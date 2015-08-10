# if we run this code over remote session (like SSH)
# sync = true will force unbuffered (real time output)
$stdout.sync = true
$stderr.sync = true

require_relative '../lib/rainbow_time.rb'

RainbowTime.start