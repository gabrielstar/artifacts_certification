pipeline {
    agent any
    parameters {
        string(name: 'REPORT_ARTIFACT_PATH', defaultValue: '/example-repo-local/dai/10.0.1/report.html', description: 'Where to store report?')
        string(name: 'ARTIFACTORY_URL', defaultValue: 'http://host.docker.internal:8081/artifactory', description: 'Artifactory URL')
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
                sh("make run ARTIFACTORY_URL=$ARTIFACTORY_URL")
                archiveArtifacts artifacts: "certification-report/report.html", fingerprint: true
            }
        }
        stage("Deploy report to Artifactory"){
            steps(){
                sh("curl -X PUT -u $ARTIFACTORY_USER:$ARTIFACTORY_PASS $ARTIFACTORY_URL/$REPORT_ARTIFACT_PATH -T certification-report/report.html")
            }
        }
    }
}