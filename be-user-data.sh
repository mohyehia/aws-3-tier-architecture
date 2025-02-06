#!/bin/bash
yum update -y
yum install git -y
yum install -y java-17-amazon-corretto-headless
yum install maven -y
git clone https://github.com/mohyehia/aws-3-tier-architecture.git

cd aws-3-tier-architecture/backend/spring-boot-api ||return

mvn clean package

cd target ||return

java -jar spring-boot-api-0.0.1-SNAPSHOT.jar