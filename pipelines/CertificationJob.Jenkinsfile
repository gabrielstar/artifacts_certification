pipeline {
  agent any
    parameters{
        password(name: 'ARTIFACTORY_USER', defaultValue: 'admin')
        password(name: 'ARTIFACTORY_PASS', defaultValue: 'password')
        string(name: "artifact_repo", defaultValue: "example-repo-local")
        string(name: "artifact_path", defaultValue: "dai/10.0.1/mojo/mojo.zip")
        string(name: "artifact_name", defaultValue: "mojo.zip")
        string(name: "info", defaultValue: "Manually Triggered")
        string(name: "MLOPS_VERSION", defaultValue: "0.56")
  }
  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'info', value: '$.artifactory', defaultValue: ''],
      [key: 'artifact_name', value: '$.artifactory.webhook.data.name', defaultValue: 'mojo.zip'],
      [key: 'artifact_path', value: '$.artifactory.webhook.data.repoPath.path', defaultValue: 'dai/10.0.1/mojo/mojo.zip'],
      [key: 'artifact_repo', value: '$.artifactory.webhook.data.repoPath.repoKey', defaultValue: 'example-repo-local']
     ],

     causeString: 'Triggered for hook',
     token: 'dai_certification',
     printContributedVariables: true,
     printPostContent: true,

    )
  }

  environment{
      ARTIFACTORY_URL = "http://host.docker.internal:8081/artifactory"
  }
  stages {
    stage('Artifact info') {
      steps {
        echo "Testing for ${ARTIFACTORY_URL}/${artifact_repo}/${artifact_path}"
      }
    }
    stage ('Starting Certification Tests') {
        steps{
            build job: 'CertificationTest', propagate: true,
            parameters: [
                [$class: 'StringParameterValue', name: 'ARTIFACT_PATH'
                    , value: "${ARTIFACTORY_URL}/${artifact_repo}/{$artifact_path}" ],
                [$class: 'StringParameterValue', name: 'MLOPS_VERSION'
                    , value: "${params.MLOPS_VERSION}" ]
            ]
        }
    }
    stage('Update properties') {
      steps {
        sh "echo 'Running update on artifact ${ARTIFACTORY_URL}/${artifact_repo}/${artifact_path}'"
        sh('curl -X PUT -sSf -u ${ARTIFACTORY_USER}:${ARTIFACTORY_PASS} -O ${ARTIFACTORY_URL}/api/storage/${artifact_repo}/${artifact_path}?properties=mlops-${MLOPS_VERSION}=certified')
      }
    }
  }
  stage ('Generate Report') {
          steps{
              build job: 'GenerateCompatibilityReport', propagate: true,
              parameters: [
                  [$class: 'StringParameterValue', name: 'MLOPS_VERSIONS'
                      , value: "${params.MLOPS_VERSION}" ]
              ]
          }
      }
   }
}