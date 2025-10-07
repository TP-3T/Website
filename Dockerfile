# Select the base version
FROM mcr.microsoft.com/dotnet/aspnet:9.0 AS base
WORKDIR /app
# Expose the port we want to be the entrypoint
# CB: We should be setting with the an environment variable!
EXPOSE 5231

# CB: Set the URL to be anything pointing to this port
#CB: The port number should be a variable; not sure how to do
ENV ASPNETCORE_URLS=http://*:5231

USER app
FROM --platform=$BUILDPLATFORM mcr.microsoft.com/dotnet/sdk:9.0 AS build
ARG configuration=Release
WORKDIR /src
COPY ["Website.csproj", "./"]
RUN dotnet restore "Website.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "Website.csproj" -c $configuration -o /app/build

FROM build AS publish
ARG configuration=Release
RUN dotnet publish "Website.csproj" -c $configuration -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "Website.dll"]
