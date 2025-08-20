# Orchestrator Docker Image 🔄

This folder contains the Docker image for the **Orchestrator** used in the project. The orchestrator is responsible for managing the OpenStack infrastructure and controlling the scenario topology.

## ⚙️ Key Component: `clouds.yaml`

Inside the orchestrator image, there is a file called `clouds.yaml` that **guarantees access** to the OpenStack infrastructure used in the project.  

> **Important:** For security reasons, this file has been **modified in the repository**, as it contains **private credentials and sensitive information**.

The `clouds.yaml` file is utilized by the orchestrator to:

- Connect to the OpenStack environment.
- Modify the **scenario topology** when migrating a **pedestrian** from one **PoP (Point of Presence)** to another.
- Ensure that the orchestrator can perform operations such as instance migration, network reconfiguration, and resource allocation safely.

## 🔐 Security Note

- Do **not commit your personal `clouds.yaml`** with real credentials to the repository.  
- Use environment variables or secret management tools if you need to run the orchestrator in your own OpenStack setup.

## 📦 Usage

Once the Docker image is built, the orchestrator can be run to manage migrations and other scenario operations using the internal `clouds.yaml` configuration.
