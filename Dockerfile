# STAGE 1: Build the application (Using a highly stable tag)
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy the pom.xml and source code
COPY pom.xml .
COPY src ./src

# Build the application and create the WAR file
RUN mvn clean package

# STAGE 2: Deploy to Tomcat (Using the correct official tag)
FROM tomcat:11.0-jdk17-temurin

# Remove default Tomcat webapps
RUN rm -rf /usr/local/tomcat/webapps/*

# Renaming to ROOT.war makes it available at http://localhost:8080/
COPY --from=build /app/target/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
