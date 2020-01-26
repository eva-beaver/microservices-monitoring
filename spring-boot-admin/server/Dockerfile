FROM adoptopenjdk/openjdk11

RUN mkdir /usr/myapp

COPY ./target/spring-boot-admin-server-1.0.0.jar /usr/myapp/app.jar
WORKDIR /usr/myapp

EXPOSE 9020
EXPOSE 9021

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]


