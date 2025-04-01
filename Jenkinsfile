pipeline {
    agent any
    environment {
        // Reference both access key and secret key with their respective Jenkins credential IDs
        AWS_ACCESS_KEY_ID = credentials('aws-access-key-id')    // AWS Access Key ID
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')  // AWS Secret Access Key
        AWS_DEFAULT_REGION = "us-east-1"  // You can set the region here as well
    }
    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }
        stage('Terraform Apply') {
            steps {
                script {
                    dir('terraform') {
                       sh 'terraform init'
                       sh 'terraform apply -auto-approve'
                    }
                }
            }
        }
    }

}