# Base image for building Java applications with Oracle JDK. This image
# includes the libraries fontconfig and freetype, which are required to
# run PhantomJS for example.

FROM kayabendroth/oracle-jdk8:latest

MAINTAINER Kay Abendroth "kay.abendroth@raxion.net"

LABEL description="This image is used to provide a lightweight \
    environment for compiling Java 8 source code. It's based on Debian \
    Jessie, the 'stable' version of Debian. The JDK8 packages comes \
    from a Launchpad repo containing the Oracle JDK. The image also \
    includes the libraries fontconfig and freetype."
LABEL version="0.1.0"


# Set locale.
ENV LANGUAGE en_US.UTF-8
ENV LANG     en_US.UTF-8
ENV LC_ALL   en_US.UTF-8

# Refresh line for up-to-date packages.
ENV REFRESH_AT='2015-10-20'

# Update package lists.
RUN apt-get -yqq update

# Install the libraries.
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    libfontconfig1 \
    libfreetype6

# Clean up.
RUN apt-get -y clean

