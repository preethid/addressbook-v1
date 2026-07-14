pipeline {
    agent any
    tools{
        maven 'mymaven'
    }

    stages {
        stage('Compile') {
            steps {
                echo 'Compile the code'
                sh 'mvn compile'
            }
        }
        stage('CodeReview') {
            steps {
                echo 'Review the Code'
                sh 'mvn pmd:pmd'
            }
        }
        stage('UnitTest') {
            steps {
                echo 'UnitTest the code'
                sh "mvn test"
            }
        }
        stage('CoverageAnalysis') {
            steps {
                echo 'Static Code Coverage Analysis'
                sh 'mvn verify'
            }
        }
        stage('Package') {
            steps {
                echo 'Packaging the code'
                sh 'mvn package'
            }
        }
    }
}
