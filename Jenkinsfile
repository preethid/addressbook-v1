pipeline {
    agent none
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
            agent any
            steps {
                echo 'Compile the code'
                echo "Compiling for ${params.Env} environment"
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                echo 'Review the code'
            }
        }
        stage('UniTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                echo 'Test the code'
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'Static Code Coverage'
            }
        }
        stage('Package') {
            agent {label 'linux_slave'}
          
            steps {
                echo 'Package the code'
                echo "Packaging  ${params.APPVERSION} version"
            }
        }
        stage('PubishtoJfrog') {
            steps {
                echo 'Publish the artifcat to jfrog'
            }
        }
    }
}
