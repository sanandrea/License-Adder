#!/bin/sh
# script to copy the headers to all the source files and header files

if [ $# -lt 2 ]; then
    echo "Provide folder as first argument and license file as second argument"
    exit 0
fi
FILES=$(find $1 -type f -name '*.m' -o -name '*.h' -o -name '*.c')

for f in $FILES; do
  if (grep NONINFRINGEMENT $f);then 
    echo "No need to copy the License Header to $f"
  else
    cat $2 $f > $f.new
    mv $f.new $f
    echo "License Header copied to $f"
  fi 
done 
