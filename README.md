# Utilidades Docker

Este repositorio contiene utilidades y configuraciones de Docker diseñadas para facilitar el desarrollo y la implementación de proyectos basados en **CakePHP 3.x** y **Next.js/React**. El objetivo es proporcionar soluciones eficientes que optimicen el flujo de trabajo de los desarrolladores.

## Tabla de Contenidos

- [Características](#características)
- [Tecnologías](#tecnologías)
- [Instalación](#instalación)
- [Uso](#uso)

## Características

- **Configuraciones de Docker para CakePHP 3.x**: Incluye archivos de configuración para una integración fluida con CakePHP.
- **Configuraciones de Docker para Next.js/React**: Proporciona configuraciones específicas para proyectos en Next.js y React.
- **Utilidades adicionales**: Herramientas y scripts que mejoran la experiencia de desarrollo con Docker.

## Tecnologías

- **Docker**: Plataforma de contenedores que permite crear, implementar y ejecutar aplicaciones en contenedores.
- **CakePHP 3.x**: Framework de desarrollo web en PHP que facilita la creación de aplicaciones.
- **Next.js/React**: Framework y biblioteca de JavaScript para construir interfaces de usuario.

## Instalación

Para utilizar las configuraciones de Docker en este repositorio, sigue estos pasos:

1. Clona el repositorio:
   ```bash
   git clone https://github.com/yosoymitxel/Utilidades-Docker.git
   cd Utilidades-Docker
   ```

2. Asegúrate de tener Docker instalado en tu máquina. Puedes descargarlo desde [Docker Hub](https://www.docker.com/products/docker-desktop).

3. Configura los archivos de Docker según las necesidades de tu proyecto.

## Uso

Para iniciar un contenedor Docker, utiliza el siguiente comando en la raíz de tu proyecto:

```bash
docker compose up
o
docker compose watch
```

Esto levantará los servicios definidos en tu archivo `docker-compose.yml` o `compose.yml`.

