FROM mcr.microsoft.com/cbl-mariner/base/core:2.0

# Install all possible repos
RUN tdnf install -y \
     mariner-repos \
     mariner-repos-debug \
     mariner-repos-debug-preview \
     mariner-repos-extended \
     mariner-repos-extended-debug \
     mariner-repos-extended-debug-preview \
     mariner-repos-extended-preview \
     mariner-repos-extras \
     mariner-repos-extras-preview \
     mariner-repos-microsoft \
     mariner-repos-microsoft-preview \
     mariner-repos-preview \
     mariner-repos-shared

# Get ALL Macros
RUN tdnf install -y \
	     kf5-rpm-macros \
	     lua-rpm-macros \
	     lua-srpm-macros \
	     mariner-check-macros \
	     mariner-rpm-macros \
	     perl-macros \
	     pyproject-rpm-macros \
	     qt5-rpm-macros \
	     systemd-bootstrap-rpm-macros \
	     systemd-rpm-macros \
	     xorg-x11-util-macros


# Some Usefull tools
RUN tdnf install -y \
	     dnf \
	     git \
	     python3-pip \
	     ripgrep \
	     rpmdevtools \
	     vim \
	     which



RUN dnf -y install python3-pip

RUN pip install --upgrade pip

RUN pip install pathlib specfile validators

RUN adduser mfrw
RUN mkdir /home/mfrw

WORKDIR /home/mfrw
ADD spec.py /usr/bin/p
RUN chmod 777 /usr/bin/p
ADD cm-uniq /usr/bin/cm-uniq
RUN chmod 777 /usr/bin/cm-uniq
ADD cgmupdate.py /usr/bin/cgmupdate
RUN chmod 777 /usr/bin/cgmupdate
ADD gitconfig /etc/gitconfig

RUN chown -R mfrw:mfrw /home/mfrw



RUN su mfrw
RUN dnf -y repoquery --whatprovides dnf

RUN dnf -y info ripgrep
