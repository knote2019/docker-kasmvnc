FROM ubuntu:20.04
# set entrypoint.
RUN set -x \
&& echo > /boot.sh \
&& chmod +x /boot.sh \
&& echo '#!/usr/bin/env bash' >/usr/bin/entrypoint \
&& echo 'bash /boot.sh' >>/usr/bin/entrypoint \
&& echo 'cat' >>/usr/bin/entrypoint \
&& chmod +x /usr/bin/entrypoint
ENV DEBIAN_FRONTEND=noninteractive
ENTRYPOINT ["/usr/bin/entrypoint"]
#-----------------------------------------------------------------------------------------------------------------------
# set repo.
RUN set -x \
&& rm -f /etc/apt/sources.list.d/* \
&& echo "\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-backports main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu/ focal-security main restricted universe multiverse\n\
" > /etc/apt/sources.list \
&& echo "end"

# install ssh.
RUN set -x \
&& apt update \
&& apt install -y openssh-server \
&& sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
&& echo 'root:cloud1234' | chpasswd \
&& ssh-keygen -A \
&& mkdir -p /run/sshd \
&& echo "/usr/sbin/sshd -q" >> /boot.sh \
&& apt clean all \
&& echo "end"

# install gui.
RUN set -x \
&& apt update \
&& apt install -y xfce4 \
&& apt install -y xfce4-goodies \
&& apt purge -y xfce4-power-manager-plugins \
&& apt purge -y gnome-terminal \
&& apt install -y wget \
&& wget -nv https://github.com/kasmtech/KasmVNC/releases/download/v1.2.0/kasmvncserver_focal_1.2.0_amd64.deb -P /tmp \
&& apt install -y /tmp/kasmvncserver_focal_1.2.0_amd64.deb \
&& echo 'cloud:$5$kasm$DAH8fimyo3/UVSYcM534anM9sdDKXe1qfQmzNtiUBw/:ow' > /root/.kasmpasswd \
&& rm -f /etc/xdg/autostart/xfce-polkit.desktop \
&& mv /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml \
&& echo "vncserver -kill :1; vncserver :1 -select-de xfce -geometry 1280x720 -depth 24 -websocketPort 6901 \
-FrameRate=24 -interface 0.0.0.0 -BlacklistThreshold=0 -FreeKeyMappings -PreferBandwidth \
-DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0" >> /boot.sh \
&& rm -rf /tmp/* \
&& echo "end"
