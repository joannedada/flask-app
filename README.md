# Flask App Deployment Pipeline 🚀

This repository contains a Python Flask application along with a CI/CD pipeline using **Jenkins**, **Ansible**, **Terraform**, and **AWS S3** for versioned deployments.

---

## 🧱 Project Structure

```
flask-app/
├── app.py
├── config.py
├── requirements.txt
├── templates/
│   └── index.html
├── tests/
│   └── test_app.py
├── .flake8
├── .bandit
├── Jenkinsfile
└── README.md
```

---

## 🚀 Features

- Flask web application
- Virtual environment setup using Ansible
- CI/CD using Jenkins
- Linting with **Flake8**
- Security scanning with **Bandit**
- Unit testing with **Pytest**
- Versioned S3 artifact storage
- Terraform for infrastructure provisioning

---

## 🧪 Testing and Quality

### ✅ Run Linting
```bash
flake8 .
```

### 🛡️ Run Security Scan
```bash
bandit -r .
```

### 🧪 Run Tests
```bash
pytest
```

---

## ⚙️ Jenkins CI/CD Pipeline

The Jenkins pipeline includes:

1. **Checkout** - Pull latest code from GitHub
2. **Linting** - Run flake8 on the codebase
3. **Security Scan** - Run Bandit on the codebase
4. **Tests** - Run pytest
5. **Build & Archive** - Zip app and upload to S3 using version tag
6. **Deploy** - Trigger Ansible to deploy to Flask servers

### 🔁 Versioned Deployments

Pass a version like `v1.0.0` to the Jenkins parameter `APP_VERSION`. The pipeline uploads the artifact to:

```
s3://your-bucket-name/flask-app/v1.0.0/app.zip
```

---

## 🧰 Infrastructure & Deployment

### Terraform

- Used to provision resources (EC2, S3, etc.)
- Backend state stored in Terraform Cloud

### Ansible

- Installs Python, sets up virtualenv, and deploys the app
- Configures systemd service to keep app running

---

## 🧾 Requirements

- Python 3.6+
- AWS CLI configured
- Jenkins with required plugins
- Ansible installed on Jenkins or control server

---

## 📂 Environment Variables

Configure your `config.py` or use environment variables for:

```python
DB_HOST = "your-db-host"
DB_NAME = "your-db-name"
DB_USER = "your-db-user"
DB_PASS = "your-db-password"
```

---

## 🧑‍💻 Author

*Your Name*  
[GitHub](https://github.com/your-username)

---

## 📜 License

This project is licensed under the MIT License.
```
