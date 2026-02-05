FROM docker.io/cm2network/steamcmd:latest

ARG REHLDS_VER=3.14.0.857
ARG REGAMEDLL_VER=5.28.0.756
ARG REAPI_VER=5.26.0.338
ARG METAMOD_VER=1.21p38
ARG AMXX_VER=1.10.0-git5474

WORKDIR /opt/hlds

# Install required tools
USER root
RUN apt-get update && apt-get install -y wget unzip xz-utils lib32gcc-s1 && rm -rf /var/lib/apt/lists/*

# Setup the entrypoint script
RUN <<EOF cat > /entrypoint.sh && chmod +x /entrypoint.sh
#!/bin/sh
set -e

if [ -z "\$(ls -A /opt/hlds/cstrike 2>/dev/null)" ]; then
  echo "Initializing cstrike directory"
  cp -a /opt/hlds/cstrike_defaults/. /opt/hlds/cstrike/
fi

exec "\$@"
EOF
ENTRYPOINT ["/entrypoint.sh"]

# Switch to the steam user
RUN chown -R steam:steam /opt/hlds
USER steam

# Download CS 1.6 via SteamCMD
RUN /home/steam/steamcmd/steamcmd.sh \
    +force_install_dir /opt/hlds \
    +login anonymous \
    +app_set_config 90 mod cstrike \
    +app_update 90 validate \
    +quit

# Download and install ReHLDS
RUN wget https://github.com/rehlds/ReHLDS/releases/download/${REHLDS_VER}/rehlds-bin-${REHLDS_VER}.zip && \
    unzip -q rehlds-bin-${REHLDS_VER}.zip && \
    rm rehlds-bin-${REHLDS_VER}.zip

# Download and install ReGameDLL
RUN wget https://github.com/rehlds/ReGameDLL_CS/releases/download/${REGAMEDLL_VER}/regamedll-bin-${REGAMEDLL_VER}.zip && \
    mkdir -p regamedll-bin-${REGAMEDLL_VER} && \
    unzip -q regamedll-bin-${REGAMEDLL_VER}.zip -d regamedll-bin-${REGAMEDLL_VER} && \
    cp -r regamedll-bin-${REGAMEDLL_VER}/bin/linux32/cstrike/* cstrike/ && \
    rm -rf regamedll-bin-${REGAMEDLL_VER} regamedll-bin-${REGAMEDLL_VER}.zip

# Fix liblist.game crash issue
RUN cd cstrike && ln -s dlls/cs.so dlls/cs_i386.so

# Download and install Metamod-P
RUN wget https://github.com/Bots-United/metamod-p/releases/download/v${METAMOD_VER}/metamod_i686_linux_win32-${METAMOD_VER}.tar.xz && \
    mkdir -p cstrike/addons/metamod && \
    tar -xJf metamod_i686_linux_win32-${METAMOD_VER}.tar.xz -C cstrike/addons/ && \
    rm metamod_i686_linux_win32-${METAMOD_VER}.tar.xz && \
    echo 'linux addons/metamod/metamod_i386.so' > cstrike/addons/metamod/plugins.ini

# Download and install AMX Mod X
RUN wget https://www.amxmodx.org/amxxdrop/1.10/amxmodx-${AMXX_VER}-base-linux.tar.gz && \
    wget https://www.amxmodx.org/amxxdrop/1.10/amxmodx-${AMXX_VER}-cstrike-linux.tar.gz && \
    tar -xzf amxmodx-${AMXX_VER}-base-linux.tar.gz -C cstrike/ && \
    tar -xzf amxmodx-${AMXX_VER}-cstrike-linux.tar.gz -C cstrike/ && \
    rm amxmodx-*.tar.gz

# Download and install ReAPI
RUN wget https://github.com/rehlds/ReAPI/releases/download/${REAPI_VER}/reapi-bin-${REAPI_VER}.zip && \
    unzip -q reapi-bin-${REAPI_VER}.zip -d cstrike/ && \
    rm reapi-bin-${REAPI_VER}.zip

# Create logs dir
RUN mkdir -p cstrike/logs

# Clone cstrike for preserving default values
RUN cp -a cstrike cstrike_defaults

EXPOSE 27015/udp 27015/tcp

CMD ["./hlds_run", "-game", "cstrike", "+ip", "0.0.0.0", "+map", "de_dust2", "+maxplayers", "32", "+sv_lan", "0"]
