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
ADD requirements.txt /
ADD . /assessment
WORKDIR /assessment
RUN pip install -r requirements.txt

ENV NETWORK_INTERFACE eth0
# Validate an installation
# snort -T -i eth0 -c /etc/snort/etc/snort.conf
#CMD ["snort", "-T", "-i", "echo ${NETWORK_INTERFACE}", "-c", "/etc/snort/etc/snort.conf"]

#CMD snort -v -i eth0 -c /etc/snort/etc/snort.conf -D && python ./runserver.py & snort 
CMD [ "python", "./runserver.py" ]

# run it:
# docker run -d -p 80:80 --rm -it docker-snort-master:latest