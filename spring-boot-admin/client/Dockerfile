FROM adoptopenjdk/openjdk11

RUN mkdir /usr/myapp

COPY ./target/spring-boot-admin-0.0.1-SNAPSHOT.jar /usr/myapp/app.jar
WORKDIR /usr/myapp

EXPOSE 8080 

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]


