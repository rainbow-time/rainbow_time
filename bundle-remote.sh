#!/bin/bash

scp -r * zbox:'c:\rainbow_time'
echo "done uploading!"
ssh zbox 'cd c:\rainbow_time; bundle install'
