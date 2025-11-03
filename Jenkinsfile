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
        BUILD_SERVER='ec2-user@172.31.8.244'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
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
           // agent {label 'linux_slave'}
           agent any
            steps {
                script{
                echo "Static Code Coverage Analysis of ${params.APPVERSION} version"
                sh "mvn verify"
            }
        }
        }
        stage('Containerise the code n push the image to dockerhub') {
            agent any
            steps {
                script{
                sshagent(['slave2']) {
                echo 'Packaging the code'
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user/"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash ~/server-script.sh ${IMAGE_NAME}"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} sudo docker login -u ${username} -p ${password}"
                sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"
                    }
                }
            }
        }
    }
}
}
