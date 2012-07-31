#!/bin/bash
# dt-cue-mp3_check.sh
#
# 2012-07-30_212700
# ./dt-cue-mp3_check.sh <help | base-folder> <all>
# confirms an existing cue file exists for an mp3 with the same name among current specified folder and all sub-folders; prints a list of filders and/or files of where cue sheets are missing
#
# Dumb Terminal
#  Smaller than Life Projects
# Main Page: http://dt.tehspork.com
# Git Repo: https://github.com/dumbterminal/
# By: MikereDD & veekahn
# email: dumbterminal -at- tehspork.com
#


big_file_size=80000000

if [[ "${1}" == "help" ]]; then
  echo "./dt-cue-mp3_check.sh <base-folder> <all>"
  echo "  note: base-folder must not contain any (sub-)folders and/or files with spaces!"
  echo " there is only one parameter to change, big_file_size, this is the byte size of the mp3 to check"
  echo " cue<->mp3 name matching converts all '_' to '-' and checks if the given *.cue is named *.mp3.cue"
  exit
fi

if [ -z "${1}" ]; then
    wdir="."
else 
    wdir="${1}"
fi


## stores backwards
#dir=(`find . -name "*.[mc][pu][3e]" -printf "%s %h %f\n" | sort`)
dir=(`find ${1} -name "*.[mc][pu][3e]" -printf "%h %f %s\n" | sort`)
FOLDERS=( )
for (( i=0; $i < ${#dir[@]}; i++ )); do
  
  if (( $i % 3 == 2 )); then
    if (( "${dir[$i]}"  > "${big_file_size}" )); then
      bffile=${dir[$((i-1))]}
      file=${bffile%.*}
      
      pfile=${dir[$((i-4))]%.*}
      pext=${dir[$((i-4))]##*.}
      afile=${dir[$((i+2))]%.*}
      aext=${dir[$((i+2))]##*.}

      if [[ "${bffile}" != "${pfile}"  &&  "${bffile}" != "${afile}"  &&  "${file}" != "${pfile}"  &&  "${file}" != "${afile}" ]]; then
        bffile=${bffile//_/-}
	file=${file//_/-}
	pfile=${pfile//_/-}
	afile=${afile//_/-}
	  if [[ "${bffile}" != "${pfile}"  &&  "${bffile}" != "${afile}"  &&  "${file}" != "${pfile}"  &&  "${file}" != "${afile}" ]]; then
	    if [[ -n "${2}" ]]; then
#	      echo "=> ${dir[$((i-2))]}     ${dir[$((i-1))]}  ${dir[$((i-1))]%.*}"
	      echo "=> ${dir[$((i-2))]}     ${dir[$((i-1))]%.*} ${dir[$((i-1))]##*.}"
#	      FOLDERS+=( "${dir[$((i-2))]}" )
	    else
	      FOLDERS+=( "${dir[$((i-2))]}" )
	    fi
	  fi
      fi

      
    fi
  fi

done

FOLDERS=( $( printf "%s\n" "${FOLDERS[@]}" | awk 'x[$0]++ == 0' ) )
for i in ${FOLDERS[@]}; do
 echo ${i}
done
