pipeline {
    agent any
    parameters {
        string(name: 'ARTIFACT_PATH', defaultValue: 'http://host.docker.internal:8081/artifactory/example-repo-local/dai/10.0.1/report.html', description: 'Artifact to run tests againts?')
        string(name: 'MLOPS_VERSION', defaultValue: '0.55')
        password(name: 'ARTIFACTORY_USER', defaultValue: 'admin')
        password(name: 'ARTIFACTORY_PASS', defaultValue: 'password')


    }
    stages{
        stage("Install deps"){
            steps(){
                sh("make setup")
            }
        }
        stage("Generate report"){
            steps(){
                sh("make run")
                archiveArtifacts artifacts: "certification-report/report.html", fingerprint: true
            }
        }
        stage("Deploy report to Artifactiory"){
            steps(){
                sh("curl -X PUT -u "$ARTIFACTORY_USER:$ARTIFACTORY_PASSWORD" "$ARTIFACT_PATH" -T certification-report/report.html")                    ")
            }
        }
    }
}