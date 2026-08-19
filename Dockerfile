# build and compile
FROM maven:3.9-eclipse-temurin-21 AS builder
# start the image containing Java and Maven
WORKDIR /app
# creates a app dir that i will work inside to not work in root dir
COPY pom.xml .
RUN mvn -B dependency:go-offline
# download all maven dependencies into the layer before source code

COPY ./src ./src

RUN mvn -B clean package -DskipTests
# compiles code into .jar file

#minimal runtime image i dont need to use maven
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app
COPY --from=builder /app/target/*.jar app.jar
# pulls the .jar file from the last layer
CMD ["java", "-jar", "app.jar"]
# automated comm that runs when container start