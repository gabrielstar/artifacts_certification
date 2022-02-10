pipeline {
    agent any
    parameters {
        string(name: 'ARTIFACT_PATH', defaultValue: 'http://host.docker.internal:8081/artifactory/example-repo-local/dai/10.0.1/mojo/mojo.zip', description: 'Artifact to run tests againts?')
        string(name: 'MLOPS_VERSION', defaultValue: 'mlops-0.55')
        password(name: 'ARTIFACTORY_USER', defaultValue: 'admin')
        password(name: 'ARTIFACTORY_PASS', defaultValue: 'password')


    }
    stages{
        stage("Fetch artifact"){
            steps(){
                echo "Fetching ${params.ARTIFACT_PATH}";
                sh('curl -sSf -u ${ARTIFACTORY_USER}:${ARTIFACTORY_PASS} -O ${ARTIFACT_PATH}')
                sh("ls -alh")
            }
        }
        stage("Run tests"){
            steps(){
                echo "Running tests against ${params.ARTIFACT_PATH}";
                echo "Running tests against ${MLOPS_VERSION}";
                sh("touch ${MLOPS_VERSION}.log")
                archiveArtifacts artifacts: "${MLOPS_VERSION}.log", fingerprint: true
            }
        }
    }
}