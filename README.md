🚀 📕 **EKS Terraform Deployment – Full Project Presentation**

---

📖 **Title: Building a Scalable EKS Infrastructure with Terraform**

*“A journey from zero to a production-ready Kubernetes platform”*

---

📘 **Table of Contents**

1. 📌 **Project Overview**
2. 🔥 **Terraform Modules Used**
3. 🏗️ **Infrastructure Provisioned**
4. 🔐 **IAM Roles and Policies**
5. 🌐 **Networking: VPC and Subnets**
6. ☸️ **EKS Cluster Deployment**
7. 🖥️ **Worker Nodes & Node Groups**
8. 📦 **Services Deployed in Kubernetes**
9. 📊 **Architecture Diagram**
10. 🎯 **Key Benefits**
11. 📝 **Challenges & Resolutions**
12. ✅ **Final Validation**
13. 🚀 **Next Steps for Production**
14. 📢 **Summary & Manager Takeaways**

---

📌 **1. Project Overview**

We provisioned an **Amazon EKS (Elastic Kubernetes Service)** cluster using **Terraform** for full Infrastructure-as-Code (IaC).

This setup enables:
✅ Rapid EKS provisioning
✅ Scalable worker nodes with Managed Node Groups
✅ A secure, highly available network
✅ Out-of-the-box Kubernetes workloads

---

🔥 **2. Terraform Modules Used**

| Module                        | Purpose                             |
| ----------------------------- | ----------------------------------- |
| terraform-aws-modules/vpc/aws | Creates VPC, subnets, route tables  |
| terraform-aws-modules/eks/aws | Provisions EKS cluster & nodegroups |
| Terraform AWS Provider        | Manages AWS resources               |

---

🏗️ **3. Infrastructure Provisioned**

✅ **VPC** – Fully isolated network
✅ **Subnets** – Public & Private, AZ-spread
✅ **EKS Cluster** – Control plane for Kubernetes
✅ **Managed Node Groups** – EC2 nodes auto-managed by EKS
✅ **IAM Roles & Policies** – For control plane, nodes, and CNI plugin
✅ **Elastic Load Balancers (ELBs)** – For Kubernetes Services of type LoadBalancer
✅ **Security Groups** – For cluster communication & public access

---

🔐 **4. IAM Roles and Policies**

Terraform automatically created:

* EKS Cluster IAM Role with:

  * `AmazonEKSClusterPolicy`
* Node Group IAM Role with:

  * `AmazonEKSWorkerNodePolicy`
  * `AmazonEKS_CNI_Policy`
  * `AmazonEC2ContainerRegistryReadOnly`
* Additional inline policies for CNI network interfaces.

---

🌐 **5. Networking: VPC and Subnets**

| Resource        | Details                          |
| --------------- | -------------------------------- |
| VPC             | CIDR: `10.0.0.0/16`              |
| Public Subnets  | `10.0.101.0/24`, `10.0.102.0/24` |
| Private Subnets | `10.0.1.0/24`, `10.0.2.0/24`     |
| NAT Gateway     | Single NAT for private subnets   |
| Route Tables    | Configured for public/private    |

---

☸️ **6. EKS Cluster Deployment**

* **Kubernetes Version:** 1.29
* **Endpoint Access:** Public
* **Authentication:** IAM user (`demo-user`) added as `system:masters`
* Managed Node Groups created using:

  * **Instance type:** t3.medium
  * **Desired capacity:** 2 nodes
  * **Scaling:** Min=2, Max=2

---

🖥️ **7. Worker Nodes & Node Groups**

* EC2 instances automatically provisioned.
* IAM role attached with required permissions.
* Nodes successfully registered with the cluster (`kubectl get nodes` shows Ready).

---

📦 **8. Services Deployed in Kubernetes**

We deployed:
✅ **hello-node** (echoserver) – Validated LoadBalancer Service
✅ **nginx-app** – Tested with browser-friendly UI
✅ Automatic creation of:

* 2 CoreDNS pods
* kube-proxy DaemonSet
* aws-node DaemonSet (VPC CNI plugin)

---

📊 **9. Architecture Diagram**

```
           Internet
               │
        +--------------+
        |  AWS ELB     |
        +--------------+
               │
         ┌──────────────┐
         │ EKS Cluster  │
         └──────────────┘
           │         │
+----------------+ +----------------+
| Worker Node 1  | | Worker Node 2   |
| t3.medium EC2  | | t3.medium EC2   |
+----------------+ +----------------+
           │
      +-----------+
      | Kubernetes|
      | Services  |
      +-----------+
```

---

🎯 **10. Key Benefits**

* 🚀 **Fast Deployment** – Full cluster in minutes
* 🔐 **Security** – IAM roles & least privilege policies
* ☸️ **Scalable** – Managed Node Groups with autoscaling
* 📦 **Reusable** – Clean Terraform code, modular design

---

📝 **11. Challenges & Resolutions**

| Challenge                           | Resolution                                 |
| ----------------------------------- | ------------------------------------------ |
| Node Group stuck creating           | Fixed IAM role policies and subnet tagging |
| CNI plugin failing                  | Added inline policy for EC2 network APIs   |
| Extra nodes after multiple applies  | Adjusted desired\_capacity in Terraform    |
| LoadBalancer service not responding | Corrected targetPort in Service definition |

---

✅ **12. Final Validation**

Commands run:

```bash
kubectl get nodes
kubectl get pods -A
kubectl get svc
```

✅ All nodes Ready
✅ CoreDNS Running
✅ Services accessible via ELB

---

🚀 **13. Next Steps for Production**

* Setup Ingress Controller (e.g., AWS ALB Ingress)
* Enable Cluster Autoscaler and HPA
* Implement CI/CD (ArgoCD or FluxCD)
* Add monitoring stack (Prometheus + Grafana)
* Setup log aggregation (EKS Control Plane logs → CloudWatch)

---

📢 **14. Summary & Manager Takeaways**

This Terraform project:
✅ Delivers a **scalable, secure, production-grade EKS cluster**
✅ Empowers teams to deploy workloads faster
✅ Fully reproducible and compliant with IaC best practices

