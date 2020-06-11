#!/bin/sh

echo repo = $repo
echo CODE_MAAT = $CODE_MAAT
echo REPO_DATA_DIR = $REPO_DATA_DIR

types=( \
      abs-churn
      age \
      author-churn \
      authors \
      communication \
      coupling \
      entity-churn \
      entity-effort \
      entity-ownership \
      fragmentation \
      identity \
      main-dev \
      main-dev-by-revs \
      refactoring-main-dev \
      revisions \
      soc \
      summary \
)
echo -e "\e[92mExtracting data from ${repo}\e[0m"
echo $repo > $REPO_DATA_DIR/repo.csv
for type in "${types[@]}"; do
  echo -e "\e[92m  Calculating ${type} metric\e[0m"
  $CODE_MAAT -l $REPO_DATA_DIR/evo.log -c git -a $type -o $REPO_DATA_DIR/$type.csv
done;
