pipeline {
    agent any

    environment {
        VIRTUAL_ENV = '/var/www/flask_app/venv'
        PYTHONPATH = "${WORKSPACE}/${VIRTUAL_ENV}/bin"
        S3_BUCKET = 'joanne-artifacts-bucket' // Replace with your S3 bucket name
        APP_VERSION = "${params.APP_VERSION}"  // Accepting version from the user as a parameter
        APP_PATH = "flask-app/${APP_VERSION}/flask_app.tar.gz"  // Path where the app will be stored in S3
    }

    parameters {
        string(name: 'APP_VERSION', defaultValue: 'v1.0.0', description: 'App version to deploy')
    }

    stages {

        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                git 'https://github.com/joannedada/flask-app.git'
            }
        }
        stage('Build App') {
                    steps {
                        script {
                            // No need to create the virtual environment here, since it already exists
                            echo "Using existing virtual environment at ${VIRTUAL_ENV}"

                            // Activate the virtual environment and install dependencies
                            sh "source ${VIRTUAL_ENV}/bin/activate && pip install -r requirements.txt"

                            // Perform the build step, for example, preparing a deployable artifact
                            echo "Building Flask app..."
                            sh 'tar -czf flask_app.tar.gz .'

                            // Optionally, you could run tests here or other build-related tasks
                            sh 'source ${VIRTUAL_ENV}/bin/activate && pytest'
                        }
                    }
                }

        stage('Upload to S3') {
            steps {
                script {
                    // Upload the app to S3 under the versioned path
                    echo "Uploading app version ${params.APP_VERSION} to S3..."
                    withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', credentialsId: 'aws-credentials']]) {
                    sh "aws s3 cp flask_app.tar.gz s3://${S3_BUCKET}/flask-app/${APP_VERSION}/flask_app.tar.gz"
                }
            }
        }

        stage('Linting (Flake8)') {
            steps {
                script {
                    // Run Flake8 to check the entire codebase for style issues
                    sh 'source ${VIRTUAL_ENV}/bin/activate && flake8 .'
                }
            }
        }

        stage('Security Scan (Bandit)') {
            steps {
                script {
                    // Run Bandit over the entire codebase to check for security vulnerabilities
                    sh 'source ${VIRTUAL_ENV}/bin/activate && bandit -r .'
                }
            }
        }

        stage('Run Tests (pytest)') {
            steps {
                script {
                    // Run pytest for the entire project to execute tests
                    sh 'source ${VIRTUAL_ENV}/bin/activate && pytest'
                }
            }
        }
        stage('Deploy') {
            steps {
                script {
                    // Deploy the app using Ansible (now that the app is uploaded to S3)
                    echo "Deploying App version: ${params.APP_VERSION} to Flask server"
                    ansiblePlaybook(
                        playbook: 'flaskapp.yml',  // Your Ansible playbook
                        extraVars: [
                            app_version: "${params.APP_VERSION}",  // Pass the version to Ansible playbook
                            s3_bucket: "${S3_BUCKET}",
                            app_path: "/var/www/flask_app"  // Path where the app will be deployed on the server
                        ]
                    )
                } 
            }
        }  
    }
}