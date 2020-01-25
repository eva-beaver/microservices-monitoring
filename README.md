# microservices-monitoring
Playground for microservices &amp; monitoring

### Usage

```sh
make  run                 # builds grafana and prometheus 
                          # images and initializes all three containers 
                          # that forms the infra (grafana, prometheus and 
                          # node_exporter).  

make  update-dashboards   # updates the list of json files that represent
                          # the dashboards configured in Grafana.

```

### More

