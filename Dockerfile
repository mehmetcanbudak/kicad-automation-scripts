#FROM productize/kicad:5.0.1-18.04
FROM nicnewdigate/docker-kicad:latest
MAINTAINER Nic Newdigate <nicnewdigate@gmail.com>
LABEL Description="Base image with all dependencies and environment for KiCad automation scripts based on  Seppe Stas's https://hub.docker.com/r/productize/kicad"

COPY src/requirements.txt .
RUN apt-get -y update && \
    apt-get install -y python2.7 python-pip python3-pip xvfb recordmydesktop xdotool xclip tree x11-utils git && \
    pip2 install -r requirements.txt && \
    pip3 install -r requirements.txt && \
    rm requirements.txt && \
    apt-get -y remove python-pip python3-pip && \
    rm -rf /var/lib/apt/lists/*

# Use a UTF-8 compatible LANG because KiCad 5 uses UTF-8 in the PCBNew title
# This causes a "failure in conversion from UTF8_STRING to ANSI_X3.4-1968" when
# attempting to look for the window name with xdotool.
ENV LANG C.UTF-8

# Copy default configuration and fp_lib_table to prevent first run dialog
COPY ./config/* /root/.config/kicad/
COPY __init__.py /usr/lib/python2.7/dist-packages/kicad_automation/
COPY src /usr/lib/python2.7/dist-packages/kicad_automation
COPY __init__.py /usr/lib/python3.6/dist-packages/kicad_automation/
COPY src /usr/lib/python3.6/dist-packages/kicad_automation