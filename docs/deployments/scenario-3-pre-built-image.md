# Scenario 3: Pre-built Image

## Obiettivo

Buildare l'immagine Docker localmente e pubblicarla su un registry, mantenendo il codice sorgente su GitHub senza i file SAP pesanti.

## Task da Eseguire

### 1. Build Locale dell'Immagine

- [ ] **Verificare presenza file SAP**:
  ```bash
  ls -la sapdownloads/server/TAR/x86_64/
  # Verificare che tutti i file .tgz-* siano presenti (circa 13.6 GB totali)
  ```
- [ ] **Build immagine Docker locale**:
  ```bash
  docker build -t sap-netweaver-abap:752-sp04 .
  ```
- [ ] **Verificare dimensione immagine**:
  ```bash
  docker images sap-netweaver-abap:752-sp04
  # Aspettarsi circa 16-20 GB di immagine finale
  ```

### 2. Test dell'Immagine Locale

- [ ] **Avviare container di test**:
  ```bash
  docker run -d --name sap-test \
    -p 8000:8000 -p 44300:44300 -p 3300:3300 -p 3200:3200 \
    sap-netweaver-abap:752-sp04
  ```
- [ ] **Verificare installazione SAP**:
  ```bash
  docker exec -it sap-test /bin/bash
  cd /tmp/sapdownloads
  ./install.sh
  ```
- [ ] **Verificare porte e servizi** dopo installazione completa

### 3. Scegliere Registry di Destinazione

#### Opzione A: Docker Hub

- [ ] **Creare account Docker Hub** (se necessario)
- [ ] **Creare repository** (pubblico o privato)
- [ ] **Login locale**:
  ```bash
  docker login
  ```

#### Opzione B: GitHub Container Registry (GHCR)

- [ ] **Creare Personal Access Token** con scope `write:packages`
- [ ] **Login a GHCR**:
  ```bash
  echo $GITHUB_TOKEN | docker login ghcr.io -u USERNAME --password-stdin
  ```

#### Opzione C: AWS ECR

- [ ] **Configurare AWS CLI** con credenziali appropriate
- [ ] **Creare ECR repository**:
  ```bash
  aws ecr create-repository --repository-name sap-netweaver-abap-752
  ```

### 4. Tag e Push dell'Immagine

#### Per Docker Hub:

- [ ] **Tag immagine**:
  ```bash
  docker tag sap-netweaver-abap:752-sp04 username/sap-netweaver-abap-752:latest
  docker tag sap-netweaver-abap:752-sp04 username/sap-netweaver-abap-752:v7.52-sp04
  ```
- [ ] **Push immagine**:
  ```bash
  docker push username/sap-netweaver-abap-752:latest
  docker push username/sap-netweaver-abap-752:v7.52-sp04
  ```

#### Per GitHub Container Registry:

- [ ] **Tag immagine**:
  ```bash
  docker tag sap-netweaver-abap:752-sp04 ghcr.io/username/sap-netweaver-abap-752:latest
  docker tag sap-netweaver-abap:752-sp04 ghcr.io/username/sap-netweaver-abap-752:v7.52-sp04
  ```
- [ ] **Push immagine**:
  ```bash
  docker push ghcr.io/username/sap-netweaver-abap-752:latest
  docker push ghcr.io/username/sap-netweaver-abap-752:v7.52-sp04
  ```

### 5. Preparare Repository GitHub Pulito

- [ ] **Rimuovere cartella sapdownloads** dal repository:
  ```bash
  git rm -r sapdownloads/
  ```
- [ ] **Aggiungere al .gitignore**:
  ```
  # SAP installation files (large files not suitable for git)
  sapdownloads/
  *.tgz-*
  *.SAR
  ```
- [ ] **Creare script download-sap-files.sh**:
  ```bash
  #!/bin/bash
  echo "This script should download SAP NetWeaver AS ABAP Developer Edition 7.52 SP04"
  echo "from SAP Developer Center and extract to sapdownloads/ directory"
  echo ""
  echo "1. Visit: https://developers.sap.com/trials-downloads.html"
  echo "2. Download all required files"
  echo "3. Extract to sapdownloads/ directory"
  echo "4. Run: docker build -t sap-netweaver-abap:752-sp04 ."
  ```

### 6. Aggiornare Documentazione

- [ ] **Modificare README.md**:

  ````markdown
  # SAP NetWeaver AS ABAP Developer Edition 7.52 SP04

  ## Quick Start with Pre-built Image

  ```bash
  # Docker Hub
  docker pull username/sap-netweaver-abap-752:latest

  # GitHub Container Registry
  docker pull ghcr.io/username/sap-netweaver-abap-752:latest

  # Run container
  docker run -d --name sap-abap \
    -p 8000:8000 -p 44300:44300 -p 3300:3300 -p 3200:3200 \
    username/sap-netweaver-abap-752:latest
  ```
  ````

  ## Building from Source
  1. Download SAP files manually from SAP Developer Center
  2. Run `./download-sap-files.sh` for instructions
  3. Extract files to `sapdownloads/` directory
  4. Build: `docker build -t sap-netweaver-abap:752-sp04 .`

  ```

  ```

### 7. Configurare Aggiornamenti Automatici (Opzionale)

- [ ] **Creare script di CI locale** `scripts/build-and-push.sh`:

  ```bash
  #!/bin/bash
  set -e

  echo "Building SAP NetWeaver ABAP Docker image..."
  docker build -t sap-netweaver-abap:752-sp04 .

  echo "Tagging for registry..."
  docker tag sap-netweaver-abap:752-sp04 username/sap-netweaver-abap-752:latest
  docker tag sap-netweaver-abap:752-sp04 username/sap-netweaver-abap-752:$(date +%Y%m%d)

  echo "Pushing to registry..."
  docker push username/sap-netweaver-abap-752:latest
  docker push username/sap-netweaver-abap-752:$(date +%Y%m%d)

  echo "Build and push completed successfully!"
  ```

### 8. Setup Monitoraggio (Opzionale)

- [ ] **Configurare Docker Hub webhooks** per notifiche
- [ ] **Setup health check** per l'immagine:
  ```dockerfile
  HEALTHCHECK --interval=30s --timeout=10s --start-period=5m --retries=3 \
    CMD curl -f http://localhost:8000 || exit 1
  ```

### 9. Gestione Versioni

- [ ] **Creare tag Git** per ogni release:
  ```bash
  git tag -a v7.52-sp04 -m "SAP NetWeaver AS ABAP 7.52 SP04"
  git push origin v7.52-sp04
  ```
- [ ] **Documentare changelog** nel README
- [ ] **Configurare GitHub Releases** con link all'immagine Docker

## Vantaggi

- ✅ Controllo completo del processo di build
- ✅ Repository GitHub pulito senza file pesanti
- ✅ Distribuzione immediata dell'immagine ready-to-use
- ✅ Nessuna dipendenza da servizi esterni per il build
- ✅ Possibilità di test approfonditi prima della pubblicazione

## Svantaggi

- ❌ Build manuale richiesto per ogni update
- ❌ Necessità di una macchina con risorse sufficienti per il build
- ❌ Upload di immagini grandi (16-20 GB)
- ❌ Costi potenziali di storage su registry privati

## Considerazioni Tecniche

- 💾 **Spazio disco necessario**: ~40 GB (fonte + build + immagine finale)
- ⏱️ **Tempo build stimato**: 30-60 minuti (dipende dall'hardware)
- 🌐 **Tempo upload**: 2-6 ore (dipende dalla connessione internet)
- 💰 **Costi registry**: gratuito per repository pubblici, $5-20/mese per privati

## Sicurezza

- 🔒 File SAP non esposti nel codice sorgente
- 🔒 Immagine final può essere scansionata per vulnerabilità
- 🔒 Registry privati per controllo accessi enterprise
