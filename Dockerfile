# Stage 1: Build environment with .NET Core SDK
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

ENV IP 192.168.1.100

# Copy all files in the project folder
COPY . /app

# Navigate to the “/app” folder (create if not exists)
WORKDIR /app

# Copy csproj and download the dependencies listed in that file
COPY *.csproj ./
RUN dotnet restore

# Build the application for release in a separate directory
RUN dotnet publish -c Release -o out

# Stage 2: Runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Working directory for the runtime image
WORKDIR /app

# Copy the published application from the build stage
COPY --from=build-env /app/out .


WORKDIR app/

# Entrypoint to run the application
ENTRYPOINT ["dotnet", "run"]

EXPOSE 8080
