set -x

INSTALL_FOLDER="$HOME/jfrog"
cp webhook* "$INSTALL_FOLDER/artifactory/var/etc/artifactory/plugins"
cp webhook* "$INSTALL_FOLDER/arti/var/etc/artifactory/plugins"
curl -X POST -u admin:password http://localhost:8081/artifactory/api/plugins/reload

#trigger job like this
curl -u user:pass http://localhost:8085/generic-webhook-trigger/invoke\?token\=a

