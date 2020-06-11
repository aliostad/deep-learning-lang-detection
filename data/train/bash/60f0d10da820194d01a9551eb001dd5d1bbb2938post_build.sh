export REPO="$(pwd | sed s,^/home/travis/build/,,g)"
echo -e "Current Repo:$REPO --- Travis Branch:$TRAVIS_BRANCH"


GIT_USER_EMAIL="wesleyhales@gmail.com"
PROD_REPO="wesleyhales/wesleyhales.github.com"

#Set git user
git config --global user.email ${GIT_USER_EMAIL}
git config --global user.name "Travis"

#Set upstream remote
git remote add upstream https://${GH_TOKEN}@github.com/${REPO} > /dev/null
git remote add live https://${GH_TOKEN}@github.com/${PROD_REPO} > /dev/null

mkdir $HOME/temp_repo
git clone https://${GH_TOKEN}@github.com/${PROD_REPO} $HOME/temp_repo

cp -rf _site/* $HOME/temp_repo/

cd $HOME/temp_repo

git add -f .
git commit -m "add new site content"
git push https://${GH_TOKEN}@github.com/${PROD_REPO} master > /dev/null
