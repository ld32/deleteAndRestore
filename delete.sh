#!/bin/bash

set -ex 

cat delete.cmd | xargs -I {} -P 4 sh -c "{}"