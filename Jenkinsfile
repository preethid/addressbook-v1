pipeline {
    agent any

    tools {
        // Install the Maven version configured as "M3" and add it to the path.
        maven "mymaven"
    }

    stages {
        stage('Compile') {
            steps {
                echo "Compiling the code"
            }
        }
        stage('CodeReview') {
            steps {
                echo "Reviewing the code"
            }
        }
        stage('UnitTest') {
            steps {
                echo "Testing the code"
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo "Static Analysis on the code"
            }
        }
        stage('Package') {
            steps {
                echo "Packaging the code"
            }
        }
    }
}
