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
                    sh "mvn compile"
                }

                }
            }
        
    
    
        stage('codeREview') {
            steps {
                script{
                    echo "codereview  the code by jacoco"
                    sh "mvn pmd:pmd"
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
                    sh "mvn test"

                }

                }
                post{
                    always{
                        junit 'target/surefire-reports/*.xml'
                    }
                }
            
        }
        stage('codeCoverage') {
            steps {
                script{
                    echo "codesCoverage  the code by jacoco"
                    sh "mvn verify"
                }

                }
            }
        
        stage('package') {
            input{
                message "select the platform to deploy"
                ok "versionn selected"
                parameters{
                    choice(name:'platform',choices:['EKS','EC2','On-prem'])
                }
            }
            
            steps {
                script{
                    echo "packagrs of  the code"
                    echo 'platform is ${platfrom}'
                    echo "pakage the version ${params.AKG}"
                    echo "mvn package"
                }

                }
            
        }
        
        
    
}
}
