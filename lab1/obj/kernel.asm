
bin/kernel:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  100000:	55                   	push   %ebp
  100001:	89 e5                	mov    %esp,%ebp
  100003:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100006:	ba a0 fd 10 00       	mov    $0x10fda0,%edx
  10000b:	b8 16 ea 10 00       	mov    $0x10ea16,%eax
  100010:	29 c2                	sub    %eax,%edx
  100012:	89 d0                	mov    %edx,%eax
  100014:	89 44 24 08          	mov    %eax,0x8(%esp)
  100018:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10001f:	00 
  100020:	c7 04 24 16 ea 10 00 	movl   $0x10ea16,(%esp)
  100027:	e8 00 2e 00 00       	call   102e2c <memset>

    cons_init();                // init the console
  10002c:	e8 28 15 00 00       	call   101559 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  100031:	c7 45 f4 40 36 10 00 	movl   $0x103640,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10003b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10003f:	c7 04 24 5c 36 10 00 	movl   $0x10365c,(%esp)
  100046:	e8 21 02 00 00       	call   10026c <cprintf>

    print_kerninfo();
  10004b:	e8 c2 08 00 00       	call   100912 <print_kerninfo>

    grade_backtrace();
  100050:	e8 8e 00 00 00       	call   1000e3 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100055:	e8 a7 2a 00 00       	call   102b01 <pmm_init>

    pic_init();                 // init interrupt controller
  10005a:	e8 39 16 00 00       	call   101698 <pic_init>
    idt_init();                 // init interrupt descriptor table
  10005f:	e8 be 17 00 00       	call   101822 <idt_init>

    clock_init();               // init clock interrupt
  100064:	e8 d1 0c 00 00       	call   100d3a <clock_init>
    intr_enable();              // enable irq interrupt
  100069:	e8 64 17 00 00       	call   1017d2 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    lab1_switch_test();
  10006e:	e8 6b 01 00 00       	call   1001de <lab1_switch_test>

    /* do nothing */
    while (1);
  100073:	eb fe                	jmp    100073 <kern_init+0x73>

00100075 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  100075:	55                   	push   %ebp
  100076:	89 e5                	mov    %esp,%ebp
  100078:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  10007b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  100082:	00 
  100083:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10008a:	00 
  10008b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100092:	e8 91 0c 00 00       	call   100d28 <mon_backtrace>
}
  100097:	90                   	nop
  100098:	c9                   	leave  
  100099:	c3                   	ret    

0010009a <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  10009a:	55                   	push   %ebp
  10009b:	89 e5                	mov    %esp,%ebp
  10009d:	53                   	push   %ebx
  10009e:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000a1:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  1000a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  1000a7:	8d 5d 08             	lea    0x8(%ebp),%ebx
  1000aa:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ad:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  1000b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1000b5:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1000b9:	89 04 24             	mov    %eax,(%esp)
  1000bc:	e8 b4 ff ff ff       	call   100075 <grade_backtrace2>
}
  1000c1:	90                   	nop
  1000c2:	83 c4 14             	add    $0x14,%esp
  1000c5:	5b                   	pop    %ebx
  1000c6:	5d                   	pop    %ebp
  1000c7:	c3                   	ret    

001000c8 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000c8:	55                   	push   %ebp
  1000c9:	89 e5                	mov    %esp,%ebp
  1000cb:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000ce:	8b 45 10             	mov    0x10(%ebp),%eax
  1000d1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d8:	89 04 24             	mov    %eax,(%esp)
  1000db:	e8 ba ff ff ff       	call   10009a <grade_backtrace1>
}
  1000e0:	90                   	nop
  1000e1:	c9                   	leave  
  1000e2:	c3                   	ret    

001000e3 <grade_backtrace>:

void
grade_backtrace(void) {
  1000e3:	55                   	push   %ebp
  1000e4:	89 e5                	mov    %esp,%ebp
  1000e6:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  1000e9:	b8 00 00 10 00       	mov    $0x100000,%eax
  1000ee:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  1000f5:	ff 
  1000f6:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100101:	e8 c2 ff ff ff       	call   1000c8 <grade_backtrace0>
}
  100106:	90                   	nop
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  10010f:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100112:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  100115:	8c 45 f2             	mov    %es,-0xe(%ebp)
  100118:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  10011b:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  10011f:	83 e0 03             	and    $0x3,%eax
  100122:	89 c2                	mov    %eax,%edx
  100124:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100129:	89 54 24 08          	mov    %edx,0x8(%esp)
  10012d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100131:	c7 04 24 61 36 10 00 	movl   $0x103661,(%esp)
  100138:	e8 2f 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  10013d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100141:	89 c2                	mov    %eax,%edx
  100143:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100148:	89 54 24 08          	mov    %edx,0x8(%esp)
  10014c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100150:	c7 04 24 6f 36 10 00 	movl   $0x10366f,(%esp)
  100157:	e8 10 01 00 00       	call   10026c <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  10015c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100160:	89 c2                	mov    %eax,%edx
  100162:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100167:	89 54 24 08          	mov    %edx,0x8(%esp)
  10016b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10016f:	c7 04 24 7d 36 10 00 	movl   $0x10367d,(%esp)
  100176:	e8 f1 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  10017b:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  10017f:	89 c2                	mov    %eax,%edx
  100181:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  100186:	89 54 24 08          	mov    %edx,0x8(%esp)
  10018a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10018e:	c7 04 24 8b 36 10 00 	movl   $0x10368b,(%esp)
  100195:	e8 d2 00 00 00       	call   10026c <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  10019a:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  10019e:	89 c2                	mov    %eax,%edx
  1001a0:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001a5:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001a9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001ad:	c7 04 24 99 36 10 00 	movl   $0x103699,(%esp)
  1001b4:	e8 b3 00 00 00       	call   10026c <cprintf>
    round ++;
  1001b9:	a1 20 ea 10 00       	mov    0x10ea20,%eax
  1001be:	40                   	inc    %eax
  1001bf:	a3 20 ea 10 00       	mov    %eax,0x10ea20
}
  1001c4:	90                   	nop
  1001c5:	c9                   	leave  
  1001c6:	c3                   	ret    

001001c7 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001c7:	55                   	push   %ebp
  1001c8:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
    asm volatile (
  1001ca:	83 ec 08             	sub    $0x8,%esp
  1001cd:	cd 78                	int    $0x78
  1001cf:	89 ec                	mov    %ebp,%esp
            "int %0 \n"
            "movl %%ebp, %%esp \n"
            :
            : "i"(T_SWITCH_TOU)
            );
}
  1001d1:	90                   	nop
  1001d2:	5d                   	pop    %ebp
  1001d3:	c3                   	ret    

001001d4 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001d4:	55                   	push   %ebp
  1001d5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
    asm volatile (
  1001d7:	cd 79                	int    $0x79
  1001d9:	89 ec                	mov    %ebp,%esp
            "int %0 \n"
            "mov %%ebp, %%esp \n"
            :
            : "i"(T_SWITCH_TOK)
            );
}
  1001db:	90                   	nop
  1001dc:	5d                   	pop    %ebp
  1001dd:	c3                   	ret    

001001de <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001de:	55                   	push   %ebp
  1001df:	89 e5                	mov    %esp,%ebp
  1001e1:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  1001e4:	e8 20 ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  1001e9:	c7 04 24 a8 36 10 00 	movl   $0x1036a8,(%esp)
  1001f0:	e8 77 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_user();
  1001f5:	e8 cd ff ff ff       	call   1001c7 <lab1_switch_to_user>
    lab1_print_cur_status();
  1001fa:	e8 0a ff ff ff       	call   100109 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  1001ff:	c7 04 24 c8 36 10 00 	movl   $0x1036c8,(%esp)
  100206:	e8 61 00 00 00       	call   10026c <cprintf>
    lab1_switch_to_kernel();
  10020b:	e8 c4 ff ff ff       	call   1001d4 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100210:	e8 f4 fe ff ff       	call   100109 <lab1_print_cur_status>
}
  100215:	90                   	nop
  100216:	c9                   	leave  
  100217:	c3                   	ret    

00100218 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  100218:	55                   	push   %ebp
  100219:	89 e5                	mov    %esp,%ebp
  10021b:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  10021e:	8b 45 08             	mov    0x8(%ebp),%eax
  100221:	89 04 24             	mov    %eax,(%esp)
  100224:	e8 5d 13 00 00       	call   101586 <cons_putc>
    (*cnt) ++;
  100229:	8b 45 0c             	mov    0xc(%ebp),%eax
  10022c:	8b 00                	mov    (%eax),%eax
  10022e:	8d 50 01             	lea    0x1(%eax),%edx
  100231:	8b 45 0c             	mov    0xc(%ebp),%eax
  100234:	89 10                	mov    %edx,(%eax)
}
  100236:	90                   	nop
  100237:	c9                   	leave  
  100238:	c3                   	ret    

00100239 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100239:	55                   	push   %ebp
  10023a:	89 e5                	mov    %esp,%ebp
  10023c:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10023f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100246:	8b 45 0c             	mov    0xc(%ebp),%eax
  100249:	89 44 24 0c          	mov    %eax,0xc(%esp)
  10024d:	8b 45 08             	mov    0x8(%ebp),%eax
  100250:	89 44 24 08          	mov    %eax,0x8(%esp)
  100254:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100257:	89 44 24 04          	mov    %eax,0x4(%esp)
  10025b:	c7 04 24 18 02 10 00 	movl   $0x100218,(%esp)
  100262:	e8 18 2f 00 00       	call   10317f <vprintfmt>
    return cnt;
  100267:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10026a:	c9                   	leave  
  10026b:	c3                   	ret    

0010026c <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  10026c:	55                   	push   %ebp
  10026d:	89 e5                	mov    %esp,%ebp
  10026f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  100272:	8d 45 0c             	lea    0xc(%ebp),%eax
  100275:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vcprintf(fmt, ap);
  100278:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10027b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10027f:	8b 45 08             	mov    0x8(%ebp),%eax
  100282:	89 04 24             	mov    %eax,(%esp)
  100285:	e8 af ff ff ff       	call   100239 <vcprintf>
  10028a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10028d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100290:	c9                   	leave  
  100291:	c3                   	ret    

00100292 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  100292:	55                   	push   %ebp
  100293:	89 e5                	mov    %esp,%ebp
  100295:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100298:	8b 45 08             	mov    0x8(%ebp),%eax
  10029b:	89 04 24             	mov    %eax,(%esp)
  10029e:	e8 e3 12 00 00       	call   101586 <cons_putc>
}
  1002a3:	90                   	nop
  1002a4:	c9                   	leave  
  1002a5:	c3                   	ret    

001002a6 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  1002a6:	55                   	push   %ebp
  1002a7:	89 e5                	mov    %esp,%ebp
  1002a9:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  1002ac:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  1002b3:	eb 13                	jmp    1002c8 <cputs+0x22>
        cputch(c, &cnt);
  1002b5:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  1002b9:	8d 55 f0             	lea    -0x10(%ebp),%edx
  1002bc:	89 54 24 04          	mov    %edx,0x4(%esp)
  1002c0:	89 04 24             	mov    %eax,(%esp)
  1002c3:	e8 50 ff ff ff       	call   100218 <cputch>
    while ((c = *str ++) != '\0') {
  1002c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1002cb:	8d 50 01             	lea    0x1(%eax),%edx
  1002ce:	89 55 08             	mov    %edx,0x8(%ebp)
  1002d1:	0f b6 00             	movzbl (%eax),%eax
  1002d4:	88 45 f7             	mov    %al,-0x9(%ebp)
  1002d7:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1002db:	75 d8                	jne    1002b5 <cputs+0xf>
    }
    cputch('\n', &cnt);
  1002dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1002e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1002e4:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1002eb:	e8 28 ff ff ff       	call   100218 <cputch>
    return cnt;
  1002f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1002f3:	c9                   	leave  
  1002f4:	c3                   	ret    

001002f5 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1002f5:	55                   	push   %ebp
  1002f6:	89 e5                	mov    %esp,%ebp
  1002f8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1002fb:	e8 b0 12 00 00       	call   1015b0 <cons_getc>
  100300:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100303:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100307:	74 f2                	je     1002fb <getchar+0x6>
        /* do nothing */;
    return c;
  100309:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10030c:	c9                   	leave  
  10030d:	c3                   	ret    

0010030e <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  10030e:	55                   	push   %ebp
  10030f:	89 e5                	mov    %esp,%ebp
  100311:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  100314:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100318:	74 13                	je     10032d <readline+0x1f>
        cprintf("%s", prompt);
  10031a:	8b 45 08             	mov    0x8(%ebp),%eax
  10031d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100321:	c7 04 24 e7 36 10 00 	movl   $0x1036e7,(%esp)
  100328:	e8 3f ff ff ff       	call   10026c <cprintf>
    }
    int i = 0, c;
  10032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        c = getchar();
  100334:	e8 bc ff ff ff       	call   1002f5 <getchar>
  100339:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  10033c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100340:	79 07                	jns    100349 <readline+0x3b>
            return NULL;
  100342:	b8 00 00 00 00       	mov    $0x0,%eax
  100347:	eb 78                	jmp    1003c1 <readline+0xb3>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100349:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10034d:	7e 28                	jle    100377 <readline+0x69>
  10034f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100356:	7f 1f                	jg     100377 <readline+0x69>
            cputchar(c);
  100358:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10035b:	89 04 24             	mov    %eax,(%esp)
  10035e:	e8 2f ff ff ff       	call   100292 <cputchar>
            buf[i ++] = c;
  100363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100366:	8d 50 01             	lea    0x1(%eax),%edx
  100369:	89 55 f4             	mov    %edx,-0xc(%ebp)
  10036c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10036f:	88 90 40 ea 10 00    	mov    %dl,0x10ea40(%eax)
  100375:	eb 45                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\b' && i > 0) {
  100377:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  10037b:	75 16                	jne    100393 <readline+0x85>
  10037d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100381:	7e 10                	jle    100393 <readline+0x85>
            cputchar(c);
  100383:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100386:	89 04 24             	mov    %eax,(%esp)
  100389:	e8 04 ff ff ff       	call   100292 <cputchar>
            i --;
  10038e:	ff 4d f4             	decl   -0xc(%ebp)
  100391:	eb 29                	jmp    1003bc <readline+0xae>
        }
        else if (c == '\n' || c == '\r') {
  100393:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  100397:	74 06                	je     10039f <readline+0x91>
  100399:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  10039d:	75 95                	jne    100334 <readline+0x26>
            cputchar(c);
  10039f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1003a2:	89 04 24             	mov    %eax,(%esp)
  1003a5:	e8 e8 fe ff ff       	call   100292 <cputchar>
            buf[i] = '\0';
  1003aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ad:	05 40 ea 10 00       	add    $0x10ea40,%eax
  1003b2:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1003b5:	b8 40 ea 10 00       	mov    $0x10ea40,%eax
  1003ba:	eb 05                	jmp    1003c1 <readline+0xb3>
        c = getchar();
  1003bc:	e9 73 ff ff ff       	jmp    100334 <readline+0x26>
        }
    }
}
  1003c1:	c9                   	leave  
  1003c2:	c3                   	ret    

001003c3 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  1003c3:	55                   	push   %ebp
  1003c4:	89 e5                	mov    %esp,%ebp
  1003c6:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  1003c9:	a1 40 ee 10 00       	mov    0x10ee40,%eax
  1003ce:	85 c0                	test   %eax,%eax
  1003d0:	75 5b                	jne    10042d <__panic+0x6a>
        goto panic_dead;
    }
    is_panic = 1;
  1003d2:	c7 05 40 ee 10 00 01 	movl   $0x1,0x10ee40
  1003d9:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  1003dc:	8d 45 14             	lea    0x14(%ebp),%eax
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  1003e2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003e5:	89 44 24 08          	mov    %eax,0x8(%esp)
  1003e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1003ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003f0:	c7 04 24 ea 36 10 00 	movl   $0x1036ea,(%esp)
  1003f7:	e8 70 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  1003fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1003ff:	89 44 24 04          	mov    %eax,0x4(%esp)
  100403:	8b 45 10             	mov    0x10(%ebp),%eax
  100406:	89 04 24             	mov    %eax,(%esp)
  100409:	e8 2b fe ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  10040e:	c7 04 24 06 37 10 00 	movl   $0x103706,(%esp)
  100415:	e8 52 fe ff ff       	call   10026c <cprintf>
    
    cprintf("stack trackback:\n");
  10041a:	c7 04 24 08 37 10 00 	movl   $0x103708,(%esp)
  100421:	e8 46 fe ff ff       	call   10026c <cprintf>
    print_stackframe();
  100426:	e8 32 06 00 00       	call   100a5d <print_stackframe>
  10042b:	eb 01                	jmp    10042e <__panic+0x6b>
        goto panic_dead;
  10042d:	90                   	nop
    
    va_end(ap);

panic_dead:
    intr_disable();
  10042e:	e8 a6 13 00 00       	call   1017d9 <intr_disable>
    while (1) {
        kmonitor(NULL);
  100433:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10043a:	e8 1c 08 00 00       	call   100c5b <kmonitor>
  10043f:	eb f2                	jmp    100433 <__panic+0x70>

00100441 <__warn>:
    }
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100441:	55                   	push   %ebp
  100442:	89 e5                	mov    %esp,%ebp
  100444:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100447:	8d 45 14             	lea    0x14(%ebp),%eax
  10044a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  10044d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100450:	89 44 24 08          	mov    %eax,0x8(%esp)
  100454:	8b 45 08             	mov    0x8(%ebp),%eax
  100457:	89 44 24 04          	mov    %eax,0x4(%esp)
  10045b:	c7 04 24 1a 37 10 00 	movl   $0x10371a,(%esp)
  100462:	e8 05 fe ff ff       	call   10026c <cprintf>
    vcprintf(fmt, ap);
  100467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10046a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10046e:	8b 45 10             	mov    0x10(%ebp),%eax
  100471:	89 04 24             	mov    %eax,(%esp)
  100474:	e8 c0 fd ff ff       	call   100239 <vcprintf>
    cprintf("\n");
  100479:	c7 04 24 06 37 10 00 	movl   $0x103706,(%esp)
  100480:	e8 e7 fd ff ff       	call   10026c <cprintf>
    va_end(ap);
}
  100485:	90                   	nop
  100486:	c9                   	leave  
  100487:	c3                   	ret    

00100488 <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100488:	55                   	push   %ebp
  100489:	89 e5                	mov    %esp,%ebp
    return is_panic;
  10048b:	a1 40 ee 10 00       	mov    0x10ee40,%eax
}
  100490:	5d                   	pop    %ebp
  100491:	c3                   	ret    

00100492 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  100492:	55                   	push   %ebp
  100493:	89 e5                	mov    %esp,%ebp
  100495:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  100498:	8b 45 0c             	mov    0xc(%ebp),%eax
  10049b:	8b 00                	mov    (%eax),%eax
  10049d:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1004a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1004a3:	8b 00                	mov    (%eax),%eax
  1004a5:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  1004af:	e9 ca 00 00 00       	jmp    10057e <stab_binsearch+0xec>
        int true_m = (l + r) / 2, m = true_m;
  1004b4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1004b7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1004ba:	01 d0                	add    %edx,%eax
  1004bc:	89 c2                	mov    %eax,%edx
  1004be:	c1 ea 1f             	shr    $0x1f,%edx
  1004c1:	01 d0                	add    %edx,%eax
  1004c3:	d1 f8                	sar    %eax
  1004c5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1004c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1004cb:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  1004ce:	eb 03                	jmp    1004d3 <stab_binsearch+0x41>
            m --;
  1004d0:	ff 4d f0             	decl   -0x10(%ebp)
        while (m >= l && stabs[m].n_type != type) {
  1004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d6:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  1004d9:	7c 1f                	jl     1004fa <stab_binsearch+0x68>
  1004db:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004de:	89 d0                	mov    %edx,%eax
  1004e0:	01 c0                	add    %eax,%eax
  1004e2:	01 d0                	add    %edx,%eax
  1004e4:	c1 e0 02             	shl    $0x2,%eax
  1004e7:	89 c2                	mov    %eax,%edx
  1004e9:	8b 45 08             	mov    0x8(%ebp),%eax
  1004ec:	01 d0                	add    %edx,%eax
  1004ee:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1004f2:	0f b6 c0             	movzbl %al,%eax
  1004f5:	39 45 14             	cmp    %eax,0x14(%ebp)
  1004f8:	75 d6                	jne    1004d0 <stab_binsearch+0x3e>
        }
        if (m < l) {    // no match in [l, m]
  1004fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004fd:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100500:	7d 09                	jge    10050b <stab_binsearch+0x79>
            l = true_m + 1;
  100502:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100505:	40                   	inc    %eax
  100506:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100509:	eb 73                	jmp    10057e <stab_binsearch+0xec>
        }

        // actual binary search
        any_matches = 1;
  10050b:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  100512:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100515:	89 d0                	mov    %edx,%eax
  100517:	01 c0                	add    %eax,%eax
  100519:	01 d0                	add    %edx,%eax
  10051b:	c1 e0 02             	shl    $0x2,%eax
  10051e:	89 c2                	mov    %eax,%edx
  100520:	8b 45 08             	mov    0x8(%ebp),%eax
  100523:	01 d0                	add    %edx,%eax
  100525:	8b 40 08             	mov    0x8(%eax),%eax
  100528:	39 45 18             	cmp    %eax,0x18(%ebp)
  10052b:	76 11                	jbe    10053e <stab_binsearch+0xac>
            *region_left = m;
  10052d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100530:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100533:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  100535:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100538:	40                   	inc    %eax
  100539:	89 45 fc             	mov    %eax,-0x4(%ebp)
  10053c:	eb 40                	jmp    10057e <stab_binsearch+0xec>
        } else if (stabs[m].n_value > addr) {
  10053e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100541:	89 d0                	mov    %edx,%eax
  100543:	01 c0                	add    %eax,%eax
  100545:	01 d0                	add    %edx,%eax
  100547:	c1 e0 02             	shl    $0x2,%eax
  10054a:	89 c2                	mov    %eax,%edx
  10054c:	8b 45 08             	mov    0x8(%ebp),%eax
  10054f:	01 d0                	add    %edx,%eax
  100551:	8b 40 08             	mov    0x8(%eax),%eax
  100554:	39 45 18             	cmp    %eax,0x18(%ebp)
  100557:	73 14                	jae    10056d <stab_binsearch+0xdb>
            *region_right = m - 1;
  100559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10055c:	8d 50 ff             	lea    -0x1(%eax),%edx
  10055f:	8b 45 10             	mov    0x10(%ebp),%eax
  100562:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  100564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100567:	48                   	dec    %eax
  100568:	89 45 f8             	mov    %eax,-0x8(%ebp)
  10056b:	eb 11                	jmp    10057e <stab_binsearch+0xec>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100573:	89 10                	mov    %edx,(%eax)
            l = m;
  100575:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100578:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  10057b:	ff 45 18             	incl   0x18(%ebp)
    while (l <= r) {
  10057e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100581:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  100584:	0f 8e 2a ff ff ff    	jle    1004b4 <stab_binsearch+0x22>
        }
    }

    if (!any_matches) {
  10058a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10058e:	75 0f                	jne    10059f <stab_binsearch+0x10d>
        *region_right = *region_left - 1;
  100590:	8b 45 0c             	mov    0xc(%ebp),%eax
  100593:	8b 00                	mov    (%eax),%eax
  100595:	8d 50 ff             	lea    -0x1(%eax),%edx
  100598:	8b 45 10             	mov    0x10(%ebp),%eax
  10059b:	89 10                	mov    %edx,(%eax)
        l = *region_right;
        for (; l > *region_left && stabs[l].n_type != type; l --)
            /* do nothing */;
        *region_left = l;
    }
}
  10059d:	eb 3e                	jmp    1005dd <stab_binsearch+0x14b>
        l = *region_right;
  10059f:	8b 45 10             	mov    0x10(%ebp),%eax
  1005a2:	8b 00                	mov    (%eax),%eax
  1005a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  1005a7:	eb 03                	jmp    1005ac <stab_binsearch+0x11a>
  1005a9:	ff 4d fc             	decl   -0x4(%ebp)
  1005ac:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005af:	8b 00                	mov    (%eax),%eax
  1005b1:	39 45 fc             	cmp    %eax,-0x4(%ebp)
  1005b4:	7e 1f                	jle    1005d5 <stab_binsearch+0x143>
  1005b6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005b9:	89 d0                	mov    %edx,%eax
  1005bb:	01 c0                	add    %eax,%eax
  1005bd:	01 d0                	add    %edx,%eax
  1005bf:	c1 e0 02             	shl    $0x2,%eax
  1005c2:	89 c2                	mov    %eax,%edx
  1005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005c7:	01 d0                	add    %edx,%eax
  1005c9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  1005cd:	0f b6 c0             	movzbl %al,%eax
  1005d0:	39 45 14             	cmp    %eax,0x14(%ebp)
  1005d3:	75 d4                	jne    1005a9 <stab_binsearch+0x117>
        *region_left = l;
  1005d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005d8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  1005db:	89 10                	mov    %edx,(%eax)
}
  1005dd:	90                   	nop
  1005de:	c9                   	leave  
  1005df:	c3                   	ret    

001005e0 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  1005e0:	55                   	push   %ebp
  1005e1:	89 e5                	mov    %esp,%ebp
  1005e3:	83 ec 58             	sub    $0x58,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  1005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005e9:	c7 00 38 37 10 00    	movl   $0x103738,(%eax)
    info->eip_line = 0;
  1005ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  1005f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  1005fc:	c7 40 08 38 37 10 00 	movl   $0x103738,0x8(%eax)
    info->eip_fn_namelen = 9;
  100603:	8b 45 0c             	mov    0xc(%ebp),%eax
  100606:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  10060d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100610:	8b 55 08             	mov    0x8(%ebp),%edx
  100613:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  100616:	8b 45 0c             	mov    0xc(%ebp),%eax
  100619:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100620:	c7 45 f4 8c 3f 10 00 	movl   $0x103f8c,-0xc(%ebp)
    stab_end = __STAB_END__;
  100627:	c7 45 f0 2c bd 10 00 	movl   $0x10bd2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  10062e:	c7 45 ec 2d bd 10 00 	movl   $0x10bd2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  100635:	c7 45 e8 18 de 10 00 	movl   $0x10de18,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  10063c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10063f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100642:	76 0b                	jbe    10064f <debuginfo_eip+0x6f>
  100644:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100647:	48                   	dec    %eax
  100648:	0f b6 00             	movzbl (%eax),%eax
  10064b:	84 c0                	test   %al,%al
  10064d:	74 0a                	je     100659 <debuginfo_eip+0x79>
        return -1;
  10064f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100654:	e9 b7 02 00 00       	jmp    100910 <debuginfo_eip+0x330>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  100659:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  100660:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100666:	29 c2                	sub    %eax,%edx
  100668:	89 d0                	mov    %edx,%eax
  10066a:	c1 f8 02             	sar    $0x2,%eax
  10066d:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  100673:	48                   	dec    %eax
  100674:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  100677:	8b 45 08             	mov    0x8(%ebp),%eax
  10067a:	89 44 24 10          	mov    %eax,0x10(%esp)
  10067e:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  100685:	00 
  100686:	8d 45 e0             	lea    -0x20(%ebp),%eax
  100689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10068d:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  100690:	89 44 24 04          	mov    %eax,0x4(%esp)
  100694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100697:	89 04 24             	mov    %eax,(%esp)
  10069a:	e8 f3 fd ff ff       	call   100492 <stab_binsearch>
    if (lfile == 0)
  10069f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006a2:	85 c0                	test   %eax,%eax
  1006a4:	75 0a                	jne    1006b0 <debuginfo_eip+0xd0>
        return -1;
  1006a6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1006ab:	e9 60 02 00 00       	jmp    100910 <debuginfo_eip+0x330>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  1006b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1006b6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006b9:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  1006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1006bf:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006c3:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  1006ca:	00 
  1006cb:	8d 45 d8             	lea    -0x28(%ebp),%eax
  1006ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  1006d2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1006d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1006d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1006dc:	89 04 24             	mov    %eax,(%esp)
  1006df:	e8 ae fd ff ff       	call   100492 <stab_binsearch>

    if (lfun <= rfun) {
  1006e4:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1006e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006ea:	39 c2                	cmp    %eax,%edx
  1006ec:	7f 7c                	jg     10076a <debuginfo_eip+0x18a>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  1006ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006f1:	89 c2                	mov    %eax,%edx
  1006f3:	89 d0                	mov    %edx,%eax
  1006f5:	01 c0                	add    %eax,%eax
  1006f7:	01 d0                	add    %edx,%eax
  1006f9:	c1 e0 02             	shl    $0x2,%eax
  1006fc:	89 c2                	mov    %eax,%edx
  1006fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100701:	01 d0                	add    %edx,%eax
  100703:	8b 00                	mov    (%eax),%eax
  100705:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100708:	8b 55 ec             	mov    -0x14(%ebp),%edx
  10070b:	29 d1                	sub    %edx,%ecx
  10070d:	89 ca                	mov    %ecx,%edx
  10070f:	39 d0                	cmp    %edx,%eax
  100711:	73 22                	jae    100735 <debuginfo_eip+0x155>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  100713:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100716:	89 c2                	mov    %eax,%edx
  100718:	89 d0                	mov    %edx,%eax
  10071a:	01 c0                	add    %eax,%eax
  10071c:	01 d0                	add    %edx,%eax
  10071e:	c1 e0 02             	shl    $0x2,%eax
  100721:	89 c2                	mov    %eax,%edx
  100723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100726:	01 d0                	add    %edx,%eax
  100728:	8b 10                	mov    (%eax),%edx
  10072a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10072d:	01 c2                	add    %eax,%edx
  10072f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100732:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  100735:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100738:	89 c2                	mov    %eax,%edx
  10073a:	89 d0                	mov    %edx,%eax
  10073c:	01 c0                	add    %eax,%eax
  10073e:	01 d0                	add    %edx,%eax
  100740:	c1 e0 02             	shl    $0x2,%eax
  100743:	89 c2                	mov    %eax,%edx
  100745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100748:	01 d0                	add    %edx,%eax
  10074a:	8b 50 08             	mov    0x8(%eax),%edx
  10074d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100750:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  100753:	8b 45 0c             	mov    0xc(%ebp),%eax
  100756:	8b 40 10             	mov    0x10(%eax),%eax
  100759:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  10075c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10075f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  100762:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100765:	89 45 d0             	mov    %eax,-0x30(%ebp)
  100768:	eb 15                	jmp    10077f <debuginfo_eip+0x19f>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  10076a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10076d:	8b 55 08             	mov    0x8(%ebp),%edx
  100770:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  100773:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100776:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  100779:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10077c:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  10077f:	8b 45 0c             	mov    0xc(%ebp),%eax
  100782:	8b 40 08             	mov    0x8(%eax),%eax
  100785:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  10078c:	00 
  10078d:	89 04 24             	mov    %eax,(%esp)
  100790:	e8 13 25 00 00       	call   102ca8 <strfind>
  100795:	89 c2                	mov    %eax,%edx
  100797:	8b 45 0c             	mov    0xc(%ebp),%eax
  10079a:	8b 40 08             	mov    0x8(%eax),%eax
  10079d:	29 c2                	sub    %eax,%edx
  10079f:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007a2:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  1007a8:	89 44 24 10          	mov    %eax,0x10(%esp)
  1007ac:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  1007b3:	00 
  1007b4:	8d 45 d0             	lea    -0x30(%ebp),%eax
  1007b7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1007bb:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  1007be:	89 44 24 04          	mov    %eax,0x4(%esp)
  1007c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007c5:	89 04 24             	mov    %eax,(%esp)
  1007c8:	e8 c5 fc ff ff       	call   100492 <stab_binsearch>
    if (lline <= rline) {
  1007cd:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007d3:	39 c2                	cmp    %eax,%edx
  1007d5:	7f 23                	jg     1007fa <debuginfo_eip+0x21a>
        info->eip_line = stabs[rline].n_desc;
  1007d7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1007da:	89 c2                	mov    %eax,%edx
  1007dc:	89 d0                	mov    %edx,%eax
  1007de:	01 c0                	add    %eax,%eax
  1007e0:	01 d0                	add    %edx,%eax
  1007e2:	c1 e0 02             	shl    $0x2,%eax
  1007e5:	89 c2                	mov    %eax,%edx
  1007e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1007ea:	01 d0                	add    %edx,%eax
  1007ec:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  1007f0:	89 c2                	mov    %eax,%edx
  1007f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f5:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  1007f8:	eb 11                	jmp    10080b <debuginfo_eip+0x22b>
        return -1;
  1007fa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1007ff:	e9 0c 01 00 00       	jmp    100910 <debuginfo_eip+0x330>
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100804:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100807:	48                   	dec    %eax
  100808:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (lline >= lfile
  10080b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10080e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100811:	39 c2                	cmp    %eax,%edx
  100813:	7c 56                	jl     10086b <debuginfo_eip+0x28b>
           && stabs[lline].n_type != N_SOL
  100815:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100818:	89 c2                	mov    %eax,%edx
  10081a:	89 d0                	mov    %edx,%eax
  10081c:	01 c0                	add    %eax,%eax
  10081e:	01 d0                	add    %edx,%eax
  100820:	c1 e0 02             	shl    $0x2,%eax
  100823:	89 c2                	mov    %eax,%edx
  100825:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100828:	01 d0                	add    %edx,%eax
  10082a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10082e:	3c 84                	cmp    $0x84,%al
  100830:	74 39                	je     10086b <debuginfo_eip+0x28b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	89 c2                	mov    %eax,%edx
  100842:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100845:	01 d0                	add    %edx,%eax
  100847:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10084b:	3c 64                	cmp    $0x64,%al
  10084d:	75 b5                	jne    100804 <debuginfo_eip+0x224>
  10084f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100852:	89 c2                	mov    %eax,%edx
  100854:	89 d0                	mov    %edx,%eax
  100856:	01 c0                	add    %eax,%eax
  100858:	01 d0                	add    %edx,%eax
  10085a:	c1 e0 02             	shl    $0x2,%eax
  10085d:	89 c2                	mov    %eax,%edx
  10085f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100862:	01 d0                	add    %edx,%eax
  100864:	8b 40 08             	mov    0x8(%eax),%eax
  100867:	85 c0                	test   %eax,%eax
  100869:	74 99                	je     100804 <debuginfo_eip+0x224>
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  10086b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10086e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100871:	39 c2                	cmp    %eax,%edx
  100873:	7c 46                	jl     1008bb <debuginfo_eip+0x2db>
  100875:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100878:	89 c2                	mov    %eax,%edx
  10087a:	89 d0                	mov    %edx,%eax
  10087c:	01 c0                	add    %eax,%eax
  10087e:	01 d0                	add    %edx,%eax
  100880:	c1 e0 02             	shl    $0x2,%eax
  100883:	89 c2                	mov    %eax,%edx
  100885:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100888:	01 d0                	add    %edx,%eax
  10088a:	8b 00                	mov    (%eax),%eax
  10088c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10088f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  100892:	29 d1                	sub    %edx,%ecx
  100894:	89 ca                	mov    %ecx,%edx
  100896:	39 d0                	cmp    %edx,%eax
  100898:	73 21                	jae    1008bb <debuginfo_eip+0x2db>
        info->eip_file = stabstr + stabs[lline].n_strx;
  10089a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10089d:	89 c2                	mov    %eax,%edx
  10089f:	89 d0                	mov    %edx,%eax
  1008a1:	01 c0                	add    %eax,%eax
  1008a3:	01 d0                	add    %edx,%eax
  1008a5:	c1 e0 02             	shl    $0x2,%eax
  1008a8:	89 c2                	mov    %eax,%edx
  1008aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1008ad:	01 d0                	add    %edx,%eax
  1008af:	8b 10                	mov    (%eax),%edx
  1008b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1008b4:	01 c2                	add    %eax,%edx
  1008b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008b9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1008bb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1008be:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1008c1:	39 c2                	cmp    %eax,%edx
  1008c3:	7d 46                	jge    10090b <debuginfo_eip+0x32b>
        for (lline = lfun + 1;
  1008c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1008c8:	40                   	inc    %eax
  1008c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  1008cc:	eb 16                	jmp    1008e4 <debuginfo_eip+0x304>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  1008ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008d1:	8b 40 14             	mov    0x14(%eax),%eax
  1008d4:	8d 50 01             	lea    0x1(%eax),%edx
  1008d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1008da:	89 50 14             	mov    %edx,0x14(%eax)
             lline ++) {
  1008dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008e0:	40                   	inc    %eax
  1008e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008e4:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1008e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
        for (lline = lfun + 1;
  1008ea:	39 c2                	cmp    %eax,%edx
  1008ec:	7d 1d                	jge    10090b <debuginfo_eip+0x32b>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  1008ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1008f1:	89 c2                	mov    %eax,%edx
  1008f3:	89 d0                	mov    %edx,%eax
  1008f5:	01 c0                	add    %eax,%eax
  1008f7:	01 d0                	add    %edx,%eax
  1008f9:	c1 e0 02             	shl    $0x2,%eax
  1008fc:	89 c2                	mov    %eax,%edx
  1008fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100901:	01 d0                	add    %edx,%eax
  100903:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100907:	3c a0                	cmp    $0xa0,%al
  100909:	74 c3                	je     1008ce <debuginfo_eip+0x2ee>
        }
    }
    return 0;
  10090b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100910:	c9                   	leave  
  100911:	c3                   	ret    

00100912 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100912:	55                   	push   %ebp
  100913:	89 e5                	mov    %esp,%ebp
  100915:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  100918:	c7 04 24 42 37 10 00 	movl   $0x103742,(%esp)
  10091f:	e8 48 f9 ff ff       	call   10026c <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100924:	c7 44 24 04 00 00 10 	movl   $0x100000,0x4(%esp)
  10092b:	00 
  10092c:	c7 04 24 5b 37 10 00 	movl   $0x10375b,(%esp)
  100933:	e8 34 f9 ff ff       	call   10026c <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  100938:	c7 44 24 04 26 36 10 	movl   $0x103626,0x4(%esp)
  10093f:	00 
  100940:	c7 04 24 73 37 10 00 	movl   $0x103773,(%esp)
  100947:	e8 20 f9 ff ff       	call   10026c <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  10094c:	c7 44 24 04 16 ea 10 	movl   $0x10ea16,0x4(%esp)
  100953:	00 
  100954:	c7 04 24 8b 37 10 00 	movl   $0x10378b,(%esp)
  10095b:	e8 0c f9 ff ff       	call   10026c <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  100960:	c7 44 24 04 a0 fd 10 	movl   $0x10fda0,0x4(%esp)
  100967:	00 
  100968:	c7 04 24 a3 37 10 00 	movl   $0x1037a3,(%esp)
  10096f:	e8 f8 f8 ff ff       	call   10026c <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  100974:	b8 a0 fd 10 00       	mov    $0x10fda0,%eax
  100979:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10097f:	b8 00 00 10 00       	mov    $0x100000,%eax
  100984:	29 c2                	sub    %eax,%edx
  100986:	89 d0                	mov    %edx,%eax
  100988:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  10098e:	85 c0                	test   %eax,%eax
  100990:	0f 48 c2             	cmovs  %edx,%eax
  100993:	c1 f8 0a             	sar    $0xa,%eax
  100996:	89 44 24 04          	mov    %eax,0x4(%esp)
  10099a:	c7 04 24 bc 37 10 00 	movl   $0x1037bc,(%esp)
  1009a1:	e8 c6 f8 ff ff       	call   10026c <cprintf>
}
  1009a6:	90                   	nop
  1009a7:	c9                   	leave  
  1009a8:	c3                   	ret    

001009a9 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1009a9:	55                   	push   %ebp
  1009aa:	89 e5                	mov    %esp,%ebp
  1009ac:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1009b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1009b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009b9:	8b 45 08             	mov    0x8(%ebp),%eax
  1009bc:	89 04 24             	mov    %eax,(%esp)
  1009bf:	e8 1c fc ff ff       	call   1005e0 <debuginfo_eip>
  1009c4:	85 c0                	test   %eax,%eax
  1009c6:	74 15                	je     1009dd <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  1009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1009cb:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009cf:	c7 04 24 e6 37 10 00 	movl   $0x1037e6,(%esp)
  1009d6:	e8 91 f8 ff ff       	call   10026c <cprintf>
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
    }
}
  1009db:	eb 6c                	jmp    100a49 <print_debuginfo+0xa0>
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1009e4:	eb 1b                	jmp    100a01 <print_debuginfo+0x58>
            fnname[j] = info.eip_fn_name[j];
  1009e6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  1009e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009ec:	01 d0                	add    %edx,%eax
  1009ee:	0f b6 00             	movzbl (%eax),%eax
  1009f1:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  1009f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1009fa:	01 ca                	add    %ecx,%edx
  1009fc:	88 02                	mov    %al,(%edx)
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  1009fe:	ff 45 f4             	incl   -0xc(%ebp)
  100a01:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100a04:	39 45 f4             	cmp    %eax,-0xc(%ebp)
  100a07:	7c dd                	jl     1009e6 <print_debuginfo+0x3d>
        fnname[j] = '\0';
  100a09:	8d 95 dc fe ff ff    	lea    -0x124(%ebp),%edx
  100a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a12:	01 d0                	add    %edx,%eax
  100a14:	c6 00 00             	movb   $0x0,(%eax)
                fnname, eip - info.eip_fn_addr);
  100a17:	8b 45 ec             	mov    -0x14(%ebp),%eax
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100a1a:	8b 55 08             	mov    0x8(%ebp),%edx
  100a1d:	89 d1                	mov    %edx,%ecx
  100a1f:	29 c1                	sub    %eax,%ecx
  100a21:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100a24:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100a27:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  100a2b:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100a31:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  100a35:	89 54 24 08          	mov    %edx,0x8(%esp)
  100a39:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a3d:	c7 04 24 02 38 10 00 	movl   $0x103802,(%esp)
  100a44:	e8 23 f8 ff ff       	call   10026c <cprintf>
}
  100a49:	90                   	nop
  100a4a:	c9                   	leave  
  100a4b:	c3                   	ret    

00100a4c <read_eip>:

static __noinline uint32_t
read_eip(void) {
  100a4c:	55                   	push   %ebp
  100a4d:	89 e5                	mov    %esp,%ebp
  100a4f:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100a52:	8b 45 04             	mov    0x4(%ebp),%eax
  100a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
    return eip;
  100a58:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  100a5b:	c9                   	leave  
  100a5c:	c3                   	ret    

00100a5d <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  100a5d:	55                   	push   %ebp
  100a5e:	89 e5                	mov    %esp,%ebp
  100a60:	53                   	push   %ebx
  100a61:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  100a64:	89 e8                	mov    %ebp,%eax
  100a66:	89 45 ec             	mov    %eax,-0x14(%ebp)
    return ebp;
  100a69:	8b 45 ec             	mov    -0x14(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
     uint32_t ebp = read_ebp();
  100a6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
     uint32_t eip = read_eip();
  100a6f:	e8 d8 ff ff ff       	call   100a4c <read_eip>
  100a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
     while(ebp != 0) {
  100a77:	eb 69                	jmp    100ae2 <print_stackframe+0x85>
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a7c:	83 c0 14             	add    $0x14,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100a7f:	8b 18                	mov    (%eax),%ebx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a84:	83 c0 10             	add    $0x10,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100a87:	8b 08                	mov    (%eax),%ecx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100a89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a8c:	83 c0 0c             	add    $0xc,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100a8f:	8b 10                	mov    (%eax),%edx
                 *((uint32_t *)ebp+2), *((uint32_t *)ebp+3), *((uint32_t *)ebp+4), *((uint32_t *)ebp+5));
  100a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a94:	83 c0 08             	add    $0x8,%eax
         cprintf("ebp:0x%08x eip:0x%08x args:0x%08x 0x%08x 0x%08x 0x%08x\n",ebp, eip,
  100a97:	8b 00                	mov    (%eax),%eax
  100a99:	89 5c 24 18          	mov    %ebx,0x18(%esp)
  100a9d:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  100aa1:	89 54 24 10          	mov    %edx,0x10(%esp)
  100aa5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100aac:	89 44 24 08          	mov    %eax,0x8(%esp)
  100ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ab3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ab7:	c7 04 24 14 38 10 00 	movl   $0x103814,(%esp)
  100abe:	e8 a9 f7 ff ff       	call   10026c <cprintf>
         print_debuginfo((uintptr_t )(eip) - 1);
  100ac3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100ac6:	48                   	dec    %eax
  100ac7:	89 04 24             	mov    %eax,(%esp)
  100aca:	e8 da fe ff ff       	call   1009a9 <print_debuginfo>
         ebp = *((uint32_t *)ebp);
  100acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ad2:	8b 00                	mov    (%eax),%eax
  100ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
         eip = *((uint32_t *)(ebp) + 1);
  100ad7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ada:	83 c0 04             	add    $0x4,%eax
  100add:	8b 00                	mov    (%eax),%eax
  100adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
     while(ebp != 0) {
  100ae2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100ae6:	75 91                	jne    100a79 <print_stackframe+0x1c>
     }

}
  100ae8:	90                   	nop
  100ae9:	83 c4 34             	add    $0x34,%esp
  100aec:	5b                   	pop    %ebx
  100aed:	5d                   	pop    %ebp
  100aee:	c3                   	ret    

00100aef <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100aef:	55                   	push   %ebp
  100af0:	89 e5                	mov    %esp,%ebp
  100af2:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100af5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100afc:	eb 0c                	jmp    100b0a <parse+0x1b>
            *buf ++ = '\0';
  100afe:	8b 45 08             	mov    0x8(%ebp),%eax
  100b01:	8d 50 01             	lea    0x1(%eax),%edx
  100b04:	89 55 08             	mov    %edx,0x8(%ebp)
  100b07:	c6 00 00             	movb   $0x0,(%eax)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b0d:	0f b6 00             	movzbl (%eax),%eax
  100b10:	84 c0                	test   %al,%al
  100b12:	74 1d                	je     100b31 <parse+0x42>
  100b14:	8b 45 08             	mov    0x8(%ebp),%eax
  100b17:	0f b6 00             	movzbl (%eax),%eax
  100b1a:	0f be c0             	movsbl %al,%eax
  100b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b21:	c7 04 24 cc 38 10 00 	movl   $0x1038cc,(%esp)
  100b28:	e8 49 21 00 00       	call   102c76 <strchr>
  100b2d:	85 c0                	test   %eax,%eax
  100b2f:	75 cd                	jne    100afe <parse+0xf>
        }
        if (*buf == '\0') {
  100b31:	8b 45 08             	mov    0x8(%ebp),%eax
  100b34:	0f b6 00             	movzbl (%eax),%eax
  100b37:	84 c0                	test   %al,%al
  100b39:	74 65                	je     100ba0 <parse+0xb1>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100b3b:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100b3f:	75 14                	jne    100b55 <parse+0x66>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100b41:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100b48:	00 
  100b49:	c7 04 24 d1 38 10 00 	movl   $0x1038d1,(%esp)
  100b50:	e8 17 f7 ff ff       	call   10026c <cprintf>
        }
        argv[argc ++] = buf;
  100b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100b58:	8d 50 01             	lea    0x1(%eax),%edx
  100b5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  100b5e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  100b65:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b68:	01 c2                	add    %eax,%edx
  100b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  100b6d:	89 02                	mov    %eax,(%edx)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b6f:	eb 03                	jmp    100b74 <parse+0x85>
            buf ++;
  100b71:	ff 45 08             	incl   0x8(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100b74:	8b 45 08             	mov    0x8(%ebp),%eax
  100b77:	0f b6 00             	movzbl (%eax),%eax
  100b7a:	84 c0                	test   %al,%al
  100b7c:	74 8c                	je     100b0a <parse+0x1b>
  100b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  100b81:	0f b6 00             	movzbl (%eax),%eax
  100b84:	0f be c0             	movsbl %al,%eax
  100b87:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b8b:	c7 04 24 cc 38 10 00 	movl   $0x1038cc,(%esp)
  100b92:	e8 df 20 00 00       	call   102c76 <strchr>
  100b97:	85 c0                	test   %eax,%eax
  100b99:	74 d6                	je     100b71 <parse+0x82>
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100b9b:	e9 6a ff ff ff       	jmp    100b0a <parse+0x1b>
            break;
  100ba0:	90                   	nop
        }
    }
    return argc;
  100ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100ba4:	c9                   	leave  
  100ba5:	c3                   	ret    

00100ba6 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100ba6:	55                   	push   %ebp
  100ba7:	89 e5                	mov    %esp,%ebp
  100ba9:	53                   	push   %ebx
  100baa:	83 ec 64             	sub    $0x64,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100bad:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  100bb7:	89 04 24             	mov    %eax,(%esp)
  100bba:	e8 30 ff ff ff       	call   100aef <parse>
  100bbf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100bc2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100bc6:	75 0a                	jne    100bd2 <runcmd+0x2c>
        return 0;
  100bc8:	b8 00 00 00 00       	mov    $0x0,%eax
  100bcd:	e9 83 00 00 00       	jmp    100c55 <runcmd+0xaf>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100bd2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100bd9:	eb 5a                	jmp    100c35 <runcmd+0x8f>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100bdb:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100bde:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100be1:	89 d0                	mov    %edx,%eax
  100be3:	01 c0                	add    %eax,%eax
  100be5:	01 d0                	add    %edx,%eax
  100be7:	c1 e0 02             	shl    $0x2,%eax
  100bea:	05 00 e0 10 00       	add    $0x10e000,%eax
  100bef:	8b 00                	mov    (%eax),%eax
  100bf1:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100bf5:	89 04 24             	mov    %eax,(%esp)
  100bf8:	e8 dc 1f 00 00       	call   102bd9 <strcmp>
  100bfd:	85 c0                	test   %eax,%eax
  100bff:	75 31                	jne    100c32 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c04:	89 d0                	mov    %edx,%eax
  100c06:	01 c0                	add    %eax,%eax
  100c08:	01 d0                	add    %edx,%eax
  100c0a:	c1 e0 02             	shl    $0x2,%eax
  100c0d:	05 08 e0 10 00       	add    $0x10e008,%eax
  100c12:	8b 10                	mov    (%eax),%edx
  100c14:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100c17:	83 c0 04             	add    $0x4,%eax
  100c1a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  100c1d:	8d 59 ff             	lea    -0x1(%ecx),%ebx
  100c20:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  100c23:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c27:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c2b:	89 1c 24             	mov    %ebx,(%esp)
  100c2e:	ff d2                	call   *%edx
  100c30:	eb 23                	jmp    100c55 <runcmd+0xaf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100c32:	ff 45 f4             	incl   -0xc(%ebp)
  100c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c38:	83 f8 02             	cmp    $0x2,%eax
  100c3b:	76 9e                	jbe    100bdb <runcmd+0x35>
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100c3d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100c40:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c44:	c7 04 24 ef 38 10 00 	movl   $0x1038ef,(%esp)
  100c4b:	e8 1c f6 ff ff       	call   10026c <cprintf>
    return 0;
  100c50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c55:	83 c4 64             	add    $0x64,%esp
  100c58:	5b                   	pop    %ebx
  100c59:	5d                   	pop    %ebp
  100c5a:	c3                   	ret    

00100c5b <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100c5b:	55                   	push   %ebp
  100c5c:	89 e5                	mov    %esp,%ebp
  100c5e:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100c61:	c7 04 24 08 39 10 00 	movl   $0x103908,(%esp)
  100c68:	e8 ff f5 ff ff       	call   10026c <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100c6d:	c7 04 24 30 39 10 00 	movl   $0x103930,(%esp)
  100c74:	e8 f3 f5 ff ff       	call   10026c <cprintf>

    if (tf != NULL) {
  100c79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100c7d:	74 0b                	je     100c8a <kmonitor+0x2f>
        print_trapframe(tf);
  100c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  100c82:	89 04 24             	mov    %eax,(%esp)
  100c85:	e8 cd 0d 00 00       	call   101a57 <print_trapframe>
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100c8a:	c7 04 24 55 39 10 00 	movl   $0x103955,(%esp)
  100c91:	e8 78 f6 ff ff       	call   10030e <readline>
  100c96:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c99:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c9d:	74 eb                	je     100c8a <kmonitor+0x2f>
            if (runcmd(buf, tf) < 0) {
  100c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  100ca2:	89 44 24 04          	mov    %eax,0x4(%esp)
  100ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ca9:	89 04 24             	mov    %eax,(%esp)
  100cac:	e8 f5 fe ff ff       	call   100ba6 <runcmd>
  100cb1:	85 c0                	test   %eax,%eax
  100cb3:	78 02                	js     100cb7 <kmonitor+0x5c>
        if ((buf = readline("K> ")) != NULL) {
  100cb5:	eb d3                	jmp    100c8a <kmonitor+0x2f>
                break;
  100cb7:	90                   	nop
            }
        }
    }
}
  100cb8:	90                   	nop
  100cb9:	c9                   	leave  
  100cba:	c3                   	ret    

00100cbb <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100cbb:	55                   	push   %ebp
  100cbc:	89 e5                	mov    %esp,%ebp
  100cbe:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100cc1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100cc8:	eb 3d                	jmp    100d07 <mon_help+0x4c>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100cca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ccd:	89 d0                	mov    %edx,%eax
  100ccf:	01 c0                	add    %eax,%eax
  100cd1:	01 d0                	add    %edx,%eax
  100cd3:	c1 e0 02             	shl    $0x2,%eax
  100cd6:	05 04 e0 10 00       	add    $0x10e004,%eax
  100cdb:	8b 08                	mov    (%eax),%ecx
  100cdd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100ce0:	89 d0                	mov    %edx,%eax
  100ce2:	01 c0                	add    %eax,%eax
  100ce4:	01 d0                	add    %edx,%eax
  100ce6:	c1 e0 02             	shl    $0x2,%eax
  100ce9:	05 00 e0 10 00       	add    $0x10e000,%eax
  100cee:	8b 00                	mov    (%eax),%eax
  100cf0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100cf4:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cf8:	c7 04 24 59 39 10 00 	movl   $0x103959,(%esp)
  100cff:	e8 68 f5 ff ff       	call   10026c <cprintf>
    for (i = 0; i < NCOMMANDS; i ++) {
  100d04:	ff 45 f4             	incl   -0xc(%ebp)
  100d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d0a:	83 f8 02             	cmp    $0x2,%eax
  100d0d:	76 bb                	jbe    100cca <mon_help+0xf>
    }
    return 0;
  100d0f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d14:	c9                   	leave  
  100d15:	c3                   	ret    

00100d16 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100d16:	55                   	push   %ebp
  100d17:	89 e5                	mov    %esp,%ebp
  100d19:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100d1c:	e8 f1 fb ff ff       	call   100912 <print_kerninfo>
    return 0;
  100d21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d26:	c9                   	leave  
  100d27:	c3                   	ret    

00100d28 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100d28:	55                   	push   %ebp
  100d29:	89 e5                	mov    %esp,%ebp
  100d2b:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100d2e:	e8 2a fd ff ff       	call   100a5d <print_stackframe>
    return 0;
  100d33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100d38:	c9                   	leave  
  100d39:	c3                   	ret    

00100d3a <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d3a:	55                   	push   %ebp
  100d3b:	89 e5                	mov    %esp,%ebp
  100d3d:	83 ec 28             	sub    $0x28,%esp
  100d40:	66 c7 45 ee 43 00    	movw   $0x43,-0x12(%ebp)
  100d46:	c6 45 ed 34          	movb   $0x34,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100d4a:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100d4e:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100d52:	ee                   	out    %al,(%dx)
  100d53:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d59:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d5d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d61:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d65:	ee                   	out    %al,(%dx)
  100d66:	66 c7 45 f6 40 00    	movw   $0x40,-0xa(%ebp)
  100d6c:	c6 45 f5 2e          	movb   $0x2e,-0xb(%ebp)
  100d70:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d74:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d78:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100d79:	c7 05 28 f9 10 00 00 	movl   $0x0,0x10f928
  100d80:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100d83:	c7 04 24 62 39 10 00 	movl   $0x103962,(%esp)
  100d8a:	e8 dd f4 ff ff       	call   10026c <cprintf>
    pic_enable(IRQ_TIMER);
  100d8f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d96:	e8 ca 08 00 00       	call   101665 <pic_enable>
}
  100d9b:	90                   	nop
  100d9c:	c9                   	leave  
  100d9d:	c3                   	ret    

00100d9e <delay>:
#include <picirq.h>
#include <trap.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100d9e:	55                   	push   %ebp
  100d9f:	89 e5                	mov    %esp,%ebp
  100da1:	83 ec 10             	sub    $0x10,%esp
  100da4:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100daa:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100dae:	89 c2                	mov    %eax,%edx
  100db0:	ec                   	in     (%dx),%al
  100db1:	88 45 f1             	mov    %al,-0xf(%ebp)
  100db4:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
  100dba:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100dbe:	89 c2                	mov    %eax,%edx
  100dc0:	ec                   	in     (%dx),%al
  100dc1:	88 45 f5             	mov    %al,-0xb(%ebp)
  100dc4:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
  100dca:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100dce:	89 c2                	mov    %eax,%edx
  100dd0:	ec                   	in     (%dx),%al
  100dd1:	88 45 f9             	mov    %al,-0x7(%ebp)
  100dd4:	66 c7 45 fe 84 00    	movw   $0x84,-0x2(%ebp)
  100dda:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  100dde:	89 c2                	mov    %eax,%edx
  100de0:	ec                   	in     (%dx),%al
  100de1:	88 45 fd             	mov    %al,-0x3(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100de4:	90                   	nop
  100de5:	c9                   	leave  
  100de6:	c3                   	ret    

00100de7 <cga_init>:
//    -- 数据寄存器 映射 到 端口 0x3D5或0x3B5 
//    -- 索引寄存器 0x3D4或0x3B4,决定在数据寄存器中的数据表示什么。

/* TEXT-mode CGA/VGA display output */
static void
cga_init(void) {
  100de7:	55                   	push   %ebp
  100de8:	89 e5                	mov    %esp,%ebp
  100dea:	83 ec 20             	sub    $0x20,%esp
    volatile uint16_t *cp = (uint16_t *)CGA_BUF;   //CGA_BUF: 0xB8000 (彩色显示的显存物理基址)
  100ded:	c7 45 fc 00 80 0b 00 	movl   $0xb8000,-0x4(%ebp)
    uint16_t was = *cp;                                            //保存当前显存0xB8000处的值
  100df4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100df7:	0f b7 00             	movzwl (%eax),%eax
  100dfa:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
    *cp = (uint16_t) 0xA55A;                                   // 给这个地址随便写个值，看看能否再读出同样的值
  100dfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e01:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {                                            // 如果读不出来，说明没有这块显存，即是单显配置
  100e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e09:	0f b7 00             	movzwl (%eax),%eax
  100e0c:	0f b7 c0             	movzwl %ax,%eax
  100e0f:	3d 5a a5 00 00       	cmp    $0xa55a,%eax
  100e14:	74 12                	je     100e28 <cga_init+0x41>
        cp = (uint16_t*)MONO_BUF;                         //设置为单显的显存基址 MONO_BUF： 0xB0000
  100e16:	c7 45 fc 00 00 0b 00 	movl   $0xb0000,-0x4(%ebp)
        addr_6845 = MONO_BASE;                           //设置为单显控制的IO地址，MONO_BASE: 0x3B4
  100e1d:	66 c7 05 66 ee 10 00 	movw   $0x3b4,0x10ee66
  100e24:	b4 03 
  100e26:	eb 13                	jmp    100e3b <cga_init+0x54>
    } else {                                                                // 如果读出来了，有这块显存，即是彩显配置
        *cp = was;                                                      //还原原来显存位置的值
  100e28:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100e2b:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e2f:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;                               // 设置为彩显控制的IO地址，CGA_BASE: 0x3D4 
  100e32:	66 c7 05 66 ee 10 00 	movw   $0x3d4,0x10ee66
  100e39:	d4 03 
    // Extract cursor location
    // 6845索引寄存器的index 0x0E（及十进制的14）== 光标位置(高位)
    // 6845索引寄存器的index 0x0F（及十进制的15）== 光标位置(低位)
    // 6845 reg 15 : Cursor Address (Low Byte)
    uint32_t pos;
    outb(addr_6845, 14);                                        
  100e3b:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e42:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100e46:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e4a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100e4e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100e52:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;                       //读出了光标位置(高位)
  100e53:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e5a:	40                   	inc    %eax
  100e5b:	0f b7 c0             	movzwl %ax,%eax
  100e5e:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100e62:	0f b7 45 ea          	movzwl -0x16(%ebp),%eax
  100e66:	89 c2                	mov    %eax,%edx
  100e68:	ec                   	in     (%dx),%al
  100e69:	88 45 e9             	mov    %al,-0x17(%ebp)
    return data;
  100e6c:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100e70:	0f b6 c0             	movzbl %al,%eax
  100e73:	c1 e0 08             	shl    $0x8,%eax
  100e76:	89 45 f4             	mov    %eax,-0xc(%ebp)
    outb(addr_6845, 15);
  100e79:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e80:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100e84:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100e88:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100e8c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e90:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);                             //读出了光标位置(低位)
  100e91:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  100e98:	40                   	inc    %eax
  100e99:	0f b7 c0             	movzwl %ax,%eax
  100e9c:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100ea0:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100ea4:	89 c2                	mov    %eax,%edx
  100ea6:	ec                   	in     (%dx),%al
  100ea7:	88 45 f1             	mov    %al,-0xf(%ebp)
    return data;
  100eaa:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100eae:	0f b6 c0             	movzbl %al,%eax
  100eb1:	09 45 f4             	or     %eax,-0xc(%ebp)

    crt_buf = (uint16_t*) cp;                                  //crt_buf是CGA显存起始地址
  100eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  100eb7:	a3 60 ee 10 00       	mov    %eax,0x10ee60
    crt_pos = pos;                                                  //crt_pos是CGA当前光标位置
  100ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ebf:	0f b7 c0             	movzwl %ax,%eax
  100ec2:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
}
  100ec8:	90                   	nop
  100ec9:	c9                   	leave  
  100eca:	c3                   	ret    

00100ecb <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100ecb:	55                   	push   %ebp
  100ecc:	89 e5                	mov    %esp,%ebp
  100ece:	83 ec 48             	sub    $0x48,%esp
  100ed1:	66 c7 45 d2 fa 03    	movw   $0x3fa,-0x2e(%ebp)
  100ed7:	c6 45 d1 00          	movb   $0x0,-0x2f(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100edb:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  100edf:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  100ee3:	ee                   	out    %al,(%dx)
  100ee4:	66 c7 45 d6 fb 03    	movw   $0x3fb,-0x2a(%ebp)
  100eea:	c6 45 d5 80          	movb   $0x80,-0x2b(%ebp)
  100eee:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  100ef2:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  100ef6:	ee                   	out    %al,(%dx)
  100ef7:	66 c7 45 da f8 03    	movw   $0x3f8,-0x26(%ebp)
  100efd:	c6 45 d9 0c          	movb   $0xc,-0x27(%ebp)
  100f01:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  100f05:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f09:	ee                   	out    %al,(%dx)
  100f0a:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100f10:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
  100f14:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  100f18:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  100f1c:	ee                   	out    %al,(%dx)
  100f1d:	66 c7 45 e2 fb 03    	movw   $0x3fb,-0x1e(%ebp)
  100f23:	c6 45 e1 03          	movb   $0x3,-0x1f(%ebp)
  100f27:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f2b:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f2f:	ee                   	out    %al,(%dx)
  100f30:	66 c7 45 e6 fc 03    	movw   $0x3fc,-0x1a(%ebp)
  100f36:	c6 45 e5 00          	movb   $0x0,-0x1b(%ebp)
  100f3a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f3e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f42:	ee                   	out    %al,(%dx)
  100f43:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100f49:	c6 45 e9 01          	movb   $0x1,-0x17(%ebp)
  100f4d:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f51:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f55:	ee                   	out    %al,(%dx)
  100f56:	66 c7 45 ee fd 03    	movw   $0x3fd,-0x12(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f5c:	0f b7 45 ee          	movzwl -0x12(%ebp),%eax
  100f60:	89 c2                	mov    %eax,%edx
  100f62:	ec                   	in     (%dx),%al
  100f63:	88 45 ed             	mov    %al,-0x13(%ebp)
    return data;
  100f66:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  100f6a:	3c ff                	cmp    $0xff,%al
  100f6c:	0f 95 c0             	setne  %al
  100f6f:	0f b6 c0             	movzbl %al,%eax
  100f72:	a3 68 ee 10 00       	mov    %eax,0x10ee68
  100f77:	66 c7 45 f2 fa 03    	movw   $0x3fa,-0xe(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  100f7d:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  100f81:	89 c2                	mov    %eax,%edx
  100f83:	ec                   	in     (%dx),%al
  100f84:	88 45 f1             	mov    %al,-0xf(%ebp)
  100f87:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  100f8d:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100f91:	89 c2                	mov    %eax,%edx
  100f93:	ec                   	in     (%dx),%al
  100f94:	88 45 f5             	mov    %al,-0xb(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  100f97:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  100f9c:	85 c0                	test   %eax,%eax
  100f9e:	74 0c                	je     100fac <serial_init+0xe1>
        pic_enable(IRQ_COM1);
  100fa0:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  100fa7:	e8 b9 06 00 00       	call   101665 <pic_enable>
    }
}
  100fac:	90                   	nop
  100fad:	c9                   	leave  
  100fae:	c3                   	ret    

00100faf <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  100faf:	55                   	push   %ebp
  100fb0:	89 e5                	mov    %esp,%ebp
  100fb2:	83 ec 20             	sub    $0x20,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fb5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  100fbc:	eb 08                	jmp    100fc6 <lpt_putc_sub+0x17>
        delay();
  100fbe:	e8 db fd ff ff       	call   100d9e <delay>
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  100fc3:	ff 45 fc             	incl   -0x4(%ebp)
  100fc6:	66 c7 45 fa 79 03    	movw   $0x379,-0x6(%ebp)
  100fcc:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  100fd0:	89 c2                	mov    %eax,%edx
  100fd2:	ec                   	in     (%dx),%al
  100fd3:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  100fd6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  100fda:	84 c0                	test   %al,%al
  100fdc:	78 09                	js     100fe7 <lpt_putc_sub+0x38>
  100fde:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  100fe5:	7e d7                	jle    100fbe <lpt_putc_sub+0xf>
    }
    outb(LPTPORT + 0, c);
  100fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  100fea:	0f b6 c0             	movzbl %al,%eax
  100fed:	66 c7 45 ee 78 03    	movw   $0x378,-0x12(%ebp)
  100ff3:	88 45 ed             	mov    %al,-0x13(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  100ff6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ffa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100ffe:	ee                   	out    %al,(%dx)
  100fff:	66 c7 45 f2 7a 03    	movw   $0x37a,-0xe(%ebp)
  101005:	c6 45 f1 0d          	movb   $0xd,-0xf(%ebp)
  101009:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  10100d:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101011:	ee                   	out    %al,(%dx)
  101012:	66 c7 45 f6 7a 03    	movw   $0x37a,-0xa(%ebp)
  101018:	c6 45 f5 08          	movb   $0x8,-0xb(%ebp)
  10101c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101020:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101024:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  101025:	90                   	nop
  101026:	c9                   	leave  
  101027:	c3                   	ret    

00101028 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101028:	55                   	push   %ebp
  101029:	89 e5                	mov    %esp,%ebp
  10102b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  10102e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101032:	74 0d                	je     101041 <lpt_putc+0x19>
        lpt_putc_sub(c);
  101034:	8b 45 08             	mov    0x8(%ebp),%eax
  101037:	89 04 24             	mov    %eax,(%esp)
  10103a:	e8 70 ff ff ff       	call   100faf <lpt_putc_sub>
    else {
        lpt_putc_sub('\b');
        lpt_putc_sub(' ');
        lpt_putc_sub('\b');
    }
}
  10103f:	eb 24                	jmp    101065 <lpt_putc+0x3d>
        lpt_putc_sub('\b');
  101041:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101048:	e8 62 ff ff ff       	call   100faf <lpt_putc_sub>
        lpt_putc_sub(' ');
  10104d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  101054:	e8 56 ff ff ff       	call   100faf <lpt_putc_sub>
        lpt_putc_sub('\b');
  101059:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101060:	e8 4a ff ff ff       	call   100faf <lpt_putc_sub>
}
  101065:	90                   	nop
  101066:	c9                   	leave  
  101067:	c3                   	ret    

00101068 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  101068:	55                   	push   %ebp
  101069:	89 e5                	mov    %esp,%ebp
  10106b:	53                   	push   %ebx
  10106c:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  10106f:	8b 45 08             	mov    0x8(%ebp),%eax
  101072:	25 00 ff ff ff       	and    $0xffffff00,%eax
  101077:	85 c0                	test   %eax,%eax
  101079:	75 07                	jne    101082 <cga_putc+0x1a>
        c |= 0x0700;
  10107b:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101082:	8b 45 08             	mov    0x8(%ebp),%eax
  101085:	0f b6 c0             	movzbl %al,%eax
  101088:	83 f8 0a             	cmp    $0xa,%eax
  10108b:	74 55                	je     1010e2 <cga_putc+0x7a>
  10108d:	83 f8 0d             	cmp    $0xd,%eax
  101090:	74 63                	je     1010f5 <cga_putc+0x8d>
  101092:	83 f8 08             	cmp    $0x8,%eax
  101095:	0f 85 94 00 00 00    	jne    10112f <cga_putc+0xc7>
    case '\b':
        if (crt_pos > 0) {
  10109b:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010a2:	85 c0                	test   %eax,%eax
  1010a4:	0f 84 af 00 00 00    	je     101159 <cga_putc+0xf1>
            crt_pos --;
  1010aa:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010b1:	48                   	dec    %eax
  1010b2:	0f b7 c0             	movzwl %ax,%eax
  1010b5:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  1010bb:	8b 45 08             	mov    0x8(%ebp),%eax
  1010be:	98                   	cwtl   
  1010bf:	25 00 ff ff ff       	and    $0xffffff00,%eax
  1010c4:	98                   	cwtl   
  1010c5:	83 c8 20             	or     $0x20,%eax
  1010c8:	98                   	cwtl   
  1010c9:	8b 15 60 ee 10 00    	mov    0x10ee60,%edx
  1010cf:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  1010d6:	01 c9                	add    %ecx,%ecx
  1010d8:	01 ca                	add    %ecx,%edx
  1010da:	0f b7 c0             	movzwl %ax,%eax
  1010dd:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1010e0:	eb 77                	jmp    101159 <cga_putc+0xf1>
    case '\n':
        crt_pos += CRT_COLS;
  1010e2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1010e9:	83 c0 50             	add    $0x50,%eax
  1010ec:	0f b7 c0             	movzwl %ax,%eax
  1010ef:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1010f5:	0f b7 1d 64 ee 10 00 	movzwl 0x10ee64,%ebx
  1010fc:	0f b7 0d 64 ee 10 00 	movzwl 0x10ee64,%ecx
  101103:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
  101108:	89 c8                	mov    %ecx,%eax
  10110a:	f7 e2                	mul    %edx
  10110c:	c1 ea 06             	shr    $0x6,%edx
  10110f:	89 d0                	mov    %edx,%eax
  101111:	c1 e0 02             	shl    $0x2,%eax
  101114:	01 d0                	add    %edx,%eax
  101116:	c1 e0 04             	shl    $0x4,%eax
  101119:	29 c1                	sub    %eax,%ecx
  10111b:	89 c8                	mov    %ecx,%eax
  10111d:	0f b7 c0             	movzwl %ax,%eax
  101120:	29 c3                	sub    %eax,%ebx
  101122:	89 d8                	mov    %ebx,%eax
  101124:	0f b7 c0             	movzwl %ax,%eax
  101127:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
        break;
  10112d:	eb 2b                	jmp    10115a <cga_putc+0xf2>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  10112f:	8b 0d 60 ee 10 00    	mov    0x10ee60,%ecx
  101135:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  10113c:	8d 50 01             	lea    0x1(%eax),%edx
  10113f:	0f b7 d2             	movzwl %dx,%edx
  101142:	66 89 15 64 ee 10 00 	mov    %dx,0x10ee64
  101149:	01 c0                	add    %eax,%eax
  10114b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
  10114e:	8b 45 08             	mov    0x8(%ebp),%eax
  101151:	0f b7 c0             	movzwl %ax,%eax
  101154:	66 89 02             	mov    %ax,(%edx)
        break;
  101157:	eb 01                	jmp    10115a <cga_putc+0xf2>
        break;
  101159:	90                   	nop
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  10115a:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101161:	3d cf 07 00 00       	cmp    $0x7cf,%eax
  101166:	76 5d                	jbe    1011c5 <cga_putc+0x15d>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101168:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10116d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  101173:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  101178:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  10117f:	00 
  101180:	89 54 24 04          	mov    %edx,0x4(%esp)
  101184:	89 04 24             	mov    %eax,(%esp)
  101187:	e8 e0 1c 00 00       	call   102e6c <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10118c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  101193:	eb 14                	jmp    1011a9 <cga_putc+0x141>
            crt_buf[i] = 0x0700 | ' ';
  101195:	a1 60 ee 10 00       	mov    0x10ee60,%eax
  10119a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10119d:	01 d2                	add    %edx,%edx
  10119f:	01 d0                	add    %edx,%eax
  1011a1:	66 c7 00 20 07       	movw   $0x720,(%eax)
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  1011a6:	ff 45 f4             	incl   -0xc(%ebp)
  1011a9:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  1011b0:	7e e3                	jle    101195 <cga_putc+0x12d>
        }
        crt_pos -= CRT_COLS;
  1011b2:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011b9:	83 e8 50             	sub    $0x50,%eax
  1011bc:	0f b7 c0             	movzwl %ax,%eax
  1011bf:	66 a3 64 ee 10 00    	mov    %ax,0x10ee64
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  1011c5:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  1011cc:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  1011d0:	c6 45 e5 0e          	movb   $0xe,-0x1b(%ebp)
  1011d4:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  1011d8:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  1011dc:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1011dd:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  1011e4:	c1 e8 08             	shr    $0x8,%eax
  1011e7:	0f b7 c0             	movzwl %ax,%eax
  1011ea:	0f b6 c0             	movzbl %al,%eax
  1011ed:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  1011f4:	42                   	inc    %edx
  1011f5:	0f b7 d2             	movzwl %dx,%edx
  1011f8:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  1011fc:	88 45 e9             	mov    %al,-0x17(%ebp)
  1011ff:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  101203:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101207:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  101208:	0f b7 05 66 ee 10 00 	movzwl 0x10ee66,%eax
  10120f:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  101213:	c6 45 ed 0f          	movb   $0xf,-0x13(%ebp)
  101217:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  10121b:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10121f:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  101220:	0f b7 05 64 ee 10 00 	movzwl 0x10ee64,%eax
  101227:	0f b6 c0             	movzbl %al,%eax
  10122a:	0f b7 15 66 ee 10 00 	movzwl 0x10ee66,%edx
  101231:	42                   	inc    %edx
  101232:	0f b7 d2             	movzwl %dx,%edx
  101235:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  101239:	88 45 f1             	mov    %al,-0xf(%ebp)
  10123c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101240:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101244:	ee                   	out    %al,(%dx)
}
  101245:	90                   	nop
  101246:	83 c4 34             	add    $0x34,%esp
  101249:	5b                   	pop    %ebx
  10124a:	5d                   	pop    %ebp
  10124b:	c3                   	ret    

0010124c <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  10124c:	55                   	push   %ebp
  10124d:	89 e5                	mov    %esp,%ebp
  10124f:	83 ec 10             	sub    $0x10,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101252:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101259:	eb 08                	jmp    101263 <serial_putc_sub+0x17>
        delay();
  10125b:	e8 3e fb ff ff       	call   100d9e <delay>
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101260:	ff 45 fc             	incl   -0x4(%ebp)
  101263:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101269:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  10126d:	89 c2                	mov    %eax,%edx
  10126f:	ec                   	in     (%dx),%al
  101270:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101273:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101277:	0f b6 c0             	movzbl %al,%eax
  10127a:	83 e0 20             	and    $0x20,%eax
  10127d:	85 c0                	test   %eax,%eax
  10127f:	75 09                	jne    10128a <serial_putc_sub+0x3e>
  101281:	81 7d fc ff 31 00 00 	cmpl   $0x31ff,-0x4(%ebp)
  101288:	7e d1                	jle    10125b <serial_putc_sub+0xf>
    }
    outb(COM1 + COM_TX, c);
  10128a:	8b 45 08             	mov    0x8(%ebp),%eax
  10128d:	0f b6 c0             	movzbl %al,%eax
  101290:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
  101296:	88 45 f5             	mov    %al,-0xb(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  101299:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10129d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  1012a1:	ee                   	out    %al,(%dx)
}
  1012a2:	90                   	nop
  1012a3:	c9                   	leave  
  1012a4:	c3                   	ret    

001012a5 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  1012a5:	55                   	push   %ebp
  1012a6:	89 e5                	mov    %esp,%ebp
  1012a8:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  1012ab:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  1012af:	74 0d                	je     1012be <serial_putc+0x19>
        serial_putc_sub(c);
  1012b1:	8b 45 08             	mov    0x8(%ebp),%eax
  1012b4:	89 04 24             	mov    %eax,(%esp)
  1012b7:	e8 90 ff ff ff       	call   10124c <serial_putc_sub>
    else {
        serial_putc_sub('\b');
        serial_putc_sub(' ');
        serial_putc_sub('\b');
    }
}
  1012bc:	eb 24                	jmp    1012e2 <serial_putc+0x3d>
        serial_putc_sub('\b');
  1012be:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012c5:	e8 82 ff ff ff       	call   10124c <serial_putc_sub>
        serial_putc_sub(' ');
  1012ca:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1012d1:	e8 76 ff ff ff       	call   10124c <serial_putc_sub>
        serial_putc_sub('\b');
  1012d6:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1012dd:	e8 6a ff ff ff       	call   10124c <serial_putc_sub>
}
  1012e2:	90                   	nop
  1012e3:	c9                   	leave  
  1012e4:	c3                   	ret    

001012e5 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1012e5:	55                   	push   %ebp
  1012e6:	89 e5                	mov    %esp,%ebp
  1012e8:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1012eb:	eb 33                	jmp    101320 <cons_intr+0x3b>
        if (c != 0) {
  1012ed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1012f1:	74 2d                	je     101320 <cons_intr+0x3b>
            cons.buf[cons.wpos ++] = c;
  1012f3:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1012f8:	8d 50 01             	lea    0x1(%eax),%edx
  1012fb:	89 15 84 f0 10 00    	mov    %edx,0x10f084
  101301:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101304:	88 90 80 ee 10 00    	mov    %dl,0x10ee80(%eax)
            if (cons.wpos == CONSBUFSIZE) {
  10130a:	a1 84 f0 10 00       	mov    0x10f084,%eax
  10130f:	3d 00 02 00 00       	cmp    $0x200,%eax
  101314:	75 0a                	jne    101320 <cons_intr+0x3b>
                cons.wpos = 0;
  101316:	c7 05 84 f0 10 00 00 	movl   $0x0,0x10f084
  10131d:	00 00 00 
    while ((c = (*proc)()) != -1) {
  101320:	8b 45 08             	mov    0x8(%ebp),%eax
  101323:	ff d0                	call   *%eax
  101325:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101328:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  10132c:	75 bf                	jne    1012ed <cons_intr+0x8>
            }
        }
    }
}
  10132e:	90                   	nop
  10132f:	c9                   	leave  
  101330:	c3                   	ret    

00101331 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101331:	55                   	push   %ebp
  101332:	89 e5                	mov    %esp,%ebp
  101334:	83 ec 10             	sub    $0x10,%esp
  101337:	66 c7 45 fa fd 03    	movw   $0x3fd,-0x6(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  10133d:	0f b7 45 fa          	movzwl -0x6(%ebp),%eax
  101341:	89 c2                	mov    %eax,%edx
  101343:	ec                   	in     (%dx),%al
  101344:	88 45 f9             	mov    %al,-0x7(%ebp)
    return data;
  101347:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10134b:	0f b6 c0             	movzbl %al,%eax
  10134e:	83 e0 01             	and    $0x1,%eax
  101351:	85 c0                	test   %eax,%eax
  101353:	75 07                	jne    10135c <serial_proc_data+0x2b>
        return -1;
  101355:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10135a:	eb 2a                	jmp    101386 <serial_proc_data+0x55>
  10135c:	66 c7 45 f6 f8 03    	movw   $0x3f8,-0xa(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  101362:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  101366:	89 c2                	mov    %eax,%edx
  101368:	ec                   	in     (%dx),%al
  101369:	88 45 f5             	mov    %al,-0xb(%ebp)
    return data;
  10136c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101370:	0f b6 c0             	movzbl %al,%eax
  101373:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (c == 127) {
  101376:	83 7d fc 7f          	cmpl   $0x7f,-0x4(%ebp)
  10137a:	75 07                	jne    101383 <serial_proc_data+0x52>
        c = '\b';
  10137c:	c7 45 fc 08 00 00 00 	movl   $0x8,-0x4(%ebp)
    }
    return c;
  101383:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  101386:	c9                   	leave  
  101387:	c3                   	ret    

00101388 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101388:	55                   	push   %ebp
  101389:	89 e5                	mov    %esp,%ebp
  10138b:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10138e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101393:	85 c0                	test   %eax,%eax
  101395:	74 0c                	je     1013a3 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101397:	c7 04 24 31 13 10 00 	movl   $0x101331,(%esp)
  10139e:	e8 42 ff ff ff       	call   1012e5 <cons_intr>
    }
}
  1013a3:	90                   	nop
  1013a4:	c9                   	leave  
  1013a5:	c3                   	ret    

001013a6 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  1013a6:	55                   	push   %ebp
  1013a7:	89 e5                	mov    %esp,%ebp
  1013a9:	83 ec 38             	sub    $0x38,%esp
  1013ac:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1013b5:	89 c2                	mov    %eax,%edx
  1013b7:	ec                   	in     (%dx),%al
  1013b8:	88 45 ef             	mov    %al,-0x11(%ebp)
    return data;
  1013bb:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1013bf:	0f b6 c0             	movzbl %al,%eax
  1013c2:	83 e0 01             	and    $0x1,%eax
  1013c5:	85 c0                	test   %eax,%eax
  1013c7:	75 0a                	jne    1013d3 <kbd_proc_data+0x2d>
        return -1;
  1013c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1013ce:	e9 55 01 00 00       	jmp    101528 <kbd_proc_data+0x182>
  1013d3:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port));
  1013d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1013dc:	89 c2                	mov    %eax,%edx
  1013de:	ec                   	in     (%dx),%al
  1013df:	88 45 eb             	mov    %al,-0x15(%ebp)
    return data;
  1013e2:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1013e6:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1013e9:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1013ed:	75 17                	jne    101406 <kbd_proc_data+0x60>
        // E0 escape character
        shift |= E0ESC;
  1013ef:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1013f4:	83 c8 40             	or     $0x40,%eax
  1013f7:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  1013fc:	b8 00 00 00 00       	mov    $0x0,%eax
  101401:	e9 22 01 00 00       	jmp    101528 <kbd_proc_data+0x182>
    } else if (data & 0x80) {
  101406:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10140a:	84 c0                	test   %al,%al
  10140c:	79 45                	jns    101453 <kbd_proc_data+0xad>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10140e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101413:	83 e0 40             	and    $0x40,%eax
  101416:	85 c0                	test   %eax,%eax
  101418:	75 08                	jne    101422 <kbd_proc_data+0x7c>
  10141a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10141e:	24 7f                	and    $0x7f,%al
  101420:	eb 04                	jmp    101426 <kbd_proc_data+0x80>
  101422:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101426:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101429:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10142d:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  101434:	0c 40                	or     $0x40,%al
  101436:	0f b6 c0             	movzbl %al,%eax
  101439:	f7 d0                	not    %eax
  10143b:	89 c2                	mov    %eax,%edx
  10143d:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101442:	21 d0                	and    %edx,%eax
  101444:	a3 88 f0 10 00       	mov    %eax,0x10f088
        return 0;
  101449:	b8 00 00 00 00       	mov    $0x0,%eax
  10144e:	e9 d5 00 00 00       	jmp    101528 <kbd_proc_data+0x182>
    } else if (shift & E0ESC) {
  101453:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101458:	83 e0 40             	and    $0x40,%eax
  10145b:	85 c0                	test   %eax,%eax
  10145d:	74 11                	je     101470 <kbd_proc_data+0xca>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10145f:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101463:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101468:	83 e0 bf             	and    $0xffffffbf,%eax
  10146b:	a3 88 f0 10 00       	mov    %eax,0x10f088
    }

    shift |= shiftcode[data];
  101470:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101474:	0f b6 80 40 e0 10 00 	movzbl 0x10e040(%eax),%eax
  10147b:	0f b6 d0             	movzbl %al,%edx
  10147e:	a1 88 f0 10 00       	mov    0x10f088,%eax
  101483:	09 d0                	or     %edx,%eax
  101485:	a3 88 f0 10 00       	mov    %eax,0x10f088
    shift ^= togglecode[data];
  10148a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10148e:	0f b6 80 40 e1 10 00 	movzbl 0x10e140(%eax),%eax
  101495:	0f b6 d0             	movzbl %al,%edx
  101498:	a1 88 f0 10 00       	mov    0x10f088,%eax
  10149d:	31 d0                	xor    %edx,%eax
  10149f:	a3 88 f0 10 00       	mov    %eax,0x10f088

    c = charcode[shift & (CTL | SHIFT)][data];
  1014a4:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014a9:	83 e0 03             	and    $0x3,%eax
  1014ac:	8b 14 85 40 e5 10 00 	mov    0x10e540(,%eax,4),%edx
  1014b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1014b7:	01 d0                	add    %edx,%eax
  1014b9:	0f b6 00             	movzbl (%eax),%eax
  1014bc:	0f b6 c0             	movzbl %al,%eax
  1014bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1014c2:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014c7:	83 e0 08             	and    $0x8,%eax
  1014ca:	85 c0                	test   %eax,%eax
  1014cc:	74 22                	je     1014f0 <kbd_proc_data+0x14a>
        if ('a' <= c && c <= 'z')
  1014ce:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1014d2:	7e 0c                	jle    1014e0 <kbd_proc_data+0x13a>
  1014d4:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1014d8:	7f 06                	jg     1014e0 <kbd_proc_data+0x13a>
            c += 'A' - 'a';
  1014da:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1014de:	eb 10                	jmp    1014f0 <kbd_proc_data+0x14a>
        else if ('A' <= c && c <= 'Z')
  1014e0:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1014e4:	7e 0a                	jle    1014f0 <kbd_proc_data+0x14a>
  1014e6:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1014ea:	7f 04                	jg     1014f0 <kbd_proc_data+0x14a>
            c += 'a' - 'A';
  1014ec:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1014f0:	a1 88 f0 10 00       	mov    0x10f088,%eax
  1014f5:	f7 d0                	not    %eax
  1014f7:	83 e0 06             	and    $0x6,%eax
  1014fa:	85 c0                	test   %eax,%eax
  1014fc:	75 27                	jne    101525 <kbd_proc_data+0x17f>
  1014fe:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101505:	75 1e                	jne    101525 <kbd_proc_data+0x17f>
        cprintf("Rebooting!\n");
  101507:	c7 04 24 7d 39 10 00 	movl   $0x10397d,(%esp)
  10150e:	e8 59 ed ff ff       	call   10026c <cprintf>
  101513:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101519:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port));
  10151d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101521:	8b 55 e8             	mov    -0x18(%ebp),%edx
  101524:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101525:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101528:	c9                   	leave  
  101529:	c3                   	ret    

0010152a <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10152a:	55                   	push   %ebp
  10152b:	89 e5                	mov    %esp,%ebp
  10152d:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101530:	c7 04 24 a6 13 10 00 	movl   $0x1013a6,(%esp)
  101537:	e8 a9 fd ff ff       	call   1012e5 <cons_intr>
}
  10153c:	90                   	nop
  10153d:	c9                   	leave  
  10153e:	c3                   	ret    

0010153f <kbd_init>:

static void
kbd_init(void) {
  10153f:	55                   	push   %ebp
  101540:	89 e5                	mov    %esp,%ebp
  101542:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101545:	e8 e0 ff ff ff       	call   10152a <kbd_intr>
    pic_enable(IRQ_KBD);
  10154a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101551:	e8 0f 01 00 00       	call   101665 <pic_enable>
}
  101556:	90                   	nop
  101557:	c9                   	leave  
  101558:	c3                   	ret    

00101559 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  101559:	55                   	push   %ebp
  10155a:	89 e5                	mov    %esp,%ebp
  10155c:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  10155f:	e8 83 f8 ff ff       	call   100de7 <cga_init>
    serial_init();
  101564:	e8 62 f9 ff ff       	call   100ecb <serial_init>
    kbd_init();
  101569:	e8 d1 ff ff ff       	call   10153f <kbd_init>
    if (!serial_exists) {
  10156e:	a1 68 ee 10 00       	mov    0x10ee68,%eax
  101573:	85 c0                	test   %eax,%eax
  101575:	75 0c                	jne    101583 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  101577:	c7 04 24 89 39 10 00 	movl   $0x103989,(%esp)
  10157e:	e8 e9 ec ff ff       	call   10026c <cprintf>
    }
}
  101583:	90                   	nop
  101584:	c9                   	leave  
  101585:	c3                   	ret    

00101586 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101586:	55                   	push   %ebp
  101587:	89 e5                	mov    %esp,%ebp
  101589:	83 ec 18             	sub    $0x18,%esp
    lpt_putc(c);
  10158c:	8b 45 08             	mov    0x8(%ebp),%eax
  10158f:	89 04 24             	mov    %eax,(%esp)
  101592:	e8 91 fa ff ff       	call   101028 <lpt_putc>
    cga_putc(c);
  101597:	8b 45 08             	mov    0x8(%ebp),%eax
  10159a:	89 04 24             	mov    %eax,(%esp)
  10159d:	e8 c6 fa ff ff       	call   101068 <cga_putc>
    serial_putc(c);
  1015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  1015a5:	89 04 24             	mov    %eax,(%esp)
  1015a8:	e8 f8 fc ff ff       	call   1012a5 <serial_putc>
}
  1015ad:	90                   	nop
  1015ae:	c9                   	leave  
  1015af:	c3                   	ret    

001015b0 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1015b0:	55                   	push   %ebp
  1015b1:	89 e5                	mov    %esp,%ebp
  1015b3:	83 ec 18             	sub    $0x18,%esp
    int c;

    // poll for any pending input characters,
    // so that this function works even when interrupts are disabled
    // (e.g., when called from the kernel monitor).
    serial_intr();
  1015b6:	e8 cd fd ff ff       	call   101388 <serial_intr>
    kbd_intr();
  1015bb:	e8 6a ff ff ff       	call   10152a <kbd_intr>

    // grab the next character from the input buffer.
    if (cons.rpos != cons.wpos) {
  1015c0:	8b 15 80 f0 10 00    	mov    0x10f080,%edx
  1015c6:	a1 84 f0 10 00       	mov    0x10f084,%eax
  1015cb:	39 c2                	cmp    %eax,%edx
  1015cd:	74 36                	je     101605 <cons_getc+0x55>
        c = cons.buf[cons.rpos ++];
  1015cf:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015d4:	8d 50 01             	lea    0x1(%eax),%edx
  1015d7:	89 15 80 f0 10 00    	mov    %edx,0x10f080
  1015dd:	0f b6 80 80 ee 10 00 	movzbl 0x10ee80(%eax),%eax
  1015e4:	0f b6 c0             	movzbl %al,%eax
  1015e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (cons.rpos == CONSBUFSIZE) {
  1015ea:	a1 80 f0 10 00       	mov    0x10f080,%eax
  1015ef:	3d 00 02 00 00       	cmp    $0x200,%eax
  1015f4:	75 0a                	jne    101600 <cons_getc+0x50>
            cons.rpos = 0;
  1015f6:	c7 05 80 f0 10 00 00 	movl   $0x0,0x10f080
  1015fd:	00 00 00 
        }
        return c;
  101600:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101603:	eb 05                	jmp    10160a <cons_getc+0x5a>
    }
    return 0;
  101605:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10160a:	c9                   	leave  
  10160b:	c3                   	ret    

0010160c <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  10160c:	55                   	push   %ebp
  10160d:	89 e5                	mov    %esp,%ebp
  10160f:	83 ec 14             	sub    $0x14,%esp
  101612:	8b 45 08             	mov    0x8(%ebp),%eax
  101615:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  101619:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10161c:	66 a3 50 e5 10 00    	mov    %ax,0x10e550
    if (did_init) {
  101622:	a1 8c f0 10 00       	mov    0x10f08c,%eax
  101627:	85 c0                	test   %eax,%eax
  101629:	74 37                	je     101662 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  10162b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10162e:	0f b6 c0             	movzbl %al,%eax
  101631:	66 c7 45 fa 21 00    	movw   $0x21,-0x6(%ebp)
  101637:	88 45 f9             	mov    %al,-0x7(%ebp)
  10163a:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10163e:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101642:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101643:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101647:	c1 e8 08             	shr    $0x8,%eax
  10164a:	0f b7 c0             	movzwl %ax,%eax
  10164d:	0f b6 c0             	movzbl %al,%eax
  101650:	66 c7 45 fe a1 00    	movw   $0xa1,-0x2(%ebp)
  101656:	88 45 fd             	mov    %al,-0x3(%ebp)
  101659:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  10165d:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101661:	ee                   	out    %al,(%dx)
    }
}
  101662:	90                   	nop
  101663:	c9                   	leave  
  101664:	c3                   	ret    

00101665 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101665:	55                   	push   %ebp
  101666:	89 e5                	mov    %esp,%ebp
  101668:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10166b:	8b 45 08             	mov    0x8(%ebp),%eax
  10166e:	ba 01 00 00 00       	mov    $0x1,%edx
  101673:	88 c1                	mov    %al,%cl
  101675:	d3 e2                	shl    %cl,%edx
  101677:	89 d0                	mov    %edx,%eax
  101679:	98                   	cwtl   
  10167a:	f7 d0                	not    %eax
  10167c:	0f bf d0             	movswl %ax,%edx
  10167f:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  101686:	98                   	cwtl   
  101687:	21 d0                	and    %edx,%eax
  101689:	98                   	cwtl   
  10168a:	0f b7 c0             	movzwl %ax,%eax
  10168d:	89 04 24             	mov    %eax,(%esp)
  101690:	e8 77 ff ff ff       	call   10160c <pic_setmask>
}
  101695:	90                   	nop
  101696:	c9                   	leave  
  101697:	c3                   	ret    

00101698 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  101698:	55                   	push   %ebp
  101699:	89 e5                	mov    %esp,%ebp
  10169b:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  10169e:	c7 05 8c f0 10 00 01 	movl   $0x1,0x10f08c
  1016a5:	00 00 00 
  1016a8:	66 c7 45 ca 21 00    	movw   $0x21,-0x36(%ebp)
  1016ae:	c6 45 c9 ff          	movb   $0xff,-0x37(%ebp)
  1016b2:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1016b6:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1016ba:	ee                   	out    %al,(%dx)
  1016bb:	66 c7 45 ce a1 00    	movw   $0xa1,-0x32(%ebp)
  1016c1:	c6 45 cd ff          	movb   $0xff,-0x33(%ebp)
  1016c5:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1016c9:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1016cd:	ee                   	out    %al,(%dx)
  1016ce:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1016d4:	c6 45 d1 11          	movb   $0x11,-0x2f(%ebp)
  1016d8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1016dc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1016e0:	ee                   	out    %al,(%dx)
  1016e1:	66 c7 45 d6 21 00    	movw   $0x21,-0x2a(%ebp)
  1016e7:	c6 45 d5 20          	movb   $0x20,-0x2b(%ebp)
  1016eb:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1016ef:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1016f3:	ee                   	out    %al,(%dx)
  1016f4:	66 c7 45 da 21 00    	movw   $0x21,-0x26(%ebp)
  1016fa:	c6 45 d9 04          	movb   $0x4,-0x27(%ebp)
  1016fe:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101702:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101706:	ee                   	out    %al,(%dx)
  101707:	66 c7 45 de 21 00    	movw   $0x21,-0x22(%ebp)
  10170d:	c6 45 dd 03          	movb   $0x3,-0x23(%ebp)
  101711:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101715:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101719:	ee                   	out    %al,(%dx)
  10171a:	66 c7 45 e2 a0 00    	movw   $0xa0,-0x1e(%ebp)
  101720:	c6 45 e1 11          	movb   $0x11,-0x1f(%ebp)
  101724:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101728:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  10172c:	ee                   	out    %al,(%dx)
  10172d:	66 c7 45 e6 a1 00    	movw   $0xa1,-0x1a(%ebp)
  101733:	c6 45 e5 28          	movb   $0x28,-0x1b(%ebp)
  101737:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10173b:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  10173f:	ee                   	out    %al,(%dx)
  101740:	66 c7 45 ea a1 00    	movw   $0xa1,-0x16(%ebp)
  101746:	c6 45 e9 02          	movb   $0x2,-0x17(%ebp)
  10174a:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10174e:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101752:	ee                   	out    %al,(%dx)
  101753:	66 c7 45 ee a1 00    	movw   $0xa1,-0x12(%ebp)
  101759:	c6 45 ed 03          	movb   $0x3,-0x13(%ebp)
  10175d:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101761:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  101765:	ee                   	out    %al,(%dx)
  101766:	66 c7 45 f2 20 00    	movw   $0x20,-0xe(%ebp)
  10176c:	c6 45 f1 68          	movb   $0x68,-0xf(%ebp)
  101770:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101774:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
  101779:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  10177f:	c6 45 f5 0a          	movb   $0xa,-0xb(%ebp)
  101783:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101787:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10178b:	ee                   	out    %al,(%dx)
  10178c:	66 c7 45 fa a0 00    	movw   $0xa0,-0x6(%ebp)
  101792:	c6 45 f9 68          	movb   $0x68,-0x7(%ebp)
  101796:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  10179a:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  10179e:	ee                   	out    %al,(%dx)
  10179f:	66 c7 45 fe a0 00    	movw   $0xa0,-0x2(%ebp)
  1017a5:	c6 45 fd 0a          	movb   $0xa,-0x3(%ebp)
  1017a9:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017ad:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017b1:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1017b2:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017b9:	3d ff ff 00 00       	cmp    $0xffff,%eax
  1017be:	74 0f                	je     1017cf <pic_init+0x137>
        pic_setmask(irq_mask);
  1017c0:	0f b7 05 50 e5 10 00 	movzwl 0x10e550,%eax
  1017c7:	89 04 24             	mov    %eax,(%esp)
  1017ca:	e8 3d fe ff ff       	call   10160c <pic_setmask>
    }
}
  1017cf:	90                   	nop
  1017d0:	c9                   	leave  
  1017d1:	c3                   	ret    

001017d2 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  1017d2:	55                   	push   %ebp
  1017d3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd));
}

static inline void
sti(void) {
    asm volatile ("sti");
  1017d5:	fb                   	sti    
    sti();
}
  1017d6:	90                   	nop
  1017d7:	5d                   	pop    %ebp
  1017d8:	c3                   	ret    

001017d9 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  1017d9:	55                   	push   %ebp
  1017da:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli");
  1017dc:	fa                   	cli    
    cli();
}
  1017dd:	90                   	nop
  1017de:	5d                   	pop    %ebp
  1017df:	c3                   	ret    

001017e0 <print_ticks>:

#define TICK_NUM 100
extern uintptr_t __vectors[];
static int count = 0;

static void print_ticks() {
  1017e0:	55                   	push   %ebp
  1017e1:	89 e5                	mov    %esp,%ebp
  1017e3:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  1017e6:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  1017ed:	00 
  1017ee:	c7 04 24 c0 39 10 00 	movl   $0x1039c0,(%esp)
  1017f5:	e8 72 ea ff ff       	call   10026c <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
  1017fa:	c7 04 24 ca 39 10 00 	movl   $0x1039ca,(%esp)
  101801:	e8 66 ea ff ff       	call   10026c <cprintf>
    panic("EOT: kernel seems ok.");
  101806:	c7 44 24 08 d8 39 10 	movl   $0x1039d8,0x8(%esp)
  10180d:	00 
  10180e:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
  101815:	00 
  101816:	c7 04 24 ee 39 10 00 	movl   $0x1039ee,(%esp)
  10181d:	e8 a1 eb ff ff       	call   1003c3 <__panic>

00101822 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101822:	55                   	push   %ebp
  101823:	89 e5                	mov    %esp,%ebp
  101825:	83 ec 10             	sub    $0x10,%esp
      * (3) After setup the contents of IDT, you will let CPU know where is the IDT by using 'lidt' instruction.
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    int i;
    for(i = 0; i < 256; ++i) {
  101828:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  10182f:	e9 c4 00 00 00       	jmp    1018f8 <idt_init+0xd6>
        SETGATE(idt[i], 0, GD_KTEXT, __vectors[i], DPL_KERNEL);
  101834:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101837:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  10183e:	0f b7 d0             	movzwl %ax,%edx
  101841:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101844:	66 89 14 c5 c0 f0 10 	mov    %dx,0x10f0c0(,%eax,8)
  10184b:	00 
  10184c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10184f:	66 c7 04 c5 c2 f0 10 	movw   $0x8,0x10f0c2(,%eax,8)
  101856:	00 08 00 
  101859:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10185c:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  101863:	00 
  101864:	80 e2 e0             	and    $0xe0,%dl
  101867:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  10186e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101871:	0f b6 14 c5 c4 f0 10 	movzbl 0x10f0c4(,%eax,8),%edx
  101878:	00 
  101879:	80 e2 1f             	and    $0x1f,%dl
  10187c:	88 14 c5 c4 f0 10 00 	mov    %dl,0x10f0c4(,%eax,8)
  101883:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101886:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  10188d:	00 
  10188e:	80 e2 f0             	and    $0xf0,%dl
  101891:	80 ca 0e             	or     $0xe,%dl
  101894:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  10189b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10189e:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018a5:	00 
  1018a6:	80 e2 ef             	and    $0xef,%dl
  1018a9:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018b0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018b3:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018ba:	00 
  1018bb:	80 e2 9f             	and    $0x9f,%dl
  1018be:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018c8:	0f b6 14 c5 c5 f0 10 	movzbl 0x10f0c5(,%eax,8),%edx
  1018cf:	00 
  1018d0:	80 ca 80             	or     $0x80,%dl
  1018d3:	88 14 c5 c5 f0 10 00 	mov    %dl,0x10f0c5(,%eax,8)
  1018da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018dd:	8b 04 85 e0 e5 10 00 	mov    0x10e5e0(,%eax,4),%eax
  1018e4:	c1 e8 10             	shr    $0x10,%eax
  1018e7:	0f b7 d0             	movzwl %ax,%edx
  1018ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1018ed:	66 89 14 c5 c6 f0 10 	mov    %dx,0x10f0c6(,%eax,8)
  1018f4:	00 
    for(i = 0; i < 256; ++i) {
  1018f5:	ff 45 fc             	incl   -0x4(%ebp)
  1018f8:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
  1018ff:	0f 8e 2f ff ff ff    	jle    101834 <idt_init+0x12>
    }
    //set the syscall for user
    SETGATE(idt[T_SYSCALL], 0, GD_KTEXT, __vectors[T_SYSCALL], DPL_USER);
  101905:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  10190a:	0f b7 c0             	movzwl %ax,%eax
  10190d:	66 a3 c0 f4 10 00    	mov    %ax,0x10f4c0
  101913:	66 c7 05 c2 f4 10 00 	movw   $0x8,0x10f4c2
  10191a:	08 00 
  10191c:	0f b6 05 c4 f4 10 00 	movzbl 0x10f4c4,%eax
  101923:	24 e0                	and    $0xe0,%al
  101925:	a2 c4 f4 10 00       	mov    %al,0x10f4c4
  10192a:	0f b6 05 c4 f4 10 00 	movzbl 0x10f4c4,%eax
  101931:	24 1f                	and    $0x1f,%al
  101933:	a2 c4 f4 10 00       	mov    %al,0x10f4c4
  101938:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  10193f:	24 f0                	and    $0xf0,%al
  101941:	0c 0e                	or     $0xe,%al
  101943:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  101948:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  10194f:	24 ef                	and    $0xef,%al
  101951:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  101956:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  10195d:	0c 60                	or     $0x60,%al
  10195f:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  101964:	0f b6 05 c5 f4 10 00 	movzbl 0x10f4c5,%eax
  10196b:	0c 80                	or     $0x80,%al
  10196d:	a2 c5 f4 10 00       	mov    %al,0x10f4c5
  101972:	a1 e0 e7 10 00       	mov    0x10e7e0,%eax
  101977:	c1 e8 10             	shr    $0x10,%eax
  10197a:	0f b7 c0             	movzwl %ax,%eax
  10197d:	66 a3 c6 f4 10 00    	mov    %ax,0x10f4c6
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101983:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  101988:	0f b7 c0             	movzwl %ax,%eax
  10198b:	66 a3 88 f4 10 00    	mov    %ax,0x10f488
  101991:	66 c7 05 8a f4 10 00 	movw   $0x8,0x10f48a
  101998:	08 00 
  10199a:	0f b6 05 8c f4 10 00 	movzbl 0x10f48c,%eax
  1019a1:	24 e0                	and    $0xe0,%al
  1019a3:	a2 8c f4 10 00       	mov    %al,0x10f48c
  1019a8:	0f b6 05 8c f4 10 00 	movzbl 0x10f48c,%eax
  1019af:	24 1f                	and    $0x1f,%al
  1019b1:	a2 8c f4 10 00       	mov    %al,0x10f48c
  1019b6:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  1019bd:	24 f0                	and    $0xf0,%al
  1019bf:	0c 0e                	or     $0xe,%al
  1019c1:	a2 8d f4 10 00       	mov    %al,0x10f48d
  1019c6:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  1019cd:	24 ef                	and    $0xef,%al
  1019cf:	a2 8d f4 10 00       	mov    %al,0x10f48d
  1019d4:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  1019db:	0c 60                	or     $0x60,%al
  1019dd:	a2 8d f4 10 00       	mov    %al,0x10f48d
  1019e2:	0f b6 05 8d f4 10 00 	movzbl 0x10f48d,%eax
  1019e9:	0c 80                	or     $0x80,%al
  1019eb:	a2 8d f4 10 00       	mov    %al,0x10f48d
  1019f0:	a1 c4 e7 10 00       	mov    0x10e7c4,%eax
  1019f5:	c1 e8 10             	shr    $0x10,%eax
  1019f8:	0f b7 c0             	movzwl %ax,%eax
  1019fb:	66 a3 8e f4 10 00    	mov    %ax,0x10f48e
  101a01:	c7 45 f8 60 e5 10 00 	movl   $0x10e560,-0x8(%ebp)
    asm volatile ("lidt (%0)" :: "r" (pd));
  101a08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a0b:	0f 01 18             	lidtl  (%eax)
    //load the idt;
    lidt(&idt_pd);
}
  101a0e:	90                   	nop
  101a0f:	c9                   	leave  
  101a10:	c3                   	ret    

00101a11 <trapname>:

static const char *
trapname(int trapno) {
  101a11:	55                   	push   %ebp
  101a12:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a14:	8b 45 08             	mov    0x8(%ebp),%eax
  101a17:	83 f8 13             	cmp    $0x13,%eax
  101a1a:	77 0c                	ja     101a28 <trapname+0x17>
        return excnames[trapno];
  101a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  101a1f:	8b 04 85 40 3d 10 00 	mov    0x103d40(,%eax,4),%eax
  101a26:	eb 18                	jmp    101a40 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101a28:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101a2c:	7e 0d                	jle    101a3b <trapname+0x2a>
  101a2e:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101a32:	7f 07                	jg     101a3b <trapname+0x2a>
        return "Hardware Interrupt";
  101a34:	b8 ff 39 10 00       	mov    $0x1039ff,%eax
  101a39:	eb 05                	jmp    101a40 <trapname+0x2f>
    }
    return "(unknown trap)";
  101a3b:	b8 12 3a 10 00       	mov    $0x103a12,%eax
}
  101a40:	5d                   	pop    %ebp
  101a41:	c3                   	ret    

00101a42 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101a42:	55                   	push   %ebp
  101a43:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101a45:	8b 45 08             	mov    0x8(%ebp),%eax
  101a48:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101a4c:	83 f8 08             	cmp    $0x8,%eax
  101a4f:	0f 94 c0             	sete   %al
  101a52:	0f b6 c0             	movzbl %al,%eax
}
  101a55:	5d                   	pop    %ebp
  101a56:	c3                   	ret    

00101a57 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101a57:	55                   	push   %ebp
  101a58:	89 e5                	mov    %esp,%ebp
  101a5a:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101a5d:	8b 45 08             	mov    0x8(%ebp),%eax
  101a60:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a64:	c7 04 24 53 3a 10 00 	movl   $0x103a53,(%esp)
  101a6b:	e8 fc e7 ff ff       	call   10026c <cprintf>
    print_regs(&tf->tf_regs);
  101a70:	8b 45 08             	mov    0x8(%ebp),%eax
  101a73:	89 04 24             	mov    %eax,(%esp)
  101a76:	e8 8f 01 00 00       	call   101c0a <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  101a7e:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101a82:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a86:	c7 04 24 64 3a 10 00 	movl   $0x103a64,(%esp)
  101a8d:	e8 da e7 ff ff       	call   10026c <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101a92:	8b 45 08             	mov    0x8(%ebp),%eax
  101a95:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101a99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101a9d:	c7 04 24 77 3a 10 00 	movl   $0x103a77,(%esp)
  101aa4:	e8 c3 e7 ff ff       	call   10026c <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  101aac:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101ab0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ab4:	c7 04 24 8a 3a 10 00 	movl   $0x103a8a,(%esp)
  101abb:	e8 ac e7 ff ff       	call   10026c <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  101ac3:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101ac7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101acb:	c7 04 24 9d 3a 10 00 	movl   $0x103a9d,(%esp)
  101ad2:	e8 95 e7 ff ff       	call   10026c <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  101ada:	8b 40 30             	mov    0x30(%eax),%eax
  101add:	89 04 24             	mov    %eax,(%esp)
  101ae0:	e8 2c ff ff ff       	call   101a11 <trapname>
  101ae5:	89 c2                	mov    %eax,%edx
  101ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  101aea:	8b 40 30             	mov    0x30(%eax),%eax
  101aed:	89 54 24 08          	mov    %edx,0x8(%esp)
  101af1:	89 44 24 04          	mov    %eax,0x4(%esp)
  101af5:	c7 04 24 b0 3a 10 00 	movl   $0x103ab0,(%esp)
  101afc:	e8 6b e7 ff ff       	call   10026c <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b01:	8b 45 08             	mov    0x8(%ebp),%eax
  101b04:	8b 40 34             	mov    0x34(%eax),%eax
  101b07:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0b:	c7 04 24 c2 3a 10 00 	movl   $0x103ac2,(%esp)
  101b12:	e8 55 e7 ff ff       	call   10026c <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101b17:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1a:	8b 40 38             	mov    0x38(%eax),%eax
  101b1d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b21:	c7 04 24 d1 3a 10 00 	movl   $0x103ad1,(%esp)
  101b28:	e8 3f e7 ff ff       	call   10026c <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  101b30:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101b34:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b38:	c7 04 24 e0 3a 10 00 	movl   $0x103ae0,(%esp)
  101b3f:	e8 28 e7 ff ff       	call   10026c <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101b44:	8b 45 08             	mov    0x8(%ebp),%eax
  101b47:	8b 40 40             	mov    0x40(%eax),%eax
  101b4a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b4e:	c7 04 24 f3 3a 10 00 	movl   $0x103af3,(%esp)
  101b55:	e8 12 e7 ff ff       	call   10026c <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101b5a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101b61:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101b68:	eb 3d                	jmp    101ba7 <print_trapframe+0x150>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6d:	8b 50 40             	mov    0x40(%eax),%edx
  101b70:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101b73:	21 d0                	and    %edx,%eax
  101b75:	85 c0                	test   %eax,%eax
  101b77:	74 28                	je     101ba1 <print_trapframe+0x14a>
  101b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b7c:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b83:	85 c0                	test   %eax,%eax
  101b85:	74 1a                	je     101ba1 <print_trapframe+0x14a>
            cprintf("%s,", IA32flags[i]);
  101b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101b8a:	8b 04 85 80 e5 10 00 	mov    0x10e580(,%eax,4),%eax
  101b91:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b95:	c7 04 24 02 3b 10 00 	movl   $0x103b02,(%esp)
  101b9c:	e8 cb e6 ff ff       	call   10026c <cprintf>
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101ba1:	ff 45 f4             	incl   -0xc(%ebp)
  101ba4:	d1 65 f0             	shll   -0x10(%ebp)
  101ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101baa:	83 f8 17             	cmp    $0x17,%eax
  101bad:	76 bb                	jbe    101b6a <print_trapframe+0x113>
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101baf:	8b 45 08             	mov    0x8(%ebp),%eax
  101bb2:	8b 40 40             	mov    0x40(%eax),%eax
  101bb5:	c1 e8 0c             	shr    $0xc,%eax
  101bb8:	83 e0 03             	and    $0x3,%eax
  101bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bbf:	c7 04 24 06 3b 10 00 	movl   $0x103b06,(%esp)
  101bc6:	e8 a1 e6 ff ff       	call   10026c <cprintf>

    if (!trap_in_kernel(tf)) {
  101bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  101bce:	89 04 24             	mov    %eax,(%esp)
  101bd1:	e8 6c fe ff ff       	call   101a42 <trap_in_kernel>
  101bd6:	85 c0                	test   %eax,%eax
  101bd8:	75 2d                	jne    101c07 <print_trapframe+0x1b0>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101bda:	8b 45 08             	mov    0x8(%ebp),%eax
  101bdd:	8b 40 44             	mov    0x44(%eax),%eax
  101be0:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be4:	c7 04 24 0f 3b 10 00 	movl   $0x103b0f,(%esp)
  101beb:	e8 7c e6 ff ff       	call   10026c <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  101bf3:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101bf7:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bfb:	c7 04 24 1e 3b 10 00 	movl   $0x103b1e,(%esp)
  101c02:	e8 65 e6 ff ff       	call   10026c <cprintf>
    }
}
  101c07:	90                   	nop
  101c08:	c9                   	leave  
  101c09:	c3                   	ret    

00101c0a <print_regs>:

void
print_regs(struct pushregs *regs) {
  101c0a:	55                   	push   %ebp
  101c0b:	89 e5                	mov    %esp,%ebp
  101c0d:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101c10:	8b 45 08             	mov    0x8(%ebp),%eax
  101c13:	8b 00                	mov    (%eax),%eax
  101c15:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c19:	c7 04 24 31 3b 10 00 	movl   $0x103b31,(%esp)
  101c20:	e8 47 e6 ff ff       	call   10026c <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101c25:	8b 45 08             	mov    0x8(%ebp),%eax
  101c28:	8b 40 04             	mov    0x4(%eax),%eax
  101c2b:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c2f:	c7 04 24 40 3b 10 00 	movl   $0x103b40,(%esp)
  101c36:	e8 31 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  101c3e:	8b 40 08             	mov    0x8(%eax),%eax
  101c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c45:	c7 04 24 4f 3b 10 00 	movl   $0x103b4f,(%esp)
  101c4c:	e8 1b e6 ff ff       	call   10026c <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101c51:	8b 45 08             	mov    0x8(%ebp),%eax
  101c54:	8b 40 0c             	mov    0xc(%eax),%eax
  101c57:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c5b:	c7 04 24 5e 3b 10 00 	movl   $0x103b5e,(%esp)
  101c62:	e8 05 e6 ff ff       	call   10026c <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101c67:	8b 45 08             	mov    0x8(%ebp),%eax
  101c6a:	8b 40 10             	mov    0x10(%eax),%eax
  101c6d:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c71:	c7 04 24 6d 3b 10 00 	movl   $0x103b6d,(%esp)
  101c78:	e8 ef e5 ff ff       	call   10026c <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  101c80:	8b 40 14             	mov    0x14(%eax),%eax
  101c83:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c87:	c7 04 24 7c 3b 10 00 	movl   $0x103b7c,(%esp)
  101c8e:	e8 d9 e5 ff ff       	call   10026c <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101c93:	8b 45 08             	mov    0x8(%ebp),%eax
  101c96:	8b 40 18             	mov    0x18(%eax),%eax
  101c99:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c9d:	c7 04 24 8b 3b 10 00 	movl   $0x103b8b,(%esp)
  101ca4:	e8 c3 e5 ff ff       	call   10026c <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  101cac:	8b 40 1c             	mov    0x1c(%eax),%eax
  101caf:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb3:	c7 04 24 9a 3b 10 00 	movl   $0x103b9a,(%esp)
  101cba:	e8 ad e5 ff ff       	call   10026c <cprintf>
}
  101cbf:	90                   	nop
  101cc0:	c9                   	leave  
  101cc1:	c3                   	ret    

00101cc2 <trap_dispatch>:

struct trapframe swithk2u;
struct trapframe *switchu2k;
/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101cc2:	55                   	push   %ebp
  101cc3:	89 e5                	mov    %esp,%ebp
  101cc5:	57                   	push   %edi
  101cc6:	56                   	push   %esi
  101cc7:	53                   	push   %ebx
  101cc8:	83 ec 2c             	sub    $0x2c,%esp
    char c;

    switch (tf->tf_trapno) {
  101ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  101cce:	8b 40 30             	mov    0x30(%eax),%eax
  101cd1:	83 f8 2f             	cmp    $0x2f,%eax
  101cd4:	77 1d                	ja     101cf3 <trap_dispatch+0x31>
  101cd6:	83 f8 2e             	cmp    $0x2e,%eax
  101cd9:	0f 83 3e 02 00 00    	jae    101f1d <trap_dispatch+0x25b>
  101cdf:	83 f8 21             	cmp    $0x21,%eax
  101ce2:	74 78                	je     101d5c <trap_dispatch+0x9a>
  101ce4:	83 f8 24             	cmp    $0x24,%eax
  101ce7:	74 4a                	je     101d33 <trap_dispatch+0x71>
  101ce9:	83 f8 20             	cmp    $0x20,%eax
  101cec:	74 1c                	je     101d0a <trap_dispatch+0x48>
  101cee:	e9 f5 01 00 00       	jmp    101ee8 <trap_dispatch+0x226>
  101cf3:	83 f8 78             	cmp    $0x78,%eax
  101cf6:	0f 84 89 00 00 00    	je     101d85 <trap_dispatch+0xc3>
  101cfc:	83 f8 79             	cmp    $0x79,%eax
  101cff:	0f 84 64 01 00 00    	je     101e69 <trap_dispatch+0x1a7>
  101d05:	e9 de 01 00 00       	jmp    101ee8 <trap_dispatch+0x226>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        if(count == 100) {
  101d0a:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  101d0f:	83 f8 64             	cmp    $0x64,%eax
  101d12:	75 0f                	jne    101d23 <trap_dispatch+0x61>
            print_ticks();
  101d14:	e8 c7 fa ff ff       	call   1017e0 <print_ticks>
            count = 0;
  101d19:	c7 05 a0 f0 10 00 00 	movl   $0x0,0x10f0a0
  101d20:	00 00 00 
        }
        ++count;
  101d23:	a1 a0 f0 10 00       	mov    0x10f0a0,%eax
  101d28:	40                   	inc    %eax
  101d29:	a3 a0 f0 10 00       	mov    %eax,0x10f0a0
        break;
  101d2e:	e9 ee 01 00 00       	jmp    101f21 <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101d33:	e8 78 f8 ff ff       	call   1015b0 <cons_getc>
  101d38:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101d3b:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d3f:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d43:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d47:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4b:	c7 04 24 a9 3b 10 00 	movl   $0x103ba9,(%esp)
  101d52:	e8 15 e5 ff ff       	call   10026c <cprintf>
        break;
  101d57:	e9 c5 01 00 00       	jmp    101f21 <trap_dispatch+0x25f>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101d5c:	e8 4f f8 ff ff       	call   1015b0 <cons_getc>
  101d61:	88 45 e7             	mov    %al,-0x19(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101d64:	0f be 55 e7          	movsbl -0x19(%ebp),%edx
  101d68:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  101d6c:	89 54 24 08          	mov    %edx,0x8(%esp)
  101d70:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d74:	c7 04 24 bb 3b 10 00 	movl   $0x103bbb,(%esp)
  101d7b:	e8 ec e4 ff ff       	call   10026c <cprintf>
        break;
  101d80:	e9 9c 01 00 00       	jmp    101f21 <trap_dispatch+0x25f>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
        if(tf->tf_cs != USER_CS) {
  101d85:	8b 45 08             	mov    0x8(%ebp),%eax
  101d88:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101d8c:	83 f8 1b             	cmp    $0x1b,%eax
  101d8f:	0f 84 d4 00 00 00    	je     101e69 <trap_dispatch+0x1a7>
            swithk2u = *tf;
  101d95:	8b 55 08             	mov    0x8(%ebp),%edx
  101d98:	b8 40 f9 10 00       	mov    $0x10f940,%eax
  101d9d:	bb 4c 00 00 00       	mov    $0x4c,%ebx
  101da2:	89 c1                	mov    %eax,%ecx
  101da4:	83 e1 01             	and    $0x1,%ecx
  101da7:	85 c9                	test   %ecx,%ecx
  101da9:	74 0c                	je     101db7 <trap_dispatch+0xf5>
  101dab:	0f b6 0a             	movzbl (%edx),%ecx
  101dae:	88 08                	mov    %cl,(%eax)
  101db0:	8d 40 01             	lea    0x1(%eax),%eax
  101db3:	8d 52 01             	lea    0x1(%edx),%edx
  101db6:	4b                   	dec    %ebx
  101db7:	89 c1                	mov    %eax,%ecx
  101db9:	83 e1 02             	and    $0x2,%ecx
  101dbc:	85 c9                	test   %ecx,%ecx
  101dbe:	74 0f                	je     101dcf <trap_dispatch+0x10d>
  101dc0:	0f b7 0a             	movzwl (%edx),%ecx
  101dc3:	66 89 08             	mov    %cx,(%eax)
  101dc6:	8d 40 02             	lea    0x2(%eax),%eax
  101dc9:	8d 52 02             	lea    0x2(%edx),%edx
  101dcc:	83 eb 02             	sub    $0x2,%ebx
  101dcf:	89 df                	mov    %ebx,%edi
  101dd1:	83 e7 fc             	and    $0xfffffffc,%edi
  101dd4:	b9 00 00 00 00       	mov    $0x0,%ecx
  101dd9:	8b 34 0a             	mov    (%edx,%ecx,1),%esi
  101ddc:	89 34 08             	mov    %esi,(%eax,%ecx,1)
  101ddf:	83 c1 04             	add    $0x4,%ecx
  101de2:	39 f9                	cmp    %edi,%ecx
  101de4:	72 f3                	jb     101dd9 <trap_dispatch+0x117>
  101de6:	01 c8                	add    %ecx,%eax
  101de8:	01 ca                	add    %ecx,%edx
  101dea:	b9 00 00 00 00       	mov    $0x0,%ecx
  101def:	89 de                	mov    %ebx,%esi
  101df1:	83 e6 02             	and    $0x2,%esi
  101df4:	85 f6                	test   %esi,%esi
  101df6:	74 0b                	je     101e03 <trap_dispatch+0x141>
  101df8:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
  101dfc:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
  101e00:	83 c1 02             	add    $0x2,%ecx
  101e03:	83 e3 01             	and    $0x1,%ebx
  101e06:	85 db                	test   %ebx,%ebx
  101e08:	74 07                	je     101e11 <trap_dispatch+0x14f>
  101e0a:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
  101e0e:	88 14 08             	mov    %dl,(%eax,%ecx,1)
            swithk2u.tf_cs = USER_CS;
  101e11:	66 c7 05 7c f9 10 00 	movw   $0x1b,0x10f97c
  101e18:	1b 00 
            swithk2u.tf_ds = swithk2u.tf_es = swithk2u.tf_ss = USER_DS;
  101e1a:	66 c7 05 88 f9 10 00 	movw   $0x23,0x10f988
  101e21:	23 00 
  101e23:	0f b7 05 88 f9 10 00 	movzwl 0x10f988,%eax
  101e2a:	66 a3 68 f9 10 00    	mov    %ax,0x10f968
  101e30:	0f b7 05 68 f9 10 00 	movzwl 0x10f968,%eax
  101e37:	66 a3 6c f9 10 00    	mov    %ax,0x10f96c
            swithk2u.tf_esp = (uint32_t)tf + sizeof(struct trapframe) - 8; //the tf stored those register's value,
  101e3d:	8b 45 08             	mov    0x8(%ebp),%eax
  101e40:	83 c0 44             	add    $0x44,%eax
  101e43:	a3 84 f9 10 00       	mov    %eax,0x10f984
                                                                            // so we skip them,use the space behind them

            //set the eflag to ensure the user mode can call the cprintf
            swithk2u.tf_eflags |= FL_IOPL_MASK;
  101e48:	a1 80 f9 10 00       	mov    0x10f980,%eax
  101e4d:	0d 00 30 00 00       	or     $0x3000,%eax
  101e52:	a3 80 f9 10 00       	mov    %eax,0x10f980

            //set the frame we create to change to user mode
            *((uint32_t *)tf - 1) = (uint32_t)&swithk2u;
  101e57:	8b 45 08             	mov    0x8(%ebp),%eax
  101e5a:	83 e8 04             	sub    $0x4,%eax
  101e5d:	ba 40 f9 10 00       	mov    $0x10f940,%edx
  101e62:	89 10                	mov    %edx,(%eax)
            break;
  101e64:	e9 b8 00 00 00       	jmp    101f21 <trap_dispatch+0x25f>
        }
    case T_SWITCH_TOK:
        if(tf->tf_cs != KERNEL_CS) {
  101e69:	8b 45 08             	mov    0x8(%ebp),%eax
  101e6c:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e70:	83 f8 08             	cmp    $0x8,%eax
  101e73:	0f 84 a7 00 00 00    	je     101f20 <trap_dispatch+0x25e>
            tf->tf_cs = KERNEL_CS;
  101e79:	8b 45 08             	mov    0x8(%ebp),%eax
  101e7c:	66 c7 40 3c 08 00    	movw   $0x8,0x3c(%eax)
            tf->tf_ds = tf->tf_es = KERNEL_DS;
  101e82:	8b 45 08             	mov    0x8(%ebp),%eax
  101e85:	66 c7 40 28 10 00    	movw   $0x10,0x28(%eax)
  101e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  101e8e:	0f b7 50 28          	movzwl 0x28(%eax),%edx
  101e92:	8b 45 08             	mov    0x8(%ebp),%eax
  101e95:	66 89 50 2c          	mov    %dx,0x2c(%eax)
            tf->tf_eflags &= ~FL_IOPL_MASK;
  101e99:	8b 45 08             	mov    0x8(%ebp),%eax
  101e9c:	8b 40 40             	mov    0x40(%eax),%eax
  101e9f:	25 ff cf ff ff       	and    $0xffffcfff,%eax
  101ea4:	89 c2                	mov    %eax,%edx
  101ea6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ea9:	89 50 40             	mov    %edx,0x40(%eax)
            switchu2k = (struct trapframe *)((uint32_t *)tf->tf_esp - (sizeof(struct trapframe) - 8));
  101eac:	8b 45 08             	mov    0x8(%ebp),%eax
  101eaf:	8b 40 44             	mov    0x44(%eax),%eax
  101eb2:	2d 10 01 00 00       	sub    $0x110,%eax
  101eb7:	a3 8c f9 10 00       	mov    %eax,0x10f98c

            memmove(switchu2k, tf, sizeof(struct trapframe) - 8);
  101ebc:	a1 8c f9 10 00       	mov    0x10f98c,%eax
  101ec1:	c7 44 24 08 44 00 00 	movl   $0x44,0x8(%esp)
  101ec8:	00 
  101ec9:	8b 55 08             	mov    0x8(%ebp),%edx
  101ecc:	89 54 24 04          	mov    %edx,0x4(%esp)
  101ed0:	89 04 24             	mov    %eax,(%esp)
  101ed3:	e8 94 0f 00 00       	call   102e6c <memmove>
            *((uint32_t *)tf - 1) = (uint32_t)switchu2k;
  101ed8:	8b 15 8c f9 10 00    	mov    0x10f98c,%edx
  101ede:	8b 45 08             	mov    0x8(%ebp),%eax
  101ee1:	83 e8 04             	sub    $0x4,%eax
  101ee4:	89 10                	mov    %edx,(%eax)
        }
        break;
  101ee6:	eb 38                	jmp    101f20 <trap_dispatch+0x25e>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  101eeb:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101eef:	83 e0 03             	and    $0x3,%eax
  101ef2:	85 c0                	test   %eax,%eax
  101ef4:	75 2b                	jne    101f21 <trap_dispatch+0x25f>
            print_trapframe(tf);
  101ef6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ef9:	89 04 24             	mov    %eax,(%esp)
  101efc:	e8 56 fb ff ff       	call   101a57 <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101f01:	c7 44 24 08 ca 3b 10 	movl   $0x103bca,0x8(%esp)
  101f08:	00 
  101f09:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  101f10:	00 
  101f11:	c7 04 24 ee 39 10 00 	movl   $0x1039ee,(%esp)
  101f18:	e8 a6 e4 ff ff       	call   1003c3 <__panic>
        break;
  101f1d:	90                   	nop
  101f1e:	eb 01                	jmp    101f21 <trap_dispatch+0x25f>
        break;
  101f20:	90                   	nop
        }
    }
}
  101f21:	90                   	nop
  101f22:	83 c4 2c             	add    $0x2c,%esp
  101f25:	5b                   	pop    %ebx
  101f26:	5e                   	pop    %esi
  101f27:	5f                   	pop    %edi
  101f28:	5d                   	pop    %ebp
  101f29:	c3                   	ret    

00101f2a <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101f2a:	55                   	push   %ebp
  101f2b:	89 e5                	mov    %esp,%ebp
  101f2d:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101f30:	8b 45 08             	mov    0x8(%ebp),%eax
  101f33:	89 04 24             	mov    %eax,(%esp)
  101f36:	e8 87 fd ff ff       	call   101cc2 <trap_dispatch>
}
  101f3b:	90                   	nop
  101f3c:	c9                   	leave  
  101f3d:	c3                   	ret    

00101f3e <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101f3e:	6a 00                	push   $0x0
  pushl $0
  101f40:	6a 00                	push   $0x0
  jmp __alltraps
  101f42:	e9 69 0a 00 00       	jmp    1029b0 <__alltraps>

00101f47 <vector1>:
.globl vector1
vector1:
  pushl $0
  101f47:	6a 00                	push   $0x0
  pushl $1
  101f49:	6a 01                	push   $0x1
  jmp __alltraps
  101f4b:	e9 60 0a 00 00       	jmp    1029b0 <__alltraps>

00101f50 <vector2>:
.globl vector2
vector2:
  pushl $0
  101f50:	6a 00                	push   $0x0
  pushl $2
  101f52:	6a 02                	push   $0x2
  jmp __alltraps
  101f54:	e9 57 0a 00 00       	jmp    1029b0 <__alltraps>

00101f59 <vector3>:
.globl vector3
vector3:
  pushl $0
  101f59:	6a 00                	push   $0x0
  pushl $3
  101f5b:	6a 03                	push   $0x3
  jmp __alltraps
  101f5d:	e9 4e 0a 00 00       	jmp    1029b0 <__alltraps>

00101f62 <vector4>:
.globl vector4
vector4:
  pushl $0
  101f62:	6a 00                	push   $0x0
  pushl $4
  101f64:	6a 04                	push   $0x4
  jmp __alltraps
  101f66:	e9 45 0a 00 00       	jmp    1029b0 <__alltraps>

00101f6b <vector5>:
.globl vector5
vector5:
  pushl $0
  101f6b:	6a 00                	push   $0x0
  pushl $5
  101f6d:	6a 05                	push   $0x5
  jmp __alltraps
  101f6f:	e9 3c 0a 00 00       	jmp    1029b0 <__alltraps>

00101f74 <vector6>:
.globl vector6
vector6:
  pushl $0
  101f74:	6a 00                	push   $0x0
  pushl $6
  101f76:	6a 06                	push   $0x6
  jmp __alltraps
  101f78:	e9 33 0a 00 00       	jmp    1029b0 <__alltraps>

00101f7d <vector7>:
.globl vector7
vector7:
  pushl $0
  101f7d:	6a 00                	push   $0x0
  pushl $7
  101f7f:	6a 07                	push   $0x7
  jmp __alltraps
  101f81:	e9 2a 0a 00 00       	jmp    1029b0 <__alltraps>

00101f86 <vector8>:
.globl vector8
vector8:
  pushl $8
  101f86:	6a 08                	push   $0x8
  jmp __alltraps
  101f88:	e9 23 0a 00 00       	jmp    1029b0 <__alltraps>

00101f8d <vector9>:
.globl vector9
vector9:
  pushl $0
  101f8d:	6a 00                	push   $0x0
  pushl $9
  101f8f:	6a 09                	push   $0x9
  jmp __alltraps
  101f91:	e9 1a 0a 00 00       	jmp    1029b0 <__alltraps>

00101f96 <vector10>:
.globl vector10
vector10:
  pushl $10
  101f96:	6a 0a                	push   $0xa
  jmp __alltraps
  101f98:	e9 13 0a 00 00       	jmp    1029b0 <__alltraps>

00101f9d <vector11>:
.globl vector11
vector11:
  pushl $11
  101f9d:	6a 0b                	push   $0xb
  jmp __alltraps
  101f9f:	e9 0c 0a 00 00       	jmp    1029b0 <__alltraps>

00101fa4 <vector12>:
.globl vector12
vector12:
  pushl $12
  101fa4:	6a 0c                	push   $0xc
  jmp __alltraps
  101fa6:	e9 05 0a 00 00       	jmp    1029b0 <__alltraps>

00101fab <vector13>:
.globl vector13
vector13:
  pushl $13
  101fab:	6a 0d                	push   $0xd
  jmp __alltraps
  101fad:	e9 fe 09 00 00       	jmp    1029b0 <__alltraps>

00101fb2 <vector14>:
.globl vector14
vector14:
  pushl $14
  101fb2:	6a 0e                	push   $0xe
  jmp __alltraps
  101fb4:	e9 f7 09 00 00       	jmp    1029b0 <__alltraps>

00101fb9 <vector15>:
.globl vector15
vector15:
  pushl $0
  101fb9:	6a 00                	push   $0x0
  pushl $15
  101fbb:	6a 0f                	push   $0xf
  jmp __alltraps
  101fbd:	e9 ee 09 00 00       	jmp    1029b0 <__alltraps>

00101fc2 <vector16>:
.globl vector16
vector16:
  pushl $0
  101fc2:	6a 00                	push   $0x0
  pushl $16
  101fc4:	6a 10                	push   $0x10
  jmp __alltraps
  101fc6:	e9 e5 09 00 00       	jmp    1029b0 <__alltraps>

00101fcb <vector17>:
.globl vector17
vector17:
  pushl $17
  101fcb:	6a 11                	push   $0x11
  jmp __alltraps
  101fcd:	e9 de 09 00 00       	jmp    1029b0 <__alltraps>

00101fd2 <vector18>:
.globl vector18
vector18:
  pushl $0
  101fd2:	6a 00                	push   $0x0
  pushl $18
  101fd4:	6a 12                	push   $0x12
  jmp __alltraps
  101fd6:	e9 d5 09 00 00       	jmp    1029b0 <__alltraps>

00101fdb <vector19>:
.globl vector19
vector19:
  pushl $0
  101fdb:	6a 00                	push   $0x0
  pushl $19
  101fdd:	6a 13                	push   $0x13
  jmp __alltraps
  101fdf:	e9 cc 09 00 00       	jmp    1029b0 <__alltraps>

00101fe4 <vector20>:
.globl vector20
vector20:
  pushl $0
  101fe4:	6a 00                	push   $0x0
  pushl $20
  101fe6:	6a 14                	push   $0x14
  jmp __alltraps
  101fe8:	e9 c3 09 00 00       	jmp    1029b0 <__alltraps>

00101fed <vector21>:
.globl vector21
vector21:
  pushl $0
  101fed:	6a 00                	push   $0x0
  pushl $21
  101fef:	6a 15                	push   $0x15
  jmp __alltraps
  101ff1:	e9 ba 09 00 00       	jmp    1029b0 <__alltraps>

00101ff6 <vector22>:
.globl vector22
vector22:
  pushl $0
  101ff6:	6a 00                	push   $0x0
  pushl $22
  101ff8:	6a 16                	push   $0x16
  jmp __alltraps
  101ffa:	e9 b1 09 00 00       	jmp    1029b0 <__alltraps>

00101fff <vector23>:
.globl vector23
vector23:
  pushl $0
  101fff:	6a 00                	push   $0x0
  pushl $23
  102001:	6a 17                	push   $0x17
  jmp __alltraps
  102003:	e9 a8 09 00 00       	jmp    1029b0 <__alltraps>

00102008 <vector24>:
.globl vector24
vector24:
  pushl $0
  102008:	6a 00                	push   $0x0
  pushl $24
  10200a:	6a 18                	push   $0x18
  jmp __alltraps
  10200c:	e9 9f 09 00 00       	jmp    1029b0 <__alltraps>

00102011 <vector25>:
.globl vector25
vector25:
  pushl $0
  102011:	6a 00                	push   $0x0
  pushl $25
  102013:	6a 19                	push   $0x19
  jmp __alltraps
  102015:	e9 96 09 00 00       	jmp    1029b0 <__alltraps>

0010201a <vector26>:
.globl vector26
vector26:
  pushl $0
  10201a:	6a 00                	push   $0x0
  pushl $26
  10201c:	6a 1a                	push   $0x1a
  jmp __alltraps
  10201e:	e9 8d 09 00 00       	jmp    1029b0 <__alltraps>

00102023 <vector27>:
.globl vector27
vector27:
  pushl $0
  102023:	6a 00                	push   $0x0
  pushl $27
  102025:	6a 1b                	push   $0x1b
  jmp __alltraps
  102027:	e9 84 09 00 00       	jmp    1029b0 <__alltraps>

0010202c <vector28>:
.globl vector28
vector28:
  pushl $0
  10202c:	6a 00                	push   $0x0
  pushl $28
  10202e:	6a 1c                	push   $0x1c
  jmp __alltraps
  102030:	e9 7b 09 00 00       	jmp    1029b0 <__alltraps>

00102035 <vector29>:
.globl vector29
vector29:
  pushl $0
  102035:	6a 00                	push   $0x0
  pushl $29
  102037:	6a 1d                	push   $0x1d
  jmp __alltraps
  102039:	e9 72 09 00 00       	jmp    1029b0 <__alltraps>

0010203e <vector30>:
.globl vector30
vector30:
  pushl $0
  10203e:	6a 00                	push   $0x0
  pushl $30
  102040:	6a 1e                	push   $0x1e
  jmp __alltraps
  102042:	e9 69 09 00 00       	jmp    1029b0 <__alltraps>

00102047 <vector31>:
.globl vector31
vector31:
  pushl $0
  102047:	6a 00                	push   $0x0
  pushl $31
  102049:	6a 1f                	push   $0x1f
  jmp __alltraps
  10204b:	e9 60 09 00 00       	jmp    1029b0 <__alltraps>

00102050 <vector32>:
.globl vector32
vector32:
  pushl $0
  102050:	6a 00                	push   $0x0
  pushl $32
  102052:	6a 20                	push   $0x20
  jmp __alltraps
  102054:	e9 57 09 00 00       	jmp    1029b0 <__alltraps>

00102059 <vector33>:
.globl vector33
vector33:
  pushl $0
  102059:	6a 00                	push   $0x0
  pushl $33
  10205b:	6a 21                	push   $0x21
  jmp __alltraps
  10205d:	e9 4e 09 00 00       	jmp    1029b0 <__alltraps>

00102062 <vector34>:
.globl vector34
vector34:
  pushl $0
  102062:	6a 00                	push   $0x0
  pushl $34
  102064:	6a 22                	push   $0x22
  jmp __alltraps
  102066:	e9 45 09 00 00       	jmp    1029b0 <__alltraps>

0010206b <vector35>:
.globl vector35
vector35:
  pushl $0
  10206b:	6a 00                	push   $0x0
  pushl $35
  10206d:	6a 23                	push   $0x23
  jmp __alltraps
  10206f:	e9 3c 09 00 00       	jmp    1029b0 <__alltraps>

00102074 <vector36>:
.globl vector36
vector36:
  pushl $0
  102074:	6a 00                	push   $0x0
  pushl $36
  102076:	6a 24                	push   $0x24
  jmp __alltraps
  102078:	e9 33 09 00 00       	jmp    1029b0 <__alltraps>

0010207d <vector37>:
.globl vector37
vector37:
  pushl $0
  10207d:	6a 00                	push   $0x0
  pushl $37
  10207f:	6a 25                	push   $0x25
  jmp __alltraps
  102081:	e9 2a 09 00 00       	jmp    1029b0 <__alltraps>

00102086 <vector38>:
.globl vector38
vector38:
  pushl $0
  102086:	6a 00                	push   $0x0
  pushl $38
  102088:	6a 26                	push   $0x26
  jmp __alltraps
  10208a:	e9 21 09 00 00       	jmp    1029b0 <__alltraps>

0010208f <vector39>:
.globl vector39
vector39:
  pushl $0
  10208f:	6a 00                	push   $0x0
  pushl $39
  102091:	6a 27                	push   $0x27
  jmp __alltraps
  102093:	e9 18 09 00 00       	jmp    1029b0 <__alltraps>

00102098 <vector40>:
.globl vector40
vector40:
  pushl $0
  102098:	6a 00                	push   $0x0
  pushl $40
  10209a:	6a 28                	push   $0x28
  jmp __alltraps
  10209c:	e9 0f 09 00 00       	jmp    1029b0 <__alltraps>

001020a1 <vector41>:
.globl vector41
vector41:
  pushl $0
  1020a1:	6a 00                	push   $0x0
  pushl $41
  1020a3:	6a 29                	push   $0x29
  jmp __alltraps
  1020a5:	e9 06 09 00 00       	jmp    1029b0 <__alltraps>

001020aa <vector42>:
.globl vector42
vector42:
  pushl $0
  1020aa:	6a 00                	push   $0x0
  pushl $42
  1020ac:	6a 2a                	push   $0x2a
  jmp __alltraps
  1020ae:	e9 fd 08 00 00       	jmp    1029b0 <__alltraps>

001020b3 <vector43>:
.globl vector43
vector43:
  pushl $0
  1020b3:	6a 00                	push   $0x0
  pushl $43
  1020b5:	6a 2b                	push   $0x2b
  jmp __alltraps
  1020b7:	e9 f4 08 00 00       	jmp    1029b0 <__alltraps>

001020bc <vector44>:
.globl vector44
vector44:
  pushl $0
  1020bc:	6a 00                	push   $0x0
  pushl $44
  1020be:	6a 2c                	push   $0x2c
  jmp __alltraps
  1020c0:	e9 eb 08 00 00       	jmp    1029b0 <__alltraps>

001020c5 <vector45>:
.globl vector45
vector45:
  pushl $0
  1020c5:	6a 00                	push   $0x0
  pushl $45
  1020c7:	6a 2d                	push   $0x2d
  jmp __alltraps
  1020c9:	e9 e2 08 00 00       	jmp    1029b0 <__alltraps>

001020ce <vector46>:
.globl vector46
vector46:
  pushl $0
  1020ce:	6a 00                	push   $0x0
  pushl $46
  1020d0:	6a 2e                	push   $0x2e
  jmp __alltraps
  1020d2:	e9 d9 08 00 00       	jmp    1029b0 <__alltraps>

001020d7 <vector47>:
.globl vector47
vector47:
  pushl $0
  1020d7:	6a 00                	push   $0x0
  pushl $47
  1020d9:	6a 2f                	push   $0x2f
  jmp __alltraps
  1020db:	e9 d0 08 00 00       	jmp    1029b0 <__alltraps>

001020e0 <vector48>:
.globl vector48
vector48:
  pushl $0
  1020e0:	6a 00                	push   $0x0
  pushl $48
  1020e2:	6a 30                	push   $0x30
  jmp __alltraps
  1020e4:	e9 c7 08 00 00       	jmp    1029b0 <__alltraps>

001020e9 <vector49>:
.globl vector49
vector49:
  pushl $0
  1020e9:	6a 00                	push   $0x0
  pushl $49
  1020eb:	6a 31                	push   $0x31
  jmp __alltraps
  1020ed:	e9 be 08 00 00       	jmp    1029b0 <__alltraps>

001020f2 <vector50>:
.globl vector50
vector50:
  pushl $0
  1020f2:	6a 00                	push   $0x0
  pushl $50
  1020f4:	6a 32                	push   $0x32
  jmp __alltraps
  1020f6:	e9 b5 08 00 00       	jmp    1029b0 <__alltraps>

001020fb <vector51>:
.globl vector51
vector51:
  pushl $0
  1020fb:	6a 00                	push   $0x0
  pushl $51
  1020fd:	6a 33                	push   $0x33
  jmp __alltraps
  1020ff:	e9 ac 08 00 00       	jmp    1029b0 <__alltraps>

00102104 <vector52>:
.globl vector52
vector52:
  pushl $0
  102104:	6a 00                	push   $0x0
  pushl $52
  102106:	6a 34                	push   $0x34
  jmp __alltraps
  102108:	e9 a3 08 00 00       	jmp    1029b0 <__alltraps>

0010210d <vector53>:
.globl vector53
vector53:
  pushl $0
  10210d:	6a 00                	push   $0x0
  pushl $53
  10210f:	6a 35                	push   $0x35
  jmp __alltraps
  102111:	e9 9a 08 00 00       	jmp    1029b0 <__alltraps>

00102116 <vector54>:
.globl vector54
vector54:
  pushl $0
  102116:	6a 00                	push   $0x0
  pushl $54
  102118:	6a 36                	push   $0x36
  jmp __alltraps
  10211a:	e9 91 08 00 00       	jmp    1029b0 <__alltraps>

0010211f <vector55>:
.globl vector55
vector55:
  pushl $0
  10211f:	6a 00                	push   $0x0
  pushl $55
  102121:	6a 37                	push   $0x37
  jmp __alltraps
  102123:	e9 88 08 00 00       	jmp    1029b0 <__alltraps>

00102128 <vector56>:
.globl vector56
vector56:
  pushl $0
  102128:	6a 00                	push   $0x0
  pushl $56
  10212a:	6a 38                	push   $0x38
  jmp __alltraps
  10212c:	e9 7f 08 00 00       	jmp    1029b0 <__alltraps>

00102131 <vector57>:
.globl vector57
vector57:
  pushl $0
  102131:	6a 00                	push   $0x0
  pushl $57
  102133:	6a 39                	push   $0x39
  jmp __alltraps
  102135:	e9 76 08 00 00       	jmp    1029b0 <__alltraps>

0010213a <vector58>:
.globl vector58
vector58:
  pushl $0
  10213a:	6a 00                	push   $0x0
  pushl $58
  10213c:	6a 3a                	push   $0x3a
  jmp __alltraps
  10213e:	e9 6d 08 00 00       	jmp    1029b0 <__alltraps>

00102143 <vector59>:
.globl vector59
vector59:
  pushl $0
  102143:	6a 00                	push   $0x0
  pushl $59
  102145:	6a 3b                	push   $0x3b
  jmp __alltraps
  102147:	e9 64 08 00 00       	jmp    1029b0 <__alltraps>

0010214c <vector60>:
.globl vector60
vector60:
  pushl $0
  10214c:	6a 00                	push   $0x0
  pushl $60
  10214e:	6a 3c                	push   $0x3c
  jmp __alltraps
  102150:	e9 5b 08 00 00       	jmp    1029b0 <__alltraps>

00102155 <vector61>:
.globl vector61
vector61:
  pushl $0
  102155:	6a 00                	push   $0x0
  pushl $61
  102157:	6a 3d                	push   $0x3d
  jmp __alltraps
  102159:	e9 52 08 00 00       	jmp    1029b0 <__alltraps>

0010215e <vector62>:
.globl vector62
vector62:
  pushl $0
  10215e:	6a 00                	push   $0x0
  pushl $62
  102160:	6a 3e                	push   $0x3e
  jmp __alltraps
  102162:	e9 49 08 00 00       	jmp    1029b0 <__alltraps>

00102167 <vector63>:
.globl vector63
vector63:
  pushl $0
  102167:	6a 00                	push   $0x0
  pushl $63
  102169:	6a 3f                	push   $0x3f
  jmp __alltraps
  10216b:	e9 40 08 00 00       	jmp    1029b0 <__alltraps>

00102170 <vector64>:
.globl vector64
vector64:
  pushl $0
  102170:	6a 00                	push   $0x0
  pushl $64
  102172:	6a 40                	push   $0x40
  jmp __alltraps
  102174:	e9 37 08 00 00       	jmp    1029b0 <__alltraps>

00102179 <vector65>:
.globl vector65
vector65:
  pushl $0
  102179:	6a 00                	push   $0x0
  pushl $65
  10217b:	6a 41                	push   $0x41
  jmp __alltraps
  10217d:	e9 2e 08 00 00       	jmp    1029b0 <__alltraps>

00102182 <vector66>:
.globl vector66
vector66:
  pushl $0
  102182:	6a 00                	push   $0x0
  pushl $66
  102184:	6a 42                	push   $0x42
  jmp __alltraps
  102186:	e9 25 08 00 00       	jmp    1029b0 <__alltraps>

0010218b <vector67>:
.globl vector67
vector67:
  pushl $0
  10218b:	6a 00                	push   $0x0
  pushl $67
  10218d:	6a 43                	push   $0x43
  jmp __alltraps
  10218f:	e9 1c 08 00 00       	jmp    1029b0 <__alltraps>

00102194 <vector68>:
.globl vector68
vector68:
  pushl $0
  102194:	6a 00                	push   $0x0
  pushl $68
  102196:	6a 44                	push   $0x44
  jmp __alltraps
  102198:	e9 13 08 00 00       	jmp    1029b0 <__alltraps>

0010219d <vector69>:
.globl vector69
vector69:
  pushl $0
  10219d:	6a 00                	push   $0x0
  pushl $69
  10219f:	6a 45                	push   $0x45
  jmp __alltraps
  1021a1:	e9 0a 08 00 00       	jmp    1029b0 <__alltraps>

001021a6 <vector70>:
.globl vector70
vector70:
  pushl $0
  1021a6:	6a 00                	push   $0x0
  pushl $70
  1021a8:	6a 46                	push   $0x46
  jmp __alltraps
  1021aa:	e9 01 08 00 00       	jmp    1029b0 <__alltraps>

001021af <vector71>:
.globl vector71
vector71:
  pushl $0
  1021af:	6a 00                	push   $0x0
  pushl $71
  1021b1:	6a 47                	push   $0x47
  jmp __alltraps
  1021b3:	e9 f8 07 00 00       	jmp    1029b0 <__alltraps>

001021b8 <vector72>:
.globl vector72
vector72:
  pushl $0
  1021b8:	6a 00                	push   $0x0
  pushl $72
  1021ba:	6a 48                	push   $0x48
  jmp __alltraps
  1021bc:	e9 ef 07 00 00       	jmp    1029b0 <__alltraps>

001021c1 <vector73>:
.globl vector73
vector73:
  pushl $0
  1021c1:	6a 00                	push   $0x0
  pushl $73
  1021c3:	6a 49                	push   $0x49
  jmp __alltraps
  1021c5:	e9 e6 07 00 00       	jmp    1029b0 <__alltraps>

001021ca <vector74>:
.globl vector74
vector74:
  pushl $0
  1021ca:	6a 00                	push   $0x0
  pushl $74
  1021cc:	6a 4a                	push   $0x4a
  jmp __alltraps
  1021ce:	e9 dd 07 00 00       	jmp    1029b0 <__alltraps>

001021d3 <vector75>:
.globl vector75
vector75:
  pushl $0
  1021d3:	6a 00                	push   $0x0
  pushl $75
  1021d5:	6a 4b                	push   $0x4b
  jmp __alltraps
  1021d7:	e9 d4 07 00 00       	jmp    1029b0 <__alltraps>

001021dc <vector76>:
.globl vector76
vector76:
  pushl $0
  1021dc:	6a 00                	push   $0x0
  pushl $76
  1021de:	6a 4c                	push   $0x4c
  jmp __alltraps
  1021e0:	e9 cb 07 00 00       	jmp    1029b0 <__alltraps>

001021e5 <vector77>:
.globl vector77
vector77:
  pushl $0
  1021e5:	6a 00                	push   $0x0
  pushl $77
  1021e7:	6a 4d                	push   $0x4d
  jmp __alltraps
  1021e9:	e9 c2 07 00 00       	jmp    1029b0 <__alltraps>

001021ee <vector78>:
.globl vector78
vector78:
  pushl $0
  1021ee:	6a 00                	push   $0x0
  pushl $78
  1021f0:	6a 4e                	push   $0x4e
  jmp __alltraps
  1021f2:	e9 b9 07 00 00       	jmp    1029b0 <__alltraps>

001021f7 <vector79>:
.globl vector79
vector79:
  pushl $0
  1021f7:	6a 00                	push   $0x0
  pushl $79
  1021f9:	6a 4f                	push   $0x4f
  jmp __alltraps
  1021fb:	e9 b0 07 00 00       	jmp    1029b0 <__alltraps>

00102200 <vector80>:
.globl vector80
vector80:
  pushl $0
  102200:	6a 00                	push   $0x0
  pushl $80
  102202:	6a 50                	push   $0x50
  jmp __alltraps
  102204:	e9 a7 07 00 00       	jmp    1029b0 <__alltraps>

00102209 <vector81>:
.globl vector81
vector81:
  pushl $0
  102209:	6a 00                	push   $0x0
  pushl $81
  10220b:	6a 51                	push   $0x51
  jmp __alltraps
  10220d:	e9 9e 07 00 00       	jmp    1029b0 <__alltraps>

00102212 <vector82>:
.globl vector82
vector82:
  pushl $0
  102212:	6a 00                	push   $0x0
  pushl $82
  102214:	6a 52                	push   $0x52
  jmp __alltraps
  102216:	e9 95 07 00 00       	jmp    1029b0 <__alltraps>

0010221b <vector83>:
.globl vector83
vector83:
  pushl $0
  10221b:	6a 00                	push   $0x0
  pushl $83
  10221d:	6a 53                	push   $0x53
  jmp __alltraps
  10221f:	e9 8c 07 00 00       	jmp    1029b0 <__alltraps>

00102224 <vector84>:
.globl vector84
vector84:
  pushl $0
  102224:	6a 00                	push   $0x0
  pushl $84
  102226:	6a 54                	push   $0x54
  jmp __alltraps
  102228:	e9 83 07 00 00       	jmp    1029b0 <__alltraps>

0010222d <vector85>:
.globl vector85
vector85:
  pushl $0
  10222d:	6a 00                	push   $0x0
  pushl $85
  10222f:	6a 55                	push   $0x55
  jmp __alltraps
  102231:	e9 7a 07 00 00       	jmp    1029b0 <__alltraps>

00102236 <vector86>:
.globl vector86
vector86:
  pushl $0
  102236:	6a 00                	push   $0x0
  pushl $86
  102238:	6a 56                	push   $0x56
  jmp __alltraps
  10223a:	e9 71 07 00 00       	jmp    1029b0 <__alltraps>

0010223f <vector87>:
.globl vector87
vector87:
  pushl $0
  10223f:	6a 00                	push   $0x0
  pushl $87
  102241:	6a 57                	push   $0x57
  jmp __alltraps
  102243:	e9 68 07 00 00       	jmp    1029b0 <__alltraps>

00102248 <vector88>:
.globl vector88
vector88:
  pushl $0
  102248:	6a 00                	push   $0x0
  pushl $88
  10224a:	6a 58                	push   $0x58
  jmp __alltraps
  10224c:	e9 5f 07 00 00       	jmp    1029b0 <__alltraps>

00102251 <vector89>:
.globl vector89
vector89:
  pushl $0
  102251:	6a 00                	push   $0x0
  pushl $89
  102253:	6a 59                	push   $0x59
  jmp __alltraps
  102255:	e9 56 07 00 00       	jmp    1029b0 <__alltraps>

0010225a <vector90>:
.globl vector90
vector90:
  pushl $0
  10225a:	6a 00                	push   $0x0
  pushl $90
  10225c:	6a 5a                	push   $0x5a
  jmp __alltraps
  10225e:	e9 4d 07 00 00       	jmp    1029b0 <__alltraps>

00102263 <vector91>:
.globl vector91
vector91:
  pushl $0
  102263:	6a 00                	push   $0x0
  pushl $91
  102265:	6a 5b                	push   $0x5b
  jmp __alltraps
  102267:	e9 44 07 00 00       	jmp    1029b0 <__alltraps>

0010226c <vector92>:
.globl vector92
vector92:
  pushl $0
  10226c:	6a 00                	push   $0x0
  pushl $92
  10226e:	6a 5c                	push   $0x5c
  jmp __alltraps
  102270:	e9 3b 07 00 00       	jmp    1029b0 <__alltraps>

00102275 <vector93>:
.globl vector93
vector93:
  pushl $0
  102275:	6a 00                	push   $0x0
  pushl $93
  102277:	6a 5d                	push   $0x5d
  jmp __alltraps
  102279:	e9 32 07 00 00       	jmp    1029b0 <__alltraps>

0010227e <vector94>:
.globl vector94
vector94:
  pushl $0
  10227e:	6a 00                	push   $0x0
  pushl $94
  102280:	6a 5e                	push   $0x5e
  jmp __alltraps
  102282:	e9 29 07 00 00       	jmp    1029b0 <__alltraps>

00102287 <vector95>:
.globl vector95
vector95:
  pushl $0
  102287:	6a 00                	push   $0x0
  pushl $95
  102289:	6a 5f                	push   $0x5f
  jmp __alltraps
  10228b:	e9 20 07 00 00       	jmp    1029b0 <__alltraps>

00102290 <vector96>:
.globl vector96
vector96:
  pushl $0
  102290:	6a 00                	push   $0x0
  pushl $96
  102292:	6a 60                	push   $0x60
  jmp __alltraps
  102294:	e9 17 07 00 00       	jmp    1029b0 <__alltraps>

00102299 <vector97>:
.globl vector97
vector97:
  pushl $0
  102299:	6a 00                	push   $0x0
  pushl $97
  10229b:	6a 61                	push   $0x61
  jmp __alltraps
  10229d:	e9 0e 07 00 00       	jmp    1029b0 <__alltraps>

001022a2 <vector98>:
.globl vector98
vector98:
  pushl $0
  1022a2:	6a 00                	push   $0x0
  pushl $98
  1022a4:	6a 62                	push   $0x62
  jmp __alltraps
  1022a6:	e9 05 07 00 00       	jmp    1029b0 <__alltraps>

001022ab <vector99>:
.globl vector99
vector99:
  pushl $0
  1022ab:	6a 00                	push   $0x0
  pushl $99
  1022ad:	6a 63                	push   $0x63
  jmp __alltraps
  1022af:	e9 fc 06 00 00       	jmp    1029b0 <__alltraps>

001022b4 <vector100>:
.globl vector100
vector100:
  pushl $0
  1022b4:	6a 00                	push   $0x0
  pushl $100
  1022b6:	6a 64                	push   $0x64
  jmp __alltraps
  1022b8:	e9 f3 06 00 00       	jmp    1029b0 <__alltraps>

001022bd <vector101>:
.globl vector101
vector101:
  pushl $0
  1022bd:	6a 00                	push   $0x0
  pushl $101
  1022bf:	6a 65                	push   $0x65
  jmp __alltraps
  1022c1:	e9 ea 06 00 00       	jmp    1029b0 <__alltraps>

001022c6 <vector102>:
.globl vector102
vector102:
  pushl $0
  1022c6:	6a 00                	push   $0x0
  pushl $102
  1022c8:	6a 66                	push   $0x66
  jmp __alltraps
  1022ca:	e9 e1 06 00 00       	jmp    1029b0 <__alltraps>

001022cf <vector103>:
.globl vector103
vector103:
  pushl $0
  1022cf:	6a 00                	push   $0x0
  pushl $103
  1022d1:	6a 67                	push   $0x67
  jmp __alltraps
  1022d3:	e9 d8 06 00 00       	jmp    1029b0 <__alltraps>

001022d8 <vector104>:
.globl vector104
vector104:
  pushl $0
  1022d8:	6a 00                	push   $0x0
  pushl $104
  1022da:	6a 68                	push   $0x68
  jmp __alltraps
  1022dc:	e9 cf 06 00 00       	jmp    1029b0 <__alltraps>

001022e1 <vector105>:
.globl vector105
vector105:
  pushl $0
  1022e1:	6a 00                	push   $0x0
  pushl $105
  1022e3:	6a 69                	push   $0x69
  jmp __alltraps
  1022e5:	e9 c6 06 00 00       	jmp    1029b0 <__alltraps>

001022ea <vector106>:
.globl vector106
vector106:
  pushl $0
  1022ea:	6a 00                	push   $0x0
  pushl $106
  1022ec:	6a 6a                	push   $0x6a
  jmp __alltraps
  1022ee:	e9 bd 06 00 00       	jmp    1029b0 <__alltraps>

001022f3 <vector107>:
.globl vector107
vector107:
  pushl $0
  1022f3:	6a 00                	push   $0x0
  pushl $107
  1022f5:	6a 6b                	push   $0x6b
  jmp __alltraps
  1022f7:	e9 b4 06 00 00       	jmp    1029b0 <__alltraps>

001022fc <vector108>:
.globl vector108
vector108:
  pushl $0
  1022fc:	6a 00                	push   $0x0
  pushl $108
  1022fe:	6a 6c                	push   $0x6c
  jmp __alltraps
  102300:	e9 ab 06 00 00       	jmp    1029b0 <__alltraps>

00102305 <vector109>:
.globl vector109
vector109:
  pushl $0
  102305:	6a 00                	push   $0x0
  pushl $109
  102307:	6a 6d                	push   $0x6d
  jmp __alltraps
  102309:	e9 a2 06 00 00       	jmp    1029b0 <__alltraps>

0010230e <vector110>:
.globl vector110
vector110:
  pushl $0
  10230e:	6a 00                	push   $0x0
  pushl $110
  102310:	6a 6e                	push   $0x6e
  jmp __alltraps
  102312:	e9 99 06 00 00       	jmp    1029b0 <__alltraps>

00102317 <vector111>:
.globl vector111
vector111:
  pushl $0
  102317:	6a 00                	push   $0x0
  pushl $111
  102319:	6a 6f                	push   $0x6f
  jmp __alltraps
  10231b:	e9 90 06 00 00       	jmp    1029b0 <__alltraps>

00102320 <vector112>:
.globl vector112
vector112:
  pushl $0
  102320:	6a 00                	push   $0x0
  pushl $112
  102322:	6a 70                	push   $0x70
  jmp __alltraps
  102324:	e9 87 06 00 00       	jmp    1029b0 <__alltraps>

00102329 <vector113>:
.globl vector113
vector113:
  pushl $0
  102329:	6a 00                	push   $0x0
  pushl $113
  10232b:	6a 71                	push   $0x71
  jmp __alltraps
  10232d:	e9 7e 06 00 00       	jmp    1029b0 <__alltraps>

00102332 <vector114>:
.globl vector114
vector114:
  pushl $0
  102332:	6a 00                	push   $0x0
  pushl $114
  102334:	6a 72                	push   $0x72
  jmp __alltraps
  102336:	e9 75 06 00 00       	jmp    1029b0 <__alltraps>

0010233b <vector115>:
.globl vector115
vector115:
  pushl $0
  10233b:	6a 00                	push   $0x0
  pushl $115
  10233d:	6a 73                	push   $0x73
  jmp __alltraps
  10233f:	e9 6c 06 00 00       	jmp    1029b0 <__alltraps>

00102344 <vector116>:
.globl vector116
vector116:
  pushl $0
  102344:	6a 00                	push   $0x0
  pushl $116
  102346:	6a 74                	push   $0x74
  jmp __alltraps
  102348:	e9 63 06 00 00       	jmp    1029b0 <__alltraps>

0010234d <vector117>:
.globl vector117
vector117:
  pushl $0
  10234d:	6a 00                	push   $0x0
  pushl $117
  10234f:	6a 75                	push   $0x75
  jmp __alltraps
  102351:	e9 5a 06 00 00       	jmp    1029b0 <__alltraps>

00102356 <vector118>:
.globl vector118
vector118:
  pushl $0
  102356:	6a 00                	push   $0x0
  pushl $118
  102358:	6a 76                	push   $0x76
  jmp __alltraps
  10235a:	e9 51 06 00 00       	jmp    1029b0 <__alltraps>

0010235f <vector119>:
.globl vector119
vector119:
  pushl $0
  10235f:	6a 00                	push   $0x0
  pushl $119
  102361:	6a 77                	push   $0x77
  jmp __alltraps
  102363:	e9 48 06 00 00       	jmp    1029b0 <__alltraps>

00102368 <vector120>:
.globl vector120
vector120:
  pushl $0
  102368:	6a 00                	push   $0x0
  pushl $120
  10236a:	6a 78                	push   $0x78
  jmp __alltraps
  10236c:	e9 3f 06 00 00       	jmp    1029b0 <__alltraps>

00102371 <vector121>:
.globl vector121
vector121:
  pushl $0
  102371:	6a 00                	push   $0x0
  pushl $121
  102373:	6a 79                	push   $0x79
  jmp __alltraps
  102375:	e9 36 06 00 00       	jmp    1029b0 <__alltraps>

0010237a <vector122>:
.globl vector122
vector122:
  pushl $0
  10237a:	6a 00                	push   $0x0
  pushl $122
  10237c:	6a 7a                	push   $0x7a
  jmp __alltraps
  10237e:	e9 2d 06 00 00       	jmp    1029b0 <__alltraps>

00102383 <vector123>:
.globl vector123
vector123:
  pushl $0
  102383:	6a 00                	push   $0x0
  pushl $123
  102385:	6a 7b                	push   $0x7b
  jmp __alltraps
  102387:	e9 24 06 00 00       	jmp    1029b0 <__alltraps>

0010238c <vector124>:
.globl vector124
vector124:
  pushl $0
  10238c:	6a 00                	push   $0x0
  pushl $124
  10238e:	6a 7c                	push   $0x7c
  jmp __alltraps
  102390:	e9 1b 06 00 00       	jmp    1029b0 <__alltraps>

00102395 <vector125>:
.globl vector125
vector125:
  pushl $0
  102395:	6a 00                	push   $0x0
  pushl $125
  102397:	6a 7d                	push   $0x7d
  jmp __alltraps
  102399:	e9 12 06 00 00       	jmp    1029b0 <__alltraps>

0010239e <vector126>:
.globl vector126
vector126:
  pushl $0
  10239e:	6a 00                	push   $0x0
  pushl $126
  1023a0:	6a 7e                	push   $0x7e
  jmp __alltraps
  1023a2:	e9 09 06 00 00       	jmp    1029b0 <__alltraps>

001023a7 <vector127>:
.globl vector127
vector127:
  pushl $0
  1023a7:	6a 00                	push   $0x0
  pushl $127
  1023a9:	6a 7f                	push   $0x7f
  jmp __alltraps
  1023ab:	e9 00 06 00 00       	jmp    1029b0 <__alltraps>

001023b0 <vector128>:
.globl vector128
vector128:
  pushl $0
  1023b0:	6a 00                	push   $0x0
  pushl $128
  1023b2:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  1023b7:	e9 f4 05 00 00       	jmp    1029b0 <__alltraps>

001023bc <vector129>:
.globl vector129
vector129:
  pushl $0
  1023bc:	6a 00                	push   $0x0
  pushl $129
  1023be:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  1023c3:	e9 e8 05 00 00       	jmp    1029b0 <__alltraps>

001023c8 <vector130>:
.globl vector130
vector130:
  pushl $0
  1023c8:	6a 00                	push   $0x0
  pushl $130
  1023ca:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  1023cf:	e9 dc 05 00 00       	jmp    1029b0 <__alltraps>

001023d4 <vector131>:
.globl vector131
vector131:
  pushl $0
  1023d4:	6a 00                	push   $0x0
  pushl $131
  1023d6:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  1023db:	e9 d0 05 00 00       	jmp    1029b0 <__alltraps>

001023e0 <vector132>:
.globl vector132
vector132:
  pushl $0
  1023e0:	6a 00                	push   $0x0
  pushl $132
  1023e2:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  1023e7:	e9 c4 05 00 00       	jmp    1029b0 <__alltraps>

001023ec <vector133>:
.globl vector133
vector133:
  pushl $0
  1023ec:	6a 00                	push   $0x0
  pushl $133
  1023ee:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  1023f3:	e9 b8 05 00 00       	jmp    1029b0 <__alltraps>

001023f8 <vector134>:
.globl vector134
vector134:
  pushl $0
  1023f8:	6a 00                	push   $0x0
  pushl $134
  1023fa:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  1023ff:	e9 ac 05 00 00       	jmp    1029b0 <__alltraps>

00102404 <vector135>:
.globl vector135
vector135:
  pushl $0
  102404:	6a 00                	push   $0x0
  pushl $135
  102406:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10240b:	e9 a0 05 00 00       	jmp    1029b0 <__alltraps>

00102410 <vector136>:
.globl vector136
vector136:
  pushl $0
  102410:	6a 00                	push   $0x0
  pushl $136
  102412:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  102417:	e9 94 05 00 00       	jmp    1029b0 <__alltraps>

0010241c <vector137>:
.globl vector137
vector137:
  pushl $0
  10241c:	6a 00                	push   $0x0
  pushl $137
  10241e:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102423:	e9 88 05 00 00       	jmp    1029b0 <__alltraps>

00102428 <vector138>:
.globl vector138
vector138:
  pushl $0
  102428:	6a 00                	push   $0x0
  pushl $138
  10242a:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  10242f:	e9 7c 05 00 00       	jmp    1029b0 <__alltraps>

00102434 <vector139>:
.globl vector139
vector139:
  pushl $0
  102434:	6a 00                	push   $0x0
  pushl $139
  102436:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  10243b:	e9 70 05 00 00       	jmp    1029b0 <__alltraps>

00102440 <vector140>:
.globl vector140
vector140:
  pushl $0
  102440:	6a 00                	push   $0x0
  pushl $140
  102442:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  102447:	e9 64 05 00 00       	jmp    1029b0 <__alltraps>

0010244c <vector141>:
.globl vector141
vector141:
  pushl $0
  10244c:	6a 00                	push   $0x0
  pushl $141
  10244e:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  102453:	e9 58 05 00 00       	jmp    1029b0 <__alltraps>

00102458 <vector142>:
.globl vector142
vector142:
  pushl $0
  102458:	6a 00                	push   $0x0
  pushl $142
  10245a:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  10245f:	e9 4c 05 00 00       	jmp    1029b0 <__alltraps>

00102464 <vector143>:
.globl vector143
vector143:
  pushl $0
  102464:	6a 00                	push   $0x0
  pushl $143
  102466:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  10246b:	e9 40 05 00 00       	jmp    1029b0 <__alltraps>

00102470 <vector144>:
.globl vector144
vector144:
  pushl $0
  102470:	6a 00                	push   $0x0
  pushl $144
  102472:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  102477:	e9 34 05 00 00       	jmp    1029b0 <__alltraps>

0010247c <vector145>:
.globl vector145
vector145:
  pushl $0
  10247c:	6a 00                	push   $0x0
  pushl $145
  10247e:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  102483:	e9 28 05 00 00       	jmp    1029b0 <__alltraps>

00102488 <vector146>:
.globl vector146
vector146:
  pushl $0
  102488:	6a 00                	push   $0x0
  pushl $146
  10248a:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  10248f:	e9 1c 05 00 00       	jmp    1029b0 <__alltraps>

00102494 <vector147>:
.globl vector147
vector147:
  pushl $0
  102494:	6a 00                	push   $0x0
  pushl $147
  102496:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10249b:	e9 10 05 00 00       	jmp    1029b0 <__alltraps>

001024a0 <vector148>:
.globl vector148
vector148:
  pushl $0
  1024a0:	6a 00                	push   $0x0
  pushl $148
  1024a2:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  1024a7:	e9 04 05 00 00       	jmp    1029b0 <__alltraps>

001024ac <vector149>:
.globl vector149
vector149:
  pushl $0
  1024ac:	6a 00                	push   $0x0
  pushl $149
  1024ae:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  1024b3:	e9 f8 04 00 00       	jmp    1029b0 <__alltraps>

001024b8 <vector150>:
.globl vector150
vector150:
  pushl $0
  1024b8:	6a 00                	push   $0x0
  pushl $150
  1024ba:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  1024bf:	e9 ec 04 00 00       	jmp    1029b0 <__alltraps>

001024c4 <vector151>:
.globl vector151
vector151:
  pushl $0
  1024c4:	6a 00                	push   $0x0
  pushl $151
  1024c6:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  1024cb:	e9 e0 04 00 00       	jmp    1029b0 <__alltraps>

001024d0 <vector152>:
.globl vector152
vector152:
  pushl $0
  1024d0:	6a 00                	push   $0x0
  pushl $152
  1024d2:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  1024d7:	e9 d4 04 00 00       	jmp    1029b0 <__alltraps>

001024dc <vector153>:
.globl vector153
vector153:
  pushl $0
  1024dc:	6a 00                	push   $0x0
  pushl $153
  1024de:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  1024e3:	e9 c8 04 00 00       	jmp    1029b0 <__alltraps>

001024e8 <vector154>:
.globl vector154
vector154:
  pushl $0
  1024e8:	6a 00                	push   $0x0
  pushl $154
  1024ea:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  1024ef:	e9 bc 04 00 00       	jmp    1029b0 <__alltraps>

001024f4 <vector155>:
.globl vector155
vector155:
  pushl $0
  1024f4:	6a 00                	push   $0x0
  pushl $155
  1024f6:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  1024fb:	e9 b0 04 00 00       	jmp    1029b0 <__alltraps>

00102500 <vector156>:
.globl vector156
vector156:
  pushl $0
  102500:	6a 00                	push   $0x0
  pushl $156
  102502:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  102507:	e9 a4 04 00 00       	jmp    1029b0 <__alltraps>

0010250c <vector157>:
.globl vector157
vector157:
  pushl $0
  10250c:	6a 00                	push   $0x0
  pushl $157
  10250e:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102513:	e9 98 04 00 00       	jmp    1029b0 <__alltraps>

00102518 <vector158>:
.globl vector158
vector158:
  pushl $0
  102518:	6a 00                	push   $0x0
  pushl $158
  10251a:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  10251f:	e9 8c 04 00 00       	jmp    1029b0 <__alltraps>

00102524 <vector159>:
.globl vector159
vector159:
  pushl $0
  102524:	6a 00                	push   $0x0
  pushl $159
  102526:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10252b:	e9 80 04 00 00       	jmp    1029b0 <__alltraps>

00102530 <vector160>:
.globl vector160
vector160:
  pushl $0
  102530:	6a 00                	push   $0x0
  pushl $160
  102532:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  102537:	e9 74 04 00 00       	jmp    1029b0 <__alltraps>

0010253c <vector161>:
.globl vector161
vector161:
  pushl $0
  10253c:	6a 00                	push   $0x0
  pushl $161
  10253e:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  102543:	e9 68 04 00 00       	jmp    1029b0 <__alltraps>

00102548 <vector162>:
.globl vector162
vector162:
  pushl $0
  102548:	6a 00                	push   $0x0
  pushl $162
  10254a:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  10254f:	e9 5c 04 00 00       	jmp    1029b0 <__alltraps>

00102554 <vector163>:
.globl vector163
vector163:
  pushl $0
  102554:	6a 00                	push   $0x0
  pushl $163
  102556:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  10255b:	e9 50 04 00 00       	jmp    1029b0 <__alltraps>

00102560 <vector164>:
.globl vector164
vector164:
  pushl $0
  102560:	6a 00                	push   $0x0
  pushl $164
  102562:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  102567:	e9 44 04 00 00       	jmp    1029b0 <__alltraps>

0010256c <vector165>:
.globl vector165
vector165:
  pushl $0
  10256c:	6a 00                	push   $0x0
  pushl $165
  10256e:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  102573:	e9 38 04 00 00       	jmp    1029b0 <__alltraps>

00102578 <vector166>:
.globl vector166
vector166:
  pushl $0
  102578:	6a 00                	push   $0x0
  pushl $166
  10257a:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  10257f:	e9 2c 04 00 00       	jmp    1029b0 <__alltraps>

00102584 <vector167>:
.globl vector167
vector167:
  pushl $0
  102584:	6a 00                	push   $0x0
  pushl $167
  102586:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  10258b:	e9 20 04 00 00       	jmp    1029b0 <__alltraps>

00102590 <vector168>:
.globl vector168
vector168:
  pushl $0
  102590:	6a 00                	push   $0x0
  pushl $168
  102592:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  102597:	e9 14 04 00 00       	jmp    1029b0 <__alltraps>

0010259c <vector169>:
.globl vector169
vector169:
  pushl $0
  10259c:	6a 00                	push   $0x0
  pushl $169
  10259e:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  1025a3:	e9 08 04 00 00       	jmp    1029b0 <__alltraps>

001025a8 <vector170>:
.globl vector170
vector170:
  pushl $0
  1025a8:	6a 00                	push   $0x0
  pushl $170
  1025aa:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  1025af:	e9 fc 03 00 00       	jmp    1029b0 <__alltraps>

001025b4 <vector171>:
.globl vector171
vector171:
  pushl $0
  1025b4:	6a 00                	push   $0x0
  pushl $171
  1025b6:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  1025bb:	e9 f0 03 00 00       	jmp    1029b0 <__alltraps>

001025c0 <vector172>:
.globl vector172
vector172:
  pushl $0
  1025c0:	6a 00                	push   $0x0
  pushl $172
  1025c2:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  1025c7:	e9 e4 03 00 00       	jmp    1029b0 <__alltraps>

001025cc <vector173>:
.globl vector173
vector173:
  pushl $0
  1025cc:	6a 00                	push   $0x0
  pushl $173
  1025ce:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  1025d3:	e9 d8 03 00 00       	jmp    1029b0 <__alltraps>

001025d8 <vector174>:
.globl vector174
vector174:
  pushl $0
  1025d8:	6a 00                	push   $0x0
  pushl $174
  1025da:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  1025df:	e9 cc 03 00 00       	jmp    1029b0 <__alltraps>

001025e4 <vector175>:
.globl vector175
vector175:
  pushl $0
  1025e4:	6a 00                	push   $0x0
  pushl $175
  1025e6:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  1025eb:	e9 c0 03 00 00       	jmp    1029b0 <__alltraps>

001025f0 <vector176>:
.globl vector176
vector176:
  pushl $0
  1025f0:	6a 00                	push   $0x0
  pushl $176
  1025f2:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  1025f7:	e9 b4 03 00 00       	jmp    1029b0 <__alltraps>

001025fc <vector177>:
.globl vector177
vector177:
  pushl $0
  1025fc:	6a 00                	push   $0x0
  pushl $177
  1025fe:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102603:	e9 a8 03 00 00       	jmp    1029b0 <__alltraps>

00102608 <vector178>:
.globl vector178
vector178:
  pushl $0
  102608:	6a 00                	push   $0x0
  pushl $178
  10260a:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  10260f:	e9 9c 03 00 00       	jmp    1029b0 <__alltraps>

00102614 <vector179>:
.globl vector179
vector179:
  pushl $0
  102614:	6a 00                	push   $0x0
  pushl $179
  102616:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10261b:	e9 90 03 00 00       	jmp    1029b0 <__alltraps>

00102620 <vector180>:
.globl vector180
vector180:
  pushl $0
  102620:	6a 00                	push   $0x0
  pushl $180
  102622:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  102627:	e9 84 03 00 00       	jmp    1029b0 <__alltraps>

0010262c <vector181>:
.globl vector181
vector181:
  pushl $0
  10262c:	6a 00                	push   $0x0
  pushl $181
  10262e:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  102633:	e9 78 03 00 00       	jmp    1029b0 <__alltraps>

00102638 <vector182>:
.globl vector182
vector182:
  pushl $0
  102638:	6a 00                	push   $0x0
  pushl $182
  10263a:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  10263f:	e9 6c 03 00 00       	jmp    1029b0 <__alltraps>

00102644 <vector183>:
.globl vector183
vector183:
  pushl $0
  102644:	6a 00                	push   $0x0
  pushl $183
  102646:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  10264b:	e9 60 03 00 00       	jmp    1029b0 <__alltraps>

00102650 <vector184>:
.globl vector184
vector184:
  pushl $0
  102650:	6a 00                	push   $0x0
  pushl $184
  102652:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  102657:	e9 54 03 00 00       	jmp    1029b0 <__alltraps>

0010265c <vector185>:
.globl vector185
vector185:
  pushl $0
  10265c:	6a 00                	push   $0x0
  pushl $185
  10265e:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  102663:	e9 48 03 00 00       	jmp    1029b0 <__alltraps>

00102668 <vector186>:
.globl vector186
vector186:
  pushl $0
  102668:	6a 00                	push   $0x0
  pushl $186
  10266a:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  10266f:	e9 3c 03 00 00       	jmp    1029b0 <__alltraps>

00102674 <vector187>:
.globl vector187
vector187:
  pushl $0
  102674:	6a 00                	push   $0x0
  pushl $187
  102676:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  10267b:	e9 30 03 00 00       	jmp    1029b0 <__alltraps>

00102680 <vector188>:
.globl vector188
vector188:
  pushl $0
  102680:	6a 00                	push   $0x0
  pushl $188
  102682:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  102687:	e9 24 03 00 00       	jmp    1029b0 <__alltraps>

0010268c <vector189>:
.globl vector189
vector189:
  pushl $0
  10268c:	6a 00                	push   $0x0
  pushl $189
  10268e:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102693:	e9 18 03 00 00       	jmp    1029b0 <__alltraps>

00102698 <vector190>:
.globl vector190
vector190:
  pushl $0
  102698:	6a 00                	push   $0x0
  pushl $190
  10269a:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  10269f:	e9 0c 03 00 00       	jmp    1029b0 <__alltraps>

001026a4 <vector191>:
.globl vector191
vector191:
  pushl $0
  1026a4:	6a 00                	push   $0x0
  pushl $191
  1026a6:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  1026ab:	e9 00 03 00 00       	jmp    1029b0 <__alltraps>

001026b0 <vector192>:
.globl vector192
vector192:
  pushl $0
  1026b0:	6a 00                	push   $0x0
  pushl $192
  1026b2:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  1026b7:	e9 f4 02 00 00       	jmp    1029b0 <__alltraps>

001026bc <vector193>:
.globl vector193
vector193:
  pushl $0
  1026bc:	6a 00                	push   $0x0
  pushl $193
  1026be:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  1026c3:	e9 e8 02 00 00       	jmp    1029b0 <__alltraps>

001026c8 <vector194>:
.globl vector194
vector194:
  pushl $0
  1026c8:	6a 00                	push   $0x0
  pushl $194
  1026ca:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  1026cf:	e9 dc 02 00 00       	jmp    1029b0 <__alltraps>

001026d4 <vector195>:
.globl vector195
vector195:
  pushl $0
  1026d4:	6a 00                	push   $0x0
  pushl $195
  1026d6:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  1026db:	e9 d0 02 00 00       	jmp    1029b0 <__alltraps>

001026e0 <vector196>:
.globl vector196
vector196:
  pushl $0
  1026e0:	6a 00                	push   $0x0
  pushl $196
  1026e2:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  1026e7:	e9 c4 02 00 00       	jmp    1029b0 <__alltraps>

001026ec <vector197>:
.globl vector197
vector197:
  pushl $0
  1026ec:	6a 00                	push   $0x0
  pushl $197
  1026ee:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  1026f3:	e9 b8 02 00 00       	jmp    1029b0 <__alltraps>

001026f8 <vector198>:
.globl vector198
vector198:
  pushl $0
  1026f8:	6a 00                	push   $0x0
  pushl $198
  1026fa:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  1026ff:	e9 ac 02 00 00       	jmp    1029b0 <__alltraps>

00102704 <vector199>:
.globl vector199
vector199:
  pushl $0
  102704:	6a 00                	push   $0x0
  pushl $199
  102706:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10270b:	e9 a0 02 00 00       	jmp    1029b0 <__alltraps>

00102710 <vector200>:
.globl vector200
vector200:
  pushl $0
  102710:	6a 00                	push   $0x0
  pushl $200
  102712:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  102717:	e9 94 02 00 00       	jmp    1029b0 <__alltraps>

0010271c <vector201>:
.globl vector201
vector201:
  pushl $0
  10271c:	6a 00                	push   $0x0
  pushl $201
  10271e:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102723:	e9 88 02 00 00       	jmp    1029b0 <__alltraps>

00102728 <vector202>:
.globl vector202
vector202:
  pushl $0
  102728:	6a 00                	push   $0x0
  pushl $202
  10272a:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  10272f:	e9 7c 02 00 00       	jmp    1029b0 <__alltraps>

00102734 <vector203>:
.globl vector203
vector203:
  pushl $0
  102734:	6a 00                	push   $0x0
  pushl $203
  102736:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  10273b:	e9 70 02 00 00       	jmp    1029b0 <__alltraps>

00102740 <vector204>:
.globl vector204
vector204:
  pushl $0
  102740:	6a 00                	push   $0x0
  pushl $204
  102742:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  102747:	e9 64 02 00 00       	jmp    1029b0 <__alltraps>

0010274c <vector205>:
.globl vector205
vector205:
  pushl $0
  10274c:	6a 00                	push   $0x0
  pushl $205
  10274e:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  102753:	e9 58 02 00 00       	jmp    1029b0 <__alltraps>

00102758 <vector206>:
.globl vector206
vector206:
  pushl $0
  102758:	6a 00                	push   $0x0
  pushl $206
  10275a:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  10275f:	e9 4c 02 00 00       	jmp    1029b0 <__alltraps>

00102764 <vector207>:
.globl vector207
vector207:
  pushl $0
  102764:	6a 00                	push   $0x0
  pushl $207
  102766:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  10276b:	e9 40 02 00 00       	jmp    1029b0 <__alltraps>

00102770 <vector208>:
.globl vector208
vector208:
  pushl $0
  102770:	6a 00                	push   $0x0
  pushl $208
  102772:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  102777:	e9 34 02 00 00       	jmp    1029b0 <__alltraps>

0010277c <vector209>:
.globl vector209
vector209:
  pushl $0
  10277c:	6a 00                	push   $0x0
  pushl $209
  10277e:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  102783:	e9 28 02 00 00       	jmp    1029b0 <__alltraps>

00102788 <vector210>:
.globl vector210
vector210:
  pushl $0
  102788:	6a 00                	push   $0x0
  pushl $210
  10278a:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  10278f:	e9 1c 02 00 00       	jmp    1029b0 <__alltraps>

00102794 <vector211>:
.globl vector211
vector211:
  pushl $0
  102794:	6a 00                	push   $0x0
  pushl $211
  102796:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10279b:	e9 10 02 00 00       	jmp    1029b0 <__alltraps>

001027a0 <vector212>:
.globl vector212
vector212:
  pushl $0
  1027a0:	6a 00                	push   $0x0
  pushl $212
  1027a2:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  1027a7:	e9 04 02 00 00       	jmp    1029b0 <__alltraps>

001027ac <vector213>:
.globl vector213
vector213:
  pushl $0
  1027ac:	6a 00                	push   $0x0
  pushl $213
  1027ae:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  1027b3:	e9 f8 01 00 00       	jmp    1029b0 <__alltraps>

001027b8 <vector214>:
.globl vector214
vector214:
  pushl $0
  1027b8:	6a 00                	push   $0x0
  pushl $214
  1027ba:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  1027bf:	e9 ec 01 00 00       	jmp    1029b0 <__alltraps>

001027c4 <vector215>:
.globl vector215
vector215:
  pushl $0
  1027c4:	6a 00                	push   $0x0
  pushl $215
  1027c6:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  1027cb:	e9 e0 01 00 00       	jmp    1029b0 <__alltraps>

001027d0 <vector216>:
.globl vector216
vector216:
  pushl $0
  1027d0:	6a 00                	push   $0x0
  pushl $216
  1027d2:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  1027d7:	e9 d4 01 00 00       	jmp    1029b0 <__alltraps>

001027dc <vector217>:
.globl vector217
vector217:
  pushl $0
  1027dc:	6a 00                	push   $0x0
  pushl $217
  1027de:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  1027e3:	e9 c8 01 00 00       	jmp    1029b0 <__alltraps>

001027e8 <vector218>:
.globl vector218
vector218:
  pushl $0
  1027e8:	6a 00                	push   $0x0
  pushl $218
  1027ea:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  1027ef:	e9 bc 01 00 00       	jmp    1029b0 <__alltraps>

001027f4 <vector219>:
.globl vector219
vector219:
  pushl $0
  1027f4:	6a 00                	push   $0x0
  pushl $219
  1027f6:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  1027fb:	e9 b0 01 00 00       	jmp    1029b0 <__alltraps>

00102800 <vector220>:
.globl vector220
vector220:
  pushl $0
  102800:	6a 00                	push   $0x0
  pushl $220
  102802:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  102807:	e9 a4 01 00 00       	jmp    1029b0 <__alltraps>

0010280c <vector221>:
.globl vector221
vector221:
  pushl $0
  10280c:	6a 00                	push   $0x0
  pushl $221
  10280e:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102813:	e9 98 01 00 00       	jmp    1029b0 <__alltraps>

00102818 <vector222>:
.globl vector222
vector222:
  pushl $0
  102818:	6a 00                	push   $0x0
  pushl $222
  10281a:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  10281f:	e9 8c 01 00 00       	jmp    1029b0 <__alltraps>

00102824 <vector223>:
.globl vector223
vector223:
  pushl $0
  102824:	6a 00                	push   $0x0
  pushl $223
  102826:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10282b:	e9 80 01 00 00       	jmp    1029b0 <__alltraps>

00102830 <vector224>:
.globl vector224
vector224:
  pushl $0
  102830:	6a 00                	push   $0x0
  pushl $224
  102832:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  102837:	e9 74 01 00 00       	jmp    1029b0 <__alltraps>

0010283c <vector225>:
.globl vector225
vector225:
  pushl $0
  10283c:	6a 00                	push   $0x0
  pushl $225
  10283e:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  102843:	e9 68 01 00 00       	jmp    1029b0 <__alltraps>

00102848 <vector226>:
.globl vector226
vector226:
  pushl $0
  102848:	6a 00                	push   $0x0
  pushl $226
  10284a:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  10284f:	e9 5c 01 00 00       	jmp    1029b0 <__alltraps>

00102854 <vector227>:
.globl vector227
vector227:
  pushl $0
  102854:	6a 00                	push   $0x0
  pushl $227
  102856:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  10285b:	e9 50 01 00 00       	jmp    1029b0 <__alltraps>

00102860 <vector228>:
.globl vector228
vector228:
  pushl $0
  102860:	6a 00                	push   $0x0
  pushl $228
  102862:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  102867:	e9 44 01 00 00       	jmp    1029b0 <__alltraps>

0010286c <vector229>:
.globl vector229
vector229:
  pushl $0
  10286c:	6a 00                	push   $0x0
  pushl $229
  10286e:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  102873:	e9 38 01 00 00       	jmp    1029b0 <__alltraps>

00102878 <vector230>:
.globl vector230
vector230:
  pushl $0
  102878:	6a 00                	push   $0x0
  pushl $230
  10287a:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  10287f:	e9 2c 01 00 00       	jmp    1029b0 <__alltraps>

00102884 <vector231>:
.globl vector231
vector231:
  pushl $0
  102884:	6a 00                	push   $0x0
  pushl $231
  102886:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  10288b:	e9 20 01 00 00       	jmp    1029b0 <__alltraps>

00102890 <vector232>:
.globl vector232
vector232:
  pushl $0
  102890:	6a 00                	push   $0x0
  pushl $232
  102892:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  102897:	e9 14 01 00 00       	jmp    1029b0 <__alltraps>

0010289c <vector233>:
.globl vector233
vector233:
  pushl $0
  10289c:	6a 00                	push   $0x0
  pushl $233
  10289e:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  1028a3:	e9 08 01 00 00       	jmp    1029b0 <__alltraps>

001028a8 <vector234>:
.globl vector234
vector234:
  pushl $0
  1028a8:	6a 00                	push   $0x0
  pushl $234
  1028aa:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  1028af:	e9 fc 00 00 00       	jmp    1029b0 <__alltraps>

001028b4 <vector235>:
.globl vector235
vector235:
  pushl $0
  1028b4:	6a 00                	push   $0x0
  pushl $235
  1028b6:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  1028bb:	e9 f0 00 00 00       	jmp    1029b0 <__alltraps>

001028c0 <vector236>:
.globl vector236
vector236:
  pushl $0
  1028c0:	6a 00                	push   $0x0
  pushl $236
  1028c2:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  1028c7:	e9 e4 00 00 00       	jmp    1029b0 <__alltraps>

001028cc <vector237>:
.globl vector237
vector237:
  pushl $0
  1028cc:	6a 00                	push   $0x0
  pushl $237
  1028ce:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  1028d3:	e9 d8 00 00 00       	jmp    1029b0 <__alltraps>

001028d8 <vector238>:
.globl vector238
vector238:
  pushl $0
  1028d8:	6a 00                	push   $0x0
  pushl $238
  1028da:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  1028df:	e9 cc 00 00 00       	jmp    1029b0 <__alltraps>

001028e4 <vector239>:
.globl vector239
vector239:
  pushl $0
  1028e4:	6a 00                	push   $0x0
  pushl $239
  1028e6:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  1028eb:	e9 c0 00 00 00       	jmp    1029b0 <__alltraps>

001028f0 <vector240>:
.globl vector240
vector240:
  pushl $0
  1028f0:	6a 00                	push   $0x0
  pushl $240
  1028f2:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  1028f7:	e9 b4 00 00 00       	jmp    1029b0 <__alltraps>

001028fc <vector241>:
.globl vector241
vector241:
  pushl $0
  1028fc:	6a 00                	push   $0x0
  pushl $241
  1028fe:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102903:	e9 a8 00 00 00       	jmp    1029b0 <__alltraps>

00102908 <vector242>:
.globl vector242
vector242:
  pushl $0
  102908:	6a 00                	push   $0x0
  pushl $242
  10290a:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  10290f:	e9 9c 00 00 00       	jmp    1029b0 <__alltraps>

00102914 <vector243>:
.globl vector243
vector243:
  pushl $0
  102914:	6a 00                	push   $0x0
  pushl $243
  102916:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10291b:	e9 90 00 00 00       	jmp    1029b0 <__alltraps>

00102920 <vector244>:
.globl vector244
vector244:
  pushl $0
  102920:	6a 00                	push   $0x0
  pushl $244
  102922:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  102927:	e9 84 00 00 00       	jmp    1029b0 <__alltraps>

0010292c <vector245>:
.globl vector245
vector245:
  pushl $0
  10292c:	6a 00                	push   $0x0
  pushl $245
  10292e:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  102933:	e9 78 00 00 00       	jmp    1029b0 <__alltraps>

00102938 <vector246>:
.globl vector246
vector246:
  pushl $0
  102938:	6a 00                	push   $0x0
  pushl $246
  10293a:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  10293f:	e9 6c 00 00 00       	jmp    1029b0 <__alltraps>

00102944 <vector247>:
.globl vector247
vector247:
  pushl $0
  102944:	6a 00                	push   $0x0
  pushl $247
  102946:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  10294b:	e9 60 00 00 00       	jmp    1029b0 <__alltraps>

00102950 <vector248>:
.globl vector248
vector248:
  pushl $0
  102950:	6a 00                	push   $0x0
  pushl $248
  102952:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  102957:	e9 54 00 00 00       	jmp    1029b0 <__alltraps>

0010295c <vector249>:
.globl vector249
vector249:
  pushl $0
  10295c:	6a 00                	push   $0x0
  pushl $249
  10295e:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  102963:	e9 48 00 00 00       	jmp    1029b0 <__alltraps>

00102968 <vector250>:
.globl vector250
vector250:
  pushl $0
  102968:	6a 00                	push   $0x0
  pushl $250
  10296a:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  10296f:	e9 3c 00 00 00       	jmp    1029b0 <__alltraps>

00102974 <vector251>:
.globl vector251
vector251:
  pushl $0
  102974:	6a 00                	push   $0x0
  pushl $251
  102976:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  10297b:	e9 30 00 00 00       	jmp    1029b0 <__alltraps>

00102980 <vector252>:
.globl vector252
vector252:
  pushl $0
  102980:	6a 00                	push   $0x0
  pushl $252
  102982:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  102987:	e9 24 00 00 00       	jmp    1029b0 <__alltraps>

0010298c <vector253>:
.globl vector253
vector253:
  pushl $0
  10298c:	6a 00                	push   $0x0
  pushl $253
  10298e:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102993:	e9 18 00 00 00       	jmp    1029b0 <__alltraps>

00102998 <vector254>:
.globl vector254
vector254:
  pushl $0
  102998:	6a 00                	push   $0x0
  pushl $254
  10299a:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  10299f:	e9 0c 00 00 00       	jmp    1029b0 <__alltraps>

001029a4 <vector255>:
.globl vector255
vector255:
  pushl $0
  1029a4:	6a 00                	push   $0x0
  pushl $255
  1029a6:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  1029ab:	e9 00 00 00 00       	jmp    1029b0 <__alltraps>

001029b0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  1029b0:	1e                   	push   %ds
    pushl %es
  1029b1:	06                   	push   %es
    pushl %fs
  1029b2:	0f a0                	push   %fs
    pushl %gs
  1029b4:	0f a8                	push   %gs
    pushal
  1029b6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  1029b7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  1029bc:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  1029be:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  1029c0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  1029c1:	e8 64 f5 ff ff       	call   101f2a <trap>

    # pop the pushed stack pointer
    popl %esp
  1029c6:	5c                   	pop    %esp

001029c7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  1029c7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  1029c8:	0f a9                	pop    %gs
    popl %fs
  1029ca:	0f a1                	pop    %fs
    popl %es
  1029cc:	07                   	pop    %es
    popl %ds
  1029cd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  1029ce:	83 c4 08             	add    $0x8,%esp
    iret
  1029d1:	cf                   	iret   

001029d2 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  1029d2:	55                   	push   %ebp
  1029d3:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  1029d5:	8b 45 08             	mov    0x8(%ebp),%eax
  1029d8:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  1029db:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e0:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  1029e2:	b8 23 00 00 00       	mov    $0x23,%eax
  1029e7:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  1029e9:	b8 10 00 00 00       	mov    $0x10,%eax
  1029ee:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  1029f0:	b8 10 00 00 00       	mov    $0x10,%eax
  1029f5:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  1029f7:	b8 10 00 00 00       	mov    $0x10,%eax
  1029fc:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  1029fe:	ea 05 2a 10 00 08 00 	ljmp   $0x8,$0x102a05
}
  102a05:	90                   	nop
  102a06:	5d                   	pop    %ebp
  102a07:	c3                   	ret    

00102a08 <gdt_init>:
/* temporary kernel stack */
uint8_t stack0[1024];

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  102a08:	55                   	push   %ebp
  102a09:	89 e5                	mov    %esp,%ebp
  102a0b:	83 ec 14             	sub    $0x14,%esp
    // Setup a TSS so that we can get the right stack when we trap from
    // user to the kernel. But not safe here, it's only a temporary value,
    // it will be set to KSTACKTOP in lab2.
    ts.ts_esp0 = (uint32_t)&stack0 + sizeof(stack0);
  102a0e:	b8 a0 f9 10 00       	mov    $0x10f9a0,%eax
  102a13:	05 00 04 00 00       	add    $0x400,%eax
  102a18:	a3 c4 f8 10 00       	mov    %eax,0x10f8c4
    ts.ts_ss0 = KERNEL_DS;
  102a1d:	66 c7 05 c8 f8 10 00 	movw   $0x10,0x10f8c8
  102a24:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEG16(STS_T32A, (uint32_t)&ts, sizeof(ts), DPL_KERNEL);
  102a26:	66 c7 05 08 ea 10 00 	movw   $0x68,0x10ea08
  102a2d:	68 00 
  102a2f:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102a34:	0f b7 c0             	movzwl %ax,%eax
  102a37:	66 a3 0a ea 10 00    	mov    %ax,0x10ea0a
  102a3d:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102a42:	c1 e8 10             	shr    $0x10,%eax
  102a45:	a2 0c ea 10 00       	mov    %al,0x10ea0c
  102a4a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a51:	24 f0                	and    $0xf0,%al
  102a53:	0c 09                	or     $0x9,%al
  102a55:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a5a:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a61:	0c 10                	or     $0x10,%al
  102a63:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a68:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a6f:	24 9f                	and    $0x9f,%al
  102a71:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a76:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102a7d:	0c 80                	or     $0x80,%al
  102a7f:	a2 0d ea 10 00       	mov    %al,0x10ea0d
  102a84:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a8b:	24 f0                	and    $0xf0,%al
  102a8d:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102a92:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102a99:	24 ef                	and    $0xef,%al
  102a9b:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aa0:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102aa7:	24 df                	and    $0xdf,%al
  102aa9:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aae:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102ab5:	0c 40                	or     $0x40,%al
  102ab7:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102abc:	0f b6 05 0e ea 10 00 	movzbl 0x10ea0e,%eax
  102ac3:	24 7f                	and    $0x7f,%al
  102ac5:	a2 0e ea 10 00       	mov    %al,0x10ea0e
  102aca:	b8 c0 f8 10 00       	mov    $0x10f8c0,%eax
  102acf:	c1 e8 18             	shr    $0x18,%eax
  102ad2:	a2 0f ea 10 00       	mov    %al,0x10ea0f
    gdt[SEG_TSS].sd_s = 0;
  102ad7:	0f b6 05 0d ea 10 00 	movzbl 0x10ea0d,%eax
  102ade:	24 ef                	and    $0xef,%al
  102ae0:	a2 0d ea 10 00       	mov    %al,0x10ea0d

    // reload all segment registers
    lgdt(&gdt_pd);
  102ae5:	c7 04 24 10 ea 10 00 	movl   $0x10ea10,(%esp)
  102aec:	e8 e1 fe ff ff       	call   1029d2 <lgdt>
  102af1:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel));
  102af7:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  102afb:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  102afe:	90                   	nop
  102aff:	c9                   	leave  
  102b00:	c3                   	ret    

00102b01 <pmm_init>:

/* pmm_init - initialize the physical memory management */
void
pmm_init(void) {
  102b01:	55                   	push   %ebp
  102b02:	89 e5                	mov    %esp,%ebp
    gdt_init();
  102b04:	e8 ff fe ff ff       	call   102a08 <gdt_init>
}
  102b09:	90                   	nop
  102b0a:	5d                   	pop    %ebp
  102b0b:	c3                   	ret    

00102b0c <strlen>:
 * @s:        the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  102b0c:	55                   	push   %ebp
  102b0d:	89 e5                	mov    %esp,%ebp
  102b0f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  102b19:	eb 03                	jmp    102b1e <strlen+0x12>
        cnt ++;
  102b1b:	ff 45 fc             	incl   -0x4(%ebp)
    while (*s ++ != '\0') {
  102b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  102b21:	8d 50 01             	lea    0x1(%eax),%edx
  102b24:	89 55 08             	mov    %edx,0x8(%ebp)
  102b27:	0f b6 00             	movzbl (%eax),%eax
  102b2a:	84 c0                	test   %al,%al
  102b2c:	75 ed                	jne    102b1b <strlen+0xf>
    }
    return cnt;
  102b2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b31:	c9                   	leave  
  102b32:	c3                   	ret    

00102b33 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  102b33:	55                   	push   %ebp
  102b34:	89 e5                	mov    %esp,%ebp
  102b36:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  102b39:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b40:	eb 03                	jmp    102b45 <strnlen+0x12>
        cnt ++;
  102b42:	ff 45 fc             	incl   -0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  102b45:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102b48:	3b 45 0c             	cmp    0xc(%ebp),%eax
  102b4b:	73 10                	jae    102b5d <strnlen+0x2a>
  102b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  102b50:	8d 50 01             	lea    0x1(%eax),%edx
  102b53:	89 55 08             	mov    %edx,0x8(%ebp)
  102b56:	0f b6 00             	movzbl (%eax),%eax
  102b59:	84 c0                	test   %al,%al
  102b5b:	75 e5                	jne    102b42 <strnlen+0xf>
    }
    return cnt;
  102b5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  102b60:	c9                   	leave  
  102b61:	c3                   	ret    

00102b62 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  102b62:	55                   	push   %ebp
  102b63:	89 e5                	mov    %esp,%ebp
  102b65:	57                   	push   %edi
  102b66:	56                   	push   %esi
  102b67:	83 ec 20             	sub    $0x20,%esp
  102b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  102b6d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  102b73:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  102b76:	8b 55 f0             	mov    -0x10(%ebp),%edx
  102b79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102b7c:	89 d1                	mov    %edx,%ecx
  102b7e:	89 c2                	mov    %eax,%edx
  102b80:	89 ce                	mov    %ecx,%esi
  102b82:	89 d7                	mov    %edx,%edi
  102b84:	ac                   	lods   %ds:(%esi),%al
  102b85:	aa                   	stos   %al,%es:(%edi)
  102b86:	84 c0                	test   %al,%al
  102b88:	75 fa                	jne    102b84 <strcpy+0x22>
  102b8a:	89 fa                	mov    %edi,%edx
  102b8c:	89 f1                	mov    %esi,%ecx
  102b8e:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102b91:	89 55 e8             	mov    %edx,-0x18(%ebp)
  102b94:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "stosb;"
            "testb %%al, %%al;"
            "jne 1b;"
            : "=&S" (d0), "=&D" (d1), "=&a" (d2)
            : "0" (src), "1" (dst) : "memory");
    return dst;
  102b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_STRCPY
    return __strcpy(dst, src);
  102b9a:	90                   	nop
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  102b9b:	83 c4 20             	add    $0x20,%esp
  102b9e:	5e                   	pop    %esi
  102b9f:	5f                   	pop    %edi
  102ba0:	5d                   	pop    %ebp
  102ba1:	c3                   	ret    

00102ba2 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  102ba2:	55                   	push   %ebp
  102ba3:	89 e5                	mov    %esp,%ebp
  102ba5:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  102ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  102bab:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  102bae:	eb 1e                	jmp    102bce <strncpy+0x2c>
        if ((*p = *src) != '\0') {
  102bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bb3:	0f b6 10             	movzbl (%eax),%edx
  102bb6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102bb9:	88 10                	mov    %dl,(%eax)
  102bbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102bbe:	0f b6 00             	movzbl (%eax),%eax
  102bc1:	84 c0                	test   %al,%al
  102bc3:	74 03                	je     102bc8 <strncpy+0x26>
            src ++;
  102bc5:	ff 45 0c             	incl   0xc(%ebp)
        }
        p ++, len --;
  102bc8:	ff 45 fc             	incl   -0x4(%ebp)
  102bcb:	ff 4d 10             	decl   0x10(%ebp)
    while (len > 0) {
  102bce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102bd2:	75 dc                	jne    102bb0 <strncpy+0xe>
    }
    return dst;
  102bd4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102bd7:	c9                   	leave  
  102bd8:	c3                   	ret    

00102bd9 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  102bd9:	55                   	push   %ebp
  102bda:	89 e5                	mov    %esp,%ebp
  102bdc:	57                   	push   %edi
  102bdd:	56                   	push   %esi
  102bde:	83 ec 20             	sub    $0x20,%esp
  102be1:	8b 45 08             	mov    0x8(%ebp),%eax
  102be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102be7:	8b 45 0c             	mov    0xc(%ebp),%eax
  102bea:	89 45 f0             	mov    %eax,-0x10(%ebp)
    asm volatile (
  102bed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102bf0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102bf3:	89 d1                	mov    %edx,%ecx
  102bf5:	89 c2                	mov    %eax,%edx
  102bf7:	89 ce                	mov    %ecx,%esi
  102bf9:	89 d7                	mov    %edx,%edi
  102bfb:	ac                   	lods   %ds:(%esi),%al
  102bfc:	ae                   	scas   %es:(%edi),%al
  102bfd:	75 08                	jne    102c07 <strcmp+0x2e>
  102bff:	84 c0                	test   %al,%al
  102c01:	75 f8                	jne    102bfb <strcmp+0x22>
  102c03:	31 c0                	xor    %eax,%eax
  102c05:	eb 04                	jmp    102c0b <strcmp+0x32>
  102c07:	19 c0                	sbb    %eax,%eax
  102c09:	0c 01                	or     $0x1,%al
  102c0b:	89 fa                	mov    %edi,%edx
  102c0d:	89 f1                	mov    %esi,%ecx
  102c0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102c12:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102c15:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return ret;
  102c18:	8b 45 ec             	mov    -0x14(%ebp),%eax
#ifdef __HAVE_ARCH_STRCMP
    return __strcmp(s1, s2);
  102c1b:	90                   	nop
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  102c1c:	83 c4 20             	add    $0x20,%esp
  102c1f:	5e                   	pop    %esi
  102c20:	5f                   	pop    %edi
  102c21:	5d                   	pop    %ebp
  102c22:	c3                   	ret    

00102c23 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  102c23:	55                   	push   %ebp
  102c24:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c26:	eb 09                	jmp    102c31 <strncmp+0xe>
        n --, s1 ++, s2 ++;
  102c28:	ff 4d 10             	decl   0x10(%ebp)
  102c2b:	ff 45 08             	incl   0x8(%ebp)
  102c2e:	ff 45 0c             	incl   0xc(%ebp)
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  102c31:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c35:	74 1a                	je     102c51 <strncmp+0x2e>
  102c37:	8b 45 08             	mov    0x8(%ebp),%eax
  102c3a:	0f b6 00             	movzbl (%eax),%eax
  102c3d:	84 c0                	test   %al,%al
  102c3f:	74 10                	je     102c51 <strncmp+0x2e>
  102c41:	8b 45 08             	mov    0x8(%ebp),%eax
  102c44:	0f b6 10             	movzbl (%eax),%edx
  102c47:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c4a:	0f b6 00             	movzbl (%eax),%eax
  102c4d:	38 c2                	cmp    %al,%dl
  102c4f:	74 d7                	je     102c28 <strncmp+0x5>
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  102c51:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102c55:	74 18                	je     102c6f <strncmp+0x4c>
  102c57:	8b 45 08             	mov    0x8(%ebp),%eax
  102c5a:	0f b6 00             	movzbl (%eax),%eax
  102c5d:	0f b6 d0             	movzbl %al,%edx
  102c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c63:	0f b6 00             	movzbl (%eax),%eax
  102c66:	0f b6 c0             	movzbl %al,%eax
  102c69:	29 c2                	sub    %eax,%edx
  102c6b:	89 d0                	mov    %edx,%eax
  102c6d:	eb 05                	jmp    102c74 <strncmp+0x51>
  102c6f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102c74:	5d                   	pop    %ebp
  102c75:	c3                   	ret    

00102c76 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  102c76:	55                   	push   %ebp
  102c77:	89 e5                	mov    %esp,%ebp
  102c79:	83 ec 04             	sub    $0x4,%esp
  102c7c:	8b 45 0c             	mov    0xc(%ebp),%eax
  102c7f:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102c82:	eb 13                	jmp    102c97 <strchr+0x21>
        if (*s == c) {
  102c84:	8b 45 08             	mov    0x8(%ebp),%eax
  102c87:	0f b6 00             	movzbl (%eax),%eax
  102c8a:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102c8d:	75 05                	jne    102c94 <strchr+0x1e>
            return (char *)s;
  102c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  102c92:	eb 12                	jmp    102ca6 <strchr+0x30>
        }
        s ++;
  102c94:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102c97:	8b 45 08             	mov    0x8(%ebp),%eax
  102c9a:	0f b6 00             	movzbl (%eax),%eax
  102c9d:	84 c0                	test   %al,%al
  102c9f:	75 e3                	jne    102c84 <strchr+0xe>
    }
    return NULL;
  102ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102ca6:	c9                   	leave  
  102ca7:	c3                   	ret    

00102ca8 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  102ca8:	55                   	push   %ebp
  102ca9:	89 e5                	mov    %esp,%ebp
  102cab:	83 ec 04             	sub    $0x4,%esp
  102cae:	8b 45 0c             	mov    0xc(%ebp),%eax
  102cb1:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  102cb4:	eb 0e                	jmp    102cc4 <strfind+0x1c>
        if (*s == c) {
  102cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  102cb9:	0f b6 00             	movzbl (%eax),%eax
  102cbc:	38 45 fc             	cmp    %al,-0x4(%ebp)
  102cbf:	74 0f                	je     102cd0 <strfind+0x28>
            break;
        }
        s ++;
  102cc1:	ff 45 08             	incl   0x8(%ebp)
    while (*s != '\0') {
  102cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  102cc7:	0f b6 00             	movzbl (%eax),%eax
  102cca:	84 c0                	test   %al,%al
  102ccc:	75 e8                	jne    102cb6 <strfind+0xe>
  102cce:	eb 01                	jmp    102cd1 <strfind+0x29>
            break;
  102cd0:	90                   	nop
    }
    return (char *)s;
  102cd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  102cd4:	c9                   	leave  
  102cd5:	c3                   	ret    

00102cd6 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  102cd6:	55                   	push   %ebp
  102cd7:	89 e5                	mov    %esp,%ebp
  102cd9:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  102cdc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  102ce3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  102cea:	eb 03                	jmp    102cef <strtol+0x19>
        s ++;
  102cec:	ff 45 08             	incl   0x8(%ebp)
    while (*s == ' ' || *s == '\t') {
  102cef:	8b 45 08             	mov    0x8(%ebp),%eax
  102cf2:	0f b6 00             	movzbl (%eax),%eax
  102cf5:	3c 20                	cmp    $0x20,%al
  102cf7:	74 f3                	je     102cec <strtol+0x16>
  102cf9:	8b 45 08             	mov    0x8(%ebp),%eax
  102cfc:	0f b6 00             	movzbl (%eax),%eax
  102cff:	3c 09                	cmp    $0x9,%al
  102d01:	74 e9                	je     102cec <strtol+0x16>
    }

    // plus/minus sign
    if (*s == '+') {
  102d03:	8b 45 08             	mov    0x8(%ebp),%eax
  102d06:	0f b6 00             	movzbl (%eax),%eax
  102d09:	3c 2b                	cmp    $0x2b,%al
  102d0b:	75 05                	jne    102d12 <strtol+0x3c>
        s ++;
  102d0d:	ff 45 08             	incl   0x8(%ebp)
  102d10:	eb 14                	jmp    102d26 <strtol+0x50>
    }
    else if (*s == '-') {
  102d12:	8b 45 08             	mov    0x8(%ebp),%eax
  102d15:	0f b6 00             	movzbl (%eax),%eax
  102d18:	3c 2d                	cmp    $0x2d,%al
  102d1a:	75 0a                	jne    102d26 <strtol+0x50>
        s ++, neg = 1;
  102d1c:	ff 45 08             	incl   0x8(%ebp)
  102d1f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  102d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d2a:	74 06                	je     102d32 <strtol+0x5c>
  102d2c:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  102d30:	75 22                	jne    102d54 <strtol+0x7e>
  102d32:	8b 45 08             	mov    0x8(%ebp),%eax
  102d35:	0f b6 00             	movzbl (%eax),%eax
  102d38:	3c 30                	cmp    $0x30,%al
  102d3a:	75 18                	jne    102d54 <strtol+0x7e>
  102d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  102d3f:	40                   	inc    %eax
  102d40:	0f b6 00             	movzbl (%eax),%eax
  102d43:	3c 78                	cmp    $0x78,%al
  102d45:	75 0d                	jne    102d54 <strtol+0x7e>
        s += 2, base = 16;
  102d47:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  102d4b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  102d52:	eb 29                	jmp    102d7d <strtol+0xa7>
    }
    else if (base == 0 && s[0] == '0') {
  102d54:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d58:	75 16                	jne    102d70 <strtol+0x9a>
  102d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  102d5d:	0f b6 00             	movzbl (%eax),%eax
  102d60:	3c 30                	cmp    $0x30,%al
  102d62:	75 0c                	jne    102d70 <strtol+0x9a>
        s ++, base = 8;
  102d64:	ff 45 08             	incl   0x8(%ebp)
  102d67:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  102d6e:	eb 0d                	jmp    102d7d <strtol+0xa7>
    }
    else if (base == 0) {
  102d70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  102d74:	75 07                	jne    102d7d <strtol+0xa7>
        base = 10;
  102d76:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  102d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  102d80:	0f b6 00             	movzbl (%eax),%eax
  102d83:	3c 2f                	cmp    $0x2f,%al
  102d85:	7e 1b                	jle    102da2 <strtol+0xcc>
  102d87:	8b 45 08             	mov    0x8(%ebp),%eax
  102d8a:	0f b6 00             	movzbl (%eax),%eax
  102d8d:	3c 39                	cmp    $0x39,%al
  102d8f:	7f 11                	jg     102da2 <strtol+0xcc>
            dig = *s - '0';
  102d91:	8b 45 08             	mov    0x8(%ebp),%eax
  102d94:	0f b6 00             	movzbl (%eax),%eax
  102d97:	0f be c0             	movsbl %al,%eax
  102d9a:	83 e8 30             	sub    $0x30,%eax
  102d9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102da0:	eb 48                	jmp    102dea <strtol+0x114>
        }
        else if (*s >= 'a' && *s <= 'z') {
  102da2:	8b 45 08             	mov    0x8(%ebp),%eax
  102da5:	0f b6 00             	movzbl (%eax),%eax
  102da8:	3c 60                	cmp    $0x60,%al
  102daa:	7e 1b                	jle    102dc7 <strtol+0xf1>
  102dac:	8b 45 08             	mov    0x8(%ebp),%eax
  102daf:	0f b6 00             	movzbl (%eax),%eax
  102db2:	3c 7a                	cmp    $0x7a,%al
  102db4:	7f 11                	jg     102dc7 <strtol+0xf1>
            dig = *s - 'a' + 10;
  102db6:	8b 45 08             	mov    0x8(%ebp),%eax
  102db9:	0f b6 00             	movzbl (%eax),%eax
  102dbc:	0f be c0             	movsbl %al,%eax
  102dbf:	83 e8 57             	sub    $0x57,%eax
  102dc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102dc5:	eb 23                	jmp    102dea <strtol+0x114>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  102dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  102dca:	0f b6 00             	movzbl (%eax),%eax
  102dcd:	3c 40                	cmp    $0x40,%al
  102dcf:	7e 3b                	jle    102e0c <strtol+0x136>
  102dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  102dd4:	0f b6 00             	movzbl (%eax),%eax
  102dd7:	3c 5a                	cmp    $0x5a,%al
  102dd9:	7f 31                	jg     102e0c <strtol+0x136>
            dig = *s - 'A' + 10;
  102ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  102dde:	0f b6 00             	movzbl (%eax),%eax
  102de1:	0f be c0             	movsbl %al,%eax
  102de4:	83 e8 37             	sub    $0x37,%eax
  102de7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  102dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ded:	3b 45 10             	cmp    0x10(%ebp),%eax
  102df0:	7d 19                	jge    102e0b <strtol+0x135>
            break;
        }
        s ++, val = (val * base) + dig;
  102df2:	ff 45 08             	incl   0x8(%ebp)
  102df5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102df8:	0f af 45 10          	imul   0x10(%ebp),%eax
  102dfc:	89 c2                	mov    %eax,%edx
  102dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e01:	01 d0                	add    %edx,%eax
  102e03:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (1) {
  102e06:	e9 72 ff ff ff       	jmp    102d7d <strtol+0xa7>
            break;
  102e0b:	90                   	nop
        // we don't properly detect overflow!
    }

    if (endptr) {
  102e0c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e10:	74 08                	je     102e1a <strtol+0x144>
        *endptr = (char *) s;
  102e12:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e15:	8b 55 08             	mov    0x8(%ebp),%edx
  102e18:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  102e1a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  102e1e:	74 07                	je     102e27 <strtol+0x151>
  102e20:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e23:	f7 d8                	neg    %eax
  102e25:	eb 03                	jmp    102e2a <strtol+0x154>
  102e27:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  102e2a:	c9                   	leave  
  102e2b:	c3                   	ret    

00102e2c <memset>:
 * @n:        number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  102e2c:	55                   	push   %ebp
  102e2d:	89 e5                	mov    %esp,%ebp
  102e2f:	57                   	push   %edi
  102e30:	83 ec 24             	sub    $0x24,%esp
  102e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e36:	88 45 d8             	mov    %al,-0x28(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  102e39:	0f be 45 d8          	movsbl -0x28(%ebp),%eax
  102e3d:	8b 55 08             	mov    0x8(%ebp),%edx
  102e40:	89 55 f8             	mov    %edx,-0x8(%ebp)
  102e43:	88 45 f7             	mov    %al,-0x9(%ebp)
  102e46:	8b 45 10             	mov    0x10(%ebp),%eax
  102e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  102e4c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  102e4f:	0f b6 45 f7          	movzbl -0x9(%ebp),%eax
  102e53:	8b 55 f8             	mov    -0x8(%ebp),%edx
  102e56:	89 d7                	mov    %edx,%edi
  102e58:	f3 aa                	rep stos %al,%es:(%edi)
  102e5a:	89 fa                	mov    %edi,%edx
  102e5c:	89 4d ec             	mov    %ecx,-0x14(%ebp)
  102e5f:	89 55 e8             	mov    %edx,-0x18(%ebp)
            "rep; stosb;"
            : "=&c" (d0), "=&D" (d1)
            : "0" (n), "a" (c), "1" (s)
            : "memory");
    return s;
  102e62:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102e65:	90                   	nop
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  102e66:	83 c4 24             	add    $0x24,%esp
  102e69:	5f                   	pop    %edi
  102e6a:	5d                   	pop    %ebp
  102e6b:	c3                   	ret    

00102e6c <memmove>:
 * @n:        number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  102e6c:	55                   	push   %ebp
  102e6d:	89 e5                	mov    %esp,%ebp
  102e6f:	57                   	push   %edi
  102e70:	56                   	push   %esi
  102e71:	53                   	push   %ebx
  102e72:	83 ec 30             	sub    $0x30,%esp
  102e75:	8b 45 08             	mov    0x8(%ebp),%eax
  102e78:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102e7b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102e7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102e81:	8b 45 10             	mov    0x10(%ebp),%eax
  102e84:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  102e87:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e8a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e8d:	73 42                	jae    102ed1 <memmove+0x65>
  102e8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102e92:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102e95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102e98:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102e9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e9e:	89 45 dc             	mov    %eax,-0x24(%ebp)
            "andl $3, %%ecx;"
            "jz 1f;"
            "rep; movsb;"
            "1:"
            : "=&c" (d0), "=&D" (d1), "=&S" (d2)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102ea1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ea4:	c1 e8 02             	shr    $0x2,%eax
  102ea7:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102ea9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102eac:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eaf:	89 d7                	mov    %edx,%edi
  102eb1:	89 c6                	mov    %eax,%esi
  102eb3:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102eb5:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  102eb8:	83 e1 03             	and    $0x3,%ecx
  102ebb:	74 02                	je     102ebf <memmove+0x53>
  102ebd:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ebf:	89 f0                	mov    %esi,%eax
  102ec1:	89 fa                	mov    %edi,%edx
  102ec3:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  102ec6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  102ec9:	89 45 d0             	mov    %eax,-0x30(%ebp)
            : "memory");
    return dst;
  102ecc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
#ifdef __HAVE_ARCH_MEMMOVE
    return __memmove(dst, src, n);
  102ecf:	eb 36                	jmp    102f07 <memmove+0x9b>
            : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  102ed1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102ed4:	8d 50 ff             	lea    -0x1(%eax),%edx
  102ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102eda:	01 c2                	add    %eax,%edx
  102edc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102edf:	8d 48 ff             	lea    -0x1(%eax),%ecx
  102ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ee5:	8d 1c 01             	lea    (%ecx,%eax,1),%ebx
    asm volatile (
  102ee8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102eeb:	89 c1                	mov    %eax,%ecx
  102eed:	89 d8                	mov    %ebx,%eax
  102eef:	89 d6                	mov    %edx,%esi
  102ef1:	89 c7                	mov    %eax,%edi
  102ef3:	fd                   	std    
  102ef4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102ef6:	fc                   	cld    
  102ef7:	89 f8                	mov    %edi,%eax
  102ef9:	89 f2                	mov    %esi,%edx
  102efb:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  102efe:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102f01:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    return dst;
  102f04:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  102f07:	83 c4 30             	add    $0x30,%esp
  102f0a:	5b                   	pop    %ebx
  102f0b:	5e                   	pop    %esi
  102f0c:	5f                   	pop    %edi
  102f0d:	5d                   	pop    %ebp
  102f0e:	c3                   	ret    

00102f0f <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  102f0f:	55                   	push   %ebp
  102f10:	89 e5                	mov    %esp,%ebp
  102f12:	57                   	push   %edi
  102f13:	56                   	push   %esi
  102f14:	83 ec 20             	sub    $0x20,%esp
  102f17:	8b 45 08             	mov    0x8(%ebp),%eax
  102f1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102f1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f20:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102f23:	8b 45 10             	mov    0x10(%ebp),%eax
  102f26:	89 45 ec             	mov    %eax,-0x14(%ebp)
            : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  102f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f2c:	c1 e8 02             	shr    $0x2,%eax
  102f2f:	89 c1                	mov    %eax,%ecx
    asm volatile (
  102f31:	8b 55 f4             	mov    -0xc(%ebp),%edx
  102f34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f37:	89 d7                	mov    %edx,%edi
  102f39:	89 c6                	mov    %eax,%esi
  102f3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  102f3d:	8b 4d ec             	mov    -0x14(%ebp),%ecx
  102f40:	83 e1 03             	and    $0x3,%ecx
  102f43:	74 02                	je     102f47 <memcpy+0x38>
  102f45:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  102f47:	89 f0                	mov    %esi,%eax
  102f49:	89 fa                	mov    %edi,%edx
  102f4b:	89 4d e8             	mov    %ecx,-0x18(%ebp)
  102f4e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  102f51:	89 45 e0             	mov    %eax,-0x20(%ebp)
    return dst;
  102f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
#ifdef __HAVE_ARCH_MEMCPY
    return __memcpy(dst, src, n);
  102f57:	90                   	nop
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  102f58:	83 c4 20             	add    $0x20,%esp
  102f5b:	5e                   	pop    %esi
  102f5c:	5f                   	pop    %edi
  102f5d:	5d                   	pop    %ebp
  102f5e:	c3                   	ret    

00102f5f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  102f5f:	55                   	push   %ebp
  102f60:	89 e5                	mov    %esp,%ebp
  102f62:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  102f65:	8b 45 08             	mov    0x8(%ebp),%eax
  102f68:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  102f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  102f6e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  102f71:	eb 2e                	jmp    102fa1 <memcmp+0x42>
        if (*s1 != *s2) {
  102f73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f76:	0f b6 10             	movzbl (%eax),%edx
  102f79:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f7c:	0f b6 00             	movzbl (%eax),%eax
  102f7f:	38 c2                	cmp    %al,%dl
  102f81:	74 18                	je     102f9b <memcmp+0x3c>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  102f83:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102f86:	0f b6 00             	movzbl (%eax),%eax
  102f89:	0f b6 d0             	movzbl %al,%edx
  102f8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  102f8f:	0f b6 00             	movzbl (%eax),%eax
  102f92:	0f b6 c0             	movzbl %al,%eax
  102f95:	29 c2                	sub    %eax,%edx
  102f97:	89 d0                	mov    %edx,%eax
  102f99:	eb 18                	jmp    102fb3 <memcmp+0x54>
        }
        s1 ++, s2 ++;
  102f9b:	ff 45 fc             	incl   -0x4(%ebp)
  102f9e:	ff 45 f8             	incl   -0x8(%ebp)
    while (n -- > 0) {
  102fa1:	8b 45 10             	mov    0x10(%ebp),%eax
  102fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  102fa7:	89 55 10             	mov    %edx,0x10(%ebp)
  102faa:	85 c0                	test   %eax,%eax
  102fac:	75 c5                	jne    102f73 <memcmp+0x14>
    }
    return 0;
  102fae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  102fb3:	c9                   	leave  
  102fb4:	c3                   	ret    

00102fb5 <printnum>:
 * @width:         maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:        character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  102fb5:	55                   	push   %ebp
  102fb6:	89 e5                	mov    %esp,%ebp
  102fb8:	83 ec 58             	sub    $0x58,%esp
  102fbb:	8b 45 10             	mov    0x10(%ebp),%eax
  102fbe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  102fc1:	8b 45 14             	mov    0x14(%ebp),%eax
  102fc4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  102fc7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102fca:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102fcd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  102fd0:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  102fd3:	8b 45 18             	mov    0x18(%ebp),%eax
  102fd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  102fd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102fdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  102fdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
  102fe2:	89 55 f0             	mov    %edx,-0x10(%ebp)
  102fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102fe8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102feb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  102fef:	74 1c                	je     10300d <printnum+0x58>
  102ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102ff4:	ba 00 00 00 00       	mov    $0x0,%edx
  102ff9:	f7 75 e4             	divl   -0x1c(%ebp)
  102ffc:	89 55 f4             	mov    %edx,-0xc(%ebp)
  102fff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103002:	ba 00 00 00 00       	mov    $0x0,%edx
  103007:	f7 75 e4             	divl   -0x1c(%ebp)
  10300a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10300d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103010:	8b 55 f4             	mov    -0xc(%ebp),%edx
  103013:	f7 75 e4             	divl   -0x1c(%ebp)
  103016:	89 45 e0             	mov    %eax,-0x20(%ebp)
  103019:	89 55 dc             	mov    %edx,-0x24(%ebp)
  10301c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10301f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103022:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103025:	89 55 ec             	mov    %edx,-0x14(%ebp)
  103028:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10302b:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10302e:	8b 45 18             	mov    0x18(%ebp),%eax
  103031:	ba 00 00 00 00       	mov    $0x0,%edx
  103036:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  103039:	72 56                	jb     103091 <printnum+0xdc>
  10303b:	39 55 d4             	cmp    %edx,-0x2c(%ebp)
  10303e:	77 05                	ja     103045 <printnum+0x90>
  103040:	39 45 d0             	cmp    %eax,-0x30(%ebp)
  103043:	72 4c                	jb     103091 <printnum+0xdc>
        printnum(putch, putdat, result, base, width - 1, padc);
  103045:	8b 45 1c             	mov    0x1c(%ebp),%eax
  103048:	8d 50 ff             	lea    -0x1(%eax),%edx
  10304b:	8b 45 20             	mov    0x20(%ebp),%eax
  10304e:	89 44 24 18          	mov    %eax,0x18(%esp)
  103052:	89 54 24 14          	mov    %edx,0x14(%esp)
  103056:	8b 45 18             	mov    0x18(%ebp),%eax
  103059:	89 44 24 10          	mov    %eax,0x10(%esp)
  10305d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  103060:	8b 55 ec             	mov    -0x14(%ebp),%edx
  103063:	89 44 24 08          	mov    %eax,0x8(%esp)
  103067:	89 54 24 0c          	mov    %edx,0xc(%esp)
  10306b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10306e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103072:	8b 45 08             	mov    0x8(%ebp),%eax
  103075:	89 04 24             	mov    %eax,(%esp)
  103078:	e8 38 ff ff ff       	call   102fb5 <printnum>
  10307d:	eb 1b                	jmp    10309a <printnum+0xe5>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  10307f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103082:	89 44 24 04          	mov    %eax,0x4(%esp)
  103086:	8b 45 20             	mov    0x20(%ebp),%eax
  103089:	89 04 24             	mov    %eax,(%esp)
  10308c:	8b 45 08             	mov    0x8(%ebp),%eax
  10308f:	ff d0                	call   *%eax
        while (-- width > 0)
  103091:	ff 4d 1c             	decl   0x1c(%ebp)
  103094:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  103098:	7f e5                	jg     10307f <printnum+0xca>
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  10309a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  10309d:	05 10 3e 10 00       	add    $0x103e10,%eax
  1030a2:	0f b6 00             	movzbl (%eax),%eax
  1030a5:	0f be c0             	movsbl %al,%eax
  1030a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  1030ab:	89 54 24 04          	mov    %edx,0x4(%esp)
  1030af:	89 04 24             	mov    %eax,(%esp)
  1030b2:	8b 45 08             	mov    0x8(%ebp),%eax
  1030b5:	ff d0                	call   *%eax
}
  1030b7:	90                   	nop
  1030b8:	c9                   	leave  
  1030b9:	c3                   	ret    

001030ba <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1030ba:	55                   	push   %ebp
  1030bb:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1030bd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  1030c1:	7e 14                	jle    1030d7 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  1030c3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030c6:	8b 00                	mov    (%eax),%eax
  1030c8:	8d 48 08             	lea    0x8(%eax),%ecx
  1030cb:	8b 55 08             	mov    0x8(%ebp),%edx
  1030ce:	89 0a                	mov    %ecx,(%edx)
  1030d0:	8b 50 04             	mov    0x4(%eax),%edx
  1030d3:	8b 00                	mov    (%eax),%eax
  1030d5:	eb 30                	jmp    103107 <getuint+0x4d>
    }
    else if (lflag) {
  1030d7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1030db:	74 16                	je     1030f3 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  1030dd:	8b 45 08             	mov    0x8(%ebp),%eax
  1030e0:	8b 00                	mov    (%eax),%eax
  1030e2:	8d 48 04             	lea    0x4(%eax),%ecx
  1030e5:	8b 55 08             	mov    0x8(%ebp),%edx
  1030e8:	89 0a                	mov    %ecx,(%edx)
  1030ea:	8b 00                	mov    (%eax),%eax
  1030ec:	ba 00 00 00 00       	mov    $0x0,%edx
  1030f1:	eb 14                	jmp    103107 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  1030f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1030f6:	8b 00                	mov    (%eax),%eax
  1030f8:	8d 48 04             	lea    0x4(%eax),%ecx
  1030fb:	8b 55 08             	mov    0x8(%ebp),%edx
  1030fe:	89 0a                	mov    %ecx,(%edx)
  103100:	8b 00                	mov    (%eax),%eax
  103102:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  103107:	5d                   	pop    %ebp
  103108:	c3                   	ret    

00103109 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:            a varargs list pointer
 * @lflag:        determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  103109:	55                   	push   %ebp
  10310a:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10310c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  103110:	7e 14                	jle    103126 <getint+0x1d>
        return va_arg(*ap, long long);
  103112:	8b 45 08             	mov    0x8(%ebp),%eax
  103115:	8b 00                	mov    (%eax),%eax
  103117:	8d 48 08             	lea    0x8(%eax),%ecx
  10311a:	8b 55 08             	mov    0x8(%ebp),%edx
  10311d:	89 0a                	mov    %ecx,(%edx)
  10311f:	8b 50 04             	mov    0x4(%eax),%edx
  103122:	8b 00                	mov    (%eax),%eax
  103124:	eb 28                	jmp    10314e <getint+0x45>
    }
    else if (lflag) {
  103126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10312a:	74 12                	je     10313e <getint+0x35>
        return va_arg(*ap, long);
  10312c:	8b 45 08             	mov    0x8(%ebp),%eax
  10312f:	8b 00                	mov    (%eax),%eax
  103131:	8d 48 04             	lea    0x4(%eax),%ecx
  103134:	8b 55 08             	mov    0x8(%ebp),%edx
  103137:	89 0a                	mov    %ecx,(%edx)
  103139:	8b 00                	mov    (%eax),%eax
  10313b:	99                   	cltd   
  10313c:	eb 10                	jmp    10314e <getint+0x45>
    }
    else {
        return va_arg(*ap, int);
  10313e:	8b 45 08             	mov    0x8(%ebp),%eax
  103141:	8b 00                	mov    (%eax),%eax
  103143:	8d 48 04             	lea    0x4(%eax),%ecx
  103146:	8b 55 08             	mov    0x8(%ebp),%edx
  103149:	89 0a                	mov    %ecx,(%edx)
  10314b:	8b 00                	mov    (%eax),%eax
  10314d:	99                   	cltd   
    }
}
  10314e:	5d                   	pop    %ebp
  10314f:	c3                   	ret    

00103150 <printfmt>:
 * @putch:        specified putch function, print a single character
 * @putdat:        used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  103150:	55                   	push   %ebp
  103151:	89 e5                	mov    %esp,%ebp
  103153:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  103156:	8d 45 14             	lea    0x14(%ebp),%eax
  103159:	89 45 f4             	mov    %eax,-0xc(%ebp)
    vprintfmt(putch, putdat, fmt, ap);
  10315c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10315f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103163:	8b 45 10             	mov    0x10(%ebp),%eax
  103166:	89 44 24 08          	mov    %eax,0x8(%esp)
  10316a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10316d:	89 44 24 04          	mov    %eax,0x4(%esp)
  103171:	8b 45 08             	mov    0x8(%ebp),%eax
  103174:	89 04 24             	mov    %eax,(%esp)
  103177:	e8 03 00 00 00       	call   10317f <vprintfmt>
    va_end(ap);
}
  10317c:	90                   	nop
  10317d:	c9                   	leave  
  10317e:	c3                   	ret    

0010317f <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  10317f:	55                   	push   %ebp
  103180:	89 e5                	mov    %esp,%ebp
  103182:	56                   	push   %esi
  103183:	53                   	push   %ebx
  103184:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  103187:	eb 17                	jmp    1031a0 <vprintfmt+0x21>
            if (ch == '\0') {
  103189:	85 db                	test   %ebx,%ebx
  10318b:	0f 84 bf 03 00 00    	je     103550 <vprintfmt+0x3d1>
                return;
            }
            putch(ch, putdat);
  103191:	8b 45 0c             	mov    0xc(%ebp),%eax
  103194:	89 44 24 04          	mov    %eax,0x4(%esp)
  103198:	89 1c 24             	mov    %ebx,(%esp)
  10319b:	8b 45 08             	mov    0x8(%ebp),%eax
  10319e:	ff d0                	call   *%eax
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1031a0:	8b 45 10             	mov    0x10(%ebp),%eax
  1031a3:	8d 50 01             	lea    0x1(%eax),%edx
  1031a6:	89 55 10             	mov    %edx,0x10(%ebp)
  1031a9:	0f b6 00             	movzbl (%eax),%eax
  1031ac:	0f b6 d8             	movzbl %al,%ebx
  1031af:	83 fb 25             	cmp    $0x25,%ebx
  1031b2:	75 d5                	jne    103189 <vprintfmt+0xa>
        }

        // Process a %-escape sequence
        char padc = ' ';
  1031b4:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  1031b8:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  1031bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1031c2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  1031c5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1031cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1031cf:	89 45 e0             	mov    %eax,-0x20(%ebp)

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  1031d2:	8b 45 10             	mov    0x10(%ebp),%eax
  1031d5:	8d 50 01             	lea    0x1(%eax),%edx
  1031d8:	89 55 10             	mov    %edx,0x10(%ebp)
  1031db:	0f b6 00             	movzbl (%eax),%eax
  1031de:	0f b6 d8             	movzbl %al,%ebx
  1031e1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  1031e4:	83 f8 55             	cmp    $0x55,%eax
  1031e7:	0f 87 37 03 00 00    	ja     103524 <vprintfmt+0x3a5>
  1031ed:	8b 04 85 34 3e 10 00 	mov    0x103e34(,%eax,4),%eax
  1031f4:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  1031f6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  1031fa:	eb d6                	jmp    1031d2 <vprintfmt+0x53>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  1031fc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  103200:	eb d0                	jmp    1031d2 <vprintfmt+0x53>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  103202:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  103209:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10320c:	89 d0                	mov    %edx,%eax
  10320e:	c1 e0 02             	shl    $0x2,%eax
  103211:	01 d0                	add    %edx,%eax
  103213:	01 c0                	add    %eax,%eax
  103215:	01 d8                	add    %ebx,%eax
  103217:	83 e8 30             	sub    $0x30,%eax
  10321a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  10321d:	8b 45 10             	mov    0x10(%ebp),%eax
  103220:	0f b6 00             	movzbl (%eax),%eax
  103223:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  103226:	83 fb 2f             	cmp    $0x2f,%ebx
  103229:	7e 38                	jle    103263 <vprintfmt+0xe4>
  10322b:	83 fb 39             	cmp    $0x39,%ebx
  10322e:	7f 33                	jg     103263 <vprintfmt+0xe4>
            for (precision = 0; ; ++ fmt) {
  103230:	ff 45 10             	incl   0x10(%ebp)
                precision = precision * 10 + ch - '0';
  103233:	eb d4                	jmp    103209 <vprintfmt+0x8a>
                }
            }
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  103235:	8b 45 14             	mov    0x14(%ebp),%eax
  103238:	8d 50 04             	lea    0x4(%eax),%edx
  10323b:	89 55 14             	mov    %edx,0x14(%ebp)
  10323e:	8b 00                	mov    (%eax),%eax
  103240:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  103243:	eb 1f                	jmp    103264 <vprintfmt+0xe5>

        case '.':
            if (width < 0)
  103245:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103249:	79 87                	jns    1031d2 <vprintfmt+0x53>
                width = 0;
  10324b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  103252:	e9 7b ff ff ff       	jmp    1031d2 <vprintfmt+0x53>

        case '#':
            altflag = 1;
  103257:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  10325e:	e9 6f ff ff ff       	jmp    1031d2 <vprintfmt+0x53>
            goto process_precision;
  103263:	90                   	nop

        process_precision:
            if (width < 0)
  103264:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103268:	0f 89 64 ff ff ff    	jns    1031d2 <vprintfmt+0x53>
                width = precision, precision = -1;
  10326e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103271:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103274:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  10327b:	e9 52 ff ff ff       	jmp    1031d2 <vprintfmt+0x53>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  103280:	ff 45 e0             	incl   -0x20(%ebp)
            goto reswitch;
  103283:	e9 4a ff ff ff       	jmp    1031d2 <vprintfmt+0x53>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  103288:	8b 45 14             	mov    0x14(%ebp),%eax
  10328b:	8d 50 04             	lea    0x4(%eax),%edx
  10328e:	89 55 14             	mov    %edx,0x14(%ebp)
  103291:	8b 00                	mov    (%eax),%eax
  103293:	8b 55 0c             	mov    0xc(%ebp),%edx
  103296:	89 54 24 04          	mov    %edx,0x4(%esp)
  10329a:	89 04 24             	mov    %eax,(%esp)
  10329d:	8b 45 08             	mov    0x8(%ebp),%eax
  1032a0:	ff d0                	call   *%eax
            break;
  1032a2:	e9 a4 02 00 00       	jmp    10354b <vprintfmt+0x3cc>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1032a7:	8b 45 14             	mov    0x14(%ebp),%eax
  1032aa:	8d 50 04             	lea    0x4(%eax),%edx
  1032ad:	89 55 14             	mov    %edx,0x14(%ebp)
  1032b0:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  1032b2:	85 db                	test   %ebx,%ebx
  1032b4:	79 02                	jns    1032b8 <vprintfmt+0x139>
                err = -err;
  1032b6:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  1032b8:	83 fb 06             	cmp    $0x6,%ebx
  1032bb:	7f 0b                	jg     1032c8 <vprintfmt+0x149>
  1032bd:	8b 34 9d f4 3d 10 00 	mov    0x103df4(,%ebx,4),%esi
  1032c4:	85 f6                	test   %esi,%esi
  1032c6:	75 23                	jne    1032eb <vprintfmt+0x16c>
                printfmt(putch, putdat, "error %d", err);
  1032c8:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1032cc:	c7 44 24 08 21 3e 10 	movl   $0x103e21,0x8(%esp)
  1032d3:	00 
  1032d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032d7:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032db:	8b 45 08             	mov    0x8(%ebp),%eax
  1032de:	89 04 24             	mov    %eax,(%esp)
  1032e1:	e8 6a fe ff ff       	call   103150 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  1032e6:	e9 60 02 00 00       	jmp    10354b <vprintfmt+0x3cc>
                printfmt(putch, putdat, "%s", p);
  1032eb:	89 74 24 0c          	mov    %esi,0xc(%esp)
  1032ef:	c7 44 24 08 2a 3e 10 	movl   $0x103e2a,0x8(%esp)
  1032f6:	00 
  1032f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  1032fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  103301:	89 04 24             	mov    %eax,(%esp)
  103304:	e8 47 fe ff ff       	call   103150 <printfmt>
            break;
  103309:	e9 3d 02 00 00       	jmp    10354b <vprintfmt+0x3cc>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  10330e:	8b 45 14             	mov    0x14(%ebp),%eax
  103311:	8d 50 04             	lea    0x4(%eax),%edx
  103314:	89 55 14             	mov    %edx,0x14(%ebp)
  103317:	8b 30                	mov    (%eax),%esi
  103319:	85 f6                	test   %esi,%esi
  10331b:	75 05                	jne    103322 <vprintfmt+0x1a3>
                p = "(null)";
  10331d:	be 2d 3e 10 00       	mov    $0x103e2d,%esi
            }
            if (width > 0 && padc != '-') {
  103322:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103326:	7e 76                	jle    10339e <vprintfmt+0x21f>
  103328:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  10332c:	74 70                	je     10339e <vprintfmt+0x21f>
                for (width -= strnlen(p, precision); width > 0; width --) {
  10332e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103331:	89 44 24 04          	mov    %eax,0x4(%esp)
  103335:	89 34 24             	mov    %esi,(%esp)
  103338:	e8 f6 f7 ff ff       	call   102b33 <strnlen>
  10333d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  103340:	29 c2                	sub    %eax,%edx
  103342:	89 d0                	mov    %edx,%eax
  103344:	89 45 e8             	mov    %eax,-0x18(%ebp)
  103347:	eb 16                	jmp    10335f <vprintfmt+0x1e0>
                    putch(padc, putdat);
  103349:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  10334d:	8b 55 0c             	mov    0xc(%ebp),%edx
  103350:	89 54 24 04          	mov    %edx,0x4(%esp)
  103354:	89 04 24             	mov    %eax,(%esp)
  103357:	8b 45 08             	mov    0x8(%ebp),%eax
  10335a:	ff d0                	call   *%eax
                for (width -= strnlen(p, precision); width > 0; width --) {
  10335c:	ff 4d e8             	decl   -0x18(%ebp)
  10335f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  103363:	7f e4                	jg     103349 <vprintfmt+0x1ca>
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  103365:	eb 37                	jmp    10339e <vprintfmt+0x21f>
                if (altflag && (ch < ' ' || ch > '~')) {
  103367:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  10336b:	74 1f                	je     10338c <vprintfmt+0x20d>
  10336d:	83 fb 1f             	cmp    $0x1f,%ebx
  103370:	7e 05                	jle    103377 <vprintfmt+0x1f8>
  103372:	83 fb 7e             	cmp    $0x7e,%ebx
  103375:	7e 15                	jle    10338c <vprintfmt+0x20d>
                    putch('?', putdat);
  103377:	8b 45 0c             	mov    0xc(%ebp),%eax
  10337a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10337e:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  103385:	8b 45 08             	mov    0x8(%ebp),%eax
  103388:	ff d0                	call   *%eax
  10338a:	eb 0f                	jmp    10339b <vprintfmt+0x21c>
                }
                else {
                    putch(ch, putdat);
  10338c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10338f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103393:	89 1c 24             	mov    %ebx,(%esp)
  103396:	8b 45 08             	mov    0x8(%ebp),%eax
  103399:	ff d0                	call   *%eax
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  10339b:	ff 4d e8             	decl   -0x18(%ebp)
  10339e:	89 f0                	mov    %esi,%eax
  1033a0:	8d 70 01             	lea    0x1(%eax),%esi
  1033a3:	0f b6 00             	movzbl (%eax),%eax
  1033a6:	0f be d8             	movsbl %al,%ebx
  1033a9:	85 db                	test   %ebx,%ebx
  1033ab:	74 27                	je     1033d4 <vprintfmt+0x255>
  1033ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033b1:	78 b4                	js     103367 <vprintfmt+0x1e8>
  1033b3:	ff 4d e4             	decl   -0x1c(%ebp)
  1033b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1033ba:	79 ab                	jns    103367 <vprintfmt+0x1e8>
                }
            }
            for (; width > 0; width --) {
  1033bc:	eb 16                	jmp    1033d4 <vprintfmt+0x255>
                putch(' ', putdat);
  1033be:	8b 45 0c             	mov    0xc(%ebp),%eax
  1033c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033c5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1033cc:	8b 45 08             	mov    0x8(%ebp),%eax
  1033cf:	ff d0                	call   *%eax
            for (; width > 0; width --) {
  1033d1:	ff 4d e8             	decl   -0x18(%ebp)
  1033d4:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1033d8:	7f e4                	jg     1033be <vprintfmt+0x23f>
            }
            break;
  1033da:	e9 6c 01 00 00       	jmp    10354b <vprintfmt+0x3cc>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  1033df:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1033e2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1033e6:	8d 45 14             	lea    0x14(%ebp),%eax
  1033e9:	89 04 24             	mov    %eax,(%esp)
  1033ec:	e8 18 fd ff ff       	call   103109 <getint>
  1033f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1033f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  1033f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1033fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1033fd:	85 d2                	test   %edx,%edx
  1033ff:	79 26                	jns    103427 <vprintfmt+0x2a8>
                putch('-', putdat);
  103401:	8b 45 0c             	mov    0xc(%ebp),%eax
  103404:	89 44 24 04          	mov    %eax,0x4(%esp)
  103408:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  10340f:	8b 45 08             	mov    0x8(%ebp),%eax
  103412:	ff d0                	call   *%eax
                num = -(long long)num;
  103414:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103417:	8b 55 f4             	mov    -0xc(%ebp),%edx
  10341a:	f7 d8                	neg    %eax
  10341c:	83 d2 00             	adc    $0x0,%edx
  10341f:	f7 da                	neg    %edx
  103421:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103424:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  103427:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  10342e:	e9 a8 00 00 00       	jmp    1034db <vprintfmt+0x35c>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  103433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103436:	89 44 24 04          	mov    %eax,0x4(%esp)
  10343a:	8d 45 14             	lea    0x14(%ebp),%eax
  10343d:	89 04 24             	mov    %eax,(%esp)
  103440:	e8 75 fc ff ff       	call   1030ba <getuint>
  103445:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103448:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  10344b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  103452:	e9 84 00 00 00       	jmp    1034db <vprintfmt+0x35c>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  103457:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10345a:	89 44 24 04          	mov    %eax,0x4(%esp)
  10345e:	8d 45 14             	lea    0x14(%ebp),%eax
  103461:	89 04 24             	mov    %eax,(%esp)
  103464:	e8 51 fc ff ff       	call   1030ba <getuint>
  103469:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10346c:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  10346f:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  103476:	eb 63                	jmp    1034db <vprintfmt+0x35c>

        // pointer
        case 'p':
            putch('0', putdat);
  103478:	8b 45 0c             	mov    0xc(%ebp),%eax
  10347b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10347f:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  103486:	8b 45 08             	mov    0x8(%ebp),%eax
  103489:	ff d0                	call   *%eax
            putch('x', putdat);
  10348b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10348e:	89 44 24 04          	mov    %eax,0x4(%esp)
  103492:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  103499:	8b 45 08             	mov    0x8(%ebp),%eax
  10349c:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  10349e:	8b 45 14             	mov    0x14(%ebp),%eax
  1034a1:	8d 50 04             	lea    0x4(%eax),%edx
  1034a4:	89 55 14             	mov    %edx,0x14(%ebp)
  1034a7:	8b 00                	mov    (%eax),%eax
  1034a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  1034b3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  1034ba:	eb 1f                	jmp    1034db <vprintfmt+0x35c>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  1034bc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1034bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1034c3:	8d 45 14             	lea    0x14(%ebp),%eax
  1034c6:	89 04 24             	mov    %eax,(%esp)
  1034c9:	e8 ec fb ff ff       	call   1030ba <getuint>
  1034ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1034d1:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  1034d4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  1034db:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  1034df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034e2:	89 54 24 18          	mov    %edx,0x18(%esp)
  1034e6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  1034e9:	89 54 24 14          	mov    %edx,0x14(%esp)
  1034ed:	89 44 24 10          	mov    %eax,0x10(%esp)
  1034f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1034f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1034f7:	89 44 24 08          	mov    %eax,0x8(%esp)
  1034fb:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1034ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  103502:	89 44 24 04          	mov    %eax,0x4(%esp)
  103506:	8b 45 08             	mov    0x8(%ebp),%eax
  103509:	89 04 24             	mov    %eax,(%esp)
  10350c:	e8 a4 fa ff ff       	call   102fb5 <printnum>
            break;
  103511:	eb 38                	jmp    10354b <vprintfmt+0x3cc>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  103513:	8b 45 0c             	mov    0xc(%ebp),%eax
  103516:	89 44 24 04          	mov    %eax,0x4(%esp)
  10351a:	89 1c 24             	mov    %ebx,(%esp)
  10351d:	8b 45 08             	mov    0x8(%ebp),%eax
  103520:	ff d0                	call   *%eax
            break;
  103522:	eb 27                	jmp    10354b <vprintfmt+0x3cc>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  103524:	8b 45 0c             	mov    0xc(%ebp),%eax
  103527:	89 44 24 04          	mov    %eax,0x4(%esp)
  10352b:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  103532:	8b 45 08             	mov    0x8(%ebp),%eax
  103535:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  103537:	ff 4d 10             	decl   0x10(%ebp)
  10353a:	eb 03                	jmp    10353f <vprintfmt+0x3c0>
  10353c:	ff 4d 10             	decl   0x10(%ebp)
  10353f:	8b 45 10             	mov    0x10(%ebp),%eax
  103542:	48                   	dec    %eax
  103543:	0f b6 00             	movzbl (%eax),%eax
  103546:	3c 25                	cmp    $0x25,%al
  103548:	75 f2                	jne    10353c <vprintfmt+0x3bd>
                /* do nothing */;
            break;
  10354a:	90                   	nop
    while (1) {
  10354b:	e9 37 fc ff ff       	jmp    103187 <vprintfmt+0x8>
                return;
  103550:	90                   	nop
        }
    }
}
  103551:	83 c4 40             	add    $0x40,%esp
  103554:	5b                   	pop    %ebx
  103555:	5e                   	pop    %esi
  103556:	5d                   	pop    %ebp
  103557:	c3                   	ret    

00103558 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:            the character will be printed
 * @b:            the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  103558:	55                   	push   %ebp
  103559:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  10355b:	8b 45 0c             	mov    0xc(%ebp),%eax
  10355e:	8b 40 08             	mov    0x8(%eax),%eax
  103561:	8d 50 01             	lea    0x1(%eax),%edx
  103564:	8b 45 0c             	mov    0xc(%ebp),%eax
  103567:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  10356a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10356d:	8b 10                	mov    (%eax),%edx
  10356f:	8b 45 0c             	mov    0xc(%ebp),%eax
  103572:	8b 40 04             	mov    0x4(%eax),%eax
  103575:	39 c2                	cmp    %eax,%edx
  103577:	73 12                	jae    10358b <sprintputch+0x33>
        *b->buf ++ = ch;
  103579:	8b 45 0c             	mov    0xc(%ebp),%eax
  10357c:	8b 00                	mov    (%eax),%eax
  10357e:	8d 48 01             	lea    0x1(%eax),%ecx
  103581:	8b 55 0c             	mov    0xc(%ebp),%edx
  103584:	89 0a                	mov    %ecx,(%edx)
  103586:	8b 55 08             	mov    0x8(%ebp),%edx
  103589:	88 10                	mov    %dl,(%eax)
    }
}
  10358b:	90                   	nop
  10358c:	5d                   	pop    %ebp
  10358d:	c3                   	ret    

0010358e <snprintf>:
 * @str:        the buffer to place the result into
 * @size:        the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  10358e:	55                   	push   %ebp
  10358f:	89 e5                	mov    %esp,%ebp
  103591:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  103594:	8d 45 14             	lea    0x14(%ebp),%eax
  103597:	89 45 f0             	mov    %eax,-0x10(%ebp)
    cnt = vsnprintf(str, size, fmt, ap);
  10359a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10359d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1035a1:	8b 45 10             	mov    0x10(%ebp),%eax
  1035a4:	89 44 24 08          	mov    %eax,0x8(%esp)
  1035a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1035af:	8b 45 08             	mov    0x8(%ebp),%eax
  1035b2:	89 04 24             	mov    %eax,(%esp)
  1035b5:	e8 08 00 00 00       	call   1035c2 <vsnprintf>
  1035ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  1035bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1035c0:	c9                   	leave  
  1035c1:	c3                   	ret    

001035c2 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  1035c2:	55                   	push   %ebp
  1035c3:	89 e5                	mov    %esp,%ebp
  1035c5:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  1035c8:	8b 45 08             	mov    0x8(%ebp),%eax
  1035cb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1035ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  1035d1:	8d 50 ff             	lea    -0x1(%eax),%edx
  1035d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1035d7:	01 d0                	add    %edx,%eax
  1035d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1035dc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  1035e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  1035e7:	74 0a                	je     1035f3 <vsnprintf+0x31>
  1035e9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1035ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035ef:	39 c2                	cmp    %eax,%edx
  1035f1:	76 07                	jbe    1035fa <vsnprintf+0x38>
        return -E_INVAL;
  1035f3:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  1035f8:	eb 2a                	jmp    103624 <vsnprintf+0x62>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  1035fa:	8b 45 14             	mov    0x14(%ebp),%eax
  1035fd:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103601:	8b 45 10             	mov    0x10(%ebp),%eax
  103604:	89 44 24 08          	mov    %eax,0x8(%esp)
  103608:	8d 45 ec             	lea    -0x14(%ebp),%eax
  10360b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10360f:	c7 04 24 58 35 10 00 	movl   $0x103558,(%esp)
  103616:	e8 64 fb ff ff       	call   10317f <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  10361b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10361e:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  103621:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103624:	c9                   	leave  
  103625:	c3                   	ret    
