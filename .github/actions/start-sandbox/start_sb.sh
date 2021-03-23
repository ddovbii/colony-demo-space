#!/bin/bash

VAL=`echo $((1 + $RANDOM % 100))`

echo "::set-output name=sandbox-id::$(echo $VAL)"
