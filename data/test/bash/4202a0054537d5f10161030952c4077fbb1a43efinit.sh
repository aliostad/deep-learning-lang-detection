#!/usr/bin/env sh

echo "Your Github Username: "
read username
while [[ "$username" == "" ]]; do
	echo "Your Github Username: (must input)"
	read username
done

echo "The dir to store your repos: [repos]"
read dir_repo
if [[ "$dir_repo" == "" ]]; then
	repo="repos"
fi

echo "Press enter to proceed with the configs:"
echo "	username: $username"
echo "	dir_repo: $dir_repo"
echo "Or ^+c to end"

read tmp

mkdir -p conf
cat > conf/conf.sh <<EOF
#!/usr/bin/env sh
username="$username"
dir_repo="$repo"
EOF

exit 0
