#!/bin/sh


CONF=/etc/samba/smb.conf

add_group(){
	NUM=$(echo ${1} | cut -d: -f1)
	NAME=$(echo ${1} | cut -d: -f2)
	addgroup -g ${NUM} ${NAME}
}

add_user(){
	USER=$(echo ${1} | cut -d : -f 1)
	PASS=$(echo ${1} | cut -d : -f 2)
	GRPS=$(echo ${1} | cut -d : -f 3-)
	adduser -D ${USER}
	echo ${PASS} | tee - | smbpasswd -s -a ${USER}
	for G in $(echo $GRPS|tr ':' ' ')
	do
		addgroup ${USER} ${G}
	done
}

add_section(){
	NAME=$(echo ${@} | cut -d: -f1)
	VALS=$(echo ${@} | cut -d: -f2-):
	echo "[${NAME}]" >> ${CONF}
	while [ "${VALS}" ]
	do
		echo "   $(echo ${VALS} | cut -d: -f1)" >> ${CONF}
		VALS=$(echo ${VALS} | cut -d: -f2-)
	done
}


while [ "${1}" ]
do
	case "${1}" in
		-g) shift && add_group ${1}
		;;
		-n) shift && add_user ${1}
		;;
		-s) shift && add_section ${1}
		;;
	esac
	shift
done

nmbd -D
smbd -FS < /dev/null
