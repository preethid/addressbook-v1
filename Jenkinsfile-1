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
     
     environment {
        BUILD_SERVER='ec2-user@172.31.9.183'
        IMAGE_NAME='devopstrainer/java-mvn-privaterepos:$BUILD_NUMBER'
     }

    stages {
        // stage('Compile') {
        //     agent any
        //     steps {
        //         script{
        //             sshagent(['slave2']){
        //             echo 'Compiling the code ${params.Env}'
        //             sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
        //             sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash /home/ec2-user/server-script.sh'"
        //         }
        //         }
        //     }
        // }
        // stage('CodeReview') {
        //     agent any
        //     steps {
        //         script{
        //             echo 'Reviewing the code'
        //             sh "mvn pmd:pmd"
        //         }
        //     }
        // }
        //  stage('UnitTest') {
        //     agent any
        //     when {
        //         expression { params.executeTests == true }
        //     }
        //     steps {
        //         script{
        //             echo 'UnitTesting the code'
        //             sh 'mvn test'
        //         }
        //     }
        //     post{
        //         always{
        //             junit 'target/surefire-reports/*.xml'
        //         }
        //     }
        // }
        //  stage('CoverageAnalysis') {
        //     agent any
        //     steps {
        //         script{
        //             echo 'Static code coverage ${params.APPVERSION}'
        //             sh "mvn verify"
        //         }
        //     }
        // }
         stage('Containerising the app') {
            agent any
            input{
               message "Package the code"
               ok "Platform selected"
               parameters{
                   choice(name:'Platform',choices:['Ec2','OnPrem'])
               }
           }

            steps {
                script{
                     sshagent(['slave2']) {
                        withCredentials([usernamePassword(credentialsId: 'docker-hub', passwordVariable: 'PASSWORD', usernameVariable: 'USERNAME')]) {
                        echo "Containerising the code and pushing the image"
                         sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                         sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} bash /home/ec2-user/server-script.sh ${IMAGE_NAME}"
                        // sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'docker build -t ${IMAGE_NAME} .'"
                        sh "ssh ${BUILD_SERVER} sudo docker login -u ${USERNAME} -p ${PASSWORD}"
                        sh "ssh ${BUILD_SERVER} sudo docker push ${IMAGE_NAME}"
                        sh "ssh ${BUILD_SERVER} sudo docker run -itd -P ${IMAGE_NAME}"
                        }
                    }
                }
            }
        }
    }
}