#!/bin/bash

set -e

apt update
apt install apt-transport-https ca-certificates -y

mv /etc/apt/sources.list /etc/apt/sources.list.bak

echo "# 默认注释了源码镜像以提高 apt update 速度，如有需要可自行取消注释
deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-updates main contrib non-free

deb https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free
# deb-src https://mirrors.tuna.tsinghua.edu.cn/debian/ bullseye-backports main contrib non-free

# deb https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free
# # deb-src https://mirrors.tuna.tsinghua.edu.cn/debian-security bullseye-security main contrib non-free

deb https://security.debian.org/debian-security bullseye-security main contrib non-free
# deb-src https://security.debian.org/debian-security bullseye-security main contrib non-free
" > /etc/apt/sources.list

apt update

apt install python3 python3-pip python3-venv vim git ssh -y

cd ~
mkdir .pip && cd .pip
echo "[global]
index-url = https://pypi.douban.com/simple/
[install]
trusted-host=pypi.douban.com
" >pip.conf

apt install libgl-dev python3-dev python3-distutils python3-setuptools -y

mkdir python_dev && cd python_dev

python3 -m venv dev_venv

. dev_venv/bin/activate

cd ~ && mkdir project && cd project

git clone https://code.qt.io/pyside/pyside-setup

cd pyside-setup && git checkout 6.4 && pip install -r requirements.txt

