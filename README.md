# secure-and-minimal
A simple framework for creating minimal and secure Docker images based on Alpine. It consist of a Dockerfile-template, a number of standardized constants, a few helper-images, and structured shell scripts.

## The Dockerfile-template
The Dockerfile-template is divided into three main blocks: Init, Build, and Final. All three main blocks contain sub-blocks with generic code that must remain untouched for the framework to work properly.

### The Init-block
This block contains all variables and commands used during the build process. For this, we use a set of standard ARGs. These ARGs might also (explicitly) be passed on to the Final-block. All standard build ARGs, and their use, are listed later in this documentation.

The generic code block loads an initial image (INITIMAGE) and makes additional data from "content-images" available for use in the Build-block.

### The Build-block
This block is normally left as it is, but in some special cases you might want to add a RUN-statement right before the generic code block to create a missing file or directory.

The generic code block loads a helper image (BUILDIMAGE) in which the building takes place. The result of the building process is then copied to a set base image (BASEIMAGE). The exact building process is described later in this documentation.

### The Final-block
This block contains the runtime ENV-vars used in the final image.

The generic block sets the secure sturtup USER for the container.


# DOCUMENTATION IN PROGRESS!!!
...



*CONTENTIMAGE1*

An image containing additional files, that should be added to the "build"-stage.

*CONTENTSOURCE1 (/)*

List of files and directories, with full paths and separated by spaces, in CONTENTIMAGE1 that should be copied to the "build"-stage.

*CONTENTDESTINATION1 (/buildfs/)*

The directory where the files and directories given in CONTENTSOURCE1 is copied to.

*CONTENTIMAGE2*

See CONTENTIMAGE1.

*CONTENTSOURCE2 (/)*

See CONTENTSOURCE1.

*CONTENTDESTINATION2 (/buildfs/)*

See CONTENTDESTINATION1.

*INITIMAGE*

*BUILDIMAGE*

*BASEIMAGE*

*DOWNLOADS*

*DOWNLOADSDIR*

*ADDREPOS*

*BUILDDEPS*

*BUILDDEPS_UNTRUSTED*

*RUNDEPS*

*RUNDEPS_UNTRUSTED*

*MAKEDIRS*

*MAKEFILES*

*REMOVEFILES*

*EXECUTABLES*

*EXPOSEFUNCTIONS*

*BUILDCMDS*
