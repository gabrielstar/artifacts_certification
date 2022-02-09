FROM jenkins/jenkins:lts
USER root
RUN  apt-get update
RUN  apt-get install -y python3 python3-pip
USER jenkins
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install -v -r /tmp/requirements.txt