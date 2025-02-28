# aws-3-tier-architecture

### Created Resources from AWS Console
- VPC
- 2 Public Subnets
  - CIDR => `10.0.0.0/24` & `10.0.1.0/24`
- 2 Private Subnets for Application Layer
  - CIDR => `10.0.16.0/20` & `10.0.32.0/20`
- 2 Private Subnets for Database Layer
  - CIDR => `10.0.48.0/20` & `10.0.64.0/20`
- 2 Route Tables
  - 1 public for public subnets association and to add route to the internet gateway
  - 1 private for private subnets association
- Internet Gateway
  - Attach it to the VPC
  - Add route to the Internet Gateway from the public route table
- Create 3 security groups
  - `fe-security-group` => allows ssh access & http access for all
  - `be-security-group` => allows ssh access & http access from only the `fe-security-group`
  - `db-security-group` => allows postgresql access from only the `be-security-group`
- RDS
  - Create DB subnet group inside the `eu-west-1a` & `eu-west-1b` AZs
  - Choose the subnets `db-private-subnet-a` & `db-private-subnet-b`
  - Create Postgresql database named `demo-db` and initial database name `social_db`
- NAT Gateway
  - Create nat gateway at the public subnet `public-subnet-a`
  - Modify the private route table to include a route for the nat gateway
- Auto Scaling Group
  - Create auto-scaling group at the private subnet `private-subnet-a` & `private-subnet-b` for the application layer
  - Create a new application load balancer
  - Attach the application load balancer to the auto-scaling group
  - Create a target group and attach it to the application load balancer
  - For the security group make sure that the load balancer is using the correct one, not the default

### References
- [AWS 3 Tier Architecture](https://towardsaws.com/aws-3-tier-architecture-63997b69ebc0)
- [Building a 3-tier web application architecture with AWS](https://medium.com/@aaloktrivedi/building-a-3-tier-web-application-architecture-with-aws-eb5981613e30)