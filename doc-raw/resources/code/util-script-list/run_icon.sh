#!/bin/bash

###
# 生成图标文件夹
# sh run_icon.sh sf.png sfi
###

USAGE="""

功能

    生成图标文件夹

用法

    sh run_icon.sh [-i|-icn] 源图片 生成目录名 图标名

参数说明

    源图片 (必须)
        需要转换的图片

    生成目录名 (可选, 默认icons)
        生成图标的目录名, 因为系统要求, 会自动加 *.iconset* 后缀

    图标名 (可选, 默认icon)
        图标名

    -i, -icn (可选, 默认不生成icns文件)
        是否将 *生成目录* 生成icns文件, 生成的文件名是 *图标名.icns*

"""

# ARGS=$(getopt -o hi --long help:,icn: -- "$@")
ARGS=$(getopt "-o hi -l help,icn --" "$@")
ErrCode=$?;
if [ $ErrCode != 0 ] ; then
    echo "Error in command line processing"
    exit 1
fi
eval set -- "${ARGS}"

_ICN=false
while true
do
    case "$1" in
        -i|--icn)
            _ICN=true
            shift
            ;;
        -h|--help)
            echo "${USAGE}"
            exit 0
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Internal error!"
            echo "${USAGE}"
            exit 1
            ;;
    esac
done

function error_exit()
{
    set +e
    echo error with last lines
}

function create_icon()
{
    sips -z 16 16 "${Origin}" --out "${Dest}"/"${Name}"_16x16.png
    sips -z 32 32 "${Origin}" --out "${Dest}"/"${Name}"_16x16@2x.png
    sips -z 32 32 "${Origin}" --out "${Dest}"/"${Name}"_32x32.png
    sips -z 64 64 "${Origin}" --out "${Dest}"/"${Name}"_32x32@2x.png
    sips -z 128 128 "${Origin}" --out "${Dest}"/"${Name}"_128x128.png
    sips -z 256 256 "${Origin}" --out "${Dest}"/"${Name}"_128x128@2x.png
    sips -z 256 256 "${Origin}" --out "${Dest}"/"${Name}"_256x256.png
    sips -z 512 512 "${Origin}" --out "${Dest}"/"${Name}"_256x256@2x.png
    sips -z 512 512 "${Origin}" --out "${Dest}"/"${Name}"_512x512.png
    sips -z 1024 1024 "${Origin}" --out "${Dest}"/"${Name}"_512x512@2x.png
}

function create_icns(){
    echo "create icns ${Name}.icns"
    iconutil -c icns "${Dest}" -o "${Name}.icns"
}

set -e
trap error_exit ERR


Origin=$1
Dest=${2:-icons}.iconset
Name="${3:-icon}"

echo """
>>> run with
    OriginImage: ${Origin}
    DestDir: ${Dest}
    Name: ${Name}
    Create icns: ${_ICN}
"""

if [ ! -d "${Dest}" ]; then
    mkdir -p "${Dest}"
fi

create_icon

if [ "${_ICN}" = true ]; then
    create_icns
fi

set +e

