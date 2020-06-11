FILE=$1

if [ "$FILE" = "" -o ! -f "$FILE" ]; then
        echo "Please specify a .nw file"
        exit 1
fi

noroots $FILE | sed 's/^<''<\(.*\)>>$/\1/' |
        while read chunk; do
                printf "%s : %s\n" "$chunk" "$FILE"
                case $chunk in
                        *.pl|*.sh)
                                printf "\tnotangle -R\$@ \$< >\$@\n"
                                printf "\tchmod 755 %s\n" "$chunk"
                                ;;
                        *.c)
                                printf "\tnotangle -L -R\$@ \$< | cpif \$@\n"
                                printf "include ${chunk%.c}.d\n"
                                ;;
                        *.h)
                                printf "\tnotangle -L -R\$@ \$< | cpif \$@\n"
                                ;;
                        *)
                                printf "\tnotangle -t8 -R\$@ $< >\$@\n"
                                ;;
                esac
        done
