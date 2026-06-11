pipeline{
    agent any
    tools {
        java 'myjava'
        maven 'mymaven'
    }
     
    stages{
        stage('Compile'){
            steps{
                echo 'Building...'
                sh "mvn compile"
            }
        }
        stage('CodeReview'){
            steps{
                echo 'CodeReview...'
                sh "mvn pmd:pmd"
            }
        }
        stage('UnitTest'){
            steps{
                echo 'UnitTest...'
                sh "mvn test"
            }
        }
        stage('CoverageAnalysis'){
             steps{
                echo 'CoverageAnalysis...'
                sh "mvn verify"
            }
            
        }
        stage('Package the app'){
             steps{
                echo 'Packaging the app...'
                sh "mvn package"
            }
            
        }
    }
}