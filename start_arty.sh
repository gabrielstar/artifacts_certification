set -x

INSTALL_FOLDER="$HOME/jfrog"
export JFROG_HOME=$INSTALL_FOLDER
$JFROG_HOME/artifactory/app/bin/artifactoryctl

