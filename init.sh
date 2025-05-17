#!/bin/bash

# === CONFIGURATION ===
REGION="eu-west-3"
BUCKET_NAME="magento-terraform-state-prod"
DYNAMO_TABLE="terraform-locks"
PROFILE="default"  # Profil AWS CLI (optionnel)

# === 1. Créer le bucket S3 ===
echo "📦 Vérification/création du bucket S3: $BUCKET_NAME"
if aws s3api head-bucket --bucket "$BUCKET_NAME" --profile "$PROFILE" 2>/dev/null; then
  echo "✅ Bucket S3 déjà existant."
else
  aws s3api create-bucket \
    --bucket "$BUCKET_NAME" \
    --region "$REGION" \
    --create-bucket-configuration LocationConstraint="$REGION" \
    --profile "$PROFILE"
  echo "✅ Bucket S3 créé avec succès."

  aws s3api put-bucket-versioning \
    --bucket "$BUCKET_NAME" \
    --versioning-configuration Status=Enabled \
    --profile "$PROFILE"
  echo "🔐 Versioning activé sur le bucket."
fi

# === 2. Créer la table DynamoDB pour le state locking ===
echo "🔐 Vérification/création de la table DynamoDB: $DYNAMO_TABLE"
if aws dynamodb describe-table --table-name "$DYNAMO_TABLE" --region "$REGION" --profile "$PROFILE" 2>/dev/null; then
  echo "✅ Table DynamoDB déjà existante."
else
  aws dynamodb create-table \
    --table-name "$DYNAMO_TABLE" \
    --attribute-definitions AttributeName=LockID,AttributeType=S \
    --key-schema AttributeName=LockID,KeyType=HASH \
    --provisioned-throughput ReadCapacityUnits=1,WriteCapacityUnits=1 \
    --region "$REGION" \
    --profile "$PROFILE"
  echo "✅ Table DynamoDB créée avec succès."
fi

# === 3. Initialiser Terraform ===
echo "🚀 Initialisation Terraform avec backend S3/DynamoDB..."
terraform init

echo "🎉 Terraform est prêt à l'emploi !"
