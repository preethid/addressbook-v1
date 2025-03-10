
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

                echo 'Compiling the source code...'
                echo "Compiling in env: ${params.Env}"

            }

        }

        stage('UnitTest') {
                when{
                    expression{
                        params.executeTests == true
                    }
                }
                steps {
                echo 'Running the tests...'
                
            }

        }

        stage('Package') {

            steps {

                echo 'Packaging the application...'
                echo "Deploying the app version ${params.APPVERSION}"
            }

        }
        stage('Deploy') {
            input{
                message "Select the platform to deploy"
                ok "Platform selected"
                parameters{
                    choice(name: 'Platform',choices ['On-prem','EKS','EC2'])
                }
            }
            steps {

                echo 'Depoly the application...'
                echo "Deploying the app version ${params.APPVERSION}"
                echo "Deploying on ${params.platform}"
            }

        }

    }

}