#!/bin/bash
set -m

/rule-update.sh &
/spamd.sh &

pids=`jobs -p`

exitcode=0

# kindly ask my children to exit
function terminate() {
    # unbind handler
    trap "" CHLD
    # iterate over previously captured PIDs,
    # each identifying a process
    for pid in $pids; do
        # check whether we have permission to
        # kill that process, and if we do not
        # wait for that process to end
        # if we have permission, loop simply
        # continues
        if ! kill -0 $pid 2>/dev/null; then
            wait $pid
            exitcode=$?
        fi
    done

    # if we are here, we have permission to
    # kill all processes identified by $pids
    kill $pids 2>/dev/null
    kill ${!}
    # wait until all children have gone
    wait
}

# CHLD-handler
function term_child_handler() {
    terminate
    exit $exitcode
}

# SIGTERM-handler
function term_handler() {
    terminate
    exit 143; # 128 + 15 -- SIGTERM
}

# setup handlers

# does one if the child processes exit?
trap term_child_handler CHLD

# on callback, kill the background process,
# which is `tail -f /dev/null` and execute the specified handler
trap 'kill ${!}; term_handler' SIGTERM

# wait forever
while true
do
    tail -f /dev/null & wait ${!}
done

exit $exitcode
