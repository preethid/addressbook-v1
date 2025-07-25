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
    environment {
       BUILD_SERVER="ec2-user@172.31.5.179"
       IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
       //DEPLOY_SERVER='ec2-user@172.31.2.38'
    }
    stages {
        stage('Compile') {
            agent any
            steps {
                 script{
                echo 'Compiline the code'
                echo "Compiling  ${params.APPVERSION} version"
                sh "mvn compile"
            }
        }
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                echo 'Review the code'
                sh "mvn pmd:pmd"
            }
        }
        }
        stage('UniTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                echo 'Test the code'
                sh "mvn test"
            }
        }
        }
        stage('CoverageAnalysis') {
            agent any // {label 'linux_slave'}
            steps {
                script{
                echo 'Static Code Coverage'
                sh "mvn verify"
            }
        }
        }
       
        stage('Containerize the application') {
        agent any
            steps {       
            script{
               sshagent(['slave2']) {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                echo 'Compile the code'
                echo "Compiling for ${params.Env} environment"
               // sh "mvn compile"
               sh "scp  -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
               sh "ssh  -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
               sh "ssh ${BUILD_SERVER} sudo docker login -u ${username} -p ${password}"
               sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"        
           }
        }
        }
        }
        }
         stage("Provision the infrastructure") {
            agent any
            steps {
                script{
                echo 'Provision the infrastructure'
                dir('terraform') {
                    sh "terraform init"
                    sh "terraform apply -auto-approve"
                    EC2_PUBLIC_IP = sh(script: "terraform output ec2_public_ip", returnStdout: true).trim()
                }
            }
        }
        }
        stage('Deploying the application') {
        agent any
            steps {   
            script{
               sshagent(['slave2']) {
                echo "${EC2_PUBLIC_IP}"
                withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
               sh "ssh  -o StrictHostKeyChecking=no ec2-user@${EC2_PUBLIC_IP} sudo yum install docker -y"
               sh "ssh  ec2-user@${EC2_PUBLIC_IP} sudo systemctl start docker"
               sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker login -u ${username} -p ${password}"
               sh "ssh ec2-user@${EC2_PUBLIC_IP} sudo docker run -itd -p 80:8080 ${IMAGE_NAME}"
           }
        }
        }
        }
        }
    }
}
