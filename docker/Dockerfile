FROM jenkins/jenkins:lts
USER root
RUN  apt-get update
RUN  apt-get install -y python3 python3-pip
USER jenkins
#automatically installing all plugins
COPY plugins.txt /usr/share/jenkins/ref/plugins.txt
RUN /usr/local/bin/install-plugins.sh < /usr/share/jenkins/ref/plugins.txt
COPY ./requirements.txt /tmp/requirements.txt
RUN pip3 install -v -r /tmp/requirements.txt