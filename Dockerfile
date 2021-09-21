# Base image.
FROM centos:8

# Add the Extra Packages for Enterprise Linux (EPEL) site.
RUN dnf install -y epel-release

# Enable powertools repository
RUN dnf install -y dnf-plugins-core &&\
    dnf config-manager --set-enabled powertools

# Install packages needed to build EPICS base
RUN dnf install -y gcc gcc-c++ gcc-toolset-9-make readline-devel perl-ExtUtils-Install make git glibc-langpack-en

# Install EPICS base
RUN mkdir $HOME/EPICS &&\
    cd $HOME/EPICS &&\
    git clone --recursive https://github.com/epics-base/epics-base.git &&\
    cd epics-base &&\
    make &&\
    echo -e 'export EPICS_BASE=${HOME}/EPICS/epics-base\n\
             export EPICS_HOST_ARCH=$(${EPICS_BASE}/startup/EpicsHostArch)\n\
             export PATH=${EPICS_BASE}/bin/${EPICS_HOST_ARCH}:${PATH}' >> $HOME/.bashrc
