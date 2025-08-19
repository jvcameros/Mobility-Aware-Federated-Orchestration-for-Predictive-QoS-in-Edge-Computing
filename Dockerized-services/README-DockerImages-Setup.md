# Docker Images Setup 🐳

This folder contains all the components required to **build Docker containers** that deploy the services defined in the **Proof of Concept (PoC)**.

## 📦 Folder Structure

Each subfolder includes the necessary files and Dockerfiles for building the corresponding container.  

**Important:**  
For the **Markov** and **VAR predictors**, two large files need to be compressed due to their size. These files are already included in their respective `/app` folders.

## ⚙️ How to Build

To build the Docker images, navigate to the folder and run:

```bash
docker build -t <your-username>/<image-name> .
