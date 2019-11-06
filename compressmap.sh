#!/bin/sh

logf="optipng.log"
optipng -backup -v -verbose *.png 2>&1 | tee $logf
