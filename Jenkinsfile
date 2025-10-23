pipeline {
    agent any

    paramaters{
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')

    }

    stages {
        stage('Compile') {
            steps {
                script{
                echo 'Compiling the code in ${params.Env} environment'
                }
            }
        }
        stage('CodeReview') {
            steps {
                script{
                echo 'Reviewing the code'
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
                }
            }
        }
        stage('CoverageAnalysis') {
            steps {
                script{
                echo 'Static Code Coverage Analysis of ${params.APPVERSION} version'
            }
        }
        }
        stage('Package') {
            steps {
                script{
                echo 'Packaging the code'
            }
        }
    }
}
}
