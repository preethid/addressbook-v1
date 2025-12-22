pipeline {
    agent none
    tools{
        maven 'mymaven'
    }
       parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                echo "Compiling the code in ${params.Env} environment with version ${params.APPVERSION}"
                sh 'mvn compile'
            }
        }
         stage('UnitTest') {
            agent any
            when {
                expression { return params.executeTests == true }
            }
            steps {
                echo 'Executing Unit Test cases'
                sh 'mvn test'
            }
        }
         stage('CodeReview') {
            agent any
            steps {
                echo 'Review the code'
                sh 'mvn pmd:pmd'
            }
        }
          stage('Coverage Analysis') {
            agent {label 'linux_slave'}
            steps {
                echo 'Static Code Coverage Analysis'
                sh 'mvn verify'
            }
        }
          stage('Package') {
            agent any
            input {
                message "Do you want to proceed to Package the application?"
                ok "Yes, Proceed"
            }
            steps {
                echo "Packaging the code ${params.APPVERSION}"
                sh 'mvn package'
            }
        }
    }
}
