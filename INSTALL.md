# Linux

Dependencies:

	sudo apt-get install make gcc bison git python python-setuptools
	sudo easy_install pip

The assembler used is [**rgbds**](https://github.com/bentley/rgbds).

	git clone git://github.com/bentley/rgbds.git
	cd rgbds
	sudo mkdir -p /usr/local/man/man{1,7}
	sudo make install
	cd ..
	rm -rf rgbds

Set up the repository.

	git clone git://github.com/huderlem/pokepinball.git
	cd pokepinball
	git submodule init
	git submodule update

Place a copy of Pokemon Pinball (U) [C][!].gb  (`md5: fbe20570c2e52c937a9395024069ba3c`) in this directory and name it `baserom.gbc`.

To build `pokepinball.gbc`:

	make

This will take a few second the first time you build because it needs to process all of the graphics.

To remove all generated files by the build process:

	make clean

To compare the `md5` hashes of `baserom.gbc` and the built `pokepinball.gbc`:

	make compare


# OS X

In the shell, run:

	xcode-select --install

Then follow the Linux instructions.


# Windows

It's recommended that you use a virtual machine running Linux or OS X.

If you insist on Windows, use [**Cygwin**](http://cygwin.com/install.html) (32-bit).

Dependencies are downloaded in the installer rather than the command line.
Select the following packages:
* make
* git
* python
* python-setuptools

The latest version of **rgbds** is  [**0.2.2**](https://github.com/bentley/rgbds/releases/download/v0.2.2/rgbds-0.2.2-win32.zip). To install, put `rgbasm.exe`, `rgblink.exe` and `rgbfix.exe` in `C:\cygwin\usr\local\bin`.

Then set up the repository. In the **Cygwin terminal**:

	git clone git://github.com/iimarckus/pokered.git
	cd pokered

To build, follow the Linux instructions.
