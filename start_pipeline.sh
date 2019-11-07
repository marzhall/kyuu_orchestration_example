#!/bin/bash

echo spinning up worker 1
while true
do
    poll_exec $KYUUPATH/one $KYUUPATH/two "./dowork1.sh"
done &

echo spinning up worker 2
while true
do
    poll_exec $KYUUPATH/two $KYUUPATH/results "./dowork2.sh"
done &

echo Spinning in a main thread so the workers can do their thing.
while true; do
    sleep 2
done
