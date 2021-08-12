#include "types.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "mmu.h"
#include "x86.h"
#include "proc.h"
#include "spinlock.h"

struct {
  struct spinlock lock;
  struct proc proc[NPROC];
} ptable;

static struct proc *initproc;


struct Queue {
struct proc *q[64];//ptable의 있는 process 주소를 가르키는 것.
int count;
};

struct Queue l0 = {.count = 0};
struct Queue l1= {.count = 0};

void enqueue(struct Queue* Q, struct proc* p)
{
  Q->q[Q->count] = p;
  Q->count++;
}

int boosting = -1;

int nextpid = 1;
extern void forkret(void);
extern void trapret(void);

static void wakeup1(void *chan);

void
pinit(void)
{
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
}

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
//CPU 구조에서 proc를 읽는 동안 일정이 조정되지 않도록 인터럽트 사용 안 함

struct proc* myproc(void) {

  struct cpu *c;
  struct proc *p;
  pushcli();
  c = mycpu();
  p = c->proc;
  popcli();
  return p;
}

//PAGEBREAK: 32
// Look in the process table for an UNUSED proc.
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;

  //cprintf("alloc %d\n", p->pid);
#ifdef MULTILEVEL_SCHED
  if(p->pid % 2 == 0 )//even
  {
     enqueue(&l0, p);
  }
  else
  {
    enqueue(&l1, p);
  }

#elif MLFQ_SCHED
   enqueue(&l0, p);
   p->quantum = 0;
   p->priority = 0;
   p->lev = 0;
  // cprintf("alloc %d\n",p->pid);
   if(boosting == -1)
   {
      boosting = ticks;
   }
 
#endif

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
  p->tf->es = p->tf->ds;
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
  p->cwd = namei("/");

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);

  p->state = RUNNABLE;

  release(&ptable.lock);
}

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
  return 0;
}


void priorityBoosting(void)
{

  if(boosting != -1 && ticks - boosting > 200)//priority boosting.
  {
    boosting = ticks;
    
    if(l1.count > 0)
    {
       
     //  cprintf("L1 to L0 boosting!!\n");
       for(int i = 0; i < l1.count; i++)
       { 
          if(l1.q[i]->pid <= 0) continue;
       //   cprintf("%d\n",l1.q[i]->pid);
          l1.q[i]->priority = 0;
          l1.q[i]->lev = 0;
          l0.q[l0.count] = l1.q[i];
          l0.count++;
       }
       
       for(int i = 0; i < l1.count; i++)
       {
          l1.q[i] = 0;
       }
       l1.count = 0;
    }

  }

}

int getlev(void)
{   
    return myproc()->lev;
}

int setpriority(int pid, int priority)
{

   acquire(&ptable.lock);

   if(priority<0 || priority >10) 
   {
      release(&ptable.lock);
      return -2;
   }

   for(int i = 0; i < l0.count; i++)
   { 
     if(l0.q[i]->pid == pid)
     {
  //      cprintf("Find L0 %d\n",l0.q[i]->pid);
        l0.q[i]->priority = priority;
        release(&ptable.lock);
        return 0;
     }
   }
    for(int i = 0; i < l1.count; i++)
    { 
      if(l1.q[i]->pid == pid)
      {
        
    //     cprintf("Find L1 %d\n",l1.q[i]->pid);
         l1.q[i]->priority = priority;
         release(&ptable.lock);
         return 0;
      }
    } 
  
  release(&ptable.lock);
  return -1;
}

void monopolize(int password)
{
  if(password != 2017029452)
  {

    kill(myproc()->pid);
    pushcli();
    mycpu()->isMono=0;
    popcli();
    return;
  }
  
  pushcli();
  if(mycpu()->isMono == 0)//이제 독점 해줘야할떄.
  {
 //   cprintf("독점.\n"); 
    mycpu()->isMono = 1;
    myproc()->monopolize = 1;
   
    myproc()->quantum = 0;
    myproc()->priority=0;

   }
   else//독점 풀어줘야할떄.
   {

    mycpu()->isMono = 0;
    myproc()->monopolize = 0;
   
    myproc()->quantum = 0;
    myproc()->priority=0;
    
    if(myproc()->lev == 1)
    {
       int i;
        for(i = 0; i < l1.count; i++)
        {
            if(myproc()->pid == l1.q[i]->pid)
            {
                break;
            }
        }
        l1.q[i] = 0;
        enqueue(&l0, myproc());
        
        for(int j = i; j < l1.count; j ++)
        {
            l1.q[j] = l1.q[j+1];
        }
        l1.q[l1.count] = 0;
        l1.count--;
    }
    myproc()->lev=0;
   }
  popcli();
 
}


// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
  int i, pid;
  struct proc *np;//process를 가르킴.
  struct proc *curproc = myproc();//현재 process를 가르킴

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){ 
//페이지 테이블이 0일떄(안될 때 같음)
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;
//Trap frame과 fork한 프로세스의 부모를 자기로 할당해줌

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;

  release(&ptable.lock);

  return pid;//자신의 Pid를 리턴해줌
}

// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
  iput(curproc->cwd);
  end_op();
  curproc->cwd = 0;

  acquire(&ptable.lock);

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
      if(p->state == ZOMBIE)
        wakeup1(initproc);
    }
  }
  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
  sched();
  panic("zombie exit");
}

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}

//PAGEBREAK: 42
// Per-CPU process scheduler.
// Each CPU calls scheduler() after setting itself up.
// Scheduler never returns.  It loops, doing:
//  - choose a process to run
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{

  struct cpu *c = mycpu();
  c->proc = 0;
  struct proc *p = 0;  
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
#ifdef FCFS_SCHED
       struct proc *prev = 0;
       for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
       {
            int changeTime = 0;
            if(p->state != RUNNABLE)
              continue;
             
            // ignore init and sh processes from FCFS
             //p is RUNNABLE. 
           if(p->pid >= 3) 
           { 
              if(prev != 0) 
              {
                if(p->pid > prev->pid) 
                {
                    if( prev ->state == RUNNABLE)
                         p = prev;
                    else changeTime = 1; 
                }
                else 
                {
                   changeTime =1;
                }
              }
              else// prev == 0 처음.
              {
                if(nextpid - 1 == p->pid) changeTime =0;
                else changeTime = 1;
              }
           }
            
            if(p != 0)
            {
              if( changeTime == 1)
              {
                   p->scheduleTime = ticks;     
              } 
               // Switch to chosen process.  It is the process's job
               // to release ptable.lock and then reacquire it
               // before jumping back to us.
               c->proc = p;
               switchuvm(p);
               p->state = RUNNING;
               swtch(&(c->scheduler), p->context);
               switchkvm();
   
               prev = p;
               // Process is done running for now.
               // It should have changed its p->state before coming back.
               c->proc = 0;
             }
        }
#elif MULTILEVEL_SCHED
      int count = 0; // check whether RUNNABLE process or not in l0
//Round Robin
      
      for(int i = 0; i < l0.count; i++) { 
        p = l0.q[i];
   
        if(p->state != RUNNABLE)
          continue;
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
  
        swtch(&(c->scheduler), p->context);
        switchkvm();
        
        if(p->state == RUNNABLE)
        {
           count++;
        }
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;
      }
//FCFS
    if( count == 0 )
    {
      struct proc* prev = 0;
      for(int i = 0; i < l1.count; i++)
      {
        p = l1.q[i];
        int changeTime = 0;
           
       if(p->state != RUNNABLE)
         continue;  
  
       // ignore init and sh processes from FCFS
       if(p->pid >= 1)  //p is RUNNABLE. 
       {                          
         if(prev != 0) 
         {
           if(p->pid > prev->pid) 
           {
              if( prev ->state == RUNNABLE)
                   p = prev;
              else changeTime = 1; 
           }
           else 
           {
              changeTime =1;
           }
         }
         else// prev == 0 처음.
         {            
            if(nextpid - 1 == p->pid) changeTime =0;
            else changeTime = 1;
         } 
       }
 
       if(p != 0)
       {
         if(changeTime == 1)
         {
              p->scheduleTime = ticks;         
         } 
          // Switch to chosen process.  It is the process's job
          // to release ptable.lock and then reacquire it
          // before jumping back to us.
          c->proc = p;
          switchuvm(p);
          p->state = RUNNING;
  
          swtch(&(c->scheduler), p->context);
          switchkvm();
  
          prev = p;
          // Process is done running for now.
          // It should have changed its p->state before coming back.
          c->proc = 0;
       }
     }
   }
#elif MLFQ_SCHED

priorityBoosting();
// cprintf("mycpu %d\n",mycpu()->isMono);
  
 //cprintf("L0 queue count %d\n",l0.count);
      
if(mycpu()->isMono == 1)//l0에 있는 프로세스 중 독점하기.
{
   for(int i = 0; i < l0.count; i++) { 
    p = l0.q[i];

    if(p->state != RUNNABLE)
      continue;
    if(p->monopolize != 1)
      continue;
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();
  
    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;
  }
   for(int i = 0; i < l1.count; i++) { 
    p = l1.q[i];

    if(p->state != RUNNABLE)
      continue;
    if(p->monopolize != 1)
      continue;
    // Switch to chosen process.  It is the process's job
    // to release ptable.lock and then reacquire it
    // before jumping back to us.
    c->proc = p;
    switchuvm(p);
    p->state = RUNNING;

    swtch(&(c->scheduler), p->context);
    switchkvm();
  
    // Process is done running for now.
    // It should have changed its p->state before coming back.
    c->proc = 0;
  }

}
else
{
      int count = 0;
      for(int i = 0; i < l0.count; i++){ 
        p = l0.q[i];
   
        if(p->state != RUNNABLE)
          continue;
        // Switch to chosen process.  It is the process's job
        // to release ptable.lock and then reacquire it
        // before jumping back to us.
        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
        p->quantum++;

        swtch(&(c->scheduler), p->context);
        switchkvm();
        if(p->quantum == 4)
        {
           enqueue(&l1, p);   
           //l0.q[i] = 0;
           p->quantum = 0;
           p->scheduleTime = ticks;
           p->lev = 1;
           for(int j = i; j < l0.count; j ++)
           {
               l0.q[j] = l0.q[j+1];
           }
           l0.q[l0.count] = 0;
           l0.count--;

//            for(int k = 0; k < l0.count; k++)
//           {
//               if(l0.q[k]->pid == p->pid)
//                 cprintf("이상");
//           }
//           for(int k = 0; k < l1.count; k++)
//           {
//               if(l1.q[k]->pid == p->pid)
//                 cprintf("%d L1으로 이동\n",p->pid);
//           }  
           
 
        //   cprintf("L0 queue count %d\n",l0.count);
          // cprintf("L1 queue count %d\n",l1.count);
        }
        else
        {
           if(p->state == RUNNABLE)
           {
              count++;
           }
        }
     
       priorityBoosting(); 
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;

        if(mycpu()->isMono==1)
        {
           break;
        }
      }//L0 queue RR scheduling
   
      if(count == 0)
      {
         struct proc* p1 = 0;
         struct proc* highPriority = 0;

         for(int i = 0; i < l1.count; i++){ 
          p1 = l1.q[i];
     
          if(p1->state != RUNNABLE)
            continue;
          
         highPriority = p1;
         
         for(int j = 0; j < l1.count; j++) { 
            p = l1.q[j];
       
            if(p->state != RUNNABLE)
              continue;
    
            if(p->priority > highPriority->priority)
            {
               highPriority = p;
            }
            else if(p->priority == highPriority->priority)
            { 
               if(p->scheduleTime < highPriority->scheduleTime)
                 highPriority = p; 
            }
        }

        p = highPriority;

        c->proc = p;
        switchuvm(p);
        p->state = RUNNING;
        p->quantum++;

        swtch(&(c->scheduler), p->context);
        switchkvm();
        if(p->quantum == 8)
        {
          p->quantum=0;
          if(p->priority > 0 )
          {
              p->priority--;
          }
        }
  
        priorityBoosting(); 
        // Process is done running for now.
        // It should have changed its p->state before coming back.
        c->proc = 0;

        if(mycpu()->isMono==1)
        {
           break;
        }
      } 
   }
}



#else 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
      if(p->state != RUNNABLE)
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
#endif

    release(&ptable.lock);

  }
}

// Enter scheduler.  Must hold only ptable.lock
// and have changed proc->state. Saves and restores
// intena because intena is a property of this
// kernel thread, not this CPU. It should
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
  sched();
  release(&ptable.lock);
}

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");

  // Must acquire ptable.lock in order to
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
  p->state = SLEEPING;

  sched();

  // Tidy up.
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}

//PAGEBREAK!
// Wake up all processes sleeping on chan.
// The ptable lock must be held.
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
}

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}

//PAGEBREAK: 36
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
  static char *states[] = {
  [UNUSED]    "unused",
  [EMBRYO]    "embryo",
  [SLEEPING]  "sleep ",
  [RUNNABLE]  "runble",
  [RUNNING]   "run   ",
  [ZOMBIE]    "zombie"
  };
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
