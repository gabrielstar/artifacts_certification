# Arty + Jenkins

## Configure Artifactory

Note: for plugins support Artifactory Pro is required.

```bash
 sh install_arty.sh
 sh start_arty.sh
```

Login with default admin credentials `admin:password`
By default there is `example-repo-local` repository we can use.

Install Arty Webhook plugin (assume jenkins run on port 8085)
```bash
    cd webhook-arty
    sh install.sh
```

## Configure Jenkins

```bash
    docker compose up
```
Open browser at localhost:8085 and install suggested plugins. Configure `user:pass` as credentials.
After that, go to Jenkins->Manage Plugins and install Generic Webhook Trigger plugin


## Install webhook plugin

```bash
cd webhook-arty
sh install.sh
```
