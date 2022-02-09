 #default docker imahe has no pythin running, you can rebuilt it locally and swap.
 docker build -t jenkins/jenkins:lts .
 docker image ls | grep jenkins