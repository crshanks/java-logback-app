FROM maven:3.5-jdk-8 AS build
COPY src /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml clean package

FROM openjdk:8-jdk-alpine
COPY --from=build /usr/src/app/target/logback-app-1.0-SNAPSHOT-jar-with-dependencies.jar /usr/app/logback-app.jar
COPY --from=build /usr/src/app/target/newrelic/newrelic.jar /artifacts/newrelic.jar

ENV AGENT_JAR='-javaagent:/artifacts/newrelic.jar'
ENV AGENT_SYS_PROPS='-Dnewrelic.config.log_file_name=STDOUT -Dnewrelic.config.log_level=info -Dnewrelic.config.audit_mode=true -Dnewrelic.config.license_key=$NEW_RELIC_LICENSE_KEY -Dnewrelic.config.app_name=logback-app -Dnewrelic.config.distributed_tracing.enabled=true -Dnewrelic.config.sync_startup=true -Dnewrelic.config.send_data_on_exit=true -Dnewrelic.config.send_data_on_exit_threshold=1'
RUN echo 'java $AGENT_JAR $AGENT_SYS_PROPS -jar /usr/app/logback-app.jar' > /bootstrap.sh
RUN chmod +x /bootstrap.sh
CMD /bootstrap.sh
# Comment out the line above, and replace with the one below to allow command line access to the container
#CMD exec /bin/sh -c "trap : TERM INT; sleep 9999999999d & wait"