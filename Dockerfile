#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["myapp/myapp.csproj", "myapp/"]
RUN dotnet restore "myapp/myapp.csproj"
COPY . .
WORKDIR "/src/myapp"
RUN dotnet build "myapp.csproj" -c Debug -o /app

FROM build AS publish
RUN dotnet publish "myapp.csproj" -c Debug -o /app

FROM mcr.microsoft.com/dotnet/core/runtime:3.1 AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "myapp.dll"]
