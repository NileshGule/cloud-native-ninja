# FROM eclipse-temurin:17-jdk-alpine AS build
# FROM arm64v8/eclipse-temurin AS build
FROM eclipse-temurin:17-jdk-jammy AS build

# Set the working directory
WORKDIR /app

# Copy the Maven dependencies
COPY pom.xml /app/pom.xml
COPY mvnw /app/mvnw
COPY .mvn /app/.mvn

# Copy the application files
COPY src /app/src

# Build the application
# RUN ./mvnw package -DskipTests
RUN --mount=type=cache,id=maven,target=/root/.m2 ./mvnw package -DskipTests

# Create the runtime image
# FROM eclipse-temurin:17-jre-alpine
FROM eclipse-temurin:17-jre-focal

# Set the working directory
WORKDIR /app

# Copy the application files
COPY --from=build /app/target/techtalks-consumer-0.0.1-SNAPSHOT.jar TechTalksConsumer.jar

# Expose the application port
EXPOSE 8080

# Run the application
ENTRYPOINT ["java", "-jar", "TechTalksConsumer.jar"]

