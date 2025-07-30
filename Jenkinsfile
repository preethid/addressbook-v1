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
       BUILD_SERVER="ec2-user@172.31.4.189"
       IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
       //DEPLOY_SERVER='ec2-user@172.31.2.38'
        ACM_IP='ec2-user@172.31.6.53'
         AWS_ACCESS_KEY_ID=credentials('ACCESS_KEY')
        AWS_SECRET_ACCESS_KEY=credentials('SECRET_ACCESS_KEY')
      DOCKER_REG_PASSWORD=credentials("DOCKER_REG_PASSWORD")
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
               sshagent(['slave2']) { //ssh into ACM
                echo "${EC2_PUBLIC_IP}"
               // withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
             sh "scp -o StrictHostKeyChecking=no -r ansible/* ${ACM_IP}:/home/ec2-user"
            withCredentials([sshUserPrivateKey(credentialsId: 'ansible-target',keyFileVariable: 'keyfile',usernameVariable: 'user')]){ 
            sh "scp -o StrictHostKeyChecking=no $keyfile ${ACM_IP}:/home/ec2-user/.ssh/id_rsa"    
            }
            sh "ssh -o StrictHostKeyChecking=no ${ACM_IP} bash /home/ec2-user/ansible-config.sh ${AWS_ACCESS_KEY_ID} ${AWS_SECRET_ACCESS_KEY} ${DOCKER_REG_PASSWORD} ${IMAGE_NAME}"
         //  }
        }
        }
        }
        }
    }
}
