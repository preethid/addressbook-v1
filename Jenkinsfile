pipeline {
    agent none

    tools {
        maven 'mymaven'
    }

    stages {
        stage('Compile') {
            agent any
            steps {
                script{
                    echo 'Compiling the code'
                    sh 'mvn compile'
                }
            }
        }
        stage('CodeReview') {
            agent any
            steps {
                script{
                    echo 'Reviewing the code'
                    sh "mvn pmd:pmd"
                }
            }
        }
         stage('UnitTest') {
            agent any
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
            agent any
            steps {
                script{
                    echo 'Static code coverage'
                    sh "mvn verify"
                }
            }
        }
         stage('Packaging') {
            agent { label 'linux_slave' }
            steps {
                script{
                    echo 'Package the code'
                    sh "mvn package"
                }
            }
        }
    }
}
