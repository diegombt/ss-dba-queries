Carlos Fabian González Corredor (CFGONZALEZC@compensar.com)
Juan Camilo Laverde Fonseca (JCLAVERDEF@compensar.com)

# Azure
Gastos de capital frente a gastos operativos

 - Gastos de capital: los gastos de capital hacen referencia a la inversión previa de dinero en infraestructura física, el IVA de cuyas facturas se podrá deducir posteriormente. Este tipo de gasto se hace por adelantado y tiene un valor que disminuye con el tiempo.

 - Gastos operativos: los gastos operativos son dinero que se invierte en servicios o productos y se facturan al instante. Este gasto se puede deducir de la factura con IVA durante el mismo año. No hay ningún costo por adelantado. Se paga por un servicio o producto a medida que se usa.

 - Costos de los gastos de capital de informática
   Un centro de datos local típico incluye costos como los siguientes:
     + Costos de servidores
     + Costos de almacenamiento
     + Costos de red
     + Costos de copia de seguridad y archivo
     + Costos de continuidad y recuperación ante desastres de la organización
     + Costos de infraestructura del centro de datos
     + Personal técnico
 - Costos de los gastos operativos de la informática en la nube
     + Leasing de software y características personalizadas
     + El escalado se cobra en función del uso o la demanda, en lugar del hardware fijo o la capacidad.
     + Facturación en el nivel de usuario o la organización.

 - Ventajas de los gastos de capital
     + Los gastos se planean al principio de un proyecto o período de presupuesto
 - Ventajas de los gastos operativos
     + Las empresas que quieran probar un producto o un servicio nuevo no tienen que invertir en equipamiento

## Tipos de servicios en la nube
 - Infraestructura como servicio (IaaS)
  > Modelo de responsabilidad compartida.
 - Plataforma como servicio (PaaS)
 - Software como servicio (SaaS)

## Descripción de la facturación de Azure
 - Entornos
 - Estructuras organizativas
 - Facturación
 - Límites de suscripción

## Opciones de soporte técnico de Azure
 - Developer
 - Standard
 - Professional Direct

## Servicios de Azure
 - Proceso
 - Redes
 - Almacenamiento
 - Móvil
 - Bases de datos
 - Web
 - Internet de las cosas
 - Datos de gran tamaño
 - Inteligencia artificial
 - DevOps

## ¿Qué es escalar?
 - Verticalmente: aumentar recursos de memoria, cpu
     + Desarrollo/pruebas
     + Producción
     + Aislado
 - Horizontalmente: distribuir carga en multiples servicios configurados similarmente
 
## CLI de Azure
 - Ver suscripción actual de Azure
   > az account list --output table
 - Mostrar todos los grupos de recursos de una suscripción
   > az group list --output table
 - Mostrar información de recursos relativa a sitios web
   > az resource list --resource-group learn-027da438-ce85-424c-84a4-fe4fad5d9dee --resource-type Microsoft.Web/sites
 - Detener una aplicación Web en Azure
   > az webapp stop --resource-group learn-027da438-ce85-424c-84a4-fe4fad5d9dee --name al-dominio-diego
 - Iniciar una aplicación Web en Azure
   > az webapp start --resource-group learn-027da438-ce85-424c-84a4-fe4fad5d9dee --name al-dominio-diego

## Centros de datos y regiones en Azure
Una región es un área geográfica del planeta que contiene al menos un centro de datos. Las regiones se utilizan para identificar la ubicación de los recursos.

Azure divide el mundo en zonas geográficas que se definen mediante límites geopolíticos o fronteras de países

 - América
 - Europa
 - Asia Pacífico
 - Oriente Medio y África

### Zona de disponibilidad
Centros de datos separados físicamente dentro de una región de Azure
   > No todas las regiones son compatibles con las zonas de disponibilidad

Se utilizan para conseguir una alta disponibilidad sobre todo al ejecutar aplicaciones críticas. Los servicios se dividen en dos categorías:
 1. Servicios de zona
 2. Servicios de redundancia de zona

### Pares de regiones → Region Pairs
Cada región de Azure se empareja siempre con otra región de la misma zona geográfica que se encuentre como mínimo a 500 km de distancia.

Se utilizan como medio de redundancia y seguridad ante imprevistos.

#### Implementación de la aplicación con nivel de granularidad física:
Azure organiza la infraestructura en torno a regiones, que incluyen múltiples centros de datos. Puede elegir la región en la que desea implementar los recursos. No puede seleccionar un centro de datos o ubicación específicos dentro de un centro de datos.


### Acuerdos de nivel de servicio → ANS
 1. Objetivos de rendimiento
 2. Tiempo de actividad y garantías de conectividad
 3. Créditos de servicio

Su combinación se denomina como Acuerdo de Nivel de Servicio Compuesto → Composite SLA

### Mejora de la confiabilidad de la App
 - Requerimientos requirements
 - Resistencia → Resiliency
     + Alta disponibilidad
     + Recuperación de desastres
 - Costo y complejidad vs alta disponibilidad

## Cloud Services básico: administración de servicios con Azure Portal

### Opciones de administración de Azure

 1. Azure Portal
 2. Azure PowerShell/Interfaz de la línea de comandos de Azure (CLI)
 3. Azure Cloud Shell
     + Es un shell interactivo que sirve para administrar los recursos de Azure
 4. Azure Mobile App

## Opciones de proceso de Azure
 - Identificar las opciones de proceso en Azure
 - Seleccionar las opciones de proceso adecuadas para la empresa

### Conceptos esenciales de proceso de Azure

#### Azure Compute → servicio de informática a petición para ejecutar aplicaciones basadas en la nube.

#### Máquinas virtuales (IaaS)
Se pueden crear y utilizar máquinas virtuales en la nube. Se usan cuando se requiere control completo sobre el entorno de la App

 - Trasladar de maquinas virtuales a la nube
 - Escalado de MV
     + Conjuntos de disponibilidad → Availability sets
       No tienen costo, se paga por la MV que hagan parte de el
         * Mantenimiento planeado
         * Mantenimiento no planeado
     + Conjuntos de escalado de máquinas virtuales → Virtual Machine Scale Sets
       Permiten administrar, configurar y actualizar de forma centralizada un conjunto de MV
     + Azure Batch

#### Contenedores → Entorno de virtualización para ejecutar aplicaciones
 - No usan virtualización
 - Normalmente, son mas ligeros que MV
 - Permite ejecutar varias instancias de una aplicación en el mismo host
 - Estpan protegidos y aislados
 - Se usan cuando hay requerimientos de portabilidad y desempeño

Contenedore en Azure
 - Azure Container Instances (ACI)
 - Azure Kubernetes Service (AKS)

Microservicios
 - Escalar rendimiento, mantenimiento y/o actualizaciones
 - Segmentar funciones de negocio en distintas secciones lógicas

#### Azure App Service (PaaS) → Hospedar aplicaciones empresariales orientadas a la Web
Permite crear y hospedar aplicaciones web, trabajos en background, back-ends móviles y API RESTful en el lenguaje de programación que prefiera sin tener que administrar la infraestructura.

 - Se paga por los recursos de procesamiento utilizados
 - Esto está determinado por el servicio de App que se elija
 - Determina el HW dedicado

#### Informática sin servidor → Serverless computing
El usuario crea una instancia del servicio y agrega el código
 1. No hay gestión de infraestructura
 2. Ofrece escalabilidad
 3. Se paga por lo que se usa

Hay dos implementaciones:
 - Azure Functions
 - Azure Logic Apps

## Opciones de almacenamiento de datos en Azure

Ventajas
 - Copia de seguridad y recuperación automatizadas
 - Funcionalidades de equilibrio de carga, alta disponibilidad y redundancia
 - Alta seguridad
 - Compatibilidad con el análisis de datos
 - Capacidades de cifrado
 - Varios tipos de datos
     + Estructurados
     + Semiestructurados
     + No estructurados
 - Almacenamiento de datos en discos virtuales
 - Niveles de almacenamiento

### Opciones
 - Azure SQL Database (Database as a Service - DaaS)
 - Azure Cosmos DB (World wide distributed database)
 - Azure Blob Storage
 - Azure Data Lake Storage
 - Azure Files
 - Azure Queue Storage → Mensajeria
 - Disk Storage

### Niveles de almacenamiento
 - Acceso frecuente
 - Acceso esporádico
 - Almacenamiento de archivo

### Cifrado y replicación
Cifrado de servicios de almacenamiento
 - Azure Storage Service Encryption (SSE)
 - Cifrado de cliente
Replicación para disponibilidad de almacenamiento

### Ventajas vs almacenamiento local
 - Rentabilidad
 - Confiabilidad
 - Diversidad
 - Agilidad

## Opciones de redes de Azure
 - Arquitectura de acoplamiento flexible
 - Arquitectura de n niveles

### Escalado con Azure load balancer
Azure Load Balancer distribuye el tráfico entre sistemas similares, lo que hace que los servicios tengan una alta disponibilidad.
If one system is unavailable, Azure Load Balancer stops sending traffic to it. It then directs traffic to one of the responsive servers

 - Disponibilidad vs Alta disponibilidad
 - Resistencia
 - Balanceador de carga

 1. Azure Load Balancer
    No hay infraestructura ni software que mantener. Las reglas de reenvío se definen en función del puerto y la dirección IP de origen a un conjunto de puertos y direcciones IP de destino
 2. Azure Application Gateway
    Es un equilibrador de carga diseñado para las aplicaciones web, se usa si todo el tráfico es HTTP
     + Afinidad de cookies
     + Terminación de SSL
     + Firewall de aplicaciones web
     + Rutas basadas en reglas de dirección URL
     + Reescritura de encabezados HTTP
 3. DNS

### Reducción de la latencia con Azure Traffic Manager
Usa el servidor DNS que está más próximo al usuario para dirigir el tráfico de usuario a un punto de conexión distribuido globalmente.

## Seguridad, responsabilidad y confianza en Azure
La seguridad en la nube es una responsabilidad compartida

### Enfoque por capas de la seguridad
 - Datos
 - Aplicación
 - Proceso
 - Redes
 - Perímetro
 - Identidad y acceso
 - Seguridad física

### Azure Security Center
Es un servicio de supervisión que proporciona protección contra amenazas en todos los servicios

Niveles disponibles
 1. Gratuito
 2. Estándar

Escenarios de uso
 1. Como respuesta a incidentes
     + Detectar
     + Evaluar
     + Diagnosticar
 2. Como mejora de la seguridad basado en sus recomendaciones
     + Se definen directivas de seguridad
     + Se identifican posibles vulnerabilidades y se emiten recomendaciones

### Identidad y Acceso
Permite mantener un perímetro de seguridad, incluso fuera de nuestro control físico
 - Autenticación
 - Autorización

#### Azure Active Directory
 - Autenticación
 - Inicio de sesión único (SSO)
 - Administración de aplicaciones
 - Servicios de identidad de negocio a negocio (B2B)
 - Servicios de identidad de negocio a cliente (B2C)
 - Administración de dispositivos
 - Autenticación multifactor
     + Algo que sabe
     + Algo que posee
     + Algo que es

#### Aprovisionamiento de identidades en servicios
 - Entidades de servicio
     + Identidad → Un elemento que se puede autenticar
     + Entidad de seguridad → Una identidad que actúa con ciertos roles o notificaciones
 - Identidades administradas para servicios de Azure

#### Control de acceso basado en rol (RBAC)
 - Privileged Identity Management

### Cifrado 
Es el proceso para hacer que los datos aparezcan ilegibles e inútiles para visores no autorizados

 - Cifrado simétrico → usa la misma clave para cifrar y descifrar los datos
 - Cifrado asimétrico → usa un par de claves pública y privada

#### Cifrado en reposo
Son aquellos datos que se han almacenado en un medio físico

#### Cifrado en tránsito
Son datos que se están moviendo activamente de una ubicación a otra

#### Cifrado en Azure
 - Almacenamiento sin formato cifrado
 - Azure Storage Service Encryption
 - Discos de máquina virtual cifrados
 - Azure Disk Encryption
 - Bases de datos cifradas
 - Cifrado de datos transparente (TDE)
 - Cifrado de secretos
 
### Información general de los certificados de Azure
TLS usa certificados para cifrar y descifrar los datos, estos requieren administración. Tipos de certificados:

 1. De servicio → Se usan para los servicios en la nube
 2. De administración se usan para la autenticación con la API de administración

#### Azure Key Vault con certificados
 - Puede almacenar los certificados en Azure Key Vault
 - Puede crear o importar
 - Puede almacenar y administrar de forma segura
 - Puede crear directivas para el ciclo de vida
 - Puede indicar info. de contacto para expiración y renovación
 - Puede configurar renovación automática

### Protección de la red
Un enfoque en capas para la seguridad de la red ayuda a reducir el riesgo de exposición a ataques basados en la red

 - Protección de entrada al perímetro
     + Azure Firewall
     + Azure Application Gateway
     + Aplicaciones virtuales de red (NVA)
 - Bloqueo de ataques de denegación de servicio distribuido (DDoS)
   Azure DDoS Protection:
     + Básico
     + Estándar
 - Control del tráfico dentro de la red virtual
     + Seguridad de red virtual
     + Integración de red

### Proteger los documentos compartidos → Azure Information Protection (AIP)
Ayuda a clasificar y, opcionalmente, proteger documentos y correos electrónicos mediante la aplicación de etiquetas.

Se puede adquirir como
 - Solución independiente
 - Licencias Microsoft
     + Enterprise Mobility + Security
     + Microsoft 365 Enterprise.

### Azure Advanced Threat Protection (ATP)
Identifica, detecta y ayuda a investigar
 - Amenazas avanzadas
 - Identidades en peligro
 - Acciones de infiltrado malintencionadas dirigidas a la organización

Tiene los siguientes componentes:
 - Portal
 - Sensor
 - Servicio en la nube

## Aplicación y supervisión de estándares de infraestructura con Azure Policy
Se trata del gobierno de tecnologías de la información a traves de estándares y buenas practicas.

Empieza con directivas, las cuales permitiran que: 
 - Se cumplan las reglas para los recursos creados
 - La infraestructura cumpla con los estándares corporativos
 - Se garanticen los requisitos de costos
 - Se respondan los ANS con clientes

Por ejemplo, la manera más eficaz de garantizar que en toda la suscripción se sigue una convención de nomenclatura sería:
 - Crear una directiva con los requisitos de nomenclatura y asignarla al ámbito de la suscripción.

How are Azure Policy and RBAC different?
 - Azure Policy focuses on resource properties during deployment and for already-existing resources
 - Azure Policy controls properties such as the types or locations of resources
 - Unlike RBAC, Azure Policy is a default-allow-and-explicit-deny system.

### Gobierno empresarial
Los grupos de administración de Azure son contenedores para administrar el acceso, las directivas y el cumplimiento entre varias suscripciones de Azure

### Definición de recursos estándar con Azure Blueprints
Es una manera declarativa de organizar la implementación de varias plantillas de recursos y de otros artefactos, como son:

 - Asignaciones de roles
 - Asignaciones de directivas
 - Plantillas de Azure Resource Manager
 - Grupos de recursos

Es diferente de:
 - Plantillas de Resource Manager
 - Azure policy

### Cumplimiento de servicios con el Administrador de cumplimiento (Compliance Manager)
Es un panel en el que se proporciona un resumen del estado de protección de datos y cumplimiento, ademas de motrar una serie de recomendaciones para la mejora

 1. Declaración de privacidad de Microsoft
 2. Microsoft Trust Center
 3. Portal de confianza de servicios
 4. Administrador de cumplimiento

### Supervisión del estado del servicio (Service Health)
Es una forma de conocer los problemas generales o de rendimiento que pueden encontrar.

 1. Azure Monitor
    Ayuda a entender cómo funcionan las aplicaciones y permite identificar de manera proactiva los problemas que les afectan y los recursos de los que dependen
     + Data sources → puede recopilar información de multiples origenes de datos
     + Diagnostic settings
     + Getting more data from your apps
         * Application Insights
         * Azure Monitor for containers
         * Azure Monitor for VMs
     + Responding to alert conditions
         * Alerts
         * Autoscale
     + Visualize monitoring data
         * Dashboards
         * Views
         * PowerBI

 2. Azure Service Health
    Proporciona instrucciones y soporte técnico personalizado cuando hay problemas con los servicios de Azure
     + Estado de Azure → Visión global del estado de los servicios
     + Service Health → Panel con seguimiento del estado **actual** de los servicios
     + Resource Health → Panel con seguimiento del estado **histórico** de los servicios

## Control y organización de los recursos de Azure con Azure Resource Manager
Tiene una serie de características que puede usar para:
 - Organizar los recursos
 - Aplicar estándares
 - Proteger los recursos críticos contra la eliminación accidental

### Principios de los grupos de recursos (Resource groups)
Es un contenedor lógico para recursos implementados en Azure → Cualquier cosa que cree en una suscripción de Azure como máquinas virtuales, instancias de Application Gateway y de Cosmos DB. Permiten:

 - Tener una agrupación lógica
 - Planeación del ciclo de vida (muy útil en ANP)
 - Autorización → Puede facilitar la administración de muultiples recursos

#### Uso de grupos de recursos
Se recomienda:
 - Tener convenciones de nomenclautra - Azure Policy (~ linea 380)
 - Diseñar principios de organización
     + Como un conjunto de recursos (BDs/Apps/VMs)
     + Por ambiente (Ap/Pre/Pru/Dev)
     + Departamento (Mark/Fin/RH)

#### Factores que pueden afectar la organización:
 - Para la autorización
 - Para el ciclo de vida
 - Para la facturación

### Uso de etiquetas para organizar los recursos
Permiten asociar detalles sobre el recurso, el cual puede tener hasta 50 etiquetas

 - Agregaruna etiqueta a un recursos de red virutal (Azure CLI)
   > az resource tag --tags Department=Finance --resource-group msftlearn-core-infrastructure-rg --name msftlearn-vnet1 --resource-type "Microsoft.Network/virtualNetworks"

### Uso de directivas para aplicar estándares → Azure Policy
Azure Policy es un servicio que se puede usar para crear, asignar y administrar directivas. Estas directivas aplican las reglas que los recursos deben seguir

### Protección de los recursos con el control de acceso basado en rol → Role-based (RBAC)
Proporciona la administración de acceso específico para los recursos de Azure

### Uso de bloqueos de recursos para proteger los recursos → Resource locks
Es una configuración que se puede aplicar a cualquier recurso para bloquear la modificación o eliminación. Proteger elementos clave como:

 - Circuitos ExpressRoute
 - Redes virtuales
 - Bases de datos críticas
 - Controladores de dominio

#Exam AZ900
 - Which Azure service should you use to correlate events from multiple resources into a centralized repository?

   A. Azure Event Hubs
   B. Azure Analysis Services
   C. Azure Monitor
   D. Azure Log Analytics -- Answer?

 - Explanation
    I think that the key words for this answer are correlate events and resources:

    As I can see, Azure Event Hubs store events from user's applications (events designed for multiple purposes, embeded right into the application/service/...) meanwhile, Azure Monitor collects events in a centralized repository and Log Analytics allows you to edit and run querys for correlating events that are being collected in Azure Monitor.

    What do you think?


    https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/event-hubs/event-hubs-about.md

    https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/azure-monitor/overview.md

    https://github.com/MicrosoftDocs/azure-docs/blob/master/articles/azure-monitor/log-query/log-analytics-overview.md