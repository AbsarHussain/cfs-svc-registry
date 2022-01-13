# Maven build container 

FROM maven:latest AS maven_build

COPY pom.xml /tmp/

COPY src /tmp/src/

WORKDIR /tmp/


RUN mvn package -e


FROM openjdk:latest

#expose port 8080
EXPOSE 30003

#default command
#CMD java -jar /data/cfs-security-broker-0.0.1-SNAPSHOT.jar

#copy hello world to docker image from builder image

COPY --from=maven_build /tmp/target/*.jar app.jar
#CMD java - jar /data/cfs-service-registry-0.0.1-SNAPSHOT.jar
ENTRYPOINT ["java", "-Dspring.config=.", "-jar", "/app.jar"]
#ENTRYPOINT ["java","-jar","/app.jar"]