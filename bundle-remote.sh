#!/bin/bash

scp -r * zbox:'c:\rainbow_time'
echo "done uploading!"

# -t makes output print immediately
ssh -t zbox 'cd c:\rainbow_time; bundle install'
