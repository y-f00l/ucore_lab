# ucore lab3

- 虚拟内存是操作系统里一个很重要的概念，它有以下几个特点
  - 每个进程都有自己的虚拟内存，并且它的虚拟内存可能并不会映射到物理内存，这就意味着有些时候程序的虚拟内存可能不存在对应的物理内存
  - 虚拟内存的地址和物理内存地址是不对应的，二者的地址不一定相等
  - 操作系统实现了建立从虚拟内存到物理内存的映射关系，可以在访存的时候通过虚拟内存地址转换到对应的物理内存地址。

- 在开启分页机制之后，物理内存就经过了虚拟化变成了虚拟内存，然后可以通过页表来把线性地址转换成物理地址，找到对应的物理内存。
- 有了内存虚拟化之后，我们就可以通过页表项来设定程序访问内存的范围来保证程序运行时不发生越界，保证了内存安全性。可以看成虚拟内存把程序之间都隔离了，他们都有自己的虚拟内存和页表，虚拟内存通过页表映射到了对应的物理内存，这样程序只能访问到自己的内存，不可能写到其他程序的内存
- 内存虚拟化，程序在没有通过虚拟地址访存的时候可以不用在物理内存中为其分配空间，只有真正访存了虚拟内存的时候，os才真正的为其分配物理内存，建立虚拟内存到物理内存的映射关系。
- 对于不常访问的内存，os会把他们从主存中换到磁盘里，当真正的访问到对应内存的时候再从磁盘中换出，换到主存中，这种技术称为page swap in/out(页换入换出)

- ucore为了进行虚拟内存管理抽象出了两个结构体

  - mm_struct

    ```
    struct mm_struct {
        // linear list link which sorted by start addr of vma
        list_entry_t mmap_list;
        // current accessed vma, used for speed purpose
        struct vma_struct *mmap_cache;
        pde_t *pgdir; // the PDT of these vma
        int map_count; // the count of these vma
        void *sm_priv; // the private data for swap manager
    };
    ```

    - mmap_list是指向vma_struct链表的
    - mmap_cache存了最近访问的内存，因为程序的局部性，所以通过cache可以提高程序访存的速度，这样就不需要直接遍历链表了
    - pgdir指向了当前的二级页表
    - map_count表示当前有多少个vma
    - sm_priv是指向swap manager的指针，swap manager是针对物理页换入换出的

  - vma_struct

    ```
    struct vma_struct {
        // the set of vma using the same PDT
        struct mm_struct *vm_mm;
        uintptr_t vm_start; // start addr of vma
        uintptr_t vm_end; // end addr of vma
        uint32_t vm_flags; // flags of vma
        //linear list link which sorted by start addr of vma
        list_entry_t list_link;
    };
    ```

    - vm_mm指向的就是上文提到的mm结构体
    - vm_start标示的是这块虚拟内存的起始地址
    - end是结束地址
    - vm_flags是vma的flag位
    - list_link就是那个双向链表

## exercise 0

- 将lab 1 2的代码merge到当前lab中

## exercise 1

- 给未被映射的物理页填上映射上物理页，完善do_pagefault()函数

- 步骤如下：

  - 首先根据mm结构体和addr参数找到对应的vma

  - 判断vma是否存在，addr是否在addr的地址范围内

  - 然后根据发生page fault的error code来判断是否合法

    - error code代表的含义: 2-> W/R:1 P:0 ; 1->W/R:0 P:1 ; 0 -> W/R:0 P:0
    - 根据error code来进行对应检查:
      - 2 : 写一个不存在的物理页，若对应flag位为不可写，就报错
      - 1 : 读一个存在的物理页，报错(因为已经缺页了，这里又标识存在)
        - 补一下，因为default分支是error code = 3，是写存在的物理页，那为什么读存在的物理页报pgfault不可以，但是写存在的物理页报pgfault是可以的呢？
        - 因为cow机制，os在fork的时候不会全部都把内存copy过去，os做了一个聪明的设计，就是让两个进程共享一个物理页，这样就类似c++的浅拷贝，只有在其中一个进程执行写入操作的时候才会申请一个新的物理页，把内容拷贝过去，这样节省了内存和时间，所以这里写存在的物理页是允许的，因为cow，被fork出来的进程可能在写一个已经存在的物理页，这时候就需要申请一个新页，这就是default对应的pgfault。
        - 但是读一个存在的物理页是不行的，因为你读的话并没有什么问题，就算因为cow，只要去读那个共享的物理页就可以了，不需要pgfault，不符合逻辑
      - 0 : 读一个不存在的物理页，若对应的flag位为不可读，报错

    - 设置一下permission为PTE_U
    - 然后判断一下vma的vm_flags是否可写，如果可写，那permission位加上PTE_W
    - 通过lab2的get_pte函数拿到对应页表项的指针
    - 判断指针是否是空，如果是空那么就说明对应页表项不存在，就报错
    - 判断指针指向的内存是否是空的，如果是空的，那么就说明这个页表项没有映射到物理页，这时候要通过pgdir_alloc_page函数，查看pgdir_alloc_page是申请了一个页，然后插入到对应的页表项，并设置好permission
    - 如果不是空的，说明这个页已经被换到磁盘上了，用swap_in函数将这个页从外存中换出来，然后将其插入对应的页表项。
    - 然后通过swap_map_swappable设置为可换出的

## exercise 2

- 完成do_pgfault以及fifo_swap_in还有fifo_swap_out
- 实现过程不难:
  - do_pgfault上个exercise我好像已经按照guide写好了
  - fifo_swap_in和fifo_swap_out就是单纯的入队出队操作
  - 这里我踩了一个坑，就是在do_pgfault的时候，在把page从外存换到主存里的时候，没有设置对应page的虚拟地址，所以导致swap换出的时候无法把对应地址上的内容写到外存上，从而有一个assert过不去，就是读对应被换出的一个物理页的内容是否等于0xa，因为换出的物理页的内容没有被写到磁盘上，所以换入该页的时候不是对应内容，从而assert过不去

## summary

- 这个实验我们完成了虚拟内存管理，主要涉及物理页的swap in和out，但是具体的代码已经在给出的框架中写好了，看了一眼之后，do_pgfault中对于没有在主存中的页，如果页表项中没有对应的物理页，那么就先申请一个page，然后将其映射到页表项中，把虚拟地址和物理地址对应好。如果有对应的物理页，那么通过swap_in函数把页面换入主存中，swap_in函数根据原先pte中存的数据算出在磁盘的位置，然后把磁盘上的数据读到新申请的页中，这样就相当于把对应物理页从磁盘中换出，然后将新申请的page插入到页表项中，这样就建立好虚拟地址和新的物理地址的对应了。然后通过swap_map_swappable，把对应的物理页插入到fifo的队列中，然后设置好page的pra_vaddr，这样在换出物理页的时候可以根据地址把数据读到磁盘里，我就是踩了这个坑，没有设置vaddr，这样导致物理页被换出的时候数据不对。
- swap_out就是根据页表项中的物理地址来计算存到磁盘的哪个位置，计算好之后就向磁盘写入。换出一般发生在程序试图读取或写入数据，但其虚拟地址对应的物理页面没有在主存中，就要选择将主存中的物理页换出，将外存中的物理页换入。在本次实验中，因为是通过fifo来决定哪个物理页要换出，所以换出的是队尾的页，将新换入的物理页插到队头。

- 但是仍然有一个问题，就是我在看assert的时候，在对对应地址读写的时候，物理页满了，对没有在主存中的地址进行写入时没有明显的调用换入换出函数。

- 通过调试找到问题了，每次申请的一个页的时候，发现物理页全部被占用，无法申请出新的物理页的时候就会去调用swap_out函数来换出fifo队列中的队尾。具体代码

  ```c
  while (1)
      {
           local_intr_save(intr_flag);
           {
                page = pmm_manager->alloc_pages(n);
           }
           local_intr_restore(intr_flag);
  
           if (page != NULL || n > 1 || swap_init_ok == 0) break;
           
           extern struct mm_struct *check_mm_struct;
           //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
           swap_out(check_mm_struct, n, 0);
      }
  ```

  
