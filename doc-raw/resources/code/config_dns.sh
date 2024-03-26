#!/bin/bash

set -e

blue_echo(){
	local _strs
	_strs="$*"

	echo "\e[1;36m${_strs}\e[0m\n"
}

pv_blue_echo(){
	local _time
	_time="$1"

	set +e

	while [ ${_time} -gt 0 ]; do

		blue_echo "................" | pv -qL 15
		_time="$(expr "${_time}" - 1)"
	done

	set -e
}

# pv_blue_echo 3

start_or_re(){

	if [ $(/etc/init.d/named status | grep not | wc -l ) -eq 1 ]; then
		blue_echo 'start named'
		/etc/init.d/named start
	else
		blue_echo 'restart named'
		/etc/init.d/named restart
	fi

	blue_echo "wait 3 s"
	pv_blue_echo 3
}

install_pack(){

	echo "安装软件包"

	# 安装证书验证模块才可以配置源
	apt update && apt install ca-certificates -y

	# 不用换源 镜像的 http://cn.archive.ubuntu.com/ubuntu/ 就是国内的

	# mv /etc/apt/sources.list /etc/apt/sources.list.bak

	# echo "deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse
	# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse
	# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse
	# deb https://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse
	# " > /etc/apt/sources.list

	# apt update

	apt install vim -y

	# 安装查看ip工具
	apt install -y iproute2 bind9 bind9-utils bind9-host pv

	# 可能有个选地区的, 选 6 亚洲 -> 70 上海

	echo "安装软件包完成"
}

add_dns_option_zone(){
	local _domain_name _c_file
	_domain_name="$1"
	_c_file="$2"

	blue_echo "add ${_c_file}"

	echo "
	zone \"${_domain_name}\" IN {
		type master;
		file \"${_c_file}\";
	};

	" >> /etc/bind/named.conf.local
}

add_dns_reverse_option_zone(){

	local _ip_r_3 _c_r_file
	_ip_r_3="$1"
	_c_r_file="$2"

	blue_echo "add ${_c_r_file}"

	echo "
	zone \"${_ip_r_3}.in-addr.arpa\" {
		type master;
		file \"${_c_r_file}\";
	};
	" >> /etc/bind/named.conf.local
}

if [ $(apt list 2> /dev/null | grep bind9 | wc -l) -eq 0 ]; then
	install_pack
fi

ip=$(ip a | grep inet | grep brd | awk '{print $2}' | cut -d '/' -f 1)

blue_echo "本机ip 为 ${ip}"

ip_reverse_3=$(echo "${ip}" | awk 'BEGIN{FS=".";};{print $3 "." $2 "." $1}')
ip_1=$(echo "${ip}" | cut -d '.' -f 4)

echo "请输入需要设置的域名, 例如: study.com. default(study.com.)"

read -p "input your domain name: default(study.com) " domain_server_name

if [ -z "${domain_server_name}" ]; then
	domain_server_name='study.com'
fi

blue_echo "your domain_server_name: ${domain_server_name}"

if [ $(cat /etc/bind/named.conf.options | grep 'listen-on port' | wc -l) -eq 0 ]; then
	sed -ie "3a \ \ \ \ \ \ \ \ listen-on port 53 { ${ip}; }; allow-query { any; }; 	// 允许进行普通查询的 IP 地址列表，默认允许所有；
	"  /etc/bind/named.conf.options
fi

config_file="/var/cache/bind/named.${domain_server_name}"
config_reverse_file="/var/cache/bind/named.reverse.db.xxx"

reverse_zone_title="${ip_reverse_3}.in-addr.arpa"
reverse_zone_title_line="$(cat /etc/bind/named.conf.local | grep -n ${reverse_zone_title} |  cut -d ':' -f 1)"

if [ -n "${reverse_zone_title_line}" ]; then
	add_dns_option_zone "${domain_server_name}" "${config_file}"
else
	add_dns_option_zone "${domain_server_name}" "${config_file}"
	add_dns_reverse_option_zone "${ip_reverse_3}" "${config_reverse_file}"
fi

echo "
;
; BIND data file for ${domain_server_name}
;
\$TTL        604800
@   IN      SOA     ${domain_server_name}. root.${domain_server_name}. (
                2           ; Serial
            604800          ; Refresh
            86400           ; Retry
            2419200         ; Expire
            604800 )        ; Negative Cache TTL
;
@   IN      NS      localhost.
@   IN      A       ${ip}
@   IN      AAAA    ::1

; A 表示ipv4地址 AAAA表示ipv6地址 NS表示使用的dns服务器
; www 会自动加到 ${domain_server_name} 实际为 www.${domain_server_name}
www IN      A       172.17.0.4
; qq 会自动加到 ${domain_server_name} 实际为 qq.${domain_server_name}
qq  IN      A       172.17.0.6
" > "${config_file}"

if [ -f "${config_reverse_file}" ]; then
	blue_echo "cant add new reverse, alread exits"
	blue_echo "if you want add new, please vim ${config_reverse_file}"
else
	echo "
;
; BIND reverse data file for ${ip_reverse_3}
;
\$TTL        604800
@   IN      SOA     ${domain_server_name}. admin.${domain_server_name}. (
				1           ; Serial
			604800          ; Refresh
			86400           ; Retry
			2419200         ; Expire
			604800 )        ; Negative Cache TTL
;
@   IN      NS      ${domain_server_name}.
; 表示 ${ip} 会被解析为 ${domain_server_name} 注意这里都是倒着来
${ip_1}   IN      PTR     ${domain_server_name}.
" >  "${config_reverse_file}"
fi

start_or_re

blue_echo "
键入:
host www.${domain_server_name} ${ip}
host qq.${domain_server_name} ${ip}
host ${ip} ${ip}
测试
"

host "www.${domain_server_name}" "${ip}"
host "qq.${domain_server_name}" "${ip}"
host "${ip}" "${ip}"

