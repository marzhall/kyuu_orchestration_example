# COUNTER ORCHESTRATION

## Kyuu Example

This is an example script of using the 
[kyuu message queue](https://github.com/marzhall/kyuu)
for organizing two "worker" threads.

## The setup

Running `./orchestrate.sh` will create three kyuus - `one`,
`two`, and `results.` It will also spin up two worker
processes, one polling on kyuu `one` for work, the other
polling on kyuu `two`.

## The workflow

The script then echoes a set of inputs from the file `inputs`
into `one.`

As the first worker polls for work, it takes these messages,
runs the shell script `dowork1.sh`, which runs a simple `sed
's/one/two/` on them, then takes the outpt and routes it to
kyuu `two`.

Worker two picks up these messages off of `two`, and runs a
similar script `dowork2.sh`. It runs the output of this into
the kyuu `results`.

## Observing the output

`cat results` will show the final messages, one at a time.
The input will have transformed from `1 one one, 2 one one`,
etc., into `1 two three, 2 two three`, etc. as a results of
having the `dowork` scripts run on it.

## Testing manually

Running `orchestrate.sh &` will spin off the worker thread
as a subprocess. Then, you can echo your own inputs to
`$KYUUPATH/one`, and the pipeline wil pick them up and
make the results available at the kyuu file`results`.

E.g.:

    $: echo "my_message one one" > $KYUUPATH/one
    $: cat results
    > my_message two three

Note: the test values will be in the queue ahead of your
test value. You can flush the queue using `kyuu -f results`,
so you don't have to cat the `results` file to pop all of
those messages.
