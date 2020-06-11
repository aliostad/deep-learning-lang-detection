#!/bin/bash
ARTIFACTS_DIR=/tmp/artifacts

EASYTRAVEL_REPO_DIR={{ easytravel_git_repo_dir }}
EASYTRAVEL_BB_DEPLOY_PLAYBOOK_REPO_DIR={{ easytravel_business_backend_deploy_playbook_git_repo_dir }}
EASYTRAVEL_CF_DEPLOY_PLAYBOOK_REPO_DIR={{ easytravel_customer_frontend_deploy_playbook_git_repo_dir }}

mkdir -p $ARTIFACTS_DIR

# easyTravel (full build required)
cd $EASYTRAVEL_REPO_DIR/Distribution && ant

# Customer Frontend: test
cd $EASYTRAVEL_REPO_DIR/TravelTest && ant -Dtestpattern=frontend/**/*Test

# Customer Frontend: build
cd $EASYTRAVEL_REPO_DIR/CustomerFrontend && ant war
cp $EASYTRAVEL_REPO_DIR/Distribution/dist/customer/customer.war /tmp/artifacts

# Customer Frontend: deploy
$EASYTRAVEL_CF_DEPLOY_PLAYBOOK_REPO_DIR/deploy.sh $ARTIFACTS_DIR

# Business Backend: test
cd $EASYTRAVEL_REPO_DIR/TravelTest && ant -Dtestpattern=business/**/*Test

# Business Backend: build
cd $EASYTRAVEL_REPO_DIR/BusinessBackend && ant war
cp $EASYTRAVEL_REPO_DIR/Distribution/dist/business/business.war /tmp/artifacts

# Business Backend: deploy
$EASYTRAVEL_BB_DEPLOY_PLAYBOOK_REPO_DIR/deploy.sh $ARTIFACTS_DIR
