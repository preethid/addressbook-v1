pipeline {
    agent none

    tools{
        maven "mymaven"
    }

    parameters{
        string(name:'Env',defaultValue:'Test',description:'environment to deploy')
        booleanParam(name:'executeTests',defaultValue: true,description:'decide to run tc')
        choice(name:'APPVERSION',choices:['1.1','1.2','1.3'])

    }
    environment{
        BUILD_SERVER='ec2-user@172.31.39.1'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    echo "Compiling the code"
                   echo "Compiling in ${params.Env}"
                   sh "mvn compile"
                }
                
            }
            
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                    echo "Code Review Using pmd plugin"
                    sh "mvn pmd:pmd"
                }
                
            }
            
        }
         stage('UnitTest') {
            agent any
            when{
                expression{
                    params.executeTests == true
                }
            }
            steps {
                script{
                    echo "UnitTest in junit"
                    sh "mvn test"
                }
                
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
            
        }
        stage('CodeCoverage') {
           // agent {label 'linux_slave'}
           agent any
            steps {
                script{
                    echo "Code Coverage by jacoco"
                    sh "mvn verify"
                }
                
            }
            
        }
        stage('Dockerize the app and push the image to docker hub') {
            agent any
            steps {
                script{
                    sshagent(['slave2']) {
                   
                   withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'password', usernameVariable: 'username')]) {
  
                    echo "Containerising the app"
                    sh "scp  -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                    sh "ssh ${BUILD_SERVER} sudo docker login -u ${username} -p ${password}"
                    sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"
                    sh "ssh ${BUILD_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
                    
                }
                    }
            }
            
        }
    }
}
}
