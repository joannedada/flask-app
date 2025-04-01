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
                    // Run terraform apply using AWS credentials injected by Jenkins
                    withCredentials([usernamePassword(credentialsId: 'aws-access-key-id', passwordVariable: 'AWS_ACCESS_KEY_ID', usernameVariable: 'AWS_SECRET_ACCESS_KEY')]) {
                        sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }
}
