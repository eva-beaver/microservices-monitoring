# defaul shell
SHELL = /bin/bash

CUR_DIR = $(CURDIR)


# Rule "help"
.PHONY: help
.SILENT: help
help:
	echo "Use make [rule]"
	echo "Rules:"
	echo ""
	echo "build-micro	- build application and generate docker image"
	echo "run-micro-app	- run application on docker"
	echo "stop-micro-app	- stop application"
	echo "rm-micro-app	- stop and delete application"
	echo ""
	echo "help		- show this message"

build-micro:
	echo "⏲️ 	: " $(shell date --iso=seconds) " : started build script..."; \
	cd sample-app-micrometer-prometheus; \
	mvn clean package; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : build complete."; \
	echo "🐋 	: " $(shell date --iso=seconds) " : building docker image micrometerprometheusservice"; \
	docker build --force-rm -t micrometerprometheusservice . ; \
	cd ..; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image complete."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

run-micro-java:
	java -jar sample-app-micrometer-prometheus/target/micrometer-prometheus-0.0.1-SNAPSHOT.jar; 

run-micro-app: stop-micro-app rm-micro-app start-micro-app

start-micro-app: 
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker image micrometerprometheusservice"; \
	docker run \
 --name=micrometerprometheus \
 --health-cmd="curl --silent --fail localhost:8080/actuator/health || exit 1" \
 --health-interval=5s \
 --health-retries=12 \
 --health-timeout=2s \
 --health-start-period=60s \
 --net=admin-network \
 -p 8080:8080 \
 -d \
 micrometerprometheusservice:latest; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image micrometerprometheusservice started."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

stop-micro-app:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image micrometerprometheusservice"; \
	docker stop micrometerprometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \

rm-micro-app:	stop-micro-app
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image micrometerprometheusservice"; \
	docker rm micrometerprometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

bash-micro-app:
	docker exec -it micrometerprometheus bash;

show-micro-logs:
	echo "🐋 	: " $(shell date --iso=seconds) " : docker image logs for micrometerprometheusservice"; \
	docker logs -f micrometerprometheus;

curl-micro-act:
	curl localhost:8080/actuator

curl-micro-health:
	curl localhost:8080/actuator/health

.SILENT: build-micro run-micro-java run-micro-app start-micro-app stop-micro-app rm-micro-app bash-micro-app
.PHONY: build-micro run-micro-java run-micro-app start-micro-app stop-micro-app rm-micro-app bash-micro-app

build-admin:
	echo "⏲️ 	: " $(shell date --iso=seconds) " : started build script..."; \
	cd spring-boot-admin; \
	cd server; \
	mvn clean package; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : build complete."; \
	echo "🐋 	: " $(shell date --iso=seconds) " : building docker image spring-boot-admin-server"; \
	docker build --force-rm -t springadminserverservice . ; \
	cd ..\..; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : spring-boot-admin-server docker image complete."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

run-admin-java:
	java -jar -Dserver.port=9020 -Dmanagement.port=9021 spring-admin-server/target/spring-admin-server-0.0.1-SNAPSHOT.jar; 

run-admin-app: stop-admin-app rm-admin-app start-admin-app

start-admin-app: 
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker image springadminserverservice"; \
	docker run \
 --name=springadminserver \
 --health-cmd="curl --silent --fail 171.18.0.2:9020/actuator/health || exit 1" \
 --health-interval=5s \
 --health-retries=12 \
 --health-timeout=2s \
 --health-start-period=60s \
 --net admin-network \
 --ip 171.18.0.2 \
 -e "SPRING_PROFILES_ACTIVE=local" \
 -e "SPRING_APPLICATION_NAME=spring-boot-admin-server-x" \
 -e "SPRING_BOOT_ADMIN_CLIENT_URL=http://171.18.0.2:9020" \
 -p 9020:9020 \
 -d \
 springadminserverservice:latest; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image springadminserverservice started."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

stop-admin-app:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image springadminserverservice"; \
	docker stop springadminserver; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \

rm-admin-app:	stop-admin-app
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image springadminserverservice"; \
	docker rm springadminserver; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

bash-admin-app:
	docker exec -it springadminserver bash;

.SILENT: build-admin run-admin-java run-admin-app start-admin-app stop-admin-app rm-admin-app bash-admin-app
.PHONY: build-admin run-admin-java run-admin-app start-admin-app stop-admin-app rm-admin-app bash-admin-app

start-env: run-app run-prometheus run-grafana

stop-env: stop-app stop-prometheus stop-grafana

rm-env: rm-app stop-app rm-prometheus stop-prometheus rm-grafana stop-grafana

.SILENT: start-env stop-env rm-env
.PHONY: start-env stop-env rm-env

run-prometheus:
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker image prometheus"; \
	echo $(CUR_DIR) ; \
	docker run -d \
 --name=prometheus \
 -p 9090:9090 \
 -v $(CUR_DIR)/prometheus/prometheus.yml:/etc/prometheus/prometheus.yml \
 prom/prometheus ; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image prometheus started."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \
.SILENT: run-prometheus
.PHONY: run-prometheus

rm-prometheus:	stop-prometheus
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image prometheus"; \
	docker rm prometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \
.SILENT: rm-prometheus
.PHONY: rm-prometheus

stop-prometheus:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image prometheus"; \
	docker stop prometheus; \
	echo " 	: " $(shell date --iso=seconds) " : docker image stopped."; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \
.SILENT: stop-prometheus
.PHONY: stop-prometheus

run-grafana:
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker image grafana"; \
	echo $(CUR_DIR) ; \
	docker run -d \
 --name=grafana \
 -p 3000:3000 \
 grafana/grafana ; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image grafana started."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

rm-grafana:	stop-grafana
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image grafana"; \
	docker rm grafana; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

stop-grafana:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image grafana"; \
	docker stop grafana; \
	echo " 	: " $(shell date --iso=seconds) " : docker image stopped."; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \

prune:
	echo "🐋 	: " $(shell date --iso=seconds) " : pruning docker images"; \
	echo $(CUR_DIR) ; \
	docker image prune -f ; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker images pruned."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

# Running everything via docker-compose

run-env-compose:
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker environment"; \
	docker-compose up -d --build
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker environment loaded."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

update-dashboards:
	echo "⏲️ 	: " $(shell date --iso=seconds) " : extracting graphana dashboards..."; \
	./update-dashboards.sh
	echo "✔️ 	: " $(shell date --iso=seconds) " : dashboards extracted."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

show-dashboards:
	echo "⏲️ 	: " $(shell date --iso=seconds) " : graphana dashboards..."; \
	curl --user admin:admin http://localhost:3000/api/search
	echo "✔️ 	: " $(shell date --iso=seconds) " : all dashboards found."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

bash-grafana:
	docker exec -it grafana bash;

.SILENT: run-env-compose update-dashboards show-dashboards bash-grafana
.PHONY:  run-env-compose update-dashboards show-dashboards bash-grafana

start-admin-network:
	docker network create --subnet=171.18.0.0/16 admin-network;

rm-admin-network:
	docker network rm admin-network;

.SILENT: start-admin-network rm-admin-network
.PHONY:  start-admin-network rm-admin-network

