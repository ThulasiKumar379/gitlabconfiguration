#!/bin/bash

# 1. Install and configure the necessary dependencies
echo "Updating package list..."
sudo apt-get update

echo "Installing required packages..."
sudo apt-get install -y curl openssh-server ca-certificates tzdata perl
sudo apt-get install -y postfix

# 2. Add the GitLab package repository and install the package
echo "Adding GitLab package repository..."
curl https://packages.gitlab.com/install/repositories/gitlab/gitlab-ee/script.deb.sh | sudo bash

echo "Installing GitLab EE..."
sudo apt-get install -y gitlab-ee

# 3. Display login information
echo "Browse to your hostname and login with username 'root'"
echo "If a custom password was not provided during installation, a password will be generated and stored in /etc/gitlab/initial_root_password for 24 hours."
echo "Use 'sudo cat /etc/gitlab/initial_root_password' to view the password."

# 4. Configure GitLab
echo "Configuring GitLab..."
PUBLIC_IP=$(ifconfig | grep -oP '(?<=inet\s)\d+(\.\d+){3}' | head -n 1)
sudo sed -i "s|^external_url .*|external_url 'http://$PUBLIC_IP'|" /etc/gitlab/gitlab.rb

echo "Reconfiguring GitLab..."
sudo gitlab-ctl reconfigure

# 5. Enable and configure the firewall
echo "Enabling and configuring firewall..."
sudo ufw enable
sudo ufw start
sudo ufw allow http
sudo ufw allow https
sudo ufw allow OpenSSH
sudo ufw status

# Final reconfiguration
echo "Final reconfiguration..."
sudo gitlab-ctl reconfigure

echo "GitLab installation and configuration complete!"
