#!/bin/bash

# Create the queues we'll be using to pass
# around inputs for business logic
kyuu one two

# Create a results queue that we can read, and
# dynamically link it to the current directory
# so we can easily inspect it
kyuu -l results
