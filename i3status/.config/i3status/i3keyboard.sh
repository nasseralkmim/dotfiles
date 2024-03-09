#!/bin/bash

# shell scipt to prepend i3status with more stuff
# need to install "yay xkblayout-state-git"

i3status | while :
do
        read line
        LG=$(xkblayout-state print %s) 
        echo "LG: $LG | $line" || exit 1
done
