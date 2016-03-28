#License Adder
This simple bash script adds a license information to all source code
files present in a certain project folder. This is useful for old 
projects which do not contain a header informotion in each file.

The script supports only adding GPL and MIT license.
See add_license.sh at line 53 to add other types of licences.

The supported file extensions for the moment are:
"c" "h" "cpp" "hpp" "m" "java" "js" "py" "sh"

To add other extensions you can add them in the arrays:
`slashComments` or `hashComments` 

##Usage
`./add_license.sh folder_of_project license_header`

I have provided two license headers for gplv2 and MIT respectively the files:
`lcs_mit` and `lcs_gplv2`

The log of all operations is written in a logfile at folder_of_project/project_name.addlcs.log

##Notes
.git and node_modules folders are excluded from find command.
