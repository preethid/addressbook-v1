pipeline {
    agent any

    tools {
        maven 'mymaven'
    }

    stages {
        stage('Compile') {
            steps {
                script{
                    echo 'Compiling the code'
                    sh 'mvn compile'
                }
            }
        }
        stage('CodeReview') {
            steps {
                script{
                    echo 'Reviewing the code'
                    sh "mvn pmd:pmd"
                }
            }
        }
         stage('UnitTest') {
            steps {
                script{
                    echo 'UnitTesting the code'
                    sh 'mvn test'
                }
            }
            post{
                always{
                    junit 'target/surefire-reports/*.xml'
                }
            }
        }
         stage('CoverageAnalysis') {
            steps {
                script{
                    echo 'Static code coverage'
                    sh "mvn verify"
                }
            }
        }
         stage('Packaging') {
            steps {
                script{
                    echo 'Package the code'
                    sh "mvn package"
                }
            }
        }
    }
}
