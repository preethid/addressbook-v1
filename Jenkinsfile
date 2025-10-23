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
    environment{
        BUILD_SERVER='ec2-user@172.31.15.44'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                echo "Compiling the code in ${params.Env} environment"
                sh "mvn compile"
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
        stage('UnitTest') {
            agent any
            when{
                expression { return params.executeTests == true }
            }
            steps {
                script{
                echo 'Testing the code'
                sh "mvn test"
                }
            }
            post {
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('CoverageAnalysis') {
            agent {label 'linux_slave'}
            steps {
                script{
                echo "Static Code Coverage Analysis of ${params.APPVERSION} version"
                sh "mvn verify"
            }
        }
        }
        stage('Package') {
            agent any
            steps {
                script{
                sshagent(['slave2']) {
                echo 'Packaging the code'
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user/"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash ~/server-script.sh'"
                    }
            }
        }
    }
}
}
