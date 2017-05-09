#!/bin/bash

# one liner to set exclude a node from an ES cluster
show_help() {
cat << EOF
Usage: ${0##*/}
    -c cluster name
    -n node ip
EOF
}

date=$(date +%F-%T)
cluster="none"
node_ip="none"

# get opts
args=$@

# make sure optindex is reset in case it was used before
OPTIND=1

# get opts and assign them to the right vars

if [[ $# != "4" ]] ; then
	echo "seems like you're missing some info"
	show_help
	exit 1
fi

while getopts c:n: opt; do
	case "$opt" in
		c) cluster=$OPTARG
			;;
		n) node_ip=$OPTARG
			;;
		*) show_help
			exit 1
			;;
	esac
done
shift $((OPTIND-1))

echo "Excluding node $node_ip from cluster $cluster"
curl -XPUT $cluster/_cluster/settings -d "{ \"transient\" :{ \"cluster.routing.allocation.exclude._ip\" : \"$node_ip\" }}"
