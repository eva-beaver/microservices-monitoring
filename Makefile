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
	echo "build 		- build application and generate docker image"
	echo "run-app		- run application on docker"
	echo "stop-app		- stop application"
	echo "rm-app		- stop and delete application"
	echo ""
	echo "help		- show this message"

build:
	echo "⏲️ 	: " $(shell date --iso=seconds) " : started build script..."; \
	cd sample-app-micrometer-prometheus; \
	mvn clean package; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : build complete."; \
	cd ..; \
	echo "🐋 	: " $(shell date --iso=seconds) " : building docker image micrometerprometheusservice"; \
	docker build --force-rm -t micrometerprometheusservice . ; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image complete."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

run-app-java:
	java -jar sample-app-micrometer-prometheus/target/micrometer-prometheus-0.0.1-SNAPSHOT.jar; 

run-app: stop-app rm-app start-app

start-app: 
	echo "🐋 	: " $(shell date --iso=seconds) " : starting docker image micrometerprometheusservice"; \
	docker run \
 --name=micrometerprometheus \
 --health-cmd="curl --silent --fail localhost:8080/actuator/health || exit 1" \
 --health-interval=5s \
 --health-retries=12 \
 --health-timeout=2s \
 --health-start-period=60s \
 -p 8080:8080 \
 -d \
 micrometerprometheusservice:latest; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image micrometerprometheusservice started."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

stop-app:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image micrometerprometheusservice"; \
	docker stop micrometerprometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \

rm-app:	stop-app
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image micrometerprometheusservice"; \
	docker rm micrometerprometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

bash-app:
	docker exec -it micrometerprometheus bash;

show-logs:
	echo "🐋 	: " $(shell date --iso=seconds) " : docker image logs for micrometerprometheusservice"; \
	docker logs -f micrometerprometheus;

curl-act:
	curl localhost:8080/actuator

curl-health:
	curl localhost:8080/actuator/health

start-env: run-app run-prometheus run-grafana

stop-env: stop-app stop-prometheus stop-grafana

rm-env: rm-app stop-app rm-prometheus stop-prometheus rm-grafana stop-grafana

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

rm-prometheus:	stop-prometheus
	echo "🐋 	: " $(shell date --iso=seconds) " : removing docker image prometheus"; \
	docker rm prometheus; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image removed."; \
	echo "👋 	: " $(shell date --iso=seconds) " : exiting..."; \

stop-prometheus:
	echo "🐋 	: " $(shell date --iso=seconds) " : stopping docker image prometheus"; \
	docker stop prometheus; \
	echo " 	: " $(shell date --iso=seconds) " : docker image stopped."; \
	echo "✔️ 	: " $(shell date --iso=seconds) " : docker image stopped."; \


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


