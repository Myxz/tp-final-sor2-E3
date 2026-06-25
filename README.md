# tp-final-sor2-E3
# Análisis de Logs de Seguridad con ELK Stack y Detección de Patrones con ML

## Descripción del Proyecto
Este repositorio contiene el Trabajo Final Integrador para la materia Sistemas Operativos y Redes 2. El proyecto implementa una arquitectura centralizada utilizando el stack ELK (Elasticsearch, Logstash y Kibana) mediante Docker Compose, junto con el agente Filebeat. El objetivo es recolectar, estructurar mediante filtros Grok y analizar en tiempo real los registros de seguridad del sistema operativo (`auditd`) y del servidor web (`Apache`). Adicionalmente, aplica modelos de Machine Learning para detectar patrones anómalos automatizados y superar las limitaciones operativas del análisis manual con herramientas como `ausearch`.

## Estructura del Repositorio
Tal como lo exige la rúbrica, este repositorio está organizado en los siguientes directorios:
* **/configs/**: Contiene el archivo `docker-compose.yml`, los pipelines de configuración de Logstash (`logstash.conf`) y el archivo de configuración del agente (`filebeat.yml`).
* **/dashboards/**: Contiene el dashboard de seguridad interactivo exportado desde Kibana en formato JSON.
* **/data/**: Incluye logs de muestra anonimizados generados durante los ataques y la tabla de eventos evaluados.
* **/informe/**: Contiene el documento PDF con el informe final detallado de la investigación.

## Prerrequisitos del Sistema
Para desplegar este laboratorio se requiere:
* Sistema Operativo Linux (ej. Ubuntu Server 24.04).
* Docker y Docker Compose instalados.
* Mínimo 15 GB de memoria RAM disponibles (La máquina virtual de Java - JVM de Elasticsearch está configurada para consumir 7GB de Heap para evitar caídas).

## Instrucciones de Instalación y Ejecución

### 1. Despliegue del Stack ELK Centralizado
1. Clonar el repositorio en el servidor.
2. Navegar hasta el directorio `/configs/`.
3. Levantar los contenedores ejecutando el comando:
   `docker-compose up -d`
4. Verificar que Elasticsearch responde correctamente en `http://localhost:9200` y Kibana en `http://localhost:5601`.

### 2. Configuración del Agente de Recolección (Filebeat)
1. Instalar Filebeat en el servidor origen.
2. Reemplazar el archivo de configuración por defecto con el provisto en este repositorio (`configs/filebeat.yml`).
3. Reiniciar el servicio para comenzar a ingerir los logs de auditd y Apache hacia Logstash (puerto 5044):
   `sudo systemctl restart filebeat`

### 3. Importación del Dashboard de Seguridad
1. Ingresar a la interfaz web de Kibana (`http://localhost:5601`).
2. Dirigirse al menú lateral y acceder a **Stack Management > Saved Objects**.
3. Hacer clic en **Import** y seleccionar el archivo JSON ubicado en la carpeta `/dashboards/` de este repositorio.

### 4. Simulación de Eventos de Seguridad (Pruebas)
Para validar la ingesta de datos y el funcionamiento del módulo de Machine Learning, se pueden ejecutar los siguientes comandos en el servidor:
* **Escaneo de puertos:** `nmap -A localhost`
* **Intento de acceso a archivos protegidos:** `cat /etc/shadow` (Ejecutado con un usuario estándar).
* **Escalada de privilegios fallida:** `sudo ls` (Ejecutado con un usuario que no pertenece al grupo *sudoers*).
