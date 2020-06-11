#!/bin/bash

header "Repo"

test_success "repo list by org, env, and content view" repo list --org="$TEST_ORG" --environment="$TEST_ENV" --content_view="$TEST_VIEW"
test_success "repo list by org only" repo list --org="$TEST_ORG"
test_success "repo list by org and product" repo list --org="$TEST_ORG" --product="$FEWUPS_PRODUCT"
test_failure "repo list by org and unknown product" repo list --org="$TEST_ORG" --product="UNKNOWN_PRODUCT"
REPO_ID=$(get_repo_id)
test_success "repo status" repo status --id="$REPO_ID"
test_success "repo synchronize" repo synchronize --id="$REPO_ID"

PACKAGE_URL="https://$SERVICES_HOST/pulp/repos/$TEST_ORT/$TEST_ORG/Library/$FEWUPS_PRODUCT/$REPO_NAME/lion-0.3-0.8.noarch.rpm"
REPO_STATUS_CODE=`curl "$PACKAGE_URL" -k --write-out '%{http_code}' -s -o /dev/null`
if [ "$REPO_STATUS_CODE" != '403' ]; then
  msg_status "repo secured" "${txtred}FAILED${txtrst}"
  echo "We expected the pulp repo to be secured (status code 403), got $REPO_STATUS_CODE"
  let failed_cnt+=1
fi

# puppet repo test
PUPPET_REPO_NAME="puppet_${FEWUPS_REPO}"
PUPPET_REPO_URL="http://davidd.fedorapeople.org/repos/random_puppet/"
test_success "puppet repo create" repo create --org="$TEST_ORG" --name="$PUPPET_REPO_NAME" --url="$PUPPET_REPO_URL" --label="$PUPPET_REPO_NAME" --content_type=puppet --product="$FEWUPS_PRODUCT"
test_success "puppet repo synchronize" repo synchronize --org="$TEST_ORG" --name="$PUPPET_REPO_NAME" --product="$FEWUPS_PRODUCT"

CVD_NAME="puppet_cvd"
CV_NAME="puppet_view"
test_success "content definition create ($CVD_NAME)" content definition create --org="$TEST_ORG" --name="$CVD_NAME"
test_success "content definition add_repo ($PUPPET_REPO_NAME to $CVD_NAME)" content definition add_repo --org="$TEST_ORG" --name="$CVD_NAME" --product=$FEWUPS_PRODUCT --repo="$PUPPET_REPO_NAME"
test_success "content definition publish ($CVD_NAME to $CV_NAME)" content definition publish --org=$TEST_ORG --label=$CVD_NAME --view_name=$CV_NAME
test_success "content view promote ($CV_NAME to $TEST_ENV)" content view promote --org="$TEST_ORG" --name="$CV_NAME" --env="$TEST_ENV"
test_success "content view refresh ($CV_NAME)" content view refresh --org="$TEST_ORG" --name="$CV_NAME"
