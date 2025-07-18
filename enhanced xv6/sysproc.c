#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "fs.h"  
#include "spinlock.h"
#include "sleeplock.h"
#include "file.h"

int
sys_fork(void)
{
  return fork();
}

int
sys_exit(void)
{
  exit();
  return 0;  // not reached
}

int
sys_wait(void)
{
  return wait();
}

int
sys_kill(void)
{
  int pid;

  if(argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int
sys_getpid(void)
{
  return myproc()->pid;
}

int
sys_sbrk(void)
{
  int addr;
  int n;

  if(argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if(growproc(n) < 0)
    return -1;
  return addr;
}

int
sys_sleep(void)
{
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}


int
sys_gethistory(void)
{   
  
  return gethistory();
  
}

#define MAX_SYSCALL 64  // Adjust based on the highest syscall number

// int blocked_syscalls[MAX_SYSCALL] = {0}; // 0 means unblocked

int sys_block(void) {
  int syscall_id;
  if (argint(0, &syscall_id) < 0)
    return -1;
  
  // Prevent blocking fork or exit
  if (syscall_id == 1 || syscall_id == 2)
    return -1;

  struct proc *p = myproc();
  p->blocked_syscalls[syscall_id] = 1;
  

  return 0;
}

int sys_unblock(void) {
  int syscall_id;
  if (argint(0, &syscall_id) < 0)
    return -1;

  struct proc *p = myproc();
  if(p->pass_syscalls[syscall_id] == 1){
    return -1;
  }
  p->blocked_syscalls[syscall_id] = 0;
  return 0;
}


// Function to handle the chmod system call
int
sys_chmod(void)
{
  char *file;
  int mode;

  // Get the filename and mode from user space
  if (argstr(0, &file) < 0 || argint(1, &mode) < 0) {
    return -1; // Invalid arguments
  }

  // Validate the mode (3-bit integer)
  if (mode < 0 || mode > 7) {
    return -1; // Invalid mode
  }

  // Find the file in the file system
  struct inode *ip = namei(file);
  begin_op();
  if (ip == 0) {
    end_op();
    return -1; // File not found
  }

  // Acquire the inode lock
  ilock(ip);

  // Update the file's mode (permissions)
  ip->mode = mode & 0x7;

  // Mark the inode as dirty
  iupdate(ip);

  // Release the inode lock
  iunlock(ip);

  end_op();
  return 0; // Success
}