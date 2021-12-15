#! /bin/bash
guests_boot_order=${1}
action=${2}
timeout=40
interval=20

start () {
local index=0
local array=()

while read -r line
do
	array+=( "$line" )
done<"$guests_boot_order"

for index in ${!array[@]}
do
	printf '%s\n' "checking ${array[${index}]}"
	domstate=$(virsh domstate "${array[${index}]}")
	countdown=0
	if [ "${domstate}" != "running" ]
	then
		printf '%s\n' "starting ${array[${index}]}"
		virsh ${action} ${array[${index}]}
		if [ ${countdown} -lt ${timeout} ]
		then
			printf '%s\n' "Checking.."
			domstate=$(virsh domstate "${array[${index}]}")
			sleep ${interval}s
			((countdown+=${interval}))
		else
			printf '%s\n' "Aborting.. ${array[${index}]} did not start up within $timeout seconds"
			break
		fi
	else
		printf '%s\n' "Already active. Aborting startup"
	fi
done
}

stop () {
local index=0
local rev=$(tac ${guests_boot_order})
for index in ${rev}
do
	printf '%s\n' "checking ${index}"
	domstate=$(virsh domstate "${index}")
	countdown=0
	if [ "${domstate}" == "running" ]
	then
		printf '%s\n' "stopping ${index}"
		virsh ${action} ${index}
		if [ ${countdown} -lt ${timeout} ]
		then
			printf '%s\n' "Checking.."
			domstate=$(virsh domstate "${index}")
			sleep ${interval}s
			((countdown+=${interval}))
		else
			printf '%s\n' "Forcing shutdown.. ${index} did not stop up within $timeout seconds"
			virsh destroy ${index}
			break
		fi
	else
		printf '%s\n' "${index} is already down. Aborting shutdown"
	fi
done
}

if [ $2 == "start" ]
then
	start
elif [ $2 == "shutdown" ]
then
	stop
else
	printf '%s\n' "Weird input. Aborting"
fi
