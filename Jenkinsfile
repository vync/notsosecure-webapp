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
                sh("kubectl --kubeconfig $HOME/.kube/<path_to_eks_cluster_kubeconfig> apply -f webserver.yaml")
            }
        }
    }
}
