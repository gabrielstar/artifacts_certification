# Arty + Jenkins

Docker compoase for Arty is available at:

    https://jfrog.com/download-jfrog-platform/

## Start services
```sh
docker compose-up
docker container ls --format 'table {{.ID}}\t{{.Names}}\t{{.Image}}\t{{.Status}}'
docker compose-down
```

## Configure Artifactory