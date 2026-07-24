#!/usr/bin/env bash

PROJECT_NAME=${PWD##*/}
MODELS=( "edge840" "edge1050" )




model=$(mtp-detect | grep "Model: Edge")
if [[ $? -ne 0 ]]; then
    echo "MTP Garmin Edge device ${MODELS[*]} not found!" >&2
    exit 1
fi;
model="edge"$(echo $model | cut -d' ' -f3)
echo "Model=$model"
[[ " ${MODELS[@]} " =~ " ${model} " ]] && echo "Model $model OK" || exit 1;

TEMP="temp~"
[[ -d "${TEMP}" ]] || mkdir ${TEMP}


reg_bmp='\s*([0-9]{1,})\s([0-9]{4}-.{14}\.BMP)'
IFS=$'\n'
for bmps in $(mtp-filetree | grep -oP $reg_bmp); do
    # Move screenshots
    if [[ ${bmps} =~ ${reg_bmp} ]]; then
        num="${BASH_REMATCH[1]}"
        file="${BASH_REMATCH[2]}"
        echo "${num}. ${file}"
        echo mtp-getfile ${num} "${TEMP}/${file}"
        mtp-getfile ${num} "${TEMP}/${model}${file}" || echo "Old version not found!"
        [[ -e "${TEMP}/${model}${file}" ]] && mtp-delfile -n ${num}
    else
        echo "${bmps}"
    fi
done;

#set -e # halt on error

echo "mtp-filetree | grep \"*${PROJECT_NAME}-${model^}*.prg*\""
#echo find bin -type f -name "*${PROJECT_NAME}-${model^}*.prg*"
regex_DIR="^\s*([0-9]+)\s(.*)"

echo "Mazání starých verzí"
for bmps in $(mtp-filetree | grep -E "${PROJECT_NAME}-${model^}.*.prg.*"); do
    if [[ ${bmps} =~ ${regex_DIR} ]]; then
        num="${BASH_REMATCH[1]}"
        file="${BASH_REMATCH[2]}"
        echo "DELETE ${num}. ${file}"
        echo mtp-getfile ${num} "${TEMP}/${file}"
        #mtp-getfile ${num} "${TEMP}/${model}${file}" || echo "Old version not found!"
        mtp-delfile -n ${num}
    else
        echo "${bmps}"
    fi
done;

for d in $(mtp-filetree | grep "Apps")
do
    if [[ ${d} =~ ${regex_DIR} ]]; then
        num="${BASH_REMATCH[1]}"
        file="${BASH_REMATCH[2]}"
        for f in $(find bin -type f -name "*${PROJECT_NAME}-${model^}*.prg*"); do
            echo "mtp-connect --sendfile ${f} ${num}"
            mtp-connect --sendfile ${f} ${num}
            mtp-files | grep -B 1 -A 4 "${f}" | grep -B 3 -A 2 "Parent ID: ${num}"
            echo "${PROJECT_NAME} copy to device"
        done
        mtp-filetree | grep "*${PROJECT_NAME}-${model^}*.prg*"
        #else
            #echo "MTP Garmin device not found!" >&2
        #fi
    fi
done

exit 0

MTP="../../MTP/"
[[ -d ${MTP} ]] || mkdir -p ${MTP}
rm -f ${MTP}${PROJECT_NAME}*.prg
cp -v "${OUTPUT_FILE}"* "${MTP}"

IFS=$'\n'
regex="^\s*([0-9]+)\s(.*)" # put the regex in a variable because some patterns won't work if included literally
for f in $(mtp-filetree | grep "${PROJECT_NAME}.prg"); do
    if [[ ${f} =~ ${regex} ]]; then
        num="${BASH_REMATCH[1]}"
        file="${BASH_REMATCH[2]}"
        echo "DELETE ${num} ${file}"
        #mtp-connect --delete ${file}
        mtp-delfile -n ${num} && echo "File ${file} deleted"
    fi
done;
for f in $(mtp-filetree | grep "Apps")
do
    if [[ ${f} =~ ${regex} ]]; then
        num="${BASH_REMATCH[1]}"
        file="${BASH_REMATCH[2]}"
        echo "mtp-connect --sendfile ${OUTPUT_FILE} ${num}"
        #mtp-detect | grep "idVendoridVendor: 091e"
        #if [ $? -eq 0 ]; then
            mtp-connect --sendfile ${OUTPUT_FILE} ${num}
            mtp-files | grep -B 1 -A 4 "${PROJECT_NAME}" | grep -B 3 -A 2 "Parent ID: ${num}"
            echo "${PROJECT_NAME} copy to device"
        #else
            #echo "MTP Garmin device not found!" >&2
        #fi
        break;
    fi
done

echo "mtp-filetree | grep CIQ"
echo "mtp-getfile 436 logs/CIQ_LOG.YML"