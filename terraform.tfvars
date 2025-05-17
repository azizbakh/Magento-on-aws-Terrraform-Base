
# 🌐 Nom du projet (sera utilisé pour nommer les ressources)
project = "magento-prod"

# 📍 Région AWS
region = "eu-west-3" # Paris

# 🛠️ Réseau - CIDR du VPC
vpc_cidr = "10.0.0.0/16"

# 🟢 Subnets publics (pour le Load Balancer + NAT Gateway)
public_subnets = ["10.0.1.0/24", "10.0.2.0/24"]

# 🔒 Subnets privés (pour RDS, EC2 Magento, Redis, EFS, etc.)
private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

# 🌍 Zones de disponibilité AWS
availability_zones = ["eu-west-3a", "eu-west-3b"]

# 🔐 Base de données
db_user     = "admin"
db_password = "SuperSecurePass123!" # ⚠️ Change ça ! Utilise un secret manager en prod

# 💾 Instance RDS
db_instance_class    = "db.t3.medium"
db_allocated_storage = 20

# 💥 Redis
redis_node_type = "cache.t3.micro"

# 🔎 Elasticsearch (OpenSearch)
es_domain_name    = "magento-es"
es_instance_type  = "t3.small.search"
es_instance_count = 1

# 📦 Type d’instance EC2 (pour Magento)
instance_type = "t3.medium"

# 🔁 Auto Scaling
desired_capacity = 2
min_size         = 1
max_size         = 3

# 📛 Tags communs
environment = "production"
#
key_name = "my-new-key-pair"

db_name = "magentodb"

ami_id = "ami-0b198a85d03bfa122"

account_id = "686255971612"

private_subnet_ids = ["subnet-02b48ac3b36106a14", "subnet-03c795d0f3555bea5"]




