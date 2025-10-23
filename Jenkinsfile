pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Compiling the code'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Reviewing the code'
            }
        }
        stage('UnitTest') {
            steps {
                echo 'Testing the code'
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'Static Code Coverage Analysis'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging the code'
            }
        }
    }
}
