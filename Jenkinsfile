pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }
      parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
    }


    stages {
        stage('Compile') {
            steps {
                echo "compiling the code in ${params.Env} environment"
                sh "mvn compile"
            }
        }
         stage('CodeReview') {
            steps {
                echo "Review the code"
                sh "mvn pmd:pmd"
            }
        }
        stage('UnitTest') {
            when{
                expression { return params.executeTests }
            }
            steps {
                echo "Test the code"
                sh "mvn test"
            }
            post{
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo "Code Coverage Analysis"
                sh "mvn verify"
            }
        }
        stage('Package') {
            input{
                message "Do you want to package the code for version ${params.APPVERSION}?"
                ok "Yes, Package it!"
            }
            steps {
                echo "Packaging the code for version ${params.APPVERSION}"
                sh "mvn package"
            }
        }
        }
    }
