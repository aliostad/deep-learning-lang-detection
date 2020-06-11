
# Define the regex for matching the arguments
regexArgShort='^-([a-zA-Z0-9])$'
regexArgShortChained='^-([a-zA-Z0-9]{2,})$'
regexArgLong='^--([a-zA-Z0-9\-]{2,})$'
regexArgLongWithValue='^--([a-zA-Z0-9\-]{2,})=(.*)$'

regexArgName="^([^= ]+)"
regexArgDefault='^[^= ]+=(.+)? -'
regexArgDesc='^.* - (.*)'

# Initialise some variables
declare -A argv;
argv=()
declare -A argd;
argd=()
declare -a argChunks
argChunks=()
declare -a parameters
parameters=()

lastWasArgument=0
lastArgument=""
endOfArguments=0

# Expand chained short form arguments, eg -aih => -a -i -h
for argChunk in "$@"; do

	# See if this argument is a chained short form argument
	[[ $argChunk =~ $regexArgShortChained ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then

		# Get the chunk or arguments
		chainedChunk="${BASH_REMATCH[1]}";

		[ "$ARG_DEBUG" == true ] && echo "Expanding chained argument chunk: $chainedChunk"

		i=0
		# Expand out the chunk into individual arguments
		while (( i++ < ${#chainedChunk} )); do

			# Get just the argument on its own
			argumentIsolated="${chainedChunk:$i-1:1}"

			# Add the isolated argument to the argument chunk array
			argChunks+=("-$argumentIsolated")
		done
		continue;
	fi

	# Add the argument to the argument array
	argChunks+=("$argChunk")
done

[ "$ARG_DEBUG" == true ] && echo "Expanded argument list: ${argChunks[@]}"

argGetName() {
	for k in "${!argExpected[@]}"
	do
		regexArg="\|($1)\|"
		[[ "|$k|" =~ $regexArg ]]
		if [ "${BASH_REMATCH[1]}" != "" ]; then

			[[ "${argExpected[$k]}" =~ $regexArgName ]]

			echo "${BASH_REMATCH[1]}"
			exit 0
		fi
	done

	# Check if the argument must be defined
	if [ "$ARG_MUST_BE_DEFINED" != false ]; then
		argUnexpected "$argChunk"
		exit 2
	fi

	# Default to using the argument as the name
	echo "$1"

	exit 1
}

argList() {
	echo "ARGUMENT SUMMARY:"
	for arguments in "${!argExpected[@]}"; do

		local argumentsPrefixed=()

		# Take all the arguments and prefix them with hyphens
		while IFS='|' read -ra argumentArray; do
			for argument in "${argumentArray[@]}"; do

				# Add the hyphens
				if [[ ${#argument} -gt 1 ]]; then
					argumentsPrefixed+=("--$argument")
				else
					argumentsPrefixed+=("-$argument")
				fi
			done
		done <<< "$arguments"

		local argumentList="${argumentsPrefixed[@]}"

		# Get the arguments description
		[[ "${argExpected[$arguments]}" =~ $regexArgDesc ]]
		local argumentDesc="${BASH_REMATCH[1]}"

		# Get the arguments default value
		[[ "${argExpected[$arguments]}" =~ $regexArgDefault ]]

		# Check if a default value could be found
		if [[ "${BASH_REMATCH}" != "" ]]; then
			local argumentDefault=" (default: '${BASH_REMATCH[1]}')"
		else
			local argumentDefault=""
		fi

		echo "	$(tput bold)$argumentList$(tput sgr0)"
		echo "		$argumentDesc $argumentDefault"
		echo
	done
}

argUnexpected() {
	echo "UNEXPECTED ARGUMENT $1"
}

argPassed() {
	if [ -z ${argv["$1"]+abc} ]; then
		return 1 # false
	else
		return 0 # true
	fi
}

argHasDefault() {
	if [ -z ${argd["$1"]+abc} ]; then
		return 1 # false
	else
		return 0 # true
	fi
}

argValue() {
	if argPassed "$1"; then
		echo "${argv["$1"]}"
		exit 0
	fi

	if argHasDefault "$1"; then
		echo "${argd["$1"]}"
	fi
}

argParseDefaults() {

	for arguments in "${!argExpected[@]}"; do
		[[ ${argExpected[$arguments]} =~ $regexArgDefault ]]

		if [[ "${BASH_REMATCH[@]}" == '' ]]; then
			continue;
		fi

		# Get the name of this argument
		local argumentName="$(argGetName "$arguments")"

		argd["$argumentName"]="${BASH_REMATCH[1]}"
	done
}


#
## Start parsing arguments
#

# Populate the argv array with the defaults
argParseDefaults

# Loop over all the argument chunks and determine if the argument type and value
for argChunk in "${argChunks[@]}"; do

	# Check if we've passed the last argument marker
	if [ $endOfArguments == 1 ]; then
		# Add this chunk to the array or parameters
		parameters+=("$argChunk")
		continue
	fi

	# Check if this chunk is the last argument marker
	if [ "$argChunk" == "--" ]; then
		endOfArguments=1
		continue;
	fi

	# Check if this chunk is a short form argument
	[[ $argChunk =~ $regexArgShort ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		argument="${BASH_REMATCH[1]}"
		lastWasArgument=1
		lastArgument="$argument"

		# Get the name of the argument
		argName="$(argGetName "$argument")"

		# Check we could get an argument, return code 2 means an error was returned
		if [ "$?" == "2" ]; then
			echo "$argName"
			exit 1
		fi

		# Add the argument to the arguments array
		argv["$argName"]=''

		[ "$ARG_DEBUG" == true ] && echo "Argument (short): ${BASH_REMATCH[1]}"

		continue;
	fi

	# Check if this chunk is a long form with value argument
	[[ $argChunk =~ $regexArgLongWithValue ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		argument="${BASH_REMATCH[1]}"
		lastArgument="$argument"

		# Get the name of the argument
		argName="$(argGetName "$argument")"

		# Check we could get an argument, return code 2 means an error was returned
		if [ "$?" == "2" ]; then
			echo "$argName"
			exit 1
		fi

		# Add the argument to the arguments array
		argv["$argName"]="${BASH_REMATCH[2]}"

		[ "$ARG_DEBUG" == true ] && echo "Argument (long with value): ${BASH_REMATCH[1]}=${BASH_REMATCH[2]}"

		continue;
	fi

	# Check if this chunk is a long form argument
	[[ $argChunk =~ $regexArgLong ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		argument="${BASH_REMATCH[1]}"
		lastWasArgument=1
		lastArgument="$argument"

		# Get the name of the argument
		argName="$(argGetName "$argument")"

		# Check we could get an argument, return code 2 means an error was returned
		if [ "$?" == "2" ]; then
			echo "$argName"
			exit 1
		fi

		# Add the argument to the arguments array
		argv["$argName"]=''

		[ "$ARG_DEBUG" == true ] && echo "Argument (long): ${BASH_REMATCH[1]}"

		continue;
	fi

	# If the last chunk was an argument and this wasn't assume its an argument value
	if [ $lastWasArgument == 1 ]; then

		# Get the name of the argument
		argName="$(argGetName "$lastArgument")"

		# Check we could get an argument, return code 2 means an error was returned
		if [ "$?" == "2" ]; then
			echo "$argName"
			exit 1
		fi

		# Add the arguments value to the arguments array
		argv["$argName"]="$argChunk"

		[ "$ARG_DEBUG" == true ] && echo "Argument Value: $argChunk"

		lastWasArgument=0
	fi
done

# Reassign the positional arguments to any that occurred after the end of arguments marker (--)
set -- ${parameters[@]}


[ "$ARG_DEBUG" == true ] && echo "Argument array:"
[ "$ARG_DEBUG" == true ] && for k in "${!argv[@]}"
do
	echo "ARG: $k = ${argv[$k]}"
done

# Add the standard argc variable containing the number of arguments
argc=${#argv[@]}

[ "$ARG_DEBUG" == true ] && echo "Argument Count: $argc"
