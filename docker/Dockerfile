FROM jenkins/jenkins:lts
USER root
RUN apt-get update
RUN apt-get install -y python3-pip python3-venv python3
RUN pip install --upgrade pip
COPY ./requirements.txt /tmp/requirements.txt
RUN pip install -v -r /tmp/requirements.txt