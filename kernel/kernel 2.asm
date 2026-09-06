
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00008117          	auipc	sp,0x8
    80000004:	9f010113          	addi	sp,sp,-1552 # 800079f0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	042000ef          	jal	80000058 <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000001c:	1141                	addi	sp,sp,-16
    8000001e:	e406                	sd	ra,8(sp)
    80000020:	e022                	sd	s0,0(sp)
    80000022:	0800                	addi	s0,sp,16
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    80000024:	30a027f3          	csrr	a5,0x30a
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | MENVCFG_STCE);
    80000028:	577d                	li	a4,-1
    8000002a:	177e                	slli	a4,a4,0x3f
    8000002c:	8fd9                	or	a5,a5,a4

static inline void
w_menvcfg(uint64 x)
{
  // asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    8000002e:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r"(x));
    80000032:	306027f3          	csrr	a5,mcounteren

  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80000036:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r"(x));
    8000003a:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r"(x));
    8000003e:	c01027f3          	rdtime	a5

  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80000042:	000f4737          	lui	a4,0xf4
    80000046:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000004a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000004c:	14d79073          	csrw	stimecmp,a5
}
    80000050:	60a2                	ld	ra,8(sp)
    80000052:	6402                	ld	s0,0(sp)
    80000054:	0141                	addi	sp,sp,16
    80000056:	8082                	ret

0000000080000058 <start>:
{
    80000058:	1141                	addi	sp,sp,-16
    8000005a:	e406                	sd	ra,8(sp)
    8000005c:	e022                	sd	s0,0(sp)
    8000005e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r"(x));
    80000060:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80000064:	7779                	lui	a4,0xffffe
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd907>
    8000006a:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000006c:	6705                	lui	a4,0x1
    8000006e:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80000072:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r"(x));
    80000074:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r"(x));
    80000078:	00001797          	auipc	a5,0x1
    8000007c:	e0878793          	addi	a5,a5,-504 # 80000e80 <main>
    80000080:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r"(x));
    80000084:	4781                	li	a5,0
    80000086:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r"(x));
    8000008a:	67c1                	lui	a5,0x10
    8000008c:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000008e:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r"(x));
    80000092:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r"(x));
    80000096:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000009a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r"(x));
    8000009e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r"(x));
    800000a2:	57fd                	li	a5,-1
    800000a4:	83a9                	srli	a5,a5,0xa
    800000a6:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r"(x));
    800000aa:	47bd                	li	a5,15
    800000ac:	3a079073          	csrw	pmpcfg0,a5
  asm volatile("csrr %0, 0x30a" : "=r"(x));
    800000b0:	30a027f3          	csrr	a5,0x30a
  w_menvcfg(r_menvcfg() | MENVCFG_ADUE);
    800000b4:	4705                	li	a4,1
    800000b6:	1776                	slli	a4,a4,0x3d
    800000b8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r"(x));
    800000ba:	30a79073          	csrw	0x30a,a5
  timerinit();
    800000be:	f5fff0ef          	jal	8000001c <timerinit>
  asm volatile("csrr %0, mhartid" : "=r"(x));
    800000c2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800000c6:	2781                	sext.w	a5,a5
}

static inline void
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r"(x));
    800000c8:	823e                	mv	tp,a5
  asm volatile("mret");
    800000ca:	30200073          	mret
}
    800000ce:	60a2                	ld	ra,8(sp)
    800000d0:	6402                	ld	s0,0(sp)
    800000d2:	0141                	addi	sp,sp,16
    800000d4:	8082                	ret

00000000800000d6 <consolewrite>:
// user write() system calls to the console go here.
// uses sleep() and UART interrupts.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800000d6:	7119                	addi	sp,sp,-128
    800000d8:	fc86                	sd	ra,120(sp)
    800000da:	f8a2                	sd	s0,112(sp)
    800000dc:	f4a6                	sd	s1,104(sp)
    800000de:	0100                	addi	s0,sp,128
  char buf[32]; // move batches from user space to uart.
  int i = 0;

  while (i < n) {
    800000e0:	06c05b63          	blez	a2,80000156 <consolewrite+0x80>
    800000e4:	f0ca                	sd	s2,96(sp)
    800000e6:	ecce                	sd	s3,88(sp)
    800000e8:	e8d2                	sd	s4,80(sp)
    800000ea:	e4d6                	sd	s5,72(sp)
    800000ec:	e0da                	sd	s6,64(sp)
    800000ee:	fc5e                	sd	s7,56(sp)
    800000f0:	f862                	sd	s8,48(sp)
    800000f2:	f466                	sd	s9,40(sp)
    800000f4:	f06a                	sd	s10,32(sp)
    800000f6:	8b2a                	mv	s6,a0
    800000f8:	8bae                	mv	s7,a1
    800000fa:	8a32                	mv	s4,a2
  int i = 0;
    800000fc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if (nn > n - i)
    800000fe:	02000c93          	li	s9,32
    80000102:	02000d13          	li	s10,32
      nn = n - i;
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000106:	f8040a93          	addi	s5,s0,-128
    8000010a:	5c7d                	li	s8,-1
    8000010c:	a025                	j	80000134 <consolewrite+0x5e>
    if (nn > n - i)
    8000010e:	0009099b          	sext.w	s3,s2
    if (either_copyin(buf, user_src, src + i, nn) == -1)
    80000112:	86ce                	mv	a3,s3
    80000114:	01748633          	add	a2,s1,s7
    80000118:	85da                	mv	a1,s6
    8000011a:	8556                	mv	a0,s5
    8000011c:	15a020ef          	jal	80002276 <either_copyin>
    80000120:	03850d63          	beq	a0,s8,8000015a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80000124:	85ce                	mv	a1,s3
    80000126:	8556                	mv	a0,s5
    80000128:	7c8000ef          	jal	800008f0 <uartwrite>
    i += nn;
    8000012c:	009904bb          	addw	s1,s2,s1
  while (i < n) {
    80000130:	0144d963          	bge	s1,s4,80000142 <consolewrite+0x6c>
    if (nn > n - i)
    80000134:	409a07bb          	subw	a5,s4,s1
    80000138:	893e                	mv	s2,a5
    8000013a:	fcfcdae3          	bge	s9,a5,8000010e <consolewrite+0x38>
    8000013e:	896a                	mv	s2,s10
    80000140:	b7f9                	j	8000010e <consolewrite+0x38>
    80000142:	7906                	ld	s2,96(sp)
    80000144:	69e6                	ld	s3,88(sp)
    80000146:	6a46                	ld	s4,80(sp)
    80000148:	6aa6                	ld	s5,72(sp)
    8000014a:	6b06                	ld	s6,64(sp)
    8000014c:	7be2                	ld	s7,56(sp)
    8000014e:	7c42                	ld	s8,48(sp)
    80000150:	7ca2                	ld	s9,40(sp)
    80000152:	7d02                	ld	s10,32(sp)
    80000154:	a821                	j	8000016c <consolewrite+0x96>
  int i = 0;
    80000156:	4481                	li	s1,0
    80000158:	a811                	j	8000016c <consolewrite+0x96>
    8000015a:	7906                	ld	s2,96(sp)
    8000015c:	69e6                	ld	s3,88(sp)
    8000015e:	6a46                	ld	s4,80(sp)
    80000160:	6aa6                	ld	s5,72(sp)
    80000162:	6b06                	ld	s6,64(sp)
    80000164:	7be2                	ld	s7,56(sp)
    80000166:	7c42                	ld	s8,48(sp)
    80000168:	7ca2                	ld	s9,40(sp)
    8000016a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000016c:	8526                	mv	a0,s1
    8000016e:	70e6                	ld	ra,120(sp)
    80000170:	7446                	ld	s0,112(sp)
    80000172:	74a6                	ld	s1,104(sp)
    80000174:	6109                	addi	sp,sp,128
    80000176:	8082                	ret

0000000080000178 <consoleread>:
// user_dst indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80000178:	711d                	addi	sp,sp,-96
    8000017a:	ec86                	sd	ra,88(sp)
    8000017c:	e8a2                	sd	s0,80(sp)
    8000017e:	e4a6                	sd	s1,72(sp)
    80000180:	e0ca                	sd	s2,64(sp)
    80000182:	fc4e                	sd	s3,56(sp)
    80000184:	f852                	sd	s4,48(sp)
    80000186:	f05a                	sd	s6,32(sp)
    80000188:	ec5e                	sd	s7,24(sp)
    8000018a:	1080                	addi	s0,sp,96
    8000018c:	8b2a                	mv	s6,a0
    8000018e:	8a2e                	mv	s4,a1
    80000190:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80000192:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80000194:	00010517          	auipc	a0,0x10
    80000198:	85c50513          	addi	a0,a0,-1956 # 8000f9f0 <cons>
    8000019c:	27d000ef          	jal	80000c18 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00010497          	auipc	s1,0x10
    800001a4:	85048493          	addi	s1,s1,-1968 # 8000f9f0 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a8:	00010917          	auipc	s2,0x10
    800001ac:	8e090913          	addi	s2,s2,-1824 # 8000fa88 <cons+0x98>
  while (n > 0) {
    800001b0:	0b305b63          	blez	s3,80000266 <consoleread+0xee>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71063          	bne	a4,a5,8000025c <consoleread+0xe4>
      if (killed(myproc())) {
    800001c0:	71a010ef          	jal	800018da <myproc>
    800001c4:	74d010ef          	jal	80002110 <killed>
    800001c8:	e12d                	bnez	a0,8000022a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001ca:	85a6                	mv	a1,s1
    800001cc:	854a                	mv	a0,s2
    800001ce:	507010ef          	jal	80001ed4 <sleep>
    while (cons.r == cons.w) {
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fef703e3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001de:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e0:	00010717          	auipc	a4,0x10
    800001e4:	81070713          	addi	a4,a4,-2032 # 8000f9f0 <cons>
    800001e8:	0017869b          	addiw	a3,a5,1
    800001ec:	08d72c23          	sw	a3,152(a4)
    800001f0:	07f7f693          	andi	a3,a5,127
    800001f4:	9736                	add	a4,a4,a3
    800001f6:	01874703          	lbu	a4,24(a4)
    800001fa:	00070a9b          	sext.w	s5,a4

    if (c == C('D')) { // end-of-file
    800001fe:	4691                	li	a3,4
    80000200:	04da8663          	beq	s5,a3,8000024c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80000204:	fae407a3          	sb	a4,-81(s0)
    if (either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80000208:	4685                	li	a3,1
    8000020a:	faf40613          	addi	a2,s0,-81
    8000020e:	85d2                	mv	a1,s4
    80000210:	855a                	mv	a0,s6
    80000212:	01a020ef          	jal	8000222c <either_copyout>
    80000216:	57fd                	li	a5,-1
    80000218:	04f50663          	beq	a0,a5,80000264 <consoleread+0xec>
      break;

    dst++;
    8000021c:	0a05                	addi	s4,s4,1
    --n;
    8000021e:	39fd                	addiw	s3,s3,-1

    if (c == '\n') {
    80000220:	47a9                	li	a5,10
    80000222:	04fa8b63          	beq	s5,a5,80000278 <consoleread+0x100>
    80000226:	7aa2                	ld	s5,40(sp)
    80000228:	b761                	j	800001b0 <consoleread+0x38>
        release(&cons.lock);
    8000022a:	0000f517          	auipc	a0,0xf
    8000022e:	7c650513          	addi	a0,a0,1990 # 8000f9f0 <cons>
    80000232:	26b000ef          	jal	80000c9c <release>
        return -1;
    80000236:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80000238:	60e6                	ld	ra,88(sp)
    8000023a:	6446                	ld	s0,80(sp)
    8000023c:	64a6                	ld	s1,72(sp)
    8000023e:	6906                	ld	s2,64(sp)
    80000240:	79e2                	ld	s3,56(sp)
    80000242:	7a42                	ld	s4,48(sp)
    80000244:	7b02                	ld	s6,32(sp)
    80000246:	6be2                	ld	s7,24(sp)
    80000248:	6125                	addi	sp,sp,96
    8000024a:	8082                	ret
      if (n < target) {
    8000024c:	0179fa63          	bgeu	s3,s7,80000260 <consoleread+0xe8>
        cons.r--;
    80000250:	00010717          	auipc	a4,0x10
    80000254:	82f72c23          	sw	a5,-1992(a4) # 8000fa88 <cons+0x98>
    80000258:	7aa2                	ld	s5,40(sp)
    8000025a:	a031                	j	80000266 <consoleread+0xee>
    8000025c:	f456                	sd	s5,40(sp)
    8000025e:	b749                	j	800001e0 <consoleread+0x68>
    80000260:	7aa2                	ld	s5,40(sp)
    80000262:	a011                	j	80000266 <consoleread+0xee>
    80000264:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000266:	0000f517          	auipc	a0,0xf
    8000026a:	78a50513          	addi	a0,a0,1930 # 8000f9f0 <cons>
    8000026e:	22f000ef          	jal	80000c9c <release>
  return target - n;
    80000272:	413b853b          	subw	a0,s7,s3
    80000276:	b7c9                	j	80000238 <consoleread+0xc0>
    80000278:	7aa2                	ld	s5,40(sp)
    8000027a:	b7f5                	j	80000266 <consoleread+0xee>

000000008000027c <consputc>:
{
    8000027c:	1141                	addi	sp,sp,-16
    8000027e:	e406                	sd	ra,8(sp)
    80000280:	e022                	sd	s0,0(sp)
    80000282:	0800                	addi	s0,sp,16
  if (c == BACKSPACE) {
    80000284:	10000793          	li	a5,256
    80000288:	00f50863          	beq	a0,a5,80000298 <consputc+0x1c>
    uartputc_sync(c);
    8000028c:	6f8000ef          	jal	80000984 <uartputc_sync>
}
    80000290:	60a2                	ld	ra,8(sp)
    80000292:	6402                	ld	s0,0(sp)
    80000294:	0141                	addi	sp,sp,16
    80000296:	8082                	ret
    uartputc_sync('\b');
    80000298:	4521                	li	a0,8
    8000029a:	6ea000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync(' ');
    8000029e:	02000513          	li	a0,32
    800002a2:	6e2000ef          	jal	80000984 <uartputc_sync>
    uartputc_sync('\b');
    800002a6:	4521                	li	a0,8
    800002a8:	6dc000ef          	jal	80000984 <uartputc_sync>
    800002ac:	b7d5                	j	80000290 <consputc+0x14>

00000000800002ae <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800002ae:	1101                	addi	sp,sp,-32
    800002b0:	ec06                	sd	ra,24(sp)
    800002b2:	e822                	sd	s0,16(sp)
    800002b4:	e426                	sd	s1,8(sp)
    800002b6:	1000                	addi	s0,sp,32
    800002b8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800002ba:	0000f517          	auipc	a0,0xf
    800002be:	73650513          	addi	a0,a0,1846 # 8000f9f0 <cons>
    800002c2:	157000ef          	jal	80000c18 <acquire>

  switch (c) {
    800002c6:	47d5                	li	a5,21
    800002c8:	0af48163          	beq	s1,a5,8000036a <consoleintr+0xbc>
    800002cc:	0297c563          	blt	a5,s1,800002f6 <consoleintr+0x48>
    800002d0:	47a1                	li	a5,8
    800002d2:	0ef48663          	beq	s1,a5,800003be <consoleintr+0x110>
    800002d6:	47c1                	li	a5,16
    800002d8:	10f49763          	bne	s1,a5,800003e6 <consoleintr+0x138>
  case C('P'): // Print process list.
    procdump();
    800002dc:	7e5010ef          	jal	800022c0 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002e0:	0000f517          	auipc	a0,0xf
    800002e4:	71050513          	addi	a0,a0,1808 # 8000f9f0 <cons>
    800002e8:	1b5000ef          	jal	80000c9c <release>
}
    800002ec:	60e2                	ld	ra,24(sp)
    800002ee:	6442                	ld	s0,16(sp)
    800002f0:	64a2                	ld	s1,8(sp)
    800002f2:	6105                	addi	sp,sp,32
    800002f4:	8082                	ret
  switch (c) {
    800002f6:	07f00793          	li	a5,127
    800002fa:	0cf48263          	beq	s1,a5,800003be <consoleintr+0x110>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800002fe:	0000f717          	auipc	a4,0xf
    80000302:	6f270713          	addi	a4,a4,1778 # 8000f9f0 <cons>
    80000306:	0a072783          	lw	a5,160(a4)
    8000030a:	09872703          	lw	a4,152(a4)
    8000030e:	9f99                	subw	a5,a5,a4
    80000310:	07f00713          	li	a4,127
    80000314:	fcf766e3          	bltu	a4,a5,800002e0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80000318:	47b5                	li	a5,13
    8000031a:	0cf48963          	beq	s1,a5,800003ec <consoleintr+0x13e>
      consputc(c);
    8000031e:	8526                	mv	a0,s1
    80000320:	f5dff0ef          	jal	8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80000324:	0000f717          	auipc	a4,0xf
    80000328:	6cc70713          	addi	a4,a4,1740 # 8000f9f0 <cons>
    8000032c:	0a072683          	lw	a3,160(a4)
    80000330:	0016879b          	addiw	a5,a3,1
    80000334:	863e                	mv	a2,a5
    80000336:	0af72023          	sw	a5,160(a4)
    8000033a:	07f6f693          	andi	a3,a3,127
    8000033e:	9736                	add	a4,a4,a3
    80000340:	00970c23          	sb	s1,24(a4)
      if (c == '\n' || c == C('D') || cons.e - cons.r == INPUT_BUF_SIZE) {
    80000344:	ff648713          	addi	a4,s1,-10
    80000348:	00173713          	seqz	a4,a4
    8000034c:	14f1                	addi	s1,s1,-4
    8000034e:	0014b493          	seqz	s1,s1
    80000352:	8f45                	or	a4,a4,s1
    80000354:	e361                	bnez	a4,80000414 <consoleintr+0x166>
    80000356:	0000f717          	auipc	a4,0xf
    8000035a:	73272703          	lw	a4,1842(a4) # 8000fa88 <cons+0x98>
    8000035e:	9f99                	subw	a5,a5,a4
    80000360:	08000713          	li	a4,128
    80000364:	f6e79ee3          	bne	a5,a4,800002e0 <consoleintr+0x32>
    80000368:	a075                	j	80000414 <consoleintr+0x166>
    8000036a:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000036c:	0000f717          	auipc	a4,0xf
    80000370:	68470713          	addi	a4,a4,1668 # 8000f9f0 <cons>
    80000374:	0a072783          	lw	a5,160(a4)
    80000378:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000037c:	0000f497          	auipc	s1,0xf
    80000380:	67448493          	addi	s1,s1,1652 # 8000f9f0 <cons>
    while (cons.e != cons.w &&
    80000384:	4929                	li	s2,10
    80000386:	02f70863          	beq	a4,a5,800003b6 <consoleintr+0x108>
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000038a:	37fd                	addiw	a5,a5,-1
    8000038c:	07f7f713          	andi	a4,a5,127
    80000390:	9726                	add	a4,a4,s1
    while (cons.e != cons.w &&
    80000392:	01874703          	lbu	a4,24(a4)
    80000396:	03270263          	beq	a4,s2,800003ba <consoleintr+0x10c>
      cons.e--;
    8000039a:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    8000039e:	10000513          	li	a0,256
    800003a2:	edbff0ef          	jal	8000027c <consputc>
    while (cons.e != cons.w &&
    800003a6:	0a04a783          	lw	a5,160(s1)
    800003aa:	09c4a703          	lw	a4,156(s1)
    800003ae:	fcf71ee3          	bne	a4,a5,8000038a <consoleintr+0xdc>
    800003b2:	6902                	ld	s2,0(sp)
    800003b4:	b735                	j	800002e0 <consoleintr+0x32>
    800003b6:	6902                	ld	s2,0(sp)
    800003b8:	b725                	j	800002e0 <consoleintr+0x32>
    800003ba:	6902                	ld	s2,0(sp)
    800003bc:	b715                	j	800002e0 <consoleintr+0x32>
    if (cons.e != cons.w) {
    800003be:	0000f717          	auipc	a4,0xf
    800003c2:	63270713          	addi	a4,a4,1586 # 8000f9f0 <cons>
    800003c6:	0a072783          	lw	a5,160(a4)
    800003ca:	09c72703          	lw	a4,156(a4)
    800003ce:	f0f709e3          	beq	a4,a5,800002e0 <consoleintr+0x32>
      cons.e--;
    800003d2:	37fd                	addiw	a5,a5,-1
    800003d4:	0000f717          	auipc	a4,0xf
    800003d8:	6af72e23          	sw	a5,1724(a4) # 8000fa90 <cons+0xa0>
      consputc(BACKSPACE);
    800003dc:	10000513          	li	a0,256
    800003e0:	e9dff0ef          	jal	8000027c <consputc>
    800003e4:	bdf5                	j	800002e0 <consoleintr+0x32>
    if (c != 0 && cons.e - cons.r < INPUT_BUF_SIZE) {
    800003e6:	ee048de3          	beqz	s1,800002e0 <consoleintr+0x32>
    800003ea:	bf11                	j	800002fe <consoleintr+0x50>
      consputc(c);
    800003ec:	4529                	li	a0,10
    800003ee:	e8fff0ef          	jal	8000027c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800003f2:	0000f797          	auipc	a5,0xf
    800003f6:	5fe78793          	addi	a5,a5,1534 # 8000f9f0 <cons>
    800003fa:	0a07a703          	lw	a4,160(a5)
    800003fe:	0017069b          	addiw	a3,a4,1
    80000402:	8636                	mv	a2,a3
    80000404:	0ad7a023          	sw	a3,160(a5)
    80000408:	07f77713          	andi	a4,a4,127
    8000040c:	97ba                	add	a5,a5,a4
    8000040e:	4729                	li	a4,10
    80000410:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80000414:	0000f797          	auipc	a5,0xf
    80000418:	66c7ac23          	sw	a2,1656(a5) # 8000fa8c <cons+0x9c>
        wakeup(&cons.r);
    8000041c:	0000f517          	auipc	a0,0xf
    80000420:	66c50513          	addi	a0,a0,1644 # 8000fa88 <cons+0x98>
    80000424:	2fd010ef          	jal	80001f20 <wakeup>
    80000428:	bd65                	j	800002e0 <consoleintr+0x32>

000000008000042a <consoleinit>:

void
consoleinit(void)
{
    8000042a:	1141                	addi	sp,sp,-16
    8000042c:	e406                	sd	ra,8(sp)
    8000042e:	e022                	sd	s0,0(sp)
    80000430:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80000432:	00007597          	auipc	a1,0x7
    80000436:	bce58593          	addi	a1,a1,-1074 # 80007000 <etext>
    8000043a:	0000f517          	auipc	a0,0xf
    8000043e:	5b650513          	addi	a0,a0,1462 # 8000f9f0 <cons>
    80000442:	756000ef          	jal	80000b98 <initlock>

  uartinit();
    80000446:	454000ef          	jal	8000089a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000044a:	00020797          	auipc	a5,0x20
    8000044e:	91678793          	addi	a5,a5,-1770 # 8001fd60 <devsw>
    80000452:	00000717          	auipc	a4,0x0
    80000456:	d2670713          	addi	a4,a4,-730 # 80000178 <consoleread>
    8000045a:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000045c:	00000717          	auipc	a4,0x0
    80000460:	c7a70713          	addi	a4,a4,-902 # 800000d6 <consolewrite>
    80000464:	ef98                	sd	a4,24(a5)
}
    80000466:	60a2                	ld	ra,8(sp)
    80000468:	6402                	ld	s0,0(sp)
    8000046a:	0141                	addi	sp,sp,16
    8000046c:	8082                	ret

000000008000046e <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000046e:	7139                	addi	sp,sp,-64
    80000470:	fc06                	sd	ra,56(sp)
    80000472:	f822                	sd	s0,48(sp)
    80000474:	f04a                	sd	s2,32(sp)
    80000476:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if (sign && (sign = (xx < 0)))
    80000478:	c219                	beqz	a2,8000047e <printint+0x10>
    8000047a:	08054063          	bltz	a0,800004fa <printint+0x8c>
    x = -xx;
  else
    x = xx;
    8000047e:	4301                	li	t1,0

  i = 0;
    80000480:	fc840913          	addi	s2,s0,-56
    x = xx;
    80000484:	86ca                	mv	a3,s2
  i = 0;
    80000486:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80000488:	00007817          	auipc	a6,0x7
    8000048c:	34880813          	addi	a6,a6,840 # 800077d0 <digits>
    80000490:	88ba                	mv	a7,a4
    80000492:	0017061b          	addiw	a2,a4,1
    80000496:	8732                	mv	a4,a2
    80000498:	02b577b3          	remu	a5,a0,a1
    8000049c:	97c2                	add	a5,a5,a6
    8000049e:	0007c783          	lbu	a5,0(a5)
    800004a2:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    800004a6:	87aa                	mv	a5,a0
    800004a8:	02b55533          	divu	a0,a0,a1
    800004ac:	0685                	addi	a3,a3,1
    800004ae:	feb7f1e3          	bgeu	a5,a1,80000490 <printint+0x22>

  if (sign)
    800004b2:	00030b63          	beqz	t1,800004c8 <printint+0x5a>
    buf[i++] = '-';
    800004b6:	fe040793          	addi	a5,s0,-32
    800004ba:	963e                	add	a2,a2,a5
    800004bc:	02d00793          	li	a5,45
    800004c0:	fef60423          	sb	a5,-24(a2)
    800004c4:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    800004c8:	02e05463          	blez	a4,800004f0 <printint+0x82>
    800004cc:	f426                	sd	s1,40(sp)
    800004ce:	377d                	addiw	a4,a4,-1
    800004d0:	00e904b3          	add	s1,s2,a4
    800004d4:	197d                	addi	s2,s2,-1
    800004d6:	993a                	add	s2,s2,a4
    800004d8:	1702                	slli	a4,a4,0x20
    800004da:	9301                	srli	a4,a4,0x20
    800004dc:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800004e0:	0004c503          	lbu	a0,0(s1)
    800004e4:	d99ff0ef          	jal	8000027c <consputc>
  while (--i >= 0)
    800004e8:	14fd                	addi	s1,s1,-1
    800004ea:	ff249be3          	bne	s1,s2,800004e0 <printint+0x72>
    800004ee:	74a2                	ld	s1,40(sp)
}
    800004f0:	70e2                	ld	ra,56(sp)
    800004f2:	7442                	ld	s0,48(sp)
    800004f4:	7902                	ld	s2,32(sp)
    800004f6:	6121                	addi	sp,sp,64
    800004f8:	8082                	ret
    x = -xx;
    800004fa:	40a00533          	neg	a0,a0
  if (sign && (sign = (xx < 0)))
    800004fe:	4305                	li	t1,1
    x = -xx;
    80000500:	b741                	j	80000480 <printint+0x12>

0000000080000502 <printk>:
}

// Print to the console.
int
printk(char *fmt, ...)
{
    80000502:	7131                	addi	sp,sp,-192
    80000504:	fc86                	sd	ra,120(sp)
    80000506:	f8a2                	sd	s0,112(sp)
    80000508:	f4a6                	sd	s1,104(sp)
    8000050a:	0100                	addi	s0,sp,128
    8000050c:	84aa                	mv	s1,a0
    8000050e:	e40c                	sd	a1,8(s0)
    80000510:	e810                	sd	a2,16(s0)
    80000512:	ec14                	sd	a3,24(s0)
    80000514:	f018                	sd	a4,32(s0)
    80000516:	f41c                	sd	a5,40(s0)
    80000518:	03043823          	sd	a6,48(s0)
    8000051c:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if (panicking == 0)
    80000520:	00007797          	auipc	a5,0x7
    80000524:	4a47a783          	lw	a5,1188(a5) # 800079c4 <panicking>
    80000528:	cf9d                	beqz	a5,80000566 <printk+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    8000052a:	00840793          	addi	a5,s0,8
    8000052e:	f8f43423          	sd	a5,-120(s0)
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000532:	0004c503          	lbu	a0,0(s1)
    80000536:	22050363          	beqz	a0,8000075c <printk+0x25a>
    8000053a:	f0ca                	sd	s2,96(sp)
    8000053c:	ecce                	sd	s3,88(sp)
    8000053e:	e8d2                	sd	s4,80(sp)
    80000540:	e4d6                	sd	s5,72(sp)
    80000542:	e0da                	sd	s6,64(sp)
    80000544:	fc5e                	sd	s7,56(sp)
    80000546:	f862                	sd	s8,48(sp)
    80000548:	f06a                	sd	s10,32(sp)
    8000054a:	ec6e                	sd	s11,24(sp)
    8000054c:	4a01                	li	s4,0
    if (cx != '%') {
    8000054e:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if (c0 == 'u') {
    80000552:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if (c0 == 'x') {
    80000556:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if (c0 == 'p') {
    8000055a:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000055e:	4b29                	li	s6,10
    if (c0 == 'd') {
    80000560:	06400b93          	li	s7,100
    80000564:	a015                	j	80000588 <printk+0x86>
    acquire(&pr.lock);
    80000566:	0000f517          	auipc	a0,0xf
    8000056a:	53250513          	addi	a0,a0,1330 # 8000fa98 <pr>
    8000056e:	6aa000ef          	jal	80000c18 <acquire>
    80000572:	bf65                	j	8000052a <printk+0x28>
      consputc(cx);
    80000574:	d09ff0ef          	jal	8000027c <consputc>
  for (i = 0; (cx = fmt[i] & 0xff) != 0; i++) {
    80000578:	001a079b          	addiw	a5,s4,1
    8000057c:	8a3e                	mv	s4,a5
    8000057e:	97a6                	add	a5,a5,s1
    80000580:	0007c503          	lbu	a0,0(a5)
    80000584:	1c050363          	beqz	a0,8000074a <printk+0x248>
    if (cx != '%') {
    80000588:	ff3516e3          	bne	a0,s3,80000574 <printk+0x72>
    i++;
    8000058c:	001a091b          	addiw	s2,s4,1
    c0 = fmt[i + 0] & 0xff;
    80000590:	012487b3          	add	a5,s1,s2
    80000594:	0007ca83          	lbu	s5,0(a5)
    if (c0)
    80000598:	200a8763          	beqz	s5,800007a6 <printk+0x2a4>
      c1 = fmt[i + 1] & 0xff;
    8000059c:	0017c703          	lbu	a4,1(a5)
    if (c1)
    800005a0:	1e070a63          	beqz	a4,80000794 <printk+0x292>
    if (c0 == 'd') {
    800005a4:	037a8963          	beq	s5,s7,800005d6 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    800005a8:	f94a8793          	addi	a5,s5,-108
    800005ac:	0017b793          	seqz	a5,a5
    800005b0:	f9c70693          	addi	a3,a4,-100
    800005b4:	0016b693          	seqz	a3,a3
    800005b8:	8efd                	and	a3,a3,a5
    800005ba:	ca9d                	beqz	a3,800005f0 <printk+0xee>
      printint(va_arg(ap, uint64), 10, 1);
    800005bc:	f8843783          	ld	a5,-120(s0)
    800005c0:	00878713          	addi	a4,a5,8
    800005c4:	f8e43423          	sd	a4,-120(s0)
    800005c8:	4605                	li	a2,1
    800005ca:	85da                	mv	a1,s6
    800005cc:	6388                	ld	a0,0(a5)
    800005ce:	ea1ff0ef          	jal	8000046e <printint>
      i += 1;
    800005d2:	2a09                	addiw	s4,s4,2
    800005d4:	b755                	j	80000578 <printk+0x76>
      printint(va_arg(ap, int), 10, 1);
    800005d6:	f8843783          	ld	a5,-120(s0)
    800005da:	00878713          	addi	a4,a5,8
    800005de:	f8e43423          	sd	a4,-120(s0)
    800005e2:	4605                	li	a2,1
    800005e4:	85da                	mv	a1,s6
    800005e6:	4388                	lw	a0,0(a5)
    800005e8:	e87ff0ef          	jal	8000046e <printint>
    i++;
    800005ec:	8a4a                	mv	s4,s2
    800005ee:	b769                	j	80000578 <printk+0x76>
      c2 = fmt[i + 2] & 0xff;
    800005f0:	012486b3          	add	a3,s1,s2
    800005f4:	863a                	mv	a2,a4
    800005f6:	0026c703          	lbu	a4,2(a3)
    800005fa:	aa65                	j	800007b2 <printk+0x2b0>
      printint(va_arg(ap, uint64), 10, 1);
    800005fc:	f8843783          	ld	a5,-120(s0)
    80000600:	00878713          	addi	a4,a5,8
    80000604:	f8e43423          	sd	a4,-120(s0)
    80000608:	4605                	li	a2,1
    8000060a:	45a9                	li	a1,10
    8000060c:	6388                	ld	a0,0(a5)
    8000060e:	e61ff0ef          	jal	8000046e <printint>
      i += 2;
    80000612:	2a0d                	addiw	s4,s4,3
    80000614:	b795                	j	80000578 <printk+0x76>
      printint(va_arg(ap, uint32), 10, 0);
    80000616:	f8843783          	ld	a5,-120(s0)
    8000061a:	00878713          	addi	a4,a5,8
    8000061e:	f8e43423          	sd	a4,-120(s0)
    80000622:	4601                	li	a2,0
    80000624:	85da                	mv	a1,s6
    80000626:	0007e503          	lwu	a0,0(a5)
    8000062a:	e45ff0ef          	jal	8000046e <printint>
    8000062e:	bf7d                	j	800005ec <printk+0xea>
      printint(va_arg(ap, uint64), 10, 0);
    80000630:	f8843783          	ld	a5,-120(s0)
    80000634:	00878713          	addi	a4,a5,8
    80000638:	f8e43423          	sd	a4,-120(s0)
    8000063c:	4601                	li	a2,0
    8000063e:	85da                	mv	a1,s6
    80000640:	6388                	ld	a0,0(a5)
    80000642:	e2dff0ef          	jal	8000046e <printint>
      i += 1;
    80000646:	2a09                	addiw	s4,s4,2
    80000648:	bf05                	j	80000578 <printk+0x76>
      printint(va_arg(ap, uint64), 10, 0);
    8000064a:	f8843783          	ld	a5,-120(s0)
    8000064e:	00878713          	addi	a4,a5,8
    80000652:	f8e43423          	sd	a4,-120(s0)
    80000656:	4601                	li	a2,0
    80000658:	45a9                	li	a1,10
    8000065a:	6388                	ld	a0,0(a5)
    8000065c:	e13ff0ef          	jal	8000046e <printint>
      i += 2;
    80000660:	2a0d                	addiw	s4,s4,3
    80000662:	bf19                	j	80000578 <printk+0x76>
      printint(va_arg(ap, uint32), 16, 0);
    80000664:	f8843783          	ld	a5,-120(s0)
    80000668:	00878713          	addi	a4,a5,8
    8000066c:	f8e43423          	sd	a4,-120(s0)
    80000670:	4601                	li	a2,0
    80000672:	45c1                	li	a1,16
    80000674:	0007e503          	lwu	a0,0(a5)
    80000678:	df7ff0ef          	jal	8000046e <printint>
    8000067c:	bf85                	j	800005ec <printk+0xea>
      printint(va_arg(ap, uint64), 16, 0);
    8000067e:	f8843783          	ld	a5,-120(s0)
    80000682:	00878713          	addi	a4,a5,8
    80000686:	f8e43423          	sd	a4,-120(s0)
    8000068a:	4601                	li	a2,0
    8000068c:	45c1                	li	a1,16
    8000068e:	6388                	ld	a0,0(a5)
    80000690:	ddfff0ef          	jal	8000046e <printint>
      i += 1;
    80000694:	2a09                	addiw	s4,s4,2
    80000696:	b5cd                	j	80000578 <printk+0x76>
      printint(va_arg(ap, uint64), 16, 0);
    80000698:	f8843783          	ld	a5,-120(s0)
    8000069c:	00878713          	addi	a4,a5,8
    800006a0:	f8e43423          	sd	a4,-120(s0)
    800006a4:	45c1                	li	a1,16
    800006a6:	6388                	ld	a0,0(a5)
    800006a8:	dc7ff0ef          	jal	8000046e <printint>
      i += 2;
    800006ac:	2a0d                	addiw	s4,s4,3
    800006ae:	b5e9                	j	80000578 <printk+0x76>
    800006b0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800006b2:	f8843783          	ld	a5,-120(s0)
    800006b6:	00878713          	addi	a4,a5,8
    800006ba:	f8e43423          	sd	a4,-120(s0)
    800006be:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800006c2:	03000513          	li	a0,48
    800006c6:	bb7ff0ef          	jal	8000027c <consputc>
  consputc('x');
    800006ca:	07800513          	li	a0,120
    800006ce:	bafff0ef          	jal	8000027c <consputc>
    800006d2:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800006d4:	00007c97          	auipc	s9,0x7
    800006d8:	0fcc8c93          	addi	s9,s9,252 # 800077d0 <digits>
    800006dc:	03cad793          	srli	a5,s5,0x3c
    800006e0:	97e6                	add	a5,a5,s9
    800006e2:	0007c503          	lbu	a0,0(a5)
    800006e6:	b97ff0ef          	jal	8000027c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800006ea:	0a92                	slli	s5,s5,0x4
    800006ec:	3a7d                	addiw	s4,s4,-1
    800006ee:	fe0a17e3          	bnez	s4,800006dc <printk+0x1da>
    800006f2:	7ca2                	ld	s9,40(sp)
    800006f4:	bde5                	j	800005ec <printk+0xea>
    } else if (c0 == 'c') {
      consputc(va_arg(ap, uint));
    800006f6:	f8843783          	ld	a5,-120(s0)
    800006fa:	00878713          	addi	a4,a5,8
    800006fe:	f8e43423          	sd	a4,-120(s0)
    80000702:	4388                	lw	a0,0(a5)
    80000704:	b79ff0ef          	jal	8000027c <consputc>
    80000708:	b5d5                	j	800005ec <printk+0xea>
    } else if (c0 == 's') {
      if ((s = va_arg(ap, char *)) == 0)
    8000070a:	f8843783          	ld	a5,-120(s0)
    8000070e:	00878713          	addi	a4,a5,8
    80000712:	f8e43423          	sd	a4,-120(s0)
    80000716:	0007ba03          	ld	s4,0(a5)
    8000071a:	000a0d63          	beqz	s4,80000734 <printk+0x232>
        s = "(null)";
      for (; *s; s++)
    8000071e:	000a4503          	lbu	a0,0(s4)
    80000722:	ec0505e3          	beqz	a0,800005ec <printk+0xea>
        consputc(*s);
    80000726:	b57ff0ef          	jal	8000027c <consputc>
      for (; *s; s++)
    8000072a:	0a05                	addi	s4,s4,1
    8000072c:	000a4503          	lbu	a0,0(s4)
    80000730:	f97d                	bnez	a0,80000726 <printk+0x224>
    80000732:	bd6d                	j	800005ec <printk+0xea>
        s = "(null)";
    80000734:	00007a17          	auipc	s4,0x7
    80000738:	8d4a0a13          	addi	s4,s4,-1836 # 80007008 <etext+0x8>
      for (; *s; s++)
    8000073c:	02800513          	li	a0,40
    80000740:	b7dd                	j	80000726 <printk+0x224>
    } else if (c0 == '%') {
      consputc('%');
    80000742:	8556                	mv	a0,s5
    80000744:	b39ff0ef          	jal	8000027c <consputc>
    80000748:	b555                	j	800005ec <printk+0xea>
    8000074a:	7906                	ld	s2,96(sp)
    8000074c:	69e6                	ld	s3,88(sp)
    8000074e:	6a46                	ld	s4,80(sp)
    80000750:	6aa6                	ld	s5,72(sp)
    80000752:	6b06                	ld	s6,64(sp)
    80000754:	7be2                	ld	s7,56(sp)
    80000756:	7c42                	ld	s8,48(sp)
    80000758:	7d02                	ld	s10,32(sp)
    8000075a:	6de2                	ld	s11,24(sp)
      consputc(c0);
    }
  }
  va_end(ap);

  if (panicking == 0)
    8000075c:	00007797          	auipc	a5,0x7
    80000760:	2687a783          	lw	a5,616(a5) # 800079c4 <panicking>
    80000764:	c38d                	beqz	a5,80000786 <printk+0x284>
    release(&pr.lock);

  return 0;
}
    80000766:	4501                	li	a0,0
    80000768:	70e6                	ld	ra,120(sp)
    8000076a:	7446                	ld	s0,112(sp)
    8000076c:	74a6                	ld	s1,104(sp)
    8000076e:	6129                	addi	sp,sp,192
    80000770:	8082                	ret
    80000772:	7906                	ld	s2,96(sp)
    80000774:	69e6                	ld	s3,88(sp)
    80000776:	6a46                	ld	s4,80(sp)
    80000778:	6aa6                	ld	s5,72(sp)
    8000077a:	6b06                	ld	s6,64(sp)
    8000077c:	7be2                	ld	s7,56(sp)
    8000077e:	7c42                	ld	s8,48(sp)
    80000780:	7d02                	ld	s10,32(sp)
    80000782:	6de2                	ld	s11,24(sp)
    80000784:	bfe1                	j	8000075c <printk+0x25a>
    release(&pr.lock);
    80000786:	0000f517          	auipc	a0,0xf
    8000078a:	31250513          	addi	a0,a0,786 # 8000fa98 <pr>
    8000078e:	50e000ef          	jal	80000c9c <release>
  return 0;
    80000792:	bfd1                	j	80000766 <printk+0x264>
    if (c0 == 'd') {
    80000794:	e57a81e3          	beq	s5,s7,800005d6 <printk+0xd4>
    } else if (c0 == 'l' && c1 == 'd') {
    80000798:	f94a8793          	addi	a5,s5,-108
    8000079c:	0017b793          	seqz	a5,a5
    800007a0:	863a                	mv	a2,a4
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007a2:	4681                	li	a3,0
    800007a4:	a01d                	j	800007ca <printk+0x2c8>
    } else if (c0 == 'l' && c1 == 'd') {
    800007a6:	f94a8793          	addi	a5,s5,-108
    800007aa:	0017b793          	seqz	a5,a5
    c1 = c2 = 0;
    800007ae:	8656                	mv	a2,s5
    800007b0:	8756                	mv	a4,s5
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    800007b2:	f9460693          	addi	a3,a2,-108
    800007b6:	0016b693          	seqz	a3,a3
    800007ba:	8efd                	and	a3,a3,a5
    800007bc:	f9c70593          	addi	a1,a4,-100
    800007c0:	0015b593          	seqz	a1,a1
    800007c4:	8df5                	and	a1,a1,a3
    800007c6:	e2059be3          	bnez	a1,800005fc <printk+0xfa>
    } else if (c0 == 'u') {
    800007ca:	e58a86e3          	beq	s5,s8,80000616 <printk+0x114>
    } else if (c0 == 'l' && c1 == 'u') {
    800007ce:	f8b60593          	addi	a1,a2,-117
    800007d2:	0015b593          	seqz	a1,a1
    800007d6:	8dfd                	and	a1,a1,a5
    800007d8:	e4059ce3          	bnez	a1,80000630 <printk+0x12e>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    800007dc:	f8b70593          	addi	a1,a4,-117
    800007e0:	0015b593          	seqz	a1,a1
    800007e4:	8df5                	and	a1,a1,a3
    800007e6:	e60592e3          	bnez	a1,8000064a <printk+0x148>
    } else if (c0 == 'x') {
    800007ea:	e7aa8de3          	beq	s5,s10,80000664 <printk+0x162>
    } else if (c0 == 'l' && c1 == 'x') {
    800007ee:	f8860613          	addi	a2,a2,-120
    800007f2:	00163613          	seqz	a2,a2
    800007f6:	8e7d                	and	a2,a2,a5
    800007f8:	e80613e3          	bnez	a2,8000067e <printk+0x17c>
    } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    800007fc:	f8870713          	addi	a4,a4,-120
    80000800:	00173713          	seqz	a4,a4
    80000804:	8f75                	and	a4,a4,a3
    80000806:	e80719e3          	bnez	a4,80000698 <printk+0x196>
    } else if (c0 == 'p') {
    8000080a:	ebba83e3          	beq	s5,s11,800006b0 <printk+0x1ae>
    } else if (c0 == 'c') {
    8000080e:	06300793          	li	a5,99
    80000812:	eefa82e3          	beq	s5,a5,800006f6 <printk+0x1f4>
    } else if (c0 == 's') {
    80000816:	07300793          	li	a5,115
    8000081a:	eefa88e3          	beq	s5,a5,8000070a <printk+0x208>
    } else if (c0 == '%') {
    8000081e:	02500793          	li	a5,37
    80000822:	f2fa80e3          	beq	s5,a5,80000742 <printk+0x240>
    } else if (c0 == 0) {
    80000826:	f40a86e3          	beqz	s5,80000772 <printk+0x270>
      consputc('%');
    8000082a:	02500513          	li	a0,37
    8000082e:	a4fff0ef          	jal	8000027c <consputc>
      consputc(c0);
    80000832:	8556                	mv	a0,s5
    80000834:	a49ff0ef          	jal	8000027c <consputc>
    80000838:	bb55                	j	800005ec <printk+0xea>

000000008000083a <panic>:

void
panic(char *s)
{
    8000083a:	1101                	addi	sp,sp,-32
    8000083c:	ec06                	sd	ra,24(sp)
    8000083e:	e822                	sd	s0,16(sp)
    80000840:	e426                	sd	s1,8(sp)
    80000842:	e04a                	sd	s2,0(sp)
    80000844:	1000                	addi	s0,sp,32
    80000846:	892a                	mv	s2,a0
  panicking = 1;
    80000848:	4485                	li	s1,1
    8000084a:	00007797          	auipc	a5,0x7
    8000084e:	1697ad23          	sw	s1,378(a5) # 800079c4 <panicking>
  printk("panic: ");
    80000852:	00006517          	auipc	a0,0x6
    80000856:	7c650513          	addi	a0,a0,1990 # 80007018 <etext+0x18>
    8000085a:	ca9ff0ef          	jal	80000502 <printk>
  printk("%s\n", s);
    8000085e:	85ca                	mv	a1,s2
    80000860:	00006517          	auipc	a0,0x6
    80000864:	7c050513          	addi	a0,a0,1984 # 80007020 <etext+0x20>
    80000868:	c9bff0ef          	jal	80000502 <printk>
  panicked = 1; // freeze uart output from other CPUs
    8000086c:	00007797          	auipc	a5,0x7
    80000870:	1497aa23          	sw	s1,340(a5) # 800079c0 <panicked>
  for (;;)
    80000874:	a001                	j	80000874 <panic+0x3a>

0000000080000876 <printkinit>:
    ;
}

void
printkinit(void)
{
    80000876:	1141                	addi	sp,sp,-16
    80000878:	e406                	sd	ra,8(sp)
    8000087a:	e022                	sd	s0,0(sp)
    8000087c:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000087e:	00006597          	auipc	a1,0x6
    80000882:	7aa58593          	addi	a1,a1,1962 # 80007028 <etext+0x28>
    80000886:	0000f517          	auipc	a0,0xf
    8000088a:	21250513          	addi	a0,a0,530 # 8000fa98 <pr>
    8000088e:	30a000ef          	jal	80000b98 <initlock>
}
    80000892:	60a2                	ld	ra,8(sp)
    80000894:	6402                	ld	s0,0(sp)
    80000896:	0141                	addi	sp,sp,16
    80000898:	8082                	ret

000000008000089a <uartinit>:
extern volatile int panicking; // from printk.c
extern volatile int panicked;  // from printk.c

void
uartinit(void)
{
    8000089a:	1141                	addi	sp,sp,-16
    8000089c:	e406                	sd	ra,8(sp)
    8000089e:	e022                	sd	s0,0(sp)
    800008a0:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800008a2:	100007b7          	lui	a5,0x10000
    800008a6:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800008aa:	10000737          	lui	a4,0x10000
    800008ae:	f8000693          	li	a3,-128
    800008b2:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800008b6:	468d                	li	a3,3
    800008b8:	10000637          	lui	a2,0x10000
    800008bc:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800008c0:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800008c4:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800008c8:	8732                	mv	a4,a2
    800008ca:	461d                	li	a2,7
    800008cc:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800008d0:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800008d4:	00006597          	auipc	a1,0x6
    800008d8:	75c58593          	addi	a1,a1,1884 # 80007030 <etext+0x30>
    800008dc:	0000f517          	auipc	a0,0xf
    800008e0:	1d450513          	addi	a0,a0,468 # 8000fab0 <tx_lock>
    800008e4:	2b4000ef          	jal	80000b98 <initlock>
}
    800008e8:	60a2                	ld	ra,8(sp)
    800008ea:	6402                	ld	s0,0(sp)
    800008ec:	0141                	addi	sp,sp,16
    800008ee:	8082                	ret

00000000800008f0 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800008f0:	715d                	addi	sp,sp,-80
    800008f2:	e486                	sd	ra,72(sp)
    800008f4:	e0a2                	sd	s0,64(sp)
    800008f6:	fc26                	sd	s1,56(sp)
    800008f8:	ec56                	sd	s5,24(sp)
    800008fa:	0880                	addi	s0,sp,80
    800008fc:	8aaa                	mv	s5,a0
    800008fe:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80000900:	0000f517          	auipc	a0,0xf
    80000904:	1b050513          	addi	a0,a0,432 # 8000fab0 <tx_lock>
    80000908:	310000ef          	jal	80000c18 <acquire>

  int i = 0;
  while (i < n) {
    8000090c:	06905063          	blez	s1,8000096c <uartwrite+0x7c>
    80000910:	f84a                	sd	s2,48(sp)
    80000912:	f44e                	sd	s3,40(sp)
    80000914:	f052                	sd	s4,32(sp)
    80000916:	e85a                	sd	s6,16(sp)
    80000918:	e45e                	sd	s7,8(sp)
    8000091a:	8a56                	mv	s4,s5
    8000091c:	9aa6                	add	s5,s5,s1
    while (tx_busy != 0) {
    8000091e:	00007497          	auipc	s1,0x7
    80000922:	0ae48493          	addi	s1,s1,174 # 800079cc <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000926:	0000f997          	auipc	s3,0xf
    8000092a:	18a98993          	addi	s3,s3,394 # 8000fab0 <tx_lock>
    8000092e:	00007917          	auipc	s2,0x7
    80000932:	09a90913          	addi	s2,s2,154 # 800079c8 <tx_chan>
    }

    WriteReg(THR, buf[i]);
    80000936:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    8000093a:	4b05                	li	s6,1
    8000093c:	a005                	j	8000095c <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000093e:	85ce                	mv	a1,s3
    80000940:	854a                	mv	a0,s2
    80000942:	592010ef          	jal	80001ed4 <sleep>
    while (tx_busy != 0) {
    80000946:	409c                	lw	a5,0(s1)
    80000948:	fbfd                	bnez	a5,8000093e <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    8000094a:	000a4783          	lbu	a5,0(s4)
    8000094e:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80000952:	0164a023          	sw	s6,0(s1)
  while (i < n) {
    80000956:	0a05                	addi	s4,s4,1
    80000958:	015a0563          	beq	s4,s5,80000962 <uartwrite+0x72>
    while (tx_busy != 0) {
    8000095c:	409c                	lw	a5,0(s1)
    8000095e:	f3e5                	bnez	a5,8000093e <uartwrite+0x4e>
    80000960:	b7ed                	j	8000094a <uartwrite+0x5a>
    80000962:	7942                	ld	s2,48(sp)
    80000964:	79a2                	ld	s3,40(sp)
    80000966:	7a02                	ld	s4,32(sp)
    80000968:	6b42                	ld	s6,16(sp)
    8000096a:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    8000096c:	0000f517          	auipc	a0,0xf
    80000970:	14450513          	addi	a0,a0,324 # 8000fab0 <tx_lock>
    80000974:	328000ef          	jal	80000c9c <release>
}
    80000978:	60a6                	ld	ra,72(sp)
    8000097a:	6406                	ld	s0,64(sp)
    8000097c:	74e2                	ld	s1,56(sp)
    8000097e:	6ae2                	ld	s5,24(sp)
    80000980:	6161                	addi	sp,sp,80
    80000982:	8082                	ret

0000000080000984 <uartputc_sync>:
// interrupts, for use by kernel printk() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80000984:	1101                	addi	sp,sp,-32
    80000986:	ec06                	sd	ra,24(sp)
    80000988:	e822                	sd	s0,16(sp)
    8000098a:	e426                	sd	s1,8(sp)
    8000098c:	1000                	addi	s0,sp,32
    8000098e:	84aa                	mv	s1,a0
  if (panicking == 0)
    80000990:	00007797          	auipc	a5,0x7
    80000994:	0347a783          	lw	a5,52(a5) # 800079c4 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	00007797          	auipc	a5,0x7
    8000099e:	0267a783          	lw	a5,38(a5) # 800079c0 <panicked>
    for (;;)
      ;
  }

  // wait for UART to set Transmit Holding Empty in LSR.
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009a2:	10000737          	lui	a4,0x10000
    800009a6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
  if (panicked) {
    800009a8:	c789                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    for (;;)
    800009aa:	a001                	j	800009aa <uartputc_sync+0x26>
    push_off();
    800009ac:	232000ef          	jal	80000bde <push_off>
    800009b0:	b7ed                	j	8000099a <uartputc_sync+0x16>
  while ((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800009b2:	00074783          	lbu	a5,0(a4)
    800009b6:	0207f793          	andi	a5,a5,32
    800009ba:	dfe5                	beqz	a5,800009b2 <uartputc_sync+0x2e>
    ;
  WriteReg(THR, c);
    800009bc:	100007b7          	lui	a5,0x10000
    800009c0:	00978023          	sb	s1,0(a5) # 10000000 <_entry-0x70000000>

  if (panicking == 0)
    800009c4:	00007797          	auipc	a5,0x7
    800009c8:	0007a783          	lw	a5,0(a5) # 800079c4 <panicking>
    800009cc:	c791                	beqz	a5,800009d8 <uartputc_sync+0x54>
    pop_off();
}
    800009ce:	60e2                	ld	ra,24(sp)
    800009d0:	6442                	ld	s0,16(sp)
    800009d2:	64a2                	ld	s1,8(sp)
    800009d4:	6105                	addi	sp,sp,32
    800009d6:	8082                	ret
    pop_off();
    800009d8:	27c000ef          	jal	80000c54 <pop_off>
}
    800009dc:	bfcd                	j	800009ce <uartputc_sync+0x4a>

00000000800009de <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800009de:	1101                	addi	sp,sp,-32
    800009e0:	ec06                	sd	ra,24(sp)
    800009e2:	e822                	sd	s0,16(sp)
    800009e4:	e426                	sd	s1,8(sp)
    800009e6:	e04a                	sd	s2,0(sp)
    800009e8:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800009ea:	100007b7          	lui	a5,0x10000
    800009ee:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800009f2:	0000f517          	auipc	a0,0xf
    800009f6:	0be50513          	addi	a0,a0,190 # 8000fab0 <tx_lock>
    800009fa:	21e000ef          	jal	80000c18 <acquire>
  if (ReadReg(LSR) & LSR_TX_IDLE) {
    800009fe:	100007b7          	lui	a5,0x10000
    80000a02:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80000a06:	0207f793          	andi	a5,a5,32
    80000a0a:	e78d                	bnez	a5,80000a34 <uartintr+0x56>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80000a0c:	0000f517          	auipc	a0,0xf
    80000a10:	0a450513          	addi	a0,a0,164 # 8000fab0 <tx_lock>
    80000a14:	288000ef          	jal	80000c9c <release>
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a18:	100004b7          	lui	s1,0x10000
    80000a1c:	0495                	addi	s1,s1,5 # 10000005 <_entry-0x6ffffffb>
    return ReadReg(RHR);
    80000a1e:	10000937          	lui	s2,0x10000
  if (ReadReg(LSR) & LSR_RX_READY) {
    80000a22:	0004c783          	lbu	a5,0(s1)
    80000a26:	8b85                	andi	a5,a5,1
    80000a28:	c38d                	beqz	a5,80000a4a <uartintr+0x6c>
  // read and process incoming characters, if any.
  while (1) {
    int c = uartgetc();
    if (c == -1)
      break;
    consoleintr(c);
    80000a2a:	00094503          	lbu	a0,0(s2) # 10000000 <_entry-0x70000000>
    80000a2e:	881ff0ef          	jal	800002ae <consoleintr>
  while (1) {
    80000a32:	bfc5                	j	80000a22 <uartintr+0x44>
    tx_busy = 0;
    80000a34:	00007797          	auipc	a5,0x7
    80000a38:	f807ac23          	sw	zero,-104(a5) # 800079cc <tx_busy>
    wakeup(&tx_chan);
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	f8c50513          	addi	a0,a0,-116 # 800079c8 <tx_chan>
    80000a44:	4dc010ef          	jal	80001f20 <wakeup>
    80000a48:	b7d1                	j	80000a0c <uartintr+0x2e>
  }
}
    80000a4a:	60e2                	ld	ra,24(sp)
    80000a4c:	6442                	ld	s0,16(sp)
    80000a4e:	64a2                	ld	s1,8(sp)
    80000a50:	6902                	ld	s2,0(sp)
    80000a52:	6105                	addi	sp,sp,32
    80000a54:	8082                	ret

0000000080000a56 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    80000a56:	1101                	addi	sp,sp,-32
    80000a58:	ec06                	sd	ra,24(sp)
    80000a5a:	e822                	sd	s0,16(sp)
    80000a5c:	e426                	sd	s1,8(sp)
    80000a5e:	e04a                	sd	s2,0(sp)
    80000a60:	1000                	addi	s0,sp,32
  struct run *r;

  if (((uint64)pa % PGSIZE) != 0 || (char *)pa < end || (uint64)pa >= PHYSTOP)
    80000a62:	00020797          	auipc	a5,0x20
    80000a66:	49678793          	addi	a5,a5,1174 # 80020ef8 <end>
    80000a6a:	00f53733          	sltu	a4,a0,a5
    80000a6e:	47c5                	li	a5,17
    80000a70:	07ee                	slli	a5,a5,0x1b
    80000a72:	17fd                	addi	a5,a5,-1
    80000a74:	00a7b7b3          	sltu	a5,a5,a0
    80000a78:	8fd9                	or	a5,a5,a4
    80000a7a:	03451713          	slli	a4,a0,0x34
    80000a7e:	8fd9                	or	a5,a5,a4
    80000a80:	eb9d                	bnez	a5,80000ab6 <kfree+0x60>
    80000a82:	84aa                	mv	s1,a0
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000a84:	6605                	lui	a2,0x1
    80000a86:	4585                	li	a1,1
    80000a88:	24c000ef          	jal	80000cd4 <memset>

  r = (struct run *)pa;

  acquire(&kmem.lock);
    80000a8c:	0000f917          	auipc	s2,0xf
    80000a90:	03c90913          	addi	s2,s2,60 # 8000fac8 <kmem>
    80000a94:	854a                	mv	a0,s2
    80000a96:	182000ef          	jal	80000c18 <acquire>
  r->next = kmem.freelist;
    80000a9a:	01893783          	ld	a5,24(s2)
    80000a9e:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000aa0:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000aa4:	854a                	mv	a0,s2
    80000aa6:	1f6000ef          	jal	80000c9c <release>
}
    80000aaa:	60e2                	ld	ra,24(sp)
    80000aac:	6442                	ld	s0,16(sp)
    80000aae:	64a2                	ld	s1,8(sp)
    80000ab0:	6902                	ld	s2,0(sp)
    80000ab2:	6105                	addi	sp,sp,32
    80000ab4:	8082                	ret
    panic("kfree");
    80000ab6:	00006517          	auipc	a0,0x6
    80000aba:	58250513          	addi	a0,a0,1410 # 80007038 <etext+0x38>
    80000abe:	d7dff0ef          	jal	8000083a <panic>

0000000080000ac2 <freerange>:
{
    80000ac2:	7179                	addi	sp,sp,-48
    80000ac4:	f406                	sd	ra,40(sp)
    80000ac6:	f022                	sd	s0,32(sp)
    80000ac8:	ec26                	sd	s1,24(sp)
    80000aca:	1800                	addi	s0,sp,48
  p = (char *)PGROUNDUP((uint64)pa_start);
    80000acc:	6785                	lui	a5,0x1
    80000ace:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000ad2:	00e504b3          	add	s1,a0,a4
    80000ad6:	777d                	lui	a4,0xfffff
    80000ad8:	8cf9                	and	s1,s1,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000ada:	94be                	add	s1,s1,a5
    80000adc:	0295e263          	bltu	a1,s1,80000b00 <freerange+0x3e>
    80000ae0:	e84a                	sd	s2,16(sp)
    80000ae2:	e44e                	sd	s3,8(sp)
    80000ae4:	e052                	sd	s4,0(sp)
    80000ae6:	892e                	mv	s2,a1
    kfree(p);
    80000ae8:	8a3a                	mv	s4,a4
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000aea:	89be                	mv	s3,a5
    kfree(p);
    80000aec:	01448533          	add	a0,s1,s4
    80000af0:	f67ff0ef          	jal	80000a56 <kfree>
  for (; p + PGSIZE <= (char *)pa_end; p += PGSIZE)
    80000af4:	94ce                	add	s1,s1,s3
    80000af6:	fe997be3          	bgeu	s2,s1,80000aec <freerange+0x2a>
    80000afa:	6942                	ld	s2,16(sp)
    80000afc:	69a2                	ld	s3,8(sp)
    80000afe:	6a02                	ld	s4,0(sp)
}
    80000b00:	70a2                	ld	ra,40(sp)
    80000b02:	7402                	ld	s0,32(sp)
    80000b04:	64e2                	ld	s1,24(sp)
    80000b06:	6145                	addi	sp,sp,48
    80000b08:	8082                	ret

0000000080000b0a <kinit>:
{
    80000b0a:	1141                	addi	sp,sp,-16
    80000b0c:	e406                	sd	ra,8(sp)
    80000b0e:	e022                	sd	s0,0(sp)
    80000b10:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    80000b12:	00006597          	auipc	a1,0x6
    80000b16:	52e58593          	addi	a1,a1,1326 # 80007040 <etext+0x40>
    80000b1a:	0000f517          	auipc	a0,0xf
    80000b1e:	fae50513          	addi	a0,a0,-82 # 8000fac8 <kmem>
    80000b22:	076000ef          	jal	80000b98 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b26:	45c5                	li	a1,17
    80000b28:	05ee                	slli	a1,a1,0x1b
    80000b2a:	00020517          	auipc	a0,0x20
    80000b2e:	3ce50513          	addi	a0,a0,974 # 80020ef8 <end>
    80000b32:	f91ff0ef          	jal	80000ac2 <freerange>
}
    80000b36:	60a2                	ld	ra,8(sp)
    80000b38:	6402                	ld	s0,0(sp)
    80000b3a:	0141                	addi	sp,sp,16
    80000b3c:	8082                	ret

0000000080000b3e <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000b3e:	1101                	addi	sp,sp,-32
    80000b40:	ec06                	sd	ra,24(sp)
    80000b42:	e822                	sd	s0,16(sp)
    80000b44:	e426                	sd	s1,8(sp)
    80000b46:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000b48:	0000f517          	auipc	a0,0xf
    80000b4c:	f8050513          	addi	a0,a0,-128 # 8000fac8 <kmem>
    80000b50:	0c8000ef          	jal	80000c18 <acquire>
  r = kmem.freelist;
    80000b54:	0000f497          	auipc	s1,0xf
    80000b58:	f8c4b483          	ld	s1,-116(s1) # 8000fae0 <kmem+0x18>
  if (r)
    80000b5c:	c49d                	beqz	s1,80000b8a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b5e:	609c                	ld	a5,0(s1)
    80000b60:	0000f717          	auipc	a4,0xf
    80000b64:	f8f73023          	sd	a5,-128(a4) # 8000fae0 <kmem+0x18>
  release(&kmem.lock);
    80000b68:	0000f517          	auipc	a0,0xf
    80000b6c:	f6050513          	addi	a0,a0,-160 # 8000fac8 <kmem>
    80000b70:	12c000ef          	jal	80000c9c <release>

  if (r)
    memset((char *)r, 5, PGSIZE); // fill with junk
    80000b74:	6605                	lui	a2,0x1
    80000b76:	4595                	li	a1,5
    80000b78:	8526                	mv	a0,s1
    80000b7a:	15a000ef          	jal	80000cd4 <memset>
  return (void *)r;
}
    80000b7e:	8526                	mv	a0,s1
    80000b80:	60e2                	ld	ra,24(sp)
    80000b82:	6442                	ld	s0,16(sp)
    80000b84:	64a2                	ld	s1,8(sp)
    80000b86:	6105                	addi	sp,sp,32
    80000b88:	8082                	ret
  release(&kmem.lock);
    80000b8a:	0000f517          	auipc	a0,0xf
    80000b8e:	f3e50513          	addi	a0,a0,-194 # 8000fac8 <kmem>
    80000b92:	10a000ef          	jal	80000c9c <release>
  if (r)
    80000b96:	b7e5                	j	80000b7e <kalloc+0x40>

0000000080000b98 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80000b98:	1141                	addi	sp,sp,-16
    80000b9a:	e406                	sd	ra,8(sp)
    80000b9c:	e022                	sd	s0,0(sp)
    80000b9e:	0800                	addi	s0,sp,16
  lk->name = name;
    80000ba0:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80000ba2:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80000ba6:	00053823          	sd	zero,16(a0)
}
    80000baa:	60a2                	ld	ra,8(sp)
    80000bac:	6402                	ld	s0,0(sp)
    80000bae:	0141                	addi	sp,sp,16
    80000bb0:	8082                	ret

0000000080000bb2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80000bb2:	411c                	lw	a5,0(a0)
    80000bb4:	e399                	bnez	a5,80000bba <holding+0x8>
    80000bb6:	4501                	li	a0,0
  return r;
}
    80000bb8:	8082                	ret
{
    80000bba:	1101                	addi	sp,sp,-32
    80000bbc:	ec06                	sd	ra,24(sp)
    80000bbe:	e822                	sd	s0,16(sp)
    80000bc0:	e426                	sd	s1,8(sp)
    80000bc2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80000bc4:	691c                	ld	a5,16(a0)
    80000bc6:	84be                	mv	s1,a5
    80000bc8:	4f3000ef          	jal	800018ba <mycpu>
    80000bcc:	40a48533          	sub	a0,s1,a0
    80000bd0:	00153513          	seqz	a0,a0
}
    80000bd4:	60e2                	ld	ra,24(sp)
    80000bd6:	6442                	ld	s0,16(sp)
    80000bd8:	64a2                	ld	s1,8(sp)
    80000bda:	6105                	addi	sp,sp,32
    80000bdc:	8082                	ret

0000000080000bde <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80000bde:	1101                	addi	sp,sp,-32
    80000be0:	ec06                	sd	ra,24(sp)
    80000be2:	e822                	sd	s0,16(sp)
    80000be4:	e426                	sd	s1,8(sp)
    80000be6:	1000                	addi	s0,sp,32
  __asm__ __volatile__("csrrc %0, sstatus, %1" : "=r"(x) : "rK"(x) : "memory");
    80000be8:	100177f3          	csrrci	a5,sstatus,2
    80000bec:	84be                	mv	s1,a5
  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  uint64 flags = rc_sstatus(SSTATUS_SIE);
  int old = !!(flags & SSTATUS_SIE);

  if (mycpu()->noff == 0)
    80000bee:	4cd000ef          	jal	800018ba <mycpu>
    80000bf2:	5d3c                	lw	a5,120(a0)
    80000bf4:	cb99                	beqz	a5,80000c0a <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bf6:	4c5000ef          	jal	800018ba <mycpu>
    80000bfa:	5d3c                	lw	a5,120(a0)
    80000bfc:	2785                	addiw	a5,a5,1
    80000bfe:	dd3c                	sw	a5,120(a0)
}
    80000c00:	60e2                	ld	ra,24(sp)
    80000c02:	6442                	ld	s0,16(sp)
    80000c04:	64a2                	ld	s1,8(sp)
    80000c06:	6105                	addi	sp,sp,32
    80000c08:	8082                	ret
    mycpu()->intena = old;
    80000c0a:	4b1000ef          	jal	800018ba <mycpu>
  int old = !!(flags & SSTATUS_SIE);
    80000c0e:	0014d793          	srli	a5,s1,0x1
    80000c12:	8b85                	andi	a5,a5,1
    mycpu()->intena = old;
    80000c14:	dd7c                	sw	a5,124(a0)
    80000c16:	b7c5                	j	80000bf6 <push_off+0x18>

0000000080000c18 <acquire>:
{
    80000c18:	1101                	addi	sp,sp,-32
    80000c1a:	ec06                	sd	ra,24(sp)
    80000c1c:	e822                	sd	s0,16(sp)
    80000c1e:	e426                	sd	s1,8(sp)
    80000c20:	1000                	addi	s0,sp,32
    80000c22:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80000c24:	fbbff0ef          	jal	80000bde <push_off>
  if (holding(lk))
    80000c28:	8526                	mv	a0,s1
    80000c2a:	f89ff0ef          	jal	80000bb2 <holding>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c2e:	4705                	li	a4,1
  if (holding(lk))
    80000c30:	ed01                	bnez	a0,80000c48 <acquire+0x30>
  while (__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
    80000c32:	0ce4a7af          	amoswap.w.aq	a5,a4,(s1)
    80000c36:	fff5                	bnez	a5,80000c32 <acquire+0x1a>
  lk->cpu = mycpu();
    80000c38:	483000ef          	jal	800018ba <mycpu>
    80000c3c:	e888                	sd	a0,16(s1)
}
    80000c3e:	60e2                	ld	ra,24(sp)
    80000c40:	6442                	ld	s0,16(sp)
    80000c42:	64a2                	ld	s1,8(sp)
    80000c44:	6105                	addi	sp,sp,32
    80000c46:	8082                	ret
    panic("acquire");
    80000c48:	00006517          	auipc	a0,0x6
    80000c4c:	40050513          	addi	a0,a0,1024 # 80007048 <etext+0x48>
    80000c50:	bebff0ef          	jal	8000083a <panic>

0000000080000c54 <pop_off>:

void
pop_off(void)
{
    80000c54:	1141                	addi	sp,sp,-16
    80000c56:	e406                	sd	ra,8(sp)
    80000c58:	e022                	sd	s0,0(sp)
    80000c5a:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80000c5c:	45f000ef          	jal	800018ba <mycpu>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80000c60:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80000c64:	8b89                	andi	a5,a5,2
  if (intr_get())
    80000c66:	ef99                	bnez	a5,80000c84 <pop_off+0x30>
    panic("pop_off - interruptible");
  if (c->noff < 1)
    80000c68:	5d3c                	lw	a5,120(a0)
    80000c6a:	02f05363          	blez	a5,80000c90 <pop_off+0x3c>
    panic("pop_off");
  c->noff -= 1;
    80000c6e:	37fd                	addiw	a5,a5,-1
    80000c70:	dd3c                	sw	a5,120(a0)
  if (c->noff == 0 && c->intena)
    80000c72:	e789                	bnez	a5,80000c7c <pop_off+0x28>
    80000c74:	5d7c                	lw	a5,124(a0)
    80000c76:	c399                	beqz	a5,80000c7c <pop_off+0x28>
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80000c78:	10016073          	csrsi	sstatus,2
    intr_on();
}
    80000c7c:	60a2                	ld	ra,8(sp)
    80000c7e:	6402                	ld	s0,0(sp)
    80000c80:	0141                	addi	sp,sp,16
    80000c82:	8082                	ret
    panic("pop_off - interruptible");
    80000c84:	00006517          	auipc	a0,0x6
    80000c88:	3cc50513          	addi	a0,a0,972 # 80007050 <etext+0x50>
    80000c8c:	bafff0ef          	jal	8000083a <panic>
    panic("pop_off");
    80000c90:	00006517          	auipc	a0,0x6
    80000c94:	3d850513          	addi	a0,a0,984 # 80007068 <etext+0x68>
    80000c98:	ba3ff0ef          	jal	8000083a <panic>

0000000080000c9c <release>:
{
    80000c9c:	1101                	addi	sp,sp,-32
    80000c9e:	ec06                	sd	ra,24(sp)
    80000ca0:	e822                	sd	s0,16(sp)
    80000ca2:	e426                	sd	s1,8(sp)
    80000ca4:	1000                	addi	s0,sp,32
    80000ca6:	84aa                	mv	s1,a0
  if (!holding(lk))
    80000ca8:	f0bff0ef          	jal	80000bb2 <holding>
    80000cac:	cd11                	beqz	a0,80000cc8 <release+0x2c>
  lk->cpu = 0;
    80000cae:	0004b823          	sd	zero,16(s1)
  __atomic_store_n(&lk->locked, 0, __ATOMIC_RELEASE);
    80000cb2:	0310000f          	fence	rw,w
    80000cb6:	0004a023          	sw	zero,0(s1)
  pop_off();
    80000cba:	f9bff0ef          	jal	80000c54 <pop_off>
}
    80000cbe:	60e2                	ld	ra,24(sp)
    80000cc0:	6442                	ld	s0,16(sp)
    80000cc2:	64a2                	ld	s1,8(sp)
    80000cc4:	6105                	addi	sp,sp,32
    80000cc6:	8082                	ret
    panic("release");
    80000cc8:	00006517          	auipc	a0,0x6
    80000ccc:	3a850513          	addi	a0,a0,936 # 80007070 <etext+0x70>
    80000cd0:	b6bff0ef          	jal	8000083a <panic>

0000000080000cd4 <memset>:
#include "types.h"

void *
memset(void *dst, int c, uint n)
{
    80000cd4:	1141                	addi	sp,sp,-16
    80000cd6:	e406                	sd	ra,8(sp)
    80000cd8:	e022                	sd	s0,0(sp)
    80000cda:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    80000cdc:	ca19                	beqz	a2,80000cf2 <memset+0x1e>
    80000cde:	87aa                	mv	a5,a0
    80000ce0:	1602                	slli	a2,a2,0x20
    80000ce2:	9201                	srli	a2,a2,0x20
    80000ce4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000ce8:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    80000cec:	0785                	addi	a5,a5,1
    80000cee:	fee79de3          	bne	a5,a4,80000ce8 <memset+0x14>
  }
  return dst;
}
    80000cf2:	60a2                	ld	ra,8(sp)
    80000cf4:	6402                	ld	s0,0(sp)
    80000cf6:	0141                	addi	sp,sp,16
    80000cf8:	8082                	ret

0000000080000cfa <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000cfa:	1141                	addi	sp,sp,-16
    80000cfc:	e406                	sd	ra,8(sp)
    80000cfe:	e022                	sd	s0,0(sp)
    80000d00:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while (n-- > 0) {
    80000d02:	ce19                	beqz	a2,80000d20 <memcmp+0x26>
    80000d04:	1602                	slli	a2,a2,0x20
    80000d06:	9201                	srli	a2,a2,0x20
    80000d08:	00c506b3          	add	a3,a0,a2
    if (*s1 != *s2)
    80000d0c:	00054783          	lbu	a5,0(a0)
    80000d10:	0005c703          	lbu	a4,0(a1)
    80000d14:	00e79b63          	bne	a5,a4,80000d2a <memcmp+0x30>
      return *s1 - *s2;
    s1++, s2++;
    80000d18:	0505                	addi	a0,a0,1
    80000d1a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    80000d1c:	fed518e3          	bne	a0,a3,80000d0c <memcmp+0x12>
  }

  return 0;
    80000d20:	4501                	li	a0,0
}
    80000d22:	60a2                	ld	ra,8(sp)
    80000d24:	6402                	ld	s0,0(sp)
    80000d26:	0141                	addi	sp,sp,16
    80000d28:	8082                	ret
      return *s1 - *s2;
    80000d2a:	40e7853b          	subw	a0,a5,a4
    80000d2e:	bfd5                	j	80000d22 <memcmp+0x28>

0000000080000d30 <memmove>:

void *
memmove(void *dst, const void *src, uint n)
{
    80000d30:	1141                	addi	sp,sp,-16
    80000d32:	e406                	sd	ra,8(sp)
    80000d34:	e022                	sd	s0,0(sp)
    80000d36:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if (n == 0)
    80000d38:	c61d                	beqz	a2,80000d66 <memmove+0x36>
    return dst;

  s = src;
  d = dst;
  if (s < d && s + n > d) {
    80000d3a:	00a5f963          	bgeu	a1,a0,80000d4c <memmove+0x1c>
    80000d3e:	02061693          	slli	a3,a2,0x20
    80000d42:	9281                	srli	a3,a3,0x20
    80000d44:	00d58733          	add	a4,a1,a3
    80000d48:	02e56363          	bltu	a0,a4,80000d6e <memmove+0x3e>
    s += n;
    d += n;
    while (n-- > 0)
      *--d = *--s;
  } else
    while (n-- > 0)
    80000d4c:	1602                	slli	a2,a2,0x20
    80000d4e:	9201                	srli	a2,a2,0x20
    80000d50:	00c587b3          	add	a5,a1,a2
{
    80000d54:	872a                	mv	a4,a0
      *d++ = *s++;
    80000d56:	0585                	addi	a1,a1,1
    80000d58:	0705                	addi	a4,a4,1
    80000d5a:	fff5c683          	lbu	a3,-1(a1)
    80000d5e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    80000d62:	fef59ae3          	bne	a1,a5,80000d56 <memmove+0x26>

  return dst;
}
    80000d66:	60a2                	ld	ra,8(sp)
    80000d68:	6402                	ld	s0,0(sp)
    80000d6a:	0141                	addi	sp,sp,16
    80000d6c:	8082                	ret
    d += n;
    80000d6e:	96aa                	add	a3,a3,a0
    while (n-- > 0)
    80000d70:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000d74:	1782                	slli	a5,a5,0x20
    80000d76:	9381                	srli	a5,a5,0x20
    80000d78:	fff7c793          	not	a5,a5
    80000d7c:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000d7e:	177d                	addi	a4,a4,-1
    80000d80:	16fd                	addi	a3,a3,-1
    80000d82:	00074603          	lbu	a2,0(a4)
    80000d86:	00c68023          	sb	a2,0(a3)
    while (n-- > 0)
    80000d8a:	fee79ae3          	bne	a5,a4,80000d7e <memmove+0x4e>
    80000d8e:	bfe1                	j	80000d66 <memmove+0x36>

0000000080000d90 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void *
memcpy(void *dst, const void *src, uint n)
{
    80000d90:	1141                	addi	sp,sp,-16
    80000d92:	e406                	sd	ra,8(sp)
    80000d94:	e022                	sd	s0,0(sp)
    80000d96:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000d98:	f99ff0ef          	jal	80000d30 <memmove>
}
    80000d9c:	60a2                	ld	ra,8(sp)
    80000d9e:	6402                	ld	s0,0(sp)
    80000da0:	0141                	addi	sp,sp,16
    80000da2:	8082                	ret

0000000080000da4 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000da4:	1141                	addi	sp,sp,-16
    80000da6:	e406                	sd	ra,8(sp)
    80000da8:	e022                	sd	s0,0(sp)
    80000daa:	0800                	addi	s0,sp,16
  while (n > 0 && *p && *p == *q)
    80000dac:	ce01                	beqz	a2,80000dc4 <strncmp+0x20>
    80000dae:	00054783          	lbu	a5,0(a0)
    80000db2:	cb99                	beqz	a5,80000dc8 <strncmp+0x24>
    80000db4:	0005c703          	lbu	a4,0(a1)
    80000db8:	00f71863          	bne	a4,a5,80000dc8 <strncmp+0x24>
    n--, p++, q++;
    80000dbc:	367d                	addiw	a2,a2,-1
    80000dbe:	0505                	addi	a0,a0,1
    80000dc0:	0585                	addi	a1,a1,1
  while (n > 0 && *p && *p == *q)
    80000dc2:	f675                	bnez	a2,80000dae <strncmp+0xa>
  if (n == 0)
    return 0;
    80000dc4:	4501                	li	a0,0
    80000dc6:	a031                	j	80000dd2 <strncmp+0x2e>
  return (uchar)*p - (uchar)*q;
    80000dc8:	00054503          	lbu	a0,0(a0)
    80000dcc:	0005c783          	lbu	a5,0(a1)
    80000dd0:	9d1d                	subw	a0,a0,a5
}
    80000dd2:	60a2                	ld	ra,8(sp)
    80000dd4:	6402                	ld	s0,0(sp)
    80000dd6:	0141                	addi	sp,sp,16
    80000dd8:	8082                	ret

0000000080000dda <strncpy>:

char *
strncpy(char *s, const char *t, int n)
{
    80000dda:	1141                	addi	sp,sp,-16
    80000ddc:	e406                	sd	ra,8(sp)
    80000dde:	e022                	sd	s0,0(sp)
    80000de0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while (n-- > 0 && (*s++ = *t++) != 0)
    80000de2:	87aa                	mv	a5,a0
    80000de4:	a011                	j	80000de8 <strncpy+0xe>
    80000de6:	8636                	mv	a2,a3
    80000de8:	02c05763          	blez	a2,80000e16 <strncpy+0x3c>
    80000dec:	fff6069b          	addiw	a3,a2,-1
    80000df0:	0785                	addi	a5,a5,1
    80000df2:	0005c703          	lbu	a4,0(a1)
    80000df6:	fee78fa3          	sb	a4,-1(a5)
    80000dfa:	0585                	addi	a1,a1,1
    80000dfc:	f76d                	bnez	a4,80000de6 <strncpy+0xc>
    ;
  while (n-- > 0)
    80000dfe:	873e                	mv	a4,a5
    80000e00:	00d05b63          	blez	a3,80000e16 <strncpy+0x3c>
    80000e04:	9fb1                	addw	a5,a5,a2
    80000e06:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    80000e08:	0705                	addi	a4,a4,1
    80000e0a:	fe070fa3          	sb	zero,-1(a4)
  while (n-- > 0)
    80000e0e:	40e786bb          	subw	a3,a5,a4
    80000e12:	fed04be3          	bgtz	a3,80000e08 <strncpy+0x2e>
  return os;
}
    80000e16:	60a2                	ld	ra,8(sp)
    80000e18:	6402                	ld	s0,0(sp)
    80000e1a:	0141                	addi	sp,sp,16
    80000e1c:	8082                	ret

0000000080000e1e <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char *
safestrcpy(char *s, const char *t, int n)
{
    80000e1e:	1141                	addi	sp,sp,-16
    80000e20:	e406                	sd	ra,8(sp)
    80000e22:	e022                	sd	s0,0(sp)
    80000e24:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if (n <= 0)
    80000e26:	02c05363          	blez	a2,80000e4c <safestrcpy+0x2e>
    80000e2a:	fff6069b          	addiw	a3,a2,-1
    80000e2e:	1682                	slli	a3,a3,0x20
    80000e30:	9281                	srli	a3,a3,0x20
    80000e32:	96ae                	add	a3,a3,a1
    80000e34:	87aa                	mv	a5,a0
    return os;
  while (--n > 0 && (*s++ = *t++) != 0)
    80000e36:	00d58963          	beq	a1,a3,80000e48 <safestrcpy+0x2a>
    80000e3a:	0585                	addi	a1,a1,1
    80000e3c:	0785                	addi	a5,a5,1
    80000e3e:	fff5c703          	lbu	a4,-1(a1)
    80000e42:	fee78fa3          	sb	a4,-1(a5)
    80000e46:	fb65                	bnez	a4,80000e36 <safestrcpy+0x18>
    ;
  *s = 0;
    80000e48:	00078023          	sb	zero,0(a5)
  return os;
}
    80000e4c:	60a2                	ld	ra,8(sp)
    80000e4e:	6402                	ld	s0,0(sp)
    80000e50:	0141                	addi	sp,sp,16
    80000e52:	8082                	ret

0000000080000e54 <strlen>:

int
strlen(const char *s)
{
    80000e54:	1141                	addi	sp,sp,-16
    80000e56:	e406                	sd	ra,8(sp)
    80000e58:	e022                	sd	s0,0(sp)
    80000e5a:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    80000e5c:	00054783          	lbu	a5,0(a0)
    80000e60:	cf91                	beqz	a5,80000e7c <strlen+0x28>
    80000e62:	00150793          	addi	a5,a0,1
    80000e66:	86be                	mv	a3,a5
    80000e68:	0785                	addi	a5,a5,1
    80000e6a:	fff7c703          	lbu	a4,-1(a5)
    80000e6e:	ff65                	bnez	a4,80000e66 <strlen+0x12>
    80000e70:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000e74:	60a2                	ld	ra,8(sp)
    80000e76:	6402                	ld	s0,0(sp)
    80000e78:	0141                	addi	sp,sp,16
    80000e7a:	8082                	ret
  for (n = 0; s[n]; n++)
    80000e7c:	4501                	li	a0,0
    80000e7e:	bfdd                	j	80000e74 <strlen+0x20>

0000000080000e80 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000e80:	1141                	addi	sp,sp,-16
    80000e82:	e406                	sd	ra,8(sp)
    80000e84:	e022                	sd	s0,0(sp)
    80000e86:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80000e88:	21f000ef          	jal	800018a6 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();         // first user process
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    started = 1;
  } else {
    while (started == 0)
    80000e8c:	00007717          	auipc	a4,0x7
    80000e90:	b4470713          	addi	a4,a4,-1212 # 800079d0 <started>
  if (cpuid() == 0) {
    80000e94:	c515                	beqz	a0,80000ec0 <main+0x40>
    while (started == 0)
    80000e96:	431c                	lw	a5,0(a4)
    80000e98:	dffd                	beqz	a5,80000e96 <main+0x16>
      ;
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000e9a:	0330000f          	fence	rw,rw
    printk("hart %d starting\n", cpuid());
    80000e9e:	209000ef          	jal	800018a6 <cpuid>
    80000ea2:	85aa                	mv	a1,a0
    80000ea4:	00006517          	auipc	a0,0x6
    80000ea8:	1f450513          	addi	a0,a0,500 # 80007098 <etext+0x98>
    80000eac:	e56ff0ef          	jal	80000502 <printk>
    kvminithart();  // turn on paging
    80000eb0:	080000ef          	jal	80000f30 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000eb4:	53a010ef          	jal	800023ee <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000eb8:	5b0040ef          	jal	80005468 <plicinithart>
  }

  scheduler();
    80000ebc:	699000ef          	jal	80001d54 <scheduler>
    consoleinit();
    80000ec0:	d6aff0ef          	jal	8000042a <consoleinit>
    printkinit();
    80000ec4:	9b3ff0ef          	jal	80000876 <printkinit>
    printk("\n");
    80000ec8:	00006517          	auipc	a0,0x6
    80000ecc:	1b050513          	addi	a0,a0,432 # 80007078 <etext+0x78>
    80000ed0:	e32ff0ef          	jal	80000502 <printk>
    printk("xv6 kernel is booting\n");
    80000ed4:	00006517          	auipc	a0,0x6
    80000ed8:	1ac50513          	addi	a0,a0,428 # 80007080 <etext+0x80>
    80000edc:	e26ff0ef          	jal	80000502 <printk>
    printk("\n");
    80000ee0:	00006517          	auipc	a0,0x6
    80000ee4:	19850513          	addi	a0,a0,408 # 80007078 <etext+0x78>
    80000ee8:	e1aff0ef          	jal	80000502 <printk>
    kinit();            // physical page allocator
    80000eec:	c1fff0ef          	jal	80000b0a <kinit>
    kvminit();          // create kernel page table
    80000ef0:	2c0000ef          	jal	800011b0 <kvminit>
    kvminithart();      // turn on paging
    80000ef4:	03c000ef          	jal	80000f30 <kvminithart>
    procinit();         // process table
    80000ef8:	0f7000ef          	jal	800017ee <procinit>
    trapinit();         // trap vectors
    80000efc:	4ce010ef          	jal	800023ca <trapinit>
    trapinithart();     // install kernel trap vector
    80000f00:	4ee010ef          	jal	800023ee <trapinithart>
    plicinit();         // set up interrupt controller
    80000f04:	54a040ef          	jal	8000544e <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000f08:	560040ef          	jal	80005468 <plicinithart>
    binit();            // buffer cache
    80000f0c:	3fd010ef          	jal	80002b08 <binit>
    iinit();            // inode table
    80000f10:	156020ef          	jal	80003066 <iinit>
    fileinit();         // file table
    80000f14:	0e6030ef          	jal	80003ffa <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f18:	640040ef          	jal	80005558 <virtio_disk_init>
    userinit();         // first user process
    80000f1c:	48f000ef          	jal	80001baa <userinit>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000f20:	0330000f          	fence	rw,rw
    started = 1;
    80000f24:	4785                	li	a5,1
    80000f26:	00007717          	auipc	a4,0x7
    80000f2a:	aaf72523          	sw	a5,-1366(a4) # 800079d0 <started>
    80000f2e:	b779                	j	80000ebc <main+0x3c>

0000000080000f30 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f30:	1141                	addi	sp,sp,-16
    80000f32:	e406                	sd	ra,8(sp)
    80000f34:	e022                	sd	s0,0(sp)
    80000f36:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f38:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f3c:	00007797          	auipc	a5,0x7
    80000f40:	a9c7b783          	ld	a5,-1380(a5) # 800079d8 <kernel_pagetable>
    80000f44:	83b1                	srli	a5,a5,0xc
    80000f46:	577d                	li	a4,-1
    80000f48:	177e                	slli	a4,a4,0x3f
    80000f4a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f4c:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f50:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f54:	60a2                	ld	ra,8(sp)
    80000f56:	6402                	ld	s0,0(sp)
    80000f58:	0141                	addi	sp,sp,16
    80000f5a:	8082                	ret

0000000080000f5c <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f5c:	7139                	addi	sp,sp,-64
    80000f5e:	fc06                	sd	ra,56(sp)
    80000f60:	f822                	sd	s0,48(sp)
    80000f62:	f426                	sd	s1,40(sp)
    80000f64:	f04a                	sd	s2,32(sp)
    80000f66:	ec4e                	sd	s3,24(sp)
    80000f68:	e852                	sd	s4,16(sp)
    80000f6a:	e456                	sd	s5,8(sp)
    80000f6c:	e05a                	sd	s6,0(sp)
    80000f6e:	0080                	addi	s0,sp,64
    80000f70:	84aa                	mv	s1,a0
    80000f72:	89ae                	mv	s3,a1
    80000f74:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f76:	57fd                	li	a5,-1
    80000f78:	83e9                	srli	a5,a5,0x1a
    80000f7a:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f7c:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f7e:	06b7e363          	bltu	a5,a1,80000fe4 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f82:	0149d933          	srl	s2,s3,s4
    80000f86:	1ff97913          	andi	s2,s2,511
    80000f8a:	090e                	slli	s2,s2,0x3
    80000f8c:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f8e:	00093483          	ld	s1,0(s2)
    80000f92:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f96:	80a9                	srli	s1,s1,0xa
    80000f98:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000f9a:	e395                	bnez	a5,80000fbe <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000f9c:	040b0a63          	beqz	s6,80000ff0 <walk+0x94>
    80000fa0:	b9fff0ef          	jal	80000b3e <kalloc>
    80000fa4:	84aa                	mv	s1,a0
    80000fa6:	c50d                	beqz	a0,80000fd0 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fa8:	6605                	lui	a2,0x1
    80000faa:	4581                	li	a1,0
    80000fac:	d29ff0ef          	jal	80000cd4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fb0:	00c4d793          	srli	a5,s1,0xc
    80000fb4:	07aa                	slli	a5,a5,0xa
    80000fb6:	0017e793          	ori	a5,a5,1
    80000fba:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fbe:	3a5d                	addiw	s4,s4,-9
    80000fc0:	fd5a11e3          	bne	s4,s5,80000f82 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fc4:	00c9d513          	srli	a0,s3,0xc
    80000fc8:	1ff57513          	andi	a0,a0,511
    80000fcc:	050e                	slli	a0,a0,0x3
    80000fce:	9526                	add	a0,a0,s1
}
    80000fd0:	70e2                	ld	ra,56(sp)
    80000fd2:	7442                	ld	s0,48(sp)
    80000fd4:	74a2                	ld	s1,40(sp)
    80000fd6:	7902                	ld	s2,32(sp)
    80000fd8:	69e2                	ld	s3,24(sp)
    80000fda:	6a42                	ld	s4,16(sp)
    80000fdc:	6aa2                	ld	s5,8(sp)
    80000fde:	6b02                	ld	s6,0(sp)
    80000fe0:	6121                	addi	sp,sp,64
    80000fe2:	8082                	ret
    panic("walk");
    80000fe4:	00006517          	auipc	a0,0x6
    80000fe8:	0cc50513          	addi	a0,a0,204 # 800070b0 <etext+0xb0>
    80000fec:	84fff0ef          	jal	8000083a <panic>
        return 0;
    80000ff0:	4501                	li	a0,0
    80000ff2:	bff9                	j	80000fd0 <walk+0x74>

0000000080000ff4 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000ff4:	57fd                	li	a5,-1
    80000ff6:	83e9                	srli	a5,a5,0x1a
    80000ff8:	00b7f463          	bgeu	a5,a1,80001000 <walkaddr+0xc>
    return 0;
    80000ffc:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000ffe:	8082                	ret
{
    80001000:	1141                	addi	sp,sp,-16
    80001002:	e406                	sd	ra,8(sp)
    80001004:	e022                	sd	s0,0(sp)
    80001006:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80001008:	4601                	li	a2,0
    8000100a:	f53ff0ef          	jal	80000f5c <walk>
  if (pte == 0)
    8000100e:	c519                	beqz	a0,8000101c <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80001010:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80001012:	01157713          	andi	a4,a0,17
    80001016:	47c5                	li	a5,17
    80001018:	00f70763          	beq	a4,a5,80001026 <walkaddr+0x32>
    return 0;
    8000101c:	4501                	li	a0,0
}
    8000101e:	60a2                	ld	ra,8(sp)
    80001020:	6402                	ld	s0,0(sp)
    80001022:	0141                	addi	sp,sp,16
    80001024:	8082                	ret
  pa = PTE2PA(*pte);
    80001026:	8129                	srli	a0,a0,0xa
    80001028:	0532                	slli	a0,a0,0xc
  return pa;
    8000102a:	bfd5                	j	8000101e <walkaddr+0x2a>

000000008000102c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000102c:	715d                	addi	sp,sp,-80
    8000102e:	e486                	sd	ra,72(sp)
    80001030:	e0a2                	sd	s0,64(sp)
    80001032:	fc26                	sd	s1,56(sp)
    80001034:	f84a                	sd	s2,48(sp)
    80001036:	f44e                	sd	s3,40(sp)
    80001038:	f052                	sd	s4,32(sp)
    8000103a:	ec56                	sd	s5,24(sp)
    8000103c:	e85a                	sd	s6,16(sp)
    8000103e:	e45e                	sd	s7,8(sp)
    80001040:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001042:	03459793          	slli	a5,a1,0x34
    80001046:	e7b1                	bnez	a5,80001092 <mappages+0x66>
    80001048:	8a2a                	mv	s4,a0
    8000104a:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    8000104c:	03461793          	slli	a5,a2,0x34
    80001050:	e7b9                	bnez	a5,8000109e <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001052:	ce21                	beqz	a2,800010aa <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001054:	77fd                	lui	a5,0xfffff
    80001056:	963e                	add	a2,a2,a5
    80001058:	00b60933          	add	s2,a2,a1
  a = va;
    8000105c:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000105e:	4b05                	li	s6,1
    80001060:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001064:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001066:	865a                	mv	a2,s6
    80001068:	85a6                	mv	a1,s1
    8000106a:	8552                	mv	a0,s4
    8000106c:	ef1ff0ef          	jal	80000f5c <walk>
    80001070:	c929                	beqz	a0,800010c2 <mappages+0x96>
    if (*pte & PTE_V)
    80001072:	611c                	ld	a5,0(a0)
    80001074:	8b85                	andi	a5,a5,1
    80001076:	e3a1                	bnez	a5,800010b6 <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80001078:	013487b3          	add	a5,s1,s3
    8000107c:	83b1                	srli	a5,a5,0xc
    8000107e:	07aa                	slli	a5,a5,0xa
    80001080:	0157e7b3          	or	a5,a5,s5
    80001084:	0017e793          	ori	a5,a5,1
    80001088:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000108a:	05248863          	beq	s1,s2,800010da <mappages+0xae>
    a += PGSIZE;
    8000108e:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001090:	bfd9                	j	80001066 <mappages+0x3a>
    panic("mappages: va not aligned");
    80001092:	00006517          	auipc	a0,0x6
    80001096:	02650513          	addi	a0,a0,38 # 800070b8 <etext+0xb8>
    8000109a:	fa0ff0ef          	jal	8000083a <panic>
    panic("mappages: size not aligned");
    8000109e:	00006517          	auipc	a0,0x6
    800010a2:	03a50513          	addi	a0,a0,58 # 800070d8 <etext+0xd8>
    800010a6:	f94ff0ef          	jal	8000083a <panic>
    panic("mappages: size");
    800010aa:	00006517          	auipc	a0,0x6
    800010ae:	04e50513          	addi	a0,a0,78 # 800070f8 <etext+0xf8>
    800010b2:	f88ff0ef          	jal	8000083a <panic>
      panic("mappages: remap");
    800010b6:	00006517          	auipc	a0,0x6
    800010ba:	05250513          	addi	a0,a0,82 # 80007108 <etext+0x108>
    800010be:	f7cff0ef          	jal	8000083a <panic>
      return -1;
    800010c2:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010c4:	60a6                	ld	ra,72(sp)
    800010c6:	6406                	ld	s0,64(sp)
    800010c8:	74e2                	ld	s1,56(sp)
    800010ca:	7942                	ld	s2,48(sp)
    800010cc:	79a2                	ld	s3,40(sp)
    800010ce:	7a02                	ld	s4,32(sp)
    800010d0:	6ae2                	ld	s5,24(sp)
    800010d2:	6b42                	ld	s6,16(sp)
    800010d4:	6ba2                	ld	s7,8(sp)
    800010d6:	6161                	addi	sp,sp,80
    800010d8:	8082                	ret
  return 0;
    800010da:	4501                	li	a0,0
    800010dc:	b7e5                	j	800010c4 <mappages+0x98>

00000000800010de <kvmmap>:
{
    800010de:	1141                	addi	sp,sp,-16
    800010e0:	e406                	sd	ra,8(sp)
    800010e2:	e022                	sd	s0,0(sp)
    800010e4:	0800                	addi	s0,sp,16
    800010e6:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010e8:	86b2                	mv	a3,a2
    800010ea:	863e                	mv	a2,a5
    800010ec:	f41ff0ef          	jal	8000102c <mappages>
    800010f0:	e509                	bnez	a0,800010fa <kvmmap+0x1c>
}
    800010f2:	60a2                	ld	ra,8(sp)
    800010f4:	6402                	ld	s0,0(sp)
    800010f6:	0141                	addi	sp,sp,16
    800010f8:	8082                	ret
    panic("kvmmap");
    800010fa:	00006517          	auipc	a0,0x6
    800010fe:	01e50513          	addi	a0,a0,30 # 80007118 <etext+0x118>
    80001102:	f38ff0ef          	jal	8000083a <panic>

0000000080001106 <kvmmake>:
{
    80001106:	1101                	addi	sp,sp,-32
    80001108:	ec06                	sd	ra,24(sp)
    8000110a:	e822                	sd	s0,16(sp)
    8000110c:	e426                	sd	s1,8(sp)
    8000110e:	e04a                	sd	s2,0(sp)
    80001110:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001112:	a2dff0ef          	jal	80000b3e <kalloc>
    80001116:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80001118:	6605                	lui	a2,0x1
    8000111a:	4581                	li	a1,0
    8000111c:	bb9ff0ef          	jal	80000cd4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001120:	4719                	li	a4,6
    80001122:	6685                	lui	a3,0x1
    80001124:	10000637          	lui	a2,0x10000
    80001128:	85b2                	mv	a1,a2
    8000112a:	8526                	mv	a0,s1
    8000112c:	fb3ff0ef          	jal	800010de <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001130:	4719                	li	a4,6
    80001132:	6685                	lui	a3,0x1
    80001134:	10001637          	lui	a2,0x10001
    80001138:	85b2                	mv	a1,a2
    8000113a:	8526                	mv	a0,s1
    8000113c:	fa3ff0ef          	jal	800010de <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001140:	4719                	li	a4,6
    80001142:	040006b7          	lui	a3,0x4000
    80001146:	0c000637          	lui	a2,0xc000
    8000114a:	85b2                	mv	a1,a2
    8000114c:	8526                	mv	a0,s1
    8000114e:	f91ff0ef          	jal	800010de <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001152:	00006917          	auipc	s2,0x6
    80001156:	eae90913          	addi	s2,s2,-338 # 80007000 <etext>
    8000115a:	4729                	li	a4,10
    8000115c:	800006b7          	lui	a3,0x80000
    80001160:	96ca                	add	a3,a3,s2
    80001162:	4605                	li	a2,1
    80001164:	067e                	slli	a2,a2,0x1f
    80001166:	85b2                	mv	a1,a2
    80001168:	8526                	mv	a0,s1
    8000116a:	f75ff0ef          	jal	800010de <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    8000116e:	4719                	li	a4,6
    80001170:	46c5                	li	a3,17
    80001172:	06ee                	slli	a3,a3,0x1b
    80001174:	412686b3          	sub	a3,a3,s2
    80001178:	864a                	mv	a2,s2
    8000117a:	85ca                	mv	a1,s2
    8000117c:	8526                	mv	a0,s1
    8000117e:	f61ff0ef          	jal	800010de <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001182:	4729                	li	a4,10
    80001184:	6685                	lui	a3,0x1
    80001186:	00005617          	auipc	a2,0x5
    8000118a:	e7a60613          	addi	a2,a2,-390 # 80006000 <_trampoline>
    8000118e:	040005b7          	lui	a1,0x4000
    80001192:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001194:	05b2                	slli	a1,a1,0xc
    80001196:	8526                	mv	a0,s1
    80001198:	f47ff0ef          	jal	800010de <kvmmap>
  proc_mapstacks(kpgtbl);
    8000119c:	8526                	mv	a0,s1
    8000119e:	5bc000ef          	jal	8000175a <proc_mapstacks>
}
    800011a2:	8526                	mv	a0,s1
    800011a4:	60e2                	ld	ra,24(sp)
    800011a6:	6442                	ld	s0,16(sp)
    800011a8:	64a2                	ld	s1,8(sp)
    800011aa:	6902                	ld	s2,0(sp)
    800011ac:	6105                	addi	sp,sp,32
    800011ae:	8082                	ret

00000000800011b0 <kvminit>:
{
    800011b0:	1141                	addi	sp,sp,-16
    800011b2:	e406                	sd	ra,8(sp)
    800011b4:	e022                	sd	s0,0(sp)
    800011b6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011b8:	f4fff0ef          	jal	80001106 <kvmmake>
    800011bc:	00007797          	auipc	a5,0x7
    800011c0:	80a7be23          	sd	a0,-2020(a5) # 800079d8 <kernel_pagetable>
}
    800011c4:	60a2                	ld	ra,8(sp)
    800011c6:	6402                	ld	s0,0(sp)
    800011c8:	0141                	addi	sp,sp,16
    800011ca:	8082                	ret

00000000800011cc <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011cc:	1101                	addi	sp,sp,-32
    800011ce:	ec06                	sd	ra,24(sp)
    800011d0:	e822                	sd	s0,16(sp)
    800011d2:	e426                	sd	s1,8(sp)
    800011d4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011d6:	969ff0ef          	jal	80000b3e <kalloc>
    800011da:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011dc:	c509                	beqz	a0,800011e6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011de:	6605                	lui	a2,0x1
    800011e0:	4581                	li	a1,0
    800011e2:	af3ff0ef          	jal	80000cd4 <memset>
  return pagetable;
}
    800011e6:	8526                	mv	a0,s1
    800011e8:	60e2                	ld	ra,24(sp)
    800011ea:	6442                	ld	s0,16(sp)
    800011ec:	64a2                	ld	s1,8(sp)
    800011ee:	6105                	addi	sp,sp,32
    800011f0:	8082                	ret

00000000800011f2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011f2:	7139                	addi	sp,sp,-64
    800011f4:	fc06                	sd	ra,56(sp)
    800011f6:	f822                	sd	s0,48(sp)
    800011f8:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011fa:	03459793          	slli	a5,a1,0x34
    800011fe:	e38d                	bnez	a5,80001220 <uvmunmap+0x2e>
    80001200:	f04a                	sd	s2,32(sp)
    80001202:	ec4e                	sd	s3,24(sp)
    80001204:	e852                	sd	s4,16(sp)
    80001206:	e456                	sd	s5,8(sp)
    80001208:	e05a                	sd	s6,0(sp)
    8000120a:	8a2a                	mv	s4,a0
    8000120c:	892e                	mv	s2,a1
    8000120e:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001210:	0632                	slli	a2,a2,0xc
    80001212:	00b609b3          	add	s3,a2,a1
    80001216:	6b05                	lui	s6,0x1
    80001218:	0535f963          	bgeu	a1,s3,8000126a <uvmunmap+0x78>
    8000121c:	f426                	sd	s1,40(sp)
    8000121e:	a015                	j	80001242 <uvmunmap+0x50>
    80001220:	f426                	sd	s1,40(sp)
    80001222:	f04a                	sd	s2,32(sp)
    80001224:	ec4e                	sd	s3,24(sp)
    80001226:	e852                	sd	s4,16(sp)
    80001228:	e456                	sd	s5,8(sp)
    8000122a:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	ef450513          	addi	a0,a0,-268 # 80007120 <etext+0x120>
    80001234:	e06ff0ef          	jal	8000083a <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    80001238:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    8000123c:	995a                	add	s2,s2,s6
    8000123e:	03397563          	bgeu	s2,s3,80001268 <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001242:	4601                	li	a2,0
    80001244:	85ca                	mv	a1,s2
    80001246:	8552                	mv	a0,s4
    80001248:	d15ff0ef          	jal	80000f5c <walk>
    8000124c:	84aa                	mv	s1,a0
    8000124e:	d57d                	beqz	a0,8000123c <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001250:	611c                	ld	a5,0(a0)
    80001252:	0017f713          	andi	a4,a5,1
    80001256:	d37d                	beqz	a4,8000123c <uvmunmap+0x4a>
    if (do_free) {
    80001258:	fe0a80e3          	beqz	s5,80001238 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    8000125c:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    8000125e:	00c79513          	slli	a0,a5,0xc
    80001262:	ff4ff0ef          	jal	80000a56 <kfree>
    80001266:	bfc9                	j	80001238 <uvmunmap+0x46>
    80001268:	74a2                	ld	s1,40(sp)
    8000126a:	7902                	ld	s2,32(sp)
    8000126c:	69e2                	ld	s3,24(sp)
    8000126e:	6a42                	ld	s4,16(sp)
    80001270:	6aa2                	ld	s5,8(sp)
    80001272:	6b02                	ld	s6,0(sp)
  }
}
    80001274:	70e2                	ld	ra,56(sp)
    80001276:	7442                	ld	s0,48(sp)
    80001278:	6121                	addi	sp,sp,64
    8000127a:	8082                	ret

000000008000127c <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    8000127c:	04b67163          	bgeu	a2,a1,800012be <uvmdealloc+0x42>
{
    80001280:	1101                	addi	sp,sp,-32
    80001282:	ec06                	sd	ra,24(sp)
    80001284:	e822                	sd	s0,16(sp)
    80001286:	e426                	sd	s1,8(sp)
    80001288:	1000                	addi	s0,sp,32
    8000128a:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    8000128c:	6785                	lui	a5,0x1
    8000128e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001290:	00f60733          	add	a4,a2,a5
    80001294:	76fd                	lui	a3,0xfffff
    80001296:	8f75                	and	a4,a4,a3
    80001298:	97ae                	add	a5,a5,a1
    8000129a:	8ff5                	and	a5,a5,a3
    8000129c:	00f76863          	bltu	a4,a5,800012ac <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    800012a0:	8526                	mv	a0,s1
}
    800012a2:	60e2                	ld	ra,24(sp)
    800012a4:	6442                	ld	s0,16(sp)
    800012a6:	64a2                	ld	s1,8(sp)
    800012a8:	6105                	addi	sp,sp,32
    800012aa:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012ac:	8f99                	sub	a5,a5,a4
    800012ae:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012b0:	4685                	li	a3,1
    800012b2:	0007861b          	sext.w	a2,a5
    800012b6:	85ba                	mv	a1,a4
    800012b8:	f3bff0ef          	jal	800011f2 <uvmunmap>
    800012bc:	b7d5                	j	800012a0 <uvmdealloc+0x24>
    return oldsz;
    800012be:	852e                	mv	a0,a1
}
    800012c0:	8082                	ret

00000000800012c2 <uvmalloc>:
  if (newsz < oldsz)
    800012c2:	08b66e63          	bltu	a2,a1,8000135e <uvmalloc+0x9c>
{
    800012c6:	715d                	addi	sp,sp,-80
    800012c8:	e486                	sd	ra,72(sp)
    800012ca:	e0a2                	sd	s0,64(sp)
    800012cc:	f052                	sd	s4,32(sp)
    800012ce:	ec56                	sd	s5,24(sp)
    800012d0:	e45e                	sd	s7,8(sp)
    800012d2:	0880                	addi	s0,sp,80
    800012d4:	8aaa                	mv	s5,a0
    800012d6:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012d8:	6785                	lui	a5,0x1
    800012da:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012dc:	95be                	add	a1,a1,a5
    800012de:	77fd                	lui	a5,0xfffff
    800012e0:	8fed                	and	a5,a5,a1
    800012e2:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012e4:	04c7f163          	bgeu	a5,a2,80001326 <uvmalloc+0x64>
    800012e8:	fc26                	sd	s1,56(sp)
    800012ea:	f84a                	sd	s2,48(sp)
    800012ec:	f44e                	sd	s3,40(sp)
    800012ee:	e85a                	sd	s6,16(sp)
    800012f0:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    800012f2:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012f4:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012f8:	847ff0ef          	jal	80000b3e <kalloc>
    800012fc:	84aa                	mv	s1,a0
    if (mem == 0) {
    800012fe:	c515                	beqz	a0,8000132a <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80001300:	864e                	mv	a2,s3
    80001302:	4581                	li	a1,0
    80001304:	9d1ff0ef          	jal	80000cd4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    80001308:	875a                	mv	a4,s6
    8000130a:	86a6                	mv	a3,s1
    8000130c:	864e                	mv	a2,s3
    8000130e:	85ca                	mv	a1,s2
    80001310:	8556                	mv	a0,s5
    80001312:	d1bff0ef          	jal	8000102c <mappages>
    80001316:	e91d                	bnez	a0,8000134c <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    80001318:	994e                	add	s2,s2,s3
    8000131a:	fd496fe3          	bltu	s2,s4,800012f8 <uvmalloc+0x36>
    8000131e:	74e2                	ld	s1,56(sp)
    80001320:	7942                	ld	s2,48(sp)
    80001322:	79a2                	ld	s3,40(sp)
    80001324:	6b42                	ld	s6,16(sp)
  return newsz;
    80001326:	8552                	mv	a0,s4
    80001328:	a819                	j	8000133e <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000132a:	865e                	mv	a2,s7
    8000132c:	85ca                	mv	a1,s2
    8000132e:	8556                	mv	a0,s5
    80001330:	f4dff0ef          	jal	8000127c <uvmdealloc>
      return 0;
    80001334:	4501                	li	a0,0
    80001336:	74e2                	ld	s1,56(sp)
    80001338:	7942                	ld	s2,48(sp)
    8000133a:	79a2                	ld	s3,40(sp)
    8000133c:	6b42                	ld	s6,16(sp)
}
    8000133e:	60a6                	ld	ra,72(sp)
    80001340:	6406                	ld	s0,64(sp)
    80001342:	7a02                	ld	s4,32(sp)
    80001344:	6ae2                	ld	s5,24(sp)
    80001346:	6ba2                	ld	s7,8(sp)
    80001348:	6161                	addi	sp,sp,80
    8000134a:	8082                	ret
      kfree(mem);
    8000134c:	8526                	mv	a0,s1
    8000134e:	f08ff0ef          	jal	80000a56 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001352:	865e                	mv	a2,s7
    80001354:	85ca                	mv	a1,s2
    80001356:	8556                	mv	a0,s5
    80001358:	f25ff0ef          	jal	8000127c <uvmdealloc>
      return 0;
    8000135c:	bfe1                	j	80001334 <uvmalloc+0x72>
    return oldsz;
    8000135e:	852e                	mv	a0,a1
}
    80001360:	8082                	ret

0000000080001362 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001362:	7179                	addi	sp,sp,-48
    80001364:	f406                	sd	ra,40(sp)
    80001366:	f022                	sd	s0,32(sp)
    80001368:	ec26                	sd	s1,24(sp)
    8000136a:	e84a                	sd	s2,16(sp)
    8000136c:	e44e                	sd	s3,8(sp)
    8000136e:	1800                	addi	s0,sp,48
    80001370:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001372:	84aa                	mv	s1,a0
    80001374:	6905                	lui	s2,0x1
    80001376:	992a                	add	s2,s2,a0
    80001378:	a811                	j	8000138c <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000137a:	00006517          	auipc	a0,0x6
    8000137e:	dbe50513          	addi	a0,a0,-578 # 80007138 <etext+0x138>
    80001382:	cb8ff0ef          	jal	8000083a <panic>
  for (int i = 0; i < 512; i++) {
    80001386:	04a1                	addi	s1,s1,8
    80001388:	03248163          	beq	s1,s2,800013aa <freewalk+0x48>
    pte_t pte = pagetable[i];
    8000138c:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    8000138e:	0017f713          	andi	a4,a5,1
    80001392:	db75                	beqz	a4,80001386 <freewalk+0x24>
    80001394:	00e7f713          	andi	a4,a5,14
    80001398:	f36d                	bnez	a4,8000137a <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000139a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000139c:	00c79513          	slli	a0,a5,0xc
    800013a0:	fc3ff0ef          	jal	80001362 <freewalk>
      pagetable[i] = 0;
    800013a4:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013a8:	bff9                	j	80001386 <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013aa:	854e                	mv	a0,s3
    800013ac:	eaaff0ef          	jal	80000a56 <kfree>
}
    800013b0:	70a2                	ld	ra,40(sp)
    800013b2:	7402                	ld	s0,32(sp)
    800013b4:	64e2                	ld	s1,24(sp)
    800013b6:	6942                	ld	s2,16(sp)
    800013b8:	69a2                	ld	s3,8(sp)
    800013ba:	6145                	addi	sp,sp,48
    800013bc:	8082                	ret

00000000800013be <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013be:	1101                	addi	sp,sp,-32
    800013c0:	ec06                	sd	ra,24(sp)
    800013c2:	e822                	sd	s0,16(sp)
    800013c4:	e426                	sd	s1,8(sp)
    800013c6:	1000                	addi	s0,sp,32
    800013c8:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ca:	e989                	bnez	a1,800013dc <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013cc:	8526                	mv	a0,s1
    800013ce:	f95ff0ef          	jal	80001362 <freewalk>
}
    800013d2:	60e2                	ld	ra,24(sp)
    800013d4:	6442                	ld	s0,16(sp)
    800013d6:	64a2                	ld	s1,8(sp)
    800013d8:	6105                	addi	sp,sp,32
    800013da:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013dc:	6785                	lui	a5,0x1
    800013de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013e0:	95be                	add	a1,a1,a5
    800013e2:	4685                	li	a3,1
    800013e4:	00c5d613          	srli	a2,a1,0xc
    800013e8:	4581                	li	a1,0
    800013ea:	e09ff0ef          	jal	800011f2 <uvmunmap>
    800013ee:	bff9                	j	800013cc <uvmfree+0xe>

00000000800013f0 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013f0:	ca59                	beqz	a2,80001486 <uvmcopy+0x96>
{
    800013f2:	715d                	addi	sp,sp,-80
    800013f4:	e486                	sd	ra,72(sp)
    800013f6:	e0a2                	sd	s0,64(sp)
    800013f8:	fc26                	sd	s1,56(sp)
    800013fa:	f84a                	sd	s2,48(sp)
    800013fc:	f44e                	sd	s3,40(sp)
    800013fe:	f052                	sd	s4,32(sp)
    80001400:	ec56                	sd	s5,24(sp)
    80001402:	e85a                	sd	s6,16(sp)
    80001404:	e45e                	sd	s7,8(sp)
    80001406:	0880                	addi	s0,sp,80
    80001408:	8b2a                	mv	s6,a0
    8000140a:	8bae                	mv	s7,a1
    8000140c:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    8000140e:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001410:	6a05                	lui	s4,0x1
    80001412:	a021                	j	8000141a <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    80001414:	94d2                	add	s1,s1,s4
    80001416:	0554fc63          	bgeu	s1,s5,8000146e <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    8000141a:	4601                	li	a2,0
    8000141c:	85a6                	mv	a1,s1
    8000141e:	855a                	mv	a0,s6
    80001420:	b3dff0ef          	jal	80000f5c <walk>
    80001424:	d965                	beqz	a0,80001414 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    80001426:	00053983          	ld	s3,0(a0)
    8000142a:	0019f793          	andi	a5,s3,1
    8000142e:	d3fd                	beqz	a5,80001414 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001430:	f0eff0ef          	jal	80000b3e <kalloc>
    80001434:	892a                	mv	s2,a0
    80001436:	c11d                	beqz	a0,8000145c <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    80001438:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    8000143c:	8652                	mv	a2,s4
    8000143e:	05b2                	slli	a1,a1,0xc
    80001440:	8f1ff0ef          	jal	80000d30 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001444:	3ff9f713          	andi	a4,s3,1023
    80001448:	86ca                	mv	a3,s2
    8000144a:	8652                	mv	a2,s4
    8000144c:	85a6                	mv	a1,s1
    8000144e:	855e                	mv	a0,s7
    80001450:	bddff0ef          	jal	8000102c <mappages>
    80001454:	d161                	beqz	a0,80001414 <uvmcopy+0x24>
      kfree(mem);
    80001456:	854a                	mv	a0,s2
    80001458:	dfeff0ef          	jal	80000a56 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    8000145c:	4685                	li	a3,1
    8000145e:	00c4d613          	srli	a2,s1,0xc
    80001462:	4581                	li	a1,0
    80001464:	855e                	mv	a0,s7
    80001466:	d8dff0ef          	jal	800011f2 <uvmunmap>
  return -1;
    8000146a:	557d                	li	a0,-1
    8000146c:	a011                	j	80001470 <uvmcopy+0x80>
  return 0;
    8000146e:	4501                	li	a0,0
}
    80001470:	60a6                	ld	ra,72(sp)
    80001472:	6406                	ld	s0,64(sp)
    80001474:	74e2                	ld	s1,56(sp)
    80001476:	7942                	ld	s2,48(sp)
    80001478:	79a2                	ld	s3,40(sp)
    8000147a:	7a02                	ld	s4,32(sp)
    8000147c:	6ae2                	ld	s5,24(sp)
    8000147e:	6b42                	ld	s6,16(sp)
    80001480:	6ba2                	ld	s7,8(sp)
    80001482:	6161                	addi	sp,sp,80
    80001484:	8082                	ret
  return 0;
    80001486:	4501                	li	a0,0
}
    80001488:	8082                	ret

000000008000148a <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000148a:	1141                	addi	sp,sp,-16
    8000148c:	e406                	sd	ra,8(sp)
    8000148e:	e022                	sd	s0,0(sp)
    80001490:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001492:	4601                	li	a2,0
    80001494:	ac9ff0ef          	jal	80000f5c <walk>
  if (pte == 0)
    80001498:	c901                	beqz	a0,800014a8 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000149a:	611c                	ld	a5,0(a0)
    8000149c:	9bbd                	andi	a5,a5,-17
    8000149e:	e11c                	sd	a5,0(a0)
}
    800014a0:	60a2                	ld	ra,8(sp)
    800014a2:	6402                	ld	s0,0(sp)
    800014a4:	0141                	addi	sp,sp,16
    800014a6:	8082                	ret
    panic("uvmclear");
    800014a8:	00006517          	auipc	a0,0x6
    800014ac:	ca050513          	addi	a0,a0,-864 # 80007148 <etext+0x148>
    800014b0:	b8aff0ef          	jal	8000083a <panic>

00000000800014b4 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    800014b4:	cac5                	beqz	a3,80001564 <copyinstr+0xb0>
{
    800014b6:	715d                	addi	sp,sp,-80
    800014b8:	e486                	sd	ra,72(sp)
    800014ba:	e0a2                	sd	s0,64(sp)
    800014bc:	fc26                	sd	s1,56(sp)
    800014be:	f84a                	sd	s2,48(sp)
    800014c0:	f44e                	sd	s3,40(sp)
    800014c2:	f052                	sd	s4,32(sp)
    800014c4:	ec56                	sd	s5,24(sp)
    800014c6:	e85a                	sd	s6,16(sp)
    800014c8:	e45e                	sd	s7,8(sp)
    800014ca:	0880                	addi	s0,sp,80
    800014cc:	8aaa                	mv	s5,a0
    800014ce:	84ae                	mv	s1,a1
    800014d0:	8bb2                	mv	s7,a2
    800014d2:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800014d4:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014d6:	6a05                	lui	s4,0x1
    800014d8:	a82d                	j	80001512 <copyinstr+0x5e>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    800014da:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800014de:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    800014e0:	0017c793          	xori	a5,a5,1
    800014e4:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014e8:	60a6                	ld	ra,72(sp)
    800014ea:	6406                	ld	s0,64(sp)
    800014ec:	74e2                	ld	s1,56(sp)
    800014ee:	7942                	ld	s2,48(sp)
    800014f0:	79a2                	ld	s3,40(sp)
    800014f2:	7a02                	ld	s4,32(sp)
    800014f4:	6ae2                	ld	s5,24(sp)
    800014f6:	6b42                	ld	s6,16(sp)
    800014f8:	6ba2                	ld	s7,8(sp)
    800014fa:	6161                	addi	sp,sp,80
    800014fc:	8082                	ret
    800014fe:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001502:	9726                	add	a4,a4,s1
      --max;
    80001504:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80001508:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0) {
    8000150c:	04e58463          	beq	a1,a4,80001554 <copyinstr+0xa0>
{
    80001510:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001512:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80001516:	85ca                	mv	a1,s2
    80001518:	8556                	mv	a0,s5
    8000151a:	adbff0ef          	jal	80000ff4 <walkaddr>
    if (pa0 == 0)
    8000151e:	cd0d                	beqz	a0,80001558 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001520:	41790633          	sub	a2,s2,s7
    80001524:	9652                	add	a2,a2,s4
    if (n > max)
    80001526:	00c9f363          	bgeu	s3,a2,8000152c <copyinstr+0x78>
    8000152a:	864e                	mv	a2,s3
    while (n > 0) {
    8000152c:	ca05                	beqz	a2,8000155c <copyinstr+0xa8>
    char *p = (char *)(pa0 + (srcva - va0));
    8000152e:	034b9693          	slli	a3,s7,0x34
    80001532:	92d1                	srli	a3,a3,0x34
    80001534:	96aa                	add	a3,a3,a0
    80001536:	87a6                	mv	a5,s1
      if (*p == '\0') {
    80001538:	8e85                	sub	a3,a3,s1
    while (n > 0) {
    8000153a:	9626                	add	a2,a2,s1
    8000153c:	85be                	mv	a1,a5
      if (*p == '\0') {
    8000153e:	00f68733          	add	a4,a3,a5
    80001542:	00074703          	lbu	a4,0(a4)
    80001546:	db51                	beqz	a4,800014da <copyinstr+0x26>
        *dst = *p;
    80001548:	00e78023          	sb	a4,0(a5)
      dst++;
    8000154c:	0785                	addi	a5,a5,1
    while (n > 0) {
    8000154e:	fec797e3          	bne	a5,a2,8000153c <copyinstr+0x88>
    80001552:	b775                	j	800014fe <copyinstr+0x4a>
    srcva = va0 + PGSIZE;
    80001554:	4781                	li	a5,0
    80001556:	b769                	j	800014e0 <copyinstr+0x2c>
      return -1;
    80001558:	557d                	li	a0,-1
    8000155a:	b779                	j	800014e8 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    8000155c:	6b85                	lui	s7,0x1
    8000155e:	9bca                	add	s7,s7,s2
    80001560:	87a6                	mv	a5,s1
    80001562:	b77d                	j	80001510 <copyinstr+0x5c>
    80001564:	4781                	li	a5,0
  if (got_null) {
    80001566:	0017c793          	xori	a5,a5,1
    8000156a:	40f0053b          	negw	a0,a5
}
    8000156e:	8082                	ret

0000000080001570 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001570:	1141                	addi	sp,sp,-16
    80001572:	e406                	sd	ra,8(sp)
    80001574:	e022                	sd	s0,0(sp)
    80001576:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80001578:	4601                	li	a2,0
    8000157a:	9e3ff0ef          	jal	80000f5c <walk>
  if (pte == 0) {
    8000157e:	c119                	beqz	a0,80001584 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    80001580:	6108                	ld	a0,0(a0)
    80001582:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001584:	60a2                	ld	ra,8(sp)
    80001586:	6402                	ld	s0,0(sp)
    80001588:	0141                	addi	sp,sp,16
    8000158a:	8082                	ret

000000008000158c <vmfault>:
{
    8000158c:	7179                	addi	sp,sp,-48
    8000158e:	f406                	sd	ra,40(sp)
    80001590:	f022                	sd	s0,32(sp)
    80001592:	e84a                	sd	s2,16(sp)
    80001594:	e052                	sd	s4,0(sp)
    80001596:	1800                	addi	s0,sp,48
    80001598:	8a2a                	mv	s4,a0
    8000159a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000159c:	33e000ef          	jal	800018da <myproc>
  if (va >= p->sz)
    800015a0:	653c                	ld	a5,72(a0)
    800015a2:	00f96d63          	bltu	s2,a5,800015bc <vmfault+0x30>
    return 0;
    800015a6:	4a01                	li	s4,0
}
    800015a8:	8552                	mv	a0,s4
    800015aa:	70a2                	ld	ra,40(sp)
    800015ac:	7402                	ld	s0,32(sp)
    800015ae:	6942                	ld	s2,16(sp)
    800015b0:	6a02                	ld	s4,0(sp)
    800015b2:	6145                	addi	sp,sp,48
    800015b4:	8082                	ret
    800015b6:	64e2                	ld	s1,24(sp)
    800015b8:	69a2                	ld	s3,8(sp)
    800015ba:	b7f5                	j	800015a6 <vmfault+0x1a>
    800015bc:	ec26                	sd	s1,24(sp)
    800015be:	e44e                	sd	s3,8(sp)
    800015c0:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800015c2:	77fd                	lui	a5,0xfffff
    800015c4:	00f979b3          	and	s3,s2,a5
  if (ismapped(pagetable, va)) {
    800015c8:	85ce                	mv	a1,s3
    800015ca:	8552                	mv	a0,s4
    800015cc:	fa5ff0ef          	jal	80001570 <ismapped>
    800015d0:	c501                	beqz	a0,800015d8 <vmfault+0x4c>
    800015d2:	64e2                	ld	s1,24(sp)
    800015d4:	69a2                	ld	s3,8(sp)
    800015d6:	bfc1                	j	800015a6 <vmfault+0x1a>
  mem = (uint64)kalloc();
    800015d8:	d66ff0ef          	jal	80000b3e <kalloc>
    800015dc:	892a                	mv	s2,a0
  if (mem == 0)
    800015de:	dd61                	beqz	a0,800015b6 <vmfault+0x2a>
  mem = (uint64)kalloc();
    800015e0:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    800015e2:	6605                	lui	a2,0x1
    800015e4:	4581                	li	a1,0
    800015e6:	eeeff0ef          	jal	80000cd4 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    800015ea:	4759                	li	a4,22
    800015ec:	86ca                	mv	a3,s2
    800015ee:	6605                	lui	a2,0x1
    800015f0:	85ce                	mv	a1,s3
    800015f2:	68a8                	ld	a0,80(s1)
    800015f4:	a39ff0ef          	jal	8000102c <mappages>
    800015f8:	e501                	bnez	a0,80001600 <vmfault+0x74>
    800015fa:	64e2                	ld	s1,24(sp)
    800015fc:	69a2                	ld	s3,8(sp)
    800015fe:	b76d                	j	800015a8 <vmfault+0x1c>
    kfree((void *)mem);
    80001600:	854a                	mv	a0,s2
    80001602:	c54ff0ef          	jal	80000a56 <kfree>
    return 0;
    80001606:	64e2                	ld	s1,24(sp)
    80001608:	69a2                	ld	s3,8(sp)
    8000160a:	bf71                	j	800015a6 <vmfault+0x1a>

000000008000160c <copyout>:
  while (len > 0) {
    8000160c:	cad5                	beqz	a3,800016c0 <copyout+0xb4>
{
    8000160e:	711d                	addi	sp,sp,-96
    80001610:	ec86                	sd	ra,88(sp)
    80001612:	e8a2                	sd	s0,80(sp)
    80001614:	e4a6                	sd	s1,72(sp)
    80001616:	e0ca                	sd	s2,64(sp)
    80001618:	fc4e                	sd	s3,56(sp)
    8000161a:	f852                	sd	s4,48(sp)
    8000161c:	f456                	sd	s5,40(sp)
    8000161e:	f05a                	sd	s6,32(sp)
    80001620:	ec5e                	sd	s7,24(sp)
    80001622:	e862                	sd	s8,16(sp)
    80001624:	e466                	sd	s9,8(sp)
    80001626:	e06a                	sd	s10,0(sp)
    80001628:	1080                	addi	s0,sp,96
    8000162a:	8baa                	mv	s7,a0
    8000162c:	84ae                	mv	s1,a1
    8000162e:	8b32                	mv	s6,a2
    80001630:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80001632:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001634:	5cfd                	li	s9,-1
    80001636:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000163a:	6c05                	lui	s8,0x1
    8000163c:	a081                	j	8000167c <copyout+0x70>
      return -1;
    8000163e:	557d                	li	a0,-1
}
    80001640:	60e6                	ld	ra,88(sp)
    80001642:	6446                	ld	s0,80(sp)
    80001644:	64a6                	ld	s1,72(sp)
    80001646:	6906                	ld	s2,64(sp)
    80001648:	79e2                	ld	s3,56(sp)
    8000164a:	7a42                	ld	s4,48(sp)
    8000164c:	7aa2                	ld	s5,40(sp)
    8000164e:	7b02                	ld	s6,32(sp)
    80001650:	6be2                	ld	s7,24(sp)
    80001652:	6c42                	ld	s8,16(sp)
    80001654:	6ca2                	ld	s9,8(sp)
    80001656:	6d02                	ld	s10,0(sp)
    80001658:	6125                	addi	sp,sp,96
    8000165a:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    8000165c:	03449513          	slli	a0,s1,0x34
    80001660:	9151                	srli	a0,a0,0x34
    80001662:	0009061b          	sext.w	a2,s2
    80001666:	85da                	mv	a1,s6
    80001668:	954e                	add	a0,a0,s3
    8000166a:	ec6ff0ef          	jal	80000d30 <memmove>
    len -= n;
    8000166e:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001672:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001674:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    80001678:	040a8263          	beqz	s5,800016bc <copyout+0xb0>
    va0 = PGROUNDDOWN(dstva);
    8000167c:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    80001680:	fb4cefe3          	bltu	s9,s4,8000163e <copyout+0x32>
    pa0 = walkaddr(pagetable, va0);
    80001684:	85d2                	mv	a1,s4
    80001686:	855e                	mv	a0,s7
    80001688:	96dff0ef          	jal	80000ff4 <walkaddr>
    8000168c:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    8000168e:	e901                	bnez	a0,8000169e <copyout+0x92>
      if ((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001690:	4601                	li	a2,0
    80001692:	85d2                	mv	a1,s4
    80001694:	855e                	mv	a0,s7
    80001696:	ef7ff0ef          	jal	8000158c <vmfault>
    8000169a:	89aa                	mv	s3,a0
    8000169c:	d14d                	beqz	a0,8000163e <copyout+0x32>
    pte = walk(pagetable, va0, 0);
    8000169e:	4601                	li	a2,0
    800016a0:	85d2                	mv	a1,s4
    800016a2:	855e                	mv	a0,s7
    800016a4:	8b9ff0ef          	jal	80000f5c <walk>
    if ((*pte & PTE_W) == 0)
    800016a8:	611c                	ld	a5,0(a0)
    800016aa:	8b91                	andi	a5,a5,4
    800016ac:	dbc9                	beqz	a5,8000163e <copyout+0x32>
    n = PGSIZE - (dstva - va0);
    800016ae:	409a0933          	sub	s2,s4,s1
    800016b2:	9962                	add	s2,s2,s8
    if (n > len)
    800016b4:	fb2af4e3          	bgeu	s5,s2,8000165c <copyout+0x50>
    800016b8:	8956                	mv	s2,s5
    800016ba:	b74d                	j	8000165c <copyout+0x50>
  return 0;
    800016bc:	4501                	li	a0,0
    800016be:	b749                	j	80001640 <copyout+0x34>
    800016c0:	4501                	li	a0,0
}
    800016c2:	8082                	ret

00000000800016c4 <copyin>:
  while (len > 0) {
    800016c4:	cac9                	beqz	a3,80001756 <copyin+0x92>
{
    800016c6:	711d                	addi	sp,sp,-96
    800016c8:	ec86                	sd	ra,88(sp)
    800016ca:	e8a2                	sd	s0,80(sp)
    800016cc:	e4a6                	sd	s1,72(sp)
    800016ce:	e0ca                	sd	s2,64(sp)
    800016d0:	fc4e                	sd	s3,56(sp)
    800016d2:	f852                	sd	s4,48(sp)
    800016d4:	f456                	sd	s5,40(sp)
    800016d6:	f05a                	sd	s6,32(sp)
    800016d8:	ec5e                	sd	s7,24(sp)
    800016da:	e862                	sd	s8,16(sp)
    800016dc:	e466                	sd	s9,8(sp)
    800016de:	1080                	addi	s0,sp,96
    800016e0:	8baa                	mv	s7,a0
    800016e2:	8aae                	mv	s5,a1
    800016e4:	84b2                	mv	s1,a2
    800016e6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016e8:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, va0, 1)) == 0) {
    800016ea:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016ec:	6b05                	lui	s6,0x1
    800016ee:	a03d                	j	8000171c <copyin+0x58>
    800016f0:	409a0933          	sub	s2,s4,s1
    800016f4:	995a                	add	s2,s2,s6
    if (n > len)
    800016f6:	0129f363          	bgeu	s3,s2,800016fc <copyin+0x38>
    800016fa:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    800016fc:	03449593          	slli	a1,s1,0x34
    80001700:	91d1                	srli	a1,a1,0x34
    80001702:	0009061b          	sext.w	a2,s2
    80001706:	95aa                	add	a1,a1,a0
    80001708:	8556                	mv	a0,s5
    8000170a:	e26ff0ef          	jal	80000d30 <memmove>
    len -= n;
    8000170e:	412989b3          	sub	s3,s3,s2
    dst += n;
    80001712:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001714:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    80001718:	02098163          	beqz	s3,8000173a <copyin+0x76>
    va0 = PGROUNDDOWN(srcva);
    8000171c:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    80001720:	85d2                	mv	a1,s4
    80001722:	855e                	mv	a0,s7
    80001724:	8d1ff0ef          	jal	80000ff4 <walkaddr>
    if (pa0 == 0) {
    80001728:	f561                	bnez	a0,800016f0 <copyin+0x2c>
      if ((pa0 = vmfault(pagetable, va0, 1)) == 0) {
    8000172a:	8666                	mv	a2,s9
    8000172c:	85d2                	mv	a1,s4
    8000172e:	855e                	mv	a0,s7
    80001730:	e5dff0ef          	jal	8000158c <vmfault>
    80001734:	fd55                	bnez	a0,800016f0 <copyin+0x2c>
        return -1;
    80001736:	557d                	li	a0,-1
    80001738:	a011                	j	8000173c <copyin+0x78>
  return 0;
    8000173a:	4501                	li	a0,0
}
    8000173c:	60e6                	ld	ra,88(sp)
    8000173e:	6446                	ld	s0,80(sp)
    80001740:	64a6                	ld	s1,72(sp)
    80001742:	6906                	ld	s2,64(sp)
    80001744:	79e2                	ld	s3,56(sp)
    80001746:	7a42                	ld	s4,48(sp)
    80001748:	7aa2                	ld	s5,40(sp)
    8000174a:	7b02                	ld	s6,32(sp)
    8000174c:	6be2                	ld	s7,24(sp)
    8000174e:	6c42                	ld	s8,16(sp)
    80001750:	6ca2                	ld	s9,8(sp)
    80001752:	6125                	addi	sp,sp,96
    80001754:	8082                	ret
  return 0;
    80001756:	4501                	li	a0,0
}
    80001758:	8082                	ret

000000008000175a <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000175a:	715d                	addi	sp,sp,-80
    8000175c:	e486                	sd	ra,72(sp)
    8000175e:	e0a2                	sd	s0,64(sp)
    80001760:	fc26                	sd	s1,56(sp)
    80001762:	f84a                	sd	s2,48(sp)
    80001764:	f44e                	sd	s3,40(sp)
    80001766:	f052                	sd	s4,32(sp)
    80001768:	ec56                	sd	s5,24(sp)
    8000176a:	e85a                	sd	s6,16(sp)
    8000176c:	e45e                	sd	s7,8(sp)
    8000176e:	0880                	addi	s0,sp,80
    80001770:	8aaa                	mv	s5,a0
    80001772:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001774:	ff4df937          	lui	s2,0xff4df
    80001778:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bdac5>
    8000177c:	0936                	slli	s2,s2,0xd
    8000177e:	6f590913          	addi	s2,s2,1781
    80001782:	0936                	slli	s2,s2,0xd
    80001784:	bd390913          	addi	s2,s2,-1069
    80001788:	0932                	slli	s2,s2,0xc
    8000178a:	7a790913          	addi	s2,s2,1959
    8000178e:	040009b7          	lui	s3,0x4000
    80001792:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001794:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001796:	4b99                	li	s7,6
    80001798:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    8000179a:	6a19                	lui	s4,0x6
    8000179c:	c00a0a13          	addi	s4,s4,-1024 # 5c00 <_entry-0x7fffa400>
    char *pa = kalloc();
    800017a0:	b9eff0ef          	jal	80000b3e <kalloc>
    800017a4:	862a                	mv	a2,a0
    if (pa == 0)
    800017a6:	cd15                	beqz	a0,800017e2 <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017a8:	4044d593          	srai	a1,s1,0x4
    800017ac:	032585b3          	mul	a1,a1,s2
    800017b0:	05b6                	slli	a1,a1,0xd
    800017b2:	6789                	lui	a5,0x2
    800017b4:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017b6:	875e                	mv	a4,s7
    800017b8:	86da                	mv	a3,s6
    800017ba:	40b985b3          	sub	a1,s3,a1
    800017be:	8556                	mv	a0,s5
    800017c0:	91fff0ef          	jal	800010de <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017c4:	17048493          	addi	s1,s1,368
    800017c8:	fd449ce3          	bne	s1,s4,800017a0 <proc_mapstacks+0x46>
  }
}
    800017cc:	60a6                	ld	ra,72(sp)
    800017ce:	6406                	ld	s0,64(sp)
    800017d0:	74e2                	ld	s1,56(sp)
    800017d2:	7942                	ld	s2,48(sp)
    800017d4:	79a2                	ld	s3,40(sp)
    800017d6:	7a02                	ld	s4,32(sp)
    800017d8:	6ae2                	ld	s5,24(sp)
    800017da:	6b42                	ld	s6,16(sp)
    800017dc:	6ba2                	ld	s7,8(sp)
    800017de:	6161                	addi	sp,sp,80
    800017e0:	8082                	ret
      panic("kalloc");
    800017e2:	00006517          	auipc	a0,0x6
    800017e6:	97650513          	addi	a0,a0,-1674 # 80007158 <etext+0x158>
    800017ea:	850ff0ef          	jal	8000083a <panic>

00000000800017ee <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017ee:	7139                	addi	sp,sp,-64
    800017f0:	fc06                	sd	ra,56(sp)
    800017f2:	f822                	sd	s0,48(sp)
    800017f4:	f426                	sd	s1,40(sp)
    800017f6:	f04a                	sd	s2,32(sp)
    800017f8:	ec4e                	sd	s3,24(sp)
    800017fa:	e852                	sd	s4,16(sp)
    800017fc:	e456                	sd	s5,8(sp)
    800017fe:	e05a                	sd	s6,0(sp)
    80001800:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001802:	00006597          	auipc	a1,0x6
    80001806:	95e58593          	addi	a1,a1,-1698 # 80007160 <etext+0x160>
    8000180a:	0000e517          	auipc	a0,0xe
    8000180e:	2de50513          	addi	a0,a0,734 # 8000fae8 <pid_lock>
    80001812:	b86ff0ef          	jal	80000b98 <initlock>
  initlock(&wait_lock, "wait_lock");
    80001816:	00006597          	auipc	a1,0x6
    8000181a:	95258593          	addi	a1,a1,-1710 # 80007168 <etext+0x168>
    8000181e:	0000e517          	auipc	a0,0xe
    80001822:	2e250513          	addi	a0,a0,738 # 8000fb00 <wait_lock>
    80001826:	b72ff0ef          	jal	80000b98 <initlock>
    8000182a:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    8000182c:	0000e497          	auipc	s1,0xe
    80001830:	6ec48493          	addi	s1,s1,1772 # 8000ff18 <proc>
    initlock(&p->lock, "proc");
    80001834:	00006a97          	auipc	s5,0x6
    80001838:	944a8a93          	addi	s5,s5,-1724 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    8000183c:	ff4df9b7          	lui	s3,0xff4df
    80001840:	9bd98993          	addi	s3,s3,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bdac5>
    80001844:	09b6                	slli	s3,s3,0xd
    80001846:	6f598993          	addi	s3,s3,1781
    8000184a:	09b6                	slli	s3,s3,0xd
    8000184c:	bd398993          	addi	s3,s3,-1069
    80001850:	09b2                	slli	s3,s3,0xc
    80001852:	7a798993          	addi	s3,s3,1959
    80001856:	04000a37          	lui	s4,0x4000
    8000185a:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    8000185c:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    8000185e:	00014b17          	auipc	s6,0x14
    80001862:	2bab0b13          	addi	s6,s6,698 # 80015b18 <tickslock>
    initlock(&p->lock, "proc");
    80001866:	85d6                	mv	a1,s5
    80001868:	8526                	mv	a0,s1
    8000186a:	b2eff0ef          	jal	80000b98 <initlock>
    p->state = UNUSED;
    8000186e:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001872:	40495793          	srai	a5,s2,0x4
    80001876:	033787b3          	mul	a5,a5,s3
    8000187a:	07b6                	slli	a5,a5,0xd
    8000187c:	6709                	lui	a4,0x2
    8000187e:	9fb9                	addw	a5,a5,a4
    80001880:	40fa07b3          	sub	a5,s4,a5
    80001884:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    80001886:	17048493          	addi	s1,s1,368
    8000188a:	17090913          	addi	s2,s2,368
    8000188e:	fd649ce3          	bne	s1,s6,80001866 <procinit+0x78>
  }
}
    80001892:	70e2                	ld	ra,56(sp)
    80001894:	7442                	ld	s0,48(sp)
    80001896:	74a2                	ld	s1,40(sp)
    80001898:	7902                	ld	s2,32(sp)
    8000189a:	69e2                	ld	s3,24(sp)
    8000189c:	6a42                	ld	s4,16(sp)
    8000189e:	6aa2                	ld	s5,8(sp)
    800018a0:	6b02                	ld	s6,0(sp)
    800018a2:	6121                	addi	sp,sp,64
    800018a4:	8082                	ret

00000000800018a6 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018a6:	1141                	addi	sp,sp,-16
    800018a8:	e406                	sd	ra,8(sp)
    800018aa:	e022                	sd	s0,0(sp)
    800018ac:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018ae:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b0:	2501                	sext.w	a0,a0
    800018b2:	60a2                	ld	ra,8(sp)
    800018b4:	6402                	ld	s0,0(sp)
    800018b6:	0141                	addi	sp,sp,16
    800018b8:	8082                	ret

00000000800018ba <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018ba:	1141                	addi	sp,sp,-16
    800018bc:	e406                	sd	ra,8(sp)
    800018be:	e022                	sd	s0,0(sp)
    800018c0:	0800                	addi	s0,sp,16
    800018c2:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c4:	2781                	sext.w	a5,a5
    800018c6:	079e                	slli	a5,a5,0x7
  return c;
}
    800018c8:	0000e517          	auipc	a0,0xe
    800018cc:	25050513          	addi	a0,a0,592 # 8000fb18 <cpus>
    800018d0:	953e                	add	a0,a0,a5
    800018d2:	60a2                	ld	ra,8(sp)
    800018d4:	6402                	ld	s0,0(sp)
    800018d6:	0141                	addi	sp,sp,16
    800018d8:	8082                	ret

00000000800018da <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800018da:	1101                	addi	sp,sp,-32
    800018dc:	ec06                	sd	ra,24(sp)
    800018de:	e822                	sd	s0,16(sp)
    800018e0:	e426                	sd	s1,8(sp)
    800018e2:	1000                	addi	s0,sp,32
  push_off();
    800018e4:	afaff0ef          	jal	80000bde <push_off>
    800018e8:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ea:	2781                	sext.w	a5,a5
    800018ec:	079e                	slli	a5,a5,0x7
    800018ee:	0000e717          	auipc	a4,0xe
    800018f2:	1fa70713          	addi	a4,a4,506 # 8000fae8 <pid_lock>
    800018f6:	97ba                	add	a5,a5,a4
    800018f8:	7b9c                	ld	a5,48(a5)
    800018fa:	84be                	mv	s1,a5
  pop_off();
    800018fc:	b58ff0ef          	jal	80000c54 <pop_off>
  return p;
}
    80001900:	8526                	mv	a0,s1
    80001902:	60e2                	ld	ra,24(sp)
    80001904:	6442                	ld	s0,16(sp)
    80001906:	64a2                	ld	s1,8(sp)
    80001908:	6105                	addi	sp,sp,32
    8000190a:	8082                	ret

000000008000190c <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000190c:	7179                	addi	sp,sp,-48
    8000190e:	f406                	sd	ra,40(sp)
    80001910:	f022                	sd	s0,32(sp)
    80001912:	ec26                	sd	s1,24(sp)
    80001914:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001916:	fc5ff0ef          	jal	800018da <myproc>
    8000191a:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000191c:	b80ff0ef          	jal	80000c9c <release>

  if (first) {
    80001920:	00006797          	auipc	a5,0x6
    80001924:	0907a783          	lw	a5,144(a5) # 800079b0 <first.1>
    80001928:	cf95                	beqz	a5,80001964 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000192a:	4505                	li	a0,1
    8000192c:	3f7010ef          	jal	80003522 <fsinit>

    first = 0;
    80001930:	00006797          	auipc	a5,0x6
    80001934:	0807a023          	sw	zero,128(a5) # 800079b0 <first.1>
    // ensure other cores see first=0.
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80001938:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    8000193c:	00006797          	auipc	a5,0x6
    80001940:	84478793          	addi	a5,a5,-1980 # 80007180 <etext+0x180>
    80001944:	fcf43823          	sd	a5,-48(s0)
    80001948:	fc043c23          	sd	zero,-40(s0)
    8000194c:	fd040593          	addi	a1,s0,-48
    80001950:	853e                	mv	a0,a5
    80001952:	5b1020ef          	jal	80004702 <kexec>
    80001956:	6cbc                	ld	a5,88(s1)
    80001958:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000195a:	6cbc                	ld	a5,88(s1)
    8000195c:	7bb8                	ld	a4,112(a5)
    8000195e:	57fd                	li	a5,-1
    80001960:	02f70d63          	beq	a4,a5,8000199a <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001964:	2a7000ef          	jal	8000240a <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001968:	68a8                	ld	a0,80(s1)
    8000196a:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000196c:	04000737          	lui	a4,0x4000
    80001970:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001972:	0732                	slli	a4,a4,0xc
    80001974:	00004797          	auipc	a5,0x4
    80001978:	72878793          	addi	a5,a5,1832 # 8000609c <userret>
    8000197c:	00004697          	auipc	a3,0x4
    80001980:	68468693          	addi	a3,a3,1668 # 80006000 <_trampoline>
    80001984:	8f95                	sub	a5,a5,a3
    80001986:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80001988:	577d                	li	a4,-1
    8000198a:	177e                	slli	a4,a4,0x3f
    8000198c:	8d59                	or	a0,a0,a4
    8000198e:	9782                	jalr	a5
}
    80001990:	70a2                	ld	ra,40(sp)
    80001992:	7402                	ld	s0,32(sp)
    80001994:	64e2                	ld	s1,24(sp)
    80001996:	6145                	addi	sp,sp,48
    80001998:	8082                	ret
      panic("exec");
    8000199a:	00005517          	auipc	a0,0x5
    8000199e:	7ee50513          	addi	a0,a0,2030 # 80007188 <etext+0x188>
    800019a2:	e99fe0ef          	jal	8000083a <panic>

00000000800019a6 <allocpid>:
{
    800019a6:	1101                	addi	sp,sp,-32
    800019a8:	ec06                	sd	ra,24(sp)
    800019aa:	e822                	sd	s0,16(sp)
    800019ac:	e426                	sd	s1,8(sp)
    800019ae:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019b0:	0000e517          	auipc	a0,0xe
    800019b4:	13850513          	addi	a0,a0,312 # 8000fae8 <pid_lock>
    800019b8:	a60ff0ef          	jal	80000c18 <acquire>
  pid = nextpid;
    800019bc:	00006797          	auipc	a5,0x6
    800019c0:	ff878793          	addi	a5,a5,-8 # 800079b4 <nextpid>
    800019c4:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019c6:	0014871b          	addiw	a4,s1,1
    800019ca:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019cc:	0000e517          	auipc	a0,0xe
    800019d0:	11c50513          	addi	a0,a0,284 # 8000fae8 <pid_lock>
    800019d4:	ac8ff0ef          	jal	80000c9c <release>
}
    800019d8:	8526                	mv	a0,s1
    800019da:	60e2                	ld	ra,24(sp)
    800019dc:	6442                	ld	s0,16(sp)
    800019de:	64a2                	ld	s1,8(sp)
    800019e0:	6105                	addi	sp,sp,32
    800019e2:	8082                	ret

00000000800019e4 <proc_pagetable>:
{
    800019e4:	1101                	addi	sp,sp,-32
    800019e6:	ec06                	sd	ra,24(sp)
    800019e8:	e822                	sd	s0,16(sp)
    800019ea:	e426                	sd	s1,8(sp)
    800019ec:	e04a                	sd	s2,0(sp)
    800019ee:	1000                	addi	s0,sp,32
    800019f0:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019f2:	fdaff0ef          	jal	800011cc <uvmcreate>
    800019f6:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800019f8:	cd05                	beqz	a0,80001a30 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800019fa:	4729                	li	a4,10
    800019fc:	00004697          	auipc	a3,0x4
    80001a00:	60468693          	addi	a3,a3,1540 # 80006000 <_trampoline>
    80001a04:	6605                	lui	a2,0x1
    80001a06:	040005b7          	lui	a1,0x4000
    80001a0a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a0c:	05b2                	slli	a1,a1,0xc
    80001a0e:	e1eff0ef          	jal	8000102c <mappages>
    80001a12:	02054663          	bltz	a0,80001a3e <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a16:	4719                	li	a4,6
    80001a18:	05893683          	ld	a3,88(s2)
    80001a1c:	6605                	lui	a2,0x1
    80001a1e:	020005b7          	lui	a1,0x2000
    80001a22:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a24:	05b6                	slli	a1,a1,0xd
    80001a26:	8526                	mv	a0,s1
    80001a28:	e04ff0ef          	jal	8000102c <mappages>
    80001a2c:	00054f63          	bltz	a0,80001a4a <proc_pagetable+0x66>
}
    80001a30:	8526                	mv	a0,s1
    80001a32:	60e2                	ld	ra,24(sp)
    80001a34:	6442                	ld	s0,16(sp)
    80001a36:	64a2                	ld	s1,8(sp)
    80001a38:	6902                	ld	s2,0(sp)
    80001a3a:	6105                	addi	sp,sp,32
    80001a3c:	8082                	ret
    uvmfree(pagetable, 0);
    80001a3e:	4581                	li	a1,0
    80001a40:	8526                	mv	a0,s1
    80001a42:	97dff0ef          	jal	800013be <uvmfree>
    return 0;
    80001a46:	4481                	li	s1,0
    80001a48:	b7e5                	j	80001a30 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a4a:	4681                	li	a3,0
    80001a4c:	4605                	li	a2,1
    80001a4e:	040005b7          	lui	a1,0x4000
    80001a52:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a54:	05b2                	slli	a1,a1,0xc
    80001a56:	8526                	mv	a0,s1
    80001a58:	f9aff0ef          	jal	800011f2 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a5c:	4581                	li	a1,0
    80001a5e:	8526                	mv	a0,s1
    80001a60:	95fff0ef          	jal	800013be <uvmfree>
    return 0;
    80001a64:	b7cd                	j	80001a46 <proc_pagetable+0x62>

0000000080001a66 <proc_freepagetable>:
{
    80001a66:	1101                	addi	sp,sp,-32
    80001a68:	ec06                	sd	ra,24(sp)
    80001a6a:	e822                	sd	s0,16(sp)
    80001a6c:	e426                	sd	s1,8(sp)
    80001a6e:	e04a                	sd	s2,0(sp)
    80001a70:	1000                	addi	s0,sp,32
    80001a72:	84aa                	mv	s1,a0
    80001a74:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a76:	4681                	li	a3,0
    80001a78:	4605                	li	a2,1
    80001a7a:	040005b7          	lui	a1,0x4000
    80001a7e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a80:	05b2                	slli	a1,a1,0xc
    80001a82:	f70ff0ef          	jal	800011f2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a86:	4681                	li	a3,0
    80001a88:	4605                	li	a2,1
    80001a8a:	020005b7          	lui	a1,0x2000
    80001a8e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a90:	05b6                	slli	a1,a1,0xd
    80001a92:	8526                	mv	a0,s1
    80001a94:	f5eff0ef          	jal	800011f2 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a98:	85ca                	mv	a1,s2
    80001a9a:	8526                	mv	a0,s1
    80001a9c:	923ff0ef          	jal	800013be <uvmfree>
}
    80001aa0:	60e2                	ld	ra,24(sp)
    80001aa2:	6442                	ld	s0,16(sp)
    80001aa4:	64a2                	ld	s1,8(sp)
    80001aa6:	6902                	ld	s2,0(sp)
    80001aa8:	6105                	addi	sp,sp,32
    80001aaa:	8082                	ret

0000000080001aac <freeproc>:
{
    80001aac:	1101                	addi	sp,sp,-32
    80001aae:	ec06                	sd	ra,24(sp)
    80001ab0:	e822                	sd	s0,16(sp)
    80001ab2:	e426                	sd	s1,8(sp)
    80001ab4:	1000                	addi	s0,sp,32
    80001ab6:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001ab8:	6d28                	ld	a0,88(a0)
    80001aba:	c119                	beqz	a0,80001ac0 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001abc:	f9bfe0ef          	jal	80000a56 <kfree>
  p->trapframe = 0;
    80001ac0:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ac4:	68a8                	ld	a0,80(s1)
    80001ac6:	c501                	beqz	a0,80001ace <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001ac8:	64ac                	ld	a1,72(s1)
    80001aca:	f9dff0ef          	jal	80001a66 <proc_freepagetable>
  p->pagetable = 0;
    80001ace:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ad2:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ad6:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ada:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ade:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ae2:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001ae6:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001aea:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001aee:	0004ac23          	sw	zero,24(s1)
  p->tracing = 0;
    80001af2:	1604a423          	sw	zero,360(s1)
}
    80001af6:	60e2                	ld	ra,24(sp)
    80001af8:	6442                	ld	s0,16(sp)
    80001afa:	64a2                	ld	s1,8(sp)
    80001afc:	6105                	addi	sp,sp,32
    80001afe:	8082                	ret

0000000080001b00 <allocproc>:
{
    80001b00:	1101                	addi	sp,sp,-32
    80001b02:	ec06                	sd	ra,24(sp)
    80001b04:	e822                	sd	s0,16(sp)
    80001b06:	e426                	sd	s1,8(sp)
    80001b08:	e04a                	sd	s2,0(sp)
    80001b0a:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b0c:	0000e497          	auipc	s1,0xe
    80001b10:	40c48493          	addi	s1,s1,1036 # 8000ff18 <proc>
    80001b14:	00014917          	auipc	s2,0x14
    80001b18:	00490913          	addi	s2,s2,4 # 80015b18 <tickslock>
    acquire(&p->lock);
    80001b1c:	8526                	mv	a0,s1
    80001b1e:	8faff0ef          	jal	80000c18 <acquire>
    if (p->state == UNUSED) {
    80001b22:	4c9c                	lw	a5,24(s1)
    80001b24:	cb91                	beqz	a5,80001b38 <allocproc+0x38>
      release(&p->lock);
    80001b26:	8526                	mv	a0,s1
    80001b28:	974ff0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b2c:	17048493          	addi	s1,s1,368
    80001b30:	ff2496e3          	bne	s1,s2,80001b1c <allocproc+0x1c>
  return 0;
    80001b34:	4481                	li	s1,0
    80001b36:	a099                	j	80001b7c <allocproc+0x7c>
  p->pid = allocpid();
    80001b38:	e6fff0ef          	jal	800019a6 <allocpid>
    80001b3c:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b3e:	4785                	li	a5,1
    80001b40:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b42:	ffdfe0ef          	jal	80000b3e <kalloc>
    80001b46:	892a                	mv	s2,a0
    80001b48:	eca8                	sd	a0,88(s1)
    80001b4a:	c121                	beqz	a0,80001b8a <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001b4c:	8526                	mv	a0,s1
    80001b4e:	e97ff0ef          	jal	800019e4 <proc_pagetable>
    80001b52:	892a                	mv	s2,a0
    80001b54:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b56:	c131                	beqz	a0,80001b9a <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001b58:	07000613          	li	a2,112
    80001b5c:	4581                	li	a1,0
    80001b5e:	06048513          	addi	a0,s1,96
    80001b62:	972ff0ef          	jal	80000cd4 <memset>
  p->context.ra = (uint64)forkret;
    80001b66:	00000797          	auipc	a5,0x0
    80001b6a:	da678793          	addi	a5,a5,-602 # 8000190c <forkret>
    80001b6e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b70:	60bc                	ld	a5,64(s1)
    80001b72:	6705                	lui	a4,0x1
    80001b74:	97ba                	add	a5,a5,a4
    80001b76:	f4bc                	sd	a5,104(s1)
  p->tracing = 0;
    80001b78:	1604a423          	sw	zero,360(s1)
}
    80001b7c:	8526                	mv	a0,s1
    80001b7e:	60e2                	ld	ra,24(sp)
    80001b80:	6442                	ld	s0,16(sp)
    80001b82:	64a2                	ld	s1,8(sp)
    80001b84:	6902                	ld	s2,0(sp)
    80001b86:	6105                	addi	sp,sp,32
    80001b88:	8082                	ret
    freeproc(p);
    80001b8a:	8526                	mv	a0,s1
    80001b8c:	f21ff0ef          	jal	80001aac <freeproc>
    release(&p->lock);
    80001b90:	8526                	mv	a0,s1
    80001b92:	90aff0ef          	jal	80000c9c <release>
    return 0;
    80001b96:	84ca                	mv	s1,s2
    80001b98:	b7d5                	j	80001b7c <allocproc+0x7c>
    freeproc(p);
    80001b9a:	8526                	mv	a0,s1
    80001b9c:	f11ff0ef          	jal	80001aac <freeproc>
    release(&p->lock);
    80001ba0:	8526                	mv	a0,s1
    80001ba2:	8faff0ef          	jal	80000c9c <release>
    return 0;
    80001ba6:	84ca                	mv	s1,s2
    80001ba8:	bfd1                	j	80001b7c <allocproc+0x7c>

0000000080001baa <userinit>:
{
    80001baa:	1101                	addi	sp,sp,-32
    80001bac:	ec06                	sd	ra,24(sp)
    80001bae:	e822                	sd	s0,16(sp)
    80001bb0:	e426                	sd	s1,8(sp)
    80001bb2:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bb4:	f4dff0ef          	jal	80001b00 <allocproc>
    80001bb8:	84aa                	mv	s1,a0
  initproc = p;
    80001bba:	00006797          	auipc	a5,0x6
    80001bbe:	e2a7b323          	sd	a0,-474(a5) # 800079e0 <initproc>
  p->cwd = namei("/");
    80001bc2:	00005517          	auipc	a0,0x5
    80001bc6:	5ce50513          	addi	a0,a0,1486 # 80007190 <etext+0x190>
    80001bca:	69d010ef          	jal	80003a66 <namei>
    80001bce:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bd2:	478d                	li	a5,3
    80001bd4:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	8c4ff0ef          	jal	80000c9c <release>
}
    80001bdc:	60e2                	ld	ra,24(sp)
    80001bde:	6442                	ld	s0,16(sp)
    80001be0:	64a2                	ld	s1,8(sp)
    80001be2:	6105                	addi	sp,sp,32
    80001be4:	8082                	ret

0000000080001be6 <growproc>:
{
    80001be6:	1101                	addi	sp,sp,-32
    80001be8:	ec06                	sd	ra,24(sp)
    80001bea:	e822                	sd	s0,16(sp)
    80001bec:	e426                	sd	s1,8(sp)
    80001bee:	e04a                	sd	s2,0(sp)
    80001bf0:	1000                	addi	s0,sp,32
    80001bf2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bf4:	ce7ff0ef          	jal	800018da <myproc>
    80001bf8:	892a                	mv	s2,a0
  sz = p->sz;
    80001bfa:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001bfc:	02905b63          	blez	s1,80001c32 <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001c00:	00b48633          	add	a2,s1,a1
    80001c04:	020007b7          	lui	a5,0x2000
    80001c08:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c0a:	07b6                	slli	a5,a5,0xd
    80001c0c:	02c7e163          	bltu	a5,a2,80001c2e <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c10:	4691                	li	a3,4
    80001c12:	6928                	ld	a0,80(a0)
    80001c14:	eaeff0ef          	jal	800012c2 <uvmalloc>
    80001c18:	85aa                	mv	a1,a0
    80001c1a:	c911                	beqz	a0,80001c2e <growproc+0x48>
  p->sz = sz;
    80001c1c:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c20:	4501                	li	a0,0
}
    80001c22:	60e2                	ld	ra,24(sp)
    80001c24:	6442                	ld	s0,16(sp)
    80001c26:	64a2                	ld	s1,8(sp)
    80001c28:	6902                	ld	s2,0(sp)
    80001c2a:	6105                	addi	sp,sp,32
    80001c2c:	8082                	ret
      return -1;
    80001c2e:	557d                	li	a0,-1
    80001c30:	bfcd                	j	80001c22 <growproc+0x3c>
  } else if (n < 0) {
    80001c32:	fe04d5e3          	bgez	s1,80001c1c <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c36:	00b48633          	add	a2,s1,a1
    80001c3a:	6928                	ld	a0,80(a0)
    80001c3c:	e40ff0ef          	jal	8000127c <uvmdealloc>
    80001c40:	85aa                	mv	a1,a0
    80001c42:	bfe9                	j	80001c1c <growproc+0x36>

0000000080001c44 <kfork>:
{
    80001c44:	7139                	addi	sp,sp,-64
    80001c46:	fc06                	sd	ra,56(sp)
    80001c48:	f822                	sd	s0,48(sp)
    80001c4a:	f426                	sd	s1,40(sp)
    80001c4c:	e456                	sd	s5,8(sp)
    80001c4e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c50:	c8bff0ef          	jal	800018da <myproc>
    80001c54:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c56:	eabff0ef          	jal	80001b00 <allocproc>
    80001c5a:	c92d                	beqz	a0,80001ccc <kfork+0x88>
    80001c5c:	ec4e                	sd	s3,24(sp)
    80001c5e:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c60:	048ab603          	ld	a2,72(s5)
    80001c64:	692c                	ld	a1,80(a0)
    80001c66:	050ab503          	ld	a0,80(s5)
    80001c6a:	f86ff0ef          	jal	800013f0 <uvmcopy>
    80001c6e:	04054863          	bltz	a0,80001cbe <kfork+0x7a>
    80001c72:	f04a                	sd	s2,32(sp)
    80001c74:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c76:	048ab783          	ld	a5,72(s5)
    80001c7a:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001c7e:	058ab683          	ld	a3,88(s5)
    80001c82:	87b6                	mv	a5,a3
    80001c84:	0589b703          	ld	a4,88(s3)
    80001c88:	12068693          	addi	a3,a3,288
    80001c8c:	6388                	ld	a0,0(a5)
    80001c8e:	678c                	ld	a1,8(a5)
    80001c90:	6b90                	ld	a2,16(a5)
    80001c92:	e308                	sd	a0,0(a4)
    80001c94:	e70c                	sd	a1,8(a4)
    80001c96:	eb10                	sd	a2,16(a4)
    80001c98:	6f90                	ld	a2,24(a5)
    80001c9a:	ef10                	sd	a2,24(a4)
    80001c9c:	02078793          	addi	a5,a5,32
    80001ca0:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001ca4:	fed794e3          	bne	a5,a3,80001c8c <kfork+0x48>
  np->trapframe->a0 = 0;
    80001ca8:	0589b783          	ld	a5,88(s3)
    80001cac:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cb0:	0d0a8493          	addi	s1,s5,208
    80001cb4:	0d098913          	addi	s2,s3,208
    80001cb8:	150a8a13          	addi	s4,s5,336
    80001cbc:	a831                	j	80001cd8 <kfork+0x94>
    freeproc(np);
    80001cbe:	854e                	mv	a0,s3
    80001cc0:	dedff0ef          	jal	80001aac <freeproc>
    release(&np->lock);
    80001cc4:	854e                	mv	a0,s3
    80001cc6:	fd7fe0ef          	jal	80000c9c <release>
    return -1;
    80001cca:	69e2                	ld	s3,24(sp)
    return -1;
    80001ccc:	54fd                	li	s1,-1
    80001cce:	a8a5                	j	80001d46 <kfork+0x102>
  for (i = 0; i < NOFILE; i++)
    80001cd0:	04a1                	addi	s1,s1,8
    80001cd2:	0921                	addi	s2,s2,8
    80001cd4:	01448963          	beq	s1,s4,80001ce6 <kfork+0xa2>
    if (p->ofile[i])
    80001cd8:	6088                	ld	a0,0(s1)
    80001cda:	d97d                	beqz	a0,80001cd0 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001cdc:	3a0020ef          	jal	8000407c <filedup>
    80001ce0:	00a93023          	sd	a0,0(s2)
    80001ce4:	b7f5                	j	80001cd0 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001ce6:	150ab503          	ld	a0,336(s5)
    80001cea:	50e010ef          	jal	800031f8 <idup>
    80001cee:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cf2:	4641                	li	a2,16
    80001cf4:	158a8593          	addi	a1,s5,344
    80001cf8:	15898513          	addi	a0,s3,344
    80001cfc:	922ff0ef          	jal	80000e1e <safestrcpy>
  np->tracing = p->tracing;
    80001d00:	168aa783          	lw	a5,360(s5)
    80001d04:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001d08:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001d0c:	854e                	mv	a0,s3
    80001d0e:	f8ffe0ef          	jal	80000c9c <release>
  acquire(&wait_lock);
    80001d12:	0000e517          	auipc	a0,0xe
    80001d16:	dee50513          	addi	a0,a0,-530 # 8000fb00 <wait_lock>
    80001d1a:	efffe0ef          	jal	80000c18 <acquire>
  np->parent = p;
    80001d1e:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d22:	0000e517          	auipc	a0,0xe
    80001d26:	dde50513          	addi	a0,a0,-546 # 8000fb00 <wait_lock>
    80001d2a:	f73fe0ef          	jal	80000c9c <release>
  acquire(&np->lock);
    80001d2e:	854e                	mv	a0,s3
    80001d30:	ee9fe0ef          	jal	80000c18 <acquire>
  np->state = RUNNABLE;
    80001d34:	478d                	li	a5,3
    80001d36:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001d3a:	854e                	mv	a0,s3
    80001d3c:	f61fe0ef          	jal	80000c9c <release>
    80001d40:	7902                	ld	s2,32(sp)
    80001d42:	69e2                	ld	s3,24(sp)
    80001d44:	6a42                	ld	s4,16(sp)
}
    80001d46:	8526                	mv	a0,s1
    80001d48:	70e2                	ld	ra,56(sp)
    80001d4a:	7442                	ld	s0,48(sp)
    80001d4c:	74a2                	ld	s1,40(sp)
    80001d4e:	6aa2                	ld	s5,8(sp)
    80001d50:	6121                	addi	sp,sp,64
    80001d52:	8082                	ret

0000000080001d54 <scheduler>:
{
    80001d54:	715d                	addi	sp,sp,-80
    80001d56:	e486                	sd	ra,72(sp)
    80001d58:	e0a2                	sd	s0,64(sp)
    80001d5a:	fc26                	sd	s1,56(sp)
    80001d5c:	f84a                	sd	s2,48(sp)
    80001d5e:	f44e                	sd	s3,40(sp)
    80001d60:	f052                	sd	s4,32(sp)
    80001d62:	ec56                	sd	s5,24(sp)
    80001d64:	e85a                	sd	s6,16(sp)
    80001d66:	e45e                	sd	s7,8(sp)
    80001d68:	e062                	sd	s8,0(sp)
    80001d6a:	0880                	addi	s0,sp,80
    80001d6c:	8792                	mv	a5,tp
  int id = r_tp();
    80001d6e:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d70:	00779693          	slli	a3,a5,0x7
    80001d74:	0000e717          	auipc	a4,0xe
    80001d78:	d7470713          	addi	a4,a4,-652 # 8000fae8 <pid_lock>
    80001d7c:	9736                	add	a4,a4,a3
    80001d7e:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d82:	0000eb17          	auipc	s6,0xe
    80001d86:	d9eb0b13          	addi	s6,s6,-610 # 8000fb20 <cpus+0x8>
    80001d8a:	9b36                	add	s6,s6,a3
        p->state = RUNNING;
    80001d8c:	4c11                	li	s8,4
        c->proc = p;
    80001d8e:	8a3a                	mv	s4,a4
        found = 1;
    80001d90:	4b85                	li	s7,1
    80001d92:	a83d                	j	80001dd0 <scheduler+0x7c>
      release(&p->lock);
    80001d94:	8526                	mv	a0,s1
    80001d96:	f07fe0ef          	jal	80000c9c <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001d9a:	17048493          	addi	s1,s1,368
    80001d9e:	03248563          	beq	s1,s2,80001dc8 <scheduler+0x74>
      acquire(&p->lock);
    80001da2:	8526                	mv	a0,s1
    80001da4:	e75fe0ef          	jal	80000c18 <acquire>
      if (p->state == RUNNABLE) {
    80001da8:	4c9c                	lw	a5,24(s1)
    80001daa:	ff3795e3          	bne	a5,s3,80001d94 <scheduler+0x40>
        p->state = RUNNING;
    80001dae:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001db2:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001db6:	06048593          	addi	a1,s1,96
    80001dba:	855a                	mv	a0,s6
    80001dbc:	5a4000ef          	jal	80002360 <swtch>
        c->proc = 0;
    80001dc0:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dc4:	8ade                	mv	s5,s7
    80001dc6:	b7f9                	j	80001d94 <scheduler+0x40>
    if (found == 0) {
    80001dc8:	000a9463          	bnez	s5,80001dd0 <scheduler+0x7c>
      asm volatile("wfi");
    80001dcc:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001dd0:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001dd4:	10017073          	csrci	sstatus,2
    int found = 0;
    80001dd8:	4a81                	li	s5,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dda:	0000e497          	auipc	s1,0xe
    80001dde:	13e48493          	addi	s1,s1,318 # 8000ff18 <proc>
      if (p->state == RUNNABLE) {
    80001de2:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001de4:	00014917          	auipc	s2,0x14
    80001de8:	d3490913          	addi	s2,s2,-716 # 80015b18 <tickslock>
    80001dec:	bf5d                	j	80001da2 <scheduler+0x4e>

0000000080001dee <sched>:
{
    80001dee:	7179                	addi	sp,sp,-48
    80001df0:	f406                	sd	ra,40(sp)
    80001df2:	f022                	sd	s0,32(sp)
    80001df4:	ec26                	sd	s1,24(sp)
    80001df6:	e84a                	sd	s2,16(sp)
    80001df8:	e44e                	sd	s3,8(sp)
    80001dfa:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001dfc:	adfff0ef          	jal	800018da <myproc>
    80001e00:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e02:	db1fe0ef          	jal	80000bb2 <holding>
    80001e06:	c92d                	beqz	a0,80001e78 <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e08:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e0a:	2781                	sext.w	a5,a5
    80001e0c:	079e                	slli	a5,a5,0x7
    80001e0e:	0000e717          	auipc	a4,0xe
    80001e12:	cda70713          	addi	a4,a4,-806 # 8000fae8 <pid_lock>
    80001e16:	97ba                	add	a5,a5,a4
    80001e18:	0a87a703          	lw	a4,168(a5)
    80001e1c:	4785                	li	a5,1
    80001e1e:	06f71363          	bne	a4,a5,80001e84 <sched+0x96>
  if (p->state == RUNNING)
    80001e22:	4c98                	lw	a4,24(s1)
    80001e24:	4791                	li	a5,4
    80001e26:	06f70563          	beq	a4,a5,80001e90 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e2a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e2e:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e30:	e7b5                	bnez	a5,80001e9c <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e32:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e34:	0000e917          	auipc	s2,0xe
    80001e38:	cb490913          	addi	s2,s2,-844 # 8000fae8 <pid_lock>
    80001e3c:	2781                	sext.w	a5,a5
    80001e3e:	079e                	slli	a5,a5,0x7
    80001e40:	97ca                	add	a5,a5,s2
    80001e42:	0ac7a983          	lw	s3,172(a5)
    80001e46:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e48:	2781                	sext.w	a5,a5
    80001e4a:	079e                	slli	a5,a5,0x7
    80001e4c:	0000e597          	auipc	a1,0xe
    80001e50:	cd458593          	addi	a1,a1,-812 # 8000fb20 <cpus+0x8>
    80001e54:	95be                	add	a1,a1,a5
    80001e56:	06048513          	addi	a0,s1,96
    80001e5a:	506000ef          	jal	80002360 <swtch>
    80001e5e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e60:	2781                	sext.w	a5,a5
    80001e62:	079e                	slli	a5,a5,0x7
    80001e64:	993e                	add	s2,s2,a5
    80001e66:	0b392623          	sw	s3,172(s2)
}
    80001e6a:	70a2                	ld	ra,40(sp)
    80001e6c:	7402                	ld	s0,32(sp)
    80001e6e:	64e2                	ld	s1,24(sp)
    80001e70:	6942                	ld	s2,16(sp)
    80001e72:	69a2                	ld	s3,8(sp)
    80001e74:	6145                	addi	sp,sp,48
    80001e76:	8082                	ret
    panic("sched p->lock");
    80001e78:	00005517          	auipc	a0,0x5
    80001e7c:	32050513          	addi	a0,a0,800 # 80007198 <etext+0x198>
    80001e80:	9bbfe0ef          	jal	8000083a <panic>
    panic("sched locks");
    80001e84:	00005517          	auipc	a0,0x5
    80001e88:	32450513          	addi	a0,a0,804 # 800071a8 <etext+0x1a8>
    80001e8c:	9affe0ef          	jal	8000083a <panic>
    panic("sched RUNNING");
    80001e90:	00005517          	auipc	a0,0x5
    80001e94:	32850513          	addi	a0,a0,808 # 800071b8 <etext+0x1b8>
    80001e98:	9a3fe0ef          	jal	8000083a <panic>
    panic("sched interruptible");
    80001e9c:	00005517          	auipc	a0,0x5
    80001ea0:	32c50513          	addi	a0,a0,812 # 800071c8 <etext+0x1c8>
    80001ea4:	997fe0ef          	jal	8000083a <panic>

0000000080001ea8 <yield>:
{
    80001ea8:	1101                	addi	sp,sp,-32
    80001eaa:	ec06                	sd	ra,24(sp)
    80001eac:	e822                	sd	s0,16(sp)
    80001eae:	e426                	sd	s1,8(sp)
    80001eb0:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eb2:	a29ff0ef          	jal	800018da <myproc>
    80001eb6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001eb8:	d61fe0ef          	jal	80000c18 <acquire>
  p->state = RUNNABLE;
    80001ebc:	478d                	li	a5,3
    80001ebe:	cc9c                	sw	a5,24(s1)
  sched();
    80001ec0:	f2fff0ef          	jal	80001dee <sched>
  release(&p->lock);
    80001ec4:	8526                	mv	a0,s1
    80001ec6:	dd7fe0ef          	jal	80000c9c <release>
}
    80001eca:	60e2                	ld	ra,24(sp)
    80001ecc:	6442                	ld	s0,16(sp)
    80001ece:	64a2                	ld	s1,8(sp)
    80001ed0:	6105                	addi	sp,sp,32
    80001ed2:	8082                	ret

0000000080001ed4 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ed4:	7179                	addi	sp,sp,-48
    80001ed6:	f406                	sd	ra,40(sp)
    80001ed8:	f022                	sd	s0,32(sp)
    80001eda:	ec26                	sd	s1,24(sp)
    80001edc:	e84a                	sd	s2,16(sp)
    80001ede:	e44e                	sd	s3,8(sp)
    80001ee0:	1800                	addi	s0,sp,48
    80001ee2:	89aa                	mv	s3,a0
    80001ee4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ee6:	9f5ff0ef          	jal	800018da <myproc>
    80001eea:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); //DOC: sleeplock1
    80001eec:	d2dfe0ef          	jal	80000c18 <acquire>
  release(lk);
    80001ef0:	854a                	mv	a0,s2
    80001ef2:	dabfe0ef          	jal	80000c9c <release>

  // Go to sleep.
  p->chan = chan;
    80001ef6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001efa:	4789                	li	a5,2
    80001efc:	cc9c                	sw	a5,24(s1)

  sched();
    80001efe:	ef1ff0ef          	jal	80001dee <sched>

  // Tidy up.
  p->chan = 0;
    80001f02:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f06:	8526                	mv	a0,s1
    80001f08:	d95fe0ef          	jal	80000c9c <release>
  acquire(lk);
    80001f0c:	854a                	mv	a0,s2
    80001f0e:	d0bfe0ef          	jal	80000c18 <acquire>
}
    80001f12:	70a2                	ld	ra,40(sp)
    80001f14:	7402                	ld	s0,32(sp)
    80001f16:	64e2                	ld	s1,24(sp)
    80001f18:	6942                	ld	s2,16(sp)
    80001f1a:	69a2                	ld	s3,8(sp)
    80001f1c:	6145                	addi	sp,sp,48
    80001f1e:	8082                	ret

0000000080001f20 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f20:	7139                	addi	sp,sp,-64
    80001f22:	fc06                	sd	ra,56(sp)
    80001f24:	f822                	sd	s0,48(sp)
    80001f26:	f426                	sd	s1,40(sp)
    80001f28:	f04a                	sd	s2,32(sp)
    80001f2a:	ec4e                	sd	s3,24(sp)
    80001f2c:	e852                	sd	s4,16(sp)
    80001f2e:	e456                	sd	s5,8(sp)
    80001f30:	0080                	addi	s0,sp,64
    80001f32:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f34:	0000e497          	auipc	s1,0xe
    80001f38:	fe448493          	addi	s1,s1,-28 # 8000ff18 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001f3c:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f3e:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f40:	00014917          	auipc	s2,0x14
    80001f44:	bd890913          	addi	s2,s2,-1064 # 80015b18 <tickslock>
    80001f48:	a801                	j	80001f58 <wakeup+0x38>
      }
      release(&p->lock);
    80001f4a:	8526                	mv	a0,s1
    80001f4c:	d51fe0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f50:	17048493          	addi	s1,s1,368
    80001f54:	03248263          	beq	s1,s2,80001f78 <wakeup+0x58>
    if (p != myproc()) {
    80001f58:	983ff0ef          	jal	800018da <myproc>
    80001f5c:	fe950ae3          	beq	a0,s1,80001f50 <wakeup+0x30>
      acquire(&p->lock);
    80001f60:	8526                	mv	a0,s1
    80001f62:	cb7fe0ef          	jal	80000c18 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001f66:	4c9c                	lw	a5,24(s1)
    80001f68:	ff3791e3          	bne	a5,s3,80001f4a <wakeup+0x2a>
    80001f6c:	709c                	ld	a5,32(s1)
    80001f6e:	fd479ee3          	bne	a5,s4,80001f4a <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f72:	0154ac23          	sw	s5,24(s1)
    80001f76:	bfd1                	j	80001f4a <wakeup+0x2a>
    }
  }
}
    80001f78:	70e2                	ld	ra,56(sp)
    80001f7a:	7442                	ld	s0,48(sp)
    80001f7c:	74a2                	ld	s1,40(sp)
    80001f7e:	7902                	ld	s2,32(sp)
    80001f80:	69e2                	ld	s3,24(sp)
    80001f82:	6a42                	ld	s4,16(sp)
    80001f84:	6aa2                	ld	s5,8(sp)
    80001f86:	6121                	addi	sp,sp,64
    80001f88:	8082                	ret

0000000080001f8a <reparent>:
{
    80001f8a:	7179                	addi	sp,sp,-48
    80001f8c:	f406                	sd	ra,40(sp)
    80001f8e:	f022                	sd	s0,32(sp)
    80001f90:	ec26                	sd	s1,24(sp)
    80001f92:	e84a                	sd	s2,16(sp)
    80001f94:	e44e                	sd	s3,8(sp)
    80001f96:	e052                	sd	s4,0(sp)
    80001f98:	1800                	addi	s0,sp,48
    80001f9a:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001f9c:	0000e497          	auipc	s1,0xe
    80001fa0:	f7c48493          	addi	s1,s1,-132 # 8000ff18 <proc>
      pp->parent = initproc;
    80001fa4:	00006a17          	auipc	s4,0x6
    80001fa8:	a3ca0a13          	addi	s4,s4,-1476 # 800079e0 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fac:	00014997          	auipc	s3,0x14
    80001fb0:	b6c98993          	addi	s3,s3,-1172 # 80015b18 <tickslock>
    80001fb4:	a029                	j	80001fbe <reparent+0x34>
    80001fb6:	17048493          	addi	s1,s1,368
    80001fba:	01348b63          	beq	s1,s3,80001fd0 <reparent+0x46>
    if (pp->parent == p) {
    80001fbe:	7c9c                	ld	a5,56(s1)
    80001fc0:	ff279be3          	bne	a5,s2,80001fb6 <reparent+0x2c>
      pp->parent = initproc;
    80001fc4:	000a3503          	ld	a0,0(s4)
    80001fc8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fca:	f57ff0ef          	jal	80001f20 <wakeup>
    80001fce:	b7e5                	j	80001fb6 <reparent+0x2c>
}
    80001fd0:	70a2                	ld	ra,40(sp)
    80001fd2:	7402                	ld	s0,32(sp)
    80001fd4:	64e2                	ld	s1,24(sp)
    80001fd6:	6942                	ld	s2,16(sp)
    80001fd8:	69a2                	ld	s3,8(sp)
    80001fda:	6a02                	ld	s4,0(sp)
    80001fdc:	6145                	addi	sp,sp,48
    80001fde:	8082                	ret

0000000080001fe0 <kexit>:
{
    80001fe0:	7179                	addi	sp,sp,-48
    80001fe2:	f406                	sd	ra,40(sp)
    80001fe4:	f022                	sd	s0,32(sp)
    80001fe6:	ec26                	sd	s1,24(sp)
    80001fe8:	e84a                	sd	s2,16(sp)
    80001fea:	e44e                	sd	s3,8(sp)
    80001fec:	e052                	sd	s4,0(sp)
    80001fee:	1800                	addi	s0,sp,48
    80001ff0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ff2:	8e9ff0ef          	jal	800018da <myproc>
    80001ff6:	89aa                	mv	s3,a0
  if (p == initproc)
    80001ff8:	00006797          	auipc	a5,0x6
    80001ffc:	9e87b783          	ld	a5,-1560(a5) # 800079e0 <initproc>
    80002000:	0d050493          	addi	s1,a0,208
    80002004:	15050913          	addi	s2,a0,336
    80002008:	00a79b63          	bne	a5,a0,8000201e <kexit+0x3e>
    panic("init exiting");
    8000200c:	00005517          	auipc	a0,0x5
    80002010:	1d450513          	addi	a0,a0,468 # 800071e0 <etext+0x1e0>
    80002014:	827fe0ef          	jal	8000083a <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    80002018:	04a1                	addi	s1,s1,8
    8000201a:	01248963          	beq	s1,s2,8000202c <kexit+0x4c>
    if (p->ofile[fd]) {
    8000201e:	6088                	ld	a0,0(s1)
    80002020:	dd65                	beqz	a0,80002018 <kexit+0x38>
      fileclose(f);
    80002022:	0a0020ef          	jal	800040c2 <fileclose>
      p->ofile[fd] = 0;
    80002026:	0004b023          	sd	zero,0(s1)
    8000202a:	b7fd                	j	80002018 <kexit+0x38>
  begin_op();
    8000202c:	419010ef          	jal	80003c44 <begin_op>
  iput(p->cwd);
    80002030:	1509b503          	ld	a0,336(s3)
    80002034:	37c010ef          	jal	800033b0 <iput>
  end_op();
    80002038:	47d010ef          	jal	80003cb4 <end_op>
  p->cwd = 0;
    8000203c:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002040:	0000e517          	auipc	a0,0xe
    80002044:	ac050513          	addi	a0,a0,-1344 # 8000fb00 <wait_lock>
    80002048:	bd1fe0ef          	jal	80000c18 <acquire>
  reparent(p);
    8000204c:	854e                	mv	a0,s3
    8000204e:	f3dff0ef          	jal	80001f8a <reparent>
  wakeup(p->parent);
    80002052:	0389b503          	ld	a0,56(s3)
    80002056:	ecbff0ef          	jal	80001f20 <wakeup>
  acquire(&p->lock);
    8000205a:	854e                	mv	a0,s3
    8000205c:	bbdfe0ef          	jal	80000c18 <acquire>
  p->xstate = status;
    80002060:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002064:	4795                	li	a5,5
    80002066:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000206a:	0000e517          	auipc	a0,0xe
    8000206e:	a9650513          	addi	a0,a0,-1386 # 8000fb00 <wait_lock>
    80002072:	c2bfe0ef          	jal	80000c9c <release>
  sched();
    80002076:	d79ff0ef          	jal	80001dee <sched>
  panic("zombie exit");
    8000207a:	00005517          	auipc	a0,0x5
    8000207e:	17650513          	addi	a0,a0,374 # 800071f0 <etext+0x1f0>
    80002082:	fb8fe0ef          	jal	8000083a <panic>

0000000080002086 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80002086:	7179                	addi	sp,sp,-48
    80002088:	f406                	sd	ra,40(sp)
    8000208a:	f022                	sd	s0,32(sp)
    8000208c:	ec26                	sd	s1,24(sp)
    8000208e:	e84a                	sd	s2,16(sp)
    80002090:	e44e                	sd	s3,8(sp)
    80002092:	1800                	addi	s0,sp,48
    80002094:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80002096:	0000e497          	auipc	s1,0xe
    8000209a:	e8248493          	addi	s1,s1,-382 # 8000ff18 <proc>
    8000209e:	00014997          	auipc	s3,0x14
    800020a2:	a7a98993          	addi	s3,s3,-1414 # 80015b18 <tickslock>
    acquire(&p->lock);
    800020a6:	8526                	mv	a0,s1
    800020a8:	b71fe0ef          	jal	80000c18 <acquire>
    if (p->pid == pid) {
    800020ac:	589c                	lw	a5,48(s1)
    800020ae:	01278b63          	beq	a5,s2,800020c4 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020b2:	8526                	mv	a0,s1
    800020b4:	be9fe0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020b8:	17048493          	addi	s1,s1,368
    800020bc:	ff3495e3          	bne	s1,s3,800020a6 <kkill+0x20>
  }
  return -1;
    800020c0:	557d                	li	a0,-1
    800020c2:	a819                	j	800020d8 <kkill+0x52>
      p->killed = 1;
    800020c4:	4785                	li	a5,1
    800020c6:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800020c8:	4c98                	lw	a4,24(s1)
    800020ca:	4789                	li	a5,2
    800020cc:	00f70d63          	beq	a4,a5,800020e6 <kkill+0x60>
      release(&p->lock);
    800020d0:	8526                	mv	a0,s1
    800020d2:	bcbfe0ef          	jal	80000c9c <release>
      return 0;
    800020d6:	4501                	li	a0,0
}
    800020d8:	70a2                	ld	ra,40(sp)
    800020da:	7402                	ld	s0,32(sp)
    800020dc:	64e2                	ld	s1,24(sp)
    800020de:	6942                	ld	s2,16(sp)
    800020e0:	69a2                	ld	s3,8(sp)
    800020e2:	6145                	addi	sp,sp,48
    800020e4:	8082                	ret
        p->state = RUNNABLE;
    800020e6:	478d                	li	a5,3
    800020e8:	cc9c                	sw	a5,24(s1)
    800020ea:	b7dd                	j	800020d0 <kkill+0x4a>

00000000800020ec <setkilled>:

void
setkilled(struct proc *p)
{
    800020ec:	1101                	addi	sp,sp,-32
    800020ee:	ec06                	sd	ra,24(sp)
    800020f0:	e822                	sd	s0,16(sp)
    800020f2:	e426                	sd	s1,8(sp)
    800020f4:	1000                	addi	s0,sp,32
    800020f6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020f8:	b21fe0ef          	jal	80000c18 <acquire>
  p->killed = 1;
    800020fc:	4785                	li	a5,1
    800020fe:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002100:	8526                	mv	a0,s1
    80002102:	b9bfe0ef          	jal	80000c9c <release>
}
    80002106:	60e2                	ld	ra,24(sp)
    80002108:	6442                	ld	s0,16(sp)
    8000210a:	64a2                	ld	s1,8(sp)
    8000210c:	6105                	addi	sp,sp,32
    8000210e:	8082                	ret

0000000080002110 <killed>:

int
killed(struct proc *p)
{
    80002110:	1101                	addi	sp,sp,-32
    80002112:	ec06                	sd	ra,24(sp)
    80002114:	e822                	sd	s0,16(sp)
    80002116:	e426                	sd	s1,8(sp)
    80002118:	e04a                	sd	s2,0(sp)
    8000211a:	1000                	addi	s0,sp,32
    8000211c:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    8000211e:	afbfe0ef          	jal	80000c18 <acquire>
  k = p->killed;
    80002122:	549c                	lw	a5,40(s1)
    80002124:	893e                	mv	s2,a5
  release(&p->lock);
    80002126:	8526                	mv	a0,s1
    80002128:	b75fe0ef          	jal	80000c9c <release>
  return k;
}
    8000212c:	854a                	mv	a0,s2
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6902                	ld	s2,0(sp)
    80002136:	6105                	addi	sp,sp,32
    80002138:	8082                	ret

000000008000213a <kwait>:
{
    8000213a:	715d                	addi	sp,sp,-80
    8000213c:	e486                	sd	ra,72(sp)
    8000213e:	e0a2                	sd	s0,64(sp)
    80002140:	fc26                	sd	s1,56(sp)
    80002142:	f84a                	sd	s2,48(sp)
    80002144:	f44e                	sd	s3,40(sp)
    80002146:	f052                	sd	s4,32(sp)
    80002148:	ec56                	sd	s5,24(sp)
    8000214a:	e85a                	sd	s6,16(sp)
    8000214c:	e45e                	sd	s7,8(sp)
    8000214e:	0880                	addi	s0,sp,80
    80002150:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002152:	f88ff0ef          	jal	800018da <myproc>
    80002156:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80002158:	0000e517          	auipc	a0,0xe
    8000215c:	9a850513          	addi	a0,a0,-1624 # 8000fb00 <wait_lock>
    80002160:	ab9fe0ef          	jal	80000c18 <acquire>
        if (pp->state == ZOMBIE) {
    80002164:	4a15                	li	s4,5
        havekids = 1;
    80002166:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002168:	00014997          	auipc	s3,0x14
    8000216c:	9b098993          	addi	s3,s3,-1616 # 80015b18 <tickslock>
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002170:	0000eb17          	auipc	s6,0xe
    80002174:	990b0b13          	addi	s6,s6,-1648 # 8000fb00 <wait_lock>
    80002178:	a861                	j	80002210 <kwait+0xd6>
          pid = pp->pid;
    8000217a:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000217e:	000b8c63          	beqz	s7,80002196 <kwait+0x5c>
    80002182:	4691                	li	a3,4
    80002184:	02c48613          	addi	a2,s1,44
    80002188:	85de                	mv	a1,s7
    8000218a:	05093503          	ld	a0,80(s2)
    8000218e:	c7eff0ef          	jal	8000160c <copyout>
    80002192:	02054a63          	bltz	a0,800021c6 <kwait+0x8c>
          freeproc(pp);
    80002196:	8526                	mv	a0,s1
    80002198:	915ff0ef          	jal	80001aac <freeproc>
          release(&pp->lock);
    8000219c:	8526                	mv	a0,s1
    8000219e:	afffe0ef          	jal	80000c9c <release>
          release(&wait_lock);
    800021a2:	0000e517          	auipc	a0,0xe
    800021a6:	95e50513          	addi	a0,a0,-1698 # 8000fb00 <wait_lock>
    800021aa:	af3fe0ef          	jal	80000c9c <release>
}
    800021ae:	854e                	mv	a0,s3
    800021b0:	60a6                	ld	ra,72(sp)
    800021b2:	6406                	ld	s0,64(sp)
    800021b4:	74e2                	ld	s1,56(sp)
    800021b6:	7942                	ld	s2,48(sp)
    800021b8:	79a2                	ld	s3,40(sp)
    800021ba:	7a02                	ld	s4,32(sp)
    800021bc:	6ae2                	ld	s5,24(sp)
    800021be:	6b42                	ld	s6,16(sp)
    800021c0:	6ba2                	ld	s7,8(sp)
    800021c2:	6161                	addi	sp,sp,80
    800021c4:	8082                	ret
            release(&pp->lock);
    800021c6:	8526                	mv	a0,s1
    800021c8:	ad5fe0ef          	jal	80000c9c <release>
            release(&wait_lock);
    800021cc:	0000e517          	auipc	a0,0xe
    800021d0:	93450513          	addi	a0,a0,-1740 # 8000fb00 <wait_lock>
    800021d4:	ac9fe0ef          	jal	80000c9c <release>
            return -1;
    800021d8:	a881                	j	80002228 <kwait+0xee>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021da:	17048493          	addi	s1,s1,368
    800021de:	03348063          	beq	s1,s3,800021fe <kwait+0xc4>
      if (pp->parent == p) {
    800021e2:	7c9c                	ld	a5,56(s1)
    800021e4:	ff279be3          	bne	a5,s2,800021da <kwait+0xa0>
        acquire(&pp->lock);
    800021e8:	8526                	mv	a0,s1
    800021ea:	a2ffe0ef          	jal	80000c18 <acquire>
        if (pp->state == ZOMBIE) {
    800021ee:	4c9c                	lw	a5,24(s1)
    800021f0:	f94785e3          	beq	a5,s4,8000217a <kwait+0x40>
        release(&pp->lock);
    800021f4:	8526                	mv	a0,s1
    800021f6:	aa7fe0ef          	jal	80000c9c <release>
        havekids = 1;
    800021fa:	8756                	mv	a4,s5
    800021fc:	bff9                	j	800021da <kwait+0xa0>
    if (!havekids || killed(p)) {
    800021fe:	cf19                	beqz	a4,8000221c <kwait+0xe2>
    80002200:	854a                	mv	a0,s2
    80002202:	f0fff0ef          	jal	80002110 <killed>
    80002206:	e919                	bnez	a0,8000221c <kwait+0xe2>
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002208:	85da                	mv	a1,s6
    8000220a:	854a                	mv	a0,s2
    8000220c:	cc9ff0ef          	jal	80001ed4 <sleep>
    havekids = 0;
    80002210:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002212:	0000e497          	auipc	s1,0xe
    80002216:	d0648493          	addi	s1,s1,-762 # 8000ff18 <proc>
    8000221a:	b7e1                	j	800021e2 <kwait+0xa8>
      release(&wait_lock);
    8000221c:	0000e517          	auipc	a0,0xe
    80002220:	8e450513          	addi	a0,a0,-1820 # 8000fb00 <wait_lock>
    80002224:	a79fe0ef          	jal	80000c9c <release>
            return -1;
    80002228:	59fd                	li	s3,-1
    8000222a:	b751                	j	800021ae <kwait+0x74>

000000008000222c <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000222c:	7179                	addi	sp,sp,-48
    8000222e:	f406                	sd	ra,40(sp)
    80002230:	f022                	sd	s0,32(sp)
    80002232:	ec26                	sd	s1,24(sp)
    80002234:	e84a                	sd	s2,16(sp)
    80002236:	e44e                	sd	s3,8(sp)
    80002238:	e052                	sd	s4,0(sp)
    8000223a:	1800                	addi	s0,sp,48
    8000223c:	84aa                	mv	s1,a0
    8000223e:	8a2e                	mv	s4,a1
    80002240:	89b2                	mv	s3,a2
    80002242:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002244:	e96ff0ef          	jal	800018da <myproc>
  if (user_dst) {
    80002248:	cc99                	beqz	s1,80002266 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000224a:	86ca                	mv	a3,s2
    8000224c:	864e                	mv	a2,s3
    8000224e:	85d2                	mv	a1,s4
    80002250:	6928                	ld	a0,80(a0)
    80002252:	bbaff0ef          	jal	8000160c <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80002256:	70a2                	ld	ra,40(sp)
    80002258:	7402                	ld	s0,32(sp)
    8000225a:	64e2                	ld	s1,24(sp)
    8000225c:	6942                	ld	s2,16(sp)
    8000225e:	69a2                	ld	s3,8(sp)
    80002260:	6a02                	ld	s4,0(sp)
    80002262:	6145                	addi	sp,sp,48
    80002264:	8082                	ret
    memmove((char *)dst, src, len);
    80002266:	0009061b          	sext.w	a2,s2
    8000226a:	85ce                	mv	a1,s3
    8000226c:	8552                	mv	a0,s4
    8000226e:	ac3fe0ef          	jal	80000d30 <memmove>
    return 0;
    80002272:	8526                	mv	a0,s1
    80002274:	b7cd                	j	80002256 <either_copyout+0x2a>

0000000080002276 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80002276:	7179                	addi	sp,sp,-48
    80002278:	f406                	sd	ra,40(sp)
    8000227a:	f022                	sd	s0,32(sp)
    8000227c:	ec26                	sd	s1,24(sp)
    8000227e:	e84a                	sd	s2,16(sp)
    80002280:	e44e                	sd	s3,8(sp)
    80002282:	e052                	sd	s4,0(sp)
    80002284:	1800                	addi	s0,sp,48
    80002286:	8a2a                	mv	s4,a0
    80002288:	84ae                	mv	s1,a1
    8000228a:	89b2                	mv	s3,a2
    8000228c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000228e:	e4cff0ef          	jal	800018da <myproc>
  if (user_src) {
    80002292:	cc99                	beqz	s1,800022b0 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002294:	86ca                	mv	a3,s2
    80002296:	864e                	mv	a2,s3
    80002298:	85d2                	mv	a1,s4
    8000229a:	6928                	ld	a0,80(a0)
    8000229c:	c28ff0ef          	jal	800016c4 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800022a0:	70a2                	ld	ra,40(sp)
    800022a2:	7402                	ld	s0,32(sp)
    800022a4:	64e2                	ld	s1,24(sp)
    800022a6:	6942                	ld	s2,16(sp)
    800022a8:	69a2                	ld	s3,8(sp)
    800022aa:	6a02                	ld	s4,0(sp)
    800022ac:	6145                	addi	sp,sp,48
    800022ae:	8082                	ret
    memmove(dst, (char *)src, len);
    800022b0:	0009061b          	sext.w	a2,s2
    800022b4:	85ce                	mv	a1,s3
    800022b6:	8552                	mv	a0,s4
    800022b8:	a79fe0ef          	jal	80000d30 <memmove>
    return 0;
    800022bc:	8526                	mv	a0,s1
    800022be:	b7cd                	j	800022a0 <either_copyin+0x2a>

00000000800022c0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022c0:	715d                	addi	sp,sp,-80
    800022c2:	e486                	sd	ra,72(sp)
    800022c4:	e0a2                	sd	s0,64(sp)
    800022c6:	fc26                	sd	s1,56(sp)
    800022c8:	f84a                	sd	s2,48(sp)
    800022ca:	f44e                	sd	s3,40(sp)
    800022cc:	f052                	sd	s4,32(sp)
    800022ce:	ec56                	sd	s5,24(sp)
    800022d0:	e85a                	sd	s6,16(sp)
    800022d2:	e45e                	sd	s7,8(sp)
    800022d4:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    800022d6:	00005517          	auipc	a0,0x5
    800022da:	da250513          	addi	a0,a0,-606 # 80007078 <etext+0x78>
    800022de:	a24fe0ef          	jal	80000502 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800022e2:	0000e497          	auipc	s1,0xe
    800022e6:	d8e48493          	addi	s1,s1,-626 # 80010070 <proc+0x158>
    800022ea:	00014917          	auipc	s2,0x14
    800022ee:	98690913          	addi	s2,s2,-1658 # 80015c70 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022f2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022f4:	00005a97          	auipc	s5,0x5
    800022f8:	f0ca8a93          	addi	s5,s5,-244 # 80007200 <etext+0x200>
    printk("%d %s %s", p->pid, state, p->name);
    800022fc:	00005a17          	auipc	s4,0x5
    80002300:	f0ca0a13          	addi	s4,s4,-244 # 80007208 <etext+0x208>
    printk("\n");
    80002304:	00005997          	auipc	s3,0x5
    80002308:	d7498993          	addi	s3,s3,-652 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000230c:	00005b97          	auipc	s7,0x5
    80002310:	4dcb8b93          	addi	s7,s7,1244 # 800077e8 <states.0>
    80002314:	a829                	j	8000232e <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    80002316:	ed86a583          	lw	a1,-296(a3)
    8000231a:	8552                	mv	a0,s4
    8000231c:	9e6fe0ef          	jal	80000502 <printk>
    printk("\n");
    80002320:	854e                	mv	a0,s3
    80002322:	9e0fe0ef          	jal	80000502 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    80002326:	17048493          	addi	s1,s1,368
    8000232a:	03248063          	beq	s1,s2,8000234a <procdump+0x8a>
    if (p->state == UNUSED)
    8000232e:	86a6                	mv	a3,s1
    80002330:	ec04a783          	lw	a5,-320(s1)
    80002334:	dbed                	beqz	a5,80002326 <procdump+0x66>
      state = "???";
    80002336:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002338:	fcfb6fe3          	bltu	s6,a5,80002316 <procdump+0x56>
    8000233c:	02079713          	slli	a4,a5,0x20
    80002340:	01d75793          	srli	a5,a4,0x1d
    80002344:	97de                	add	a5,a5,s7
    80002346:	6390                	ld	a2,0(a5)
      state = states[p->state];
    80002348:	b7f9                	j	80002316 <procdump+0x56>
  }
}
    8000234a:	60a6                	ld	ra,72(sp)
    8000234c:	6406                	ld	s0,64(sp)
    8000234e:	74e2                	ld	s1,56(sp)
    80002350:	7942                	ld	s2,48(sp)
    80002352:	79a2                	ld	s3,40(sp)
    80002354:	7a02                	ld	s4,32(sp)
    80002356:	6ae2                	ld	s5,24(sp)
    80002358:	6b42                	ld	s6,16(sp)
    8000235a:	6ba2                	ld	s7,8(sp)
    8000235c:	6161                	addi	sp,sp,80
    8000235e:	8082                	ret

0000000080002360 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002360:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002364:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80002368:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000236a:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000236c:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002370:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002374:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80002378:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000237c:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002380:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002384:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80002388:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000238c:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002390:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002394:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80002398:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    8000239c:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000239e:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023a0:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023a4:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023a8:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023ac:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023b0:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800023b4:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800023b8:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800023bc:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800023c0:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800023c4:	0685bd83          	ld	s11,104(a1)
        
        ret
    800023c8:	8082                	ret

00000000800023ca <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023ca:	1141                	addi	sp,sp,-16
    800023cc:	e406                	sd	ra,8(sp)
    800023ce:	e022                	sd	s0,0(sp)
    800023d0:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023d2:	00005597          	auipc	a1,0x5
    800023d6:	e7658593          	addi	a1,a1,-394 # 80007248 <etext+0x248>
    800023da:	00013517          	auipc	a0,0x13
    800023de:	73e50513          	addi	a0,a0,1854 # 80015b18 <tickslock>
    800023e2:	fb6fe0ef          	jal	80000b98 <initlock>
}
    800023e6:	60a2                	ld	ra,8(sp)
    800023e8:	6402                	ld	s0,0(sp)
    800023ea:	0141                	addi	sp,sp,16
    800023ec:	8082                	ret

00000000800023ee <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023ee:	1141                	addi	sp,sp,-16
    800023f0:	e406                	sd	ra,8(sp)
    800023f2:	e022                	sd	s0,0(sp)
    800023f4:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800023f6:	00003797          	auipc	a5,0x3
    800023fa:	ffa78793          	addi	a5,a5,-6 # 800053f0 <kernelvec>
    800023fe:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002402:	60a2                	ld	ra,8(sp)
    80002404:	6402                	ld	s0,0(sp)
    80002406:	0141                	addi	sp,sp,16
    80002408:	8082                	ret

000000008000240a <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000240a:	1141                	addi	sp,sp,-16
    8000240c:	e406                	sd	ra,8(sp)
    8000240e:	e022                	sd	s0,0(sp)
    80002410:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002412:	cc8ff0ef          	jal	800018da <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80002416:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000241a:	04000737          	lui	a4,0x4000
    8000241e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002420:	0732                	slli	a4,a4,0xc
    80002422:	00004797          	auipc	a5,0x4
    80002426:	bde78793          	addi	a5,a5,-1058 # 80006000 <_trampoline>
    8000242a:	00004697          	auipc	a3,0x4
    8000242e:	bd668693          	addi	a3,a3,-1066 # 80006000 <_trampoline>
    80002432:	8f95                	sub	a5,a5,a3
    80002434:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002436:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000243a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    8000243c:	18002773          	csrr	a4,satp
    80002440:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002442:	6d38                	ld	a4,88(a0)
    80002444:	613c                	ld	a5,64(a0)
    80002446:	6685                	lui	a3,0x1
    80002448:	97b6                	add	a5,a5,a3
    8000244a:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000244c:	6d3c                	ld	a5,88(a0)
    8000244e:	00000717          	auipc	a4,0x0
    80002452:	0f470713          	addi	a4,a4,244 # 80002542 <usertrap>
    80002456:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80002458:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    8000245a:	8712                	mv	a4,tp
    8000245c:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000245e:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002462:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80002466:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000246a:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000246e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002470:	6f9c                	ld	a5,24(a5)
    80002472:	14179073          	csrw	sepc,a5
}
    80002476:	60a2                	ld	ra,8(sp)
    80002478:	6402                	ld	s0,0(sp)
    8000247a:	0141                	addi	sp,sp,16
    8000247c:	8082                	ret

000000008000247e <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000247e:	1141                	addi	sp,sp,-16
    80002480:	e406                	sd	ra,8(sp)
    80002482:	e022                	sd	s0,0(sp)
    80002484:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    80002486:	c20ff0ef          	jal	800018a6 <cpuid>
    8000248a:	cd11                	beqz	a0,800024a6 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    8000248c:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002490:	000f4737          	lui	a4,0xf4
    80002494:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80002498:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000249a:	14d79073          	csrw	stimecmp,a5
}
    8000249e:	60a2                	ld	ra,8(sp)
    800024a0:	6402                	ld	s0,0(sp)
    800024a2:	0141                	addi	sp,sp,16
    800024a4:	8082                	ret
    acquire(&tickslock);
    800024a6:	00013517          	auipc	a0,0x13
    800024aa:	67250513          	addi	a0,a0,1650 # 80015b18 <tickslock>
    800024ae:	f6afe0ef          	jal	80000c18 <acquire>
    ticks++;
    800024b2:	00005717          	auipc	a4,0x5
    800024b6:	53670713          	addi	a4,a4,1334 # 800079e8 <ticks>
    800024ba:	431c                	lw	a5,0(a4)
    800024bc:	2785                	addiw	a5,a5,1
    800024be:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800024c0:	853a                	mv	a0,a4
    800024c2:	a5fff0ef          	jal	80001f20 <wakeup>
    release(&tickslock);
    800024c6:	00013517          	auipc	a0,0x13
    800024ca:	65250513          	addi	a0,a0,1618 # 80015b18 <tickslock>
    800024ce:	fcefe0ef          	jal	80000c9c <release>
    800024d2:	bf6d                	j	8000248c <clockintr+0xe>

00000000800024d4 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024d4:	1101                	addi	sp,sp,-32
    800024d6:	ec06                	sd	ra,24(sp)
    800024d8:	e822                	sd	s0,16(sp)
    800024da:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    800024dc:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    800024e0:	57fd                	li	a5,-1
    800024e2:	17fe                	slli	a5,a5,0x3f
    800024e4:	07a5                	addi	a5,a5,9
    800024e6:	00f70c63          	beq	a4,a5,800024fe <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    800024ea:	57fd                	li	a5,-1
    800024ec:	17fe                	slli	a5,a5,0x3f
    800024ee:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800024f0:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    800024f2:	04f70463          	beq	a4,a5,8000253a <devintr+0x66>
  }
}
    800024f6:	60e2                	ld	ra,24(sp)
    800024f8:	6442                	ld	s0,16(sp)
    800024fa:	6105                	addi	sp,sp,32
    800024fc:	8082                	ret
    800024fe:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002500:	79d020ef          	jal	8000549c <plic_claim>
    80002504:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    80002506:	47a9                	li	a5,10
    80002508:	02f50363          	beq	a0,a5,8000252e <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    8000250c:	4785                	li	a5,1
    8000250e:	02f50363          	beq	a0,a5,80002534 <devintr+0x60>
    } else if (irq) {
    80002512:	c919                	beqz	a0,80002528 <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    80002514:	85aa                	mv	a1,a0
    80002516:	00005517          	auipc	a0,0x5
    8000251a:	d3a50513          	addi	a0,a0,-710 # 80007250 <etext+0x250>
    8000251e:	fe5fd0ef          	jal	80000502 <printk>
      plic_complete(irq);
    80002522:	8526                	mv	a0,s1
    80002524:	799020ef          	jal	800054bc <plic_complete>
    return 1;
    80002528:	4505                	li	a0,1
    8000252a:	64a2                	ld	s1,8(sp)
    8000252c:	b7e9                	j	800024f6 <devintr+0x22>
      uartintr();
    8000252e:	cb0fe0ef          	jal	800009de <uartintr>
    if (irq)
    80002532:	bfc5                	j	80002522 <devintr+0x4e>
      virtio_disk_intr();
    80002534:	3ec030ef          	jal	80005920 <virtio_disk_intr>
    if (irq)
    80002538:	b7ed                	j	80002522 <devintr+0x4e>
    clockintr();
    8000253a:	f45ff0ef          	jal	8000247e <clockintr>
    return 2;
    8000253e:	4509                	li	a0,2
    80002540:	bf5d                	j	800024f6 <devintr+0x22>

0000000080002542 <usertrap>:
{
    80002542:	1101                	addi	sp,sp,-32
    80002544:	ec06                	sd	ra,24(sp)
    80002546:	e822                	sd	s0,16(sp)
    80002548:	e426                	sd	s1,8(sp)
    8000254a:	e04a                	sd	s2,0(sp)
    8000254c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000254e:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002552:	1007f793          	andi	a5,a5,256
    80002556:	eba5                	bnez	a5,800025c6 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    80002558:	00003797          	auipc	a5,0x3
    8000255c:	e9878793          	addi	a5,a5,-360 # 800053f0 <kernelvec>
    80002560:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002564:	b76ff0ef          	jal	800018da <myproc>
    80002568:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000256a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000256c:	14102773          	csrr	a4,sepc
    80002570:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002572:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    80002576:	47a1                	li	a5,8
    80002578:	04f70d63          	beq	a4,a5,800025d2 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    8000257c:	f59ff0ef          	jal	800024d4 <devintr>
    80002580:	892a                	mv	s2,a0
    80002582:	e545                	bnez	a0,8000262a <usertrap+0xe8>
    80002584:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002588:	47bd                	li	a5,15
    8000258a:	08f70463          	beq	a4,a5,80002612 <usertrap+0xd0>
    8000258e:	14202773          	csrr	a4,scause
    80002592:	47b5                	li	a5,13
    80002594:	06f70f63          	beq	a4,a5,80002612 <usertrap+0xd0>
    80002598:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    8000259c:	5890                	lw	a2,48(s1)
    8000259e:	00005517          	auipc	a0,0x5
    800025a2:	cf250513          	addi	a0,a0,-782 # 80007290 <etext+0x290>
    800025a6:	f5dfd0ef          	jal	80000502 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025aa:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800025ae:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025b2:	00005517          	auipc	a0,0x5
    800025b6:	d0e50513          	addi	a0,a0,-754 # 800072c0 <etext+0x2c0>
    800025ba:	f49fd0ef          	jal	80000502 <printk>
    setkilled(p);
    800025be:	8526                	mv	a0,s1
    800025c0:	b2dff0ef          	jal	800020ec <setkilled>
    800025c4:	a015                	j	800025e8 <usertrap+0xa6>
    panic("usertrap: not from user mode");
    800025c6:	00005517          	auipc	a0,0x5
    800025ca:	caa50513          	addi	a0,a0,-854 # 80007270 <etext+0x270>
    800025ce:	a6cfe0ef          	jal	8000083a <panic>
    if (killed(p))
    800025d2:	b3fff0ef          	jal	80002110 <killed>
    800025d6:	e915                	bnez	a0,8000260a <usertrap+0xc8>
    p->trapframe->epc += 4;
    800025d8:	6cb8                	ld	a4,88(s1)
    800025da:	6f1c                	ld	a5,24(a4)
    800025dc:	0791                	addi	a5,a5,4
    800025de:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800025e0:	10016073          	csrsi	sstatus,2
    syscall();
    800025e4:	23c000ef          	jal	80002820 <syscall>
  if (killed(p))
    800025e8:	8526                	mv	a0,s1
    800025ea:	b27ff0ef          	jal	80002110 <killed>
    800025ee:	e139                	bnez	a0,80002634 <usertrap+0xf2>
  prepare_return();
    800025f0:	e1bff0ef          	jal	8000240a <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800025f4:	68a8                	ld	a0,80(s1)
    800025f6:	8131                	srli	a0,a0,0xc
    800025f8:	57fd                	li	a5,-1
    800025fa:	17fe                	slli	a5,a5,0x3f
    800025fc:	8d5d                	or	a0,a0,a5
}
    800025fe:	60e2                	ld	ra,24(sp)
    80002600:	6442                	ld	s0,16(sp)
    80002602:	64a2                	ld	s1,8(sp)
    80002604:	6902                	ld	s2,0(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret
      kexit(-1);
    8000260a:	557d                	li	a0,-1
    8000260c:	9d5ff0ef          	jal	80001fe0 <kexit>
    80002610:	b7e1                	j	800025d8 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002612:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    80002616:	14202673          	csrr	a2,scause
             vmfault(p->pagetable, r_stval(), (r_scause() == 13) ? 1 : 0) !=
    8000261a:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    8000261c:	00163613          	seqz	a2,a2
    80002620:	68a8                	ld	a0,80(s1)
    80002622:	f6bfe0ef          	jal	8000158c <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    80002626:	f169                	bnez	a0,800025e8 <usertrap+0xa6>
    80002628:	bf85                	j	80002598 <usertrap+0x56>
  if (killed(p))
    8000262a:	8526                	mv	a0,s1
    8000262c:	ae5ff0ef          	jal	80002110 <killed>
    80002630:	c511                	beqz	a0,8000263c <usertrap+0xfa>
    80002632:	a011                	j	80002636 <usertrap+0xf4>
    80002634:	4901                	li	s2,0
    kexit(-1);
    80002636:	557d                	li	a0,-1
    80002638:	9a9ff0ef          	jal	80001fe0 <kexit>
  if (which_dev == 2)
    8000263c:	4789                	li	a5,2
    8000263e:	faf919e3          	bne	s2,a5,800025f0 <usertrap+0xae>
    yield();
    80002642:	867ff0ef          	jal	80001ea8 <yield>
    80002646:	b76d                	j	800025f0 <usertrap+0xae>

0000000080002648 <kerneltrap>:
{
    80002648:	7179                	addi	sp,sp,-48
    8000264a:	f406                	sd	ra,40(sp)
    8000264c:	f022                	sd	s0,32(sp)
    8000264e:	ec26                	sd	s1,24(sp)
    80002650:	e84a                	sd	s2,16(sp)
    80002652:	e44e                	sd	s3,8(sp)
    80002654:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002656:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000265a:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    8000265e:	142027f3          	csrr	a5,scause
    80002662:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002664:	1004f793          	andi	a5,s1,256
    80002668:	c795                	beqz	a5,80002694 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000266a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000266e:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002670:	eb85                	bnez	a5,800026a0 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80002672:	e63ff0ef          	jal	800024d4 <devintr>
    80002676:	c91d                	beqz	a0,800026ac <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    80002678:	4789                	li	a5,2
    8000267a:	04f50a63          	beq	a0,a5,800026ce <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    8000267e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002682:	10049073          	csrw	sstatus,s1
}
    80002686:	70a2                	ld	ra,40(sp)
    80002688:	7402                	ld	s0,32(sp)
    8000268a:	64e2                	ld	s1,24(sp)
    8000268c:	6942                	ld	s2,16(sp)
    8000268e:	69a2                	ld	s3,8(sp)
    80002690:	6145                	addi	sp,sp,48
    80002692:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002694:	00005517          	auipc	a0,0x5
    80002698:	c5450513          	addi	a0,a0,-940 # 800072e8 <etext+0x2e8>
    8000269c:	99efe0ef          	jal	8000083a <panic>
    panic("kerneltrap: interrupts enabled");
    800026a0:	00005517          	auipc	a0,0x5
    800026a4:	c7050513          	addi	a0,a0,-912 # 80007310 <etext+0x310>
    800026a8:	992fe0ef          	jal	8000083a <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026ac:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800026b0:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800026b4:	85ce                	mv	a1,s3
    800026b6:	00005517          	auipc	a0,0x5
    800026ba:	c7a50513          	addi	a0,a0,-902 # 80007330 <etext+0x330>
    800026be:	e45fd0ef          	jal	80000502 <printk>
    panic("kerneltrap");
    800026c2:	00005517          	auipc	a0,0x5
    800026c6:	c9650513          	addi	a0,a0,-874 # 80007358 <etext+0x358>
    800026ca:	970fe0ef          	jal	8000083a <panic>
  if (which_dev == 2 && myproc() != 0)
    800026ce:	a0cff0ef          	jal	800018da <myproc>
    800026d2:	d555                	beqz	a0,8000267e <kerneltrap+0x36>
    yield();
    800026d4:	fd4ff0ef          	jal	80001ea8 <yield>
    800026d8:	b75d                	j	8000267e <kerneltrap+0x36>

00000000800026da <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026da:	1101                	addi	sp,sp,-32
    800026dc:	ec06                	sd	ra,24(sp)
    800026de:	e822                	sd	s0,16(sp)
    800026e0:	e426                	sd	s1,8(sp)
    800026e2:	1000                	addi	s0,sp,32
    800026e4:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026e6:	9f4ff0ef          	jal	800018da <myproc>
  switch (n) {
    800026ea:	4795                	li	a5,5
    800026ec:	0497e163          	bltu	a5,s1,8000272e <argraw+0x54>
    800026f0:	048a                	slli	s1,s1,0x2
    800026f2:	00005717          	auipc	a4,0x5
    800026f6:	12670713          	addi	a4,a4,294 # 80007818 <states.0+0x30>
    800026fa:	94ba                	add	s1,s1,a4
    800026fc:	409c                	lw	a5,0(s1)
    800026fe:	97ba                	add	a5,a5,a4
    80002700:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002702:	6d3c                	ld	a5,88(a0)
    80002704:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002706:	60e2                	ld	ra,24(sp)
    80002708:	6442                	ld	s0,16(sp)
    8000270a:	64a2                	ld	s1,8(sp)
    8000270c:	6105                	addi	sp,sp,32
    8000270e:	8082                	ret
    return p->trapframe->a1;
    80002710:	6d3c                	ld	a5,88(a0)
    80002712:	7fa8                	ld	a0,120(a5)
    80002714:	bfcd                	j	80002706 <argraw+0x2c>
    return p->trapframe->a2;
    80002716:	6d3c                	ld	a5,88(a0)
    80002718:	63c8                	ld	a0,128(a5)
    8000271a:	b7f5                	j	80002706 <argraw+0x2c>
    return p->trapframe->a3;
    8000271c:	6d3c                	ld	a5,88(a0)
    8000271e:	67c8                	ld	a0,136(a5)
    80002720:	b7dd                	j	80002706 <argraw+0x2c>
    return p->trapframe->a4;
    80002722:	6d3c                	ld	a5,88(a0)
    80002724:	6bc8                	ld	a0,144(a5)
    80002726:	b7c5                	j	80002706 <argraw+0x2c>
    return p->trapframe->a5;
    80002728:	6d3c                	ld	a5,88(a0)
    8000272a:	6fc8                	ld	a0,152(a5)
    8000272c:	bfe9                	j	80002706 <argraw+0x2c>
  panic("argraw");
    8000272e:	00005517          	auipc	a0,0x5
    80002732:	c3a50513          	addi	a0,a0,-966 # 80007368 <etext+0x368>
    80002736:	904fe0ef          	jal	8000083a <panic>

000000008000273a <fetchaddr>:
{
    8000273a:	1101                	addi	sp,sp,-32
    8000273c:	ec06                	sd	ra,24(sp)
    8000273e:	e822                	sd	s0,16(sp)
    80002740:	e426                	sd	s1,8(sp)
    80002742:	e04a                	sd	s2,0(sp)
    80002744:	1000                	addi	s0,sp,32
    80002746:	84aa                	mv	s1,a0
    80002748:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000274a:	990ff0ef          	jal	800018da <myproc>
  if (addr >= p->sz ||
    8000274e:	653c                	ld	a5,72(a0)
    80002750:	02f4f663          	bgeu	s1,a5,8000277c <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002754:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    80002758:	02e7e263          	bltu	a5,a4,8000277c <fetchaddr+0x42>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000275c:	46a1                	li	a3,8
    8000275e:	8626                	mv	a2,s1
    80002760:	85ca                	mv	a1,s2
    80002762:	6928                	ld	a0,80(a0)
    80002764:	f61fe0ef          	jal	800016c4 <copyin>
    80002768:	00a03533          	snez	a0,a0
    8000276c:	40a0053b          	negw	a0,a0
}
    80002770:	60e2                	ld	ra,24(sp)
    80002772:	6442                	ld	s0,16(sp)
    80002774:	64a2                	ld	s1,8(sp)
    80002776:	6902                	ld	s2,0(sp)
    80002778:	6105                	addi	sp,sp,32
    8000277a:	8082                	ret
    return -1;
    8000277c:	557d                	li	a0,-1
    8000277e:	bfcd                	j	80002770 <fetchaddr+0x36>

0000000080002780 <fetchstr>:
{
    80002780:	7179                	addi	sp,sp,-48
    80002782:	f406                	sd	ra,40(sp)
    80002784:	f022                	sd	s0,32(sp)
    80002786:	ec26                	sd	s1,24(sp)
    80002788:	e84a                	sd	s2,16(sp)
    8000278a:	e44e                	sd	s3,8(sp)
    8000278c:	1800                	addi	s0,sp,48
    8000278e:	89aa                	mv	s3,a0
    80002790:	84ae                	mv	s1,a1
    80002792:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002794:	946ff0ef          	jal	800018da <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002798:	86ca                	mv	a3,s2
    8000279a:	864e                	mv	a2,s3
    8000279c:	85a6                	mv	a1,s1
    8000279e:	6928                	ld	a0,80(a0)
    800027a0:	d15fe0ef          	jal	800014b4 <copyinstr>
    800027a4:	00054c63          	bltz	a0,800027bc <fetchstr+0x3c>
  return strlen(buf);
    800027a8:	8526                	mv	a0,s1
    800027aa:	eaafe0ef          	jal	80000e54 <strlen>
}
    800027ae:	70a2                	ld	ra,40(sp)
    800027b0:	7402                	ld	s0,32(sp)
    800027b2:	64e2                	ld	s1,24(sp)
    800027b4:	6942                	ld	s2,16(sp)
    800027b6:	69a2                	ld	s3,8(sp)
    800027b8:	6145                	addi	sp,sp,48
    800027ba:	8082                	ret
    return -1;
    800027bc:	557d                	li	a0,-1
    800027be:	bfc5                	j	800027ae <fetchstr+0x2e>

00000000800027c0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027c0:	1101                	addi	sp,sp,-32
    800027c2:	ec06                	sd	ra,24(sp)
    800027c4:	e822                	sd	s0,16(sp)
    800027c6:	e426                	sd	s1,8(sp)
    800027c8:	1000                	addi	s0,sp,32
    800027ca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027cc:	f0fff0ef          	jal	800026da <argraw>
    800027d0:	c088                	sw	a0,0(s1)
}
    800027d2:	60e2                	ld	ra,24(sp)
    800027d4:	6442                	ld	s0,16(sp)
    800027d6:	64a2                	ld	s1,8(sp)
    800027d8:	6105                	addi	sp,sp,32
    800027da:	8082                	ret

00000000800027dc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027dc:	1101                	addi	sp,sp,-32
    800027de:	ec06                	sd	ra,24(sp)
    800027e0:	e822                	sd	s0,16(sp)
    800027e2:	e426                	sd	s1,8(sp)
    800027e4:	1000                	addi	s0,sp,32
    800027e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027e8:	ef3ff0ef          	jal	800026da <argraw>
    800027ec:	e088                	sd	a0,0(s1)
}
    800027ee:	60e2                	ld	ra,24(sp)
    800027f0:	6442                	ld	s0,16(sp)
    800027f2:	64a2                	ld	s1,8(sp)
    800027f4:	6105                	addi	sp,sp,32
    800027f6:	8082                	ret

00000000800027f8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027f8:	1101                	addi	sp,sp,-32
    800027fa:	ec06                	sd	ra,24(sp)
    800027fc:	e822                	sd	s0,16(sp)
    800027fe:	e426                	sd	s1,8(sp)
    80002800:	e04a                	sd	s2,0(sp)
    80002802:	1000                	addi	s0,sp,32
    80002804:	892e                	mv	s2,a1
    80002806:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002808:	ed3ff0ef          	jal	800026da <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000280c:	8626                	mv	a2,s1
    8000280e:	85ca                	mv	a1,s2
    80002810:	f71ff0ef          	jal	80002780 <fetchstr>
}
    80002814:	60e2                	ld	ra,24(sp)
    80002816:	6442                	ld	s0,16(sp)
    80002818:	64a2                	ld	s1,8(sp)
    8000281a:	6902                	ld	s2,0(sp)
    8000281c:	6105                	addi	sp,sp,32
    8000281e:	8082                	ret

0000000080002820 <syscall>:
  [SYS_trace]   "trace",
};

void
syscall(void)
{
    80002820:	7179                	addi	sp,sp,-48
    80002822:	f406                	sd	ra,40(sp)
    80002824:	f022                	sd	s0,32(sp)
    80002826:	ec26                	sd	s1,24(sp)
    80002828:	e84a                	sd	s2,16(sp)
    8000282a:	e44e                	sd	s3,8(sp)
    8000282c:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    8000282e:	8acff0ef          	jal	800018da <myproc>
    80002832:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002834:	05853903          	ld	s2,88(a0)
    80002838:	0a893783          	ld	a5,168(s2)
    8000283c:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002840:	37fd                	addiw	a5,a5,-1
    80002842:	4759                	li	a4,22
    80002844:	04f76b63          	bltu	a4,a5,8000289a <syscall+0x7a>
    80002848:	00399713          	slli	a4,s3,0x3
    8000284c:	00005797          	auipc	a5,0x5
    80002850:	fe478793          	addi	a5,a5,-28 # 80007830 <syscalls>
    80002854:	97ba                	add	a5,a5,a4
    80002856:	639c                	ld	a5,0(a5)
    80002858:	c3a9                	beqz	a5,8000289a <syscall+0x7a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000285a:	9782                	jalr	a5
    8000285c:	06a93823          	sd	a0,112(s2)
    if (num != SYS_exit && (p->tracing == 1 || (p->tracing & (1 << num)))) {
    80002860:	4789                	li	a5,2
    80002862:	04f98963          	beq	s3,a5,800028b4 <syscall+0x94>
    80002866:	1684a783          	lw	a5,360(s1)
    8000286a:	4705                	li	a4,1
    8000286c:	00e78663          	beq	a5,a4,80002878 <syscall+0x58>
    80002870:	4137d7bb          	sraw	a5,a5,s3
    80002874:	8ff9                	and	a5,a5,a4
    80002876:	cf9d                	beqz	a5,800028b4 <syscall+0x94>
      printk("%d: %s -> %ld\n", p->pid, syscallnames[num], (long)p->trapframe->a0);
    80002878:	6cb8                	ld	a4,88(s1)
    8000287a:	098e                	slli	s3,s3,0x3
    8000287c:	00005797          	auipc	a5,0x5
    80002880:	fb478793          	addi	a5,a5,-76 # 80007830 <syscalls>
    80002884:	97ce                	add	a5,a5,s3
    80002886:	7b34                	ld	a3,112(a4)
    80002888:	63f0                	ld	a2,192(a5)
    8000288a:	588c                	lw	a1,48(s1)
    8000288c:	00005517          	auipc	a0,0x5
    80002890:	ae450513          	addi	a0,a0,-1308 # 80007370 <etext+0x370>
    80002894:	c6ffd0ef          	jal	80000502 <printk>
    80002898:	a831                	j	800028b4 <syscall+0x94>
    }
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    8000289a:	86ce                	mv	a3,s3
    8000289c:	15848613          	addi	a2,s1,344
    800028a0:	588c                	lw	a1,48(s1)
    800028a2:	00005517          	auipc	a0,0x5
    800028a6:	ade50513          	addi	a0,a0,-1314 # 80007380 <etext+0x380>
    800028aa:	c59fd0ef          	jal	80000502 <printk>
    p->trapframe->a0 = -1;
    800028ae:	6cbc                	ld	a5,88(s1)
    800028b0:	577d                	li	a4,-1
    800028b2:	fbb8                	sd	a4,112(a5)
  }
}
    800028b4:	70a2                	ld	ra,40(sp)
    800028b6:	7402                	ld	s0,32(sp)
    800028b8:	64e2                	ld	s1,24(sp)
    800028ba:	6942                	ld	s2,16(sp)
    800028bc:	69a2                	ld	s3,8(sp)
    800028be:	6145                	addi	sp,sp,48
    800028c0:	8082                	ret

00000000800028c2 <sys_exit>:
#include "vm.h"
#include "syscall.h"

uint64
sys_exit(void)
{
    800028c2:	1101                	addi	sp,sp,-32
    800028c4:	ec06                	sd	ra,24(sp)
    800028c6:	e822                	sd	s0,16(sp)
    800028c8:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028ca:	fec40593          	addi	a1,s0,-20
    800028ce:	4501                	li	a0,0
    800028d0:	ef1ff0ef          	jal	800027c0 <argint>
  if (myproc()->tracing == 1 || (myproc()->tracing & (1 << SYS_exit))) {
    800028d4:	806ff0ef          	jal	800018da <myproc>
    800028d8:	16852703          	lw	a4,360(a0)
    800028dc:	4785                	li	a5,1
    800028de:	00f70863          	beq	a4,a5,800028ee <sys_exit+0x2c>
    800028e2:	ff9fe0ef          	jal	800018da <myproc>
    800028e6:	16852783          	lw	a5,360(a0)
    800028ea:	8b91                	andi	a5,a5,4
    800028ec:	cf81                	beqz	a5,80002904 <sys_exit+0x42>
    printk("%d: exit -> %d\n", myproc()->pid, n);
    800028ee:	fedfe0ef          	jal	800018da <myproc>
    800028f2:	fec42603          	lw	a2,-20(s0)
    800028f6:	590c                	lw	a1,48(a0)
    800028f8:	00005517          	auipc	a0,0x5
    800028fc:	b5050513          	addi	a0,a0,-1200 # 80007448 <etext+0x448>
    80002900:	c03fd0ef          	jal	80000502 <printk>
  }
  kexit(n);
    80002904:	fec42503          	lw	a0,-20(s0)
    80002908:	ed8ff0ef          	jal	80001fe0 <kexit>
  return 0; // not reached
}
    8000290c:	4501                	li	a0,0
    8000290e:	60e2                	ld	ra,24(sp)
    80002910:	6442                	ld	s0,16(sp)
    80002912:	6105                	addi	sp,sp,32
    80002914:	8082                	ret

0000000080002916 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002916:	1141                	addi	sp,sp,-16
    80002918:	e406                	sd	ra,8(sp)
    8000291a:	e022                	sd	s0,0(sp)
    8000291c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    8000291e:	fbdfe0ef          	jal	800018da <myproc>
}
    80002922:	5908                	lw	a0,48(a0)
    80002924:	60a2                	ld	ra,8(sp)
    80002926:	6402                	ld	s0,0(sp)
    80002928:	0141                	addi	sp,sp,16
    8000292a:	8082                	ret

000000008000292c <sys_fork>:

uint64
sys_fork(void)
{
    8000292c:	1141                	addi	sp,sp,-16
    8000292e:	e406                	sd	ra,8(sp)
    80002930:	e022                	sd	s0,0(sp)
    80002932:	0800                	addi	s0,sp,16
  return kfork();
    80002934:	b10ff0ef          	jal	80001c44 <kfork>
}
    80002938:	60a2                	ld	ra,8(sp)
    8000293a:	6402                	ld	s0,0(sp)
    8000293c:	0141                	addi	sp,sp,16
    8000293e:	8082                	ret

0000000080002940 <sys_wait>:

uint64
sys_wait(void)
{
    80002940:	1101                	addi	sp,sp,-32
    80002942:	ec06                	sd	ra,24(sp)
    80002944:	e822                	sd	s0,16(sp)
    80002946:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002948:	fe840593          	addi	a1,s0,-24
    8000294c:	4501                	li	a0,0
    8000294e:	e8fff0ef          	jal	800027dc <argaddr>
  return kwait(p);
    80002952:	fe843503          	ld	a0,-24(s0)
    80002956:	fe4ff0ef          	jal	8000213a <kwait>
}
    8000295a:	60e2                	ld	ra,24(sp)
    8000295c:	6442                	ld	s0,16(sp)
    8000295e:	6105                	addi	sp,sp,32
    80002960:	8082                	ret

0000000080002962 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002962:	7179                	addi	sp,sp,-48
    80002964:	f406                	sd	ra,40(sp)
    80002966:	f022                	sd	s0,32(sp)
    80002968:	ec26                	sd	s1,24(sp)
    8000296a:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    8000296c:	fd840593          	addi	a1,s0,-40
    80002970:	4501                	li	a0,0
    80002972:	e4fff0ef          	jal	800027c0 <argint>
  argint(1, &t);
    80002976:	fdc40593          	addi	a1,s0,-36
    8000297a:	4505                	li	a0,1
    8000297c:	e45ff0ef          	jal	800027c0 <argint>
  addr = myproc()->sz;
    80002980:	f5bfe0ef          	jal	800018da <myproc>
    80002984:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    80002986:	fdc42703          	lw	a4,-36(s0)
    8000298a:	4785                	li	a5,1
    8000298c:	02f70a63          	beq	a4,a5,800029c0 <sys_sbrk+0x5e>
    80002990:	fd842783          	lw	a5,-40(s0)
    80002994:	0207c663          	bltz	a5,800029c0 <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    80002998:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    8000299c:	020007b7          	lui	a5,0x2000
    800029a0:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    800029a2:	07b6                	slli	a5,a5,0xd
    800029a4:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    800029a8:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    800029ac:	8fd9                	or	a5,a5,a4
    800029ae:	e79d                	bnez	a5,800029dc <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    800029b0:	f2bfe0ef          	jal	800018da <myproc>
    800029b4:	fd842703          	lw	a4,-40(s0)
    800029b8:	653c                	ld	a5,72(a0)
    800029ba:	97ba                	add	a5,a5,a4
    800029bc:	e53c                	sd	a5,72(a0)
    800029be:	a039                	j	800029cc <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    800029c0:	fd842503          	lw	a0,-40(s0)
    800029c4:	a22ff0ef          	jal	80001be6 <growproc>
    800029c8:	00054863          	bltz	a0,800029d8 <sys_sbrk+0x76>
  }
  return addr;
}
    800029cc:	8526                	mv	a0,s1
    800029ce:	70a2                	ld	ra,40(sp)
    800029d0:	7402                	ld	s0,32(sp)
    800029d2:	64e2                	ld	s1,24(sp)
    800029d4:	6145                	addi	sp,sp,48
    800029d6:	8082                	ret
      return -1;
    800029d8:	54fd                	li	s1,-1
    800029da:	bfcd                	j	800029cc <sys_sbrk+0x6a>
      return -1;
    800029dc:	54fd                	li	s1,-1
    800029de:	b7fd                	j	800029cc <sys_sbrk+0x6a>

00000000800029e0 <sys_pause>:

uint64
sys_pause(void)
{
    800029e0:	7139                	addi	sp,sp,-64
    800029e2:	fc06                	sd	ra,56(sp)
    800029e4:	f822                	sd	s0,48(sp)
    800029e6:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029e8:	fcc40593          	addi	a1,s0,-52
    800029ec:	4501                	li	a0,0
    800029ee:	dd3ff0ef          	jal	800027c0 <argint>
  if (n < 0)
    800029f2:	fcc42783          	lw	a5,-52(s0)
    800029f6:	0607c863          	bltz	a5,80002a66 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800029fa:	00013517          	auipc	a0,0x13
    800029fe:	11e50513          	addi	a0,a0,286 # 80015b18 <tickslock>
    80002a02:	a16fe0ef          	jal	80000c18 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a06:	fcc42783          	lw	a5,-52(s0)
    80002a0a:	c3b9                	beqz	a5,80002a50 <sys_pause+0x70>
    80002a0c:	f426                	sd	s1,40(sp)
    80002a0e:	f04a                	sd	s2,32(sp)
    80002a10:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a12:	00005997          	auipc	s3,0x5
    80002a16:	fd69a983          	lw	s3,-42(s3) # 800079e8 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a1a:	00013917          	auipc	s2,0x13
    80002a1e:	0fe90913          	addi	s2,s2,254 # 80015b18 <tickslock>
    80002a22:	00005497          	auipc	s1,0x5
    80002a26:	fc648493          	addi	s1,s1,-58 # 800079e8 <ticks>
    if (killed(myproc())) {
    80002a2a:	eb1fe0ef          	jal	800018da <myproc>
    80002a2e:	ee2ff0ef          	jal	80002110 <killed>
    80002a32:	ed0d                	bnez	a0,80002a6c <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a34:	85ca                	mv	a1,s2
    80002a36:	8526                	mv	a0,s1
    80002a38:	c9cff0ef          	jal	80001ed4 <sleep>
  while (ticks - ticks0 < n) {
    80002a3c:	409c                	lw	a5,0(s1)
    80002a3e:	413787bb          	subw	a5,a5,s3
    80002a42:	fcc42703          	lw	a4,-52(s0)
    80002a46:	fee7e2e3          	bltu	a5,a4,80002a2a <sys_pause+0x4a>
    80002a4a:	74a2                	ld	s1,40(sp)
    80002a4c:	7902                	ld	s2,32(sp)
    80002a4e:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a50:	00013517          	auipc	a0,0x13
    80002a54:	0c850513          	addi	a0,a0,200 # 80015b18 <tickslock>
    80002a58:	a44fe0ef          	jal	80000c9c <release>
  return 0;
    80002a5c:	4501                	li	a0,0
}
    80002a5e:	70e2                	ld	ra,56(sp)
    80002a60:	7442                	ld	s0,48(sp)
    80002a62:	6121                	addi	sp,sp,64
    80002a64:	8082                	ret
    n = 0;
    80002a66:	fc042623          	sw	zero,-52(s0)
    80002a6a:	bf41                	j	800029fa <sys_pause+0x1a>
      release(&tickslock);
    80002a6c:	00013517          	auipc	a0,0x13
    80002a70:	0ac50513          	addi	a0,a0,172 # 80015b18 <tickslock>
    80002a74:	a28fe0ef          	jal	80000c9c <release>
      return -1;
    80002a78:	557d                	li	a0,-1
    80002a7a:	74a2                	ld	s1,40(sp)
    80002a7c:	7902                	ld	s2,32(sp)
    80002a7e:	69e2                	ld	s3,24(sp)
    80002a80:	bff9                	j	80002a5e <sys_pause+0x7e>

0000000080002a82 <sys_kill>:

uint64
sys_kill(void)
{
    80002a82:	1101                	addi	sp,sp,-32
    80002a84:	ec06                	sd	ra,24(sp)
    80002a86:	e822                	sd	s0,16(sp)
    80002a88:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a8a:	fec40593          	addi	a1,s0,-20
    80002a8e:	4501                	li	a0,0
    80002a90:	d31ff0ef          	jal	800027c0 <argint>
  return kkill(pid);
    80002a94:	fec42503          	lw	a0,-20(s0)
    80002a98:	deeff0ef          	jal	80002086 <kkill>
}
    80002a9c:	60e2                	ld	ra,24(sp)
    80002a9e:	6442                	ld	s0,16(sp)
    80002aa0:	6105                	addi	sp,sp,32
    80002aa2:	8082                	ret

0000000080002aa4 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002aa4:	1101                	addi	sp,sp,-32
    80002aa6:	ec06                	sd	ra,24(sp)
    80002aa8:	e822                	sd	s0,16(sp)
    80002aaa:	e426                	sd	s1,8(sp)
    80002aac:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002aae:	00013517          	auipc	a0,0x13
    80002ab2:	06a50513          	addi	a0,a0,106 # 80015b18 <tickslock>
    80002ab6:	962fe0ef          	jal	80000c18 <acquire>
  xticks = ticks;
    80002aba:	00005797          	auipc	a5,0x5
    80002abe:	f2e7a783          	lw	a5,-210(a5) # 800079e8 <ticks>
    80002ac2:	84be                	mv	s1,a5
  release(&tickslock);
    80002ac4:	00013517          	auipc	a0,0x13
    80002ac8:	05450513          	addi	a0,a0,84 # 80015b18 <tickslock>
    80002acc:	9d0fe0ef          	jal	80000c9c <release>
  return xticks;
}
    80002ad0:	02049513          	slli	a0,s1,0x20
    80002ad4:	9101                	srli	a0,a0,0x20
    80002ad6:	60e2                	ld	ra,24(sp)
    80002ad8:	6442                	ld	s0,16(sp)
    80002ada:	64a2                	ld	s1,8(sp)
    80002adc:	6105                	addi	sp,sp,32
    80002ade:	8082                	ret

0000000080002ae0 <sys_trace>:

uint64
sys_trace(void)
{
    80002ae0:	1101                	addi	sp,sp,-32
    80002ae2:	ec06                	sd	ra,24(sp)
    80002ae4:	e822                	sd	s0,16(sp)
    80002ae6:	1000                	addi	s0,sp,32
  int on;
  argint(0, &on);
    80002ae8:	fec40593          	addi	a1,s0,-20
    80002aec:	4501                	li	a0,0
    80002aee:	cd3ff0ef          	jal	800027c0 <argint>
  myproc()->tracing = on;
    80002af2:	de9fe0ef          	jal	800018da <myproc>
    80002af6:	fec42783          	lw	a5,-20(s0)
    80002afa:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002afe:	4501                	li	a0,0
    80002b00:	60e2                	ld	ra,24(sp)
    80002b02:	6442                	ld	s0,16(sp)
    80002b04:	6105                	addi	sp,sp,32
    80002b06:	8082                	ret

0000000080002b08 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b08:	7179                	addi	sp,sp,-48
    80002b0a:	f406                	sd	ra,40(sp)
    80002b0c:	f022                	sd	s0,32(sp)
    80002b0e:	ec26                	sd	s1,24(sp)
    80002b10:	e84a                	sd	s2,16(sp)
    80002b12:	e44e                	sd	s3,8(sp)
    80002b14:	e052                	sd	s4,0(sp)
    80002b16:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b18:	00005597          	auipc	a1,0x5
    80002b1c:	94058593          	addi	a1,a1,-1728 # 80007458 <etext+0x458>
    80002b20:	00013517          	auipc	a0,0x13
    80002b24:	01050513          	addi	a0,a0,16 # 80015b30 <bcache>
    80002b28:	870fe0ef          	jal	80000b98 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b2c:	0001b797          	auipc	a5,0x1b
    80002b30:	00478793          	addi	a5,a5,4 # 8001db30 <bcache+0x8000>
    80002b34:	0001b717          	auipc	a4,0x1b
    80002b38:	26470713          	addi	a4,a4,612 # 8001dd98 <bcache+0x8268>
    80002b3c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b40:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b44:	00013497          	auipc	s1,0x13
    80002b48:	00448493          	addi	s1,s1,4 # 80015b48 <bcache+0x18>
    b->next = bcache.head.next;
    80002b4c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002b4e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002b50:	00005a17          	auipc	s4,0x5
    80002b54:	910a0a13          	addi	s4,s4,-1776 # 80007460 <etext+0x460>
    b->next = bcache.head.next;
    80002b58:	2b893783          	ld	a5,696(s2)
    80002b5c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002b5e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002b62:	85d2                	mv	a1,s4
    80002b64:	01048513          	addi	a0,s1,16
    80002b68:	394010ef          	jal	80003efc <initsleeplock>
    bcache.head.next->prev = b;
    80002b6c:	2b893783          	ld	a5,696(s2)
    80002b70:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002b72:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002b76:	45848493          	addi	s1,s1,1112
    80002b7a:	fd349fe3          	bne	s1,s3,80002b58 <binit+0x50>
  }
}
    80002b7e:	70a2                	ld	ra,40(sp)
    80002b80:	7402                	ld	s0,32(sp)
    80002b82:	64e2                	ld	s1,24(sp)
    80002b84:	6942                	ld	s2,16(sp)
    80002b86:	69a2                	ld	s3,8(sp)
    80002b88:	6a02                	ld	s4,0(sp)
    80002b8a:	6145                	addi	sp,sp,48
    80002b8c:	8082                	ret

0000000080002b8e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002b8e:	7179                	addi	sp,sp,-48
    80002b90:	f406                	sd	ra,40(sp)
    80002b92:	f022                	sd	s0,32(sp)
    80002b94:	ec26                	sd	s1,24(sp)
    80002b96:	e84a                	sd	s2,16(sp)
    80002b98:	e44e                	sd	s3,8(sp)
    80002b9a:	1800                	addi	s0,sp,48
    80002b9c:	892a                	mv	s2,a0
    80002b9e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002ba0:	00013517          	auipc	a0,0x13
    80002ba4:	f9050513          	addi	a0,a0,-112 # 80015b30 <bcache>
    80002ba8:	870fe0ef          	jal	80000c18 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002bac:	0001b497          	auipc	s1,0x1b
    80002bb0:	23c4b483          	ld	s1,572(s1) # 8001dde8 <bcache+0x82b8>
    80002bb4:	0001b797          	auipc	a5,0x1b
    80002bb8:	1e478793          	addi	a5,a5,484 # 8001dd98 <bcache+0x8268>
    80002bbc:	02f48b63          	beq	s1,a5,80002bf2 <bread+0x64>
    80002bc0:	873e                	mv	a4,a5
    80002bc2:	a021                	j	80002bca <bread+0x3c>
    80002bc4:	68a4                	ld	s1,80(s1)
    80002bc6:	02e48663          	beq	s1,a4,80002bf2 <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002bca:	449c                	lw	a5,8(s1)
    80002bcc:	ff279ce3          	bne	a5,s2,80002bc4 <bread+0x36>
    80002bd0:	44dc                	lw	a5,12(s1)
    80002bd2:	ff3799e3          	bne	a5,s3,80002bc4 <bread+0x36>
      b->refcnt++;
    80002bd6:	40bc                	lw	a5,64(s1)
    80002bd8:	2785                	addiw	a5,a5,1
    80002bda:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002bdc:	00013517          	auipc	a0,0x13
    80002be0:	f5450513          	addi	a0,a0,-172 # 80015b30 <bcache>
    80002be4:	8b8fe0ef          	jal	80000c9c <release>
      acquiresleep(&b->lock);
    80002be8:	01048513          	addi	a0,s1,16
    80002bec:	346010ef          	jal	80003f32 <acquiresleep>
      return b;
    80002bf0:	a889                	j	80002c42 <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002bf2:	0001b497          	auipc	s1,0x1b
    80002bf6:	1ee4b483          	ld	s1,494(s1) # 8001dde0 <bcache+0x82b0>
    80002bfa:	0001b797          	auipc	a5,0x1b
    80002bfe:	19e78793          	addi	a5,a5,414 # 8001dd98 <bcache+0x8268>
    80002c02:	00f48863          	beq	s1,a5,80002c12 <bread+0x84>
    80002c06:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002c08:	40bc                	lw	a5,64(s1)
    80002c0a:	cb91                	beqz	a5,80002c1e <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c0c:	64a4                	ld	s1,72(s1)
    80002c0e:	fee49de3          	bne	s1,a4,80002c08 <bread+0x7a>
  panic("bget: no buffers");
    80002c12:	00005517          	auipc	a0,0x5
    80002c16:	85650513          	addi	a0,a0,-1962 # 80007468 <etext+0x468>
    80002c1a:	c21fd0ef          	jal	8000083a <panic>
      b->dev = dev;
    80002c1e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c22:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c26:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c2a:	4785                	li	a5,1
    80002c2c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c2e:	00013517          	auipc	a0,0x13
    80002c32:	f0250513          	addi	a0,a0,-254 # 80015b30 <bcache>
    80002c36:	866fe0ef          	jal	80000c9c <release>
      acquiresleep(&b->lock);
    80002c3a:	01048513          	addi	a0,s1,16
    80002c3e:	2f4010ef          	jal	80003f32 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002c42:	409c                	lw	a5,0(s1)
    80002c44:	cb89                	beqz	a5,80002c56 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002c46:	8526                	mv	a0,s1
    80002c48:	70a2                	ld	ra,40(sp)
    80002c4a:	7402                	ld	s0,32(sp)
    80002c4c:	64e2                	ld	s1,24(sp)
    80002c4e:	6942                	ld	s2,16(sp)
    80002c50:	69a2                	ld	s3,8(sp)
    80002c52:	6145                	addi	sp,sp,48
    80002c54:	8082                	ret
    virtio_disk_rw(b, 0);
    80002c56:	4581                	li	a1,0
    80002c58:	8526                	mv	a0,s1
    80002c5a:	2b9020ef          	jal	80005712 <virtio_disk_rw>
    b->valid = 1;
    80002c5e:	4785                	li	a5,1
    80002c60:	c09c                	sw	a5,0(s1)
  return b;
    80002c62:	b7d5                	j	80002c46 <bread+0xb8>

0000000080002c64 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002c64:	1101                	addi	sp,sp,-32
    80002c66:	ec06                	sd	ra,24(sp)
    80002c68:	e822                	sd	s0,16(sp)
    80002c6a:	e426                	sd	s1,8(sp)
    80002c6c:	1000                	addi	s0,sp,32
    80002c6e:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002c70:	0541                	addi	a0,a0,16
    80002c72:	33e010ef          	jal	80003fb0 <holdingsleep>
    80002c76:	c911                	beqz	a0,80002c8a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002c78:	4585                	li	a1,1
    80002c7a:	8526                	mv	a0,s1
    80002c7c:	297020ef          	jal	80005712 <virtio_disk_rw>
}
    80002c80:	60e2                	ld	ra,24(sp)
    80002c82:	6442                	ld	s0,16(sp)
    80002c84:	64a2                	ld	s1,8(sp)
    80002c86:	6105                	addi	sp,sp,32
    80002c88:	8082                	ret
    panic("bwrite");
    80002c8a:	00004517          	auipc	a0,0x4
    80002c8e:	7f650513          	addi	a0,a0,2038 # 80007480 <etext+0x480>
    80002c92:	ba9fd0ef          	jal	8000083a <panic>

0000000080002c96 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002c96:	1101                	addi	sp,sp,-32
    80002c98:	ec06                	sd	ra,24(sp)
    80002c9a:	e822                	sd	s0,16(sp)
    80002c9c:	e426                	sd	s1,8(sp)
    80002c9e:	e04a                	sd	s2,0(sp)
    80002ca0:	1000                	addi	s0,sp,32
    80002ca2:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ca4:	01050913          	addi	s2,a0,16
    80002ca8:	854a                	mv	a0,s2
    80002caa:	306010ef          	jal	80003fb0 <holdingsleep>
    80002cae:	c125                	beqz	a0,80002d0e <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002cb0:	854a                	mv	a0,s2
    80002cb2:	2c6010ef          	jal	80003f78 <releasesleep>

  acquire(&bcache.lock);
    80002cb6:	00013517          	auipc	a0,0x13
    80002cba:	e7a50513          	addi	a0,a0,-390 # 80015b30 <bcache>
    80002cbe:	f5bfd0ef          	jal	80000c18 <acquire>
  b->refcnt--;
    80002cc2:	40bc                	lw	a5,64(s1)
    80002cc4:	37fd                	addiw	a5,a5,-1
    80002cc6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002cc8:	e79d                	bnez	a5,80002cf6 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002cca:	68b8                	ld	a4,80(s1)
    80002ccc:	64bc                	ld	a5,72(s1)
    80002cce:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002cd0:	68b8                	ld	a4,80(s1)
    80002cd2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002cd4:	0001b797          	auipc	a5,0x1b
    80002cd8:	e5c78793          	addi	a5,a5,-420 # 8001db30 <bcache+0x8000>
    80002cdc:	2b87b703          	ld	a4,696(a5)
    80002ce0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002ce2:	0001b717          	auipc	a4,0x1b
    80002ce6:	0b670713          	addi	a4,a4,182 # 8001dd98 <bcache+0x8268>
    80002cea:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002cec:	2b87b703          	ld	a4,696(a5)
    80002cf0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002cf2:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002cf6:	00013517          	auipc	a0,0x13
    80002cfa:	e3a50513          	addi	a0,a0,-454 # 80015b30 <bcache>
    80002cfe:	f9ffd0ef          	jal	80000c9c <release>
}
    80002d02:	60e2                	ld	ra,24(sp)
    80002d04:	6442                	ld	s0,16(sp)
    80002d06:	64a2                	ld	s1,8(sp)
    80002d08:	6902                	ld	s2,0(sp)
    80002d0a:	6105                	addi	sp,sp,32
    80002d0c:	8082                	ret
    panic("brelse");
    80002d0e:	00004517          	auipc	a0,0x4
    80002d12:	77a50513          	addi	a0,a0,1914 # 80007488 <etext+0x488>
    80002d16:	b25fd0ef          	jal	8000083a <panic>

0000000080002d1a <bpin>:

void
bpin(struct buf *b)
{
    80002d1a:	1101                	addi	sp,sp,-32
    80002d1c:	ec06                	sd	ra,24(sp)
    80002d1e:	e822                	sd	s0,16(sp)
    80002d20:	e426                	sd	s1,8(sp)
    80002d22:	1000                	addi	s0,sp,32
    80002d24:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d26:	00013517          	auipc	a0,0x13
    80002d2a:	e0a50513          	addi	a0,a0,-502 # 80015b30 <bcache>
    80002d2e:	eebfd0ef          	jal	80000c18 <acquire>
  b->refcnt++;
    80002d32:	40bc                	lw	a5,64(s1)
    80002d34:	2785                	addiw	a5,a5,1
    80002d36:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d38:	00013517          	auipc	a0,0x13
    80002d3c:	df850513          	addi	a0,a0,-520 # 80015b30 <bcache>
    80002d40:	f5dfd0ef          	jal	80000c9c <release>
}
    80002d44:	60e2                	ld	ra,24(sp)
    80002d46:	6442                	ld	s0,16(sp)
    80002d48:	64a2                	ld	s1,8(sp)
    80002d4a:	6105                	addi	sp,sp,32
    80002d4c:	8082                	ret

0000000080002d4e <bunpin>:

void
bunpin(struct buf *b)
{
    80002d4e:	1101                	addi	sp,sp,-32
    80002d50:	ec06                	sd	ra,24(sp)
    80002d52:	e822                	sd	s0,16(sp)
    80002d54:	e426                	sd	s1,8(sp)
    80002d56:	1000                	addi	s0,sp,32
    80002d58:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d5a:	00013517          	auipc	a0,0x13
    80002d5e:	dd650513          	addi	a0,a0,-554 # 80015b30 <bcache>
    80002d62:	eb7fd0ef          	jal	80000c18 <acquire>
  b->refcnt--;
    80002d66:	40bc                	lw	a5,64(s1)
    80002d68:	37fd                	addiw	a5,a5,-1
    80002d6a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d6c:	00013517          	auipc	a0,0x13
    80002d70:	dc450513          	addi	a0,a0,-572 # 80015b30 <bcache>
    80002d74:	f29fd0ef          	jal	80000c9c <release>
}
    80002d78:	60e2                	ld	ra,24(sp)
    80002d7a:	6442                	ld	s0,16(sp)
    80002d7c:	64a2                	ld	s1,8(sp)
    80002d7e:	6105                	addi	sp,sp,32
    80002d80:	8082                	ret

0000000080002d82 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002d82:	1101                	addi	sp,sp,-32
    80002d84:	ec06                	sd	ra,24(sp)
    80002d86:	e822                	sd	s0,16(sp)
    80002d88:	e426                	sd	s1,8(sp)
    80002d8a:	e04a                	sd	s2,0(sp)
    80002d8c:	1000                	addi	s0,sp,32
    80002d8e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002d90:	00d5d79b          	srliw	a5,a1,0xd
    80002d94:	0001b597          	auipc	a1,0x1b
    80002d98:	4785a583          	lw	a1,1144(a1) # 8001e20c <sb+0x1c>
    80002d9c:	9dbd                	addw	a1,a1,a5
    80002d9e:	df1ff0ef          	jal	80002b8e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002da2:	0074f713          	andi	a4,s1,7
    80002da6:	4785                	li	a5,1
    80002da8:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002dac:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002dae:	90d9                	srli	s1,s1,0x36
    80002db0:	00950733          	add	a4,a0,s1
    80002db4:	05874703          	lbu	a4,88(a4)
    80002db8:	00e7f6b3          	and	a3,a5,a4
    80002dbc:	c29d                	beqz	a3,80002de2 <bfree+0x60>
    80002dbe:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002dc0:	94aa                	add	s1,s1,a0
    80002dc2:	fff7c793          	not	a5,a5
    80002dc6:	8f7d                	and	a4,a4,a5
    80002dc8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002dcc:	00a010ef          	jal	80003dd6 <log_write>
  brelse(bp);
    80002dd0:	854a                	mv	a0,s2
    80002dd2:	ec5ff0ef          	jal	80002c96 <brelse>
}
    80002dd6:	60e2                	ld	ra,24(sp)
    80002dd8:	6442                	ld	s0,16(sp)
    80002dda:	64a2                	ld	s1,8(sp)
    80002ddc:	6902                	ld	s2,0(sp)
    80002dde:	6105                	addi	sp,sp,32
    80002de0:	8082                	ret
    panic("freeing free block");
    80002de2:	00004517          	auipc	a0,0x4
    80002de6:	6ae50513          	addi	a0,a0,1710 # 80007490 <etext+0x490>
    80002dea:	a51fd0ef          	jal	8000083a <panic>

0000000080002dee <balloc>:
{
    80002dee:	715d                	addi	sp,sp,-80
    80002df0:	e486                	sd	ra,72(sp)
    80002df2:	e0a2                	sd	s0,64(sp)
    80002df4:	fc26                	sd	s1,56(sp)
    80002df6:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002df8:	0001b797          	auipc	a5,0x1b
    80002dfc:	3fc7a783          	lw	a5,1020(a5) # 8001e1f4 <sb+0x4>
    80002e00:	0e078263          	beqz	a5,80002ee4 <balloc+0xf6>
    80002e04:	f84a                	sd	s2,48(sp)
    80002e06:	f44e                	sd	s3,40(sp)
    80002e08:	f052                	sd	s4,32(sp)
    80002e0a:	ec56                	sd	s5,24(sp)
    80002e0c:	e85a                	sd	s6,16(sp)
    80002e0e:	e45e                	sd	s7,8(sp)
    80002e10:	e062                	sd	s8,0(sp)
    80002e12:	8baa                	mv	s7,a0
    80002e14:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e16:	0001bb17          	auipc	s6,0x1b
    80002e1a:	3dab0b13          	addi	s6,s6,986 # 8001e1f0 <sb>
      m = 1 << (bi % 8);
    80002e1e:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e20:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002e22:	6c09                	lui	s8,0x2
    80002e24:	a09d                	j	80002e8a <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002e26:	97ca                	add	a5,a5,s2
    80002e28:	8e55                	or	a2,a2,a3
    80002e2a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e2e:	854a                	mv	a0,s2
    80002e30:	7a7000ef          	jal	80003dd6 <log_write>
        brelse(bp);
    80002e34:	854a                	mv	a0,s2
    80002e36:	e61ff0ef          	jal	80002c96 <brelse>
  bp = bread(dev, bno);
    80002e3a:	85a6                	mv	a1,s1
    80002e3c:	855e                	mv	a0,s7
    80002e3e:	d51ff0ef          	jal	80002b8e <bread>
    80002e42:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002e44:	40000613          	li	a2,1024
    80002e48:	4581                	li	a1,0
    80002e4a:	05850513          	addi	a0,a0,88
    80002e4e:	e87fd0ef          	jal	80000cd4 <memset>
  log_write(bp);
    80002e52:	854a                	mv	a0,s2
    80002e54:	783000ef          	jal	80003dd6 <log_write>
  brelse(bp);
    80002e58:	854a                	mv	a0,s2
    80002e5a:	e3dff0ef          	jal	80002c96 <brelse>
        return b + bi;
    80002e5e:	7942                	ld	s2,48(sp)
    80002e60:	79a2                	ld	s3,40(sp)
    80002e62:	7a02                	ld	s4,32(sp)
    80002e64:	6ae2                	ld	s5,24(sp)
    80002e66:	6b42                	ld	s6,16(sp)
    80002e68:	6ba2                	ld	s7,8(sp)
    80002e6a:	6c02                	ld	s8,0(sp)
}
    80002e6c:	8526                	mv	a0,s1
    80002e6e:	60a6                	ld	ra,72(sp)
    80002e70:	6406                	ld	s0,64(sp)
    80002e72:	74e2                	ld	s1,56(sp)
    80002e74:	6161                	addi	sp,sp,80
    80002e76:	8082                	ret
    brelse(bp);
    80002e78:	854a                	mv	a0,s2
    80002e7a:	e1dff0ef          	jal	80002c96 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002e7e:	015c0abb          	addw	s5,s8,s5
    80002e82:	004b2783          	lw	a5,4(s6)
    80002e86:	04faf863          	bgeu	s5,a5,80002ed6 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002e8a:	40dad59b          	sraiw	a1,s5,0xd
    80002e8e:	01cb2783          	lw	a5,28(s6)
    80002e92:	9dbd                	addw	a1,a1,a5
    80002e94:	855e                	mv	a0,s7
    80002e96:	cf9ff0ef          	jal	80002b8e <bread>
    80002e9a:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e9c:	004b2503          	lw	a0,4(s6)
    80002ea0:	84d6                	mv	s1,s5
    80002ea2:	4701                	li	a4,0
    80002ea4:	fca4fae3          	bgeu	s1,a0,80002e78 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002ea8:	00777693          	andi	a3,a4,7
    80002eac:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002eb0:	41f7579b          	sraiw	a5,a4,0x1f
    80002eb4:	01d7d79b          	srliw	a5,a5,0x1d
    80002eb8:	9fb9                	addw	a5,a5,a4
    80002eba:	4037d79b          	sraiw	a5,a5,0x3
    80002ebe:	00f90633          	add	a2,s2,a5
    80002ec2:	05864603          	lbu	a2,88(a2)
    80002ec6:	00c6f5b3          	and	a1,a3,a2
    80002eca:	ddb1                	beqz	a1,80002e26 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002ecc:	2705                	addiw	a4,a4,1
    80002ece:	2485                	addiw	s1,s1,1
    80002ed0:	fd471ae3          	bne	a4,s4,80002ea4 <balloc+0xb6>
    80002ed4:	b755                	j	80002e78 <balloc+0x8a>
    80002ed6:	7942                	ld	s2,48(sp)
    80002ed8:	79a2                	ld	s3,40(sp)
    80002eda:	7a02                	ld	s4,32(sp)
    80002edc:	6ae2                	ld	s5,24(sp)
    80002ede:	6b42                	ld	s6,16(sp)
    80002ee0:	6ba2                	ld	s7,8(sp)
    80002ee2:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80002ee4:	00004517          	auipc	a0,0x4
    80002ee8:	5c450513          	addi	a0,a0,1476 # 800074a8 <etext+0x4a8>
    80002eec:	e16fd0ef          	jal	80000502 <printk>
  return 0;
    80002ef0:	4481                	li	s1,0
    80002ef2:	bfad                	j	80002e6c <balloc+0x7e>

0000000080002ef4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002ef4:	7179                	addi	sp,sp,-48
    80002ef6:	f406                	sd	ra,40(sp)
    80002ef8:	f022                	sd	s0,32(sp)
    80002efa:	ec26                	sd	s1,24(sp)
    80002efc:	e84a                	sd	s2,16(sp)
    80002efe:	e44e                	sd	s3,8(sp)
    80002f00:	1800                	addi	s0,sp,48
    80002f02:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002f04:	47ad                	li	a5,11
    80002f06:	02b7e363          	bltu	a5,a1,80002f2c <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80002f0a:	02059793          	slli	a5,a1,0x20
    80002f0e:	01e7d593          	srli	a1,a5,0x1e
    80002f12:	00b509b3          	add	s3,a0,a1
    80002f16:	0509a483          	lw	s1,80(s3)
    80002f1a:	e0b5                	bnez	s1,80002f7e <bmap+0x8a>
      addr = balloc(ip->dev);
    80002f1c:	4108                	lw	a0,0(a0)
    80002f1e:	ed1ff0ef          	jal	80002dee <balloc>
    80002f22:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f24:	cd29                	beqz	a0,80002f7e <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002f26:	04a9a823          	sw	a0,80(s3)
    80002f2a:	a891                	j	80002f7e <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f2c:	ff45879b          	addiw	a5,a1,-12
    80002f30:	873e                	mv	a4,a5
    80002f32:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80002f34:	0ff00793          	li	a5,255
    80002f38:	06e7e763          	bltu	a5,a4,80002fa6 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002f3c:	08052483          	lw	s1,128(a0)
    80002f40:	e891                	bnez	s1,80002f54 <bmap+0x60>
      addr = balloc(ip->dev);
    80002f42:	4108                	lw	a0,0(a0)
    80002f44:	eabff0ef          	jal	80002dee <balloc>
    80002f48:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f4a:	c915                	beqz	a0,80002f7e <bmap+0x8a>
    80002f4c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002f4e:	08a92023          	sw	a0,128(s2)
    80002f52:	a011                	j	80002f56 <bmap+0x62>
    80002f54:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002f56:	85a6                	mv	a1,s1
    80002f58:	00092503          	lw	a0,0(s2)
    80002f5c:	c33ff0ef          	jal	80002b8e <bread>
    80002f60:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002f62:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002f66:	02099713          	slli	a4,s3,0x20
    80002f6a:	01e75593          	srli	a1,a4,0x1e
    80002f6e:	97ae                	add	a5,a5,a1
    80002f70:	89be                	mv	s3,a5
    80002f72:	4384                	lw	s1,0(a5)
    80002f74:	cc89                	beqz	s1,80002f8e <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002f76:	8552                	mv	a0,s4
    80002f78:	d1fff0ef          	jal	80002c96 <brelse>
    return addr;
    80002f7c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002f7e:	8526                	mv	a0,s1
    80002f80:	70a2                	ld	ra,40(sp)
    80002f82:	7402                	ld	s0,32(sp)
    80002f84:	64e2                	ld	s1,24(sp)
    80002f86:	6942                	ld	s2,16(sp)
    80002f88:	69a2                	ld	s3,8(sp)
    80002f8a:	6145                	addi	sp,sp,48
    80002f8c:	8082                	ret
      addr = balloc(ip->dev);
    80002f8e:	00092503          	lw	a0,0(s2)
    80002f92:	e5dff0ef          	jal	80002dee <balloc>
    80002f96:	84aa                	mv	s1,a0
      if (addr) {
    80002f98:	dd79                	beqz	a0,80002f76 <bmap+0x82>
        a[bn] = addr;
    80002f9a:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002f9e:	8552                	mv	a0,s4
    80002fa0:	637000ef          	jal	80003dd6 <log_write>
    80002fa4:	bfc9                	j	80002f76 <bmap+0x82>
    80002fa6:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002fa8:	00004517          	auipc	a0,0x4
    80002fac:	51850513          	addi	a0,a0,1304 # 800074c0 <etext+0x4c0>
    80002fb0:	88bfd0ef          	jal	8000083a <panic>

0000000080002fb4 <iget>:
{
    80002fb4:	7179                	addi	sp,sp,-48
    80002fb6:	f406                	sd	ra,40(sp)
    80002fb8:	f022                	sd	s0,32(sp)
    80002fba:	ec26                	sd	s1,24(sp)
    80002fbc:	e84a                	sd	s2,16(sp)
    80002fbe:	e44e                	sd	s3,8(sp)
    80002fc0:	e052                	sd	s4,0(sp)
    80002fc2:	1800                	addi	s0,sp,48
    80002fc4:	89aa                	mv	s3,a0
    80002fc6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002fc8:	0001b517          	auipc	a0,0x1b
    80002fcc:	24850513          	addi	a0,a0,584 # 8001e210 <itable>
    80002fd0:	c49fd0ef          	jal	80000c18 <acquire>
  empty = 0;
    80002fd4:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002fd6:	0001b497          	auipc	s1,0x1b
    80002fda:	25248493          	addi	s1,s1,594 # 8001e228 <itable+0x18>
    80002fde:	0001d697          	auipc	a3,0x1d
    80002fe2:	cda68693          	addi	a3,a3,-806 # 8001fcb8 <log>
    80002fe6:	a819                	j	80002ffc <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002fe8:	0017b793          	seqz	a5,a5
    80002fec:	00193713          	seqz	a4,s2
    80002ff0:	8ff9                	and	a5,a5,a4
    80002ff2:	eb85                	bnez	a5,80003022 <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80002ff4:	08848493          	addi	s1,s1,136
    80002ff8:	02d48763          	beq	s1,a3,80003026 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80002ffc:	449c                	lw	a5,8(s1)
    80002ffe:	fef055e3          	blez	a5,80002fe8 <iget+0x34>
    80003002:	4098                	lw	a4,0(s1)
    80003004:	ff3718e3          	bne	a4,s3,80002ff4 <iget+0x40>
    80003008:	40d8                	lw	a4,4(s1)
    8000300a:	ff4715e3          	bne	a4,s4,80002ff4 <iget+0x40>
      ip->ref++;
    8000300e:	2785                	addiw	a5,a5,1
    80003010:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80003012:	0001b517          	auipc	a0,0x1b
    80003016:	1fe50513          	addi	a0,a0,510 # 8001e210 <itable>
    8000301a:	c83fd0ef          	jal	80000c9c <release>
      return ip;
    8000301e:	8926                	mv	s2,s1
    80003020:	a025                	j	80003048 <iget+0x94>
      empty = ip;
    80003022:	8926                	mv	s2,s1
    80003024:	bfc1                	j	80002ff4 <iget+0x40>
  if (empty == 0)
    80003026:	02090a63          	beqz	s2,8000305a <iget+0xa6>
  ip->dev = dev;
    8000302a:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000302e:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80003032:	4785                	li	a5,1
    80003034:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003038:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000303c:	0001b517          	auipc	a0,0x1b
    80003040:	1d450513          	addi	a0,a0,468 # 8001e210 <itable>
    80003044:	c59fd0ef          	jal	80000c9c <release>
}
    80003048:	854a                	mv	a0,s2
    8000304a:	70a2                	ld	ra,40(sp)
    8000304c:	7402                	ld	s0,32(sp)
    8000304e:	64e2                	ld	s1,24(sp)
    80003050:	6942                	ld	s2,16(sp)
    80003052:	69a2                	ld	s3,8(sp)
    80003054:	6a02                	ld	s4,0(sp)
    80003056:	6145                	addi	sp,sp,48
    80003058:	8082                	ret
    panic("iget: no inodes");
    8000305a:	00004517          	auipc	a0,0x4
    8000305e:	47e50513          	addi	a0,a0,1150 # 800074d8 <etext+0x4d8>
    80003062:	fd8fd0ef          	jal	8000083a <panic>

0000000080003066 <iinit>:
{
    80003066:	7179                	addi	sp,sp,-48
    80003068:	f406                	sd	ra,40(sp)
    8000306a:	f022                	sd	s0,32(sp)
    8000306c:	ec26                	sd	s1,24(sp)
    8000306e:	e84a                	sd	s2,16(sp)
    80003070:	e44e                	sd	s3,8(sp)
    80003072:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80003074:	00004597          	auipc	a1,0x4
    80003078:	47458593          	addi	a1,a1,1140 # 800074e8 <etext+0x4e8>
    8000307c:	0001b517          	auipc	a0,0x1b
    80003080:	19450513          	addi	a0,a0,404 # 8001e210 <itable>
    80003084:	b15fd0ef          	jal	80000b98 <initlock>
  for (i = 0; i < NINODE; i++) {
    80003088:	0001b497          	auipc	s1,0x1b
    8000308c:	1b048493          	addi	s1,s1,432 # 8001e238 <itable+0x28>
    80003090:	0001d997          	auipc	s3,0x1d
    80003094:	c3898993          	addi	s3,s3,-968 # 8001fcc8 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80003098:	00004917          	auipc	s2,0x4
    8000309c:	45890913          	addi	s2,s2,1112 # 800074f0 <etext+0x4f0>
    800030a0:	85ca                	mv	a1,s2
    800030a2:	8526                	mv	a0,s1
    800030a4:	659000ef          	jal	80003efc <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    800030a8:	08848493          	addi	s1,s1,136
    800030ac:	ff349ae3          	bne	s1,s3,800030a0 <iinit+0x3a>
}
    800030b0:	70a2                	ld	ra,40(sp)
    800030b2:	7402                	ld	s0,32(sp)
    800030b4:	64e2                	ld	s1,24(sp)
    800030b6:	6942                	ld	s2,16(sp)
    800030b8:	69a2                	ld	s3,8(sp)
    800030ba:	6145                	addi	sp,sp,48
    800030bc:	8082                	ret

00000000800030be <ialloc>:
{
    800030be:	7139                	addi	sp,sp,-64
    800030c0:	fc06                	sd	ra,56(sp)
    800030c2:	f822                	sd	s0,48(sp)
    800030c4:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    800030c6:	0001b717          	auipc	a4,0x1b
    800030ca:	13672703          	lw	a4,310(a4) # 8001e1fc <sb+0xc>
    800030ce:	4785                	li	a5,1
    800030d0:	06e7f063          	bgeu	a5,a4,80003130 <ialloc+0x72>
    800030d4:	f426                	sd	s1,40(sp)
    800030d6:	f04a                	sd	s2,32(sp)
    800030d8:	ec4e                	sd	s3,24(sp)
    800030da:	e852                	sd	s4,16(sp)
    800030dc:	e456                	sd	s5,8(sp)
    800030de:	e05a                	sd	s6,0(sp)
    800030e0:	8aaa                	mv	s5,a0
    800030e2:	8b2e                	mv	s6,a1
    800030e4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800030e6:	0001ba17          	auipc	s4,0x1b
    800030ea:	10aa0a13          	addi	s4,s4,266 # 8001e1f0 <sb>
    800030ee:	00495593          	srli	a1,s2,0x4
    800030f2:	018a2783          	lw	a5,24(s4)
    800030f6:	9dbd                	addw	a1,a1,a5
    800030f8:	8556                	mv	a0,s5
    800030fa:	a95ff0ef          	jal	80002b8e <bread>
    800030fe:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    80003100:	05850993          	addi	s3,a0,88
    80003104:	00f97793          	andi	a5,s2,15
    80003108:	079a                	slli	a5,a5,0x6
    8000310a:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    8000310c:	00099783          	lh	a5,0(s3)
    80003110:	cb9d                	beqz	a5,80003146 <ialloc+0x88>
    brelse(bp);
    80003112:	b85ff0ef          	jal	80002c96 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003116:	0905                	addi	s2,s2,1
    80003118:	00ca2703          	lw	a4,12(s4)
    8000311c:	0009079b          	sext.w	a5,s2
    80003120:	fce7e7e3          	bltu	a5,a4,800030ee <ialloc+0x30>
    80003124:	74a2                	ld	s1,40(sp)
    80003126:	7902                	ld	s2,32(sp)
    80003128:	69e2                	ld	s3,24(sp)
    8000312a:	6a42                	ld	s4,16(sp)
    8000312c:	6aa2                	ld	s5,8(sp)
    8000312e:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    80003130:	00004517          	auipc	a0,0x4
    80003134:	3c850513          	addi	a0,a0,968 # 800074f8 <etext+0x4f8>
    80003138:	bcafd0ef          	jal	80000502 <printk>
  return 0;
    8000313c:	4501                	li	a0,0
}
    8000313e:	70e2                	ld	ra,56(sp)
    80003140:	7442                	ld	s0,48(sp)
    80003142:	6121                	addi	sp,sp,64
    80003144:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80003146:	04000613          	li	a2,64
    8000314a:	4581                	li	a1,0
    8000314c:	854e                	mv	a0,s3
    8000314e:	b87fd0ef          	jal	80000cd4 <memset>
      dip->type = type;
    80003152:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    80003156:	8526                	mv	a0,s1
    80003158:	47f000ef          	jal	80003dd6 <log_write>
      brelse(bp);
    8000315c:	8526                	mv	a0,s1
    8000315e:	b39ff0ef          	jal	80002c96 <brelse>
      return iget(dev, inum);
    80003162:	0009059b          	sext.w	a1,s2
    80003166:	8556                	mv	a0,s5
    80003168:	e4dff0ef          	jal	80002fb4 <iget>
    8000316c:	74a2                	ld	s1,40(sp)
    8000316e:	7902                	ld	s2,32(sp)
    80003170:	69e2                	ld	s3,24(sp)
    80003172:	6a42                	ld	s4,16(sp)
    80003174:	6aa2                	ld	s5,8(sp)
    80003176:	6b02                	ld	s6,0(sp)
    80003178:	b7d9                	j	8000313e <ialloc+0x80>

000000008000317a <iupdate>:
{
    8000317a:	1101                	addi	sp,sp,-32
    8000317c:	ec06                	sd	ra,24(sp)
    8000317e:	e822                	sd	s0,16(sp)
    80003180:	e426                	sd	s1,8(sp)
    80003182:	e04a                	sd	s2,0(sp)
    80003184:	1000                	addi	s0,sp,32
    80003186:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003188:	415c                	lw	a5,4(a0)
    8000318a:	0047d79b          	srliw	a5,a5,0x4
    8000318e:	0001b597          	auipc	a1,0x1b
    80003192:	07a5a583          	lw	a1,122(a1) # 8001e208 <sb+0x18>
    80003196:	9dbd                	addw	a1,a1,a5
    80003198:	4108                	lw	a0,0(a0)
    8000319a:	9f5ff0ef          	jal	80002b8e <bread>
    8000319e:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800031a0:	05850793          	addi	a5,a0,88
    800031a4:	40d8                	lw	a4,4(s1)
    800031a6:	8b3d                	andi	a4,a4,15
    800031a8:	071a                	slli	a4,a4,0x6
    800031aa:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800031ac:	04449703          	lh	a4,68(s1)
    800031b0:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800031b4:	04649703          	lh	a4,70(s1)
    800031b8:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800031bc:	04849703          	lh	a4,72(s1)
    800031c0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800031c4:	04a49703          	lh	a4,74(s1)
    800031c8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800031cc:	44f8                	lw	a4,76(s1)
    800031ce:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800031d0:	03400613          	li	a2,52
    800031d4:	05048593          	addi	a1,s1,80
    800031d8:	00c78513          	addi	a0,a5,12
    800031dc:	b55fd0ef          	jal	80000d30 <memmove>
  log_write(bp);
    800031e0:	854a                	mv	a0,s2
    800031e2:	3f5000ef          	jal	80003dd6 <log_write>
  brelse(bp);
    800031e6:	854a                	mv	a0,s2
    800031e8:	aafff0ef          	jal	80002c96 <brelse>
}
    800031ec:	60e2                	ld	ra,24(sp)
    800031ee:	6442                	ld	s0,16(sp)
    800031f0:	64a2                	ld	s1,8(sp)
    800031f2:	6902                	ld	s2,0(sp)
    800031f4:	6105                	addi	sp,sp,32
    800031f6:	8082                	ret

00000000800031f8 <idup>:
{
    800031f8:	1101                	addi	sp,sp,-32
    800031fa:	ec06                	sd	ra,24(sp)
    800031fc:	e822                	sd	s0,16(sp)
    800031fe:	e426                	sd	s1,8(sp)
    80003200:	1000                	addi	s0,sp,32
    80003202:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003204:	0001b517          	auipc	a0,0x1b
    80003208:	00c50513          	addi	a0,a0,12 # 8001e210 <itable>
    8000320c:	a0dfd0ef          	jal	80000c18 <acquire>
  ip->ref++;
    80003210:	449c                	lw	a5,8(s1)
    80003212:	2785                	addiw	a5,a5,1
    80003214:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003216:	0001b517          	auipc	a0,0x1b
    8000321a:	ffa50513          	addi	a0,a0,-6 # 8001e210 <itable>
    8000321e:	a7ffd0ef          	jal	80000c9c <release>
}
    80003222:	8526                	mv	a0,s1
    80003224:	60e2                	ld	ra,24(sp)
    80003226:	6442                	ld	s0,16(sp)
    80003228:	64a2                	ld	s1,8(sp)
    8000322a:	6105                	addi	sp,sp,32
    8000322c:	8082                	ret

000000008000322e <ilock>:
{
    8000322e:	1101                	addi	sp,sp,-32
    80003230:	ec06                	sd	ra,24(sp)
    80003232:	e822                	sd	s0,16(sp)
    80003234:	e426                	sd	s1,8(sp)
    80003236:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003238:	cd19                	beqz	a0,80003256 <ilock+0x28>
    8000323a:	84aa                	mv	s1,a0
    8000323c:	451c                	lw	a5,8(a0)
    8000323e:	00f05c63          	blez	a5,80003256 <ilock+0x28>
  acquiresleep(&ip->lock);
    80003242:	0541                	addi	a0,a0,16
    80003244:	4ef000ef          	jal	80003f32 <acquiresleep>
  if (ip->valid == 0) {
    80003248:	40bc                	lw	a5,64(s1)
    8000324a:	cf89                	beqz	a5,80003264 <ilock+0x36>
}
    8000324c:	60e2                	ld	ra,24(sp)
    8000324e:	6442                	ld	s0,16(sp)
    80003250:	64a2                	ld	s1,8(sp)
    80003252:	6105                	addi	sp,sp,32
    80003254:	8082                	ret
    80003256:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80003258:	00004517          	auipc	a0,0x4
    8000325c:	2b850513          	addi	a0,a0,696 # 80007510 <etext+0x510>
    80003260:	ddafd0ef          	jal	8000083a <panic>
    80003264:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80003266:	40dc                	lw	a5,4(s1)
    80003268:	0047d79b          	srliw	a5,a5,0x4
    8000326c:	0001b597          	auipc	a1,0x1b
    80003270:	f9c5a583          	lw	a1,-100(a1) # 8001e208 <sb+0x18>
    80003274:	9dbd                	addw	a1,a1,a5
    80003276:	4088                	lw	a0,0(s1)
    80003278:	917ff0ef          	jal	80002b8e <bread>
    8000327c:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    8000327e:	05850593          	addi	a1,a0,88
    80003282:	40dc                	lw	a5,4(s1)
    80003284:	8bbd                	andi	a5,a5,15
    80003286:	079a                	slli	a5,a5,0x6
    80003288:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000328a:	00059783          	lh	a5,0(a1)
    8000328e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80003292:	00259783          	lh	a5,2(a1)
    80003296:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000329a:	00459783          	lh	a5,4(a1)
    8000329e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032a2:	00659783          	lh	a5,6(a1)
    800032a6:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800032aa:	459c                	lw	a5,8(a1)
    800032ac:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800032ae:	03400613          	li	a2,52
    800032b2:	05b1                	addi	a1,a1,12
    800032b4:	05048513          	addi	a0,s1,80
    800032b8:	a79fd0ef          	jal	80000d30 <memmove>
    brelse(bp);
    800032bc:	854a                	mv	a0,s2
    800032be:	9d9ff0ef          	jal	80002c96 <brelse>
    ip->valid = 1;
    800032c2:	4785                	li	a5,1
    800032c4:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    800032c6:	04449783          	lh	a5,68(s1)
    800032ca:	c399                	beqz	a5,800032d0 <ilock+0xa2>
    800032cc:	6902                	ld	s2,0(sp)
    800032ce:	bfbd                	j	8000324c <ilock+0x1e>
      panic("ilock: no type");
    800032d0:	00004517          	auipc	a0,0x4
    800032d4:	24850513          	addi	a0,a0,584 # 80007518 <etext+0x518>
    800032d8:	d62fd0ef          	jal	8000083a <panic>

00000000800032dc <iunlock>:
{
    800032dc:	1101                	addi	sp,sp,-32
    800032de:	ec06                	sd	ra,24(sp)
    800032e0:	e822                	sd	s0,16(sp)
    800032e2:	e426                	sd	s1,8(sp)
    800032e4:	e04a                	sd	s2,0(sp)
    800032e6:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800032e8:	c505                	beqz	a0,80003310 <iunlock+0x34>
    800032ea:	84aa                	mv	s1,a0
    800032ec:	01050913          	addi	s2,a0,16
    800032f0:	854a                	mv	a0,s2
    800032f2:	4bf000ef          	jal	80003fb0 <holdingsleep>
    800032f6:	cd09                	beqz	a0,80003310 <iunlock+0x34>
    800032f8:	449c                	lw	a5,8(s1)
    800032fa:	00f05b63          	blez	a5,80003310 <iunlock+0x34>
  releasesleep(&ip->lock);
    800032fe:	854a                	mv	a0,s2
    80003300:	479000ef          	jal	80003f78 <releasesleep>
}
    80003304:	60e2                	ld	ra,24(sp)
    80003306:	6442                	ld	s0,16(sp)
    80003308:	64a2                	ld	s1,8(sp)
    8000330a:	6902                	ld	s2,0(sp)
    8000330c:	6105                	addi	sp,sp,32
    8000330e:	8082                	ret
    panic("iunlock");
    80003310:	00004517          	auipc	a0,0x4
    80003314:	21850513          	addi	a0,a0,536 # 80007528 <etext+0x528>
    80003318:	d22fd0ef          	jal	8000083a <panic>

000000008000331c <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000331c:	7179                	addi	sp,sp,-48
    8000331e:	f406                	sd	ra,40(sp)
    80003320:	f022                	sd	s0,32(sp)
    80003322:	ec26                	sd	s1,24(sp)
    80003324:	e84a                	sd	s2,16(sp)
    80003326:	e44e                	sd	s3,8(sp)
    80003328:	1800                	addi	s0,sp,48
    8000332a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    8000332c:	05050493          	addi	s1,a0,80
    80003330:	08050913          	addi	s2,a0,128
    80003334:	a021                	j	8000333c <itrunc+0x20>
    80003336:	0491                	addi	s1,s1,4
    80003338:	01248b63          	beq	s1,s2,8000334e <itrunc+0x32>
    if (ip->addrs[i]) {
    8000333c:	408c                	lw	a1,0(s1)
    8000333e:	dde5                	beqz	a1,80003336 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80003340:	0009a503          	lw	a0,0(s3)
    80003344:	a3fff0ef          	jal	80002d82 <bfree>
      ip->addrs[i] = 0;
    80003348:	0004a023          	sw	zero,0(s1)
    8000334c:	b7ed                	j	80003336 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    8000334e:	0809a583          	lw	a1,128(s3)
    80003352:	ed89                	bnez	a1,8000336c <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80003354:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80003358:	854e                	mv	a0,s3
    8000335a:	e21ff0ef          	jal	8000317a <iupdate>
}
    8000335e:	70a2                	ld	ra,40(sp)
    80003360:	7402                	ld	s0,32(sp)
    80003362:	64e2                	ld	s1,24(sp)
    80003364:	6942                	ld	s2,16(sp)
    80003366:	69a2                	ld	s3,8(sp)
    80003368:	6145                	addi	sp,sp,48
    8000336a:	8082                	ret
    8000336c:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000336e:	0009a503          	lw	a0,0(s3)
    80003372:	81dff0ef          	jal	80002b8e <bread>
    80003376:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    80003378:	05850493          	addi	s1,a0,88
    8000337c:	45850913          	addi	s2,a0,1112
    80003380:	a021                	j	80003388 <itrunc+0x6c>
    80003382:	0491                	addi	s1,s1,4
    80003384:	01248963          	beq	s1,s2,80003396 <itrunc+0x7a>
      if (a[j])
    80003388:	408c                	lw	a1,0(s1)
    8000338a:	dde5                	beqz	a1,80003382 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    8000338c:	0009a503          	lw	a0,0(s3)
    80003390:	9f3ff0ef          	jal	80002d82 <bfree>
    80003394:	b7fd                	j	80003382 <itrunc+0x66>
    brelse(bp);
    80003396:	8552                	mv	a0,s4
    80003398:	8ffff0ef          	jal	80002c96 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    8000339c:	0809a583          	lw	a1,128(s3)
    800033a0:	0009a503          	lw	a0,0(s3)
    800033a4:	9dfff0ef          	jal	80002d82 <bfree>
    ip->addrs[NDIRECT] = 0;
    800033a8:	0809a023          	sw	zero,128(s3)
    800033ac:	6a02                	ld	s4,0(sp)
    800033ae:	b75d                	j	80003354 <itrunc+0x38>

00000000800033b0 <iput>:
{
    800033b0:	1101                	addi	sp,sp,-32
    800033b2:	ec06                	sd	ra,24(sp)
    800033b4:	e822                	sd	s0,16(sp)
    800033b6:	e426                	sd	s1,8(sp)
    800033b8:	1000                	addi	s0,sp,32
    800033ba:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800033bc:	0001b517          	auipc	a0,0x1b
    800033c0:	e5450513          	addi	a0,a0,-428 # 8001e210 <itable>
    800033c4:	855fd0ef          	jal	80000c18 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800033c8:	4498                	lw	a4,8(s1)
    800033ca:	4785                	li	a5,1
    800033cc:	02f70063          	beq	a4,a5,800033ec <iput+0x3c>
  ip->ref--;
    800033d0:	449c                	lw	a5,8(s1)
    800033d2:	37fd                	addiw	a5,a5,-1
    800033d4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800033d6:	0001b517          	auipc	a0,0x1b
    800033da:	e3a50513          	addi	a0,a0,-454 # 8001e210 <itable>
    800033de:	8bffd0ef          	jal	80000c9c <release>
}
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	64a2                	ld	s1,8(sp)
    800033e8:	6105                	addi	sp,sp,32
    800033ea:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    800033ec:	40bc                	lw	a5,64(s1)
    800033ee:	d3ed                	beqz	a5,800033d0 <iput+0x20>
    800033f0:	04a49783          	lh	a5,74(s1)
    800033f4:	fff1                	bnez	a5,800033d0 <iput+0x20>
    800033f6:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800033f8:	01048793          	addi	a5,s1,16
    800033fc:	893e                	mv	s2,a5
    800033fe:	853e                	mv	a0,a5
    80003400:	333000ef          	jal	80003f32 <acquiresleep>
    release(&itable.lock);
    80003404:	0001b517          	auipc	a0,0x1b
    80003408:	e0c50513          	addi	a0,a0,-500 # 8001e210 <itable>
    8000340c:	891fd0ef          	jal	80000c9c <release>
    itrunc(ip);
    80003410:	8526                	mv	a0,s1
    80003412:	f0bff0ef          	jal	8000331c <itrunc>
    ip->type = 0;
    80003416:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000341a:	8526                	mv	a0,s1
    8000341c:	d5fff0ef          	jal	8000317a <iupdate>
    ip->valid = 0;
    80003420:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003424:	854a                	mv	a0,s2
    80003426:	353000ef          	jal	80003f78 <releasesleep>
    acquire(&itable.lock);
    8000342a:	0001b517          	auipc	a0,0x1b
    8000342e:	de650513          	addi	a0,a0,-538 # 8001e210 <itable>
    80003432:	fe6fd0ef          	jal	80000c18 <acquire>
    80003436:	6902                	ld	s2,0(sp)
    80003438:	bf61                	j	800033d0 <iput+0x20>

000000008000343a <iunlockput>:
{
    8000343a:	1101                	addi	sp,sp,-32
    8000343c:	ec06                	sd	ra,24(sp)
    8000343e:	e822                	sd	s0,16(sp)
    80003440:	e426                	sd	s1,8(sp)
    80003442:	1000                	addi	s0,sp,32
    80003444:	84aa                	mv	s1,a0
  iunlock(ip);
    80003446:	e97ff0ef          	jal	800032dc <iunlock>
  iput(ip);
    8000344a:	8526                	mv	a0,s1
    8000344c:	f65ff0ef          	jal	800033b0 <iput>
}
    80003450:	60e2                	ld	ra,24(sp)
    80003452:	6442                	ld	s0,16(sp)
    80003454:	64a2                	ld	s1,8(sp)
    80003456:	6105                	addi	sp,sp,32
    80003458:	8082                	ret

000000008000345a <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000345a:	0001b717          	auipc	a4,0x1b
    8000345e:	da272703          	lw	a4,-606(a4) # 8001e1fc <sb+0xc>
    80003462:	4785                	li	a5,1
    80003464:	0ae7fe63          	bgeu	a5,a4,80003520 <ireclaim+0xc6>
{
    80003468:	7139                	addi	sp,sp,-64
    8000346a:	fc06                	sd	ra,56(sp)
    8000346c:	f822                	sd	s0,48(sp)
    8000346e:	f426                	sd	s1,40(sp)
    80003470:	f04a                	sd	s2,32(sp)
    80003472:	ec4e                	sd	s3,24(sp)
    80003474:	e852                	sd	s4,16(sp)
    80003476:	e456                	sd	s5,8(sp)
    80003478:	e05a                	sd	s6,0(sp)
    8000347a:	0080                	addi	s0,sp,64
    8000347c:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    8000347e:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003480:	0001ba17          	auipc	s4,0x1b
    80003484:	d70a0a13          	addi	s4,s4,-656 # 8001e1f0 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    80003488:	00004b17          	auipc	s6,0x4
    8000348c:	0a8b0b13          	addi	s6,s6,168 # 80007530 <etext+0x530>
    80003490:	a099                	j	800034d6 <ireclaim+0x7c>
    80003492:	85ce                	mv	a1,s3
    80003494:	855a                	mv	a0,s6
    80003496:	86cfd0ef          	jal	80000502 <printk>
      ip = iget(dev, inum);
    8000349a:	85ce                	mv	a1,s3
    8000349c:	8556                	mv	a0,s5
    8000349e:	b17ff0ef          	jal	80002fb4 <iget>
    800034a2:	89aa                	mv	s3,a0
    brelse(bp);
    800034a4:	854a                	mv	a0,s2
    800034a6:	ff0ff0ef          	jal	80002c96 <brelse>
    if (ip) {
    800034aa:	00098f63          	beqz	s3,800034c8 <ireclaim+0x6e>
      begin_op();
    800034ae:	796000ef          	jal	80003c44 <begin_op>
      ilock(ip);
    800034b2:	854e                	mv	a0,s3
    800034b4:	d7bff0ef          	jal	8000322e <ilock>
      iunlock(ip);
    800034b8:	854e                	mv	a0,s3
    800034ba:	e23ff0ef          	jal	800032dc <iunlock>
      iput(ip);
    800034be:	854e                	mv	a0,s3
    800034c0:	ef1ff0ef          	jal	800033b0 <iput>
      end_op();
    800034c4:	7f0000ef          	jal	80003cb4 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034c8:	0485                	addi	s1,s1,1
    800034ca:	00ca2703          	lw	a4,12(s4)
    800034ce:	0004879b          	sext.w	a5,s1
    800034d2:	02e7fd63          	bgeu	a5,a4,8000350c <ireclaim+0xb2>
    800034d6:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034da:	0044d593          	srli	a1,s1,0x4
    800034de:	018a2783          	lw	a5,24(s4)
    800034e2:	9dbd                	addw	a1,a1,a5
    800034e4:	8556                	mv	a0,s5
    800034e6:	ea8ff0ef          	jal	80002b8e <bread>
    800034ea:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800034ec:	05850793          	addi	a5,a0,88
    800034f0:	00f9f713          	andi	a4,s3,15
    800034f4:	071a                	slli	a4,a4,0x6
    800034f6:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    800034f8:	00079703          	lh	a4,0(a5)
    800034fc:	c701                	beqz	a4,80003504 <ireclaim+0xaa>
    800034fe:	00679783          	lh	a5,6(a5)
    80003502:	dbc1                	beqz	a5,80003492 <ireclaim+0x38>
    brelse(bp);
    80003504:	854a                	mv	a0,s2
    80003506:	f90ff0ef          	jal	80002c96 <brelse>
    if (ip) {
    8000350a:	bf7d                	j	800034c8 <ireclaim+0x6e>
}
    8000350c:	70e2                	ld	ra,56(sp)
    8000350e:	7442                	ld	s0,48(sp)
    80003510:	74a2                	ld	s1,40(sp)
    80003512:	7902                	ld	s2,32(sp)
    80003514:	69e2                	ld	s3,24(sp)
    80003516:	6a42                	ld	s4,16(sp)
    80003518:	6aa2                	ld	s5,8(sp)
    8000351a:	6b02                	ld	s6,0(sp)
    8000351c:	6121                	addi	sp,sp,64
    8000351e:	8082                	ret
    80003520:	8082                	ret

0000000080003522 <fsinit>:
{
    80003522:	1101                	addi	sp,sp,-32
    80003524:	ec06                	sd	ra,24(sp)
    80003526:	e822                	sd	s0,16(sp)
    80003528:	e426                	sd	s1,8(sp)
    8000352a:	e04a                	sd	s2,0(sp)
    8000352c:	1000                	addi	s0,sp,32
    8000352e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80003530:	4585                	li	a1,1
    80003532:	e5cff0ef          	jal	80002b8e <bread>
    80003536:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003538:	02000613          	li	a2,32
    8000353c:	05850593          	addi	a1,a0,88
    80003540:	0001b517          	auipc	a0,0x1b
    80003544:	cb050513          	addi	a0,a0,-848 # 8001e1f0 <sb>
    80003548:	fe8fd0ef          	jal	80000d30 <memmove>
  brelse(bp);
    8000354c:	8526                	mv	a0,s1
    8000354e:	f48ff0ef          	jal	80002c96 <brelse>
  if (sb.magic != FSMAGIC)
    80003552:	0001b717          	auipc	a4,0x1b
    80003556:	c9e72703          	lw	a4,-866(a4) # 8001e1f0 <sb>
    8000355a:	102037b7          	lui	a5,0x10203
    8000355e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003562:	02f71263          	bne	a4,a5,80003586 <fsinit+0x64>
  initlog(dev, &sb);
    80003566:	0001b597          	auipc	a1,0x1b
    8000356a:	c8a58593          	addi	a1,a1,-886 # 8001e1f0 <sb>
    8000356e:	854a                	mv	a0,s2
    80003570:	652000ef          	jal	80003bc2 <initlog>
  ireclaim(dev);
    80003574:	854a                	mv	a0,s2
    80003576:	ee5ff0ef          	jal	8000345a <ireclaim>
}
    8000357a:	60e2                	ld	ra,24(sp)
    8000357c:	6442                	ld	s0,16(sp)
    8000357e:	64a2                	ld	s1,8(sp)
    80003580:	6902                	ld	s2,0(sp)
    80003582:	6105                	addi	sp,sp,32
    80003584:	8082                	ret
    panic("invalid file system");
    80003586:	00004517          	auipc	a0,0x4
    8000358a:	fca50513          	addi	a0,a0,-54 # 80007550 <etext+0x550>
    8000358e:	aacfd0ef          	jal	8000083a <panic>

0000000080003592 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003592:	1141                	addi	sp,sp,-16
    80003594:	e406                	sd	ra,8(sp)
    80003596:	e022                	sd	s0,0(sp)
    80003598:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000359a:	411c                	lw	a5,0(a0)
    8000359c:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    8000359e:	415c                	lw	a5,4(a0)
    800035a0:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035a2:	04451783          	lh	a5,68(a0)
    800035a6:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800035aa:	04a51783          	lh	a5,74(a0)
    800035ae:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800035b2:	04c56783          	lwu	a5,76(a0)
    800035b6:	e99c                	sd	a5,16(a1)
}
    800035b8:	60a2                	ld	ra,8(sp)
    800035ba:	6402                	ld	s0,0(sp)
    800035bc:	0141                	addi	sp,sp,16
    800035be:	8082                	ret

00000000800035c0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800035c0:	457c                	lw	a5,76(a0)
    800035c2:	0ed7e663          	bltu	a5,a3,800036ae <readi+0xee>
{
    800035c6:	7159                	addi	sp,sp,-112
    800035c8:	f486                	sd	ra,104(sp)
    800035ca:	f0a2                	sd	s0,96(sp)
    800035cc:	eca6                	sd	s1,88(sp)
    800035ce:	e0d2                	sd	s4,64(sp)
    800035d0:	fc56                	sd	s5,56(sp)
    800035d2:	f85a                	sd	s6,48(sp)
    800035d4:	f45e                	sd	s7,40(sp)
    800035d6:	1880                	addi	s0,sp,112
    800035d8:	8b2a                	mv	s6,a0
    800035da:	8bae                	mv	s7,a1
    800035dc:	8a32                	mv	s4,a2
    800035de:	84b6                	mv	s1,a3
    800035e0:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    800035e2:	9f35                	addw	a4,a4,a3
    return 0;
    800035e4:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    800035e6:	0ad76b63          	bltu	a4,a3,8000369c <readi+0xdc>
    800035ea:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    800035ec:	00e7f463          	bgeu	a5,a4,800035f4 <readi+0x34>
    n = ip->size - off;
    800035f0:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800035f4:	080a8b63          	beqz	s5,8000368a <readi+0xca>
    800035f8:	e8ca                	sd	s2,80(sp)
    800035fa:	f062                	sd	s8,32(sp)
    800035fc:	ec66                	sd	s9,24(sp)
    800035fe:	e86a                	sd	s10,16(sp)
    80003600:	e46e                	sd	s11,8(sp)
    80003602:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003604:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003608:	5c7d                	li	s8,-1
    8000360a:	a80d                	j	8000363c <readi+0x7c>
    8000360c:	020d1d93          	slli	s11,s10,0x20
    80003610:	020ddd93          	srli	s11,s11,0x20
    80003614:	05890613          	addi	a2,s2,88
    80003618:	86ee                	mv	a3,s11
    8000361a:	963e                	add	a2,a2,a5
    8000361c:	85d2                	mv	a1,s4
    8000361e:	855e                	mv	a0,s7
    80003620:	c0dfe0ef          	jal	8000222c <either_copyout>
    80003624:	05850363          	beq	a0,s8,8000366a <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003628:	854a                	mv	a0,s2
    8000362a:	e6cff0ef          	jal	80002c96 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000362e:	013d09bb          	addw	s3,s10,s3
    80003632:	009d04bb          	addw	s1,s10,s1
    80003636:	9a6e                	add	s4,s4,s11
    80003638:	0559f363          	bgeu	s3,s5,8000367e <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    8000363c:	00a4d59b          	srliw	a1,s1,0xa
    80003640:	855a                	mv	a0,s6
    80003642:	8b3ff0ef          	jal	80002ef4 <bmap>
    80003646:	85aa                	mv	a1,a0
    if (addr == 0)
    80003648:	c139                	beqz	a0,8000368e <readi+0xce>
    bp = bread(ip->dev, addr);
    8000364a:	000b2503          	lw	a0,0(s6)
    8000364e:	d40ff0ef          	jal	80002b8e <bread>
    80003652:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003654:	3ff4f793          	andi	a5,s1,1023
    80003658:	40fc873b          	subw	a4,s9,a5
    8000365c:	413a86bb          	subw	a3,s5,s3
    80003660:	8d3a                	mv	s10,a4
    80003662:	fae6f5e3          	bgeu	a3,a4,8000360c <readi+0x4c>
    80003666:	8d36                	mv	s10,a3
    80003668:	b755                	j	8000360c <readi+0x4c>
      brelse(bp);
    8000366a:	854a                	mv	a0,s2
    8000366c:	e2aff0ef          	jal	80002c96 <brelse>
      tot = -1;
    80003670:	59fd                	li	s3,-1
      break;
    80003672:	6946                	ld	s2,80(sp)
    80003674:	7c02                	ld	s8,32(sp)
    80003676:	6ce2                	ld	s9,24(sp)
    80003678:	6d42                	ld	s10,16(sp)
    8000367a:	6da2                	ld	s11,8(sp)
    8000367c:	a831                	j	80003698 <readi+0xd8>
    8000367e:	6946                	ld	s2,80(sp)
    80003680:	7c02                	ld	s8,32(sp)
    80003682:	6ce2                	ld	s9,24(sp)
    80003684:	6d42                	ld	s10,16(sp)
    80003686:	6da2                	ld	s11,8(sp)
    80003688:	a801                	j	80003698 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000368a:	89d6                	mv	s3,s5
    8000368c:	a031                	j	80003698 <readi+0xd8>
    8000368e:	6946                	ld	s2,80(sp)
    80003690:	7c02                	ld	s8,32(sp)
    80003692:	6ce2                	ld	s9,24(sp)
    80003694:	6d42                	ld	s10,16(sp)
    80003696:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80003698:	854e                	mv	a0,s3
    8000369a:	69a6                	ld	s3,72(sp)
}
    8000369c:	70a6                	ld	ra,104(sp)
    8000369e:	7406                	ld	s0,96(sp)
    800036a0:	64e6                	ld	s1,88(sp)
    800036a2:	6a06                	ld	s4,64(sp)
    800036a4:	7ae2                	ld	s5,56(sp)
    800036a6:	7b42                	ld	s6,48(sp)
    800036a8:	7ba2                	ld	s7,40(sp)
    800036aa:	6165                	addi	sp,sp,112
    800036ac:	8082                	ret
    return 0;
    800036ae:	4501                	li	a0,0
}
    800036b0:	8082                	ret

00000000800036b2 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    800036b2:	457c                	lw	a5,76(a0)
    800036b4:	0ed7ee63          	bltu	a5,a3,800037b0 <writei+0xfe>
{
    800036b8:	7159                	addi	sp,sp,-112
    800036ba:	f486                	sd	ra,104(sp)
    800036bc:	f0a2                	sd	s0,96(sp)
    800036be:	e8ca                	sd	s2,80(sp)
    800036c0:	e0d2                	sd	s4,64(sp)
    800036c2:	fc56                	sd	s5,56(sp)
    800036c4:	f85a                	sd	s6,48(sp)
    800036c6:	f45e                	sd	s7,40(sp)
    800036c8:	1880                	addi	s0,sp,112
    800036ca:	8aaa                	mv	s5,a0
    800036cc:	8bae                	mv	s7,a1
    800036ce:	8a32                	mv	s4,a2
    800036d0:	8936                	mv	s2,a3
    800036d2:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    800036d4:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    800036d6:	000437b7          	lui	a5,0x43
    800036da:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    800036de:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    800036e2:	8fd9                	or	a5,a5,a4
    800036e4:	ef91                	bnez	a5,80003700 <writei+0x4e>
    800036e6:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800036e8:	0a0b0c63          	beqz	s6,800037a0 <writei+0xee>
    800036ec:	eca6                	sd	s1,88(sp)
    800036ee:	f062                	sd	s8,32(sp)
    800036f0:	ec66                	sd	s9,24(sp)
    800036f2:	e86a                	sd	s10,16(sp)
    800036f4:	e46e                	sd	s11,8(sp)
    800036f6:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    800036f8:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    800036fc:	5c7d                	li	s8,-1
    800036fe:	a835                	j	8000373a <writei+0x88>
    return -1;
    80003700:	557d                	li	a0,-1
    80003702:	a071                	j	8000378e <writei+0xdc>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003704:	020d1d93          	slli	s11,s10,0x20
    80003708:	020ddd93          	srli	s11,s11,0x20
    8000370c:	05848513          	addi	a0,s1,88
    80003710:	86ee                	mv	a3,s11
    80003712:	8652                	mv	a2,s4
    80003714:	85de                	mv	a1,s7
    80003716:	953e                	add	a0,a0,a5
    80003718:	b5ffe0ef          	jal	80002276 <either_copyin>
    8000371c:	05850663          	beq	a0,s8,80003768 <writei+0xb6>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003720:	8526                	mv	a0,s1
    80003722:	6b4000ef          	jal	80003dd6 <log_write>
    brelse(bp);
    80003726:	8526                	mv	a0,s1
    80003728:	d6eff0ef          	jal	80002c96 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    8000372c:	013d09bb          	addw	s3,s10,s3
    80003730:	012d093b          	addw	s2,s10,s2
    80003734:	9a6e                	add	s4,s4,s11
    80003736:	0369fc63          	bgeu	s3,s6,8000376e <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    8000373a:	00a9559b          	srliw	a1,s2,0xa
    8000373e:	8556                	mv	a0,s5
    80003740:	fb4ff0ef          	jal	80002ef4 <bmap>
    80003744:	85aa                	mv	a1,a0
    if (addr == 0)
    80003746:	c505                	beqz	a0,8000376e <writei+0xbc>
    bp = bread(ip->dev, addr);
    80003748:	000aa503          	lw	a0,0(s5)
    8000374c:	c42ff0ef          	jal	80002b8e <bread>
    80003750:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    80003752:	3ff97793          	andi	a5,s2,1023
    80003756:	40fc873b          	subw	a4,s9,a5
    8000375a:	413b06bb          	subw	a3,s6,s3
    8000375e:	8d3a                	mv	s10,a4
    80003760:	fae6f2e3          	bgeu	a3,a4,80003704 <writei+0x52>
    80003764:	8d36                	mv	s10,a3
    80003766:	bf79                	j	80003704 <writei+0x52>
      brelse(bp);
    80003768:	8526                	mv	a0,s1
    8000376a:	d2cff0ef          	jal	80002c96 <brelse>
  }

  if (off > ip->size)
    8000376e:	04caa783          	lw	a5,76(s5)
    80003772:	0327f963          	bgeu	a5,s2,800037a4 <writei+0xf2>
    ip->size = off;
    80003776:	052aa623          	sw	s2,76(s5)
    8000377a:	64e6                	ld	s1,88(sp)
    8000377c:	7c02                	ld	s8,32(sp)
    8000377e:	6ce2                	ld	s9,24(sp)
    80003780:	6d42                	ld	s10,16(sp)
    80003782:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003784:	8556                	mv	a0,s5
    80003786:	9f5ff0ef          	jal	8000317a <iupdate>

  return tot;
    8000378a:	854e                	mv	a0,s3
    8000378c:	69a6                	ld	s3,72(sp)
}
    8000378e:	70a6                	ld	ra,104(sp)
    80003790:	7406                	ld	s0,96(sp)
    80003792:	6946                	ld	s2,80(sp)
    80003794:	6a06                	ld	s4,64(sp)
    80003796:	7ae2                	ld	s5,56(sp)
    80003798:	7b42                	ld	s6,48(sp)
    8000379a:	7ba2                	ld	s7,40(sp)
    8000379c:	6165                	addi	sp,sp,112
    8000379e:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037a0:	89da                	mv	s3,s6
    800037a2:	b7cd                	j	80003784 <writei+0xd2>
    800037a4:	64e6                	ld	s1,88(sp)
    800037a6:	7c02                	ld	s8,32(sp)
    800037a8:	6ce2                	ld	s9,24(sp)
    800037aa:	6d42                	ld	s10,16(sp)
    800037ac:	6da2                	ld	s11,8(sp)
    800037ae:	bfd9                	j	80003784 <writei+0xd2>
    return -1;
    800037b0:	557d                	li	a0,-1
}
    800037b2:	8082                	ret

00000000800037b4 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800037b4:	1141                	addi	sp,sp,-16
    800037b6:	e406                	sd	ra,8(sp)
    800037b8:	e022                	sd	s0,0(sp)
    800037ba:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800037bc:	4639                	li	a2,14
    800037be:	de6fd0ef          	jal	80000da4 <strncmp>
}
    800037c2:	60a2                	ld	ra,8(sp)
    800037c4:	6402                	ld	s0,0(sp)
    800037c6:	0141                	addi	sp,sp,16
    800037c8:	8082                	ret

00000000800037ca <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800037ca:	711d                	addi	sp,sp,-96
    800037cc:	ec86                	sd	ra,88(sp)
    800037ce:	e8a2                	sd	s0,80(sp)
    800037d0:	e4a6                	sd	s1,72(sp)
    800037d2:	e0ca                	sd	s2,64(sp)
    800037d4:	fc4e                	sd	s3,56(sp)
    800037d6:	f852                	sd	s4,48(sp)
    800037d8:	f456                	sd	s5,40(sp)
    800037da:	f05a                	sd	s6,32(sp)
    800037dc:	ec5e                	sd	s7,24(sp)
    800037de:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    800037e0:	04451703          	lh	a4,68(a0)
    800037e4:	4785                	li	a5,1
    800037e6:	02f71963          	bne	a4,a5,80003818 <dirlookup+0x4e>
    800037ea:	892a                	mv	s2,a0
    800037ec:	8aae                	mv	s5,a1
    800037ee:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    800037f0:	457c                	lw	a5,76(a0)
    800037f2:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800037f4:	fa040a13          	addi	s4,s0,-96
    800037f8:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    800037fa:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800037fe:	ef95                	bnez	a5,8000383a <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003800:	4501                	li	a0,0
}
    80003802:	60e6                	ld	ra,88(sp)
    80003804:	6446                	ld	s0,80(sp)
    80003806:	64a6                	ld	s1,72(sp)
    80003808:	6906                	ld	s2,64(sp)
    8000380a:	79e2                	ld	s3,56(sp)
    8000380c:	7a42                	ld	s4,48(sp)
    8000380e:	7aa2                	ld	s5,40(sp)
    80003810:	7b02                	ld	s6,32(sp)
    80003812:	6be2                	ld	s7,24(sp)
    80003814:	6125                	addi	sp,sp,96
    80003816:	8082                	ret
    panic("dirlookup not DIR");
    80003818:	00004517          	auipc	a0,0x4
    8000381c:	d5050513          	addi	a0,a0,-688 # 80007568 <etext+0x568>
    80003820:	81afd0ef          	jal	8000083a <panic>
      panic("dirlookup read");
    80003824:	00004517          	auipc	a0,0x4
    80003828:	d5c50513          	addi	a0,a0,-676 # 80007580 <etext+0x580>
    8000382c:	80efd0ef          	jal	8000083a <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003830:	24c1                	addiw	s1,s1,16
    80003832:	04c92783          	lw	a5,76(s2)
    80003836:	fcf4f5e3          	bgeu	s1,a5,80003800 <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000383a:	874e                	mv	a4,s3
    8000383c:	86a6                	mv	a3,s1
    8000383e:	8652                	mv	a2,s4
    80003840:	4581                	li	a1,0
    80003842:	854a                	mv	a0,s2
    80003844:	d7dff0ef          	jal	800035c0 <readi>
    80003848:	fd351ee3          	bne	a0,s3,80003824 <dirlookup+0x5a>
    if (de.inum == 0)
    8000384c:	fa045783          	lhu	a5,-96(s0)
    80003850:	d3e5                	beqz	a5,80003830 <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    80003852:	85da                	mv	a1,s6
    80003854:	8556                	mv	a0,s5
    80003856:	f5fff0ef          	jal	800037b4 <namecmp>
    8000385a:	f979                	bnez	a0,80003830 <dirlookup+0x66>
      if (poff)
    8000385c:	000b8463          	beqz	s7,80003864 <dirlookup+0x9a>
        *poff = off;
    80003860:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80003864:	fa045583          	lhu	a1,-96(s0)
    80003868:	00092503          	lw	a0,0(s2)
    8000386c:	f48ff0ef          	jal	80002fb4 <iget>
    80003870:	bf49                	j	80003802 <dirlookup+0x38>

0000000080003872 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003872:	711d                	addi	sp,sp,-96
    80003874:	ec86                	sd	ra,88(sp)
    80003876:	e8a2                	sd	s0,80(sp)
    80003878:	e4a6                	sd	s1,72(sp)
    8000387a:	e0ca                	sd	s2,64(sp)
    8000387c:	fc4e                	sd	s3,56(sp)
    8000387e:	f852                	sd	s4,48(sp)
    80003880:	f456                	sd	s5,40(sp)
    80003882:	f05a                	sd	s6,32(sp)
    80003884:	ec5e                	sd	s7,24(sp)
    80003886:	e862                	sd	s8,16(sp)
    80003888:	e466                	sd	s9,8(sp)
    8000388a:	e06a                	sd	s10,0(sp)
    8000388c:	1080                	addi	s0,sp,96
    8000388e:	84aa                	mv	s1,a0
    80003890:	8b2e                	mv	s6,a1
    80003892:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    80003894:	00054703          	lbu	a4,0(a0)
    80003898:	02f00793          	li	a5,47
    8000389c:	00f70f63          	beq	a4,a5,800038ba <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038a0:	83afe0ef          	jal	800018da <myproc>
    800038a4:	15053503          	ld	a0,336(a0)
    800038a8:	951ff0ef          	jal	800031f8 <idup>
    800038ac:	8a2a                	mv	s4,a0
  while (*path == '/')
    800038ae:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    800038b2:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800038b4:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    800038b6:	4b85                	li	s7,1
    800038b8:	a879                	j	80003956 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800038ba:	4585                	li	a1,1
    800038bc:	852e                	mv	a0,a1
    800038be:	ef6ff0ef          	jal	80002fb4 <iget>
    800038c2:	8a2a                	mv	s4,a0
    800038c4:	b7ed                	j	800038ae <namex+0x3c>
      iunlockput(ip);
    800038c6:	8552                	mv	a0,s4
    800038c8:	b73ff0ef          	jal	8000343a <iunlockput>
      return 0;
    800038cc:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    800038ce:	8552                	mv	a0,s4
    800038d0:	60e6                	ld	ra,88(sp)
    800038d2:	6446                	ld	s0,80(sp)
    800038d4:	64a6                	ld	s1,72(sp)
    800038d6:	6906                	ld	s2,64(sp)
    800038d8:	79e2                	ld	s3,56(sp)
    800038da:	7a42                	ld	s4,48(sp)
    800038dc:	7aa2                	ld	s5,40(sp)
    800038de:	7b02                	ld	s6,32(sp)
    800038e0:	6be2                	ld	s7,24(sp)
    800038e2:	6c42                	ld	s8,16(sp)
    800038e4:	6ca2                	ld	s9,8(sp)
    800038e6:	6d02                	ld	s10,0(sp)
    800038e8:	6125                	addi	sp,sp,96
    800038ea:	8082                	ret
      iunlock(ip);
    800038ec:	8552                	mv	a0,s4
    800038ee:	9efff0ef          	jal	800032dc <iunlock>
      return ip;
    800038f2:	bff1                	j	800038ce <namex+0x5c>
      iunlockput(ip);
    800038f4:	8552                	mv	a0,s4
    800038f6:	b45ff0ef          	jal	8000343a <iunlockput>
      return 0;
    800038fa:	8a4a                	mv	s4,s2
    800038fc:	bfc9                	j	800038ce <namex+0x5c>
  while (*path != '/' && *path != 0)
    800038fe:	8926                	mv	s2,s1
  len = path - s;
    80003900:	4d01                	li	s10,0
    80003902:	4601                	li	a2,0
    memmove(name, s, len);
    80003904:	2601                	sext.w	a2,a2
    80003906:	85a6                	mv	a1,s1
    80003908:	8556                	mv	a0,s5
    8000390a:	c26fd0ef          	jal	80000d30 <memmove>
    name[len] = 0;
    8000390e:	9d56                	add	s10,s10,s5
    80003910:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde108>
    80003914:	84ca                	mv	s1,s2
  while (*path == '/')
    80003916:	0004c783          	lbu	a5,0(s1)
    8000391a:	01379763          	bne	a5,s3,80003928 <namex+0xb6>
    path++;
    8000391e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003920:	0004c783          	lbu	a5,0(s1)
    80003924:	ff378de3          	beq	a5,s3,8000391e <namex+0xac>
    ilock(ip);
    80003928:	8552                	mv	a0,s4
    8000392a:	905ff0ef          	jal	8000322e <ilock>
    if (ip->type != T_DIR) {
    8000392e:	044a1783          	lh	a5,68(s4)
    80003932:	f9779ae3          	bne	a5,s7,800038c6 <namex+0x54>
    if (nameiparent && *path == '\0') {
    80003936:	000b0563          	beqz	s6,80003940 <namex+0xce>
    8000393a:	0004c783          	lbu	a5,0(s1)
    8000393e:	d7dd                	beqz	a5,800038ec <namex+0x7a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    80003940:	4601                	li	a2,0
    80003942:	85d6                	mv	a1,s5
    80003944:	8552                	mv	a0,s4
    80003946:	e85ff0ef          	jal	800037ca <dirlookup>
    8000394a:	892a                	mv	s2,a0
    8000394c:	d545                	beqz	a0,800038f4 <namex+0x82>
    iunlockput(ip);
    8000394e:	8552                	mv	a0,s4
    80003950:	aebff0ef          	jal	8000343a <iunlockput>
    ip = next;
    80003954:	8a4a                	mv	s4,s2
  while (*path == '/')
    80003956:	0004c783          	lbu	a5,0(s1)
    8000395a:	01379763          	bne	a5,s3,80003968 <namex+0xf6>
    path++;
    8000395e:	0485                	addi	s1,s1,1
  while (*path == '/')
    80003960:	0004c783          	lbu	a5,0(s1)
    80003964:	ff378de3          	beq	a5,s3,8000395e <namex+0xec>
  if (*path == 0)
    80003968:	c7a1                	beqz	a5,800039b0 <namex+0x13e>
  while (*path != '/' && *path != 0)
    8000396a:	0004c703          	lbu	a4,0(s1)
    8000396e:	fd170793          	addi	a5,a4,-47
    80003972:	00f037b3          	snez	a5,a5
    80003976:	00e03733          	snez	a4,a4
    8000397a:	8ff9                	and	a5,a5,a4
    8000397c:	d3c9                	beqz	a5,800038fe <namex+0x8c>
    8000397e:	8926                	mv	s2,s1
    path++;
    80003980:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    80003982:	00094703          	lbu	a4,0(s2)
    80003986:	fd170793          	addi	a5,a4,-47
    8000398a:	00f037b3          	snez	a5,a5
    8000398e:	00e03733          	snez	a4,a4
    80003992:	8ff9                	and	a5,a5,a4
    80003994:	f7f5                	bnez	a5,80003980 <namex+0x10e>
  len = path - s;
    80003996:	40990633          	sub	a2,s2,s1
    8000399a:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    8000399e:	f7ac53e3          	bge	s8,s10,80003904 <namex+0x92>
    memmove(name, s, DIRSIZ);
    800039a2:	8666                	mv	a2,s9
    800039a4:	85a6                	mv	a1,s1
    800039a6:	8556                	mv	a0,s5
    800039a8:	b88fd0ef          	jal	80000d30 <memmove>
    800039ac:	84ca                	mv	s1,s2
    800039ae:	b7a5                	j	80003916 <namex+0xa4>
  if (nameiparent) {
    800039b0:	f00b0fe3          	beqz	s6,800038ce <namex+0x5c>
    iput(ip);
    800039b4:	8552                	mv	a0,s4
    800039b6:	9fbff0ef          	jal	800033b0 <iput>
    return 0;
    800039ba:	bf09                	j	800038cc <namex+0x5a>

00000000800039bc <dirlink>:
{
    800039bc:	715d                	addi	sp,sp,-80
    800039be:	e486                	sd	ra,72(sp)
    800039c0:	e0a2                	sd	s0,64(sp)
    800039c2:	f84a                	sd	s2,48(sp)
    800039c4:	ec56                	sd	s5,24(sp)
    800039c6:	e85a                	sd	s6,16(sp)
    800039c8:	0880                	addi	s0,sp,80
    800039ca:	892a                	mv	s2,a0
    800039cc:	8aae                	mv	s5,a1
    800039ce:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    800039d0:	4601                	li	a2,0
    800039d2:	df9ff0ef          	jal	800037ca <dirlookup>
    800039d6:	ed1d                	bnez	a0,80003a14 <dirlink+0x58>
    800039d8:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    800039da:	04c92483          	lw	s1,76(s2)
    800039de:	c4b9                	beqz	s1,80003a2c <dirlink+0x70>
    800039e0:	f44e                	sd	s3,40(sp)
    800039e2:	f052                	sd	s4,32(sp)
    800039e4:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800039e6:	fb040a13          	addi	s4,s0,-80
    800039ea:	49c1                	li	s3,16
    800039ec:	874e                	mv	a4,s3
    800039ee:	86a6                	mv	a3,s1
    800039f0:	8652                	mv	a2,s4
    800039f2:	4581                	li	a1,0
    800039f4:	854a                	mv	a0,s2
    800039f6:	bcbff0ef          	jal	800035c0 <readi>
    800039fa:	03351163          	bne	a0,s3,80003a1c <dirlink+0x60>
    if (de.inum == 0)
    800039fe:	fb045783          	lhu	a5,-80(s0)
    80003a02:	c39d                	beqz	a5,80003a28 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a04:	24c1                	addiw	s1,s1,16
    80003a06:	04c92783          	lw	a5,76(s2)
    80003a0a:	fef4e1e3          	bltu	s1,a5,800039ec <dirlink+0x30>
    80003a0e:	79a2                	ld	s3,40(sp)
    80003a10:	7a02                	ld	s4,32(sp)
    80003a12:	a829                	j	80003a2c <dirlink+0x70>
    iput(ip);
    80003a14:	99dff0ef          	jal	800033b0 <iput>
    return -1;
    80003a18:	557d                	li	a0,-1
    80003a1a:	a83d                	j	80003a58 <dirlink+0x9c>
      panic("dirlink read");
    80003a1c:	00004517          	auipc	a0,0x4
    80003a20:	b7450513          	addi	a0,a0,-1164 # 80007590 <etext+0x590>
    80003a24:	e17fc0ef          	jal	8000083a <panic>
    80003a28:	79a2                	ld	s3,40(sp)
    80003a2a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003a2c:	4639                	li	a2,14
    80003a2e:	85d6                	mv	a1,s5
    80003a30:	fb240513          	addi	a0,s0,-78
    80003a34:	ba6fd0ef          	jal	80000dda <strncpy>
  de.inum = inum;
    80003a38:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a3c:	4741                	li	a4,16
    80003a3e:	86a6                	mv	a3,s1
    80003a40:	fb040613          	addi	a2,s0,-80
    80003a44:	4581                	li	a1,0
    80003a46:	854a                	mv	a0,s2
    80003a48:	c6bff0ef          	jal	800036b2 <writei>
    80003a4c:	1541                	addi	a0,a0,-16
    80003a4e:	00a03533          	snez	a0,a0
    80003a52:	40a0053b          	negw	a0,a0
    80003a56:	74e2                	ld	s1,56(sp)
}
    80003a58:	60a6                	ld	ra,72(sp)
    80003a5a:	6406                	ld	s0,64(sp)
    80003a5c:	7942                	ld	s2,48(sp)
    80003a5e:	6ae2                	ld	s5,24(sp)
    80003a60:	6b42                	ld	s6,16(sp)
    80003a62:	6161                	addi	sp,sp,80
    80003a64:	8082                	ret

0000000080003a66 <namei>:

struct inode *
namei(char *path)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003a6e:	fe040613          	addi	a2,s0,-32
    80003a72:	4581                	li	a1,0
    80003a74:	dffff0ef          	jal	80003872 <namex>
}
    80003a78:	60e2                	ld	ra,24(sp)
    80003a7a:	6442                	ld	s0,16(sp)
    80003a7c:	6105                	addi	sp,sp,32
    80003a7e:	8082                	ret

0000000080003a80 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003a80:	1141                	addi	sp,sp,-16
    80003a82:	e406                	sd	ra,8(sp)
    80003a84:	e022                	sd	s0,0(sp)
    80003a86:	0800                	addi	s0,sp,16
    80003a88:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003a8a:	4585                	li	a1,1
    80003a8c:	de7ff0ef          	jal	80003872 <namex>
}
    80003a90:	60a2                	ld	ra,8(sp)
    80003a92:	6402                	ld	s0,0(sp)
    80003a94:	0141                	addi	sp,sp,16
    80003a96:	8082                	ret

0000000080003a98 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003a98:	1101                	addi	sp,sp,-32
    80003a9a:	ec06                	sd	ra,24(sp)
    80003a9c:	e822                	sd	s0,16(sp)
    80003a9e:	e426                	sd	s1,8(sp)
    80003aa0:	e04a                	sd	s2,0(sp)
    80003aa2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003aa4:	0001c917          	auipc	s2,0x1c
    80003aa8:	21490913          	addi	s2,s2,532 # 8001fcb8 <log>
    80003aac:	01892583          	lw	a1,24(s2)
    80003ab0:	02492503          	lw	a0,36(s2)
    80003ab4:	8daff0ef          	jal	80002b8e <bread>
    80003ab8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003aba:	02c92603          	lw	a2,44(s2)
    80003abe:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003ac0:	00c05f63          	blez	a2,80003ade <write_head+0x46>
    80003ac4:	0001c717          	auipc	a4,0x1c
    80003ac8:	22470713          	addi	a4,a4,548 # 8001fce8 <log+0x30>
    80003acc:	87aa                	mv	a5,a0
    80003ace:	060a                	slli	a2,a2,0x2
    80003ad0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003ad2:	4314                	lw	a3,0(a4)
    80003ad4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003ad6:	0711                	addi	a4,a4,4
    80003ad8:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003ada:	fec79ce3          	bne	a5,a2,80003ad2 <write_head+0x3a>
  }
  bwrite(buf);
    80003ade:	8526                	mv	a0,s1
    80003ae0:	984ff0ef          	jal	80002c64 <bwrite>
  brelse(buf);
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	9b0ff0ef          	jal	80002c96 <brelse>
}
    80003aea:	60e2                	ld	ra,24(sp)
    80003aec:	6442                	ld	s0,16(sp)
    80003aee:	64a2                	ld	s1,8(sp)
    80003af0:	6902                	ld	s2,0(sp)
    80003af2:	6105                	addi	sp,sp,32
    80003af4:	8082                	ret

0000000080003af6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003af6:	0001c797          	auipc	a5,0x1c
    80003afa:	1ee7a783          	lw	a5,494(a5) # 8001fce4 <log+0x2c>
    80003afe:	0cf05163          	blez	a5,80003bc0 <install_trans+0xca>
{
    80003b02:	715d                	addi	sp,sp,-80
    80003b04:	e486                	sd	ra,72(sp)
    80003b06:	e0a2                	sd	s0,64(sp)
    80003b08:	fc26                	sd	s1,56(sp)
    80003b0a:	f84a                	sd	s2,48(sp)
    80003b0c:	f44e                	sd	s3,40(sp)
    80003b0e:	f052                	sd	s4,32(sp)
    80003b10:	ec56                	sd	s5,24(sp)
    80003b12:	e85a                	sd	s6,16(sp)
    80003b14:	e45e                	sd	s7,8(sp)
    80003b16:	e062                	sd	s8,0(sp)
    80003b18:	0880                	addi	s0,sp,80
    80003b1a:	8b2a                	mv	s6,a0
    80003b1c:	0001ca97          	auipc	s5,0x1c
    80003b20:	1cca8a93          	addi	s5,s5,460 # 8001fce8 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b24:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b26:	00004c17          	auipc	s8,0x4
    80003b2a:	a7ac0c13          	addi	s8,s8,-1414 # 800075a0 <etext+0x5a0>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003b2e:	0001ca17          	auipc	s4,0x1c
    80003b32:	18aa0a13          	addi	s4,s4,394 # 8001fcb8 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003b36:	40000b93          	li	s7,1024
    80003b3a:	a025                	j	80003b62 <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b3c:	000aa603          	lw	a2,0(s5)
    80003b40:	85ce                	mv	a1,s3
    80003b42:	8562                	mv	a0,s8
    80003b44:	9bffc0ef          	jal	80000502 <printk>
    80003b48:	a839                	j	80003b66 <install_trans+0x70>
    brelse(lbuf);
    80003b4a:	854a                	mv	a0,s2
    80003b4c:	94aff0ef          	jal	80002c96 <brelse>
    brelse(dbuf);
    80003b50:	8526                	mv	a0,s1
    80003b52:	944ff0ef          	jal	80002c96 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b56:	2985                	addiw	s3,s3,1
    80003b58:	0a91                	addi	s5,s5,4
    80003b5a:	02ca2783          	lw	a5,44(s4)
    80003b5e:	04f9d563          	bge	s3,a5,80003ba8 <install_trans+0xb2>
    if (recovering) {
    80003b62:	fc0b1de3          	bnez	s6,80003b3c <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003b66:	018a2583          	lw	a1,24(s4)
    80003b6a:	013585bb          	addw	a1,a1,s3
    80003b6e:	2585                	addiw	a1,a1,1
    80003b70:	024a2503          	lw	a0,36(s4)
    80003b74:	81aff0ef          	jal	80002b8e <bread>
    80003b78:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003b7a:	000aa583          	lw	a1,0(s5)
    80003b7e:	024a2503          	lw	a0,36(s4)
    80003b82:	80cff0ef          	jal	80002b8e <bread>
    80003b86:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003b88:	865e                	mv	a2,s7
    80003b8a:	05890593          	addi	a1,s2,88
    80003b8e:	05850513          	addi	a0,a0,88
    80003b92:	99efd0ef          	jal	80000d30 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003b96:	8526                	mv	a0,s1
    80003b98:	8ccff0ef          	jal	80002c64 <bwrite>
    if (recovering == 0)
    80003b9c:	fa0b17e3          	bnez	s6,80003b4a <install_trans+0x54>
      bunpin(dbuf);
    80003ba0:	8526                	mv	a0,s1
    80003ba2:	9acff0ef          	jal	80002d4e <bunpin>
    80003ba6:	b755                	j	80003b4a <install_trans+0x54>
}
    80003ba8:	60a6                	ld	ra,72(sp)
    80003baa:	6406                	ld	s0,64(sp)
    80003bac:	74e2                	ld	s1,56(sp)
    80003bae:	7942                	ld	s2,48(sp)
    80003bb0:	79a2                	ld	s3,40(sp)
    80003bb2:	7a02                	ld	s4,32(sp)
    80003bb4:	6ae2                	ld	s5,24(sp)
    80003bb6:	6b42                	ld	s6,16(sp)
    80003bb8:	6ba2                	ld	s7,8(sp)
    80003bba:	6c02                	ld	s8,0(sp)
    80003bbc:	6161                	addi	sp,sp,80
    80003bbe:	8082                	ret
    80003bc0:	8082                	ret

0000000080003bc2 <initlog>:
{
    80003bc2:	7179                	addi	sp,sp,-48
    80003bc4:	f406                	sd	ra,40(sp)
    80003bc6:	f022                	sd	s0,32(sp)
    80003bc8:	ec26                	sd	s1,24(sp)
    80003bca:	e84a                	sd	s2,16(sp)
    80003bcc:	e44e                	sd	s3,8(sp)
    80003bce:	1800                	addi	s0,sp,48
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003bd4:	0001c917          	auipc	s2,0x1c
    80003bd8:	0e490913          	addi	s2,s2,228 # 8001fcb8 <log>
    80003bdc:	00004597          	auipc	a1,0x4
    80003be0:	9e458593          	addi	a1,a1,-1564 # 800075c0 <etext+0x5c0>
    80003be4:	854a                	mv	a0,s2
    80003be6:	fb3fc0ef          	jal	80000b98 <initlock>
  log.start = sb->logstart;
    80003bea:	0149a583          	lw	a1,20(s3)
    80003bee:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003bf2:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003bf6:	8526                	mv	a0,s1
    80003bf8:	f97fe0ef          	jal	80002b8e <bread>
  log.lh.n = lh->n;
    80003bfc:	4d30                	lw	a2,88(a0)
    80003bfe:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003c02:	00c05f63          	blez	a2,80003c20 <initlog+0x5e>
    80003c06:	87aa                	mv	a5,a0
    80003c08:	0001c717          	auipc	a4,0x1c
    80003c0c:	0e070713          	addi	a4,a4,224 # 8001fce8 <log+0x30>
    80003c10:	060a                	slli	a2,a2,0x2
    80003c12:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c14:	4ff4                	lw	a3,92(a5)
    80003c16:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c18:	0791                	addi	a5,a5,4
    80003c1a:	0711                	addi	a4,a4,4
    80003c1c:	fec79ce3          	bne	a5,a2,80003c14 <initlog+0x52>
  brelse(buf);
    80003c20:	876ff0ef          	jal	80002c96 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c24:	4505                	li	a0,1
    80003c26:	ed1ff0ef          	jal	80003af6 <install_trans>
  log.lh.n = 0;
    80003c2a:	0001c797          	auipc	a5,0x1c
    80003c2e:	0a07ad23          	sw	zero,186(a5) # 8001fce4 <log+0x2c>
  write_head(); // clear the log
    80003c32:	e67ff0ef          	jal	80003a98 <write_head>
}
    80003c36:	70a2                	ld	ra,40(sp)
    80003c38:	7402                	ld	s0,32(sp)
    80003c3a:	64e2                	ld	s1,24(sp)
    80003c3c:	6942                	ld	s2,16(sp)
    80003c3e:	69a2                	ld	s3,8(sp)
    80003c40:	6145                	addi	sp,sp,48
    80003c42:	8082                	ret

0000000080003c44 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003c44:	1101                	addi	sp,sp,-32
    80003c46:	ec06                	sd	ra,24(sp)
    80003c48:	e822                	sd	s0,16(sp)
    80003c4a:	e426                	sd	s1,8(sp)
    80003c4c:	e04a                	sd	s2,0(sp)
    80003c4e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003c50:	0001c517          	auipc	a0,0x1c
    80003c54:	06850513          	addi	a0,a0,104 # 8001fcb8 <log>
    80003c58:	fc1fc0ef          	jal	80000c18 <acquire>
  while (1) {
    if (log.committing) {
    80003c5c:	0001c497          	auipc	s1,0x1c
    80003c60:	05c48493          	addi	s1,s1,92 # 8001fcb8 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003c64:	4979                	li	s2,30
    80003c66:	a029                	j	80003c70 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003c68:	85a6                	mv	a1,s1
    80003c6a:	8526                	mv	a0,s1
    80003c6c:	a68fe0ef          	jal	80001ed4 <sleep>
    if (log.committing) {
    80003c70:	509c                	lw	a5,32(s1)
    80003c72:	fbfd                	bnez	a5,80003c68 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003c74:	4cd8                	lw	a4,28(s1)
    80003c76:	2705                	addiw	a4,a4,1
    80003c78:	0027179b          	slliw	a5,a4,0x2
    80003c7c:	9fb9                	addw	a5,a5,a4
    80003c7e:	0017979b          	slliw	a5,a5,0x1
    80003c82:	54d4                	lw	a3,44(s1)
    80003c84:	9fb5                	addw	a5,a5,a3
    80003c86:	00f95763          	bge	s2,a5,80003c94 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003c8a:	85a6                	mv	a1,s1
    80003c8c:	8526                	mv	a0,s1
    80003c8e:	a46fe0ef          	jal	80001ed4 <sleep>
    80003c92:	bff9                	j	80003c70 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003c94:	0001c797          	auipc	a5,0x1c
    80003c98:	04e7a023          	sw	a4,64(a5) # 8001fcd4 <log+0x1c>
      release(&log.lock);
    80003c9c:	0001c517          	auipc	a0,0x1c
    80003ca0:	01c50513          	addi	a0,a0,28 # 8001fcb8 <log>
    80003ca4:	ff9fc0ef          	jal	80000c9c <release>
      break;
    }
  }
}
    80003ca8:	60e2                	ld	ra,24(sp)
    80003caa:	6442                	ld	s0,16(sp)
    80003cac:	64a2                	ld	s1,8(sp)
    80003cae:	6902                	ld	s2,0(sp)
    80003cb0:	6105                	addi	sp,sp,32
    80003cb2:	8082                	ret

0000000080003cb4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003cb4:	7139                	addi	sp,sp,-64
    80003cb6:	fc06                	sd	ra,56(sp)
    80003cb8:	f822                	sd	s0,48(sp)
    80003cba:	f426                	sd	s1,40(sp)
    80003cbc:	f04a                	sd	s2,32(sp)
    80003cbe:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003cc0:	0001c497          	auipc	s1,0x1c
    80003cc4:	ff848493          	addi	s1,s1,-8 # 8001fcb8 <log>
    80003cc8:	8526                	mv	a0,s1
    80003cca:	f4ffc0ef          	jal	80000c18 <acquire>
  log.outstanding -= 1;
    80003cce:	4cdc                	lw	a5,28(s1)
    80003cd0:	37fd                	addiw	a5,a5,-1
    80003cd2:	893e                	mv	s2,a5
    80003cd4:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003cd6:	509c                	lw	a5,32(s1)
    80003cd8:	e7b9                	bnez	a5,80003d26 <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003cda:	04091f63          	bnez	s2,80003d38 <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003cde:	0001c497          	auipc	s1,0x1c
    80003ce2:	fda48493          	addi	s1,s1,-38 # 8001fcb8 <log>
    80003ce6:	4785                	li	a5,1
    80003ce8:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003cea:	8526                	mv	a0,s1
    80003cec:	fb1fc0ef          	jal	80000c9c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003cf0:	54dc                	lw	a5,44(s1)
    80003cf2:	06f04063          	bgtz	a5,80003d52 <end_op+0x9e>
    acquire(&log.lock);
    80003cf6:	0001c497          	auipc	s1,0x1c
    80003cfa:	fc248493          	addi	s1,s1,-62 # 8001fcb8 <log>
    80003cfe:	8526                	mv	a0,s1
    80003d00:	f19fc0ef          	jal	80000c18 <acquire>
    log.committing = 0;
    80003d04:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003d08:	549c                	lw	a5,40(s1)
    80003d0a:	2785                	addiw	a5,a5,1
    80003d0c:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003d0e:	8526                	mv	a0,s1
    80003d10:	a10fe0ef          	jal	80001f20 <wakeup>
    release(&log.lock);
    80003d14:	8526                	mv	a0,s1
    80003d16:	f87fc0ef          	jal	80000c9c <release>
}
    80003d1a:	70e2                	ld	ra,56(sp)
    80003d1c:	7442                	ld	s0,48(sp)
    80003d1e:	74a2                	ld	s1,40(sp)
    80003d20:	7902                	ld	s2,32(sp)
    80003d22:	6121                	addi	sp,sp,64
    80003d24:	8082                	ret
    80003d26:	ec4e                	sd	s3,24(sp)
    80003d28:	e852                	sd	s4,16(sp)
    80003d2a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003d2c:	00004517          	auipc	a0,0x4
    80003d30:	89c50513          	addi	a0,a0,-1892 # 800075c8 <etext+0x5c8>
    80003d34:	b07fc0ef          	jal	8000083a <panic>
    wakeup(&log);
    80003d38:	0001c517          	auipc	a0,0x1c
    80003d3c:	f8050513          	addi	a0,a0,-128 # 8001fcb8 <log>
    80003d40:	9e0fe0ef          	jal	80001f20 <wakeup>
  release(&log.lock);
    80003d44:	0001c517          	auipc	a0,0x1c
    80003d48:	f7450513          	addi	a0,a0,-140 # 8001fcb8 <log>
    80003d4c:	f51fc0ef          	jal	80000c9c <release>
  if (do_commit) {
    80003d50:	b7e9                	j	80003d1a <end_op+0x66>
    80003d52:	ec4e                	sd	s3,24(sp)
    80003d54:	e852                	sd	s4,16(sp)
    80003d56:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003d58:	0001ca97          	auipc	s5,0x1c
    80003d5c:	f90a8a93          	addi	s5,s5,-112 # 8001fce8 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003d60:	0001ca17          	auipc	s4,0x1c
    80003d64:	f58a0a13          	addi	s4,s4,-168 # 8001fcb8 <log>
    80003d68:	018a2583          	lw	a1,24(s4)
    80003d6c:	012585bb          	addw	a1,a1,s2
    80003d70:	2585                	addiw	a1,a1,1
    80003d72:	024a2503          	lw	a0,36(s4)
    80003d76:	e19fe0ef          	jal	80002b8e <bread>
    80003d7a:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003d7c:	000aa583          	lw	a1,0(s5)
    80003d80:	024a2503          	lw	a0,36(s4)
    80003d84:	e0bfe0ef          	jal	80002b8e <bread>
    80003d88:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003d8a:	40000613          	li	a2,1024
    80003d8e:	05850593          	addi	a1,a0,88
    80003d92:	05848513          	addi	a0,s1,88
    80003d96:	f9bfc0ef          	jal	80000d30 <memmove>
    bwrite(to); // write the log
    80003d9a:	8526                	mv	a0,s1
    80003d9c:	ec9fe0ef          	jal	80002c64 <bwrite>
    brelse(from);
    80003da0:	854e                	mv	a0,s3
    80003da2:	ef5fe0ef          	jal	80002c96 <brelse>
    brelse(to);
    80003da6:	8526                	mv	a0,s1
    80003da8:	eeffe0ef          	jal	80002c96 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003dac:	2905                	addiw	s2,s2,1
    80003dae:	0a91                	addi	s5,s5,4
    80003db0:	02ca2783          	lw	a5,44(s4)
    80003db4:	faf94ae3          	blt	s2,a5,80003d68 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003db8:	ce1ff0ef          	jal	80003a98 <write_head>
    install_trans(0); // Now install writes to home locations
    80003dbc:	4501                	li	a0,0
    80003dbe:	d39ff0ef          	jal	80003af6 <install_trans>
    log.lh.n = 0;
    80003dc2:	0001c797          	auipc	a5,0x1c
    80003dc6:	f207a123          	sw	zero,-222(a5) # 8001fce4 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003dca:	ccfff0ef          	jal	80003a98 <write_head>
    80003dce:	69e2                	ld	s3,24(sp)
    80003dd0:	6a42                	ld	s4,16(sp)
    80003dd2:	6aa2                	ld	s5,8(sp)
    80003dd4:	b70d                	j	80003cf6 <end_op+0x42>

0000000080003dd6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003dd6:	1101                	addi	sp,sp,-32
    80003dd8:	ec06                	sd	ra,24(sp)
    80003dda:	e822                	sd	s0,16(sp)
    80003ddc:	e426                	sd	s1,8(sp)
    80003dde:	1000                	addi	s0,sp,32
    80003de0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003de2:	0001c517          	auipc	a0,0x1c
    80003de6:	ed650513          	addi	a0,a0,-298 # 8001fcb8 <log>
    80003dea:	e2ffc0ef          	jal	80000c18 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003dee:	0001c617          	auipc	a2,0x1c
    80003df2:	ef662603          	lw	a2,-266(a2) # 8001fce4 <log+0x2c>
    80003df6:	47f5                	li	a5,29
    80003df8:	04c7cc63          	blt	a5,a2,80003e50 <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003dfc:	0001c797          	auipc	a5,0x1c
    80003e00:	ed87a783          	lw	a5,-296(a5) # 8001fcd4 <log+0x1c>
    80003e04:	04f05c63          	blez	a5,80003e5c <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e08:	4781                	li	a5,0
    80003e0a:	04c05f63          	blez	a2,80003e68 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e0e:	44cc                	lw	a1,12(s1)
    80003e10:	0001c717          	auipc	a4,0x1c
    80003e14:	ed870713          	addi	a4,a4,-296 # 8001fce8 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e18:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e1a:	4314                	lw	a3,0(a4)
    80003e1c:	04b68663          	beq	a3,a1,80003e68 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003e20:	2785                	addiw	a5,a5,1
    80003e22:	0711                	addi	a4,a4,4
    80003e24:	fef61be3          	bne	a2,a5,80003e1a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e28:	0621                	addi	a2,a2,8
    80003e2a:	060a                	slli	a2,a2,0x2
    80003e2c:	0001c797          	auipc	a5,0x1c
    80003e30:	e8c78793          	addi	a5,a5,-372 # 8001fcb8 <log>
    80003e34:	97b2                	add	a5,a5,a2
    80003e36:	44d8                	lw	a4,12(s1)
    80003e38:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003e3a:	8526                	mv	a0,s1
    80003e3c:	edffe0ef          	jal	80002d1a <bpin>
    log.lh.n++;
    80003e40:	0001c717          	auipc	a4,0x1c
    80003e44:	e7870713          	addi	a4,a4,-392 # 8001fcb8 <log>
    80003e48:	575c                	lw	a5,44(a4)
    80003e4a:	2785                	addiw	a5,a5,1
    80003e4c:	d75c                	sw	a5,44(a4)
    80003e4e:	a80d                	j	80003e80 <log_write+0xaa>
    panic("too big a transaction");
    80003e50:	00003517          	auipc	a0,0x3
    80003e54:	78850513          	addi	a0,a0,1928 # 800075d8 <etext+0x5d8>
    80003e58:	9e3fc0ef          	jal	8000083a <panic>
    panic("log_write outside of trans");
    80003e5c:	00003517          	auipc	a0,0x3
    80003e60:	79450513          	addi	a0,a0,1940 # 800075f0 <etext+0x5f0>
    80003e64:	9d7fc0ef          	jal	8000083a <panic>
  log.lh.block[i] = b->blockno;
    80003e68:	00878693          	addi	a3,a5,8
    80003e6c:	068a                	slli	a3,a3,0x2
    80003e6e:	0001c717          	auipc	a4,0x1c
    80003e72:	e4a70713          	addi	a4,a4,-438 # 8001fcb8 <log>
    80003e76:	9736                	add	a4,a4,a3
    80003e78:	44d4                	lw	a3,12(s1)
    80003e7a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003e7c:	faf60fe3          	beq	a2,a5,80003e3a <log_write+0x64>
  }
  release(&log.lock);
    80003e80:	0001c517          	auipc	a0,0x1c
    80003e84:	e3850513          	addi	a0,a0,-456 # 8001fcb8 <log>
    80003e88:	e15fc0ef          	jal	80000c9c <release>
}
    80003e8c:	60e2                	ld	ra,24(sp)
    80003e8e:	6442                	ld	s0,16(sp)
    80003e90:	64a2                	ld	s1,8(sp)
    80003e92:	6105                	addi	sp,sp,32
    80003e94:	8082                	ret

0000000080003e96 <sys_sync>:

uint64
sys_sync(void)
{
    80003e96:	1101                	addi	sp,sp,-32
    80003e98:	ec06                	sd	ra,24(sp)
    80003e9a:	e822                	sd	s0,16(sp)
    80003e9c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003e9e:	0001c517          	auipc	a0,0x1c
    80003ea2:	e1a50513          	addi	a0,a0,-486 # 8001fcb8 <log>
    80003ea6:	d73fc0ef          	jal	80000c18 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003eaa:	0001c797          	auipc	a5,0x1c
    80003eae:	e2e7a783          	lw	a5,-466(a5) # 8001fcd8 <log+0x20>
    80003eb2:	e799                	bnez	a5,80003ec0 <sys_sync+0x2a>
    80003eb4:	0001c797          	auipc	a5,0x1c
    80003eb8:	e207a783          	lw	a5,-480(a5) # 8001fcd4 <log+0x1c>
    80003ebc:	02f05563          	blez	a5,80003ee6 <sys_sync+0x50>
    80003ec0:	e426                	sd	s1,8(sp)
    80003ec2:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003ec4:	0001c917          	auipc	s2,0x1c
    80003ec8:	e1c92903          	lw	s2,-484(s2) # 8001fce0 <log+0x28>
    while (log.ncommit < n) {
      sleep(&log, &log.lock);
    80003ecc:	0001c497          	auipc	s1,0x1c
    80003ed0:	dec48493          	addi	s1,s1,-532 # 8001fcb8 <log>
    80003ed4:	85a6                	mv	a1,s1
    80003ed6:	8526                	mv	a0,s1
    80003ed8:	ffdfd0ef          	jal	80001ed4 <sleep>
    while (log.ncommit < n) {
    80003edc:	549c                	lw	a5,40(s1)
    80003ede:	fef95be3          	bge	s2,a5,80003ed4 <sys_sync+0x3e>
    80003ee2:	64a2                	ld	s1,8(sp)
    80003ee4:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003ee6:	0001c517          	auipc	a0,0x1c
    80003eea:	dd250513          	addi	a0,a0,-558 # 8001fcb8 <log>
    80003eee:	daffc0ef          	jal	80000c9c <release>
  return 0;
}
    80003ef2:	4501                	li	a0,0
    80003ef4:	60e2                	ld	ra,24(sp)
    80003ef6:	6442                	ld	s0,16(sp)
    80003ef8:	6105                	addi	sp,sp,32
    80003efa:	8082                	ret

0000000080003efc <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003efc:	1101                	addi	sp,sp,-32
    80003efe:	ec06                	sd	ra,24(sp)
    80003f00:	e822                	sd	s0,16(sp)
    80003f02:	e426                	sd	s1,8(sp)
    80003f04:	e04a                	sd	s2,0(sp)
    80003f06:	1000                	addi	s0,sp,32
    80003f08:	84aa                	mv	s1,a0
    80003f0a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f0c:	00003597          	auipc	a1,0x3
    80003f10:	70458593          	addi	a1,a1,1796 # 80007610 <etext+0x610>
    80003f14:	0521                	addi	a0,a0,8
    80003f16:	c83fc0ef          	jal	80000b98 <initlock>
  lk->name = name;
    80003f1a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f1e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f22:	0204a423          	sw	zero,40(s1)
}
    80003f26:	60e2                	ld	ra,24(sp)
    80003f28:	6442                	ld	s0,16(sp)
    80003f2a:	64a2                	ld	s1,8(sp)
    80003f2c:	6902                	ld	s2,0(sp)
    80003f2e:	6105                	addi	sp,sp,32
    80003f30:	8082                	ret

0000000080003f32 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f32:	1101                	addi	sp,sp,-32
    80003f34:	ec06                	sd	ra,24(sp)
    80003f36:	e822                	sd	s0,16(sp)
    80003f38:	e426                	sd	s1,8(sp)
    80003f3a:	e04a                	sd	s2,0(sp)
    80003f3c:	1000                	addi	s0,sp,32
    80003f3e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f40:	00850913          	addi	s2,a0,8
    80003f44:	854a                	mv	a0,s2
    80003f46:	cd3fc0ef          	jal	80000c18 <acquire>
  while (lk->locked) {
    80003f4a:	409c                	lw	a5,0(s1)
    80003f4c:	c799                	beqz	a5,80003f5a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003f4e:	85ca                	mv	a1,s2
    80003f50:	8526                	mv	a0,s1
    80003f52:	f83fd0ef          	jal	80001ed4 <sleep>
  while (lk->locked) {
    80003f56:	409c                	lw	a5,0(s1)
    80003f58:	fbfd                	bnez	a5,80003f4e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003f5a:	4785                	li	a5,1
    80003f5c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003f5e:	97dfd0ef          	jal	800018da <myproc>
    80003f62:	591c                	lw	a5,48(a0)
    80003f64:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003f66:	854a                	mv	a0,s2
    80003f68:	d35fc0ef          	jal	80000c9c <release>
}
    80003f6c:	60e2                	ld	ra,24(sp)
    80003f6e:	6442                	ld	s0,16(sp)
    80003f70:	64a2                	ld	s1,8(sp)
    80003f72:	6902                	ld	s2,0(sp)
    80003f74:	6105                	addi	sp,sp,32
    80003f76:	8082                	ret

0000000080003f78 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003f78:	1101                	addi	sp,sp,-32
    80003f7a:	ec06                	sd	ra,24(sp)
    80003f7c:	e822                	sd	s0,16(sp)
    80003f7e:	e426                	sd	s1,8(sp)
    80003f80:	e04a                	sd	s2,0(sp)
    80003f82:	1000                	addi	s0,sp,32
    80003f84:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f86:	00850913          	addi	s2,a0,8
    80003f8a:	854a                	mv	a0,s2
    80003f8c:	c8dfc0ef          	jal	80000c18 <acquire>
  lk->locked = 0;
    80003f90:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f94:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	f87fd0ef          	jal	80001f20 <wakeup>
  release(&lk->lk);
    80003f9e:	854a                	mv	a0,s2
    80003fa0:	cfdfc0ef          	jal	80000c9c <release>
}
    80003fa4:	60e2                	ld	ra,24(sp)
    80003fa6:	6442                	ld	s0,16(sp)
    80003fa8:	64a2                	ld	s1,8(sp)
    80003faa:	6902                	ld	s2,0(sp)
    80003fac:	6105                	addi	sp,sp,32
    80003fae:	8082                	ret

0000000080003fb0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003fb0:	7179                	addi	sp,sp,-48
    80003fb2:	f406                	sd	ra,40(sp)
    80003fb4:	f022                	sd	s0,32(sp)
    80003fb6:	ec26                	sd	s1,24(sp)
    80003fb8:	e84a                	sd	s2,16(sp)
    80003fba:	1800                	addi	s0,sp,48
    80003fbc:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    80003fbe:	00850913          	addi	s2,a0,8
    80003fc2:	854a                	mv	a0,s2
    80003fc4:	c55fc0ef          	jal	80000c18 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fc8:	409c                	lw	a5,0(s1)
    80003fca:	ef81                	bnez	a5,80003fe2 <holdingsleep+0x32>
    80003fcc:	4481                	li	s1,0
  release(&lk->lk);
    80003fce:	854a                	mv	a0,s2
    80003fd0:	ccdfc0ef          	jal	80000c9c <release>
  return r;
}
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	70a2                	ld	ra,40(sp)
    80003fd8:	7402                	ld	s0,32(sp)
    80003fda:	64e2                	ld	s1,24(sp)
    80003fdc:	6942                	ld	s2,16(sp)
    80003fde:	6145                	addi	sp,sp,48
    80003fe0:	8082                	ret
    80003fe2:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003fe4:	0284a983          	lw	s3,40(s1)
    80003fe8:	8f3fd0ef          	jal	800018da <myproc>
    80003fec:	5904                	lw	s1,48(a0)
    80003fee:	413484b3          	sub	s1,s1,s3
    80003ff2:	0014b493          	seqz	s1,s1
    80003ff6:	69a2                	ld	s3,8(sp)
    80003ff8:	bfd9                	j	80003fce <holdingsleep+0x1e>

0000000080003ffa <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003ffa:	1141                	addi	sp,sp,-16
    80003ffc:	e406                	sd	ra,8(sp)
    80003ffe:	e022                	sd	s0,0(sp)
    80004000:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80004002:	00003597          	auipc	a1,0x3
    80004006:	61e58593          	addi	a1,a1,1566 # 80007620 <etext+0x620>
    8000400a:	0001c517          	auipc	a0,0x1c
    8000400e:	df650513          	addi	a0,a0,-522 # 8001fe00 <ftable>
    80004012:	b87fc0ef          	jal	80000b98 <initlock>
}
    80004016:	60a2                	ld	ra,8(sp)
    80004018:	6402                	ld	s0,0(sp)
    8000401a:	0141                	addi	sp,sp,16
    8000401c:	8082                	ret

000000008000401e <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000401e:	1101                	addi	sp,sp,-32
    80004020:	ec06                	sd	ra,24(sp)
    80004022:	e822                	sd	s0,16(sp)
    80004024:	e426                	sd	s1,8(sp)
    80004026:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004028:	0001c517          	auipc	a0,0x1c
    8000402c:	dd850513          	addi	a0,a0,-552 # 8001fe00 <ftable>
    80004030:	be9fc0ef          	jal	80000c18 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004034:	0001c497          	auipc	s1,0x1c
    80004038:	de448493          	addi	s1,s1,-540 # 8001fe18 <ftable+0x18>
    8000403c:	0001d717          	auipc	a4,0x1d
    80004040:	d7c70713          	addi	a4,a4,-644 # 80020db8 <disk>
    if (f->ref == 0) {
    80004044:	40dc                	lw	a5,4(s1)
    80004046:	cf89                	beqz	a5,80004060 <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004048:	02848493          	addi	s1,s1,40
    8000404c:	fee49ce3          	bne	s1,a4,80004044 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80004050:	0001c517          	auipc	a0,0x1c
    80004054:	db050513          	addi	a0,a0,-592 # 8001fe00 <ftable>
    80004058:	c45fc0ef          	jal	80000c9c <release>
  return 0;
    8000405c:	4481                	li	s1,0
    8000405e:	a809                	j	80004070 <filealloc+0x52>
      f->ref = 1;
    80004060:	4785                	li	a5,1
    80004062:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80004064:	0001c517          	auipc	a0,0x1c
    80004068:	d9c50513          	addi	a0,a0,-612 # 8001fe00 <ftable>
    8000406c:	c31fc0ef          	jal	80000c9c <release>
}
    80004070:	8526                	mv	a0,s1
    80004072:	60e2                	ld	ra,24(sp)
    80004074:	6442                	ld	s0,16(sp)
    80004076:	64a2                	ld	s1,8(sp)
    80004078:	6105                	addi	sp,sp,32
    8000407a:	8082                	ret

000000008000407c <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    8000407c:	1101                	addi	sp,sp,-32
    8000407e:	ec06                	sd	ra,24(sp)
    80004080:	e822                	sd	s0,16(sp)
    80004082:	e426                	sd	s1,8(sp)
    80004084:	1000                	addi	s0,sp,32
    80004086:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80004088:	0001c517          	auipc	a0,0x1c
    8000408c:	d7850513          	addi	a0,a0,-648 # 8001fe00 <ftable>
    80004090:	b89fc0ef          	jal	80000c18 <acquire>
  if (f->ref < 1)
    80004094:	40dc                	lw	a5,4(s1)
    80004096:	02f05063          	blez	a5,800040b6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000409a:	2785                	addiw	a5,a5,1
    8000409c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000409e:	0001c517          	auipc	a0,0x1c
    800040a2:	d6250513          	addi	a0,a0,-670 # 8001fe00 <ftable>
    800040a6:	bf7fc0ef          	jal	80000c9c <release>
  return f;
}
    800040aa:	8526                	mv	a0,s1
    800040ac:	60e2                	ld	ra,24(sp)
    800040ae:	6442                	ld	s0,16(sp)
    800040b0:	64a2                	ld	s1,8(sp)
    800040b2:	6105                	addi	sp,sp,32
    800040b4:	8082                	ret
    panic("filedup");
    800040b6:	00003517          	auipc	a0,0x3
    800040ba:	57250513          	addi	a0,a0,1394 # 80007628 <etext+0x628>
    800040be:	f7cfc0ef          	jal	8000083a <panic>

00000000800040c2 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800040c2:	7139                	addi	sp,sp,-64
    800040c4:	fc06                	sd	ra,56(sp)
    800040c6:	f822                	sd	s0,48(sp)
    800040c8:	f426                	sd	s1,40(sp)
    800040ca:	0080                	addi	s0,sp,64
    800040cc:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800040ce:	0001c517          	auipc	a0,0x1c
    800040d2:	d3250513          	addi	a0,a0,-718 # 8001fe00 <ftable>
    800040d6:	b43fc0ef          	jal	80000c18 <acquire>
  if (f->ref < 1)
    800040da:	40dc                	lw	a5,4(s1)
    800040dc:	04f05a63          	blez	a5,80004130 <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    800040e0:	37fd                	addiw	a5,a5,-1
    800040e2:	c0dc                	sw	a5,4(s1)
    800040e4:	06f04063          	bgtz	a5,80004144 <fileclose+0x82>
    800040e8:	f04a                	sd	s2,32(sp)
    800040ea:	ec4e                	sd	s3,24(sp)
    800040ec:	e852                	sd	s4,16(sp)
    800040ee:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800040f0:	0004a903          	lw	s2,0(s1)
    800040f4:	0094c783          	lbu	a5,9(s1)
    800040f8:	89be                	mv	s3,a5
    800040fa:	689c                	ld	a5,16(s1)
    800040fc:	8a3e                	mv	s4,a5
    800040fe:	6c9c                	ld	a5,24(s1)
    80004100:	8abe                	mv	s5,a5
  f->ref = 0;
    80004102:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004106:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000410a:	0001c517          	auipc	a0,0x1c
    8000410e:	cf650513          	addi	a0,a0,-778 # 8001fe00 <ftable>
    80004112:	b8bfc0ef          	jal	80000c9c <release>

  if (ff.type == FD_PIPE) {
    80004116:	4785                	li	a5,1
    80004118:	04f90163          	beq	s2,a5,8000415a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    8000411c:	ffe9079b          	addiw	a5,s2,-2
    80004120:	4705                	li	a4,1
    80004122:	04f77563          	bgeu	a4,a5,8000416c <fileclose+0xaa>
    80004126:	7902                	ld	s2,32(sp)
    80004128:	69e2                	ld	s3,24(sp)
    8000412a:	6a42                	ld	s4,16(sp)
    8000412c:	6aa2                	ld	s5,8(sp)
    8000412e:	a00d                	j	80004150 <fileclose+0x8e>
    80004130:	f04a                	sd	s2,32(sp)
    80004132:	ec4e                	sd	s3,24(sp)
    80004134:	e852                	sd	s4,16(sp)
    80004136:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004138:	00003517          	auipc	a0,0x3
    8000413c:	4f850513          	addi	a0,a0,1272 # 80007630 <etext+0x630>
    80004140:	efafc0ef          	jal	8000083a <panic>
    release(&ftable.lock);
    80004144:	0001c517          	auipc	a0,0x1c
    80004148:	cbc50513          	addi	a0,a0,-836 # 8001fe00 <ftable>
    8000414c:	b51fc0ef          	jal	80000c9c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80004150:	70e2                	ld	ra,56(sp)
    80004152:	7442                	ld	s0,48(sp)
    80004154:	74a2                	ld	s1,40(sp)
    80004156:	6121                	addi	sp,sp,64
    80004158:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000415a:	85ce                	mv	a1,s3
    8000415c:	8552                	mv	a0,s4
    8000415e:	332000ef          	jal	80004490 <pipeclose>
    80004162:	7902                	ld	s2,32(sp)
    80004164:	69e2                	ld	s3,24(sp)
    80004166:	6a42                	ld	s4,16(sp)
    80004168:	6aa2                	ld	s5,8(sp)
    8000416a:	b7dd                	j	80004150 <fileclose+0x8e>
    begin_op();
    8000416c:	ad9ff0ef          	jal	80003c44 <begin_op>
    iput(ff.ip);
    80004170:	8556                	mv	a0,s5
    80004172:	a3eff0ef          	jal	800033b0 <iput>
    end_op();
    80004176:	b3fff0ef          	jal	80003cb4 <end_op>
    8000417a:	7902                	ld	s2,32(sp)
    8000417c:	69e2                	ld	s3,24(sp)
    8000417e:	6a42                	ld	s4,16(sp)
    80004180:	6aa2                	ld	s5,8(sp)
    80004182:	b7f9                	j	80004150 <fileclose+0x8e>

0000000080004184 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80004184:	715d                	addi	sp,sp,-80
    80004186:	e486                	sd	ra,72(sp)
    80004188:	e0a2                	sd	s0,64(sp)
    8000418a:	fc26                	sd	s1,56(sp)
    8000418c:	f052                	sd	s4,32(sp)
    8000418e:	0880                	addi	s0,sp,80
    80004190:	84aa                	mv	s1,a0
    80004192:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80004194:	f46fd0ef          	jal	800018da <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    80004198:	409c                	lw	a5,0(s1)
    8000419a:	37f9                	addiw	a5,a5,-2
    8000419c:	4705                	li	a4,1
    8000419e:	04f76263          	bltu	a4,a5,800041e2 <filestat+0x5e>
    800041a2:	f84a                	sd	s2,48(sp)
    800041a4:	f44e                	sd	s3,40(sp)
    800041a6:	89aa                	mv	s3,a0
    ilock(f->ip);
    800041a8:	6c88                	ld	a0,24(s1)
    800041aa:	884ff0ef          	jal	8000322e <ilock>
    stati(f->ip, &st);
    800041ae:	fb840913          	addi	s2,s0,-72
    800041b2:	85ca                	mv	a1,s2
    800041b4:	6c88                	ld	a0,24(s1)
    800041b6:	bdcff0ef          	jal	80003592 <stati>
    iunlock(f->ip);
    800041ba:	6c88                	ld	a0,24(s1)
    800041bc:	920ff0ef          	jal	800032dc <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800041c0:	46e1                	li	a3,24
    800041c2:	864a                	mv	a2,s2
    800041c4:	85d2                	mv	a1,s4
    800041c6:	0509b503          	ld	a0,80(s3)
    800041ca:	c42fd0ef          	jal	8000160c <copyout>
    800041ce:	41f5551b          	sraiw	a0,a0,0x1f
    800041d2:	7942                	ld	s2,48(sp)
    800041d4:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800041d6:	60a6                	ld	ra,72(sp)
    800041d8:	6406                	ld	s0,64(sp)
    800041da:	74e2                	ld	s1,56(sp)
    800041dc:	7a02                	ld	s4,32(sp)
    800041de:	6161                	addi	sp,sp,80
    800041e0:	8082                	ret
  return -1;
    800041e2:	557d                	li	a0,-1
    800041e4:	bfcd                	j	800041d6 <filestat+0x52>

00000000800041e6 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800041e6:	7179                	addi	sp,sp,-48
    800041e8:	f406                	sd	ra,40(sp)
    800041ea:	f022                	sd	s0,32(sp)
    800041ec:	e84a                	sd	s2,16(sp)
    800041ee:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    800041f0:	00854783          	lbu	a5,8(a0)
    800041f4:	c3c5                	beqz	a5,80004294 <fileread+0xae>
    800041f6:	ec26                	sd	s1,24(sp)
    800041f8:	e44e                	sd	s3,8(sp)
    800041fa:	84aa                	mv	s1,a0
    800041fc:	892e                	mv	s2,a1
    800041fe:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004200:	411c                	lw	a5,0(a0)
    80004202:	4705                	li	a4,1
    80004204:	04e78363          	beq	a5,a4,8000424a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004208:	470d                	li	a4,3
    8000420a:	04e78763          	beq	a5,a4,80004258 <fileread+0x72>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000420e:	4709                	li	a4,2
    80004210:	06e79a63          	bne	a5,a4,80004284 <fileread+0x9e>
    ilock(f->ip);
    80004214:	6d08                	ld	a0,24(a0)
    80004216:	818ff0ef          	jal	8000322e <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000421a:	874e                	mv	a4,s3
    8000421c:	5094                	lw	a3,32(s1)
    8000421e:	864a                	mv	a2,s2
    80004220:	4585                	li	a1,1
    80004222:	6c88                	ld	a0,24(s1)
    80004224:	b9cff0ef          	jal	800035c0 <readi>
    80004228:	892a                	mv	s2,a0
    8000422a:	00a05563          	blez	a0,80004234 <fileread+0x4e>
      f->off += r;
    8000422e:	509c                	lw	a5,32(s1)
    80004230:	9fa9                	addw	a5,a5,a0
    80004232:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004234:	6c88                	ld	a0,24(s1)
    80004236:	8a6ff0ef          	jal	800032dc <iunlock>
    8000423a:	64e2                	ld	s1,24(sp)
    8000423c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000423e:	854a                	mv	a0,s2
    80004240:	70a2                	ld	ra,40(sp)
    80004242:	7402                	ld	s0,32(sp)
    80004244:	6942                	ld	s2,16(sp)
    80004246:	6145                	addi	sp,sp,48
    80004248:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000424a:	6908                	ld	a0,16(a0)
    8000424c:	39a000ef          	jal	800045e6 <piperead>
    80004250:	892a                	mv	s2,a0
    80004252:	64e2                	ld	s1,24(sp)
    80004254:	69a2                	ld	s3,8(sp)
    80004256:	b7e5                	j	8000423e <fileread+0x58>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80004258:	02451783          	lh	a5,36(a0)
    8000425c:	03079693          	slli	a3,a5,0x30
    80004260:	92c1                	srli	a3,a3,0x30
    80004262:	4725                	li	a4,9
    80004264:	02d76663          	bltu	a4,a3,80004290 <fileread+0xaa>
    80004268:	0792                	slli	a5,a5,0x4
    8000426a:	0001c717          	auipc	a4,0x1c
    8000426e:	af670713          	addi	a4,a4,-1290 # 8001fd60 <devsw>
    80004272:	97ba                	add	a5,a5,a4
    80004274:	639c                	ld	a5,0(a5)
    80004276:	c395                	beqz	a5,8000429a <fileread+0xb4>
    r = devsw[f->major].read(1, addr, n);
    80004278:	4505                	li	a0,1
    8000427a:	9782                	jalr	a5
    8000427c:	892a                	mv	s2,a0
    8000427e:	64e2                	ld	s1,24(sp)
    80004280:	69a2                	ld	s3,8(sp)
    80004282:	bf75                	j	8000423e <fileread+0x58>
    panic("fileread");
    80004284:	00003517          	auipc	a0,0x3
    80004288:	3bc50513          	addi	a0,a0,956 # 80007640 <etext+0x640>
    8000428c:	daefc0ef          	jal	8000083a <panic>
    80004290:	64e2                	ld	s1,24(sp)
    80004292:	69a2                	ld	s3,8(sp)
    return -1;
    80004294:	57fd                	li	a5,-1
    80004296:	893e                	mv	s2,a5
    80004298:	b75d                	j	8000423e <fileread+0x58>
    8000429a:	64e2                	ld	s1,24(sp)
    8000429c:	69a2                	ld	s3,8(sp)
    8000429e:	bfdd                	j	80004294 <fileread+0xae>

00000000800042a0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0)
    800042a0:	00954783          	lbu	a5,9(a0)
    800042a4:	12078463          	beqz	a5,800043cc <filewrite+0x12c>
{
    800042a8:	711d                	addi	sp,sp,-96
    800042aa:	ec86                	sd	ra,88(sp)
    800042ac:	e8a2                	sd	s0,80(sp)
    800042ae:	e0ca                	sd	s2,64(sp)
    800042b0:	f456                	sd	s5,40(sp)
    800042b2:	f05a                	sd	s6,32(sp)
    800042b4:	1080                	addi	s0,sp,96
    800042b6:	892a                	mv	s2,a0
    800042b8:	8b2e                	mv	s6,a1
    800042ba:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    800042bc:	411c                	lw	a5,0(a0)
    800042be:	4705                	li	a4,1
    800042c0:	02e78a63          	beq	a5,a4,800042f4 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    800042c4:	470d                	li	a4,3
    800042c6:	02e78b63          	beq	a5,a4,800042fc <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    800042ca:	4709                	li	a4,2
    800042cc:	0ce79f63          	bne	a5,a4,800043aa <filewrite+0x10a>
    800042d0:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    800042d2:	0ac05a63          	blez	a2,80004386 <filewrite+0xe6>
    800042d6:	e4a6                	sd	s1,72(sp)
    800042d8:	fc4e                	sd	s3,56(sp)
    800042da:	ec5e                	sd	s7,24(sp)
    800042dc:	e862                	sd	s8,16(sp)
    800042de:	e466                	sd	s9,8(sp)
    int i = 0;
    800042e0:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    800042e2:	6b85                	lui	s7,0x1
    800042e4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800042e8:	6785                	lui	a5,0x1
    800042ea:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800042ee:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800042f0:	4c05                	li	s8,1
    800042f2:	a8ad                	j	8000436c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800042f4:	6908                	ld	a0,16(a0)
    800042f6:	1f8000ef          	jal	800044ee <pipewrite>
    800042fa:	a04d                	j	8000439c <filewrite+0xfc>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800042fc:	02451783          	lh	a5,36(a0)
    80004300:	03079693          	slli	a3,a5,0x30
    80004304:	92c1                	srli	a3,a3,0x30
    80004306:	4725                	li	a4,9
    80004308:	0ad76d63          	bltu	a4,a3,800043c2 <filewrite+0x122>
    8000430c:	0792                	slli	a5,a5,0x4
    8000430e:	0001c717          	auipc	a4,0x1c
    80004312:	a5270713          	addi	a4,a4,-1454 # 8001fd60 <devsw>
    80004316:	97ba                	add	a5,a5,a4
    80004318:	679c                	ld	a5,8(a5)
    8000431a:	c7c5                	beqz	a5,800043c2 <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    8000431c:	4505                	li	a0,1
    8000431e:	9782                	jalr	a5
    80004320:	a8b5                	j	8000439c <filewrite+0xfc>
      if (n1 > max)
    80004322:	2981                	sext.w	s3,s3
      begin_op();
    80004324:	921ff0ef          	jal	80003c44 <begin_op>
      ilock(f->ip);
    80004328:	01893503          	ld	a0,24(s2)
    8000432c:	f03fe0ef          	jal	8000322e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80004330:	874e                	mv	a4,s3
    80004332:	02092683          	lw	a3,32(s2)
    80004336:	016a0633          	add	a2,s4,s6
    8000433a:	85e2                	mv	a1,s8
    8000433c:	01893503          	ld	a0,24(s2)
    80004340:	b72ff0ef          	jal	800036b2 <writei>
    80004344:	84aa                	mv	s1,a0
    80004346:	00a05763          	blez	a0,80004354 <filewrite+0xb4>
        f->off += r;
    8000434a:	02092783          	lw	a5,32(s2)
    8000434e:	9fa9                	addw	a5,a5,a0
    80004350:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80004354:	01893503          	ld	a0,24(s2)
    80004358:	f85fe0ef          	jal	800032dc <iunlock>
      end_op();
    8000435c:	959ff0ef          	jal	80003cb4 <end_op>

      if (r != n1) {
    80004360:	02999563          	bne	s3,s1,8000438a <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80004364:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    80004368:	015a5963          	bge	s4,s5,8000437a <filewrite+0xda>
      int n1 = n - i;
    8000436c:	414a87bb          	subw	a5,s5,s4
    80004370:	89be                	mv	s3,a5
      if (n1 > max)
    80004372:	fafbd8e3          	bge	s7,a5,80004322 <filewrite+0x82>
    80004376:	89e6                	mv	s3,s9
    80004378:	b76d                	j	80004322 <filewrite+0x82>
    8000437a:	64a6                	ld	s1,72(sp)
    8000437c:	79e2                	ld	s3,56(sp)
    8000437e:	6be2                	ld	s7,24(sp)
    80004380:	6c42                	ld	s8,16(sp)
    80004382:	6ca2                	ld	s9,8(sp)
    80004384:	a801                	j	80004394 <filewrite+0xf4>
    int i = 0;
    80004386:	4a01                	li	s4,0
    80004388:	a031                	j	80004394 <filewrite+0xf4>
    8000438a:	64a6                	ld	s1,72(sp)
    8000438c:	79e2                	ld	s3,56(sp)
    8000438e:	6be2                	ld	s7,24(sp)
    80004390:	6c42                	ld	s8,16(sp)
    80004392:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80004394:	034a9963          	bne	s5,s4,800043c6 <filewrite+0x126>
    80004398:	8556                	mv	a0,s5
    8000439a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000439c:	60e6                	ld	ra,88(sp)
    8000439e:	6446                	ld	s0,80(sp)
    800043a0:	6906                	ld	s2,64(sp)
    800043a2:	7aa2                	ld	s5,40(sp)
    800043a4:	7b02                	ld	s6,32(sp)
    800043a6:	6125                	addi	sp,sp,96
    800043a8:	8082                	ret
    800043aa:	e4a6                	sd	s1,72(sp)
    800043ac:	fc4e                	sd	s3,56(sp)
    800043ae:	f852                	sd	s4,48(sp)
    800043b0:	ec5e                	sd	s7,24(sp)
    800043b2:	e862                	sd	s8,16(sp)
    800043b4:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800043b6:	00003517          	auipc	a0,0x3
    800043ba:	29a50513          	addi	a0,a0,666 # 80007650 <etext+0x650>
    800043be:	c7cfc0ef          	jal	8000083a <panic>
    return -1;
    800043c2:	557d                	li	a0,-1
    800043c4:	bfe1                	j	8000439c <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800043c6:	557d                	li	a0,-1
    800043c8:	7a42                	ld	s4,48(sp)
    800043ca:	bfc9                	j	8000439c <filewrite+0xfc>
    return -1;
    800043cc:	557d                	li	a0,-1
}
    800043ce:	8082                	ret

00000000800043d0 <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800043d0:	7179                	addi	sp,sp,-48
    800043d2:	f406                	sd	ra,40(sp)
    800043d4:	f022                	sd	s0,32(sp)
    800043d6:	ec26                	sd	s1,24(sp)
    800043d8:	e052                	sd	s4,0(sp)
    800043da:	1800                	addi	s0,sp,48
    800043dc:	84aa                	mv	s1,a0
    800043de:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800043e0:	0005b023          	sd	zero,0(a1)
    800043e4:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800043e8:	c37ff0ef          	jal	8000401e <filealloc>
    800043ec:	e088                	sd	a0,0(s1)
    800043ee:	c549                	beqz	a0,80004478 <pipealloc+0xa8>
    800043f0:	c2fff0ef          	jal	8000401e <filealloc>
    800043f4:	00aa3023          	sd	a0,0(s4)
    800043f8:	cd25                	beqz	a0,80004470 <pipealloc+0xa0>
    800043fa:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    800043fc:	f42fc0ef          	jal	80000b3e <kalloc>
    80004400:	892a                	mv	s2,a0
    80004402:	c12d                	beqz	a0,80004464 <pipealloc+0x94>
    80004404:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004406:	4985                	li	s3,1
    80004408:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    8000440c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80004410:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004414:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004418:	00003597          	auipc	a1,0x3
    8000441c:	fa058593          	addi	a1,a1,-96 # 800073b8 <etext+0x3b8>
    80004420:	f78fc0ef          	jal	80000b98 <initlock>
  (*f0)->type = FD_PIPE;
    80004424:	609c                	ld	a5,0(s1)
    80004426:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000442a:	609c                	ld	a5,0(s1)
    8000442c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80004430:	609c                	ld	a5,0(s1)
    80004432:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004436:	609c                	ld	a5,0(s1)
    80004438:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000443c:	000a3783          	ld	a5,0(s4)
    80004440:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80004444:	000a3783          	ld	a5,0(s4)
    80004448:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000444c:	000a3783          	ld	a5,0(s4)
    80004450:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80004454:	000a3783          	ld	a5,0(s4)
    80004458:	0127b823          	sd	s2,16(a5)
  return 0;
    8000445c:	4501                	li	a0,0
    8000445e:	6942                	ld	s2,16(sp)
    80004460:	69a2                	ld	s3,8(sp)
    80004462:	a00d                	j	80004484 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    80004464:	6088                	ld	a0,0(s1)
    80004466:	c119                	beqz	a0,8000446c <pipealloc+0x9c>
    80004468:	6942                	ld	s2,16(sp)
    8000446a:	a029                	j	80004474 <pipealloc+0xa4>
    8000446c:	6942                	ld	s2,16(sp)
    8000446e:	a029                	j	80004478 <pipealloc+0xa8>
    80004470:	6088                	ld	a0,0(s1)
    80004472:	c901                	beqz	a0,80004482 <pipealloc+0xb2>
    fileclose(*f0);
    80004474:	c4fff0ef          	jal	800040c2 <fileclose>
  if (*f1)
    80004478:	000a3503          	ld	a0,0(s4)
    8000447c:	c119                	beqz	a0,80004482 <pipealloc+0xb2>
    fileclose(*f1);
    8000447e:	c45ff0ef          	jal	800040c2 <fileclose>
  return -1;
    80004482:	557d                	li	a0,-1
}
    80004484:	70a2                	ld	ra,40(sp)
    80004486:	7402                	ld	s0,32(sp)
    80004488:	64e2                	ld	s1,24(sp)
    8000448a:	6a02                	ld	s4,0(sp)
    8000448c:	6145                	addi	sp,sp,48
    8000448e:	8082                	ret

0000000080004490 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80004490:	1101                	addi	sp,sp,-32
    80004492:	ec06                	sd	ra,24(sp)
    80004494:	e822                	sd	s0,16(sp)
    80004496:	e426                	sd	s1,8(sp)
    80004498:	e04a                	sd	s2,0(sp)
    8000449a:	1000                	addi	s0,sp,32
    8000449c:	84aa                	mv	s1,a0
    8000449e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800044a0:	f78fc0ef          	jal	80000c18 <acquire>
  if (writable) {
    800044a4:	02090763          	beqz	s2,800044d2 <pipeclose+0x42>
    pi->writeopen = 0;
    800044a8:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800044ac:	21848513          	addi	a0,s1,536
    800044b0:	a71fd0ef          	jal	80001f20 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    800044b4:	2204a783          	lw	a5,544(s1)
    800044b8:	e781                	bnez	a5,800044c0 <pipeclose+0x30>
    800044ba:	2244a783          	lw	a5,548(s1)
    800044be:	c38d                	beqz	a5,800044e0 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    800044c0:	8526                	mv	a0,s1
    800044c2:	fdafc0ef          	jal	80000c9c <release>
}
    800044c6:	60e2                	ld	ra,24(sp)
    800044c8:	6442                	ld	s0,16(sp)
    800044ca:	64a2                	ld	s1,8(sp)
    800044cc:	6902                	ld	s2,0(sp)
    800044ce:	6105                	addi	sp,sp,32
    800044d0:	8082                	ret
    pi->readopen = 0;
    800044d2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800044d6:	21c48513          	addi	a0,s1,540
    800044da:	a47fd0ef          	jal	80001f20 <wakeup>
    800044de:	bfd9                	j	800044b4 <pipeclose+0x24>
    release(&pi->lock);
    800044e0:	8526                	mv	a0,s1
    800044e2:	fbafc0ef          	jal	80000c9c <release>
    kfree((char *)pi);
    800044e6:	8526                	mv	a0,s1
    800044e8:	d6efc0ef          	jal	80000a56 <kfree>
    800044ec:	bfe9                	j	800044c6 <pipeclose+0x36>

00000000800044ee <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800044ee:	7159                	addi	sp,sp,-112
    800044f0:	f486                	sd	ra,104(sp)
    800044f2:	f0a2                	sd	s0,96(sp)
    800044f4:	eca6                	sd	s1,88(sp)
    800044f6:	e8ca                	sd	s2,80(sp)
    800044f8:	e4ce                	sd	s3,72(sp)
    800044fa:	e0d2                	sd	s4,64(sp)
    800044fc:	fc56                	sd	s5,56(sp)
    800044fe:	1880                	addi	s0,sp,112
    80004500:	84aa                	mv	s1,a0
    80004502:	8aae                	mv	s5,a1
    80004504:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004506:	bd4fd0ef          	jal	800018da <myproc>
    8000450a:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    8000450c:	8526                	mv	a0,s1
    8000450e:	f0afc0ef          	jal	80000c18 <acquire>
  while (i < n) {
    80004512:	0d405263          	blez	s4,800045d6 <pipewrite+0xe8>
    80004516:	f85a                	sd	s6,48(sp)
    80004518:	f45e                	sd	s7,40(sp)
    8000451a:	f062                	sd	s8,32(sp)
    8000451c:	ec66                	sd	s9,24(sp)
    8000451e:	e86a                	sd	s10,16(sp)
  int i = 0;
    80004520:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004522:	f9f40c13          	addi	s8,s0,-97
    80004526:	4b85                	li	s7,1
    80004528:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000452a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000452e:	21c48c93          	addi	s9,s1,540
    80004532:	a82d                	j	8000456c <pipewrite+0x7e>
      release(&pi->lock);
    80004534:	8526                	mv	a0,s1
    80004536:	f66fc0ef          	jal	80000c9c <release>
      return -1;
    8000453a:	597d                	li	s2,-1
    8000453c:	7b42                	ld	s6,48(sp)
    8000453e:	7ba2                	ld	s7,40(sp)
    80004540:	7c02                	ld	s8,32(sp)
    80004542:	6ce2                	ld	s9,24(sp)
    80004544:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004546:	854a                	mv	a0,s2
    80004548:	70a6                	ld	ra,104(sp)
    8000454a:	7406                	ld	s0,96(sp)
    8000454c:	64e6                	ld	s1,88(sp)
    8000454e:	6946                	ld	s2,80(sp)
    80004550:	69a6                	ld	s3,72(sp)
    80004552:	6a06                	ld	s4,64(sp)
    80004554:	7ae2                	ld	s5,56(sp)
    80004556:	6165                	addi	sp,sp,112
    80004558:	8082                	ret
      wakeup(&pi->nread);
    8000455a:	856a                	mv	a0,s10
    8000455c:	9c5fd0ef          	jal	80001f20 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004560:	85a6                	mv	a1,s1
    80004562:	8566                	mv	a0,s9
    80004564:	971fd0ef          	jal	80001ed4 <sleep>
  while (i < n) {
    80004568:	05495a63          	bge	s2,s4,800045bc <pipewrite+0xce>
    if (pi->readopen == 0 || killed(pr)) {
    8000456c:	2204a783          	lw	a5,544(s1)
    80004570:	d3f1                	beqz	a5,80004534 <pipewrite+0x46>
    80004572:	854e                	mv	a0,s3
    80004574:	b9dfd0ef          	jal	80002110 <killed>
    80004578:	fd55                	bnez	a0,80004534 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    8000457a:	2184a783          	lw	a5,536(s1)
    8000457e:	21c4a703          	lw	a4,540(s1)
    80004582:	2007879b          	addiw	a5,a5,512
    80004586:	fcf70ae3          	beq	a4,a5,8000455a <pipewrite+0x6c>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000458a:	86de                	mv	a3,s7
    8000458c:	01590633          	add	a2,s2,s5
    80004590:	85e2                	mv	a1,s8
    80004592:	0509b503          	ld	a0,80(s3)
    80004596:	92efd0ef          	jal	800016c4 <copyin>
    8000459a:	05650063          	beq	a0,s6,800045da <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000459e:	21c4a783          	lw	a5,540(s1)
    800045a2:	0017871b          	addiw	a4,a5,1
    800045a6:	20e4ae23          	sw	a4,540(s1)
    800045aa:	1ff7f793          	andi	a5,a5,511
    800045ae:	97a6                	add	a5,a5,s1
    800045b0:	f9f44703          	lbu	a4,-97(s0)
    800045b4:	00e78c23          	sb	a4,24(a5)
      i++;
    800045b8:	2905                	addiw	s2,s2,1
    800045ba:	b77d                	j	80004568 <pipewrite+0x7a>
    800045bc:	7b42                	ld	s6,48(sp)
    800045be:	7ba2                	ld	s7,40(sp)
    800045c0:	7c02                	ld	s8,32(sp)
    800045c2:	6ce2                	ld	s9,24(sp)
    800045c4:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800045c6:	21848513          	addi	a0,s1,536
    800045ca:	957fd0ef          	jal	80001f20 <wakeup>
  release(&pi->lock);
    800045ce:	8526                	mv	a0,s1
    800045d0:	eccfc0ef          	jal	80000c9c <release>
  return i;
    800045d4:	bf8d                	j	80004546 <pipewrite+0x58>
  int i = 0;
    800045d6:	4901                	li	s2,0
    800045d8:	b7fd                	j	800045c6 <pipewrite+0xd8>
    800045da:	7b42                	ld	s6,48(sp)
    800045dc:	7ba2                	ld	s7,40(sp)
    800045de:	7c02                	ld	s8,32(sp)
    800045e0:	6ce2                	ld	s9,24(sp)
    800045e2:	6d42                	ld	s10,16(sp)
    800045e4:	b7cd                	j	800045c6 <pipewrite+0xd8>

00000000800045e6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800045e6:	711d                	addi	sp,sp,-96
    800045e8:	ec86                	sd	ra,88(sp)
    800045ea:	e8a2                	sd	s0,80(sp)
    800045ec:	e4a6                	sd	s1,72(sp)
    800045ee:	e0ca                	sd	s2,64(sp)
    800045f0:	fc4e                	sd	s3,56(sp)
    800045f2:	f852                	sd	s4,48(sp)
    800045f4:	f456                	sd	s5,40(sp)
    800045f6:	1080                	addi	s0,sp,96
    800045f8:	84aa                	mv	s1,a0
    800045fa:	892e                	mv	s2,a1
    800045fc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800045fe:	adcfd0ef          	jal	800018da <myproc>
    80004602:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004604:	8526                	mv	a0,s1
    80004606:	e12fc0ef          	jal	80000c18 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000460a:	2184a703          	lw	a4,536(s1)
    8000460e:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004612:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004616:	02f71363          	bne	a4,a5,8000463c <piperead+0x56>
    8000461a:	2244a783          	lw	a5,548(s1)
    8000461e:	cf99                	beqz	a5,8000463c <piperead+0x56>
    if (killed(pr)) {
    80004620:	8552                	mv	a0,s4
    80004622:	aeffd0ef          	jal	80002110 <killed>
    80004626:	e925                	bnez	a0,80004696 <piperead+0xb0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004628:	85a6                	mv	a1,s1
    8000462a:	854e                	mv	a0,s3
    8000462c:	8a9fd0ef          	jal	80001ed4 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004630:	2184a703          	lw	a4,536(s1)
    80004634:	21c4a783          	lw	a5,540(s1)
    80004638:	fef701e3          	beq	a4,a5,8000461a <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    8000463c:	07505863          	blez	s5,800046ac <piperead+0xc6>
    80004640:	f05a                	sd	s6,32(sp)
    80004642:	ec5e                	sd	s7,24(sp)
    80004644:	e862                	sd	s8,16(sp)
    80004646:	4981                	li	s3,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    80004648:	faf40c13          	addi	s8,s0,-81
    8000464c:	4b85                	li	s7,1
    8000464e:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    80004650:	2184a783          	lw	a5,536(s1)
    80004654:	21c4a703          	lw	a4,540(s1)
    80004658:	06f70163          	beq	a4,a5,800046ba <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    8000465c:	1ff7f793          	andi	a5,a5,511
    80004660:	97a6                	add	a5,a5,s1
    80004662:	0187c783          	lbu	a5,24(a5)
    80004666:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    8000466a:	86de                	mv	a3,s7
    8000466c:	8662                	mv	a2,s8
    8000466e:	85ca                	mv	a1,s2
    80004670:	050a3503          	ld	a0,80(s4)
    80004674:	f99fc0ef          	jal	8000160c <copyout>
    80004678:	03650463          	beq	a0,s6,800046a0 <piperead+0xba>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    8000467c:	2184a783          	lw	a5,536(s1)
    80004680:	2785                	addiw	a5,a5,1
    80004682:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004686:	2985                	addiw	s3,s3,1
    80004688:	0905                	addi	s2,s2,1
    8000468a:	fd3a93e3          	bne	s5,s3,80004650 <piperead+0x6a>
    8000468e:	7b02                	ld	s6,32(sp)
    80004690:	6be2                	ld	s7,24(sp)
    80004692:	6c42                	ld	s8,16(sp)
    80004694:	a035                	j	800046c0 <piperead+0xda>
      release(&pi->lock);
    80004696:	8526                	mv	a0,s1
    80004698:	e04fc0ef          	jal	80000c9c <release>
      return -1;
    8000469c:	59fd                	li	s3,-1
    8000469e:	a805                	j	800046ce <piperead+0xe8>
      if (i == 0)
    800046a0:	00098863          	beqz	s3,800046b0 <piperead+0xca>
    800046a4:	7b02                	ld	s6,32(sp)
    800046a6:	6be2                	ld	s7,24(sp)
    800046a8:	6c42                	ld	s8,16(sp)
    800046aa:	a819                	j	800046c0 <piperead+0xda>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800046ac:	4981                	li	s3,0
    800046ae:	a809                	j	800046c0 <piperead+0xda>
        i = -1;
    800046b0:	89aa                	mv	s3,a0
    800046b2:	7b02                	ld	s6,32(sp)
    800046b4:	6be2                	ld	s7,24(sp)
    800046b6:	6c42                	ld	s8,16(sp)
    800046b8:	a021                	j	800046c0 <piperead+0xda>
    800046ba:	7b02                	ld	s6,32(sp)
    800046bc:	6be2                	ld	s7,24(sp)
    800046be:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    800046c0:	21c48513          	addi	a0,s1,540
    800046c4:	85dfd0ef          	jal	80001f20 <wakeup>
  release(&pi->lock);
    800046c8:	8526                	mv	a0,s1
    800046ca:	dd2fc0ef          	jal	80000c9c <release>
  return i;
}
    800046ce:	854e                	mv	a0,s3
    800046d0:	60e6                	ld	ra,88(sp)
    800046d2:	6446                	ld	s0,80(sp)
    800046d4:	64a6                	ld	s1,72(sp)
    800046d6:	6906                	ld	s2,64(sp)
    800046d8:	79e2                	ld	s3,56(sp)
    800046da:	7a42                	ld	s4,48(sp)
    800046dc:	7aa2                	ld	s5,40(sp)
    800046de:	6125                	addi	sp,sp,96
    800046e0:	8082                	ret

00000000800046e2 <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    800046e2:	1141                	addi	sp,sp,-16
    800046e4:	e406                	sd	ra,8(sp)
    800046e6:	e022                	sd	s0,0(sp)
    800046e8:	0800                	addi	s0,sp,16
    800046ea:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    800046ec:	0035151b          	slliw	a0,a0,0x3
    800046f0:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    800046f2:	8b89                	andi	a5,a5,2
    800046f4:	c399                	beqz	a5,800046fa <flags2perm+0x18>
    perm |= PTE_W;
    800046f6:	00456513          	ori	a0,a0,4
  return perm;
}
    800046fa:	60a2                	ld	ra,8(sp)
    800046fc:	6402                	ld	s0,0(sp)
    800046fe:	0141                	addi	sp,sp,16
    80004700:	8082                	ret

0000000080004702 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004702:	df010113          	addi	sp,sp,-528
    80004706:	20113423          	sd	ra,520(sp)
    8000470a:	20813023          	sd	s0,512(sp)
    8000470e:	ffa6                	sd	s1,504(sp)
    80004710:	fbca                	sd	s2,496(sp)
    80004712:	0c00                	addi	s0,sp,528
    80004714:	892a                	mv	s2,a0
    80004716:	e0a43023          	sd	a0,-512(s0)
    8000471a:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000471e:	9bcfd0ef          	jal	800018da <myproc>
    80004722:	84aa                	mv	s1,a0

  begin_op();
    80004724:	d20ff0ef          	jal	80003c44 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004728:	854a                	mv	a0,s2
    8000472a:	b3cff0ef          	jal	80003a66 <namei>
    8000472e:	c931                	beqz	a0,80004782 <kexec+0x80>
    80004730:	f3d2                	sd	s4,480(sp)
    80004732:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004734:	afbfe0ef          	jal	8000322e <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004738:	04000713          	li	a4,64
    8000473c:	4681                	li	a3,0
    8000473e:	e5040613          	addi	a2,s0,-432
    80004742:	4581                	li	a1,0
    80004744:	8552                	mv	a0,s4
    80004746:	e7bfe0ef          	jal	800035c0 <readi>
    8000474a:	04000793          	li	a5,64
    8000474e:	00f51a63          	bne	a0,a5,80004762 <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    80004752:	e5042703          	lw	a4,-432(s0)
    80004756:	464c47b7          	lui	a5,0x464c4
    8000475a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000475e:	02f70563          	beq	a4,a5,80004788 <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    80004762:	8552                	mv	a0,s4
    80004764:	cd7fe0ef          	jal	8000343a <iunlockput>
    end_op();
    80004768:	d4cff0ef          	jal	80003cb4 <end_op>
    8000476c:	7a1e                	ld	s4,480(sp)
    return -1;
    8000476e:	557d                	li	a0,-1
  }
  return -1;
}
    80004770:	20813083          	ld	ra,520(sp)
    80004774:	20013403          	ld	s0,512(sp)
    80004778:	74fe                	ld	s1,504(sp)
    8000477a:	795e                	ld	s2,496(sp)
    8000477c:	21010113          	addi	sp,sp,528
    80004780:	8082                	ret
    end_op();
    80004782:	d32ff0ef          	jal	80003cb4 <end_op>
    return -1;
    80004786:	b7e5                	j	8000476e <kexec+0x6c>
    80004788:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    8000478a:	8526                	mv	a0,s1
    8000478c:	a58fd0ef          	jal	800019e4 <proc_pagetable>
    80004790:	8b2a                	mv	s6,a0
    80004792:	26050063          	beqz	a0,800049f2 <kexec+0x2f0>
    80004796:	f7ce                	sd	s3,488(sp)
    80004798:	efd6                	sd	s5,472(sp)
    8000479a:	e7de                	sd	s7,456(sp)
    8000479c:	e3e2                	sd	s8,448(sp)
    8000479e:	ff66                	sd	s9,440(sp)
    800047a0:	fb6a                	sd	s10,432(sp)
    800047a2:	f76e                	sd	s11,424(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800047a4:	e8845783          	lhu	a5,-376(s0)
    800047a8:	cff9                	beqz	a5,80004886 <kexec+0x184>
    800047aa:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800047ae:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    800047b0:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800047b2:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    800047b6:	6c85                	lui	s9,0x1
    800047b8:	6a85                	lui	s5,0x1
    800047ba:	a085                	j	8000481a <kexec+0x118>
      panic("loadseg: address should exist");
    800047bc:	00003517          	auipc	a0,0x3
    800047c0:	ea450513          	addi	a0,a0,-348 # 80007660 <etext+0x660>
    800047c4:	876fc0ef          	jal	8000083a <panic>
    if (sz - i < PGSIZE)
    800047c8:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    800047ca:	874a                	mv	a4,s2
    800047cc:	009b86bb          	addw	a3,s7,s1
    800047d0:	4581                	li	a1,0
    800047d2:	8552                	mv	a0,s4
    800047d4:	dedfe0ef          	jal	800035c0 <readi>
    800047d8:	22a91163          	bne	s2,a0,800049fa <kexec+0x2f8>
  for (i = 0; i < sz; i += PGSIZE) {
    800047dc:	009a84bb          	addw	s1,s5,s1
    800047e0:	0334f263          	bgeu	s1,s3,80004804 <kexec+0x102>
    pa = walkaddr(pagetable, va + i);
    800047e4:	02049593          	slli	a1,s1,0x20
    800047e8:	9181                	srli	a1,a1,0x20
    800047ea:	95e2                	add	a1,a1,s8
    800047ec:	855a                	mv	a0,s6
    800047ee:	807fc0ef          	jal	80000ff4 <walkaddr>
    800047f2:	862a                	mv	a2,a0
    if (pa == 0)
    800047f4:	d561                	beqz	a0,800047bc <kexec+0xba>
    if (sz - i < PGSIZE)
    800047f6:	409987bb          	subw	a5,s3,s1
    800047fa:	893e                	mv	s2,a5
    800047fc:	fcfcf6e3          	bgeu	s9,a5,800047c8 <kexec+0xc6>
    80004800:	8956                	mv	s2,s5
    80004802:	b7d9                	j	800047c8 <kexec+0xc6>
    sz = sz1;
    80004804:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004808:	2d05                	addiw	s10,s10,1
    8000480a:	e0843783          	ld	a5,-504(s0)
    8000480e:	0387869b          	addiw	a3,a5,56
    80004812:	e8845783          	lhu	a5,-376(s0)
    80004816:	06fd5963          	bge	s10,a5,80004888 <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000481a:	e0d43423          	sd	a3,-504(s0)
    8000481e:	876e                	mv	a4,s11
    80004820:	e1840613          	addi	a2,s0,-488
    80004824:	4581                	li	a1,0
    80004826:	8552                	mv	a0,s4
    80004828:	d99fe0ef          	jal	800035c0 <readi>
    8000482c:	1db51563          	bne	a0,s11,800049f6 <kexec+0x2f4>
    if (ph.type != ELF_PROG_LOAD)
    80004830:	e1842783          	lw	a5,-488(s0)
    80004834:	4705                	li	a4,1
    80004836:	fce799e3          	bne	a5,a4,80004808 <kexec+0x106>
    if (ph.memsz < ph.filesz)
    8000483a:	e4043483          	ld	s1,-448(s0)
    8000483e:	e3843783          	ld	a5,-456(s0)
    80004842:	1af4ea63          	bltu	s1,a5,800049f6 <kexec+0x2f4>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    80004846:	e2843783          	ld	a5,-472(s0)
    8000484a:	94be                	add	s1,s1,a5
    8000484c:	1af4e563          	bltu	s1,a5,800049f6 <kexec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    80004850:	17d2                	slli	a5,a5,0x34
    80004852:	1a079263          	bnez	a5,800049f6 <kexec+0x2f4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    80004856:	e1c42503          	lw	a0,-484(s0)
    8000485a:	e89ff0ef          	jal	800046e2 <flags2perm>
    8000485e:	86aa                	mv	a3,a0
    80004860:	8626                	mv	a2,s1
    80004862:	85ca                	mv	a1,s2
    80004864:	855a                	mv	a0,s6
    80004866:	a5dfc0ef          	jal	800012c2 <uvmalloc>
    8000486a:	dea43823          	sd	a0,-528(s0)
    8000486e:	18050463          	beqz	a0,800049f6 <kexec+0x2f4>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004872:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004876:	f80987e3          	beqz	s3,80004804 <kexec+0x102>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000487a:	e2843c03          	ld	s8,-472(s0)
    8000487e:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    80004882:	4481                	li	s1,0
    80004884:	b785                	j	800047e4 <kexec+0xe2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004886:	4901                	li	s2,0
  iunlockput(ip);
    80004888:	8552                	mv	a0,s4
    8000488a:	bb1fe0ef          	jal	8000343a <iunlockput>
  end_op();
    8000488e:	c26ff0ef          	jal	80003cb4 <end_op>
  p = myproc();
    80004892:	848fd0ef          	jal	800018da <myproc>
    80004896:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    80004898:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    8000489c:	6485                	lui	s1,0x1
    8000489e:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    800048a0:	94ca                	add	s1,s1,s2
    800048a2:	77fd                	lui	a5,0xfffff
    800048a4:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    800048a6:	4691                	li	a3,4
    800048a8:	6609                	lui	a2,0x2
    800048aa:	9626                	add	a2,a2,s1
    800048ac:	85a6                	mv	a1,s1
    800048ae:	855a                	mv	a0,s6
    800048b0:	a13fc0ef          	jal	800012c2 <uvmalloc>
    800048b4:	8a2a                	mv	s4,a0
    800048b6:	ed19                	bnez	a0,800048d4 <kexec+0x1d2>
    proc_freepagetable(pagetable, sz);
    800048b8:	85a6                	mv	a1,s1
    800048ba:	855a                	mv	a0,s6
    800048bc:	9aafd0ef          	jal	80001a66 <proc_freepagetable>
  if (ip) {
    800048c0:	79be                	ld	s3,488(sp)
    800048c2:	7a1e                	ld	s4,480(sp)
    800048c4:	6afe                	ld	s5,472(sp)
    800048c6:	6b5e                	ld	s6,464(sp)
    800048c8:	6bbe                	ld	s7,456(sp)
    800048ca:	6c1e                	ld	s8,448(sp)
    800048cc:	7cfa                	ld	s9,440(sp)
    800048ce:	7d5a                	ld	s10,432(sp)
    800048d0:	7dba                	ld	s11,424(sp)
    800048d2:	bd71                	j	8000476e <kexec+0x6c>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    800048d4:	75f9                	lui	a1,0xffffe
    800048d6:	95aa                	add	a1,a1,a0
    800048d8:	855a                	mv	a0,s6
    800048da:	bb1fc0ef          	jal	8000148a <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    800048de:	7c7d                	lui	s8,0xfffff
    800048e0:	9c52                	add	s8,s8,s4
  for (argc = 0; argv[argc]; argc++) {
    800048e2:	df843783          	ld	a5,-520(s0)
    800048e6:	6388                	ld	a0,0(a5)
  sp = sz;
    800048e8:	8952                	mv	s2,s4
  for (argc = 0; argv[argc]; argc++) {
    800048ea:	4481                	li	s1,0
    ustack[argc] = sp;
    800048ec:	e9040c93          	addi	s9,s0,-368
    if (argc >= MAXARG)
    800048f0:	02000d13          	li	s10,32
  for (argc = 0; argv[argc]; argc++) {
    800048f4:	cd21                	beqz	a0,8000494c <kexec+0x24a>
    sp -= strlen(argv[argc]) + 1;
    800048f6:	d5efc0ef          	jal	80000e54 <strlen>
    800048fa:	0015079b          	addiw	a5,a0,1
    800048fe:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004902:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    80004906:	05896163          	bltu	s2,s8,80004948 <kexec+0x246>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000490a:	df843d83          	ld	s11,-520(s0)
    8000490e:	000dbb83          	ld	s7,0(s11)
    80004912:	855e                	mv	a0,s7
    80004914:	d40fc0ef          	jal	80000e54 <strlen>
    80004918:	0015069b          	addiw	a3,a0,1
    8000491c:	865e                	mv	a2,s7
    8000491e:	85ca                	mv	a1,s2
    80004920:	855a                	mv	a0,s6
    80004922:	cebfc0ef          	jal	8000160c <copyout>
    80004926:	02054163          	bltz	a0,80004948 <kexec+0x246>
    ustack[argc] = sp;
    8000492a:	00349793          	slli	a5,s1,0x3
    8000492e:	97e6                	add	a5,a5,s9
    80004930:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde108>
  for (argc = 0; argv[argc]; argc++) {
    80004934:	0485                	addi	s1,s1,1
    80004936:	008d8793          	addi	a5,s11,8
    8000493a:	def43c23          	sd	a5,-520(s0)
    8000493e:	008db503          	ld	a0,8(s11)
    80004942:	c509                	beqz	a0,8000494c <kexec+0x24a>
    if (argc >= MAXARG)
    80004944:	fba499e3          	bne	s1,s10,800048f6 <kexec+0x1f4>
  sz = sz1;
    80004948:	84d2                	mv	s1,s4
    8000494a:	b7bd                	j	800048b8 <kexec+0x1b6>
  ustack[argc] = 0;
    8000494c:	00349793          	slli	a5,s1,0x3
    80004950:	f9040713          	addi	a4,s0,-112
    80004954:	97ba                	add	a5,a5,a4
    80004956:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    8000495a:	00148693          	addi	a3,s1,1
    8000495e:	068e                	slli	a3,a3,0x3
    80004960:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004964:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    80004968:	ff8960e3          	bltu	s2,s8,80004948 <kexec+0x246>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    8000496c:	e9040613          	addi	a2,s0,-368
    80004970:	85ca                	mv	a1,s2
    80004972:	855a                	mv	a0,s6
    80004974:	c99fc0ef          	jal	8000160c <copyout>
    80004978:	fc0548e3          	bltz	a0,80004948 <kexec+0x246>
  p->trapframe->a1 = sp;
    8000497c:	0589b783          	ld	a5,88(s3)
    80004980:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    80004984:	e0043783          	ld	a5,-512(s0)
    80004988:	0007c703          	lbu	a4,0(a5)
    8000498c:	cf11                	beqz	a4,800049a8 <kexec+0x2a6>
    8000498e:	0785                	addi	a5,a5,1
    if (*s == '/')
    80004990:	02f00693          	li	a3,47
    80004994:	a029                	j	8000499e <kexec+0x29c>
  for (last = s = path; *s; s++)
    80004996:	0785                	addi	a5,a5,1
    80004998:	fff7c703          	lbu	a4,-1(a5)
    8000499c:	c711                	beqz	a4,800049a8 <kexec+0x2a6>
    if (*s == '/')
    8000499e:	fed71ce3          	bne	a4,a3,80004996 <kexec+0x294>
      last = s + 1;
    800049a2:	e0f43023          	sd	a5,-512(s0)
    800049a6:	bfc5                	j	80004996 <kexec+0x294>
  safestrcpy(p->name, last, sizeof(p->name));
    800049a8:	4641                	li	a2,16
    800049aa:	e0043583          	ld	a1,-512(s0)
    800049ae:	15898513          	addi	a0,s3,344
    800049b2:	c6cfc0ef          	jal	80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    800049b6:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    800049ba:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    800049be:	0549b423          	sd	s4,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    800049c2:	0589b783          	ld	a5,88(s3)
    800049c6:	e6843703          	ld	a4,-408(s0)
    800049ca:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    800049cc:	0589b783          	ld	a5,88(s3)
    800049d0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800049d4:	85d6                	mv	a1,s5
    800049d6:	890fd0ef          	jal	80001a66 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800049da:	0004851b          	sext.w	a0,s1
    800049de:	79be                	ld	s3,488(sp)
    800049e0:	7a1e                	ld	s4,480(sp)
    800049e2:	6afe                	ld	s5,472(sp)
    800049e4:	6b5e                	ld	s6,464(sp)
    800049e6:	6bbe                	ld	s7,456(sp)
    800049e8:	6c1e                	ld	s8,448(sp)
    800049ea:	7cfa                	ld	s9,440(sp)
    800049ec:	7d5a                	ld	s10,432(sp)
    800049ee:	7dba                	ld	s11,424(sp)
    800049f0:	b341                	j	80004770 <kexec+0x6e>
    800049f2:	6b5e                	ld	s6,464(sp)
    800049f4:	b3bd                	j	80004762 <kexec+0x60>
    return -1;
    800049f6:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    800049fa:	df043583          	ld	a1,-528(s0)
    800049fe:	855a                	mv	a0,s6
    80004a00:	866fd0ef          	jal	80001a66 <proc_freepagetable>
  if (ip) {
    80004a04:	79be                	ld	s3,488(sp)
    80004a06:	6afe                	ld	s5,472(sp)
    80004a08:	6b5e                	ld	s6,464(sp)
    80004a0a:	6bbe                	ld	s7,456(sp)
    80004a0c:	6c1e                	ld	s8,448(sp)
    80004a0e:	7cfa                	ld	s9,440(sp)
    80004a10:	7d5a                	ld	s10,432(sp)
    80004a12:	7dba                	ld	s11,424(sp)
    80004a14:	b3b9                	j	80004762 <kexec+0x60>

0000000080004a16 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a16:	7179                	addi	sp,sp,-48
    80004a18:	f406                	sd	ra,40(sp)
    80004a1a:	f022                	sd	s0,32(sp)
    80004a1c:	ec26                	sd	s1,24(sp)
    80004a1e:	e84a                	sd	s2,16(sp)
    80004a20:	1800                	addi	s0,sp,48
    80004a22:	892e                	mv	s2,a1
    80004a24:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a26:	fdc40593          	addi	a1,s0,-36
    80004a2a:	d97fd0ef          	jal	800027c0 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004a2e:	fdc42703          	lw	a4,-36(s0)
    80004a32:	47bd                	li	a5,15
    80004a34:	02e7e963          	bltu	a5,a4,80004a66 <argfd+0x50>
    80004a38:	ea3fc0ef          	jal	800018da <myproc>
    80004a3c:	fdc42703          	lw	a4,-36(s0)
    80004a40:	01a70793          	addi	a5,a4,26
    80004a44:	078e                	slli	a5,a5,0x3
    80004a46:	953e                	add	a0,a0,a5
    80004a48:	611c                	ld	a5,0(a0)
    80004a4a:	cf91                	beqz	a5,80004a66 <argfd+0x50>
    return -1;
  if (pfd)
    80004a4c:	00090463          	beqz	s2,80004a54 <argfd+0x3e>
    *pfd = fd;
    80004a50:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004a54:	c091                	beqz	s1,80004a58 <argfd+0x42>
    *pf = f;
    80004a56:	e09c                	sd	a5,0(s1)
  return 0;
    80004a58:	4501                	li	a0,0
}
    80004a5a:	70a2                	ld	ra,40(sp)
    80004a5c:	7402                	ld	s0,32(sp)
    80004a5e:	64e2                	ld	s1,24(sp)
    80004a60:	6942                	ld	s2,16(sp)
    80004a62:	6145                	addi	sp,sp,48
    80004a64:	8082                	ret
    return -1;
    80004a66:	557d                	li	a0,-1
    80004a68:	bfcd                	j	80004a5a <argfd+0x44>

0000000080004a6a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004a6a:	1101                	addi	sp,sp,-32
    80004a6c:	ec06                	sd	ra,24(sp)
    80004a6e:	e822                	sd	s0,16(sp)
    80004a70:	e426                	sd	s1,8(sp)
    80004a72:	1000                	addi	s0,sp,32
    80004a74:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004a76:	e65fc0ef          	jal	800018da <myproc>
    80004a7a:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004a7c:	0d050793          	addi	a5,a0,208
    80004a80:	4501                	li	a0,0
    80004a82:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004a84:	6398                	ld	a4,0(a5)
    80004a86:	cb19                	beqz	a4,80004a9c <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004a88:	2505                	addiw	a0,a0,1
    80004a8a:	07a1                	addi	a5,a5,8
    80004a8c:	fed51ce3          	bne	a0,a3,80004a84 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004a90:	557d                	li	a0,-1
}
    80004a92:	60e2                	ld	ra,24(sp)
    80004a94:	6442                	ld	s0,16(sp)
    80004a96:	64a2                	ld	s1,8(sp)
    80004a98:	6105                	addi	sp,sp,32
    80004a9a:	8082                	ret
      p->ofile[fd] = f;
    80004a9c:	01a50793          	addi	a5,a0,26
    80004aa0:	078e                	slli	a5,a5,0x3
    80004aa2:	963e                	add	a2,a2,a5
    80004aa4:	e204                	sd	s1,0(a2)
      return fd;
    80004aa6:	b7f5                	j	80004a92 <fdalloc+0x28>

0000000080004aa8 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004aa8:	715d                	addi	sp,sp,-80
    80004aaa:	e486                	sd	ra,72(sp)
    80004aac:	e0a2                	sd	s0,64(sp)
    80004aae:	fc26                	sd	s1,56(sp)
    80004ab0:	f84a                	sd	s2,48(sp)
    80004ab2:	f44e                	sd	s3,40(sp)
    80004ab4:	f052                	sd	s4,32(sp)
    80004ab6:	ec56                	sd	s5,24(sp)
    80004ab8:	e85a                	sd	s6,16(sp)
    80004aba:	0880                	addi	s0,sp,80
    80004abc:	892e                	mv	s2,a1
    80004abe:	8a2e                	mv	s4,a1
    80004ac0:	8ab2                	mv	s5,a2
    80004ac2:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004ac4:	fb040593          	addi	a1,s0,-80
    80004ac8:	fb9fe0ef          	jal	80003a80 <nameiparent>
    80004acc:	84aa                	mv	s1,a0
    return 0;
    80004ace:	89aa                	mv	s3,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004ad0:	cd05                	beqz	a0,80004b08 <create+0x60>

  ilock(dp);
    80004ad2:	f5cfe0ef          	jal	8000322e <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004ad6:	4601                	li	a2,0
    80004ad8:	fb040593          	addi	a1,s0,-80
    80004adc:	8526                	mv	a0,s1
    80004ade:	cedfe0ef          	jal	800037ca <dirlookup>
    80004ae2:	89aa                	mv	s3,a0
    80004ae4:	c131                	beqz	a0,80004b28 <create+0x80>
    iunlockput(dp);
    80004ae6:	8526                	mv	a0,s1
    80004ae8:	953fe0ef          	jal	8000343a <iunlockput>
    ilock(ip);
    80004aec:	854e                	mv	a0,s3
    80004aee:	f40fe0ef          	jal	8000322e <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004af2:	4789                	li	a5,2
    80004af4:	02f91563          	bne	s2,a5,80004b1e <create+0x76>
    80004af8:	0449d783          	lhu	a5,68(s3)
    80004afc:	37f9                	addiw	a5,a5,-2
    80004afe:	17c2                	slli	a5,a5,0x30
    80004b00:	93c1                	srli	a5,a5,0x30
    80004b02:	4705                	li	a4,1
    80004b04:	00f76d63          	bltu	a4,a5,80004b1e <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b08:	854e                	mv	a0,s3
    80004b0a:	60a6                	ld	ra,72(sp)
    80004b0c:	6406                	ld	s0,64(sp)
    80004b0e:	74e2                	ld	s1,56(sp)
    80004b10:	7942                	ld	s2,48(sp)
    80004b12:	79a2                	ld	s3,40(sp)
    80004b14:	7a02                	ld	s4,32(sp)
    80004b16:	6ae2                	ld	s5,24(sp)
    80004b18:	6b42                	ld	s6,16(sp)
    80004b1a:	6161                	addi	sp,sp,80
    80004b1c:	8082                	ret
    iunlockput(ip);
    80004b1e:	854e                	mv	a0,s3
    80004b20:	91bfe0ef          	jal	8000343a <iunlockput>
    return 0;
    80004b24:	4981                	li	s3,0
    80004b26:	b7cd                	j	80004b08 <create+0x60>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004b28:	85ca                	mv	a1,s2
    80004b2a:	4088                	lw	a0,0(s1)
    80004b2c:	d92fe0ef          	jal	800030be <ialloc>
    80004b30:	892a                	mv	s2,a0
    80004b32:	cd15                	beqz	a0,80004b6e <create+0xc6>
  ilock(ip);
    80004b34:	efafe0ef          	jal	8000322e <ilock>
  ip->major = major;
    80004b38:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004b3c:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004b40:	4785                	li	a5,1
    80004b42:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b46:	854a                	mv	a0,s2
    80004b48:	e32fe0ef          	jal	8000317a <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004b4c:	4705                	li	a4,1
    80004b4e:	02ea0463          	beq	s4,a4,80004b76 <create+0xce>
  if (dirlink(dp, name, ip->inum) < 0)
    80004b52:	00492603          	lw	a2,4(s2)
    80004b56:	fb040593          	addi	a1,s0,-80
    80004b5a:	8526                	mv	a0,s1
    80004b5c:	e61fe0ef          	jal	800039bc <dirlink>
    80004b60:	06054263          	bltz	a0,80004bc4 <create+0x11c>
  iunlockput(dp);
    80004b64:	8526                	mv	a0,s1
    80004b66:	8d5fe0ef          	jal	8000343a <iunlockput>
    return 0;
    80004b6a:	89ca                	mv	s3,s2
    80004b6c:	bf71                	j	80004b08 <create+0x60>
    iunlockput(dp);
    80004b6e:	8526                	mv	a0,s1
    80004b70:	8cbfe0ef          	jal	8000343a <iunlockput>
    return 0;
    80004b74:	bfdd                	j	80004b6a <create+0xc2>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004b76:	00492603          	lw	a2,4(s2)
    80004b7a:	00003597          	auipc	a1,0x3
    80004b7e:	b0658593          	addi	a1,a1,-1274 # 80007680 <etext+0x680>
    80004b82:	854a                	mv	a0,s2
    80004b84:	e39fe0ef          	jal	800039bc <dirlink>
    80004b88:	02054e63          	bltz	a0,80004bc4 <create+0x11c>
    80004b8c:	40d0                	lw	a2,4(s1)
    80004b8e:	00003597          	auipc	a1,0x3
    80004b92:	afa58593          	addi	a1,a1,-1286 # 80007688 <etext+0x688>
    80004b96:	854a                	mv	a0,s2
    80004b98:	e25fe0ef          	jal	800039bc <dirlink>
    80004b9c:	02054463          	bltz	a0,80004bc4 <create+0x11c>
  if (dirlink(dp, name, ip->inum) < 0)
    80004ba0:	00492603          	lw	a2,4(s2)
    80004ba4:	fb040593          	addi	a1,s0,-80
    80004ba8:	8526                	mv	a0,s1
    80004baa:	e13fe0ef          	jal	800039bc <dirlink>
    80004bae:	00054b63          	bltz	a0,80004bc4 <create+0x11c>
    dp->nlink++; // for ".."
    80004bb2:	04a4d783          	lhu	a5,74(s1)
    80004bb6:	2785                	addiw	a5,a5,1
    80004bb8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	dbcfe0ef          	jal	8000317a <iupdate>
    80004bc2:	b74d                	j	80004b64 <create+0xbc>
  ip->nlink = 0;
    80004bc4:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004bc8:	854a                	mv	a0,s2
    80004bca:	db0fe0ef          	jal	8000317a <iupdate>
  iunlockput(ip);
    80004bce:	854a                	mv	a0,s2
    80004bd0:	86bfe0ef          	jal	8000343a <iunlockput>
  iunlockput(dp);
    80004bd4:	8526                	mv	a0,s1
    80004bd6:	865fe0ef          	jal	8000343a <iunlockput>
  return 0;
    80004bda:	b73d                	j	80004b08 <create+0x60>

0000000080004bdc <sys_dup>:
{
    80004bdc:	7179                	addi	sp,sp,-48
    80004bde:	f406                	sd	ra,40(sp)
    80004be0:	f022                	sd	s0,32(sp)
    80004be2:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004be4:	fd840613          	addi	a2,s0,-40
    80004be8:	4581                	li	a1,0
    80004bea:	4501                	li	a0,0
    80004bec:	e2bff0ef          	jal	80004a16 <argfd>
    80004bf0:	02054863          	bltz	a0,80004c20 <sys_dup+0x44>
    80004bf4:	ec26                	sd	s1,24(sp)
    80004bf6:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004bf8:	fd843483          	ld	s1,-40(s0)
    80004bfc:	8526                	mv	a0,s1
    80004bfe:	e6dff0ef          	jal	80004a6a <fdalloc>
    80004c02:	892a                	mv	s2,a0
    80004c04:	00054c63          	bltz	a0,80004c1c <sys_dup+0x40>
  filedup(f);
    80004c08:	8526                	mv	a0,s1
    80004c0a:	c72ff0ef          	jal	8000407c <filedup>
  return fd;
    80004c0e:	854a                	mv	a0,s2
    80004c10:	64e2                	ld	s1,24(sp)
    80004c12:	6942                	ld	s2,16(sp)
}
    80004c14:	70a2                	ld	ra,40(sp)
    80004c16:	7402                	ld	s0,32(sp)
    80004c18:	6145                	addi	sp,sp,48
    80004c1a:	8082                	ret
    80004c1c:	64e2                	ld	s1,24(sp)
    80004c1e:	6942                	ld	s2,16(sp)
    return -1;
    80004c20:	557d                	li	a0,-1
    80004c22:	bfcd                	j	80004c14 <sys_dup+0x38>

0000000080004c24 <sys_read>:
{
    80004c24:	7179                	addi	sp,sp,-48
    80004c26:	f406                	sd	ra,40(sp)
    80004c28:	f022                	sd	s0,32(sp)
    80004c2a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c2c:	fd840593          	addi	a1,s0,-40
    80004c30:	4505                	li	a0,1
    80004c32:	babfd0ef          	jal	800027dc <argaddr>
  argint(2, &n);
    80004c36:	fe440593          	addi	a1,s0,-28
    80004c3a:	4509                	li	a0,2
    80004c3c:	b85fd0ef          	jal	800027c0 <argint>
  if (argfd(0, 0, &f) < 0)
    80004c40:	fe840613          	addi	a2,s0,-24
    80004c44:	4581                	li	a1,0
    80004c46:	4501                	li	a0,0
    80004c48:	dcfff0ef          	jal	80004a16 <argfd>
    80004c4c:	87aa                	mv	a5,a0
    return -1;
    80004c4e:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004c50:	0007ca63          	bltz	a5,80004c64 <sys_read+0x40>
  return fileread(f, p, n);
    80004c54:	fe442603          	lw	a2,-28(s0)
    80004c58:	fd843583          	ld	a1,-40(s0)
    80004c5c:	fe843503          	ld	a0,-24(s0)
    80004c60:	d86ff0ef          	jal	800041e6 <fileread>
}
    80004c64:	70a2                	ld	ra,40(sp)
    80004c66:	7402                	ld	s0,32(sp)
    80004c68:	6145                	addi	sp,sp,48
    80004c6a:	8082                	ret

0000000080004c6c <sys_write>:
{
    80004c6c:	7179                	addi	sp,sp,-48
    80004c6e:	f406                	sd	ra,40(sp)
    80004c70:	f022                	sd	s0,32(sp)
    80004c72:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c74:	fd840593          	addi	a1,s0,-40
    80004c78:	4505                	li	a0,1
    80004c7a:	b63fd0ef          	jal	800027dc <argaddr>
  argint(2, &n);
    80004c7e:	fe440593          	addi	a1,s0,-28
    80004c82:	4509                	li	a0,2
    80004c84:	b3dfd0ef          	jal	800027c0 <argint>
  if (argfd(0, 0, &f) < 0)
    80004c88:	fe840613          	addi	a2,s0,-24
    80004c8c:	4581                	li	a1,0
    80004c8e:	4501                	li	a0,0
    80004c90:	d87ff0ef          	jal	80004a16 <argfd>
    80004c94:	87aa                	mv	a5,a0
    return -1;
    80004c96:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004c98:	0007ca63          	bltz	a5,80004cac <sys_write+0x40>
  return filewrite(f, p, n);
    80004c9c:	fe442603          	lw	a2,-28(s0)
    80004ca0:	fd843583          	ld	a1,-40(s0)
    80004ca4:	fe843503          	ld	a0,-24(s0)
    80004ca8:	df8ff0ef          	jal	800042a0 <filewrite>
}
    80004cac:	70a2                	ld	ra,40(sp)
    80004cae:	7402                	ld	s0,32(sp)
    80004cb0:	6145                	addi	sp,sp,48
    80004cb2:	8082                	ret

0000000080004cb4 <sys_close>:
{
    80004cb4:	1101                	addi	sp,sp,-32
    80004cb6:	ec06                	sd	ra,24(sp)
    80004cb8:	e822                	sd	s0,16(sp)
    80004cba:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004cbc:	fe040613          	addi	a2,s0,-32
    80004cc0:	fec40593          	addi	a1,s0,-20
    80004cc4:	4501                	li	a0,0
    80004cc6:	d51ff0ef          	jal	80004a16 <argfd>
    return -1;
    80004cca:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004ccc:	02054063          	bltz	a0,80004cec <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004cd0:	c0bfc0ef          	jal	800018da <myproc>
    80004cd4:	fec42783          	lw	a5,-20(s0)
    80004cd8:	07e9                	addi	a5,a5,26
    80004cda:	078e                	slli	a5,a5,0x3
    80004cdc:	953e                	add	a0,a0,a5
    80004cde:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004ce2:	fe043503          	ld	a0,-32(s0)
    80004ce6:	bdcff0ef          	jal	800040c2 <fileclose>
  return 0;
    80004cea:	4781                	li	a5,0
}
    80004cec:	853e                	mv	a0,a5
    80004cee:	60e2                	ld	ra,24(sp)
    80004cf0:	6442                	ld	s0,16(sp)
    80004cf2:	6105                	addi	sp,sp,32
    80004cf4:	8082                	ret

0000000080004cf6 <sys_fstat>:
{
    80004cf6:	1101                	addi	sp,sp,-32
    80004cf8:	ec06                	sd	ra,24(sp)
    80004cfa:	e822                	sd	s0,16(sp)
    80004cfc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004cfe:	fe040593          	addi	a1,s0,-32
    80004d02:	4505                	li	a0,1
    80004d04:	ad9fd0ef          	jal	800027dc <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004d08:	fe840613          	addi	a2,s0,-24
    80004d0c:	4581                	li	a1,0
    80004d0e:	4501                	li	a0,0
    80004d10:	d07ff0ef          	jal	80004a16 <argfd>
    80004d14:	87aa                	mv	a5,a0
    return -1;
    80004d16:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d18:	0007c863          	bltz	a5,80004d28 <sys_fstat+0x32>
  return filestat(f, st);
    80004d1c:	fe043583          	ld	a1,-32(s0)
    80004d20:	fe843503          	ld	a0,-24(s0)
    80004d24:	c60ff0ef          	jal	80004184 <filestat>
}
    80004d28:	60e2                	ld	ra,24(sp)
    80004d2a:	6442                	ld	s0,16(sp)
    80004d2c:	6105                	addi	sp,sp,32
    80004d2e:	8082                	ret

0000000080004d30 <sys_link>:
{
    80004d30:	7169                	addi	sp,sp,-304
    80004d32:	f606                	sd	ra,296(sp)
    80004d34:	f222                	sd	s0,288(sp)
    80004d36:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d38:	08000613          	li	a2,128
    80004d3c:	ed040593          	addi	a1,s0,-304
    80004d40:	4501                	li	a0,0
    80004d42:	ab7fd0ef          	jal	800027f8 <argstr>
    80004d46:	0c054a63          	bltz	a0,80004e1a <sys_link+0xea>
    80004d4a:	08000613          	li	a2,128
    80004d4e:	f5040593          	addi	a1,s0,-176
    80004d52:	4505                	li	a0,1
    80004d54:	aa5fd0ef          	jal	800027f8 <argstr>
    80004d58:	0c054163          	bltz	a0,80004e1a <sys_link+0xea>
    80004d5c:	ee26                	sd	s1,280(sp)
  begin_op();
    80004d5e:	ee7fe0ef          	jal	80003c44 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004d62:	ed040513          	addi	a0,s0,-304
    80004d66:	d01fe0ef          	jal	80003a66 <namei>
    80004d6a:	84aa                	mv	s1,a0
    80004d6c:	c53d                	beqz	a0,80004dda <sys_link+0xaa>
  ilock(ip);
    80004d6e:	cc0fe0ef          	jal	8000322e <ilock>
  if (ip->type == T_DIR) {
    80004d72:	04449703          	lh	a4,68(s1)
    80004d76:	4785                	li	a5,1
    80004d78:	06f70563          	beq	a4,a5,80004de2 <sys_link+0xb2>
    80004d7c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004d7e:	04a4d783          	lhu	a5,74(s1)
    80004d82:	2785                	addiw	a5,a5,1
    80004d84:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004d88:	8526                	mv	a0,s1
    80004d8a:	bf0fe0ef          	jal	8000317a <iupdate>
  iunlock(ip);
    80004d8e:	8526                	mv	a0,s1
    80004d90:	d4cfe0ef          	jal	800032dc <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004d94:	fd040593          	addi	a1,s0,-48
    80004d98:	f5040513          	addi	a0,s0,-176
    80004d9c:	ce5fe0ef          	jal	80003a80 <nameiparent>
    80004da0:	892a                	mv	s2,a0
    80004da2:	c931                	beqz	a0,80004df6 <sys_link+0xc6>
  ilock(dp);
    80004da4:	c8afe0ef          	jal	8000322e <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004da8:	854a                	mv	a0,s2
    80004daa:	00092703          	lw	a4,0(s2)
    80004dae:	409c                	lw	a5,0(s1)
    80004db0:	04f71063          	bne	a4,a5,80004df0 <sys_link+0xc0>
    80004db4:	40d0                	lw	a2,4(s1)
    80004db6:	fd040593          	addi	a1,s0,-48
    80004dba:	c03fe0ef          	jal	800039bc <dirlink>
    80004dbe:	02054963          	bltz	a0,80004df0 <sys_link+0xc0>
  iunlockput(dp);
    80004dc2:	854a                	mv	a0,s2
    80004dc4:	e76fe0ef          	jal	8000343a <iunlockput>
  iput(ip);
    80004dc8:	8526                	mv	a0,s1
    80004dca:	de6fe0ef          	jal	800033b0 <iput>
  end_op();
    80004dce:	ee7fe0ef          	jal	80003cb4 <end_op>
  return 0;
    80004dd2:	4501                	li	a0,0
    80004dd4:	64f2                	ld	s1,280(sp)
    80004dd6:	6952                	ld	s2,272(sp)
    80004dd8:	a091                	j	80004e1c <sys_link+0xec>
    end_op();
    80004dda:	edbfe0ef          	jal	80003cb4 <end_op>
    return -1;
    80004dde:	64f2                	ld	s1,280(sp)
    80004de0:	a82d                	j	80004e1a <sys_link+0xea>
    iunlockput(ip);
    80004de2:	8526                	mv	a0,s1
    80004de4:	e56fe0ef          	jal	8000343a <iunlockput>
    end_op();
    80004de8:	ecdfe0ef          	jal	80003cb4 <end_op>
    return -1;
    80004dec:	64f2                	ld	s1,280(sp)
    80004dee:	a035                	j	80004e1a <sys_link+0xea>
    iunlockput(dp);
    80004df0:	854a                	mv	a0,s2
    80004df2:	e48fe0ef          	jal	8000343a <iunlockput>
  ilock(ip);
    80004df6:	8526                	mv	a0,s1
    80004df8:	c36fe0ef          	jal	8000322e <ilock>
  ip->nlink--;
    80004dfc:	04a4d783          	lhu	a5,74(s1)
    80004e00:	37fd                	addiw	a5,a5,-1
    80004e02:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e06:	8526                	mv	a0,s1
    80004e08:	b72fe0ef          	jal	8000317a <iupdate>
  iunlockput(ip);
    80004e0c:	8526                	mv	a0,s1
    80004e0e:	e2cfe0ef          	jal	8000343a <iunlockput>
  end_op();
    80004e12:	ea3fe0ef          	jal	80003cb4 <end_op>
  return -1;
    80004e16:	64f2                	ld	s1,280(sp)
    80004e18:	6952                	ld	s2,272(sp)
    return -1;
    80004e1a:	557d                	li	a0,-1
}
    80004e1c:	70b2                	ld	ra,296(sp)
    80004e1e:	7412                	ld	s0,288(sp)
    80004e20:	6155                	addi	sp,sp,304
    80004e22:	8082                	ret

0000000080004e24 <sys_unlink>:
{
    80004e24:	7151                	addi	sp,sp,-240
    80004e26:	f586                	sd	ra,232(sp)
    80004e28:	f1a2                	sd	s0,224(sp)
    80004e2a:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004e2c:	08000613          	li	a2,128
    80004e30:	f3040593          	addi	a1,s0,-208
    80004e34:	4501                	li	a0,0
    80004e36:	9c3fd0ef          	jal	800027f8 <argstr>
    80004e3a:	14054763          	bltz	a0,80004f88 <sys_unlink+0x164>
    80004e3e:	eda6                	sd	s1,216(sp)
  begin_op();
    80004e40:	e05fe0ef          	jal	80003c44 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004e44:	fb040593          	addi	a1,s0,-80
    80004e48:	f3040513          	addi	a0,s0,-208
    80004e4c:	c35fe0ef          	jal	80003a80 <nameiparent>
    80004e50:	84aa                	mv	s1,a0
    80004e52:	c955                	beqz	a0,80004f06 <sys_unlink+0xe2>
  ilock(dp);
    80004e54:	bdafe0ef          	jal	8000322e <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004e58:	00003597          	auipc	a1,0x3
    80004e5c:	82858593          	addi	a1,a1,-2008 # 80007680 <etext+0x680>
    80004e60:	fb040513          	addi	a0,s0,-80
    80004e64:	951fe0ef          	jal	800037b4 <namecmp>
    80004e68:	10050a63          	beqz	a0,80004f7c <sys_unlink+0x158>
    80004e6c:	00003597          	auipc	a1,0x3
    80004e70:	81c58593          	addi	a1,a1,-2020 # 80007688 <etext+0x688>
    80004e74:	fb040513          	addi	a0,s0,-80
    80004e78:	93dfe0ef          	jal	800037b4 <namecmp>
    80004e7c:	10050063          	beqz	a0,80004f7c <sys_unlink+0x158>
    80004e80:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004e82:	f2c40613          	addi	a2,s0,-212
    80004e86:	fb040593          	addi	a1,s0,-80
    80004e8a:	8526                	mv	a0,s1
    80004e8c:	93ffe0ef          	jal	800037ca <dirlookup>
    80004e90:	892a                	mv	s2,a0
    80004e92:	0e050463          	beqz	a0,80004f7a <sys_unlink+0x156>
    80004e96:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004e98:	b96fe0ef          	jal	8000322e <ilock>
  if (ip->nlink < 1)
    80004e9c:	04a91783          	lh	a5,74(s2)
    80004ea0:	06f05763          	blez	a5,80004f0e <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004ea4:	04491703          	lh	a4,68(s2)
    80004ea8:	4785                	li	a5,1
    80004eaa:	06f70863          	beq	a4,a5,80004f1a <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004eae:	fc040993          	addi	s3,s0,-64
    80004eb2:	4641                	li	a2,16
    80004eb4:	4581                	li	a1,0
    80004eb6:	854e                	mv	a0,s3
    80004eb8:	e1dfb0ef          	jal	80000cd4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ebc:	4741                	li	a4,16
    80004ebe:	f2c42683          	lw	a3,-212(s0)
    80004ec2:	864e                	mv	a2,s3
    80004ec4:	4581                	li	a1,0
    80004ec6:	8526                	mv	a0,s1
    80004ec8:	feafe0ef          	jal	800036b2 <writei>
    80004ecc:	47c1                	li	a5,16
    80004ece:	08f51763          	bne	a0,a5,80004f5c <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    80004ed2:	04491703          	lh	a4,68(s2)
    80004ed6:	4785                	li	a5,1
    80004ed8:	08f70863          	beq	a4,a5,80004f68 <sys_unlink+0x144>
  iunlockput(dp);
    80004edc:	8526                	mv	a0,s1
    80004ede:	d5cfe0ef          	jal	8000343a <iunlockput>
  ip->nlink--;
    80004ee2:	04a95783          	lhu	a5,74(s2)
    80004ee6:	37fd                	addiw	a5,a5,-1
    80004ee8:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004eec:	854a                	mv	a0,s2
    80004eee:	a8cfe0ef          	jal	8000317a <iupdate>
  iunlockput(ip);
    80004ef2:	854a                	mv	a0,s2
    80004ef4:	d46fe0ef          	jal	8000343a <iunlockput>
  end_op();
    80004ef8:	dbdfe0ef          	jal	80003cb4 <end_op>
  return 0;
    80004efc:	4501                	li	a0,0
    80004efe:	64ee                	ld	s1,216(sp)
    80004f00:	694e                	ld	s2,208(sp)
    80004f02:	69ae                	ld	s3,200(sp)
    80004f04:	a059                	j	80004f8a <sys_unlink+0x166>
    end_op();
    80004f06:	daffe0ef          	jal	80003cb4 <end_op>
    return -1;
    80004f0a:	64ee                	ld	s1,216(sp)
    80004f0c:	a8b5                	j	80004f88 <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    80004f0e:	00002517          	auipc	a0,0x2
    80004f12:	78250513          	addi	a0,a0,1922 # 80007690 <etext+0x690>
    80004f16:	925fb0ef          	jal	8000083a <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004f1a:	04c92703          	lw	a4,76(s2)
    80004f1e:	02000793          	li	a5,32
    80004f22:	f8e7f6e3          	bgeu	a5,a4,80004eae <sys_unlink+0x8a>
    80004f26:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f28:	4741                	li	a4,16
    80004f2a:	86ce                	mv	a3,s3
    80004f2c:	f1840613          	addi	a2,s0,-232
    80004f30:	4581                	li	a1,0
    80004f32:	854a                	mv	a0,s2
    80004f34:	e8cfe0ef          	jal	800035c0 <readi>
    80004f38:	47c1                	li	a5,16
    80004f3a:	00f51b63          	bne	a0,a5,80004f50 <sys_unlink+0x12c>
    if (de.inum != 0)
    80004f3e:	f1845783          	lhu	a5,-232(s0)
    80004f42:	eba1                	bnez	a5,80004f92 <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004f44:	29c1                	addiw	s3,s3,16
    80004f46:	04c92783          	lw	a5,76(s2)
    80004f4a:	fcf9efe3          	bltu	s3,a5,80004f28 <sys_unlink+0x104>
    80004f4e:	b785                	j	80004eae <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004f50:	00002517          	auipc	a0,0x2
    80004f54:	75850513          	addi	a0,a0,1880 # 800076a8 <etext+0x6a8>
    80004f58:	8e3fb0ef          	jal	8000083a <panic>
    panic("unlink: writei");
    80004f5c:	00002517          	auipc	a0,0x2
    80004f60:	76450513          	addi	a0,a0,1892 # 800076c0 <etext+0x6c0>
    80004f64:	8d7fb0ef          	jal	8000083a <panic>
    dp->nlink--;
    80004f68:	04a4d783          	lhu	a5,74(s1)
    80004f6c:	37fd                	addiw	a5,a5,-1
    80004f6e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004f72:	8526                	mv	a0,s1
    80004f74:	a06fe0ef          	jal	8000317a <iupdate>
    80004f78:	b795                	j	80004edc <sys_unlink+0xb8>
    80004f7a:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004f7c:	8526                	mv	a0,s1
    80004f7e:	cbcfe0ef          	jal	8000343a <iunlockput>
  end_op();
    80004f82:	d33fe0ef          	jal	80003cb4 <end_op>
  return -1;
    80004f86:	64ee                	ld	s1,216(sp)
    return -1;
    80004f88:	557d                	li	a0,-1
}
    80004f8a:	70ae                	ld	ra,232(sp)
    80004f8c:	740e                	ld	s0,224(sp)
    80004f8e:	616d                	addi	sp,sp,240
    80004f90:	8082                	ret
    iunlockput(ip);
    80004f92:	854a                	mv	a0,s2
    80004f94:	ca6fe0ef          	jal	8000343a <iunlockput>
    goto bad;
    80004f98:	694e                	ld	s2,208(sp)
    80004f9a:	69ae                	ld	s3,200(sp)
    80004f9c:	b7c5                	j	80004f7c <sys_unlink+0x158>

0000000080004f9e <sys_open>:

uint64
sys_open(void)
{
    80004f9e:	7131                	addi	sp,sp,-192
    80004fa0:	fd06                	sd	ra,184(sp)
    80004fa2:	f922                	sd	s0,176(sp)
    80004fa4:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004fa6:	f4c40593          	addi	a1,s0,-180
    80004faa:	4505                	li	a0,1
    80004fac:	815fd0ef          	jal	800027c0 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    80004fb0:	08000613          	li	a2,128
    80004fb4:	f5040593          	addi	a1,s0,-176
    80004fb8:	4501                	li	a0,0
    80004fba:	83ffd0ef          	jal	800027f8 <argstr>
    80004fbe:	10054563          	bltz	a0,800050c8 <sys_open+0x12a>
    80004fc2:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    80004fc4:	c81fe0ef          	jal	80003c44 <begin_op>

  if (omode & O_CREATE) {
    80004fc8:	f4c42783          	lw	a5,-180(s0)
    80004fcc:	2007f793          	andi	a5,a5,512
    80004fd0:	cfd9                	beqz	a5,8000506e <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    80004fd2:	4681                	li	a3,0
    80004fd4:	4601                	li	a2,0
    80004fd6:	4589                	li	a1,2
    80004fd8:	f5040513          	addi	a0,s0,-176
    80004fdc:	acdff0ef          	jal	80004aa8 <create>
    80004fe0:	84aa                	mv	s1,a0
    if (ip == 0) {
    80004fe2:	c151                	beqz	a0,80005066 <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80004fe4:	04449703          	lh	a4,68(s1)
    80004fe8:	478d                	li	a5,3
    80004fea:	00f71763          	bne	a4,a5,80004ff8 <sys_open+0x5a>
    80004fee:	0464d703          	lhu	a4,70(s1)
    80004ff2:	47a5                	li	a5,9
    80004ff4:	0ae7e863          	bltu	a5,a4,800050a4 <sys_open+0x106>
    80004ff8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80004ffa:	824ff0ef          	jal	8000401e <filealloc>
    80004ffe:	892a                	mv	s2,a0
    80005000:	cd4d                	beqz	a0,800050ba <sys_open+0x11c>
    80005002:	ed4e                	sd	s3,152(sp)
    80005004:	a67ff0ef          	jal	80004a6a <fdalloc>
    80005008:	89aa                	mv	s3,a0
    8000500a:	0a054463          	bltz	a0,800050b2 <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000500e:	04449703          	lh	a4,68(s1)
    80005012:	478d                	li	a5,3
    80005014:	0af70f63          	beq	a4,a5,800050d2 <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005018:	4789                	li	a5,2
    8000501a:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000501e:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80005022:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005026:	f4c42783          	lw	a5,-180(s0)
    8000502a:	0017f713          	andi	a4,a5,1
    8000502e:	00174713          	xori	a4,a4,1
    80005032:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005036:	0037f713          	andi	a4,a5,3
    8000503a:	00e03733          	snez	a4,a4
    8000503e:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    80005042:	4007f793          	andi	a5,a5,1024
    80005046:	c791                	beqz	a5,80005052 <sys_open+0xb4>
    80005048:	04449703          	lh	a4,68(s1)
    8000504c:	4789                	li	a5,2
    8000504e:	08f70963          	beq	a4,a5,800050e0 <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    80005052:	8526                	mv	a0,s1
    80005054:	a88fe0ef          	jal	800032dc <iunlock>
  end_op();
    80005058:	c5dfe0ef          	jal	80003cb4 <end_op>

  return fd;
    8000505c:	854e                	mv	a0,s3
    8000505e:	74aa                	ld	s1,168(sp)
    80005060:	790a                	ld	s2,160(sp)
    80005062:	69ea                	ld	s3,152(sp)
    80005064:	a09d                	j	800050ca <sys_open+0x12c>
      end_op();
    80005066:	c4ffe0ef          	jal	80003cb4 <end_op>
      return -1;
    8000506a:	74aa                	ld	s1,168(sp)
    8000506c:	a8b1                	j	800050c8 <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    8000506e:	f5040513          	addi	a0,s0,-176
    80005072:	9f5fe0ef          	jal	80003a66 <namei>
    80005076:	84aa                	mv	s1,a0
    80005078:	c115                	beqz	a0,8000509c <sys_open+0xfe>
    ilock(ip);
    8000507a:	9b4fe0ef          	jal	8000322e <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    8000507e:	04449703          	lh	a4,68(s1)
    80005082:	4785                	li	a5,1
    80005084:	f6f710e3          	bne	a4,a5,80004fe4 <sys_open+0x46>
    80005088:	f4c42783          	lw	a5,-180(s0)
    8000508c:	d7b5                	beqz	a5,80004ff8 <sys_open+0x5a>
      iunlockput(ip);
    8000508e:	8526                	mv	a0,s1
    80005090:	baafe0ef          	jal	8000343a <iunlockput>
      end_op();
    80005094:	c21fe0ef          	jal	80003cb4 <end_op>
      return -1;
    80005098:	74aa                	ld	s1,168(sp)
    8000509a:	a03d                	j	800050c8 <sys_open+0x12a>
      end_op();
    8000509c:	c19fe0ef          	jal	80003cb4 <end_op>
      return -1;
    800050a0:	74aa                	ld	s1,168(sp)
    800050a2:	a01d                	j	800050c8 <sys_open+0x12a>
    iunlockput(ip);
    800050a4:	8526                	mv	a0,s1
    800050a6:	b94fe0ef          	jal	8000343a <iunlockput>
    end_op();
    800050aa:	c0bfe0ef          	jal	80003cb4 <end_op>
    return -1;
    800050ae:	74aa                	ld	s1,168(sp)
    800050b0:	a821                	j	800050c8 <sys_open+0x12a>
      fileclose(f);
    800050b2:	854a                	mv	a0,s2
    800050b4:	80eff0ef          	jal	800040c2 <fileclose>
    800050b8:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800050ba:	8526                	mv	a0,s1
    800050bc:	b7efe0ef          	jal	8000343a <iunlockput>
    end_op();
    800050c0:	bf5fe0ef          	jal	80003cb4 <end_op>
    return -1;
    800050c4:	74aa                	ld	s1,168(sp)
    800050c6:	790a                	ld	s2,160(sp)
    return -1;
    800050c8:	557d                	li	a0,-1
}
    800050ca:	70ea                	ld	ra,184(sp)
    800050cc:	744a                	ld	s0,176(sp)
    800050ce:	6129                	addi	sp,sp,192
    800050d0:	8082                	ret
    f->type = FD_DEVICE;
    800050d2:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800050d6:	04649783          	lh	a5,70(s1)
    800050da:	02f91223          	sh	a5,36(s2)
    800050de:	b791                	j	80005022 <sys_open+0x84>
    itrunc(ip);
    800050e0:	8526                	mv	a0,s1
    800050e2:	a3afe0ef          	jal	8000331c <itrunc>
    800050e6:	b7b5                	j	80005052 <sys_open+0xb4>

00000000800050e8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800050e8:	7175                	addi	sp,sp,-144
    800050ea:	e506                	sd	ra,136(sp)
    800050ec:	e122                	sd	s0,128(sp)
    800050ee:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800050f0:	b55fe0ef          	jal	80003c44 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    800050f4:	08000613          	li	a2,128
    800050f8:	f7040593          	addi	a1,s0,-144
    800050fc:	4501                	li	a0,0
    800050fe:	efafd0ef          	jal	800027f8 <argstr>
    80005102:	02054363          	bltz	a0,80005128 <sys_mkdir+0x40>
    80005106:	4681                	li	a3,0
    80005108:	4601                	li	a2,0
    8000510a:	4585                	li	a1,1
    8000510c:	f7040513          	addi	a0,s0,-144
    80005110:	999ff0ef          	jal	80004aa8 <create>
    80005114:	c911                	beqz	a0,80005128 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005116:	b24fe0ef          	jal	8000343a <iunlockput>
  end_op();
    8000511a:	b9bfe0ef          	jal	80003cb4 <end_op>
  return 0;
    8000511e:	4501                	li	a0,0
}
    80005120:	60aa                	ld	ra,136(sp)
    80005122:	640a                	ld	s0,128(sp)
    80005124:	6149                	addi	sp,sp,144
    80005126:	8082                	ret
    end_op();
    80005128:	b8dfe0ef          	jal	80003cb4 <end_op>
    return -1;
    8000512c:	557d                	li	a0,-1
    8000512e:	bfcd                	j	80005120 <sys_mkdir+0x38>

0000000080005130 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005130:	7135                	addi	sp,sp,-160
    80005132:	ed06                	sd	ra,152(sp)
    80005134:	e922                	sd	s0,144(sp)
    80005136:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005138:	b0dfe0ef          	jal	80003c44 <begin_op>
  argint(1, &major);
    8000513c:	f6c40593          	addi	a1,s0,-148
    80005140:	4505                	li	a0,1
    80005142:	e7efd0ef          	jal	800027c0 <argint>
  argint(2, &minor);
    80005146:	f6840593          	addi	a1,s0,-152
    8000514a:	4509                	li	a0,2
    8000514c:	e74fd0ef          	jal	800027c0 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005150:	08000613          	li	a2,128
    80005154:	f7040593          	addi	a1,s0,-144
    80005158:	4501                	li	a0,0
    8000515a:	e9efd0ef          	jal	800027f8 <argstr>
    8000515e:	02054563          	bltz	a0,80005188 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    80005162:	f6841683          	lh	a3,-152(s0)
    80005166:	f6c41603          	lh	a2,-148(s0)
    8000516a:	458d                	li	a1,3
    8000516c:	f7040513          	addi	a0,s0,-144
    80005170:	939ff0ef          	jal	80004aa8 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    80005174:	c911                	beqz	a0,80005188 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005176:	ac4fe0ef          	jal	8000343a <iunlockput>
  end_op();
    8000517a:	b3bfe0ef          	jal	80003cb4 <end_op>
  return 0;
    8000517e:	4501                	li	a0,0
}
    80005180:	60ea                	ld	ra,152(sp)
    80005182:	644a                	ld	s0,144(sp)
    80005184:	610d                	addi	sp,sp,160
    80005186:	8082                	ret
    end_op();
    80005188:	b2dfe0ef          	jal	80003cb4 <end_op>
    return -1;
    8000518c:	557d                	li	a0,-1
    8000518e:	bfcd                	j	80005180 <sys_mknod+0x50>

0000000080005190 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005190:	7135                	addi	sp,sp,-160
    80005192:	ed06                	sd	ra,152(sp)
    80005194:	e922                	sd	s0,144(sp)
    80005196:	e14a                	sd	s2,128(sp)
    80005198:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000519a:	f40fc0ef          	jal	800018da <myproc>
    8000519e:	892a                	mv	s2,a0

  begin_op();
    800051a0:	aa5fe0ef          	jal	80003c44 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    800051a4:	08000613          	li	a2,128
    800051a8:	f6040593          	addi	a1,s0,-160
    800051ac:	4501                	li	a0,0
    800051ae:	e4afd0ef          	jal	800027f8 <argstr>
    800051b2:	02054f63          	bltz	a0,800051f0 <sys_chdir+0x60>
    800051b6:	e526                	sd	s1,136(sp)
    800051b8:	f6040513          	addi	a0,s0,-160
    800051bc:	8abfe0ef          	jal	80003a66 <namei>
    800051c0:	84aa                	mv	s1,a0
    800051c2:	c515                	beqz	a0,800051ee <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    800051c4:	86afe0ef          	jal	8000322e <ilock>
  if (ip->type != T_DIR) {
    800051c8:	04449703          	lh	a4,68(s1)
    800051cc:	4785                	li	a5,1
    800051ce:	02f71963          	bne	a4,a5,80005200 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800051d2:	8526                	mv	a0,s1
    800051d4:	908fe0ef          	jal	800032dc <iunlock>
  iput(p->cwd);
    800051d8:	15093503          	ld	a0,336(s2)
    800051dc:	9d4fe0ef          	jal	800033b0 <iput>
  end_op();
    800051e0:	ad5fe0ef          	jal	80003cb4 <end_op>
  p->cwd = ip;
    800051e4:	14993823          	sd	s1,336(s2)
  return 0;
    800051e8:	4501                	li	a0,0
    800051ea:	64aa                	ld	s1,136(sp)
    800051ec:	a029                	j	800051f6 <sys_chdir+0x66>
    800051ee:	64aa                	ld	s1,136(sp)
    end_op();
    800051f0:	ac5fe0ef          	jal	80003cb4 <end_op>
    return -1;
    800051f4:	557d                	li	a0,-1
}
    800051f6:	60ea                	ld	ra,152(sp)
    800051f8:	644a                	ld	s0,144(sp)
    800051fa:	690a                	ld	s2,128(sp)
    800051fc:	610d                	addi	sp,sp,160
    800051fe:	8082                	ret
    iunlockput(ip);
    80005200:	8526                	mv	a0,s1
    80005202:	a38fe0ef          	jal	8000343a <iunlockput>
    end_op();
    80005206:	aaffe0ef          	jal	80003cb4 <end_op>
    return -1;
    8000520a:	64aa                	ld	s1,136(sp)
    8000520c:	b7e5                	j	800051f4 <sys_chdir+0x64>

000000008000520e <sys_exec>:

uint64
sys_exec(void)
{
    8000520e:	7105                	addi	sp,sp,-480
    80005210:	ef86                	sd	ra,472(sp)
    80005212:	eba2                	sd	s0,464(sp)
    80005214:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005216:	e2840593          	addi	a1,s0,-472
    8000521a:	4505                	li	a0,1
    8000521c:	dc0fd0ef          	jal	800027dc <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    80005220:	08000613          	li	a2,128
    80005224:	f3040593          	addi	a1,s0,-208
    80005228:	4501                	li	a0,0
    8000522a:	dcefd0ef          	jal	800027f8 <argstr>
    8000522e:	0c054e63          	bltz	a0,8000530a <sys_exec+0xfc>
    80005232:	e7a6                	sd	s1,456(sp)
    80005234:	e3ca                	sd	s2,448(sp)
    80005236:	ff4e                	sd	s3,440(sp)
    80005238:	fb52                	sd	s4,432(sp)
    8000523a:	f756                	sd	s5,424(sp)
    8000523c:	f35a                	sd	s6,416(sp)
    8000523e:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    80005240:	e3040a13          	addi	s4,s0,-464
    80005244:	10000613          	li	a2,256
    80005248:	4581                	li	a1,0
    8000524a:	8552                	mv	a0,s4
    8000524c:	a89fb0ef          	jal	80000cd4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    80005250:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80005252:	89d2                	mv	s3,s4
    80005254:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005256:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000525a:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    8000525c:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    80005260:	00391513          	slli	a0,s2,0x3
    80005264:	85d6                	mv	a1,s5
    80005266:	e2843783          	ld	a5,-472(s0)
    8000526a:	953e                	add	a0,a0,a5
    8000526c:	ccefd0ef          	jal	8000273a <fetchaddr>
    80005270:	02054663          	bltz	a0,8000529c <sys_exec+0x8e>
    if (uarg == 0) {
    80005274:	e2043783          	ld	a5,-480(s0)
    80005278:	c3b9                	beqz	a5,800052be <sys_exec+0xb0>
    argv[i] = kalloc();
    8000527a:	8c5fb0ef          	jal	80000b3e <kalloc>
    8000527e:	85aa                	mv	a1,a0
    80005280:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    80005284:	cd01                	beqz	a0,8000529c <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005286:	865a                	mv	a2,s6
    80005288:	e2043503          	ld	a0,-480(s0)
    8000528c:	cf4fd0ef          	jal	80002780 <fetchstr>
    80005290:	00054663          	bltz	a0,8000529c <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    80005294:	0905                	addi	s2,s2,1
    80005296:	09a1                	addi	s3,s3,8
    80005298:	fd7914e3          	bne	s2,s7,80005260 <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000529c:	100a0a13          	addi	s4,s4,256
    800052a0:	6088                	ld	a0,0(s1)
    800052a2:	cd29                	beqz	a0,800052fc <sys_exec+0xee>
    kfree(argv[i]);
    800052a4:	fb2fb0ef          	jal	80000a56 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052a8:	04a1                	addi	s1,s1,8
    800052aa:	ff449be3          	bne	s1,s4,800052a0 <sys_exec+0x92>
    800052ae:	64be                	ld	s1,456(sp)
    800052b0:	691e                	ld	s2,448(sp)
    800052b2:	79fa                	ld	s3,440(sp)
    800052b4:	7a5a                	ld	s4,432(sp)
    800052b6:	7aba                	ld	s5,424(sp)
    800052b8:	7b1a                	ld	s6,416(sp)
    800052ba:	6bfa                	ld	s7,408(sp)
    800052bc:	a0b9                	j	8000530a <sys_exec+0xfc>
      argv[i] = 0;
    800052be:	0009079b          	sext.w	a5,s2
    800052c2:	e3040593          	addi	a1,s0,-464
    800052c6:	078e                	slli	a5,a5,0x3
    800052c8:	97ae                	add	a5,a5,a1
    800052ca:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800052ce:	f3040513          	addi	a0,s0,-208
    800052d2:	c30ff0ef          	jal	80004702 <kexec>
    800052d6:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d8:	100a0a13          	addi	s4,s4,256
    800052dc:	6088                	ld	a0,0(s1)
    800052de:	c511                	beqz	a0,800052ea <sys_exec+0xdc>
    kfree(argv[i]);
    800052e0:	f76fb0ef          	jal	80000a56 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052e4:	04a1                	addi	s1,s1,8
    800052e6:	ff449be3          	bne	s1,s4,800052dc <sys_exec+0xce>
  return ret;
    800052ea:	854a                	mv	a0,s2
    800052ec:	64be                	ld	s1,456(sp)
    800052ee:	691e                	ld	s2,448(sp)
    800052f0:	79fa                	ld	s3,440(sp)
    800052f2:	7a5a                	ld	s4,432(sp)
    800052f4:	7aba                	ld	s5,424(sp)
    800052f6:	7b1a                	ld	s6,416(sp)
    800052f8:	6bfa                	ld	s7,408(sp)
    800052fa:	a809                	j	8000530c <sys_exec+0xfe>
    800052fc:	64be                	ld	s1,456(sp)
    800052fe:	691e                	ld	s2,448(sp)
    80005300:	79fa                	ld	s3,440(sp)
    80005302:	7a5a                	ld	s4,432(sp)
    80005304:	7aba                	ld	s5,424(sp)
    80005306:	7b1a                	ld	s6,416(sp)
    80005308:	6bfa                	ld	s7,408(sp)
    return -1;
    8000530a:	557d                	li	a0,-1
  return -1;
}
    8000530c:	60fe                	ld	ra,472(sp)
    8000530e:	645e                	ld	s0,464(sp)
    80005310:	613d                	addi	sp,sp,480
    80005312:	8082                	ret

0000000080005314 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005314:	7139                	addi	sp,sp,-64
    80005316:	fc06                	sd	ra,56(sp)
    80005318:	f822                	sd	s0,48(sp)
    8000531a:	f426                	sd	s1,40(sp)
    8000531c:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000531e:	dbcfc0ef          	jal	800018da <myproc>
    80005322:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005324:	fd840593          	addi	a1,s0,-40
    80005328:	4501                	li	a0,0
    8000532a:	cb2fd0ef          	jal	800027dc <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000532e:	fc840593          	addi	a1,s0,-56
    80005332:	fd040513          	addi	a0,s0,-48
    80005336:	89aff0ef          	jal	800043d0 <pipealloc>
    8000533a:	0a054463          	bltz	a0,800053e2 <sys_pipe+0xce>
    return -1;
  fd0 = -1;
    8000533e:	57fd                	li	a5,-1
    80005340:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    80005344:	fd043503          	ld	a0,-48(s0)
    80005348:	f22ff0ef          	jal	80004a6a <fdalloc>
    8000534c:	fca42223          	sw	a0,-60(s0)
    80005350:	08054163          	bltz	a0,800053d2 <sys_pipe+0xbe>
    80005354:	fc843503          	ld	a0,-56(s0)
    80005358:	f12ff0ef          	jal	80004a6a <fdalloc>
    8000535c:	fca42023          	sw	a0,-64(s0)
    80005360:	06054063          	bltz	a0,800053c0 <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005364:	4691                	li	a3,4
    80005366:	fc440613          	addi	a2,s0,-60
    8000536a:	fd843583          	ld	a1,-40(s0)
    8000536e:	68a8                	ld	a0,80(s1)
    80005370:	a9cfc0ef          	jal	8000160c <copyout>
    80005374:	00054f63          	bltz	a0,80005392 <sys_pipe+0x7e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    80005378:	4691                	li	a3,4
    8000537a:	fc040613          	addi	a2,s0,-64
    8000537e:	fd843583          	ld	a1,-40(s0)
    80005382:	95b6                	add	a1,a1,a3
    80005384:	68a8                	ld	a0,80(s1)
    80005386:	a86fc0ef          	jal	8000160c <copyout>
    8000538a:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    8000538c:	4501                	li	a0,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000538e:	0407db63          	bgez	a5,800053e4 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    80005392:	fc442783          	lw	a5,-60(s0)
    80005396:	07e9                	addi	a5,a5,26
    80005398:	078e                	slli	a5,a5,0x3
    8000539a:	97a6                	add	a5,a5,s1
    8000539c:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053a0:	fc042783          	lw	a5,-64(s0)
    800053a4:	07e9                	addi	a5,a5,26
    800053a6:	078e                	slli	a5,a5,0x3
    800053a8:	97a6                	add	a5,a5,s1
    800053aa:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053ae:	fd043503          	ld	a0,-48(s0)
    800053b2:	d11fe0ef          	jal	800040c2 <fileclose>
    fileclose(wf);
    800053b6:	fc843503          	ld	a0,-56(s0)
    800053ba:	d09fe0ef          	jal	800040c2 <fileclose>
    return -1;
    800053be:	a015                	j	800053e2 <sys_pipe+0xce>
    if (fd0 >= 0)
    800053c0:	fc442783          	lw	a5,-60(s0)
    800053c4:	0007c763          	bltz	a5,800053d2 <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    800053c8:	07e9                	addi	a5,a5,26
    800053ca:	078e                	slli	a5,a5,0x3
    800053cc:	97a6                	add	a5,a5,s1
    800053ce:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800053d2:	fd043503          	ld	a0,-48(s0)
    800053d6:	cedfe0ef          	jal	800040c2 <fileclose>
    fileclose(wf);
    800053da:	fc843503          	ld	a0,-56(s0)
    800053de:	ce5fe0ef          	jal	800040c2 <fileclose>
    return -1;
    800053e2:	557d                	li	a0,-1
}
    800053e4:	70e2                	ld	ra,56(sp)
    800053e6:	7442                	ld	s0,48(sp)
    800053e8:	74a2                	ld	s1,40(sp)
    800053ea:	6121                	addi	sp,sp,64
    800053ec:	8082                	ret
	...

00000000800053f0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800053f0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800053f2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800053f4:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    800053f6:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800053f8:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800053fa:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800053fc:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800053fe:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005400:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005402:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005404:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005406:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005408:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000540a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000540c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000540e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005410:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005412:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005414:	a34fd0ef          	jal	80002648 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005418:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000541a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000541c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000541e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005420:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005422:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005424:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005426:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005428:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000542a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000542c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000542e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005430:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005432:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005434:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005436:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005438:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000543a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000543c:	10200073          	sret
    80005440:	0001                	nop
    80005442:	00000013          	nop
    80005446:	00000013          	nop
    8000544a:	00000013          	nop

000000008000544e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000544e:	1141                	addi	sp,sp,-16
    80005450:	e406                	sd	ra,8(sp)
    80005452:	e022                	sd	s0,0(sp)
    80005454:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    80005456:	0c000737          	lui	a4,0xc000
    8000545a:	4785                	li	a5,1
    8000545c:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    8000545e:	c35c                	sw	a5,4(a4)
}
    80005460:	60a2                	ld	ra,8(sp)
    80005462:	6402                	ld	s0,0(sp)
    80005464:	0141                	addi	sp,sp,16
    80005466:	8082                	ret

0000000080005468 <plicinithart>:

void
plicinithart(void)
{
    80005468:	1141                	addi	sp,sp,-16
    8000546a:	e406                	sd	ra,8(sp)
    8000546c:	e022                	sd	s0,0(sp)
    8000546e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005470:	c36fc0ef          	jal	800018a6 <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005474:	0085171b          	slliw	a4,a0,0x8
    80005478:	0c0027b7          	lui	a5,0xc002
    8000547c:	97ba                	add	a5,a5,a4
    8000547e:	40200713          	li	a4,1026
    80005482:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    80005486:	00d5151b          	slliw	a0,a0,0xd
    8000548a:	0c2017b7          	lui	a5,0xc201
    8000548e:	97aa                	add	a5,a5,a0
    80005490:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80005494:	60a2                	ld	ra,8(sp)
    80005496:	6402                	ld	s0,0(sp)
    80005498:	0141                	addi	sp,sp,16
    8000549a:	8082                	ret

000000008000549c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000549c:	1141                	addi	sp,sp,-16
    8000549e:	e406                	sd	ra,8(sp)
    800054a0:	e022                	sd	s0,0(sp)
    800054a2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054a4:	c02fc0ef          	jal	800018a6 <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    800054a8:	00d5151b          	slliw	a0,a0,0xd
    800054ac:	0c2017b7          	lui	a5,0xc201
    800054b0:	97aa                	add	a5,a5,a0
  return irq;
}
    800054b2:	43c8                	lw	a0,4(a5)
    800054b4:	60a2                	ld	ra,8(sp)
    800054b6:	6402                	ld	s0,0(sp)
    800054b8:	0141                	addi	sp,sp,16
    800054ba:	8082                	ret

00000000800054bc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054bc:	1101                	addi	sp,sp,-32
    800054be:	ec06                	sd	ra,24(sp)
    800054c0:	e822                	sd	s0,16(sp)
    800054c2:	e426                	sd	s1,8(sp)
    800054c4:	1000                	addi	s0,sp,32
    800054c6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054c8:	bdefc0ef          	jal	800018a6 <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    800054cc:	00d5179b          	slliw	a5,a0,0xd
    800054d0:	0c201737          	lui	a4,0xc201
    800054d4:	97ba                	add	a5,a5,a4
    800054d6:	c3c4                	sw	s1,4(a5)
}
    800054d8:	60e2                	ld	ra,24(sp)
    800054da:	6442                	ld	s0,16(sp)
    800054dc:	64a2                	ld	s1,8(sp)
    800054de:	6105                	addi	sp,sp,32
    800054e0:	8082                	ret

00000000800054e2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054e2:	1141                	addi	sp,sp,-16
    800054e4:	e406                	sd	ra,8(sp)
    800054e6:	e022                	sd	s0,0(sp)
    800054e8:	0800                	addi	s0,sp,16
  if (i >= NUM)
    800054ea:	479d                	li	a5,7
    800054ec:	04a7ca63          	blt	a5,a0,80005540 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    800054f0:	0001c797          	auipc	a5,0x1c
    800054f4:	8c878793          	addi	a5,a5,-1848 # 80020db8 <disk>
    800054f8:	97aa                	add	a5,a5,a0
    800054fa:	0187c783          	lbu	a5,24(a5)
    800054fe:	e7b9                	bnez	a5,8000554c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005500:	00451693          	slli	a3,a0,0x4
    80005504:	0001c797          	auipc	a5,0x1c
    80005508:	8b478793          	addi	a5,a5,-1868 # 80020db8 <disk>
    8000550c:	6398                	ld	a4,0(a5)
    8000550e:	9736                	add	a4,a4,a3
    80005510:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005514:	6398                	ld	a4,0(a5)
    80005516:	9736                	add	a4,a4,a3
    80005518:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000551c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005520:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005524:	97aa                	add	a5,a5,a0
    80005526:	4705                	li	a4,1
    80005528:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000552c:	0001c517          	auipc	a0,0x1c
    80005530:	8a450513          	addi	a0,a0,-1884 # 80020dd0 <disk+0x18>
    80005534:	9edfc0ef          	jal	80001f20 <wakeup>
}
    80005538:	60a2                	ld	ra,8(sp)
    8000553a:	6402                	ld	s0,0(sp)
    8000553c:	0141                	addi	sp,sp,16
    8000553e:	8082                	ret
    panic("free_desc 1");
    80005540:	00002517          	auipc	a0,0x2
    80005544:	19050513          	addi	a0,a0,400 # 800076d0 <etext+0x6d0>
    80005548:	af2fb0ef          	jal	8000083a <panic>
    panic("free_desc 2");
    8000554c:	00002517          	auipc	a0,0x2
    80005550:	19450513          	addi	a0,a0,404 # 800076e0 <etext+0x6e0>
    80005554:	ae6fb0ef          	jal	8000083a <panic>

0000000080005558 <virtio_disk_init>:
{
    80005558:	1101                	addi	sp,sp,-32
    8000555a:	ec06                	sd	ra,24(sp)
    8000555c:	e822                	sd	s0,16(sp)
    8000555e:	e426                	sd	s1,8(sp)
    80005560:	e04a                	sd	s2,0(sp)
    80005562:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005564:	00002597          	auipc	a1,0x2
    80005568:	18c58593          	addi	a1,a1,396 # 800076f0 <etext+0x6f0>
    8000556c:	0001c517          	auipc	a0,0x1c
    80005570:	97450513          	addi	a0,a0,-1676 # 80020ee0 <disk+0x128>
    80005574:	e24fb0ef          	jal	80000b98 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005578:	100017b7          	lui	a5,0x10001
    8000557c:	4398                	lw	a4,0(a5)
    8000557e:	747277b7          	lui	a5,0x74727
    80005582:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005586:	14f71263          	bne	a4,a5,800056ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000558a:	100017b7          	lui	a5,0x10001
    8000558e:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005590:	4789                	li	a5,2
    80005592:	12f71c63          	bne	a4,a5,800056ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005596:	100017b7          	lui	a5,0x10001
    8000559a:	4798                	lw	a4,8(a5)
    8000559c:	4789                	li	a5,2
    8000559e:	12f71663          	bne	a4,a5,800056ca <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    800055a2:	100017b7          	lui	a5,0x10001
    800055a6:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055a8:	554d47b7          	lui	a5,0x554d4
    800055ac:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055b0:	10f71d63          	bne	a4,a5,800056ca <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055b4:	100017b7          	lui	a5,0x10001
    800055b8:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055bc:	4705                	li	a4,1
    800055be:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c0:	470d                	li	a4,3
    800055c2:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055c4:	10001737          	lui	a4,0x10001
    800055c8:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055ca:	c7ffe6b7          	lui	a3,0xc7ffe
    800055ce:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd867>
    800055d2:	8f75                	and	a4,a4,a3
    800055d4:	100016b7          	lui	a3,0x10001
    800055d8:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055da:	472d                	li	a4,11
    800055dc:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800055de:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055e2:	00897793          	andi	a5,s2,8
    800055e6:	0e078863          	beqz	a5,800056d6 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    800055f2:	43fc                	lw	a5,68(a5)
    800055f4:	0e079763          	bnez	a5,800056e2 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055f8:	100017b7          	lui	a5,0x10001
    800055fc:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    800055fe:	0e078863          	beqz	a5,800056ee <virtio_disk_init+0x196>
  if (max < NUM)
    80005602:	471d                	li	a4,7
    80005604:	0ef77b63          	bgeu	a4,a5,800056fa <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    80005608:	d36fb0ef          	jal	80000b3e <kalloc>
    8000560c:	0001b497          	auipc	s1,0x1b
    80005610:	7ac48493          	addi	s1,s1,1964 # 80020db8 <disk>
    80005614:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005616:	d28fb0ef          	jal	80000b3e <kalloc>
    8000561a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000561c:	d22fb0ef          	jal	80000b3e <kalloc>
    80005620:	87aa                	mv	a5,a0
    80005622:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005624:	6088                	ld	a0,0(s1)
    80005626:	0e050063          	beqz	a0,80005706 <virtio_disk_init+0x1ae>
    8000562a:	0001b717          	auipc	a4,0x1b
    8000562e:	79673703          	ld	a4,1942(a4) # 80020dc0 <disk+0x8>
    80005632:	00173713          	seqz	a4,a4
    80005636:	0017b793          	seqz	a5,a5
    8000563a:	8fd9                	or	a5,a5,a4
    8000563c:	e7e9                	bnez	a5,80005706 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    8000563e:	6605                	lui	a2,0x1
    80005640:	4581                	li	a1,0
    80005642:	e92fb0ef          	jal	80000cd4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005646:	0001b497          	auipc	s1,0x1b
    8000564a:	77248493          	addi	s1,s1,1906 # 80020db8 <disk>
    8000564e:	6605                	lui	a2,0x1
    80005650:	4581                	li	a1,0
    80005652:	6488                	ld	a0,8(s1)
    80005654:	e80fb0ef          	jal	80000cd4 <memset>
  memset(disk.used, 0, PGSIZE);
    80005658:	6605                	lui	a2,0x1
    8000565a:	4581                	li	a1,0
    8000565c:	6888                	ld	a0,16(s1)
    8000565e:	e76fb0ef          	jal	80000cd4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005662:	100017b7          	lui	a5,0x10001
    80005666:	4721                	li	a4,8
    80005668:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    8000566a:	4098                	lw	a4,0(s1)
    8000566c:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005670:	40d8                	lw	a4,4(s1)
    80005672:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80005676:	649c                	ld	a5,8(s1)
    80005678:	10001737          	lui	a4,0x10001
    8000567c:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005680:	9781                	srai	a5,a5,0x20
    80005682:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005686:	689c                	ld	a5,16(s1)
    80005688:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000568c:	9781                	srai	a5,a5,0x20
    8000568e:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005692:	4785                	li	a5,1
    80005694:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005696:	00f48c23          	sb	a5,24(s1)
    8000569a:	00f48ca3          	sb	a5,25(s1)
    8000569e:	00f48d23          	sb	a5,26(s1)
    800056a2:	00f48da3          	sb	a5,27(s1)
    800056a6:	00f48e23          	sb	a5,28(s1)
    800056aa:	00f48ea3          	sb	a5,29(s1)
    800056ae:	00f48f23          	sb	a5,30(s1)
    800056b2:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056b6:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ba:	07272823          	sw	s2,112(a4)
}
    800056be:	60e2                	ld	ra,24(sp)
    800056c0:	6442                	ld	s0,16(sp)
    800056c2:	64a2                	ld	s1,8(sp)
    800056c4:	6902                	ld	s2,0(sp)
    800056c6:	6105                	addi	sp,sp,32
    800056c8:	8082                	ret
    panic("could not find virtio disk");
    800056ca:	00002517          	auipc	a0,0x2
    800056ce:	03650513          	addi	a0,a0,54 # 80007700 <etext+0x700>
    800056d2:	968fb0ef          	jal	8000083a <panic>
    panic("virtio disk FEATURES_OK unset");
    800056d6:	00002517          	auipc	a0,0x2
    800056da:	04a50513          	addi	a0,a0,74 # 80007720 <etext+0x720>
    800056de:	95cfb0ef          	jal	8000083a <panic>
    panic("virtio disk should not be ready");
    800056e2:	00002517          	auipc	a0,0x2
    800056e6:	05e50513          	addi	a0,a0,94 # 80007740 <etext+0x740>
    800056ea:	950fb0ef          	jal	8000083a <panic>
    panic("virtio disk has no queue 0");
    800056ee:	00002517          	auipc	a0,0x2
    800056f2:	07250513          	addi	a0,a0,114 # 80007760 <etext+0x760>
    800056f6:	944fb0ef          	jal	8000083a <panic>
    panic("virtio disk max queue too short");
    800056fa:	00002517          	auipc	a0,0x2
    800056fe:	08650513          	addi	a0,a0,134 # 80007780 <etext+0x780>
    80005702:	938fb0ef          	jal	8000083a <panic>
    panic("virtio disk kalloc");
    80005706:	00002517          	auipc	a0,0x2
    8000570a:	09a50513          	addi	a0,a0,154 # 800077a0 <etext+0x7a0>
    8000570e:	92cfb0ef          	jal	8000083a <panic>

0000000080005712 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005712:	711d                	addi	sp,sp,-96
    80005714:	ec86                	sd	ra,88(sp)
    80005716:	e8a2                	sd	s0,80(sp)
    80005718:	e4a6                	sd	s1,72(sp)
    8000571a:	e0ca                	sd	s2,64(sp)
    8000571c:	fc4e                	sd	s3,56(sp)
    8000571e:	f852                	sd	s4,48(sp)
    80005720:	f456                	sd	s5,40(sp)
    80005722:	f05a                	sd	s6,32(sp)
    80005724:	ec5e                	sd	s7,24(sp)
    80005726:	e862                	sd	s8,16(sp)
    80005728:	1080                	addi	s0,sp,96
    8000572a:	89aa                	mv	s3,a0
    8000572c:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000572e:	00c52b83          	lw	s7,12(a0)
    80005732:	001b9b9b          	slliw	s7,s7,0x1
    80005736:	1b82                	slli	s7,s7,0x20
    80005738:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000573c:	0001b517          	auipc	a0,0x1b
    80005740:	7a450513          	addi	a0,a0,1956 # 80020ee0 <disk+0x128>
    80005744:	cd4fb0ef          	jal	80000c18 <acquire>
  for (int i = 0; i < NUM; i++) {
    80005748:	44a1                	li	s1,8
      disk.free[i] = 0;
    8000574a:	0001ba97          	auipc	s5,0x1b
    8000574e:	66ea8a93          	addi	s5,s5,1646 # 80020db8 <disk>
  for (int i = 0; i < 3; i++) {
    80005752:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005754:	5c7d                	li	s8,-1
    80005756:	a095                	j	800057ba <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005758:	00fa8733          	add	a4,s5,a5
    8000575c:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80005760:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    80005762:	0207c563          	bltz	a5,8000578c <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    80005766:	2905                	addiw	s2,s2,1
    80005768:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    8000576a:	05490c63          	beq	s2,s4,800057c2 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000576e:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    80005770:	0001b717          	auipc	a4,0x1b
    80005774:	64870713          	addi	a4,a4,1608 # 80020db8 <disk>
    80005778:	4781                	li	a5,0
    if (disk.free[i]) {
    8000577a:	01874683          	lbu	a3,24(a4)
    8000577e:	fee9                	bnez	a3,80005758 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    80005780:	2785                	addiw	a5,a5,1
    80005782:	0705                	addi	a4,a4,1
    80005784:	fe979be3          	bne	a5,s1,8000577a <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005788:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    8000578c:	01205d63          	blez	s2,800057a6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80005790:	fa042503          	lw	a0,-96(s0)
    80005794:	d4fff0ef          	jal	800054e2 <free_desc>
      for (int j = 0; j < i; j++)
    80005798:	4785                	li	a5,1
    8000579a:	0127d663          	bge	a5,s2,800057a6 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000579e:	fa442503          	lw	a0,-92(s0)
    800057a2:	d41ff0ef          	jal	800054e2 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057a6:	0001b597          	auipc	a1,0x1b
    800057aa:	73a58593          	addi	a1,a1,1850 # 80020ee0 <disk+0x128>
    800057ae:	0001b517          	auipc	a0,0x1b
    800057b2:	62250513          	addi	a0,a0,1570 # 80020dd0 <disk+0x18>
    800057b6:	f1efc0ef          	jal	80001ed4 <sleep>
  for (int i = 0; i < 3; i++) {
    800057ba:	fa040613          	addi	a2,s0,-96
    800057be:	4901                	li	s2,0
    800057c0:	b77d                	j	8000576e <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057c2:	fa042503          	lw	a0,-96(s0)
    800057c6:	00451693          	slli	a3,a0,0x4

  if (write)
    800057ca:	0001b797          	auipc	a5,0x1b
    800057ce:	5ee78793          	addi	a5,a5,1518 # 80020db8 <disk>
    800057d2:	00451713          	slli	a4,a0,0x4
    800057d6:	0a070713          	addi	a4,a4,160
    800057da:	973e                	add	a4,a4,a5
    800057dc:	01603633          	snez	a2,s6
    800057e0:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800057e2:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800057e6:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    800057ea:	6398                	ld	a4,0(a5)
    800057ec:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800057ee:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800057f2:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    800057f4:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800057f6:	6390                	ld	a2,0(a5)
    800057f8:	00d605b3          	add	a1,a2,a3
    800057fc:	4741                	li	a4,16
    800057fe:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005800:	4805                	li	a6,1
    80005802:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005806:	fa442703          	lw	a4,-92(s0)
    8000580a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000580e:	0712                	slli	a4,a4,0x4
    80005810:	963a                	add	a2,a2,a4
    80005812:	05898593          	addi	a1,s3,88
    80005816:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005818:	0007b883          	ld	a7,0(a5)
    8000581c:	9746                	add	a4,a4,a7
    8000581e:	40000613          	li	a2,1024
    80005822:	c710                	sw	a2,8(a4)
  if (write)
    80005824:	001b3613          	seqz	a2,s6
    80005828:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000582c:	01066633          	or	a2,a2,a6
    80005830:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005834:	fa842583          	lw	a1,-88(s0)
    80005838:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000583c:	00250613          	addi	a2,a0,2
    80005840:	0612                	slli	a2,a2,0x4
    80005842:	963e                	add	a2,a2,a5
    80005844:	577d                	li	a4,-1
    80005846:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    8000584a:	0592                	slli	a1,a1,0x4
    8000584c:	98ae                	add	a7,a7,a1
    8000584e:	03068713          	addi	a4,a3,48
    80005852:	973e                	add	a4,a4,a5
    80005854:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80005858:	6398                	ld	a4,0(a5)
    8000585a:	972e                	add	a4,a4,a1
    8000585c:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005860:	4689                	li	a3,2
    80005862:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005866:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000586a:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    8000586e:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005872:	6794                	ld	a3,8(a5)
    80005874:	0026d703          	lhu	a4,2(a3)
    80005878:	8b1d                	andi	a4,a4,7
    8000587a:	0706                	slli	a4,a4,0x1
    8000587c:	96ba                	add	a3,a3,a4
    8000587e:	00a69223          	sh	a0,4(a3)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005882:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005886:	6798                	ld	a4,8(a5)
    80005888:	00275783          	lhu	a5,2(a4)
    8000588c:	2785                	addiw	a5,a5,1
    8000588e:	00f71123          	sh	a5,2(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80005892:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005896:	100017b7          	lui	a5,0x10001
    8000589a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    8000589e:	0049a783          	lw	a5,4(s3)
    800058a2:	01079f63          	bne	a5,a6,800058c0 <virtio_disk_rw+0x1ae>
    sleep(b, &disk.vdisk_lock);
    800058a6:	0001b917          	auipc	s2,0x1b
    800058aa:	63a90913          	addi	s2,s2,1594 # 80020ee0 <disk+0x128>
  while (b->disk == 1) {
    800058ae:	84be                	mv	s1,a5
    sleep(b, &disk.vdisk_lock);
    800058b0:	85ca                	mv	a1,s2
    800058b2:	854e                	mv	a0,s3
    800058b4:	e20fc0ef          	jal	80001ed4 <sleep>
  while (b->disk == 1) {
    800058b8:	0049a783          	lw	a5,4(s3)
    800058bc:	fe978ae3          	beq	a5,s1,800058b0 <virtio_disk_rw+0x19e>
  }

  disk.info[idx[0]].b = 0;
    800058c0:	fa042903          	lw	s2,-96(s0)
    800058c4:	00290713          	addi	a4,s2,2
    800058c8:	0712                	slli	a4,a4,0x4
    800058ca:	0001b797          	auipc	a5,0x1b
    800058ce:	4ee78793          	addi	a5,a5,1262 # 80020db8 <disk>
    800058d2:	97ba                	add	a5,a5,a4
    800058d4:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800058d8:	0001b997          	auipc	s3,0x1b
    800058dc:	4e098993          	addi	s3,s3,1248 # 80020db8 <disk>
    800058e0:	00491713          	slli	a4,s2,0x4
    800058e4:	0009b783          	ld	a5,0(s3)
    800058e8:	97ba                	add	a5,a5,a4
    800058ea:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800058ee:	854a                	mv	a0,s2
    800058f0:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800058f4:	befff0ef          	jal	800054e2 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    800058f8:	8885                	andi	s1,s1,1
    800058fa:	f0fd                	bnez	s1,800058e0 <virtio_disk_rw+0x1ce>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058fc:	0001b517          	auipc	a0,0x1b
    80005900:	5e450513          	addi	a0,a0,1508 # 80020ee0 <disk+0x128>
    80005904:	b98fb0ef          	jal	80000c9c <release>
}
    80005908:	60e6                	ld	ra,88(sp)
    8000590a:	6446                	ld	s0,80(sp)
    8000590c:	64a6                	ld	s1,72(sp)
    8000590e:	6906                	ld	s2,64(sp)
    80005910:	79e2                	ld	s3,56(sp)
    80005912:	7a42                	ld	s4,48(sp)
    80005914:	7aa2                	ld	s5,40(sp)
    80005916:	7b02                	ld	s6,32(sp)
    80005918:	6be2                	ld	s7,24(sp)
    8000591a:	6c42                	ld	s8,16(sp)
    8000591c:	6125                	addi	sp,sp,96
    8000591e:	8082                	ret

0000000080005920 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005920:	1101                	addi	sp,sp,-32
    80005922:	ec06                	sd	ra,24(sp)
    80005924:	e822                	sd	s0,16(sp)
    80005926:	e426                	sd	s1,8(sp)
    80005928:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000592a:	0001b497          	auipc	s1,0x1b
    8000592e:	48e48493          	addi	s1,s1,1166 # 80020db8 <disk>
    80005932:	0001b517          	auipc	a0,0x1b
    80005936:	5ae50513          	addi	a0,a0,1454 # 80020ee0 <disk+0x128>
    8000593a:	adefb0ef          	jal	80000c18 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000593e:	100017b7          	lui	a5,0x10001
    80005942:	53bc                	lw	a5,96(a5)
    80005944:	8b8d                	andi	a5,a5,3
    80005946:	10001737          	lui	a4,0x10001
    8000594a:	d37c                	sw	a5,100(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    8000594c:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    80005950:	689c                	ld	a5,16(s1)
    80005952:	0204d703          	lhu	a4,32(s1)
    80005956:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000595a:	04f70663          	beq	a4,a5,800059a6 <virtio_disk_intr+0x86>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    8000595e:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005962:	6898                	ld	a4,16(s1)
    80005964:	0204d783          	lhu	a5,32(s1)
    80005968:	8b9d                	andi	a5,a5,7
    8000596a:	078e                	slli	a5,a5,0x3
    8000596c:	97ba                	add	a5,a5,a4
    8000596e:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    80005970:	00278713          	addi	a4,a5,2
    80005974:	0712                	slli	a4,a4,0x4
    80005976:	9726                	add	a4,a4,s1
    80005978:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    8000597c:	e321                	bnez	a4,800059bc <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    8000597e:	0789                	addi	a5,a5,2
    80005980:	0792                	slli	a5,a5,0x4
    80005982:	97a6                	add	a5,a5,s1
    80005984:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    80005986:	00052223          	sw	zero,4(a0)
    wakeup(b);
    8000598a:	d96fc0ef          	jal	80001f20 <wakeup>

    disk.used_idx += 1;
    8000598e:	0204d783          	lhu	a5,32(s1)
    80005992:	2785                	addiw	a5,a5,1
    80005994:	17c2                	slli	a5,a5,0x30
    80005996:	93c1                	srli	a5,a5,0x30
    80005998:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    8000599c:	6898                	ld	a4,16(s1)
    8000599e:	00275703          	lhu	a4,2(a4)
    800059a2:	faf71ee3          	bne	a4,a5,8000595e <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800059a6:	0001b517          	auipc	a0,0x1b
    800059aa:	53a50513          	addi	a0,a0,1338 # 80020ee0 <disk+0x128>
    800059ae:	aeefb0ef          	jal	80000c9c <release>
}
    800059b2:	60e2                	ld	ra,24(sp)
    800059b4:	6442                	ld	s0,16(sp)
    800059b6:	64a2                	ld	s1,8(sp)
    800059b8:	6105                	addi	sp,sp,32
    800059ba:	8082                	ret
      panic("virtio_disk_intr status");
    800059bc:	00002517          	auipc	a0,0x2
    800059c0:	dfc50513          	addi	a0,a0,-516 # 800077b8 <etext+0x7b8>
    800059c4:	e77fa0ef          	jal	8000083a <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
