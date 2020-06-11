#/bin/sh
## Static Config

###Path config
REPOSITORY_PATH="$PRE_PATH/repositories"
TMP_LOG_FILE="/tmp/tmp_`date +%Y%M%S`"

###GitHub authentication config
GITHUB_NAME="memeda" # Name is needed to be compatible with git 1.7
GITHUB_PASSWD="" # if caring about security , it can be left to empty
AUTH="${GITHUB_NAME}:${GITHUB_PASSWD}@"
if [ -z "$GITHUB_PASSWD" ];then
    AUTH="${GITHUB_NAME}@"
fi

### Repository config
LTP_REPO_NAME="ltp"
LTP_REPO_PATH="$REPOSITORY_PATH/$LTP_REPO_NAME"
LTP_REPO_URL="https://${AUTH}github.com/memeda/ltp"
LTP_REPO_UPSTREAM_URL="https://github.com/HIT-SCIR/ltp"

LTPCWS_REPO_NAME="ltpcws"
LTPCWS_REPO_PATH="$REPOSITORY_PATH/$LTPCWS_REPO_NAME"
LTPCWS_REPO_URL="https://${AUTH}github.com/memeda/ltp-cws"
LTPCWS_REPO_UPSTREAM_URL="https://github.com/HIT-SCIR/ltp-cws"

### dependency file and keep stable file config
LTP_SUBPROJECT_DEPENDENCY_PATH="$LTP_REPO_PATH/subproject.d.json"
LTPCWS_KEEP_STABLE_PATH="$LTPCWS_REPO_PATH/keep_stable.txt"
