# terraform-aws-internal-networking-and-storage
Build AWS infrastructure using Terraform:
- A VPC with private subnets across two Availability Zones (AZs)
- No Internet Gateway (IGW) or Public IPs
- A secure S3 bucket with encryption and lifecycle policies
- VPC endpoints for private access to AWS services

---------------------------------------------------------------------------------------------------------------
# Security Groups vs. Network ACLs

* Security Groups (SGs)
- Security Groups operate at the ENI (instance) level and act as stateful virtual firewalls.

Key characteristics:
- Stateful: If inbound traffic is allowed, the return traffic is automatically allowed.
- Attached to resources: EC2, ENIs, RDS, Lambda ENIs, etc.
- Allow rules only: You explicitly define what is permitted; everything else is implicitly denied.
- Workload‑centric: Policies follow the resource, not the subnet.

* Network ACLs (NACLs)
- Network ACLs operate at the subnet level and act as stateless packet filters.

Key characteristics:
- Stateless: Return traffic must be explicitly allowed.
- Subnet‑wide: Rules apply to all resources inside the subnet.
- Allow + deny rules: You can explicitly block traffic.
- Coarse‑grained: Useful for broad network boundaries, not per‑workload control.

* Why Security Groups Are Primary for Workload Control

Security Groups are the preferred mechanism for protecting workloads because:
- They are stateful, reducing rule complexity.
- They move with the resource, ensuring consistent enforcement.
- They allow fine‑grained, least‑privilege policies per application or microservice.
- They integrate tightly with AWS services (ALB, RDS, ECS, Lambda ENIs).
- They avoid the operational overhead of managing stateless return rules.

NACLs still matter, but they’re best used as broad subnet‑level guardrails, not as the primary enforcement layer.

---------------------------------------------------------------------------------------------------------------
# Multi‑AZ Design for High Availability

A Multi‑AZ architecture distributes resources across multiple Availability Zones within a region.

This design improves resilience by ensuring that:
- A failure in one AZ does not take down the application.
- Traffic can be routed to healthy AZs using load balancers or failover mechanisms.
- Stateful services (RDS, EFS, ElastiCache) can maintain synchronous replication across AZs.
- Infrastructure updates, patching, or AZ‑specific disruptions do not cause downtime.

Typical Multi‑AZ components:

Subnets: At least one public and one private subnet per AZ.
Load Balancers: Distribute traffic across AZs.
NAT Gateways: One per AZ for fault tolerance.
Databases: Multi‑AZ failover or cluster mode.
Route tables: Scoped per subnet to isolate and control traffic.

---------------------------------------------------------------------------------------------------------------
# Cost Optimization Considerations

Multi‑AZ architectures improve availability but can increase cost. Common optimizations include:

1. NAT Gateway Optimization
NAT Gateways are billed hourly + per GB.

Use one NAT Gateway per AZ for HA, but route each private subnet to its local NAT to avoid cross‑AZ data charges.

For dev/test, consider single‑AZ NAT or NAT instance (non‑prod only).

2. Right‑Sizing
Choose instance types based on actual CPU/memory usage.

Use AWS Compute Optimizer or CloudWatch metrics to guide sizing.

3. Autoscaling
Scale out only when needed and scale in aggressively during low traffic periods.

4. Spot Instances
Use Spot for stateless or fault‑tolerant workloads (ECS, EKS, batch jobs).

5. Storage Optimization
Use gp3 instead of gp2 for EBS.

Clean up unattached EBS volumes, snapshots, and unused ENIs.

6. Load Balancer Efficiency
Use ALB instead of NLB/CLB when possible.

Consolidate listeners and target groups where appropriate.

7. Data Transfer Awareness
Avoid cross‑AZ traffic where possible.

Keep compute and data stores in the same AZ for chatty workloads.