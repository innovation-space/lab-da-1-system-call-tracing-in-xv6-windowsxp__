
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
   c:	8e850513          	addi	a0,a0,-1816 # 8f0 <malloc+0xf2>
  10:	732000ef          	jal	742 <printf>
    printf("Greetings from the xv6 kernel!\n");
  14:	00001517          	auipc	a0,0x1
  18:	8ec50513          	addi	a0,a0,-1812 # 900 <malloc+0x102>
  1c:	726000ef          	jal	742 <printf>
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

000000000000038c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 38c:	1101                	addi	sp,sp,-32
 38e:	ec06                	sd	ra,24(sp)
 390:	e822                	sd	s0,16(sp)
 392:	1000                	addi	s0,sp,32
 394:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 398:	4605                	li	a2,1
 39a:	fef40593          	addi	a1,s0,-17
 39e:	f5fff0ef          	jal	2fc <write>
}
 3a2:	60e2                	ld	ra,24(sp)
 3a4:	6442                	ld	s0,16(sp)
 3a6:	6105                	addi	sp,sp,32
 3a8:	8082                	ret

00000000000003aa <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3aa:	715d                	addi	sp,sp,-80
 3ac:	e486                	sd	ra,72(sp)
 3ae:	e0a2                	sd	s0,64(sp)
 3b0:	f84a                	sd	s2,48(sp)
 3b2:	f44e                	sd	s3,40(sp)
 3b4:	0880                	addi	s0,sp,80
 3b6:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3b8:	00d036b3          	snez	a3,a3
 3bc:	03f5d793          	srli	a5,a1,0x3f
 3c0:	8efd                	and	a3,a3,a5
  neg = 0;
 3c2:	4301                	li	t1,0
  if (sgn && xx < 0) {
 3c4:	c681                	beqz	a3,3cc <printint+0x22>
    neg = 1;
    x = -xx;
 3c6:	40b005b3          	neg	a1,a1
    neg = 1;
 3ca:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3cc:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3d0:	86ce                	mv	a3,s3
  i = 0;
 3d2:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 3d4:	00000817          	auipc	a6,0x0
 3d8:	55480813          	addi	a6,a6,1364 # 928 <digits>
 3dc:	88ba                	mv	a7,a4
 3de:	0017051b          	addiw	a0,a4,1
 3e2:	872a                	mv	a4,a0
 3e4:	02c5f7b3          	remu	a5,a1,a2
 3e8:	97c2                	add	a5,a5,a6
 3ea:	0007c783          	lbu	a5,0(a5)
 3ee:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 3f2:	87ae                	mv	a5,a1
 3f4:	02c5d5b3          	divu	a1,a1,a2
 3f8:	0685                	addi	a3,a3,1
 3fa:	fec7f1e3          	bgeu	a5,a2,3dc <printint+0x32>
  if (neg)
 3fe:	00030b63          	beqz	t1,414 <printint+0x6a>
    buf[i++] = '-';
 402:	fd040793          	addi	a5,s0,-48
 406:	953e                	add	a0,a0,a5
 408:	02d00793          	li	a5,45
 40c:	fef50423          	sb	a5,-24(a0)
 410:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 414:	02e05563          	blez	a4,43e <printint+0x94>
 418:	fc26                	sd	s1,56(sp)
 41a:	377d                	addiw	a4,a4,-1
 41c:	00e984b3          	add	s1,s3,a4
 420:	19fd                	addi	s3,s3,-1
 422:	99ba                	add	s3,s3,a4
 424:	1702                	slli	a4,a4,0x20
 426:	9301                	srli	a4,a4,0x20
 428:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42c:	0004c583          	lbu	a1,0(s1)
 430:	854a                	mv	a0,s2
 432:	f5bff0ef          	jal	38c <putc>
  while (--i >= 0)
 436:	14fd                	addi	s1,s1,-1
 438:	ff349ae3          	bne	s1,s3,42c <printint+0x82>
 43c:	74e2                	ld	s1,56(sp)
}
 43e:	60a6                	ld	ra,72(sp)
 440:	6406                	ld	s0,64(sp)
 442:	7942                	ld	s2,48(sp)
 444:	79a2                	ld	s3,40(sp)
 446:	6161                	addi	sp,sp,80
 448:	8082                	ret

000000000000044a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 44a:	711d                	addi	sp,sp,-96
 44c:	ec86                	sd	ra,88(sp)
 44e:	e8a2                	sd	s0,80(sp)
 450:	e4a6                	sd	s1,72(sp)
 452:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 454:	0005c483          	lbu	s1,0(a1)
 458:	2a048063          	beqz	s1,6f8 <vprintf+0x2ae>
 45c:	e0ca                	sd	s2,64(sp)
 45e:	fc4e                	sd	s3,56(sp)
 460:	f852                	sd	s4,48(sp)
 462:	f456                	sd	s5,40(sp)
 464:	f05a                	sd	s6,32(sp)
 466:	ec5e                	sd	s7,24(sp)
 468:	e862                	sd	s8,16(sp)
 46a:	8b2a                	mv	s6,a0
 46c:	8a2e                	mv	s4,a1
 46e:	8bb2                	mv	s7,a2
  state = 0;
 470:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 472:	4901                	li	s2,0
 474:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 476:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 47a:	06400c13          	li	s8,100
 47e:	a00d                	j	4a0 <vprintf+0x56>
        putc(fd, c0);
 480:	85a6                	mv	a1,s1
 482:	855a                	mv	a0,s6
 484:	f09ff0ef          	jal	38c <putc>
 488:	a019                	j	48e <vprintf+0x44>
    } else if (state == '%') {
 48a:	03598363          	beq	s3,s5,4b0 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 48e:	0019079b          	addiw	a5,s2,1
 492:	893e                	mv	s2,a5
 494:	873e                	mv	a4,a5
 496:	97d2                	add	a5,a5,s4
 498:	0007c483          	lbu	s1,0(a5)
 49c:	24048763          	beqz	s1,6ea <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4a0:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4a4:	fe0993e3          	bnez	s3,48a <vprintf+0x40>
      if (c0 == '%') {
 4a8:	fd579ce3          	bne	a5,s5,480 <vprintf+0x36>
        state = '%';
 4ac:	89be                	mv	s3,a5
 4ae:	b7c5                	j	48e <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4b0:	00ea06b3          	add	a3,s4,a4
 4b4:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4b8:	24060563          	beqz	a2,702 <vprintf+0x2b8>
      if (c0 == 'd') {
 4bc:	0b878763          	beq	a5,s8,56a <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 4c0:	f9478693          	addi	a3,a5,-108
 4c4:	0016b693          	seqz	a3,a3
 4c8:	f9c60593          	addi	a1,a2,-100
 4cc:	0015b593          	seqz	a1,a1
 4d0:	8df5                	and	a1,a1,a3
 4d2:	e9c5                	bnez	a1,582 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 4d4:	9752                	add	a4,a4,s4
 4d6:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 4da:	f9460713          	addi	a4,a2,-108
 4de:	00173713          	seqz	a4,a4
 4e2:	8f75                	and	a4,a4,a3
 4e4:	f9c50593          	addi	a1,a0,-100
 4e8:	0015b593          	seqz	a1,a1
 4ec:	8df9                	and	a1,a1,a4
 4ee:	e5dd                	bnez	a1,59c <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 4f0:	07500593          	li	a1,117
 4f4:	0cb78163          	beq	a5,a1,5b6 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 4f8:	f8b60593          	addi	a1,a2,-117
 4fc:	0015b593          	seqz	a1,a1
 500:	8df5                	and	a1,a1,a3
 502:	e5f1                	bnez	a1,5ce <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 504:	f8b50593          	addi	a1,a0,-117
 508:	0015b593          	seqz	a1,a1
 50c:	8df9                	and	a1,a1,a4
 50e:	ede9                	bnez	a1,5e8 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 510:	07800593          	li	a1,120
 514:	0eb78763          	beq	a5,a1,602 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 518:	f8860613          	addi	a2,a2,-120
 51c:	00163613          	seqz	a2,a2
 520:	8ef1                	and	a3,a3,a2
 522:	0e069c63          	bnez	a3,61a <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 526:	f8850513          	addi	a0,a0,-120
 52a:	00153513          	seqz	a0,a0
 52e:	8f69                	and	a4,a4,a0
 530:	10071263          	bnez	a4,634 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 534:	07000713          	li	a4,112
 538:	10e78a63          	beq	a5,a4,64c <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 53c:	06300713          	li	a4,99
 540:	14e78a63          	beq	a5,a4,694 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 544:	07300713          	li	a4,115
 548:	16e78063          	beq	a5,a4,6a8 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 54c:	02500713          	li	a4,37
 550:	18e78863          	beq	a5,a4,6e0 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 554:	02500593          	li	a1,37
 558:	855a                	mv	a0,s6
 55a:	e33ff0ef          	jal	38c <putc>
        putc(fd, c0);
 55e:	85a6                	mv	a1,s1
 560:	855a                	mv	a0,s6
 562:	e2bff0ef          	jal	38c <putc>
      }

      state = 0;
 566:	4981                	li	s3,0
 568:	b71d                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 56a:	008b8493          	addi	s1,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000ba583          	lw	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e33ff0ef          	jal	3aa <printint>
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
 580:	b739                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	008b8493          	addi	s1,s7,8
 586:	4685                	li	a3,1
 588:	4629                	li	a2,10
 58a:	000bb583          	ld	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e1bff0ef          	jal	3aa <printint>
        i += 1;
 594:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
 59a:	bdd5                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4685                	li	a3,1
 5a2:	4629                	li	a2,10
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e01ff0ef          	jal	3aa <printint>
        i += 2;
 5ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	bde9                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000be583          	lwu	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	de7ff0ef          	jal	3aa <printint>
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
 5cc:	b5c9                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4629                	li	a2,10
 5d6:	000bb583          	ld	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	dcfff0ef          	jal	3aa <printint>
        i += 1;
 5e0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	b565                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4629                	li	a2,10
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	db5ff0ef          	jal	3aa <printint>
        i += 2;
 5fa:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
        i += 2;
 600:	b579                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000be583          	lwu	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	d9bff0ef          	jal	3aa <printint>
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
 618:	bd9d                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 61a:	008b8493          	addi	s1,s7,8
 61e:	4681                	li	a3,0
 620:	4641                	li	a2,16
 622:	000bb583          	ld	a1,0(s7)
 626:	855a                	mv	a0,s6
 628:	d83ff0ef          	jal	3aa <printint>
        i += 1;
 62c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	bdb1                	j	48e <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 634:	008b8493          	addi	s1,s7,8
 638:	4641                	li	a2,16
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	d6bff0ef          	jal	3aa <printint>
        i += 2;
 644:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
        i += 2;
 64a:	b591                	j	48e <vprintf+0x44>
 64c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 64e:	008b8793          	addi	a5,s7,8
 652:	8cbe                	mv	s9,a5
 654:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 658:	03000593          	li	a1,48
 65c:	855a                	mv	a0,s6
 65e:	d2fff0ef          	jal	38c <putc>
  putc(fd, 'x');
 662:	07800593          	li	a1,120
 666:	855a                	mv	a0,s6
 668:	d25ff0ef          	jal	38c <putc>
 66c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 66e:	00000b97          	auipc	s7,0x0
 672:	2bab8b93          	addi	s7,s7,698 # 928 <digits>
 676:	03c9d793          	srli	a5,s3,0x3c
 67a:	97de                	add	a5,a5,s7
 67c:	0007c583          	lbu	a1,0(a5)
 680:	855a                	mv	a0,s6
 682:	d0bff0ef          	jal	38c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 686:	0992                	slli	s3,s3,0x4
 688:	34fd                	addiw	s1,s1,-1
 68a:	f4f5                	bnez	s1,676 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 68c:	8be6                	mv	s7,s9
      state = 0;
 68e:	4981                	li	s3,0
 690:	6ca2                	ld	s9,8(sp)
 692:	bbf5                	j	48e <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 694:	008b8493          	addi	s1,s7,8
 698:	000bc583          	lbu	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	cefff0ef          	jal	38c <putc>
 6a2:	8ba6                	mv	s7,s1
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b3e5                	j	48e <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6a8:	008b8993          	addi	s3,s7,8
 6ac:	000bb483          	ld	s1,0(s7)
 6b0:	cc91                	beqz	s1,6cc <vprintf+0x282>
        for (; *s; s++)
 6b2:	0004c583          	lbu	a1,0(s1)
 6b6:	c195                	beqz	a1,6da <vprintf+0x290>
          putc(fd, *s);
 6b8:	855a                	mv	a0,s6
 6ba:	cd3ff0ef          	jal	38c <putc>
        for (; *s; s++)
 6be:	0485                	addi	s1,s1,1
 6c0:	0004c583          	lbu	a1,0(s1)
 6c4:	f9f5                	bnez	a1,6b8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6c6:	8bce                	mv	s7,s3
      state = 0;
 6c8:	4981                	li	s3,0
 6ca:	b3d1                	j	48e <vprintf+0x44>
          s = "(null)";
 6cc:	00000497          	auipc	s1,0x0
 6d0:	25448493          	addi	s1,s1,596 # 920 <malloc+0x122>
        for (; *s; s++)
 6d4:	02800593          	li	a1,40
 6d8:	b7c5                	j	6b8 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 6da:	8bce                	mv	s7,s3
      state = 0;
 6dc:	4981                	li	s3,0
 6de:	bb45                	j	48e <vprintf+0x44>
        putc(fd, '%');
 6e0:	85be                	mv	a1,a5
 6e2:	855a                	mv	a0,s6
 6e4:	ca9ff0ef          	jal	38c <putc>
 6e8:	bdbd                	j	566 <vprintf+0x11c>
 6ea:	6906                	ld	s2,64(sp)
 6ec:	79e2                	ld	s3,56(sp)
 6ee:	7a42                	ld	s4,48(sp)
 6f0:	7aa2                	ld	s5,40(sp)
 6f2:	7b02                	ld	s6,32(sp)
 6f4:	6be2                	ld	s7,24(sp)
 6f6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6f8:	60e6                	ld	ra,88(sp)
 6fa:	6446                	ld	s0,80(sp)
 6fc:	64a6                	ld	s1,72(sp)
 6fe:	6125                	addi	sp,sp,96
 700:	8082                	ret
      if (c0 == 'd') {
 702:	06400713          	li	a4,100
 706:	e6e782e3          	beq	a5,a4,56a <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 70a:	f9478693          	addi	a3,a5,-108
 70e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 712:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 714:	4701                	li	a4,0
 716:	bbe9                	j	4f0 <vprintf+0xa6>

0000000000000718 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 718:	715d                	addi	sp,sp,-80
 71a:	ec06                	sd	ra,24(sp)
 71c:	e822                	sd	s0,16(sp)
 71e:	1000                	addi	s0,sp,32
 720:	e010                	sd	a2,0(s0)
 722:	e414                	sd	a3,8(s0)
 724:	e818                	sd	a4,16(s0)
 726:	ec1c                	sd	a5,24(s0)
 728:	03043023          	sd	a6,32(s0)
 72c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 730:	8622                	mv	a2,s0
 732:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 736:	d15ff0ef          	jal	44a <vprintf>
}
 73a:	60e2                	ld	ra,24(sp)
 73c:	6442                	ld	s0,16(sp)
 73e:	6161                	addi	sp,sp,80
 740:	8082                	ret

0000000000000742 <printf>:

void
printf(const char *fmt, ...)
{
 742:	711d                	addi	sp,sp,-96
 744:	ec06                	sd	ra,24(sp)
 746:	e822                	sd	s0,16(sp)
 748:	1000                	addi	s0,sp,32
 74a:	e40c                	sd	a1,8(s0)
 74c:	e810                	sd	a2,16(s0)
 74e:	ec14                	sd	a3,24(s0)
 750:	f018                	sd	a4,32(s0)
 752:	f41c                	sd	a5,40(s0)
 754:	03043823          	sd	a6,48(s0)
 758:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 75c:	00840613          	addi	a2,s0,8
 760:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 764:	85aa                	mv	a1,a0
 766:	4505                	li	a0,1
 768:	ce3ff0ef          	jal	44a <vprintf>
}
 76c:	60e2                	ld	ra,24(sp)
 76e:	6442                	ld	s0,16(sp)
 770:	6125                	addi	sp,sp,96
 772:	8082                	ret

0000000000000774 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 774:	1141                	addi	sp,sp,-16
 776:	e406                	sd	ra,8(sp)
 778:	e022                	sd	s0,0(sp)
 77a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 77c:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 780:	00001797          	auipc	a5,0x1
 784:	8807b783          	ld	a5,-1920(a5) # 1000 <freep>
 788:	a095                	j	7ec <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 78a:	ff852583          	lw	a1,-8(a0)
 78e:	6390                	ld	a2,0(a5)
 790:	02059813          	slli	a6,a1,0x20
 794:	01c85693          	srli	a3,a6,0x1c
 798:	96ba                	add	a3,a3,a4
 79a:	02d60563          	beq	a2,a3,7c4 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 79e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7a2:	4790                	lw	a2,8(a5)
 7a4:	02061593          	slli	a1,a2,0x20
 7a8:	01c5d693          	srli	a3,a1,0x1c
 7ac:	96be                	add	a3,a3,a5
 7ae:	02d70263          	beq	a4,a3,7d2 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7b2:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7b4:	00001717          	auipc	a4,0x1
 7b8:	84f73623          	sd	a5,-1972(a4) # 1000 <freep>
}
 7bc:	60a2                	ld	ra,8(sp)
 7be:	6402                	ld	s0,0(sp)
 7c0:	0141                	addi	sp,sp,16
 7c2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7c4:	4614                	lw	a3,8(a2)
 7c6:	9ead                	addw	a3,a3,a1
 7c8:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7cc:	6394                	ld	a3,0(a5)
 7ce:	6290                	ld	a2,0(a3)
 7d0:	b7f9                	j	79e <free+0x2a>
    p->s.size += bp->s.size;
 7d2:	ff852703          	lw	a4,-8(a0)
 7d6:	9f31                	addw	a4,a4,a2
 7d8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7da:	ff053703          	ld	a4,-16(a0)
 7de:	bfd1                	j	7b2 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e0:	6394                	ld	a3,0(a5)
 7e2:	00d7e463          	bltu	a5,a3,7ea <free+0x76>
 7e6:	fad762e3          	bltu	a4,a3,78a <free+0x16>
 7ea:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ec:	fee7fae3          	bgeu	a5,a4,7e0 <free+0x6c>
 7f0:	6394                	ld	a3,0(a5)
 7f2:	f8d76ce3          	bltu	a4,a3,78a <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7f6:	f8d7fae3          	bgeu	a5,a3,78a <free+0x16>
 7fa:	87b6                	mv	a5,a3
 7fc:	bfc5                	j	7ec <free+0x78>

00000000000007fe <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 7fe:	7139                	addi	sp,sp,-64
 800:	fc06                	sd	ra,56(sp)
 802:	f822                	sd	s0,48(sp)
 804:	f04a                	sd	s2,32(sp)
 806:	ec4e                	sd	s3,24(sp)
 808:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 80a:	02051993          	slli	s3,a0,0x20
 80e:	0209d993          	srli	s3,s3,0x20
 812:	09bd                	addi	s3,s3,15
 814:	0049d993          	srli	s3,s3,0x4
 818:	2985                	addiw	s3,s3,1
 81a:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 81c:	00000517          	auipc	a0,0x0
 820:	7e453503          	ld	a0,2020(a0) # 1000 <freep>
 824:	c905                	beqz	a0,854 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 826:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 828:	4798                	lw	a4,8(a5)
 82a:	09377663          	bgeu	a4,s3,8b6 <malloc+0xb8>
 82e:	f426                	sd	s1,40(sp)
 830:	e852                	sd	s4,16(sp)
 832:	e456                	sd	s5,8(sp)
 834:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 836:	8a4e                	mv	s4,s3
 838:	6705                	lui	a4,0x1
 83a:	00e9f363          	bgeu	s3,a4,840 <malloc+0x42>
 83e:	6a05                	lui	s4,0x1
 840:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 844:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 848:	00000497          	auipc	s1,0x0
 84c:	7b848493          	addi	s1,s1,1976 # 1000 <freep>
  if (p == SBRK_ERROR)
 850:	5afd                	li	s5,-1
 852:	a83d                	j	890 <malloc+0x92>
 854:	f426                	sd	s1,40(sp)
 856:	e852                	sd	s4,16(sp)
 858:	e456                	sd	s5,8(sp)
 85a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 85c:	00000797          	auipc	a5,0x0
 860:	7b478793          	addi	a5,a5,1972 # 1010 <base>
 864:	00000717          	auipc	a4,0x0
 868:	78f73e23          	sd	a5,1948(a4) # 1000 <freep>
 86c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 86e:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 872:	b7d1                	j	836 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 874:	6398                	ld	a4,0(a5)
 876:	e118                	sd	a4,0(a0)
 878:	a899                	j	8ce <malloc+0xd0>
  hp->s.size = nu;
 87a:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 87e:	0541                	addi	a0,a0,16
 880:	ef5ff0ef          	jal	774 <free>
  return freep;
 884:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 886:	c125                	beqz	a0,8e6 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 888:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 88a:	4798                	lw	a4,8(a5)
 88c:	03277163          	bgeu	a4,s2,8ae <malloc+0xb0>
    if (p == freep)
 890:	6098                	ld	a4,0(s1)
 892:	853e                	mv	a0,a5
 894:	fef71ae3          	bne	a4,a5,888 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 898:	8552                	mv	a0,s4
 89a:	a0fff0ef          	jal	2a8 <sbrk>
  if (p == SBRK_ERROR)
 89e:	fd551ee3          	bne	a0,s5,87a <malloc+0x7c>
        return 0;
 8a2:	4501                	li	a0,0
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
 8ac:	a03d                	j	8da <malloc+0xdc>
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8b6:	fae90fe3          	beq	s2,a4,874 <malloc+0x76>
        p->s.size -= nunits;
 8ba:	4137073b          	subw	a4,a4,s3
 8be:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8c0:	02071693          	slli	a3,a4,0x20
 8c4:	01c6d713          	srli	a4,a3,0x1c
 8c8:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8ca:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ce:	00000717          	auipc	a4,0x0
 8d2:	72a73923          	sd	a0,1842(a4) # 1000 <freep>
      return (void *)(p + 1);
 8d6:	01078513          	addi	a0,a5,16
  }
}
 8da:	70e2                	ld	ra,56(sp)
 8dc:	7442                	ld	s0,48(sp)
 8de:	7902                	ld	s2,32(sp)
 8e0:	69e2                	ld	s3,24(sp)
 8e2:	6121                	addi	sp,sp,64
 8e4:	8082                	ret
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
 8ee:	b7f5                	j	8da <malloc+0xdc>
