
pipeline {

    agent any

    parameters{
        string(name: 'Env', defaultValue: 'Test', description: 'version to deploy')

        booleanParam(name: 'executeTests', defaultValue: true, description: 'decide to run tc')

        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'])
    }

    stages {
        
        stage('Compile') {

            steps {
                echo 'Compiling the source code'
                echo "Compiling in env: ${params.Env}"
                sh "mvn compile"

            }

        }

        stage('CodeReview') {

            steps {

                echo 'Reviewing the code...'
                echo "Deploying the app version ${params.APPVERSION}"
                sh "mvn pmd:pmd"
            }
           // post{
           //     always{
           //         pmd pattern: 'target/pmd.xml'
           //     }
           // }

        }

            stage('UnitTest') {
                when{
                    expression{
                        params.executeTests == true
                    }
                }
                steps {
                echo 'Running the tests...'
                sh "mvn test"
                
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }

        }

            stage('Package') {

            steps {

                echo 'Packaging the application...'
                echo "Deploying the app version ${params.APPVERSION}"
                sh "mvn package"
            }

        }
            stage('Deploy') {
            input{
                message "Select the platform to deploy"
                ok "Platform selected"
                parameters{
                    choice(name: 'Platform',choices:['On-prem','EKS','EC2'])
                }
            }
            steps {

                echo 'Depoly the application...'
                echo "Deploying the app version ${params.APPVERSION}"
                echo "Deploying on ${params.Platform}"
            }

        }

    }
}
