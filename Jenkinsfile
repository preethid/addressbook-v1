pipeline {
    agent any
    tools{
        jdk 'myjava'
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
                echo 'Compile the code in ${params.Env} Environment'
                sh 'mvn compile'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Review the Code in ${params.Env} Environment'
                sh 'mvn pmd:pmd'
            }
        }
        stage('UnitTest') {
            when {
                expression { return params.executeTests == true }
            }
            steps {
                echo 'UnitTest the code'
                sh "mvn test"
            }
        }
        stage('CoverageAnalysis') {

            steps {
                echo 'Static Code Coverage Analysis  ${params.APPVERSION}'
                sh 'mvn verify'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging the code'
                sh 'mvn package'
            }
        }
    }
}
