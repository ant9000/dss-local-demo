#!/bin/bash

HERE=$(realpath $(dirname $0))

fname=$1
if [ -z $fname ]; then
  fname="$HERE/samples/blank_signed.pdf"
fi

(
echo -n '{"signedDocument":{"bytes":['
od -An -v -t u1 -w1 $fname | perl -0 -pe 's/\n/,/g;s/ *//g;s/,$//;'
echo '],"name":"'$fname'"}}'
) | curl -X 'POST' --silent --fail \
  'http://localhost:8080/services/rest/validation/validateSignature' \
  -H 'Content-Type: application/json' \
  -d @-
