pipeline {
    agent any
    parameters {
        string(name: 'ARTIFACT_PATH', defaultValue: 'http://host.docker.internal:8081/artifactory/example-repo-local/dai/10.0.1/mojo/mojo.zip', description: 'Artifact to run tests againts?')
        string(name: 'MLOPS_VERSION', defaultValue: '0.55')
        password(name: 'ARTIFACTORY_USER', defaultValue: 'admin')
        password(name: 'ARTIFACTORY_PASS', defaultValue: 'password')


    }
    stages{
        stage("Install dependencies"){
            steps(){
                sh('make setup')
            }
        }
        stage("Generate report"){
            steps(){
                sh('make run')
            }
        }
    }
}