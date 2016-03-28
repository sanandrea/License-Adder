#!/bin/sh
# script to copy the headers to all the source files and header files


#function to check if element is present in array
#see: http://stackoverflow.com/a/8574392/1073786
containsElement () {
  local e
  for e in "${@:2}"; do [[ "$e" == "$1" ]] && return 0; done
  return 1
}

if [ $# -lt 2 ]; then
    echo "Provide project folder as first argument and license file as second argument"
    exit 0
fi
slashComments=("c" "h" "cpp" "hpp" "m" "java" "js")
hashComments=("py" "sh")

FILES=$(find $1 -type f)

for f in $FILES; do
  if (grep -Eq '(?:PURPOSE AND NONINFRINGEMENT|GNU General Public License)' $f);then 
    echo "No need to copy the License Header to $f"
  else
    #get file extension
    #see http://stackoverflow.com/a/965072/1073786
    extension="${f##*.}" 
    comment=""
    containsElement $extension "${slashComments[@]}"
    if (( $? == 0 ));then
        comment="// "
    fi
    containsElement $extension "${hashComments[@]}"
    if (( $? == 0 ));then
        comment="# "
    fi
    #check comment length
    if [ ${#comment} -gt 0 ]; then
        #prepend comment characters
        #see http://stackoverflow.com/a/9588622/1073786
        awk '{print "'"$comment"'" $0;}' $2 > $f.new
        cat $f >> $f.new
        mv $f.new $f
        echo "License Header copied to $f"
    else
        echo "$f does not belong to licensable files"
    fi

  fi 
done
