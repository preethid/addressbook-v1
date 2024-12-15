pipeline {
    agent any

    parameters{
        string(name: 'ENV', defaultValue: 'stage', description: 'envinorment to deploy')
        booleanParam(name: 'DEBUG_BUILD', defaultValue: true, description: 'decide to run')
        choice(name: 'AKG', choices: ['one', 'two', 'three'])

    }  

    stages {
        stage('compile') {
            steps {
                script{
                    echo "compile the code"
                    echo "compileing in ${params.ENV}"
                }

                }
            }
        
    
    
        stage('codeREview') {
            steps {
                script{
                    echo "codereview  the code by jacoco"
                }

                }
            }
        
        stage('UnitTest') {
            when{
                expression{
                    params.DEBUG_BUILD == true
                }
            }
            steps {
                script{
                    echo "packagrs of  the code"
                }

                }
            
        }
        stage('codeCoverage') {
            steps {
                script{
                    echo "codeCoverage  the code by jacoco"
                }

                }
            }
        
        stage('package') {
            steps {
                script{
                    echo "packagrs of  the code"
                    echo "pakage the version ${params.AKG}"
                }

                }
            
        }
        
        
    
}
}
