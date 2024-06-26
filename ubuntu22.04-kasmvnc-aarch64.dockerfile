FROM ubuntu:22.04
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
WORKDIR /root
#-----------------------------------------------------------------------------------------------------------------------
# set repo.
RUN set -x \
&& rm -f /etc/apt/sources.list.d/* \
&& echo "\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-updates main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-backports main restricted universe multiverse\n\
deb http://mirrors.tuna.tsinghua.edu.cn/ubuntu-ports/ jammy-security main restricted universe multiverse\n\
" > /etc/apt/sources.list \
&& echo "end"
#-----------------------------------------------------------------------------------------------------------------------
# install common.
RUN set -x \
&& apt update \
&& apt install -y wget \
&& apt install -y tar \
&& apt install -y unzip \
&& apt install -y git \
&& apt install -y vim \
&& apt install -y g++ \
&& apt install -y make \
&& apt install -y pkg-config \
&& apt clean all \
&& echo "end"
#-----------------------------------------------------------------------------------------------------------------------
# install python.
RUN set -x \
&& apt update \
&& apt install -y python3 \
&& apt install -y python3-pip \
&& ln -sf /usr/bin/python3 /usr/bin/python \
&& python -m pip install --upgrade pip \
&& python -m pip config set global.index-url https://pypi.tuna.tsinghua.edu.cn/simple \
&& python -m pip config set global.trusted-host pypi.tuna.tsinghua.edu.cn \
&& python -m pip config set global.cache-dir false \
&& python -m pip config set global.disable-pip-version-check true \
&& apt clean all \
&& echo "end"
#-----------------------------------------------------------------------------------------------------------------------
# install ssh.
RUN set -x \
&& apt update \
&& apt install -y openssh-server \
&& sed -i 's/#PermitRootLogin.*/PermitRootLogin yes/' /etc/ssh/sshd_config \
&& sed -i 's/#PasswordAuthentication.*/PasswordAuthentication yes/' /etc/ssh/sshd_config \
&& echo 'root:cloud1234' | chpasswd \
&& ssh-keygen -A \
&& ssh-keygen -t rsa -C cloud -P '' -f ~/.ssh/id_rsa \
&& ssh-keygen -t ecdsa -C cloud -P '' -f ~/.ssh/id_ecdsa \
&& mkdir -p /run/sshd \
&& echo "/usr/sbin/sshd -q" >> /boot.sh \
&& echo "end"
EXPOSE 22
#-----------------------------------------------------------------------------------------------------------------------
# install gui.
RUN set -x \
&& apt update \
&& apt install -y xfce4 \
&& apt install -y xfce4-goodies \
&& apt purge -y xfce4-power-manager-plugins \
&& apt purge -y gnome-terminal \
&& wget -nv https://github.com/kasmtech/KasmVNC/releases/download/v1.2.0/kasmvncserver_jammy_1.2.0_arm64.deb -P /tmp \
&& apt install -y /tmp/kasmvncserver_jammy_1.2.0_arm64.deb \
&& echo 'cloud:$5$kasm$DAH8fimyo3/UVSYcM534anM9sdDKXe1qfQmzNtiUBw/:ow' > /root/.kasmpasswd \
&& rm -f /etc/xdg/autostart/xfce-polkit.desktop \
&& mv /etc/xdg/xfce4/panel/default.xml /etc/xdg/xfce4/xfconf/xfce-perchannel-xml/xfce4-panel.xml \
&& echo "rm -f /tmp/.X1-lock; vncserver -kill :1; vncserver :1 -select-de xfce -geometry 1280x720 -depth 24 -websocketPort 6901 \
-FrameRate=24 -interface 0.0.0.0 -BlacklistThreshold=0 -FreeKeyMappings -PreferBandwidth \
-DynamicQualityMin=4 -DynamicQualityMax=7 -DLP_ClipDelay=0" >> /boot.sh \
&& rm -rf /tmp/* \
&& echo "end"
EXPOSE 6901
