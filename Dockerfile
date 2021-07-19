FROM ubuntu:16.04

RUN apt-get update \
      && apt-get install -y \
            build-essential libtool autotools-dev automake pkg-config libssl-dev libevent-dev bsdmainutils python3 libboost-all-dev software-properties-common

RUN add-apt-repository ppa:bitcoin/bitcoin

RUN apt-get update && \
    apt-get install -y \
      libdb4.8-dev libdb4.8++-dev libzmq3-dev \
      libqt5gui5 libqt5core5a libqt5dbus5 qttools5-dev qttools5-dev-tools libprotobuf-dev protobuf-compiler

WORKDIR /
COPY ./entrypoint.sh .
COPY ./kmcoin.conf /root/.kmcoin/kmcoin.conf

# WORKDIR /app
# ADD https://github.com/kmcoin-project/kmcoin/archive/refs/tags/v0.18.1.tar.gz /app/
# RUN tar -xvf /app/v0.18.1.tar.gz

COPY . /kmcoin

WORKDIR /kmcoin

RUN ./autogen.sh && ./configure && make install

RUN apt-get install -qqy x11-apps libxext-dev libxrender-dev libxtst-dev

RUN apt-get -y autoremove \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# WORKDIR /app

#open service port
EXPOSE 9888 19888 9882 19882

CMD ["/bin/bash", "/entrypoint.sh"]
