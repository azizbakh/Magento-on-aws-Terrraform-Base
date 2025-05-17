#!/bin/bash

# === Update & Install Dependencies ===
yum update -y
amazon-linux-extras enable php8.0
yum install -y php php-cli php-mysqlnd php-pdo php-xml php-gd php-mbstring php-bcmath php-json php-intl php-opcache php-curl php-soap
yum install -y nginx mysql amazon-efs-utils nfs-utils git unzip policycoreutils-python-utils

# === Configure EFS ===
mkdir -p /mnt/efs
mount -t efs ${efs_id}:/ /mnt/efs

# === Create Magento Directory ===
mkdir -p /var/www/magento
chown -R ec2-user:ec2-user /var/www/magento
ln -s /mnt/efs /var/www/magento/pub/media

# === Set Environment Variables ===
cat <<EOF >> /etc/environment
DB_HOST=${db_endpoint}
REDIS_HOST=${redis_host}
ES_HOST=${es_host}
MAGENTO_MODE=production
EOF

# === Install Composer ===
cd /tmp
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer

# === Install Magento (simplifié) ===
cd /var/www/magento
sudo -u ec2-user composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

# === Setup Permissions ===
find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} +
chown -R ec2-user:ec2-user .

# === Setup NGINX ===
systemctl enable nginx
systemctl start nginx

# === Magento Setup (Optional) ===
# sudo -u ec2-user bin/magento setup:install \
# --base-url=http://$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)/ \
# --db-host=${db_endpoint} \
# --db-name=magentodb \
# --db-user=magento \
# --db-password=yourpassword \
# --admin-firstname=Admin \
# --admin-lastname=User \
# --admin-email=admin@example.com \
# --admin-user=admin \
# --admin-password=Admin123 \
# --language=en_US \
# --currency=USD \
# --timezone=UTC \
# --use-rewrites=1

# === Enable Magento Crons ===
# sudo -u ec2-user bin/magento cron:install

# === Final Service Restart ===
systemctl restart php-fpm
systemctl restart nginx
