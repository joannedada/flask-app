pipeline {

    agent { label 'jenkins-agent' }

    environment {
        S3_BUCKET = 'joanne-artifacts-bucket'
        APP_PATH = "flask-app/${params.APP_VERSION}/flask_app.tar.gz"
        DEPLOY_PATH = "/var/www/flask_app"
    }

    parameters {
        string(name: 'APP_VERSION', defaultValue: 'v1.0.0', description: 'App version to deploy')
    }

    tools {
        git 'Default'
    }
    
    stages {

        stage('Checkout') {
            steps {
                // Checkout code from GitHub repository
                git branch: 'dev', url: 'https://github.com/joannedada/flask-app.git'
            }
        }

        stage('Setup Environment') {
            steps {
                script {
                    // Activate the virtual environment and install dependencies
                     sh '''
                    python3 -m venv ./build_venv
                    . ./build_venv/bin/activate
                    pip install -r ansible/roles/deploy_app/files/requirements.txt
                    pip install flake8 bandit pytest
                    '''
                }
            }
        }
       
        stage('Linting (Flake8)') {
            steps {
                script {
                    // Run Flake8 to check the entire codebase for style issues
                    sh '''
                    . ./build_venv/bin/activate
                        flake8 app/ --count --show-source --statistics
                    '''    
                }
            }
        }

        stage('Security Scan (Bandit)') {
            steps {
                script {
                    // Run Bandit over the entire codebase to check for security vulnerabilities
                    sh '''
                    . ./build_venv/bin/activate
                    bandit -r app/
                    '''
                }
            }
        }

        stage('Run Tests (pytest)') {
            steps {
                script {
                    // Run pytest for the entire project to execute tests
                    sh '''
                    . ./build_venv/bin/activate
                    pytest tests/ -v
                    '''
                }
            }
        }            

        stage('Package & Upload') {
            steps {
                script {
                      // Create clean production artifact
                    sh '''
                    mkdir -p package
                    cp -r app package/
                    cp requirements.txt package/
                    cd package && tar -czf ../flask_app.tar.gz .
                    '''
                    
                    // Upload to S3
                    withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                        s3Upload(
                            bucket: "${S3_BUCKET}",
                            file: "flask_app.tar.gz",
                            path: "${APP_PATH}"
                         )
                }
            }
        }
    }

        stage('Download & Deploy') {
            steps {
                script {
                    sh """
                        aws s3 cp s3://${S3_BUCKET}/${APP_PATH} ./downloaded_app.tar.gz
                        """
                    }
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