pipeline{
    agent any
    tools {
        jdk 'myjava'
        maven 'mymaven'
    }
     parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
     }

    stages{
        stage('Compile'){
            steps{
                echo 'Building for environment ${params.Env}...'
                sh "mvn compile"
            }
        }
        stage('CodeReview'){
            steps{
                echo 'CodeReview...'
                sh "mvn pmd:pmd"
            }
        }
        stage('UnitTest'){
            when {
                expression { params.executeTests == true }
            }
            steps{
                echo 'UnitTest...'
                sh "mvn test"
            }
        }
        stage('CoverageAnalysis'){
             steps{
                echo 'CoverageAnalysis...'
                sh "mvn verify"
            }
            
        }
        stage('Package the app'){
            input{
              
                message "Package the app with version ${params.APPVERSION}?"
                ok "Yes, Package it!"
            }
             steps{
                  echo 'Select the application version to package: ${params.APPVERSION}'
                sh "mvn package"
            }
            
        }
    }
}