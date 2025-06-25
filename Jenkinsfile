pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Compile the code'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Review the code'
            }
        }
        stage('UniTest') {
            steps {
                echo 'Test the code'
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'Static Code Coverage'
            }
        }
        stage('Package') {
            steps {
                echo 'Package the code'
            }
        }
        stage('PubishtoJfrog') {
            steps {
                echo 'Publish the artifcat to jfrog'
            }
        }
    }
}
