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
        BUILD_SERVER='ec2-user@172.31.9.26'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
        // DEPLOY_SERVER='ec2-user@172.31.36.190'
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
          stage('Containerize & Push') {
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
     stage('Provision deploy server with terraform'){
           agent any
           steps {
               script {
                   echo 'Provisioning the deploy server with Terraform'
                   dir('terraform') {
                       // Assuming the Terraform files are in a directory named 'terraform'
                       sh 'terraform init'
                       sh 'terraform apply -auto-approve'
                       EC2_PUBLIC_IP = sh(script: 'terraform output ec2-ip', returnStdout: true).trim()
                   }
               }
           }
       }

    stage('Deploy the docker image') {
            agent any
            steps {
                script{
                sshagent(['slave2']) {
                echo 'Packaging the code'
                echo "${EC2_PUBLIC_IP}"
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                //sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user/"
                //sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                sh "ssh -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo service docker start"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${username} -p ${password}"
                sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 8080:8080 ${IMAGE_NAME}"
                    }
                }
            }
        }
    }
}
}
