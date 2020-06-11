#!/bin/sh
SCRIPT_DIR=$(cd $(dirname $0); pwd)

cd ${SCRIPT_DIR}
sh sample/sample.sh >sample/sample.out 2>&1
ST=$?
git add --force sample/sample.out
git commit -m "[ci skip] submit result (status=${ST})" --allow-empty
git branch -D maybe_detatched 2>/dev/null
git checkout -b maybe_detatched
git checkout -
git merge - --ff

# - 実行した結果、ファイルに変更がない場合でもコミットを投げる
# - コミットがdetatchedになったりするのでそれ用のブランチが必要

exit ${ST}
