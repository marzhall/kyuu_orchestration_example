# COUNTER ORCHESTRATION

## Kyuu Example

This is an example script of using the 
[kyuu message queue](https://github.com/marzhall/kyuu)
for organizing two "worker" threads.

## The setup

Running `./setup.sh` will create three kyuus - `one`,
`two`, and `results.`

Next, `./start_pipeline` will spin up two worker processes:
one polling on kyuu `one` for work and writing its output
to kyuu two, the other polling on kyuu `two` for work and
writing its results to kyuu `results`.

## The workflow

The individul scripts called by orchestrate.sh send a message
through a pipeline that runs the `sed` command on the message,
replacing the second and third word in the input commands with
"hello" and "world."

The beginning of a 'job' starts with sending a message into
kyuu `one`, on which the first worker process listens.
`./feed_inputs.sh`, in our case, `echoes` a set of inputs
from the file `inputs` into kyuu `one.`

As the first worker polls for work, it takes these messages
and runs the shell script `dowork1.sh` on them. `dowork1.sh`
uns a simple `sed 's/one/two/` on the messages, then takes
the outpt and routes it to kyuu `two`.

Worker two picks up these messages off of `two`, and runs a
similar script `dowork2.sh`. It runs the output of this into
the kyuu `results`.

## Observing the output

`cat results` will show the final messages, one at a time.
`kyuu -fv results` will dump all of the messages at once.
The input will have transformed from `1 one one, 2 one one`,
etc., into `1 hello world, 2 hello world`, etc. as a results
of having the `dowork*` scripts run on it.

## Testing manually

Running `setup.sh` will start up the kyuuD and creates the
kyuus used by the pipeline we're using.

Running `./start_pipeline.sh &` will spin off the worker
threads as subprocesses.

Then, you can echo your own inputs to `$KYUUPATH/one`, and
the pipeline wil pick them up and make the results available
at the kyuu file `results`. `cat results`, then, should let
you see them!

E.g.:

    $: ./setup.sh
    $: ./start_pipeline.sh
    $: echo "my_message one one" > $KYUUPATH/one
    $: echo "my_message2 one one" > $KYUUPATH/one
    $: cat results
    > my_message two three
    $: cat results
    > my_message2 two three
