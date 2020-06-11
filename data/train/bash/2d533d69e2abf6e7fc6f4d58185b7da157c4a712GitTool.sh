#var
ip_list=`hostname -I`
name_repo=""
name_user=`whoami`
###
create_root_repository(){
	mkdir -p ~/GitRepo
}
create_sub_repo()
{
  echo "Git create repository"
  echo -n "Type name of Repository: "
  read name_repo
  mkdir -p ~/GitRepo/$name_repo
  mkdir -p ~/GitRepo/$name_repo/.git
  cd ~/GitRepo/$name_repo/.git
  git init --bare
  cd
}
get_remote_repo()
{
  #echo $ip_list
  for ip in ${ip_list[*]}
  do
    echo "Remote git access: $name_user@$ip:/GitRepo/$name_repo/.git"
  done
}
clone_repository(){
  echo -n "Type name repo: "
  read name_repo
  echo -n "Type address server: "
  read name_address
  mkdir -p ~/GitClone
  cd ~/GitClone
  git clone $name_address:GitRepo/$name_repo/.git
}
echo "Tool create repo server, clone private git server"
PS3="Select: "
options=("Create" "Clone" "Quit")
select opt in "${options[@]}"
do
    case $opt in
        "Create")
            create_sub_repo
            #echo "Create reop"
            get_remote_repo
            ;;
        "Clone")
            #echo "Clone repo"
            clone_repository
            ;;
        "Quit")
            break
            ;;
        *) echo invalid option;;
    esac
done
#get_remote_repo
#create_root_repository
