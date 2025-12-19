pipeline {
    agent any

       parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
    }

    stages {
        stage('Compile') {
            steps {
                echo "Compiling the code in ${params.Env} environment with version ${params.APPVERSION}"
            }
        }
         stage('UnitTest') {
            when {
                expression { return params.executeTests == true }
            }
            steps {
                echo 'Executing Unit Test cases'
            }
        }
         stage('CodeReview') {
            steps {
                echo 'Review the code'
            }
        }
          stage('Coverage Analysis') {
            steps {
                echo 'Static Code Coverage Analysis'
            }
        }
          stage('Package') {
            steps {
                echo "Packaging the code ${params.APPVERSION}"
            }
        }
    }
}
