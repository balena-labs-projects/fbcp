#! /bin/busybox sh

if [ -z ${FBCP_DISPLAY} ] ;
 then
    echo -e "\033[91mWARNING: FBCP_DISPLAY variable not set.\n Set the value if you are using an SPI-based display."
 else
    /usr/src/fbcp-${FBCP_DISPLAY}
fi 


/bin/busybox sh /usr/bin/balena-idle