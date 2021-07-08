# Bitnami Docker Image for OpenCart

## What is OpenCart?

....

https://github.com/bitnami/bitnami-docker-opencart
https://github.com/bitnami/bitnami-docker-opencart/issues/98 - heroes

### before start create persistence folders
```
mkdir opencart_data
sudo chown 1001:root opencart_data
mkdir opencart_storage_data
sudo chown 1001:root opencart_storage_data
```
### let's start
docker-compose up