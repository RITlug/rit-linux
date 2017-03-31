Name:           jflap
Version:        7.0
Release:        1%{?dist}
Summary:        The JFLAP formal language tool
License:        JFLAP 7.0 License
URL:            https://www.jflap.org
Source0:    %{name}.tar.gz
BuildArch:  noarch
BuildRequires:  java

%description
JFLAP is a package of graphical tools which can be used as an aid in learning the basic concepts of Formal Languages and Automata Theory. 

%prep

%setup -n %{name} -n %{name}

%build
make

%install
%{__mkdir_p} %{buildroot}%{_javadir}
install -p -m 755 JFLAP_With_Source.jar %{buildroot}%{_javadir}/jflap.jar
%{__mkdir_p} %{buildroot}%{_bindir}
install -p -m 755 %{_sourcedir}/jflap.sh %{buildroot}%{_bindir}/jflap 
%{__mkdir_p} %{buildroot}%{_datadir}/icons
install -p -m 644 %{_sourcedir}/jflap.jpg %{buildroot}%{_datadir}/icons/jflap.jpg 
%{__mkdir_p} %{buildroot}%{_datadir}/applications
install -p -m 644 %{_sourcedir}/jflap.desktop %{buildroot}%{_datadir}/applications/jflap.desktop

%files
%{_javadir}/jflap.jar
%{_bindir}/jflap
%{_datadir}/applications/jflap.desktop
%{_datadir}/icons/jflap.jpg

%changelog