#!/bin/sh

citation=$(curl 'http://127.0.0.1:23119/better-bibtex/cayw?format=pandoc&brackets=1&clipboard=1')
sleep 0.1s
xdotool key "ctrl+v"
