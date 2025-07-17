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
       BUILD_SERVER="ec2-user@172.31.9.87"
       IMAGE_NAME='devopstrainer/java-mvn-privaterepos'
      // DEPLOY_SERVER='ec2-user@172.31.2.38'
       ACCESS_KEY=credentials('ACCESS_KEY')
       SECRET_ACCESS_KEY=credentials('SECRET_ACCESS_KEY')
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
               sh "ssh  -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME} ${BUILD_NUMBER}"
               sh "ssh ${BUILD_SERVER} sudo docker login -u ${username} -p ${password}"
               sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}:${BUILD_NUMBER}"        
           }
        }
        }
        }
        }
        // stage('Deploying the application') {
        // agent any
        //     steps {   
        //     script{
        //        sshagent(['slave2']) {
        //         withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
               
        //        sh "ssh  -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y"
        //        sh "ssh  ${DEPLOY_SERVER} sudo systemctl start docker"
        //        sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${username} -p ${password}"
        //        sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}:${BUILD_NUMBER}"
        //    }
        // }
        // }
        // }
        // }
        stage('DeploytoEKS'){
            agent any
            steps {
                script {
                echo 'Deploying to EKS'
                sh "aws --version"
                sh "aws configure set aws_access_key_id ${ACCESS_KEY}"
                sh "aws configure set aws_secret_access_key ${SECRET_ACCESS_KEY}"
                sh "aws eks update-kubeconfig --region us-east-1 --name eks-test"
                sh "kubectl get nodes"
                sh "envsubst < k8s-manifests/java-mvn-app.yaml | kubectl apply -f -"
                sh "kubectl get all"
                }
            }
        }
    }
}
