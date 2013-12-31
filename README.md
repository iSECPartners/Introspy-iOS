Introspy-iOS
============

Blackbox tool to help understand what an iOS application is doing at runtime
and assist in the identification of potential security issues.

See http://isecpartners.github.io/Introspy-iOS/ for a quick introduction.


Description
-----------

This is the repository for the Introspy-iOS tracer.

The tracer can be installed on a jailbroken device to hook and log
security-sensitive iOS APIs called by applications running on the device. The
tool records details of relevant API calls, including arguments and return
values and persists them in a database.
Additionally, the calls are also sent to the Console for real-time analysis.

The database can then be fed to Introspy-Analyzer, a Python script to generate
HTML reports containing the list of logged function calls as well as a list of
potential vulnerabilities affecting the application. Introspy-Analyzer is hosted
on a separate repository:
https://github.com/iSECPartners/Introspy-Analyzer


Installation
------------

Users should first download the latest pre-compiled Debian package available
in the release section of the project page at:
https://github.com/iSECPartners/Introspy-iOS/releases

### Dependencies

The tracer will only run on a jailbroken device. Using Cydia, make
sure the following packages are installed:
- dpkg
- MobileSubstrate
- PreferenceLoader
- Applist

### How to install

Download and copy the Debian package to the device; install it:

    scp <package.deb> root@<device_ip>:~
    ssh root@<device_ip>
    dpkg -i <package.deb>

Respring the device:

    killall -HUP SpringBoard

There should be two new menus in the device's Settings. The Apps menu allows you
to select which applications will be profiled while the Settings menu defines
which API groups are being hooked.

Finally, kill and restart the App you want to monitor.

### How to uninstall

    dpkg -r com.isecpartners.introspy


Generating HTML Reports
-----------------------

The tracer will store data about API calls made by applications in a database
stored on the device (actually one in each application's folder). This database
can be fed to a Python script call Introspy-Analyzer in order to generate HTML
reports that make it a lot easier to review the data collected by the tracer.
The script will also analyze and flag dangerous API calls in order to facilitate
the process of identifying vulnerabilities within iOS applications.

Introspy-Analyzer is hosted on a separate repository:
https://github.com/iSECPartners/Introspy-Analyzer


License
-------

See ./LICENSE.

Authors
-------

* Tom Daniels
* Alban Diquet
