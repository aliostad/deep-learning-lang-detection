#!/bin/sh
append() {                                                                                                                                                                                    local var="$1"                                                                                                                                                                        local value="$2"                                                                                                                                                                      local sep="${3:- }"                                                                                                                                                                   
    eval "export ${NO_EXPORT:+-n} -- \"$var=\${$var:+\${$var}\${value:+\$sep}}\$value\""                                                                                                  
}


append "aaa" "bbb"
append "aaa" "ccc" "xxx"
append "aaa" "ddd" "lll"
append "aaa" "eee"

echo $aaa
