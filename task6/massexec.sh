#!/usr/bin/bash

# Задача 6. Массовая обработка файлов Бубеков Д.В. 521

dirpath="$(pwd)"
mask="*"
number="$(nproc)"

while (($# > 0)); do
    case "$1" in
    --path)
        if (($# < 2)); then
            echo "Ошибка: для --path требуется значение."
            exit 1
        fi

        dirpath=$2
        shift 2
        ;;

    --mask)
        if (($# < 2)); then
            echo "Ошибка: для --mask требуется значение."
            exit 1
        fi

        mask=$2
        shift 2
        ;;

    --number)
        if (($# < 2)); then
            echo "Ошибка: для --number требуется значение."
            exit 1
        fi

        number=$2
        shift 2
        ;;

    --*)
        echo "Ошибка: неизвестный аргумент $1."
        exit 1
        ;;

    *)
        break
        ;;
    esac
done

if (($# == 0)); then
    echo "Ошибка: не указана команда обработки."
    exit 1
fi

command_name=$1

if [[ ! -d "${dirpath}" ]]; then
    echo "Ошибка: каталог ${dirpath} не существует."
    exit 1
fi

if [[ -z "${mask}" ]]; then
    echo "Ошибка: маска не может быть пустой."
    exit 1
fi

if [[ ! "${number}" =~ ^[1-9][0-9]*$ ]]; then
    echo "Ошибка: number должен быть целым числом больше нуля."
    exit 1
fi

command_path=$(command -v -- "${command_name}")

if [[ -z "${command_path}" || ! -f "${command_path}" || ! -x "${command_path}" ]]; then
    echo "Ошибка: команда ${command_name} не существует или не имеет права исполнения."
    exit 1
fi

dirpath=$(cd -- "${dirpath}" && pwd -P)

declare -a files=()

shopt -s nullglob dotglob

for file in "${dirpath}"/*; do

    if [[ ! -f "${file}" || -L "${file}" ]]; then
        continue
    fi

    filename=${file##*/}

    if [[ "${filename}" == ${mask} ]]; then
        files+=("${file}")
    fi

done

declare -i running=0

for file in "${files[@]}"; do

    while ((running >= number)); do
        wait -n
        ((running--))
    done

    "${command_path}" "${file}" &
    ((running++))

done

while ((running > 0)); do
    wait -n
    ((running--))
done
