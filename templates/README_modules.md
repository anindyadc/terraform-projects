### ✅ `README.md` Template for a Terraform Module

# Terraform Module: EC2 Instance

This Terraform module provisions an AWS EC2 instance with basic configuration options such as AMI, instance type, security groups, and public IP association.

---

## ✨ Features

- Launches a single EC2 instance
- Supports custom key pair, tags, and instance types
- Public IP optional
- Designed for VPC + subnet inputs (modular)

---

## 📦 Usage

```hcl
module "ec2" {
  source             = "../../modules/ec2"

  ami_id             = "ami-0c02fb55956c7d316"
  instance_type      = "t2.micro"
  subnet_id          = "subnet-0123456789abcdef0"
  security_group_ids = ["sg-0123456789abcdef0"]
  key_name           = "my-keypair"
  name               = "web-server"
}
````

---

## 📥 Inputs

|Name|Description|Type|Default|Required|
|---|---|---|---|---|
|`ami_id`|AMI ID for the EC2 instance|`string`|n/a|✅ Yes|
|`instance_type`|Instance type (e.g. `t2.micro`)|`string`|`"t2.micro"`|❌ No|
|`subnet_id`|Subnet ID to launch into|`string`|n/a|✅ Yes|
|`security_group_ids`|List of security group IDs|`list(string)`|`[]`|✅ Yes|
|`key_name`|Name of the SSH key pair|`string`|n/a|✅ Yes|
|`name`|Name tag for the instance|`string`|n/a|✅ Yes|

---

## 📤 Outputs

|Name|Description|
|---|---|
|`instance_id`|ID of the EC2 instance|
|`public_ip`|Public IP address of the instance|

---

## 🛠️ Requirements

|Name|Version|
|---|---|
|terraform|>= 1.0|
|aws|>= 4.0|

---

## 📄 License

MIT – feel free to reuse with attribution.

```
> ✅ Tip: Run `terraform-docs markdown . > README.md` inside your module to auto-fill the Inputs/Outputs table.
```