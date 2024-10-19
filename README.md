# AWS VPC and Web Application Infrastructure

This Terraform configuration sets up a VPC with public subnets, EC2 instances running Nginx, and an Application Load Balancer (ALB) on AWS.

## Infrastructure Overview

This Terraform code creates the following resources:

- VPC with DNS support and hostnames enabled
- Two public subnets in different Availability Zones
- Internet Gateway
- Route table for public subnets
- Security group for EC2 instances (allowing HTTP and SSH access)
- Security group for ALB
- Two EC2 instances running Nginx
- Application Load Balancer
- Target group for the ALB
- Listener for the ALB

## Prerequisites

- AWS CLI configured with appropriate credentials
- Terraform installed (version 0.12 or later)
- An AWS key pair for SSH access to EC2 instances

## Usage

1. Clone this repository:

git clone <repository-url>
cd <repository-directory>

2. Initialize Terraform:

terraform init

3. Review and modify the `variables.tf` file to set appropriate values for your environment.

4. (Optional) Create a `terraform.tfvars` file to set variable values:

vpc_cidr = "10.0.0.0/16"
vpc_name = "my-vpc"
aws_region = "us-west-2"

Add other variables as needed

5. Review the planned changes:

terraform plan

6. Apply the Terraform configuration:

terraform apply

7. After the apply completes, Terraform will output the DNS name of the Application Load Balancer. You can use this to access your web application.

## Accessing the Web Application

Once the infrastructure is set up, you can access the web application by entering the ALB DNS name in a web browser. The ALB will distribute traffic between the two Nginx instances.

## SSH Access

To SSH into the EC2 instances, use the key pair specified in the Terraform configuration and the public IP of the instance. For example:

ssh -i /path/to/your/key.pem ec2-user@<instance-public-ip>

Note: Replace `ec2-user` with the appropriate username for your AMI if you're not using Amazon Linux 2.

## Clean Up

To destroy the created resources and avoid unnecessary AWS charges, run:

terraform destroy

Review the planned destruction carefully before confirming.

## Security Considerations

- The current configuration allows SSH access from a specific IP address. Ensure this is set correctly in the security group.
- HTTP access is allowed from anywhere. Consider restricting this in production environments.
- The ALB is internet-facing. Ensure this is appropriate for your use case.
- Consider enabling HTTPS and using AWS Certificate Manager for production deployments.

## Customization

You can customize this configuration by modifying the Terraform files. Common customizations include:

- Changing instance types
- Adding more EC2 instances
- Configuring auto-scaling
- Adding additional security group rules
- Modifying the Nginx configuration in the user data script

## Troubleshooting

If you encounter issues:

1. Ensure your AWS CLI is configured correctly.
2. Check that you have the necessary permissions in your AWS account.
3. Verify that the specified key pair exists in the AWS region you're using.
4. Review the Terraform and AWS provider versions for compatibility.

For more detailed errors, run `terraform apply` with the `-debug` flag.

## Contributing

Contributions to improve the configuration are welcome. Please submit a pull request or open an issue to discuss proposed changes.

## License

[Specify your license here]

This README provides a comprehensive overview of the infrastructure, instructions for using the Terraform configuration, and important considerations for security and customization. You may want to adjust some parts to better fit your specific use case or add more details about your particular setup.

Remember to replace placeholders like <repository-url>, <repository-directory>, and the license information with your actual details. 
