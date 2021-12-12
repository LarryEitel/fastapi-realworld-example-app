export DB=1
export DB_PASSWORD=temp
export DB_PORT=1234

# Github actions doesn't use need sudo, but local dev setups might. Simply
# prefix this script with "SUDO=sudo" to run docker as sudo.

$SUDO docker-compose -p ci down -v
$SUDO docker-compose -p ci up -d db

container_name="ci_db_1"

wait_for_db() {
    status="$($SUDO docker inspect -f {{.State.Health.Status}} $container_name)"

    [ "$?" = "0" ] || exit 1;
    [ "$status" = "healthy" ] && {
        echo "done"
        return;
    }

    sleep 1
    echo -n "."
    wait_for_db
}

wait_for_db

alembic upgrade head
pytest src

$SUDO docker-compose -p ci down -v
