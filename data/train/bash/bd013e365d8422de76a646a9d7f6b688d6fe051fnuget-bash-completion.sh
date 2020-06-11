# Bash completion script for invoke-operation
#
# To use, run the following:
#   source `pwd`/nuget_bash_completion.sh

#default nuget actions
actions="
 delete 
 install 
 list 
 pack 
 publish 
 push 
 setApiKey
 sources
 spec
 update
 help
"
#action parameters that apply to all nuget actions
globalActions="
 -h 
 -Help 
 ?
"
#action parameters that apply to the delete action
deleteActions="
 -Source 
 -NoPrompt 
 -ApiKey
"
#action parameters that apply to the install action
installActions="
 -Source 
 -OutputDirectory 
 -Version 
 -ExcludeVersion 
 -Prerelease 
"
#action parameters that apply to the list action
listActions="
 -Source 
 -Verbose 
 -AllVersions 
 -Prerelease
"
#action parameters that apply to the pack action
packActions="
 -OutputDirectory    
 -BasePath           
 -Verbose            
 -Version            
 -Exclude          
 -Symbols            
 -Tool               
 -Build              
 -NoDefaultExcludes  
 -NoPackageAnalysis  
 -Properties       
"
#action parameters that apply to the publish action
publishActions="
 -Source
"
#action parameters that apply to the push action
pushActions="
 -CreateOnly 
 -Source     
 -ApiKey     
"
#action parameters that apply to the setApiKey action
setApiKeyActions="
 -Source
"
#action parameters that apply to the sources action
sourcesActions="
 -Name
 -Source
"
#action parameters that apply to the spec action
specActions="
 -AssemblyPath 
 -Force
"
#action parameters that apply to the update action
updateActions="
 -Source       
 -Id         
 -RepositoryPath 
 -Safe           
 -Self           
 -Verbose        
 -Prerelease    
"
#action parameters that apply to the help action
helpActions="
 -All 
 -Markdown
"
#directories where nuget packages can be found and used for auto completion when invoking the update action
nugetPackageDirectories="
./packages
${HOME}/.nuget/packages
"
# check for existence of package directories in common locations
# and parse the packages found in each directory, writing the name of the 
# package out as an auto complete option
_get_installed_package_names() {
	for dir in ${nugetPackageDirectories[*]}; do
		if test -d $dir; then 
			ls $dir | sed -e "s/\.dll//g"
		fi
	done
}

# invoke the action completion process on the array of words passed into the function
# from a calling member
_invoke_nuget_action_completion() {
	local cur="${COMP_WORDS[COMP_CWORD]}"
	local localActions="${@}"
	local opts=$(
		for o in ${localActions[*]}; do
			[[ " ${COMP_WORDS[*]} " =~ " $o " ]] || echo "$o"
		done
	)
	COMPREPLY=( $(compgen -W "${opts} ${globalActions}" -- "${cur}") )
	return
}

# invoke the initial action completion process on the current action 
_invoke_nuget_completion()
{
    local cur="${COMP_WORDS[COMP_CWORD]}"

    # Subcommand list
    [[ ${COMP_CWORD} -eq 1 ]] && {
        COMPREPLY=( $(compgen -W "${actions} ${allActions}" -- ${cur}) )
        return
    }

    # Find the previous non-switch word
    local prev_index=$((COMP_CWORD - 1))
    local prev="${COMP_WORDS[prev_index]}"
    while [[ $prev == -* ]]; do
        prev_index=$((--prev_index))
        prev="${COMP_WORDS[prev_index]}"
    done

    # take the action in the index just before the <tab> key press and call the 
    # _invoke_nuget_action_complete function with the related actions subactions 
    case "$prev" in
    # base commands for nuget
	help)
		_invoke_nuget_action_completion $actions
	;;
	test)
		_invoke_nuget_action_completion $testActions
	;;
        delete)
		_invoke_nuget_action_completion $deleteActions
        ;;
	install)
		_invoke_nuget_action_completion $installActions
	;;
	list)
		_invoke_nuget_action_completion $listActions
	;;
        pack)
                _invoke_nuget_action_completion $packActions
	;;
        publish)
		_invoke_nuget_action_completion $publishActions
        ;;
        pack)
		_invoke_nuget_action_completion $packActions        
        ;;
        push)
		_invoke_nuget_action_completion $pushActions                
        ;;
        setApiKey)
		_invoke_nuget_action_completion $setApiKeyActions        
        ;;
        sources)
		_invoke_nuget_action_completion $sourcesActions                
        ;;
        spec)
		_invoke_nuget_action_completion $specActions        
        ;;
        update)
        	_invoke_nuget_action_completion $updateActions $(_get_installed_package_names) 
	;;

	*)
        	return
        ;;
    esac
}

complete -o bashdefault -o default -F _invoke_nuget_completion nuget  
