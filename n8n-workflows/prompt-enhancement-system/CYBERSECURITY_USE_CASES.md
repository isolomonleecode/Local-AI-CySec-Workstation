# Cybersecurity Use Cases - Prompt Enhancement System

## Overview

This document demonstrates real-world cybersecurity scenarios where the prompt enhancement system transforms basic requests into production-ready, comprehensive prompts across four domains:

1. **Threat Modeling**
2. **Incident Response**
3. **Penetration Testing**
4. **Compliance Audit**

Each use case includes:
- **Original Prompt**: Basic user input
- **Workflow Selection**: Which variant to use and why
- **Expected Output**: What the system produces
- **How to Use**: Practical application of enhanced prompts
- **Success Metrics**: How to measure effectiveness

---

## Use Case 1: Cloud Migration Threat Model

### Scenario
Your organization is migrating a customer-facing web application from on-premises infrastructure to AWS. The application handles customer PII and payment data. Security leadership needs a comprehensive threat model before proceeding.

### Original Prompt
```
Create a threat model for migrating our web app to AWS.
```

### Workflow Selection
**Use:** Variant C (Deep Analysis)

**Why:**
- Multi-stakeholder decision (security, engineering, business)
- High-impact project requiring balanced perspectives
- Compliance implications (PCI DSS, GDPR)
- Need both security-first and business-aligned viewpoints

### API Call
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-deep \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a comprehensive threat model for migrating a customer-facing web application handling PII and payment data from on-premises infrastructure to AWS cloud. Application stack: React frontend, Node.js API, PostgreSQL database. Current security: firewall, WAF, database encryption at rest. Target AWS services: ECS Fargate, RDS, ALB, S3. Must maintain PCI DSS compliance."
  }'
```

### Expected Enhanced Output (Example)

**Security-First Variant:**
```
System Prompt:
You are a cloud security architect specializing in threat modeling for cloud migrations. Apply STRIDE methodology and map threats to MITRE ATT&CK cloud tactics. Prioritize data protection, compliance requirements (PCI DSS, GDPR), and AWS-specific attack vectors.

User Prompt:
Conduct a comprehensive threat model for the following cloud migration:

**System Description:**
- Current: On-premises web application (React + Node.js + PostgreSQL)
- Handles: Customer PII, payment card data (PCI DSS scope)
- Target: AWS ECS Fargate, RDS, ALB, S3
- Security: Current firewall/WAF, DB encryption; AWS equivalent needed

**Requirements:**
1. STRIDE analysis for each trust boundary crossing (Internet → ALB, ALB → ECS, ECS → RDS, etc.)
2. Map threats to MITRE ATT&CK cloud tactics (Initial Access, Credential Access, Lateral Movement, Exfiltration)
3. Identify PCI DSS control gaps during migration
4. AWS-specific threats: S3 misconfigurations, IAM privilege escalation, VPC security groups, encryption key management
5. Data flow diagram with trust boundaries clearly marked
6. Risk prioritization matrix (Likelihood x Impact)
7. Recommended AWS security controls (WAF, GuardDuty, CloudTrail, KMS, Secrets Manager)

**Output Format:**
- Executive summary (business risk in non-technical terms)
- STRIDE threat enumeration table
- Data flow diagram (text description or PlantUML/Mermaid code)
- Risk matrix with HIGH priority threats first
- Control recommendations mapped to specific threats
- PCI DSS gap analysis (current vs. AWS implementation)
```

**Business-Aligned Variant:**
```
System Prompt:
You are a cloud transformation consultant balancing security, cost, and time-to-market for cloud migrations. Consider business objectives, regulatory compliance, and stakeholder concerns while maintaining pragmatic security posture.

User Prompt:
Create an executive-friendly threat assessment for our AWS cloud migration:

**Business Context:**
- Goal: Improve scalability, reduce infrastructure costs by 30%, enable faster feature deployment
- Timeline: 6-month migration, Q2 2025 go-live
- Stakeholders: CTO (cost savings), CISO (security/compliance), VP Engineering (agility)
- Compliance: Must maintain PCI DSS Level 1, GDPR

**Migration Scope:**
- Application: Customer portal (React, Node.js, PostgreSQL)
- Data: 500K customer records, 1M+ payment transactions annually
- Current security: Physical DC security, network firewalls, DB encryption
- Target: AWS ECS Fargate, RDS, ALB, S3

**Assessment Requirements:**
1. Top 5 business risks of migration (revenue impact, compliance violations, reputation damage)
2. Security controls required to maintain compliance (PCI DSS, GDPR)
3. Cost-effective AWS security services (balance protection vs. budget)
4. Migration phases with security validation gates
5. Stakeholder communication plan (technical vs. executive audiences)
6. Success criteria: security posture maintained or improved, compliance status, cost targets

**Output Format:**
- 1-page executive summary (board-level language)
- Business risk matrix (High/Medium/Low with $ impact estimates)
- Security roadmap aligned to migration phases
- Compliance checklist (PCI DSS requirements in cloud)
- Stakeholder RACI matrix
```

### How to Use the Enhanced Prompts

1. **Security Team Review:**
   - Run the **security-first variant** through your LLM (qwen3-30b)
   - Use output to create formal threat model documentation
   - Present STRIDE analysis and risk matrix to security leadership

2. **Executive Presentation:**
   - Run the **business-aligned variant** through your LLM
   - Extract 1-page summary for C-level stakeholders
   - Use business risk matrix to justify security budget

3. **Engineering Planning:**
   - Run the **performance-optimized variant** (from Deep Analysis output)
   - Focus on AWS service configurations and technical controls
   - Create implementation tasks in sprint planning

4. **Comprehensive Documentation:**
   - Run the **holistic variant** for complete documentation
   - Includes security, business, and technical perspectives
   - Archive for compliance audits and future reference

### Success Metrics

- **Completeness**: All trust boundaries identified and analyzed
- **Compliance**: PCI DSS and GDPR requirements mapped to AWS controls
- **Actionability**: Specific AWS services and configurations recommended (not generic advice)
- **Stakeholder Satisfaction**: Security, engineering, and business teams find value in their respective variants
- **Risk Reduction**: High-priority threats have mitigation plans before migration

---

## Use Case 2: Ransomware Incident Response Playbook

### Scenario
Your organization experienced a near-miss with ransomware (detected by EDR before encryption). Security operations needs an incident response playbook for future ransomware attacks, including containment, eradication, recovery, and communication procedures.

### Original Prompt
```
Write an incident response playbook for ransomware.
```

### Workflow Selection
**Use:** Variant A (Full Pipeline)

**Why:**
- Well-defined problem (ransomware playbook)
- Need comprehensive 7-stage analysis
- Single audience (security operations team)
- Production documentation required

### API Call
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a detailed incident response playbook for ransomware attacks targeting our Windows enterprise environment (500 endpoints, Active Directory, file servers, cloud backups). Include NIST 800-61 lifecycle phases, technical procedures for containment/eradication/recovery, communication templates, and lessons learned. We have EDR (CrowdStrike), SIEM (Splunk), offline backups (Veeam), and cyber insurance ($1M coverage with breach coach)."
  }'
```

### Expected Enhanced Output (Example)

**Precision Variant** (Recommended for formal playbook documentation):
```
System Prompt:
You are a senior incident response consultant specializing in ransomware attacks. Create a comprehensive, step-by-step incident response playbook following NIST SP 800-61 lifecycle. Include specific technical commands, communication templates, decision trees, and forensic evidence collection procedures. Prioritize business continuity while preserving evidence for legal/insurance purposes.

User Prompt:
Develop a production-ready ransomware incident response playbook:

**Environment Details:**
- 500 Windows endpoints (Windows 10/11)
- Active Directory domain with 50 servers
- File servers: 10TB shared drives
- Backups: Veeam (hourly snapshots, 30-day retention, offline storage)
- Security tools: CrowdStrike Falcon EDR, Splunk SIEM, Microsoft Defender
- Cyber insurance: $1M coverage with breach coach firm

**Playbook Structure (NIST 800-61 Lifecycle):**

**1. PREPARATION**
- Pre-incident checklist: Verify backups, test recovery procedures, update contact lists
- Required tools: Forensic laptop, Faraday bags, USB with portable tools (FTK Imager, Wireshark)
- Team roles: Incident Commander, Technical Lead, Communications Lead, Legal Liaison
- Escalation triggers: When to activate breach coach, when to notify FBI, when to consider paying ransom (policy)

**2. DETECTION & ANALYSIS**
- Detection indicators: CrowdStrike alerts, mass file renaming, ransom notes, unexplained encryption
- Triage procedure:
  a. Verify alert legitimacy (rule out false positive)
  b. Identify ransomware variant (ransom note, file extensions, ID Ransomware tool)
  c. Determine scope: How many systems encrypted? When did encryption start?
  d. Assess backup status: Are backups intact and offline?
- Severity classification: SEV1 (active encryption), SEV2 (contained but systems encrypted), SEV3 (prevented by EDR)
- Forensic collection: Memory dumps, disk images, network PCAPs, EDR telemetry

**3. CONTAINMENT**
Short-term containment (immediate):
  1. Isolate affected systems (disconnect from network, DO NOT power off)
     - CrowdStrike: `contain` command from console
     - Physical: Unplug network cable
  2. Disable compromised accounts in Active Directory
     ```powershell
     Disable-ADAccount -Identity <compromised_user>
     ```
  3. Block C2 domains/IPs at firewall and DNS
  4. Segment network to prevent lateral spread (ACLs on core switches)
  5. Preserve evidence: Create forensic images before any changes

Long-term containment:
  1. Identify root cause (phishing email, RDP brute force, software vulnerability)
  2. Block attack vector organization-wide
  3. Force password reset for all privileged accounts
  4. Enable enhanced logging on critical systems

**4. ERADICATION**
  1. Identify persistence mechanisms:
     - Scheduled tasks: `schtasks /query /fo LIST /v`
     - Registry Run keys: `reg query HKLM\\Software\\Microsoft\\Windows\\CurrentVersion\\Run`
     - Services: `sc query` and look for suspicious services
  2. Remove malware and persistence from ALL systems (not just encrypted ones)
  3. Patch vulnerabilities exploited in initial access
  4. Rebuild compromised domain controllers from known-good backups
  5. Reset krbtgt password twice (to invalidate all Kerberos tickets)

**5. RECOVERY**
  1. Verify backups are clean (scan for malware before restore)
  2. Restore from most recent clean backup (test small subset first)
  3. Phased restoration priority:
     - Phase 1: Domain controllers, DNS, DHCP
     - Phase 2: Critical business systems (email, ERP, file servers)
     - Phase 3: Workstations
  4. Monitor restored systems for 72 hours for re-infection
  5. Validate data integrity and application functionality

**6. POST-INCIDENT ACTIVITY (Lessons Learned)**
  - Conduct hot wash within 48 hours of recovery
  - Root cause analysis: How did attacker gain initial access? How did they escalate privileges?
  - Process improvements: What worked? What failed? How can we detect faster next time?
  - Technical improvements: New security controls, architecture changes, backup enhancements
  - Document timeline, costs, and business impact metrics (MTTD, MTTR, downtime)

**COMMUNICATION TEMPLATES:**

Internal:
  - Subject: [CRITICAL] Security Incident - Ransomware Detected
  - Body: Ransomware detected on [X] systems. IT is responding. Do not click unknown links or open attachments. Report suspicious activity to security@company.com.

Executive:
  - Status: Active incident, [X] systems affected, recovery in progress
  - Impact: [X hours] estimated downtime, [Y] business functions impacted
  - Actions: Containment complete, restoration from backups underway
  - Estimated resolution: [Timeline]
  - Costs: [Forensics, restoration, potential ransom - do not pay unless approved by CEO + breach coach]

Cyber Insurance:
  - Policy number: [X]
  - Incident date/time: [UTC timestamp]
  - Systems affected: [Count and description]
  - Forensic firm engaged: [Name]
  - Estimated loss: [Business interruption + forensics + restoration]

**DECISION TREE: To Pay or Not to Pay Ransom?**
  - Default: DO NOT PAY (funds criminal activity, no guarantee of decryption, may violate OFAC sanctions)
  - Consider only if:
    1. Backups completely destroyed or encrypted
    2. Business-critical data permanently lost
    3. Breach coach and legal counsel approve
    4. Ransomware variant has proven decryption success rate (check No More Ransom project first)
    5. CEO/Board approval obtained
    6. Payment does not violate OFAC sanctions (check ransomware group against SDN list)

**TOOLS AND COMMANDS:**
  - Identify ransomware: https://id-ransomware.malwarehunterteam.com/
  - Check for free decryptors: https://www.nomoreransom.org/
  - Active Directory account disable: `Disable-ADAccount -Identity <user>`
  - Kerberos ticket purge: Reset krbtgt password twice, 24 hours apart
  - Network isolation: `netsh advfirewall set allprofiles state on` + block all inbound
  - Memory dump: FTK Imager → Capture Memory
  - Disk image: FTK Imager → Create Disk Image (E01 format)
```

### How to Use This Playbook

1. **Immediate Response (During Incident):**
   - Follow Detection & Analysis section to triage
   - Execute Containment procedures immediately
   - Use communication templates to notify stakeholders

2. **Eradication & Recovery:**
   - Follow step-by-step procedures in sequence
   - Check off each step as completed (use printed checklist)
   - Document all actions with timestamps in incident log

3. **Post-Incident:**
   - Schedule lessons learned meeting within 48 hours
   - Update playbook based on what worked/didn't work
   - Implement technical improvements identified

4. **Regular Testing:**
   - Quarterly tabletop exercises using this playbook
   - Annual ransomware simulation (safe test environment)
   - Update playbook as environment changes

### Success Metrics

- **MTTD (Mean Time To Detect)**: <30 minutes from initial encryption to alert
- **MTTR (Mean Time To Recover)**: <24 hours from containment to restored operations
- **Containment Effectiveness**: Ransomware spread limited to <10 systems
- **Backup Success Rate**: 100% of critical data recoverable from backups
- **Communication Timeliness**: Executives notified within 1 hour, all-company alert within 2 hours
- **Lessons Learned**: Concrete improvements implemented within 30 days post-incident

---

## Use Case 3: Web Application Penetration Test Scoping

### Scenario
You're a penetration tester scoping a web application security assessment for a financial services client. They have a customer portal with account management, fund transfers, and document uploads. You need to create a comprehensive scope document, rules of engagement, and deliverables outline.

### Original Prompt
```
Create a pentest scope for a banking web app.
```

### Workflow Selection
**Use:** Variant B (Fast Track)

**Why:**
- Well-understood task (pentesting is a standardized process)
- Time-sensitive (client needs scope document for approval tomorrow)
- Standard deliverables (ROE, scope, timeline)
- Fast turnaround more important than deep analysis

### API Call
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-fast \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Create a penetration testing scope document for a financial services customer portal. Features: user authentication (MFA), account balance viewing, fund transfers, bill payments, document upload (statements), admin panel. Tech stack: Angular frontend, Java Spring Boot API, MySQL database, hosted on AWS. Client wants OWASP Top 10 coverage, no DoS testing, business hours only, 40 hours of testing. Deliverables: technical report, executive summary, re-test after remediation."
  }'
```

### Expected Enhanced Output (Example)

**Precision Variant** (Recommended for client-facing scope document):
```
System Prompt:
You are a professional penetration tester creating a scope of work document for a web application security assessment. Follow PTES methodology and OWASP Testing Guide. Create a clear, client-friendly document covering scope, methodology, rules of engagement, timeline, and deliverables. Address legal concerns (authorization, data handling, responsible disclosure).

User Prompt:
Create a comprehensive penetration testing scope document:

**CLIENT INFORMATION:**
- Organization: [Financial Services Client]
- Application: Customer Portal (account management, transfers, bill pay, document upload)
- Technology Stack:
  - Frontend: Angular (TypeScript)
  - Backend API: Java Spring Boot (RESTful)
  - Database: MySQL 8.0
  - Hosting: AWS (EC2, RDS, S3, CloudFront CDN)
- Authentication: Username/password + MFA (SMS, authenticator app)
- Users: 50,000 active customers
- Admin Panel: Separate interface for customer service representatives

**TESTING OBJECTIVES:**
1. Identify and validate security vulnerabilities in web application
2. Assess authentication and authorization controls
3. Evaluate sensitive data handling (account numbers, SSNs, transaction history)
4. Test for OWASP Top 10 2021 vulnerabilities
5. Review API security (REST endpoints, authentication tokens)
6. Assess admin panel security (privilege escalation, access controls)

**SCOPE OF TESTING:**

In-Scope:
- Customer portal (https://portal.client.com)
- API endpoints (https://api.client.com/v1/*)
- Admin panel (https://admin.client.com)
- Mobile API (if accessed via web proxy)
- Document upload/download functionality
- Payment processing workflow (up to final confirmation, NO actual fund transfers)

Out-of-Scope:
- Third-party integrations (payment gateways, credit bureaus)
- Physical security testing
- Social engineering or phishing attacks
- Denial-of-service testing
- Production database (use staging environment)
- Actual fund transfers or account modifications
- Any systems not explicitly listed above

**TESTING METHODOLOGY:**
Following OWASP Web Security Testing Guide and PTES:

1. **Reconnaissance (4 hours)**
   - Application mapping and technology fingerprinting
   - User role identification (customer, admin, guest)
   - Entry point enumeration (all forms, API endpoints, file uploads)

2. **Vulnerability Scanning (4 hours)**
   - Automated scanning (Burp Suite Professional, OWASP ZAP)
   - Review scan results and eliminate false positives

3. **Manual Testing (24 hours)**
   - Authentication & Session Management:
     * Password policy testing
     * MFA bypass attempts
     * Session fixation and hijacking
     * Cookie security (HttpOnly, Secure, SameSite flags)

   - Authorization & Access Control:
     * Horizontal privilege escalation (access other users' accounts)
     * Vertical privilege escalation (customer → admin)
     * IDOR (Insecure Direct Object Reference) in account/transaction IDs

   - Input Validation:
     * SQL injection (login forms, search, filters)
     * Cross-Site Scripting (XSS) - reflected, stored, DOM-based
     * XML External Entity (XXE) injection
     * Server-Side Request Forgery (SSRF)

   - Business Logic:
     * Transaction manipulation (negative amounts, race conditions)
     * Workflow bypass (skip MFA, approval steps)
     * Price/amount manipulation

   - File Upload:
     * Malicious file upload (web shells, XXE via SVG)
     * Path traversal in file downloads
     * Unrestricted file upload

   - API Security:
     * Mass assignment vulnerabilities
     * Rate limiting and brute force protection
     * API authentication bypass
     * Excessive data exposure

4. **Exploitation & Impact Validation (6 hours)**
   - Proof-of-concept development for critical findings
   - Impact assessment (data exposure, account takeover scenarios)

5. **Reporting (2 hours)**
   - Technical report compilation
   - Executive summary creation

**RULES OF ENGAGEMENT:**

Authorization:
- Written authorization letter required before testing begins
- Authorized personnel: [Tester Name], [Company]
- Authorized testing window: [Date range]

Acceptable Techniques:
- Automated vulnerability scanning with rate limiting (max 10 req/sec)
- Manual testing and exploitation of identified vulnerabilities
- Credential testing using provided test accounts ONLY
- Proof-of-concept exploits demonstrating impact (no data destruction)

Prohibited Actions:
- Denial-of-service attacks or resource exhaustion
- Data modification, deletion, or corruption
- Testing of out-of-scope systems
- Brute force attacks against authentication (unless specific permission granted)
- Access to production customer data (use test accounts only)
- Actual fund transfers or financial transactions

Testing Window:
- Allowed hours: Monday-Friday, 9 AM - 5 PM EST (business hours only)
- No testing on weekends or holidays without prior approval

Communication:
- Daily brief status updates via email
- Immediate notification for critical vulnerabilities (CVSS 9.0+)
- Emergency contact: [Client CISO Phone Number] (if testing causes unintended impact)

Data Handling:
- All findings and evidence treated as confidential
- Secure deletion of all client data within 30 days of project completion
- No disclosure to third parties without written consent

**TIMELINE:**
- Week 1: Reconnaissance, scanning, initial manual testing
- Week 2: Deep-dive manual testing, exploitation, validation
- Week 3: Report writing, client review, re-test planning
- Total effort: 40 hours over 3 weeks

**DELIVERABLES:**

1. **Technical Report** (delivered Day 15)
   - Executive summary (1-2 pages, business risk language)
   - Methodology overview
   - Detailed findings with:
     * Vulnerability description
     * CVSS v3 score and severity
     * Affected components/endpoints
     * Proof-of-concept steps and screenshots
     * Business impact assessment
     * Remediation recommendations (specific, actionable)
     * References (OWASP, CWE, CVE)
   - Appendices: Testing scope, tools used, test accounts

2. **Executive Summary** (PowerPoint, delivered Day 15)
   - High-level overview for C-level executives
   - Key findings summary (critical and high only)
   - Business risk assessment
   - Remediation roadmap with priorities

3. **Re-test Validation Report** (delivered 30 days after remediation)
   - Verification testing for all findings
   - Updated status (Fixed, Partially Fixed, Not Fixed)
   - Residual risk assessment

**TESTING ACCOUNTS:**
Client to provide:
- 3 customer accounts (different privilege levels)
- 1 admin account (customer service representative)
- Test credit card numbers for payment testing (no real transactions)
- Access to staging environment that mirrors production

**ASSUMPTIONS:**
- Staging environment accurately represents production
- Test accounts have same privileges as real user accounts
- Client will provide network access (VPN if needed)
- Client has backups and can restore if unintended impact occurs

**EXCLUSIONS:**
- This assessment does NOT include:
  * Mobile application testing (native iOS/Android apps)
  * Infrastructure/network penetration testing
  * Source code review
  * Cloud configuration review (AWS security)
  * Compliance assessment (PCI DSS, SOC 2)

**ACCEPTANCE CRITERIA:**
- All in-scope URLs and API endpoints tested
- OWASP Top 10 2021 coverage achieved
- Critical and high vulnerabilities validated with proof-of-concept
- Report meets client's documentation requirements
- Re-test scheduled within 60 days of initial report delivery

**LEGAL & COMPLIANCE:**
- Tester liability limited to gross negligence
- Client responsible for backups and restoration
- No warranty on completeness (point-in-time assessment)
- Findings remain confidential and client-owned
```

### How to Use This Scope Document

1. **Client Approval:**
   - Send to client for review and signature
   - Address any questions or scope changes
   - Obtain signed authorization letter before testing

2. **Pre-Engagement:**
   - Request test accounts and VPN access
   - Schedule kickoff call to confirm testing window
   - Verify emergency contact information

3. **During Testing:**
   - Follow Rules of Engagement strictly
   - Document all testing activities with timestamps
   - Notify client immediately of critical findings

4. **Reporting:**
   - Use scope as framework for report structure
   - Ensure all in-scope areas are addressed
   - Provide actionable remediation guidance

### Success Metrics

- **Coverage**: 100% of in-scope URLs and API endpoints tested
- **Vulnerability Detection**: All OWASP Top 10 categories assessed
- **No Incidents**: Zero unintended outages or data corruption during testing
- **Client Satisfaction**: Scope clearly defines boundaries, no surprises
- **Actionability**: All findings include specific remediation steps, not generic advice
- **Re-test Success**: >80% of findings remediated within 30 days

---

## Use Case 4: SOC 2 Type II Compliance Gap Analysis

### Scenario
Your SaaS company is pursuing SOC 2 Type II certification for the first time. You need to conduct a gap analysis against the Trust Services Criteria (Security, Availability) to identify control deficiencies and create a remediation roadmap before the formal audit in 6 months.

### Original Prompt
```
Do a SOC 2 compliance gap analysis for our SaaS platform.
```

### Workflow Selection
**Use:** Variant A (Full Pipeline)

**Why:**
- Complex compliance framework (detailed analysis needed)
- Multiple control domains (organizational, technical, physical)
- Need for remediation roadmap with priorities
- Formal documentation required for audit preparation

### API Call
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -H "Content-Type: application/json" \
  -d '{
    "prompt": "Conduct a SOC 2 Type II gap analysis for our SaaS customer relationship management platform (500 customers, $5M ARR, 50 employees, AWS-hosted). We are pursuing Security and Availability TSCs. Current state: Basic security policies, AWS default configurations, Google Workspace for email, GitHub for code, PagerDuty for incidents. No formal change management, access reviews are ad-hoc, no vendor risk assessments. Audit scheduled in 6 months. Need prioritized remediation roadmap with effort estimates."
  }'
```

### Expected Enhanced Output (Example)

**Balanced Variant** (Recommended for practical implementation):
```
System Prompt:
You are a SOC 2 compliance consultant conducting a gap analysis for a SaaS organization. Apply the Trust Services Criteria framework and identify specific control deficiencies. Provide a realistic, prioritized remediation roadmap with effort estimates. Balance audit requirements with practical implementation constraints (budget, timeline, staffing).

User Prompt:
Conduct a comprehensive SOC 2 Type II gap analysis and create a 6-month remediation roadmap:

**ORGANIZATION PROFILE:**
- Company: SaaS CRM platform
- Customers: 500 businesses (B2B SaaS)
- ARR: $5 million
- Employees: 50 (10 engineering, 5 IT/security, 35 sales/support/admin)
- Infrastructure: AWS-hosted (EC2, RDS, S3, Route 53, CloudFront)
- Tech Stack: React, Node.js, PostgreSQL
- Current tools: Google Workspace, GitHub, Slack, PagerDuty, AWS native monitoring

**AUDIT SCOPE:**
- Trust Service Categories: Security (CC) + Availability (A)
- Audit Type: SOC 2 Type II (12 months of evidence required)
- Audit Timeline: Readiness assessment in 3 months, formal audit in 6 months

**CURRENT STATE ASSESSMENT:**

Policies & Procedures:
- Information Security Policy (v1.0, last updated 2 years ago, not reviewed)
- Acceptable Use Policy (basic, no acknowledgment process)
- No documented: Change Management, Incident Response, Business Continuity, Vendor Risk Management

Access Controls:
- User provisioning: Manual (IT tickets)
- Deprovisioning: Manual, no checklist, average 3-5 days after termination
- Access reviews: Ad-hoc, no documented process
- MFA: Enabled for Google Workspace and AWS console, not enforced for GitHub
- Privileged access: 8 employees have AWS root account access (shared credentials)

Change Management:
- Code changes: GitHub PRs required, but no approval workflow, no testing requirements documented
- Infrastructure changes: AWS console access for 12 engineers, no approval process, no change log
- No rollback procedures documented

Monitoring & Logging:
- Application logs: CloudWatch Logs (30-day retention)
- AWS CloudTrail: Enabled but not monitored, no alerts configured
- No SIEM or centralized log management
- PagerDuty for uptime alerts only (no security alerts)

Incident Response:
- No formal incident response plan
- No security incident classification or escalation procedures
- Incidents handled via Slack, no tracking or documentation

Vendor Management:
- No vendor risk assessments
- No review of subservice organization SOC 2 reports
- Critical vendors: AWS (no SOC 2 review), Stripe (payment processing, no review), Twilio (SMS, no review)

Backup & Recovery:
- RDS automated backups (7-day retention)
- No disaster recovery plan
- No backup restoration testing
- No documented RTO/RPO

**GAP ANALYSIS BY CONTROL DOMAIN:**

**Common Criteria (CC) - Security**

| Control ID | Control Requirement | Current State | Gap | Risk | Remediation Effort |
|------------|---------------------|---------------|-----|------|-------------------|
| CC1.1 | COSO principles established | No governance structure | No board oversight, no risk committee | HIGH | Medium (4-6 weeks) |
| CC2.1 | Outsourced service providers monitored | No vendor assessments | AWS, Stripe, Twilio not assessed | HIGH | Low (2 weeks) |
| CC3.1 | Risk assessment process | No formal process | No risk register, no annual assessment | HIGH | Medium (4 weeks) |
| CC6.1 | Logical access controls | Partial implementation | No access review process, privileged access not restricted | CRITICAL | High (8 weeks) |
| CC6.6 | Vulnerabilities identified and addressed | No process | No vuln scanning, no patch management | CRITICAL | High (8-12 weeks) |
| CC7.2 | System monitoring | Minimal monitoring | No security monitoring, no SIEM | HIGH | High (10-12 weeks) |
| CC8.1 | Change management | No formal process | No approval workflow, no testing requirements | CRITICAL | Medium (6 weeks) |
| CC9.1 | Risk mitigation activities identified | No documentation | No risk treatment plans | MEDIUM | Low (2 weeks) |

**Availability (A)**

| Control ID | Control Requirement | Current State | Gap | Risk | Remediation Effort |
|------------|---------------------|---------------|-----|------|-------------------|
| A1.1 | Capacity planning | Ad-hoc | No capacity monitoring or forecasting | MEDIUM | Low (2 weeks) |
| A1.2 | Environmental protections | AWS responsibility | Reliance on AWS, no verification | LOW | Low (1 week - review AWS SOC 2) |
| A1.3 | Backups and recovery | Partial | No DR plan, no testing | HIGH | Medium (4-6 weeks) |

**PRIORITIZED REMEDIATION ROADMAP (6 Months):**

**Phase 1 (Months 1-2): Critical Controls - Audit Blockers**

Priority: CRITICAL - These controls are mandatory for SOC 2 and pose immediate audit risk.

1. **Implement Formal Access Review Process (CC6.1)**
   - Effort: 2 weeks
   - Actions:
     * Document access review procedure (quarterly reviews)
     * Create access review template (spreadsheet: User → Systems → Role → Business Justification → Approved By)
     * Conduct initial access review for all 50 employees
     * Remove 6 unnecessary AWS root account accesses (keep 2)
     * Implement least privilege: Remove admin rights where not needed
   - Evidence: Access review reports (Q1, Q2, Q3, Q4 for 12-month period)
   - Owner: IT Manager

2. **Establish Change Management Process (CC8.1)**
   - Effort: 4 weeks
   - Actions:
     * Document change management policy and procedures
     * Implement approval workflow in GitHub (require 1 approval for production PRs)
     * Create infrastructure change request form (for AWS changes)
     * Require production change approvals from CTO or Engineering Manager
     * Document rollback procedures for applications and infrastructure
     * Create change calendar (track all production changes)
   - Evidence: Approved change requests, change logs, rollback procedures
   - Owner: CTO

3. **Implement Vulnerability Management (CC6.6)**
   - Effort: 6 weeks
   - Actions:
     * Deploy Tenable.io or AWS Inspector for vulnerability scanning
     * Configure weekly automated scans of all AWS EC2 instances and containers
     * Define remediation SLAs: Critical (7 days), High (30 days), Medium (90 days)
     * Create vulnerability tracking board (Jira or GitHub Issues)
     * Patch 3 critical vulnerabilities identified in initial scan
   - Evidence: Scan reports, remediation tracking, before/after comparisons
   - Owner: Security Engineer

4. **Conduct Vendor Risk Assessments (CC2.1)**
   - Effort: 2 weeks
   - Actions:
     * Identify all critical vendors (AWS, Stripe, Twilio, GitHub, Google)
     * Obtain and review SOC 2 reports for each vendor
     * Document vendor risk assessment with questionnaire
     * Create vendor inventory with risk ratings
     * Schedule annual vendor review process
   - Evidence: SOC 2 reports, vendor risk assessments, vendor inventory
   - Owner: Compliance Manager

**Phase 2 (Months 3-4): High Priority - Security Foundations**

5. **Deploy Security Monitoring & SIEM (CC7.2)**
   - Effort: 8 weeks
   - Actions:
     * Select SIEM solution (options: Splunk Cloud, Sumo Logic, AWS Security Hub + CloudWatch Insights)
     * Integrate AWS CloudTrail, application logs, VPC Flow Logs
     * Create alerting rules for security events:
       - Failed login attempts (10+ in 5 minutes)
       - Privilege escalation (IAM policy changes)
       - Unauthorized API calls
       - Large data transfers (potential exfiltration)
     * Configure PagerDuty integration for critical security alerts
     * Document incident detection and alert response procedures
   - Evidence: SIEM configuration, alert rules, incident detection logs
   - Owner: Security Engineer + DevOps

6. **Develop Incident Response Plan (CC7.3)**
   - Effort: 3 weeks
   - Actions:
     * Create Incident Response Policy and Procedures (based on NIST 800-61)
     * Define incident severity levels (SEV1-4) with escalation triggers
     * Document incident response team roles and contact information
     * Create communication templates (internal, customer, executive)
     * Conduct tabletop exercise to test IRP
     * Implement incident tracking system (Jira Service Management or PagerDuty)
   - Evidence: IRP documentation, tabletop exercise report, incident logs
   - Owner: CISO / Security Lead

7. **Implement Business Continuity and Disaster Recovery Plan (A1.3)**
   - Effort: 4 weeks
   - Actions:
     * Document RTO (Recovery Time Objective): 4 hours
     * Document RPO (Recovery Point Objective): 1 hour
     * Create disaster recovery runbook for AWS infrastructure
     * Configure RDS backups to 30-day retention (increase from 7)
     * Implement S3 versioning and lifecycle policies for critical data
     * Conduct DR test: Restore from backup in separate AWS region
     * Document lessons learned and update runbook
   - Evidence: DR plan, backup configurations, DR test report
   - Owner: DevOps Lead

**Phase 3 (Months 5-6): Medium Priority - Governance & Documentation**

8. **Establish Information Security Governance (CC1.1)**
   - Effort: 4 weeks
   - Actions:
     * Create Security Committee (CTO, CISO, CFO, Legal)
     * Define committee charter and responsibilities
     * Schedule quarterly security committee meetings
     * Conduct first meeting: Review risk register, approve policies, review metrics
     * Document minutes and action items
   - Evidence: Committee charter, meeting minutes (3 quarterly meetings before audit)
   - Owner: CISO

9. **Conduct Formal Risk Assessment (CC3.1)**
   - Effort: 3 weeks
   - Actions:
     * Create risk assessment methodology (NIST 800-30 or FAIR)
     * Identify assets, threats, and vulnerabilities
     * Assess likelihood and impact (risk matrix)
     * Create risk register with treatment plans (mitigate, accept, transfer, avoid)
     * Present risk register to Security Committee for approval
     * Schedule annual risk assessment cycle
   - Evidence: Risk assessment report, risk register, Security Committee approval
   - Owner: CISO + Compliance Manager

10. **Update and Approve Policies (CC1.2, CC1.3)**
    - Effort: 3 weeks
    - Actions:
      * Update Information Security Policy (last updated 2 years ago)
      * Create new policies:
        - Change Management Policy
        - Incident Response Policy
        - Business Continuity Policy
        - Vendor Risk Management Policy
        - Data Classification and Handling Policy
      * Obtain executive approval (CEO/CTO signature)
      * Distribute policies to all employees
      * Require acknowledgment via Google Forms (track completion)
      * Schedule annual policy review cycle
    - Evidence: Approved policies, employee acknowledgment records
    - Owner: Compliance Manager

**EFFORT SUMMARY:**
- Total Effort: ~34 weeks of work across 6 months (feasible with dedicated resources)
- Team Required:
  * 1 full-time Compliance Manager (can be consultant)
  * 1 Security Engineer (0.5 FTE, existing staff)
  * 1 DevOps Lead (0.25 FTE, existing staff)
  * CTO/CISO oversight (0.25 FTE)

**BUDGET ESTIMATE:**
- SIEM solution: $15K-25K/year
- Vulnerability scanning: $5K-10K/year
- Compliance consultant: $25K-40K (6-month engagement)
- SOC 2 audit fees: $15K-25K (Type II)
- Training and certifications: $5K
- **Total: $65K-105K**

**TIMELINE TO READINESS:**
- Month 3: Readiness self-assessment (internal review)
- Month 4-5: Address any gaps identified in readiness review
- Month 6: Formal SOC 2 Type II audit begins
- Month 9: Audit report issued (assuming no significant findings)

**SUCCESS CRITERIA:**
- ✅ All CRITICAL and HIGH gaps remediated before audit
- ✅ 12 months of evidence collected for Type II audit
- ✅ No significant deficiencies identified in audit
- ✅ SOC 2 report issued with unqualified opinion
- ✅ Sales team can use SOC 2 report for enterprise deals

**ONGOING COMPLIANCE (Post-Audit):**
- Quarterly access reviews
- Monthly vulnerability scans with remediation tracking
- Quarterly Security Committee meetings
- Annual policy reviews and updates
- Annual risk assessments
- Continuous evidence collection for next year's surveillance audit
```

### How to Use This Gap Analysis

1. **Executive Buy-In:**
   - Present effort summary and budget estimate to leadership
   - Obtain approval for budget and resource allocation
   - Assign ownership for each remediation task

2. **Project Management:**
   - Create project plan in Jira/Asana with all 10 remediation tasks
   - Assign owners and set deadlines based on phase timeline
   - Weekly status meetings to track progress

3. **Evidence Collection:**
   - Create shared folder for SOC 2 evidence (Google Drive or SharePoint)
   - Organize by control ID (e.g., "CC6.1 - Access Reviews/")
   - Document everything (screenshots, approvals, meeting minutes)

4. **Pre-Audit Readiness:**
   - Month 3: Conduct internal readiness assessment using this gap analysis
   - Verify all CRITICAL and HIGH items are completed
   - Confirm 12 months of evidence available for each control

### Success Metrics

- **Gap Closure Rate**: 100% of CRITICAL gaps closed by Month 6
- **Evidence Quality**: All controls have documented policies + 12 months of operational evidence
- **Audit Outcome**: Zero significant deficiencies in final SOC 2 report
- **Business Impact**: SOC 2 badge on website, unlocks 3+ enterprise deals ($500K+ ARR)
- **Compliance Sustainability**: Ongoing process embedded in operations (not just point-in-time audit prep)

---

## Cross-Domain Use Case: Secure SDLC Implementation

### Scenario
Your development team wants to implement a secure software development lifecycle (SDLC) incorporating threat modeling, security testing, and compliance checks. This spans multiple domains: threat modeling (design phase), penetration testing (testing phase), and compliance (audit readiness).

### Multi-Workflow Approach

**Step 1: Threat Modeling (Use Variant A)**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -d '{"prompt": "Create a threat modeling process for our SDLC design phase. New features should have STRIDE analysis before development. Use JIRA for tracking threats. Output: threat model template and JIRA workflow."}'
```

**Step 2: Security Testing (Use Variant B - Fast)**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt-fast \
  -d '{"prompt": "Define security testing requirements for CI/CD pipeline. Include SAST, DAST, dependency scanning. Gate deployments on critical vulnerabilities. Tools: GitHub Actions, Snyk, OWASP ZAP."}'
```

**Step 3: Compliance Documentation (Use Variant A)**
```bash
curl -X POST http://192.168.0.52:5678/webhook/enhance-prompt \
  -d '{"prompt": "Create security documentation templates for SOC 2 compliance. Developers need to document: data classification, encryption, access controls, logging. Integrate with GitHub PRs."}'
```

This demonstrates how to chain multiple enhanced prompts to build a comprehensive secure SDLC program.

---

## Tips for Maximum Value

### 1. **Be Specific in Original Prompts**
- ❌ Bad: "Create a threat model"
- ✅ Good: "Create a STRIDE-based threat model for our payment API handling credit cards, hosted on AWS ECS, with PCI DSS requirements"

The more context you provide, the better the enhancement.

### 2. **Choose the Right Workflow Variant**
- **Fast Track (B)**: Simple, standardized tasks under time pressure
- **Full Pipeline (A)**: Production documentation, comprehensive analysis
- **Deep Analysis (C)**: Multi-stakeholder projects, strategic decisions

### 3. **Iterate on Outputs**
- Use the enhanced prompt to generate output from your LLM
- If output quality is low, adjust the enhanced prompt (not the original)
- Feed successful prompts back into the system for further refinement

### 4. **Leverage Domain Libraries**
- Include domain keywords in your input to trigger relevant expertise
- Examples: "STRIDE", "NIST 800-61", "OWASP Top 10", "PCI DSS"

### 5. **Track Metrics**
- Measure time saved (manual prompt engineering vs automated enhancement)
- Track output quality (did enhanced prompt achieve the goal?)
- Monitor usage patterns (which workflow variant is most popular?)

---

## Conclusion

The Prompt Enhancement System transforms basic cybersecurity requests into production-ready, domain-aware prompts across:
- **Threat Modeling**: STRIDE analysis, MITRE ATT&CK mapping, risk prioritization
- **Incident Response**: NIST 800-61 lifecycle, playbook procedures, communication templates
- **Penetration Testing**: PTES methodology, scope documents, rules of engagement
- **Compliance Audit**: Framework mapping, gap analysis, remediation roadmaps

By leveraging the appropriate workflow variant and domain-specific libraries, security professionals can dramatically accelerate documentation, analysis, and implementation tasks while maintaining high quality and compliance standards.

---

**Document Version:** 1.0.0
**Last Updated:** 2025-12-10
**Related Documents:** IMPLEMENTATION_GUIDE.md, Domain Library JSON Files
