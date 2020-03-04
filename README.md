# deb-tutorial
A _very_ minimal deb package building tutorial for Fortran code from scratch using debhelper.

## Introduction
Borne out of a dearth of tutorials on a quick and dirty way of creating a deb package, this tutorial aims to introduce debian packaging in its most simplest form. The tutorial is made as concise as possible and may skim over finer details.  

### Let's get a few things straight!
1. It is assumed that you know your way around Linux and have used package maintainers (like apt) to install programs.
2. Our aim is to start with a simple source code, say `helloworld.f90`, and end up with `helloworld.deb`.   
This `helloworld.deb` package can then be installed with a package maintainer using:  
`sudo apt ./helloworld.deb` or `gdebi helloworld.deb`
3. Ensure required tools for the tutorial are installed with:  
`sudo apt install debhelper build-essential`
4. Version number `2.3.45-6_amd64` means:
- Major version: `2`  - major release (May signify incompatibility with other major releases)
- Minor version: `3`  - minor release (Minor improvements compatible with the same major release)
- Patch version: `45` - patches and/or bug fixes
- Debian revision: `6`  - version of the deb package file
- Architecture: `amd64`

### But what really is a .deb package?
A .deb package is essentially an archive file that contains three files inside. 
1. **debian-binary**: File that contains a single line with the debian version (not the program version)
2. **control.tar.xz**: Archive that contains program metadata
3. **data.tar.xz**: Archive that contains program files that are to be installed or help installation

'Program metadata' here, refers to additional information that support distribution of the program, like the version number, dependencies, changes to the software, who the author is etc.

### Start your engines!
Now that that's out of the way, let's build a simple Hello World Fortran program named `helloworld.f90` that prints
```
 ************
 Hello World!
 ************
```
To demonstrate the use of a library in the project, we also use `star.f90` to print stars.  
Let's start with a clean directory titled `tutorial`, in which, our project directory `helloworld-1.0.0`, where the program source code resides in.   
```
tutorial
└── helloworld-1.0.0
    ├── CMakeLists.txt
    └── src
        ├── CMakeLists.txt
        ├── helloworld.f90
        └── star.f90
```
Note that the project directory contains the name and the version number that the package is expected to have. The Fortran source code for these files are provided in this repository.  
`helloworld-1.0.0/CMakeLists.txt` contains an install target that copies the final executable to the desired location in /opt.

### Let's go!
To add metadata for our package, we require a few extra files stored in a directory titled `debian` or `DEBIAN` in our project directory
1. control: Metadata on package
2. rules: Makefile containing rules to build package
3. compat: A file with just the debhelper version number for defining compatibility
4. copyright
5. changelog and a few others

Once these debian files are created, we would have run `dpkg-buildpackage` which further executes a list of commands to build the package and sign it. Then we would run `lintian` which checks for errors in the package.  
However, rare as it may be, life is made a lot easier due to 'helper' scripts. We utilize two of them here:
1. **debmake**: Creates a template of all required debian files
2. **debuild**: Smart wrapper program for dpkg-buildpackage and lintian

`debmake` requires an archive of the source code to work with. Use `tar` to create it:  
`tar -czvf helloworld-1.0.0.tar.gz helloworld-1.0.0`  

Let's create the template files by running `debmake` *inside* the directory `helloworld-1.0.0/`.   
After a verbose output, we arrive at the following directory structure:  
```
tutorial
├── helloworld-1.0.0
│   ├── CMakeLists.txt
│   ├── debian
│   │   ├── changelog
│   │   ├── compat
│   │   ├── control
│   │   ├── copyright
│   │   ├── patches
│   │   │   └── series
│   │   ├── README.Debian
│   │   ├── rules
│   │   ├── source
│   │   │   ├── format
│   │   │   └── local-options
│   │   └── watch
│   └── src
│       ├── CMakeLists.txt
│       ├── helloworld.f90
│       └── star.f90
└── helloworld-1.0.0.tar.gz
```

Notice the new directory `debian` that `debmake` has created and populated with template files. For the purpose of this tutorial, only the file `debian/control` and `debian/rules` require minor changes. All other files may be edited after a thorough understanding of their purposes.   

In `debian/control`:
Change `Section: unknown` to `Section: devel`. This classifies the program `helloworld` into the `developers` group.   
Also change the `Description` section to an arbitrary description of your liking.  
We have now satisfied the basic requirements for building a deb package.  

In `debian/rules`:
Uncomment the line `export DH_VERBOSE = 1` so that a detailed report is printed in the coming steps.  

### Final stretch
We run `debuild` from *inside* the project directory to build the package with this configuration.  
A deb package `helloworld_1.0.0-1_amd64.deb` is now created *outside* the project directory.  
Notice that the `lintian` check that `debuild` ran returned a few errors and warnings due to use of the template files. These will not affect the working of the package and may be treated as a pointer.  

### Finish line
Install this package using apt with `sudo apt install ./helloworld_1.0.0-1_amd64.deb` and run it with the command `/opt/helloworld`.  
To uninstall the package use `sudo apt remove helloworld`.  

### Epilogue
The same workflow may be adapted for projects that use a Makefile or autoconf tools instead of cmake.

## References
1. `https://www.debian.org/doc/manuals/debmake-doc/ch04.en.html#big-picture`  
2. `https://www.debian.org/doc/manuals/packaging-tutorial/packaging-tutorial.en.pdf`  
