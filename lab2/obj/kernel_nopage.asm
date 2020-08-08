
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:

.text
.globl kern_entry
kern_entry:
    # load pa of boot pgdir
    movl $REALLOC(__boot_pgdir), %eax
  100000:	b8 00 80 11 40       	mov    $0x40118000,%eax
    movl %eax, %cr3
  100005:	0f 22 d8             	mov    %eax,%cr3

    # enable paging
    movl %cr0, %eax
  100008:	0f 20 c0             	mov    %cr0,%eax
    orl $(CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP), %eax
  10000b:	0d 2f 00 05 80       	or     $0x8005002f,%eax
    andl $~(CR0_TS | CR0_EM), %eax
  100010:	83 e0 f3             	and    $0xfffffff3,%eax
    movl %eax, %cr0
  100013:	0f 22 c0             	mov    %eax,%cr0

    # update eip
    # now, eip = 0x1.....
    leal next, %eax
  100016:	8d 05 1e 00 10 00    	lea    0x10001e,%eax
    # set eip = KERNBASE + 0x1.....
    jmp *%eax
  10001c:	ff e0                	jmp    *%eax

0010001e <next>:
next:

    # unmap va 0 ~ 4M, it's temporary mapping
    xorl %eax, %eax
  10001e:	31 c0                	xor    %eax,%eax
    movl %eax, __boot_pgdir
  100020:	a3 00 80 11 00       	mov    %eax,0x118000

    # set ebp, esp
    movl $0x0, %ebp
  100025:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10002a:	bc 00 70 11 00       	mov    $0x117000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  10002f:	e8 02 00 00 00       	call   100036 <kern_init>

00100034 <spin>:

# should never get here
spin:
    jmp spin
  100034:	eb fe                	jmp    100034 <spin>

00100036 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100036:	55                   	push   %ebp
  100037:	89 e5                	mov    %esp,%ebp
  100039:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  10003c:	ba a8 af 11 00       	mov    $0x11afa8,%edx
  100041:	b8 36 7a 11 00       	mov    $0x117a36,%eax
  100046:	29 c2                	sub    %eax,%edx
  100048:	89 d0                	mov    %edx,%eax
  10004a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10004e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  100055:	00 
  100056:	c7 04 24 36 7a 11 00 	movl   $0x117a36,(%esp)
  10005d:	e8 a0 56 00 00       	call   105702 <memset>

    cons_init();                // init the console
  100062:	e8 66 15 00 00       	call   1015cd <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100067:	c7 45 f4 00 5f 10 00 	movl   $0x105f00,-0xc(%ebp)
    cprintf("%s\n\n", message);
  10006e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100071:	89 44 24 04          	mov    %eax,0x4(%esp)
  100075:	c7 04 24 1c 5f 10 00 	movl   $0x105f1c,(%esp)
  10007c:	e8 11 02 00 00       	call   100292 <cprintf>

    print_kerninfo();
  100081:	e8 b2 08 00 00       	call   100938 <print_kerninfo>

    grade_backtrace();
  100086:	e8 89 00 00 00       	call   100114 <grade_backtrace>

    pmm_init();                 // init physical memory management
  10008b:	e8 86 30 00 00       	call   103116 <pmm_init>

    pic_init();                 // init interrupt controller
  100090:	e8 9d 16 00 00       	call   101732 <pic_init>
    idt_init();                 // init interrupt descriptor table
  100095:	e8 22 18 00 00       	call   1018bc <idt_init>

    clock_init();               // init clock interrupt
  10009a:	e8 d1 0c 00 00       	call   100d70 <clock_init>
    intr_enable();              // enable irq interrupt
  10009f:	e8 c8 17 00 00       	call   10186c <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  1000a4:	eb fe                	jmp    1000a4 <kern_init+0x6e>

001000a6 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  1000a6:	55                   	push   %ebp
  1000a7:	89 e5                	mov    %esp,%ebp
  1000a9:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000b3:	00 
  1000b4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000bb:	00 
  1000bc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000c3:	e8 96 0c 00 00       	call   100d5e <mon_backtrace>
}
  1000c8:	90                   	nop
  1000c9:	c9                   	leave  
  1000ca:	c3                   	ret    

001000cb <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000cb:	55                   	push   %ebp
  1000cc:	89 e5                	mov    %esp,%ebp
  1000ce:	53                   	push   %ebx
  1000cf:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000d2:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000d8:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000db:	8b 45 08             	mov    0x8(%ebp),%eax
  1000de:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000e6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000ea:	89 04 24             	mov    %eax,(%esp)
  1000ed:	e8 b4 ff ff ff       	call   1000a6 <grade_backtrace2>
}
  1000f2:	90                   	nop
  1000f3:	83 c4 14             	add    $0x14,%esp
  1000f6:	5b                   	pop    %ebx
  1000f7:	5d                   	pop    %ebp
  1000f8:	c3                   	ret    

001000f9 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000f9:	55                   	push   %ebp
  1000fa:	89 e5                	mov    %esp,%ebp
  1000fc:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ff:	8b 45 10             	mov    0x10(%ebp),%eax
  100102:	89 44 24 04          	mov    %eax,0x4(%esp)
  100106:	8b 45 08             	mov    0x8(%ebp),%eax
  100109:	89 04 24             	mov    %eax,(%esp)
  10010c:	e8 ba ff ff ff       	call   1000cb <grade_backtrace1>
}
  100111:	90                   	nop
  100112:	c9                   	leave  
  100113:	c3                   	ret    

00100114 <grade_backtrace>:

void
grade_backtrace(void) {
  100114:	55                   	push   %ebp
  100115:	89 e5                	mov    %esp,%ebp
  100117:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10011a:	b8 36 00 10 00       	mov    $0x100036,%eax
  10011f:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  100126:	ff 
  100127:	89 44 24 04          	mov    %eax,0x4(%esp)
  10012b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100132:	e8 c2 ff ff ff       	call   1000f9 <grade_backtrace0>
}
  100137:	90                   	nop
  100138:	c9                   	leave  
  100139:	c3                   	ret    

0010013a <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10013a:	55                   	push   %ebp
  10013b:	89 e5                	mov    %esp,%ebp
  10013d:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100140:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100143:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100146:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100149:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10014c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100150:	83 e0 03             	and    $0x3,%eax
  100153:	89 c2                	mov    %eax,%edx
  100155:	a1 00 a0 11 00       	mov    0x11a000,%eax
  10015a:	89 54 24 08          	mov    %edx,0x8(%esp)
  10015e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100162:	c7 04 24 21 5f 10 00 	movl   $0x105f21,(%esp)
  100169:	e8 24 01 00 00       	call   100292 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10016e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100172:	89 c2                	mov    %eax,%edx
  100174:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100179:	89 54 24 08          	mov    %edx,0x8(%esp)
  10017d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100181:	c7 04 24 2f 5f 10 00 	movl   $0x105f2f,(%esp)
  100188:	e8 05 01 00 00       	call   100292 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10018d:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100191:	89 c2                	mov    %eax,%edx
  100193:	a1 00 a0 11 00       	mov    0x11a000,%eax
  100198:	89 54 24 08          	mov    %edx,0x8(%esp)
  10019c:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001a0:	c7 04 24 3d 5f 10 00 	movl   $0x105f3d,(%esp)
  1001a7:	e8 e6 00 00 00       	call   100292 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001ac:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001b0:	89 c2                	mov    %eax,%edx
  1001b2:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001b7:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001bf:	c7 04 24 4b 5f 10 00 	movl   $0x105f4b,(%esp)
  1001c6:	e8 c7 00 00 00       	call   100292 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001cb:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001cf:	89 c2                	mov    %eax,%edx
  1001d1:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001d6:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001da:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001de:	c7 04 24 59 5f 10 00 	movl   $0x105f59,(%esp)
  1001e5:	e8 a8 00 00 00       	call   100292 <cprintf>
    round ++;
  1001ea:	a1 00 a0 11 00       	mov    0x11a000,%eax
  1001ef:	40                   	inc    %eax
  1001f0:	a3 00 a0 11 00       	mov    %eax,0x11a000
}
  1001f5:	90                   	nop
  1001f6:	c9                   	leave  
  1001f7:	c3                   	ret    

001001f8 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f8:	55                   	push   %ebp
  1001f9:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001fb:	90                   	nop
  1001fc:	5d                   	pop    %ebp
  1001fd:	c3                   	ret    

001001fe <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  100201:	90                   	nop
  100202:	5d                   	pop    %ebp
  100203:	c3                   	ret    

00100204 <lab1_switch_test>:

static void
lab1_switch_test(void) {
  100204:	55                   	push   %ebp
  100205:	89 e5                	mov    %esp,%ebp
  100207:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  10020a:	e8 2b ff ff ff       	call   10013a <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  10020f:	c7 04 24 68 5f 10 00 	movl   $0x105f68,(%esp)
  100216:	e8 77 00 00 00       	call   100292 <cprintf>
    lab1_switch_to_user();
  10021b:	e8 d8 ff ff ff       	call   1001f8 <lab1_switch_to_user>
    lab1_print_cur_status();
  100220:	e8 15 ff ff ff       	call   10013a <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  100225:	c7 04 24 88 5f 10 00 	movl   $0x105f88,(%esp)
  10022c:	e8 61 00 00 00       	call   100292 <cprintf>
    lab1_switch_to_kernel();
  100231:	e8 c8 ff ff ff       	call   1001fe <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100236:	e8 ff fe ff ff       	call   10013a <lab1_print_cur_status>
}
  10023b:	90                   	nop
  10023c:	c9                   	leave  
  10023d:	c3                   	ret    

0010023e <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  10023e:	55                   	push   %ebp
  10023f:	89 e5                	mov    %esp,%ebp
  100241:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 04 24             	mov    %eax,(%esp)
  10024a:	e8 ab 13 00 00       	call   1015fa <cons_putc>
    (*cnt) ++;
  10024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100252:	8b 00                	mov    (%eax),%eax
  100254:	8d 50 01             	lea    0x1(%eax),%edx
  100257:	8b 45 0c             	mov    0xc(%ebp),%eax
  10025a:	89 10                	mov    %edx,(%eax)
}
  10025c:	90                   	nop
  10025d:	c9                   	leave  
  10025e:	c3                   	ret    

0010025f <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  10025f:	55                   	push   %ebp
  100260:	89 e5                	mov    %esp,%ebp
  100262:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100265:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  10026c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10026f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100273:	8b 45 08             	mov    0x8(%ebp),%eax
  100276:	89 44 24 08          	mov    %eax,0x8(%esp)
  10027a:	8d 45 f4             	lea    -0xc(%ebp),%eax
  10027d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100281:	c7 04 24 3e 02 10 00 	movl   $0x10023e,(%esp)
  100288:	e8 c8 57 00 00       	call   105a55 <vprintfmt>
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100298:	8d 45 0c             	lea    0xc(%ebp),%eax
  10029b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  10029e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002a1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1002a8:	89 04 24             	mov    %eax,(%esp)
  1002ab:	e8 af ff ff ff       	call   10025f <vcprintf>
  1002b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1002b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1002b6:	c9                   	leave  
  1002b7:	c3                   	ret    

001002b8 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  1002b8:	55                   	push   %ebp
  1002b9:	89 e5                	mov    %esp,%ebp
  1002bb:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002be:	8b 45 08             	mov    0x8(%ebp),%eax
  1002c1:	89 04 24             	mov    %eax,(%esp)
  1002c4:	e8 31 13 00 00       	call   1015fa <cons_putc>
}
  1002c9:	90                   	nop
  1002ca:	c9                   	leave  
  1002cb:	c3                   	ret    

001002cc <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002cc:	55                   	push   %ebp
  1002cd:	89 e5                	mov    %esp,%ebp
  1002cf:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002d9:	eb 13                	jmp    1002ee <cputs+0x22>
        cputch(c, &cnt);
  1002db:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002df:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002e2:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002e6:	89 04 24             	mov    %eax,(%esp)
  1002e9:	e8 50 ff ff ff       	call   10023e <cputch>
    while ((c = *str ++) != '\0') {
  1002ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1002f1:	8d 50 01             	lea    0x1(%eax),%edx
  1002f4:	89 55 08             	mov    %edx,0x8(%ebp)
  1002f7:	0f b6 00             	movzbl (%eax),%eax
  1002fa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002fd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  100301:	75 d8                	jne    1002db <cputs+0xf>
    }
    cputch('\n', &cnt);
  100303:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100306:	89 44 24 04          	mov    %eax,0x4(%esp)
  10030a:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  100311:	e8 28 ff ff ff       	call   10023e <cputch>
    return cnt;
  100316:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  100319:	c9                   	leave  
  10031a:	c3                   	ret    

0010031b <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  10031b:	55                   	push   %ebp
  10031c:	89 e5                	mov    %esp,%ebp
  10031e:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  100321:	e8 11 13 00 00       	call   101637 <cons_getc>
  100326:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100329:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10032d:	74 f2                	je     100321 <getchar+0x6>
        /* do nothing */;
    return c;
  10032f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100332:	c9                   	leave  
  100333:	c3                   	ret    

00100334 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100334:	55                   	push   %ebp
  100335:	89 e5                	mov    %esp,%ebp
  100337:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10033a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  10033e:	74 13                	je     100353 <readline+0x1f>
        cprintf("%s", prompt);
  100340:	8b 45 08             	mov    0x8(%ebp),%eax
  100343:	89 44 24 04          	mov    %eax,0x4(%esp)
  100347:	c7 04 24 a7 5f 10 00 	movl   $0x105fa7,(%esp)
  10034e:	e8 3f ff ff ff       	call   100292 <cprintf>
    }
    int i = 0, c;
  100353:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  10035a:	e8 bc ff ff ff       	call   10031b <getchar>
  10035f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100362:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100366:	79 07                	jns    10036f <readline+0x3b>
            return NULL;
  100368:	b8 00 00 00 00       	mov    $0x0,%eax
  10036d:	eb 78                	jmp    1003e7 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  10036f:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  100373:	7e 28                	jle    10039d <readline+0x69>
  100375:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  10037c:	7f 1f                	jg     10039d <readline+0x69>
            cputchar(c);
  10037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100381:	89 04 24             	mov    %eax,(%esp)
  100384:	e8 2f ff ff ff       	call   1002b8 <cputchar>
            buf[i ++] = c;
  100389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10038c:	8d 50 01             	lea    0x1(%eax),%edx
  10038f:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100392:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100395:	88 90 20 a0 11 00    	mov    %dl,0x11a020(%eax)
  10039b:	eb 45                	jmp    1003e2 <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  10039d:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1003a1:	75 16                	jne    1003b9 <readline+0x85>
  1003a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003a7:	7e 10                	jle    1003b9 <readline+0x85>
            cputchar(c);
  1003a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003ac:	89 04 24             	mov    %eax,(%esp)
  1003af:	e8 04 ff ff ff       	call   1002b8 <cputchar>
            i --;
  1003b4:	ff 4d f4             	decl   -0xc(%ebp)
  1003b7:	eb 29                	jmp    1003e2 <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  1003b9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1003bd:	74 06                	je     1003c5 <readline+0x91>
  1003bf:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1003c3:	75 95                	jne    10035a <readline+0x26>
            cputchar(c);
  1003c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003c8:	89 04 24             	mov    %eax,(%esp)
  1003cb:	e8 e8 fe ff ff       	call   1002b8 <cputchar>
            buf[i] = '\0';
  1003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003d3:	05 20 a0 11 00       	add    $0x11a020,%eax
  1003d8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003db:	b8 20 a0 11 00       	mov    $0x11a020,%eax
  1003e0:	eb 05                	jmp    1003e7 <readline+0xb3>
        c = getchar();
  1003e2:	e9 73 ff ff ff       	jmp    10035a <readline+0x26>
        }
    }
}
  1003e7:	c9                   	leave  
  1003e8:	c3                   	ret    

001003e9 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003e9:	55                   	push   %ebp
  1003ea:	89 e5                	mov    %esp,%ebp
  1003ec:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003ef:	a1 20 a4 11 00       	mov    0x11a420,%eax
  1003f4:	85 c0                	test   %eax,%eax
  1003f6:	75 5b                	jne    100453 <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003f8:	c7 05 20 a4 11 00 01 	movl   $0x1,0x11a420
  1003ff:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100402:	8d 45 14             	lea    0x14(%ebp),%eax
  100405:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100408:	8b 45 0c             	mov    0xc(%ebp),%eax
  10040b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10040f:	8b 45 08             	mov    0x8(%ebp),%eax
  100412:	89 44 24 04          	mov    %eax,0x4(%esp)
  100416:	c7 04 24 aa 5f 10 00 	movl   $0x105faa,(%esp)
  10041d:	e8 70 fe ff ff       	call   100292 <cprintf>
    vcprintf(fmt, ap);
  100422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100425:	89 44 24 04          	mov    %eax,0x4(%esp)
  100429:	8b 45 10             	mov    0x10(%ebp),%eax
  10042c:	89 04 24             	mov    %eax,(%esp)
  10042f:	e8 2b fe ff ff       	call   10025f <vcprintf>
    cprintf("\n");
  100434:	c7 04 24 c6 5f 10 00 	movl   $0x105fc6,(%esp)
  10043b:	e8 52 fe ff ff       	call   100292 <cprintf>
    
    cprintf("stack trackback:\n");
  100440:	c7 04 24 c8 5f 10 00 	movl   $0x105fc8,(%esp)
  100447:	e8 46 fe ff ff       	call   100292 <cprintf>
    print_stackframe();
  10044c:	e8 32 06 00 00       	call   100a83 <print_stackframe>
  100451:	eb 01                	jmp    100454 <__panic+0x6b>
        goto panic_dead;
  100453:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  100454:	e8 1a 14 00 00       	call   101873 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100459:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100460:	e8 2c 08 00 00       	call   100c91 <kmonitor>
  100465:	eb f2                	jmp    100459 <__panic+0x70>

00100467 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100467:	55                   	push   %ebp
  100468:	89 e5                	mov    %esp,%ebp
  10046a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  10046d:	8d 45 14             	lea    0x14(%ebp),%eax
  100470:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100473:	8b 45 0c             	mov    0xc(%ebp),%eax
  100476:	89 44 24 08          	mov    %eax,0x8(%esp)
  10047a:	8b 45 08             	mov    0x8(%ebp),%eax
  10047d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100481:	c7 04 24 da 5f 10 00 	movl   $0x105fda,(%esp)
  100488:	e8 05 fe ff ff       	call   100292 <cprintf>
    vcprintf(fmt, ap);
  10048d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100490:	89 44 24 04          	mov    %eax,0x4(%esp)
  100494:	8b 45 10             	mov    0x10(%ebp),%eax
  100497:	89 04 24             	mov    %eax,(%esp)
  10049a:	e8 c0 fd ff ff       	call   10025f <vcprintf>
    cprintf("\n");
  10049f:	c7 04 24 c6 5f 10 00 	movl   $0x105fc6,(%esp)
  1004a6:	e8 e7 fd ff ff       	call   100292 <cprintf>
    va_end(ap);
}
  1004ab:	90                   	nop
  1004ac:	c9                   	leave  
  1004ad:	c3                   	ret    

001004ae <is_kernel_panic>:

bool
is_kernel_panic(void) {
  1004ae:	55                   	push   %ebp
  1004af:	89 e5                	mov    %esp,%ebp
    return is_panic;
  1004b1:	a1 20 a4 11 00       	mov    0x11a420,%eax
}
  1004b6:	5d                   	pop    %ebp
  1004b7:	c3                   	ret    

001004b8 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1004b8:	55                   	push   %ebp
  1004b9:	89 e5                	mov    %esp,%ebp
  1004bb:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c1:	8b 00                	mov    (%eax),%eax
  1004c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004c9:	8b 00                	mov    (%eax),%eax
  1004cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004ce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004d5:	e9 ca 00 00 00       	jmp    1005a4 <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004da:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004dd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004e0:	01 d0                	add    %edx,%eax
  1004e2:	89 c2                	mov    %eax,%edx
  1004e4:	c1 ea 1f             	shr    $0x1f,%edx
  1004e7:	01 d0                	add    %edx,%eax
  1004e9:	d1 f8                	sar    %eax
  1004eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004f1:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004f4:	eb 03                	jmp    1004f9 <stab_binsearch+0x41>
            m --;
  1004f6:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fc:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004ff:	7c 1f                	jl     100520 <stab_binsearch+0x68>
  100501:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100504:	89 d0                	mov    %edx,%eax
  100506:	01 c0                	add    %eax,%eax
  100508:	01 d0                	add    %edx,%eax
  10050a:	c1 e0 02             	shl    $0x2,%eax
  10050d:	89 c2                	mov    %eax,%edx
  10050f:	8b 45 08             	mov    0x8(%ebp),%eax
  100512:	01 d0                	add    %edx,%eax
  100514:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100518:	0f b6 c0             	movzbl %al,%eax
  10051b:	39 45 14             	cmp    %eax,0x14(%ebp)
  10051e:	75 d6                	jne    1004f6 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  100520:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100523:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100526:	7d 09                	jge    100531 <stab_binsearch+0x79>
            l = true_m + 1;
  100528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10052b:	40                   	inc    %eax
  10052c:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  10052f:	eb 73                	jmp    1005a4 <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  100531:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100538:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10053b:	89 d0                	mov    %edx,%eax
  10053d:	01 c0                	add    %eax,%eax
  10053f:	01 d0                	add    %edx,%eax
  100541:	c1 e0 02             	shl    $0x2,%eax
  100544:	89 c2                	mov    %eax,%edx
  100546:	8b 45 08             	mov    0x8(%ebp),%eax
  100549:	01 d0                	add    %edx,%eax
  10054b:	8b 40 08             	mov    0x8(%eax),%eax
  10054e:	39 45 18             	cmp    %eax,0x18(%ebp)
  100551:	76 11                	jbe    100564 <stab_binsearch+0xac>
            *region_left = m;
  100553:	8b 45 0c             	mov    0xc(%ebp),%eax
  100556:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100559:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10055b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10055e:	40                   	inc    %eax
  10055f:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100562:	eb 40                	jmp    1005a4 <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  100564:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100567:	89 d0                	mov    %edx,%eax
  100569:	01 c0                	add    %eax,%eax
  10056b:	01 d0                	add    %edx,%eax
  10056d:	c1 e0 02             	shl    $0x2,%eax
  100570:	89 c2                	mov    %eax,%edx
  100572:	8b 45 08             	mov    0x8(%ebp),%eax
  100575:	01 d0                	add    %edx,%eax
  100577:	8b 40 08             	mov    0x8(%eax),%eax
  10057a:	39 45 18             	cmp    %eax,0x18(%ebp)
  10057d:	73 14                	jae    100593 <stab_binsearch+0xdb>
            *region_right = m - 1;
  10057f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100582:	8d 50 ff             	lea    -0x1(%eax),%edx
  100585:	8b 45 10             	mov    0x10(%ebp),%eax
  100588:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  10058a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10058d:	48                   	dec    %eax
  10058e:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100591:	eb 11                	jmp    1005a4 <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  100593:	8b 45 0c             	mov    0xc(%ebp),%eax
  100596:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100599:	89 10                	mov    %edx,(%eax)
            l = m;
  10059b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10059e:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1005a1:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  1005a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1005a7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1005aa:	0f 8e 2a ff ff ff    	jle    1004da <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  1005b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1005b4:	75 0f                	jne    1005c5 <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  1005b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005b9:	8b 00                	mov    (%eax),%eax
  1005bb:	8d 50 ff             	lea    -0x1(%eax),%edx
  1005be:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c1:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  1005c3:	eb 3e                	jmp    100603 <stab_binsearch+0x14b>
        l = *region_right;
  1005c5:	8b 45 10             	mov    0x10(%ebp),%eax
  1005c8:	8b 00                	mov    (%eax),%eax
  1005ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005cd:	eb 03                	jmp    1005d2 <stab_binsearch+0x11a>
  1005cf:	ff 4d fc             	decl   -0x4(%ebp)
  1005d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d5:	8b 00                	mov    (%eax),%eax
  1005d7:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005da:	7e 1f                	jle    1005fb <stab_binsearch+0x143>
  1005dc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005df:	89 d0                	mov    %edx,%eax
  1005e1:	01 c0                	add    %eax,%eax
  1005e3:	01 d0                	add    %edx,%eax
  1005e5:	c1 e0 02             	shl    $0x2,%eax
  1005e8:	89 c2                	mov    %eax,%edx
  1005ea:	8b 45 08             	mov    0x8(%ebp),%eax
  1005ed:	01 d0                	add    %edx,%eax
  1005ef:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005f3:	0f b6 c0             	movzbl %al,%eax
  1005f6:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005f9:	75 d4                	jne    1005cf <stab_binsearch+0x117>
        *region_left = l;
  1005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100601:	89 10                	mov    %edx,(%eax)
}
  100603:	90                   	nop
  100604:	c9                   	leave  
  100605:	c3                   	ret    

00100606 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100606:	55                   	push   %ebp
  100607:	89 e5                	mov    %esp,%ebp
  100609:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10060f:	c7 00 f8 5f 10 00    	movl   $0x105ff8,(%eax)
    info->eip_line = 0;
  100615:	8b 45 0c             	mov    0xc(%ebp),%eax
  100618:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  10061f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100622:	c7 40 08 f8 5f 10 00 	movl   $0x105ff8,0x8(%eax)
    info->eip_fn_namelen = 9;
  100629:	8b 45 0c             	mov    0xc(%ebp),%eax
  10062c:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100633:	8b 45 0c             	mov    0xc(%ebp),%eax
  100636:	8b 55 08             	mov    0x8(%ebp),%edx
  100639:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10063f:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100646:	c7 45 f4 78 72 10 00 	movl   $0x107278,-0xc(%ebp)
    stab_end = __STAB_END__;
  10064d:	c7 45 f0 14 24 11 00 	movl   $0x112414,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100654:	c7 45 ec 15 24 11 00 	movl   $0x112415,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10065b:	c7 45 e8 56 4f 11 00 	movl   $0x114f56,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100662:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100665:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100668:	76 0b                	jbe    100675 <debuginfo_eip+0x6f>
  10066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10066d:	48                   	dec    %eax
  10066e:	0f b6 00             	movzbl (%eax),%eax
  100671:	84 c0                	test   %al,%al
  100673:	74 0a                	je     10067f <debuginfo_eip+0x79>
        return -1;
  100675:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10067a:	e9 b7 02 00 00       	jmp    100936 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  10067f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100686:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10068c:	29 c2                	sub    %eax,%edx
  10068e:	89 d0                	mov    %edx,%eax
  100690:	c1 f8 02             	sar    $0x2,%eax
  100693:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100699:	48                   	dec    %eax
  10069a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  10069d:	8b 45 08             	mov    0x8(%ebp),%eax
  1006a0:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006a4:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1006ab:	00 
  1006ac:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1006af:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006b3:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1006b6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006bd:	89 04 24             	mov    %eax,(%esp)
  1006c0:	e8 f3 fd ff ff       	call   1004b8 <stab_binsearch>
    if (lfile == 0)
  1006c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c8:	85 c0                	test   %eax,%eax
  1006ca:	75 0a                	jne    1006d6 <debuginfo_eip+0xd0>
        return -1;
  1006cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006d1:	e9 60 02 00 00       	jmp    100936 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006d9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006df:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  1006e5:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006e9:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006f0:	00 
  1006f1:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006f4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006f8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006fb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100702:	89 04 24             	mov    %eax,(%esp)
  100705:	e8 ae fd ff ff       	call   1004b8 <stab_binsearch>

    if (lfun <= rfun) {
  10070a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10070d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100710:	39 c2                	cmp    %eax,%edx
  100712:	7f 7c                	jg     100790 <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  100714:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100717:	89 c2                	mov    %eax,%edx
  100719:	89 d0                	mov    %edx,%eax
  10071b:	01 c0                	add    %eax,%eax
  10071d:	01 d0                	add    %edx,%eax
  10071f:	c1 e0 02             	shl    $0x2,%eax
  100722:	89 c2                	mov    %eax,%edx
  100724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100727:	01 d0                	add    %edx,%eax
  100729:	8b 00                	mov    (%eax),%eax
  10072b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10072e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100731:	29 d1                	sub    %edx,%ecx
  100733:	89 ca                	mov    %ecx,%edx
  100735:	39 d0                	cmp    %edx,%eax
  100737:	73 22                	jae    10075b <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100739:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10073c:	89 c2                	mov    %eax,%edx
  10073e:	89 d0                	mov    %edx,%eax
  100740:	01 c0                	add    %eax,%eax
  100742:	01 d0                	add    %edx,%eax
  100744:	c1 e0 02             	shl    $0x2,%eax
  100747:	89 c2                	mov    %eax,%edx
  100749:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10074c:	01 d0                	add    %edx,%eax
  10074e:	8b 10                	mov    (%eax),%edx
  100750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100753:	01 c2                	add    %eax,%edx
  100755:	8b 45 0c             	mov    0xc(%ebp),%eax
  100758:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10075b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075e:	89 c2                	mov    %eax,%edx
  100760:	89 d0                	mov    %edx,%eax
  100762:	01 c0                	add    %eax,%eax
  100764:	01 d0                	add    %edx,%eax
  100766:	c1 e0 02             	shl    $0x2,%eax
  100769:	89 c2                	mov    %eax,%edx
  10076b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10076e:	01 d0                	add    %edx,%eax
  100770:	8b 50 08             	mov    0x8(%eax),%edx
  100773:	8b 45 0c             	mov    0xc(%ebp),%eax
  100776:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100779:	8b 45 0c             	mov    0xc(%ebp),%eax
  10077c:	8b 40 10             	mov    0x10(%eax),%eax
  10077f:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  100782:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100785:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100788:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10078b:	89 45 d0             	mov    %eax,-0x30(%ebp)
  10078e:	eb 15                	jmp    1007a5 <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  100790:	8b 45 0c             	mov    0xc(%ebp),%eax
  100793:	8b 55 08             	mov    0x8(%ebp),%edx
  100796:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100799:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10079c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  10079f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1007a2:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1007a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a8:	8b 40 08             	mov    0x8(%eax),%eax
  1007ab:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1007b2:	00 
  1007b3:	89 04 24             	mov    %eax,(%esp)
  1007b6:	e8 c3 4d 00 00       	call   10557e <strfind>
  1007bb:	89 c2                	mov    %eax,%edx
  1007bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c0:	8b 40 08             	mov    0x8(%eax),%eax
  1007c3:	29 c2                	sub    %eax,%edx
  1007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007c8:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1007ce:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007d2:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007d9:	00 
  1007da:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007e1:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007eb:	89 04 24             	mov    %eax,(%esp)
  1007ee:	e8 c5 fc ff ff       	call   1004b8 <stab_binsearch>
    if (lline <= rline) {
  1007f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007f9:	39 c2                	cmp    %eax,%edx
  1007fb:	7f 23                	jg     100820 <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007fd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100800:	89 c2                	mov    %eax,%edx
  100802:	89 d0                	mov    %edx,%eax
  100804:	01 c0                	add    %eax,%eax
  100806:	01 d0                	add    %edx,%eax
  100808:	c1 e0 02             	shl    $0x2,%eax
  10080b:	89 c2                	mov    %eax,%edx
  10080d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100810:	01 d0                	add    %edx,%eax
  100812:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  100816:	89 c2                	mov    %eax,%edx
  100818:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081b:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10081e:	eb 11                	jmp    100831 <debuginfo_eip+0x22b>
        return -1;
  100820:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100825:	e9 0c 01 00 00       	jmp    100936 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  10082a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10082d:	48                   	dec    %eax
  10082e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  100831:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100834:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100837:	39 c2                	cmp    %eax,%edx
  100839:	7c 56                	jl     100891 <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  10083b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10083e:	89 c2                	mov    %eax,%edx
  100840:	89 d0                	mov    %edx,%eax
  100842:	01 c0                	add    %eax,%eax
  100844:	01 d0                	add    %edx,%eax
  100846:	c1 e0 02             	shl    $0x2,%eax
  100849:	89 c2                	mov    %eax,%edx
  10084b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10084e:	01 d0                	add    %edx,%eax
  100850:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100854:	3c 84                	cmp    $0x84,%al
  100856:	74 39                	je     100891 <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100858:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10085b:	89 c2                	mov    %eax,%edx
  10085d:	89 d0                	mov    %edx,%eax
  10085f:	01 c0                	add    %eax,%eax
  100861:	01 d0                	add    %edx,%eax
  100863:	c1 e0 02             	shl    $0x2,%eax
  100866:	89 c2                	mov    %eax,%edx
  100868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10086b:	01 d0                	add    %edx,%eax
  10086d:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100871:	3c 64                	cmp    $0x64,%al
  100873:	75 b5                	jne    10082a <debuginfo_eip+0x224>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 40 08             	mov    0x8(%eax),%eax
  10088d:	85 c0                	test   %eax,%eax
  10088f:	74 99                	je     10082a <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  100891:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100897:	39 c2                	cmp    %eax,%edx
  100899:	7c 46                	jl     1008e1 <debuginfo_eip+0x2db>
  10089b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089e:	89 c2                	mov    %eax,%edx
  1008a0:	89 d0                	mov    %edx,%eax
  1008a2:	01 c0                	add    %eax,%eax
  1008a4:	01 d0                	add    %edx,%eax
  1008a6:	c1 e0 02             	shl    $0x2,%eax
  1008a9:	89 c2                	mov    %eax,%edx
  1008ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ae:	01 d0                	add    %edx,%eax
  1008b0:	8b 00                	mov    (%eax),%eax
  1008b2:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1008b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1008b8:	29 d1                	sub    %edx,%ecx
  1008ba:	89 ca                	mov    %ecx,%edx
  1008bc:	39 d0                	cmp    %edx,%eax
  1008be:	73 21                	jae    1008e1 <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1008c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008c3:	89 c2                	mov    %eax,%edx
  1008c5:	89 d0                	mov    %edx,%eax
  1008c7:	01 c0                	add    %eax,%eax
  1008c9:	01 d0                	add    %edx,%eax
  1008cb:	c1 e0 02             	shl    $0x2,%eax
  1008ce:	89 c2                	mov    %eax,%edx
  1008d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008d3:	01 d0                	add    %edx,%eax
  1008d5:	8b 10                	mov    (%eax),%edx
  1008d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008da:	01 c2                	add    %eax,%edx
  1008dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008df:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008e1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008e7:	39 c2                	cmp    %eax,%edx
  1008e9:	7d 46                	jge    100931 <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008eb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008ee:	40                   	inc    %eax
  1008ef:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008f2:	eb 16                	jmp    10090a <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008f7:	8b 40 14             	mov    0x14(%eax),%eax
  1008fa:	8d 50 01             	lea    0x1(%eax),%edx
  1008fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  100900:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  100903:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100906:	40                   	inc    %eax
  100907:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  10090a:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10090d:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  100910:	39 c2                	cmp    %eax,%edx
  100912:	7d 1d                	jge    100931 <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100914:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100917:	89 c2                	mov    %eax,%edx
  100919:	89 d0                	mov    %edx,%eax
  10091b:	01 c0                	add    %eax,%eax
  10091d:	01 d0                	add    %edx,%eax
  10091f:	c1 e0 02             	shl    $0x2,%eax
  100922:	89 c2                	mov    %eax,%edx
  100924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100927:	01 d0                	add    %edx,%eax
  100929:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10092d:	3c a0                	cmp    $0xa0,%al
  10092f:	74 c3                	je     1008f4 <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  100931:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100936:	c9                   	leave  
  100937:	c3                   	ret    

00100938 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100938:	55                   	push   %ebp
  100939:	89 e5                	mov    %esp,%ebp
  10093b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10093e:	c7 04 24 02 60 10 00 	movl   $0x106002,(%esp)
  100945:	e8 48 f9 ff ff       	call   100292 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  10094a:	c7 44 24 04 36 00 10 	movl   $0x100036,0x4(%esp)
  100951:	00 
  100952:	c7 04 24 1b 60 10 00 	movl   $0x10601b,(%esp)
  100959:	e8 34 f9 ff ff       	call   100292 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10095e:	c7 44 24 04 fc 5e 10 	movl   $0x105efc,0x4(%esp)
  100965:	00 
  100966:	c7 04 24 33 60 10 00 	movl   $0x106033,(%esp)
  10096d:	e8 20 f9 ff ff       	call   100292 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100972:	c7 44 24 04 36 7a 11 	movl   $0x117a36,0x4(%esp)
  100979:	00 
  10097a:	c7 04 24 4b 60 10 00 	movl   $0x10604b,(%esp)
  100981:	e8 0c f9 ff ff       	call   100292 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100986:	c7 44 24 04 a8 af 11 	movl   $0x11afa8,0x4(%esp)
  10098d:	00 
  10098e:	c7 04 24 63 60 10 00 	movl   $0x106063,(%esp)
  100995:	e8 f8 f8 ff ff       	call   100292 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  10099a:	b8 a8 af 11 00       	mov    $0x11afa8,%eax
  10099f:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009a5:	b8 36 00 10 00       	mov    $0x100036,%eax
  1009aa:	29 c2                	sub    %eax,%edx
  1009ac:	89 d0                	mov    %edx,%eax
  1009ae:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1009b4:	85 c0                	test   %eax,%eax
  1009b6:	0f 48 c2             	cmovs  %edx,%eax
  1009b9:	c1 f8 0a             	sar    $0xa,%eax
  1009bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009c0:	c7 04 24 7c 60 10 00 	movl   $0x10607c,(%esp)
  1009c7:	e8 c6 f8 ff ff       	call   100292 <cprintf>
}
  1009cc:	90                   	nop
  1009cd:	c9                   	leave  
  1009ce:	c3                   	ret    

001009cf <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009cf:	55                   	push   %ebp
  1009d0:	89 e5                	mov    %esp,%ebp
  1009d2:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009d8:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009db:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009df:	8b 45 08             	mov    0x8(%ebp),%eax
  1009e2:	89 04 24             	mov    %eax,(%esp)
  1009e5:	e8 1c fc ff ff       	call   100606 <debuginfo_eip>
  1009ea:	85 c0                	test   %eax,%eax
  1009ec:	74 15                	je     100a03 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009ee:	8b 45 08             	mov    0x8(%ebp),%eax
  1009f1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009f5:	c7 04 24 a6 60 10 00 	movl   $0x1060a6,(%esp)
  1009fc:	e8 91 f8 ff ff       	call   100292 <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  100a01:	eb 6c                	jmp    100a6f <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100a0a:	eb 1b                	jmp    100a27 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  100a0c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	0f b6 00             	movzbl (%eax),%eax
  100a17:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100a20:	01 ca                	add    %ecx,%edx
  100a22:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100a24:	ff 45 f4             	incl   -0xc(%ebp)
  100a27:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a2a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a2d:	7c dd                	jl     100a0c <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a2f:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a38:	01 d0                	add    %edx,%eax
  100a3a:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a40:	8b 55 08             	mov    0x8(%ebp),%edx
  100a43:	89 d1                	mov    %edx,%ecx
  100a45:	29 c1                	sub    %eax,%ecx
  100a47:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a4a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a4d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a51:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a57:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a5b:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a63:	c7 04 24 c2 60 10 00 	movl   $0x1060c2,(%esp)
  100a6a:	e8 23 f8 ff ff       	call   100292 <cprintf>
}
  100a6f:	90                   	nop
  100a70:	c9                   	leave  
  100a71:	c3                   	ret    

00100a72 <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a72:	55                   	push   %ebp
  100a73:	89 e5                	mov    %esp,%ebp
  100a75:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a78:	8b 45 04             	mov    0x4(%ebp),%eax
  100a7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a7e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a81:	c9                   	leave  
  100a82:	c3                   	ret    

00100a83 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a83:	55                   	push   %ebp
  100a84:	89 e5                	mov    %esp,%ebp
  100a86:	53                   	push   %ebx
  100a87:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a8a:	89 e8                	mov    %ebp,%eax
  100a8c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return ebp;
  100a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     int i;
     uint32_t ebp = read_ebp();
  100a92:	89 45 f0             	mov    %eax,-0x10(%ebp)
     uint32_t eip = read_eip();
  100a95:	e8 d8 ff ff ff       	call   100a72 <read_eip>
  100a9a:	89 45 ec             	mov    %eax,-0x14(%ebp)
     for(i = 0; i < STACKFRAME_DEPTH && ebp != 0; ++i){
  100a9d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100aa4:	eb 6c                	jmp    100b12 <print_stackframe+0x8f>
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aa9:	83 c0 14             	add    $0x14,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100aac:	8b 18                	mov    (%eax),%ebx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab1:	83 c0 10             	add    $0x10,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100ab4:	8b 08                	mov    (%eax),%ecx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100ab6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ab9:	83 c0 0c             	add    $0xc,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100abc:	8b 10                	mov    (%eax),%edx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100abe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac1:	83 c0 08             	add    $0x8,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100ac4:	8b 00                	mov    (%eax),%eax
  100ac6:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  100aca:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  100ace:	89 54 24 10          	mov    %edx,0x10(%esp)
  100ad2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100ad6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100ad9:	89 44 24 08          	mov    %eax,0x8(%esp)
  100add:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ae0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ae4:	c7 04 24 d4 60 10 00 	movl   $0x1060d4,(%esp)
  100aeb:	e8 a2 f7 ff ff       	call   100292 <cprintf>
         print_debuginfo((uintptr_t )(eip) - 1);
  100af0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100af3:	48                   	dec    %eax
  100af4:	89 04 24             	mov    %eax,(%esp)
  100af7:	e8 d3 fe ff ff       	call   1009cf <print_debuginfo>
         //ebp = *((uint32_t *)ebp);
         eip = *((uint32_t *)(ebp) + 1);
  100afc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aff:	83 c0 04             	add    $0x4,%eax
  100b02:	8b 00                	mov    (%eax),%eax
  100b04:	89 45 ec             	mov    %eax,-0x14(%ebp)
	 ebp = *((uint32_t *)ebp);
  100b07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b0a:	8b 00                	mov    (%eax),%eax
  100b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     for(i = 0; i < STACKFRAME_DEPTH && ebp != 0; ++i){
  100b0f:	ff 45 f4             	incl   -0xc(%ebp)
  100b12:	83 7d f4 13          	cmpl   $0x13,-0xc(%ebp)
  100b16:	7f 06                	jg     100b1e <print_stackframe+0x9b>
  100b18:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b1c:	75 88                	jne    100aa6 <print_stackframe+0x23>
     }

}
  100b1e:	90                   	nop
  100b1f:	83 c4 34             	add    $0x34,%esp
  100b22:	5b                   	pop    %ebx
  100b23:	5d                   	pop    %ebp
  100b24:	c3                   	ret    

00100b25 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100b25:	55                   	push   %ebp
  100b26:	89 e5                	mov    %esp,%ebp
  100b28:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100b2b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b32:	eb 0c                	jmp    100b40 <parse+0x1b>
            *buf ++ = '\0';
  100b34:	8b 45 08             	mov    0x8(%ebp),%eax
  100b37:	8d 50 01             	lea    0x1(%eax),%edx
  100b3a:	89 55 08             	mov    %edx,0x8(%ebp)
  100b3d:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b40:	8b 45 08             	mov    0x8(%ebp),%eax
  100b43:	0f b6 00             	movzbl (%eax),%eax
  100b46:	84 c0                	test   %al,%al
  100b48:	74 1d                	je     100b67 <parse+0x42>
  100b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b4d:	0f b6 00             	movzbl (%eax),%eax
  100b50:	0f be c0             	movsbl %al,%eax
  100b53:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b57:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  100b5e:	e8 e9 49 00 00       	call   10554c <strchr>
  100b63:	85 c0                	test   %eax,%eax
  100b65:	75 cd                	jne    100b34 <parse+0xf>
        }
        if (*buf == '\0') {
  100b67:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6a:	0f b6 00             	movzbl (%eax),%eax
  100b6d:	84 c0                	test   %al,%al
  100b6f:	74 65                	je     100bd6 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b71:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b75:	75 14                	jne    100b8b <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b77:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b7e:	00 
  100b7f:	c7 04 24 91 61 10 00 	movl   $0x106191,(%esp)
  100b86:	e8 07 f7 ff ff       	call   100292 <cprintf>
        }
        argv[argc ++] = buf;
  100b8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b8e:	8d 50 01             	lea    0x1(%eax),%edx
  100b91:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b94:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b9e:	01 c2                	add    %eax,%edx
  100ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  100ba3:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ba5:	eb 03                	jmp    100baa <parse+0x85>
            buf ++;
  100ba7:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100baa:	8b 45 08             	mov    0x8(%ebp),%eax
  100bad:	0f b6 00             	movzbl (%eax),%eax
  100bb0:	84 c0                	test   %al,%al
  100bb2:	74 8c                	je     100b40 <parse+0x1b>
  100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb7:	0f b6 00             	movzbl (%eax),%eax
  100bba:	0f be c0             	movsbl %al,%eax
  100bbd:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bc1:	c7 04 24 8c 61 10 00 	movl   $0x10618c,(%esp)
  100bc8:	e8 7f 49 00 00       	call   10554c <strchr>
  100bcd:	85 c0                	test   %eax,%eax
  100bcf:	74 d6                	je     100ba7 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100bd1:	e9 6a ff ff ff       	jmp    100b40 <parse+0x1b>
            break;
  100bd6:	90                   	nop
        }
    }
    return argc;
  100bd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100bda:	c9                   	leave  
  100bdb:	c3                   	ret    

00100bdc <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100bdc:	55                   	push   %ebp
  100bdd:	89 e5                	mov    %esp,%ebp
  100bdf:	53                   	push   %ebx
  100be0:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100be3:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100be6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bea:	8b 45 08             	mov    0x8(%ebp),%eax
  100bed:	89 04 24             	mov    %eax,(%esp)
  100bf0:	e8 30 ff ff ff       	call   100b25 <parse>
  100bf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bf8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bfc:	75 0a                	jne    100c08 <runcmd+0x2c>
        return 0;
  100bfe:	b8 00 00 00 00       	mov    $0x0,%eax
  100c03:	e9 83 00 00 00       	jmp    100c8b <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c08:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c0f:	eb 5a                	jmp    100c6b <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100c11:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100c14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c17:	89 d0                	mov    %edx,%eax
  100c19:	01 c0                	add    %eax,%eax
  100c1b:	01 d0                	add    %edx,%eax
  100c1d:	c1 e0 02             	shl    $0x2,%eax
  100c20:	05 00 70 11 00       	add    $0x117000,%eax
  100c25:	8b 00                	mov    (%eax),%eax
  100c27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100c2b:	89 04 24             	mov    %eax,(%esp)
  100c2e:	e8 7c 48 00 00       	call   1054af <strcmp>
  100c33:	85 c0                	test   %eax,%eax
  100c35:	75 31                	jne    100c68 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c3a:	89 d0                	mov    %edx,%eax
  100c3c:	01 c0                	add    %eax,%eax
  100c3e:	01 d0                	add    %edx,%eax
  100c40:	c1 e0 02             	shl    $0x2,%eax
  100c43:	05 08 70 11 00       	add    $0x117008,%eax
  100c48:	8b 10                	mov    (%eax),%edx
  100c4a:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c4d:	83 c0 04             	add    $0x4,%eax
  100c50:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c53:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c56:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c59:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c5d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c61:	89 1c 24             	mov    %ebx,(%esp)
  100c64:	ff d2                	call   *%edx
  100c66:	eb 23                	jmp    100c8b <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c68:	ff 45 f4             	incl   -0xc(%ebp)
  100c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c6e:	83 f8 02             	cmp    $0x2,%eax
  100c71:	76 9e                	jbe    100c11 <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c73:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c76:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c7a:	c7 04 24 af 61 10 00 	movl   $0x1061af,(%esp)
  100c81:	e8 0c f6 ff ff       	call   100292 <cprintf>
    return 0;
  100c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c8b:	83 c4 64             	add    $0x64,%esp
  100c8e:	5b                   	pop    %ebx
  100c8f:	5d                   	pop    %ebp
  100c90:	c3                   	ret    

00100c91 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c91:	55                   	push   %ebp
  100c92:	89 e5                	mov    %esp,%ebp
  100c94:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c97:	c7 04 24 c8 61 10 00 	movl   $0x1061c8,(%esp)
  100c9e:	e8 ef f5 ff ff       	call   100292 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100ca3:	c7 04 24 f0 61 10 00 	movl   $0x1061f0,(%esp)
  100caa:	e8 e3 f5 ff ff       	call   100292 <cprintf>

    if (tf != NULL) {
  100caf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100cb3:	74 0b                	je     100cc0 <kmonitor+0x2f>
        print_trapframe(tf);
  100cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cb8:	89 04 24             	mov    %eax,(%esp)
  100cbb:	e8 35 0d 00 00       	call   1019f5 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100cc0:	c7 04 24 15 62 10 00 	movl   $0x106215,(%esp)
  100cc7:	e8 68 f6 ff ff       	call   100334 <readline>
  100ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100ccf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100cd3:	74 eb                	je     100cc0 <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100cdf:	89 04 24             	mov    %eax,(%esp)
  100ce2:	e8 f5 fe ff ff       	call   100bdc <runcmd>
  100ce7:	85 c0                	test   %eax,%eax
  100ce9:	78 02                	js     100ced <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100ceb:	eb d3                	jmp    100cc0 <kmonitor+0x2f>
                break;
  100ced:	90                   	nop
            }
        }
    }
}
  100cee:	90                   	nop
  100cef:	c9                   	leave  
  100cf0:	c3                   	ret    

00100cf1 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cf1:	55                   	push   %ebp
  100cf2:	89 e5                	mov    %esp,%ebp
  100cf4:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cfe:	eb 3d                	jmp    100d3d <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100d00:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d03:	89 d0                	mov    %edx,%eax
  100d05:	01 c0                	add    %eax,%eax
  100d07:	01 d0                	add    %edx,%eax
  100d09:	c1 e0 02             	shl    $0x2,%eax
  100d0c:	05 04 70 11 00       	add    $0x117004,%eax
  100d11:	8b 08                	mov    (%eax),%ecx
  100d13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100d16:	89 d0                	mov    %edx,%eax
  100d18:	01 c0                	add    %eax,%eax
  100d1a:	01 d0                	add    %edx,%eax
  100d1c:	c1 e0 02             	shl    $0x2,%eax
  100d1f:	05 00 70 11 00       	add    $0x117000,%eax
  100d24:	8b 00                	mov    (%eax),%eax
  100d26:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100d2a:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d2e:	c7 04 24 19 62 10 00 	movl   $0x106219,(%esp)
  100d35:	e8 58 f5 ff ff       	call   100292 <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d3a:	ff 45 f4             	incl   -0xc(%ebp)
  100d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d40:	83 f8 02             	cmp    $0x2,%eax
  100d43:	76 bb                	jbe    100d00 <mon_help+0xf>
    }
    return 0;
  100d45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d4a:	c9                   	leave  
  100d4b:	c3                   	ret    

00100d4c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d4c:	55                   	push   %ebp
  100d4d:	89 e5                	mov    %esp,%ebp
  100d4f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d52:	e8 e1 fb ff ff       	call   100938 <print_kerninfo>
    return 0;
  100d57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d5c:	c9                   	leave  
  100d5d:	c3                   	ret    

00100d5e <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d5e:	55                   	push   %ebp
  100d5f:	89 e5                	mov    %esp,%ebp
  100d61:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d64:	e8 1a fd ff ff       	call   100a83 <print_stackframe>
    return 0;
  100d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d6e:	c9                   	leave  
  100d6f:	c3                   	ret    

00100d70 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d70:	55                   	push   %ebp
  100d71:	89 e5                	mov    %esp,%ebp
  100d73:	83 ec 28             	sub    $0x28,%esp
  100d76:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d7c:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d80:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d84:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d88:	ee                   	out    %al,(%dx)
  100d89:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8f:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d93:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d9b:	ee                   	out    %al,(%dx)
  100d9c:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100da2:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100da6:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100daa:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100dae:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100daf:	c7 05 2c af 11 00 00 	movl   $0x0,0x11af2c
  100db6:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db9:	c7 04 24 22 62 10 00 	movl   $0x106222,(%esp)
  100dc0:	e8 cd f4 ff ff       	call   100292 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dcc:	e8 2e 09 00 00       	call   1016ff <pic_enable>
}
  100dd1:	90                   	nop
  100dd2:	c9                   	leave  
  100dd3:	c3                   	ret    

00100dd4 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd4:	55                   	push   %ebp
  100dd5:	89 e5                	mov    %esp,%ebp
  100dd7:	83 ec 18             	sub    $0x18,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dda:	9c                   	pushf  
  100ddb:	58                   	pop    %eax
  100ddc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  100ddf:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100de2:	25 00 02 00 00       	and    $0x200,%eax
  100de7:	85 c0                	test   %eax,%eax
  100de9:	74 0c                	je     100df7 <__intr_save+0x23>
        intr_disable();
  100deb:	e8 83 0a 00 00       	call   101873 <intr_disable>
        return 1;
  100df0:	b8 01 00 00 00       	mov    $0x1,%eax
  100df5:	eb 05                	jmp    100dfc <__intr_save+0x28>
    }
    return 0;
  100df7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100dfc:	c9                   	leave  
  100dfd:	c3                   	ret    

00100dfe <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dfe:	55                   	push   %ebp
  100dff:	89 e5                	mov    %esp,%ebp
  100e01:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e08:	74 05                	je     100e0f <__intr_restore+0x11>
        intr_enable();
  100e0a:	e8 5d 0a 00 00       	call   10186c <intr_enable>
    }
}
  100e0f:	90                   	nop
  100e10:	c9                   	leave  
  100e11:	c3                   	ret    

00100e12 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e12:	55                   	push   %ebp
  100e13:	89 e5                	mov    %esp,%ebp
  100e15:	83 ec 10             	sub    $0x10,%esp
  100e18:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100e22:	89 c2                	mov    %eax,%edx
  100e24:	ec                   	in     (%dx),%al
  100e25:	88 45 f1             	mov    %al,-0xf(%ebp)
  100e28:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100e2e:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100e32:	89 c2                	mov    %eax,%edx
  100e34:	ec                   	in     (%dx),%al
  100e35:	88 45 f5             	mov    %al,-0xb(%ebp)
  100e38:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100e3e:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100e42:	89 c2                	mov    %eax,%edx
  100e44:	ec                   	in     (%dx),%al
  100e45:	88 45 f9             	mov    %al,-0x7(%ebp)
  100e48:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100e4e:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100e52:	89 c2                	mov    %eax,%edx
  100e54:	ec                   	in     (%dx),%al
  100e55:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e58:	90                   	nop
  100e59:	c9                   	leave  
  100e5a:	c3                   	ret    

00100e5b <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e5b:	55                   	push   %ebp
  100e5c:	89 e5                	mov    %esp,%ebp
  100e5e:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e61:	c7 45 fc 00 80 0b c0 	movl   $0xc00b8000,-0x4(%ebp)
    uint16_t was = *cp;
  100e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e6b:	0f b7 00             	movzwl (%eax),%eax
  100e6e:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e75:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e7d:	0f b7 00             	movzwl (%eax),%eax
  100e80:	0f b7 c0             	movzwl %ax,%eax
  100e83:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e88:	74 12                	je     100e9c <cga_init+0x41>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100e8a:	c7 45 fc 00 00 0b c0 	movl   $0xc00b0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;
  100e91:	66 c7 05 46 a4 11 00 	movw   $0x3b4,0x11a446
  100e98:	b4 03 
  100e9a:	eb 13                	jmp    100eaf <cga_init+0x54>
    } else {
        *cp = was;
  100e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e9f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100ea3:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ea6:	66 c7 05 46 a4 11 00 	movw   $0x3d4,0x11a446
  100ead:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100eaf:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100eb6:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100eba:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ebe:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100ec2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100ec6:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100ec7:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ece:	40                   	inc    %eax
  100ecf:	0f b7 c0             	movzwl %ax,%eax
  100ed2:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ed6:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100eda:	89 c2                	mov    %eax,%edx
  100edc:	ec                   	in     (%dx),%al
  100edd:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100ee0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100ee4:	0f b6 c0             	movzbl %al,%eax
  100ee7:	c1 e0 08             	shl    $0x8,%eax
  100eea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100eed:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100ef4:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ef8:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100efc:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100f00:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100f04:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f05:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  100f0c:	40                   	inc    %eax
  100f0d:	0f b7 c0             	movzwl %ax,%eax
  100f10:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f14:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f18:	89 c2                	mov    %eax,%edx
  100f1a:	ec                   	in     (%dx),%al
  100f1b:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100f1e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100f22:	0f b6 c0             	movzbl %al,%eax
  100f25:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;
  100f28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100f2b:	a3 40 a4 11 00       	mov    %eax,0x11a440
    crt_pos = pos;
  100f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100f33:	0f b7 c0             	movzwl %ax,%eax
  100f36:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
}
  100f3c:	90                   	nop
  100f3d:	c9                   	leave  
  100f3e:	c3                   	ret    

00100f3f <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f3f:	55                   	push   %ebp
  100f40:	89 e5                	mov    %esp,%ebp
  100f42:	83 ec 48             	sub    $0x48,%esp
  100f45:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100f4b:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f4f:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100f53:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100f57:	ee                   	out    %al,(%dx)
  100f58:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100f5e:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100f62:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100f66:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100f6a:	ee                   	out    %al,(%dx)
  100f6b:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100f71:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f75:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f79:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f7d:	ee                   	out    %al,(%dx)
  100f7e:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f84:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f88:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f8c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f90:	ee                   	out    %al,(%dx)
  100f91:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f97:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f9b:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f9f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100fa3:	ee                   	out    %al,(%dx)
  100fa4:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100faa:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100fae:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fb2:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fb6:	ee                   	out    %al,(%dx)
  100fb7:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fbd:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100fc1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fc5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fc9:	ee                   	out    %al,(%dx)
  100fca:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100fd0:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100fd4:	89 c2                	mov    %eax,%edx
  100fd6:	ec                   	in     (%dx),%al
  100fd7:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100fda:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100fde:	3c ff                	cmp    $0xff,%al
  100fe0:	0f 95 c0             	setne  %al
  100fe3:	0f b6 c0             	movzbl %al,%eax
  100fe6:	a3 48 a4 11 00       	mov    %eax,0x11a448
  100feb:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100ff1:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ff5:	89 c2                	mov    %eax,%edx
  100ff7:	ec                   	in     (%dx),%al
  100ff8:	88 45 f1             	mov    %al,-0xf(%ebp)
  100ffb:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101001:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101005:	89 c2                	mov    %eax,%edx
  101007:	ec                   	in     (%dx),%al
  101008:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10100b:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101010:	85 c0                	test   %eax,%eax
  101012:	74 0c                	je     101020 <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  101014:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10101b:	e8 df 06 00 00       	call   1016ff <pic_enable>
    }
}
  101020:	90                   	nop
  101021:	c9                   	leave  
  101022:	c3                   	ret    

00101023 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  101023:	55                   	push   %ebp
  101024:	89 e5                	mov    %esp,%ebp
  101026:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101029:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101030:	eb 08                	jmp    10103a <lpt_putc_sub+0x17>
        delay();
  101032:	e8 db fd ff ff       	call   100e12 <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101037:	ff 45 fc             	incl   -0x4(%ebp)
  10103a:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  101040:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101044:	89 c2                	mov    %eax,%edx
  101046:	ec                   	in     (%dx),%al
  101047:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  10104a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10104e:	84 c0                	test   %al,%al
  101050:	78 09                	js     10105b <lpt_putc_sub+0x38>
  101052:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101059:	7e d7                	jle    101032 <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  10105b:	8b 45 08             	mov    0x8(%ebp),%eax
  10105e:	0f b6 c0             	movzbl %al,%eax
  101061:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  101067:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10106a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10106e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101072:	ee                   	out    %al,(%dx)
  101073:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101079:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  10107d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101081:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101085:	ee                   	out    %al,(%dx)
  101086:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  10108c:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  101090:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101094:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101098:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101099:	90                   	nop
  10109a:	c9                   	leave  
  10109b:	c3                   	ret    

0010109c <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  10109c:	55                   	push   %ebp
  10109d:	89 e5                	mov    %esp,%ebp
  10109f:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1010a2:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1010a6:	74 0d                	je     1010b5 <lpt_putc+0x19>
        lpt_putc_sub(c);
  1010a8:	8b 45 08             	mov    0x8(%ebp),%eax
  1010ab:	89 04 24             	mov    %eax,(%esp)
  1010ae:	e8 70 ff ff ff       	call   101023 <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  1010b3:	eb 24                	jmp    1010d9 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  1010b5:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010bc:	e8 62 ff ff ff       	call   101023 <lpt_putc_sub>
        lpt_putc_sub(' ');
  1010c1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1010c8:	e8 56 ff ff ff       	call   101023 <lpt_putc_sub>
        lpt_putc_sub('\b');
  1010cd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1010d4:	e8 4a ff ff ff       	call   101023 <lpt_putc_sub>
}
  1010d9:	90                   	nop
  1010da:	c9                   	leave  
  1010db:	c3                   	ret    

001010dc <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  1010dc:	55                   	push   %ebp
  1010dd:	89 e5                	mov    %esp,%ebp
  1010df:	53                   	push   %ebx
  1010e0:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  1010e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1010e6:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010eb:	85 c0                	test   %eax,%eax
  1010ed:	75 07                	jne    1010f6 <cga_putc+0x1a>
        c |= 0x0700;
  1010ef:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  1010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  1010f9:	0f b6 c0             	movzbl %al,%eax
  1010fc:	83 f8 0a             	cmp    $0xa,%eax
  1010ff:	74 55                	je     101156 <cga_putc+0x7a>
  101101:	83 f8 0d             	cmp    $0xd,%eax
  101104:	74 63                	je     101169 <cga_putc+0x8d>
  101106:	83 f8 08             	cmp    $0x8,%eax
  101109:	0f 85 94 00 00 00    	jne    1011a3 <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  10110f:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101116:	85 c0                	test   %eax,%eax
  101118:	0f 84 af 00 00 00    	je     1011cd <cga_putc+0xf1>
            crt_pos --;
  10111e:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101125:	48                   	dec    %eax
  101126:	0f b7 c0             	movzwl %ax,%eax
  101129:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  10112f:	8b 45 08             	mov    0x8(%ebp),%eax
  101132:	98                   	cwtl   
  101133:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101138:	98                   	cwtl   
  101139:	83 c8 20             	or     $0x20,%eax
  10113c:	98                   	cwtl   
  10113d:	8b 15 40 a4 11 00    	mov    0x11a440,%edx
  101143:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  10114a:	01 c9                	add    %ecx,%ecx
  10114c:	01 ca                	add    %ecx,%edx
  10114e:	0f b7 c0             	movzwl %ax,%eax
  101151:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  101154:	eb 77                	jmp    1011cd <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  101156:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10115d:	83 c0 50             	add    $0x50,%eax
  101160:	0f b7 c0             	movzwl %ax,%eax
  101163:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  101169:	0f b7 1d 44 a4 11 00 	movzwl 0x11a444,%ebx
  101170:	0f b7 0d 44 a4 11 00 	movzwl 0x11a444,%ecx
  101177:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  10117c:	89 c8                	mov    %ecx,%eax
  10117e:	f7 e2                	mul    %edx
  101180:	c1 ea 06             	shr    $0x6,%edx
  101183:	89 d0                	mov    %edx,%eax
  101185:	c1 e0 02             	shl    $0x2,%eax
  101188:	01 d0                	add    %edx,%eax
  10118a:	c1 e0 04             	shl    $0x4,%eax
  10118d:	29 c1                	sub    %eax,%ecx
  10118f:	89 c8                	mov    %ecx,%eax
  101191:	0f b7 c0             	movzwl %ax,%eax
  101194:	29 c3                	sub    %eax,%ebx
  101196:	89 d8                	mov    %ebx,%eax
  101198:	0f b7 c0             	movzwl %ax,%eax
  10119b:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
        break;
  1011a1:	eb 2b                	jmp    1011ce <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011a3:	8b 0d 40 a4 11 00    	mov    0x11a440,%ecx
  1011a9:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011b0:	8d 50 01             	lea    0x1(%eax),%edx
  1011b3:	0f b7 d2             	movzwl %dx,%edx
  1011b6:	66 89 15 44 a4 11 00 	mov    %dx,0x11a444
  1011bd:	01 c0                	add    %eax,%eax
  1011bf:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  1011c2:	8b 45 08             	mov    0x8(%ebp),%eax
  1011c5:	0f b7 c0             	movzwl %ax,%eax
  1011c8:	66 89 02             	mov    %ax,(%edx)
        break;
  1011cb:	eb 01                	jmp    1011ce <cga_putc+0xf2>
        break;
  1011cd:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  1011ce:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  1011d5:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  1011da:	76 5d                	jbe    101239 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  1011dc:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011e1:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  1011e7:	a1 40 a4 11 00       	mov    0x11a440,%eax
  1011ec:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  1011f3:	00 
  1011f4:	89 54 24 04          	mov    %edx,0x4(%esp)
  1011f8:	89 04 24             	mov    %eax,(%esp)
  1011fb:	e8 42 45 00 00       	call   105742 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101200:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101207:	eb 14                	jmp    10121d <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101209:	a1 40 a4 11 00       	mov    0x11a440,%eax
  10120e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101211:	01 d2                	add    %edx,%edx
  101213:	01 d0                	add    %edx,%eax
  101215:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10121a:	ff 45 f4             	incl   -0xc(%ebp)
  10121d:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101224:	7e e3                	jle    101209 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  101226:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10122d:	83 e8 50             	sub    $0x50,%eax
  101230:	0f b7 c0             	movzwl %ax,%eax
  101233:	66 a3 44 a4 11 00    	mov    %ax,0x11a444
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  101239:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101240:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  101244:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  101248:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10124c:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101250:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  101251:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  101258:	c1 e8 08             	shr    $0x8,%eax
  10125b:	0f b7 c0             	movzwl %ax,%eax
  10125e:	0f b6 c0             	movzbl %al,%eax
  101261:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  101268:	42                   	inc    %edx
  101269:	0f b7 d2             	movzwl %dx,%edx
  10126c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101270:	88 45 e9             	mov    %al,-0x17(%ebp)
  101273:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101277:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10127b:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  10127c:	0f b7 05 46 a4 11 00 	movzwl 0x11a446,%eax
  101283:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101287:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  10128b:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10128f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101293:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101294:	0f b7 05 44 a4 11 00 	movzwl 0x11a444,%eax
  10129b:	0f b6 c0             	movzbl %al,%eax
  10129e:	0f b7 15 46 a4 11 00 	movzwl 0x11a446,%edx
  1012a5:	42                   	inc    %edx
  1012a6:	0f b7 d2             	movzwl %dx,%edx
  1012a9:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  1012ad:	88 45 f1             	mov    %al,-0xf(%ebp)
  1012b0:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012b4:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012b8:	ee                   	out    %al,(%dx)
}
  1012b9:	90                   	nop
  1012ba:	83 c4 34             	add    $0x34,%esp
  1012bd:	5b                   	pop    %ebx
  1012be:	5d                   	pop    %ebp
  1012bf:	c3                   	ret    

001012c0 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  1012c0:	55                   	push   %ebp
  1012c1:	89 e5                	mov    %esp,%ebp
  1012c3:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012c6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1012cd:	eb 08                	jmp    1012d7 <serial_putc_sub+0x17>
        delay();
  1012cf:	e8 3e fb ff ff       	call   100e12 <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  1012d4:	ff 45 fc             	incl   -0x4(%ebp)
  1012d7:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1012dd:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1012e1:	89 c2                	mov    %eax,%edx
  1012e3:	ec                   	in     (%dx),%al
  1012e4:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1012e7:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1012eb:	0f b6 c0             	movzbl %al,%eax
  1012ee:	83 e0 20             	and    $0x20,%eax
  1012f1:	85 c0                	test   %eax,%eax
  1012f3:	75 09                	jne    1012fe <serial_putc_sub+0x3e>
  1012f5:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  1012fc:	7e d1                	jle    1012cf <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  1012fe:	8b 45 08             	mov    0x8(%ebp),%eax
  101301:	0f b6 c0             	movzbl %al,%eax
  101304:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  10130a:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10130d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101311:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101315:	ee                   	out    %al,(%dx)
}
  101316:	90                   	nop
  101317:	c9                   	leave  
  101318:	c3                   	ret    

00101319 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  101319:	55                   	push   %ebp
  10131a:	89 e5                	mov    %esp,%ebp
  10131c:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10131f:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101323:	74 0d                	je     101332 <serial_putc+0x19>
        serial_putc_sub(c);
  101325:	8b 45 08             	mov    0x8(%ebp),%eax
  101328:	89 04 24             	mov    %eax,(%esp)
  10132b:	e8 90 ff ff ff       	call   1012c0 <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  101330:	eb 24                	jmp    101356 <serial_putc+0x3d>
        serial_putc_sub('\b');
  101332:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101339:	e8 82 ff ff ff       	call   1012c0 <serial_putc_sub>
        serial_putc_sub(' ');
  10133e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101345:	e8 76 ff ff ff       	call   1012c0 <serial_putc_sub>
        serial_putc_sub('\b');
  10134a:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101351:	e8 6a ff ff ff       	call   1012c0 <serial_putc_sub>
}
  101356:	90                   	nop
  101357:	c9                   	leave  
  101358:	c3                   	ret    

00101359 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  101359:	55                   	push   %ebp
  10135a:	89 e5                	mov    %esp,%ebp
  10135c:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  10135f:	eb 33                	jmp    101394 <cons_intr+0x3b>
        if (c != 0) {
  101361:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  101365:	74 2d                	je     101394 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  101367:	a1 64 a6 11 00       	mov    0x11a664,%eax
  10136c:	8d 50 01             	lea    0x1(%eax),%edx
  10136f:	89 15 64 a6 11 00    	mov    %edx,0x11a664
  101375:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101378:	88 90 60 a4 11 00    	mov    %dl,0x11a460(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10137e:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101383:	3d 00 02 00 00       	cmp    $0x200,%eax
  101388:	75 0a                	jne    101394 <cons_intr+0x3b>
                cons.wpos = 0;
  10138a:	c7 05 64 a6 11 00 00 	movl   $0x0,0x11a664
  101391:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101394:	8b 45 08             	mov    0x8(%ebp),%eax
  101397:	ff d0                	call   *%eax
  101399:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10139c:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  1013a0:	75 bf                	jne    101361 <cons_intr+0x8>
            }
        }
    }
}
  1013a2:	90                   	nop
  1013a3:	c9                   	leave  
  1013a4:	c3                   	ret    

001013a5 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  1013a5:	55                   	push   %ebp
  1013a6:	89 e5                	mov    %esp,%ebp
  1013a8:	83 ec 10             	sub    $0x10,%esp
  1013ab:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013b1:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  1013b5:	89 c2                	mov    %eax,%edx
  1013b7:	ec                   	in     (%dx),%al
  1013b8:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  1013bb:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  1013bf:	0f b6 c0             	movzbl %al,%eax
  1013c2:	83 e0 01             	and    $0x1,%eax
  1013c5:	85 c0                	test   %eax,%eax
  1013c7:	75 07                	jne    1013d0 <serial_proc_data+0x2b>
        return -1;
  1013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ce:	eb 2a                	jmp    1013fa <serial_proc_data+0x55>
  1013d0:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1013d6:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  1013da:	89 c2                	mov    %eax,%edx
  1013dc:	ec                   	in     (%dx),%al
  1013dd:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  1013e0:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  1013e4:	0f b6 c0             	movzbl %al,%eax
  1013e7:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  1013ea:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  1013ee:	75 07                	jne    1013f7 <serial_proc_data+0x52>
        c = '\b';
  1013f0:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  1013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  1013fa:	c9                   	leave  
  1013fb:	c3                   	ret    

001013fc <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  1013fc:	55                   	push   %ebp
  1013fd:	89 e5                	mov    %esp,%ebp
  1013ff:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  101402:	a1 48 a4 11 00       	mov    0x11a448,%eax
  101407:	85 c0                	test   %eax,%eax
  101409:	74 0c                	je     101417 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  10140b:	c7 04 24 a5 13 10 00 	movl   $0x1013a5,(%esp)
  101412:	e8 42 ff ff ff       	call   101359 <cons_intr>
    }
}
  101417:	90                   	nop
  101418:	c9                   	leave  
  101419:	c3                   	ret    

0010141a <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  10141a:	55                   	push   %ebp
  10141b:	89 e5                	mov    %esp,%ebp
  10141d:	83 ec 38             	sub    $0x38,%esp
  101420:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101429:	89 c2                	mov    %eax,%edx
  10142b:	ec                   	in     (%dx),%al
  10142c:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  10142f:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  101433:	0f b6 c0             	movzbl %al,%eax
  101436:	83 e0 01             	and    $0x1,%eax
  101439:	85 c0                	test   %eax,%eax
  10143b:	75 0a                	jne    101447 <kbd_proc_data+0x2d>
        return -1;
  10143d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  101442:	e9 55 01 00 00       	jmp    10159c <kbd_proc_data+0x182>
  101447:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10144d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  101450:	89 c2                	mov    %eax,%edx
  101452:	ec                   	in     (%dx),%al
  101453:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  101456:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  10145a:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  10145d:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  101461:	75 17                	jne    10147a <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  101463:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101468:	83 c8 40             	or     $0x40,%eax
  10146b:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  101470:	b8 00 00 00 00       	mov    $0x0,%eax
  101475:	e9 22 01 00 00       	jmp    10159c <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  10147a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10147e:	84 c0                	test   %al,%al
  101480:	79 45                	jns    1014c7 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  101482:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101487:	83 e0 40             	and    $0x40,%eax
  10148a:	85 c0                	test   %eax,%eax
  10148c:	75 08                	jne    101496 <kbd_proc_data+0x7c>
  10148e:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101492:	24 7f                	and    $0x7f,%al
  101494:	eb 04                	jmp    10149a <kbd_proc_data+0x80>
  101496:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10149a:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  10149d:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014a1:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014a8:	0c 40                	or     $0x40,%al
  1014aa:	0f b6 c0             	movzbl %al,%eax
  1014ad:	f7 d0                	not    %eax
  1014af:	89 c2                	mov    %eax,%edx
  1014b1:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014b6:	21 d0                	and    %edx,%eax
  1014b8:	a3 68 a6 11 00       	mov    %eax,0x11a668
        return 0;
  1014bd:	b8 00 00 00 00       	mov    $0x0,%eax
  1014c2:	e9 d5 00 00 00       	jmp    10159c <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  1014c7:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014cc:	83 e0 40             	and    $0x40,%eax
  1014cf:	85 c0                	test   %eax,%eax
  1014d1:	74 11                	je     1014e4 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  1014d3:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  1014d7:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014dc:	83 e0 bf             	and    $0xffffffbf,%eax
  1014df:	a3 68 a6 11 00       	mov    %eax,0x11a668
    }

    shift |= shiftcode[data];
  1014e4:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014e8:	0f b6 80 40 70 11 00 	movzbl 0x117040(%eax),%eax
  1014ef:	0f b6 d0             	movzbl %al,%edx
  1014f2:	a1 68 a6 11 00       	mov    0x11a668,%eax
  1014f7:	09 d0                	or     %edx,%eax
  1014f9:	a3 68 a6 11 00       	mov    %eax,0x11a668
    shift ^= togglecode[data];
  1014fe:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101502:	0f b6 80 40 71 11 00 	movzbl 0x117140(%eax),%eax
  101509:	0f b6 d0             	movzbl %al,%edx
  10150c:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101511:	31 d0                	xor    %edx,%eax
  101513:	a3 68 a6 11 00       	mov    %eax,0x11a668

    c = charcode[shift & (CTL | SHIFT)][data];
  101518:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10151d:	83 e0 03             	and    $0x3,%eax
  101520:	8b 14 85 40 75 11 00 	mov    0x117540(,%eax,4),%edx
  101527:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152b:	01 d0                	add    %edx,%eax
  10152d:	0f b6 00             	movzbl (%eax),%eax
  101530:	0f b6 c0             	movzbl %al,%eax
  101533:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  101536:	a1 68 a6 11 00       	mov    0x11a668,%eax
  10153b:	83 e0 08             	and    $0x8,%eax
  10153e:	85 c0                	test   %eax,%eax
  101540:	74 22                	je     101564 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  101542:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  101546:	7e 0c                	jle    101554 <kbd_proc_data+0x13a>
  101548:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  10154c:	7f 06                	jg     101554 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  10154e:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  101552:	eb 10                	jmp    101564 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  101554:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  101558:	7e 0a                	jle    101564 <kbd_proc_data+0x14a>
  10155a:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  10155e:	7f 04                	jg     101564 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  101560:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  101564:	a1 68 a6 11 00       	mov    0x11a668,%eax
  101569:	f7 d0                	not    %eax
  10156b:	83 e0 06             	and    $0x6,%eax
  10156e:	85 c0                	test   %eax,%eax
  101570:	75 27                	jne    101599 <kbd_proc_data+0x17f>
  101572:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101579:	75 1e                	jne    101599 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  10157b:	c7 04 24 3d 62 10 00 	movl   $0x10623d,(%esp)
  101582:	e8 0b ed ff ff       	call   100292 <cprintf>
  101587:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  10158d:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101591:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101595:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101598:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101599:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10159c:	c9                   	leave  
  10159d:	c3                   	ret    

0010159e <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10159e:	55                   	push   %ebp
  10159f:	89 e5                	mov    %esp,%ebp
  1015a1:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  1015a4:	c7 04 24 1a 14 10 00 	movl   $0x10141a,(%esp)
  1015ab:	e8 a9 fd ff ff       	call   101359 <cons_intr>
}
  1015b0:	90                   	nop
  1015b1:	c9                   	leave  
  1015b2:	c3                   	ret    

001015b3 <kbd_init>:

static void
kbd_init(void) {
  1015b3:	55                   	push   %ebp
  1015b4:	89 e5                	mov    %esp,%ebp
  1015b6:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  1015b9:	e8 e0 ff ff ff       	call   10159e <kbd_intr>
    pic_enable(IRQ_KBD);
  1015be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1015c5:	e8 35 01 00 00       	call   1016ff <pic_enable>
}
  1015ca:	90                   	nop
  1015cb:	c9                   	leave  
  1015cc:	c3                   	ret    

001015cd <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  1015cd:	55                   	push   %ebp
  1015ce:	89 e5                	mov    %esp,%ebp
  1015d0:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  1015d3:	e8 83 f8 ff ff       	call   100e5b <cga_init>
    serial_init();
  1015d8:	e8 62 f9 ff ff       	call   100f3f <serial_init>
    kbd_init();
  1015dd:	e8 d1 ff ff ff       	call   1015b3 <kbd_init>
    if (!serial_exists) {
  1015e2:	a1 48 a4 11 00       	mov    0x11a448,%eax
  1015e7:	85 c0                	test   %eax,%eax
  1015e9:	75 0c                	jne    1015f7 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  1015eb:	c7 04 24 49 62 10 00 	movl   $0x106249,(%esp)
  1015f2:	e8 9b ec ff ff       	call   100292 <cprintf>
    }
}
  1015f7:	90                   	nop
  1015f8:	c9                   	leave  
  1015f9:	c3                   	ret    

001015fa <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  1015fa:	55                   	push   %ebp
  1015fb:	89 e5                	mov    %esp,%ebp
  1015fd:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  101600:	e8 cf f7 ff ff       	call   100dd4 <__intr_save>
  101605:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101608:	8b 45 08             	mov    0x8(%ebp),%eax
  10160b:	89 04 24             	mov    %eax,(%esp)
  10160e:	e8 89 fa ff ff       	call   10109c <lpt_putc>
        cga_putc(c);
  101613:	8b 45 08             	mov    0x8(%ebp),%eax
  101616:	89 04 24             	mov    %eax,(%esp)
  101619:	e8 be fa ff ff       	call   1010dc <cga_putc>
        serial_putc(c);
  10161e:	8b 45 08             	mov    0x8(%ebp),%eax
  101621:	89 04 24             	mov    %eax,(%esp)
  101624:	e8 f0 fc ff ff       	call   101319 <serial_putc>
    }
    local_intr_restore(intr_flag);
  101629:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10162c:	89 04 24             	mov    %eax,(%esp)
  10162f:	e8 ca f7 ff ff       	call   100dfe <__intr_restore>
}
  101634:	90                   	nop
  101635:	c9                   	leave  
  101636:	c3                   	ret    

00101637 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  101637:	55                   	push   %ebp
  101638:	89 e5                	mov    %esp,%ebp
  10163a:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  10163d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  101644:	e8 8b f7 ff ff       	call   100dd4 <__intr_save>
  101649:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  10164c:	e8 ab fd ff ff       	call   1013fc <serial_intr>
        kbd_intr();
  101651:	e8 48 ff ff ff       	call   10159e <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  101656:	8b 15 60 a6 11 00    	mov    0x11a660,%edx
  10165c:	a1 64 a6 11 00       	mov    0x11a664,%eax
  101661:	39 c2                	cmp    %eax,%edx
  101663:	74 31                	je     101696 <cons_getc+0x5f>
            c = cons.buf[cons.rpos ++];
  101665:	a1 60 a6 11 00       	mov    0x11a660,%eax
  10166a:	8d 50 01             	lea    0x1(%eax),%edx
  10166d:	89 15 60 a6 11 00    	mov    %edx,0x11a660
  101673:	0f b6 80 60 a4 11 00 	movzbl 0x11a460(%eax),%eax
  10167a:	0f b6 c0             	movzbl %al,%eax
  10167d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (cons.rpos == CONSBUFSIZE) {
  101680:	a1 60 a6 11 00       	mov    0x11a660,%eax
  101685:	3d 00 02 00 00       	cmp    $0x200,%eax
  10168a:	75 0a                	jne    101696 <cons_getc+0x5f>
                cons.rpos = 0;
  10168c:	c7 05 60 a6 11 00 00 	movl   $0x0,0x11a660
  101693:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101696:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101699:	89 04 24             	mov    %eax,(%esp)
  10169c:	e8 5d f7 ff ff       	call   100dfe <__intr_restore>
    return c;
  1016a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1016a4:	c9                   	leave  
  1016a5:	c3                   	ret    

001016a6 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  1016a6:	55                   	push   %ebp
  1016a7:	89 e5                	mov    %esp,%ebp
  1016a9:	83 ec 14             	sub    $0x14,%esp
  1016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1016af:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  1016b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016b6:	66 a3 50 75 11 00    	mov    %ax,0x117550
    if (did_init) {
  1016bc:	a1 6c a6 11 00       	mov    0x11a66c,%eax
  1016c1:	85 c0                	test   %eax,%eax
  1016c3:	74 37                	je     1016fc <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  1016c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1016c8:	0f b6 c0             	movzbl %al,%eax
  1016cb:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  1016d1:	88 45 f9             	mov    %al,-0x7(%ebp)
  1016d4:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1016d8:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  1016dc:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  1016dd:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  1016e1:	c1 e8 08             	shr    $0x8,%eax
  1016e4:	0f b7 c0             	movzwl %ax,%eax
  1016e7:	0f b6 c0             	movzbl %al,%eax
  1016ea:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  1016f0:	88 45 fd             	mov    %al,-0x3(%ebp)
  1016f3:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1016f7:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1016fb:	ee                   	out    %al,(%dx)
    }
}
  1016fc:	90                   	nop
  1016fd:	c9                   	leave  
  1016fe:	c3                   	ret    

001016ff <pic_enable>:

void
pic_enable(unsigned int irq) {
  1016ff:	55                   	push   %ebp
  101700:	89 e5                	mov    %esp,%ebp
  101702:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  101705:	8b 45 08             	mov    0x8(%ebp),%eax
  101708:	ba 01 00 00 00       	mov    $0x1,%edx
  10170d:	88 c1                	mov    %al,%cl
  10170f:	d3 e2                	shl    %cl,%edx
  101711:	89 d0                	mov    %edx,%eax
  101713:	98                   	cwtl   
  101714:	f7 d0                	not    %eax
  101716:	0f bf d0             	movswl %ax,%edx
  101719:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101720:	98                   	cwtl   
  101721:	21 d0                	and    %edx,%eax
  101723:	98                   	cwtl   
  101724:	0f b7 c0             	movzwl %ax,%eax
  101727:	89 04 24             	mov    %eax,(%esp)
  10172a:	e8 77 ff ff ff       	call   1016a6 <pic_setmask>
}
  10172f:	90                   	nop
  101730:	c9                   	leave  
  101731:	c3                   	ret    

00101732 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101732:	55                   	push   %ebp
  101733:	89 e5                	mov    %esp,%ebp
  101735:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  101738:	c7 05 6c a6 11 00 01 	movl   $0x1,0x11a66c
  10173f:	00 00 00 
  101742:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  101748:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  10174c:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  101750:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  101754:	ee                   	out    %al,(%dx)
  101755:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  10175b:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  10175f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  101763:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  101767:	ee                   	out    %al,(%dx)
  101768:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  10176e:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  101772:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  101776:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  10177a:	ee                   	out    %al,(%dx)
  10177b:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  101781:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  101785:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  101789:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  10178d:	ee                   	out    %al,(%dx)
  10178e:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  101794:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  101798:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  10179c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1017a0:	ee                   	out    %al,(%dx)
  1017a1:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  1017a7:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  1017ab:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  1017af:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  1017b3:	ee                   	out    %al,(%dx)
  1017b4:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  1017ba:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  1017be:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  1017c2:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  1017c6:	ee                   	out    %al,(%dx)
  1017c7:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  1017cd:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  1017d1:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1017d5:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1017d9:	ee                   	out    %al,(%dx)
  1017da:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  1017e0:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  1017e4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1017e8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1017ec:	ee                   	out    %al,(%dx)
  1017ed:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  1017f3:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  1017f7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1017fb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1017ff:	ee                   	out    %al,(%dx)
  101800:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  101806:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  10180a:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10180e:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101812:	ee                   	out    %al,(%dx)
  101813:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101819:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  10181d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101821:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101825:	ee                   	out    %al,(%dx)
  101826:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  10182c:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101830:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101834:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101838:	ee                   	out    %al,(%dx)
  101839:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  10183f:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  101843:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101847:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  10184b:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  10184c:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101853:	3d ff ff 00 00       	cmp    $0xffff,%eax
  101858:	74 0f                	je     101869 <pic_init+0x137>
        pic_setmask(irq_mask);
  10185a:	0f b7 05 50 75 11 00 	movzwl 0x117550,%eax
  101861:	89 04 24             	mov    %eax,(%esp)
  101864:	e8 3d fe ff ff       	call   1016a6 <pic_setmask>
    }
}
  101869:	90                   	nop
  10186a:	c9                   	leave  
  10186b:	c3                   	ret    

0010186c <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  10186c:	55                   	push   %ebp
  10186d:	89 e5                	mov    %esp,%ebp
    asm volatile ("sti");
  10186f:	fb                   	sti    
    sti();
}
  101870:	90                   	nop
  101871:	5d                   	pop    %ebp
  101872:	c3                   	ret    

00101873 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  101873:	55                   	push   %ebp
  101874:	89 e5                	mov    %esp,%ebp
    asm volatile ("cli" ::: "memory");
  101876:	fa                   	cli    
    cli();
}
  101877:	90                   	nop
  101878:	5d                   	pop    %ebp
  101879:	c3                   	ret    

0010187a <print_ticks>:

#define TICK_NUM 100
extern uintptr_t __vectors[];
static int count = 0;

static void print_ticks() {
  10187a:	55                   	push   %ebp
  10187b:	89 e5                	mov    %esp,%ebp
  10187d:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  101880:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101887:	00 
  101888:	c7 04 24 80 62 10 00 	movl   $0x106280,(%esp)
  10188f:	e8 fe e9 ff ff       	call   100292 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  101894:	c7 04 24 8a 62 10 00 	movl   $0x10628a,(%esp)
  10189b:	e8 f2 e9 ff ff       	call   100292 <cprintf>
    panic("EOT: kernel seems ok.");
  1018a0:	c7 44 24 08 98 62 10 	movl   $0x106298,0x8(%esp)
  1018a7:	00 
  1018a8:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  1018af:	00 
  1018b0:	c7 04 24 ae 62 10 00 	movl   $0x1062ae,(%esp)
  1018b7:	e8 2d eb ff ff       	call   1003e9 <__panic>

001018bc <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  1018bc:	55                   	push   %ebp
  1018bd:	89 e5                	mov    %esp,%ebp
  1018bf:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    int i;
    for(i = 0; i < 256; ++i) {
  1018c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  1018c9:	e9 c4 00 00 00       	jmp    101992 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  1018ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018d1:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  1018d8:	0f b7 d0             	movzwl %ax,%edx
  1018db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018de:	66 89 14 c5 a0 a6 11 	mov    %dx,0x11a6a0(,%eax,8)
  1018e5:	00 
  1018e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018e9:	66 c7 04 c5 a2 a6 11 	movw   $0x8,0x11a6a2(,%eax,8)
  1018f0:	00 08 00 
  1018f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018f6:	0f b6 14 c5 a4 a6 11 	movzbl 0x11a6a4(,%eax,8),%edx
  1018fd:	00 
  1018fe:	80 e2 e0             	and    $0xe0,%dl
  101901:	88 14 c5 a4 a6 11 00 	mov    %dl,0x11a6a4(,%eax,8)
  101908:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10190b:	0f b6 14 c5 a4 a6 11 	movzbl 0x11a6a4(,%eax,8),%edx
  101912:	00 
  101913:	80 e2 1f             	and    $0x1f,%dl
  101916:	88 14 c5 a4 a6 11 00 	mov    %dl,0x11a6a4(,%eax,8)
  10191d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101920:	0f b6 14 c5 a5 a6 11 	movzbl 0x11a6a5(,%eax,8),%edx
  101927:	00 
  101928:	80 e2 f0             	and    $0xf0,%dl
  10192b:	80 ca 0e             	or     $0xe,%dl
  10192e:	88 14 c5 a5 a6 11 00 	mov    %dl,0x11a6a5(,%eax,8)
  101935:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101938:	0f b6 14 c5 a5 a6 11 	movzbl 0x11a6a5(,%eax,8),%edx
  10193f:	00 
  101940:	80 e2 ef             	and    $0xef,%dl
  101943:	88 14 c5 a5 a6 11 00 	mov    %dl,0x11a6a5(,%eax,8)
  10194a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10194d:	0f b6 14 c5 a5 a6 11 	movzbl 0x11a6a5(,%eax,8),%edx
  101954:	00 
  101955:	80 e2 9f             	and    $0x9f,%dl
  101958:	88 14 c5 a5 a6 11 00 	mov    %dl,0x11a6a5(,%eax,8)
  10195f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101962:	0f b6 14 c5 a5 a6 11 	movzbl 0x11a6a5(,%eax,8),%edx
  101969:	00 
  10196a:	80 ca 80             	or     $0x80,%dl
  10196d:	88 14 c5 a5 a6 11 00 	mov    %dl,0x11a6a5(,%eax,8)
  101974:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101977:	8b 04 85 e0 75 11 00 	mov    0x1175e0(,%eax,4),%eax
  10197e:	c1 e8 10             	shr    $0x10,%eax
  101981:	0f b7 d0             	movzwl %ax,%edx
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	66 89 14 c5 a6 a6 11 	mov    %dx,0x11a6a6(,%eax,8)
  10198e:	00 
    for(i = 0; i < 256; ++i) {
  10198f:	ff 45 fc             	incl   -0x4(%ebp)
  101992:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  101999:	0f 8e 2f ff ff ff    	jle    1018ce <idt_init+0x12>
  10199f:	c7 45 f8 60 75 11 00 	movl   $0x117560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  1019a6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1019a9:	0f 01 18             	lidtl  (%eax)
    }
    //set the syscall for user
    //load the idt;
    lidt(&idt_pd);
}
  1019ac:	90                   	nop
  1019ad:	c9                   	leave  
  1019ae:	c3                   	ret    

001019af <trapname>:

static const char *
trapname(int trapno) {
  1019af:	55                   	push   %ebp
  1019b0:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  1019b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1019b5:	83 f8 13             	cmp    $0x13,%eax
  1019b8:	77 0c                	ja     1019c6 <trapname+0x17>
        return excnames[trapno];
  1019ba:	8b 45 08             	mov    0x8(%ebp),%eax
  1019bd:	8b 04 85 00 66 10 00 	mov    0x106600(,%eax,4),%eax
  1019c4:	eb 18                	jmp    1019de <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  1019c6:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  1019ca:	7e 0d                	jle    1019d9 <trapname+0x2a>
  1019cc:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  1019d0:	7f 07                	jg     1019d9 <trapname+0x2a>
        return "Hardware Interrupt";
  1019d2:	b8 bf 62 10 00       	mov    $0x1062bf,%eax
  1019d7:	eb 05                	jmp    1019de <trapname+0x2f>
    }
    return "(unknown trap)";
  1019d9:	b8 d2 62 10 00       	mov    $0x1062d2,%eax
}
  1019de:	5d                   	pop    %ebp
  1019df:	c3                   	ret    

001019e0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  1019e0:	55                   	push   %ebp
  1019e1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  1019e3:	8b 45 08             	mov    0x8(%ebp),%eax
  1019e6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  1019ea:	83 f8 08             	cmp    $0x8,%eax
  1019ed:	0f 94 c0             	sete   %al
  1019f0:	0f b6 c0             	movzbl %al,%eax
}
  1019f3:	5d                   	pop    %ebp
  1019f4:	c3                   	ret    

001019f5 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  1019f5:	55                   	push   %ebp
  1019f6:	89 e5                	mov    %esp,%ebp
  1019f8:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  1019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  1019fe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a02:	c7 04 24 13 63 10 00 	movl   $0x106313,(%esp)
  101a09:	e8 84 e8 ff ff       	call   100292 <cprintf>
    print_regs(&tf->tf_regs);
  101a0e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a11:	89 04 24             	mov    %eax,(%esp)
  101a14:	e8 8f 01 00 00       	call   101ba8 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a19:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a20:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a24:	c7 04 24 24 63 10 00 	movl   $0x106324,(%esp)
  101a2b:	e8 62 e8 ff ff       	call   100292 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a30:	8b 45 08             	mov    0x8(%ebp),%eax
  101a33:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a3b:	c7 04 24 37 63 10 00 	movl   $0x106337,(%esp)
  101a42:	e8 4b e8 ff ff       	call   100292 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101a47:	8b 45 08             	mov    0x8(%ebp),%eax
  101a4a:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101a4e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a52:	c7 04 24 4a 63 10 00 	movl   $0x10634a,(%esp)
  101a59:	e8 34 e8 ff ff       	call   100292 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101a61:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101a65:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a69:	c7 04 24 5d 63 10 00 	movl   $0x10635d,(%esp)
  101a70:	e8 1d e8 ff ff       	call   100292 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101a75:	8b 45 08             	mov    0x8(%ebp),%eax
  101a78:	8b 40 30             	mov    0x30(%eax),%eax
  101a7b:	89 04 24             	mov    %eax,(%esp)
  101a7e:	e8 2c ff ff ff       	call   1019af <trapname>
  101a83:	89 c2                	mov    %eax,%edx
  101a85:	8b 45 08             	mov    0x8(%ebp),%eax
  101a88:	8b 40 30             	mov    0x30(%eax),%eax
  101a8b:	89 54 24 08          	mov    %edx,0x8(%esp)
  101a8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a93:	c7 04 24 70 63 10 00 	movl   $0x106370,(%esp)
  101a9a:	e8 f3 e7 ff ff       	call   100292 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa2:	8b 40 34             	mov    0x34(%eax),%eax
  101aa5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aa9:	c7 04 24 82 63 10 00 	movl   $0x106382,(%esp)
  101ab0:	e8 dd e7 ff ff       	call   100292 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  101ab8:	8b 40 38             	mov    0x38(%eax),%eax
  101abb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101abf:	c7 04 24 91 63 10 00 	movl   $0x106391,(%esp)
  101ac6:	e8 c7 e7 ff ff       	call   100292 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101acb:	8b 45 08             	mov    0x8(%ebp),%eax
  101ace:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ad6:	c7 04 24 a0 63 10 00 	movl   $0x1063a0,(%esp)
  101add:	e8 b0 e7 ff ff       	call   100292 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	8b 40 40             	mov    0x40(%eax),%eax
  101ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101aec:	c7 04 24 b3 63 10 00 	movl   $0x1063b3,(%esp)
  101af3:	e8 9a e7 ff ff       	call   100292 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101af8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101aff:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b06:	eb 3d                	jmp    101b45 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b08:	8b 45 08             	mov    0x8(%ebp),%eax
  101b0b:	8b 50 40             	mov    0x40(%eax),%edx
  101b0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b11:	21 d0                	and    %edx,%eax
  101b13:	85 c0                	test   %eax,%eax
  101b15:	74 28                	je     101b3f <print_trapframe+0x14a>
  101b17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b1a:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101b21:	85 c0                	test   %eax,%eax
  101b23:	74 1a                	je     101b3f <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101b25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b28:	8b 04 85 80 75 11 00 	mov    0x117580(,%eax,4),%eax
  101b2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b33:	c7 04 24 c2 63 10 00 	movl   $0x1063c2,(%esp)
  101b3a:	e8 53 e7 ff ff       	call   100292 <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b3f:	ff 45 f4             	incl   -0xc(%ebp)
  101b42:	d1 65 f0             	shll   -0x10(%ebp)
  101b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b48:	83 f8 17             	cmp    $0x17,%eax
  101b4b:	76 bb                	jbe    101b08 <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b50:	8b 40 40             	mov    0x40(%eax),%eax
  101b53:	c1 e8 0c             	shr    $0xc,%eax
  101b56:	83 e0 03             	and    $0x3,%eax
  101b59:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5d:	c7 04 24 c6 63 10 00 	movl   $0x1063c6,(%esp)
  101b64:	e8 29 e7 ff ff       	call   100292 <cprintf>

    if (!trap_in_kernel(tf)) {
  101b69:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6c:	89 04 24             	mov    %eax,(%esp)
  101b6f:	e8 6c fe ff ff       	call   1019e0 <trap_in_kernel>
  101b74:	85 c0                	test   %eax,%eax
  101b76:	75 2d                	jne    101ba5 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101b78:	8b 45 08             	mov    0x8(%ebp),%eax
  101b7b:	8b 40 44             	mov    0x44(%eax),%eax
  101b7e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b82:	c7 04 24 cf 63 10 00 	movl   $0x1063cf,(%esp)
  101b89:	e8 04 e7 ff ff       	call   100292 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b91:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101b95:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b99:	c7 04 24 de 63 10 00 	movl   $0x1063de,(%esp)
  101ba0:	e8 ed e6 ff ff       	call   100292 <cprintf>
    }
}
  101ba5:	90                   	nop
  101ba6:	c9                   	leave  
  101ba7:	c3                   	ret    

00101ba8 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ba8:	55                   	push   %ebp
  101ba9:	89 e5                	mov    %esp,%ebp
  101bab:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101bae:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb1:	8b 00                	mov    (%eax),%eax
  101bb3:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb7:	c7 04 24 f1 63 10 00 	movl   $0x1063f1,(%esp)
  101bbe:	e8 cf e6 ff ff       	call   100292 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  101bc6:	8b 40 04             	mov    0x4(%eax),%eax
  101bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bcd:	c7 04 24 00 64 10 00 	movl   $0x106400,(%esp)
  101bd4:	e8 b9 e6 ff ff       	call   100292 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdc:	8b 40 08             	mov    0x8(%eax),%eax
  101bdf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be3:	c7 04 24 0f 64 10 00 	movl   $0x10640f,(%esp)
  101bea:	e8 a3 e6 ff ff       	call   100292 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101bef:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf2:	8b 40 0c             	mov    0xc(%eax),%eax
  101bf5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bf9:	c7 04 24 1e 64 10 00 	movl   $0x10641e,(%esp)
  101c00:	e8 8d e6 ff ff       	call   100292 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c05:	8b 45 08             	mov    0x8(%ebp),%eax
  101c08:	8b 40 10             	mov    0x10(%eax),%eax
  101c0b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c0f:	c7 04 24 2d 64 10 00 	movl   $0x10642d,(%esp)
  101c16:	e8 77 e6 ff ff       	call   100292 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c1e:	8b 40 14             	mov    0x14(%eax),%eax
  101c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c25:	c7 04 24 3c 64 10 00 	movl   $0x10643c,(%esp)
  101c2c:	e8 61 e6 ff ff       	call   100292 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c31:	8b 45 08             	mov    0x8(%ebp),%eax
  101c34:	8b 40 18             	mov    0x18(%eax),%eax
  101c37:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c3b:	c7 04 24 4b 64 10 00 	movl   $0x10644b,(%esp)
  101c42:	e8 4b e6 ff ff       	call   100292 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101c47:	8b 45 08             	mov    0x8(%ebp),%eax
  101c4a:	8b 40 1c             	mov    0x1c(%eax),%eax
  101c4d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c51:	c7 04 24 5a 64 10 00 	movl   $0x10645a,(%esp)
  101c58:	e8 35 e6 ff ff       	call   100292 <cprintf>
}
  101c5d:	90                   	nop
  101c5e:	c9                   	leave  
  101c5f:	c3                   	ret    

00101c60 <trap_dispatch>:
struct trapframe swithk2u;
struct trapframe *switchu2k;

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101c60:	55                   	push   %ebp
  101c61:	89 e5                	mov    %esp,%ebp
  101c63:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101c66:	8b 45 08             	mov    0x8(%ebp),%eax
  101c69:	8b 40 30             	mov    0x30(%eax),%eax
  101c6c:	83 f8 2f             	cmp    $0x2f,%eax
  101c6f:	77 21                	ja     101c92 <trap_dispatch+0x32>
  101c71:	83 f8 2e             	cmp    $0x2e,%eax
  101c74:	0f 83 f1 00 00 00    	jae    101d6b <trap_dispatch+0x10b>
  101c7a:	83 f8 21             	cmp    $0x21,%eax
  101c7d:	0f 84 8d 00 00 00    	je     101d10 <trap_dispatch+0xb0>
  101c83:	83 f8 24             	cmp    $0x24,%eax
  101c86:	74 62                	je     101cea <trap_dispatch+0x8a>
  101c88:	83 f8 20             	cmp    $0x20,%eax
  101c8b:	74 16                	je     101ca3 <trap_dispatch+0x43>
  101c8d:	e9 a4 00 00 00       	jmp    101d36 <trap_dispatch+0xd6>
  101c92:	83 e8 78             	sub    $0x78,%eax
  101c95:	83 f8 01             	cmp    $0x1,%eax
  101c98:	0f 87 98 00 00 00    	ja     101d36 <trap_dispatch+0xd6>
        break;
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
	 
    case T_SWITCH_TOK:
        break;
  101c9e:	e9 c9 00 00 00       	jmp    101d6c <trap_dispatch+0x10c>
        if(count % TICK_NUM == 0) {
  101ca3:	8b 0d 80 a6 11 00    	mov    0x11a680,%ecx
  101ca9:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  101cae:	f7 e9                	imul   %ecx
  101cb0:	c1 fa 05             	sar    $0x5,%edx
  101cb3:	89 c8                	mov    %ecx,%eax
  101cb5:	c1 f8 1f             	sar    $0x1f,%eax
  101cb8:	29 c2                	sub    %eax,%edx
  101cba:	89 d0                	mov    %edx,%eax
  101cbc:	c1 e0 02             	shl    $0x2,%eax
  101cbf:	01 d0                	add    %edx,%eax
  101cc1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  101cc8:	01 d0                	add    %edx,%eax
  101cca:	c1 e0 02             	shl    $0x2,%eax
  101ccd:	29 c1                	sub    %eax,%ecx
  101ccf:	89 ca                	mov    %ecx,%edx
  101cd1:	85 d2                	test   %edx,%edx
  101cd3:	75 05                	jne    101cda <trap_dispatch+0x7a>
            print_ticks();
  101cd5:	e8 a0 fb ff ff       	call   10187a <print_ticks>
        ++count;
  101cda:	a1 80 a6 11 00       	mov    0x11a680,%eax
  101cdf:	40                   	inc    %eax
  101ce0:	a3 80 a6 11 00       	mov    %eax,0x11a680
        break;
  101ce5:	e9 82 00 00 00       	jmp    101d6c <trap_dispatch+0x10c>
        c = cons_getc();
  101cea:	e8 48 f9 ff ff       	call   101637 <cons_getc>
  101cef:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101cf2:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101cf6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101cfa:	89 54 24 08          	mov    %edx,0x8(%esp)
  101cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d02:	c7 04 24 69 64 10 00 	movl   $0x106469,(%esp)
  101d09:	e8 84 e5 ff ff       	call   100292 <cprintf>
        break;
  101d0e:	eb 5c                	jmp    101d6c <trap_dispatch+0x10c>
        c = cons_getc();
  101d10:	e8 22 f9 ff ff       	call   101637 <cons_getc>
  101d15:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d18:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101d1c:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101d20:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d28:	c7 04 24 7b 64 10 00 	movl   $0x10647b,(%esp)
  101d2f:	e8 5e e5 ff ff       	call   100292 <cprintf>
        break;
  101d34:	eb 36                	jmp    101d6c <trap_dispatch+0x10c>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101d36:	8b 45 08             	mov    0x8(%ebp),%eax
  101d39:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d3d:	83 e0 03             	and    $0x3,%eax
  101d40:	85 c0                	test   %eax,%eax
  101d42:	75 28                	jne    101d6c <trap_dispatch+0x10c>
            print_trapframe(tf);
  101d44:	8b 45 08             	mov    0x8(%ebp),%eax
  101d47:	89 04 24             	mov    %eax,(%esp)
  101d4a:	e8 a6 fc ff ff       	call   1019f5 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101d4f:	c7 44 24 08 8a 64 10 	movl   $0x10648a,0x8(%esp)
  101d56:	00 
  101d57:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
  101d5e:	00 
  101d5f:	c7 04 24 ae 62 10 00 	movl   $0x1062ae,(%esp)
  101d66:	e8 7e e6 ff ff       	call   1003e9 <__panic>
        break;
  101d6b:	90                   	nop
        }
    }
}
  101d6c:	90                   	nop
  101d6d:	c9                   	leave  
  101d6e:	c3                   	ret    

00101d6f <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101d6f:	55                   	push   %ebp
  101d70:	89 e5                	mov    %esp,%ebp
  101d72:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101d75:	8b 45 08             	mov    0x8(%ebp),%eax
  101d78:	89 04 24             	mov    %eax,(%esp)
  101d7b:	e8 e0 fe ff ff       	call   101c60 <trap_dispatch>
}
  101d80:	90                   	nop
  101d81:	c9                   	leave  
  101d82:	c3                   	ret    

00101d83 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101d83:	6a 00                	push   $0x0
  pushl $0
  101d85:	6a 00                	push   $0x0
  jmp __alltraps
  101d87:	e9 69 0a 00 00       	jmp    1027f5 <__alltraps>

00101d8c <vector1>:
.globl vector1
vector1:
  pushl $0
  101d8c:	6a 00                	push   $0x0
  pushl $1
  101d8e:	6a 01                	push   $0x1
  jmp __alltraps
  101d90:	e9 60 0a 00 00       	jmp    1027f5 <__alltraps>

00101d95 <vector2>:
.globl vector2
vector2:
  pushl $0
  101d95:	6a 00                	push   $0x0
  pushl $2
  101d97:	6a 02                	push   $0x2
  jmp __alltraps
  101d99:	e9 57 0a 00 00       	jmp    1027f5 <__alltraps>

00101d9e <vector3>:
.globl vector3
vector3:
  pushl $0
  101d9e:	6a 00                	push   $0x0
  pushl $3
  101da0:	6a 03                	push   $0x3
  jmp __alltraps
  101da2:	e9 4e 0a 00 00       	jmp    1027f5 <__alltraps>

00101da7 <vector4>:
.globl vector4
vector4:
  pushl $0
  101da7:	6a 00                	push   $0x0
  pushl $4
  101da9:	6a 04                	push   $0x4
  jmp __alltraps
  101dab:	e9 45 0a 00 00       	jmp    1027f5 <__alltraps>

00101db0 <vector5>:
.globl vector5
vector5:
  pushl $0
  101db0:	6a 00                	push   $0x0
  pushl $5
  101db2:	6a 05                	push   $0x5
  jmp __alltraps
  101db4:	e9 3c 0a 00 00       	jmp    1027f5 <__alltraps>

00101db9 <vector6>:
.globl vector6
vector6:
  pushl $0
  101db9:	6a 00                	push   $0x0
  pushl $6
  101dbb:	6a 06                	push   $0x6
  jmp __alltraps
  101dbd:	e9 33 0a 00 00       	jmp    1027f5 <__alltraps>

00101dc2 <vector7>:
.globl vector7
vector7:
  pushl $0
  101dc2:	6a 00                	push   $0x0
  pushl $7
  101dc4:	6a 07                	push   $0x7
  jmp __alltraps
  101dc6:	e9 2a 0a 00 00       	jmp    1027f5 <__alltraps>

00101dcb <vector8>:
.globl vector8
vector8:
  pushl $8
  101dcb:	6a 08                	push   $0x8
  jmp __alltraps
  101dcd:	e9 23 0a 00 00       	jmp    1027f5 <__alltraps>

00101dd2 <vector9>:
.globl vector9
vector9:
  pushl $0
  101dd2:	6a 00                	push   $0x0
  pushl $9
  101dd4:	6a 09                	push   $0x9
  jmp __alltraps
  101dd6:	e9 1a 0a 00 00       	jmp    1027f5 <__alltraps>

00101ddb <vector10>:
.globl vector10
vector10:
  pushl $10
  101ddb:	6a 0a                	push   $0xa
  jmp __alltraps
  101ddd:	e9 13 0a 00 00       	jmp    1027f5 <__alltraps>

00101de2 <vector11>:
.globl vector11
vector11:
  pushl $11
  101de2:	6a 0b                	push   $0xb
  jmp __alltraps
  101de4:	e9 0c 0a 00 00       	jmp    1027f5 <__alltraps>

00101de9 <vector12>:
.globl vector12
vector12:
  pushl $12
  101de9:	6a 0c                	push   $0xc
  jmp __alltraps
  101deb:	e9 05 0a 00 00       	jmp    1027f5 <__alltraps>

00101df0 <vector13>:
.globl vector13
vector13:
  pushl $13
  101df0:	6a 0d                	push   $0xd
  jmp __alltraps
  101df2:	e9 fe 09 00 00       	jmp    1027f5 <__alltraps>

00101df7 <vector14>:
.globl vector14
vector14:
  pushl $14
  101df7:	6a 0e                	push   $0xe
  jmp __alltraps
  101df9:	e9 f7 09 00 00       	jmp    1027f5 <__alltraps>

00101dfe <vector15>:
.globl vector15
vector15:
  pushl $0
  101dfe:	6a 00                	push   $0x0
  pushl $15
  101e00:	6a 0f                	push   $0xf
  jmp __alltraps
  101e02:	e9 ee 09 00 00       	jmp    1027f5 <__alltraps>

00101e07 <vector16>:
.globl vector16
vector16:
  pushl $0
  101e07:	6a 00                	push   $0x0
  pushl $16
  101e09:	6a 10                	push   $0x10
  jmp __alltraps
  101e0b:	e9 e5 09 00 00       	jmp    1027f5 <__alltraps>

00101e10 <vector17>:
.globl vector17
vector17:
  pushl $17
  101e10:	6a 11                	push   $0x11
  jmp __alltraps
  101e12:	e9 de 09 00 00       	jmp    1027f5 <__alltraps>

00101e17 <vector18>:
.globl vector18
vector18:
  pushl $0
  101e17:	6a 00                	push   $0x0
  pushl $18
  101e19:	6a 12                	push   $0x12
  jmp __alltraps
  101e1b:	e9 d5 09 00 00       	jmp    1027f5 <__alltraps>

00101e20 <vector19>:
.globl vector19
vector19:
  pushl $0
  101e20:	6a 00                	push   $0x0
  pushl $19
  101e22:	6a 13                	push   $0x13
  jmp __alltraps
  101e24:	e9 cc 09 00 00       	jmp    1027f5 <__alltraps>

00101e29 <vector20>:
.globl vector20
vector20:
  pushl $0
  101e29:	6a 00                	push   $0x0
  pushl $20
  101e2b:	6a 14                	push   $0x14
  jmp __alltraps
  101e2d:	e9 c3 09 00 00       	jmp    1027f5 <__alltraps>

00101e32 <vector21>:
.globl vector21
vector21:
  pushl $0
  101e32:	6a 00                	push   $0x0
  pushl $21
  101e34:	6a 15                	push   $0x15
  jmp __alltraps
  101e36:	e9 ba 09 00 00       	jmp    1027f5 <__alltraps>

00101e3b <vector22>:
.globl vector22
vector22:
  pushl $0
  101e3b:	6a 00                	push   $0x0
  pushl $22
  101e3d:	6a 16                	push   $0x16
  jmp __alltraps
  101e3f:	e9 b1 09 00 00       	jmp    1027f5 <__alltraps>

00101e44 <vector23>:
.globl vector23
vector23:
  pushl $0
  101e44:	6a 00                	push   $0x0
  pushl $23
  101e46:	6a 17                	push   $0x17
  jmp __alltraps
  101e48:	e9 a8 09 00 00       	jmp    1027f5 <__alltraps>

00101e4d <vector24>:
.globl vector24
vector24:
  pushl $0
  101e4d:	6a 00                	push   $0x0
  pushl $24
  101e4f:	6a 18                	push   $0x18
  jmp __alltraps
  101e51:	e9 9f 09 00 00       	jmp    1027f5 <__alltraps>

00101e56 <vector25>:
.globl vector25
vector25:
  pushl $0
  101e56:	6a 00                	push   $0x0
  pushl $25
  101e58:	6a 19                	push   $0x19
  jmp __alltraps
  101e5a:	e9 96 09 00 00       	jmp    1027f5 <__alltraps>

00101e5f <vector26>:
.globl vector26
vector26:
  pushl $0
  101e5f:	6a 00                	push   $0x0
  pushl $26
  101e61:	6a 1a                	push   $0x1a
  jmp __alltraps
  101e63:	e9 8d 09 00 00       	jmp    1027f5 <__alltraps>

00101e68 <vector27>:
.globl vector27
vector27:
  pushl $0
  101e68:	6a 00                	push   $0x0
  pushl $27
  101e6a:	6a 1b                	push   $0x1b
  jmp __alltraps
  101e6c:	e9 84 09 00 00       	jmp    1027f5 <__alltraps>

00101e71 <vector28>:
.globl vector28
vector28:
  pushl $0
  101e71:	6a 00                	push   $0x0
  pushl $28
  101e73:	6a 1c                	push   $0x1c
  jmp __alltraps
  101e75:	e9 7b 09 00 00       	jmp    1027f5 <__alltraps>

00101e7a <vector29>:
.globl vector29
vector29:
  pushl $0
  101e7a:	6a 00                	push   $0x0
  pushl $29
  101e7c:	6a 1d                	push   $0x1d
  jmp __alltraps
  101e7e:	e9 72 09 00 00       	jmp    1027f5 <__alltraps>

00101e83 <vector30>:
.globl vector30
vector30:
  pushl $0
  101e83:	6a 00                	push   $0x0
  pushl $30
  101e85:	6a 1e                	push   $0x1e
  jmp __alltraps
  101e87:	e9 69 09 00 00       	jmp    1027f5 <__alltraps>

00101e8c <vector31>:
.globl vector31
vector31:
  pushl $0
  101e8c:	6a 00                	push   $0x0
  pushl $31
  101e8e:	6a 1f                	push   $0x1f
  jmp __alltraps
  101e90:	e9 60 09 00 00       	jmp    1027f5 <__alltraps>

00101e95 <vector32>:
.globl vector32
vector32:
  pushl $0
  101e95:	6a 00                	push   $0x0
  pushl $32
  101e97:	6a 20                	push   $0x20
  jmp __alltraps
  101e99:	e9 57 09 00 00       	jmp    1027f5 <__alltraps>

00101e9e <vector33>:
.globl vector33
vector33:
  pushl $0
  101e9e:	6a 00                	push   $0x0
  pushl $33
  101ea0:	6a 21                	push   $0x21
  jmp __alltraps
  101ea2:	e9 4e 09 00 00       	jmp    1027f5 <__alltraps>

00101ea7 <vector34>:
.globl vector34
vector34:
  pushl $0
  101ea7:	6a 00                	push   $0x0
  pushl $34
  101ea9:	6a 22                	push   $0x22
  jmp __alltraps
  101eab:	e9 45 09 00 00       	jmp    1027f5 <__alltraps>

00101eb0 <vector35>:
.globl vector35
vector35:
  pushl $0
  101eb0:	6a 00                	push   $0x0
  pushl $35
  101eb2:	6a 23                	push   $0x23
  jmp __alltraps
  101eb4:	e9 3c 09 00 00       	jmp    1027f5 <__alltraps>

00101eb9 <vector36>:
.globl vector36
vector36:
  pushl $0
  101eb9:	6a 00                	push   $0x0
  pushl $36
  101ebb:	6a 24                	push   $0x24
  jmp __alltraps
  101ebd:	e9 33 09 00 00       	jmp    1027f5 <__alltraps>

00101ec2 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ec2:	6a 00                	push   $0x0
  pushl $37
  101ec4:	6a 25                	push   $0x25
  jmp __alltraps
  101ec6:	e9 2a 09 00 00       	jmp    1027f5 <__alltraps>

00101ecb <vector38>:
.globl vector38
vector38:
  pushl $0
  101ecb:	6a 00                	push   $0x0
  pushl $38
  101ecd:	6a 26                	push   $0x26
  jmp __alltraps
  101ecf:	e9 21 09 00 00       	jmp    1027f5 <__alltraps>

00101ed4 <vector39>:
.globl vector39
vector39:
  pushl $0
  101ed4:	6a 00                	push   $0x0
  pushl $39
  101ed6:	6a 27                	push   $0x27
  jmp __alltraps
  101ed8:	e9 18 09 00 00       	jmp    1027f5 <__alltraps>

00101edd <vector40>:
.globl vector40
vector40:
  pushl $0
  101edd:	6a 00                	push   $0x0
  pushl $40
  101edf:	6a 28                	push   $0x28
  jmp __alltraps
  101ee1:	e9 0f 09 00 00       	jmp    1027f5 <__alltraps>

00101ee6 <vector41>:
.globl vector41
vector41:
  pushl $0
  101ee6:	6a 00                	push   $0x0
  pushl $41
  101ee8:	6a 29                	push   $0x29
  jmp __alltraps
  101eea:	e9 06 09 00 00       	jmp    1027f5 <__alltraps>

00101eef <vector42>:
.globl vector42
vector42:
  pushl $0
  101eef:	6a 00                	push   $0x0
  pushl $42
  101ef1:	6a 2a                	push   $0x2a
  jmp __alltraps
  101ef3:	e9 fd 08 00 00       	jmp    1027f5 <__alltraps>

00101ef8 <vector43>:
.globl vector43
vector43:
  pushl $0
  101ef8:	6a 00                	push   $0x0
  pushl $43
  101efa:	6a 2b                	push   $0x2b
  jmp __alltraps
  101efc:	e9 f4 08 00 00       	jmp    1027f5 <__alltraps>

00101f01 <vector44>:
.globl vector44
vector44:
  pushl $0
  101f01:	6a 00                	push   $0x0
  pushl $44
  101f03:	6a 2c                	push   $0x2c
  jmp __alltraps
  101f05:	e9 eb 08 00 00       	jmp    1027f5 <__alltraps>

00101f0a <vector45>:
.globl vector45
vector45:
  pushl $0
  101f0a:	6a 00                	push   $0x0
  pushl $45
  101f0c:	6a 2d                	push   $0x2d
  jmp __alltraps
  101f0e:	e9 e2 08 00 00       	jmp    1027f5 <__alltraps>

00101f13 <vector46>:
.globl vector46
vector46:
  pushl $0
  101f13:	6a 00                	push   $0x0
  pushl $46
  101f15:	6a 2e                	push   $0x2e
  jmp __alltraps
  101f17:	e9 d9 08 00 00       	jmp    1027f5 <__alltraps>

00101f1c <vector47>:
.globl vector47
vector47:
  pushl $0
  101f1c:	6a 00                	push   $0x0
  pushl $47
  101f1e:	6a 2f                	push   $0x2f
  jmp __alltraps
  101f20:	e9 d0 08 00 00       	jmp    1027f5 <__alltraps>

00101f25 <vector48>:
.globl vector48
vector48:
  pushl $0
  101f25:	6a 00                	push   $0x0
  pushl $48
  101f27:	6a 30                	push   $0x30
  jmp __alltraps
  101f29:	e9 c7 08 00 00       	jmp    1027f5 <__alltraps>

00101f2e <vector49>:
.globl vector49
vector49:
  pushl $0
  101f2e:	6a 00                	push   $0x0
  pushl $49
  101f30:	6a 31                	push   $0x31
  jmp __alltraps
  101f32:	e9 be 08 00 00       	jmp    1027f5 <__alltraps>

00101f37 <vector50>:
.globl vector50
vector50:
  pushl $0
  101f37:	6a 00                	push   $0x0
  pushl $50
  101f39:	6a 32                	push   $0x32
  jmp __alltraps
  101f3b:	e9 b5 08 00 00       	jmp    1027f5 <__alltraps>

00101f40 <vector51>:
.globl vector51
vector51:
  pushl $0
  101f40:	6a 00                	push   $0x0
  pushl $51
  101f42:	6a 33                	push   $0x33
  jmp __alltraps
  101f44:	e9 ac 08 00 00       	jmp    1027f5 <__alltraps>

00101f49 <vector52>:
.globl vector52
vector52:
  pushl $0
  101f49:	6a 00                	push   $0x0
  pushl $52
  101f4b:	6a 34                	push   $0x34
  jmp __alltraps
  101f4d:	e9 a3 08 00 00       	jmp    1027f5 <__alltraps>

00101f52 <vector53>:
.globl vector53
vector53:
  pushl $0
  101f52:	6a 00                	push   $0x0
  pushl $53
  101f54:	6a 35                	push   $0x35
  jmp __alltraps
  101f56:	e9 9a 08 00 00       	jmp    1027f5 <__alltraps>

00101f5b <vector54>:
.globl vector54
vector54:
  pushl $0
  101f5b:	6a 00                	push   $0x0
  pushl $54
  101f5d:	6a 36                	push   $0x36
  jmp __alltraps
  101f5f:	e9 91 08 00 00       	jmp    1027f5 <__alltraps>

00101f64 <vector55>:
.globl vector55
vector55:
  pushl $0
  101f64:	6a 00                	push   $0x0
  pushl $55
  101f66:	6a 37                	push   $0x37
  jmp __alltraps
  101f68:	e9 88 08 00 00       	jmp    1027f5 <__alltraps>

00101f6d <vector56>:
.globl vector56
vector56:
  pushl $0
  101f6d:	6a 00                	push   $0x0
  pushl $56
  101f6f:	6a 38                	push   $0x38
  jmp __alltraps
  101f71:	e9 7f 08 00 00       	jmp    1027f5 <__alltraps>

00101f76 <vector57>:
.globl vector57
vector57:
  pushl $0
  101f76:	6a 00                	push   $0x0
  pushl $57
  101f78:	6a 39                	push   $0x39
  jmp __alltraps
  101f7a:	e9 76 08 00 00       	jmp    1027f5 <__alltraps>

00101f7f <vector58>:
.globl vector58
vector58:
  pushl $0
  101f7f:	6a 00                	push   $0x0
  pushl $58
  101f81:	6a 3a                	push   $0x3a
  jmp __alltraps
  101f83:	e9 6d 08 00 00       	jmp    1027f5 <__alltraps>

00101f88 <vector59>:
.globl vector59
vector59:
  pushl $0
  101f88:	6a 00                	push   $0x0
  pushl $59
  101f8a:	6a 3b                	push   $0x3b
  jmp __alltraps
  101f8c:	e9 64 08 00 00       	jmp    1027f5 <__alltraps>

00101f91 <vector60>:
.globl vector60
vector60:
  pushl $0
  101f91:	6a 00                	push   $0x0
  pushl $60
  101f93:	6a 3c                	push   $0x3c
  jmp __alltraps
  101f95:	e9 5b 08 00 00       	jmp    1027f5 <__alltraps>

00101f9a <vector61>:
.globl vector61
vector61:
  pushl $0
  101f9a:	6a 00                	push   $0x0
  pushl $61
  101f9c:	6a 3d                	push   $0x3d
  jmp __alltraps
  101f9e:	e9 52 08 00 00       	jmp    1027f5 <__alltraps>

00101fa3 <vector62>:
.globl vector62
vector62:
  pushl $0
  101fa3:	6a 00                	push   $0x0
  pushl $62
  101fa5:	6a 3e                	push   $0x3e
  jmp __alltraps
  101fa7:	e9 49 08 00 00       	jmp    1027f5 <__alltraps>

00101fac <vector63>:
.globl vector63
vector63:
  pushl $0
  101fac:	6a 00                	push   $0x0
  pushl $63
  101fae:	6a 3f                	push   $0x3f
  jmp __alltraps
  101fb0:	e9 40 08 00 00       	jmp    1027f5 <__alltraps>

00101fb5 <vector64>:
.globl vector64
vector64:
  pushl $0
  101fb5:	6a 00                	push   $0x0
  pushl $64
  101fb7:	6a 40                	push   $0x40
  jmp __alltraps
  101fb9:	e9 37 08 00 00       	jmp    1027f5 <__alltraps>

00101fbe <vector65>:
.globl vector65
vector65:
  pushl $0
  101fbe:	6a 00                	push   $0x0
  pushl $65
  101fc0:	6a 41                	push   $0x41
  jmp __alltraps
  101fc2:	e9 2e 08 00 00       	jmp    1027f5 <__alltraps>

00101fc7 <vector66>:
.globl vector66
vector66:
  pushl $0
  101fc7:	6a 00                	push   $0x0
  pushl $66
  101fc9:	6a 42                	push   $0x42
  jmp __alltraps
  101fcb:	e9 25 08 00 00       	jmp    1027f5 <__alltraps>

00101fd0 <vector67>:
.globl vector67
vector67:
  pushl $0
  101fd0:	6a 00                	push   $0x0
  pushl $67
  101fd2:	6a 43                	push   $0x43
  jmp __alltraps
  101fd4:	e9 1c 08 00 00       	jmp    1027f5 <__alltraps>

00101fd9 <vector68>:
.globl vector68
vector68:
  pushl $0
  101fd9:	6a 00                	push   $0x0
  pushl $68
  101fdb:	6a 44                	push   $0x44
  jmp __alltraps
  101fdd:	e9 13 08 00 00       	jmp    1027f5 <__alltraps>

00101fe2 <vector69>:
.globl vector69
vector69:
  pushl $0
  101fe2:	6a 00                	push   $0x0
  pushl $69
  101fe4:	6a 45                	push   $0x45
  jmp __alltraps
  101fe6:	e9 0a 08 00 00       	jmp    1027f5 <__alltraps>

00101feb <vector70>:
.globl vector70
vector70:
  pushl $0
  101feb:	6a 00                	push   $0x0
  pushl $70
  101fed:	6a 46                	push   $0x46
  jmp __alltraps
  101fef:	e9 01 08 00 00       	jmp    1027f5 <__alltraps>

00101ff4 <vector71>:
.globl vector71
vector71:
  pushl $0
  101ff4:	6a 00                	push   $0x0
  pushl $71
  101ff6:	6a 47                	push   $0x47
  jmp __alltraps
  101ff8:	e9 f8 07 00 00       	jmp    1027f5 <__alltraps>

00101ffd <vector72>:
.globl vector72
vector72:
  pushl $0
  101ffd:	6a 00                	push   $0x0
  pushl $72
  101fff:	6a 48                	push   $0x48
  jmp __alltraps
  102001:	e9 ef 07 00 00       	jmp    1027f5 <__alltraps>

00102006 <vector73>:
.globl vector73
vector73:
  pushl $0
  102006:	6a 00                	push   $0x0
  pushl $73
  102008:	6a 49                	push   $0x49
  jmp __alltraps
  10200a:	e9 e6 07 00 00       	jmp    1027f5 <__alltraps>

0010200f <vector74>:
.globl vector74
vector74:
  pushl $0
  10200f:	6a 00                	push   $0x0
  pushl $74
  102011:	6a 4a                	push   $0x4a
  jmp __alltraps
  102013:	e9 dd 07 00 00       	jmp    1027f5 <__alltraps>

00102018 <vector75>:
.globl vector75
vector75:
  pushl $0
  102018:	6a 00                	push   $0x0
  pushl $75
  10201a:	6a 4b                	push   $0x4b
  jmp __alltraps
  10201c:	e9 d4 07 00 00       	jmp    1027f5 <__alltraps>

00102021 <vector76>:
.globl vector76
vector76:
  pushl $0
  102021:	6a 00                	push   $0x0
  pushl $76
  102023:	6a 4c                	push   $0x4c
  jmp __alltraps
  102025:	e9 cb 07 00 00       	jmp    1027f5 <__alltraps>

0010202a <vector77>:
.globl vector77
vector77:
  pushl $0
  10202a:	6a 00                	push   $0x0
  pushl $77
  10202c:	6a 4d                	push   $0x4d
  jmp __alltraps
  10202e:	e9 c2 07 00 00       	jmp    1027f5 <__alltraps>

00102033 <vector78>:
.globl vector78
vector78:
  pushl $0
  102033:	6a 00                	push   $0x0
  pushl $78
  102035:	6a 4e                	push   $0x4e
  jmp __alltraps
  102037:	e9 b9 07 00 00       	jmp    1027f5 <__alltraps>

0010203c <vector79>:
.globl vector79
vector79:
  pushl $0
  10203c:	6a 00                	push   $0x0
  pushl $79
  10203e:	6a 4f                	push   $0x4f
  jmp __alltraps
  102040:	e9 b0 07 00 00       	jmp    1027f5 <__alltraps>

00102045 <vector80>:
.globl vector80
vector80:
  pushl $0
  102045:	6a 00                	push   $0x0
  pushl $80
  102047:	6a 50                	push   $0x50
  jmp __alltraps
  102049:	e9 a7 07 00 00       	jmp    1027f5 <__alltraps>

0010204e <vector81>:
.globl vector81
vector81:
  pushl $0
  10204e:	6a 00                	push   $0x0
  pushl $81
  102050:	6a 51                	push   $0x51
  jmp __alltraps
  102052:	e9 9e 07 00 00       	jmp    1027f5 <__alltraps>

00102057 <vector82>:
.globl vector82
vector82:
  pushl $0
  102057:	6a 00                	push   $0x0
  pushl $82
  102059:	6a 52                	push   $0x52
  jmp __alltraps
  10205b:	e9 95 07 00 00       	jmp    1027f5 <__alltraps>

00102060 <vector83>:
.globl vector83
vector83:
  pushl $0
  102060:	6a 00                	push   $0x0
  pushl $83
  102062:	6a 53                	push   $0x53
  jmp __alltraps
  102064:	e9 8c 07 00 00       	jmp    1027f5 <__alltraps>

00102069 <vector84>:
.globl vector84
vector84:
  pushl $0
  102069:	6a 00                	push   $0x0
  pushl $84
  10206b:	6a 54                	push   $0x54
  jmp __alltraps
  10206d:	e9 83 07 00 00       	jmp    1027f5 <__alltraps>

00102072 <vector85>:
.globl vector85
vector85:
  pushl $0
  102072:	6a 00                	push   $0x0
  pushl $85
  102074:	6a 55                	push   $0x55
  jmp __alltraps
  102076:	e9 7a 07 00 00       	jmp    1027f5 <__alltraps>

0010207b <vector86>:
.globl vector86
vector86:
  pushl $0
  10207b:	6a 00                	push   $0x0
  pushl $86
  10207d:	6a 56                	push   $0x56
  jmp __alltraps
  10207f:	e9 71 07 00 00       	jmp    1027f5 <__alltraps>

00102084 <vector87>:
.globl vector87
vector87:
  pushl $0
  102084:	6a 00                	push   $0x0
  pushl $87
  102086:	6a 57                	push   $0x57
  jmp __alltraps
  102088:	e9 68 07 00 00       	jmp    1027f5 <__alltraps>

0010208d <vector88>:
.globl vector88
vector88:
  pushl $0
  10208d:	6a 00                	push   $0x0
  pushl $88
  10208f:	6a 58                	push   $0x58
  jmp __alltraps
  102091:	e9 5f 07 00 00       	jmp    1027f5 <__alltraps>

00102096 <vector89>:
.globl vector89
vector89:
  pushl $0
  102096:	6a 00                	push   $0x0
  pushl $89
  102098:	6a 59                	push   $0x59
  jmp __alltraps
  10209a:	e9 56 07 00 00       	jmp    1027f5 <__alltraps>

0010209f <vector90>:
.globl vector90
vector90:
  pushl $0
  10209f:	6a 00                	push   $0x0
  pushl $90
  1020a1:	6a 5a                	push   $0x5a
  jmp __alltraps
  1020a3:	e9 4d 07 00 00       	jmp    1027f5 <__alltraps>

001020a8 <vector91>:
.globl vector91
vector91:
  pushl $0
  1020a8:	6a 00                	push   $0x0
  pushl $91
  1020aa:	6a 5b                	push   $0x5b
  jmp __alltraps
  1020ac:	e9 44 07 00 00       	jmp    1027f5 <__alltraps>

001020b1 <vector92>:
.globl vector92
vector92:
  pushl $0
  1020b1:	6a 00                	push   $0x0
  pushl $92
  1020b3:	6a 5c                	push   $0x5c
  jmp __alltraps
  1020b5:	e9 3b 07 00 00       	jmp    1027f5 <__alltraps>

001020ba <vector93>:
.globl vector93
vector93:
  pushl $0
  1020ba:	6a 00                	push   $0x0
  pushl $93
  1020bc:	6a 5d                	push   $0x5d
  jmp __alltraps
  1020be:	e9 32 07 00 00       	jmp    1027f5 <__alltraps>

001020c3 <vector94>:
.globl vector94
vector94:
  pushl $0
  1020c3:	6a 00                	push   $0x0
  pushl $94
  1020c5:	6a 5e                	push   $0x5e
  jmp __alltraps
  1020c7:	e9 29 07 00 00       	jmp    1027f5 <__alltraps>

001020cc <vector95>:
.globl vector95
vector95:
  pushl $0
  1020cc:	6a 00                	push   $0x0
  pushl $95
  1020ce:	6a 5f                	push   $0x5f
  jmp __alltraps
  1020d0:	e9 20 07 00 00       	jmp    1027f5 <__alltraps>

001020d5 <vector96>:
.globl vector96
vector96:
  pushl $0
  1020d5:	6a 00                	push   $0x0
  pushl $96
  1020d7:	6a 60                	push   $0x60
  jmp __alltraps
  1020d9:	e9 17 07 00 00       	jmp    1027f5 <__alltraps>

001020de <vector97>:
.globl vector97
vector97:
  pushl $0
  1020de:	6a 00                	push   $0x0
  pushl $97
  1020e0:	6a 61                	push   $0x61
  jmp __alltraps
  1020e2:	e9 0e 07 00 00       	jmp    1027f5 <__alltraps>

001020e7 <vector98>:
.globl vector98
vector98:
  pushl $0
  1020e7:	6a 00                	push   $0x0
  pushl $98
  1020e9:	6a 62                	push   $0x62
  jmp __alltraps
  1020eb:	e9 05 07 00 00       	jmp    1027f5 <__alltraps>

001020f0 <vector99>:
.globl vector99
vector99:
  pushl $0
  1020f0:	6a 00                	push   $0x0
  pushl $99
  1020f2:	6a 63                	push   $0x63
  jmp __alltraps
  1020f4:	e9 fc 06 00 00       	jmp    1027f5 <__alltraps>

001020f9 <vector100>:
.globl vector100
vector100:
  pushl $0
  1020f9:	6a 00                	push   $0x0
  pushl $100
  1020fb:	6a 64                	push   $0x64
  jmp __alltraps
  1020fd:	e9 f3 06 00 00       	jmp    1027f5 <__alltraps>

00102102 <vector101>:
.globl vector101
vector101:
  pushl $0
  102102:	6a 00                	push   $0x0
  pushl $101
  102104:	6a 65                	push   $0x65
  jmp __alltraps
  102106:	e9 ea 06 00 00       	jmp    1027f5 <__alltraps>

0010210b <vector102>:
.globl vector102
vector102:
  pushl $0
  10210b:	6a 00                	push   $0x0
  pushl $102
  10210d:	6a 66                	push   $0x66
  jmp __alltraps
  10210f:	e9 e1 06 00 00       	jmp    1027f5 <__alltraps>

00102114 <vector103>:
.globl vector103
vector103:
  pushl $0
  102114:	6a 00                	push   $0x0
  pushl $103
  102116:	6a 67                	push   $0x67
  jmp __alltraps
  102118:	e9 d8 06 00 00       	jmp    1027f5 <__alltraps>

0010211d <vector104>:
.globl vector104
vector104:
  pushl $0
  10211d:	6a 00                	push   $0x0
  pushl $104
  10211f:	6a 68                	push   $0x68
  jmp __alltraps
  102121:	e9 cf 06 00 00       	jmp    1027f5 <__alltraps>

00102126 <vector105>:
.globl vector105
vector105:
  pushl $0
  102126:	6a 00                	push   $0x0
  pushl $105
  102128:	6a 69                	push   $0x69
  jmp __alltraps
  10212a:	e9 c6 06 00 00       	jmp    1027f5 <__alltraps>

0010212f <vector106>:
.globl vector106
vector106:
  pushl $0
  10212f:	6a 00                	push   $0x0
  pushl $106
  102131:	6a 6a                	push   $0x6a
  jmp __alltraps
  102133:	e9 bd 06 00 00       	jmp    1027f5 <__alltraps>

00102138 <vector107>:
.globl vector107
vector107:
  pushl $0
  102138:	6a 00                	push   $0x0
  pushl $107
  10213a:	6a 6b                	push   $0x6b
  jmp __alltraps
  10213c:	e9 b4 06 00 00       	jmp    1027f5 <__alltraps>

00102141 <vector108>:
.globl vector108
vector108:
  pushl $0
  102141:	6a 00                	push   $0x0
  pushl $108
  102143:	6a 6c                	push   $0x6c
  jmp __alltraps
  102145:	e9 ab 06 00 00       	jmp    1027f5 <__alltraps>

0010214a <vector109>:
.globl vector109
vector109:
  pushl $0
  10214a:	6a 00                	push   $0x0
  pushl $109
  10214c:	6a 6d                	push   $0x6d
  jmp __alltraps
  10214e:	e9 a2 06 00 00       	jmp    1027f5 <__alltraps>

00102153 <vector110>:
.globl vector110
vector110:
  pushl $0
  102153:	6a 00                	push   $0x0
  pushl $110
  102155:	6a 6e                	push   $0x6e
  jmp __alltraps
  102157:	e9 99 06 00 00       	jmp    1027f5 <__alltraps>

0010215c <vector111>:
.globl vector111
vector111:
  pushl $0
  10215c:	6a 00                	push   $0x0
  pushl $111
  10215e:	6a 6f                	push   $0x6f
  jmp __alltraps
  102160:	e9 90 06 00 00       	jmp    1027f5 <__alltraps>

00102165 <vector112>:
.globl vector112
vector112:
  pushl $0
  102165:	6a 00                	push   $0x0
  pushl $112
  102167:	6a 70                	push   $0x70
  jmp __alltraps
  102169:	e9 87 06 00 00       	jmp    1027f5 <__alltraps>

0010216e <vector113>:
.globl vector113
vector113:
  pushl $0
  10216e:	6a 00                	push   $0x0
  pushl $113
  102170:	6a 71                	push   $0x71
  jmp __alltraps
  102172:	e9 7e 06 00 00       	jmp    1027f5 <__alltraps>

00102177 <vector114>:
.globl vector114
vector114:
  pushl $0
  102177:	6a 00                	push   $0x0
  pushl $114
  102179:	6a 72                	push   $0x72
  jmp __alltraps
  10217b:	e9 75 06 00 00       	jmp    1027f5 <__alltraps>

00102180 <vector115>:
.globl vector115
vector115:
  pushl $0
  102180:	6a 00                	push   $0x0
  pushl $115
  102182:	6a 73                	push   $0x73
  jmp __alltraps
  102184:	e9 6c 06 00 00       	jmp    1027f5 <__alltraps>

00102189 <vector116>:
.globl vector116
vector116:
  pushl $0
  102189:	6a 00                	push   $0x0
  pushl $116
  10218b:	6a 74                	push   $0x74
  jmp __alltraps
  10218d:	e9 63 06 00 00       	jmp    1027f5 <__alltraps>

00102192 <vector117>:
.globl vector117
vector117:
  pushl $0
  102192:	6a 00                	push   $0x0
  pushl $117
  102194:	6a 75                	push   $0x75
  jmp __alltraps
  102196:	e9 5a 06 00 00       	jmp    1027f5 <__alltraps>

0010219b <vector118>:
.globl vector118
vector118:
  pushl $0
  10219b:	6a 00                	push   $0x0
  pushl $118
  10219d:	6a 76                	push   $0x76
  jmp __alltraps
  10219f:	e9 51 06 00 00       	jmp    1027f5 <__alltraps>

001021a4 <vector119>:
.globl vector119
vector119:
  pushl $0
  1021a4:	6a 00                	push   $0x0
  pushl $119
  1021a6:	6a 77                	push   $0x77
  jmp __alltraps
  1021a8:	e9 48 06 00 00       	jmp    1027f5 <__alltraps>

001021ad <vector120>:
.globl vector120
vector120:
  pushl $0
  1021ad:	6a 00                	push   $0x0
  pushl $120
  1021af:	6a 78                	push   $0x78
  jmp __alltraps
  1021b1:	e9 3f 06 00 00       	jmp    1027f5 <__alltraps>

001021b6 <vector121>:
.globl vector121
vector121:
  pushl $0
  1021b6:	6a 00                	push   $0x0
  pushl $121
  1021b8:	6a 79                	push   $0x79
  jmp __alltraps
  1021ba:	e9 36 06 00 00       	jmp    1027f5 <__alltraps>

001021bf <vector122>:
.globl vector122
vector122:
  pushl $0
  1021bf:	6a 00                	push   $0x0
  pushl $122
  1021c1:	6a 7a                	push   $0x7a
  jmp __alltraps
  1021c3:	e9 2d 06 00 00       	jmp    1027f5 <__alltraps>

001021c8 <vector123>:
.globl vector123
vector123:
  pushl $0
  1021c8:	6a 00                	push   $0x0
  pushl $123
  1021ca:	6a 7b                	push   $0x7b
  jmp __alltraps
  1021cc:	e9 24 06 00 00       	jmp    1027f5 <__alltraps>

001021d1 <vector124>:
.globl vector124
vector124:
  pushl $0
  1021d1:	6a 00                	push   $0x0
  pushl $124
  1021d3:	6a 7c                	push   $0x7c
  jmp __alltraps
  1021d5:	e9 1b 06 00 00       	jmp    1027f5 <__alltraps>

001021da <vector125>:
.globl vector125
vector125:
  pushl $0
  1021da:	6a 00                	push   $0x0
  pushl $125
  1021dc:	6a 7d                	push   $0x7d
  jmp __alltraps
  1021de:	e9 12 06 00 00       	jmp    1027f5 <__alltraps>

001021e3 <vector126>:
.globl vector126
vector126:
  pushl $0
  1021e3:	6a 00                	push   $0x0
  pushl $126
  1021e5:	6a 7e                	push   $0x7e
  jmp __alltraps
  1021e7:	e9 09 06 00 00       	jmp    1027f5 <__alltraps>

001021ec <vector127>:
.globl vector127
vector127:
  pushl $0
  1021ec:	6a 00                	push   $0x0
  pushl $127
  1021ee:	6a 7f                	push   $0x7f
  jmp __alltraps
  1021f0:	e9 00 06 00 00       	jmp    1027f5 <__alltraps>

001021f5 <vector128>:
.globl vector128
vector128:
  pushl $0
  1021f5:	6a 00                	push   $0x0
  pushl $128
  1021f7:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1021fc:	e9 f4 05 00 00       	jmp    1027f5 <__alltraps>

00102201 <vector129>:
.globl vector129
vector129:
  pushl $0
  102201:	6a 00                	push   $0x0
  pushl $129
  102203:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102208:	e9 e8 05 00 00       	jmp    1027f5 <__alltraps>

0010220d <vector130>:
.globl vector130
vector130:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $130
  10220f:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102214:	e9 dc 05 00 00       	jmp    1027f5 <__alltraps>

00102219 <vector131>:
.globl vector131
vector131:
  pushl $0
  102219:	6a 00                	push   $0x0
  pushl $131
  10221b:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  102220:	e9 d0 05 00 00       	jmp    1027f5 <__alltraps>

00102225 <vector132>:
.globl vector132
vector132:
  pushl $0
  102225:	6a 00                	push   $0x0
  pushl $132
  102227:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10222c:	e9 c4 05 00 00       	jmp    1027f5 <__alltraps>

00102231 <vector133>:
.globl vector133
vector133:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $133
  102233:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102238:	e9 b8 05 00 00       	jmp    1027f5 <__alltraps>

0010223d <vector134>:
.globl vector134
vector134:
  pushl $0
  10223d:	6a 00                	push   $0x0
  pushl $134
  10223f:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102244:	e9 ac 05 00 00       	jmp    1027f5 <__alltraps>

00102249 <vector135>:
.globl vector135
vector135:
  pushl $0
  102249:	6a 00                	push   $0x0
  pushl $135
  10224b:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  102250:	e9 a0 05 00 00       	jmp    1027f5 <__alltraps>

00102255 <vector136>:
.globl vector136
vector136:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $136
  102257:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10225c:	e9 94 05 00 00       	jmp    1027f5 <__alltraps>

00102261 <vector137>:
.globl vector137
vector137:
  pushl $0
  102261:	6a 00                	push   $0x0
  pushl $137
  102263:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102268:	e9 88 05 00 00       	jmp    1027f5 <__alltraps>

0010226d <vector138>:
.globl vector138
vector138:
  pushl $0
  10226d:	6a 00                	push   $0x0
  pushl $138
  10226f:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  102274:	e9 7c 05 00 00       	jmp    1027f5 <__alltraps>

00102279 <vector139>:
.globl vector139
vector139:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $139
  10227b:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  102280:	e9 70 05 00 00       	jmp    1027f5 <__alltraps>

00102285 <vector140>:
.globl vector140
vector140:
  pushl $0
  102285:	6a 00                	push   $0x0
  pushl $140
  102287:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  10228c:	e9 64 05 00 00       	jmp    1027f5 <__alltraps>

00102291 <vector141>:
.globl vector141
vector141:
  pushl $0
  102291:	6a 00                	push   $0x0
  pushl $141
  102293:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102298:	e9 58 05 00 00       	jmp    1027f5 <__alltraps>

0010229d <vector142>:
.globl vector142
vector142:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $142
  10229f:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1022a4:	e9 4c 05 00 00       	jmp    1027f5 <__alltraps>

001022a9 <vector143>:
.globl vector143
vector143:
  pushl $0
  1022a9:	6a 00                	push   $0x0
  pushl $143
  1022ab:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1022b0:	e9 40 05 00 00       	jmp    1027f5 <__alltraps>

001022b5 <vector144>:
.globl vector144
vector144:
  pushl $0
  1022b5:	6a 00                	push   $0x0
  pushl $144
  1022b7:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1022bc:	e9 34 05 00 00       	jmp    1027f5 <__alltraps>

001022c1 <vector145>:
.globl vector145
vector145:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $145
  1022c3:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1022c8:	e9 28 05 00 00       	jmp    1027f5 <__alltraps>

001022cd <vector146>:
.globl vector146
vector146:
  pushl $0
  1022cd:	6a 00                	push   $0x0
  pushl $146
  1022cf:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  1022d4:	e9 1c 05 00 00       	jmp    1027f5 <__alltraps>

001022d9 <vector147>:
.globl vector147
vector147:
  pushl $0
  1022d9:	6a 00                	push   $0x0
  pushl $147
  1022db:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  1022e0:	e9 10 05 00 00       	jmp    1027f5 <__alltraps>

001022e5 <vector148>:
.globl vector148
vector148:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $148
  1022e7:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1022ec:	e9 04 05 00 00       	jmp    1027f5 <__alltraps>

001022f1 <vector149>:
.globl vector149
vector149:
  pushl $0
  1022f1:	6a 00                	push   $0x0
  pushl $149
  1022f3:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1022f8:	e9 f8 04 00 00       	jmp    1027f5 <__alltraps>

001022fd <vector150>:
.globl vector150
vector150:
  pushl $0
  1022fd:	6a 00                	push   $0x0
  pushl $150
  1022ff:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102304:	e9 ec 04 00 00       	jmp    1027f5 <__alltraps>

00102309 <vector151>:
.globl vector151
vector151:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $151
  10230b:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  102310:	e9 e0 04 00 00       	jmp    1027f5 <__alltraps>

00102315 <vector152>:
.globl vector152
vector152:
  pushl $0
  102315:	6a 00                	push   $0x0
  pushl $152
  102317:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10231c:	e9 d4 04 00 00       	jmp    1027f5 <__alltraps>

00102321 <vector153>:
.globl vector153
vector153:
  pushl $0
  102321:	6a 00                	push   $0x0
  pushl $153
  102323:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102328:	e9 c8 04 00 00       	jmp    1027f5 <__alltraps>

0010232d <vector154>:
.globl vector154
vector154:
  pushl $0
  10232d:	6a 00                	push   $0x0
  pushl $154
  10232f:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102334:	e9 bc 04 00 00       	jmp    1027f5 <__alltraps>

00102339 <vector155>:
.globl vector155
vector155:
  pushl $0
  102339:	6a 00                	push   $0x0
  pushl $155
  10233b:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  102340:	e9 b0 04 00 00       	jmp    1027f5 <__alltraps>

00102345 <vector156>:
.globl vector156
vector156:
  pushl $0
  102345:	6a 00                	push   $0x0
  pushl $156
  102347:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10234c:	e9 a4 04 00 00       	jmp    1027f5 <__alltraps>

00102351 <vector157>:
.globl vector157
vector157:
  pushl $0
  102351:	6a 00                	push   $0x0
  pushl $157
  102353:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102358:	e9 98 04 00 00       	jmp    1027f5 <__alltraps>

0010235d <vector158>:
.globl vector158
vector158:
  pushl $0
  10235d:	6a 00                	push   $0x0
  pushl $158
  10235f:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102364:	e9 8c 04 00 00       	jmp    1027f5 <__alltraps>

00102369 <vector159>:
.globl vector159
vector159:
  pushl $0
  102369:	6a 00                	push   $0x0
  pushl $159
  10236b:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  102370:	e9 80 04 00 00       	jmp    1027f5 <__alltraps>

00102375 <vector160>:
.globl vector160
vector160:
  pushl $0
  102375:	6a 00                	push   $0x0
  pushl $160
  102377:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  10237c:	e9 74 04 00 00       	jmp    1027f5 <__alltraps>

00102381 <vector161>:
.globl vector161
vector161:
  pushl $0
  102381:	6a 00                	push   $0x0
  pushl $161
  102383:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102388:	e9 68 04 00 00       	jmp    1027f5 <__alltraps>

0010238d <vector162>:
.globl vector162
vector162:
  pushl $0
  10238d:	6a 00                	push   $0x0
  pushl $162
  10238f:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  102394:	e9 5c 04 00 00       	jmp    1027f5 <__alltraps>

00102399 <vector163>:
.globl vector163
vector163:
  pushl $0
  102399:	6a 00                	push   $0x0
  pushl $163
  10239b:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1023a0:	e9 50 04 00 00       	jmp    1027f5 <__alltraps>

001023a5 <vector164>:
.globl vector164
vector164:
  pushl $0
  1023a5:	6a 00                	push   $0x0
  pushl $164
  1023a7:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1023ac:	e9 44 04 00 00       	jmp    1027f5 <__alltraps>

001023b1 <vector165>:
.globl vector165
vector165:
  pushl $0
  1023b1:	6a 00                	push   $0x0
  pushl $165
  1023b3:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1023b8:	e9 38 04 00 00       	jmp    1027f5 <__alltraps>

001023bd <vector166>:
.globl vector166
vector166:
  pushl $0
  1023bd:	6a 00                	push   $0x0
  pushl $166
  1023bf:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1023c4:	e9 2c 04 00 00       	jmp    1027f5 <__alltraps>

001023c9 <vector167>:
.globl vector167
vector167:
  pushl $0
  1023c9:	6a 00                	push   $0x0
  pushl $167
  1023cb:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1023d0:	e9 20 04 00 00       	jmp    1027f5 <__alltraps>

001023d5 <vector168>:
.globl vector168
vector168:
  pushl $0
  1023d5:	6a 00                	push   $0x0
  pushl $168
  1023d7:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  1023dc:	e9 14 04 00 00       	jmp    1027f5 <__alltraps>

001023e1 <vector169>:
.globl vector169
vector169:
  pushl $0
  1023e1:	6a 00                	push   $0x0
  pushl $169
  1023e3:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1023e8:	e9 08 04 00 00       	jmp    1027f5 <__alltraps>

001023ed <vector170>:
.globl vector170
vector170:
  pushl $0
  1023ed:	6a 00                	push   $0x0
  pushl $170
  1023ef:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1023f4:	e9 fc 03 00 00       	jmp    1027f5 <__alltraps>

001023f9 <vector171>:
.globl vector171
vector171:
  pushl $0
  1023f9:	6a 00                	push   $0x0
  pushl $171
  1023fb:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  102400:	e9 f0 03 00 00       	jmp    1027f5 <__alltraps>

00102405 <vector172>:
.globl vector172
vector172:
  pushl $0
  102405:	6a 00                	push   $0x0
  pushl $172
  102407:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10240c:	e9 e4 03 00 00       	jmp    1027f5 <__alltraps>

00102411 <vector173>:
.globl vector173
vector173:
  pushl $0
  102411:	6a 00                	push   $0x0
  pushl $173
  102413:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102418:	e9 d8 03 00 00       	jmp    1027f5 <__alltraps>

0010241d <vector174>:
.globl vector174
vector174:
  pushl $0
  10241d:	6a 00                	push   $0x0
  pushl $174
  10241f:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102424:	e9 cc 03 00 00       	jmp    1027f5 <__alltraps>

00102429 <vector175>:
.globl vector175
vector175:
  pushl $0
  102429:	6a 00                	push   $0x0
  pushl $175
  10242b:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  102430:	e9 c0 03 00 00       	jmp    1027f5 <__alltraps>

00102435 <vector176>:
.globl vector176
vector176:
  pushl $0
  102435:	6a 00                	push   $0x0
  pushl $176
  102437:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10243c:	e9 b4 03 00 00       	jmp    1027f5 <__alltraps>

00102441 <vector177>:
.globl vector177
vector177:
  pushl $0
  102441:	6a 00                	push   $0x0
  pushl $177
  102443:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102448:	e9 a8 03 00 00       	jmp    1027f5 <__alltraps>

0010244d <vector178>:
.globl vector178
vector178:
  pushl $0
  10244d:	6a 00                	push   $0x0
  pushl $178
  10244f:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102454:	e9 9c 03 00 00       	jmp    1027f5 <__alltraps>

00102459 <vector179>:
.globl vector179
vector179:
  pushl $0
  102459:	6a 00                	push   $0x0
  pushl $179
  10245b:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  102460:	e9 90 03 00 00       	jmp    1027f5 <__alltraps>

00102465 <vector180>:
.globl vector180
vector180:
  pushl $0
  102465:	6a 00                	push   $0x0
  pushl $180
  102467:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10246c:	e9 84 03 00 00       	jmp    1027f5 <__alltraps>

00102471 <vector181>:
.globl vector181
vector181:
  pushl $0
  102471:	6a 00                	push   $0x0
  pushl $181
  102473:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102478:	e9 78 03 00 00       	jmp    1027f5 <__alltraps>

0010247d <vector182>:
.globl vector182
vector182:
  pushl $0
  10247d:	6a 00                	push   $0x0
  pushl $182
  10247f:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  102484:	e9 6c 03 00 00       	jmp    1027f5 <__alltraps>

00102489 <vector183>:
.globl vector183
vector183:
  pushl $0
  102489:	6a 00                	push   $0x0
  pushl $183
  10248b:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  102490:	e9 60 03 00 00       	jmp    1027f5 <__alltraps>

00102495 <vector184>:
.globl vector184
vector184:
  pushl $0
  102495:	6a 00                	push   $0x0
  pushl $184
  102497:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  10249c:	e9 54 03 00 00       	jmp    1027f5 <__alltraps>

001024a1 <vector185>:
.globl vector185
vector185:
  pushl $0
  1024a1:	6a 00                	push   $0x0
  pushl $185
  1024a3:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1024a8:	e9 48 03 00 00       	jmp    1027f5 <__alltraps>

001024ad <vector186>:
.globl vector186
vector186:
  pushl $0
  1024ad:	6a 00                	push   $0x0
  pushl $186
  1024af:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1024b4:	e9 3c 03 00 00       	jmp    1027f5 <__alltraps>

001024b9 <vector187>:
.globl vector187
vector187:
  pushl $0
  1024b9:	6a 00                	push   $0x0
  pushl $187
  1024bb:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1024c0:	e9 30 03 00 00       	jmp    1027f5 <__alltraps>

001024c5 <vector188>:
.globl vector188
vector188:
  pushl $0
  1024c5:	6a 00                	push   $0x0
  pushl $188
  1024c7:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1024cc:	e9 24 03 00 00       	jmp    1027f5 <__alltraps>

001024d1 <vector189>:
.globl vector189
vector189:
  pushl $0
  1024d1:	6a 00                	push   $0x0
  pushl $189
  1024d3:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  1024d8:	e9 18 03 00 00       	jmp    1027f5 <__alltraps>

001024dd <vector190>:
.globl vector190
vector190:
  pushl $0
  1024dd:	6a 00                	push   $0x0
  pushl $190
  1024df:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  1024e4:	e9 0c 03 00 00       	jmp    1027f5 <__alltraps>

001024e9 <vector191>:
.globl vector191
vector191:
  pushl $0
  1024e9:	6a 00                	push   $0x0
  pushl $191
  1024eb:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1024f0:	e9 00 03 00 00       	jmp    1027f5 <__alltraps>

001024f5 <vector192>:
.globl vector192
vector192:
  pushl $0
  1024f5:	6a 00                	push   $0x0
  pushl $192
  1024f7:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1024fc:	e9 f4 02 00 00       	jmp    1027f5 <__alltraps>

00102501 <vector193>:
.globl vector193
vector193:
  pushl $0
  102501:	6a 00                	push   $0x0
  pushl $193
  102503:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102508:	e9 e8 02 00 00       	jmp    1027f5 <__alltraps>

0010250d <vector194>:
.globl vector194
vector194:
  pushl $0
  10250d:	6a 00                	push   $0x0
  pushl $194
  10250f:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102514:	e9 dc 02 00 00       	jmp    1027f5 <__alltraps>

00102519 <vector195>:
.globl vector195
vector195:
  pushl $0
  102519:	6a 00                	push   $0x0
  pushl $195
  10251b:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  102520:	e9 d0 02 00 00       	jmp    1027f5 <__alltraps>

00102525 <vector196>:
.globl vector196
vector196:
  pushl $0
  102525:	6a 00                	push   $0x0
  pushl $196
  102527:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10252c:	e9 c4 02 00 00       	jmp    1027f5 <__alltraps>

00102531 <vector197>:
.globl vector197
vector197:
  pushl $0
  102531:	6a 00                	push   $0x0
  pushl $197
  102533:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102538:	e9 b8 02 00 00       	jmp    1027f5 <__alltraps>

0010253d <vector198>:
.globl vector198
vector198:
  pushl $0
  10253d:	6a 00                	push   $0x0
  pushl $198
  10253f:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102544:	e9 ac 02 00 00       	jmp    1027f5 <__alltraps>

00102549 <vector199>:
.globl vector199
vector199:
  pushl $0
  102549:	6a 00                	push   $0x0
  pushl $199
  10254b:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  102550:	e9 a0 02 00 00       	jmp    1027f5 <__alltraps>

00102555 <vector200>:
.globl vector200
vector200:
  pushl $0
  102555:	6a 00                	push   $0x0
  pushl $200
  102557:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10255c:	e9 94 02 00 00       	jmp    1027f5 <__alltraps>

00102561 <vector201>:
.globl vector201
vector201:
  pushl $0
  102561:	6a 00                	push   $0x0
  pushl $201
  102563:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102568:	e9 88 02 00 00       	jmp    1027f5 <__alltraps>

0010256d <vector202>:
.globl vector202
vector202:
  pushl $0
  10256d:	6a 00                	push   $0x0
  pushl $202
  10256f:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  102574:	e9 7c 02 00 00       	jmp    1027f5 <__alltraps>

00102579 <vector203>:
.globl vector203
vector203:
  pushl $0
  102579:	6a 00                	push   $0x0
  pushl $203
  10257b:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  102580:	e9 70 02 00 00       	jmp    1027f5 <__alltraps>

00102585 <vector204>:
.globl vector204
vector204:
  pushl $0
  102585:	6a 00                	push   $0x0
  pushl $204
  102587:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  10258c:	e9 64 02 00 00       	jmp    1027f5 <__alltraps>

00102591 <vector205>:
.globl vector205
vector205:
  pushl $0
  102591:	6a 00                	push   $0x0
  pushl $205
  102593:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102598:	e9 58 02 00 00       	jmp    1027f5 <__alltraps>

0010259d <vector206>:
.globl vector206
vector206:
  pushl $0
  10259d:	6a 00                	push   $0x0
  pushl $206
  10259f:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1025a4:	e9 4c 02 00 00       	jmp    1027f5 <__alltraps>

001025a9 <vector207>:
.globl vector207
vector207:
  pushl $0
  1025a9:	6a 00                	push   $0x0
  pushl $207
  1025ab:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1025b0:	e9 40 02 00 00       	jmp    1027f5 <__alltraps>

001025b5 <vector208>:
.globl vector208
vector208:
  pushl $0
  1025b5:	6a 00                	push   $0x0
  pushl $208
  1025b7:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1025bc:	e9 34 02 00 00       	jmp    1027f5 <__alltraps>

001025c1 <vector209>:
.globl vector209
vector209:
  pushl $0
  1025c1:	6a 00                	push   $0x0
  pushl $209
  1025c3:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1025c8:	e9 28 02 00 00       	jmp    1027f5 <__alltraps>

001025cd <vector210>:
.globl vector210
vector210:
  pushl $0
  1025cd:	6a 00                	push   $0x0
  pushl $210
  1025cf:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  1025d4:	e9 1c 02 00 00       	jmp    1027f5 <__alltraps>

001025d9 <vector211>:
.globl vector211
vector211:
  pushl $0
  1025d9:	6a 00                	push   $0x0
  pushl $211
  1025db:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  1025e0:	e9 10 02 00 00       	jmp    1027f5 <__alltraps>

001025e5 <vector212>:
.globl vector212
vector212:
  pushl $0
  1025e5:	6a 00                	push   $0x0
  pushl $212
  1025e7:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1025ec:	e9 04 02 00 00       	jmp    1027f5 <__alltraps>

001025f1 <vector213>:
.globl vector213
vector213:
  pushl $0
  1025f1:	6a 00                	push   $0x0
  pushl $213
  1025f3:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1025f8:	e9 f8 01 00 00       	jmp    1027f5 <__alltraps>

001025fd <vector214>:
.globl vector214
vector214:
  pushl $0
  1025fd:	6a 00                	push   $0x0
  pushl $214
  1025ff:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102604:	e9 ec 01 00 00       	jmp    1027f5 <__alltraps>

00102609 <vector215>:
.globl vector215
vector215:
  pushl $0
  102609:	6a 00                	push   $0x0
  pushl $215
  10260b:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  102610:	e9 e0 01 00 00       	jmp    1027f5 <__alltraps>

00102615 <vector216>:
.globl vector216
vector216:
  pushl $0
  102615:	6a 00                	push   $0x0
  pushl $216
  102617:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10261c:	e9 d4 01 00 00       	jmp    1027f5 <__alltraps>

00102621 <vector217>:
.globl vector217
vector217:
  pushl $0
  102621:	6a 00                	push   $0x0
  pushl $217
  102623:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102628:	e9 c8 01 00 00       	jmp    1027f5 <__alltraps>

0010262d <vector218>:
.globl vector218
vector218:
  pushl $0
  10262d:	6a 00                	push   $0x0
  pushl $218
  10262f:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102634:	e9 bc 01 00 00       	jmp    1027f5 <__alltraps>

00102639 <vector219>:
.globl vector219
vector219:
  pushl $0
  102639:	6a 00                	push   $0x0
  pushl $219
  10263b:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  102640:	e9 b0 01 00 00       	jmp    1027f5 <__alltraps>

00102645 <vector220>:
.globl vector220
vector220:
  pushl $0
  102645:	6a 00                	push   $0x0
  pushl $220
  102647:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10264c:	e9 a4 01 00 00       	jmp    1027f5 <__alltraps>

00102651 <vector221>:
.globl vector221
vector221:
  pushl $0
  102651:	6a 00                	push   $0x0
  pushl $221
  102653:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102658:	e9 98 01 00 00       	jmp    1027f5 <__alltraps>

0010265d <vector222>:
.globl vector222
vector222:
  pushl $0
  10265d:	6a 00                	push   $0x0
  pushl $222
  10265f:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102664:	e9 8c 01 00 00       	jmp    1027f5 <__alltraps>

00102669 <vector223>:
.globl vector223
vector223:
  pushl $0
  102669:	6a 00                	push   $0x0
  pushl $223
  10266b:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  102670:	e9 80 01 00 00       	jmp    1027f5 <__alltraps>

00102675 <vector224>:
.globl vector224
vector224:
  pushl $0
  102675:	6a 00                	push   $0x0
  pushl $224
  102677:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  10267c:	e9 74 01 00 00       	jmp    1027f5 <__alltraps>

00102681 <vector225>:
.globl vector225
vector225:
  pushl $0
  102681:	6a 00                	push   $0x0
  pushl $225
  102683:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102688:	e9 68 01 00 00       	jmp    1027f5 <__alltraps>

0010268d <vector226>:
.globl vector226
vector226:
  pushl $0
  10268d:	6a 00                	push   $0x0
  pushl $226
  10268f:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  102694:	e9 5c 01 00 00       	jmp    1027f5 <__alltraps>

00102699 <vector227>:
.globl vector227
vector227:
  pushl $0
  102699:	6a 00                	push   $0x0
  pushl $227
  10269b:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1026a0:	e9 50 01 00 00       	jmp    1027f5 <__alltraps>

001026a5 <vector228>:
.globl vector228
vector228:
  pushl $0
  1026a5:	6a 00                	push   $0x0
  pushl $228
  1026a7:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1026ac:	e9 44 01 00 00       	jmp    1027f5 <__alltraps>

001026b1 <vector229>:
.globl vector229
vector229:
  pushl $0
  1026b1:	6a 00                	push   $0x0
  pushl $229
  1026b3:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1026b8:	e9 38 01 00 00       	jmp    1027f5 <__alltraps>

001026bd <vector230>:
.globl vector230
vector230:
  pushl $0
  1026bd:	6a 00                	push   $0x0
  pushl $230
  1026bf:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1026c4:	e9 2c 01 00 00       	jmp    1027f5 <__alltraps>

001026c9 <vector231>:
.globl vector231
vector231:
  pushl $0
  1026c9:	6a 00                	push   $0x0
  pushl $231
  1026cb:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1026d0:	e9 20 01 00 00       	jmp    1027f5 <__alltraps>

001026d5 <vector232>:
.globl vector232
vector232:
  pushl $0
  1026d5:	6a 00                	push   $0x0
  pushl $232
  1026d7:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  1026dc:	e9 14 01 00 00       	jmp    1027f5 <__alltraps>

001026e1 <vector233>:
.globl vector233
vector233:
  pushl $0
  1026e1:	6a 00                	push   $0x0
  pushl $233
  1026e3:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1026e8:	e9 08 01 00 00       	jmp    1027f5 <__alltraps>

001026ed <vector234>:
.globl vector234
vector234:
  pushl $0
  1026ed:	6a 00                	push   $0x0
  pushl $234
  1026ef:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1026f4:	e9 fc 00 00 00       	jmp    1027f5 <__alltraps>

001026f9 <vector235>:
.globl vector235
vector235:
  pushl $0
  1026f9:	6a 00                	push   $0x0
  pushl $235
  1026fb:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  102700:	e9 f0 00 00 00       	jmp    1027f5 <__alltraps>

00102705 <vector236>:
.globl vector236
vector236:
  pushl $0
  102705:	6a 00                	push   $0x0
  pushl $236
  102707:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10270c:	e9 e4 00 00 00       	jmp    1027f5 <__alltraps>

00102711 <vector237>:
.globl vector237
vector237:
  pushl $0
  102711:	6a 00                	push   $0x0
  pushl $237
  102713:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102718:	e9 d8 00 00 00       	jmp    1027f5 <__alltraps>

0010271d <vector238>:
.globl vector238
vector238:
  pushl $0
  10271d:	6a 00                	push   $0x0
  pushl $238
  10271f:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102724:	e9 cc 00 00 00       	jmp    1027f5 <__alltraps>

00102729 <vector239>:
.globl vector239
vector239:
  pushl $0
  102729:	6a 00                	push   $0x0
  pushl $239
  10272b:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  102730:	e9 c0 00 00 00       	jmp    1027f5 <__alltraps>

00102735 <vector240>:
.globl vector240
vector240:
  pushl $0
  102735:	6a 00                	push   $0x0
  pushl $240
  102737:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10273c:	e9 b4 00 00 00       	jmp    1027f5 <__alltraps>

00102741 <vector241>:
.globl vector241
vector241:
  pushl $0
  102741:	6a 00                	push   $0x0
  pushl $241
  102743:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102748:	e9 a8 00 00 00       	jmp    1027f5 <__alltraps>

0010274d <vector242>:
.globl vector242
vector242:
  pushl $0
  10274d:	6a 00                	push   $0x0
  pushl $242
  10274f:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102754:	e9 9c 00 00 00       	jmp    1027f5 <__alltraps>

00102759 <vector243>:
.globl vector243
vector243:
  pushl $0
  102759:	6a 00                	push   $0x0
  pushl $243
  10275b:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  102760:	e9 90 00 00 00       	jmp    1027f5 <__alltraps>

00102765 <vector244>:
.globl vector244
vector244:
  pushl $0
  102765:	6a 00                	push   $0x0
  pushl $244
  102767:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10276c:	e9 84 00 00 00       	jmp    1027f5 <__alltraps>

00102771 <vector245>:
.globl vector245
vector245:
  pushl $0
  102771:	6a 00                	push   $0x0
  pushl $245
  102773:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102778:	e9 78 00 00 00       	jmp    1027f5 <__alltraps>

0010277d <vector246>:
.globl vector246
vector246:
  pushl $0
  10277d:	6a 00                	push   $0x0
  pushl $246
  10277f:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  102784:	e9 6c 00 00 00       	jmp    1027f5 <__alltraps>

00102789 <vector247>:
.globl vector247
vector247:
  pushl $0
  102789:	6a 00                	push   $0x0
  pushl $247
  10278b:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  102790:	e9 60 00 00 00       	jmp    1027f5 <__alltraps>

00102795 <vector248>:
.globl vector248
vector248:
  pushl $0
  102795:	6a 00                	push   $0x0
  pushl $248
  102797:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  10279c:	e9 54 00 00 00       	jmp    1027f5 <__alltraps>

001027a1 <vector249>:
.globl vector249
vector249:
  pushl $0
  1027a1:	6a 00                	push   $0x0
  pushl $249
  1027a3:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1027a8:	e9 48 00 00 00       	jmp    1027f5 <__alltraps>

001027ad <vector250>:
.globl vector250
vector250:
  pushl $0
  1027ad:	6a 00                	push   $0x0
  pushl $250
  1027af:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1027b4:	e9 3c 00 00 00       	jmp    1027f5 <__alltraps>

001027b9 <vector251>:
.globl vector251
vector251:
  pushl $0
  1027b9:	6a 00                	push   $0x0
  pushl $251
  1027bb:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1027c0:	e9 30 00 00 00       	jmp    1027f5 <__alltraps>

001027c5 <vector252>:
.globl vector252
vector252:
  pushl $0
  1027c5:	6a 00                	push   $0x0
  pushl $252
  1027c7:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1027cc:	e9 24 00 00 00       	jmp    1027f5 <__alltraps>

001027d1 <vector253>:
.globl vector253
vector253:
  pushl $0
  1027d1:	6a 00                	push   $0x0
  pushl $253
  1027d3:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  1027d8:	e9 18 00 00 00       	jmp    1027f5 <__alltraps>

001027dd <vector254>:
.globl vector254
vector254:
  pushl $0
  1027dd:	6a 00                	push   $0x0
  pushl $254
  1027df:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  1027e4:	e9 0c 00 00 00       	jmp    1027f5 <__alltraps>

001027e9 <vector255>:
.globl vector255
vector255:
  pushl $0
  1027e9:	6a 00                	push   $0x0
  pushl $255
  1027eb:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1027f0:	e9 00 00 00 00       	jmp    1027f5 <__alltraps>

001027f5 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1027f5:	1e                   	push   %ds
    pushl %es
  1027f6:	06                   	push   %es
    pushl %fs
  1027f7:	0f a0                	push   %fs
    pushl %gs
  1027f9:	0f a8                	push   %gs
    pushal
  1027fb:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1027fc:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  102801:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  102803:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  102805:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  102806:	e8 64 f5 ff ff       	call   101d6f <trap>

    # pop the pushed stack pointer
    popl %esp
  10280b:	5c                   	pop    %esp

0010280c <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  10280c:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  10280d:	0f a9                	pop    %gs
    popl %fs
  10280f:	0f a1                	pop    %fs
    popl %es
  102811:	07                   	pop    %es
    popl %ds
  102812:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  102813:	83 c4 08             	add    $0x8,%esp
    iret
  102816:	cf                   	iret   

00102817 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102817:	55                   	push   %ebp
  102818:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10281a:	8b 45 08             	mov    0x8(%ebp),%eax
  10281d:	8b 15 98 af 11 00    	mov    0x11af98,%edx
  102823:	29 d0                	sub    %edx,%eax
  102825:	c1 f8 02             	sar    $0x2,%eax
  102828:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10282e:	5d                   	pop    %ebp
  10282f:	c3                   	ret    

00102830 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102830:	55                   	push   %ebp
  102831:	89 e5                	mov    %esp,%ebp
  102833:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102836:	8b 45 08             	mov    0x8(%ebp),%eax
  102839:	89 04 24             	mov    %eax,(%esp)
  10283c:	e8 d6 ff ff ff       	call   102817 <page2ppn>
  102841:	c1 e0 0c             	shl    $0xc,%eax
}
  102844:	c9                   	leave  
  102845:	c3                   	ret    

00102846 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  102846:	55                   	push   %ebp
  102847:	89 e5                	mov    %esp,%ebp
  102849:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  10284c:	8b 45 08             	mov    0x8(%ebp),%eax
  10284f:	c1 e8 0c             	shr    $0xc,%eax
  102852:	89 c2                	mov    %eax,%edx
  102854:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  102859:	39 c2                	cmp    %eax,%edx
  10285b:	72 1c                	jb     102879 <pa2page+0x33>
        panic("pa2page called with invalid pa");
  10285d:	c7 44 24 08 50 66 10 	movl   $0x106650,0x8(%esp)
  102864:	00 
  102865:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  10286c:	00 
  10286d:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  102874:	e8 70 db ff ff       	call   1003e9 <__panic>
    }
    return &pages[PPN(pa)];
  102879:	8b 0d 98 af 11 00    	mov    0x11af98,%ecx
  10287f:	8b 45 08             	mov    0x8(%ebp),%eax
  102882:	c1 e8 0c             	shr    $0xc,%eax
  102885:	89 c2                	mov    %eax,%edx
  102887:	89 d0                	mov    %edx,%eax
  102889:	c1 e0 02             	shl    $0x2,%eax
  10288c:	01 d0                	add    %edx,%eax
  10288e:	c1 e0 02             	shl    $0x2,%eax
  102891:	01 c8                	add    %ecx,%eax
}
  102893:	c9                   	leave  
  102894:	c3                   	ret    

00102895 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  102895:	55                   	push   %ebp
  102896:	89 e5                	mov    %esp,%ebp
  102898:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  10289b:	8b 45 08             	mov    0x8(%ebp),%eax
  10289e:	89 04 24             	mov    %eax,(%esp)
  1028a1:	e8 8a ff ff ff       	call   102830 <page2pa>
  1028a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028ac:	c1 e8 0c             	shr    $0xc,%eax
  1028af:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1028b2:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1028b7:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1028ba:	72 23                	jb     1028df <page2kva+0x4a>
  1028bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1028c3:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  1028ca:	00 
  1028cb:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  1028d2:	00 
  1028d3:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  1028da:	e8 0a db ff ff       	call   1003e9 <__panic>
  1028df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1028e2:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  1028e7:	c9                   	leave  
  1028e8:	c3                   	ret    

001028e9 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  1028e9:	55                   	push   %ebp
  1028ea:	89 e5                	mov    %esp,%ebp
  1028ec:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  1028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  1028f2:	83 e0 01             	and    $0x1,%eax
  1028f5:	85 c0                	test   %eax,%eax
  1028f7:	75 1c                	jne    102915 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  1028f9:	c7 44 24 08 a4 66 10 	movl   $0x1066a4,0x8(%esp)
  102900:	00 
  102901:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  102908:	00 
  102909:	c7 04 24 6f 66 10 00 	movl   $0x10666f,(%esp)
  102910:	e8 d4 da ff ff       	call   1003e9 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  102915:	8b 45 08             	mov    0x8(%ebp),%eax
  102918:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10291d:	89 04 24             	mov    %eax,(%esp)
  102920:	e8 21 ff ff ff       	call   102846 <pa2page>
}
  102925:	c9                   	leave  
  102926:	c3                   	ret    

00102927 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  102927:	55                   	push   %ebp
  102928:	89 e5                	mov    %esp,%ebp
  10292a:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  10292d:	8b 45 08             	mov    0x8(%ebp),%eax
  102930:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  102935:	89 04 24             	mov    %eax,(%esp)
  102938:	e8 09 ff ff ff       	call   102846 <pa2page>
}
  10293d:	c9                   	leave  
  10293e:	c3                   	ret    

0010293f <page_ref>:

static inline int
page_ref(struct Page *page) {
  10293f:	55                   	push   %ebp
  102940:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102942:	8b 45 08             	mov    0x8(%ebp),%eax
  102945:	8b 00                	mov    (%eax),%eax
}
  102947:	5d                   	pop    %ebp
  102948:	c3                   	ret    

00102949 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102949:	55                   	push   %ebp
  10294a:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  10294c:	8b 45 08             	mov    0x8(%ebp),%eax
  10294f:	8b 55 0c             	mov    0xc(%ebp),%edx
  102952:	89 10                	mov    %edx,(%eax)
}
  102954:	90                   	nop
  102955:	5d                   	pop    %ebp
  102956:	c3                   	ret    

00102957 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  102957:	55                   	push   %ebp
  102958:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  10295a:	8b 45 08             	mov    0x8(%ebp),%eax
  10295d:	8b 00                	mov    (%eax),%eax
  10295f:	8d 50 01             	lea    0x1(%eax),%edx
  102962:	8b 45 08             	mov    0x8(%ebp),%eax
  102965:	89 10                	mov    %edx,(%eax)
    return page->ref;
  102967:	8b 45 08             	mov    0x8(%ebp),%eax
  10296a:	8b 00                	mov    (%eax),%eax
}
  10296c:	5d                   	pop    %ebp
  10296d:	c3                   	ret    

0010296e <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  10296e:	55                   	push   %ebp
  10296f:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  102971:	8b 45 08             	mov    0x8(%ebp),%eax
  102974:	8b 00                	mov    (%eax),%eax
  102976:	8d 50 ff             	lea    -0x1(%eax),%edx
  102979:	8b 45 08             	mov    0x8(%ebp),%eax
  10297c:	89 10                	mov    %edx,(%eax)
    return page->ref;
  10297e:	8b 45 08             	mov    0x8(%ebp),%eax
  102981:	8b 00                	mov    (%eax),%eax
}
  102983:	5d                   	pop    %ebp
  102984:	c3                   	ret    

00102985 <__intr_save>:
__intr_save(void) {
  102985:	55                   	push   %ebp
  102986:	89 e5                	mov    %esp,%ebp
  102988:	83 ec 18             	sub    $0x18,%esp
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  10298b:	9c                   	pushf  
  10298c:	58                   	pop    %eax
  10298d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return eflags;
  102990:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  102993:	25 00 02 00 00       	and    $0x200,%eax
  102998:	85 c0                	test   %eax,%eax
  10299a:	74 0c                	je     1029a8 <__intr_save+0x23>
        intr_disable();
  10299c:	e8 d2 ee ff ff       	call   101873 <intr_disable>
        return 1;
  1029a1:	b8 01 00 00 00       	mov    $0x1,%eax
  1029a6:	eb 05                	jmp    1029ad <__intr_save+0x28>
    return 0;
  1029a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1029ad:	c9                   	leave  
  1029ae:	c3                   	ret    

001029af <__intr_restore>:
__intr_restore(bool flag) {
  1029af:	55                   	push   %ebp
  1029b0:	89 e5                	mov    %esp,%ebp
  1029b2:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  1029b5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1029b9:	74 05                	je     1029c0 <__intr_restore+0x11>
        intr_enable();
  1029bb:	e8 ac ee ff ff       	call   10186c <intr_enable>
}
  1029c0:	90                   	nop
  1029c1:	c9                   	leave  
  1029c2:	c3                   	ret    

001029c3 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029c3:	55                   	push   %ebp
  1029c4:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1029c9:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029cc:	b8 23 00 00 00       	mov    $0x23,%eax
  1029d1:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029d3:	b8 23 00 00 00       	mov    $0x23,%eax
  1029d8:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029da:	b8 10 00 00 00       	mov    $0x10,%eax
  1029df:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029e1:	b8 10 00 00 00       	mov    $0x10,%eax
  1029e6:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029e8:	b8 10 00 00 00       	mov    $0x10,%eax
  1029ed:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029ef:	ea f6 29 10 00 08 00 	ljmp   $0x8,$0x1029f6
}
  1029f6:	90                   	nop
  1029f7:	5d                   	pop    %ebp
  1029f8:	c3                   	ret    

001029f9 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  1029f9:	55                   	push   %ebp
  1029fa:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  1029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ff:	a3 c4 ae 11 00       	mov    %eax,0x11aec4
}
  102a04:	90                   	nop
  102a05:	5d                   	pop    %ebp
  102a06:	c3                   	ret    

00102a07 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a07:	55                   	push   %ebp
  102a08:	89 e5                	mov    %esp,%ebp
  102a0a:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  102a0d:	b8 00 70 11 00       	mov    $0x117000,%eax
  102a12:	89 04 24             	mov    %eax,(%esp)
  102a15:	e8 df ff ff ff       	call   1029f9 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  102a1a:	66 c7 05 c8 ae 11 00 	movw   $0x10,0x11aec8
  102a21:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  102a23:	66 c7 05 28 7a 11 00 	movw   $0x68,0x117a28
  102a2a:	68 00 
  102a2c:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102a31:	0f b7 c0             	movzwl %ax,%eax
  102a34:	66 a3 2a 7a 11 00    	mov    %ax,0x117a2a
  102a3a:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102a3f:	c1 e8 10             	shr    $0x10,%eax
  102a42:	a2 2c 7a 11 00       	mov    %al,0x117a2c
  102a47:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a4e:	24 f0                	and    $0xf0,%al
  102a50:	0c 09                	or     $0x9,%al
  102a52:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a57:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a5e:	24 ef                	and    $0xef,%al
  102a60:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a65:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a6c:	24 9f                	and    $0x9f,%al
  102a6e:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a73:	0f b6 05 2d 7a 11 00 	movzbl 0x117a2d,%eax
  102a7a:	0c 80                	or     $0x80,%al
  102a7c:	a2 2d 7a 11 00       	mov    %al,0x117a2d
  102a81:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102a88:	24 f0                	and    $0xf0,%al
  102a8a:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102a8f:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102a96:	24 ef                	and    $0xef,%al
  102a98:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102a9d:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102aa4:	24 df                	and    $0xdf,%al
  102aa6:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102aab:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102ab2:	0c 40                	or     $0x40,%al
  102ab4:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ab9:	0f b6 05 2e 7a 11 00 	movzbl 0x117a2e,%eax
  102ac0:	24 7f                	and    $0x7f,%al
  102ac2:	a2 2e 7a 11 00       	mov    %al,0x117a2e
  102ac7:	b8 c0 ae 11 00       	mov    $0x11aec0,%eax
  102acc:	c1 e8 18             	shr    $0x18,%eax
  102acf:	a2 2f 7a 11 00       	mov    %al,0x117a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  102ad4:	c7 04 24 30 7a 11 00 	movl   $0x117a30,(%esp)
  102adb:	e8 e3 fe ff ff       	call   1029c3 <lgdt>
  102ae0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  102ae6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102aea:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102aed:	90                   	nop
  102aee:	c9                   	leave  
  102aef:	c3                   	ret    

00102af0 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  102af0:	55                   	push   %ebp
  102af1:	89 e5                	mov    %esp,%ebp
  102af3:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  102af6:	c7 05 90 af 11 00 60 	movl   $0x107060,0x11af90
  102afd:	70 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  102b00:	a1 90 af 11 00       	mov    0x11af90,%eax
  102b05:	8b 00                	mov    (%eax),%eax
  102b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  102b0b:	c7 04 24 d0 66 10 00 	movl   $0x1066d0,(%esp)
  102b12:	e8 7b d7 ff ff       	call   100292 <cprintf>
    pmm_manager->init();
  102b17:	a1 90 af 11 00       	mov    0x11af90,%eax
  102b1c:	8b 40 04             	mov    0x4(%eax),%eax
  102b1f:	ff d0                	call   *%eax
}
  102b21:	90                   	nop
  102b22:	c9                   	leave  
  102b23:	c3                   	ret    

00102b24 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  102b24:	55                   	push   %ebp
  102b25:	89 e5                	mov    %esp,%ebp
  102b27:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  102b2a:	a1 90 af 11 00       	mov    0x11af90,%eax
  102b2f:	8b 40 08             	mov    0x8(%eax),%eax
  102b32:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b35:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b39:	8b 55 08             	mov    0x8(%ebp),%edx
  102b3c:	89 14 24             	mov    %edx,(%esp)
  102b3f:	ff d0                	call   *%eax
}
  102b41:	90                   	nop
  102b42:	c9                   	leave  
  102b43:	c3                   	ret    

00102b44 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  102b44:	55                   	push   %ebp
  102b45:	89 e5                	mov    %esp,%ebp
  102b47:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  102b4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  102b51:	e8 2f fe ff ff       	call   102985 <__intr_save>
  102b56:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  102b59:	a1 90 af 11 00       	mov    0x11af90,%eax
  102b5e:	8b 40 0c             	mov    0xc(%eax),%eax
  102b61:	8b 55 08             	mov    0x8(%ebp),%edx
  102b64:	89 14 24             	mov    %edx,(%esp)
  102b67:	ff d0                	call   *%eax
  102b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  102b6c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102b6f:	89 04 24             	mov    %eax,(%esp)
  102b72:	e8 38 fe ff ff       	call   1029af <__intr_restore>
    return page;
  102b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102b7a:	c9                   	leave  
  102b7b:	c3                   	ret    

00102b7c <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  102b7c:	55                   	push   %ebp
  102b7d:	89 e5                	mov    %esp,%ebp
  102b7f:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  102b82:	e8 fe fd ff ff       	call   102985 <__intr_save>
  102b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  102b8a:	a1 90 af 11 00       	mov    0x11af90,%eax
  102b8f:	8b 40 10             	mov    0x10(%eax),%eax
  102b92:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b95:	89 54 24 04          	mov    %edx,0x4(%esp)
  102b99:	8b 55 08             	mov    0x8(%ebp),%edx
  102b9c:	89 14 24             	mov    %edx,(%esp)
  102b9f:	ff d0                	call   *%eax
    }
    local_intr_restore(intr_flag);
  102ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ba4:	89 04 24             	mov    %eax,(%esp)
  102ba7:	e8 03 fe ff ff       	call   1029af <__intr_restore>
}
  102bac:	90                   	nop
  102bad:	c9                   	leave  
  102bae:	c3                   	ret    

00102baf <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  102baf:	55                   	push   %ebp
  102bb0:	89 e5                	mov    %esp,%ebp
  102bb2:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  102bb5:	e8 cb fd ff ff       	call   102985 <__intr_save>
  102bba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  102bbd:	a1 90 af 11 00       	mov    0x11af90,%eax
  102bc2:	8b 40 14             	mov    0x14(%eax),%eax
  102bc5:	ff d0                	call   *%eax
  102bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  102bca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102bcd:	89 04 24             	mov    %eax,(%esp)
  102bd0:	e8 da fd ff ff       	call   1029af <__intr_restore>
    return ret;
  102bd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  102bd8:	c9                   	leave  
  102bd9:	c3                   	ret    

00102bda <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  102bda:	55                   	push   %ebp
  102bdb:	89 e5                	mov    %esp,%ebp
  102bdd:	57                   	push   %edi
  102bde:	56                   	push   %esi
  102bdf:	53                   	push   %ebx
  102be0:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  102be6:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  102bed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  102bf4:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  102bfb:	c7 04 24 e7 66 10 00 	movl   $0x1066e7,(%esp)
  102c02:	e8 8b d6 ff ff       	call   100292 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  102c07:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102c0e:	e9 22 01 00 00       	jmp    102d35 <page_init+0x15b>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102c13:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c16:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c19:	89 d0                	mov    %edx,%eax
  102c1b:	c1 e0 02             	shl    $0x2,%eax
  102c1e:	01 d0                	add    %edx,%eax
  102c20:	c1 e0 02             	shl    $0x2,%eax
  102c23:	01 c8                	add    %ecx,%eax
  102c25:	8b 50 08             	mov    0x8(%eax),%edx
  102c28:	8b 40 04             	mov    0x4(%eax),%eax
  102c2b:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102c2e:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102c31:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c34:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c37:	89 d0                	mov    %edx,%eax
  102c39:	c1 e0 02             	shl    $0x2,%eax
  102c3c:	01 d0                	add    %edx,%eax
  102c3e:	c1 e0 02             	shl    $0x2,%eax
  102c41:	01 c8                	add    %ecx,%eax
  102c43:	8b 48 0c             	mov    0xc(%eax),%ecx
  102c46:	8b 58 10             	mov    0x10(%eax),%ebx
  102c49:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102c4c:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102c4f:	01 c8                	add    %ecx,%eax
  102c51:	11 da                	adc    %ebx,%edx
  102c53:	89 45 98             	mov    %eax,-0x68(%ebp)
  102c56:	89 55 9c             	mov    %edx,-0x64(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  102c59:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c5c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c5f:	89 d0                	mov    %edx,%eax
  102c61:	c1 e0 02             	shl    $0x2,%eax
  102c64:	01 d0                	add    %edx,%eax
  102c66:	c1 e0 02             	shl    $0x2,%eax
  102c69:	01 c8                	add    %ecx,%eax
  102c6b:	83 c0 14             	add    $0x14,%eax
  102c6e:	8b 00                	mov    (%eax),%eax
  102c70:	89 45 84             	mov    %eax,-0x7c(%ebp)
  102c73:	8b 45 98             	mov    -0x68(%ebp),%eax
  102c76:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102c79:	83 c0 ff             	add    $0xffffffff,%eax
  102c7c:	83 d2 ff             	adc    $0xffffffff,%edx
  102c7f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
  102c85:	89 95 7c ff ff ff    	mov    %edx,-0x84(%ebp)
  102c8b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102c8e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102c91:	89 d0                	mov    %edx,%eax
  102c93:	c1 e0 02             	shl    $0x2,%eax
  102c96:	01 d0                	add    %edx,%eax
  102c98:	c1 e0 02             	shl    $0x2,%eax
  102c9b:	01 c8                	add    %ecx,%eax
  102c9d:	8b 48 0c             	mov    0xc(%eax),%ecx
  102ca0:	8b 58 10             	mov    0x10(%eax),%ebx
  102ca3:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102ca6:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  102caa:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  102cb0:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102cb6:	89 44 24 14          	mov    %eax,0x14(%esp)
  102cba:	89 54 24 18          	mov    %edx,0x18(%esp)
  102cbe:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102cc1:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102cc4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102cc8:	89 54 24 10          	mov    %edx,0x10(%esp)
  102ccc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  102cd0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  102cd4:	c7 04 24 f4 66 10 00 	movl   $0x1066f4,(%esp)
  102cdb:	e8 b2 d5 ff ff       	call   100292 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  102ce0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102ce3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ce6:	89 d0                	mov    %edx,%eax
  102ce8:	c1 e0 02             	shl    $0x2,%eax
  102ceb:	01 d0                	add    %edx,%eax
  102ced:	c1 e0 02             	shl    $0x2,%eax
  102cf0:	01 c8                	add    %ecx,%eax
  102cf2:	83 c0 14             	add    $0x14,%eax
  102cf5:	8b 00                	mov    (%eax),%eax
  102cf7:	83 f8 01             	cmp    $0x1,%eax
  102cfa:	75 36                	jne    102d32 <page_init+0x158>
            if (maxpa < end && begin < KMEMSIZE) {
  102cfc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102cff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d02:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102d05:	77 2b                	ja     102d32 <page_init+0x158>
  102d07:	3b 55 9c             	cmp    -0x64(%ebp),%edx
  102d0a:	72 05                	jb     102d11 <page_init+0x137>
  102d0c:	3b 45 98             	cmp    -0x68(%ebp),%eax
  102d0f:	73 21                	jae    102d32 <page_init+0x158>
  102d11:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102d15:	77 1b                	ja     102d32 <page_init+0x158>
  102d17:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  102d1b:	72 09                	jb     102d26 <page_init+0x14c>
  102d1d:	81 7d a0 ff ff ff 37 	cmpl   $0x37ffffff,-0x60(%ebp)
  102d24:	77 0c                	ja     102d32 <page_init+0x158>
                maxpa = end;
  102d26:	8b 45 98             	mov    -0x68(%ebp),%eax
  102d29:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102d2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102d2f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    for (i = 0; i < memmap->nr_map; i ++) {
  102d32:	ff 45 dc             	incl   -0x24(%ebp)
  102d35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102d38:	8b 00                	mov    (%eax),%eax
  102d3a:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102d3d:	0f 8c d0 fe ff ff    	jl     102c13 <page_init+0x39>
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  102d43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d47:	72 1d                	jb     102d66 <page_init+0x18c>
  102d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  102d4d:	77 09                	ja     102d58 <page_init+0x17e>
  102d4f:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  102d56:	76 0e                	jbe    102d66 <page_init+0x18c>
        maxpa = KMEMSIZE;
  102d58:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  102d5f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  102d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102d69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102d6c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102d70:	c1 ea 0c             	shr    $0xc,%edx
  102d73:	89 c1                	mov    %eax,%ecx
  102d75:	89 d3                	mov    %edx,%ebx
  102d77:	89 c8                	mov    %ecx,%eax
  102d79:	a3 a0 ae 11 00       	mov    %eax,0x11aea0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  102d7e:	c7 45 c0 00 10 00 00 	movl   $0x1000,-0x40(%ebp)
  102d85:	b8 a8 af 11 00       	mov    $0x11afa8,%eax
  102d8a:	8d 50 ff             	lea    -0x1(%eax),%edx
  102d8d:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102d90:	01 d0                	add    %edx,%eax
  102d92:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102d95:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102d98:	ba 00 00 00 00       	mov    $0x0,%edx
  102d9d:	f7 75 c0             	divl   -0x40(%ebp)
  102da0:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102da3:	29 d0                	sub    %edx,%eax
  102da5:	a3 98 af 11 00       	mov    %eax,0x11af98

    for (i = 0; i < npage; i ++) {
  102daa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102db1:	eb 2e                	jmp    102de1 <page_init+0x207>
        SetPageReserved(pages + i);
  102db3:	8b 0d 98 af 11 00    	mov    0x11af98,%ecx
  102db9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102dbc:	89 d0                	mov    %edx,%eax
  102dbe:	c1 e0 02             	shl    $0x2,%eax
  102dc1:	01 d0                	add    %edx,%eax
  102dc3:	c1 e0 02             	shl    $0x2,%eax
  102dc6:	01 c8                	add    %ecx,%eax
  102dc8:	83 c0 04             	add    $0x4,%eax
  102dcb:	c7 45 94 00 00 00 00 	movl   $0x0,-0x6c(%ebp)
  102dd2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dd5:	8b 45 90             	mov    -0x70(%ebp),%eax
  102dd8:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102ddb:	0f ab 10             	bts    %edx,(%eax)
    for (i = 0; i < npage; i ++) {
  102dde:	ff 45 dc             	incl   -0x24(%ebp)
  102de1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102de4:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  102de9:	39 c2                	cmp    %eax,%edx
  102deb:	72 c6                	jb     102db3 <page_init+0x1d9>
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  102ded:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  102df3:	89 d0                	mov    %edx,%eax
  102df5:	c1 e0 02             	shl    $0x2,%eax
  102df8:	01 d0                	add    %edx,%eax
  102dfa:	c1 e0 02             	shl    $0x2,%eax
  102dfd:	89 c2                	mov    %eax,%edx
  102dff:	a1 98 af 11 00       	mov    0x11af98,%eax
  102e04:	01 d0                	add    %edx,%eax
  102e06:	89 45 b8             	mov    %eax,-0x48(%ebp)
  102e09:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
  102e10:	77 23                	ja     102e35 <page_init+0x25b>
  102e12:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e15:	89 44 24 0c          	mov    %eax,0xc(%esp)
  102e19:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  102e20:	00 
  102e21:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  102e28:	00 
  102e29:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  102e30:	e8 b4 d5 ff ff       	call   1003e9 <__panic>
  102e35:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102e38:	05 00 00 00 40       	add    $0x40000000,%eax
  102e3d:	89 45 b4             	mov    %eax,-0x4c(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  102e40:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  102e47:	e9 69 01 00 00       	jmp    102fb5 <page_init+0x3db>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  102e4c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e4f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e52:	89 d0                	mov    %edx,%eax
  102e54:	c1 e0 02             	shl    $0x2,%eax
  102e57:	01 d0                	add    %edx,%eax
  102e59:	c1 e0 02             	shl    $0x2,%eax
  102e5c:	01 c8                	add    %ecx,%eax
  102e5e:	8b 50 08             	mov    0x8(%eax),%edx
  102e61:	8b 40 04             	mov    0x4(%eax),%eax
  102e64:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102e67:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102e6a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e6d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e70:	89 d0                	mov    %edx,%eax
  102e72:	c1 e0 02             	shl    $0x2,%eax
  102e75:	01 d0                	add    %edx,%eax
  102e77:	c1 e0 02             	shl    $0x2,%eax
  102e7a:	01 c8                	add    %ecx,%eax
  102e7c:	8b 48 0c             	mov    0xc(%eax),%ecx
  102e7f:	8b 58 10             	mov    0x10(%eax),%ebx
  102e82:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102e85:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102e88:	01 c8                	add    %ecx,%eax
  102e8a:	11 da                	adc    %ebx,%edx
  102e8c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  102e8f:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  102e92:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  102e95:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102e98:	89 d0                	mov    %edx,%eax
  102e9a:	c1 e0 02             	shl    $0x2,%eax
  102e9d:	01 d0                	add    %edx,%eax
  102e9f:	c1 e0 02             	shl    $0x2,%eax
  102ea2:	01 c8                	add    %ecx,%eax
  102ea4:	83 c0 14             	add    $0x14,%eax
  102ea7:	8b 00                	mov    (%eax),%eax
  102ea9:	83 f8 01             	cmp    $0x1,%eax
  102eac:	0f 85 00 01 00 00    	jne    102fb2 <page_init+0x3d8>
            if (begin < freemem) {
  102eb2:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102eb5:	ba 00 00 00 00       	mov    $0x0,%edx
  102eba:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102ebd:	77 17                	ja     102ed6 <page_init+0x2fc>
  102ebf:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  102ec2:	72 05                	jb     102ec9 <page_init+0x2ef>
  102ec4:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  102ec7:	73 0d                	jae    102ed6 <page_init+0x2fc>
                begin = freemem;
  102ec9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102ecc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102ecf:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  102ed6:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102eda:	72 1d                	jb     102ef9 <page_init+0x31f>
  102edc:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102ee0:	77 09                	ja     102eeb <page_init+0x311>
  102ee2:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  102ee9:	76 0e                	jbe    102ef9 <page_init+0x31f>
                end = KMEMSIZE;
  102eeb:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  102ef2:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  102ef9:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102efc:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102eff:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f02:	0f 87 aa 00 00 00    	ja     102fb2 <page_init+0x3d8>
  102f08:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f0b:	72 09                	jb     102f16 <page_init+0x33c>
  102f0d:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f10:	0f 83 9c 00 00 00    	jae    102fb2 <page_init+0x3d8>
                begin = ROUNDUP(begin, PGSIZE);
  102f16:	c7 45 b0 00 10 00 00 	movl   $0x1000,-0x50(%ebp)
  102f1d:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102f20:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102f23:	01 d0                	add    %edx,%eax
  102f25:	48                   	dec    %eax
  102f26:	89 45 ac             	mov    %eax,-0x54(%ebp)
  102f29:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f2c:	ba 00 00 00 00       	mov    $0x0,%edx
  102f31:	f7 75 b0             	divl   -0x50(%ebp)
  102f34:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102f37:	29 d0                	sub    %edx,%eax
  102f39:	ba 00 00 00 00       	mov    $0x0,%edx
  102f3e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102f41:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  102f44:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f47:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102f4a:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102f4d:	ba 00 00 00 00       	mov    $0x0,%edx
  102f52:	89 c3                	mov    %eax,%ebx
  102f54:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  102f5a:	89 de                	mov    %ebx,%esi
  102f5c:	89 d0                	mov    %edx,%eax
  102f5e:	83 e0 00             	and    $0x0,%eax
  102f61:	89 c7                	mov    %eax,%edi
  102f63:	89 75 c8             	mov    %esi,-0x38(%ebp)
  102f66:	89 7d cc             	mov    %edi,-0x34(%ebp)
                if (begin < end) {
  102f69:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f6c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f6f:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f72:	77 3e                	ja     102fb2 <page_init+0x3d8>
  102f74:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  102f77:	72 05                	jb     102f7e <page_init+0x3a4>
  102f79:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  102f7c:	73 34                	jae    102fb2 <page_init+0x3d8>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  102f7e:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f81:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102f84:	2b 45 d0             	sub    -0x30(%ebp),%eax
  102f87:	1b 55 d4             	sbb    -0x2c(%ebp),%edx
  102f8a:	89 c1                	mov    %eax,%ecx
  102f8c:	89 d3                	mov    %edx,%ebx
  102f8e:	89 c8                	mov    %ecx,%eax
  102f90:	89 da                	mov    %ebx,%edx
  102f92:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  102f96:	c1 ea 0c             	shr    $0xc,%edx
  102f99:	89 c3                	mov    %eax,%ebx
  102f9b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f9e:	89 04 24             	mov    %eax,(%esp)
  102fa1:	e8 a0 f8 ff ff       	call   102846 <pa2page>
  102fa6:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  102faa:	89 04 24             	mov    %eax,(%esp)
  102fad:	e8 72 fb ff ff       	call   102b24 <init_memmap>
    for (i = 0; i < memmap->nr_map; i ++) {
  102fb2:	ff 45 dc             	incl   -0x24(%ebp)
  102fb5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102fb8:	8b 00                	mov    (%eax),%eax
  102fba:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  102fbd:	0f 8c 89 fe ff ff    	jl     102e4c <page_init+0x272>
                }
            }
        }
    }
}
  102fc3:	90                   	nop
  102fc4:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  102fca:	5b                   	pop    %ebx
  102fcb:	5e                   	pop    %esi
  102fcc:	5f                   	pop    %edi
  102fcd:	5d                   	pop    %ebp
  102fce:	c3                   	ret    

00102fcf <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  102fcf:	55                   	push   %ebp
  102fd0:	89 e5                	mov    %esp,%ebp
  102fd2:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  102fd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  102fd8:	33 45 14             	xor    0x14(%ebp),%eax
  102fdb:	25 ff 0f 00 00       	and    $0xfff,%eax
  102fe0:	85 c0                	test   %eax,%eax
  102fe2:	74 24                	je     103008 <boot_map_segment+0x39>
  102fe4:	c7 44 24 0c 56 67 10 	movl   $0x106756,0xc(%esp)
  102feb:	00 
  102fec:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  102ff3:	00 
  102ff4:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
  102ffb:	00 
  102ffc:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103003:	e8 e1 d3 ff ff       	call   1003e9 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  103008:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  10300f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103012:	25 ff 0f 00 00       	and    $0xfff,%eax
  103017:	89 c2                	mov    %eax,%edx
  103019:	8b 45 10             	mov    0x10(%ebp),%eax
  10301c:	01 c2                	add    %eax,%edx
  10301e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103021:	01 d0                	add    %edx,%eax
  103023:	48                   	dec    %eax
  103024:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10302a:	ba 00 00 00 00       	mov    $0x0,%edx
  10302f:	f7 75 f0             	divl   -0x10(%ebp)
  103032:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103035:	29 d0                	sub    %edx,%eax
  103037:	c1 e8 0c             	shr    $0xc,%eax
  10303a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  10303d:	8b 45 0c             	mov    0xc(%ebp),%eax
  103040:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103043:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103046:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10304b:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  10304e:	8b 45 14             	mov    0x14(%ebp),%eax
  103051:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103054:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10305c:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10305f:	eb 68                	jmp    1030c9 <boot_map_segment+0xfa>
        pte_t *ptep = get_pte(pgdir, la, 1);
  103061:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  103068:	00 
  103069:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306c:	89 44 24 04          	mov    %eax,0x4(%esp)
  103070:	8b 45 08             	mov    0x8(%ebp),%eax
  103073:	89 04 24             	mov    %eax,(%esp)
  103076:	e8 81 01 00 00       	call   1031fc <get_pte>
  10307b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  10307e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  103082:	75 24                	jne    1030a8 <boot_map_segment+0xd9>
  103084:	c7 44 24 0c 82 67 10 	movl   $0x106782,0xc(%esp)
  10308b:	00 
  10308c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103093:	00 
  103094:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
  10309b:	00 
  10309c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1030a3:	e8 41 d3 ff ff       	call   1003e9 <__panic>
        *ptep = pa | PTE_P | perm;
  1030a8:	8b 45 14             	mov    0x14(%ebp),%eax
  1030ab:	0b 45 18             	or     0x18(%ebp),%eax
  1030ae:	83 c8 01             	or     $0x1,%eax
  1030b1:	89 c2                	mov    %eax,%edx
  1030b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1030b6:	89 10                	mov    %edx,(%eax)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1030b8:	ff 4d f4             	decl   -0xc(%ebp)
  1030bb:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  1030c2:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  1030c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030cd:	75 92                	jne    103061 <boot_map_segment+0x92>
    }
}
  1030cf:	90                   	nop
  1030d0:	c9                   	leave  
  1030d1:	c3                   	ret    

001030d2 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  1030d2:	55                   	push   %ebp
  1030d3:	89 e5                	mov    %esp,%ebp
  1030d5:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  1030d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030df:	e8 60 fa ff ff       	call   102b44 <alloc_pages>
  1030e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  1030e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1030eb:	75 1c                	jne    103109 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  1030ed:	c7 44 24 08 8f 67 10 	movl   $0x10678f,0x8(%esp)
  1030f4:	00 
  1030f5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  1030fc:	00 
  1030fd:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103104:	e8 e0 d2 ff ff       	call   1003e9 <__panic>
    }
    return page2kva(p);
  103109:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10310c:	89 04 24             	mov    %eax,(%esp)
  10310f:	e8 81 f7 ff ff       	call   102895 <page2kva>
}
  103114:	c9                   	leave  
  103115:	c3                   	ret    

00103116 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  103116:	55                   	push   %ebp
  103117:	89 e5                	mov    %esp,%ebp
  103119:	83 ec 38             	sub    $0x38,%esp
    // We've already enabled paging
    boot_cr3 = PADDR(boot_pgdir);
  10311c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103121:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103124:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  10312b:	77 23                	ja     103150 <pmm_init+0x3a>
  10312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103130:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103134:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  10313b:	00 
  10313c:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  103143:	00 
  103144:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10314b:	e8 99 d2 ff ff       	call   1003e9 <__panic>
  103150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103153:	05 00 00 00 40       	add    $0x40000000,%eax
  103158:	a3 94 af 11 00       	mov    %eax,0x11af94
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  10315d:	e8 8e f9 ff ff       	call   102af0 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  103162:	e8 73 fa ff ff       	call   102bda <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  103167:	e8 18 04 00 00       	call   103584 <check_alloc_page>

    check_pgdir();
  10316c:	e8 32 04 00 00       	call   1035a3 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  103171:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103176:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103179:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103180:	77 23                	ja     1031a5 <pmm_init+0x8f>
  103182:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103185:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103189:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103190:	00 
  103191:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  103198:	00 
  103199:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1031a0:	e8 44 d2 ff ff       	call   1003e9 <__panic>
  1031a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031a8:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
  1031ae:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1031b3:	05 ac 0f 00 00       	add    $0xfac,%eax
  1031b8:	83 ca 03             	or     $0x3,%edx
  1031bb:	89 10                	mov    %edx,(%eax)

    // map all physical memory to linear memory with base linear addr KERNBASE
    // linear_addr KERNBASE ~ KERNBASE + KMEMSIZE = phy_addr 0 ~ KMEMSIZE
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  1031bd:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1031c2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  1031c9:	00 
  1031ca:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  1031d1:	00 
  1031d2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  1031d9:	38 
  1031da:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  1031e1:	c0 
  1031e2:	89 04 24             	mov    %eax,(%esp)
  1031e5:	e8 e5 fd ff ff       	call   102fcf <boot_map_segment>

    // Since we are using bootloader's GDT,
    // we should reload gdt (second time, the last time) to get user segments and the TSS
    // map virtual_addr 0 ~ 4G = linear_addr 0 ~ 4G
    // then set kernel stack (ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  1031ea:	e8 18 f8 ff ff       	call   102a07 <gdt_init>

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  1031ef:	e8 4b 0a 00 00       	call   103c3f <check_boot_pgdir>

    print_pgdir();
  1031f4:	e8 c4 0e 00 00       	call   1040bd <print_pgdir>

}
  1031f9:	90                   	nop
  1031fa:	c9                   	leave  
  1031fb:	c3                   	ret    

001031fc <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1031fc:	55                   	push   %ebp
  1031fd:	89 e5                	mov    %esp,%ebp
  1031ff:	83 ec 48             	sub    $0x48,%esp
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     *   PTE_W           0x002                   // page table/directory entry flags bit : Writeable
     *   PTE_U           0x004                   // page table/directory entry flags bit : User can access
     */
      // (1) find page directory entry
    pde_t *pde = &pgdir[PDX(la)];
  103202:	8b 45 0c             	mov    0xc(%ebp),%eax
  103205:	c1 e8 16             	shr    $0x16,%eax
  103208:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10320f:	8b 45 08             	mov    0x8(%ebp),%eax
  103212:	01 d0                	add    %edx,%eax
  103214:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(!(*pde & PTE_P)) {
  103217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10321a:	8b 00                	mov    (%eax),%eax
  10321c:	83 e0 01             	and    $0x1,%eax
  10321f:	85 c0                	test   %eax,%eax
  103221:	0f 85 b9 00 00 00    	jne    1032e0 <get_pte+0xe4>
        if(!create)
  103227:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10322b:	75 0a                	jne    103237 <get_pte+0x3b>
            return NULL;
  10322d:	b8 00 00 00 00       	mov    $0x0,%eax
  103232:	e9 14 01 00 00       	jmp    10334b <get_pte+0x14f>
        else {
            struct Page *p;
            p = alloc_page();
  103237:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10323e:	e8 01 f9 ff ff       	call   102b44 <alloc_pages>
  103243:	89 45 f0             	mov    %eax,-0x10(%ebp)
            if(p == NULL) {
  103246:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10324a:	75 0a                	jne    103256 <get_pte+0x5a>
                return NULL;
  10324c:	b8 00 00 00 00       	mov    $0x0,%eax
  103251:	e9 f5 00 00 00       	jmp    10334b <get_pte+0x14f>
            }
            set_page_ref(p, 1);
  103256:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10325d:	00 
  10325e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103261:	89 04 24             	mov    %eax,(%esp)
  103264:	e8 e0 f6 ff ff       	call   102949 <set_page_ref>
            uintptr_t pa = page2pa(p);
  103269:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10326c:	89 04 24             	mov    %eax,(%esp)
  10326f:	e8 bc f5 ff ff       	call   102830 <page2pa>
  103274:	89 45 ec             	mov    %eax,-0x14(%ebp)
            memset(KADDR(pa), 0, PGSIZE);
  103277:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10327a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10327d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103280:	c1 e8 0c             	shr    $0xc,%eax
  103283:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103286:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  10328b:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10328e:	72 23                	jb     1032b3 <get_pte+0xb7>
  103290:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103293:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103297:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  10329e:	00 
  10329f:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
  1032a6:	00 
  1032a7:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1032ae:	e8 36 d1 ff ff       	call   1003e9 <__panic>
  1032b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1032b6:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1032bb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1032c2:	00 
  1032c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1032ca:	00 
  1032cb:	89 04 24             	mov    %eax,(%esp)
  1032ce:	e8 2f 24 00 00       	call   105702 <memset>
            *pde = pa | PTE_P | PTE_U | PTE_W;
  1032d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1032d6:	83 c8 07             	or     $0x7,%eax
  1032d9:	89 c2                	mov    %eax,%edx
  1032db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032de:	89 10                	mov    %edx,(%eax)
        }
    }
    pte_t *pte_base = (pte_t *)KADDR(PDE_ADDR(*pde));
  1032e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1032e3:	8b 00                	mov    (%eax),%eax
  1032e5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1032ea:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1032ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032f0:	c1 e8 0c             	shr    $0xc,%eax
  1032f3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1032f6:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1032fb:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1032fe:	72 23                	jb     103323 <get_pte+0x127>
  103300:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103303:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103307:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  10330e:	00 
  10330f:	c7 44 24 04 6f 01 00 	movl   $0x16f,0x4(%esp)
  103316:	00 
  103317:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10331e:	e8 c6 d0 ff ff       	call   1003e9 <__panic>
  103323:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103326:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10332b:	89 45 d8             	mov    %eax,-0x28(%ebp)
    pte_t *pte_p = &pte_base[PTX(la)];
  10332e:	8b 45 0c             	mov    0xc(%ebp),%eax
  103331:	c1 e8 0c             	shr    $0xc,%eax
  103334:	25 ff 03 00 00       	and    $0x3ff,%eax
  103339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  103340:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103343:	01 d0                	add    %edx,%eax
  103345:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    return pte_p;          // (8) return page table entry
  103348:	8b 45 d4             	mov    -0x2c(%ebp),%eax

}
  10334b:	c9                   	leave  
  10334c:	c3                   	ret    

0010334d <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  10334d:	55                   	push   %ebp
  10334e:	89 e5                	mov    %esp,%ebp
  103350:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103353:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10335a:	00 
  10335b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10335e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103362:	8b 45 08             	mov    0x8(%ebp),%eax
  103365:	89 04 24             	mov    %eax,(%esp)
  103368:	e8 8f fe ff ff       	call   1031fc <get_pte>
  10336d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  103370:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  103374:	74 08                	je     10337e <get_page+0x31>
        *ptep_store = ptep;
  103376:	8b 45 10             	mov    0x10(%ebp),%eax
  103379:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10337c:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  10337e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103382:	74 1b                	je     10339f <get_page+0x52>
  103384:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103387:	8b 00                	mov    (%eax),%eax
  103389:	83 e0 01             	and    $0x1,%eax
  10338c:	85 c0                	test   %eax,%eax
  10338e:	74 0f                	je     10339f <get_page+0x52>
        return pte2page(*ptep);
  103390:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103393:	8b 00                	mov    (%eax),%eax
  103395:	89 04 24             	mov    %eax,(%esp)
  103398:	e8 4c f5 ff ff       	call   1028e9 <pte2page>
  10339d:	eb 05                	jmp    1033a4 <get_page+0x57>
    }
    return NULL;
  10339f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1033a4:	c9                   	leave  
  1033a5:	c3                   	ret    

001033a6 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  1033a6:	55                   	push   %ebp
  1033a7:	89 e5                	mov    %esp,%ebp
  1033a9:	83 ec 28             	sub    $0x28,%esp
     *   tlb_invalidate(pde_t *pgdir, uintptr_t la) : Invalidate a TLB entry, but only if the page tables being
     *                        edited are the ones currently in use by the processor.
     * DEFINEs:
     *   PTE_P           0x001                   // page table/directory entry flags bit : Present
     */
    pte_t *pte = get_pte(pgdir, la, 0);
  1033ac:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1033b3:	00 
  1033b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033b7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1033be:	89 04 24             	mov    %eax,(%esp)
  1033c1:	e8 36 fe ff ff       	call   1031fc <get_pte>
  1033c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (*pte & PTE_P) {                      //(1) check if this page table entry is present
  1033c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1033cc:	8b 00                	mov    (%eax),%eax
  1033ce:	83 e0 01             	and    $0x1,%eax
  1033d1:	85 c0                	test   %eax,%eax
  1033d3:	74 52                	je     103427 <page_remove_pte+0x81>
        struct Page *page = pte2page(*ptep); //(2) find corresponding page to pte
  1033d5:	8b 45 10             	mov    0x10(%ebp),%eax
  1033d8:	8b 00                	mov    (%eax),%eax
  1033da:	89 04 24             	mov    %eax,(%esp)
  1033dd:	e8 07 f5 ff ff       	call   1028e9 <pte2page>
  1033e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
        page_ref_dec(page);        //(3) decrease page reference
  1033e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033e8:	89 04 24             	mov    %eax,(%esp)
  1033eb:	e8 7e f5 ff ff       	call   10296e <page_ref_dec>
        if(page->ref == 0) {
  1033f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033f3:	8b 00                	mov    (%eax),%eax
  1033f5:	85 c0                	test   %eax,%eax
  1033f7:	75 13                	jne    10340c <page_remove_pte+0x66>
            free_page(page);
  1033f9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103400:	00 
  103401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103404:	89 04 24             	mov    %eax,(%esp)
  103407:	e8 70 f7 ff ff       	call   102b7c <free_pages>
        }                          //(4) and free this page when page reference reachs 0
        *pte = 0;                           //(5) clear second page table entry
  10340c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10340f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);                          //(6) flush tlb
  103415:	8b 45 0c             	mov    0xc(%ebp),%eax
  103418:	89 44 24 04          	mov    %eax,0x4(%esp)
  10341c:	8b 45 08             	mov    0x8(%ebp),%eax
  10341f:	89 04 24             	mov    %eax,(%esp)
  103422:	e8 01 01 00 00       	call   103528 <tlb_invalidate>
    }

}
  103427:	90                   	nop
  103428:	c9                   	leave  
  103429:	c3                   	ret    

0010342a <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  10342a:	55                   	push   %ebp
  10342b:	89 e5                	mov    %esp,%ebp
  10342d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  103430:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103437:	00 
  103438:	8b 45 0c             	mov    0xc(%ebp),%eax
  10343b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343f:	8b 45 08             	mov    0x8(%ebp),%eax
  103442:	89 04 24             	mov    %eax,(%esp)
  103445:	e8 b2 fd ff ff       	call   1031fc <get_pte>
  10344a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  10344d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103451:	74 19                	je     10346c <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  103453:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103456:	89 44 24 08          	mov    %eax,0x8(%esp)
  10345a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10345d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103461:	8b 45 08             	mov    0x8(%ebp),%eax
  103464:	89 04 24             	mov    %eax,(%esp)
  103467:	e8 3a ff ff ff       	call   1033a6 <page_remove_pte>
    }
}
  10346c:	90                   	nop
  10346d:	c9                   	leave  
  10346e:	c3                   	ret    

0010346f <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  10346f:	55                   	push   %ebp
  103470:	89 e5                	mov    %esp,%ebp
  103472:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  103475:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  10347c:	00 
  10347d:	8b 45 10             	mov    0x10(%ebp),%eax
  103480:	89 44 24 04          	mov    %eax,0x4(%esp)
  103484:	8b 45 08             	mov    0x8(%ebp),%eax
  103487:	89 04 24             	mov    %eax,(%esp)
  10348a:	e8 6d fd ff ff       	call   1031fc <get_pte>
  10348f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  103492:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103496:	75 0a                	jne    1034a2 <page_insert+0x33>
        return -E_NO_MEM;
  103498:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  10349d:	e9 84 00 00 00       	jmp    103526 <page_insert+0xb7>
    }
    page_ref_inc(page);
  1034a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034a5:	89 04 24             	mov    %eax,(%esp)
  1034a8:	e8 aa f4 ff ff       	call   102957 <page_ref_inc>
    if (*ptep & PTE_P) {
  1034ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034b0:	8b 00                	mov    (%eax),%eax
  1034b2:	83 e0 01             	and    $0x1,%eax
  1034b5:	85 c0                	test   %eax,%eax
  1034b7:	74 3e                	je     1034f7 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  1034b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034bc:	8b 00                	mov    (%eax),%eax
  1034be:	89 04 24             	mov    %eax,(%esp)
  1034c1:	e8 23 f4 ff ff       	call   1028e9 <pte2page>
  1034c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  1034c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034cc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1034cf:	75 0d                	jne    1034de <page_insert+0x6f>
            page_ref_dec(page);
  1034d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034d4:	89 04 24             	mov    %eax,(%esp)
  1034d7:	e8 92 f4 ff ff       	call   10296e <page_ref_dec>
  1034dc:	eb 19                	jmp    1034f7 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  1034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1034e1:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034e5:	8b 45 10             	mov    0x10(%ebp),%eax
  1034e8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  1034ef:	89 04 24             	mov    %eax,(%esp)
  1034f2:	e8 af fe ff ff       	call   1033a6 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  1034f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1034fa:	89 04 24             	mov    %eax,(%esp)
  1034fd:	e8 2e f3 ff ff       	call   102830 <page2pa>
  103502:	0b 45 14             	or     0x14(%ebp),%eax
  103505:	83 c8 01             	or     $0x1,%eax
  103508:	89 c2                	mov    %eax,%edx
  10350a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10350d:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  10350f:	8b 45 10             	mov    0x10(%ebp),%eax
  103512:	89 44 24 04          	mov    %eax,0x4(%esp)
  103516:	8b 45 08             	mov    0x8(%ebp),%eax
  103519:	89 04 24             	mov    %eax,(%esp)
  10351c:	e8 07 00 00 00       	call   103528 <tlb_invalidate>
    return 0;
  103521:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103526:	c9                   	leave  
  103527:	c3                   	ret    

00103528 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  103528:	55                   	push   %ebp
  103529:	89 e5                	mov    %esp,%ebp
  10352b:	83 ec 28             	sub    $0x28,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  10352e:	0f 20 d8             	mov    %cr3,%eax
  103531:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return cr3;
  103534:	8b 55 f0             	mov    -0x10(%ebp),%edx
    if (rcr3() == PADDR(pgdir)) {
  103537:	8b 45 08             	mov    0x8(%ebp),%eax
  10353a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10353d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  103544:	77 23                	ja     103569 <tlb_invalidate+0x41>
  103546:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103549:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10354d:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103554:	00 
  103555:	c7 44 24 04 ce 01 00 	movl   $0x1ce,0x4(%esp)
  10355c:	00 
  10355d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103564:	e8 80 ce ff ff       	call   1003e9 <__panic>
  103569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10356c:	05 00 00 00 40       	add    $0x40000000,%eax
  103571:	39 d0                	cmp    %edx,%eax
  103573:	75 0c                	jne    103581 <tlb_invalidate+0x59>
        invlpg((void *)la);
  103575:	8b 45 0c             	mov    0xc(%ebp),%eax
  103578:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  10357b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10357e:	0f 01 38             	invlpg (%eax)
    }
}
  103581:	90                   	nop
  103582:	c9                   	leave  
  103583:	c3                   	ret    

00103584 <check_alloc_page>:

static void
check_alloc_page(void) {
  103584:	55                   	push   %ebp
  103585:	89 e5                	mov    %esp,%ebp
  103587:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  10358a:	a1 90 af 11 00       	mov    0x11af90,%eax
  10358f:	8b 40 18             	mov    0x18(%eax),%eax
  103592:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  103594:	c7 04 24 a8 67 10 00 	movl   $0x1067a8,(%esp)
  10359b:	e8 f2 cc ff ff       	call   100292 <cprintf>
}
  1035a0:	90                   	nop
  1035a1:	c9                   	leave  
  1035a2:	c3                   	ret    

001035a3 <check_pgdir>:

static void
check_pgdir(void) {
  1035a3:	55                   	push   %ebp
  1035a4:	89 e5                	mov    %esp,%ebp
  1035a6:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  1035a9:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  1035ae:	3d 00 80 03 00       	cmp    $0x38000,%eax
  1035b3:	76 24                	jbe    1035d9 <check_pgdir+0x36>
  1035b5:	c7 44 24 0c c7 67 10 	movl   $0x1067c7,0xc(%esp)
  1035bc:	00 
  1035bd:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1035c4:	00 
  1035c5:	c7 44 24 04 db 01 00 	movl   $0x1db,0x4(%esp)
  1035cc:	00 
  1035cd:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1035d4:	e8 10 ce ff ff       	call   1003e9 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  1035d9:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1035de:	85 c0                	test   %eax,%eax
  1035e0:	74 0e                	je     1035f0 <check_pgdir+0x4d>
  1035e2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1035e7:	25 ff 0f 00 00       	and    $0xfff,%eax
  1035ec:	85 c0                	test   %eax,%eax
  1035ee:	74 24                	je     103614 <check_pgdir+0x71>
  1035f0:	c7 44 24 0c e4 67 10 	movl   $0x1067e4,0xc(%esp)
  1035f7:	00 
  1035f8:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1035ff:	00 
  103600:	c7 44 24 04 dc 01 00 	movl   $0x1dc,0x4(%esp)
  103607:	00 
  103608:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10360f:	e8 d5 cd ff ff       	call   1003e9 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  103614:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103619:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103620:	00 
  103621:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103628:	00 
  103629:	89 04 24             	mov    %eax,(%esp)
  10362c:	e8 1c fd ff ff       	call   10334d <get_page>
  103631:	85 c0                	test   %eax,%eax
  103633:	74 24                	je     103659 <check_pgdir+0xb6>
  103635:	c7 44 24 0c 1c 68 10 	movl   $0x10681c,0xc(%esp)
  10363c:	00 
  10363d:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103644:	00 
  103645:	c7 44 24 04 dd 01 00 	movl   $0x1dd,0x4(%esp)
  10364c:	00 
  10364d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103654:	e8 90 cd ff ff       	call   1003e9 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  103659:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103660:	e8 df f4 ff ff       	call   102b44 <alloc_pages>
  103665:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  103668:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10366d:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103674:	00 
  103675:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10367c:	00 
  10367d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103680:	89 54 24 04          	mov    %edx,0x4(%esp)
  103684:	89 04 24             	mov    %eax,(%esp)
  103687:	e8 e3 fd ff ff       	call   10346f <page_insert>
  10368c:	85 c0                	test   %eax,%eax
  10368e:	74 24                	je     1036b4 <check_pgdir+0x111>
  103690:	c7 44 24 0c 44 68 10 	movl   $0x106844,0xc(%esp)
  103697:	00 
  103698:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10369f:	00 
  1036a0:	c7 44 24 04 e1 01 00 	movl   $0x1e1,0x4(%esp)
  1036a7:	00 
  1036a8:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1036af:	e8 35 cd ff ff       	call   1003e9 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  1036b4:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1036b9:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1036c0:	00 
  1036c1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1036c8:	00 
  1036c9:	89 04 24             	mov    %eax,(%esp)
  1036cc:	e8 2b fb ff ff       	call   1031fc <get_pte>
  1036d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1036d4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1036d8:	75 24                	jne    1036fe <check_pgdir+0x15b>
  1036da:	c7 44 24 0c 70 68 10 	movl   $0x106870,0xc(%esp)
  1036e1:	00 
  1036e2:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1036e9:	00 
  1036ea:	c7 44 24 04 e4 01 00 	movl   $0x1e4,0x4(%esp)
  1036f1:	00 
  1036f2:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1036f9:	e8 eb cc ff ff       	call   1003e9 <__panic>
    assert(pte2page(*ptep) == p1);
  1036fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103701:	8b 00                	mov    (%eax),%eax
  103703:	89 04 24             	mov    %eax,(%esp)
  103706:	e8 de f1 ff ff       	call   1028e9 <pte2page>
  10370b:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10370e:	74 24                	je     103734 <check_pgdir+0x191>
  103710:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103717:	00 
  103718:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  10371f:	00 
  103720:	c7 44 24 04 e5 01 00 	movl   $0x1e5,0x4(%esp)
  103727:	00 
  103728:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  10372f:	e8 b5 cc ff ff       	call   1003e9 <__panic>
    assert(page_ref(p1) == 1);
  103734:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103737:	89 04 24             	mov    %eax,(%esp)
  10373a:	e8 00 f2 ff ff       	call   10293f <page_ref>
  10373f:	83 f8 01             	cmp    $0x1,%eax
  103742:	74 24                	je     103768 <check_pgdir+0x1c5>
  103744:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  10374b:	00 
  10374c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103753:	00 
  103754:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
  10375b:	00 
  10375c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103763:	e8 81 cc ff ff       	call   1003e9 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  103768:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10376d:	8b 00                	mov    (%eax),%eax
  10376f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103774:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103777:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10377a:	c1 e8 0c             	shr    $0xc,%eax
  10377d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103780:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103785:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  103788:	72 23                	jb     1037ad <check_pgdir+0x20a>
  10378a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10378d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103791:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  103798:	00 
  103799:	c7 44 24 04 e8 01 00 	movl   $0x1e8,0x4(%esp)
  1037a0:	00 
  1037a1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1037a8:	e8 3c cc ff ff       	call   1003e9 <__panic>
  1037ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1037b0:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1037b5:	83 c0 04             	add    $0x4,%eax
  1037b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  1037bb:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  1037c0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1037c7:	00 
  1037c8:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  1037cf:	00 
  1037d0:	89 04 24             	mov    %eax,(%esp)
  1037d3:	e8 24 fa ff ff       	call   1031fc <get_pte>
  1037d8:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  1037db:	74 24                	je     103801 <check_pgdir+0x25e>
  1037dd:	c7 44 24 0c c8 68 10 	movl   $0x1068c8,0xc(%esp)
  1037e4:	00 
  1037e5:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1037ec:	00 
  1037ed:	c7 44 24 04 e9 01 00 	movl   $0x1e9,0x4(%esp)
  1037f4:	00 
  1037f5:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1037fc:	e8 e8 cb ff ff       	call   1003e9 <__panic>

    p2 = alloc_page();
  103801:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103808:	e8 37 f3 ff ff       	call   102b44 <alloc_pages>
  10380d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  103810:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103815:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  10381c:	00 
  10381d:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103824:	00 
  103825:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  103828:	89 54 24 04          	mov    %edx,0x4(%esp)
  10382c:	89 04 24             	mov    %eax,(%esp)
  10382f:	e8 3b fc ff ff       	call   10346f <page_insert>
  103834:	85 c0                	test   %eax,%eax
  103836:	74 24                	je     10385c <check_pgdir+0x2b9>
  103838:	c7 44 24 0c f0 68 10 	movl   $0x1068f0,0xc(%esp)
  10383f:	00 
  103840:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103847:	00 
  103848:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  10384f:	00 
  103850:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103857:	e8 8d cb ff ff       	call   1003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  10385c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103861:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103868:	00 
  103869:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103870:	00 
  103871:	89 04 24             	mov    %eax,(%esp)
  103874:	e8 83 f9 ff ff       	call   1031fc <get_pte>
  103879:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10387c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103880:	75 24                	jne    1038a6 <check_pgdir+0x303>
  103882:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  103889:	00 
  10388a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103891:	00 
  103892:	c7 44 24 04 ed 01 00 	movl   $0x1ed,0x4(%esp)
  103899:	00 
  10389a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038a1:	e8 43 cb ff ff       	call   1003e9 <__panic>
    assert(*ptep & PTE_U);
  1038a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038a9:	8b 00                	mov    (%eax),%eax
  1038ab:	83 e0 04             	and    $0x4,%eax
  1038ae:	85 c0                	test   %eax,%eax
  1038b0:	75 24                	jne    1038d6 <check_pgdir+0x333>
  1038b2:	c7 44 24 0c 58 69 10 	movl   $0x106958,0xc(%esp)
  1038b9:	00 
  1038ba:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038c1:	00 
  1038c2:	c7 44 24 04 ee 01 00 	movl   $0x1ee,0x4(%esp)
  1038c9:	00 
  1038ca:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1038d1:	e8 13 cb ff ff       	call   1003e9 <__panic>
    assert(*ptep & PTE_W);
  1038d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1038d9:	8b 00                	mov    (%eax),%eax
  1038db:	83 e0 02             	and    $0x2,%eax
  1038de:	85 c0                	test   %eax,%eax
  1038e0:	75 24                	jne    103906 <check_pgdir+0x363>
  1038e2:	c7 44 24 0c 66 69 10 	movl   $0x106966,0xc(%esp)
  1038e9:	00 
  1038ea:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1038f1:	00 
  1038f2:	c7 44 24 04 ef 01 00 	movl   $0x1ef,0x4(%esp)
  1038f9:	00 
  1038fa:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103901:	e8 e3 ca ff ff       	call   1003e9 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  103906:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  10390b:	8b 00                	mov    (%eax),%eax
  10390d:	83 e0 04             	and    $0x4,%eax
  103910:	85 c0                	test   %eax,%eax
  103912:	75 24                	jne    103938 <check_pgdir+0x395>
  103914:	c7 44 24 0c 74 69 10 	movl   $0x106974,0xc(%esp)
  10391b:	00 
  10391c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103923:	00 
  103924:	c7 44 24 04 f0 01 00 	movl   $0x1f0,0x4(%esp)
  10392b:	00 
  10392c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103933:	e8 b1 ca ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 1);
  103938:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10393b:	89 04 24             	mov    %eax,(%esp)
  10393e:	e8 fc ef ff ff       	call   10293f <page_ref>
  103943:	83 f8 01             	cmp    $0x1,%eax
  103946:	74 24                	je     10396c <check_pgdir+0x3c9>
  103948:	c7 44 24 0c 8a 69 10 	movl   $0x10698a,0xc(%esp)
  10394f:	00 
  103950:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103957:	00 
  103958:	c7 44 24 04 f1 01 00 	movl   $0x1f1,0x4(%esp)
  10395f:	00 
  103960:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103967:	e8 7d ca ff ff       	call   1003e9 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  10396c:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103971:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  103978:	00 
  103979:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  103980:	00 
  103981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103984:	89 54 24 04          	mov    %edx,0x4(%esp)
  103988:	89 04 24             	mov    %eax,(%esp)
  10398b:	e8 df fa ff ff       	call   10346f <page_insert>
  103990:	85 c0                	test   %eax,%eax
  103992:	74 24                	je     1039b8 <check_pgdir+0x415>
  103994:	c7 44 24 0c 9c 69 10 	movl   $0x10699c,0xc(%esp)
  10399b:	00 
  10399c:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1039a3:	00 
  1039a4:	c7 44 24 04 f3 01 00 	movl   $0x1f3,0x4(%esp)
  1039ab:	00 
  1039ac:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1039b3:	e8 31 ca ff ff       	call   1003e9 <__panic>
    assert(page_ref(p1) == 2);
  1039b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1039bb:	89 04 24             	mov    %eax,(%esp)
  1039be:	e8 7c ef ff ff       	call   10293f <page_ref>
  1039c3:	83 f8 02             	cmp    $0x2,%eax
  1039c6:	74 24                	je     1039ec <check_pgdir+0x449>
  1039c8:	c7 44 24 0c c8 69 10 	movl   $0x1069c8,0xc(%esp)
  1039cf:	00 
  1039d0:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  1039d7:	00 
  1039d8:	c7 44 24 04 f4 01 00 	movl   $0x1f4,0x4(%esp)
  1039df:	00 
  1039e0:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  1039e7:	e8 fd c9 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  1039ec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1039ef:	89 04 24             	mov    %eax,(%esp)
  1039f2:	e8 48 ef ff ff       	call   10293f <page_ref>
  1039f7:	85 c0                	test   %eax,%eax
  1039f9:	74 24                	je     103a1f <check_pgdir+0x47c>
  1039fb:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103a02:	00 
  103a03:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a0a:	00 
  103a0b:	c7 44 24 04 f5 01 00 	movl   $0x1f5,0x4(%esp)
  103a12:	00 
  103a13:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a1a:	e8 ca c9 ff ff       	call   1003e9 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  103a1f:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103a24:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103a2b:	00 
  103a2c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103a33:	00 
  103a34:	89 04 24             	mov    %eax,(%esp)
  103a37:	e8 c0 f7 ff ff       	call   1031fc <get_pte>
  103a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103a3f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103a43:	75 24                	jne    103a69 <check_pgdir+0x4c6>
  103a45:	c7 44 24 0c 28 69 10 	movl   $0x106928,0xc(%esp)
  103a4c:	00 
  103a4d:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a54:	00 
  103a55:	c7 44 24 04 f6 01 00 	movl   $0x1f6,0x4(%esp)
  103a5c:	00 
  103a5d:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a64:	e8 80 c9 ff ff       	call   1003e9 <__panic>
    assert(pte2page(*ptep) == p1);
  103a69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103a6c:	8b 00                	mov    (%eax),%eax
  103a6e:	89 04 24             	mov    %eax,(%esp)
  103a71:	e8 73 ee ff ff       	call   1028e9 <pte2page>
  103a76:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  103a79:	74 24                	je     103a9f <check_pgdir+0x4fc>
  103a7b:	c7 44 24 0c 9d 68 10 	movl   $0x10689d,0xc(%esp)
  103a82:	00 
  103a83:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103a8a:	00 
  103a8b:	c7 44 24 04 f7 01 00 	movl   $0x1f7,0x4(%esp)
  103a92:	00 
  103a93:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103a9a:	e8 4a c9 ff ff       	call   1003e9 <__panic>
    assert((*ptep & PTE_U) == 0);
  103a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103aa2:	8b 00                	mov    (%eax),%eax
  103aa4:	83 e0 04             	and    $0x4,%eax
  103aa7:	85 c0                	test   %eax,%eax
  103aa9:	74 24                	je     103acf <check_pgdir+0x52c>
  103aab:	c7 44 24 0c ec 69 10 	movl   $0x1069ec,0xc(%esp)
  103ab2:	00 
  103ab3:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103aba:	00 
  103abb:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
  103ac2:	00 
  103ac3:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103aca:	e8 1a c9 ff ff       	call   1003e9 <__panic>

    page_remove(boot_pgdir, 0x0);
  103acf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103ad4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  103adb:	00 
  103adc:	89 04 24             	mov    %eax,(%esp)
  103adf:	e8 46 f9 ff ff       	call   10342a <page_remove>
    assert(page_ref(p1) == 1);
  103ae4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ae7:	89 04 24             	mov    %eax,(%esp)
  103aea:	e8 50 ee ff ff       	call   10293f <page_ref>
  103aef:	83 f8 01             	cmp    $0x1,%eax
  103af2:	74 24                	je     103b18 <check_pgdir+0x575>
  103af4:	c7 44 24 0c b3 68 10 	movl   $0x1068b3,0xc(%esp)
  103afb:	00 
  103afc:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b03:	00 
  103b04:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  103b0b:	00 
  103b0c:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b13:	e8 d1 c8 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  103b18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b1b:	89 04 24             	mov    %eax,(%esp)
  103b1e:	e8 1c ee ff ff       	call   10293f <page_ref>
  103b23:	85 c0                	test   %eax,%eax
  103b25:	74 24                	je     103b4b <check_pgdir+0x5a8>
  103b27:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103b2e:	00 
  103b2f:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b36:	00 
  103b37:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
  103b3e:	00 
  103b3f:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b46:	e8 9e c8 ff ff       	call   1003e9 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  103b4b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103b50:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  103b57:	00 
  103b58:	89 04 24             	mov    %eax,(%esp)
  103b5b:	e8 ca f8 ff ff       	call   10342a <page_remove>
    assert(page_ref(p1) == 0);
  103b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103b63:	89 04 24             	mov    %eax,(%esp)
  103b66:	e8 d4 ed ff ff       	call   10293f <page_ref>
  103b6b:	85 c0                	test   %eax,%eax
  103b6d:	74 24                	je     103b93 <check_pgdir+0x5f0>
  103b6f:	c7 44 24 0c 01 6a 10 	movl   $0x106a01,0xc(%esp)
  103b76:	00 
  103b77:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103b7e:	00 
  103b7f:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  103b86:	00 
  103b87:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103b8e:	e8 56 c8 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p2) == 0);
  103b93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b96:	89 04 24             	mov    %eax,(%esp)
  103b99:	e8 a1 ed ff ff       	call   10293f <page_ref>
  103b9e:	85 c0                	test   %eax,%eax
  103ba0:	74 24                	je     103bc6 <check_pgdir+0x623>
  103ba2:	c7 44 24 0c da 69 10 	movl   $0x1069da,0xc(%esp)
  103ba9:	00 
  103baa:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103bb1:	00 
  103bb2:	c7 44 24 04 00 02 00 	movl   $0x200,0x4(%esp)
  103bb9:	00 
  103bba:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103bc1:	e8 23 c8 ff ff       	call   1003e9 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  103bc6:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103bcb:	8b 00                	mov    (%eax),%eax
  103bcd:	89 04 24             	mov    %eax,(%esp)
  103bd0:	e8 52 ed ff ff       	call   102927 <pde2page>
  103bd5:	89 04 24             	mov    %eax,(%esp)
  103bd8:	e8 62 ed ff ff       	call   10293f <page_ref>
  103bdd:	83 f8 01             	cmp    $0x1,%eax
  103be0:	74 24                	je     103c06 <check_pgdir+0x663>
  103be2:	c7 44 24 0c 14 6a 10 	movl   $0x106a14,0xc(%esp)
  103be9:	00 
  103bea:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103bf1:	00 
  103bf2:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  103bf9:	00 
  103bfa:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c01:	e8 e3 c7 ff ff       	call   1003e9 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  103c06:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c0b:	8b 00                	mov    (%eax),%eax
  103c0d:	89 04 24             	mov    %eax,(%esp)
  103c10:	e8 12 ed ff ff       	call   102927 <pde2page>
  103c15:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103c1c:	00 
  103c1d:	89 04 24             	mov    %eax,(%esp)
  103c20:	e8 57 ef ff ff       	call   102b7c <free_pages>
    boot_pgdir[0] = 0;
  103c25:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  103c30:	c7 04 24 3b 6a 10 00 	movl   $0x106a3b,(%esp)
  103c37:	e8 56 c6 ff ff       	call   100292 <cprintf>
}
  103c3c:	90                   	nop
  103c3d:	c9                   	leave  
  103c3e:	c3                   	ret    

00103c3f <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  103c3f:	55                   	push   %ebp
  103c40:	89 e5                	mov    %esp,%ebp
  103c42:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  103c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  103c4c:	e9 ca 00 00 00       	jmp    103d1b <check_boot_pgdir+0xdc>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  103c51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103c54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c5a:	c1 e8 0c             	shr    $0xc,%eax
  103c5d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103c60:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103c65:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  103c68:	72 23                	jb     103c8d <check_boot_pgdir+0x4e>
  103c6a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c6d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103c71:	c7 44 24 08 80 66 10 	movl   $0x106680,0x8(%esp)
  103c78:	00 
  103c79:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103c80:	00 
  103c81:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103c88:	e8 5c c7 ff ff       	call   1003e9 <__panic>
  103c8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103c90:	2d 00 00 00 40       	sub    $0x40000000,%eax
  103c95:	89 c2                	mov    %eax,%edx
  103c97:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103c9c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  103ca3:	00 
  103ca4:	89 54 24 04          	mov    %edx,0x4(%esp)
  103ca8:	89 04 24             	mov    %eax,(%esp)
  103cab:	e8 4c f5 ff ff       	call   1031fc <get_pte>
  103cb0:	89 45 dc             	mov    %eax,-0x24(%ebp)
  103cb3:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  103cb7:	75 24                	jne    103cdd <check_boot_pgdir+0x9e>
  103cb9:	c7 44 24 0c 58 6a 10 	movl   $0x106a58,0xc(%esp)
  103cc0:	00 
  103cc1:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103cc8:	00 
  103cc9:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  103cd0:	00 
  103cd1:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103cd8:	e8 0c c7 ff ff       	call   1003e9 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  103cdd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103ce0:	8b 00                	mov    (%eax),%eax
  103ce2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103ce7:	89 c2                	mov    %eax,%edx
  103ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cec:	39 c2                	cmp    %eax,%edx
  103cee:	74 24                	je     103d14 <check_boot_pgdir+0xd5>
  103cf0:	c7 44 24 0c 95 6a 10 	movl   $0x106a95,0xc(%esp)
  103cf7:	00 
  103cf8:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103cff:	00 
  103d00:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  103d07:	00 
  103d08:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d0f:	e8 d5 c6 ff ff       	call   1003e9 <__panic>
    for (i = 0; i < npage; i += PGSIZE) {
  103d14:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  103d1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103d1e:	a1 a0 ae 11 00       	mov    0x11aea0,%eax
  103d23:	39 c2                	cmp    %eax,%edx
  103d25:	0f 82 26 ff ff ff    	jb     103c51 <check_boot_pgdir+0x12>
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  103d2b:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d30:	05 ac 0f 00 00       	add    $0xfac,%eax
  103d35:	8b 00                	mov    (%eax),%eax
  103d37:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d3c:	89 c2                	mov    %eax,%edx
  103d3e:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103d43:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103d46:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  103d4d:	77 23                	ja     103d72 <check_boot_pgdir+0x133>
  103d4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d52:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103d56:	c7 44 24 08 24 67 10 	movl   $0x106724,0x8(%esp)
  103d5d:	00 
  103d5e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  103d65:	00 
  103d66:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d6d:	e8 77 c6 ff ff       	call   1003e9 <__panic>
  103d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103d75:	05 00 00 00 40       	add    $0x40000000,%eax
  103d7a:	39 d0                	cmp    %edx,%eax
  103d7c:	74 24                	je     103da2 <check_boot_pgdir+0x163>
  103d7e:	c7 44 24 0c ac 6a 10 	movl   $0x106aac,0xc(%esp)
  103d85:	00 
  103d86:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103d8d:	00 
  103d8e:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  103d95:	00 
  103d96:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103d9d:	e8 47 c6 ff ff       	call   1003e9 <__panic>

    assert(boot_pgdir[0] == 0);
  103da2:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103da7:	8b 00                	mov    (%eax),%eax
  103da9:	85 c0                	test   %eax,%eax
  103dab:	74 24                	je     103dd1 <check_boot_pgdir+0x192>
  103dad:	c7 44 24 0c e0 6a 10 	movl   $0x106ae0,0xc(%esp)
  103db4:	00 
  103db5:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103dbc:	00 
  103dbd:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  103dc4:	00 
  103dc5:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103dcc:	e8 18 c6 ff ff       	call   1003e9 <__panic>

    struct Page *p;
    p = alloc_page();
  103dd1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103dd8:	e8 67 ed ff ff       	call   102b44 <alloc_pages>
  103ddd:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  103de0:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103de5:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103dec:	00 
  103ded:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  103df4:	00 
  103df5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103df8:	89 54 24 04          	mov    %edx,0x4(%esp)
  103dfc:	89 04 24             	mov    %eax,(%esp)
  103dff:	e8 6b f6 ff ff       	call   10346f <page_insert>
  103e04:	85 c0                	test   %eax,%eax
  103e06:	74 24                	je     103e2c <check_boot_pgdir+0x1ed>
  103e08:	c7 44 24 0c f4 6a 10 	movl   $0x106af4,0xc(%esp)
  103e0f:	00 
  103e10:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e17:	00 
  103e18:	c7 44 24 04 18 02 00 	movl   $0x218,0x4(%esp)
  103e1f:	00 
  103e20:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e27:	e8 bd c5 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p) == 1);
  103e2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103e2f:	89 04 24             	mov    %eax,(%esp)
  103e32:	e8 08 eb ff ff       	call   10293f <page_ref>
  103e37:	83 f8 01             	cmp    $0x1,%eax
  103e3a:	74 24                	je     103e60 <check_boot_pgdir+0x221>
  103e3c:	c7 44 24 0c 22 6b 10 	movl   $0x106b22,0xc(%esp)
  103e43:	00 
  103e44:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e4b:	00 
  103e4c:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  103e53:	00 
  103e54:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103e5b:	e8 89 c5 ff ff       	call   1003e9 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  103e60:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103e65:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  103e6c:	00 
  103e6d:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  103e74:	00 
  103e75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103e78:	89 54 24 04          	mov    %edx,0x4(%esp)
  103e7c:	89 04 24             	mov    %eax,(%esp)
  103e7f:	e8 eb f5 ff ff       	call   10346f <page_insert>
  103e84:	85 c0                	test   %eax,%eax
  103e86:	74 24                	je     103eac <check_boot_pgdir+0x26d>
  103e88:	c7 44 24 0c 34 6b 10 	movl   $0x106b34,0xc(%esp)
  103e8f:	00 
  103e90:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103e97:	00 
  103e98:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  103e9f:	00 
  103ea0:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103ea7:	e8 3d c5 ff ff       	call   1003e9 <__panic>
    assert(page_ref(p) == 2);
  103eac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103eaf:	89 04 24             	mov    %eax,(%esp)
  103eb2:	e8 88 ea ff ff       	call   10293f <page_ref>
  103eb7:	83 f8 02             	cmp    $0x2,%eax
  103eba:	74 24                	je     103ee0 <check_boot_pgdir+0x2a1>
  103ebc:	c7 44 24 0c 6b 6b 10 	movl   $0x106b6b,0xc(%esp)
  103ec3:	00 
  103ec4:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103ecb:	00 
  103ecc:	c7 44 24 04 1b 02 00 	movl   $0x21b,0x4(%esp)
  103ed3:	00 
  103ed4:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103edb:	e8 09 c5 ff ff       	call   1003e9 <__panic>

    const char *str = "ucore: Hello world!!";
  103ee0:	c7 45 e8 7c 6b 10 00 	movl   $0x106b7c,-0x18(%ebp)
    strcpy((void *)0x100, str);
  103ee7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103eea:	89 44 24 04          	mov    %eax,0x4(%esp)
  103eee:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103ef5:	e8 3e 15 00 00       	call   105438 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  103efa:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  103f01:	00 
  103f02:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f09:	e8 a1 15 00 00       	call   1054af <strcmp>
  103f0e:	85 c0                	test   %eax,%eax
  103f10:	74 24                	je     103f36 <check_boot_pgdir+0x2f7>
  103f12:	c7 44 24 0c 94 6b 10 	movl   $0x106b94,0xc(%esp)
  103f19:	00 
  103f1a:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103f21:	00 
  103f22:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
  103f29:	00 
  103f2a:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103f31:	e8 b3 c4 ff ff       	call   1003e9 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  103f36:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f39:	89 04 24             	mov    %eax,(%esp)
  103f3c:	e8 54 e9 ff ff       	call   102895 <page2kva>
  103f41:	05 00 01 00 00       	add    $0x100,%eax
  103f46:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  103f49:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  103f50:	e8 8d 14 00 00       	call   1053e2 <strlen>
  103f55:	85 c0                	test   %eax,%eax
  103f57:	74 24                	je     103f7d <check_boot_pgdir+0x33e>
  103f59:	c7 44 24 0c cc 6b 10 	movl   $0x106bcc,0xc(%esp)
  103f60:	00 
  103f61:	c7 44 24 08 6d 67 10 	movl   $0x10676d,0x8(%esp)
  103f68:	00 
  103f69:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
  103f70:	00 
  103f71:	c7 04 24 48 67 10 00 	movl   $0x106748,(%esp)
  103f78:	e8 6c c4 ff ff       	call   1003e9 <__panic>

    free_page(p);
  103f7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103f84:	00 
  103f85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103f88:	89 04 24             	mov    %eax,(%esp)
  103f8b:	e8 ec eb ff ff       	call   102b7c <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  103f90:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103f95:	8b 00                	mov    (%eax),%eax
  103f97:	89 04 24             	mov    %eax,(%esp)
  103f9a:	e8 88 e9 ff ff       	call   102927 <pde2page>
  103f9f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103fa6:	00 
  103fa7:	89 04 24             	mov    %eax,(%esp)
  103faa:	e8 cd eb ff ff       	call   102b7c <free_pages>
    boot_pgdir[0] = 0;
  103faf:	a1 e0 79 11 00       	mov    0x1179e0,%eax
  103fb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  103fba:	c7 04 24 f0 6b 10 00 	movl   $0x106bf0,(%esp)
  103fc1:	e8 cc c2 ff ff       	call   100292 <cprintf>
}
  103fc6:	90                   	nop
  103fc7:	c9                   	leave  
  103fc8:	c3                   	ret    

00103fc9 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  103fc9:	55                   	push   %ebp
  103fca:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  103fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  103fcf:	83 e0 04             	and    $0x4,%eax
  103fd2:	85 c0                	test   %eax,%eax
  103fd4:	74 04                	je     103fda <perm2str+0x11>
  103fd6:	b0 75                	mov    $0x75,%al
  103fd8:	eb 02                	jmp    103fdc <perm2str+0x13>
  103fda:	b0 2d                	mov    $0x2d,%al
  103fdc:	a2 28 af 11 00       	mov    %al,0x11af28
    str[1] = 'r';
  103fe1:	c6 05 29 af 11 00 72 	movb   $0x72,0x11af29
    str[2] = (perm & PTE_W) ? 'w' : '-';
  103fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  103feb:	83 e0 02             	and    $0x2,%eax
  103fee:	85 c0                	test   %eax,%eax
  103ff0:	74 04                	je     103ff6 <perm2str+0x2d>
  103ff2:	b0 77                	mov    $0x77,%al
  103ff4:	eb 02                	jmp    103ff8 <perm2str+0x2f>
  103ff6:	b0 2d                	mov    $0x2d,%al
  103ff8:	a2 2a af 11 00       	mov    %al,0x11af2a
    str[3] = '\0';
  103ffd:	c6 05 2b af 11 00 00 	movb   $0x0,0x11af2b
    return str;
  104004:	b8 28 af 11 00       	mov    $0x11af28,%eax
}
  104009:	5d                   	pop    %ebp
  10400a:	c3                   	ret    

0010400b <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  10400b:	55                   	push   %ebp
  10400c:	89 e5                	mov    %esp,%ebp
  10400e:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  104011:	8b 45 10             	mov    0x10(%ebp),%eax
  104014:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104017:	72 0d                	jb     104026 <get_pgtable_items+0x1b>
        return 0;
  104019:	b8 00 00 00 00       	mov    $0x0,%eax
  10401e:	e9 98 00 00 00       	jmp    1040bb <get_pgtable_items+0xb0>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  104023:	ff 45 10             	incl   0x10(%ebp)
    while (start < right && !(table[start] & PTE_P)) {
  104026:	8b 45 10             	mov    0x10(%ebp),%eax
  104029:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10402c:	73 18                	jae    104046 <get_pgtable_items+0x3b>
  10402e:	8b 45 10             	mov    0x10(%ebp),%eax
  104031:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104038:	8b 45 14             	mov    0x14(%ebp),%eax
  10403b:	01 d0                	add    %edx,%eax
  10403d:	8b 00                	mov    (%eax),%eax
  10403f:	83 e0 01             	and    $0x1,%eax
  104042:	85 c0                	test   %eax,%eax
  104044:	74 dd                	je     104023 <get_pgtable_items+0x18>
    }
    if (start < right) {
  104046:	8b 45 10             	mov    0x10(%ebp),%eax
  104049:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10404c:	73 68                	jae    1040b6 <get_pgtable_items+0xab>
        if (left_store != NULL) {
  10404e:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  104052:	74 08                	je     10405c <get_pgtable_items+0x51>
            *left_store = start;
  104054:	8b 45 18             	mov    0x18(%ebp),%eax
  104057:	8b 55 10             	mov    0x10(%ebp),%edx
  10405a:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  10405c:	8b 45 10             	mov    0x10(%ebp),%eax
  10405f:	8d 50 01             	lea    0x1(%eax),%edx
  104062:	89 55 10             	mov    %edx,0x10(%ebp)
  104065:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  10406c:	8b 45 14             	mov    0x14(%ebp),%eax
  10406f:	01 d0                	add    %edx,%eax
  104071:	8b 00                	mov    (%eax),%eax
  104073:	83 e0 07             	and    $0x7,%eax
  104076:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  104079:	eb 03                	jmp    10407e <get_pgtable_items+0x73>
            start ++;
  10407b:	ff 45 10             	incl   0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  10407e:	8b 45 10             	mov    0x10(%ebp),%eax
  104081:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104084:	73 1d                	jae    1040a3 <get_pgtable_items+0x98>
  104086:	8b 45 10             	mov    0x10(%ebp),%eax
  104089:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  104090:	8b 45 14             	mov    0x14(%ebp),%eax
  104093:	01 d0                	add    %edx,%eax
  104095:	8b 00                	mov    (%eax),%eax
  104097:	83 e0 07             	and    $0x7,%eax
  10409a:	89 c2                	mov    %eax,%edx
  10409c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10409f:	39 c2                	cmp    %eax,%edx
  1040a1:	74 d8                	je     10407b <get_pgtable_items+0x70>
        }
        if (right_store != NULL) {
  1040a3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1040a7:	74 08                	je     1040b1 <get_pgtable_items+0xa6>
            *right_store = start;
  1040a9:	8b 45 1c             	mov    0x1c(%ebp),%eax
  1040ac:	8b 55 10             	mov    0x10(%ebp),%edx
  1040af:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  1040b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1040b4:	eb 05                	jmp    1040bb <get_pgtable_items+0xb0>
    }
    return 0;
  1040b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1040bb:	c9                   	leave  
  1040bc:	c3                   	ret    

001040bd <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  1040bd:	55                   	push   %ebp
  1040be:	89 e5                	mov    %esp,%ebp
  1040c0:	57                   	push   %edi
  1040c1:	56                   	push   %esi
  1040c2:	53                   	push   %ebx
  1040c3:	83 ec 4c             	sub    $0x4c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  1040c6:	c7 04 24 10 6c 10 00 	movl   $0x106c10,(%esp)
  1040cd:	e8 c0 c1 ff ff       	call   100292 <cprintf>
    size_t left, right = 0, perm;
  1040d2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1040d9:	e9 fa 00 00 00       	jmp    1041d8 <print_pgdir+0x11b>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1040de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1040e1:	89 04 24             	mov    %eax,(%esp)
  1040e4:	e8 e0 fe ff ff       	call   103fc9 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  1040e9:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  1040ec:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1040ef:	29 d1                	sub    %edx,%ecx
  1040f1:	89 ca                	mov    %ecx,%edx
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  1040f3:	89 d6                	mov    %edx,%esi
  1040f5:	c1 e6 16             	shl    $0x16,%esi
  1040f8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040fb:	89 d3                	mov    %edx,%ebx
  1040fd:	c1 e3 16             	shl    $0x16,%ebx
  104100:	8b 55 e0             	mov    -0x20(%ebp),%edx
  104103:	89 d1                	mov    %edx,%ecx
  104105:	c1 e1 16             	shl    $0x16,%ecx
  104108:	8b 7d dc             	mov    -0x24(%ebp),%edi
  10410b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10410e:	29 d7                	sub    %edx,%edi
  104110:	89 fa                	mov    %edi,%edx
  104112:	89 44 24 14          	mov    %eax,0x14(%esp)
  104116:	89 74 24 10          	mov    %esi,0x10(%esp)
  10411a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10411e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104122:	89 54 24 04          	mov    %edx,0x4(%esp)
  104126:	c7 04 24 41 6c 10 00 	movl   $0x106c41,(%esp)
  10412d:	e8 60 c1 ff ff       	call   100292 <cprintf>
        size_t l, r = left * NPTEENTRY;
  104132:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104135:	c1 e0 0a             	shl    $0xa,%eax
  104138:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  10413b:	eb 54                	jmp    104191 <print_pgdir+0xd4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  10413d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104140:	89 04 24             	mov    %eax,(%esp)
  104143:	e8 81 fe ff ff       	call   103fc9 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  104148:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  10414b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10414e:	29 d1                	sub    %edx,%ecx
  104150:	89 ca                	mov    %ecx,%edx
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  104152:	89 d6                	mov    %edx,%esi
  104154:	c1 e6 0c             	shl    $0xc,%esi
  104157:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10415a:	89 d3                	mov    %edx,%ebx
  10415c:	c1 e3 0c             	shl    $0xc,%ebx
  10415f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  104162:	89 d1                	mov    %edx,%ecx
  104164:	c1 e1 0c             	shl    $0xc,%ecx
  104167:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  10416a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  10416d:	29 d7                	sub    %edx,%edi
  10416f:	89 fa                	mov    %edi,%edx
  104171:	89 44 24 14          	mov    %eax,0x14(%esp)
  104175:	89 74 24 10          	mov    %esi,0x10(%esp)
  104179:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  10417d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  104181:	89 54 24 04          	mov    %edx,0x4(%esp)
  104185:	c7 04 24 60 6c 10 00 	movl   $0x106c60,(%esp)
  10418c:	e8 01 c1 ff ff       	call   100292 <cprintf>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  104191:	be 00 00 c0 fa       	mov    $0xfac00000,%esi
  104196:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104199:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10419c:	89 d3                	mov    %edx,%ebx
  10419e:	c1 e3 0a             	shl    $0xa,%ebx
  1041a1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1041a4:	89 d1                	mov    %edx,%ecx
  1041a6:	c1 e1 0a             	shl    $0xa,%ecx
  1041a9:	8d 55 d4             	lea    -0x2c(%ebp),%edx
  1041ac:	89 54 24 14          	mov    %edx,0x14(%esp)
  1041b0:	8d 55 d8             	lea    -0x28(%ebp),%edx
  1041b3:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041b7:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1041bb:	89 44 24 08          	mov    %eax,0x8(%esp)
  1041bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1041c3:	89 0c 24             	mov    %ecx,(%esp)
  1041c6:	e8 40 fe ff ff       	call   10400b <get_pgtable_items>
  1041cb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1041ce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1041d2:	0f 85 65 ff ff ff    	jne    10413d <print_pgdir+0x80>
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  1041d8:	b9 00 b0 fe fa       	mov    $0xfafeb000,%ecx
  1041dd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1041e0:	8d 55 dc             	lea    -0x24(%ebp),%edx
  1041e3:	89 54 24 14          	mov    %edx,0x14(%esp)
  1041e7:	8d 55 e0             	lea    -0x20(%ebp),%edx
  1041ea:	89 54 24 10          	mov    %edx,0x10(%esp)
  1041ee:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1041f2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1041f6:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  1041fd:	00 
  1041fe:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  104205:	e8 01 fe ff ff       	call   10400b <get_pgtable_items>
  10420a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10420d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104211:	0f 85 c7 fe ff ff    	jne    1040de <print_pgdir+0x21>
        }
    }
    cprintf("--------------------- END ---------------------\n");
  104217:	c7 04 24 84 6c 10 00 	movl   $0x106c84,(%esp)
  10421e:	e8 6f c0 ff ff       	call   100292 <cprintf>
}
  104223:	90                   	nop
  104224:	83 c4 4c             	add    $0x4c,%esp
  104227:	5b                   	pop    %ebx
  104228:	5e                   	pop    %esi
  104229:	5f                   	pop    %edi
  10422a:	5d                   	pop    %ebp
  10422b:	c3                   	ret    

0010422c <page2ppn>:
page2ppn(struct Page *page) {
  10422c:	55                   	push   %ebp
  10422d:	89 e5                	mov    %esp,%ebp
    return page - pages;
  10422f:	8b 45 08             	mov    0x8(%ebp),%eax
  104232:	8b 15 98 af 11 00    	mov    0x11af98,%edx
  104238:	29 d0                	sub    %edx,%eax
  10423a:	c1 f8 02             	sar    $0x2,%eax
  10423d:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  104243:	5d                   	pop    %ebp
  104244:	c3                   	ret    

00104245 <page2pa>:
page2pa(struct Page *page) {
  104245:	55                   	push   %ebp
  104246:	89 e5                	mov    %esp,%ebp
  104248:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  10424b:	8b 45 08             	mov    0x8(%ebp),%eax
  10424e:	89 04 24             	mov    %eax,(%esp)
  104251:	e8 d6 ff ff ff       	call   10422c <page2ppn>
  104256:	c1 e0 0c             	shl    $0xc,%eax
}
  104259:	c9                   	leave  
  10425a:	c3                   	ret    

0010425b <page_ref>:
page_ref(struct Page *page) {
  10425b:	55                   	push   %ebp
  10425c:	89 e5                	mov    %esp,%ebp
    return page->ref;
  10425e:	8b 45 08             	mov    0x8(%ebp),%eax
  104261:	8b 00                	mov    (%eax),%eax
}
  104263:	5d                   	pop    %ebp
  104264:	c3                   	ret    

00104265 <set_page_ref>:
set_page_ref(struct Page *page, int val) {
  104265:	55                   	push   %ebp
  104266:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  104268:	8b 45 08             	mov    0x8(%ebp),%eax
  10426b:	8b 55 0c             	mov    0xc(%ebp),%edx
  10426e:	89 10                	mov    %edx,(%eax)
}
  104270:	90                   	nop
  104271:	5d                   	pop    %ebp
  104272:	c3                   	ret    

00104273 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  104273:	55                   	push   %ebp
  104274:	89 e5                	mov    %esp,%ebp
  104276:	83 ec 10             	sub    $0x10,%esp
  104279:	c7 45 fc 9c af 11 00 	movl   $0x11af9c,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  104280:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104283:	8b 55 fc             	mov    -0x4(%ebp),%edx
  104286:	89 50 04             	mov    %edx,0x4(%eax)
  104289:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10428c:	8b 50 04             	mov    0x4(%eax),%edx
  10428f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  104292:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  104294:	c7 05 a4 af 11 00 00 	movl   $0x0,0x11afa4
  10429b:	00 00 00 
}
  10429e:	90                   	nop
  10429f:	c9                   	leave  
  1042a0:	c3                   	ret    

001042a1 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  1042a1:	55                   	push   %ebp
  1042a2:	89 e5                	mov    %esp,%ebp
  1042a4:	83 ec 58             	sub    $0x58,%esp
    assert(n > 0);
  1042a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1042ab:	75 24                	jne    1042d1 <default_init_memmap+0x30>
  1042ad:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  1042b4:	00 
  1042b5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1042bc:	00 
  1042bd:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
  1042c4:	00 
  1042c5:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1042cc:	e8 18 c1 ff ff       	call   1003e9 <__panic>
    struct Page *p = base;
  1042d1:	8b 45 08             	mov    0x8(%ebp),%eax
  1042d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1042d7:	eb 7d                	jmp    104356 <default_init_memmap+0xb5>
        assert(PageReserved(p));
  1042d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1042dc:	83 c0 04             	add    $0x4,%eax
  1042df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1042e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1042e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1042ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1042ef:	0f a3 10             	bt     %edx,(%eax)
  1042f2:	19 c0                	sbb    %eax,%eax
  1042f4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return oldbit != 0;
  1042f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1042fb:	0f 95 c0             	setne  %al
  1042fe:	0f b6 c0             	movzbl %al,%eax
  104301:	85 c0                	test   %eax,%eax
  104303:	75 24                	jne    104329 <default_init_memmap+0x88>
  104305:	c7 44 24 0c e9 6c 10 	movl   $0x106ce9,0xc(%esp)
  10430c:	00 
  10430d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104314:	00 
  104315:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
  10431c:	00 
  10431d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104324:	e8 c0 c0 ff ff       	call   1003e9 <__panic>
        p->flags = p->property = 0;
  104329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10432c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
  104333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104336:	8b 50 08             	mov    0x8(%eax),%edx
  104339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10433c:	89 50 04             	mov    %edx,0x4(%eax)
        set_page_ref(p, 0);
  10433f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104346:	00 
  104347:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10434a:	89 04 24             	mov    %eax,(%esp)
  10434d:	e8 13 ff ff ff       	call   104265 <set_page_ref>
    for (; p != base + n; p ++) {
  104352:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104356:	8b 55 0c             	mov    0xc(%ebp),%edx
  104359:	89 d0                	mov    %edx,%eax
  10435b:	c1 e0 02             	shl    $0x2,%eax
  10435e:	01 d0                	add    %edx,%eax
  104360:	c1 e0 02             	shl    $0x2,%eax
  104363:	89 c2                	mov    %eax,%edx
  104365:	8b 45 08             	mov    0x8(%ebp),%eax
  104368:	01 d0                	add    %edx,%eax
  10436a:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10436d:	0f 85 66 ff ff ff    	jne    1042d9 <default_init_memmap+0x38>
    }
    base->property = n;
  104373:	8b 45 08             	mov    0x8(%ebp),%eax
  104376:	8b 55 0c             	mov    0xc(%ebp),%edx
  104379:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10437c:	8b 45 08             	mov    0x8(%ebp),%eax
  10437f:	83 c0 04             	add    $0x4,%eax
  104382:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
  104389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10438c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10438f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104392:	0f ab 10             	bts    %edx,(%eax)
    nr_free += n;
  104395:	8b 15 a4 af 11 00    	mov    0x11afa4,%edx
  10439b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10439e:	01 d0                	add    %edx,%eax
  1043a0:	a3 a4 af 11 00       	mov    %eax,0x11afa4
    list_add(&free_list, &(base->page_link));
  1043a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1043a8:	83 c0 0c             	add    $0xc,%eax
  1043ab:	c7 45 e4 9c af 11 00 	movl   $0x11af9c,-0x1c(%ebp)
  1043b2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1043b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1043b8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1043bb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1043be:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  1043c1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1043c4:	8b 40 04             	mov    0x4(%eax),%eax
  1043c7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1043ca:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1043cd:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1043d0:	89 55 d0             	mov    %edx,-0x30(%ebp)
  1043d3:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  1043d6:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1043d9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1043dc:	89 10                	mov    %edx,(%eax)
  1043de:	8b 45 cc             	mov    -0x34(%ebp),%eax
  1043e1:	8b 10                	mov    (%eax),%edx
  1043e3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043e6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1043e9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1043ec:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1043ef:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  1043f2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1043f5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  1043f8:	89 10                	mov    %edx,(%eax)
}
  1043fa:	90                   	nop
  1043fb:	c9                   	leave  
  1043fc:	c3                   	ret    

001043fd <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  1043fd:	55                   	push   %ebp
  1043fe:	89 e5                	mov    %esp,%ebp
  104400:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
  104403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  104407:	75 24                	jne    10442d <default_alloc_pages+0x30>
  104409:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  104410:	00 
  104411:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104418:	00 
  104419:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
  104420:	00 
  104421:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104428:	e8 bc bf ff ff       	call   1003e9 <__panic>
    if (n > nr_free) {
  10442d:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104432:	39 45 08             	cmp    %eax,0x8(%ebp)
  104435:	76 0a                	jbe    104441 <default_alloc_pages+0x44>
        return NULL;
  104437:	b8 00 00 00 00       	mov    $0x0,%eax
  10443c:	e9 2a 01 00 00       	jmp    10456b <default_alloc_pages+0x16e>
    }
    struct Page *page = NULL;
  104441:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  104448:	c7 45 f0 9c af 11 00 	movl   $0x11af9c,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  10444f:	eb 1c                	jmp    10446d <default_alloc_pages+0x70>
        struct Page *p = le2page(le, page_link);
  104451:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104454:	83 e8 0c             	sub    $0xc,%eax
  104457:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (p->property >= n) {
  10445a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10445d:	8b 40 08             	mov    0x8(%eax),%eax
  104460:	39 45 08             	cmp    %eax,0x8(%ebp)
  104463:	77 08                	ja     10446d <default_alloc_pages+0x70>
            page = p;
  104465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104468:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  10446b:	eb 18                	jmp    104485 <default_alloc_pages+0x88>
  10446d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104470:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return listelm->next;
  104473:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104476:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104479:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10447c:	81 7d f0 9c af 11 00 	cmpl   $0x11af9c,-0x10(%ebp)
  104483:	75 cc                	jne    104451 <default_alloc_pages+0x54>
        }
    }
    if (page != NULL) {
  104485:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104489:	0f 84 d9 00 00 00    	je     104568 <default_alloc_pages+0x16b>
        list_del(&(page->page_link));
  10448f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104492:	83 c0 0c             	add    $0xc,%eax
  104495:	89 45 e0             	mov    %eax,-0x20(%ebp)
    __list_del(listelm->prev, listelm->next);
  104498:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10449b:	8b 40 04             	mov    0x4(%eax),%eax
  10449e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1044a1:	8b 12                	mov    (%edx),%edx
  1044a3:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1044a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  1044a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1044ac:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1044af:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  1044b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1044b5:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1044b8:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  1044ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044bd:	8b 40 08             	mov    0x8(%eax),%eax
  1044c0:	39 45 08             	cmp    %eax,0x8(%ebp)
  1044c3:	73 7d                	jae    104542 <default_alloc_pages+0x145>
            struct Page *p = page + n;
  1044c5:	8b 55 08             	mov    0x8(%ebp),%edx
  1044c8:	89 d0                	mov    %edx,%eax
  1044ca:	c1 e0 02             	shl    $0x2,%eax
  1044cd:	01 d0                	add    %edx,%eax
  1044cf:	c1 e0 02             	shl    $0x2,%eax
  1044d2:	89 c2                	mov    %eax,%edx
  1044d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044d7:	01 d0                	add    %edx,%eax
  1044d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
            p->property = page->property - n;
  1044dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1044df:	8b 40 08             	mov    0x8(%eax),%eax
  1044e2:	2b 45 08             	sub    0x8(%ebp),%eax
  1044e5:	89 c2                	mov    %eax,%edx
  1044e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044ea:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(&free_list, &(p->page_link));
  1044ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044f0:	83 c0 0c             	add    $0xc,%eax
  1044f3:	c7 45 d4 9c af 11 00 	movl   $0x11af9c,-0x2c(%ebp)
  1044fa:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1044fd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104500:	89 45 cc             	mov    %eax,-0x34(%ebp)
  104503:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104506:	89 45 c8             	mov    %eax,-0x38(%ebp)
    __list_add(elm, listelm, listelm->next);
  104509:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10450c:	8b 40 04             	mov    0x4(%eax),%eax
  10450f:	8b 55 c8             	mov    -0x38(%ebp),%edx
  104512:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  104515:	8b 55 cc             	mov    -0x34(%ebp),%edx
  104518:	89 55 c0             	mov    %edx,-0x40(%ebp)
  10451b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next->prev = elm;
  10451e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104521:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  104524:	89 10                	mov    %edx,(%eax)
  104526:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104529:	8b 10                	mov    (%eax),%edx
  10452b:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10452e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  104531:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104534:	8b 55 bc             	mov    -0x44(%ebp),%edx
  104537:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  10453a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  10453d:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104540:	89 10                	mov    %edx,(%eax)
    }
        nr_free -= n;
  104542:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104547:	2b 45 08             	sub    0x8(%ebp),%eax
  10454a:	a3 a4 af 11 00       	mov    %eax,0x11afa4
        ClearPageProperty(page);
  10454f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104552:	83 c0 04             	add    $0x4,%eax
  104555:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  10455c:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10455f:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104562:	8b 55 b8             	mov    -0x48(%ebp),%edx
  104565:	0f b3 10             	btr    %edx,(%eax)
    }
    return page;
  104568:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10456b:	c9                   	leave  
  10456c:	c3                   	ret    

0010456d <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  10456d:	55                   	push   %ebp
  10456e:	89 e5                	mov    %esp,%ebp
  104570:	81 ec 88 00 00 00    	sub    $0x88,%esp
    assert(n > 0);
  104576:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10457a:	75 24                	jne    1045a0 <default_free_pages+0x33>
  10457c:	c7 44 24 0c b8 6c 10 	movl   $0x106cb8,0xc(%esp)
  104583:	00 
  104584:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10458b:	00 
  10458c:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
  104593:	00 
  104594:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10459b:	e8 49 be ff ff       	call   1003e9 <__panic>
    struct Page *p = base;
  1045a0:	8b 45 08             	mov    0x8(%ebp),%eax
  1045a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
  1045a6:	e9 9d 00 00 00       	jmp    104648 <default_free_pages+0xdb>
        assert(!PageReserved(p) && !PageProperty(p));
  1045ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ae:	83 c0 04             	add    $0x4,%eax
  1045b1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1045b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1045be:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1045c1:	0f a3 10             	bt     %edx,(%eax)
  1045c4:	19 c0                	sbb    %eax,%eax
  1045c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return oldbit != 0;
  1045c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1045cd:	0f 95 c0             	setne  %al
  1045d0:	0f b6 c0             	movzbl %al,%eax
  1045d3:	85 c0                	test   %eax,%eax
  1045d5:	75 2c                	jne    104603 <default_free_pages+0x96>
  1045d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045da:	83 c0 04             	add    $0x4,%eax
  1045dd:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  1045e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1045e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1045ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1045ed:	0f a3 10             	bt     %edx,(%eax)
  1045f0:	19 c0                	sbb    %eax,%eax
  1045f2:	89 45 d8             	mov    %eax,-0x28(%ebp)
    return oldbit != 0;
  1045f5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  1045f9:	0f 95 c0             	setne  %al
  1045fc:	0f b6 c0             	movzbl %al,%eax
  1045ff:	85 c0                	test   %eax,%eax
  104601:	74 24                	je     104627 <default_free_pages+0xba>
  104603:	c7 44 24 0c fc 6c 10 	movl   $0x106cfc,0xc(%esp)
  10460a:	00 
  10460b:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104612:	00 
  104613:	c7 44 24 04 9b 00 00 	movl   $0x9b,0x4(%esp)
  10461a:	00 
  10461b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104622:	e8 c2 bd ff ff       	call   1003e9 <__panic>
        p->flags = 0;
  104627:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10462a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        set_page_ref(p, 0);
  104631:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104638:	00 
  104639:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10463c:	89 04 24             	mov    %eax,(%esp)
  10463f:	e8 21 fc ff ff       	call   104265 <set_page_ref>
    for (; p != base + n; p ++) {
  104644:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  104648:	8b 55 0c             	mov    0xc(%ebp),%edx
  10464b:	89 d0                	mov    %edx,%eax
  10464d:	c1 e0 02             	shl    $0x2,%eax
  104650:	01 d0                	add    %edx,%eax
  104652:	c1 e0 02             	shl    $0x2,%eax
  104655:	89 c2                	mov    %eax,%edx
  104657:	8b 45 08             	mov    0x8(%ebp),%eax
  10465a:	01 d0                	add    %edx,%eax
  10465c:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  10465f:	0f 85 46 ff ff ff    	jne    1045ab <default_free_pages+0x3e>
    }
    base->property = n;
  104665:	8b 45 08             	mov    0x8(%ebp),%eax
  104668:	8b 55 0c             	mov    0xc(%ebp),%edx
  10466b:	89 50 08             	mov    %edx,0x8(%eax)
    SetPageProperty(base);
  10466e:	8b 45 08             	mov    0x8(%ebp),%eax
  104671:	83 c0 04             	add    $0x4,%eax
  104674:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  10467b:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10467e:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104681:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104684:	0f ab 10             	bts    %edx,(%eax)
  104687:	c7 45 d4 9c af 11 00 	movl   $0x11af9c,-0x2c(%ebp)
    return listelm->next;
  10468e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104691:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *le = list_next(&free_list);
  104694:	89 45 f0             	mov    %eax,-0x10(%ebp)
    while (le != &free_list) {
  104697:	e9 08 01 00 00       	jmp    1047a4 <default_free_pages+0x237>
        p = le2page(le, page_link);
  10469c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10469f:	83 e8 0c             	sub    $0xc,%eax
  1046a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1046a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046a8:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1046ab:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1046ae:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
  1046b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (base + base->property == p) {
  1046b4:	8b 45 08             	mov    0x8(%ebp),%eax
  1046b7:	8b 50 08             	mov    0x8(%eax),%edx
  1046ba:	89 d0                	mov    %edx,%eax
  1046bc:	c1 e0 02             	shl    $0x2,%eax
  1046bf:	01 d0                	add    %edx,%eax
  1046c1:	c1 e0 02             	shl    $0x2,%eax
  1046c4:	89 c2                	mov    %eax,%edx
  1046c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1046c9:	01 d0                	add    %edx,%eax
  1046cb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  1046ce:	75 5a                	jne    10472a <default_free_pages+0x1bd>
            base->property += p->property;
  1046d0:	8b 45 08             	mov    0x8(%ebp),%eax
  1046d3:	8b 50 08             	mov    0x8(%eax),%edx
  1046d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046d9:	8b 40 08             	mov    0x8(%eax),%eax
  1046dc:	01 c2                	add    %eax,%edx
  1046de:	8b 45 08             	mov    0x8(%ebp),%eax
  1046e1:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(p);
  1046e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1046e7:	83 c0 04             	add    $0x4,%eax
  1046ea:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  1046f1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1046f4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  1046f7:	8b 55 b8             	mov    -0x48(%ebp),%edx
  1046fa:	0f b3 10             	btr    %edx,(%eax)
            list_del(&(p->page_link));
  1046fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104700:	83 c0 0c             	add    $0xc,%eax
  104703:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    __list_del(listelm->prev, listelm->next);
  104706:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104709:	8b 40 04             	mov    0x4(%eax),%eax
  10470c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10470f:	8b 12                	mov    (%edx),%edx
  104711:	89 55 c0             	mov    %edx,-0x40(%ebp)
  104714:	89 45 bc             	mov    %eax,-0x44(%ebp)
    prev->next = next;
  104717:	8b 45 c0             	mov    -0x40(%ebp),%eax
  10471a:	8b 55 bc             	mov    -0x44(%ebp),%edx
  10471d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  104720:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104723:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104726:	89 10                	mov    %edx,(%eax)
  104728:	eb 7a                	jmp    1047a4 <default_free_pages+0x237>
        }
        else if (p + p->property == base) {
  10472a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10472d:	8b 50 08             	mov    0x8(%eax),%edx
  104730:	89 d0                	mov    %edx,%eax
  104732:	c1 e0 02             	shl    $0x2,%eax
  104735:	01 d0                	add    %edx,%eax
  104737:	c1 e0 02             	shl    $0x2,%eax
  10473a:	89 c2                	mov    %eax,%edx
  10473c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10473f:	01 d0                	add    %edx,%eax
  104741:	39 45 08             	cmp    %eax,0x8(%ebp)
  104744:	75 5e                	jne    1047a4 <default_free_pages+0x237>
            p->property += base->property;
  104746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104749:	8b 50 08             	mov    0x8(%eax),%edx
  10474c:	8b 45 08             	mov    0x8(%ebp),%eax
  10474f:	8b 40 08             	mov    0x8(%eax),%eax
  104752:	01 c2                	add    %eax,%edx
  104754:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104757:	89 50 08             	mov    %edx,0x8(%eax)
            ClearPageProperty(base);
  10475a:	8b 45 08             	mov    0x8(%ebp),%eax
  10475d:	83 c0 04             	add    $0x4,%eax
  104760:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  104767:	89 45 a0             	mov    %eax,-0x60(%ebp)
  10476a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10476d:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  104770:	0f b3 10             	btr    %edx,(%eax)
            base = p;
  104773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104776:	89 45 08             	mov    %eax,0x8(%ebp)
            list_del(&(p->page_link));
  104779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10477c:	83 c0 0c             	add    $0xc,%eax
  10477f:	89 45 b0             	mov    %eax,-0x50(%ebp)
    __list_del(listelm->prev, listelm->next);
  104782:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104785:	8b 40 04             	mov    0x4(%eax),%eax
  104788:	8b 55 b0             	mov    -0x50(%ebp),%edx
  10478b:	8b 12                	mov    (%edx),%edx
  10478d:	89 55 ac             	mov    %edx,-0x54(%ebp)
  104790:	89 45 a8             	mov    %eax,-0x58(%ebp)
    prev->next = next;
  104793:	8b 45 ac             	mov    -0x54(%ebp),%eax
  104796:	8b 55 a8             	mov    -0x58(%ebp),%edx
  104799:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  10479c:	8b 45 a8             	mov    -0x58(%ebp),%eax
  10479f:	8b 55 ac             	mov    -0x54(%ebp),%edx
  1047a2:	89 10                	mov    %edx,(%eax)
    while (le != &free_list) {
  1047a4:	81 7d f0 9c af 11 00 	cmpl   $0x11af9c,-0x10(%ebp)
  1047ab:	0f 85 eb fe ff ff    	jne    10469c <default_free_pages+0x12f>
        }
    }
    nr_free += n;
  1047b1:	8b 15 a4 af 11 00    	mov    0x11afa4,%edx
  1047b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1047ba:	01 d0                	add    %edx,%eax
  1047bc:	a3 a4 af 11 00       	mov    %eax,0x11afa4
    list_add_before(&free_list, &(base->page_link));
  1047c1:	8b 45 08             	mov    0x8(%ebp),%eax
  1047c4:	83 c0 0c             	add    $0xc,%eax
  1047c7:	c7 45 9c 9c af 11 00 	movl   $0x11af9c,-0x64(%ebp)
  1047ce:	89 45 98             	mov    %eax,-0x68(%ebp)
    __list_add(elm, listelm->prev, listelm);
  1047d1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1047d4:	8b 00                	mov    (%eax),%eax
  1047d6:	8b 55 98             	mov    -0x68(%ebp),%edx
  1047d9:	89 55 94             	mov    %edx,-0x6c(%ebp)
  1047dc:	89 45 90             	mov    %eax,-0x70(%ebp)
  1047df:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1047e2:	89 45 8c             	mov    %eax,-0x74(%ebp)
    prev->next = next->prev = elm;
  1047e5:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1047e8:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1047eb:	89 10                	mov    %edx,(%eax)
  1047ed:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1047f0:	8b 10                	mov    (%eax),%edx
  1047f2:	8b 45 90             	mov    -0x70(%ebp),%eax
  1047f5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  1047f8:	8b 45 94             	mov    -0x6c(%ebp),%eax
  1047fb:	8b 55 8c             	mov    -0x74(%ebp),%edx
  1047fe:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  104801:	8b 45 94             	mov    -0x6c(%ebp),%eax
  104804:	8b 55 90             	mov    -0x70(%ebp),%edx
  104807:	89 10                	mov    %edx,(%eax)
}
  104809:	90                   	nop
  10480a:	c9                   	leave  
  10480b:	c3                   	ret    

0010480c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
  10480c:	55                   	push   %ebp
  10480d:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10480f:	a1 a4 af 11 00       	mov    0x11afa4,%eax
}
  104814:	5d                   	pop    %ebp
  104815:	c3                   	ret    

00104816 <basic_check>:

static void
basic_check(void) {
  104816:	55                   	push   %ebp
  104817:	89 e5                	mov    %esp,%ebp
  104819:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  10481c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104826:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104829:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10482c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  10482f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104836:	e8 09 e3 ff ff       	call   102b44 <alloc_pages>
  10483b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  10483e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104842:	75 24                	jne    104868 <basic_check+0x52>
  104844:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  10484b:	00 
  10484c:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104853:	00 
  104854:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  10485b:	00 
  10485c:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104863:	e8 81 bb ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104868:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10486f:	e8 d0 e2 ff ff       	call   102b44 <alloc_pages>
  104874:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104877:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10487b:	75 24                	jne    1048a1 <basic_check+0x8b>
  10487d:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  104884:	00 
  104885:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10488c:	00 
  10488d:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
  104894:	00 
  104895:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10489c:	e8 48 bb ff ff       	call   1003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  1048a1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1048a8:	e8 97 e2 ff ff       	call   102b44 <alloc_pages>
  1048ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1048b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048b4:	75 24                	jne    1048da <basic_check+0xc4>
  1048b6:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  1048bd:	00 
  1048be:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1048c5:	00 
  1048c6:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  1048cd:	00 
  1048ce:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1048d5:	e8 0f bb ff ff       	call   1003e9 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  1048da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048dd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  1048e0:	74 10                	je     1048f2 <basic_check+0xdc>
  1048e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1048e5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048e8:	74 08                	je     1048f2 <basic_check+0xdc>
  1048ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1048ed:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  1048f0:	75 24                	jne    104916 <basic_check+0x100>
  1048f2:	c7 44 24 0c 78 6d 10 	movl   $0x106d78,0xc(%esp)
  1048f9:	00 
  1048fa:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104901:	00 
  104902:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  104909:	00 
  10490a:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104911:	e8 d3 ba ff ff       	call   1003e9 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  104916:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104919:	89 04 24             	mov    %eax,(%esp)
  10491c:	e8 3a f9 ff ff       	call   10425b <page_ref>
  104921:	85 c0                	test   %eax,%eax
  104923:	75 1e                	jne    104943 <basic_check+0x12d>
  104925:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104928:	89 04 24             	mov    %eax,(%esp)
  10492b:	e8 2b f9 ff ff       	call   10425b <page_ref>
  104930:	85 c0                	test   %eax,%eax
  104932:	75 0f                	jne    104943 <basic_check+0x12d>
  104934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104937:	89 04 24             	mov    %eax,(%esp)
  10493a:	e8 1c f9 ff ff       	call   10425b <page_ref>
  10493f:	85 c0                	test   %eax,%eax
  104941:	74 24                	je     104967 <basic_check+0x151>
  104943:	c7 44 24 0c 9c 6d 10 	movl   $0x106d9c,0xc(%esp)
  10494a:	00 
  10494b:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104952:	00 
  104953:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
  10495a:	00 
  10495b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104962:	e8 82 ba ff ff       	call   1003e9 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  104967:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10496a:	89 04 24             	mov    %eax,(%esp)
  10496d:	e8 d3 f8 ff ff       	call   104245 <page2pa>
  104972:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  104978:	c1 e2 0c             	shl    $0xc,%edx
  10497b:	39 d0                	cmp    %edx,%eax
  10497d:	72 24                	jb     1049a3 <basic_check+0x18d>
  10497f:	c7 44 24 0c d8 6d 10 	movl   $0x106dd8,0xc(%esp)
  104986:	00 
  104987:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10498e:	00 
  10498f:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
  104996:	00 
  104997:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10499e:	e8 46 ba ff ff       	call   1003e9 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  1049a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1049a6:	89 04 24             	mov    %eax,(%esp)
  1049a9:	e8 97 f8 ff ff       	call   104245 <page2pa>
  1049ae:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  1049b4:	c1 e2 0c             	shl    $0xc,%edx
  1049b7:	39 d0                	cmp    %edx,%eax
  1049b9:	72 24                	jb     1049df <basic_check+0x1c9>
  1049bb:	c7 44 24 0c f5 6d 10 	movl   $0x106df5,0xc(%esp)
  1049c2:	00 
  1049c3:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1049ca:	00 
  1049cb:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  1049d2:	00 
  1049d3:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1049da:	e8 0a ba ff ff       	call   1003e9 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  1049df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049e2:	89 04 24             	mov    %eax,(%esp)
  1049e5:	e8 5b f8 ff ff       	call   104245 <page2pa>
  1049ea:	8b 15 a0 ae 11 00    	mov    0x11aea0,%edx
  1049f0:	c1 e2 0c             	shl    $0xc,%edx
  1049f3:	39 d0                	cmp    %edx,%eax
  1049f5:	72 24                	jb     104a1b <basic_check+0x205>
  1049f7:	c7 44 24 0c 12 6e 10 	movl   $0x106e12,0xc(%esp)
  1049fe:	00 
  1049ff:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a06:	00 
  104a07:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
  104a0e:	00 
  104a0f:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a16:	e8 ce b9 ff ff       	call   1003e9 <__panic>

    list_entry_t free_list_store = free_list;
  104a1b:	a1 9c af 11 00       	mov    0x11af9c,%eax
  104a20:	8b 15 a0 af 11 00    	mov    0x11afa0,%edx
  104a26:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104a29:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  104a2c:	c7 45 dc 9c af 11 00 	movl   $0x11af9c,-0x24(%ebp)
    elm->prev = elm->next = elm;
  104a33:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a36:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104a39:	89 50 04             	mov    %edx,0x4(%eax)
  104a3c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a3f:	8b 50 04             	mov    0x4(%eax),%edx
  104a42:	8b 45 dc             	mov    -0x24(%ebp),%eax
  104a45:	89 10                	mov    %edx,(%eax)
  104a47:	c7 45 e0 9c af 11 00 	movl   $0x11af9c,-0x20(%ebp)
    return list->next == list;
  104a4e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  104a51:	8b 40 04             	mov    0x4(%eax),%eax
  104a54:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  104a57:	0f 94 c0             	sete   %al
  104a5a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104a5d:	85 c0                	test   %eax,%eax
  104a5f:	75 24                	jne    104a85 <basic_check+0x26f>
  104a61:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104a68:	00 
  104a69:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104a70:	00 
  104a71:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  104a78:	00 
  104a79:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104a80:	e8 64 b9 ff ff       	call   1003e9 <__panic>

    unsigned int nr_free_store = nr_free;
  104a85:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104a8a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  104a8d:	c7 05 a4 af 11 00 00 	movl   $0x0,0x11afa4
  104a94:	00 00 00 

    assert(alloc_page() == NULL);
  104a97:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104a9e:	e8 a1 e0 ff ff       	call   102b44 <alloc_pages>
  104aa3:	85 c0                	test   %eax,%eax
  104aa5:	74 24                	je     104acb <basic_check+0x2b5>
  104aa7:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104aae:	00 
  104aaf:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ab6:	00 
  104ab7:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  104abe:	00 
  104abf:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104ac6:	e8 1e b9 ff ff       	call   1003e9 <__panic>

    free_page(p0);
  104acb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ad2:	00 
  104ad3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104ad6:	89 04 24             	mov    %eax,(%esp)
  104ad9:	e8 9e e0 ff ff       	call   102b7c <free_pages>
    free_page(p1);
  104ade:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104ae5:	00 
  104ae6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ae9:	89 04 24             	mov    %eax,(%esp)
  104aec:	e8 8b e0 ff ff       	call   102b7c <free_pages>
    free_page(p2);
  104af1:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104af8:	00 
  104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104afc:	89 04 24             	mov    %eax,(%esp)
  104aff:	e8 78 e0 ff ff       	call   102b7c <free_pages>
    assert(nr_free == 3);
  104b04:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104b09:	83 f8 03             	cmp    $0x3,%eax
  104b0c:	74 24                	je     104b32 <basic_check+0x31c>
  104b0e:	c7 44 24 0c 5b 6e 10 	movl   $0x106e5b,0xc(%esp)
  104b15:	00 
  104b16:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b1d:	00 
  104b1e:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
  104b25:	00 
  104b26:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b2d:	e8 b7 b8 ff ff       	call   1003e9 <__panic>

    assert((p0 = alloc_page()) != NULL);
  104b32:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b39:	e8 06 e0 ff ff       	call   102b44 <alloc_pages>
  104b3e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104b41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  104b45:	75 24                	jne    104b6b <basic_check+0x355>
  104b47:	c7 44 24 0c 21 6d 10 	movl   $0x106d21,0xc(%esp)
  104b4e:	00 
  104b4f:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b56:	00 
  104b57:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
  104b5e:	00 
  104b5f:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b66:	e8 7e b8 ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_page()) != NULL);
  104b6b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104b72:	e8 cd df ff ff       	call   102b44 <alloc_pages>
  104b77:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b7e:	75 24                	jne    104ba4 <basic_check+0x38e>
  104b80:	c7 44 24 0c 3d 6d 10 	movl   $0x106d3d,0xc(%esp)
  104b87:	00 
  104b88:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104b8f:	00 
  104b90:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
  104b97:	00 
  104b98:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104b9f:	e8 45 b8 ff ff       	call   1003e9 <__panic>
    assert((p2 = alloc_page()) != NULL);
  104ba4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104bab:	e8 94 df ff ff       	call   102b44 <alloc_pages>
  104bb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  104bb3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104bb7:	75 24                	jne    104bdd <basic_check+0x3c7>
  104bb9:	c7 44 24 0c 59 6d 10 	movl   $0x106d59,0xc(%esp)
  104bc0:	00 
  104bc1:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104bc8:	00 
  104bc9:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  104bd0:	00 
  104bd1:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104bd8:	e8 0c b8 ff ff       	call   1003e9 <__panic>

    assert(alloc_page() == NULL);
  104bdd:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104be4:	e8 5b df ff ff       	call   102b44 <alloc_pages>
  104be9:	85 c0                	test   %eax,%eax
  104beb:	74 24                	je     104c11 <basic_check+0x3fb>
  104bed:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104bf4:	00 
  104bf5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104bfc:	00 
  104bfd:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104c04:	00 
  104c05:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c0c:	e8 d8 b7 ff ff       	call   1003e9 <__panic>

    free_page(p0);
  104c11:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104c18:	00 
  104c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c1c:	89 04 24             	mov    %eax,(%esp)
  104c1f:	e8 58 df ff ff       	call   102b7c <free_pages>
  104c24:	c7 45 d8 9c af 11 00 	movl   $0x11af9c,-0x28(%ebp)
  104c2b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  104c2e:	8b 40 04             	mov    0x4(%eax),%eax
  104c31:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  104c34:	0f 94 c0             	sete   %al
  104c37:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  104c3a:	85 c0                	test   %eax,%eax
  104c3c:	74 24                	je     104c62 <basic_check+0x44c>
  104c3e:	c7 44 24 0c 68 6e 10 	movl   $0x106e68,0xc(%esp)
  104c45:	00 
  104c46:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c4d:	00 
  104c4e:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
  104c55:	00 
  104c56:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c5d:	e8 87 b7 ff ff       	call   1003e9 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  104c62:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c69:	e8 d6 de ff ff       	call   102b44 <alloc_pages>
  104c6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104c71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104c74:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  104c77:	74 24                	je     104c9d <basic_check+0x487>
  104c79:	c7 44 24 0c 80 6e 10 	movl   $0x106e80,0xc(%esp)
  104c80:	00 
  104c81:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104c88:	00 
  104c89:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
  104c90:	00 
  104c91:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104c98:	e8 4c b7 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  104c9d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104ca4:	e8 9b de ff ff       	call   102b44 <alloc_pages>
  104ca9:	85 c0                	test   %eax,%eax
  104cab:	74 24                	je     104cd1 <basic_check+0x4bb>
  104cad:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104cb4:	00 
  104cb5:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104cbc:	00 
  104cbd:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
  104cc4:	00 
  104cc5:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104ccc:	e8 18 b7 ff ff       	call   1003e9 <__panic>

    assert(nr_free == 0);
  104cd1:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104cd6:	85 c0                	test   %eax,%eax
  104cd8:	74 24                	je     104cfe <basic_check+0x4e8>
  104cda:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  104ce1:	00 
  104ce2:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ce9:	00 
  104cea:	c7 44 24 04 e4 00 00 	movl   $0xe4,0x4(%esp)
  104cf1:	00 
  104cf2:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104cf9:	e8 eb b6 ff ff       	call   1003e9 <__panic>
    free_list = free_list_store;
  104cfe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104d01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104d04:	a3 9c af 11 00       	mov    %eax,0x11af9c
  104d09:	89 15 a0 af 11 00    	mov    %edx,0x11afa0
    nr_free = nr_free_store;
  104d0f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104d12:	a3 a4 af 11 00       	mov    %eax,0x11afa4

    free_page(p);
  104d17:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d1e:	00 
  104d1f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104d22:	89 04 24             	mov    %eax,(%esp)
  104d25:	e8 52 de ff ff       	call   102b7c <free_pages>
    free_page(p1);
  104d2a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d31:	00 
  104d32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d35:	89 04 24             	mov    %eax,(%esp)
  104d38:	e8 3f de ff ff       	call   102b7c <free_pages>
    free_page(p2);
  104d3d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104d44:	00 
  104d45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104d48:	89 04 24             	mov    %eax,(%esp)
  104d4b:	e8 2c de ff ff       	call   102b7c <free_pages>
}
  104d50:	90                   	nop
  104d51:	c9                   	leave  
  104d52:	c3                   	ret    

00104d53 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  104d53:	55                   	push   %ebp
  104d54:	89 e5                	mov    %esp,%ebp
  104d56:	81 ec 98 00 00 00    	sub    $0x98,%esp
    int count = 0, total = 0;
  104d5c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  104d63:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  104d6a:	c7 45 ec 9c af 11 00 	movl   $0x11af9c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  104d71:	eb 6a                	jmp    104ddd <default_check+0x8a>
        struct Page *p = le2page(le, page_link);
  104d73:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104d76:	83 e8 0c             	sub    $0xc,%eax
  104d79:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(PageProperty(p));
  104d7c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104d7f:	83 c0 04             	add    $0x4,%eax
  104d82:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  104d89:	89 45 cc             	mov    %eax,-0x34(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104d8c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  104d8f:	8b 55 d0             	mov    -0x30(%ebp),%edx
  104d92:	0f a3 10             	bt     %edx,(%eax)
  104d95:	19 c0                	sbb    %eax,%eax
  104d97:	89 45 c8             	mov    %eax,-0x38(%ebp)
    return oldbit != 0;
  104d9a:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  104d9e:	0f 95 c0             	setne  %al
  104da1:	0f b6 c0             	movzbl %al,%eax
  104da4:	85 c0                	test   %eax,%eax
  104da6:	75 24                	jne    104dcc <default_check+0x79>
  104da8:	c7 44 24 0c a6 6e 10 	movl   $0x106ea6,0xc(%esp)
  104daf:	00 
  104db0:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104db7:	00 
  104db8:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
  104dbf:	00 
  104dc0:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104dc7:	e8 1d b6 ff ff       	call   1003e9 <__panic>
        count ++, total += p->property;
  104dcc:	ff 45 f4             	incl   -0xc(%ebp)
  104dcf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  104dd2:	8b 50 08             	mov    0x8(%eax),%edx
  104dd5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104dd8:	01 d0                	add    %edx,%eax
  104dda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104ddd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104de0:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return listelm->next;
  104de3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104de6:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  104de9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104dec:	81 7d ec 9c af 11 00 	cmpl   $0x11af9c,-0x14(%ebp)
  104df3:	0f 85 7a ff ff ff    	jne    104d73 <default_check+0x20>
    }
    assert(total == nr_free_pages());
  104df9:	e8 b1 dd ff ff       	call   102baf <nr_free_pages>
  104dfe:	89 c2                	mov    %eax,%edx
  104e00:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104e03:	39 c2                	cmp    %eax,%edx
  104e05:	74 24                	je     104e2b <default_check+0xd8>
  104e07:	c7 44 24 0c b6 6e 10 	movl   $0x106eb6,0xc(%esp)
  104e0e:	00 
  104e0f:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e16:	00 
  104e17:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  104e1e:	00 
  104e1f:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e26:	e8 be b5 ff ff       	call   1003e9 <__panic>

    basic_check();
  104e2b:	e8 e6 f9 ff ff       	call   104816 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  104e30:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  104e37:	e8 08 dd ff ff       	call   102b44 <alloc_pages>
  104e3c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(p0 != NULL);
  104e3f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  104e43:	75 24                	jne    104e69 <default_check+0x116>
  104e45:	c7 44 24 0c cf 6e 10 	movl   $0x106ecf,0xc(%esp)
  104e4c:	00 
  104e4d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104e54:	00 
  104e55:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  104e5c:	00 
  104e5d:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104e64:	e8 80 b5 ff ff       	call   1003e9 <__panic>
    assert(!PageProperty(p0));
  104e69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104e6c:	83 c0 04             	add    $0x4,%eax
  104e6f:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  104e76:	89 45 bc             	mov    %eax,-0x44(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104e79:	8b 45 bc             	mov    -0x44(%ebp),%eax
  104e7c:	8b 55 c0             	mov    -0x40(%ebp),%edx
  104e7f:	0f a3 10             	bt     %edx,(%eax)
  104e82:	19 c0                	sbb    %eax,%eax
  104e84:	89 45 b8             	mov    %eax,-0x48(%ebp)
    return oldbit != 0;
  104e87:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  104e8b:	0f 95 c0             	setne  %al
  104e8e:	0f b6 c0             	movzbl %al,%eax
  104e91:	85 c0                	test   %eax,%eax
  104e93:	74 24                	je     104eb9 <default_check+0x166>
  104e95:	c7 44 24 0c da 6e 10 	movl   $0x106eda,0xc(%esp)
  104e9c:	00 
  104e9d:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104ea4:	00 
  104ea5:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  104eac:	00 
  104ead:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104eb4:	e8 30 b5 ff ff       	call   1003e9 <__panic>

    list_entry_t free_list_store = free_list;
  104eb9:	a1 9c af 11 00       	mov    0x11af9c,%eax
  104ebe:	8b 15 a0 af 11 00    	mov    0x11afa0,%edx
  104ec4:	89 45 80             	mov    %eax,-0x80(%ebp)
  104ec7:	89 55 84             	mov    %edx,-0x7c(%ebp)
  104eca:	c7 45 b0 9c af 11 00 	movl   $0x11af9c,-0x50(%ebp)
    elm->prev = elm->next = elm;
  104ed1:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104ed4:	8b 55 b0             	mov    -0x50(%ebp),%edx
  104ed7:	89 50 04             	mov    %edx,0x4(%eax)
  104eda:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104edd:	8b 50 04             	mov    0x4(%eax),%edx
  104ee0:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104ee3:	89 10                	mov    %edx,(%eax)
  104ee5:	c7 45 b4 9c af 11 00 	movl   $0x11af9c,-0x4c(%ebp)
    return list->next == list;
  104eec:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  104eef:	8b 40 04             	mov    0x4(%eax),%eax
  104ef2:	39 45 b4             	cmp    %eax,-0x4c(%ebp)
  104ef5:	0f 94 c0             	sete   %al
  104ef8:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  104efb:	85 c0                	test   %eax,%eax
  104efd:	75 24                	jne    104f23 <default_check+0x1d0>
  104eff:	c7 44 24 0c 2f 6e 10 	movl   $0x106e2f,0xc(%esp)
  104f06:	00 
  104f07:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f0e:	00 
  104f0f:	c7 44 24 04 02 01 00 	movl   $0x102,0x4(%esp)
  104f16:	00 
  104f17:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f1e:	e8 c6 b4 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  104f23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104f2a:	e8 15 dc ff ff       	call   102b44 <alloc_pages>
  104f2f:	85 c0                	test   %eax,%eax
  104f31:	74 24                	je     104f57 <default_check+0x204>
  104f33:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  104f3a:	00 
  104f3b:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f42:	00 
  104f43:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
  104f4a:	00 
  104f4b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104f52:	e8 92 b4 ff ff       	call   1003e9 <__panic>

    unsigned int nr_free_store = nr_free;
  104f57:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  104f5c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    nr_free = 0;
  104f5f:	c7 05 a4 af 11 00 00 	movl   $0x0,0x11afa4
  104f66:	00 00 00 

    free_pages(p0 + 2, 3);
  104f69:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104f6c:	83 c0 28             	add    $0x28,%eax
  104f6f:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  104f76:	00 
  104f77:	89 04 24             	mov    %eax,(%esp)
  104f7a:	e8 fd db ff ff       	call   102b7c <free_pages>
    assert(alloc_pages(4) == NULL);
  104f7f:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  104f86:	e8 b9 db ff ff       	call   102b44 <alloc_pages>
  104f8b:	85 c0                	test   %eax,%eax
  104f8d:	74 24                	je     104fb3 <default_check+0x260>
  104f8f:	c7 44 24 0c ec 6e 10 	movl   $0x106eec,0xc(%esp)
  104f96:	00 
  104f97:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104f9e:	00 
  104f9f:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
  104fa6:	00 
  104fa7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  104fae:	e8 36 b4 ff ff       	call   1003e9 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  104fb3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fb6:	83 c0 28             	add    $0x28,%eax
  104fb9:	83 c0 04             	add    $0x4,%eax
  104fbc:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  104fc3:	89 45 a8             	mov    %eax,-0x58(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  104fc6:	8b 45 a8             	mov    -0x58(%ebp),%eax
  104fc9:	8b 55 ac             	mov    -0x54(%ebp),%edx
  104fcc:	0f a3 10             	bt     %edx,(%eax)
  104fcf:	19 c0                	sbb    %eax,%eax
  104fd1:	89 45 a4             	mov    %eax,-0x5c(%ebp)
    return oldbit != 0;
  104fd4:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  104fd8:	0f 95 c0             	setne  %al
  104fdb:	0f b6 c0             	movzbl %al,%eax
  104fde:	85 c0                	test   %eax,%eax
  104fe0:	74 0e                	je     104ff0 <default_check+0x29d>
  104fe2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104fe5:	83 c0 28             	add    $0x28,%eax
  104fe8:	8b 40 08             	mov    0x8(%eax),%eax
  104feb:	83 f8 03             	cmp    $0x3,%eax
  104fee:	74 24                	je     105014 <default_check+0x2c1>
  104ff0:	c7 44 24 0c 04 6f 10 	movl   $0x106f04,0xc(%esp)
  104ff7:	00 
  104ff8:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  104fff:	00 
  105000:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  105007:	00 
  105008:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10500f:	e8 d5 b3 ff ff       	call   1003e9 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  105014:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  10501b:	e8 24 db ff ff       	call   102b44 <alloc_pages>
  105020:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105023:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  105027:	75 24                	jne    10504d <default_check+0x2fa>
  105029:	c7 44 24 0c 30 6f 10 	movl   $0x106f30,0xc(%esp)
  105030:	00 
  105031:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105038:	00 
  105039:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
  105040:	00 
  105041:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105048:	e8 9c b3 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  10504d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105054:	e8 eb da ff ff       	call   102b44 <alloc_pages>
  105059:	85 c0                	test   %eax,%eax
  10505b:	74 24                	je     105081 <default_check+0x32e>
  10505d:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  105064:	00 
  105065:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10506c:	00 
  10506d:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
  105074:	00 
  105075:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10507c:	e8 68 b3 ff ff       	call   1003e9 <__panic>
    assert(p0 + 2 == p1);
  105081:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105084:	83 c0 28             	add    $0x28,%eax
  105087:	39 45 e0             	cmp    %eax,-0x20(%ebp)
  10508a:	74 24                	je     1050b0 <default_check+0x35d>
  10508c:	c7 44 24 0c 4e 6f 10 	movl   $0x106f4e,0xc(%esp)
  105093:	00 
  105094:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10509b:	00 
  10509c:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1050a3:	00 
  1050a4:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1050ab:	e8 39 b3 ff ff       	call   1003e9 <__panic>

    p2 = p0 + 1;
  1050b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050b3:	83 c0 14             	add    $0x14,%eax
  1050b6:	89 45 dc             	mov    %eax,-0x24(%ebp)
    free_page(p0);
  1050b9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050c0:	00 
  1050c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050c4:	89 04 24             	mov    %eax,(%esp)
  1050c7:	e8 b0 da ff ff       	call   102b7c <free_pages>
    free_pages(p1, 3);
  1050cc:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  1050d3:	00 
  1050d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1050d7:	89 04 24             	mov    %eax,(%esp)
  1050da:	e8 9d da ff ff       	call   102b7c <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  1050df:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1050e2:	83 c0 04             	add    $0x4,%eax
  1050e5:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  1050ec:	89 45 9c             	mov    %eax,-0x64(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1050ef:	8b 45 9c             	mov    -0x64(%ebp),%eax
  1050f2:	8b 55 a0             	mov    -0x60(%ebp),%edx
  1050f5:	0f a3 10             	bt     %edx,(%eax)
  1050f8:	19 c0                	sbb    %eax,%eax
  1050fa:	89 45 98             	mov    %eax,-0x68(%ebp)
    return oldbit != 0;
  1050fd:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  105101:	0f 95 c0             	setne  %al
  105104:	0f b6 c0             	movzbl %al,%eax
  105107:	85 c0                	test   %eax,%eax
  105109:	74 0b                	je     105116 <default_check+0x3c3>
  10510b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10510e:	8b 40 08             	mov    0x8(%eax),%eax
  105111:	83 f8 01             	cmp    $0x1,%eax
  105114:	74 24                	je     10513a <default_check+0x3e7>
  105116:	c7 44 24 0c 5c 6f 10 	movl   $0x106f5c,0xc(%esp)
  10511d:	00 
  10511e:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105125:	00 
  105126:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  10512d:	00 
  10512e:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105135:	e8 af b2 ff ff       	call   1003e9 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  10513a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10513d:	83 c0 04             	add    $0x4,%eax
  105140:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  105147:	89 45 90             	mov    %eax,-0x70(%ebp)
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10514a:	8b 45 90             	mov    -0x70(%ebp),%eax
  10514d:	8b 55 94             	mov    -0x6c(%ebp),%edx
  105150:	0f a3 10             	bt     %edx,(%eax)
  105153:	19 c0                	sbb    %eax,%eax
  105155:	89 45 8c             	mov    %eax,-0x74(%ebp)
    return oldbit != 0;
  105158:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  10515c:	0f 95 c0             	setne  %al
  10515f:	0f b6 c0             	movzbl %al,%eax
  105162:	85 c0                	test   %eax,%eax
  105164:	74 0b                	je     105171 <default_check+0x41e>
  105166:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105169:	8b 40 08             	mov    0x8(%eax),%eax
  10516c:	83 f8 03             	cmp    $0x3,%eax
  10516f:	74 24                	je     105195 <default_check+0x442>
  105171:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  105178:	00 
  105179:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105180:	00 
  105181:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
  105188:	00 
  105189:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105190:	e8 54 b2 ff ff       	call   1003e9 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  105195:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10519c:	e8 a3 d9 ff ff       	call   102b44 <alloc_pages>
  1051a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1051a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051a7:	83 e8 14             	sub    $0x14,%eax
  1051aa:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1051ad:	74 24                	je     1051d3 <default_check+0x480>
  1051af:	c7 44 24 0c aa 6f 10 	movl   $0x106faa,0xc(%esp)
  1051b6:	00 
  1051b7:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1051be:	00 
  1051bf:	c7 44 24 04 15 01 00 	movl   $0x115,0x4(%esp)
  1051c6:	00 
  1051c7:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1051ce:	e8 16 b2 ff ff       	call   1003e9 <__panic>
    free_page(p0);
  1051d3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1051da:	00 
  1051db:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1051de:	89 04 24             	mov    %eax,(%esp)
  1051e1:	e8 96 d9 ff ff       	call   102b7c <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  1051e6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  1051ed:	e8 52 d9 ff ff       	call   102b44 <alloc_pages>
  1051f2:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1051f5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1051f8:	83 c0 14             	add    $0x14,%eax
  1051fb:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  1051fe:	74 24                	je     105224 <default_check+0x4d1>
  105200:	c7 44 24 0c c8 6f 10 	movl   $0x106fc8,0xc(%esp)
  105207:	00 
  105208:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10520f:	00 
  105210:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  105217:	00 
  105218:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10521f:	e8 c5 b1 ff ff       	call   1003e9 <__panic>

    free_pages(p0, 2);
  105224:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  10522b:	00 
  10522c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10522f:	89 04 24             	mov    %eax,(%esp)
  105232:	e8 45 d9 ff ff       	call   102b7c <free_pages>
    free_page(p2);
  105237:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10523e:	00 
  10523f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105242:	89 04 24             	mov    %eax,(%esp)
  105245:	e8 32 d9 ff ff       	call   102b7c <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  10524a:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  105251:	e8 ee d8 ff ff       	call   102b44 <alloc_pages>
  105256:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105259:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10525d:	75 24                	jne    105283 <default_check+0x530>
  10525f:	c7 44 24 0c e8 6f 10 	movl   $0x106fe8,0xc(%esp)
  105266:	00 
  105267:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  10526e:	00 
  10526f:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
  105276:	00 
  105277:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  10527e:	e8 66 b1 ff ff       	call   1003e9 <__panic>
    assert(alloc_page() == NULL);
  105283:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10528a:	e8 b5 d8 ff ff       	call   102b44 <alloc_pages>
  10528f:	85 c0                	test   %eax,%eax
  105291:	74 24                	je     1052b7 <default_check+0x564>
  105293:	c7 44 24 0c 46 6e 10 	movl   $0x106e46,0xc(%esp)
  10529a:	00 
  10529b:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052a2:	00 
  1052a3:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
  1052aa:	00 
  1052ab:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052b2:	e8 32 b1 ff ff       	call   1003e9 <__panic>

    assert(nr_free == 0);
  1052b7:	a1 a4 af 11 00       	mov    0x11afa4,%eax
  1052bc:	85 c0                	test   %eax,%eax
  1052be:	74 24                	je     1052e4 <default_check+0x591>
  1052c0:	c7 44 24 0c 99 6e 10 	movl   $0x106e99,0xc(%esp)
  1052c7:	00 
  1052c8:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1052cf:	00 
  1052d0:	c7 44 24 04 1f 01 00 	movl   $0x11f,0x4(%esp)
  1052d7:	00 
  1052d8:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1052df:	e8 05 b1 ff ff       	call   1003e9 <__panic>
    nr_free = nr_free_store;
  1052e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1052e7:	a3 a4 af 11 00       	mov    %eax,0x11afa4

    free_list = free_list_store;
  1052ec:	8b 45 80             	mov    -0x80(%ebp),%eax
  1052ef:	8b 55 84             	mov    -0x7c(%ebp),%edx
  1052f2:	a3 9c af 11 00       	mov    %eax,0x11af9c
  1052f7:	89 15 a0 af 11 00    	mov    %edx,0x11afa0
    free_pages(p0, 5);
  1052fd:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  105304:	00 
  105305:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105308:	89 04 24             	mov    %eax,(%esp)
  10530b:	e8 6c d8 ff ff       	call   102b7c <free_pages>

    le = &free_list;
  105310:	c7 45 ec 9c af 11 00 	movl   $0x11af9c,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  105317:	eb 5a                	jmp    105373 <default_check+0x620>
        assert(le->next->prev == le && le->prev->next == le);
  105319:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10531c:	8b 40 04             	mov    0x4(%eax),%eax
  10531f:	8b 00                	mov    (%eax),%eax
  105321:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105324:	75 0d                	jne    105333 <default_check+0x5e0>
  105326:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105329:	8b 00                	mov    (%eax),%eax
  10532b:	8b 40 04             	mov    0x4(%eax),%eax
  10532e:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  105331:	74 24                	je     105357 <default_check+0x604>
  105333:	c7 44 24 0c 08 70 10 	movl   $0x107008,0xc(%esp)
  10533a:	00 
  10533b:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  105342:	00 
  105343:	c7 44 24 04 27 01 00 	movl   $0x127,0x4(%esp)
  10534a:	00 
  10534b:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  105352:	e8 92 b0 ff ff       	call   1003e9 <__panic>
        struct Page *p = le2page(le, page_link);
  105357:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10535a:	83 e8 0c             	sub    $0xc,%eax
  10535d:	89 45 d8             	mov    %eax,-0x28(%ebp)
        count --, total -= p->property;
  105360:	ff 4d f4             	decl   -0xc(%ebp)
  105363:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105366:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105369:	8b 40 08             	mov    0x8(%eax),%eax
  10536c:	29 c2                	sub    %eax,%edx
  10536e:	89 d0                	mov    %edx,%eax
  105370:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105373:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105376:	89 45 88             	mov    %eax,-0x78(%ebp)
    return listelm->next;
  105379:	8b 45 88             	mov    -0x78(%ebp),%eax
  10537c:	8b 40 04             	mov    0x4(%eax),%eax
    while ((le = list_next(le)) != &free_list) {
  10537f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105382:	81 7d ec 9c af 11 00 	cmpl   $0x11af9c,-0x14(%ebp)
  105389:	75 8e                	jne    105319 <default_check+0x5c6>
    }
    assert(count == 0);
  10538b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10538f:	74 24                	je     1053b5 <default_check+0x662>
  105391:	c7 44 24 0c 35 70 10 	movl   $0x107035,0xc(%esp)
  105398:	00 
  105399:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1053a0:	00 
  1053a1:	c7 44 24 04 2b 01 00 	movl   $0x12b,0x4(%esp)
  1053a8:	00 
  1053a9:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1053b0:	e8 34 b0 ff ff       	call   1003e9 <__panic>
    assert(total == 0);
  1053b5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1053b9:	74 24                	je     1053df <default_check+0x68c>
  1053bb:	c7 44 24 0c 40 70 10 	movl   $0x107040,0xc(%esp)
  1053c2:	00 
  1053c3:	c7 44 24 08 be 6c 10 	movl   $0x106cbe,0x8(%esp)
  1053ca:	00 
  1053cb:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
  1053d2:	00 
  1053d3:	c7 04 24 d3 6c 10 00 	movl   $0x106cd3,(%esp)
  1053da:	e8 0a b0 ff ff       	call   1003e9 <__panic>
}
  1053df:	90                   	nop
  1053e0:	c9                   	leave  
  1053e1:	c3                   	ret    

001053e2 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  1053e2:	55                   	push   %ebp
  1053e3:	89 e5                	mov    %esp,%ebp
  1053e5:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  1053e8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  1053ef:	eb 03                	jmp    1053f4 <strlen+0x12>
        cnt ++;
  1053f1:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  1053f4:	8b 45 08             	mov    0x8(%ebp),%eax
  1053f7:	8d 50 01             	lea    0x1(%eax),%edx
  1053fa:	89 55 08             	mov    %edx,0x8(%ebp)
  1053fd:	0f b6 00             	movzbl (%eax),%eax
  105400:	84 c0                	test   %al,%al
  105402:	75 ed                	jne    1053f1 <strlen+0xf>
    }
    return cnt;
  105404:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105407:	c9                   	leave  
  105408:	c3                   	ret    

00105409 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105409:	55                   	push   %ebp
  10540a:	89 e5                	mov    %esp,%ebp
  10540c:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  10540f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105416:	eb 03                	jmp    10541b <strnlen+0x12>
        cnt ++;
  105418:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  10541b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10541e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105421:	73 10                	jae    105433 <strnlen+0x2a>
  105423:	8b 45 08             	mov    0x8(%ebp),%eax
  105426:	8d 50 01             	lea    0x1(%eax),%edx
  105429:	89 55 08             	mov    %edx,0x8(%ebp)
  10542c:	0f b6 00             	movzbl (%eax),%eax
  10542f:	84 c0                	test   %al,%al
  105431:	75 e5                	jne    105418 <strnlen+0xf>
    }
    return cnt;
  105433:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105436:	c9                   	leave  
  105437:	c3                   	ret    

00105438 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105438:	55                   	push   %ebp
  105439:	89 e5                	mov    %esp,%ebp
  10543b:	57                   	push   %edi
  10543c:	56                   	push   %esi
  10543d:	83 ec 20             	sub    $0x20,%esp
  105440:	8b 45 08             	mov    0x8(%ebp),%eax
  105443:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105446:	8b 45 0c             	mov    0xc(%ebp),%eax
  105449:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  10544c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10544f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105452:	89 d1                	mov    %edx,%ecx
  105454:	89 c2                	mov    %eax,%edx
  105456:	89 ce                	mov    %ecx,%esi
  105458:	89 d7                	mov    %edx,%edi
  10545a:	ac                   	lods   %ds:(%esi),%al
  10545b:	aa                   	stos   %al,%es:(%edi)
  10545c:	84 c0                	test   %al,%al
  10545e:	75 fa                	jne    10545a <strcpy+0x22>
  105460:	89 fa                	mov    %edi,%edx
  105462:	89 f1                	mov    %esi,%ecx
  105464:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105467:	89 55 e8             	mov    %edx,-0x18(%ebp)
  10546a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  10546d:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  105470:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105471:	83 c4 20             	add    $0x20,%esp
  105474:	5e                   	pop    %esi
  105475:	5f                   	pop    %edi
  105476:	5d                   	pop    %ebp
  105477:	c3                   	ret    

00105478 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105478:	55                   	push   %ebp
  105479:	89 e5                	mov    %esp,%ebp
  10547b:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  10547e:	8b 45 08             	mov    0x8(%ebp),%eax
  105481:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105484:	eb 1e                	jmp    1054a4 <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  105486:	8b 45 0c             	mov    0xc(%ebp),%eax
  105489:	0f b6 10             	movzbl (%eax),%edx
  10548c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10548f:	88 10                	mov    %dl,(%eax)
  105491:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105494:	0f b6 00             	movzbl (%eax),%eax
  105497:	84 c0                	test   %al,%al
  105499:	74 03                	je     10549e <strncpy+0x26>
            src ++;
  10549b:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  10549e:	ff 45 fc             	incl   -0x4(%ebp)
  1054a1:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  1054a4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1054a8:	75 dc                	jne    105486 <strncpy+0xe>
    }
    return dst;
  1054aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1054ad:	c9                   	leave  
  1054ae:	c3                   	ret    

001054af <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  1054af:	55                   	push   %ebp
  1054b0:	89 e5                	mov    %esp,%ebp
  1054b2:	57                   	push   %edi
  1054b3:	56                   	push   %esi
  1054b4:	83 ec 20             	sub    $0x20,%esp
  1054b7:	8b 45 08             	mov    0x8(%ebp),%eax
  1054ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1054bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1054c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  1054c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1054c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1054c9:	89 d1                	mov    %edx,%ecx
  1054cb:	89 c2                	mov    %eax,%edx
  1054cd:	89 ce                	mov    %ecx,%esi
  1054cf:	89 d7                	mov    %edx,%edi
  1054d1:	ac                   	lods   %ds:(%esi),%al
  1054d2:	ae                   	scas   %es:(%edi),%al
  1054d3:	75 08                	jne    1054dd <strcmp+0x2e>
  1054d5:	84 c0                	test   %al,%al
  1054d7:	75 f8                	jne    1054d1 <strcmp+0x22>
  1054d9:	31 c0                	xor    %eax,%eax
  1054db:	eb 04                	jmp    1054e1 <strcmp+0x32>
  1054dd:	19 c0                	sbb    %eax,%eax
  1054df:	0c 01                	or     $0x1,%al
  1054e1:	89 fa                	mov    %edi,%edx
  1054e3:	89 f1                	mov    %esi,%ecx
  1054e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1054e8:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  1054eb:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  1054ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  1054f1:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  1054f2:	83 c4 20             	add    $0x20,%esp
  1054f5:	5e                   	pop    %esi
  1054f6:	5f                   	pop    %edi
  1054f7:	5d                   	pop    %ebp
  1054f8:	c3                   	ret    

001054f9 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  1054f9:	55                   	push   %ebp
  1054fa:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  1054fc:	eb 09                	jmp    105507 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  1054fe:	ff 4d 10             	decl   0x10(%ebp)
  105501:	ff 45 08             	incl   0x8(%ebp)
  105504:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105507:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10550b:	74 1a                	je     105527 <strncmp+0x2e>
  10550d:	8b 45 08             	mov    0x8(%ebp),%eax
  105510:	0f b6 00             	movzbl (%eax),%eax
  105513:	84 c0                	test   %al,%al
  105515:	74 10                	je     105527 <strncmp+0x2e>
  105517:	8b 45 08             	mov    0x8(%ebp),%eax
  10551a:	0f b6 10             	movzbl (%eax),%edx
  10551d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105520:	0f b6 00             	movzbl (%eax),%eax
  105523:	38 c2                	cmp    %al,%dl
  105525:	74 d7                	je     1054fe <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105527:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10552b:	74 18                	je     105545 <strncmp+0x4c>
  10552d:	8b 45 08             	mov    0x8(%ebp),%eax
  105530:	0f b6 00             	movzbl (%eax),%eax
  105533:	0f b6 d0             	movzbl %al,%edx
  105536:	8b 45 0c             	mov    0xc(%ebp),%eax
  105539:	0f b6 00             	movzbl (%eax),%eax
  10553c:	0f b6 c0             	movzbl %al,%eax
  10553f:	29 c2                	sub    %eax,%edx
  105541:	89 d0                	mov    %edx,%eax
  105543:	eb 05                	jmp    10554a <strncmp+0x51>
  105545:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10554a:	5d                   	pop    %ebp
  10554b:	c3                   	ret    

0010554c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  10554c:	55                   	push   %ebp
  10554d:	89 e5                	mov    %esp,%ebp
  10554f:	83 ec 04             	sub    $0x4,%esp
  105552:	8b 45 0c             	mov    0xc(%ebp),%eax
  105555:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105558:	eb 13                	jmp    10556d <strchr+0x21>
        if (*s == c) {
  10555a:	8b 45 08             	mov    0x8(%ebp),%eax
  10555d:	0f b6 00             	movzbl (%eax),%eax
  105560:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105563:	75 05                	jne    10556a <strchr+0x1e>
            return (char *)s;
  105565:	8b 45 08             	mov    0x8(%ebp),%eax
  105568:	eb 12                	jmp    10557c <strchr+0x30>
        }
        s ++;
  10556a:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10556d:	8b 45 08             	mov    0x8(%ebp),%eax
  105570:	0f b6 00             	movzbl (%eax),%eax
  105573:	84 c0                	test   %al,%al
  105575:	75 e3                	jne    10555a <strchr+0xe>
    }
    return NULL;
  105577:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10557c:	c9                   	leave  
  10557d:	c3                   	ret    

0010557e <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  10557e:	55                   	push   %ebp
  10557f:	89 e5                	mov    %esp,%ebp
  105581:	83 ec 04             	sub    $0x4,%esp
  105584:	8b 45 0c             	mov    0xc(%ebp),%eax
  105587:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  10558a:	eb 0e                	jmp    10559a <strfind+0x1c>
        if (*s == c) {
  10558c:	8b 45 08             	mov    0x8(%ebp),%eax
  10558f:	0f b6 00             	movzbl (%eax),%eax
  105592:	38 45 fc             	cmp    %al,-0x4(%ebp)
  105595:	74 0f                	je     1055a6 <strfind+0x28>
            break;
        }
        s ++;
  105597:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  10559a:	8b 45 08             	mov    0x8(%ebp),%eax
  10559d:	0f b6 00             	movzbl (%eax),%eax
  1055a0:	84 c0                	test   %al,%al
  1055a2:	75 e8                	jne    10558c <strfind+0xe>
  1055a4:	eb 01                	jmp    1055a7 <strfind+0x29>
            break;
  1055a6:	90                   	nop
    }
    return (char *)s;
  1055a7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  1055aa:	c9                   	leave  
  1055ab:	c3                   	ret    

001055ac <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  1055ac:	55                   	push   %ebp
  1055ad:	89 e5                	mov    %esp,%ebp
  1055af:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  1055b2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  1055b9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  1055c0:	eb 03                	jmp    1055c5 <strtol+0x19>
        s ++;
  1055c2:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  1055c5:	8b 45 08             	mov    0x8(%ebp),%eax
  1055c8:	0f b6 00             	movzbl (%eax),%eax
  1055cb:	3c 20                	cmp    $0x20,%al
  1055cd:	74 f3                	je     1055c2 <strtol+0x16>
  1055cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1055d2:	0f b6 00             	movzbl (%eax),%eax
  1055d5:	3c 09                	cmp    $0x9,%al
  1055d7:	74 e9                	je     1055c2 <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  1055d9:	8b 45 08             	mov    0x8(%ebp),%eax
  1055dc:	0f b6 00             	movzbl (%eax),%eax
  1055df:	3c 2b                	cmp    $0x2b,%al
  1055e1:	75 05                	jne    1055e8 <strtol+0x3c>
        s ++;
  1055e3:	ff 45 08             	incl   0x8(%ebp)
  1055e6:	eb 14                	jmp    1055fc <strtol+0x50>
    }
    else if (*s == '-') {
  1055e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1055eb:	0f b6 00             	movzbl (%eax),%eax
  1055ee:	3c 2d                	cmp    $0x2d,%al
  1055f0:	75 0a                	jne    1055fc <strtol+0x50>
        s ++, neg = 1;
  1055f2:	ff 45 08             	incl   0x8(%ebp)
  1055f5:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  1055fc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105600:	74 06                	je     105608 <strtol+0x5c>
  105602:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105606:	75 22                	jne    10562a <strtol+0x7e>
  105608:	8b 45 08             	mov    0x8(%ebp),%eax
  10560b:	0f b6 00             	movzbl (%eax),%eax
  10560e:	3c 30                	cmp    $0x30,%al
  105610:	75 18                	jne    10562a <strtol+0x7e>
  105612:	8b 45 08             	mov    0x8(%ebp),%eax
  105615:	40                   	inc    %eax
  105616:	0f b6 00             	movzbl (%eax),%eax
  105619:	3c 78                	cmp    $0x78,%al
  10561b:	75 0d                	jne    10562a <strtol+0x7e>
        s += 2, base = 16;
  10561d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105621:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105628:	eb 29                	jmp    105653 <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  10562a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10562e:	75 16                	jne    105646 <strtol+0x9a>
  105630:	8b 45 08             	mov    0x8(%ebp),%eax
  105633:	0f b6 00             	movzbl (%eax),%eax
  105636:	3c 30                	cmp    $0x30,%al
  105638:	75 0c                	jne    105646 <strtol+0x9a>
        s ++, base = 8;
  10563a:	ff 45 08             	incl   0x8(%ebp)
  10563d:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  105644:	eb 0d                	jmp    105653 <strtol+0xa7>
    }
    else if (base == 0) {
  105646:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10564a:	75 07                	jne    105653 <strtol+0xa7>
        base = 10;
  10564c:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  105653:	8b 45 08             	mov    0x8(%ebp),%eax
  105656:	0f b6 00             	movzbl (%eax),%eax
  105659:	3c 2f                	cmp    $0x2f,%al
  10565b:	7e 1b                	jle    105678 <strtol+0xcc>
  10565d:	8b 45 08             	mov    0x8(%ebp),%eax
  105660:	0f b6 00             	movzbl (%eax),%eax
  105663:	3c 39                	cmp    $0x39,%al
  105665:	7f 11                	jg     105678 <strtol+0xcc>
            dig = *s - '0';
  105667:	8b 45 08             	mov    0x8(%ebp),%eax
  10566a:	0f b6 00             	movzbl (%eax),%eax
  10566d:	0f be c0             	movsbl %al,%eax
  105670:	83 e8 30             	sub    $0x30,%eax
  105673:	89 45 f4             	mov    %eax,-0xc(%ebp)
  105676:	eb 48                	jmp    1056c0 <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  105678:	8b 45 08             	mov    0x8(%ebp),%eax
  10567b:	0f b6 00             	movzbl (%eax),%eax
  10567e:	3c 60                	cmp    $0x60,%al
  105680:	7e 1b                	jle    10569d <strtol+0xf1>
  105682:	8b 45 08             	mov    0x8(%ebp),%eax
  105685:	0f b6 00             	movzbl (%eax),%eax
  105688:	3c 7a                	cmp    $0x7a,%al
  10568a:	7f 11                	jg     10569d <strtol+0xf1>
            dig = *s - 'a' + 10;
  10568c:	8b 45 08             	mov    0x8(%ebp),%eax
  10568f:	0f b6 00             	movzbl (%eax),%eax
  105692:	0f be c0             	movsbl %al,%eax
  105695:	83 e8 57             	sub    $0x57,%eax
  105698:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10569b:	eb 23                	jmp    1056c0 <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  10569d:	8b 45 08             	mov    0x8(%ebp),%eax
  1056a0:	0f b6 00             	movzbl (%eax),%eax
  1056a3:	3c 40                	cmp    $0x40,%al
  1056a5:	7e 3b                	jle    1056e2 <strtol+0x136>
  1056a7:	8b 45 08             	mov    0x8(%ebp),%eax
  1056aa:	0f b6 00             	movzbl (%eax),%eax
  1056ad:	3c 5a                	cmp    $0x5a,%al
  1056af:	7f 31                	jg     1056e2 <strtol+0x136>
            dig = *s - 'A' + 10;
  1056b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1056b4:	0f b6 00             	movzbl (%eax),%eax
  1056b7:	0f be c0             	movsbl %al,%eax
  1056ba:	83 e8 37             	sub    $0x37,%eax
  1056bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  1056c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  1056c6:	7d 19                	jge    1056e1 <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  1056c8:	ff 45 08             	incl   0x8(%ebp)
  1056cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  1056d2:	89 c2                	mov    %eax,%edx
  1056d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1056d7:	01 d0                	add    %edx,%eax
  1056d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  1056dc:	e9 72 ff ff ff       	jmp    105653 <strtol+0xa7>
            break;
  1056e1:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  1056e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1056e6:	74 08                	je     1056f0 <strtol+0x144>
        *endptr = (char *) s;
  1056e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1056eb:	8b 55 08             	mov    0x8(%ebp),%edx
  1056ee:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1056f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1056f4:	74 07                	je     1056fd <strtol+0x151>
  1056f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1056f9:	f7 d8                	neg    %eax
  1056fb:	eb 03                	jmp    105700 <strtol+0x154>
  1056fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  105700:	c9                   	leave  
  105701:	c3                   	ret    

00105702 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  105702:	55                   	push   %ebp
  105703:	89 e5                	mov    %esp,%ebp
  105705:	57                   	push   %edi
  105706:	83 ec 24             	sub    $0x24,%esp
  105709:	8b 45 0c             	mov    0xc(%ebp),%eax
  10570c:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  10570f:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  105713:	8b 55 08             	mov    0x8(%ebp),%edx
  105716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  105719:	88 45 f7             	mov    %al,-0x9(%ebp)
  10571c:	8b 45 10             	mov    0x10(%ebp),%eax
  10571f:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  105722:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  105725:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  105729:	8b 55 f8             	mov    -0x8(%ebp),%edx
  10572c:	89 d7                	mov    %edx,%edi
  10572e:	f3 aa                	rep stos %al,%es:(%edi)
  105730:	89 fa                	mov    %edi,%edx
  105732:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  105735:	89 55 e8             	mov    %edx,-0x18(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  105738:	8b 45 f8             	mov    -0x8(%ebp),%eax
  10573b:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10573c:	83 c4 24             	add    $0x24,%esp
  10573f:	5f                   	pop    %edi
  105740:	5d                   	pop    %ebp
  105741:	c3                   	ret    

00105742 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  105742:	55                   	push   %ebp
  105743:	89 e5                	mov    %esp,%ebp
  105745:	57                   	push   %edi
  105746:	56                   	push   %esi
  105747:	53                   	push   %ebx
  105748:	83 ec 30             	sub    $0x30,%esp
  10574b:	8b 45 08             	mov    0x8(%ebp),%eax
  10574e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105751:	8b 45 0c             	mov    0xc(%ebp),%eax
  105754:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105757:	8b 45 10             	mov    0x10(%ebp),%eax
  10575a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10575d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105760:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  105763:	73 42                	jae    1057a7 <memmove+0x65>
  105765:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105768:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10576b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10576e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105771:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105774:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  105777:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10577a:	c1 e8 02             	shr    $0x2,%eax
  10577d:	89 c1                	mov    %eax,%ecx
    asm volatile (
  10577f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105782:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105785:	89 d7                	mov    %edx,%edi
  105787:	89 c6                	mov    %eax,%esi
  105789:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  10578b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  10578e:	83 e1 03             	and    $0x3,%ecx
  105791:	74 02                	je     105795 <memmove+0x53>
  105793:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  105795:	89 f0                	mov    %esi,%eax
  105797:	89 fa                	mov    %edi,%edx
  105799:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  10579c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10579f:	89 45 d0             	mov    %eax,-0x30(%ebp)
        : "memory");
    return dst;
  1057a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  1057a5:	eb 36                	jmp    1057dd <memmove+0x9b>
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  1057a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057aa:	8d 50 ff             	lea    -0x1(%eax),%edx
  1057ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1057b0:	01 c2                	add    %eax,%edx
  1057b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057b5:	8d 48 ff             	lea    -0x1(%eax),%ecx
  1057b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1057bb:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  1057be:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1057c1:	89 c1                	mov    %eax,%ecx
  1057c3:	89 d8                	mov    %ebx,%eax
  1057c5:	89 d6                	mov    %edx,%esi
  1057c7:	89 c7                	mov    %eax,%edi
  1057c9:	fd                   	std    
  1057ca:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1057cc:	fc                   	cld    
  1057cd:	89 f8                	mov    %edi,%eax
  1057cf:	89 f2                	mov    %esi,%edx
  1057d1:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1057d4:	89 55 c8             	mov    %edx,-0x38(%ebp)
  1057d7:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  1057da:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1057dd:	83 c4 30             	add    $0x30,%esp
  1057e0:	5b                   	pop    %ebx
  1057e1:	5e                   	pop    %esi
  1057e2:	5f                   	pop    %edi
  1057e3:	5d                   	pop    %ebp
  1057e4:	c3                   	ret    

001057e5 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1057e5:	55                   	push   %ebp
  1057e6:	89 e5                	mov    %esp,%ebp
  1057e8:	57                   	push   %edi
  1057e9:	56                   	push   %esi
  1057ea:	83 ec 20             	sub    $0x20,%esp
  1057ed:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1057f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1057f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1057fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1057ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105802:	c1 e8 02             	shr    $0x2,%eax
  105805:	89 c1                	mov    %eax,%ecx
    asm volatile (
  105807:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10580a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10580d:	89 d7                	mov    %edx,%edi
  10580f:	89 c6                	mov    %eax,%esi
  105811:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  105813:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  105816:	83 e1 03             	and    $0x3,%ecx
  105819:	74 02                	je     10581d <memcpy+0x38>
  10581b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10581d:	89 f0                	mov    %esi,%eax
  10581f:	89 fa                	mov    %edi,%edx
  105821:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  105824:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  105827:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  10582a:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  10582d:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10582e:	83 c4 20             	add    $0x20,%esp
  105831:	5e                   	pop    %esi
  105832:	5f                   	pop    %edi
  105833:	5d                   	pop    %ebp
  105834:	c3                   	ret    

00105835 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  105835:	55                   	push   %ebp
  105836:	89 e5                	mov    %esp,%ebp
  105838:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  10583b:	8b 45 08             	mov    0x8(%ebp),%eax
  10583e:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  105841:	8b 45 0c             	mov    0xc(%ebp),%eax
  105844:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  105847:	eb 2e                	jmp    105877 <memcmp+0x42>
        if (*s1 != *s2) {
  105849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10584c:	0f b6 10             	movzbl (%eax),%edx
  10584f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105852:	0f b6 00             	movzbl (%eax),%eax
  105855:	38 c2                	cmp    %al,%dl
  105857:	74 18                	je     105871 <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  105859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10585c:	0f b6 00             	movzbl (%eax),%eax
  10585f:	0f b6 d0             	movzbl %al,%edx
  105862:	8b 45 f8             	mov    -0x8(%ebp),%eax
  105865:	0f b6 00             	movzbl (%eax),%eax
  105868:	0f b6 c0             	movzbl %al,%eax
  10586b:	29 c2                	sub    %eax,%edx
  10586d:	89 d0                	mov    %edx,%eax
  10586f:	eb 18                	jmp    105889 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  105871:	ff 45 fc             	incl   -0x4(%ebp)
  105874:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  105877:	8b 45 10             	mov    0x10(%ebp),%eax
  10587a:	8d 50 ff             	lea    -0x1(%eax),%edx
  10587d:	89 55 10             	mov    %edx,0x10(%ebp)
  105880:	85 c0                	test   %eax,%eax
  105882:	75 c5                	jne    105849 <memcmp+0x14>
    }
    return 0;
  105884:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105889:	c9                   	leave  
  10588a:	c3                   	ret    

0010588b <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  10588b:	55                   	push   %ebp
  10588c:	89 e5                	mov    %esp,%ebp
  10588e:	83 ec 58             	sub    $0x58,%esp
  105891:	8b 45 10             	mov    0x10(%ebp),%eax
  105894:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105897:	8b 45 14             	mov    0x14(%ebp),%eax
  10589a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  10589d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1058a0:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1058a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058a6:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1058a9:	8b 45 18             	mov    0x18(%ebp),%eax
  1058ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1058af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1058b2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1058b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058b8:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1058bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1058c1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  1058c5:	74 1c                	je     1058e3 <printnum+0x58>
  1058c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058ca:	ba 00 00 00 00       	mov    $0x0,%edx
  1058cf:	f7 75 e4             	divl   -0x1c(%ebp)
  1058d2:	89 55 f4             	mov    %edx,-0xc(%ebp)
  1058d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1058d8:	ba 00 00 00 00       	mov    $0x0,%edx
  1058dd:	f7 75 e4             	divl   -0x1c(%ebp)
  1058e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1058e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058e6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1058e9:	f7 75 e4             	divl   -0x1c(%ebp)
  1058ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1058ef:	89 55 dc             	mov    %edx,-0x24(%ebp)
  1058f2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1058f5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1058f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1058fb:	89 55 ec             	mov    %edx,-0x14(%ebp)
  1058fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105901:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  105904:	8b 45 18             	mov    0x18(%ebp),%eax
  105907:	ba 00 00 00 00       	mov    $0x0,%edx
  10590c:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10590f:	72 56                	jb     105967 <printnum+0xdc>
  105911:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  105914:	77 05                	ja     10591b <printnum+0x90>
  105916:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  105919:	72 4c                	jb     105967 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  10591b:	8b 45 1c             	mov    0x1c(%ebp),%eax
  10591e:	8d 50 ff             	lea    -0x1(%eax),%edx
  105921:	8b 45 20             	mov    0x20(%ebp),%eax
  105924:	89 44 24 18          	mov    %eax,0x18(%esp)
  105928:	89 54 24 14          	mov    %edx,0x14(%esp)
  10592c:	8b 45 18             	mov    0x18(%ebp),%eax
  10592f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105933:	8b 45 e8             	mov    -0x18(%ebp),%eax
  105936:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105939:	89 44 24 08          	mov    %eax,0x8(%esp)
  10593d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105941:	8b 45 0c             	mov    0xc(%ebp),%eax
  105944:	89 44 24 04          	mov    %eax,0x4(%esp)
  105948:	8b 45 08             	mov    0x8(%ebp),%eax
  10594b:	89 04 24             	mov    %eax,(%esp)
  10594e:	e8 38 ff ff ff       	call   10588b <printnum>
  105953:	eb 1b                	jmp    105970 <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  105955:	8b 45 0c             	mov    0xc(%ebp),%eax
  105958:	89 44 24 04          	mov    %eax,0x4(%esp)
  10595c:	8b 45 20             	mov    0x20(%ebp),%eax
  10595f:	89 04 24             	mov    %eax,(%esp)
  105962:	8b 45 08             	mov    0x8(%ebp),%eax
  105965:	ff d0                	call   *%eax
        while (-- width > 0)
  105967:	ff 4d 1c             	decl   0x1c(%ebp)
  10596a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10596e:	7f e5                	jg     105955 <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  105970:	8b 45 d8             	mov    -0x28(%ebp),%eax
  105973:	05 fc 70 10 00       	add    $0x1070fc,%eax
  105978:	0f b6 00             	movzbl (%eax),%eax
  10597b:	0f be c0             	movsbl %al,%eax
  10597e:	8b 55 0c             	mov    0xc(%ebp),%edx
  105981:	89 54 24 04          	mov    %edx,0x4(%esp)
  105985:	89 04 24             	mov    %eax,(%esp)
  105988:	8b 45 08             	mov    0x8(%ebp),%eax
  10598b:	ff d0                	call   *%eax
}
  10598d:	90                   	nop
  10598e:	c9                   	leave  
  10598f:	c3                   	ret    

00105990 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  105990:	55                   	push   %ebp
  105991:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  105993:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105997:	7e 14                	jle    1059ad <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105999:	8b 45 08             	mov    0x8(%ebp),%eax
  10599c:	8b 00                	mov    (%eax),%eax
  10599e:	8d 48 08             	lea    0x8(%eax),%ecx
  1059a1:	8b 55 08             	mov    0x8(%ebp),%edx
  1059a4:	89 0a                	mov    %ecx,(%edx)
  1059a6:	8b 50 04             	mov    0x4(%eax),%edx
  1059a9:	8b 00                	mov    (%eax),%eax
  1059ab:	eb 30                	jmp    1059dd <getuint+0x4d>
    }
    else if (lflag) {
  1059ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1059b1:	74 16                	je     1059c9 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1059b3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059b6:	8b 00                	mov    (%eax),%eax
  1059b8:	8d 48 04             	lea    0x4(%eax),%ecx
  1059bb:	8b 55 08             	mov    0x8(%ebp),%edx
  1059be:	89 0a                	mov    %ecx,(%edx)
  1059c0:	8b 00                	mov    (%eax),%eax
  1059c2:	ba 00 00 00 00       	mov    $0x0,%edx
  1059c7:	eb 14                	jmp    1059dd <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1059c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1059cc:	8b 00                	mov    (%eax),%eax
  1059ce:	8d 48 04             	lea    0x4(%eax),%ecx
  1059d1:	8b 55 08             	mov    0x8(%ebp),%edx
  1059d4:	89 0a                	mov    %ecx,(%edx)
  1059d6:	8b 00                	mov    (%eax),%eax
  1059d8:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  1059dd:	5d                   	pop    %ebp
  1059de:	c3                   	ret    

001059df <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  1059df:	55                   	push   %ebp
  1059e0:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1059e2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1059e6:	7e 14                	jle    1059fc <getint+0x1d>
        return va_arg(*ap, long long);
  1059e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1059eb:	8b 00                	mov    (%eax),%eax
  1059ed:	8d 48 08             	lea    0x8(%eax),%ecx
  1059f0:	8b 55 08             	mov    0x8(%ebp),%edx
  1059f3:	89 0a                	mov    %ecx,(%edx)
  1059f5:	8b 50 04             	mov    0x4(%eax),%edx
  1059f8:	8b 00                	mov    (%eax),%eax
  1059fa:	eb 28                	jmp    105a24 <getint+0x45>
    }
    else if (lflag) {
  1059fc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  105a00:	74 12                	je     105a14 <getint+0x35>
        return va_arg(*ap, long);
  105a02:	8b 45 08             	mov    0x8(%ebp),%eax
  105a05:	8b 00                	mov    (%eax),%eax
  105a07:	8d 48 04             	lea    0x4(%eax),%ecx
  105a0a:	8b 55 08             	mov    0x8(%ebp),%edx
  105a0d:	89 0a                	mov    %ecx,(%edx)
  105a0f:	8b 00                	mov    (%eax),%eax
  105a11:	99                   	cltd   
  105a12:	eb 10                	jmp    105a24 <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  105a14:	8b 45 08             	mov    0x8(%ebp),%eax
  105a17:	8b 00                	mov    (%eax),%eax
  105a19:	8d 48 04             	lea    0x4(%eax),%ecx
  105a1c:	8b 55 08             	mov    0x8(%ebp),%edx
  105a1f:	89 0a                	mov    %ecx,(%edx)
  105a21:	8b 00                	mov    (%eax),%eax
  105a23:	99                   	cltd   
    }
}
  105a24:	5d                   	pop    %ebp
  105a25:	c3                   	ret    

00105a26 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  105a26:	55                   	push   %ebp
  105a27:	89 e5                	mov    %esp,%ebp
  105a29:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  105a2c:	8d 45 14             	lea    0x14(%ebp),%eax
  105a2f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  105a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105a35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105a39:	8b 45 10             	mov    0x10(%ebp),%eax
  105a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a47:	8b 45 08             	mov    0x8(%ebp),%eax
  105a4a:	89 04 24             	mov    %eax,(%esp)
  105a4d:	e8 03 00 00 00       	call   105a55 <vprintfmt>
    va_end(ap);
}
  105a52:	90                   	nop
  105a53:	c9                   	leave  
  105a54:	c3                   	ret    

00105a55 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  105a55:	55                   	push   %ebp
  105a56:	89 e5                	mov    %esp,%ebp
  105a58:	56                   	push   %esi
  105a59:	53                   	push   %ebx
  105a5a:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a5d:	eb 17                	jmp    105a76 <vprintfmt+0x21>
            if (ch == '\0') {
  105a5f:	85 db                	test   %ebx,%ebx
  105a61:	0f 84 bf 03 00 00    	je     105e26 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  105a67:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a6a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a6e:	89 1c 24             	mov    %ebx,(%esp)
  105a71:	8b 45 08             	mov    0x8(%ebp),%eax
  105a74:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105a76:	8b 45 10             	mov    0x10(%ebp),%eax
  105a79:	8d 50 01             	lea    0x1(%eax),%edx
  105a7c:	89 55 10             	mov    %edx,0x10(%ebp)
  105a7f:	0f b6 00             	movzbl (%eax),%eax
  105a82:	0f b6 d8             	movzbl %al,%ebx
  105a85:	83 fb 25             	cmp    $0x25,%ebx
  105a88:	75 d5                	jne    105a5f <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  105a8a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105a8e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  105a95:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a98:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105a9b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  105aa2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105aa5:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105aa8:	8b 45 10             	mov    0x10(%ebp),%eax
  105aab:	8d 50 01             	lea    0x1(%eax),%edx
  105aae:	89 55 10             	mov    %edx,0x10(%ebp)
  105ab1:	0f b6 00             	movzbl (%eax),%eax
  105ab4:	0f b6 d8             	movzbl %al,%ebx
  105ab7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  105aba:	83 f8 55             	cmp    $0x55,%eax
  105abd:	0f 87 37 03 00 00    	ja     105dfa <vprintfmt+0x3a5>
  105ac3:	8b 04 85 20 71 10 00 	mov    0x107120(,%eax,4),%eax
  105aca:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  105acc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  105ad0:	eb d6                	jmp    105aa8 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105ad2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105ad6:	eb d0                	jmp    105aa8 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105ad8:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  105adf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105ae2:	89 d0                	mov    %edx,%eax
  105ae4:	c1 e0 02             	shl    $0x2,%eax
  105ae7:	01 d0                	add    %edx,%eax
  105ae9:	01 c0                	add    %eax,%eax
  105aeb:	01 d8                	add    %ebx,%eax
  105aed:	83 e8 30             	sub    $0x30,%eax
  105af0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105af3:	8b 45 10             	mov    0x10(%ebp),%eax
  105af6:	0f b6 00             	movzbl (%eax),%eax
  105af9:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  105afc:	83 fb 2f             	cmp    $0x2f,%ebx
  105aff:	7e 38                	jle    105b39 <vprintfmt+0xe4>
  105b01:	83 fb 39             	cmp    $0x39,%ebx
  105b04:	7f 33                	jg     105b39 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  105b06:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  105b09:	eb d4                	jmp    105adf <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  105b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  105b0e:	8d 50 04             	lea    0x4(%eax),%edx
  105b11:	89 55 14             	mov    %edx,0x14(%ebp)
  105b14:	8b 00                	mov    (%eax),%eax
  105b16:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105b19:	eb 1f                	jmp    105b3a <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  105b1b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b1f:	79 87                	jns    105aa8 <vprintfmt+0x53>
                width = 0;
  105b21:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  105b28:	e9 7b ff ff ff       	jmp    105aa8 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  105b2d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  105b34:	e9 6f ff ff ff       	jmp    105aa8 <vprintfmt+0x53>
            goto process_precision;
  105b39:	90                   	nop

        process_precision:
            if (width < 0)
  105b3a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b3e:	0f 89 64 ff ff ff    	jns    105aa8 <vprintfmt+0x53>
                width = precision, precision = -1;
  105b44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105b47:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105b4a:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  105b51:	e9 52 ff ff ff       	jmp    105aa8 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  105b56:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  105b59:	e9 4a ff ff ff       	jmp    105aa8 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  105b5e:	8b 45 14             	mov    0x14(%ebp),%eax
  105b61:	8d 50 04             	lea    0x4(%eax),%edx
  105b64:	89 55 14             	mov    %edx,0x14(%ebp)
  105b67:	8b 00                	mov    (%eax),%eax
  105b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  105b6c:	89 54 24 04          	mov    %edx,0x4(%esp)
  105b70:	89 04 24             	mov    %eax,(%esp)
  105b73:	8b 45 08             	mov    0x8(%ebp),%eax
  105b76:	ff d0                	call   *%eax
            break;
  105b78:	e9 a4 02 00 00       	jmp    105e21 <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  105b7d:	8b 45 14             	mov    0x14(%ebp),%eax
  105b80:	8d 50 04             	lea    0x4(%eax),%edx
  105b83:	89 55 14             	mov    %edx,0x14(%ebp)
  105b86:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105b88:	85 db                	test   %ebx,%ebx
  105b8a:	79 02                	jns    105b8e <vprintfmt+0x139>
                err = -err;
  105b8c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105b8e:	83 fb 06             	cmp    $0x6,%ebx
  105b91:	7f 0b                	jg     105b9e <vprintfmt+0x149>
  105b93:	8b 34 9d e0 70 10 00 	mov    0x1070e0(,%ebx,4),%esi
  105b9a:	85 f6                	test   %esi,%esi
  105b9c:	75 23                	jne    105bc1 <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  105b9e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105ba2:	c7 44 24 08 0d 71 10 	movl   $0x10710d,0x8(%esp)
  105ba9:	00 
  105baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bad:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bb1:	8b 45 08             	mov    0x8(%ebp),%eax
  105bb4:	89 04 24             	mov    %eax,(%esp)
  105bb7:	e8 6a fe ff ff       	call   105a26 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105bbc:	e9 60 02 00 00       	jmp    105e21 <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  105bc1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105bc5:	c7 44 24 08 16 71 10 	movl   $0x107116,0x8(%esp)
  105bcc:	00 
  105bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bd0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  105bd7:	89 04 24             	mov    %eax,(%esp)
  105bda:	e8 47 fe ff ff       	call   105a26 <printfmt>
            break;
  105bdf:	e9 3d 02 00 00       	jmp    105e21 <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105be4:	8b 45 14             	mov    0x14(%ebp),%eax
  105be7:	8d 50 04             	lea    0x4(%eax),%edx
  105bea:	89 55 14             	mov    %edx,0x14(%ebp)
  105bed:	8b 30                	mov    (%eax),%esi
  105bef:	85 f6                	test   %esi,%esi
  105bf1:	75 05                	jne    105bf8 <vprintfmt+0x1a3>
                p = "(null)";
  105bf3:	be 19 71 10 00       	mov    $0x107119,%esi
            }
            if (width > 0 && padc != '-') {
  105bf8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105bfc:	7e 76                	jle    105c74 <vprintfmt+0x21f>
  105bfe:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105c02:	74 70                	je     105c74 <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105c07:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c0b:	89 34 24             	mov    %esi,(%esp)
  105c0e:	e8 f6 f7 ff ff       	call   105409 <strnlen>
  105c13:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c16:	29 c2                	sub    %eax,%edx
  105c18:	89 d0                	mov    %edx,%eax
  105c1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105c1d:	eb 16                	jmp    105c35 <vprintfmt+0x1e0>
                    putch(padc, putdat);
  105c1f:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105c23:	8b 55 0c             	mov    0xc(%ebp),%edx
  105c26:	89 54 24 04          	mov    %edx,0x4(%esp)
  105c2a:	89 04 24             	mov    %eax,(%esp)
  105c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105c30:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  105c32:	ff 4d e8             	decl   -0x18(%ebp)
  105c35:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105c39:	7f e4                	jg     105c1f <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105c3b:	eb 37                	jmp    105c74 <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  105c3d:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105c41:	74 1f                	je     105c62 <vprintfmt+0x20d>
  105c43:	83 fb 1f             	cmp    $0x1f,%ebx
  105c46:	7e 05                	jle    105c4d <vprintfmt+0x1f8>
  105c48:	83 fb 7e             	cmp    $0x7e,%ebx
  105c4b:	7e 15                	jle    105c62 <vprintfmt+0x20d>
                    putch('?', putdat);
  105c4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c54:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105c5b:	8b 45 08             	mov    0x8(%ebp),%eax
  105c5e:	ff d0                	call   *%eax
  105c60:	eb 0f                	jmp    105c71 <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  105c62:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c65:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c69:	89 1c 24             	mov    %ebx,(%esp)
  105c6c:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6f:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105c71:	ff 4d e8             	decl   -0x18(%ebp)
  105c74:	89 f0                	mov    %esi,%eax
  105c76:	8d 70 01             	lea    0x1(%eax),%esi
  105c79:	0f b6 00             	movzbl (%eax),%eax
  105c7c:	0f be d8             	movsbl %al,%ebx
  105c7f:	85 db                	test   %ebx,%ebx
  105c81:	74 27                	je     105caa <vprintfmt+0x255>
  105c83:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105c87:	78 b4                	js     105c3d <vprintfmt+0x1e8>
  105c89:	ff 4d e4             	decl   -0x1c(%ebp)
  105c8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105c90:	79 ab                	jns    105c3d <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  105c92:	eb 16                	jmp    105caa <vprintfmt+0x255>
                putch(' ', putdat);
  105c94:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c97:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c9b:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  105ca5:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  105ca7:	ff 4d e8             	decl   -0x18(%ebp)
  105caa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105cae:	7f e4                	jg     105c94 <vprintfmt+0x23f>
            }
            break;
  105cb0:	e9 6c 01 00 00       	jmp    105e21 <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105cb8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cbc:	8d 45 14             	lea    0x14(%ebp),%eax
  105cbf:	89 04 24             	mov    %eax,(%esp)
  105cc2:	e8 18 fd ff ff       	call   1059df <getint>
  105cc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cca:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105cd0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105cd3:	85 d2                	test   %edx,%edx
  105cd5:	79 26                	jns    105cfd <vprintfmt+0x2a8>
                putch('-', putdat);
  105cd7:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cda:	89 44 24 04          	mov    %eax,0x4(%esp)
  105cde:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105ce5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ce8:	ff d0                	call   *%eax
                num = -(long long)num;
  105cea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105cf0:	f7 d8                	neg    %eax
  105cf2:	83 d2 00             	adc    $0x0,%edx
  105cf5:	f7 da                	neg    %edx
  105cf7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105cfa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105cfd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d04:	e9 a8 00 00 00       	jmp    105db1 <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105d09:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d0c:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d10:	8d 45 14             	lea    0x14(%ebp),%eax
  105d13:	89 04 24             	mov    %eax,(%esp)
  105d16:	e8 75 fc ff ff       	call   105990 <getuint>
  105d1b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d1e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105d21:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105d28:	e9 84 00 00 00       	jmp    105db1 <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105d2d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d34:	8d 45 14             	lea    0x14(%ebp),%eax
  105d37:	89 04 24             	mov    %eax,(%esp)
  105d3a:	e8 51 fc ff ff       	call   105990 <getuint>
  105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d42:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105d45:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105d4c:	eb 63                	jmp    105db1 <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  105d4e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d51:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d55:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105d5f:	ff d0                	call   *%eax
            putch('x', putdat);
  105d61:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d64:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d68:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  105d72:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105d74:	8b 45 14             	mov    0x14(%ebp),%eax
  105d77:	8d 50 04             	lea    0x4(%eax),%edx
  105d7a:	89 55 14             	mov    %edx,0x14(%ebp)
  105d7d:	8b 00                	mov    (%eax),%eax
  105d7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105d89:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105d90:	eb 1f                	jmp    105db1 <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105d92:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105d95:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d99:	8d 45 14             	lea    0x14(%ebp),%eax
  105d9c:	89 04 24             	mov    %eax,(%esp)
  105d9f:	e8 ec fb ff ff       	call   105990 <getuint>
  105da4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105da7:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105daa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105db1:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105db5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105db8:	89 54 24 18          	mov    %edx,0x18(%esp)
  105dbc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105dbf:	89 54 24 14          	mov    %edx,0x14(%esp)
  105dc3:	89 44 24 10          	mov    %eax,0x10(%esp)
  105dc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105dca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105dcd:	89 44 24 08          	mov    %eax,0x8(%esp)
  105dd1:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105dd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  105ddf:	89 04 24             	mov    %eax,(%esp)
  105de2:	e8 a4 fa ff ff       	call   10588b <printnum>
            break;
  105de7:	eb 38                	jmp    105e21 <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105de9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dec:	89 44 24 04          	mov    %eax,0x4(%esp)
  105df0:	89 1c 24             	mov    %ebx,(%esp)
  105df3:	8b 45 08             	mov    0x8(%ebp),%eax
  105df6:	ff d0                	call   *%eax
            break;
  105df8:	eb 27                	jmp    105e21 <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105dfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dfd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e01:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105e08:	8b 45 08             	mov    0x8(%ebp),%eax
  105e0b:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105e0d:	ff 4d 10             	decl   0x10(%ebp)
  105e10:	eb 03                	jmp    105e15 <vprintfmt+0x3c0>
  105e12:	ff 4d 10             	decl   0x10(%ebp)
  105e15:	8b 45 10             	mov    0x10(%ebp),%eax
  105e18:	48                   	dec    %eax
  105e19:	0f b6 00             	movzbl (%eax),%eax
  105e1c:	3c 25                	cmp    $0x25,%al
  105e1e:	75 f2                	jne    105e12 <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  105e20:	90                   	nop
    while (1) {
  105e21:	e9 37 fc ff ff       	jmp    105a5d <vprintfmt+0x8>
                return;
  105e26:	90                   	nop
        }
    }
}
  105e27:	83 c4 40             	add    $0x40,%esp
  105e2a:	5b                   	pop    %ebx
  105e2b:	5e                   	pop    %esi
  105e2c:	5d                   	pop    %ebp
  105e2d:	c3                   	ret    

00105e2e <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105e2e:	55                   	push   %ebp
  105e2f:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105e31:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e34:	8b 40 08             	mov    0x8(%eax),%eax
  105e37:	8d 50 01             	lea    0x1(%eax),%edx
  105e3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3d:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105e40:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e43:	8b 10                	mov    (%eax),%edx
  105e45:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e48:	8b 40 04             	mov    0x4(%eax),%eax
  105e4b:	39 c2                	cmp    %eax,%edx
  105e4d:	73 12                	jae    105e61 <sprintputch+0x33>
        *b->buf ++ = ch;
  105e4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e52:	8b 00                	mov    (%eax),%eax
  105e54:	8d 48 01             	lea    0x1(%eax),%ecx
  105e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  105e5a:	89 0a                	mov    %ecx,(%edx)
  105e5c:	8b 55 08             	mov    0x8(%ebp),%edx
  105e5f:	88 10                	mov    %dl,(%eax)
    }
}
  105e61:	90                   	nop
  105e62:	5d                   	pop    %ebp
  105e63:	c3                   	ret    

00105e64 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105e64:	55                   	push   %ebp
  105e65:	89 e5                	mov    %esp,%ebp
  105e67:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105e6a:	8d 45 14             	lea    0x14(%ebp),%eax
  105e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  105e70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e73:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105e77:	8b 45 10             	mov    0x10(%ebp),%eax
  105e7a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105e7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e81:	89 44 24 04          	mov    %eax,0x4(%esp)
  105e85:	8b 45 08             	mov    0x8(%ebp),%eax
  105e88:	89 04 24             	mov    %eax,(%esp)
  105e8b:	e8 08 00 00 00       	call   105e98 <vsnprintf>
  105e90:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105e93:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105e96:	c9                   	leave  
  105e97:	c3                   	ret    

00105e98 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105e98:	55                   	push   %ebp
  105e99:	89 e5                	mov    %esp,%ebp
  105e9b:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  105ea1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105ea4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  105eaa:	8b 45 08             	mov    0x8(%ebp),%eax
  105ead:	01 d0                	add    %edx,%eax
  105eaf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105eb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105ebd:	74 0a                	je     105ec9 <vsnprintf+0x31>
  105ebf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105ec2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105ec5:	39 c2                	cmp    %eax,%edx
  105ec7:	76 07                	jbe    105ed0 <vsnprintf+0x38>
        return -E_INVAL;
  105ec9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105ece:	eb 2a                	jmp    105efa <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105ed0:	8b 45 14             	mov    0x14(%ebp),%eax
  105ed3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105ed7:	8b 45 10             	mov    0x10(%ebp),%eax
  105eda:	89 44 24 08          	mov    %eax,0x8(%esp)
  105ede:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105ee1:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ee5:	c7 04 24 2e 5e 10 00 	movl   $0x105e2e,(%esp)
  105eec:	e8 64 fb ff ff       	call   105a55 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105ef1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105ef4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105ef7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105efa:	c9                   	leave  
  105efb:	c3                   	ret    
