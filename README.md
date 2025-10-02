# Transaction API Service


# Part 1 Deployment

## Overview
This repository contains the infrastructure and Kubernetes deployment configurations for the **Transaction API Service**. The deployment is designed for **high availability** and **scalability**, using Kubernetes and ArgoCD for GitOps-based management.

---

## Architecture
- **Kubernetes Cluster**: Hosted on GCP.  
- **Application**: Transaction API service deployed in its own namespace.  
- **Database**: PostgreSQL deployed via a **self-managed Helm chart**.  
- **GitOps Deployment**: ArgoCD manages the deployment of all manifests.  
- **High Availability**:  
  - Multi-zone node pools within a single region  
  - Pod anti-affinity rules to prevent multiple replicas from running in the same zone  
  - StatefulSet for PostgreSQL ensures persistent data and HA  

---

## Features
- Automated deployment using **ArgoCD**  
- **Self-healing and scalable** application  
- **Automatic scaling** based on load (Horizontal Pod Autoscaler for Transaction API)  
- Secure database credentials managed through Kubernetes **Secrets**  
- Infrastructure defined as **Terraform modules** for reproducibility  

---

## Prerequisites
- Kubernetes cluster with `kubectl` access  
- ArgoCD installed and accessible  
- Helm installed for deploying PostgreSQL  
- Terraform installed for infrastructure provisioning  
- Git repository containing the deployment manifests  

---

## Deployment Steps

### 1. Infrastructure
1. Configure Terraform variables (`terraform.tfvars`) with project ID, region, cluster node sizes, and repository information.  
2. Deploy infrastructure:
   ```bash
   terraform init
   terraform apply
    ```

 GKE cluster is created with multi-zone node pools.

3. Database

- Deploy via Argocd, helm chart are in ***arogocd/app/transaction-db****
- Configure database credentials via Kubernetes Secrets.

4. Application Deployment

- Deploy via Argocd, helm chart are in ***arogocd/app/transaction-api****
- Added the Git repository to ArgoCD:
- Created the Argocd application using argocd-cd-apps in addons folder.
- Application pods will be automatically created in the transaction-api-testnet namespace.

5. Configuration & Secrets

- Database URL is injected into Transaction API pods via Secrets:
- DATABASE_URL=postgresql://<user>:<password>@transaction-db:5432/transactions

6. Scaling & High Availability

- Horizontal Pod Autoscaler can be configured for Transaction API:
- Pod anti-affinity ensures multiple replicas do not land in the same zone.

7. Verification

- Test application endpoint: curl http://localhost:8080/health

8. Notes

- All resources are deployed using infrastructure as code.
- PostgreSQL data is persisted using StatefulSet volumes.
- The deployment is zone-resilient, and node failures in a single zone do not impact the application.

---

# Part 2: Monitoring & Reliability

## Overview   
This part focuses on setting up monitoring and reliability for the Transaction API Service. The goal is to collect metrics, monitor application and infrastructure health, and define reliability targets using Prometheus, Grafana, and Loki.

---

## Monitoring Stack

1. Prometheus: Collects metrics from the Transaction API, PostgreSQL database, and infrastructure.

2. Grafana: Visualizes metrics and logs; dashboards show real-time performance and transaction data.

3. Loki: Centralized logging for the Transaction API, integrated with Grafana for log exploration.

- Metrics Collected

## Application Performance
- API Response Times: P95 latency of HTTP requests.
- Throughput: Number of HTTP requests per second.
- Error Rate: Percentage of HTTP requests resulting in 5xx errors.

## Transaction Processing
- Transaction Success / Fail: Counts of successful and failed transactions.

## Infrastructure & Database Health

- CPU Usage: Container CPU consumption for Transaction API pods.
- Memory Usage: Resident memory consumption.
- Disk usage: Check Database disk usage

## Database Health:
Monitored via PostgreSQL metrics exposed to Prometheus.

## Grafana Dashboard
 A Grafana dashboard has been created to monitor the Transaction API service with the following panels:

- Dashboard is saved in Grafana under the name “Transaction API Monitoring”.
- Metrics are scraped by Prometheus and visualized in real-time.

## Service Level Objectives (SLOs)
# Metric	                  Target
- Transaction Success Rate	≥ 99.9%
- API P95 Latency	        ≤ 1s
- API Error Rate 	        ≤ 0.5%
- Availability	            ≥ 99.9% uptime

```Future work: Alerts can be configured using Prometheus Alerting Rules and integrated with Slack, Discord, or other notification channels we can create using prometheus rule but currently i don't have any discord or slack```


---

# Part 3: Operational Procedures

## Overview
This section explains how to operate the **Transaction API Service** in production.  
It covers **common issues, troubleshooting steps, incident response procedures, and quick problem checks** to ensure smooth operation and maintain service reliability.

---

## Common Issues and Troubleshooting

### 1. High Latency
**Problem:** API requests take longer than expected.

**How to check:**  
- Grafana dashboard: **P95 latency**, **CPU usage**, **Memory usage**  
- Database queries for slow execution

**Example:**  
- `/transactions` P95 latency > 1 second  
- CPU usage of API pods > 90%

**Fix:**  
- Scale API pods:  

```
kubectl scale deployment transaction-api --replicas=3
Optimize slow database queries
```

## 2. Database Connection Issues

**Problem:** API cannot connect to the database.

**How to check:**  
- Check database pods:
- Check database logs:

## 3. Failed Transactions

**Problem:** Transactions fail due to application errors or validation issues.

**How to check:**  

- Prometheus metric
- Loki logs for error messages

```
    Example:
    5 failed transactions in the last 5 minutes
    Logs show Insufficient balance
    Fix:
    Retry failed transactions if safe
    Fix underlying application code or validation issues
```

## 4. Pod Crashes or Restarts

**Problem:** API pods crash unexpectedly

**How to check:**  

```
    kubectl describe pod <pod-name> -n transaction-api-testnet
    kubectl logs <pod-name>
    Example:

    Pod restarted due to OOMKilled

    Fix:
    - Increase memory/CPU limits in deployment
    Restart the pod manually:
    kubectl delete pod <pod-name> -n transaction-api-testnet
```

# Incident Response Steps

- Detect: Monitor Grafana dashboards for latency spikes, error rate increases, or failed transactions
- Assess: Determine if issue is pod-level, database-level, or system-wide
- Mitigate:
    Restart failing pods
    Scale deployments if latency is high
    Fix database issues or rollback recent changes

- Confirm: Ensure metrics return to normal and transactions process successfully
- Document: Record root cause, fix applied, and update runbook


# Quick Problem Checks
Check	                   Why	                                                Example

- API Request Rate	     Detect traffic drops or spikes	                 Requests drop from 1000/s to 100/s
- API Error Rate	     Detect failing requests	                     5xx errors increase to 10%
- P95 Latency	         Detect slow endpoints	                         transactions P95 > 1s
- Transaction            Track failed transactions	                     3 fails out of 1000
- CPU/Memory Usage	     Detect resource exhaustion	                     CPU > 90%, Memory > 80%
- Recent Logs	         Identify root cause	                         Error: Insufficient balance

**Notes**
- These procedures help quickly identify and fix issues in production
- Grafana, Prometheus, and Loki provide real-time metrics and logs
- Alerts to Slack, Discord, or email can be added in the future for automatic notifications
- Regularly update this runbook as the system evolves
