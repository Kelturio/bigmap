#!/bin/sh

logf="make.log"

perl bigmap.pl 2>&1 | tee $logf

optipng -backup -v -verbose *.png 2>&1 | tee $logf
