#!/bin/bash
# GPU Metrics Collection Script for Prometheus
# Collects AMD GPU metrics using rocm-smi from LocalAI container
# Output format: Prometheus text file format

set -e

# Textfile collector directory (mount this in node-exporter)
TEXTFILE_DIR="${TEXTFILE_DIR:-/var/lib/node_exporter/textfile_collector}"
OUTPUT_FILE="${TEXTFILE_DIR}/gpu_metrics.prom"
TEMP_FILE="${OUTPUT_FILE}.$$"

# LocalAI container name
LOCALAI_CONTAINER="${LOCALAI_CONTAINER:-local-ai}"

# Function to get GPU metrics from rocm-smi
collect_metrics() {
    # Run rocm-smi in LocalAI container and parse output
    docker exec "$LOCALAI_CONTAINER" rocm-smi --showmeminfo vram --json 2>/dev/null || {
        echo "# ERROR: Failed to query rocm-smi" >&2
        return 1
    }
}

# Parse rocm-smi JSON output and convert to Prometheus format
parse_metrics() {
    local json_output="$1"

    # Extract VRAM used and total (in bytes)
    # rocm-smi returns memory in MB, convert to bytes
    local vram_used_mb=$(echo "$json_output" | jq -r '.card0."VRAM Total Used Memory (B)"' 2>/dev/null | awk '{print $1/1024/1024}')
    local vram_total_mb=$(echo "$json_output" | jq -r '.card0."VRAM Total Memory (B)"' 2>/dev/null | awk '{print $1/1024/1024}')

    # If jq parsing fails, try simpler rocm-smi output
    if [ -z "$vram_used_mb" ] || [ "$vram_used_mb" = "null" ]; then
        # Fallback: parse simpler rocm-smi output
        local simple_output=$(docker exec "$LOCALAI_CONTAINER" rocm-smi --showmeminfo vram 2>/dev/null)
        vram_used_mb=$(echo "$simple_output" | grep "VRAM Total Used Memory" | awk '{print $6}')
        vram_total_mb=$(echo "$simple_output" | grep "VRAM Total Memory" | awk '{print $5}')
    fi

    # Convert MB to bytes
    local vram_used_bytes=$((${vram_used_mb%.*} * 1024 * 1024))
    local vram_total_bytes=$((${vram_total_mb%.*} * 1024 * 1024))
    local vram_free_bytes=$((vram_total_bytes - vram_used_bytes))

    # Output Prometheus metrics
    cat <<EOF
# HELP amd_gpu_memory_used_bytes GPU memory currently in use (bytes)
# TYPE amd_gpu_memory_used_bytes gauge
amd_gpu_memory_used_bytes{gpu="0",model="AMD_Radeon_RX_6900_XT"} ${vram_used_bytes}

# HELP amd_gpu_memory_total_bytes Total GPU memory available (bytes)
# TYPE amd_gpu_memory_total_bytes gauge
amd_gpu_memory_total_bytes{gpu="0",model="AMD_Radeon_RX_6900_XT"} ${vram_total_bytes}

# HELP amd_gpu_memory_free_bytes GPU memory currently free (bytes)
# TYPE amd_gpu_memory_free_bytes gauge
amd_gpu_memory_free_bytes{gpu="0",model="AMD_Radeon_RX_6900_XT"} ${vram_free_bytes}

# HELP amd_gpu_memory_usage_ratio GPU memory usage ratio (0.0 to 1.0)
# TYPE amd_gpu_memory_usage_ratio gauge
amd_gpu_memory_usage_ratio{gpu="0",model="AMD_Radeon_RX_6900_XT"} $(awk "BEGIN {printf \"%.4f\", ${vram_used_bytes} / ${vram_total_bytes}}")
EOF
}

# Main execution
main() {
    # Check if LocalAI container is running
    if ! docker ps --format '{{.Names}}' | grep -q "^${LOCALAI_CONTAINER}$"; then
        echo "# ERROR: LocalAI container '${LOCALAI_CONTAINER}' is not running" >&2
        exit 1
    fi

    # Collect metrics
    local metrics_json=$(collect_metrics)

    # Parse and write to temp file
    parse_metrics "$metrics_json" > "$TEMP_FILE"

    # Atomic move to final location
    mv "$TEMP_FILE" "$OUTPUT_FILE"

    # Optional: log success
    # echo "$(date): GPU metrics collected successfully" >> /var/log/gpu-metrics.log
}

# Run main function
main "$@"
