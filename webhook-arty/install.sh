set -x
# https://www.eficode.com/blog/triggering-jenkins-pipelines-on-artifactory-events

INSTALL_FOLDER="$HOME/jfrog"
ARTI_USER=admin
ARTI_PASS=password

cp webhook* "$INSTALL_FOLDER/artifactory/var/etc/artifactory/plugins"
curl -X POST -u $ARTI_USER:$ARTI_PASS http://localhost:8081/artifactory/api/plugins/reload

