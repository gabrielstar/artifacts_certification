 #default docker imahe has no pythin running, you can rebuilt it locally and swap.
 cp ../requirements.txt .
 docker build --progress=plain -t jenkins/jenkins:lts .
 docker image ls | grep jenkins
 rm requirements.txt ||: