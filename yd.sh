#!/bin/bash
read -p "Please input URL:" Str
echo "¡¾1¡¿show all formats"
echo "¡¾2¡¿download directly"
read -p "Please select(default 1):" a
if [ $a == 1 ]
then
youtube-dl -F "$Str"
fi
if [ $a == 2 ]
then
read -p "Please input a format(default best):" b
if [ -z $b ]:
youtube-dl -o "/home/%(title)s.%(ext)s" "$Str"
else
youtube-dl -o "/home/%(title)s.%(ext)s" -f $b "$Str"
fi
echo "Now you can download it from 45.77.101.200:8000"
u
fi
