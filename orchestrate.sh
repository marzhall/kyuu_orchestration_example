#!/bin/bash

# Create the queues we'll be using to pass
# around inputs for business logic
kyuu one two

# Create a results queue that we can read, and
# dynamically link it to the current directory
# so we can easily inspect it
kyuu -l results

# Read file containing inputs line by line, and
# and send each line into the first chain in our
# message queue.
while IFS= read -r line
do
    echo $line
    echo $line > $KYUUPATH/one
done < inputs
echo done > $KYUUPATH/close1

echo spinning up worker 1
while true
do
    msg=`cat $KYUUPATH/one || true`
    if [[ -z $msg ]]
    then
        #msg=`cat $KYUUPATH/close1 || true`
        #if [[ $msg ]]
        #then
            #echo "worker one is done"
            #echo done > $KYUUPATH/close2
            #exit 0
        #fi

        sleep 2
        continue
    fi

    results=`echo "$msg" | ./dowork1.sh `
    echo $results  > $KYUUPATH/two
done &

echo spinning up worker 2
while true
do
    msg=`cat $KYUUPATH/two || true`
    if [[ -z $msg ]]
    then
        #msg=`cat $KYUUPATH/close2 || true`
        #if [[ $msg ]]
        #then
            #echo "worker two is done"
            #echo done > $KYUUPATH/close3
            #exit 0
        #fi

        sleep 2
        continue
    fi

    results=`echo "$msg" | ./dowork2.sh `
    echo $results  > $KYUUPATH/results
done &

echo Spinning in a main thread so the workers can do their thing.
while true; do
    #msg=`cat $KYUUPATH/close3 || true`
    #if [[ -z $msg ]]
    #then
        #sleep 2
    #fi

    #echo "Worker two finished - we're all done."
    
    # clean up our leftover queues.
    #kyuu -r one two close1 close2 close3 2>&1 1>/dev/null
    #exit 0
    sleep 2
done
