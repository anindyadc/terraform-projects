### ✅ `README.md` – VPC Module Template

# Terraform Module: VPC

This Terraform module provisions an AWS VPC with a public subnet, internet gateway, and route table.  
It is designed to be a reusable building block in AWS infrastructure.

---

## ✨ Features

- Creates a custom VPC
- Creates a public subnet
- Attaches an internet gateway
- Configures a public route table
- Outputs VPC and subnet IDs

---

## 📦 Usage

```hcl
module "vpc" {
  source               = "../../modules/vpc"

  vpc_cidr             = "10.0.0.0/16"
  public_subnet_cidr   = "10.0.1.0/24"
  availability_zone    = "us-east-1a"
  name                 = "dev"
}
````

---

## 📥 Inputs

| Name                 | Description                                          | Type     | Default | Required |
| -------------------- | ---------------------------------------------------- | -------- | ------- | -------- |
| `vpc_cidr`           | CIDR block for the VPC                               | `string` | n/a     | ✅ Yes    |
| `public_subnet_cidr` | CIDR block for the public subnet                     | `string` | n/a     | ✅ Yes    |
| `availability_zone`  | Availability zone for the subnet (e.g. `us-east-1a`) | `string` | n/a     | ✅ Yes    |
| `name`               | Name prefix for tagging resources                    | `string` | `"vpc"` | ❌ No     |

---

## 📤 Outputs

| Name        | Description                 |
| ----------- | --------------------------- |
| `vpc_id`    | The ID of the created VPC   |
| `subnet_id` | The ID of the public subnet |

---

## 🛠️ Requirements

| Name         | Version |
| ------------ | ------- |
| Terraform    | >= 1.0  |
| AWS Provider | >= 4.0  |

---

## 📄 License

MIT – feel free to use and adapt.

