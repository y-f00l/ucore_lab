# ucore lab 4

- 本次实验主要是实现内核线程的管理
- 在lab2和3中我们实现内存的虚拟化，让每一个进程都认为自己有独立的内存空间，通过操作系统来进行物理内存的调度，可以充分的利用物理内存。在lab4中我们会实现cpu的虚拟化，让多条控制流可以并发执行，从而让操作系统实时共享cpu。
- 内核线程和用户线程的区别:
  - 内核线程只能运行在内核，用户线程则是在用户态和内核态来回切换
  - 所有内核线程共享ucore的内存空间，不需要额外维护每个线程的内存；而用户线程是需要独享内存空间的，所以os要承担维护他们内存空间的任务。

- 为了实现内核线程，需要管理内核线程的数据结构，就是进(线)程控制块(PCB)。如果要让内核线程运行，首先要创建相应的进程控制块，也要把这些控制块插入到对应的链表中，方便进程管理事务。通过调度器来决定运行哪个进程

## exercise1

- 分配并初始化一个进程控制块
- 分析一下实现过程，因为是分配一个新的进程控制块，但是这个进程控制块并没有指定哪个进程会使用它，审查后面的代码后发现这个就是返回一个基本是空的进程结构体，所以实现流程如下
  - state设置成UNINIT，设置为初始化状态
  - pid设置成-1，因为没有指定哪个进程
  - runs设置成0，不需要run这个进程
  - kstack设置为NULL，目前这个进程块没有具体的进程，所以没有栈指针
  - need_resched设置为0，不需要cpu去调度
  - parent设置为NULL，即没有父进程
  - mm设置成NULL，同kstack，不需要
  - context和name用memset设置成0
  - cr3设置为boot_cr3，因为是内核线程，资源是共享的，所以设置成boot_cr3。
  - tf设置为NULL，同kstack

- Q:请说明proc_struct中`struct context context`和`struct trapframe *tf`成员变量含义和在本实验中的作用是啥？（提示通过看代码和编程调试可以判断出来）
- A: 
  - struct context context是进程的上下文，在进程切换的时候通过这个东西保存当时寄存器的值，线程调度的时候可以恢复之前进程寄存器的值。
  - tf是中断时候保存的各种寄存器还有error_code，trapno等运行时环境，在进入trap的时候这个tf是参数，同时在中断的准备工作时ucore会build一个trapframe来保存中断前的运行环境，方便中断结束后恢复。

## exercise2

- 为新创建的内核线程分配资源
- 注释里写的很清楚，流程
  - 首先alloc_proc申请一个新的PCB
  - 然后set_stack，给新内核线程设置栈，如果失败了就跳到fork_cleanup_proc
  - 然后copy_mm，给新内核线程设置内存管理器，如果失败了就跳到fork_cleanup_stack
  - 然后copy_thread，因为是在do_fork里实现的，所以要copy一下原线程的tf。
  - 然后对proc->pid进行设置，通过get_pid()函数进行获取
  - 然后在hash list中插入该PCB
  - 然后在proc list中插入该PCB
  - 然后就用wakeup唤醒这个线程就好。

- Q： 请说明ucore是否做到给每个新fork的线程一个唯一的id？请说明你的分析和理由
- A：保证了，理由如下:
  - 首先在最开头就保证了MAX_PID > MAX_PROCS,这样PID的数目就大于PROCS的数目了
  - 它通过遍历PCB的链表来寻找和当前PCB链表中的pid不一样的一个pid，来当做返回的pid。

## exercise3

- 理解proc_run函数和他调用的函数如何完成进程切换的

- proc run接受的参数是即将被执行的线程

- 首先通过local_intr_save来关中断，防止进行切换的被打断

- 然后load这个进程的cr3:二级页表base addr，esp:栈顶指针

- 然后用switch to函数进行切换

  ```
  .text
  .globl switch_to
  switch_to:                      # switch_to(from, to)
  
      # save from's registers
      movl 4(%esp), %eax          # eax points to from
      popl 0(%eax)                # save eip !popl
      movl %esp, 4(%eax)          # save esp::context of from
      movl %ebx, 8(%eax)          # save ebx::context of from
      movl %ecx, 12(%eax)         # save ecx::context of from
      movl %edx, 16(%eax)         # save edx::context of from
      movl %esi, 20(%eax)         # save esi::context of from
      movl %edi, 24(%eax)         # save edi::context of from
      movl %ebp, 28(%eax)         # save ebp::context of from
  
      # restore to's registers
      movl 4(%esp), %eax          # not 8(%esp): popped return address already
                                  # eax now points to to
      movl 28(%eax), %ebp         # restore ebp::context of to
      movl 24(%eax), %edi         # restore edi::context of to
      movl 20(%eax), %esi         # restore esi::context of to
      movl 16(%eax), %edx         # restore edx::context of to
      movl 12(%eax), %ecx         # restore ecx::context of to
      movl 8(%eax), %ebx          # restore ebx::context of to
      movl 4(%eax), %esp          # restore esp::context of to
  
      pushl 0(%eax)               # push eip
  
      ret
  ```

  - 代码写的很明显了，不用多解释了吧
  - 这样就切换到to进程的代码执行了

- Q:创建并执行了几个内核线程?
- A:两个，一个idleproc一个initproc
- Q:local_intr_save(intr_flag);....local_intr_restore(intr_flag);有何作用？
- A:分别是表示开/关中断，保证了进程切换过程的原子性。