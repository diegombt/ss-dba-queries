Course Agenda
At the end of this course, the student will learn:

# Module 1: Azure for the Data Engineer
This module explores how the world of data has evolved and how cloud data platform technologies are providing new opportunities for business to explore their data in different ways. The student will gain an overview of the various data platform technologies that are available, and how a Data Engineers role and responsibilities has evolved to work in this new world to an organization benefit.

Module Objectives:
At the end of this module, the students will be able to:

Explain the evolving world of data
## Survey the services in the Azure Data Platform
 - Tipos de datos
 - Azure Storage Accounts
 - Azure data lake
 - Azure databricks
 - Azure Cosmos DB
 - Azure SQL Database
 - Azure Synapse Analytics
 - Stream Analytics
 - Other Data Platform Services
     + Data Factory
     + HDInsight
     + Data Catalog

## Data Engineer Roles and Responsabilites
 - Data Engineer
 - Data Analyst
 - Data Scientist
 - Data Management
 - AI Engineer

## Data Engineer Practices
 - Provision
 - Process
 - Secure
 - Monitor
 - Disaster recovery

## Describe the use cases for the cloud in a Case Study

# Module 2: Working with Data Storage
This module teaches the variety of ways to store data in Azure. The Student will learn the basics of storage management in Azure, how to create a Storage Account, and how to choose the right model for the data you want to store in the cloud. They will also understand how data lake storage can be created to support a wide variety of big data analytics solutions with minimal effort.

(Exercises)[https://github.com/MicrosoftLearning/DP-200-Implementing-an-Azure-Data-Solution/blob/master/instructions/dp-200-02_instructions.md]

Module Objectives:
At the end of this module, the students will be able to:

## Choose a data storage approach in Azure
 - Benefits
     + Automated backup and recovery
     + Replication across the globe
     + Support for data analytics
     + Encryption capabilities
     + Multiple data types
     + Data storage in virtual disks
     + Storage tiers
 - Comparing Azure/On-premises
     + Cost effectiveness → What I use is what I pay for
     + Reliability
     + Storage types
     + Agility

## Create an Azure Storage Account (ASA)
Groups a set of Azure Storage Services. Number of ASAs is determined by:
 - Data Diversity
 - Cost Sensitivity
 - Management Overhead

To create a storage account you can use:
 - Azure portal
 - Azure Command Line Interface (A-CLI)
 - Managemente Cliente Librarioes
 - Azure PowerShell

## Explain Azure Data Lake Storage
Provides a repository where we can upload and store huge amounts of unstructured data with an eye toward high-performance Big Data Analytics

 - Hadoop compatible access
 - Security
 - Performance
 - Data redundancy

Use Cases
 - Modern Data Warehouse
 - Advanced Anlytics
 - Real Time Analytics

## Upload data into Azure Data Lake
 - Use Azure Storage Explorer
 - Use Azure Portal

### Stages for Processing Big Data
 1. Ingestion
 2. Store
 3. Preparation & Train
 4. Model & Serve

# Module 3: Enabling Team Based Data Science with Azure Databricks
This module introduces students to Azure Databricks and how a Data Engineer works with it to enable an organization to perform Team Data Science projects. They will learn the fundamentals of Azure Databricks and Apache Spark notebooks; how to provision the service and workspaces and learn how to perform data preparation task that can contribute to the data science project.

Module Objectives:
At the end of this module, the students will be able to:

Explain Azure Databricks
Work with Azure Databricks
Read data with Azure Databricks
Perform transformations with Azure Databricks

# Module 4: Building Globally Distributed Databases with Cosmos DB
In this module, students will learn how to work with NoSQL data using Azure Cosmos DB. They will learn how to provision the service, and how they can load and interrogate data in the service using Visual Studio Code extensions, and the Azure Cosmos DB .NET Core SDK. They will also learn how to configure the availability options so that users are able to access the data from anywhere in the world.

## Cosmos DB

## Requests Units
 - Database thorughput → reads/writes per second
 - Request Unit (RU/s) → You must reserver the number of you want Azure Cosmos DB to provision in advance

## Partition Key
 - Partition Strategy
     + Used to scale out/horizontal scaling
     + Enables to add more partitions
 - Partition Key
     + Is the value by which Azure organizes your data into logical divisions
     + Should aim to distribute operations across the database
     + The storage space for the data associated with each partition key cannot exceed 10 GB, which is the size of one physical partition in Azure Cosmos DB

Module Objectives:
At the end of this module, the students will be able to:
 - Create an Azure Cosmos DB database built to scale
 - Insert and query data in your Azure Cosmos DB database
 - Build a .NET Core app for Azure Cosmos DB in Visual Studio Code
 - Distribute your data globally with Azure Cosmos DB
     + Global Distribution
     + Multi-Master Replication
     + Fail-Over Management
     + Data Consistency Levels

# Module 5: Working with Relational Data Stores in the Cloud
In this module, students will explore the Azure relational data platform options including Azure SQL Database and the enterprise data warehouse capabilities using Azure Synapse Analytics. The student will be able explain why they would choose one service over another, and how to provision and connect to each of the services.

Module objectives
In this module, you'll learn:

Work with Azure SQL Database
Work with Azure Synapse Analytics
Provision and query data in Azure Synapse Analytics
Import data into Azure Synapse Analytics using PolyBase

# Module 6: Performing Real-Time Analytics with Stream Analytics
In this module, students will learn the concepts of event processing and streaming data and how this applies to Events Hubs and Azure Stream Analytics. The students will then set up a stream analytics job to stream data and learn how to query the incoming data to perform analysis of the data. Finally, you will learn how to manage and monitor running jobs.

Module Objectives:
At the end of this module, the students will be able to:

Explain data streams and event processing
Data Ingestion with Event Hubs
Processing Data with Stream Analytics Jobs

# Module 7: Orchestrating Data Movement with Azure Data Factory
In this module, students will learn how Azure Data Factory can be used to orchestrate the movement and transformation of data both natively and from a wide range of data platform technologies. You will be able to explain the capabilities of the technology and set up an end to end data pipeline that ingests and transforms data with an Azure data platform technology.

Module Objectives
In this module, you will:

Introduced to Azure Data Factory
Understand Azure Data Factory Components
Ingesting and Transforming Data with Azure Data Factory
Integrate Azure Data Factory with Databricks

# Module 8: Securing Azure Data Platforms
In this module, students will learn how Azure provides a multi-layered security model to protect your data. The students will explore how security can range from setting up secure networks and access keys, to defining permission through to monitoring with Advanced Threat Detection across a range of data stores.

Module Objectives:
At the end of this module, the students will be able to:

An introduction to security
Key security components
Securing Storage Accounts and Data Lake Storage
Securing Data Stores
Securing Streaming Data

# Module 9: Monitoring and Troubleshooting Data Storage and Processing
In this module, the student will get an overview of the range of monitoring capabilities that are available to provide operational support should there be issue with a data platform architecture. They will explore the common data storage and data processing issues. Finally, disaster recovery options are revealed to ensure business continuity.

Module Objectives:
At the end of this module, the students will be able to:

Explain the monitoring capabilities that are available
Troubleshoot common data storage issues
Troubleshoot common data processing issues
Manage disaster recovery