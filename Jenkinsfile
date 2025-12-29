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
    environment {
        BUILD_SERVER='ec2-user@172.31.43.53'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
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
           // agent {label 'linux_slave'}
           agent any
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
                script{
                    sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                        echo "Packaging the code ${params.APPVERSION}"
                        sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                        sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash server-script.sh ${IMAGE_NAME}"
                        sh "ssh ${BUILD_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                        sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"
                        }
                    }
                }
                
            }
        }
    }
}
