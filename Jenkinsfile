pipeline {
    agent any

    tools {
        maven 'mymaven'
        jdk 'myjava'
    }

    parameters {
        string(name: 'EC2_HOST', defaultValue: '', description: 'Public IP or DNS of the EC2 instance to deploy to (terraform output public_ip/public_dns)')
    }

    environment {
        DOCKER_IMAGE = "devopstrainer/addressbook:${BUILD_NUMBER}"
        EC2_USER = 'ec2-user'
        APP_PORT = '8080'
        CONTAINER_NAME = 'addressbook'
    }

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Build image') {
            steps {
                sh "docker build -f dockerfile -t ${DOCKER_IMAGE} ."
            }
        }

        stage('Push image') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh 'echo $PASSWORD | docker login -u $USERNAME --password-stdin'
                    sh "docker push ${DOCKER_IMAGE}"
                }
            }
        }

        stage('Deploy to EC2') {
            steps {
                script {
                    if (!params.EC2_HOST?.trim()) {
                        error 'EC2_HOST parameter is required (terraform output public_ip or public_dns)'
                    }
                }
                sshagent(['slave1']) {
                    withCredentials([usernamePassword(credentialsId: 'docker-hub', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                        sh """
                            ssh -o StrictHostKeyChecking=no ${EC2_USER}@${params.EC2_HOST} '
                                echo \$PASSWORD | sudo docker login -u \$USERNAME --password-stdin &&
                                sudo docker pull ${DOCKER_IMAGE} &&
                                sudo docker rm -f ${CONTAINER_NAME} || true &&
                                sudo docker run -d --name ${CONTAINER_NAME} -p ${APP_PORT}:${APP_PORT} ${DOCKER_IMAGE}
                            '
                        """
                    }
                }
            }
        }
    }

    post {
        always {
            sh 'docker logout || true'
        }
    }
}
