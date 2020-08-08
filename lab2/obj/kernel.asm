
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
c0100000:	b8 00 80 11 00       	mov    $0x118000,%eax
    movl %eax, %cr3
c0100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
c0100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
c010000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
c0100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
c0100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
c0100016:	8d 05 1e 00 10 c0    	lea    0xc010001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
c010001c:	ff e0                	jmp    *%eax

c010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
c010001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
c0100020:	a3 00 80 11 c0       	mov    %eax,0xc0118000

    # set ebp, esp
    movl $0x0, %ebp
c0100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010002a:	bc 00 70 11 c0       	mov    $0xc0117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c010002f:	e8 02 00 00 00       	call   c0100036 <kern_init>

c0100034 <spin>:

# should never get here
spin:
    jmp spin
c0100034:	eb fe                	jmp    c0100034 <spin>

c0100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c0100036:	55                   	push   %ebp
c0100037:	89 e5                	mov    %esp,%ebp
c0100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c010003c:	ba a8 af 11 c0       	mov    $0xc011afa8,%edx
c0100041:	b8 00 a0 11 c0       	mov    $0xc011a000,%eax
c0100046:	29 c2                	sub    %eax,%edx
c0100048:	89 d0                	mov    %edx,%eax
c010004a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0100055:	00 
c0100056:	c7 04 24 00 a0 11 c0 	movl   $0xc011a000,(%esp)
c010005d:	e8 a0 56 00 00       	call   c0105702 <memset>

    cons_init();                // init the console
c0100062:	e8 66 15 00 00       	call   c01015cd <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c0100067:	c7 45 f4 00 5f 10 c0 	movl   $0xc0105f00,-0xc(%ebp)
    cprintf("%s\n\n", message);
c010006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100071:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100075:	c7 04 24 1c 5f 10 c0 	movl   $0xc0105f1c,(%esp)
c010007c:	e8 11 02 00 00       	call   c0100292 <cprintf>

    print_kerninfo();
c0100081:	e8 b2 08 00 00       	call   c0100938 <print_kerninfo>

    grade_backtrace();
c0100086:	e8 89 00 00 00       	call   c0100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
c010008b:	e8 86 30 00 00       	call   c0103116 <pmm_init>

    pic_init();                 // init interrupt controller
c0100090:	e8 9d 16 00 00       	call   c0101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
c0100095:	e8 22 18 00 00       	call   c01018bc <idt_init>

    clock_init();               // init clock interrupt
c010009a:	e8 d1 0c 00 00       	call   c0100d70 <clock_init>
    intr_enable();              // enable irq interrupt
c010009f:	e8 c8 17 00 00       	call   c010186c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000a4:	eb fe                	jmp    c01000a4 <kern_init+0x6e>

c01000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000a6:	55                   	push   %ebp
c01000a7:	89 e5                	mov    %esp,%ebp
c01000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000b3:	00 
c01000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000bb:	00 
c01000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000c3:	e8 96 0c 00 00       	call   c0100d5e <mon_backtrace>
}
c01000c8:	90                   	nop
c01000c9:	c9                   	leave  
c01000ca:	c3                   	ret    

c01000cb <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000cb:	55                   	push   %ebp
c01000cc:	89 e5                	mov    %esp,%ebp
c01000ce:	53                   	push   %ebx
c01000cf:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
c01000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
c01000db:	8b 45 08             	mov    0x8(%ebp),%eax
c01000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
c01000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01000ea:	89 04 24             	mov    %eax,(%esp)
c01000ed:	e8 b4 ff ff ff       	call   c01000a6 <grade_backtrace2>
}
c01000f2:	90                   	nop
c01000f3:	83 c4 14             	add    $0x14,%esp
c01000f6:	5b                   	pop    %ebx
c01000f7:	5d                   	pop    %ebp
c01000f8:	c3                   	ret    

c01000f9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000f9:	55                   	push   %ebp
c01000fa:	89 e5                	mov    %esp,%ebp
c01000fc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000ff:	8b 45 10             	mov    0x10(%ebp),%eax
c0100102:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100106:	8b 45 08             	mov    0x8(%ebp),%eax
c0100109:	89 04 24             	mov    %eax,(%esp)
c010010c:	e8 ba ff ff ff       	call   c01000cb <grade_backtrace1>
}
c0100111:	90                   	nop
c0100112:	c9                   	leave  
c0100113:	c3                   	ret    

c0100114 <grade_backtrace>:

void
grade_backtrace(void) {
c0100114:	55                   	push   %ebp
c0100115:	89 e5                	mov    %esp,%ebp
c0100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011a:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c010011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100126:	ff 
c0100127:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100132:	e8 c2 ff ff ff       	call   c01000f9 <grade_backtrace0>
}
c0100137:	90                   	nop
c0100138:	c9                   	leave  
c0100139:	c3                   	ret    

c010013a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013a:	55                   	push   %ebp
c010013b:	89 e5                	mov    %esp,%ebp
c010013d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100140:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100143:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100146:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100149:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100150:	83 e0 03             	and    $0x3,%eax
c0100153:	89 c2                	mov    %eax,%edx
c0100155:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c010015a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010015e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100162:	c7 04 24 21 5f 10 c0 	movl   $0xc0105f21,(%esp)
c0100169:	e8 24 01 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100172:	89 c2                	mov    %eax,%edx
c0100174:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100179:	89 54 24 08          	mov    %edx,0x8(%esp)
c010017d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100181:	c7 04 24 2f 5f 10 c0 	movl   $0xc0105f2f,(%esp)
c0100188:	e8 05 01 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100191:	89 c2                	mov    %eax,%edx
c0100193:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c0100198:	89 54 24 08          	mov    %edx,0x8(%esp)
c010019c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a0:	c7 04 24 3d 5f 10 c0 	movl   $0xc0105f3d,(%esp)
c01001a7:	e8 e6 00 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b0:	89 c2                	mov    %eax,%edx
c01001b2:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001b7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001bf:	c7 04 24 4b 5f 10 c0 	movl   $0xc0105f4b,(%esp)
c01001c6:	e8 c7 00 00 00       	call   c0100292 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001cb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001cf:	89 c2                	mov    %eax,%edx
c01001d1:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001d6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001de:	c7 04 24 59 5f 10 c0 	movl   $0xc0105f59,(%esp)
c01001e5:	e8 a8 00 00 00       	call   c0100292 <cprintf>
    round ++;
c01001ea:	a1 00 a0 11 c0       	mov    0xc011a000,%eax
c01001ef:	40                   	inc    %eax
c01001f0:	a3 00 a0 11 c0       	mov    %eax,0xc011a000
}
c01001f5:	90                   	nop
c01001f6:	c9                   	leave  
c01001f7:	c3                   	ret    

c01001f8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f8:	55                   	push   %ebp
c01001f9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001fb:	90                   	nop
c01001fc:	5d                   	pop    %ebp
c01001fd:	c3                   	ret    

c01001fe <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001fe:	55                   	push   %ebp
c01001ff:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100201:	90                   	nop
c0100202:	5d                   	pop    %ebp
c0100203:	c3                   	ret    

c0100204 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100204:	55                   	push   %ebp
c0100205:	89 e5                	mov    %esp,%ebp
c0100207:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010020a:	e8 2b ff ff ff       	call   c010013a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c010020f:	c7 04 24 68 5f 10 c0 	movl   $0xc0105f68,(%esp)
c0100216:	e8 77 00 00 00       	call   c0100292 <cprintf>
    lab1_switch_to_user();
c010021b:	e8 d8 ff ff ff       	call   c01001f8 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100220:	e8 15 ff ff ff       	call   c010013a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100225:	c7 04 24 88 5f 10 c0 	movl   $0xc0105f88,(%esp)
c010022c:	e8 61 00 00 00       	call   c0100292 <cprintf>
    lab1_switch_to_kernel();
c0100231:	e8 c8 ff ff ff       	call   c01001fe <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100236:	e8 ff fe ff ff       	call   c010013a <lab1_print_cur_status>
}
c010023b:	90                   	nop
c010023c:	c9                   	leave  
c010023d:	c3                   	ret    

c010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010023e:	55                   	push   %ebp
c010023f:	89 e5                	mov    %esp,%ebp
c0100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 04 24             	mov    %eax,(%esp)
c010024a:	e8 ab 13 00 00       	call   c01015fa <cons_putc>
    (*cnt) ++;
c010024f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100252:	8b 00                	mov    (%eax),%eax
c0100254:	8d 50 01             	lea    0x1(%eax),%edx
c0100257:	8b 45 0c             	mov    0xc(%ebp),%eax
c010025a:	89 10                	mov    %edx,(%eax)
}
c010025c:	90                   	nop
c010025d:	c9                   	leave  
c010025e:	c3                   	ret    

c010025f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010025f:	55                   	push   %ebp
c0100260:	89 e5                	mov    %esp,%ebp
c0100262:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c010026c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010026f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100273:	8b 45 08             	mov    0x8(%ebp),%eax
c0100276:	89 44 24 08          	mov    %eax,0x8(%esp)
c010027a:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010027d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100281:	c7 04 24 3e 02 10 c0 	movl   $0xc010023e,(%esp)
c0100288:	e8 c8 57 00 00       	call   c0105a55 <vprintfmt>
    return cnt;
c010028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100290:	c9                   	leave  
c0100291:	c3                   	ret    

c0100292 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100292:	55                   	push   %ebp
c0100293:	89 e5                	mov    %esp,%ebp
c0100295:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100298:	8d 45 0c             	lea    0xc(%ebp),%eax
c010029b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
c010029e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01002a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01002a8:	89 04 24             	mov    %eax,(%esp)
c01002ab:	e8 af ff ff ff       	call   c010025f <vcprintf>
c01002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c01002b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01002b6:	c9                   	leave  
c01002b7:	c3                   	ret    

c01002b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c01002b8:	55                   	push   %ebp
c01002b9:	89 e5                	mov    %esp,%ebp
c01002bb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002be:	8b 45 08             	mov    0x8(%ebp),%eax
c01002c1:	89 04 24             	mov    %eax,(%esp)
c01002c4:	e8 31 13 00 00       	call   c01015fa <cons_putc>
}
c01002c9:	90                   	nop
c01002ca:	c9                   	leave  
c01002cb:	c3                   	ret    

c01002cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c01002cc:	55                   	push   %ebp
c01002cd:	89 e5                	mov    %esp,%ebp
c01002cf:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01002d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01002d9:	eb 13                	jmp    c01002ee <cputs+0x22>
        cputch(c, &cnt);
c01002db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01002df:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01002e2:	89 54 24 04          	mov    %edx,0x4(%esp)
c01002e6:	89 04 24             	mov    %eax,(%esp)
c01002e9:	e8 50 ff ff ff       	call   c010023e <cputch>
    while ((c = *str ++) != '\0') {
c01002ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01002f1:	8d 50 01             	lea    0x1(%eax),%edx
c01002f4:	89 55 08             	mov    %edx,0x8(%ebp)
c01002f7:	0f b6 00             	movzbl (%eax),%eax
c01002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01002fd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c0100301:	75 d8                	jne    c01002db <cputs+0xf>
    }
    cputch('\n', &cnt);
c0100303:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100306:	89 44 24 04          	mov    %eax,0x4(%esp)
c010030a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c0100311:	e8 28 ff ff ff       	call   c010023e <cputch>
    return cnt;
c0100316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0100319:	c9                   	leave  
c010031a:	c3                   	ret    

c010031b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c010031b:	55                   	push   %ebp
c010031c:	89 e5                	mov    %esp,%ebp
c010031e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c0100321:	e8 11 13 00 00       	call   c0101637 <cons_getc>
c0100326:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010032d:	74 f2                	je     c0100321 <getchar+0x6>
        /* do nothing */;
    return c;
c010032f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100332:	c9                   	leave  
c0100333:	c3                   	ret    

c0100334 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100334:	55                   	push   %ebp
c0100335:	89 e5                	mov    %esp,%ebp
c0100337:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010033a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010033e:	74 13                	je     c0100353 <readline+0x1f>
        cprintf("%s", prompt);
c0100340:	8b 45 08             	mov    0x8(%ebp),%eax
c0100343:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100347:	c7 04 24 a7 5f 10 c0 	movl   $0xc0105fa7,(%esp)
c010034e:	e8 3f ff ff ff       	call   c0100292 <cprintf>
    }
    int i = 0, c;
c0100353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
c010035a:	e8 bc ff ff ff       	call   c010031b <getchar>
c010035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100366:	79 07                	jns    c010036f <readline+0x3b>
            return NULL;
c0100368:	b8 00 00 00 00       	mov    $0x0,%eax
c010036d:	eb 78                	jmp    c01003e7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010036f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100373:	7e 28                	jle    c010039d <readline+0x69>
c0100375:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010037c:	7f 1f                	jg     c010039d <readline+0x69>
            cputchar(c);
c010037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100381:	89 04 24             	mov    %eax,(%esp)
c0100384:	e8 2f ff ff ff       	call   c01002b8 <cputchar>
            buf[i ++] = c;
c0100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010038c:	8d 50 01             	lea    0x1(%eax),%edx
c010038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100395:	88 90 20 a0 11 c0    	mov    %dl,-0x3fee5fe0(%eax)
c010039b:	eb 45                	jmp    c01003e2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
c010039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01003a1:	75 16                	jne    c01003b9 <readline+0x85>
c01003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003a7:	7e 10                	jle    c01003b9 <readline+0x85>
            cputchar(c);
c01003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003ac:	89 04 24             	mov    %eax,(%esp)
c01003af:	e8 04 ff ff ff       	call   c01002b8 <cputchar>
            i --;
c01003b4:	ff 4d f4             	decl   -0xc(%ebp)
c01003b7:	eb 29                	jmp    c01003e2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
c01003b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01003bd:	74 06                	je     c01003c5 <readline+0x91>
c01003bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01003c3:	75 95                	jne    c010035a <readline+0x26>
            cputchar(c);
c01003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01003c8:	89 04 24             	mov    %eax,(%esp)
c01003cb:	e8 e8 fe ff ff       	call   c01002b8 <cputchar>
            buf[i] = '\0';
c01003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01003d3:	05 20 a0 11 c0       	add    $0xc011a020,%eax
c01003d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01003db:	b8 20 a0 11 c0       	mov    $0xc011a020,%eax
c01003e0:	eb 05                	jmp    c01003e7 <readline+0xb3>
        c = getchar();
c01003e2:	e9 73 ff ff ff       	jmp    c010035a <readline+0x26>
        }
    }
}
c01003e7:	c9                   	leave  
c01003e8:	c3                   	ret    

c01003e9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c01003e9:	55                   	push   %ebp
c01003ea:	89 e5                	mov    %esp,%ebp
c01003ec:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c01003ef:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
c01003f4:	85 c0                	test   %eax,%eax
c01003f6:	75 5b                	jne    c0100453 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
c01003f8:	c7 05 20 a4 11 c0 01 	movl   $0x1,0xc011a420
c01003ff:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100402:	8d 45 14             	lea    0x14(%ebp),%eax
c0100405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100408:	8b 45 0c             	mov    0xc(%ebp),%eax
c010040b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010040f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100412:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100416:	c7 04 24 aa 5f 10 c0 	movl   $0xc0105faa,(%esp)
c010041d:	e8 70 fe ff ff       	call   c0100292 <cprintf>
    vcprintf(fmt, ap);
c0100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100425:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100429:	8b 45 10             	mov    0x10(%ebp),%eax
c010042c:	89 04 24             	mov    %eax,(%esp)
c010042f:	e8 2b fe ff ff       	call   c010025f <vcprintf>
    cprintf("\n");
c0100434:	c7 04 24 c6 5f 10 c0 	movl   $0xc0105fc6,(%esp)
c010043b:	e8 52 fe ff ff       	call   c0100292 <cprintf>
    
    cprintf("stack trackback:\n");
c0100440:	c7 04 24 c8 5f 10 c0 	movl   $0xc0105fc8,(%esp)
c0100447:	e8 46 fe ff ff       	call   c0100292 <cprintf>
    print_stackframe();
c010044c:	e8 32 06 00 00       	call   c0100a83 <print_stackframe>
c0100451:	eb 01                	jmp    c0100454 <__panic+0x6b>
        goto panic_dead;
c0100453:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
c0100454:	e8 1a 14 00 00       	call   c0101873 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100460:	e8 2c 08 00 00       	call   c0100c91 <kmonitor>
c0100465:	eb f2                	jmp    c0100459 <__panic+0x70>

c0100467 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100467:	55                   	push   %ebp
c0100468:	89 e5                	mov    %esp,%ebp
c010046a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c010046d:	8d 45 14             	lea    0x14(%ebp),%eax
c0100470:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100473:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100476:	89 44 24 08          	mov    %eax,0x8(%esp)
c010047a:	8b 45 08             	mov    0x8(%ebp),%eax
c010047d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100481:	c7 04 24 da 5f 10 c0 	movl   $0xc0105fda,(%esp)
c0100488:	e8 05 fe ff ff       	call   c0100292 <cprintf>
    vcprintf(fmt, ap);
c010048d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100490:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100494:	8b 45 10             	mov    0x10(%ebp),%eax
c0100497:	89 04 24             	mov    %eax,(%esp)
c010049a:	e8 c0 fd ff ff       	call   c010025f <vcprintf>
    cprintf("\n");
c010049f:	c7 04 24 c6 5f 10 c0 	movl   $0xc0105fc6,(%esp)
c01004a6:	e8 e7 fd ff ff       	call   c0100292 <cprintf>
    va_end(ap);
}
c01004ab:	90                   	nop
c01004ac:	c9                   	leave  
c01004ad:	c3                   	ret    

c01004ae <is_kernel_panic>:

bool
is_kernel_panic(void) {
c01004ae:	55                   	push   %ebp
c01004af:	89 e5                	mov    %esp,%ebp
    return is_panic;
c01004b1:	a1 20 a4 11 c0       	mov    0xc011a420,%eax
}
c01004b6:	5d                   	pop    %ebp
c01004b7:	c3                   	ret    

c01004b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01004b8:	55                   	push   %ebp
c01004b9:	89 e5                	mov    %esp,%ebp
c01004bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01004be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c1:	8b 00                	mov    (%eax),%eax
c01004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	8b 00                	mov    (%eax),%eax
c01004cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c01004d5:	e9 ca 00 00 00       	jmp    c01005a4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
c01004da:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01004dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01004e0:	01 d0                	add    %edx,%eax
c01004e2:	89 c2                	mov    %eax,%edx
c01004e4:	c1 ea 1f             	shr    $0x1f,%edx
c01004e7:	01 d0                	add    %edx,%eax
c01004e9:	d1 f8                	sar    %eax
c01004eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01004ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c01004f4:	eb 03                	jmp    c01004f9 <stab_binsearch+0x41>
            m --;
c01004f6:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
c01004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c01004ff:	7c 1f                	jl     c0100520 <stab_binsearch+0x68>
c0100501:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100504:	89 d0                	mov    %edx,%eax
c0100506:	01 c0                	add    %eax,%eax
c0100508:	01 d0                	add    %edx,%eax
c010050a:	c1 e0 02             	shl    $0x2,%eax
c010050d:	89 c2                	mov    %eax,%edx
c010050f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100512:	01 d0                	add    %edx,%eax
c0100514:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100518:	0f b6 c0             	movzbl %al,%eax
c010051b:	39 45 14             	cmp    %eax,0x14(%ebp)
c010051e:	75 d6                	jne    c01004f6 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
c0100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100526:	7d 09                	jge    c0100531 <stab_binsearch+0x79>
            l = true_m + 1;
c0100528:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010052b:	40                   	inc    %eax
c010052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010052f:	eb 73                	jmp    c01005a4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
c0100531:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100538:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010053b:	89 d0                	mov    %edx,%eax
c010053d:	01 c0                	add    %eax,%eax
c010053f:	01 d0                	add    %edx,%eax
c0100541:	c1 e0 02             	shl    $0x2,%eax
c0100544:	89 c2                	mov    %eax,%edx
c0100546:	8b 45 08             	mov    0x8(%ebp),%eax
c0100549:	01 d0                	add    %edx,%eax
c010054b:	8b 40 08             	mov    0x8(%eax),%eax
c010054e:	39 45 18             	cmp    %eax,0x18(%ebp)
c0100551:	76 11                	jbe    c0100564 <stab_binsearch+0xac>
            *region_left = m;
c0100553:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100556:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100559:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010055b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010055e:	40                   	inc    %eax
c010055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100562:	eb 40                	jmp    c01005a4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
c0100564:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100567:	89 d0                	mov    %edx,%eax
c0100569:	01 c0                	add    %eax,%eax
c010056b:	01 d0                	add    %edx,%eax
c010056d:	c1 e0 02             	shl    $0x2,%eax
c0100570:	89 c2                	mov    %eax,%edx
c0100572:	8b 45 08             	mov    0x8(%ebp),%eax
c0100575:	01 d0                	add    %edx,%eax
c0100577:	8b 40 08             	mov    0x8(%eax),%eax
c010057a:	39 45 18             	cmp    %eax,0x18(%ebp)
c010057d:	73 14                	jae    c0100593 <stab_binsearch+0xdb>
            *region_right = m - 1;
c010057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100582:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100585:	8b 45 10             	mov    0x10(%ebp),%eax
c0100588:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c010058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010058d:	48                   	dec    %eax
c010058e:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100591:	eb 11                	jmp    c01005a4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c0100593:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100596:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100599:	89 10                	mov    %edx,(%eax)
            l = m;
c010059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010059e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01005a1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
c01005a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01005a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01005aa:	0f 8e 2a ff ff ff    	jle    c01004da <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
c01005b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01005b4:	75 0f                	jne    c01005c5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
c01005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005b9:	8b 00                	mov    (%eax),%eax
c01005bb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01005be:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
c01005c3:	eb 3e                	jmp    c0100603 <stab_binsearch+0x14b>
        l = *region_right;
c01005c5:	8b 45 10             	mov    0x10(%ebp),%eax
c01005c8:	8b 00                	mov    (%eax),%eax
c01005ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c01005cd:	eb 03                	jmp    c01005d2 <stab_binsearch+0x11a>
c01005cf:	ff 4d fc             	decl   -0x4(%ebp)
c01005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005d5:	8b 00                	mov    (%eax),%eax
c01005d7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
c01005da:	7e 1f                	jle    c01005fb <stab_binsearch+0x143>
c01005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
c01005df:	89 d0                	mov    %edx,%eax
c01005e1:	01 c0                	add    %eax,%eax
c01005e3:	01 d0                	add    %edx,%eax
c01005e5:	c1 e0 02             	shl    $0x2,%eax
c01005e8:	89 c2                	mov    %eax,%edx
c01005ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ed:	01 d0                	add    %edx,%eax
c01005ef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01005f3:	0f b6 c0             	movzbl %al,%eax
c01005f6:	39 45 14             	cmp    %eax,0x14(%ebp)
c01005f9:	75 d4                	jne    c01005cf <stab_binsearch+0x117>
        *region_left = l;
c01005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
c01005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100601:	89 10                	mov    %edx,(%eax)
}
c0100603:	90                   	nop
c0100604:	c9                   	leave  
c0100605:	c3                   	ret    

c0100606 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100606:	55                   	push   %ebp
c0100607:	89 e5                	mov    %esp,%ebp
c0100609:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010060c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010060f:	c7 00 f8 5f 10 c0    	movl   $0xc0105ff8,(%eax)
    info->eip_line = 0;
c0100615:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c010061f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100622:	c7 40 08 f8 5f 10 c0 	movl   $0xc0105ff8,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100629:	8b 45 0c             	mov    0xc(%ebp),%eax
c010062c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100633:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100636:	8b 55 08             	mov    0x8(%ebp),%edx
c0100639:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010063c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010063f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100646:	c7 45 f4 78 72 10 c0 	movl   $0xc0107278,-0xc(%ebp)
    stab_end = __STAB_END__;
c010064d:	c7 45 f0 14 24 11 c0 	movl   $0xc0112414,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100654:	c7 45 ec 15 24 11 c0 	movl   $0xc0112415,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010065b:	c7 45 e8 56 4f 11 c0 	movl   $0xc0114f56,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100662:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100668:	76 0b                	jbe    c0100675 <debuginfo_eip+0x6f>
c010066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010066d:	48                   	dec    %eax
c010066e:	0f b6 00             	movzbl (%eax),%eax
c0100671:	84 c0                	test   %al,%al
c0100673:	74 0a                	je     c010067f <debuginfo_eip+0x79>
        return -1;
c0100675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010067a:	e9 b7 02 00 00       	jmp    c0100936 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c010067f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0100686:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010068c:	29 c2                	sub    %eax,%edx
c010068e:	89 d0                	mov    %edx,%eax
c0100690:	c1 f8 02             	sar    $0x2,%eax
c0100693:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c0100699:	48                   	dec    %eax
c010069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c010069d:	8b 45 08             	mov    0x8(%ebp),%eax
c01006a0:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006a4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006ab:	00 
c01006ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01006af:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01006b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006bd:	89 04 24             	mov    %eax,(%esp)
c01006c0:	e8 f3 fd ff ff       	call   c01004b8 <stab_binsearch>
    if (lfile == 0)
c01006c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c8:	85 c0                	test   %eax,%eax
c01006ca:	75 0a                	jne    c01006d6 <debuginfo_eip+0xd0>
        return -1;
c01006cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006d1:	e9 60 02 00 00       	jmp    c0100936 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c01006e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006e9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c01006f0:	00 
c01006f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100702:	89 04 24             	mov    %eax,(%esp)
c0100705:	e8 ae fd ff ff       	call   c01004b8 <stab_binsearch>

    if (lfun <= rfun) {
c010070a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010070d:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100710:	39 c2                	cmp    %eax,%edx
c0100712:	7f 7c                	jg     c0100790 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100714:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100717:	89 c2                	mov    %eax,%edx
c0100719:	89 d0                	mov    %edx,%eax
c010071b:	01 c0                	add    %eax,%eax
c010071d:	01 d0                	add    %edx,%eax
c010071f:	c1 e0 02             	shl    $0x2,%eax
c0100722:	89 c2                	mov    %eax,%edx
c0100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100727:	01 d0                	add    %edx,%eax
c0100729:	8b 00                	mov    (%eax),%eax
c010072b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010072e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0100731:	29 d1                	sub    %edx,%ecx
c0100733:	89 ca                	mov    %ecx,%edx
c0100735:	39 d0                	cmp    %edx,%eax
c0100737:	73 22                	jae    c010075b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100739:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010073c:	89 c2                	mov    %eax,%edx
c010073e:	89 d0                	mov    %edx,%eax
c0100740:	01 c0                	add    %eax,%eax
c0100742:	01 d0                	add    %edx,%eax
c0100744:	c1 e0 02             	shl    $0x2,%eax
c0100747:	89 c2                	mov    %eax,%edx
c0100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074c:	01 d0                	add    %edx,%eax
c010074e:	8b 10                	mov    (%eax),%edx
c0100750:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100753:	01 c2                	add    %eax,%edx
c0100755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100758:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010075b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010075e:	89 c2                	mov    %eax,%edx
c0100760:	89 d0                	mov    %edx,%eax
c0100762:	01 c0                	add    %eax,%eax
c0100764:	01 d0                	add    %edx,%eax
c0100766:	c1 e0 02             	shl    $0x2,%eax
c0100769:	89 c2                	mov    %eax,%edx
c010076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010076e:	01 d0                	add    %edx,%eax
c0100770:	8b 50 08             	mov    0x8(%eax),%edx
c0100773:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100776:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c0100779:	8b 45 0c             	mov    0xc(%ebp),%eax
c010077c:	8b 40 10             	mov    0x10(%eax),%eax
c010077f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c0100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c0100788:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010078b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010078e:	eb 15                	jmp    c01007a5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c0100790:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100793:	8b 55 08             	mov    0x8(%ebp),%edx
c0100796:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c0100799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c010079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007a8:	8b 40 08             	mov    0x8(%eax),%eax
c01007ab:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007b2:	00 
c01007b3:	89 04 24             	mov    %eax,(%esp)
c01007b6:	e8 c3 4d 00 00       	call   c010557e <strfind>
c01007bb:	89 c2                	mov    %eax,%edx
c01007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c0:	8b 40 08             	mov    0x8(%eax),%eax
c01007c3:	29 c2                	sub    %eax,%edx
c01007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007c8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01007cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01007ce:	89 44 24 10          	mov    %eax,0x10(%esp)
c01007d2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c01007d9:	00 
c01007da:	8d 45 d0             	lea    -0x30(%ebp),%eax
c01007dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01007e1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c01007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01007eb:	89 04 24             	mov    %eax,(%esp)
c01007ee:	e8 c5 fc ff ff       	call   c01004b8 <stab_binsearch>
    if (lline <= rline) {
c01007f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007f9:	39 c2                	cmp    %eax,%edx
c01007fb:	7f 23                	jg     c0100820 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
c01007fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100800:	89 c2                	mov    %eax,%edx
c0100802:	89 d0                	mov    %edx,%eax
c0100804:	01 c0                	add    %eax,%eax
c0100806:	01 d0                	add    %edx,%eax
c0100808:	c1 e0 02             	shl    $0x2,%eax
c010080b:	89 c2                	mov    %eax,%edx
c010080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100810:	01 d0                	add    %edx,%eax
c0100812:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100816:	89 c2                	mov    %eax,%edx
c0100818:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010081e:	eb 11                	jmp    c0100831 <debuginfo_eip+0x22b>
        return -1;
c0100820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100825:	e9 0c 01 00 00       	jmp    c0100936 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010082d:	48                   	dec    %eax
c010082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
c0100831:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100837:	39 c2                	cmp    %eax,%edx
c0100839:	7c 56                	jl     c0100891 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
c010083b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083e:	89 c2                	mov    %eax,%edx
c0100840:	89 d0                	mov    %edx,%eax
c0100842:	01 c0                	add    %eax,%eax
c0100844:	01 d0                	add    %edx,%eax
c0100846:	c1 e0 02             	shl    $0x2,%eax
c0100849:	89 c2                	mov    %eax,%edx
c010084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010084e:	01 d0                	add    %edx,%eax
c0100850:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100854:	3c 84                	cmp    $0x84,%al
c0100856:	74 39                	je     c0100891 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010085b:	89 c2                	mov    %eax,%edx
c010085d:	89 d0                	mov    %edx,%eax
c010085f:	01 c0                	add    %eax,%eax
c0100861:	01 d0                	add    %edx,%eax
c0100863:	c1 e0 02             	shl    $0x2,%eax
c0100866:	89 c2                	mov    %eax,%edx
c0100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010086b:	01 d0                	add    %edx,%eax
c010086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100871:	3c 64                	cmp    $0x64,%al
c0100873:	75 b5                	jne    c010082a <debuginfo_eip+0x224>
c0100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100878:	89 c2                	mov    %eax,%edx
c010087a:	89 d0                	mov    %edx,%eax
c010087c:	01 c0                	add    %eax,%eax
c010087e:	01 d0                	add    %edx,%eax
c0100880:	c1 e0 02             	shl    $0x2,%eax
c0100883:	89 c2                	mov    %eax,%edx
c0100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100888:	01 d0                	add    %edx,%eax
c010088a:	8b 40 08             	mov    0x8(%eax),%eax
c010088d:	85 c0                	test   %eax,%eax
c010088f:	74 99                	je     c010082a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c0100891:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100897:	39 c2                	cmp    %eax,%edx
c0100899:	7c 46                	jl     c01008e1 <debuginfo_eip+0x2db>
c010089b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010089e:	89 c2                	mov    %eax,%edx
c01008a0:	89 d0                	mov    %edx,%eax
c01008a2:	01 c0                	add    %eax,%eax
c01008a4:	01 d0                	add    %edx,%eax
c01008a6:	c1 e0 02             	shl    $0x2,%eax
c01008a9:	89 c2                	mov    %eax,%edx
c01008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008ae:	01 d0                	add    %edx,%eax
c01008b0:	8b 00                	mov    (%eax),%eax
c01008b2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01008b8:	29 d1                	sub    %edx,%ecx
c01008ba:	89 ca                	mov    %ecx,%edx
c01008bc:	39 d0                	cmp    %edx,%eax
c01008be:	73 21                	jae    c01008e1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01008c3:	89 c2                	mov    %eax,%edx
c01008c5:	89 d0                	mov    %edx,%eax
c01008c7:	01 c0                	add    %eax,%eax
c01008c9:	01 d0                	add    %edx,%eax
c01008cb:	c1 e0 02             	shl    $0x2,%eax
c01008ce:	89 c2                	mov    %eax,%edx
c01008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01008d3:	01 d0                	add    %edx,%eax
c01008d5:	8b 10                	mov    (%eax),%edx
c01008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008da:	01 c2                	add    %eax,%edx
c01008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008df:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01008e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01008e7:	39 c2                	cmp    %eax,%edx
c01008e9:	7d 46                	jge    c0100931 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
c01008eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008ee:	40                   	inc    %eax
c01008ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c01008f2:	eb 16                	jmp    c010090a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c01008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01008f7:	8b 40 14             	mov    0x14(%eax),%eax
c01008fa:	8d 50 01             	lea    0x1(%eax),%edx
c01008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100900:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
c0100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100906:	40                   	inc    %eax
c0100907:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010090a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010090d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
c0100910:	39 c2                	cmp    %eax,%edx
c0100912:	7d 1d                	jge    c0100931 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100917:	89 c2                	mov    %eax,%edx
c0100919:	89 d0                	mov    %edx,%eax
c010091b:	01 c0                	add    %eax,%eax
c010091d:	01 d0                	add    %edx,%eax
c010091f:	c1 e0 02             	shl    $0x2,%eax
c0100922:	89 c2                	mov    %eax,%edx
c0100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100927:	01 d0                	add    %edx,%eax
c0100929:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010092d:	3c a0                	cmp    $0xa0,%al
c010092f:	74 c3                	je     c01008f4 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
c0100931:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100936:	c9                   	leave  
c0100937:	c3                   	ret    

c0100938 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100938:	55                   	push   %ebp
c0100939:	89 e5                	mov    %esp,%ebp
c010093b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010093e:	c7 04 24 02 60 10 c0 	movl   $0xc0106002,(%esp)
c0100945:	e8 48 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010094a:	c7 44 24 04 36 00 10 	movl   $0xc0100036,0x4(%esp)
c0100951:	c0 
c0100952:	c7 04 24 1b 60 10 c0 	movl   $0xc010601b,(%esp)
c0100959:	e8 34 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010095e:	c7 44 24 04 fc 5e 10 	movl   $0xc0105efc,0x4(%esp)
c0100965:	c0 
c0100966:	c7 04 24 33 60 10 c0 	movl   $0xc0106033,(%esp)
c010096d:	e8 20 f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100972:	c7 44 24 04 00 a0 11 	movl   $0xc011a000,0x4(%esp)
c0100979:	c0 
c010097a:	c7 04 24 4b 60 10 c0 	movl   $0xc010604b,(%esp)
c0100981:	e8 0c f9 ff ff       	call   c0100292 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c0100986:	c7 44 24 04 a8 af 11 	movl   $0xc011afa8,0x4(%esp)
c010098d:	c0 
c010098e:	c7 04 24 63 60 10 c0 	movl   $0xc0106063,(%esp)
c0100995:	e8 f8 f8 ff ff       	call   c0100292 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c010099a:	b8 a8 af 11 c0       	mov    $0xc011afa8,%eax
c010099f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009a5:	b8 36 00 10 c0       	mov    $0xc0100036,%eax
c01009aa:	29 c2                	sub    %eax,%edx
c01009ac:	89 d0                	mov    %edx,%eax
c01009ae:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009b4:	85 c0                	test   %eax,%eax
c01009b6:	0f 48 c2             	cmovs  %edx,%eax
c01009b9:	c1 f8 0a             	sar    $0xa,%eax
c01009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009c0:	c7 04 24 7c 60 10 c0 	movl   $0xc010607c,(%esp)
c01009c7:	e8 c6 f8 ff ff       	call   c0100292 <cprintf>
}
c01009cc:	90                   	nop
c01009cd:	c9                   	leave  
c01009ce:	c3                   	ret    

c01009cf <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01009cf:	55                   	push   %ebp
c01009d0:	89 e5                	mov    %esp,%ebp
c01009d2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01009d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01009db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009df:	8b 45 08             	mov    0x8(%ebp),%eax
c01009e2:	89 04 24             	mov    %eax,(%esp)
c01009e5:	e8 1c fc ff ff       	call   c0100606 <debuginfo_eip>
c01009ea:	85 c0                	test   %eax,%eax
c01009ec:	74 15                	je     c0100a03 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c01009ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f5:	c7 04 24 a6 60 10 c0 	movl   $0xc01060a6,(%esp)
c01009fc:	e8 91 f8 ff ff       	call   c0100292 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a01:	eb 6c                	jmp    c0100a6f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a0a:	eb 1b                	jmp    c0100a27 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
c0100a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a12:	01 d0                	add    %edx,%eax
c0100a14:	0f b6 00             	movzbl (%eax),%eax
c0100a17:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100a20:	01 ca                	add    %ecx,%edx
c0100a22:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a24:	ff 45 f4             	incl   -0xc(%ebp)
c0100a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0100a2d:	7c dd                	jl     c0100a0c <print_debuginfo+0x3d>
        fnname[j] = '\0';
c0100a2f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
c0100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a38:	01 d0                	add    %edx,%eax
c0100a3a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
c0100a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a40:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a43:	89 d1                	mov    %edx,%ecx
c0100a45:	29 c1                	sub    %eax,%ecx
c0100a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a4d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0100a51:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0100a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a63:	c7 04 24 c2 60 10 c0 	movl   $0xc01060c2,(%esp)
c0100a6a:	e8 23 f8 ff ff       	call   c0100292 <cprintf>
}
c0100a6f:	90                   	nop
c0100a70:	c9                   	leave  
c0100a71:	c3                   	ret    

c0100a72 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a72:	55                   	push   %ebp
c0100a73:	89 e5                	mov    %esp,%ebp
c0100a75:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100a78:	8b 45 04             	mov    0x4(%ebp),%eax
c0100a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
c0100a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0100a81:	c9                   	leave  
c0100a82:	c3                   	ret    

c0100a83 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100a83:	55                   	push   %ebp
c0100a84:	89 e5                	mov    %esp,%ebp
c0100a86:	53                   	push   %ebx
c0100a87:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100a8a:	89 e8                	mov    %ebp,%eax
c0100a8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
c0100a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     int i;
     uint32_t ebp = read_ebp();
c0100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
     uint32_t eip = read_eip();
c0100a95:	e8 d8 ff ff ff       	call   c0100a72 <read_eip>
c0100a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     for(i = 0; i < STACKFRAME_DEPTH && ebp != 0; ++i){
c0100a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100aa4:	eb 6c                	jmp    c0100b12 <print_stackframe+0x8f>
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
c0100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aa9:	83 c0 14             	add    $0x14,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
c0100aac:	8b 18                	mov    (%eax),%ebx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
c0100aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ab1:	83 c0 10             	add    $0x10,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
c0100ab4:	8b 08                	mov    (%eax),%ecx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
c0100ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ab9:	83 c0 0c             	add    $0xc,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
c0100abc:	8b 10                	mov    (%eax),%edx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
c0100abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ac1:	83 c0 08             	add    $0x8,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
c0100ac4:	8b 00                	mov    (%eax),%eax
c0100ac6:	89 5c 24 18          	mov    %ebx,0x18(%esp)
c0100aca:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0100ace:	89 54 24 10          	mov    %edx,0x10(%esp)
c0100ad2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100ad9:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100add:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ae4:	c7 04 24 d4 60 10 c0 	movl   $0xc01060d4,(%esp)
c0100aeb:	e8 a2 f7 ff ff       	call   c0100292 <cprintf>
         print_debuginfo((uintptr_t )(eip) - 1);
c0100af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100af3:	48                   	dec    %eax
c0100af4:	89 04 24             	mov    %eax,(%esp)
c0100af7:	e8 d3 fe ff ff       	call   c01009cf <print_debuginfo>
         //ebp = *((uint32_t *)ebp);
         eip = *((uint32_t *)(ebp) + 1);
c0100afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100aff:	83 c0 04             	add    $0x4,%eax
c0100b02:	8b 00                	mov    (%eax),%eax
c0100b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
	 ebp = *((uint32_t *)ebp);
c0100b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b0a:	8b 00                	mov    (%eax),%eax
c0100b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(i = 0; i < STACKFRAME_DEPTH && ebp != 0; ++i){
c0100b0f:	ff 45 f4             	incl   -0xc(%ebp)
c0100b12:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
c0100b16:	7f 06                	jg     c0100b1e <print_stackframe+0x9b>
c0100b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b1c:	75 88                	jne    c0100aa6 <print_stackframe+0x23>
     }

}
c0100b1e:	90                   	nop
c0100b1f:	83 c4 34             	add    $0x34,%esp
c0100b22:	5b                   	pop    %ebx
c0100b23:	5d                   	pop    %ebp
c0100b24:	c3                   	ret    

c0100b25 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b25:	55                   	push   %ebp
c0100b26:	89 e5                	mov    %esp,%ebp
c0100b28:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b32:	eb 0c                	jmp    c0100b40 <parse+0x1b>
            *buf ++ = '\0';
c0100b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b37:	8d 50 01             	lea    0x1(%eax),%edx
c0100b3a:	89 55 08             	mov    %edx,0x8(%ebp)
c0100b3d:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b40:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b43:	0f b6 00             	movzbl (%eax),%eax
c0100b46:	84 c0                	test   %al,%al
c0100b48:	74 1d                	je     c0100b67 <parse+0x42>
c0100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b4d:	0f b6 00             	movzbl (%eax),%eax
c0100b50:	0f be c0             	movsbl %al,%eax
c0100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b57:	c7 04 24 8c 61 10 c0 	movl   $0xc010618c,(%esp)
c0100b5e:	e8 e9 49 00 00       	call   c010554c <strchr>
c0100b63:	85 c0                	test   %eax,%eax
c0100b65:	75 cd                	jne    c0100b34 <parse+0xf>
        }
        if (*buf == '\0') {
c0100b67:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b6a:	0f b6 00             	movzbl (%eax),%eax
c0100b6d:	84 c0                	test   %al,%al
c0100b6f:	74 65                	je     c0100bd6 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100b71:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100b75:	75 14                	jne    c0100b8b <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100b77:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100b7e:	00 
c0100b7f:	c7 04 24 91 61 10 c0 	movl   $0xc0106191,(%esp)
c0100b86:	e8 07 f7 ff ff       	call   c0100292 <cprintf>
        }
        argv[argc ++] = buf;
c0100b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b8e:	8d 50 01             	lea    0x1(%eax),%edx
c0100b91:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0100b94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0100b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b9e:	01 c2                	add    %eax,%edx
c0100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ba3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ba5:	eb 03                	jmp    c0100baa <parse+0x85>
            buf ++;
c0100ba7:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100baa:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bad:	0f b6 00             	movzbl (%eax),%eax
c0100bb0:	84 c0                	test   %al,%al
c0100bb2:	74 8c                	je     c0100b40 <parse+0x1b>
c0100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bb7:	0f b6 00             	movzbl (%eax),%eax
c0100bba:	0f be c0             	movsbl %al,%eax
c0100bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc1:	c7 04 24 8c 61 10 c0 	movl   $0xc010618c,(%esp)
c0100bc8:	e8 7f 49 00 00       	call   c010554c <strchr>
c0100bcd:	85 c0                	test   %eax,%eax
c0100bcf:	74 d6                	je     c0100ba7 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100bd1:	e9 6a ff ff ff       	jmp    c0100b40 <parse+0x1b>
            break;
c0100bd6:	90                   	nop
        }
    }
    return argc;
c0100bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100bda:	c9                   	leave  
c0100bdb:	c3                   	ret    

c0100bdc <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100bdc:	55                   	push   %ebp
c0100bdd:	89 e5                	mov    %esp,%ebp
c0100bdf:	53                   	push   %ebx
c0100be0:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100be3:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bea:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bed:	89 04 24             	mov    %eax,(%esp)
c0100bf0:	e8 30 ff ff ff       	call   c0100b25 <parse>
c0100bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100bfc:	75 0a                	jne    c0100c08 <runcmd+0x2c>
        return 0;
c0100bfe:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c03:	e9 83 00 00 00       	jmp    c0100c8b <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c0f:	eb 5a                	jmp    c0100c6b <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c11:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c17:	89 d0                	mov    %edx,%eax
c0100c19:	01 c0                	add    %eax,%eax
c0100c1b:	01 d0                	add    %edx,%eax
c0100c1d:	c1 e0 02             	shl    $0x2,%eax
c0100c20:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100c25:	8b 00                	mov    (%eax),%eax
c0100c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c2b:	89 04 24             	mov    %eax,(%esp)
c0100c2e:	e8 7c 48 00 00       	call   c01054af <strcmp>
c0100c33:	85 c0                	test   %eax,%eax
c0100c35:	75 31                	jne    c0100c68 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c3a:	89 d0                	mov    %edx,%eax
c0100c3c:	01 c0                	add    %eax,%eax
c0100c3e:	01 d0                	add    %edx,%eax
c0100c40:	c1 e0 02             	shl    $0x2,%eax
c0100c43:	05 08 70 11 c0       	add    $0xc0117008,%eax
c0100c48:	8b 10                	mov    (%eax),%edx
c0100c4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c4d:	83 c0 04             	add    $0x4,%eax
c0100c50:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0100c53:	8d 59 ff             	lea    -0x1(%ecx),%ebx
c0100c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c0100c59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c61:	89 1c 24             	mov    %ebx,(%esp)
c0100c64:	ff d2                	call   *%edx
c0100c66:	eb 23                	jmp    c0100c8b <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c68:	ff 45 f4             	incl   -0xc(%ebp)
c0100c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c6e:	83 f8 02             	cmp    $0x2,%eax
c0100c71:	76 9e                	jbe    c0100c11 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100c73:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c7a:	c7 04 24 af 61 10 c0 	movl   $0xc01061af,(%esp)
c0100c81:	e8 0c f6 ff ff       	call   c0100292 <cprintf>
    return 0;
c0100c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c8b:	83 c4 64             	add    $0x64,%esp
c0100c8e:	5b                   	pop    %ebx
c0100c8f:	5d                   	pop    %ebp
c0100c90:	c3                   	ret    

c0100c91 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100c91:	55                   	push   %ebp
c0100c92:	89 e5                	mov    %esp,%ebp
c0100c94:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100c97:	c7 04 24 c8 61 10 c0 	movl   $0xc01061c8,(%esp)
c0100c9e:	e8 ef f5 ff ff       	call   c0100292 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100ca3:	c7 04 24 f0 61 10 c0 	movl   $0xc01061f0,(%esp)
c0100caa:	e8 e3 f5 ff ff       	call   c0100292 <cprintf>

    if (tf != NULL) {
c0100caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cb3:	74 0b                	je     c0100cc0 <kmonitor+0x2f>
        print_trapframe(tf);
c0100cb5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cb8:	89 04 24             	mov    %eax,(%esp)
c0100cbb:	e8 35 0d 00 00       	call   c01019f5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100cc0:	c7 04 24 15 62 10 c0 	movl   $0xc0106215,(%esp)
c0100cc7:	e8 68 f6 ff ff       	call   c0100334 <readline>
c0100ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100cd3:	74 eb                	je     c0100cc0 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
c0100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cdf:	89 04 24             	mov    %eax,(%esp)
c0100ce2:	e8 f5 fe ff ff       	call   c0100bdc <runcmd>
c0100ce7:	85 c0                	test   %eax,%eax
c0100ce9:	78 02                	js     c0100ced <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
c0100ceb:	eb d3                	jmp    c0100cc0 <kmonitor+0x2f>
                break;
c0100ced:	90                   	nop
            }
        }
    }
}
c0100cee:	90                   	nop
c0100cef:	c9                   	leave  
c0100cf0:	c3                   	ret    

c0100cf1 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100cf1:	55                   	push   %ebp
c0100cf2:	89 e5                	mov    %esp,%ebp
c0100cf4:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100cfe:	eb 3d                	jmp    c0100d3d <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d03:	89 d0                	mov    %edx,%eax
c0100d05:	01 c0                	add    %eax,%eax
c0100d07:	01 d0                	add    %edx,%eax
c0100d09:	c1 e0 02             	shl    $0x2,%eax
c0100d0c:	05 04 70 11 c0       	add    $0xc0117004,%eax
c0100d11:	8b 08                	mov    (%eax),%ecx
c0100d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d16:	89 d0                	mov    %edx,%eax
c0100d18:	01 c0                	add    %eax,%eax
c0100d1a:	01 d0                	add    %edx,%eax
c0100d1c:	c1 e0 02             	shl    $0x2,%eax
c0100d1f:	05 00 70 11 c0       	add    $0xc0117000,%eax
c0100d24:	8b 00                	mov    (%eax),%eax
c0100d26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d2e:	c7 04 24 19 62 10 c0 	movl   $0xc0106219,(%esp)
c0100d35:	e8 58 f5 ff ff       	call   c0100292 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d3a:	ff 45 f4             	incl   -0xc(%ebp)
c0100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d40:	83 f8 02             	cmp    $0x2,%eax
c0100d43:	76 bb                	jbe    c0100d00 <mon_help+0xf>
    }
    return 0;
c0100d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d4a:	c9                   	leave  
c0100d4b:	c3                   	ret    

c0100d4c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d4c:	55                   	push   %ebp
c0100d4d:	89 e5                	mov    %esp,%ebp
c0100d4f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d52:	e8 e1 fb ff ff       	call   c0100938 <print_kerninfo>
    return 0;
c0100d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d5c:	c9                   	leave  
c0100d5d:	c3                   	ret    

c0100d5e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100d5e:	55                   	push   %ebp
c0100d5f:	89 e5                	mov    %esp,%ebp
c0100d61:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100d64:	e8 1a fd ff ff       	call   c0100a83 <print_stackframe>
    return 0;
c0100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d6e:	c9                   	leave  
c0100d6f:	c3                   	ret    

c0100d70 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d70:	55                   	push   %ebp
c0100d71:	89 e5                	mov    %esp,%ebp
c0100d73:	83 ec 28             	sub    $0x28,%esp
c0100d76:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
c0100d7c:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100d84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100d88:	ee                   	out    %al,(%dx)
c0100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d8f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d9b:	ee                   	out    %al,(%dx)
c0100d9c:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
c0100da2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
c0100da6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100daa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100dae:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100daf:	c7 05 2c af 11 c0 00 	movl   $0x0,0xc011af2c
c0100db6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db9:	c7 04 24 22 62 10 c0 	movl   $0xc0106222,(%esp)
c0100dc0:	e8 cd f4 ff ff       	call   c0100292 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dcc:	e8 2e 09 00 00       	call   c01016ff <pic_enable>
}
c0100dd1:	90                   	nop
c0100dd2:	c9                   	leave  
c0100dd3:	c3                   	ret    

c0100dd4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd4:	55                   	push   %ebp
c0100dd5:	89 e5                	mov    %esp,%ebp
c0100dd7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dda:	9c                   	pushf  
c0100ddb:	58                   	pop    %eax
c0100ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0100ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100de2:	25 00 02 00 00       	and    $0x200,%eax
c0100de7:	85 c0                	test   %eax,%eax
c0100de9:	74 0c                	je     c0100df7 <__intr_save+0x23>
        intr_disable();
c0100deb:	e8 83 0a 00 00       	call   c0101873 <intr_disable>
        return 1;
c0100df0:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df5:	eb 05                	jmp    c0100dfc <__intr_save+0x28>
    }
    return 0;
c0100df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100dfc:	c9                   	leave  
c0100dfd:	c3                   	ret    

c0100dfe <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dfe:	55                   	push   %ebp
c0100dff:	89 e5                	mov    %esp,%ebp
c0100e01:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e08:	74 05                	je     c0100e0f <__intr_restore+0x11>
        intr_enable();
c0100e0a:	e8 5d 0a 00 00       	call   c010186c <intr_enable>
    }
}
c0100e0f:	90                   	nop
c0100e10:	c9                   	leave  
c0100e11:	c3                   	ret    

c0100e12 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e12:	55                   	push   %ebp
c0100e13:	89 e5                	mov    %esp,%ebp
c0100e15:	83 ec 10             	sub    $0x10,%esp
c0100e18:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100e22:	89 c2                	mov    %eax,%edx
c0100e24:	ec                   	in     (%dx),%al
c0100e25:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100e28:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
c0100e2e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100e32:	89 c2                	mov    %eax,%edx
c0100e34:	ec                   	in     (%dx),%al
c0100e35:	88 45 f5             	mov    %al,-0xb(%ebp)
c0100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
c0100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0100e42:	89 c2                	mov    %eax,%edx
c0100e44:	ec                   	in     (%dx),%al
c0100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
c0100e48:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
c0100e4e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0100e52:	89 c2                	mov    %eax,%edx
c0100e54:	ec                   	in     (%dx),%al
c0100e55:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e58:	90                   	nop
c0100e59:	c9                   	leave  
c0100e5a:	c3                   	ret    

c0100e5b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e5b:	55                   	push   %ebp
c0100e5c:	89 e5                	mov    %esp,%ebp
c0100e5e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e61:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
c0100e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e6b:	0f b7 00             	movzwl (%eax),%eax
c0100e6e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e75:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e7d:	0f b7 00             	movzwl (%eax),%eax
c0100e80:	0f b7 c0             	movzwl %ax,%eax
c0100e83:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
c0100e88:	74 12                	je     c0100e9c <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100e8a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
c0100e91:	66 c7 05 46 a4 11 c0 	movw   $0x3b4,0xc011a446
c0100e98:	b4 03 
c0100e9a:	eb 13                	jmp    c0100eaf <cga_init+0x54>
    } else {
        *cp = was;
c0100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100e9f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100ea3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ea6:	66 c7 05 46 a4 11 c0 	movw   $0x3d4,0xc011a446
c0100ead:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100eaf:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100eb6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100eba:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ebe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ec2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ec6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ec7:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ece:	40                   	inc    %eax
c0100ecf:	0f b7 c0             	movzwl %ax,%eax
c0100ed2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ed6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
c0100eda:	89 c2                	mov    %eax,%edx
c0100edc:	ec                   	in     (%dx),%al
c0100edd:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
c0100ee0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100ee4:	0f b6 c0             	movzbl %al,%eax
c0100ee7:	c1 e0 08             	shl    $0x8,%eax
c0100eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
c0100eed:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ef8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100f00:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f05:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0100f0c:	40                   	inc    %eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f14:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100f18:	89 c2                	mov    %eax,%edx
c0100f1a:	ec                   	in     (%dx),%al
c0100f1b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
c0100f1e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100f22:	0f b6 c0             	movzbl %al,%eax
c0100f25:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0100f2b:	a3 40 a4 11 c0       	mov    %eax,0xc011a440
    crt_pos = pos;
c0100f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100f33:	0f b7 c0             	movzwl %ax,%eax
c0100f36:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
}
c0100f3c:	90                   	nop
c0100f3d:	c9                   	leave  
c0100f3e:	c3                   	ret    

c0100f3f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f3f:	55                   	push   %ebp
c0100f40:	89 e5                	mov    %esp,%ebp
c0100f42:	83 ec 48             	sub    $0x48,%esp
c0100f45:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
c0100f4b:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f4f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0100f53:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0100f57:	ee                   	out    %al,(%dx)
c0100f58:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
c0100f5e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
c0100f62:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0100f66:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0100f6a:	ee                   	out    %al,(%dx)
c0100f6b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
c0100f71:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
c0100f75:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0100f79:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f7d:	ee                   	out    %al,(%dx)
c0100f7e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100f84:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
c0100f88:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0100f8c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0100f90:	ee                   	out    %al,(%dx)
c0100f91:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
c0100f97:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
c0100f9b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f9f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100fa3:	ee                   	out    %al,(%dx)
c0100fa4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
c0100faa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
c0100fae:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fb2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fb6:	ee                   	out    %al,(%dx)
c0100fb7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fbd:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
c0100fc1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100fd0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
c0100fd4:	89 c2                	mov    %eax,%edx
c0100fd6:	ec                   	in     (%dx),%al
c0100fd7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
c0100fda:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0100fde:	3c ff                	cmp    $0xff,%al
c0100fe0:	0f 95 c0             	setne  %al
c0100fe3:	0f b6 c0             	movzbl %al,%eax
c0100fe6:	a3 48 a4 11 c0       	mov    %eax,0xc011a448
c0100feb:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100ff1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0100ff5:	89 c2                	mov    %eax,%edx
c0100ff7:	ec                   	in     (%dx),%al
c0100ff8:	88 45 f1             	mov    %al,-0xf(%ebp)
c0100ffb:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c0101001:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0101005:	89 c2                	mov    %eax,%edx
c0101007:	ec                   	in     (%dx),%al
c0101008:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010100b:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101010:	85 c0                	test   %eax,%eax
c0101012:	74 0c                	je     c0101020 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
c0101014:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010101b:	e8 df 06 00 00       	call   c01016ff <pic_enable>
    }
}
c0101020:	90                   	nop
c0101021:	c9                   	leave  
c0101022:	c3                   	ret    

c0101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101023:	55                   	push   %ebp
c0101024:	89 e5                	mov    %esp,%ebp
c0101026:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101030:	eb 08                	jmp    c010103a <lpt_putc_sub+0x17>
        delay();
c0101032:	e8 db fd ff ff       	call   c0100e12 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101037:	ff 45 fc             	incl   -0x4(%ebp)
c010103a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
c0101040:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c0101044:	89 c2                	mov    %eax,%edx
c0101046:	ec                   	in     (%dx),%al
c0101047:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c010104a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010104e:	84 c0                	test   %al,%al
c0101050:	78 09                	js     c010105b <lpt_putc_sub+0x38>
c0101052:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c0101059:	7e d7                	jle    c0101032 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
c010105b:	8b 45 08             	mov    0x8(%ebp),%eax
c010105e:	0f b6 c0             	movzbl %al,%eax
c0101061:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
c0101067:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010106a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010106e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101072:	ee                   	out    %al,(%dx)
c0101073:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
c0101079:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
c010107d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101081:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101085:	ee                   	out    %al,(%dx)
c0101086:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
c010108c:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
c0101090:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101094:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101098:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101099:	90                   	nop
c010109a:	c9                   	leave  
c010109b:	c3                   	ret    

c010109c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c010109c:	55                   	push   %ebp
c010109d:	89 e5                	mov    %esp,%ebp
c010109f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c01010a2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01010a6:	74 0d                	je     c01010b5 <lpt_putc+0x19>
        lpt_putc_sub(c);
c01010a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01010ab:	89 04 24             	mov    %eax,(%esp)
c01010ae:	e8 70 ff ff ff       	call   c0101023 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
c01010b3:	eb 24                	jmp    c01010d9 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
c01010b5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010bc:	e8 62 ff ff ff       	call   c0101023 <lpt_putc_sub>
        lpt_putc_sub(' ');
c01010c1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01010c8:	e8 56 ff ff ff       	call   c0101023 <lpt_putc_sub>
        lpt_putc_sub('\b');
c01010cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01010d4:	e8 4a ff ff ff       	call   c0101023 <lpt_putc_sub>
}
c01010d9:	90                   	nop
c01010da:	c9                   	leave  
c01010db:	c3                   	ret    

c01010dc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c01010dc:	55                   	push   %ebp
c01010dd:	89 e5                	mov    %esp,%ebp
c01010df:	53                   	push   %ebx
c01010e0:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c01010e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01010e6:	25 00 ff ff ff       	and    $0xffffff00,%eax
c01010eb:	85 c0                	test   %eax,%eax
c01010ed:	75 07                	jne    c01010f6 <cga_putc+0x1a>
        c |= 0x0700;
c01010ef:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c01010f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01010f9:	0f b6 c0             	movzbl %al,%eax
c01010fc:	83 f8 0a             	cmp    $0xa,%eax
c01010ff:	74 55                	je     c0101156 <cga_putc+0x7a>
c0101101:	83 f8 0d             	cmp    $0xd,%eax
c0101104:	74 63                	je     c0101169 <cga_putc+0x8d>
c0101106:	83 f8 08             	cmp    $0x8,%eax
c0101109:	0f 85 94 00 00 00    	jne    c01011a3 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
c010110f:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101116:	85 c0                	test   %eax,%eax
c0101118:	0f 84 af 00 00 00    	je     c01011cd <cga_putc+0xf1>
            crt_pos --;
c010111e:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101125:	48                   	dec    %eax
c0101126:	0f b7 c0             	movzwl %ax,%eax
c0101129:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c010112f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101132:	98                   	cwtl   
c0101133:	25 00 ff ff ff       	and    $0xffffff00,%eax
c0101138:	98                   	cwtl   
c0101139:	83 c8 20             	or     $0x20,%eax
c010113c:	98                   	cwtl   
c010113d:	8b 15 40 a4 11 c0    	mov    0xc011a440,%edx
c0101143:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c010114a:	01 c9                	add    %ecx,%ecx
c010114c:	01 ca                	add    %ecx,%edx
c010114e:	0f b7 c0             	movzwl %ax,%eax
c0101151:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c0101154:	eb 77                	jmp    c01011cd <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
c0101156:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010115d:	83 c0 50             	add    $0x50,%eax
c0101160:	0f b7 c0             	movzwl %ax,%eax
c0101163:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c0101169:	0f b7 1d 44 a4 11 c0 	movzwl 0xc011a444,%ebx
c0101170:	0f b7 0d 44 a4 11 c0 	movzwl 0xc011a444,%ecx
c0101177:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
c010117c:	89 c8                	mov    %ecx,%eax
c010117e:	f7 e2                	mul    %edx
c0101180:	c1 ea 06             	shr    $0x6,%edx
c0101183:	89 d0                	mov    %edx,%eax
c0101185:	c1 e0 02             	shl    $0x2,%eax
c0101188:	01 d0                	add    %edx,%eax
c010118a:	c1 e0 04             	shl    $0x4,%eax
c010118d:	29 c1                	sub    %eax,%ecx
c010118f:	89 c8                	mov    %ecx,%eax
c0101191:	0f b7 c0             	movzwl %ax,%eax
c0101194:	29 c3                	sub    %eax,%ebx
c0101196:	89 d8                	mov    %ebx,%eax
c0101198:	0f b7 c0             	movzwl %ax,%eax
c010119b:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
        break;
c01011a1:	eb 2b                	jmp    c01011ce <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011a3:	8b 0d 40 a4 11 c0    	mov    0xc011a440,%ecx
c01011a9:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011b0:	8d 50 01             	lea    0x1(%eax),%edx
c01011b3:	0f b7 d2             	movzwl %dx,%edx
c01011b6:	66 89 15 44 a4 11 c0 	mov    %dx,0xc011a444
c01011bd:	01 c0                	add    %eax,%eax
c01011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
c01011c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01011c5:	0f b7 c0             	movzwl %ax,%eax
c01011c8:	66 89 02             	mov    %ax,(%edx)
        break;
c01011cb:	eb 01                	jmp    c01011ce <cga_putc+0xf2>
        break;
c01011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c01011ce:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c01011d5:	3d cf 07 00 00       	cmp    $0x7cf,%eax
c01011da:	76 5d                	jbe    c0101239 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c01011dc:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011e1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c01011e7:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c01011ec:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c01011f3:	00 
c01011f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01011f8:	89 04 24             	mov    %eax,(%esp)
c01011fb:	e8 42 45 00 00       	call   c0105742 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101200:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101207:	eb 14                	jmp    c010121d <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
c0101209:	a1 40 a4 11 c0       	mov    0xc011a440,%eax
c010120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101211:	01 d2                	add    %edx,%edx
c0101213:	01 d0                	add    %edx,%eax
c0101215:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010121a:	ff 45 f4             	incl   -0xc(%ebp)
c010121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101224:	7e e3                	jle    c0101209 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
c0101226:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010122d:	83 e8 50             	sub    $0x50,%eax
c0101230:	0f b7 c0             	movzwl %ax,%eax
c0101233:	66 a3 44 a4 11 c0    	mov    %ax,0xc011a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c0101239:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101240:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101244:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
c0101248:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010124c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c0101251:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c0101258:	c1 e8 08             	shr    $0x8,%eax
c010125b:	0f b7 c0             	movzwl %ax,%eax
c010125e:	0f b6 c0             	movzbl %al,%eax
c0101261:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c0101268:	42                   	inc    %edx
c0101269:	0f b7 d2             	movzwl %dx,%edx
c010126c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101270:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101273:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101277:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c010127c:	0f b7 05 46 a4 11 c0 	movzwl 0xc011a446,%eax
c0101283:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101287:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
c010128b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c010128f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101293:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101294:	0f b7 05 44 a4 11 c0 	movzwl 0xc011a444,%eax
c010129b:	0f b6 c0             	movzbl %al,%eax
c010129e:	0f b7 15 46 a4 11 c0 	movzwl 0xc011a446,%edx
c01012a5:	42                   	inc    %edx
c01012a6:	0f b7 d2             	movzwl %dx,%edx
c01012a9:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
c01012ad:	88 45 f1             	mov    %al,-0xf(%ebp)
c01012b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b8:	ee                   	out    %al,(%dx)
}
c01012b9:	90                   	nop
c01012ba:	83 c4 34             	add    $0x34,%esp
c01012bd:	5b                   	pop    %ebx
c01012be:	5d                   	pop    %ebp
c01012bf:	c3                   	ret    

c01012c0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c01012c0:	55                   	push   %ebp
c01012c1:	89 e5                	mov    %esp,%ebp
c01012c3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01012cd:	eb 08                	jmp    c01012d7 <serial_putc_sub+0x17>
        delay();
c01012cf:	e8 3e fb ff ff       	call   c0100e12 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c01012d4:	ff 45 fc             	incl   -0x4(%ebp)
c01012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01012e1:	89 c2                	mov    %eax,%edx
c01012e3:	ec                   	in     (%dx),%al
c01012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01012eb:	0f b6 c0             	movzbl %al,%eax
c01012ee:	83 e0 20             	and    $0x20,%eax
c01012f1:	85 c0                	test   %eax,%eax
c01012f3:	75 09                	jne    c01012fe <serial_putc_sub+0x3e>
c01012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
c01012fc:	7e d1                	jle    c01012cf <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
c01012fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101301:	0f b6 c0             	movzbl %al,%eax
c0101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
c010130a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101315:	ee                   	out    %al,(%dx)
}
c0101316:	90                   	nop
c0101317:	c9                   	leave  
c0101318:	c3                   	ret    

c0101319 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101319:	55                   	push   %ebp
c010131a:	89 e5                	mov    %esp,%ebp
c010131c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010131f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101323:	74 0d                	je     c0101332 <serial_putc+0x19>
        serial_putc_sub(c);
c0101325:	8b 45 08             	mov    0x8(%ebp),%eax
c0101328:	89 04 24             	mov    %eax,(%esp)
c010132b:	e8 90 ff ff ff       	call   c01012c0 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
c0101330:	eb 24                	jmp    c0101356 <serial_putc+0x3d>
        serial_putc_sub('\b');
c0101332:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101339:	e8 82 ff ff ff       	call   c01012c0 <serial_putc_sub>
        serial_putc_sub(' ');
c010133e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101345:	e8 76 ff ff ff       	call   c01012c0 <serial_putc_sub>
        serial_putc_sub('\b');
c010134a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101351:	e8 6a ff ff ff       	call   c01012c0 <serial_putc_sub>
}
c0101356:	90                   	nop
c0101357:	c9                   	leave  
c0101358:	c3                   	ret    

c0101359 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c0101359:	55                   	push   %ebp
c010135a:	89 e5                	mov    %esp,%ebp
c010135c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c010135f:	eb 33                	jmp    c0101394 <cons_intr+0x3b>
        if (c != 0) {
c0101361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101365:	74 2d                	je     c0101394 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
c0101367:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c010136c:	8d 50 01             	lea    0x1(%eax),%edx
c010136f:	89 15 64 a6 11 c0    	mov    %edx,0xc011a664
c0101375:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101378:	88 90 60 a4 11 c0    	mov    %dl,-0x3fee5ba0(%eax)
            if (cons.wpos == CONSBUFSIZE) {
c010137e:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101383:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101388:	75 0a                	jne    c0101394 <cons_intr+0x3b>
                cons.wpos = 0;
c010138a:	c7 05 64 a6 11 c0 00 	movl   $0x0,0xc011a664
c0101391:	00 00 00 
    while ((c = (*proc)()) != -1) {
c0101394:	8b 45 08             	mov    0x8(%ebp),%eax
c0101397:	ff d0                	call   *%eax
c0101399:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010139c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c01013a0:	75 bf                	jne    c0101361 <cons_intr+0x8>
            }
        }
    }
}
c01013a2:	90                   	nop
c01013a3:	c9                   	leave  
c01013a4:	c3                   	ret    

c01013a5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c01013a5:	55                   	push   %ebp
c01013a6:	89 e5                	mov    %esp,%ebp
c01013a8:	83 ec 10             	sub    $0x10,%esp
c01013ab:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
c01013b5:	89 c2                	mov    %eax,%edx
c01013b7:	ec                   	in     (%dx),%al
c01013b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
c01013bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c01013bf:	0f b6 c0             	movzbl %al,%eax
c01013c2:	83 e0 01             	and    $0x1,%eax
c01013c5:	85 c0                	test   %eax,%eax
c01013c7:	75 07                	jne    c01013d0 <serial_proc_data+0x2b>
        return -1;
c01013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01013ce:	eb 2a                	jmp    c01013fa <serial_proc_data+0x55>
c01013d0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01013d6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c01013da:	89 c2                	mov    %eax,%edx
c01013dc:	ec                   	in     (%dx),%al
c01013dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
c01013e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c01013e4:	0f b6 c0             	movzbl %al,%eax
c01013e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
c01013ea:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
c01013ee:	75 07                	jne    c01013f7 <serial_proc_data+0x52>
        c = '\b';
c01013f0:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
c01013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01013fa:	c9                   	leave  
c01013fb:	c3                   	ret    

c01013fc <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c01013fc:	55                   	push   %ebp
c01013fd:	89 e5                	mov    %esp,%ebp
c01013ff:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101402:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c0101407:	85 c0                	test   %eax,%eax
c0101409:	74 0c                	je     c0101417 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010140b:	c7 04 24 a5 13 10 c0 	movl   $0xc01013a5,(%esp)
c0101412:	e8 42 ff ff ff       	call   c0101359 <cons_intr>
    }
}
c0101417:	90                   	nop
c0101418:	c9                   	leave  
c0101419:	c3                   	ret    

c010141a <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c010141a:	55                   	push   %ebp
c010141b:	89 e5                	mov    %esp,%ebp
c010141d:	83 ec 38             	sub    $0x38,%esp
c0101420:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101426:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101429:	89 c2                	mov    %eax,%edx
c010142b:	ec                   	in     (%dx),%al
c010142c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
c010142f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c0101433:	0f b6 c0             	movzbl %al,%eax
c0101436:	83 e0 01             	and    $0x1,%eax
c0101439:	85 c0                	test   %eax,%eax
c010143b:	75 0a                	jne    c0101447 <kbd_proc_data+0x2d>
        return -1;
c010143d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101442:	e9 55 01 00 00       	jmp    c010159c <kbd_proc_data+0x182>
c0101447:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010144d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0101450:	89 c2                	mov    %eax,%edx
c0101452:	ec                   	in     (%dx),%al
c0101453:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
c0101456:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c010145a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c010145d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101461:	75 17                	jne    c010147a <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
c0101463:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101468:	83 c8 40             	or     $0x40,%eax
c010146b:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c0101470:	b8 00 00 00 00       	mov    $0x0,%eax
c0101475:	e9 22 01 00 00       	jmp    c010159c <kbd_proc_data+0x182>
    } else if (data & 0x80) {
c010147a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010147e:	84 c0                	test   %al,%al
c0101480:	79 45                	jns    c01014c7 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101482:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101487:	83 e0 40             	and    $0x40,%eax
c010148a:	85 c0                	test   %eax,%eax
c010148c:	75 08                	jne    c0101496 <kbd_proc_data+0x7c>
c010148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101492:	24 7f                	and    $0x7f,%al
c0101494:	eb 04                	jmp    c010149a <kbd_proc_data+0x80>
c0101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010149a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c010149d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014a1:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014a8:	0c 40                	or     $0x40,%al
c01014aa:	0f b6 c0             	movzbl %al,%eax
c01014ad:	f7 d0                	not    %eax
c01014af:	89 c2                	mov    %eax,%edx
c01014b1:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014b6:	21 d0                	and    %edx,%eax
c01014b8:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
        return 0;
c01014bd:	b8 00 00 00 00       	mov    $0x0,%eax
c01014c2:	e9 d5 00 00 00       	jmp    c010159c <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
c01014c7:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014cc:	83 e0 40             	and    $0x40,%eax
c01014cf:	85 c0                	test   %eax,%eax
c01014d1:	74 11                	je     c01014e4 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c01014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c01014d7:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014dc:	83 e0 bf             	and    $0xffffffbf,%eax
c01014df:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    }

    shift |= shiftcode[data];
c01014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01014e8:	0f b6 80 40 70 11 c0 	movzbl -0x3fee8fc0(%eax),%eax
c01014ef:	0f b6 d0             	movzbl %al,%edx
c01014f2:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c01014f7:	09 d0                	or     %edx,%eax
c01014f9:	a3 68 a6 11 c0       	mov    %eax,0xc011a668
    shift ^= togglecode[data];
c01014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101502:	0f b6 80 40 71 11 c0 	movzbl -0x3fee8ec0(%eax),%eax
c0101509:	0f b6 d0             	movzbl %al,%edx
c010150c:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101511:	31 d0                	xor    %edx,%eax
c0101513:	a3 68 a6 11 c0       	mov    %eax,0xc011a668

    c = charcode[shift & (CTL | SHIFT)][data];
c0101518:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010151d:	83 e0 03             	and    $0x3,%eax
c0101520:	8b 14 85 40 75 11 c0 	mov    -0x3fee8ac0(,%eax,4),%edx
c0101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152b:	01 d0                	add    %edx,%eax
c010152d:	0f b6 00             	movzbl (%eax),%eax
c0101530:	0f b6 c0             	movzbl %al,%eax
c0101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c0101536:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c010153b:	83 e0 08             	and    $0x8,%eax
c010153e:	85 c0                	test   %eax,%eax
c0101540:	74 22                	je     c0101564 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
c0101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c0101546:	7e 0c                	jle    c0101554 <kbd_proc_data+0x13a>
c0101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c010154c:	7f 06                	jg     c0101554 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
c010154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c0101552:	eb 10                	jmp    c0101564 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
c0101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c0101558:	7e 0a                	jle    c0101564 <kbd_proc_data+0x14a>
c010155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c010155e:	7f 04                	jg     c0101564 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
c0101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101564:	a1 68 a6 11 c0       	mov    0xc011a668,%eax
c0101569:	f7 d0                	not    %eax
c010156b:	83 e0 06             	and    $0x6,%eax
c010156e:	85 c0                	test   %eax,%eax
c0101570:	75 27                	jne    c0101599 <kbd_proc_data+0x17f>
c0101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101579:	75 1e                	jne    c0101599 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
c010157b:	c7 04 24 3d 62 10 c0 	movl   $0xc010623d,(%esp)
c0101582:	e8 0b ed ff ff       	call   c0100292 <cprintf>
c0101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c010158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101595:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0101598:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010159c:	c9                   	leave  
c010159d:	c3                   	ret    

c010159e <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010159e:	55                   	push   %ebp
c010159f:	89 e5                	mov    %esp,%ebp
c01015a1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c01015a4:	c7 04 24 1a 14 10 c0 	movl   $0xc010141a,(%esp)
c01015ab:	e8 a9 fd ff ff       	call   c0101359 <cons_intr>
}
c01015b0:	90                   	nop
c01015b1:	c9                   	leave  
c01015b2:	c3                   	ret    

c01015b3 <kbd_init>:

static void
kbd_init(void) {
c01015b3:	55                   	push   %ebp
c01015b4:	89 e5                	mov    %esp,%ebp
c01015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c01015b9:	e8 e0 ff ff ff       	call   c010159e <kbd_intr>
    pic_enable(IRQ_KBD);
c01015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01015c5:	e8 35 01 00 00       	call   c01016ff <pic_enable>
}
c01015ca:	90                   	nop
c01015cb:	c9                   	leave  
c01015cc:	c3                   	ret    

c01015cd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c01015cd:	55                   	push   %ebp
c01015ce:	89 e5                	mov    %esp,%ebp
c01015d0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c01015d3:	e8 83 f8 ff ff       	call   c0100e5b <cga_init>
    serial_init();
c01015d8:	e8 62 f9 ff ff       	call   c0100f3f <serial_init>
    kbd_init();
c01015dd:	e8 d1 ff ff ff       	call   c01015b3 <kbd_init>
    if (!serial_exists) {
c01015e2:	a1 48 a4 11 c0       	mov    0xc011a448,%eax
c01015e7:	85 c0                	test   %eax,%eax
c01015e9:	75 0c                	jne    c01015f7 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c01015eb:	c7 04 24 49 62 10 c0 	movl   $0xc0106249,(%esp)
c01015f2:	e8 9b ec ff ff       	call   c0100292 <cprintf>
    }
}
c01015f7:	90                   	nop
c01015f8:	c9                   	leave  
c01015f9:	c3                   	ret    

c01015fa <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01015fa:	55                   	push   %ebp
c01015fb:	89 e5                	mov    %esp,%ebp
c01015fd:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0101600:	e8 cf f7 ff ff       	call   c0100dd4 <__intr_save>
c0101605:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101608:	8b 45 08             	mov    0x8(%ebp),%eax
c010160b:	89 04 24             	mov    %eax,(%esp)
c010160e:	e8 89 fa ff ff       	call   c010109c <lpt_putc>
        cga_putc(c);
c0101613:	8b 45 08             	mov    0x8(%ebp),%eax
c0101616:	89 04 24             	mov    %eax,(%esp)
c0101619:	e8 be fa ff ff       	call   c01010dc <cga_putc>
        serial_putc(c);
c010161e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101621:	89 04 24             	mov    %eax,(%esp)
c0101624:	e8 f0 fc ff ff       	call   c0101319 <serial_putc>
    }
    local_intr_restore(intr_flag);
c0101629:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010162c:	89 04 24             	mov    %eax,(%esp)
c010162f:	e8 ca f7 ff ff       	call   c0100dfe <__intr_restore>
}
c0101634:	90                   	nop
c0101635:	c9                   	leave  
c0101636:	c3                   	ret    

c0101637 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c0101637:	55                   	push   %ebp
c0101638:	89 e5                	mov    %esp,%ebp
c010163a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c010163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0101644:	e8 8b f7 ff ff       	call   c0100dd4 <__intr_save>
c0101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c010164c:	e8 ab fd ff ff       	call   c01013fc <serial_intr>
        kbd_intr();
c0101651:	e8 48 ff ff ff       	call   c010159e <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c0101656:	8b 15 60 a6 11 c0    	mov    0xc011a660,%edx
c010165c:	a1 64 a6 11 c0       	mov    0xc011a664,%eax
c0101661:	39 c2                	cmp    %eax,%edx
c0101663:	74 31                	je     c0101696 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
c0101665:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c010166a:	8d 50 01             	lea    0x1(%eax),%edx
c010166d:	89 15 60 a6 11 c0    	mov    %edx,0xc011a660
c0101673:	0f b6 80 60 a4 11 c0 	movzbl -0x3fee5ba0(%eax),%eax
c010167a:	0f b6 c0             	movzbl %al,%eax
c010167d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
c0101680:	a1 60 a6 11 c0       	mov    0xc011a660,%eax
c0101685:	3d 00 02 00 00       	cmp    $0x200,%eax
c010168a:	75 0a                	jne    c0101696 <cons_getc+0x5f>
                cons.rpos = 0;
c010168c:	c7 05 60 a6 11 c0 00 	movl   $0x0,0xc011a660
c0101693:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101699:	89 04 24             	mov    %eax,(%esp)
c010169c:	e8 5d f7 ff ff       	call   c0100dfe <__intr_restore>
    return c;
c01016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01016a4:	c9                   	leave  
c01016a5:	c3                   	ret    

c01016a6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01016a6:	55                   	push   %ebp
c01016a7:	89 e5                	mov    %esp,%ebp
c01016a9:	83 ec 14             	sub    $0x14,%esp
c01016ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01016af:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01016b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016b6:	66 a3 50 75 11 c0    	mov    %ax,0xc0117550
    if (did_init) {
c01016bc:	a1 6c a6 11 c0       	mov    0xc011a66c,%eax
c01016c1:	85 c0                	test   %eax,%eax
c01016c3:	74 37                	je     c01016fc <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c01016c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01016c8:	0f b6 c0             	movzbl %al,%eax
c01016cb:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
c01016d1:	88 45 f9             	mov    %al,-0x7(%ebp)
c01016d4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01016d8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01016dc:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c01016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01016e1:	c1 e8 08             	shr    $0x8,%eax
c01016e4:	0f b7 c0             	movzwl %ax,%eax
c01016e7:	0f b6 c0             	movzbl %al,%eax
c01016ea:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
c01016f0:	88 45 fd             	mov    %al,-0x3(%ebp)
c01016f3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01016f7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01016fb:	ee                   	out    %al,(%dx)
    }
}
c01016fc:	90                   	nop
c01016fd:	c9                   	leave  
c01016fe:	c3                   	ret    

c01016ff <pic_enable>:

void
pic_enable(unsigned int irq) {
c01016ff:	55                   	push   %ebp
c0101700:	89 e5                	mov    %esp,%ebp
c0101702:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0101705:	8b 45 08             	mov    0x8(%ebp),%eax
c0101708:	ba 01 00 00 00       	mov    $0x1,%edx
c010170d:	88 c1                	mov    %al,%cl
c010170f:	d3 e2                	shl    %cl,%edx
c0101711:	89 d0                	mov    %edx,%eax
c0101713:	98                   	cwtl   
c0101714:	f7 d0                	not    %eax
c0101716:	0f bf d0             	movswl %ax,%edx
c0101719:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101720:	98                   	cwtl   
c0101721:	21 d0                	and    %edx,%eax
c0101723:	98                   	cwtl   
c0101724:	0f b7 c0             	movzwl %ax,%eax
c0101727:	89 04 24             	mov    %eax,(%esp)
c010172a:	e8 77 ff ff ff       	call   c01016a6 <pic_setmask>
}
c010172f:	90                   	nop
c0101730:	c9                   	leave  
c0101731:	c3                   	ret    

c0101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0101732:	55                   	push   %ebp
c0101733:	89 e5                	mov    %esp,%ebp
c0101735:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0101738:	c7 05 6c a6 11 c0 01 	movl   $0x1,0xc011a66c
c010173f:	00 00 00 
c0101742:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
c0101748:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
c010174c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101750:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101754:	ee                   	out    %al,(%dx)
c0101755:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
c010175b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
c010175f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101763:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101767:	ee                   	out    %al,(%dx)
c0101768:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c010176e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
c0101772:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101776:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010177a:	ee                   	out    %al,(%dx)
c010177b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
c0101781:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
c0101785:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101789:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c010178d:	ee                   	out    %al,(%dx)
c010178e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
c0101794:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
c0101798:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010179c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01017a0:	ee                   	out    %al,(%dx)
c01017a1:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
c01017a7:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
c01017ab:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c01017af:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c01017b3:	ee                   	out    %al,(%dx)
c01017b4:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
c01017ba:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
c01017be:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01017c2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c01017c6:	ee                   	out    %al,(%dx)
c01017c7:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
c01017cd:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
c01017d1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01017d5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01017d9:	ee                   	out    %al,(%dx)
c01017da:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
c01017e0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
c01017e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01017e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01017ec:	ee                   	out    %al,(%dx)
c01017ed:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
c01017f3:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
c01017f7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01017fb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01017ff:	ee                   	out    %al,(%dx)
c0101800:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
c0101806:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
c010180a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010180e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101812:	ee                   	out    %al,(%dx)
c0101813:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101819:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
c010181d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101821:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101825:	ee                   	out    %al,(%dx)
c0101826:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
c010182c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
c0101830:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101834:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101838:	ee                   	out    %al,(%dx)
c0101839:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
c010183f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
c0101843:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101847:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010184c:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101853:	3d ff ff 00 00       	cmp    $0xffff,%eax
c0101858:	74 0f                	je     c0101869 <pic_init+0x137>
        pic_setmask(irq_mask);
c010185a:	0f b7 05 50 75 11 c0 	movzwl 0xc0117550,%eax
c0101861:	89 04 24             	mov    %eax,(%esp)
c0101864:	e8 3d fe ff ff       	call   c01016a6 <pic_setmask>
    }
}
c0101869:	90                   	nop
c010186a:	c9                   	leave  
c010186b:	c3                   	ret    

c010186c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c010186c:	55                   	push   %ebp
c010186d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
c010186f:	fb                   	sti    
    sti();
}
c0101870:	90                   	nop
c0101871:	5d                   	pop    %ebp
c0101872:	c3                   	ret    

c0101873 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101873:	55                   	push   %ebp
c0101874:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
c0101876:	fa                   	cli    
    cli();
}
c0101877:	90                   	nop
c0101878:	5d                   	pop    %ebp
c0101879:	c3                   	ret    

c010187a <print_ticks>:

#define TICK_NUM 100
extern uintptr_t __vectors[];
static int count = 0;

static void print_ticks() {
c010187a:	55                   	push   %ebp
c010187b:	89 e5                	mov    %esp,%ebp
c010187d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c0101880:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101887:	00 
c0101888:	c7 04 24 80 62 10 c0 	movl   $0xc0106280,(%esp)
c010188f:	e8 fe e9 ff ff       	call   c0100292 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c0101894:	c7 04 24 8a 62 10 c0 	movl   $0xc010628a,(%esp)
c010189b:	e8 f2 e9 ff ff       	call   c0100292 <cprintf>
    panic("EOT: kernel seems ok.");
c01018a0:	c7 44 24 08 98 62 10 	movl   $0xc0106298,0x8(%esp)
c01018a7:	c0 
c01018a8:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01018af:	00 
c01018b0:	c7 04 24 ae 62 10 c0 	movl   $0xc01062ae,(%esp)
c01018b7:	e8 2d eb ff ff       	call   c01003e9 <__panic>

c01018bc <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01018bc:	55                   	push   %ebp
c01018bd:	89 e5                	mov    %esp,%ebp
c01018bf:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    int i;
    for(i = 0; i < 256; ++i) {
c01018c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c01018c9:	e9 c4 00 00 00       	jmp    c0101992 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
c01018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018d1:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c01018d8:	0f b7 d0             	movzwl %ax,%edx
c01018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018de:	66 89 14 c5 a0 a6 11 	mov    %dx,-0x3fee5960(,%eax,8)
c01018e5:	c0 
c01018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018e9:	66 c7 04 c5 a2 a6 11 	movw   $0x8,-0x3fee595e(,%eax,8)
c01018f0:	c0 08 00 
c01018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01018f6:	0f b6 14 c5 a4 a6 11 	movzbl -0x3fee595c(,%eax,8),%edx
c01018fd:	c0 
c01018fe:	80 e2 e0             	and    $0xe0,%dl
c0101901:	88 14 c5 a4 a6 11 c0 	mov    %dl,-0x3fee595c(,%eax,8)
c0101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010190b:	0f b6 14 c5 a4 a6 11 	movzbl -0x3fee595c(,%eax,8),%edx
c0101912:	c0 
c0101913:	80 e2 1f             	and    $0x1f,%dl
c0101916:	88 14 c5 a4 a6 11 c0 	mov    %dl,-0x3fee595c(,%eax,8)
c010191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101920:	0f b6 14 c5 a5 a6 11 	movzbl -0x3fee595b(,%eax,8),%edx
c0101927:	c0 
c0101928:	80 e2 f0             	and    $0xf0,%dl
c010192b:	80 ca 0e             	or     $0xe,%dl
c010192e:	88 14 c5 a5 a6 11 c0 	mov    %dl,-0x3fee595b(,%eax,8)
c0101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101938:	0f b6 14 c5 a5 a6 11 	movzbl -0x3fee595b(,%eax,8),%edx
c010193f:	c0 
c0101940:	80 e2 ef             	and    $0xef,%dl
c0101943:	88 14 c5 a5 a6 11 c0 	mov    %dl,-0x3fee595b(,%eax,8)
c010194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010194d:	0f b6 14 c5 a5 a6 11 	movzbl -0x3fee595b(,%eax,8),%edx
c0101954:	c0 
c0101955:	80 e2 9f             	and    $0x9f,%dl
c0101958:	88 14 c5 a5 a6 11 c0 	mov    %dl,-0x3fee595b(,%eax,8)
c010195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101962:	0f b6 14 c5 a5 a6 11 	movzbl -0x3fee595b(,%eax,8),%edx
c0101969:	c0 
c010196a:	80 ca 80             	or     $0x80,%dl
c010196d:	88 14 c5 a5 a6 11 c0 	mov    %dl,-0x3fee595b(,%eax,8)
c0101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101977:	8b 04 85 e0 75 11 c0 	mov    -0x3fee8a20(,%eax,4),%eax
c010197e:	c1 e8 10             	shr    $0x10,%eax
c0101981:	0f b7 d0             	movzwl %ax,%edx
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	66 89 14 c5 a6 a6 11 	mov    %dx,-0x3fee595a(,%eax,8)
c010198e:	c0 
    for(i = 0; i < 256; ++i) {
c010198f:	ff 45 fc             	incl   -0x4(%ebp)
c0101992:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c0101999:	0f 8e 2f ff ff ff    	jle    c01018ce <idt_init+0x12>
c010199f:	c7 45 f8 60 75 11 c0 	movl   $0xc0117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c01019a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01019a9:	0f 01 18             	lidtl  (%eax)
    }
    //set the syscall for user
    //load the idt;
    lidt(&idt_pd);
}
c01019ac:	90                   	nop
c01019ad:	c9                   	leave  
c01019ae:	c3                   	ret    

c01019af <trapname>:

static const char *
trapname(int trapno) {
c01019af:	55                   	push   %ebp
c01019b0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c01019b2:	8b 45 08             	mov    0x8(%ebp),%eax
c01019b5:	83 f8 13             	cmp    $0x13,%eax
c01019b8:	77 0c                	ja     c01019c6 <trapname+0x17>
        return excnames[trapno];
c01019ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01019bd:	8b 04 85 00 66 10 c0 	mov    -0x3fef9a00(,%eax,4),%eax
c01019c4:	eb 18                	jmp    c01019de <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c01019c6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c01019ca:	7e 0d                	jle    c01019d9 <trapname+0x2a>
c01019cc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c01019d0:	7f 07                	jg     c01019d9 <trapname+0x2a>
        return "Hardware Interrupt";
c01019d2:	b8 bf 62 10 c0       	mov    $0xc01062bf,%eax
c01019d7:	eb 05                	jmp    c01019de <trapname+0x2f>
    }
    return "(unknown trap)";
c01019d9:	b8 d2 62 10 c0       	mov    $0xc01062d2,%eax
}
c01019de:	5d                   	pop    %ebp
c01019df:	c3                   	ret    

c01019e0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01019e0:	55                   	push   %ebp
c01019e1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01019e3:	8b 45 08             	mov    0x8(%ebp),%eax
c01019e6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01019ea:	83 f8 08             	cmp    $0x8,%eax
c01019ed:	0f 94 c0             	sete   %al
c01019f0:	0f b6 c0             	movzbl %al,%eax
}
c01019f3:	5d                   	pop    %ebp
c01019f4:	c3                   	ret    

c01019f5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01019f5:	55                   	push   %ebp
c01019f6:	89 e5                	mov    %esp,%ebp
c01019f8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01019fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a02:	c7 04 24 13 63 10 c0 	movl   $0xc0106313,(%esp)
c0101a09:	e8 84 e8 ff ff       	call   c0100292 <cprintf>
    print_regs(&tf->tf_regs);
c0101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a11:	89 04 24             	mov    %eax,(%esp)
c0101a14:	e8 8f 01 00 00       	call   c0101ba8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101a19:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a1c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a24:	c7 04 24 24 63 10 c0 	movl   $0xc0106324,(%esp)
c0101a2b:	e8 62 e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101a30:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a33:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101a37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a3b:	c7 04 24 37 63 10 c0 	movl   $0xc0106337,(%esp)
c0101a42:	e8 4b e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a4a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a52:	c7 04 24 4a 63 10 c0 	movl   $0xc010634a,(%esp)
c0101a59:	e8 34 e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a61:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101a65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a69:	c7 04 24 5d 63 10 c0 	movl   $0xc010635d,(%esp)
c0101a70:	e8 1d e8 ff ff       	call   c0100292 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101a75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a78:	8b 40 30             	mov    0x30(%eax),%eax
c0101a7b:	89 04 24             	mov    %eax,(%esp)
c0101a7e:	e8 2c ff ff ff       	call   c01019af <trapname>
c0101a83:	89 c2                	mov    %eax,%edx
c0101a85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a88:	8b 40 30             	mov    0x30(%eax),%eax
c0101a8b:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a93:	c7 04 24 70 63 10 c0 	movl   $0xc0106370,(%esp)
c0101a9a:	e8 f3 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa2:	8b 40 34             	mov    0x34(%eax),%eax
c0101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aa9:	c7 04 24 82 63 10 c0 	movl   $0xc0106382,(%esp)
c0101ab0:	e8 dd e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ab8:	8b 40 38             	mov    0x38(%eax),%eax
c0101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101abf:	c7 04 24 91 63 10 c0 	movl   $0xc0106391,(%esp)
c0101ac6:	e8 c7 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101acb:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ad6:	c7 04 24 a0 63 10 c0 	movl   $0xc01063a0,(%esp)
c0101add:	e8 b0 e7 ff ff       	call   c0100292 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae5:	8b 40 40             	mov    0x40(%eax),%eax
c0101ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101aec:	c7 04 24 b3 63 10 c0 	movl   $0xc01063b3,(%esp)
c0101af3:	e8 9a e7 ff ff       	call   c0100292 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101af8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101aff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101b06:	eb 3d                	jmp    c0101b45 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101b08:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b0b:	8b 50 40             	mov    0x40(%eax),%edx
c0101b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101b11:	21 d0                	and    %edx,%eax
c0101b13:	85 c0                	test   %eax,%eax
c0101b15:	74 28                	je     c0101b3f <print_trapframe+0x14a>
c0101b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b1a:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b21:	85 c0                	test   %eax,%eax
c0101b23:	74 1a                	je     c0101b3f <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
c0101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b28:	8b 04 85 80 75 11 c0 	mov    -0x3fee8a80(,%eax,4),%eax
c0101b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b33:	c7 04 24 c2 63 10 c0 	movl   $0xc01063c2,(%esp)
c0101b3a:	e8 53 e7 ff ff       	call   c0100292 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101b3f:	ff 45 f4             	incl   -0xc(%ebp)
c0101b42:	d1 65 f0             	shll   -0x10(%ebp)
c0101b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101b48:	83 f8 17             	cmp    $0x17,%eax
c0101b4b:	76 bb                	jbe    c0101b08 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b50:	8b 40 40             	mov    0x40(%eax),%eax
c0101b53:	c1 e8 0c             	shr    $0xc,%eax
c0101b56:	83 e0 03             	and    $0x3,%eax
c0101b59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5d:	c7 04 24 c6 63 10 c0 	movl   $0xc01063c6,(%esp)
c0101b64:	e8 29 e7 ff ff       	call   c0100292 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6c:	89 04 24             	mov    %eax,(%esp)
c0101b6f:	e8 6c fe ff ff       	call   c01019e0 <trap_in_kernel>
c0101b74:	85 c0                	test   %eax,%eax
c0101b76:	75 2d                	jne    c0101ba5 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101b78:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b7b:	8b 40 44             	mov    0x44(%eax),%eax
c0101b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b82:	c7 04 24 cf 63 10 c0 	movl   $0xc01063cf,(%esp)
c0101b89:	e8 04 e7 ff ff       	call   c0100292 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b99:	c7 04 24 de 63 10 c0 	movl   $0xc01063de,(%esp)
c0101ba0:	e8 ed e6 ff ff       	call   c0100292 <cprintf>
    }
}
c0101ba5:	90                   	nop
c0101ba6:	c9                   	leave  
c0101ba7:	c3                   	ret    

c0101ba8 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ba8:	55                   	push   %ebp
c0101ba9:	89 e5                	mov    %esp,%ebp
c0101bab:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bb1:	8b 00                	mov    (%eax),%eax
c0101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb7:	c7 04 24 f1 63 10 c0 	movl   $0xc01063f1,(%esp)
c0101bbe:	e8 cf e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bc6:	8b 40 04             	mov    0x4(%eax),%eax
c0101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bcd:	c7 04 24 00 64 10 c0 	movl   $0xc0106400,(%esp)
c0101bd4:	e8 b9 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdc:	8b 40 08             	mov    0x8(%eax),%eax
c0101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be3:	c7 04 24 0f 64 10 c0 	movl   $0xc010640f,(%esp)
c0101bea:	e8 a3 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101bef:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bf2:	8b 40 0c             	mov    0xc(%eax),%eax
c0101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bf9:	c7 04 24 1e 64 10 c0 	movl   $0xc010641e,(%esp)
c0101c00:	e8 8d e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101c05:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c08:	8b 40 10             	mov    0x10(%eax),%eax
c0101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c0f:	c7 04 24 2d 64 10 c0 	movl   $0xc010642d,(%esp)
c0101c16:	e8 77 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1e:	8b 40 14             	mov    0x14(%eax),%eax
c0101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c25:	c7 04 24 3c 64 10 c0 	movl   $0xc010643c,(%esp)
c0101c2c:	e8 61 e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101c31:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c34:	8b 40 18             	mov    0x18(%eax),%eax
c0101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c3b:	c7 04 24 4b 64 10 c0 	movl   $0xc010644b,(%esp)
c0101c42:	e8 4b e6 ff ff       	call   c0100292 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101c47:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c4a:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c51:	c7 04 24 5a 64 10 c0 	movl   $0xc010645a,(%esp)
c0101c58:	e8 35 e6 ff ff       	call   c0100292 <cprintf>
}
c0101c5d:	90                   	nop
c0101c5e:	c9                   	leave  
c0101c5f:	c3                   	ret    

c0101c60 <trap_dispatch>:
struct trapframe swithk2u;
struct trapframe *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101c60:	55                   	push   %ebp
c0101c61:	89 e5                	mov    %esp,%ebp
c0101c63:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c69:	8b 40 30             	mov    0x30(%eax),%eax
c0101c6c:	83 f8 2f             	cmp    $0x2f,%eax
c0101c6f:	77 21                	ja     c0101c92 <trap_dispatch+0x32>
c0101c71:	83 f8 2e             	cmp    $0x2e,%eax
c0101c74:	0f 83 f1 00 00 00    	jae    c0101d6b <trap_dispatch+0x10b>
c0101c7a:	83 f8 21             	cmp    $0x21,%eax
c0101c7d:	0f 84 8d 00 00 00    	je     c0101d10 <trap_dispatch+0xb0>
c0101c83:	83 f8 24             	cmp    $0x24,%eax
c0101c86:	74 62                	je     c0101cea <trap_dispatch+0x8a>
c0101c88:	83 f8 20             	cmp    $0x20,%eax
c0101c8b:	74 16                	je     c0101ca3 <trap_dispatch+0x43>
c0101c8d:	e9 a4 00 00 00       	jmp    c0101d36 <trap_dispatch+0xd6>
c0101c92:	83 e8 78             	sub    $0x78,%eax
c0101c95:	83 f8 01             	cmp    $0x1,%eax
c0101c98:	0f 87 98 00 00 00    	ja     c0101d36 <trap_dispatch+0xd6>
        break;
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	 
    case T_SWITCH_TOK:
        break;
c0101c9e:	e9 c9 00 00 00       	jmp    c0101d6c <trap_dispatch+0x10c>
        if(count % TICK_NUM == 0) {
c0101ca3:	8b 0d 80 a6 11 c0    	mov    0xc011a680,%ecx
c0101ca9:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
c0101cae:	f7 e9                	imul   %ecx
c0101cb0:	c1 fa 05             	sar    $0x5,%edx
c0101cb3:	89 c8                	mov    %ecx,%eax
c0101cb5:	c1 f8 1f             	sar    $0x1f,%eax
c0101cb8:	29 c2                	sub    %eax,%edx
c0101cba:	89 d0                	mov    %edx,%eax
c0101cbc:	c1 e0 02             	shl    $0x2,%eax
c0101cbf:	01 d0                	add    %edx,%eax
c0101cc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0101cc8:	01 d0                	add    %edx,%eax
c0101cca:	c1 e0 02             	shl    $0x2,%eax
c0101ccd:	29 c1                	sub    %eax,%ecx
c0101ccf:	89 ca                	mov    %ecx,%edx
c0101cd1:	85 d2                	test   %edx,%edx
c0101cd3:	75 05                	jne    c0101cda <trap_dispatch+0x7a>
            print_ticks();
c0101cd5:	e8 a0 fb ff ff       	call   c010187a <print_ticks>
        ++count;
c0101cda:	a1 80 a6 11 c0       	mov    0xc011a680,%eax
c0101cdf:	40                   	inc    %eax
c0101ce0:	a3 80 a6 11 c0       	mov    %eax,0xc011a680
        break;
c0101ce5:	e9 82 00 00 00       	jmp    c0101d6c <trap_dispatch+0x10c>
        c = cons_getc();
c0101cea:	e8 48 f9 ff ff       	call   c0101637 <cons_getc>
c0101cef:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101cf2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101cf6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101cfa:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d02:	c7 04 24 69 64 10 c0 	movl   $0xc0106469,(%esp)
c0101d09:	e8 84 e5 ff ff       	call   c0100292 <cprintf>
        break;
c0101d0e:	eb 5c                	jmp    c0101d6c <trap_dispatch+0x10c>
        c = cons_getc();
c0101d10:	e8 22 f9 ff ff       	call   c0101637 <cons_getc>
c0101d15:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101d18:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101d1c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101d20:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101d24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d28:	c7 04 24 7b 64 10 c0 	movl   $0xc010647b,(%esp)
c0101d2f:	e8 5e e5 ff ff       	call   c0100292 <cprintf>
        break;
c0101d34:	eb 36                	jmp    c0101d6c <trap_dispatch+0x10c>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101d36:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d39:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101d3d:	83 e0 03             	and    $0x3,%eax
c0101d40:	85 c0                	test   %eax,%eax
c0101d42:	75 28                	jne    c0101d6c <trap_dispatch+0x10c>
            print_trapframe(tf);
c0101d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d47:	89 04 24             	mov    %eax,(%esp)
c0101d4a:	e8 a6 fc ff ff       	call   c01019f5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101d4f:	c7 44 24 08 8a 64 10 	movl   $0xc010648a,0x8(%esp)
c0101d56:	c0 
c0101d57:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101d5e:	00 
c0101d5f:	c7 04 24 ae 62 10 c0 	movl   $0xc01062ae,(%esp)
c0101d66:	e8 7e e6 ff ff       	call   c01003e9 <__panic>
        break;
c0101d6b:	90                   	nop
        }
    }
}
c0101d6c:	90                   	nop
c0101d6d:	c9                   	leave  
c0101d6e:	c3                   	ret    

c0101d6f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101d6f:	55                   	push   %ebp
c0101d70:	89 e5                	mov    %esp,%ebp
c0101d72:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101d75:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d78:	89 04 24             	mov    %eax,(%esp)
c0101d7b:	e8 e0 fe ff ff       	call   c0101c60 <trap_dispatch>
}
c0101d80:	90                   	nop
c0101d81:	c9                   	leave  
c0101d82:	c3                   	ret    

c0101d83 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101d83:	6a 00                	push   $0x0
  pushl $0
c0101d85:	6a 00                	push   $0x0
  jmp __alltraps
c0101d87:	e9 69 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101d8c <vector1>:
.globl vector1
vector1:
  pushl $0
c0101d8c:	6a 00                	push   $0x0
  pushl $1
c0101d8e:	6a 01                	push   $0x1
  jmp __alltraps
c0101d90:	e9 60 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101d95 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101d95:	6a 00                	push   $0x0
  pushl $2
c0101d97:	6a 02                	push   $0x2
  jmp __alltraps
c0101d99:	e9 57 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101d9e <vector3>:
.globl vector3
vector3:
  pushl $0
c0101d9e:	6a 00                	push   $0x0
  pushl $3
c0101da0:	6a 03                	push   $0x3
  jmp __alltraps
c0101da2:	e9 4e 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101da7 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101da7:	6a 00                	push   $0x0
  pushl $4
c0101da9:	6a 04                	push   $0x4
  jmp __alltraps
c0101dab:	e9 45 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101db0 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101db0:	6a 00                	push   $0x0
  pushl $5
c0101db2:	6a 05                	push   $0x5
  jmp __alltraps
c0101db4:	e9 3c 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101db9 <vector6>:
.globl vector6
vector6:
  pushl $0
c0101db9:	6a 00                	push   $0x0
  pushl $6
c0101dbb:	6a 06                	push   $0x6
  jmp __alltraps
c0101dbd:	e9 33 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101dc2 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101dc2:	6a 00                	push   $0x0
  pushl $7
c0101dc4:	6a 07                	push   $0x7
  jmp __alltraps
c0101dc6:	e9 2a 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101dcb <vector8>:
.globl vector8
vector8:
  pushl $8
c0101dcb:	6a 08                	push   $0x8
  jmp __alltraps
c0101dcd:	e9 23 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101dd2 <vector9>:
.globl vector9
vector9:
  pushl $0
c0101dd2:	6a 00                	push   $0x0
  pushl $9
c0101dd4:	6a 09                	push   $0x9
  jmp __alltraps
c0101dd6:	e9 1a 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101ddb <vector10>:
.globl vector10
vector10:
  pushl $10
c0101ddb:	6a 0a                	push   $0xa
  jmp __alltraps
c0101ddd:	e9 13 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101de2 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101de2:	6a 0b                	push   $0xb
  jmp __alltraps
c0101de4:	e9 0c 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101de9 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101de9:	6a 0c                	push   $0xc
  jmp __alltraps
c0101deb:	e9 05 0a 00 00       	jmp    c01027f5 <__alltraps>

c0101df0 <vector13>:
.globl vector13
vector13:
  pushl $13
c0101df0:	6a 0d                	push   $0xd
  jmp __alltraps
c0101df2:	e9 fe 09 00 00       	jmp    c01027f5 <__alltraps>

c0101df7 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101df7:	6a 0e                	push   $0xe
  jmp __alltraps
c0101df9:	e9 f7 09 00 00       	jmp    c01027f5 <__alltraps>

c0101dfe <vector15>:
.globl vector15
vector15:
  pushl $0
c0101dfe:	6a 00                	push   $0x0
  pushl $15
c0101e00:	6a 0f                	push   $0xf
  jmp __alltraps
c0101e02:	e9 ee 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e07 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101e07:	6a 00                	push   $0x0
  pushl $16
c0101e09:	6a 10                	push   $0x10
  jmp __alltraps
c0101e0b:	e9 e5 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e10 <vector17>:
.globl vector17
vector17:
  pushl $17
c0101e10:	6a 11                	push   $0x11
  jmp __alltraps
c0101e12:	e9 de 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e17 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101e17:	6a 00                	push   $0x0
  pushl $18
c0101e19:	6a 12                	push   $0x12
  jmp __alltraps
c0101e1b:	e9 d5 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e20 <vector19>:
.globl vector19
vector19:
  pushl $0
c0101e20:	6a 00                	push   $0x0
  pushl $19
c0101e22:	6a 13                	push   $0x13
  jmp __alltraps
c0101e24:	e9 cc 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e29 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101e29:	6a 00                	push   $0x0
  pushl $20
c0101e2b:	6a 14                	push   $0x14
  jmp __alltraps
c0101e2d:	e9 c3 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e32 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101e32:	6a 00                	push   $0x0
  pushl $21
c0101e34:	6a 15                	push   $0x15
  jmp __alltraps
c0101e36:	e9 ba 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e3b <vector22>:
.globl vector22
vector22:
  pushl $0
c0101e3b:	6a 00                	push   $0x0
  pushl $22
c0101e3d:	6a 16                	push   $0x16
  jmp __alltraps
c0101e3f:	e9 b1 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e44 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101e44:	6a 00                	push   $0x0
  pushl $23
c0101e46:	6a 17                	push   $0x17
  jmp __alltraps
c0101e48:	e9 a8 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e4d <vector24>:
.globl vector24
vector24:
  pushl $0
c0101e4d:	6a 00                	push   $0x0
  pushl $24
c0101e4f:	6a 18                	push   $0x18
  jmp __alltraps
c0101e51:	e9 9f 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e56 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101e56:	6a 00                	push   $0x0
  pushl $25
c0101e58:	6a 19                	push   $0x19
  jmp __alltraps
c0101e5a:	e9 96 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e5f <vector26>:
.globl vector26
vector26:
  pushl $0
c0101e5f:	6a 00                	push   $0x0
  pushl $26
c0101e61:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101e63:	e9 8d 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e68 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101e68:	6a 00                	push   $0x0
  pushl $27
c0101e6a:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101e6c:	e9 84 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e71 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101e71:	6a 00                	push   $0x0
  pushl $28
c0101e73:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101e75:	e9 7b 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e7a <vector29>:
.globl vector29
vector29:
  pushl $0
c0101e7a:	6a 00                	push   $0x0
  pushl $29
c0101e7c:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101e7e:	e9 72 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e83 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101e83:	6a 00                	push   $0x0
  pushl $30
c0101e85:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101e87:	e9 69 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e8c <vector31>:
.globl vector31
vector31:
  pushl $0
c0101e8c:	6a 00                	push   $0x0
  pushl $31
c0101e8e:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101e90:	e9 60 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e95 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101e95:	6a 00                	push   $0x0
  pushl $32
c0101e97:	6a 20                	push   $0x20
  jmp __alltraps
c0101e99:	e9 57 09 00 00       	jmp    c01027f5 <__alltraps>

c0101e9e <vector33>:
.globl vector33
vector33:
  pushl $0
c0101e9e:	6a 00                	push   $0x0
  pushl $33
c0101ea0:	6a 21                	push   $0x21
  jmp __alltraps
c0101ea2:	e9 4e 09 00 00       	jmp    c01027f5 <__alltraps>

c0101ea7 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101ea7:	6a 00                	push   $0x0
  pushl $34
c0101ea9:	6a 22                	push   $0x22
  jmp __alltraps
c0101eab:	e9 45 09 00 00       	jmp    c01027f5 <__alltraps>

c0101eb0 <vector35>:
.globl vector35
vector35:
  pushl $0
c0101eb0:	6a 00                	push   $0x0
  pushl $35
c0101eb2:	6a 23                	push   $0x23
  jmp __alltraps
c0101eb4:	e9 3c 09 00 00       	jmp    c01027f5 <__alltraps>

c0101eb9 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101eb9:	6a 00                	push   $0x0
  pushl $36
c0101ebb:	6a 24                	push   $0x24
  jmp __alltraps
c0101ebd:	e9 33 09 00 00       	jmp    c01027f5 <__alltraps>

c0101ec2 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ec2:	6a 00                	push   $0x0
  pushl $37
c0101ec4:	6a 25                	push   $0x25
  jmp __alltraps
c0101ec6:	e9 2a 09 00 00       	jmp    c01027f5 <__alltraps>

c0101ecb <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ecb:	6a 00                	push   $0x0
  pushl $38
c0101ecd:	6a 26                	push   $0x26
  jmp __alltraps
c0101ecf:	e9 21 09 00 00       	jmp    c01027f5 <__alltraps>

c0101ed4 <vector39>:
.globl vector39
vector39:
  pushl $0
c0101ed4:	6a 00                	push   $0x0
  pushl $39
c0101ed6:	6a 27                	push   $0x27
  jmp __alltraps
c0101ed8:	e9 18 09 00 00       	jmp    c01027f5 <__alltraps>

c0101edd <vector40>:
.globl vector40
vector40:
  pushl $0
c0101edd:	6a 00                	push   $0x0
  pushl $40
c0101edf:	6a 28                	push   $0x28
  jmp __alltraps
c0101ee1:	e9 0f 09 00 00       	jmp    c01027f5 <__alltraps>

c0101ee6 <vector41>:
.globl vector41
vector41:
  pushl $0
c0101ee6:	6a 00                	push   $0x0
  pushl $41
c0101ee8:	6a 29                	push   $0x29
  jmp __alltraps
c0101eea:	e9 06 09 00 00       	jmp    c01027f5 <__alltraps>

c0101eef <vector42>:
.globl vector42
vector42:
  pushl $0
c0101eef:	6a 00                	push   $0x0
  pushl $42
c0101ef1:	6a 2a                	push   $0x2a
  jmp __alltraps
c0101ef3:	e9 fd 08 00 00       	jmp    c01027f5 <__alltraps>

c0101ef8 <vector43>:
.globl vector43
vector43:
  pushl $0
c0101ef8:	6a 00                	push   $0x0
  pushl $43
c0101efa:	6a 2b                	push   $0x2b
  jmp __alltraps
c0101efc:	e9 f4 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f01 <vector44>:
.globl vector44
vector44:
  pushl $0
c0101f01:	6a 00                	push   $0x0
  pushl $44
c0101f03:	6a 2c                	push   $0x2c
  jmp __alltraps
c0101f05:	e9 eb 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f0a <vector45>:
.globl vector45
vector45:
  pushl $0
c0101f0a:	6a 00                	push   $0x0
  pushl $45
c0101f0c:	6a 2d                	push   $0x2d
  jmp __alltraps
c0101f0e:	e9 e2 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f13 <vector46>:
.globl vector46
vector46:
  pushl $0
c0101f13:	6a 00                	push   $0x0
  pushl $46
c0101f15:	6a 2e                	push   $0x2e
  jmp __alltraps
c0101f17:	e9 d9 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f1c <vector47>:
.globl vector47
vector47:
  pushl $0
c0101f1c:	6a 00                	push   $0x0
  pushl $47
c0101f1e:	6a 2f                	push   $0x2f
  jmp __alltraps
c0101f20:	e9 d0 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f25 <vector48>:
.globl vector48
vector48:
  pushl $0
c0101f25:	6a 00                	push   $0x0
  pushl $48
c0101f27:	6a 30                	push   $0x30
  jmp __alltraps
c0101f29:	e9 c7 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f2e <vector49>:
.globl vector49
vector49:
  pushl $0
c0101f2e:	6a 00                	push   $0x0
  pushl $49
c0101f30:	6a 31                	push   $0x31
  jmp __alltraps
c0101f32:	e9 be 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f37 <vector50>:
.globl vector50
vector50:
  pushl $0
c0101f37:	6a 00                	push   $0x0
  pushl $50
c0101f39:	6a 32                	push   $0x32
  jmp __alltraps
c0101f3b:	e9 b5 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f40 <vector51>:
.globl vector51
vector51:
  pushl $0
c0101f40:	6a 00                	push   $0x0
  pushl $51
c0101f42:	6a 33                	push   $0x33
  jmp __alltraps
c0101f44:	e9 ac 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f49 <vector52>:
.globl vector52
vector52:
  pushl $0
c0101f49:	6a 00                	push   $0x0
  pushl $52
c0101f4b:	6a 34                	push   $0x34
  jmp __alltraps
c0101f4d:	e9 a3 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f52 <vector53>:
.globl vector53
vector53:
  pushl $0
c0101f52:	6a 00                	push   $0x0
  pushl $53
c0101f54:	6a 35                	push   $0x35
  jmp __alltraps
c0101f56:	e9 9a 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f5b <vector54>:
.globl vector54
vector54:
  pushl $0
c0101f5b:	6a 00                	push   $0x0
  pushl $54
c0101f5d:	6a 36                	push   $0x36
  jmp __alltraps
c0101f5f:	e9 91 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f64 <vector55>:
.globl vector55
vector55:
  pushl $0
c0101f64:	6a 00                	push   $0x0
  pushl $55
c0101f66:	6a 37                	push   $0x37
  jmp __alltraps
c0101f68:	e9 88 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f6d <vector56>:
.globl vector56
vector56:
  pushl $0
c0101f6d:	6a 00                	push   $0x0
  pushl $56
c0101f6f:	6a 38                	push   $0x38
  jmp __alltraps
c0101f71:	e9 7f 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f76 <vector57>:
.globl vector57
vector57:
  pushl $0
c0101f76:	6a 00                	push   $0x0
  pushl $57
c0101f78:	6a 39                	push   $0x39
  jmp __alltraps
c0101f7a:	e9 76 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f7f <vector58>:
.globl vector58
vector58:
  pushl $0
c0101f7f:	6a 00                	push   $0x0
  pushl $58
c0101f81:	6a 3a                	push   $0x3a
  jmp __alltraps
c0101f83:	e9 6d 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f88 <vector59>:
.globl vector59
vector59:
  pushl $0
c0101f88:	6a 00                	push   $0x0
  pushl $59
c0101f8a:	6a 3b                	push   $0x3b
  jmp __alltraps
c0101f8c:	e9 64 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f91 <vector60>:
.globl vector60
vector60:
  pushl $0
c0101f91:	6a 00                	push   $0x0
  pushl $60
c0101f93:	6a 3c                	push   $0x3c
  jmp __alltraps
c0101f95:	e9 5b 08 00 00       	jmp    c01027f5 <__alltraps>

c0101f9a <vector61>:
.globl vector61
vector61:
  pushl $0
c0101f9a:	6a 00                	push   $0x0
  pushl $61
c0101f9c:	6a 3d                	push   $0x3d
  jmp __alltraps
c0101f9e:	e9 52 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fa3 <vector62>:
.globl vector62
vector62:
  pushl $0
c0101fa3:	6a 00                	push   $0x0
  pushl $62
c0101fa5:	6a 3e                	push   $0x3e
  jmp __alltraps
c0101fa7:	e9 49 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fac <vector63>:
.globl vector63
vector63:
  pushl $0
c0101fac:	6a 00                	push   $0x0
  pushl $63
c0101fae:	6a 3f                	push   $0x3f
  jmp __alltraps
c0101fb0:	e9 40 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fb5 <vector64>:
.globl vector64
vector64:
  pushl $0
c0101fb5:	6a 00                	push   $0x0
  pushl $64
c0101fb7:	6a 40                	push   $0x40
  jmp __alltraps
c0101fb9:	e9 37 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fbe <vector65>:
.globl vector65
vector65:
  pushl $0
c0101fbe:	6a 00                	push   $0x0
  pushl $65
c0101fc0:	6a 41                	push   $0x41
  jmp __alltraps
c0101fc2:	e9 2e 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fc7 <vector66>:
.globl vector66
vector66:
  pushl $0
c0101fc7:	6a 00                	push   $0x0
  pushl $66
c0101fc9:	6a 42                	push   $0x42
  jmp __alltraps
c0101fcb:	e9 25 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fd0 <vector67>:
.globl vector67
vector67:
  pushl $0
c0101fd0:	6a 00                	push   $0x0
  pushl $67
c0101fd2:	6a 43                	push   $0x43
  jmp __alltraps
c0101fd4:	e9 1c 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fd9 <vector68>:
.globl vector68
vector68:
  pushl $0
c0101fd9:	6a 00                	push   $0x0
  pushl $68
c0101fdb:	6a 44                	push   $0x44
  jmp __alltraps
c0101fdd:	e9 13 08 00 00       	jmp    c01027f5 <__alltraps>

c0101fe2 <vector69>:
.globl vector69
vector69:
  pushl $0
c0101fe2:	6a 00                	push   $0x0
  pushl $69
c0101fe4:	6a 45                	push   $0x45
  jmp __alltraps
c0101fe6:	e9 0a 08 00 00       	jmp    c01027f5 <__alltraps>

c0101feb <vector70>:
.globl vector70
vector70:
  pushl $0
c0101feb:	6a 00                	push   $0x0
  pushl $70
c0101fed:	6a 46                	push   $0x46
  jmp __alltraps
c0101fef:	e9 01 08 00 00       	jmp    c01027f5 <__alltraps>

c0101ff4 <vector71>:
.globl vector71
vector71:
  pushl $0
c0101ff4:	6a 00                	push   $0x0
  pushl $71
c0101ff6:	6a 47                	push   $0x47
  jmp __alltraps
c0101ff8:	e9 f8 07 00 00       	jmp    c01027f5 <__alltraps>

c0101ffd <vector72>:
.globl vector72
vector72:
  pushl $0
c0101ffd:	6a 00                	push   $0x0
  pushl $72
c0101fff:	6a 48                	push   $0x48
  jmp __alltraps
c0102001:	e9 ef 07 00 00       	jmp    c01027f5 <__alltraps>

c0102006 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102006:	6a 00                	push   $0x0
  pushl $73
c0102008:	6a 49                	push   $0x49
  jmp __alltraps
c010200a:	e9 e6 07 00 00       	jmp    c01027f5 <__alltraps>

c010200f <vector74>:
.globl vector74
vector74:
  pushl $0
c010200f:	6a 00                	push   $0x0
  pushl $74
c0102011:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102013:	e9 dd 07 00 00       	jmp    c01027f5 <__alltraps>

c0102018 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102018:	6a 00                	push   $0x0
  pushl $75
c010201a:	6a 4b                	push   $0x4b
  jmp __alltraps
c010201c:	e9 d4 07 00 00       	jmp    c01027f5 <__alltraps>

c0102021 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102021:	6a 00                	push   $0x0
  pushl $76
c0102023:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102025:	e9 cb 07 00 00       	jmp    c01027f5 <__alltraps>

c010202a <vector77>:
.globl vector77
vector77:
  pushl $0
c010202a:	6a 00                	push   $0x0
  pushl $77
c010202c:	6a 4d                	push   $0x4d
  jmp __alltraps
c010202e:	e9 c2 07 00 00       	jmp    c01027f5 <__alltraps>

c0102033 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102033:	6a 00                	push   $0x0
  pushl $78
c0102035:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102037:	e9 b9 07 00 00       	jmp    c01027f5 <__alltraps>

c010203c <vector79>:
.globl vector79
vector79:
  pushl $0
c010203c:	6a 00                	push   $0x0
  pushl $79
c010203e:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102040:	e9 b0 07 00 00       	jmp    c01027f5 <__alltraps>

c0102045 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102045:	6a 00                	push   $0x0
  pushl $80
c0102047:	6a 50                	push   $0x50
  jmp __alltraps
c0102049:	e9 a7 07 00 00       	jmp    c01027f5 <__alltraps>

c010204e <vector81>:
.globl vector81
vector81:
  pushl $0
c010204e:	6a 00                	push   $0x0
  pushl $81
c0102050:	6a 51                	push   $0x51
  jmp __alltraps
c0102052:	e9 9e 07 00 00       	jmp    c01027f5 <__alltraps>

c0102057 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102057:	6a 00                	push   $0x0
  pushl $82
c0102059:	6a 52                	push   $0x52
  jmp __alltraps
c010205b:	e9 95 07 00 00       	jmp    c01027f5 <__alltraps>

c0102060 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102060:	6a 00                	push   $0x0
  pushl $83
c0102062:	6a 53                	push   $0x53
  jmp __alltraps
c0102064:	e9 8c 07 00 00       	jmp    c01027f5 <__alltraps>

c0102069 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102069:	6a 00                	push   $0x0
  pushl $84
c010206b:	6a 54                	push   $0x54
  jmp __alltraps
c010206d:	e9 83 07 00 00       	jmp    c01027f5 <__alltraps>

c0102072 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102072:	6a 00                	push   $0x0
  pushl $85
c0102074:	6a 55                	push   $0x55
  jmp __alltraps
c0102076:	e9 7a 07 00 00       	jmp    c01027f5 <__alltraps>

c010207b <vector86>:
.globl vector86
vector86:
  pushl $0
c010207b:	6a 00                	push   $0x0
  pushl $86
c010207d:	6a 56                	push   $0x56
  jmp __alltraps
c010207f:	e9 71 07 00 00       	jmp    c01027f5 <__alltraps>

c0102084 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102084:	6a 00                	push   $0x0
  pushl $87
c0102086:	6a 57                	push   $0x57
  jmp __alltraps
c0102088:	e9 68 07 00 00       	jmp    c01027f5 <__alltraps>

c010208d <vector88>:
.globl vector88
vector88:
  pushl $0
c010208d:	6a 00                	push   $0x0
  pushl $88
c010208f:	6a 58                	push   $0x58
  jmp __alltraps
c0102091:	e9 5f 07 00 00       	jmp    c01027f5 <__alltraps>

c0102096 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102096:	6a 00                	push   $0x0
  pushl $89
c0102098:	6a 59                	push   $0x59
  jmp __alltraps
c010209a:	e9 56 07 00 00       	jmp    c01027f5 <__alltraps>

c010209f <vector90>:
.globl vector90
vector90:
  pushl $0
c010209f:	6a 00                	push   $0x0
  pushl $90
c01020a1:	6a 5a                	push   $0x5a
  jmp __alltraps
c01020a3:	e9 4d 07 00 00       	jmp    c01027f5 <__alltraps>

c01020a8 <vector91>:
.globl vector91
vector91:
  pushl $0
c01020a8:	6a 00                	push   $0x0
  pushl $91
c01020aa:	6a 5b                	push   $0x5b
  jmp __alltraps
c01020ac:	e9 44 07 00 00       	jmp    c01027f5 <__alltraps>

c01020b1 <vector92>:
.globl vector92
vector92:
  pushl $0
c01020b1:	6a 00                	push   $0x0
  pushl $92
c01020b3:	6a 5c                	push   $0x5c
  jmp __alltraps
c01020b5:	e9 3b 07 00 00       	jmp    c01027f5 <__alltraps>

c01020ba <vector93>:
.globl vector93
vector93:
  pushl $0
c01020ba:	6a 00                	push   $0x0
  pushl $93
c01020bc:	6a 5d                	push   $0x5d
  jmp __alltraps
c01020be:	e9 32 07 00 00       	jmp    c01027f5 <__alltraps>

c01020c3 <vector94>:
.globl vector94
vector94:
  pushl $0
c01020c3:	6a 00                	push   $0x0
  pushl $94
c01020c5:	6a 5e                	push   $0x5e
  jmp __alltraps
c01020c7:	e9 29 07 00 00       	jmp    c01027f5 <__alltraps>

c01020cc <vector95>:
.globl vector95
vector95:
  pushl $0
c01020cc:	6a 00                	push   $0x0
  pushl $95
c01020ce:	6a 5f                	push   $0x5f
  jmp __alltraps
c01020d0:	e9 20 07 00 00       	jmp    c01027f5 <__alltraps>

c01020d5 <vector96>:
.globl vector96
vector96:
  pushl $0
c01020d5:	6a 00                	push   $0x0
  pushl $96
c01020d7:	6a 60                	push   $0x60
  jmp __alltraps
c01020d9:	e9 17 07 00 00       	jmp    c01027f5 <__alltraps>

c01020de <vector97>:
.globl vector97
vector97:
  pushl $0
c01020de:	6a 00                	push   $0x0
  pushl $97
c01020e0:	6a 61                	push   $0x61
  jmp __alltraps
c01020e2:	e9 0e 07 00 00       	jmp    c01027f5 <__alltraps>

c01020e7 <vector98>:
.globl vector98
vector98:
  pushl $0
c01020e7:	6a 00                	push   $0x0
  pushl $98
c01020e9:	6a 62                	push   $0x62
  jmp __alltraps
c01020eb:	e9 05 07 00 00       	jmp    c01027f5 <__alltraps>

c01020f0 <vector99>:
.globl vector99
vector99:
  pushl $0
c01020f0:	6a 00                	push   $0x0
  pushl $99
c01020f2:	6a 63                	push   $0x63
  jmp __alltraps
c01020f4:	e9 fc 06 00 00       	jmp    c01027f5 <__alltraps>

c01020f9 <vector100>:
.globl vector100
vector100:
  pushl $0
c01020f9:	6a 00                	push   $0x0
  pushl $100
c01020fb:	6a 64                	push   $0x64
  jmp __alltraps
c01020fd:	e9 f3 06 00 00       	jmp    c01027f5 <__alltraps>

c0102102 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102102:	6a 00                	push   $0x0
  pushl $101
c0102104:	6a 65                	push   $0x65
  jmp __alltraps
c0102106:	e9 ea 06 00 00       	jmp    c01027f5 <__alltraps>

c010210b <vector102>:
.globl vector102
vector102:
  pushl $0
c010210b:	6a 00                	push   $0x0
  pushl $102
c010210d:	6a 66                	push   $0x66
  jmp __alltraps
c010210f:	e9 e1 06 00 00       	jmp    c01027f5 <__alltraps>

c0102114 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102114:	6a 00                	push   $0x0
  pushl $103
c0102116:	6a 67                	push   $0x67
  jmp __alltraps
c0102118:	e9 d8 06 00 00       	jmp    c01027f5 <__alltraps>

c010211d <vector104>:
.globl vector104
vector104:
  pushl $0
c010211d:	6a 00                	push   $0x0
  pushl $104
c010211f:	6a 68                	push   $0x68
  jmp __alltraps
c0102121:	e9 cf 06 00 00       	jmp    c01027f5 <__alltraps>

c0102126 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102126:	6a 00                	push   $0x0
  pushl $105
c0102128:	6a 69                	push   $0x69
  jmp __alltraps
c010212a:	e9 c6 06 00 00       	jmp    c01027f5 <__alltraps>

c010212f <vector106>:
.globl vector106
vector106:
  pushl $0
c010212f:	6a 00                	push   $0x0
  pushl $106
c0102131:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102133:	e9 bd 06 00 00       	jmp    c01027f5 <__alltraps>

c0102138 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102138:	6a 00                	push   $0x0
  pushl $107
c010213a:	6a 6b                	push   $0x6b
  jmp __alltraps
c010213c:	e9 b4 06 00 00       	jmp    c01027f5 <__alltraps>

c0102141 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102141:	6a 00                	push   $0x0
  pushl $108
c0102143:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102145:	e9 ab 06 00 00       	jmp    c01027f5 <__alltraps>

c010214a <vector109>:
.globl vector109
vector109:
  pushl $0
c010214a:	6a 00                	push   $0x0
  pushl $109
c010214c:	6a 6d                	push   $0x6d
  jmp __alltraps
c010214e:	e9 a2 06 00 00       	jmp    c01027f5 <__alltraps>

c0102153 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102153:	6a 00                	push   $0x0
  pushl $110
c0102155:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102157:	e9 99 06 00 00       	jmp    c01027f5 <__alltraps>

c010215c <vector111>:
.globl vector111
vector111:
  pushl $0
c010215c:	6a 00                	push   $0x0
  pushl $111
c010215e:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102160:	e9 90 06 00 00       	jmp    c01027f5 <__alltraps>

c0102165 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102165:	6a 00                	push   $0x0
  pushl $112
c0102167:	6a 70                	push   $0x70
  jmp __alltraps
c0102169:	e9 87 06 00 00       	jmp    c01027f5 <__alltraps>

c010216e <vector113>:
.globl vector113
vector113:
  pushl $0
c010216e:	6a 00                	push   $0x0
  pushl $113
c0102170:	6a 71                	push   $0x71
  jmp __alltraps
c0102172:	e9 7e 06 00 00       	jmp    c01027f5 <__alltraps>

c0102177 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102177:	6a 00                	push   $0x0
  pushl $114
c0102179:	6a 72                	push   $0x72
  jmp __alltraps
c010217b:	e9 75 06 00 00       	jmp    c01027f5 <__alltraps>

c0102180 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102180:	6a 00                	push   $0x0
  pushl $115
c0102182:	6a 73                	push   $0x73
  jmp __alltraps
c0102184:	e9 6c 06 00 00       	jmp    c01027f5 <__alltraps>

c0102189 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102189:	6a 00                	push   $0x0
  pushl $116
c010218b:	6a 74                	push   $0x74
  jmp __alltraps
c010218d:	e9 63 06 00 00       	jmp    c01027f5 <__alltraps>

c0102192 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102192:	6a 00                	push   $0x0
  pushl $117
c0102194:	6a 75                	push   $0x75
  jmp __alltraps
c0102196:	e9 5a 06 00 00       	jmp    c01027f5 <__alltraps>

c010219b <vector118>:
.globl vector118
vector118:
  pushl $0
c010219b:	6a 00                	push   $0x0
  pushl $118
c010219d:	6a 76                	push   $0x76
  jmp __alltraps
c010219f:	e9 51 06 00 00       	jmp    c01027f5 <__alltraps>

c01021a4 <vector119>:
.globl vector119
vector119:
  pushl $0
c01021a4:	6a 00                	push   $0x0
  pushl $119
c01021a6:	6a 77                	push   $0x77
  jmp __alltraps
c01021a8:	e9 48 06 00 00       	jmp    c01027f5 <__alltraps>

c01021ad <vector120>:
.globl vector120
vector120:
  pushl $0
c01021ad:	6a 00                	push   $0x0
  pushl $120
c01021af:	6a 78                	push   $0x78
  jmp __alltraps
c01021b1:	e9 3f 06 00 00       	jmp    c01027f5 <__alltraps>

c01021b6 <vector121>:
.globl vector121
vector121:
  pushl $0
c01021b6:	6a 00                	push   $0x0
  pushl $121
c01021b8:	6a 79                	push   $0x79
  jmp __alltraps
c01021ba:	e9 36 06 00 00       	jmp    c01027f5 <__alltraps>

c01021bf <vector122>:
.globl vector122
vector122:
  pushl $0
c01021bf:	6a 00                	push   $0x0
  pushl $122
c01021c1:	6a 7a                	push   $0x7a
  jmp __alltraps
c01021c3:	e9 2d 06 00 00       	jmp    c01027f5 <__alltraps>

c01021c8 <vector123>:
.globl vector123
vector123:
  pushl $0
c01021c8:	6a 00                	push   $0x0
  pushl $123
c01021ca:	6a 7b                	push   $0x7b
  jmp __alltraps
c01021cc:	e9 24 06 00 00       	jmp    c01027f5 <__alltraps>

c01021d1 <vector124>:
.globl vector124
vector124:
  pushl $0
c01021d1:	6a 00                	push   $0x0
  pushl $124
c01021d3:	6a 7c                	push   $0x7c
  jmp __alltraps
c01021d5:	e9 1b 06 00 00       	jmp    c01027f5 <__alltraps>

c01021da <vector125>:
.globl vector125
vector125:
  pushl $0
c01021da:	6a 00                	push   $0x0
  pushl $125
c01021dc:	6a 7d                	push   $0x7d
  jmp __alltraps
c01021de:	e9 12 06 00 00       	jmp    c01027f5 <__alltraps>

c01021e3 <vector126>:
.globl vector126
vector126:
  pushl $0
c01021e3:	6a 00                	push   $0x0
  pushl $126
c01021e5:	6a 7e                	push   $0x7e
  jmp __alltraps
c01021e7:	e9 09 06 00 00       	jmp    c01027f5 <__alltraps>

c01021ec <vector127>:
.globl vector127
vector127:
  pushl $0
c01021ec:	6a 00                	push   $0x0
  pushl $127
c01021ee:	6a 7f                	push   $0x7f
  jmp __alltraps
c01021f0:	e9 00 06 00 00       	jmp    c01027f5 <__alltraps>

c01021f5 <vector128>:
.globl vector128
vector128:
  pushl $0
c01021f5:	6a 00                	push   $0x0
  pushl $128
c01021f7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c01021fc:	e9 f4 05 00 00       	jmp    c01027f5 <__alltraps>

c0102201 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102201:	6a 00                	push   $0x0
  pushl $129
c0102203:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102208:	e9 e8 05 00 00       	jmp    c01027f5 <__alltraps>

c010220d <vector130>:
.globl vector130
vector130:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $130
c010220f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102214:	e9 dc 05 00 00       	jmp    c01027f5 <__alltraps>

c0102219 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102219:	6a 00                	push   $0x0
  pushl $131
c010221b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102220:	e9 d0 05 00 00       	jmp    c01027f5 <__alltraps>

c0102225 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102225:	6a 00                	push   $0x0
  pushl $132
c0102227:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010222c:	e9 c4 05 00 00       	jmp    c01027f5 <__alltraps>

c0102231 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $133
c0102233:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102238:	e9 b8 05 00 00       	jmp    c01027f5 <__alltraps>

c010223d <vector134>:
.globl vector134
vector134:
  pushl $0
c010223d:	6a 00                	push   $0x0
  pushl $134
c010223f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102244:	e9 ac 05 00 00       	jmp    c01027f5 <__alltraps>

c0102249 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102249:	6a 00                	push   $0x0
  pushl $135
c010224b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102250:	e9 a0 05 00 00       	jmp    c01027f5 <__alltraps>

c0102255 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $136
c0102257:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010225c:	e9 94 05 00 00       	jmp    c01027f5 <__alltraps>

c0102261 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102261:	6a 00                	push   $0x0
  pushl $137
c0102263:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102268:	e9 88 05 00 00       	jmp    c01027f5 <__alltraps>

c010226d <vector138>:
.globl vector138
vector138:
  pushl $0
c010226d:	6a 00                	push   $0x0
  pushl $138
c010226f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102274:	e9 7c 05 00 00       	jmp    c01027f5 <__alltraps>

c0102279 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $139
c010227b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102280:	e9 70 05 00 00       	jmp    c01027f5 <__alltraps>

c0102285 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102285:	6a 00                	push   $0x0
  pushl $140
c0102287:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010228c:	e9 64 05 00 00       	jmp    c01027f5 <__alltraps>

c0102291 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102291:	6a 00                	push   $0x0
  pushl $141
c0102293:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102298:	e9 58 05 00 00       	jmp    c01027f5 <__alltraps>

c010229d <vector142>:
.globl vector142
vector142:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $142
c010229f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01022a4:	e9 4c 05 00 00       	jmp    c01027f5 <__alltraps>

c01022a9 <vector143>:
.globl vector143
vector143:
  pushl $0
c01022a9:	6a 00                	push   $0x0
  pushl $143
c01022ab:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01022b0:	e9 40 05 00 00       	jmp    c01027f5 <__alltraps>

c01022b5 <vector144>:
.globl vector144
vector144:
  pushl $0
c01022b5:	6a 00                	push   $0x0
  pushl $144
c01022b7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01022bc:	e9 34 05 00 00       	jmp    c01027f5 <__alltraps>

c01022c1 <vector145>:
.globl vector145
vector145:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $145
c01022c3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01022c8:	e9 28 05 00 00       	jmp    c01027f5 <__alltraps>

c01022cd <vector146>:
.globl vector146
vector146:
  pushl $0
c01022cd:	6a 00                	push   $0x0
  pushl $146
c01022cf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c01022d4:	e9 1c 05 00 00       	jmp    c01027f5 <__alltraps>

c01022d9 <vector147>:
.globl vector147
vector147:
  pushl $0
c01022d9:	6a 00                	push   $0x0
  pushl $147
c01022db:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01022e0:	e9 10 05 00 00       	jmp    c01027f5 <__alltraps>

c01022e5 <vector148>:
.globl vector148
vector148:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $148
c01022e7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01022ec:	e9 04 05 00 00       	jmp    c01027f5 <__alltraps>

c01022f1 <vector149>:
.globl vector149
vector149:
  pushl $0
c01022f1:	6a 00                	push   $0x0
  pushl $149
c01022f3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01022f8:	e9 f8 04 00 00       	jmp    c01027f5 <__alltraps>

c01022fd <vector150>:
.globl vector150
vector150:
  pushl $0
c01022fd:	6a 00                	push   $0x0
  pushl $150
c01022ff:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102304:	e9 ec 04 00 00       	jmp    c01027f5 <__alltraps>

c0102309 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $151
c010230b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102310:	e9 e0 04 00 00       	jmp    c01027f5 <__alltraps>

c0102315 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102315:	6a 00                	push   $0x0
  pushl $152
c0102317:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010231c:	e9 d4 04 00 00       	jmp    c01027f5 <__alltraps>

c0102321 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102321:	6a 00                	push   $0x0
  pushl $153
c0102323:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102328:	e9 c8 04 00 00       	jmp    c01027f5 <__alltraps>

c010232d <vector154>:
.globl vector154
vector154:
  pushl $0
c010232d:	6a 00                	push   $0x0
  pushl $154
c010232f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102334:	e9 bc 04 00 00       	jmp    c01027f5 <__alltraps>

c0102339 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102339:	6a 00                	push   $0x0
  pushl $155
c010233b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102340:	e9 b0 04 00 00       	jmp    c01027f5 <__alltraps>

c0102345 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102345:	6a 00                	push   $0x0
  pushl $156
c0102347:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010234c:	e9 a4 04 00 00       	jmp    c01027f5 <__alltraps>

c0102351 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102351:	6a 00                	push   $0x0
  pushl $157
c0102353:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102358:	e9 98 04 00 00       	jmp    c01027f5 <__alltraps>

c010235d <vector158>:
.globl vector158
vector158:
  pushl $0
c010235d:	6a 00                	push   $0x0
  pushl $158
c010235f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102364:	e9 8c 04 00 00       	jmp    c01027f5 <__alltraps>

c0102369 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102369:	6a 00                	push   $0x0
  pushl $159
c010236b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102370:	e9 80 04 00 00       	jmp    c01027f5 <__alltraps>

c0102375 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102375:	6a 00                	push   $0x0
  pushl $160
c0102377:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010237c:	e9 74 04 00 00       	jmp    c01027f5 <__alltraps>

c0102381 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102381:	6a 00                	push   $0x0
  pushl $161
c0102383:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102388:	e9 68 04 00 00       	jmp    c01027f5 <__alltraps>

c010238d <vector162>:
.globl vector162
vector162:
  pushl $0
c010238d:	6a 00                	push   $0x0
  pushl $162
c010238f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102394:	e9 5c 04 00 00       	jmp    c01027f5 <__alltraps>

c0102399 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102399:	6a 00                	push   $0x0
  pushl $163
c010239b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01023a0:	e9 50 04 00 00       	jmp    c01027f5 <__alltraps>

c01023a5 <vector164>:
.globl vector164
vector164:
  pushl $0
c01023a5:	6a 00                	push   $0x0
  pushl $164
c01023a7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01023ac:	e9 44 04 00 00       	jmp    c01027f5 <__alltraps>

c01023b1 <vector165>:
.globl vector165
vector165:
  pushl $0
c01023b1:	6a 00                	push   $0x0
  pushl $165
c01023b3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01023b8:	e9 38 04 00 00       	jmp    c01027f5 <__alltraps>

c01023bd <vector166>:
.globl vector166
vector166:
  pushl $0
c01023bd:	6a 00                	push   $0x0
  pushl $166
c01023bf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01023c4:	e9 2c 04 00 00       	jmp    c01027f5 <__alltraps>

c01023c9 <vector167>:
.globl vector167
vector167:
  pushl $0
c01023c9:	6a 00                	push   $0x0
  pushl $167
c01023cb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01023d0:	e9 20 04 00 00       	jmp    c01027f5 <__alltraps>

c01023d5 <vector168>:
.globl vector168
vector168:
  pushl $0
c01023d5:	6a 00                	push   $0x0
  pushl $168
c01023d7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c01023dc:	e9 14 04 00 00       	jmp    c01027f5 <__alltraps>

c01023e1 <vector169>:
.globl vector169
vector169:
  pushl $0
c01023e1:	6a 00                	push   $0x0
  pushl $169
c01023e3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01023e8:	e9 08 04 00 00       	jmp    c01027f5 <__alltraps>

c01023ed <vector170>:
.globl vector170
vector170:
  pushl $0
c01023ed:	6a 00                	push   $0x0
  pushl $170
c01023ef:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01023f4:	e9 fc 03 00 00       	jmp    c01027f5 <__alltraps>

c01023f9 <vector171>:
.globl vector171
vector171:
  pushl $0
c01023f9:	6a 00                	push   $0x0
  pushl $171
c01023fb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102400:	e9 f0 03 00 00       	jmp    c01027f5 <__alltraps>

c0102405 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102405:	6a 00                	push   $0x0
  pushl $172
c0102407:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010240c:	e9 e4 03 00 00       	jmp    c01027f5 <__alltraps>

c0102411 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102411:	6a 00                	push   $0x0
  pushl $173
c0102413:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102418:	e9 d8 03 00 00       	jmp    c01027f5 <__alltraps>

c010241d <vector174>:
.globl vector174
vector174:
  pushl $0
c010241d:	6a 00                	push   $0x0
  pushl $174
c010241f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102424:	e9 cc 03 00 00       	jmp    c01027f5 <__alltraps>

c0102429 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102429:	6a 00                	push   $0x0
  pushl $175
c010242b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102430:	e9 c0 03 00 00       	jmp    c01027f5 <__alltraps>

c0102435 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102435:	6a 00                	push   $0x0
  pushl $176
c0102437:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010243c:	e9 b4 03 00 00       	jmp    c01027f5 <__alltraps>

c0102441 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102441:	6a 00                	push   $0x0
  pushl $177
c0102443:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102448:	e9 a8 03 00 00       	jmp    c01027f5 <__alltraps>

c010244d <vector178>:
.globl vector178
vector178:
  pushl $0
c010244d:	6a 00                	push   $0x0
  pushl $178
c010244f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102454:	e9 9c 03 00 00       	jmp    c01027f5 <__alltraps>

c0102459 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102459:	6a 00                	push   $0x0
  pushl $179
c010245b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102460:	e9 90 03 00 00       	jmp    c01027f5 <__alltraps>

c0102465 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102465:	6a 00                	push   $0x0
  pushl $180
c0102467:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010246c:	e9 84 03 00 00       	jmp    c01027f5 <__alltraps>

c0102471 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102471:	6a 00                	push   $0x0
  pushl $181
c0102473:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102478:	e9 78 03 00 00       	jmp    c01027f5 <__alltraps>

c010247d <vector182>:
.globl vector182
vector182:
  pushl $0
c010247d:	6a 00                	push   $0x0
  pushl $182
c010247f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102484:	e9 6c 03 00 00       	jmp    c01027f5 <__alltraps>

c0102489 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102489:	6a 00                	push   $0x0
  pushl $183
c010248b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102490:	e9 60 03 00 00       	jmp    c01027f5 <__alltraps>

c0102495 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102495:	6a 00                	push   $0x0
  pushl $184
c0102497:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010249c:	e9 54 03 00 00       	jmp    c01027f5 <__alltraps>

c01024a1 <vector185>:
.globl vector185
vector185:
  pushl $0
c01024a1:	6a 00                	push   $0x0
  pushl $185
c01024a3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01024a8:	e9 48 03 00 00       	jmp    c01027f5 <__alltraps>

c01024ad <vector186>:
.globl vector186
vector186:
  pushl $0
c01024ad:	6a 00                	push   $0x0
  pushl $186
c01024af:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01024b4:	e9 3c 03 00 00       	jmp    c01027f5 <__alltraps>

c01024b9 <vector187>:
.globl vector187
vector187:
  pushl $0
c01024b9:	6a 00                	push   $0x0
  pushl $187
c01024bb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01024c0:	e9 30 03 00 00       	jmp    c01027f5 <__alltraps>

c01024c5 <vector188>:
.globl vector188
vector188:
  pushl $0
c01024c5:	6a 00                	push   $0x0
  pushl $188
c01024c7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01024cc:	e9 24 03 00 00       	jmp    c01027f5 <__alltraps>

c01024d1 <vector189>:
.globl vector189
vector189:
  pushl $0
c01024d1:	6a 00                	push   $0x0
  pushl $189
c01024d3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c01024d8:	e9 18 03 00 00       	jmp    c01027f5 <__alltraps>

c01024dd <vector190>:
.globl vector190
vector190:
  pushl $0
c01024dd:	6a 00                	push   $0x0
  pushl $190
c01024df:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01024e4:	e9 0c 03 00 00       	jmp    c01027f5 <__alltraps>

c01024e9 <vector191>:
.globl vector191
vector191:
  pushl $0
c01024e9:	6a 00                	push   $0x0
  pushl $191
c01024eb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01024f0:	e9 00 03 00 00       	jmp    c01027f5 <__alltraps>

c01024f5 <vector192>:
.globl vector192
vector192:
  pushl $0
c01024f5:	6a 00                	push   $0x0
  pushl $192
c01024f7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01024fc:	e9 f4 02 00 00       	jmp    c01027f5 <__alltraps>

c0102501 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102501:	6a 00                	push   $0x0
  pushl $193
c0102503:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102508:	e9 e8 02 00 00       	jmp    c01027f5 <__alltraps>

c010250d <vector194>:
.globl vector194
vector194:
  pushl $0
c010250d:	6a 00                	push   $0x0
  pushl $194
c010250f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102514:	e9 dc 02 00 00       	jmp    c01027f5 <__alltraps>

c0102519 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102519:	6a 00                	push   $0x0
  pushl $195
c010251b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c0102520:	e9 d0 02 00 00       	jmp    c01027f5 <__alltraps>

c0102525 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102525:	6a 00                	push   $0x0
  pushl $196
c0102527:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010252c:	e9 c4 02 00 00       	jmp    c01027f5 <__alltraps>

c0102531 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102531:	6a 00                	push   $0x0
  pushl $197
c0102533:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102538:	e9 b8 02 00 00       	jmp    c01027f5 <__alltraps>

c010253d <vector198>:
.globl vector198
vector198:
  pushl $0
c010253d:	6a 00                	push   $0x0
  pushl $198
c010253f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102544:	e9 ac 02 00 00       	jmp    c01027f5 <__alltraps>

c0102549 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102549:	6a 00                	push   $0x0
  pushl $199
c010254b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0102550:	e9 a0 02 00 00       	jmp    c01027f5 <__alltraps>

c0102555 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102555:	6a 00                	push   $0x0
  pushl $200
c0102557:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010255c:	e9 94 02 00 00       	jmp    c01027f5 <__alltraps>

c0102561 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102561:	6a 00                	push   $0x0
  pushl $201
c0102563:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102568:	e9 88 02 00 00       	jmp    c01027f5 <__alltraps>

c010256d <vector202>:
.globl vector202
vector202:
  pushl $0
c010256d:	6a 00                	push   $0x0
  pushl $202
c010256f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0102574:	e9 7c 02 00 00       	jmp    c01027f5 <__alltraps>

c0102579 <vector203>:
.globl vector203
vector203:
  pushl $0
c0102579:	6a 00                	push   $0x0
  pushl $203
c010257b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0102580:	e9 70 02 00 00       	jmp    c01027f5 <__alltraps>

c0102585 <vector204>:
.globl vector204
vector204:
  pushl $0
c0102585:	6a 00                	push   $0x0
  pushl $204
c0102587:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010258c:	e9 64 02 00 00       	jmp    c01027f5 <__alltraps>

c0102591 <vector205>:
.globl vector205
vector205:
  pushl $0
c0102591:	6a 00                	push   $0x0
  pushl $205
c0102593:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c0102598:	e9 58 02 00 00       	jmp    c01027f5 <__alltraps>

c010259d <vector206>:
.globl vector206
vector206:
  pushl $0
c010259d:	6a 00                	push   $0x0
  pushl $206
c010259f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01025a4:	e9 4c 02 00 00       	jmp    c01027f5 <__alltraps>

c01025a9 <vector207>:
.globl vector207
vector207:
  pushl $0
c01025a9:	6a 00                	push   $0x0
  pushl $207
c01025ab:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01025b0:	e9 40 02 00 00       	jmp    c01027f5 <__alltraps>

c01025b5 <vector208>:
.globl vector208
vector208:
  pushl $0
c01025b5:	6a 00                	push   $0x0
  pushl $208
c01025b7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01025bc:	e9 34 02 00 00       	jmp    c01027f5 <__alltraps>

c01025c1 <vector209>:
.globl vector209
vector209:
  pushl $0
c01025c1:	6a 00                	push   $0x0
  pushl $209
c01025c3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01025c8:	e9 28 02 00 00       	jmp    c01027f5 <__alltraps>

c01025cd <vector210>:
.globl vector210
vector210:
  pushl $0
c01025cd:	6a 00                	push   $0x0
  pushl $210
c01025cf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c01025d4:	e9 1c 02 00 00       	jmp    c01027f5 <__alltraps>

c01025d9 <vector211>:
.globl vector211
vector211:
  pushl $0
c01025d9:	6a 00                	push   $0x0
  pushl $211
c01025db:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01025e0:	e9 10 02 00 00       	jmp    c01027f5 <__alltraps>

c01025e5 <vector212>:
.globl vector212
vector212:
  pushl $0
c01025e5:	6a 00                	push   $0x0
  pushl $212
c01025e7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01025ec:	e9 04 02 00 00       	jmp    c01027f5 <__alltraps>

c01025f1 <vector213>:
.globl vector213
vector213:
  pushl $0
c01025f1:	6a 00                	push   $0x0
  pushl $213
c01025f3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01025f8:	e9 f8 01 00 00       	jmp    c01027f5 <__alltraps>

c01025fd <vector214>:
.globl vector214
vector214:
  pushl $0
c01025fd:	6a 00                	push   $0x0
  pushl $214
c01025ff:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102604:	e9 ec 01 00 00       	jmp    c01027f5 <__alltraps>

c0102609 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102609:	6a 00                	push   $0x0
  pushl $215
c010260b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c0102610:	e9 e0 01 00 00       	jmp    c01027f5 <__alltraps>

c0102615 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102615:	6a 00                	push   $0x0
  pushl $216
c0102617:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010261c:	e9 d4 01 00 00       	jmp    c01027f5 <__alltraps>

c0102621 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102621:	6a 00                	push   $0x0
  pushl $217
c0102623:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102628:	e9 c8 01 00 00       	jmp    c01027f5 <__alltraps>

c010262d <vector218>:
.globl vector218
vector218:
  pushl $0
c010262d:	6a 00                	push   $0x0
  pushl $218
c010262f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102634:	e9 bc 01 00 00       	jmp    c01027f5 <__alltraps>

c0102639 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102639:	6a 00                	push   $0x0
  pushl $219
c010263b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0102640:	e9 b0 01 00 00       	jmp    c01027f5 <__alltraps>

c0102645 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102645:	6a 00                	push   $0x0
  pushl $220
c0102647:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010264c:	e9 a4 01 00 00       	jmp    c01027f5 <__alltraps>

c0102651 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102651:	6a 00                	push   $0x0
  pushl $221
c0102653:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102658:	e9 98 01 00 00       	jmp    c01027f5 <__alltraps>

c010265d <vector222>:
.globl vector222
vector222:
  pushl $0
c010265d:	6a 00                	push   $0x0
  pushl $222
c010265f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102664:	e9 8c 01 00 00       	jmp    c01027f5 <__alltraps>

c0102669 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102669:	6a 00                	push   $0x0
  pushl $223
c010266b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0102670:	e9 80 01 00 00       	jmp    c01027f5 <__alltraps>

c0102675 <vector224>:
.globl vector224
vector224:
  pushl $0
c0102675:	6a 00                	push   $0x0
  pushl $224
c0102677:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010267c:	e9 74 01 00 00       	jmp    c01027f5 <__alltraps>

c0102681 <vector225>:
.globl vector225
vector225:
  pushl $0
c0102681:	6a 00                	push   $0x0
  pushl $225
c0102683:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c0102688:	e9 68 01 00 00       	jmp    c01027f5 <__alltraps>

c010268d <vector226>:
.globl vector226
vector226:
  pushl $0
c010268d:	6a 00                	push   $0x0
  pushl $226
c010268f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0102694:	e9 5c 01 00 00       	jmp    c01027f5 <__alltraps>

c0102699 <vector227>:
.globl vector227
vector227:
  pushl $0
c0102699:	6a 00                	push   $0x0
  pushl $227
c010269b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01026a0:	e9 50 01 00 00       	jmp    c01027f5 <__alltraps>

c01026a5 <vector228>:
.globl vector228
vector228:
  pushl $0
c01026a5:	6a 00                	push   $0x0
  pushl $228
c01026a7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01026ac:	e9 44 01 00 00       	jmp    c01027f5 <__alltraps>

c01026b1 <vector229>:
.globl vector229
vector229:
  pushl $0
c01026b1:	6a 00                	push   $0x0
  pushl $229
c01026b3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01026b8:	e9 38 01 00 00       	jmp    c01027f5 <__alltraps>

c01026bd <vector230>:
.globl vector230
vector230:
  pushl $0
c01026bd:	6a 00                	push   $0x0
  pushl $230
c01026bf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01026c4:	e9 2c 01 00 00       	jmp    c01027f5 <__alltraps>

c01026c9 <vector231>:
.globl vector231
vector231:
  pushl $0
c01026c9:	6a 00                	push   $0x0
  pushl $231
c01026cb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01026d0:	e9 20 01 00 00       	jmp    c01027f5 <__alltraps>

c01026d5 <vector232>:
.globl vector232
vector232:
  pushl $0
c01026d5:	6a 00                	push   $0x0
  pushl $232
c01026d7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c01026dc:	e9 14 01 00 00       	jmp    c01027f5 <__alltraps>

c01026e1 <vector233>:
.globl vector233
vector233:
  pushl $0
c01026e1:	6a 00                	push   $0x0
  pushl $233
c01026e3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01026e8:	e9 08 01 00 00       	jmp    c01027f5 <__alltraps>

c01026ed <vector234>:
.globl vector234
vector234:
  pushl $0
c01026ed:	6a 00                	push   $0x0
  pushl $234
c01026ef:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01026f4:	e9 fc 00 00 00       	jmp    c01027f5 <__alltraps>

c01026f9 <vector235>:
.globl vector235
vector235:
  pushl $0
c01026f9:	6a 00                	push   $0x0
  pushl $235
c01026fb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c0102700:	e9 f0 00 00 00       	jmp    c01027f5 <__alltraps>

c0102705 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102705:	6a 00                	push   $0x0
  pushl $236
c0102707:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010270c:	e9 e4 00 00 00       	jmp    c01027f5 <__alltraps>

c0102711 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102711:	6a 00                	push   $0x0
  pushl $237
c0102713:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102718:	e9 d8 00 00 00       	jmp    c01027f5 <__alltraps>

c010271d <vector238>:
.globl vector238
vector238:
  pushl $0
c010271d:	6a 00                	push   $0x0
  pushl $238
c010271f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102724:	e9 cc 00 00 00       	jmp    c01027f5 <__alltraps>

c0102729 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102729:	6a 00                	push   $0x0
  pushl $239
c010272b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c0102730:	e9 c0 00 00 00       	jmp    c01027f5 <__alltraps>

c0102735 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102735:	6a 00                	push   $0x0
  pushl $240
c0102737:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010273c:	e9 b4 00 00 00       	jmp    c01027f5 <__alltraps>

c0102741 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102741:	6a 00                	push   $0x0
  pushl $241
c0102743:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102748:	e9 a8 00 00 00       	jmp    c01027f5 <__alltraps>

c010274d <vector242>:
.globl vector242
vector242:
  pushl $0
c010274d:	6a 00                	push   $0x0
  pushl $242
c010274f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102754:	e9 9c 00 00 00       	jmp    c01027f5 <__alltraps>

c0102759 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102759:	6a 00                	push   $0x0
  pushl $243
c010275b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0102760:	e9 90 00 00 00       	jmp    c01027f5 <__alltraps>

c0102765 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102765:	6a 00                	push   $0x0
  pushl $244
c0102767:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010276c:	e9 84 00 00 00       	jmp    c01027f5 <__alltraps>

c0102771 <vector245>:
.globl vector245
vector245:
  pushl $0
c0102771:	6a 00                	push   $0x0
  pushl $245
c0102773:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c0102778:	e9 78 00 00 00       	jmp    c01027f5 <__alltraps>

c010277d <vector246>:
.globl vector246
vector246:
  pushl $0
c010277d:	6a 00                	push   $0x0
  pushl $246
c010277f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0102784:	e9 6c 00 00 00       	jmp    c01027f5 <__alltraps>

c0102789 <vector247>:
.globl vector247
vector247:
  pushl $0
c0102789:	6a 00                	push   $0x0
  pushl $247
c010278b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0102790:	e9 60 00 00 00       	jmp    c01027f5 <__alltraps>

c0102795 <vector248>:
.globl vector248
vector248:
  pushl $0
c0102795:	6a 00                	push   $0x0
  pushl $248
c0102797:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010279c:	e9 54 00 00 00       	jmp    c01027f5 <__alltraps>

c01027a1 <vector249>:
.globl vector249
vector249:
  pushl $0
c01027a1:	6a 00                	push   $0x0
  pushl $249
c01027a3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01027a8:	e9 48 00 00 00       	jmp    c01027f5 <__alltraps>

c01027ad <vector250>:
.globl vector250
vector250:
  pushl $0
c01027ad:	6a 00                	push   $0x0
  pushl $250
c01027af:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01027b4:	e9 3c 00 00 00       	jmp    c01027f5 <__alltraps>

c01027b9 <vector251>:
.globl vector251
vector251:
  pushl $0
c01027b9:	6a 00                	push   $0x0
  pushl $251
c01027bb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01027c0:	e9 30 00 00 00       	jmp    c01027f5 <__alltraps>

c01027c5 <vector252>:
.globl vector252
vector252:
  pushl $0
c01027c5:	6a 00                	push   $0x0
  pushl $252
c01027c7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01027cc:	e9 24 00 00 00       	jmp    c01027f5 <__alltraps>

c01027d1 <vector253>:
.globl vector253
vector253:
  pushl $0
c01027d1:	6a 00                	push   $0x0
  pushl $253
c01027d3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c01027d8:	e9 18 00 00 00       	jmp    c01027f5 <__alltraps>

c01027dd <vector254>:
.globl vector254
vector254:
  pushl $0
c01027dd:	6a 00                	push   $0x0
  pushl $254
c01027df:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01027e4:	e9 0c 00 00 00       	jmp    c01027f5 <__alltraps>

c01027e9 <vector255>:
.globl vector255
vector255:
  pushl $0
c01027e9:	6a 00                	push   $0x0
  pushl $255
c01027eb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01027f0:	e9 00 00 00 00       	jmp    c01027f5 <__alltraps>

c01027f5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01027f5:	1e                   	push   %ds
    pushl %es
c01027f6:	06                   	push   %es
    pushl %fs
c01027f7:	0f a0                	push   %fs
    pushl %gs
c01027f9:	0f a8                	push   %gs
    pushal
c01027fb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01027fc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102801:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102803:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102805:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102806:	e8 64 f5 ff ff       	call   c0101d6f <trap>

    # pop the pushed stack pointer
    popl %esp
c010280b:	5c                   	pop    %esp

c010280c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c010280c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c010280d:	0f a9                	pop    %gs
    popl %fs
c010280f:	0f a1                	pop    %fs
    popl %es
c0102811:	07                   	pop    %es
    popl %ds
c0102812:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102813:	83 c4 08             	add    $0x8,%esp
    iret
c0102816:	cf                   	iret   

c0102817 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102817:	55                   	push   %ebp
c0102818:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010281a:	8b 45 08             	mov    0x8(%ebp),%eax
c010281d:	8b 15 98 af 11 c0    	mov    0xc011af98,%edx
c0102823:	29 d0                	sub    %edx,%eax
c0102825:	c1 f8 02             	sar    $0x2,%eax
c0102828:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010282e:	5d                   	pop    %ebp
c010282f:	c3                   	ret    

c0102830 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102830:	55                   	push   %ebp
c0102831:	89 e5                	mov    %esp,%ebp
c0102833:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102836:	8b 45 08             	mov    0x8(%ebp),%eax
c0102839:	89 04 24             	mov    %eax,(%esp)
c010283c:	e8 d6 ff ff ff       	call   c0102817 <page2ppn>
c0102841:	c1 e0 0c             	shl    $0xc,%eax
}
c0102844:	c9                   	leave  
c0102845:	c3                   	ret    

c0102846 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0102846:	55                   	push   %ebp
c0102847:	89 e5                	mov    %esp,%ebp
c0102849:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010284c:	8b 45 08             	mov    0x8(%ebp),%eax
c010284f:	c1 e8 0c             	shr    $0xc,%eax
c0102852:	89 c2                	mov    %eax,%edx
c0102854:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0102859:	39 c2                	cmp    %eax,%edx
c010285b:	72 1c                	jb     c0102879 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010285d:	c7 44 24 08 50 66 10 	movl   $0xc0106650,0x8(%esp)
c0102864:	c0 
c0102865:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010286c:	00 
c010286d:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102874:	e8 70 db ff ff       	call   c01003e9 <__panic>
    }
    return &pages[PPN(pa)];
c0102879:	8b 0d 98 af 11 c0    	mov    0xc011af98,%ecx
c010287f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102882:	c1 e8 0c             	shr    $0xc,%eax
c0102885:	89 c2                	mov    %eax,%edx
c0102887:	89 d0                	mov    %edx,%eax
c0102889:	c1 e0 02             	shl    $0x2,%eax
c010288c:	01 d0                	add    %edx,%eax
c010288e:	c1 e0 02             	shl    $0x2,%eax
c0102891:	01 c8                	add    %ecx,%eax
}
c0102893:	c9                   	leave  
c0102894:	c3                   	ret    

c0102895 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0102895:	55                   	push   %ebp
c0102896:	89 e5                	mov    %esp,%ebp
c0102898:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c010289b:	8b 45 08             	mov    0x8(%ebp),%eax
c010289e:	89 04 24             	mov    %eax,(%esp)
c01028a1:	e8 8a ff ff ff       	call   c0102830 <page2pa>
c01028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028ac:	c1 e8 0c             	shr    $0xc,%eax
c01028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01028b2:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01028b7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01028ba:	72 23                	jb     c01028df <page2kva+0x4a>
c01028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01028c3:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c01028ca:	c0 
c01028cb:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c01028d2:	00 
c01028d3:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c01028da:	e8 0a db ff ff       	call   c01003e9 <__panic>
c01028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01028e2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01028e7:	c9                   	leave  
c01028e8:	c3                   	ret    

c01028e9 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c01028e9:	55                   	push   %ebp
c01028ea:	89 e5                	mov    %esp,%ebp
c01028ec:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c01028ef:	8b 45 08             	mov    0x8(%ebp),%eax
c01028f2:	83 e0 01             	and    $0x1,%eax
c01028f5:	85 c0                	test   %eax,%eax
c01028f7:	75 1c                	jne    c0102915 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c01028f9:	c7 44 24 08 a4 66 10 	movl   $0xc01066a4,0x8(%esp)
c0102900:	c0 
c0102901:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0102908:	00 
c0102909:	c7 04 24 6f 66 10 c0 	movl   $0xc010666f,(%esp)
c0102910:	e8 d4 da ff ff       	call   c01003e9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0102915:	8b 45 08             	mov    0x8(%ebp),%eax
c0102918:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010291d:	89 04 24             	mov    %eax,(%esp)
c0102920:	e8 21 ff ff ff       	call   c0102846 <pa2page>
}
c0102925:	c9                   	leave  
c0102926:	c3                   	ret    

c0102927 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0102927:	55                   	push   %ebp
c0102928:	89 e5                	mov    %esp,%ebp
c010292a:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010292d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102930:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0102935:	89 04 24             	mov    %eax,(%esp)
c0102938:	e8 09 ff ff ff       	call   c0102846 <pa2page>
}
c010293d:	c9                   	leave  
c010293e:	c3                   	ret    

c010293f <page_ref>:

static inline int
page_ref(struct Page *page) {
c010293f:	55                   	push   %ebp
c0102940:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102942:	8b 45 08             	mov    0x8(%ebp),%eax
c0102945:	8b 00                	mov    (%eax),%eax
}
c0102947:	5d                   	pop    %ebp
c0102948:	c3                   	ret    

c0102949 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102949:	55                   	push   %ebp
c010294a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010294c:	8b 45 08             	mov    0x8(%ebp),%eax
c010294f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102952:	89 10                	mov    %edx,(%eax)
}
c0102954:	90                   	nop
c0102955:	5d                   	pop    %ebp
c0102956:	c3                   	ret    

c0102957 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0102957:	55                   	push   %ebp
c0102958:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c010295a:	8b 45 08             	mov    0x8(%ebp),%eax
c010295d:	8b 00                	mov    (%eax),%eax
c010295f:	8d 50 01             	lea    0x1(%eax),%edx
c0102962:	8b 45 08             	mov    0x8(%ebp),%eax
c0102965:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0102967:	8b 45 08             	mov    0x8(%ebp),%eax
c010296a:	8b 00                	mov    (%eax),%eax
}
c010296c:	5d                   	pop    %ebp
c010296d:	c3                   	ret    

c010296e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c010296e:	55                   	push   %ebp
c010296f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0102971:	8b 45 08             	mov    0x8(%ebp),%eax
c0102974:	8b 00                	mov    (%eax),%eax
c0102976:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102979:	8b 45 08             	mov    0x8(%ebp),%eax
c010297c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c010297e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102981:	8b 00                	mov    (%eax),%eax
}
c0102983:	5d                   	pop    %ebp
c0102984:	c3                   	ret    

c0102985 <__intr_save>:
__intr_save(void) {
c0102985:	55                   	push   %ebp
c0102986:	89 e5                	mov    %esp,%ebp
c0102988:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010298b:	9c                   	pushf  
c010298c:	58                   	pop    %eax
c010298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
c0102990:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0102993:	25 00 02 00 00       	and    $0x200,%eax
c0102998:	85 c0                	test   %eax,%eax
c010299a:	74 0c                	je     c01029a8 <__intr_save+0x23>
        intr_disable();
c010299c:	e8 d2 ee ff ff       	call   c0101873 <intr_disable>
        return 1;
c01029a1:	b8 01 00 00 00       	mov    $0x1,%eax
c01029a6:	eb 05                	jmp    c01029ad <__intr_save+0x28>
    return 0;
c01029a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01029ad:	c9                   	leave  
c01029ae:	c3                   	ret    

c01029af <__intr_restore>:
__intr_restore(bool flag) {
c01029af:	55                   	push   %ebp
c01029b0:	89 e5                	mov    %esp,%ebp
c01029b2:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01029b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01029b9:	74 05                	je     c01029c0 <__intr_restore+0x11>
        intr_enable();
c01029bb:	e8 ac ee ff ff       	call   c010186c <intr_enable>
}
c01029c0:	90                   	nop
c01029c1:	c9                   	leave  
c01029c2:	c3                   	ret    

c01029c3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c01029c3:	55                   	push   %ebp
c01029c4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c01029c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01029c9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c01029cc:	b8 23 00 00 00       	mov    $0x23,%eax
c01029d1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c01029d3:	b8 23 00 00 00       	mov    $0x23,%eax
c01029d8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c01029da:	b8 10 00 00 00       	mov    $0x10,%eax
c01029df:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c01029e1:	b8 10 00 00 00       	mov    $0x10,%eax
c01029e6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c01029e8:	b8 10 00 00 00       	mov    $0x10,%eax
c01029ed:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c01029ef:	ea f6 29 10 c0 08 00 	ljmp   $0x8,$0xc01029f6
}
c01029f6:	90                   	nop
c01029f7:	5d                   	pop    %ebp
c01029f8:	c3                   	ret    

c01029f9 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c01029f9:	55                   	push   %ebp
c01029fa:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c01029fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ff:	a3 c4 ae 11 c0       	mov    %eax,0xc011aec4
}
c0102a04:	90                   	nop
c0102a05:	5d                   	pop    %ebp
c0102a06:	c3                   	ret    

c0102a07 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0102a07:	55                   	push   %ebp
c0102a08:	89 e5                	mov    %esp,%ebp
c0102a0a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0102a0d:	b8 00 70 11 c0       	mov    $0xc0117000,%eax
c0102a12:	89 04 24             	mov    %eax,(%esp)
c0102a15:	e8 df ff ff ff       	call   c01029f9 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0102a1a:	66 c7 05 c8 ae 11 c0 	movw   $0x10,0xc011aec8
c0102a21:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0102a23:	66 c7 05 28 7a 11 c0 	movw   $0x68,0xc0117a28
c0102a2a:	68 00 
c0102a2c:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102a31:	0f b7 c0             	movzwl %ax,%eax
c0102a34:	66 a3 2a 7a 11 c0    	mov    %ax,0xc0117a2a
c0102a3a:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102a3f:	c1 e8 10             	shr    $0x10,%eax
c0102a42:	a2 2c 7a 11 c0       	mov    %al,0xc0117a2c
c0102a47:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a4e:	24 f0                	and    $0xf0,%al
c0102a50:	0c 09                	or     $0x9,%al
c0102a52:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a57:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a5e:	24 ef                	and    $0xef,%al
c0102a60:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a65:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a6c:	24 9f                	and    $0x9f,%al
c0102a6e:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a73:	0f b6 05 2d 7a 11 c0 	movzbl 0xc0117a2d,%eax
c0102a7a:	0c 80                	or     $0x80,%al
c0102a7c:	a2 2d 7a 11 c0       	mov    %al,0xc0117a2d
c0102a81:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102a88:	24 f0                	and    $0xf0,%al
c0102a8a:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102a8f:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102a96:	24 ef                	and    $0xef,%al
c0102a98:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102a9d:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102aa4:	24 df                	and    $0xdf,%al
c0102aa6:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102aab:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ab2:	0c 40                	or     $0x40,%al
c0102ab4:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ab9:	0f b6 05 2e 7a 11 c0 	movzbl 0xc0117a2e,%eax
c0102ac0:	24 7f                	and    $0x7f,%al
c0102ac2:	a2 2e 7a 11 c0       	mov    %al,0xc0117a2e
c0102ac7:	b8 c0 ae 11 c0       	mov    $0xc011aec0,%eax
c0102acc:	c1 e8 18             	shr    $0x18,%eax
c0102acf:	a2 2f 7a 11 c0       	mov    %al,0xc0117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0102ad4:	c7 04 24 30 7a 11 c0 	movl   $0xc0117a30,(%esp)
c0102adb:	e8 e3 fe ff ff       	call   c01029c3 <lgdt>
c0102ae0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0102ae6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0102aea:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0102aed:	90                   	nop
c0102aee:	c9                   	leave  
c0102aef:	c3                   	ret    

c0102af0 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0102af0:	55                   	push   %ebp
c0102af1:	89 e5                	mov    %esp,%ebp
c0102af3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0102af6:	c7 05 90 af 11 c0 60 	movl   $0xc0107060,0xc011af90
c0102afd:	70 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0102b00:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102b05:	8b 00                	mov    (%eax),%eax
c0102b07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102b0b:	c7 04 24 d0 66 10 c0 	movl   $0xc01066d0,(%esp)
c0102b12:	e8 7b d7 ff ff       	call   c0100292 <cprintf>
    pmm_manager->init();
c0102b17:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102b1c:	8b 40 04             	mov    0x4(%eax),%eax
c0102b1f:	ff d0                	call   *%eax
}
c0102b21:	90                   	nop
c0102b22:	c9                   	leave  
c0102b23:	c3                   	ret    

c0102b24 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0102b24:	55                   	push   %ebp
c0102b25:	89 e5                	mov    %esp,%ebp
c0102b27:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0102b2a:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102b2f:	8b 40 08             	mov    0x8(%eax),%eax
c0102b32:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b35:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102b39:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b3c:	89 14 24             	mov    %edx,(%esp)
c0102b3f:	ff d0                	call   *%eax
}
c0102b41:	90                   	nop
c0102b42:	c9                   	leave  
c0102b43:	c3                   	ret    

c0102b44 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0102b44:	55                   	push   %ebp
c0102b45:	89 e5                	mov    %esp,%ebp
c0102b47:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0102b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b51:	e8 2f fe ff ff       	call   c0102985 <__intr_save>
c0102b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0102b59:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102b5e:	8b 40 0c             	mov    0xc(%eax),%eax
c0102b61:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b64:	89 14 24             	mov    %edx,(%esp)
c0102b67:	ff d0                	call   *%eax
c0102b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0102b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102b6f:	89 04 24             	mov    %eax,(%esp)
c0102b72:	e8 38 fe ff ff       	call   c01029af <__intr_restore>
    return page;
c0102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102b7a:	c9                   	leave  
c0102b7b:	c3                   	ret    

c0102b7c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0102b7c:	55                   	push   %ebp
c0102b7d:	89 e5                	mov    %esp,%ebp
c0102b7f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0102b82:	e8 fe fd ff ff       	call   c0102985 <__intr_save>
c0102b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0102b8a:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102b8f:	8b 40 10             	mov    0x10(%eax),%eax
c0102b92:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b95:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102b99:	8b 55 08             	mov    0x8(%ebp),%edx
c0102b9c:	89 14 24             	mov    %edx,(%esp)
c0102b9f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
c0102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ba4:	89 04 24             	mov    %eax,(%esp)
c0102ba7:	e8 03 fe ff ff       	call   c01029af <__intr_restore>
}
c0102bac:	90                   	nop
c0102bad:	c9                   	leave  
c0102bae:	c3                   	ret    

c0102baf <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0102baf:	55                   	push   %ebp
c0102bb0:	89 e5                	mov    %esp,%ebp
c0102bb2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0102bb5:	e8 cb fd ff ff       	call   c0102985 <__intr_save>
c0102bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0102bbd:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c0102bc2:	8b 40 14             	mov    0x14(%eax),%eax
c0102bc5:	ff d0                	call   *%eax
c0102bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0102bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102bcd:	89 04 24             	mov    %eax,(%esp)
c0102bd0:	e8 da fd ff ff       	call   c01029af <__intr_restore>
    return ret;
c0102bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0102bd8:	c9                   	leave  
c0102bd9:	c3                   	ret    

c0102bda <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0102bda:	55                   	push   %ebp
c0102bdb:	89 e5                	mov    %esp,%ebp
c0102bdd:	57                   	push   %edi
c0102bde:	56                   	push   %esi
c0102bdf:	53                   	push   %ebx
c0102be0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0102be6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0102bed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0102bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0102bfb:	c7 04 24 e7 66 10 c0 	movl   $0xc01066e7,(%esp)
c0102c02:	e8 8b d6 ff ff       	call   c0100292 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0102c07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102c0e:	e9 22 01 00 00       	jmp    c0102d35 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102c13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c16:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c19:	89 d0                	mov    %edx,%eax
c0102c1b:	c1 e0 02             	shl    $0x2,%eax
c0102c1e:	01 d0                	add    %edx,%eax
c0102c20:	c1 e0 02             	shl    $0x2,%eax
c0102c23:	01 c8                	add    %ecx,%eax
c0102c25:	8b 50 08             	mov    0x8(%eax),%edx
c0102c28:	8b 40 04             	mov    0x4(%eax),%eax
c0102c2b:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102c2e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102c31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c37:	89 d0                	mov    %edx,%eax
c0102c39:	c1 e0 02             	shl    $0x2,%eax
c0102c3c:	01 d0                	add    %edx,%eax
c0102c3e:	c1 e0 02             	shl    $0x2,%eax
c0102c41:	01 c8                	add    %ecx,%eax
c0102c43:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102c46:	8b 58 10             	mov    0x10(%eax),%ebx
c0102c49:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102c4c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102c4f:	01 c8                	add    %ecx,%eax
c0102c51:	11 da                	adc    %ebx,%edx
c0102c53:	89 45 98             	mov    %eax,-0x68(%ebp)
c0102c56:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0102c59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c5f:	89 d0                	mov    %edx,%eax
c0102c61:	c1 e0 02             	shl    $0x2,%eax
c0102c64:	01 d0                	add    %edx,%eax
c0102c66:	c1 e0 02             	shl    $0x2,%eax
c0102c69:	01 c8                	add    %ecx,%eax
c0102c6b:	83 c0 14             	add    $0x14,%eax
c0102c6e:	8b 00                	mov    (%eax),%eax
c0102c70:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0102c73:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102c76:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102c79:	83 c0 ff             	add    $0xffffffff,%eax
c0102c7c:	83 d2 ff             	adc    $0xffffffff,%edx
c0102c7f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
c0102c85:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
c0102c8b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102c8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102c91:	89 d0                	mov    %edx,%eax
c0102c93:	c1 e0 02             	shl    $0x2,%eax
c0102c96:	01 d0                	add    %edx,%eax
c0102c98:	c1 e0 02             	shl    $0x2,%eax
c0102c9b:	01 c8                	add    %ecx,%eax
c0102c9d:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102ca0:	8b 58 10             	mov    0x10(%eax),%ebx
c0102ca3:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102ca6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
c0102caa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0102cb0:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102cb6:	89 44 24 14          	mov    %eax,0x14(%esp)
c0102cba:	89 54 24 18          	mov    %edx,0x18(%esp)
c0102cbe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102cc1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102cc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102cc8:	89 54 24 10          	mov    %edx,0x10(%esp)
c0102ccc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0102cd0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0102cd4:	c7 04 24 f4 66 10 c0 	movl   $0xc01066f4,(%esp)
c0102cdb:	e8 b2 d5 ff ff       	call   c0100292 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0102ce0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102ce3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ce6:	89 d0                	mov    %edx,%eax
c0102ce8:	c1 e0 02             	shl    $0x2,%eax
c0102ceb:	01 d0                	add    %edx,%eax
c0102ced:	c1 e0 02             	shl    $0x2,%eax
c0102cf0:	01 c8                	add    %ecx,%eax
c0102cf2:	83 c0 14             	add    $0x14,%eax
c0102cf5:	8b 00                	mov    (%eax),%eax
c0102cf7:	83 f8 01             	cmp    $0x1,%eax
c0102cfa:	75 36                	jne    c0102d32 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
c0102cfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d02:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d05:	77 2b                	ja     c0102d32 <page_init+0x158>
c0102d07:	3b 55 9c             	cmp    -0x64(%ebp),%edx
c0102d0a:	72 05                	jb     c0102d11 <page_init+0x137>
c0102d0c:	3b 45 98             	cmp    -0x68(%ebp),%eax
c0102d0f:	73 21                	jae    c0102d32 <page_init+0x158>
c0102d11:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d15:	77 1b                	ja     c0102d32 <page_init+0x158>
c0102d17:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0102d1b:	72 09                	jb     c0102d26 <page_init+0x14c>
c0102d1d:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
c0102d24:	77 0c                	ja     c0102d32 <page_init+0x158>
                maxpa = end;
c0102d26:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d29:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102d2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0102d2f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
c0102d32:	ff 45 dc             	incl   -0x24(%ebp)
c0102d35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102d38:	8b 00                	mov    (%eax),%eax
c0102d3a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102d3d:	0f 8c d0 fe ff ff    	jl     c0102c13 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0102d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d47:	72 1d                	jb     c0102d66 <page_init+0x18c>
c0102d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0102d4d:	77 09                	ja     c0102d58 <page_init+0x17e>
c0102d4f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0102d56:	76 0e                	jbe    c0102d66 <page_init+0x18c>
        maxpa = KMEMSIZE;
c0102d58:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0102d5f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0102d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102d69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102d6c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102d70:	c1 ea 0c             	shr    $0xc,%edx
c0102d73:	89 c1                	mov    %eax,%ecx
c0102d75:	89 d3                	mov    %edx,%ebx
c0102d77:	89 c8                	mov    %ecx,%eax
c0102d79:	a3 a0 ae 11 c0       	mov    %eax,0xc011aea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0102d7e:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
c0102d85:	b8 a8 af 11 c0       	mov    $0xc011afa8,%eax
c0102d8a:	8d 50 ff             	lea    -0x1(%eax),%edx
c0102d8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102d90:	01 d0                	add    %edx,%eax
c0102d92:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102d95:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102d98:	ba 00 00 00 00       	mov    $0x0,%edx
c0102d9d:	f7 75 c0             	divl   -0x40(%ebp)
c0102da0:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102da3:	29 d0                	sub    %edx,%eax
c0102da5:	a3 98 af 11 c0       	mov    %eax,0xc011af98

    for (i = 0; i < npage; i ++) {
c0102daa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102db1:	eb 2e                	jmp    c0102de1 <page_init+0x207>
        SetPageReserved(pages + i);
c0102db3:	8b 0d 98 af 11 c0    	mov    0xc011af98,%ecx
c0102db9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102dbc:	89 d0                	mov    %edx,%eax
c0102dbe:	c1 e0 02             	shl    $0x2,%eax
c0102dc1:	01 d0                	add    %edx,%eax
c0102dc3:	c1 e0 02             	shl    $0x2,%eax
c0102dc6:	01 c8                	add    %ecx,%eax
c0102dc8:	83 c0 04             	add    $0x4,%eax
c0102dcb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
c0102dd2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dd5:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102dd8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102ddb:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
c0102dde:	ff 45 dc             	incl   -0x24(%ebp)
c0102de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102de4:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0102de9:	39 c2                	cmp    %eax,%edx
c0102deb:	72 c6                	jb     c0102db3 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0102ded:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0102df3:	89 d0                	mov    %edx,%eax
c0102df5:	c1 e0 02             	shl    $0x2,%eax
c0102df8:	01 d0                	add    %edx,%eax
c0102dfa:	c1 e0 02             	shl    $0x2,%eax
c0102dfd:	89 c2                	mov    %eax,%edx
c0102dff:	a1 98 af 11 c0       	mov    0xc011af98,%eax
c0102e04:	01 d0                	add    %edx,%eax
c0102e06:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0102e09:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c0102e10:	77 23                	ja     c0102e35 <page_init+0x25b>
c0102e12:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e15:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102e19:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0102e20:	c0 
c0102e21:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0102e28:	00 
c0102e29:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0102e30:	e8 b4 d5 ff ff       	call   c01003e9 <__panic>
c0102e35:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102e38:	05 00 00 00 40       	add    $0x40000000,%eax
c0102e3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0102e40:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0102e47:	e9 69 01 00 00       	jmp    c0102fb5 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0102e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e52:	89 d0                	mov    %edx,%eax
c0102e54:	c1 e0 02             	shl    $0x2,%eax
c0102e57:	01 d0                	add    %edx,%eax
c0102e59:	c1 e0 02             	shl    $0x2,%eax
c0102e5c:	01 c8                	add    %ecx,%eax
c0102e5e:	8b 50 08             	mov    0x8(%eax),%edx
c0102e61:	8b 40 04             	mov    0x4(%eax),%eax
c0102e64:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102e67:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0102e6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e70:	89 d0                	mov    %edx,%eax
c0102e72:	c1 e0 02             	shl    $0x2,%eax
c0102e75:	01 d0                	add    %edx,%eax
c0102e77:	c1 e0 02             	shl    $0x2,%eax
c0102e7a:	01 c8                	add    %ecx,%eax
c0102e7c:	8b 48 0c             	mov    0xc(%eax),%ecx
c0102e7f:	8b 58 10             	mov    0x10(%eax),%ebx
c0102e82:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102e85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102e88:	01 c8                	add    %ecx,%eax
c0102e8a:	11 da                	adc    %ebx,%edx
c0102e8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0102e8f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0102e92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0102e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102e98:	89 d0                	mov    %edx,%eax
c0102e9a:	c1 e0 02             	shl    $0x2,%eax
c0102e9d:	01 d0                	add    %edx,%eax
c0102e9f:	c1 e0 02             	shl    $0x2,%eax
c0102ea2:	01 c8                	add    %ecx,%eax
c0102ea4:	83 c0 14             	add    $0x14,%eax
c0102ea7:	8b 00                	mov    (%eax),%eax
c0102ea9:	83 f8 01             	cmp    $0x1,%eax
c0102eac:	0f 85 00 01 00 00    	jne    c0102fb2 <page_init+0x3d8>
            if (begin < freemem) {
c0102eb2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102eb5:	ba 00 00 00 00       	mov    $0x0,%edx
c0102eba:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102ebd:	77 17                	ja     c0102ed6 <page_init+0x2fc>
c0102ebf:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0102ec2:	72 05                	jb     c0102ec9 <page_init+0x2ef>
c0102ec4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0102ec7:	73 0d                	jae    c0102ed6 <page_init+0x2fc>
                begin = freemem;
c0102ec9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102ecc:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102ecf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0102ed6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102eda:	72 1d                	jb     c0102ef9 <page_init+0x31f>
c0102edc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102ee0:	77 09                	ja     c0102eeb <page_init+0x311>
c0102ee2:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0102ee9:	76 0e                	jbe    c0102ef9 <page_init+0x31f>
                end = KMEMSIZE;
c0102eeb:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0102ef2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0102ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102efc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102eff:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f02:	0f 87 aa 00 00 00    	ja     c0102fb2 <page_init+0x3d8>
c0102f08:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f0b:	72 09                	jb     c0102f16 <page_init+0x33c>
c0102f0d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f10:	0f 83 9c 00 00 00    	jae    c0102fb2 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
c0102f16:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
c0102f1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102f20:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102f23:	01 d0                	add    %edx,%eax
c0102f25:	48                   	dec    %eax
c0102f26:	89 45 ac             	mov    %eax,-0x54(%ebp)
c0102f29:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f2c:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f31:	f7 75 b0             	divl   -0x50(%ebp)
c0102f34:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102f37:	29 d0                	sub    %edx,%eax
c0102f39:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102f41:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0102f44:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f47:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102f4a:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102f4d:	ba 00 00 00 00       	mov    $0x0,%edx
c0102f52:	89 c3                	mov    %eax,%ebx
c0102f54:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
c0102f5a:	89 de                	mov    %ebx,%esi
c0102f5c:	89 d0                	mov    %edx,%eax
c0102f5e:	83 e0 00             	and    $0x0,%eax
c0102f61:	89 c7                	mov    %eax,%edi
c0102f63:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0102f66:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
c0102f69:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f72:	77 3e                	ja     c0102fb2 <page_init+0x3d8>
c0102f74:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0102f77:	72 05                	jb     c0102f7e <page_init+0x3a4>
c0102f79:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0102f7c:	73 34                	jae    c0102fb2 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0102f7e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f81:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f84:	2b 45 d0             	sub    -0x30(%ebp),%eax
c0102f87:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
c0102f8a:	89 c1                	mov    %eax,%ecx
c0102f8c:	89 d3                	mov    %edx,%ebx
c0102f8e:	89 c8                	mov    %ecx,%eax
c0102f90:	89 da                	mov    %ebx,%edx
c0102f92:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0102f96:	c1 ea 0c             	shr    $0xc,%edx
c0102f99:	89 c3                	mov    %eax,%ebx
c0102f9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f9e:	89 04 24             	mov    %eax,(%esp)
c0102fa1:	e8 a0 f8 ff ff       	call   c0102846 <pa2page>
c0102fa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102faa:	89 04 24             	mov    %eax,(%esp)
c0102fad:	e8 72 fb ff ff       	call   c0102b24 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
c0102fb2:	ff 45 dc             	incl   -0x24(%ebp)
c0102fb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102fb8:	8b 00                	mov    (%eax),%eax
c0102fba:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0102fbd:	0f 8c 89 fe ff ff    	jl     c0102e4c <page_init+0x272>
                }
            }
        }
    }
}
c0102fc3:	90                   	nop
c0102fc4:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0102fca:	5b                   	pop    %ebx
c0102fcb:	5e                   	pop    %esi
c0102fcc:	5f                   	pop    %edi
c0102fcd:	5d                   	pop    %ebp
c0102fce:	c3                   	ret    

c0102fcf <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0102fcf:	55                   	push   %ebp
c0102fd0:	89 e5                	mov    %esp,%ebp
c0102fd2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102fd8:	33 45 14             	xor    0x14(%ebp),%eax
c0102fdb:	25 ff 0f 00 00       	and    $0xfff,%eax
c0102fe0:	85 c0                	test   %eax,%eax
c0102fe2:	74 24                	je     c0103008 <boot_map_segment+0x39>
c0102fe4:	c7 44 24 0c 56 67 10 	movl   $0xc0106756,0xc(%esp)
c0102feb:	c0 
c0102fec:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0102ff3:	c0 
c0102ff4:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0102ffb:	00 
c0102ffc:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103003:	e8 e1 d3 ff ff       	call   c01003e9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0103008:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c010300f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103012:	25 ff 0f 00 00       	and    $0xfff,%eax
c0103017:	89 c2                	mov    %eax,%edx
c0103019:	8b 45 10             	mov    0x10(%ebp),%eax
c010301c:	01 c2                	add    %eax,%edx
c010301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103021:	01 d0                	add    %edx,%eax
c0103023:	48                   	dec    %eax
c0103024:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103027:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010302a:	ba 00 00 00 00       	mov    $0x0,%edx
c010302f:	f7 75 f0             	divl   -0x10(%ebp)
c0103032:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103035:	29 d0                	sub    %edx,%eax
c0103037:	c1 e8 0c             	shr    $0xc,%eax
c010303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c010303d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103040:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103043:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010304b:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c010304e:	8b 45 14             	mov    0x14(%ebp),%eax
c0103051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010305c:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010305f:	eb 68                	jmp    c01030c9 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0103061:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0103068:	00 
c0103069:	8b 45 0c             	mov    0xc(%ebp),%eax
c010306c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103070:	8b 45 08             	mov    0x8(%ebp),%eax
c0103073:	89 04 24             	mov    %eax,(%esp)
c0103076:	e8 81 01 00 00       	call   c01031fc <get_pte>
c010307b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c010307e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0103082:	75 24                	jne    c01030a8 <boot_map_segment+0xd9>
c0103084:	c7 44 24 0c 82 67 10 	movl   $0xc0106782,0xc(%esp)
c010308b:	c0 
c010308c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103093:	c0 
c0103094:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010309b:	00 
c010309c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01030a3:	e8 41 d3 ff ff       	call   c01003e9 <__panic>
        *ptep = pa | PTE_P | perm;
c01030a8:	8b 45 14             	mov    0x14(%ebp),%eax
c01030ab:	0b 45 18             	or     0x18(%ebp),%eax
c01030ae:	83 c8 01             	or     $0x1,%eax
c01030b1:	89 c2                	mov    %eax,%edx
c01030b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01030b6:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01030b8:	ff 4d f4             	decl   -0xc(%ebp)
c01030bb:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01030c2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01030c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030cd:	75 92                	jne    c0103061 <boot_map_segment+0x92>
    }
}
c01030cf:	90                   	nop
c01030d0:	c9                   	leave  
c01030d1:	c3                   	ret    

c01030d2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01030d2:	55                   	push   %ebp
c01030d3:	89 e5                	mov    %esp,%ebp
c01030d5:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01030d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030df:	e8 60 fa ff ff       	call   c0102b44 <alloc_pages>
c01030e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01030eb:	75 1c                	jne    c0103109 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01030ed:	c7 44 24 08 8f 67 10 	movl   $0xc010678f,0x8(%esp)
c01030f4:	c0 
c01030f5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01030fc:	00 
c01030fd:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103104:	e8 e0 d2 ff ff       	call   c01003e9 <__panic>
    }
    return page2kva(p);
c0103109:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010310c:	89 04 24             	mov    %eax,(%esp)
c010310f:	e8 81 f7 ff ff       	call   c0102895 <page2kva>
}
c0103114:	c9                   	leave  
c0103115:	c3                   	ret    

c0103116 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0103116:	55                   	push   %ebp
c0103117:	89 e5                	mov    %esp,%ebp
c0103119:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
c010311c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103121:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103124:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010312b:	77 23                	ja     c0103150 <pmm_init+0x3a>
c010312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103130:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103134:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c010313b:	c0 
c010313c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0103143:	00 
c0103144:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010314b:	e8 99 d2 ff ff       	call   c01003e9 <__panic>
c0103150:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103153:	05 00 00 00 40       	add    $0x40000000,%eax
c0103158:	a3 94 af 11 c0       	mov    %eax,0xc011af94
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c010315d:	e8 8e f9 ff ff       	call   c0102af0 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0103162:	e8 73 fa ff ff       	call   c0102bda <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0103167:	e8 18 04 00 00       	call   c0103584 <check_alloc_page>

    check_pgdir();
c010316c:	e8 32 04 00 00       	call   c01035a3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0103171:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103176:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103179:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103180:	77 23                	ja     c01031a5 <pmm_init+0x8f>
c0103182:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103185:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103189:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103190:	c0 
c0103191:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0103198:	00 
c0103199:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01031a0:	e8 44 d2 ff ff       	call   c01003e9 <__panic>
c01031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031a8:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c01031ae:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01031b3:	05 ac 0f 00 00       	add    $0xfac,%eax
c01031b8:	83 ca 03             	or     $0x3,%edx
c01031bb:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01031bd:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01031c2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01031c9:	00 
c01031ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01031d1:	00 
c01031d2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01031d9:	38 
c01031da:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01031e1:	c0 
c01031e2:	89 04 24             	mov    %eax,(%esp)
c01031e5:	e8 e5 fd ff ff       	call   c0102fcf <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c01031ea:	e8 18 f8 ff ff       	call   c0102a07 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c01031ef:	e8 4b 0a 00 00       	call   c0103c3f <check_boot_pgdir>

    print_pgdir();
c01031f4:	e8 c4 0e 00 00       	call   c01040bd <print_pgdir>

}
c01031f9:	90                   	nop
c01031fa:	c9                   	leave  
c01031fb:	c3                   	ret    

c01031fc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01031fc:	55                   	push   %ebp
c01031fd:	89 e5                	mov    %esp,%ebp
c01031ff:	83 ec 48             	sub    $0x48,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
      // (1) find page directory entry
    pde_t *pde = &pgdir[PDX(la)];
c0103202:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103205:	c1 e8 16             	shr    $0x16,%eax
c0103208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010320f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103212:	01 d0                	add    %edx,%eax
c0103214:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pde & PTE_P)) {
c0103217:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010321a:	8b 00                	mov    (%eax),%eax
c010321c:	83 e0 01             	and    $0x1,%eax
c010321f:	85 c0                	test   %eax,%eax
c0103221:	0f 85 b9 00 00 00    	jne    c01032e0 <get_pte+0xe4>
        if(!create)
c0103227:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010322b:	75 0a                	jne    c0103237 <get_pte+0x3b>
            return NULL;
c010322d:	b8 00 00 00 00       	mov    $0x0,%eax
c0103232:	e9 14 01 00 00       	jmp    c010334b <get_pte+0x14f>
        else {
            struct Page *p;
            p = alloc_page();
c0103237:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010323e:	e8 01 f9 ff ff       	call   c0102b44 <alloc_pages>
c0103243:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(p == NULL) {
c0103246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010324a:	75 0a                	jne    c0103256 <get_pte+0x5a>
                return NULL;
c010324c:	b8 00 00 00 00       	mov    $0x0,%eax
c0103251:	e9 f5 00 00 00       	jmp    c010334b <get_pte+0x14f>
            }
            set_page_ref(p, 1);
c0103256:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010325d:	00 
c010325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103261:	89 04 24             	mov    %eax,(%esp)
c0103264:	e8 e0 f6 ff ff       	call   c0102949 <set_page_ref>
            uintptr_t pa = page2pa(p);
c0103269:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010326c:	89 04 24             	mov    %eax,(%esp)
c010326f:	e8 bc f5 ff ff       	call   c0102830 <page2pa>
c0103274:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);
c0103277:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010327a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103280:	c1 e8 0c             	shr    $0xc,%eax
c0103283:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103286:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c010328b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010328e:	72 23                	jb     c01032b3 <get_pte+0xb7>
c0103290:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103293:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103297:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c010329e:	c0 
c010329f:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c01032a6:	00 
c01032a7:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01032ae:	e8 36 d1 ff ff       	call   c01003e9 <__panic>
c01032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01032b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01032bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01032c2:	00 
c01032c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01032ca:	00 
c01032cb:	89 04 24             	mov    %eax,(%esp)
c01032ce:	e8 2f 24 00 00       	call   c0105702 <memset>
            *pde = pa | PTE_P | PTE_U | PTE_W;
c01032d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01032d6:	83 c8 07             	or     $0x7,%eax
c01032d9:	89 c2                	mov    %eax,%edx
c01032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032de:	89 10                	mov    %edx,(%eax)
        }
    }
    pte_t *pte_base = (pte_t *)KADDR(PDE_ADDR(*pde));
c01032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01032e3:	8b 00                	mov    (%eax),%eax
c01032e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01032ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01032ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032f0:	c1 e8 0c             	shr    $0xc,%eax
c01032f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01032f6:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01032fb:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032fe:	72 23                	jb     c0103323 <get_pte+0x127>
c0103300:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103303:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103307:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c010330e:	c0 
c010330f:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
c0103316:	00 
c0103317:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010331e:	e8 c6 d0 ff ff       	call   c01003e9 <__panic>
c0103323:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103326:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010332b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t *pte_p = &pte_base[PTX(la)];
c010332e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103331:	c1 e8 0c             	shr    $0xc,%eax
c0103334:	25 ff 03 00 00       	and    $0x3ff,%eax
c0103339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0103340:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103343:	01 d0                	add    %edx,%eax
c0103345:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return pte_p;          // (8) return page table entry
c0103348:	8b 45 d4             	mov    -0x2c(%ebp),%eax

}
c010334b:	c9                   	leave  
c010334c:	c3                   	ret    

c010334d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010334d:	55                   	push   %ebp
c010334e:	89 e5                	mov    %esp,%ebp
c0103350:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103353:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010335a:	00 
c010335b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010335e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103362:	8b 45 08             	mov    0x8(%ebp),%eax
c0103365:	89 04 24             	mov    %eax,(%esp)
c0103368:	e8 8f fe ff ff       	call   c01031fc <get_pte>
c010336d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0103370:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0103374:	74 08                	je     c010337e <get_page+0x31>
        *ptep_store = ptep;
c0103376:	8b 45 10             	mov    0x10(%ebp),%eax
c0103379:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010337c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c010337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103382:	74 1b                	je     c010339f <get_page+0x52>
c0103384:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103387:	8b 00                	mov    (%eax),%eax
c0103389:	83 e0 01             	and    $0x1,%eax
c010338c:	85 c0                	test   %eax,%eax
c010338e:	74 0f                	je     c010339f <get_page+0x52>
        return pte2page(*ptep);
c0103390:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103393:	8b 00                	mov    (%eax),%eax
c0103395:	89 04 24             	mov    %eax,(%esp)
c0103398:	e8 4c f5 ff ff       	call   c01028e9 <pte2page>
c010339d:	eb 05                	jmp    c01033a4 <get_page+0x57>
    }
    return NULL;
c010339f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01033a4:	c9                   	leave  
c01033a5:	c3                   	ret    

c01033a6 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01033a6:	55                   	push   %ebp
c01033a7:	89 e5                	mov    %esp,%ebp
c01033a9:	83 ec 28             	sub    $0x28,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    pte_t *pte = get_pte(pgdir, la, 0);
c01033ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01033b3:	00 
c01033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01033b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01033bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01033be:	89 04 24             	mov    %eax,(%esp)
c01033c1:	e8 36 fe ff ff       	call   c01031fc <get_pte>
c01033c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (*pte & PTE_P) {                      //(1) check if this page table entry is present
c01033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033cc:	8b 00                	mov    (%eax),%eax
c01033ce:	83 e0 01             	and    $0x1,%eax
c01033d1:	85 c0                	test   %eax,%eax
c01033d3:	74 52                	je     c0103427 <page_remove_pte+0x81>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
c01033d5:	8b 45 10             	mov    0x10(%ebp),%eax
c01033d8:	8b 00                	mov    (%eax),%eax
c01033da:	89 04 24             	mov    %eax,(%esp)
c01033dd:	e8 07 f5 ff ff       	call   c01028e9 <pte2page>
c01033e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        page_ref_dec(page);        //(3) decrease page reference
c01033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033e8:	89 04 24             	mov    %eax,(%esp)
c01033eb:	e8 7e f5 ff ff       	call   c010296e <page_ref_dec>
        if(page->ref == 0) {
c01033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01033f3:	8b 00                	mov    (%eax),%eax
c01033f5:	85 c0                	test   %eax,%eax
c01033f7:	75 13                	jne    c010340c <page_remove_pte+0x66>
            free_page(page);
c01033f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103400:	00 
c0103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103404:	89 04 24             	mov    %eax,(%esp)
c0103407:	e8 70 f7 ff ff       	call   c0102b7c <free_pages>
        }                          //(4) and free this page when page reference reachs 0
        *pte = 0;                           //(5) clear second page table entry
c010340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010340f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
c0103415:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103418:	89 44 24 04          	mov    %eax,0x4(%esp)
c010341c:	8b 45 08             	mov    0x8(%ebp),%eax
c010341f:	89 04 24             	mov    %eax,(%esp)
c0103422:	e8 01 01 00 00       	call   c0103528 <tlb_invalidate>
    }

}
c0103427:	90                   	nop
c0103428:	c9                   	leave  
c0103429:	c3                   	ret    

c010342a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010342a:	55                   	push   %ebp
c010342b:	89 e5                	mov    %esp,%ebp
c010342d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0103430:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103437:	00 
c0103438:	8b 45 0c             	mov    0xc(%ebp),%eax
c010343b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010343f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103442:	89 04 24             	mov    %eax,(%esp)
c0103445:	e8 b2 fd ff ff       	call   c01031fc <get_pte>
c010344a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010344d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103451:	74 19                	je     c010346c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0103453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103456:	89 44 24 08          	mov    %eax,0x8(%esp)
c010345a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010345d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103461:	8b 45 08             	mov    0x8(%ebp),%eax
c0103464:	89 04 24             	mov    %eax,(%esp)
c0103467:	e8 3a ff ff ff       	call   c01033a6 <page_remove_pte>
    }
}
c010346c:	90                   	nop
c010346d:	c9                   	leave  
c010346e:	c3                   	ret    

c010346f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010346f:	55                   	push   %ebp
c0103470:	89 e5                	mov    %esp,%ebp
c0103472:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0103475:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010347c:	00 
c010347d:	8b 45 10             	mov    0x10(%ebp),%eax
c0103480:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103484:	8b 45 08             	mov    0x8(%ebp),%eax
c0103487:	89 04 24             	mov    %eax,(%esp)
c010348a:	e8 6d fd ff ff       	call   c01031fc <get_pte>
c010348f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0103492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103496:	75 0a                	jne    c01034a2 <page_insert+0x33>
        return -E_NO_MEM;
c0103498:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010349d:	e9 84 00 00 00       	jmp    c0103526 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01034a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034a5:	89 04 24             	mov    %eax,(%esp)
c01034a8:	e8 aa f4 ff ff       	call   c0102957 <page_ref_inc>
    if (*ptep & PTE_P) {
c01034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034b0:	8b 00                	mov    (%eax),%eax
c01034b2:	83 e0 01             	and    $0x1,%eax
c01034b5:	85 c0                	test   %eax,%eax
c01034b7:	74 3e                	je     c01034f7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034bc:	8b 00                	mov    (%eax),%eax
c01034be:	89 04 24             	mov    %eax,(%esp)
c01034c1:	e8 23 f4 ff ff       	call   c01028e9 <pte2page>
c01034c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01034cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01034cf:	75 0d                	jne    c01034de <page_insert+0x6f>
            page_ref_dec(page);
c01034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034d4:	89 04 24             	mov    %eax,(%esp)
c01034d7:	e8 92 f4 ff ff       	call   c010296e <page_ref_dec>
c01034dc:	eb 19                	jmp    c01034f7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01034e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01034e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01034e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01034ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ef:	89 04 24             	mov    %eax,(%esp)
c01034f2:	e8 af fe ff ff       	call   c01033a6 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034fa:	89 04 24             	mov    %eax,(%esp)
c01034fd:	e8 2e f3 ff ff       	call   c0102830 <page2pa>
c0103502:	0b 45 14             	or     0x14(%ebp),%eax
c0103505:	83 c8 01             	or     $0x1,%eax
c0103508:	89 c2                	mov    %eax,%edx
c010350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010350d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010350f:	8b 45 10             	mov    0x10(%ebp),%eax
c0103512:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103516:	8b 45 08             	mov    0x8(%ebp),%eax
c0103519:	89 04 24             	mov    %eax,(%esp)
c010351c:	e8 07 00 00 00       	call   c0103528 <tlb_invalidate>
    return 0;
c0103521:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103526:	c9                   	leave  
c0103527:	c3                   	ret    

c0103528 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0103528:	55                   	push   %ebp
c0103529:	89 e5                	mov    %esp,%ebp
c010352b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010352e:	0f 20 d8             	mov    %cr3,%eax
c0103531:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
c0103534:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
c0103537:	8b 45 08             	mov    0x8(%ebp),%eax
c010353a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010353d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0103544:	77 23                	ja     c0103569 <tlb_invalidate+0x41>
c0103546:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103549:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010354d:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103554:	c0 
c0103555:	c7 44 24 04 ce 01 00 	movl   $0x1ce,0x4(%esp)
c010355c:	00 
c010355d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103564:	e8 80 ce ff ff       	call   c01003e9 <__panic>
c0103569:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356c:	05 00 00 00 40       	add    $0x40000000,%eax
c0103571:	39 d0                	cmp    %edx,%eax
c0103573:	75 0c                	jne    c0103581 <tlb_invalidate+0x59>
        invlpg((void *)la);
c0103575:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103578:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010357b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010357e:	0f 01 38             	invlpg (%eax)
    }
}
c0103581:	90                   	nop
c0103582:	c9                   	leave  
c0103583:	c3                   	ret    

c0103584 <check_alloc_page>:

static void
check_alloc_page(void) {
c0103584:	55                   	push   %ebp
c0103585:	89 e5                	mov    %esp,%ebp
c0103587:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010358a:	a1 90 af 11 c0       	mov    0xc011af90,%eax
c010358f:	8b 40 18             	mov    0x18(%eax),%eax
c0103592:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0103594:	c7 04 24 a8 67 10 c0 	movl   $0xc01067a8,(%esp)
c010359b:	e8 f2 cc ff ff       	call   c0100292 <cprintf>
}
c01035a0:	90                   	nop
c01035a1:	c9                   	leave  
c01035a2:	c3                   	ret    

c01035a3 <check_pgdir>:

static void
check_pgdir(void) {
c01035a3:	55                   	push   %ebp
c01035a4:	89 e5                	mov    %esp,%ebp
c01035a6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c01035a9:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c01035ae:	3d 00 80 03 00       	cmp    $0x38000,%eax
c01035b3:	76 24                	jbe    c01035d9 <check_pgdir+0x36>
c01035b5:	c7 44 24 0c c7 67 10 	movl   $0xc01067c7,0xc(%esp)
c01035bc:	c0 
c01035bd:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01035c4:	c0 
c01035c5:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
c01035cc:	00 
c01035cd:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01035d4:	e8 10 ce ff ff       	call   c01003e9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c01035d9:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01035de:	85 c0                	test   %eax,%eax
c01035e0:	74 0e                	je     c01035f0 <check_pgdir+0x4d>
c01035e2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01035e7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01035ec:	85 c0                	test   %eax,%eax
c01035ee:	74 24                	je     c0103614 <check_pgdir+0x71>
c01035f0:	c7 44 24 0c e4 67 10 	movl   $0xc01067e4,0xc(%esp)
c01035f7:	c0 
c01035f8:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01035ff:	c0 
c0103600:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
c0103607:	00 
c0103608:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010360f:	e8 d5 cd ff ff       	call   c01003e9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0103614:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103619:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103620:	00 
c0103621:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103628:	00 
c0103629:	89 04 24             	mov    %eax,(%esp)
c010362c:	e8 1c fd ff ff       	call   c010334d <get_page>
c0103631:	85 c0                	test   %eax,%eax
c0103633:	74 24                	je     c0103659 <check_pgdir+0xb6>
c0103635:	c7 44 24 0c 1c 68 10 	movl   $0xc010681c,0xc(%esp)
c010363c:	c0 
c010363d:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103644:	c0 
c0103645:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
c010364c:	00 
c010364d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103654:	e8 90 cd ff ff       	call   c01003e9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0103659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103660:	e8 df f4 ff ff       	call   c0102b44 <alloc_pages>
c0103665:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0103668:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010366d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103674:	00 
c0103675:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010367c:	00 
c010367d:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103680:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103684:	89 04 24             	mov    %eax,(%esp)
c0103687:	e8 e3 fd ff ff       	call   c010346f <page_insert>
c010368c:	85 c0                	test   %eax,%eax
c010368e:	74 24                	je     c01036b4 <check_pgdir+0x111>
c0103690:	c7 44 24 0c 44 68 10 	movl   $0xc0106844,0xc(%esp)
c0103697:	c0 
c0103698:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010369f:	c0 
c01036a0:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
c01036a7:	00 
c01036a8:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01036af:	e8 35 cd ff ff       	call   c01003e9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c01036b4:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01036b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01036c0:	00 
c01036c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036c8:	00 
c01036c9:	89 04 24             	mov    %eax,(%esp)
c01036cc:	e8 2b fb ff ff       	call   c01031fc <get_pte>
c01036d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01036d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01036d8:	75 24                	jne    c01036fe <check_pgdir+0x15b>
c01036da:	c7 44 24 0c 70 68 10 	movl   $0xc0106870,0xc(%esp)
c01036e1:	c0 
c01036e2:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01036e9:	c0 
c01036ea:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
c01036f1:	00 
c01036f2:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01036f9:	e8 eb cc ff ff       	call   c01003e9 <__panic>
    assert(pte2page(*ptep) == p1);
c01036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103701:	8b 00                	mov    (%eax),%eax
c0103703:	89 04 24             	mov    %eax,(%esp)
c0103706:	e8 de f1 ff ff       	call   c01028e9 <pte2page>
c010370b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010370e:	74 24                	je     c0103734 <check_pgdir+0x191>
c0103710:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103717:	c0 
c0103718:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c010371f:	c0 
c0103720:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
c0103727:	00 
c0103728:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c010372f:	e8 b5 cc ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p1) == 1);
c0103734:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103737:	89 04 24             	mov    %eax,(%esp)
c010373a:	e8 00 f2 ff ff       	call   c010293f <page_ref>
c010373f:	83 f8 01             	cmp    $0x1,%eax
c0103742:	74 24                	je     c0103768 <check_pgdir+0x1c5>
c0103744:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c010374b:	c0 
c010374c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103753:	c0 
c0103754:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c010375b:	00 
c010375c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103763:	e8 81 cc ff ff       	call   c01003e9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0103768:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010376d:	8b 00                	mov    (%eax),%eax
c010376f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103774:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103777:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010377a:	c1 e8 0c             	shr    $0xc,%eax
c010377d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0103780:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103785:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0103788:	72 23                	jb     c01037ad <check_pgdir+0x20a>
c010378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010378d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103791:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0103798:	c0 
c0103799:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
c01037a0:	00 
c01037a1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01037a8:	e8 3c cc ff ff       	call   c01003e9 <__panic>
c01037ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01037b5:	83 c0 04             	add    $0x4,%eax
c01037b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c01037bb:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c01037c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01037c7:	00 
c01037c8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01037cf:	00 
c01037d0:	89 04 24             	mov    %eax,(%esp)
c01037d3:	e8 24 fa ff ff       	call   c01031fc <get_pte>
c01037d8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01037db:	74 24                	je     c0103801 <check_pgdir+0x25e>
c01037dd:	c7 44 24 0c c8 68 10 	movl   $0xc01068c8,0xc(%esp)
c01037e4:	c0 
c01037e5:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01037ec:	c0 
c01037ed:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
c01037f4:	00 
c01037f5:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01037fc:	e8 e8 cb ff ff       	call   c01003e9 <__panic>

    p2 = alloc_page();
c0103801:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103808:	e8 37 f3 ff ff       	call   c0102b44 <alloc_pages>
c010380d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0103810:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103815:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c010381c:	00 
c010381d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103824:	00 
c0103825:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103828:	89 54 24 04          	mov    %edx,0x4(%esp)
c010382c:	89 04 24             	mov    %eax,(%esp)
c010382f:	e8 3b fc ff ff       	call   c010346f <page_insert>
c0103834:	85 c0                	test   %eax,%eax
c0103836:	74 24                	je     c010385c <check_pgdir+0x2b9>
c0103838:	c7 44 24 0c f0 68 10 	movl   $0xc01068f0,0xc(%esp)
c010383f:	c0 
c0103840:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103847:	c0 
c0103848:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c010384f:	00 
c0103850:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103857:	e8 8d cb ff ff       	call   c01003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010385c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103861:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103868:	00 
c0103869:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103870:	00 
c0103871:	89 04 24             	mov    %eax,(%esp)
c0103874:	e8 83 f9 ff ff       	call   c01031fc <get_pte>
c0103879:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010387c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103880:	75 24                	jne    c01038a6 <check_pgdir+0x303>
c0103882:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c0103889:	c0 
c010388a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103891:	c0 
c0103892:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
c0103899:	00 
c010389a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038a1:	e8 43 cb ff ff       	call   c01003e9 <__panic>
    assert(*ptep & PTE_U);
c01038a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038a9:	8b 00                	mov    (%eax),%eax
c01038ab:	83 e0 04             	and    $0x4,%eax
c01038ae:	85 c0                	test   %eax,%eax
c01038b0:	75 24                	jne    c01038d6 <check_pgdir+0x333>
c01038b2:	c7 44 24 0c 58 69 10 	movl   $0xc0106958,0xc(%esp)
c01038b9:	c0 
c01038ba:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038c1:	c0 
c01038c2:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
c01038c9:	00 
c01038ca:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01038d1:	e8 13 cb ff ff       	call   c01003e9 <__panic>
    assert(*ptep & PTE_W);
c01038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038d9:	8b 00                	mov    (%eax),%eax
c01038db:	83 e0 02             	and    $0x2,%eax
c01038de:	85 c0                	test   %eax,%eax
c01038e0:	75 24                	jne    c0103906 <check_pgdir+0x363>
c01038e2:	c7 44 24 0c 66 69 10 	movl   $0xc0106966,0xc(%esp)
c01038e9:	c0 
c01038ea:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01038f1:	c0 
c01038f2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
c01038f9:	00 
c01038fa:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103901:	e8 e3 ca ff ff       	call   c01003e9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0103906:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c010390b:	8b 00                	mov    (%eax),%eax
c010390d:	83 e0 04             	and    $0x4,%eax
c0103910:	85 c0                	test   %eax,%eax
c0103912:	75 24                	jne    c0103938 <check_pgdir+0x395>
c0103914:	c7 44 24 0c 74 69 10 	movl   $0xc0106974,0xc(%esp)
c010391b:	c0 
c010391c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103923:	c0 
c0103924:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
c010392b:	00 
c010392c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103933:	e8 b1 ca ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 1);
c0103938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010393b:	89 04 24             	mov    %eax,(%esp)
c010393e:	e8 fc ef ff ff       	call   c010293f <page_ref>
c0103943:	83 f8 01             	cmp    $0x1,%eax
c0103946:	74 24                	je     c010396c <check_pgdir+0x3c9>
c0103948:	c7 44 24 0c 8a 69 10 	movl   $0xc010698a,0xc(%esp)
c010394f:	c0 
c0103950:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103957:	c0 
c0103958:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
c010395f:	00 
c0103960:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103967:	e8 7d ca ff ff       	call   c01003e9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010396c:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103971:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0103978:	00 
c0103979:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0103980:	00 
c0103981:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103984:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103988:	89 04 24             	mov    %eax,(%esp)
c010398b:	e8 df fa ff ff       	call   c010346f <page_insert>
c0103990:	85 c0                	test   %eax,%eax
c0103992:	74 24                	je     c01039b8 <check_pgdir+0x415>
c0103994:	c7 44 24 0c 9c 69 10 	movl   $0xc010699c,0xc(%esp)
c010399b:	c0 
c010399c:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01039a3:	c0 
c01039a4:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
c01039ab:	00 
c01039ac:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01039b3:	e8 31 ca ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p1) == 2);
c01039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039bb:	89 04 24             	mov    %eax,(%esp)
c01039be:	e8 7c ef ff ff       	call   c010293f <page_ref>
c01039c3:	83 f8 02             	cmp    $0x2,%eax
c01039c6:	74 24                	je     c01039ec <check_pgdir+0x449>
c01039c8:	c7 44 24 0c c8 69 10 	movl   $0xc01069c8,0xc(%esp)
c01039cf:	c0 
c01039d0:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c01039d7:	c0 
c01039d8:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
c01039df:	00 
c01039e0:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c01039e7:	e8 fd c9 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c01039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01039ef:	89 04 24             	mov    %eax,(%esp)
c01039f2:	e8 48 ef ff ff       	call   c010293f <page_ref>
c01039f7:	85 c0                	test   %eax,%eax
c01039f9:	74 24                	je     c0103a1f <check_pgdir+0x47c>
c01039fb:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103a02:	c0 
c0103a03:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a0a:	c0 
c0103a0b:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
c0103a12:	00 
c0103a13:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a1a:	e8 ca c9 ff ff       	call   c01003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0103a1f:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103a24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103a2b:	00 
c0103a2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103a33:	00 
c0103a34:	89 04 24             	mov    %eax,(%esp)
c0103a37:	e8 c0 f7 ff ff       	call   c01031fc <get_pte>
c0103a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103a3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103a43:	75 24                	jne    c0103a69 <check_pgdir+0x4c6>
c0103a45:	c7 44 24 0c 28 69 10 	movl   $0xc0106928,0xc(%esp)
c0103a4c:	c0 
c0103a4d:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a54:	c0 
c0103a55:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
c0103a5c:	00 
c0103a5d:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a64:	e8 80 c9 ff ff       	call   c01003e9 <__panic>
    assert(pte2page(*ptep) == p1);
c0103a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a6c:	8b 00                	mov    (%eax),%eax
c0103a6e:	89 04 24             	mov    %eax,(%esp)
c0103a71:	e8 73 ee ff ff       	call   c01028e9 <pte2page>
c0103a76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c0103a79:	74 24                	je     c0103a9f <check_pgdir+0x4fc>
c0103a7b:	c7 44 24 0c 9d 68 10 	movl   $0xc010689d,0xc(%esp)
c0103a82:	c0 
c0103a83:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103a8a:	c0 
c0103a8b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
c0103a92:	00 
c0103a93:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103a9a:	e8 4a c9 ff ff       	call   c01003e9 <__panic>
    assert((*ptep & PTE_U) == 0);
c0103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103aa2:	8b 00                	mov    (%eax),%eax
c0103aa4:	83 e0 04             	and    $0x4,%eax
c0103aa7:	85 c0                	test   %eax,%eax
c0103aa9:	74 24                	je     c0103acf <check_pgdir+0x52c>
c0103aab:	c7 44 24 0c ec 69 10 	movl   $0xc01069ec,0xc(%esp)
c0103ab2:	c0 
c0103ab3:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103aba:	c0 
c0103abb:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0103ac2:	00 
c0103ac3:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103aca:	e8 1a c9 ff ff       	call   c01003e9 <__panic>

    page_remove(boot_pgdir, 0x0);
c0103acf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103ad4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103adb:	00 
c0103adc:	89 04 24             	mov    %eax,(%esp)
c0103adf:	e8 46 f9 ff ff       	call   c010342a <page_remove>
    assert(page_ref(p1) == 1);
c0103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ae7:	89 04 24             	mov    %eax,(%esp)
c0103aea:	e8 50 ee ff ff       	call   c010293f <page_ref>
c0103aef:	83 f8 01             	cmp    $0x1,%eax
c0103af2:	74 24                	je     c0103b18 <check_pgdir+0x575>
c0103af4:	c7 44 24 0c b3 68 10 	movl   $0xc01068b3,0xc(%esp)
c0103afb:	c0 
c0103afc:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b03:	c0 
c0103b04:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0103b0b:	00 
c0103b0c:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b13:	e8 d1 c8 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c0103b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b1b:	89 04 24             	mov    %eax,(%esp)
c0103b1e:	e8 1c ee ff ff       	call   c010293f <page_ref>
c0103b23:	85 c0                	test   %eax,%eax
c0103b25:	74 24                	je     c0103b4b <check_pgdir+0x5a8>
c0103b27:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103b2e:	c0 
c0103b2f:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b36:	c0 
c0103b37:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0103b3e:	00 
c0103b3f:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b46:	e8 9e c8 ff ff       	call   c01003e9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0103b4b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103b50:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0103b57:	00 
c0103b58:	89 04 24             	mov    %eax,(%esp)
c0103b5b:	e8 ca f8 ff ff       	call   c010342a <page_remove>
    assert(page_ref(p1) == 0);
c0103b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b63:	89 04 24             	mov    %eax,(%esp)
c0103b66:	e8 d4 ed ff ff       	call   c010293f <page_ref>
c0103b6b:	85 c0                	test   %eax,%eax
c0103b6d:	74 24                	je     c0103b93 <check_pgdir+0x5f0>
c0103b6f:	c7 44 24 0c 01 6a 10 	movl   $0xc0106a01,0xc(%esp)
c0103b76:	c0 
c0103b77:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103b7e:	c0 
c0103b7f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0103b86:	00 
c0103b87:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103b8e:	e8 56 c8 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p2) == 0);
c0103b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b96:	89 04 24             	mov    %eax,(%esp)
c0103b99:	e8 a1 ed ff ff       	call   c010293f <page_ref>
c0103b9e:	85 c0                	test   %eax,%eax
c0103ba0:	74 24                	je     c0103bc6 <check_pgdir+0x623>
c0103ba2:	c7 44 24 0c da 69 10 	movl   $0xc01069da,0xc(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103bb1:	c0 
c0103bb2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
c0103bb9:	00 
c0103bba:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103bc1:	e8 23 c8 ff ff       	call   c01003e9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0103bc6:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103bcb:	8b 00                	mov    (%eax),%eax
c0103bcd:	89 04 24             	mov    %eax,(%esp)
c0103bd0:	e8 52 ed ff ff       	call   c0102927 <pde2page>
c0103bd5:	89 04 24             	mov    %eax,(%esp)
c0103bd8:	e8 62 ed ff ff       	call   c010293f <page_ref>
c0103bdd:	83 f8 01             	cmp    $0x1,%eax
c0103be0:	74 24                	je     c0103c06 <check_pgdir+0x663>
c0103be2:	c7 44 24 0c 14 6a 10 	movl   $0xc0106a14,0xc(%esp)
c0103be9:	c0 
c0103bea:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103bf1:	c0 
c0103bf2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0103bf9:	00 
c0103bfa:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c01:	e8 e3 c7 ff ff       	call   c01003e9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0103c06:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c0b:	8b 00                	mov    (%eax),%eax
c0103c0d:	89 04 24             	mov    %eax,(%esp)
c0103c10:	e8 12 ed ff ff       	call   c0102927 <pde2page>
c0103c15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103c1c:	00 
c0103c1d:	89 04 24             	mov    %eax,(%esp)
c0103c20:	e8 57 ef ff ff       	call   c0102b7c <free_pages>
    boot_pgdir[0] = 0;
c0103c25:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0103c30:	c7 04 24 3b 6a 10 c0 	movl   $0xc0106a3b,(%esp)
c0103c37:	e8 56 c6 ff ff       	call   c0100292 <cprintf>
}
c0103c3c:	90                   	nop
c0103c3d:	c9                   	leave  
c0103c3e:	c3                   	ret    

c0103c3f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c0103c3f:	55                   	push   %ebp
c0103c40:	89 e5                	mov    %esp,%ebp
c0103c42:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0103c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103c4c:	e9 ca 00 00 00       	jmp    c0103d1b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0103c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c5a:	c1 e8 0c             	shr    $0xc,%eax
c0103c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103c60:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103c65:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0103c68:	72 23                	jb     c0103c8d <check_boot_pgdir+0x4e>
c0103c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103c71:	c7 44 24 08 80 66 10 	movl   $0xc0106680,0x8(%esp)
c0103c78:	c0 
c0103c79:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103c80:	00 
c0103c81:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103c88:	e8 5c c7 ff ff       	call   c01003e9 <__panic>
c0103c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103c90:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0103c95:	89 c2                	mov    %eax,%edx
c0103c97:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103c9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0103ca3:	00 
c0103ca4:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103ca8:	89 04 24             	mov    %eax,(%esp)
c0103cab:	e8 4c f5 ff ff       	call   c01031fc <get_pte>
c0103cb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0103cb7:	75 24                	jne    c0103cdd <check_boot_pgdir+0x9e>
c0103cb9:	c7 44 24 0c 58 6a 10 	movl   $0xc0106a58,0xc(%esp)
c0103cc0:	c0 
c0103cc1:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103cc8:	c0 
c0103cc9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0103cd0:	00 
c0103cd1:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103cd8:	e8 0c c7 ff ff       	call   c01003e9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0103cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103ce0:	8b 00                	mov    (%eax),%eax
c0103ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103ce7:	89 c2                	mov    %eax,%edx
c0103ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cec:	39 c2                	cmp    %eax,%edx
c0103cee:	74 24                	je     c0103d14 <check_boot_pgdir+0xd5>
c0103cf0:	c7 44 24 0c 95 6a 10 	movl   $0xc0106a95,0xc(%esp)
c0103cf7:	c0 
c0103cf8:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103cff:	c0 
c0103d00:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0103d07:	00 
c0103d08:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d0f:	e8 d5 c6 ff ff       	call   c01003e9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
c0103d14:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0103d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0103d1e:	a1 a0 ae 11 c0       	mov    0xc011aea0,%eax
c0103d23:	39 c2                	cmp    %eax,%edx
c0103d25:	0f 82 26 ff ff ff    	jb     c0103c51 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0103d2b:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d30:	05 ac 0f 00 00       	add    $0xfac,%eax
c0103d35:	8b 00                	mov    (%eax),%eax
c0103d37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d3c:	89 c2                	mov    %eax,%edx
c0103d3e:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103d46:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0103d4d:	77 23                	ja     c0103d72 <check_boot_pgdir+0x133>
c0103d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103d56:	c7 44 24 08 24 67 10 	movl   $0xc0106724,0x8(%esp)
c0103d5d:	c0 
c0103d5e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0103d65:	00 
c0103d66:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d6d:	e8 77 c6 ff ff       	call   c01003e9 <__panic>
c0103d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103d75:	05 00 00 00 40       	add    $0x40000000,%eax
c0103d7a:	39 d0                	cmp    %edx,%eax
c0103d7c:	74 24                	je     c0103da2 <check_boot_pgdir+0x163>
c0103d7e:	c7 44 24 0c ac 6a 10 	movl   $0xc0106aac,0xc(%esp)
c0103d85:	c0 
c0103d86:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103d8d:	c0 
c0103d8e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0103d95:	00 
c0103d96:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103d9d:	e8 47 c6 ff ff       	call   c01003e9 <__panic>

    assert(boot_pgdir[0] == 0);
c0103da2:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103da7:	8b 00                	mov    (%eax),%eax
c0103da9:	85 c0                	test   %eax,%eax
c0103dab:	74 24                	je     c0103dd1 <check_boot_pgdir+0x192>
c0103dad:	c7 44 24 0c e0 6a 10 	movl   $0xc0106ae0,0xc(%esp)
c0103db4:	c0 
c0103db5:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103dbc:	c0 
c0103dbd:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0103dc4:	00 
c0103dc5:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103dcc:	e8 18 c6 ff ff       	call   c01003e9 <__panic>

    struct Page *p;
    p = alloc_page();
c0103dd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dd8:	e8 67 ed ff ff       	call   c0102b44 <alloc_pages>
c0103ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0103de0:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103de5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103dec:	00 
c0103ded:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0103df4:	00 
c0103df5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103df8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103dfc:	89 04 24             	mov    %eax,(%esp)
c0103dff:	e8 6b f6 ff ff       	call   c010346f <page_insert>
c0103e04:	85 c0                	test   %eax,%eax
c0103e06:	74 24                	je     c0103e2c <check_boot_pgdir+0x1ed>
c0103e08:	c7 44 24 0c f4 6a 10 	movl   $0xc0106af4,0xc(%esp)
c0103e0f:	c0 
c0103e10:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e17:	c0 
c0103e18:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
c0103e1f:	00 
c0103e20:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e27:	e8 bd c5 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p) == 1);
c0103e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e2f:	89 04 24             	mov    %eax,(%esp)
c0103e32:	e8 08 eb ff ff       	call   c010293f <page_ref>
c0103e37:	83 f8 01             	cmp    $0x1,%eax
c0103e3a:	74 24                	je     c0103e60 <check_boot_pgdir+0x221>
c0103e3c:	c7 44 24 0c 22 6b 10 	movl   $0xc0106b22,0xc(%esp)
c0103e43:	c0 
c0103e44:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e4b:	c0 
c0103e4c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0103e53:	00 
c0103e54:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103e5b:	e8 89 c5 ff ff       	call   c01003e9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0103e60:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103e65:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0103e6c:	00 
c0103e6d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0103e74:	00 
c0103e75:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103e78:	89 54 24 04          	mov    %edx,0x4(%esp)
c0103e7c:	89 04 24             	mov    %eax,(%esp)
c0103e7f:	e8 eb f5 ff ff       	call   c010346f <page_insert>
c0103e84:	85 c0                	test   %eax,%eax
c0103e86:	74 24                	je     c0103eac <check_boot_pgdir+0x26d>
c0103e88:	c7 44 24 0c 34 6b 10 	movl   $0xc0106b34,0xc(%esp)
c0103e8f:	c0 
c0103e90:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103e97:	c0 
c0103e98:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0103e9f:	00 
c0103ea0:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103ea7:	e8 3d c5 ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p) == 2);
c0103eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103eaf:	89 04 24             	mov    %eax,(%esp)
c0103eb2:	e8 88 ea ff ff       	call   c010293f <page_ref>
c0103eb7:	83 f8 02             	cmp    $0x2,%eax
c0103eba:	74 24                	je     c0103ee0 <check_boot_pgdir+0x2a1>
c0103ebc:	c7 44 24 0c 6b 6b 10 	movl   $0xc0106b6b,0xc(%esp)
c0103ec3:	c0 
c0103ec4:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103ecb:	c0 
c0103ecc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
c0103ed3:	00 
c0103ed4:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103edb:	e8 09 c5 ff ff       	call   c01003e9 <__panic>

    const char *str = "ucore: Hello world!!";
c0103ee0:	c7 45 e8 7c 6b 10 c0 	movl   $0xc0106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
c0103ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103eea:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103eee:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103ef5:	e8 3e 15 00 00       	call   c0105438 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0103efa:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0103f01:	00 
c0103f02:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f09:	e8 a1 15 00 00       	call   c01054af <strcmp>
c0103f0e:	85 c0                	test   %eax,%eax
c0103f10:	74 24                	je     c0103f36 <check_boot_pgdir+0x2f7>
c0103f12:	c7 44 24 0c 94 6b 10 	movl   $0xc0106b94,0xc(%esp)
c0103f19:	c0 
c0103f1a:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103f21:	c0 
c0103f22:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0103f29:	00 
c0103f2a:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103f31:	e8 b3 c4 ff ff       	call   c01003e9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0103f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f39:	89 04 24             	mov    %eax,(%esp)
c0103f3c:	e8 54 e9 ff ff       	call   c0102895 <page2kva>
c0103f41:	05 00 01 00 00       	add    $0x100,%eax
c0103f46:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0103f49:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0103f50:	e8 8d 14 00 00       	call   c01053e2 <strlen>
c0103f55:	85 c0                	test   %eax,%eax
c0103f57:	74 24                	je     c0103f7d <check_boot_pgdir+0x33e>
c0103f59:	c7 44 24 0c cc 6b 10 	movl   $0xc0106bcc,0xc(%esp)
c0103f60:	c0 
c0103f61:	c7 44 24 08 6d 67 10 	movl   $0xc010676d,0x8(%esp)
c0103f68:	c0 
c0103f69:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c0103f70:	00 
c0103f71:	c7 04 24 48 67 10 c0 	movl   $0xc0106748,(%esp)
c0103f78:	e8 6c c4 ff ff       	call   c01003e9 <__panic>

    free_page(p);
c0103f7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f84:	00 
c0103f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f88:	89 04 24             	mov    %eax,(%esp)
c0103f8b:	e8 ec eb ff ff       	call   c0102b7c <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0103f90:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103f95:	8b 00                	mov    (%eax),%eax
c0103f97:	89 04 24             	mov    %eax,(%esp)
c0103f9a:	e8 88 e9 ff ff       	call   c0102927 <pde2page>
c0103f9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103fa6:	00 
c0103fa7:	89 04 24             	mov    %eax,(%esp)
c0103faa:	e8 cd eb ff ff       	call   c0102b7c <free_pages>
    boot_pgdir[0] = 0;
c0103faf:	a1 e0 79 11 c0       	mov    0xc01179e0,%eax
c0103fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0103fba:	c7 04 24 f0 6b 10 c0 	movl   $0xc0106bf0,(%esp)
c0103fc1:	e8 cc c2 ff ff       	call   c0100292 <cprintf>
}
c0103fc6:	90                   	nop
c0103fc7:	c9                   	leave  
c0103fc8:	c3                   	ret    

c0103fc9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0103fc9:	55                   	push   %ebp
c0103fca:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0103fcc:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fcf:	83 e0 04             	and    $0x4,%eax
c0103fd2:	85 c0                	test   %eax,%eax
c0103fd4:	74 04                	je     c0103fda <perm2str+0x11>
c0103fd6:	b0 75                	mov    $0x75,%al
c0103fd8:	eb 02                	jmp    c0103fdc <perm2str+0x13>
c0103fda:	b0 2d                	mov    $0x2d,%al
c0103fdc:	a2 28 af 11 c0       	mov    %al,0xc011af28
    str[1] = 'r';
c0103fe1:	c6 05 29 af 11 c0 72 	movb   $0x72,0xc011af29
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0103fe8:	8b 45 08             	mov    0x8(%ebp),%eax
c0103feb:	83 e0 02             	and    $0x2,%eax
c0103fee:	85 c0                	test   %eax,%eax
c0103ff0:	74 04                	je     c0103ff6 <perm2str+0x2d>
c0103ff2:	b0 77                	mov    $0x77,%al
c0103ff4:	eb 02                	jmp    c0103ff8 <perm2str+0x2f>
c0103ff6:	b0 2d                	mov    $0x2d,%al
c0103ff8:	a2 2a af 11 c0       	mov    %al,0xc011af2a
    str[3] = '\0';
c0103ffd:	c6 05 2b af 11 c0 00 	movb   $0x0,0xc011af2b
    return str;
c0104004:	b8 28 af 11 c0       	mov    $0xc011af28,%eax
}
c0104009:	5d                   	pop    %ebp
c010400a:	c3                   	ret    

c010400b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c010400b:	55                   	push   %ebp
c010400c:	89 e5                	mov    %esp,%ebp
c010400e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0104011:	8b 45 10             	mov    0x10(%ebp),%eax
c0104014:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104017:	72 0d                	jb     c0104026 <get_pgtable_items+0x1b>
        return 0;
c0104019:	b8 00 00 00 00       	mov    $0x0,%eax
c010401e:	e9 98 00 00 00       	jmp    c01040bb <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0104023:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
c0104026:	8b 45 10             	mov    0x10(%ebp),%eax
c0104029:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010402c:	73 18                	jae    c0104046 <get_pgtable_items+0x3b>
c010402e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104031:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104038:	8b 45 14             	mov    0x14(%ebp),%eax
c010403b:	01 d0                	add    %edx,%eax
c010403d:	8b 00                	mov    (%eax),%eax
c010403f:	83 e0 01             	and    $0x1,%eax
c0104042:	85 c0                	test   %eax,%eax
c0104044:	74 dd                	je     c0104023 <get_pgtable_items+0x18>
    }
    if (start < right) {
c0104046:	8b 45 10             	mov    0x10(%ebp),%eax
c0104049:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010404c:	73 68                	jae    c01040b6 <get_pgtable_items+0xab>
        if (left_store != NULL) {
c010404e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0104052:	74 08                	je     c010405c <get_pgtable_items+0x51>
            *left_store = start;
c0104054:	8b 45 18             	mov    0x18(%ebp),%eax
c0104057:	8b 55 10             	mov    0x10(%ebp),%edx
c010405a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c010405c:	8b 45 10             	mov    0x10(%ebp),%eax
c010405f:	8d 50 01             	lea    0x1(%eax),%edx
c0104062:	89 55 10             	mov    %edx,0x10(%ebp)
c0104065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c010406c:	8b 45 14             	mov    0x14(%ebp),%eax
c010406f:	01 d0                	add    %edx,%eax
c0104071:	8b 00                	mov    (%eax),%eax
c0104073:	83 e0 07             	and    $0x7,%eax
c0104076:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0104079:	eb 03                	jmp    c010407e <get_pgtable_items+0x73>
            start ++;
c010407b:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c010407e:	8b 45 10             	mov    0x10(%ebp),%eax
c0104081:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104084:	73 1d                	jae    c01040a3 <get_pgtable_items+0x98>
c0104086:	8b 45 10             	mov    0x10(%ebp),%eax
c0104089:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
c0104090:	8b 45 14             	mov    0x14(%ebp),%eax
c0104093:	01 d0                	add    %edx,%eax
c0104095:	8b 00                	mov    (%eax),%eax
c0104097:	83 e0 07             	and    $0x7,%eax
c010409a:	89 c2                	mov    %eax,%edx
c010409c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010409f:	39 c2                	cmp    %eax,%edx
c01040a1:	74 d8                	je     c010407b <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
c01040a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01040a7:	74 08                	je     c01040b1 <get_pgtable_items+0xa6>
            *right_store = start;
c01040a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
c01040ac:	8b 55 10             	mov    0x10(%ebp),%edx
c01040af:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c01040b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01040b4:	eb 05                	jmp    c01040bb <get_pgtable_items+0xb0>
    }
    return 0;
c01040b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01040bb:	c9                   	leave  
c01040bc:	c3                   	ret    

c01040bd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c01040bd:	55                   	push   %ebp
c01040be:	89 e5                	mov    %esp,%ebp
c01040c0:	57                   	push   %edi
c01040c1:	56                   	push   %esi
c01040c2:	53                   	push   %ebx
c01040c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c01040c6:	c7 04 24 10 6c 10 c0 	movl   $0xc0106c10,(%esp)
c01040cd:	e8 c0 c1 ff ff       	call   c0100292 <cprintf>
    size_t left, right = 0, perm;
c01040d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01040d9:	e9 fa 00 00 00       	jmp    c01041d8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01040e1:	89 04 24             	mov    %eax,(%esp)
c01040e4:	e8 e0 fe ff ff       	call   c0103fc9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01040e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01040ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01040ef:	29 d1                	sub    %edx,%ecx
c01040f1:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01040f3:	89 d6                	mov    %edx,%esi
c01040f5:	c1 e6 16             	shl    $0x16,%esi
c01040f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040fb:	89 d3                	mov    %edx,%ebx
c01040fd:	c1 e3 16             	shl    $0x16,%ebx
c0104100:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104103:	89 d1                	mov    %edx,%ecx
c0104105:	c1 e1 16             	shl    $0x16,%ecx
c0104108:	8b 7d dc             	mov    -0x24(%ebp),%edi
c010410b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010410e:	29 d7                	sub    %edx,%edi
c0104110:	89 fa                	mov    %edi,%edx
c0104112:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104116:	89 74 24 10          	mov    %esi,0x10(%esp)
c010411a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010411e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104122:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104126:	c7 04 24 41 6c 10 c0 	movl   $0xc0106c41,(%esp)
c010412d:	e8 60 c1 ff ff       	call   c0100292 <cprintf>
        size_t l, r = left * NPTEENTRY;
c0104132:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104135:	c1 e0 0a             	shl    $0xa,%eax
c0104138:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010413b:	eb 54                	jmp    c0104191 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010413d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104140:	89 04 24             	mov    %eax,(%esp)
c0104143:	e8 81 fe ff ff       	call   c0103fc9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0104148:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010414b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010414e:	29 d1                	sub    %edx,%ecx
c0104150:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0104152:	89 d6                	mov    %edx,%esi
c0104154:	c1 e6 0c             	shl    $0xc,%esi
c0104157:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010415a:	89 d3                	mov    %edx,%ebx
c010415c:	c1 e3 0c             	shl    $0xc,%ebx
c010415f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0104162:	89 d1                	mov    %edx,%ecx
c0104164:	c1 e1 0c             	shl    $0xc,%ecx
c0104167:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010416a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010416d:	29 d7                	sub    %edx,%edi
c010416f:	89 fa                	mov    %edi,%edx
c0104171:	89 44 24 14          	mov    %eax,0x14(%esp)
c0104175:	89 74 24 10          	mov    %esi,0x10(%esp)
c0104179:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010417d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0104181:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104185:	c7 04 24 60 6c 10 c0 	movl   $0xc0106c60,(%esp)
c010418c:	e8 01 c1 ff ff       	call   c0100292 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0104191:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
c0104196:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104199:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010419c:	89 d3                	mov    %edx,%ebx
c010419e:	c1 e3 0a             	shl    $0xa,%ebx
c01041a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01041a4:	89 d1                	mov    %edx,%ecx
c01041a6:	c1 e1 0a             	shl    $0xa,%ecx
c01041a9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
c01041ac:	89 54 24 14          	mov    %edx,0x14(%esp)
c01041b0:	8d 55 d8             	lea    -0x28(%ebp),%edx
c01041b3:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
c01041bb:	89 44 24 08          	mov    %eax,0x8(%esp)
c01041bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01041c3:	89 0c 24             	mov    %ecx,(%esp)
c01041c6:	e8 40 fe ff ff       	call   c010400b <get_pgtable_items>
c01041cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01041ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01041d2:	0f 85 65 ff ff ff    	jne    c010413d <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01041d8:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
c01041dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
c01041e3:	89 54 24 14          	mov    %edx,0x14(%esp)
c01041e7:	8d 55 e0             	lea    -0x20(%ebp),%edx
c01041ea:	89 54 24 10          	mov    %edx,0x10(%esp)
c01041ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c01041f2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01041f6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01041fd:	00 
c01041fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0104205:	e8 01 fe ff ff       	call   c010400b <get_pgtable_items>
c010420a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010420d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104211:	0f 85 c7 fe ff ff    	jne    c01040de <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0104217:	c7 04 24 84 6c 10 c0 	movl   $0xc0106c84,(%esp)
c010421e:	e8 6f c0 ff ff       	call   c0100292 <cprintf>
}
c0104223:	90                   	nop
c0104224:	83 c4 4c             	add    $0x4c,%esp
c0104227:	5b                   	pop    %ebx
c0104228:	5e                   	pop    %esi
c0104229:	5f                   	pop    %edi
c010422a:	5d                   	pop    %ebp
c010422b:	c3                   	ret    

c010422c <page2ppn>:
page2ppn(struct Page *page) {
c010422c:	55                   	push   %ebp
c010422d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010422f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104232:	8b 15 98 af 11 c0    	mov    0xc011af98,%edx
c0104238:	29 d0                	sub    %edx,%eax
c010423a:	c1 f8 02             	sar    $0x2,%eax
c010423d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0104243:	5d                   	pop    %ebp
c0104244:	c3                   	ret    

c0104245 <page2pa>:
page2pa(struct Page *page) {
c0104245:	55                   	push   %ebp
c0104246:	89 e5                	mov    %esp,%ebp
c0104248:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010424b:	8b 45 08             	mov    0x8(%ebp),%eax
c010424e:	89 04 24             	mov    %eax,(%esp)
c0104251:	e8 d6 ff ff ff       	call   c010422c <page2ppn>
c0104256:	c1 e0 0c             	shl    $0xc,%eax
}
c0104259:	c9                   	leave  
c010425a:	c3                   	ret    

c010425b <page_ref>:
page_ref(struct Page *page) {
c010425b:	55                   	push   %ebp
c010425c:	89 e5                	mov    %esp,%ebp
    return page->ref;
c010425e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104261:	8b 00                	mov    (%eax),%eax
}
c0104263:	5d                   	pop    %ebp
c0104264:	c3                   	ret    

c0104265 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
c0104265:	55                   	push   %ebp
c0104266:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104268:	8b 45 08             	mov    0x8(%ebp),%eax
c010426b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010426e:	89 10                	mov    %edx,(%eax)
}
c0104270:	90                   	nop
c0104271:	5d                   	pop    %ebp
c0104272:	c3                   	ret    

c0104273 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0104273:	55                   	push   %ebp
c0104274:	89 e5                	mov    %esp,%ebp
c0104276:	83 ec 10             	sub    $0x10,%esp
c0104279:	c7 45 fc 9c af 11 c0 	movl   $0xc011af9c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0104280:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104283:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0104286:	89 50 04             	mov    %edx,0x4(%eax)
c0104289:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010428c:	8b 50 04             	mov    0x4(%eax),%edx
c010428f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0104292:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0104294:	c7 05 a4 af 11 c0 00 	movl   $0x0,0xc011afa4
c010429b:	00 00 00 
}
c010429e:	90                   	nop
c010429f:	c9                   	leave  
c01042a0:	c3                   	ret    

c01042a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01042a1:	55                   	push   %ebp
c01042a2:	89 e5                	mov    %esp,%ebp
c01042a4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
c01042a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01042ab:	75 24                	jne    c01042d1 <default_init_memmap+0x30>
c01042ad:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c01042b4:	c0 
c01042b5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01042bc:	c0 
c01042bd:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01042c4:	00 
c01042c5:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01042cc:	e8 18 c1 ff ff       	call   c01003e9 <__panic>
    struct Page *p = base;
c01042d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01042d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01042d7:	eb 7d                	jmp    c0104356 <default_init_memmap+0xb5>
        assert(PageReserved(p));
c01042d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01042dc:	83 c0 04             	add    $0x4,%eax
c01042df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01042e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01042ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01042ef:	0f a3 10             	bt     %edx,(%eax)
c01042f2:	19 c0                	sbb    %eax,%eax
c01042f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
c01042f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01042fb:	0f 95 c0             	setne  %al
c01042fe:	0f b6 c0             	movzbl %al,%eax
c0104301:	85 c0                	test   %eax,%eax
c0104303:	75 24                	jne    c0104329 <default_init_memmap+0x88>
c0104305:	c7 44 24 0c e9 6c 10 	movl   $0xc0106ce9,0xc(%esp)
c010430c:	c0 
c010430d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104314:	c0 
c0104315:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010431c:	00 
c010431d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104324:	e8 c0 c0 ff ff       	call   c01003e9 <__panic>
        p->flags = p->property = 0;
c0104329:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010432c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
c0104333:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104336:	8b 50 08             	mov    0x8(%eax),%edx
c0104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010433c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
c010433f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104346:	00 
c0104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010434a:	89 04 24             	mov    %eax,(%esp)
c010434d:	e8 13 ff ff ff       	call   c0104265 <set_page_ref>
    for (; p != base + n; p ++) {
c0104352:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104356:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104359:	89 d0                	mov    %edx,%eax
c010435b:	c1 e0 02             	shl    $0x2,%eax
c010435e:	01 d0                	add    %edx,%eax
c0104360:	c1 e0 02             	shl    $0x2,%eax
c0104363:	89 c2                	mov    %eax,%edx
c0104365:	8b 45 08             	mov    0x8(%ebp),%eax
c0104368:	01 d0                	add    %edx,%eax
c010436a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010436d:	0f 85 66 ff ff ff    	jne    c01042d9 <default_init_memmap+0x38>
    }
    base->property = n;
c0104373:	8b 45 08             	mov    0x8(%ebp),%eax
c0104376:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104379:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010437c:	8b 45 08             	mov    0x8(%ebp),%eax
c010437f:	83 c0 04             	add    $0x4,%eax
c0104382:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0104389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010438c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010438f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104392:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
c0104395:	8b 15 a4 af 11 c0    	mov    0xc011afa4,%edx
c010439b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010439e:	01 d0                	add    %edx,%eax
c01043a0:	a3 a4 af 11 c0       	mov    %eax,0xc011afa4
    list_add(&free_list, &(base->page_link));
c01043a5:	8b 45 08             	mov    0x8(%ebp),%eax
c01043a8:	83 c0 0c             	add    $0xc,%eax
c01043ab:	c7 45 e4 9c af 11 c0 	movl   $0xc011af9c,-0x1c(%ebp)
c01043b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01043b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01043bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01043be:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01043c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043c4:	8b 40 04             	mov    0x4(%eax),%eax
c01043c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01043ca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01043cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01043d0:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01043d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01043d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01043dc:	89 10                	mov    %edx,(%eax)
c01043de:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01043e1:	8b 10                	mov    (%eax),%edx
c01043e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043e6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01043e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01043ef:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01043f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043f5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01043f8:	89 10                	mov    %edx,(%eax)
}
c01043fa:	90                   	nop
c01043fb:	c9                   	leave  
c01043fc:	c3                   	ret    

c01043fd <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01043fd:	55                   	push   %ebp
c01043fe:	89 e5                	mov    %esp,%ebp
c0104400:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0104403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104407:	75 24                	jne    c010442d <default_alloc_pages+0x30>
c0104409:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c0104410:	c0 
c0104411:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104418:	c0 
c0104419:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c0104420:	00 
c0104421:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104428:	e8 bc bf ff ff       	call   c01003e9 <__panic>
    if (n > nr_free) {
c010442d:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104432:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104435:	76 0a                	jbe    c0104441 <default_alloc_pages+0x44>
        return NULL;
c0104437:	b8 00 00 00 00       	mov    $0x0,%eax
c010443c:	e9 2a 01 00 00       	jmp    c010456b <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
c0104441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0104448:	c7 45 f0 9c af 11 c0 	movl   $0xc011af9c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c010444f:	eb 1c                	jmp    c010446d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
c0104451:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104454:	83 e8 0c             	sub    $0xc,%eax
c0104457:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
c010445a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010445d:	8b 40 08             	mov    0x8(%eax),%eax
c0104460:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104463:	77 08                	ja     c010446d <default_alloc_pages+0x70>
            page = p;
c0104465:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104468:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c010446b:	eb 18                	jmp    c0104485 <default_alloc_pages+0x88>
c010446d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
c0104473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104476:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104479:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010447c:	81 7d f0 9c af 11 c0 	cmpl   $0xc011af9c,-0x10(%ebp)
c0104483:	75 cc                	jne    c0104451 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
c0104485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104489:	0f 84 d9 00 00 00    	je     c0104568 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
c010448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104492:	83 c0 0c             	add    $0xc,%eax
c0104495:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104498:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010449b:	8b 40 04             	mov    0x4(%eax),%eax
c010449e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01044a1:	8b 12                	mov    (%edx),%edx
c01044a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01044a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01044a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01044ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01044af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01044b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01044b8:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c01044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044bd:	8b 40 08             	mov    0x8(%eax),%eax
c01044c0:	39 45 08             	cmp    %eax,0x8(%ebp)
c01044c3:	73 7d                	jae    c0104542 <default_alloc_pages+0x145>
            struct Page *p = page + n;
c01044c5:	8b 55 08             	mov    0x8(%ebp),%edx
c01044c8:	89 d0                	mov    %edx,%eax
c01044ca:	c1 e0 02             	shl    $0x2,%eax
c01044cd:	01 d0                	add    %edx,%eax
c01044cf:	c1 e0 02             	shl    $0x2,%eax
c01044d2:	89 c2                	mov    %eax,%edx
c01044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d7:	01 d0                	add    %edx,%eax
c01044d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
c01044dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044df:	8b 40 08             	mov    0x8(%eax),%eax
c01044e2:	2b 45 08             	sub    0x8(%ebp),%eax
c01044e5:	89 c2                	mov    %eax,%edx
c01044e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044ea:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
c01044ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044f0:	83 c0 0c             	add    $0xc,%eax
c01044f3:	c7 45 d4 9c af 11 c0 	movl   $0xc011af9c,-0x2c(%ebp)
c01044fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01044fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104500:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0104503:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104506:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
c0104509:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010450c:	8b 40 04             	mov    0x4(%eax),%eax
c010450f:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0104512:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0104515:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104518:	89 55 c0             	mov    %edx,-0x40(%ebp)
c010451b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
c010451e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104521:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0104524:	89 10                	mov    %edx,(%eax)
c0104526:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104529:	8b 10                	mov    (%eax),%edx
c010452b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010452e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0104531:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104534:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104537:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c010453a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010453d:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104540:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
c0104542:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104547:	2b 45 08             	sub    0x8(%ebp),%eax
c010454a:	a3 a4 af 11 c0       	mov    %eax,0xc011afa4
        ClearPageProperty(page);
c010454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104552:	83 c0 04             	add    $0x4,%eax
c0104555:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c010455c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010455f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104562:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0104565:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
c0104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010456b:	c9                   	leave  
c010456c:	c3                   	ret    

c010456d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c010456d:	55                   	push   %ebp
c010456e:	89 e5                	mov    %esp,%ebp
c0104570:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
c0104576:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010457a:	75 24                	jne    c01045a0 <default_free_pages+0x33>
c010457c:	c7 44 24 0c b8 6c 10 	movl   $0xc0106cb8,0xc(%esp)
c0104583:	c0 
c0104584:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010458b:	c0 
c010458c:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0104593:	00 
c0104594:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010459b:	e8 49 be ff ff       	call   c01003e9 <__panic>
    struct Page *p = base;
c01045a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c01045a6:	e9 9d 00 00 00       	jmp    c0104648 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
c01045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ae:	83 c0 04             	add    $0x4,%eax
c01045b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01045b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01045be:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01045c1:	0f a3 10             	bt     %edx,(%eax)
c01045c4:	19 c0                	sbb    %eax,%eax
c01045c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
c01045c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01045cd:	0f 95 c0             	setne  %al
c01045d0:	0f b6 c0             	movzbl %al,%eax
c01045d3:	85 c0                	test   %eax,%eax
c01045d5:	75 2c                	jne    c0104603 <default_free_pages+0x96>
c01045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045da:	83 c0 04             	add    $0x4,%eax
c01045dd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c01045e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01045e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01045ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01045ed:	0f a3 10             	bt     %edx,(%eax)
c01045f0:	19 c0                	sbb    %eax,%eax
c01045f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
c01045f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01045f9:	0f 95 c0             	setne  %al
c01045fc:	0f b6 c0             	movzbl %al,%eax
c01045ff:	85 c0                	test   %eax,%eax
c0104601:	74 24                	je     c0104627 <default_free_pages+0xba>
c0104603:	c7 44 24 0c fc 6c 10 	movl   $0xc0106cfc,0xc(%esp)
c010460a:	c0 
c010460b:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104612:	c0 
c0104613:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
c010461a:	00 
c010461b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104622:	e8 c2 bd ff ff       	call   c01003e9 <__panic>
        p->flags = 0;
c0104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010462a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
c0104631:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104638:	00 
c0104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010463c:	89 04 24             	mov    %eax,(%esp)
c010463f:	e8 21 fc ff ff       	call   c0104265 <set_page_ref>
    for (; p != base + n; p ++) {
c0104644:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0104648:	8b 55 0c             	mov    0xc(%ebp),%edx
c010464b:	89 d0                	mov    %edx,%eax
c010464d:	c1 e0 02             	shl    $0x2,%eax
c0104650:	01 d0                	add    %edx,%eax
c0104652:	c1 e0 02             	shl    $0x2,%eax
c0104655:	89 c2                	mov    %eax,%edx
c0104657:	8b 45 08             	mov    0x8(%ebp),%eax
c010465a:	01 d0                	add    %edx,%eax
c010465c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010465f:	0f 85 46 ff ff ff    	jne    c01045ab <default_free_pages+0x3e>
    }
    base->property = n;
c0104665:	8b 45 08             	mov    0x8(%ebp),%eax
c0104668:	8b 55 0c             	mov    0xc(%ebp),%edx
c010466b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
c010466e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104671:	83 c0 04             	add    $0x4,%eax
c0104674:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c010467b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010467e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104681:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104684:	0f ab 10             	bts    %edx,(%eax)
c0104687:	c7 45 d4 9c af 11 c0 	movl   $0xc011af9c,-0x2c(%ebp)
    return listelm->next;
c010468e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104691:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
c0104694:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
c0104697:	e9 08 01 00 00       	jmp    c01047a4 <default_free_pages+0x237>
        p = le2page(le, page_link);
c010469c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469f:	83 e8 0c             	sub    $0xc,%eax
c01046a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01046ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01046ae:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01046b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
c01046b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01046b7:	8b 50 08             	mov    0x8(%eax),%edx
c01046ba:	89 d0                	mov    %edx,%eax
c01046bc:	c1 e0 02             	shl    $0x2,%eax
c01046bf:	01 d0                	add    %edx,%eax
c01046c1:	c1 e0 02             	shl    $0x2,%eax
c01046c4:	89 c2                	mov    %eax,%edx
c01046c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01046c9:	01 d0                	add    %edx,%eax
c01046cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c01046ce:	75 5a                	jne    c010472a <default_free_pages+0x1bd>
            base->property += p->property;
c01046d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01046d3:	8b 50 08             	mov    0x8(%eax),%edx
c01046d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046d9:	8b 40 08             	mov    0x8(%eax),%eax
c01046dc:	01 c2                	add    %eax,%edx
c01046de:	8b 45 08             	mov    0x8(%ebp),%eax
c01046e1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
c01046e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01046e7:	83 c0 04             	add    $0x4,%eax
c01046ea:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c01046f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01046f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01046f7:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01046fa:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
c01046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104700:	83 c0 0c             	add    $0xc,%eax
c0104703:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104706:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104709:	8b 40 04             	mov    0x4(%eax),%eax
c010470c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010470f:	8b 12                	mov    (%edx),%edx
c0104711:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0104714:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
c0104717:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010471a:	8b 55 bc             	mov    -0x44(%ebp),%edx
c010471d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0104720:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104723:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104726:	89 10                	mov    %edx,(%eax)
c0104728:	eb 7a                	jmp    c01047a4 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
c010472a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010472d:	8b 50 08             	mov    0x8(%eax),%edx
c0104730:	89 d0                	mov    %edx,%eax
c0104732:	c1 e0 02             	shl    $0x2,%eax
c0104735:	01 d0                	add    %edx,%eax
c0104737:	c1 e0 02             	shl    $0x2,%eax
c010473a:	89 c2                	mov    %eax,%edx
c010473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010473f:	01 d0                	add    %edx,%eax
c0104741:	39 45 08             	cmp    %eax,0x8(%ebp)
c0104744:	75 5e                	jne    c01047a4 <default_free_pages+0x237>
            p->property += base->property;
c0104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104749:	8b 50 08             	mov    0x8(%eax),%edx
c010474c:	8b 45 08             	mov    0x8(%ebp),%eax
c010474f:	8b 40 08             	mov    0x8(%eax),%eax
c0104752:	01 c2                	add    %eax,%edx
c0104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104757:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
c010475a:	8b 45 08             	mov    0x8(%ebp),%eax
c010475d:	83 c0 04             	add    $0x4,%eax
c0104760:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0104767:	89 45 a0             	mov    %eax,-0x60(%ebp)
c010476a:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010476d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0104770:	0f b3 10             	btr    %edx,(%eax)
            base = p;
c0104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104776:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
c0104779:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010477c:	83 c0 0c             	add    $0xc,%eax
c010477f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
c0104782:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104785:	8b 40 04             	mov    0x4(%eax),%eax
c0104788:	8b 55 b0             	mov    -0x50(%ebp),%edx
c010478b:	8b 12                	mov    (%edx),%edx
c010478d:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0104790:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
c0104793:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0104796:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104799:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010479c:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010479f:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01047a2:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
c01047a4:	81 7d f0 9c af 11 c0 	cmpl   $0xc011af9c,-0x10(%ebp)
c01047ab:	0f 85 eb fe ff ff    	jne    c010469c <default_free_pages+0x12f>
        }
    }
    nr_free += n;
c01047b1:	8b 15 a4 af 11 c0    	mov    0xc011afa4,%edx
c01047b7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01047ba:	01 d0                	add    %edx,%eax
c01047bc:	a3 a4 af 11 c0       	mov    %eax,0xc011afa4
    list_add_before(&free_list, &(base->page_link));
c01047c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c4:	83 c0 0c             	add    $0xc,%eax
c01047c7:	c7 45 9c 9c af 11 c0 	movl   $0xc011af9c,-0x64(%ebp)
c01047ce:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
c01047d1:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01047d4:	8b 00                	mov    (%eax),%eax
c01047d6:	8b 55 98             	mov    -0x68(%ebp),%edx
c01047d9:	89 55 94             	mov    %edx,-0x6c(%ebp)
c01047dc:	89 45 90             	mov    %eax,-0x70(%ebp)
c01047df:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01047e2:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
c01047e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01047e8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01047eb:	89 10                	mov    %edx,(%eax)
c01047ed:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01047f0:	8b 10                	mov    (%eax),%edx
c01047f2:	8b 45 90             	mov    -0x70(%ebp),%eax
c01047f5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01047f8:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01047fb:	8b 55 8c             	mov    -0x74(%ebp),%edx
c01047fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0104801:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104804:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104807:	89 10                	mov    %edx,(%eax)
}
c0104809:	90                   	nop
c010480a:	c9                   	leave  
c010480b:	c3                   	ret    

c010480c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c010480c:	55                   	push   %ebp
c010480d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010480f:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
}
c0104814:	5d                   	pop    %ebp
c0104815:	c3                   	ret    

c0104816 <basic_check>:

static void
basic_check(void) {
c0104816:	55                   	push   %ebp
c0104817:	89 e5                	mov    %esp,%ebp
c0104819:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c010481c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104826:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104829:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010482c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c010482f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104836:	e8 09 e3 ff ff       	call   c0102b44 <alloc_pages>
c010483b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010483e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104842:	75 24                	jne    c0104868 <basic_check+0x52>
c0104844:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c010484b:	c0 
c010484c:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104853:	c0 
c0104854:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c010485b:	00 
c010485c:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104863:	e8 81 bb ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010486f:	e8 d0 e2 ff ff       	call   c0102b44 <alloc_pages>
c0104874:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104877:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010487b:	75 24                	jne    c01048a1 <basic_check+0x8b>
c010487d:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c0104884:	c0 
c0104885:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010488c:	c0 
c010488d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0104894:	00 
c0104895:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010489c:	e8 48 bb ff ff       	call   c01003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c01048a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01048a8:	e8 97 e2 ff ff       	call   c0102b44 <alloc_pages>
c01048ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01048b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048b4:	75 24                	jne    c01048da <basic_check+0xc4>
c01048b6:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c01048bd:	c0 
c01048be:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01048c5:	c0 
c01048c6:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c01048cd:	00 
c01048ce:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01048d5:	e8 0f bb ff ff       	call   c01003e9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c01048da:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01048e0:	74 10                	je     c01048f2 <basic_check+0xdc>
c01048e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048e8:	74 08                	je     c01048f2 <basic_check+0xdc>
c01048ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01048f0:	75 24                	jne    c0104916 <basic_check+0x100>
c01048f2:	c7 44 24 0c 78 6d 10 	movl   $0xc0106d78,0xc(%esp)
c01048f9:	c0 
c01048fa:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104901:	c0 
c0104902:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0104909:	00 
c010490a:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104911:	e8 d3 ba ff ff       	call   c01003e9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0104916:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104919:	89 04 24             	mov    %eax,(%esp)
c010491c:	e8 3a f9 ff ff       	call   c010425b <page_ref>
c0104921:	85 c0                	test   %eax,%eax
c0104923:	75 1e                	jne    c0104943 <basic_check+0x12d>
c0104925:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104928:	89 04 24             	mov    %eax,(%esp)
c010492b:	e8 2b f9 ff ff       	call   c010425b <page_ref>
c0104930:	85 c0                	test   %eax,%eax
c0104932:	75 0f                	jne    c0104943 <basic_check+0x12d>
c0104934:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104937:	89 04 24             	mov    %eax,(%esp)
c010493a:	e8 1c f9 ff ff       	call   c010425b <page_ref>
c010493f:	85 c0                	test   %eax,%eax
c0104941:	74 24                	je     c0104967 <basic_check+0x151>
c0104943:	c7 44 24 0c 9c 6d 10 	movl   $0xc0106d9c,0xc(%esp)
c010494a:	c0 
c010494b:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104952:	c0 
c0104953:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010495a:	00 
c010495b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104962:	e8 82 ba ff ff       	call   c01003e9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0104967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496a:	89 04 24             	mov    %eax,(%esp)
c010496d:	e8 d3 f8 ff ff       	call   c0104245 <page2pa>
c0104972:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c0104978:	c1 e2 0c             	shl    $0xc,%edx
c010497b:	39 d0                	cmp    %edx,%eax
c010497d:	72 24                	jb     c01049a3 <basic_check+0x18d>
c010497f:	c7 44 24 0c d8 6d 10 	movl   $0xc0106dd8,0xc(%esp)
c0104986:	c0 
c0104987:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010498e:	c0 
c010498f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0104996:	00 
c0104997:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010499e:	e8 46 ba ff ff       	call   c01003e9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c01049a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049a6:	89 04 24             	mov    %eax,(%esp)
c01049a9:	e8 97 f8 ff ff       	call   c0104245 <page2pa>
c01049ae:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c01049b4:	c1 e2 0c             	shl    $0xc,%edx
c01049b7:	39 d0                	cmp    %edx,%eax
c01049b9:	72 24                	jb     c01049df <basic_check+0x1c9>
c01049bb:	c7 44 24 0c f5 6d 10 	movl   $0xc0106df5,0xc(%esp)
c01049c2:	c0 
c01049c3:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01049ca:	c0 
c01049cb:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01049d2:	00 
c01049d3:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01049da:	e8 0a ba ff ff       	call   c01003e9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c01049df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049e2:	89 04 24             	mov    %eax,(%esp)
c01049e5:	e8 5b f8 ff ff       	call   c0104245 <page2pa>
c01049ea:	8b 15 a0 ae 11 c0    	mov    0xc011aea0,%edx
c01049f0:	c1 e2 0c             	shl    $0xc,%edx
c01049f3:	39 d0                	cmp    %edx,%eax
c01049f5:	72 24                	jb     c0104a1b <basic_check+0x205>
c01049f7:	c7 44 24 0c 12 6e 10 	movl   $0xc0106e12,0xc(%esp)
c01049fe:	c0 
c01049ff:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a06:	c0 
c0104a07:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0104a0e:	00 
c0104a0f:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a16:	e8 ce b9 ff ff       	call   c01003e9 <__panic>

    list_entry_t free_list_store = free_list;
c0104a1b:	a1 9c af 11 c0       	mov    0xc011af9c,%eax
c0104a20:	8b 15 a0 af 11 c0    	mov    0xc011afa0,%edx
c0104a26:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104a29:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104a2c:	c7 45 dc 9c af 11 c0 	movl   $0xc011af9c,-0x24(%ebp)
    elm->prev = elm->next = elm;
c0104a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a36:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a39:	89 50 04             	mov    %edx,0x4(%eax)
c0104a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a3f:	8b 50 04             	mov    0x4(%eax),%edx
c0104a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104a45:	89 10                	mov    %edx,(%eax)
c0104a47:	c7 45 e0 9c af 11 c0 	movl   $0xc011af9c,-0x20(%ebp)
    return list->next == list;
c0104a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104a51:	8b 40 04             	mov    0x4(%eax),%eax
c0104a54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c0104a57:	0f 94 c0             	sete   %al
c0104a5a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104a5d:	85 c0                	test   %eax,%eax
c0104a5f:	75 24                	jne    c0104a85 <basic_check+0x26f>
c0104a61:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104a68:	c0 
c0104a69:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104a70:	c0 
c0104a71:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0104a78:	00 
c0104a79:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104a80:	e8 64 b9 ff ff       	call   c01003e9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104a85:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0104a8d:	c7 05 a4 af 11 c0 00 	movl   $0x0,0xc011afa4
c0104a94:	00 00 00 

    assert(alloc_page() == NULL);
c0104a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104a9e:	e8 a1 e0 ff ff       	call   c0102b44 <alloc_pages>
c0104aa3:	85 c0                	test   %eax,%eax
c0104aa5:	74 24                	je     c0104acb <basic_check+0x2b5>
c0104aa7:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104aae:	c0 
c0104aaf:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ab6:	c0 
c0104ab7:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0104abe:	00 
c0104abf:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104ac6:	e8 1e b9 ff ff       	call   c01003e9 <__panic>

    free_page(p0);
c0104acb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ad2:	00 
c0104ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ad6:	89 04 24             	mov    %eax,(%esp)
c0104ad9:	e8 9e e0 ff ff       	call   c0102b7c <free_pages>
    free_page(p1);
c0104ade:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104ae5:	00 
c0104ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae9:	89 04 24             	mov    %eax,(%esp)
c0104aec:	e8 8b e0 ff ff       	call   c0102b7c <free_pages>
    free_page(p2);
c0104af1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104af8:	00 
c0104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104afc:	89 04 24             	mov    %eax,(%esp)
c0104aff:	e8 78 e0 ff ff       	call   c0102b7c <free_pages>
    assert(nr_free == 3);
c0104b04:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104b09:	83 f8 03             	cmp    $0x3,%eax
c0104b0c:	74 24                	je     c0104b32 <basic_check+0x31c>
c0104b0e:	c7 44 24 0c 5b 6e 10 	movl   $0xc0106e5b,0xc(%esp)
c0104b15:	c0 
c0104b16:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b1d:	c0 
c0104b1e:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0104b25:	00 
c0104b26:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b2d:	e8 b7 b8 ff ff       	call   c01003e9 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0104b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b39:	e8 06 e0 ff ff       	call   c0102b44 <alloc_pages>
c0104b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0104b45:	75 24                	jne    c0104b6b <basic_check+0x355>
c0104b47:	c7 44 24 0c 21 6d 10 	movl   $0xc0106d21,0xc(%esp)
c0104b4e:	c0 
c0104b4f:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b56:	c0 
c0104b57:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0104b5e:	00 
c0104b5f:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b66:	e8 7e b8 ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0104b6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104b72:	e8 cd df ff ff       	call   c0102b44 <alloc_pages>
c0104b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b7e:	75 24                	jne    c0104ba4 <basic_check+0x38e>
c0104b80:	c7 44 24 0c 3d 6d 10 	movl   $0xc0106d3d,0xc(%esp)
c0104b87:	c0 
c0104b88:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104b8f:	c0 
c0104b90:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0104b97:	00 
c0104b98:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104b9f:	e8 45 b8 ff ff       	call   c01003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0104ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104bab:	e8 94 df ff ff       	call   c0102b44 <alloc_pages>
c0104bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bb7:	75 24                	jne    c0104bdd <basic_check+0x3c7>
c0104bb9:	c7 44 24 0c 59 6d 10 	movl   $0xc0106d59,0xc(%esp)
c0104bc0:	c0 
c0104bc1:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104bc8:	c0 
c0104bc9:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0104bd0:	00 
c0104bd1:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104bd8:	e8 0c b8 ff ff       	call   c01003e9 <__panic>

    assert(alloc_page() == NULL);
c0104bdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104be4:	e8 5b df ff ff       	call   c0102b44 <alloc_pages>
c0104be9:	85 c0                	test   %eax,%eax
c0104beb:	74 24                	je     c0104c11 <basic_check+0x3fb>
c0104bed:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104bf4:	c0 
c0104bf5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104bfc:	c0 
c0104bfd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104c04:	00 
c0104c05:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c0c:	e8 d8 b7 ff ff       	call   c01003e9 <__panic>

    free_page(p0);
c0104c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104c18:	00 
c0104c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c1c:	89 04 24             	mov    %eax,(%esp)
c0104c1f:	e8 58 df ff ff       	call   c0102b7c <free_pages>
c0104c24:	c7 45 d8 9c af 11 c0 	movl   $0xc011af9c,-0x28(%ebp)
c0104c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104c2e:	8b 40 04             	mov    0x4(%eax),%eax
c0104c31:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0104c34:	0f 94 c0             	sete   %al
c0104c37:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0104c3a:	85 c0                	test   %eax,%eax
c0104c3c:	74 24                	je     c0104c62 <basic_check+0x44c>
c0104c3e:	c7 44 24 0c 68 6e 10 	movl   $0xc0106e68,0xc(%esp)
c0104c45:	c0 
c0104c46:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c4d:	c0 
c0104c4e:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0104c55:	00 
c0104c56:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c5d:	e8 87 b7 ff ff       	call   c01003e9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0104c62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c69:	e8 d6 de ff ff       	call   c0102b44 <alloc_pages>
c0104c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104c74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0104c77:	74 24                	je     c0104c9d <basic_check+0x487>
c0104c79:	c7 44 24 0c 80 6e 10 	movl   $0xc0106e80,0xc(%esp)
c0104c80:	c0 
c0104c81:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104c88:	c0 
c0104c89:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0104c90:	00 
c0104c91:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104c98:	e8 4c b7 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0104c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104ca4:	e8 9b de ff ff       	call   c0102b44 <alloc_pages>
c0104ca9:	85 c0                	test   %eax,%eax
c0104cab:	74 24                	je     c0104cd1 <basic_check+0x4bb>
c0104cad:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104cb4:	c0 
c0104cb5:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104cbc:	c0 
c0104cbd:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0104cc4:	00 
c0104cc5:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104ccc:	e8 18 b7 ff ff       	call   c01003e9 <__panic>

    assert(nr_free == 0);
c0104cd1:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104cd6:	85 c0                	test   %eax,%eax
c0104cd8:	74 24                	je     c0104cfe <basic_check+0x4e8>
c0104cda:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c0104ce1:	c0 
c0104ce2:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ce9:	c0 
c0104cea:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
c0104cf1:	00 
c0104cf2:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104cf9:	e8 eb b6 ff ff       	call   c01003e9 <__panic>
    free_list = free_list_store;
c0104cfe:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104d01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104d04:	a3 9c af 11 c0       	mov    %eax,0xc011af9c
c0104d09:	89 15 a0 af 11 c0    	mov    %edx,0xc011afa0
    nr_free = nr_free_store;
c0104d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d12:	a3 a4 af 11 c0       	mov    %eax,0xc011afa4

    free_page(p);
c0104d17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d1e:	00 
c0104d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d22:	89 04 24             	mov    %eax,(%esp)
c0104d25:	e8 52 de ff ff       	call   c0102b7c <free_pages>
    free_page(p1);
c0104d2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d31:	00 
c0104d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d35:	89 04 24             	mov    %eax,(%esp)
c0104d38:	e8 3f de ff ff       	call   c0102b7c <free_pages>
    free_page(p2);
c0104d3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104d44:	00 
c0104d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d48:	89 04 24             	mov    %eax,(%esp)
c0104d4b:	e8 2c de ff ff       	call   c0102b7c <free_pages>
}
c0104d50:	90                   	nop
c0104d51:	c9                   	leave  
c0104d52:	c3                   	ret    

c0104d53 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104d53:	55                   	push   %ebp
c0104d54:	89 e5                	mov    %esp,%ebp
c0104d56:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
c0104d5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104d63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0104d6a:	c7 45 ec 9c af 11 c0 	movl   $0xc011af9c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104d71:	eb 6a                	jmp    c0104ddd <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
c0104d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d76:	83 e8 0c             	sub    $0xc,%eax
c0104d79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
c0104d7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104d7f:	83 c0 04             	add    $0x4,%eax
c0104d82:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104d89:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104d8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0104d8f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0104d92:	0f a3 10             	bt     %edx,(%eax)
c0104d95:	19 c0                	sbb    %eax,%eax
c0104d97:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
c0104d9a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0104d9e:	0f 95 c0             	setne  %al
c0104da1:	0f b6 c0             	movzbl %al,%eax
c0104da4:	85 c0                	test   %eax,%eax
c0104da6:	75 24                	jne    c0104dcc <default_check+0x79>
c0104da8:	c7 44 24 0c a6 6e 10 	movl   $0xc0106ea6,0xc(%esp)
c0104daf:	c0 
c0104db0:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104db7:	c0 
c0104db8:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0104dbf:	00 
c0104dc0:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104dc7:	e8 1d b6 ff ff       	call   c01003e9 <__panic>
        count ++, total += p->property;
c0104dcc:	ff 45 f4             	incl   -0xc(%ebp)
c0104dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0104dd2:	8b 50 08             	mov    0x8(%eax),%edx
c0104dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd8:	01 d0                	add    %edx,%eax
c0104dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104de0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
c0104de3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104de6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c0104de9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104dec:	81 7d ec 9c af 11 c0 	cmpl   $0xc011af9c,-0x14(%ebp)
c0104df3:	0f 85 7a ff ff ff    	jne    c0104d73 <default_check+0x20>
    }
    assert(total == nr_free_pages());
c0104df9:	e8 b1 dd ff ff       	call   c0102baf <nr_free_pages>
c0104dfe:	89 c2                	mov    %eax,%edx
c0104e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e03:	39 c2                	cmp    %eax,%edx
c0104e05:	74 24                	je     c0104e2b <default_check+0xd8>
c0104e07:	c7 44 24 0c b6 6e 10 	movl   $0xc0106eb6,0xc(%esp)
c0104e0e:	c0 
c0104e0f:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e16:	c0 
c0104e17:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104e1e:	00 
c0104e1f:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e26:	e8 be b5 ff ff       	call   c01003e9 <__panic>

    basic_check();
c0104e2b:	e8 e6 f9 ff ff       	call   c0104816 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0104e30:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104e37:	e8 08 dd ff ff       	call   c0102b44 <alloc_pages>
c0104e3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
c0104e3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104e43:	75 24                	jne    c0104e69 <default_check+0x116>
c0104e45:	c7 44 24 0c cf 6e 10 	movl   $0xc0106ecf,0xc(%esp)
c0104e4c:	c0 
c0104e4d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104e54:	c0 
c0104e55:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0104e5c:	00 
c0104e5d:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104e64:	e8 80 b5 ff ff       	call   c01003e9 <__panic>
    assert(!PageProperty(p0));
c0104e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104e6c:	83 c0 04             	add    $0x4,%eax
c0104e6f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104e76:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104e79:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0104e7c:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0104e7f:	0f a3 10             	bt     %edx,(%eax)
c0104e82:	19 c0                	sbb    %eax,%eax
c0104e84:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
c0104e87:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0104e8b:	0f 95 c0             	setne  %al
c0104e8e:	0f b6 c0             	movzbl %al,%eax
c0104e91:	85 c0                	test   %eax,%eax
c0104e93:	74 24                	je     c0104eb9 <default_check+0x166>
c0104e95:	c7 44 24 0c da 6e 10 	movl   $0xc0106eda,0xc(%esp)
c0104e9c:	c0 
c0104e9d:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104ea4:	c0 
c0104ea5:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0104eac:	00 
c0104ead:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104eb4:	e8 30 b5 ff ff       	call   c01003e9 <__panic>

    list_entry_t free_list_store = free_list;
c0104eb9:	a1 9c af 11 c0       	mov    0xc011af9c,%eax
c0104ebe:	8b 15 a0 af 11 c0    	mov    0xc011afa0,%edx
c0104ec4:	89 45 80             	mov    %eax,-0x80(%ebp)
c0104ec7:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0104eca:	c7 45 b0 9c af 11 c0 	movl   $0xc011af9c,-0x50(%ebp)
    elm->prev = elm->next = elm;
c0104ed1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ed4:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0104ed7:	89 50 04             	mov    %edx,0x4(%eax)
c0104eda:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104edd:	8b 50 04             	mov    0x4(%eax),%edx
c0104ee0:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104ee3:	89 10                	mov    %edx,(%eax)
c0104ee5:	c7 45 b4 9c af 11 c0 	movl   $0xc011af9c,-0x4c(%ebp)
    return list->next == list;
c0104eec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0104eef:	8b 40 04             	mov    0x4(%eax),%eax
c0104ef2:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
c0104ef5:	0f 94 c0             	sete   %al
c0104ef8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0104efb:	85 c0                	test   %eax,%eax
c0104efd:	75 24                	jne    c0104f23 <default_check+0x1d0>
c0104eff:	c7 44 24 0c 2f 6e 10 	movl   $0xc0106e2f,0xc(%esp)
c0104f06:	c0 
c0104f07:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f0e:	c0 
c0104f0f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
c0104f16:	00 
c0104f17:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f1e:	e8 c6 b4 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0104f23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f2a:	e8 15 dc ff ff       	call   c0102b44 <alloc_pages>
c0104f2f:	85 c0                	test   %eax,%eax
c0104f31:	74 24                	je     c0104f57 <default_check+0x204>
c0104f33:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0104f3a:	c0 
c0104f3b:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f42:	c0 
c0104f43:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c0104f4a:	00 
c0104f4b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104f52:	e8 92 b4 ff ff       	call   c01003e9 <__panic>

    unsigned int nr_free_store = nr_free;
c0104f57:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c0104f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
c0104f5f:	c7 05 a4 af 11 c0 00 	movl   $0x0,0xc011afa4
c0104f66:	00 00 00 

    free_pages(p0 + 2, 3);
c0104f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f6c:	83 c0 28             	add    $0x28,%eax
c0104f6f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104f76:	00 
c0104f77:	89 04 24             	mov    %eax,(%esp)
c0104f7a:	e8 fd db ff ff       	call   c0102b7c <free_pages>
    assert(alloc_pages(4) == NULL);
c0104f7f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104f86:	e8 b9 db ff ff       	call   c0102b44 <alloc_pages>
c0104f8b:	85 c0                	test   %eax,%eax
c0104f8d:	74 24                	je     c0104fb3 <default_check+0x260>
c0104f8f:	c7 44 24 0c ec 6e 10 	movl   $0xc0106eec,0xc(%esp)
c0104f96:	c0 
c0104f97:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104f9e:	c0 
c0104f9f:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c0104fa6:	00 
c0104fa7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0104fae:	e8 36 b4 ff ff       	call   c01003e9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c0104fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fb6:	83 c0 28             	add    $0x28,%eax
c0104fb9:	83 c0 04             	add    $0x4,%eax
c0104fbc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c0104fc3:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104fc6:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104fc9:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104fcc:	0f a3 10             	bt     %edx,(%eax)
c0104fcf:	19 c0                	sbb    %eax,%eax
c0104fd1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
c0104fd4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104fd8:	0f 95 c0             	setne  %al
c0104fdb:	0f b6 c0             	movzbl %al,%eax
c0104fde:	85 c0                	test   %eax,%eax
c0104fe0:	74 0e                	je     c0104ff0 <default_check+0x29d>
c0104fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fe5:	83 c0 28             	add    $0x28,%eax
c0104fe8:	8b 40 08             	mov    0x8(%eax),%eax
c0104feb:	83 f8 03             	cmp    $0x3,%eax
c0104fee:	74 24                	je     c0105014 <default_check+0x2c1>
c0104ff0:	c7 44 24 0c 04 6f 10 	movl   $0xc0106f04,0xc(%esp)
c0104ff7:	c0 
c0104ff8:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0104fff:	c0 
c0105000:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0105007:	00 
c0105008:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010500f:	e8 d5 b3 ff ff       	call   c01003e9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0105014:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010501b:	e8 24 db ff ff       	call   c0102b44 <alloc_pages>
c0105020:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105023:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105027:	75 24                	jne    c010504d <default_check+0x2fa>
c0105029:	c7 44 24 0c 30 6f 10 	movl   $0xc0106f30,0xc(%esp)
c0105030:	c0 
c0105031:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105038:	c0 
c0105039:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c0105040:	00 
c0105041:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105048:	e8 9c b3 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c010504d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105054:	e8 eb da ff ff       	call   c0102b44 <alloc_pages>
c0105059:	85 c0                	test   %eax,%eax
c010505b:	74 24                	je     c0105081 <default_check+0x32e>
c010505d:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c0105064:	c0 
c0105065:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010506c:	c0 
c010506d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c0105074:	00 
c0105075:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010507c:	e8 68 b3 ff ff       	call   c01003e9 <__panic>
    assert(p0 + 2 == p1);
c0105081:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105084:	83 c0 28             	add    $0x28,%eax
c0105087:	39 45 e0             	cmp    %eax,-0x20(%ebp)
c010508a:	74 24                	je     c01050b0 <default_check+0x35d>
c010508c:	c7 44 24 0c 4e 6f 10 	movl   $0xc0106f4e,0xc(%esp)
c0105093:	c0 
c0105094:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010509b:	c0 
c010509c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01050a3:	00 
c01050a4:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01050ab:	e8 39 b3 ff ff       	call   c01003e9 <__panic>

    p2 = p0 + 1;
c01050b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050b3:	83 c0 14             	add    $0x14,%eax
c01050b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
c01050b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050c0:	00 
c01050c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050c4:	89 04 24             	mov    %eax,(%esp)
c01050c7:	e8 b0 da ff ff       	call   c0102b7c <free_pages>
    free_pages(p1, 3);
c01050cc:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01050d3:	00 
c01050d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050d7:	89 04 24             	mov    %eax,(%esp)
c01050da:	e8 9d da ff ff       	call   c0102b7c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01050df:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01050e2:	83 c0 04             	add    $0x4,%eax
c01050e5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01050ec:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01050ef:	8b 45 9c             	mov    -0x64(%ebp),%eax
c01050f2:	8b 55 a0             	mov    -0x60(%ebp),%edx
c01050f5:	0f a3 10             	bt     %edx,(%eax)
c01050f8:	19 c0                	sbb    %eax,%eax
c01050fa:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
c01050fd:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0105101:	0f 95 c0             	setne  %al
c0105104:	0f b6 c0             	movzbl %al,%eax
c0105107:	85 c0                	test   %eax,%eax
c0105109:	74 0b                	je     c0105116 <default_check+0x3c3>
c010510b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010510e:	8b 40 08             	mov    0x8(%eax),%eax
c0105111:	83 f8 01             	cmp    $0x1,%eax
c0105114:	74 24                	je     c010513a <default_check+0x3e7>
c0105116:	c7 44 24 0c 5c 6f 10 	movl   $0xc0106f5c,0xc(%esp)
c010511d:	c0 
c010511e:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105125:	c0 
c0105126:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c010512d:	00 
c010512e:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105135:	e8 af b2 ff ff       	call   c01003e9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c010513a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010513d:	83 c0 04             	add    $0x4,%eax
c0105140:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0105147:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010514a:	8b 45 90             	mov    -0x70(%ebp),%eax
c010514d:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0105150:	0f a3 10             	bt     %edx,(%eax)
c0105153:	19 c0                	sbb    %eax,%eax
c0105155:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
c0105158:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010515c:	0f 95 c0             	setne  %al
c010515f:	0f b6 c0             	movzbl %al,%eax
c0105162:	85 c0                	test   %eax,%eax
c0105164:	74 0b                	je     c0105171 <default_check+0x41e>
c0105166:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105169:	8b 40 08             	mov    0x8(%eax),%eax
c010516c:	83 f8 03             	cmp    $0x3,%eax
c010516f:	74 24                	je     c0105195 <default_check+0x442>
c0105171:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0105178:	c0 
c0105179:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105180:	c0 
c0105181:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0105188:	00 
c0105189:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105190:	e8 54 b2 ff ff       	call   c01003e9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0105195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010519c:	e8 a3 d9 ff ff       	call   c0102b44 <alloc_pages>
c01051a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051a7:	83 e8 14             	sub    $0x14,%eax
c01051aa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01051ad:	74 24                	je     c01051d3 <default_check+0x480>
c01051af:	c7 44 24 0c aa 6f 10 	movl   $0xc0106faa,0xc(%esp)
c01051b6:	c0 
c01051b7:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01051be:	c0 
c01051bf:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
c01051c6:	00 
c01051c7:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01051ce:	e8 16 b2 ff ff       	call   c01003e9 <__panic>
    free_page(p0);
c01051d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01051da:	00 
c01051db:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01051de:	89 04 24             	mov    %eax,(%esp)
c01051e1:	e8 96 d9 ff ff       	call   c0102b7c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01051e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01051ed:	e8 52 d9 ff ff       	call   c0102b44 <alloc_pages>
c01051f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01051f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01051f8:	83 c0 14             	add    $0x14,%eax
c01051fb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01051fe:	74 24                	je     c0105224 <default_check+0x4d1>
c0105200:	c7 44 24 0c c8 6f 10 	movl   $0xc0106fc8,0xc(%esp)
c0105207:	c0 
c0105208:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010520f:	c0 
c0105210:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0105217:	00 
c0105218:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010521f:	e8 c5 b1 ff ff       	call   c01003e9 <__panic>

    free_pages(p0, 2);
c0105224:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010522b:	00 
c010522c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010522f:	89 04 24             	mov    %eax,(%esp)
c0105232:	e8 45 d9 ff ff       	call   c0102b7c <free_pages>
    free_page(p2);
c0105237:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010523e:	00 
c010523f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105242:	89 04 24             	mov    %eax,(%esp)
c0105245:	e8 32 d9 ff ff       	call   c0102b7c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c010524a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0105251:	e8 ee d8 ff ff       	call   c0102b44 <alloc_pages>
c0105256:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105259:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010525d:	75 24                	jne    c0105283 <default_check+0x530>
c010525f:	c7 44 24 0c e8 6f 10 	movl   $0xc0106fe8,0xc(%esp)
c0105266:	c0 
c0105267:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c010526e:	c0 
c010526f:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0105276:	00 
c0105277:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c010527e:	e8 66 b1 ff ff       	call   c01003e9 <__panic>
    assert(alloc_page() == NULL);
c0105283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010528a:	e8 b5 d8 ff ff       	call   c0102b44 <alloc_pages>
c010528f:	85 c0                	test   %eax,%eax
c0105291:	74 24                	je     c01052b7 <default_check+0x564>
c0105293:	c7 44 24 0c 46 6e 10 	movl   $0xc0106e46,0xc(%esp)
c010529a:	c0 
c010529b:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052a2:	c0 
c01052a3:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c01052aa:	00 
c01052ab:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052b2:	e8 32 b1 ff ff       	call   c01003e9 <__panic>

    assert(nr_free == 0);
c01052b7:	a1 a4 af 11 c0       	mov    0xc011afa4,%eax
c01052bc:	85 c0                	test   %eax,%eax
c01052be:	74 24                	je     c01052e4 <default_check+0x591>
c01052c0:	c7 44 24 0c 99 6e 10 	movl   $0xc0106e99,0xc(%esp)
c01052c7:	c0 
c01052c8:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01052cf:	c0 
c01052d0:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
c01052d7:	00 
c01052d8:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01052df:	e8 05 b1 ff ff       	call   c01003e9 <__panic>
    nr_free = nr_free_store;
c01052e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01052e7:	a3 a4 af 11 c0       	mov    %eax,0xc011afa4

    free_list = free_list_store;
c01052ec:	8b 45 80             	mov    -0x80(%ebp),%eax
c01052ef:	8b 55 84             	mov    -0x7c(%ebp),%edx
c01052f2:	a3 9c af 11 c0       	mov    %eax,0xc011af9c
c01052f7:	89 15 a0 af 11 c0    	mov    %edx,0xc011afa0
    free_pages(p0, 5);
c01052fd:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0105304:	00 
c0105305:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105308:	89 04 24             	mov    %eax,(%esp)
c010530b:	e8 6c d8 ff ff       	call   c0102b7c <free_pages>

    le = &free_list;
c0105310:	c7 45 ec 9c af 11 c0 	movl   $0xc011af9c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0105317:	eb 5a                	jmp    c0105373 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
c0105319:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010531c:	8b 40 04             	mov    0x4(%eax),%eax
c010531f:	8b 00                	mov    (%eax),%eax
c0105321:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105324:	75 0d                	jne    c0105333 <default_check+0x5e0>
c0105326:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105329:	8b 00                	mov    (%eax),%eax
c010532b:	8b 40 04             	mov    0x4(%eax),%eax
c010532e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105331:	74 24                	je     c0105357 <default_check+0x604>
c0105333:	c7 44 24 0c 08 70 10 	movl   $0xc0107008,0xc(%esp)
c010533a:	c0 
c010533b:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c0105342:	c0 
c0105343:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
c010534a:	00 
c010534b:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c0105352:	e8 92 b0 ff ff       	call   c01003e9 <__panic>
        struct Page *p = le2page(le, page_link);
c0105357:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010535a:	83 e8 0c             	sub    $0xc,%eax
c010535d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
c0105360:	ff 4d f4             	decl   -0xc(%ebp)
c0105363:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105366:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105369:	8b 40 08             	mov    0x8(%eax),%eax
c010536c:	29 c2                	sub    %eax,%edx
c010536e:	89 d0                	mov    %edx,%eax
c0105370:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105373:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105376:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
c0105379:	8b 45 88             	mov    -0x78(%ebp),%eax
c010537c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
c010537f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105382:	81 7d ec 9c af 11 c0 	cmpl   $0xc011af9c,-0x14(%ebp)
c0105389:	75 8e                	jne    c0105319 <default_check+0x5c6>
    }
    assert(count == 0);
c010538b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010538f:	74 24                	je     c01053b5 <default_check+0x662>
c0105391:	c7 44 24 0c 35 70 10 	movl   $0xc0107035,0xc(%esp)
c0105398:	c0 
c0105399:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01053a0:	c0 
c01053a1:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
c01053a8:	00 
c01053a9:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01053b0:	e8 34 b0 ff ff       	call   c01003e9 <__panic>
    assert(total == 0);
c01053b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01053b9:	74 24                	je     c01053df <default_check+0x68c>
c01053bb:	c7 44 24 0c 40 70 10 	movl   $0xc0107040,0xc(%esp)
c01053c2:	c0 
c01053c3:	c7 44 24 08 be 6c 10 	movl   $0xc0106cbe,0x8(%esp)
c01053ca:	c0 
c01053cb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c01053d2:	00 
c01053d3:	c7 04 24 d3 6c 10 c0 	movl   $0xc0106cd3,(%esp)
c01053da:	e8 0a b0 ff ff       	call   c01003e9 <__panic>
}
c01053df:	90                   	nop
c01053e0:	c9                   	leave  
c01053e1:	c3                   	ret    

c01053e2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01053e2:	55                   	push   %ebp
c01053e3:	89 e5                	mov    %esp,%ebp
c01053e5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01053e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01053ef:	eb 03                	jmp    c01053f4 <strlen+0x12>
        cnt ++;
c01053f1:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
c01053f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01053f7:	8d 50 01             	lea    0x1(%eax),%edx
c01053fa:	89 55 08             	mov    %edx,0x8(%ebp)
c01053fd:	0f b6 00             	movzbl (%eax),%eax
c0105400:	84 c0                	test   %al,%al
c0105402:	75 ed                	jne    c01053f1 <strlen+0xf>
    }
    return cnt;
c0105404:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105407:	c9                   	leave  
c0105408:	c3                   	ret    

c0105409 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105409:	55                   	push   %ebp
c010540a:	89 e5                	mov    %esp,%ebp
c010540c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010540f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105416:	eb 03                	jmp    c010541b <strnlen+0x12>
        cnt ++;
c0105418:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010541b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010541e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105421:	73 10                	jae    c0105433 <strnlen+0x2a>
c0105423:	8b 45 08             	mov    0x8(%ebp),%eax
c0105426:	8d 50 01             	lea    0x1(%eax),%edx
c0105429:	89 55 08             	mov    %edx,0x8(%ebp)
c010542c:	0f b6 00             	movzbl (%eax),%eax
c010542f:	84 c0                	test   %al,%al
c0105431:	75 e5                	jne    c0105418 <strnlen+0xf>
    }
    return cnt;
c0105433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105436:	c9                   	leave  
c0105437:	c3                   	ret    

c0105438 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105438:	55                   	push   %ebp
c0105439:	89 e5                	mov    %esp,%ebp
c010543b:	57                   	push   %edi
c010543c:	56                   	push   %esi
c010543d:	83 ec 20             	sub    $0x20,%esp
c0105440:	8b 45 08             	mov    0x8(%ebp),%eax
c0105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105446:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105449:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010544c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105452:	89 d1                	mov    %edx,%ecx
c0105454:	89 c2                	mov    %eax,%edx
c0105456:	89 ce                	mov    %ecx,%esi
c0105458:	89 d7                	mov    %edx,%edi
c010545a:	ac                   	lods   %ds:(%esi),%al
c010545b:	aa                   	stos   %al,%es:(%edi)
c010545c:	84 c0                	test   %al,%al
c010545e:	75 fa                	jne    c010545a <strcpy+0x22>
c0105460:	89 fa                	mov    %edi,%edx
c0105462:	89 f1                	mov    %esi,%ecx
c0105464:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105467:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010546a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010546d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
c0105470:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105471:	83 c4 20             	add    $0x20,%esp
c0105474:	5e                   	pop    %esi
c0105475:	5f                   	pop    %edi
c0105476:	5d                   	pop    %ebp
c0105477:	c3                   	ret    

c0105478 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105478:	55                   	push   %ebp
c0105479:	89 e5                	mov    %esp,%ebp
c010547b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010547e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105481:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105484:	eb 1e                	jmp    c01054a4 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
c0105486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105489:	0f b6 10             	movzbl (%eax),%edx
c010548c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010548f:	88 10                	mov    %dl,(%eax)
c0105491:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105494:	0f b6 00             	movzbl (%eax),%eax
c0105497:	84 c0                	test   %al,%al
c0105499:	74 03                	je     c010549e <strncpy+0x26>
            src ++;
c010549b:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
c010549e:	ff 45 fc             	incl   -0x4(%ebp)
c01054a1:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
c01054a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01054a8:	75 dc                	jne    c0105486 <strncpy+0xe>
    }
    return dst;
c01054aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01054ad:	c9                   	leave  
c01054ae:	c3                   	ret    

c01054af <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c01054af:	55                   	push   %ebp
c01054b0:	89 e5                	mov    %esp,%ebp
c01054b2:	57                   	push   %edi
c01054b3:	56                   	push   %esi
c01054b4:	83 ec 20             	sub    $0x20,%esp
c01054b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01054ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01054c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
c01054c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01054c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054c9:	89 d1                	mov    %edx,%ecx
c01054cb:	89 c2                	mov    %eax,%edx
c01054cd:	89 ce                	mov    %ecx,%esi
c01054cf:	89 d7                	mov    %edx,%edi
c01054d1:	ac                   	lods   %ds:(%esi),%al
c01054d2:	ae                   	scas   %es:(%edi),%al
c01054d3:	75 08                	jne    c01054dd <strcmp+0x2e>
c01054d5:	84 c0                	test   %al,%al
c01054d7:	75 f8                	jne    c01054d1 <strcmp+0x22>
c01054d9:	31 c0                	xor    %eax,%eax
c01054db:	eb 04                	jmp    c01054e1 <strcmp+0x32>
c01054dd:	19 c0                	sbb    %eax,%eax
c01054df:	0c 01                	or     $0x1,%al
c01054e1:	89 fa                	mov    %edi,%edx
c01054e3:	89 f1                	mov    %esi,%ecx
c01054e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01054e8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c01054eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
c01054ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
c01054f1:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c01054f2:	83 c4 20             	add    $0x20,%esp
c01054f5:	5e                   	pop    %esi
c01054f6:	5f                   	pop    %edi
c01054f7:	5d                   	pop    %ebp
c01054f8:	c3                   	ret    

c01054f9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c01054f9:	55                   	push   %ebp
c01054fa:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c01054fc:	eb 09                	jmp    c0105507 <strncmp+0xe>
        n --, s1 ++, s2 ++;
c01054fe:	ff 4d 10             	decl   0x10(%ebp)
c0105501:	ff 45 08             	incl   0x8(%ebp)
c0105504:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010550b:	74 1a                	je     c0105527 <strncmp+0x2e>
c010550d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105510:	0f b6 00             	movzbl (%eax),%eax
c0105513:	84 c0                	test   %al,%al
c0105515:	74 10                	je     c0105527 <strncmp+0x2e>
c0105517:	8b 45 08             	mov    0x8(%ebp),%eax
c010551a:	0f b6 10             	movzbl (%eax),%edx
c010551d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105520:	0f b6 00             	movzbl (%eax),%eax
c0105523:	38 c2                	cmp    %al,%dl
c0105525:	74 d7                	je     c01054fe <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010552b:	74 18                	je     c0105545 <strncmp+0x4c>
c010552d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105530:	0f b6 00             	movzbl (%eax),%eax
c0105533:	0f b6 d0             	movzbl %al,%edx
c0105536:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105539:	0f b6 00             	movzbl (%eax),%eax
c010553c:	0f b6 c0             	movzbl %al,%eax
c010553f:	29 c2                	sub    %eax,%edx
c0105541:	89 d0                	mov    %edx,%eax
c0105543:	eb 05                	jmp    c010554a <strncmp+0x51>
c0105545:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010554a:	5d                   	pop    %ebp
c010554b:	c3                   	ret    

c010554c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010554c:	55                   	push   %ebp
c010554d:	89 e5                	mov    %esp,%ebp
c010554f:	83 ec 04             	sub    $0x4,%esp
c0105552:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105555:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105558:	eb 13                	jmp    c010556d <strchr+0x21>
        if (*s == c) {
c010555a:	8b 45 08             	mov    0x8(%ebp),%eax
c010555d:	0f b6 00             	movzbl (%eax),%eax
c0105560:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105563:	75 05                	jne    c010556a <strchr+0x1e>
            return (char *)s;
c0105565:	8b 45 08             	mov    0x8(%ebp),%eax
c0105568:	eb 12                	jmp    c010557c <strchr+0x30>
        }
        s ++;
c010556a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010556d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105570:	0f b6 00             	movzbl (%eax),%eax
c0105573:	84 c0                	test   %al,%al
c0105575:	75 e3                	jne    c010555a <strchr+0xe>
    }
    return NULL;
c0105577:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010557c:	c9                   	leave  
c010557d:	c3                   	ret    

c010557e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010557e:	55                   	push   %ebp
c010557f:	89 e5                	mov    %esp,%ebp
c0105581:	83 ec 04             	sub    $0x4,%esp
c0105584:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105587:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010558a:	eb 0e                	jmp    c010559a <strfind+0x1c>
        if (*s == c) {
c010558c:	8b 45 08             	mov    0x8(%ebp),%eax
c010558f:	0f b6 00             	movzbl (%eax),%eax
c0105592:	38 45 fc             	cmp    %al,-0x4(%ebp)
c0105595:	74 0f                	je     c01055a6 <strfind+0x28>
            break;
        }
        s ++;
c0105597:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
c010559a:	8b 45 08             	mov    0x8(%ebp),%eax
c010559d:	0f b6 00             	movzbl (%eax),%eax
c01055a0:	84 c0                	test   %al,%al
c01055a2:	75 e8                	jne    c010558c <strfind+0xe>
c01055a4:	eb 01                	jmp    c01055a7 <strfind+0x29>
            break;
c01055a6:	90                   	nop
    }
    return (char *)s;
c01055a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
c01055aa:	c9                   	leave  
c01055ab:	c3                   	ret    

c01055ac <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c01055ac:	55                   	push   %ebp
c01055ad:	89 e5                	mov    %esp,%ebp
c01055af:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c01055b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c01055b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c01055c0:	eb 03                	jmp    c01055c5 <strtol+0x19>
        s ++;
c01055c2:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
c01055c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01055c8:	0f b6 00             	movzbl (%eax),%eax
c01055cb:	3c 20                	cmp    $0x20,%al
c01055cd:	74 f3                	je     c01055c2 <strtol+0x16>
c01055cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01055d2:	0f b6 00             	movzbl (%eax),%eax
c01055d5:	3c 09                	cmp    $0x9,%al
c01055d7:	74 e9                	je     c01055c2 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
c01055d9:	8b 45 08             	mov    0x8(%ebp),%eax
c01055dc:	0f b6 00             	movzbl (%eax),%eax
c01055df:	3c 2b                	cmp    $0x2b,%al
c01055e1:	75 05                	jne    c01055e8 <strtol+0x3c>
        s ++;
c01055e3:	ff 45 08             	incl   0x8(%ebp)
c01055e6:	eb 14                	jmp    c01055fc <strtol+0x50>
    }
    else if (*s == '-') {
c01055e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01055eb:	0f b6 00             	movzbl (%eax),%eax
c01055ee:	3c 2d                	cmp    $0x2d,%al
c01055f0:	75 0a                	jne    c01055fc <strtol+0x50>
        s ++, neg = 1;
c01055f2:	ff 45 08             	incl   0x8(%ebp)
c01055f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c01055fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105600:	74 06                	je     c0105608 <strtol+0x5c>
c0105602:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105606:	75 22                	jne    c010562a <strtol+0x7e>
c0105608:	8b 45 08             	mov    0x8(%ebp),%eax
c010560b:	0f b6 00             	movzbl (%eax),%eax
c010560e:	3c 30                	cmp    $0x30,%al
c0105610:	75 18                	jne    c010562a <strtol+0x7e>
c0105612:	8b 45 08             	mov    0x8(%ebp),%eax
c0105615:	40                   	inc    %eax
c0105616:	0f b6 00             	movzbl (%eax),%eax
c0105619:	3c 78                	cmp    $0x78,%al
c010561b:	75 0d                	jne    c010562a <strtol+0x7e>
        s += 2, base = 16;
c010561d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105621:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105628:	eb 29                	jmp    c0105653 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
c010562a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010562e:	75 16                	jne    c0105646 <strtol+0x9a>
c0105630:	8b 45 08             	mov    0x8(%ebp),%eax
c0105633:	0f b6 00             	movzbl (%eax),%eax
c0105636:	3c 30                	cmp    $0x30,%al
c0105638:	75 0c                	jne    c0105646 <strtol+0x9a>
        s ++, base = 8;
c010563a:	ff 45 08             	incl   0x8(%ebp)
c010563d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0105644:	eb 0d                	jmp    c0105653 <strtol+0xa7>
    }
    else if (base == 0) {
c0105646:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010564a:	75 07                	jne    c0105653 <strtol+0xa7>
        base = 10;
c010564c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0105653:	8b 45 08             	mov    0x8(%ebp),%eax
c0105656:	0f b6 00             	movzbl (%eax),%eax
c0105659:	3c 2f                	cmp    $0x2f,%al
c010565b:	7e 1b                	jle    c0105678 <strtol+0xcc>
c010565d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105660:	0f b6 00             	movzbl (%eax),%eax
c0105663:	3c 39                	cmp    $0x39,%al
c0105665:	7f 11                	jg     c0105678 <strtol+0xcc>
            dig = *s - '0';
c0105667:	8b 45 08             	mov    0x8(%ebp),%eax
c010566a:	0f b6 00             	movzbl (%eax),%eax
c010566d:	0f be c0             	movsbl %al,%eax
c0105670:	83 e8 30             	sub    $0x30,%eax
c0105673:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105676:	eb 48                	jmp    c01056c0 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0105678:	8b 45 08             	mov    0x8(%ebp),%eax
c010567b:	0f b6 00             	movzbl (%eax),%eax
c010567e:	3c 60                	cmp    $0x60,%al
c0105680:	7e 1b                	jle    c010569d <strtol+0xf1>
c0105682:	8b 45 08             	mov    0x8(%ebp),%eax
c0105685:	0f b6 00             	movzbl (%eax),%eax
c0105688:	3c 7a                	cmp    $0x7a,%al
c010568a:	7f 11                	jg     c010569d <strtol+0xf1>
            dig = *s - 'a' + 10;
c010568c:	8b 45 08             	mov    0x8(%ebp),%eax
c010568f:	0f b6 00             	movzbl (%eax),%eax
c0105692:	0f be c0             	movsbl %al,%eax
c0105695:	83 e8 57             	sub    $0x57,%eax
c0105698:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010569b:	eb 23                	jmp    c01056c0 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010569d:	8b 45 08             	mov    0x8(%ebp),%eax
c01056a0:	0f b6 00             	movzbl (%eax),%eax
c01056a3:	3c 40                	cmp    $0x40,%al
c01056a5:	7e 3b                	jle    c01056e2 <strtol+0x136>
c01056a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01056aa:	0f b6 00             	movzbl (%eax),%eax
c01056ad:	3c 5a                	cmp    $0x5a,%al
c01056af:	7f 31                	jg     c01056e2 <strtol+0x136>
            dig = *s - 'A' + 10;
c01056b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01056b4:	0f b6 00             	movzbl (%eax),%eax
c01056b7:	0f be c0             	movsbl %al,%eax
c01056ba:	83 e8 37             	sub    $0x37,%eax
c01056bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c01056c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056c3:	3b 45 10             	cmp    0x10(%ebp),%eax
c01056c6:	7d 19                	jge    c01056e1 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
c01056c8:	ff 45 08             	incl   0x8(%ebp)
c01056cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056ce:	0f af 45 10          	imul   0x10(%ebp),%eax
c01056d2:	89 c2                	mov    %eax,%edx
c01056d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056d7:	01 d0                	add    %edx,%eax
c01056d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
c01056dc:	e9 72 ff ff ff       	jmp    c0105653 <strtol+0xa7>
            break;
c01056e1:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
c01056e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01056e6:	74 08                	je     c01056f0 <strtol+0x144>
        *endptr = (char *) s;
c01056e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056eb:	8b 55 08             	mov    0x8(%ebp),%edx
c01056ee:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01056f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01056f4:	74 07                	je     c01056fd <strtol+0x151>
c01056f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01056f9:	f7 d8                	neg    %eax
c01056fb:	eb 03                	jmp    c0105700 <strtol+0x154>
c01056fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0105700:	c9                   	leave  
c0105701:	c3                   	ret    

c0105702 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0105702:	55                   	push   %ebp
c0105703:	89 e5                	mov    %esp,%ebp
c0105705:	57                   	push   %edi
c0105706:	83 ec 24             	sub    $0x24,%esp
c0105709:	8b 45 0c             	mov    0xc(%ebp),%eax
c010570c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010570f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
c0105713:	8b 55 08             	mov    0x8(%ebp),%edx
c0105716:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0105719:	88 45 f7             	mov    %al,-0x9(%ebp)
c010571c:	8b 45 10             	mov    0x10(%ebp),%eax
c010571f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0105722:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0105725:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
c0105729:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010572c:	89 d7                	mov    %edx,%edi
c010572e:	f3 aa                	rep stos %al,%es:(%edi)
c0105730:	89 fa                	mov    %edi,%edx
c0105732:	89 4d ec             	mov    %ecx,-0x14(%ebp)
c0105735:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0105738:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010573b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010573c:	83 c4 24             	add    $0x24,%esp
c010573f:	5f                   	pop    %edi
c0105740:	5d                   	pop    %ebp
c0105741:	c3                   	ret    

c0105742 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0105742:	55                   	push   %ebp
c0105743:	89 e5                	mov    %esp,%ebp
c0105745:	57                   	push   %edi
c0105746:	56                   	push   %esi
c0105747:	53                   	push   %ebx
c0105748:	83 ec 30             	sub    $0x30,%esp
c010574b:	8b 45 08             	mov    0x8(%ebp),%eax
c010574e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105751:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105754:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105757:	8b 45 10             	mov    0x10(%ebp),%eax
c010575a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010575d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105760:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0105763:	73 42                	jae    c01057a7 <memmove+0x65>
c0105765:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010576b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010576e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105771:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105774:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0105777:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010577a:	c1 e8 02             	shr    $0x2,%eax
c010577d:	89 c1                	mov    %eax,%ecx
    asm volatile (
c010577f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105782:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105785:	89 d7                	mov    %edx,%edi
c0105787:	89 c6                	mov    %eax,%esi
c0105789:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010578b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010578e:	83 e1 03             	and    $0x3,%ecx
c0105791:	74 02                	je     c0105795 <memmove+0x53>
c0105793:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0105795:	89 f0                	mov    %esi,%eax
c0105797:	89 fa                	mov    %edi,%edx
c0105799:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010579c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010579f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
c01057a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
c01057a5:	eb 36                	jmp    c01057dd <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c01057a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057aa:	8d 50 ff             	lea    -0x1(%eax),%edx
c01057ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01057b0:	01 c2                	add    %eax,%edx
c01057b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057b5:	8d 48 ff             	lea    -0x1(%eax),%ecx
c01057b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01057bb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
c01057be:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01057c1:	89 c1                	mov    %eax,%ecx
c01057c3:	89 d8                	mov    %ebx,%eax
c01057c5:	89 d6                	mov    %edx,%esi
c01057c7:	89 c7                	mov    %eax,%edi
c01057c9:	fd                   	std    
c01057ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01057cc:	fc                   	cld    
c01057cd:	89 f8                	mov    %edi,%eax
c01057cf:	89 f2                	mov    %esi,%edx
c01057d1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01057d4:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01057d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
c01057da:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01057dd:	83 c4 30             	add    $0x30,%esp
c01057e0:	5b                   	pop    %ebx
c01057e1:	5e                   	pop    %esi
c01057e2:	5f                   	pop    %edi
c01057e3:	5d                   	pop    %ebp
c01057e4:	c3                   	ret    

c01057e5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01057e5:	55                   	push   %ebp
c01057e6:	89 e5                	mov    %esp,%ebp
c01057e8:	57                   	push   %edi
c01057e9:	56                   	push   %esi
c01057ea:	83 ec 20             	sub    $0x20,%esp
c01057ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057f3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01057fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01057ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105802:	c1 e8 02             	shr    $0x2,%eax
c0105805:	89 c1                	mov    %eax,%ecx
    asm volatile (
c0105807:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010580a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010580d:	89 d7                	mov    %edx,%edi
c010580f:	89 c6                	mov    %eax,%esi
c0105811:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0105813:	8b 4d ec             	mov    -0x14(%ebp),%ecx
c0105816:	83 e1 03             	and    $0x3,%ecx
c0105819:	74 02                	je     c010581d <memcpy+0x38>
c010581b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010581d:	89 f0                	mov    %esi,%eax
c010581f:	89 fa                	mov    %edi,%edx
c0105821:	89 4d e8             	mov    %ecx,-0x18(%ebp)
c0105824:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0105827:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
c010582a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
c010582d:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010582e:	83 c4 20             	add    $0x20,%esp
c0105831:	5e                   	pop    %esi
c0105832:	5f                   	pop    %edi
c0105833:	5d                   	pop    %ebp
c0105834:	c3                   	ret    

c0105835 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0105835:	55                   	push   %ebp
c0105836:	89 e5                	mov    %esp,%ebp
c0105838:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010583b:	8b 45 08             	mov    0x8(%ebp),%eax
c010583e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0105841:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105844:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0105847:	eb 2e                	jmp    c0105877 <memcmp+0x42>
        if (*s1 != *s2) {
c0105849:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010584c:	0f b6 10             	movzbl (%eax),%edx
c010584f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105852:	0f b6 00             	movzbl (%eax),%eax
c0105855:	38 c2                	cmp    %al,%dl
c0105857:	74 18                	je     c0105871 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105859:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010585c:	0f b6 00             	movzbl (%eax),%eax
c010585f:	0f b6 d0             	movzbl %al,%edx
c0105862:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105865:	0f b6 00             	movzbl (%eax),%eax
c0105868:	0f b6 c0             	movzbl %al,%eax
c010586b:	29 c2                	sub    %eax,%edx
c010586d:	89 d0                	mov    %edx,%eax
c010586f:	eb 18                	jmp    c0105889 <memcmp+0x54>
        }
        s1 ++, s2 ++;
c0105871:	ff 45 fc             	incl   -0x4(%ebp)
c0105874:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
c0105877:	8b 45 10             	mov    0x10(%ebp),%eax
c010587a:	8d 50 ff             	lea    -0x1(%eax),%edx
c010587d:	89 55 10             	mov    %edx,0x10(%ebp)
c0105880:	85 c0                	test   %eax,%eax
c0105882:	75 c5                	jne    c0105849 <memcmp+0x14>
    }
    return 0;
c0105884:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105889:	c9                   	leave  
c010588a:	c3                   	ret    

c010588b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010588b:	55                   	push   %ebp
c010588c:	89 e5                	mov    %esp,%ebp
c010588e:	83 ec 58             	sub    $0x58,%esp
c0105891:	8b 45 10             	mov    0x10(%ebp),%eax
c0105894:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105897:	8b 45 14             	mov    0x14(%ebp),%eax
c010589a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010589d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01058a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01058a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01058a9:	8b 45 18             	mov    0x18(%ebp),%eax
c01058ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01058af:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01058b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01058b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058be:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01058c5:	74 1c                	je     c01058e3 <printnum+0x58>
c01058c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058ca:	ba 00 00 00 00       	mov    $0x0,%edx
c01058cf:	f7 75 e4             	divl   -0x1c(%ebp)
c01058d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01058d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058d8:	ba 00 00 00 00       	mov    $0x0,%edx
c01058dd:	f7 75 e4             	divl   -0x1c(%ebp)
c01058e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01058e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01058e9:	f7 75 e4             	divl   -0x1c(%ebp)
c01058ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01058ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
c01058f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01058f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01058f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01058fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01058fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105901:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0105904:	8b 45 18             	mov    0x18(%ebp),%eax
c0105907:	ba 00 00 00 00       	mov    $0x0,%edx
c010590c:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c010590f:	72 56                	jb     c0105967 <printnum+0xdc>
c0105911:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
c0105914:	77 05                	ja     c010591b <printnum+0x90>
c0105916:	39 45 d0             	cmp    %eax,-0x30(%ebp)
c0105919:	72 4c                	jb     c0105967 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
c010591b:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010591e:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105921:	8b 45 20             	mov    0x20(%ebp),%eax
c0105924:	89 44 24 18          	mov    %eax,0x18(%esp)
c0105928:	89 54 24 14          	mov    %edx,0x14(%esp)
c010592c:	8b 45 18             	mov    0x18(%ebp),%eax
c010592f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105933:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105936:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105939:	89 44 24 08          	mov    %eax,0x8(%esp)
c010593d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105941:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105944:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105948:	8b 45 08             	mov    0x8(%ebp),%eax
c010594b:	89 04 24             	mov    %eax,(%esp)
c010594e:	e8 38 ff ff ff       	call   c010588b <printnum>
c0105953:	eb 1b                	jmp    c0105970 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c0105955:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105958:	89 44 24 04          	mov    %eax,0x4(%esp)
c010595c:	8b 45 20             	mov    0x20(%ebp),%eax
c010595f:	89 04 24             	mov    %eax,(%esp)
c0105962:	8b 45 08             	mov    0x8(%ebp),%eax
c0105965:	ff d0                	call   *%eax
        while (-- width > 0)
c0105967:	ff 4d 1c             	decl   0x1c(%ebp)
c010596a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010596e:	7f e5                	jg     c0105955 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c0105970:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105973:	05 fc 70 10 c0       	add    $0xc01070fc,%eax
c0105978:	0f b6 00             	movzbl (%eax),%eax
c010597b:	0f be c0             	movsbl %al,%eax
c010597e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105981:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105985:	89 04 24             	mov    %eax,(%esp)
c0105988:	8b 45 08             	mov    0x8(%ebp),%eax
c010598b:	ff d0                	call   *%eax
}
c010598d:	90                   	nop
c010598e:	c9                   	leave  
c010598f:	c3                   	ret    

c0105990 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0105990:	55                   	push   %ebp
c0105991:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0105993:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105997:	7e 14                	jle    c01059ad <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105999:	8b 45 08             	mov    0x8(%ebp),%eax
c010599c:	8b 00                	mov    (%eax),%eax
c010599e:	8d 48 08             	lea    0x8(%eax),%ecx
c01059a1:	8b 55 08             	mov    0x8(%ebp),%edx
c01059a4:	89 0a                	mov    %ecx,(%edx)
c01059a6:	8b 50 04             	mov    0x4(%eax),%edx
c01059a9:	8b 00                	mov    (%eax),%eax
c01059ab:	eb 30                	jmp    c01059dd <getuint+0x4d>
    }
    else if (lflag) {
c01059ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01059b1:	74 16                	je     c01059c9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c01059b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059b6:	8b 00                	mov    (%eax),%eax
c01059b8:	8d 48 04             	lea    0x4(%eax),%ecx
c01059bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01059be:	89 0a                	mov    %ecx,(%edx)
c01059c0:	8b 00                	mov    (%eax),%eax
c01059c2:	ba 00 00 00 00       	mov    $0x0,%edx
c01059c7:	eb 14                	jmp    c01059dd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c01059c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cc:	8b 00                	mov    (%eax),%eax
c01059ce:	8d 48 04             	lea    0x4(%eax),%ecx
c01059d1:	8b 55 08             	mov    0x8(%ebp),%edx
c01059d4:	89 0a                	mov    %ecx,(%edx)
c01059d6:	8b 00                	mov    (%eax),%eax
c01059d8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c01059dd:	5d                   	pop    %ebp
c01059de:	c3                   	ret    

c01059df <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c01059df:	55                   	push   %ebp
c01059e0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01059e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c01059e6:	7e 14                	jle    c01059fc <getint+0x1d>
        return va_arg(*ap, long long);
c01059e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01059eb:	8b 00                	mov    (%eax),%eax
c01059ed:	8d 48 08             	lea    0x8(%eax),%ecx
c01059f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01059f3:	89 0a                	mov    %ecx,(%edx)
c01059f5:	8b 50 04             	mov    0x4(%eax),%edx
c01059f8:	8b 00                	mov    (%eax),%eax
c01059fa:	eb 28                	jmp    c0105a24 <getint+0x45>
    }
    else if (lflag) {
c01059fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105a00:	74 12                	je     c0105a14 <getint+0x35>
        return va_arg(*ap, long);
c0105a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a05:	8b 00                	mov    (%eax),%eax
c0105a07:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a0a:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a0d:	89 0a                	mov    %ecx,(%edx)
c0105a0f:	8b 00                	mov    (%eax),%eax
c0105a11:	99                   	cltd   
c0105a12:	eb 10                	jmp    c0105a24 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
c0105a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a17:	8b 00                	mov    (%eax),%eax
c0105a19:	8d 48 04             	lea    0x4(%eax),%ecx
c0105a1c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105a1f:	89 0a                	mov    %ecx,(%edx)
c0105a21:	8b 00                	mov    (%eax),%eax
c0105a23:	99                   	cltd   
    }
}
c0105a24:	5d                   	pop    %ebp
c0105a25:	c3                   	ret    

c0105a26 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c0105a26:	55                   	push   %ebp
c0105a27:	89 e5                	mov    %esp,%ebp
c0105a29:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c0105a2c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
c0105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a35:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a39:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a43:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a47:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a4a:	89 04 24             	mov    %eax,(%esp)
c0105a4d:	e8 03 00 00 00       	call   c0105a55 <vprintfmt>
    va_end(ap);
}
c0105a52:	90                   	nop
c0105a53:	c9                   	leave  
c0105a54:	c3                   	ret    

c0105a55 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c0105a55:	55                   	push   %ebp
c0105a56:	89 e5                	mov    %esp,%ebp
c0105a58:	56                   	push   %esi
c0105a59:	53                   	push   %ebx
c0105a5a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a5d:	eb 17                	jmp    c0105a76 <vprintfmt+0x21>
            if (ch == '\0') {
c0105a5f:	85 db                	test   %ebx,%ebx
c0105a61:	0f 84 bf 03 00 00    	je     c0105e26 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
c0105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a6e:	89 1c 24             	mov    %ebx,(%esp)
c0105a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a74:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105a76:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a79:	8d 50 01             	lea    0x1(%eax),%edx
c0105a7c:	89 55 10             	mov    %edx,0x10(%ebp)
c0105a7f:	0f b6 00             	movzbl (%eax),%eax
c0105a82:	0f b6 d8             	movzbl %al,%ebx
c0105a85:	83 fb 25             	cmp    $0x25,%ebx
c0105a88:	75 d5                	jne    c0105a5f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105a8a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105a8e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0105a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a98:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105a9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105aa5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105aa8:	8b 45 10             	mov    0x10(%ebp),%eax
c0105aab:	8d 50 01             	lea    0x1(%eax),%edx
c0105aae:	89 55 10             	mov    %edx,0x10(%ebp)
c0105ab1:	0f b6 00             	movzbl (%eax),%eax
c0105ab4:	0f b6 d8             	movzbl %al,%ebx
c0105ab7:	8d 43 dd             	lea    -0x23(%ebx),%eax
c0105aba:	83 f8 55             	cmp    $0x55,%eax
c0105abd:	0f 87 37 03 00 00    	ja     c0105dfa <vprintfmt+0x3a5>
c0105ac3:	8b 04 85 20 71 10 c0 	mov    -0x3fef8ee0(,%eax,4),%eax
c0105aca:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0105acc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0105ad0:	eb d6                	jmp    c0105aa8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105ad2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105ad6:	eb d0                	jmp    c0105aa8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105ad8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0105adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105ae2:	89 d0                	mov    %edx,%eax
c0105ae4:	c1 e0 02             	shl    $0x2,%eax
c0105ae7:	01 d0                	add    %edx,%eax
c0105ae9:	01 c0                	add    %eax,%eax
c0105aeb:	01 d8                	add    %ebx,%eax
c0105aed:	83 e8 30             	sub    $0x30,%eax
c0105af0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105af3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105af6:	0f b6 00             	movzbl (%eax),%eax
c0105af9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0105afc:	83 fb 2f             	cmp    $0x2f,%ebx
c0105aff:	7e 38                	jle    c0105b39 <vprintfmt+0xe4>
c0105b01:	83 fb 39             	cmp    $0x39,%ebx
c0105b04:	7f 33                	jg     c0105b39 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
c0105b06:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
c0105b09:	eb d4                	jmp    c0105adf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0105b0b:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b0e:	8d 50 04             	lea    0x4(%eax),%edx
c0105b11:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b14:	8b 00                	mov    (%eax),%eax
c0105b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105b19:	eb 1f                	jmp    c0105b3a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
c0105b1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b1f:	79 87                	jns    c0105aa8 <vprintfmt+0x53>
                width = 0;
c0105b21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c0105b28:	e9 7b ff ff ff       	jmp    c0105aa8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
c0105b2d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c0105b34:	e9 6f ff ff ff       	jmp    c0105aa8 <vprintfmt+0x53>
            goto process_precision;
c0105b39:	90                   	nop

        process_precision:
            if (width < 0)
c0105b3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b3e:	0f 89 64 ff ff ff    	jns    c0105aa8 <vprintfmt+0x53>
                width = precision, precision = -1;
c0105b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b47:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105b4a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c0105b51:	e9 52 ff ff ff       	jmp    c0105aa8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c0105b56:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
c0105b59:	e9 4a ff ff ff       	jmp    c0105aa8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c0105b5e:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b61:	8d 50 04             	lea    0x4(%eax),%edx
c0105b64:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b67:	8b 00                	mov    (%eax),%eax
c0105b69:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105b6c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b70:	89 04 24             	mov    %eax,(%esp)
c0105b73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b76:	ff d0                	call   *%eax
            break;
c0105b78:	e9 a4 02 00 00       	jmp    c0105e21 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0105b7d:	8b 45 14             	mov    0x14(%ebp),%eax
c0105b80:	8d 50 04             	lea    0x4(%eax),%edx
c0105b83:	89 55 14             	mov    %edx,0x14(%ebp)
c0105b86:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105b88:	85 db                	test   %ebx,%ebx
c0105b8a:	79 02                	jns    c0105b8e <vprintfmt+0x139>
                err = -err;
c0105b8c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105b8e:	83 fb 06             	cmp    $0x6,%ebx
c0105b91:	7f 0b                	jg     c0105b9e <vprintfmt+0x149>
c0105b93:	8b 34 9d e0 70 10 c0 	mov    -0x3fef8f20(,%ebx,4),%esi
c0105b9a:	85 f6                	test   %esi,%esi
c0105b9c:	75 23                	jne    c0105bc1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
c0105b9e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ba2:	c7 44 24 08 0d 71 10 	movl   $0xc010710d,0x8(%esp)
c0105ba9:	c0 
c0105baa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bb4:	89 04 24             	mov    %eax,(%esp)
c0105bb7:	e8 6a fe ff ff       	call   c0105a26 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105bbc:	e9 60 02 00 00       	jmp    c0105e21 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
c0105bc1:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105bc5:	c7 44 24 08 16 71 10 	movl   $0xc0107116,0x8(%esp)
c0105bcc:	c0 
c0105bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bd4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bd7:	89 04 24             	mov    %eax,(%esp)
c0105bda:	e8 47 fe ff ff       	call   c0105a26 <printfmt>
            break;
c0105bdf:	e9 3d 02 00 00       	jmp    c0105e21 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105be4:	8b 45 14             	mov    0x14(%ebp),%eax
c0105be7:	8d 50 04             	lea    0x4(%eax),%edx
c0105bea:	89 55 14             	mov    %edx,0x14(%ebp)
c0105bed:	8b 30                	mov    (%eax),%esi
c0105bef:	85 f6                	test   %esi,%esi
c0105bf1:	75 05                	jne    c0105bf8 <vprintfmt+0x1a3>
                p = "(null)";
c0105bf3:	be 19 71 10 c0       	mov    $0xc0107119,%esi
            }
            if (width > 0 && padc != '-') {
c0105bf8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105bfc:	7e 76                	jle    c0105c74 <vprintfmt+0x21f>
c0105bfe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105c02:	74 70                	je     c0105c74 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105c07:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c0b:	89 34 24             	mov    %esi,(%esp)
c0105c0e:	e8 f6 f7 ff ff       	call   c0105409 <strnlen>
c0105c13:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c16:	29 c2                	sub    %eax,%edx
c0105c18:	89 d0                	mov    %edx,%eax
c0105c1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c1d:	eb 16                	jmp    c0105c35 <vprintfmt+0x1e0>
                    putch(padc, putdat);
c0105c1f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105c23:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105c26:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c2a:	89 04 24             	mov    %eax,(%esp)
c0105c2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c30:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105c32:	ff 4d e8             	decl   -0x18(%ebp)
c0105c35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105c39:	7f e4                	jg     c0105c1f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105c3b:	eb 37                	jmp    c0105c74 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105c3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105c41:	74 1f                	je     c0105c62 <vprintfmt+0x20d>
c0105c43:	83 fb 1f             	cmp    $0x1f,%ebx
c0105c46:	7e 05                	jle    c0105c4d <vprintfmt+0x1f8>
c0105c48:	83 fb 7e             	cmp    $0x7e,%ebx
c0105c4b:	7e 15                	jle    c0105c62 <vprintfmt+0x20d>
                    putch('?', putdat);
c0105c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c54:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c5e:	ff d0                	call   *%eax
c0105c60:	eb 0f                	jmp    c0105c71 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
c0105c62:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c65:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c69:	89 1c 24             	mov    %ebx,(%esp)
c0105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105c71:	ff 4d e8             	decl   -0x18(%ebp)
c0105c74:	89 f0                	mov    %esi,%eax
c0105c76:	8d 70 01             	lea    0x1(%eax),%esi
c0105c79:	0f b6 00             	movzbl (%eax),%eax
c0105c7c:	0f be d8             	movsbl %al,%ebx
c0105c7f:	85 db                	test   %ebx,%ebx
c0105c81:	74 27                	je     c0105caa <vprintfmt+0x255>
c0105c83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105c87:	78 b4                	js     c0105c3d <vprintfmt+0x1e8>
c0105c89:	ff 4d e4             	decl   -0x1c(%ebp)
c0105c8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105c90:	79 ab                	jns    c0105c3d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
c0105c92:	eb 16                	jmp    c0105caa <vprintfmt+0x255>
                putch(' ', putdat);
c0105c94:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c97:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105ca2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ca5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
c0105ca7:	ff 4d e8             	decl   -0x18(%ebp)
c0105caa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105cae:	7f e4                	jg     c0105c94 <vprintfmt+0x23f>
            }
            break;
c0105cb0:	e9 6c 01 00 00       	jmp    c0105e21 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cbc:	8d 45 14             	lea    0x14(%ebp),%eax
c0105cbf:	89 04 24             	mov    %eax,(%esp)
c0105cc2:	e8 18 fd ff ff       	call   c01059df <getint>
c0105cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cd3:	85 d2                	test   %edx,%edx
c0105cd5:	79 26                	jns    c0105cfd <vprintfmt+0x2a8>
                putch('-', putdat);
c0105cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cda:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105cde:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ce8:	ff d0                	call   *%eax
                num = -(long long)num;
c0105cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105cf0:	f7 d8                	neg    %eax
c0105cf2:	83 d2 00             	adc    $0x0,%edx
c0105cf5:	f7 da                	neg    %edx
c0105cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105cfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105cfd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d04:	e9 a8 00 00 00       	jmp    c0105db1 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d10:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d13:	89 04 24             	mov    %eax,(%esp)
c0105d16:	e8 75 fc ff ff       	call   c0105990 <getuint>
c0105d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105d21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105d28:	e9 84 00 00 00       	jmp    c0105db1 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d34:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d37:	89 04 24             	mov    %eax,(%esp)
c0105d3a:	e8 51 fc ff ff       	call   c0105990 <getuint>
c0105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105d45:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105d4c:	eb 63                	jmp    c0105db1 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
c0105d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d55:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105d5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d5f:	ff d0                	call   *%eax
            putch('x', putdat);
c0105d61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d68:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d72:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105d74:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d77:	8d 50 04             	lea    0x4(%eax),%edx
c0105d7a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105d7d:	8b 00                	mov    (%eax),%eax
c0105d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105d89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105d90:	eb 1f                	jmp    c0105db1 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d99:	8d 45 14             	lea    0x14(%ebp),%eax
c0105d9c:	89 04 24             	mov    %eax,(%esp)
c0105d9f:	e8 ec fb ff ff       	call   c0105990 <getuint>
c0105da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105da7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105daa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105db1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105db8:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105dbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105dbf:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105dcd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105dd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ddc:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ddf:	89 04 24             	mov    %eax,(%esp)
c0105de2:	e8 a4 fa ff ff       	call   c010588b <printnum>
            break;
c0105de7:	eb 38                	jmp    c0105e21 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105de9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105df0:	89 1c 24             	mov    %ebx,(%esp)
c0105df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df6:	ff d0                	call   *%eax
            break;
c0105df8:	eb 27                	jmp    c0105e21 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e01:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105e08:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e0b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105e0d:	ff 4d 10             	decl   0x10(%ebp)
c0105e10:	eb 03                	jmp    c0105e15 <vprintfmt+0x3c0>
c0105e12:	ff 4d 10             	decl   0x10(%ebp)
c0105e15:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e18:	48                   	dec    %eax
c0105e19:	0f b6 00             	movzbl (%eax),%eax
c0105e1c:	3c 25                	cmp    $0x25,%al
c0105e1e:	75 f2                	jne    c0105e12 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
c0105e20:	90                   	nop
    while (1) {
c0105e21:	e9 37 fc ff ff       	jmp    c0105a5d <vprintfmt+0x8>
                return;
c0105e26:	90                   	nop
        }
    }
}
c0105e27:	83 c4 40             	add    $0x40,%esp
c0105e2a:	5b                   	pop    %ebx
c0105e2b:	5e                   	pop    %esi
c0105e2c:	5d                   	pop    %ebp
c0105e2d:	c3                   	ret    

c0105e2e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105e2e:	55                   	push   %ebp
c0105e2f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105e31:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e34:	8b 40 08             	mov    0x8(%eax),%eax
c0105e37:	8d 50 01             	lea    0x1(%eax),%edx
c0105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105e40:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e43:	8b 10                	mov    (%eax),%edx
c0105e45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e48:	8b 40 04             	mov    0x4(%eax),%eax
c0105e4b:	39 c2                	cmp    %eax,%edx
c0105e4d:	73 12                	jae    c0105e61 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e52:	8b 00                	mov    (%eax),%eax
c0105e54:	8d 48 01             	lea    0x1(%eax),%ecx
c0105e57:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105e5a:	89 0a                	mov    %ecx,(%edx)
c0105e5c:	8b 55 08             	mov    0x8(%ebp),%edx
c0105e5f:	88 10                	mov    %dl,(%eax)
    }
}
c0105e61:	90                   	nop
c0105e62:	5d                   	pop    %ebp
c0105e63:	c3                   	ret    

c0105e64 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105e64:	55                   	push   %ebp
c0105e65:	89 e5                	mov    %esp,%ebp
c0105e67:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105e6a:	8d 45 14             	lea    0x14(%ebp),%eax
c0105e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
c0105e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e73:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105e77:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e7a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e81:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e85:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e88:	89 04 24             	mov    %eax,(%esp)
c0105e8b:	e8 08 00 00 00       	call   c0105e98 <vsnprintf>
c0105e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105e96:	c9                   	leave  
c0105e97:	c3                   	ret    

c0105e98 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105e98:	55                   	push   %ebp
c0105e99:	89 e5                	mov    %esp,%ebp
c0105e9b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105e9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105eaa:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ead:	01 d0                	add    %edx,%eax
c0105eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105eb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105ebd:	74 0a                	je     c0105ec9 <vsnprintf+0x31>
c0105ebf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105ec5:	39 c2                	cmp    %eax,%edx
c0105ec7:	76 07                	jbe    c0105ed0 <vsnprintf+0x38>
        return -E_INVAL;
c0105ec9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105ece:	eb 2a                	jmp    c0105efa <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105ed0:	8b 45 14             	mov    0x14(%ebp),%eax
c0105ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105ed7:	8b 45 10             	mov    0x10(%ebp),%eax
c0105eda:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ede:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ee5:	c7 04 24 2e 5e 10 c0 	movl   $0xc0105e2e,(%esp)
c0105eec:	e8 64 fb ff ff       	call   c0105a55 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105ef4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105efa:	c9                   	leave  
c0105efb:	c3                   	ret    
