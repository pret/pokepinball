# Linux

Dependencies:

	sudo apt-get install make gcc bison git
	sudo easy_install pip

The assembler used is [**rgbds**](https://github.com/bentley/rgbds).

	git clone https://github.com/rednex/rgbds
	cd rgbds
	sudo mkdir -p /usr/local/man/man{1,7}
	sudo make install
	cd ..
	rm -rf rgbds

Set up the repository.

	git clone https://github.com/huderlem/pokepinball
	cd pokepinball

To build `pokepinball.gbc`:

	make

This will take a few seconds the first time you build because it needs to process all of the graphics.

To remove all generated files by the build process:

	make clean

To compare the built `pokepinball.gbc` to the original ROM:

	make compare


# OS X

In the shell, run:

	xcode-select --install

Then follow the Linux instructions.


# Windows

To build on Windows, install [**Cygwin**](http://cygwin.com/install.html) with the default settings.

Dependencies are downloaded in the installer rather than the command line.
Select the following packages:
* make
* git
* gcc-core

The latest pokepinball-compatible version of **rgbds** is  [**0.3.0**](https://github.com/rednex/rgbds/releases/download/v0.3.0/rgbds-0.3.0-win32.zip). To install, put each of the files in the download in `C:\cygwin\usr\local\bin`.

Then set up the repository. In the **Cygwin terminal**:

	git clone https://github.com/pret/pokepinball.git
	cd pokepinball

To build `pokepinball.gbc`:

	make
