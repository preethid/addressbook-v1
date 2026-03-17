pipeline {
    agent any

    // tools {
    //     // Install the Maven version configured as "M3" and add it to the path.
    //     maven "M3"
    // }

    stages {
        stage('Compile') {
            steps {
                echo "compiling the code"
            }
        }
           stage('CodeReview') {
            steps {
                echo "Review the code"
            }
        }
        stage('UnitTest') {
            steps {
                echo "Test the code"
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo "Code Coverage Analysis"
            }
        }
        stage('Package') {
            steps {
                echo "Packaging the code"
            }
        }
        }
    }
