#!/bin/sh

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/opt/vc/lib

if [ -z "${FBCP_DISPLAY}" ]
then
   echo "WARNING: FBCP_DISPLAY variable not set."
   echo " Set the value if you are using an attached display."
   tail -f /dev/null
else
   "/usr/bin/fbcp-${FBCP_DISPLAY}"
fi
