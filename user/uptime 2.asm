
user/_uptime:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  int t = uptime();
   8:	366000ef          	jal	36e <uptime>
   c:	85aa                	mv	a1,a0
  printf("uptime: %d ticks\n", t);
   e:	00001517          	auipc	a0,0x1
  12:	90250513          	addi	a0,a0,-1790 # 910 <malloc+0x100>
  16:	73e000ef          	jal	754 <printf>
  exit(0);
  1a:	4501                	li	a0,0
  1c:	2ba000ef          	jal	2d6 <exit>

0000000000000020 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  20:	1141                	addi	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  28:	fd9ff0ef          	jal	0 <main>
  exit(r);
  2c:	2aa000ef          	jal	2d6 <exit>

0000000000000030 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  30:	1141                	addi	sp,sp,-16
  32:	e406                	sd	ra,8(sp)
  34:	e022                	sd	s0,0(sp)
  36:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  38:	87aa                	mv	a5,a0
  3a:	0585                	addi	a1,a1,1
  3c:	0785                	addi	a5,a5,1
  3e:	fff5c703          	lbu	a4,-1(a1)
  42:	fee78fa3          	sb	a4,-1(a5)
  46:	fb75                	bnez	a4,3a <strcpy+0xa>
    ;
  return os;
}
  48:	60a2                	ld	ra,8(sp)
  4a:	6402                	ld	s0,0(sp)
  4c:	0141                	addi	sp,sp,16
  4e:	8082                	ret

0000000000000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	1141                	addi	sp,sp,-16
  52:	e406                	sd	ra,8(sp)
  54:	e022                	sd	s0,0(sp)
  56:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  58:	00054783          	lbu	a5,0(a0)
  5c:	cb91                	beqz	a5,70 <strcmp+0x20>
  5e:	0005c703          	lbu	a4,0(a1)
  62:	00f71763          	bne	a4,a5,70 <strcmp+0x20>
    p++, q++;
  66:	0505                	addi	a0,a0,1
  68:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  6a:	00054783          	lbu	a5,0(a0)
  6e:	fbe5                	bnez	a5,5e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  70:	0005c503          	lbu	a0,0(a1)
}
  74:	40a7853b          	subw	a0,a5,a0
  78:	60a2                	ld	ra,8(sp)
  7a:	6402                	ld	s0,0(sp)
  7c:	0141                	addi	sp,sp,16
  7e:	8082                	ret

0000000000000080 <strlen>:

uint
strlen(const char *s)
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  88:	00054783          	lbu	a5,0(a0)
  8c:	cf91                	beqz	a5,a8 <strlen+0x28>
  8e:	00150793          	addi	a5,a0,1
  92:	86be                	mv	a3,a5
  94:	0785                	addi	a5,a5,1
  96:	fff7c703          	lbu	a4,-1(a5)
  9a:	ff65                	bnez	a4,92 <strlen+0x12>
  9c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a0:	60a2                	ld	ra,8(sp)
  a2:	6402                	ld	s0,0(sp)
  a4:	0141                	addi	sp,sp,16
  a6:	8082                	ret
  for (n = 0; s[n]; n++)
  a8:	4501                	li	a0,0
  aa:	bfdd                	j	a0 <strlen+0x20>

00000000000000ac <memset>:

void *
memset(void *dst, int c, uint n)
{
  ac:	1141                	addi	sp,sp,-16
  ae:	e406                	sd	ra,8(sp)
  b0:	e022                	sd	s0,0(sp)
  b2:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  b4:	ca19                	beqz	a2,ca <memset+0x1e>
  b6:	87aa                	mv	a5,a0
  b8:	1602                	slli	a2,a2,0x20
  ba:	9201                	srli	a2,a2,0x20
  bc:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c0:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  c4:	0785                	addi	a5,a5,1
  c6:	fee79de3          	bne	a5,a4,c0 <memset+0x14>
  }
  return dst;
}
  ca:	60a2                	ld	ra,8(sp)
  cc:	6402                	ld	s0,0(sp)
  ce:	0141                	addi	sp,sp,16
  d0:	8082                	ret

00000000000000d2 <strchr>:

char *
strchr(const char *s, char c)
{
  d2:	1141                	addi	sp,sp,-16
  d4:	e406                	sd	ra,8(sp)
  d6:	e022                	sd	s0,0(sp)
  d8:	0800                	addi	s0,sp,16
  for (; *s; s++)
  da:	00054783          	lbu	a5,0(a0)
  de:	c799                	beqz	a5,ec <strchr+0x1a>
    if (*s == c)
  e0:	00f58763          	beq	a1,a5,ee <strchr+0x1c>
  for (; *s; s++)
  e4:	0505                	addi	a0,a0,1
  e6:	00054783          	lbu	a5,0(a0)
  ea:	fbfd                	bnez	a5,e0 <strchr+0xe>
      return (char *)s;
  return 0;
  ec:	4501                	li	a0,0
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <gets>:

char *
gets(char *buf, int max)
{
  f6:	711d                	addi	sp,sp,-96
  f8:	ec86                	sd	ra,88(sp)
  fa:	e8a2                	sd	s0,80(sp)
  fc:	e4a6                	sd	s1,72(sp)
  fe:	e0ca                	sd	s2,64(sp)
 100:	fc4e                	sd	s3,56(sp)
 102:	f852                	sd	s4,48(sp)
 104:	f456                	sd	s5,40(sp)
 106:	f05a                	sd	s6,32(sp)
 108:	ec5e                	sd	s7,24(sp)
 10a:	e862                	sd	s8,16(sp)
 10c:	1080                	addi	s0,sp,96
 10e:	8baa                	mv	s7,a0
 110:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 112:	892a                	mv	s2,a0
 114:	4481                	li	s1,0
    cc = read(0, &c, 1);
 116:	faf40b13          	addi	s6,s0,-81
 11a:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 11c:	8c26                	mv	s8,s1
 11e:	0014899b          	addiw	s3,s1,1
 122:	84ce                	mv	s1,s3
 124:	0349d863          	bge	s3,s4,154 <gets+0x5e>
    cc = read(0, &c, 1);
 128:	8656                	mv	a2,s5
 12a:	85da                	mv	a1,s6
 12c:	4501                	li	a0,0
 12e:	1c0000ef          	jal	2ee <read>
    if (cc < 1)
 132:	02a05163          	blez	a0,154 <gets+0x5e>
      break;
    buf[i++] = c;
 136:	faf44783          	lbu	a5,-81(s0)
 13a:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 13e:	0905                	addi	s2,s2,1
 140:	ff678713          	addi	a4,a5,-10
 144:	00173713          	seqz	a4,a4
 148:	17cd                	addi	a5,a5,-13
 14a:	0017b793          	seqz	a5,a5
 14e:	8fd9                	or	a5,a5,a4
 150:	d7f1                	beqz	a5,11c <gets+0x26>
    buf[i++] = c;
 152:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 154:	9c5e                	add	s8,s8,s7
 156:	000c0023          	sb	zero,0(s8)
  return buf;
}
 15a:	855e                	mv	a0,s7
 15c:	60e6                	ld	ra,88(sp)
 15e:	6446                	ld	s0,80(sp)
 160:	64a6                	ld	s1,72(sp)
 162:	6906                	ld	s2,64(sp)
 164:	79e2                	ld	s3,56(sp)
 166:	7a42                	ld	s4,48(sp)
 168:	7aa2                	ld	s5,40(sp)
 16a:	7b02                	ld	s6,32(sp)
 16c:	6be2                	ld	s7,24(sp)
 16e:	6c42                	ld	s8,16(sp)
 170:	6125                	addi	sp,sp,96
 172:	8082                	ret

0000000000000174 <stat>:

int
stat(const char *n, struct stat *st)
{
 174:	1101                	addi	sp,sp,-32
 176:	ec06                	sd	ra,24(sp)
 178:	e822                	sd	s0,16(sp)
 17a:	e04a                	sd	s2,0(sp)
 17c:	1000                	addi	s0,sp,32
 17e:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 180:	4581                	li	a1,0
 182:	194000ef          	jal	316 <open>
  if (fd < 0)
 186:	02054263          	bltz	a0,1aa <stat+0x36>
 18a:	e426                	sd	s1,8(sp)
 18c:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 18e:	85ca                	mv	a1,s2
 190:	19e000ef          	jal	32e <fstat>
 194:	892a                	mv	s2,a0
  close(fd);
 196:	8526                	mv	a0,s1
 198:	166000ef          	jal	2fe <close>
  return r;
 19c:	64a2                	ld	s1,8(sp)
}
 19e:	854a                	mv	a0,s2
 1a0:	60e2                	ld	ra,24(sp)
 1a2:	6442                	ld	s0,16(sp)
 1a4:	6902                	ld	s2,0(sp)
 1a6:	6105                	addi	sp,sp,32
 1a8:	8082                	ret
    return -1;
 1aa:	57fd                	li	a5,-1
 1ac:	893e                	mv	s2,a5
 1ae:	bfc5                	j	19e <stat+0x2a>

00000000000001b0 <atoi>:

int
atoi(const char *s)
{
 1b0:	1141                	addi	sp,sp,-16
 1b2:	e406                	sd	ra,8(sp)
 1b4:	e022                	sd	s0,0(sp)
 1b6:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1b8:	00054683          	lbu	a3,0(a0)
 1bc:	fd06879b          	addiw	a5,a3,-48
 1c0:	0ff7f793          	zext.b	a5,a5
 1c4:	4625                	li	a2,9
 1c6:	02f66963          	bltu	a2,a5,1f8 <atoi+0x48>
 1ca:	872a                	mv	a4,a0
  n = 0;
 1cc:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1ce:	0705                	addi	a4,a4,1
 1d0:	0025179b          	slliw	a5,a0,0x2
 1d4:	9fa9                	addw	a5,a5,a0
 1d6:	0017979b          	slliw	a5,a5,0x1
 1da:	9fb5                	addw	a5,a5,a3
 1dc:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1e0:	00074683          	lbu	a3,0(a4)
 1e4:	fd06879b          	addiw	a5,a3,-48
 1e8:	0ff7f793          	zext.b	a5,a5
 1ec:	fef671e3          	bgeu	a2,a5,1ce <atoi+0x1e>
  return n;
}
 1f0:	60a2                	ld	ra,8(sp)
 1f2:	6402                	ld	s0,0(sp)
 1f4:	0141                	addi	sp,sp,16
 1f6:	8082                	ret
  n = 0;
 1f8:	4501                	li	a0,0
 1fa:	bfdd                	j	1f0 <atoi+0x40>

00000000000001fc <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 204:	02b57563          	bgeu	a0,a1,22e <memmove+0x32>
    while (n-- > 0)
 208:	00c05f63          	blez	a2,226 <memmove+0x2a>
 20c:	1602                	slli	a2,a2,0x20
 20e:	9201                	srli	a2,a2,0x20
 210:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 214:	872a                	mv	a4,a0
      *dst++ = *src++;
 216:	0585                	addi	a1,a1,1
 218:	0705                	addi	a4,a4,1
 21a:	fff5c683          	lbu	a3,-1(a1)
 21e:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 222:	fee79ae3          	bne	a5,a4,216 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 226:	60a2                	ld	ra,8(sp)
 228:	6402                	ld	s0,0(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
    while (n-- > 0)
 22e:	fec05ce3          	blez	a2,226 <memmove+0x2a>
    dst += n;
 232:	00c50733          	add	a4,a0,a2
    src += n;
 236:	95b2                	add	a1,a1,a2
 238:	fff6079b          	addiw	a5,a2,-1
 23c:	1782                	slli	a5,a5,0x20
 23e:	9381                	srli	a5,a5,0x20
 240:	fff7c793          	not	a5,a5
 244:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 246:	15fd                	addi	a1,a1,-1
 248:	177d                	addi	a4,a4,-1
 24a:	0005c683          	lbu	a3,0(a1)
 24e:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 252:	fef71ae3          	bne	a4,a5,246 <memmove+0x4a>
 256:	bfc1                	j	226 <memmove+0x2a>

0000000000000258 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 260:	ce19                	beqz	a2,27e <memcmp+0x26>
 262:	1602                	slli	a2,a2,0x20
 264:	9201                	srli	a2,a2,0x20
 266:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 26a:	00054783          	lbu	a5,0(a0)
 26e:	0005c703          	lbu	a4,0(a1)
 272:	00e79b63          	bne	a5,a4,288 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 276:	0505                	addi	a0,a0,1
    p2++;
 278:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 27a:	fed518e3          	bne	a0,a3,26a <memcmp+0x12>
  }
  return 0;
 27e:	4501                	li	a0,0
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
      return *p1 - *p2;
 288:	40e7853b          	subw	a0,a5,a4
 28c:	bfd5                	j	280 <memcmp+0x28>

000000000000028e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 296:	f67ff0ef          	jal	1fc <memmove>
}
 29a:	60a2                	ld	ra,8(sp)
 29c:	6402                	ld	s0,0(sp)
 29e:	0141                	addi	sp,sp,16
 2a0:	8082                	ret

00000000000002a2 <sbrk>:

char *
sbrk(int n)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2aa:	4585                	li	a1,1
 2ac:	0b2000ef          	jal	35e <sys_sbrk>
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret

00000000000002b8 <sbrklazy>:

char *
sbrklazy(int n)
{
 2b8:	1141                	addi	sp,sp,-16
 2ba:	e406                	sd	ra,8(sp)
 2bc:	e022                	sd	s0,0(sp)
 2be:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c0:	4589                	li	a1,2
 2c2:	09c000ef          	jal	35e <sys_sbrk>
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2ce:	4885                	li	a7,1
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d6:	4889                	li	a7,2
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <wait>:
.global wait
wait:
 li a7, SYS_wait
 2de:	488d                	li	a7,3
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e6:	4891                	li	a7,4
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <read>:
.global read
read:
 li a7, SYS_read
 2ee:	4895                	li	a7,5
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <write>:
.global write
write:
 li a7, SYS_write
 2f6:	48c1                	li	a7,16
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <close>:
.global close
close:
 li a7, SYS_close
 2fe:	48d5                	li	a7,21
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <kill>:
.global kill
kill:
 li a7, SYS_kill
 306:	4899                	li	a7,6
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <exec>:
.global exec
exec:
 li a7, SYS_exec
 30e:	489d                	li	a7,7
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <open>:
.global open
open:
 li a7, SYS_open
 316:	48bd                	li	a7,15
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31e:	48c5                	li	a7,17
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 326:	48c9                	li	a7,18
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32e:	48a1                	li	a7,8
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <link>:
.global link
link:
 li a7, SYS_link
 336:	48cd                	li	a7,19
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33e:	48d1                	li	a7,20
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 346:	48a5                	li	a7,9
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <dup>:
.global dup
dup:
 li a7, SYS_dup
 34e:	48a9                	li	a7,10
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 356:	48ad                	li	a7,11
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35e:	48b1                	li	a7,12
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <pause>:
.global pause
pause:
 li a7, SYS_pause
 366:	48b5                	li	a7,13
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36e:	48b9                	li	a7,14
 ecall
 370:	00000073          	ecall
 ret
 374:	8082                	ret

0000000000000376 <sync>:
.global sync
sync:
 li a7, SYS_sync
 376:	48d9                	li	a7,22
 ecall
 378:	00000073          	ecall
 ret
 37c:	8082                	ret

000000000000037e <trace>:
.global trace
trace:
 li a7, SYS_trace
 37e:	48dd                	li	a7,23
 ecall
 380:	00000073          	ecall
 ret
 384:	8082                	ret

0000000000000386 <race_inc>:
.global race_inc
race_inc:
 li a7, SYS_race_inc
 386:	48e1                	li	a7,24
 ecall
 388:	00000073          	ecall
 ret
 38c:	8082                	ret

000000000000038e <race_get>:
.global race_get
race_get:
 li a7, SYS_race_get
 38e:	48e5                	li	a7,25
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <race_reset>:
.global race_reset
race_reset:
 li a7, SYS_race_reset
 396:	48e9                	li	a7,26
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 39e:	1101                	addi	sp,sp,-32
 3a0:	ec06                	sd	ra,24(sp)
 3a2:	e822                	sd	s0,16(sp)
 3a4:	1000                	addi	s0,sp,32
 3a6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3aa:	4605                	li	a2,1
 3ac:	fef40593          	addi	a1,s0,-17
 3b0:	f47ff0ef          	jal	2f6 <write>
}
 3b4:	60e2                	ld	ra,24(sp)
 3b6:	6442                	ld	s0,16(sp)
 3b8:	6105                	addi	sp,sp,32
 3ba:	8082                	ret

00000000000003bc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3bc:	715d                	addi	sp,sp,-80
 3be:	e486                	sd	ra,72(sp)
 3c0:	e0a2                	sd	s0,64(sp)
 3c2:	f84a                	sd	s2,48(sp)
 3c4:	f44e                	sd	s3,40(sp)
 3c6:	0880                	addi	s0,sp,80
 3c8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3ca:	00d036b3          	snez	a3,a3
 3ce:	03f5d793          	srli	a5,a1,0x3f
 3d2:	8efd                	and	a3,a3,a5
  neg = 0;
 3d4:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3d6:	c681                	beqz	a3,3de <printint+0x22>
    neg = 1;
    x = -xx;
 3d8:	40b005b3          	neg	a1,a1
    neg = 1;
 3dc:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3de:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3e2:	86ce                	mv	a3,s3
  i = 0;
 3e4:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3e6:	00000817          	auipc	a6,0x0
 3ea:	54a80813          	addi	a6,a6,1354 # 930 <digits>
 3ee:	88ba                	mv	a7,a4
 3f0:	0017051b          	addiw	a0,a4,1
 3f4:	872a                	mv	a4,a0
 3f6:	02c5f7b3          	remu	a5,a1,a2
 3fa:	97c2                	add	a5,a5,a6
 3fc:	0007c783          	lbu	a5,0(a5)
 400:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 404:	87ae                	mv	a5,a1
 406:	02c5d5b3          	divu	a1,a1,a2
 40a:	0685                	addi	a3,a3,1
 40c:	fec7f1e3          	bgeu	a5,a2,3ee <printint+0x32>
  if (neg)
 410:	00030b63          	beqz	t1,426 <printint+0x6a>
    buf[i++] = '-';
 414:	fd040793          	addi	a5,s0,-48
 418:	953e                	add	a0,a0,a5
 41a:	02d00793          	li	a5,45
 41e:	fef50423          	sb	a5,-24(a0)
 422:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 426:	02e05563          	blez	a4,450 <printint+0x94>
 42a:	fc26                	sd	s1,56(sp)
 42c:	377d                	addiw	a4,a4,-1
 42e:	00e984b3          	add	s1,s3,a4
 432:	19fd                	addi	s3,s3,-1
 434:	99ba                	add	s3,s3,a4
 436:	1702                	slli	a4,a4,0x20
 438:	9301                	srli	a4,a4,0x20
 43a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 43e:	0004c583          	lbu	a1,0(s1)
 442:	854a                	mv	a0,s2
 444:	f5bff0ef          	jal	39e <putc>
  while (--i >= 0)
 448:	14fd                	addi	s1,s1,-1
 44a:	ff349ae3          	bne	s1,s3,43e <printint+0x82>
 44e:	74e2                	ld	s1,56(sp)
}
 450:	60a6                	ld	ra,72(sp)
 452:	6406                	ld	s0,64(sp)
 454:	7942                	ld	s2,48(sp)
 456:	79a2                	ld	s3,40(sp)
 458:	6161                	addi	sp,sp,80
 45a:	8082                	ret

000000000000045c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 45c:	711d                	addi	sp,sp,-96
 45e:	ec86                	sd	ra,88(sp)
 460:	e8a2                	sd	s0,80(sp)
 462:	e4a6                	sd	s1,72(sp)
 464:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 466:	0005c483          	lbu	s1,0(a1)
 46a:	2a048063          	beqz	s1,70a <vprintf+0x2ae>
 46e:	e0ca                	sd	s2,64(sp)
 470:	fc4e                	sd	s3,56(sp)
 472:	f852                	sd	s4,48(sp)
 474:	f456                	sd	s5,40(sp)
 476:	f05a                	sd	s6,32(sp)
 478:	ec5e                	sd	s7,24(sp)
 47a:	e862                	sd	s8,16(sp)
 47c:	8b2a                	mv	s6,a0
 47e:	8a2e                	mv	s4,a1
 480:	8bb2                	mv	s7,a2
  state = 0;
 482:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 484:	4901                	li	s2,0
 486:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 488:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 48c:	06400c13          	li	s8,100
 490:	a00d                	j	4b2 <vprintf+0x56>
        putc(fd, c0);
 492:	85a6                	mv	a1,s1
 494:	855a                	mv	a0,s6
 496:	f09ff0ef          	jal	39e <putc>
 49a:	a019                	j	4a0 <vprintf+0x44>
    } else if (state == '%') {
 49c:	03598363          	beq	s3,s5,4c2 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4a0:	0019079b          	addiw	a5,s2,1
 4a4:	893e                	mv	s2,a5
 4a6:	873e                	mv	a4,a5
 4a8:	97d2                	add	a5,a5,s4
 4aa:	0007c483          	lbu	s1,0(a5)
 4ae:	24048763          	beqz	s1,6fc <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4b2:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4b6:	fe0993e3          	bnez	s3,49c <vprintf+0x40>
      if (c0 == '%') {
 4ba:	fd579ce3          	bne	a5,s5,492 <vprintf+0x36>
        state = '%';
 4be:	89be                	mv	s3,a5
 4c0:	b7c5                	j	4a0 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4c2:	00ea06b3          	add	a3,s4,a4
 4c6:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4ca:	24060563          	beqz	a2,714 <vprintf+0x2b8>
      if (c0 == 'd') {
 4ce:	0b878763          	beq	a5,s8,57c <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4d2:	f9478693          	addi	a3,a5,-108
 4d6:	0016b693          	seqz	a3,a3
 4da:	f9c60593          	addi	a1,a2,-100
 4de:	0015b593          	seqz	a1,a1
 4e2:	8df5                	and	a1,a1,a3
 4e4:	e9c5                	bnez	a1,594 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4e6:	9752                	add	a4,a4,s4
 4e8:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4ec:	f9460713          	addi	a4,a2,-108
 4f0:	00173713          	seqz	a4,a4
 4f4:	8f75                	and	a4,a4,a3
 4f6:	f9c50593          	addi	a1,a0,-100
 4fa:	0015b593          	seqz	a1,a1
 4fe:	8df9                	and	a1,a1,a4
 500:	e5dd                	bnez	a1,5ae <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 502:	07500593          	li	a1,117
 506:	0cb78163          	beq	a5,a1,5c8 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 50a:	f8b60593          	addi	a1,a2,-117
 50e:	0015b593          	seqz	a1,a1
 512:	8df5                	and	a1,a1,a3
 514:	e5f1                	bnez	a1,5e0 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 516:	f8b50593          	addi	a1,a0,-117
 51a:	0015b593          	seqz	a1,a1
 51e:	8df9                	and	a1,a1,a4
 520:	ede9                	bnez	a1,5fa <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 522:	07800593          	li	a1,120
 526:	0eb78763          	beq	a5,a1,614 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 52a:	f8860613          	addi	a2,a2,-120
 52e:	00163613          	seqz	a2,a2
 532:	8ef1                	and	a3,a3,a2
 534:	0e069c63          	bnez	a3,62c <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 538:	f8850513          	addi	a0,a0,-120
 53c:	00153513          	seqz	a0,a0
 540:	8f69                	and	a4,a4,a0
 542:	10071263          	bnez	a4,646 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 546:	07000713          	li	a4,112
 54a:	10e78a63          	beq	a5,a4,65e <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 54e:	06300713          	li	a4,99
 552:	14e78a63          	beq	a5,a4,6a6 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 556:	07300713          	li	a4,115
 55a:	16e78063          	beq	a5,a4,6ba <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 55e:	02500713          	li	a4,37
 562:	18e78863          	beq	a5,a4,6f2 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 566:	02500593          	li	a1,37
 56a:	855a                	mv	a0,s6
 56c:	e33ff0ef          	jal	39e <putc>
        putc(fd, c0);
 570:	85a6                	mv	a1,s1
 572:	855a                	mv	a0,s6
 574:	e2bff0ef          	jal	39e <putc>
      }

      state = 0;
 578:	4981                	li	s3,0
 57a:	b71d                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 57c:	008b8493          	addi	s1,s7,8
 580:	4685                	li	a3,1
 582:	4629                	li	a2,10
 584:	000ba583          	lw	a1,0(s7)
 588:	855a                	mv	a0,s6
 58a:	e33ff0ef          	jal	3bc <printint>
 58e:	8ba6                	mv	s7,s1
      state = 0;
 590:	4981                	li	s3,0
 592:	b739                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	e1bff0ef          	jal	3bc <printint>
        i += 1;
 5a6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	8ba6                	mv	s7,s1
      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	bdd5                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	e01ff0ef          	jal	3bc <printint>
        i += 2;
 5c0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
        i += 2;
 5c6:	bde9                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4681                	li	a3,0
 5ce:	4629                	li	a2,10
 5d0:	000be583          	lwu	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	de7ff0ef          	jal	3bc <printint>
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b5c9                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4681                	li	a3,0
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	dcfff0ef          	jal	3bc <printint>
        i += 1;
 5f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	b565                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4681                	li	a3,0
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	db5ff0ef          	jal	3bc <printint>
        i += 2;
 60c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	b579                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4641                	li	a2,16
 61c:	000be583          	lwu	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	d9bff0ef          	jal	3bc <printint>
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	bd9d                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4641                	li	a2,16
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	d83ff0ef          	jal	3bc <printint>
        i += 1;
 63e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
 644:	bdb1                	j	4a0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	008b8493          	addi	s1,s7,8
 64a:	4641                	li	a2,16
 64c:	000bb583          	ld	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d6bff0ef          	jal	3bc <printint>
        i += 2;
 656:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 658:	8ba6                	mv	s7,s1
      state = 0;
 65a:	4981                	li	s3,0
        i += 2;
 65c:	b591                	j	4a0 <vprintf+0x44>
 65e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 660:	008b8793          	addi	a5,s7,8
 664:	8cbe                	mv	s9,a5
 666:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 66a:	03000593          	li	a1,48
 66e:	855a                	mv	a0,s6
 670:	d2fff0ef          	jal	39e <putc>
  putc(fd, 'x');
 674:	07800593          	li	a1,120
 678:	855a                	mv	a0,s6
 67a:	d25ff0ef          	jal	39e <putc>
 67e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 680:	00000b97          	auipc	s7,0x0
 684:	2b0b8b93          	addi	s7,s7,688 # 930 <digits>
 688:	03c9d793          	srli	a5,s3,0x3c
 68c:	97de                	add	a5,a5,s7
 68e:	0007c583          	lbu	a1,0(a5)
 692:	855a                	mv	a0,s6
 694:	d0bff0ef          	jal	39e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 698:	0992                	slli	s3,s3,0x4
 69a:	34fd                	addiw	s1,s1,-1
 69c:	f4f5                	bnez	s1,688 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 69e:	8be6                	mv	s7,s9
      state = 0;
 6a0:	4981                	li	s3,0
 6a2:	6ca2                	ld	s9,8(sp)
 6a4:	bbf5                	j	4a0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	000bc583          	lbu	a1,0(s7)
 6ae:	855a                	mv	a0,s6
 6b0:	cefff0ef          	jal	39e <putc>
 6b4:	8ba6                	mv	s7,s1
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b3e5                	j	4a0 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6ba:	008b8993          	addi	s3,s7,8
 6be:	000bb483          	ld	s1,0(s7)
 6c2:	cc91                	beqz	s1,6de <vprintf+0x282>
        for (; *s; s++)
 6c4:	0004c583          	lbu	a1,0(s1)
 6c8:	c195                	beqz	a1,6ec <vprintf+0x290>
          putc(fd, *s);
 6ca:	855a                	mv	a0,s6
 6cc:	cd3ff0ef          	jal	39e <putc>
        for (; *s; s++)
 6d0:	0485                	addi	s1,s1,1
 6d2:	0004c583          	lbu	a1,0(s1)
 6d6:	f9f5                	bnez	a1,6ca <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6d8:	8bce                	mv	s7,s3
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b3d1                	j	4a0 <vprintf+0x44>
          s = "(null)";
 6de:	00000497          	auipc	s1,0x0
 6e2:	24a48493          	addi	s1,s1,586 # 928 <malloc+0x118>
        for (; *s; s++)
 6e6:	02800593          	li	a1,40
 6ea:	b7c5                	j	6ca <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6ec:	8bce                	mv	s7,s3
      state = 0;
 6ee:	4981                	li	s3,0
 6f0:	bb45                	j	4a0 <vprintf+0x44>
        putc(fd, '%');
 6f2:	85be                	mv	a1,a5
 6f4:	855a                	mv	a0,s6
 6f6:	ca9ff0ef          	jal	39e <putc>
 6fa:	bdbd                	j	578 <vprintf+0x11c>
 6fc:	6906                	ld	s2,64(sp)
 6fe:	79e2                	ld	s3,56(sp)
 700:	7a42                	ld	s4,48(sp)
 702:	7aa2                	ld	s5,40(sp)
 704:	7b02                	ld	s6,32(sp)
 706:	6be2                	ld	s7,24(sp)
 708:	6c42                	ld	s8,16(sp)
    }
  }
}
 70a:	60e6                	ld	ra,88(sp)
 70c:	6446                	ld	s0,80(sp)
 70e:	64a6                	ld	s1,72(sp)
 710:	6125                	addi	sp,sp,96
 712:	8082                	ret
      if (c0 == 'd') {
 714:	06400713          	li	a4,100
 718:	e6e782e3          	beq	a5,a4,57c <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 71c:	f9478693          	addi	a3,a5,-108
 720:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 724:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 726:	4701                	li	a4,0
 728:	bbe9                	j	502 <vprintf+0xa6>

000000000000072a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 72a:	715d                	addi	sp,sp,-80
 72c:	ec06                	sd	ra,24(sp)
 72e:	e822                	sd	s0,16(sp)
 730:	1000                	addi	s0,sp,32
 732:	e010                	sd	a2,0(s0)
 734:	e414                	sd	a3,8(s0)
 736:	e818                	sd	a4,16(s0)
 738:	ec1c                	sd	a5,24(s0)
 73a:	03043023          	sd	a6,32(s0)
 73e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 742:	8622                	mv	a2,s0
 744:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 748:	d15ff0ef          	jal	45c <vprintf>
}
 74c:	60e2                	ld	ra,24(sp)
 74e:	6442                	ld	s0,16(sp)
 750:	6161                	addi	sp,sp,80
 752:	8082                	ret

0000000000000754 <printf>:

void
printf(const char *fmt, ...)
{
 754:	711d                	addi	sp,sp,-96
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e40c                	sd	a1,8(s0)
 75e:	e810                	sd	a2,16(s0)
 760:	ec14                	sd	a3,24(s0)
 762:	f018                	sd	a4,32(s0)
 764:	f41c                	sd	a5,40(s0)
 766:	03043823          	sd	a6,48(s0)
 76a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	00840613          	addi	a2,s0,8
 772:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 776:	85aa                	mv	a1,a0
 778:	4505                	li	a0,1
 77a:	ce3ff0ef          	jal	45c <vprintf>
}
 77e:	60e2                	ld	ra,24(sp)
 780:	6442                	ld	s0,16(sp)
 782:	6125                	addi	sp,sp,96
 784:	8082                	ret

0000000000000786 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 786:	1141                	addi	sp,sp,-16
 788:	e406                	sd	ra,8(sp)
 78a:	e022                	sd	s0,0(sp)
 78c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 78e:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 792:	00001797          	auipc	a5,0x1
 796:	86e7b783          	ld	a5,-1938(a5) # 1000 <freep>
 79a:	a095                	j	7fe <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 79c:	ff852583          	lw	a1,-8(a0)
 7a0:	6390                	ld	a2,0(a5)
 7a2:	02059813          	slli	a6,a1,0x20
 7a6:	01c85693          	srli	a3,a6,0x1c
 7aa:	96ba                	add	a3,a3,a4
 7ac:	02d60563          	beq	a2,a3,7d6 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7b4:	4790                	lw	a2,8(a5)
 7b6:	02061593          	slli	a1,a2,0x20
 7ba:	01c5d693          	srli	a3,a1,0x1c
 7be:	96be                	add	a3,a3,a5
 7c0:	02d70263          	beq	a4,a3,7e4 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7c4:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c6:	00001717          	auipc	a4,0x1
 7ca:	82f73d23          	sd	a5,-1990(a4) # 1000 <freep>
}
 7ce:	60a2                	ld	ra,8(sp)
 7d0:	6402                	ld	s0,0(sp)
 7d2:	0141                	addi	sp,sp,16
 7d4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7d6:	4614                	lw	a3,8(a2)
 7d8:	9ead                	addw	a3,a3,a1
 7da:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7de:	6394                	ld	a3,0(a5)
 7e0:	6290                	ld	a2,0(a3)
 7e2:	b7f9                	j	7b0 <free+0x2a>
    p->s.size += bp->s.size;
 7e4:	ff852703          	lw	a4,-8(a0)
 7e8:	9f31                	addw	a4,a4,a2
 7ea:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ec:	ff053703          	ld	a4,-16(a0)
 7f0:	bfd1                	j	7c4 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f2:	6394                	ld	a3,0(a5)
 7f4:	00d7e463          	bltu	a5,a3,7fc <free+0x76>
 7f8:	fad762e3          	bltu	a4,a3,79c <free+0x16>
 7fc:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7fe:	fee7fae3          	bgeu	a5,a4,7f2 <free+0x6c>
 802:	6394                	ld	a3,0(a5)
 804:	f8d76ce3          	bltu	a4,a3,79c <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 808:	f8d7fae3          	bgeu	a5,a3,79c <free+0x16>
 80c:	87b6                	mv	a5,a3
 80e:	bfc5                	j	7fe <free+0x78>

0000000000000810 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 810:	7139                	addi	sp,sp,-64
 812:	fc06                	sd	ra,56(sp)
 814:	f822                	sd	s0,48(sp)
 816:	f04a                	sd	s2,32(sp)
 818:	ec4e                	sd	s3,24(sp)
 81a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 81c:	02051993          	slli	s3,a0,0x20
 820:	0209d993          	srli	s3,s3,0x20
 824:	09bd                	addi	s3,s3,15
 826:	0049d993          	srli	s3,s3,0x4
 82a:	2985                	addiw	s3,s3,1
 82c:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 82e:	00000517          	auipc	a0,0x0
 832:	7d253503          	ld	a0,2002(a0) # 1000 <freep>
 836:	c905                	beqz	a0,866 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 838:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 83a:	4798                	lw	a4,8(a5)
 83c:	09377663          	bgeu	a4,s3,8c8 <malloc+0xb8>
 840:	f426                	sd	s1,40(sp)
 842:	e852                	sd	s4,16(sp)
 844:	e456                	sd	s5,8(sp)
 846:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 848:	8a4e                	mv	s4,s3
 84a:	6705                	lui	a4,0x1
 84c:	00e9f363          	bgeu	s3,a4,852 <malloc+0x42>
 850:	6a05                	lui	s4,0x1
 852:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 856:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 85a:	00000497          	auipc	s1,0x0
 85e:	7a648493          	addi	s1,s1,1958 # 1000 <freep>
  if (p == SBRK_ERROR)
 862:	5afd                	li	s5,-1
 864:	a83d                	j	8a2 <malloc+0x92>
 866:	f426                	sd	s1,40(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 86e:	00000797          	auipc	a5,0x0
 872:	7a278793          	addi	a5,a5,1954 # 1010 <base>
 876:	00000717          	auipc	a4,0x0
 87a:	78f73523          	sd	a5,1930(a4) # 1000 <freep>
 87e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 880:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 884:	b7d1                	j	848 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 886:	6398                	ld	a4,0(a5)
 888:	e118                	sd	a4,0(a0)
 88a:	a899                	j	8e0 <malloc+0xd0>
  hp->s.size = nu;
 88c:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 890:	0541                	addi	a0,a0,16
 892:	ef5ff0ef          	jal	786 <free>
  return freep;
 896:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 898:	c125                	beqz	a0,8f8 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 89a:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 89c:	4798                	lw	a4,8(a5)
 89e:	03277163          	bgeu	a4,s2,8c0 <malloc+0xb0>
    if (p == freep)
 8a2:	6098                	ld	a4,0(s1)
 8a4:	853e                	mv	a0,a5
 8a6:	fef71ae3          	bne	a4,a5,89a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8aa:	8552                	mv	a0,s4
 8ac:	9f7ff0ef          	jal	2a2 <sbrk>
  if (p == SBRK_ERROR)
 8b0:	fd551ee3          	bne	a0,s5,88c <malloc+0x7c>
        return 0;
 8b4:	4501                	li	a0,0
 8b6:	74a2                	ld	s1,40(sp)
 8b8:	6a42                	ld	s4,16(sp)
 8ba:	6aa2                	ld	s5,8(sp)
 8bc:	6b02                	ld	s6,0(sp)
 8be:	a03d                	j	8ec <malloc+0xdc>
 8c0:	74a2                	ld	s1,40(sp)
 8c2:	6a42                	ld	s4,16(sp)
 8c4:	6aa2                	ld	s5,8(sp)
 8c6:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8c8:	fae90fe3          	beq	s2,a4,886 <malloc+0x76>
        p->s.size -= nunits;
 8cc:	4137073b          	subw	a4,a4,s3
 8d0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d2:	02071693          	slli	a3,a4,0x20
 8d6:	01c6d713          	srli	a4,a3,0x1c
 8da:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8dc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e0:	00000717          	auipc	a4,0x0
 8e4:	72a73023          	sd	a0,1824(a4) # 1000 <freep>
      return (void *)(p + 1);
 8e8:	01078513          	addi	a0,a5,16
  }
}
 8ec:	70e2                	ld	ra,56(sp)
 8ee:	7442                	ld	s0,48(sp)
 8f0:	7902                	ld	s2,32(sp)
 8f2:	69e2                	ld	s3,24(sp)
 8f4:	6121                	addi	sp,sp,64
 8f6:	8082                	ret
 8f8:	74a2                	ld	s1,40(sp)
 8fa:	6a42                	ld	s4,16(sp)
 8fc:	6aa2                	ld	s5,8(sp)
 8fe:	6b02                	ld	s6,0(sp)
 900:	b7f5                	j	8ec <malloc+0xdc>
