%global debug_package %{nil}
%global _binaries_in_noarch_packages_terminate_build   0
%define perl_lib /opt/grnoc/venv/
AutoReqProv: no # Keep rpmbuild from trying to figure out Perl on its own

Summary: GRNOC TSDS Aggregate
Name: grnoc-tsds-aggregate
Version: 1.2.3
Release: 1%{?dist}
License: GRNOC
Group: Measurement
URL: http://globalnoc.iu.edu
Source0: %{name}-%{version}.tar.gz
BuildRoot: %{_tmppath}/%{name}-%{version}-%{release}-root

Requires: perl >= 5.8.8
Requires: perl-GRNOC-Log
Requires: perl-GRNOC-Config == 1.0.9
Requires: perl-GRNOC-WebService-Client >= 1.3.3
Requires: perl-GRNOC-TSDS-Aggregate-Histogram >= 1.0.1

%description
GRNOC TSDS Aggregate Daemon and Workers

%prep
%setup -q -n grnoc-tsds-aggregate-%{version}

%build
%{__perl} Makefile.PL PREFIX="%{buildroot}%{_prefix}" INSTALLDIRS="vendor"
make

%install
rm -rf $RPM_BUILD_ROOT
make pure_install

%{__install} -d -p %{buildroot}/etc/grnoc/tsds/aggregate/
%{__install} -d -p %{buildroot}/var/lib/grnoc/tsds/aggregate/
%{__install} -d -p %{buildroot}/usr/bin/
%{__install} -d -p %{buildroot}/etc/init.d/
%{__install} -d -p %{buildroot}/usr/share/doc/grnoc/tsds-aggregate/

%{__install} CHANGES.md %{buildroot}/usr/share/doc/grnoc/tsds-aggregate/CHANGES.md
%{__install} INSTALL.md %{buildroot}/usr/share/doc/grnoc/tsds-aggregate/INSTALL.md

%{__install} conf/config.xml.example %{buildroot}/etc/grnoc/tsds/aggregate/config.xml
%{__install} conf/logging.conf.example %{buildroot}/etc/grnoc/tsds/aggregate/logging.conf

%{__install} init.d/tsds-aggregate-daemon %{buildroot}/etc/init.d/tsds-aggregate-daemon
%{__install} init.d/tsds-aggregate-workers %{buildroot}/etc/init.d/tsds-aggregate-workers

%{__install} bin/tsds-aggregate-daemon  %{buildroot}/usr/bin/tsds-aggregate-daemon
%{__install} bin/tsds-aggregate-workers %{buildroot}/usr/bin/tsds-aggregate-workers
%{__install} bin/tsds-aggregate-worker.pl %{buildroot}/usr/bin/tsds-aggregate-worker.pl

%{__install} -d -p %{buildroot}/opt/grnoc/venv/%{name}/lib/perl5
cp -r local/lib/perl5/* -t %{buildroot}/opt/grnoc/venv/%{name}/lib/perl5


# clean up buildroot
find %{buildroot} -name .packlist -exec %{__rm} {} \;

%{_fixperms} $RPM_BUILD_ROOT/*

%clean
rm -rf $RPM_BUILD_ROOT

%files

%defattr(640, root, root, -)

%config(noreplace) /etc/grnoc/tsds/aggregate/config.xml
%config(noreplace) /etc/grnoc/tsds/aggregate/logging.conf

%defattr(644, root, root, -)

/usr/share/doc/grnoc/tsds-aggregate/CHANGES.md
/usr/share/doc/grnoc/tsds-aggregate/INSTALL.md

%{perl_vendorlib}/GRNOC/TSDS/Aggregate.pm
%{perl_vendorlib}/GRNOC/TSDS/Aggregate/Config.pm
%{perl_vendorlib}/GRNOC/TSDS/Aggregate/Daemon.pm
%{perl_vendorlib}/GRNOC/TSDS/Aggregate/Aggregator.pm
%{perl_vendorlib}/GRNOC/TSDS/Aggregate/Aggregator/Worker.pm
%{perl_vendorlib}/GRNOC/TSDS/Aggregate/Aggregator/Message.pm

/usr/share/man/man3/GRNOC::TSDS::Aggregate::Config.3pm.gz

%defattr(754, root, root, -)

/usr/bin/tsds-aggregate-daemon
/usr/bin/tsds-aggregate-workers
/usr/bin/tsds-aggregate-worker.pl

/etc/init.d/tsds-aggregate-daemon
/etc/init.d/tsds-aggregate-workers

%defattr(755, root, root, -)

%dir /var/lib/grnoc/tsds/aggregate/
/opt/grnoc/venv/%{name}/lib/perl5/*