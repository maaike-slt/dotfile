#!/bin/bash

SYMLINK_ENV="symlink.env"
SEPARATOR="="
SAVE_PATH="$(pwd)/data/"

if [[ ! -f "$SYMLINK_ENV" ]]; then
	printf "\033[1;31merror\033[0m:\t\033[1;35m%s\033[0m \033[31mnot found\033[0m\n" "$SYMLINK_ENV"
	exit 1
fi

while IFS= read -r line; do
	if [[ -z "$line" ]]; then
		continue
	fi

	IFS="$SEPARATOR" read -r save create <<<"$line"

	if [[ -z "$save" ]] || [[ -z "$create" ]]; then
		printf "\033[1;31merror\033[0m:\t\033[31mline '\033[1;35m%s\033[0m\033[31m' does not have a valid format\033[0m\n" "$line"
		printf "\033[1;36mformat\033[0m:\t\033[1;32mDOTFILE\033[1;35m%s\033[0m\033[1;36mSYMLINK_PATH\033[0m\n" "$SEPARATOR"
		exit 1
	fi

	if [[ ! -f "${SAVE_PATH}${save}" ]]; then
		printf "\033[1;31merror\033[0m:\t\033[1;35m%s%s\033[0m \033[31mnot found\033[0m\n" "$SAVE_PATH" "$save"
		exit 1
	fi

	create="${create/#\~/$HOME}"

	if [[ -L "$create" ]]; then
		printf "\033[1;36minfo\033[0m:\tsymlink \033[1;35m%s\033[0m \033[1;36malready exists\033[0m\n" "$create"
		continue
	fi

	if [[ -f "$create" ]]; then
		printf "\033[1;36minfo\033[0m:\tfile \033[1;35m%s\033[0m \033[1;36malready exists\033[0m\n" "$create"
		mv "$create" "$create.pre-dotfile"
		printf "\033[1;36minfo\033[0m:\tmoved \033[1;35m%s\033[0m to \033[1;35m%s.pre-dotfile\033[0m\n" "$create" "$create"
	fi

	ln -s "${SAVE_PATH}${save}" "$create"
	printf "\033[1;36minfo\033[0m:\tcreated symlink \033[1;35m%s\033[0m -> \033[1;35m%s\033[0m\n" "$save" "$create"

done <"$SYMLINK_ENV"
