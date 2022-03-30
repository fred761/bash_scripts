#!/bin/bash

dnf install gdm
systemctl enable gdm
systemctl set-default graphical.target
