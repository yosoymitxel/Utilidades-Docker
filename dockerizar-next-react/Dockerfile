# Etapa de construcción y producción
FROM node:22-alpine

# Establecer el directorio de trabajo
WORKDIR /app

# Asignación de variables de entorno en caso de que no estén definidos
ARG ENV_FILE_CONTENT

RUN if [ -z "$ENV_FILE_CONTENT" ]; then \
    if [ -f .env ]; then \
    cp .env .env            ; \
    echo "# No se ha proporcionado el contenido del archivo .env" >> .env; \
    else \
    cp example.env .env; \
    echo "# Se ha copiado el archivo .env.example como .env" >> .env; \
    fi; \
    else \
    echo "$ENV_FILE_CONTENT" > .env && \
    echo "# Se ha creado el archivo .env con el contenido proporcionado." >> .env; \
    fi
# Copiar el archivo .env y renombrarlo según entorno
RUN for env in production development; do cp .env .env.$env; done

# Copiar archivos necesarios para instalar dependencias
COPY package.json package-lock.json ./

# Instalar dependencias
RUN npm install && npm audit fix --force

# Copiar el resto del código fuente
COPY . .

# Construir la aplicación
RUN npm run build

# Comando para iniciar la aplicación
# run dev en caso de querer ver modificaciones en tiempo real
CMD ["npm", "run", "start"] 
