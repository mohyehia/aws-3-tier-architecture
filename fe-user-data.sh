#!/bin/bash
yum update -y
yum install git -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd

git clone https://github.com/mohyehia/aws-3-tier-architecture.git

cd aws-3-tier-architecture/frontend

mv index.html /var/www/html

# Restart Apache to apply changes
systemctl restart httpd
