# Snort in Docker
FROM ubuntu:14.04.4

MAINTAINER Glenn ten Cate <glenntencate@gmail.com>

RUN apt-get update && \
    apt-get install -y \
        python-setuptools \
        python-pip \
        python-dev \
        wget \
        build-essential \
        bison \
        flex \
        libpcap-dev \
        libpcre3-dev \
        libdumbnet-dev \
        zlib1g-dev \
        iptables-dev \
        libnetfilter-queue1 \
        tcpdump \
        unzip \
        vim 

# Define working directory.
WORKDIR /opt

RUN wget https://www.snort.org/downloads/snort/daq-2.0.6.tar.gz \
    && tar xvfz daq-2.0.6.tar.gz \
    && cd daq-2.0.6 \
    && ./configure; make; make install

RUN wget https://www.snort.org/downloads/snort/snort-2.9.11.1.tar.gz \
    && tar xvfz snort-2.9.11.1.tar.gz \
    && cd snort-2.9.11.1 \
    && ./configure; make; make install

RUN ldconfig

ADD mysnortrules /opt
RUN mkdir -p /var/log/snort && \
    mkdir -p /etc/snort && \
    cp -r /opt/rules /etc/snort/rules && \
    cp -r /opt/etc /etc/snort/etc 


# Add the Python app
ADD runserver.py /
ADD entrypoint.sh /
ADD requirements.txt /
ADD . /assessment
WORKDIR /assessment
RUN pip install -r requirements.txt

EXPOSE 80

# Validate and run snort and server
WORKDIR /
RUN ["chmod", "+x", "/entrypoint.sh"]
ENTRYPOINT ["/entrypoint.sh"]

# run it:
# docker run -ti -p 127.0.0.1:80:80 assessment-service:latest