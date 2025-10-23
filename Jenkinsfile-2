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
            BUILD_SERVER = 'ec2-user@172.31.42.134'
    }
    stages {
        
        stage('Compile') {
            agent any
            steps {
                echo "Compiling the Code in ${params.Env} environment"
                sh 'mvn compile'
            }
        }
        stage('Code Review') {
             agent any
            steps {
                echo 'Reviewing the Code'
                sh "mvn pmd:pmd"
            }
        }
        stage('Unit Test') {
            agent any
            when {
                expression { 
                    params.executeTests == true} 
                    }
            steps {
                echo 'Unit Testing the Code'
                sh 'mvn test'
            }
            post{
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('Coverage Analysis') {
             agent {label 'linux_slave'}
            steps {
                echo 'Static Code Coverage Analysis of the Code'
                sh 'mvn verify'
            }
        }
        stage('Package') {
             agent any
            steps {
                script{
                sshagent(['slave2']) {
                    echo "Packaging the code ${params.APPVERSION}"
                    sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
                    sh "ssh -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash ~/server-script.sh'"
               
            }
            }
        }
        }
        stage('Publish the artifacts') {
            agent any
            input {
                message "Do you want to publish the artifacts to Jfrog?"
                ok "Yes, publish"
            }
            
            steps {
                echo 'Publishing the artifact to Jfrog'
                sh 'mvn -U deploy -s settings.xml'
            }
        }
    }
}
