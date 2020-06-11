#!/bin/bash
_load_mksh_list_dir_default=/usr/local/lib/mksh
# Zabezpieczenie przed parametrami do includujących tą bibliotekę skryptów
if [ -f $1/load_mksh.sh ] && [ -f $1/VERSION ]
	then
		_load_mksh_list_dir=${1}
	else 
		_load_mksh_list_dir=$_load_mksh_list_dir_default
fi
_load_mksh_list=`find $_load_mksh_list_dir -name '*.sh' -not -name load_mksh.sh -not -name README|sort`
for _load_mksh_module in $_load_mksh_list; 
	do
			#echo "Ładuję $_load_mksh_module"
			source $_load_mksh_module
			_load_mksh_basename=`basename $_load_mksh_module`
			is_function ${_load_mksh_basename}CheckDependencies
			if [ $? -eq 0 ]
				then
					${_load_mksh_basename}CheckDependencies
					if [ $? -ne 0 ]
							then
								echo "Błąd podczas ładowania modułu ${_load_mksh_basename}"
					fi
				else
					echo "Brak funkcji weryfikacji dla modułu ${_load_mksh_basename}"
			fi
done