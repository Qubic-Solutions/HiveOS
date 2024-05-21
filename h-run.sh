#!/usr/bin/env bash

source h-manifest.conf

#[[ `ps aux | grep "./rqiner-x86" | grep -v grep | wc -l` != 0 ]] &&
#	echo -e "${RED}$CUSTOM_NAME miner is already running${NOCOLOR}" &&
#	exit 1

CUSTOM_LOG_BASEDIR=`dirname "$CUSTOM_LOG_BASENAME"`
[[ ! -d $CUSTOM_LOG_BASEDIR ]] && mkdir -p $CUSTOM_LOG_BASEDIR

if [[ -z $CUSTOM_CONFIG_FILENAME ]]; then
	echo -e "The config file is not defined"
fi

export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/hive/lib
#export LD_LIBRARY_PATH="/usr/lib/zluda/:$LD_LIBRARY_PATH"

CUSTOM_USER_CONFIG=$(< $CUSTOM_CONFIG_FILENAME)
CUSTOM2_USER_CONFIG=$(< $CUSTOM2_CONFIG_FILENAME)

#echo "about to call executiable "
echo "args: $CUSTOM_USER_CONFIG"
echo "args for rqiner cpu is : $CUSTOM2_USER_CONFIG"

#strip arch from commandline
# Remove the -arch argument and its value
CLEAN=$(echo "$CUSTOM_USER_CONFIG" | sed -E 's/-t [^ ]+ //')
echo "args are now: $CLEAN"
/hive/miners/custom/rqiner-x86-cuda/rqiner-x86-cuda -V > "/tmp/.rqiner-x86-cuda-version"

echo $(date +%s) > "/tmp/miner_start_time"
/hive/miners/custom/rqiner-x86-cuda/rqiner-x86-cuda $CUSTOM_USER_CONFIG  2>&1 | tee --append ${CUSTOM_LOG_BASENAME}.log & /hive/miners/custom/rqiner-x86-cuda/cpu/rqiner-x86 $CUSTOM2_USER_CONFIG  2>&1 | tee --append ${CUSTOM_LOG_BASENAME}.log

echo "Miner has exited"

