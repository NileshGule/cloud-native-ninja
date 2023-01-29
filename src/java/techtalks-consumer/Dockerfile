FROM eclipse-temurin:19.0.1_10-jdk-alpine AS build

# FROM openjdk:19-alpine AS build

# Set the working directory
WORKDIR /app

# Copy the Maven dependencies
COPY pom.xml /app/pom.xml
COPY mvnw /app/mvnw
COPY .mvn /app/.mvn

# # Build the application
# RUN ./mvnw package -DskipTests

# RUN ./mvnw dependency:go-offline

# Copy the application files
COPY src /app/src

# Build the application
RUN ./mvnw package -DskipTests

# Create the runtime image
# FROM openjdk:19-alpine

FROM eclipse-temurin:19-jre-alpine

# Set the working directory
WORKDIR /app

# Copy the application files
COPY --from=build /app/target/techtalks-consumer-0.0.1-SNAPSHOT.jar TechTalksConsumer.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "TechTalksConsumer.jar"]

