package jail

import (
	"os"
	"os/exec"
	"path"
	"runtime"
	"syscall"
	"time"
	"unsafe"
)

func (j *Cell) Command(name string, args ...string) *Cmd {
	c := exec.Command(name, args...)
	c.Dir = j.Dir
	c.SysProcAttr = &syscall.SysProcAttr{
		Ptrace: true,
	}
	return &Cmd{
		Cmd: c,
	}
}

func (j *Cell) Create(name string) (*os.File, error) {
	name = path.Join(j.Dir, name)

	f, err := os.Create(name)
	if err != nil {
		return nil, err
	}

	return f, nil
}

func (j *Cell) Dispose() error {
	return nil
}

func (c *Cmd) Run() error {
	runtime.LockOSThread()
	defer runtime.UnlockOSThread()

	err := c.Cmd.Start()
	if err != nil {
		return err
	}

	ready := map[int]bool{}

	status := syscall.WaitStatus(0)
	usage := syscall.Rusage{}
	for {
		pid, err := syscall.Wait4(c.Cmd.Process.Pid, &status, 0, &usage)
		if err != nil {
			return err
		}

		if !ready[pid] {
			_, _, errno := syscall.RawSyscall6(syscall.SYS_PRLIMIT64, uintptr(pid), syscall.RLIMIT_CPU, uintptr(unsafe.Pointer(&syscall.Rlimit{
				Cur: uint64(c.Limits.Cpu)/1e9 + 1,
				Max: uint64(c.Limits.Cpu)/1e9 + 1,
			})), 0, 0, 0)
			if errno != 0 {
				err = errno
				return err
			}

			_, _, errno = syscall.RawSyscall6(syscall.SYS_PRLIMIT64, uintptr(pid), syscall.RLIMIT_DATA, uintptr(unsafe.Pointer(&syscall.Rlimit{
				Cur: c.Limits.Memory,
				Max: c.Limits.Memory,
			})), 0, 0, 0)
			if errno != 0 {
				err = errno
				return err
			}

			ready[pid] = true
		}

		c.Usages.Cpu = time.Duration(usage.Utime.Nano())
		c.Usages.Memory = uint64(usage.Maxrss * (1 << 10))

		switch {
		case status.Exited():
			if status.ExitStatus() != 0 {
				return ExitError(status)
			}
			return nil

		case status.Signaled():
			return ExitError(status)

		case status.Stopped():
			switch {
			case status.StopSignal()&syscall.SIGTRAP > 0:
				regs := syscall.PtraceRegs{}
				err = syscall.PtraceGetRegs(pid, &regs)
				if err != nil {
					return err
				}

				switch regs.Orig_rax {
				case syscall.SYS_READ:
				case syscall.SYS_WRITE:
				case syscall.SYS_OPEN:
				case syscall.SYS_CLOSE:
				case syscall.SYS_STAT:
				case syscall.SYS_FSTAT:
				case syscall.SYS_LSTAT:
				case syscall.SYS_POLL:
				case syscall.SYS_LSEEK:
				case syscall.SYS_MMAP:
				case syscall.SYS_MPROTECT:
				case syscall.SYS_MUNMAP:
				case syscall.SYS_BRK:
				case syscall.SYS_RT_SIGACTION:
				case syscall.SYS_RT_SIGPROCMASK:
				case syscall.SYS_RT_SIGRETURN:
				case syscall.SYS_IOCTL:
				case syscall.SYS_PREAD64:
				case syscall.SYS_PWRITE64:
				case syscall.SYS_READV:
				case syscall.SYS_WRITEV:
				case syscall.SYS_ACCESS:
				case syscall.SYS_PIPE:
				case syscall.SYS_SELECT:
				case syscall.SYS_SCHED_YIELD:
				case syscall.SYS_MREMAP:
				case syscall.SYS_MSYNC:
				case syscall.SYS_MINCORE:
				case syscall.SYS_MADVISE:
				case syscall.SYS_SHMGET:
				case syscall.SYS_SHMAT:
				case syscall.SYS_SHMCTL:
				case syscall.SYS_DUP:
				case syscall.SYS_DUP2:
				case syscall.SYS_PAUSE:
				case syscall.SYS_NANOSLEEP:
				case syscall.SYS_GETITIMER:
				case syscall.SYS_ALARM:
				case syscall.SYS_SETITIMER:
				case syscall.SYS_GETPID:
				case syscall.SYS_SENDFILE:
				case syscall.SYS_SOCKET:
				case syscall.SYS_CONNECT:
				case syscall.SYS_ACCEPT:
				case syscall.SYS_SENDTO:
				case syscall.SYS_RECVFROM:
				case syscall.SYS_SENDMSG:
				case syscall.SYS_RECVMSG:
				case syscall.SYS_SHUTDOWN:
				case syscall.SYS_BIND:
				case syscall.SYS_LISTEN:
				case syscall.SYS_GETSOCKNAME:
				case syscall.SYS_GETPEERNAME:
				case syscall.SYS_SOCKETPAIR:
				case syscall.SYS_SETSOCKOPT:
				case syscall.SYS_GETSOCKOPT:
				case syscall.SYS_CLONE:
				case syscall.SYS_FORK:
				case syscall.SYS_VFORK:
				case syscall.SYS_EXECVE:
					// err = syscall.Kill(pid, syscall.SIGKILL)
					// if err != nil {
					// 	return err
					// }

				case syscall.SYS_EXIT:
				case syscall.SYS_WAIT4:
				case syscall.SYS_KILL:
				case syscall.SYS_UNAME:
				case syscall.SYS_SEMGET:
				case syscall.SYS_SEMOP:
				case syscall.SYS_SEMCTL:
				case syscall.SYS_SHMDT:
				case syscall.SYS_MSGGET:
				case syscall.SYS_MSGSND:
				case syscall.SYS_MSGRCV:
				case syscall.SYS_MSGCTL:
				case syscall.SYS_FCNTL:
				case syscall.SYS_FLOCK:
				case syscall.SYS_FSYNC:
				case syscall.SYS_FDATASYNC:
				case syscall.SYS_TRUNCATE:
				case syscall.SYS_FTRUNCATE:
				case syscall.SYS_GETDENTS:
				case syscall.SYS_GETCWD:
				case syscall.SYS_CHDIR:
				case syscall.SYS_FCHDIR:
				case syscall.SYS_RENAME:
				case syscall.SYS_MKDIR:
				case syscall.SYS_RMDIR:
				case syscall.SYS_CREAT:
				case syscall.SYS_LINK:
				case syscall.SYS_UNLINK:
				case syscall.SYS_SYMLINK:
				case syscall.SYS_READLINK:
				case syscall.SYS_CHMOD:
				case syscall.SYS_FCHMOD:
				case syscall.SYS_CHOWN:
				case syscall.SYS_FCHOWN:
				case syscall.SYS_LCHOWN:
				case syscall.SYS_UMASK:
				case syscall.SYS_GETTIMEOFDAY:
				case syscall.SYS_GETRLIMIT:
				case syscall.SYS_GETRUSAGE:
				case syscall.SYS_SYSINFO:
				case syscall.SYS_TIMES:
				case syscall.SYS_PTRACE:
				case syscall.SYS_GETUID:
				case syscall.SYS_SYSLOG:
				case syscall.SYS_GETGID:
				case syscall.SYS_SETUID:
				case syscall.SYS_SETGID:
				case syscall.SYS_GETEUID:
				case syscall.SYS_GETEGID:
				case syscall.SYS_SETPGID:
				case syscall.SYS_GETPPID:
				case syscall.SYS_GETPGRP:
				case syscall.SYS_SETSID:
				case syscall.SYS_SETREUID:
				case syscall.SYS_SETREGID:
				case syscall.SYS_GETGROUPS:
				case syscall.SYS_SETGROUPS:
				case syscall.SYS_SETRESUID:
				case syscall.SYS_GETRESUID:
				case syscall.SYS_SETRESGID:
				case syscall.SYS_GETRESGID:
				case syscall.SYS_GETPGID:
				case syscall.SYS_SETFSUID:
				case syscall.SYS_SETFSGID:
				case syscall.SYS_GETSID:
				case syscall.SYS_CAPGET:
				case syscall.SYS_CAPSET:
				case syscall.SYS_RT_SIGPENDING:
				case syscall.SYS_RT_SIGTIMEDWAIT:
				case syscall.SYS_RT_SIGQUEUEINFO:
				case syscall.SYS_RT_SIGSUSPEND:
				case syscall.SYS_SIGALTSTACK:
				case syscall.SYS_UTIME:
				case syscall.SYS_MKNOD:
				case syscall.SYS_USELIB:
				case syscall.SYS_PERSONALITY:
				case syscall.SYS_USTAT:
				case syscall.SYS_STATFS:
				case syscall.SYS_FSTATFS:
				case syscall.SYS_SYSFS:
				case syscall.SYS_GETPRIORITY:
				case syscall.SYS_SETPRIORITY:
				case syscall.SYS_SCHED_SETPARAM:
				case syscall.SYS_SCHED_GETPARAM:
				case syscall.SYS_SCHED_SETSCHEDULER:
				case syscall.SYS_SCHED_GETSCHEDULER:
				case syscall.SYS_SCHED_GET_PRIORITY_MAX:
				case syscall.SYS_SCHED_GET_PRIORITY_MIN:
				case syscall.SYS_SCHED_RR_GET_INTERVAL:
				case syscall.SYS_MLOCK:
				case syscall.SYS_MUNLOCK:
				case syscall.SYS_MLOCKALL:
				case syscall.SYS_MUNLOCKALL:
				case syscall.SYS_VHANGUP:
				case syscall.SYS_MODIFY_LDT:
				case syscall.SYS_PIVOT_ROOT:
				case syscall.SYS__SYSCTL:
				case syscall.SYS_PRCTL:
				case syscall.SYS_ARCH_PRCTL:
				case syscall.SYS_ADJTIMEX:
				case syscall.SYS_SETRLIMIT:
				case syscall.SYS_CHROOT:
				case syscall.SYS_SYNC:
				case syscall.SYS_ACCT:
				case syscall.SYS_SETTIMEOFDAY:
				case syscall.SYS_MOUNT:
				case syscall.SYS_UMOUNT2:
				case syscall.SYS_SWAPON:
				case syscall.SYS_SWAPOFF:
				case syscall.SYS_REBOOT:
				case syscall.SYS_SETHOSTNAME:
				case syscall.SYS_SETDOMAINNAME:
				case syscall.SYS_IOPL:
				case syscall.SYS_IOPERM:
				case syscall.SYS_CREATE_MODULE:
				case syscall.SYS_INIT_MODULE:
				case syscall.SYS_DELETE_MODULE:
				case syscall.SYS_GET_KERNEL_SYMS:
				case syscall.SYS_QUERY_MODULE:
				case syscall.SYS_QUOTACTL:
				case syscall.SYS_NFSSERVCTL:
				case syscall.SYS_GETPMSG:
				case syscall.SYS_PUTPMSG:
				case syscall.SYS_AFS_SYSCALL:
				case syscall.SYS_TUXCALL:
				case syscall.SYS_SECURITY:
				case syscall.SYS_GETTID:
				case syscall.SYS_READAHEAD:
				case syscall.SYS_SETXATTR:
				case syscall.SYS_LSETXATTR:
				case syscall.SYS_FSETXATTR:
				case syscall.SYS_GETXATTR:
				case syscall.SYS_LGETXATTR:
				case syscall.SYS_FGETXATTR:
				case syscall.SYS_LISTXATTR:
				case syscall.SYS_LLISTXATTR:
				case syscall.SYS_FLISTXATTR:
				case syscall.SYS_REMOVEXATTR:
				case syscall.SYS_LREMOVEXATTR:
				case syscall.SYS_FREMOVEXATTR:
				case syscall.SYS_TKILL:
				case syscall.SYS_TIME:
				case syscall.SYS_FUTEX:
				case syscall.SYS_SCHED_SETAFFINITY:
				case syscall.SYS_SCHED_GETAFFINITY:
				case syscall.SYS_SET_THREAD_AREA:
				case syscall.SYS_IO_SETUP:
				case syscall.SYS_IO_DESTROY:
				case syscall.SYS_IO_GETEVENTS:
				case syscall.SYS_IO_SUBMIT:
				case syscall.SYS_IO_CANCEL:
				case syscall.SYS_GET_THREAD_AREA:
				case syscall.SYS_LOOKUP_DCOOKIE:
				case syscall.SYS_EPOLL_CREATE:
				case syscall.SYS_EPOLL_CTL_OLD:
				case syscall.SYS_EPOLL_WAIT_OLD:
				case syscall.SYS_REMAP_FILE_PAGES:
				case syscall.SYS_GETDENTS64:
				case syscall.SYS_SET_TID_ADDRESS:
				case syscall.SYS_RESTART_SYSCALL:
				case syscall.SYS_SEMTIMEDOP:
				case syscall.SYS_FADVISE64:
				case syscall.SYS_TIMER_CREATE:
				case syscall.SYS_TIMER_SETTIME:
				case syscall.SYS_TIMER_GETTIME:
				case syscall.SYS_TIMER_GETOVERRUN:
				case syscall.SYS_TIMER_DELETE:
				case syscall.SYS_CLOCK_SETTIME:
				case syscall.SYS_CLOCK_GETTIME:
				case syscall.SYS_CLOCK_GETRES:
				case syscall.SYS_CLOCK_NANOSLEEP:
				case syscall.SYS_EXIT_GROUP:
				case syscall.SYS_EPOLL_WAIT:
				case syscall.SYS_EPOLL_CTL:
				case syscall.SYS_TGKILL:
				case syscall.SYS_UTIMES:
				case syscall.SYS_VSERVER:
				case syscall.SYS_MBIND:
				case syscall.SYS_SET_MEMPOLICY:
				case syscall.SYS_GET_MEMPOLICY:
				case syscall.SYS_MQ_OPEN:
				case syscall.SYS_MQ_UNLINK:
				case syscall.SYS_MQ_TIMEDSEND:
				case syscall.SYS_MQ_TIMEDRECEIVE:
				case syscall.SYS_MQ_NOTIFY:
				case syscall.SYS_MQ_GETSETATTR:
				case syscall.SYS_KEXEC_LOAD:
				case syscall.SYS_WAITID:
				case syscall.SYS_ADD_KEY:
				case syscall.SYS_REQUEST_KEY:
				case syscall.SYS_KEYCTL:
				case syscall.SYS_IOPRIO_SET:
				case syscall.SYS_IOPRIO_GET:
				case syscall.SYS_INOTIFY_INIT:
				case syscall.SYS_INOTIFY_ADD_WATCH:
				case syscall.SYS_INOTIFY_RM_WATCH:
				case syscall.SYS_MIGRATE_PAGES:
				case syscall.SYS_OPENAT:
				case syscall.SYS_MKDIRAT:
				case syscall.SYS_MKNODAT:
				case syscall.SYS_FCHOWNAT:
				case syscall.SYS_FUTIMESAT:
				case syscall.SYS_NEWFSTATAT:
				case syscall.SYS_UNLINKAT:
				case syscall.SYS_RENAMEAT:
				case syscall.SYS_LINKAT:
				case syscall.SYS_SYMLINKAT:
				case syscall.SYS_READLINKAT:
				case syscall.SYS_FCHMODAT:
				case syscall.SYS_FACCESSAT:
				case syscall.SYS_PSELECT6:
				case syscall.SYS_PPOLL:
				case syscall.SYS_UNSHARE:
				case syscall.SYS_SET_ROBUST_LIST:
				case syscall.SYS_GET_ROBUST_LIST:
				case syscall.SYS_SPLICE:
				case syscall.SYS_TEE:
				case syscall.SYS_SYNC_FILE_RANGE:
				case syscall.SYS_VMSPLICE:
				case syscall.SYS_MOVE_PAGES:
				case syscall.SYS_UTIMENSAT:
				case syscall.SYS_EPOLL_PWAIT:
				case syscall.SYS_SIGNALFD:
				case syscall.SYS_TIMERFD_CREATE:
				case syscall.SYS_EVENTFD:
				case syscall.SYS_FALLOCATE:
				case syscall.SYS_TIMERFD_SETTIME:
				case syscall.SYS_TIMERFD_GETTIME:
				case syscall.SYS_ACCEPT4:
				case syscall.SYS_SIGNALFD4:
				case syscall.SYS_EVENTFD2:
				case syscall.SYS_EPOLL_CREATE1:
				case syscall.SYS_DUP3:
				case syscall.SYS_PIPE2:
				case syscall.SYS_INOTIFY_INIT1:
				case syscall.SYS_PREADV:
				case syscall.SYS_PWRITEV:
				case syscall.SYS_RT_TGSIGQUEUEINFO:
				case syscall.SYS_PERF_EVENT_OPEN:
				case syscall.SYS_RECVMMSG:
				case syscall.SYS_FANOTIFY_INIT:
				case syscall.SYS_FANOTIFY_MARK:
				case syscall.SYS_PRLIMIT64:
				}

				err = syscall.PtraceSyscall(pid, 0)
				if err != nil {
					return err
				}

			default:
				return ExitError(status)
			}
		}
	}

	panic("unreachable")
}
