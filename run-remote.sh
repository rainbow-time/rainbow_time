#!/bin/bash

scp -r * 'zbox:c:/rainbow_time'
echo "SCP finished uploading!"

ssh zbox 'ruby c:\rainbow_time\bin\rainbow_time.rb' 
