FROM openjdk:8-jre

WORKDIR /usr/src/app

ADD ./target/*.jar ./app.jar

ADD https://github.com/open-telemetry/opentelemetry-java-instrumentation/releases/latest/download/opentelemetry-javaagent.jar /usr/scr/app/opentelemetry-javaagent.jar
RUN chmod 644 /usr/scr/app/opentelemetry-javaagent.jar

USER ${SERVICE_USER}
ENV JAVA_TOOL_OPTIONS="-javaagent:/usr/scr/app/opentelemetry-javaagent.jar" \
    OTEL_TRACES_EXPORTER=jaeger \
    OTEL_EXPORTER_JAEGER_ENDPOINT=http://172.26.146.178:14250 \
    OTEL_EXPORTER_JAEGER_TIMEOUT=100000 \
    OTEL_METRICS_EXPORTER=prometheus \
    # OTEL_EXPORTER_PROMETHEUS_HOST=http://172.26.146.178 \
    OTEL_LOGS_EXPORTER=logging


ENTRYPOINT ["java","-jar","./app.jar"]
