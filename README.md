## What is Graviton?
Graviton is a buildscript collection with additional packages to build wifi router firmware for PtP and PtmP setups.
It is based on [Gluon](https://github.com/freifunk-gluon/gluon) and aims to complement the tools to build open, community operated wireless networks. One of the main goals is to support and maybe even develop a TDMA mode which is desirable for carrier class links.
Documentation (incomplete at this time, contribute if you can!) may be found at
http://graviton.readthedocs.org/

If you're new to Graviton and ready to get your feet wet, have a look at the
[Getting Started Guide](http://graviton.readthedocs.org/en/latest/user/getting_started.html).

## Use a release!

Please refrain from using the master branch for anything else but development purposes!
Use the most recent release instead. You can list all relaseses by running `git branch -a`
and switch to one by running `git checkout v2016.1;make update`.

If you're using the autoupdater, do not autoupdate nodes with anything but releases.
If you upgrade using random master commits the nodes *will break* eventually.

