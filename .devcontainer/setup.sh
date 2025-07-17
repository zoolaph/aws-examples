#!/bin/bash

# Install AWS CLI
echo "Installing AWS CLI..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
rm -rf aws awscliv2.zip

# Update package list and enable universe repo
sudo apt-get update
sudo apt-get install -y software-properties-common
sudo add-apt-repository universe
sudo apt-get update

# Install Ruby
sudo apt-get install -y ruby-full
aws --version

# Configure AWS credentials (Optional: Set up default profile)
if [[ -n "$AWS_ACCESS_KEY_ID" && -n "$AWS_SECRET_ACCESS_KEY" ]]; then
    echo "Configuring AWS credentials..."
    mkdir -p ~/.aws
    cat <<EOF > ~/.aws/credentials
[default]
AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID
AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY
EOF
    chmod 600 ~/.aws/credentials
fi

echo "Setup complete."
