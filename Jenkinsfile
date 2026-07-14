pipeline {
    agent any
    tools{
        jdk 'myjava'
        maven 'mymaven'
    }

        parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
    }

      environment {
        BUILDSERVER="ec2-user@65.2.82.31"
      }

    stages {
        stage('Compile') {
            steps {
                echo "Compile the code in ${params.Env} Environment"
                sh 'mvn compile'
            }
        }
        stage('CodeReview') {
            steps {
                echo "Review the Code in ${params.Env} Environment"
                sh 'mvn pmd:pmd'
            }
        }
        stage('UnitTest') {
            when {
                expression { return params.executeTests == true }
            }
            steps {
                echo 'UnitTest the code'
                sh "mvn test"
            }
            post{
                always {
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
        stage('CoverageAnalysis') {

            steps {
                echo "Static Code Coverage Analysis  ${params.APPVERSION}"
                sh 'mvn verify'
            }
        }
        stage('Package') {
            input {
                message "Do you want to package the code?"
                ok "Yes, I want to package"
            }
            steps {
                sshagent(['slave1']) {

                echo "Packaging the code in ${params.Env} Environment"
                sh "scp -o StrictHostKeyChecking=no server-script.sh ${BUILDSERVER}:/home/ec2-user/addressbook-v1"
                sh "ssh -o StrictHostKeyChecking=no ${BUILDSERVER} 'bash ~/server-script.sh'"
                }
            }
        }
    }
}
