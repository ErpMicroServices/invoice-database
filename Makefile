.PHONY = clean clean-files clean-docker docker

all : docker node_modules database_up.sql
	sudo docker commit new-invoicing-database erpmicroservices/invoicing-database:latest

docker :
	sudo docker build --tag new-invoicing-database --rm .
	sudo docker run -d --publish 5432:5432 --name new-invoicing-database new-invoicing-database
	sleep 10

node_modules : package.json
	npm install

database_up.sql : sql/*.sql database_change_log.yml
	liquibase --changeLogFile=./database_change_log.yml --url='jdbc:postgresql://localhost/invoicing-database' --username=invoicing-database --password=invoicing-database --outputFile=database_up.sql updateSql

clean : clean-docker clean-files

clean-files :
	-$(RM) -rf node_modules
	-$(RM) database_up.sql
	-$(RM) databasechangelog.csv

clean-docker :
	if sudo docker ps | grep -q new-invoicing-database; then sudo docker stop new-invoicing-database; fi
	if sudo docker ps -a | grep -q new-invoicing-database; then sudo docker rm new-invoicing-database; fi
	if sudo docker images | grep -q new-invoicing-database; then sudo docker rmi new-invoicing-database; fi
	if sudo docker images | grep -q erpmicroservices/invoicing-database; then sudo docker rmi erpmicroservices/invoicing-database; fi
