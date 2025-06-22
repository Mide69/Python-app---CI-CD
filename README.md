# Python Exchange Rate App - CI/CD Pipeline

A Flask-based web application that displays real-time Nigerian Naira (NGN) to US Dollar (USD) exchange rates with automated CI/CD deployment to AWS EC2. This project will enhance your understanding of Python, Flask framework, Docker, AWS EC2 and storage of container Images in a private ECR repository.

## 🚀 Features

- **Real-time Exchange Rates**: Fetches current NGN/USD exchange rates from ExchangeRate-API
- **Web Interface**: Clean, responsive web UI displaying exchange rates
- **Command Line Support**: Can be run from terminal for quick rate checks
- **Dockerized**: Containerized application for consistent deployment
- **CI/CD Pipeline**: Automated deployment using GitHub Actions
- **AWS Integration**: Deployed on EC2 with ECR for container registry

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────┐    ┌─────────────────┐
│   GitHub Repo   │───▶│ GitHub Actions│───▶│   AWS ECR       │
└─────────────────┘    └──────────────┘    └─────────────────┘
                              │                       │
                              ▼                       ▼
                       ┌──────────────┐    ┌─────────────────┐
                       │   Build &    │    │   AWS EC2       │
                       │   Push Image │    │   (Production)  │
                       └──────────────┘    └─────────────────┘
```

## 📋 Prerequisites

- Python 3.9+
- Docker
- AWS Account with ECR and EC2 access
- GitHub repository with Actions enabled

## 🛠️ Local Development

### Setup

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd Python-app---CI-CD
   ```

2. **Install dependencies**
   ```bash
   pip install -r requirements.txt
   ```

3. **Run the application**
   ```bash
   python app.py
   ```

4. **Access the application**
   - Web interface: http://localhost:5000
   - Command line: Run `python app.py` and check terminal output

### Docker Development

1. **Build the image**
   ```bash
   docker build -t exchange-rate-app .
   ```

2. **Run the container**
   ```bash
   docker run -p 5000:5000 exchange-rate-app
   ```

## 🚀 Deployment

### AWS Infrastructure Setup

1. **Create ECR Repository**
   ```bash
   aws ecr create-repository --repository-name tekktribe --region eu-west-2
   ```

2. **Launch EC2 Instance**
   - AMI: Amazon Linux 2
   - Instance Type: t2.micro (or preferred)
   - Security Group: Allow HTTP (80) and SSH (22)
   - Install Docker and AWS CLI

3. **Configure EC2 Instance**
   ```bash
   # Install Docker
   sudo yum update -y
   sudo yum install -y docker
   sudo systemctl start docker
   sudo systemctl enable docker
   sudo usermod -a -G docker ec2-user
   
   # Install AWS CLI
   sudo yum install -y aws-cli
   ```

### GitHub Secrets Configuration

Add the following secrets to your GitHub repository:

| Secret Name | Description |
|-------------|-------------|
| `AWS_ACCESS_KEY_ID` | AWS Access Key ID |
| `AWS_SECRET_ACCESS_KEY` | AWS Secret Access Key |
| `EC2_HOST` | EC2 instance public IP/hostname |
| `EC2_USER` | EC2 username (usually `ec2-user`) |
| `EC2_SSH_KEY` | Private SSH key for EC2 access |

### CI/CD Pipeline

The GitHub Actions workflow (`.github/workflows/pipeline.yml`) automatically:

1. **Triggers** on push/PR to `main` branch
2. **Builds** Docker image with commit SHA and `latest` tags
3. **Pushes** images to AWS ECR
4. **Deploys** to EC2 by:
   - Stopping existing containers on port 80
   - Pulling latest image from ECR
   - Running new container on port 80

## 📁 Project Structure

```
Python-app---CI-CD/
├── .github/
│   └── workflows/
│       └── pipeline.yml          # CI/CD pipeline configuration
├── app.py                        # Main Flask application
├── Dockerfile                    # Container configuration
├── requirements.txt              # Python dependencies
├── deploy.sh                     # Manual deployment script
├── LICENSE                       # Project license
└── README.md                     # Project documentation
```

## 🔧 Configuration

### Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `AWS_REGION` | `eu-west-2` | AWS region for ECR/EC2 |
| `ECR_REPOSITORY` | `tekktribe` | ECR repository name |

### Application Settings

- **Port**: 5000 (container) → 80 (host)
- **API**: ExchangeRate-API (free tier)
- **Update Frequency**: Real-time on page refresh

## 🔍 API Reference

### Endpoints

- `GET /` - Display exchange rates in web interface

### External API

- **Provider**: [ExchangeRate-API](https://open.er-api.com/)
- **Endpoint**: `https://open.er-api.com/v6/latest/USD`
- **Rate Limit**: 1,500 requests/month (free tier)

## 🐛 Troubleshooting

### Common Issues

1. **Port 80 already in use**
   - Pipeline automatically kills processes using port 80
   - Manual fix: `sudo fuser -k 80/tcp`

2. **ECR authentication failed**
   - Verify AWS credentials in GitHub secrets
   - Check ECR repository exists in correct region

3. **EC2 connection failed**
   - Verify EC2 security group allows SSH (22) and HTTP (80)
   - Check SSH key format in GitHub secrets

### Logs

- **Application logs**: `docker logs python-app`
- **GitHub Actions**: Check Actions tab in repository
- **EC2 system logs**: `/var/log/messages`

## 🔒 Security

- AWS credentials stored as GitHub secrets
- Docker containers run with non-root user
- Security groups restrict access to necessary ports only
- Regular dependency updates via Dependabot

## 📈 Monitoring

- **Health Check**: Access application URL
- **Container Status**: `docker ps`
- **Resource Usage**: `docker stats python-app`

## 🤝 Contributing

1. Fork the repository
2. Create feature branch (`git checkout -b feature/amazing-feature`)
3. Commit changes (`git commit -m 'Add amazing feature'`)
4. Push to branch (`git push origin feature/amazing-feature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙋‍♂️ Support

For support and questions:
- Create an issue in the GitHub repository
- Check troubleshooting section above
- Review GitHub Actions logs for deployment issues