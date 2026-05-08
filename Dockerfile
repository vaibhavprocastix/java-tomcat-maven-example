# STAGE 1: Build the application
FROM maven:3.9-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application and create the WAR file
RUN mvn clean package

# STAGE 2: Deploy to Tomcat
FROM tomcat:11.0-jdk17-temurin-ubuntu

# Remove default Tomcat webapps to save space/security
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy the WAR file from the build stage to the Tomcat webapps directory
# Note: we rename it to ROOT.war so it is accessible at the base URL (/)
COPY --from=build /app/target/java-tomcat-maven-example.war /usr/local/tomcat/webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
