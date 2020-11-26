#!/bin/bash

# Environment
. ./environment.sh

oc apply -f postgresql.yml
# Data Base for backend
oc new-app -e POSTGRESQL_USER=userTD0 -e POSTGRESQL_PASSWORD=UqcNw8Cw8fUoqpyx -e POSTGRESQL_DATABASE=sampledb --labels='app=postgresql' \
    centos/postgresql-10-centos7 --name=postgresql -n ${PROJECT_NAME}

oc label deployment/postgresql app.openshift.io/runtime=postgresql --overwrite -n ${PROJECT_NAME} && \
oc label deployment/postgresql app.kubernetes.io/part-of=${APP_NAME} --overwrite -n ${PROJECT_NAME} 

