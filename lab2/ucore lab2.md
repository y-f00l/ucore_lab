# ucore lab2

- lab2是实现物理内存管理

- 在保护模式中地址分为三种：

  - 物理地址 physical address
    - 实际访存用的地址
  - 线性地址 linear address
  - 虚拟地址 virtual address
    - 程序中使用的地址

  - 虚拟地址通过段式管理的地址映射可以得到线性地址，线性地址通过页表可以得到物理地址，在没有引入分页的时候，线性地址就是物理地址。

- 为了实现物理内存管理，os使用了段页式内存管理

- 所谓段页式内存管理，就是在分段的基础上，引入了页表。

  - cpu拿到的都是virtual address，根据gdt和页表来翻译得到物理地址之后才能去访存
  - 由于每个进程都要维护自己的页表，如果只设计成只有一级的页表的话，那么对于内存的开销就会很大，所以引入了二级页表。
    - page_directory的基地址存在cr3寄存器中。
  - TLB，类似于cpu的cache，把一部分页表拿到TLB中，这样下次访存的速度会更快

- 在这个实验中由于我自己的原因，搞混了一些东西
  - 首先是alloc page返回的是一个page *，但是这个是申请一个页面，我当时不知道它的physical address是怎么处理的，后来看到了page2pa函数，所以我们根据alloc page函数传回的page指针可以转换成对应的physical address，并且这个page数据结构只是一个物理页的抽象，并不是真正的物理页，它和对应的物理页有一个映射关系，通过这个小型的数据结构来维护整个页表的状态。
  - 在最开始的时候错误的以为os是负责地址转换的，所以我在写代码的时候就一直在纳闷，因为代码里都是virtual address，os是怎么对物理内存进行操作的。整理了一下之后明白进行地址转换的部件在cpu内部，是MMU，所以os并不是负责地址转换的，它只是负责建立页表来管理物理内存这个资源，但os自身也抽象出了地址转换的规则，因为页表里都是physical address的，os通过抽象出地址转换规则来填充页表，我们写出来os的代码都是虚拟地址，都是要通过MMU去转换的，这个过程不归os管。

## exercise 0

- 将上一个lab的code merge进来

## exercise 1

- 实现物理页的first fit算法
- lab中给出了default_alloc等函数，阅读代码之后发现就是first fit算法，只不过实现上有一点问题
  - 在free page的时候，需要将合并后的物理页插入free list，这里使用的是list_add，这样会导致在check的时候有个assert过不去，改用add_before就可以了

## exercise 2

- 可以看一下二级页表的结构：

  ![image-20200809025807420](/Users/g1ft/Library/Application Support/typora-user-images/image-20200809025807420.png)

- linear address是段式内存管理通过虚拟地址转换的，然后可以看到MMU是这样找到物理地址的，那么在这个exercise里我们要做的就是拿到pte的地址，函数有三个参数，一个是pgdir(页目录基地址)，一个是la(线性地址)，一个是create(如果没有对应page table，且create为1，那么就新建一个page table)那么我们可以拆分成以下步骤:
  - 首先用PDX macro来拿到page directory的index，从而拿到对应的page table的base address
  - 判断一下是否有对应的page table，如果有的话，那么就拿到对应的base address，然后用PTE_ADDR macro来去掉一些flag位，接着用KADDR拿到对应的虚拟地址，然后通过PTX macro来拿到对应的pte表项，取址之后就是我们想要的pte的地址了。
  - 如果没有对应的page table，且create为0，那么就返回null
  - 如果create为1，那么就申请一个新的物理页，然后初始化后插入对应的page directory，然后重复第二步的那些操作。

## exercise 3

- 注释里写的很详细了，照着看代码就好了
- Q:数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
- A:有对应关系，数据结构Page的全局数组可以根据数组的基地址来算出是第几个page，然后通过PGSHIFT来拿到对应page的物理地址
- Q:如果希望虚拟地址与物理地址相等，则需要如何修改lab2，完成此事？
- A:(参照答案)可以通过把virtual address<-linear address的映射关系转成virtual address = linear address - 0xc0000000。因为在ucore初始化结束后，linear address和virtual address是相等的，都是physical address + 0xc0000000，所以通过更新gdt来更新virtual address和linear address的映射关系改变。