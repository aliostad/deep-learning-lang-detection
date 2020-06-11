Overview of the PaRTiKle filesystem's internals
-----------------------------------------------

By Salvador Peiró, PaRTiKle crew member.

The current mechanism is not the same used by Linux but it has been
inspired by Inferno/Plan 9's filesystem [1], references to the more relevant
documents are provided.

The reason because I've chosen the ideas behind the Inferno/Plan 9's
filesystem is that it provides a cleaner and simpler filesystem
(not perfect, but good), than the one in the Linux kernel,
so it'll be easier to be understood and to work out with it.

I'm going to detail the process and the benefits/drawbacks, while I
try to emphasise the differences.  

The Linux Kernel uses a similar REGISTER_DRV [0] macro to initialise a
device, to do so a particular kernel section "drivers" is used to hold
an array of structures that contains the name of the device and a
pointer to the initialisation routine, and a initialisation order
number (hardcoded).  

struct devinfo {
	char * name;
	void *(init) (void);
	int order;
}

Then when the kernel boots in order to initialise the devices it has
to gather all the devices contained in the "drivers" section, read
them all, sort them and then run each function in order.

* question: what does it happen when you need a different initialisation order?

* note: this sorting is done on-line when the kernel boots,
  it's not computationally expensive since you have all the
  information, why not perform this at compilation time?.

CONF files:
-----------

PaRTiKle defines two configuration files: 

* The ".config" file which holds the PaRTiKle configuration
  variables. This file is created during the "menuconfig" step
  see [2].

* The kernel configuration file (CONF for short) which lives in
  "core/kernel/$ARCH/prtkcf". This file is processed when building the
  kernel, generating a CONF.c file which contains the code needed to
  initialise the device.

What follows is a brief description of the CONF file (a description in
detail can be found in the Inferno's conf man page [3]):

This file defines a list (an explicit list) of the object files that
form part of the kernel. Thus, enabling to define different profiles
(a full-POSIX kernel, a minimal embedded Java kernel, ...).
A different profile can be selected changing the CONF
variable defined at the top of the "core/kernel/$ARCH/Makefile" file.

The CONF file is composed of the next sections:

* Section "dev", which contains the object files corresponding
to each device present in the kernel, they are sorted by their
initialisation order, that is, the devices that appear first will be
initialised firstly (this solves device initialisation order issues).

* Section "port", which holds the code which is portable
(architecture independent) and so shared among all the
architectures. You can find this code in the core/kernel/port/
directory.  

* Section "lib" that currently contains "c", i.e. the libc used by
the kernel code. (Note: PaRTiKle uses a different C libraries
depending whether it is being executed kernel code or user one. It
means that the code located in user/ulibc is different that the code
located in core/libc).

* Section "link" contains the code for the devices that do not expose
a filesystem interface under /dev/. For instance, this is useful to
manage devices like vga, rtc, etc. Basically, a function, called
"name"link, is defined in each linked device file "name.c". This function
is called during the kernel setup.

* Section "root" contains the description of a minimal built-in
filesystem. Is the simplest way to have a filesystem under partikle,
which comes handy to provide small configuration files for the applications.

Filesystem devices:
-------------------

This sort of devices has been already explained above (see section
"dev"). These are the ones that expose a filesystem interface to the
applications. Lets start with the device table structure
(core/kernel/port/dev.h:/^struct Dev/ and see also [4] & [5]) 

struct Dev {
	int	dc;
	char*	name;

	int		(*init)(void);
	int		(*open)(char*, int);
	long	(*read)(int fd, void*, long, long long);
	long	(*write)(int fd, const void*, long, long long);
	void	(*close)(int fd);

	// wish we don't need it
	int 	(*ioctl) (int fd, unsigned, unsigned long);
	int		(*mmap) (int fd, void  *, int, int, int, int, char **);
};


A quick glance to the structure's fields shows:

- The "dc" field which identifies a device type.
Each different device type has a different identification.

- The "name" field which points to the device's name (a C
string). This name will be listed in the "/dev" directory.

- And, lastly, it comes all the device operations (init, open, read,
write, close,...). 

To build self-contained devices, the whole path to the device is
passed to the open function so it can decide what to do with it.

To be able to name the files served by a device, the next two fields are
compulsory:

(core/include/fs.h) 
struct File {
	int type;
	Qid qid;
	...
}

- The field "type" is the index to the device table "devtab". It
points to the device which is serving the file.

- The field "qid" is a file identifier per "device''. (Note: a
file is unequivocally identify by the combination of both fields,
"type" plus "qid".  This is a more flexible approach than that used by
UNIX; The major and minor number used by UNIX can be mapped to the
type and qid fields respectively.

The idea behind this implementation is that a driver is able to
decide the mapping between paths and files served. As an examples
consider:
	/dev/console0	-> {type: console, qid: 0}
	/dev/console1	-> {type: console, qid: 1}
	/dev/console3	-> {type: console, qid: 2}
	...				-> ...

The file operation functions (read and write) use a file descriptor
(fd) to access to the "files" table, returning the appropriate File
structure. With this information the file operations can find out
which device is in charge of that file.

The "qids" can be generated either dynamically or statically,
this decision is up to the particular needs of the device.

Hope this text will clarify things.

[0] http://geek.vtnet.ca/doc/initcall/index.html, `Understanding The Linux Kernel Initcall Mechanism'.
[1] http://www.vitanuova.com/inferno/docs.html, `Manual pages and papers'
[2] https://www.gii.upv.es/svn/rtos/trunk/partikle/docs, `PaRTiKle user manual'.
[3] http://www.vitanuova.com/inferno/man/10/conf.html
[4] http://www.vitanuova.com/inferno/man/10/dev.html
[5] http://www.vitanuova.com/inferno/man/10/devattach.html
