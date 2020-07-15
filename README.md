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

## Standard ARGs
Below follows a list of standard ARGs that can be set in the Init-block and serve as parameters in the build process. Default values in paranthesis.

### SaM_VERSION
Mandatory! Defines which version of Secure and Minimal that is to be used.

### IMAGETYPE (application)
Modifies the build process to produce an image formatted to set purpose. Available values are application, base, content.

### HUBPROFILE
Dockerhub profile name of created image. Only used for content images and if IMAGEID is undefined. See IMAGEID.

### HUBREPO
Dockerhub repository name of created image. Only used for content images and if IMAGEID is undefined. See IMAGEID.

### HUBVERSION
Dockerhub image version of created image. Only used for content images and if IMAGEID is undefined. See IMAGEID.

### IMAGEID
Used to name the content-list file in content images. Is created from HUBPROFILE, HUBREPO and HUBVERSION if not set directly.

### CONTENTIMAGE[1-5]
A docker image to pull content from.

### CONTENTSOURCE[1-5]
A file or directory to copy from the corresponding content image.

### CONTENTDESTINATION[1-5]
The destination where content from the corresponding content image are copied to. The destination is relative to the build root, to copy directly to the final image prepend /finalfs.

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
