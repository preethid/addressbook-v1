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
       BUILD_SERVER="ec2-user@172.31.1.155"
    }
    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    sshagent(['slave2']) {
                echo 'Compile the code'
                echo "Compiling for ${params.Env} environment"
               // sh "mvn compile"
               sh "scp  -o StrictHostKeyChecking=no server-script.sh ${BUILD_SERVER}:/home/ec2-user"
               sh "ssh  -o StrictHostKeyChecking=no ${BUILD_SERVER} 'bash /home/ec2-user/server-script.sh'"
              
            }
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
            agent any
            steps {
                script{
                echo 'Static Code Coverage'
                sh "mvn verify"
            }
        }
        }
        stage('Package') {
            agent {label 'linux_slave'}
          input {
                message "Archive the artifacts"
                ok "select the Platform"
                parameters{
                    choice(name: 'Platform', choices: ['Jfrog', 'Nexus'], description: 'Select the platform for deployment')
                }
            }
            steps {
                script{
                echo 'Package the code'
                echo "Packaging  ${params.APPVERSION} version"
                sh "mvn package"
            }
        }
        }
        stage('PubishtoJfrog') {
            agent any
            input{
                message "Do you want to publish the artifact to JFrog?"
                ok "Yes, publish it"
            }
            
            steps {
                script{
                echo 'Publish the artifcat to jfrog'
                sh "mvn -U deploy -s settings.xml"
            }
        }
        }
    }
}
