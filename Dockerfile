FROM centos:7

MAINTAINER Boris Maslakov <b.maslakov@dlg.im>

# update and epel-release
RUN yum -y update && yum -y install epel-release

# basic tools
RUN yum -y install wget \
                   net-tools \
                   ns \
                   vim \
                   mc \
                   nc \
                   tcpdump

# asterisk dependencies
RUN yum -y install autoconf \
                   automake \
                   bzip2 \
                   gcc-c++ \
                   jansson-devel \
                   libtool \
                   libuuid-devel \
                   libxml2-devel \
                   ncurses-devel \
                   make \
                   pjproject \
                   sqlite-devel \
                   tar \
                   uuid-devel \
                   xmlstarlet

WORKDIR /usr/src

RUN wget http://downloads.asterisk.org/pub/telephony/asterisk/releases/asterisk-15.4.0.tar.gz && \
    tar -zxvf asterisk-15.4.0.tar.gz

RUN cd asterisk-15.4.0/contrib/scripts/ && \
    ./install_prereq install && \
    ./install_prereq install-unpackaged

RUN cd asterisk-15.4.0 && \
    ./configure && \
    make menuselect.makeopts && \
    menuselect/menuselect --disable BUILD_NATIVE \
                          --enable chan_pjsip \
                          --enable chan_sip \
                          --enable res_srtp \
                          --enable res_crypto \
                          --enable res_http_websocket \
                          --enable codec_opus \
                          --enable codec_silk \
                          --enable codec_g729a \
                          menuselect.makeopts && \
    make && \
    make install

RUN yum clean all

EXPOSE \
    8089/tcp \
    10000-10010/udp 
    
# config
COPY pjsip.conf /etc/asterisk/pjsip.conf
COPY http.conf /etc/asterisk/http.conf
COPY rtp.conf /etc/asterisk/rtp.conf
COPY modules.conf /etc/asterisk/modules.conf
COPY extensions.conf /etc/asterisk/extensions.conf
COPY keys /etc/asterisk/keys

# entrypoint
COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
