set -e
download_if_not_present() { #download _file if not already present on the disk

  local _folder=$1
  local _file=$2
  local _url=$3

  echo "Provided $_file and $_url"
  if test -f "$_folder/$_file"; then
    echo "$_file exist in $_folder, OK"
  else
    echo "$_file not present. Downloading from $_url"
    curl -O -L $_url
    status=$?
    if [ $status -ne 0 ]; then
      echo "Downloading of dependency failed: $_file. Please update download URL in script"
      exit 1
    fi
    mv $_file $_folder/$file
  fi
}

function install_artifactory() { #unpack and install on the system
  local _downloads_folder=$1
  local _file=$2
  local _install_folder=$3
  local _version=$4

  mkdir -p "$_install_folder"
  export JFROG_HOME=$_install_folder
  cp "$_downloads_folder/$_file" "$_install_folder/"
  pushd "$_install_folder"
  tar -xvf $_file
  local _folder="artifactory-pro-$_version"
  rm -rf artifactory
  mv "$_folder" artifactory
  chmod -R 777 "$JFROG_HOME/artifactory/var" #required for MacOS as not officially supported by JFrog
  popd
}




function run(){
  echo "Let us download Artifactory from $ARTIFACTORY_DOWNLOAD_URL"
  download_if_not_present "$DOWNLOADS_FOLDER" "$DOWNLOAD_FILE" "$ARTIFACTORY_DOWNLOAD_URL"
  install_artifactory "$DOWNLOADS_FOLDER" "$DOWNLOAD_FILE" "$INSTALL_FOLDER" "$ARTIFACTORY_VERSION"

  echo "You can start Artifactory by running 'export JFROG_HOME=$INSTALL_FOLDER && sh $JFROG_HOME/artifactory/app/bin/artifactoryctl'"
  echo "or 'sh start_arty.sh'"
  echo "It will run on http://localhost:8082/ui/login/"
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  DOWNLOADS_FOLDER="$HOME/Downloads"
  ARTIFACTORY_VERSION="7.33.8"
  DOWNLOAD_FILE="jfrog-artifactory-pro-$ARTIFACTORY_VERSION-darwin.tar.gz"
  ARTIFACTORY_DOWNLOAD_URL="https://releases.jfrog.io/artifactory/artifactory-pro/org/artifactory/pro/jfrog-artifactory-pro/$ARTIFACTORY_VERSION/$DOWNLOAD_FILE"
  INSTALL_FOLDER="$HOME/jfrog"

  run "$@"
fi


