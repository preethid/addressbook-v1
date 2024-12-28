pipeline {
    agent none
    tools {
        maven 'mymaven' 
    }
    // parameters{
    //     string(name:'Env',defaultValue:'Test',description:'version to deploy')
    //     booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
    //     choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    // }
    environment{
        DEV_SERVER='ec2-user@172.31.8.175'
       IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
        //IMAGE_NAME='newaxisdevops.jfrog.io/addbook-docker/addbook:$BUILD_NUMBER'
        DEPLOY_SERVER='ec2-user@172.31.7.50'
    }
    stages {
        stage('Compile') {
            agent any
            steps {
                echo 'Compiling the code'
                echo "compiling in env: ${params.Env}"
                sh "mvn compile"

            }
        }
         stage('CodeReview') {
            agent any
            steps {
                echo 'Reviewing the code'
                echo "Deploying the app version ${params.APPVERSION}"
                sh "mvn pmd:pmd"
            }
            // post{
            //     always{
            //         pmd pattern: 'target/pmd.xml'
            //     }
            // }
        }
         stage('UniTest') {//slave1
          // agent {label 'linux_slave'}
             agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            
            steps {
                echo 'UnitTest the code'
                sh "mvn test"
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('CodeCoverage'){
            agent any
            steps{
                script{
                    echo "Static Code Coverage Analysis with Jacoco"
                    sh "mvn verify"
                }
            }
        }

        //  stage('Package and push to jfrog') {//slave2
        //     //agent {label 'linux_slave'}
        //     agent any
        //     steps {
        //         script{
        //         sshagent(['slave2']) {
        //         echo 'Package the code'
        //         echo "Deploying the app version ${params.APPVERSION}"
        //         sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
        //         sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} 'bash /home/ec2-user/server-script.sh'"
                
        //     }
        // }
        //     }
        //  }
         stage('Containerise the and push to docker-hub') {//slave2
            //agent {label 'linux_slave'}
            agent any
            steps {
                script{
                sshagent(['slave2']) {
               withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                  //withCredentials([usernamePassword(credentialsId: 'jfrog-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                // echo 'Package the code'
                // echo "Deploying the app version ${params.APPVERSION}"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${DEV_SERVER}:/home/ec2-user"
                sh "ssh -o StrictHostKeyChecking=no ${DEV_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                sh "ssh ${DEV_SERVER} sudo docker login -u ${username}  -p ${password}"
            //   sh "ssh ${DEV_SERVER} sudo docker login -u ${username}  -p ${password} newasxisdevops.jfrog.io"
                sh "ssh ${DEV_SERVER} sudo docker push ${IMAGE_NAME}"
                
            }
        }
            }
         }
         }
          stage('Deploy') {
            agent any
            input{
                message "Select the platform to deploy"
                ok "Platform selected"
                parameters{
                    choice(name:'Platform',choices:['On-prem','EKS','EC2'])
                }
            }
            steps {
                   script{
                sshagent(['slave2']) {
               withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
                    // withCredentials([usernamePassword(credentialsId: 'jfrog-cred', passwordVariable: 'password', usernameVariable: 'username')]) {
                // echo 'Deploy the code'
                // echo "Deploying the app version ${params.APPVERSION}"
                // echo "Deploying on ${params.Platform}"
                sh "ssh -o StrictHostKeyChecking=no ${DEPLOY_SERVER} sudo yum install docker -y"
               sh "ssh ${DEPLOY_SERVER} sudo systemctl start docker"
               sh "ssh ${DEPLOY_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
               sh "ssh ${DEPLOY_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
            }
        }
    }
}
          }
    }
}
