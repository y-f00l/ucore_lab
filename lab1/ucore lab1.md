# ucore lab1

## exercise1

- Q:操作系统镜像文件ucore.img是如何一步一步生成的？(需要比较详细地解释Makefile中每一条相关命令和命令参数的含义，以及说明命令导致的结果)
- A:在Makefile里发现了关于生产ucore.img的注释，
- ![image-20200803205630530](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200803205630530.png)https://github.com/y-f00l/ucore_lab/tree/master/img
- 用了dd命令，通过make "V="这个命令查看输出信息，dd命令是从input文件copy到output文件
- ![image-20200803205815499](https://github.com/y-f00l/ucore_lab/edit/tree/img/image-20200803205815499.png)
- 分别调用了三次dd命令分别把/dev/zero, bin/bootblock, bin/kernel，这三个copy到ucore.img文件里了。
  - /dev/zero是一个特殊设备文件，读取他的时候他会提供无限的空字符串，可以用作映射匿名的虚拟内存
  - bootblock通过file文件读取发现是一个MBR，也就是主引导记录，他会帮助我们找到bootloader
  - kernel应该是内核的一些代码以及帮助我们调试的代码

- 这样ucore.img这个就完成了
- Q:一个被系统认为是符合规范的硬盘主引导扇区的特征是什么？
- A:我个人认为特征应该是直接加载bootloader到内存里，或者如果有多个分区，帮助我们找到活动分区，然后在活动分区的引导扇区里来加载bootloader，然后把控制权转移给bootloader来加载内核代码，也就是kernel。

## exercise 2

- 从CPU加电后执行的第一条指令开始，单步跟踪bios的执行
  - 首先从0xe05b开始，一直是add [eax],al这个指令(不知道这是什么意思，望大神解答)
  - 在0xfff3d开始，对段寄存器进行初始化，值为0x10,然后jmp到edx(0xf2d4e)
  - 然后在后面就是在对端口进行操作，各种in out指令，不是很理解这是在干嘛

- 在0x7c00处设置实地址断点，测试断点正常，然后进行单步跟踪，并且与bootasm.S和bootblock.asm进行比较
  - 首先bootasm.S和bootblock.asm
    - 前者没有地址，后者有地址
    - 前者保留了很多符号，而后者去除了很多符号，替换成了运行时侯的数据
    - 前者没有bootmain等函数的汇编代码，后者代码是完整的

## exercise 3

- 分析bootloader进入保护模式的过程
  - ![image-20200804021523064](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804021523064.png)这里初始化各个段寄存器
  - ![image-20200804022008642](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804022008642.png)等待8042(键盘控制器)不busy，0x64是8042的命令端口(0x60端口是数据指令)，然后对其进行写入0xd1，这样是准备写Output端口。随后通过0x60端口写入的字节，会被放置在Output Port中。然后再对0x60写入0xdf，这样0xdf就被放在output port里了，这样就开启了A20
  - ![image-20200804022725576](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804022725576.png)这里通过ldgt指令来加载gdt全局描述表，为了进入保护模式做准备(因为gdt就保存的各个段的权限，可以看这里![image-20200804023148505](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804023148505.png)就对cs段设置了x和r权限，对ds段设置了w权限)。然后余下三条指令就是把cr0的保护模式位设置为1，意为开启保护模式，也就有了分段机制。
  - 余下的代码就是开启保护模式之后设置好段寄存器，然后跳入bootmain来加载kernel代码

### exercise 4

- bootloader如何读取磁盘扇区的？
  - bootloader使用了一个函数交readseg
  - ![image-20200804025312741](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804025312741.png)
  - readseg函数首先将va按照sectsize(扇区大小)对齐，根据offset算出在磁盘的哪一个扇区，然后循环调用readsect函数来读取磁盘上的内容
  - ![image-20200804025340109](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804025340109.png)
  - readsect函数首先等待磁盘准备好，然后后面对磁盘的端口进行设置，设置好要读取的扇区号以及读取几次，这里直接就读取1次，因为在readseg里就是按1次来的，然后设置好cmd为0x20(读扇区)后，用insl函数来读取磁盘上的内容到dst，也就是readseg里的va。
- bootloader是如何加载ELF格式的OS？
  - ![image-20200804025918323](https://github.com/y-f00l/ucore_lab/tree/master/img/image-20200804025918323.png)
  - 首先读取了磁盘上的第一页，读取到0x10000处，然后对其进行一下检查，看看文件头是否等于ELF的magic number，如果不是elf文件，那么就跳转到bad
  - 如果是的话就找到elf里的program header，通过program header来找到elf里的各个segment磁盘里的offset，然后根据各个offset调用readseg函数来从磁盘中读取ELF的数据。读取完之后就从ELF里的entry开始执行代码，这个时候就跳到kernel的代码了。

## exercise 5

- 实现堆栈追踪，要求能打印出ebp eip以及各个参数的值
- 注释里已经把实现过程告诉我们了，并且帮助我们实现了两个辅助函数read_ebp和read_eip
- 我们要做的就是迭代的去打印函数堆栈信息就好了
- 在注释里说了boundry是ebp为0，所以用while结构去不断迭代，直到ebp = 0
- 由于之前的基础，我对函数调用过程的栈结构还算熟悉，所以参考资料就没有读
- 流程:
  - 首先读出最开始的ebp和eip，然后因为ebp的高地址处就是参数，将ebp看成int型指针的话，那么四个参数所在的地址分别就是ebp+2, ebp+3, ebp +4, ebp+5。这样我们就能拿到参数信息了。
  - 然后是调用print_debuginfo这个函数来帮我们打印源代码的位置信息
  - 然后拿到下一个函数的ebp，众所周知ebp指向的内存单元处存的就是上一个stack frame的ebp，直接对ebp进行访存操作就可以拿到上一个stack frame的ebp，然后根据新的ebp+1来拿到eip(栈结构就是这样)，然后就进入下一次迭代。

## exercise 6

- Q:中断描述符表中一个表项占多少字节？其中哪几位代表中断处理代码的入口
- A:一个表项占8字节
- ![image-20200805104538057](/Users/g1ft/Library/Application Support/typora-user-images/image-20200805104538057.png)16-31位表示了相应的段选择子，根据这个到GDT里找到对应的段描述符拿到中断处理代码的段基地址，然后0-15位,48-63位共同组成了offset，根据这个base addr + offset就找到了中断处理程序的入口

- 编程完善trap.c的中断向量表的初始化函数
  - 注释中让我们使用SETGATE宏，并且引入vector这个变量，vector就是存储了各个中断处理程序入口地址的一个数组，用vector来初始化中断向量表
  - SETGATE宏需要gete结构体，istrap flag(是否是trap), sel(段选择子), off(代码的偏移，也就是vector里存的地址), dpl(该段特权级)。
  - 找了半天找不到内核代码段的段选择子在哪里，只能去看answer给的code了，在memlayout.h里定义了内核代码段的selector。惭愧
  - 然后实现过程就很简单了，因为中断有256个表项，依次用SETGATE宏初始化就好了。istrap flag位设置为0，表示不是trap而是interrupt。dpl也都设置成kernel的特权级，也就是0，这里用DPL_KERNEL就行(这个宏也在memlayout.h里)
  - 注意一点就是T_SYSCALL对应表的DPL要设置成DPL_USER。
- 编程完善trap.c的中断处理函数
  - 要我们针对时钟中断处理函数做处理，每100次时钟中断就打印出100 ticks!这个信息。
    - 所以用一个全局变量count来标识，在trap dispatch那个函数里的switch case分支中写代码，因为那个对应了各个中断的处理，找到对时钟中断处理的case，在里面添上每执行这个case一次count就加1，然后判断一下是否到100，到100就重置count，然后打印100 ticks

## challenge

- 参考了答案和网上的资料才写出来,wtcl TAT

- 首先是从内核态转到用户态

- 通过内联汇编来写一个switch to kernel的函数，利用int指令来进入trap中的代码

  - 利用int指令从用户到内核态的时候会对cs eip ss esp等寄存器压栈，还有error和trap number
    - 这里要注意我们switch to user的时候，是在ring0的，并没有帮助user保存他的ss和esp，所以我们要为他预留空间
  - 然后就是ds es那些段寄存器压栈
  - 然后是那些通用寄存器压栈
  - 接着就根据trap number跳到对应中断处理程序

- 然后在trap dispatch中添加切换到用户态的代码，这里利用了一个临时变量switchk2u，是一个trapframe

  - 将tf的内容复制到trap frame中

  - 然后是对trapframe的cs ds等段寄存器切到用户态
  - 然后对eflag位进行一下标记，因为进入用户态之后还要调用cprintf，涉及到IO
  - 接着把参数地址换成我们的trap frame，这样再返回的时候就会将我们设置好的那些寄存器值弹出
  - 这样就切换回用户态了

- 切换到内核态的时候跟用户态的代码差不多，所以基本是不变的。
