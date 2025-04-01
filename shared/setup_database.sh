SHARED_SCRIPT_PATH=$(dirname $0)
DEMODATA=1
CONSOLE_PATH=$( [ -e "source/bin/oe-console" ] && echo "bin/oe-console" || echo "vendor/bin/oe-console" )

#Pass arguments to the script
flags()
{
    while test $# -gt 0
    do
        case "$1" in
        -n|--no-demodata)
            DEMODATA=0
            ;;
        esac

        # and here we shift to the next argument
        shift
    done
}
flags "$@"

echo -e "\033[1;37m\033[1;42mSetup shop\033[0m\n"

docker compose exec php bash -c 'mkdir -p "$OXID_BUILD_DIRECTORY"'

docker compose exec php ${CONSOLE_PATH} oe:setup:shop

$SHARED_SCRIPT_PATH/reset_database.sh

if [[ $DEMODATA -eq 1 ]]; then
  docker compose exec -T php ${CONSOLE_PATH} oe:setup:demodata
fi
