#!/bin/bash

function deploy() {
  curl -X PUT -u "$ARTI_USER:$ARTI_PASS" "$ARTI_URL:$ARTI_PORT/artifactory/$REPOSITORY/$ARTIFACT;$PROPS" -T data/mojo.zip
  printf "\nDeployed $ARTIFACT_NAME"
}
function download() {
  curl -sSf -u "$ARTI_USER:$ARTI_PASS" -O "$ARTI_URL:$ARTI_PORT/artifactory/$REPOSITORY/$ARTIFACT"
  printf "\nDownloaded $ARTIFACT_NAME"
}
function update_property(){
  local _props=$1
  curl -X PUT -u "$ARTI_USER:$ARTI_PASS" "$ARTI_URL:$ARTI_PORT/artifactory/api/storage/$REPOSITORY/$ARTIFACT;?properties=$_props"
  printf "\nUpdated property to $_props\n"
}
function remove_download() {
  local _sleep=$1
  sleep $_sleep
  rm $ARTIFACT_NAME
  printf "\nRemoved $ARTIFACT_NAME\n"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  ARTI_USER="admin"
  ARTI_PASS="password"
  ARTI_URL="http://localhost"
  ARTI_PORT="8081"
  REPOSITORY="example-repo-local"
  ARTIFACT="dai/10.0.1/mojo/mojo.zip"
  ARTIFACT_NAME=mojo.zip
  PROPS="mlops-0.53=unknown;mlops-0.54=unknown;type=mojo;produced=dai"
  UPDATED_PROPS="mlops-0.53=certified"
  deploy && download && update_property $UPDATED_PROPS && remove_download 5
fi
