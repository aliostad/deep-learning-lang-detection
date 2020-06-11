url=$1
name=$(basename $url .git)
repos_path=~/repos
repo_path=$repos_path/$name

echo Processing $repo
rvm reload

echo Cloning into $repo_path

if [ -d $repo_path ]
then
  echo "$repo_path already exists, deleting"
  rm -rf $repo_path
fi

cd $repos_path
git clone $url

rvmrc=$repo_path/.rvmrc

echo "Checking for $rvmrc"

if [ -f $rvmrc ]
then
  echo "Using provided .rvmrc"
else
  rvm use 1.8.7@$name
fi

cd $repo_path

echo "Now in $(pwd)"

echo "Running bundle"
bundle --system

echo "Running rake"
rake --verbose
