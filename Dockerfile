FROM mcr.microsoft.com/dotnet/sdk:latest AS build-env
#Navigate to the "/app" folder (create if it not exists)
WORKDIR /app

#copy csproj and download the dependencies listed in that file
COPY *.csproj ./
RUN dotnet restore

#copy all files in the projetct folder 
COPY . ./
RUN dotnet publish -c Release -o out

#Build runtime image
FROM mcr.microsoft.com/dotnet/core/aspnet:latest
WORKDIR /app
COPY --from=build-env /app/out .

ENTRYPOINT ["dotnet", "appMVC.dll"]
