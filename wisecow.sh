#!/usr/bin/env bash

SRVPORT=4499
RSPFILE=response

rm -f $RSPFILE
mkfifo $RSPFILE

get_api() {
	read line
	echo $line
}

handleRequest() {
    # 1) Process the request
	get_api
	mod=`fortune`

cat <<EOF > $RSPFILE
HTTP/1.1 200


<pre>`cowsay $mod`</pre>
EOF
}

prerequisites() {
  for cmd in cowsay fortune nc; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
      echo "Missing prerequisite: $cmd"
      exit 1
    fi
  done
}


main() {
	prerequisites
	echo "Wisdom served on port=$SRVPORT..."

	while [ 1 ]; do
		cat $RSPFILE | nc -lN $SRVPORT | handleRequest
		sleep 0.01
	done
}

main
