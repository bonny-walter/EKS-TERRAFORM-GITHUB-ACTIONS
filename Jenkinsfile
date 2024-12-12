pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION = 'us-east-2' // Set your default AWS region
        AWS_ACCESS_KEY_ID     = credentials('AWS_ACCESS_KEY_ID')
        AWS_SECRET_ACCESS_KEY = credentials('AWS_SECRET_ACCESS_KEY')
    }

    stages {

        stage('Cleanup') {
            steps {
                cleanWs()
            }
        }

        stage('Checkout') {
            steps {
                sh 'git clone git@github.com:bonny-walter/EKS-TERRAFORM-GITHUB-ACTIONS.git'
            }
        }

        stage('create s3 and dynamodb') {
            steps {
                sh '''
                  cd EKS-TERRAFORM-GITHUB-ACTIONS/eks/backend 
                  terraform destroy --auto-approve
                  terraform init
                  terraform plan
                  terraform apply --auto-approve
                  '''

            }
        }

        stage('Terraform init') {
            steps {
                sh 'cd EKS-TERRAFORM-GITHUB-ACTIONS/eks  && terraform init'
            }
        }

        stage('Plan') { 
            steps {
                sh '''
                    cd EKS-TERRAFORM-GITHUB-ACTIONS/eks 
                    terraform plan -out=tfplan
                    terraform show -no-color tfplan > tfplan.txt
                   ''' 
            }
        }

        stage('Approval to Deploy') {
            steps {
                input message: 'Approve deployment to EKS?', ok: 'Deploy'
            }
        }

        stage('Apply') {
            steps {
                sh '''
                    cd EKS-TERRAFORM-GITHUB-ACTIONS/eks 
                    terraform apply --auto-approve
                  '''  
            }
        }

        stage('Approval to Destroy') {
            steps {
                input message: 'Approve deletion of EKS?', ok: 'Destroy'
            }
        }

        stage('Destroy') {
            steps {
                sh '''
                    cd EKS-TERRAFORM-GITHUB-ACTIONS/eks 
                    terraform destroy --auto-approve
                  '''
            }
        }
    }
}