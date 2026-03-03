FROM opensuse/leap:15.5

ENV LANG=en_US.UTF-8

# Install all required packages in a single layer and clean cache to reduce image size
RUN zypper --non-interactive install --replacefiles \
  which hostname expect net-tools iputils wget vim iproute2 \
  unrar less tar gzip uuidd tcsh libaio gcc insserv-compat \
  && zypper clean -a

# uuidd is needed by SAP NW ABAP; create dirs here, daemon is started at runtime
RUN mkdir -p /run/uuidd /var/run/uuidd \
  && chown uuidd /run/uuidd /var/run/uuidd

# Make SAP installer recognise this as a valid SUSE distro
RUN printf "SUSE Linux Enterprise Server 12 (x86_64)\nVERSION = 12\nPATCHLEVEL = 1\n" \
  > /etc/SuSE-release

# Copy resources
COPY sapdownloads /tmp/sapdownloads/
# The license file must be copied to the expected location for the installer to work
COPY /sapdownloads/SYBASE_ASE_TestDrive.lic /tmp/sapdownloads/server/TAR/x86_64/
COPY /resources/INSTALL_README.MD /tmp/sapdownloads/
COPY /resources/install-quiet.sh /tmp/sapdownloads/
COPY /resources/instructions /tmp/sapdownloads/
COPY /resources/entrypoint.sh /entrypoint.sh

# Fix Windows line endings if the files were created on a Windows machine, which would cause the installer to fail with "Syntax error: unexpected end of file"
RUN sed -i 's/\r//' /tmp/sapdownloads/install-quiet.sh /tmp/sapdownloads/instructions /entrypoint.sh

# Wire up the quiet installer and the instructions as .bashrc
RUN mv /tmp/sapdownloads/install.sh /tmp/sapdownloads/org_install.sh \
  && ln -s /tmp/sapdownloads/install-quiet.sh /tmp/sapdownloads/install.sh \
  && ln /tmp/sapdownloads/instructions /root/.bashrc \
  && sed -i 's/\r//' /root/.bashrc /tmp/sapdownloads/install-quiet.sh \
  && chmod +x /tmp/sapdownloads/install-quiet.sh /entrypoint.sh

WORKDIR /tmp/sapdownloads

# Important ports to be exposed (TCP):
# HTTP
EXPOSE 8000
# HTTPS
EXPOSE 44300
# ABAP in Eclipse
EXPOSE 3300
# SAP GUI
EXPOSE 3200
# SAP Cloud Connector
EXPOSE 8443

CMD ["/entrypoint.sh"]
