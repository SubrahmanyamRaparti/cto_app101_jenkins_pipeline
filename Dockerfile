FROM amazoncorretto:11.0.17-alpine3.16

COPY target/*.jar simple_app.jar

ENTRYPOINT ["java", "-jar", "/simple_app.jar"]