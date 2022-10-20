FROM amazoncorretto:11.0.17-alpine3.16

COPY /var/jenkins_home/workspace/simple-java-maven-app/target/*.jar app.jar

ENTRYPOINT ["java", "-jar", "/simple_app.jar"]