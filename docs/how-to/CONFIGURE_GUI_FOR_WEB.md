# Configurare SAP GUI per Accesso Web

## Prerequisiti

Verifica che l'ICM (Internet Communication Manager) sia in esecuzione tramite la transazione **SMICM**. Controlla i parametri ICM come `icm/server_port_0 = PROT=HTTP,PORT=<porta>` (es. 8000) e `icm/host_name_full = <FQDN del server>`. Assicurati che il sistema SAP NetWeaver sia configurato per servizi web. [community.sap](https://community.sap.com/t5/technology-blog-posts-by-members/how-to-configure-web-gui-for-sap/ba-p/13208789)

## Verifica ICM

Esegui **SMICM** e vai su **Goto > Parameters > Display** per confermare i parametri di porta HTTP/HTTPS e hostname completo. L'ICM deve essere attivo per gestire le richieste web. [scribd](https://www.scribd.com/doc/178424062/Activate-Web-GUI-for-SAP-pdf)

## Attivazione Servizi ICF

Avvia la transazione **SICF** e naviga/attiva i seguenti servizi (tasto destro > **Activate Service**, conferma con "Yes" per attivare anche i nodi genitori):

- `/default_host/sap/bc/gui/sap/its/webgui`
- `/default_host/sap/public/bc/its/mimes`
- `/default_host/sap/public/bc/ur`. [help.sap](https://help.sap.com/docs/SAP_FIORI_OVERVIEW/17ca92fbe8f54d9d8dfbe830cbb0c8d2/bf6052d84b2548e1a46c3edeb932e8de.html&version=4_2020.000)

I servizi passano da grigio (disattivi) a nero (attivi). [eathealthy365](https://eathealthy365.com/sap-netweaver-webgui-configuration-step-by-step-tutorial/)

## Pubblicazione Servizi ITS

Esegui **SE80 > Utilities > Settings > Internet Transaction Server > Publish tab** (imposta "INTERNAL"), poi pubblica i servizi **SYSTEM** e **WEBGUI** (tasto destro > **Publish > Complete Service**). Infine, lancia **SIAC_PUBLISH_ALL_INTERNAL** e attendi il completamento. [itsiti](https://itsiti.com/activate-configure-sap-its-webgui/)

## Test Accesso

Accedi via browser all'URL: `http://<server>:<porta>/sap/bc/gui/sap/its/webgui/` (es. http://testp1.bomain.cpstl:8000/sap/bc/gui/sap/its/webgui/). Inserisci credenziali SAP per verificare il login. Per transazioni specifiche: `?~transaction=<TCODE>`. [saptechnicalguru](https://www.saptechnicalguru.com/its/)
