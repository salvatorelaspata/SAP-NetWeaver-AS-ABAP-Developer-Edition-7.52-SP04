#!/bin/bash

# Start uuidd daemon required by SAP NW ABAP
/usr/sbin/uuidd

# Run first-time installation if SAP is not yet installed.
# Check uses a path in a persisted volume (sap-usr:/usr/sap) for reliability
# across container recreations, rather than /tmp which is ephemeral.
if [ ! -d "/usr/sap/NPL/SYS" ]; then
    echo ">>> SAP not installed yet - starting automatic installation..."
    cd /tmp/sapdownloads && bash install.sh -k
fi

exec bash
