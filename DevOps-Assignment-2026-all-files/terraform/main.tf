/*
# main.tf

# 1. Define the Cloud Provider (AWS)
provider "aws" {
  region = "us-east-1"
}

# 2. Create a Security Group (The Firewall)
# INTENTIONAL VULNERABILITY: This allows SSH from ANYWHERE [cite: 24]
resource "aws_security_group" "web_sg" {
  name        = "devops-assignment-sg"
  description = "Security group for web server"

  # INBOUND RULES (Who can enter)
  
  # !!! VULNERABILITY HERE !!!
  # Port 22 (SSH) is open to 0.0.0.0/0 (The entire internet)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  # Allow HTTP traffic (Port 5000 for your Flask App)
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUND RULES (Who can leave - Allow everything)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Create the Server (EC2 Instance)
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS (Free Tier Eligible in us-east-1)
  instance_type = "t2.micro"              # Free Tier Eligible [cite: 20]
  
  # Attach the security group we created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  tags = {
    Name = "EmoCare-DevOps-Assignment"
  }
  
  # Simple script to install Docker on startup (User Data)
  user_data = <<-EOF
              #!/bin/bash
              sudo apt-get update
              sudo apt-get install -y docker.io
              sudo systemctl start docker
              EOF
}
*/

# main.tf

# 1. Define the Cloud Provider (AWS)
provider "aws" {
  region = "us-east-1"
}

# 2. Create a Security Group (The Firewall)
resource "aws_security_group" "web_sg" {
  name        = "devops-assignment-sg-secure"
  description = "Secured Security group for web server"

  # INBOUND RULES (Who can enter)
  
  # FIX: AVD-AWS-0107 (SSH restricted to private network or specific IP)
  # Replaced 0.0.0.0/0 with a restricted range.
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/8"] 
  }

  # Allow HTTP traffic (Port 5000 for your Flask App)
  # Keeping this open is standard for a public web server
  ingress {
    from_port   = 5000
    to_port     = 5000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # OUTBOUND RULES
  # Note regarding AVD-AWS-0104: We keep egress open to allow 'apt-get' updates.
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 3. Create the Server (EC2 Instance)
resource "aws_instance" "web_server" {
  ami           = "ami-0c7217cdde317cfec" # Ubuntu 22.04 LTS
  instance_type = "t3.micro"              # Free Tier Eligible [cite: 20]
  
  # Attach the security group we created above
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  # FIX: AVD-AWS-0028 (Require IMDSv2 Tokens)
  metadata_options {
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  # FIX: AVD-AWS-0131 (Encrypt Root Volume)
  root_block_device {
    encrypted = true
  }

  tags = {
    Name = "EmoCare-DevOps-Assignment-Secure"
  }
  
  user_data = <<-EOF
              
              sudo apt-get update
              sudo apt-get install -y docker.io git

              # 2. Start Docker
              sudo systemctl start docker
              sudo systemctl enable docker

              cd /home/ubuntu
              # Cloning the repo 
              git clone https://github.com/rayanubhav/DevOps-Assignment-GET-2026.git app_repo

              # 4. Build the Docker Image
              cd app_repo
              # Note: Your files are inside a subfolder, so we cd into it
              cd DevOps-Assignment-2026-all-files
              
              # Build the image named 'emocare-app'
              sudo docker build -t emocare-app .

              # 5. Run the Container
              # Map port 5000 on server to port 5000 in container
              sudo docker run -d -p 5000:5000 --name emocare-running emocare-app
              EOF
}