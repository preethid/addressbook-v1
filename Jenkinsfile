pipeline {
    agent any

    tools{
        maven 'mymaven'
    }

    parameters{
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')

    }

    stages {
        stage('Compile') {
            steps {
                script{
                echo "Compiling the code in ${params.Env} environment"
                sh "mvn compile"
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
        stage('UnitTest') {
            when{
                expression { return params.executeTests == true }
            }
            steps {
                script{
                echo 'Testing the code'
                sh "mvn test"
                }
            }
        }
        stage('CoverageAnalysis') {
            steps {
                script{
                echo "Static Code Coverage Analysis of ${params.APPVERSION} version"
                sh "mvn verify"
            }
        }
        }
        stage('Package') {
            steps {
                script{
                echo 'Packaging the code'
                sh "mvn package"
            }
        }
    }
}
}
