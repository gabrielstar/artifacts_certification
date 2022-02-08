pipeline {
  agent any
  triggers {
    GenericTrigger(
     genericVariables: [
      [key: 'info', value: '$.artifactory'],
      [key: 'artifact_name', value: '$.artifactory.webhook.data.name'],
      [key: 'artifact_path', value: '$.artifactory.webhook.data.repoPath.path'],
      [key: 'artifact_repo', value: '$.artifactory.webhook.data.repoPath.repoKey'],
     ],

     causeString: 'Triggered for hook',
     token: 'dai_certification',
     printContributedVariables: true,
     printPostContent: true,

    )
  }
  parameters{
        password(name: 'ARTIFACTORY_USER', defaultValue: 'admin')
        password(name: 'ARTIFACTORY_PASS', defaultValue: 'password')
  }
  environment{
      ARTIFACTORY_URL = "http://host.docker.internal:8081/artifactory" //that is because Jenkins seats on compose and Arty on localhost
  }
  stages {
    stage('Artifact info') {
      steps {
        echo "Testing for ${ARTIFACTORY_URL}/${artifact_repo}/${artifact_path}"
      }
    }
    stage ('Starting ART job') {
        steps{
            build job: 'DAI Artifact Certification Test for MLOPS', propagate: true,
            parameters: [[$class: 'StringParameterValue', name: 'ARTIFACT_PATH'
            , value: "${ARTIFACTORY_URL}/${artifact_repo}/{$artifact_path}" ]]
        }
    }
    stage('Update properties') {
      steps {
        sh "echo 'Running update on artifact ${ARTIFACTORY_URL}/${artifact_repo}/${artifact_path}'"
        sh('curl -X PUT -sSf -u ${ARTIFACTORY_USER}:${ARTIFACTORY_PASS} -O ${ARTIFACTORY_URL}/api/storage/${artifact_repo}/${artifact_path}?properties=mlops-0.59=certified')
      }
    }
  }
}