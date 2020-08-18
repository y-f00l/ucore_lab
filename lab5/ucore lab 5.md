# ucore lab 5

- 上一个lab我们初始化了第一个内核线程，这个lab是让我们来管理用户进程



## exercise 0

- 填写lab1/2/3/4的代码，并且进行一定的修改
- 首先是在lab5中，对于proc结构体新加入了optr cptr等成员，在alloc_proc的时候要对其进行初始化
- 然后是在do_fork的时候，要设置新的proc的parent为current
- 还是do_fork的时候，对于将新的pcb连入链表，不需要用list_add和nr_proc++，直接用封装好的set_links函数就可以了
- 在时钟中断的trap分支，每100个时钟周期，要将current的need_resched设置为1，这样方便cpu再次调度
- 并且要删除print_ticks，不删没法过一个check

## exercise 1

- 完成load_icode函数，并理清楚整个函数是怎样把elf格式的文件加载进来的
  - 对于完成load_icode函数，注释给的很明白了，根据注释来写就好了
  - 主要是因为用户进程，我们需要把trapframe设置成USER相关的

- 分析整个函数的作用
  - 首先检查current->mm是否是空的，这个必须是空的，因为要加载对应程序到内存空间中，不能用别人的，必须起一个新的
  - 接着mm_create()创建一个新的mm结构体
  - 然后set_pgdir()设置二级页表
  - 然后定义了elf变量和ph变量(ph代表了program header，看过ELF header的都懂)
  - 然后检查了一下elf文件的magic number是否是elf的magic number
  - 接着就根据ph来读取各个section的信息，然后mmap出来一块区域，然后把按照ph中记录的属性来创建mm中的vma
  - 接着是申请物理页来记录程序并且把对应内容copy到物理页上
  - 加载程序各个section的过程都差不多，对于TEXT段和DATA段都是copy内容，但对于bss段就设置0就好了，因为bss段就是未初始化的全局变量，要初始化成0
  - 然后是设置好用户空间的栈，在memorylayout中定义了用户栈在虚拟空间的起始位置
  - 接着是把当前页表的基地址加载到cr3中，注意一下加载的是物理地址
  - 然后就是设置对应的tf，和lab1的challenge很像，就不细说了
  - 这里注意一下tf的eip被设置成elf的e_entry，也就是代码的entry地址

- 对于创建了一个用户态进程，并加载对应的应用程序进行执行的时候，CPU是如何让这个进程运行起来的(即这个用户态进程被ucore选择占用CPU执行（RUNNING态）到具体执行应用程序第一条指令的整个经过。)
  - 首先用户进程进行exec系统调用，进入trap_entry，保存trapframe，然后跳到syscall去执行，然后syscall去执行对应的exec代码
  - exec代码主要是设置一下进程的name，然后调用load_icode函数，就是上文的函数，这样就准备好新进程的运行环境了。
- 至此exercise1完成

## exercise 2

- 这个主要是完成copy_range，很简单
- 按照注释写就可以了

## exercise 3

- 请分析fork/exec/wait/exit在实现中是如何影响进程的执行状态的？

  - fork:
    - 首先通过中断执行fork系统调用，通过syscall来执行do_fork代码
    - do_fork设置了子进程的各个state，比如parent成员等等，然后copy一下父进程的一些内存之类的
    - 把子进程的pcb加入相应的链表中
    - 通过wakeup来把子进程的pcb标记为RUNABLE，这样cpu就可以通过调度器来选择子进程执行
    - 然后中断完成，正常返回

  - exec:
    - 首先通过中断执行exec系统调用，通过syscall来执行do_exec代码
    - do_exec函数流程上面已经说了，就不需要说了
    - 要注意的一点是，fork完成后是按照中断正常返回的，fork出的子进程不会立刻执行，会等待cpu的调度
    - 但是exec函数不一样，在中断返回的时候，因为在load_icode函数里对当前proc的tf进行了修改，改成了要运行的二进制文件的入口代码的地址，所以返回的时候会跳到那个加载好的二进制文件的入口处执行

  - wait

    - 首先通过中断执行wait系统调用，通过syscall来执行do_wait代码

    - do_wait主要是根据pid来判断，

    - 如果pid不是0，那么就通过pid来找到对应的proc，然后判断一下proc的父进程是否是current proc(因为current proc才是调用wait的proc)，

      - 如果是的话就看一下这个proc的state是否是ZOMBIE，
        - 如果是就跳到found label那里执行将对应pcb从链表中移除，然后释放对应的栈，释放对应的pcb
        - 如果不是就将haskid设为1

      - 如果不是的话就说明current proc没有权利等待pid对应的进程

    - 如果pid是0，那么就遍历跟current proc有关系的proc，将haskid标为1
      - 如果找到有proc的state是ZOMBIE，那么就跳到found label处执行

    - 接下来是haskid的作用，因为在上面执行的代码中没有找到子进程是ZOMBIE的，所以current proc应该进入SLEEPING状态，来等待其中子进程为ZOMBIE，标记current proc的STATE为SLEEPING后通过schedule来进行调度，切到别的进程。
    - 子进程变为zombie一般都是通过exit，在exit里，子进程变为zombie状态后就会用wakeup函数来唤醒父进程，进行资源回收。

  - exit

    - 首先通过中断执行exit系统调用，通过syscall来执行do_exit代码
    - do_exit代码对于当前进程的mm进行了计数-1的操作，这时候会做一个判断，如果计数变为0，那么就对这个mm进行移除，因为没有proc引用它了
    - 然后给当前proc标记为ZOMBIE，告诉调度器这是个僵死进程
    - 然后根据它的parent拿到父进程，如果父进程的状态是WT_CHILD,那么就wakeup父进程，让其进行进一步的资源回收。
    - 后面的代码没读懂，不知道cptr等指针的具体含义
    - exit会直接标记当前进程为ZOMBIE，并等待父进程进行进一步的资源回收

- 请给出ucore中一个用户态进程的执行状态生命周期图（包执行状态，执行状态之间的变换关系，以及产生变换的事件或函数调用）。（字符方式画即可）
  - 略