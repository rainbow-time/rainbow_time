#!/bin/bash

scp -r * zbox:'c:/rainbow_time'
echo "SCP finished uploading!"

ssh zbox 'cd c:\rainbow_time; bundle install'
