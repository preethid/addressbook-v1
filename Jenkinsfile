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
                echo 'UnitTesting the code'
            }
        }
         stage('CoverageAnalysis') {
            steps {
                echo 'Static code coverage'
            }
        }
         stage('Packaging') {
            steps {
                echo 'Package the code'
            }
        }
    }
}
