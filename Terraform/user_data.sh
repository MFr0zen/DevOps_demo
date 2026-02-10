#!/bin/bash
dnf install docker -y
systemctl start docker
systemctl enable docker
usermod -aG docker ec2-user


# github build_tag
TAG=$(/usr/bin/aws ssm get-parameter \
  --name "${image_tags_name}" \
  --query "Parameter.Value" \
  --output text)

echo "Deploying version: $TAG"


aws ecr get-login-password --region ${region} \
| docker login --username AWS --password-stdin ${ecr_repo_url}

docker pull ${ecr_repo_url}:$TAG

docker run -d \
  -p ${app_port}:${app_port} \
  --restart unless-stopped \
  ${ecr_repo_url}:$TAG


#!/bin/bash
dnf install docker cronie -y
systemctl start docker
systemctl enable docker
systemctl start crond
systemctl enable crond

# Create deploy script
cat << 'EOF' > /usr/local/bin/deploy.sh
./deploy.sh
EOF

chmod +x /usr/local/bin/deploy.sh

# Create systemd service
cat << 'EOF' > /etc/systemd/system/myapp.service
./myapp.service
EOF

# Create cron job
cat << 'EOF' > /etc/cron.d/myapp-deploy
*/2 * * * * root /usr/local/bin/deploy.sh >> /var/log/deploy.log 2>&1
EOF

# Correct permissions
chmod 644 /etc/cron.d/myapp-deploy

systemctl daemon-reexec
systemctl enable myapp
systemctl start myapp
