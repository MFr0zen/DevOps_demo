#!/bin/bash
set -euxo pipefail

dnf install -y docker cronie awscli
systemctl enable --now docker
systemctl enable --now crond
usermod -aG docker ec2-user

# Create deploy script
cat << 'EOF' > /usr/local/bin/deploy.sh
#!/bin/bash
set -e

REGION="${region}"
ECR_REPO="${ecr_repo_url}"
CONTAINER_NAME="my-devOps-app"
PORT=${app_port}
image_tag_name=${image_tag}

# github build_tag
TAG=$(/usr/bin/aws ssm get-parameter \
    --name "$image_tag_name" \
    --query "Parameter.Value" \
    --output text)

echo "Deploying version: $TAG"

# Login to ECR
aws ecr get-login-password --region $REGION \
| docker login --username AWS --password-stdin $ECR_REPO

# Pull latest image
docker pull $ECR_REPO:$TAG

# Check running container
docker stop "$CONTAINER_NAME" || true
docker rm "$CONTAINER_NAME" || true

# Run new container
docker run -d \
    --name $CONTAINER_NAME \
    --restart unless-stopped \
    -p $PORT:$PORT \
    $ECR_REPO:$TAG
EOF

chmod +x /usr/local/bin/deploy.sh

# Create systemd service
cat << 'EOF' > /etc/systemd/system/myapp.service
[Unit]
Description=My devops demo app
After=docker.service
Requires=docker.service

[Service]
ExecStart=/usr/local/bin/deploy.sh
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create cron job
cat << 'EOF' > /etc/cron.d/myapp-deploy
    */2 * * * * root /usr/local/bin/deploy.sh >> /var/log/deploy.log 2>&1
EOF

# Correct permissions
chmod 644 /etc/cron.d/myapp-deploy

systemctl daemon-reload
systemctl enable --now myapp
