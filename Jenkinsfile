pipeline {
    agent any

    environment {
        AWS_REGION = 'us-east-1'
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
                    withCredentials([aws(credentialsId: 'aws-access-key-id', region: AWS_REGION)]) {
                        sh '''
                        terraform init
                        terraform plan
                        terraform apply -auto-approve
                        '''
                    }
                }
            }
        }
    }
}
