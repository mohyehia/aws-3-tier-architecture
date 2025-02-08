#!/bin/bash
yum update -y
yum install git -y
yum install -y java-17-amazon-corretto-headless
yum install maven -y

#Forward port 80 traffic to port 8085
yum install iptables -y
iptables -t nat -I PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8085

git clone https://github.com/mohyehia/aws-3-tier-architecture.git

export spring_profiles_active=dev
export DB_URL=jdbc:postgresql://{rds_endpoint}:5432/postgres
export DB_USERNAME={rds_username}
export DB_PASSWORD={rds_password}

cd aws-3-tier-architecture/backend/spring-boot-api ||return

mvn clean package

cd target ||return

java -jar spring-boot-api-0.0.1-SNAPSHOT.jar &