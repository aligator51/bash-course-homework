#!/usr/bin/bash

RED='\e[31m'
GREEN='\e[32m'
RESET='\e[0m'

declare -i step=1
declare -i hit=0
declare -i miss=0

declare -a numbers=()

while :; do
    pred=${RANDOM: -1}

    echo "Step: ${step}"

    while :; do
        read -p "Please enter number from 0 to 9 (q - quit): " num

        case "${num}" in
        [0-9])
            break
            ;;
        q)
            echo "Bye"
            exit 0
            ;;
        *)
            echo "Not valid input. Please repeat."
            ;;
        esac
    done

    if [[ "${num}" == "${pred}" ]]; then
        echo "Hit! My number: ${pred}"
        hit+=1
        number_string="${GREEN}${pred}${RESET}"
    else
        echo "Miss! My number: ${pred}"
        miss+=1
        number_string="${RED}${pred}${RESET}"
    fi

    numbers+=("${number_string}")

    if ((${#numbers[@]} > 10)); then
        numbers=("${numbers[@]:1}")
    fi

    total=$((hit + miss))
    hit_percent=$((hit * 100 / total))
    miss_percent=$((100 - hit_percent))

    echo "Hit: ${hit_percent}% Miss: ${miss_percent}%"
    echo -e "Numbers: ${numbers[@]}"

    step+=1
    echo
done