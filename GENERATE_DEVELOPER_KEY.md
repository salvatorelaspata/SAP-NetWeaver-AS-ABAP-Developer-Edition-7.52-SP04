# Procedura per Generare Licenza Utente DEVELOPER in SAP NetWeaver AS ABAP 7.52 SP04

Questa guida descrive i passaggi per generare e installare la chiave di licenza necessaria per l'utente **DEVELOPER** nel client 001, abilitando lo sviluppo ABAP senza bisogno di access key aggiuntive. [community.sap](https://community.sap.com/t5/application-development-blog-posts/as-abap-7-52-sp04-developer-edition-concise-installation-guide/bc-p/13389569)

## Prerequisiti

- Sistema SAP NetWeaver AS ABAP Developer Edition 7.52 SP04 installato e avviato.
- Accesso SAP GUI configurato per connettersi al sistema (host locale, system number 00, client 000).
- Utente **SAP\*** con password **Down1oad** nel client 000. [community.sap](https://community.sap.com/t5/application-development-discussions/abap-7-52-sp04-developer-edition-need-a-valid-developer-access-key/m-p/12117519)

## Passaggi Dettagliati

1. **Login iniziale**: Apri SAP GUI, connettiti al client **000** con utente **SAP\*** e password **Down1oad**. [community.sap](https://community.sap.com/t5/application-development-blog-posts/as-abap-7-52-sp04-developer-edition-concise-installation-guide/bc-p/13389569)
2. **Avvia transazione SLICENSE**: Digita `/nSLICENSE` nella barra comandi e premi Invio. [scribd](https://www.scribd.com/document/673753044/Installing-as-ABAP-7-52-SP04-Developer-Edition-on-VMWare-and-Linux)
3. **Elimina licenza temporanea**: Vai alla scheda **Digitally signed licenses**, seleziona la licenza esistente (tipo "Evaluation") e clicca **Delete** (o right-click > Delete). [community.sap](https://community.sap.com/t5/application-development-discussions/abap-7-52-sp04-developer-edition-need-a-valid-developer-access-key/m-p/12117519)
4. **Copia Hardware Key**: Nota il **Hardware Key** visualizzato in alto nella schermata (es. un codice alfanumerico come "1234567890"). [scribd](https://www.scribd.com/document/673753044/Installing-as-ABAP-7-52-SP04-Developer-Edition-on-VMWare-and-Linux)

5. **Richiedi licenza online**:
   - Visita https://go.support.sap.com/minisap/.
   - Seleziona **NPL – SAP NetWeaver 7.x (Sybase ASE)** come System ID.
   - Inserisci i tuoi dati (nome, email, Hardware Key).
   - Genera e scarica il file di licenza (.txt o .key). [github](https://github.com/SAP-docs/abap-platform-trial-image/blob/main/faq-v7.md)
6. **Installa la licenza**: Torna in SLICENSE, clicca **Install**, seleziona il file scaricato e conferma. Il sistema passa a licenza "Demo". [scribd](https://www.scribd.com/document/673753044/Installing-as-ABAP-7-52-SP04-Developer-Edition-on-VMWare-and-Linux)
7. **Verifica**: Cambia client in **001**, login con **DEVELOPER** (password impostata in installazione, es. master password). Lo sviluppo è ora abilitato permanentemente. [community.sap](https://community.sap.com/t5/application-development-discussions/abap-7-52-sp04-developer-edition-need-a-valid-developer-access-key/m-p/12117519)

## Note Importanti

- La licenza è valida fino alla fine del mese successivo alla generazione (es. marzo 2026 o oltre). [community.sap](https://community.sap.com/t5/application-development-blog-posts/as-abap-7-5x-ase-license-available/bc-p/13360482)
- Se errore "Need a valid developer access key", la licenza non è installata correttamente – ripeti da client 000. [community.sap](https://community.sap.com/t5/application-development-and-automation-discussions/abap-7-52-sp04-developer-edition-need-a-valid-developer-access-key/td-p/12117519)
- Per sicurezza, crea un nuovo utente admin e disabilita SAP\* dopo l'uso. [sapbasisdurgaprasad.blogspot](https://sapbasisdurgaprasad.blogspot.com/2011/06/how-to-activate-automatic-sap-user-in.html)

Copia questo documento in un file .md per riferimento futuro. [community.sap](https://community.sap.com/t5/application-development-blog-posts/as-abap-7-52-sp04-developer-edition-concise-installation-guide/bc-p/13389569)
