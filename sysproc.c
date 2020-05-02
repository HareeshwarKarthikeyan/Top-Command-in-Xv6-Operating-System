#include "types.h"
#include "x86.h"
#include "defs.h"
#include "date.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"
#include "pstat.h"
#include "spinlock.h"
#include "memlayout.h"

struct
{
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

struct pstat pstat;

int sys_fork(void)
{
  return fork();
}

int sys_exit(void)
{
  exit();
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
}

int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
  return kill(pid);
}

int sys_getpid(void)
{
  return myproc()->pid;
}

int sys_sbrk(void)
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
  if (growproc(n) < 0)
    return -1;
  return addr;
}

int sys_sleep(void)
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
  {
    if (myproc()->killed)
    {
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
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

//implemented by Harry
int sys_hello(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
  cprintf("\nHello World %d\n", n);
  return 0;
}

int sys_halt(void)
{
  outb(0xf4, 0x00);
  return 0;
}

int sys_gettop(void)
{
  cprintf("TOP COMMAND\n");
  //get data from the processes table
  struct proc *p;
  int no_ticks;
  static char *states[] = {
      [UNUSED] "Unused",
      [EMBRYO] "Embryo",
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == 0)
      unused++;
    else if (p->state == 1)
      embryo++ ;
    else if (p->state == 2)
      sleeping++;
    else if (p->state == 3)
      runnable++;
    else if (p->state == 4)
      running++;
    else
      zombie++;
  }
  // getting the size of physical memory
  int mem = (int)PHYSTOP;
  // printing stats
  cprintf("\nUser : Root \nTasks: \nTotal: %d  Unused: %d  Embryo: %d  Sleeping: %d Runnable: %d  Running: %d  Zombie: %d",
      NPROC,unused,embryo,sleeping,runnable,running,zombie);
  cprintf("\nCPU Size : %d \nTicks : %d\n",mem,sys_uptime());
  cprintf("\nPID   USER   COMMAND   STATE        RES     TIME+      %%MEM    %%CPU");
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
     if (p->pid != 0)
     {

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
      no_ticks = no_ticks - (seconds * 100);
      seconds = seconds - (minutes * 60);
      int size = (int)p->sz;
      int rem = size % mem;
      int timewhole = size / mem;
      int timedecimal = 0;
      int res[6];
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
      {
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
      {
        timedecimal = (timedecimal * 10) + res[i];
      }

      // %CPU
      int total_time = sys_uptime();
      int elapsed_time = p->calticks;
      int usagewhole, usagedecimal;
      //division
      rem = elapsed_time % total_time;
      usagewhole = elapsed_time / total_time;
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
      {
        rem = rem * 10;
        res[i] = rem / total_time;
        rem = rem - (total_time * res[i]);
      }
      usagewhole = (usagewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
      {
        usagedecimal = (usagedecimal * 10) + res[i];
      }

      //print
      cprintf("\n %d    %s    %s    %s   %d    %d:%d.%d     %d.%d    %d.%d",
              p->pid, "root", p->name, states[p->state], size,
              minutes, seconds, no_ticks, timewhole, timedecimal, usagewhole, usagedecimal);
      cprintf("\n");
    }
  }

  return 0;
}