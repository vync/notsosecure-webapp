pipeline{
    agent any

    stages {
        stage('Checkout code') {
            steps {
                checkout scm
            }
        }
        
        stage('build image') {
            steps {
                sh './build-image.sh'
            }
        }

        stage('kubectl apply') {
            steps {
                sh './kubectl-apply.sh'
            }
        }

        stage('Terraform plan') {
            steps {
                sh './terraform-plan.sh'
            }
        }

        stage('Terraform apply') {
            steps {
                sh './terraform-apply.sh'
            }
        }

    }
}
