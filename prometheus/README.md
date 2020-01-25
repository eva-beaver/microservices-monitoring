### Run Prometheus via Docker

```
docker run -p 9090:9090 -v <path-to-prometheus.yml>:/etc/prometheus/prometheus.yml prom/prometheus
```
For example, in windows
```
docker run -d -p 9090:9090 -v $PWD/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus
```
