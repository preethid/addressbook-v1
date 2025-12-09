pipeline {
    agent any

    tools {
        maven 'mymaven'
    }

    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')

    }

    stages {
        stage('Compile') {
            steps {
                script{
                     echo "Compiling the code in ${params.Env} environments"
                     sh "mvn compile"
                }
               
            }
        }
        stage('Unit Test') {
            when {
                expression { return params.executeTests == true }
            }
            steps {
                script{
                echo "Running unit tests in ${params.Env} environments"
                sh "mvn test"
                }
            }
        }
        stage('CodeReview') {
            steps {
                script{
                echo 'Reviewing the code'
                sh "mvn pmd:pmd"
                }
            }
        }
        stage('Coverage') {
            steps {
                script{
                echo 'Checking code coverage'
                sh "mvn verify"
                }
            }
        }
           stage('Package') {
            steps {
                script{
                echo "Packaging the code in ${params.APPVERSION} environments"
                }
            }
        }
    }
}
