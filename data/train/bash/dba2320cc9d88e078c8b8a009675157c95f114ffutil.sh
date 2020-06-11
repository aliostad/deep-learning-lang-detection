
### useful utility function ###

#
# Simple Logging (ex. 2006-06-28 20:21:05 [foo.sh]: hoge hoge hoge)
#
# @param  msg   the message to be
#
log() {
    local msg=$*
    local timestamp=`date '+%Y-%m-%d %H:%M:%S'`
    local script_name=`basename $0`
    
    echo "${timestamp} [${script_name}] $msg"
}

#
# Multiple Process Control: limit number of command process concurrently
#
# @param  process_str    process string for GREP
# @param  max_process    max process number (default 10) 
# @param  sleep_time     sleep time(second) to wait (default 60)
#
multi_process_control() {
    local process_str=$1
    local max_process=$2
    local sleep_time=$3
    local process_num=0

    if [ -z $process_str ]; then
        return
    fi
    if [ -z $max_process ]; then
        max_process=10
    fi
    if [ -z $sleep_time ]; then
        sleep_time=60
    fi

    local get_process_num="ps auxwwwwwwwww | grep $process_str | grep -v grep | wc -l | sed 's/ //g'"
    eval process_num='$('$get_process_num')'
#    log "PROCESS & MAX => $process_num & $max_process"
    while [ $process_num -gt $max_process ]; do
        log "Too many process($process_num). Wait $sleep_time second..."
        sleep $sleep_time;
        eval process_num='$('$get_process_num')'
    done
}

#
# Sending Mail: 
#
# @param  mail_subject  mail subject (no required JIS encoding)
# @param  mail_body     mail body (no required JIS encoding)
# @param  to_addr       to addresses
# @param  from_addr     from address
#
send_mail() {
    local mail_subject=$1
    local mail_body=$2
    local to_addr=$3
    local from_addr=$4
    local NKF=/home/y/bin/nkf
    local MAIL=/usr/bin/mail

#    log "mail_subject: $mail_subject"#
#    log "mail_body: $mail_body"
#    log "to_addr: $to_addr"
#    log "from_addr: $from_addr"
    
    echo -e `echo $mail_body | $NKF -j` | $MAIL -s `echo $mail_subject | $NKF -j` $to_addr -f $from_addr
}