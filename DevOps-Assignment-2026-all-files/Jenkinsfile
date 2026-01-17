pipeline {
    agent any

    tools {
        // These rely on the tools we installed in the Dockerfile
        // We can just use 'sh' commands since they are in the system path
    }

    environment {
        // This securely pulls the credentials you added to Jenkins earlier
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout') {
            steps {
                // This pulls your code from GitHub
                git branch: 'main', url: 'https://github.com/rayanubhav/DevOps-Assignment-GET-2026.git'
            }
        }

        stage('Init Terraform') {
            steps {
                dir('terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                dir('terraform') {
                    // This scans the terraform directory for vulnerabilities
                    // exit-code 1 means "fail the pipeline if you find issues"
                    sh 'trivy config . --severity HIGH,CRITICAL --exit-code 1'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('terraform') {
                    sh 'terraform plan'
                }
            }
        }
    }
}