##################
# Variables
##################

DOCKER_COMPOSE = docker-compose -f ./docker-compose.yml --env-file ./.env
DOCKER_COMPOSE_PHP_FPM_EXEC = ${DOCKER_COMPOSE} exec -u www-data php-fpm

##################
# Docker compose
##################
dc_build:
	${DOCKER_COMPOSE} build

dc_start:
	${DOCKER_COMPOSE} start

dc_stop:
	${DOCKER_COMPOSE} stop

dc_up:
	${DOCKER_COMPOSE} up -d --remove-orphans

dc_ps:
	${DOCKER_COMPOSE} ps

dc_logs:
	${DOCKER_COMPOSE} logs -f

dc_down:
	${DOCKER_COMPOSE} down -v --rmi=all --remove-orphans

dc_restart:
	make dc_stop dc_start

##################
# App
##################

bash:
	${DOCKER_COMPOSE} exec -u www-data php bash

git_clone:
	${DOCKER_COMPOSE} exec -it php git clone ${r} /var/www/${p}

composer_i:
	${DOCKER_COMPOSE} exec -u www-data php composer install --working-dir=/var/www/${p}

composer_u:
	${DOCKER_COMPOSE} exec -u www-data php composer upgrade --working-dir=/var/www/${p}

##################
# Db
##################
db_import:
	${DOCKER_COMPOSE} exec -T ${c} mysql -uroot -proot ${db} < ${f}

db_export:
	${DOCKER_COMPOSE} exec -T ${c} mysqldump -uroot -proot ${db} | sed -e 's/DEFINER[ ]*=[ ]*[^*]*\*/\*/' | gzip > ${db}.sql.gz