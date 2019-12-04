FROM ubuntu:18.04

ARG DEBIAN_FRONTEND=noninteractive

# Update
RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends apt-utils

RUN apt-get install -y python3 python3-dev
RUN apt-get install -y python3-pip


RUN pip3 install --upgrade pip
RUN pip3 install cython 

COPY requirements.txt /tmp/requirements.txt
RUN pip3 install -r /tmp/requirements.txt
