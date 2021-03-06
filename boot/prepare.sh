#!/bin/bash

# GPU Settings for Mining
export DISPLAY=:0
export GPU_MAX_ALLOC_PERCENT=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_SINGLE_ALLOC_PERCENT=100
export GPU_MAX_HEAP_SIZE=100
export GPU_FORCE_64BIT_PTR=1

# Screen Cleaning
clear
killall screen -9 &
screen -wipe &
clear
sleep 1

# Register Screen
screen -dm -S miner bash -c "/root/mrminer/boot/configure.sh"
