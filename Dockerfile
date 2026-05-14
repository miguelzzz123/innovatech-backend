# ETAPA 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

# ETAPA 2: Runtime
FROM eclipse-temurin:17-jdk-jammy
WORKDIR /app
# Seguridad: Usuario no root
RUN addgroup --system devopsgroup && adduser --system devopsuser --ingroup devopsgroup
COPY --from=build /app/target/*.jar app.jar
RUN chown devopsuser:devopsgroup app.jar
USER devopsuser
EXPOSE 8081
ENTRYPOINT ["java", "-jar", "app.jar"]