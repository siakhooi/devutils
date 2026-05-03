Name:           siakhooi-devutils
Version:        1.4.0
Release:        1%{?dist}
Summary:        parent package for all siakhooi-devutils-* packages.

License:        MIT
URL:            https://github.com/siakhooi/devutils
Source0:        https://github.com/siakhooi/%{name}/archive/refs/tags/${version}.tar.gz
BuildArch:      noarch

Requires:       siakhooi-echo-colors, siakhooi-date-formats, siakhooi-textutils, siakhooi-fileutils

%description
parent package for all siakhooi-devutils-* packages.

%install
%{__mkdir}   -v -p %{buildroot}%{_mandir}/man1
%{__mkdir}   -v -p %{buildroot}/usr/share/licenses/siakhooi-devutils
%{__install} -v -m 644  %{_topdir}/BUILD/usr/share/man/man1/* %{buildroot}%{_mandir}/man1
%{__install} -v -m 644  %{_topdir}/BUILD/LICENSE %{buildroot}/usr/share/licenses/siakhooi-devutils

%files
%license LICENSE
%{_mandir}/man1/siakhooi-devutils.1.gz

%changelog
* Sun Sep 28 2025 Siak Hooi <siakhooi@gmail.com> - 1.4.0
- add siakhooi-fileutils

* Mon Nov 4 2024 Siak Hooi <siakhooi@gmail.com> - 1.3.0
- initial rpm version

* Mon Mar 20 2023 Siak Hooi <siakhooi@gmail.com> - 1.2.0
- rename indent to textutils

* Sun Mar 19 2023 Siak Hooi <siakhooi@gmail.com> - 1.1.1
- fix md, deb compression

* Fri Mar 03 2023 Siak Hooi <siakhooi@gmail.com> - 1.1.0
- add *-indent

* Fri Mar 03 2023 Siak Hooi <siakhooi@gmail.com> - 1.0.0
- initial release
