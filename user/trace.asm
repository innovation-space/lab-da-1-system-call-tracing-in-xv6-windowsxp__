
user/_trace:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
   a:	84ae                	mv	s1,a1
  if(argc < 3){
   c:	4789                	li	a5,2
   e:	00a7cd63          	blt	a5,a0,28 <main+0x28>
    fprintf(2, "Usage: %s <0|1> <command> [args...]\n", argv[0]);
  12:	6190                	ld	a2,0(a1)
  14:	00001597          	auipc	a1,0x1
  18:	92c58593          	addi	a1,a1,-1748 # 940 <malloc+0xfc>
  1c:	853e                	mv	a0,a5
  1e:	740000ef          	jal	75e <fprintf>
    exit(1);
  22:	4505                	li	a0,1
  24:	2fe000ef          	jal	322 <exit>
  }

  int trace_on = atoi(argv[1]);
  28:	6588                	ld	a0,8(a1)
  2a:	1d2000ef          	jal	1fc <atoi>
  if(trace(trace_on) < 0){
  2e:	39c000ef          	jal	3ca <trace>
  32:	02054263          	bltz	a0,56 <main+0x56>
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }

  exec(argv[2], &argv[2]);
  36:	01048593          	addi	a1,s1,16
  3a:	6888                	ld	a0,16(s1)
  3c:	31e000ef          	jal	35a <exec>
  fprintf(2, "exec %s failed\n", argv[2]);
  40:	6890                	ld	a2,16(s1)
  42:	00001597          	auipc	a1,0x1
  46:	93e58593          	addi	a1,a1,-1730 # 980 <malloc+0x13c>
  4a:	4509                	li	a0,2
  4c:	712000ef          	jal	75e <fprintf>
  exit(1);
  50:	4505                	li	a0,1
  52:	2d0000ef          	jal	322 <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  56:	6090                	ld	a2,0(s1)
  58:	00001597          	auipc	a1,0x1
  5c:	91058593          	addi	a1,a1,-1776 # 968 <malloc+0x124>
  60:	4509                	li	a0,2
  62:	6fc000ef          	jal	75e <fprintf>
    exit(1);
  66:	4505                	li	a0,1
  68:	2ba000ef          	jal	322 <exit>

000000000000006c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  6c:	1141                	addi	sp,sp,-16
  6e:	e406                	sd	ra,8(sp)
  70:	e022                	sd	s0,0(sp)
  72:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  74:	f8dff0ef          	jal	0 <main>
  exit(r);
  78:	2aa000ef          	jal	322 <exit>

000000000000007c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
  7c:	1141                	addi	sp,sp,-16
  7e:	e406                	sd	ra,8(sp)
  80:	e022                	sd	s0,0(sp)
  82:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
  84:	87aa                	mv	a5,a0
  86:	0585                	addi	a1,a1,1
  88:	0785                	addi	a5,a5,1
  8a:	fff5c703          	lbu	a4,-1(a1)
  8e:	fee78fa3          	sb	a4,-1(a5)
  92:	fb75                	bnez	a4,86 <strcpy+0xa>
    ;
  return os;
}
  94:	60a2                	ld	ra,8(sp)
  96:	6402                	ld	s0,0(sp)
  98:	0141                	addi	sp,sp,16
  9a:	8082                	ret

000000000000009c <strcmp>:

int
strcmp(const char *p, const char *q)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	cb91                	beqz	a5,bc <strcmp+0x20>
  aa:	0005c703          	lbu	a4,0(a1)
  ae:	00f71763          	bne	a4,a5,bc <strcmp+0x20>
    p++, q++;
  b2:	0505                	addi	a0,a0,1
  b4:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	fbe5                	bnez	a5,aa <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  bc:	0005c503          	lbu	a0,0(a1)
}
  c0:	40a7853b          	subw	a0,a5,a0
  c4:	60a2                	ld	ra,8(sp)
  c6:	6402                	ld	s0,0(sp)
  c8:	0141                	addi	sp,sp,16
  ca:	8082                	ret

00000000000000cc <strlen>:

uint
strlen(const char *s)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
  d4:	00054783          	lbu	a5,0(a0)
  d8:	cf91                	beqz	a5,f4 <strlen+0x28>
  da:	00150793          	addi	a5,a0,1
  de:	86be                	mv	a3,a5
  e0:	0785                	addi	a5,a5,1
  e2:	fff7c703          	lbu	a4,-1(a5)
  e6:	ff65                	bnez	a4,de <strlen+0x12>
  e8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  for (n = 0; s[n]; n++)
  f4:	4501                	li	a0,0
  f6:	bfdd                	j	ec <strlen+0x20>

00000000000000f8 <memset>:

void *
memset(void *dst, int c, uint n)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 100:	ca19                	beqz	a2,116 <memset+0x1e>
 102:	87aa                	mv	a5,a0
 104:	1602                	slli	a2,a2,0x20
 106:	9201                	srli	a2,a2,0x20
 108:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 10c:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 110:	0785                	addi	a5,a5,1
 112:	fee79de3          	bne	a5,a4,10c <memset+0x14>
  }
  return dst;
}
 116:	60a2                	ld	ra,8(sp)
 118:	6402                	ld	s0,0(sp)
 11a:	0141                	addi	sp,sp,16
 11c:	8082                	ret

000000000000011e <strchr>:

char *
strchr(const char *s, char c)
{
 11e:	1141                	addi	sp,sp,-16
 120:	e406                	sd	ra,8(sp)
 122:	e022                	sd	s0,0(sp)
 124:	0800                	addi	s0,sp,16
  for (; *s; s++)
 126:	00054783          	lbu	a5,0(a0)
 12a:	c799                	beqz	a5,138 <strchr+0x1a>
    if (*s == c)
 12c:	00f58763          	beq	a1,a5,13a <strchr+0x1c>
  for (; *s; s++)
 130:	0505                	addi	a0,a0,1
 132:	00054783          	lbu	a5,0(a0)
 136:	fbfd                	bnez	a5,12c <strchr+0xe>
      return (char *)s;
  return 0;
 138:	4501                	li	a0,0
}
 13a:	60a2                	ld	ra,8(sp)
 13c:	6402                	ld	s0,0(sp)
 13e:	0141                	addi	sp,sp,16
 140:	8082                	ret

0000000000000142 <gets>:

char *
gets(char *buf, int max)
{
 142:	711d                	addi	sp,sp,-96
 144:	ec86                	sd	ra,88(sp)
 146:	e8a2                	sd	s0,80(sp)
 148:	e4a6                	sd	s1,72(sp)
 14a:	e0ca                	sd	s2,64(sp)
 14c:	fc4e                	sd	s3,56(sp)
 14e:	f852                	sd	s4,48(sp)
 150:	f456                	sd	s5,40(sp)
 152:	f05a                	sd	s6,32(sp)
 154:	ec5e                	sd	s7,24(sp)
 156:	e862                	sd	s8,16(sp)
 158:	1080                	addi	s0,sp,96
 15a:	8baa                	mv	s7,a0
 15c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 15e:	892a                	mv	s2,a0
 160:	4481                	li	s1,0
    cc = read(0, &c, 1);
 162:	faf40b13          	addi	s6,s0,-81
 166:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 168:	8c26                	mv	s8,s1
 16a:	0014899b          	addiw	s3,s1,1
 16e:	84ce                	mv	s1,s3
 170:	0349d863          	bge	s3,s4,1a0 <gets+0x5e>
    cc = read(0, &c, 1);
 174:	8656                	mv	a2,s5
 176:	85da                	mv	a1,s6
 178:	4501                	li	a0,0
 17a:	1c0000ef          	jal	33a <read>
    if (cc < 1)
 17e:	02a05163          	blez	a0,1a0 <gets+0x5e>
      break;
    buf[i++] = c;
 182:	faf44783          	lbu	a5,-81(s0)
 186:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 18a:	0905                	addi	s2,s2,1
 18c:	ff678713          	addi	a4,a5,-10
 190:	00173713          	seqz	a4,a4
 194:	17cd                	addi	a5,a5,-13
 196:	0017b793          	seqz	a5,a5
 19a:	8fd9                	or	a5,a5,a4
 19c:	d7f1                	beqz	a5,168 <gets+0x26>
    buf[i++] = c;
 19e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1a0:	9c5e                	add	s8,s8,s7
 1a2:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1a6:	855e                	mv	a0,s7
 1a8:	60e6                	ld	ra,88(sp)
 1aa:	6446                	ld	s0,80(sp)
 1ac:	64a6                	ld	s1,72(sp)
 1ae:	6906                	ld	s2,64(sp)
 1b0:	79e2                	ld	s3,56(sp)
 1b2:	7a42                	ld	s4,48(sp)
 1b4:	7aa2                	ld	s5,40(sp)
 1b6:	7b02                	ld	s6,32(sp)
 1b8:	6be2                	ld	s7,24(sp)
 1ba:	6c42                	ld	s8,16(sp)
 1bc:	6125                	addi	sp,sp,96
 1be:	8082                	ret

00000000000001c0 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c0:	1101                	addi	sp,sp,-32
 1c2:	ec06                	sd	ra,24(sp)
 1c4:	e822                	sd	s0,16(sp)
 1c6:	e04a                	sd	s2,0(sp)
 1c8:	1000                	addi	s0,sp,32
 1ca:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1cc:	4581                	li	a1,0
 1ce:	194000ef          	jal	362 <open>
  if (fd < 0)
 1d2:	02054263          	bltz	a0,1f6 <stat+0x36>
 1d6:	e426                	sd	s1,8(sp)
 1d8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1da:	85ca                	mv	a1,s2
 1dc:	19e000ef          	jal	37a <fstat>
 1e0:	892a                	mv	s2,a0
  close(fd);
 1e2:	8526                	mv	a0,s1
 1e4:	166000ef          	jal	34a <close>
  return r;
 1e8:	64a2                	ld	s1,8(sp)
}
 1ea:	854a                	mv	a0,s2
 1ec:	60e2                	ld	ra,24(sp)
 1ee:	6442                	ld	s0,16(sp)
 1f0:	6902                	ld	s2,0(sp)
 1f2:	6105                	addi	sp,sp,32
 1f4:	8082                	ret
    return -1;
 1f6:	57fd                	li	a5,-1
 1f8:	893e                	mv	s2,a5
 1fa:	bfc5                	j	1ea <stat+0x2a>

00000000000001fc <atoi>:

int
atoi(const char *s)
{
 1fc:	1141                	addi	sp,sp,-16
 1fe:	e406                	sd	ra,8(sp)
 200:	e022                	sd	s0,0(sp)
 202:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 204:	00054683          	lbu	a3,0(a0)
 208:	fd06879b          	addiw	a5,a3,-48
 20c:	0ff7f793          	zext.b	a5,a5
 210:	4625                	li	a2,9
 212:	02f66963          	bltu	a2,a5,244 <atoi+0x48>
 216:	872a                	mv	a4,a0
  n = 0;
 218:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 21a:	0705                	addi	a4,a4,1
 21c:	0025179b          	slliw	a5,a0,0x2
 220:	9fa9                	addw	a5,a5,a0
 222:	0017979b          	slliw	a5,a5,0x1
 226:	9fb5                	addw	a5,a5,a3
 228:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 22c:	00074683          	lbu	a3,0(a4)
 230:	fd06879b          	addiw	a5,a3,-48
 234:	0ff7f793          	zext.b	a5,a5
 238:	fef671e3          	bgeu	a2,a5,21a <atoi+0x1e>
  return n;
}
 23c:	60a2                	ld	ra,8(sp)
 23e:	6402                	ld	s0,0(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
  n = 0;
 244:	4501                	li	a0,0
 246:	bfdd                	j	23c <atoi+0x40>

0000000000000248 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 248:	1141                	addi	sp,sp,-16
 24a:	e406                	sd	ra,8(sp)
 24c:	e022                	sd	s0,0(sp)
 24e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 250:	02b57563          	bgeu	a0,a1,27a <memmove+0x32>
    while (n-- > 0)
 254:	00c05f63          	blez	a2,272 <memmove+0x2a>
 258:	1602                	slli	a2,a2,0x20
 25a:	9201                	srli	a2,a2,0x20
 25c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 260:	872a                	mv	a4,a0
      *dst++ = *src++;
 262:	0585                	addi	a1,a1,1
 264:	0705                	addi	a4,a4,1
 266:	fff5c683          	lbu	a3,-1(a1)
 26a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 26e:	fee79ae3          	bne	a5,a4,262 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
    while (n-- > 0)
 27a:	fec05ce3          	blez	a2,272 <memmove+0x2a>
    dst += n;
 27e:	00c50733          	add	a4,a0,a2
    src += n;
 282:	95b2                	add	a1,a1,a2
 284:	fff6079b          	addiw	a5,a2,-1
 288:	1782                	slli	a5,a5,0x20
 28a:	9381                	srli	a5,a5,0x20
 28c:	fff7c793          	not	a5,a5
 290:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 292:	15fd                	addi	a1,a1,-1
 294:	177d                	addi	a4,a4,-1
 296:	0005c683          	lbu	a3,0(a1)
 29a:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 29e:	fef71ae3          	bne	a4,a5,292 <memmove+0x4a>
 2a2:	bfc1                	j	272 <memmove+0x2a>

00000000000002a4 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2ac:	ce19                	beqz	a2,2ca <memcmp+0x26>
 2ae:	1602                	slli	a2,a2,0x20
 2b0:	9201                	srli	a2,a2,0x20
 2b2:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2b6:	00054783          	lbu	a5,0(a0)
 2ba:	0005c703          	lbu	a4,0(a1)
 2be:	00e79b63          	bne	a5,a4,2d4 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 2c2:	0505                	addi	a0,a0,1
    p2++;
 2c4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2c6:	fed518e3          	bne	a0,a3,2b6 <memcmp+0x12>
  }
  return 0;
 2ca:	4501                	li	a0,0
}
 2cc:	60a2                	ld	ra,8(sp)
 2ce:	6402                	ld	s0,0(sp)
 2d0:	0141                	addi	sp,sp,16
 2d2:	8082                	ret
      return *p1 - *p2;
 2d4:	40e7853b          	subw	a0,a5,a4
 2d8:	bfd5                	j	2cc <memcmp+0x28>

00000000000002da <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2e2:	f67ff0ef          	jal	248 <memmove>
}
 2e6:	60a2                	ld	ra,8(sp)
 2e8:	6402                	ld	s0,0(sp)
 2ea:	0141                	addi	sp,sp,16
 2ec:	8082                	ret

00000000000002ee <sbrk>:

char *
sbrk(int n)
{
 2ee:	1141                	addi	sp,sp,-16
 2f0:	e406                	sd	ra,8(sp)
 2f2:	e022                	sd	s0,0(sp)
 2f4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2f6:	4585                	li	a1,1
 2f8:	0b2000ef          	jal	3aa <sys_sbrk>
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret

0000000000000304 <sbrklazy>:

char *
sbrklazy(int n)
{
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 30c:	4589                	li	a1,2
 30e:	09c000ef          	jal	3aa <sys_sbrk>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 31a:	4885                	li	a7,1
 ecall
 31c:	00000073          	ecall
 ret
 320:	8082                	ret

0000000000000322 <exit>:
.global exit
exit:
 li a7, SYS_exit
 322:	4889                	li	a7,2
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <wait>:
.global wait
wait:
 li a7, SYS_wait
 32a:	488d                	li	a7,3
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 332:	4891                	li	a7,4
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <read>:
.global read
read:
 li a7, SYS_read
 33a:	4895                	li	a7,5
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <write>:
.global write
write:
 li a7, SYS_write
 342:	48c1                	li	a7,16
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <close>:
.global close
close:
 li a7, SYS_close
 34a:	48d5                	li	a7,21
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <kill>:
.global kill
kill:
 li a7, SYS_kill
 352:	4899                	li	a7,6
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <exec>:
.global exec
exec:
 li a7, SYS_exec
 35a:	489d                	li	a7,7
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <open>:
.global open
open:
 li a7, SYS_open
 362:	48bd                	li	a7,15
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 36a:	48c5                	li	a7,17
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 372:	48c9                	li	a7,18
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 37a:	48a1                	li	a7,8
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <link>:
.global link
link:
 li a7, SYS_link
 382:	48cd                	li	a7,19
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 38a:	48d1                	li	a7,20
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 392:	48a5                	li	a7,9
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <dup>:
.global dup
dup:
 li a7, SYS_dup
 39a:	48a9                	li	a7,10
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3a2:	48ad                	li	a7,11
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3aa:	48b1                	li	a7,12
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3b2:	48b5                	li	a7,13
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3ba:	48b9                	li	a7,14
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <sync>:
.global sync
sync:
 li a7, SYS_sync
 3c2:	48d9                	li	a7,22
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <trace>:
.global trace
trace:
 li a7, SYS_trace
 3ca:	48dd                	li	a7,23
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	f5fff0ef          	jal	342 <write>
}
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	6105                	addi	sp,sp,32
 3ee:	8082                	ret

00000000000003f0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f0:	715d                	addi	sp,sp,-80
 3f2:	e486                	sd	ra,72(sp)
 3f4:	e0a2                	sd	s0,64(sp)
 3f6:	f84a                	sd	s2,48(sp)
 3f8:	f44e                	sd	s3,40(sp)
 3fa:	0880                	addi	s0,sp,80
 3fc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 3fe:	00d036b3          	snez	a3,a3
 402:	03f5d793          	srli	a5,a1,0x3f
 406:	8efd                	and	a3,a3,a5
  neg = 0;
 408:	4301                	li	t1,0
  if (sgn && xx < 0) {
 40a:	c681                	beqz	a3,412 <printint+0x22>
    neg = 1;
    x = -xx;
 40c:	40b005b3          	neg	a1,a1
    neg = 1;
 410:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 412:	fb840993          	addi	s3,s0,-72
  neg = 0;
 416:	86ce                	mv	a3,s3
  i = 0;
 418:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 41a:	00000817          	auipc	a6,0x0
 41e:	57e80813          	addi	a6,a6,1406 # 998 <digits>
 422:	88ba                	mv	a7,a4
 424:	0017051b          	addiw	a0,a4,1
 428:	872a                	mv	a4,a0
 42a:	02c5f7b3          	remu	a5,a1,a2
 42e:	97c2                	add	a5,a5,a6
 430:	0007c783          	lbu	a5,0(a5)
 434:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 438:	87ae                	mv	a5,a1
 43a:	02c5d5b3          	divu	a1,a1,a2
 43e:	0685                	addi	a3,a3,1
 440:	fec7f1e3          	bgeu	a5,a2,422 <printint+0x32>
  if (neg)
 444:	00030b63          	beqz	t1,45a <printint+0x6a>
    buf[i++] = '-';
 448:	fd040793          	addi	a5,s0,-48
 44c:	953e                	add	a0,a0,a5
 44e:	02d00793          	li	a5,45
 452:	fef50423          	sb	a5,-24(a0)
 456:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 45a:	02e05563          	blez	a4,484 <printint+0x94>
 45e:	fc26                	sd	s1,56(sp)
 460:	377d                	addiw	a4,a4,-1
 462:	00e984b3          	add	s1,s3,a4
 466:	19fd                	addi	s3,s3,-1
 468:	99ba                	add	s3,s3,a4
 46a:	1702                	slli	a4,a4,0x20
 46c:	9301                	srli	a4,a4,0x20
 46e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 472:	0004c583          	lbu	a1,0(s1)
 476:	854a                	mv	a0,s2
 478:	f5bff0ef          	jal	3d2 <putc>
  while (--i >= 0)
 47c:	14fd                	addi	s1,s1,-1
 47e:	ff349ae3          	bne	s1,s3,472 <printint+0x82>
 482:	74e2                	ld	s1,56(sp)
}
 484:	60a6                	ld	ra,72(sp)
 486:	6406                	ld	s0,64(sp)
 488:	7942                	ld	s2,48(sp)
 48a:	79a2                	ld	s3,40(sp)
 48c:	6161                	addi	sp,sp,80
 48e:	8082                	ret

0000000000000490 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 490:	711d                	addi	sp,sp,-96
 492:	ec86                	sd	ra,88(sp)
 494:	e8a2                	sd	s0,80(sp)
 496:	e4a6                	sd	s1,72(sp)
 498:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 49a:	0005c483          	lbu	s1,0(a1)
 49e:	2a048063          	beqz	s1,73e <vprintf+0x2ae>
 4a2:	e0ca                	sd	s2,64(sp)
 4a4:	fc4e                	sd	s3,56(sp)
 4a6:	f852                	sd	s4,48(sp)
 4a8:	f456                	sd	s5,40(sp)
 4aa:	f05a                	sd	s6,32(sp)
 4ac:	ec5e                	sd	s7,24(sp)
 4ae:	e862                	sd	s8,16(sp)
 4b0:	8b2a                	mv	s6,a0
 4b2:	8a2e                	mv	s4,a1
 4b4:	8bb2                	mv	s7,a2
  state = 0;
 4b6:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4b8:	4901                	li	s2,0
 4ba:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4bc:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4c0:	06400c13          	li	s8,100
 4c4:	a00d                	j	4e6 <vprintf+0x56>
        putc(fd, c0);
 4c6:	85a6                	mv	a1,s1
 4c8:	855a                	mv	a0,s6
 4ca:	f09ff0ef          	jal	3d2 <putc>
 4ce:	a019                	j	4d4 <vprintf+0x44>
    } else if (state == '%') {
 4d0:	03598363          	beq	s3,s5,4f6 <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4d4:	0019079b          	addiw	a5,s2,1
 4d8:	893e                	mv	s2,a5
 4da:	873e                	mv	a4,a5
 4dc:	97d2                	add	a5,a5,s4
 4de:	0007c483          	lbu	s1,0(a5)
 4e2:	24048763          	beqz	s1,730 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4e6:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 4ea:	fe0993e3          	bnez	s3,4d0 <vprintf+0x40>
      if (c0 == '%') {
 4ee:	fd579ce3          	bne	a5,s5,4c6 <vprintf+0x36>
        state = '%';
 4f2:	89be                	mv	s3,a5
 4f4:	b7c5                	j	4d4 <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 4f6:	00ea06b3          	add	a3,s4,a4
 4fa:	0016c603          	lbu	a2,1(a3)
      if (c1)
 4fe:	24060563          	beqz	a2,748 <vprintf+0x2b8>
      if (c0 == 'd') {
 502:	0b878763          	beq	a5,s8,5b0 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 506:	f9478693          	addi	a3,a5,-108
 50a:	0016b693          	seqz	a3,a3
 50e:	f9c60593          	addi	a1,a2,-100
 512:	0015b593          	seqz	a1,a1
 516:	8df5                	and	a1,a1,a3
 518:	e9c5                	bnez	a1,5c8 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 51a:	9752                	add	a4,a4,s4
 51c:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 520:	f9460713          	addi	a4,a2,-108
 524:	00173713          	seqz	a4,a4
 528:	8f75                	and	a4,a4,a3
 52a:	f9c50593          	addi	a1,a0,-100
 52e:	0015b593          	seqz	a1,a1
 532:	8df9                	and	a1,a1,a4
 534:	e5dd                	bnez	a1,5e2 <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 536:	07500593          	li	a1,117
 53a:	0cb78163          	beq	a5,a1,5fc <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 53e:	f8b60593          	addi	a1,a2,-117
 542:	0015b593          	seqz	a1,a1
 546:	8df5                	and	a1,a1,a3
 548:	e5f1                	bnez	a1,614 <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 54a:	f8b50593          	addi	a1,a0,-117
 54e:	0015b593          	seqz	a1,a1
 552:	8df9                	and	a1,a1,a4
 554:	ede9                	bnez	a1,62e <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 556:	07800593          	li	a1,120
 55a:	0eb78763          	beq	a5,a1,648 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 55e:	f8860613          	addi	a2,a2,-120
 562:	00163613          	seqz	a2,a2
 566:	8ef1                	and	a3,a3,a2
 568:	0e069c63          	bnez	a3,660 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 56c:	f8850513          	addi	a0,a0,-120
 570:	00153513          	seqz	a0,a0
 574:	8f69                	and	a4,a4,a0
 576:	10071263          	bnez	a4,67a <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 57a:	07000713          	li	a4,112
 57e:	10e78a63          	beq	a5,a4,692 <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 582:	06300713          	li	a4,99
 586:	14e78a63          	beq	a5,a4,6da <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 58a:	07300713          	li	a4,115
 58e:	16e78063          	beq	a5,a4,6ee <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 592:	02500713          	li	a4,37
 596:	18e78863          	beq	a5,a4,726 <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 59a:	02500593          	li	a1,37
 59e:	855a                	mv	a0,s6
 5a0:	e33ff0ef          	jal	3d2 <putc>
        putc(fd, c0);
 5a4:	85a6                	mv	a1,s1
 5a6:	855a                	mv	a0,s6
 5a8:	e2bff0ef          	jal	3d2 <putc>
      }

      state = 0;
 5ac:	4981                	li	s3,0
 5ae:	b71d                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5b0:	008b8493          	addi	s1,s7,8
 5b4:	4685                	li	a3,1
 5b6:	4629                	li	a2,10
 5b8:	000ba583          	lw	a1,0(s7)
 5bc:	855a                	mv	a0,s6
 5be:	e33ff0ef          	jal	3f0 <printint>
 5c2:	8ba6                	mv	s7,s1
      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b739                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000bb583          	ld	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e1bff0ef          	jal	3f0 <printint>
        i += 1;
 5da:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5dc:	8ba6                	mv	s7,s1
      state = 0;
 5de:	4981                	li	s3,0
 5e0:	bdd5                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e01ff0ef          	jal	3f0 <printint>
        i += 2;
 5f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	bde9                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000be583          	lwu	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	de7ff0ef          	jal	3f0 <printint>
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	b5c9                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	dcfff0ef          	jal	3f0 <printint>
        i += 1;
 626:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b565                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000bb583          	ld	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	db5ff0ef          	jal	3f0 <printint>
        i += 2;
 640:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
        i += 2;
 646:	b579                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000be583          	lwu	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	d9bff0ef          	jal	3f0 <printint>
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bd9d                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d83ff0ef          	jal	3f0 <printint>
        i += 1;
 672:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
 678:	bdb1                	j	4d4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	008b8493          	addi	s1,s7,8
 67e:	4641                	li	a2,16
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d6bff0ef          	jal	3f0 <printint>
        i += 2;
 68a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	b591                	j	4d4 <vprintf+0x44>
 692:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 694:	008b8793          	addi	a5,s7,8
 698:	8cbe                	mv	s9,a5
 69a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 69e:	03000593          	li	a1,48
 6a2:	855a                	mv	a0,s6
 6a4:	d2fff0ef          	jal	3d2 <putc>
  putc(fd, 'x');
 6a8:	07800593          	li	a1,120
 6ac:	855a                	mv	a0,s6
 6ae:	d25ff0ef          	jal	3d2 <putc>
 6b2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b4:	00000b97          	auipc	s7,0x0
 6b8:	2e4b8b93          	addi	s7,s7,740 # 998 <digits>
 6bc:	03c9d793          	srli	a5,s3,0x3c
 6c0:	97de                	add	a5,a5,s7
 6c2:	0007c583          	lbu	a1,0(a5)
 6c6:	855a                	mv	a0,s6
 6c8:	d0bff0ef          	jal	3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6cc:	0992                	slli	s3,s3,0x4
 6ce:	34fd                	addiw	s1,s1,-1
 6d0:	f4f5                	bnez	s1,6bc <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6d2:	8be6                	mv	s7,s9
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	6ca2                	ld	s9,8(sp)
 6d8:	bbf5                	j	4d4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6da:	008b8493          	addi	s1,s7,8
 6de:	000bc583          	lbu	a1,0(s7)
 6e2:	855a                	mv	a0,s6
 6e4:	cefff0ef          	jal	3d2 <putc>
 6e8:	8ba6                	mv	s7,s1
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b3e5                	j	4d4 <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 6ee:	008b8993          	addi	s3,s7,8
 6f2:	000bb483          	ld	s1,0(s7)
 6f6:	cc91                	beqz	s1,712 <vprintf+0x282>
        for (; *s; s++)
 6f8:	0004c583          	lbu	a1,0(s1)
 6fc:	c195                	beqz	a1,720 <vprintf+0x290>
          putc(fd, *s);
 6fe:	855a                	mv	a0,s6
 700:	cd3ff0ef          	jal	3d2 <putc>
        for (; *s; s++)
 704:	0485                	addi	s1,s1,1
 706:	0004c583          	lbu	a1,0(s1)
 70a:	f9f5                	bnez	a1,6fe <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 70c:	8bce                	mv	s7,s3
      state = 0;
 70e:	4981                	li	s3,0
 710:	b3d1                	j	4d4 <vprintf+0x44>
          s = "(null)";
 712:	00000497          	auipc	s1,0x0
 716:	27e48493          	addi	s1,s1,638 # 990 <malloc+0x14c>
        for (; *s; s++)
 71a:	02800593          	li	a1,40
 71e:	b7c5                	j	6fe <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 720:	8bce                	mv	s7,s3
      state = 0;
 722:	4981                	li	s3,0
 724:	bb45                	j	4d4 <vprintf+0x44>
        putc(fd, '%');
 726:	85be                	mv	a1,a5
 728:	855a                	mv	a0,s6
 72a:	ca9ff0ef          	jal	3d2 <putc>
 72e:	bdbd                	j	5ac <vprintf+0x11c>
 730:	6906                	ld	s2,64(sp)
 732:	79e2                	ld	s3,56(sp)
 734:	7a42                	ld	s4,48(sp)
 736:	7aa2                	ld	s5,40(sp)
 738:	7b02                	ld	s6,32(sp)
 73a:	6be2                	ld	s7,24(sp)
 73c:	6c42                	ld	s8,16(sp)
    }
  }
}
 73e:	60e6                	ld	ra,88(sp)
 740:	6446                	ld	s0,80(sp)
 742:	64a6                	ld	s1,72(sp)
 744:	6125                	addi	sp,sp,96
 746:	8082                	ret
      if (c0 == 'd') {
 748:	06400713          	li	a4,100
 74c:	e6e782e3          	beq	a5,a4,5b0 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 750:	f9478693          	addi	a3,a5,-108
 754:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 758:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 75a:	4701                	li	a4,0
 75c:	bbe9                	j	536 <vprintf+0xa6>

000000000000075e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 75e:	715d                	addi	sp,sp,-80
 760:	ec06                	sd	ra,24(sp)
 762:	e822                	sd	s0,16(sp)
 764:	1000                	addi	s0,sp,32
 766:	e010                	sd	a2,0(s0)
 768:	e414                	sd	a3,8(s0)
 76a:	e818                	sd	a4,16(s0)
 76c:	ec1c                	sd	a5,24(s0)
 76e:	03043023          	sd	a6,32(s0)
 772:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 776:	8622                	mv	a2,s0
 778:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 77c:	d15ff0ef          	jal	490 <vprintf>
}
 780:	60e2                	ld	ra,24(sp)
 782:	6442                	ld	s0,16(sp)
 784:	6161                	addi	sp,sp,80
 786:	8082                	ret

0000000000000788 <printf>:

void
printf(const char *fmt, ...)
{
 788:	711d                	addi	sp,sp,-96
 78a:	ec06                	sd	ra,24(sp)
 78c:	e822                	sd	s0,16(sp)
 78e:	1000                	addi	s0,sp,32
 790:	e40c                	sd	a1,8(s0)
 792:	e810                	sd	a2,16(s0)
 794:	ec14                	sd	a3,24(s0)
 796:	f018                	sd	a4,32(s0)
 798:	f41c                	sd	a5,40(s0)
 79a:	03043823          	sd	a6,48(s0)
 79e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a2:	00840613          	addi	a2,s0,8
 7a6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7aa:	85aa                	mv	a1,a0
 7ac:	4505                	li	a0,1
 7ae:	ce3ff0ef          	jal	490 <vprintf>
}
 7b2:	60e2                	ld	ra,24(sp)
 7b4:	6442                	ld	s0,16(sp)
 7b6:	6125                	addi	sp,sp,96
 7b8:	8082                	ret

00000000000007ba <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7ba:	1141                	addi	sp,sp,-16
 7bc:	e406                	sd	ra,8(sp)
 7be:	e022                	sd	s0,0(sp)
 7c0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7c2:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7c6:	00001797          	auipc	a5,0x1
 7ca:	83a7b783          	ld	a5,-1990(a5) # 1000 <freep>
 7ce:	a095                	j	832 <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7d0:	ff852583          	lw	a1,-8(a0)
 7d4:	6390                	ld	a2,0(a5)
 7d6:	02059813          	slli	a6,a1,0x20
 7da:	01c85693          	srli	a3,a6,0x1c
 7de:	96ba                	add	a3,a3,a4
 7e0:	02d60563          	beq	a2,a3,80a <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7e4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 7e8:	4790                	lw	a2,8(a5)
 7ea:	02061593          	slli	a1,a2,0x20
 7ee:	01c5d693          	srli	a3,a1,0x1c
 7f2:	96be                	add	a3,a3,a5
 7f4:	02d70263          	beq	a4,a3,818 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7f8:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7fa:	00001717          	auipc	a4,0x1
 7fe:	80f73323          	sd	a5,-2042(a4) # 1000 <freep>
}
 802:	60a2                	ld	ra,8(sp)
 804:	6402                	ld	s0,0(sp)
 806:	0141                	addi	sp,sp,16
 808:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 80a:	4614                	lw	a3,8(a2)
 80c:	9ead                	addw	a3,a3,a1
 80e:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 812:	6394                	ld	a3,0(a5)
 814:	6290                	ld	a2,0(a3)
 816:	b7f9                	j	7e4 <free+0x2a>
    p->s.size += bp->s.size;
 818:	ff852703          	lw	a4,-8(a0)
 81c:	9f31                	addw	a4,a4,a2
 81e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 820:	ff053703          	ld	a4,-16(a0)
 824:	bfd1                	j	7f8 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 826:	6394                	ld	a3,0(a5)
 828:	00d7e463          	bltu	a5,a3,830 <free+0x76>
 82c:	fad762e3          	bltu	a4,a3,7d0 <free+0x16>
 830:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 832:	fee7fae3          	bgeu	a5,a4,826 <free+0x6c>
 836:	6394                	ld	a3,0(a5)
 838:	f8d76ce3          	bltu	a4,a3,7d0 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83c:	f8d7fae3          	bgeu	a5,a3,7d0 <free+0x16>
 840:	87b6                	mv	a5,a3
 842:	bfc5                	j	832 <free+0x78>

0000000000000844 <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f04a                	sd	s2,32(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 850:	02051993          	slli	s3,a0,0x20
 854:	0209d993          	srli	s3,s3,0x20
 858:	09bd                	addi	s3,s3,15
 85a:	0049d993          	srli	s3,s3,0x4
 85e:	2985                	addiw	s3,s3,1
 860:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 862:	00000517          	auipc	a0,0x0
 866:	79e53503          	ld	a0,1950(a0) # 1000 <freep>
 86a:	c905                	beqz	a0,89a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 86c:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 86e:	4798                	lw	a4,8(a5)
 870:	09377663          	bgeu	a4,s3,8fc <malloc+0xb8>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	6705                	lui	a4,0x1
 880:	00e9f363          	bgeu	s3,a4,886 <malloc+0x42>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 88e:	00000497          	auipc	s1,0x0
 892:	77248493          	addi	s1,s1,1906 # 1000 <freep>
  if (p == SBRK_ERROR)
 896:	5afd                	li	s5,-1
 898:	a83d                	j	8d6 <malloc+0x92>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8b8:	b7d1                	j	87c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a899                	j	914 <malloc+0xd0>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	ef5ff0ef          	jal	7ba <free>
  return freep;
 8ca:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8cc:	c125                	beqz	a0,92c <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8ce:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8d0:	4798                	lw	a4,8(a5)
 8d2:	03277163          	bgeu	a4,s2,8f4 <malloc+0xb0>
    if (p == freep)
 8d6:	6098                	ld	a4,0(s1)
 8d8:	853e                	mv	a0,a5
 8da:	fef71ae3          	bne	a4,a5,8ce <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	a0fff0ef          	jal	2ee <sbrk>
  if (p == SBRK_ERROR)
 8e4:	fd551ee3          	bne	a0,s5,8c0 <malloc+0x7c>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	a03d                	j	920 <malloc+0xdc>
 8f4:	74a2                	ld	s1,40(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 8fc:	fae90fe3          	beq	s2,a4,8ba <malloc+0x76>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	slli	a3,a4,0x20
 90a:	01c6d713          	srli	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void *)(p + 1);
 91c:	01078513          	addi	a0,a5,16
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	7902                	ld	s2,32(sp)
 926:	69e2                	ld	s3,24(sp)
 928:	6121                	addi	sp,sp,64
 92a:	8082                	ret
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	b7f5                	j	920 <malloc+0xdc>
