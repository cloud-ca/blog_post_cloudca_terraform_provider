# cloud.ca Terraform provider example

This configuration shows a deployment on cloud.ca with:
- a web network
- a database network
- a tools network

The number of web instances and database instances is configurable.
If the environment is intended to be for production workloads, set the
variable `is_production` to true and the ACLs for the networks will be
more strict:
- SSH access is allowed only from the instance in the tools network (except for the tools instance itself)
- The database port is blocked on the database network, except for the IPs of the web instances

## How to use

- generate ssh keys, with `ssh-keygen -t rsa -b 4096 -N "" -f ./id_rsa` for example
- create a file terraform.tfvars containing at least the following variables:
  - `api_key`: your cloud.ca API key
  - `organization_code`: name used to connect to cloud.ca - \<organization_code>.cloud.ca
  - `service_code`: `compute-qc` or `compute-on`
  - `environment_name`: production, dev for example
  - `admin`: a list of users in your organization who will have the `Environment Admin` role
  - `read_only`: a list of users in your organization who wil have the `Read Only` role
  - `frontend_count`: number of instances in the web network
  - `backend_count`: number of instances in the database network
  - `is_production`: set to true for production, false otherwise
