# Arty + Jenkins

## Infrastructure set-up
### Configure Artifactory

Note: for plugins support Artifactory Pro is required (register on JFrog site for 30-day trial license). You need to install Artifactory e.g. by running

```bash
 sh install_arty.sh
 sh start_arty.sh
```

Login with default admin credentials `admin:password`
By default there is `example-repo-local` repository we can use. 

Install [Arty Webhook plugin](https://www.eficode.com/blog/triggering-jenkins-pipelines-on-artifactory-events) (assume jenkins run on port 8085) that will be notyfying Jenkins on artifacts deployment
```bash
    cd webhook-arty
    sh install.sh
```

You can verify it all works by trying to [upload a test artifact](testing/test_deploy.sh)

# Configure Jenkins with Docker in Docker (unsafe - use for testing only)

```bash
    docker compose up
    # install docker for docker
    docker exec -it --user root artifacts_certification-jenkins-1 bash
    root@08e45ab0cec7:/# 
    curl https://get.docker.com/ > dockerinstall && chmod 777 dockerinstall && ./dockerinstall
    docker run hello-world
    usermod -a -G docker jenkins
    chmod 777 var/run/docker.sock
    su jenkins
    docker run hello-world

    
```
Open browser at localhost:8085 and install suggested plugins. Configure `user:pass` as credentials.
After that, go to Jenkins->Manage Plugins and install:
- Generic Webhook Trigger plugin
- HTML Publisher plugin

if not using [Docker Image from this repo](docker/Dockerfile).

## Jenkins pipeline

At this stage whenever an artifact gets deployed to Artifactory a Hook API call will be sent to Jenkins to notify it of an event.
Now it is time for Jenkins pipeline.

* First, create new Pipeline job from [CertificationJob.Jenkinsfile](CertificationJob.Jenkinsfile) with a name of
"CertificationJob"

    This is the pipeline that gets triggered whenever new artifact is deployed to our repo. It runs Test and Report.

* Second, create new Pipeline job from [CertificationTest.Jenkinsfile](ci/CertificationTest.Jenkinsfile)
with a name of "CertificationTest"

    This can also be used manually to verify that an artifact passes criteria.

* Last, create new Pipeline job from [GenerateCompatibility.Jenkinsfile](ci/GenerateCompatibilityReport.Jenkinsfile)
  with a name of "GenerateCompabilityReport",

    Generates report, can also be run manually.

Now, deploy an artifact to Arty with [test_deploy.sh](testing/test_deploy.sh). You should see Arty notyfying Jenkins and on successful 
jobs, artifact properties will be updated. Test and Report will be run and at the end of the process a compatibility report will be published as HTML file bot
in Artifactory and Jenkins.



## Generate report from local machine:

```bash
report.py --mlops_versions mlops-0.53 mlops-0.54 --dai_version=10.0.1 --repo="example-repo-local/dai" --artifactory_url="http://localhost:8081/artifactory" --artifactory_user=... --artifactory_password=...

```
You can also use make commands:
```bash
    make setup && make run
```
