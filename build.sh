#!/bin/bash
#$(aws ecr get-login --no-include-email)
docker build -t postgresql_backup .
docker tag postgresql_backup:latest khteh/postgresql_backup:latest
docker push khteh/postgresql_backup:latest
