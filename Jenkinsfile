pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id') // Jenkins AWS credentials for access key
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key') // Jenkins AWS credentials for secret key
        AWS_DEFAULT_REGION = 'us-east-1' // Specify your AWS region
    }

    stages {
        stage('Checkout') {
            steps {
                // Pull code from your Git repository
                git 'https://github.com/joannedada/flask-app.git'  // Replace with your Git repository
            }
        }

        stage('Terraform Init') {
            steps {
                // Initialize Terraform (downloads necessary providers, modules)
                sh 'terraform init'
            }
        }

        stage('Terraform Plan') {
            steps {
                // Run terraform plan to preview changes
                sh 'terraform plan -out=tfplan'
            }
        }

        stage('Terraform Apply') {
            steps {
                // Apply the Terraform changes to provision infrastructure
                sh 'terraform apply -auto-approve tfplan'
            }
        }
    }

    post {
        success {
            echo 'Terraform provisioning succeeded!'
        }
        failure {
            echo 'Terraform provisioning failed.'
        }
    }
}
