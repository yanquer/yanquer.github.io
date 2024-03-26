#!/bin/sh

ARGS=$(getopt -o hu: -l help,user:,age:,name:: -- "$@")
ERR_CODE=$?

if ! [ ${ERR_CODE} -eq 0 ]
then
	echo "please get true option"
	exit 1
fi

echo "ARGS::: ${ARGS}"
eval set -- "${ARGS}"

while true;
do

	case "$1" in
		-u|--user)
			_user="$2"
			shift
			;;
		-h)
			echo "a help msg"
			exit
			;;
		--age)
			_age="$2"
			shift
			;;
		--name)
			_name="$2"
			shift
			;;
		--)
			break
			;;
		*)
			echo "error no msg with args $*"
			exit 1
			;;
	esac

	shift
done

echo "user:$_user"
echo "age:$_age"
echo "name:$_name"

