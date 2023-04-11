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
	efi-srpm-macros \
	ghc-srpm-macros \
	go-rpm-macros \
	go-srpm-macros \
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

# The whole shbang!
RUN tdnf install -y ca-certificates wget && \
    wget https://raw.githubusercontent.com/microsoft/CBL-Mariner/2.0-stable/toolkit/resources/manifests/package/pkggen_core_$(uname -m).txt && \
    cat pkggen_core_$(uname -m).txt | sed "s|\.cm2.*$|\.cm2|" | \
        sed -E "s|^(msopenjdk.*)\.$(uname -m).rpm$|\1|" | \
        sed -E "s|^(msopenjdk.*\+1)-(.*)$|\1\_\2|" | \
        xargs tdnf install -y

# Some Usefull tools
RUN tdnf install -y \
	     ca-certificates \
	     dnf \
	     git \
	     jq \
	     python3-pip \
	     rpmdevtools \
	     sudo \
	     vim \
	     which



RUN dnf -y install python3-pip

RUN pip install --upgrade pip

RUN pip install pathlib specfile validators decorator pyrpm python-rpm-spec rpm

RUN groupadd -g 1000 mfrw
RUN adduser -m mfrw -u 1000 -g 1000


WORKDIR /home/mfrw
ADD spec.py /home/mfrw/bin/p
RUN chmod a+x /home/mfrw/bin/p
ADD cm-uniq /home/mfrw/bin/cm-uniq
RUN chmod a+x /home/mfrw/bin/cm-uniq
ADD cgmupdate.py /home/mfrw/bin/cgmupdate
RUN chmod a+x /home/mfrw/bin/cgmupdate
ADD gitconfig /home/mfrw/.gitconfig
RUN chmod a+x /home/mfrw/bin/cgmupdate
ADD bashrc /home/mfrw/.bashrc
RUN chmod 777 /home/mfrw/.bashrc
RUN chown -R mfrw:mfrw /home/mfrw

USER mfrw


# Install rust and other shenanigans
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- --profile default -y
RUN /home/mfrw/.cargo/bin/cargo install cargo-quickinstall && /home/mfrw/.cargo/bin/cargo quickinstall fd-find git-delta ripgrep tealdeer zoxide starship gitui && /home/mfrw/.cargo/bin/tldr --update
