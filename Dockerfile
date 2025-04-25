# Usa una imagen base oficial de .NET SDK para compilar el proyecto
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Establece el directorio de trabajo
WORKDIR /src

# Copia los archivos del proyecto y restaura las dependencias
COPY *.csproj ./
RUN dotnet restore

# Copia el resto del código y compila
COPY . ./
RUN dotnet publish -c Release -o /app/publish

# Usa una imagen más ligera para ejecutar el proyecto
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Establece el directorio de trabajo
WORKDIR /app

# Copia los archivos publicados desde la fase anterior
COPY --from=build /app/publish .

# Copia archivo de entorno si es necesario
# COPY env .env  # Descomenta si tienes uno

# Expone el puerto 80
EXPOSE 80

# Comando para ejecutar la aplicación
ENTRYPOINT ["dotnet", "TuProyecto.dll"]
