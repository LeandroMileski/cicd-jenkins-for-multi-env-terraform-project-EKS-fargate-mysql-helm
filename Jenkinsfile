pipeline {
    agent any

    environment {
        AWS_DEFAULT_REGION    = "eu-west-1"
        TF_VAR_env_prefix     = "${params.ENV}"
        AWS_ACCESS_KEY_ID     = credentials('aws-access-key-id')
        AWS_SECRET_ACCESS_KEY = credentials('aws-secret-access-key')
    }

    parameters {
        choice(
            name: 'ENV',
            choices: ['dev', 'test', 'staging'],
            description: 'Target environment'
        )
        choice(
            name: 'ACTION',
            choices: ['plan-apply', 'destroy'],
            description: 'Terraform action'
        )
    }

    stages {

        stage('Init') {
            steps {
                sh """
                    terraform init \
                        -backend-config="key=${ENV}/terraform.tfstate"
                """
            }
        }

        stage('Plan') {
            steps {
                sh """
                    terraform plan \
                        -var-file="envs/${ENV}.tfvars" \
                        -out=tfplan
                """
                sh 'terraform show -no-color tfplan > tfplan.txt'
            }
        }

        stage('Approval') {
            when {
                expression { params.ACTION == 'plan-apply' }
            }
            steps {
                script {
                    def plan = readFile 'tfplan.txt'
                    input message: "Apply this plan to ${ENV}?",
                          ok: 'Apply',
                          parameters: [
                              text(name: 'Plan', description: 'Review the plan', defaultValue: plan)
                          ]
                }
            }
        }

        stage('Apply') {
            when {
                expression { params.ACTION == 'plan-apply' }
            }
            steps {
                sh 'terraform apply -auto-approve tfplan'
            }
        }

        stage('Destroy') {
            when {
                expression { params.ACTION == 'destroy' }
            }
            steps {
                input message: "Destroy ${ENV}? This cannot be undone.",
                      ok: 'Destroy'
                sh """
                    terraform destroy \
                        -var-file="envs/${ENV}.tfvars" \
                        -auto-approve
                """
            }
        }

    }

    post {
        always {
            cleanWs()
        }
        success {
            echo "Terraform ${params.ACTION} on ${params.ENV} completed successfully."
        }
        failure {
            echo "Terraform ${params.ACTION} on ${params.ENV} failed."
        }
    }
}