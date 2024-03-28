FROM oraclelinux:8

# set working directory
WORKDIR /app

# add globalnoc and epel repos
RUN dnf install -y \
    https://build.grnoc.iu.edu/repo/rhel/8/x86_64/globalnoc-release-8-1.el8.noarch.rpm \
    oracle-epel-release-el8

# enable additional ol8 repos
RUN yum-config-manager --enable \
    ol8_appstream ol8_baseos_latest ol8_codeready_builder \
    ol8_developer_EPEL  ol8_developer_EPEL_modular

# run makecache
RUN dnf makecache

# install venv dependencies 
RUN dnf install -y \
    openssl-devel perl-App-cpanminus expat-devel rpm-build
RUN cpanm Carton

# copy everything in
COPY . /app

# build & install rpm
RUN perl Makefile.PL
RUN make venv
RUN make rpm

FROM oraclelinux:8

COPY --from=0 /root/rpmbuild/RPMS/x86_64//grnoc-tsds-aggregate*.rpm /root/

RUN dnf install -y \
    https://build.grnoc.iu.edu/repo/rhel/8/x86_64/globalnoc-release-8-1.el8.noarch.rpm \
    oracle-epel-release-el8

# enable additional ol8 repos
RUN yum-config-manager --enable \
    ol8_appstream ol8_baseos_latest ol8_codeready_builder \
    ol8_developer_EPEL  ol8_developer_EPEL_modular

# run makecache
RUN dnf makecache

RUN dnf install -y /root/grnoc-tsds-aggregate*.rpm

# set entrypoint
ENTRYPOINT ["/bin/echo", "'Welcome to TSDS!'"]