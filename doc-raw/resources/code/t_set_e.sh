#!/bin/bash

error_exit() {
	echo "error, exit"
}

set -e
trap error_exit ERR

echo 1
ss
echo 2
echo 3

