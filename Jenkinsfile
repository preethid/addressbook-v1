pipeline {
    agent any

    stages {
        stage('Compile') {
            steps {
                echo 'Compiling the code'
            }
        }
         stage('UnitTest') {
            steps {
                echo 'Executing Unit Test cases'
            }
        }
         stage('CodeReview') {
            steps {
                echo 'Review the code'
            }
        }
          stage('Coverage Analysis') {
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
