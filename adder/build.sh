#!/usr/bin/env bash

ponyc -d -b adder-bin adder
chown "$1" adder-bin
