#!/usr/bin/bash

declare -i step=1
declare -a history=()

secret=""

trap 'echo; echo "Для завершения работы введите q или Q"' SIGINT

while ((${#secret} < 4)); do
    digit=${RANDOM: -1}

    if [[ -z "${secret}" && "${digit}" == "0" ]]; then
        continue
    fi

    if [[ "${secret}" != *"${digit}"* ]]; then
        secret+="${digit}"
    fi
done

echo
echo "********************************************************************************"
echo "* Я загадал 4-значное число с неповторяющимися цифрами. На каждом ходу делайте *"
echo "* попытку отгадать загаданное число. Попытка - это 4-значное число с           *"
echo "* неповторяющимися цифрами.                                                    *"
echo "********************************************************************************"
echo

while :; do
    read -r -p "Попытка ${step}: " guess

    case "${guess}" in
    q | Q)
        echo "Выход."
        exit 1
        ;;
    esac

    if [[ ! "${guess}" =~ ^[1-9][0-9]{3}$ ]]; then
        echo "Ошибка: введите 4-значное число, если хотите завершить работу введите q или Q"
        continue
    fi

    valid=true

    for ((i = 0; i < 4; i++)); do
        for ((j = i + 1; j < 4; j++)); do
            if [[ "${guess:i:1}" == "${guess:j:1}" ]]; then
                valid=false
            fi
        done
    done

    if [[ "${valid}" == "false" ]]; then
        echo "Ошибка: цифры не должны повторяться."
        continue
    fi

    bulls=0
    cows=0

    for ((i = 0; i < 4; i++)); do
        guess_digit=${guess:i:1}
        secret_digit=${secret:i:1}

        if [[ "${guess_digit}" == "${secret_digit}" ]]; then
            ((bulls++))
        elif [[ "${secret}" == *"${guess_digit}"* ]]; then
            ((cows++))
        fi
    done

    echo "Коров - ${cows} Быков - ${bulls}"
    echo

    history+=("${step}. ${guess} (Коров - ${cows} Быков - ${bulls})")

    echo "История ходов:"

    for item in "${history[@]}"; do
        echo "${item}"
    done

    echo

    if ((bulls == 4)); then
        echo "Вы угадали число ${secret}!"
        exit 0
    fi

    ((step++))
done
