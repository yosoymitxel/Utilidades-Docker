FROM node:18.19

WORKDIR /esm

COPY . .

RUN npm install

#Necesario solo para puesta en modo producción
ARG DB_NAME
ARG DB_HOST
ARG DB_PASS
ARG DB_USER

RUN echo "DB_NAME=${DB_NAME}"  > .env.production
RUN echo "DB_HOST=${DB_HOST}" >> .env.production
RUN echo "DB_PASS=${DB_PASS}" >> .env.production
RUN echo "DB_USER=${DB_USER}" >> .env.production

RUN npm run build

CMD ["npm", "run", "start"]
