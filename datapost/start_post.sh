#!/bin/sh

# start web

nohup /usr/local/post/datapost_daemon/datapost >/tmp/datapost.log 2>&1 &
