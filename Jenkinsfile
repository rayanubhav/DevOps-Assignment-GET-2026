pipeline {
    agent any

    environment {
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
        AWS_DEFAULT_REGION    = 'us-east-1'
    }

    stages {
        stage('Checkout Code') {
            steps {
                git branch: 'main', url: 'https://github.com/rayanubhav/DevOps-Assignment-GET-2026.git'
            }
        }

        stage('Init Terraform') {
            steps {
                dir('DevOps-Assignment-2026-all-files/terraform') {
                    sh 'terraform init'
                }
            }
        }

        stage('Security Scan (Trivy)') {
            steps {
                dir('DevOps-Assignment-2026-all-files/terraform') {
                    sh 'trivy config . --severity HIGH,CRITICAL --exit-code 0'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('DevOps-Assignment-2026-all-files/terraform') {
                    sh 'terraform plan'
                }
            }
        }

        stage('Terraform Apply') {
            steps {
                dir('DevOps-Assignment-2026-all-files/terraform') {
                    sh 'terraform apply -auto-approve'
                }
            }
        }
    }
}