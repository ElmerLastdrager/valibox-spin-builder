# SPIN build Dockerfile
# This produces a docker container that allows you to build SPIN software
#   and/or images based on LEDE.
# Run: docker build -t spinbuild . && docker run --rm -it -v "$(pwd)":/build spinbuild -b

# Use an official Ubuntu stable release
FROM ubuntu:latest

# Set the working directory to /app
WORKDIR /build

# Install all requirements for building SPIN
RUN apt-get update && apt-get install -y \
    linux-generic linux-headers-generic \
    build-essential autoconf \
    libnfnetlink-dev libnfnetlink0 \
    libmosquitto-dev luarocks \
    git nano curl \
    luarocks mosquitto lua-bitop lua-posix \
    libncurses5-dev zlib1g-dev gawk python2.7-dev \ 
    ccache python3

# Add build scripts and files to image
ADD . /build/

RUN useradd -ms /bin/bash dev &&\
    /bin/chown -R dev:dev /build

USER dev

ENV EDITOR nano

# Build SPIN
# TODO REMOVE
ENTRYPOINT ["/build/builder.py"]
CMD ["-b"]

# Use ENTRYPOINT to allow dynamic commands to run
# Default: build all
