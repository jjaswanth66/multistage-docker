# First Stage: Build the Java application using Maven
FROM maven:3.8.8-eclipse-temurin-17 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the Maven project files to the container
COPY pom.xml .

# Download the project dependencies
RUN mvn dependency:go-offline -B

# Copy the entire project (after dependencies to optimize build caching)
COPY . .

# Build the application
RUN mvn clean package -DskipTests

# Second Stage: Create a lightweight runtime image
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the first stage to the second stage
COPY --from=build /app/target/*.jar /*.jar

# Expose the port the application will run on
EXPOSE 8080

# Command to run the application
CMD ["java", "-jar", "your-app.jar"]
