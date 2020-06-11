#!/bin/sh

# 
# extcommtests-runner.sh: container-emulated, automated
#     ExternalInterface test generator
# 
# Copyright (C) 2015, 2016 Free Software Foundation, Inc.
# 
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA 
# 
# 
# Original author: Nutchanon Wetchasit <Nutchanon.Wetchasit@gmail.com>
# 
# The generated test runner checks Gnash for:
#  * ExternalInterface.addCallback() issues (bug #37223)
#        <https://savannah.gnu.org/bugs/?37223>
#  * ExternalInterface.call()'s delayed return value issue (bug #46131)
#        <https://savannah.gnu.org/bugs/?46131>
#  * Single-argument ExternalInterface.call() issue (bug #46878)
#        <https://savannah.gnu.org/bugs/?46878>
# 
# Usage:
#     ./extcommtests-runner.sh <builddir> <srcdir> <swf>
# 
# Exit codes:
#     0         if tester ran completely
#     non-zero  if tester encountered an error
# 
# Note:
#     The generated test file requires a filesystem that supports a named pipe.
# 

# Check for generation parameters
while getopts "" name
do
	case $name in
		?)
			echo "Usage: $0 <builddir> <srcdir> <swf>" >&2
			exit 1;;
	esac
done
shift $(($OPTIND - 1))
if [ "$#" -ne 3 ]
then
	echo "Usage: $0 <builddir> <srcdir> <swf>" >&2
	exit 1
fi

# Load generation parameters
top_builddir=$1
shift
top_srcdir=$1
shift
swf=$1

# Generate the test runner
echo "#!/bin/sh"
echo

echo "# Environment variables"
env | grep '^GNASH' | while read reply
do
	echo "export \"${reply}\""
done

timeout=10

cat << EOF

# Filenames and constants
LOGFILE=${top_builddir}/testoutlog.\$\$
PIPE2CONTAINER=${top_builddir}/tocontainer.\$\$
PIPE2PLAYER=${top_builddir}/toplayer.\$\$
READTIMEOUT=5

# Test counts
TESTED=0
FAILED=0
XFAILED=0
PASSED=0
XPASSED=0

# check_equals(\$op1, \$op2, \$msg)
# Equality checker and counter
check_equals() {
	if [ "\$1" = "\$2" ]
	then
		echo "PASSED: \$3"
		PASSED=\`expr "\$PASSED" + 1\`
	else
		echo "FAILED: \$3 (\"\$1\" != \"\$2\")"
		FAILED=\`expr "\$FAILED" + 1\`
	fi
	TESTED=\`expr "\$TESTED" + 1\`
}

# check_totals(\$op, \$msg)
# Test count checker
check_totals() {
	check_equals "\$TESTED" "\$1" "\$2"
}

# check_error(\$bool, \$msg)
# Assert \$bool is 0; if not, flag error in the test, and exit
check_error() {
	if [ "\$1" -ne 0 ]
	then
		echo "ERROR: \$2" >&2
		exit 1
	fi
}

# read_timeout(\$varname, \$timeout)
# Read one line from standard input, with a specified timeout (in seconds)
read_timeout() {
	trap 'trap - USR1; return 142' USR1
	(sleep "\$2" && kill -USR1 "\$\$" > /dev/null 2>&1) &
	TIMEOUTPID=\$!
	read "\$1"
	READERROR=\$?
	kill "\$TIMEOUTPID" > /dev/null 2>&1
	trap - USR1
	return \$READERROR
}

# Create required named pipes
if [ \! -p "\$PIPE2CONTAINER" ]
then
	mkfifo "\$PIPE2CONTAINER"
	check_error "\$?" "Failed to create a named pipe: \$PIPE2CONTAINER"
fi
if [ \! -p "\$PIPE2PLAYER" ]
then
	mkfifo "\$PIPE2PLAYER"
	check_error "\$?" "Failed to create a named pipe: \$PIPE2PLAYER"
fi

# Open player-to-host pipe
exec 3<> "\$PIPE2CONTAINER"
check_error \$? "Failed to open a named pipe: \$PIPE2CONTAINER"

# Open host-to-player pipe
exec 4<> "\$PIPE2PLAYER"
check_error \$? "Failed to open a named pipe: \$PIPE2PLAYER"

# Start player
"${top_builddir}/gui/gnash" -r 0 -t ${timeout} -vv -F 3:4 "${swf}" > "\$LOGFILE" 2>&1 &
GNASHPID=\$!

# Read for script_call callback registration statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="addMethod" returntype="xml"><arguments><string>script_call</string></arguments></invoke>' \
	"Gnash should properly register script_call ExternalInterface callback"

# Read for script_nothis1 callback registration statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="addMethod" returntype="xml"><arguments><string>script_nothis1</string></arguments></invoke>' \
	"Gnash should properly register script_nothis1 ExternalInterface callback"

# Read for script_nothis2 callback registration statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="addMethod" returntype="xml"><arguments><string>script_nothis2</string></arguments></invoke>' \
	"Gnash should properly register script_nothis2 ExternalInterface callback"

# Read for script_globalcheck callback registration statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="addMethod" returntype="xml"><arguments><string>script_globalcheck</string></arguments></invoke>' \
	"Gnash should properly register script_globalcheck ExternalInterface callback"

# Read for script_longarglist callback registration statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="addMethod" returntype="xml"><arguments><string>script_longarglist</string></arguments></invoke>' \
	"Gnash should properly register script_longarglist ExternalInterface callback"

# Read for js_simple JavaScript function invocation statement
read_timeout LINE \$READTIMEOUT <&3
check_equals \
	"\$LINE" \
	'<invoke name="js_simple" returntype="xml"><arguments><string>js_simple</string></arguments></invoke>' \
	"Gnash should call JavaScript's js_simple function correctly"

# Return string value from js_simple function
echo '<string>Correct</string>' >&4

# Test using multiple ExternalInterface.call() in row
NUMBER=1
for READING in "one" "two" "three" "four" "five" "six" "seven" "eight" "nine" \
	"ten" "eleven" "twelve" "thirteen" "fourteen" "fifteen"  "sixteen" \
	"seventeen" "eighteen" "nineteen" "twenty"
do
	# Read for js_readnumber JavaScript function invocation statement
	read_timeout LINE \$READTIMEOUT <&3
	check_equals \
		"\$LINE" \
		"<invoke name=\"js_readnumber\" returntype=\"xml\"><arguments><string>js_readnumber</string><number>\$NUMBER</number></arguments></invoke>" \
		"Gnash should call JavaScript's js_readnumber function with parameter \$NUMBER correctly"

	# Return string value from js_readnumber function
	echo "<string>\$READING</string>" >&4

	NUMBER=\`expr \$NUMBER + 1\`
done

# Pause a bit, so the next script_call invoke doesn't get mixed up with
# the previous return value data
sleep 1

# Call the script_call callback
echo '<invoke name="script_call" returntype="xml"><arguments><string>Hello</string><string>World</string></arguments></invoke>' >&4

# Read for callback return value statement
read_timeout LINE \$READTIMEOUT <&3
check_equals "\$LINE" '<string>Too</string>' "Gnash should return a correct value from script_call ExternalInterface callback"

# Call the script_nothis1 callback
echo '<invoke name="script_nothis1" returntype="xml"><arguments></arguments></invoke>' >&4

# Read for callback return value statement
read_timeout LINE \$READTIMEOUT <&3
check_equals "\$LINE" '<void/>' "Gnash should return a correct value from script_nothis1 ExternalInterface callback"

# Call the script_nothis2 callback
echo '<invoke name="script_nothis2" returntype="xml"><arguments></arguments></invoke>' >&4

# Read for callback return value statement
read_timeout LINE \$READTIMEOUT <&3
check_equals "\$LINE" '<void/>' "Gnash should return a correct value from script_nothis2 ExternalInterface callback"

# Call the script_globalcheck callback
echo '<invoke name="script_globalcheck" returntype="xml"><arguments></arguments></invoke>' >&4

# Read for callback return value statement
read_timeout LINE \$READTIMEOUT <&3
check_equals "\$LINE" '<void/>' "Gnash should return a correct value from script_globalcheck ExternalInterface callback"

# Call the script_longarglist callback
echo '<invoke name="script_longarglist" returntype="xml"><arguments><string>The</string><string>quick</string><string>brown</string><string>fox</string><string>jumps</string><string>over</string><string>the</string><string>lazy</string><string>dog</string></arguments></invoke>' >&4

# Read for callback return value statement
read_timeout LINE \$READTIMEOUT <&3
check_equals "\$LINE" '<string>Pangram</string>' "Gnash should return a correct value from script_longarglist ExternalInterface callback"

# Close pipes
exec 3<&-
exec 4<&-

# Wait for Gnash to exit
wait \$GNASHPID
check_equals "\$?" "0" "Gnash should terminate successfully"

# Show player-side output
exec 5< "\$LOGFILE"
cat <&5
exec 5<&-

# Include total number of tests from player side
exec 5< "\$LOGFILE"
PLAYERPASSED=\`grep "TRACE: PASSED:" <&5 | wc -l\`
exec 5<&-
exec 5< "\$LOGFILE"
PLAYERXPASSED=\`grep "TRACE: XPASSED:" <&5 | wc -l\`
exec 5<&-
exec 5< "\$LOGFILE"
PLAYERFAILED=\`grep "TRACE: FAILED:" <&5 | wc -l\`
exec 5<&-
exec 5< "\$LOGFILE"
PLAYERXFAILED=\`grep "TRACE: XFAILED:" <&5 | wc -l\`
exec 5<&-
PASSED=\`expr "\$PASSED" + "\$PLAYERPASSED"\`
XPASSED=\`expr "\$XPASSED" + "\$PLAYERXPASSED"\`
FAILED=\`expr "\$FAILED" + "\$PLAYERFAILED"\`
XFAILED=\`expr "\$XFAILED" + "\$PLAYERXFAILED"\`
TESTED=\`expr "\$TESTED" + "\$PLAYERPASSED" + "\$PLAYERXPASSED" + "\$PLAYERFAILED" + "\$PLAYERXFAILED"\`

# Check for total number of test run
check_totals "94" "There should be 94 tests run"

# Remove temporary files
rm "\$LOGFILE"
rm "\$PIPE2CONTAINER"
rm "\$PIPE2PLAYER"
EOF
