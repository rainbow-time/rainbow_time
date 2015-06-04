#!/bin/bash

# cp -r * /run/user/1000/gvfs/smb-share:server=zbox,share=rainbow_time
# ssh zbox 'cd c:\rainbow_time; bundle install'
scp -r * zbox:'c:\rainbow_time'
echo "done uploading!"
ssh zbox 'ruby c:\rainbow_time\bin\rainbow_time.rb'