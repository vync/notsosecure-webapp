pipeline{
    agent any

    stages {
        stage('Checkout code') {
            steps {
                checkout scm
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

        stage('kubectl apply') {
            steps {
                sh './kubectl-apply.sh'
            }
        }
    }
}
