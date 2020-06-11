#! /bin/sh

echo "TEST connecting to a wiki and editing using the api.php interface"

# Edit these variables, especially first three
export WIKI_USERNAME='USER-NAME'
export WIKI_PASSWORD='USER-PASSWORD'
export WIKI_API='http://docs.webplatform.org/t/api.php'
export PAGE='Tests/javascript-a'
export PAGE_URLENCODED='Tests%2Fjavascript-a'
export CONTENT='Sample page contents: '$(mktemp --dry-run)
export SUMMARY='Automated test edit'
export LOG_FILE='LOG.txt'
export RESULT_FILE='RESULT.txt'
export COOKIE_FILE='COOKIES.txt'

function append ()
{
    echo "$1" >> "$LOG_FILE"
}

function appendfile ()
{
    cat "$1" >> "$LOG_FILE"
}

function showbanner ()
{
    echo
    echo "----------------------------------------------------------------------"
    echo "$1"
    echo "----------------------------------------------------------------------"
}

function showoutput ()
{
    cat "$LOG_FILE"
}

#======================================================================
# Login
#======================================================================

# New log file for this request
showbanner "Login request"
echo -n > "$LOG_FILE"

# Empty the cookie file
echo -n > "$COOKIE_FILE"
append "EMPTIED cookie jar"
append ""

# Post request
append "POST to $WIKI_API"
append ""
append "PARAMETERS:"
append "    action=login"
append "    lgname=$WIKI_USERNAME"
append "    lgpassword=$WIKI_PASSWORD"
append "    format=json"
append ""
curl -s --show-error -i "$WIKI_API" -d action=login -d "lgname=$WIKI_USERNAME" -d "lgpassword=$WIKI_PASSWORD" -d format=json -b "$COOKIE_FILE" -c "$COOKIE_FILE" > "$RESULT_FILE"
append "HTTP dump:"
append ""
appendfile "$RESULT_FILE"
append ""
append ""

# Verify last result
if ! grep -q '"result":"NeedToken"' "$RESULT_FILE"; then
    append ""
    append 'FAILURE, did not find: "result":"NeedToken"'
    append ""
    append 'EXPECTED something like: {"login":{"result":"NeedToken"'
    showoutput
    exit 1
fi
# Get token from last result
export TOKEN=$(grep "^{" "$RESULT_FILE" | sed 's/^.*"token":"\([^"]*\)".*$/\1/')
if [ -z "$TOKEN" ]; then
    echo "Unable to find token"
    exit 1
fi
append ""
append "EXTRACTED TOKEN:"
append "    $TOKEN"
showoutput

#======================================================================
# Verify login using login/token from previous output
#======================================================================

# New log file for this request
showbanner "Login verification"
echo -n > "$LOG_FILE"

# Post verification
append "POST to $WIKI_API"
append ""
append "PARAMETERS:"
append "    action=login"
append "    lgname=$WIKI_USERNAME"
append "    lgpassword=$WIKI_PASSWORD"
append "    lgtoken=$TOKEN"
append "    format=json"
append ""
curl -s --show-error -i "$WIKI_API" -d action=login -d "lgname=$WIKI_USERNAME" -d "lgpassword=$WIKI_PASSWORD" -d "lgtoken=$TOKEN" -d format=json -b "$COOKIE_FILE" -c "$COOKIE_FILE" > "$RESULT_FILE"
append "HTTP dump:"
append ""
appendfile "$RESULT_FILE"
append ""
append ""

# Verify last result
if ! grep -q '"result":"Success"' "$RESULT_FILE"; then
    append ""
    append 'FAILURE, did not find: "result":"Success"'
    append ""
    append 'EXPECTED something like: {"login":{"result":"Success"'
    showoutput
    exit 1
fi

append ""
append "SUCCESSFULLY VERIFIED LOGIN"
showoutput

#======================================================================
# Get an edit token
#======================================================================

# New log file for this request
showbanner "Obtain edit token"
echo -n > "$LOG_FILE"

# Query for edit token
append "GET from $WIKI_API"
append ""
append "PARAMETERS:"
append "    action=query"
append "    prop=info"
append "    intoken=edit"
append "    titles=${PAGE}"
append "    format=json"
append ""
append "ACTUAL URL:"
append "    ${WIKI_API}?action=query&prop=info&intoken=edit&titles=${PAGE_URLENCODED}&format=json"
append ""
curl -s --show-error -i "${WIKI_API}?action=query&prop=info&intoken=edit&titles=${PAGE_URLENCODED}&format=json" -b "$COOKIE_FILE" -c "$COOKIE_FILE" > "$RESULT_FILE"
append "HTTP dump:"
append ""
appendfile "$RESULT_FILE"
append ""
append ""

# Verify last result
if ! grep -q '{"query":{"pages"' "$RESULT_FILE"; then
    append ""
    append 'FAILURE, did not find: {"query":{"pages"'
    append ""
    showoutput
    exit 1
fi

# Get edit token from last result (unescape JSON "\\" into "\")
export EDIT_TOKEN=$(grep "^{" "$RESULT_FILE" | sed 's/^.*"edittoken":"\([^"]*\)".*$/\1/' | sed 's/\\\\/\\/g')
if [ -z "$EDIT_TOKEN" ]; then
    echo "Unable to find edit token"
    exit 1
fi
append ""
append "EXTRACTED EDIT TOKEN:"
append "    $EDIT_TOKEN"
showoutput

#======================================================================
# Perform actual page edit
#======================================================================

# New log file for this request
showbanner "Perform page edit"
echo -n > "$LOG_FILE"

# Post edit
append "POST to $WIKI_API"
append ""
append "PARAMETERS:"
append "    action=edit"
append "    title=${PAGE}"
append "    summary=${SUMMARY}"
append "    text=${CONTENT}"
append "    bot=1"
append "    watchlist=nochange"
append "    token=${EDIT_TOKEN}"
append "    format=json"
append ""
curl -s --show-error -i "${WIKI_API}" -d action=edit -d "title=$PAGE" -d "summary=$SUMMARY" -d "text=$CONTENT" -d bot=1 -d watchlist=nochange --data-urlencode "token=$EDIT_TOKEN" -d format=json -b "$COOKIE_FILE" -c "$COOKIE_FILE" > "$RESULT_FILE"
append "HTTP dump:"
append ""
appendfile "$RESULT_FILE"
append ""
append ""

# Verify last result
if ! grep -q '"result":"Success"' "$RESULT_FILE"; then
    append ""
    append 'FAILURE, did not find: "result":"Success"'
    append ""
    append 'EXPECTED something like: {"login":{"result":"Success"'
    showoutput
    exit 1
fi

showoutput

#======================================================================
# Logout
#======================================================================

# New log file for this request
showbanner "Logout"
echo -n > "$LOG_FILE"

# Post logout
append "POST to $WIKI_API"
append ""
append "PARAMETERS:"
append "    action=logout"
append "    format=json"
append ""
curl -s --show-error -i "$WIKI_API" -d action=logout -d format=json -b "$COOKIE_FILE" -c "$COOKIE_FILE" > "$RESULT_FILE"
append "HTTP dump:"
append ""
appendfile "$RESULT_FILE"
append ""
append ""

# Verify last result
if ! grep -q "\[\]" "$RESULT_FILE"; then
    append ""
    append "FAILURE, did not find: \[\]"
    append ""
    showoutput
    exit 1
fi

append ""
append "SUCCESSFULLY LOGGED OUT"
showoutput

#======================================================================
# Success
#======================================================================

showbanner "SUCCESS"
