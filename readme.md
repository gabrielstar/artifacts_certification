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
After that, go to Jenkins->Manage Plugins and install Generic Webhook Trigger plugin


## Jenkins pipeline

At this stage whenever an artifact gets deployed to Artifactory a Hook API call will be sent to Jenkins to notify it of an event.
Now it is time for Jenkins pipeline.