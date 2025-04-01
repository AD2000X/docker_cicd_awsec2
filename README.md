# Minimalist Project Showcasing Docker, CI/CD, Flask, and AWS

This project demonstrates a complete CI/CD pipeline for deploying a minimal Flask application to AWS EC2 using Docker and GitHub Actions.

![Deployed Application](https://github.com/AD2000X/docker_cicd_awsec2/blob/main/images/successfully%20deploy.jpg)

## Project Structure

```
hello-docker-cicd-aws/
├── app.py               # Simple Flask application
├── requirements.txt     # Python dependencies
├── Dockerfile           # Container configuration
├── .github/
│   └── workflows/
│       └── deploy.yml   # GitHub Actions workflow
```

## Complete Project Execution Flow

### 1. GitHub Preparation

Create application files locally using VS Code:

- `app.py` - Main Flask application code
- `requirements.txt` - Python dependency list 
- `Dockerfile` - Containerization configuration
- `.github/workflows/deploy.yml` - CI/CD workflow definition

Push code to your GitHub repository.

### 2. AWS EC2 Setup

Create EC2 instance in AWS Console:

- Choose Amazon Linux 2023 AMI (free tier eligible)
- Select t2.micro instance type (free tier eligible)
- Create new key pair and download .pem file
- Configure security group with the following rules:
  - Allow SSH traffic from anywhere (port 22)
  - Allow HTTP traffic from the internet (port 80)
  - Allow HTTPS traffic from the internet (port 443)
- Configure storage: 8 GiB gp3 Root volume (free tier eligible)

Record important information:
- `AWS_HOST`: Your EC2 instance public IP address
- `AWS_USER`: Usually "ec2-user"
- `AWS_KEY`: Your .pem file content (complete private key)

### 3. GitHub Secrets Setup

Go to GitHub repository settings:
- Settings > Security > Actions secrets and variables > Repository secrets
- Add three secrets:
  - `AWS_HOST`: EC2 public IP
  - `AWS_USER`: ec2-user
  - `AWS_KEY`: .pem file content

### 4. AWS EC2 Initialization

Connect to EC2 instance using PowerShell:

```powershell
# AWS EC2 Connection Info (Local machine - VS Code terminal)
EC2_IP="your-ec2-ip"  # EC2 instance public IP address
KEY_PATH="C:\path\to\your-key.pem"  # Full path to SSH private key file

# Navigate to directory containing SSH key (Local machine - PowerShell)
cd "C:\path\to\directory"

# Set correct permissions for key file (Local machine - PowerShell)
icacls your-key.pem /inheritance:r
icacls your-key.pem /grant:r "${env:USERNAME}:(R)"

# Connect to EC2 instance (Local machine - PowerShell)
ssh -i "C:\path\to\your-key.pem" ec2-user@your-ec2-ip
```

Once connected to EC2, run these commands:

```bash
# Update system packages
sudo dnf update -y

# Install Docker
sudo dnf install -y docker

# Start the Docker service
sudo systemctl start docker

# Set Docker to start automatically at boot
sudo systemctl enable docker

# Add the current user to the docker group
sudo usermod -aG docker ec2-user

# Exit and reconnect to apply group changes
exit
# [Reconnect using the SSH command above]

# Verify Docker installation
docker ps

# Install Git
sudo dnf install -y git

# Clone your repository
git clone https://github.com/yourusername/your-repo.git

# Go to the project directory
cd your-repo

# Build and run the Docker container
docker build -t flask-app .
docker run -d -p 80:5000 --name flask-app flask-app
```

### 5. Automated Deployment

Make changes to GitHub repository and push to main branch:

```bash
git add .
git commit -m "trigger deploy"
git push origin main
```

GitHub Actions automatically triggers deployment workflow:
- Check out code
- Connect to EC2 via SSH
- Clone/update repository on EC2
- Build Docker image
- Run Docker container

### 6. Verification

Visit `http://<EC2_IP>` in browser to view deployed application.

## Detailed AWS EC2 Setup Guide

1. Launch Instances
2. Set Instance Name
3. User Name: ec2-user
4. Application and OS Images: Amazon Linux 2023 AMI
5. Architecture: 64-bit(x86)
6. Instance type: t2.micro (free tier eligible)
7. Key pair(login): Create new key pair, download and save it
8. Network setting:
   - Create security group
   - Allow SSH traffic from anywhere (0.0.0.0/0)
   - Allow HTTPS traffic from the internet
   - Allow HTTP traffic from the internet
9. Configure storage: 8 GiB gp3 Root volume, 3000 IOPS, Not encrypted

## Shutting Down Resources

When you're done with the project, to avoid unnecessary AWS charges:

1. Stop or terminate your EC2 instance
2. If you've only stopped your instance, also check for and delete:
   - Elastic IP addresses
   - Unattached EBS volumes
   - Snapshots

## Notes

- This project uses the simplest possible Flask application to demonstrate the CI/CD pipeline
- The GitHub Actions workflow uses SSH to deploy to EC2
- All components are configured for minimal setup while showing core concepts
- It is recommended to push changes to a feature branch first, then merge into main via pull request.
