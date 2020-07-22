# secure-and-minimal
A simple framework for creating minimal and secure Docker images based on Alpine. It consist of a Dockerfile-template, a number of standardized constants, a few helper-images, and structured shell scripts.

# The Dockerfile-template
The Dockerfile-template is divided into three main blocks: Init, Build, and Final. All three main blocks contain sub-blocks with generic code that must remain untouched for the framework to work properly.

## The Init-block
This block contains all variables and commands used during the build process. For this, we use a set of standard ARGs. These ARGs might also (explicitly) be passed on to the Final-block. All standard build ARGs, and their use, are listed later in this documentation.

The generic code block loads an initial image (INITIMAGE) and makes additional data from "content-images" available for use in the Build-block.

## The Build-block
This block is normally left as it is, but in some special cases you might want to add a RUN-statement right before the generic code block to create a missing file or directory.

The generic code block loads a helper image (BUILDIMAGE) in which the building takes place. The result of the building process is then copied to a set base image (BASEIMAGE). The exact building process is described later in this documentation.

## The Final-block
This block contains the runtime ENV-vars used in the final image.

The generic block sets the secure sturtup USER for the container.

# The build process
The build process starts by preparing the standard ARGs, giving some of them their default values. Then are the files from INITIMAGE, CONTENTIMAGEs and files provided along with the Dockerfile copied to their correct locations. Files and directories, provided together with the Dockerfile, needs to be placed in a directory named finalfs (or rootfs) to be copied over to the final image. Then, based on the standard ARGs, init-commands are executed, empty files and directories are created, gits are cloned, files and packages are downloaded, build and final-commands are executed, file permissions are set, directories and files are deleted (mainly in this order).

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
The destination where content from the corresponding content image are copied to. The destination is relative to the build root, to copy directly to the final image, prepend /finalfs.

### ADDREPOS
Space-separated list of additional Alpine package repositories to use during the build process.

### EXCLUDEAPKS
Space-separated list of Alpine packages that should NOT be included in the final image.

### EXCLUDEDEPS
Space-separated list of Alpine packages which dependencies should be excluded from the final image. The listed packages are NOT excluded themselves.

### RUNDEPS
Space-separated list of Alpine packages that should be included in the final image.

### RUNDEPS_UNTRUSTED
Same as RUNDEPS but allows untrusted repositories.

### BUILDDEPS
Space-separated list of Alpine packages needed during the build process. The following packages is already installed and doesn't need to be added: acl bash build-base libtool cmake automake autoconf linux-headers git libcurl.

### BUILDDEPS_UNTRUSTED
Same as BUILDDEPS but allows untrusted repositories.

### BUILDDIR (/builddir)
Working directory for BUILDCMDS. 

### CLONEGITS
Comma-separated list of git repositories to clone to the build environment. Clone parameters may be included.

### CLONEGITSDIR (BUILDDIR)
Working directory for CLONEGITS. To clone directly to the final image, prepend /finalfs.

### DOWNLOADS
Space-separated list of urls to download to the build environment.

### DOWNLOADSDIR (BUILDDIR)
Working directory for DOWNLOADS. To download directly to the final image, prepend /finalfs.

### MAKEDIRS
Space-separated list of directories to create in the final image.

### MAKEFILES
Space-separated list of empty files to create in the final image.

### INITCMDS
String of shell commands to be executed in the initial build environment, prior to the installation of BUILDDEPS.

### BUILDCMDS
String of shell commands to be executed in the complete build environment. The final image filesystem is located in /finalfs.

### FINALCMDS
String of shell commands to be executed in the final image filesystem, after the execution of BUILDCMDS has finished.

### LINUXUSEROWNED
Space-separated list of files and directories (non-recursive) that should be owned by VAR_LINUX_USER in the final image.

### LINUXUSEROWNEDRECURSIVE
Space-separated list of directories that should be recursively owned by VAR_LINUX_USER in the final image.

### REMOVEDIRS
Space-separated list of directories that should be removed (with contents) from the final image.

### REMOVEFILES
Space-separated list of files that should be removed from the final image.

### KEEPEMPTYDIRS (no)
Whether empty directories should be preserved in the final image. If no, all non-essential empty directories, that is not listed in MAKEDIRS, is removed. 

### GID0WRITABLES
Space-separated list of files and directories (non-recursive) that should be writable by GID 0 (primary group for VAR_LINUX_USER) in the final image.

### GID0WRITABLESRECURSIVE
Space-separated list of directories that should be recursively writable by GID 0 (primary group for VAR_LINUX_USER) in the final image.

### EXECUTABLES
Space-separated list of files that should be persistently executable by VAR_LINUX_USER in the final image.

### STARTUPEXECUTABLES
Space-separated list of files that should be executable by VAR_LINUX_USER, but only during container startup.

### EXPOSEFUNCTIONS
Space-separated list of Secure and Minimal-functions that should be executable by VAR_LINUX_USER in the final image.

### DESTDIR
Base directory, in the final image, where the build process should install files. Defaults to /content-x in content images. 

### CFLAGS (--O2 -fomit-frame-pointer -fno-reorder-blocks -fno-reorder-functions -mcmodel=large)
C build flags in the build environment.

### ADDTO_CFLAGS
Additional C build flags that is appended to CFLAGS.

### PATH (/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin::)
PATH environment variable in the build environment.

### ADDTO_PATH
Additional PATH-string that is appended to PATH.

### CPATH

### ADDTO_CPATH
Additional CPATH-string that is appended to CPATH.

### LIBRARY_PATH

### ADDTO_LIBRARY_PATH
Additional LIBRARY_PATH-string that is appended to LIBRARY_PATH.

### LD_LIBRARY_PATH (LIBRARY_PATH)

### ADDTO_LD_LIBRARY_PATH
Additional LD_LIBRARY_PATH-string that is appended to LD_LIBRARY_PATH.

### LANG (C.UTF-8)

### CHARSET (UTF-8)

### MPICC (/usr/bin/mpicc)

### MPICXX (/usr/bin/mpicxx)

### COMMON_CONFIGUREPREFIX (/usr)

### COMMON_CONFIGURECMD (./configure --prefix=${COMMON_CONFIGUREPREFIX})
Convenience-variable (pass to eval in BUILDCMDS.)

### COMMON_CMAKECMD (cmake -DCMAKE_INSTALL_PREFIX=/usr -DCMAKE_INSTALL_LIBDIR=/usr/lib -DCMAKE_BUILD_TYPE=MinSizeRel -DCMAKE_C_FLAGS=\"${CFLAGS}\")
Convenience-variable (pass to eval in BUILDCMDS.)

### COMMON_MAKECMDS (make -s && make -s install)
Convenience-variable (pass to eval in BUILDCMDS.)

### COMMON_INSTALLSRC ($COMMON_CONFIGURECMD && $COMMON_MAKECMDS)
Convenience-variable (pass to eval in BUILDCMDS.)

### INITIMAGE (BASEIMAGE)
All files in this image are copied to /finalfs prior to the build process (seldomly used).

### BASEIMAGE (huggla/secure_and_minimal:$SaM_VERSION-base)
Baseimage which is extended with new contents. Needs to be an image created with Secure and Minimal.

### BUILDIMAGE (huggla/secure_and_minimal:$SaM_VERSION-build)
Helper-image where the building process takes place (don't touch!).

# The container start process
During the start process the Secure and Minimal framework secures and prepares the container according to the given VAR-parameters. The start process is divided into "stages". Each stage consists of a shell script or directory of shell scripts inside the /start directory. Stage1 and stage2 are common for all SaM-images. Stage3 are optional, and used to tailor the individual SaM-image during the build process. Stage2 and up are executed by the root user, but with reduced capabilities. The final command (VAR_FINAL_COMMAND) is automatically executed, in most cases as a non-privileged user (VAR_LINUX_USER), at the end of the start process. Secure and Minimal provides a number of shell script functions, organized in files located in /start/functions. These functions can used during the start process and, if exposed with EXPOSEFUNCTIONS, even within the running container. To add a stage3 to a SaM-image all you have to do is, together with the Dockerfile, put one or more shell scripts in /finalfs/start/stage3. The scripts will be executed in alphanumerical order so it is wise to choose filenames beginning with a three digit number. It is also possible to put shell functions in /finalfs/start/functions. 

## VAR-parameters
A VAR-parameter is an ENV-variable who's name starts with "VAR_". ENV-variables without the VAR-prefix are discarded during container startup, and is not passed to the final command. Some VAR-parameters are standardized and exists in all or many SaM-images. VAR-parameters can be set in the Final-block and are inherited from given BASEIMAGE, but they can also be set/changed at runtime with docker run -e. VAR-parameters ending with \_DIR(S), \_DIRECTORY, \_DIRECTORIES, \_FILE(S) (all case-insensitive) are interpreted as containing paths, which are automatically created. Path-VARs with names containing conf, sock, storage, data, logfile, logdir, \_pid_, \_log_, \_logs_, temp, tmp, home, cache, \_work_ are made writable by group 0, the primary group for VAR_LINUX_USER. Path-VARs with names containing pass, pw, sec, salt, key are made non-readable by all except owner. Below is a short list of common VAR-paramaters.

### VAR_LINUX_USER
The name of the user executing VAR_FINAL_COMMAND. Can be set to root but should in most cases not. Gets UID 102 (0 if root) and GID 0.

### VAR_FINAL_COMMAND
Shell command executed by VAR_LINUX_USER at the end of the startup process. Files that should be executed must be included in the EXECUTABLES or STARTUPEXECUTABLES ARG of the image or its BASEIMAGE.

# Examples
Below follows a few basic examples of SaM-images.

## Dropbear SSH server
It is very easy to create a SaM-image with Dropbear server, all you need to do is add a few ARGs and ENVs to the SaM Dockerfile template. 

* Download and open the SaM Dockerfile template (https://github.com/huggla/secure_and_minimal/raw/master/Dockerfile-template).
* Add the following lines to the Init-block (before the generic template code):
  ARG RUNDEPS="dropbear"
  ARG STARTUPEXECUTABLES="/usr/sbin/dropbear"
* Then add the following lines to the Final-block (before the generic template code):
  ENV VAR_LINUX_USER="dropbear" \\
      VAR_CONFIG_DIR="/etc/dropbear" \\
      VAR_PORT="2222" \\
      VAR_PID_FILE="/run/dropbear.pid" \\
      VAR_FINAL_COMMAND='dropbear -F -p $VAR_PORT -P $VAR_PID_FILE'
* Build the image.


# DOCUMENTATION IN PROGRESS!!!
...



