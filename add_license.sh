#!/bin/sh
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
# 
#
#  Copyright © 2016 Andi Palo
#  This file is part of project: License Adder
#

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

echo "Enter author, followed by [ENTER]:"
read author
echo "Project name, followed by [ENTER]:"
read project

slashComments=("c" "h" "cpp" "hpp" "m" "java" "js")
hashComments=("py" "sh")

FILES=$(find $1 -type f -not -path "$1/.git/*" -not -path "$1/node_modules/*")

log=$1/$project.add_lcs.log
for f in $FILES; do
  if (grep -Eq '(?:PURPOSE AND NONINFRINGEMENT|GNU General Public License)' $f);then 
    echo "No need to copy the License Header to $f" >> $log
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
        echo $comment >> $f.new
        echo "$comment Copyright © $(date +"%Y") $author" >> $f.new
        echo "$comment This file is part of project: $project" >> $f.new
        echo $comment >> $f.new
        cat $f >> $f.new
        mv $f.new $f
        echo "License Header copied to $f" >> $log
    else
        echo "$f does not belong to licensable files" >> $log
    fi

  fi 
done
echo "output has been written to: $log"