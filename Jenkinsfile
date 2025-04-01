pipeline {
    agent any
    environment {
        AWS_DEFAULT_REGION = "us-east-1"  // You can set the region here as well
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Init') {
            steps {
                script {
                    // Initialize Terraform
                    sh 'terraform init'
                }
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
