#!/bin/bash

# Environment
. ./environment.sh

CURRENT_DIR=$(pwd)

oc project ${PROJECT_NAME}

if [ ! -d ${CURRENT_DIR}/rest-advice/ ];
then
git clone git@github.com:lcanon/rest-advice.git
fi

cd ${CURRENT_DIR}/rest-advice/
git pull
./mvnw quarkus:add-extension -Dextensions="openshift"
./mvnw clean package -Dquarkus.kubernetes.deploy=true

# Labels
oc label dc/rest-advice app.openshift.io/runtime=java --overwrite -n ${PROJECT_NAME} && \
oc label dc/rest-advice app.openshift.io/runtime-version=8 --overwrite -n ${PROJECT_NAME} && \
oc label dc/rest-advice app.kubernetes.io/part-of=${APP_NAME} -n ${PROJECT_NAME} --overwrite

# Annotates
oc annotate dc/rest-advice app.openshift.io/connects-to=postgresql --overwrite

cd ${CURRENT_DIR}
