FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /src

# Copy project file
COPY ["TurnTheTides.csproj", "./"]
RUN dotnet restore "TurnTheTides.csproj"

# Copy source code
COPY . .
RUN dotnet publish "TurnTheTides.csproj" -c Release -o /app/publish

# Use nginx to serve the static files
FROM nginx:alpine AS final
WORKDIR /usr/share/nginx/html
COPY --from=build /app/publish/wwwroot .
COPY nginx.conf /etc/nginx/nginx.conf
EXPOSE 80