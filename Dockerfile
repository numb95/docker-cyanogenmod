# Build environment for CyanogenMod

FROM ubuntu:14.04
MAINTAINER Michael Stucki <mundaun@gmx.ch>

ENV DEBIAN_FRONTEND noninteractive

RUN sed -i 's/main$/main universe/' /etc/apt/sources.list
RUN apt-get -qq update
RUN apt-get -qqy upgrade

RUN apt-get install -y bc bsdmainutils file screen
RUN apt-get install -y android-tools-adb android-tools-fastboot
RUN apt-get install -y bison build-essential curl flex git gnupg gperf libesd0-dev liblz4-tool libncurses5-dev libsdl1.2-dev libwxgtk2.8-dev libxml2 libxml2-utils lzop maven openjdk-7-jdk openjdk-7-jre pngcrush schedtool squashfs-tools xsltproc zip zlib1g-dev
RUN apt-get install -y g++-multilib gcc-multilib lib32ncurses5-dev lib32readline-gplv2-dev lib32z1-dev
RUN apt-get install -y ccache rsync tig

RUN mkdir -p /home/cmbuild && useradd --no-create-home cmbuild && rsync -a /etc/skel/ /home/cmbuild/

RUN mkdir /home/cmbuild/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > /home/cmbuild/bin/repo
RUN chmod a+x /home/cmbuild/bin/repo

# Add sudo permission
RUN echo "cmbuild ALL=NOPASSWD: ALL" > /etc/sudoers.d/cmbuild

ADD startup.sh /home/cmbuild/startup.sh
RUN chmod a+x /home/cmbuild/startup.sh

# Fix ownership
RUN chown -R cmbuild:cmbuild /home/cmbuild

# Set global variables
ADD android-env-vars.sh /etc/android-env-vars.sh
RUN echo "source /etc/android-env-vars.sh" >> /etc/bash.bashrc

VOLUME /home/cmbuild/android
VOLUME /srv/ccache

CMD /home/cmbuild/startup.sh

USER cmbuild
WORKDIR /home/cmbuild/android
