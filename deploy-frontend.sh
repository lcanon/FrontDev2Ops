#!/bin/bash

# Environment
. ./environment.sh

CURRENT_DIR=$(pwd)

oc project ${PROJECT_NAME}

if [ ! -d ${CURRENT_DIR}/frontend/ ];
then
git clone git@github.com:lcanon/nodejs-ex.git
fi

cd ${CURRENT_DIR}/frontend/
git pull
npm install
npm run openshift

# Labels
oc label dc/nodejs-ex app.openshift.io/runtime=nodejs --overwrite -n ${PROJECT_NAME} && \
oc label dc/nodejs-ex app.kubernetes.io/part-of=${APP_NAME} -n ${PROJECT_NAME} --overwrite

# Annotates

oc annotate dc/nodejs-ex app.openshift.io/connects-to=rest-advice --overwrite && \
oc annotate dc/nodejs-ex app.openshift.io/connects-to=rest-user --overwrite && \
oc annotate dc/nodejs-ex app.openshift.io/connects-to=rest-goals --overwrite

cd ${CURRENT_DIR}

oc apply -f route-nodejs.yaml