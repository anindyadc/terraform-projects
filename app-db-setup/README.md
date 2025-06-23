### 🧩 Components in the Diagram:

* **VPC**
* **Public Subnet**

  * ✅ 2 × EC2 instances (App Servers)
  * ✅ Application Load Balancer
  * ✅ NAT Gateway
* **Private Subnet**

  * ✅ 1 × EC2 instance (DB Server)
* **Internet Gateway**
* **Routing**

  * ALB → App instances
  * App → DB (internal traffic)
  * DB → internet via NAT (for updates)

---


