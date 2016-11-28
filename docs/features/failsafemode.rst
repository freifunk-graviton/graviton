Failsafe Mode
===========

When in failsafe mode the node will fallback to its default network and wireless configuration. 
This gives you the possibility to gain access if you have locked yourself out by a configuration error.
Don't confuse it with the OpenWrt failsafe mode which is also a possibility for recovery at the moment.

Whether a node is in failsafe mode can be determined by a characteristic
blinking sequence of the SYS LED:

.. image:: node_configmode.gif

Activating Failsafe Mode
----------------------

You can enter failsafe mode by pressing and holding the RESET/WPS button for about ten
seconds. The device should reboot (all LEDs will turn on briefly) and 
failsafe mode will be available.

Hard-reset
---------------------

To hard-reset the device (e.g. if you don't remember the password) you have press and hold the RESET/WPS button,
wait for the Failsafe mode to come up completely still holding the button and wait for another 10 seconds until 
again all LEDs turn on briefly.

