=============
Cocoa Karajan
=============

The Cocoa Karajan application delivers a precompiled version of the `Karajan
<http://github.com/rodaebel/Karajan>`_ platform bundled with all dependencies
for Mac OS X. It also provides a user interface for running and configuring
Karajan and additional modules.


Copyright and License
---------------------

Copyright 2011 Tobias Rodaebel

This software is released under the Apache License, Version 2.0. You may obtain
a copy of the License at

  http://www.apache.org/licenses/LICENSE-2.0


Building and Running
--------------------

Building the Cocoa Karajan project requires Mac OS X Snow Leopard and Xcode 4.
In order to build and run the project, enter the following commands::

  $ make
  $ ./build/Release/Karajan.app/Contents/MacOS/Karajan

Or use Xcode 4 to build the project. This requires the
`build-erlang-components.sh` script to be manually executed.


Bundle Contents
---------------

The bundled application contains the Erlang virtual machine binaries and the
compiled (BEAM) standard library modules including the Open Telecom Platform
(OTP). Hence, it is not necessary to install Erlang on your System.
