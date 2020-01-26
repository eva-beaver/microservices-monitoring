FROM adoptopenjdk/openjdk11

RUN mkdir /usr/myapp

COPY ./target/spring-boot-admin-client-1.0.0.jar /usr/myapp/app.jar
WORKDIR /usr/myapp

EXPOSE 9040 
EXPOSE 9041 

ENTRYPOINT [ "sh", "-c", "java $JAVA_OPTS -jar app.jar" ]


