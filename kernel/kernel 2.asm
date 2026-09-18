
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
    80000004:	a6010113          	addi	sp,sp,-1440 # 80007a60 <stack0>
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
    80000066:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd877>
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
    8000011c:	15e020ef          	jal	8000227a <either_copyin>
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
    80000198:	8cc50513          	addi	a0,a0,-1844 # 8000fa60 <cons>
    8000019c:	27d000ef          	jal	80000c18 <acquire>
  while (n > 0) {
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while (cons.r == cons.w) {
    800001a0:	00010497          	auipc	s1,0x10
    800001a4:	8c048493          	addi	s1,s1,-1856 # 8000fa60 <cons>
      if (killed(myproc())) {
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800001a8:	00010917          	auipc	s2,0x10
    800001ac:	95090913          	addi	s2,s2,-1712 # 8000faf8 <cons+0x98>
  while (n > 0) {
    800001b0:	0b305b63          	blez	s3,80000266 <consoleread+0xee>
    while (cons.r == cons.w) {
    800001b4:	0984a783          	lw	a5,152(s1)
    800001b8:	09c4a703          	lw	a4,156(s1)
    800001bc:	0af71063          	bne	a4,a5,8000025c <consoleread+0xe4>
      if (killed(myproc())) {
    800001c0:	71e010ef          	jal	800018de <myproc>
    800001c4:	751010ef          	jal	80002114 <killed>
    800001c8:	e12d                	bnez	a0,8000022a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800001ca:	85a6                	mv	a1,s1
    800001cc:	854a                	mv	a0,s2
    800001ce:	50b010ef          	jal	80001ed8 <sleep>
    while (cons.r == cons.w) {
    800001d2:	0984a783          	lw	a5,152(s1)
    800001d6:	09c4a703          	lw	a4,156(s1)
    800001da:	fef703e3          	beq	a4,a5,800001c0 <consoleread+0x48>
    800001de:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800001e0:	00010717          	auipc	a4,0x10
    800001e4:	88070713          	addi	a4,a4,-1920 # 8000fa60 <cons>
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
    80000212:	01e020ef          	jal	80002230 <either_copyout>
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
    8000022a:	00010517          	auipc	a0,0x10
    8000022e:	83650513          	addi	a0,a0,-1994 # 8000fa60 <cons>
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
    80000254:	8af72423          	sw	a5,-1880(a4) # 8000faf8 <cons+0x98>
    80000258:	7aa2                	ld	s5,40(sp)
    8000025a:	a031                	j	80000266 <consoleread+0xee>
    8000025c:	f456                	sd	s5,40(sp)
    8000025e:	b749                	j	800001e0 <consoleread+0x68>
    80000260:	7aa2                	ld	s5,40(sp)
    80000262:	a011                	j	80000266 <consoleread+0xee>
    80000264:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80000266:	0000f517          	auipc	a0,0xf
    8000026a:	7fa50513          	addi	a0,a0,2042 # 8000fa60 <cons>
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
    800002be:	7a650513          	addi	a0,a0,1958 # 8000fa60 <cons>
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
    800002dc:	7e9010ef          	jal	800022c4 <procdump>
      }
    }
    break;
  }

  release(&cons.lock);
    800002e0:	0000f517          	auipc	a0,0xf
    800002e4:	78050513          	addi	a0,a0,1920 # 8000fa60 <cons>
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
    80000302:	76270713          	addi	a4,a4,1890 # 8000fa60 <cons>
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
    80000328:	73c70713          	addi	a4,a4,1852 # 8000fa60 <cons>
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
    8000035a:	7a272703          	lw	a4,1954(a4) # 8000faf8 <cons+0x98>
    8000035e:	9f99                	subw	a5,a5,a4
    80000360:	08000713          	li	a4,128
    80000364:	f6e79ee3          	bne	a5,a4,800002e0 <consoleintr+0x32>
    80000368:	a075                	j	80000414 <consoleintr+0x166>
    8000036a:	e04a                	sd	s2,0(sp)
    while (cons.e != cons.w &&
    8000036c:	0000f717          	auipc	a4,0xf
    80000370:	6f470713          	addi	a4,a4,1780 # 8000fa60 <cons>
    80000374:	0a072783          	lw	a5,160(a4)
    80000378:	09c72703          	lw	a4,156(a4)
           cons.buf[(cons.e - 1) % INPUT_BUF_SIZE] != '\n') {
    8000037c:	0000f497          	auipc	s1,0xf
    80000380:	6e448493          	addi	s1,s1,1764 # 8000fa60 <cons>
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
    800003c2:	6a270713          	addi	a4,a4,1698 # 8000fa60 <cons>
    800003c6:	0a072783          	lw	a5,160(a4)
    800003ca:	09c72703          	lw	a4,156(a4)
    800003ce:	f0f709e3          	beq	a4,a5,800002e0 <consoleintr+0x32>
      cons.e--;
    800003d2:	37fd                	addiw	a5,a5,-1
    800003d4:	0000f717          	auipc	a4,0xf
    800003d8:	72f72623          	sw	a5,1836(a4) # 8000fb00 <cons+0xa0>
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
    800003f6:	66e78793          	addi	a5,a5,1646 # 8000fa60 <cons>
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
    80000418:	6ec7a423          	sw	a2,1768(a5) # 8000fafc <cons+0x9c>
        wakeup(&cons.r);
    8000041c:	0000f517          	auipc	a0,0xf
    80000420:	6dc50513          	addi	a0,a0,1756 # 8000faf8 <cons+0x98>
    80000424:	301010ef          	jal	80001f24 <wakeup>
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
    8000043e:	62650513          	addi	a0,a0,1574 # 8000fa60 <cons>
    80000442:	756000ef          	jal	80000b98 <initlock>

  uartinit();
    80000446:	454000ef          	jal	8000089a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000044a:	00020797          	auipc	a5,0x20
    8000044e:	98678793          	addi	a5,a5,-1658 # 8001fdd0 <devsw>
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
    8000048c:	38880813          	addi	a6,a6,904 # 80007810 <digits>
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
    80000524:	5147a783          	lw	a5,1300(a5) # 80007a34 <panicking>
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
    8000056a:	5a250513          	addi	a0,a0,1442 # 8000fb08 <pr>
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
    800006d8:	13cc8c93          	addi	s9,s9,316 # 80007810 <digits>
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
    80000760:	2d87a783          	lw	a5,728(a5) # 80007a34 <panicking>
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
    8000078a:	38250513          	addi	a0,a0,898 # 8000fb08 <pr>
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
    8000084e:	1e97a523          	sw	s1,490(a5) # 80007a34 <panicking>
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
    80000870:	1c97a223          	sw	s1,452(a5) # 80007a30 <panicked>
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
    8000088a:	28250513          	addi	a0,a0,642 # 8000fb08 <pr>
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
    800008e0:	24450513          	addi	a0,a0,580 # 8000fb20 <tx_lock>
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
    80000904:	22050513          	addi	a0,a0,544 # 8000fb20 <tx_lock>
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
    80000922:	11e48493          	addi	s1,s1,286 # 80007a3c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80000926:	0000f997          	auipc	s3,0xf
    8000092a:	1fa98993          	addi	s3,s3,506 # 8000fb20 <tx_lock>
    8000092e:	00007917          	auipc	s2,0x7
    80000932:	10a90913          	addi	s2,s2,266 # 80007a38 <tx_chan>
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
    80000942:	596010ef          	jal	80001ed8 <sleep>
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
    80000970:	1b450513          	addi	a0,a0,436 # 8000fb20 <tx_lock>
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
    80000994:	0a47a783          	lw	a5,164(a5) # 80007a34 <panicking>
    80000998:	cb91                	beqz	a5,800009ac <uartputc_sync+0x28>
    push_off();

  if (panicked) {
    8000099a:	00007797          	auipc	a5,0x7
    8000099e:	0967a783          	lw	a5,150(a5) # 80007a30 <panicked>
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
    800009c8:	0707a783          	lw	a5,112(a5) # 80007a34 <panicking>
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
    800009f6:	12e50513          	addi	a0,a0,302 # 8000fb20 <tx_lock>
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
    80000a10:	11450513          	addi	a0,a0,276 # 8000fb20 <tx_lock>
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
    80000a38:	0007a423          	sw	zero,8(a5) # 80007a3c <tx_busy>
    wakeup(&tx_chan);
    80000a3c:	00007517          	auipc	a0,0x7
    80000a40:	ffc50513          	addi	a0,a0,-4 # 80007a38 <tx_chan>
    80000a44:	4e0010ef          	jal	80001f24 <wakeup>
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
    80000a66:	52678793          	addi	a5,a5,1318 # 80020f88 <end>
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
    80000a90:	0ac90913          	addi	s2,s2,172 # 8000fb38 <kmem>
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
    80000b1e:	01e50513          	addi	a0,a0,30 # 8000fb38 <kmem>
    80000b22:	076000ef          	jal	80000b98 <initlock>
  freerange(end, (void *)PHYSTOP);
    80000b26:	45c5                	li	a1,17
    80000b28:	05ee                	slli	a1,a1,0x1b
    80000b2a:	00020517          	auipc	a0,0x20
    80000b2e:	45e50513          	addi	a0,a0,1118 # 80020f88 <end>
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
    80000b4c:	ff050513          	addi	a0,a0,-16 # 8000fb38 <kmem>
    80000b50:	0c8000ef          	jal	80000c18 <acquire>
  r = kmem.freelist;
    80000b54:	0000f497          	auipc	s1,0xf
    80000b58:	ffc4b483          	ld	s1,-4(s1) # 8000fb50 <kmem+0x18>
  if (r)
    80000b5c:	c49d                	beqz	s1,80000b8a <kalloc+0x4c>
    kmem.freelist = r->next;
    80000b5e:	609c                	ld	a5,0(s1)
    80000b60:	0000f717          	auipc	a4,0xf
    80000b64:	fef73823          	sd	a5,-16(a4) # 8000fb50 <kmem+0x18>
  release(&kmem.lock);
    80000b68:	0000f517          	auipc	a0,0xf
    80000b6c:	fd050513          	addi	a0,a0,-48 # 8000fb38 <kmem>
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
    80000b8e:	fae50513          	addi	a0,a0,-82 # 8000fb38 <kmem>
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
    80000bc8:	4f7000ef          	jal	800018be <mycpu>
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
    80000bee:	4d1000ef          	jal	800018be <mycpu>
    80000bf2:	5d3c                	lw	a5,120(a0)
    80000bf4:	cb99                	beqz	a5,80000c0a <push_off+0x2c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80000bf6:	4c9000ef          	jal	800018be <mycpu>
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
    80000c0a:	4b5000ef          	jal	800018be <mycpu>
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
    80000c38:	487000ef          	jal	800018be <mycpu>
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
    80000c5c:	463000ef          	jal	800018be <mycpu>
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
    80000e88:	223000ef          	jal	800018aa <cpuid>
    userinit();         // first user process
    race_init();        // shared resource and spinlock initialization
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    started = 1;
  } else {
    while (started == 0)
    80000e8c:	00007717          	auipc	a4,0x7
    80000e90:	bb470713          	addi	a4,a4,-1100 # 80007a40 <started>
  if (cpuid() == 0) {
    80000e94:	c515                	beqz	a0,80000ec0 <main+0x40>
    while (started == 0)
    80000e96:	431c                	lw	a5,0(a4)
    80000e98:	dffd                	beqz	a5,80000e96 <main+0x16>
      ;
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000e9a:	0330000f          	fence	rw,rw
    printk("hart %d starting\n", cpuid());
    80000e9e:	20d000ef          	jal	800018aa <cpuid>
    80000ea2:	85aa                	mv	a1,a0
    80000ea4:	00006517          	auipc	a0,0x6
    80000ea8:	1f450513          	addi	a0,a0,500 # 80007098 <etext+0x98>
    80000eac:	e56ff0ef          	jal	80000502 <printk>
    kvminithart();  // turn on paging
    80000eb0:	084000ef          	jal	80000f34 <kvminithart>
    trapinithart(); // install kernel trap vector
    80000eb4:	53e010ef          	jal	800023f2 <trapinithart>
    plicinithart(); // ask PLIC for device interrupts
    80000eb8:	610040ef          	jal	800054c8 <plicinithart>
  }

  scheduler();
    80000ebc:	69d000ef          	jal	80001d58 <scheduler>
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
    80000ef0:	2c4000ef          	jal	800011b4 <kvminit>
    kvminithart();      // turn on paging
    80000ef4:	040000ef          	jal	80000f34 <kvminithart>
    procinit();         // process table
    80000ef8:	0fb000ef          	jal	800017f2 <procinit>
    trapinit();         // trap vectors
    80000efc:	4d2010ef          	jal	800023ce <trapinit>
    trapinithart();     // install kernel trap vector
    80000f00:	4f2010ef          	jal	800023f2 <trapinithart>
    plicinit();         // set up interrupt controller
    80000f04:	5aa040ef          	jal	800054ae <plicinit>
    plicinithart();     // ask PLIC for device interrupts
    80000f08:	5c0040ef          	jal	800054c8 <plicinithart>
    binit();            // buffer cache
    80000f0c:	459010ef          	jal	80002b64 <binit>
    iinit();            // inode table
    80000f10:	1b2020ef          	jal	800030c2 <iinit>
    fileinit();         // file table
    80000f14:	142030ef          	jal	80004056 <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000f18:	6a0040ef          	jal	800055b8 <virtio_disk_init>
    userinit();         // first user process
    80000f1c:	493000ef          	jal	80001bae <userinit>
    race_init();        // shared resource and spinlock initialization
    80000f20:	309040ef          	jal	80005a28 <race_init>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    80000f24:	0330000f          	fence	rw,rw
    started = 1;
    80000f28:	4785                	li	a5,1
    80000f2a:	00007717          	auipc	a4,0x7
    80000f2e:	b0f72b23          	sw	a5,-1258(a4) # 80007a40 <started>
    80000f32:	b769                	j	80000ebc <main+0x3c>

0000000080000f34 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000f34:	1141                	addi	sp,sp,-16
    80000f36:	e406                	sd	ra,8(sp)
    80000f38:	e022                	sd	s0,0(sp)
    80000f3a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000f3c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000f40:	00007797          	auipc	a5,0x7
    80000f44:	b087b783          	ld	a5,-1272(a5) # 80007a48 <kernel_pagetable>
    80000f48:	83b1                	srli	a5,a5,0xc
    80000f4a:	577d                	li	a4,-1
    80000f4c:	177e                	slli	a4,a4,0x3f
    80000f4e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r"(x));
    80000f50:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000f54:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000f58:	60a2                	ld	ra,8(sp)
    80000f5a:	6402                	ld	s0,0(sp)
    80000f5c:	0141                	addi	sp,sp,16
    80000f5e:	8082                	ret

0000000080000f60 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000f60:	7139                	addi	sp,sp,-64
    80000f62:	fc06                	sd	ra,56(sp)
    80000f64:	f822                	sd	s0,48(sp)
    80000f66:	f426                	sd	s1,40(sp)
    80000f68:	f04a                	sd	s2,32(sp)
    80000f6a:	ec4e                	sd	s3,24(sp)
    80000f6c:	e852                	sd	s4,16(sp)
    80000f6e:	e456                	sd	s5,8(sp)
    80000f70:	e05a                	sd	s6,0(sp)
    80000f72:	0080                	addi	s0,sp,64
    80000f74:	84aa                	mv	s1,a0
    80000f76:	89ae                	mv	s3,a1
    80000f78:	8b32                	mv	s6,a2
  if (va >= MAXVA)
    80000f7a:	57fd                	li	a5,-1
    80000f7c:	83e9                	srli	a5,a5,0x1a
    80000f7e:	4a79                	li	s4,30
    panic("walk");

  for (int level = 2; level > 0; level--) {
    80000f80:	4ab1                	li	s5,12
  if (va >= MAXVA)
    80000f82:	06b7e363          	bltu	a5,a1,80000fe8 <walk+0x88>
    pte_t *pte = &pagetable[PX(level, va)];
    80000f86:	0149d933          	srl	s2,s3,s4
    80000f8a:	1ff97913          	andi	s2,s2,511
    80000f8e:	090e                	slli	s2,s2,0x3
    80000f90:	9926                	add	s2,s2,s1
    if (*pte & PTE_V) {
    80000f92:	00093483          	ld	s1,0(s2)
    80000f96:	0014f793          	andi	a5,s1,1
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000f9a:	80a9                	srli	s1,s1,0xa
    80000f9c:	04b2                	slli	s1,s1,0xc
    if (*pte & PTE_V) {
    80000f9e:	e395                	bnez	a5,80000fc2 <walk+0x62>
    } else {
      if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    80000fa0:	040b0a63          	beqz	s6,80000ff4 <walk+0x94>
    80000fa4:	b9bff0ef          	jal	80000b3e <kalloc>
    80000fa8:	84aa                	mv	s1,a0
    80000faa:	c50d                	beqz	a0,80000fd4 <walk+0x74>
        return 0;
      memset(pagetable, 0, PGSIZE);
    80000fac:	6605                	lui	a2,0x1
    80000fae:	4581                	li	a1,0
    80000fb0:	d25ff0ef          	jal	80000cd4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000fb4:	00c4d793          	srli	a5,s1,0xc
    80000fb8:	07aa                	slli	a5,a5,0xa
    80000fba:	0017e793          	ori	a5,a5,1
    80000fbe:	00f93023          	sd	a5,0(s2)
  for (int level = 2; level > 0; level--) {
    80000fc2:	3a5d                	addiw	s4,s4,-9
    80000fc4:	fd5a11e3          	bne	s4,s5,80000f86 <walk+0x26>
    }
  }
  return &pagetable[PX(0, va)];
    80000fc8:	00c9d513          	srli	a0,s3,0xc
    80000fcc:	1ff57513          	andi	a0,a0,511
    80000fd0:	050e                	slli	a0,a0,0x3
    80000fd2:	9526                	add	a0,a0,s1
}
    80000fd4:	70e2                	ld	ra,56(sp)
    80000fd6:	7442                	ld	s0,48(sp)
    80000fd8:	74a2                	ld	s1,40(sp)
    80000fda:	7902                	ld	s2,32(sp)
    80000fdc:	69e2                	ld	s3,24(sp)
    80000fde:	6a42                	ld	s4,16(sp)
    80000fe0:	6aa2                	ld	s5,8(sp)
    80000fe2:	6b02                	ld	s6,0(sp)
    80000fe4:	6121                	addi	sp,sp,64
    80000fe6:	8082                	ret
    panic("walk");
    80000fe8:	00006517          	auipc	a0,0x6
    80000fec:	0c850513          	addi	a0,a0,200 # 800070b0 <etext+0xb0>
    80000ff0:	84bff0ef          	jal	8000083a <panic>
        return 0;
    80000ff4:	4501                	li	a0,0
    80000ff6:	bff9                	j	80000fd4 <walk+0x74>

0000000080000ff8 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if (va >= MAXVA)
    80000ff8:	57fd                	li	a5,-1
    80000ffa:	83e9                	srli	a5,a5,0x1a
    80000ffc:	00b7f463          	bgeu	a5,a1,80001004 <walkaddr+0xc>
    return 0;
    80001000:	4501                	li	a0,0
    return 0;
  if ((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80001002:	8082                	ret
{
    80001004:	1141                	addi	sp,sp,-16
    80001006:	e406                	sd	ra,8(sp)
    80001008:	e022                	sd	s0,0(sp)
    8000100a:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    8000100c:	4601                	li	a2,0
    8000100e:	f53ff0ef          	jal	80000f60 <walk>
  if (pte == 0)
    80001012:	c519                	beqz	a0,80001020 <walkaddr+0x28>
  if ((*pte & PTE_V) == 0)
    80001014:	6108                	ld	a0,0(a0)
  if ((*pte & PTE_U) == 0)
    80001016:	01157713          	andi	a4,a0,17
    8000101a:	47c5                	li	a5,17
    8000101c:	00f70763          	beq	a4,a5,8000102a <walkaddr+0x32>
    return 0;
    80001020:	4501                	li	a0,0
}
    80001022:	60a2                	ld	ra,8(sp)
    80001024:	6402                	ld	s0,0(sp)
    80001026:	0141                	addi	sp,sp,16
    80001028:	8082                	ret
  pa = PTE2PA(*pte);
    8000102a:	8129                	srli	a0,a0,0xa
    8000102c:	0532                	slli	a0,a0,0xc
  return pa;
    8000102e:	bfd5                	j	80001022 <walkaddr+0x2a>

0000000080001030 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    80001030:	715d                	addi	sp,sp,-80
    80001032:	e486                	sd	ra,72(sp)
    80001034:	e0a2                	sd	s0,64(sp)
    80001036:	fc26                	sd	s1,56(sp)
    80001038:	f84a                	sd	s2,48(sp)
    8000103a:	f44e                	sd	s3,40(sp)
    8000103c:	f052                	sd	s4,32(sp)
    8000103e:	ec56                	sd	s5,24(sp)
    80001040:	e85a                	sd	s6,16(sp)
    80001042:	e45e                	sd	s7,8(sp)
    80001044:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    80001046:	03459793          	slli	a5,a1,0x34
    8000104a:	e7b1                	bnez	a5,80001096 <mappages+0x66>
    8000104c:	8a2a                	mv	s4,a0
    8000104e:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if ((size % PGSIZE) != 0)
    80001050:	03461793          	slli	a5,a2,0x34
    80001054:	e7b9                	bnez	a5,800010a2 <mappages+0x72>
    panic("mappages: size not aligned");

  if (size == 0)
    80001056:	ce21                	beqz	a2,800010ae <mappages+0x7e>
    panic("mappages: size");

  a = va;
  last = va + size - PGSIZE;
    80001058:	77fd                	lui	a5,0xfffff
    8000105a:	963e                	add	a2,a2,a5
    8000105c:	00b60933          	add	s2,a2,a1
  a = va;
    80001060:	84ae                	mv	s1,a1
  for (;;) {
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001062:	4b05                	li	s6,1
    80001064:	40b689b3          	sub	s3,a3,a1
    if (*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if (a == last)
      break;
    a += PGSIZE;
    80001068:	6b85                	lui	s7,0x1
    if ((pte = walk(pagetable, a, 1)) == 0)
    8000106a:	865a                	mv	a2,s6
    8000106c:	85a6                	mv	a1,s1
    8000106e:	8552                	mv	a0,s4
    80001070:	ef1ff0ef          	jal	80000f60 <walk>
    80001074:	c929                	beqz	a0,800010c6 <mappages+0x96>
    if (*pte & PTE_V)
    80001076:	611c                	ld	a5,0(a0)
    80001078:	8b85                	andi	a5,a5,1
    8000107a:	e3a1                	bnez	a5,800010ba <mappages+0x8a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000107c:	013487b3          	add	a5,s1,s3
    80001080:	83b1                	srli	a5,a5,0xc
    80001082:	07aa                	slli	a5,a5,0xa
    80001084:	0157e7b3          	or	a5,a5,s5
    80001088:	0017e793          	ori	a5,a5,1
    8000108c:	e11c                	sd	a5,0(a0)
    if (a == last)
    8000108e:	05248863          	beq	s1,s2,800010de <mappages+0xae>
    a += PGSIZE;
    80001092:	94de                	add	s1,s1,s7
    if ((pte = walk(pagetable, a, 1)) == 0)
    80001094:	bfd9                	j	8000106a <mappages+0x3a>
    panic("mappages: va not aligned");
    80001096:	00006517          	auipc	a0,0x6
    8000109a:	02250513          	addi	a0,a0,34 # 800070b8 <etext+0xb8>
    8000109e:	f9cff0ef          	jal	8000083a <panic>
    panic("mappages: size not aligned");
    800010a2:	00006517          	auipc	a0,0x6
    800010a6:	03650513          	addi	a0,a0,54 # 800070d8 <etext+0xd8>
    800010aa:	f90ff0ef          	jal	8000083a <panic>
    panic("mappages: size");
    800010ae:	00006517          	auipc	a0,0x6
    800010b2:	04a50513          	addi	a0,a0,74 # 800070f8 <etext+0xf8>
    800010b6:	f84ff0ef          	jal	8000083a <panic>
      panic("mappages: remap");
    800010ba:	00006517          	auipc	a0,0x6
    800010be:	04e50513          	addi	a0,a0,78 # 80007108 <etext+0x108>
    800010c2:	f78ff0ef          	jal	8000083a <panic>
      return -1;
    800010c6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800010c8:	60a6                	ld	ra,72(sp)
    800010ca:	6406                	ld	s0,64(sp)
    800010cc:	74e2                	ld	s1,56(sp)
    800010ce:	7942                	ld	s2,48(sp)
    800010d0:	79a2                	ld	s3,40(sp)
    800010d2:	7a02                	ld	s4,32(sp)
    800010d4:	6ae2                	ld	s5,24(sp)
    800010d6:	6b42                	ld	s6,16(sp)
    800010d8:	6ba2                	ld	s7,8(sp)
    800010da:	6161                	addi	sp,sp,80
    800010dc:	8082                	ret
  return 0;
    800010de:	4501                	li	a0,0
    800010e0:	b7e5                	j	800010c8 <mappages+0x98>

00000000800010e2 <kvmmap>:
{
    800010e2:	1141                	addi	sp,sp,-16
    800010e4:	e406                	sd	ra,8(sp)
    800010e6:	e022                	sd	s0,0(sp)
    800010e8:	0800                	addi	s0,sp,16
    800010ea:	87b6                	mv	a5,a3
  if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800010ec:	86b2                	mv	a3,a2
    800010ee:	863e                	mv	a2,a5
    800010f0:	f41ff0ef          	jal	80001030 <mappages>
    800010f4:	e509                	bnez	a0,800010fe <kvmmap+0x1c>
}
    800010f6:	60a2                	ld	ra,8(sp)
    800010f8:	6402                	ld	s0,0(sp)
    800010fa:	0141                	addi	sp,sp,16
    800010fc:	8082                	ret
    panic("kvmmap");
    800010fe:	00006517          	auipc	a0,0x6
    80001102:	01a50513          	addi	a0,a0,26 # 80007118 <etext+0x118>
    80001106:	f34ff0ef          	jal	8000083a <panic>

000000008000110a <kvmmake>:
{
    8000110a:	1101                	addi	sp,sp,-32
    8000110c:	ec06                	sd	ra,24(sp)
    8000110e:	e822                	sd	s0,16(sp)
    80001110:	e426                	sd	s1,8(sp)
    80001112:	e04a                	sd	s2,0(sp)
    80001114:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t)kalloc();
    80001116:	a29ff0ef          	jal	80000b3e <kalloc>
    8000111a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000111c:	6605                	lui	a2,0x1
    8000111e:	4581                	li	a1,0
    80001120:	bb5ff0ef          	jal	80000cd4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80001124:	4719                	li	a4,6
    80001126:	6685                	lui	a3,0x1
    80001128:	10000637          	lui	a2,0x10000
    8000112c:	85b2                	mv	a1,a2
    8000112e:	8526                	mv	a0,s1
    80001130:	fb3ff0ef          	jal	800010e2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80001134:	4719                	li	a4,6
    80001136:	6685                	lui	a3,0x1
    80001138:	10001637          	lui	a2,0x10001
    8000113c:	85b2                	mv	a1,a2
    8000113e:	8526                	mv	a0,s1
    80001140:	fa3ff0ef          	jal	800010e2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80001144:	4719                	li	a4,6
    80001146:	040006b7          	lui	a3,0x4000
    8000114a:	0c000637          	lui	a2,0xc000
    8000114e:	85b2                	mv	a1,a2
    80001150:	8526                	mv	a0,s1
    80001152:	f91ff0ef          	jal	800010e2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80001156:	00006917          	auipc	s2,0x6
    8000115a:	eaa90913          	addi	s2,s2,-342 # 80007000 <etext>
    8000115e:	4729                	li	a4,10
    80001160:	800006b7          	lui	a3,0x80000
    80001164:	96ca                	add	a3,a3,s2
    80001166:	4605                	li	a2,1
    80001168:	067e                	slli	a2,a2,0x1f
    8000116a:	85b2                	mv	a1,a2
    8000116c:	8526                	mv	a0,s1
    8000116e:	f75ff0ef          	jal	800010e2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext,
    80001172:	4719                	li	a4,6
    80001174:	46c5                	li	a3,17
    80001176:	06ee                	slli	a3,a3,0x1b
    80001178:	412686b3          	sub	a3,a3,s2
    8000117c:	864a                	mv	a2,s2
    8000117e:	85ca                	mv	a1,s2
    80001180:	8526                	mv	a0,s1
    80001182:	f61ff0ef          	jal	800010e2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80001186:	4729                	li	a4,10
    80001188:	6685                	lui	a3,0x1
    8000118a:	00005617          	auipc	a2,0x5
    8000118e:	e7660613          	addi	a2,a2,-394 # 80006000 <_trampoline>
    80001192:	040005b7          	lui	a1,0x4000
    80001196:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001198:	05b2                	slli	a1,a1,0xc
    8000119a:	8526                	mv	a0,s1
    8000119c:	f47ff0ef          	jal	800010e2 <kvmmap>
  proc_mapstacks(kpgtbl);
    800011a0:	8526                	mv	a0,s1
    800011a2:	5bc000ef          	jal	8000175e <proc_mapstacks>
}
    800011a6:	8526                	mv	a0,s1
    800011a8:	60e2                	ld	ra,24(sp)
    800011aa:	6442                	ld	s0,16(sp)
    800011ac:	64a2                	ld	s1,8(sp)
    800011ae:	6902                	ld	s2,0(sp)
    800011b0:	6105                	addi	sp,sp,32
    800011b2:	8082                	ret

00000000800011b4 <kvminit>:
{
    800011b4:	1141                	addi	sp,sp,-16
    800011b6:	e406                	sd	ra,8(sp)
    800011b8:	e022                	sd	s0,0(sp)
    800011ba:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800011bc:	f4fff0ef          	jal	8000110a <kvmmake>
    800011c0:	00007797          	auipc	a5,0x7
    800011c4:	88a7b423          	sd	a0,-1912(a5) # 80007a48 <kernel_pagetable>
}
    800011c8:	60a2                	ld	ra,8(sp)
    800011ca:	6402                	ld	s0,0(sp)
    800011cc:	0141                	addi	sp,sp,16
    800011ce:	8082                	ret

00000000800011d0 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800011d0:	1101                	addi	sp,sp,-32
    800011d2:	ec06                	sd	ra,24(sp)
    800011d4:	e822                	sd	s0,16(sp)
    800011d6:	e426                	sd	s1,8(sp)
    800011d8:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t)kalloc();
    800011da:	965ff0ef          	jal	80000b3e <kalloc>
    800011de:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800011e0:	c509                	beqz	a0,800011ea <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800011e2:	6605                	lui	a2,0x1
    800011e4:	4581                	li	a1,0
    800011e6:	aefff0ef          	jal	80000cd4 <memset>
  return pagetable;
}
    800011ea:	8526                	mv	a0,s1
    800011ec:	60e2                	ld	ra,24(sp)
    800011ee:	6442                	ld	s0,16(sp)
    800011f0:	64a2                	ld	s1,8(sp)
    800011f2:	6105                	addi	sp,sp,32
    800011f4:	8082                	ret

00000000800011f6 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800011f6:	7139                	addi	sp,sp,-64
    800011f8:	fc06                	sd	ra,56(sp)
    800011fa:	f822                	sd	s0,48(sp)
    800011fc:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if ((va % PGSIZE) != 0)
    800011fe:	03459793          	slli	a5,a1,0x34
    80001202:	e38d                	bnez	a5,80001224 <uvmunmap+0x2e>
    80001204:	f04a                	sd	s2,32(sp)
    80001206:	ec4e                	sd	s3,24(sp)
    80001208:	e852                	sd	s4,16(sp)
    8000120a:	e456                	sd	s5,8(sp)
    8000120c:	e05a                	sd	s6,0(sp)
    8000120e:	8a2a                	mv	s4,a0
    80001210:	892e                	mv	s2,a1
    80001212:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001214:	0632                	slli	a2,a2,0xc
    80001216:	00b609b3          	add	s3,a2,a1
    8000121a:	6b05                	lui	s6,0x1
    8000121c:	0535f963          	bgeu	a1,s3,8000126e <uvmunmap+0x78>
    80001220:	f426                	sd	s1,40(sp)
    80001222:	a015                	j	80001246 <uvmunmap+0x50>
    80001224:	f426                	sd	s1,40(sp)
    80001226:	f04a                	sd	s2,32(sp)
    80001228:	ec4e                	sd	s3,24(sp)
    8000122a:	e852                	sd	s4,16(sp)
    8000122c:	e456                	sd	s5,8(sp)
    8000122e:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80001230:	00006517          	auipc	a0,0x6
    80001234:	ef050513          	addi	a0,a0,-272 # 80007120 <etext+0x120>
    80001238:	e02ff0ef          	jal	8000083a <panic>
      continue;
    if (do_free) {
      uint64 pa = PTE2PA(*pte);
      kfree((void *)pa);
    }
    *pte = 0;
    8000123c:	0004b023          	sd	zero,0(s1)
  for (a = va; a < va + npages * PGSIZE; a += PGSIZE) {
    80001240:	995a                	add	s2,s2,s6
    80001242:	03397563          	bgeu	s2,s3,8000126c <uvmunmap+0x76>
    if ((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80001246:	4601                	li	a2,0
    80001248:	85ca                	mv	a1,s2
    8000124a:	8552                	mv	a0,s4
    8000124c:	d15ff0ef          	jal	80000f60 <walk>
    80001250:	84aa                	mv	s1,a0
    80001252:	d57d                	beqz	a0,80001240 <uvmunmap+0x4a>
    if ((*pte & PTE_V) == 0) // has physical page been allocated?
    80001254:	611c                	ld	a5,0(a0)
    80001256:	0017f713          	andi	a4,a5,1
    8000125a:	d37d                	beqz	a4,80001240 <uvmunmap+0x4a>
    if (do_free) {
    8000125c:	fe0a80e3          	beqz	s5,8000123c <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80001260:	83a9                	srli	a5,a5,0xa
      kfree((void *)pa);
    80001262:	00c79513          	slli	a0,a5,0xc
    80001266:	ff0ff0ef          	jal	80000a56 <kfree>
    8000126a:	bfc9                	j	8000123c <uvmunmap+0x46>
    8000126c:	74a2                	ld	s1,40(sp)
    8000126e:	7902                	ld	s2,32(sp)
    80001270:	69e2                	ld	s3,24(sp)
    80001272:	6a42                	ld	s4,16(sp)
    80001274:	6aa2                	ld	s5,8(sp)
    80001276:	6b02                	ld	s6,0(sp)
  }
}
    80001278:	70e2                	ld	ra,56(sp)
    8000127a:	7442                	ld	s0,48(sp)
    8000127c:	6121                	addi	sp,sp,64
    8000127e:	8082                	ret

0000000080001280 <uvmdealloc>:
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
  if (newsz >= oldsz)
    80001280:	04b67163          	bgeu	a2,a1,800012c2 <uvmdealloc+0x42>
{
    80001284:	1101                	addi	sp,sp,-32
    80001286:	ec06                	sd	ra,24(sp)
    80001288:	e822                	sd	s0,16(sp)
    8000128a:	e426                	sd	s1,8(sp)
    8000128c:	1000                	addi	s0,sp,32
    8000128e:	84b2                	mv	s1,a2
    return oldsz;

  if (PGROUNDUP(newsz) < PGROUNDUP(oldsz)) {
    80001290:	6785                	lui	a5,0x1
    80001292:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80001294:	00f60733          	add	a4,a2,a5
    80001298:	76fd                	lui	a3,0xfffff
    8000129a:	8f75                	and	a4,a4,a3
    8000129c:	97ae                	add	a5,a5,a1
    8000129e:	8ff5                	and	a5,a5,a3
    800012a0:	00f76863          	bltu	a4,a5,800012b0 <uvmdealloc+0x30>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
    800012a4:	8526                	mv	a0,s1
}
    800012a6:	60e2                	ld	ra,24(sp)
    800012a8:	6442                	ld	s0,16(sp)
    800012aa:	64a2                	ld	s1,8(sp)
    800012ac:	6105                	addi	sp,sp,32
    800012ae:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800012b0:	8f99                	sub	a5,a5,a4
    800012b2:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800012b4:	4685                	li	a3,1
    800012b6:	0007861b          	sext.w	a2,a5
    800012ba:	85ba                	mv	a1,a4
    800012bc:	f3bff0ef          	jal	800011f6 <uvmunmap>
    800012c0:	b7d5                	j	800012a4 <uvmdealloc+0x24>
    return oldsz;
    800012c2:	852e                	mv	a0,a1
}
    800012c4:	8082                	ret

00000000800012c6 <uvmalloc>:
  if (newsz < oldsz)
    800012c6:	08b66e63          	bltu	a2,a1,80001362 <uvmalloc+0x9c>
{
    800012ca:	715d                	addi	sp,sp,-80
    800012cc:	e486                	sd	ra,72(sp)
    800012ce:	e0a2                	sd	s0,64(sp)
    800012d0:	f052                	sd	s4,32(sp)
    800012d2:	ec56                	sd	s5,24(sp)
    800012d4:	e45e                	sd	s7,8(sp)
    800012d6:	0880                	addi	s0,sp,80
    800012d8:	8aaa                	mv	s5,a0
    800012da:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800012dc:	6785                	lui	a5,0x1
    800012de:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800012e0:	95be                	add	a1,a1,a5
    800012e2:	77fd                	lui	a5,0xfffff
    800012e4:	8fed                	and	a5,a5,a1
    800012e6:	8bbe                	mv	s7,a5
  for (a = oldsz; a < newsz; a += PGSIZE) {
    800012e8:	04c7f163          	bgeu	a5,a2,8000132a <uvmalloc+0x64>
    800012ec:	fc26                	sd	s1,56(sp)
    800012ee:	f84a                	sd	s2,48(sp)
    800012f0:	f44e                	sd	s3,40(sp)
    800012f2:	e85a                	sd	s6,16(sp)
    800012f4:	893e                	mv	s2,a5
    memset(mem, 0, PGSIZE);
    800012f6:	6985                	lui	s3,0x1
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    800012f8:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800012fc:	843ff0ef          	jal	80000b3e <kalloc>
    80001300:	84aa                	mv	s1,a0
    if (mem == 0) {
    80001302:	c515                	beqz	a0,8000132e <uvmalloc+0x68>
    memset(mem, 0, PGSIZE);
    80001304:	864e                	mv	a2,s3
    80001306:	4581                	li	a1,0
    80001308:	9cdff0ef          	jal	80000cd4 <memset>
    if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) !=
    8000130c:	875a                	mv	a4,s6
    8000130e:	86a6                	mv	a3,s1
    80001310:	864e                	mv	a2,s3
    80001312:	85ca                	mv	a1,s2
    80001314:	8556                	mv	a0,s5
    80001316:	d1bff0ef          	jal	80001030 <mappages>
    8000131a:	e91d                	bnez	a0,80001350 <uvmalloc+0x8a>
  for (a = oldsz; a < newsz; a += PGSIZE) {
    8000131c:	994e                	add	s2,s2,s3
    8000131e:	fd496fe3          	bltu	s2,s4,800012fc <uvmalloc+0x36>
    80001322:	74e2                	ld	s1,56(sp)
    80001324:	7942                	ld	s2,48(sp)
    80001326:	79a2                	ld	s3,40(sp)
    80001328:	6b42                	ld	s6,16(sp)
  return newsz;
    8000132a:	8552                	mv	a0,s4
    8000132c:	a819                	j	80001342 <uvmalloc+0x7c>
      uvmdealloc(pagetable, a, oldsz);
    8000132e:	865e                	mv	a2,s7
    80001330:	85ca                	mv	a1,s2
    80001332:	8556                	mv	a0,s5
    80001334:	f4dff0ef          	jal	80001280 <uvmdealloc>
      return 0;
    80001338:	4501                	li	a0,0
    8000133a:	74e2                	ld	s1,56(sp)
    8000133c:	7942                	ld	s2,48(sp)
    8000133e:	79a2                	ld	s3,40(sp)
    80001340:	6b42                	ld	s6,16(sp)
}
    80001342:	60a6                	ld	ra,72(sp)
    80001344:	6406                	ld	s0,64(sp)
    80001346:	7a02                	ld	s4,32(sp)
    80001348:	6ae2                	ld	s5,24(sp)
    8000134a:	6ba2                	ld	s7,8(sp)
    8000134c:	6161                	addi	sp,sp,80
    8000134e:	8082                	ret
      kfree(mem);
    80001350:	8526                	mv	a0,s1
    80001352:	f04ff0ef          	jal	80000a56 <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80001356:	865e                	mv	a2,s7
    80001358:	85ca                	mv	a1,s2
    8000135a:	8556                	mv	a0,s5
    8000135c:	f25ff0ef          	jal	80001280 <uvmdealloc>
      return 0;
    80001360:	bfe1                	j	80001338 <uvmalloc+0x72>
    return oldsz;
    80001362:	852e                	mv	a0,a1
}
    80001364:	8082                	ret

0000000080001366 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80001366:	7179                	addi	sp,sp,-48
    80001368:	f406                	sd	ra,40(sp)
    8000136a:	f022                	sd	s0,32(sp)
    8000136c:	ec26                	sd	s1,24(sp)
    8000136e:	e84a                	sd	s2,16(sp)
    80001370:	e44e                	sd	s3,8(sp)
    80001372:	1800                	addi	s0,sp,48
    80001374:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for (int i = 0; i < 512; i++) {
    80001376:	84aa                	mv	s1,a0
    80001378:	6905                	lui	s2,0x1
    8000137a:	992a                	add	s2,s2,a0
    8000137c:	a811                	j	80001390 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if (pte & PTE_V) {
      panic("freewalk: leaf");
    8000137e:	00006517          	auipc	a0,0x6
    80001382:	dba50513          	addi	a0,a0,-582 # 80007138 <etext+0x138>
    80001386:	cb4ff0ef          	jal	8000083a <panic>
  for (int i = 0; i < 512; i++) {
    8000138a:	04a1                	addi	s1,s1,8
    8000138c:	03248163          	beq	s1,s2,800013ae <freewalk+0x48>
    pte_t pte = pagetable[i];
    80001390:	609c                	ld	a5,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    80001392:	0017f713          	andi	a4,a5,1
    80001396:	db75                	beqz	a4,8000138a <freewalk+0x24>
    80001398:	00e7f713          	andi	a4,a5,14
    8000139c:	f36d                	bnez	a4,8000137e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000139e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    800013a0:	00c79513          	slli	a0,a5,0xc
    800013a4:	fc3ff0ef          	jal	80001366 <freewalk>
      pagetable[i] = 0;
    800013a8:	0004b023          	sd	zero,0(s1)
    if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0) {
    800013ac:	bff9                	j	8000138a <freewalk+0x24>
    }
  }
  kfree((void *)pagetable);
    800013ae:	854e                	mv	a0,s3
    800013b0:	ea6ff0ef          	jal	80000a56 <kfree>
}
    800013b4:	70a2                	ld	ra,40(sp)
    800013b6:	7402                	ld	s0,32(sp)
    800013b8:	64e2                	ld	s1,24(sp)
    800013ba:	6942                	ld	s2,16(sp)
    800013bc:	69a2                	ld	s3,8(sp)
    800013be:	6145                	addi	sp,sp,48
    800013c0:	8082                	ret

00000000800013c2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800013c2:	1101                	addi	sp,sp,-32
    800013c4:	ec06                	sd	ra,24(sp)
    800013c6:	e822                	sd	s0,16(sp)
    800013c8:	e426                	sd	s1,8(sp)
    800013ca:	1000                	addi	s0,sp,32
    800013cc:	84aa                	mv	s1,a0
  if (sz > 0)
    800013ce:	e989                	bnez	a1,800013e0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
  freewalk(pagetable);
    800013d0:	8526                	mv	a0,s1
    800013d2:	f95ff0ef          	jal	80001366 <freewalk>
}
    800013d6:	60e2                	ld	ra,24(sp)
    800013d8:	6442                	ld	s0,16(sp)
    800013da:	64a2                	ld	s1,8(sp)
    800013dc:	6105                	addi	sp,sp,32
    800013de:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800013e0:	6785                	lui	a5,0x1
    800013e2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800013e4:	95be                	add	a1,a1,a5
    800013e6:	4685                	li	a3,1
    800013e8:	00c5d613          	srli	a2,a1,0xc
    800013ec:	4581                	li	a1,0
    800013ee:	e09ff0ef          	jal	800011f6 <uvmunmap>
    800013f2:	bff9                	j	800013d0 <uvmfree+0xe>

00000000800013f4 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for (i = 0; i < sz; i += PGSIZE) {
    800013f4:	ca59                	beqz	a2,8000148a <uvmcopy+0x96>
{
    800013f6:	715d                	addi	sp,sp,-80
    800013f8:	e486                	sd	ra,72(sp)
    800013fa:	e0a2                	sd	s0,64(sp)
    800013fc:	fc26                	sd	s1,56(sp)
    800013fe:	f84a                	sd	s2,48(sp)
    80001400:	f44e                	sd	s3,40(sp)
    80001402:	f052                	sd	s4,32(sp)
    80001404:	ec56                	sd	s5,24(sp)
    80001406:	e85a                	sd	s6,16(sp)
    80001408:	e45e                	sd	s7,8(sp)
    8000140a:	0880                	addi	s0,sp,80
    8000140c:	8b2a                	mv	s6,a0
    8000140e:	8bae                	mv	s7,a1
    80001410:	8ab2                	mv	s5,a2
  for (i = 0; i < sz; i += PGSIZE) {
    80001412:	4481                	li	s1,0
      continue; // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if ((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char *)pa, PGSIZE);
    80001414:	6a05                	lui	s4,0x1
    80001416:	a021                	j	8000141e <uvmcopy+0x2a>
  for (i = 0; i < sz; i += PGSIZE) {
    80001418:	94d2                	add	s1,s1,s4
    8000141a:	0554fc63          	bgeu	s1,s5,80001472 <uvmcopy+0x7e>
    if ((pte = walk(old, i, 0)) == 0)
    8000141e:	4601                	li	a2,0
    80001420:	85a6                	mv	a1,s1
    80001422:	855a                	mv	a0,s6
    80001424:	b3dff0ef          	jal	80000f60 <walk>
    80001428:	d965                	beqz	a0,80001418 <uvmcopy+0x24>
    if ((*pte & PTE_V) == 0)
    8000142a:	00053983          	ld	s3,0(a0)
    8000142e:	0019f793          	andi	a5,s3,1
    80001432:	d3fd                	beqz	a5,80001418 <uvmcopy+0x24>
    if ((mem = kalloc()) == 0)
    80001434:	f0aff0ef          	jal	80000b3e <kalloc>
    80001438:	892a                	mv	s2,a0
    8000143a:	c11d                	beqz	a0,80001460 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000143c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char *)pa, PGSIZE);
    80001440:	8652                	mv	a2,s4
    80001442:	05b2                	slli	a1,a1,0xc
    80001444:	8edff0ef          	jal	80000d30 <memmove>
    if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0) {
    80001448:	3ff9f713          	andi	a4,s3,1023
    8000144c:	86ca                	mv	a3,s2
    8000144e:	8652                	mv	a2,s4
    80001450:	85a6                	mv	a1,s1
    80001452:	855e                	mv	a0,s7
    80001454:	bddff0ef          	jal	80001030 <mappages>
    80001458:	d161                	beqz	a0,80001418 <uvmcopy+0x24>
      kfree(mem);
    8000145a:	854a                	mv	a0,s2
    8000145c:	dfaff0ef          	jal	80000a56 <kfree>
    }
  }
  return 0;

err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80001460:	4685                	li	a3,1
    80001462:	00c4d613          	srli	a2,s1,0xc
    80001466:	4581                	li	a1,0
    80001468:	855e                	mv	a0,s7
    8000146a:	d8dff0ef          	jal	800011f6 <uvmunmap>
  return -1;
    8000146e:	557d                	li	a0,-1
    80001470:	a011                	j	80001474 <uvmcopy+0x80>
  return 0;
    80001472:	4501                	li	a0,0
}
    80001474:	60a6                	ld	ra,72(sp)
    80001476:	6406                	ld	s0,64(sp)
    80001478:	74e2                	ld	s1,56(sp)
    8000147a:	7942                	ld	s2,48(sp)
    8000147c:	79a2                	ld	s3,40(sp)
    8000147e:	7a02                	ld	s4,32(sp)
    80001480:	6ae2                	ld	s5,24(sp)
    80001482:	6b42                	ld	s6,16(sp)
    80001484:	6ba2                	ld	s7,8(sp)
    80001486:	6161                	addi	sp,sp,80
    80001488:	8082                	ret
  return 0;
    8000148a:	4501                	li	a0,0
}
    8000148c:	8082                	ret

000000008000148e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000148e:	1141                	addi	sp,sp,-16
    80001490:	e406                	sd	ra,8(sp)
    80001492:	e022                	sd	s0,0(sp)
    80001494:	0800                	addi	s0,sp,16
  pte_t *pte;

  pte = walk(pagetable, va, 0);
    80001496:	4601                	li	a2,0
    80001498:	ac9ff0ef          	jal	80000f60 <walk>
  if (pte == 0)
    8000149c:	c901                	beqz	a0,800014ac <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000149e:	611c                	ld	a5,0(a0)
    800014a0:	9bbd                	andi	a5,a5,-17
    800014a2:	e11c                	sd	a5,0(a0)
}
    800014a4:	60a2                	ld	ra,8(sp)
    800014a6:	6402                	ld	s0,0(sp)
    800014a8:	0141                	addi	sp,sp,16
    800014aa:	8082                	ret
    panic("uvmclear");
    800014ac:	00006517          	auipc	a0,0x6
    800014b0:	c9c50513          	addi	a0,a0,-868 # 80007148 <etext+0x148>
    800014b4:	b86ff0ef          	jal	8000083a <panic>

00000000800014b8 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while (got_null == 0 && max > 0) {
    800014b8:	cac5                	beqz	a3,80001568 <copyinstr+0xb0>
{
    800014ba:	715d                	addi	sp,sp,-80
    800014bc:	e486                	sd	ra,72(sp)
    800014be:	e0a2                	sd	s0,64(sp)
    800014c0:	fc26                	sd	s1,56(sp)
    800014c2:	f84a                	sd	s2,48(sp)
    800014c4:	f44e                	sd	s3,40(sp)
    800014c6:	f052                	sd	s4,32(sp)
    800014c8:	ec56                	sd	s5,24(sp)
    800014ca:	e85a                	sd	s6,16(sp)
    800014cc:	e45e                	sd	s7,8(sp)
    800014ce:	0880                	addi	s0,sp,80
    800014d0:	8aaa                	mv	s5,a0
    800014d2:	84ae                	mv	s1,a1
    800014d4:	8bb2                	mv	s7,a2
    800014d6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800014d8:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if (pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800014da:	6a05                	lui	s4,0x1
    800014dc:	a82d                	j	80001516 <copyinstr+0x5e>
      n = max;

    char *p = (char *)(pa0 + (srcva - va0));
    while (n > 0) {
      if (*p == '\0') {
        *dst = '\0';
    800014de:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800014e2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if (got_null) {
    800014e4:	0017c793          	xori	a5,a5,1
    800014e8:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800014ec:	60a6                	ld	ra,72(sp)
    800014ee:	6406                	ld	s0,64(sp)
    800014f0:	74e2                	ld	s1,56(sp)
    800014f2:	7942                	ld	s2,48(sp)
    800014f4:	79a2                	ld	s3,40(sp)
    800014f6:	7a02                	ld	s4,32(sp)
    800014f8:	6ae2                	ld	s5,24(sp)
    800014fa:	6b42                	ld	s6,16(sp)
    800014fc:	6ba2                	ld	s7,8(sp)
    800014fe:	6161                	addi	sp,sp,80
    80001500:	8082                	ret
    80001502:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80001506:	9726                	add	a4,a4,s1
      --max;
    80001508:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    8000150c:	01490bb3          	add	s7,s2,s4
  while (got_null == 0 && max > 0) {
    80001510:	04e58463          	beq	a1,a4,80001558 <copyinstr+0xa0>
{
    80001514:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80001516:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    8000151a:	85ca                	mv	a1,s2
    8000151c:	8556                	mv	a0,s5
    8000151e:	adbff0ef          	jal	80000ff8 <walkaddr>
    if (pa0 == 0)
    80001522:	cd0d                	beqz	a0,8000155c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80001524:	41790633          	sub	a2,s2,s7
    80001528:	9652                	add	a2,a2,s4
    if (n > max)
    8000152a:	00c9f363          	bgeu	s3,a2,80001530 <copyinstr+0x78>
    8000152e:	864e                	mv	a2,s3
    while (n > 0) {
    80001530:	ca05                	beqz	a2,80001560 <copyinstr+0xa8>
    char *p = (char *)(pa0 + (srcva - va0));
    80001532:	034b9693          	slli	a3,s7,0x34
    80001536:	92d1                	srli	a3,a3,0x34
    80001538:	96aa                	add	a3,a3,a0
    8000153a:	87a6                	mv	a5,s1
      if (*p == '\0') {
    8000153c:	8e85                	sub	a3,a3,s1
    while (n > 0) {
    8000153e:	9626                	add	a2,a2,s1
    80001540:	85be                	mv	a1,a5
      if (*p == '\0') {
    80001542:	00f68733          	add	a4,a3,a5
    80001546:	00074703          	lbu	a4,0(a4)
    8000154a:	db51                	beqz	a4,800014de <copyinstr+0x26>
        *dst = *p;
    8000154c:	00e78023          	sb	a4,0(a5)
      dst++;
    80001550:	0785                	addi	a5,a5,1
    while (n > 0) {
    80001552:	fec797e3          	bne	a5,a2,80001540 <copyinstr+0x88>
    80001556:	b775                	j	80001502 <copyinstr+0x4a>
    srcva = va0 + PGSIZE;
    80001558:	4781                	li	a5,0
    8000155a:	b769                	j	800014e4 <copyinstr+0x2c>
      return -1;
    8000155c:	557d                	li	a0,-1
    8000155e:	b779                	j	800014ec <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80001560:	6b85                	lui	s7,0x1
    80001562:	9bca                	add	s7,s7,s2
    80001564:	87a6                	mv	a5,s1
    80001566:	b77d                	j	80001514 <copyinstr+0x5c>
    80001568:	4781                	li	a5,0
  if (got_null) {
    8000156a:	0017c793          	xori	a5,a5,1
    8000156e:	40f0053b          	negw	a0,a5
}
    80001572:	8082                	ret

0000000080001574 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80001574:	1141                	addi	sp,sp,-16
    80001576:	e406                	sd	ra,8(sp)
    80001578:	e022                	sd	s0,0(sp)
    8000157a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    8000157c:	4601                	li	a2,0
    8000157e:	9e3ff0ef          	jal	80000f60 <walk>
  if (pte == 0) {
    80001582:	c119                	beqz	a0,80001588 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V) {
    80001584:	6108                	ld	a0,0(a0)
    80001586:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80001588:	60a2                	ld	ra,8(sp)
    8000158a:	6402                	ld	s0,0(sp)
    8000158c:	0141                	addi	sp,sp,16
    8000158e:	8082                	ret

0000000080001590 <vmfault>:
{
    80001590:	7179                	addi	sp,sp,-48
    80001592:	f406                	sd	ra,40(sp)
    80001594:	f022                	sd	s0,32(sp)
    80001596:	e84a                	sd	s2,16(sp)
    80001598:	e052                	sd	s4,0(sp)
    8000159a:	1800                	addi	s0,sp,48
    8000159c:	8a2a                	mv	s4,a0
    8000159e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800015a0:	33e000ef          	jal	800018de <myproc>
  if (va >= p->sz)
    800015a4:	653c                	ld	a5,72(a0)
    800015a6:	00f96d63          	bltu	s2,a5,800015c0 <vmfault+0x30>
    return 0;
    800015aa:	4a01                	li	s4,0
}
    800015ac:	8552                	mv	a0,s4
    800015ae:	70a2                	ld	ra,40(sp)
    800015b0:	7402                	ld	s0,32(sp)
    800015b2:	6942                	ld	s2,16(sp)
    800015b4:	6a02                	ld	s4,0(sp)
    800015b6:	6145                	addi	sp,sp,48
    800015b8:	8082                	ret
    800015ba:	64e2                	ld	s1,24(sp)
    800015bc:	69a2                	ld	s3,8(sp)
    800015be:	b7f5                	j	800015aa <vmfault+0x1a>
    800015c0:	ec26                	sd	s1,24(sp)
    800015c2:	e44e                	sd	s3,8(sp)
    800015c4:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    800015c6:	77fd                	lui	a5,0xfffff
    800015c8:	00f979b3          	and	s3,s2,a5
  if (ismapped(pagetable, va)) {
    800015cc:	85ce                	mv	a1,s3
    800015ce:	8552                	mv	a0,s4
    800015d0:	fa5ff0ef          	jal	80001574 <ismapped>
    800015d4:	c501                	beqz	a0,800015dc <vmfault+0x4c>
    800015d6:	64e2                	ld	s1,24(sp)
    800015d8:	69a2                	ld	s3,8(sp)
    800015da:	bfc1                	j	800015aa <vmfault+0x1a>
  mem = (uint64)kalloc();
    800015dc:	d62ff0ef          	jal	80000b3e <kalloc>
    800015e0:	892a                	mv	s2,a0
  if (mem == 0)
    800015e2:	dd61                	beqz	a0,800015ba <vmfault+0x2a>
  mem = (uint64)kalloc();
    800015e4:	8a2a                	mv	s4,a0
  memset((void *)mem, 0, PGSIZE);
    800015e6:	6605                	lui	a2,0x1
    800015e8:	4581                	li	a1,0
    800015ea:	eeaff0ef          	jal	80000cd4 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W | PTE_U | PTE_R) != 0) {
    800015ee:	4759                	li	a4,22
    800015f0:	86ca                	mv	a3,s2
    800015f2:	6605                	lui	a2,0x1
    800015f4:	85ce                	mv	a1,s3
    800015f6:	68a8                	ld	a0,80(s1)
    800015f8:	a39ff0ef          	jal	80001030 <mappages>
    800015fc:	e501                	bnez	a0,80001604 <vmfault+0x74>
    800015fe:	64e2                	ld	s1,24(sp)
    80001600:	69a2                	ld	s3,8(sp)
    80001602:	b76d                	j	800015ac <vmfault+0x1c>
    kfree((void *)mem);
    80001604:	854a                	mv	a0,s2
    80001606:	c50ff0ef          	jal	80000a56 <kfree>
    return 0;
    8000160a:	64e2                	ld	s1,24(sp)
    8000160c:	69a2                	ld	s3,8(sp)
    8000160e:	bf71                	j	800015aa <vmfault+0x1a>

0000000080001610 <copyout>:
  while (len > 0) {
    80001610:	cad5                	beqz	a3,800016c4 <copyout+0xb4>
{
    80001612:	711d                	addi	sp,sp,-96
    80001614:	ec86                	sd	ra,88(sp)
    80001616:	e8a2                	sd	s0,80(sp)
    80001618:	e4a6                	sd	s1,72(sp)
    8000161a:	e0ca                	sd	s2,64(sp)
    8000161c:	fc4e                	sd	s3,56(sp)
    8000161e:	f852                	sd	s4,48(sp)
    80001620:	f456                	sd	s5,40(sp)
    80001622:	f05a                	sd	s6,32(sp)
    80001624:	ec5e                	sd	s7,24(sp)
    80001626:	e862                	sd	s8,16(sp)
    80001628:	e466                	sd	s9,8(sp)
    8000162a:	e06a                	sd	s10,0(sp)
    8000162c:	1080                	addi	s0,sp,96
    8000162e:	8baa                	mv	s7,a0
    80001630:	84ae                	mv	s1,a1
    80001632:	8b32                	mv	s6,a2
    80001634:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80001636:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80001638:	5cfd                	li	s9,-1
    8000163a:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    8000163e:	6c05                	lui	s8,0x1
    80001640:	a081                	j	80001680 <copyout+0x70>
      return -1;
    80001642:	557d                	li	a0,-1
}
    80001644:	60e6                	ld	ra,88(sp)
    80001646:	6446                	ld	s0,80(sp)
    80001648:	64a6                	ld	s1,72(sp)
    8000164a:	6906                	ld	s2,64(sp)
    8000164c:	79e2                	ld	s3,56(sp)
    8000164e:	7a42                	ld	s4,48(sp)
    80001650:	7aa2                	ld	s5,40(sp)
    80001652:	7b02                	ld	s6,32(sp)
    80001654:	6be2                	ld	s7,24(sp)
    80001656:	6c42                	ld	s8,16(sp)
    80001658:	6ca2                	ld	s9,8(sp)
    8000165a:	6d02                	ld	s10,0(sp)
    8000165c:	6125                	addi	sp,sp,96
    8000165e:	8082                	ret
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001660:	03449513          	slli	a0,s1,0x34
    80001664:	9151                	srli	a0,a0,0x34
    80001666:	0009061b          	sext.w	a2,s2
    8000166a:	85da                	mv	a1,s6
    8000166c:	954e                	add	a0,a0,s3
    8000166e:	ec2ff0ef          	jal	80000d30 <memmove>
    len -= n;
    80001672:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80001676:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80001678:	018a04b3          	add	s1,s4,s8
  while (len > 0) {
    8000167c:	040a8263          	beqz	s5,800016c0 <copyout+0xb0>
    va0 = PGROUNDDOWN(dstva);
    80001680:	01a4fa33          	and	s4,s1,s10
    if (va0 >= MAXVA)
    80001684:	fb4cefe3          	bltu	s9,s4,80001642 <copyout+0x32>
    pa0 = walkaddr(pagetable, va0);
    80001688:	85d2                	mv	a1,s4
    8000168a:	855e                	mv	a0,s7
    8000168c:	96dff0ef          	jal	80000ff8 <walkaddr>
    80001690:	89aa                	mv	s3,a0
    if (pa0 == 0) {
    80001692:	e901                	bnez	a0,800016a2 <copyout+0x92>
      if ((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80001694:	4601                	li	a2,0
    80001696:	85d2                	mv	a1,s4
    80001698:	855e                	mv	a0,s7
    8000169a:	ef7ff0ef          	jal	80001590 <vmfault>
    8000169e:	89aa                	mv	s3,a0
    800016a0:	d14d                	beqz	a0,80001642 <copyout+0x32>
    pte = walk(pagetable, va0, 0);
    800016a2:	4601                	li	a2,0
    800016a4:	85d2                	mv	a1,s4
    800016a6:	855e                	mv	a0,s7
    800016a8:	8b9ff0ef          	jal	80000f60 <walk>
    if ((*pte & PTE_W) == 0)
    800016ac:	611c                	ld	a5,0(a0)
    800016ae:	8b91                	andi	a5,a5,4
    800016b0:	dbc9                	beqz	a5,80001642 <copyout+0x32>
    n = PGSIZE - (dstva - va0);
    800016b2:	409a0933          	sub	s2,s4,s1
    800016b6:	9962                	add	s2,s2,s8
    if (n > len)
    800016b8:	fb2af4e3          	bgeu	s5,s2,80001660 <copyout+0x50>
    800016bc:	8956                	mv	s2,s5
    800016be:	b74d                	j	80001660 <copyout+0x50>
  return 0;
    800016c0:	4501                	li	a0,0
    800016c2:	b749                	j	80001644 <copyout+0x34>
    800016c4:	4501                	li	a0,0
}
    800016c6:	8082                	ret

00000000800016c8 <copyin>:
  while (len > 0) {
    800016c8:	cac9                	beqz	a3,8000175a <copyin+0x92>
{
    800016ca:	711d                	addi	sp,sp,-96
    800016cc:	ec86                	sd	ra,88(sp)
    800016ce:	e8a2                	sd	s0,80(sp)
    800016d0:	e4a6                	sd	s1,72(sp)
    800016d2:	e0ca                	sd	s2,64(sp)
    800016d4:	fc4e                	sd	s3,56(sp)
    800016d6:	f852                	sd	s4,48(sp)
    800016d8:	f456                	sd	s5,40(sp)
    800016da:	f05a                	sd	s6,32(sp)
    800016dc:	ec5e                	sd	s7,24(sp)
    800016de:	e862                	sd	s8,16(sp)
    800016e0:	e466                	sd	s9,8(sp)
    800016e2:	1080                	addi	s0,sp,96
    800016e4:	8baa                	mv	s7,a0
    800016e6:	8aae                	mv	s5,a1
    800016e8:	84b2                	mv	s1,a2
    800016ea:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800016ec:	7c7d                	lui	s8,0xfffff
      if ((pa0 = vmfault(pagetable, va0, 1)) == 0) {
    800016ee:	4c85                	li	s9,1
    n = PGSIZE - (srcva - va0);
    800016f0:	6b05                	lui	s6,0x1
    800016f2:	a03d                	j	80001720 <copyin+0x58>
    800016f4:	409a0933          	sub	s2,s4,s1
    800016f8:	995a                	add	s2,s2,s6
    if (n > len)
    800016fa:	0129f363          	bgeu	s3,s2,80001700 <copyin+0x38>
    800016fe:	894e                	mv	s2,s3
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001700:	03449593          	slli	a1,s1,0x34
    80001704:	91d1                	srli	a1,a1,0x34
    80001706:	0009061b          	sext.w	a2,s2
    8000170a:	95aa                	add	a1,a1,a0
    8000170c:	8556                	mv	a0,s5
    8000170e:	e22ff0ef          	jal	80000d30 <memmove>
    len -= n;
    80001712:	412989b3          	sub	s3,s3,s2
    dst += n;
    80001716:	9aca                	add	s5,s5,s2
    srcva = va0 + PGSIZE;
    80001718:	016a04b3          	add	s1,s4,s6
  while (len > 0) {
    8000171c:	02098163          	beqz	s3,8000173e <copyin+0x76>
    va0 = PGROUNDDOWN(srcva);
    80001720:	0184fa33          	and	s4,s1,s8
    pa0 = walkaddr(pagetable, va0);
    80001724:	85d2                	mv	a1,s4
    80001726:	855e                	mv	a0,s7
    80001728:	8d1ff0ef          	jal	80000ff8 <walkaddr>
    if (pa0 == 0) {
    8000172c:	f561                	bnez	a0,800016f4 <copyin+0x2c>
      if ((pa0 = vmfault(pagetable, va0, 1)) == 0) {
    8000172e:	8666                	mv	a2,s9
    80001730:	85d2                	mv	a1,s4
    80001732:	855e                	mv	a0,s7
    80001734:	e5dff0ef          	jal	80001590 <vmfault>
    80001738:	fd55                	bnez	a0,800016f4 <copyin+0x2c>
        return -1;
    8000173a:	557d                	li	a0,-1
    8000173c:	a011                	j	80001740 <copyin+0x78>
  return 0;
    8000173e:	4501                	li	a0,0
}
    80001740:	60e6                	ld	ra,88(sp)
    80001742:	6446                	ld	s0,80(sp)
    80001744:	64a6                	ld	s1,72(sp)
    80001746:	6906                	ld	s2,64(sp)
    80001748:	79e2                	ld	s3,56(sp)
    8000174a:	7a42                	ld	s4,48(sp)
    8000174c:	7aa2                	ld	s5,40(sp)
    8000174e:	7b02                	ld	s6,32(sp)
    80001750:	6be2                	ld	s7,24(sp)
    80001752:	6c42                	ld	s8,16(sp)
    80001754:	6ca2                	ld	s9,8(sp)
    80001756:	6125                	addi	sp,sp,96
    80001758:	8082                	ret
  return 0;
    8000175a:	4501                	li	a0,0
}
    8000175c:	8082                	ret

000000008000175e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    8000175e:	715d                	addi	sp,sp,-80
    80001760:	e486                	sd	ra,72(sp)
    80001762:	e0a2                	sd	s0,64(sp)
    80001764:	fc26                	sd	s1,56(sp)
    80001766:	f84a                	sd	s2,48(sp)
    80001768:	f44e                	sd	s3,40(sp)
    8000176a:	f052                	sd	s4,32(sp)
    8000176c:	ec56                	sd	s5,24(sp)
    8000176e:	e85a                	sd	s6,16(sp)
    80001770:	e45e                	sd	s7,8(sp)
    80001772:	0880                	addi	s0,sp,80
    80001774:	8aaa                	mv	s5,a0
    80001776:	4481                	li	s1,0

  for (p = proc; p < &proc[NPROC]; p++) {
    char *pa = kalloc();
    if (pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int)(p - proc));
    80001778:	ff4df937          	lui	s2,0xff4df
    8000177c:	9bd90913          	addi	s2,s2,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bda35>
    80001780:	0936                	slli	s2,s2,0xd
    80001782:	6f590913          	addi	s2,s2,1781
    80001786:	0936                	slli	s2,s2,0xd
    80001788:	bd390913          	addi	s2,s2,-1069
    8000178c:	0932                	slli	s2,s2,0xc
    8000178e:	7a790913          	addi	s2,s2,1959
    80001792:	040009b7          	lui	s3,0x4000
    80001796:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001798:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    8000179a:	4b99                	li	s7,6
    8000179c:	6b05                	lui	s6,0x1
  for (p = proc; p < &proc[NPROC]; p++) {
    8000179e:	6a19                	lui	s4,0x6
    800017a0:	c00a0a13          	addi	s4,s4,-1024 # 5c00 <_entry-0x7fffa400>
    char *pa = kalloc();
    800017a4:	b9aff0ef          	jal	80000b3e <kalloc>
    800017a8:	862a                	mv	a2,a0
    if (pa == 0)
    800017aa:	cd15                	beqz	a0,800017e6 <proc_mapstacks+0x88>
    uint64 va = KSTACK((int)(p - proc));
    800017ac:	4044d593          	srai	a1,s1,0x4
    800017b0:	032585b3          	mul	a1,a1,s2
    800017b4:	05b6                	slli	a1,a1,0xd
    800017b6:	6789                	lui	a5,0x2
    800017b8:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    800017ba:	875e                	mv	a4,s7
    800017bc:	86da                	mv	a3,s6
    800017be:	40b985b3          	sub	a1,s3,a1
    800017c2:	8556                	mv	a0,s5
    800017c4:	91fff0ef          	jal	800010e2 <kvmmap>
  for (p = proc; p < &proc[NPROC]; p++) {
    800017c8:	17048493          	addi	s1,s1,368
    800017cc:	fd449ce3          	bne	s1,s4,800017a4 <proc_mapstacks+0x46>
  }
}
    800017d0:	60a6                	ld	ra,72(sp)
    800017d2:	6406                	ld	s0,64(sp)
    800017d4:	74e2                	ld	s1,56(sp)
    800017d6:	7942                	ld	s2,48(sp)
    800017d8:	79a2                	ld	s3,40(sp)
    800017da:	7a02                	ld	s4,32(sp)
    800017dc:	6ae2                	ld	s5,24(sp)
    800017de:	6b42                	ld	s6,16(sp)
    800017e0:	6ba2                	ld	s7,8(sp)
    800017e2:	6161                	addi	sp,sp,80
    800017e4:	8082                	ret
      panic("kalloc");
    800017e6:	00006517          	auipc	a0,0x6
    800017ea:	97250513          	addi	a0,a0,-1678 # 80007158 <etext+0x158>
    800017ee:	84cff0ef          	jal	8000083a <panic>

00000000800017f2 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    800017f2:	7139                	addi	sp,sp,-64
    800017f4:	fc06                	sd	ra,56(sp)
    800017f6:	f822                	sd	s0,48(sp)
    800017f8:	f426                	sd	s1,40(sp)
    800017fa:	f04a                	sd	s2,32(sp)
    800017fc:	ec4e                	sd	s3,24(sp)
    800017fe:	e852                	sd	s4,16(sp)
    80001800:	e456                	sd	s5,8(sp)
    80001802:	e05a                	sd	s6,0(sp)
    80001804:	0080                	addi	s0,sp,64
  struct proc *p;

  initlock(&pid_lock, "nextpid");
    80001806:	00006597          	auipc	a1,0x6
    8000180a:	95a58593          	addi	a1,a1,-1702 # 80007160 <etext+0x160>
    8000180e:	0000e517          	auipc	a0,0xe
    80001812:	34a50513          	addi	a0,a0,842 # 8000fb58 <pid_lock>
    80001816:	b82ff0ef          	jal	80000b98 <initlock>
  initlock(&wait_lock, "wait_lock");
    8000181a:	00006597          	auipc	a1,0x6
    8000181e:	94e58593          	addi	a1,a1,-1714 # 80007168 <etext+0x168>
    80001822:	0000e517          	auipc	a0,0xe
    80001826:	34e50513          	addi	a0,a0,846 # 8000fb70 <wait_lock>
    8000182a:	b6eff0ef          	jal	80000b98 <initlock>
    8000182e:	4901                	li	s2,0
  for (p = proc; p < &proc[NPROC]; p++) {
    80001830:	0000e497          	auipc	s1,0xe
    80001834:	75848493          	addi	s1,s1,1880 # 8000ff88 <proc>
    initlock(&p->lock, "proc");
    80001838:	00006a97          	auipc	s5,0x6
    8000183c:	940a8a93          	addi	s5,s5,-1728 # 80007178 <etext+0x178>
    p->state = UNUSED;
    p->kstack = KSTACK((int)(p - proc));
    80001840:	ff4df9b7          	lui	s3,0xff4df
    80001844:	9bd98993          	addi	s3,s3,-1603 # ffffffffff4de9bd <end+0xffffffff7f4bda35>
    80001848:	09b6                	slli	s3,s3,0xd
    8000184a:	6f598993          	addi	s3,s3,1781
    8000184e:	09b6                	slli	s3,s3,0xd
    80001850:	bd398993          	addi	s3,s3,-1069
    80001854:	09b2                	slli	s3,s3,0xc
    80001856:	7a798993          	addi	s3,s3,1959
    8000185a:	04000a37          	lui	s4,0x4000
    8000185e:	1a7d                	addi	s4,s4,-1 # 3ffffff <_entry-0x7c000001>
    80001860:	0a32                	slli	s4,s4,0xc
  for (p = proc; p < &proc[NPROC]; p++) {
    80001862:	00014b17          	auipc	s6,0x14
    80001866:	326b0b13          	addi	s6,s6,806 # 80015b88 <tickslock>
    initlock(&p->lock, "proc");
    8000186a:	85d6                	mv	a1,s5
    8000186c:	8526                	mv	a0,s1
    8000186e:	b2aff0ef          	jal	80000b98 <initlock>
    p->state = UNUSED;
    80001872:	0004ac23          	sw	zero,24(s1)
    p->kstack = KSTACK((int)(p - proc));
    80001876:	40495793          	srai	a5,s2,0x4
    8000187a:	033787b3          	mul	a5,a5,s3
    8000187e:	07b6                	slli	a5,a5,0xd
    80001880:	6709                	lui	a4,0x2
    80001882:	9fb9                	addw	a5,a5,a4
    80001884:	40fa07b3          	sub	a5,s4,a5
    80001888:	e0bc                	sd	a5,64(s1)
  for (p = proc; p < &proc[NPROC]; p++) {
    8000188a:	17048493          	addi	s1,s1,368
    8000188e:	17090913          	addi	s2,s2,368
    80001892:	fd649ce3          	bne	s1,s6,8000186a <procinit+0x78>
  }
}
    80001896:	70e2                	ld	ra,56(sp)
    80001898:	7442                	ld	s0,48(sp)
    8000189a:	74a2                	ld	s1,40(sp)
    8000189c:	7902                	ld	s2,32(sp)
    8000189e:	69e2                	ld	s3,24(sp)
    800018a0:	6a42                	ld	s4,16(sp)
    800018a2:	6aa2                	ld	s5,8(sp)
    800018a4:	6b02                	ld	s6,0(sp)
    800018a6:	6121                	addi	sp,sp,64
    800018a8:	8082                	ret

00000000800018aa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800018aa:	1141                	addi	sp,sp,-16
    800018ac:	e406                	sd	ra,8(sp)
    800018ae:	e022                	sd	s0,0(sp)
    800018b0:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r"(x));
    800018b2:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800018b4:	2501                	sext.w	a0,a0
    800018b6:	60a2                	ld	ra,8(sp)
    800018b8:	6402                	ld	s0,0(sp)
    800018ba:	0141                	addi	sp,sp,16
    800018bc:	8082                	ret

00000000800018be <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    800018be:	1141                	addi	sp,sp,-16
    800018c0:	e406                	sd	ra,8(sp)
    800018c2:	e022                	sd	s0,0(sp)
    800018c4:	0800                	addi	s0,sp,16
    800018c6:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800018c8:	2781                	sext.w	a5,a5
    800018ca:	079e                	slli	a5,a5,0x7
  return c;
}
    800018cc:	0000e517          	auipc	a0,0xe
    800018d0:	2bc50513          	addi	a0,a0,700 # 8000fb88 <cpus>
    800018d4:	953e                	add	a0,a0,a5
    800018d6:	60a2                	ld	ra,8(sp)
    800018d8:	6402                	ld	s0,0(sp)
    800018da:	0141                	addi	sp,sp,16
    800018dc:	8082                	ret

00000000800018de <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    800018de:	1101                	addi	sp,sp,-32
    800018e0:	ec06                	sd	ra,24(sp)
    800018e2:	e822                	sd	s0,16(sp)
    800018e4:	e426                	sd	s1,8(sp)
    800018e6:	1000                	addi	s0,sp,32
  push_off();
    800018e8:	af6ff0ef          	jal	80000bde <push_off>
    800018ec:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    800018ee:	2781                	sext.w	a5,a5
    800018f0:	079e                	slli	a5,a5,0x7
    800018f2:	0000e717          	auipc	a4,0xe
    800018f6:	26670713          	addi	a4,a4,614 # 8000fb58 <pid_lock>
    800018fa:	97ba                	add	a5,a5,a4
    800018fc:	7b9c                	ld	a5,48(a5)
    800018fe:	84be                	mv	s1,a5
  pop_off();
    80001900:	b54ff0ef          	jal	80000c54 <pop_off>
  return p;
}
    80001904:	8526                	mv	a0,s1
    80001906:	60e2                	ld	ra,24(sp)
    80001908:	6442                	ld	s0,16(sp)
    8000190a:	64a2                	ld	s1,8(sp)
    8000190c:	6105                	addi	sp,sp,32
    8000190e:	8082                	ret

0000000080001910 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001910:	7179                	addi	sp,sp,-48
    80001912:	f406                	sd	ra,40(sp)
    80001914:	f022                	sd	s0,32(sp)
    80001916:	ec26                	sd	s1,24(sp)
    80001918:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000191a:	fc5ff0ef          	jal	800018de <myproc>
    8000191e:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001920:	b7cff0ef          	jal	80000c9c <release>

  if (first) {
    80001924:	00006797          	auipc	a5,0x6
    80001928:	0fc7a783          	lw	a5,252(a5) # 80007a20 <first.1>
    8000192c:	cf95                	beqz	a5,80001968 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000192e:	4505                	li	a0,1
    80001930:	44f010ef          	jal	8000357e <fsinit>

    first = 0;
    80001934:	00006797          	auipc	a5,0x6
    80001938:	0e07a623          	sw	zero,236(a5) # 80007a20 <first.1>
    // ensure other cores see first=0.
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    8000193c:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){"/init", 0});
    80001940:	00006797          	auipc	a5,0x6
    80001944:	84078793          	addi	a5,a5,-1984 # 80007180 <etext+0x180>
    80001948:	fcf43823          	sd	a5,-48(s0)
    8000194c:	fc043c23          	sd	zero,-40(s0)
    80001950:	fd040593          	addi	a1,s0,-48
    80001954:	853e                	mv	a0,a5
    80001956:	609020ef          	jal	8000475e <kexec>
    8000195a:	6cbc                	ld	a5,88(s1)
    8000195c:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000195e:	6cbc                	ld	a5,88(s1)
    80001960:	7bb8                	ld	a4,112(a5)
    80001962:	57fd                	li	a5,-1
    80001964:	02f70d63          	beq	a4,a5,8000199e <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001968:	2a7000ef          	jal	8000240e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000196c:	68a8                	ld	a0,80(s1)
    8000196e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001970:	04000737          	lui	a4,0x4000
    80001974:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001976:	0732                	slli	a4,a4,0xc
    80001978:	00004797          	auipc	a5,0x4
    8000197c:	72478793          	addi	a5,a5,1828 # 8000609c <userret>
    80001980:	00004697          	auipc	a3,0x4
    80001984:	68068693          	addi	a3,a3,1664 # 80006000 <_trampoline>
    80001988:	8f95                	sub	a5,a5,a3
    8000198a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000198c:	577d                	li	a4,-1
    8000198e:	177e                	slli	a4,a4,0x3f
    80001990:	8d59                	or	a0,a0,a4
    80001992:	9782                	jalr	a5
}
    80001994:	70a2                	ld	ra,40(sp)
    80001996:	7402                	ld	s0,32(sp)
    80001998:	64e2                	ld	s1,24(sp)
    8000199a:	6145                	addi	sp,sp,48
    8000199c:	8082                	ret
      panic("exec");
    8000199e:	00005517          	auipc	a0,0x5
    800019a2:	7ea50513          	addi	a0,a0,2026 # 80007188 <etext+0x188>
    800019a6:	e95fe0ef          	jal	8000083a <panic>

00000000800019aa <allocpid>:
{
    800019aa:	1101                	addi	sp,sp,-32
    800019ac:	ec06                	sd	ra,24(sp)
    800019ae:	e822                	sd	s0,16(sp)
    800019b0:	e426                	sd	s1,8(sp)
    800019b2:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800019b4:	0000e517          	auipc	a0,0xe
    800019b8:	1a450513          	addi	a0,a0,420 # 8000fb58 <pid_lock>
    800019bc:	a5cff0ef          	jal	80000c18 <acquire>
  pid = nextpid;
    800019c0:	00006797          	auipc	a5,0x6
    800019c4:	06478793          	addi	a5,a5,100 # 80007a24 <nextpid>
    800019c8:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800019ca:	0014871b          	addiw	a4,s1,1
    800019ce:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800019d0:	0000e517          	auipc	a0,0xe
    800019d4:	18850513          	addi	a0,a0,392 # 8000fb58 <pid_lock>
    800019d8:	ac4ff0ef          	jal	80000c9c <release>
}
    800019dc:	8526                	mv	a0,s1
    800019de:	60e2                	ld	ra,24(sp)
    800019e0:	6442                	ld	s0,16(sp)
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	6105                	addi	sp,sp,32
    800019e6:	8082                	ret

00000000800019e8 <proc_pagetable>:
{
    800019e8:	1101                	addi	sp,sp,-32
    800019ea:	ec06                	sd	ra,24(sp)
    800019ec:	e822                	sd	s0,16(sp)
    800019ee:	e426                	sd	s1,8(sp)
    800019f0:	e04a                	sd	s2,0(sp)
    800019f2:	1000                	addi	s0,sp,32
    800019f4:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    800019f6:	fdaff0ef          	jal	800011d0 <uvmcreate>
    800019fa:	84aa                	mv	s1,a0
  if (pagetable == 0)
    800019fc:	cd05                	beqz	a0,80001a34 <proc_pagetable+0x4c>
  if (mappages(pagetable, TRAMPOLINE, PGSIZE, (uint64)trampoline,
    800019fe:	4729                	li	a4,10
    80001a00:	00004697          	auipc	a3,0x4
    80001a04:	60068693          	addi	a3,a3,1536 # 80006000 <_trampoline>
    80001a08:	6605                	lui	a2,0x1
    80001a0a:	040005b7          	lui	a1,0x4000
    80001a0e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a10:	05b2                	slli	a1,a1,0xc
    80001a12:	e1eff0ef          	jal	80001030 <mappages>
    80001a16:	02054663          	bltz	a0,80001a42 <proc_pagetable+0x5a>
  if (mappages(pagetable, TRAPFRAME, PGSIZE, (uint64)(p->trapframe),
    80001a1a:	4719                	li	a4,6
    80001a1c:	05893683          	ld	a3,88(s2)
    80001a20:	6605                	lui	a2,0x1
    80001a22:	020005b7          	lui	a1,0x2000
    80001a26:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a28:	05b6                	slli	a1,a1,0xd
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	e04ff0ef          	jal	80001030 <mappages>
    80001a30:	00054f63          	bltz	a0,80001a4e <proc_pagetable+0x66>
}
    80001a34:	8526                	mv	a0,s1
    80001a36:	60e2                	ld	ra,24(sp)
    80001a38:	6442                	ld	s0,16(sp)
    80001a3a:	64a2                	ld	s1,8(sp)
    80001a3c:	6902                	ld	s2,0(sp)
    80001a3e:	6105                	addi	sp,sp,32
    80001a40:	8082                	ret
    uvmfree(pagetable, 0);
    80001a42:	4581                	li	a1,0
    80001a44:	8526                	mv	a0,s1
    80001a46:	97dff0ef          	jal	800013c2 <uvmfree>
    return 0;
    80001a4a:	4481                	li	s1,0
    80001a4c:	b7e5                	j	80001a34 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a4e:	4681                	li	a3,0
    80001a50:	4605                	li	a2,1
    80001a52:	040005b7          	lui	a1,0x4000
    80001a56:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a58:	05b2                	slli	a1,a1,0xc
    80001a5a:	8526                	mv	a0,s1
    80001a5c:	f9aff0ef          	jal	800011f6 <uvmunmap>
    uvmfree(pagetable, 0);
    80001a60:	4581                	li	a1,0
    80001a62:	8526                	mv	a0,s1
    80001a64:	95fff0ef          	jal	800013c2 <uvmfree>
    return 0;
    80001a68:	b7cd                	j	80001a4a <proc_pagetable+0x62>

0000000080001a6a <proc_freepagetable>:
{
    80001a6a:	1101                	addi	sp,sp,-32
    80001a6c:	ec06                	sd	ra,24(sp)
    80001a6e:	e822                	sd	s0,16(sp)
    80001a70:	e426                	sd	s1,8(sp)
    80001a72:	e04a                	sd	s2,0(sp)
    80001a74:	1000                	addi	s0,sp,32
    80001a76:	84aa                	mv	s1,a0
    80001a78:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001a7a:	4681                	li	a3,0
    80001a7c:	4605                	li	a2,1
    80001a7e:	040005b7          	lui	a1,0x4000
    80001a82:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001a84:	05b2                	slli	a1,a1,0xc
    80001a86:	f70ff0ef          	jal	800011f6 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001a8a:	4681                	li	a3,0
    80001a8c:	4605                	li	a2,1
    80001a8e:	020005b7          	lui	a1,0x2000
    80001a92:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001a94:	05b6                	slli	a1,a1,0xd
    80001a96:	8526                	mv	a0,s1
    80001a98:	f5eff0ef          	jal	800011f6 <uvmunmap>
  uvmfree(pagetable, sz);
    80001a9c:	85ca                	mv	a1,s2
    80001a9e:	8526                	mv	a0,s1
    80001aa0:	923ff0ef          	jal	800013c2 <uvmfree>
}
    80001aa4:	60e2                	ld	ra,24(sp)
    80001aa6:	6442                	ld	s0,16(sp)
    80001aa8:	64a2                	ld	s1,8(sp)
    80001aaa:	6902                	ld	s2,0(sp)
    80001aac:	6105                	addi	sp,sp,32
    80001aae:	8082                	ret

0000000080001ab0 <freeproc>:
{
    80001ab0:	1101                	addi	sp,sp,-32
    80001ab2:	ec06                	sd	ra,24(sp)
    80001ab4:	e822                	sd	s0,16(sp)
    80001ab6:	e426                	sd	s1,8(sp)
    80001ab8:	1000                	addi	s0,sp,32
    80001aba:	84aa                	mv	s1,a0
  if (p->trapframe)
    80001abc:	6d28                	ld	a0,88(a0)
    80001abe:	c119                	beqz	a0,80001ac4 <freeproc+0x14>
    kfree((void *)p->trapframe);
    80001ac0:	f97fe0ef          	jal	80000a56 <kfree>
  p->trapframe = 0;
    80001ac4:	0404bc23          	sd	zero,88(s1)
  if (p->pagetable)
    80001ac8:	68a8                	ld	a0,80(s1)
    80001aca:	c501                	beqz	a0,80001ad2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001acc:	64ac                	ld	a1,72(s1)
    80001ace:	f9dff0ef          	jal	80001a6a <proc_freepagetable>
  p->pagetable = 0;
    80001ad2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001ad6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001ada:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001ade:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001ae2:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001ae6:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001aea:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001aee:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001af2:	0004ac23          	sw	zero,24(s1)
  p->tracing = 0;
    80001af6:	1604a423          	sw	zero,360(s1)
}
    80001afa:	60e2                	ld	ra,24(sp)
    80001afc:	6442                	ld	s0,16(sp)
    80001afe:	64a2                	ld	s1,8(sp)
    80001b00:	6105                	addi	sp,sp,32
    80001b02:	8082                	ret

0000000080001b04 <allocproc>:
{
    80001b04:	1101                	addi	sp,sp,-32
    80001b06:	ec06                	sd	ra,24(sp)
    80001b08:	e822                	sd	s0,16(sp)
    80001b0a:	e426                	sd	s1,8(sp)
    80001b0c:	e04a                	sd	s2,0(sp)
    80001b0e:	1000                	addi	s0,sp,32
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b10:	0000e497          	auipc	s1,0xe
    80001b14:	47848493          	addi	s1,s1,1144 # 8000ff88 <proc>
    80001b18:	00014917          	auipc	s2,0x14
    80001b1c:	07090913          	addi	s2,s2,112 # 80015b88 <tickslock>
    acquire(&p->lock);
    80001b20:	8526                	mv	a0,s1
    80001b22:	8f6ff0ef          	jal	80000c18 <acquire>
    if (p->state == UNUSED) {
    80001b26:	4c9c                	lw	a5,24(s1)
    80001b28:	cb91                	beqz	a5,80001b3c <allocproc+0x38>
      release(&p->lock);
    80001b2a:	8526                	mv	a0,s1
    80001b2c:	970ff0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001b30:	17048493          	addi	s1,s1,368
    80001b34:	ff2496e3          	bne	s1,s2,80001b20 <allocproc+0x1c>
  return 0;
    80001b38:	4481                	li	s1,0
    80001b3a:	a099                	j	80001b80 <allocproc+0x7c>
  p->pid = allocpid();
    80001b3c:	e6fff0ef          	jal	800019aa <allocpid>
    80001b40:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001b42:	4785                	li	a5,1
    80001b44:	cc9c                	sw	a5,24(s1)
  if ((p->trapframe = (struct trapframe *)kalloc()) == 0) {
    80001b46:	ff9fe0ef          	jal	80000b3e <kalloc>
    80001b4a:	892a                	mv	s2,a0
    80001b4c:	eca8                	sd	a0,88(s1)
    80001b4e:	c121                	beqz	a0,80001b8e <allocproc+0x8a>
  p->pagetable = proc_pagetable(p);
    80001b50:	8526                	mv	a0,s1
    80001b52:	e97ff0ef          	jal	800019e8 <proc_pagetable>
    80001b56:	892a                	mv	s2,a0
    80001b58:	e8a8                	sd	a0,80(s1)
  if (p->pagetable == 0) {
    80001b5a:	c131                	beqz	a0,80001b9e <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    80001b5c:	07000613          	li	a2,112
    80001b60:	4581                	li	a1,0
    80001b62:	06048513          	addi	a0,s1,96
    80001b66:	96eff0ef          	jal	80000cd4 <memset>
  p->context.ra = (uint64)forkret;
    80001b6a:	00000797          	auipc	a5,0x0
    80001b6e:	da678793          	addi	a5,a5,-602 # 80001910 <forkret>
    80001b72:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001b74:	60bc                	ld	a5,64(s1)
    80001b76:	6705                	lui	a4,0x1
    80001b78:	97ba                	add	a5,a5,a4
    80001b7a:	f4bc                	sd	a5,104(s1)
  p->tracing = 0;
    80001b7c:	1604a423          	sw	zero,360(s1)
}
    80001b80:	8526                	mv	a0,s1
    80001b82:	60e2                	ld	ra,24(sp)
    80001b84:	6442                	ld	s0,16(sp)
    80001b86:	64a2                	ld	s1,8(sp)
    80001b88:	6902                	ld	s2,0(sp)
    80001b8a:	6105                	addi	sp,sp,32
    80001b8c:	8082                	ret
    freeproc(p);
    80001b8e:	8526                	mv	a0,s1
    80001b90:	f21ff0ef          	jal	80001ab0 <freeproc>
    release(&p->lock);
    80001b94:	8526                	mv	a0,s1
    80001b96:	906ff0ef          	jal	80000c9c <release>
    return 0;
    80001b9a:	84ca                	mv	s1,s2
    80001b9c:	b7d5                	j	80001b80 <allocproc+0x7c>
    freeproc(p);
    80001b9e:	8526                	mv	a0,s1
    80001ba0:	f11ff0ef          	jal	80001ab0 <freeproc>
    release(&p->lock);
    80001ba4:	8526                	mv	a0,s1
    80001ba6:	8f6ff0ef          	jal	80000c9c <release>
    return 0;
    80001baa:	84ca                	mv	s1,s2
    80001bac:	bfd1                	j	80001b80 <allocproc+0x7c>

0000000080001bae <userinit>:
{
    80001bae:	1101                	addi	sp,sp,-32
    80001bb0:	ec06                	sd	ra,24(sp)
    80001bb2:	e822                	sd	s0,16(sp)
    80001bb4:	e426                	sd	s1,8(sp)
    80001bb6:	1000                	addi	s0,sp,32
  p = allocproc();
    80001bb8:	f4dff0ef          	jal	80001b04 <allocproc>
    80001bbc:	84aa                	mv	s1,a0
  initproc = p;
    80001bbe:	00006797          	auipc	a5,0x6
    80001bc2:	e8a7b923          	sd	a0,-366(a5) # 80007a50 <initproc>
  p->cwd = namei("/");
    80001bc6:	00005517          	auipc	a0,0x5
    80001bca:	5ca50513          	addi	a0,a0,1482 # 80007190 <etext+0x190>
    80001bce:	6f5010ef          	jal	80003ac2 <namei>
    80001bd2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001bd6:	478d                	li	a5,3
    80001bd8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	8c0ff0ef          	jal	80000c9c <release>
}
    80001be0:	60e2                	ld	ra,24(sp)
    80001be2:	6442                	ld	s0,16(sp)
    80001be4:	64a2                	ld	s1,8(sp)
    80001be6:	6105                	addi	sp,sp,32
    80001be8:	8082                	ret

0000000080001bea <growproc>:
{
    80001bea:	1101                	addi	sp,sp,-32
    80001bec:	ec06                	sd	ra,24(sp)
    80001bee:	e822                	sd	s0,16(sp)
    80001bf0:	e426                	sd	s1,8(sp)
    80001bf2:	e04a                	sd	s2,0(sp)
    80001bf4:	1000                	addi	s0,sp,32
    80001bf6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bf8:	ce7ff0ef          	jal	800018de <myproc>
    80001bfc:	892a                	mv	s2,a0
  sz = p->sz;
    80001bfe:	652c                	ld	a1,72(a0)
  if (n > 0) {
    80001c00:	02905b63          	blez	s1,80001c36 <growproc+0x4c>
    if (sz + n > TRAPFRAME) {
    80001c04:	00b48633          	add	a2,s1,a1
    80001c08:	020007b7          	lui	a5,0x2000
    80001c0c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001c0e:	07b6                	slli	a5,a5,0xd
    80001c10:	02c7e163          	bltu	a5,a2,80001c32 <growproc+0x48>
    if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001c14:	4691                	li	a3,4
    80001c16:	6928                	ld	a0,80(a0)
    80001c18:	eaeff0ef          	jal	800012c6 <uvmalloc>
    80001c1c:	85aa                	mv	a1,a0
    80001c1e:	c911                	beqz	a0,80001c32 <growproc+0x48>
  p->sz = sz;
    80001c20:	04b93423          	sd	a1,72(s2)
  return 0;
    80001c24:	4501                	li	a0,0
}
    80001c26:	60e2                	ld	ra,24(sp)
    80001c28:	6442                	ld	s0,16(sp)
    80001c2a:	64a2                	ld	s1,8(sp)
    80001c2c:	6902                	ld	s2,0(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret
      return -1;
    80001c32:	557d                	li	a0,-1
    80001c34:	bfcd                	j	80001c26 <growproc+0x3c>
  } else if (n < 0) {
    80001c36:	fe04d5e3          	bgez	s1,80001c20 <growproc+0x36>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001c3a:	00b48633          	add	a2,s1,a1
    80001c3e:	6928                	ld	a0,80(a0)
    80001c40:	e40ff0ef          	jal	80001280 <uvmdealloc>
    80001c44:	85aa                	mv	a1,a0
    80001c46:	bfe9                	j	80001c20 <growproc+0x36>

0000000080001c48 <kfork>:
{
    80001c48:	7139                	addi	sp,sp,-64
    80001c4a:	fc06                	sd	ra,56(sp)
    80001c4c:	f822                	sd	s0,48(sp)
    80001c4e:	f426                	sd	s1,40(sp)
    80001c50:	e456                	sd	s5,8(sp)
    80001c52:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001c54:	c8bff0ef          	jal	800018de <myproc>
    80001c58:	8aaa                	mv	s5,a0
  if ((np = allocproc()) == 0) {
    80001c5a:	eabff0ef          	jal	80001b04 <allocproc>
    80001c5e:	c92d                	beqz	a0,80001cd0 <kfork+0x88>
    80001c60:	ec4e                	sd	s3,24(sp)
    80001c62:	89aa                	mv	s3,a0
  if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0) {
    80001c64:	048ab603          	ld	a2,72(s5)
    80001c68:	692c                	ld	a1,80(a0)
    80001c6a:	050ab503          	ld	a0,80(s5)
    80001c6e:	f86ff0ef          	jal	800013f4 <uvmcopy>
    80001c72:	04054863          	bltz	a0,80001cc2 <kfork+0x7a>
    80001c76:	f04a                	sd	s2,32(sp)
    80001c78:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001c7a:	048ab783          	ld	a5,72(s5)
    80001c7e:	04f9b423          	sd	a5,72(s3)
  *(np->trapframe) = *(p->trapframe);
    80001c82:	058ab683          	ld	a3,88(s5)
    80001c86:	87b6                	mv	a5,a3
    80001c88:	0589b703          	ld	a4,88(s3)
    80001c8c:	12068693          	addi	a3,a3,288
    80001c90:	6388                	ld	a0,0(a5)
    80001c92:	678c                	ld	a1,8(a5)
    80001c94:	6b90                	ld	a2,16(a5)
    80001c96:	e308                	sd	a0,0(a4)
    80001c98:	e70c                	sd	a1,8(a4)
    80001c9a:	eb10                	sd	a2,16(a4)
    80001c9c:	6f90                	ld	a2,24(a5)
    80001c9e:	ef10                	sd	a2,24(a4)
    80001ca0:	02078793          	addi	a5,a5,32
    80001ca4:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001ca8:	fed794e3          	bne	a5,a3,80001c90 <kfork+0x48>
  np->trapframe->a0 = 0;
    80001cac:	0589b783          	ld	a5,88(s3)
    80001cb0:	0607b823          	sd	zero,112(a5)
  for (i = 0; i < NOFILE; i++)
    80001cb4:	0d0a8493          	addi	s1,s5,208
    80001cb8:	0d098913          	addi	s2,s3,208
    80001cbc:	150a8a13          	addi	s4,s5,336
    80001cc0:	a831                	j	80001cdc <kfork+0x94>
    freeproc(np);
    80001cc2:	854e                	mv	a0,s3
    80001cc4:	dedff0ef          	jal	80001ab0 <freeproc>
    release(&np->lock);
    80001cc8:	854e                	mv	a0,s3
    80001cca:	fd3fe0ef          	jal	80000c9c <release>
    return -1;
    80001cce:	69e2                	ld	s3,24(sp)
    return -1;
    80001cd0:	54fd                	li	s1,-1
    80001cd2:	a8a5                	j	80001d4a <kfork+0x102>
  for (i = 0; i < NOFILE; i++)
    80001cd4:	04a1                	addi	s1,s1,8
    80001cd6:	0921                	addi	s2,s2,8
    80001cd8:	01448963          	beq	s1,s4,80001cea <kfork+0xa2>
    if (p->ofile[i])
    80001cdc:	6088                	ld	a0,0(s1)
    80001cde:	d97d                	beqz	a0,80001cd4 <kfork+0x8c>
      np->ofile[i] = filedup(p->ofile[i]);
    80001ce0:	3f8020ef          	jal	800040d8 <filedup>
    80001ce4:	00a93023          	sd	a0,0(s2)
    80001ce8:	b7f5                	j	80001cd4 <kfork+0x8c>
  np->cwd = idup(p->cwd);
    80001cea:	150ab503          	ld	a0,336(s5)
    80001cee:	566010ef          	jal	80003254 <idup>
    80001cf2:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001cf6:	4641                	li	a2,16
    80001cf8:	158a8593          	addi	a1,s5,344
    80001cfc:	15898513          	addi	a0,s3,344
    80001d00:	91eff0ef          	jal	80000e1e <safestrcpy>
  np->tracing = p->tracing;
    80001d04:	168aa783          	lw	a5,360(s5)
    80001d08:	16f9a423          	sw	a5,360(s3)
  pid = np->pid;
    80001d0c:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001d10:	854e                	mv	a0,s3
    80001d12:	f8bfe0ef          	jal	80000c9c <release>
  acquire(&wait_lock);
    80001d16:	0000e517          	auipc	a0,0xe
    80001d1a:	e5a50513          	addi	a0,a0,-422 # 8000fb70 <wait_lock>
    80001d1e:	efbfe0ef          	jal	80000c18 <acquire>
  np->parent = p;
    80001d22:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001d26:	0000e517          	auipc	a0,0xe
    80001d2a:	e4a50513          	addi	a0,a0,-438 # 8000fb70 <wait_lock>
    80001d2e:	f6ffe0ef          	jal	80000c9c <release>
  acquire(&np->lock);
    80001d32:	854e                	mv	a0,s3
    80001d34:	ee5fe0ef          	jal	80000c18 <acquire>
  np->state = RUNNABLE;
    80001d38:	478d                	li	a5,3
    80001d3a:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001d3e:	854e                	mv	a0,s3
    80001d40:	f5dfe0ef          	jal	80000c9c <release>
    80001d44:	7902                	ld	s2,32(sp)
    80001d46:	69e2                	ld	s3,24(sp)
    80001d48:	6a42                	ld	s4,16(sp)
}
    80001d4a:	8526                	mv	a0,s1
    80001d4c:	70e2                	ld	ra,56(sp)
    80001d4e:	7442                	ld	s0,48(sp)
    80001d50:	74a2                	ld	s1,40(sp)
    80001d52:	6aa2                	ld	s5,8(sp)
    80001d54:	6121                	addi	sp,sp,64
    80001d56:	8082                	ret

0000000080001d58 <scheduler>:
{
    80001d58:	715d                	addi	sp,sp,-80
    80001d5a:	e486                	sd	ra,72(sp)
    80001d5c:	e0a2                	sd	s0,64(sp)
    80001d5e:	fc26                	sd	s1,56(sp)
    80001d60:	f84a                	sd	s2,48(sp)
    80001d62:	f44e                	sd	s3,40(sp)
    80001d64:	f052                	sd	s4,32(sp)
    80001d66:	ec56                	sd	s5,24(sp)
    80001d68:	e85a                	sd	s6,16(sp)
    80001d6a:	e45e                	sd	s7,8(sp)
    80001d6c:	e062                	sd	s8,0(sp)
    80001d6e:	0880                	addi	s0,sp,80
    80001d70:	8792                	mv	a5,tp
  int id = r_tp();
    80001d72:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001d74:	00779693          	slli	a3,a5,0x7
    80001d78:	0000e717          	auipc	a4,0xe
    80001d7c:	de070713          	addi	a4,a4,-544 # 8000fb58 <pid_lock>
    80001d80:	9736                	add	a4,a4,a3
    80001d82:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001d86:	0000eb17          	auipc	s6,0xe
    80001d8a:	e0ab0b13          	addi	s6,s6,-502 # 8000fb90 <cpus+0x8>
    80001d8e:	9b36                	add	s6,s6,a3
        p->state = RUNNING;
    80001d90:	4c11                	li	s8,4
        c->proc = p;
    80001d92:	8a3a                	mv	s4,a4
        found = 1;
    80001d94:	4b85                	li	s7,1
    80001d96:	a83d                	j	80001dd4 <scheduler+0x7c>
      release(&p->lock);
    80001d98:	8526                	mv	a0,s1
    80001d9a:	f03fe0ef          	jal	80000c9c <release>
    for (p = proc; p < &proc[NPROC]; p++) {
    80001d9e:	17048493          	addi	s1,s1,368
    80001da2:	03248563          	beq	s1,s2,80001dcc <scheduler+0x74>
      acquire(&p->lock);
    80001da6:	8526                	mv	a0,s1
    80001da8:	e71fe0ef          	jal	80000c18 <acquire>
      if (p->state == RUNNABLE) {
    80001dac:	4c9c                	lw	a5,24(s1)
    80001dae:	ff3795e3          	bne	a5,s3,80001d98 <scheduler+0x40>
        p->state = RUNNING;
    80001db2:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001db6:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001dba:	06048593          	addi	a1,s1,96
    80001dbe:	855a                	mv	a0,s6
    80001dc0:	5a4000ef          	jal	80002364 <swtch>
        c->proc = 0;
    80001dc4:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001dc8:	8ade                	mv	s5,s7
    80001dca:	b7f9                	j	80001d98 <scheduler+0x40>
    if (found == 0) {
    80001dcc:	000a9463          	bnez	s5,80001dd4 <scheduler+0x7c>
      asm volatile("wfi");
    80001dd0:	10500073          	wfi
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    80001dd4:	10016073          	csrsi	sstatus,2
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    80001dd8:	10017073          	csrci	sstatus,2
    int found = 0;
    80001ddc:	4a81                	li	s5,0
    for (p = proc; p < &proc[NPROC]; p++) {
    80001dde:	0000e497          	auipc	s1,0xe
    80001de2:	1aa48493          	addi	s1,s1,426 # 8000ff88 <proc>
      if (p->state == RUNNABLE) {
    80001de6:	498d                	li	s3,3
    for (p = proc; p < &proc[NPROC]; p++) {
    80001de8:	00014917          	auipc	s2,0x14
    80001dec:	da090913          	addi	s2,s2,-608 # 80015b88 <tickslock>
    80001df0:	bf5d                	j	80001da6 <scheduler+0x4e>

0000000080001df2 <sched>:
{
    80001df2:	7179                	addi	sp,sp,-48
    80001df4:	f406                	sd	ra,40(sp)
    80001df6:	f022                	sd	s0,32(sp)
    80001df8:	ec26                	sd	s1,24(sp)
    80001dfa:	e84a                	sd	s2,16(sp)
    80001dfc:	e44e                	sd	s3,8(sp)
    80001dfe:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001e00:	adfff0ef          	jal	800018de <myproc>
    80001e04:	84aa                	mv	s1,a0
  if (!holding(&p->lock))
    80001e06:	dadfe0ef          	jal	80000bb2 <holding>
    80001e0a:	c92d                	beqz	a0,80001e7c <sched+0x8a>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e0c:	8792                	mv	a5,tp
  if (mycpu()->noff != 1)
    80001e0e:	2781                	sext.w	a5,a5
    80001e10:	079e                	slli	a5,a5,0x7
    80001e12:	0000e717          	auipc	a4,0xe
    80001e16:	d4670713          	addi	a4,a4,-698 # 8000fb58 <pid_lock>
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	0a87a703          	lw	a4,168(a5)
    80001e20:	4785                	li	a5,1
    80001e22:	06f71363          	bne	a4,a5,80001e88 <sched+0x96>
  if (p->state == RUNNING)
    80001e26:	4c98                	lw	a4,24(s1)
    80001e28:	4791                	li	a5,4
    80001e2a:	06f70563          	beq	a4,a5,80001e94 <sched+0xa2>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80001e2e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001e32:	8b89                	andi	a5,a5,2
  if (intr_get())
    80001e34:	e7b5                	bnez	a5,80001ea0 <sched+0xae>
  asm volatile("mv %0, tp" : "=r"(x));
    80001e36:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001e38:	0000e917          	auipc	s2,0xe
    80001e3c:	d2090913          	addi	s2,s2,-736 # 8000fb58 <pid_lock>
    80001e40:	2781                	sext.w	a5,a5
    80001e42:	079e                	slli	a5,a5,0x7
    80001e44:	97ca                	add	a5,a5,s2
    80001e46:	0ac7a983          	lw	s3,172(a5)
    80001e4a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001e4c:	2781                	sext.w	a5,a5
    80001e4e:	079e                	slli	a5,a5,0x7
    80001e50:	0000e597          	auipc	a1,0xe
    80001e54:	d4058593          	addi	a1,a1,-704 # 8000fb90 <cpus+0x8>
    80001e58:	95be                	add	a1,a1,a5
    80001e5a:	06048513          	addi	a0,s1,96
    80001e5e:	506000ef          	jal	80002364 <swtch>
    80001e62:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001e64:	2781                	sext.w	a5,a5
    80001e66:	079e                	slli	a5,a5,0x7
    80001e68:	993e                	add	s2,s2,a5
    80001e6a:	0b392623          	sw	s3,172(s2)
}
    80001e6e:	70a2                	ld	ra,40(sp)
    80001e70:	7402                	ld	s0,32(sp)
    80001e72:	64e2                	ld	s1,24(sp)
    80001e74:	6942                	ld	s2,16(sp)
    80001e76:	69a2                	ld	s3,8(sp)
    80001e78:	6145                	addi	sp,sp,48
    80001e7a:	8082                	ret
    panic("sched p->lock");
    80001e7c:	00005517          	auipc	a0,0x5
    80001e80:	31c50513          	addi	a0,a0,796 # 80007198 <etext+0x198>
    80001e84:	9b7fe0ef          	jal	8000083a <panic>
    panic("sched locks");
    80001e88:	00005517          	auipc	a0,0x5
    80001e8c:	32050513          	addi	a0,a0,800 # 800071a8 <etext+0x1a8>
    80001e90:	9abfe0ef          	jal	8000083a <panic>
    panic("sched RUNNING");
    80001e94:	00005517          	auipc	a0,0x5
    80001e98:	32450513          	addi	a0,a0,804 # 800071b8 <etext+0x1b8>
    80001e9c:	99ffe0ef          	jal	8000083a <panic>
    panic("sched interruptible");
    80001ea0:	00005517          	auipc	a0,0x5
    80001ea4:	32850513          	addi	a0,a0,808 # 800071c8 <etext+0x1c8>
    80001ea8:	993fe0ef          	jal	8000083a <panic>

0000000080001eac <yield>:
{
    80001eac:	1101                	addi	sp,sp,-32
    80001eae:	ec06                	sd	ra,24(sp)
    80001eb0:	e822                	sd	s0,16(sp)
    80001eb2:	e426                	sd	s1,8(sp)
    80001eb4:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001eb6:	a29ff0ef          	jal	800018de <myproc>
    80001eba:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001ebc:	d5dfe0ef          	jal	80000c18 <acquire>
  p->state = RUNNABLE;
    80001ec0:	478d                	li	a5,3
    80001ec2:	cc9c                	sw	a5,24(s1)
  sched();
    80001ec4:	f2fff0ef          	jal	80001df2 <sched>
  release(&p->lock);
    80001ec8:	8526                	mv	a0,s1
    80001eca:	dd3fe0ef          	jal	80000c9c <release>
}
    80001ece:	60e2                	ld	ra,24(sp)
    80001ed0:	6442                	ld	s0,16(sp)
    80001ed2:	64a2                	ld	s1,8(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret

0000000080001ed8 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001ed8:	7179                	addi	sp,sp,-48
    80001eda:	f406                	sd	ra,40(sp)
    80001edc:	f022                	sd	s0,32(sp)
    80001ede:	ec26                	sd	s1,24(sp)
    80001ee0:	e84a                	sd	s2,16(sp)
    80001ee2:	e44e                	sd	s3,8(sp)
    80001ee4:	1800                	addi	s0,sp,48
    80001ee6:	89aa                	mv	s3,a0
    80001ee8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001eea:	9f5ff0ef          	jal	800018de <myproc>
    80001eee:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock); //DOC: sleeplock1
    80001ef0:	d29fe0ef          	jal	80000c18 <acquire>
  release(lk);
    80001ef4:	854a                	mv	a0,s2
    80001ef6:	da7fe0ef          	jal	80000c9c <release>

  // Go to sleep.
  p->chan = chan;
    80001efa:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001efe:	4789                	li	a5,2
    80001f00:	cc9c                	sw	a5,24(s1)

  sched();
    80001f02:	ef1ff0ef          	jal	80001df2 <sched>

  // Tidy up.
  p->chan = 0;
    80001f06:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001f0a:	8526                	mv	a0,s1
    80001f0c:	d91fe0ef          	jal	80000c9c <release>
  acquire(lk);
    80001f10:	854a                	mv	a0,s2
    80001f12:	d07fe0ef          	jal	80000c18 <acquire>
}
    80001f16:	70a2                	ld	ra,40(sp)
    80001f18:	7402                	ld	s0,32(sp)
    80001f1a:	64e2                	ld	s1,24(sp)
    80001f1c:	6942                	ld	s2,16(sp)
    80001f1e:	69a2                	ld	s3,8(sp)
    80001f20:	6145                	addi	sp,sp,48
    80001f22:	8082                	ret

0000000080001f24 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001f24:	7139                	addi	sp,sp,-64
    80001f26:	fc06                	sd	ra,56(sp)
    80001f28:	f822                	sd	s0,48(sp)
    80001f2a:	f426                	sd	s1,40(sp)
    80001f2c:	f04a                	sd	s2,32(sp)
    80001f2e:	ec4e                	sd	s3,24(sp)
    80001f30:	e852                	sd	s4,16(sp)
    80001f32:	e456                	sd	s5,8(sp)
    80001f34:	0080                	addi	s0,sp,64
    80001f36:	8a2a                	mv	s4,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    80001f38:	0000e497          	auipc	s1,0xe
    80001f3c:	05048493          	addi	s1,s1,80 # 8000ff88 <proc>
    if (p != myproc()) {
      acquire(&p->lock);
      if (p->state == SLEEPING && p->chan == chan) {
    80001f40:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001f42:	4a8d                	li	s5,3
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f44:	00014917          	auipc	s2,0x14
    80001f48:	c4490913          	addi	s2,s2,-956 # 80015b88 <tickslock>
    80001f4c:	a801                	j	80001f5c <wakeup+0x38>
      }
      release(&p->lock);
    80001f4e:	8526                	mv	a0,s1
    80001f50:	d4dfe0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    80001f54:	17048493          	addi	s1,s1,368
    80001f58:	03248263          	beq	s1,s2,80001f7c <wakeup+0x58>
    if (p != myproc()) {
    80001f5c:	983ff0ef          	jal	800018de <myproc>
    80001f60:	fe950ae3          	beq	a0,s1,80001f54 <wakeup+0x30>
      acquire(&p->lock);
    80001f64:	8526                	mv	a0,s1
    80001f66:	cb3fe0ef          	jal	80000c18 <acquire>
      if (p->state == SLEEPING && p->chan == chan) {
    80001f6a:	4c9c                	lw	a5,24(s1)
    80001f6c:	ff3791e3          	bne	a5,s3,80001f4e <wakeup+0x2a>
    80001f70:	709c                	ld	a5,32(s1)
    80001f72:	fd479ee3          	bne	a5,s4,80001f4e <wakeup+0x2a>
        p->state = RUNNABLE;
    80001f76:	0154ac23          	sw	s5,24(s1)
    80001f7a:	bfd1                	j	80001f4e <wakeup+0x2a>
    }
  }
}
    80001f7c:	70e2                	ld	ra,56(sp)
    80001f7e:	7442                	ld	s0,48(sp)
    80001f80:	74a2                	ld	s1,40(sp)
    80001f82:	7902                	ld	s2,32(sp)
    80001f84:	69e2                	ld	s3,24(sp)
    80001f86:	6a42                	ld	s4,16(sp)
    80001f88:	6aa2                	ld	s5,8(sp)
    80001f8a:	6121                	addi	sp,sp,64
    80001f8c:	8082                	ret

0000000080001f8e <reparent>:
{
    80001f8e:	7179                	addi	sp,sp,-48
    80001f90:	f406                	sd	ra,40(sp)
    80001f92:	f022                	sd	s0,32(sp)
    80001f94:	ec26                	sd	s1,24(sp)
    80001f96:	e84a                	sd	s2,16(sp)
    80001f98:	e44e                	sd	s3,8(sp)
    80001f9a:	e052                	sd	s4,0(sp)
    80001f9c:	1800                	addi	s0,sp,48
    80001f9e:	892a                	mv	s2,a0
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fa0:	0000e497          	auipc	s1,0xe
    80001fa4:	fe848493          	addi	s1,s1,-24 # 8000ff88 <proc>
      pp->parent = initproc;
    80001fa8:	00006a17          	auipc	s4,0x6
    80001fac:	aa8a0a13          	addi	s4,s4,-1368 # 80007a50 <initproc>
  for (pp = proc; pp < &proc[NPROC]; pp++) {
    80001fb0:	00014997          	auipc	s3,0x14
    80001fb4:	bd898993          	addi	s3,s3,-1064 # 80015b88 <tickslock>
    80001fb8:	a029                	j	80001fc2 <reparent+0x34>
    80001fba:	17048493          	addi	s1,s1,368
    80001fbe:	01348b63          	beq	s1,s3,80001fd4 <reparent+0x46>
    if (pp->parent == p) {
    80001fc2:	7c9c                	ld	a5,56(s1)
    80001fc4:	ff279be3          	bne	a5,s2,80001fba <reparent+0x2c>
      pp->parent = initproc;
    80001fc8:	000a3503          	ld	a0,0(s4)
    80001fcc:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001fce:	f57ff0ef          	jal	80001f24 <wakeup>
    80001fd2:	b7e5                	j	80001fba <reparent+0x2c>
}
    80001fd4:	70a2                	ld	ra,40(sp)
    80001fd6:	7402                	ld	s0,32(sp)
    80001fd8:	64e2                	ld	s1,24(sp)
    80001fda:	6942                	ld	s2,16(sp)
    80001fdc:	69a2                	ld	s3,8(sp)
    80001fde:	6a02                	ld	s4,0(sp)
    80001fe0:	6145                	addi	sp,sp,48
    80001fe2:	8082                	ret

0000000080001fe4 <kexit>:
{
    80001fe4:	7179                	addi	sp,sp,-48
    80001fe6:	f406                	sd	ra,40(sp)
    80001fe8:	f022                	sd	s0,32(sp)
    80001fea:	ec26                	sd	s1,24(sp)
    80001fec:	e84a                	sd	s2,16(sp)
    80001fee:	e44e                	sd	s3,8(sp)
    80001ff0:	e052                	sd	s4,0(sp)
    80001ff2:	1800                	addi	s0,sp,48
    80001ff4:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ff6:	8e9ff0ef          	jal	800018de <myproc>
    80001ffa:	89aa                	mv	s3,a0
  if (p == initproc)
    80001ffc:	00006797          	auipc	a5,0x6
    80002000:	a547b783          	ld	a5,-1452(a5) # 80007a50 <initproc>
    80002004:	0d050493          	addi	s1,a0,208
    80002008:	15050913          	addi	s2,a0,336
    8000200c:	00a79b63          	bne	a5,a0,80002022 <kexit+0x3e>
    panic("init exiting");
    80002010:	00005517          	auipc	a0,0x5
    80002014:	1d050513          	addi	a0,a0,464 # 800071e0 <etext+0x1e0>
    80002018:	823fe0ef          	jal	8000083a <panic>
  for (int fd = 0; fd < NOFILE; fd++) {
    8000201c:	04a1                	addi	s1,s1,8
    8000201e:	01248963          	beq	s1,s2,80002030 <kexit+0x4c>
    if (p->ofile[fd]) {
    80002022:	6088                	ld	a0,0(s1)
    80002024:	dd65                	beqz	a0,8000201c <kexit+0x38>
      fileclose(f);
    80002026:	0f8020ef          	jal	8000411e <fileclose>
      p->ofile[fd] = 0;
    8000202a:	0004b023          	sd	zero,0(s1)
    8000202e:	b7fd                	j	8000201c <kexit+0x38>
  begin_op();
    80002030:	471010ef          	jal	80003ca0 <begin_op>
  iput(p->cwd);
    80002034:	1509b503          	ld	a0,336(s3)
    80002038:	3d4010ef          	jal	8000340c <iput>
  end_op();
    8000203c:	4d5010ef          	jal	80003d10 <end_op>
  p->cwd = 0;
    80002040:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80002044:	0000e517          	auipc	a0,0xe
    80002048:	b2c50513          	addi	a0,a0,-1236 # 8000fb70 <wait_lock>
    8000204c:	bcdfe0ef          	jal	80000c18 <acquire>
  reparent(p);
    80002050:	854e                	mv	a0,s3
    80002052:	f3dff0ef          	jal	80001f8e <reparent>
  wakeup(p->parent);
    80002056:	0389b503          	ld	a0,56(s3)
    8000205a:	ecbff0ef          	jal	80001f24 <wakeup>
  acquire(&p->lock);
    8000205e:	854e                	mv	a0,s3
    80002060:	bb9fe0ef          	jal	80000c18 <acquire>
  p->xstate = status;
    80002064:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80002068:	4795                	li	a5,5
    8000206a:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000206e:	0000e517          	auipc	a0,0xe
    80002072:	b0250513          	addi	a0,a0,-1278 # 8000fb70 <wait_lock>
    80002076:	c27fe0ef          	jal	80000c9c <release>
  sched();
    8000207a:	d79ff0ef          	jal	80001df2 <sched>
  panic("zombie exit");
    8000207e:	00005517          	auipc	a0,0x5
    80002082:	17250513          	addi	a0,a0,370 # 800071f0 <etext+0x1f0>
    80002086:	fb4fe0ef          	jal	8000083a <panic>

000000008000208a <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000208a:	7179                	addi	sp,sp,-48
    8000208c:	f406                	sd	ra,40(sp)
    8000208e:	f022                	sd	s0,32(sp)
    80002090:	ec26                	sd	s1,24(sp)
    80002092:	e84a                	sd	s2,16(sp)
    80002094:	e44e                	sd	s3,8(sp)
    80002096:	1800                	addi	s0,sp,48
    80002098:	892a                	mv	s2,a0
  struct proc *p;

  for (p = proc; p < &proc[NPROC]; p++) {
    8000209a:	0000e497          	auipc	s1,0xe
    8000209e:	eee48493          	addi	s1,s1,-274 # 8000ff88 <proc>
    800020a2:	00014997          	auipc	s3,0x14
    800020a6:	ae698993          	addi	s3,s3,-1306 # 80015b88 <tickslock>
    acquire(&p->lock);
    800020aa:	8526                	mv	a0,s1
    800020ac:	b6dfe0ef          	jal	80000c18 <acquire>
    if (p->pid == pid) {
    800020b0:	589c                	lw	a5,48(s1)
    800020b2:	01278b63          	beq	a5,s2,800020c8 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800020b6:	8526                	mv	a0,s1
    800020b8:	be5fe0ef          	jal	80000c9c <release>
  for (p = proc; p < &proc[NPROC]; p++) {
    800020bc:	17048493          	addi	s1,s1,368
    800020c0:	ff3495e3          	bne	s1,s3,800020aa <kkill+0x20>
  }
  return -1;
    800020c4:	557d                	li	a0,-1
    800020c6:	a819                	j	800020dc <kkill+0x52>
      p->killed = 1;
    800020c8:	4785                	li	a5,1
    800020ca:	d49c                	sw	a5,40(s1)
      if (p->state == SLEEPING) {
    800020cc:	4c98                	lw	a4,24(s1)
    800020ce:	4789                	li	a5,2
    800020d0:	00f70d63          	beq	a4,a5,800020ea <kkill+0x60>
      release(&p->lock);
    800020d4:	8526                	mv	a0,s1
    800020d6:	bc7fe0ef          	jal	80000c9c <release>
      return 0;
    800020da:	4501                	li	a0,0
}
    800020dc:	70a2                	ld	ra,40(sp)
    800020de:	7402                	ld	s0,32(sp)
    800020e0:	64e2                	ld	s1,24(sp)
    800020e2:	6942                	ld	s2,16(sp)
    800020e4:	69a2                	ld	s3,8(sp)
    800020e6:	6145                	addi	sp,sp,48
    800020e8:	8082                	ret
        p->state = RUNNABLE;
    800020ea:	478d                	li	a5,3
    800020ec:	cc9c                	sw	a5,24(s1)
    800020ee:	b7dd                	j	800020d4 <kkill+0x4a>

00000000800020f0 <setkilled>:

void
setkilled(struct proc *p)
{
    800020f0:	1101                	addi	sp,sp,-32
    800020f2:	ec06                	sd	ra,24(sp)
    800020f4:	e822                	sd	s0,16(sp)
    800020f6:	e426                	sd	s1,8(sp)
    800020f8:	1000                	addi	s0,sp,32
    800020fa:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800020fc:	b1dfe0ef          	jal	80000c18 <acquire>
  p->killed = 1;
    80002100:	4785                	li	a5,1
    80002102:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80002104:	8526                	mv	a0,s1
    80002106:	b97fe0ef          	jal	80000c9c <release>
}
    8000210a:	60e2                	ld	ra,24(sp)
    8000210c:	6442                	ld	s0,16(sp)
    8000210e:	64a2                	ld	s1,8(sp)
    80002110:	6105                	addi	sp,sp,32
    80002112:	8082                	ret

0000000080002114 <killed>:

int
killed(struct proc *p)
{
    80002114:	1101                	addi	sp,sp,-32
    80002116:	ec06                	sd	ra,24(sp)
    80002118:	e822                	sd	s0,16(sp)
    8000211a:	e426                	sd	s1,8(sp)
    8000211c:	e04a                	sd	s2,0(sp)
    8000211e:	1000                	addi	s0,sp,32
    80002120:	84aa                	mv	s1,a0
  int k;

  acquire(&p->lock);
    80002122:	af7fe0ef          	jal	80000c18 <acquire>
  k = p->killed;
    80002126:	549c                	lw	a5,40(s1)
    80002128:	893e                	mv	s2,a5
  release(&p->lock);
    8000212a:	8526                	mv	a0,s1
    8000212c:	b71fe0ef          	jal	80000c9c <release>
  return k;
}
    80002130:	854a                	mv	a0,s2
    80002132:	60e2                	ld	ra,24(sp)
    80002134:	6442                	ld	s0,16(sp)
    80002136:	64a2                	ld	s1,8(sp)
    80002138:	6902                	ld	s2,0(sp)
    8000213a:	6105                	addi	sp,sp,32
    8000213c:	8082                	ret

000000008000213e <kwait>:
{
    8000213e:	715d                	addi	sp,sp,-80
    80002140:	e486                	sd	ra,72(sp)
    80002142:	e0a2                	sd	s0,64(sp)
    80002144:	fc26                	sd	s1,56(sp)
    80002146:	f84a                	sd	s2,48(sp)
    80002148:	f44e                	sd	s3,40(sp)
    8000214a:	f052                	sd	s4,32(sp)
    8000214c:	ec56                	sd	s5,24(sp)
    8000214e:	e85a                	sd	s6,16(sp)
    80002150:	e45e                	sd	s7,8(sp)
    80002152:	0880                	addi	s0,sp,80
    80002154:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80002156:	f88ff0ef          	jal	800018de <myproc>
    8000215a:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000215c:	0000e517          	auipc	a0,0xe
    80002160:	a1450513          	addi	a0,a0,-1516 # 8000fb70 <wait_lock>
    80002164:	ab5fe0ef          	jal	80000c18 <acquire>
        if (pp->state == ZOMBIE) {
    80002168:	4a15                	li	s4,5
        havekids = 1;
    8000216a:	4a85                	li	s5,1
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    8000216c:	00014997          	auipc	s3,0x14
    80002170:	a1c98993          	addi	s3,s3,-1508 # 80015b88 <tickslock>
    sleep(p, &wait_lock); //DOC: wait-sleep
    80002174:	0000eb17          	auipc	s6,0xe
    80002178:	9fcb0b13          	addi	s6,s6,-1540 # 8000fb70 <wait_lock>
    8000217c:	a861                	j	80002214 <kwait+0xd6>
          pid = pp->pid;
    8000217e:	0304a983          	lw	s3,48(s1)
          if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80002182:	000b8c63          	beqz	s7,8000219a <kwait+0x5c>
    80002186:	4691                	li	a3,4
    80002188:	02c48613          	addi	a2,s1,44
    8000218c:	85de                	mv	a1,s7
    8000218e:	05093503          	ld	a0,80(s2)
    80002192:	c7eff0ef          	jal	80001610 <copyout>
    80002196:	02054a63          	bltz	a0,800021ca <kwait+0x8c>
          freeproc(pp);
    8000219a:	8526                	mv	a0,s1
    8000219c:	915ff0ef          	jal	80001ab0 <freeproc>
          release(&pp->lock);
    800021a0:	8526                	mv	a0,s1
    800021a2:	afbfe0ef          	jal	80000c9c <release>
          release(&wait_lock);
    800021a6:	0000e517          	auipc	a0,0xe
    800021aa:	9ca50513          	addi	a0,a0,-1590 # 8000fb70 <wait_lock>
    800021ae:	aeffe0ef          	jal	80000c9c <release>
}
    800021b2:	854e                	mv	a0,s3
    800021b4:	60a6                	ld	ra,72(sp)
    800021b6:	6406                	ld	s0,64(sp)
    800021b8:	74e2                	ld	s1,56(sp)
    800021ba:	7942                	ld	s2,48(sp)
    800021bc:	79a2                	ld	s3,40(sp)
    800021be:	7a02                	ld	s4,32(sp)
    800021c0:	6ae2                	ld	s5,24(sp)
    800021c2:	6b42                	ld	s6,16(sp)
    800021c4:	6ba2                	ld	s7,8(sp)
    800021c6:	6161                	addi	sp,sp,80
    800021c8:	8082                	ret
            release(&pp->lock);
    800021ca:	8526                	mv	a0,s1
    800021cc:	ad1fe0ef          	jal	80000c9c <release>
            release(&wait_lock);
    800021d0:	0000e517          	auipc	a0,0xe
    800021d4:	9a050513          	addi	a0,a0,-1632 # 8000fb70 <wait_lock>
    800021d8:	ac5fe0ef          	jal	80000c9c <release>
            return -1;
    800021dc:	a881                	j	8000222c <kwait+0xee>
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    800021de:	17048493          	addi	s1,s1,368
    800021e2:	03348063          	beq	s1,s3,80002202 <kwait+0xc4>
      if (pp->parent == p) {
    800021e6:	7c9c                	ld	a5,56(s1)
    800021e8:	ff279be3          	bne	a5,s2,800021de <kwait+0xa0>
        acquire(&pp->lock);
    800021ec:	8526                	mv	a0,s1
    800021ee:	a2bfe0ef          	jal	80000c18 <acquire>
        if (pp->state == ZOMBIE) {
    800021f2:	4c9c                	lw	a5,24(s1)
    800021f4:	f94785e3          	beq	a5,s4,8000217e <kwait+0x40>
        release(&pp->lock);
    800021f8:	8526                	mv	a0,s1
    800021fa:	aa3fe0ef          	jal	80000c9c <release>
        havekids = 1;
    800021fe:	8756                	mv	a4,s5
    80002200:	bff9                	j	800021de <kwait+0xa0>
    if (!havekids || killed(p)) {
    80002202:	cf19                	beqz	a4,80002220 <kwait+0xe2>
    80002204:	854a                	mv	a0,s2
    80002206:	f0fff0ef          	jal	80002114 <killed>
    8000220a:	e919                	bnez	a0,80002220 <kwait+0xe2>
    sleep(p, &wait_lock); //DOC: wait-sleep
    8000220c:	85da                	mv	a1,s6
    8000220e:	854a                	mv	a0,s2
    80002210:	cc9ff0ef          	jal	80001ed8 <sleep>
    havekids = 0;
    80002214:	4701                	li	a4,0
    for (pp = proc; pp < &proc[NPROC]; pp++) {
    80002216:	0000e497          	auipc	s1,0xe
    8000221a:	d7248493          	addi	s1,s1,-654 # 8000ff88 <proc>
    8000221e:	b7e1                	j	800021e6 <kwait+0xa8>
      release(&wait_lock);
    80002220:	0000e517          	auipc	a0,0xe
    80002224:	95050513          	addi	a0,a0,-1712 # 8000fb70 <wait_lock>
    80002228:	a75fe0ef          	jal	80000c9c <release>
            return -1;
    8000222c:	59fd                	li	s3,-1
    8000222e:	b751                	j	800021b2 <kwait+0x74>

0000000080002230 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80002230:	7179                	addi	sp,sp,-48
    80002232:	f406                	sd	ra,40(sp)
    80002234:	f022                	sd	s0,32(sp)
    80002236:	ec26                	sd	s1,24(sp)
    80002238:	e84a                	sd	s2,16(sp)
    8000223a:	e44e                	sd	s3,8(sp)
    8000223c:	e052                	sd	s4,0(sp)
    8000223e:	1800                	addi	s0,sp,48
    80002240:	84aa                	mv	s1,a0
    80002242:	8a2e                	mv	s4,a1
    80002244:	89b2                	mv	s3,a2
    80002246:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002248:	e96ff0ef          	jal	800018de <myproc>
  if (user_dst) {
    8000224c:	cc99                	beqz	s1,8000226a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000224e:	86ca                	mv	a3,s2
    80002250:	864e                	mv	a2,s3
    80002252:	85d2                	mv	a1,s4
    80002254:	6928                	ld	a0,80(a0)
    80002256:	bbaff0ef          	jal	80001610 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000225a:	70a2                	ld	ra,40(sp)
    8000225c:	7402                	ld	s0,32(sp)
    8000225e:	64e2                	ld	s1,24(sp)
    80002260:	6942                	ld	s2,16(sp)
    80002262:	69a2                	ld	s3,8(sp)
    80002264:	6a02                	ld	s4,0(sp)
    80002266:	6145                	addi	sp,sp,48
    80002268:	8082                	ret
    memmove((char *)dst, src, len);
    8000226a:	0009061b          	sext.w	a2,s2
    8000226e:	85ce                	mv	a1,s3
    80002270:	8552                	mv	a0,s4
    80002272:	abffe0ef          	jal	80000d30 <memmove>
    return 0;
    80002276:	8526                	mv	a0,s1
    80002278:	b7cd                	j	8000225a <either_copyout+0x2a>

000000008000227a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000227a:	7179                	addi	sp,sp,-48
    8000227c:	f406                	sd	ra,40(sp)
    8000227e:	f022                	sd	s0,32(sp)
    80002280:	ec26                	sd	s1,24(sp)
    80002282:	e84a                	sd	s2,16(sp)
    80002284:	e44e                	sd	s3,8(sp)
    80002286:	e052                	sd	s4,0(sp)
    80002288:	1800                	addi	s0,sp,48
    8000228a:	8a2a                	mv	s4,a0
    8000228c:	84ae                	mv	s1,a1
    8000228e:	89b2                	mv	s3,a2
    80002290:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80002292:	e4cff0ef          	jal	800018de <myproc>
  if (user_src) {
    80002296:	cc99                	beqz	s1,800022b4 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80002298:	86ca                	mv	a3,s2
    8000229a:	864e                	mv	a2,s3
    8000229c:	85d2                	mv	a1,s4
    8000229e:	6928                	ld	a0,80(a0)
    800022a0:	c28ff0ef          	jal	800016c8 <copyin>
  } else {
    memmove(dst, (char *)src, len);
    return 0;
  }
}
    800022a4:	70a2                	ld	ra,40(sp)
    800022a6:	7402                	ld	s0,32(sp)
    800022a8:	64e2                	ld	s1,24(sp)
    800022aa:	6942                	ld	s2,16(sp)
    800022ac:	69a2                	ld	s3,8(sp)
    800022ae:	6a02                	ld	s4,0(sp)
    800022b0:	6145                	addi	sp,sp,48
    800022b2:	8082                	ret
    memmove(dst, (char *)src, len);
    800022b4:	0009061b          	sext.w	a2,s2
    800022b8:	85ce                	mv	a1,s3
    800022ba:	8552                	mv	a0,s4
    800022bc:	a75fe0ef          	jal	80000d30 <memmove>
    return 0;
    800022c0:	8526                	mv	a0,s1
    800022c2:	b7cd                	j	800022a4 <either_copyin+0x2a>

00000000800022c4 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800022c4:	715d                	addi	sp,sp,-80
    800022c6:	e486                	sd	ra,72(sp)
    800022c8:	e0a2                	sd	s0,64(sp)
    800022ca:	fc26                	sd	s1,56(sp)
    800022cc:	f84a                	sd	s2,48(sp)
    800022ce:	f44e                	sd	s3,40(sp)
    800022d0:	f052                	sd	s4,32(sp)
    800022d2:	ec56                	sd	s5,24(sp)
    800022d4:	e85a                	sd	s6,16(sp)
    800022d6:	e45e                	sd	s7,8(sp)
    800022d8:	0880                	addi	s0,sp,80
    // clang-format on
  };
  struct proc *p;
  char *state;

  printk("\n");
    800022da:	00005517          	auipc	a0,0x5
    800022de:	d9e50513          	addi	a0,a0,-610 # 80007078 <etext+0x78>
    800022e2:	a20fe0ef          	jal	80000502 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    800022e6:	0000e497          	auipc	s1,0xe
    800022ea:	dfa48493          	addi	s1,s1,-518 # 800100e0 <proc+0x158>
    800022ee:	00014917          	auipc	s2,0x14
    800022f2:	9f290913          	addi	s2,s2,-1550 # 80015ce0 <bcache+0x140>
    if (p->state == UNUSED)
      continue;
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800022f6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800022f8:	00005a97          	auipc	s5,0x5
    800022fc:	f08a8a93          	addi	s5,s5,-248 # 80007200 <etext+0x200>
    printk("%d %s %s", p->pid, state, p->name);
    80002300:	00005a17          	auipc	s4,0x5
    80002304:	f08a0a13          	addi	s4,s4,-248 # 80007208 <etext+0x208>
    printk("\n");
    80002308:	00005997          	auipc	s3,0x5
    8000230c:	d7098993          	addi	s3,s3,-656 # 80007078 <etext+0x78>
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80002310:	00005b97          	auipc	s7,0x5
    80002314:	518b8b93          	addi	s7,s7,1304 # 80007828 <states.0>
    80002318:	a829                	j	80002332 <procdump+0x6e>
    printk("%d %s %s", p->pid, state, p->name);
    8000231a:	ed86a583          	lw	a1,-296(a3)
    8000231e:	8552                	mv	a0,s4
    80002320:	9e2fe0ef          	jal	80000502 <printk>
    printk("\n");
    80002324:	854e                	mv	a0,s3
    80002326:	9dcfe0ef          	jal	80000502 <printk>
  for (p = proc; p < &proc[NPROC]; p++) {
    8000232a:	17048493          	addi	s1,s1,368
    8000232e:	03248063          	beq	s1,s2,8000234e <procdump+0x8a>
    if (p->state == UNUSED)
    80002332:	86a6                	mv	a3,s1
    80002334:	ec04a783          	lw	a5,-320(s1)
    80002338:	dbed                	beqz	a5,8000232a <procdump+0x66>
      state = "???";
    8000233a:	8656                	mv	a2,s5
    if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000233c:	fcfb6fe3          	bltu	s6,a5,8000231a <procdump+0x56>
    80002340:	02079713          	slli	a4,a5,0x20
    80002344:	01d75793          	srli	a5,a4,0x1d
    80002348:	97de                	add	a5,a5,s7
    8000234a:	6390                	ld	a2,0(a5)
      state = states[p->state];
    8000234c:	b7f9                	j	8000231a <procdump+0x56>
  }
}
    8000234e:	60a6                	ld	ra,72(sp)
    80002350:	6406                	ld	s0,64(sp)
    80002352:	74e2                	ld	s1,56(sp)
    80002354:	7942                	ld	s2,48(sp)
    80002356:	79a2                	ld	s3,40(sp)
    80002358:	7a02                	ld	s4,32(sp)
    8000235a:	6ae2                	ld	s5,24(sp)
    8000235c:	6b42                	ld	s6,16(sp)
    8000235e:	6ba2                	ld	s7,8(sp)
    80002360:	6161                	addi	sp,sp,80
    80002362:	8082                	ret

0000000080002364 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80002364:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80002368:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000236c:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000236e:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80002370:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80002374:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80002378:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000237c:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80002380:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80002384:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80002388:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000238c:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80002390:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80002394:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80002398:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000239c:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800023a0:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800023a2:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800023a4:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800023a8:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800023ac:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800023b0:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800023b4:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800023b8:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800023bc:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800023c0:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800023c4:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800023c8:	0685bd83          	ld	s11,104(a1)
        
        ret
    800023cc:	8082                	ret

00000000800023ce <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800023ce:	1141                	addi	sp,sp,-16
    800023d0:	e406                	sd	ra,8(sp)
    800023d2:	e022                	sd	s0,0(sp)
    800023d4:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800023d6:	00005597          	auipc	a1,0x5
    800023da:	e7258593          	addi	a1,a1,-398 # 80007248 <etext+0x248>
    800023de:	00013517          	auipc	a0,0x13
    800023e2:	7aa50513          	addi	a0,a0,1962 # 80015b88 <tickslock>
    800023e6:	fb2fe0ef          	jal	80000b98 <initlock>
}
    800023ea:	60a2                	ld	ra,8(sp)
    800023ec:	6402                	ld	s0,0(sp)
    800023ee:	0141                	addi	sp,sp,16
    800023f0:	8082                	ret

00000000800023f2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800023f2:	1141                	addi	sp,sp,-16
    800023f4:	e406                	sd	ra,8(sp)
    800023f6:	e022                	sd	s0,0(sp)
    800023f8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r"(x));
    800023fa:	00003797          	auipc	a5,0x3
    800023fe:	05678793          	addi	a5,a5,86 # 80005450 <kernelvec>
    80002402:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80002406:	60a2                	ld	ra,8(sp)
    80002408:	6402                	ld	s0,0(sp)
    8000240a:	0141                	addi	sp,sp,16
    8000240c:	8082                	ret

000000008000240e <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000240e:	1141                	addi	sp,sp,-16
    80002410:	e406                	sd	ra,8(sp)
    80002412:	e022                	sd	s0,0(sp)
    80002414:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80002416:	cc8ff0ef          	jal	800018de <myproc>
  __asm__ __volatile__("csrc sstatus, %0" ::"rK"(x) : "memory");
    8000241a:	10017073          	csrci	sstatus,2
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000241e:	04000737          	lui	a4,0x4000
    80002422:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80002424:	0732                	slli	a4,a4,0xc
    80002426:	00004797          	auipc	a5,0x4
    8000242a:	bda78793          	addi	a5,a5,-1062 # 80006000 <_trampoline>
    8000242e:	00004697          	auipc	a3,0x4
    80002432:	bd268693          	addi	a3,a3,-1070 # 80006000 <_trampoline>
    80002436:	8f95                	sub	a5,a5,a3
    80002438:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000243a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000243e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r"(x));
    80002440:	18002773          	csrr	a4,satp
    80002444:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80002446:	6d38                	ld	a4,88(a0)
    80002448:	613c                	ld	a5,64(a0)
    8000244a:	6685                	lui	a3,0x1
    8000244c:	97b6                	add	a5,a5,a3
    8000244e:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80002450:	6d3c                	ld	a5,88(a0)
    80002452:	00000717          	auipc	a4,0x0
    80002456:	0f470713          	addi	a4,a4,244 # 80002546 <usertrap>
    8000245a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    8000245c:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r"(x));
    8000245e:	8712                	mv	a4,tp
    80002460:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002462:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.

  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80002466:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000246a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r"(x));
    8000246e:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80002472:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002474:	6f9c                	ld	a5,24(a5)
    80002476:	14179073          	csrw	sepc,a5
}
    8000247a:	60a2                	ld	ra,8(sp)
    8000247c:	6402                	ld	s0,0(sp)
    8000247e:	0141                	addi	sp,sp,16
    80002480:	8082                	ret

0000000080002482 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80002482:	1141                	addi	sp,sp,-16
    80002484:	e406                	sd	ra,8(sp)
    80002486:	e022                	sd	s0,0(sp)
    80002488:	0800                	addi	s0,sp,16
  if (cpuid() == 0) {
    8000248a:	c20ff0ef          	jal	800018aa <cpuid>
    8000248e:	cd11                	beqz	a0,800024aa <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r"(x));
    80002490:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80002494:	000f4737          	lui	a4,0xf4
    80002498:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000249c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r"(x));
    8000249e:	14d79073          	csrw	stimecmp,a5
}
    800024a2:	60a2                	ld	ra,8(sp)
    800024a4:	6402                	ld	s0,0(sp)
    800024a6:	0141                	addi	sp,sp,16
    800024a8:	8082                	ret
    acquire(&tickslock);
    800024aa:	00013517          	auipc	a0,0x13
    800024ae:	6de50513          	addi	a0,a0,1758 # 80015b88 <tickslock>
    800024b2:	f66fe0ef          	jal	80000c18 <acquire>
    ticks++;
    800024b6:	00005717          	auipc	a4,0x5
    800024ba:	5a270713          	addi	a4,a4,1442 # 80007a58 <ticks>
    800024be:	431c                	lw	a5,0(a4)
    800024c0:	2785                	addiw	a5,a5,1
    800024c2:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800024c4:	853a                	mv	a0,a4
    800024c6:	a5fff0ef          	jal	80001f24 <wakeup>
    release(&tickslock);
    800024ca:	00013517          	auipc	a0,0x13
    800024ce:	6be50513          	addi	a0,a0,1726 # 80015b88 <tickslock>
    800024d2:	fcafe0ef          	jal	80000c9c <release>
    800024d6:	bf6d                	j	80002490 <clockintr+0xe>

00000000800024d8 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800024d8:	1101                	addi	sp,sp,-32
    800024da:	ec06                	sd	ra,24(sp)
    800024dc:	e822                	sd	s0,16(sp)
    800024de:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r"(x));
    800024e0:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if (scause == 0x8000000000000009L) {
    800024e4:	57fd                	li	a5,-1
    800024e6:	17fe                	slli	a5,a5,0x3f
    800024e8:	07a5                	addi	a5,a5,9
    800024ea:	00f70c63          	beq	a4,a5,80002502 <devintr+0x2a>
    // now allowed to interrupt again.
    if (irq)
      plic_complete(irq);

    return 1;
  } else if (scause == 0x8000000000000005L) {
    800024ee:	57fd                	li	a5,-1
    800024f0:	17fe                	slli	a5,a5,0x3f
    800024f2:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800024f4:	4501                	li	a0,0
  } else if (scause == 0x8000000000000005L) {
    800024f6:	04f70463          	beq	a4,a5,8000253e <devintr+0x66>
  }
}
    800024fa:	60e2                	ld	ra,24(sp)
    800024fc:	6442                	ld	s0,16(sp)
    800024fe:	6105                	addi	sp,sp,32
    80002500:	8082                	ret
    80002502:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80002504:	7f9020ef          	jal	800054fc <plic_claim>
    80002508:	84aa                	mv	s1,a0
    if (irq == UART0_IRQ) {
    8000250a:	47a9                	li	a5,10
    8000250c:	02f50363          	beq	a0,a5,80002532 <devintr+0x5a>
    } else if (irq == VIRTIO0_IRQ) {
    80002510:	4785                	li	a5,1
    80002512:	02f50363          	beq	a0,a5,80002538 <devintr+0x60>
    } else if (irq) {
    80002516:	c919                	beqz	a0,8000252c <devintr+0x54>
      printk("unexpected interrupt irq=%d\n", irq);
    80002518:	85aa                	mv	a1,a0
    8000251a:	00005517          	auipc	a0,0x5
    8000251e:	d3650513          	addi	a0,a0,-714 # 80007250 <etext+0x250>
    80002522:	fe1fd0ef          	jal	80000502 <printk>
      plic_complete(irq);
    80002526:	8526                	mv	a0,s1
    80002528:	7f5020ef          	jal	8000551c <plic_complete>
    return 1;
    8000252c:	4505                	li	a0,1
    8000252e:	64a2                	ld	s1,8(sp)
    80002530:	b7e9                	j	800024fa <devintr+0x22>
      uartintr();
    80002532:	cacfe0ef          	jal	800009de <uartintr>
    if (irq)
    80002536:	bfc5                	j	80002526 <devintr+0x4e>
      virtio_disk_intr();
    80002538:	448030ef          	jal	80005980 <virtio_disk_intr>
    if (irq)
    8000253c:	b7ed                	j	80002526 <devintr+0x4e>
    clockintr();
    8000253e:	f45ff0ef          	jal	80002482 <clockintr>
    return 2;
    80002542:	4509                	li	a0,2
    80002544:	bf5d                	j	800024fa <devintr+0x22>

0000000080002546 <usertrap>:
{
    80002546:	1101                	addi	sp,sp,-32
    80002548:	ec06                	sd	ra,24(sp)
    8000254a:	e822                	sd	s0,16(sp)
    8000254c:	e426                	sd	s1,8(sp)
    8000254e:	e04a                	sd	s2,0(sp)
    80002550:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r"(x));
    80002552:	100027f3          	csrr	a5,sstatus
  if ((r_sstatus() & SSTATUS_SPP) != 0)
    80002556:	1007f793          	andi	a5,a5,256
    8000255a:	eba5                	bnez	a5,800025ca <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r"(x));
    8000255c:	00003797          	auipc	a5,0x3
    80002560:	ef478793          	addi	a5,a5,-268 # 80005450 <kernelvec>
    80002564:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002568:	b76ff0ef          	jal	800018de <myproc>
    8000256c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000256e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r"(x));
    80002570:	14102773          	csrr	a4,sepc
    80002574:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r"(x));
    80002576:	14202773          	csrr	a4,scause
  if (r_scause() == 8) {
    8000257a:	47a1                	li	a5,8
    8000257c:	04f70d63          	beq	a4,a5,800025d6 <usertrap+0x90>
  } else if ((which_dev = devintr()) != 0) {
    80002580:	f59ff0ef          	jal	800024d8 <devintr>
    80002584:	892a                	mv	s2,a0
    80002586:	e545                	bnez	a0,8000262e <usertrap+0xe8>
    80002588:	14202773          	csrr	a4,scause
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000258c:	47bd                	li	a5,15
    8000258e:	08f70463          	beq	a4,a5,80002616 <usertrap+0xd0>
    80002592:	14202773          	csrr	a4,scause
    80002596:	47b5                	li	a5,13
    80002598:	06f70f63          	beq	a4,a5,80002616 <usertrap+0xd0>
    8000259c:	142025f3          	csrr	a1,scause
    printk("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    800025a0:	5890                	lw	a2,48(s1)
    800025a2:	00005517          	auipc	a0,0x5
    800025a6:	cee50513          	addi	a0,a0,-786 # 80007290 <etext+0x290>
    800025aa:	f59fd0ef          	jal	80000502 <printk>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800025ae:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800025b2:	14302673          	csrr	a2,stval
    printk("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800025b6:	00005517          	auipc	a0,0x5
    800025ba:	d0a50513          	addi	a0,a0,-758 # 800072c0 <etext+0x2c0>
    800025be:	f45fd0ef          	jal	80000502 <printk>
    setkilled(p);
    800025c2:	8526                	mv	a0,s1
    800025c4:	b2dff0ef          	jal	800020f0 <setkilled>
    800025c8:	a015                	j	800025ec <usertrap+0xa6>
    panic("usertrap: not from user mode");
    800025ca:	00005517          	auipc	a0,0x5
    800025ce:	ca650513          	addi	a0,a0,-858 # 80007270 <etext+0x270>
    800025d2:	a68fe0ef          	jal	8000083a <panic>
    if (killed(p))
    800025d6:	b3fff0ef          	jal	80002114 <killed>
    800025da:	e915                	bnez	a0,8000260e <usertrap+0xc8>
    p->trapframe->epc += 4;
    800025dc:	6cb8                	ld	a4,88(s1)
    800025de:	6f1c                	ld	a5,24(a4)
    800025e0:	0791                	addi	a5,a5,4
    800025e2:	ef1c                	sd	a5,24(a4)
  __asm__ __volatile__("csrs sstatus, %0" ::"rK"(x) : "memory");
    800025e4:	10016073          	csrsi	sstatus,2
    syscall();
    800025e8:	23c000ef          	jal	80002824 <syscall>
  if (killed(p))
    800025ec:	8526                	mv	a0,s1
    800025ee:	b27ff0ef          	jal	80002114 <killed>
    800025f2:	e139                	bnez	a0,80002638 <usertrap+0xf2>
  prepare_return();
    800025f4:	e1bff0ef          	jal	8000240e <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800025f8:	68a8                	ld	a0,80(s1)
    800025fa:	8131                	srli	a0,a0,0xc
    800025fc:	57fd                	li	a5,-1
    800025fe:	17fe                	slli	a5,a5,0x3f
    80002600:	8d5d                	or	a0,a0,a5
}
    80002602:	60e2                	ld	ra,24(sp)
    80002604:	6442                	ld	s0,16(sp)
    80002606:	64a2                	ld	s1,8(sp)
    80002608:	6902                	ld	s2,0(sp)
    8000260a:	6105                	addi	sp,sp,32
    8000260c:	8082                	ret
      kexit(-1);
    8000260e:	557d                	li	a0,-1
    80002610:	9d5ff0ef          	jal	80001fe4 <kexit>
    80002614:	b7e1                	j	800025dc <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r"(x));
    80002616:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r"(x));
    8000261a:	14202673          	csrr	a2,scause
             vmfault(p->pagetable, r_stval(), (r_scause() == 13) ? 1 : 0) !=
    8000261e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002620:	00163613          	seqz	a2,a2
    80002624:	68a8                	ld	a0,80(s1)
    80002626:	f6bfe0ef          	jal	80001590 <vmfault>
  } else if ((r_scause() == 15 || r_scause() == 13) &&
    8000262a:	f169                	bnez	a0,800025ec <usertrap+0xa6>
    8000262c:	bf85                	j	8000259c <usertrap+0x56>
  if (killed(p))
    8000262e:	8526                	mv	a0,s1
    80002630:	ae5ff0ef          	jal	80002114 <killed>
    80002634:	c511                	beqz	a0,80002640 <usertrap+0xfa>
    80002636:	a011                	j	8000263a <usertrap+0xf4>
    80002638:	4901                	li	s2,0
    kexit(-1);
    8000263a:	557d                	li	a0,-1
    8000263c:	9a9ff0ef          	jal	80001fe4 <kexit>
  if (which_dev == 2)
    80002640:	4789                	li	a5,2
    80002642:	faf919e3          	bne	s2,a5,800025f4 <usertrap+0xae>
    yield();
    80002646:	867ff0ef          	jal	80001eac <yield>
    8000264a:	b76d                	j	800025f4 <usertrap+0xae>

000000008000264c <kerneltrap>:
{
    8000264c:	7179                	addi	sp,sp,-48
    8000264e:	f406                	sd	ra,40(sp)
    80002650:	f022                	sd	s0,32(sp)
    80002652:	ec26                	sd	s1,24(sp)
    80002654:	e84a                	sd	s2,16(sp)
    80002656:	e44e                	sd	s3,8(sp)
    80002658:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r"(x));
    8000265a:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000265e:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r"(x));
    80002662:	142027f3          	csrr	a5,scause
    80002666:	89be                	mv	s3,a5
  if ((sstatus & SSTATUS_SPP) == 0)
    80002668:	1004f793          	andi	a5,s1,256
    8000266c:	c795                	beqz	a5,80002698 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r"(x));
    8000266e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80002672:	8b89                	andi	a5,a5,2
  if (intr_get() != 0)
    80002674:	eb85                	bnez	a5,800026a4 <kerneltrap+0x58>
  if ((which_dev = devintr()) == 0) {
    80002676:	e63ff0ef          	jal	800024d8 <devintr>
    8000267a:	c91d                	beqz	a0,800026b0 <kerneltrap+0x64>
  if (which_dev == 2 && myproc() != 0)
    8000267c:	4789                	li	a5,2
    8000267e:	04f50a63          	beq	a0,a5,800026d2 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r"(x));
    80002682:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r"(x));
    80002686:	10049073          	csrw	sstatus,s1
}
    8000268a:	70a2                	ld	ra,40(sp)
    8000268c:	7402                	ld	s0,32(sp)
    8000268e:	64e2                	ld	s1,24(sp)
    80002690:	6942                	ld	s2,16(sp)
    80002692:	69a2                	ld	s3,8(sp)
    80002694:	6145                	addi	sp,sp,48
    80002696:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002698:	00005517          	auipc	a0,0x5
    8000269c:	c5050513          	addi	a0,a0,-944 # 800072e8 <etext+0x2e8>
    800026a0:	99afe0ef          	jal	8000083a <panic>
    panic("kerneltrap: interrupts enabled");
    800026a4:	00005517          	auipc	a0,0x5
    800026a8:	c6c50513          	addi	a0,a0,-916 # 80007310 <etext+0x310>
    800026ac:	98efe0ef          	jal	8000083a <panic>
  asm volatile("csrr %0, sepc" : "=r"(x));
    800026b0:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r"(x));
    800026b4:	143026f3          	csrr	a3,stval
    printk("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(),
    800026b8:	85ce                	mv	a1,s3
    800026ba:	00005517          	auipc	a0,0x5
    800026be:	c7650513          	addi	a0,a0,-906 # 80007330 <etext+0x330>
    800026c2:	e41fd0ef          	jal	80000502 <printk>
    panic("kerneltrap");
    800026c6:	00005517          	auipc	a0,0x5
    800026ca:	c9250513          	addi	a0,a0,-878 # 80007358 <etext+0x358>
    800026ce:	96cfe0ef          	jal	8000083a <panic>
  if (which_dev == 2 && myproc() != 0)
    800026d2:	a0cff0ef          	jal	800018de <myproc>
    800026d6:	d555                	beqz	a0,80002682 <kerneltrap+0x36>
    yield();
    800026d8:	fd4ff0ef          	jal	80001eac <yield>
    800026dc:	b75d                	j	80002682 <kerneltrap+0x36>

00000000800026de <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800026de:	1101                	addi	sp,sp,-32
    800026e0:	ec06                	sd	ra,24(sp)
    800026e2:	e822                	sd	s0,16(sp)
    800026e4:	e426                	sd	s1,8(sp)
    800026e6:	1000                	addi	s0,sp,32
    800026e8:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800026ea:	9f4ff0ef          	jal	800018de <myproc>
  switch (n) {
    800026ee:	4795                	li	a5,5
    800026f0:	0497e163          	bltu	a5,s1,80002732 <argraw+0x54>
    800026f4:	048a                	slli	s1,s1,0x2
    800026f6:	00005717          	auipc	a4,0x5
    800026fa:	16270713          	addi	a4,a4,354 # 80007858 <states.0+0x30>
    800026fe:	94ba                	add	s1,s1,a4
    80002700:	409c                	lw	a5,0(s1)
    80002702:	97ba                	add	a5,a5,a4
    80002704:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80002706:	6d3c                	ld	a5,88(a0)
    80002708:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    8000270a:	60e2                	ld	ra,24(sp)
    8000270c:	6442                	ld	s0,16(sp)
    8000270e:	64a2                	ld	s1,8(sp)
    80002710:	6105                	addi	sp,sp,32
    80002712:	8082                	ret
    return p->trapframe->a1;
    80002714:	6d3c                	ld	a5,88(a0)
    80002716:	7fa8                	ld	a0,120(a5)
    80002718:	bfcd                	j	8000270a <argraw+0x2c>
    return p->trapframe->a2;
    8000271a:	6d3c                	ld	a5,88(a0)
    8000271c:	63c8                	ld	a0,128(a5)
    8000271e:	b7f5                	j	8000270a <argraw+0x2c>
    return p->trapframe->a3;
    80002720:	6d3c                	ld	a5,88(a0)
    80002722:	67c8                	ld	a0,136(a5)
    80002724:	b7dd                	j	8000270a <argraw+0x2c>
    return p->trapframe->a4;
    80002726:	6d3c                	ld	a5,88(a0)
    80002728:	6bc8                	ld	a0,144(a5)
    8000272a:	b7c5                	j	8000270a <argraw+0x2c>
    return p->trapframe->a5;
    8000272c:	6d3c                	ld	a5,88(a0)
    8000272e:	6fc8                	ld	a0,152(a5)
    80002730:	bfe9                	j	8000270a <argraw+0x2c>
  panic("argraw");
    80002732:	00005517          	auipc	a0,0x5
    80002736:	c3650513          	addi	a0,a0,-970 # 80007368 <etext+0x368>
    8000273a:	900fe0ef          	jal	8000083a <panic>

000000008000273e <fetchaddr>:
{
    8000273e:	1101                	addi	sp,sp,-32
    80002740:	ec06                	sd	ra,24(sp)
    80002742:	e822                	sd	s0,16(sp)
    80002744:	e426                	sd	s1,8(sp)
    80002746:	e04a                	sd	s2,0(sp)
    80002748:	1000                	addi	s0,sp,32
    8000274a:	84aa                	mv	s1,a0
    8000274c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000274e:	990ff0ef          	jal	800018de <myproc>
  if (addr >= p->sz ||
    80002752:	653c                	ld	a5,72(a0)
    80002754:	02f4f663          	bgeu	s1,a5,80002780 <fetchaddr+0x42>
      addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002758:	00848713          	addi	a4,s1,8
  if (addr >= p->sz ||
    8000275c:	02e7e263          	bltu	a5,a4,80002780 <fetchaddr+0x42>
  if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002760:	46a1                	li	a3,8
    80002762:	8626                	mv	a2,s1
    80002764:	85ca                	mv	a1,s2
    80002766:	6928                	ld	a0,80(a0)
    80002768:	f61fe0ef          	jal	800016c8 <copyin>
    8000276c:	00a03533          	snez	a0,a0
    80002770:	40a0053b          	negw	a0,a0
}
    80002774:	60e2                	ld	ra,24(sp)
    80002776:	6442                	ld	s0,16(sp)
    80002778:	64a2                	ld	s1,8(sp)
    8000277a:	6902                	ld	s2,0(sp)
    8000277c:	6105                	addi	sp,sp,32
    8000277e:	8082                	ret
    return -1;
    80002780:	557d                	li	a0,-1
    80002782:	bfcd                	j	80002774 <fetchaddr+0x36>

0000000080002784 <fetchstr>:
{
    80002784:	7179                	addi	sp,sp,-48
    80002786:	f406                	sd	ra,40(sp)
    80002788:	f022                	sd	s0,32(sp)
    8000278a:	ec26                	sd	s1,24(sp)
    8000278c:	e84a                	sd	s2,16(sp)
    8000278e:	e44e                	sd	s3,8(sp)
    80002790:	1800                	addi	s0,sp,48
    80002792:	89aa                	mv	s3,a0
    80002794:	84ae                	mv	s1,a1
    80002796:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002798:	946ff0ef          	jal	800018de <myproc>
  if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000279c:	86ca                	mv	a3,s2
    8000279e:	864e                	mv	a2,s3
    800027a0:	85a6                	mv	a1,s1
    800027a2:	6928                	ld	a0,80(a0)
    800027a4:	d15fe0ef          	jal	800014b8 <copyinstr>
    800027a8:	00054c63          	bltz	a0,800027c0 <fetchstr+0x3c>
  return strlen(buf);
    800027ac:	8526                	mv	a0,s1
    800027ae:	ea6fe0ef          	jal	80000e54 <strlen>
}
    800027b2:	70a2                	ld	ra,40(sp)
    800027b4:	7402                	ld	s0,32(sp)
    800027b6:	64e2                	ld	s1,24(sp)
    800027b8:	6942                	ld	s2,16(sp)
    800027ba:	69a2                	ld	s3,8(sp)
    800027bc:	6145                	addi	sp,sp,48
    800027be:	8082                	ret
    return -1;
    800027c0:	557d                	li	a0,-1
    800027c2:	bfc5                	j	800027b2 <fetchstr+0x2e>

00000000800027c4 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800027c4:	1101                	addi	sp,sp,-32
    800027c6:	ec06                	sd	ra,24(sp)
    800027c8:	e822                	sd	s0,16(sp)
    800027ca:	e426                	sd	s1,8(sp)
    800027cc:	1000                	addi	s0,sp,32
    800027ce:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027d0:	f0fff0ef          	jal	800026de <argraw>
    800027d4:	c088                	sw	a0,0(s1)
}
    800027d6:	60e2                	ld	ra,24(sp)
    800027d8:	6442                	ld	s0,16(sp)
    800027da:	64a2                	ld	s1,8(sp)
    800027dc:	6105                	addi	sp,sp,32
    800027de:	8082                	ret

00000000800027e0 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800027e0:	1101                	addi	sp,sp,-32
    800027e2:	ec06                	sd	ra,24(sp)
    800027e4:	e822                	sd	s0,16(sp)
    800027e6:	e426                	sd	s1,8(sp)
    800027e8:	1000                	addi	s0,sp,32
    800027ea:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800027ec:	ef3ff0ef          	jal	800026de <argraw>
    800027f0:	e088                	sd	a0,0(s1)
}
    800027f2:	60e2                	ld	ra,24(sp)
    800027f4:	6442                	ld	s0,16(sp)
    800027f6:	64a2                	ld	s1,8(sp)
    800027f8:	6105                	addi	sp,sp,32
    800027fa:	8082                	ret

00000000800027fc <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (not including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800027fc:	1101                	addi	sp,sp,-32
    800027fe:	ec06                	sd	ra,24(sp)
    80002800:	e822                	sd	s0,16(sp)
    80002802:	e426                	sd	s1,8(sp)
    80002804:	e04a                	sd	s2,0(sp)
    80002806:	1000                	addi	s0,sp,32
    80002808:	892e                	mv	s2,a1
    8000280a:	84b2                	mv	s1,a2
  *ip = argraw(n);
    8000280c:	ed3ff0ef          	jal	800026de <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80002810:	8626                	mv	a2,s1
    80002812:	85ca                	mv	a1,s2
    80002814:	f71ff0ef          	jal	80002784 <fetchstr>
}
    80002818:	60e2                	ld	ra,24(sp)
    8000281a:	6442                	ld	s0,16(sp)
    8000281c:	64a2                	ld	s1,8(sp)
    8000281e:	6902                	ld	s2,0(sp)
    80002820:	6105                	addi	sp,sp,32
    80002822:	8082                	ret

0000000080002824 <syscall>:
  [SYS_race_reset] "race_reset",
};

void
syscall(void)
{
    80002824:	7179                	addi	sp,sp,-48
    80002826:	f406                	sd	ra,40(sp)
    80002828:	f022                	sd	s0,32(sp)
    8000282a:	ec26                	sd	s1,24(sp)
    8000282c:	e84a                	sd	s2,16(sp)
    8000282e:	e44e                	sd	s3,8(sp)
    80002830:	1800                	addi	s0,sp,48
  int num;
  struct proc *p = myproc();
    80002832:	8acff0ef          	jal	800018de <myproc>
    80002836:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002838:	05853903          	ld	s2,88(a0)
    8000283c:	0a893783          	ld	a5,168(s2)
    80002840:	0007899b          	sext.w	s3,a5
  if (num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002844:	37fd                	addiw	a5,a5,-1
    80002846:	4765                	li	a4,25
    80002848:	04f76b63          	bltu	a4,a5,8000289e <syscall+0x7a>
    8000284c:	00399713          	slli	a4,s3,0x3
    80002850:	00005797          	auipc	a5,0x5
    80002854:	02078793          	addi	a5,a5,32 # 80007870 <syscalls>
    80002858:	97ba                	add	a5,a5,a4
    8000285a:	639c                	ld	a5,0(a5)
    8000285c:	c3a9                	beqz	a5,8000289e <syscall+0x7a>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000285e:	9782                	jalr	a5
    80002860:	06a93823          	sd	a0,112(s2)
    if (num != SYS_exit && (p->tracing == 1 || (p->tracing & (1 << num)))) {
    80002864:	4789                	li	a5,2
    80002866:	04f98963          	beq	s3,a5,800028b8 <syscall+0x94>
    8000286a:	1684a783          	lw	a5,360(s1)
    8000286e:	4705                	li	a4,1
    80002870:	00e78663          	beq	a5,a4,8000287c <syscall+0x58>
    80002874:	4137d7bb          	sraw	a5,a5,s3
    80002878:	8ff9                	and	a5,a5,a4
    8000287a:	cf9d                	beqz	a5,800028b8 <syscall+0x94>
      printk("%d: %s -> %ld\n", p->pid, syscallnames[num], (long)p->trapframe->a0);
    8000287c:	6cb8                	ld	a4,88(s1)
    8000287e:	098e                	slli	s3,s3,0x3
    80002880:	00005797          	auipc	a5,0x5
    80002884:	ff078793          	addi	a5,a5,-16 # 80007870 <syscalls>
    80002888:	97ce                	add	a5,a5,s3
    8000288a:	7b34                	ld	a3,112(a4)
    8000288c:	6ff0                	ld	a2,216(a5)
    8000288e:	588c                	lw	a1,48(s1)
    80002890:	00005517          	auipc	a0,0x5
    80002894:	ae050513          	addi	a0,a0,-1312 # 80007370 <etext+0x370>
    80002898:	c6bfd0ef          	jal	80000502 <printk>
    8000289c:	a831                	j	800028b8 <syscall+0x94>
    }
  } else {
    printk("%d %s: unknown sys call %d\n", p->pid, p->name, num);
    8000289e:	86ce                	mv	a3,s3
    800028a0:	15848613          	addi	a2,s1,344
    800028a4:	588c                	lw	a1,48(s1)
    800028a6:	00005517          	auipc	a0,0x5
    800028aa:	ada50513          	addi	a0,a0,-1318 # 80007380 <etext+0x380>
    800028ae:	c55fd0ef          	jal	80000502 <printk>
    p->trapframe->a0 = -1;
    800028b2:	6cbc                	ld	a5,88(s1)
    800028b4:	577d                	li	a4,-1
    800028b6:	fbb8                	sd	a4,112(a5)
  }
}
    800028b8:	70a2                	ld	ra,40(sp)
    800028ba:	7402                	ld	s0,32(sp)
    800028bc:	64e2                	ld	s1,24(sp)
    800028be:	6942                	ld	s2,16(sp)
    800028c0:	69a2                	ld	s3,8(sp)
    800028c2:	6145                	addi	sp,sp,48
    800028c4:	8082                	ret

00000000800028c6 <sys_exit>:
#include "vm.h"
#include "syscall.h"

uint64
sys_exit(void)
{
    800028c6:	1101                	addi	sp,sp,-32
    800028c8:	ec06                	sd	ra,24(sp)
    800028ca:	e822                	sd	s0,16(sp)
    800028cc:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800028ce:	fec40593          	addi	a1,s0,-20
    800028d2:	4501                	li	a0,0
    800028d4:	ef1ff0ef          	jal	800027c4 <argint>
  if (myproc()->tracing == 1 || (myproc()->tracing & (1 << SYS_exit))) {
    800028d8:	806ff0ef          	jal	800018de <myproc>
    800028dc:	16852703          	lw	a4,360(a0)
    800028e0:	4785                	li	a5,1
    800028e2:	00f70863          	beq	a4,a5,800028f2 <sys_exit+0x2c>
    800028e6:	ff9fe0ef          	jal	800018de <myproc>
    800028ea:	16852783          	lw	a5,360(a0)
    800028ee:	8b91                	andi	a5,a5,4
    800028f0:	cf81                	beqz	a5,80002908 <sys_exit+0x42>
    printk("%d: exit -> %d\n", myproc()->pid, n);
    800028f2:	fedfe0ef          	jal	800018de <myproc>
    800028f6:	fec42603          	lw	a2,-20(s0)
    800028fa:	590c                	lw	a1,48(a0)
    800028fc:	00005517          	auipc	a0,0x5
    80002900:	b7c50513          	addi	a0,a0,-1156 # 80007478 <etext+0x478>
    80002904:	bfffd0ef          	jal	80000502 <printk>
  }
  kexit(n);
    80002908:	fec42503          	lw	a0,-20(s0)
    8000290c:	ed8ff0ef          	jal	80001fe4 <kexit>
  return 0; // not reached
}
    80002910:	4501                	li	a0,0
    80002912:	60e2                	ld	ra,24(sp)
    80002914:	6442                	ld	s0,16(sp)
    80002916:	6105                	addi	sp,sp,32
    80002918:	8082                	ret

000000008000291a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000291a:	1141                	addi	sp,sp,-16
    8000291c:	e406                	sd	ra,8(sp)
    8000291e:	e022                	sd	s0,0(sp)
    80002920:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002922:	fbdfe0ef          	jal	800018de <myproc>
}
    80002926:	5908                	lw	a0,48(a0)
    80002928:	60a2                	ld	ra,8(sp)
    8000292a:	6402                	ld	s0,0(sp)
    8000292c:	0141                	addi	sp,sp,16
    8000292e:	8082                	ret

0000000080002930 <sys_fork>:

uint64
sys_fork(void)
{
    80002930:	1141                	addi	sp,sp,-16
    80002932:	e406                	sd	ra,8(sp)
    80002934:	e022                	sd	s0,0(sp)
    80002936:	0800                	addi	s0,sp,16
  return kfork();
    80002938:	b10ff0ef          	jal	80001c48 <kfork>
}
    8000293c:	60a2                	ld	ra,8(sp)
    8000293e:	6402                	ld	s0,0(sp)
    80002940:	0141                	addi	sp,sp,16
    80002942:	8082                	ret

0000000080002944 <sys_wait>:

uint64
sys_wait(void)
{
    80002944:	1101                	addi	sp,sp,-32
    80002946:	ec06                	sd	ra,24(sp)
    80002948:	e822                	sd	s0,16(sp)
    8000294a:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    8000294c:	fe840593          	addi	a1,s0,-24
    80002950:	4501                	li	a0,0
    80002952:	e8fff0ef          	jal	800027e0 <argaddr>
  return kwait(p);
    80002956:	fe843503          	ld	a0,-24(s0)
    8000295a:	fe4ff0ef          	jal	8000213e <kwait>
}
    8000295e:	60e2                	ld	ra,24(sp)
    80002960:	6442                	ld	s0,16(sp)
    80002962:	6105                	addi	sp,sp,32
    80002964:	8082                	ret

0000000080002966 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002966:	7179                	addi	sp,sp,-48
    80002968:	f406                	sd	ra,40(sp)
    8000296a:	f022                	sd	s0,32(sp)
    8000296c:	ec26                	sd	s1,24(sp)
    8000296e:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002970:	fd840593          	addi	a1,s0,-40
    80002974:	4501                	li	a0,0
    80002976:	e4fff0ef          	jal	800027c4 <argint>
  argint(1, &t);
    8000297a:	fdc40593          	addi	a1,s0,-36
    8000297e:	4505                	li	a0,1
    80002980:	e45ff0ef          	jal	800027c4 <argint>
  addr = myproc()->sz;
    80002984:	f5bfe0ef          	jal	800018de <myproc>
    80002988:	6524                	ld	s1,72(a0)

  if (t == SBRK_EAGER || n < 0) {
    8000298a:	fdc42703          	lw	a4,-36(s0)
    8000298e:	4785                	li	a5,1
    80002990:	02f70a63          	beq	a4,a5,800029c4 <sys_sbrk+0x5e>
    80002994:	fd842783          	lw	a5,-40(s0)
    80002998:	0207c663          	bltz	a5,800029c4 <sys_sbrk+0x5e>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if (addr + n < addr)
    8000299c:	00978733          	add	a4,a5,s1
      return -1;
    if (addr + n > TRAPFRAME)
    800029a0:	020007b7          	lui	a5,0x2000
    800029a4:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    800029a6:	07b6                	slli	a5,a5,0xd
    800029a8:	00e7b7b3          	sltu	a5,a5,a4
    if (addr + n < addr)
    800029ac:	00973733          	sltu	a4,a4,s1
    if (addr + n > TRAPFRAME)
    800029b0:	8fd9                	or	a5,a5,a4
    800029b2:	e79d                	bnez	a5,800029e0 <sys_sbrk+0x7a>
      return -1;
    myproc()->sz += n;
    800029b4:	f2bfe0ef          	jal	800018de <myproc>
    800029b8:	fd842703          	lw	a4,-40(s0)
    800029bc:	653c                	ld	a5,72(a0)
    800029be:	97ba                	add	a5,a5,a4
    800029c0:	e53c                	sd	a5,72(a0)
    800029c2:	a039                	j	800029d0 <sys_sbrk+0x6a>
    if (growproc(n) < 0) {
    800029c4:	fd842503          	lw	a0,-40(s0)
    800029c8:	a22ff0ef          	jal	80001bea <growproc>
    800029cc:	00054863          	bltz	a0,800029dc <sys_sbrk+0x76>
  }
  return addr;
}
    800029d0:	8526                	mv	a0,s1
    800029d2:	70a2                	ld	ra,40(sp)
    800029d4:	7402                	ld	s0,32(sp)
    800029d6:	64e2                	ld	s1,24(sp)
    800029d8:	6145                	addi	sp,sp,48
    800029da:	8082                	ret
      return -1;
    800029dc:	54fd                	li	s1,-1
    800029de:	bfcd                	j	800029d0 <sys_sbrk+0x6a>
      return -1;
    800029e0:	54fd                	li	s1,-1
    800029e2:	b7fd                	j	800029d0 <sys_sbrk+0x6a>

00000000800029e4 <sys_pause>:

uint64
sys_pause(void)
{
    800029e4:	7139                	addi	sp,sp,-64
    800029e6:	fc06                	sd	ra,56(sp)
    800029e8:	f822                	sd	s0,48(sp)
    800029ea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800029ec:	fcc40593          	addi	a1,s0,-52
    800029f0:	4501                	li	a0,0
    800029f2:	dd3ff0ef          	jal	800027c4 <argint>
  if (n < 0)
    800029f6:	fcc42783          	lw	a5,-52(s0)
    800029fa:	0607c863          	bltz	a5,80002a6a <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    800029fe:	00013517          	auipc	a0,0x13
    80002a02:	18a50513          	addi	a0,a0,394 # 80015b88 <tickslock>
    80002a06:	a12fe0ef          	jal	80000c18 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
    80002a0a:	fcc42783          	lw	a5,-52(s0)
    80002a0e:	c3b9                	beqz	a5,80002a54 <sys_pause+0x70>
    80002a10:	f426                	sd	s1,40(sp)
    80002a12:	f04a                	sd	s2,32(sp)
    80002a14:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002a16:	00005997          	auipc	s3,0x5
    80002a1a:	0429a983          	lw	s3,66(s3) # 80007a58 <ticks>
    if (killed(myproc())) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002a1e:	00013917          	auipc	s2,0x13
    80002a22:	16a90913          	addi	s2,s2,362 # 80015b88 <tickslock>
    80002a26:	00005497          	auipc	s1,0x5
    80002a2a:	03248493          	addi	s1,s1,50 # 80007a58 <ticks>
    if (killed(myproc())) {
    80002a2e:	eb1fe0ef          	jal	800018de <myproc>
    80002a32:	ee2ff0ef          	jal	80002114 <killed>
    80002a36:	ed0d                	bnez	a0,80002a70 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002a38:	85ca                	mv	a1,s2
    80002a3a:	8526                	mv	a0,s1
    80002a3c:	c9cff0ef          	jal	80001ed8 <sleep>
  while (ticks - ticks0 < n) {
    80002a40:	409c                	lw	a5,0(s1)
    80002a42:	413787bb          	subw	a5,a5,s3
    80002a46:	fcc42703          	lw	a4,-52(s0)
    80002a4a:	fee7e2e3          	bltu	a5,a4,80002a2e <sys_pause+0x4a>
    80002a4e:	74a2                	ld	s1,40(sp)
    80002a50:	7902                	ld	s2,32(sp)
    80002a52:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002a54:	00013517          	auipc	a0,0x13
    80002a58:	13450513          	addi	a0,a0,308 # 80015b88 <tickslock>
    80002a5c:	a40fe0ef          	jal	80000c9c <release>
  return 0;
    80002a60:	4501                	li	a0,0
}
    80002a62:	70e2                	ld	ra,56(sp)
    80002a64:	7442                	ld	s0,48(sp)
    80002a66:	6121                	addi	sp,sp,64
    80002a68:	8082                	ret
    n = 0;
    80002a6a:	fc042623          	sw	zero,-52(s0)
    80002a6e:	bf41                	j	800029fe <sys_pause+0x1a>
      release(&tickslock);
    80002a70:	00013517          	auipc	a0,0x13
    80002a74:	11850513          	addi	a0,a0,280 # 80015b88 <tickslock>
    80002a78:	a24fe0ef          	jal	80000c9c <release>
      return -1;
    80002a7c:	557d                	li	a0,-1
    80002a7e:	74a2                	ld	s1,40(sp)
    80002a80:	7902                	ld	s2,32(sp)
    80002a82:	69e2                	ld	s3,24(sp)
    80002a84:	bff9                	j	80002a62 <sys_pause+0x7e>

0000000080002a86 <sys_kill>:

uint64
sys_kill(void)
{
    80002a86:	1101                	addi	sp,sp,-32
    80002a88:	ec06                	sd	ra,24(sp)
    80002a8a:	e822                	sd	s0,16(sp)
    80002a8c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002a8e:	fec40593          	addi	a1,s0,-20
    80002a92:	4501                	li	a0,0
    80002a94:	d31ff0ef          	jal	800027c4 <argint>
  return kkill(pid);
    80002a98:	fec42503          	lw	a0,-20(s0)
    80002a9c:	deeff0ef          	jal	8000208a <kkill>
}
    80002aa0:	60e2                	ld	ra,24(sp)
    80002aa2:	6442                	ld	s0,16(sp)
    80002aa4:	6105                	addi	sp,sp,32
    80002aa6:	8082                	ret

0000000080002aa8 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002aa8:	1101                	addi	sp,sp,-32
    80002aaa:	ec06                	sd	ra,24(sp)
    80002aac:	e822                	sd	s0,16(sp)
    80002aae:	e426                	sd	s1,8(sp)
    80002ab0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002ab2:	00013517          	auipc	a0,0x13
    80002ab6:	0d650513          	addi	a0,a0,214 # 80015b88 <tickslock>
    80002aba:	95efe0ef          	jal	80000c18 <acquire>
  xticks = ticks;
    80002abe:	00005797          	auipc	a5,0x5
    80002ac2:	f9a7a783          	lw	a5,-102(a5) # 80007a58 <ticks>
    80002ac6:	84be                	mv	s1,a5
  release(&tickslock);
    80002ac8:	00013517          	auipc	a0,0x13
    80002acc:	0c050513          	addi	a0,a0,192 # 80015b88 <tickslock>
    80002ad0:	9ccfe0ef          	jal	80000c9c <release>
  return xticks;
}
    80002ad4:	02049513          	slli	a0,s1,0x20
    80002ad8:	9101                	srli	a0,a0,0x20
    80002ada:	60e2                	ld	ra,24(sp)
    80002adc:	6442                	ld	s0,16(sp)
    80002ade:	64a2                	ld	s1,8(sp)
    80002ae0:	6105                	addi	sp,sp,32
    80002ae2:	8082                	ret

0000000080002ae4 <sys_trace>:

uint64
sys_trace(void)
{
    80002ae4:	1101                	addi	sp,sp,-32
    80002ae6:	ec06                	sd	ra,24(sp)
    80002ae8:	e822                	sd	s0,16(sp)
    80002aea:	1000                	addi	s0,sp,32
  int on;
  argint(0, &on);
    80002aec:	fec40593          	addi	a1,s0,-20
    80002af0:	4501                	li	a0,0
    80002af2:	cd3ff0ef          	jal	800027c4 <argint>
  myproc()->tracing = on;
    80002af6:	de9fe0ef          	jal	800018de <myproc>
    80002afa:	fec42783          	lw	a5,-20(s0)
    80002afe:	16f52423          	sw	a5,360(a0)
  return 0;
}
    80002b02:	4501                	li	a0,0
    80002b04:	60e2                	ld	ra,24(sp)
    80002b06:	6442                	ld	s0,16(sp)
    80002b08:	6105                	addi	sp,sp,32
    80002b0a:	8082                	ret

0000000080002b0c <sys_race_inc>:

uint64
sys_race_inc(void)
{
    80002b0c:	1101                	addi	sp,sp,-32
    80002b0e:	ec06                	sd	ra,24(sp)
    80002b10:	e822                	sd	s0,16(sp)
    80002b12:	1000                	addi	s0,sp,32
  int iters, use_lock;
  argint(0, &iters);
    80002b14:	fec40593          	addi	a1,s0,-20
    80002b18:	4501                	li	a0,0
    80002b1a:	cabff0ef          	jal	800027c4 <argint>
  argint(1, &use_lock);
    80002b1e:	fe840593          	addi	a1,s0,-24
    80002b22:	4505                	li	a0,1
    80002b24:	ca1ff0ef          	jal	800027c4 <argint>
  return race_increment(iters, use_lock);
    80002b28:	fe842583          	lw	a1,-24(s0)
    80002b2c:	fec42503          	lw	a0,-20(s0)
    80002b30:	795020ef          	jal	80005ac4 <race_increment>
}
    80002b34:	60e2                	ld	ra,24(sp)
    80002b36:	6442                	ld	s0,16(sp)
    80002b38:	6105                	addi	sp,sp,32
    80002b3a:	8082                	ret

0000000080002b3c <sys_race_get>:

uint64
sys_race_get(void)
{
    80002b3c:	1141                	addi	sp,sp,-16
    80002b3e:	e406                	sd	ra,8(sp)
    80002b40:	e022                	sd	s0,0(sp)
    80002b42:	0800                	addi	s0,sp,16
  return race_get_counter();
    80002b44:	749020ef          	jal	80005a8c <race_get_counter>
}
    80002b48:	60a2                	ld	ra,8(sp)
    80002b4a:	6402                	ld	s0,0(sp)
    80002b4c:	0141                	addi	sp,sp,16
    80002b4e:	8082                	ret

0000000080002b50 <sys_race_reset>:

uint64
sys_race_reset(void)
{
    80002b50:	1141                	addi	sp,sp,-16
    80002b52:	e406                	sd	ra,8(sp)
    80002b54:	e022                	sd	s0,0(sp)
    80002b56:	0800                	addi	s0,sp,16
  return race_reset();
    80002b58:	703020ef          	jal	80005a5a <race_reset>
}
    80002b5c:	60a2                	ld	ra,8(sp)
    80002b5e:	6402                	ld	s0,0(sp)
    80002b60:	0141                	addi	sp,sp,16
    80002b62:	8082                	ret

0000000080002b64 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002b64:	7179                	addi	sp,sp,-48
    80002b66:	f406                	sd	ra,40(sp)
    80002b68:	f022                	sd	s0,32(sp)
    80002b6a:	ec26                	sd	s1,24(sp)
    80002b6c:	e84a                	sd	s2,16(sp)
    80002b6e:	e44e                	sd	s3,8(sp)
    80002b70:	e052                	sd	s4,0(sp)
    80002b72:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002b74:	00005597          	auipc	a1,0x5
    80002b78:	91458593          	addi	a1,a1,-1772 # 80007488 <etext+0x488>
    80002b7c:	00013517          	auipc	a0,0x13
    80002b80:	02450513          	addi	a0,a0,36 # 80015ba0 <bcache>
    80002b84:	814fe0ef          	jal	80000b98 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002b88:	0001b797          	auipc	a5,0x1b
    80002b8c:	01878793          	addi	a5,a5,24 # 8001dba0 <bcache+0x8000>
    80002b90:	0001b717          	auipc	a4,0x1b
    80002b94:	27870713          	addi	a4,a4,632 # 8001de08 <bcache+0x8268>
    80002b98:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002b9c:	2ae7bc23          	sd	a4,696(a5)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002ba0:	00013497          	auipc	s1,0x13
    80002ba4:	01848493          	addi	s1,s1,24 # 80015bb8 <bcache+0x18>
    b->next = bcache.head.next;
    80002ba8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002baa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002bac:	00005a17          	auipc	s4,0x5
    80002bb0:	8e4a0a13          	addi	s4,s4,-1820 # 80007490 <etext+0x490>
    b->next = bcache.head.next;
    80002bb4:	2b893783          	ld	a5,696(s2)
    80002bb8:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002bba:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002bbe:	85d2                	mv	a1,s4
    80002bc0:	01048513          	addi	a0,s1,16
    80002bc4:	394010ef          	jal	80003f58 <initsleeplock>
    bcache.head.next->prev = b;
    80002bc8:	2b893783          	ld	a5,696(s2)
    80002bcc:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002bce:	2a993c23          	sd	s1,696(s2)
  for (b = bcache.buf; b < bcache.buf + NBUF; b++) {
    80002bd2:	45848493          	addi	s1,s1,1112
    80002bd6:	fd349fe3          	bne	s1,s3,80002bb4 <binit+0x50>
  }
}
    80002bda:	70a2                	ld	ra,40(sp)
    80002bdc:	7402                	ld	s0,32(sp)
    80002bde:	64e2                	ld	s1,24(sp)
    80002be0:	6942                	ld	s2,16(sp)
    80002be2:	69a2                	ld	s3,8(sp)
    80002be4:	6a02                	ld	s4,0(sp)
    80002be6:	6145                	addi	sp,sp,48
    80002be8:	8082                	ret

0000000080002bea <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf *
bread(uint dev, uint blockno)
{
    80002bea:	7179                	addi	sp,sp,-48
    80002bec:	f406                	sd	ra,40(sp)
    80002bee:	f022                	sd	s0,32(sp)
    80002bf0:	ec26                	sd	s1,24(sp)
    80002bf2:	e84a                	sd	s2,16(sp)
    80002bf4:	e44e                	sd	s3,8(sp)
    80002bf6:	1800                	addi	s0,sp,48
    80002bf8:	892a                	mv	s2,a0
    80002bfa:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002bfc:	00013517          	auipc	a0,0x13
    80002c00:	fa450513          	addi	a0,a0,-92 # 80015ba0 <bcache>
    80002c04:	814fe0ef          	jal	80000c18 <acquire>
  for (b = bcache.head.next; b != &bcache.head; b = b->next) {
    80002c08:	0001b497          	auipc	s1,0x1b
    80002c0c:	2504b483          	ld	s1,592(s1) # 8001de58 <bcache+0x82b8>
    80002c10:	0001b797          	auipc	a5,0x1b
    80002c14:	1f878793          	addi	a5,a5,504 # 8001de08 <bcache+0x8268>
    80002c18:	02f48b63          	beq	s1,a5,80002c4e <bread+0x64>
    80002c1c:	873e                	mv	a4,a5
    80002c1e:	a021                	j	80002c26 <bread+0x3c>
    80002c20:	68a4                	ld	s1,80(s1)
    80002c22:	02e48663          	beq	s1,a4,80002c4e <bread+0x64>
    if (b->dev == dev && b->blockno == blockno) {
    80002c26:	449c                	lw	a5,8(s1)
    80002c28:	ff279ce3          	bne	a5,s2,80002c20 <bread+0x36>
    80002c2c:	44dc                	lw	a5,12(s1)
    80002c2e:	ff3799e3          	bne	a5,s3,80002c20 <bread+0x36>
      b->refcnt++;
    80002c32:	40bc                	lw	a5,64(s1)
    80002c34:	2785                	addiw	a5,a5,1
    80002c36:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c38:	00013517          	auipc	a0,0x13
    80002c3c:	f6850513          	addi	a0,a0,-152 # 80015ba0 <bcache>
    80002c40:	85cfe0ef          	jal	80000c9c <release>
      acquiresleep(&b->lock);
    80002c44:	01048513          	addi	a0,s1,16
    80002c48:	346010ef          	jal	80003f8e <acquiresleep>
      return b;
    80002c4c:	a889                	j	80002c9e <bread+0xb4>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c4e:	0001b497          	auipc	s1,0x1b
    80002c52:	2024b483          	ld	s1,514(s1) # 8001de50 <bcache+0x82b0>
    80002c56:	0001b797          	auipc	a5,0x1b
    80002c5a:	1b278793          	addi	a5,a5,434 # 8001de08 <bcache+0x8268>
    80002c5e:	00f48863          	beq	s1,a5,80002c6e <bread+0x84>
    80002c62:	873e                	mv	a4,a5
    if (b->refcnt == 0) {
    80002c64:	40bc                	lw	a5,64(s1)
    80002c66:	cb91                	beqz	a5,80002c7a <bread+0x90>
  for (b = bcache.head.prev; b != &bcache.head; b = b->prev) {
    80002c68:	64a4                	ld	s1,72(s1)
    80002c6a:	fee49de3          	bne	s1,a4,80002c64 <bread+0x7a>
  panic("bget: no buffers");
    80002c6e:	00005517          	auipc	a0,0x5
    80002c72:	82a50513          	addi	a0,a0,-2006 # 80007498 <etext+0x498>
    80002c76:	bc5fd0ef          	jal	8000083a <panic>
      b->dev = dev;
    80002c7a:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002c7e:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002c82:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002c86:	4785                	li	a5,1
    80002c88:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002c8a:	00013517          	auipc	a0,0x13
    80002c8e:	f1650513          	addi	a0,a0,-234 # 80015ba0 <bcache>
    80002c92:	80afe0ef          	jal	80000c9c <release>
      acquiresleep(&b->lock);
    80002c96:	01048513          	addi	a0,s1,16
    80002c9a:	2f4010ef          	jal	80003f8e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if (!b->valid) {
    80002c9e:	409c                	lw	a5,0(s1)
    80002ca0:	cb89                	beqz	a5,80002cb2 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002ca2:	8526                	mv	a0,s1
    80002ca4:	70a2                	ld	ra,40(sp)
    80002ca6:	7402                	ld	s0,32(sp)
    80002ca8:	64e2                	ld	s1,24(sp)
    80002caa:	6942                	ld	s2,16(sp)
    80002cac:	69a2                	ld	s3,8(sp)
    80002cae:	6145                	addi	sp,sp,48
    80002cb0:	8082                	ret
    virtio_disk_rw(b, 0);
    80002cb2:	4581                	li	a1,0
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	2bd020ef          	jal	80005772 <virtio_disk_rw>
    b->valid = 1;
    80002cba:	4785                	li	a5,1
    80002cbc:	c09c                	sw	a5,0(s1)
  return b;
    80002cbe:	b7d5                	j	80002ca2 <bread+0xb8>

0000000080002cc0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002cc0:	1101                	addi	sp,sp,-32
    80002cc2:	ec06                	sd	ra,24(sp)
    80002cc4:	e822                	sd	s0,16(sp)
    80002cc6:	e426                	sd	s1,8(sp)
    80002cc8:	1000                	addi	s0,sp,32
    80002cca:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002ccc:	0541                	addi	a0,a0,16
    80002cce:	33e010ef          	jal	8000400c <holdingsleep>
    80002cd2:	c911                	beqz	a0,80002ce6 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002cd4:	4585                	li	a1,1
    80002cd6:	8526                	mv	a0,s1
    80002cd8:	29b020ef          	jal	80005772 <virtio_disk_rw>
}
    80002cdc:	60e2                	ld	ra,24(sp)
    80002cde:	6442                	ld	s0,16(sp)
    80002ce0:	64a2                	ld	s1,8(sp)
    80002ce2:	6105                	addi	sp,sp,32
    80002ce4:	8082                	ret
    panic("bwrite");
    80002ce6:	00004517          	auipc	a0,0x4
    80002cea:	7ca50513          	addi	a0,a0,1994 # 800074b0 <etext+0x4b0>
    80002cee:	b4dfd0ef          	jal	8000083a <panic>

0000000080002cf2 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002cf2:	1101                	addi	sp,sp,-32
    80002cf4:	ec06                	sd	ra,24(sp)
    80002cf6:	e822                	sd	s0,16(sp)
    80002cf8:	e426                	sd	s1,8(sp)
    80002cfa:	e04a                	sd	s2,0(sp)
    80002cfc:	1000                	addi	s0,sp,32
    80002cfe:	84aa                	mv	s1,a0
  if (!holdingsleep(&b->lock))
    80002d00:	01050913          	addi	s2,a0,16
    80002d04:	854a                	mv	a0,s2
    80002d06:	306010ef          	jal	8000400c <holdingsleep>
    80002d0a:	c125                	beqz	a0,80002d6a <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002d0c:	854a                	mv	a0,s2
    80002d0e:	2c6010ef          	jal	80003fd4 <releasesleep>

  acquire(&bcache.lock);
    80002d12:	00013517          	auipc	a0,0x13
    80002d16:	e8e50513          	addi	a0,a0,-370 # 80015ba0 <bcache>
    80002d1a:	efffd0ef          	jal	80000c18 <acquire>
  b->refcnt--;
    80002d1e:	40bc                	lw	a5,64(s1)
    80002d20:	37fd                	addiw	a5,a5,-1
    80002d22:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002d24:	e79d                	bnez	a5,80002d52 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002d26:	68b8                	ld	a4,80(s1)
    80002d28:	64bc                	ld	a5,72(s1)
    80002d2a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002d2c:	68b8                	ld	a4,80(s1)
    80002d2e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002d30:	0001b797          	auipc	a5,0x1b
    80002d34:	e7078793          	addi	a5,a5,-400 # 8001dba0 <bcache+0x8000>
    80002d38:	2b87b703          	ld	a4,696(a5)
    80002d3c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002d3e:	0001b717          	auipc	a4,0x1b
    80002d42:	0ca70713          	addi	a4,a4,202 # 8001de08 <bcache+0x8268>
    80002d46:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002d48:	2b87b703          	ld	a4,696(a5)
    80002d4c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002d4e:	2a97bc23          	sd	s1,696(a5)
  }

  release(&bcache.lock);
    80002d52:	00013517          	auipc	a0,0x13
    80002d56:	e4e50513          	addi	a0,a0,-434 # 80015ba0 <bcache>
    80002d5a:	f43fd0ef          	jal	80000c9c <release>
}
    80002d5e:	60e2                	ld	ra,24(sp)
    80002d60:	6442                	ld	s0,16(sp)
    80002d62:	64a2                	ld	s1,8(sp)
    80002d64:	6902                	ld	s2,0(sp)
    80002d66:	6105                	addi	sp,sp,32
    80002d68:	8082                	ret
    panic("brelse");
    80002d6a:	00004517          	auipc	a0,0x4
    80002d6e:	74e50513          	addi	a0,a0,1870 # 800074b8 <etext+0x4b8>
    80002d72:	ac9fd0ef          	jal	8000083a <panic>

0000000080002d76 <bpin>:

void
bpin(struct buf *b)
{
    80002d76:	1101                	addi	sp,sp,-32
    80002d78:	ec06                	sd	ra,24(sp)
    80002d7a:	e822                	sd	s0,16(sp)
    80002d7c:	e426                	sd	s1,8(sp)
    80002d7e:	1000                	addi	s0,sp,32
    80002d80:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002d82:	00013517          	auipc	a0,0x13
    80002d86:	e1e50513          	addi	a0,a0,-482 # 80015ba0 <bcache>
    80002d8a:	e8ffd0ef          	jal	80000c18 <acquire>
  b->refcnt++;
    80002d8e:	40bc                	lw	a5,64(s1)
    80002d90:	2785                	addiw	a5,a5,1
    80002d92:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002d94:	00013517          	auipc	a0,0x13
    80002d98:	e0c50513          	addi	a0,a0,-500 # 80015ba0 <bcache>
    80002d9c:	f01fd0ef          	jal	80000c9c <release>
}
    80002da0:	60e2                	ld	ra,24(sp)
    80002da2:	6442                	ld	s0,16(sp)
    80002da4:	64a2                	ld	s1,8(sp)
    80002da6:	6105                	addi	sp,sp,32
    80002da8:	8082                	ret

0000000080002daa <bunpin>:

void
bunpin(struct buf *b)
{
    80002daa:	1101                	addi	sp,sp,-32
    80002dac:	ec06                	sd	ra,24(sp)
    80002dae:	e822                	sd	s0,16(sp)
    80002db0:	e426                	sd	s1,8(sp)
    80002db2:	1000                	addi	s0,sp,32
    80002db4:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002db6:	00013517          	auipc	a0,0x13
    80002dba:	dea50513          	addi	a0,a0,-534 # 80015ba0 <bcache>
    80002dbe:	e5bfd0ef          	jal	80000c18 <acquire>
  b->refcnt--;
    80002dc2:	40bc                	lw	a5,64(s1)
    80002dc4:	37fd                	addiw	a5,a5,-1
    80002dc6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002dc8:	00013517          	auipc	a0,0x13
    80002dcc:	dd850513          	addi	a0,a0,-552 # 80015ba0 <bcache>
    80002dd0:	ecdfd0ef          	jal	80000c9c <release>
}
    80002dd4:	60e2                	ld	ra,24(sp)
    80002dd6:	6442                	ld	s0,16(sp)
    80002dd8:	64a2                	ld	s1,8(sp)
    80002dda:	6105                	addi	sp,sp,32
    80002ddc:	8082                	ret

0000000080002dde <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002dde:	1101                	addi	sp,sp,-32
    80002de0:	ec06                	sd	ra,24(sp)
    80002de2:	e822                	sd	s0,16(sp)
    80002de4:	e426                	sd	s1,8(sp)
    80002de6:	e04a                	sd	s2,0(sp)
    80002de8:	1000                	addi	s0,sp,32
    80002dea:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002dec:	00d5d79b          	srliw	a5,a1,0xd
    80002df0:	0001b597          	auipc	a1,0x1b
    80002df4:	48c5a583          	lw	a1,1164(a1) # 8001e27c <sb+0x1c>
    80002df8:	9dbd                	addw	a1,a1,a5
    80002dfa:	df1ff0ef          	jal	80002bea <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002dfe:	0074f713          	andi	a4,s1,7
    80002e02:	4785                	li	a5,1
    80002e04:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002e08:	14ce                	slli	s1,s1,0x33
  if ((bp->data[bi / 8] & m) == 0)
    80002e0a:	90d9                	srli	s1,s1,0x36
    80002e0c:	00950733          	add	a4,a0,s1
    80002e10:	05874703          	lbu	a4,88(a4)
    80002e14:	00e7f6b3          	and	a3,a5,a4
    80002e18:	c29d                	beqz	a3,80002e3e <bfree+0x60>
    80002e1a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi / 8] &= ~m;
    80002e1c:	94aa                	add	s1,s1,a0
    80002e1e:	fff7c793          	not	a5,a5
    80002e22:	8f7d                	and	a4,a4,a5
    80002e24:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002e28:	00a010ef          	jal	80003e32 <log_write>
  brelse(bp);
    80002e2c:	854a                	mv	a0,s2
    80002e2e:	ec5ff0ef          	jal	80002cf2 <brelse>
}
    80002e32:	60e2                	ld	ra,24(sp)
    80002e34:	6442                	ld	s0,16(sp)
    80002e36:	64a2                	ld	s1,8(sp)
    80002e38:	6902                	ld	s2,0(sp)
    80002e3a:	6105                	addi	sp,sp,32
    80002e3c:	8082                	ret
    panic("freeing free block");
    80002e3e:	00004517          	auipc	a0,0x4
    80002e42:	68250513          	addi	a0,a0,1666 # 800074c0 <etext+0x4c0>
    80002e46:	9f5fd0ef          	jal	8000083a <panic>

0000000080002e4a <balloc>:
{
    80002e4a:	715d                	addi	sp,sp,-80
    80002e4c:	e486                	sd	ra,72(sp)
    80002e4e:	e0a2                	sd	s0,64(sp)
    80002e50:	fc26                	sd	s1,56(sp)
    80002e52:	0880                	addi	s0,sp,80
  for (b = 0; b < sb.size; b += BPB) {
    80002e54:	0001b797          	auipc	a5,0x1b
    80002e58:	4107a783          	lw	a5,1040(a5) # 8001e264 <sb+0x4>
    80002e5c:	0e078263          	beqz	a5,80002f40 <balloc+0xf6>
    80002e60:	f84a                	sd	s2,48(sp)
    80002e62:	f44e                	sd	s3,40(sp)
    80002e64:	f052                	sd	s4,32(sp)
    80002e66:	ec56                	sd	s5,24(sp)
    80002e68:	e85a                	sd	s6,16(sp)
    80002e6a:	e45e                	sd	s7,8(sp)
    80002e6c:	e062                	sd	s8,0(sp)
    80002e6e:	8baa                	mv	s7,a0
    80002e70:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002e72:	0001bb17          	auipc	s6,0x1b
    80002e76:	3eeb0b13          	addi	s6,s6,1006 # 8001e260 <sb>
      m = 1 << (bi % 8);
    80002e7a:	4985                	li	s3,1
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002e7c:	6a09                	lui	s4,0x2
  for (b = 0; b < sb.size; b += BPB) {
    80002e7e:	6c09                	lui	s8,0x2
    80002e80:	a09d                	j	80002ee6 <balloc+0x9c>
        bp->data[bi / 8] |= m;           // Mark block in use.
    80002e82:	97ca                	add	a5,a5,s2
    80002e84:	8e55                	or	a2,a2,a3
    80002e86:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002e8a:	854a                	mv	a0,s2
    80002e8c:	7a7000ef          	jal	80003e32 <log_write>
        brelse(bp);
    80002e90:	854a                	mv	a0,s2
    80002e92:	e61ff0ef          	jal	80002cf2 <brelse>
  bp = bread(dev, bno);
    80002e96:	85a6                	mv	a1,s1
    80002e98:	855e                	mv	a0,s7
    80002e9a:	d51ff0ef          	jal	80002bea <bread>
    80002e9e:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002ea0:	40000613          	li	a2,1024
    80002ea4:	4581                	li	a1,0
    80002ea6:	05850513          	addi	a0,a0,88
    80002eaa:	e2bfd0ef          	jal	80000cd4 <memset>
  log_write(bp);
    80002eae:	854a                	mv	a0,s2
    80002eb0:	783000ef          	jal	80003e32 <log_write>
  brelse(bp);
    80002eb4:	854a                	mv	a0,s2
    80002eb6:	e3dff0ef          	jal	80002cf2 <brelse>
        return b + bi;
    80002eba:	7942                	ld	s2,48(sp)
    80002ebc:	79a2                	ld	s3,40(sp)
    80002ebe:	7a02                	ld	s4,32(sp)
    80002ec0:	6ae2                	ld	s5,24(sp)
    80002ec2:	6b42                	ld	s6,16(sp)
    80002ec4:	6ba2                	ld	s7,8(sp)
    80002ec6:	6c02                	ld	s8,0(sp)
}
    80002ec8:	8526                	mv	a0,s1
    80002eca:	60a6                	ld	ra,72(sp)
    80002ecc:	6406                	ld	s0,64(sp)
    80002ece:	74e2                	ld	s1,56(sp)
    80002ed0:	6161                	addi	sp,sp,80
    80002ed2:	8082                	ret
    brelse(bp);
    80002ed4:	854a                	mv	a0,s2
    80002ed6:	e1dff0ef          	jal	80002cf2 <brelse>
  for (b = 0; b < sb.size; b += BPB) {
    80002eda:	015c0abb          	addw	s5,s8,s5
    80002ede:	004b2783          	lw	a5,4(s6)
    80002ee2:	04faf863          	bgeu	s5,a5,80002f32 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002ee6:	40dad59b          	sraiw	a1,s5,0xd
    80002eea:	01cb2783          	lw	a5,28(s6)
    80002eee:	9dbd                	addw	a1,a1,a5
    80002ef0:	855e                	mv	a0,s7
    80002ef2:	cf9ff0ef          	jal	80002bea <bread>
    80002ef6:	892a                	mv	s2,a0
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002ef8:	004b2503          	lw	a0,4(s6)
    80002efc:	84d6                	mv	s1,s5
    80002efe:	4701                	li	a4,0
    80002f00:	fca4fae3          	bgeu	s1,a0,80002ed4 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002f04:	00777693          	andi	a3,a4,7
    80002f08:	00d996bb          	sllw	a3,s3,a3
      if ((bp->data[bi / 8] & m) == 0) { // Is block free?
    80002f0c:	41f7579b          	sraiw	a5,a4,0x1f
    80002f10:	01d7d79b          	srliw	a5,a5,0x1d
    80002f14:	9fb9                	addw	a5,a5,a4
    80002f16:	4037d79b          	sraiw	a5,a5,0x3
    80002f1a:	00f90633          	add	a2,s2,a5
    80002f1e:	05864603          	lbu	a2,88(a2)
    80002f22:	00c6f5b3          	and	a1,a3,a2
    80002f26:	ddb1                	beqz	a1,80002e82 <balloc+0x38>
    for (bi = 0; bi < BPB && b + bi < sb.size; bi++) {
    80002f28:	2705                	addiw	a4,a4,1
    80002f2a:	2485                	addiw	s1,s1,1
    80002f2c:	fd471ae3          	bne	a4,s4,80002f00 <balloc+0xb6>
    80002f30:	b755                	j	80002ed4 <balloc+0x8a>
    80002f32:	7942                	ld	s2,48(sp)
    80002f34:	79a2                	ld	s3,40(sp)
    80002f36:	7a02                	ld	s4,32(sp)
    80002f38:	6ae2                	ld	s5,24(sp)
    80002f3a:	6b42                	ld	s6,16(sp)
    80002f3c:	6ba2                	ld	s7,8(sp)
    80002f3e:	6c02                	ld	s8,0(sp)
  printk("balloc: out of blocks\n");
    80002f40:	00004517          	auipc	a0,0x4
    80002f44:	59850513          	addi	a0,a0,1432 # 800074d8 <etext+0x4d8>
    80002f48:	dbafd0ef          	jal	80000502 <printk>
  return 0;
    80002f4c:	4481                	li	s1,0
    80002f4e:	bfad                	j	80002ec8 <balloc+0x7e>

0000000080002f50 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002f50:	7179                	addi	sp,sp,-48
    80002f52:	f406                	sd	ra,40(sp)
    80002f54:	f022                	sd	s0,32(sp)
    80002f56:	ec26                	sd	s1,24(sp)
    80002f58:	e84a                	sd	s2,16(sp)
    80002f5a:	e44e                	sd	s3,8(sp)
    80002f5c:	1800                	addi	s0,sp,48
    80002f5e:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if (bn < NDIRECT) {
    80002f60:	47ad                	li	a5,11
    80002f62:	02b7e363          	bltu	a5,a1,80002f88 <bmap+0x38>
    if ((addr = ip->addrs[bn]) == 0) {
    80002f66:	02059793          	slli	a5,a1,0x20
    80002f6a:	01e7d593          	srli	a1,a5,0x1e
    80002f6e:	00b509b3          	add	s3,a0,a1
    80002f72:	0509a483          	lw	s1,80(s3)
    80002f76:	e0b5                	bnez	s1,80002fda <bmap+0x8a>
      addr = balloc(ip->dev);
    80002f78:	4108                	lw	a0,0(a0)
    80002f7a:	ed1ff0ef          	jal	80002e4a <balloc>
    80002f7e:	84aa                	mv	s1,a0
      if (addr == 0)
    80002f80:	cd29                	beqz	a0,80002fda <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002f82:	04a9a823          	sw	a0,80(s3)
    80002f86:	a891                	j	80002fda <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002f88:	ff45879b          	addiw	a5,a1,-12
    80002f8c:	873e                	mv	a4,a5
    80002f8e:	89be                	mv	s3,a5

  if (bn < NINDIRECT) {
    80002f90:	0ff00793          	li	a5,255
    80002f94:	06e7e763          	bltu	a5,a4,80003002 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if ((addr = ip->addrs[NDIRECT]) == 0) {
    80002f98:	08052483          	lw	s1,128(a0)
    80002f9c:	e891                	bnez	s1,80002fb0 <bmap+0x60>
      addr = balloc(ip->dev);
    80002f9e:	4108                	lw	a0,0(a0)
    80002fa0:	eabff0ef          	jal	80002e4a <balloc>
    80002fa4:	84aa                	mv	s1,a0
      if (addr == 0)
    80002fa6:	c915                	beqz	a0,80002fda <bmap+0x8a>
    80002fa8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002faa:	08a92023          	sw	a0,128(s2)
    80002fae:	a011                	j	80002fb2 <bmap+0x62>
    80002fb0:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002fb2:	85a6                	mv	a1,s1
    80002fb4:	00092503          	lw	a0,0(s2)
    80002fb8:	c33ff0ef          	jal	80002bea <bread>
    80002fbc:	8a2a                	mv	s4,a0
    a = (uint *)bp->data;
    80002fbe:	05850793          	addi	a5,a0,88
    if ((addr = a[bn]) == 0) {
    80002fc2:	02099713          	slli	a4,s3,0x20
    80002fc6:	01e75593          	srli	a1,a4,0x1e
    80002fca:	97ae                	add	a5,a5,a1
    80002fcc:	89be                	mv	s3,a5
    80002fce:	4384                	lw	s1,0(a5)
    80002fd0:	cc89                	beqz	s1,80002fea <bmap+0x9a>
      if (addr) {
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002fd2:	8552                	mv	a0,s4
    80002fd4:	d1fff0ef          	jal	80002cf2 <brelse>
    return addr;
    80002fd8:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002fda:	8526                	mv	a0,s1
    80002fdc:	70a2                	ld	ra,40(sp)
    80002fde:	7402                	ld	s0,32(sp)
    80002fe0:	64e2                	ld	s1,24(sp)
    80002fe2:	6942                	ld	s2,16(sp)
    80002fe4:	69a2                	ld	s3,8(sp)
    80002fe6:	6145                	addi	sp,sp,48
    80002fe8:	8082                	ret
      addr = balloc(ip->dev);
    80002fea:	00092503          	lw	a0,0(s2)
    80002fee:	e5dff0ef          	jal	80002e4a <balloc>
    80002ff2:	84aa                	mv	s1,a0
      if (addr) {
    80002ff4:	dd79                	beqz	a0,80002fd2 <bmap+0x82>
        a[bn] = addr;
    80002ff6:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002ffa:	8552                	mv	a0,s4
    80002ffc:	637000ef          	jal	80003e32 <log_write>
    80003000:	bfc9                	j	80002fd2 <bmap+0x82>
    80003002:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80003004:	00004517          	auipc	a0,0x4
    80003008:	4ec50513          	addi	a0,a0,1260 # 800074f0 <etext+0x4f0>
    8000300c:	82ffd0ef          	jal	8000083a <panic>

0000000080003010 <iget>:
{
    80003010:	7179                	addi	sp,sp,-48
    80003012:	f406                	sd	ra,40(sp)
    80003014:	f022                	sd	s0,32(sp)
    80003016:	ec26                	sd	s1,24(sp)
    80003018:	e84a                	sd	s2,16(sp)
    8000301a:	e44e                	sd	s3,8(sp)
    8000301c:	e052                	sd	s4,0(sp)
    8000301e:	1800                	addi	s0,sp,48
    80003020:	89aa                	mv	s3,a0
    80003022:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80003024:	0001b517          	auipc	a0,0x1b
    80003028:	25c50513          	addi	a0,a0,604 # 8001e280 <itable>
    8000302c:	bedfd0ef          	jal	80000c18 <acquire>
  empty = 0;
    80003030:	4901                	li	s2,0
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003032:	0001b497          	auipc	s1,0x1b
    80003036:	26648493          	addi	s1,s1,614 # 8001e298 <itable+0x18>
    8000303a:	0001d697          	auipc	a3,0x1d
    8000303e:	cee68693          	addi	a3,a3,-786 # 8001fd28 <log>
    80003042:	a819                	j	80003058 <iget+0x48>
    if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80003044:	0017b793          	seqz	a5,a5
    80003048:	00193713          	seqz	a4,s2
    8000304c:	8ff9                	and	a5,a5,a4
    8000304e:	eb85                	bnez	a5,8000307e <iget+0x6e>
  for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++) {
    80003050:	08848493          	addi	s1,s1,136
    80003054:	02d48763          	beq	s1,a3,80003082 <iget+0x72>
    if (ip->ref > 0 && ip->dev == dev && ip->inum == inum) {
    80003058:	449c                	lw	a5,8(s1)
    8000305a:	fef055e3          	blez	a5,80003044 <iget+0x34>
    8000305e:	4098                	lw	a4,0(s1)
    80003060:	ff3718e3          	bne	a4,s3,80003050 <iget+0x40>
    80003064:	40d8                	lw	a4,4(s1)
    80003066:	ff4715e3          	bne	a4,s4,80003050 <iget+0x40>
      ip->ref++;
    8000306a:	2785                	addiw	a5,a5,1
    8000306c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000306e:	0001b517          	auipc	a0,0x1b
    80003072:	21250513          	addi	a0,a0,530 # 8001e280 <itable>
    80003076:	c27fd0ef          	jal	80000c9c <release>
      return ip;
    8000307a:	8926                	mv	s2,s1
    8000307c:	a025                	j	800030a4 <iget+0x94>
      empty = ip;
    8000307e:	8926                	mv	s2,s1
    80003080:	bfc1                	j	80003050 <iget+0x40>
  if (empty == 0)
    80003082:	02090a63          	beqz	s2,800030b6 <iget+0xa6>
  ip->dev = dev;
    80003086:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    8000308a:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    8000308e:	4785                	li	a5,1
    80003090:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    80003094:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    80003098:	0001b517          	auipc	a0,0x1b
    8000309c:	1e850513          	addi	a0,a0,488 # 8001e280 <itable>
    800030a0:	bfdfd0ef          	jal	80000c9c <release>
}
    800030a4:	854a                	mv	a0,s2
    800030a6:	70a2                	ld	ra,40(sp)
    800030a8:	7402                	ld	s0,32(sp)
    800030aa:	64e2                	ld	s1,24(sp)
    800030ac:	6942                	ld	s2,16(sp)
    800030ae:	69a2                	ld	s3,8(sp)
    800030b0:	6a02                	ld	s4,0(sp)
    800030b2:	6145                	addi	sp,sp,48
    800030b4:	8082                	ret
    panic("iget: no inodes");
    800030b6:	00004517          	auipc	a0,0x4
    800030ba:	45250513          	addi	a0,a0,1106 # 80007508 <etext+0x508>
    800030be:	f7cfd0ef          	jal	8000083a <panic>

00000000800030c2 <iinit>:
{
    800030c2:	7179                	addi	sp,sp,-48
    800030c4:	f406                	sd	ra,40(sp)
    800030c6:	f022                	sd	s0,32(sp)
    800030c8:	ec26                	sd	s1,24(sp)
    800030ca:	e84a                	sd	s2,16(sp)
    800030cc:	e44e                	sd	s3,8(sp)
    800030ce:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800030d0:	00004597          	auipc	a1,0x4
    800030d4:	44858593          	addi	a1,a1,1096 # 80007518 <etext+0x518>
    800030d8:	0001b517          	auipc	a0,0x1b
    800030dc:	1a850513          	addi	a0,a0,424 # 8001e280 <itable>
    800030e0:	ab9fd0ef          	jal	80000b98 <initlock>
  for (i = 0; i < NINODE; i++) {
    800030e4:	0001b497          	auipc	s1,0x1b
    800030e8:	1c448493          	addi	s1,s1,452 # 8001e2a8 <itable+0x28>
    800030ec:	0001d997          	auipc	s3,0x1d
    800030f0:	c4c98993          	addi	s3,s3,-948 # 8001fd38 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800030f4:	00004917          	auipc	s2,0x4
    800030f8:	42c90913          	addi	s2,s2,1068 # 80007520 <etext+0x520>
    800030fc:	85ca                	mv	a1,s2
    800030fe:	8526                	mv	a0,s1
    80003100:	659000ef          	jal	80003f58 <initsleeplock>
  for (i = 0; i < NINODE; i++) {
    80003104:	08848493          	addi	s1,s1,136
    80003108:	ff349ae3          	bne	s1,s3,800030fc <iinit+0x3a>
}
    8000310c:	70a2                	ld	ra,40(sp)
    8000310e:	7402                	ld	s0,32(sp)
    80003110:	64e2                	ld	s1,24(sp)
    80003112:	6942                	ld	s2,16(sp)
    80003114:	69a2                	ld	s3,8(sp)
    80003116:	6145                	addi	sp,sp,48
    80003118:	8082                	ret

000000008000311a <ialloc>:
{
    8000311a:	7139                	addi	sp,sp,-64
    8000311c:	fc06                	sd	ra,56(sp)
    8000311e:	f822                	sd	s0,48(sp)
    80003120:	0080                	addi	s0,sp,64
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003122:	0001b717          	auipc	a4,0x1b
    80003126:	14a72703          	lw	a4,330(a4) # 8001e26c <sb+0xc>
    8000312a:	4785                	li	a5,1
    8000312c:	06e7f063          	bgeu	a5,a4,8000318c <ialloc+0x72>
    80003130:	f426                	sd	s1,40(sp)
    80003132:	f04a                	sd	s2,32(sp)
    80003134:	ec4e                	sd	s3,24(sp)
    80003136:	e852                	sd	s4,16(sp)
    80003138:	e456                	sd	s5,8(sp)
    8000313a:	e05a                	sd	s6,0(sp)
    8000313c:	8aaa                	mv	s5,a0
    8000313e:	8b2e                	mv	s6,a1
    80003140:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80003142:	0001ba17          	auipc	s4,0x1b
    80003146:	11ea0a13          	addi	s4,s4,286 # 8001e260 <sb>
    8000314a:	00495593          	srli	a1,s2,0x4
    8000314e:	018a2783          	lw	a5,24(s4)
    80003152:	9dbd                	addw	a1,a1,a5
    80003154:	8556                	mv	a0,s5
    80003156:	a95ff0ef          	jal	80002bea <bread>
    8000315a:	84aa                	mv	s1,a0
    dip = (struct dinode *)bp->data + inum % IPB;
    8000315c:	05850993          	addi	s3,a0,88
    80003160:	00f97793          	andi	a5,s2,15
    80003164:	079a                	slli	a5,a5,0x6
    80003166:	99be                	add	s3,s3,a5
    if (dip->type == 0) { // a free inode
    80003168:	00099783          	lh	a5,0(s3)
    8000316c:	cb9d                	beqz	a5,800031a2 <ialloc+0x88>
    brelse(bp);
    8000316e:	b85ff0ef          	jal	80002cf2 <brelse>
  for (inum = 1; inum < sb.ninodes; inum++) {
    80003172:	0905                	addi	s2,s2,1
    80003174:	00ca2703          	lw	a4,12(s4)
    80003178:	0009079b          	sext.w	a5,s2
    8000317c:	fce7e7e3          	bltu	a5,a4,8000314a <ialloc+0x30>
    80003180:	74a2                	ld	s1,40(sp)
    80003182:	7902                	ld	s2,32(sp)
    80003184:	69e2                	ld	s3,24(sp)
    80003186:	6a42                	ld	s4,16(sp)
    80003188:	6aa2                	ld	s5,8(sp)
    8000318a:	6b02                	ld	s6,0(sp)
  printk("ialloc: no inodes\n");
    8000318c:	00004517          	auipc	a0,0x4
    80003190:	39c50513          	addi	a0,a0,924 # 80007528 <etext+0x528>
    80003194:	b6efd0ef          	jal	80000502 <printk>
  return 0;
    80003198:	4501                	li	a0,0
}
    8000319a:	70e2                	ld	ra,56(sp)
    8000319c:	7442                	ld	s0,48(sp)
    8000319e:	6121                	addi	sp,sp,64
    800031a0:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800031a2:	04000613          	li	a2,64
    800031a6:	4581                	li	a1,0
    800031a8:	854e                	mv	a0,s3
    800031aa:	b2bfd0ef          	jal	80000cd4 <memset>
      dip->type = type;
    800031ae:	01699023          	sh	s6,0(s3)
      log_write(bp); // mark it allocated on the disk
    800031b2:	8526                	mv	a0,s1
    800031b4:	47f000ef          	jal	80003e32 <log_write>
      brelse(bp);
    800031b8:	8526                	mv	a0,s1
    800031ba:	b39ff0ef          	jal	80002cf2 <brelse>
      return iget(dev, inum);
    800031be:	0009059b          	sext.w	a1,s2
    800031c2:	8556                	mv	a0,s5
    800031c4:	e4dff0ef          	jal	80003010 <iget>
    800031c8:	74a2                	ld	s1,40(sp)
    800031ca:	7902                	ld	s2,32(sp)
    800031cc:	69e2                	ld	s3,24(sp)
    800031ce:	6a42                	ld	s4,16(sp)
    800031d0:	6aa2                	ld	s5,8(sp)
    800031d2:	6b02                	ld	s6,0(sp)
    800031d4:	b7d9                	j	8000319a <ialloc+0x80>

00000000800031d6 <iupdate>:
{
    800031d6:	1101                	addi	sp,sp,-32
    800031d8:	ec06                	sd	ra,24(sp)
    800031da:	e822                	sd	s0,16(sp)
    800031dc:	e426                	sd	s1,8(sp)
    800031de:	e04a                	sd	s2,0(sp)
    800031e0:	1000                	addi	s0,sp,32
    800031e2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800031e4:	415c                	lw	a5,4(a0)
    800031e6:	0047d79b          	srliw	a5,a5,0x4
    800031ea:	0001b597          	auipc	a1,0x1b
    800031ee:	08e5a583          	lw	a1,142(a1) # 8001e278 <sb+0x18>
    800031f2:	9dbd                	addw	a1,a1,a5
    800031f4:	4108                	lw	a0,0(a0)
    800031f6:	9f5ff0ef          	jal	80002bea <bread>
    800031fa:	892a                	mv	s2,a0
  dip = (struct dinode *)bp->data + ip->inum % IPB;
    800031fc:	05850793          	addi	a5,a0,88
    80003200:	40d8                	lw	a4,4(s1)
    80003202:	8b3d                	andi	a4,a4,15
    80003204:	071a                	slli	a4,a4,0x6
    80003206:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80003208:	04449703          	lh	a4,68(s1)
    8000320c:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80003210:	04649703          	lh	a4,70(s1)
    80003214:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80003218:	04849703          	lh	a4,72(s1)
    8000321c:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80003220:	04a49703          	lh	a4,74(s1)
    80003224:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80003228:	44f8                	lw	a4,76(s1)
    8000322a:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000322c:	03400613          	li	a2,52
    80003230:	05048593          	addi	a1,s1,80
    80003234:	00c78513          	addi	a0,a5,12
    80003238:	af9fd0ef          	jal	80000d30 <memmove>
  log_write(bp);
    8000323c:	854a                	mv	a0,s2
    8000323e:	3f5000ef          	jal	80003e32 <log_write>
  brelse(bp);
    80003242:	854a                	mv	a0,s2
    80003244:	aafff0ef          	jal	80002cf2 <brelse>
}
    80003248:	60e2                	ld	ra,24(sp)
    8000324a:	6442                	ld	s0,16(sp)
    8000324c:	64a2                	ld	s1,8(sp)
    8000324e:	6902                	ld	s2,0(sp)
    80003250:	6105                	addi	sp,sp,32
    80003252:	8082                	ret

0000000080003254 <idup>:
{
    80003254:	1101                	addi	sp,sp,-32
    80003256:	ec06                	sd	ra,24(sp)
    80003258:	e822                	sd	s0,16(sp)
    8000325a:	e426                	sd	s1,8(sp)
    8000325c:	1000                	addi	s0,sp,32
    8000325e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003260:	0001b517          	auipc	a0,0x1b
    80003264:	02050513          	addi	a0,a0,32 # 8001e280 <itable>
    80003268:	9b1fd0ef          	jal	80000c18 <acquire>
  ip->ref++;
    8000326c:	449c                	lw	a5,8(s1)
    8000326e:	2785                	addiw	a5,a5,1
    80003270:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003272:	0001b517          	auipc	a0,0x1b
    80003276:	00e50513          	addi	a0,a0,14 # 8001e280 <itable>
    8000327a:	a23fd0ef          	jal	80000c9c <release>
}
    8000327e:	8526                	mv	a0,s1
    80003280:	60e2                	ld	ra,24(sp)
    80003282:	6442                	ld	s0,16(sp)
    80003284:	64a2                	ld	s1,8(sp)
    80003286:	6105                	addi	sp,sp,32
    80003288:	8082                	ret

000000008000328a <ilock>:
{
    8000328a:	1101                	addi	sp,sp,-32
    8000328c:	ec06                	sd	ra,24(sp)
    8000328e:	e822                	sd	s0,16(sp)
    80003290:	e426                	sd	s1,8(sp)
    80003292:	1000                	addi	s0,sp,32
  if (ip == 0 || ip->ref < 1)
    80003294:	cd19                	beqz	a0,800032b2 <ilock+0x28>
    80003296:	84aa                	mv	s1,a0
    80003298:	451c                	lw	a5,8(a0)
    8000329a:	00f05c63          	blez	a5,800032b2 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000329e:	0541                	addi	a0,a0,16
    800032a0:	4ef000ef          	jal	80003f8e <acquiresleep>
  if (ip->valid == 0) {
    800032a4:	40bc                	lw	a5,64(s1)
    800032a6:	cf89                	beqz	a5,800032c0 <ilock+0x36>
}
    800032a8:	60e2                	ld	ra,24(sp)
    800032aa:	6442                	ld	s0,16(sp)
    800032ac:	64a2                	ld	s1,8(sp)
    800032ae:	6105                	addi	sp,sp,32
    800032b0:	8082                	ret
    800032b2:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800032b4:	00004517          	auipc	a0,0x4
    800032b8:	28c50513          	addi	a0,a0,652 # 80007540 <etext+0x540>
    800032bc:	d7efd0ef          	jal	8000083a <panic>
    800032c0:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800032c2:	40dc                	lw	a5,4(s1)
    800032c4:	0047d79b          	srliw	a5,a5,0x4
    800032c8:	0001b597          	auipc	a1,0x1b
    800032cc:	fb05a583          	lw	a1,-80(a1) # 8001e278 <sb+0x18>
    800032d0:	9dbd                	addw	a1,a1,a5
    800032d2:	4088                	lw	a0,0(s1)
    800032d4:	917ff0ef          	jal	80002bea <bread>
    800032d8:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    800032da:	05850593          	addi	a1,a0,88
    800032de:	40dc                	lw	a5,4(s1)
    800032e0:	8bbd                	andi	a5,a5,15
    800032e2:	079a                	slli	a5,a5,0x6
    800032e4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800032e6:	00059783          	lh	a5,0(a1)
    800032ea:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800032ee:	00259783          	lh	a5,2(a1)
    800032f2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800032f6:	00459783          	lh	a5,4(a1)
    800032fa:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800032fe:	00659783          	lh	a5,6(a1)
    80003302:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80003306:	459c                	lw	a5,8(a1)
    80003308:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000330a:	03400613          	li	a2,52
    8000330e:	05b1                	addi	a1,a1,12
    80003310:	05048513          	addi	a0,s1,80
    80003314:	a1dfd0ef          	jal	80000d30 <memmove>
    brelse(bp);
    80003318:	854a                	mv	a0,s2
    8000331a:	9d9ff0ef          	jal	80002cf2 <brelse>
    ip->valid = 1;
    8000331e:	4785                	li	a5,1
    80003320:	c0bc                	sw	a5,64(s1)
    if (ip->type == 0)
    80003322:	04449783          	lh	a5,68(s1)
    80003326:	c399                	beqz	a5,8000332c <ilock+0xa2>
    80003328:	6902                	ld	s2,0(sp)
    8000332a:	bfbd                	j	800032a8 <ilock+0x1e>
      panic("ilock: no type");
    8000332c:	00004517          	auipc	a0,0x4
    80003330:	21c50513          	addi	a0,a0,540 # 80007548 <etext+0x548>
    80003334:	d06fd0ef          	jal	8000083a <panic>

0000000080003338 <iunlock>:
{
    80003338:	1101                	addi	sp,sp,-32
    8000333a:	ec06                	sd	ra,24(sp)
    8000333c:	e822                	sd	s0,16(sp)
    8000333e:	e426                	sd	s1,8(sp)
    80003340:	e04a                	sd	s2,0(sp)
    80003342:	1000                	addi	s0,sp,32
  if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80003344:	c505                	beqz	a0,8000336c <iunlock+0x34>
    80003346:	84aa                	mv	s1,a0
    80003348:	01050913          	addi	s2,a0,16
    8000334c:	854a                	mv	a0,s2
    8000334e:	4bf000ef          	jal	8000400c <holdingsleep>
    80003352:	cd09                	beqz	a0,8000336c <iunlock+0x34>
    80003354:	449c                	lw	a5,8(s1)
    80003356:	00f05b63          	blez	a5,8000336c <iunlock+0x34>
  releasesleep(&ip->lock);
    8000335a:	854a                	mv	a0,s2
    8000335c:	479000ef          	jal	80003fd4 <releasesleep>
}
    80003360:	60e2                	ld	ra,24(sp)
    80003362:	6442                	ld	s0,16(sp)
    80003364:	64a2                	ld	s1,8(sp)
    80003366:	6902                	ld	s2,0(sp)
    80003368:	6105                	addi	sp,sp,32
    8000336a:	8082                	ret
    panic("iunlock");
    8000336c:	00004517          	auipc	a0,0x4
    80003370:	1ec50513          	addi	a0,a0,492 # 80007558 <etext+0x558>
    80003374:	cc6fd0ef          	jal	8000083a <panic>

0000000080003378 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80003378:	7179                	addi	sp,sp,-48
    8000337a:	f406                	sd	ra,40(sp)
    8000337c:	f022                	sd	s0,32(sp)
    8000337e:	ec26                	sd	s1,24(sp)
    80003380:	e84a                	sd	s2,16(sp)
    80003382:	e44e                	sd	s3,8(sp)
    80003384:	1800                	addi	s0,sp,48
    80003386:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for (i = 0; i < NDIRECT; i++) {
    80003388:	05050493          	addi	s1,a0,80
    8000338c:	08050913          	addi	s2,a0,128
    80003390:	a021                	j	80003398 <itrunc+0x20>
    80003392:	0491                	addi	s1,s1,4
    80003394:	01248b63          	beq	s1,s2,800033aa <itrunc+0x32>
    if (ip->addrs[i]) {
    80003398:	408c                	lw	a1,0(s1)
    8000339a:	dde5                	beqz	a1,80003392 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000339c:	0009a503          	lw	a0,0(s3)
    800033a0:	a3fff0ef          	jal	80002dde <bfree>
      ip->addrs[i] = 0;
    800033a4:	0004a023          	sw	zero,0(s1)
    800033a8:	b7ed                	j	80003392 <itrunc+0x1a>
    }
  }

  if (ip->addrs[NDIRECT]) {
    800033aa:	0809a583          	lw	a1,128(s3)
    800033ae:	ed89                	bnez	a1,800033c8 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800033b0:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800033b4:	854e                	mv	a0,s3
    800033b6:	e21ff0ef          	jal	800031d6 <iupdate>
}
    800033ba:	70a2                	ld	ra,40(sp)
    800033bc:	7402                	ld	s0,32(sp)
    800033be:	64e2                	ld	s1,24(sp)
    800033c0:	6942                	ld	s2,16(sp)
    800033c2:	69a2                	ld	s3,8(sp)
    800033c4:	6145                	addi	sp,sp,48
    800033c6:	8082                	ret
    800033c8:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800033ca:	0009a503          	lw	a0,0(s3)
    800033ce:	81dff0ef          	jal	80002bea <bread>
    800033d2:	8a2a                	mv	s4,a0
    for (j = 0; j < NINDIRECT; j++) {
    800033d4:	05850493          	addi	s1,a0,88
    800033d8:	45850913          	addi	s2,a0,1112
    800033dc:	a021                	j	800033e4 <itrunc+0x6c>
    800033de:	0491                	addi	s1,s1,4
    800033e0:	01248963          	beq	s1,s2,800033f2 <itrunc+0x7a>
      if (a[j])
    800033e4:	408c                	lw	a1,0(s1)
    800033e6:	dde5                	beqz	a1,800033de <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800033e8:	0009a503          	lw	a0,0(s3)
    800033ec:	9f3ff0ef          	jal	80002dde <bfree>
    800033f0:	b7fd                	j	800033de <itrunc+0x66>
    brelse(bp);
    800033f2:	8552                	mv	a0,s4
    800033f4:	8ffff0ef          	jal	80002cf2 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800033f8:	0809a583          	lw	a1,128(s3)
    800033fc:	0009a503          	lw	a0,0(s3)
    80003400:	9dfff0ef          	jal	80002dde <bfree>
    ip->addrs[NDIRECT] = 0;
    80003404:	0809a023          	sw	zero,128(s3)
    80003408:	6a02                	ld	s4,0(sp)
    8000340a:	b75d                	j	800033b0 <itrunc+0x38>

000000008000340c <iput>:
{
    8000340c:	1101                	addi	sp,sp,-32
    8000340e:	ec06                	sd	ra,24(sp)
    80003410:	e822                	sd	s0,16(sp)
    80003412:	e426                	sd	s1,8(sp)
    80003414:	1000                	addi	s0,sp,32
    80003416:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80003418:	0001b517          	auipc	a0,0x1b
    8000341c:	e6850513          	addi	a0,a0,-408 # 8001e280 <itable>
    80003420:	ff8fd0ef          	jal	80000c18 <acquire>
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003424:	4498                	lw	a4,8(s1)
    80003426:	4785                	li	a5,1
    80003428:	02f70063          	beq	a4,a5,80003448 <iput+0x3c>
  ip->ref--;
    8000342c:	449c                	lw	a5,8(s1)
    8000342e:	37fd                	addiw	a5,a5,-1
    80003430:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80003432:	0001b517          	auipc	a0,0x1b
    80003436:	e4e50513          	addi	a0,a0,-434 # 8001e280 <itable>
    8000343a:	863fd0ef          	jal	80000c9c <release>
}
    8000343e:	60e2                	ld	ra,24(sp)
    80003440:	6442                	ld	s0,16(sp)
    80003442:	64a2                	ld	s1,8(sp)
    80003444:	6105                	addi	sp,sp,32
    80003446:	8082                	ret
  if (ip->ref == 1 && ip->valid && ip->nlink == 0) {
    80003448:	40bc                	lw	a5,64(s1)
    8000344a:	d3ed                	beqz	a5,8000342c <iput+0x20>
    8000344c:	04a49783          	lh	a5,74(s1)
    80003450:	fff1                	bnez	a5,8000342c <iput+0x20>
    80003452:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80003454:	01048793          	addi	a5,s1,16
    80003458:	893e                	mv	s2,a5
    8000345a:	853e                	mv	a0,a5
    8000345c:	333000ef          	jal	80003f8e <acquiresleep>
    release(&itable.lock);
    80003460:	0001b517          	auipc	a0,0x1b
    80003464:	e2050513          	addi	a0,a0,-480 # 8001e280 <itable>
    80003468:	835fd0ef          	jal	80000c9c <release>
    itrunc(ip);
    8000346c:	8526                	mv	a0,s1
    8000346e:	f0bff0ef          	jal	80003378 <itrunc>
    ip->type = 0;
    80003472:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80003476:	8526                	mv	a0,s1
    80003478:	d5fff0ef          	jal	800031d6 <iupdate>
    ip->valid = 0;
    8000347c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80003480:	854a                	mv	a0,s2
    80003482:	353000ef          	jal	80003fd4 <releasesleep>
    acquire(&itable.lock);
    80003486:	0001b517          	auipc	a0,0x1b
    8000348a:	dfa50513          	addi	a0,a0,-518 # 8001e280 <itable>
    8000348e:	f8afd0ef          	jal	80000c18 <acquire>
    80003492:	6902                	ld	s2,0(sp)
    80003494:	bf61                	j	8000342c <iput+0x20>

0000000080003496 <iunlockput>:
{
    80003496:	1101                	addi	sp,sp,-32
    80003498:	ec06                	sd	ra,24(sp)
    8000349a:	e822                	sd	s0,16(sp)
    8000349c:	e426                	sd	s1,8(sp)
    8000349e:	1000                	addi	s0,sp,32
    800034a0:	84aa                	mv	s1,a0
  iunlock(ip);
    800034a2:	e97ff0ef          	jal	80003338 <iunlock>
  iput(ip);
    800034a6:	8526                	mv	a0,s1
    800034a8:	f65ff0ef          	jal	8000340c <iput>
}
    800034ac:	60e2                	ld	ra,24(sp)
    800034ae:	6442                	ld	s0,16(sp)
    800034b0:	64a2                	ld	s1,8(sp)
    800034b2:	6105                	addi	sp,sp,32
    800034b4:	8082                	ret

00000000800034b6 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034b6:	0001b717          	auipc	a4,0x1b
    800034ba:	db672703          	lw	a4,-586(a4) # 8001e26c <sb+0xc>
    800034be:	4785                	li	a5,1
    800034c0:	0ae7fe63          	bgeu	a5,a4,8000357c <ireclaim+0xc6>
{
    800034c4:	7139                	addi	sp,sp,-64
    800034c6:	fc06                	sd	ra,56(sp)
    800034c8:	f822                	sd	s0,48(sp)
    800034ca:	f426                	sd	s1,40(sp)
    800034cc:	f04a                	sd	s2,32(sp)
    800034ce:	ec4e                	sd	s3,24(sp)
    800034d0:	e852                	sd	s4,16(sp)
    800034d2:	e456                	sd	s5,8(sp)
    800034d4:	e05a                	sd	s6,0(sp)
    800034d6:	0080                	addi	s0,sp,64
    800034d8:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800034da:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800034dc:	0001ba17          	auipc	s4,0x1b
    800034e0:	d84a0a13          	addi	s4,s4,-636 # 8001e260 <sb>
      printk("ireclaim: orphaned inode %d\n", inum);
    800034e4:	00004b17          	auipc	s6,0x4
    800034e8:	07cb0b13          	addi	s6,s6,124 # 80007560 <etext+0x560>
    800034ec:	a099                	j	80003532 <ireclaim+0x7c>
    800034ee:	85ce                	mv	a1,s3
    800034f0:	855a                	mv	a0,s6
    800034f2:	810fd0ef          	jal	80000502 <printk>
      ip = iget(dev, inum);
    800034f6:	85ce                	mv	a1,s3
    800034f8:	8556                	mv	a0,s5
    800034fa:	b17ff0ef          	jal	80003010 <iget>
    800034fe:	89aa                	mv	s3,a0
    brelse(bp);
    80003500:	854a                	mv	a0,s2
    80003502:	ff0ff0ef          	jal	80002cf2 <brelse>
    if (ip) {
    80003506:	00098f63          	beqz	s3,80003524 <ireclaim+0x6e>
      begin_op();
    8000350a:	796000ef          	jal	80003ca0 <begin_op>
      ilock(ip);
    8000350e:	854e                	mv	a0,s3
    80003510:	d7bff0ef          	jal	8000328a <ilock>
      iunlock(ip);
    80003514:	854e                	mv	a0,s3
    80003516:	e23ff0ef          	jal	80003338 <iunlock>
      iput(ip);
    8000351a:	854e                	mv	a0,s3
    8000351c:	ef1ff0ef          	jal	8000340c <iput>
      end_op();
    80003520:	7f0000ef          	jal	80003d10 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80003524:	0485                	addi	s1,s1,1
    80003526:	00ca2703          	lw	a4,12(s4)
    8000352a:	0004879b          	sext.w	a5,s1
    8000352e:	02e7fd63          	bgeu	a5,a4,80003568 <ireclaim+0xb2>
    80003532:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80003536:	0044d593          	srli	a1,s1,0x4
    8000353a:	018a2783          	lw	a5,24(s4)
    8000353e:	9dbd                	addw	a1,a1,a5
    80003540:	8556                	mv	a0,s5
    80003542:	ea8ff0ef          	jal	80002bea <bread>
    80003546:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80003548:	05850793          	addi	a5,a0,88
    8000354c:	00f9f713          	andi	a4,s3,15
    80003550:	071a                	slli	a4,a4,0x6
    80003552:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) { // is an orphaned inode
    80003554:	00079703          	lh	a4,0(a5)
    80003558:	c701                	beqz	a4,80003560 <ireclaim+0xaa>
    8000355a:	00679783          	lh	a5,6(a5)
    8000355e:	dbc1                	beqz	a5,800034ee <ireclaim+0x38>
    brelse(bp);
    80003560:	854a                	mv	a0,s2
    80003562:	f90ff0ef          	jal	80002cf2 <brelse>
    if (ip) {
    80003566:	bf7d                	j	80003524 <ireclaim+0x6e>
}
    80003568:	70e2                	ld	ra,56(sp)
    8000356a:	7442                	ld	s0,48(sp)
    8000356c:	74a2                	ld	s1,40(sp)
    8000356e:	7902                	ld	s2,32(sp)
    80003570:	69e2                	ld	s3,24(sp)
    80003572:	6a42                	ld	s4,16(sp)
    80003574:	6aa2                	ld	s5,8(sp)
    80003576:	6b02                	ld	s6,0(sp)
    80003578:	6121                	addi	sp,sp,64
    8000357a:	8082                	ret
    8000357c:	8082                	ret

000000008000357e <fsinit>:
{
    8000357e:	1101                	addi	sp,sp,-32
    80003580:	ec06                	sd	ra,24(sp)
    80003582:	e822                	sd	s0,16(sp)
    80003584:	e426                	sd	s1,8(sp)
    80003586:	e04a                	sd	s2,0(sp)
    80003588:	1000                	addi	s0,sp,32
    8000358a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000358c:	4585                	li	a1,1
    8000358e:	e5cff0ef          	jal	80002bea <bread>
    80003592:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80003594:	02000613          	li	a2,32
    80003598:	05850593          	addi	a1,a0,88
    8000359c:	0001b517          	auipc	a0,0x1b
    800035a0:	cc450513          	addi	a0,a0,-828 # 8001e260 <sb>
    800035a4:	f8cfd0ef          	jal	80000d30 <memmove>
  brelse(bp);
    800035a8:	8526                	mv	a0,s1
    800035aa:	f48ff0ef          	jal	80002cf2 <brelse>
  if (sb.magic != FSMAGIC)
    800035ae:	0001b717          	auipc	a4,0x1b
    800035b2:	cb272703          	lw	a4,-846(a4) # 8001e260 <sb>
    800035b6:	102037b7          	lui	a5,0x10203
    800035ba:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800035be:	02f71263          	bne	a4,a5,800035e2 <fsinit+0x64>
  initlog(dev, &sb);
    800035c2:	0001b597          	auipc	a1,0x1b
    800035c6:	c9e58593          	addi	a1,a1,-866 # 8001e260 <sb>
    800035ca:	854a                	mv	a0,s2
    800035cc:	652000ef          	jal	80003c1e <initlog>
  ireclaim(dev);
    800035d0:	854a                	mv	a0,s2
    800035d2:	ee5ff0ef          	jal	800034b6 <ireclaim>
}
    800035d6:	60e2                	ld	ra,24(sp)
    800035d8:	6442                	ld	s0,16(sp)
    800035da:	64a2                	ld	s1,8(sp)
    800035dc:	6902                	ld	s2,0(sp)
    800035de:	6105                	addi	sp,sp,32
    800035e0:	8082                	ret
    panic("invalid file system");
    800035e2:	00004517          	auipc	a0,0x4
    800035e6:	f9e50513          	addi	a0,a0,-98 # 80007580 <etext+0x580>
    800035ea:	a50fd0ef          	jal	8000083a <panic>

00000000800035ee <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800035ee:	1141                	addi	sp,sp,-16
    800035f0:	e406                	sd	ra,8(sp)
    800035f2:	e022                	sd	s0,0(sp)
    800035f4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800035f6:	411c                	lw	a5,0(a0)
    800035f8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800035fa:	415c                	lw	a5,4(a0)
    800035fc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800035fe:	04451783          	lh	a5,68(a0)
    80003602:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003606:	04a51783          	lh	a5,74(a0)
    8000360a:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000360e:	04c56783          	lwu	a5,76(a0)
    80003612:	e99c                	sd	a5,16(a1)
}
    80003614:	60a2                	ld	ra,8(sp)
    80003616:	6402                	ld	s0,0(sp)
    80003618:	0141                	addi	sp,sp,16
    8000361a:	8082                	ret

000000008000361c <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000361c:	457c                	lw	a5,76(a0)
    8000361e:	0ed7e663          	bltu	a5,a3,8000370a <readi+0xee>
{
    80003622:	7159                	addi	sp,sp,-112
    80003624:	f486                	sd	ra,104(sp)
    80003626:	f0a2                	sd	s0,96(sp)
    80003628:	eca6                	sd	s1,88(sp)
    8000362a:	e0d2                	sd	s4,64(sp)
    8000362c:	fc56                	sd	s5,56(sp)
    8000362e:	f85a                	sd	s6,48(sp)
    80003630:	f45e                	sd	s7,40(sp)
    80003632:	1880                	addi	s0,sp,112
    80003634:	8b2a                	mv	s6,a0
    80003636:	8bae                	mv	s7,a1
    80003638:	8a32                	mv	s4,a2
    8000363a:	84b6                	mv	s1,a3
    8000363c:	8aba                	mv	s5,a4
  if (off > ip->size || off + n < off)
    8000363e:	9f35                	addw	a4,a4,a3
    return 0;
    80003640:	4501                	li	a0,0
  if (off > ip->size || off + n < off)
    80003642:	0ad76b63          	bltu	a4,a3,800036f8 <readi+0xdc>
    80003646:	e4ce                	sd	s3,72(sp)
  if (off + n > ip->size)
    80003648:	00e7f463          	bgeu	a5,a4,80003650 <readi+0x34>
    n = ip->size - off;
    8000364c:	40d78abb          	subw	s5,a5,a3

  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    80003650:	080a8b63          	beqz	s5,800036e6 <readi+0xca>
    80003654:	e8ca                	sd	s2,80(sp)
    80003656:	f062                	sd	s8,32(sp)
    80003658:	ec66                	sd	s9,24(sp)
    8000365a:	e86a                	sd	s10,16(sp)
    8000365c:	e46e                	sd	s11,8(sp)
    8000365e:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003660:	40000c93          	li	s9,1024
    if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003664:	5c7d                	li	s8,-1
    80003666:	a80d                	j	80003698 <readi+0x7c>
    80003668:	020d1d93          	slli	s11,s10,0x20
    8000366c:	020ddd93          	srli	s11,s11,0x20
    80003670:	05890613          	addi	a2,s2,88
    80003674:	86ee                	mv	a3,s11
    80003676:	963e                	add	a2,a2,a5
    80003678:	85d2                	mv	a1,s4
    8000367a:	855e                	mv	a0,s7
    8000367c:	bb5fe0ef          	jal	80002230 <either_copyout>
    80003680:	05850363          	beq	a0,s8,800036c6 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003684:	854a                	mv	a0,s2
    80003686:	e6cff0ef          	jal	80002cf2 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    8000368a:	013d09bb          	addw	s3,s10,s3
    8000368e:	009d04bb          	addw	s1,s10,s1
    80003692:	9a6e                	add	s4,s4,s11
    80003694:	0559f363          	bgeu	s3,s5,800036da <readi+0xbe>
    uint addr = bmap(ip, off / BSIZE);
    80003698:	00a4d59b          	srliw	a1,s1,0xa
    8000369c:	855a                	mv	a0,s6
    8000369e:	8b3ff0ef          	jal	80002f50 <bmap>
    800036a2:	85aa                	mv	a1,a0
    if (addr == 0)
    800036a4:	c139                	beqz	a0,800036ea <readi+0xce>
    bp = bread(ip->dev, addr);
    800036a6:	000b2503          	lw	a0,0(s6)
    800036aa:	d40ff0ef          	jal	80002bea <bread>
    800036ae:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800036b0:	3ff4f793          	andi	a5,s1,1023
    800036b4:	40fc873b          	subw	a4,s9,a5
    800036b8:	413a86bb          	subw	a3,s5,s3
    800036bc:	8d3a                	mv	s10,a4
    800036be:	fae6f5e3          	bgeu	a3,a4,80003668 <readi+0x4c>
    800036c2:	8d36                	mv	s10,a3
    800036c4:	b755                	j	80003668 <readi+0x4c>
      brelse(bp);
    800036c6:	854a                	mv	a0,s2
    800036c8:	e2aff0ef          	jal	80002cf2 <brelse>
      tot = -1;
    800036cc:	59fd                	li	s3,-1
      break;
    800036ce:	6946                	ld	s2,80(sp)
    800036d0:	7c02                	ld	s8,32(sp)
    800036d2:	6ce2                	ld	s9,24(sp)
    800036d4:	6d42                	ld	s10,16(sp)
    800036d6:	6da2                	ld	s11,8(sp)
    800036d8:	a831                	j	800036f4 <readi+0xd8>
    800036da:	6946                	ld	s2,80(sp)
    800036dc:	7c02                	ld	s8,32(sp)
    800036de:	6ce2                	ld	s9,24(sp)
    800036e0:	6d42                	ld	s10,16(sp)
    800036e2:	6da2                	ld	s11,8(sp)
    800036e4:	a801                	j	800036f4 <readi+0xd8>
  for (tot = 0; tot < n; tot += m, off += m, dst += m) {
    800036e6:	89d6                	mv	s3,s5
    800036e8:	a031                	j	800036f4 <readi+0xd8>
    800036ea:	6946                	ld	s2,80(sp)
    800036ec:	7c02                	ld	s8,32(sp)
    800036ee:	6ce2                	ld	s9,24(sp)
    800036f0:	6d42                	ld	s10,16(sp)
    800036f2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800036f4:	854e                	mv	a0,s3
    800036f6:	69a6                	ld	s3,72(sp)
}
    800036f8:	70a6                	ld	ra,104(sp)
    800036fa:	7406                	ld	s0,96(sp)
    800036fc:	64e6                	ld	s1,88(sp)
    800036fe:	6a06                	ld	s4,64(sp)
    80003700:	7ae2                	ld	s5,56(sp)
    80003702:	7b42                	ld	s6,48(sp)
    80003704:	7ba2                	ld	s7,40(sp)
    80003706:	6165                	addi	sp,sp,112
    80003708:	8082                	ret
    return 0;
    8000370a:	4501                	li	a0,0
}
    8000370c:	8082                	ret

000000008000370e <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if (off > ip->size || off + n < off)
    8000370e:	457c                	lw	a5,76(a0)
    80003710:	0ed7ee63          	bltu	a5,a3,8000380c <writei+0xfe>
{
    80003714:	7159                	addi	sp,sp,-112
    80003716:	f486                	sd	ra,104(sp)
    80003718:	f0a2                	sd	s0,96(sp)
    8000371a:	e8ca                	sd	s2,80(sp)
    8000371c:	e0d2                	sd	s4,64(sp)
    8000371e:	fc56                	sd	s5,56(sp)
    80003720:	f85a                	sd	s6,48(sp)
    80003722:	f45e                	sd	s7,40(sp)
    80003724:	1880                	addi	s0,sp,112
    80003726:	8aaa                	mv	s5,a0
    80003728:	8bae                	mv	s7,a1
    8000372a:	8a32                	mv	s4,a2
    8000372c:	8936                	mv	s2,a3
    8000372e:	8b3a                	mv	s6,a4
  if (off > ip->size || off + n < off)
    80003730:	9f35                	addw	a4,a4,a3
    return -1;
  if (off + n > MAXFILE * BSIZE)
    80003732:	000437b7          	lui	a5,0x43
    80003736:	00e7b7b3          	sltu	a5,a5,a4
  if (off > ip->size || off + n < off)
    8000373a:	00d73733          	sltu	a4,a4,a3
  if (off + n > MAXFILE * BSIZE)
    8000373e:	8fd9                	or	a5,a5,a4
    80003740:	ef91                	bnez	a5,8000375c <writei+0x4e>
    80003742:	e4ce                	sd	s3,72(sp)
    return -1;

  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003744:	0a0b0c63          	beqz	s6,800037fc <writei+0xee>
    80003748:	eca6                	sd	s1,88(sp)
    8000374a:	f062                	sd	s8,32(sp)
    8000374c:	ec66                	sd	s9,24(sp)
    8000374e:	e86a                	sd	s10,16(sp)
    80003750:	e46e                	sd	s11,8(sp)
    80003752:	4981                	li	s3,0
    uint addr = bmap(ip, off / BSIZE);
    if (addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off % BSIZE);
    80003754:	40000c93          	li	s9,1024
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003758:	5c7d                	li	s8,-1
    8000375a:	a835                	j	80003796 <writei+0x88>
    return -1;
    8000375c:	557d                	li	a0,-1
    8000375e:	a071                	j	800037ea <writei+0xdc>
    if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003760:	020d1d93          	slli	s11,s10,0x20
    80003764:	020ddd93          	srli	s11,s11,0x20
    80003768:	05848513          	addi	a0,s1,88
    8000376c:	86ee                	mv	a3,s11
    8000376e:	8652                	mv	a2,s4
    80003770:	85de                	mv	a1,s7
    80003772:	953e                	add	a0,a0,a5
    80003774:	b07fe0ef          	jal	8000227a <either_copyin>
    80003778:	05850663          	beq	a0,s8,800037c4 <writei+0xb6>
      brelse(bp);
      break;
    }
    log_write(bp);
    8000377c:	8526                	mv	a0,s1
    8000377e:	6b4000ef          	jal	80003e32 <log_write>
    brelse(bp);
    80003782:	8526                	mv	a0,s1
    80003784:	d6eff0ef          	jal	80002cf2 <brelse>
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    80003788:	013d09bb          	addw	s3,s10,s3
    8000378c:	012d093b          	addw	s2,s10,s2
    80003790:	9a6e                	add	s4,s4,s11
    80003792:	0369fc63          	bgeu	s3,s6,800037ca <writei+0xbc>
    uint addr = bmap(ip, off / BSIZE);
    80003796:	00a9559b          	srliw	a1,s2,0xa
    8000379a:	8556                	mv	a0,s5
    8000379c:	fb4ff0ef          	jal	80002f50 <bmap>
    800037a0:	85aa                	mv	a1,a0
    if (addr == 0)
    800037a2:	c505                	beqz	a0,800037ca <writei+0xbc>
    bp = bread(ip->dev, addr);
    800037a4:	000aa503          	lw	a0,0(s5)
    800037a8:	c42ff0ef          	jal	80002bea <bread>
    800037ac:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off % BSIZE);
    800037ae:	3ff97793          	andi	a5,s2,1023
    800037b2:	40fc873b          	subw	a4,s9,a5
    800037b6:	413b06bb          	subw	a3,s6,s3
    800037ba:	8d3a                	mv	s10,a4
    800037bc:	fae6f2e3          	bgeu	a3,a4,80003760 <writei+0x52>
    800037c0:	8d36                	mv	s10,a3
    800037c2:	bf79                	j	80003760 <writei+0x52>
      brelse(bp);
    800037c4:	8526                	mv	a0,s1
    800037c6:	d2cff0ef          	jal	80002cf2 <brelse>
  }

  if (off > ip->size)
    800037ca:	04caa783          	lw	a5,76(s5)
    800037ce:	0327f963          	bgeu	a5,s2,80003800 <writei+0xf2>
    ip->size = off;
    800037d2:	052aa623          	sw	s2,76(s5)
    800037d6:	64e6                	ld	s1,88(sp)
    800037d8:	7c02                	ld	s8,32(sp)
    800037da:	6ce2                	ld	s9,24(sp)
    800037dc:	6d42                	ld	s10,16(sp)
    800037de:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800037e0:	8556                	mv	a0,s5
    800037e2:	9f5ff0ef          	jal	800031d6 <iupdate>

  return tot;
    800037e6:	854e                	mv	a0,s3
    800037e8:	69a6                	ld	s3,72(sp)
}
    800037ea:	70a6                	ld	ra,104(sp)
    800037ec:	7406                	ld	s0,96(sp)
    800037ee:	6946                	ld	s2,80(sp)
    800037f0:	6a06                	ld	s4,64(sp)
    800037f2:	7ae2                	ld	s5,56(sp)
    800037f4:	7b42                	ld	s6,48(sp)
    800037f6:	7ba2                	ld	s7,40(sp)
    800037f8:	6165                	addi	sp,sp,112
    800037fa:	8082                	ret
  for (tot = 0; tot < n; tot += m, off += m, src += m) {
    800037fc:	89da                	mv	s3,s6
    800037fe:	b7cd                	j	800037e0 <writei+0xd2>
    80003800:	64e6                	ld	s1,88(sp)
    80003802:	7c02                	ld	s8,32(sp)
    80003804:	6ce2                	ld	s9,24(sp)
    80003806:	6d42                	ld	s10,16(sp)
    80003808:	6da2                	ld	s11,8(sp)
    8000380a:	bfd9                	j	800037e0 <writei+0xd2>
    return -1;
    8000380c:	557d                	li	a0,-1
}
    8000380e:	8082                	ret

0000000080003810 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003810:	1141                	addi	sp,sp,-16
    80003812:	e406                	sd	ra,8(sp)
    80003814:	e022                	sd	s0,0(sp)
    80003816:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003818:	4639                	li	a2,14
    8000381a:	d8afd0ef          	jal	80000da4 <strncmp>
}
    8000381e:	60a2                	ld	ra,8(sp)
    80003820:	6402                	ld	s0,0(sp)
    80003822:	0141                	addi	sp,sp,16
    80003824:	8082                	ret

0000000080003826 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003826:	711d                	addi	sp,sp,-96
    80003828:	ec86                	sd	ra,88(sp)
    8000382a:	e8a2                	sd	s0,80(sp)
    8000382c:	e4a6                	sd	s1,72(sp)
    8000382e:	e0ca                	sd	s2,64(sp)
    80003830:	fc4e                	sd	s3,56(sp)
    80003832:	f852                	sd	s4,48(sp)
    80003834:	f456                	sd	s5,40(sp)
    80003836:	f05a                	sd	s6,32(sp)
    80003838:	ec5e                	sd	s7,24(sp)
    8000383a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if (dp->type != T_DIR)
    8000383c:	04451703          	lh	a4,68(a0)
    80003840:	4785                	li	a5,1
    80003842:	02f71963          	bne	a4,a5,80003874 <dirlookup+0x4e>
    80003846:	892a                	mv	s2,a0
    80003848:	8aae                	mv	s5,a1
    8000384a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000384c:	457c                	lw	a5,76(a0)
    8000384e:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003850:	fa040a13          	addi	s4,s0,-96
    80003854:	49c1                	li	s3,16
      panic("dirlookup read");
    if (de.inum == 0)
      continue;
    if (namecmp(name, de.name) == 0) {
    80003856:	fa240b13          	addi	s6,s0,-94
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000385a:	ef95                	bnez	a5,80003896 <dirlookup+0x70>
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    8000385c:	4501                	li	a0,0
}
    8000385e:	60e6                	ld	ra,88(sp)
    80003860:	6446                	ld	s0,80(sp)
    80003862:	64a6                	ld	s1,72(sp)
    80003864:	6906                	ld	s2,64(sp)
    80003866:	79e2                	ld	s3,56(sp)
    80003868:	7a42                	ld	s4,48(sp)
    8000386a:	7aa2                	ld	s5,40(sp)
    8000386c:	7b02                	ld	s6,32(sp)
    8000386e:	6be2                	ld	s7,24(sp)
    80003870:	6125                	addi	sp,sp,96
    80003872:	8082                	ret
    panic("dirlookup not DIR");
    80003874:	00004517          	auipc	a0,0x4
    80003878:	d2450513          	addi	a0,a0,-732 # 80007598 <etext+0x598>
    8000387c:	fbffc0ef          	jal	8000083a <panic>
      panic("dirlookup read");
    80003880:	00004517          	auipc	a0,0x4
    80003884:	d3050513          	addi	a0,a0,-720 # 800075b0 <etext+0x5b0>
    80003888:	fb3fc0ef          	jal	8000083a <panic>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    8000388c:	24c1                	addiw	s1,s1,16
    8000388e:	04c92783          	lw	a5,76(s2)
    80003892:	fcf4f5e3          	bgeu	s1,a5,8000385c <dirlookup+0x36>
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003896:	874e                	mv	a4,s3
    80003898:	86a6                	mv	a3,s1
    8000389a:	8652                	mv	a2,s4
    8000389c:	4581                	li	a1,0
    8000389e:	854a                	mv	a0,s2
    800038a0:	d7dff0ef          	jal	8000361c <readi>
    800038a4:	fd351ee3          	bne	a0,s3,80003880 <dirlookup+0x5a>
    if (de.inum == 0)
    800038a8:	fa045783          	lhu	a5,-96(s0)
    800038ac:	d3e5                	beqz	a5,8000388c <dirlookup+0x66>
    if (namecmp(name, de.name) == 0) {
    800038ae:	85da                	mv	a1,s6
    800038b0:	8556                	mv	a0,s5
    800038b2:	f5fff0ef          	jal	80003810 <namecmp>
    800038b6:	f979                	bnez	a0,8000388c <dirlookup+0x66>
      if (poff)
    800038b8:	000b8463          	beqz	s7,800038c0 <dirlookup+0x9a>
        *poff = off;
    800038bc:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800038c0:	fa045583          	lhu	a1,-96(s0)
    800038c4:	00092503          	lw	a0,0(s2)
    800038c8:	f48ff0ef          	jal	80003010 <iget>
    800038cc:	bf49                	j	8000385e <dirlookup+0x38>

00000000800038ce <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800038ce:	711d                	addi	sp,sp,-96
    800038d0:	ec86                	sd	ra,88(sp)
    800038d2:	e8a2                	sd	s0,80(sp)
    800038d4:	e4a6                	sd	s1,72(sp)
    800038d6:	e0ca                	sd	s2,64(sp)
    800038d8:	fc4e                	sd	s3,56(sp)
    800038da:	f852                	sd	s4,48(sp)
    800038dc:	f456                	sd	s5,40(sp)
    800038de:	f05a                	sd	s6,32(sp)
    800038e0:	ec5e                	sd	s7,24(sp)
    800038e2:	e862                	sd	s8,16(sp)
    800038e4:	e466                	sd	s9,8(sp)
    800038e6:	e06a                	sd	s10,0(sp)
    800038e8:	1080                	addi	s0,sp,96
    800038ea:	84aa                	mv	s1,a0
    800038ec:	8b2e                	mv	s6,a1
    800038ee:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if (*path == '/')
    800038f0:	00054703          	lbu	a4,0(a0)
    800038f4:	02f00793          	li	a5,47
    800038f8:	00f70f63          	beq	a4,a5,80003916 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800038fc:	fe3fd0ef          	jal	800018de <myproc>
    80003900:	15053503          	ld	a0,336(a0)
    80003904:	951ff0ef          	jal	80003254 <idup>
    80003908:	8a2a                	mv	s4,a0
  while (*path == '/')
    8000390a:	02f00993          	li	s3,47
  if (len >= DIRSIZ)
    8000390e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80003910:	4cb9                	li	s9,14

  while ((path = skipelem(path, name)) != 0) {
    ilock(ip);
    if (ip->type != T_DIR) {
    80003912:	4b85                	li	s7,1
    80003914:	a879                	j	800039b2 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003916:	4585                	li	a1,1
    80003918:	852e                	mv	a0,a1
    8000391a:	ef6ff0ef          	jal	80003010 <iget>
    8000391e:	8a2a                	mv	s4,a0
    80003920:	b7ed                	j	8000390a <namex+0x3c>
      iunlockput(ip);
    80003922:	8552                	mv	a0,s4
    80003924:	b73ff0ef          	jal	80003496 <iunlockput>
      return 0;
    80003928:	4a01                	li	s4,0
  if (nameiparent) {
    iput(ip);
    return 0;
  }
  return ip;
}
    8000392a:	8552                	mv	a0,s4
    8000392c:	60e6                	ld	ra,88(sp)
    8000392e:	6446                	ld	s0,80(sp)
    80003930:	64a6                	ld	s1,72(sp)
    80003932:	6906                	ld	s2,64(sp)
    80003934:	79e2                	ld	s3,56(sp)
    80003936:	7a42                	ld	s4,48(sp)
    80003938:	7aa2                	ld	s5,40(sp)
    8000393a:	7b02                	ld	s6,32(sp)
    8000393c:	6be2                	ld	s7,24(sp)
    8000393e:	6c42                	ld	s8,16(sp)
    80003940:	6ca2                	ld	s9,8(sp)
    80003942:	6d02                	ld	s10,0(sp)
    80003944:	6125                	addi	sp,sp,96
    80003946:	8082                	ret
      iunlock(ip);
    80003948:	8552                	mv	a0,s4
    8000394a:	9efff0ef          	jal	80003338 <iunlock>
      return ip;
    8000394e:	bff1                	j	8000392a <namex+0x5c>
      iunlockput(ip);
    80003950:	8552                	mv	a0,s4
    80003952:	b45ff0ef          	jal	80003496 <iunlockput>
      return 0;
    80003956:	8a4a                	mv	s4,s2
    80003958:	bfc9                	j	8000392a <namex+0x5c>
  while (*path != '/' && *path != 0)
    8000395a:	8926                	mv	s2,s1
  len = path - s;
    8000395c:	4d01                	li	s10,0
    8000395e:	4601                	li	a2,0
    memmove(name, s, len);
    80003960:	2601                	sext.w	a2,a2
    80003962:	85a6                	mv	a1,s1
    80003964:	8556                	mv	a0,s5
    80003966:	bcafd0ef          	jal	80000d30 <memmove>
    name[len] = 0;
    8000396a:	9d56                	add	s10,s10,s5
    8000396c:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde078>
    80003970:	84ca                	mv	s1,s2
  while (*path == '/')
    80003972:	0004c783          	lbu	a5,0(s1)
    80003976:	01379763          	bne	a5,s3,80003984 <namex+0xb6>
    path++;
    8000397a:	0485                	addi	s1,s1,1
  while (*path == '/')
    8000397c:	0004c783          	lbu	a5,0(s1)
    80003980:	ff378de3          	beq	a5,s3,8000397a <namex+0xac>
    ilock(ip);
    80003984:	8552                	mv	a0,s4
    80003986:	905ff0ef          	jal	8000328a <ilock>
    if (ip->type != T_DIR) {
    8000398a:	044a1783          	lh	a5,68(s4)
    8000398e:	f9779ae3          	bne	a5,s7,80003922 <namex+0x54>
    if (nameiparent && *path == '\0') {
    80003992:	000b0563          	beqz	s6,8000399c <namex+0xce>
    80003996:	0004c783          	lbu	a5,0(s1)
    8000399a:	d7dd                	beqz	a5,80003948 <namex+0x7a>
    if ((next = dirlookup(ip, name, 0)) == 0) {
    8000399c:	4601                	li	a2,0
    8000399e:	85d6                	mv	a1,s5
    800039a0:	8552                	mv	a0,s4
    800039a2:	e85ff0ef          	jal	80003826 <dirlookup>
    800039a6:	892a                	mv	s2,a0
    800039a8:	d545                	beqz	a0,80003950 <namex+0x82>
    iunlockput(ip);
    800039aa:	8552                	mv	a0,s4
    800039ac:	aebff0ef          	jal	80003496 <iunlockput>
    ip = next;
    800039b0:	8a4a                	mv	s4,s2
  while (*path == '/')
    800039b2:	0004c783          	lbu	a5,0(s1)
    800039b6:	01379763          	bne	a5,s3,800039c4 <namex+0xf6>
    path++;
    800039ba:	0485                	addi	s1,s1,1
  while (*path == '/')
    800039bc:	0004c783          	lbu	a5,0(s1)
    800039c0:	ff378de3          	beq	a5,s3,800039ba <namex+0xec>
  if (*path == 0)
    800039c4:	c7a1                	beqz	a5,80003a0c <namex+0x13e>
  while (*path != '/' && *path != 0)
    800039c6:	0004c703          	lbu	a4,0(s1)
    800039ca:	fd170793          	addi	a5,a4,-47
    800039ce:	00f037b3          	snez	a5,a5
    800039d2:	00e03733          	snez	a4,a4
    800039d6:	8ff9                	and	a5,a5,a4
    800039d8:	d3c9                	beqz	a5,8000395a <namex+0x8c>
    800039da:	8926                	mv	s2,s1
    path++;
    800039dc:	0905                	addi	s2,s2,1
  while (*path != '/' && *path != 0)
    800039de:	00094703          	lbu	a4,0(s2)
    800039e2:	fd170793          	addi	a5,a4,-47
    800039e6:	00f037b3          	snez	a5,a5
    800039ea:	00e03733          	snez	a4,a4
    800039ee:	8ff9                	and	a5,a5,a4
    800039f0:	f7f5                	bnez	a5,800039dc <namex+0x10e>
  len = path - s;
    800039f2:	40990633          	sub	a2,s2,s1
    800039f6:	00060d1b          	sext.w	s10,a2
  if (len >= DIRSIZ)
    800039fa:	f7ac53e3          	bge	s8,s10,80003960 <namex+0x92>
    memmove(name, s, DIRSIZ);
    800039fe:	8666                	mv	a2,s9
    80003a00:	85a6                	mv	a1,s1
    80003a02:	8556                	mv	a0,s5
    80003a04:	b2cfd0ef          	jal	80000d30 <memmove>
    80003a08:	84ca                	mv	s1,s2
    80003a0a:	b7a5                	j	80003972 <namex+0xa4>
  if (nameiparent) {
    80003a0c:	f00b0fe3          	beqz	s6,8000392a <namex+0x5c>
    iput(ip);
    80003a10:	8552                	mv	a0,s4
    80003a12:	9fbff0ef          	jal	8000340c <iput>
    return 0;
    80003a16:	bf09                	j	80003928 <namex+0x5a>

0000000080003a18 <dirlink>:
{
    80003a18:	715d                	addi	sp,sp,-80
    80003a1a:	e486                	sd	ra,72(sp)
    80003a1c:	e0a2                	sd	s0,64(sp)
    80003a1e:	f84a                	sd	s2,48(sp)
    80003a20:	ec56                	sd	s5,24(sp)
    80003a22:	e85a                	sd	s6,16(sp)
    80003a24:	0880                	addi	s0,sp,80
    80003a26:	892a                	mv	s2,a0
    80003a28:	8aae                	mv	s5,a1
    80003a2a:	8b32                	mv	s6,a2
  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80003a2c:	4601                	li	a2,0
    80003a2e:	df9ff0ef          	jal	80003826 <dirlookup>
    80003a32:	ed1d                	bnez	a0,80003a70 <dirlink+0x58>
    80003a34:	fc26                	sd	s1,56(sp)
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a36:	04c92483          	lw	s1,76(s2)
    80003a3a:	c4b9                	beqz	s1,80003a88 <dirlink+0x70>
    80003a3c:	f44e                	sd	s3,40(sp)
    80003a3e:	f052                	sd	s4,32(sp)
    80003a40:	4481                	li	s1,0
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a42:	fb040a13          	addi	s4,s0,-80
    80003a46:	49c1                	li	s3,16
    80003a48:	874e                	mv	a4,s3
    80003a4a:	86a6                	mv	a3,s1
    80003a4c:	8652                	mv	a2,s4
    80003a4e:	4581                	li	a1,0
    80003a50:	854a                	mv	a0,s2
    80003a52:	bcbff0ef          	jal	8000361c <readi>
    80003a56:	03351163          	bne	a0,s3,80003a78 <dirlink+0x60>
    if (de.inum == 0)
    80003a5a:	fb045783          	lhu	a5,-80(s0)
    80003a5e:	c39d                	beqz	a5,80003a84 <dirlink+0x6c>
  for (off = 0; off < dp->size; off += sizeof(de)) {
    80003a60:	24c1                	addiw	s1,s1,16
    80003a62:	04c92783          	lw	a5,76(s2)
    80003a66:	fef4e1e3          	bltu	s1,a5,80003a48 <dirlink+0x30>
    80003a6a:	79a2                	ld	s3,40(sp)
    80003a6c:	7a02                	ld	s4,32(sp)
    80003a6e:	a829                	j	80003a88 <dirlink+0x70>
    iput(ip);
    80003a70:	99dff0ef          	jal	8000340c <iput>
    return -1;
    80003a74:	557d                	li	a0,-1
    80003a76:	a83d                	j	80003ab4 <dirlink+0x9c>
      panic("dirlink read");
    80003a78:	00004517          	auipc	a0,0x4
    80003a7c:	b4850513          	addi	a0,a0,-1208 # 800075c0 <etext+0x5c0>
    80003a80:	dbbfc0ef          	jal	8000083a <panic>
    80003a84:	79a2                	ld	s3,40(sp)
    80003a86:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80003a88:	4639                	li	a2,14
    80003a8a:	85d6                	mv	a1,s5
    80003a8c:	fb240513          	addi	a0,s0,-78
    80003a90:	b4afd0ef          	jal	80000dda <strncpy>
  de.inum = inum;
    80003a94:	fb641823          	sh	s6,-80(s0)
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003a98:	4741                	li	a4,16
    80003a9a:	86a6                	mv	a3,s1
    80003a9c:	fb040613          	addi	a2,s0,-80
    80003aa0:	4581                	li	a1,0
    80003aa2:	854a                	mv	a0,s2
    80003aa4:	c6bff0ef          	jal	8000370e <writei>
    80003aa8:	1541                	addi	a0,a0,-16
    80003aaa:	00a03533          	snez	a0,a0
    80003aae:	40a0053b          	negw	a0,a0
    80003ab2:	74e2                	ld	s1,56(sp)
}
    80003ab4:	60a6                	ld	ra,72(sp)
    80003ab6:	6406                	ld	s0,64(sp)
    80003ab8:	7942                	ld	s2,48(sp)
    80003aba:	6ae2                	ld	s5,24(sp)
    80003abc:	6b42                	ld	s6,16(sp)
    80003abe:	6161                	addi	sp,sp,80
    80003ac0:	8082                	ret

0000000080003ac2 <namei>:

struct inode *
namei(char *path)
{
    80003ac2:	1101                	addi	sp,sp,-32
    80003ac4:	ec06                	sd	ra,24(sp)
    80003ac6:	e822                	sd	s0,16(sp)
    80003ac8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003aca:	fe040613          	addi	a2,s0,-32
    80003ace:	4581                	li	a1,0
    80003ad0:	dffff0ef          	jal	800038ce <namex>
}
    80003ad4:	60e2                	ld	ra,24(sp)
    80003ad6:	6442                	ld	s0,16(sp)
    80003ad8:	6105                	addi	sp,sp,32
    80003ada:	8082                	ret

0000000080003adc <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003adc:	1141                	addi	sp,sp,-16
    80003ade:	e406                	sd	ra,8(sp)
    80003ae0:	e022                	sd	s0,0(sp)
    80003ae2:	0800                	addi	s0,sp,16
    80003ae4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003ae6:	4585                	li	a1,1
    80003ae8:	de7ff0ef          	jal	800038ce <namex>
}
    80003aec:	60a2                	ld	ra,8(sp)
    80003aee:	6402                	ld	s0,0(sp)
    80003af0:	0141                	addi	sp,sp,16
    80003af2:	8082                	ret

0000000080003af4 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003af4:	1101                	addi	sp,sp,-32
    80003af6:	ec06                	sd	ra,24(sp)
    80003af8:	e822                	sd	s0,16(sp)
    80003afa:	e426                	sd	s1,8(sp)
    80003afc:	e04a                	sd	s2,0(sp)
    80003afe:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003b00:	0001c917          	auipc	s2,0x1c
    80003b04:	22890913          	addi	s2,s2,552 # 8001fd28 <log>
    80003b08:	01892583          	lw	a1,24(s2)
    80003b0c:	02492503          	lw	a0,36(s2)
    80003b10:	8daff0ef          	jal	80002bea <bread>
    80003b14:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *)(buf->data);
  int i;
  hb->n = log.lh.n;
    80003b16:	02c92603          	lw	a2,44(s2)
    80003b1a:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003b1c:	00c05f63          	blez	a2,80003b3a <write_head+0x46>
    80003b20:	0001c717          	auipc	a4,0x1c
    80003b24:	23870713          	addi	a4,a4,568 # 8001fd58 <log+0x30>
    80003b28:	87aa                	mv	a5,a0
    80003b2a:	060a                	slli	a2,a2,0x2
    80003b2c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003b2e:	4314                	lw	a3,0(a4)
    80003b30:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003b32:	0711                	addi	a4,a4,4
    80003b34:	0791                	addi	a5,a5,4 # 43004 <_entry-0x7ffbcffc>
    80003b36:	fec79ce3          	bne	a5,a2,80003b2e <write_head+0x3a>
  }
  bwrite(buf);
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	984ff0ef          	jal	80002cc0 <bwrite>
  brelse(buf);
    80003b40:	8526                	mv	a0,s1
    80003b42:	9b0ff0ef          	jal	80002cf2 <brelse>
}
    80003b46:	60e2                	ld	ra,24(sp)
    80003b48:	6442                	ld	s0,16(sp)
    80003b4a:	64a2                	ld	s1,8(sp)
    80003b4c:	6902                	ld	s2,0(sp)
    80003b4e:	6105                	addi	sp,sp,32
    80003b50:	8082                	ret

0000000080003b52 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b52:	0001c797          	auipc	a5,0x1c
    80003b56:	2027a783          	lw	a5,514(a5) # 8001fd54 <log+0x2c>
    80003b5a:	0cf05163          	blez	a5,80003c1c <install_trans+0xca>
{
    80003b5e:	715d                	addi	sp,sp,-80
    80003b60:	e486                	sd	ra,72(sp)
    80003b62:	e0a2                	sd	s0,64(sp)
    80003b64:	fc26                	sd	s1,56(sp)
    80003b66:	f84a                	sd	s2,48(sp)
    80003b68:	f44e                	sd	s3,40(sp)
    80003b6a:	f052                	sd	s4,32(sp)
    80003b6c:	ec56                	sd	s5,24(sp)
    80003b6e:	e85a                	sd	s6,16(sp)
    80003b70:	e45e                	sd	s7,8(sp)
    80003b72:	e062                	sd	s8,0(sp)
    80003b74:	0880                	addi	s0,sp,80
    80003b76:	8b2a                	mv	s6,a0
    80003b78:	0001ca97          	auipc	s5,0x1c
    80003b7c:	1e0a8a93          	addi	s5,s5,480 # 8001fd58 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003b80:	4981                	li	s3,0
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b82:	00004c17          	auipc	s8,0x4
    80003b86:	a4ec0c13          	addi	s8,s8,-1458 # 800075d0 <etext+0x5d0>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003b8a:	0001ca17          	auipc	s4,0x1c
    80003b8e:	19ea0a13          	addi	s4,s4,414 # 8001fd28 <log>
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003b92:	40000b93          	li	s7,1024
    80003b96:	a025                	j	80003bbe <install_trans+0x6c>
      printk("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003b98:	000aa603          	lw	a2,0(s5)
    80003b9c:	85ce                	mv	a1,s3
    80003b9e:	8562                	mv	a0,s8
    80003ba0:	963fc0ef          	jal	80000502 <printk>
    80003ba4:	a839                	j	80003bc2 <install_trans+0x70>
    brelse(lbuf);
    80003ba6:	854a                	mv	a0,s2
    80003ba8:	94aff0ef          	jal	80002cf2 <brelse>
    brelse(dbuf);
    80003bac:	8526                	mv	a0,s1
    80003bae:	944ff0ef          	jal	80002cf2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003bb2:	2985                	addiw	s3,s3,1
    80003bb4:	0a91                	addi	s5,s5,4
    80003bb6:	02ca2783          	lw	a5,44(s4)
    80003bba:	04f9d563          	bge	s3,a5,80003c04 <install_trans+0xb2>
    if (recovering) {
    80003bbe:	fc0b1de3          	bnez	s6,80003b98 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start + tail + 1); // read log block
    80003bc2:	018a2583          	lw	a1,24(s4)
    80003bc6:	013585bb          	addw	a1,a1,s3
    80003bca:	2585                	addiw	a1,a1,1
    80003bcc:	024a2503          	lw	a0,36(s4)
    80003bd0:	81aff0ef          	jal	80002bea <bread>
    80003bd4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]);   // read dst
    80003bd6:	000aa583          	lw	a1,0(s5)
    80003bda:	024a2503          	lw	a0,36(s4)
    80003bde:	80cff0ef          	jal	80002bea <bread>
    80003be2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE); // copy block to dst
    80003be4:	865e                	mv	a2,s7
    80003be6:	05890593          	addi	a1,s2,88
    80003bea:	05850513          	addi	a0,a0,88
    80003bee:	942fd0ef          	jal	80000d30 <memmove>
    bwrite(dbuf);                           // write dst to disk
    80003bf2:	8526                	mv	a0,s1
    80003bf4:	8ccff0ef          	jal	80002cc0 <bwrite>
    if (recovering == 0)
    80003bf8:	fa0b17e3          	bnez	s6,80003ba6 <install_trans+0x54>
      bunpin(dbuf);
    80003bfc:	8526                	mv	a0,s1
    80003bfe:	9acff0ef          	jal	80002daa <bunpin>
    80003c02:	b755                	j	80003ba6 <install_trans+0x54>
}
    80003c04:	60a6                	ld	ra,72(sp)
    80003c06:	6406                	ld	s0,64(sp)
    80003c08:	74e2                	ld	s1,56(sp)
    80003c0a:	7942                	ld	s2,48(sp)
    80003c0c:	79a2                	ld	s3,40(sp)
    80003c0e:	7a02                	ld	s4,32(sp)
    80003c10:	6ae2                	ld	s5,24(sp)
    80003c12:	6b42                	ld	s6,16(sp)
    80003c14:	6ba2                	ld	s7,8(sp)
    80003c16:	6c02                	ld	s8,0(sp)
    80003c18:	6161                	addi	sp,sp,80
    80003c1a:	8082                	ret
    80003c1c:	8082                	ret

0000000080003c1e <initlog>:
{
    80003c1e:	7179                	addi	sp,sp,-48
    80003c20:	f406                	sd	ra,40(sp)
    80003c22:	f022                	sd	s0,32(sp)
    80003c24:	ec26                	sd	s1,24(sp)
    80003c26:	e84a                	sd	s2,16(sp)
    80003c28:	e44e                	sd	s3,8(sp)
    80003c2a:	1800                	addi	s0,sp,48
    80003c2c:	84aa                	mv	s1,a0
    80003c2e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003c30:	0001c917          	auipc	s2,0x1c
    80003c34:	0f890913          	addi	s2,s2,248 # 8001fd28 <log>
    80003c38:	00004597          	auipc	a1,0x4
    80003c3c:	9b858593          	addi	a1,a1,-1608 # 800075f0 <etext+0x5f0>
    80003c40:	854a                	mv	a0,s2
    80003c42:	f57fc0ef          	jal	80000b98 <initlock>
  log.start = sb->logstart;
    80003c46:	0149a583          	lw	a1,20(s3)
    80003c4a:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003c4e:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003c52:	8526                	mv	a0,s1
    80003c54:	f97fe0ef          	jal	80002bea <bread>
  log.lh.n = lh->n;
    80003c58:	4d30                	lw	a2,88(a0)
    80003c5a:	02c92623          	sw	a2,44(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003c5e:	00c05f63          	blez	a2,80003c7c <initlog+0x5e>
    80003c62:	87aa                	mv	a5,a0
    80003c64:	0001c717          	auipc	a4,0x1c
    80003c68:	0f470713          	addi	a4,a4,244 # 8001fd58 <log+0x30>
    80003c6c:	060a                	slli	a2,a2,0x2
    80003c6e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003c70:	4ff4                	lw	a3,92(a5)
    80003c72:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003c74:	0791                	addi	a5,a5,4
    80003c76:	0711                	addi	a4,a4,4
    80003c78:	fec79ce3          	bne	a5,a2,80003c70 <initlog+0x52>
  brelse(buf);
    80003c7c:	876ff0ef          	jal	80002cf2 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003c80:	4505                	li	a0,1
    80003c82:	ed1ff0ef          	jal	80003b52 <install_trans>
  log.lh.n = 0;
    80003c86:	0001c797          	auipc	a5,0x1c
    80003c8a:	0c07a723          	sw	zero,206(a5) # 8001fd54 <log+0x2c>
  write_head(); // clear the log
    80003c8e:	e67ff0ef          	jal	80003af4 <write_head>
}
    80003c92:	70a2                	ld	ra,40(sp)
    80003c94:	7402                	ld	s0,32(sp)
    80003c96:	64e2                	ld	s1,24(sp)
    80003c98:	6942                	ld	s2,16(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
    80003c9c:	6145                	addi	sp,sp,48
    80003c9e:	8082                	ret

0000000080003ca0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003ca0:	1101                	addi	sp,sp,-32
    80003ca2:	ec06                	sd	ra,24(sp)
    80003ca4:	e822                	sd	s0,16(sp)
    80003ca6:	e426                	sd	s1,8(sp)
    80003ca8:	e04a                	sd	s2,0(sp)
    80003caa:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003cac:	0001c517          	auipc	a0,0x1c
    80003cb0:	07c50513          	addi	a0,a0,124 # 8001fd28 <log>
    80003cb4:	f65fc0ef          	jal	80000c18 <acquire>
  while (1) {
    if (log.committing) {
    80003cb8:	0001c497          	auipc	s1,0x1c
    80003cbc:	07048493          	addi	s1,s1,112 # 8001fd28 <log>
      sleep(&log, &log.lock);
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003cc0:	4979                	li	s2,30
    80003cc2:	a029                	j	80003ccc <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003cc4:	85a6                	mv	a1,s1
    80003cc6:	8526                	mv	a0,s1
    80003cc8:	a10fe0ef          	jal	80001ed8 <sleep>
    if (log.committing) {
    80003ccc:	509c                	lw	a5,32(s1)
    80003cce:	fbfd                	bnez	a5,80003cc4 <begin_op+0x24>
    } else if (log.lh.n + (log.outstanding + 1) * MAXOPBLOCKS > LOGBLOCKS) {
    80003cd0:	4cd8                	lw	a4,28(s1)
    80003cd2:	2705                	addiw	a4,a4,1
    80003cd4:	0027179b          	slliw	a5,a4,0x2
    80003cd8:	9fb9                	addw	a5,a5,a4
    80003cda:	0017979b          	slliw	a5,a5,0x1
    80003cde:	54d4                	lw	a3,44(s1)
    80003ce0:	9fb5                	addw	a5,a5,a3
    80003ce2:	00f95763          	bge	s2,a5,80003cf0 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003ce6:	85a6                	mv	a1,s1
    80003ce8:	8526                	mv	a0,s1
    80003cea:	9eefe0ef          	jal	80001ed8 <sleep>
    80003cee:	bff9                	j	80003ccc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003cf0:	0001c797          	auipc	a5,0x1c
    80003cf4:	04e7aa23          	sw	a4,84(a5) # 8001fd44 <log+0x1c>
      release(&log.lock);
    80003cf8:	0001c517          	auipc	a0,0x1c
    80003cfc:	03050513          	addi	a0,a0,48 # 8001fd28 <log>
    80003d00:	f9dfc0ef          	jal	80000c9c <release>
      break;
    }
  }
}
    80003d04:	60e2                	ld	ra,24(sp)
    80003d06:	6442                	ld	s0,16(sp)
    80003d08:	64a2                	ld	s1,8(sp)
    80003d0a:	6902                	ld	s2,0(sp)
    80003d0c:	6105                	addi	sp,sp,32
    80003d0e:	8082                	ret

0000000080003d10 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003d10:	7139                	addi	sp,sp,-64
    80003d12:	fc06                	sd	ra,56(sp)
    80003d14:	f822                	sd	s0,48(sp)
    80003d16:	f426                	sd	s1,40(sp)
    80003d18:	f04a                	sd	s2,32(sp)
    80003d1a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003d1c:	0001c497          	auipc	s1,0x1c
    80003d20:	00c48493          	addi	s1,s1,12 # 8001fd28 <log>
    80003d24:	8526                	mv	a0,s1
    80003d26:	ef3fc0ef          	jal	80000c18 <acquire>
  log.outstanding -= 1;
    80003d2a:	4cdc                	lw	a5,28(s1)
    80003d2c:	37fd                	addiw	a5,a5,-1
    80003d2e:	893e                	mv	s2,a5
    80003d30:	ccdc                	sw	a5,28(s1)
  if (log.committing)
    80003d32:	509c                	lw	a5,32(s1)
    80003d34:	e7b9                	bnez	a5,80003d82 <end_op+0x72>
    panic("log.committing");
  if (log.outstanding == 0) {
    80003d36:	04091f63          	bnez	s2,80003d94 <end_op+0x84>
    do_commit = 1;
    log.committing = 1;
    80003d3a:	0001c497          	auipc	s1,0x1c
    80003d3e:	fee48493          	addi	s1,s1,-18 # 8001fd28 <log>
    80003d42:	4785                	li	a5,1
    80003d44:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003d46:	8526                	mv	a0,s1
    80003d48:	f55fc0ef          	jal	80000c9c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003d4c:	54dc                	lw	a5,44(s1)
    80003d4e:	06f04063          	bgtz	a5,80003dae <end_op+0x9e>
    acquire(&log.lock);
    80003d52:	0001c497          	auipc	s1,0x1c
    80003d56:	fd648493          	addi	s1,s1,-42 # 8001fd28 <log>
    80003d5a:	8526                	mv	a0,s1
    80003d5c:	ebdfc0ef          	jal	80000c18 <acquire>
    log.committing = 0;
    80003d60:	0204a023          	sw	zero,32(s1)
    log.ncommit += 1;
    80003d64:	549c                	lw	a5,40(s1)
    80003d66:	2785                	addiw	a5,a5,1
    80003d68:	d49c                	sw	a5,40(s1)
    wakeup(&log);
    80003d6a:	8526                	mv	a0,s1
    80003d6c:	9b8fe0ef          	jal	80001f24 <wakeup>
    release(&log.lock);
    80003d70:	8526                	mv	a0,s1
    80003d72:	f2bfc0ef          	jal	80000c9c <release>
}
    80003d76:	70e2                	ld	ra,56(sp)
    80003d78:	7442                	ld	s0,48(sp)
    80003d7a:	74a2                	ld	s1,40(sp)
    80003d7c:	7902                	ld	s2,32(sp)
    80003d7e:	6121                	addi	sp,sp,64
    80003d80:	8082                	ret
    80003d82:	ec4e                	sd	s3,24(sp)
    80003d84:	e852                	sd	s4,16(sp)
    80003d86:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003d88:	00004517          	auipc	a0,0x4
    80003d8c:	87050513          	addi	a0,a0,-1936 # 800075f8 <etext+0x5f8>
    80003d90:	aabfc0ef          	jal	8000083a <panic>
    wakeup(&log);
    80003d94:	0001c517          	auipc	a0,0x1c
    80003d98:	f9450513          	addi	a0,a0,-108 # 8001fd28 <log>
    80003d9c:	988fe0ef          	jal	80001f24 <wakeup>
  release(&log.lock);
    80003da0:	0001c517          	auipc	a0,0x1c
    80003da4:	f8850513          	addi	a0,a0,-120 # 8001fd28 <log>
    80003da8:	ef5fc0ef          	jal	80000c9c <release>
  if (do_commit) {
    80003dac:	b7e9                	j	80003d76 <end_op+0x66>
    80003dae:	ec4e                	sd	s3,24(sp)
    80003db0:	e852                	sd	s4,16(sp)
    80003db2:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003db4:	0001ca97          	auipc	s5,0x1c
    80003db8:	fa4a8a93          	addi	s5,s5,-92 # 8001fd58 <log+0x30>
    struct buf *to = bread(log.dev, log.start + tail + 1); // log block
    80003dbc:	0001ca17          	auipc	s4,0x1c
    80003dc0:	f6ca0a13          	addi	s4,s4,-148 # 8001fd28 <log>
    80003dc4:	018a2583          	lw	a1,24(s4)
    80003dc8:	012585bb          	addw	a1,a1,s2
    80003dcc:	2585                	addiw	a1,a1,1
    80003dce:	024a2503          	lw	a0,36(s4)
    80003dd2:	e19fe0ef          	jal	80002bea <bread>
    80003dd6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003dd8:	000aa583          	lw	a1,0(s5)
    80003ddc:	024a2503          	lw	a0,36(s4)
    80003de0:	e0bfe0ef          	jal	80002bea <bread>
    80003de4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003de6:	40000613          	li	a2,1024
    80003dea:	05850593          	addi	a1,a0,88
    80003dee:	05848513          	addi	a0,s1,88
    80003df2:	f3ffc0ef          	jal	80000d30 <memmove>
    bwrite(to); // write the log
    80003df6:	8526                	mv	a0,s1
    80003df8:	ec9fe0ef          	jal	80002cc0 <bwrite>
    brelse(from);
    80003dfc:	854e                	mv	a0,s3
    80003dfe:	ef5fe0ef          	jal	80002cf2 <brelse>
    brelse(to);
    80003e02:	8526                	mv	a0,s1
    80003e04:	eeffe0ef          	jal	80002cf2 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003e08:	2905                	addiw	s2,s2,1
    80003e0a:	0a91                	addi	s5,s5,4
    80003e0c:	02ca2783          	lw	a5,44(s4)
    80003e10:	faf94ae3          	blt	s2,a5,80003dc4 <end_op+0xb4>
    write_log();      // Write modified blocks from cache to log
    write_head();     // Write header to disk -- the real commit
    80003e14:	ce1ff0ef          	jal	80003af4 <write_head>
    install_trans(0); // Now install writes to home locations
    80003e18:	4501                	li	a0,0
    80003e1a:	d39ff0ef          	jal	80003b52 <install_trans>
    log.lh.n = 0;
    80003e1e:	0001c797          	auipc	a5,0x1c
    80003e22:	f207ab23          	sw	zero,-202(a5) # 8001fd54 <log+0x2c>
    write_head(); // Erase the transaction from the log
    80003e26:	ccfff0ef          	jal	80003af4 <write_head>
    80003e2a:	69e2                	ld	s3,24(sp)
    80003e2c:	6a42                	ld	s4,16(sp)
    80003e2e:	6aa2                	ld	s5,8(sp)
    80003e30:	b70d                	j	80003d52 <end_op+0x42>

0000000080003e32 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003e32:	1101                	addi	sp,sp,-32
    80003e34:	ec06                	sd	ra,24(sp)
    80003e36:	e822                	sd	s0,16(sp)
    80003e38:	e426                	sd	s1,8(sp)
    80003e3a:	1000                	addi	s0,sp,32
    80003e3c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003e3e:	0001c517          	auipc	a0,0x1c
    80003e42:	eea50513          	addi	a0,a0,-278 # 8001fd28 <log>
    80003e46:	dd3fc0ef          	jal	80000c18 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003e4a:	0001c617          	auipc	a2,0x1c
    80003e4e:	f0a62603          	lw	a2,-246(a2) # 8001fd54 <log+0x2c>
    80003e52:	47f5                	li	a5,29
    80003e54:	04c7cc63          	blt	a5,a2,80003eac <log_write+0x7a>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003e58:	0001c797          	auipc	a5,0x1c
    80003e5c:	eec7a783          	lw	a5,-276(a5) # 8001fd44 <log+0x1c>
    80003e60:	04f05c63          	blez	a5,80003eb8 <log_write+0x86>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003e64:	4781                	li	a5,0
    80003e66:	04c05f63          	blez	a2,80003ec4 <log_write+0x92>
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e6a:	44cc                	lw	a1,12(s1)
    80003e6c:	0001c717          	auipc	a4,0x1c
    80003e70:	eec70713          	addi	a4,a4,-276 # 8001fd58 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003e74:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno) // log absorption
    80003e76:	4314                	lw	a3,0(a4)
    80003e78:	04b68663          	beq	a3,a1,80003ec4 <log_write+0x92>
  for (i = 0; i < log.lh.n; i++) {
    80003e7c:	2785                	addiw	a5,a5,1
    80003e7e:	0711                	addi	a4,a4,4
    80003e80:	fef61be3          	bne	a2,a5,80003e76 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003e84:	0621                	addi	a2,a2,8
    80003e86:	060a                	slli	a2,a2,0x2
    80003e88:	0001c797          	auipc	a5,0x1c
    80003e8c:	ea078793          	addi	a5,a5,-352 # 8001fd28 <log>
    80003e90:	97b2                	add	a5,a5,a2
    80003e92:	44d8                	lw	a4,12(s1)
    80003e94:	cb98                	sw	a4,16(a5)
  if (i == log.lh.n) { // Add new block to log?
    bpin(b);
    80003e96:	8526                	mv	a0,s1
    80003e98:	edffe0ef          	jal	80002d76 <bpin>
    log.lh.n++;
    80003e9c:	0001c717          	auipc	a4,0x1c
    80003ea0:	e8c70713          	addi	a4,a4,-372 # 8001fd28 <log>
    80003ea4:	575c                	lw	a5,44(a4)
    80003ea6:	2785                	addiw	a5,a5,1
    80003ea8:	d75c                	sw	a5,44(a4)
    80003eaa:	a80d                	j	80003edc <log_write+0xaa>
    panic("too big a transaction");
    80003eac:	00003517          	auipc	a0,0x3
    80003eb0:	75c50513          	addi	a0,a0,1884 # 80007608 <etext+0x608>
    80003eb4:	987fc0ef          	jal	8000083a <panic>
    panic("log_write outside of trans");
    80003eb8:	00003517          	auipc	a0,0x3
    80003ebc:	76850513          	addi	a0,a0,1896 # 80007620 <etext+0x620>
    80003ec0:	97bfc0ef          	jal	8000083a <panic>
  log.lh.block[i] = b->blockno;
    80003ec4:	00878693          	addi	a3,a5,8
    80003ec8:	068a                	slli	a3,a3,0x2
    80003eca:	0001c717          	auipc	a4,0x1c
    80003ece:	e5e70713          	addi	a4,a4,-418 # 8001fd28 <log>
    80003ed2:	9736                	add	a4,a4,a3
    80003ed4:	44d4                	lw	a3,12(s1)
    80003ed6:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) { // Add new block to log?
    80003ed8:	faf60fe3          	beq	a2,a5,80003e96 <log_write+0x64>
  }
  release(&log.lock);
    80003edc:	0001c517          	auipc	a0,0x1c
    80003ee0:	e4c50513          	addi	a0,a0,-436 # 8001fd28 <log>
    80003ee4:	db9fc0ef          	jal	80000c9c <release>
}
    80003ee8:	60e2                	ld	ra,24(sp)
    80003eea:	6442                	ld	s0,16(sp)
    80003eec:	64a2                	ld	s1,8(sp)
    80003eee:	6105                	addi	sp,sp,32
    80003ef0:	8082                	ret

0000000080003ef2 <sys_sync>:

uint64
sys_sync(void)
{
    80003ef2:	1101                	addi	sp,sp,-32
    80003ef4:	ec06                	sd	ra,24(sp)
    80003ef6:	e822                	sd	s0,16(sp)
    80003ef8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003efa:	0001c517          	auipc	a0,0x1c
    80003efe:	e2e50513          	addi	a0,a0,-466 # 8001fd28 <log>
    80003f02:	d17fc0ef          	jal	80000c18 <acquire>
  if (log.committing || log.outstanding > 0) {
    80003f06:	0001c797          	auipc	a5,0x1c
    80003f0a:	e427a783          	lw	a5,-446(a5) # 8001fd48 <log+0x20>
    80003f0e:	e799                	bnez	a5,80003f1c <sys_sync+0x2a>
    80003f10:	0001c797          	auipc	a5,0x1c
    80003f14:	e347a783          	lw	a5,-460(a5) # 8001fd44 <log+0x1c>
    80003f18:	02f05563          	blez	a5,80003f42 <sys_sync+0x50>
    80003f1c:	e426                	sd	s1,8(sp)
    80003f1e:	e04a                	sd	s2,0(sp)
    int n = log.ncommit + 1;
    80003f20:	0001c917          	auipc	s2,0x1c
    80003f24:	e3092903          	lw	s2,-464(s2) # 8001fd50 <log+0x28>
    while (log.ncommit < n) {
      sleep(&log, &log.lock);
    80003f28:	0001c497          	auipc	s1,0x1c
    80003f2c:	e0048493          	addi	s1,s1,-512 # 8001fd28 <log>
    80003f30:	85a6                	mv	a1,s1
    80003f32:	8526                	mv	a0,s1
    80003f34:	fa5fd0ef          	jal	80001ed8 <sleep>
    while (log.ncommit < n) {
    80003f38:	549c                	lw	a5,40(s1)
    80003f3a:	fef95be3          	bge	s2,a5,80003f30 <sys_sync+0x3e>
    80003f3e:	64a2                	ld	s1,8(sp)
    80003f40:	6902                	ld	s2,0(sp)
    }
  }
  release(&log.lock);
    80003f42:	0001c517          	auipc	a0,0x1c
    80003f46:	de650513          	addi	a0,a0,-538 # 8001fd28 <log>
    80003f4a:	d53fc0ef          	jal	80000c9c <release>
  return 0;
}
    80003f4e:	4501                	li	a0,0
    80003f50:	60e2                	ld	ra,24(sp)
    80003f52:	6442                	ld	s0,16(sp)
    80003f54:	6105                	addi	sp,sp,32
    80003f56:	8082                	ret

0000000080003f58 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003f58:	1101                	addi	sp,sp,-32
    80003f5a:	ec06                	sd	ra,24(sp)
    80003f5c:	e822                	sd	s0,16(sp)
    80003f5e:	e426                	sd	s1,8(sp)
    80003f60:	e04a                	sd	s2,0(sp)
    80003f62:	1000                	addi	s0,sp,32
    80003f64:	84aa                	mv	s1,a0
    80003f66:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003f68:	00003597          	auipc	a1,0x3
    80003f6c:	6d858593          	addi	a1,a1,1752 # 80007640 <etext+0x640>
    80003f70:	0521                	addi	a0,a0,8
    80003f72:	c27fc0ef          	jal	80000b98 <initlock>
  lk->name = name;
    80003f76:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003f7a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003f7e:	0204a423          	sw	zero,40(s1)
}
    80003f82:	60e2                	ld	ra,24(sp)
    80003f84:	6442                	ld	s0,16(sp)
    80003f86:	64a2                	ld	s1,8(sp)
    80003f88:	6902                	ld	s2,0(sp)
    80003f8a:	6105                	addi	sp,sp,32
    80003f8c:	8082                	ret

0000000080003f8e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003f8e:	1101                	addi	sp,sp,-32
    80003f90:	ec06                	sd	ra,24(sp)
    80003f92:	e822                	sd	s0,16(sp)
    80003f94:	e426                	sd	s1,8(sp)
    80003f96:	e04a                	sd	s2,0(sp)
    80003f98:	1000                	addi	s0,sp,32
    80003f9a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003f9c:	00850913          	addi	s2,a0,8
    80003fa0:	854a                	mv	a0,s2
    80003fa2:	c77fc0ef          	jal	80000c18 <acquire>
  while (lk->locked) {
    80003fa6:	409c                	lw	a5,0(s1)
    80003fa8:	c799                	beqz	a5,80003fb6 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003faa:	85ca                	mv	a1,s2
    80003fac:	8526                	mv	a0,s1
    80003fae:	f2bfd0ef          	jal	80001ed8 <sleep>
  while (lk->locked) {
    80003fb2:	409c                	lw	a5,0(s1)
    80003fb4:	fbfd                	bnez	a5,80003faa <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003fb6:	4785                	li	a5,1
    80003fb8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003fba:	925fd0ef          	jal	800018de <myproc>
    80003fbe:	591c                	lw	a5,48(a0)
    80003fc0:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003fc2:	854a                	mv	a0,s2
    80003fc4:	cd9fc0ef          	jal	80000c9c <release>
}
    80003fc8:	60e2                	ld	ra,24(sp)
    80003fca:	6442                	ld	s0,16(sp)
    80003fcc:	64a2                	ld	s1,8(sp)
    80003fce:	6902                	ld	s2,0(sp)
    80003fd0:	6105                	addi	sp,sp,32
    80003fd2:	8082                	ret

0000000080003fd4 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003fd4:	1101                	addi	sp,sp,-32
    80003fd6:	ec06                	sd	ra,24(sp)
    80003fd8:	e822                	sd	s0,16(sp)
    80003fda:	e426                	sd	s1,8(sp)
    80003fdc:	e04a                	sd	s2,0(sp)
    80003fde:	1000                	addi	s0,sp,32
    80003fe0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003fe2:	00850913          	addi	s2,a0,8
    80003fe6:	854a                	mv	a0,s2
    80003fe8:	c31fc0ef          	jal	80000c18 <acquire>
  lk->locked = 0;
    80003fec:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003ff0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	f2ffd0ef          	jal	80001f24 <wakeup>
  release(&lk->lk);
    80003ffa:	854a                	mv	a0,s2
    80003ffc:	ca1fc0ef          	jal	80000c9c <release>
}
    80004000:	60e2                	ld	ra,24(sp)
    80004002:	6442                	ld	s0,16(sp)
    80004004:	64a2                	ld	s1,8(sp)
    80004006:	6902                	ld	s2,0(sp)
    80004008:	6105                	addi	sp,sp,32
    8000400a:	8082                	ret

000000008000400c <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000400c:	7179                	addi	sp,sp,-48
    8000400e:	f406                	sd	ra,40(sp)
    80004010:	f022                	sd	s0,32(sp)
    80004012:	ec26                	sd	s1,24(sp)
    80004014:	e84a                	sd	s2,16(sp)
    80004016:	1800                	addi	s0,sp,48
    80004018:	84aa                	mv	s1,a0
  int r;

  acquire(&lk->lk);
    8000401a:	00850913          	addi	s2,a0,8
    8000401e:	854a                	mv	a0,s2
    80004020:	bf9fc0ef          	jal	80000c18 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80004024:	409c                	lw	a5,0(s1)
    80004026:	ef81                	bnez	a5,8000403e <holdingsleep+0x32>
    80004028:	4481                	li	s1,0
  release(&lk->lk);
    8000402a:	854a                	mv	a0,s2
    8000402c:	c71fc0ef          	jal	80000c9c <release>
  return r;
}
    80004030:	8526                	mv	a0,s1
    80004032:	70a2                	ld	ra,40(sp)
    80004034:	7402                	ld	s0,32(sp)
    80004036:	64e2                	ld	s1,24(sp)
    80004038:	6942                	ld	s2,16(sp)
    8000403a:	6145                	addi	sp,sp,48
    8000403c:	8082                	ret
    8000403e:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80004040:	0284a983          	lw	s3,40(s1)
    80004044:	89bfd0ef          	jal	800018de <myproc>
    80004048:	5904                	lw	s1,48(a0)
    8000404a:	413484b3          	sub	s1,s1,s3
    8000404e:	0014b493          	seqz	s1,s1
    80004052:	69a2                	ld	s3,8(sp)
    80004054:	bfd9                	j	8000402a <holdingsleep+0x1e>

0000000080004056 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80004056:	1141                	addi	sp,sp,-16
    80004058:	e406                	sd	ra,8(sp)
    8000405a:	e022                	sd	s0,0(sp)
    8000405c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000405e:	00003597          	auipc	a1,0x3
    80004062:	5f258593          	addi	a1,a1,1522 # 80007650 <etext+0x650>
    80004066:	0001c517          	auipc	a0,0x1c
    8000406a:	e0a50513          	addi	a0,a0,-502 # 8001fe70 <ftable>
    8000406e:	b2bfc0ef          	jal	80000b98 <initlock>
}
    80004072:	60a2                	ld	ra,8(sp)
    80004074:	6402                	ld	s0,0(sp)
    80004076:	0141                	addi	sp,sp,16
    80004078:	8082                	ret

000000008000407a <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    8000407a:	1101                	addi	sp,sp,-32
    8000407c:	ec06                	sd	ra,24(sp)
    8000407e:	e822                	sd	s0,16(sp)
    80004080:	e426                	sd	s1,8(sp)
    80004082:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80004084:	0001c517          	auipc	a0,0x1c
    80004088:	dec50513          	addi	a0,a0,-532 # 8001fe70 <ftable>
    8000408c:	b8dfc0ef          	jal	80000c18 <acquire>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    80004090:	0001c497          	auipc	s1,0x1c
    80004094:	df848493          	addi	s1,s1,-520 # 8001fe88 <ftable+0x18>
    80004098:	0001d717          	auipc	a4,0x1d
    8000409c:	d9070713          	addi	a4,a4,-624 # 80020e28 <disk>
    if (f->ref == 0) {
    800040a0:	40dc                	lw	a5,4(s1)
    800040a2:	cf89                	beqz	a5,800040bc <filealloc+0x42>
  for (f = ftable.file; f < ftable.file + NFILE; f++) {
    800040a4:	02848493          	addi	s1,s1,40
    800040a8:	fee49ce3          	bne	s1,a4,800040a0 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800040ac:	0001c517          	auipc	a0,0x1c
    800040b0:	dc450513          	addi	a0,a0,-572 # 8001fe70 <ftable>
    800040b4:	be9fc0ef          	jal	80000c9c <release>
  return 0;
    800040b8:	4481                	li	s1,0
    800040ba:	a809                	j	800040cc <filealloc+0x52>
      f->ref = 1;
    800040bc:	4785                	li	a5,1
    800040be:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800040c0:	0001c517          	auipc	a0,0x1c
    800040c4:	db050513          	addi	a0,a0,-592 # 8001fe70 <ftable>
    800040c8:	bd5fc0ef          	jal	80000c9c <release>
}
    800040cc:	8526                	mv	a0,s1
    800040ce:	60e2                	ld	ra,24(sp)
    800040d0:	6442                	ld	s0,16(sp)
    800040d2:	64a2                	ld	s1,8(sp)
    800040d4:	6105                	addi	sp,sp,32
    800040d6:	8082                	ret

00000000800040d8 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    800040d8:	1101                	addi	sp,sp,-32
    800040da:	ec06                	sd	ra,24(sp)
    800040dc:	e822                	sd	s0,16(sp)
    800040de:	e426                	sd	s1,8(sp)
    800040e0:	1000                	addi	s0,sp,32
    800040e2:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800040e4:	0001c517          	auipc	a0,0x1c
    800040e8:	d8c50513          	addi	a0,a0,-628 # 8001fe70 <ftable>
    800040ec:	b2dfc0ef          	jal	80000c18 <acquire>
  if (f->ref < 1)
    800040f0:	40dc                	lw	a5,4(s1)
    800040f2:	02f05063          	blez	a5,80004112 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800040f6:	2785                	addiw	a5,a5,1
    800040f8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800040fa:	0001c517          	auipc	a0,0x1c
    800040fe:	d7650513          	addi	a0,a0,-650 # 8001fe70 <ftable>
    80004102:	b9bfc0ef          	jal	80000c9c <release>
  return f;
}
    80004106:	8526                	mv	a0,s1
    80004108:	60e2                	ld	ra,24(sp)
    8000410a:	6442                	ld	s0,16(sp)
    8000410c:	64a2                	ld	s1,8(sp)
    8000410e:	6105                	addi	sp,sp,32
    80004110:	8082                	ret
    panic("filedup");
    80004112:	00003517          	auipc	a0,0x3
    80004116:	54650513          	addi	a0,a0,1350 # 80007658 <etext+0x658>
    8000411a:	f20fc0ef          	jal	8000083a <panic>

000000008000411e <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000411e:	7139                	addi	sp,sp,-64
    80004120:	fc06                	sd	ra,56(sp)
    80004122:	f822                	sd	s0,48(sp)
    80004124:	f426                	sd	s1,40(sp)
    80004126:	0080                	addi	s0,sp,64
    80004128:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    8000412a:	0001c517          	auipc	a0,0x1c
    8000412e:	d4650513          	addi	a0,a0,-698 # 8001fe70 <ftable>
    80004132:	ae7fc0ef          	jal	80000c18 <acquire>
  if (f->ref < 1)
    80004136:	40dc                	lw	a5,4(s1)
    80004138:	04f05a63          	blez	a5,8000418c <fileclose+0x6e>
    panic("fileclose");
  if (--f->ref > 0) {
    8000413c:	37fd                	addiw	a5,a5,-1
    8000413e:	c0dc                	sw	a5,4(s1)
    80004140:	06f04063          	bgtz	a5,800041a0 <fileclose+0x82>
    80004144:	f04a                	sd	s2,32(sp)
    80004146:	ec4e                	sd	s3,24(sp)
    80004148:	e852                	sd	s4,16(sp)
    8000414a:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    8000414c:	0004a903          	lw	s2,0(s1)
    80004150:	0094c783          	lbu	a5,9(s1)
    80004154:	89be                	mv	s3,a5
    80004156:	689c                	ld	a5,16(s1)
    80004158:	8a3e                	mv	s4,a5
    8000415a:	6c9c                	ld	a5,24(s1)
    8000415c:	8abe                	mv	s5,a5
  f->ref = 0;
    8000415e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80004162:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80004166:	0001c517          	auipc	a0,0x1c
    8000416a:	d0a50513          	addi	a0,a0,-758 # 8001fe70 <ftable>
    8000416e:	b2ffc0ef          	jal	80000c9c <release>

  if (ff.type == FD_PIPE) {
    80004172:	4785                	li	a5,1
    80004174:	04f90163          	beq	s2,a5,800041b6 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if (ff.type == FD_INODE || ff.type == FD_DEVICE) {
    80004178:	ffe9079b          	addiw	a5,s2,-2
    8000417c:	4705                	li	a4,1
    8000417e:	04f77563          	bgeu	a4,a5,800041c8 <fileclose+0xaa>
    80004182:	7902                	ld	s2,32(sp)
    80004184:	69e2                	ld	s3,24(sp)
    80004186:	6a42                	ld	s4,16(sp)
    80004188:	6aa2                	ld	s5,8(sp)
    8000418a:	a00d                	j	800041ac <fileclose+0x8e>
    8000418c:	f04a                	sd	s2,32(sp)
    8000418e:	ec4e                	sd	s3,24(sp)
    80004190:	e852                	sd	s4,16(sp)
    80004192:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80004194:	00003517          	auipc	a0,0x3
    80004198:	4cc50513          	addi	a0,a0,1228 # 80007660 <etext+0x660>
    8000419c:	e9efc0ef          	jal	8000083a <panic>
    release(&ftable.lock);
    800041a0:	0001c517          	auipc	a0,0x1c
    800041a4:	cd050513          	addi	a0,a0,-816 # 8001fe70 <ftable>
    800041a8:	af5fc0ef          	jal	80000c9c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800041ac:	70e2                	ld	ra,56(sp)
    800041ae:	7442                	ld	s0,48(sp)
    800041b0:	74a2                	ld	s1,40(sp)
    800041b2:	6121                	addi	sp,sp,64
    800041b4:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800041b6:	85ce                	mv	a1,s3
    800041b8:	8552                	mv	a0,s4
    800041ba:	332000ef          	jal	800044ec <pipeclose>
    800041be:	7902                	ld	s2,32(sp)
    800041c0:	69e2                	ld	s3,24(sp)
    800041c2:	6a42                	ld	s4,16(sp)
    800041c4:	6aa2                	ld	s5,8(sp)
    800041c6:	b7dd                	j	800041ac <fileclose+0x8e>
    begin_op();
    800041c8:	ad9ff0ef          	jal	80003ca0 <begin_op>
    iput(ff.ip);
    800041cc:	8556                	mv	a0,s5
    800041ce:	a3eff0ef          	jal	8000340c <iput>
    end_op();
    800041d2:	b3fff0ef          	jal	80003d10 <end_op>
    800041d6:	7902                	ld	s2,32(sp)
    800041d8:	69e2                	ld	s3,24(sp)
    800041da:	6a42                	ld	s4,16(sp)
    800041dc:	6aa2                	ld	s5,8(sp)
    800041de:	b7f9                	j	800041ac <fileclose+0x8e>

00000000800041e0 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800041e0:	715d                	addi	sp,sp,-80
    800041e2:	e486                	sd	ra,72(sp)
    800041e4:	e0a2                	sd	s0,64(sp)
    800041e6:	fc26                	sd	s1,56(sp)
    800041e8:	f052                	sd	s4,32(sp)
    800041ea:	0880                	addi	s0,sp,80
    800041ec:	84aa                	mv	s1,a0
    800041ee:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800041f0:	eeefd0ef          	jal	800018de <myproc>
  struct stat st;

  if (f->type == FD_INODE || f->type == FD_DEVICE) {
    800041f4:	409c                	lw	a5,0(s1)
    800041f6:	37f9                	addiw	a5,a5,-2
    800041f8:	4705                	li	a4,1
    800041fa:	04f76263          	bltu	a4,a5,8000423e <filestat+0x5e>
    800041fe:	f84a                	sd	s2,48(sp)
    80004200:	f44e                	sd	s3,40(sp)
    80004202:	89aa                	mv	s3,a0
    ilock(f->ip);
    80004204:	6c88                	ld	a0,24(s1)
    80004206:	884ff0ef          	jal	8000328a <ilock>
    stati(f->ip, &st);
    8000420a:	fb840913          	addi	s2,s0,-72
    8000420e:	85ca                	mv	a1,s2
    80004210:	6c88                	ld	a0,24(s1)
    80004212:	bdcff0ef          	jal	800035ee <stati>
    iunlock(f->ip);
    80004216:	6c88                	ld	a0,24(s1)
    80004218:	920ff0ef          	jal	80003338 <iunlock>
    if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000421c:	46e1                	li	a3,24
    8000421e:	864a                	mv	a2,s2
    80004220:	85d2                	mv	a1,s4
    80004222:	0509b503          	ld	a0,80(s3)
    80004226:	beafd0ef          	jal	80001610 <copyout>
    8000422a:	41f5551b          	sraiw	a0,a0,0x1f
    8000422e:	7942                	ld	s2,48(sp)
    80004230:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80004232:	60a6                	ld	ra,72(sp)
    80004234:	6406                	ld	s0,64(sp)
    80004236:	74e2                	ld	s1,56(sp)
    80004238:	7a02                	ld	s4,32(sp)
    8000423a:	6161                	addi	sp,sp,80
    8000423c:	8082                	ret
  return -1;
    8000423e:	557d                	li	a0,-1
    80004240:	bfcd                	j	80004232 <filestat+0x52>

0000000080004242 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80004242:	7179                	addi	sp,sp,-48
    80004244:	f406                	sd	ra,40(sp)
    80004246:	f022                	sd	s0,32(sp)
    80004248:	e84a                	sd	s2,16(sp)
    8000424a:	1800                	addi	s0,sp,48
  int r = 0;

  if (f->readable == 0)
    8000424c:	00854783          	lbu	a5,8(a0)
    80004250:	c3c5                	beqz	a5,800042f0 <fileread+0xae>
    80004252:	ec26                	sd	s1,24(sp)
    80004254:	e44e                	sd	s3,8(sp)
    80004256:	84aa                	mv	s1,a0
    80004258:	892e                	mv	s2,a1
    8000425a:	89b2                	mv	s3,a2
    return -1;

  if (f->type == FD_PIPE) {
    8000425c:	411c                	lw	a5,0(a0)
    8000425e:	4705                	li	a4,1
    80004260:	04e78363          	beq	a5,a4,800042a6 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004264:	470d                	li	a4,3
    80004266:	04e78763          	beq	a5,a4,800042b4 <fileread+0x72>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if (f->type == FD_INODE) {
    8000426a:	4709                	li	a4,2
    8000426c:	06e79a63          	bne	a5,a4,800042e0 <fileread+0x9e>
    ilock(f->ip);
    80004270:	6d08                	ld	a0,24(a0)
    80004272:	818ff0ef          	jal	8000328a <ilock>
    if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80004276:	874e                	mv	a4,s3
    80004278:	5094                	lw	a3,32(s1)
    8000427a:	864a                	mv	a2,s2
    8000427c:	4585                	li	a1,1
    8000427e:	6c88                	ld	a0,24(s1)
    80004280:	b9cff0ef          	jal	8000361c <readi>
    80004284:	892a                	mv	s2,a0
    80004286:	00a05563          	blez	a0,80004290 <fileread+0x4e>
      f->off += r;
    8000428a:	509c                	lw	a5,32(s1)
    8000428c:	9fa9                	addw	a5,a5,a0
    8000428e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80004290:	6c88                	ld	a0,24(s1)
    80004292:	8a6ff0ef          	jal	80003338 <iunlock>
    80004296:	64e2                	ld	s1,24(sp)
    80004298:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000429a:	854a                	mv	a0,s2
    8000429c:	70a2                	ld	ra,40(sp)
    8000429e:	7402                	ld	s0,32(sp)
    800042a0:	6942                	ld	s2,16(sp)
    800042a2:	6145                	addi	sp,sp,48
    800042a4:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800042a6:	6908                	ld	a0,16(a0)
    800042a8:	39a000ef          	jal	80004642 <piperead>
    800042ac:	892a                	mv	s2,a0
    800042ae:	64e2                	ld	s1,24(sp)
    800042b0:	69a2                	ld	s3,8(sp)
    800042b2:	b7e5                	j	8000429a <fileread+0x58>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800042b4:	02451783          	lh	a5,36(a0)
    800042b8:	03079693          	slli	a3,a5,0x30
    800042bc:	92c1                	srli	a3,a3,0x30
    800042be:	4725                	li	a4,9
    800042c0:	02d76663          	bltu	a4,a3,800042ec <fileread+0xaa>
    800042c4:	0792                	slli	a5,a5,0x4
    800042c6:	0001c717          	auipc	a4,0x1c
    800042ca:	b0a70713          	addi	a4,a4,-1270 # 8001fdd0 <devsw>
    800042ce:	97ba                	add	a5,a5,a4
    800042d0:	639c                	ld	a5,0(a5)
    800042d2:	c395                	beqz	a5,800042f6 <fileread+0xb4>
    r = devsw[f->major].read(1, addr, n);
    800042d4:	4505                	li	a0,1
    800042d6:	9782                	jalr	a5
    800042d8:	892a                	mv	s2,a0
    800042da:	64e2                	ld	s1,24(sp)
    800042dc:	69a2                	ld	s3,8(sp)
    800042de:	bf75                	j	8000429a <fileread+0x58>
    panic("fileread");
    800042e0:	00003517          	auipc	a0,0x3
    800042e4:	39050513          	addi	a0,a0,912 # 80007670 <etext+0x670>
    800042e8:	d52fc0ef          	jal	8000083a <panic>
    800042ec:	64e2                	ld	s1,24(sp)
    800042ee:	69a2                	ld	s3,8(sp)
    return -1;
    800042f0:	57fd                	li	a5,-1
    800042f2:	893e                	mv	s2,a5
    800042f4:	b75d                	j	8000429a <fileread+0x58>
    800042f6:	64e2                	ld	s1,24(sp)
    800042f8:	69a2                	ld	s3,8(sp)
    800042fa:	bfdd                	j	800042f0 <fileread+0xae>

00000000800042fc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if (f->writable == 0)
    800042fc:	00954783          	lbu	a5,9(a0)
    80004300:	12078463          	beqz	a5,80004428 <filewrite+0x12c>
{
    80004304:	711d                	addi	sp,sp,-96
    80004306:	ec86                	sd	ra,88(sp)
    80004308:	e8a2                	sd	s0,80(sp)
    8000430a:	e0ca                	sd	s2,64(sp)
    8000430c:	f456                	sd	s5,40(sp)
    8000430e:	f05a                	sd	s6,32(sp)
    80004310:	1080                	addi	s0,sp,96
    80004312:	892a                	mv	s2,a0
    80004314:	8b2e                	mv	s6,a1
    80004316:	8ab2                	mv	s5,a2
    return -1;

  if (f->type == FD_PIPE) {
    80004318:	411c                	lw	a5,0(a0)
    8000431a:	4705                	li	a4,1
    8000431c:	02e78a63          	beq	a5,a4,80004350 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if (f->type == FD_DEVICE) {
    80004320:	470d                	li	a4,3
    80004322:	02e78b63          	beq	a5,a4,80004358 <filewrite+0x5c>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if (f->type == FD_INODE) {
    80004326:	4709                	li	a4,2
    80004328:	0ce79f63          	bne	a5,a4,80004406 <filewrite+0x10a>
    8000432c:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
    int i = 0;
    while (i < n) {
    8000432e:	0ac05a63          	blez	a2,800043e2 <filewrite+0xe6>
    80004332:	e4a6                	sd	s1,72(sp)
    80004334:	fc4e                	sd	s3,56(sp)
    80004336:	ec5e                	sd	s7,24(sp)
    80004338:	e862                	sd	s8,16(sp)
    8000433a:	e466                	sd	s9,8(sp)
    int i = 0;
    8000433c:	4a01                	li	s4,0
      int n1 = n - i;
      if (n1 > max)
    8000433e:	6b85                	lui	s7,0x1
    80004340:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80004344:	6785                	lui	a5,0x1
    80004346:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000434a:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000434c:	4c05                	li	s8,1
    8000434e:	a8ad                	j	800043c8 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80004350:	6908                	ld	a0,16(a0)
    80004352:	1f8000ef          	jal	8000454a <pipewrite>
    80004356:	a04d                	j	800043f8 <filewrite+0xfc>
    if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80004358:	02451783          	lh	a5,36(a0)
    8000435c:	03079693          	slli	a3,a5,0x30
    80004360:	92c1                	srli	a3,a3,0x30
    80004362:	4725                	li	a4,9
    80004364:	0ad76d63          	bltu	a4,a3,8000441e <filewrite+0x122>
    80004368:	0792                	slli	a5,a5,0x4
    8000436a:	0001c717          	auipc	a4,0x1c
    8000436e:	a6670713          	addi	a4,a4,-1434 # 8001fdd0 <devsw>
    80004372:	97ba                	add	a5,a5,a4
    80004374:	679c                	ld	a5,8(a5)
    80004376:	c7c5                	beqz	a5,8000441e <filewrite+0x122>
    ret = devsw[f->major].write(1, addr, n);
    80004378:	4505                	li	a0,1
    8000437a:	9782                	jalr	a5
    8000437c:	a8b5                	j	800043f8 <filewrite+0xfc>
      if (n1 > max)
    8000437e:	2981                	sext.w	s3,s3
      begin_op();
    80004380:	921ff0ef          	jal	80003ca0 <begin_op>
      ilock(f->ip);
    80004384:	01893503          	ld	a0,24(s2)
    80004388:	f03fe0ef          	jal	8000328a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000438c:	874e                	mv	a4,s3
    8000438e:	02092683          	lw	a3,32(s2)
    80004392:	016a0633          	add	a2,s4,s6
    80004396:	85e2                	mv	a1,s8
    80004398:	01893503          	ld	a0,24(s2)
    8000439c:	b72ff0ef          	jal	8000370e <writei>
    800043a0:	84aa                	mv	s1,a0
    800043a2:	00a05763          	blez	a0,800043b0 <filewrite+0xb4>
        f->off += r;
    800043a6:	02092783          	lw	a5,32(s2)
    800043aa:	9fa9                	addw	a5,a5,a0
    800043ac:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800043b0:	01893503          	ld	a0,24(s2)
    800043b4:	f85fe0ef          	jal	80003338 <iunlock>
      end_op();
    800043b8:	959ff0ef          	jal	80003d10 <end_op>

      if (r != n1) {
    800043bc:	02999563          	bne	s3,s1,800043e6 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800043c0:	01448a3b          	addw	s4,s1,s4
    while (i < n) {
    800043c4:	015a5963          	bge	s4,s5,800043d6 <filewrite+0xda>
      int n1 = n - i;
    800043c8:	414a87bb          	subw	a5,s5,s4
    800043cc:	89be                	mv	s3,a5
      if (n1 > max)
    800043ce:	fafbd8e3          	bge	s7,a5,8000437e <filewrite+0x82>
    800043d2:	89e6                	mv	s3,s9
    800043d4:	b76d                	j	8000437e <filewrite+0x82>
    800043d6:	64a6                	ld	s1,72(sp)
    800043d8:	79e2                	ld	s3,56(sp)
    800043da:	6be2                	ld	s7,24(sp)
    800043dc:	6c42                	ld	s8,16(sp)
    800043de:	6ca2                	ld	s9,8(sp)
    800043e0:	a801                	j	800043f0 <filewrite+0xf4>
    int i = 0;
    800043e2:	4a01                	li	s4,0
    800043e4:	a031                	j	800043f0 <filewrite+0xf4>
    800043e6:	64a6                	ld	s1,72(sp)
    800043e8:	79e2                	ld	s3,56(sp)
    800043ea:	6be2                	ld	s7,24(sp)
    800043ec:	6c42                	ld	s8,16(sp)
    800043ee:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800043f0:	034a9963          	bne	s5,s4,80004422 <filewrite+0x126>
    800043f4:	8556                	mv	a0,s5
    800043f6:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800043f8:	60e6                	ld	ra,88(sp)
    800043fa:	6446                	ld	s0,80(sp)
    800043fc:	6906                	ld	s2,64(sp)
    800043fe:	7aa2                	ld	s5,40(sp)
    80004400:	7b02                	ld	s6,32(sp)
    80004402:	6125                	addi	sp,sp,96
    80004404:	8082                	ret
    80004406:	e4a6                	sd	s1,72(sp)
    80004408:	fc4e                	sd	s3,56(sp)
    8000440a:	f852                	sd	s4,48(sp)
    8000440c:	ec5e                	sd	s7,24(sp)
    8000440e:	e862                	sd	s8,16(sp)
    80004410:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80004412:	00003517          	auipc	a0,0x3
    80004416:	26e50513          	addi	a0,a0,622 # 80007680 <etext+0x680>
    8000441a:	c20fc0ef          	jal	8000083a <panic>
    return -1;
    8000441e:	557d                	li	a0,-1
    80004420:	bfe1                	j	800043f8 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80004422:	557d                	li	a0,-1
    80004424:	7a42                	ld	s4,48(sp)
    80004426:	bfc9                	j	800043f8 <filewrite+0xfc>
    return -1;
    80004428:	557d                	li	a0,-1
}
    8000442a:	8082                	ret

000000008000442c <pipealloc>:
  int writeopen; // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    8000442c:	7179                	addi	sp,sp,-48
    8000442e:	f406                	sd	ra,40(sp)
    80004430:	f022                	sd	s0,32(sp)
    80004432:	ec26                	sd	s1,24(sp)
    80004434:	e052                	sd	s4,0(sp)
    80004436:	1800                	addi	s0,sp,48
    80004438:	84aa                	mv	s1,a0
    8000443a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    8000443c:	0005b023          	sd	zero,0(a1)
    80004440:	00053023          	sd	zero,0(a0)
  if ((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80004444:	c37ff0ef          	jal	8000407a <filealloc>
    80004448:	e088                	sd	a0,0(s1)
    8000444a:	c549                	beqz	a0,800044d4 <pipealloc+0xa8>
    8000444c:	c2fff0ef          	jal	8000407a <filealloc>
    80004450:	00aa3023          	sd	a0,0(s4)
    80004454:	cd25                	beqz	a0,800044cc <pipealloc+0xa0>
    80004456:	e84a                	sd	s2,16(sp)
    goto bad;
  if ((pi = (struct pipe *)kalloc()) == 0)
    80004458:	ee6fc0ef          	jal	80000b3e <kalloc>
    8000445c:	892a                	mv	s2,a0
    8000445e:	c12d                	beqz	a0,800044c0 <pipealloc+0x94>
    80004460:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80004462:	4985                	li	s3,1
    80004464:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80004468:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000446c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80004470:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80004474:	00003597          	auipc	a1,0x3
    80004478:	f4458593          	addi	a1,a1,-188 # 800073b8 <etext+0x3b8>
    8000447c:	f1cfc0ef          	jal	80000b98 <initlock>
  (*f0)->type = FD_PIPE;
    80004480:	609c                	ld	a5,0(s1)
    80004482:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80004486:	609c                	ld	a5,0(s1)
    80004488:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000448c:	609c                	ld	a5,0(s1)
    8000448e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80004492:	609c                	ld	a5,0(s1)
    80004494:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80004498:	000a3783          	ld	a5,0(s4)
    8000449c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800044a0:	000a3783          	ld	a5,0(s4)
    800044a4:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800044a8:	000a3783          	ld	a5,0(s4)
    800044ac:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800044b0:	000a3783          	ld	a5,0(s4)
    800044b4:	0127b823          	sd	s2,16(a5)
  return 0;
    800044b8:	4501                	li	a0,0
    800044ba:	6942                	ld	s2,16(sp)
    800044bc:	69a2                	ld	s3,8(sp)
    800044be:	a00d                	j	800044e0 <pipealloc+0xb4>

bad:
  if (pi)
    kfree((char *)pi);
  if (*f0)
    800044c0:	6088                	ld	a0,0(s1)
    800044c2:	c119                	beqz	a0,800044c8 <pipealloc+0x9c>
    800044c4:	6942                	ld	s2,16(sp)
    800044c6:	a029                	j	800044d0 <pipealloc+0xa4>
    800044c8:	6942                	ld	s2,16(sp)
    800044ca:	a029                	j	800044d4 <pipealloc+0xa8>
    800044cc:	6088                	ld	a0,0(s1)
    800044ce:	c901                	beqz	a0,800044de <pipealloc+0xb2>
    fileclose(*f0);
    800044d0:	c4fff0ef          	jal	8000411e <fileclose>
  if (*f1)
    800044d4:	000a3503          	ld	a0,0(s4)
    800044d8:	c119                	beqz	a0,800044de <pipealloc+0xb2>
    fileclose(*f1);
    800044da:	c45ff0ef          	jal	8000411e <fileclose>
  return -1;
    800044de:	557d                	li	a0,-1
}
    800044e0:	70a2                	ld	ra,40(sp)
    800044e2:	7402                	ld	s0,32(sp)
    800044e4:	64e2                	ld	s1,24(sp)
    800044e6:	6a02                	ld	s4,0(sp)
    800044e8:	6145                	addi	sp,sp,48
    800044ea:	8082                	ret

00000000800044ec <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800044ec:	1101                	addi	sp,sp,-32
    800044ee:	ec06                	sd	ra,24(sp)
    800044f0:	e822                	sd	s0,16(sp)
    800044f2:	e426                	sd	s1,8(sp)
    800044f4:	e04a                	sd	s2,0(sp)
    800044f6:	1000                	addi	s0,sp,32
    800044f8:	84aa                	mv	s1,a0
    800044fa:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800044fc:	f1cfc0ef          	jal	80000c18 <acquire>
  if (writable) {
    80004500:	02090763          	beqz	s2,8000452e <pipeclose+0x42>
    pi->writeopen = 0;
    80004504:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80004508:	21848513          	addi	a0,s1,536
    8000450c:	a19fd0ef          	jal	80001f24 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if (pi->readopen == 0 && pi->writeopen == 0) {
    80004510:	2204a783          	lw	a5,544(s1)
    80004514:	e781                	bnez	a5,8000451c <pipeclose+0x30>
    80004516:	2244a783          	lw	a5,548(s1)
    8000451a:	c38d                	beqz	a5,8000453c <pipeclose+0x50>
    release(&pi->lock);
    kfree((char *)pi);
  } else
    release(&pi->lock);
    8000451c:	8526                	mv	a0,s1
    8000451e:	f7efc0ef          	jal	80000c9c <release>
}
    80004522:	60e2                	ld	ra,24(sp)
    80004524:	6442                	ld	s0,16(sp)
    80004526:	64a2                	ld	s1,8(sp)
    80004528:	6902                	ld	s2,0(sp)
    8000452a:	6105                	addi	sp,sp,32
    8000452c:	8082                	ret
    pi->readopen = 0;
    8000452e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80004532:	21c48513          	addi	a0,s1,540
    80004536:	9effd0ef          	jal	80001f24 <wakeup>
    8000453a:	bfd9                	j	80004510 <pipeclose+0x24>
    release(&pi->lock);
    8000453c:	8526                	mv	a0,s1
    8000453e:	f5efc0ef          	jal	80000c9c <release>
    kfree((char *)pi);
    80004542:	8526                	mv	a0,s1
    80004544:	d12fc0ef          	jal	80000a56 <kfree>
    80004548:	bfe9                	j	80004522 <pipeclose+0x36>

000000008000454a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000454a:	7159                	addi	sp,sp,-112
    8000454c:	f486                	sd	ra,104(sp)
    8000454e:	f0a2                	sd	s0,96(sp)
    80004550:	eca6                	sd	s1,88(sp)
    80004552:	e8ca                	sd	s2,80(sp)
    80004554:	e4ce                	sd	s3,72(sp)
    80004556:	e0d2                	sd	s4,64(sp)
    80004558:	fc56                	sd	s5,56(sp)
    8000455a:	1880                	addi	s0,sp,112
    8000455c:	84aa                	mv	s1,a0
    8000455e:	8aae                	mv	s5,a1
    80004560:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80004562:	b7cfd0ef          	jal	800018de <myproc>
    80004566:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80004568:	8526                	mv	a0,s1
    8000456a:	eaefc0ef          	jal	80000c18 <acquire>
  while (i < n) {
    8000456e:	0d405263          	blez	s4,80004632 <pipewrite+0xe8>
    80004572:	f85a                	sd	s6,48(sp)
    80004574:	f45e                	sd	s7,40(sp)
    80004576:	f062                	sd	s8,32(sp)
    80004578:	ec66                	sd	s9,24(sp)
    8000457a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000457c:	4901                	li	s2,0
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000457e:	f9f40c13          	addi	s8,s0,-97
    80004582:	4b85                	li	s7,1
    80004584:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004586:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000458a:	21c48c93          	addi	s9,s1,540
    8000458e:	a82d                	j	800045c8 <pipewrite+0x7e>
      release(&pi->lock);
    80004590:	8526                	mv	a0,s1
    80004592:	f0afc0ef          	jal	80000c9c <release>
      return -1;
    80004596:	597d                	li	s2,-1
    80004598:	7b42                	ld	s6,48(sp)
    8000459a:	7ba2                	ld	s7,40(sp)
    8000459c:	7c02                	ld	s8,32(sp)
    8000459e:	6ce2                	ld	s9,24(sp)
    800045a0:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800045a2:	854a                	mv	a0,s2
    800045a4:	70a6                	ld	ra,104(sp)
    800045a6:	7406                	ld	s0,96(sp)
    800045a8:	64e6                	ld	s1,88(sp)
    800045aa:	6946                	ld	s2,80(sp)
    800045ac:	69a6                	ld	s3,72(sp)
    800045ae:	6a06                	ld	s4,64(sp)
    800045b0:	7ae2                	ld	s5,56(sp)
    800045b2:	6165                	addi	sp,sp,112
    800045b4:	8082                	ret
      wakeup(&pi->nread);
    800045b6:	856a                	mv	a0,s10
    800045b8:	96dfd0ef          	jal	80001f24 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800045bc:	85a6                	mv	a1,s1
    800045be:	8566                	mv	a0,s9
    800045c0:	919fd0ef          	jal	80001ed8 <sleep>
  while (i < n) {
    800045c4:	05495a63          	bge	s2,s4,80004618 <pipewrite+0xce>
    if (pi->readopen == 0 || killed(pr)) {
    800045c8:	2204a783          	lw	a5,544(s1)
    800045cc:	d3f1                	beqz	a5,80004590 <pipewrite+0x46>
    800045ce:	854e                	mv	a0,s3
    800045d0:	b45fd0ef          	jal	80002114 <killed>
    800045d4:	fd55                	bnez	a0,80004590 <pipewrite+0x46>
    if (pi->nwrite == pi->nread + PIPESIZE) { //DOC: pipewrite-full
    800045d6:	2184a783          	lw	a5,536(s1)
    800045da:	21c4a703          	lw	a4,540(s1)
    800045de:	2007879b          	addiw	a5,a5,512
    800045e2:	fcf70ae3          	beq	a4,a5,800045b6 <pipewrite+0x6c>
      if (copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800045e6:	86de                	mv	a3,s7
    800045e8:	01590633          	add	a2,s2,s5
    800045ec:	85e2                	mv	a1,s8
    800045ee:	0509b503          	ld	a0,80(s3)
    800045f2:	8d6fd0ef          	jal	800016c8 <copyin>
    800045f6:	05650063          	beq	a0,s6,80004636 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800045fa:	21c4a783          	lw	a5,540(s1)
    800045fe:	0017871b          	addiw	a4,a5,1
    80004602:	20e4ae23          	sw	a4,540(s1)
    80004606:	1ff7f793          	andi	a5,a5,511
    8000460a:	97a6                	add	a5,a5,s1
    8000460c:	f9f44703          	lbu	a4,-97(s0)
    80004610:	00e78c23          	sb	a4,24(a5)
      i++;
    80004614:	2905                	addiw	s2,s2,1
    80004616:	b77d                	j	800045c4 <pipewrite+0x7a>
    80004618:	7b42                	ld	s6,48(sp)
    8000461a:	7ba2                	ld	s7,40(sp)
    8000461c:	7c02                	ld	s8,32(sp)
    8000461e:	6ce2                	ld	s9,24(sp)
    80004620:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80004622:	21848513          	addi	a0,s1,536
    80004626:	8fffd0ef          	jal	80001f24 <wakeup>
  release(&pi->lock);
    8000462a:	8526                	mv	a0,s1
    8000462c:	e70fc0ef          	jal	80000c9c <release>
  return i;
    80004630:	bf8d                	j	800045a2 <pipewrite+0x58>
  int i = 0;
    80004632:	4901                	li	s2,0
    80004634:	b7fd                	j	80004622 <pipewrite+0xd8>
    80004636:	7b42                	ld	s6,48(sp)
    80004638:	7ba2                	ld	s7,40(sp)
    8000463a:	7c02                	ld	s8,32(sp)
    8000463c:	6ce2                	ld	s9,24(sp)
    8000463e:	6d42                	ld	s10,16(sp)
    80004640:	b7cd                	j	80004622 <pipewrite+0xd8>

0000000080004642 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004642:	711d                	addi	sp,sp,-96
    80004644:	ec86                	sd	ra,88(sp)
    80004646:	e8a2                	sd	s0,80(sp)
    80004648:	e4a6                	sd	s1,72(sp)
    8000464a:	e0ca                	sd	s2,64(sp)
    8000464c:	fc4e                	sd	s3,56(sp)
    8000464e:	f852                	sd	s4,48(sp)
    80004650:	f456                	sd	s5,40(sp)
    80004652:	1080                	addi	s0,sp,96
    80004654:	84aa                	mv	s1,a0
    80004656:	892e                	mv	s2,a1
    80004658:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000465a:	a84fd0ef          	jal	800018de <myproc>
    8000465e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004660:	8526                	mv	a0,s1
    80004662:	db6fc0ef          	jal	80000c18 <acquire>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004666:	2184a703          	lw	a4,536(s1)
    8000466a:	21c4a783          	lw	a5,540(s1)
    if (killed(pr)) {
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000466e:	21848993          	addi	s3,s1,536
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    80004672:	02f71363          	bne	a4,a5,80004698 <piperead+0x56>
    80004676:	2244a783          	lw	a5,548(s1)
    8000467a:	cf99                	beqz	a5,80004698 <piperead+0x56>
    if (killed(pr)) {
    8000467c:	8552                	mv	a0,s4
    8000467e:	a97fd0ef          	jal	80002114 <killed>
    80004682:	e925                	bnez	a0,800046f2 <piperead+0xb0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004684:	85a6                	mv	a1,s1
    80004686:	854e                	mv	a0,s3
    80004688:	851fd0ef          	jal	80001ed8 <sleep>
  while (pi->nread == pi->nwrite && pi->writeopen) { //DOC: pipe-empty
    8000468c:	2184a703          	lw	a4,536(s1)
    80004690:	21c4a783          	lw	a5,540(s1)
    80004694:	fef701e3          	beq	a4,a5,80004676 <piperead+0x34>
  }
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004698:	07505863          	blez	s5,80004708 <piperead+0xc6>
    8000469c:	f05a                	sd	s6,32(sp)
    8000469e:	ec5e                	sd	s7,24(sp)
    800046a0:	e862                	sd	s8,16(sp)
    800046a2:	4981                	li	s3,0
    if (pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread % PIPESIZE];
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800046a4:	faf40c13          	addi	s8,s0,-81
    800046a8:	4b85                	li	s7,1
    800046aa:	5b7d                	li	s6,-1
    if (pi->nread == pi->nwrite)
    800046ac:	2184a783          	lw	a5,536(s1)
    800046b0:	21c4a703          	lw	a4,540(s1)
    800046b4:	06f70163          	beq	a4,a5,80004716 <piperead+0xd4>
    ch = pi->data[pi->nread % PIPESIZE];
    800046b8:	1ff7f793          	andi	a5,a5,511
    800046bc:	97a6                	add	a5,a5,s1
    800046be:	0187c783          	lbu	a5,24(a5)
    800046c2:	faf407a3          	sb	a5,-81(s0)
    if (copyout(pr->pagetable, addr + i, &ch, 1) == -1) {
    800046c6:	86de                	mv	a3,s7
    800046c8:	8662                	mv	a2,s8
    800046ca:	85ca                	mv	a1,s2
    800046cc:	050a3503          	ld	a0,80(s4)
    800046d0:	f41fc0ef          	jal	80001610 <copyout>
    800046d4:	03650463          	beq	a0,s6,800046fc <piperead+0xba>
      if (i == 0)
        i = -1;
      break;
    }
    pi->nread++;
    800046d8:	2184a783          	lw	a5,536(s1)
    800046dc:	2785                	addiw	a5,a5,1
    800046de:	20f4ac23          	sw	a5,536(s1)
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    800046e2:	2985                	addiw	s3,s3,1
    800046e4:	0905                	addi	s2,s2,1
    800046e6:	fd3a93e3          	bne	s5,s3,800046ac <piperead+0x6a>
    800046ea:	7b02                	ld	s6,32(sp)
    800046ec:	6be2                	ld	s7,24(sp)
    800046ee:	6c42                	ld	s8,16(sp)
    800046f0:	a035                	j	8000471c <piperead+0xda>
      release(&pi->lock);
    800046f2:	8526                	mv	a0,s1
    800046f4:	da8fc0ef          	jal	80000c9c <release>
      return -1;
    800046f8:	59fd                	li	s3,-1
    800046fa:	a805                	j	8000472a <piperead+0xe8>
      if (i == 0)
    800046fc:	00098863          	beqz	s3,8000470c <piperead+0xca>
    80004700:	7b02                	ld	s6,32(sp)
    80004702:	6be2                	ld	s7,24(sp)
    80004704:	6c42                	ld	s8,16(sp)
    80004706:	a819                	j	8000471c <piperead+0xda>
  for (i = 0; i < n; i++) { //DOC: piperead-copy
    80004708:	4981                	li	s3,0
    8000470a:	a809                	j	8000471c <piperead+0xda>
        i = -1;
    8000470c:	89aa                	mv	s3,a0
    8000470e:	7b02                	ld	s6,32(sp)
    80004710:	6be2                	ld	s7,24(sp)
    80004712:	6c42                	ld	s8,16(sp)
    80004714:	a021                	j	8000471c <piperead+0xda>
    80004716:	7b02                	ld	s6,32(sp)
    80004718:	6be2                	ld	s7,24(sp)
    8000471a:	6c42                	ld	s8,16(sp)
  }
  wakeup(&pi->nwrite); //DOC: piperead-wakeup
    8000471c:	21c48513          	addi	a0,s1,540
    80004720:	805fd0ef          	jal	80001f24 <wakeup>
  release(&pi->lock);
    80004724:	8526                	mv	a0,s1
    80004726:	d76fc0ef          	jal	80000c9c <release>
  return i;
}
    8000472a:	854e                	mv	a0,s3
    8000472c:	60e6                	ld	ra,88(sp)
    8000472e:	6446                	ld	s0,80(sp)
    80004730:	64a6                	ld	s1,72(sp)
    80004732:	6906                	ld	s2,64(sp)
    80004734:	79e2                	ld	s3,56(sp)
    80004736:	7a42                	ld	s4,48(sp)
    80004738:	7aa2                	ld	s5,40(sp)
    8000473a:	6125                	addi	sp,sp,96
    8000473c:	8082                	ret

000000008000473e <flags2perm>:
static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int
flags2perm(int flags)
{
    8000473e:	1141                	addi	sp,sp,-16
    80004740:	e406                	sd	ra,8(sp)
    80004742:	e022                	sd	s0,0(sp)
    80004744:	0800                	addi	s0,sp,16
    80004746:	87aa                	mv	a5,a0
  int perm = 0;
  if (flags & 0x1)
    80004748:	0035151b          	slliw	a0,a0,0x3
    8000474c:	8921                	andi	a0,a0,8
    perm = PTE_X;
  if (flags & 0x2)
    8000474e:	8b89                	andi	a5,a5,2
    80004750:	c399                	beqz	a5,80004756 <flags2perm+0x18>
    perm |= PTE_W;
    80004752:	00456513          	ori	a0,a0,4
  return perm;
}
    80004756:	60a2                	ld	ra,8(sp)
    80004758:	6402                	ld	s0,0(sp)
    8000475a:	0141                	addi	sp,sp,16
    8000475c:	8082                	ret

000000008000475e <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    8000475e:	df010113          	addi	sp,sp,-528
    80004762:	20113423          	sd	ra,520(sp)
    80004766:	20813023          	sd	s0,512(sp)
    8000476a:	ffa6                	sd	s1,504(sp)
    8000476c:	fbca                	sd	s2,496(sp)
    8000476e:	0c00                	addi	s0,sp,528
    80004770:	892a                	mv	s2,a0
    80004772:	e0a43023          	sd	a0,-512(s0)
    80004776:	deb43c23          	sd	a1,-520(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    8000477a:	964fd0ef          	jal	800018de <myproc>
    8000477e:	84aa                	mv	s1,a0

  begin_op();
    80004780:	d20ff0ef          	jal	80003ca0 <begin_op>

  // Open the executable file.
  if ((ip = namei(path)) == 0) {
    80004784:	854a                	mv	a0,s2
    80004786:	b3cff0ef          	jal	80003ac2 <namei>
    8000478a:	c931                	beqz	a0,800047de <kexec+0x80>
    8000478c:	f3d2                	sd	s4,480(sp)
    8000478e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004790:	afbfe0ef          	jal	8000328a <ilock>

  // Read the ELF header.
  if (readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004794:	04000713          	li	a4,64
    80004798:	4681                	li	a3,0
    8000479a:	e5040613          	addi	a2,s0,-432
    8000479e:	4581                	li	a1,0
    800047a0:	8552                	mv	a0,s4
    800047a2:	e7bfe0ef          	jal	8000361c <readi>
    800047a6:	04000793          	li	a5,64
    800047aa:	00f51a63          	bne	a0,a5,800047be <kexec+0x60>
    goto bad;

  // Is this really an ELF file?
  if (elf.magic != ELF_MAGIC)
    800047ae:	e5042703          	lw	a4,-432(s0)
    800047b2:	464c47b7          	lui	a5,0x464c4
    800047b6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800047ba:	02f70563          	beq	a4,a5,800047e4 <kexec+0x86>

bad:
  if (pagetable)
    proc_freepagetable(pagetable, sz);
  if (ip) {
    iunlockput(ip);
    800047be:	8552                	mv	a0,s4
    800047c0:	cd7fe0ef          	jal	80003496 <iunlockput>
    end_op();
    800047c4:	d4cff0ef          	jal	80003d10 <end_op>
    800047c8:	7a1e                	ld	s4,480(sp)
    return -1;
    800047ca:	557d                	li	a0,-1
  }
  return -1;
}
    800047cc:	20813083          	ld	ra,520(sp)
    800047d0:	20013403          	ld	s0,512(sp)
    800047d4:	74fe                	ld	s1,504(sp)
    800047d6:	795e                	ld	s2,496(sp)
    800047d8:	21010113          	addi	sp,sp,528
    800047dc:	8082                	ret
    end_op();
    800047de:	d32ff0ef          	jal	80003d10 <end_op>
    return -1;
    800047e2:	b7e5                	j	800047ca <kexec+0x6c>
    800047e4:	ebda                	sd	s6,464(sp)
  if ((pagetable = proc_pagetable(p)) == 0)
    800047e6:	8526                	mv	a0,s1
    800047e8:	a00fd0ef          	jal	800019e8 <proc_pagetable>
    800047ec:	8b2a                	mv	s6,a0
    800047ee:	26050063          	beqz	a0,80004a4e <kexec+0x2f0>
    800047f2:	f7ce                	sd	s3,488(sp)
    800047f4:	efd6                	sd	s5,472(sp)
    800047f6:	e7de                	sd	s7,456(sp)
    800047f8:	e3e2                	sd	s8,448(sp)
    800047fa:	ff66                	sd	s9,440(sp)
    800047fc:	fb6a                	sd	s10,432(sp)
    800047fe:	f76e                	sd	s11,424(sp)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004800:	e8845783          	lhu	a5,-376(s0)
    80004804:	cff9                	beqz	a5,800048e2 <kexec+0x184>
    80004806:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000480a:	4901                	li	s2,0
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    8000480c:	4d01                	li	s10,0
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000480e:	03800d93          	li	s11,56

  for (i = 0; i < sz; i += PGSIZE) {
    pa = walkaddr(pagetable, va + i);
    if (pa == 0)
      panic("loadseg: address should exist");
    if (sz - i < PGSIZE)
    80004812:	6c85                	lui	s9,0x1
    80004814:	6a85                	lui	s5,0x1
    80004816:	a085                	j	80004876 <kexec+0x118>
      panic("loadseg: address should exist");
    80004818:	00003517          	auipc	a0,0x3
    8000481c:	e7850513          	addi	a0,a0,-392 # 80007690 <etext+0x690>
    80004820:	81afc0ef          	jal	8000083a <panic>
    if (sz - i < PGSIZE)
    80004824:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if (readi(ip, 0, (uint64)pa, offset + i, n) != n)
    80004826:	874a                	mv	a4,s2
    80004828:	009b86bb          	addw	a3,s7,s1
    8000482c:	4581                	li	a1,0
    8000482e:	8552                	mv	a0,s4
    80004830:	dedfe0ef          	jal	8000361c <readi>
    80004834:	22a91163          	bne	s2,a0,80004a56 <kexec+0x2f8>
  for (i = 0; i < sz; i += PGSIZE) {
    80004838:	009a84bb          	addw	s1,s5,s1
    8000483c:	0334f263          	bgeu	s1,s3,80004860 <kexec+0x102>
    pa = walkaddr(pagetable, va + i);
    80004840:	02049593          	slli	a1,s1,0x20
    80004844:	9181                	srli	a1,a1,0x20
    80004846:	95e2                	add	a1,a1,s8
    80004848:	855a                	mv	a0,s6
    8000484a:	faefc0ef          	jal	80000ff8 <walkaddr>
    8000484e:	862a                	mv	a2,a0
    if (pa == 0)
    80004850:	d561                	beqz	a0,80004818 <kexec+0xba>
    if (sz - i < PGSIZE)
    80004852:	409987bb          	subw	a5,s3,s1
    80004856:	893e                	mv	s2,a5
    80004858:	fcfcf6e3          	bgeu	s9,a5,80004824 <kexec+0xc6>
    8000485c:	8956                	mv	s2,s5
    8000485e:	b7d9                	j	80004824 <kexec+0xc6>
    sz = sz1;
    80004860:	df043903          	ld	s2,-528(s0)
  for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph)) {
    80004864:	2d05                	addiw	s10,s10,1
    80004866:	e0843783          	ld	a5,-504(s0)
    8000486a:	0387869b          	addiw	a3,a5,56
    8000486e:	e8845783          	lhu	a5,-376(s0)
    80004872:	06fd5963          	bge	s10,a5,800048e4 <kexec+0x186>
    if (readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004876:	e0d43423          	sd	a3,-504(s0)
    8000487a:	876e                	mv	a4,s11
    8000487c:	e1840613          	addi	a2,s0,-488
    80004880:	4581                	li	a1,0
    80004882:	8552                	mv	a0,s4
    80004884:	d99fe0ef          	jal	8000361c <readi>
    80004888:	1db51563          	bne	a0,s11,80004a52 <kexec+0x2f4>
    if (ph.type != ELF_PROG_LOAD)
    8000488c:	e1842783          	lw	a5,-488(s0)
    80004890:	4705                	li	a4,1
    80004892:	fce799e3          	bne	a5,a4,80004864 <kexec+0x106>
    if (ph.memsz < ph.filesz)
    80004896:	e4043483          	ld	s1,-448(s0)
    8000489a:	e3843783          	ld	a5,-456(s0)
    8000489e:	1af4ea63          	bltu	s1,a5,80004a52 <kexec+0x2f4>
    if (ph.vaddr + ph.memsz < ph.vaddr)
    800048a2:	e2843783          	ld	a5,-472(s0)
    800048a6:	94be                	add	s1,s1,a5
    800048a8:	1af4e563          	bltu	s1,a5,80004a52 <kexec+0x2f4>
    if (ph.vaddr % PGSIZE != 0)
    800048ac:	17d2                	slli	a5,a5,0x34
    800048ae:	1a079263          	bnez	a5,80004a52 <kexec+0x2f4>
    if ((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz,
    800048b2:	e1c42503          	lw	a0,-484(s0)
    800048b6:	e89ff0ef          	jal	8000473e <flags2perm>
    800048ba:	86aa                	mv	a3,a0
    800048bc:	8626                	mv	a2,s1
    800048be:	85ca                	mv	a1,s2
    800048c0:	855a                	mv	a0,s6
    800048c2:	a05fc0ef          	jal	800012c6 <uvmalloc>
    800048c6:	dea43823          	sd	a0,-528(s0)
    800048ca:	18050463          	beqz	a0,80004a52 <kexec+0x2f4>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800048ce:	e3842983          	lw	s3,-456(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800048d2:	f80987e3          	beqz	s3,80004860 <kexec+0x102>
    if (loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800048d6:	e2843c03          	ld	s8,-472(s0)
    800048da:	e2042b83          	lw	s7,-480(s0)
  for (i = 0; i < sz; i += PGSIZE) {
    800048de:	4481                	li	s1,0
    800048e0:	b785                	j	80004840 <kexec+0xe2>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800048e2:	4901                	li	s2,0
  iunlockput(ip);
    800048e4:	8552                	mv	a0,s4
    800048e6:	bb1fe0ef          	jal	80003496 <iunlockput>
  end_op();
    800048ea:	c26ff0ef          	jal	80003d10 <end_op>
  p = myproc();
    800048ee:	ff1fc0ef          	jal	800018de <myproc>
    800048f2:	89aa                	mv	s3,a0
  uint64 oldsz = p->sz;
    800048f4:	04853a83          	ld	s5,72(a0)
  sz = PGROUNDUP(sz);
    800048f8:	6485                	lui	s1,0x1
    800048fa:	14fd                	addi	s1,s1,-1 # fff <_entry-0x7ffff001>
    800048fc:	94ca                	add	s1,s1,s2
    800048fe:	77fd                	lui	a5,0xfffff
    80004900:	8cfd                	and	s1,s1,a5
  if ((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK + 1) * PGSIZE, PTE_W)) ==
    80004902:	4691                	li	a3,4
    80004904:	6609                	lui	a2,0x2
    80004906:	9626                	add	a2,a2,s1
    80004908:	85a6                	mv	a1,s1
    8000490a:	855a                	mv	a0,s6
    8000490c:	9bbfc0ef          	jal	800012c6 <uvmalloc>
    80004910:	8a2a                	mv	s4,a0
    80004912:	ed19                	bnez	a0,80004930 <kexec+0x1d2>
    proc_freepagetable(pagetable, sz);
    80004914:	85a6                	mv	a1,s1
    80004916:	855a                	mv	a0,s6
    80004918:	952fd0ef          	jal	80001a6a <proc_freepagetable>
  if (ip) {
    8000491c:	79be                	ld	s3,488(sp)
    8000491e:	7a1e                	ld	s4,480(sp)
    80004920:	6afe                	ld	s5,472(sp)
    80004922:	6b5e                	ld	s6,464(sp)
    80004924:	6bbe                	ld	s7,456(sp)
    80004926:	6c1e                	ld	s8,448(sp)
    80004928:	7cfa                	ld	s9,440(sp)
    8000492a:	7d5a                	ld	s10,432(sp)
    8000492c:	7dba                	ld	s11,424(sp)
    8000492e:	bd71                	j	800047ca <kexec+0x6c>
  uvmclear(pagetable, sz - (USERSTACK + 1) * PGSIZE);
    80004930:	75f9                	lui	a1,0xffffe
    80004932:	95aa                	add	a1,a1,a0
    80004934:	855a                	mv	a0,s6
    80004936:	b59fc0ef          	jal	8000148e <uvmclear>
  stackbase = sp - USERSTACK * PGSIZE;
    8000493a:	7c7d                	lui	s8,0xfffff
    8000493c:	9c52                	add	s8,s8,s4
  for (argc = 0; argv[argc]; argc++) {
    8000493e:	df843783          	ld	a5,-520(s0)
    80004942:	6388                	ld	a0,0(a5)
  sp = sz;
    80004944:	8952                	mv	s2,s4
  for (argc = 0; argv[argc]; argc++) {
    80004946:	4481                	li	s1,0
    ustack[argc] = sp;
    80004948:	e9040c93          	addi	s9,s0,-368
    if (argc >= MAXARG)
    8000494c:	02000d13          	li	s10,32
  for (argc = 0; argv[argc]; argc++) {
    80004950:	cd21                	beqz	a0,800049a8 <kexec+0x24a>
    sp -= strlen(argv[argc]) + 1;
    80004952:	d02fc0ef          	jal	80000e54 <strlen>
    80004956:	0015079b          	addiw	a5,a0,1
    8000495a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000495e:	ff07f913          	andi	s2,a5,-16
    if (sp < stackbase)
    80004962:	05896163          	bltu	s2,s8,800049a4 <kexec+0x246>
    if (copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004966:	df843d83          	ld	s11,-520(s0)
    8000496a:	000dbb83          	ld	s7,0(s11)
    8000496e:	855e                	mv	a0,s7
    80004970:	ce4fc0ef          	jal	80000e54 <strlen>
    80004974:	0015069b          	addiw	a3,a0,1
    80004978:	865e                	mv	a2,s7
    8000497a:	85ca                	mv	a1,s2
    8000497c:	855a                	mv	a0,s6
    8000497e:	c93fc0ef          	jal	80001610 <copyout>
    80004982:	02054163          	bltz	a0,800049a4 <kexec+0x246>
    ustack[argc] = sp;
    80004986:	00349793          	slli	a5,s1,0x3
    8000498a:	97e6                	add	a5,a5,s9
    8000498c:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde078>
  for (argc = 0; argv[argc]; argc++) {
    80004990:	0485                	addi	s1,s1,1
    80004992:	008d8793          	addi	a5,s11,8
    80004996:	def43c23          	sd	a5,-520(s0)
    8000499a:	008db503          	ld	a0,8(s11)
    8000499e:	c509                	beqz	a0,800049a8 <kexec+0x24a>
    if (argc >= MAXARG)
    800049a0:	fba499e3          	bne	s1,s10,80004952 <kexec+0x1f4>
  sz = sz1;
    800049a4:	84d2                	mv	s1,s4
    800049a6:	b7bd                	j	80004914 <kexec+0x1b6>
  ustack[argc] = 0;
    800049a8:	00349793          	slli	a5,s1,0x3
    800049ac:	f9040713          	addi	a4,s0,-112
    800049b0:	97ba                	add	a5,a5,a4
    800049b2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc + 1) * sizeof(uint64);
    800049b6:	00148693          	addi	a3,s1,1
    800049ba:	068e                	slli	a3,a3,0x3
    800049bc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800049c0:	ff097913          	andi	s2,s2,-16
  if (sp < stackbase)
    800049c4:	ff8960e3          	bltu	s2,s8,800049a4 <kexec+0x246>
  if (copyout(pagetable, sp, (char *)ustack, (argc + 1) * sizeof(uint64)) < 0)
    800049c8:	e9040613          	addi	a2,s0,-368
    800049cc:	85ca                	mv	a1,s2
    800049ce:	855a                	mv	a0,s6
    800049d0:	c41fc0ef          	jal	80001610 <copyout>
    800049d4:	fc0548e3          	bltz	a0,800049a4 <kexec+0x246>
  p->trapframe->a1 = sp;
    800049d8:	0589b783          	ld	a5,88(s3)
    800049dc:	0727bc23          	sd	s2,120(a5)
  for (last = s = path; *s; s++)
    800049e0:	e0043783          	ld	a5,-512(s0)
    800049e4:	0007c703          	lbu	a4,0(a5)
    800049e8:	cf11                	beqz	a4,80004a04 <kexec+0x2a6>
    800049ea:	0785                	addi	a5,a5,1
    if (*s == '/')
    800049ec:	02f00693          	li	a3,47
    800049f0:	a029                	j	800049fa <kexec+0x29c>
  for (last = s = path; *s; s++)
    800049f2:	0785                	addi	a5,a5,1
    800049f4:	fff7c703          	lbu	a4,-1(a5)
    800049f8:	c711                	beqz	a4,80004a04 <kexec+0x2a6>
    if (*s == '/')
    800049fa:	fed71ce3          	bne	a4,a3,800049f2 <kexec+0x294>
      last = s + 1;
    800049fe:	e0f43023          	sd	a5,-512(s0)
    80004a02:	bfc5                	j	800049f2 <kexec+0x294>
  safestrcpy(p->name, last, sizeof(p->name));
    80004a04:	4641                	li	a2,16
    80004a06:	e0043583          	ld	a1,-512(s0)
    80004a0a:	15898513          	addi	a0,s3,344
    80004a0e:	c10fc0ef          	jal	80000e1e <safestrcpy>
  oldpagetable = p->pagetable;
    80004a12:	0509b503          	ld	a0,80(s3)
  p->pagetable = pagetable;
    80004a16:	0569b823          	sd	s6,80(s3)
  p->sz = sz;
    80004a1a:	0549b423          	sd	s4,72(s3)
  p->trapframe->epc = elf.entry; // initial program counter = ulib.c:start()
    80004a1e:	0589b783          	ld	a5,88(s3)
    80004a22:	e6843703          	ld	a4,-408(s0)
    80004a26:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp;         // initial stack pointer
    80004a28:	0589b783          	ld	a5,88(s3)
    80004a2c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004a30:	85d6                	mv	a1,s5
    80004a32:	838fd0ef          	jal	80001a6a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004a36:	0004851b          	sext.w	a0,s1
    80004a3a:	79be                	ld	s3,488(sp)
    80004a3c:	7a1e                	ld	s4,480(sp)
    80004a3e:	6afe                	ld	s5,472(sp)
    80004a40:	6b5e                	ld	s6,464(sp)
    80004a42:	6bbe                	ld	s7,456(sp)
    80004a44:	6c1e                	ld	s8,448(sp)
    80004a46:	7cfa                	ld	s9,440(sp)
    80004a48:	7d5a                	ld	s10,432(sp)
    80004a4a:	7dba                	ld	s11,424(sp)
    80004a4c:	b341                	j	800047cc <kexec+0x6e>
    80004a4e:	6b5e                	ld	s6,464(sp)
    80004a50:	b3bd                	j	800047be <kexec+0x60>
    return -1;
    80004a52:	df243823          	sd	s2,-528(s0)
    proc_freepagetable(pagetable, sz);
    80004a56:	df043583          	ld	a1,-528(s0)
    80004a5a:	855a                	mv	a0,s6
    80004a5c:	80efd0ef          	jal	80001a6a <proc_freepagetable>
  if (ip) {
    80004a60:	79be                	ld	s3,488(sp)
    80004a62:	6afe                	ld	s5,472(sp)
    80004a64:	6b5e                	ld	s6,464(sp)
    80004a66:	6bbe                	ld	s7,456(sp)
    80004a68:	6c1e                	ld	s8,448(sp)
    80004a6a:	7cfa                	ld	s9,440(sp)
    80004a6c:	7d5a                	ld	s10,432(sp)
    80004a6e:	7dba                	ld	s11,424(sp)
    80004a70:	b3b9                	j	800047be <kexec+0x60>

0000000080004a72 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004a72:	7179                	addi	sp,sp,-48
    80004a74:	f406                	sd	ra,40(sp)
    80004a76:	f022                	sd	s0,32(sp)
    80004a78:	ec26                	sd	s1,24(sp)
    80004a7a:	e84a                	sd	s2,16(sp)
    80004a7c:	1800                	addi	s0,sp,48
    80004a7e:	892e                	mv	s2,a1
    80004a80:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004a82:	fdc40593          	addi	a1,s0,-36
    80004a86:	d3ffd0ef          	jal	800027c4 <argint>
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004a8a:	fdc42703          	lw	a4,-36(s0)
    80004a8e:	47bd                	li	a5,15
    80004a90:	02e7e963          	bltu	a5,a4,80004ac2 <argfd+0x50>
    80004a94:	e4bfc0ef          	jal	800018de <myproc>
    80004a98:	fdc42703          	lw	a4,-36(s0)
    80004a9c:	01a70793          	addi	a5,a4,26
    80004aa0:	078e                	slli	a5,a5,0x3
    80004aa2:	953e                	add	a0,a0,a5
    80004aa4:	611c                	ld	a5,0(a0)
    80004aa6:	cf91                	beqz	a5,80004ac2 <argfd+0x50>
    return -1;
  if (pfd)
    80004aa8:	00090463          	beqz	s2,80004ab0 <argfd+0x3e>
    *pfd = fd;
    80004aac:	00e92023          	sw	a4,0(s2)
  if (pf)
    80004ab0:	c091                	beqz	s1,80004ab4 <argfd+0x42>
    *pf = f;
    80004ab2:	e09c                	sd	a5,0(s1)
  return 0;
    80004ab4:	4501                	li	a0,0
}
    80004ab6:	70a2                	ld	ra,40(sp)
    80004ab8:	7402                	ld	s0,32(sp)
    80004aba:	64e2                	ld	s1,24(sp)
    80004abc:	6942                	ld	s2,16(sp)
    80004abe:	6145                	addi	sp,sp,48
    80004ac0:	8082                	ret
    return -1;
    80004ac2:	557d                	li	a0,-1
    80004ac4:	bfcd                	j	80004ab6 <argfd+0x44>

0000000080004ac6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004ac6:	1101                	addi	sp,sp,-32
    80004ac8:	ec06                	sd	ra,24(sp)
    80004aca:	e822                	sd	s0,16(sp)
    80004acc:	e426                	sd	s1,8(sp)
    80004ace:	1000                	addi	s0,sp,32
    80004ad0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004ad2:	e0dfc0ef          	jal	800018de <myproc>
    80004ad6:	862a                	mv	a2,a0

  for (fd = 0; fd < NOFILE; fd++) {
    80004ad8:	0d050793          	addi	a5,a0,208
    80004adc:	4501                	li	a0,0
    80004ade:	46c1                	li	a3,16
    if (p->ofile[fd] == 0) {
    80004ae0:	6398                	ld	a4,0(a5)
    80004ae2:	cb19                	beqz	a4,80004af8 <fdalloc+0x32>
  for (fd = 0; fd < NOFILE; fd++) {
    80004ae4:	2505                	addiw	a0,a0,1
    80004ae6:	07a1                	addi	a5,a5,8
    80004ae8:	fed51ce3          	bne	a0,a3,80004ae0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004aec:	557d                	li	a0,-1
}
    80004aee:	60e2                	ld	ra,24(sp)
    80004af0:	6442                	ld	s0,16(sp)
    80004af2:	64a2                	ld	s1,8(sp)
    80004af4:	6105                	addi	sp,sp,32
    80004af6:	8082                	ret
      p->ofile[fd] = f;
    80004af8:	01a50793          	addi	a5,a0,26
    80004afc:	078e                	slli	a5,a5,0x3
    80004afe:	963e                	add	a2,a2,a5
    80004b00:	e204                	sd	s1,0(a2)
      return fd;
    80004b02:	b7f5                	j	80004aee <fdalloc+0x28>

0000000080004b04 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004b04:	715d                	addi	sp,sp,-80
    80004b06:	e486                	sd	ra,72(sp)
    80004b08:	e0a2                	sd	s0,64(sp)
    80004b0a:	fc26                	sd	s1,56(sp)
    80004b0c:	f84a                	sd	s2,48(sp)
    80004b0e:	f44e                	sd	s3,40(sp)
    80004b10:	f052                	sd	s4,32(sp)
    80004b12:	ec56                	sd	s5,24(sp)
    80004b14:	e85a                	sd	s6,16(sp)
    80004b16:	0880                	addi	s0,sp,80
    80004b18:	892e                	mv	s2,a1
    80004b1a:	8a2e                	mv	s4,a1
    80004b1c:	8ab2                	mv	s5,a2
    80004b1e:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
    80004b20:	fb040593          	addi	a1,s0,-80
    80004b24:	fb9fe0ef          	jal	80003adc <nameiparent>
    80004b28:	84aa                	mv	s1,a0
    return 0;
    80004b2a:	89aa                	mv	s3,a0
  if ((dp = nameiparent(path, name)) == 0)
    80004b2c:	cd05                	beqz	a0,80004b64 <create+0x60>

  ilock(dp);
    80004b2e:	f5cfe0ef          	jal	8000328a <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0) {
    80004b32:	4601                	li	a2,0
    80004b34:	fb040593          	addi	a1,s0,-80
    80004b38:	8526                	mv	a0,s1
    80004b3a:	cedfe0ef          	jal	80003826 <dirlookup>
    80004b3e:	89aa                	mv	s3,a0
    80004b40:	c131                	beqz	a0,80004b84 <create+0x80>
    iunlockput(dp);
    80004b42:	8526                	mv	a0,s1
    80004b44:	953fe0ef          	jal	80003496 <iunlockput>
    ilock(ip);
    80004b48:	854e                	mv	a0,s3
    80004b4a:	f40fe0ef          	jal	8000328a <ilock>
    if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004b4e:	4789                	li	a5,2
    80004b50:	02f91563          	bne	s2,a5,80004b7a <create+0x76>
    80004b54:	0449d783          	lhu	a5,68(s3)
    80004b58:	37f9                	addiw	a5,a5,-2
    80004b5a:	17c2                	slli	a5,a5,0x30
    80004b5c:	93c1                	srli	a5,a5,0x30
    80004b5e:	4705                	li	a4,1
    80004b60:	00f76d63          	bltu	a4,a5,80004b7a <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004b64:	854e                	mv	a0,s3
    80004b66:	60a6                	ld	ra,72(sp)
    80004b68:	6406                	ld	s0,64(sp)
    80004b6a:	74e2                	ld	s1,56(sp)
    80004b6c:	7942                	ld	s2,48(sp)
    80004b6e:	79a2                	ld	s3,40(sp)
    80004b70:	7a02                	ld	s4,32(sp)
    80004b72:	6ae2                	ld	s5,24(sp)
    80004b74:	6b42                	ld	s6,16(sp)
    80004b76:	6161                	addi	sp,sp,80
    80004b78:	8082                	ret
    iunlockput(ip);
    80004b7a:	854e                	mv	a0,s3
    80004b7c:	91bfe0ef          	jal	80003496 <iunlockput>
    return 0;
    80004b80:	4981                	li	s3,0
    80004b82:	b7cd                	j	80004b64 <create+0x60>
  if ((ip = ialloc(dp->dev, type)) == 0) {
    80004b84:	85ca                	mv	a1,s2
    80004b86:	4088                	lw	a0,0(s1)
    80004b88:	d92fe0ef          	jal	8000311a <ialloc>
    80004b8c:	892a                	mv	s2,a0
    80004b8e:	cd15                	beqz	a0,80004bca <create+0xc6>
  ilock(ip);
    80004b90:	efafe0ef          	jal	8000328a <ilock>
  ip->major = major;
    80004b94:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004b98:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004b9c:	4785                	li	a5,1
    80004b9e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004ba2:	854a                	mv	a0,s2
    80004ba4:	e32fe0ef          	jal	800031d6 <iupdate>
  if (type == T_DIR) { // Create . and .. entries.
    80004ba8:	4705                	li	a4,1
    80004baa:	02ea0463          	beq	s4,a4,80004bd2 <create+0xce>
  if (dirlink(dp, name, ip->inum) < 0)
    80004bae:	00492603          	lw	a2,4(s2)
    80004bb2:	fb040593          	addi	a1,s0,-80
    80004bb6:	8526                	mv	a0,s1
    80004bb8:	e61fe0ef          	jal	80003a18 <dirlink>
    80004bbc:	06054263          	bltz	a0,80004c20 <create+0x11c>
  iunlockput(dp);
    80004bc0:	8526                	mv	a0,s1
    80004bc2:	8d5fe0ef          	jal	80003496 <iunlockput>
    return 0;
    80004bc6:	89ca                	mv	s3,s2
    80004bc8:	bf71                	j	80004b64 <create+0x60>
    iunlockput(dp);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	8cbfe0ef          	jal	80003496 <iunlockput>
    return 0;
    80004bd0:	bfdd                	j	80004bc6 <create+0xc2>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004bd2:	00492603          	lw	a2,4(s2)
    80004bd6:	00003597          	auipc	a1,0x3
    80004bda:	ada58593          	addi	a1,a1,-1318 # 800076b0 <etext+0x6b0>
    80004bde:	854a                	mv	a0,s2
    80004be0:	e39fe0ef          	jal	80003a18 <dirlink>
    80004be4:	02054e63          	bltz	a0,80004c20 <create+0x11c>
    80004be8:	40d0                	lw	a2,4(s1)
    80004bea:	00003597          	auipc	a1,0x3
    80004bee:	ace58593          	addi	a1,a1,-1330 # 800076b8 <etext+0x6b8>
    80004bf2:	854a                	mv	a0,s2
    80004bf4:	e25fe0ef          	jal	80003a18 <dirlink>
    80004bf8:	02054463          	bltz	a0,80004c20 <create+0x11c>
  if (dirlink(dp, name, ip->inum) < 0)
    80004bfc:	00492603          	lw	a2,4(s2)
    80004c00:	fb040593          	addi	a1,s0,-80
    80004c04:	8526                	mv	a0,s1
    80004c06:	e13fe0ef          	jal	80003a18 <dirlink>
    80004c0a:	00054b63          	bltz	a0,80004c20 <create+0x11c>
    dp->nlink++; // for ".."
    80004c0e:	04a4d783          	lhu	a5,74(s1)
    80004c12:	2785                	addiw	a5,a5,1
    80004c14:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004c18:	8526                	mv	a0,s1
    80004c1a:	dbcfe0ef          	jal	800031d6 <iupdate>
    80004c1e:	b74d                	j	80004bc0 <create+0xbc>
  ip->nlink = 0;
    80004c20:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004c24:	854a                	mv	a0,s2
    80004c26:	db0fe0ef          	jal	800031d6 <iupdate>
  iunlockput(ip);
    80004c2a:	854a                	mv	a0,s2
    80004c2c:	86bfe0ef          	jal	80003496 <iunlockput>
  iunlockput(dp);
    80004c30:	8526                	mv	a0,s1
    80004c32:	865fe0ef          	jal	80003496 <iunlockput>
  return 0;
    80004c36:	b73d                	j	80004b64 <create+0x60>

0000000080004c38 <sys_dup>:
{
    80004c38:	7179                	addi	sp,sp,-48
    80004c3a:	f406                	sd	ra,40(sp)
    80004c3c:	f022                	sd	s0,32(sp)
    80004c3e:	1800                	addi	s0,sp,48
  if (argfd(0, 0, &f) < 0)
    80004c40:	fd840613          	addi	a2,s0,-40
    80004c44:	4581                	li	a1,0
    80004c46:	4501                	li	a0,0
    80004c48:	e2bff0ef          	jal	80004a72 <argfd>
    80004c4c:	02054863          	bltz	a0,80004c7c <sys_dup+0x44>
    80004c50:	ec26                	sd	s1,24(sp)
    80004c52:	e84a                	sd	s2,16(sp)
  if ((fd = fdalloc(f)) < 0)
    80004c54:	fd843483          	ld	s1,-40(s0)
    80004c58:	8526                	mv	a0,s1
    80004c5a:	e6dff0ef          	jal	80004ac6 <fdalloc>
    80004c5e:	892a                	mv	s2,a0
    80004c60:	00054c63          	bltz	a0,80004c78 <sys_dup+0x40>
  filedup(f);
    80004c64:	8526                	mv	a0,s1
    80004c66:	c72ff0ef          	jal	800040d8 <filedup>
  return fd;
    80004c6a:	854a                	mv	a0,s2
    80004c6c:	64e2                	ld	s1,24(sp)
    80004c6e:	6942                	ld	s2,16(sp)
}
    80004c70:	70a2                	ld	ra,40(sp)
    80004c72:	7402                	ld	s0,32(sp)
    80004c74:	6145                	addi	sp,sp,48
    80004c76:	8082                	ret
    80004c78:	64e2                	ld	s1,24(sp)
    80004c7a:	6942                	ld	s2,16(sp)
    return -1;
    80004c7c:	557d                	li	a0,-1
    80004c7e:	bfcd                	j	80004c70 <sys_dup+0x38>

0000000080004c80 <sys_read>:
{
    80004c80:	7179                	addi	sp,sp,-48
    80004c82:	f406                	sd	ra,40(sp)
    80004c84:	f022                	sd	s0,32(sp)
    80004c86:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004c88:	fd840593          	addi	a1,s0,-40
    80004c8c:	4505                	li	a0,1
    80004c8e:	b53fd0ef          	jal	800027e0 <argaddr>
  argint(2, &n);
    80004c92:	fe440593          	addi	a1,s0,-28
    80004c96:	4509                	li	a0,2
    80004c98:	b2dfd0ef          	jal	800027c4 <argint>
  if (argfd(0, 0, &f) < 0)
    80004c9c:	fe840613          	addi	a2,s0,-24
    80004ca0:	4581                	li	a1,0
    80004ca2:	4501                	li	a0,0
    80004ca4:	dcfff0ef          	jal	80004a72 <argfd>
    80004ca8:	87aa                	mv	a5,a0
    return -1;
    80004caa:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004cac:	0007ca63          	bltz	a5,80004cc0 <sys_read+0x40>
  return fileread(f, p, n);
    80004cb0:	fe442603          	lw	a2,-28(s0)
    80004cb4:	fd843583          	ld	a1,-40(s0)
    80004cb8:	fe843503          	ld	a0,-24(s0)
    80004cbc:	d86ff0ef          	jal	80004242 <fileread>
}
    80004cc0:	70a2                	ld	ra,40(sp)
    80004cc2:	7402                	ld	s0,32(sp)
    80004cc4:	6145                	addi	sp,sp,48
    80004cc6:	8082                	ret

0000000080004cc8 <sys_write>:
{
    80004cc8:	7179                	addi	sp,sp,-48
    80004cca:	f406                	sd	ra,40(sp)
    80004ccc:	f022                	sd	s0,32(sp)
    80004cce:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004cd0:	fd840593          	addi	a1,s0,-40
    80004cd4:	4505                	li	a0,1
    80004cd6:	b0bfd0ef          	jal	800027e0 <argaddr>
  argint(2, &n);
    80004cda:	fe440593          	addi	a1,s0,-28
    80004cde:	4509                	li	a0,2
    80004ce0:	ae5fd0ef          	jal	800027c4 <argint>
  if (argfd(0, 0, &f) < 0)
    80004ce4:	fe840613          	addi	a2,s0,-24
    80004ce8:	4581                	li	a1,0
    80004cea:	4501                	li	a0,0
    80004cec:	d87ff0ef          	jal	80004a72 <argfd>
    80004cf0:	87aa                	mv	a5,a0
    return -1;
    80004cf2:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004cf4:	0007ca63          	bltz	a5,80004d08 <sys_write+0x40>
  return filewrite(f, p, n);
    80004cf8:	fe442603          	lw	a2,-28(s0)
    80004cfc:	fd843583          	ld	a1,-40(s0)
    80004d00:	fe843503          	ld	a0,-24(s0)
    80004d04:	df8ff0ef          	jal	800042fc <filewrite>
}
    80004d08:	70a2                	ld	ra,40(sp)
    80004d0a:	7402                	ld	s0,32(sp)
    80004d0c:	6145                	addi	sp,sp,48
    80004d0e:	8082                	ret

0000000080004d10 <sys_close>:
{
    80004d10:	1101                	addi	sp,sp,-32
    80004d12:	ec06                	sd	ra,24(sp)
    80004d14:	e822                	sd	s0,16(sp)
    80004d16:	1000                	addi	s0,sp,32
  if (argfd(0, &fd, &f) < 0)
    80004d18:	fe040613          	addi	a2,s0,-32
    80004d1c:	fec40593          	addi	a1,s0,-20
    80004d20:	4501                	li	a0,0
    80004d22:	d51ff0ef          	jal	80004a72 <argfd>
    return -1;
    80004d26:	57fd                	li	a5,-1
  if (argfd(0, &fd, &f) < 0)
    80004d28:	02054063          	bltz	a0,80004d48 <sys_close+0x38>
  myproc()->ofile[fd] = 0;
    80004d2c:	bb3fc0ef          	jal	800018de <myproc>
    80004d30:	fec42783          	lw	a5,-20(s0)
    80004d34:	07e9                	addi	a5,a5,26
    80004d36:	078e                	slli	a5,a5,0x3
    80004d38:	953e                	add	a0,a0,a5
    80004d3a:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004d3e:	fe043503          	ld	a0,-32(s0)
    80004d42:	bdcff0ef          	jal	8000411e <fileclose>
  return 0;
    80004d46:	4781                	li	a5,0
}
    80004d48:	853e                	mv	a0,a5
    80004d4a:	60e2                	ld	ra,24(sp)
    80004d4c:	6442                	ld	s0,16(sp)
    80004d4e:	6105                	addi	sp,sp,32
    80004d50:	8082                	ret

0000000080004d52 <sys_fstat>:
{
    80004d52:	1101                	addi	sp,sp,-32
    80004d54:	ec06                	sd	ra,24(sp)
    80004d56:	e822                	sd	s0,16(sp)
    80004d58:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004d5a:	fe040593          	addi	a1,s0,-32
    80004d5e:	4505                	li	a0,1
    80004d60:	a81fd0ef          	jal	800027e0 <argaddr>
  if (argfd(0, 0, &f) < 0)
    80004d64:	fe840613          	addi	a2,s0,-24
    80004d68:	4581                	li	a1,0
    80004d6a:	4501                	li	a0,0
    80004d6c:	d07ff0ef          	jal	80004a72 <argfd>
    80004d70:	87aa                	mv	a5,a0
    return -1;
    80004d72:	557d                	li	a0,-1
  if (argfd(0, 0, &f) < 0)
    80004d74:	0007c863          	bltz	a5,80004d84 <sys_fstat+0x32>
  return filestat(f, st);
    80004d78:	fe043583          	ld	a1,-32(s0)
    80004d7c:	fe843503          	ld	a0,-24(s0)
    80004d80:	c60ff0ef          	jal	800041e0 <filestat>
}
    80004d84:	60e2                	ld	ra,24(sp)
    80004d86:	6442                	ld	s0,16(sp)
    80004d88:	6105                	addi	sp,sp,32
    80004d8a:	8082                	ret

0000000080004d8c <sys_link>:
{
    80004d8c:	7169                	addi	sp,sp,-304
    80004d8e:	f606                	sd	ra,296(sp)
    80004d90:	f222                	sd	s0,288(sp)
    80004d92:	1a00                	addi	s0,sp,304
  if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004d94:	08000613          	li	a2,128
    80004d98:	ed040593          	addi	a1,s0,-304
    80004d9c:	4501                	li	a0,0
    80004d9e:	a5ffd0ef          	jal	800027fc <argstr>
    80004da2:	0c054a63          	bltz	a0,80004e76 <sys_link+0xea>
    80004da6:	08000613          	li	a2,128
    80004daa:	f5040593          	addi	a1,s0,-176
    80004dae:	4505                	li	a0,1
    80004db0:	a4dfd0ef          	jal	800027fc <argstr>
    80004db4:	0c054163          	bltz	a0,80004e76 <sys_link+0xea>
    80004db8:	ee26                	sd	s1,280(sp)
  begin_op();
    80004dba:	ee7fe0ef          	jal	80003ca0 <begin_op>
  if ((ip = namei(old)) == 0) {
    80004dbe:	ed040513          	addi	a0,s0,-304
    80004dc2:	d01fe0ef          	jal	80003ac2 <namei>
    80004dc6:	84aa                	mv	s1,a0
    80004dc8:	c53d                	beqz	a0,80004e36 <sys_link+0xaa>
  ilock(ip);
    80004dca:	cc0fe0ef          	jal	8000328a <ilock>
  if (ip->type == T_DIR) {
    80004dce:	04449703          	lh	a4,68(s1)
    80004dd2:	4785                	li	a5,1
    80004dd4:	06f70563          	beq	a4,a5,80004e3e <sys_link+0xb2>
    80004dd8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004dda:	04a4d783          	lhu	a5,74(s1)
    80004dde:	2785                	addiw	a5,a5,1
    80004de0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004de4:	8526                	mv	a0,s1
    80004de6:	bf0fe0ef          	jal	800031d6 <iupdate>
  iunlock(ip);
    80004dea:	8526                	mv	a0,s1
    80004dec:	d4cfe0ef          	jal	80003338 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
    80004df0:	fd040593          	addi	a1,s0,-48
    80004df4:	f5040513          	addi	a0,s0,-176
    80004df8:	ce5fe0ef          	jal	80003adc <nameiparent>
    80004dfc:	892a                	mv	s2,a0
    80004dfe:	c931                	beqz	a0,80004e52 <sys_link+0xc6>
  ilock(dp);
    80004e00:	c8afe0ef          	jal	8000328a <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0) {
    80004e04:	854a                	mv	a0,s2
    80004e06:	00092703          	lw	a4,0(s2)
    80004e0a:	409c                	lw	a5,0(s1)
    80004e0c:	04f71063          	bne	a4,a5,80004e4c <sys_link+0xc0>
    80004e10:	40d0                	lw	a2,4(s1)
    80004e12:	fd040593          	addi	a1,s0,-48
    80004e16:	c03fe0ef          	jal	80003a18 <dirlink>
    80004e1a:	02054963          	bltz	a0,80004e4c <sys_link+0xc0>
  iunlockput(dp);
    80004e1e:	854a                	mv	a0,s2
    80004e20:	e76fe0ef          	jal	80003496 <iunlockput>
  iput(ip);
    80004e24:	8526                	mv	a0,s1
    80004e26:	de6fe0ef          	jal	8000340c <iput>
  end_op();
    80004e2a:	ee7fe0ef          	jal	80003d10 <end_op>
  return 0;
    80004e2e:	4501                	li	a0,0
    80004e30:	64f2                	ld	s1,280(sp)
    80004e32:	6952                	ld	s2,272(sp)
    80004e34:	a091                	j	80004e78 <sys_link+0xec>
    end_op();
    80004e36:	edbfe0ef          	jal	80003d10 <end_op>
    return -1;
    80004e3a:	64f2                	ld	s1,280(sp)
    80004e3c:	a82d                	j	80004e76 <sys_link+0xea>
    iunlockput(ip);
    80004e3e:	8526                	mv	a0,s1
    80004e40:	e56fe0ef          	jal	80003496 <iunlockput>
    end_op();
    80004e44:	ecdfe0ef          	jal	80003d10 <end_op>
    return -1;
    80004e48:	64f2                	ld	s1,280(sp)
    80004e4a:	a035                	j	80004e76 <sys_link+0xea>
    iunlockput(dp);
    80004e4c:	854a                	mv	a0,s2
    80004e4e:	e48fe0ef          	jal	80003496 <iunlockput>
  ilock(ip);
    80004e52:	8526                	mv	a0,s1
    80004e54:	c36fe0ef          	jal	8000328a <ilock>
  ip->nlink--;
    80004e58:	04a4d783          	lhu	a5,74(s1)
    80004e5c:	37fd                	addiw	a5,a5,-1
    80004e5e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004e62:	8526                	mv	a0,s1
    80004e64:	b72fe0ef          	jal	800031d6 <iupdate>
  iunlockput(ip);
    80004e68:	8526                	mv	a0,s1
    80004e6a:	e2cfe0ef          	jal	80003496 <iunlockput>
  end_op();
    80004e6e:	ea3fe0ef          	jal	80003d10 <end_op>
  return -1;
    80004e72:	64f2                	ld	s1,280(sp)
    80004e74:	6952                	ld	s2,272(sp)
    return -1;
    80004e76:	557d                	li	a0,-1
}
    80004e78:	70b2                	ld	ra,296(sp)
    80004e7a:	7412                	ld	s0,288(sp)
    80004e7c:	6155                	addi	sp,sp,304
    80004e7e:	8082                	ret

0000000080004e80 <sys_unlink>:
{
    80004e80:	7151                	addi	sp,sp,-240
    80004e82:	f586                	sd	ra,232(sp)
    80004e84:	f1a2                	sd	s0,224(sp)
    80004e86:	1980                	addi	s0,sp,240
  if (argstr(0, path, MAXPATH) < 0)
    80004e88:	08000613          	li	a2,128
    80004e8c:	f3040593          	addi	a1,s0,-208
    80004e90:	4501                	li	a0,0
    80004e92:	96bfd0ef          	jal	800027fc <argstr>
    80004e96:	14054763          	bltz	a0,80004fe4 <sys_unlink+0x164>
    80004e9a:	eda6                	sd	s1,216(sp)
  begin_op();
    80004e9c:	e05fe0ef          	jal	80003ca0 <begin_op>
  if ((dp = nameiparent(path, name)) == 0) {
    80004ea0:	fb040593          	addi	a1,s0,-80
    80004ea4:	f3040513          	addi	a0,s0,-208
    80004ea8:	c35fe0ef          	jal	80003adc <nameiparent>
    80004eac:	84aa                	mv	s1,a0
    80004eae:	c955                	beqz	a0,80004f62 <sys_unlink+0xe2>
  ilock(dp);
    80004eb0:	bdafe0ef          	jal	8000328a <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004eb4:	00002597          	auipc	a1,0x2
    80004eb8:	7fc58593          	addi	a1,a1,2044 # 800076b0 <etext+0x6b0>
    80004ebc:	fb040513          	addi	a0,s0,-80
    80004ec0:	951fe0ef          	jal	80003810 <namecmp>
    80004ec4:	10050a63          	beqz	a0,80004fd8 <sys_unlink+0x158>
    80004ec8:	00002597          	auipc	a1,0x2
    80004ecc:	7f058593          	addi	a1,a1,2032 # 800076b8 <etext+0x6b8>
    80004ed0:	fb040513          	addi	a0,s0,-80
    80004ed4:	93dfe0ef          	jal	80003810 <namecmp>
    80004ed8:	10050063          	beqz	a0,80004fd8 <sys_unlink+0x158>
    80004edc:	e9ca                	sd	s2,208(sp)
  if ((ip = dirlookup(dp, name, &off)) == 0)
    80004ede:	f2c40613          	addi	a2,s0,-212
    80004ee2:	fb040593          	addi	a1,s0,-80
    80004ee6:	8526                	mv	a0,s1
    80004ee8:	93ffe0ef          	jal	80003826 <dirlookup>
    80004eec:	892a                	mv	s2,a0
    80004eee:	0e050463          	beqz	a0,80004fd6 <sys_unlink+0x156>
    80004ef2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004ef4:	b96fe0ef          	jal	8000328a <ilock>
  if (ip->nlink < 1)
    80004ef8:	04a91783          	lh	a5,74(s2)
    80004efc:	06f05763          	blez	a5,80004f6a <sys_unlink+0xea>
  if (ip->type == T_DIR && !isdirempty(ip)) {
    80004f00:	04491703          	lh	a4,68(s2)
    80004f04:	4785                	li	a5,1
    80004f06:	06f70863          	beq	a4,a5,80004f76 <sys_unlink+0xf6>
  memset(&de, 0, sizeof(de));
    80004f0a:	fc040993          	addi	s3,s0,-64
    80004f0e:	4641                	li	a2,16
    80004f10:	4581                	li	a1,0
    80004f12:	854e                	mv	a0,s3
    80004f14:	dc1fb0ef          	jal	80000cd4 <memset>
  if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f18:	4741                	li	a4,16
    80004f1a:	f2c42683          	lw	a3,-212(s0)
    80004f1e:	864e                	mv	a2,s3
    80004f20:	4581                	li	a1,0
    80004f22:	8526                	mv	a0,s1
    80004f24:	feafe0ef          	jal	8000370e <writei>
    80004f28:	47c1                	li	a5,16
    80004f2a:	08f51763          	bne	a0,a5,80004fb8 <sys_unlink+0x138>
  if (ip->type == T_DIR) {
    80004f2e:	04491703          	lh	a4,68(s2)
    80004f32:	4785                	li	a5,1
    80004f34:	08f70863          	beq	a4,a5,80004fc4 <sys_unlink+0x144>
  iunlockput(dp);
    80004f38:	8526                	mv	a0,s1
    80004f3a:	d5cfe0ef          	jal	80003496 <iunlockput>
  ip->nlink--;
    80004f3e:	04a95783          	lhu	a5,74(s2)
    80004f42:	37fd                	addiw	a5,a5,-1
    80004f44:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004f48:	854a                	mv	a0,s2
    80004f4a:	a8cfe0ef          	jal	800031d6 <iupdate>
  iunlockput(ip);
    80004f4e:	854a                	mv	a0,s2
    80004f50:	d46fe0ef          	jal	80003496 <iunlockput>
  end_op();
    80004f54:	dbdfe0ef          	jal	80003d10 <end_op>
  return 0;
    80004f58:	4501                	li	a0,0
    80004f5a:	64ee                	ld	s1,216(sp)
    80004f5c:	694e                	ld	s2,208(sp)
    80004f5e:	69ae                	ld	s3,200(sp)
    80004f60:	a059                	j	80004fe6 <sys_unlink+0x166>
    end_op();
    80004f62:	daffe0ef          	jal	80003d10 <end_op>
    return -1;
    80004f66:	64ee                	ld	s1,216(sp)
    80004f68:	a8b5                	j	80004fe4 <sys_unlink+0x164>
    panic("unlink: nlink < 1");
    80004f6a:	00002517          	auipc	a0,0x2
    80004f6e:	75650513          	addi	a0,a0,1878 # 800076c0 <etext+0x6c0>
    80004f72:	8c9fb0ef          	jal	8000083a <panic>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004f76:	04c92703          	lw	a4,76(s2)
    80004f7a:	02000793          	li	a5,32
    80004f7e:	f8e7f6e3          	bgeu	a5,a4,80004f0a <sys_unlink+0x8a>
    80004f82:	89be                	mv	s3,a5
    if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004f84:	4741                	li	a4,16
    80004f86:	86ce                	mv	a3,s3
    80004f88:	f1840613          	addi	a2,s0,-232
    80004f8c:	4581                	li	a1,0
    80004f8e:	854a                	mv	a0,s2
    80004f90:	e8cfe0ef          	jal	8000361c <readi>
    80004f94:	47c1                	li	a5,16
    80004f96:	00f51b63          	bne	a0,a5,80004fac <sys_unlink+0x12c>
    if (de.inum != 0)
    80004f9a:	f1845783          	lhu	a5,-232(s0)
    80004f9e:	eba1                	bnez	a5,80004fee <sys_unlink+0x16e>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de)) {
    80004fa0:	29c1                	addiw	s3,s3,16
    80004fa2:	04c92783          	lw	a5,76(s2)
    80004fa6:	fcf9efe3          	bltu	s3,a5,80004f84 <sys_unlink+0x104>
    80004faa:	b785                	j	80004f0a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004fac:	00002517          	auipc	a0,0x2
    80004fb0:	72c50513          	addi	a0,a0,1836 # 800076d8 <etext+0x6d8>
    80004fb4:	887fb0ef          	jal	8000083a <panic>
    panic("unlink: writei");
    80004fb8:	00002517          	auipc	a0,0x2
    80004fbc:	73850513          	addi	a0,a0,1848 # 800076f0 <etext+0x6f0>
    80004fc0:	87bfb0ef          	jal	8000083a <panic>
    dp->nlink--;
    80004fc4:	04a4d783          	lhu	a5,74(s1)
    80004fc8:	37fd                	addiw	a5,a5,-1
    80004fca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004fce:	8526                	mv	a0,s1
    80004fd0:	a06fe0ef          	jal	800031d6 <iupdate>
    80004fd4:	b795                	j	80004f38 <sys_unlink+0xb8>
    80004fd6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004fd8:	8526                	mv	a0,s1
    80004fda:	cbcfe0ef          	jal	80003496 <iunlockput>
  end_op();
    80004fde:	d33fe0ef          	jal	80003d10 <end_op>
  return -1;
    80004fe2:	64ee                	ld	s1,216(sp)
    return -1;
    80004fe4:	557d                	li	a0,-1
}
    80004fe6:	70ae                	ld	ra,232(sp)
    80004fe8:	740e                	ld	s0,224(sp)
    80004fea:	616d                	addi	sp,sp,240
    80004fec:	8082                	ret
    iunlockput(ip);
    80004fee:	854a                	mv	a0,s2
    80004ff0:	ca6fe0ef          	jal	80003496 <iunlockput>
    goto bad;
    80004ff4:	694e                	ld	s2,208(sp)
    80004ff6:	69ae                	ld	s3,200(sp)
    80004ff8:	b7c5                	j	80004fd8 <sys_unlink+0x158>

0000000080004ffa <sys_open>:

uint64
sys_open(void)
{
    80004ffa:	7131                	addi	sp,sp,-192
    80004ffc:	fd06                	sd	ra,184(sp)
    80004ffe:	f922                	sd	s0,176(sp)
    80005000:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80005002:	f4c40593          	addi	a1,s0,-180
    80005006:	4505                	li	a0,1
    80005008:	fbcfd0ef          	jal	800027c4 <argint>
  if ((n = argstr(0, path, MAXPATH)) < 0)
    8000500c:	08000613          	li	a2,128
    80005010:	f5040593          	addi	a1,s0,-176
    80005014:	4501                	li	a0,0
    80005016:	fe6fd0ef          	jal	800027fc <argstr>
    8000501a:	10054563          	bltz	a0,80005124 <sys_open+0x12a>
    8000501e:	f526                	sd	s1,168(sp)
    return -1;

  begin_op();
    80005020:	c81fe0ef          	jal	80003ca0 <begin_op>

  if (omode & O_CREATE) {
    80005024:	f4c42783          	lw	a5,-180(s0)
    80005028:	2007f793          	andi	a5,a5,512
    8000502c:	cfd9                	beqz	a5,800050ca <sys_open+0xd0>
    ip = create(path, T_FILE, 0, 0);
    8000502e:	4681                	li	a3,0
    80005030:	4601                	li	a2,0
    80005032:	4589                	li	a1,2
    80005034:	f5040513          	addi	a0,s0,-176
    80005038:	acdff0ef          	jal	80004b04 <create>
    8000503c:	84aa                	mv	s1,a0
    if (ip == 0) {
    8000503e:	c151                	beqz	a0,800050c2 <sys_open+0xc8>
      end_op();
      return -1;
    }
  }

  if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)) {
    80005040:	04449703          	lh	a4,68(s1)
    80005044:	478d                	li	a5,3
    80005046:	00f71763          	bne	a4,a5,80005054 <sys_open+0x5a>
    8000504a:	0464d703          	lhu	a4,70(s1)
    8000504e:	47a5                	li	a5,9
    80005050:	0ae7e863          	bltu	a5,a4,80005100 <sys_open+0x106>
    80005054:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0) {
    80005056:	824ff0ef          	jal	8000407a <filealloc>
    8000505a:	892a                	mv	s2,a0
    8000505c:	cd4d                	beqz	a0,80005116 <sys_open+0x11c>
    8000505e:	ed4e                	sd	s3,152(sp)
    80005060:	a67ff0ef          	jal	80004ac6 <fdalloc>
    80005064:	89aa                	mv	s3,a0
    80005066:	0a054463          	bltz	a0,8000510e <sys_open+0x114>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if (ip->type == T_DEVICE) {
    8000506a:	04449703          	lh	a4,68(s1)
    8000506e:	478d                	li	a5,3
    80005070:	0af70f63          	beq	a4,a5,8000512e <sys_open+0x134>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80005074:	4789                	li	a5,2
    80005076:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000507a:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    8000507e:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80005082:	f4c42783          	lw	a5,-180(s0)
    80005086:	0017f713          	andi	a4,a5,1
    8000508a:	00174713          	xori	a4,a4,1
    8000508e:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005092:	0037f713          	andi	a4,a5,3
    80005096:	00e03733          	snez	a4,a4
    8000509a:	00e904a3          	sb	a4,9(s2)

  if ((omode & O_TRUNC) && ip->type == T_FILE) {
    8000509e:	4007f793          	andi	a5,a5,1024
    800050a2:	c791                	beqz	a5,800050ae <sys_open+0xb4>
    800050a4:	04449703          	lh	a4,68(s1)
    800050a8:	4789                	li	a5,2
    800050aa:	08f70963          	beq	a4,a5,8000513c <sys_open+0x142>
    itrunc(ip);
  }

  iunlock(ip);
    800050ae:	8526                	mv	a0,s1
    800050b0:	a88fe0ef          	jal	80003338 <iunlock>
  end_op();
    800050b4:	c5dfe0ef          	jal	80003d10 <end_op>

  return fd;
    800050b8:	854e                	mv	a0,s3
    800050ba:	74aa                	ld	s1,168(sp)
    800050bc:	790a                	ld	s2,160(sp)
    800050be:	69ea                	ld	s3,152(sp)
    800050c0:	a09d                	j	80005126 <sys_open+0x12c>
      end_op();
    800050c2:	c4ffe0ef          	jal	80003d10 <end_op>
      return -1;
    800050c6:	74aa                	ld	s1,168(sp)
    800050c8:	a8b1                	j	80005124 <sys_open+0x12a>
    if ((ip = namei(path)) == 0) {
    800050ca:	f5040513          	addi	a0,s0,-176
    800050ce:	9f5fe0ef          	jal	80003ac2 <namei>
    800050d2:	84aa                	mv	s1,a0
    800050d4:	c115                	beqz	a0,800050f8 <sys_open+0xfe>
    ilock(ip);
    800050d6:	9b4fe0ef          	jal	8000328a <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY) {
    800050da:	04449703          	lh	a4,68(s1)
    800050de:	4785                	li	a5,1
    800050e0:	f6f710e3          	bne	a4,a5,80005040 <sys_open+0x46>
    800050e4:	f4c42783          	lw	a5,-180(s0)
    800050e8:	d7b5                	beqz	a5,80005054 <sys_open+0x5a>
      iunlockput(ip);
    800050ea:	8526                	mv	a0,s1
    800050ec:	baafe0ef          	jal	80003496 <iunlockput>
      end_op();
    800050f0:	c21fe0ef          	jal	80003d10 <end_op>
      return -1;
    800050f4:	74aa                	ld	s1,168(sp)
    800050f6:	a03d                	j	80005124 <sys_open+0x12a>
      end_op();
    800050f8:	c19fe0ef          	jal	80003d10 <end_op>
      return -1;
    800050fc:	74aa                	ld	s1,168(sp)
    800050fe:	a01d                	j	80005124 <sys_open+0x12a>
    iunlockput(ip);
    80005100:	8526                	mv	a0,s1
    80005102:	b94fe0ef          	jal	80003496 <iunlockput>
    end_op();
    80005106:	c0bfe0ef          	jal	80003d10 <end_op>
    return -1;
    8000510a:	74aa                	ld	s1,168(sp)
    8000510c:	a821                	j	80005124 <sys_open+0x12a>
      fileclose(f);
    8000510e:	854a                	mv	a0,s2
    80005110:	80eff0ef          	jal	8000411e <fileclose>
    80005114:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80005116:	8526                	mv	a0,s1
    80005118:	b7efe0ef          	jal	80003496 <iunlockput>
    end_op();
    8000511c:	bf5fe0ef          	jal	80003d10 <end_op>
    return -1;
    80005120:	74aa                	ld	s1,168(sp)
    80005122:	790a                	ld	s2,160(sp)
    return -1;
    80005124:	557d                	li	a0,-1
}
    80005126:	70ea                	ld	ra,184(sp)
    80005128:	744a                	ld	s0,176(sp)
    8000512a:	6129                	addi	sp,sp,192
    8000512c:	8082                	ret
    f->type = FD_DEVICE;
    8000512e:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80005132:	04649783          	lh	a5,70(s1)
    80005136:	02f91223          	sh	a5,36(s2)
    8000513a:	b791                	j	8000507e <sys_open+0x84>
    itrunc(ip);
    8000513c:	8526                	mv	a0,s1
    8000513e:	a3afe0ef          	jal	80003378 <itrunc>
    80005142:	b7b5                	j	800050ae <sys_open+0xb4>

0000000080005144 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80005144:	7175                	addi	sp,sp,-144
    80005146:	e506                	sd	ra,136(sp)
    80005148:	e122                	sd	s0,128(sp)
    8000514a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000514c:	b55fe0ef          	jal	80003ca0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0) {
    80005150:	08000613          	li	a2,128
    80005154:	f7040593          	addi	a1,s0,-144
    80005158:	4501                	li	a0,0
    8000515a:	ea2fd0ef          	jal	800027fc <argstr>
    8000515e:	02054363          	bltz	a0,80005184 <sys_mkdir+0x40>
    80005162:	4681                	li	a3,0
    80005164:	4601                	li	a2,0
    80005166:	4585                	li	a1,1
    80005168:	f7040513          	addi	a0,s0,-144
    8000516c:	999ff0ef          	jal	80004b04 <create>
    80005170:	c911                	beqz	a0,80005184 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80005172:	b24fe0ef          	jal	80003496 <iunlockput>
  end_op();
    80005176:	b9bfe0ef          	jal	80003d10 <end_op>
  return 0;
    8000517a:	4501                	li	a0,0
}
    8000517c:	60aa                	ld	ra,136(sp)
    8000517e:	640a                	ld	s0,128(sp)
    80005180:	6149                	addi	sp,sp,144
    80005182:	8082                	ret
    end_op();
    80005184:	b8dfe0ef          	jal	80003d10 <end_op>
    return -1;
    80005188:	557d                	li	a0,-1
    8000518a:	bfcd                	j	8000517c <sys_mkdir+0x38>

000000008000518c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000518c:	7135                	addi	sp,sp,-160
    8000518e:	ed06                	sd	ra,152(sp)
    80005190:	e922                	sd	s0,144(sp)
    80005192:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80005194:	b0dfe0ef          	jal	80003ca0 <begin_op>
  argint(1, &major);
    80005198:	f6c40593          	addi	a1,s0,-148
    8000519c:	4505                	li	a0,1
    8000519e:	e26fd0ef          	jal	800027c4 <argint>
  argint(2, &minor);
    800051a2:	f6840593          	addi	a1,s0,-152
    800051a6:	4509                	li	a0,2
    800051a8:	e1cfd0ef          	jal	800027c4 <argint>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800051ac:	08000613          	li	a2,128
    800051b0:	f7040593          	addi	a1,s0,-144
    800051b4:	4501                	li	a0,0
    800051b6:	e46fd0ef          	jal	800027fc <argstr>
    800051ba:	02054563          	bltz	a0,800051e4 <sys_mknod+0x58>
      (ip = create(path, T_DEVICE, major, minor)) == 0) {
    800051be:	f6841683          	lh	a3,-152(s0)
    800051c2:	f6c41603          	lh	a2,-148(s0)
    800051c6:	458d                	li	a1,3
    800051c8:	f7040513          	addi	a0,s0,-144
    800051cc:	939ff0ef          	jal	80004b04 <create>
  if ((argstr(0, path, MAXPATH)) < 0 ||
    800051d0:	c911                	beqz	a0,800051e4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800051d2:	ac4fe0ef          	jal	80003496 <iunlockput>
  end_op();
    800051d6:	b3bfe0ef          	jal	80003d10 <end_op>
  return 0;
    800051da:	4501                	li	a0,0
}
    800051dc:	60ea                	ld	ra,152(sp)
    800051de:	644a                	ld	s0,144(sp)
    800051e0:	610d                	addi	sp,sp,160
    800051e2:	8082                	ret
    end_op();
    800051e4:	b2dfe0ef          	jal	80003d10 <end_op>
    return -1;
    800051e8:	557d                	li	a0,-1
    800051ea:	bfcd                	j	800051dc <sys_mknod+0x50>

00000000800051ec <sys_chdir>:

uint64
sys_chdir(void)
{
    800051ec:	7135                	addi	sp,sp,-160
    800051ee:	ed06                	sd	ra,152(sp)
    800051f0:	e922                	sd	s0,144(sp)
    800051f2:	e14a                	sd	s2,128(sp)
    800051f4:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800051f6:	ee8fc0ef          	jal	800018de <myproc>
    800051fa:	892a                	mv	s2,a0

  begin_op();
    800051fc:	aa5fe0ef          	jal	80003ca0 <begin_op>
  if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0) {
    80005200:	08000613          	li	a2,128
    80005204:	f6040593          	addi	a1,s0,-160
    80005208:	4501                	li	a0,0
    8000520a:	df2fd0ef          	jal	800027fc <argstr>
    8000520e:	02054f63          	bltz	a0,8000524c <sys_chdir+0x60>
    80005212:	e526                	sd	s1,136(sp)
    80005214:	f6040513          	addi	a0,s0,-160
    80005218:	8abfe0ef          	jal	80003ac2 <namei>
    8000521c:	84aa                	mv	s1,a0
    8000521e:	c515                	beqz	a0,8000524a <sys_chdir+0x5e>
    end_op();
    return -1;
  }
  ilock(ip);
    80005220:	86afe0ef          	jal	8000328a <ilock>
  if (ip->type != T_DIR) {
    80005224:	04449703          	lh	a4,68(s1)
    80005228:	4785                	li	a5,1
    8000522a:	02f71963          	bne	a4,a5,8000525c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    8000522e:	8526                	mv	a0,s1
    80005230:	908fe0ef          	jal	80003338 <iunlock>
  iput(p->cwd);
    80005234:	15093503          	ld	a0,336(s2)
    80005238:	9d4fe0ef          	jal	8000340c <iput>
  end_op();
    8000523c:	ad5fe0ef          	jal	80003d10 <end_op>
  p->cwd = ip;
    80005240:	14993823          	sd	s1,336(s2)
  return 0;
    80005244:	4501                	li	a0,0
    80005246:	64aa                	ld	s1,136(sp)
    80005248:	a029                	j	80005252 <sys_chdir+0x66>
    8000524a:	64aa                	ld	s1,136(sp)
    end_op();
    8000524c:	ac5fe0ef          	jal	80003d10 <end_op>
    return -1;
    80005250:	557d                	li	a0,-1
}
    80005252:	60ea                	ld	ra,152(sp)
    80005254:	644a                	ld	s0,144(sp)
    80005256:	690a                	ld	s2,128(sp)
    80005258:	610d                	addi	sp,sp,160
    8000525a:	8082                	ret
    iunlockput(ip);
    8000525c:	8526                	mv	a0,s1
    8000525e:	a38fe0ef          	jal	80003496 <iunlockput>
    end_op();
    80005262:	aaffe0ef          	jal	80003d10 <end_op>
    return -1;
    80005266:	64aa                	ld	s1,136(sp)
    80005268:	b7e5                	j	80005250 <sys_chdir+0x64>

000000008000526a <sys_exec>:

uint64
sys_exec(void)
{
    8000526a:	7105                	addi	sp,sp,-480
    8000526c:	ef86                	sd	ra,472(sp)
    8000526e:	eba2                	sd	s0,464(sp)
    80005270:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80005272:	e2840593          	addi	a1,s0,-472
    80005276:	4505                	li	a0,1
    80005278:	d68fd0ef          	jal	800027e0 <argaddr>
  if (argstr(0, path, MAXPATH) < 0) {
    8000527c:	08000613          	li	a2,128
    80005280:	f3040593          	addi	a1,s0,-208
    80005284:	4501                	li	a0,0
    80005286:	d76fd0ef          	jal	800027fc <argstr>
    8000528a:	0c054e63          	bltz	a0,80005366 <sys_exec+0xfc>
    8000528e:	e7a6                	sd	s1,456(sp)
    80005290:	e3ca                	sd	s2,448(sp)
    80005292:	ff4e                	sd	s3,440(sp)
    80005294:	fb52                	sd	s4,432(sp)
    80005296:	f756                	sd	s5,424(sp)
    80005298:	f35a                	sd	s6,416(sp)
    8000529a:	ef5e                	sd	s7,408(sp)
    return -1;
  }
  memset(argv, 0, sizeof(argv));
    8000529c:	e3040a13          	addi	s4,s0,-464
    800052a0:	10000613          	li	a2,256
    800052a4:	4581                	li	a1,0
    800052a6:	8552                	mv	a0,s4
    800052a8:	a2dfb0ef          	jal	80000cd4 <memset>
  for (i = 0;; i++) {
    if (i >= NELEM(argv)) {
    800052ac:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800052ae:	89d2                	mv	s3,s4
    800052b0:	4901                	li	s2,0
      goto bad;
    }
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800052b2:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if (argv[i] == 0)
      goto bad;
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052b6:	6b05                	lui	s6,0x1
    if (i >= NELEM(argv)) {
    800052b8:	02000b93          	li	s7,32
    if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0) {
    800052bc:	00391513          	slli	a0,s2,0x3
    800052c0:	85d6                	mv	a1,s5
    800052c2:	e2843783          	ld	a5,-472(s0)
    800052c6:	953e                	add	a0,a0,a5
    800052c8:	c76fd0ef          	jal	8000273e <fetchaddr>
    800052cc:	02054663          	bltz	a0,800052f8 <sys_exec+0x8e>
    if (uarg == 0) {
    800052d0:	e2043783          	ld	a5,-480(s0)
    800052d4:	c3b9                	beqz	a5,8000531a <sys_exec+0xb0>
    argv[i] = kalloc();
    800052d6:	869fb0ef          	jal	80000b3e <kalloc>
    800052da:	85aa                	mv	a1,a0
    800052dc:	00a9b023          	sd	a0,0(s3)
    if (argv[i] == 0)
    800052e0:	cd01                	beqz	a0,800052f8 <sys_exec+0x8e>
    if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052e2:	865a                	mv	a2,s6
    800052e4:	e2043503          	ld	a0,-480(s0)
    800052e8:	c9cfd0ef          	jal	80002784 <fetchstr>
    800052ec:	00054663          	bltz	a0,800052f8 <sys_exec+0x8e>
    if (i >= NELEM(argv)) {
    800052f0:	0905                	addi	s2,s2,1
    800052f2:	09a1                	addi	s3,s3,8
    800052f4:	fd7914e3          	bne	s2,s7,800052bc <sys_exec+0x52>
    kfree(argv[i]);

  return ret;

bad:
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052f8:	100a0a13          	addi	s4,s4,256
    800052fc:	6088                	ld	a0,0(s1)
    800052fe:	cd29                	beqz	a0,80005358 <sys_exec+0xee>
    kfree(argv[i]);
    80005300:	f56fb0ef          	jal	80000a56 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005304:	04a1                	addi	s1,s1,8
    80005306:	ff449be3          	bne	s1,s4,800052fc <sys_exec+0x92>
    8000530a:	64be                	ld	s1,456(sp)
    8000530c:	691e                	ld	s2,448(sp)
    8000530e:	79fa                	ld	s3,440(sp)
    80005310:	7a5a                	ld	s4,432(sp)
    80005312:	7aba                	ld	s5,424(sp)
    80005314:	7b1a                	ld	s6,416(sp)
    80005316:	6bfa                	ld	s7,408(sp)
    80005318:	a0b9                	j	80005366 <sys_exec+0xfc>
      argv[i] = 0;
    8000531a:	0009079b          	sext.w	a5,s2
    8000531e:	e3040593          	addi	a1,s0,-464
    80005322:	078e                	slli	a5,a5,0x3
    80005324:	97ae                	add	a5,a5,a1
    80005326:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000532a:	f3040513          	addi	a0,s0,-208
    8000532e:	c30ff0ef          	jal	8000475e <kexec>
    80005332:	892a                	mv	s2,a0
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005334:	100a0a13          	addi	s4,s4,256
    80005338:	6088                	ld	a0,0(s1)
    8000533a:	c511                	beqz	a0,80005346 <sys_exec+0xdc>
    kfree(argv[i]);
    8000533c:	f1afb0ef          	jal	80000a56 <kfree>
  for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005340:	04a1                	addi	s1,s1,8
    80005342:	ff449be3          	bne	s1,s4,80005338 <sys_exec+0xce>
  return ret;
    80005346:	854a                	mv	a0,s2
    80005348:	64be                	ld	s1,456(sp)
    8000534a:	691e                	ld	s2,448(sp)
    8000534c:	79fa                	ld	s3,440(sp)
    8000534e:	7a5a                	ld	s4,432(sp)
    80005350:	7aba                	ld	s5,424(sp)
    80005352:	7b1a                	ld	s6,416(sp)
    80005354:	6bfa                	ld	s7,408(sp)
    80005356:	a809                	j	80005368 <sys_exec+0xfe>
    80005358:	64be                	ld	s1,456(sp)
    8000535a:	691e                	ld	s2,448(sp)
    8000535c:	79fa                	ld	s3,440(sp)
    8000535e:	7a5a                	ld	s4,432(sp)
    80005360:	7aba                	ld	s5,424(sp)
    80005362:	7b1a                	ld	s6,416(sp)
    80005364:	6bfa                	ld	s7,408(sp)
    return -1;
    80005366:	557d                	li	a0,-1
  return -1;
}
    80005368:	60fe                	ld	ra,472(sp)
    8000536a:	645e                	ld	s0,464(sp)
    8000536c:	613d                	addi	sp,sp,480
    8000536e:	8082                	ret

0000000080005370 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005370:	7139                	addi	sp,sp,-64
    80005372:	fc06                	sd	ra,56(sp)
    80005374:	f822                	sd	s0,48(sp)
    80005376:	f426                	sd	s1,40(sp)
    80005378:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000537a:	d64fc0ef          	jal	800018de <myproc>
    8000537e:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80005380:	fd840593          	addi	a1,s0,-40
    80005384:	4501                	li	a0,0
    80005386:	c5afd0ef          	jal	800027e0 <argaddr>
  if (pipealloc(&rf, &wf) < 0)
    8000538a:	fc840593          	addi	a1,s0,-56
    8000538e:	fd040513          	addi	a0,s0,-48
    80005392:	89aff0ef          	jal	8000442c <pipealloc>
    80005396:	0a054463          	bltz	a0,8000543e <sys_pipe+0xce>
    return -1;
  fd0 = -1;
    8000539a:	57fd                	li	a5,-1
    8000539c:	fcf42223          	sw	a5,-60(s0)
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0) {
    800053a0:	fd043503          	ld	a0,-48(s0)
    800053a4:	f22ff0ef          	jal	80004ac6 <fdalloc>
    800053a8:	fca42223          	sw	a0,-60(s0)
    800053ac:	08054163          	bltz	a0,8000542e <sys_pipe+0xbe>
    800053b0:	fc843503          	ld	a0,-56(s0)
    800053b4:	f12ff0ef          	jal	80004ac6 <fdalloc>
    800053b8:	fca42023          	sw	a0,-64(s0)
    800053bc:	06054063          	bltz	a0,8000541c <sys_pipe+0xac>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053c0:	4691                	li	a3,4
    800053c2:	fc440613          	addi	a2,s0,-60
    800053c6:	fd843583          	ld	a1,-40(s0)
    800053ca:	68a8                	ld	a0,80(s1)
    800053cc:	a44fc0ef          	jal	80001610 <copyout>
    800053d0:	00054f63          	bltz	a0,800053ee <sys_pipe+0x7e>
      copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) <
    800053d4:	4691                	li	a3,4
    800053d6:	fc040613          	addi	a2,s0,-64
    800053da:	fd843583          	ld	a1,-40(s0)
    800053de:	95b6                	add	a1,a1,a3
    800053e0:	68a8                	ld	a0,80(s1)
    800053e2:	a2efc0ef          	jal	80001610 <copyout>
    800053e6:	87aa                	mv	a5,a0
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800053e8:	4501                	li	a0,0
  if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053ea:	0407db63          	bgez	a5,80005440 <sys_pipe+0xd0>
    p->ofile[fd0] = 0;
    800053ee:	fc442783          	lw	a5,-60(s0)
    800053f2:	07e9                	addi	a5,a5,26
    800053f4:	078e                	slli	a5,a5,0x3
    800053f6:	97a6                	add	a5,a5,s1
    800053f8:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800053fc:	fc042783          	lw	a5,-64(s0)
    80005400:	07e9                	addi	a5,a5,26
    80005402:	078e                	slli	a5,a5,0x3
    80005404:	97a6                	add	a5,a5,s1
    80005406:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000540a:	fd043503          	ld	a0,-48(s0)
    8000540e:	d11fe0ef          	jal	8000411e <fileclose>
    fileclose(wf);
    80005412:	fc843503          	ld	a0,-56(s0)
    80005416:	d09fe0ef          	jal	8000411e <fileclose>
    return -1;
    8000541a:	a015                	j	8000543e <sys_pipe+0xce>
    if (fd0 >= 0)
    8000541c:	fc442783          	lw	a5,-60(s0)
    80005420:	0007c763          	bltz	a5,8000542e <sys_pipe+0xbe>
      p->ofile[fd0] = 0;
    80005424:	07e9                	addi	a5,a5,26
    80005426:	078e                	slli	a5,a5,0x3
    80005428:	97a6                	add	a5,a5,s1
    8000542a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000542e:	fd043503          	ld	a0,-48(s0)
    80005432:	cedfe0ef          	jal	8000411e <fileclose>
    fileclose(wf);
    80005436:	fc843503          	ld	a0,-56(s0)
    8000543a:	ce5fe0ef          	jal	8000411e <fileclose>
    return -1;
    8000543e:	557d                	li	a0,-1
}
    80005440:	70e2                	ld	ra,56(sp)
    80005442:	7442                	ld	s0,48(sp)
    80005444:	74a2                	ld	s1,40(sp)
    80005446:	6121                	addi	sp,sp,64
    80005448:	8082                	ret
    8000544a:	0000                	unimp
    8000544c:	0000                	unimp
	...

0000000080005450 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80005450:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80005452:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80005454:	e80e                	sd	gp,16(sp)
        # sd tp, 24(sp)
        sd t0, 32(sp)
    80005456:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80005458:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000545a:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000545c:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    8000545e:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80005460:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80005462:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80005464:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80005466:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80005468:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000546a:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000546c:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    8000546e:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80005470:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80005472:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80005474:	9d8fd0ef          	jal	8000264c <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80005478:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000547a:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000547c:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    8000547e:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80005480:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80005482:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80005484:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80005486:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80005488:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000548a:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000548c:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    8000548e:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80005490:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80005492:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80005494:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80005496:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80005498:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000549a:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000549c:	10200073          	sret
    800054a0:	0001                	nop
    800054a2:	00000013          	nop
    800054a6:	00000013          	nop
    800054aa:	00000013          	nop

00000000800054ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054ae:	1141                	addi	sp,sp,-16
    800054b0:	e406                	sd	ra,8(sp)
    800054b2:	e022                	sd	s0,0(sp)
    800054b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32 *)(PLIC + UART0_IRQ * 4) = 1;
    800054b6:	0c000737          	lui	a4,0xc000
    800054ba:	4785                	li	a5,1
    800054bc:	d71c                	sw	a5,40(a4)
  *(uint32 *)(PLIC + VIRTIO0_IRQ * 4) = 1;
    800054be:	c35c                	sw	a5,4(a4)
}
    800054c0:	60a2                	ld	ra,8(sp)
    800054c2:	6402                	ld	s0,0(sp)
    800054c4:	0141                	addi	sp,sp,16
    800054c6:	8082                	ret

00000000800054c8 <plicinithart>:

void
plicinithart(void)
{
    800054c8:	1141                	addi	sp,sp,-16
    800054ca:	e406                	sd	ra,8(sp)
    800054cc:	e022                	sd	s0,0(sp)
    800054ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054d0:	bdafc0ef          	jal	800018aa <cpuid>

  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32 *)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054d4:	0085171b          	slliw	a4,a0,0x8
    800054d8:	0c0027b7          	lui	a5,0xc002
    800054dc:	97ba                	add	a5,a5,a4
    800054de:	40200713          	li	a4,1026
    800054e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32 *)PLIC_SPRIORITY(hart) = 0;
    800054e6:	00d5151b          	slliw	a0,a0,0xd
    800054ea:	0c2017b7          	lui	a5,0xc201
    800054ee:	97aa                	add	a5,a5,a0
    800054f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800054f4:	60a2                	ld	ra,8(sp)
    800054f6:	6402                	ld	s0,0(sp)
    800054f8:	0141                	addi	sp,sp,16
    800054fa:	8082                	ret

00000000800054fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800054fc:	1141                	addi	sp,sp,-16
    800054fe:	e406                	sd	ra,8(sp)
    80005500:	e022                	sd	s0,0(sp)
    80005502:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005504:	ba6fc0ef          	jal	800018aa <cpuid>
  int irq = *(uint32 *)PLIC_SCLAIM(hart);
    80005508:	00d5151b          	slliw	a0,a0,0xd
    8000550c:	0c2017b7          	lui	a5,0xc201
    80005510:	97aa                	add	a5,a5,a0
  return irq;
}
    80005512:	43c8                	lw	a0,4(a5)
    80005514:	60a2                	ld	ra,8(sp)
    80005516:	6402                	ld	s0,0(sp)
    80005518:	0141                	addi	sp,sp,16
    8000551a:	8082                	ret

000000008000551c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000551c:	1101                	addi	sp,sp,-32
    8000551e:	ec06                	sd	ra,24(sp)
    80005520:	e822                	sd	s0,16(sp)
    80005522:	e426                	sd	s1,8(sp)
    80005524:	1000                	addi	s0,sp,32
    80005526:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005528:	b82fc0ef          	jal	800018aa <cpuid>
  *(uint32 *)PLIC_SCLAIM(hart) = irq;
    8000552c:	00d5179b          	slliw	a5,a0,0xd
    80005530:	0c201737          	lui	a4,0xc201
    80005534:	97ba                	add	a5,a5,a4
    80005536:	c3c4                	sw	s1,4(a5)
}
    80005538:	60e2                	ld	ra,24(sp)
    8000553a:	6442                	ld	s0,16(sp)
    8000553c:	64a2                	ld	s1,8(sp)
    8000553e:	6105                	addi	sp,sp,32
    80005540:	8082                	ret

0000000080005542 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005542:	1141                	addi	sp,sp,-16
    80005544:	e406                	sd	ra,8(sp)
    80005546:	e022                	sd	s0,0(sp)
    80005548:	0800                	addi	s0,sp,16
  if (i >= NUM)
    8000554a:	479d                	li	a5,7
    8000554c:	04a7ca63          	blt	a5,a0,800055a0 <free_desc+0x5e>
    panic("free_desc 1");
  if (disk.free[i])
    80005550:	0001c797          	auipc	a5,0x1c
    80005554:	8d878793          	addi	a5,a5,-1832 # 80020e28 <disk>
    80005558:	97aa                	add	a5,a5,a0
    8000555a:	0187c783          	lbu	a5,24(a5)
    8000555e:	e7b9                	bnez	a5,800055ac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005560:	00451693          	slli	a3,a0,0x4
    80005564:	0001c797          	auipc	a5,0x1c
    80005568:	8c478793          	addi	a5,a5,-1852 # 80020e28 <disk>
    8000556c:	6398                	ld	a4,0(a5)
    8000556e:	9736                	add	a4,a4,a3
    80005570:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80005574:	6398                	ld	a4,0(a5)
    80005576:	9736                	add	a4,a4,a3
    80005578:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000557c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005580:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005584:	97aa                	add	a5,a5,a0
    80005586:	4705                	li	a4,1
    80005588:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000558c:	0001c517          	auipc	a0,0x1c
    80005590:	8b450513          	addi	a0,a0,-1868 # 80020e40 <disk+0x18>
    80005594:	991fc0ef          	jal	80001f24 <wakeup>
}
    80005598:	60a2                	ld	ra,8(sp)
    8000559a:	6402                	ld	s0,0(sp)
    8000559c:	0141                	addi	sp,sp,16
    8000559e:	8082                	ret
    panic("free_desc 1");
    800055a0:	00002517          	auipc	a0,0x2
    800055a4:	16050513          	addi	a0,a0,352 # 80007700 <etext+0x700>
    800055a8:	a92fb0ef          	jal	8000083a <panic>
    panic("free_desc 2");
    800055ac:	00002517          	auipc	a0,0x2
    800055b0:	16450513          	addi	a0,a0,356 # 80007710 <etext+0x710>
    800055b4:	a86fb0ef          	jal	8000083a <panic>

00000000800055b8 <virtio_disk_init>:
{
    800055b8:	1101                	addi	sp,sp,-32
    800055ba:	ec06                	sd	ra,24(sp)
    800055bc:	e822                	sd	s0,16(sp)
    800055be:	e426                	sd	s1,8(sp)
    800055c0:	e04a                	sd	s2,0(sp)
    800055c2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055c4:	00002597          	auipc	a1,0x2
    800055c8:	15c58593          	addi	a1,a1,348 # 80007720 <etext+0x720>
    800055cc:	0001c517          	auipc	a0,0x1c
    800055d0:	98450513          	addi	a0,a0,-1660 # 80020f50 <disk+0x128>
    800055d4:	dc4fb0ef          	jal	80000b98 <initlock>
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055d8:	100017b7          	lui	a5,0x10001
    800055dc:	4398                	lw	a4,0(a5)
    800055de:	747277b7          	lui	a5,0x74727
    800055e2:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800055e6:	14f71263          	bne	a4,a5,8000572a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055ea:	100017b7          	lui	a5,0x10001
    800055ee:	43d8                	lw	a4,4(a5)
  if (*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055f0:	4789                	li	a5,2
    800055f2:	12f71c63          	bne	a4,a5,8000572a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055f6:	100017b7          	lui	a5,0x10001
    800055fa:	4798                	lw	a4,8(a5)
    800055fc:	4789                	li	a5,2
    800055fe:	12f71663          	bne	a4,a5,8000572a <virtio_disk_init+0x172>
      *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551) {
    80005602:	100017b7          	lui	a5,0x10001
    80005606:	47d8                	lw	a4,12(a5)
      *R(VIRTIO_MMIO_VERSION) != 2 || *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005608:	554d47b7          	lui	a5,0x554d4
    8000560c:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005610:	10f71d63          	bne	a4,a5,8000572a <virtio_disk_init+0x172>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005614:	100017b7          	lui	a5,0x10001
    80005618:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000561c:	4705                	li	a4,1
    8000561e:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005620:	470d                	li	a4,3
    80005622:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80005624:	10001737          	lui	a4,0x10001
    80005628:	4b18                	lw	a4,16(a4)
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000562a:	c7ffe6b7          	lui	a3,0xc7ffe
    8000562e:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd7d7>
    80005632:	8f75                	and	a4,a4,a3
    80005634:	100016b7          	lui	a3,0x10001
    80005638:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563a:	472d                	li	a4,11
    8000563c:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    8000563e:	0707a903          	lw	s2,112(a5)
  if (!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005642:	00897793          	andi	a5,s2,8
    80005646:	0e078863          	beqz	a5,80005736 <virtio_disk_init+0x17e>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    8000564a:	100017b7          	lui	a5,0x10001
    8000564e:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if (*R(VIRTIO_MMIO_QUEUE_READY))
    80005652:	43fc                	lw	a5,68(a5)
    80005654:	0e079763          	bnez	a5,80005742 <virtio_disk_init+0x18a>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005658:	100017b7          	lui	a5,0x10001
    8000565c:	5bdc                	lw	a5,52(a5)
  if (max == 0)
    8000565e:	0e078863          	beqz	a5,8000574e <virtio_disk_init+0x196>
  if (max < NUM)
    80005662:	471d                	li	a4,7
    80005664:	0ef77b63          	bgeu	a4,a5,8000575a <virtio_disk_init+0x1a2>
  disk.desc = kalloc();
    80005668:	cd6fb0ef          	jal	80000b3e <kalloc>
    8000566c:	0001b497          	auipc	s1,0x1b
    80005670:	7bc48493          	addi	s1,s1,1980 # 80020e28 <disk>
    80005674:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005676:	cc8fb0ef          	jal	80000b3e <kalloc>
    8000567a:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000567c:	cc2fb0ef          	jal	80000b3e <kalloc>
    80005680:	87aa                	mv	a5,a0
    80005682:	e888                	sd	a0,16(s1)
  if (!disk.desc || !disk.avail || !disk.used)
    80005684:	6088                	ld	a0,0(s1)
    80005686:	0e050063          	beqz	a0,80005766 <virtio_disk_init+0x1ae>
    8000568a:	0001b717          	auipc	a4,0x1b
    8000568e:	7a673703          	ld	a4,1958(a4) # 80020e30 <disk+0x8>
    80005692:	00173713          	seqz	a4,a4
    80005696:	0017b793          	seqz	a5,a5
    8000569a:	8fd9                	or	a5,a5,a4
    8000569c:	e7e9                	bnez	a5,80005766 <virtio_disk_init+0x1ae>
  memset(disk.desc, 0, PGSIZE);
    8000569e:	6605                	lui	a2,0x1
    800056a0:	4581                	li	a1,0
    800056a2:	e32fb0ef          	jal	80000cd4 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056a6:	0001b497          	auipc	s1,0x1b
    800056aa:	78248493          	addi	s1,s1,1922 # 80020e28 <disk>
    800056ae:	6605                	lui	a2,0x1
    800056b0:	4581                	li	a1,0
    800056b2:	6488                	ld	a0,8(s1)
    800056b4:	e20fb0ef          	jal	80000cd4 <memset>
  memset(disk.used, 0, PGSIZE);
    800056b8:	6605                	lui	a2,0x1
    800056ba:	4581                	li	a1,0
    800056bc:	6888                	ld	a0,16(s1)
    800056be:	e16fb0ef          	jal	80000cd4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056c2:	100017b7          	lui	a5,0x10001
    800056c6:	4721                	li	a4,8
    800056c8:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800056ca:	4098                	lw	a4,0(s1)
    800056cc:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800056d0:	40d8                	lw	a4,4(s1)
    800056d2:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800056d6:	649c                	ld	a5,8(s1)
    800056d8:	10001737          	lui	a4,0x10001
    800056dc:	08f72823          	sw	a5,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800056e0:	9781                	srai	a5,a5,0x20
    800056e2:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800056e6:	689c                	ld	a5,16(s1)
    800056e8:	0af72023          	sw	a5,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056ec:	9781                	srai	a5,a5,0x20
    800056ee:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056f2:	4785                	li	a5,1
    800056f4:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800056f6:	00f48c23          	sb	a5,24(s1)
    800056fa:	00f48ca3          	sb	a5,25(s1)
    800056fe:	00f48d23          	sb	a5,26(s1)
    80005702:	00f48da3          	sb	a5,27(s1)
    80005706:	00f48e23          	sb	a5,28(s1)
    8000570a:	00f48ea3          	sb	a5,29(s1)
    8000570e:	00f48f23          	sb	a5,30(s1)
    80005712:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005716:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    8000571a:	07272823          	sw	s2,112(a4)
}
    8000571e:	60e2                	ld	ra,24(sp)
    80005720:	6442                	ld	s0,16(sp)
    80005722:	64a2                	ld	s1,8(sp)
    80005724:	6902                	ld	s2,0(sp)
    80005726:	6105                	addi	sp,sp,32
    80005728:	8082                	ret
    panic("could not find virtio disk");
    8000572a:	00002517          	auipc	a0,0x2
    8000572e:	00650513          	addi	a0,a0,6 # 80007730 <etext+0x730>
    80005732:	908fb0ef          	jal	8000083a <panic>
    panic("virtio disk FEATURES_OK unset");
    80005736:	00002517          	auipc	a0,0x2
    8000573a:	01a50513          	addi	a0,a0,26 # 80007750 <etext+0x750>
    8000573e:	8fcfb0ef          	jal	8000083a <panic>
    panic("virtio disk should not be ready");
    80005742:	00002517          	auipc	a0,0x2
    80005746:	02e50513          	addi	a0,a0,46 # 80007770 <etext+0x770>
    8000574a:	8f0fb0ef          	jal	8000083a <panic>
    panic("virtio disk has no queue 0");
    8000574e:	00002517          	auipc	a0,0x2
    80005752:	04250513          	addi	a0,a0,66 # 80007790 <etext+0x790>
    80005756:	8e4fb0ef          	jal	8000083a <panic>
    panic("virtio disk max queue too short");
    8000575a:	00002517          	auipc	a0,0x2
    8000575e:	05650513          	addi	a0,a0,86 # 800077b0 <etext+0x7b0>
    80005762:	8d8fb0ef          	jal	8000083a <panic>
    panic("virtio disk kalloc");
    80005766:	00002517          	auipc	a0,0x2
    8000576a:	06a50513          	addi	a0,a0,106 # 800077d0 <etext+0x7d0>
    8000576e:	8ccfb0ef          	jal	8000083a <panic>

0000000080005772 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005772:	711d                	addi	sp,sp,-96
    80005774:	ec86                	sd	ra,88(sp)
    80005776:	e8a2                	sd	s0,80(sp)
    80005778:	e4a6                	sd	s1,72(sp)
    8000577a:	e0ca                	sd	s2,64(sp)
    8000577c:	fc4e                	sd	s3,56(sp)
    8000577e:	f852                	sd	s4,48(sp)
    80005780:	f456                	sd	s5,40(sp)
    80005782:	f05a                	sd	s6,32(sp)
    80005784:	ec5e                	sd	s7,24(sp)
    80005786:	e862                	sd	s8,16(sp)
    80005788:	1080                	addi	s0,sp,96
    8000578a:	89aa                	mv	s3,a0
    8000578c:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000578e:	00c52b83          	lw	s7,12(a0)
    80005792:	001b9b9b          	slliw	s7,s7,0x1
    80005796:	1b82                	slli	s7,s7,0x20
    80005798:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000579c:	0001b517          	auipc	a0,0x1b
    800057a0:	7b450513          	addi	a0,a0,1972 # 80020f50 <disk+0x128>
    800057a4:	c74fb0ef          	jal	80000c18 <acquire>
  for (int i = 0; i < NUM; i++) {
    800057a8:	44a1                	li	s1,8
      disk.free[i] = 0;
    800057aa:	0001ba97          	auipc	s5,0x1b
    800057ae:	67ea8a93          	addi	s5,s5,1662 # 80020e28 <disk>
  for (int i = 0; i < 3; i++) {
    800057b2:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800057b4:	5c7d                	li	s8,-1
    800057b6:	a095                	j	8000581a <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800057b8:	00fa8733          	add	a4,s5,a5
    800057bc:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800057c0:	c19c                	sw	a5,0(a1)
    if (idx[i] < 0) {
    800057c2:	0207c563          	bltz	a5,800057ec <virtio_disk_rw+0x7a>
  for (int i = 0; i < 3; i++) {
    800057c6:	2905                	addiw	s2,s2,1
    800057c8:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800057ca:	05490c63          	beq	s2,s4,80005822 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800057ce:	85b2                	mv	a1,a2
  for (int i = 0; i < NUM; i++) {
    800057d0:	0001b717          	auipc	a4,0x1b
    800057d4:	65870713          	addi	a4,a4,1624 # 80020e28 <disk>
    800057d8:	4781                	li	a5,0
    if (disk.free[i]) {
    800057da:	01874683          	lbu	a3,24(a4)
    800057de:	fee9                	bnez	a3,800057b8 <virtio_disk_rw+0x46>
  for (int i = 0; i < NUM; i++) {
    800057e0:	2785                	addiw	a5,a5,1
    800057e2:	0705                	addi	a4,a4,1
    800057e4:	fe979be3          	bne	a5,s1,800057da <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800057e8:	0185a023          	sw	s8,0(a1)
      for (int j = 0; j < i; j++)
    800057ec:	01205d63          	blez	s2,80005806 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800057f0:	fa042503          	lw	a0,-96(s0)
    800057f4:	d4fff0ef          	jal	80005542 <free_desc>
      for (int j = 0; j < i; j++)
    800057f8:	4785                	li	a5,1
    800057fa:	0127d663          	bge	a5,s2,80005806 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800057fe:	fa442503          	lw	a0,-92(s0)
    80005802:	d41ff0ef          	jal	80005542 <free_desc>
  int idx[3];
  while (1) {
    if (alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005806:	0001b597          	auipc	a1,0x1b
    8000580a:	74a58593          	addi	a1,a1,1866 # 80020f50 <disk+0x128>
    8000580e:	0001b517          	auipc	a0,0x1b
    80005812:	63250513          	addi	a0,a0,1586 # 80020e40 <disk+0x18>
    80005816:	ec2fc0ef          	jal	80001ed8 <sleep>
  for (int i = 0; i < 3; i++) {
    8000581a:	fa040613          	addi	a2,s0,-96
    8000581e:	4901                	li	s2,0
    80005820:	b77d                	j	800057ce <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005822:	fa042503          	lw	a0,-96(s0)
    80005826:	00451693          	slli	a3,a0,0x4

  if (write)
    8000582a:	0001b797          	auipc	a5,0x1b
    8000582e:	5fe78793          	addi	a5,a5,1534 # 80020e28 <disk>
    80005832:	00451713          	slli	a4,a0,0x4
    80005836:	0a070713          	addi	a4,a4,160
    8000583a:	973e                	add	a4,a4,a5
    8000583c:	01603633          	snez	a2,s6
    80005840:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005842:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005846:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64)buf0;
    8000584a:	6398                	ld	a4,0(a5)
    8000584c:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000584e:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005852:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64)buf0;
    80005854:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005856:	6390                	ld	a2,0(a5)
    80005858:	00d605b3          	add	a1,a2,a3
    8000585c:	4741                	li	a4,16
    8000585e:	c598                	sw	a4,8(a1)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005860:	4805                	li	a6,1
    80005862:	01059623          	sh	a6,12(a1)
  disk.desc[idx[0]].next = idx[1];
    80005866:	fa442703          	lw	a4,-92(s0)
    8000586a:	00e59723          	sh	a4,14(a1)

  disk.desc[idx[1]].addr = (uint64)b->data;
    8000586e:	0712                	slli	a4,a4,0x4
    80005870:	963a                	add	a2,a2,a4
    80005872:	05898593          	addi	a1,s3,88
    80005876:	e20c                	sd	a1,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80005878:	0007b883          	ld	a7,0(a5)
    8000587c:	9746                	add	a4,a4,a7
    8000587e:	40000613          	li	a2,1024
    80005882:	c710                	sw	a2,8(a4)
  if (write)
    80005884:	001b3613          	seqz	a2,s6
    80005888:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000588c:	01066633          	or	a2,a2,a6
    80005890:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005894:	fa842583          	lw	a1,-88(s0)
    80005898:	00b71723          	sh	a1,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000589c:	00250613          	addi	a2,a0,2
    800058a0:	0612                	slli	a2,a2,0x4
    800058a2:	963e                	add	a2,a2,a5
    800058a4:	577d                	li	a4,-1
    800058a6:	00e60823          	sb	a4,16(a2)
  disk.desc[idx[2]].addr = (uint64)&disk.info[idx[0]].status;
    800058aa:	0592                	slli	a1,a1,0x4
    800058ac:	98ae                	add	a7,a7,a1
    800058ae:	03068713          	addi	a4,a3,48
    800058b2:	973e                	add	a4,a4,a5
    800058b4:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800058b8:	6398                	ld	a4,0(a5)
    800058ba:	972e                	add	a4,a4,a1
    800058bc:	01072423          	sw	a6,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058c0:	4689                	li	a3,2
    800058c2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800058c6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058ca:	0109a223          	sw	a6,4(s3)
  disk.info[idx[0]].b = b;
    800058ce:	01363423          	sd	s3,8(a2)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058d2:	6794                	ld	a3,8(a5)
    800058d4:	0026d703          	lhu	a4,2(a3)
    800058d8:	8b1d                	andi	a4,a4,7
    800058da:	0706                	slli	a4,a4,0x1
    800058dc:	96ba                	add	a3,a3,a4
    800058de:	00a69223          	sh	a0,4(a3)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800058e2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058e6:	6798                	ld	a4,8(a5)
    800058e8:	00275783          	lhu	a5,2(a4)
    800058ec:	2785                	addiw	a5,a5,1
    800058ee:	00f71123          	sh	a5,2(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800058f2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058f6:	100017b7          	lui	a5,0x10001
    800058fa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while (b->disk == 1) {
    800058fe:	0049a783          	lw	a5,4(s3)
    80005902:	01079f63          	bne	a5,a6,80005920 <virtio_disk_rw+0x1ae>
    sleep(b, &disk.vdisk_lock);
    80005906:	0001b917          	auipc	s2,0x1b
    8000590a:	64a90913          	addi	s2,s2,1610 # 80020f50 <disk+0x128>
  while (b->disk == 1) {
    8000590e:	84be                	mv	s1,a5
    sleep(b, &disk.vdisk_lock);
    80005910:	85ca                	mv	a1,s2
    80005912:	854e                	mv	a0,s3
    80005914:	dc4fc0ef          	jal	80001ed8 <sleep>
  while (b->disk == 1) {
    80005918:	0049a783          	lw	a5,4(s3)
    8000591c:	fe978ae3          	beq	a5,s1,80005910 <virtio_disk_rw+0x19e>
  }

  disk.info[idx[0]].b = 0;
    80005920:	fa042903          	lw	s2,-96(s0)
    80005924:	00290713          	addi	a4,s2,2
    80005928:	0712                	slli	a4,a4,0x4
    8000592a:	0001b797          	auipc	a5,0x1b
    8000592e:	4fe78793          	addi	a5,a5,1278 # 80020e28 <disk>
    80005932:	97ba                	add	a5,a5,a4
    80005934:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005938:	0001b997          	auipc	s3,0x1b
    8000593c:	4f098993          	addi	s3,s3,1264 # 80020e28 <disk>
    80005940:	00491713          	slli	a4,s2,0x4
    80005944:	0009b783          	ld	a5,0(s3)
    80005948:	97ba                	add	a5,a5,a4
    8000594a:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    8000594e:	854a                	mv	a0,s2
    80005950:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005954:	befff0ef          	jal	80005542 <free_desc>
    if (flag & VRING_DESC_F_NEXT)
    80005958:	8885                	andi	s1,s1,1
    8000595a:	f0fd                	bnez	s1,80005940 <virtio_disk_rw+0x1ce>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000595c:	0001b517          	auipc	a0,0x1b
    80005960:	5f450513          	addi	a0,a0,1524 # 80020f50 <disk+0x128>
    80005964:	b38fb0ef          	jal	80000c9c <release>
}
    80005968:	60e6                	ld	ra,88(sp)
    8000596a:	6446                	ld	s0,80(sp)
    8000596c:	64a6                	ld	s1,72(sp)
    8000596e:	6906                	ld	s2,64(sp)
    80005970:	79e2                	ld	s3,56(sp)
    80005972:	7a42                	ld	s4,48(sp)
    80005974:	7aa2                	ld	s5,40(sp)
    80005976:	7b02                	ld	s6,32(sp)
    80005978:	6be2                	ld	s7,24(sp)
    8000597a:	6c42                	ld	s8,16(sp)
    8000597c:	6125                	addi	sp,sp,96
    8000597e:	8082                	ret

0000000080005980 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005980:	1101                	addi	sp,sp,-32
    80005982:	ec06                	sd	ra,24(sp)
    80005984:	e822                	sd	s0,16(sp)
    80005986:	e426                	sd	s1,8(sp)
    80005988:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000598a:	0001b497          	auipc	s1,0x1b
    8000598e:	49e48493          	addi	s1,s1,1182 # 80020e28 <disk>
    80005992:	0001b517          	auipc	a0,0x1b
    80005996:	5be50513          	addi	a0,a0,1470 # 80020f50 <disk+0x128>
    8000599a:	a7efb0ef          	jal	80000c18 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    8000599e:	100017b7          	lui	a5,0x10001
    800059a2:	53bc                	lw	a5,96(a5)
    800059a4:	8b8d                	andi	a5,a5,3
    800059a6:	10001737          	lui	a4,0x10001
    800059aa:	d37c                	sw	a5,100(a4)

  __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800059ac:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while (disk.used_idx != disk.used->idx) {
    800059b0:	689c                	ld	a5,16(s1)
    800059b2:	0204d703          	lhu	a4,32(s1)
    800059b6:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800059ba:	04f70663          	beq	a4,a5,80005a06 <virtio_disk_intr+0x86>
    __atomic_thread_fence(__ATOMIC_SEQ_CST);
    800059be:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059c2:	6898                	ld	a4,16(s1)
    800059c4:	0204d783          	lhu	a5,32(s1)
    800059c8:	8b9d                	andi	a5,a5,7
    800059ca:	078e                	slli	a5,a5,0x3
    800059cc:	97ba                	add	a5,a5,a4
    800059ce:	43dc                	lw	a5,4(a5)

    if (disk.info[id].status != 0)
    800059d0:	00278713          	addi	a4,a5,2
    800059d4:	0712                	slli	a4,a4,0x4
    800059d6:	9726                	add	a4,a4,s1
    800059d8:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    800059dc:	e321                	bnez	a4,80005a1c <virtio_disk_intr+0x9c>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800059de:	0789                	addi	a5,a5,2
    800059e0:	0792                	slli	a5,a5,0x4
    800059e2:	97a6                	add	a5,a5,s1
    800059e4:	6788                	ld	a0,8(a5)
    b->disk = 0; // disk is done with buf
    800059e6:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800059ea:	d3afc0ef          	jal	80001f24 <wakeup>

    disk.used_idx += 1;
    800059ee:	0204d783          	lhu	a5,32(s1)
    800059f2:	2785                	addiw	a5,a5,1
    800059f4:	17c2                	slli	a5,a5,0x30
    800059f6:	93c1                	srli	a5,a5,0x30
    800059f8:	02f49023          	sh	a5,32(s1)
  while (disk.used_idx != disk.used->idx) {
    800059fc:	6898                	ld	a4,16(s1)
    800059fe:	00275703          	lhu	a4,2(a4)
    80005a02:	faf71ee3          	bne	a4,a5,800059be <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a06:	0001b517          	auipc	a0,0x1b
    80005a0a:	54a50513          	addi	a0,a0,1354 # 80020f50 <disk+0x128>
    80005a0e:	a8efb0ef          	jal	80000c9c <release>
}
    80005a12:	60e2                	ld	ra,24(sp)
    80005a14:	6442                	ld	s0,16(sp)
    80005a16:	64a2                	ld	s1,8(sp)
    80005a18:	6105                	addi	sp,sp,32
    80005a1a:	8082                	ret
      panic("virtio_disk_intr status");
    80005a1c:	00002517          	auipc	a0,0x2
    80005a20:	dcc50513          	addi	a0,a0,-564 # 800077e8 <etext+0x7e8>
    80005a24:	e17fa0ef          	jal	8000083a <panic>

0000000080005a28 <race_init>:
static struct shared_resource shared_res;

// Initialize the shared resource and its spinlock
void
race_init(void)
{
    80005a28:	1101                	addi	sp,sp,-32
    80005a2a:	ec06                	sd	ra,24(sp)
    80005a2c:	e822                	sd	s0,16(sp)
    80005a2e:	e426                	sd	s1,8(sp)
    80005a30:	1000                	addi	s0,sp,32
  initlock(&shared_res.lock, "race_counter");
    80005a32:	0001b497          	auipc	s1,0x1b
    80005a36:	53648493          	addi	s1,s1,1334 # 80020f68 <shared_res>
    80005a3a:	00002597          	auipc	a1,0x2
    80005a3e:	dc658593          	addi	a1,a1,-570 # 80007800 <etext+0x800>
    80005a42:	8526                	mv	a0,s1
    80005a44:	954fb0ef          	jal	80000b98 <initlock>
  shared_res.counter = 0;
    80005a48:	0004ac23          	sw	zero,24(s1)
  shared_res.total_ops = 0;
    80005a4c:	0004ae23          	sw	zero,28(s1)
}
    80005a50:	60e2                	ld	ra,24(sp)
    80005a52:	6442                	ld	s0,16(sp)
    80005a54:	64a2                	ld	s1,8(sp)
    80005a56:	6105                	addi	sp,sp,32
    80005a58:	8082                	ret

0000000080005a5a <race_reset>:

// Reset counter to zero
int
race_reset(void)
{
    80005a5a:	1101                	addi	sp,sp,-32
    80005a5c:	ec06                	sd	ra,24(sp)
    80005a5e:	e822                	sd	s0,16(sp)
    80005a60:	e426                	sd	s1,8(sp)
    80005a62:	1000                	addi	s0,sp,32
  acquire(&shared_res.lock);
    80005a64:	0001b497          	auipc	s1,0x1b
    80005a68:	50448493          	addi	s1,s1,1284 # 80020f68 <shared_res>
    80005a6c:	8526                	mv	a0,s1
    80005a6e:	9aafb0ef          	jal	80000c18 <acquire>
  shared_res.counter = 0;
    80005a72:	0004ac23          	sw	zero,24(s1)
  shared_res.total_ops = 0;
    80005a76:	0004ae23          	sw	zero,28(s1)
  release(&shared_res.lock);
    80005a7a:	8526                	mv	a0,s1
    80005a7c:	a20fb0ef          	jal	80000c9c <release>
  return 0;
}
    80005a80:	4501                	li	a0,0
    80005a82:	60e2                	ld	ra,24(sp)
    80005a84:	6442                	ld	s0,16(sp)
    80005a86:	64a2                	ld	s1,8(sp)
    80005a88:	6105                	addi	sp,sp,32
    80005a8a:	8082                	ret

0000000080005a8c <race_get_counter>:

// Read current counter value (thread-safe read)
int
race_get_counter(void)
{
    80005a8c:	1101                	addi	sp,sp,-32
    80005a8e:	ec06                	sd	ra,24(sp)
    80005a90:	e822                	sd	s0,16(sp)
    80005a92:	e426                	sd	s1,8(sp)
    80005a94:	1000                	addi	s0,sp,32
  int val;
  acquire(&shared_res.lock);
    80005a96:	0001b517          	auipc	a0,0x1b
    80005a9a:	4d250513          	addi	a0,a0,1234 # 80020f68 <shared_res>
    80005a9e:	97afb0ef          	jal	80000c18 <acquire>
  val = shared_res.counter;
    80005aa2:	0001b797          	auipc	a5,0x1b
    80005aa6:	4de7a783          	lw	a5,1246(a5) # 80020f80 <shared_res+0x18>
    80005aaa:	84be                	mv	s1,a5
  release(&shared_res.lock);
    80005aac:	0001b517          	auipc	a0,0x1b
    80005ab0:	4bc50513          	addi	a0,a0,1212 # 80020f68 <shared_res>
    80005ab4:	9e8fb0ef          	jal	80000c9c <release>
  return val;
}
    80005ab8:	8526                	mv	a0,s1
    80005aba:	60e2                	ld	ra,24(sp)
    80005abc:	6442                	ld	s0,16(sp)
    80005abe:	64a2                	ld	s1,8(sp)
    80005ac0:	6105                	addi	sp,sp,32
    80005ac2:	8082                	ret

0000000080005ac4 <race_increment>:
// If use_lock == 0: executes unprotected non-atomic read-modify-write.
// If use_lock == 1: protects critical section using acquire() and release().
int
race_increment(int iterations, int use_lock)
{
  for (int i = 0; i < iterations; i++) {
    80005ac4:	0ea05963          	blez	a0,80005bb6 <race_increment+0xf2>
{
    80005ac8:	715d                	addi	sp,sp,-80
    80005aca:	e486                	sd	ra,72(sp)
    80005acc:	e0a2                	sd	s0,64(sp)
    80005ace:	fc26                	sd	s1,56(sp)
    80005ad0:	f84a                	sd	s2,48(sp)
    80005ad2:	f44e                	sd	s3,40(sp)
    80005ad4:	f052                	sd	s4,32(sp)
    80005ad6:	ec56                	sd	s5,24(sp)
    80005ad8:	e85a                	sd	s6,16(sp)
    80005ada:	0880                	addi	s0,sp,80
    80005adc:	8a2a                	mv	s4,a0
    80005ade:	8aae                	mv	s5,a1
  for (int i = 0; i < iterations; i++) {
    80005ae0:	4481                	li	s1,0

      release(&shared_res.lock);
    } else {
      // Unprotected critical section (VULNERABLE TO RACE CONDITIONS)
      // Read shared state into local register
      volatile int temp = shared_res.counter;
    80005ae2:	0001b997          	auipc	s3,0x1b
    80005ae6:	48698993          	addi	s3,s3,1158 # 80020f68 <shared_res>

      // In unlocked mode, preemption/context-switching or core interleaving
      // during the vulnerable read-modify-write window causes lost updates.
      if ((i % 5) == 0) {
    80005aea:	66666b37          	lui	s6,0x66666
    80005aee:	667b0b13          	addi	s6,s6,1639 # 66666667 <_entry-0x19999999>
        yield();
      } else {
        for (volatile int d = 0; d < 30; d++)
    80005af2:	4975                	li	s2,29
    80005af4:	a049                	j	80005b76 <race_increment+0xb2>
      acquire(&shared_res.lock);
    80005af6:	854e                	mv	a0,s3
    80005af8:	920fb0ef          	jal	80000c18 <acquire>
      volatile int temp = shared_res.counter;
    80005afc:	0189a783          	lw	a5,24(s3)
    80005b00:	faf42823          	sw	a5,-80(s0)
      for (volatile int d = 0; d < 30; d++)
    80005b04:	fa042a23          	sw	zero,-76(s0)
    80005b08:	fb442783          	lw	a5,-76(s0)
    80005b0c:	00f94b63          	blt	s2,a5,80005b22 <race_increment+0x5e>
    80005b10:	fb442783          	lw	a5,-76(s0)
    80005b14:	2785                	addiw	a5,a5,1
    80005b16:	faf42a23          	sw	a5,-76(s0)
    80005b1a:	fb442783          	lw	a5,-76(s0)
    80005b1e:	fef959e3          	bge	s2,a5,80005b10 <race_increment+0x4c>
      shared_res.counter = temp + 1;
    80005b22:	fb042783          	lw	a5,-80(s0)
    80005b26:	2785                	addiw	a5,a5,1
    80005b28:	00f9ac23          	sw	a5,24(s3)
      shared_res.total_ops++;
    80005b2c:	01c9a783          	lw	a5,28(s3)
    80005b30:	2785                	addiw	a5,a5,1
    80005b32:	00f9ae23          	sw	a5,28(s3)
      release(&shared_res.lock);
    80005b36:	854e                	mv	a0,s3
    80005b38:	964fb0ef          	jal	80000c9c <release>
    80005b3c:	a815                	j	80005b70 <race_increment+0xac>
        for (volatile int d = 0; d < 30; d++)
    80005b3e:	fa042e23          	sw	zero,-68(s0)
    80005b42:	fbc42783          	lw	a5,-68(s0)
    80005b46:	00f94b63          	blt	s2,a5,80005b5c <race_increment+0x98>
    80005b4a:	fbc42783          	lw	a5,-68(s0)
    80005b4e:	2785                	addiw	a5,a5,1
    80005b50:	faf42e23          	sw	a5,-68(s0)
    80005b54:	fbc42783          	lw	a5,-68(s0)
    80005b58:	fef959e3          	bge	s2,a5,80005b4a <race_increment+0x86>
          ;
      }

      // Overwrite shared state with stale computation -> Lost Update occurs
      shared_res.counter = temp + 1;
    80005b5c:	fb842783          	lw	a5,-72(s0)
    80005b60:	2785                	addiw	a5,a5,1
    80005b62:	00f9ac23          	sw	a5,24(s3)
      shared_res.total_ops++;
    80005b66:	01c9a783          	lw	a5,28(s3)
    80005b6a:	2785                	addiw	a5,a5,1
    80005b6c:	00f9ae23          	sw	a5,28(s3)
  for (int i = 0; i < iterations; i++) {
    80005b70:	2485                	addiw	s1,s1,1
    80005b72:	029a0763          	beq	s4,s1,80005ba0 <race_increment+0xdc>
    if (use_lock) {
    80005b76:	f80a90e3          	bnez	s5,80005af6 <race_increment+0x32>
      volatile int temp = shared_res.counter;
    80005b7a:	0189a783          	lw	a5,24(s3)
    80005b7e:	faf42c23          	sw	a5,-72(s0)
      if ((i % 5) == 0) {
    80005b82:	036487b3          	mul	a5,s1,s6
    80005b86:	9785                	srai	a5,a5,0x21
    80005b88:	41f4d71b          	sraiw	a4,s1,0x1f
    80005b8c:	9f99                	subw	a5,a5,a4
    80005b8e:	0027971b          	slliw	a4,a5,0x2
    80005b92:	9fb9                	addw	a5,a5,a4
    80005b94:	40f487bb          	subw	a5,s1,a5
    80005b98:	f3dd                	bnez	a5,80005b3e <race_increment+0x7a>
        yield();
    80005b9a:	b12fc0ef          	jal	80001eac <yield>
    80005b9e:	bf7d                	j	80005b5c <race_increment+0x98>
    }
  }
  return 0;
}
    80005ba0:	4501                	li	a0,0
    80005ba2:	60a6                	ld	ra,72(sp)
    80005ba4:	6406                	ld	s0,64(sp)
    80005ba6:	74e2                	ld	s1,56(sp)
    80005ba8:	7942                	ld	s2,48(sp)
    80005baa:	79a2                	ld	s3,40(sp)
    80005bac:	7a02                	ld	s4,32(sp)
    80005bae:	6ae2                	ld	s5,24(sp)
    80005bb0:	6b42                	ld	s6,16(sp)
    80005bb2:	6161                	addi	sp,sp,80
    80005bb4:	8082                	ret
    80005bb6:	4501                	li	a0,0
    80005bb8:	8082                	ret
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
