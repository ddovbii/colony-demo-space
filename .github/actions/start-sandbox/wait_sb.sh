#!/bin/bash

WAIT=`echo $((1 + $RANDOM % 15))`

sleep $WAIT

echo "Sandbox ID is ${SANDBOX_ID}"
