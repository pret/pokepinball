# Instructions

These instructions explain how to set up the tools required to build **pokepinball**, including [**rgbds**](https://github.com/gbdev/rgbds), which assembles the source files into a ROM.

If you run into trouble, ask for help on IRC or Discord (see [README.md](README.md)).

## Linux

Open **Terminal** and enter the following commands, depending on which distro you're using.

### Debian or Ubuntu

To install the software required for **pokepinball**:

```bash
sudo apt-get install make gcc git
```

Then follow the [**rgbds** instructions](https://rgbds.gbdev.io/install#building-from-source) to build **rgbds 0.5.2** from source.

After that, you're ready to [build **pokepinball**](#build-pokepinball).

### Arch Linux

To install the software required for **pokepinball**:

```bash
sudo pacman -S make gcc git rgbds
```

Now you're ready to [build **pokepinball**](#build-pokepinball).

If you want to compile and install **rgbds** yourself instead, then follow the [**rgbds** instructions](https://rgbds.gbdev.io/install#building-from-source) to build **rgbds 0.5.2** from source.


## macOS

Install [**Homebrew**](https://brew.sh/). Follow the official instructions.

Open **Terminal** and prepare to enter commands.

Then follow the [**rgbds** instructions](https://rgbds.gbdev.io/install#pre-built) for macOS to install **rgbds 0.5.2**.

Now you're ready to [build **pokepinball**](#build-pokepinball).


## Windows

To build on Windows, install [**Cygwin**](http://cygwin.com/install.html) with the default settings.

Dependencies are downloaded in the installer rather than the command line.
Select the following packages:
* make
* git
* gcc-core

The latest pokepinball-compatible version of **rgbds** is  [**0.5.2**](https://github.com/gbdev/rgbds/releases/v0.5.2). To install, put each of the files in the download in `C:\cygwin\usr\local\bin`.

Now you're ready to [build **pokepinball**](#build-pokepinball).

## Build pokepinball

To download the **pokepinball** source files:

```bash
git clone https://github.com/pret/pokepinball
cd pokepinball
```

To build **pokepinball.gbc**:

```bash
make
```

To remove all generated files by the build process:

```bash
make clean
```

To compare the built **pokepinball.gbc** to the original ROM:

```bash
make compare
```
