FROM adoptopenjdk/openjdk11

RUN mkdir /usr/myapp

COPY ./sample-app-micrometer-prometheus/target/micrometer-prometheus-0.0.1-SNAPSHOT.jar /usr/myapp/app.jar
WORKDIR /usr/myapp

EXPOSE 8080 

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]


