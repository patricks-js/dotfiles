#!/bin/bash

pidof -q eww || { eww -c "$HOME"/.config/eww daemon & }
