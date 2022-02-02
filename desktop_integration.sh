#!/bin/bash

echo 'Shortcut name:'
read NAME

echo 'Executable path:'
read EXECU

echo 'Icon path:'
read ICO

chmod +x $EXECU

cd /usr/share/applications

cat <<EOF | tee $NAME.desktop
[Desktop Entry]
Type=Application
Encoding=UTF-8
Name=$NAME
Comment=$NAME
Exec=$EXECU
Icon=$ICO
Terminal=false
EOF


