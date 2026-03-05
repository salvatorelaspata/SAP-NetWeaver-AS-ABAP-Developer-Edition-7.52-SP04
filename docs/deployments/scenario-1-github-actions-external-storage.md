# Scenario 1: GitHub Actions + External Storage

## Obiettivo

Creare un build automatico su GitHub che scarica i file SAP da un servizio cloud esterno durante il processo di build.

## Task da Eseguire

### 1. Preparazione dei File SAP

- [ ] **Comprimere la cartella sapdownloads**
  ```bash
  tar -czf sapdownloads.tar.gz sapdownloads/
  ```
- [ ] **Upload su servizio cloud** (scegliere una delle opzioni):
  - AWS S3 (bucket privato)
  - Google Cloud Storage
  - Azure Blob Storage
  - GitHub Releases (se sotto 2GB)
- [ ] **Ottenere URL di download** pubblico o con autenticazione

### 2. Modificare il Dockerfile

- [ ] **Aggiungere stage per download**

  ```dockerfile
  # Download SAP files stage
  FROM alpine/git as downloader
  RUN apk add --no-cache wget curl
  ARG SAP_DOWNLOAD_URL
  WORKDIR /downloads
  RUN wget "$SAP_DOWNLOAD_URL" -O sapdownloads.tar.gz
  RUN tar -xzf sapdownloads.tar.gz

  # Main stage
  FROM opensuse/leap:15.5
  # ... resto del Dockerfile
  COPY --from=downloader /downloads/sapdownloads /tmp/sapdownloads/
  ```

### 3. Creare GitHub Actions Workflow

- [ ] **Creare file `.github/workflows/build-docker.yml`**

  ```yaml
  name: Build SAP Docker Image

  on:
    push:
      branches: [main]
    workflow_dispatch:

  env:
    REGISTRY: ghcr.io
    IMAGE_NAME: ${{ github.repository }}/sap-netweaver-abap

  jobs:
    build:
      runs-on: ubuntu-latest
      permissions:
        contents: read
        packages: write

      steps:
        - name: Checkout repository
          uses: actions/checkout@v4

        - name: Log in to Container Registry
          uses: docker/login-action@v3
          with:
            registry: ${{ env.REGISTRY }}
            username: ${{ github.actor }}
            password: ${{ secrets.GITHUB_TOKEN }}

        - name: Extract metadata
          id: meta
          uses: docker/metadata-action@v5
          with:
            images: ${{ env.REGISTRY }}/${{ env.IMAGE_NAME }}

        - name: Build and push Docker image
          uses: docker/build-push-action@v5
          with:
            context: .
            push: true
            tags: ${{ steps.meta.outputs.tags }}
            labels: ${{ steps.meta.outputs.labels }}
            build-args: |
              SAP_DOWNLOAD_URL=${{ secrets.SAP_DOWNLOAD_URL }}
  ```

### 4. Configurare Secrets GitHub

- [ ] **Andare in Settings > Secrets and variables > Actions**
- [ ] **Aggiungere secret**: `SAP_DOWNLOAD_URL` con l'URL del file compresso
- [ ] **Se necessario**: aggiungere credenziali cloud (AWS_ACCESS_KEY_ID, etc.)

### 5. Aggiornare Documentation

- [ ] **Modificare README.md** per spiegare il nuovo processo
- [ ] **Aggiungere istruzioni** per scaricare l'immagine da GitHub Container Registry
- [ ] **Documentare variabili ambiente** necessarie

### 6. Test e Validazione

- [ ] **Fare push del codice** per triggerare il build
- [ ] **Verificare build su GitHub Actions**
- [ ] **Testare l'immagine generata**:
  ```bash
  docker pull ghcr.io/USERNAME/REPO/sap-netweaver-abap:latest
  docker run -d --name sap-test ghcr.io/USERNAME/REPO/sap-netweaver-abap:latest
  ```

## Vantaggi

- ✅ Repository GitHub pulito (senza file pesanti)
- ✅ Build automatico su ogni push
- ✅ Versionamento delle immagini Docker
- ✅ Distribuzione tramite GitHub Container Registry

## Svantaggi

- ❌ Dipendenza da servizio cloud esterno
- ❌ Possibili costi storage cloud
- ❌ Complessità setup iniziale maggiore

## Costi Stimati

- GitHub Actions: gratuito per repository pubblici
- Storage cloud: $1-5/mese per 15GB
- Bandwidth: variabile in base al numero di download
