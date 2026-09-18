
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
  18:	93c58593          	addi	a1,a1,-1732 # 950 <malloc+0xf4>
  1c:	853e                	mv	a0,a5
  1e:	758000ef          	jal	776 <fprintf>
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
  46:	94e58593          	addi	a1,a1,-1714 # 990 <malloc+0x134>
  4a:	4509                	li	a0,2
  4c:	72a000ef          	jal	776 <fprintf>
  exit(1);
  50:	4505                	li	a0,1
  52:	2d0000ef          	jal	322 <exit>
    fprintf(2, "%s: trace failed\n", argv[0]);
  56:	6090                	ld	a2,0(s1)
  58:	00001597          	auipc	a1,0x1
  5c:	92058593          	addi	a1,a1,-1760 # 978 <malloc+0x11c>
  60:	4509                	li	a0,2
  62:	714000ef          	jal	776 <fprintf>
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

00000000000003d2 <race_inc>:
.global race_inc
race_inc:
 li a7, SYS_race_inc
 3d2:	48e1                	li	a7,24
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <race_get>:
.global race_get
race_get:
 li a7, SYS_race_get
 3da:	48e5                	li	a7,25
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <race_reset>:
.global race_reset
race_reset:
 li a7, SYS_race_reset
 3e2:	48e9                	li	a7,26
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3ea:	1101                	addi	sp,sp,-32
 3ec:	ec06                	sd	ra,24(sp)
 3ee:	e822                	sd	s0,16(sp)
 3f0:	1000                	addi	s0,sp,32
 3f2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3f6:	4605                	li	a2,1
 3f8:	fef40593          	addi	a1,s0,-17
 3fc:	f47ff0ef          	jal	342 <write>
}
 400:	60e2                	ld	ra,24(sp)
 402:	6442                	ld	s0,16(sp)
 404:	6105                	addi	sp,sp,32
 406:	8082                	ret

0000000000000408 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 408:	715d                	addi	sp,sp,-80
 40a:	e486                	sd	ra,72(sp)
 40c:	e0a2                	sd	s0,64(sp)
 40e:	f84a                	sd	s2,48(sp)
 410:	f44e                	sd	s3,40(sp)
 412:	0880                	addi	s0,sp,80
 414:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 416:	00d036b3          	snez	a3,a3
 41a:	03f5d793          	srli	a5,a1,0x3f
 41e:	8efd                	and	a3,a3,a5
  neg = 0;
 420:	4301                	li	t1,0
  if (sgn && xx < 0) {
 422:	c681                	beqz	a3,42a <printint+0x22>
    neg = 1;
    x = -xx;
 424:	40b005b3          	neg	a1,a1
    neg = 1;
 428:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 42a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 42e:	86ce                	mv	a3,s3
  i = 0;
 430:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 432:	00000817          	auipc	a6,0x0
 436:	57680813          	addi	a6,a6,1398 # 9a8 <digits>
 43a:	88ba                	mv	a7,a4
 43c:	0017051b          	addiw	a0,a4,1
 440:	872a                	mv	a4,a0
 442:	02c5f7b3          	remu	a5,a1,a2
 446:	97c2                	add	a5,a5,a6
 448:	0007c783          	lbu	a5,0(a5)
 44c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 450:	87ae                	mv	a5,a1
 452:	02c5d5b3          	divu	a1,a1,a2
 456:	0685                	addi	a3,a3,1
 458:	fec7f1e3          	bgeu	a5,a2,43a <printint+0x32>
  if (neg)
 45c:	00030b63          	beqz	t1,472 <printint+0x6a>
    buf[i++] = '-';
 460:	fd040793          	addi	a5,s0,-48
 464:	953e                	add	a0,a0,a5
 466:	02d00793          	li	a5,45
 46a:	fef50423          	sb	a5,-24(a0)
 46e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 472:	02e05563          	blez	a4,49c <printint+0x94>
 476:	fc26                	sd	s1,56(sp)
 478:	377d                	addiw	a4,a4,-1
 47a:	00e984b3          	add	s1,s3,a4
 47e:	19fd                	addi	s3,s3,-1
 480:	99ba                	add	s3,s3,a4
 482:	1702                	slli	a4,a4,0x20
 484:	9301                	srli	a4,a4,0x20
 486:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 48a:	0004c583          	lbu	a1,0(s1)
 48e:	854a                	mv	a0,s2
 490:	f5bff0ef          	jal	3ea <putc>
  while (--i >= 0)
 494:	14fd                	addi	s1,s1,-1
 496:	ff349ae3          	bne	s1,s3,48a <printint+0x82>
 49a:	74e2                	ld	s1,56(sp)
}
 49c:	60a6                	ld	ra,72(sp)
 49e:	6406                	ld	s0,64(sp)
 4a0:	7942                	ld	s2,48(sp)
 4a2:	79a2                	ld	s3,40(sp)
 4a4:	6161                	addi	sp,sp,80
 4a6:	8082                	ret

00000000000004a8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a8:	711d                	addi	sp,sp,-96
 4aa:	ec86                	sd	ra,88(sp)
 4ac:	e8a2                	sd	s0,80(sp)
 4ae:	e4a6                	sd	s1,72(sp)
 4b0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 4b2:	0005c483          	lbu	s1,0(a1)
 4b6:	2a048063          	beqz	s1,756 <vprintf+0x2ae>
 4ba:	e0ca                	sd	s2,64(sp)
 4bc:	fc4e                	sd	s3,56(sp)
 4be:	f852                	sd	s4,48(sp)
 4c0:	f456                	sd	s5,40(sp)
 4c2:	f05a                	sd	s6,32(sp)
 4c4:	ec5e                	sd	s7,24(sp)
 4c6:	e862                	sd	s8,16(sp)
 4c8:	8b2a                	mv	s6,a0
 4ca:	8a2e                	mv	s4,a1
 4cc:	8bb2                	mv	s7,a2
  state = 0;
 4ce:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 4d0:	4901                	li	s2,0
 4d2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 4d4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 4d8:	06400c13          	li	s8,100
 4dc:	a00d                	j	4fe <vprintf+0x56>
        putc(fd, c0);
 4de:	85a6                	mv	a1,s1
 4e0:	855a                	mv	a0,s6
 4e2:	f09ff0ef          	jal	3ea <putc>
 4e6:	a019                	j	4ec <vprintf+0x44>
    } else if (state == '%') {
 4e8:	03598363          	beq	s3,s5,50e <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 4ec:	0019079b          	addiw	a5,s2,1
 4f0:	893e                	mv	s2,a5
 4f2:	873e                	mv	a4,a5
 4f4:	97d2                	add	a5,a5,s4
 4f6:	0007c483          	lbu	s1,0(a5)
 4fa:	24048763          	beqz	s1,748 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 4fe:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 502:	fe0993e3          	bnez	s3,4e8 <vprintf+0x40>
      if (c0 == '%') {
 506:	fd579ce3          	bne	a5,s5,4de <vprintf+0x36>
        state = '%';
 50a:	89be                	mv	s3,a5
 50c:	b7c5                	j	4ec <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 50e:	00ea06b3          	add	a3,s4,a4
 512:	0016c603          	lbu	a2,1(a3)
      if (c1)
 516:	24060563          	beqz	a2,760 <vprintf+0x2b8>
      if (c0 == 'd') {
 51a:	0b878763          	beq	a5,s8,5c8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 51e:	f9478693          	addi	a3,a5,-108
 522:	0016b693          	seqz	a3,a3
 526:	f9c60593          	addi	a1,a2,-100
 52a:	0015b593          	seqz	a1,a1
 52e:	8df5                	and	a1,a1,a3
 530:	e9c5                	bnez	a1,5e0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 532:	9752                	add	a4,a4,s4
 534:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 538:	f9460713          	addi	a4,a2,-108
 53c:	00173713          	seqz	a4,a4
 540:	8f75                	and	a4,a4,a3
 542:	f9c50593          	addi	a1,a0,-100
 546:	0015b593          	seqz	a1,a1
 54a:	8df9                	and	a1,a1,a4
 54c:	e5dd                	bnez	a1,5fa <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 54e:	07500593          	li	a1,117
 552:	0cb78163          	beq	a5,a1,614 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 556:	f8b60593          	addi	a1,a2,-117
 55a:	0015b593          	seqz	a1,a1
 55e:	8df5                	and	a1,a1,a3
 560:	e5f1                	bnez	a1,62c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 562:	f8b50593          	addi	a1,a0,-117
 566:	0015b593          	seqz	a1,a1
 56a:	8df9                	and	a1,a1,a4
 56c:	ede9                	bnez	a1,646 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 56e:	07800593          	li	a1,120
 572:	0eb78763          	beq	a5,a1,660 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 576:	f8860613          	addi	a2,a2,-120
 57a:	00163613          	seqz	a2,a2
 57e:	8ef1                	and	a3,a3,a2
 580:	0e069c63          	bnez	a3,678 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 584:	f8850513          	addi	a0,a0,-120
 588:	00153513          	seqz	a0,a0
 58c:	8f69                	and	a4,a4,a0
 58e:	10071263          	bnez	a4,692 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 592:	07000713          	li	a4,112
 596:	10e78a63          	beq	a5,a4,6aa <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 59a:	06300713          	li	a4,99
 59e:	14e78a63          	beq	a5,a4,6f2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 5a2:	07300713          	li	a4,115
 5a6:	16e78063          	beq	a5,a4,706 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 5aa:	02500713          	li	a4,37
 5ae:	18e78863          	beq	a5,a4,73e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 5b2:	02500593          	li	a1,37
 5b6:	855a                	mv	a0,s6
 5b8:	e33ff0ef          	jal	3ea <putc>
        putc(fd, c0);
 5bc:	85a6                	mv	a1,s1
 5be:	855a                	mv	a0,s6
 5c0:	e2bff0ef          	jal	3ea <putc>
      }

      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b71d                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	e33ff0ef          	jal	408 <printint>
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b739                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e0:	008b8493          	addi	s1,s7,8
 5e4:	4685                	li	a3,1
 5e6:	4629                	li	a2,10
 5e8:	000bb583          	ld	a1,0(s7)
 5ec:	855a                	mv	a0,s6
 5ee:	e1bff0ef          	jal	408 <printint>
        i += 1;
 5f2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f4:	8ba6                	mv	s7,s1
      state = 0;
 5f6:	4981                	li	s3,0
 5f8:	bdd5                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fa:	008b8493          	addi	s1,s7,8
 5fe:	4685                	li	a3,1
 600:	4629                	li	a2,10
 602:	000bb583          	ld	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	e01ff0ef          	jal	408 <printint>
        i += 2;
 60c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
        i += 2;
 612:	bde9                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000be583          	lwu	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	de7ff0ef          	jal	408 <printint>
 626:	8ba6                	mv	s7,s1
      state = 0;
 628:	4981                	li	s3,0
 62a:	b5c9                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62c:	008b8493          	addi	s1,s7,8
 630:	4681                	li	a3,0
 632:	4629                	li	a2,10
 634:	000bb583          	ld	a1,0(s7)
 638:	855a                	mv	a0,s6
 63a:	dcfff0ef          	jal	408 <printint>
        i += 1;
 63e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 640:	8ba6                	mv	s7,s1
      state = 0;
 642:	4981                	li	s3,0
 644:	b565                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 646:	008b8493          	addi	s1,s7,8
 64a:	4681                	li	a3,0
 64c:	4629                	li	a2,10
 64e:	000bb583          	ld	a1,0(s7)
 652:	855a                	mv	a0,s6
 654:	db5ff0ef          	jal	408 <printint>
        i += 2;
 658:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
        i += 2;
 65e:	b579                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000be583          	lwu	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d9bff0ef          	jal	408 <printint>
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
 676:	bd9d                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 678:	008b8493          	addi	s1,s7,8
 67c:	4681                	li	a3,0
 67e:	4641                	li	a2,16
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	d83ff0ef          	jal	408 <printint>
        i += 1;
 68a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
 690:	bdb1                	j	4ec <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 692:	008b8493          	addi	s1,s7,8
 696:	4641                	li	a2,16
 698:	000bb583          	ld	a1,0(s7)
 69c:	855a                	mv	a0,s6
 69e:	d6bff0ef          	jal	408 <printint>
        i += 2;
 6a2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
        i += 2;
 6a8:	b591                	j	4ec <vprintf+0x44>
 6aa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6ac:	008b8793          	addi	a5,s7,8
 6b0:	8cbe                	mv	s9,a5
 6b2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6b6:	03000593          	li	a1,48
 6ba:	855a                	mv	a0,s6
 6bc:	d2fff0ef          	jal	3ea <putc>
  putc(fd, 'x');
 6c0:	07800593          	li	a1,120
 6c4:	855a                	mv	a0,s6
 6c6:	d25ff0ef          	jal	3ea <putc>
 6ca:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6cc:	00000b97          	auipc	s7,0x0
 6d0:	2dcb8b93          	addi	s7,s7,732 # 9a8 <digits>
 6d4:	03c9d793          	srli	a5,s3,0x3c
 6d8:	97de                	add	a5,a5,s7
 6da:	0007c583          	lbu	a1,0(a5)
 6de:	855a                	mv	a0,s6
 6e0:	d0bff0ef          	jal	3ea <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e4:	0992                	slli	s3,s3,0x4
 6e6:	34fd                	addiw	s1,s1,-1
 6e8:	f4f5                	bnez	s1,6d4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 6ea:	8be6                	mv	s7,s9
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	6ca2                	ld	s9,8(sp)
 6f0:	bbf5                	j	4ec <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6f2:	008b8493          	addi	s1,s7,8
 6f6:	000bc583          	lbu	a1,0(s7)
 6fa:	855a                	mv	a0,s6
 6fc:	cefff0ef          	jal	3ea <putc>
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	b3e5                	j	4ec <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 706:	008b8993          	addi	s3,s7,8
 70a:	000bb483          	ld	s1,0(s7)
 70e:	cc91                	beqz	s1,72a <vprintf+0x282>
        for (; *s; s++)
 710:	0004c583          	lbu	a1,0(s1)
 714:	c195                	beqz	a1,738 <vprintf+0x290>
          putc(fd, *s);
 716:	855a                	mv	a0,s6
 718:	cd3ff0ef          	jal	3ea <putc>
        for (; *s; s++)
 71c:	0485                	addi	s1,s1,1
 71e:	0004c583          	lbu	a1,0(s1)
 722:	f9f5                	bnez	a1,716 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 724:	8bce                	mv	s7,s3
      state = 0;
 726:	4981                	li	s3,0
 728:	b3d1                	j	4ec <vprintf+0x44>
          s = "(null)";
 72a:	00000497          	auipc	s1,0x0
 72e:	27648493          	addi	s1,s1,630 # 9a0 <malloc+0x144>
        for (; *s; s++)
 732:	02800593          	li	a1,40
 736:	b7c5                	j	716 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 738:	8bce                	mv	s7,s3
      state = 0;
 73a:	4981                	li	s3,0
 73c:	bb45                	j	4ec <vprintf+0x44>
        putc(fd, '%');
 73e:	85be                	mv	a1,a5
 740:	855a                	mv	a0,s6
 742:	ca9ff0ef          	jal	3ea <putc>
 746:	bdbd                	j	5c4 <vprintf+0x11c>
 748:	6906                	ld	s2,64(sp)
 74a:	79e2                	ld	s3,56(sp)
 74c:	7a42                	ld	s4,48(sp)
 74e:	7aa2                	ld	s5,40(sp)
 750:	7b02                	ld	s6,32(sp)
 752:	6be2                	ld	s7,24(sp)
 754:	6c42                	ld	s8,16(sp)
    }
  }
}
 756:	60e6                	ld	ra,88(sp)
 758:	6446                	ld	s0,80(sp)
 75a:	64a6                	ld	s1,72(sp)
 75c:	6125                	addi	sp,sp,96
 75e:	8082                	ret
      if (c0 == 'd') {
 760:	06400713          	li	a4,100
 764:	e6e782e3          	beq	a5,a4,5c8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 768:	f9478693          	addi	a3,a5,-108
 76c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 770:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 772:	4701                	li	a4,0
 774:	bbe9                	j	54e <vprintf+0xa6>

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	8622                	mv	a2,s0
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	d15ff0ef          	jal	4a8 <vprintf>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6161                	addi	sp,sp,80
 79e:	8082                	ret

00000000000007a0 <printf>:

void
printf(const char *fmt, ...)
{
 7a0:	711d                	addi	sp,sp,-96
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e40c                	sd	a1,8(s0)
 7aa:	e810                	sd	a2,16(s0)
 7ac:	ec14                	sd	a3,24(s0)
 7ae:	f018                	sd	a4,32(s0)
 7b0:	f41c                	sd	a5,40(s0)
 7b2:	03043823          	sd	a6,48(s0)
 7b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	00840613          	addi	a2,s0,8
 7be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c2:	85aa                	mv	a1,a0
 7c4:	4505                	li	a0,1
 7c6:	ce3ff0ef          	jal	4a8 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	1141                	addi	sp,sp,-16
 7d4:	e406                	sd	ra,8(sp)
 7d6:	e022                	sd	s0,0(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 7da:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a095                	j	84a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 7e8:	ff852583          	lw	a1,-8(a0)
 7ec:	6390                	ld	a2,0(a5)
 7ee:	02059813          	slli	a6,a1,0x20
 7f2:	01c85693          	srli	a3,a6,0x1c
 7f6:	96ba                	add	a3,a3,a4
 7f8:	02d60563          	beq	a2,a3,822 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7fc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 800:	4790                	lw	a2,8(a5)
 802:	02061593          	slli	a1,a2,0x20
 806:	01c5d693          	srli	a3,a1,0x1c
 80a:	96be                	add	a3,a3,a5
 80c:	02d70263          	beq	a4,a3,830 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 810:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 812:	00000717          	auipc	a4,0x0
 816:	7ef73723          	sd	a5,2030(a4) # 1000 <freep>
}
 81a:	60a2                	ld	ra,8(sp)
 81c:	6402                	ld	s0,0(sp)
 81e:	0141                	addi	sp,sp,16
 820:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 822:	4614                	lw	a3,8(a2)
 824:	9ead                	addw	a3,a3,a1
 826:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 82a:	6394                	ld	a3,0(a5)
 82c:	6290                	ld	a2,0(a3)
 82e:	b7f9                	j	7fc <free+0x2a>
    p->s.size += bp->s.size;
 830:	ff852703          	lw	a4,-8(a0)
 834:	9f31                	addw	a4,a4,a2
 836:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 838:	ff053703          	ld	a4,-16(a0)
 83c:	bfd1                	j	810 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 83e:	6394                	ld	a3,0(a5)
 840:	00d7e463          	bltu	a5,a3,848 <free+0x76>
 844:	fad762e3          	bltu	a4,a3,7e8 <free+0x16>
 848:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84a:	fee7fae3          	bgeu	a5,a4,83e <free+0x6c>
 84e:	6394                	ld	a3,0(a5)
 850:	f8d76ce3          	bltu	a4,a3,7e8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 854:	f8d7fae3          	bgeu	a5,a3,7e8 <free+0x16>
 858:	87b6                	mv	a5,a3
 85a:	bfc5                	j	84a <free+0x78>

000000000000085c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 85c:	7139                	addi	sp,sp,-64
 85e:	fc06                	sd	ra,56(sp)
 860:	f822                	sd	s0,48(sp)
 862:	f04a                	sd	s2,32(sp)
 864:	ec4e                	sd	s3,24(sp)
 866:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 868:	02051993          	slli	s3,a0,0x20
 86c:	0209d993          	srli	s3,s3,0x20
 870:	09bd                	addi	s3,s3,15
 872:	0049d993          	srli	s3,s3,0x4
 876:	2985                	addiw	s3,s3,1
 878:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 87a:	00000517          	auipc	a0,0x0
 87e:	78653503          	ld	a0,1926(a0) # 1000 <freep>
 882:	c905                	beqz	a0,8b2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 884:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 886:	4798                	lw	a4,8(a5)
 888:	09377663          	bgeu	a4,s3,914 <malloc+0xb8>
 88c:	f426                	sd	s1,40(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 894:	8a4e                	mv	s4,s3
 896:	6705                	lui	a4,0x1
 898:	00e9f363          	bgeu	s3,a4,89e <malloc+0x42>
 89c:	6a05                	lui	s4,0x1
 89e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8a2:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 8a6:	00000497          	auipc	s1,0x0
 8aa:	75a48493          	addi	s1,s1,1882 # 1000 <freep>
  if (p == SBRK_ERROR)
 8ae:	5afd                	li	s5,-1
 8b0:	a83d                	j	8ee <malloc+0x92>
 8b2:	f426                	sd	s1,40(sp)
 8b4:	e852                	sd	s4,16(sp)
 8b6:	e456                	sd	s5,8(sp)
 8b8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8ba:	00000797          	auipc	a5,0x0
 8be:	75678793          	addi	a5,a5,1878 # 1010 <base>
 8c2:	00000717          	auipc	a4,0x0
 8c6:	72f73f23          	sd	a5,1854(a4) # 1000 <freep>
 8ca:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8cc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 8d0:	b7d1                	j	894 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8d2:	6398                	ld	a4,0(a5)
 8d4:	e118                	sd	a4,0(a0)
 8d6:	a899                	j	92c <malloc+0xd0>
  hp->s.size = nu;
 8d8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 8dc:	0541                	addi	a0,a0,16
 8de:	ef5ff0ef          	jal	7d2 <free>
  return freep;
 8e2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 8e4:	c125                	beqz	a0,944 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 8e6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 8e8:	4798                	lw	a4,8(a5)
 8ea:	03277163          	bgeu	a4,s2,90c <malloc+0xb0>
    if (p == freep)
 8ee:	6098                	ld	a4,0(s1)
 8f0:	853e                	mv	a0,a5
 8f2:	fef71ae3          	bne	a4,a5,8e6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f6:	8552                	mv	a0,s4
 8f8:	9f7ff0ef          	jal	2ee <sbrk>
  if (p == SBRK_ERROR)
 8fc:	fd551ee3          	bne	a0,s5,8d8 <malloc+0x7c>
        return 0;
 900:	4501                	li	a0,0
 902:	74a2                	ld	s1,40(sp)
 904:	6a42                	ld	s4,16(sp)
 906:	6aa2                	ld	s5,8(sp)
 908:	6b02                	ld	s6,0(sp)
 90a:	a03d                	j	938 <malloc+0xdc>
 90c:	74a2                	ld	s1,40(sp)
 90e:	6a42                	ld	s4,16(sp)
 910:	6aa2                	ld	s5,8(sp)
 912:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 914:	fae90fe3          	beq	s2,a4,8d2 <malloc+0x76>
        p->s.size -= nunits;
 918:	4137073b          	subw	a4,a4,s3
 91c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91e:	02071693          	slli	a3,a4,0x20
 922:	01c6d713          	srli	a4,a3,0x1c
 926:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 928:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 92c:	00000717          	auipc	a4,0x0
 930:	6ca73a23          	sd	a0,1748(a4) # 1000 <freep>
      return (void *)(p + 1);
 934:	01078513          	addi	a0,a5,16
  }
}
 938:	70e2                	ld	ra,56(sp)
 93a:	7442                	ld	s0,48(sp)
 93c:	7902                	ld	s2,32(sp)
 93e:	69e2                	ld	s3,24(sp)
 940:	6121                	addi	sp,sp,64
 942:	8082                	ret
 944:	74a2                	ld	s1,40(sp)
 946:	6a42                	ld	s4,16(sp)
 948:	6aa2                	ld	s5,8(sp)
 94a:	6b02                	ld	s6,0(sp)
 94c:	b7f5                	j	938 <malloc+0xdc>
