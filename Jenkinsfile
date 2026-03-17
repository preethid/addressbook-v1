pipeline {
    agent any

    // tools {
    //     // Install the Maven version configured as "M3" and add it to the path.
    //     maven "M3"
    // }
      parameters {
        string(name: 'Env', defaultValue: 'Test', description: 'Version to deploy')
        booleanParam(name: 'executeTests', defaultValue: true, description: 'Decide to run test cases')
        choice(name: 'APPVERSION', choices: ['1.1', '1.2', '1.3'], description: 'Select application version')
    }


    stages {
        stage('Compile') {
            steps {
                echo "compiling the code in ${params.Env} environment"
            }
        }
           stage('CodeReview') {
            steps {
                echo "Review the code"
            }
        }
        stage('UnitTest') {
            when{
                expression { return params.executeTests }
            }
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
            input{
                message "Do you want to package the code for version ${params.APPVERSION}?"
                ok "Yes, Package it!"
            }
            steps {
                echo "Packaging the code for version ${params.APPVERSION}"
            }
        }
        }
    }
