echo Starting kyuuD and creating our kyuus
./setup.sh

echo Starting our worker pipeline and giving it a second to come up
./start_pipeline.sh &
sleep 1

echo Feeding 10 inputs to our first kyuu, and giving the queue some
echo time to do work...
./feed_inputs.sh
sleep 4

echo The results are!
kyuu -fv results

echo Killing kyuuD and cleaning up the leftover symlink
./cleanup.sh
