# === CONFIGURATION ===
PROJECT_NAME := magento
TF_VAR_FILE  := terraform.tfvars
BACKEND_DIR  := .
TF           := terraform

# === COMMANDES ===

init:
	@echo "👉 Initialisation de Terraform..."
	cd $(BACKEND_DIR) && $(TF) init

validate:
	@echo "🔍 Validation de la configuration..."
	cd $(BACKEND_DIR) && $(TF) validate

plan:
	@echo "📐 Planification du déploiement..."
	cd $(BACKEND_DIR) && $(TF) plan -var-file=$(TF_VAR_FILE)

apply:
	@echo "🚀 Déploiement de l’infrastructure..."
	cd $(BACKEND_DIR) && $(TF) apply -var-file=$(TF_VAR_FILE) -auto-approve

destroy:
	@echo "💣 Destruction de l’infrastructure..."
	cd $(BACKEND_DIR) && $(TF) destroy -var-file=$(TF_VAR_FILE) -auto-approve

fmt:
	@echo "🧹 Formatage des fichiers Terraform..."
	cd $(BACKEND_DIR) && $(TF) fmt -recursive

# === AIDE ===

help:
	@echo ""
	@echo "🛠️  Commandes Make disponibles :"
	@echo "   make init      - Initialiser Terraform (backend S3/DynamoDB)"
	@echo "   make validate  - Valider la configuration"
	@echo "   make plan      - Générer le plan de déploiement"
	@echo "   make apply     - Appliquer la configuration"
	@echo "   make destroy   - Supprimer toute l'infrastructure"
	@echo "   make fmt       - Formater les fichiers Terraform"
	@echo ""
