FROM docker.io/cm2network/steamcmd:latest

ARG REHLDS_VER=3.14.0.857
ARG METAMOD_VER=1.21p38
ARG AMXX_VER=1.10.0-git5474

WORKDIR /opt/hlds

# Install required tools
USER root
RUN apt-get update && apt-get install -y wget unzip xz-utils lib32gcc-s1 && rm -rf /var/lib/apt/lists/*
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

# Create logs dir
RUN mkdir -p cstrike/logs

# Clone cstrike for preserving default values
RUN cp -a cstrike cstrike_defaults

# Setup the entrypoint script
COPY --chmod=0755 entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

EXPOSE 27015/udp 27015/tcp

CMD ["./hlds_run", "-game", "cstrike", "+ip", "0.0.0.0", "+map", "de_dust2", "+maxplayers", "32", "+sv_lan", "0"]
