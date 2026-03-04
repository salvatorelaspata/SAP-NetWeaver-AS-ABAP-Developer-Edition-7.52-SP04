#!/bin/bash

echo "=== AVVIO ENTRYPOINT SCRIPT ==="
echo "Timestamp: $(date)"

# Start uuidd daemon required by SAP NW ABAP
echo "Avvio uuidd daemon..."
/usr/sbin/uuidd
echo "uuidd daemon avviato."

# Run first-time installation if SAP is not yet installed.
# Check for actual SAP installation, not just directory existence
echo "Controllo se SAP è già installato..."
echo "Controllo directory /usr/sap/NPL/SYS: $(ls -la /usr/sap/NPL/SYS 2>/dev/null | wc -l) files"

# More reliable check: look for SAP binaries and configuration files
SAP_INSTALLED=false
if [ -d "/usr/sap/NPL/SYS" ] && [ -n "$(ls -A /usr/sap/NPL/SYS 2>/dev/null)" ]; then
    echo "Directory /usr/sap/NPL/SYS esiste e non è vuota"
    # Check for critical SAP files
    if [ -f "/usr/sap/NPL/SYS/profile/NPL_DVEBMGS00_vhcalnplci" ] || \
       [ -d "/usr/sap/NPL/DVEBMGS00" ] || \
       [ -f "/usr/sap/NPL/SYS/exe/run/disp+work" ]; then
        echo "Trovati file SAP critici - SAP sembra installato"
        SAP_INSTALLED=true
    else
        echo "Directory esiste ma mancano file SAP critici"
    fi
else
    echo "Directory /usr/sap/NPL/SYS non esiste o è vuota"
fi

if [ "$SAP_INSTALLED" = "false" ]; then
    echo ">>> SAP not installed yet - starting automatic installation..."
    echo "Cambio directory a /tmp/sapdownloads"
    cd /tmp/sapdownloads
    echo "Contenuto della directory:"
    ls -la
    echo "Esecuzione di install.sh..."
    # Automaticamente risponde 'yes' a tutte le domande interattive
    echo "yes" | bash install.sh -k
    echo "Install.sh terminato con codice: $?"
    SAP_INSTALLED=true
else
    echo ">>> SAP è già installato, skip installazione."
fi

# Avvio automatico di SAP se installato
if [ "$SAP_INSTALLED" = "true" ]; then
    echo "=== AVVIO SAP ==="
    su - npladm -c 'startsap ALL'
    echo "startsap terminato con codice: $?"
    echo "=== VERIFICA STATO SAP ==="
    su - npladm -c 'sapcontrol -nr 00 -function GetProcessList'
fi

echo "=== ENTRYPOINT COMPLETATO ==="
# Mantiene il container in esecuzione
exec tail -f /dev/null
