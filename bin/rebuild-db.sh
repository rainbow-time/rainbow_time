#!/bin/sh
rm db/rainbow.db
sequel sqlite://db/rainbow.db db/schema.rb -E
