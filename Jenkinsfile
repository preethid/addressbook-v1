pipeline {
    agent none

    tools {
        maven 'mymaven'
    }

    parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')

    }
    environment{
        BUILD_SERVER = 'ec2-user@172.31.5.94'
    }
    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                     echo "Compiling the code in ${params.Env} environments"
                     sh "mvn compile"
                }
               
            }
        }
        stage('Unit Test') {
            agent any
            when {
                expression { return params.executeTests == true }
            }
            steps {
                script{
                echo "Running unit tests in ${params.Env} environments"
                sh "mvn test"
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                echo 'Reviewing the code'
                sh "mvn pmd:pmd"
                }
            }
        }
        stage('Coverage') {
            agent {label 'linux_slave'}
            steps {
                script{
                echo 'Checking code coverage'
                sh "mvn verify"
                }
            }
        }
           stage('Package') {
            agent any
            steps {
                script{
                   sshagent(['slave2']) {
                echo "Packaging the code in ${params.APPVERSION} environments"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user/"
                sh "ssh  -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash /home/ec2-user/server-script.sh'"
                }
                

                }
            }
        }
    }
}

