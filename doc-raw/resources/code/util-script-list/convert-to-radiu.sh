#!/bin/bash

###
# 将图片转换成圆角图片
#  会先生成一个 $MASK 临时文件, 作为背景通道图片,
# sh convert-to-radiu.sh 宽度 高度 圆角弧度 源文件.png 目标文件.png
# sh convert-to-radiu.sh 406 586 20 sf.png sfr.png
###

W=$1
H=$2
R=$3
SRC=$4
DST=$5

MASK=tmpMask.png
magick -size "$W"x"$H" xc:none -draw "roundrectangle 0,0,$W,$H,$R,$R" $MASK
# magick $SRC -matte $MASK -compose DstIn -composite $DST
magick $SRC -alpha Set $MASK -compose DstIn -composite $DST

# 如果想要白底
# magick $SRC -matte $MASK -compose DstIn -composite $TMP_PNG
# magick $TMP_PNG -background white -flatten $DST

rm $MASK


