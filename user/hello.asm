
user/_hello:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "kernel/fcntl.h"
#include "user/user.h"

int main(int argc, char *argv[]){
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
    printf("HI How R U\n");
   8:	00001517          	auipc	a0,0x1
   c:	90850513          	addi	a0,a0,-1784 # 910 <malloc+0xfa>
  10:	74a000ef          	jal	75a <printf>
    printf("Greetings from the xv6 kernel!\n");
  14:	00001517          	auipc	a0,0x1
  18:	90c50513          	addi	a0,a0,-1780 # 920 <malloc+0x10a>
  1c:	73e000ef          	jal	75a <printf>
    exit(0);
  20:	4501                	li	a0,0
  22:	2ba000ef          	jal	2dc <exit>

0000000000000026 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  26:	1141                	addi	sp,sp,-16
  28:	e406                	sd	ra,8(sp)
  2a:	e022                	sd	s0,0(sp)
  2c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  2e:	fd3ff0ef          	jal	0 <main>
  exit(r);
  32:	2aa000ef          	jal	2dc <exit>

0000000000000036 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  36:	1141                	addi	sp,sp,-16
  38:	e406                	sd	ra,8(sp)
  3a:	e022                	sd	s0,0(sp)
  3c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  3e:	87aa                	mv	a5,a0
  40:	0585                	addi	a1,a1,1
  42:	0785                	addi	a5,a5,1
  44:	fff5c703          	lbu	a4,-1(a1)
  48:	fee78fa3          	sb	a4,-1(a5)
  4c:	fb75                	bnez	a4,40 <strcpy+0xa>
    ;
  return os;
}
  4e:	60a2                	ld	ra,8(sp)
  50:	6402                	ld	s0,0(sp)
  52:	0141                	addi	sp,sp,16
  54:	8082                	ret

0000000000000056 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  56:	1141                	addi	sp,sp,-16
  58:	e406                	sd	ra,8(sp)
  5a:	e022                	sd	s0,0(sp)
  5c:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  5e:	00054783          	lbu	a5,0(a0)
  62:	cb91                	beqz	a5,76 <strcmp+0x20>
  64:	0005c703          	lbu	a4,0(a1)
  68:	00f71763          	bne	a4,a5,76 <strcmp+0x20>
    p++, q++;
  6c:	0505                	addi	a0,a0,1
  6e:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  70:	00054783          	lbu	a5,0(a0)
  74:	fbe5                	bnez	a5,64 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  76:	0005c503          	lbu	a0,0(a1)
}
  7a:	40a7853b          	subw	a0,a5,a0
  7e:	60a2                	ld	ra,8(sp)
  80:	6402                	ld	s0,0(sp)
  82:	0141                	addi	sp,sp,16
  84:	8082                	ret

0000000000000086 <strlen>:

uint
strlen(const char *s)
{
  86:	1141                	addi	sp,sp,-16
  88:	e406                	sd	ra,8(sp)
  8a:	e022                	sd	s0,0(sp)
  8c:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  8e:	00054783          	lbu	a5,0(a0)
  92:	cf91                	beqz	a5,ae <strlen+0x28>
  94:	00150793          	addi	a5,a0,1
  98:	86be                	mv	a3,a5
  9a:	0785                	addi	a5,a5,1
  9c:	fff7c703          	lbu	a4,-1(a5)
  a0:	ff65                	bnez	a4,98 <strlen+0x12>
  a2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret
  for (n = 0; s[n]; n++)
  ae:	4501                	li	a0,0
  b0:	bfdd                	j	a6 <strlen+0x20>

00000000000000b2 <memset>:

void *
memset(void *dst, int c, uint n)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
  ba:	ca19                	beqz	a2,d0 <memset+0x1e>
  bc:	87aa                	mv	a5,a0
  be:	1602                	slli	a2,a2,0x20
  c0:	9201                	srli	a2,a2,0x20
  c2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  c6:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
  ca:	0785                	addi	a5,a5,1
  cc:	fee79de3          	bne	a5,a4,c6 <memset+0x14>
  }
  return dst;
}
  d0:	60a2                	ld	ra,8(sp)
  d2:	6402                	ld	s0,0(sp)
  d4:	0141                	addi	sp,sp,16
  d6:	8082                	ret

00000000000000d8 <strchr>:

char *
strchr(const char *s, char c)
{
  d8:	1141                	addi	sp,sp,-16
  da:	e406                	sd	ra,8(sp)
  dc:	e022                	sd	s0,0(sp)
  de:	0800                	addi	s0,sp,16
  for (; *s; s++)
  e0:	00054783          	lbu	a5,0(a0)
  e4:	c799                	beqz	a5,f2 <strchr+0x1a>
    if (*s == c)
  e6:	00f58763          	beq	a1,a5,f4 <strchr+0x1c>
  for (; *s; s++)
  ea:	0505                	addi	a0,a0,1
  ec:	00054783          	lbu	a5,0(a0)
  f0:	fbfd                	bnez	a5,e6 <strchr+0xe>
      return (char *)s;
  return 0;
  f2:	4501                	li	a0,0
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <gets>:

char *
gets(char *buf, int max)
{
  fc:	711d                	addi	sp,sp,-96
  fe:	ec86                	sd	ra,88(sp)
 100:	e8a2                	sd	s0,80(sp)
 102:	e4a6                	sd	s1,72(sp)
 104:	e0ca                	sd	s2,64(sp)
 106:	fc4e                	sd	s3,56(sp)
 108:	f852                	sd	s4,48(sp)
 10a:	f456                	sd	s5,40(sp)
 10c:	f05a                	sd	s6,32(sp)
 10e:	ec5e                	sd	s7,24(sp)
 110:	e862                	sd	s8,16(sp)
 112:	1080                	addi	s0,sp,96
 114:	8baa                	mv	s7,a0
 116:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 118:	892a                	mv	s2,a0
 11a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 11c:	faf40b13          	addi	s6,s0,-81
 120:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 122:	8c26                	mv	s8,s1
 124:	0014899b          	addiw	s3,s1,1
 128:	84ce                	mv	s1,s3
 12a:	0349d863          	bge	s3,s4,15a <gets+0x5e>
    cc = read(0, &c, 1);
 12e:	8656                	mv	a2,s5
 130:	85da                	mv	a1,s6
 132:	4501                	li	a0,0
 134:	1c0000ef          	jal	2f4 <read>
    if (cc < 1)
 138:	02a05163          	blez	a0,15a <gets+0x5e>
      break;
    buf[i++] = c;
 13c:	faf44783          	lbu	a5,-81(s0)
 140:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 144:	0905                	addi	s2,s2,1
 146:	ff678713          	addi	a4,a5,-10
 14a:	00173713          	seqz	a4,a4
 14e:	17cd                	addi	a5,a5,-13
 150:	0017b793          	seqz	a5,a5
 154:	8fd9                	or	a5,a5,a4
 156:	d7f1                	beqz	a5,122 <gets+0x26>
    buf[i++] = c;
 158:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 15a:	9c5e                	add	s8,s8,s7
 15c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 160:	855e                	mv	a0,s7
 162:	60e6                	ld	ra,88(sp)
 164:	6446                	ld	s0,80(sp)
 166:	64a6                	ld	s1,72(sp)
 168:	6906                	ld	s2,64(sp)
 16a:	79e2                	ld	s3,56(sp)
 16c:	7a42                	ld	s4,48(sp)
 16e:	7aa2                	ld	s5,40(sp)
 170:	7b02                	ld	s6,32(sp)
 172:	6be2                	ld	s7,24(sp)
 174:	6c42                	ld	s8,16(sp)
 176:	6125                	addi	sp,sp,96
 178:	8082                	ret

000000000000017a <stat>:

int
stat(const char *n, struct stat *st)
{
 17a:	1101                	addi	sp,sp,-32
 17c:	ec06                	sd	ra,24(sp)
 17e:	e822                	sd	s0,16(sp)
 180:	e04a                	sd	s2,0(sp)
 182:	1000                	addi	s0,sp,32
 184:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 186:	4581                	li	a1,0
 188:	194000ef          	jal	31c <open>
  if (fd < 0)
 18c:	02054263          	bltz	a0,1b0 <stat+0x36>
 190:	e426                	sd	s1,8(sp)
 192:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 194:	85ca                	mv	a1,s2
 196:	19e000ef          	jal	334 <fstat>
 19a:	892a                	mv	s2,a0
  close(fd);
 19c:	8526                	mv	a0,s1
 19e:	166000ef          	jal	304 <close>
  return r;
 1a2:	64a2                	ld	s1,8(sp)
}
 1a4:	854a                	mv	a0,s2
 1a6:	60e2                	ld	ra,24(sp)
 1a8:	6442                	ld	s0,16(sp)
 1aa:	6902                	ld	s2,0(sp)
 1ac:	6105                	addi	sp,sp,32
 1ae:	8082                	ret
    return -1;
 1b0:	57fd                	li	a5,-1
 1b2:	893e                	mv	s2,a5
 1b4:	bfc5                	j	1a4 <stat+0x2a>

00000000000001b6 <atoi>:

int
atoi(const char *s)
{
 1b6:	1141                	addi	sp,sp,-16
 1b8:	e406                	sd	ra,8(sp)
 1ba:	e022                	sd	s0,0(sp)
 1bc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 1be:	00054683          	lbu	a3,0(a0)
 1c2:	fd06879b          	addiw	a5,a3,-48
 1c6:	0ff7f793          	zext.b	a5,a5
 1ca:	4625                	li	a2,9
 1cc:	02f66963          	bltu	a2,a5,1fe <atoi+0x48>
 1d0:	872a                	mv	a4,a0
  n = 0;
 1d2:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 1d4:	0705                	addi	a4,a4,1
 1d6:	0025179b          	slliw	a5,a0,0x2
 1da:	9fa9                	addw	a5,a5,a0
 1dc:	0017979b          	slliw	a5,a5,0x1
 1e0:	9fb5                	addw	a5,a5,a3
 1e2:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 1e6:	00074683          	lbu	a3,0(a4)
 1ea:	fd06879b          	addiw	a5,a3,-48
 1ee:	0ff7f793          	zext.b	a5,a5
 1f2:	fef671e3          	bgeu	a2,a5,1d4 <atoi+0x1e>
  return n;
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret
  n = 0;
 1fe:	4501                	li	a0,0
 200:	bfdd                	j	1f6 <atoi+0x40>

0000000000000202 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 202:	1141                	addi	sp,sp,-16
 204:	e406                	sd	ra,8(sp)
 206:	e022                	sd	s0,0(sp)
 208:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 20a:	02b57563          	bgeu	a0,a1,234 <memmove+0x32>
    while (n-- > 0)
 20e:	00c05f63          	blez	a2,22c <memmove+0x2a>
 212:	1602                	slli	a2,a2,0x20
 214:	9201                	srli	a2,a2,0x20
 216:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 21a:	872a                	mv	a4,a0
      *dst++ = *src++;
 21c:	0585                	addi	a1,a1,1
 21e:	0705                	addi	a4,a4,1
 220:	fff5c683          	lbu	a3,-1(a1)
 224:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 228:	fee79ae3          	bne	a5,a4,21c <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 22c:	60a2                	ld	ra,8(sp)
 22e:	6402                	ld	s0,0(sp)
 230:	0141                	addi	sp,sp,16
 232:	8082                	ret
    while (n-- > 0)
 234:	fec05ce3          	blez	a2,22c <memmove+0x2a>
    dst += n;
 238:	00c50733          	add	a4,a0,a2
    src += n;
 23c:	95b2                	add	a1,a1,a2
 23e:	fff6079b          	addiw	a5,a2,-1
 242:	1782                	slli	a5,a5,0x20
 244:	9381                	srli	a5,a5,0x20
 246:	fff7c793          	not	a5,a5
 24a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 24c:	15fd                	addi	a1,a1,-1
 24e:	177d                	addi	a4,a4,-1
 250:	0005c683          	lbu	a3,0(a1)
 254:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 258:	fef71ae3          	bne	a4,a5,24c <memmove+0x4a>
 25c:	bfc1                	j	22c <memmove+0x2a>

000000000000025e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 25e:	1141                	addi	sp,sp,-16
 260:	e406                	sd	ra,8(sp)
 262:	e022                	sd	s0,0(sp)
 264:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 266:	ce19                	beqz	a2,284 <memcmp+0x26>
 268:	1602                	slli	a2,a2,0x20
 26a:	9201                	srli	a2,a2,0x20
 26c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 270:	00054783          	lbu	a5,0(a0)
 274:	0005c703          	lbu	a4,0(a1)
 278:	00e79b63          	bne	a5,a4,28e <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 27c:	0505                	addi	a0,a0,1
    p2++;
 27e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 280:	fed518e3          	bne	a0,a3,270 <memcmp+0x12>
  }
  return 0;
 284:	4501                	li	a0,0
}
 286:	60a2                	ld	ra,8(sp)
 288:	6402                	ld	s0,0(sp)
 28a:	0141                	addi	sp,sp,16
 28c:	8082                	ret
      return *p1 - *p2;
 28e:	40e7853b          	subw	a0,a5,a4
 292:	bfd5                	j	286 <memcmp+0x28>

0000000000000294 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 294:	1141                	addi	sp,sp,-16
 296:	e406                	sd	ra,8(sp)
 298:	e022                	sd	s0,0(sp)
 29a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 29c:	f67ff0ef          	jal	202 <memmove>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <sbrk>:

char *
sbrk(int n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2b0:	4585                	li	a1,1
 2b2:	0b2000ef          	jal	364 <sys_sbrk>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <sbrklazy>:

char *
sbrklazy(int n)
{
 2be:	1141                	addi	sp,sp,-16
 2c0:	e406                	sd	ra,8(sp)
 2c2:	e022                	sd	s0,0(sp)
 2c4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2c6:	4589                	li	a1,2
 2c8:	09c000ef          	jal	364 <sys_sbrk>
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret

00000000000002d4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2d4:	4885                	li	a7,1
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <exit>:
.global exit
exit:
 li a7, SYS_exit
 2dc:	4889                	li	a7,2
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2e4:	488d                	li	a7,3
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2ec:	4891                	li	a7,4
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <read>:
.global read
read:
 li a7, SYS_read
 2f4:	4895                	li	a7,5
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <write>:
.global write
write:
 li a7, SYS_write
 2fc:	48c1                	li	a7,16
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <close>:
.global close
close:
 li a7, SYS_close
 304:	48d5                	li	a7,21
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <kill>:
.global kill
kill:
 li a7, SYS_kill
 30c:	4899                	li	a7,6
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <exec>:
.global exec
exec:
 li a7, SYS_exec
 314:	489d                	li	a7,7
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <open>:
.global open
open:
 li a7, SYS_open
 31c:	48bd                	li	a7,15
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 324:	48c5                	li	a7,17
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 32c:	48c9                	li	a7,18
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 334:	48a1                	li	a7,8
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <link>:
.global link
link:
 li a7, SYS_link
 33c:	48cd                	li	a7,19
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 344:	48d1                	li	a7,20
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 34c:	48a5                	li	a7,9
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <dup>:
.global dup
dup:
 li a7, SYS_dup
 354:	48a9                	li	a7,10
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 35c:	48ad                	li	a7,11
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 364:	48b1                	li	a7,12
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <pause>:
.global pause
pause:
 li a7, SYS_pause
 36c:	48b5                	li	a7,13
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 374:	48b9                	li	a7,14
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <sync>:
.global sync
sync:
 li a7, SYS_sync
 37c:	48d9                	li	a7,22
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <trace>:
.global trace
trace:
 li a7, SYS_trace
 384:	48dd                	li	a7,23
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <race_inc>:
.global race_inc
race_inc:
 li a7, SYS_race_inc
 38c:	48e1                	li	a7,24
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <race_get>:
.global race_get
race_get:
 li a7, SYS_race_get
 394:	48e5                	li	a7,25
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <race_reset>:
.global race_reset
race_reset:
 li a7, SYS_race_reset
 39c:	48e9                	li	a7,26
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3a4:	1101                	addi	sp,sp,-32
 3a6:	ec06                	sd	ra,24(sp)
 3a8:	e822                	sd	s0,16(sp)
 3aa:	1000                	addi	s0,sp,32
 3ac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b0:	4605                	li	a2,1
 3b2:	fef40593          	addi	a1,s0,-17
 3b6:	f47ff0ef          	jal	2fc <write>
}
 3ba:	60e2                	ld	ra,24(sp)
 3bc:	6442                	ld	s0,16(sp)
 3be:	6105                	addi	sp,sp,32
 3c0:	8082                	ret

00000000000003c2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3c2:	715d                	addi	sp,sp,-80
 3c4:	e486                	sd	ra,72(sp)
 3c6:	e0a2                	sd	s0,64(sp)
 3c8:	f84a                	sd	s2,48(sp)
 3ca:	f44e                	sd	s3,40(sp)
 3cc:	0880                	addi	s0,sp,80
 3ce:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3d0:	00d036b3          	snez	a3,a3
 3d4:	03f5d793          	srli	a5,a1,0x3f
 3d8:	8efd                	and	a3,a3,a5
  neg = 0;
 3da:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3dc:	c681                	beqz	a3,3e4 <printint+0x22>
    neg = 1;
    x = -xx;
 3de:	40b005b3          	neg	a1,a1
    neg = 1;
 3e2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3e8:	86ce                	mv	a3,s3
  i = 0;
 3ea:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3ec:	00000817          	auipc	a6,0x0
 3f0:	55c80813          	addi	a6,a6,1372 # 948 <digits>
 3f4:	88ba                	mv	a7,a4
 3f6:	0017051b          	addiw	a0,a4,1
 3fa:	872a                	mv	a4,a0
 3fc:	02c5f7b3          	remu	a5,a1,a2
 400:	97c2                	add	a5,a5,a6
 402:	0007c783          	lbu	a5,0(a5)
 406:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 40a:	87ae                	mv	a5,a1
 40c:	02c5d5b3          	divu	a1,a1,a2
 410:	0685                	addi	a3,a3,1
 412:	fec7f1e3          	bgeu	a5,a2,3f4 <printint+0x32>
  if (neg)
 416:	00030b63          	beqz	t1,42c <printint+0x6a>
    buf[i++] = '-';
 41a:	fd040793          	addi	a5,s0,-48
 41e:	953e                	add	a0,a0,a5
 420:	02d00793          	li	a5,45
 424:	fef50423          	sb	a5,-24(a0)
 428:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 42c:	02e05563          	blez	a4,456 <printint+0x94>
 430:	fc26                	sd	s1,56(sp)
 432:	377d                	addiw	a4,a4,-1
 434:	00e984b3          	add	s1,s3,a4
 438:	19fd                	addi	s3,s3,-1
 43a:	99ba                	add	s3,s3,a4
 43c:	1702                	slli	a4,a4,0x20
 43e:	9301                	srli	a4,a4,0x20
 440:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 444:	0004c583          	lbu	a1,0(s1)
 448:	854a                	mv	a0,s2
 44a:	f5bff0ef          	jal	3a4 <putc>
  while (--i >= 0)
 44e:	14fd                	addi	s1,s1,-1
 450:	ff349ae3          	bne	s1,s3,444 <printint+0x82>
 454:	74e2                	ld	s1,56(sp)
}
 456:	60a6                	ld	ra,72(sp)
 458:	6406                	ld	s0,64(sp)
 45a:	7942                	ld	s2,48(sp)
 45c:	79a2                	ld	s3,40(sp)
 45e:	6161                	addi	sp,sp,80
 460:	8082                	ret

0000000000000462 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 462:	711d                	addi	sp,sp,-96
 464:	ec86                	sd	ra,88(sp)
 466:	e8a2                	sd	s0,80(sp)
 468:	e4a6                	sd	s1,72(sp)
 46a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 46c:	0005c483          	lbu	s1,0(a1)
 470:	2a048063          	beqz	s1,710 <vprintf+0x2ae>
 474:	e0ca                	sd	s2,64(sp)
 476:	fc4e                	sd	s3,56(sp)
 478:	f852                	sd	s4,48(sp)
 47a:	f456                	sd	s5,40(sp)
 47c:	f05a                	sd	s6,32(sp)
 47e:	ec5e                	sd	s7,24(sp)
 480:	e862                	sd	s8,16(sp)
 482:	8b2a                	mv	s6,a0
 484:	8a2e                	mv	s4,a1
 486:	8bb2                	mv	s7,a2
  state = 0;
 488:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 48a:	4901                	li	s2,0
 48c:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 48e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 492:	06400c13          	li	s8,100
 496:	a00d                	j	4b8 <vprintf+0x56>
        putc(fd, c0);
 498:	85a6                	mv	a1,s1
 49a:	855a                	mv	a0,s6
 49c:	f09ff0ef          	jal	3a4 <putc>
 4a0:	a019                	j	4a6 <vprintf+0x44>
    } else if (state == '%') {
 4a2:	03598363          	beq	s3,s5,4c8 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4a6:	0019079b          	addiw	a5,s2,1
 4aa:	893e                	mv	s2,a5
 4ac:	873e                	mv	a4,a5
 4ae:	97d2                	add	a5,a5,s4
 4b0:	0007c483          	lbu	s1,0(a5)
 4b4:	24048763          	beqz	s1,702 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4b8:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4bc:	fe0993e3          	bnez	s3,4a2 <vprintf+0x40>
      if (c0 == '%') {
 4c0:	fd579ce3          	bne	a5,s5,498 <vprintf+0x36>
        state = '%';
 4c4:	89be                	mv	s3,a5
 4c6:	b7c5                	j	4a6 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4c8:	00ea06b3          	add	a3,s4,a4
 4cc:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4d0:	24060563          	beqz	a2,71a <vprintf+0x2b8>
      if (c0 == 'd') {
 4d4:	0b878763          	beq	a5,s8,582 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4d8:	f9478693          	addi	a3,a5,-108
 4dc:	0016b693          	seqz	a3,a3
 4e0:	f9c60593          	addi	a1,a2,-100
 4e4:	0015b593          	seqz	a1,a1
 4e8:	8df5                	and	a1,a1,a3
 4ea:	e9c5                	bnez	a1,59a <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4ec:	9752                	add	a4,a4,s4
 4ee:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4f2:	f9460713          	addi	a4,a2,-108
 4f6:	00173713          	seqz	a4,a4
 4fa:	8f75                	and	a4,a4,a3
 4fc:	f9c50593          	addi	a1,a0,-100
 500:	0015b593          	seqz	a1,a1
 504:	8df9                	and	a1,a1,a4
 506:	e5dd                	bnez	a1,5b4 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 508:	07500593          	li	a1,117
 50c:	0cb78163          	beq	a5,a1,5ce <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 510:	f8b60593          	addi	a1,a2,-117
 514:	0015b593          	seqz	a1,a1
 518:	8df5                	and	a1,a1,a3
 51a:	e5f1                	bnez	a1,5e6 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 51c:	f8b50593          	addi	a1,a0,-117
 520:	0015b593          	seqz	a1,a1
 524:	8df9                	and	a1,a1,a4
 526:	ede9                	bnez	a1,600 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 528:	07800593          	li	a1,120
 52c:	0eb78763          	beq	a5,a1,61a <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 530:	f8860613          	addi	a2,a2,-120
 534:	00163613          	seqz	a2,a2
 538:	8ef1                	and	a3,a3,a2
 53a:	0e069c63          	bnez	a3,632 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 53e:	f8850513          	addi	a0,a0,-120
 542:	00153513          	seqz	a0,a0
 546:	8f69                	and	a4,a4,a0
 548:	10071263          	bnez	a4,64c <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 54c:	07000713          	li	a4,112
 550:	10e78a63          	beq	a5,a4,664 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 554:	06300713          	li	a4,99
 558:	14e78a63          	beq	a5,a4,6ac <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 55c:	07300713          	li	a4,115
 560:	16e78063          	beq	a5,a4,6c0 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 564:	02500713          	li	a4,37
 568:	18e78863          	beq	a5,a4,6f8 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 56c:	02500593          	li	a1,37
 570:	855a                	mv	a0,s6
 572:	e33ff0ef          	jal	3a4 <putc>
        putc(fd, c0);
 576:	85a6                	mv	a1,s1
 578:	855a                	mv	a0,s6
 57a:	e2bff0ef          	jal	3a4 <putc>
      }

      state = 0;
 57e:	4981                	li	s3,0
 580:	b71d                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 582:	008b8493          	addi	s1,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000ba583          	lw	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e33ff0ef          	jal	3c2 <printint>
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	b739                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4685                	li	a3,1
 5a0:	4629                	li	a2,10
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e1bff0ef          	jal	3c2 <printint>
        i += 1;
 5ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	bdd5                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4685                	li	a3,1
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e01ff0ef          	jal	3c2 <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	bde9                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000be583          	lwu	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	de7ff0ef          	jal	3c2 <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	b5c9                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4629                	li	a2,10
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	dcfff0ef          	jal	3c2 <printint>
        i += 1;
 5f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	b565                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4629                	li	a2,10
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	db5ff0ef          	jal	3c2 <printint>
        i += 2;
 612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b579                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000be583          	lwu	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	d9bff0ef          	jal	3c2 <printint>
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
 630:	bd9d                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	d83ff0ef          	jal	3c2 <printint>
        i += 1;
 644:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
 64a:	bdb1                	j	4a6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 64c:	008b8493          	addi	s1,s7,8
 650:	4641                	li	a2,16
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	d6bff0ef          	jal	3c2 <printint>
        i += 2;
 65c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
        i += 2;
 662:	b591                	j	4a6 <vprintf+0x44>
 664:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 666:	008b8793          	addi	a5,s7,8
 66a:	8cbe                	mv	s9,a5
 66c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 670:	03000593          	li	a1,48
 674:	855a                	mv	a0,s6
 676:	d2fff0ef          	jal	3a4 <putc>
  putc(fd, 'x');
 67a:	07800593          	li	a1,120
 67e:	855a                	mv	a0,s6
 680:	d25ff0ef          	jal	3a4 <putc>
 684:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 686:	00000b97          	auipc	s7,0x0
 68a:	2c2b8b93          	addi	s7,s7,706 # 948 <digits>
 68e:	03c9d793          	srli	a5,s3,0x3c
 692:	97de                	add	a5,a5,s7
 694:	0007c583          	lbu	a1,0(a5)
 698:	855a                	mv	a0,s6
 69a:	d0bff0ef          	jal	3a4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 69e:	0992                	slli	s3,s3,0x4
 6a0:	34fd                	addiw	s1,s1,-1
 6a2:	f4f5                	bnez	s1,68e <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6a4:	8be6                	mv	s7,s9
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	6ca2                	ld	s9,8(sp)
 6aa:	bbf5                	j	4a6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	000bc583          	lbu	a1,0(s7)
 6b4:	855a                	mv	a0,s6
 6b6:	cefff0ef          	jal	3a4 <putc>
 6ba:	8ba6                	mv	s7,s1
      state = 0;
 6bc:	4981                	li	s3,0
 6be:	b3e5                	j	4a6 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6c0:	008b8993          	addi	s3,s7,8
 6c4:	000bb483          	ld	s1,0(s7)
 6c8:	cc91                	beqz	s1,6e4 <vprintf+0x282>
        for (; *s; s++)
 6ca:	0004c583          	lbu	a1,0(s1)
 6ce:	c195                	beqz	a1,6f2 <vprintf+0x290>
          putc(fd, *s);
 6d0:	855a                	mv	a0,s6
 6d2:	cd3ff0ef          	jal	3a4 <putc>
        for (; *s; s++)
 6d6:	0485                	addi	s1,s1,1
 6d8:	0004c583          	lbu	a1,0(s1)
 6dc:	f9f5                	bnez	a1,6d0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6de:	8bce                	mv	s7,s3
      state = 0;
 6e0:	4981                	li	s3,0
 6e2:	b3d1                	j	4a6 <vprintf+0x44>
          s = "(null)";
 6e4:	00000497          	auipc	s1,0x0
 6e8:	25c48493          	addi	s1,s1,604 # 940 <malloc+0x12a>
        for (; *s; s++)
 6ec:	02800593          	li	a1,40
 6f0:	b7c5                	j	6d0 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6f2:	8bce                	mv	s7,s3
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	bb45                	j	4a6 <vprintf+0x44>
        putc(fd, '%');
 6f8:	85be                	mv	a1,a5
 6fa:	855a                	mv	a0,s6
 6fc:	ca9ff0ef          	jal	3a4 <putc>
 700:	bdbd                	j	57e <vprintf+0x11c>
 702:	6906                	ld	s2,64(sp)
 704:	79e2                	ld	s3,56(sp)
 706:	7a42                	ld	s4,48(sp)
 708:	7aa2                	ld	s5,40(sp)
 70a:	7b02                	ld	s6,32(sp)
 70c:	6be2                	ld	s7,24(sp)
 70e:	6c42                	ld	s8,16(sp)
    }
  }
}
 710:	60e6                	ld	ra,88(sp)
 712:	6446                	ld	s0,80(sp)
 714:	64a6                	ld	s1,72(sp)
 716:	6125                	addi	sp,sp,96
 718:	8082                	ret
      if (c0 == 'd') {
 71a:	06400713          	li	a4,100
 71e:	e6e782e3          	beq	a5,a4,582 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 722:	f9478693          	addi	a3,a5,-108
 726:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 72a:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 72c:	4701                	li	a4,0
 72e:	bbe9                	j	508 <vprintf+0xa6>

0000000000000730 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 730:	715d                	addi	sp,sp,-80
 732:	ec06                	sd	ra,24(sp)
 734:	e822                	sd	s0,16(sp)
 736:	1000                	addi	s0,sp,32
 738:	e010                	sd	a2,0(s0)
 73a:	e414                	sd	a3,8(s0)
 73c:	e818                	sd	a4,16(s0)
 73e:	ec1c                	sd	a5,24(s0)
 740:	03043023          	sd	a6,32(s0)
 744:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 748:	8622                	mv	a2,s0
 74a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 74e:	d15ff0ef          	jal	462 <vprintf>
}
 752:	60e2                	ld	ra,24(sp)
 754:	6442                	ld	s0,16(sp)
 756:	6161                	addi	sp,sp,80
 758:	8082                	ret

000000000000075a <printf>:

void
printf(const char *fmt, ...)
{
 75a:	711d                	addi	sp,sp,-96
 75c:	ec06                	sd	ra,24(sp)
 75e:	e822                	sd	s0,16(sp)
 760:	1000                	addi	s0,sp,32
 762:	e40c                	sd	a1,8(s0)
 764:	e810                	sd	a2,16(s0)
 766:	ec14                	sd	a3,24(s0)
 768:	f018                	sd	a4,32(s0)
 76a:	f41c                	sd	a5,40(s0)
 76c:	03043823          	sd	a6,48(s0)
 770:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 774:	00840613          	addi	a2,s0,8
 778:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 77c:	85aa                	mv	a1,a0
 77e:	4505                	li	a0,1
 780:	ce3ff0ef          	jal	462 <vprintf>
}
 784:	60e2                	ld	ra,24(sp)
 786:	6442                	ld	s0,16(sp)
 788:	6125                	addi	sp,sp,96
 78a:	8082                	ret

000000000000078c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 78c:	1141                	addi	sp,sp,-16
 78e:	e406                	sd	ra,8(sp)
 790:	e022                	sd	s0,0(sp)
 792:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 794:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 798:	00001797          	auipc	a5,0x1
 79c:	8687b783          	ld	a5,-1944(a5) # 1000 <freep>
 7a0:	a095                	j	804 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7a2:	ff852583          	lw	a1,-8(a0)
 7a6:	6390                	ld	a2,0(a5)
 7a8:	02059813          	slli	a6,a1,0x20
 7ac:	01c85693          	srli	a3,a6,0x1c
 7b0:	96ba                	add	a3,a3,a4
 7b2:	02d60563          	beq	a2,a3,7dc <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7ba:	4790                	lw	a2,8(a5)
 7bc:	02061593          	slli	a1,a2,0x20
 7c0:	01c5d693          	srli	a3,a1,0x1c
 7c4:	96be                	add	a3,a3,a5
 7c6:	02d70263          	beq	a4,a3,7ea <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ca:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7cc:	00001717          	auipc	a4,0x1
 7d0:	82f73a23          	sd	a5,-1996(a4) # 1000 <freep>
}
 7d4:	60a2                	ld	ra,8(sp)
 7d6:	6402                	ld	s0,0(sp)
 7d8:	0141                	addi	sp,sp,16
 7da:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7dc:	4614                	lw	a3,8(a2)
 7de:	9ead                	addw	a3,a3,a1
 7e0:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	6394                	ld	a3,0(a5)
 7e6:	6290                	ld	a2,0(a3)
 7e8:	b7f9                	j	7b6 <free+0x2a>
    p->s.size += bp->s.size;
 7ea:	ff852703          	lw	a4,-8(a0)
 7ee:	9f31                	addw	a4,a4,a2
 7f0:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7f2:	ff053703          	ld	a4,-16(a0)
 7f6:	bfd1                	j	7ca <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f8:	6394                	ld	a3,0(a5)
 7fa:	00d7e463          	bltu	a5,a3,802 <free+0x76>
 7fe:	fad762e3          	bltu	a4,a3,7a2 <free+0x16>
 802:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 804:	fee7fae3          	bgeu	a5,a4,7f8 <free+0x6c>
 808:	6394                	ld	a3,0(a5)
 80a:	f8d76ce3          	bltu	a4,a3,7a2 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 80e:	f8d7fae3          	bgeu	a5,a3,7a2 <free+0x16>
 812:	87b6                	mv	a5,a3
 814:	bfc5                	j	804 <free+0x78>

0000000000000816 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 816:	7139                	addi	sp,sp,-64
 818:	fc06                	sd	ra,56(sp)
 81a:	f822                	sd	s0,48(sp)
 81c:	f04a                	sd	s2,32(sp)
 81e:	ec4e                	sd	s3,24(sp)
 820:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 822:	02051993          	slli	s3,a0,0x20
 826:	0209d993          	srli	s3,s3,0x20
 82a:	09bd                	addi	s3,s3,15
 82c:	0049d993          	srli	s3,s3,0x4
 830:	2985                	addiw	s3,s3,1
 832:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 834:	00000517          	auipc	a0,0x0
 838:	7cc53503          	ld	a0,1996(a0) # 1000 <freep>
 83c:	c905                	beqz	a0,86c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 83e:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 840:	4798                	lw	a4,8(a5)
 842:	09377663          	bgeu	a4,s3,8ce <malloc+0xb8>
 846:	f426                	sd	s1,40(sp)
 848:	e852                	sd	s4,16(sp)
 84a:	e456                	sd	s5,8(sp)
 84c:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 84e:	8a4e                	mv	s4,s3
 850:	6705                	lui	a4,0x1
 852:	00e9f363          	bgeu	s3,a4,858 <malloc+0x42>
 856:	6a05                	lui	s4,0x1
 858:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 85c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 860:	00000497          	auipc	s1,0x0
 864:	7a048493          	addi	s1,s1,1952 # 1000 <freep>
  if (p == SBRK_ERROR)
 868:	5afd                	li	s5,-1
 86a:	a83d                	j	8a8 <malloc+0x92>
 86c:	f426                	sd	s1,40(sp)
 86e:	e852                	sd	s4,16(sp)
 870:	e456                	sd	s5,8(sp)
 872:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 874:	00000797          	auipc	a5,0x0
 878:	79c78793          	addi	a5,a5,1948 # 1010 <base>
 87c:	00000717          	auipc	a4,0x0
 880:	78f73223          	sd	a5,1924(a4) # 1000 <freep>
 884:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 886:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 88a:	b7d1                	j	84e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 88c:	6398                	ld	a4,0(a5)
 88e:	e118                	sd	a4,0(a0)
 890:	a899                	j	8e6 <malloc+0xd0>
  hp->s.size = nu;
 892:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 896:	0541                	addi	a0,a0,16
 898:	ef5ff0ef          	jal	78c <free>
  return freep;
 89c:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 89e:	c125                	beqz	a0,8fe <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8a0:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8a2:	4798                	lw	a4,8(a5)
 8a4:	03277163          	bgeu	a4,s2,8c6 <malloc+0xb0>
    if (p == freep)
 8a8:	6098                	ld	a4,0(s1)
 8aa:	853e                	mv	a0,a5
 8ac:	fef71ae3          	bne	a4,a5,8a0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b0:	8552                	mv	a0,s4
 8b2:	9f7ff0ef          	jal	2a8 <sbrk>
  if (p == SBRK_ERROR)
 8b6:	fd551ee3          	bne	a0,s5,892 <malloc+0x7c>
        return 0;
 8ba:	4501                	li	a0,0
 8bc:	74a2                	ld	s1,40(sp)
 8be:	6a42                	ld	s4,16(sp)
 8c0:	6aa2                	ld	s5,8(sp)
 8c2:	6b02                	ld	s6,0(sp)
 8c4:	a03d                	j	8f2 <malloc+0xdc>
 8c6:	74a2                	ld	s1,40(sp)
 8c8:	6a42                	ld	s4,16(sp)
 8ca:	6aa2                	ld	s5,8(sp)
 8cc:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8ce:	fae90fe3          	beq	s2,a4,88c <malloc+0x76>
        p->s.size -= nunits;
 8d2:	4137073b          	subw	a4,a4,s3
 8d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8d8:	02071693          	slli	a3,a4,0x20
 8dc:	01c6d713          	srli	a4,a3,0x1c
 8e0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8e6:	00000717          	auipc	a4,0x0
 8ea:	70a73d23          	sd	a0,1818(a4) # 1000 <freep>
      return (void *)(p + 1);
 8ee:	01078513          	addi	a0,a5,16
  }
}
 8f2:	70e2                	ld	ra,56(sp)
 8f4:	7442                	ld	s0,48(sp)
 8f6:	7902                	ld	s2,32(sp)
 8f8:	69e2                	ld	s3,24(sp)
 8fa:	6121                	addi	sp,sp,64
 8fc:	8082                	ret
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	b7f5                	j	8f2 <malloc+0xdc>
