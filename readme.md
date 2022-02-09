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

Install Arty Webhook plugin (assume jenkins run on port 8085) that will be notyfying Jenkins on artifacts deployment
```bash
    cd webhook-arty
    sh install.sh
```

You can verify it all works by trying to [upload a test artifact](testing/test_deploy.sh)

# Configure Jenkins

```bash
    docker compose up
```
Open browser at localhost:8085 and install suggested plugins. Configure `user:pass` as credentials.
After that, go to Jenkins->Manage Plugins and install:
- Generic Webhook Trigger plugin
- HTML Publisher plugin


## Jenkins pipeline

At this stage whenever an artifact gets deployed to Artifactory a Hook API call will be sent to Jenkins to notify it of an event.
Now it is time for Jenkins pipeline.

* First, create new Pipeline job from [DAICertificationTestforMLOPS.Jenkinsfile](ci/DAICertificationTestforMLOPS.Jenkinsfile) with a name of
"DAI Artifact Certification Test for MLOPS"
* Second, create new Pipeline job from [CertificationJob.Jenkinsfile](ci/CertificationJob.Jenkinsfile)
with a name of "Pipeline Certification-Job"

Now, deploy an artifact to Arty with [test_deploy.sh](testing/test_deploy.sh). You should see Arty notyfying Jenkins and on successful 
jobs, artifact properties will be updated.



## Generate report

```bash
report.py --mlops_versions mlops-0.53 mlops-0.54 --dai_version=10.0.1 --repo="example-repo-local/dai" --artifactory_url="http://localhost:8081/artifactory" --artifactory_user=... --artifactory_password=...

```
You can also use make commands:
```bash
    make setup && make run
```