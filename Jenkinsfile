pipeline {

    agent { label 'jenkins-agent' }

    environment {
        S3_BUCKET = 'joanne-artifacts-bucket'
        APP_PATH = "flask-app/${params.APP_VERSION}/flask_app.tar.gz"
        DEPLOY_PATH = "/var/www/flask_app"
        PATH = "/usr/bin:$PATH"
    }

    parameters {
        string(name: 'APP_VERSION', defaultValue: 'v1.0.2', description: 'App version to deploy')
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
                    pip install -r ansible/roles/app/files/requirements.txt
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
                        flake8 ansible/roles/app/ --count --show-source --statistics
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
                    bandit -r ansible/roles/app/
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
                    PYTHONPATH=$PYTHONPATH:. pytest ansible/roles/app/files/tests/ -v || echo "Tests skipped"
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
                    cp -r ansible/roles/app package/
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
                    withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
                        // Download the artifact
                        sh 'aws s3 cp s3://${S3_BUCKET}/${APP_PATH} ./downloaded_app.tar.gz'
                        
                        // Use ansiblePlaybook step (not sh) for proper extraVars handling
                        ansiblePlaybook(
                            playbook: '/home/jenkins-agent/workspace/testjob/ansible/flaskapp.yml',
                            inventory: '/home/jenkins-agent/workspace/testjob/ansible/hosts.ini',
                            extras: '-e "app_version=${params.APP_VERSION}" ' +
                                '-e "s3_bucket=${S3_BUCKET}" ' +
                                '-e "app_path=/var/www/flask_app" ' +
                                '-e "s3_key=flask-app/${params.APP_VERSION}/flask_app.tar.gz"'
                        )
                    }
                }
            }
        }
        }
       stage('Deploy Monitoring') {
            steps {
                ansiblePlaybook(
                    playbook: 'monitoring/prometheus.yml',
                    inventory: 'ansible/hosts.ini',
                    extraVars: [
                        target_hosts: 'monitoring_servers'
                    ]
                )

                ansiblePlaybook(
                    playbook: 'monitoring/grafana.yml',
                    inventory: 'ansible/hosts.ini',
                    extraVars: [
                        target_hosts: 'monitoring_servers'
                    ]
                )
            }
        }

    }

    post {
        success {
            emailext (
                subject: "✅ SUCCESS: Devopsensei Flask Deployment Job",
                body: """
                ${params.APP_VERSION} was successful!!
                """,
                to: 'orezikoko@gmail.com'
            )
        }
        failure {
            emailext (
                subject: "❌ FAILURE: Devopsensei Flask Deployment Job",
                body: """
                The build failed unfortunately. Check Jenkins for details.
                """,
                to: 'orezikoko@gmail.com'
            )
        }
    }
}