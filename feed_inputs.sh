#!/bin/bash
# Read file containing inputs line by line, and
# and send each line into the first chain in our
# message queue.
while IFS= read -r line
do
    echo $line
    echo $line > $KYUUPATH/one
done < inputs
