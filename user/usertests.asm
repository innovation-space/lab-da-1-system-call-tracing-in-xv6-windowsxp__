
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	be078793          	addi	a5,a5,-1056 # 7bf0 <malloc+0x26a4>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                    0xffffffffffffffff};

  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE | O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	020050ef          	jal	506a <open>
    if (fd >= 0) {
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void *)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	5d450513          	addi	a0,a0,1492 # 5640 <malloc+0xf4>
      74:	41c050ef          	jal	5490 <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	7b1040ef          	jal	502a <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for (i = 0; i < sizeof(uninit); i++) {
      7e:	00009797          	auipc	a5,0x9
      82:	52a78793          	addi	a5,a5,1322 # 95a8 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	c3268693          	addi	a3,a3,-974 # bcb8 <buf>
    if (uninit[i] != '\0') {
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for (i = 0; i < sizeof(uninit); i++) {
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	5ba50513          	addi	a0,a0,1466 # 5660 <malloc+0x114>
      ae:	3e2050ef          	jal	5490 <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	777040ef          	jal	502a <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	5b250513          	addi	a0,a0,1458 # 5678 <malloc+0x12c>
      ce:	79d040ef          	jal	506a <open>
  if (fd < 0) {
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	77d040ef          	jal	5052 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	5bc50513          	addi	a0,a0,1468 # 5698 <malloc+0x14c>
      e4:	787040ef          	jal	506a <open>
  if (fd >= 0) {
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	58850513          	addi	a0,a0,1416 # 5680 <malloc+0x134>
     100:	390050ef          	jal	5490 <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	725040ef          	jal	502a <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	59c50513          	addi	a0,a0,1436 # 56a8 <malloc+0x15c>
     114:	37c050ef          	jal	5490 <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	711040ef          	jal	502a <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	5a250513          	addi	a0,a0,1442 # 56d0 <malloc+0x184>
     136:	745040ef          	jal	507a <unlink>
  int fd1 = open("truncfile", O_CREATE | O_TRUNC | O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	59250513          	addi	a0,a0,1426 # 56d0 <malloc+0x184>
     146:	725040ef          	jal	506a <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	59258593          	addi	a1,a1,1426 # 56e0 <malloc+0x194>
     156:	6f5040ef          	jal	504a <write>
  int fd2 = open("truncfile", O_TRUNC | O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	57250513          	addi	a0,a0,1394 # 56d0 <malloc+0x184>
     166:	705040ef          	jal	506a <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	57a58593          	addi	a1,a1,1402 # 56e8 <malloc+0x19c>
     176:	8526                	mv	a0,s1
     178:	6d3040ef          	jal	504a <write>
  if (n != -1) {
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	54e50513          	addi	a0,a0,1358 # 56d0 <malloc+0x184>
     18a:	6f1040ef          	jal	507a <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	6c3040ef          	jal	5052 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	6bd040ef          	jal	5052 <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	54450513          	addi	a0,a0,1348 # 56f0 <malloc+0x1a4>
     1b4:	2dc050ef          	jal	5490 <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	671040ef          	jal	502a <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE | O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for (i = 0; i < N; i++) {
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE | O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	679040ef          	jal	506a <open>
    close(fd);
     1f6:	65d040ef          	jal	5052 <close>
  for (i = 0; i < N; i++) {
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for (i = 0; i < N; i++) {
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	659040ef          	jal	507a <unlink>
  for (i = 0; i < N; i++) {
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00005517          	auipc	a0,0x5
     260:	4bc50513          	addi	a0,a0,1212 # 5718 <malloc+0x1cc>
     264:	617040ef          	jal	507a <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	4a8a0a13          	addi	s4,s4,1192 # 5718 <malloc+0x1cc>
    if (fd < 0) {
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000c997          	auipc	s3,0xc
     27e:	a3e98993          	addi	s3,s3,-1474 # bcb8 <buf>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <rmdot+0x55>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	5df040ef          	jal	506a <open>
     290:	892a                	mv	s2,a0
    if (fd < 0) {
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	5ad040ef          	jal	504a <write>
      if (cc != sz) {
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for (i = 0; i < 2; i++) {
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	5a5040ef          	jal	5052 <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	5c7040ef          	jal	507a <unlink>
  for (sz = 499; sz < (MAXOPBLOCKS + 2) * BSIZE; sz += 471) {
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00005517          	auipc	a0,0x5
     2e0:	44c50513          	addi	a0,a0,1100 # 5728 <malloc+0x1dc>
     2e4:	1ac050ef          	jal	5490 <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	541040ef          	jal	502a <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	45450513          	addi	a0,a0,1108 # 5748 <malloc+0x1fc>
     2fc:	194050ef          	jal	5490 <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	529040ef          	jal	502a <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;

  unlink("junk");
     31a:	00005517          	auipc	a0,0x5
     31e:	44650513          	addi	a0,a0,1094 # 5760 <malloc+0x214>
     322:	559040ef          	jal	507a <unlink>
     326:	25800913          	li	s2,600
  for (int i = 0; i < assumed_free; i++) {
    int fd = open("junk", O_CREATE | O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	43298993          	addi	s3,s3,1074 # 5760 <malloc+0x214>
    if (fd < 0) {
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char *)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE | O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	529040ef          	jal	506a <open>
     346:	84aa                	mv	s1,a0
    if (fd < 0) {
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char *)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	4fb040ef          	jal	504a <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	4fd040ef          	jal	5052 <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	51f040ef          	jal	507a <unlink>
  for (int i = 0; i < assumed_free; i++) {
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE | O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	3f650513          	addi	a0,a0,1014 # 5760 <malloc+0x214>
     372:	4f9040ef          	jal	506a <open>
     376:	84aa                	mv	s1,a0
  if (fd < 0) {
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if (write(fd, "x", 1) != 1) {
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	36a58593          	addi	a1,a1,874 # 56e8 <malloc+0x19c>
     386:	4c5040ef          	jal	504a <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	3f050513          	addi	a0,a0,1008 # 5780 <malloc+0x234>
     398:	0f8050ef          	jal	5490 <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	48d040ef          	jal	502a <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	3c650513          	addi	a0,a0,966 # 5768 <malloc+0x21c>
     3aa:	0e6050ef          	jal	5490 <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	47b040ef          	jal	502a <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	3b450513          	addi	a0,a0,948 # 5768 <malloc+0x21c>
     3bc:	0d4050ef          	jal	5490 <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	469040ef          	jal	502a <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	48b040ef          	jal	5052 <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	39450513          	addi	a0,a0,916 # 5760 <malloc+0x214>
     3d4:	4a7040ef          	jal	507a <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	451040ef          	jal	502a <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32 * 32;
  for (int i = 0; i < nzz; i++) {
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	447040ef          	jal	507a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	42f040ef          	jal	506a <open>
    if (fd < 0) {
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	40f040ef          	jal	5052 <close>
  for (int i = 0; i < nzz; i++) {
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
  }

  for (int i = 0; i < nzz; i++) {
     44e:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for (int i = 0; i < nzz; i++) {
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	3ed040ef          	jal	507a <unlink>
  for (int i = 0; i < nzz; i++) {
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = {0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00007797          	auipc	a5,0x7
     4c8:	72c78793          	addi	a5,a5,1836 # 7bf0 <malloc+0x26a4>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00005a97          	auipc	s5,0x5
     4fa:	29aa8a93          	addi	s5,s5,666 # 5790 <malloc+0x244>
    int n = write(fd, (void *)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char *)addr, 8192);
     500:	4c05                	li	s8,1
    if (pipe(fds) < 0) {
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE | O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	35d040ef          	jal	506a <open>
     512:	84aa                	mv	s1,a0
    if (fd < 0) {
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void *)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	32f040ef          	jal	504a <write>
    if (n >= 0) {
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	32d040ef          	jal	5052 <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	34f040ef          	jal	507a <unlink>
    n = write(1, (char *)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	315040ef          	jal	504a <write>
    if (n > 0) {
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if (pipe(fds) < 0) {
     53e:	855e                	mv	a0,s7
     540:	2fb040ef          	jal	503a <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char *)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	2fb040ef          	jal	504a <write>
    if (n > 0) {
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	2f7040ef          	jal	5052 <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	2ef040ef          	jal	5052 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	21050513          	addi	a0,a0,528 # 5798 <malloc+0x24c>
     590:	701040ef          	jal	5490 <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	295040ef          	jal	502a <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void *)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	21250513          	addi	a0,a0,530 # 57b0 <malloc+0x264>
     5a6:	6eb040ef          	jal	5490 <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	27f040ef          	jal	502a <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	22c50513          	addi	a0,a0,556 # 57e0 <malloc+0x294>
     5bc:	6d5040ef          	jal	5490 <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	269040ef          	jal	502a <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	24a50513          	addi	a0,a0,586 # 5810 <malloc+0x2c4>
     5ce:	6c3040ef          	jal	5490 <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	257040ef          	jal	502a <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	24450513          	addi	a0,a0,580 # 5820 <malloc+0x2d4>
     5e4:	6ad040ef          	jal	5490 <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	241040ef          	jal	502a <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = {0LL,          0x80000000LL, 0x3fffffe000,
     608:	00007797          	auipc	a5,0x7
     60c:	5e878793          	addi	a5,a5,1512 # 7bf0 <malloc+0x26a4>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00005b17          	auipc	s6,0x5
     640:	214b0b13          	addi	s6,s6,532 # 5850 <malloc+0x304>
    int n = read(fd, (void *)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if (pipe(fds) < 0) {
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	09cb8b93          	addi	s7,s7,156 # 56e8 <malloc+0x19c>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	20f040ef          	jal	506a <open>
     660:	84aa                	mv	s1,a0
    if (fd < 0) {
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void *)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	1d9040ef          	jal	5042 <read>
    if (n > 0) {
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	1df040ef          	jal	5052 <close>
    if (pipe(fds) < 0) {
     678:	8562                	mv	a0,s8
     67a:	1c1040ef          	jal	503a <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	1c1040ef          	jal	504a <write>
    if (n != 1) {
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void *)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	1a9040ef          	jal	5042 <read>
    if (n > 0) {
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	1ad040ef          	jal	5052 <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	1a5040ef          	jal	5052 <close>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00005517          	auipc	a0,0x5
     6d6:	18650513          	addi	a0,a0,390 # 5858 <malloc+0x30c>
     6da:	5b7040ef          	jal	5490 <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	14b040ef          	jal	502a <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void *)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	18850513          	addi	a0,a0,392 # 5870 <malloc+0x324>
     6f0:	5a1040ef          	jal	5490 <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	135040ef          	jal	502a <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	11650513          	addi	a0,a0,278 # 5810 <malloc+0x2c4>
     702:	58f040ef          	jal	5490 <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	123040ef          	jal	502a <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	19450513          	addi	a0,a0,404 # 58a0 <malloc+0x354>
     714:	57d040ef          	jal	5490 <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	111040ef          	jal	502a <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void *)addr,
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	19650513          	addi	a0,a0,406 # 58b8 <malloc+0x36c>
     72a:	567040ef          	jal	5490 <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	0fb040ef          	jal	502a <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	f8850513          	addi	a0,a0,-120 # 56d0 <malloc+0x184>
     750:	12b040ef          	jal	507a <unlink>
  int fd1 = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	f7850513          	addi	a0,a0,-136 # 56d0 <malloc+0x184>
     760:	10b040ef          	jal	506a <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	f7858593          	addi	a1,a1,-136 # 56e0 <malloc+0x194>
     770:	0db040ef          	jal	504a <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	0dd040ef          	jal	5052 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	f5450513          	addi	a0,a0,-172 # 56d0 <malloc+0x184>
     784:	0e7040ef          	jal	506a <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	0b1040ef          	jal	5042 <read>
  if (n != 4) {
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY | O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	f3050513          	addi	a0,a0,-208 # 56d0 <malloc+0x184>
     7a8:	0c3040ef          	jal	506a <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	f2050513          	addi	a0,a0,-224 # 56d0 <malloc+0x184>
     7b8:	0b3040ef          	jal	506a <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	07d040ef          	jal	5042 <read>
     7ca:	8aaa                	mv	s5,a0
  if (n != 0) {
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	06b040ef          	jal	5042 <read>
     7dc:	8aaa                	mv	s5,a0
  if (n != 0) {
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	16658593          	addi	a1,a1,358 # 5948 <malloc+0x3fc>
     7ea:	854e                	mv	a0,s3
     7ec:	05f040ef          	jal	504a <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	049040ef          	jal	5042 <read>
  if (n != 6) {
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	035040ef          	jal	5042 <read>
  if (n != 2) {
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	eb850513          	addi	a0,a0,-328 # 56d0 <malloc+0x184>
     820:	05b040ef          	jal	507a <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	02d040ef          	jal	5052 <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	027040ef          	jal	5052 <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	021040ef          	jal	5052 <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	09c50513          	addi	a0,a0,156 # 58e8 <malloc+0x39c>
     854:	43d040ef          	jal	5490 <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	7d0040ef          	jal	502a <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	0a850513          	addi	a0,a0,168 # 5908 <malloc+0x3bc>
     868:	429040ef          	jal	5490 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	0a850513          	addi	a0,a0,168 # 5918 <malloc+0x3cc>
     878:	419040ef          	jal	5490 <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	7ac040ef          	jal	502a <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	0b450513          	addi	a0,a0,180 # 5938 <malloc+0x3ec>
     88c:	405040ef          	jal	5490 <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	08450513          	addi	a0,a0,132 # 5918 <malloc+0x3cc>
     89c:	3f5040ef          	jal	5490 <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	788040ef          	jal	502a <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	0a650513          	addi	a0,a0,166 # 5950 <malloc+0x404>
     8b2:	3df040ef          	jal	5490 <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	772040ef          	jal	502a <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	0b050513          	addi	a0,a0,176 # 5970 <malloc+0x424>
     8c8:	3c9040ef          	jal	5490 <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	75c040ef          	jal	502a <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE | O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	0a250513          	addi	a0,a0,162 # 5990 <malloc+0x444>
     8f6:	774040ef          	jal	506a <open>
  if (fd < 0) {
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	0b4a0a13          	addi	s4,s4,180 # 59b8 <malloc+0x46c>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     90c:	00005b17          	auipc	s6,0x5
     910:	0e4b0b13          	addi	s6,s6,228 # 59f0 <malloc+0x4a4>
  for (i = 0; i < N; i++) {
     914:	06400a93          	li	s5,100
    if (write(fd, "aaaaaaaaaa", SZ) != SZ) {
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	72c040ef          	jal	504a <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if (write(fd, "bbbbbbbbbb", SZ) != SZ) {
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	71e040ef          	jal	504a <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for (i = 0; i < N; i++) {
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	716040ef          	jal	5052 <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	04e50513          	addi	a0,a0,78 # 5990 <malloc+0x444>
     94a:	720040ef          	jal	506a <open>
     94e:	84aa                	mv	s1,a0
  if (fd < 0) {
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N * SZ * 2);
     954:	7d000613          	li	a2,2000
     958:	0000b597          	auipc	a1,0xb
     95c:	36058593          	addi	a1,a1,864 # bcb8 <buf>
     960:	6e2040ef          	jal	5042 <read>
  if (i != N * SZ * 2) {
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	6e4040ef          	jal	5052 <close>
  if (unlink("small") < 0) {
     972:	00005517          	auipc	a0,0x5
     976:	01e50513          	addi	a0,a0,30 # 5990 <malloc+0x444>
     97a:	700040ef          	jal	507a <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	ffe50513          	addi	a0,a0,-2 # 5998 <malloc+0x44c>
     9a2:	2ef040ef          	jal	5490 <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	682040ef          	jal	502a <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	01850513          	addi	a0,a0,24 # 59c8 <malloc+0x47c>
     9b8:	2d9040ef          	jal	5490 <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	66c040ef          	jal	502a <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	03a50513          	addi	a0,a0,58 # 5a00 <malloc+0x4b4>
     9ce:	2c3040ef          	jal	5490 <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	656040ef          	jal	502a <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	04e50513          	addi	a0,a0,78 # 5a28 <malloc+0x4dc>
     9e2:	2af040ef          	jal	5490 <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	642040ef          	jal	502a <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	05a50513          	addi	a0,a0,90 # 5a48 <malloc+0x4fc>
     9f6:	29b040ef          	jal	5490 <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	62e040ef          	jal	502a <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	05e50513          	addi	a0,a0,94 # 5a60 <malloc+0x514>
     a0a:	287040ef          	jal	5490 <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	61a040ef          	jal	502a <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE | O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	05250513          	addi	a0,a0,82 # 5a80 <malloc+0x534>
     a36:	634040ef          	jal	506a <open>
  if (fd < 0) {
     a3a:	06054a63          	bltz	a0,aae <writebig+0x9a>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int *)buf)[0] = i;
     a42:	0000b997          	auipc	s3,0xb
     a46:	27698993          	addi	s3,s3,630 # bcb8 <buf>
    if (write(fd, buf, BSIZE) != BSIZE) {
     a4a:	40000913          	li	s2,1024
  for (i = 0; i < MAXFILE; i++) {
     a4e:	10c00a93          	li	s5,268
    ((int *)buf)[0] = i;
     a52:	0099a023          	sw	s1,0(s3)
    if (write(fd, buf, BSIZE) != BSIZE) {
     a56:	864a                	mv	a2,s2
     a58:	85ce                	mv	a1,s3
     a5a:	8552                	mv	a0,s4
     a5c:	5ee040ef          	jal	504a <write>
     a60:	07251163          	bne	a0,s2,ac2 <writebig+0xae>
  for (i = 0; i < MAXFILE; i++) {
     a64:	2485                	addiw	s1,s1,1
     a66:	ff5496e3          	bne	s1,s5,a52 <writebig+0x3e>
  close(fd);
     a6a:	8552                	mv	a0,s4
     a6c:	5e6040ef          	jal	5052 <close>
  fd = open("big", O_RDONLY);
     a70:	4581                	li	a1,0
     a72:	00005517          	auipc	a0,0x5
     a76:	00e50513          	addi	a0,a0,14 # 5a80 <malloc+0x534>
     a7a:	5f0040ef          	jal	506a <open>
     a7e:	8a2a                	mv	s4,a0
  n = 0;
     a80:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a82:	40000993          	li	s3,1024
     a86:	0000b917          	auipc	s2,0xb
     a8a:	23290913          	addi	s2,s2,562 # bcb8 <buf>
  if (fd < 0) {
     a8e:	04054563          	bltz	a0,ad8 <writebig+0xc4>
    i = read(fd, buf, BSIZE);
     a92:	864e                	mv	a2,s3
     a94:	85ca                	mv	a1,s2
     a96:	8552                	mv	a0,s4
     a98:	5aa040ef          	jal	5042 <read>
    if (i == 0) {
     a9c:	c921                	beqz	a0,aec <writebig+0xd8>
    } else if (i != BSIZE) {
     a9e:	09351b63          	bne	a0,s3,b34 <writebig+0x120>
    if (((int *)buf)[0] != n) {
     aa2:	00092683          	lw	a3,0(s2)
     aa6:	0a969263          	bne	a3,s1,b4a <writebig+0x136>
    n++;
     aaa:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aac:	b7dd                	j	a92 <writebig+0x7e>
    printf("%s: error: creat big failed!\n", s);
     aae:	85da                	mv	a1,s6
     ab0:	00005517          	auipc	a0,0x5
     ab4:	fd850513          	addi	a0,a0,-40 # 5a88 <malloc+0x53c>
     ab8:	1d9040ef          	jal	5490 <printf>
    exit(1);
     abc:	4505                	li	a0,1
     abe:	56c040ef          	jal	502a <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac2:	8626                	mv	a2,s1
     ac4:	85da                	mv	a1,s6
     ac6:	00005517          	auipc	a0,0x5
     aca:	fe250513          	addi	a0,a0,-30 # 5aa8 <malloc+0x55c>
     ace:	1c3040ef          	jal	5490 <printf>
      exit(1);
     ad2:	4505                	li	a0,1
     ad4:	556040ef          	jal	502a <exit>
    printf("%s: error: open big failed!\n", s);
     ad8:	85da                	mv	a1,s6
     ada:	00005517          	auipc	a0,0x5
     ade:	ff650513          	addi	a0,a0,-10 # 5ad0 <malloc+0x584>
     ae2:	1af040ef          	jal	5490 <printf>
    exit(1);
     ae6:	4505                	li	a0,1
     ae8:	542040ef          	jal	502a <exit>
      if (n != MAXFILE) {
     aec:	10c00793          	li	a5,268
     af0:	02f49763          	bne	s1,a5,b1e <writebig+0x10a>
  close(fd);
     af4:	8552                	mv	a0,s4
     af6:	55c040ef          	jal	5052 <close>
  if (unlink("big") < 0) {
     afa:	00005517          	auipc	a0,0x5
     afe:	f8650513          	addi	a0,a0,-122 # 5a80 <malloc+0x534>
     b02:	578040ef          	jal	507a <unlink>
     b06:	04054d63          	bltz	a0,b60 <writebig+0x14c>
}
     b0a:	70e2                	ld	ra,56(sp)
     b0c:	7442                	ld	s0,48(sp)
     b0e:	74a2                	ld	s1,40(sp)
     b10:	7902                	ld	s2,32(sp)
     b12:	69e2                	ld	s3,24(sp)
     b14:	6a42                	ld	s4,16(sp)
     b16:	6aa2                	ld	s5,8(sp)
     b18:	6b02                	ld	s6,0(sp)
     b1a:	6121                	addi	sp,sp,64
     b1c:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b1e:	8626                	mv	a2,s1
     b20:	85da                	mv	a1,s6
     b22:	00005517          	auipc	a0,0x5
     b26:	fce50513          	addi	a0,a0,-50 # 5af0 <malloc+0x5a4>
     b2a:	167040ef          	jal	5490 <printf>
        exit(1);
     b2e:	4505                	li	a0,1
     b30:	4fa040ef          	jal	502a <exit>
      printf("%s: read failed %d\n", s, i);
     b34:	862a                	mv	a2,a0
     b36:	85da                	mv	a1,s6
     b38:	00005517          	auipc	a0,0x5
     b3c:	fe050513          	addi	a0,a0,-32 # 5b18 <malloc+0x5cc>
     b40:	151040ef          	jal	5490 <printf>
      exit(1);
     b44:	4505                	li	a0,1
     b46:	4e4040ef          	jal	502a <exit>
      printf("%s: read content of block %d is %d\n", s, n, ((int *)buf)[0]);
     b4a:	8626                	mv	a2,s1
     b4c:	85da                	mv	a1,s6
     b4e:	00005517          	auipc	a0,0x5
     b52:	fe250513          	addi	a0,a0,-30 # 5b30 <malloc+0x5e4>
     b56:	13b040ef          	jal	5490 <printf>
      exit(1);
     b5a:	4505                	li	a0,1
     b5c:	4ce040ef          	jal	502a <exit>
    printf("%s: unlink big failed\n", s);
     b60:	85da                	mv	a1,s6
     b62:	00005517          	auipc	a0,0x5
     b66:	ff650513          	addi	a0,a0,-10 # 5b58 <malloc+0x60c>
     b6a:	127040ef          	jal	5490 <printf>
    exit(1);
     b6e:	4505                	li	a0,1
     b70:	4ba040ef          	jal	502a <exit>

0000000000000b74 <unlinkread>:
{
     b74:	7179                	addi	sp,sp,-48
     b76:	f406                	sd	ra,40(sp)
     b78:	f022                	sd	s0,32(sp)
     b7a:	ec26                	sd	s1,24(sp)
     b7c:	e84a                	sd	s2,16(sp)
     b7e:	e44e                	sd	s3,8(sp)
     b80:	1800                	addi	s0,sp,48
     b82:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b84:	20200593          	li	a1,514
     b88:	00005517          	auipc	a0,0x5
     b8c:	fe850513          	addi	a0,a0,-24 # 5b70 <malloc+0x624>
     b90:	4da040ef          	jal	506a <open>
  if (fd < 0) {
     b94:	0a054f63          	bltz	a0,c52 <unlinkread+0xde>
     b98:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9a:	4615                	li	a2,5
     b9c:	00005597          	auipc	a1,0x5
     ba0:	00458593          	addi	a1,a1,4 # 5ba0 <malloc+0x654>
     ba4:	4a6040ef          	jal	504a <write>
  close(fd);
     ba8:	8526                	mv	a0,s1
     baa:	4a8040ef          	jal	5052 <close>
  fd = open("unlinkread", O_RDWR);
     bae:	4589                	li	a1,2
     bb0:	00005517          	auipc	a0,0x5
     bb4:	fc050513          	addi	a0,a0,-64 # 5b70 <malloc+0x624>
     bb8:	4b2040ef          	jal	506a <open>
     bbc:	84aa                	mv	s1,a0
  if (fd < 0) {
     bbe:	0a054463          	bltz	a0,c66 <unlinkread+0xf2>
  if (unlink("unlinkread") != 0) {
     bc2:	00005517          	auipc	a0,0x5
     bc6:	fae50513          	addi	a0,a0,-82 # 5b70 <malloc+0x624>
     bca:	4b0040ef          	jal	507a <unlink>
     bce:	e555                	bnez	a0,c7a <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd0:	20200593          	li	a1,514
     bd4:	00005517          	auipc	a0,0x5
     bd8:	f9c50513          	addi	a0,a0,-100 # 5b70 <malloc+0x624>
     bdc:	48e040ef          	jal	506a <open>
     be0:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be2:	460d                	li	a2,3
     be4:	00005597          	auipc	a1,0x5
     be8:	00458593          	addi	a1,a1,4 # 5be8 <malloc+0x69c>
     bec:	45e040ef          	jal	504a <write>
  close(fd1);
     bf0:	854a                	mv	a0,s2
     bf2:	460040ef          	jal	5052 <close>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     bf6:	660d                	lui	a2,0x3
     bf8:	0000b597          	auipc	a1,0xb
     bfc:	0c058593          	addi	a1,a1,192 # bcb8 <buf>
     c00:	8526                	mv	a0,s1
     c02:	440040ef          	jal	5042 <read>
     c06:	4795                	li	a5,5
     c08:	08f51363          	bne	a0,a5,c8e <unlinkread+0x11a>
  if (buf[0] != 'h') {
     c0c:	0000b717          	auipc	a4,0xb
     c10:	0ac74703          	lbu	a4,172(a4) # bcb8 <buf>
     c14:	06800793          	li	a5,104
     c18:	08f71563          	bne	a4,a5,ca2 <unlinkread+0x12e>
  if (write(fd, buf, 10) != 10) {
     c1c:	4629                	li	a2,10
     c1e:	0000b597          	auipc	a1,0xb
     c22:	09a58593          	addi	a1,a1,154 # bcb8 <buf>
     c26:	8526                	mv	a0,s1
     c28:	422040ef          	jal	504a <write>
     c2c:	47a9                	li	a5,10
     c2e:	08f51463          	bne	a0,a5,cb6 <unlinkread+0x142>
  close(fd);
     c32:	8526                	mv	a0,s1
     c34:	41e040ef          	jal	5052 <close>
  unlink("unlinkread");
     c38:	00005517          	auipc	a0,0x5
     c3c:	f3850513          	addi	a0,a0,-200 # 5b70 <malloc+0x624>
     c40:	43a040ef          	jal	507a <unlink>
}
     c44:	70a2                	ld	ra,40(sp)
     c46:	7402                	ld	s0,32(sp)
     c48:	64e2                	ld	s1,24(sp)
     c4a:	6942                	ld	s2,16(sp)
     c4c:	69a2                	ld	s3,8(sp)
     c4e:	6145                	addi	sp,sp,48
     c50:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c52:	85ce                	mv	a1,s3
     c54:	00005517          	auipc	a0,0x5
     c58:	f2c50513          	addi	a0,a0,-212 # 5b80 <malloc+0x634>
     c5c:	035040ef          	jal	5490 <printf>
    exit(1);
     c60:	4505                	li	a0,1
     c62:	3c8040ef          	jal	502a <exit>
    printf("%s: open unlinkread failed\n", s);
     c66:	85ce                	mv	a1,s3
     c68:	00005517          	auipc	a0,0x5
     c6c:	f4050513          	addi	a0,a0,-192 # 5ba8 <malloc+0x65c>
     c70:	021040ef          	jal	5490 <printf>
    exit(1);
     c74:	4505                	li	a0,1
     c76:	3b4040ef          	jal	502a <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7a:	85ce                	mv	a1,s3
     c7c:	00005517          	auipc	a0,0x5
     c80:	f4c50513          	addi	a0,a0,-180 # 5bc8 <malloc+0x67c>
     c84:	00d040ef          	jal	5490 <printf>
    exit(1);
     c88:	4505                	li	a0,1
     c8a:	3a0040ef          	jal	502a <exit>
    printf("%s: unlinkread read failed", s);
     c8e:	85ce                	mv	a1,s3
     c90:	00005517          	auipc	a0,0x5
     c94:	f6050513          	addi	a0,a0,-160 # 5bf0 <malloc+0x6a4>
     c98:	7f8040ef          	jal	5490 <printf>
    exit(1);
     c9c:	4505                	li	a0,1
     c9e:	38c040ef          	jal	502a <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca2:	85ce                	mv	a1,s3
     ca4:	00005517          	auipc	a0,0x5
     ca8:	f6c50513          	addi	a0,a0,-148 # 5c10 <malloc+0x6c4>
     cac:	7e4040ef          	jal	5490 <printf>
    exit(1);
     cb0:	4505                	li	a0,1
     cb2:	378040ef          	jal	502a <exit>
    printf("%s: unlinkread write failed\n", s);
     cb6:	85ce                	mv	a1,s3
     cb8:	00005517          	auipc	a0,0x5
     cbc:	f7850513          	addi	a0,a0,-136 # 5c30 <malloc+0x6e4>
     cc0:	7d0040ef          	jal	5490 <printf>
    exit(1);
     cc4:	4505                	li	a0,1
     cc6:	364040ef          	jal	502a <exit>

0000000000000cca <linktest>:
{
     cca:	1101                	addi	sp,sp,-32
     ccc:	ec06                	sd	ra,24(sp)
     cce:	e822                	sd	s0,16(sp)
     cd0:	e426                	sd	s1,8(sp)
     cd2:	e04a                	sd	s2,0(sp)
     cd4:	1000                	addi	s0,sp,32
     cd6:	892a                	mv	s2,a0
  unlink("lf1");
     cd8:	00005517          	auipc	a0,0x5
     cdc:	f7850513          	addi	a0,a0,-136 # 5c50 <malloc+0x704>
     ce0:	39a040ef          	jal	507a <unlink>
  unlink("lf2");
     ce4:	00005517          	auipc	a0,0x5
     ce8:	f7450513          	addi	a0,a0,-140 # 5c58 <malloc+0x70c>
     cec:	38e040ef          	jal	507a <unlink>
  fd = open("lf1", O_CREATE | O_RDWR);
     cf0:	20200593          	li	a1,514
     cf4:	00005517          	auipc	a0,0x5
     cf8:	f5c50513          	addi	a0,a0,-164 # 5c50 <malloc+0x704>
     cfc:	36e040ef          	jal	506a <open>
  if (fd < 0) {
     d00:	0c054f63          	bltz	a0,dde <linktest+0x114>
     d04:	84aa                	mv	s1,a0
  if (write(fd, "hello", SZ) != SZ) {
     d06:	4615                	li	a2,5
     d08:	00005597          	auipc	a1,0x5
     d0c:	e9858593          	addi	a1,a1,-360 # 5ba0 <malloc+0x654>
     d10:	33a040ef          	jal	504a <write>
     d14:	4795                	li	a5,5
     d16:	0cf51e63          	bne	a0,a5,df2 <linktest+0x128>
  close(fd);
     d1a:	8526                	mv	a0,s1
     d1c:	336040ef          	jal	5052 <close>
  if (link("lf1", "lf2") < 0) {
     d20:	00005597          	auipc	a1,0x5
     d24:	f3858593          	addi	a1,a1,-200 # 5c58 <malloc+0x70c>
     d28:	00005517          	auipc	a0,0x5
     d2c:	f2850513          	addi	a0,a0,-216 # 5c50 <malloc+0x704>
     d30:	35a040ef          	jal	508a <link>
     d34:	0c054963          	bltz	a0,e06 <linktest+0x13c>
  unlink("lf1");
     d38:	00005517          	auipc	a0,0x5
     d3c:	f1850513          	addi	a0,a0,-232 # 5c50 <malloc+0x704>
     d40:	33a040ef          	jal	507a <unlink>
  if (open("lf1", 0) >= 0) {
     d44:	4581                	li	a1,0
     d46:	00005517          	auipc	a0,0x5
     d4a:	f0a50513          	addi	a0,a0,-246 # 5c50 <malloc+0x704>
     d4e:	31c040ef          	jal	506a <open>
     d52:	0c055463          	bgez	a0,e1a <linktest+0x150>
  fd = open("lf2", 0);
     d56:	4581                	li	a1,0
     d58:	00005517          	auipc	a0,0x5
     d5c:	f0050513          	addi	a0,a0,-256 # 5c58 <malloc+0x70c>
     d60:	30a040ef          	jal	506a <open>
     d64:	84aa                	mv	s1,a0
  if (fd < 0) {
     d66:	0c054463          	bltz	a0,e2e <linktest+0x164>
  if (read(fd, buf, sizeof(buf)) != SZ) {
     d6a:	660d                	lui	a2,0x3
     d6c:	0000b597          	auipc	a1,0xb
     d70:	f4c58593          	addi	a1,a1,-180 # bcb8 <buf>
     d74:	2ce040ef          	jal	5042 <read>
     d78:	4795                	li	a5,5
     d7a:	0cf51463          	bne	a0,a5,e42 <linktest+0x178>
  close(fd);
     d7e:	8526                	mv	a0,s1
     d80:	2d2040ef          	jal	5052 <close>
  if (link("lf2", "lf2") >= 0) {
     d84:	00005597          	auipc	a1,0x5
     d88:	ed458593          	addi	a1,a1,-300 # 5c58 <malloc+0x70c>
     d8c:	852e                	mv	a0,a1
     d8e:	2fc040ef          	jal	508a <link>
     d92:	0c055263          	bgez	a0,e56 <linktest+0x18c>
  unlink("lf2");
     d96:	00005517          	auipc	a0,0x5
     d9a:	ec250513          	addi	a0,a0,-318 # 5c58 <malloc+0x70c>
     d9e:	2dc040ef          	jal	507a <unlink>
  if (link("lf2", "lf1") >= 0) {
     da2:	00005597          	auipc	a1,0x5
     da6:	eae58593          	addi	a1,a1,-338 # 5c50 <malloc+0x704>
     daa:	00005517          	auipc	a0,0x5
     dae:	eae50513          	addi	a0,a0,-338 # 5c58 <malloc+0x70c>
     db2:	2d8040ef          	jal	508a <link>
     db6:	0a055a63          	bgez	a0,e6a <linktest+0x1a0>
  if (link(".", "lf1") >= 0) {
     dba:	00005597          	auipc	a1,0x5
     dbe:	e9658593          	addi	a1,a1,-362 # 5c50 <malloc+0x704>
     dc2:	00005517          	auipc	a0,0x5
     dc6:	f9e50513          	addi	a0,a0,-98 # 5d60 <malloc+0x814>
     dca:	2c0040ef          	jal	508a <link>
     dce:	0a055863          	bgez	a0,e7e <linktest+0x1b4>
}
     dd2:	60e2                	ld	ra,24(sp)
     dd4:	6442                	ld	s0,16(sp)
     dd6:	64a2                	ld	s1,8(sp)
     dd8:	6902                	ld	s2,0(sp)
     dda:	6105                	addi	sp,sp,32
     ddc:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     dde:	85ca                	mv	a1,s2
     de0:	00005517          	auipc	a0,0x5
     de4:	e8050513          	addi	a0,a0,-384 # 5c60 <malloc+0x714>
     de8:	6a8040ef          	jal	5490 <printf>
    exit(1);
     dec:	4505                	li	a0,1
     dee:	23c040ef          	jal	502a <exit>
    printf("%s: write lf1 failed\n", s);
     df2:	85ca                	mv	a1,s2
     df4:	00005517          	auipc	a0,0x5
     df8:	e8450513          	addi	a0,a0,-380 # 5c78 <malloc+0x72c>
     dfc:	694040ef          	jal	5490 <printf>
    exit(1);
     e00:	4505                	li	a0,1
     e02:	228040ef          	jal	502a <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e06:	85ca                	mv	a1,s2
     e08:	00005517          	auipc	a0,0x5
     e0c:	e8850513          	addi	a0,a0,-376 # 5c90 <malloc+0x744>
     e10:	680040ef          	jal	5490 <printf>
    exit(1);
     e14:	4505                	li	a0,1
     e16:	214040ef          	jal	502a <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1a:	85ca                	mv	a1,s2
     e1c:	00005517          	auipc	a0,0x5
     e20:	e9450513          	addi	a0,a0,-364 # 5cb0 <malloc+0x764>
     e24:	66c040ef          	jal	5490 <printf>
    exit(1);
     e28:	4505                	li	a0,1
     e2a:	200040ef          	jal	502a <exit>
    printf("%s: open lf2 failed\n", s);
     e2e:	85ca                	mv	a1,s2
     e30:	00005517          	auipc	a0,0x5
     e34:	eb050513          	addi	a0,a0,-336 # 5ce0 <malloc+0x794>
     e38:	658040ef          	jal	5490 <printf>
    exit(1);
     e3c:	4505                	li	a0,1
     e3e:	1ec040ef          	jal	502a <exit>
    printf("%s: read lf2 failed\n", s);
     e42:	85ca                	mv	a1,s2
     e44:	00005517          	auipc	a0,0x5
     e48:	eb450513          	addi	a0,a0,-332 # 5cf8 <malloc+0x7ac>
     e4c:	644040ef          	jal	5490 <printf>
    exit(1);
     e50:	4505                	li	a0,1
     e52:	1d8040ef          	jal	502a <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e56:	85ca                	mv	a1,s2
     e58:	00005517          	auipc	a0,0x5
     e5c:	eb850513          	addi	a0,a0,-328 # 5d10 <malloc+0x7c4>
     e60:	630040ef          	jal	5490 <printf>
    exit(1);
     e64:	4505                	li	a0,1
     e66:	1c4040ef          	jal	502a <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6a:	85ca                	mv	a1,s2
     e6c:	00005517          	auipc	a0,0x5
     e70:	ecc50513          	addi	a0,a0,-308 # 5d38 <malloc+0x7ec>
     e74:	61c040ef          	jal	5490 <printf>
    exit(1);
     e78:	4505                	li	a0,1
     e7a:	1b0040ef          	jal	502a <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e7e:	85ca                	mv	a1,s2
     e80:	00005517          	auipc	a0,0x5
     e84:	ee850513          	addi	a0,a0,-280 # 5d68 <malloc+0x81c>
     e88:	608040ef          	jal	5490 <printf>
    exit(1);
     e8c:	4505                	li	a0,1
     e8e:	19c040ef          	jal	502a <exit>

0000000000000e92 <validatetest>:
{
     e92:	7139                	addi	sp,sp,-64
     e94:	fc06                	sd	ra,56(sp)
     e96:	f822                	sd	s0,48(sp)
     e98:	f426                	sd	s1,40(sp)
     e9a:	f04a                	sd	s2,32(sp)
     e9c:	ec4e                	sd	s3,24(sp)
     e9e:	e852                	sd	s4,16(sp)
     ea0:	e456                	sd	s5,8(sp)
     ea2:	e05a                	sd	s6,0(sp)
     ea4:	0080                	addi	s0,sp,64
     ea6:	8b2a                	mv	s6,a0
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ea8:	4481                	li	s1,0
    if (link("nosuchfile", (char *)p) != -1) {
     eaa:	00005997          	auipc	s3,0x5
     eae:	ede98993          	addi	s3,s3,-290 # 5d88 <malloc+0x83c>
     eb2:	597d                	li	s2,-1
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     eb4:	6a85                	lui	s5,0x1
     eb6:	00114a37          	lui	s4,0x114
    if (link("nosuchfile", (char *)p) != -1) {
     eba:	85a6                	mv	a1,s1
     ebc:	854e                	mv	a0,s3
     ebe:	1cc040ef          	jal	508a <link>
     ec2:	01251f63          	bne	a0,s2,ee0 <validatetest+0x4e>
  for (p = 0; p <= (uint)hi; p += PGSIZE) {
     ec6:	94d6                	add	s1,s1,s5
     ec8:	ff4499e3          	bne	s1,s4,eba <validatetest+0x28>
}
     ecc:	70e2                	ld	ra,56(sp)
     ece:	7442                	ld	s0,48(sp)
     ed0:	74a2                	ld	s1,40(sp)
     ed2:	7902                	ld	s2,32(sp)
     ed4:	69e2                	ld	s3,24(sp)
     ed6:	6a42                	ld	s4,16(sp)
     ed8:	6aa2                	ld	s5,8(sp)
     eda:	6b02                	ld	s6,0(sp)
     edc:	6121                	addi	sp,sp,64
     ede:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee0:	85da                	mv	a1,s6
     ee2:	00005517          	auipc	a0,0x5
     ee6:	eb650513          	addi	a0,a0,-330 # 5d98 <malloc+0x84c>
     eea:	5a6040ef          	jal	5490 <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	13a040ef          	jal	502a <exit>

0000000000000ef4 <bigdir>:
{
     ef4:	711d                	addi	sp,sp,-96
     ef6:	ec86                	sd	ra,88(sp)
     ef8:	e8a2                	sd	s0,80(sp)
     efa:	e4a6                	sd	s1,72(sp)
     efc:	e0ca                	sd	s2,64(sp)
     efe:	fc4e                	sd	s3,56(sp)
     f00:	f852                	sd	s4,48(sp)
     f02:	f456                	sd	s5,40(sp)
     f04:	f05a                	sd	s6,32(sp)
     f06:	ec5e                	sd	s7,24(sp)
     f08:	1080                	addi	s0,sp,96
     f0a:	8baa                	mv	s7,a0
  unlink("bd");
     f0c:	00005517          	auipc	a0,0x5
     f10:	eac50513          	addi	a0,a0,-340 # 5db8 <malloc+0x86c>
     f14:	166040ef          	jal	507a <unlink>
  fd = open("bd", O_CREATE);
     f18:	20000593          	li	a1,512
     f1c:	00005517          	auipc	a0,0x5
     f20:	e9c50513          	addi	a0,a0,-356 # 5db8 <malloc+0x86c>
     f24:	146040ef          	jal	506a <open>
  if (fd < 0) {
     f28:	0c054463          	bltz	a0,ff0 <bigdir+0xfc>
  close(fd);
     f2c:	126040ef          	jal	5052 <close>
  for (i = 0; i < N; i++) {
     f30:	4901                	li	s2,0
    name[0] = 'x';
     f32:	07800a93          	li	s5,120
    if (link("bd", name) != 0) {
     f36:	fa040a13          	addi	s4,s0,-96
     f3a:	00005997          	auipc	s3,0x5
     f3e:	e7e98993          	addi	s3,s3,-386 # 5db8 <malloc+0x86c>
  for (i = 0; i < N; i++) {
     f42:	1f400b13          	li	s6,500
    name[0] = 'x';
     f46:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4a:	41f9571b          	sraiw	a4,s2,0x1f
     f4e:	01a7571b          	srliw	a4,a4,0x1a
     f52:	012707bb          	addw	a5,a4,s2
     f56:	4067d69b          	sraiw	a3,a5,0x6
     f5a:	0306869b          	addiw	a3,a3,48
     f5e:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f62:	03f7f793          	andi	a5,a5,63
     f66:	9f99                	subw	a5,a5,a4
     f68:	0307879b          	addiw	a5,a5,48
     f6c:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f70:	fa0401a3          	sb	zero,-93(s0)
    if (link("bd", name) != 0) {
     f74:	85d2                	mv	a1,s4
     f76:	854e                	mv	a0,s3
     f78:	112040ef          	jal	508a <link>
     f7c:	84aa                	mv	s1,a0
     f7e:	e159                	bnez	a0,1004 <bigdir+0x110>
  for (i = 0; i < N; i++) {
     f80:	2905                	addiw	s2,s2,1
     f82:	fd6912e3          	bne	s2,s6,f46 <bigdir+0x52>
  unlink("bd");
     f86:	00005517          	auipc	a0,0x5
     f8a:	e3250513          	addi	a0,a0,-462 # 5db8 <malloc+0x86c>
     f8e:	0ec040ef          	jal	507a <unlink>
    name[0] = 'x';
     f92:	07800993          	li	s3,120
    if (unlink(name) != 0) {
     f96:	fa040913          	addi	s2,s0,-96
  for (i = 0; i < N; i++) {
     f9a:	1f400a13          	li	s4,500
    name[0] = 'x';
     f9e:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa2:	41f4d71b          	sraiw	a4,s1,0x1f
     fa6:	01a7571b          	srliw	a4,a4,0x1a
     faa:	009707bb          	addw	a5,a4,s1
     fae:	4067d69b          	sraiw	a3,a5,0x6
     fb2:	0306869b          	addiw	a3,a3,48
     fb6:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fba:	03f7f793          	andi	a5,a5,63
     fbe:	9f99                	subw	a5,a5,a4
     fc0:	0307879b          	addiw	a5,a5,48
     fc4:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fc8:	fa0401a3          	sb	zero,-93(s0)
    if (unlink(name) != 0) {
     fcc:	854a                	mv	a0,s2
     fce:	0ac040ef          	jal	507a <unlink>
     fd2:	e531                	bnez	a0,101e <bigdir+0x12a>
  for (i = 0; i < N; i++) {
     fd4:	2485                	addiw	s1,s1,1
     fd6:	fd4494e3          	bne	s1,s4,f9e <bigdir+0xaa>
}
     fda:	60e6                	ld	ra,88(sp)
     fdc:	6446                	ld	s0,80(sp)
     fde:	64a6                	ld	s1,72(sp)
     fe0:	6906                	ld	s2,64(sp)
     fe2:	79e2                	ld	s3,56(sp)
     fe4:	7a42                	ld	s4,48(sp)
     fe6:	7aa2                	ld	s5,40(sp)
     fe8:	7b02                	ld	s6,32(sp)
     fea:	6be2                	ld	s7,24(sp)
     fec:	6125                	addi	sp,sp,96
     fee:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff0:	85de                	mv	a1,s7
     ff2:	00005517          	auipc	a0,0x5
     ff6:	dce50513          	addi	a0,a0,-562 # 5dc0 <malloc+0x874>
     ffa:	496040ef          	jal	5490 <printf>
    exit(1);
     ffe:	4505                	li	a0,1
    1000:	02a040ef          	jal	502a <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1004:	fa040693          	addi	a3,s0,-96
    1008:	864a                	mv	a2,s2
    100a:	85de                	mv	a1,s7
    100c:	00005517          	auipc	a0,0x5
    1010:	dd450513          	addi	a0,a0,-556 # 5de0 <malloc+0x894>
    1014:	47c040ef          	jal	5490 <printf>
      exit(1);
    1018:	4505                	li	a0,1
    101a:	010040ef          	jal	502a <exit>
      printf("%s: bigdir unlink failed", s);
    101e:	85de                	mv	a1,s7
    1020:	00005517          	auipc	a0,0x5
    1024:	de850513          	addi	a0,a0,-536 # 5e08 <malloc+0x8bc>
    1028:	468040ef          	jal	5490 <printf>
      exit(1);
    102c:	4505                	li	a0,1
    102e:	7fd030ef          	jal	502a <exit>

0000000000001032 <pgbug>:
{
    1032:	7179                	addi	sp,sp,-48
    1034:	f406                	sd	ra,40(sp)
    1036:	f022                	sd	s0,32(sp)
    1038:	ec26                	sd	s1,24(sp)
    103a:	1800                	addi	s0,sp,48
  argv[0] = 0;
    103c:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1040:	00007497          	auipc	s1,0x7
    1044:	fc048493          	addi	s1,s1,-64 # 8000 <big>
    1048:	fd840593          	addi	a1,s0,-40
    104c:	6088                	ld	a0,0(s1)
    104e:	014040ef          	jal	5062 <exec>
  pipe(big);
    1052:	6088                	ld	a0,0(s1)
    1054:	7e7030ef          	jal	503a <pipe>
  exit(0);
    1058:	4501                	li	a0,0
    105a:	7d1030ef          	jal	502a <exit>

000000000000105e <badarg>:
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	0080                	addi	s0,sp,64
    106e:	64b1                	lui	s1,0xc
    1070:	35048493          	addi	s1,s1,848 # c350 <buf+0x698>
    argv[0] = (char *)0xffffffff;
    1074:	597d                	li	s2,-1
    1076:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107a:	fc040a13          	addi	s4,s0,-64
    107e:	00004997          	auipc	s3,0x4
    1082:	5fa98993          	addi	s3,s3,1530 # 5678 <malloc+0x12c>
    argv[0] = (char *)0xffffffff;
    1086:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108a:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    108e:	85d2                	mv	a1,s4
    1090:	854e                	mv	a0,s3
    1092:	7d1030ef          	jal	5062 <exec>
  for (int i = 0; i < 50000; i++) {
    1096:	34fd                	addiw	s1,s1,-1
    1098:	f4fd                	bnez	s1,1086 <badarg+0x28>
  exit(0);
    109a:	4501                	li	a0,0
    109c:	78f030ef          	jal	502a <exit>

00000000000010a0 <copyinstr2>:
{
    10a0:	7155                	addi	sp,sp,-208
    10a2:	e586                	sd	ra,200(sp)
    10a4:	e1a2                	sd	s0,192(sp)
    10a6:	0980                	addi	s0,sp,208
  for (int i = 0; i < MAXPATH; i++)
    10a8:	f6840793          	addi	a5,s0,-152
    10ac:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b0:	07800713          	li	a4,120
    10b4:	00e78023          	sb	a4,0(a5)
  for (int i = 0; i < MAXPATH; i++)
    10b8:	0785                	addi	a5,a5,1
    10ba:	fed79de3          	bne	a5,a3,10b4 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10be:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c2:	f6840513          	addi	a0,s0,-152
    10c6:	7b5030ef          	jal	507a <unlink>
  if (ret != -1) {
    10ca:	57fd                	li	a5,-1
    10cc:	0cf51263          	bne	a0,a5,1190 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d0:	20100593          	li	a1,513
    10d4:	f6840513          	addi	a0,s0,-152
    10d8:	793030ef          	jal	506a <open>
  if (fd != -1) {
    10dc:	57fd                	li	a5,-1
    10de:	0cf51563          	bne	a0,a5,11a8 <copyinstr2+0x108>
  ret = link(b, b);
    10e2:	f6840513          	addi	a0,s0,-152
    10e6:	85aa                	mv	a1,a0
    10e8:	7a3030ef          	jal	508a <link>
  if (ret != -1) {
    10ec:	57fd                	li	a5,-1
    10ee:	0cf51963          	bne	a0,a5,11c0 <copyinstr2+0x120>
  char *args[] = {"xx", 0};
    10f2:	00006797          	auipc	a5,0x6
    10f6:	dfe78793          	addi	a5,a5,-514 # 6ef0 <malloc+0x19a4>
    10fa:	f4f43c23          	sd	a5,-168(s0)
    10fe:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1102:	f5840593          	addi	a1,s0,-168
    1106:	f6840513          	addi	a0,s0,-152
    110a:	759030ef          	jal	5062 <exec>
  if (ret != -1) {
    110e:	57fd                	li	a5,-1
    1110:	0cf51563          	bne	a0,a5,11da <copyinstr2+0x13a>
  int pid = fork();
    1114:	70f030ef          	jal	5022 <fork>
  if (pid < 0) {
    1118:	0c054d63          	bltz	a0,11f2 <copyinstr2+0x152>
  if (pid == 0) {
    111c:	0e051863          	bnez	a0,120c <copyinstr2+0x16c>
    1120:	00007797          	auipc	a5,0x7
    1124:	48078793          	addi	a5,a5,1152 # 85a0 <big.0>
    1128:	00008697          	auipc	a3,0x8
    112c:	47868693          	addi	a3,a3,1144 # 95a0 <big.0+0x1000>
      big[i] = 'x';
    1130:	07800713          	li	a4,120
    1134:	00e78023          	sb	a4,0(a5)
    for (int i = 0; i < PGSIZE; i++)
    1138:	0785                	addi	a5,a5,1
    113a:	fed79de3          	bne	a5,a3,1134 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    113e:	00008797          	auipc	a5,0x8
    1142:	46078123          	sb	zero,1122(a5) # 95a0 <big.0+0x1000>
    char *args2[] = {big, big, big, 0};
    1146:	00007797          	auipc	a5,0x7
    114a:	aaa78793          	addi	a5,a5,-1366 # 7bf0 <malloc+0x26a4>
    114e:	6fb0                	ld	a2,88(a5)
    1150:	73b4                	ld	a3,96(a5)
    1152:	77b8                	ld	a4,104(a5)
    1154:	f2c43823          	sd	a2,-208(s0)
    1158:	f2d43c23          	sd	a3,-200(s0)
    115c:	f4e43023          	sd	a4,-192(s0)
    1160:	7bbc                	ld	a5,112(a5)
    1162:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    1166:	f3040593          	addi	a1,s0,-208
    116a:	00004517          	auipc	a0,0x4
    116e:	50e50513          	addi	a0,a0,1294 # 5678 <malloc+0x12c>
    1172:	6f1030ef          	jal	5062 <exec>
    if (ret != -1) {
    1176:	57fd                	li	a5,-1
    1178:	08f50663          	beq	a0,a5,1204 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    117c:	85be                	mv	a1,a5
    117e:	00005517          	auipc	a0,0x5
    1182:	d3250513          	addi	a0,a0,-718 # 5eb0 <malloc+0x964>
    1186:	30a040ef          	jal	5490 <printf>
      exit(1);
    118a:	4505                	li	a0,1
    118c:	69f030ef          	jal	502a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1190:	862a                	mv	a2,a0
    1192:	f6840593          	addi	a1,s0,-152
    1196:	00005517          	auipc	a0,0x5
    119a:	c9250513          	addi	a0,a0,-878 # 5e28 <malloc+0x8dc>
    119e:	2f2040ef          	jal	5490 <printf>
    exit(1);
    11a2:	4505                	li	a0,1
    11a4:	687030ef          	jal	502a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11a8:	862a                	mv	a2,a0
    11aa:	f6840593          	addi	a1,s0,-152
    11ae:	00005517          	auipc	a0,0x5
    11b2:	c9a50513          	addi	a0,a0,-870 # 5e48 <malloc+0x8fc>
    11b6:	2da040ef          	jal	5490 <printf>
    exit(1);
    11ba:	4505                	li	a0,1
    11bc:	66f030ef          	jal	502a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c0:	f6840593          	addi	a1,s0,-152
    11c4:	86aa                	mv	a3,a0
    11c6:	862e                	mv	a2,a1
    11c8:	00005517          	auipc	a0,0x5
    11cc:	ca050513          	addi	a0,a0,-864 # 5e68 <malloc+0x91c>
    11d0:	2c0040ef          	jal	5490 <printf>
    exit(1);
    11d4:	4505                	li	a0,1
    11d6:	655030ef          	jal	502a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11da:	863e                	mv	a2,a5
    11dc:	f6840593          	addi	a1,s0,-152
    11e0:	00005517          	auipc	a0,0x5
    11e4:	cb050513          	addi	a0,a0,-848 # 5e90 <malloc+0x944>
    11e8:	2a8040ef          	jal	5490 <printf>
    exit(1);
    11ec:	4505                	li	a0,1
    11ee:	63d030ef          	jal	502a <exit>
    printf("fork failed\n");
    11f2:	00006517          	auipc	a0,0x6
    11f6:	2ee50513          	addi	a0,a0,750 # 74e0 <malloc+0x1f94>
    11fa:	296040ef          	jal	5490 <printf>
    exit(1);
    11fe:	4505                	li	a0,1
    1200:	62b030ef          	jal	502a <exit>
    exit(747); // OK
    1204:	2eb00513          	li	a0,747
    1208:	623030ef          	jal	502a <exit>
  int st = 0;
    120c:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1210:	f5440513          	addi	a0,s0,-172
    1214:	61f030ef          	jal	5032 <wait>
  if (st != 747) {
    1218:	f5442703          	lw	a4,-172(s0)
    121c:	2eb00793          	li	a5,747
    1220:	00f71663          	bne	a4,a5,122c <copyinstr2+0x18c>
}
    1224:	60ae                	ld	ra,200(sp)
    1226:	640e                	ld	s0,192(sp)
    1228:	6169                	addi	sp,sp,208
    122a:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    122c:	00005517          	auipc	a0,0x5
    1230:	cac50513          	addi	a0,a0,-852 # 5ed8 <malloc+0x98c>
    1234:	25c040ef          	jal	5490 <printf>
    exit(1);
    1238:	4505                	li	a0,1
    123a:	5f1030ef          	jal	502a <exit>

000000000000123e <truncate3>:
{
    123e:	7175                	addi	sp,sp,-144
    1240:	e506                	sd	ra,136(sp)
    1242:	e122                	sd	s0,128(sp)
    1244:	fc66                	sd	s9,56(sp)
    1246:	0900                	addi	s0,sp,144
    1248:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE | O_TRUNC | O_WRONLY));
    124a:	60100593          	li	a1,1537
    124e:	00004517          	auipc	a0,0x4
    1252:	48250513          	addi	a0,a0,1154 # 56d0 <malloc+0x184>
    1256:	615030ef          	jal	506a <open>
    125a:	5f9030ef          	jal	5052 <close>
  pid = fork();
    125e:	5c5030ef          	jal	5022 <fork>
  if (pid < 0) {
    1262:	06054d63          	bltz	a0,12dc <truncate3+0x9e>
  if (pid == 0) {
    1266:	e171                	bnez	a0,132a <truncate3+0xec>
    1268:	fca6                	sd	s1,120(sp)
    126a:	f8ca                	sd	s2,112(sp)
    126c:	f4ce                	sd	s3,104(sp)
    126e:	f0d2                	sd	s4,96(sp)
    1270:	ecd6                	sd	s5,88(sp)
    1272:	e8da                	sd	s6,80(sp)
    1274:	e4de                	sd	s7,72(sp)
    1276:	e0e2                	sd	s8,64(sp)
    1278:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    127c:	4a85                	li	s5,1
    127e:	00004997          	auipc	s3,0x4
    1282:	45298993          	addi	s3,s3,1106 # 56d0 <malloc+0x184>
      int n = write(fd, "1234567890", 10);
    1286:	4a29                	li	s4,10
    1288:	00005b17          	auipc	s6,0x5
    128c:	cb0b0b13          	addi	s6,s6,-848 # 5f38 <malloc+0x9ec>
      read(fd, buf, sizeof(buf));
    1290:	f7840c13          	addi	s8,s0,-136
    1294:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    1298:	85d6                	mv	a1,s5
    129a:	854e                	mv	a0,s3
    129c:	5cf030ef          	jal	506a <open>
    12a0:	84aa                	mv	s1,a0
      if (fd < 0) {
    12a2:	04054f63          	bltz	a0,1300 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12a6:	8652                	mv	a2,s4
    12a8:	85da                	mv	a1,s6
    12aa:	5a1030ef          	jal	504a <write>
      if (n != 10) {
    12ae:	07451363          	bne	a0,s4,1314 <truncate3+0xd6>
      close(fd);
    12b2:	8526                	mv	a0,s1
    12b4:	59f030ef          	jal	5052 <close>
      fd = open("truncfile", O_RDONLY);
    12b8:	4581                	li	a1,0
    12ba:	854e                	mv	a0,s3
    12bc:	5af030ef          	jal	506a <open>
    12c0:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c2:	865e                	mv	a2,s7
    12c4:	85e2                	mv	a1,s8
    12c6:	57d030ef          	jal	5042 <read>
      close(fd);
    12ca:	8526                	mv	a0,s1
    12cc:	587030ef          	jal	5052 <close>
    for (int i = 0; i < 100; i++) {
    12d0:	397d                	addiw	s2,s2,-1
    12d2:	fc0913e3          	bnez	s2,1298 <truncate3+0x5a>
    exit(0);
    12d6:	4501                	li	a0,0
    12d8:	553030ef          	jal	502a <exit>
    12dc:	fca6                	sd	s1,120(sp)
    12de:	f8ca                	sd	s2,112(sp)
    12e0:	f4ce                	sd	s3,104(sp)
    12e2:	f0d2                	sd	s4,96(sp)
    12e4:	ecd6                	sd	s5,88(sp)
    12e6:	e8da                	sd	s6,80(sp)
    12e8:	e4de                	sd	s7,72(sp)
    12ea:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12ec:	85e6                	mv	a1,s9
    12ee:	00005517          	auipc	a0,0x5
    12f2:	c1a50513          	addi	a0,a0,-998 # 5f08 <malloc+0x9bc>
    12f6:	19a040ef          	jal	5490 <printf>
    exit(1);
    12fa:	4505                	li	a0,1
    12fc:	52f030ef          	jal	502a <exit>
        printf("%s: open failed\n", s);
    1300:	85e6                	mv	a1,s9
    1302:	00005517          	auipc	a0,0x5
    1306:	c1e50513          	addi	a0,a0,-994 # 5f20 <malloc+0x9d4>
    130a:	186040ef          	jal	5490 <printf>
        exit(1);
    130e:	4505                	li	a0,1
    1310:	51b030ef          	jal	502a <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1314:	862a                	mv	a2,a0
    1316:	85e6                	mv	a1,s9
    1318:	00005517          	auipc	a0,0x5
    131c:	c3050513          	addi	a0,a0,-976 # 5f48 <malloc+0x9fc>
    1320:	170040ef          	jal	5490 <printf>
        exit(1);
    1324:	4505                	li	a0,1
    1326:	505030ef          	jal	502a <exit>
    132a:	fca6                	sd	s1,120(sp)
    132c:	f8ca                	sd	s2,112(sp)
    132e:	f4ce                	sd	s3,104(sp)
    1330:	f0d2                	sd	s4,96(sp)
    1332:	ecd6                	sd	s5,88(sp)
    1334:	e8da                	sd	s6,80(sp)
  if (pid == 0) {
    1336:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    133a:	60100a93          	li	s5,1537
    133e:	00004a17          	auipc	s4,0x4
    1342:	392a0a13          	addi	s4,s4,914 # 56d0 <malloc+0x184>
    int n = write(fd, "xxx", 3);
    1346:	498d                	li	s3,3
    1348:	00005b17          	auipc	s6,0x5
    134c:	c20b0b13          	addi	s6,s6,-992 # 5f68 <malloc+0xa1c>
    int fd = open("truncfile", O_CREATE | O_WRONLY | O_TRUNC);
    1350:	85d6                	mv	a1,s5
    1352:	8552                	mv	a0,s4
    1354:	517030ef          	jal	506a <open>
    1358:	84aa                	mv	s1,a0
    if (fd < 0) {
    135a:	02054e63          	bltz	a0,1396 <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    135e:	864e                	mv	a2,s3
    1360:	85da                	mv	a1,s6
    1362:	4e9030ef          	jal	504a <write>
    if (n != 3) {
    1366:	05351463          	bne	a0,s3,13ae <truncate3+0x170>
    close(fd);
    136a:	8526                	mv	a0,s1
    136c:	4e7030ef          	jal	5052 <close>
  for (int i = 0; i < 150; i++) {
    1370:	397d                	addiw	s2,s2,-1
    1372:	fc091fe3          	bnez	s2,1350 <truncate3+0x112>
    1376:	e4de                	sd	s7,72(sp)
    1378:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137a:	f9c40513          	addi	a0,s0,-100
    137e:	4b5030ef          	jal	5032 <wait>
  unlink("truncfile");
    1382:	00004517          	auipc	a0,0x4
    1386:	34e50513          	addi	a0,a0,846 # 56d0 <malloc+0x184>
    138a:	4f1030ef          	jal	507a <unlink>
  exit(xstatus);
    138e:	f9c42503          	lw	a0,-100(s0)
    1392:	499030ef          	jal	502a <exit>
    1396:	e4de                	sd	s7,72(sp)
    1398:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139a:	85e6                	mv	a1,s9
    139c:	00005517          	auipc	a0,0x5
    13a0:	b8450513          	addi	a0,a0,-1148 # 5f20 <malloc+0x9d4>
    13a4:	0ec040ef          	jal	5490 <printf>
      exit(1);
    13a8:	4505                	li	a0,1
    13aa:	481030ef          	jal	502a <exit>
    13ae:	e4de                	sd	s7,72(sp)
    13b0:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b2:	862a                	mv	a2,a0
    13b4:	85e6                	mv	a1,s9
    13b6:	00005517          	auipc	a0,0x5
    13ba:	bba50513          	addi	a0,a0,-1094 # 5f70 <malloc+0xa24>
    13be:	0d2040ef          	jal	5490 <printf>
      exit(1);
    13c2:	4505                	li	a0,1
    13c4:	467030ef          	jal	502a <exit>

00000000000013c8 <pipe1>:
{
    13c8:	711d                	addi	sp,sp,-96
    13ca:	ec86                	sd	ra,88(sp)
    13cc:	e8a2                	sd	s0,80(sp)
    13ce:	e862                	sd	s8,16(sp)
    13d0:	1080                	addi	s0,sp,96
    13d2:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    13d4:	fa840513          	addi	a0,s0,-88
    13d8:	463030ef          	jal	503a <pipe>
    13dc:	e925                	bnez	a0,144c <pipe1+0x84>
    13de:	e4a6                	sd	s1,72(sp)
    13e0:	fc4e                	sd	s3,56(sp)
    13e2:	84aa                	mv	s1,a0
  pid = fork();
    13e4:	43f030ef          	jal	5022 <fork>
    13e8:	89aa                	mv	s3,a0
  if (pid == 0) {
    13ea:	c151                	beqz	a0,146e <pipe1+0xa6>
  } else if (pid > 0) {
    13ec:	16a05063          	blez	a0,154c <pipe1+0x184>
    13f0:	e0ca                	sd	s2,64(sp)
    13f2:	f852                	sd	s4,48(sp)
    close(fds[1]);
    13f4:	fac42503          	lw	a0,-84(s0)
    13f8:	45b030ef          	jal	5052 <close>
    total = 0;
    13fc:	89a6                	mv	s3,s1
    cc = 1;
    13fe:	4905                	li	s2,1
    while ((n = read(fds[0], buf, cc)) > 0) {
    1400:	0000ba17          	auipc	s4,0xb
    1404:	8b8a0a13          	addi	s4,s4,-1864 # bcb8 <buf>
    1408:	864a                	mv	a2,s2
    140a:	85d2                	mv	a1,s4
    140c:	fa842503          	lw	a0,-88(s0)
    1410:	433030ef          	jal	5042 <read>
    1414:	85aa                	mv	a1,a0
    1416:	0ea05963          	blez	a0,1508 <pipe1+0x140>
    141a:	0000b797          	auipc	a5,0xb
    141e:	89e78793          	addi	a5,a5,-1890 # bcb8 <buf>
    1422:	00b4863b          	addw	a2,s1,a1
        if ((buf[i] & 0xff) != (seq++ & 0xff)) {
    1426:	0007c683          	lbu	a3,0(a5)
    142a:	0ff4f713          	zext.b	a4,s1
    142e:	0ae69d63          	bne	a3,a4,14e8 <pipe1+0x120>
    1432:	2485                	addiw	s1,s1,1
      for (i = 0; i < n; i++) {
    1434:	0785                	addi	a5,a5,1
    1436:	fec498e3          	bne	s1,a2,1426 <pipe1+0x5e>
      total += n;
    143a:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    143e:	0019191b          	slliw	s2,s2,0x1
      if (cc > sizeof(buf))
    1442:	678d                	lui	a5,0x3
    1444:	fd27f2e3          	bgeu	a5,s2,1408 <pipe1+0x40>
        cc = sizeof(buf);
    1448:	893e                	mv	s2,a5
    144a:	bf7d                	j	1408 <pipe1+0x40>
    144c:	e4a6                	sd	s1,72(sp)
    144e:	e0ca                	sd	s2,64(sp)
    1450:	fc4e                	sd	s3,56(sp)
    1452:	f852                	sd	s4,48(sp)
    1454:	f456                	sd	s5,40(sp)
    1456:	f05a                	sd	s6,32(sp)
    1458:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    145a:	85e2                	mv	a1,s8
    145c:	00005517          	auipc	a0,0x5
    1460:	b3450513          	addi	a0,a0,-1228 # 5f90 <malloc+0xa44>
    1464:	02c040ef          	jal	5490 <printf>
    exit(1);
    1468:	4505                	li	a0,1
    146a:	3c1030ef          	jal	502a <exit>
    146e:	e0ca                	sd	s2,64(sp)
    1470:	f852                	sd	s4,48(sp)
    1472:	f456                	sd	s5,40(sp)
    1474:	f05a                	sd	s6,32(sp)
    1476:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1478:	fa842503          	lw	a0,-88(s0)
    147c:	3d7030ef          	jal	5052 <close>
    for (n = 0; n < N; n++) {
    1480:	0000bb17          	auipc	s6,0xb
    1484:	838b0b13          	addi	s6,s6,-1992 # bcb8 <buf>
    1488:	416004bb          	negw	s1,s6
    148c:	0ff4f493          	zext.b	s1,s1
    1490:	409b0913          	addi	s2,s6,1033
      if (write(fds[1], buf, SZ) != SZ) {
    1494:	40900a13          	li	s4,1033
    1498:	8bda                	mv	s7,s6
    for (n = 0; n < N; n++) {
    149a:	6a85                	lui	s5,0x1
    149c:	42da8a93          	addi	s5,s5,1069 # 142d <pipe1+0x65>
{
    14a0:	87da                	mv	a5,s6
        buf[i] = seq++;
    14a2:	0097873b          	addw	a4,a5,s1
    14a6:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x47a>
      for (i = 0; i < SZ; i++)
    14aa:	0785                	addi	a5,a5,1
    14ac:	ff279be3          	bne	a5,s2,14a2 <pipe1+0xda>
      if (write(fds[1], buf, SZ) != SZ) {
    14b0:	8652                	mv	a2,s4
    14b2:	85de                	mv	a1,s7
    14b4:	fac42503          	lw	a0,-84(s0)
    14b8:	393030ef          	jal	504a <write>
    14bc:	01451c63          	bne	a0,s4,14d4 <pipe1+0x10c>
    14c0:	4099899b          	addiw	s3,s3,1033
    for (n = 0; n < N; n++) {
    14c4:	24a5                	addiw	s1,s1,9
    14c6:	0ff4f493          	zext.b	s1,s1
    14ca:	fd599be3          	bne	s3,s5,14a0 <pipe1+0xd8>
    exit(0);
    14ce:	4501                	li	a0,0
    14d0:	35b030ef          	jal	502a <exit>
        printf("%s: pipe1 oops 1\n", s);
    14d4:	85e2                	mv	a1,s8
    14d6:	00005517          	auipc	a0,0x5
    14da:	ad250513          	addi	a0,a0,-1326 # 5fa8 <malloc+0xa5c>
    14de:	7b3030ef          	jal	5490 <printf>
        exit(1);
    14e2:	4505                	li	a0,1
    14e4:	347030ef          	jal	502a <exit>
          printf("%s: pipe1 oops 2\n", s);
    14e8:	85e2                	mv	a1,s8
    14ea:	00005517          	auipc	a0,0x5
    14ee:	ad650513          	addi	a0,a0,-1322 # 5fc0 <malloc+0xa74>
    14f2:	79f030ef          	jal	5490 <printf>
          return;
    14f6:	64a6                	ld	s1,72(sp)
    14f8:	6906                	ld	s2,64(sp)
    14fa:	79e2                	ld	s3,56(sp)
    14fc:	7a42                	ld	s4,48(sp)
}
    14fe:	60e6                	ld	ra,88(sp)
    1500:	6446                	ld	s0,80(sp)
    1502:	6c42                	ld	s8,16(sp)
    1504:	6125                	addi	sp,sp,96
    1506:	8082                	ret
    if (total != N * SZ) {
    1508:	6785                	lui	a5,0x1
    150a:	42d78793          	addi	a5,a5,1069 # 142d <pipe1+0x65>
    150e:	02f98063          	beq	s3,a5,152e <pipe1+0x166>
    1512:	f456                	sd	s5,40(sp)
    1514:	f05a                	sd	s6,32(sp)
    1516:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1518:	864e                	mv	a2,s3
    151a:	85e2                	mv	a1,s8
    151c:	00005517          	auipc	a0,0x5
    1520:	abc50513          	addi	a0,a0,-1348 # 5fd8 <malloc+0xa8c>
    1524:	76d030ef          	jal	5490 <printf>
      exit(1);
    1528:	4505                	li	a0,1
    152a:	301030ef          	jal	502a <exit>
    152e:	f456                	sd	s5,40(sp)
    1530:	f05a                	sd	s6,32(sp)
    1532:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    1534:	fa842503          	lw	a0,-88(s0)
    1538:	31b030ef          	jal	5052 <close>
    wait(&xstatus);
    153c:	fa440513          	addi	a0,s0,-92
    1540:	2f3030ef          	jal	5032 <wait>
    exit(xstatus);
    1544:	fa442503          	lw	a0,-92(s0)
    1548:	2e3030ef          	jal	502a <exit>
    154c:	e0ca                	sd	s2,64(sp)
    154e:	f852                	sd	s4,48(sp)
    1550:	f456                	sd	s5,40(sp)
    1552:	f05a                	sd	s6,32(sp)
    1554:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    1556:	85e2                	mv	a1,s8
    1558:	00005517          	auipc	a0,0x5
    155c:	aa050513          	addi	a0,a0,-1376 # 5ff8 <malloc+0xaac>
    1560:	731030ef          	jal	5490 <printf>
    exit(1);
    1564:	4505                	li	a0,1
    1566:	2c5030ef          	jal	502a <exit>

000000000000156a <exitwait>:
{
    156a:	715d                	addi	sp,sp,-80
    156c:	e486                	sd	ra,72(sp)
    156e:	e0a2                	sd	s0,64(sp)
    1570:	fc26                	sd	s1,56(sp)
    1572:	f84a                	sd	s2,48(sp)
    1574:	f44e                	sd	s3,40(sp)
    1576:	f052                	sd	s4,32(sp)
    1578:	ec56                	sd	s5,24(sp)
    157a:	0880                	addi	s0,sp,80
    157c:	8aaa                	mv	s5,a0
  for (i = 0; i < 100; i++) {
    157e:	4901                	li	s2,0
      if (wait(&xstate) != pid) {
    1580:	fbc40993          	addi	s3,s0,-68
  for (i = 0; i < 100; i++) {
    1584:	06400a13          	li	s4,100
    pid = fork();
    1588:	29b030ef          	jal	5022 <fork>
    158c:	84aa                	mv	s1,a0
    if (pid < 0) {
    158e:	02054863          	bltz	a0,15be <exitwait+0x54>
    if (pid) {
    1592:	c525                	beqz	a0,15fa <exitwait+0x90>
      if (wait(&xstate) != pid) {
    1594:	854e                	mv	a0,s3
    1596:	29d030ef          	jal	5032 <wait>
    159a:	02951c63          	bne	a0,s1,15d2 <exitwait+0x68>
      if (i != xstate) {
    159e:	fbc42783          	lw	a5,-68(s0)
    15a2:	05279263          	bne	a5,s2,15e6 <exitwait+0x7c>
  for (i = 0; i < 100; i++) {
    15a6:	2905                	addiw	s2,s2,1
    15a8:	ff4910e3          	bne	s2,s4,1588 <exitwait+0x1e>
}
    15ac:	60a6                	ld	ra,72(sp)
    15ae:	6406                	ld	s0,64(sp)
    15b0:	74e2                	ld	s1,56(sp)
    15b2:	7942                	ld	s2,48(sp)
    15b4:	79a2                	ld	s3,40(sp)
    15b6:	7a02                	ld	s4,32(sp)
    15b8:	6ae2                	ld	s5,24(sp)
    15ba:	6161                	addi	sp,sp,80
    15bc:	8082                	ret
      printf("%s: fork failed\n", s);
    15be:	85d6                	mv	a1,s5
    15c0:	00005517          	auipc	a0,0x5
    15c4:	94850513          	addi	a0,a0,-1720 # 5f08 <malloc+0x9bc>
    15c8:	6c9030ef          	jal	5490 <printf>
      exit(1);
    15cc:	4505                	li	a0,1
    15ce:	25d030ef          	jal	502a <exit>
        printf("%s: wait wrong pid\n", s);
    15d2:	85d6                	mv	a1,s5
    15d4:	00005517          	auipc	a0,0x5
    15d8:	a3c50513          	addi	a0,a0,-1476 # 6010 <malloc+0xac4>
    15dc:	6b5030ef          	jal	5490 <printf>
        exit(1);
    15e0:	4505                	li	a0,1
    15e2:	249030ef          	jal	502a <exit>
        printf("%s: wait wrong exit status\n", s);
    15e6:	85d6                	mv	a1,s5
    15e8:	00005517          	auipc	a0,0x5
    15ec:	a4050513          	addi	a0,a0,-1472 # 6028 <malloc+0xadc>
    15f0:	6a1030ef          	jal	5490 <printf>
        exit(1);
    15f4:	4505                	li	a0,1
    15f6:	235030ef          	jal	502a <exit>
      exit(i);
    15fa:	854a                	mv	a0,s2
    15fc:	22f030ef          	jal	502a <exit>

0000000000001600 <twochildren>:
{
    1600:	1101                	addi	sp,sp,-32
    1602:	ec06                	sd	ra,24(sp)
    1604:	e822                	sd	s0,16(sp)
    1606:	e426                	sd	s1,8(sp)
    1608:	e04a                	sd	s2,0(sp)
    160a:	1000                	addi	s0,sp,32
    160c:	892a                	mv	s2,a0
    160e:	3e800493          	li	s1,1000
    int pid1 = fork();
    1612:	211030ef          	jal	5022 <fork>
    if (pid1 < 0) {
    1616:	02054663          	bltz	a0,1642 <twochildren+0x42>
    if (pid1 == 0) {
    161a:	cd15                	beqz	a0,1656 <twochildren+0x56>
      int pid2 = fork();
    161c:	207030ef          	jal	5022 <fork>
      if (pid2 < 0) {
    1620:	02054d63          	bltz	a0,165a <twochildren+0x5a>
      if (pid2 == 0) {
    1624:	c529                	beqz	a0,166e <twochildren+0x6e>
        wait(0);
    1626:	4501                	li	a0,0
    1628:	20b030ef          	jal	5032 <wait>
        wait(0);
    162c:	4501                	li	a0,0
    162e:	205030ef          	jal	5032 <wait>
  for (int i = 0; i < 1000; i++) {
    1632:	34fd                	addiw	s1,s1,-1
    1634:	fcf9                	bnez	s1,1612 <twochildren+0x12>
}
    1636:	60e2                	ld	ra,24(sp)
    1638:	6442                	ld	s0,16(sp)
    163a:	64a2                	ld	s1,8(sp)
    163c:	6902                	ld	s2,0(sp)
    163e:	6105                	addi	sp,sp,32
    1640:	8082                	ret
      printf("%s: fork failed\n", s);
    1642:	85ca                	mv	a1,s2
    1644:	00005517          	auipc	a0,0x5
    1648:	8c450513          	addi	a0,a0,-1852 # 5f08 <malloc+0x9bc>
    164c:	645030ef          	jal	5490 <printf>
      exit(1);
    1650:	4505                	li	a0,1
    1652:	1d9030ef          	jal	502a <exit>
      exit(0);
    1656:	1d5030ef          	jal	502a <exit>
        printf("%s: fork failed\n", s);
    165a:	85ca                	mv	a1,s2
    165c:	00005517          	auipc	a0,0x5
    1660:	8ac50513          	addi	a0,a0,-1876 # 5f08 <malloc+0x9bc>
    1664:	62d030ef          	jal	5490 <printf>
        exit(1);
    1668:	4505                	li	a0,1
    166a:	1c1030ef          	jal	502a <exit>
        exit(0);
    166e:	1bd030ef          	jal	502a <exit>

0000000000001672 <forkfork>:
{
    1672:	7179                	addi	sp,sp,-48
    1674:	f406                	sd	ra,40(sp)
    1676:	f022                	sd	s0,32(sp)
    1678:	ec26                	sd	s1,24(sp)
    167a:	1800                	addi	s0,sp,48
    167c:	84aa                	mv	s1,a0
    int pid = fork();
    167e:	1a5030ef          	jal	5022 <fork>
    if (pid < 0) {
    1682:	02054b63          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1686:	c139                	beqz	a0,16cc <forkfork+0x5a>
    int pid = fork();
    1688:	19b030ef          	jal	5022 <fork>
    if (pid < 0) {
    168c:	02054663          	bltz	a0,16b8 <forkfork+0x46>
    if (pid == 0) {
    1690:	cd15                	beqz	a0,16cc <forkfork+0x5a>
    wait(&xstatus);
    1692:	fdc40513          	addi	a0,s0,-36
    1696:	19d030ef          	jal	5032 <wait>
    if (xstatus != 0) {
    169a:	fdc42783          	lw	a5,-36(s0)
    169e:	ebb9                	bnez	a5,16f4 <forkfork+0x82>
    wait(&xstatus);
    16a0:	fdc40513          	addi	a0,s0,-36
    16a4:	18f030ef          	jal	5032 <wait>
    if (xstatus != 0) {
    16a8:	fdc42783          	lw	a5,-36(s0)
    16ac:	e7a1                	bnez	a5,16f4 <forkfork+0x82>
}
    16ae:	70a2                	ld	ra,40(sp)
    16b0:	7402                	ld	s0,32(sp)
    16b2:	64e2                	ld	s1,24(sp)
    16b4:	6145                	addi	sp,sp,48
    16b6:	8082                	ret
      printf("%s: fork failed", s);
    16b8:	85a6                	mv	a1,s1
    16ba:	00005517          	auipc	a0,0x5
    16be:	98e50513          	addi	a0,a0,-1650 # 6048 <malloc+0xafc>
    16c2:	5cf030ef          	jal	5490 <printf>
      exit(1);
    16c6:	4505                	li	a0,1
    16c8:	163030ef          	jal	502a <exit>
{
    16cc:	0c800493          	li	s1,200
        int pid1 = fork();
    16d0:	153030ef          	jal	5022 <fork>
        if (pid1 < 0) {
    16d4:	00054b63          	bltz	a0,16ea <forkfork+0x78>
        if (pid1 == 0) {
    16d8:	cd01                	beqz	a0,16f0 <forkfork+0x7e>
        wait(0);
    16da:	4501                	li	a0,0
    16dc:	157030ef          	jal	5032 <wait>
      for (int j = 0; j < 200; j++) {
    16e0:	34fd                	addiw	s1,s1,-1
    16e2:	f4fd                	bnez	s1,16d0 <forkfork+0x5e>
      exit(0);
    16e4:	4501                	li	a0,0
    16e6:	145030ef          	jal	502a <exit>
          exit(1);
    16ea:	4505                	li	a0,1
    16ec:	13f030ef          	jal	502a <exit>
          exit(0);
    16f0:	13b030ef          	jal	502a <exit>
      printf("%s: fork in child failed", s);
    16f4:	85a6                	mv	a1,s1
    16f6:	00005517          	auipc	a0,0x5
    16fa:	96250513          	addi	a0,a0,-1694 # 6058 <malloc+0xb0c>
    16fe:	593030ef          	jal	5490 <printf>
      exit(1);
    1702:	4505                	li	a0,1
    1704:	127030ef          	jal	502a <exit>

0000000000001708 <reparent2>:
{
    1708:	1101                	addi	sp,sp,-32
    170a:	ec06                	sd	ra,24(sp)
    170c:	e822                	sd	s0,16(sp)
    170e:	e426                	sd	s1,8(sp)
    1710:	1000                	addi	s0,sp,32
    1712:	32000493          	li	s1,800
    int pid1 = fork();
    1716:	10d030ef          	jal	5022 <fork>
    if (pid1 < 0) {
    171a:	00054b63          	bltz	a0,1730 <reparent2+0x28>
    if (pid1 == 0) {
    171e:	c115                	beqz	a0,1742 <reparent2+0x3a>
    wait(0);
    1720:	4501                	li	a0,0
    1722:	111030ef          	jal	5032 <wait>
  for (int i = 0; i < 800; i++) {
    1726:	34fd                	addiw	s1,s1,-1
    1728:	f4fd                	bnez	s1,1716 <reparent2+0xe>
  exit(0);
    172a:	4501                	li	a0,0
    172c:	0ff030ef          	jal	502a <exit>
      printf("fork failed\n");
    1730:	00006517          	auipc	a0,0x6
    1734:	db050513          	addi	a0,a0,-592 # 74e0 <malloc+0x1f94>
    1738:	559030ef          	jal	5490 <printf>
      exit(1);
    173c:	4505                	li	a0,1
    173e:	0ed030ef          	jal	502a <exit>
      fork();
    1742:	0e1030ef          	jal	5022 <fork>
      fork();
    1746:	0dd030ef          	jal	5022 <fork>
      exit(0);
    174a:	4501                	li	a0,0
    174c:	0df030ef          	jal	502a <exit>

0000000000001750 <createdelete>:
{
    1750:	7135                	addi	sp,sp,-160
    1752:	ed06                	sd	ra,152(sp)
    1754:	e922                	sd	s0,144(sp)
    1756:	e526                	sd	s1,136(sp)
    1758:	e14a                	sd	s2,128(sp)
    175a:	fcce                	sd	s3,120(sp)
    175c:	f8d2                	sd	s4,112(sp)
    175e:	f4d6                	sd	s5,104(sp)
    1760:	f0da                	sd	s6,96(sp)
    1762:	ecde                	sd	s7,88(sp)
    1764:	e8e2                	sd	s8,80(sp)
    1766:	e4e6                	sd	s9,72(sp)
    1768:	e0ea                	sd	s10,64(sp)
    176a:	fc6e                	sd	s11,56(sp)
    176c:	1100                	addi	s0,sp,160
    176e:	8daa                	mv	s11,a0
  for (pi = 0; pi < NCHILD; pi++) {
    1770:	4901                	li	s2,0
    1772:	4991                	li	s3,4
    pid = fork();
    1774:	0af030ef          	jal	5022 <fork>
    1778:	84aa                	mv	s1,a0
    if (pid < 0) {
    177a:	04054063          	bltz	a0,17ba <createdelete+0x6a>
    if (pid == 0) {
    177e:	c921                	beqz	a0,17ce <createdelete+0x7e>
  for (pi = 0; pi < NCHILD; pi++) {
    1780:	2905                	addiw	s2,s2,1
    1782:	ff3919e3          	bne	s2,s3,1774 <createdelete+0x24>
    1786:	4491                	li	s1,4
    wait(&xstatus);
    1788:	f6c40913          	addi	s2,s0,-148
    178c:	854a                	mv	a0,s2
    178e:	0a5030ef          	jal	5032 <wait>
    if (xstatus != 0)
    1792:	f6c42a83          	lw	s5,-148(s0)
    1796:	0c0a9263          	bnez	s5,185a <createdelete+0x10a>
  for (pi = 0; pi < NCHILD; pi++) {
    179a:	34fd                	addiw	s1,s1,-1
    179c:	f8e5                	bnez	s1,178c <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    179e:	f6040923          	sb	zero,-142(s0)
    17a2:	03000993          	li	s3,48
    17a6:	5a7d                	li	s4,-1
      if ((i == 0 || i >= N / 2) && fd < 0) {
    17a8:	4d25                	li	s10,9
    17aa:	07000c93          	li	s9,112
      fd = open(name, 0);
    17ae:	f7040c13          	addi	s8,s0,-144
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    17b2:	4ba1                	li	s7,8
    for (pi = 0; pi < NCHILD; pi++) {
    17b4:	07400b13          	li	s6,116
    17b8:	aa39                	j	18d6 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    17ba:	85ee                	mv	a1,s11
    17bc:	00004517          	auipc	a0,0x4
    17c0:	74c50513          	addi	a0,a0,1868 # 5f08 <malloc+0x9bc>
    17c4:	4cd030ef          	jal	5490 <printf>
      exit(1);
    17c8:	4505                	li	a0,1
    17ca:	061030ef          	jal	502a <exit>
      name[0] = 'p' + pi;
    17ce:	0709091b          	addiw	s2,s2,112
    17d2:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    17d6:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    17da:	f7040913          	addi	s2,s0,-144
    17de:	20200993          	li	s3,514
      for (i = 0; i < N; i++) {
    17e2:	4a51                	li	s4,20
    17e4:	a815                	j	1818 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    17e6:	85ee                	mv	a1,s11
    17e8:	00005517          	auipc	a0,0x5
    17ec:	89050513          	addi	a0,a0,-1904 # 6078 <malloc+0xb2c>
    17f0:	4a1030ef          	jal	5490 <printf>
          exit(1);
    17f4:	4505                	li	a0,1
    17f6:	035030ef          	jal	502a <exit>
          name[1] = '0' + (i / 2);
    17fa:	01f4d79b          	srliw	a5,s1,0x1f
    17fe:	9fa5                	addw	a5,a5,s1
    1800:	4017d79b          	sraiw	a5,a5,0x1
    1804:	0307879b          	addiw	a5,a5,48
    1808:	f6f408a3          	sb	a5,-143(s0)
          if (unlink(name) < 0) {
    180c:	854a                	mv	a0,s2
    180e:	06d030ef          	jal	507a <unlink>
    1812:	02054a63          	bltz	a0,1846 <createdelete+0xf6>
      for (i = 0; i < N; i++) {
    1816:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1818:	0304879b          	addiw	a5,s1,48
    181c:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1820:	85ce                	mv	a1,s3
    1822:	854a                	mv	a0,s2
    1824:	047030ef          	jal	506a <open>
        if (fd < 0) {
    1828:	fa054fe3          	bltz	a0,17e6 <createdelete+0x96>
        close(fd);
    182c:	027030ef          	jal	5052 <close>
        if (i > 0 && (i % 2) == 0) {
    1830:	fe9053e3          	blez	s1,1816 <createdelete+0xc6>
    1834:	0014f793          	andi	a5,s1,1
    1838:	d3e9                	beqz	a5,17fa <createdelete+0xaa>
      for (i = 0; i < N; i++) {
    183a:	2485                	addiw	s1,s1,1
    183c:	fd449ee3          	bne	s1,s4,1818 <createdelete+0xc8>
      exit(0);
    1840:	4501                	li	a0,0
    1842:	7e8030ef          	jal	502a <exit>
            printf("%s: unlink failed\n", s);
    1846:	85ee                	mv	a1,s11
    1848:	00005517          	auipc	a0,0x5
    184c:	84850513          	addi	a0,a0,-1976 # 6090 <malloc+0xb44>
    1850:	441030ef          	jal	5490 <printf>
            exit(1);
    1854:	4505                	li	a0,1
    1856:	7d4030ef          	jal	502a <exit>
      exit(1);
    185a:	4505                	li	a0,1
    185c:	7ce030ef          	jal	502a <exit>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1860:	f7040613          	addi	a2,s0,-144
    1864:	85ee                	mv	a1,s11
    1866:	00005517          	auipc	a0,0x5
    186a:	84250513          	addi	a0,a0,-1982 # 60a8 <malloc+0xb5c>
    186e:	423030ef          	jal	5490 <printf>
        exit(1);
    1872:	4505                	li	a0,1
    1874:	7b6030ef          	jal	502a <exit>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    1878:	02054063          	bltz	a0,1898 <createdelete+0x148>
        printf("%s: oops createdelete %s did exist\n", s, name);
    187c:	f7040613          	addi	a2,s0,-144
    1880:	85ee                	mv	a1,s11
    1882:	00005517          	auipc	a0,0x5
    1886:	84e50513          	addi	a0,a0,-1970 # 60d0 <malloc+0xb84>
    188a:	407030ef          	jal	5490 <printf>
        exit(1);
    188e:	4505                	li	a0,1
    1890:	79a030ef          	jal	502a <exit>
        close(fd);
    1894:	7be030ef          	jal	5052 <close>
    for (pi = 0; pi < NCHILD; pi++) {
    1898:	2485                	addiw	s1,s1,1
    189a:	0ff4f493          	zext.b	s1,s1
    189e:	03648463          	beq	s1,s6,18c6 <createdelete+0x176>
      name[0] = 'p' + pi;
    18a2:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    18a6:	f73408a3          	sb	s3,-143(s0)
      fd = open(name, 0);
    18aa:	4581                	li	a1,0
    18ac:	8562                	mv	a0,s8
    18ae:	7bc030ef          	jal	506a <open>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18b2:	01f5579b          	srliw	a5,a0,0x1f
    18b6:	00f977b3          	and	a5,s2,a5
    18ba:	f3dd                	bnez	a5,1860 <createdelete+0x110>
      } else if ((i >= 1 && i < N / 2) && fd >= 0) {
    18bc:	fb4bfee3          	bgeu	s7,s4,1878 <createdelete+0x128>
      if (fd >= 0)
    18c0:	fc054ce3          	bltz	a0,1898 <createdelete+0x148>
    18c4:	bfc1                	j	1894 <createdelete+0x144>
  for (i = 0; i < N; i++) {
    18c6:	2a85                	addiw	s5,s5,1
    18c8:	2a05                	addiw	s4,s4,1
    18ca:	2985                	addiw	s3,s3,1
    18cc:	0ff9f993          	zext.b	s3,s3
    18d0:	47d1                	li	a5,20
    18d2:	00fa8a63          	beq	s5,a5,18e6 <createdelete+0x196>
      if ((i == 0 || i >= N / 2) && fd < 0) {
    18d6:	001ab913          	seqz	s2,s5
    18da:	015d27b3          	slt	a5,s10,s5
    18de:	00f96933          	or	s2,s2,a5
    18e2:	84e6                	mv	s1,s9
    18e4:	bf7d                	j	18a2 <createdelete+0x152>
  for (i = 0; i < N; i++) {
    18e6:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    18ea:	07000b13          	li	s6,112
      unlink(name);
    18ee:	f7040a13          	addi	s4,s0,-144
    for (pi = 0; pi < NCHILD; pi++) {
    18f2:	07400993          	li	s3,116
  for (i = 0; i < N; i++) {
    18f6:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    18fa:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    18fc:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1900:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1904:	8552                	mv	a0,s4
    1906:	774030ef          	jal	507a <unlink>
    for (pi = 0; pi < NCHILD; pi++) {
    190a:	2485                	addiw	s1,s1,1
    190c:	0ff4f493          	zext.b	s1,s1
    1910:	ff3496e3          	bne	s1,s3,18fc <createdelete+0x1ac>
  for (i = 0; i < N; i++) {
    1914:	2905                	addiw	s2,s2,1
    1916:	0ff97913          	zext.b	s2,s2
    191a:	ff5910e3          	bne	s2,s5,18fa <createdelete+0x1aa>
}
    191e:	60ea                	ld	ra,152(sp)
    1920:	644a                	ld	s0,144(sp)
    1922:	64aa                	ld	s1,136(sp)
    1924:	690a                	ld	s2,128(sp)
    1926:	79e6                	ld	s3,120(sp)
    1928:	7a46                	ld	s4,112(sp)
    192a:	7aa6                	ld	s5,104(sp)
    192c:	7b06                	ld	s6,96(sp)
    192e:	6be6                	ld	s7,88(sp)
    1930:	6c46                	ld	s8,80(sp)
    1932:	6ca6                	ld	s9,72(sp)
    1934:	6d06                	ld	s10,64(sp)
    1936:	7de2                	ld	s11,56(sp)
    1938:	610d                	addi	sp,sp,160
    193a:	8082                	ret

000000000000193c <linkunlink>:
{
    193c:	711d                	addi	sp,sp,-96
    193e:	ec86                	sd	ra,88(sp)
    1940:	e8a2                	sd	s0,80(sp)
    1942:	e4a6                	sd	s1,72(sp)
    1944:	e0ca                	sd	s2,64(sp)
    1946:	fc4e                	sd	s3,56(sp)
    1948:	f852                	sd	s4,48(sp)
    194a:	f456                	sd	s5,40(sp)
    194c:	f05a                	sd	s6,32(sp)
    194e:	ec5e                	sd	s7,24(sp)
    1950:	e862                	sd	s8,16(sp)
    1952:	e466                	sd	s9,8(sp)
    1954:	e06a                	sd	s10,0(sp)
    1956:	1080                	addi	s0,sp,96
    1958:	84aa                	mv	s1,a0
  unlink("x");
    195a:	00004517          	auipc	a0,0x4
    195e:	d8e50513          	addi	a0,a0,-626 # 56e8 <malloc+0x19c>
    1962:	718030ef          	jal	507a <unlink>
  pid = fork();
    1966:	6bc030ef          	jal	5022 <fork>
  if (pid < 0) {
    196a:	04054663          	bltz	a0,19b6 <linkunlink+0x7a>
    196e:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1970:	00153913          	seqz	s2,a0
    1974:	41200933          	neg	s2,s2
    1978:	06097913          	andi	s2,s2,96
    197c:	0905                	addi	s2,s2,1
    197e:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1982:	41c65ab7          	lui	s5,0x41c65
    1986:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561b5>
    198a:	6a0d                	lui	s4,0x3
    198c:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x4b3>
    if ((x % 3) == 0) {
    1990:	000ab9b7          	lui	s3,0xab
    1994:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9bdf3>
    1998:	09b2                	slli	s3,s3,0xc
    199a:	aab98993          	addi	s3,s3,-1365
    } else if ((x % 3) == 1) {
    199e:	4b85                	li	s7,1
      unlink("x");
    19a0:	00004b17          	auipc	s6,0x4
    19a4:	d48b0b13          	addi	s6,s6,-696 # 56e8 <malloc+0x19c>
      link("cat", "x");
    19a8:	00004c97          	auipc	s9,0x4
    19ac:	750c8c93          	addi	s9,s9,1872 # 60f8 <malloc+0xbac>
      close(open("x", O_RDWR | O_CREATE));
    19b0:	20200c13          	li	s8,514
    19b4:	a03d                	j	19e2 <linkunlink+0xa6>
    printf("%s: fork failed\n", s);
    19b6:	85a6                	mv	a1,s1
    19b8:	00004517          	auipc	a0,0x4
    19bc:	55050513          	addi	a0,a0,1360 # 5f08 <malloc+0x9bc>
    19c0:	2d1030ef          	jal	5490 <printf>
    exit(1);
    19c4:	4505                	li	a0,1
    19c6:	664030ef          	jal	502a <exit>
      close(open("x", O_RDWR | O_CREATE));
    19ca:	85e2                	mv	a1,s8
    19cc:	855a                	mv	a0,s6
    19ce:	69c030ef          	jal	506a <open>
    19d2:	680030ef          	jal	5052 <close>
    19d6:	a021                	j	19de <linkunlink+0xa2>
      unlink("x");
    19d8:	855a                	mv	a0,s6
    19da:	6a0030ef          	jal	507a <unlink>
  for (i = 0; i < 100; i++) {
    19de:	34fd                	addiw	s1,s1,-1
    19e0:	c885                	beqz	s1,1a10 <linkunlink+0xd4>
    x = x * 1103515245 + 12345;
    19e2:	035907bb          	mulw	a5,s2,s5
    19e6:	00fa07bb          	addw	a5,s4,a5
    19ea:	893e                	mv	s2,a5
    if ((x % 3) == 0) {
    19ec:	02079713          	slli	a4,a5,0x20
    19f0:	9301                	srli	a4,a4,0x20
    19f2:	03370733          	mul	a4,a4,s3
    19f6:	9305                	srli	a4,a4,0x21
    19f8:	0017169b          	slliw	a3,a4,0x1
    19fc:	9f35                	addw	a4,a4,a3
    19fe:	9f99                	subw	a5,a5,a4
    1a00:	d7e9                	beqz	a5,19ca <linkunlink+0x8e>
    } else if ((x % 3) == 1) {
    1a02:	fd779be3          	bne	a5,s7,19d8 <linkunlink+0x9c>
      link("cat", "x");
    1a06:	85da                	mv	a1,s6
    1a08:	8566                	mv	a0,s9
    1a0a:	680030ef          	jal	508a <link>
    1a0e:	bfc1                	j	19de <linkunlink+0xa2>
  if (pid)
    1a10:	020d0363          	beqz	s10,1a36 <linkunlink+0xfa>
    wait(0);
    1a14:	4501                	li	a0,0
    1a16:	61c030ef          	jal	5032 <wait>
}
    1a1a:	60e6                	ld	ra,88(sp)
    1a1c:	6446                	ld	s0,80(sp)
    1a1e:	64a6                	ld	s1,72(sp)
    1a20:	6906                	ld	s2,64(sp)
    1a22:	79e2                	ld	s3,56(sp)
    1a24:	7a42                	ld	s4,48(sp)
    1a26:	7aa2                	ld	s5,40(sp)
    1a28:	7b02                	ld	s6,32(sp)
    1a2a:	6be2                	ld	s7,24(sp)
    1a2c:	6c42                	ld	s8,16(sp)
    1a2e:	6ca2                	ld	s9,8(sp)
    1a30:	6d02                	ld	s10,0(sp)
    1a32:	6125                	addi	sp,sp,96
    1a34:	8082                	ret
    exit(0);
    1a36:	4501                	li	a0,0
    1a38:	5f2030ef          	jal	502a <exit>

0000000000001a3c <forktest>:
{
    1a3c:	7179                	addi	sp,sp,-48
    1a3e:	f406                	sd	ra,40(sp)
    1a40:	f022                	sd	s0,32(sp)
    1a42:	ec26                	sd	s1,24(sp)
    1a44:	e84a                	sd	s2,16(sp)
    1a46:	e44e                	sd	s3,8(sp)
    1a48:	1800                	addi	s0,sp,48
    1a4a:	89aa                	mv	s3,a0
  for (n = 0; n < N; n++) {
    1a4c:	4481                	li	s1,0
    1a4e:	3e800913          	li	s2,1000
    pid = fork();
    1a52:	5d0030ef          	jal	5022 <fork>
    if (pid < 0)
    1a56:	06054063          	bltz	a0,1ab6 <forktest+0x7a>
    if (pid == 0)
    1a5a:	cd11                	beqz	a0,1a76 <forktest+0x3a>
  for (n = 0; n < N; n++) {
    1a5c:	2485                	addiw	s1,s1,1
    1a5e:	ff249ae3          	bne	s1,s2,1a52 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1a62:	85ce                	mv	a1,s3
    1a64:	00004517          	auipc	a0,0x4
    1a68:	6e450513          	addi	a0,a0,1764 # 6148 <malloc+0xbfc>
    1a6c:	225030ef          	jal	5490 <printf>
    exit(1);
    1a70:	4505                	li	a0,1
    1a72:	5b8030ef          	jal	502a <exit>
      exit(0);
    1a76:	5b4030ef          	jal	502a <exit>
    printf("%s: no fork at all!\n", s);
    1a7a:	85ce                	mv	a1,s3
    1a7c:	00004517          	auipc	a0,0x4
    1a80:	68450513          	addi	a0,a0,1668 # 6100 <malloc+0xbb4>
    1a84:	20d030ef          	jal	5490 <printf>
    exit(1);
    1a88:	4505                	li	a0,1
    1a8a:	5a0030ef          	jal	502a <exit>
      printf("%s: wait stopped early\n", s);
    1a8e:	85ce                	mv	a1,s3
    1a90:	00004517          	auipc	a0,0x4
    1a94:	68850513          	addi	a0,a0,1672 # 6118 <malloc+0xbcc>
    1a98:	1f9030ef          	jal	5490 <printf>
      exit(1);
    1a9c:	4505                	li	a0,1
    1a9e:	58c030ef          	jal	502a <exit>
    printf("%s: wait got too many\n", s);
    1aa2:	85ce                	mv	a1,s3
    1aa4:	00004517          	auipc	a0,0x4
    1aa8:	68c50513          	addi	a0,a0,1676 # 6130 <malloc+0xbe4>
    1aac:	1e5030ef          	jal	5490 <printf>
    exit(1);
    1ab0:	4505                	li	a0,1
    1ab2:	578030ef          	jal	502a <exit>
  if (n == 0) {
    1ab6:	d0f1                	beqz	s1,1a7a <forktest+0x3e>
  for (; n > 0; n--) {
    1ab8:	00905963          	blez	s1,1aca <forktest+0x8e>
    if (wait(0) < 0) {
    1abc:	4501                	li	a0,0
    1abe:	574030ef          	jal	5032 <wait>
    1ac2:	fc0546e3          	bltz	a0,1a8e <forktest+0x52>
  for (; n > 0; n--) {
    1ac6:	34fd                	addiw	s1,s1,-1
    1ac8:	f8f5                	bnez	s1,1abc <forktest+0x80>
  if (wait(0) != -1) {
    1aca:	4501                	li	a0,0
    1acc:	566030ef          	jal	5032 <wait>
    1ad0:	57fd                	li	a5,-1
    1ad2:	fcf518e3          	bne	a0,a5,1aa2 <forktest+0x66>
}
    1ad6:	70a2                	ld	ra,40(sp)
    1ad8:	7402                	ld	s0,32(sp)
    1ada:	64e2                	ld	s1,24(sp)
    1adc:	6942                	ld	s2,16(sp)
    1ade:	69a2                	ld	s3,8(sp)
    1ae0:	6145                	addi	sp,sp,48
    1ae2:	8082                	ret

0000000000001ae4 <kernmem>:
{
    1ae4:	715d                	addi	sp,sp,-80
    1ae6:	e486                	sd	ra,72(sp)
    1ae8:	e0a2                	sd	s0,64(sp)
    1aea:	fc26                	sd	s1,56(sp)
    1aec:	f84a                	sd	s2,48(sp)
    1aee:	f44e                	sd	s3,40(sp)
    1af0:	f052                	sd	s4,32(sp)
    1af2:	ec56                	sd	s5,24(sp)
    1af4:	e85a                	sd	s6,16(sp)
    1af6:	0880                	addi	s0,sp,80
    1af8:	8b2a                	mv	s6,a0
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1afa:	4485                	li	s1,1
    1afc:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1afe:	fbc40a93          	addi	s5,s0,-68
    if (xstatus != -1) // did kernel kill child?
    1b02:	5a7d                	li	s4,-1
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b04:	69b1                	lui	s3,0xc
    1b06:	35098993          	addi	s3,s3,848 # c350 <buf+0x698>
    1b0a:	1003d937          	lui	s2,0x1003d
    1b0e:	090e                	slli	s2,s2,0x3
    1b10:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7c8>
    pid = fork();
    1b14:	50e030ef          	jal	5022 <fork>
    if (pid < 0) {
    1b18:	02054763          	bltz	a0,1b46 <kernmem+0x62>
    if (pid == 0) {
    1b1c:	cd1d                	beqz	a0,1b5a <kernmem+0x76>
    wait(&xstatus);
    1b1e:	8556                	mv	a0,s5
    1b20:	512030ef          	jal	5032 <wait>
    if (xstatus != -1) // did kernel kill child?
    1b24:	fbc42783          	lw	a5,-68(s0)
    1b28:	05479663          	bne	a5,s4,1b74 <kernmem+0x90>
  for (a = (char *)(KERNBASE); a < (char *)(KERNBASE + 2000000); a += 50000) {
    1b2c:	94ce                	add	s1,s1,s3
    1b2e:	ff2493e3          	bne	s1,s2,1b14 <kernmem+0x30>
}
    1b32:	60a6                	ld	ra,72(sp)
    1b34:	6406                	ld	s0,64(sp)
    1b36:	74e2                	ld	s1,56(sp)
    1b38:	7942                	ld	s2,48(sp)
    1b3a:	79a2                	ld	s3,40(sp)
    1b3c:	7a02                	ld	s4,32(sp)
    1b3e:	6ae2                	ld	s5,24(sp)
    1b40:	6b42                	ld	s6,16(sp)
    1b42:	6161                	addi	sp,sp,80
    1b44:	8082                	ret
      printf("%s: fork failed\n", s);
    1b46:	85da                	mv	a1,s6
    1b48:	00004517          	auipc	a0,0x4
    1b4c:	3c050513          	addi	a0,a0,960 # 5f08 <malloc+0x9bc>
    1b50:	141030ef          	jal	5490 <printf>
      exit(1);
    1b54:	4505                	li	a0,1
    1b56:	4d4030ef          	jal	502a <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1b5a:	0004c683          	lbu	a3,0(s1)
    1b5e:	8626                	mv	a2,s1
    1b60:	85da                	mv	a1,s6
    1b62:	00004517          	auipc	a0,0x4
    1b66:	60e50513          	addi	a0,a0,1550 # 6170 <malloc+0xc24>
    1b6a:	127030ef          	jal	5490 <printf>
      exit(1);
    1b6e:	4505                	li	a0,1
    1b70:	4ba030ef          	jal	502a <exit>
      exit(1);
    1b74:	4505                	li	a0,1
    1b76:	4b4030ef          	jal	502a <exit>

0000000000001b7a <MAXVAplus>:
{
    1b7a:	7139                	addi	sp,sp,-64
    1b7c:	fc06                	sd	ra,56(sp)
    1b7e:	f822                	sd	s0,48(sp)
    1b80:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1b82:	4785                	li	a5,1
    1b84:	179a                	slli	a5,a5,0x26
    1b86:	fcf43423          	sd	a5,-56(s0)
  for (; a != 0; a <<= 1) {
    1b8a:	fc843783          	ld	a5,-56(s0)
    1b8e:	cf9d                	beqz	a5,1bcc <MAXVAplus+0x52>
    1b90:	f426                	sd	s1,40(sp)
    1b92:	f04a                	sd	s2,32(sp)
    1b94:	ec4e                	sd	s3,24(sp)
    1b96:	89aa                	mv	s3,a0
    wait(&xstatus);
    1b98:	fc440913          	addi	s2,s0,-60
    if (xstatus != -1) // did kernel kill child?
    1b9c:	54fd                	li	s1,-1
    pid = fork();
    1b9e:	484030ef          	jal	5022 <fork>
    if (pid < 0) {
    1ba2:	02054963          	bltz	a0,1bd4 <MAXVAplus+0x5a>
    if (pid == 0) {
    1ba6:	c129                	beqz	a0,1be8 <MAXVAplus+0x6e>
    wait(&xstatus);
    1ba8:	854a                	mv	a0,s2
    1baa:	488030ef          	jal	5032 <wait>
    if (xstatus != -1) // did kernel kill child?
    1bae:	fc442783          	lw	a5,-60(s0)
    1bb2:	04979d63          	bne	a5,s1,1c0c <MAXVAplus+0x92>
  for (; a != 0; a <<= 1) {
    1bb6:	fc843783          	ld	a5,-56(s0)
    1bba:	0786                	slli	a5,a5,0x1
    1bbc:	fcf43423          	sd	a5,-56(s0)
    1bc0:	fc843783          	ld	a5,-56(s0)
    1bc4:	ffe9                	bnez	a5,1b9e <MAXVAplus+0x24>
    1bc6:	74a2                	ld	s1,40(sp)
    1bc8:	7902                	ld	s2,32(sp)
    1bca:	69e2                	ld	s3,24(sp)
}
    1bcc:	70e2                	ld	ra,56(sp)
    1bce:	7442                	ld	s0,48(sp)
    1bd0:	6121                	addi	sp,sp,64
    1bd2:	8082                	ret
      printf("%s: fork failed\n", s);
    1bd4:	85ce                	mv	a1,s3
    1bd6:	00004517          	auipc	a0,0x4
    1bda:	33250513          	addi	a0,a0,818 # 5f08 <malloc+0x9bc>
    1bde:	0b3030ef          	jal	5490 <printf>
      exit(1);
    1be2:	4505                	li	a0,1
    1be4:	446030ef          	jal	502a <exit>
      *(char *)a = 99;
    1be8:	fc843783          	ld	a5,-56(s0)
    1bec:	06300713          	li	a4,99
    1bf0:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void *)a);
    1bf4:	fc843603          	ld	a2,-56(s0)
    1bf8:	85ce                	mv	a1,s3
    1bfa:	00004517          	auipc	a0,0x4
    1bfe:	59650513          	addi	a0,a0,1430 # 6190 <malloc+0xc44>
    1c02:	08f030ef          	jal	5490 <printf>
      exit(1);
    1c06:	4505                	li	a0,1
    1c08:	422030ef          	jal	502a <exit>
      exit(1);
    1c0c:	4505                	li	a0,1
    1c0e:	41c030ef          	jal	502a <exit>

0000000000001c12 <stacktest>:
{
    1c12:	7179                	addi	sp,sp,-48
    1c14:	f406                	sd	ra,40(sp)
    1c16:	f022                	sd	s0,32(sp)
    1c18:	ec26                	sd	s1,24(sp)
    1c1a:	1800                	addi	s0,sp,48
    1c1c:	84aa                	mv	s1,a0
  pid = fork();
    1c1e:	404030ef          	jal	5022 <fork>
  if (pid == 0) {
    1c22:	cd11                	beqz	a0,1c3e <stacktest+0x2c>
  } else if (pid < 0) {
    1c24:	02054c63          	bltz	a0,1c5c <stacktest+0x4a>
  wait(&xstatus);
    1c28:	fdc40513          	addi	a0,s0,-36
    1c2c:	406030ef          	jal	5032 <wait>
  if (xstatus == -1) // kernel killed child?
    1c30:	fdc42503          	lw	a0,-36(s0)
    1c34:	57fd                	li	a5,-1
    1c36:	02f50d63          	beq	a0,a5,1c70 <stacktest+0x5e>
    exit(xstatus);
    1c3a:	3f0030ef          	jal	502a <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r"(x));
    1c3e:	870a                	mv	a4,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1c40:	77fd                	lui	a5,0xfffff
    1c42:	97ba                	add	a5,a5,a4
    1c44:	0007c603          	lbu	a2,0(a5) # fffffffffffff000 <base+0xffffffffffff0348>
    1c48:	85a6                	mv	a1,s1
    1c4a:	00004517          	auipc	a0,0x4
    1c4e:	55e50513          	addi	a0,a0,1374 # 61a8 <malloc+0xc5c>
    1c52:	03f030ef          	jal	5490 <printf>
    exit(1);
    1c56:	4505                	li	a0,1
    1c58:	3d2030ef          	jal	502a <exit>
    printf("%s: fork failed\n", s);
    1c5c:	85a6                	mv	a1,s1
    1c5e:	00004517          	auipc	a0,0x4
    1c62:	2aa50513          	addi	a0,a0,682 # 5f08 <malloc+0x9bc>
    1c66:	02b030ef          	jal	5490 <printf>
    exit(1);
    1c6a:	4505                	li	a0,1
    1c6c:	3be030ef          	jal	502a <exit>
    exit(0);
    1c70:	4501                	li	a0,0
    1c72:	3b8030ef          	jal	502a <exit>

0000000000001c76 <nowrite>:
{
    1c76:	7159                	addi	sp,sp,-112
    1c78:	f486                	sd	ra,104(sp)
    1c7a:	f0a2                	sd	s0,96(sp)
    1c7c:	eca6                	sd	s1,88(sp)
    1c7e:	e8ca                	sd	s2,80(sp)
    1c80:	e4ce                	sd	s3,72(sp)
    1c82:	e0d2                	sd	s4,64(sp)
    1c84:	1880                	addi	s0,sp,112
    1c86:	8a2a                	mv	s4,a0
  uint64 addrs[] = {0,
    1c88:	00006797          	auipc	a5,0x6
    1c8c:	f6878793          	addi	a5,a5,-152 # 7bf0 <malloc+0x26a4>
    1c90:	7788                	ld	a0,40(a5)
    1c92:	7b8c                	ld	a1,48(a5)
    1c94:	7f90                	ld	a2,56(a5)
    1c96:	63b4                	ld	a3,64(a5)
    1c98:	67b8                	ld	a4,72(a5)
    1c9a:	f8a43c23          	sd	a0,-104(s0)
    1c9e:	fab43023          	sd	a1,-96(s0)
    1ca2:	fac43423          	sd	a2,-88(s0)
    1ca6:	fad43823          	sd	a3,-80(s0)
    1caa:	fae43c23          	sd	a4,-72(s0)
    1cae:	6bbc                	ld	a5,80(a5)
    1cb0:	fcf43023          	sd	a5,-64(s0)
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cb4:	4481                	li	s1,0
    wait(&xstatus);
    1cb6:	fcc40913          	addi	s2,s0,-52
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cba:	4999                	li	s3,6
    pid = fork();
    1cbc:	366030ef          	jal	5022 <fork>
    if (pid == 0) {
    1cc0:	cd19                	beqz	a0,1cde <nowrite+0x68>
    } else if (pid < 0) {
    1cc2:	04054063          	bltz	a0,1d02 <nowrite+0x8c>
    wait(&xstatus);
    1cc6:	854a                	mv	a0,s2
    1cc8:	36a030ef          	jal	5032 <wait>
    if (xstatus == 0) {
    1ccc:	fcc42783          	lw	a5,-52(s0)
    1cd0:	c3b9                	beqz	a5,1d16 <nowrite+0xa0>
  for (int ai = 0; ai < sizeof(addrs) / sizeof(addrs[0]); ai++) {
    1cd2:	2485                	addiw	s1,s1,1
    1cd4:	ff3494e3          	bne	s1,s3,1cbc <nowrite+0x46>
  exit(0);
    1cd8:	4501                	li	a0,0
    1cda:	350030ef          	jal	502a <exit>
      volatile int *addr = (int *)addrs[ai];
    1cde:	048e                	slli	s1,s1,0x3
    1ce0:	fd040793          	addi	a5,s0,-48
    1ce4:	94be                	add	s1,s1,a5
    1ce6:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1cea:	47a9                	li	a5,10
    1cec:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1cee:	85d2                	mv	a1,s4
    1cf0:	00004517          	auipc	a0,0x4
    1cf4:	4e050513          	addi	a0,a0,1248 # 61d0 <malloc+0xc84>
    1cf8:	798030ef          	jal	5490 <printf>
      exit(0);
    1cfc:	4501                	li	a0,0
    1cfe:	32c030ef          	jal	502a <exit>
      printf("%s: fork failed\n", s);
    1d02:	85d2                	mv	a1,s4
    1d04:	00004517          	auipc	a0,0x4
    1d08:	20450513          	addi	a0,a0,516 # 5f08 <malloc+0x9bc>
    1d0c:	784030ef          	jal	5490 <printf>
      exit(1);
    1d10:	4505                	li	a0,1
    1d12:	318030ef          	jal	502a <exit>
      exit(1);
    1d16:	4505                	li	a0,1
    1d18:	312030ef          	jal	502a <exit>

0000000000001d1c <manywrites>:
{
    1d1c:	7159                	addi	sp,sp,-112
    1d1e:	f486                	sd	ra,104(sp)
    1d20:	f0a2                	sd	s0,96(sp)
    1d22:	eca6                	sd	s1,88(sp)
    1d24:	e8ca                	sd	s2,80(sp)
    1d26:	e4ce                	sd	s3,72(sp)
    1d28:	ec66                	sd	s9,24(sp)
    1d2a:	1880                	addi	s0,sp,112
    1d2c:	8caa                	mv	s9,a0
  for (int ci = 0; ci < nchildren; ci++) {
    1d2e:	4901                	li	s2,0
    1d30:	4991                	li	s3,4
    int pid = fork();
    1d32:	2f0030ef          	jal	5022 <fork>
    1d36:	84aa                	mv	s1,a0
    if (pid < 0) {
    1d38:	02054c63          	bltz	a0,1d70 <manywrites+0x54>
    if (pid == 0) {
    1d3c:	c929                	beqz	a0,1d8e <manywrites+0x72>
  for (int ci = 0; ci < nchildren; ci++) {
    1d3e:	2905                	addiw	s2,s2,1
    1d40:	ff3919e3          	bne	s2,s3,1d32 <manywrites+0x16>
    1d44:	4491                	li	s1,4
    wait(&st);
    1d46:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1d4a:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1d4e:	854a                	mv	a0,s2
    1d50:	2e2030ef          	jal	5032 <wait>
    if (st != 0)
    1d54:	f9842503          	lw	a0,-104(s0)
    1d58:	0e051763          	bnez	a0,1e46 <manywrites+0x12a>
  for (int ci = 0; ci < nchildren; ci++) {
    1d5c:	34fd                	addiw	s1,s1,-1
    1d5e:	f4f5                	bnez	s1,1d4a <manywrites+0x2e>
    1d60:	e0d2                	sd	s4,64(sp)
    1d62:	fc56                	sd	s5,56(sp)
    1d64:	f85a                	sd	s6,48(sp)
    1d66:	f45e                	sd	s7,40(sp)
    1d68:	f062                	sd	s8,32(sp)
    1d6a:	e86a                	sd	s10,16(sp)
  exit(0);
    1d6c:	2be030ef          	jal	502a <exit>
    1d70:	e0d2                	sd	s4,64(sp)
    1d72:	fc56                	sd	s5,56(sp)
    1d74:	f85a                	sd	s6,48(sp)
    1d76:	f45e                	sd	s7,40(sp)
    1d78:	f062                	sd	s8,32(sp)
    1d7a:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1d7c:	00005517          	auipc	a0,0x5
    1d80:	76450513          	addi	a0,a0,1892 # 74e0 <malloc+0x1f94>
    1d84:	70c030ef          	jal	5490 <printf>
      exit(1);
    1d88:	4505                	li	a0,1
    1d8a:	2a0030ef          	jal	502a <exit>
    1d8e:	e0d2                	sd	s4,64(sp)
    1d90:	fc56                	sd	s5,56(sp)
    1d92:	f85a                	sd	s6,48(sp)
    1d94:	f45e                	sd	s7,40(sp)
    1d96:	f062                	sd	s8,32(sp)
    1d98:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1d9a:	06200793          	li	a5,98
    1d9e:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1da2:	0619079b          	addiw	a5,s2,97
    1da6:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1daa:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1dae:	f9840513          	addi	a0,s0,-104
    1db2:	2c8030ef          	jal	507a <unlink>
    1db6:	47f9                	li	a5,30
    1db8:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1dba:	f9840b93          	addi	s7,s0,-104
    1dbe:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1dc2:	6a8d                	lui	s5,0x3
    1dc4:	0000ac17          	auipc	s8,0xa
    1dc8:	ef4c0c13          	addi	s8,s8,-268 # bcb8 <buf>
        for (int i = 0; i < ci + 1; i++) {
    1dcc:	8a26                	mv	s4,s1
    1dce:	02094563          	bltz	s2,1df8 <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1dd2:	85da                	mv	a1,s6
    1dd4:	855e                	mv	a0,s7
    1dd6:	294030ef          	jal	506a <open>
    1dda:	89aa                	mv	s3,a0
          if (fd < 0) {
    1ddc:	02054d63          	bltz	a0,1e16 <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1de0:	8656                	mv	a2,s5
    1de2:	85e2                	mv	a1,s8
    1de4:	266030ef          	jal	504a <write>
          if (cc != sz) {
    1de8:	05551363          	bne	a0,s5,1e2e <manywrites+0x112>
          close(fd);
    1dec:	854e                	mv	a0,s3
    1dee:	264030ef          	jal	5052 <close>
        for (int i = 0; i < ci + 1; i++) {
    1df2:	2a05                	addiw	s4,s4,1
    1df4:	fd495fe3          	bge	s2,s4,1dd2 <manywrites+0xb6>
        unlink(name);
    1df8:	f9840513          	addi	a0,s0,-104
    1dfc:	27e030ef          	jal	507a <unlink>
      for (int iters = 0; iters < howmany; iters++) {
    1e00:	fffd079b          	addiw	a5,s10,-1
    1e04:	8d3e                	mv	s10,a5
    1e06:	f3f9                	bnez	a5,1dcc <manywrites+0xb0>
      unlink(name);
    1e08:	f9840513          	addi	a0,s0,-104
    1e0c:	26e030ef          	jal	507a <unlink>
      exit(0);
    1e10:	4501                	li	a0,0
    1e12:	218030ef          	jal	502a <exit>
            printf("%s: cannot create %s\n", s, name);
    1e16:	f9840613          	addi	a2,s0,-104
    1e1a:	85e6                	mv	a1,s9
    1e1c:	00004517          	auipc	a0,0x4
    1e20:	3d450513          	addi	a0,a0,980 # 61f0 <malloc+0xca4>
    1e24:	66c030ef          	jal	5490 <printf>
            exit(1);
    1e28:	4505                	li	a0,1
    1e2a:	200030ef          	jal	502a <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1e2e:	86aa                	mv	a3,a0
    1e30:	660d                	lui	a2,0x3
    1e32:	85e6                	mv	a1,s9
    1e34:	00004517          	auipc	a0,0x4
    1e38:	91450513          	addi	a0,a0,-1772 # 5748 <malloc+0x1fc>
    1e3c:	654030ef          	jal	5490 <printf>
            exit(1);
    1e40:	4505                	li	a0,1
    1e42:	1e8030ef          	jal	502a <exit>
    1e46:	e0d2                	sd	s4,64(sp)
    1e48:	fc56                	sd	s5,56(sp)
    1e4a:	f85a                	sd	s6,48(sp)
    1e4c:	f45e                	sd	s7,40(sp)
    1e4e:	f062                	sd	s8,32(sp)
    1e50:	e86a                	sd	s10,16(sp)
      exit(st);
    1e52:	1d8030ef          	jal	502a <exit>

0000000000001e56 <copyinstr3>:
{
    1e56:	7179                	addi	sp,sp,-48
    1e58:	f406                	sd	ra,40(sp)
    1e5a:	f022                	sd	s0,32(sp)
    1e5c:	ec26                	sd	s1,24(sp)
    1e5e:	1800                	addi	s0,sp,48
  sbrk(8192);
    1e60:	6509                	lui	a0,0x2
    1e62:	194030ef          	jal	4ff6 <sbrk>
  uint64 top = (uint64)sbrk(0);
    1e66:	4501                	li	a0,0
    1e68:	18e030ef          	jal	4ff6 <sbrk>
  if ((top % PGSIZE) != 0) {
    1e6c:	03451793          	slli	a5,a0,0x34
    1e70:	e7bd                	bnez	a5,1ede <copyinstr3+0x88>
  top = (uint64)sbrk(0);
    1e72:	4501                	li	a0,0
    1e74:	182030ef          	jal	4ff6 <sbrk>
  if (top % PGSIZE) {
    1e78:	03451793          	slli	a5,a0,0x34
    1e7c:	ebad                	bnez	a5,1eee <copyinstr3+0x98>
  char *b = (char *)(top - 1);
    1e7e:	fff50493          	addi	s1,a0,-1 # 1fff <rwsbrk+0xa5>
  *b = 'x';
    1e82:	07800793          	li	a5,120
    1e86:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    1e8a:	8526                	mv	a0,s1
    1e8c:	1ee030ef          	jal	507a <unlink>
  if (ret != -1) {
    1e90:	57fd                	li	a5,-1
    1e92:	06f51763          	bne	a0,a5,1f00 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    1e96:	20100593          	li	a1,513
    1e9a:	8526                	mv	a0,s1
    1e9c:	1ce030ef          	jal	506a <open>
  if (fd != -1) {
    1ea0:	57fd                	li	a5,-1
    1ea2:	06f51a63          	bne	a0,a5,1f16 <copyinstr3+0xc0>
  ret = link(b, b);
    1ea6:	85a6                	mv	a1,s1
    1ea8:	8526                	mv	a0,s1
    1eaa:	1e0030ef          	jal	508a <link>
  if (ret != -1) {
    1eae:	57fd                	li	a5,-1
    1eb0:	06f51e63          	bne	a0,a5,1f2c <copyinstr3+0xd6>
  char *args[] = {"xx", 0};
    1eb4:	00005797          	auipc	a5,0x5
    1eb8:	03c78793          	addi	a5,a5,60 # 6ef0 <malloc+0x19a4>
    1ebc:	fcf43823          	sd	a5,-48(s0)
    1ec0:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    1ec4:	fd040593          	addi	a1,s0,-48
    1ec8:	8526                	mv	a0,s1
    1eca:	198030ef          	jal	5062 <exec>
  if (ret != -1) {
    1ece:	57fd                	li	a5,-1
    1ed0:	06f51a63          	bne	a0,a5,1f44 <copyinstr3+0xee>
}
    1ed4:	70a2                	ld	ra,40(sp)
    1ed6:	7402                	ld	s0,32(sp)
    1ed8:	64e2                	ld	s1,24(sp)
    1eda:	6145                	addi	sp,sp,48
    1edc:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    1ede:	0347d513          	srli	a0,a5,0x34
    1ee2:	6785                	lui	a5,0x1
    1ee4:	40a7853b          	subw	a0,a5,a0
    1ee8:	10e030ef          	jal	4ff6 <sbrk>
    1eec:	b759                	j	1e72 <copyinstr3+0x1c>
    printf("oops\n");
    1eee:	00004517          	auipc	a0,0x4
    1ef2:	31a50513          	addi	a0,a0,794 # 6208 <malloc+0xcbc>
    1ef6:	59a030ef          	jal	5490 <printf>
    exit(1);
    1efa:	4505                	li	a0,1
    1efc:	12e030ef          	jal	502a <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1f00:	862a                	mv	a2,a0
    1f02:	85a6                	mv	a1,s1
    1f04:	00004517          	auipc	a0,0x4
    1f08:	f2450513          	addi	a0,a0,-220 # 5e28 <malloc+0x8dc>
    1f0c:	584030ef          	jal	5490 <printf>
    exit(1);
    1f10:	4505                	li	a0,1
    1f12:	118030ef          	jal	502a <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    1f16:	862a                	mv	a2,a0
    1f18:	85a6                	mv	a1,s1
    1f1a:	00004517          	auipc	a0,0x4
    1f1e:	f2e50513          	addi	a0,a0,-210 # 5e48 <malloc+0x8fc>
    1f22:	56e030ef          	jal	5490 <printf>
    exit(1);
    1f26:	4505                	li	a0,1
    1f28:	102030ef          	jal	502a <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    1f2c:	86aa                	mv	a3,a0
    1f2e:	8626                	mv	a2,s1
    1f30:	85a6                	mv	a1,s1
    1f32:	00004517          	auipc	a0,0x4
    1f36:	f3650513          	addi	a0,a0,-202 # 5e68 <malloc+0x91c>
    1f3a:	556030ef          	jal	5490 <printf>
    exit(1);
    1f3e:	4505                	li	a0,1
    1f40:	0ea030ef          	jal	502a <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    1f44:	863e                	mv	a2,a5
    1f46:	85a6                	mv	a1,s1
    1f48:	00004517          	auipc	a0,0x4
    1f4c:	f4850513          	addi	a0,a0,-184 # 5e90 <malloc+0x944>
    1f50:	540030ef          	jal	5490 <printf>
    exit(1);
    1f54:	4505                	li	a0,1
    1f56:	0d4030ef          	jal	502a <exit>

0000000000001f5a <rwsbrk>:
{
    1f5a:	1101                	addi	sp,sp,-32
    1f5c:	ec06                	sd	ra,24(sp)
    1f5e:	e822                	sd	s0,16(sp)
    1f60:	1000                	addi	s0,sp,32
  uint64 a = (uint64)sbrk(8192);
    1f62:	6509                	lui	a0,0x2
    1f64:	092030ef          	jal	4ff6 <sbrk>
  if (a == (uint64)SBRK_ERROR) {
    1f68:	57fd                	li	a5,-1
    1f6a:	04f50a63          	beq	a0,a5,1fbe <rwsbrk+0x64>
    1f6e:	e426                	sd	s1,8(sp)
    1f70:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    1f72:	7579                	lui	a0,0xffffe
    1f74:	082030ef          	jal	4ff6 <sbrk>
    1f78:	57fd                	li	a5,-1
    1f7a:	04f50d63          	beq	a0,a5,1fd4 <rwsbrk+0x7a>
    1f7e:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE | O_WRONLY);
    1f80:	20100593          	li	a1,513
    1f84:	00004517          	auipc	a0,0x4
    1f88:	2c450513          	addi	a0,a0,708 # 6248 <malloc+0xcfc>
    1f8c:	0de030ef          	jal	506a <open>
    1f90:	892a                	mv	s2,a0
  if (fd < 0) {
    1f92:	04054b63          	bltz	a0,1fe8 <rwsbrk+0x8e>
  n = write(fd, (void *)(a + PGSIZE), 1024);
    1f96:	6785                	lui	a5,0x1
    1f98:	94be                	add	s1,s1,a5
    1f9a:	40000613          	li	a2,1024
    1f9e:	85a6                	mv	a1,s1
    1fa0:	0aa030ef          	jal	504a <write>
    1fa4:	862a                	mv	a2,a0
  if (n >= 0) {
    1fa6:	04054a63          	bltz	a0,1ffa <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void *)a + PGSIZE, n);
    1faa:	85a6                	mv	a1,s1
    1fac:	00004517          	auipc	a0,0x4
    1fb0:	2bc50513          	addi	a0,a0,700 # 6268 <malloc+0xd1c>
    1fb4:	4dc030ef          	jal	5490 <printf>
    exit(1);
    1fb8:	4505                	li	a0,1
    1fba:	070030ef          	jal	502a <exit>
    1fbe:	e426                	sd	s1,8(sp)
    1fc0:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    1fc2:	00004517          	auipc	a0,0x4
    1fc6:	24e50513          	addi	a0,a0,590 # 6210 <malloc+0xcc4>
    1fca:	4c6030ef          	jal	5490 <printf>
    exit(1);
    1fce:	4505                	li	a0,1
    1fd0:	05a030ef          	jal	502a <exit>
    1fd4:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    1fd6:	00004517          	auipc	a0,0x4
    1fda:	25250513          	addi	a0,a0,594 # 6228 <malloc+0xcdc>
    1fde:	4b2030ef          	jal	5490 <printf>
    exit(1);
    1fe2:	4505                	li	a0,1
    1fe4:	046030ef          	jal	502a <exit>
    printf("open(rwsbrk) failed\n");
    1fe8:	00004517          	auipc	a0,0x4
    1fec:	26850513          	addi	a0,a0,616 # 6250 <malloc+0xd04>
    1ff0:	4a0030ef          	jal	5490 <printf>
    exit(1);
    1ff4:	4505                	li	a0,1
    1ff6:	034030ef          	jal	502a <exit>
  close(fd);
    1ffa:	854a                	mv	a0,s2
    1ffc:	056030ef          	jal	5052 <close>
  unlink("rwsbrk");
    2000:	00004517          	auipc	a0,0x4
    2004:	24850513          	addi	a0,a0,584 # 6248 <malloc+0xcfc>
    2008:	072030ef          	jal	507a <unlink>
  fd = open("README", O_RDONLY);
    200c:	4581                	li	a1,0
    200e:	00004517          	auipc	a0,0x4
    2012:	84250513          	addi	a0,a0,-1982 # 5850 <malloc+0x304>
    2016:	054030ef          	jal	506a <open>
    201a:	892a                	mv	s2,a0
  if (fd < 0) {
    201c:	02054363          	bltz	a0,2042 <rwsbrk+0xe8>
  n = read(fd, (void *)(a + PGSIZE), 10);
    2020:	4629                	li	a2,10
    2022:	85a6                	mv	a1,s1
    2024:	01e030ef          	jal	5042 <read>
    2028:	862a                	mv	a2,a0
  if (n >= 0) {
    202a:	02054563          	bltz	a0,2054 <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void *)a + PGSIZE, n);
    202e:	85a6                	mv	a1,s1
    2030:	00004517          	auipc	a0,0x4
    2034:	26850513          	addi	a0,a0,616 # 6298 <malloc+0xd4c>
    2038:	458030ef          	jal	5490 <printf>
    exit(1);
    203c:	4505                	li	a0,1
    203e:	7ed020ef          	jal	502a <exit>
    printf("open(README) failed\n");
    2042:	00004517          	auipc	a0,0x4
    2046:	81650513          	addi	a0,a0,-2026 # 5858 <malloc+0x30c>
    204a:	446030ef          	jal	5490 <printf>
    exit(1);
    204e:	4505                	li	a0,1
    2050:	7db020ef          	jal	502a <exit>
  close(fd);
    2054:	854a                	mv	a0,s2
    2056:	7fd020ef          	jal	5052 <close>
  exit(0);
    205a:	4501                	li	a0,0
    205c:	7cf020ef          	jal	502a <exit>

0000000000002060 <sbrkbasic>:
{
    2060:	715d                	addi	sp,sp,-80
    2062:	e486                	sd	ra,72(sp)
    2064:	e0a2                	sd	s0,64(sp)
    2066:	ec56                	sd	s5,24(sp)
    2068:	0880                	addi	s0,sp,80
    206a:	8aaa                	mv	s5,a0
  pid = fork();
    206c:	7b7020ef          	jal	5022 <fork>
  if (pid < 0) {
    2070:	02054c63          	bltz	a0,20a8 <sbrkbasic+0x48>
  if (pid == 0) {
    2074:	ed31                	bnez	a0,20d0 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    2076:	40000537          	lui	a0,0x40000
    207a:	77d020ef          	jal	4ff6 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    207e:	57fd                	li	a5,-1
    2080:	04f50163          	beq	a0,a5,20c2 <sbrkbasic+0x62>
    2084:	fc26                	sd	s1,56(sp)
    2086:	f84a                	sd	s2,48(sp)
    2088:	f44e                	sd	s3,40(sp)
    208a:	f052                	sd	s4,32(sp)
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    208c:	400007b7          	lui	a5,0x40000
    2090:	97aa                	add	a5,a5,a0
      *b = 99;
    2092:	06300693          	li	a3,99
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    2096:	6705                	lui	a4,0x1
      *b = 99;
    2098:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1348>
    for (b = a; b < a + TOOMUCH; b += PGSIZE) {
    209c:	953a                	add	a0,a0,a4
    209e:	fef51de3          	bne	a0,a5,2098 <sbrkbasic+0x38>
    exit(1);
    20a2:	4505                	li	a0,1
    20a4:	787020ef          	jal	502a <exit>
    20a8:	fc26                	sd	s1,56(sp)
    20aa:	f84a                	sd	s2,48(sp)
    20ac:	f44e                	sd	s3,40(sp)
    20ae:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    20b0:	00004517          	auipc	a0,0x4
    20b4:	21050513          	addi	a0,a0,528 # 62c0 <malloc+0xd74>
    20b8:	3d8030ef          	jal	5490 <printf>
    exit(1);
    20bc:	4505                	li	a0,1
    20be:	76d020ef          	jal	502a <exit>
    20c2:	fc26                	sd	s1,56(sp)
    20c4:	f84a                	sd	s2,48(sp)
    20c6:	f44e                	sd	s3,40(sp)
    20c8:	f052                	sd	s4,32(sp)
      exit(0);
    20ca:	4501                	li	a0,0
    20cc:	75f020ef          	jal	502a <exit>
  wait(&xstatus);
    20d0:	fbc40513          	addi	a0,s0,-68
    20d4:	75f020ef          	jal	5032 <wait>
  if (xstatus == 1) {
    20d8:	fbc42703          	lw	a4,-68(s0)
    20dc:	4785                	li	a5,1
    20de:	02f70063          	beq	a4,a5,20fe <sbrkbasic+0x9e>
    20e2:	fc26                	sd	s1,56(sp)
    20e4:	f84a                	sd	s2,48(sp)
    20e6:	f44e                	sd	s3,40(sp)
    20e8:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    20ea:	4501                	li	a0,0
    20ec:	70b020ef          	jal	4ff6 <sbrk>
    20f0:	84aa                	mv	s1,a0
  for (i = 0; i < 5000; i++) {
    20f2:	4901                	li	s2,0
    b = sbrk(1);
    20f4:	4985                	li	s3,1
  for (i = 0; i < 5000; i++) {
    20f6:	6a05                	lui	s4,0x1
    20f8:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x14a>
    20fc:	a005                	j	211c <sbrkbasic+0xbc>
    20fe:	fc26                	sd	s1,56(sp)
    2100:	f84a                	sd	s2,48(sp)
    2102:	f44e                	sd	s3,40(sp)
    2104:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    2106:	85d6                	mv	a1,s5
    2108:	00004517          	auipc	a0,0x4
    210c:	1d850513          	addi	a0,a0,472 # 62e0 <malloc+0xd94>
    2110:	380030ef          	jal	5490 <printf>
    exit(1);
    2114:	4505                	li	a0,1
    2116:	715020ef          	jal	502a <exit>
  for (i = 0; i < 5000; i++) {
    211a:	84be                	mv	s1,a5
    b = sbrk(1);
    211c:	854e                	mv	a0,s3
    211e:	6d9020ef          	jal	4ff6 <sbrk>
    if (b != a) {
    2122:	04951163          	bne	a0,s1,2164 <sbrkbasic+0x104>
    *b = 1;
    2126:	01348023          	sb	s3,0(s1)
    a = b + 1;
    212a:	00148793          	addi	a5,s1,1
  for (i = 0; i < 5000; i++) {
    212e:	2905                	addiw	s2,s2,1
    2130:	ff4915e3          	bne	s2,s4,211a <sbrkbasic+0xba>
  pid = fork();
    2134:	6ef020ef          	jal	5022 <fork>
    2138:	892a                	mv	s2,a0
  if (pid < 0) {
    213a:	04054263          	bltz	a0,217e <sbrkbasic+0x11e>
  c = sbrk(1);
    213e:	4505                	li	a0,1
    2140:	6b7020ef          	jal	4ff6 <sbrk>
  c = sbrk(1);
    2144:	4505                	li	a0,1
    2146:	6b1020ef          	jal	4ff6 <sbrk>
  if (c != a + 1) {
    214a:	0489                	addi	s1,s1,2
    214c:	04950363          	beq	a0,s1,2192 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    2150:	85d6                	mv	a1,s5
    2152:	00004517          	auipc	a0,0x4
    2156:	1ee50513          	addi	a0,a0,494 # 6340 <malloc+0xdf4>
    215a:	336030ef          	jal	5490 <printf>
    exit(1);
    215e:	4505                	li	a0,1
    2160:	6cb020ef          	jal	502a <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    2164:	872a                	mv	a4,a0
    2166:	86a6                	mv	a3,s1
    2168:	864a                	mv	a2,s2
    216a:	85d6                	mv	a1,s5
    216c:	00004517          	auipc	a0,0x4
    2170:	19450513          	addi	a0,a0,404 # 6300 <malloc+0xdb4>
    2174:	31c030ef          	jal	5490 <printf>
      exit(1);
    2178:	4505                	li	a0,1
    217a:	6b1020ef          	jal	502a <exit>
    printf("%s: sbrk test fork failed\n", s);
    217e:	85d6                	mv	a1,s5
    2180:	00004517          	auipc	a0,0x4
    2184:	1a050513          	addi	a0,a0,416 # 6320 <malloc+0xdd4>
    2188:	308030ef          	jal	5490 <printf>
    exit(1);
    218c:	4505                	li	a0,1
    218e:	69d020ef          	jal	502a <exit>
  if (pid == 0)
    2192:	00091563          	bnez	s2,219c <sbrkbasic+0x13c>
    exit(0);
    2196:	4501                	li	a0,0
    2198:	693020ef          	jal	502a <exit>
  wait(&xstatus);
    219c:	fbc40513          	addi	a0,s0,-68
    21a0:	693020ef          	jal	5032 <wait>
  exit(xstatus);
    21a4:	fbc42503          	lw	a0,-68(s0)
    21a8:	683020ef          	jal	502a <exit>

00000000000021ac <sbrkmuch>:
{
    21ac:	7179                	addi	sp,sp,-48
    21ae:	f406                	sd	ra,40(sp)
    21b0:	f022                	sd	s0,32(sp)
    21b2:	ec26                	sd	s1,24(sp)
    21b4:	e84a                	sd	s2,16(sp)
    21b6:	e44e                	sd	s3,8(sp)
    21b8:	e052                	sd	s4,0(sp)
    21ba:	1800                	addi	s0,sp,48
    21bc:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    21be:	4501                	li	a0,0
    21c0:	637020ef          	jal	4ff6 <sbrk>
    21c4:	892a                	mv	s2,a0
  a = sbrk(0);
    21c6:	4501                	li	a0,0
    21c8:	62f020ef          	jal	4ff6 <sbrk>
    21cc:	84aa                	mv	s1,a0
  p = sbrk(amt);
    21ce:	06400537          	lui	a0,0x6400
    21d2:	9d05                	subw	a0,a0,s1
    21d4:	623020ef          	jal	4ff6 <sbrk>
  if (p != a) {
    21d8:	08a49763          	bne	s1,a0,2266 <sbrkmuch+0xba>
  *lastaddr = 99;
    21dc:	064007b7          	lui	a5,0x6400
    21e0:	06300713          	li	a4,99
    21e4:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1347>
  a = sbrk(0);
    21e8:	4501                	li	a0,0
    21ea:	60d020ef          	jal	4ff6 <sbrk>
    21ee:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    21f0:	757d                	lui	a0,0xfffff
    21f2:	605020ef          	jal	4ff6 <sbrk>
  if (c == (char *)SBRK_ERROR) {
    21f6:	57fd                	li	a5,-1
    21f8:	08f50163          	beq	a0,a5,227a <sbrkmuch+0xce>
  c = sbrk(0);
    21fc:	4501                	li	a0,0
    21fe:	5f9020ef          	jal	4ff6 <sbrk>
  if (c != a - PGSIZE) {
    2202:	77fd                	lui	a5,0xfffff
    2204:	97a6                	add	a5,a5,s1
    2206:	08f51463          	bne	a0,a5,228e <sbrkmuch+0xe2>
  a = sbrk(0);
    220a:	4501                	li	a0,0
    220c:	5eb020ef          	jal	4ff6 <sbrk>
    2210:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    2212:	6505                	lui	a0,0x1
    2214:	5e3020ef          	jal	4ff6 <sbrk>
    2218:	8a2a                	mv	s4,a0
  if (c != a || sbrk(0) != a + PGSIZE) {
    221a:	08a49663          	bne	s1,a0,22a6 <sbrkmuch+0xfa>
    221e:	4501                	li	a0,0
    2220:	5d7020ef          	jal	4ff6 <sbrk>
    2224:	6785                	lui	a5,0x1
    2226:	97a6                	add	a5,a5,s1
    2228:	06f51f63          	bne	a0,a5,22a6 <sbrkmuch+0xfa>
  if (*lastaddr == 99) {
    222c:	064007b7          	lui	a5,0x6400
    2230:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1347>
    2234:	06300793          	li	a5,99
    2238:	08f70363          	beq	a4,a5,22be <sbrkmuch+0x112>
  a = sbrk(0);
    223c:	4501                	li	a0,0
    223e:	5b9020ef          	jal	4ff6 <sbrk>
    2242:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    2244:	4501                	li	a0,0
    2246:	5b1020ef          	jal	4ff6 <sbrk>
    224a:	40a9053b          	subw	a0,s2,a0
    224e:	5a9020ef          	jal	4ff6 <sbrk>
  if (c != a) {
    2252:	08a49063          	bne	s1,a0,22d2 <sbrkmuch+0x126>
}
    2256:	70a2                	ld	ra,40(sp)
    2258:	7402                	ld	s0,32(sp)
    225a:	64e2                	ld	s1,24(sp)
    225c:	6942                	ld	s2,16(sp)
    225e:	69a2                	ld	s3,8(sp)
    2260:	6a02                	ld	s4,0(sp)
    2262:	6145                	addi	sp,sp,48
    2264:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n",
    2266:	85ce                	mv	a1,s3
    2268:	00004517          	auipc	a0,0x4
    226c:	0f850513          	addi	a0,a0,248 # 6360 <malloc+0xe14>
    2270:	220030ef          	jal	5490 <printf>
    exit(1);
    2274:	4505                	li	a0,1
    2276:	5b5020ef          	jal	502a <exit>
    printf("%s: sbrk could not deallocate\n", s);
    227a:	85ce                	mv	a1,s3
    227c:	00004517          	auipc	a0,0x4
    2280:	12c50513          	addi	a0,a0,300 # 63a8 <malloc+0xe5c>
    2284:	20c030ef          	jal	5490 <printf>
    exit(1);
    2288:	4505                	li	a0,1
    228a:	5a1020ef          	jal	502a <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a,
    228e:	86aa                	mv	a3,a0
    2290:	8626                	mv	a2,s1
    2292:	85ce                	mv	a1,s3
    2294:	00004517          	auipc	a0,0x4
    2298:	13450513          	addi	a0,a0,308 # 63c8 <malloc+0xe7c>
    229c:	1f4030ef          	jal	5490 <printf>
    exit(1);
    22a0:	4505                	li	a0,1
    22a2:	589020ef          	jal	502a <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    22a6:	86d2                	mv	a3,s4
    22a8:	8626                	mv	a2,s1
    22aa:	85ce                	mv	a1,s3
    22ac:	00004517          	auipc	a0,0x4
    22b0:	15c50513          	addi	a0,a0,348 # 6408 <malloc+0xebc>
    22b4:	1dc030ef          	jal	5490 <printf>
    exit(1);
    22b8:	4505                	li	a0,1
    22ba:	571020ef          	jal	502a <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    22be:	85ce                	mv	a1,s3
    22c0:	00004517          	auipc	a0,0x4
    22c4:	17850513          	addi	a0,a0,376 # 6438 <malloc+0xeec>
    22c8:	1c8030ef          	jal	5490 <printf>
    exit(1);
    22cc:	4505                	li	a0,1
    22ce:	55d020ef          	jal	502a <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    22d2:	86aa                	mv	a3,a0
    22d4:	8626                	mv	a2,s1
    22d6:	85ce                	mv	a1,s3
    22d8:	00004517          	auipc	a0,0x4
    22dc:	19850513          	addi	a0,a0,408 # 6470 <malloc+0xf24>
    22e0:	1b0030ef          	jal	5490 <printf>
    exit(1);
    22e4:	4505                	li	a0,1
    22e6:	545020ef          	jal	502a <exit>

00000000000022ea <sbrkarg>:
{
    22ea:	7179                	addi	sp,sp,-48
    22ec:	f406                	sd	ra,40(sp)
    22ee:	f022                	sd	s0,32(sp)
    22f0:	ec26                	sd	s1,24(sp)
    22f2:	e84a                	sd	s2,16(sp)
    22f4:	e44e                	sd	s3,8(sp)
    22f6:	1800                	addi	s0,sp,48
    22f8:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    22fa:	6505                	lui	a0,0x1
    22fc:	4fb020ef          	jal	4ff6 <sbrk>
    2300:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE | O_WRONLY);
    2302:	20100593          	li	a1,513
    2306:	00004517          	auipc	a0,0x4
    230a:	19250513          	addi	a0,a0,402 # 6498 <malloc+0xf4c>
    230e:	55d020ef          	jal	506a <open>
    2312:	84aa                	mv	s1,a0
  unlink("sbrk");
    2314:	00004517          	auipc	a0,0x4
    2318:	18450513          	addi	a0,a0,388 # 6498 <malloc+0xf4c>
    231c:	55f020ef          	jal	507a <unlink>
  if (fd < 0) {
    2320:	0204c963          	bltz	s1,2352 <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    2324:	6605                	lui	a2,0x1
    2326:	85ca                	mv	a1,s2
    2328:	8526                	mv	a0,s1
    232a:	521020ef          	jal	504a <write>
    232e:	02054c63          	bltz	a0,2366 <sbrkarg+0x7c>
  close(fd);
    2332:	8526                	mv	a0,s1
    2334:	51f020ef          	jal	5052 <close>
  a = sbrk(PGSIZE);
    2338:	6505                	lui	a0,0x1
    233a:	4bd020ef          	jal	4ff6 <sbrk>
  if (pipe((int *)a) != 0) {
    233e:	4fd020ef          	jal	503a <pipe>
    2342:	ed05                	bnez	a0,237a <sbrkarg+0x90>
}
    2344:	70a2                	ld	ra,40(sp)
    2346:	7402                	ld	s0,32(sp)
    2348:	64e2                	ld	s1,24(sp)
    234a:	6942                	ld	s2,16(sp)
    234c:	69a2                	ld	s3,8(sp)
    234e:	6145                	addi	sp,sp,48
    2350:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    2352:	85ce                	mv	a1,s3
    2354:	00004517          	auipc	a0,0x4
    2358:	14c50513          	addi	a0,a0,332 # 64a0 <malloc+0xf54>
    235c:	134030ef          	jal	5490 <printf>
    exit(1);
    2360:	4505                	li	a0,1
    2362:	4c9020ef          	jal	502a <exit>
    printf("%s: write sbrk failed\n", s);
    2366:	85ce                	mv	a1,s3
    2368:	00004517          	auipc	a0,0x4
    236c:	15050513          	addi	a0,a0,336 # 64b8 <malloc+0xf6c>
    2370:	120030ef          	jal	5490 <printf>
    exit(1);
    2374:	4505                	li	a0,1
    2376:	4b5020ef          	jal	502a <exit>
    printf("%s: pipe() failed\n", s);
    237a:	85ce                	mv	a1,s3
    237c:	00004517          	auipc	a0,0x4
    2380:	c1450513          	addi	a0,a0,-1004 # 5f90 <malloc+0xa44>
    2384:	10c030ef          	jal	5490 <printf>
    exit(1);
    2388:	4505                	li	a0,1
    238a:	4a1020ef          	jal	502a <exit>

000000000000238e <argptest>:
{
    238e:	1101                	addi	sp,sp,-32
    2390:	ec06                	sd	ra,24(sp)
    2392:	e822                	sd	s0,16(sp)
    2394:	e426                	sd	s1,8(sp)
    2396:	e04a                	sd	s2,0(sp)
    2398:	1000                	addi	s0,sp,32
    239a:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    239c:	4581                	li	a1,0
    239e:	00004517          	auipc	a0,0x4
    23a2:	13250513          	addi	a0,a0,306 # 64d0 <malloc+0xf84>
    23a6:	4c5020ef          	jal	506a <open>
  if (fd < 0) {
    23aa:	02054563          	bltz	a0,23d4 <argptest+0x46>
    23ae:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    23b0:	4501                	li	a0,0
    23b2:	445020ef          	jal	4ff6 <sbrk>
    23b6:	567d                	li	a2,-1
    23b8:	00c505b3          	add	a1,a0,a2
    23bc:	8526                	mv	a0,s1
    23be:	485020ef          	jal	5042 <read>
  close(fd);
    23c2:	8526                	mv	a0,s1
    23c4:	48f020ef          	jal	5052 <close>
}
    23c8:	60e2                	ld	ra,24(sp)
    23ca:	6442                	ld	s0,16(sp)
    23cc:	64a2                	ld	s1,8(sp)
    23ce:	6902                	ld	s2,0(sp)
    23d0:	6105                	addi	sp,sp,32
    23d2:	8082                	ret
    printf("%s: open failed\n", s);
    23d4:	85ca                	mv	a1,s2
    23d6:	00004517          	auipc	a0,0x4
    23da:	b4a50513          	addi	a0,a0,-1206 # 5f20 <malloc+0x9d4>
    23de:	0b2030ef          	jal	5490 <printf>
    exit(1);
    23e2:	4505                	li	a0,1
    23e4:	447020ef          	jal	502a <exit>

00000000000023e8 <sbrkbugs>:
{
    23e8:	1141                	addi	sp,sp,-16
    23ea:	e406                	sd	ra,8(sp)
    23ec:	e022                	sd	s0,0(sp)
    23ee:	0800                	addi	s0,sp,16
  int pid = fork();
    23f0:	433020ef          	jal	5022 <fork>
  if (pid < 0) {
    23f4:	00054c63          	bltz	a0,240c <sbrkbugs+0x24>
  if (pid == 0) {
    23f8:	e11d                	bnez	a0,241e <sbrkbugs+0x36>
    int sz = (uint64)sbrk(0);
    23fa:	3fd020ef          	jal	4ff6 <sbrk>
    sbrk(-sz);
    23fe:	40a0053b          	negw	a0,a0
    2402:	3f5020ef          	jal	4ff6 <sbrk>
    exit(0);
    2406:	4501                	li	a0,0
    2408:	423020ef          	jal	502a <exit>
    printf("fork failed\n");
    240c:	00005517          	auipc	a0,0x5
    2410:	0d450513          	addi	a0,a0,212 # 74e0 <malloc+0x1f94>
    2414:	07c030ef          	jal	5490 <printf>
    exit(1);
    2418:	4505                	li	a0,1
    241a:	411020ef          	jal	502a <exit>
  wait(0);
    241e:	4501                	li	a0,0
    2420:	413020ef          	jal	5032 <wait>
  pid = fork();
    2424:	3ff020ef          	jal	5022 <fork>
  if (pid < 0) {
    2428:	00054f63          	bltz	a0,2446 <sbrkbugs+0x5e>
  if (pid == 0) {
    242c:	e515                	bnez	a0,2458 <sbrkbugs+0x70>
    int sz = (uint64)sbrk(0);
    242e:	3c9020ef          	jal	4ff6 <sbrk>
    sbrk(-(sz - 3500));
    2432:	6785                	lui	a5,0x1
    2434:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xe2>
    2438:	40a7853b          	subw	a0,a5,a0
    243c:	3bb020ef          	jal	4ff6 <sbrk>
    exit(0);
    2440:	4501                	li	a0,0
    2442:	3e9020ef          	jal	502a <exit>
    printf("fork failed\n");
    2446:	00005517          	auipc	a0,0x5
    244a:	09a50513          	addi	a0,a0,154 # 74e0 <malloc+0x1f94>
    244e:	042030ef          	jal	5490 <printf>
    exit(1);
    2452:	4505                	li	a0,1
    2454:	3d7020ef          	jal	502a <exit>
  wait(0);
    2458:	4501                	li	a0,0
    245a:	3d9020ef          	jal	5032 <wait>
  pid = fork();
    245e:	3c5020ef          	jal	5022 <fork>
  if (pid < 0) {
    2462:	02054263          	bltz	a0,2486 <sbrkbugs+0x9e>
  if (pid == 0) {
    2466:	e90d                	bnez	a0,2498 <sbrkbugs+0xb0>
    sbrk((10 * PGSIZE + 2048) - (uint64)sbrk(0));
    2468:	38f020ef          	jal	4ff6 <sbrk>
    246c:	67ad                	lui	a5,0xb
    246e:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1258>
    2472:	40a7853b          	subw	a0,a5,a0
    2476:	381020ef          	jal	4ff6 <sbrk>
    sbrk(-10);
    247a:	5559                	li	a0,-10
    247c:	37b020ef          	jal	4ff6 <sbrk>
    exit(0);
    2480:	4501                	li	a0,0
    2482:	3a9020ef          	jal	502a <exit>
    printf("fork failed\n");
    2486:	00005517          	auipc	a0,0x5
    248a:	05a50513          	addi	a0,a0,90 # 74e0 <malloc+0x1f94>
    248e:	002030ef          	jal	5490 <printf>
    exit(1);
    2492:	4505                	li	a0,1
    2494:	397020ef          	jal	502a <exit>
  wait(0);
    2498:	4501                	li	a0,0
    249a:	399020ef          	jal	5032 <wait>
  exit(0);
    249e:	4501                	li	a0,0
    24a0:	38b020ef          	jal	502a <exit>

00000000000024a4 <sbrklast>:
{
    24a4:	7179                	addi	sp,sp,-48
    24a6:	f406                	sd	ra,40(sp)
    24a8:	f022                	sd	s0,32(sp)
    24aa:	ec26                	sd	s1,24(sp)
    24ac:	e84a                	sd	s2,16(sp)
    24ae:	e44e                	sd	s3,8(sp)
    24b0:	e052                	sd	s4,0(sp)
    24b2:	1800                	addi	s0,sp,48
  uint64 top = (uint64)sbrk(0);
    24b4:	4501                	li	a0,0
    24b6:	341020ef          	jal	4ff6 <sbrk>
  if ((top % PGSIZE) != 0)
    24ba:	03451793          	slli	a5,a0,0x34
    24be:	ebad                	bnez	a5,2530 <sbrklast+0x8c>
  sbrk(PGSIZE);
    24c0:	6505                	lui	a0,0x1
    24c2:	335020ef          	jal	4ff6 <sbrk>
  sbrk(10);
    24c6:	4529                	li	a0,10
    24c8:	32f020ef          	jal	4ff6 <sbrk>
  sbrk(-20);
    24cc:	5531                	li	a0,-20
    24ce:	329020ef          	jal	4ff6 <sbrk>
  top = (uint64)sbrk(0);
    24d2:	4501                	li	a0,0
    24d4:	323020ef          	jal	4ff6 <sbrk>
    24d8:	84aa                	mv	s1,a0
  char *p = (char *)(top - 64);
    24da:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xcc>
  p[0] = 'x';
    24de:	07800993          	li	s3,120
    24e2:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    24e6:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR | O_CREATE);
    24ea:	20200593          	li	a1,514
    24ee:	854a                	mv	a0,s2
    24f0:	37b020ef          	jal	506a <open>
    24f4:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    24f6:	4605                	li	a2,1
    24f8:	85ca                	mv	a1,s2
    24fa:	351020ef          	jal	504a <write>
  close(fd);
    24fe:	8552                	mv	a0,s4
    2500:	353020ef          	jal	5052 <close>
  fd = open(p, O_RDWR);
    2504:	4589                	li	a1,2
    2506:	854a                	mv	a0,s2
    2508:	363020ef          	jal	506a <open>
  p[0] = '\0';
    250c:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    2510:	4605                	li	a2,1
    2512:	85ca                	mv	a1,s2
    2514:	32f020ef          	jal	5042 <read>
  if (p[0] != 'x')
    2518:	fc04c783          	lbu	a5,-64(s1)
    251c:	03379263          	bne	a5,s3,2540 <sbrklast+0x9c>
}
    2520:	70a2                	ld	ra,40(sp)
    2522:	7402                	ld	s0,32(sp)
    2524:	64e2                	ld	s1,24(sp)
    2526:	6942                	ld	s2,16(sp)
    2528:	69a2                	ld	s3,8(sp)
    252a:	6a02                	ld	s4,0(sp)
    252c:	6145                	addi	sp,sp,48
    252e:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2530:	0347d513          	srli	a0,a5,0x34
    2534:	6785                	lui	a5,0x1
    2536:	40a7853b          	subw	a0,a5,a0
    253a:	2bd020ef          	jal	4ff6 <sbrk>
    253e:	b749                	j	24c0 <sbrklast+0x1c>
    exit(1);
    2540:	4505                	li	a0,1
    2542:	2e9020ef          	jal	502a <exit>

0000000000002546 <sbrk8000>:
{
    2546:	1141                	addi	sp,sp,-16
    2548:	e406                	sd	ra,8(sp)
    254a:	e022                	sd	s0,0(sp)
    254c:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    254e:	80000537          	lui	a0,0x80000
    2552:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff134c>
    2554:	2a3020ef          	jal	4ff6 <sbrk>
  volatile char *top = sbrk(0);
    2558:	4501                	li	a0,0
    255a:	29d020ef          	jal	4ff6 <sbrk>
  *(top - 1) = *(top - 1) + 1;
    255e:	fff54783          	lbu	a5,-1(a0)
    2562:	2785                	addiw	a5,a5,1 # 1001 <bigdir+0x10d>
    2564:	fef50fa3          	sb	a5,-1(a0)
}
    2568:	60a2                	ld	ra,8(sp)
    256a:	6402                	ld	s0,0(sp)
    256c:	0141                	addi	sp,sp,16
    256e:	8082                	ret

0000000000002570 <execout>:
{
    2570:	711d                	addi	sp,sp,-96
    2572:	ec86                	sd	ra,88(sp)
    2574:	e8a2                	sd	s0,80(sp)
    2576:	e4a6                	sd	s1,72(sp)
    2578:	e0ca                	sd	s2,64(sp)
    257a:	fc4e                	sd	s3,56(sp)
    257c:	1080                	addi	s0,sp,96
  for (int avail = 0; avail < 15; avail++) {
    257e:	4901                	li	s2,0
    2580:	49bd                	li	s3,15
    int pid = fork();
    2582:	2a1020ef          	jal	5022 <fork>
    2586:	84aa                	mv	s1,a0
    if (pid < 0) {
    2588:	00054e63          	bltz	a0,25a4 <execout+0x34>
    } else if (pid == 0) {
    258c:	c51d                	beqz	a0,25ba <execout+0x4a>
      wait((int *)0);
    258e:	4501                	li	a0,0
    2590:	2a3020ef          	jal	5032 <wait>
  for (int avail = 0; avail < 15; avail++) {
    2594:	2905                	addiw	s2,s2,1
    2596:	ff3916e3          	bne	s2,s3,2582 <execout+0x12>
    259a:	f852                	sd	s4,48(sp)
    259c:	f456                	sd	s5,40(sp)
  exit(0);
    259e:	4501                	li	a0,0
    25a0:	28b020ef          	jal	502a <exit>
    25a4:	f852                	sd	s4,48(sp)
    25a6:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    25a8:	00005517          	auipc	a0,0x5
    25ac:	f3850513          	addi	a0,a0,-200 # 74e0 <malloc+0x1f94>
    25b0:	6e1020ef          	jal	5490 <printf>
      exit(1);
    25b4:	4505                	li	a0,1
    25b6:	275020ef          	jal	502a <exit>
    25ba:	f852                	sd	s4,48(sp)
    25bc:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    25be:	6985                	lui	s3,0x1
        if (a == SBRK_ERROR)
    25c0:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    25c2:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    25c4:	854e                	mv	a0,s3
    25c6:	231020ef          	jal	4ff6 <sbrk>
        if (a == SBRK_ERROR)
    25ca:	01450663          	beq	a0,s4,25d6 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    25ce:	954e                	add	a0,a0,s3
    25d0:	ff550fa3          	sb	s5,-1(a0)
      while (1) {
    25d4:	bfc5                	j	25c4 <execout+0x54>
        sbrk(-PGSIZE);
    25d6:	79fd                	lui	s3,0xfffff
      for (int i = 0; i < avail; i++)
    25d8:	01205863          	blez	s2,25e8 <execout+0x78>
        sbrk(-PGSIZE);
    25dc:	854e                	mv	a0,s3
    25de:	219020ef          	jal	4ff6 <sbrk>
      for (int i = 0; i < avail; i++)
    25e2:	2485                	addiw	s1,s1,1
    25e4:	ff249ce3          	bne	s1,s2,25dc <execout+0x6c>
      close(1);
    25e8:	4505                	li	a0,1
    25ea:	269020ef          	jal	5052 <close>
      char *args[] = {"echo", "x", 0};
    25ee:	00003797          	auipc	a5,0x3
    25f2:	08a78793          	addi	a5,a5,138 # 5678 <malloc+0x12c>
    25f6:	faf43423          	sd	a5,-88(s0)
    25fa:	00003797          	auipc	a5,0x3
    25fe:	0ee78793          	addi	a5,a5,238 # 56e8 <malloc+0x19c>
    2602:	faf43823          	sd	a5,-80(s0)
    2606:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    260a:	fa840593          	addi	a1,s0,-88
    260e:	00003517          	auipc	a0,0x3
    2612:	06a50513          	addi	a0,a0,106 # 5678 <malloc+0x12c>
    2616:	24d020ef          	jal	5062 <exec>
      exit(0);
    261a:	4501                	li	a0,0
    261c:	20f020ef          	jal	502a <exit>

0000000000002620 <fourteen>:
{
    2620:	1101                	addi	sp,sp,-32
    2622:	ec06                	sd	ra,24(sp)
    2624:	e822                	sd	s0,16(sp)
    2626:	e426                	sd	s1,8(sp)
    2628:	1000                	addi	s0,sp,32
    262a:	84aa                	mv	s1,a0
  if (mkdir("12345678901234") != 0) {
    262c:	00004517          	auipc	a0,0x4
    2630:	07c50513          	addi	a0,a0,124 # 66a8 <malloc+0x115c>
    2634:	25f020ef          	jal	5092 <mkdir>
    2638:	e555                	bnez	a0,26e4 <fourteen+0xc4>
  if (mkdir("12345678901234/123456789012345") != 0) {
    263a:	00004517          	auipc	a0,0x4
    263e:	ec650513          	addi	a0,a0,-314 # 6500 <malloc+0xfb4>
    2642:	251020ef          	jal	5092 <mkdir>
    2646:	e94d                	bnez	a0,26f8 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2648:	20000593          	li	a1,512
    264c:	00004517          	auipc	a0,0x4
    2650:	f0c50513          	addi	a0,a0,-244 # 6558 <malloc+0x100c>
    2654:	217020ef          	jal	506a <open>
  if (fd < 0) {
    2658:	0a054a63          	bltz	a0,270c <fourteen+0xec>
  close(fd);
    265c:	1f7020ef          	jal	5052 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2660:	4581                	li	a1,0
    2662:	00004517          	auipc	a0,0x4
    2666:	f6e50513          	addi	a0,a0,-146 # 65d0 <malloc+0x1084>
    266a:	201020ef          	jal	506a <open>
  if (fd < 0) {
    266e:	0a054963          	bltz	a0,2720 <fourteen+0x100>
  close(fd);
    2672:	1e1020ef          	jal	5052 <close>
  if (mkdir("12345678901234/12345678901234") == 0) {
    2676:	00004517          	auipc	a0,0x4
    267a:	fca50513          	addi	a0,a0,-54 # 6640 <malloc+0x10f4>
    267e:	215020ef          	jal	5092 <mkdir>
    2682:	c94d                	beqz	a0,2734 <fourteen+0x114>
  if (mkdir("123456789012345/12345678901234") == 0) {
    2684:	00004517          	auipc	a0,0x4
    2688:	01450513          	addi	a0,a0,20 # 6698 <malloc+0x114c>
    268c:	207020ef          	jal	5092 <mkdir>
    2690:	cd45                	beqz	a0,2748 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2692:	00004517          	auipc	a0,0x4
    2696:	00650513          	addi	a0,a0,6 # 6698 <malloc+0x114c>
    269a:	1e1020ef          	jal	507a <unlink>
  unlink("12345678901234/12345678901234");
    269e:	00004517          	auipc	a0,0x4
    26a2:	fa250513          	addi	a0,a0,-94 # 6640 <malloc+0x10f4>
    26a6:	1d5020ef          	jal	507a <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    26aa:	00004517          	auipc	a0,0x4
    26ae:	f2650513          	addi	a0,a0,-218 # 65d0 <malloc+0x1084>
    26b2:	1c9020ef          	jal	507a <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    26b6:	00004517          	auipc	a0,0x4
    26ba:	ea250513          	addi	a0,a0,-350 # 6558 <malloc+0x100c>
    26be:	1bd020ef          	jal	507a <unlink>
  unlink("12345678901234/123456789012345");
    26c2:	00004517          	auipc	a0,0x4
    26c6:	e3e50513          	addi	a0,a0,-450 # 6500 <malloc+0xfb4>
    26ca:	1b1020ef          	jal	507a <unlink>
  unlink("12345678901234");
    26ce:	00004517          	auipc	a0,0x4
    26d2:	fda50513          	addi	a0,a0,-38 # 66a8 <malloc+0x115c>
    26d6:	1a5020ef          	jal	507a <unlink>
}
    26da:	60e2                	ld	ra,24(sp)
    26dc:	6442                	ld	s0,16(sp)
    26de:	64a2                	ld	s1,8(sp)
    26e0:	6105                	addi	sp,sp,32
    26e2:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    26e4:	85a6                	mv	a1,s1
    26e6:	00004517          	auipc	a0,0x4
    26ea:	df250513          	addi	a0,a0,-526 # 64d8 <malloc+0xf8c>
    26ee:	5a3020ef          	jal	5490 <printf>
    exit(1);
    26f2:	4505                	li	a0,1
    26f4:	137020ef          	jal	502a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    26f8:	85a6                	mv	a1,s1
    26fa:	00004517          	auipc	a0,0x4
    26fe:	e2650513          	addi	a0,a0,-474 # 6520 <malloc+0xfd4>
    2702:	58f020ef          	jal	5490 <printf>
    exit(1);
    2706:	4505                	li	a0,1
    2708:	123020ef          	jal	502a <exit>
    printf(
    270c:	85a6                	mv	a1,s1
    270e:	00004517          	auipc	a0,0x4
    2712:	e7a50513          	addi	a0,a0,-390 # 6588 <malloc+0x103c>
    2716:	57b020ef          	jal	5490 <printf>
    exit(1);
    271a:	4505                	li	a0,1
    271c:	10f020ef          	jal	502a <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    2720:	85a6                	mv	a1,s1
    2722:	00004517          	auipc	a0,0x4
    2726:	ede50513          	addi	a0,a0,-290 # 6600 <malloc+0x10b4>
    272a:	567020ef          	jal	5490 <printf>
    exit(1);
    272e:	4505                	li	a0,1
    2730:	0fb020ef          	jal	502a <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    2734:	85a6                	mv	a1,s1
    2736:	00004517          	auipc	a0,0x4
    273a:	f2a50513          	addi	a0,a0,-214 # 6660 <malloc+0x1114>
    273e:	553020ef          	jal	5490 <printf>
    exit(1);
    2742:	4505                	li	a0,1
    2744:	0e7020ef          	jal	502a <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    2748:	85a6                	mv	a1,s1
    274a:	00004517          	auipc	a0,0x4
    274e:	f6e50513          	addi	a0,a0,-146 # 66b8 <malloc+0x116c>
    2752:	53f020ef          	jal	5490 <printf>
    exit(1);
    2756:	4505                	li	a0,1
    2758:	0d3020ef          	jal	502a <exit>

000000000000275c <diskfull>:
{
    275c:	b6010113          	addi	sp,sp,-1184
    2760:	48113c23          	sd	ra,1176(sp)
    2764:	48813823          	sd	s0,1168(sp)
    2768:	48913423          	sd	s1,1160(sp)
    276c:	49213023          	sd	s2,1152(sp)
    2770:	47313c23          	sd	s3,1144(sp)
    2774:	47413823          	sd	s4,1136(sp)
    2778:	47513423          	sd	s5,1128(sp)
    277c:	47613023          	sd	s6,1120(sp)
    2780:	45713c23          	sd	s7,1112(sp)
    2784:	45813823          	sd	s8,1104(sp)
    2788:	45913423          	sd	s9,1096(sp)
    278c:	45a13023          	sd	s10,1088(sp)
    2790:	43b13c23          	sd	s11,1080(sp)
    2794:	4a010413          	addi	s0,sp,1184
    2798:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    279c:	00004517          	auipc	a0,0x4
    27a0:	f5450513          	addi	a0,a0,-172 # 66f0 <malloc+0x11a4>
    27a4:	0d7020ef          	jal	507a <unlink>
    27a8:	03000a93          	li	s5,48
    name[0] = 'b';
    27ac:	06200d13          	li	s10,98
    name[1] = 'i';
    27b0:	06900c93          	li	s9,105
    name[2] = 'g';
    27b4:	06700c13          	li	s8,103
    unlink(name);
    27b8:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27bc:	60200b93          	li	s7,1538
    if (fd < 0) {
    27c0:	10c00d93          	li	s11,268
      if (write(fd, buf, BSIZE) != BSIZE) {
    27c4:	b9040a13          	addi	s4,s0,-1136
    27c8:	aa8d                	j	293a <diskfull+0x1de>
      printf("%s: could not create file %s\n", s, name);
    27ca:	b7040613          	addi	a2,s0,-1168
    27ce:	b6843583          	ld	a1,-1176(s0)
    27d2:	00004517          	auipc	a0,0x4
    27d6:	f2e50513          	addi	a0,a0,-210 # 6700 <malloc+0x11b4>
    27da:	4b7020ef          	jal	5490 <printf>
      break;
    27de:	a039                	j	27ec <diskfull+0x90>
        close(fd);
    27e0:	854e                	mv	a0,s3
    27e2:	071020ef          	jal	5052 <close>
    close(fd);
    27e6:	854e                	mv	a0,s3
    27e8:	06b020ef          	jal	5052 <close>
  for (int i = 0; i < nzz; i++) {
    27ec:	4481                	li	s1,0
    name[0] = 'z';
    27ee:	07a00993          	li	s3,122
    unlink(name);
    27f2:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    27f6:	60200a13          	li	s4,1538
  for (int i = 0; i < nzz; i++) {
    27fa:	08000a93          	li	s5,128
    name[0] = 'z';
    27fe:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2802:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2806:	41f4d71b          	sraiw	a4,s1,0x1f
    280a:	01b7571b          	srliw	a4,a4,0x1b
    280e:	009707bb          	addw	a5,a4,s1
    2812:	4057d69b          	sraiw	a3,a5,0x5
    2816:	0306869b          	addiw	a3,a3,48
    281a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    281e:	8bfd                	andi	a5,a5,31
    2820:	9f99                	subw	a5,a5,a4
    2822:	0307879b          	addiw	a5,a5,48
    2826:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    282a:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    282e:	854a                	mv	a0,s2
    2830:	04b020ef          	jal	507a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2834:	85d2                	mv	a1,s4
    2836:	854a                	mv	a0,s2
    2838:	033020ef          	jal	506a <open>
    if (fd < 0)
    283c:	00054763          	bltz	a0,284a <diskfull+0xee>
    close(fd);
    2840:	013020ef          	jal	5052 <close>
  for (int i = 0; i < nzz; i++) {
    2844:	2485                	addiw	s1,s1,1
    2846:	fb549ce3          	bne	s1,s5,27fe <diskfull+0xa2>
  if (mkdir("diskfulldir") == 0)
    284a:	00004517          	auipc	a0,0x4
    284e:	ea650513          	addi	a0,a0,-346 # 66f0 <malloc+0x11a4>
    2852:	041020ef          	jal	5092 <mkdir>
    2856:	12050363          	beqz	a0,297c <diskfull+0x220>
  unlink("diskfulldir");
    285a:	00004517          	auipc	a0,0x4
    285e:	e9650513          	addi	a0,a0,-362 # 66f0 <malloc+0x11a4>
    2862:	019020ef          	jal	507a <unlink>
  for (int i = 0; i < nzz; i++) {
    2866:	4481                	li	s1,0
    name[0] = 'z';
    2868:	07a00913          	li	s2,122
    unlink(name);
    286c:	b9040a13          	addi	s4,s0,-1136
  for (int i = 0; i < nzz; i++) {
    2870:	08000993          	li	s3,128
    name[0] = 'z';
    2874:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    2878:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    287c:	41f4d71b          	sraiw	a4,s1,0x1f
    2880:	01b7571b          	srliw	a4,a4,0x1b
    2884:	009707bb          	addw	a5,a4,s1
    2888:	4057d69b          	sraiw	a3,a5,0x5
    288c:	0306869b          	addiw	a3,a3,48
    2890:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2894:	8bfd                	andi	a5,a5,31
    2896:	9f99                	subw	a5,a5,a4
    2898:	0307879b          	addiw	a5,a5,48
    289c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    28a0:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28a4:	8552                	mv	a0,s4
    28a6:	7d4020ef          	jal	507a <unlink>
  for (int i = 0; i < nzz; i++) {
    28aa:	2485                	addiw	s1,s1,1
    28ac:	fd3494e3          	bne	s1,s3,2874 <diskfull+0x118>
    28b0:	03000493          	li	s1,48
    name[0] = 'b';
    28b4:	06200b13          	li	s6,98
    name[1] = 'i';
    28b8:	06900a93          	li	s5,105
    name[2] = 'g';
    28bc:	06700a13          	li	s4,103
    unlink(name);
    28c0:	b9040993          	addi	s3,s0,-1136
  for (int i = 0; '0' + i < 0177; i++) {
    28c4:	07f00913          	li	s2,127
    name[0] = 'b';
    28c8:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    28cc:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    28d0:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    28d4:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    28d8:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    28dc:	854e                	mv	a0,s3
    28de:	79c020ef          	jal	507a <unlink>
  for (int i = 0; '0' + i < 0177; i++) {
    28e2:	2485                	addiw	s1,s1,1
    28e4:	0ff4f493          	zext.b	s1,s1
    28e8:	ff2490e3          	bne	s1,s2,28c8 <diskfull+0x16c>
}
    28ec:	49813083          	ld	ra,1176(sp)
    28f0:	49013403          	ld	s0,1168(sp)
    28f4:	48813483          	ld	s1,1160(sp)
    28f8:	48013903          	ld	s2,1152(sp)
    28fc:	47813983          	ld	s3,1144(sp)
    2900:	47013a03          	ld	s4,1136(sp)
    2904:	46813a83          	ld	s5,1128(sp)
    2908:	46013b03          	ld	s6,1120(sp)
    290c:	45813b83          	ld	s7,1112(sp)
    2910:	45013c03          	ld	s8,1104(sp)
    2914:	44813c83          	ld	s9,1096(sp)
    2918:	44013d03          	ld	s10,1088(sp)
    291c:	43813d83          	ld	s11,1080(sp)
    2920:	4a010113          	addi	sp,sp,1184
    2924:	8082                	ret
    close(fd);
    2926:	854e                	mv	a0,s3
    2928:	72a020ef          	jal	5052 <close>
  for (fi = 0; done == 0 && '0' + fi < 0177; fi++) {
    292c:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x47b>
    292e:	0ffafa93          	zext.b	s5,s5
    2932:	07f00793          	li	a5,127
    2936:	eafa8be3          	beq	s5,a5,27ec <diskfull+0x90>
    name[0] = 'b';
    293a:	b7a40823          	sb	s10,-1168(s0)
    name[1] = 'i';
    293e:	b79408a3          	sb	s9,-1167(s0)
    name[2] = 'g';
    2942:	b7840923          	sb	s8,-1166(s0)
    name[3] = '0' + fi;
    2946:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    294a:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    294e:	855a                	mv	a0,s6
    2950:	72a020ef          	jal	507a <unlink>
    int fd = open(name, O_CREATE | O_RDWR | O_TRUNC);
    2954:	85de                	mv	a1,s7
    2956:	855a                	mv	a0,s6
    2958:	712020ef          	jal	506a <open>
    295c:	89aa                	mv	s3,a0
    if (fd < 0) {
    295e:	e60546e3          	bltz	a0,27ca <diskfull+0x6e>
    2962:	84ee                	mv	s1,s11
      if (write(fd, buf, BSIZE) != BSIZE) {
    2964:	40000913          	li	s2,1024
    2968:	864a                	mv	a2,s2
    296a:	85d2                	mv	a1,s4
    296c:	854e                	mv	a0,s3
    296e:	6dc020ef          	jal	504a <write>
    2972:	e72517e3          	bne	a0,s2,27e0 <diskfull+0x84>
    for (int i = 0; i < MAXFILE; i++) {
    2976:	34fd                	addiw	s1,s1,-1
    2978:	f8e5                	bnez	s1,2968 <diskfull+0x20c>
    297a:	b775                	j	2926 <diskfull+0x1ca>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    297c:	b6843583          	ld	a1,-1176(s0)
    2980:	00004517          	auipc	a0,0x4
    2984:	da050513          	addi	a0,a0,-608 # 6720 <malloc+0x11d4>
    2988:	309020ef          	jal	5490 <printf>
    298c:	b5f9                	j	285a <diskfull+0xfe>

000000000000298e <iputtest>:
{
    298e:	1101                	addi	sp,sp,-32
    2990:	ec06                	sd	ra,24(sp)
    2992:	e822                	sd	s0,16(sp)
    2994:	e426                	sd	s1,8(sp)
    2996:	1000                	addi	s0,sp,32
    2998:	84aa                	mv	s1,a0
  if (mkdir("iputdir") < 0) {
    299a:	00004517          	auipc	a0,0x4
    299e:	db650513          	addi	a0,a0,-586 # 6750 <malloc+0x1204>
    29a2:	6f0020ef          	jal	5092 <mkdir>
    29a6:	02054f63          	bltz	a0,29e4 <iputtest+0x56>
  if (chdir("iputdir") < 0) {
    29aa:	00004517          	auipc	a0,0x4
    29ae:	da650513          	addi	a0,a0,-602 # 6750 <malloc+0x1204>
    29b2:	6e8020ef          	jal	509a <chdir>
    29b6:	04054163          	bltz	a0,29f8 <iputtest+0x6a>
  if (unlink("../iputdir") < 0) {
    29ba:	00004517          	auipc	a0,0x4
    29be:	dd650513          	addi	a0,a0,-554 # 6790 <malloc+0x1244>
    29c2:	6b8020ef          	jal	507a <unlink>
    29c6:	04054363          	bltz	a0,2a0c <iputtest+0x7e>
  if (chdir("/") < 0) {
    29ca:	00004517          	auipc	a0,0x4
    29ce:	df650513          	addi	a0,a0,-522 # 67c0 <malloc+0x1274>
    29d2:	6c8020ef          	jal	509a <chdir>
    29d6:	04054563          	bltz	a0,2a20 <iputtest+0x92>
}
    29da:	60e2                	ld	ra,24(sp)
    29dc:	6442                	ld	s0,16(sp)
    29de:	64a2                	ld	s1,8(sp)
    29e0:	6105                	addi	sp,sp,32
    29e2:	8082                	ret
    printf("%s: mkdir failed\n", s);
    29e4:	85a6                	mv	a1,s1
    29e6:	00004517          	auipc	a0,0x4
    29ea:	d7250513          	addi	a0,a0,-654 # 6758 <malloc+0x120c>
    29ee:	2a3020ef          	jal	5490 <printf>
    exit(1);
    29f2:	4505                	li	a0,1
    29f4:	636020ef          	jal	502a <exit>
    printf("%s: chdir iputdir failed\n", s);
    29f8:	85a6                	mv	a1,s1
    29fa:	00004517          	auipc	a0,0x4
    29fe:	d7650513          	addi	a0,a0,-650 # 6770 <malloc+0x1224>
    2a02:	28f020ef          	jal	5490 <printf>
    exit(1);
    2a06:	4505                	li	a0,1
    2a08:	622020ef          	jal	502a <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2a0c:	85a6                	mv	a1,s1
    2a0e:	00004517          	auipc	a0,0x4
    2a12:	d9250513          	addi	a0,a0,-622 # 67a0 <malloc+0x1254>
    2a16:	27b020ef          	jal	5490 <printf>
    exit(1);
    2a1a:	4505                	li	a0,1
    2a1c:	60e020ef          	jal	502a <exit>
    printf("%s: chdir / failed\n", s);
    2a20:	85a6                	mv	a1,s1
    2a22:	00004517          	auipc	a0,0x4
    2a26:	da650513          	addi	a0,a0,-602 # 67c8 <malloc+0x127c>
    2a2a:	267020ef          	jal	5490 <printf>
    exit(1);
    2a2e:	4505                	li	a0,1
    2a30:	5fa020ef          	jal	502a <exit>

0000000000002a34 <exitiputtest>:
{
    2a34:	7179                	addi	sp,sp,-48
    2a36:	f406                	sd	ra,40(sp)
    2a38:	f022                	sd	s0,32(sp)
    2a3a:	ec26                	sd	s1,24(sp)
    2a3c:	1800                	addi	s0,sp,48
    2a3e:	84aa                	mv	s1,a0
  pid = fork();
    2a40:	5e2020ef          	jal	5022 <fork>
  if (pid < 0) {
    2a44:	02054e63          	bltz	a0,2a80 <exitiputtest+0x4c>
  if (pid == 0) {
    2a48:	e541                	bnez	a0,2ad0 <exitiputtest+0x9c>
    if (mkdir("iputdir") < 0) {
    2a4a:	00004517          	auipc	a0,0x4
    2a4e:	d0650513          	addi	a0,a0,-762 # 6750 <malloc+0x1204>
    2a52:	640020ef          	jal	5092 <mkdir>
    2a56:	02054f63          	bltz	a0,2a94 <exitiputtest+0x60>
    if (chdir("iputdir") < 0) {
    2a5a:	00004517          	auipc	a0,0x4
    2a5e:	cf650513          	addi	a0,a0,-778 # 6750 <malloc+0x1204>
    2a62:	638020ef          	jal	509a <chdir>
    2a66:	04054163          	bltz	a0,2aa8 <exitiputtest+0x74>
    if (unlink("../iputdir") < 0) {
    2a6a:	00004517          	auipc	a0,0x4
    2a6e:	d2650513          	addi	a0,a0,-730 # 6790 <malloc+0x1244>
    2a72:	608020ef          	jal	507a <unlink>
    2a76:	04054363          	bltz	a0,2abc <exitiputtest+0x88>
    exit(0);
    2a7a:	4501                	li	a0,0
    2a7c:	5ae020ef          	jal	502a <exit>
    printf("%s: fork failed\n", s);
    2a80:	85a6                	mv	a1,s1
    2a82:	00003517          	auipc	a0,0x3
    2a86:	48650513          	addi	a0,a0,1158 # 5f08 <malloc+0x9bc>
    2a8a:	207020ef          	jal	5490 <printf>
    exit(1);
    2a8e:	4505                	li	a0,1
    2a90:	59a020ef          	jal	502a <exit>
      printf("%s: mkdir failed\n", s);
    2a94:	85a6                	mv	a1,s1
    2a96:	00004517          	auipc	a0,0x4
    2a9a:	cc250513          	addi	a0,a0,-830 # 6758 <malloc+0x120c>
    2a9e:	1f3020ef          	jal	5490 <printf>
      exit(1);
    2aa2:	4505                	li	a0,1
    2aa4:	586020ef          	jal	502a <exit>
      printf("%s: child chdir failed\n", s);
    2aa8:	85a6                	mv	a1,s1
    2aaa:	00004517          	auipc	a0,0x4
    2aae:	d3650513          	addi	a0,a0,-714 # 67e0 <malloc+0x1294>
    2ab2:	1df020ef          	jal	5490 <printf>
      exit(1);
    2ab6:	4505                	li	a0,1
    2ab8:	572020ef          	jal	502a <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2abc:	85a6                	mv	a1,s1
    2abe:	00004517          	auipc	a0,0x4
    2ac2:	ce250513          	addi	a0,a0,-798 # 67a0 <malloc+0x1254>
    2ac6:	1cb020ef          	jal	5490 <printf>
      exit(1);
    2aca:	4505                	li	a0,1
    2acc:	55e020ef          	jal	502a <exit>
  wait(&xstatus);
    2ad0:	fdc40513          	addi	a0,s0,-36
    2ad4:	55e020ef          	jal	5032 <wait>
  exit(xstatus);
    2ad8:	fdc42503          	lw	a0,-36(s0)
    2adc:	54e020ef          	jal	502a <exit>

0000000000002ae0 <dirtest>:
{
    2ae0:	1101                	addi	sp,sp,-32
    2ae2:	ec06                	sd	ra,24(sp)
    2ae4:	e822                	sd	s0,16(sp)
    2ae6:	e426                	sd	s1,8(sp)
    2ae8:	1000                	addi	s0,sp,32
    2aea:	84aa                	mv	s1,a0
  if (mkdir("dir0") < 0) {
    2aec:	00004517          	auipc	a0,0x4
    2af0:	d0c50513          	addi	a0,a0,-756 # 67f8 <malloc+0x12ac>
    2af4:	59e020ef          	jal	5092 <mkdir>
    2af8:	02054f63          	bltz	a0,2b36 <dirtest+0x56>
  if (chdir("dir0") < 0) {
    2afc:	00004517          	auipc	a0,0x4
    2b00:	cfc50513          	addi	a0,a0,-772 # 67f8 <malloc+0x12ac>
    2b04:	596020ef          	jal	509a <chdir>
    2b08:	04054163          	bltz	a0,2b4a <dirtest+0x6a>
  if (chdir("..") < 0) {
    2b0c:	00004517          	auipc	a0,0x4
    2b10:	d0c50513          	addi	a0,a0,-756 # 6818 <malloc+0x12cc>
    2b14:	586020ef          	jal	509a <chdir>
    2b18:	04054363          	bltz	a0,2b5e <dirtest+0x7e>
  if (unlink("dir0") < 0) {
    2b1c:	00004517          	auipc	a0,0x4
    2b20:	cdc50513          	addi	a0,a0,-804 # 67f8 <malloc+0x12ac>
    2b24:	556020ef          	jal	507a <unlink>
    2b28:	04054563          	bltz	a0,2b72 <dirtest+0x92>
}
    2b2c:	60e2                	ld	ra,24(sp)
    2b2e:	6442                	ld	s0,16(sp)
    2b30:	64a2                	ld	s1,8(sp)
    2b32:	6105                	addi	sp,sp,32
    2b34:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b36:	85a6                	mv	a1,s1
    2b38:	00004517          	auipc	a0,0x4
    2b3c:	c2050513          	addi	a0,a0,-992 # 6758 <malloc+0x120c>
    2b40:	151020ef          	jal	5490 <printf>
    exit(1);
    2b44:	4505                	li	a0,1
    2b46:	4e4020ef          	jal	502a <exit>
    printf("%s: chdir dir0 failed\n", s);
    2b4a:	85a6                	mv	a1,s1
    2b4c:	00004517          	auipc	a0,0x4
    2b50:	cb450513          	addi	a0,a0,-844 # 6800 <malloc+0x12b4>
    2b54:	13d020ef          	jal	5490 <printf>
    exit(1);
    2b58:	4505                	li	a0,1
    2b5a:	4d0020ef          	jal	502a <exit>
    printf("%s: chdir .. failed\n", s);
    2b5e:	85a6                	mv	a1,s1
    2b60:	00004517          	auipc	a0,0x4
    2b64:	cc050513          	addi	a0,a0,-832 # 6820 <malloc+0x12d4>
    2b68:	129020ef          	jal	5490 <printf>
    exit(1);
    2b6c:	4505                	li	a0,1
    2b6e:	4bc020ef          	jal	502a <exit>
    printf("%s: unlink dir0 failed\n", s);
    2b72:	85a6                	mv	a1,s1
    2b74:	00004517          	auipc	a0,0x4
    2b78:	cc450513          	addi	a0,a0,-828 # 6838 <malloc+0x12ec>
    2b7c:	115020ef          	jal	5490 <printf>
    exit(1);
    2b80:	4505                	li	a0,1
    2b82:	4a8020ef          	jal	502a <exit>

0000000000002b86 <subdir>:
{
    2b86:	1101                	addi	sp,sp,-32
    2b88:	ec06                	sd	ra,24(sp)
    2b8a:	e822                	sd	s0,16(sp)
    2b8c:	e426                	sd	s1,8(sp)
    2b8e:	e04a                	sd	s2,0(sp)
    2b90:	1000                	addi	s0,sp,32
    2b92:	892a                	mv	s2,a0
  unlink("ff");
    2b94:	00004517          	auipc	a0,0x4
    2b98:	dec50513          	addi	a0,a0,-532 # 6980 <malloc+0x1434>
    2b9c:	4de020ef          	jal	507a <unlink>
  if (mkdir("dd") != 0) {
    2ba0:	00004517          	auipc	a0,0x4
    2ba4:	cb050513          	addi	a0,a0,-848 # 6850 <malloc+0x1304>
    2ba8:	4ea020ef          	jal	5092 <mkdir>
    2bac:	2e051263          	bnez	a0,2e90 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2bb0:	20200593          	li	a1,514
    2bb4:	00004517          	auipc	a0,0x4
    2bb8:	cbc50513          	addi	a0,a0,-836 # 6870 <malloc+0x1324>
    2bbc:	4ae020ef          	jal	506a <open>
    2bc0:	84aa                	mv	s1,a0
  if (fd < 0) {
    2bc2:	2e054163          	bltz	a0,2ea4 <subdir+0x31e>
  write(fd, "ff", 2);
    2bc6:	4609                	li	a2,2
    2bc8:	00004597          	auipc	a1,0x4
    2bcc:	db858593          	addi	a1,a1,-584 # 6980 <malloc+0x1434>
    2bd0:	47a020ef          	jal	504a <write>
  close(fd);
    2bd4:	8526                	mv	a0,s1
    2bd6:	47c020ef          	jal	5052 <close>
  if (unlink("dd") >= 0) {
    2bda:	00004517          	auipc	a0,0x4
    2bde:	c7650513          	addi	a0,a0,-906 # 6850 <malloc+0x1304>
    2be2:	498020ef          	jal	507a <unlink>
    2be6:	2c055963          	bgez	a0,2eb8 <subdir+0x332>
  if (mkdir("/dd/dd") != 0) {
    2bea:	00004517          	auipc	a0,0x4
    2bee:	cde50513          	addi	a0,a0,-802 # 68c8 <malloc+0x137c>
    2bf2:	4a0020ef          	jal	5092 <mkdir>
    2bf6:	2c051b63          	bnez	a0,2ecc <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2bfa:	20200593          	li	a1,514
    2bfe:	00004517          	auipc	a0,0x4
    2c02:	cf250513          	addi	a0,a0,-782 # 68f0 <malloc+0x13a4>
    2c06:	464020ef          	jal	506a <open>
    2c0a:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c0c:	2c054a63          	bltz	a0,2ee0 <subdir+0x35a>
  write(fd, "FF", 2);
    2c10:	4609                	li	a2,2
    2c12:	00004597          	auipc	a1,0x4
    2c16:	d0e58593          	addi	a1,a1,-754 # 6920 <malloc+0x13d4>
    2c1a:	430020ef          	jal	504a <write>
  close(fd);
    2c1e:	8526                	mv	a0,s1
    2c20:	432020ef          	jal	5052 <close>
  fd = open("dd/dd/../ff", 0);
    2c24:	4581                	li	a1,0
    2c26:	00004517          	auipc	a0,0x4
    2c2a:	d0250513          	addi	a0,a0,-766 # 6928 <malloc+0x13dc>
    2c2e:	43c020ef          	jal	506a <open>
    2c32:	84aa                	mv	s1,a0
  if (fd < 0) {
    2c34:	2c054063          	bltz	a0,2ef4 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2c38:	660d                	lui	a2,0x3
    2c3a:	00009597          	auipc	a1,0x9
    2c3e:	07e58593          	addi	a1,a1,126 # bcb8 <buf>
    2c42:	400020ef          	jal	5042 <read>
  if (cc != 2 || buf[0] != 'f') {
    2c46:	4789                	li	a5,2
    2c48:	2cf51063          	bne	a0,a5,2f08 <subdir+0x382>
    2c4c:	00009717          	auipc	a4,0x9
    2c50:	06c74703          	lbu	a4,108(a4) # bcb8 <buf>
    2c54:	06600793          	li	a5,102
    2c58:	2af71863          	bne	a4,a5,2f08 <subdir+0x382>
  close(fd);
    2c5c:	8526                	mv	a0,s1
    2c5e:	3f4020ef          	jal	5052 <close>
  if (link("dd/dd/ff", "dd/dd/ffff") != 0) {
    2c62:	00004597          	auipc	a1,0x4
    2c66:	d1658593          	addi	a1,a1,-746 # 6978 <malloc+0x142c>
    2c6a:	00004517          	auipc	a0,0x4
    2c6e:	c8650513          	addi	a0,a0,-890 # 68f0 <malloc+0x13a4>
    2c72:	418020ef          	jal	508a <link>
    2c76:	2a051363          	bnez	a0,2f1c <subdir+0x396>
  if (unlink("dd/dd/ff") != 0) {
    2c7a:	00004517          	auipc	a0,0x4
    2c7e:	c7650513          	addi	a0,a0,-906 # 68f0 <malloc+0x13a4>
    2c82:	3f8020ef          	jal	507a <unlink>
    2c86:	2a051563          	bnez	a0,2f30 <subdir+0x3aa>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2c8a:	4581                	li	a1,0
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	c6450513          	addi	a0,a0,-924 # 68f0 <malloc+0x13a4>
    2c94:	3d6020ef          	jal	506a <open>
    2c98:	2a055663          	bgez	a0,2f44 <subdir+0x3be>
  if (chdir("dd") != 0) {
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	bb450513          	addi	a0,a0,-1100 # 6850 <malloc+0x1304>
    2ca4:	3f6020ef          	jal	509a <chdir>
    2ca8:	2a051863          	bnez	a0,2f58 <subdir+0x3d2>
  if (chdir("dd/../../dd") != 0) {
    2cac:	00004517          	auipc	a0,0x4
    2cb0:	d6450513          	addi	a0,a0,-668 # 6a10 <malloc+0x14c4>
    2cb4:	3e6020ef          	jal	509a <chdir>
    2cb8:	2a051a63          	bnez	a0,2f6c <subdir+0x3e6>
  if (chdir("dd/../../../dd") != 0) {
    2cbc:	00004517          	auipc	a0,0x4
    2cc0:	d8450513          	addi	a0,a0,-636 # 6a40 <malloc+0x14f4>
    2cc4:	3d6020ef          	jal	509a <chdir>
    2cc8:	2a051c63          	bnez	a0,2f80 <subdir+0x3fa>
  if (chdir("./..") != 0) {
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	dac50513          	addi	a0,a0,-596 # 6a78 <malloc+0x152c>
    2cd4:	3c6020ef          	jal	509a <chdir>
    2cd8:	2a051e63          	bnez	a0,2f94 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2cdc:	4581                	li	a1,0
    2cde:	00004517          	auipc	a0,0x4
    2ce2:	c9a50513          	addi	a0,a0,-870 # 6978 <malloc+0x142c>
    2ce6:	384020ef          	jal	506a <open>
    2cea:	84aa                	mv	s1,a0
  if (fd < 0) {
    2cec:	2a054e63          	bltz	a0,2fa8 <subdir+0x422>
  if (read(fd, buf, sizeof(buf)) != 2) {
    2cf0:	660d                	lui	a2,0x3
    2cf2:	00009597          	auipc	a1,0x9
    2cf6:	fc658593          	addi	a1,a1,-58 # bcb8 <buf>
    2cfa:	348020ef          	jal	5042 <read>
    2cfe:	4789                	li	a5,2
    2d00:	2af51e63          	bne	a0,a5,2fbc <subdir+0x436>
  close(fd);
    2d04:	8526                	mv	a0,s1
    2d06:	34c020ef          	jal	5052 <close>
  if (open("dd/dd/ff", O_RDONLY) >= 0) {
    2d0a:	4581                	li	a1,0
    2d0c:	00004517          	auipc	a0,0x4
    2d10:	be450513          	addi	a0,a0,-1052 # 68f0 <malloc+0x13a4>
    2d14:	356020ef          	jal	506a <open>
    2d18:	2a055c63          	bgez	a0,2fd0 <subdir+0x44a>
  if (open("dd/ff/ff", O_CREATE | O_RDWR) >= 0) {
    2d1c:	20200593          	li	a1,514
    2d20:	00004517          	auipc	a0,0x4
    2d24:	de850513          	addi	a0,a0,-536 # 6b08 <malloc+0x15bc>
    2d28:	342020ef          	jal	506a <open>
    2d2c:	2a055c63          	bgez	a0,2fe4 <subdir+0x45e>
  if (open("dd/xx/ff", O_CREATE | O_RDWR) >= 0) {
    2d30:	20200593          	li	a1,514
    2d34:	00004517          	auipc	a0,0x4
    2d38:	e0450513          	addi	a0,a0,-508 # 6b38 <malloc+0x15ec>
    2d3c:	32e020ef          	jal	506a <open>
    2d40:	2a055c63          	bgez	a0,2ff8 <subdir+0x472>
  if (open("dd", O_CREATE) >= 0) {
    2d44:	20000593          	li	a1,512
    2d48:	00004517          	auipc	a0,0x4
    2d4c:	b0850513          	addi	a0,a0,-1272 # 6850 <malloc+0x1304>
    2d50:	31a020ef          	jal	506a <open>
    2d54:	2a055c63          	bgez	a0,300c <subdir+0x486>
  if (open("dd", O_RDWR) >= 0) {
    2d58:	4589                	li	a1,2
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	af650513          	addi	a0,a0,-1290 # 6850 <malloc+0x1304>
    2d62:	308020ef          	jal	506a <open>
    2d66:	2a055d63          	bgez	a0,3020 <subdir+0x49a>
  if (open("dd", O_WRONLY) >= 0) {
    2d6a:	4585                	li	a1,1
    2d6c:	00004517          	auipc	a0,0x4
    2d70:	ae450513          	addi	a0,a0,-1308 # 6850 <malloc+0x1304>
    2d74:	2f6020ef          	jal	506a <open>
    2d78:	2a055e63          	bgez	a0,3034 <subdir+0x4ae>
  if (link("dd/ff/ff", "dd/dd/xx") == 0) {
    2d7c:	00004597          	auipc	a1,0x4
    2d80:	e4c58593          	addi	a1,a1,-436 # 6bc8 <malloc+0x167c>
    2d84:	00004517          	auipc	a0,0x4
    2d88:	d8450513          	addi	a0,a0,-636 # 6b08 <malloc+0x15bc>
    2d8c:	2fe020ef          	jal	508a <link>
    2d90:	2a050c63          	beqz	a0,3048 <subdir+0x4c2>
  if (link("dd/xx/ff", "dd/dd/xx") == 0) {
    2d94:	00004597          	auipc	a1,0x4
    2d98:	e3458593          	addi	a1,a1,-460 # 6bc8 <malloc+0x167c>
    2d9c:	00004517          	auipc	a0,0x4
    2da0:	d9c50513          	addi	a0,a0,-612 # 6b38 <malloc+0x15ec>
    2da4:	2e6020ef          	jal	508a <link>
    2da8:	2a050a63          	beqz	a0,305c <subdir+0x4d6>
  if (link("dd/ff", "dd/dd/ffff") == 0) {
    2dac:	00004597          	auipc	a1,0x4
    2db0:	bcc58593          	addi	a1,a1,-1076 # 6978 <malloc+0x142c>
    2db4:	00004517          	auipc	a0,0x4
    2db8:	abc50513          	addi	a0,a0,-1348 # 6870 <malloc+0x1324>
    2dbc:	2ce020ef          	jal	508a <link>
    2dc0:	2a050863          	beqz	a0,3070 <subdir+0x4ea>
  if (mkdir("dd/ff/ff") == 0) {
    2dc4:	00004517          	auipc	a0,0x4
    2dc8:	d4450513          	addi	a0,a0,-700 # 6b08 <malloc+0x15bc>
    2dcc:	2c6020ef          	jal	5092 <mkdir>
    2dd0:	2a050a63          	beqz	a0,3084 <subdir+0x4fe>
  if (mkdir("dd/xx/ff") == 0) {
    2dd4:	00004517          	auipc	a0,0x4
    2dd8:	d6450513          	addi	a0,a0,-668 # 6b38 <malloc+0x15ec>
    2ddc:	2b6020ef          	jal	5092 <mkdir>
    2de0:	2a050c63          	beqz	a0,3098 <subdir+0x512>
  if (mkdir("dd/dd/ffff") == 0) {
    2de4:	00004517          	auipc	a0,0x4
    2de8:	b9450513          	addi	a0,a0,-1132 # 6978 <malloc+0x142c>
    2dec:	2a6020ef          	jal	5092 <mkdir>
    2df0:	2a050e63          	beqz	a0,30ac <subdir+0x526>
  if (unlink("dd/xx/ff") == 0) {
    2df4:	00004517          	auipc	a0,0x4
    2df8:	d4450513          	addi	a0,a0,-700 # 6b38 <malloc+0x15ec>
    2dfc:	27e020ef          	jal	507a <unlink>
    2e00:	2c050063          	beqz	a0,30c0 <subdir+0x53a>
  if (unlink("dd/ff/ff") == 0) {
    2e04:	00004517          	auipc	a0,0x4
    2e08:	d0450513          	addi	a0,a0,-764 # 6b08 <malloc+0x15bc>
    2e0c:	26e020ef          	jal	507a <unlink>
    2e10:	2c050263          	beqz	a0,30d4 <subdir+0x54e>
  if (chdir("dd/ff") == 0) {
    2e14:	00004517          	auipc	a0,0x4
    2e18:	a5c50513          	addi	a0,a0,-1444 # 6870 <malloc+0x1324>
    2e1c:	27e020ef          	jal	509a <chdir>
    2e20:	2c050463          	beqz	a0,30e8 <subdir+0x562>
  if (chdir("dd/xx") == 0) {
    2e24:	00004517          	auipc	a0,0x4
    2e28:	ef450513          	addi	a0,a0,-268 # 6d18 <malloc+0x17cc>
    2e2c:	26e020ef          	jal	509a <chdir>
    2e30:	2c050663          	beqz	a0,30fc <subdir+0x576>
  if (unlink("dd/dd/ffff") != 0) {
    2e34:	00004517          	auipc	a0,0x4
    2e38:	b4450513          	addi	a0,a0,-1212 # 6978 <malloc+0x142c>
    2e3c:	23e020ef          	jal	507a <unlink>
    2e40:	2c051863          	bnez	a0,3110 <subdir+0x58a>
  if (unlink("dd/ff") != 0) {
    2e44:	00004517          	auipc	a0,0x4
    2e48:	a2c50513          	addi	a0,a0,-1492 # 6870 <malloc+0x1324>
    2e4c:	22e020ef          	jal	507a <unlink>
    2e50:	2c051a63          	bnez	a0,3124 <subdir+0x59e>
  if (unlink("dd") == 0) {
    2e54:	00004517          	auipc	a0,0x4
    2e58:	9fc50513          	addi	a0,a0,-1540 # 6850 <malloc+0x1304>
    2e5c:	21e020ef          	jal	507a <unlink>
    2e60:	2c050c63          	beqz	a0,3138 <subdir+0x5b2>
  if (unlink("dd/dd") < 0) {
    2e64:	00004517          	auipc	a0,0x4
    2e68:	f2450513          	addi	a0,a0,-220 # 6d88 <malloc+0x183c>
    2e6c:	20e020ef          	jal	507a <unlink>
    2e70:	2c054e63          	bltz	a0,314c <subdir+0x5c6>
  if (unlink("dd") < 0) {
    2e74:	00004517          	auipc	a0,0x4
    2e78:	9dc50513          	addi	a0,a0,-1572 # 6850 <malloc+0x1304>
    2e7c:	1fe020ef          	jal	507a <unlink>
    2e80:	2e054063          	bltz	a0,3160 <subdir+0x5da>
}
    2e84:	60e2                	ld	ra,24(sp)
    2e86:	6442                	ld	s0,16(sp)
    2e88:	64a2                	ld	s1,8(sp)
    2e8a:	6902                	ld	s2,0(sp)
    2e8c:	6105                	addi	sp,sp,32
    2e8e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    2e90:	85ca                	mv	a1,s2
    2e92:	00004517          	auipc	a0,0x4
    2e96:	9c650513          	addi	a0,a0,-1594 # 6858 <malloc+0x130c>
    2e9a:	5f6020ef          	jal	5490 <printf>
    exit(1);
    2e9e:	4505                	li	a0,1
    2ea0:	18a020ef          	jal	502a <exit>
    printf("%s: create dd/ff failed\n", s);
    2ea4:	85ca                	mv	a1,s2
    2ea6:	00004517          	auipc	a0,0x4
    2eaa:	9d250513          	addi	a0,a0,-1582 # 6878 <malloc+0x132c>
    2eae:	5e2020ef          	jal	5490 <printf>
    exit(1);
    2eb2:	4505                	li	a0,1
    2eb4:	176020ef          	jal	502a <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    2eb8:	85ca                	mv	a1,s2
    2eba:	00004517          	auipc	a0,0x4
    2ebe:	9de50513          	addi	a0,a0,-1570 # 6898 <malloc+0x134c>
    2ec2:	5ce020ef          	jal	5490 <printf>
    exit(1);
    2ec6:	4505                	li	a0,1
    2ec8:	162020ef          	jal	502a <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    2ecc:	85ca                	mv	a1,s2
    2ece:	00004517          	auipc	a0,0x4
    2ed2:	a0250513          	addi	a0,a0,-1534 # 68d0 <malloc+0x1384>
    2ed6:	5ba020ef          	jal	5490 <printf>
    exit(1);
    2eda:	4505                	li	a0,1
    2edc:	14e020ef          	jal	502a <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    2ee0:	85ca                	mv	a1,s2
    2ee2:	00004517          	auipc	a0,0x4
    2ee6:	a1e50513          	addi	a0,a0,-1506 # 6900 <malloc+0x13b4>
    2eea:	5a6020ef          	jal	5490 <printf>
    exit(1);
    2eee:	4505                	li	a0,1
    2ef0:	13a020ef          	jal	502a <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    2ef4:	85ca                	mv	a1,s2
    2ef6:	00004517          	auipc	a0,0x4
    2efa:	a4250513          	addi	a0,a0,-1470 # 6938 <malloc+0x13ec>
    2efe:	592020ef          	jal	5490 <printf>
    exit(1);
    2f02:	4505                	li	a0,1
    2f04:	126020ef          	jal	502a <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    2f08:	85ca                	mv	a1,s2
    2f0a:	00004517          	auipc	a0,0x4
    2f0e:	a4e50513          	addi	a0,a0,-1458 # 6958 <malloc+0x140c>
    2f12:	57e020ef          	jal	5490 <printf>
    exit(1);
    2f16:	4505                	li	a0,1
    2f18:	112020ef          	jal	502a <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    2f1c:	85ca                	mv	a1,s2
    2f1e:	00004517          	auipc	a0,0x4
    2f22:	a6a50513          	addi	a0,a0,-1430 # 6988 <malloc+0x143c>
    2f26:	56a020ef          	jal	5490 <printf>
    exit(1);
    2f2a:	4505                	li	a0,1
    2f2c:	0fe020ef          	jal	502a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    2f30:	85ca                	mv	a1,s2
    2f32:	00004517          	auipc	a0,0x4
    2f36:	a7e50513          	addi	a0,a0,-1410 # 69b0 <malloc+0x1464>
    2f3a:	556020ef          	jal	5490 <printf>
    exit(1);
    2f3e:	4505                	li	a0,1
    2f40:	0ea020ef          	jal	502a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    2f44:	85ca                	mv	a1,s2
    2f46:	00004517          	auipc	a0,0x4
    2f4a:	a8a50513          	addi	a0,a0,-1398 # 69d0 <malloc+0x1484>
    2f4e:	542020ef          	jal	5490 <printf>
    exit(1);
    2f52:	4505                	li	a0,1
    2f54:	0d6020ef          	jal	502a <exit>
    printf("%s: chdir dd failed\n", s);
    2f58:	85ca                	mv	a1,s2
    2f5a:	00004517          	auipc	a0,0x4
    2f5e:	a9e50513          	addi	a0,a0,-1378 # 69f8 <malloc+0x14ac>
    2f62:	52e020ef          	jal	5490 <printf>
    exit(1);
    2f66:	4505                	li	a0,1
    2f68:	0c2020ef          	jal	502a <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    2f6c:	85ca                	mv	a1,s2
    2f6e:	00004517          	auipc	a0,0x4
    2f72:	ab250513          	addi	a0,a0,-1358 # 6a20 <malloc+0x14d4>
    2f76:	51a020ef          	jal	5490 <printf>
    exit(1);
    2f7a:	4505                	li	a0,1
    2f7c:	0ae020ef          	jal	502a <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    2f80:	85ca                	mv	a1,s2
    2f82:	00004517          	auipc	a0,0x4
    2f86:	ace50513          	addi	a0,a0,-1330 # 6a50 <malloc+0x1504>
    2f8a:	506020ef          	jal	5490 <printf>
    exit(1);
    2f8e:	4505                	li	a0,1
    2f90:	09a020ef          	jal	502a <exit>
    printf("%s: chdir ./.. failed\n", s);
    2f94:	85ca                	mv	a1,s2
    2f96:	00004517          	auipc	a0,0x4
    2f9a:	aea50513          	addi	a0,a0,-1302 # 6a80 <malloc+0x1534>
    2f9e:	4f2020ef          	jal	5490 <printf>
    exit(1);
    2fa2:	4505                	li	a0,1
    2fa4:	086020ef          	jal	502a <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    2fa8:	85ca                	mv	a1,s2
    2faa:	00004517          	auipc	a0,0x4
    2fae:	aee50513          	addi	a0,a0,-1298 # 6a98 <malloc+0x154c>
    2fb2:	4de020ef          	jal	5490 <printf>
    exit(1);
    2fb6:	4505                	li	a0,1
    2fb8:	072020ef          	jal	502a <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    2fbc:	85ca                	mv	a1,s2
    2fbe:	00004517          	auipc	a0,0x4
    2fc2:	afa50513          	addi	a0,a0,-1286 # 6ab8 <malloc+0x156c>
    2fc6:	4ca020ef          	jal	5490 <printf>
    exit(1);
    2fca:	4505                	li	a0,1
    2fcc:	05e020ef          	jal	502a <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    2fd0:	85ca                	mv	a1,s2
    2fd2:	00004517          	auipc	a0,0x4
    2fd6:	b0650513          	addi	a0,a0,-1274 # 6ad8 <malloc+0x158c>
    2fda:	4b6020ef          	jal	5490 <printf>
    exit(1);
    2fde:	4505                	li	a0,1
    2fe0:	04a020ef          	jal	502a <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    2fe4:	85ca                	mv	a1,s2
    2fe6:	00004517          	auipc	a0,0x4
    2fea:	b3250513          	addi	a0,a0,-1230 # 6b18 <malloc+0x15cc>
    2fee:	4a2020ef          	jal	5490 <printf>
    exit(1);
    2ff2:	4505                	li	a0,1
    2ff4:	036020ef          	jal	502a <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    2ff8:	85ca                	mv	a1,s2
    2ffa:	00004517          	auipc	a0,0x4
    2ffe:	b4e50513          	addi	a0,a0,-1202 # 6b48 <malloc+0x15fc>
    3002:	48e020ef          	jal	5490 <printf>
    exit(1);
    3006:	4505                	li	a0,1
    3008:	022020ef          	jal	502a <exit>
    printf("%s: create dd succeeded!\n", s);
    300c:	85ca                	mv	a1,s2
    300e:	00004517          	auipc	a0,0x4
    3012:	b5a50513          	addi	a0,a0,-1190 # 6b68 <malloc+0x161c>
    3016:	47a020ef          	jal	5490 <printf>
    exit(1);
    301a:	4505                	li	a0,1
    301c:	00e020ef          	jal	502a <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    3020:	85ca                	mv	a1,s2
    3022:	00004517          	auipc	a0,0x4
    3026:	b6650513          	addi	a0,a0,-1178 # 6b88 <malloc+0x163c>
    302a:	466020ef          	jal	5490 <printf>
    exit(1);
    302e:	4505                	li	a0,1
    3030:	7fb010ef          	jal	502a <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    3034:	85ca                	mv	a1,s2
    3036:	00004517          	auipc	a0,0x4
    303a:	b7250513          	addi	a0,a0,-1166 # 6ba8 <malloc+0x165c>
    303e:	452020ef          	jal	5490 <printf>
    exit(1);
    3042:	4505                	li	a0,1
    3044:	7e7010ef          	jal	502a <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    3048:	85ca                	mv	a1,s2
    304a:	00004517          	auipc	a0,0x4
    304e:	b8e50513          	addi	a0,a0,-1138 # 6bd8 <malloc+0x168c>
    3052:	43e020ef          	jal	5490 <printf>
    exit(1);
    3056:	4505                	li	a0,1
    3058:	7d3010ef          	jal	502a <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    305c:	85ca                	mv	a1,s2
    305e:	00004517          	auipc	a0,0x4
    3062:	ba250513          	addi	a0,a0,-1118 # 6c00 <malloc+0x16b4>
    3066:	42a020ef          	jal	5490 <printf>
    exit(1);
    306a:	4505                	li	a0,1
    306c:	7bf010ef          	jal	502a <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    3070:	85ca                	mv	a1,s2
    3072:	00004517          	auipc	a0,0x4
    3076:	bb650513          	addi	a0,a0,-1098 # 6c28 <malloc+0x16dc>
    307a:	416020ef          	jal	5490 <printf>
    exit(1);
    307e:	4505                	li	a0,1
    3080:	7ab010ef          	jal	502a <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3084:	85ca                	mv	a1,s2
    3086:	00004517          	auipc	a0,0x4
    308a:	bca50513          	addi	a0,a0,-1078 # 6c50 <malloc+0x1704>
    308e:	402020ef          	jal	5490 <printf>
    exit(1);
    3092:	4505                	li	a0,1
    3094:	797010ef          	jal	502a <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3098:	85ca                	mv	a1,s2
    309a:	00004517          	auipc	a0,0x4
    309e:	bd650513          	addi	a0,a0,-1066 # 6c70 <malloc+0x1724>
    30a2:	3ee020ef          	jal	5490 <printf>
    exit(1);
    30a6:	4505                	li	a0,1
    30a8:	783010ef          	jal	502a <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    30ac:	85ca                	mv	a1,s2
    30ae:	00004517          	auipc	a0,0x4
    30b2:	be250513          	addi	a0,a0,-1054 # 6c90 <malloc+0x1744>
    30b6:	3da020ef          	jal	5490 <printf>
    exit(1);
    30ba:	4505                	li	a0,1
    30bc:	76f010ef          	jal	502a <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    30c0:	85ca                	mv	a1,s2
    30c2:	00004517          	auipc	a0,0x4
    30c6:	bf650513          	addi	a0,a0,-1034 # 6cb8 <malloc+0x176c>
    30ca:	3c6020ef          	jal	5490 <printf>
    exit(1);
    30ce:	4505                	li	a0,1
    30d0:	75b010ef          	jal	502a <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    30d4:	85ca                	mv	a1,s2
    30d6:	00004517          	auipc	a0,0x4
    30da:	c0250513          	addi	a0,a0,-1022 # 6cd8 <malloc+0x178c>
    30de:	3b2020ef          	jal	5490 <printf>
    exit(1);
    30e2:	4505                	li	a0,1
    30e4:	747010ef          	jal	502a <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    30e8:	85ca                	mv	a1,s2
    30ea:	00004517          	auipc	a0,0x4
    30ee:	c0e50513          	addi	a0,a0,-1010 # 6cf8 <malloc+0x17ac>
    30f2:	39e020ef          	jal	5490 <printf>
    exit(1);
    30f6:	4505                	li	a0,1
    30f8:	733010ef          	jal	502a <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    30fc:	85ca                	mv	a1,s2
    30fe:	00004517          	auipc	a0,0x4
    3102:	c2250513          	addi	a0,a0,-990 # 6d20 <malloc+0x17d4>
    3106:	38a020ef          	jal	5490 <printf>
    exit(1);
    310a:	4505                	li	a0,1
    310c:	71f010ef          	jal	502a <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3110:	85ca                	mv	a1,s2
    3112:	00004517          	auipc	a0,0x4
    3116:	89e50513          	addi	a0,a0,-1890 # 69b0 <malloc+0x1464>
    311a:	376020ef          	jal	5490 <printf>
    exit(1);
    311e:	4505                	li	a0,1
    3120:	70b010ef          	jal	502a <exit>
    printf("%s: unlink dd/ff failed\n", s);
    3124:	85ca                	mv	a1,s2
    3126:	00004517          	auipc	a0,0x4
    312a:	c1a50513          	addi	a0,a0,-998 # 6d40 <malloc+0x17f4>
    312e:	362020ef          	jal	5490 <printf>
    exit(1);
    3132:	4505                	li	a0,1
    3134:	6f7010ef          	jal	502a <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    3138:	85ca                	mv	a1,s2
    313a:	00004517          	auipc	a0,0x4
    313e:	c2650513          	addi	a0,a0,-986 # 6d60 <malloc+0x1814>
    3142:	34e020ef          	jal	5490 <printf>
    exit(1);
    3146:	4505                	li	a0,1
    3148:	6e3010ef          	jal	502a <exit>
    printf("%s: unlink dd/dd failed\n", s);
    314c:	85ca                	mv	a1,s2
    314e:	00004517          	auipc	a0,0x4
    3152:	c4250513          	addi	a0,a0,-958 # 6d90 <malloc+0x1844>
    3156:	33a020ef          	jal	5490 <printf>
    exit(1);
    315a:	4505                	li	a0,1
    315c:	6cf010ef          	jal	502a <exit>
    printf("%s: unlink dd failed\n", s);
    3160:	85ca                	mv	a1,s2
    3162:	00004517          	auipc	a0,0x4
    3166:	c4e50513          	addi	a0,a0,-946 # 6db0 <malloc+0x1864>
    316a:	326020ef          	jal	5490 <printf>
    exit(1);
    316e:	4505                	li	a0,1
    3170:	6bb010ef          	jal	502a <exit>

0000000000003174 <rmdot>:
{
    3174:	1101                	addi	sp,sp,-32
    3176:	ec06                	sd	ra,24(sp)
    3178:	e822                	sd	s0,16(sp)
    317a:	e426                	sd	s1,8(sp)
    317c:	1000                	addi	s0,sp,32
    317e:	84aa                	mv	s1,a0
  if (mkdir("dots") != 0) {
    3180:	00004517          	auipc	a0,0x4
    3184:	c4850513          	addi	a0,a0,-952 # 6dc8 <malloc+0x187c>
    3188:	70b010ef          	jal	5092 <mkdir>
    318c:	e53d                	bnez	a0,31fa <rmdot+0x86>
  if (chdir("dots") != 0) {
    318e:	00004517          	auipc	a0,0x4
    3192:	c3a50513          	addi	a0,a0,-966 # 6dc8 <malloc+0x187c>
    3196:	705010ef          	jal	509a <chdir>
    319a:	e935                	bnez	a0,320e <rmdot+0x9a>
  if (unlink(".") == 0) {
    319c:	00003517          	auipc	a0,0x3
    31a0:	bc450513          	addi	a0,a0,-1084 # 5d60 <malloc+0x814>
    31a4:	6d7010ef          	jal	507a <unlink>
    31a8:	cd2d                	beqz	a0,3222 <rmdot+0xae>
  if (unlink("..") == 0) {
    31aa:	00003517          	auipc	a0,0x3
    31ae:	66e50513          	addi	a0,a0,1646 # 6818 <malloc+0x12cc>
    31b2:	6c9010ef          	jal	507a <unlink>
    31b6:	c141                	beqz	a0,3236 <rmdot+0xc2>
  if (chdir("/") != 0) {
    31b8:	00003517          	auipc	a0,0x3
    31bc:	60850513          	addi	a0,a0,1544 # 67c0 <malloc+0x1274>
    31c0:	6db010ef          	jal	509a <chdir>
    31c4:	e159                	bnez	a0,324a <rmdot+0xd6>
  if (unlink("dots/.") == 0) {
    31c6:	00004517          	auipc	a0,0x4
    31ca:	c6a50513          	addi	a0,a0,-918 # 6e30 <malloc+0x18e4>
    31ce:	6ad010ef          	jal	507a <unlink>
    31d2:	c551                	beqz	a0,325e <rmdot+0xea>
  if (unlink("dots/..") == 0) {
    31d4:	00004517          	auipc	a0,0x4
    31d8:	c8450513          	addi	a0,a0,-892 # 6e58 <malloc+0x190c>
    31dc:	69f010ef          	jal	507a <unlink>
    31e0:	c949                	beqz	a0,3272 <rmdot+0xfe>
  if (unlink("dots") != 0) {
    31e2:	00004517          	auipc	a0,0x4
    31e6:	be650513          	addi	a0,a0,-1050 # 6dc8 <malloc+0x187c>
    31ea:	691010ef          	jal	507a <unlink>
    31ee:	ed41                	bnez	a0,3286 <rmdot+0x112>
}
    31f0:	60e2                	ld	ra,24(sp)
    31f2:	6442                	ld	s0,16(sp)
    31f4:	64a2                	ld	s1,8(sp)
    31f6:	6105                	addi	sp,sp,32
    31f8:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    31fa:	85a6                	mv	a1,s1
    31fc:	00004517          	auipc	a0,0x4
    3200:	bd450513          	addi	a0,a0,-1068 # 6dd0 <malloc+0x1884>
    3204:	28c020ef          	jal	5490 <printf>
    exit(1);
    3208:	4505                	li	a0,1
    320a:	621010ef          	jal	502a <exit>
    printf("%s: chdir dots failed\n", s);
    320e:	85a6                	mv	a1,s1
    3210:	00004517          	auipc	a0,0x4
    3214:	bd850513          	addi	a0,a0,-1064 # 6de8 <malloc+0x189c>
    3218:	278020ef          	jal	5490 <printf>
    exit(1);
    321c:	4505                	li	a0,1
    321e:	60d010ef          	jal	502a <exit>
    printf("%s: rm . worked!\n", s);
    3222:	85a6                	mv	a1,s1
    3224:	00004517          	auipc	a0,0x4
    3228:	bdc50513          	addi	a0,a0,-1060 # 6e00 <malloc+0x18b4>
    322c:	264020ef          	jal	5490 <printf>
    exit(1);
    3230:	4505                	li	a0,1
    3232:	5f9010ef          	jal	502a <exit>
    printf("%s: rm .. worked!\n", s);
    3236:	85a6                	mv	a1,s1
    3238:	00004517          	auipc	a0,0x4
    323c:	be050513          	addi	a0,a0,-1056 # 6e18 <malloc+0x18cc>
    3240:	250020ef          	jal	5490 <printf>
    exit(1);
    3244:	4505                	li	a0,1
    3246:	5e5010ef          	jal	502a <exit>
    printf("%s: chdir / failed\n", s);
    324a:	85a6                	mv	a1,s1
    324c:	00003517          	auipc	a0,0x3
    3250:	57c50513          	addi	a0,a0,1404 # 67c8 <malloc+0x127c>
    3254:	23c020ef          	jal	5490 <printf>
    exit(1);
    3258:	4505                	li	a0,1
    325a:	5d1010ef          	jal	502a <exit>
    printf("%s: unlink dots/. worked!\n", s);
    325e:	85a6                	mv	a1,s1
    3260:	00004517          	auipc	a0,0x4
    3264:	bd850513          	addi	a0,a0,-1064 # 6e38 <malloc+0x18ec>
    3268:	228020ef          	jal	5490 <printf>
    exit(1);
    326c:	4505                	li	a0,1
    326e:	5bd010ef          	jal	502a <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    3272:	85a6                	mv	a1,s1
    3274:	00004517          	auipc	a0,0x4
    3278:	bec50513          	addi	a0,a0,-1044 # 6e60 <malloc+0x1914>
    327c:	214020ef          	jal	5490 <printf>
    exit(1);
    3280:	4505                	li	a0,1
    3282:	5a9010ef          	jal	502a <exit>
    printf("%s: unlink dots failed!\n", s);
    3286:	85a6                	mv	a1,s1
    3288:	00004517          	auipc	a0,0x4
    328c:	bf850513          	addi	a0,a0,-1032 # 6e80 <malloc+0x1934>
    3290:	200020ef          	jal	5490 <printf>
    exit(1);
    3294:	4505                	li	a0,1
    3296:	595010ef          	jal	502a <exit>

000000000000329a <dirfile>:
{
    329a:	1101                	addi	sp,sp,-32
    329c:	ec06                	sd	ra,24(sp)
    329e:	e822                	sd	s0,16(sp)
    32a0:	e426                	sd	s1,8(sp)
    32a2:	e04a                	sd	s2,0(sp)
    32a4:	1000                	addi	s0,sp,32
    32a6:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    32a8:	20000593          	li	a1,512
    32ac:	00004517          	auipc	a0,0x4
    32b0:	bf450513          	addi	a0,a0,-1036 # 6ea0 <malloc+0x1954>
    32b4:	5b7010ef          	jal	506a <open>
  if (fd < 0) {
    32b8:	0c054563          	bltz	a0,3382 <dirfile+0xe8>
  close(fd);
    32bc:	597010ef          	jal	5052 <close>
  if (chdir("dirfile") == 0) {
    32c0:	00004517          	auipc	a0,0x4
    32c4:	be050513          	addi	a0,a0,-1056 # 6ea0 <malloc+0x1954>
    32c8:	5d3010ef          	jal	509a <chdir>
    32cc:	c569                	beqz	a0,3396 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    32ce:	4581                	li	a1,0
    32d0:	00004517          	auipc	a0,0x4
    32d4:	c1850513          	addi	a0,a0,-1000 # 6ee8 <malloc+0x199c>
    32d8:	593010ef          	jal	506a <open>
  if (fd >= 0) {
    32dc:	0c055763          	bgez	a0,33aa <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    32e0:	20000593          	li	a1,512
    32e4:	00004517          	auipc	a0,0x4
    32e8:	c0450513          	addi	a0,a0,-1020 # 6ee8 <malloc+0x199c>
    32ec:	57f010ef          	jal	506a <open>
  if (fd >= 0) {
    32f0:	0c055763          	bgez	a0,33be <dirfile+0x124>
  if (mkdir("dirfile/xx") == 0) {
    32f4:	00004517          	auipc	a0,0x4
    32f8:	bf450513          	addi	a0,a0,-1036 # 6ee8 <malloc+0x199c>
    32fc:	597010ef          	jal	5092 <mkdir>
    3300:	0c050963          	beqz	a0,33d2 <dirfile+0x138>
  if (unlink("dirfile/xx") == 0) {
    3304:	00004517          	auipc	a0,0x4
    3308:	be450513          	addi	a0,a0,-1052 # 6ee8 <malloc+0x199c>
    330c:	56f010ef          	jal	507a <unlink>
    3310:	0c050b63          	beqz	a0,33e6 <dirfile+0x14c>
  if (link("README", "dirfile/xx") == 0) {
    3314:	00004597          	auipc	a1,0x4
    3318:	bd458593          	addi	a1,a1,-1068 # 6ee8 <malloc+0x199c>
    331c:	00002517          	auipc	a0,0x2
    3320:	53450513          	addi	a0,a0,1332 # 5850 <malloc+0x304>
    3324:	567010ef          	jal	508a <link>
    3328:	0c050963          	beqz	a0,33fa <dirfile+0x160>
  if (unlink("dirfile") != 0) {
    332c:	00004517          	auipc	a0,0x4
    3330:	b7450513          	addi	a0,a0,-1164 # 6ea0 <malloc+0x1954>
    3334:	547010ef          	jal	507a <unlink>
    3338:	0c051b63          	bnez	a0,340e <dirfile+0x174>
  fd = open(".", O_RDWR);
    333c:	4589                	li	a1,2
    333e:	00003517          	auipc	a0,0x3
    3342:	a2250513          	addi	a0,a0,-1502 # 5d60 <malloc+0x814>
    3346:	525010ef          	jal	506a <open>
  if (fd >= 0) {
    334a:	0c055c63          	bgez	a0,3422 <dirfile+0x188>
  fd = open(".", 0);
    334e:	4581                	li	a1,0
    3350:	00003517          	auipc	a0,0x3
    3354:	a1050513          	addi	a0,a0,-1520 # 5d60 <malloc+0x814>
    3358:	513010ef          	jal	506a <open>
    335c:	84aa                	mv	s1,a0
  if (write(fd, "x", 1) > 0) {
    335e:	4605                	li	a2,1
    3360:	00002597          	auipc	a1,0x2
    3364:	38858593          	addi	a1,a1,904 # 56e8 <malloc+0x19c>
    3368:	4e3010ef          	jal	504a <write>
    336c:	0ca04563          	bgtz	a0,3436 <dirfile+0x19c>
  close(fd);
    3370:	8526                	mv	a0,s1
    3372:	4e1010ef          	jal	5052 <close>
}
    3376:	60e2                	ld	ra,24(sp)
    3378:	6442                	ld	s0,16(sp)
    337a:	64a2                	ld	s1,8(sp)
    337c:	6902                	ld	s2,0(sp)
    337e:	6105                	addi	sp,sp,32
    3380:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3382:	85ca                	mv	a1,s2
    3384:	00004517          	auipc	a0,0x4
    3388:	b2450513          	addi	a0,a0,-1244 # 6ea8 <malloc+0x195c>
    338c:	104020ef          	jal	5490 <printf>
    exit(1);
    3390:	4505                	li	a0,1
    3392:	499010ef          	jal	502a <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3396:	85ca                	mv	a1,s2
    3398:	00004517          	auipc	a0,0x4
    339c:	b3050513          	addi	a0,a0,-1232 # 6ec8 <malloc+0x197c>
    33a0:	0f0020ef          	jal	5490 <printf>
    exit(1);
    33a4:	4505                	li	a0,1
    33a6:	485010ef          	jal	502a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33aa:	85ca                	mv	a1,s2
    33ac:	00004517          	auipc	a0,0x4
    33b0:	b4c50513          	addi	a0,a0,-1204 # 6ef8 <malloc+0x19ac>
    33b4:	0dc020ef          	jal	5490 <printf>
    exit(1);
    33b8:	4505                	li	a0,1
    33ba:	471010ef          	jal	502a <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    33be:	85ca                	mv	a1,s2
    33c0:	00004517          	auipc	a0,0x4
    33c4:	b3850513          	addi	a0,a0,-1224 # 6ef8 <malloc+0x19ac>
    33c8:	0c8020ef          	jal	5490 <printf>
    exit(1);
    33cc:	4505                	li	a0,1
    33ce:	45d010ef          	jal	502a <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    33d2:	85ca                	mv	a1,s2
    33d4:	00004517          	auipc	a0,0x4
    33d8:	b4c50513          	addi	a0,a0,-1204 # 6f20 <malloc+0x19d4>
    33dc:	0b4020ef          	jal	5490 <printf>
    exit(1);
    33e0:	4505                	li	a0,1
    33e2:	449010ef          	jal	502a <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    33e6:	85ca                	mv	a1,s2
    33e8:	00004517          	auipc	a0,0x4
    33ec:	b6050513          	addi	a0,a0,-1184 # 6f48 <malloc+0x19fc>
    33f0:	0a0020ef          	jal	5490 <printf>
    exit(1);
    33f4:	4505                	li	a0,1
    33f6:	435010ef          	jal	502a <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    33fa:	85ca                	mv	a1,s2
    33fc:	00004517          	auipc	a0,0x4
    3400:	b7450513          	addi	a0,a0,-1164 # 6f70 <malloc+0x1a24>
    3404:	08c020ef          	jal	5490 <printf>
    exit(1);
    3408:	4505                	li	a0,1
    340a:	421010ef          	jal	502a <exit>
    printf("%s: unlink dirfile failed!\n", s);
    340e:	85ca                	mv	a1,s2
    3410:	00004517          	auipc	a0,0x4
    3414:	b8850513          	addi	a0,a0,-1144 # 6f98 <malloc+0x1a4c>
    3418:	078020ef          	jal	5490 <printf>
    exit(1);
    341c:	4505                	li	a0,1
    341e:	40d010ef          	jal	502a <exit>
    printf("%s: open . for writing succeeded!\n", s);
    3422:	85ca                	mv	a1,s2
    3424:	00004517          	auipc	a0,0x4
    3428:	b9450513          	addi	a0,a0,-1132 # 6fb8 <malloc+0x1a6c>
    342c:	064020ef          	jal	5490 <printf>
    exit(1);
    3430:	4505                	li	a0,1
    3432:	3f9010ef          	jal	502a <exit>
    printf("%s: write . succeeded!\n", s);
    3436:	85ca                	mv	a1,s2
    3438:	00004517          	auipc	a0,0x4
    343c:	ba850513          	addi	a0,a0,-1112 # 6fe0 <malloc+0x1a94>
    3440:	050020ef          	jal	5490 <printf>
    exit(1);
    3444:	4505                	li	a0,1
    3446:	3e5010ef          	jal	502a <exit>

000000000000344a <iref>:
{
    344a:	715d                	addi	sp,sp,-80
    344c:	e486                	sd	ra,72(sp)
    344e:	e0a2                	sd	s0,64(sp)
    3450:	fc26                	sd	s1,56(sp)
    3452:	f84a                	sd	s2,48(sp)
    3454:	f44e                	sd	s3,40(sp)
    3456:	f052                	sd	s4,32(sp)
    3458:	ec56                	sd	s5,24(sp)
    345a:	e85a                	sd	s6,16(sp)
    345c:	e45e                	sd	s7,8(sp)
    345e:	0880                	addi	s0,sp,80
    3460:	8baa                	mv	s7,a0
    3462:	03300913          	li	s2,51
    if (mkdir("irefd") != 0) {
    3466:	00004a97          	auipc	s5,0x4
    346a:	b92a8a93          	addi	s5,s5,-1134 # 6ff8 <malloc+0x1aac>
    mkdir("");
    346e:	00003497          	auipc	s1,0x3
    3472:	69248493          	addi	s1,s1,1682 # 6b00 <malloc+0x15b4>
    link("README", "");
    3476:	00002b17          	auipc	s6,0x2
    347a:	3dab0b13          	addi	s6,s6,986 # 5850 <malloc+0x304>
    fd = open("", O_CREATE);
    347e:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3482:	00004997          	auipc	s3,0x4
    3486:	a6e98993          	addi	s3,s3,-1426 # 6ef0 <malloc+0x19a4>
    348a:	a835                	j	34c6 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    348c:	85de                	mv	a1,s7
    348e:	00004517          	auipc	a0,0x4
    3492:	b7250513          	addi	a0,a0,-1166 # 7000 <malloc+0x1ab4>
    3496:	7fb010ef          	jal	5490 <printf>
      exit(1);
    349a:	4505                	li	a0,1
    349c:	38f010ef          	jal	502a <exit>
      printf("%s: chdir irefd failed\n", s);
    34a0:	85de                	mv	a1,s7
    34a2:	00004517          	auipc	a0,0x4
    34a6:	b7650513          	addi	a0,a0,-1162 # 7018 <malloc+0x1acc>
    34aa:	7e7010ef          	jal	5490 <printf>
      exit(1);
    34ae:	4505                	li	a0,1
    34b0:	37b010ef          	jal	502a <exit>
      close(fd);
    34b4:	39f010ef          	jal	5052 <close>
    34b8:	a825                	j	34f0 <iref+0xa6>
    unlink("xx");
    34ba:	854e                	mv	a0,s3
    34bc:	3bf010ef          	jal	507a <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    34c0:	397d                	addiw	s2,s2,-1
    34c2:	04090063          	beqz	s2,3502 <iref+0xb8>
    if (mkdir("irefd") != 0) {
    34c6:	8556                	mv	a0,s5
    34c8:	3cb010ef          	jal	5092 <mkdir>
    34cc:	f161                	bnez	a0,348c <iref+0x42>
    if (chdir("irefd") != 0) {
    34ce:	8556                	mv	a0,s5
    34d0:	3cb010ef          	jal	509a <chdir>
    34d4:	f571                	bnez	a0,34a0 <iref+0x56>
    mkdir("");
    34d6:	8526                	mv	a0,s1
    34d8:	3bb010ef          	jal	5092 <mkdir>
    link("README", "");
    34dc:	85a6                	mv	a1,s1
    34de:	855a                	mv	a0,s6
    34e0:	3ab010ef          	jal	508a <link>
    fd = open("", O_CREATE);
    34e4:	85d2                	mv	a1,s4
    34e6:	8526                	mv	a0,s1
    34e8:	383010ef          	jal	506a <open>
    if (fd >= 0)
    34ec:	fc0554e3          	bgez	a0,34b4 <iref+0x6a>
    fd = open("xx", O_CREATE);
    34f0:	85d2                	mv	a1,s4
    34f2:	854e                	mv	a0,s3
    34f4:	377010ef          	jal	506a <open>
    if (fd >= 0)
    34f8:	fc0541e3          	bltz	a0,34ba <iref+0x70>
      close(fd);
    34fc:	357010ef          	jal	5052 <close>
    3500:	bf6d                	j	34ba <iref+0x70>
  for (i = 0; i < NINODE + 1; i++) {
    3502:	03300493          	li	s1,51
    chdir("..");
    3506:	00003997          	auipc	s3,0x3
    350a:	31298993          	addi	s3,s3,786 # 6818 <malloc+0x12cc>
    unlink("irefd");
    350e:	00004917          	auipc	s2,0x4
    3512:	aea90913          	addi	s2,s2,-1302 # 6ff8 <malloc+0x1aac>
    chdir("..");
    3516:	854e                	mv	a0,s3
    3518:	383010ef          	jal	509a <chdir>
    unlink("irefd");
    351c:	854a                	mv	a0,s2
    351e:	35d010ef          	jal	507a <unlink>
  for (i = 0; i < NINODE + 1; i++) {
    3522:	34fd                	addiw	s1,s1,-1
    3524:	f8ed                	bnez	s1,3516 <iref+0xcc>
  chdir("/");
    3526:	00003517          	auipc	a0,0x3
    352a:	29a50513          	addi	a0,a0,666 # 67c0 <malloc+0x1274>
    352e:	36d010ef          	jal	509a <chdir>
}
    3532:	60a6                	ld	ra,72(sp)
    3534:	6406                	ld	s0,64(sp)
    3536:	74e2                	ld	s1,56(sp)
    3538:	7942                	ld	s2,48(sp)
    353a:	79a2                	ld	s3,40(sp)
    353c:	7a02                	ld	s4,32(sp)
    353e:	6ae2                	ld	s5,24(sp)
    3540:	6b42                	ld	s6,16(sp)
    3542:	6ba2                	ld	s7,8(sp)
    3544:	6161                	addi	sp,sp,80
    3546:	8082                	ret

0000000000003548 <openiputtest>:
{
    3548:	7179                	addi	sp,sp,-48
    354a:	f406                	sd	ra,40(sp)
    354c:	f022                	sd	s0,32(sp)
    354e:	ec26                	sd	s1,24(sp)
    3550:	1800                	addi	s0,sp,48
    3552:	84aa                	mv	s1,a0
  if (mkdir("oidir") < 0) {
    3554:	00004517          	auipc	a0,0x4
    3558:	adc50513          	addi	a0,a0,-1316 # 7030 <malloc+0x1ae4>
    355c:	337010ef          	jal	5092 <mkdir>
    3560:	02054a63          	bltz	a0,3594 <openiputtest+0x4c>
  pid = fork();
    3564:	2bf010ef          	jal	5022 <fork>
  if (pid < 0) {
    3568:	04054063          	bltz	a0,35a8 <openiputtest+0x60>
  if (pid == 0) {
    356c:	e939                	bnez	a0,35c2 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    356e:	4589                	li	a1,2
    3570:	00004517          	auipc	a0,0x4
    3574:	ac050513          	addi	a0,a0,-1344 # 7030 <malloc+0x1ae4>
    3578:	2f3010ef          	jal	506a <open>
    if (fd >= 0) {
    357c:	04054063          	bltz	a0,35bc <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3580:	85a6                	mv	a1,s1
    3582:	00004517          	auipc	a0,0x4
    3586:	ace50513          	addi	a0,a0,-1330 # 7050 <malloc+0x1b04>
    358a:	707010ef          	jal	5490 <printf>
      exit(1);
    358e:	4505                	li	a0,1
    3590:	29b010ef          	jal	502a <exit>
    printf("%s: mkdir oidir failed\n", s);
    3594:	85a6                	mv	a1,s1
    3596:	00004517          	auipc	a0,0x4
    359a:	aa250513          	addi	a0,a0,-1374 # 7038 <malloc+0x1aec>
    359e:	6f3010ef          	jal	5490 <printf>
    exit(1);
    35a2:	4505                	li	a0,1
    35a4:	287010ef          	jal	502a <exit>
    printf("%s: fork failed\n", s);
    35a8:	85a6                	mv	a1,s1
    35aa:	00003517          	auipc	a0,0x3
    35ae:	95e50513          	addi	a0,a0,-1698 # 5f08 <malloc+0x9bc>
    35b2:	6df010ef          	jal	5490 <printf>
    exit(1);
    35b6:	4505                	li	a0,1
    35b8:	273010ef          	jal	502a <exit>
    exit(0);
    35bc:	4501                	li	a0,0
    35be:	26d010ef          	jal	502a <exit>
  pause(1);
    35c2:	4505                	li	a0,1
    35c4:	2f7010ef          	jal	50ba <pause>
  if (unlink("oidir") != 0) {
    35c8:	00004517          	auipc	a0,0x4
    35cc:	a6850513          	addi	a0,a0,-1432 # 7030 <malloc+0x1ae4>
    35d0:	2ab010ef          	jal	507a <unlink>
    35d4:	c919                	beqz	a0,35ea <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    35d6:	85a6                	mv	a1,s1
    35d8:	00003517          	auipc	a0,0x3
    35dc:	ab850513          	addi	a0,a0,-1352 # 6090 <malloc+0xb44>
    35e0:	6b1010ef          	jal	5490 <printf>
    exit(1);
    35e4:	4505                	li	a0,1
    35e6:	245010ef          	jal	502a <exit>
  wait(&xstatus);
    35ea:	fdc40513          	addi	a0,s0,-36
    35ee:	245010ef          	jal	5032 <wait>
  exit(xstatus);
    35f2:	fdc42503          	lw	a0,-36(s0)
    35f6:	235010ef          	jal	502a <exit>

00000000000035fa <forkforkfork>:
{
    35fa:	1101                	addi	sp,sp,-32
    35fc:	ec06                	sd	ra,24(sp)
    35fe:	e822                	sd	s0,16(sp)
    3600:	e426                	sd	s1,8(sp)
    3602:	1000                	addi	s0,sp,32
    3604:	84aa                	mv	s1,a0
  unlink("stopforking");
    3606:	00004517          	auipc	a0,0x4
    360a:	a7250513          	addi	a0,a0,-1422 # 7078 <malloc+0x1b2c>
    360e:	26d010ef          	jal	507a <unlink>
  int pid = fork();
    3612:	211010ef          	jal	5022 <fork>
  if (pid < 0) {
    3616:	02054b63          	bltz	a0,364c <forkforkfork+0x52>
  if (pid == 0) {
    361a:	c125                	beqz	a0,367a <forkforkfork+0x80>
  pause(20); // two seconds
    361c:	4551                	li	a0,20
    361e:	29d010ef          	jal	50ba <pause>
  close(open("stopforking", O_CREATE | O_RDWR));
    3622:	20200593          	li	a1,514
    3626:	00004517          	auipc	a0,0x4
    362a:	a5250513          	addi	a0,a0,-1454 # 7078 <malloc+0x1b2c>
    362e:	23d010ef          	jal	506a <open>
    3632:	221010ef          	jal	5052 <close>
  wait(0);
    3636:	4501                	li	a0,0
    3638:	1fb010ef          	jal	5032 <wait>
  pause(10); // one second
    363c:	4529                	li	a0,10
    363e:	27d010ef          	jal	50ba <pause>
}
    3642:	60e2                	ld	ra,24(sp)
    3644:	6442                	ld	s0,16(sp)
    3646:	64a2                	ld	s1,8(sp)
    3648:	6105                	addi	sp,sp,32
    364a:	8082                	ret
    printf("%s: fork failed", s);
    364c:	85a6                	mv	a1,s1
    364e:	00003517          	auipc	a0,0x3
    3652:	9fa50513          	addi	a0,a0,-1542 # 6048 <malloc+0xafc>
    3656:	63b010ef          	jal	5490 <printf>
    exit(1);
    365a:	4505                	li	a0,1
    365c:	1cf010ef          	jal	502a <exit>
        exit(0);
    3660:	4501                	li	a0,0
    3662:	1c9010ef          	jal	502a <exit>
        close(open("stopforking", O_CREATE | O_RDWR));
    3666:	20200593          	li	a1,514
    366a:	00004517          	auipc	a0,0x4
    366e:	a0e50513          	addi	a0,a0,-1522 # 7078 <malloc+0x1b2c>
    3672:	1f9010ef          	jal	506a <open>
    3676:	1dd010ef          	jal	5052 <close>
      int fd = open("stopforking", 0);
    367a:	4581                	li	a1,0
    367c:	00004517          	auipc	a0,0x4
    3680:	9fc50513          	addi	a0,a0,-1540 # 7078 <malloc+0x1b2c>
    3684:	1e7010ef          	jal	506a <open>
      if (fd >= 0) {
    3688:	fc055ce3          	bgez	a0,3660 <forkforkfork+0x66>
      if (fork() < 0) {
    368c:	197010ef          	jal	5022 <fork>
    3690:	fe0555e3          	bgez	a0,367a <forkforkfork+0x80>
    3694:	bfc9                	j	3666 <forkforkfork+0x6c>

0000000000003696 <exectest>:
{
    3696:	711d                	addi	sp,sp,-96
    3698:	ec86                	sd	ra,88(sp)
    369a:	e8a2                	sd	s0,80(sp)
    369c:	e0ca                	sd	s2,64(sp)
    369e:	1080                	addi	s0,sp,96
    36a0:	892a                	mv	s2,a0
  char *echoargv[] = {"echo", "OK", 0};
    36a2:	00002797          	auipc	a5,0x2
    36a6:	fd678793          	addi	a5,a5,-42 # 5678 <malloc+0x12c>
    36aa:	faf43823          	sd	a5,-80(s0)
    36ae:	00004797          	auipc	a5,0x4
    36b2:	9da78793          	addi	a5,a5,-1574 # 7088 <malloc+0x1b3c>
    36b6:	faf43c23          	sd	a5,-72(s0)
    36ba:	fc043023          	sd	zero,-64(s0)
  unlink("echo-ok");
    36be:	00004517          	auipc	a0,0x4
    36c2:	9d250513          	addi	a0,a0,-1582 # 7090 <malloc+0x1b44>
    36c6:	1b5010ef          	jal	507a <unlink>
  pid = fork();
    36ca:	159010ef          	jal	5022 <fork>
  if (pid < 0) {
    36ce:	04054763          	bltz	a0,371c <exectest+0x86>
    36d2:	e4a6                	sd	s1,72(sp)
    36d4:	fc4e                	sd	s3,56(sp)
    36d6:	84aa                	mv	s1,a0
  if (pid == 0) {
    36d8:	ed49                	bnez	a0,3772 <exectest+0xdc>
    int errfd = dup(1);
    36da:	4505                	li	a0,1
    36dc:	1c7010ef          	jal	50a2 <dup>
    36e0:	89aa                	mv	s3,a0
    if (errfd < 0) {
    36e2:	04054963          	bltz	a0,3734 <exectest+0x9e>
    close(1);
    36e6:	4505                	li	a0,1
    36e8:	16b010ef          	jal	5052 <close>
    fd = open("echo-ok", O_CREATE | O_WRONLY);
    36ec:	20100593          	li	a1,513
    36f0:	00004517          	auipc	a0,0x4
    36f4:	9a050513          	addi	a0,a0,-1632 # 7090 <malloc+0x1b44>
    36f8:	173010ef          	jal	506a <open>
    if (fd < 0) {
    36fc:	04054663          	bltz	a0,3748 <exectest+0xb2>
    if (fd != 1) {
    3700:	4785                	li	a5,1
    3702:	04f50e63          	beq	a0,a5,375e <exectest+0xc8>
      fprintf(errfd, "%s: wrong fd\n", s);
    3706:	864a                	mv	a2,s2
    3708:	00004597          	auipc	a1,0x4
    370c:	9a058593          	addi	a1,a1,-1632 # 70a8 <malloc+0x1b5c>
    3710:	854e                	mv	a0,s3
    3712:	555010ef          	jal	5466 <fprintf>
      exit(1);
    3716:	4505                	li	a0,1
    3718:	113010ef          	jal	502a <exit>
    371c:	e4a6                	sd	s1,72(sp)
    371e:	fc4e                	sd	s3,56(sp)
    printf("%s: fork failed\n", s);
    3720:	85ca                	mv	a1,s2
    3722:	00002517          	auipc	a0,0x2
    3726:	7e650513          	addi	a0,a0,2022 # 5f08 <malloc+0x9bc>
    372a:	567010ef          	jal	5490 <printf>
    exit(1);
    372e:	4505                	li	a0,1
    3730:	0fb010ef          	jal	502a <exit>
      printf("%s: dup failed\n", s);
    3734:	85ca                	mv	a1,s2
    3736:	00004517          	auipc	a0,0x4
    373a:	96250513          	addi	a0,a0,-1694 # 7098 <malloc+0x1b4c>
    373e:	553010ef          	jal	5490 <printf>
      exit(1);
    3742:	4505                	li	a0,1
    3744:	0e7010ef          	jal	502a <exit>
      fprintf(errfd, "%s: create failed\n", s);
    3748:	864a                	mv	a2,s2
    374a:	00003597          	auipc	a1,0x3
    374e:	92e58593          	addi	a1,a1,-1746 # 6078 <malloc+0xb2c>
    3752:	854e                	mv	a0,s3
    3754:	513010ef          	jal	5466 <fprintf>
      exit(1);
    3758:	4505                	li	a0,1
    375a:	0d1010ef          	jal	502a <exit>
    if (exec("echo", echoargv) < 0) {
    375e:	fb040593          	addi	a1,s0,-80
    3762:	00002517          	auipc	a0,0x2
    3766:	f1650513          	addi	a0,a0,-234 # 5678 <malloc+0x12c>
    376a:	0f9010ef          	jal	5062 <exec>
    376e:	02054563          	bltz	a0,3798 <exectest+0x102>
  if (wait(&xstatus) != pid) {
    3772:	fcc40513          	addi	a0,s0,-52
    3776:	0bd010ef          	jal	5032 <wait>
    377a:	02951a63          	bne	a0,s1,37ae <exectest+0x118>
  if (xstatus != 0) {
    377e:	fcc42603          	lw	a2,-52(s0)
    3782:	ce15                	beqz	a2,37be <exectest+0x128>
    printf("%s: nonzero wait status %d\n", s, xstatus);
    3784:	85ca                	mv	a1,s2
    3786:	00004517          	auipc	a0,0x4
    378a:	96250513          	addi	a0,a0,-1694 # 70e8 <malloc+0x1b9c>
    378e:	503010ef          	jal	5490 <printf>
    exit(1);
    3792:	4505                	li	a0,1
    3794:	097010ef          	jal	502a <exit>
      fprintf(errfd, "%s: exec echo failed\n", s);
    3798:	864a                	mv	a2,s2
    379a:	00004597          	auipc	a1,0x4
    379e:	91e58593          	addi	a1,a1,-1762 # 70b8 <malloc+0x1b6c>
    37a2:	854e                	mv	a0,s3
    37a4:	4c3010ef          	jal	5466 <fprintf>
      exit(1);
    37a8:	4505                	li	a0,1
    37aa:	081010ef          	jal	502a <exit>
    printf("%s: wait failed!\n", s);
    37ae:	85ca                	mv	a1,s2
    37b0:	00004517          	auipc	a0,0x4
    37b4:	92050513          	addi	a0,a0,-1760 # 70d0 <malloc+0x1b84>
    37b8:	4d9010ef          	jal	5490 <printf>
    37bc:	b7c9                	j	377e <exectest+0xe8>
  fd = open("echo-ok", O_RDONLY);
    37be:	4581                	li	a1,0
    37c0:	00004517          	auipc	a0,0x4
    37c4:	8d050513          	addi	a0,a0,-1840 # 7090 <malloc+0x1b44>
    37c8:	0a3010ef          	jal	506a <open>
  if (fd < 0) {
    37cc:	02054463          	bltz	a0,37f4 <exectest+0x15e>
  if (read(fd, buf, 2) != 2) {
    37d0:	4609                	li	a2,2
    37d2:	fa840593          	addi	a1,s0,-88
    37d6:	06d010ef          	jal	5042 <read>
    37da:	4789                	li	a5,2
    37dc:	02f50663          	beq	a0,a5,3808 <exectest+0x172>
    printf("%s: read failed\n", s);
    37e0:	85ca                	mv	a1,s2
    37e2:	00002517          	auipc	a0,0x2
    37e6:	26650513          	addi	a0,a0,614 # 5a48 <malloc+0x4fc>
    37ea:	4a7010ef          	jal	5490 <printf>
    exit(1);
    37ee:	4505                	li	a0,1
    37f0:	03b010ef          	jal	502a <exit>
    printf("%s: open failed\n", s);
    37f4:	85ca                	mv	a1,s2
    37f6:	00002517          	auipc	a0,0x2
    37fa:	72a50513          	addi	a0,a0,1834 # 5f20 <malloc+0x9d4>
    37fe:	493010ef          	jal	5490 <printf>
    exit(1);
    3802:	4505                	li	a0,1
    3804:	027010ef          	jal	502a <exit>
  unlink("echo-ok");
    3808:	00004517          	auipc	a0,0x4
    380c:	88850513          	addi	a0,a0,-1912 # 7090 <malloc+0x1b44>
    3810:	06b010ef          	jal	507a <unlink>
  if (buf[0] == 'O' && buf[1] == 'K')
    3814:	fa844703          	lbu	a4,-88(s0)
    3818:	04f00793          	li	a5,79
    381c:	00f71863          	bne	a4,a5,382c <exectest+0x196>
    3820:	fa944703          	lbu	a4,-87(s0)
    3824:	04b00793          	li	a5,75
    3828:	00f70c63          	beq	a4,a5,3840 <exectest+0x1aa>
    printf("%s: wrong output\n", s);
    382c:	85ca                	mv	a1,s2
    382e:	00004517          	auipc	a0,0x4
    3832:	8da50513          	addi	a0,a0,-1830 # 7108 <malloc+0x1bbc>
    3836:	45b010ef          	jal	5490 <printf>
    exit(1);
    383a:	4505                	li	a0,1
    383c:	7ee010ef          	jal	502a <exit>
    exit(0);
    3840:	4501                	li	a0,0
    3842:	7e8010ef          	jal	502a <exit>

0000000000003846 <killstatus>:
{
    3846:	715d                	addi	sp,sp,-80
    3848:	e486                	sd	ra,72(sp)
    384a:	e0a2                	sd	s0,64(sp)
    384c:	fc26                	sd	s1,56(sp)
    384e:	f84a                	sd	s2,48(sp)
    3850:	f44e                	sd	s3,40(sp)
    3852:	f052                	sd	s4,32(sp)
    3854:	ec56                	sd	s5,24(sp)
    3856:	e85a                	sd	s6,16(sp)
    3858:	0880                	addi	s0,sp,80
    385a:	8b2a                	mv	s6,a0
    385c:	06400913          	li	s2,100
    pause(1);
    3860:	4a85                	li	s5,1
    wait(&xst);
    3862:	fbc40a13          	addi	s4,s0,-68
    if (xst != -1) {
    3866:	59fd                	li	s3,-1
    int pid1 = fork();
    3868:	7ba010ef          	jal	5022 <fork>
    386c:	84aa                	mv	s1,a0
    if (pid1 < 0) {
    386e:	02054663          	bltz	a0,389a <killstatus+0x54>
    if (pid1 == 0) {
    3872:	cd15                	beqz	a0,38ae <killstatus+0x68>
    pause(1);
    3874:	8556                	mv	a0,s5
    3876:	045010ef          	jal	50ba <pause>
    kill(pid1);
    387a:	8526                	mv	a0,s1
    387c:	7de010ef          	jal	505a <kill>
    wait(&xst);
    3880:	8552                	mv	a0,s4
    3882:	7b0010ef          	jal	5032 <wait>
    if (xst != -1) {
    3886:	fbc42783          	lw	a5,-68(s0)
    388a:	03379563          	bne	a5,s3,38b4 <killstatus+0x6e>
  for (int i = 0; i < 100; i++) {
    388e:	397d                	addiw	s2,s2,-1
    3890:	fc091ce3          	bnez	s2,3868 <killstatus+0x22>
  exit(0);
    3894:	4501                	li	a0,0
    3896:	794010ef          	jal	502a <exit>
      printf("%s: fork failed\n", s);
    389a:	85da                	mv	a1,s6
    389c:	00002517          	auipc	a0,0x2
    38a0:	66c50513          	addi	a0,a0,1644 # 5f08 <malloc+0x9bc>
    38a4:	3ed010ef          	jal	5490 <printf>
      exit(1);
    38a8:	4505                	li	a0,1
    38aa:	780010ef          	jal	502a <exit>
        getpid();
    38ae:	7fc010ef          	jal	50aa <getpid>
      while (1) {
    38b2:	bff5                	j	38ae <killstatus+0x68>
      printf("%s: status should be -1\n", s);
    38b4:	85da                	mv	a1,s6
    38b6:	00004517          	auipc	a0,0x4
    38ba:	86a50513          	addi	a0,a0,-1942 # 7120 <malloc+0x1bd4>
    38be:	3d3010ef          	jal	5490 <printf>
      exit(1);
    38c2:	4505                	li	a0,1
    38c4:	766010ef          	jal	502a <exit>

00000000000038c8 <preempt>:
{
    38c8:	7139                	addi	sp,sp,-64
    38ca:	fc06                	sd	ra,56(sp)
    38cc:	f822                	sd	s0,48(sp)
    38ce:	f426                	sd	s1,40(sp)
    38d0:	f04a                	sd	s2,32(sp)
    38d2:	ec4e                	sd	s3,24(sp)
    38d4:	e852                	sd	s4,16(sp)
    38d6:	0080                	addi	s0,sp,64
    38d8:	892a                	mv	s2,a0
  pid1 = fork();
    38da:	748010ef          	jal	5022 <fork>
  if (pid1 < 0) {
    38de:	00054563          	bltz	a0,38e8 <preempt+0x20>
    38e2:	84aa                	mv	s1,a0
  if (pid1 == 0)
    38e4:	ed01                	bnez	a0,38fc <preempt+0x34>
    for (;;)
    38e6:	a001                	j	38e6 <preempt+0x1e>
    printf("%s: fork failed", s);
    38e8:	85ca                	mv	a1,s2
    38ea:	00002517          	auipc	a0,0x2
    38ee:	75e50513          	addi	a0,a0,1886 # 6048 <malloc+0xafc>
    38f2:	39f010ef          	jal	5490 <printf>
    exit(1);
    38f6:	4505                	li	a0,1
    38f8:	732010ef          	jal	502a <exit>
  pid2 = fork();
    38fc:	726010ef          	jal	5022 <fork>
    3900:	89aa                	mv	s3,a0
  if (pid2 < 0) {
    3902:	00054463          	bltz	a0,390a <preempt+0x42>
  if (pid2 == 0)
    3906:	ed01                	bnez	a0,391e <preempt+0x56>
    for (;;)
    3908:	a001                	j	3908 <preempt+0x40>
    printf("%s: fork failed\n", s);
    390a:	85ca                	mv	a1,s2
    390c:	00002517          	auipc	a0,0x2
    3910:	5fc50513          	addi	a0,a0,1532 # 5f08 <malloc+0x9bc>
    3914:	37d010ef          	jal	5490 <printf>
    exit(1);
    3918:	4505                	li	a0,1
    391a:	710010ef          	jal	502a <exit>
  pipe(pfds);
    391e:	fc840513          	addi	a0,s0,-56
    3922:	718010ef          	jal	503a <pipe>
  pid3 = fork();
    3926:	6fc010ef          	jal	5022 <fork>
    392a:	8a2a                	mv	s4,a0
  if (pid3 < 0) {
    392c:	02054863          	bltz	a0,395c <preempt+0x94>
  if (pid3 == 0) {
    3930:	e921                	bnez	a0,3980 <preempt+0xb8>
    close(pfds[0]);
    3932:	fc842503          	lw	a0,-56(s0)
    3936:	71c010ef          	jal	5052 <close>
    if (write(pfds[1], "x", 1) != 1)
    393a:	4605                	li	a2,1
    393c:	00002597          	auipc	a1,0x2
    3940:	dac58593          	addi	a1,a1,-596 # 56e8 <malloc+0x19c>
    3944:	fcc42503          	lw	a0,-52(s0)
    3948:	702010ef          	jal	504a <write>
    394c:	4785                	li	a5,1
    394e:	02f51163          	bne	a0,a5,3970 <preempt+0xa8>
    close(pfds[1]);
    3952:	fcc42503          	lw	a0,-52(s0)
    3956:	6fc010ef          	jal	5052 <close>
    for (;;)
    395a:	a001                	j	395a <preempt+0x92>
    printf("%s: fork failed\n", s);
    395c:	85ca                	mv	a1,s2
    395e:	00002517          	auipc	a0,0x2
    3962:	5aa50513          	addi	a0,a0,1450 # 5f08 <malloc+0x9bc>
    3966:	32b010ef          	jal	5490 <printf>
    exit(1);
    396a:	4505                	li	a0,1
    396c:	6be010ef          	jal	502a <exit>
      printf("%s: preempt write error", s);
    3970:	85ca                	mv	a1,s2
    3972:	00003517          	auipc	a0,0x3
    3976:	7ce50513          	addi	a0,a0,1998 # 7140 <malloc+0x1bf4>
    397a:	317010ef          	jal	5490 <printf>
    397e:	bfd1                	j	3952 <preempt+0x8a>
  close(pfds[1]);
    3980:	fcc42503          	lw	a0,-52(s0)
    3984:	6ce010ef          	jal	5052 <close>
  if (read(pfds[0], buf, sizeof(buf)) != 1) {
    3988:	660d                	lui	a2,0x3
    398a:	00008597          	auipc	a1,0x8
    398e:	32e58593          	addi	a1,a1,814 # bcb8 <buf>
    3992:	fc842503          	lw	a0,-56(s0)
    3996:	6ac010ef          	jal	5042 <read>
    399a:	4785                	li	a5,1
    399c:	00f50a63          	beq	a0,a5,39b0 <preempt+0xe8>
    printf("%s: preempt read error", s);
    39a0:	85ca                	mv	a1,s2
    39a2:	00003517          	auipc	a0,0x3
    39a6:	7b650513          	addi	a0,a0,1974 # 7158 <malloc+0x1c0c>
    39aa:	2e7010ef          	jal	5490 <printf>
    return;
    39ae:	a099                	j	39f4 <preempt+0x12c>
  close(pfds[0]);
    39b0:	fc842503          	lw	a0,-56(s0)
    39b4:	69e010ef          	jal	5052 <close>
  printf("kill... ");
    39b8:	00003517          	auipc	a0,0x3
    39bc:	7b850513          	addi	a0,a0,1976 # 7170 <malloc+0x1c24>
    39c0:	2d1010ef          	jal	5490 <printf>
  kill(pid1);
    39c4:	8526                	mv	a0,s1
    39c6:	694010ef          	jal	505a <kill>
  kill(pid2);
    39ca:	854e                	mv	a0,s3
    39cc:	68e010ef          	jal	505a <kill>
  kill(pid3);
    39d0:	8552                	mv	a0,s4
    39d2:	688010ef          	jal	505a <kill>
  printf("wait... ");
    39d6:	00003517          	auipc	a0,0x3
    39da:	7aa50513          	addi	a0,a0,1962 # 7180 <malloc+0x1c34>
    39de:	2b3010ef          	jal	5490 <printf>
  wait(0);
    39e2:	4501                	li	a0,0
    39e4:	64e010ef          	jal	5032 <wait>
  wait(0);
    39e8:	4501                	li	a0,0
    39ea:	648010ef          	jal	5032 <wait>
  wait(0);
    39ee:	4501                	li	a0,0
    39f0:	642010ef          	jal	5032 <wait>
}
    39f4:	70e2                	ld	ra,56(sp)
    39f6:	7442                	ld	s0,48(sp)
    39f8:	74a2                	ld	s1,40(sp)
    39fa:	7902                	ld	s2,32(sp)
    39fc:	69e2                	ld	s3,24(sp)
    39fe:	6a42                	ld	s4,16(sp)
    3a00:	6121                	addi	sp,sp,64
    3a02:	8082                	ret

0000000000003a04 <reparent>:
{
    3a04:	7179                	addi	sp,sp,-48
    3a06:	f406                	sd	ra,40(sp)
    3a08:	f022                	sd	s0,32(sp)
    3a0a:	ec26                	sd	s1,24(sp)
    3a0c:	e84a                	sd	s2,16(sp)
    3a0e:	e44e                	sd	s3,8(sp)
    3a10:	e052                	sd	s4,0(sp)
    3a12:	1800                	addi	s0,sp,48
    3a14:	89aa                	mv	s3,a0
  int master_pid = getpid();
    3a16:	694010ef          	jal	50aa <getpid>
    3a1a:	8a2a                	mv	s4,a0
    3a1c:	0c800913          	li	s2,200
    int pid = fork();
    3a20:	602010ef          	jal	5022 <fork>
    3a24:	84aa                	mv	s1,a0
    if (pid < 0) {
    3a26:	00054e63          	bltz	a0,3a42 <reparent+0x3e>
    if (pid) {
    3a2a:	c121                	beqz	a0,3a6a <reparent+0x66>
      if (wait(0) != pid) {
    3a2c:	4501                	li	a0,0
    3a2e:	604010ef          	jal	5032 <wait>
    3a32:	02951263          	bne	a0,s1,3a56 <reparent+0x52>
  for (int i = 0; i < 200; i++) {
    3a36:	397d                	addiw	s2,s2,-1
    3a38:	fe0914e3          	bnez	s2,3a20 <reparent+0x1c>
  exit(0);
    3a3c:	4501                	li	a0,0
    3a3e:	5ec010ef          	jal	502a <exit>
      printf("%s: fork failed\n", s);
    3a42:	85ce                	mv	a1,s3
    3a44:	00002517          	auipc	a0,0x2
    3a48:	4c450513          	addi	a0,a0,1220 # 5f08 <malloc+0x9bc>
    3a4c:	245010ef          	jal	5490 <printf>
      exit(1);
    3a50:	4505                	li	a0,1
    3a52:	5d8010ef          	jal	502a <exit>
        printf("%s: wait wrong pid\n", s);
    3a56:	85ce                	mv	a1,s3
    3a58:	00002517          	auipc	a0,0x2
    3a5c:	5b850513          	addi	a0,a0,1464 # 6010 <malloc+0xac4>
    3a60:	231010ef          	jal	5490 <printf>
        exit(1);
    3a64:	4505                	li	a0,1
    3a66:	5c4010ef          	jal	502a <exit>
      int pid2 = fork();
    3a6a:	5b8010ef          	jal	5022 <fork>
      if (pid2 < 0) {
    3a6e:	00054563          	bltz	a0,3a78 <reparent+0x74>
      exit(0);
    3a72:	4501                	li	a0,0
    3a74:	5b6010ef          	jal	502a <exit>
        kill(master_pid);
    3a78:	8552                	mv	a0,s4
    3a7a:	5e0010ef          	jal	505a <kill>
        exit(1);
    3a7e:	4505                	li	a0,1
    3a80:	5aa010ef          	jal	502a <exit>

0000000000003a84 <sbrkfail>:
{
    3a84:	7175                	addi	sp,sp,-144
    3a86:	e506                	sd	ra,136(sp)
    3a88:	e122                	sd	s0,128(sp)
    3a8a:	fca6                	sd	s1,120(sp)
    3a8c:	f8ca                	sd	s2,112(sp)
    3a8e:	f4ce                	sd	s3,104(sp)
    3a90:	f0d2                	sd	s4,96(sp)
    3a92:	ecd6                	sd	s5,88(sp)
    3a94:	e8da                	sd	s6,80(sp)
    3a96:	e4de                	sd	s7,72(sp)
    3a98:	e0e2                	sd	s8,64(sp)
    3a9a:	0900                	addi	s0,sp,144
    3a9c:	8c2a                	mv	s8,a0
  if (pipe(fds) != 0) {
    3a9e:	fa040513          	addi	a0,s0,-96
    3aa2:	598010ef          	jal	503a <pipe>
    3aa6:	ed01                	bnez	a0,3abe <sbrkfail+0x3a>
    3aa8:	8baa                	mv	s7,a0
    3aaa:	f7040493          	addi	s1,s0,-144
    3aae:	f9840993          	addi	s3,s0,-104
    3ab2:	8926                	mv	s2,s1
    if (pids[i] != -1) {
    3ab4:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3ab6:	f9f40b13          	addi	s6,s0,-97
    3aba:	4a85                	li	s5,1
    3abc:	a095                	j	3b20 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3abe:	85e2                	mv	a1,s8
    3ac0:	00002517          	auipc	a0,0x2
    3ac4:	4d050513          	addi	a0,a0,1232 # 5f90 <malloc+0xa44>
    3ac8:	1c9010ef          	jal	5490 <printf>
    exit(1);
    3acc:	4505                	li	a0,1
    3ace:	55c010ef          	jal	502a <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) == (char *)SBRK_ERROR)
    3ad2:	524010ef          	jal	4ff6 <sbrk>
    3ad6:	064007b7          	lui	a5,0x6400
    3ada:	40a7853b          	subw	a0,a5,a0
    3ade:	518010ef          	jal	4ff6 <sbrk>
    3ae2:	57fd                	li	a5,-1
    3ae4:	02f50163          	beq	a0,a5,3b06 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3ae8:	4605                	li	a2,1
    3aea:	00004597          	auipc	a1,0x4
    3aee:	e1e58593          	addi	a1,a1,-482 # 7908 <malloc+0x23bc>
    3af2:	fa442503          	lw	a0,-92(s0)
    3af6:	554010ef          	jal	504a <write>
        pause(1000);
    3afa:	3e800493          	li	s1,1000
    3afe:	8526                	mv	a0,s1
    3b00:	5ba010ef          	jal	50ba <pause>
      for (;;)
    3b04:	bfed                	j	3afe <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3b06:	4605                	li	a2,1
    3b08:	00003597          	auipc	a1,0x3
    3b0c:	68858593          	addi	a1,a1,1672 # 7190 <malloc+0x1c44>
    3b10:	fa442503          	lw	a0,-92(s0)
    3b14:	536010ef          	jal	504a <write>
    3b18:	b7cd                	j	3afa <sbrkfail+0x76>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3b1a:	0911                	addi	s2,s2,4
    3b1c:	03390a63          	beq	s2,s3,3b50 <sbrkfail+0xcc>
    if ((pids[i] = fork()) == 0) {
    3b20:	502010ef          	jal	5022 <fork>
    3b24:	00a92023          	sw	a0,0(s2)
    3b28:	d54d                	beqz	a0,3ad2 <sbrkfail+0x4e>
    if (pids[i] != -1) {
    3b2a:	ff4508e3          	beq	a0,s4,3b1a <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3b2e:	8656                	mv	a2,s5
    3b30:	85da                	mv	a1,s6
    3b32:	fa042503          	lw	a0,-96(s0)
    3b36:	50c010ef          	jal	5042 <read>
      if (scratch == '0')
    3b3a:	f9f44783          	lbu	a5,-97(s0)
    3b3e:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f1318>
    3b42:	0017b793          	seqz	a5,a5
    3b46:	00fbe7b3          	or	a5,s7,a5
    3b4a:	00078b9b          	sext.w	s7,a5
    3b4e:	b7f1                	j	3b1a <sbrkfail+0x96>
  if (!failed) {
    3b50:	000b8863          	beqz	s7,3b60 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b54:	6505                	lui	a0,0x1
    3b56:	4a0010ef          	jal	4ff6 <sbrk>
    3b5a:	8a2a                	mv	s4,a0
    if (pids[i] == -1)
    3b5c:	597d                	li	s2,-1
    3b5e:	a821                	j	3b76 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b60:	85e2                	mv	a1,s8
    3b62:	00003517          	auipc	a0,0x3
    3b66:	63650513          	addi	a0,a0,1590 # 7198 <malloc+0x1c4c>
    3b6a:	127010ef          	jal	5490 <printf>
    3b6e:	b7dd                	j	3b54 <sbrkfail+0xd0>
  for (i = 0; i < sizeof(pids) / sizeof(pids[0]); i++) {
    3b70:	0491                	addi	s1,s1,4
    3b72:	01348b63          	beq	s1,s3,3b88 <sbrkfail+0x104>
    if (pids[i] == -1)
    3b76:	4088                	lw	a0,0(s1)
    3b78:	ff250ce3          	beq	a0,s2,3b70 <sbrkfail+0xec>
    kill(pids[i]);
    3b7c:	4de010ef          	jal	505a <kill>
    wait(0);
    3b80:	4501                	li	a0,0
    3b82:	4b0010ef          	jal	5032 <wait>
    3b86:	b7ed                	j	3b70 <sbrkfail+0xec>
  if (c == (char *)SBRK_ERROR) {
    3b88:	57fd                	li	a5,-1
    3b8a:	02fa0a63          	beq	s4,a5,3bbe <sbrkfail+0x13a>
  pid = fork();
    3b8e:	494010ef          	jal	5022 <fork>
  if (pid < 0) {
    3b92:	04054063          	bltz	a0,3bd2 <sbrkfail+0x14e>
  if (pid == 0) {
    3b96:	e939                	bnez	a0,3bec <sbrkfail+0x168>
    a = sbrk(10 * BIG);
    3b98:	3e800537          	lui	a0,0x3e800
    3b9c:	45a010ef          	jal	4ff6 <sbrk>
    if (a == (char *)SBRK_ERROR) {
    3ba0:	57fd                	li	a5,-1
    3ba2:	04f50263          	beq	a0,a5,3be6 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10 * BIG);
    3ba6:	3e800637          	lui	a2,0x3e800
    3baa:	85e2                	mv	a1,s8
    3bac:	00003517          	auipc	a0,0x3
    3bb0:	63c50513          	addi	a0,a0,1596 # 71e8 <malloc+0x1c9c>
    3bb4:	0dd010ef          	jal	5490 <printf>
    exit(1);
    3bb8:	4505                	li	a0,1
    3bba:	470010ef          	jal	502a <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3bbe:	85e2                	mv	a1,s8
    3bc0:	00003517          	auipc	a0,0x3
    3bc4:	60850513          	addi	a0,a0,1544 # 71c8 <malloc+0x1c7c>
    3bc8:	0c9010ef          	jal	5490 <printf>
    exit(1);
    3bcc:	4505                	li	a0,1
    3bce:	45c010ef          	jal	502a <exit>
    printf("%s: fork failed\n", s);
    3bd2:	85e2                	mv	a1,s8
    3bd4:	00002517          	auipc	a0,0x2
    3bd8:	33450513          	addi	a0,a0,820 # 5f08 <malloc+0x9bc>
    3bdc:	0b5010ef          	jal	5490 <printf>
    exit(1);
    3be0:	4505                	li	a0,1
    3be2:	448010ef          	jal	502a <exit>
      exit(0);
    3be6:	4501                	li	a0,0
    3be8:	442010ef          	jal	502a <exit>
  wait(&xstatus);
    3bec:	fac40513          	addi	a0,s0,-84
    3bf0:	442010ef          	jal	5032 <wait>
  if (xstatus != 0)
    3bf4:	fac42783          	lw	a5,-84(s0)
    3bf8:	ef89                	bnez	a5,3c12 <sbrkfail+0x18e>
}
    3bfa:	60aa                	ld	ra,136(sp)
    3bfc:	640a                	ld	s0,128(sp)
    3bfe:	74e6                	ld	s1,120(sp)
    3c00:	7946                	ld	s2,112(sp)
    3c02:	79a6                	ld	s3,104(sp)
    3c04:	7a06                	ld	s4,96(sp)
    3c06:	6ae6                	ld	s5,88(sp)
    3c08:	6b46                	ld	s6,80(sp)
    3c0a:	6ba6                	ld	s7,72(sp)
    3c0c:	6c06                	ld	s8,64(sp)
    3c0e:	6149                	addi	sp,sp,144
    3c10:	8082                	ret
    exit(1);
    3c12:	4505                	li	a0,1
    3c14:	416010ef          	jal	502a <exit>

0000000000003c18 <mem>:
{
    3c18:	7139                	addi	sp,sp,-64
    3c1a:	fc06                	sd	ra,56(sp)
    3c1c:	f822                	sd	s0,48(sp)
    3c1e:	f426                	sd	s1,40(sp)
    3c20:	f04a                	sd	s2,32(sp)
    3c22:	ec4e                	sd	s3,24(sp)
    3c24:	0080                	addi	s0,sp,64
    3c26:	89aa                	mv	s3,a0
  if ((pid = fork()) == 0) {
    3c28:	3fa010ef          	jal	5022 <fork>
    m1 = 0;
    3c2c:	4481                	li	s1,0
    while ((m2 = malloc(10001)) != 0) {
    3c2e:	6909                	lui	s2,0x2
    3c30:	71190913          	addi	s2,s2,1809 # 2711 <fourteen+0xf1>
  if ((pid = fork()) == 0) {
    3c34:	cd11                	beqz	a0,3c50 <mem+0x38>
    wait(&xstatus);
    3c36:	fcc40513          	addi	a0,s0,-52
    3c3a:	3f8010ef          	jal	5032 <wait>
    if (xstatus == -1) {
    3c3e:	fcc42503          	lw	a0,-52(s0)
    3c42:	57fd                	li	a5,-1
    3c44:	04f50363          	beq	a0,a5,3c8a <mem+0x72>
    exit(xstatus);
    3c48:	3e2010ef          	jal	502a <exit>
      *(char **)m2 = m1;
    3c4c:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c4e:	84aa                	mv	s1,a0
    while ((m2 = malloc(10001)) != 0) {
    3c50:	854a                	mv	a0,s2
    3c52:	0fb010ef          	jal	554c <malloc>
    3c56:	f97d                	bnez	a0,3c4c <mem+0x34>
    while (m1) {
    3c58:	c491                	beqz	s1,3c64 <mem+0x4c>
      m2 = *(char **)m1;
    3c5a:	8526                	mv	a0,s1
    3c5c:	6084                	ld	s1,0(s1)
      free(m1);
    3c5e:	065010ef          	jal	54c2 <free>
    while (m1) {
    3c62:	fce5                	bnez	s1,3c5a <mem+0x42>
    m1 = malloc(1024 * 20);
    3c64:	6515                	lui	a0,0x5
    3c66:	0e7010ef          	jal	554c <malloc>
    if (m1 == 0) {
    3c6a:	c511                	beqz	a0,3c76 <mem+0x5e>
    free(m1);
    3c6c:	057010ef          	jal	54c2 <free>
    exit(0);
    3c70:	4501                	li	a0,0
    3c72:	3b8010ef          	jal	502a <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c76:	85ce                	mv	a1,s3
    3c78:	00003517          	auipc	a0,0x3
    3c7c:	5a050513          	addi	a0,a0,1440 # 7218 <malloc+0x1ccc>
    3c80:	011010ef          	jal	5490 <printf>
      exit(1);
    3c84:	4505                	li	a0,1
    3c86:	3a4010ef          	jal	502a <exit>
      exit(0);
    3c8a:	4501                	li	a0,0
    3c8c:	39e010ef          	jal	502a <exit>

0000000000003c90 <sharedfd>:
{
    3c90:	7159                	addi	sp,sp,-112
    3c92:	f486                	sd	ra,104(sp)
    3c94:	f0a2                	sd	s0,96(sp)
    3c96:	eca6                	sd	s1,88(sp)
    3c98:	f85a                	sd	s6,48(sp)
    3c9a:	1880                	addi	s0,sp,112
    3c9c:	84aa                	mv	s1,a0
    3c9e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3ca0:	00003517          	auipc	a0,0x3
    3ca4:	59850513          	addi	a0,a0,1432 # 7238 <malloc+0x1cec>
    3ca8:	3d2010ef          	jal	507a <unlink>
  fd = open("sharedfd", O_CREATE | O_RDWR);
    3cac:	20200593          	li	a1,514
    3cb0:	00003517          	auipc	a0,0x3
    3cb4:	58850513          	addi	a0,a0,1416 # 7238 <malloc+0x1cec>
    3cb8:	3b2010ef          	jal	506a <open>
  if (fd < 0) {
    3cbc:	04054863          	bltz	a0,3d0c <sharedfd+0x7c>
    3cc0:	e8ca                	sd	s2,80(sp)
    3cc2:	e4ce                	sd	s3,72(sp)
    3cc4:	e0d2                	sd	s4,64(sp)
    3cc6:	fc56                	sd	s5,56(sp)
    3cc8:	89aa                	mv	s3,a0
  pid = fork();
    3cca:	358010ef          	jal	5022 <fork>
    3cce:	8aaa                	mv	s5,a0
  memset(buf, pid == 0 ? 'c' : 'p', sizeof(buf));
    3cd0:	07000593          	li	a1,112
    3cd4:	e119                	bnez	a0,3cda <sharedfd+0x4a>
    3cd6:	06300593          	li	a1,99
    3cda:	4629                	li	a2,10
    3cdc:	fa040513          	addi	a0,s0,-96
    3ce0:	120010ef          	jal	4e00 <memset>
    3ce4:	3e800493          	li	s1,1000
    if (write(fd, buf, sizeof(buf)) != sizeof(buf)) {
    3ce8:	fa040a13          	addi	s4,s0,-96
    3cec:	4929                	li	s2,10
    3cee:	864a                	mv	a2,s2
    3cf0:	85d2                	mv	a1,s4
    3cf2:	854e                	mv	a0,s3
    3cf4:	356010ef          	jal	504a <write>
    3cf8:	03251963          	bne	a0,s2,3d2a <sharedfd+0x9a>
  for (i = 0; i < N; i++) {
    3cfc:	34fd                	addiw	s1,s1,-1
    3cfe:	f8e5                	bnez	s1,3cee <sharedfd+0x5e>
  if (pid == 0) {
    3d00:	040a9063          	bnez	s5,3d40 <sharedfd+0xb0>
    3d04:	f45e                	sd	s7,40(sp)
    exit(0);
    3d06:	4501                	li	a0,0
    3d08:	322010ef          	jal	502a <exit>
    3d0c:	e8ca                	sd	s2,80(sp)
    3d0e:	e4ce                	sd	s3,72(sp)
    3d10:	e0d2                	sd	s4,64(sp)
    3d12:	fc56                	sd	s5,56(sp)
    3d14:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3d16:	85a6                	mv	a1,s1
    3d18:	00003517          	auipc	a0,0x3
    3d1c:	53050513          	addi	a0,a0,1328 # 7248 <malloc+0x1cfc>
    3d20:	770010ef          	jal	5490 <printf>
    exit(1);
    3d24:	4505                	li	a0,1
    3d26:	304010ef          	jal	502a <exit>
    3d2a:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3d2c:	85da                	mv	a1,s6
    3d2e:	00003517          	auipc	a0,0x3
    3d32:	54250513          	addi	a0,a0,1346 # 7270 <malloc+0x1d24>
    3d36:	75a010ef          	jal	5490 <printf>
      exit(1);
    3d3a:	4505                	li	a0,1
    3d3c:	2ee010ef          	jal	502a <exit>
    wait(&xstatus);
    3d40:	f9c40513          	addi	a0,s0,-100
    3d44:	2ee010ef          	jal	5032 <wait>
    if (xstatus != 0)
    3d48:	f9c42a03          	lw	s4,-100(s0)
    3d4c:	000a0663          	beqz	s4,3d58 <sharedfd+0xc8>
    3d50:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d52:	8552                	mv	a0,s4
    3d54:	2d6010ef          	jal	502a <exit>
    3d58:	f45e                	sd	s7,40(sp)
  close(fd);
    3d5a:	854e                	mv	a0,s3
    3d5c:	2f6010ef          	jal	5052 <close>
  fd = open("sharedfd", 0);
    3d60:	4581                	li	a1,0
    3d62:	00003517          	auipc	a0,0x3
    3d66:	4d650513          	addi	a0,a0,1238 # 7238 <malloc+0x1cec>
    3d6a:	300010ef          	jal	506a <open>
    3d6e:	8baa                	mv	s7,a0
  nc = np = 0;
    3d70:	89d2                	mv	s3,s4
  if (fd < 0) {
    3d72:	02054363          	bltz	a0,3d98 <sharedfd+0x108>
    3d76:	faa40913          	addi	s2,s0,-86
      if (buf[i] == 'c')
    3d7a:	06300493          	li	s1,99
      if (buf[i] == 'p')
    3d7e:	07000a93          	li	s5,112
  while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3d82:	4629                	li	a2,10
    3d84:	fa040593          	addi	a1,s0,-96
    3d88:	855e                	mv	a0,s7
    3d8a:	2b8010ef          	jal	5042 <read>
    3d8e:	02a05b63          	blez	a0,3dc4 <sharedfd+0x134>
    3d92:	fa040793          	addi	a5,s0,-96
    3d96:	a839                	j	3db4 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d98:	85da                	mv	a1,s6
    3d9a:	00003517          	auipc	a0,0x3
    3d9e:	4f650513          	addi	a0,a0,1270 # 7290 <malloc+0x1d44>
    3da2:	6ee010ef          	jal	5490 <printf>
    exit(1);
    3da6:	4505                	li	a0,1
    3da8:	282010ef          	jal	502a <exit>
        nc++;
    3dac:	2a05                	addiw	s4,s4,1
    for (i = 0; i < sizeof(buf); i++) {
    3dae:	0785                	addi	a5,a5,1
    3db0:	fd2789e3          	beq	a5,s2,3d82 <sharedfd+0xf2>
      if (buf[i] == 'c')
    3db4:	0007c703          	lbu	a4,0(a5)
    3db8:	fe970ae3          	beq	a4,s1,3dac <sharedfd+0x11c>
      if (buf[i] == 'p')
    3dbc:	ff5719e3          	bne	a4,s5,3dae <sharedfd+0x11e>
        np++;
    3dc0:	2985                	addiw	s3,s3,1
    3dc2:	b7f5                	j	3dae <sharedfd+0x11e>
  close(fd);
    3dc4:	855e                	mv	a0,s7
    3dc6:	28c010ef          	jal	5052 <close>
  unlink("sharedfd");
    3dca:	00003517          	auipc	a0,0x3
    3dce:	46e50513          	addi	a0,a0,1134 # 7238 <malloc+0x1cec>
    3dd2:	2a8010ef          	jal	507a <unlink>
  if (nc == N * SZ && np == N * SZ) {
    3dd6:	6789                	lui	a5,0x2
    3dd8:	71078793          	addi	a5,a5,1808 # 2710 <fourteen+0xf0>
    3ddc:	00fa1763          	bne	s4,a5,3dea <sharedfd+0x15a>
    3de0:	01499563          	bne	s3,s4,3dea <sharedfd+0x15a>
    exit(0);
    3de4:	4501                	li	a0,0
    3de6:	244010ef          	jal	502a <exit>
    printf("%s: nc/np test fails\n", s);
    3dea:	85da                	mv	a1,s6
    3dec:	00003517          	auipc	a0,0x3
    3df0:	4cc50513          	addi	a0,a0,1228 # 72b8 <malloc+0x1d6c>
    3df4:	69c010ef          	jal	5490 <printf>
    exit(1);
    3df8:	4505                	li	a0,1
    3dfa:	230010ef          	jal	502a <exit>

0000000000003dfe <fourfiles>:
{
    3dfe:	7135                	addi	sp,sp,-160
    3e00:	ed06                	sd	ra,152(sp)
    3e02:	e922                	sd	s0,144(sp)
    3e04:	e526                	sd	s1,136(sp)
    3e06:	e14a                	sd	s2,128(sp)
    3e08:	fcce                	sd	s3,120(sp)
    3e0a:	f8d2                	sd	s4,112(sp)
    3e0c:	f4d6                	sd	s5,104(sp)
    3e0e:	f0da                	sd	s6,96(sp)
    3e10:	ecde                	sd	s7,88(sp)
    3e12:	e8e2                	sd	s8,80(sp)
    3e14:	e4e6                	sd	s9,72(sp)
    3e16:	e0ea                	sd	s10,64(sp)
    3e18:	fc6e                	sd	s11,56(sp)
    3e1a:	1100                	addi	s0,sp,160
    3e1c:	8caa                	mv	s9,a0
  char *names[] = {"f0", "f1", "f2", "f3"};
    3e1e:	00003797          	auipc	a5,0x3
    3e22:	4b278793          	addi	a5,a5,1202 # 72d0 <malloc+0x1d84>
    3e26:	f6f43823          	sd	a5,-144(s0)
    3e2a:	00003797          	auipc	a5,0x3
    3e2e:	4ae78793          	addi	a5,a5,1198 # 72d8 <malloc+0x1d8c>
    3e32:	f6f43c23          	sd	a5,-136(s0)
    3e36:	00003797          	auipc	a5,0x3
    3e3a:	4aa78793          	addi	a5,a5,1194 # 72e0 <malloc+0x1d94>
    3e3e:	f8f43023          	sd	a5,-128(s0)
    3e42:	00003797          	auipc	a5,0x3
    3e46:	4a678793          	addi	a5,a5,1190 # 72e8 <malloc+0x1d9c>
    3e4a:	f8f43423          	sd	a5,-120(s0)
  for (pi = 0; pi < NCHILD; pi++) {
    3e4e:	f7040b93          	addi	s7,s0,-144
  char *names[] = {"f0", "f1", "f2", "f3"};
    3e52:	895e                	mv	s2,s7
  for (pi = 0; pi < NCHILD; pi++) {
    3e54:	4481                	li	s1,0
    3e56:	4a11                	li	s4,4
    fname = names[pi];
    3e58:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e5c:	854e                	mv	a0,s3
    3e5e:	21c010ef          	jal	507a <unlink>
    pid = fork();
    3e62:	1c0010ef          	jal	5022 <fork>
    if (pid < 0) {
    3e66:	04054063          	bltz	a0,3ea6 <fourfiles+0xa8>
    if (pid == 0) {
    3e6a:	c921                	beqz	a0,3eba <fourfiles+0xbc>
  for (pi = 0; pi < NCHILD; pi++) {
    3e6c:	2485                	addiw	s1,s1,1
    3e6e:	0921                	addi	s2,s2,8
    3e70:	ff4494e3          	bne	s1,s4,3e58 <fourfiles+0x5a>
    3e74:	4491                	li	s1,4
    wait(&xstatus);
    3e76:	f6c40913          	addi	s2,s0,-148
    3e7a:	854a                	mv	a0,s2
    3e7c:	1b6010ef          	jal	5032 <wait>
    if (xstatus != 0)
    3e80:	f6c42b03          	lw	s6,-148(s0)
    3e84:	0a0b1463          	bnez	s6,3f2c <fourfiles+0x12e>
  for (pi = 0; pi < NCHILD; pi++) {
    3e88:	34fd                	addiw	s1,s1,-1
    3e8a:	f8e5                	bnez	s1,3e7a <fourfiles+0x7c>
    3e8c:	03000493          	li	s1,48
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3e90:	6a8d                	lui	s5,0x3
    3e92:	00008a17          	auipc	s4,0x8
    3e96:	e26a0a13          	addi	s4,s4,-474 # bcb8 <buf>
    if (total != N * SZ) {
    3e9a:	6d05                	lui	s10,0x1
    3e9c:	770d0d13          	addi	s10,s10,1904 # 1770 <createdelete+0x20>
  for (i = 0; i < NCHILD; i++) {
    3ea0:	03400d93          	li	s11,52
    3ea4:	a86d                	j	3f5e <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3ea6:	85e6                	mv	a1,s9
    3ea8:	00002517          	auipc	a0,0x2
    3eac:	06050513          	addi	a0,a0,96 # 5f08 <malloc+0x9bc>
    3eb0:	5e0010ef          	jal	5490 <printf>
      exit(1);
    3eb4:	4505                	li	a0,1
    3eb6:	174010ef          	jal	502a <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3eba:	20200593          	li	a1,514
    3ebe:	854e                	mv	a0,s3
    3ec0:	1aa010ef          	jal	506a <open>
    3ec4:	892a                	mv	s2,a0
      if (fd < 0) {
    3ec6:	04054063          	bltz	a0,3f06 <fourfiles+0x108>
      memset(buf, '0' + pi, SZ);
    3eca:	1f400613          	li	a2,500
    3ece:	0304859b          	addiw	a1,s1,48
    3ed2:	00008517          	auipc	a0,0x8
    3ed6:	de650513          	addi	a0,a0,-538 # bcb8 <buf>
    3eda:	727000ef          	jal	4e00 <memset>
    3ede:	44b1                	li	s1,12
        if ((n = write(fd, buf, SZ)) != SZ) {
    3ee0:	1f400993          	li	s3,500
    3ee4:	00008a17          	auipc	s4,0x8
    3ee8:	dd4a0a13          	addi	s4,s4,-556 # bcb8 <buf>
    3eec:	864e                	mv	a2,s3
    3eee:	85d2                	mv	a1,s4
    3ef0:	854a                	mv	a0,s2
    3ef2:	158010ef          	jal	504a <write>
    3ef6:	85aa                	mv	a1,a0
    3ef8:	03351163          	bne	a0,s3,3f1a <fourfiles+0x11c>
      for (i = 0; i < N; i++) {
    3efc:	34fd                	addiw	s1,s1,-1
    3efe:	f4fd                	bnez	s1,3eec <fourfiles+0xee>
      exit(0);
    3f00:	4501                	li	a0,0
    3f02:	128010ef          	jal	502a <exit>
        printf("%s: create failed\n", s);
    3f06:	85e6                	mv	a1,s9
    3f08:	00002517          	auipc	a0,0x2
    3f0c:	17050513          	addi	a0,a0,368 # 6078 <malloc+0xb2c>
    3f10:	580010ef          	jal	5490 <printf>
        exit(1);
    3f14:	4505                	li	a0,1
    3f16:	114010ef          	jal	502a <exit>
          printf("write failed %d\n", n);
    3f1a:	00003517          	auipc	a0,0x3
    3f1e:	3d650513          	addi	a0,a0,982 # 72f0 <malloc+0x1da4>
    3f22:	56e010ef          	jal	5490 <printf>
          exit(1);
    3f26:	4505                	li	a0,1
    3f28:	102010ef          	jal	502a <exit>
      exit(xstatus);
    3f2c:	855a                	mv	a0,s6
    3f2e:	0fc010ef          	jal	502a <exit>
          printf("%s: wrong char\n", s);
    3f32:	85e6                	mv	a1,s9
    3f34:	00003517          	auipc	a0,0x3
    3f38:	3d450513          	addi	a0,a0,980 # 7308 <malloc+0x1dbc>
    3f3c:	554010ef          	jal	5490 <printf>
          exit(1);
    3f40:	4505                	li	a0,1
    3f42:	0e8010ef          	jal	502a <exit>
    close(fd);
    3f46:	854e                	mv	a0,s3
    3f48:	10a010ef          	jal	5052 <close>
    if (total != N * SZ) {
    3f4c:	05a91863          	bne	s2,s10,3f9c <fourfiles+0x19e>
    unlink(fname);
    3f50:	8562                	mv	a0,s8
    3f52:	128010ef          	jal	507a <unlink>
  for (i = 0; i < NCHILD; i++) {
    3f56:	0ba1                	addi	s7,s7,8
    3f58:	2485                	addiw	s1,s1,1
    3f5a:	05b48b63          	beq	s1,s11,3fb0 <fourfiles+0x1b2>
    fname = names[i];
    3f5e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f62:	4581                	li	a1,0
    3f64:	8562                	mv	a0,s8
    3f66:	104010ef          	jal	506a <open>
    3f6a:	89aa                	mv	s3,a0
    total = 0;
    3f6c:	895a                	mv	s2,s6
    while ((n = read(fd, buf, sizeof(buf))) > 0) {
    3f6e:	8656                	mv	a2,s5
    3f70:	85d2                	mv	a1,s4
    3f72:	854e                	mv	a0,s3
    3f74:	0ce010ef          	jal	5042 <read>
    3f78:	fca057e3          	blez	a0,3f46 <fourfiles+0x148>
    3f7c:	00008797          	auipc	a5,0x8
    3f80:	d3c78793          	addi	a5,a5,-708 # bcb8 <buf>
    3f84:	00f506b3          	add	a3,a0,a5
        if (buf[j] != '0' + i) {
    3f88:	0007c703          	lbu	a4,0(a5)
    3f8c:	fa9713e3          	bne	a4,s1,3f32 <fourfiles+0x134>
      for (j = 0; j < n; j++) {
    3f90:	0785                	addi	a5,a5,1
    3f92:	fed79be3          	bne	a5,a3,3f88 <fourfiles+0x18a>
      total += n;
    3f96:	00a9093b          	addw	s2,s2,a0
    3f9a:	bfd1                	j	3f6e <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f9c:	85ca                	mv	a1,s2
    3f9e:	00003517          	auipc	a0,0x3
    3fa2:	37a50513          	addi	a0,a0,890 # 7318 <malloc+0x1dcc>
    3fa6:	4ea010ef          	jal	5490 <printf>
      exit(1);
    3faa:	4505                	li	a0,1
    3fac:	07e010ef          	jal	502a <exit>
}
    3fb0:	60ea                	ld	ra,152(sp)
    3fb2:	644a                	ld	s0,144(sp)
    3fb4:	64aa                	ld	s1,136(sp)
    3fb6:	690a                	ld	s2,128(sp)
    3fb8:	79e6                	ld	s3,120(sp)
    3fba:	7a46                	ld	s4,112(sp)
    3fbc:	7aa6                	ld	s5,104(sp)
    3fbe:	7b06                	ld	s6,96(sp)
    3fc0:	6be6                	ld	s7,88(sp)
    3fc2:	6c46                	ld	s8,80(sp)
    3fc4:	6ca6                	ld	s9,72(sp)
    3fc6:	6d06                	ld	s10,64(sp)
    3fc8:	7de2                	ld	s11,56(sp)
    3fca:	610d                	addi	sp,sp,160
    3fcc:	8082                	ret

0000000000003fce <concreate>:
{
    3fce:	7171                	addi	sp,sp,-176
    3fd0:	f506                	sd	ra,168(sp)
    3fd2:	f122                	sd	s0,160(sp)
    3fd4:	ed26                	sd	s1,152(sp)
    3fd6:	e94a                	sd	s2,144(sp)
    3fd8:	e54e                	sd	s3,136(sp)
    3fda:	e152                	sd	s4,128(sp)
    3fdc:	fcd6                	sd	s5,120(sp)
    3fde:	f8da                	sd	s6,112(sp)
    3fe0:	f4de                	sd	s7,104(sp)
    3fe2:	f0e2                	sd	s8,96(sp)
    3fe4:	ece6                	sd	s9,88(sp)
    3fe6:	e8ea                	sd	s10,80(sp)
    3fe8:	1900                	addi	s0,sp,176
    3fea:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3fec:	04300793          	li	a5,67
    3ff0:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3ff4:	f8040d23          	sb	zero,-102(s0)
  for (i = 0; i < N; i++) {
    3ff8:	4901                	li	s2,0
    unlink(file);
    3ffa:	f9840993          	addi	s3,s0,-104
    if (pid && (i % 3) == 1) {
    3ffe:	55555b37          	lui	s6,0x55555
    4002:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x5554689e>
    4006:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    4008:	20200c13          	li	s8,514
      link("C0", file);
    400c:	00003c97          	auipc	s9,0x3
    4010:	324c8c93          	addi	s9,s9,804 # 7330 <malloc+0x1de4>
      wait(&xstatus);
    4014:	f5c40a93          	addi	s5,s0,-164
  for (i = 0; i < N; i++) {
    4018:	02800a13          	li	s4,40
    401c:	a481                	j	425c <concreate+0x28e>
      link("C0", file);
    401e:	85ce                	mv	a1,s3
    4020:	8566                	mv	a0,s9
    4022:	068010ef          	jal	508a <link>
    if (pid == 0) {
    4026:	a40d                	j	4248 <concreate+0x27a>
    } else if (pid == 0 && (i % 5) == 1) {
    4028:	666667b7          	lui	a5,0x66666
    402c:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579af>
    4030:	02f907b3          	mul	a5,s2,a5
    4034:	9785                	srai	a5,a5,0x21
    4036:	41f9571b          	sraiw	a4,s2,0x1f
    403a:	9f99                	subw	a5,a5,a4
    403c:	0027971b          	slliw	a4,a5,0x2
    4040:	9fb9                	addw	a5,a5,a4
    4042:	40f9093b          	subw	s2,s2,a5
    4046:	4785                	li	a5,1
    4048:	02f90563          	beq	s2,a5,4072 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    404c:	20200593          	li	a1,514
    4050:	f9840513          	addi	a0,s0,-104
    4054:	016010ef          	jal	506a <open>
      if (fd < 0) {
    4058:	1e055363          	bgez	a0,423e <concreate+0x270>
        printf("concreate create %s failed\n", file);
    405c:	f9840593          	addi	a1,s0,-104
    4060:	00003517          	auipc	a0,0x3
    4064:	2d850513          	addi	a0,a0,728 # 7338 <malloc+0x1dec>
    4068:	428010ef          	jal	5490 <printf>
        exit(1);
    406c:	4505                	li	a0,1
    406e:	7bd000ef          	jal	502a <exit>
      link("C0", file);
    4072:	f9840593          	addi	a1,s0,-104
    4076:	00003517          	auipc	a0,0x3
    407a:	2ba50513          	addi	a0,a0,698 # 7330 <malloc+0x1de4>
    407e:	00c010ef          	jal	508a <link>
      exit(0);
    4082:	4501                	li	a0,0
    4084:	7a7000ef          	jal	502a <exit>
        exit(1);
    4088:	4505                	li	a0,1
    408a:	7a1000ef          	jal	502a <exit>
  memset(fa, 0, sizeof(fa));
    408e:	02800613          	li	a2,40
    4092:	4581                	li	a1,0
    4094:	f7040513          	addi	a0,s0,-144
    4098:	569000ef          	jal	4e00 <memset>
  fd = open(".", 0);
    409c:	4581                	li	a1,0
    409e:	00002517          	auipc	a0,0x2
    40a2:	cc250513          	addi	a0,a0,-830 # 5d60 <malloc+0x814>
    40a6:	7c5000ef          	jal	506a <open>
    40aa:	892a                	mv	s2,a0
  n = 0;
    40ac:	8b26                	mv	s6,s1
  while (read(fd, &de, sizeof(de)) > 0) {
    40ae:	f6040a13          	addi	s4,s0,-160
    40b2:	49c1                	li	s3,16
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    40b4:	04300a93          	li	s5,67
      if (i < 0 || i >= sizeof(fa)) {
    40b8:	02700b93          	li	s7,39
      fa[i] = 1;
    40bc:	4c05                	li	s8,1
  while (read(fd, &de, sizeof(de)) > 0) {
    40be:	864e                	mv	a2,s3
    40c0:	85d2                	mv	a1,s4
    40c2:	854a                	mv	a0,s2
    40c4:	77f000ef          	jal	5042 <read>
    40c8:	06a05763          	blez	a0,4136 <concreate+0x168>
    if (de.inum == 0)
    40cc:	f6045783          	lhu	a5,-160(s0)
    40d0:	d7fd                	beqz	a5,40be <concreate+0xf0>
    if (de.name[0] == 'C' && de.name[2] == '\0') {
    40d2:	f6244783          	lbu	a5,-158(s0)
    40d6:	ff5794e3          	bne	a5,s5,40be <concreate+0xf0>
    40da:	f6444783          	lbu	a5,-156(s0)
    40de:	f3e5                	bnez	a5,40be <concreate+0xf0>
      i = de.name[1] - '0';
    40e0:	f6344783          	lbu	a5,-157(s0)
    40e4:	fd07879b          	addiw	a5,a5,-48
      if (i < 0 || i >= sizeof(fa)) {
    40e8:	00fbef63          	bltu	s7,a5,4106 <concreate+0x138>
      if (fa[i]) {
    40ec:	fa040713          	addi	a4,s0,-96
    40f0:	973e                	add	a4,a4,a5
    40f2:	fd074703          	lbu	a4,-48(a4)
    40f6:	e705                	bnez	a4,411e <concreate+0x150>
      fa[i] = 1;
    40f8:	fa040713          	addi	a4,s0,-96
    40fc:	97ba                	add	a5,a5,a4
    40fe:	fd878823          	sb	s8,-48(a5)
      n++;
    4102:	2b05                	addiw	s6,s6,1
    4104:	bf6d                	j	40be <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    4106:	f6240613          	addi	a2,s0,-158
    410a:	85ea                	mv	a1,s10
    410c:	00003517          	auipc	a0,0x3
    4110:	24c50513          	addi	a0,a0,588 # 7358 <malloc+0x1e0c>
    4114:	37c010ef          	jal	5490 <printf>
        exit(1);
    4118:	4505                	li	a0,1
    411a:	711000ef          	jal	502a <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    411e:	f6240613          	addi	a2,s0,-158
    4122:	85ea                	mv	a1,s10
    4124:	00003517          	auipc	a0,0x3
    4128:	25450513          	addi	a0,a0,596 # 7378 <malloc+0x1e2c>
    412c:	364010ef          	jal	5490 <printf>
        exit(1);
    4130:	4505                	li	a0,1
    4132:	6f9000ef          	jal	502a <exit>
  close(fd);
    4136:	854a                	mv	a0,s2
    4138:	71b000ef          	jal	5052 <close>
  if (n != N) {
    413c:	02800793          	li	a5,40
    4140:	00fb1a63          	bne	s6,a5,4154 <concreate+0x186>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    4144:	55555a37          	lui	s4,0x55555
    4148:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x5554689e>
      close(open(file, 0));
    414c:	f9840993          	addi	s3,s0,-104
  for (i = 0; i < N; i++) {
    4150:	8ada                	mv	s5,s6
    4152:	a049                	j	41d4 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4154:	85ea                	mv	a1,s10
    4156:	00003517          	auipc	a0,0x3
    415a:	24a50513          	addi	a0,a0,586 # 73a0 <malloc+0x1e54>
    415e:	332010ef          	jal	5490 <printf>
    exit(1);
    4162:	4505                	li	a0,1
    4164:	6c7000ef          	jal	502a <exit>
      printf("%s: fork failed\n", s);
    4168:	85ea                	mv	a1,s10
    416a:	00002517          	auipc	a0,0x2
    416e:	d9e50513          	addi	a0,a0,-610 # 5f08 <malloc+0x9bc>
    4172:	31e010ef          	jal	5490 <printf>
      exit(1);
    4176:	4505                	li	a0,1
    4178:	6b3000ef          	jal	502a <exit>
      close(open(file, 0));
    417c:	4581                	li	a1,0
    417e:	854e                	mv	a0,s3
    4180:	6eb000ef          	jal	506a <open>
    4184:	6cf000ef          	jal	5052 <close>
      close(open(file, 0));
    4188:	4581                	li	a1,0
    418a:	854e                	mv	a0,s3
    418c:	6df000ef          	jal	506a <open>
    4190:	6c3000ef          	jal	5052 <close>
      close(open(file, 0));
    4194:	4581                	li	a1,0
    4196:	854e                	mv	a0,s3
    4198:	6d3000ef          	jal	506a <open>
    419c:	6b7000ef          	jal	5052 <close>
      close(open(file, 0));
    41a0:	4581                	li	a1,0
    41a2:	854e                	mv	a0,s3
    41a4:	6c7000ef          	jal	506a <open>
    41a8:	6ab000ef          	jal	5052 <close>
      close(open(file, 0));
    41ac:	4581                	li	a1,0
    41ae:	854e                	mv	a0,s3
    41b0:	6bb000ef          	jal	506a <open>
    41b4:	69f000ef          	jal	5052 <close>
      close(open(file, 0));
    41b8:	4581                	li	a1,0
    41ba:	854e                	mv	a0,s3
    41bc:	6af000ef          	jal	506a <open>
    41c0:	693000ef          	jal	5052 <close>
    if (pid == 0)
    41c4:	06090a63          	beqz	s2,4238 <concreate+0x26a>
      wait(0);
    41c8:	4501                	li	a0,0
    41ca:	669000ef          	jal	5032 <wait>
  for (i = 0; i < N; i++) {
    41ce:	2485                	addiw	s1,s1,1
    41d0:	0d548563          	beq	s1,s5,429a <concreate+0x2cc>
    file[1] = '0' + i;
    41d4:	0304879b          	addiw	a5,s1,48
    41d8:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41dc:	647000ef          	jal	5022 <fork>
    41e0:	892a                	mv	s2,a0
    if (pid < 0) {
    41e2:	f80543e3          	bltz	a0,4168 <concreate+0x19a>
    if (((i % 3) == 0 && pid == 0) || ((i % 3) == 1 && pid != 0)) {
    41e6:	03448733          	mul	a4,s1,s4
    41ea:	9301                	srli	a4,a4,0x20
    41ec:	41f4d79b          	sraiw	a5,s1,0x1f
    41f0:	9f1d                	subw	a4,a4,a5
    41f2:	0017179b          	slliw	a5,a4,0x1
    41f6:	9fb9                	addw	a5,a5,a4
    41f8:	40f487bb          	subw	a5,s1,a5
    41fc:	00a7e733          	or	a4,a5,a0
    4200:	2701                	sext.w	a4,a4
    4202:	df2d                	beqz	a4,417c <concreate+0x1ae>
    4204:	00a03733          	snez	a4,a0
    4208:	17fd                	addi	a5,a5,-1
    420a:	0017b793          	seqz	a5,a5
    420e:	8ff9                	and	a5,a5,a4
    4210:	f7b5                	bnez	a5,417c <concreate+0x1ae>
      unlink(file);
    4212:	854e                	mv	a0,s3
    4214:	667000ef          	jal	507a <unlink>
      unlink(file);
    4218:	854e                	mv	a0,s3
    421a:	661000ef          	jal	507a <unlink>
      unlink(file);
    421e:	854e                	mv	a0,s3
    4220:	65b000ef          	jal	507a <unlink>
      unlink(file);
    4224:	854e                	mv	a0,s3
    4226:	655000ef          	jal	507a <unlink>
      unlink(file);
    422a:	854e                	mv	a0,s3
    422c:	64f000ef          	jal	507a <unlink>
      unlink(file);
    4230:	854e                	mv	a0,s3
    4232:	649000ef          	jal	507a <unlink>
    4236:	b779                	j	41c4 <concreate+0x1f6>
      exit(0);
    4238:	4501                	li	a0,0
    423a:	5f1000ef          	jal	502a <exit>
      close(fd);
    423e:	615000ef          	jal	5052 <close>
    if (pid == 0) {
    4242:	b581                	j	4082 <concreate+0xb4>
      close(fd);
    4244:	60f000ef          	jal	5052 <close>
      wait(&xstatus);
    4248:	8556                	mv	a0,s5
    424a:	5e9000ef          	jal	5032 <wait>
      if (xstatus != 0)
    424e:	f5c42483          	lw	s1,-164(s0)
    4252:	e2049be3          	bnez	s1,4088 <concreate+0xba>
  for (i = 0; i < N; i++) {
    4256:	2905                	addiw	s2,s2,1
    4258:	e3490be3          	beq	s2,s4,408e <concreate+0xc0>
    file[1] = '0' + i;
    425c:	0309079b          	addiw	a5,s2,48
    4260:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    4264:	854e                	mv	a0,s3
    4266:	615000ef          	jal	507a <unlink>
    pid = fork();
    426a:	5b9000ef          	jal	5022 <fork>
    if (pid && (i % 3) == 1) {
    426e:	da050de3          	beqz	a0,4028 <concreate+0x5a>
    4272:	036907b3          	mul	a5,s2,s6
    4276:	9381                	srli	a5,a5,0x20
    4278:	41f9571b          	sraiw	a4,s2,0x1f
    427c:	9f99                	subw	a5,a5,a4
    427e:	0017971b          	slliw	a4,a5,0x1
    4282:	9fb9                	addw	a5,a5,a4
    4284:	40f907bb          	subw	a5,s2,a5
    4288:	d9778be3          	beq	a5,s7,401e <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    428c:	85e2                	mv	a1,s8
    428e:	854e                	mv	a0,s3
    4290:	5db000ef          	jal	506a <open>
      if (fd < 0) {
    4294:	fa0558e3          	bgez	a0,4244 <concreate+0x276>
    4298:	b3d1                	j	405c <concreate+0x8e>
}
    429a:	70aa                	ld	ra,168(sp)
    429c:	740a                	ld	s0,160(sp)
    429e:	64ea                	ld	s1,152(sp)
    42a0:	694a                	ld	s2,144(sp)
    42a2:	69aa                	ld	s3,136(sp)
    42a4:	6a0a                	ld	s4,128(sp)
    42a6:	7ae6                	ld	s5,120(sp)
    42a8:	7b46                	ld	s6,112(sp)
    42aa:	7ba6                	ld	s7,104(sp)
    42ac:	7c06                	ld	s8,96(sp)
    42ae:	6ce6                	ld	s9,88(sp)
    42b0:	6d46                	ld	s10,80(sp)
    42b2:	614d                	addi	sp,sp,176
    42b4:	8082                	ret

00000000000042b6 <bigfile>:
{
    42b6:	7139                	addi	sp,sp,-64
    42b8:	fc06                	sd	ra,56(sp)
    42ba:	f822                	sd	s0,48(sp)
    42bc:	f426                	sd	s1,40(sp)
    42be:	f04a                	sd	s2,32(sp)
    42c0:	ec4e                	sd	s3,24(sp)
    42c2:	e852                	sd	s4,16(sp)
    42c4:	e456                	sd	s5,8(sp)
    42c6:	e05a                	sd	s6,0(sp)
    42c8:	0080                	addi	s0,sp,64
    42ca:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    42cc:	00003517          	auipc	a0,0x3
    42d0:	10c50513          	addi	a0,a0,268 # 73d8 <malloc+0x1e8c>
    42d4:	5a7000ef          	jal	507a <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    42d8:	20200593          	li	a1,514
    42dc:	00003517          	auipc	a0,0x3
    42e0:	0fc50513          	addi	a0,a0,252 # 73d8 <malloc+0x1e8c>
    42e4:	587000ef          	jal	506a <open>
  if (fd < 0) {
    42e8:	08054a63          	bltz	a0,437c <bigfile+0xc6>
    42ec:	8a2a                	mv	s4,a0
    42ee:	4481                	li	s1,0
    memset(buf, i, SZ);
    42f0:	25800913          	li	s2,600
    42f4:	00008997          	auipc	s3,0x8
    42f8:	9c498993          	addi	s3,s3,-1596 # bcb8 <buf>
  for (i = 0; i < N; i++) {
    42fc:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42fe:	864a                	mv	a2,s2
    4300:	85a6                	mv	a1,s1
    4302:	854e                	mv	a0,s3
    4304:	2fd000ef          	jal	4e00 <memset>
    if (write(fd, buf, SZ) != SZ) {
    4308:	864a                	mv	a2,s2
    430a:	85ce                	mv	a1,s3
    430c:	8552                	mv	a0,s4
    430e:	53d000ef          	jal	504a <write>
    4312:	07251f63          	bne	a0,s2,4390 <bigfile+0xda>
  for (i = 0; i < N; i++) {
    4316:	2485                	addiw	s1,s1,1
    4318:	ff5493e3          	bne	s1,s5,42fe <bigfile+0x48>
  close(fd);
    431c:	8552                	mv	a0,s4
    431e:	535000ef          	jal	5052 <close>
  fd = open("bigfile.dat", 0);
    4322:	4581                	li	a1,0
    4324:	00003517          	auipc	a0,0x3
    4328:	0b450513          	addi	a0,a0,180 # 73d8 <malloc+0x1e8c>
    432c:	53f000ef          	jal	506a <open>
    4330:	8aaa                	mv	s5,a0
  total = 0;
    4332:	4a01                	li	s4,0
  for (i = 0;; i++) {
    4334:	4481                	li	s1,0
    cc = read(fd, buf, SZ / 2);
    4336:	12c00993          	li	s3,300
    433a:	00008917          	auipc	s2,0x8
    433e:	97e90913          	addi	s2,s2,-1666 # bcb8 <buf>
  if (fd < 0) {
    4342:	06054163          	bltz	a0,43a4 <bigfile+0xee>
    cc = read(fd, buf, SZ / 2);
    4346:	864e                	mv	a2,s3
    4348:	85ca                	mv	a1,s2
    434a:	8556                	mv	a0,s5
    434c:	4f7000ef          	jal	5042 <read>
    if (cc < 0) {
    4350:	06054463          	bltz	a0,43b8 <bigfile+0x102>
    if (cc == 0)
    4354:	c145                	beqz	a0,43f4 <bigfile+0x13e>
    if (cc != SZ / 2) {
    4356:	07351b63          	bne	a0,s3,43cc <bigfile+0x116>
    if (buf[0] != i / 2 || buf[SZ / 2 - 1] != i / 2) {
    435a:	01f4d79b          	srliw	a5,s1,0x1f
    435e:	9fa5                	addw	a5,a5,s1
    4360:	4017d79b          	sraiw	a5,a5,0x1
    4364:	00094703          	lbu	a4,0(s2)
    4368:	06f71c63          	bne	a4,a5,43e0 <bigfile+0x12a>
    436c:	12b94703          	lbu	a4,299(s2)
    4370:	06f71863          	bne	a4,a5,43e0 <bigfile+0x12a>
    total += cc;
    4374:	12ca0a1b          	addiw	s4,s4,300
  for (i = 0;; i++) {
    4378:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ / 2);
    437a:	b7f1                	j	4346 <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    437c:	85da                	mv	a1,s6
    437e:	00003517          	auipc	a0,0x3
    4382:	06a50513          	addi	a0,a0,106 # 73e8 <malloc+0x1e9c>
    4386:	10a010ef          	jal	5490 <printf>
    exit(1);
    438a:	4505                	li	a0,1
    438c:	49f000ef          	jal	502a <exit>
      printf("%s: write bigfile failed\n", s);
    4390:	85da                	mv	a1,s6
    4392:	00003517          	auipc	a0,0x3
    4396:	07650513          	addi	a0,a0,118 # 7408 <malloc+0x1ebc>
    439a:	0f6010ef          	jal	5490 <printf>
      exit(1);
    439e:	4505                	li	a0,1
    43a0:	48b000ef          	jal	502a <exit>
    printf("%s: cannot open bigfile\n", s);
    43a4:	85da                	mv	a1,s6
    43a6:	00003517          	auipc	a0,0x3
    43aa:	08250513          	addi	a0,a0,130 # 7428 <malloc+0x1edc>
    43ae:	0e2010ef          	jal	5490 <printf>
    exit(1);
    43b2:	4505                	li	a0,1
    43b4:	477000ef          	jal	502a <exit>
      printf("%s: read bigfile failed\n", s);
    43b8:	85da                	mv	a1,s6
    43ba:	00003517          	auipc	a0,0x3
    43be:	08e50513          	addi	a0,a0,142 # 7448 <malloc+0x1efc>
    43c2:	0ce010ef          	jal	5490 <printf>
      exit(1);
    43c6:	4505                	li	a0,1
    43c8:	463000ef          	jal	502a <exit>
      printf("%s: short read bigfile\n", s);
    43cc:	85da                	mv	a1,s6
    43ce:	00003517          	auipc	a0,0x3
    43d2:	09a50513          	addi	a0,a0,154 # 7468 <malloc+0x1f1c>
    43d6:	0ba010ef          	jal	5490 <printf>
      exit(1);
    43da:	4505                	li	a0,1
    43dc:	44f000ef          	jal	502a <exit>
      printf("%s: read bigfile wrong data\n", s);
    43e0:	85da                	mv	a1,s6
    43e2:	00003517          	auipc	a0,0x3
    43e6:	09e50513          	addi	a0,a0,158 # 7480 <malloc+0x1f34>
    43ea:	0a6010ef          	jal	5490 <printf>
      exit(1);
    43ee:	4505                	li	a0,1
    43f0:	43b000ef          	jal	502a <exit>
  close(fd);
    43f4:	8556                	mv	a0,s5
    43f6:	45d000ef          	jal	5052 <close>
  if (total != N * SZ) {
    43fa:	678d                	lui	a5,0x3
    43fc:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x35a>
    4400:	02fa1263          	bne	s4,a5,4424 <bigfile+0x16e>
  unlink("bigfile.dat");
    4404:	00003517          	auipc	a0,0x3
    4408:	fd450513          	addi	a0,a0,-44 # 73d8 <malloc+0x1e8c>
    440c:	46f000ef          	jal	507a <unlink>
}
    4410:	70e2                	ld	ra,56(sp)
    4412:	7442                	ld	s0,48(sp)
    4414:	74a2                	ld	s1,40(sp)
    4416:	7902                	ld	s2,32(sp)
    4418:	69e2                	ld	s3,24(sp)
    441a:	6a42                	ld	s4,16(sp)
    441c:	6aa2                	ld	s5,8(sp)
    441e:	6b02                	ld	s6,0(sp)
    4420:	6121                	addi	sp,sp,64
    4422:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    4424:	85da                	mv	a1,s6
    4426:	00003517          	auipc	a0,0x3
    442a:	07a50513          	addi	a0,a0,122 # 74a0 <malloc+0x1f54>
    442e:	062010ef          	jal	5490 <printf>
    exit(1);
    4432:	4505                	li	a0,1
    4434:	3f7000ef          	jal	502a <exit>

0000000000004438 <bigargtest>:
{
    4438:	7121                	addi	sp,sp,-448
    443a:	ff06                	sd	ra,440(sp)
    443c:	fb22                	sd	s0,432(sp)
    443e:	f726                	sd	s1,424(sp)
    4440:	0380                	addi	s0,sp,448
    4442:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    4444:	00003517          	auipc	a0,0x3
    4448:	07c50513          	addi	a0,a0,124 # 74c0 <malloc+0x1f74>
    444c:	42f000ef          	jal	507a <unlink>
  pid = fork();
    4450:	3d3000ef          	jal	5022 <fork>
  if (pid == 0) {
    4454:	c915                	beqz	a0,4488 <bigargtest+0x50>
  } else if (pid < 0) {
    4456:	08054c63          	bltz	a0,44ee <bigargtest+0xb6>
  wait(&xstatus);
    445a:	fdc40513          	addi	a0,s0,-36
    445e:	3d5000ef          	jal	5032 <wait>
  if (xstatus != 0)
    4462:	fdc42503          	lw	a0,-36(s0)
    4466:	ed51                	bnez	a0,4502 <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4468:	4581                	li	a1,0
    446a:	00003517          	auipc	a0,0x3
    446e:	05650513          	addi	a0,a0,86 # 74c0 <malloc+0x1f74>
    4472:	3f9000ef          	jal	506a <open>
  if (fd < 0) {
    4476:	08054863          	bltz	a0,4506 <bigargtest+0xce>
  close(fd);
    447a:	3d9000ef          	jal	5052 <close>
}
    447e:	70fa                	ld	ra,440(sp)
    4480:	745a                	ld	s0,432(sp)
    4482:	74ba                	ld	s1,424(sp)
    4484:	6139                	addi	sp,sp,448
    4486:	8082                	ret
    memset(big, ' ', sizeof(big));
    4488:	19000613          	li	a2,400
    448c:	02000593          	li	a1,32
    4490:	e4840513          	addi	a0,s0,-440
    4494:	16d000ef          	jal	4e00 <memset>
    big[sizeof(big) - 1] = '\0';
    4498:	fc040ba3          	sb	zero,-41(s0)
    for (i = 0; i < MAXARG - 1; i++)
    449c:	00004797          	auipc	a5,0x4
    44a0:	00478793          	addi	a5,a5,4 # 84a0 <args.1>
    44a4:	00004697          	auipc	a3,0x4
    44a8:	0f468693          	addi	a3,a3,244 # 8598 <args.1+0xf8>
      args[i] = big;
    44ac:	e4840713          	addi	a4,s0,-440
    44b0:	e398                	sd	a4,0(a5)
    for (i = 0; i < MAXARG - 1; i++)
    44b2:	07a1                	addi	a5,a5,8
    44b4:	fed79ee3          	bne	a5,a3,44b0 <bigargtest+0x78>
    args[MAXARG - 1] = 0;
    44b8:	00004797          	auipc	a5,0x4
    44bc:	0e07b023          	sd	zero,224(a5) # 8598 <args.1+0xf8>
    exec("echo", args);
    44c0:	00004597          	auipc	a1,0x4
    44c4:	fe058593          	addi	a1,a1,-32 # 84a0 <args.1>
    44c8:	00001517          	auipc	a0,0x1
    44cc:	1b050513          	addi	a0,a0,432 # 5678 <malloc+0x12c>
    44d0:	393000ef          	jal	5062 <exec>
    fd = open("bigarg-ok", O_CREATE);
    44d4:	20000593          	li	a1,512
    44d8:	00003517          	auipc	a0,0x3
    44dc:	fe850513          	addi	a0,a0,-24 # 74c0 <malloc+0x1f74>
    44e0:	38b000ef          	jal	506a <open>
    close(fd);
    44e4:	36f000ef          	jal	5052 <close>
    exit(0);
    44e8:	4501                	li	a0,0
    44ea:	341000ef          	jal	502a <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44ee:	85a6                	mv	a1,s1
    44f0:	00003517          	auipc	a0,0x3
    44f4:	fe050513          	addi	a0,a0,-32 # 74d0 <malloc+0x1f84>
    44f8:	799000ef          	jal	5490 <printf>
    exit(1);
    44fc:	4505                	li	a0,1
    44fe:	32d000ef          	jal	502a <exit>
    exit(xstatus);
    4502:	329000ef          	jal	502a <exit>
    printf("%s: bigarg test failed!\n", s);
    4506:	85a6                	mv	a1,s1
    4508:	00003517          	auipc	a0,0x3
    450c:	fe850513          	addi	a0,a0,-24 # 74f0 <malloc+0x1fa4>
    4510:	781000ef          	jal	5490 <printf>
    exit(1);
    4514:	4505                	li	a0,1
    4516:	315000ef          	jal	502a <exit>

000000000000451a <lazy_alloc>:
{
    451a:	1141                	addi	sp,sp,-16
    451c:	e406                	sd	ra,8(sp)
    451e:	e022                	sd	s0,0(sp)
    4520:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    4522:	40000537          	lui	a0,0x40000
    4526:	2e7000ef          	jal	500c <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    452a:	57fd                	li	a5,-1
    452c:	02f50a63          	beq	a0,a5,4560 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4530:	6605                	lui	a2,0x1
    4532:	962a                	add	a2,a2,a0
    4534:	400017b7          	lui	a5,0x40001
    4538:	00f50733          	add	a4,a0,a5
    453c:	87b2                	mv	a5,a2
    453e:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    4542:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    4544:	97b6                	add	a5,a5,a3
    4546:	fee79ee3          	bne	a5,a4,4542 <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    454a:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    454e:	621c                	ld	a5,0(a2)
    4550:	02c79163          	bne	a5,a2,4572 <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4554:	9636                	add	a2,a2,a3
    4556:	fee61ce3          	bne	a2,a4,454e <lazy_alloc+0x34>
  exit(0);
    455a:	4501                	li	a0,0
    455c:	2cf000ef          	jal	502a <exit>
    printf("sbrklazy() failed\n");
    4560:	00003517          	auipc	a0,0x3
    4564:	fb050513          	addi	a0,a0,-80 # 7510 <malloc+0x1fc4>
    4568:	729000ef          	jal	5490 <printf>
    exit(1);
    456c:	4505                	li	a0,1
    456e:	2bd000ef          	jal	502a <exit>
      printf("failed to read value from memory\n");
    4572:	00003517          	auipc	a0,0x3
    4576:	fb650513          	addi	a0,a0,-74 # 7528 <malloc+0x1fdc>
    457a:	717000ef          	jal	5490 <printf>
      exit(1);
    457e:	4505                	li	a0,1
    4580:	2ab000ef          	jal	502a <exit>

0000000000004584 <lazy_unmap>:
{
    4584:	7139                	addi	sp,sp,-64
    4586:	fc06                	sd	ra,56(sp)
    4588:	f822                	sd	s0,48(sp)
    458a:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    458c:	40000537          	lui	a0,0x40000
    4590:	27d000ef          	jal	500c <sbrklazy>
  if (prev_end == (char *)SBRK_ERROR) {
    4594:	57fd                	li	a5,-1
    4596:	04f50863          	beq	a0,a5,45e6 <lazy_unmap+0x62>
    459a:	f426                	sd	s1,40(sp)
    459c:	f04a                	sd	s2,32(sp)
    459e:	ec4e                	sd	s3,24(sp)
    45a0:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    45a2:	6905                	lui	s2,0x1
    45a4:	992a                	add	s2,s2,a0
    45a6:	400017b7          	lui	a5,0x40001
    45aa:	00f504b3          	add	s1,a0,a5
    45ae:	87ca                	mv	a5,s2
    45b0:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    45b4:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    45b6:	97ba                	add	a5,a5,a4
    45b8:	fe979ee3          	bne	a5,s1,45b4 <lazy_unmap+0x30>
      wait(&status);
    45bc:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45c0:	01000a37          	lui	s4,0x1000
    pid = fork();
    45c4:	25f000ef          	jal	5022 <fork>
    if (pid < 0) {
    45c8:	02054c63          	bltz	a0,4600 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    45cc:	c139                	beqz	a0,4612 <lazy_unmap+0x8e>
      wait(&status);
    45ce:	854e                	mv	a0,s3
    45d0:	263000ef          	jal	5032 <wait>
      if (status == 0) {
    45d4:	fcc42783          	lw	a5,-52(s0)
    45d8:	c7b1                	beqz	a5,4624 <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45da:	9952                	add	s2,s2,s4
    45dc:	fe9914e3          	bne	s2,s1,45c4 <lazy_unmap+0x40>
  exit(0);
    45e0:	4501                	li	a0,0
    45e2:	249000ef          	jal	502a <exit>
    45e6:	f426                	sd	s1,40(sp)
    45e8:	f04a                	sd	s2,32(sp)
    45ea:	ec4e                	sd	s3,24(sp)
    45ec:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45ee:	00003517          	auipc	a0,0x3
    45f2:	f2250513          	addi	a0,a0,-222 # 7510 <malloc+0x1fc4>
    45f6:	69b000ef          	jal	5490 <printf>
    exit(1);
    45fa:	4505                	li	a0,1
    45fc:	22f000ef          	jal	502a <exit>
      printf("error forking\n");
    4600:	00003517          	auipc	a0,0x3
    4604:	f5050513          	addi	a0,a0,-176 # 7550 <malloc+0x2004>
    4608:	689000ef          	jal	5490 <printf>
      exit(1);
    460c:	4505                	li	a0,1
    460e:	21d000ef          	jal	502a <exit>
      sbrklazy(-1L * REGION_SZ);
    4612:	c0000537          	lui	a0,0xc0000
    4616:	1f7000ef          	jal	500c <sbrklazy>
      *(char **)i = i;
    461a:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x10c>
      exit(0);
    461e:	4501                	li	a0,0
    4620:	20b000ef          	jal	502a <exit>
        printf("memory not unmapped\n");
    4624:	00003517          	auipc	a0,0x3
    4628:	f3c50513          	addi	a0,a0,-196 # 7560 <malloc+0x2014>
    462c:	665000ef          	jal	5490 <printf>
        exit(1);
    4630:	4505                	li	a0,1
    4632:	1f9000ef          	jal	502a <exit>

0000000000004636 <lazy_copy>:
{
    4636:	7119                	addi	sp,sp,-128
    4638:	fc86                	sd	ra,120(sp)
    463a:	f8a2                	sd	s0,112(sp)
    463c:	f4a6                	sd	s1,104(sp)
    463e:	f0ca                	sd	s2,96(sp)
    4640:	ecce                	sd	s3,88(sp)
    4642:	e8d2                	sd	s4,80(sp)
    4644:	e4d6                	sd	s5,72(sp)
    4646:	e0da                	sd	s6,64(sp)
    4648:	fc5e                	sd	s7,56(sp)
    464a:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    464c:	4501                	li	a0,0
    464e:	1a9000ef          	jal	4ff6 <sbrk>
    4652:	84aa                	mv	s1,a0
    sbrklazy(4 * PGSIZE);
    4654:	6511                	lui	a0,0x4
    4656:	1b7000ef          	jal	500c <sbrklazy>
    open(p + 8192, 0);
    465a:	4581                	li	a1,0
    465c:	6509                	lui	a0,0x2
    465e:	9526                	add	a0,a0,s1
    4660:	20b000ef          	jal	506a <open>
    void *xx = sbrk(0);
    4664:	4501                	li	a0,0
    4666:	191000ef          	jal	4ff6 <sbrk>
    466a:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64)xx) + 1));
    466c:	fff54513          	not	a0,a0
    4670:	2501                	sext.w	a0,a0
    4672:	185000ef          	jal	4ff6 <sbrk>
    if (ret != xx) {
    4676:	00a48c63          	beq	s1,a0,468e <lazy_copy+0x58>
    467a:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    467c:	00003517          	auipc	a0,0x3
    4680:	efc50513          	addi	a0,a0,-260 # 7578 <malloc+0x202c>
    4684:	60d000ef          	jal	5490 <printf>
      exit(1);
    4688:	4505                	li	a0,1
    468a:	1a1000ef          	jal	502a <exit>
  unsigned long bad[] = {
    468e:	00003797          	auipc	a5,0x3
    4692:	56278793          	addi	a5,a5,1378 # 7bf0 <malloc+0x26a4>
    4696:	7fa8                	ld	a0,120(a5)
    4698:	63cc                	ld	a1,128(a5)
    469a:	67d0                	ld	a2,136(a5)
    469c:	6bd4                	ld	a3,144(a5)
    469e:	6fd8                	ld	a4,152(a5)
    46a0:	f8a43023          	sd	a0,-128(s0)
    46a4:	f8b43423          	sd	a1,-120(s0)
    46a8:	f8c43823          	sd	a2,-112(s0)
    46ac:	f8d43c23          	sd	a3,-104(s0)
    46b0:	fae43023          	sd	a4,-96(s0)
    46b4:	73dc                	ld	a5,160(a5)
    46b6:	faf43423          	sd	a5,-88(s0)
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    46ba:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    46be:	00001a97          	auipc	s5,0x1
    46c2:	192a8a93          	addi	s5,s5,402 # 5850 <malloc+0x304>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    46c6:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    46ca:	60200b93          	li	s7,1538
    46ce:	00001b17          	auipc	s6,0x1
    46d2:	092b0b13          	addi	s6,s6,146 # 5760 <malloc+0x214>
    int fd = open("README", 0);
    46d6:	4581                	li	a1,0
    46d8:	8556                	mv	a0,s5
    46da:	191000ef          	jal	506a <open>
    46de:	84aa                	mv	s1,a0
    if (fd < 0) {
    46e0:	04054563          	bltz	a0,472a <lazy_copy+0xf4>
    if (read(fd, (char *)bad[i], 512) >= 0) {
    46e4:	00093983          	ld	s3,0(s2)
    46e8:	8652                	mv	a2,s4
    46ea:	85ce                	mv	a1,s3
    46ec:	157000ef          	jal	5042 <read>
    46f0:	04055663          	bgez	a0,473c <lazy_copy+0x106>
    close(fd);
    46f4:	8526                	mv	a0,s1
    46f6:	15d000ef          	jal	5052 <close>
    fd = open("junk", O_CREATE | O_RDWR | O_TRUNC);
    46fa:	85de                	mv	a1,s7
    46fc:	855a                	mv	a0,s6
    46fe:	16d000ef          	jal	506a <open>
    4702:	84aa                	mv	s1,a0
    if (fd < 0) {
    4704:	04054563          	bltz	a0,474e <lazy_copy+0x118>
    if (write(fd, (char *)bad[i], 512) >= 0) {
    4708:	8652                	mv	a2,s4
    470a:	85ce                	mv	a1,s3
    470c:	13f000ef          	jal	504a <write>
    4710:	04055863          	bgez	a0,4760 <lazy_copy+0x12a>
    close(fd);
    4714:	8526                	mv	a0,s1
    4716:	13d000ef          	jal	5052 <close>
  for (int i = 0; i < sizeof(bad) / sizeof(bad[0]); i++) {
    471a:	0921                	addi	s2,s2,8
    471c:	fb040793          	addi	a5,s0,-80
    4720:	faf91be3          	bne	s2,a5,46d6 <lazy_copy+0xa0>
  exit(0);
    4724:	4501                	li	a0,0
    4726:	105000ef          	jal	502a <exit>
      printf("cannot open README\n");
    472a:	00003517          	auipc	a0,0x3
    472e:	e7e50513          	addi	a0,a0,-386 # 75a8 <malloc+0x205c>
    4732:	55f000ef          	jal	5490 <printf>
      exit(1);
    4736:	4505                	li	a0,1
    4738:	0f3000ef          	jal	502a <exit>
      printf("read succeeded\n");
    473c:	00003517          	auipc	a0,0x3
    4740:	e8450513          	addi	a0,a0,-380 # 75c0 <malloc+0x2074>
    4744:	54d000ef          	jal	5490 <printf>
      exit(1);
    4748:	4505                	li	a0,1
    474a:	0e1000ef          	jal	502a <exit>
      printf("cannot open junk\n");
    474e:	00003517          	auipc	a0,0x3
    4752:	e8250513          	addi	a0,a0,-382 # 75d0 <malloc+0x2084>
    4756:	53b000ef          	jal	5490 <printf>
      exit(1);
    475a:	4505                	li	a0,1
    475c:	0cf000ef          	jal	502a <exit>
      printf("write succeeded\n");
    4760:	00003517          	auipc	a0,0x3
    4764:	e8850513          	addi	a0,a0,-376 # 75e8 <malloc+0x209c>
    4768:	529000ef          	jal	5490 <printf>
      exit(1);
    476c:	4505                	li	a0,1
    476e:	0bd000ef          	jal	502a <exit>

0000000000004772 <lazy_sbrk>:
{
    4772:	7179                	addi	sp,sp,-48
    4774:	f406                	sd	ra,40(sp)
    4776:	f022                	sd	s0,32(sp)
    4778:	ec26                	sd	s1,24(sp)
    477a:	e84a                	sd	s2,16(sp)
    477c:	e44e                	sd	s3,8(sp)
    477e:	1800                	addi	s0,sp,48
  char *p = sbrk(0);
    4780:	4501                	li	a0,0
    4782:	075000ef          	jal	4ff6 <sbrk>
    4786:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    4788:	0ff00793          	li	a5,255
    478c:	07fa                	slli	a5,a5,0x1e
    478e:	00f57e63          	bgeu	a0,a5,47aa <lazy_sbrk+0x38>
    p = sbrklazy(1 << 30);
    4792:	400009b7          	lui	s3,0x40000
  while ((uint64)p < MAXVA - (1 << 30)) {
    4796:	893e                	mv	s2,a5
    p = sbrklazy(1 << 30);
    4798:	854e                	mv	a0,s3
    479a:	073000ef          	jal	500c <sbrklazy>
    p = sbrklazy(0);
    479e:	4501                	li	a0,0
    47a0:	06d000ef          	jal	500c <sbrklazy>
    47a4:	84aa                	mv	s1,a0
  while ((uint64)p < MAXVA - (1 << 30)) {
    47a6:	ff2569e3          	bltu	a0,s2,4798 <lazy_sbrk+0x26>
  int n = TRAPFRAME - PGSIZE - (uint64)p;
    47aa:	7975                	lui	s2,0xffffd
    47ac:	4099093b          	subw	s2,s2,s1
  char *p1 = sbrklazy(n);
    47b0:	854a                	mv	a0,s2
    47b2:	05b000ef          	jal	500c <sbrklazy>
    47b6:	862a                	mv	a2,a0
  if (p1 < 0 || p1 != p) {
    47b8:	00950d63          	beq	a0,s1,47d2 <lazy_sbrk+0x60>
    printf("sbrklazy(%d) returned %p, not expected %p\n", n, p1, p);
    47bc:	86a6                	mv	a3,s1
    47be:	85ca                	mv	a1,s2
    47c0:	00003517          	auipc	a0,0x3
    47c4:	e4050513          	addi	a0,a0,-448 # 7600 <malloc+0x20b4>
    47c8:	4c9000ef          	jal	5490 <printf>
    exit(1);
    47cc:	4505                	li	a0,1
    47ce:	05d000ef          	jal	502a <exit>
  p = sbrk(PGSIZE);
    47d2:	6505                	lui	a0,0x1
    47d4:	023000ef          	jal	4ff6 <sbrk>
    47d8:	862a                	mv	a2,a0
  if (p < 0 || (uint64)p != TRAPFRAME - PGSIZE) {
    47da:	040007b7          	lui	a5,0x4000
    47de:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    47e0:	07b2                	slli	a5,a5,0xc
    47e2:	00f50c63          	beq	a0,a5,47fa <lazy_sbrk+0x88>
    printf("sbrk(%d) returned %p, not expected TRAPFRAME-PGSIZE\n", PGSIZE, p);
    47e6:	6585                	lui	a1,0x1
    47e8:	00003517          	auipc	a0,0x3
    47ec:	e4850513          	addi	a0,a0,-440 # 7630 <malloc+0x20e4>
    47f0:	4a1000ef          	jal	5490 <printf>
    exit(1);
    47f4:	4505                	li	a0,1
    47f6:	035000ef          	jal	502a <exit>
  p[0] = 1;
    47fa:	040007b7          	lui	a5,0x4000
    47fe:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ff1345>
    4800:	07b2                	slli	a5,a5,0xc
    4802:	4705                	li	a4,1
    4804:	00e78023          	sb	a4,0(a5)
  if (p[1] != 0) {
    4808:	0017c783          	lbu	a5,1(a5)
    480c:	cb91                	beqz	a5,4820 <lazy_sbrk+0xae>
    printf("sbrk() returned non-zero-filled memory\n");
    480e:	00003517          	auipc	a0,0x3
    4812:	e5a50513          	addi	a0,a0,-422 # 7668 <malloc+0x211c>
    4816:	47b000ef          	jal	5490 <printf>
    exit(1);
    481a:	4505                	li	a0,1
    481c:	00f000ef          	jal	502a <exit>
  p = sbrk(1);
    4820:	4505                	li	a0,1
    4822:	7d4000ef          	jal	4ff6 <sbrk>
    4826:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4828:	57fd                	li	a5,-1
    482a:	00f50b63          	beq	a0,a5,4840 <lazy_sbrk+0xce>
    printf("sbrk(1) returned %p, expected error\n", p);
    482e:	00003517          	auipc	a0,0x3
    4832:	e6250513          	addi	a0,a0,-414 # 7690 <malloc+0x2144>
    4836:	45b000ef          	jal	5490 <printf>
    exit(1);
    483a:	4505                	li	a0,1
    483c:	7ee000ef          	jal	502a <exit>
  p = sbrklazy(1);
    4840:	4505                	li	a0,1
    4842:	7ca000ef          	jal	500c <sbrklazy>
    4846:	85aa                	mv	a1,a0
  if ((uint64)p != -1) {
    4848:	57fd                	li	a5,-1
    484a:	00f50b63          	beq	a0,a5,4860 <lazy_sbrk+0xee>
    printf("sbrklazy(1) returned %p, expected error\n", p);
    484e:	00003517          	auipc	a0,0x3
    4852:	e6a50513          	addi	a0,a0,-406 # 76b8 <malloc+0x216c>
    4856:	43b000ef          	jal	5490 <printf>
    exit(1);
    485a:	4505                	li	a0,1
    485c:	7ce000ef          	jal	502a <exit>
  exit(0);
    4860:	4501                	li	a0,0
    4862:	7c8000ef          	jal	502a <exit>

0000000000004866 <fsfull>:
{
    4866:	7171                	addi	sp,sp,-176
    4868:	f506                	sd	ra,168(sp)
    486a:	f122                	sd	s0,160(sp)
    486c:	ed26                	sd	s1,152(sp)
    486e:	e94a                	sd	s2,144(sp)
    4870:	e54e                	sd	s3,136(sp)
    4872:	e152                	sd	s4,128(sp)
    4874:	fcd6                	sd	s5,120(sp)
    4876:	f8da                	sd	s6,112(sp)
    4878:	f4de                	sd	s7,104(sp)
    487a:	f0e2                	sd	s8,96(sp)
    487c:	ece6                	sd	s9,88(sp)
    487e:	e8ea                	sd	s10,80(sp)
    4880:	e4ee                	sd	s11,72(sp)
    4882:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4884:	00003517          	auipc	a0,0x3
    4888:	e6450513          	addi	a0,a0,-412 # 76e8 <malloc+0x219c>
    488c:	405000ef          	jal	5490 <printf>
  for (nfiles = 0;; nfiles++) {
    4890:	4481                	li	s1,0
    name[0] = 'f';
    4892:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    4896:	10625cb7          	lui	s9,0x10625
    489a:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    489e:	51eb8ab7          	lui	s5,0x51eb8
    48a2:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    48a6:	66666a37          	lui	s4,0x66666
    48aa:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579af>
    printf("writing %s\n", name);
    48ae:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    48b2:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    48b6:	039487b3          	mul	a5,s1,s9
    48ba:	9799                	srai	a5,a5,0x26
    48bc:	41f4d69b          	sraiw	a3,s1,0x1f
    48c0:	9f95                	subw	a5,a5,a3
    48c2:	0307871b          	addiw	a4,a5,48
    48c6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    48ca:	3e800713          	li	a4,1000
    48ce:	02f707bb          	mulw	a5,a4,a5
    48d2:	40f487bb          	subw	a5,s1,a5
    48d6:	03578733          	mul	a4,a5,s5
    48da:	9715                	srai	a4,a4,0x25
    48dc:	41f7d79b          	sraiw	a5,a5,0x1f
    48e0:	40f707bb          	subw	a5,a4,a5
    48e4:	0307879b          	addiw	a5,a5,48
    48e8:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    48ec:	035487b3          	mul	a5,s1,s5
    48f0:	9795                	srai	a5,a5,0x25
    48f2:	9f95                	subw	a5,a5,a3
    48f4:	06400713          	li	a4,100
    48f8:	02f707bb          	mulw	a5,a4,a5
    48fc:	40f487bb          	subw	a5,s1,a5
    4900:	03478733          	mul	a4,a5,s4
    4904:	9709                	srai	a4,a4,0x22
    4906:	41f7d79b          	sraiw	a5,a5,0x1f
    490a:	40f707bb          	subw	a5,a4,a5
    490e:	0307879b          	addiw	a5,a5,48
    4912:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    4916:	03448733          	mul	a4,s1,s4
    491a:	9709                	srai	a4,a4,0x22
    491c:	9f15                	subw	a4,a4,a3
    491e:	0027179b          	slliw	a5,a4,0x2
    4922:	9fb9                	addw	a5,a5,a4
    4924:	0017979b          	slliw	a5,a5,0x1
    4928:	40f487bb          	subw	a5,s1,a5
    492c:	0307879b          	addiw	a5,a5,48
    4930:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4934:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    4938:	85ea                	mv	a1,s10
    493a:	00003517          	auipc	a0,0x3
    493e:	dbe50513          	addi	a0,a0,-578 # 76f8 <malloc+0x21ac>
    4942:	34f000ef          	jal	5490 <printf>
    int fd = open(name, O_CREATE | O_RDWR);
    4946:	20200593          	li	a1,514
    494a:	856a                	mv	a0,s10
    494c:	71e000ef          	jal	506a <open>
    4950:	892a                	mv	s2,a0
    if (fd < 0) {
    4952:	0e055b63          	bgez	a0,4a48 <fsfull+0x1e2>
      printf("open %s failed\n", name);
    4956:	f5040593          	addi	a1,s0,-176
    495a:	00003517          	auipc	a0,0x3
    495e:	dae50513          	addi	a0,a0,-594 # 7708 <malloc+0x21bc>
    4962:	32f000ef          	jal	5490 <printf>
  while (nfiles >= 0) {
    4966:	0a04cc63          	bltz	s1,4a1e <fsfull+0x1b8>
    name[0] = 'f';
    496a:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    496e:	10625a37          	lui	s4,0x10625
    4972:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061611b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4976:	3e800b93          	li	s7,1000
    497a:	51eb89b7          	lui	s3,0x51eb8
    497e:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea9867>
    name[3] = '0' + (nfiles % 100) / 10;
    4982:	06400b13          	li	s6,100
    4986:	66666937          	lui	s2,0x66666
    498a:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579af>
    unlink(name);
    498e:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4992:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    4996:	034487b3          	mul	a5,s1,s4
    499a:	9799                	srai	a5,a5,0x26
    499c:	41f4d69b          	sraiw	a3,s1,0x1f
    49a0:	9f95                	subw	a5,a5,a3
    49a2:	0307871b          	addiw	a4,a5,48
    49a6:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    49aa:	02fb87bb          	mulw	a5,s7,a5
    49ae:	40f487bb          	subw	a5,s1,a5
    49b2:	03378733          	mul	a4,a5,s3
    49b6:	9715                	srai	a4,a4,0x25
    49b8:	41f7d79b          	sraiw	a5,a5,0x1f
    49bc:	40f707bb          	subw	a5,a4,a5
    49c0:	0307879b          	addiw	a5,a5,48
    49c4:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    49c8:	033487b3          	mul	a5,s1,s3
    49cc:	9795                	srai	a5,a5,0x25
    49ce:	9f95                	subw	a5,a5,a3
    49d0:	02fb07bb          	mulw	a5,s6,a5
    49d4:	40f487bb          	subw	a5,s1,a5
    49d8:	03278733          	mul	a4,a5,s2
    49dc:	9709                	srai	a4,a4,0x22
    49de:	41f7d79b          	sraiw	a5,a5,0x1f
    49e2:	40f707bb          	subw	a5,a4,a5
    49e6:	0307879b          	addiw	a5,a5,48
    49ea:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    49ee:	03248733          	mul	a4,s1,s2
    49f2:	9709                	srai	a4,a4,0x22
    49f4:	9f15                	subw	a4,a4,a3
    49f6:	0027179b          	slliw	a5,a4,0x2
    49fa:	9fb9                	addw	a5,a5,a4
    49fc:	0017979b          	slliw	a5,a5,0x1
    4a00:	40f487bb          	subw	a5,s1,a5
    4a04:	0307879b          	addiw	a5,a5,48
    4a08:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4a0c:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    4a10:	8556                	mv	a0,s5
    4a12:	668000ef          	jal	507a <unlink>
    nfiles--;
    4a16:	34fd                	addiw	s1,s1,-1
  while (nfiles >= 0) {
    4a18:	57fd                	li	a5,-1
    4a1a:	f6f49ce3          	bne	s1,a5,4992 <fsfull+0x12c>
  printf("fsfull test finished\n");
    4a1e:	00003517          	auipc	a0,0x3
    4a22:	d0a50513          	addi	a0,a0,-758 # 7728 <malloc+0x21dc>
    4a26:	26b000ef          	jal	5490 <printf>
}
    4a2a:	70aa                	ld	ra,168(sp)
    4a2c:	740a                	ld	s0,160(sp)
    4a2e:	64ea                	ld	s1,152(sp)
    4a30:	694a                	ld	s2,144(sp)
    4a32:	69aa                	ld	s3,136(sp)
    4a34:	6a0a                	ld	s4,128(sp)
    4a36:	7ae6                	ld	s5,120(sp)
    4a38:	7b46                	ld	s6,112(sp)
    4a3a:	7ba6                	ld	s7,104(sp)
    4a3c:	7c06                	ld	s8,96(sp)
    4a3e:	6ce6                	ld	s9,88(sp)
    4a40:	6d46                	ld	s10,80(sp)
    4a42:	6da6                	ld	s11,72(sp)
    4a44:	614d                	addi	sp,sp,176
    4a46:	8082                	ret
    int total = 0;
    4a48:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    4a4a:	40000c13          	li	s8,1024
    4a4e:	00007b97          	auipc	s7,0x7
    4a52:	26ab8b93          	addi	s7,s7,618 # bcb8 <buf>
      if (cc < BSIZE)
    4a56:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    4a5a:	8662                	mv	a2,s8
    4a5c:	85de                	mv	a1,s7
    4a5e:	854a                	mv	a0,s2
    4a60:	5ea000ef          	jal	504a <write>
      if (cc < BSIZE)
    4a64:	00ab5563          	bge	s6,a0,4a6e <fsfull+0x208>
      total += cc;
    4a68:	00a989bb          	addw	s3,s3,a0
    while (1) {
    4a6c:	b7fd                	j	4a5a <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    4a6e:	85ce                	mv	a1,s3
    4a70:	00003517          	auipc	a0,0x3
    4a74:	ca850513          	addi	a0,a0,-856 # 7718 <malloc+0x21cc>
    4a78:	219000ef          	jal	5490 <printf>
    close(fd);
    4a7c:	854a                	mv	a0,s2
    4a7e:	5d4000ef          	jal	5052 <close>
    if (total == 0)
    4a82:	ee0982e3          	beqz	s3,4966 <fsfull+0x100>
  for (nfiles = 0;; nfiles++) {
    4a86:	2485                	addiw	s1,s1,1
    4a88:	b52d                	j	48b2 <fsfull+0x4c>

0000000000004a8a <run>:

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s)
{
    4a8a:	7179                	addi	sp,sp,-48
    4a8c:	f406                	sd	ra,40(sp)
    4a8e:	f022                	sd	s0,32(sp)
    4a90:	ec26                	sd	s1,24(sp)
    4a92:	e84a                	sd	s2,16(sp)
    4a94:	1800                	addi	s0,sp,48
    4a96:	84aa                	mv	s1,a0
    4a98:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    4a9a:	00003517          	auipc	a0,0x3
    4a9e:	ca650513          	addi	a0,a0,-858 # 7740 <malloc+0x21f4>
    4aa2:	1ef000ef          	jal	5490 <printf>
  if ((pid = fork()) < 0) {
    4aa6:	57c000ef          	jal	5022 <fork>
    4aaa:	02054a63          	bltz	a0,4ade <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if (pid == 0) {
    4aae:	c129                	beqz	a0,4af0 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4ab0:	fdc40513          	addi	a0,s0,-36
    4ab4:	57e000ef          	jal	5032 <wait>
    if (xstatus != 0)
    4ab8:	fdc42783          	lw	a5,-36(s0)
    4abc:	cf9d                	beqz	a5,4afa <run+0x70>
      printf("FAILED\n");
    4abe:	00003517          	auipc	a0,0x3
    4ac2:	caa50513          	addi	a0,a0,-854 # 7768 <malloc+0x221c>
    4ac6:	1cb000ef          	jal	5490 <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    4aca:	fdc42503          	lw	a0,-36(s0)
  }
}
    4ace:	00153513          	seqz	a0,a0
    4ad2:	70a2                	ld	ra,40(sp)
    4ad4:	7402                	ld	s0,32(sp)
    4ad6:	64e2                	ld	s1,24(sp)
    4ad8:	6942                	ld	s2,16(sp)
    4ada:	6145                	addi	sp,sp,48
    4adc:	8082                	ret
    printf("runtest: fork error\n");
    4ade:	00003517          	auipc	a0,0x3
    4ae2:	c7250513          	addi	a0,a0,-910 # 7750 <malloc+0x2204>
    4ae6:	1ab000ef          	jal	5490 <printf>
    exit(1);
    4aea:	4505                	li	a0,1
    4aec:	53e000ef          	jal	502a <exit>
    f(s);
    4af0:	854a                	mv	a0,s2
    4af2:	9482                	jalr	s1
    exit(0);
    4af4:	4501                	li	a0,0
    4af6:	534000ef          	jal	502a <exit>
      printf("OK\n");
    4afa:	00003517          	auipc	a0,0x3
    4afe:	c7650513          	addi	a0,a0,-906 # 7770 <malloc+0x2224>
    4b02:	18f000ef          	jal	5490 <printf>
    4b06:	b7d1                	j	4aca <run+0x40>

0000000000004b08 <runtests>:

int
runtests(struct test *tests, char *justone, int continuous)
{
    4b08:	7179                	addi	sp,sp,-48
    4b0a:	f406                	sd	ra,40(sp)
    4b0c:	f022                	sd	s0,32(sp)
    4b0e:	ec26                	sd	s1,24(sp)
    4b10:	e44e                	sd	s3,8(sp)
    4b12:	1800                	addi	s0,sp,48
    4b14:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    4b16:	6508                	ld	a0,8(a0)
    4b18:	c125                	beqz	a0,4b78 <runtests+0x70>
    4b1a:	e84a                	sd	s2,16(sp)
    4b1c:	e052                	sd	s4,0(sp)
    4b1e:	892e                	mv	s2,a1
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if (!run(t->f, t->s)) {
        if (continuous != 2) {
    4b20:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x10a>
    4b22:	00c03a33          	snez	s4,a2
  int ntests = 0;
    4b26:	4981                	li	s3,0
    4b28:	a831                	j	4b44 <runtests+0x3c>
      if (!run(t->f, t->s)) {
    4b2a:	648c                	ld	a1,8(s1)
    4b2c:	6088                	ld	a0,0(s1)
    4b2e:	f5dff0ef          	jal	4a8a <run>
    4b32:	00153513          	seqz	a0,a0
        if (continuous != 2) {
    4b36:	00aa7533          	and	a0,s4,a0
    4b3a:	ed01                	bnez	a0,4b52 <runtests+0x4a>
      ntests++;
    4b3c:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    4b3e:	04c1                	addi	s1,s1,16
    4b40:	6488                	ld	a0,8(s1)
    4b42:	c115                	beqz	a0,4b66 <runtests+0x5e>
    if ((justone == 0) || strcmp(t->s, justone) == 0) {
    4b44:	fe0903e3          	beqz	s2,4b2a <runtests+0x22>
    4b48:	85ca                	mv	a1,s2
    4b4a:	25a000ef          	jal	4da4 <strcmp>
    4b4e:	f965                	bnez	a0,4b3e <runtests+0x36>
    4b50:	bfe9                	j	4b2a <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4b52:	00003517          	auipc	a0,0x3
    4b56:	c2650513          	addi	a0,a0,-986 # 7778 <malloc+0x222c>
    4b5a:	137000ef          	jal	5490 <printf>
          return -1;
    4b5e:	59fd                	li	s3,-1
    4b60:	6942                	ld	s2,16(sp)
    4b62:	6a02                	ld	s4,0(sp)
    4b64:	a019                	j	4b6a <runtests+0x62>
    4b66:	6942                	ld	s2,16(sp)
    4b68:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4b6a:	854e                	mv	a0,s3
    4b6c:	70a2                	ld	ra,40(sp)
    4b6e:	7402                	ld	s0,32(sp)
    4b70:	64e2                	ld	s1,24(sp)
    4b72:	69a2                	ld	s3,8(sp)
    4b74:	6145                	addi	sp,sp,48
    4b76:	8082                	ret
  return ntests;
    4b78:	4981                	li	s3,0
    4b7a:	bfc5                	j	4b6a <runtests+0x62>

0000000000004b7c <countfree>:

// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4b7c:	7179                	addi	sp,sp,-48
    4b7e:	f406                	sd	ra,40(sp)
    4b80:	f022                	sd	s0,32(sp)
    4b82:	ec26                	sd	s1,24(sp)
    4b84:	e84a                	sd	s2,16(sp)
    4b86:	e44e                	sd	s3,8(sp)
    4b88:	e052                	sd	s4,0(sp)
    4b8a:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4b8c:	4501                	li	a0,0
    4b8e:	468000ef          	jal	4ff6 <sbrk>
    4b92:	8a2a                	mv	s4,a0
  int n = 0;
    4b94:	4481                	li	s1,0
  while (1) {
    char *a = sbrk(PGSIZE);
    4b96:	6985                	lui	s3,0x1
    if (a == SBRK_ERROR) {
    4b98:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4b9a:	854e                	mv	a0,s3
    4b9c:	45a000ef          	jal	4ff6 <sbrk>
    if (a == SBRK_ERROR) {
    4ba0:	01250463          	beq	a0,s2,4ba8 <countfree+0x2c>
      break;
    }
    n += 1;
    4ba4:	2485                	addiw	s1,s1,1
  while (1) {
    4ba6:	bfd5                	j	4b9a <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
    4ba8:	4501                	li	a0,0
    4baa:	44c000ef          	jal	4ff6 <sbrk>
    4bae:	40aa053b          	subw	a0,s4,a0
    4bb2:	444000ef          	jal	4ff6 <sbrk>
  return n;
}
    4bb6:	8526                	mv	a0,s1
    4bb8:	70a2                	ld	ra,40(sp)
    4bba:	7402                	ld	s0,32(sp)
    4bbc:	64e2                	ld	s1,24(sp)
    4bbe:	6942                	ld	s2,16(sp)
    4bc0:	69a2                	ld	s3,8(sp)
    4bc2:	6a02                	ld	s4,0(sp)
    4bc4:	6145                	addi	sp,sp,48
    4bc6:	8082                	ret

0000000000004bc8 <drivetests>:

int
drivetests(int quick, int continuous, char *justone)
{
    4bc8:	7159                	addi	sp,sp,-112
    4bca:	f486                	sd	ra,104(sp)
    4bcc:	f0a2                	sd	s0,96(sp)
    4bce:	eca6                	sd	s1,88(sp)
    4bd0:	e8ca                	sd	s2,80(sp)
    4bd2:	e4ce                	sd	s3,72(sp)
    4bd4:	e0d2                	sd	s4,64(sp)
    4bd6:	fc56                	sd	s5,56(sp)
    4bd8:	f85a                	sd	s6,48(sp)
    4bda:	f45e                	sd	s7,40(sp)
    4bdc:	f062                	sd	s8,32(sp)
    4bde:	ec66                	sd	s9,24(sp)
    4be0:	e86a                	sd	s10,16(sp)
    4be2:	e46e                	sd	s11,8(sp)
    4be4:	1880                	addi	s0,sp,112
    4be6:	8aaa                	mv	s5,a0
    4be8:	89ae                	mv	s3,a1
    4bea:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if (continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4bec:	00c03cb3          	snez	s9,a2
    printf("usertests starting\n");
    4bf0:	00003c17          	auipc	s8,0x3
    4bf4:	ba0c0c13          	addi	s8,s8,-1120 # 7790 <malloc+0x2244>
    n = runtests(quicktests, justone, continuous);
    4bf8:	00003b97          	auipc	s7,0x3
    4bfc:	418b8b93          	addi	s7,s7,1048 # 8010 <quicktests>
      if (continuous != 2) {
    4c00:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4c02:	00004d17          	auipc	s10,0x4
    4c06:	81ed0d13          	addi	s10,s10,-2018 # 8420 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4c0a:	00003d97          	auipc	s11,0x3
    4c0e:	bbed8d93          	addi	s11,s11,-1090 # 77c8 <malloc+0x227c>
    4c12:	a80d                	j	4c44 <drivetests+0x7c>
      if (continuous != 2) {
    4c14:	09699563          	bne	s3,s6,4c9e <drivetests+0xd6>
    int ntests = 0;
    4c18:	4481                	li	s1,0
    4c1a:	a099                	j	4c60 <drivetests+0x98>
        printf("usertests slow tests starting\n");
    4c1c:	00003517          	auipc	a0,0x3
    4c20:	b8c50513          	addi	a0,a0,-1140 # 77a8 <malloc+0x225c>
    4c24:	06d000ef          	jal	5490 <printf>
    4c28:	a081                	j	4c68 <drivetests+0xa0>
        if (continuous != 2) {
    4c2a:	07699a63          	bne	s3,s6,4c9e <drivetests+0xd6>
    if ((free1 = countfree()) < free0) {
    4c2e:	f4fff0ef          	jal	4b7c <countfree>
    4c32:	05254463          	blt	a0,s2,4c7a <drivetests+0xb2>
    if (justone != 0 && ntests == 0) {
    4c36:	0014b493          	seqz	s1,s1
    4c3a:	009cf4b3          	and	s1,s9,s1
    4c3e:	e8b1                	bnez	s1,4c92 <drivetests+0xca>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while (continuous);
    4c40:	06098f63          	beqz	s3,4cbe <drivetests+0xf6>
    printf("usertests starting\n");
    4c44:	8562                	mv	a0,s8
    4c46:	04b000ef          	jal	5490 <printf>
    int free0 = countfree();
    4c4a:	f33ff0ef          	jal	4b7c <countfree>
    4c4e:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4c50:	864e                	mv	a2,s3
    4c52:	85d2                	mv	a1,s4
    4c54:	855e                	mv	a0,s7
    4c56:	eb3ff0ef          	jal	4b08 <runtests>
    4c5a:	84aa                	mv	s1,a0
    if (n < 0) {
    4c5c:	fa054ce3          	bltz	a0,4c14 <drivetests+0x4c>
    if (!quick) {
    4c60:	fc0a97e3          	bnez	s5,4c2e <drivetests+0x66>
      if (justone == 0)
    4c64:	fa0a0ce3          	beqz	s4,4c1c <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4c68:	864e                	mv	a2,s3
    4c6a:	85d2                	mv	a1,s4
    4c6c:	856a                	mv	a0,s10
    4c6e:	e9bff0ef          	jal	4b08 <runtests>
      if (n < 0) {
    4c72:	fa054ce3          	bltz	a0,4c2a <drivetests+0x62>
        ntests += n;
    4c76:	9ca9                	addw	s1,s1,a0
    4c78:	bf5d                	j	4c2e <drivetests+0x66>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4c7a:	864a                	mv	a2,s2
    4c7c:	85aa                	mv	a1,a0
    4c7e:	856e                	mv	a0,s11
    4c80:	011000ef          	jal	5490 <printf>
      if (continuous != 2) {
    4c84:	01699d63          	bne	s3,s6,4c9e <drivetests+0xd6>
    if (justone != 0 && ntests == 0) {
    4c88:	0014b493          	seqz	s1,s1
    4c8c:	009cf4b3          	and	s1,s9,s1
    4c90:	d8d5                	beqz	s1,4c44 <drivetests+0x7c>
      printf("NO TESTS EXECUTED\n");
    4c92:	00003517          	auipc	a0,0x3
    4c96:	b6650513          	addi	a0,a0,-1178 # 77f8 <malloc+0x22ac>
    4c9a:	7f6000ef          	jal	5490 <printf>
        return 1;
    4c9e:	4505                	li	a0,1
  return 0;
}
    4ca0:	70a6                	ld	ra,104(sp)
    4ca2:	7406                	ld	s0,96(sp)
    4ca4:	64e6                	ld	s1,88(sp)
    4ca6:	6946                	ld	s2,80(sp)
    4ca8:	69a6                	ld	s3,72(sp)
    4caa:	6a06                	ld	s4,64(sp)
    4cac:	7ae2                	ld	s5,56(sp)
    4cae:	7b42                	ld	s6,48(sp)
    4cb0:	7ba2                	ld	s7,40(sp)
    4cb2:	7c02                	ld	s8,32(sp)
    4cb4:	6ce2                	ld	s9,24(sp)
    4cb6:	6d42                	ld	s10,16(sp)
    4cb8:	6da2                	ld	s11,8(sp)
    4cba:	6165                	addi	sp,sp,112
    4cbc:	8082                	ret
  return 0;
    4cbe:	854e                	mv	a0,s3
    4cc0:	b7c5                	j	4ca0 <drivetests+0xd8>

0000000000004cc2 <main>:

int
main(int argc, char *argv[])
{
    4cc2:	1101                	addi	sp,sp,-32
    4cc4:	ec06                	sd	ra,24(sp)
    4cc6:	e822                	sd	s0,16(sp)
    4cc8:	e426                	sd	s1,8(sp)
    4cca:	e04a                	sd	s2,0(sp)
    4ccc:	1000                	addi	s0,sp,32
    4cce:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4cd0:	4789                	li	a5,2
    4cd2:	00f50e63          	beq	a0,a5,4cee <main+0x2c>
    continuous = 1;
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    continuous = 2;
  } else if (argc == 2 && argv[1][0] != '-') {
    justone = argv[1];
  } else if (argc > 1) {
    4cd6:	4785                	li	a5,1
    4cd8:	06a7c663          	blt	a5,a0,4d44 <main+0x82>
  char *justone = 0;
    4cdc:	4601                	li	a2,0
  int quick = 0;
    4cde:	4501                	li	a0,0
  int continuous = 0;
    4ce0:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4ce2:	ee7ff0ef          	jal	4bc8 <drivetests>
    4ce6:	cd35                	beqz	a0,4d62 <main+0xa0>
    exit(1);
    4ce8:	4505                	li	a0,1
    4cea:	340000ef          	jal	502a <exit>
    4cee:	892e                	mv	s2,a1
  if (argc == 2 && strcmp(argv[1], "-q") == 0) {
    4cf0:	00003597          	auipc	a1,0x3
    4cf4:	b2058593          	addi	a1,a1,-1248 # 7810 <malloc+0x22c4>
    4cf8:	00893503          	ld	a0,8(s2)
    4cfc:	0a8000ef          	jal	4da4 <strcmp>
    4d00:	85aa                	mv	a1,a0
    4d02:	e501                	bnez	a0,4d0a <main+0x48>
  char *justone = 0;
    4d04:	4601                	li	a2,0
    quick = 1;
    4d06:	4505                	li	a0,1
    4d08:	bfe9                	j	4ce2 <main+0x20>
  } else if (argc == 2 && strcmp(argv[1], "-c") == 0) {
    4d0a:	00003597          	auipc	a1,0x3
    4d0e:	b0e58593          	addi	a1,a1,-1266 # 7818 <malloc+0x22cc>
    4d12:	00893503          	ld	a0,8(s2)
    4d16:	08e000ef          	jal	4da4 <strcmp>
    4d1a:	cd15                	beqz	a0,4d56 <main+0x94>
  } else if (argc == 2 && strcmp(argv[1], "-C") == 0) {
    4d1c:	00003597          	auipc	a1,0x3
    4d20:	b4c58593          	addi	a1,a1,-1204 # 7868 <malloc+0x231c>
    4d24:	00893503          	ld	a0,8(s2)
    4d28:	07c000ef          	jal	4da4 <strcmp>
    4d2c:	c905                	beqz	a0,4d5c <main+0x9a>
  } else if (argc == 2 && argv[1][0] != '-') {
    4d2e:	00893603          	ld	a2,8(s2)
    4d32:	00064703          	lbu	a4,0(a2)
    4d36:	02d00793          	li	a5,45
    4d3a:	00f70563          	beq	a4,a5,4d44 <main+0x82>
  int quick = 0;
    4d3e:	4501                	li	a0,0
  int continuous = 0;
    4d40:	4581                	li	a1,0
    4d42:	b745                	j	4ce2 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4d44:	00003517          	auipc	a0,0x3
    4d48:	adc50513          	addi	a0,a0,-1316 # 7820 <malloc+0x22d4>
    4d4c:	744000ef          	jal	5490 <printf>
    exit(1);
    4d50:	4505                	li	a0,1
    4d52:	2d8000ef          	jal	502a <exit>
  char *justone = 0;
    4d56:	4601                	li	a2,0
    continuous = 1;
    4d58:	4585                	li	a1,1
    4d5a:	b761                	j	4ce2 <main+0x20>
    continuous = 2;
    4d5c:	85a6                	mv	a1,s1
  char *justone = 0;
    4d5e:	4601                	li	a2,0
    4d60:	b749                	j	4ce2 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4d62:	00003517          	auipc	a0,0x3
    4d66:	aee50513          	addi	a0,a0,-1298 # 7850 <malloc+0x2304>
    4d6a:	726000ef          	jal	5490 <printf>
  exit(0);
    4d6e:	4501                	li	a0,0
    4d70:	2ba000ef          	jal	502a <exit>

0000000000004d74 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4d74:	1141                	addi	sp,sp,-16
    4d76:	e406                	sd	ra,8(sp)
    4d78:	e022                	sd	s0,0(sp)
    4d7a:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4d7c:	f47ff0ef          	jal	4cc2 <main>
  exit(r);
    4d80:	2aa000ef          	jal	502a <exit>

0000000000004d84 <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
    4d84:	1141                	addi	sp,sp,-16
    4d86:	e406                	sd	ra,8(sp)
    4d88:	e022                	sd	s0,0(sp)
    4d8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
    4d8c:	87aa                	mv	a5,a0
    4d8e:	0585                	addi	a1,a1,1
    4d90:	0785                	addi	a5,a5,1
    4d92:	fff5c703          	lbu	a4,-1(a1)
    4d96:	fee78fa3          	sb	a4,-1(a5)
    4d9a:	fb75                	bnez	a4,4d8e <strcpy+0xa>
    ;
  return os;
}
    4d9c:	60a2                	ld	ra,8(sp)
    4d9e:	6402                	ld	s0,0(sp)
    4da0:	0141                	addi	sp,sp,16
    4da2:	8082                	ret

0000000000004da4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4da4:	1141                	addi	sp,sp,-16
    4da6:	e406                	sd	ra,8(sp)
    4da8:	e022                	sd	s0,0(sp)
    4daa:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
    4dac:	00054783          	lbu	a5,0(a0)
    4db0:	cb91                	beqz	a5,4dc4 <strcmp+0x20>
    4db2:	0005c703          	lbu	a4,0(a1)
    4db6:	00f71763          	bne	a4,a5,4dc4 <strcmp+0x20>
    p++, q++;
    4dba:	0505                	addi	a0,a0,1
    4dbc:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
    4dbe:	00054783          	lbu	a5,0(a0)
    4dc2:	fbe5                	bnez	a5,4db2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4dc4:	0005c503          	lbu	a0,0(a1)
}
    4dc8:	40a7853b          	subw	a0,a5,a0
    4dcc:	60a2                	ld	ra,8(sp)
    4dce:	6402                	ld	s0,0(sp)
    4dd0:	0141                	addi	sp,sp,16
    4dd2:	8082                	ret

0000000000004dd4 <strlen>:

uint
strlen(const char *s)
{
    4dd4:	1141                	addi	sp,sp,-16
    4dd6:	e406                	sd	ra,8(sp)
    4dd8:	e022                	sd	s0,0(sp)
    4dda:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
    4ddc:	00054783          	lbu	a5,0(a0)
    4de0:	cf91                	beqz	a5,4dfc <strlen+0x28>
    4de2:	00150793          	addi	a5,a0,1
    4de6:	86be                	mv	a3,a5
    4de8:	0785                	addi	a5,a5,1
    4dea:	fff7c703          	lbu	a4,-1(a5)
    4dee:	ff65                	bnez	a4,4de6 <strlen+0x12>
    4df0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4df4:	60a2                	ld	ra,8(sp)
    4df6:	6402                	ld	s0,0(sp)
    4df8:	0141                	addi	sp,sp,16
    4dfa:	8082                	ret
  for (n = 0; s[n]; n++)
    4dfc:	4501                	li	a0,0
    4dfe:	bfdd                	j	4df4 <strlen+0x20>

0000000000004e00 <memset>:

void *
memset(void *dst, int c, uint n)
{
    4e00:	1141                	addi	sp,sp,-16
    4e02:	e406                	sd	ra,8(sp)
    4e04:	e022                	sd	s0,0(sp)
    4e06:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
    4e08:	ca19                	beqz	a2,4e1e <memset+0x1e>
    4e0a:	87aa                	mv	a5,a0
    4e0c:	1602                	slli	a2,a2,0x20
    4e0e:	9201                	srli	a2,a2,0x20
    4e10:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4e14:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
    4e18:	0785                	addi	a5,a5,1
    4e1a:	fee79de3          	bne	a5,a4,4e14 <memset+0x14>
  }
  return dst;
}
    4e1e:	60a2                	ld	ra,8(sp)
    4e20:	6402                	ld	s0,0(sp)
    4e22:	0141                	addi	sp,sp,16
    4e24:	8082                	ret

0000000000004e26 <strchr>:

char *
strchr(const char *s, char c)
{
    4e26:	1141                	addi	sp,sp,-16
    4e28:	e406                	sd	ra,8(sp)
    4e2a:	e022                	sd	s0,0(sp)
    4e2c:	0800                	addi	s0,sp,16
  for (; *s; s++)
    4e2e:	00054783          	lbu	a5,0(a0)
    4e32:	c799                	beqz	a5,4e40 <strchr+0x1a>
    if (*s == c)
    4e34:	00f58763          	beq	a1,a5,4e42 <strchr+0x1c>
  for (; *s; s++)
    4e38:	0505                	addi	a0,a0,1
    4e3a:	00054783          	lbu	a5,0(a0)
    4e3e:	fbfd                	bnez	a5,4e34 <strchr+0xe>
      return (char *)s;
  return 0;
    4e40:	4501                	li	a0,0
}
    4e42:	60a2                	ld	ra,8(sp)
    4e44:	6402                	ld	s0,0(sp)
    4e46:	0141                	addi	sp,sp,16
    4e48:	8082                	ret

0000000000004e4a <gets>:

char *
gets(char *buf, int max)
{
    4e4a:	711d                	addi	sp,sp,-96
    4e4c:	ec86                	sd	ra,88(sp)
    4e4e:	e8a2                	sd	s0,80(sp)
    4e50:	e4a6                	sd	s1,72(sp)
    4e52:	e0ca                	sd	s2,64(sp)
    4e54:	fc4e                	sd	s3,56(sp)
    4e56:	f852                	sd	s4,48(sp)
    4e58:	f456                	sd	s5,40(sp)
    4e5a:	f05a                	sd	s6,32(sp)
    4e5c:	ec5e                	sd	s7,24(sp)
    4e5e:	e862                	sd	s8,16(sp)
    4e60:	1080                	addi	s0,sp,96
    4e62:	8baa                	mv	s7,a0
    4e64:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
    4e66:	892a                	mv	s2,a0
    4e68:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4e6a:	faf40b13          	addi	s6,s0,-81
    4e6e:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
    4e70:	8c26                	mv	s8,s1
    4e72:	0014899b          	addiw	s3,s1,1
    4e76:	84ce                	mv	s1,s3
    4e78:	0349d863          	bge	s3,s4,4ea8 <gets+0x5e>
    cc = read(0, &c, 1);
    4e7c:	8656                	mv	a2,s5
    4e7e:	85da                	mv	a1,s6
    4e80:	4501                	li	a0,0
    4e82:	1c0000ef          	jal	5042 <read>
    if (cc < 1)
    4e86:	02a05163          	blez	a0,4ea8 <gets+0x5e>
      break;
    buf[i++] = c;
    4e8a:	faf44783          	lbu	a5,-81(s0)
    4e8e:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
    4e92:	0905                	addi	s2,s2,1
    4e94:	ff678713          	addi	a4,a5,-10
    4e98:	00173713          	seqz	a4,a4
    4e9c:	17cd                	addi	a5,a5,-13
    4e9e:	0017b793          	seqz	a5,a5
    4ea2:	8fd9                	or	a5,a5,a4
    4ea4:	d7f1                	beqz	a5,4e70 <gets+0x26>
    buf[i++] = c;
    4ea6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4ea8:	9c5e                	add	s8,s8,s7
    4eaa:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4eae:	855e                	mv	a0,s7
    4eb0:	60e6                	ld	ra,88(sp)
    4eb2:	6446                	ld	s0,80(sp)
    4eb4:	64a6                	ld	s1,72(sp)
    4eb6:	6906                	ld	s2,64(sp)
    4eb8:	79e2                	ld	s3,56(sp)
    4eba:	7a42                	ld	s4,48(sp)
    4ebc:	7aa2                	ld	s5,40(sp)
    4ebe:	7b02                	ld	s6,32(sp)
    4ec0:	6be2                	ld	s7,24(sp)
    4ec2:	6c42                	ld	s8,16(sp)
    4ec4:	6125                	addi	sp,sp,96
    4ec6:	8082                	ret

0000000000004ec8 <stat>:

int
stat(const char *n, struct stat *st)
{
    4ec8:	1101                	addi	sp,sp,-32
    4eca:	ec06                	sd	ra,24(sp)
    4ecc:	e822                	sd	s0,16(sp)
    4ece:	e04a                	sd	s2,0(sp)
    4ed0:	1000                	addi	s0,sp,32
    4ed2:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4ed4:	4581                	li	a1,0
    4ed6:	194000ef          	jal	506a <open>
  if (fd < 0)
    4eda:	02054263          	bltz	a0,4efe <stat+0x36>
    4ede:	e426                	sd	s1,8(sp)
    4ee0:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4ee2:	85ca                	mv	a1,s2
    4ee4:	19e000ef          	jal	5082 <fstat>
    4ee8:	892a                	mv	s2,a0
  close(fd);
    4eea:	8526                	mv	a0,s1
    4eec:	166000ef          	jal	5052 <close>
  return r;
    4ef0:	64a2                	ld	s1,8(sp)
}
    4ef2:	854a                	mv	a0,s2
    4ef4:	60e2                	ld	ra,24(sp)
    4ef6:	6442                	ld	s0,16(sp)
    4ef8:	6902                	ld	s2,0(sp)
    4efa:	6105                	addi	sp,sp,32
    4efc:	8082                	ret
    return -1;
    4efe:	57fd                	li	a5,-1
    4f00:	893e                	mv	s2,a5
    4f02:	bfc5                	j	4ef2 <stat+0x2a>

0000000000004f04 <atoi>:

int
atoi(const char *s)
{
    4f04:	1141                	addi	sp,sp,-16
    4f06:	e406                	sd	ra,8(sp)
    4f08:	e022                	sd	s0,0(sp)
    4f0a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
    4f0c:	00054683          	lbu	a3,0(a0)
    4f10:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x31318>
    4f14:	0ff7f793          	zext.b	a5,a5
    4f18:	4625                	li	a2,9
    4f1a:	02f66963          	bltu	a2,a5,4f4c <atoi+0x48>
    4f1e:	872a                	mv	a4,a0
  n = 0;
    4f20:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
    4f22:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1349>
    4f24:	0025179b          	slliw	a5,a0,0x2
    4f28:	9fa9                	addw	a5,a5,a0
    4f2a:	0017979b          	slliw	a5,a5,0x1
    4f2e:	9fb5                	addw	a5,a5,a3
    4f30:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
    4f34:	00074683          	lbu	a3,0(a4)
    4f38:	fd06879b          	addiw	a5,a3,-48
    4f3c:	0ff7f793          	zext.b	a5,a5
    4f40:	fef671e3          	bgeu	a2,a5,4f22 <atoi+0x1e>
  return n;
}
    4f44:	60a2                	ld	ra,8(sp)
    4f46:	6402                	ld	s0,0(sp)
    4f48:	0141                	addi	sp,sp,16
    4f4a:	8082                	ret
  n = 0;
    4f4c:	4501                	li	a0,0
    4f4e:	bfdd                	j	4f44 <atoi+0x40>

0000000000004f50 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
    4f50:	1141                	addi	sp,sp,-16
    4f52:	e406                	sd	ra,8(sp)
    4f54:	e022                	sd	s0,0(sp)
    4f56:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4f58:	02b57563          	bgeu	a0,a1,4f82 <memmove+0x32>
    while (n-- > 0)
    4f5c:	00c05f63          	blez	a2,4f7a <memmove+0x2a>
    4f60:	1602                	slli	a2,a2,0x20
    4f62:	9201                	srli	a2,a2,0x20
    4f64:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4f68:	872a                	mv	a4,a0
      *dst++ = *src++;
    4f6a:	0585                	addi	a1,a1,1
    4f6c:	0705                	addi	a4,a4,1
    4f6e:	fff5c683          	lbu	a3,-1(a1)
    4f72:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
    4f76:	fee79ae3          	bne	a5,a4,4f6a <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4f7a:	60a2                	ld	ra,8(sp)
    4f7c:	6402                	ld	s0,0(sp)
    4f7e:	0141                	addi	sp,sp,16
    4f80:	8082                	ret
    while (n-- > 0)
    4f82:	fec05ce3          	blez	a2,4f7a <memmove+0x2a>
    dst += n;
    4f86:	00c50733          	add	a4,a0,a2
    src += n;
    4f8a:	95b2                	add	a1,a1,a2
    4f8c:	fff6079b          	addiw	a5,a2,-1
    4f90:	1782                	slli	a5,a5,0x20
    4f92:	9381                	srli	a5,a5,0x20
    4f94:	fff7c793          	not	a5,a5
    4f98:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4f9a:	15fd                	addi	a1,a1,-1
    4f9c:	177d                	addi	a4,a4,-1
    4f9e:	0005c683          	lbu	a3,0(a1)
    4fa2:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
    4fa6:	fef71ae3          	bne	a4,a5,4f9a <memmove+0x4a>
    4faa:	bfc1                	j	4f7a <memmove+0x2a>

0000000000004fac <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4fac:	1141                	addi	sp,sp,-16
    4fae:	e406                	sd	ra,8(sp)
    4fb0:	e022                	sd	s0,0(sp)
    4fb2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4fb4:	ce19                	beqz	a2,4fd2 <memcmp+0x26>
    4fb6:	1602                	slli	a2,a2,0x20
    4fb8:	9201                	srli	a2,a2,0x20
    4fba:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4fbe:	00054783          	lbu	a5,0(a0)
    4fc2:	0005c703          	lbu	a4,0(a1)
    4fc6:	00e79b63          	bne	a5,a4,4fdc <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
    4fca:	0505                	addi	a0,a0,1
    p2++;
    4fcc:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4fce:	fed518e3          	bne	a0,a3,4fbe <memcmp+0x12>
  }
  return 0;
    4fd2:	4501                	li	a0,0
}
    4fd4:	60a2                	ld	ra,8(sp)
    4fd6:	6402                	ld	s0,0(sp)
    4fd8:	0141                	addi	sp,sp,16
    4fda:	8082                	ret
      return *p1 - *p2;
    4fdc:	40e7853b          	subw	a0,a5,a4
    4fe0:	bfd5                	j	4fd4 <memcmp+0x28>

0000000000004fe2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4fe2:	1141                	addi	sp,sp,-16
    4fe4:	e406                	sd	ra,8(sp)
    4fe6:	e022                	sd	s0,0(sp)
    4fe8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4fea:	f67ff0ef          	jal	4f50 <memmove>
}
    4fee:	60a2                	ld	ra,8(sp)
    4ff0:	6402                	ld	s0,0(sp)
    4ff2:	0141                	addi	sp,sp,16
    4ff4:	8082                	ret

0000000000004ff6 <sbrk>:

char *
sbrk(int n)
{
    4ff6:	1141                	addi	sp,sp,-16
    4ff8:	e406                	sd	ra,8(sp)
    4ffa:	e022                	sd	s0,0(sp)
    4ffc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4ffe:	4585                	li	a1,1
    5000:	0b2000ef          	jal	50b2 <sys_sbrk>
}
    5004:	60a2                	ld	ra,8(sp)
    5006:	6402                	ld	s0,0(sp)
    5008:	0141                	addi	sp,sp,16
    500a:	8082                	ret

000000000000500c <sbrklazy>:

char *
sbrklazy(int n)
{
    500c:	1141                	addi	sp,sp,-16
    500e:	e406                	sd	ra,8(sp)
    5010:	e022                	sd	s0,0(sp)
    5012:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    5014:	4589                	li	a1,2
    5016:	09c000ef          	jal	50b2 <sys_sbrk>
}
    501a:	60a2                	ld	ra,8(sp)
    501c:	6402                	ld	s0,0(sp)
    501e:	0141                	addi	sp,sp,16
    5020:	8082                	ret

0000000000005022 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    5022:	4885                	li	a7,1
 ecall
    5024:	00000073          	ecall
 ret
    5028:	8082                	ret

000000000000502a <exit>:
.global exit
exit:
 li a7, SYS_exit
    502a:	4889                	li	a7,2
 ecall
    502c:	00000073          	ecall
 ret
    5030:	8082                	ret

0000000000005032 <wait>:
.global wait
wait:
 li a7, SYS_wait
    5032:	488d                	li	a7,3
 ecall
    5034:	00000073          	ecall
 ret
    5038:	8082                	ret

000000000000503a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    503a:	4891                	li	a7,4
 ecall
    503c:	00000073          	ecall
 ret
    5040:	8082                	ret

0000000000005042 <read>:
.global read
read:
 li a7, SYS_read
    5042:	4895                	li	a7,5
 ecall
    5044:	00000073          	ecall
 ret
    5048:	8082                	ret

000000000000504a <write>:
.global write
write:
 li a7, SYS_write
    504a:	48c1                	li	a7,16
 ecall
    504c:	00000073          	ecall
 ret
    5050:	8082                	ret

0000000000005052 <close>:
.global close
close:
 li a7, SYS_close
    5052:	48d5                	li	a7,21
 ecall
    5054:	00000073          	ecall
 ret
    5058:	8082                	ret

000000000000505a <kill>:
.global kill
kill:
 li a7, SYS_kill
    505a:	4899                	li	a7,6
 ecall
    505c:	00000073          	ecall
 ret
    5060:	8082                	ret

0000000000005062 <exec>:
.global exec
exec:
 li a7, SYS_exec
    5062:	489d                	li	a7,7
 ecall
    5064:	00000073          	ecall
 ret
    5068:	8082                	ret

000000000000506a <open>:
.global open
open:
 li a7, SYS_open
    506a:	48bd                	li	a7,15
 ecall
    506c:	00000073          	ecall
 ret
    5070:	8082                	ret

0000000000005072 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    5072:	48c5                	li	a7,17
 ecall
    5074:	00000073          	ecall
 ret
    5078:	8082                	ret

000000000000507a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    507a:	48c9                	li	a7,18
 ecall
    507c:	00000073          	ecall
 ret
    5080:	8082                	ret

0000000000005082 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    5082:	48a1                	li	a7,8
 ecall
    5084:	00000073          	ecall
 ret
    5088:	8082                	ret

000000000000508a <link>:
.global link
link:
 li a7, SYS_link
    508a:	48cd                	li	a7,19
 ecall
    508c:	00000073          	ecall
 ret
    5090:	8082                	ret

0000000000005092 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    5092:	48d1                	li	a7,20
 ecall
    5094:	00000073          	ecall
 ret
    5098:	8082                	ret

000000000000509a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    509a:	48a5                	li	a7,9
 ecall
    509c:	00000073          	ecall
 ret
    50a0:	8082                	ret

00000000000050a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
    50a2:	48a9                	li	a7,10
 ecall
    50a4:	00000073          	ecall
 ret
    50a8:	8082                	ret

00000000000050aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    50aa:	48ad                	li	a7,11
 ecall
    50ac:	00000073          	ecall
 ret
    50b0:	8082                	ret

00000000000050b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    50b2:	48b1                	li	a7,12
 ecall
    50b4:	00000073          	ecall
 ret
    50b8:	8082                	ret

00000000000050ba <pause>:
.global pause
pause:
 li a7, SYS_pause
    50ba:	48b5                	li	a7,13
 ecall
    50bc:	00000073          	ecall
 ret
    50c0:	8082                	ret

00000000000050c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    50c2:	48b9                	li	a7,14
 ecall
    50c4:	00000073          	ecall
 ret
    50c8:	8082                	ret

00000000000050ca <sync>:
.global sync
sync:
 li a7, SYS_sync
    50ca:	48d9                	li	a7,22
 ecall
    50cc:	00000073          	ecall
 ret
    50d0:	8082                	ret

00000000000050d2 <trace>:
.global trace
trace:
 li a7, SYS_trace
    50d2:	48dd                	li	a7,23
 ecall
    50d4:	00000073          	ecall
 ret
    50d8:	8082                	ret

00000000000050da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    50da:	1101                	addi	sp,sp,-32
    50dc:	ec06                	sd	ra,24(sp)
    50de:	e822                	sd	s0,16(sp)
    50e0:	1000                	addi	s0,sp,32
    50e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    50e6:	4605                	li	a2,1
    50e8:	fef40593          	addi	a1,s0,-17
    50ec:	f5fff0ef          	jal	504a <write>
}
    50f0:	60e2                	ld	ra,24(sp)
    50f2:	6442                	ld	s0,16(sp)
    50f4:	6105                	addi	sp,sp,32
    50f6:	8082                	ret

00000000000050f8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    50f8:	715d                	addi	sp,sp,-80
    50fa:	e486                	sd	ra,72(sp)
    50fc:	e0a2                	sd	s0,64(sp)
    50fe:	f84a                	sd	s2,48(sp)
    5100:	f44e                	sd	s3,40(sp)
    5102:	0880                	addi	s0,sp,80
    5104:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
    5106:	00d036b3          	snez	a3,a3
    510a:	03f5d793          	srli	a5,a1,0x3f
    510e:	8efd                	and	a3,a3,a5
  neg = 0;
    5110:	4301                	li	t1,0
  if (sgn && xx < 0) {
    5112:	c681                	beqz	a3,511a <printint+0x22>
    neg = 1;
    x = -xx;
    5114:	40b005b3          	neg	a1,a1
    neg = 1;
    5118:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    511a:	fb840993          	addi	s3,s0,-72
  neg = 0;
    511e:	86ce                	mv	a3,s3
  i = 0;
    5120:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    5122:	00003817          	auipc	a6,0x3
    5126:	b7680813          	addi	a6,a6,-1162 # 7c98 <digits>
    512a:	88ba                	mv	a7,a4
    512c:	0017051b          	addiw	a0,a4,1
    5130:	872a                	mv	a4,a0
    5132:	02c5f7b3          	remu	a5,a1,a2
    5136:	97c2                	add	a5,a5,a6
    5138:	0007c783          	lbu	a5,0(a5)
    513c:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
    5140:	87ae                	mv	a5,a1
    5142:	02c5d5b3          	divu	a1,a1,a2
    5146:	0685                	addi	a3,a3,1
    5148:	fec7f1e3          	bgeu	a5,a2,512a <printint+0x32>
  if (neg)
    514c:	00030b63          	beqz	t1,5162 <printint+0x6a>
    buf[i++] = '-';
    5150:	fd040793          	addi	a5,s0,-48
    5154:	953e                	add	a0,a0,a5
    5156:	02d00793          	li	a5,45
    515a:	fef50423          	sb	a5,-24(a0)
    515e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
    5162:	02e05563          	blez	a4,518c <printint+0x94>
    5166:	fc26                	sd	s1,56(sp)
    5168:	377d                	addiw	a4,a4,-1
    516a:	00e984b3          	add	s1,s3,a4
    516e:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x10b>
    5170:	99ba                	add	s3,s3,a4
    5172:	1702                	slli	a4,a4,0x20
    5174:	9301                	srli	a4,a4,0x20
    5176:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    517a:	0004c583          	lbu	a1,0(s1)
    517e:	854a                	mv	a0,s2
    5180:	f5bff0ef          	jal	50da <putc>
  while (--i >= 0)
    5184:	14fd                	addi	s1,s1,-1
    5186:	ff349ae3          	bne	s1,s3,517a <printint+0x82>
    518a:	74e2                	ld	s1,56(sp)
}
    518c:	60a6                	ld	ra,72(sp)
    518e:	6406                	ld	s0,64(sp)
    5190:	7942                	ld	s2,48(sp)
    5192:	79a2                	ld	s3,40(sp)
    5194:	6161                	addi	sp,sp,80
    5196:	8082                	ret

0000000000005198 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5198:	711d                	addi	sp,sp,-96
    519a:	ec86                	sd	ra,88(sp)
    519c:	e8a2                	sd	s0,80(sp)
    519e:	e4a6                	sd	s1,72(sp)
    51a0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
    51a2:	0005c483          	lbu	s1,0(a1)
    51a6:	2a048063          	beqz	s1,5446 <vprintf+0x2ae>
    51aa:	e0ca                	sd	s2,64(sp)
    51ac:	fc4e                	sd	s3,56(sp)
    51ae:	f852                	sd	s4,48(sp)
    51b0:	f456                	sd	s5,40(sp)
    51b2:	f05a                	sd	s6,32(sp)
    51b4:	ec5e                	sd	s7,24(sp)
    51b6:	e862                	sd	s8,16(sp)
    51b8:	8b2a                	mv	s6,a0
    51ba:	8a2e                	mv	s4,a1
    51bc:	8bb2                	mv	s7,a2
  state = 0;
    51be:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
    51c0:	4901                	li	s2,0
    51c2:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
    51c4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
    51c8:	06400c13          	li	s8,100
    51cc:	a00d                	j	51ee <vprintf+0x56>
        putc(fd, c0);
    51ce:	85a6                	mv	a1,s1
    51d0:	855a                	mv	a0,s6
    51d2:	f09ff0ef          	jal	50da <putc>
    51d6:	a019                	j	51dc <vprintf+0x44>
    } else if (state == '%') {
    51d8:	03598363          	beq	s3,s5,51fe <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
    51dc:	0019079b          	addiw	a5,s2,1
    51e0:	893e                	mv	s2,a5
    51e2:	873e                	mv	a4,a5
    51e4:	97d2                	add	a5,a5,s4
    51e6:	0007c483          	lbu	s1,0(a5)
    51ea:	24048763          	beqz	s1,5438 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
    51ee:	0004879b          	sext.w	a5,s1
    if (state == 0) {
    51f2:	fe0993e3          	bnez	s3,51d8 <vprintf+0x40>
      if (c0 == '%') {
    51f6:	fd579ce3          	bne	a5,s5,51ce <vprintf+0x36>
        state = '%';
    51fa:	89be                	mv	s3,a5
    51fc:	b7c5                	j	51dc <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
    51fe:	00ea06b3          	add	a3,s4,a4
    5202:	0016c603          	lbu	a2,1(a3)
      if (c1)
    5206:	24060563          	beqz	a2,5450 <vprintf+0x2b8>
      if (c0 == 'd') {
    520a:	0b878763          	beq	a5,s8,52b8 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
    520e:	f9478693          	addi	a3,a5,-108
    5212:	0016b693          	seqz	a3,a3
    5216:	f9c60593          	addi	a1,a2,-100
    521a:	0015b593          	seqz	a1,a1
    521e:	8df5                	and	a1,a1,a3
    5220:	e9c5                	bnez	a1,52d0 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
    5222:	9752                	add	a4,a4,s4
    5224:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5228:	f9460713          	addi	a4,a2,-108
    522c:	00173713          	seqz	a4,a4
    5230:	8f75                	and	a4,a4,a3
    5232:	f9c50593          	addi	a1,a0,-100
    5236:	0015b593          	seqz	a1,a1
    523a:	8df9                	and	a1,a1,a4
    523c:	e5dd                	bnez	a1,52ea <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
    523e:	07500593          	li	a1,117
    5242:	0cb78163          	beq	a5,a1,5304 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
    5246:	f8b60593          	addi	a1,a2,-117
    524a:	0015b593          	seqz	a1,a1
    524e:	8df5                	and	a1,a1,a3
    5250:	e5f1                	bnez	a1,531c <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
    5252:	f8b50593          	addi	a1,a0,-117
    5256:	0015b593          	seqz	a1,a1
    525a:	8df9                	and	a1,a1,a4
    525c:	ede9                	bnez	a1,5336 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
    525e:	07800593          	li	a1,120
    5262:	0eb78763          	beq	a5,a1,5350 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
    5266:	f8860613          	addi	a2,a2,-120
    526a:	00163613          	seqz	a2,a2
    526e:	8ef1                	and	a3,a3,a2
    5270:	0e069c63          	bnez	a3,5368 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
    5274:	f8850513          	addi	a0,a0,-120
    5278:	00153513          	seqz	a0,a0
    527c:	8f69                	and	a4,a4,a0
    527e:	10071263          	bnez	a4,5382 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
    5282:	07000713          	li	a4,112
    5286:	10e78a63          	beq	a5,a4,539a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
    528a:	06300713          	li	a4,99
    528e:	14e78a63          	beq	a5,a4,53e2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
    5292:	07300713          	li	a4,115
    5296:	16e78063          	beq	a5,a4,53f6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
    529a:	02500713          	li	a4,37
    529e:	18e78863          	beq	a5,a4,542e <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    52a2:	02500593          	li	a1,37
    52a6:	855a                	mv	a0,s6
    52a8:	e33ff0ef          	jal	50da <putc>
        putc(fd, c0);
    52ac:	85a6                	mv	a1,s1
    52ae:	855a                	mv	a0,s6
    52b0:	e2bff0ef          	jal	50da <putc>
      }

      state = 0;
    52b4:	4981                	li	s3,0
    52b6:	b71d                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    52b8:	008b8493          	addi	s1,s7,8
    52bc:	4685                	li	a3,1
    52be:	4629                	li	a2,10
    52c0:	000ba583          	lw	a1,0(s7)
    52c4:	855a                	mv	a0,s6
    52c6:	e33ff0ef          	jal	50f8 <printint>
    52ca:	8ba6                	mv	s7,s1
      state = 0;
    52cc:	4981                	li	s3,0
    52ce:	b739                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    52d0:	008b8493          	addi	s1,s7,8
    52d4:	4685                	li	a3,1
    52d6:	4629                	li	a2,10
    52d8:	000bb583          	ld	a1,0(s7)
    52dc:	855a                	mv	a0,s6
    52de:	e1bff0ef          	jal	50f8 <printint>
        i += 1;
    52e2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    52e4:	8ba6                	mv	s7,s1
      state = 0;
    52e6:	4981                	li	s3,0
    52e8:	bdd5                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
    52ea:	008b8493          	addi	s1,s7,8
    52ee:	4685                	li	a3,1
    52f0:	4629                	li	a2,10
    52f2:	000bb583          	ld	a1,0(s7)
    52f6:	855a                	mv	a0,s6
    52f8:	e01ff0ef          	jal	50f8 <printint>
        i += 2;
    52fc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    52fe:	8ba6                	mv	s7,s1
      state = 0;
    5300:	4981                	li	s3,0
        i += 2;
    5302:	bde9                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    5304:	008b8493          	addi	s1,s7,8
    5308:	4681                	li	a3,0
    530a:	4629                	li	a2,10
    530c:	000be583          	lwu	a1,0(s7)
    5310:	855a                	mv	a0,s6
    5312:	de7ff0ef          	jal	50f8 <printint>
    5316:	8ba6                	mv	s7,s1
      state = 0;
    5318:	4981                	li	s3,0
    531a:	b5c9                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    531c:	008b8493          	addi	s1,s7,8
    5320:	4681                	li	a3,0
    5322:	4629                	li	a2,10
    5324:	000bb583          	ld	a1,0(s7)
    5328:	855a                	mv	a0,s6
    532a:	dcfff0ef          	jal	50f8 <printint>
        i += 1;
    532e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    5330:	8ba6                	mv	s7,s1
      state = 0;
    5332:	4981                	li	s3,0
    5334:	b565                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5336:	008b8493          	addi	s1,s7,8
    533a:	4681                	li	a3,0
    533c:	4629                	li	a2,10
    533e:	000bb583          	ld	a1,0(s7)
    5342:	855a                	mv	a0,s6
    5344:	db5ff0ef          	jal	50f8 <printint>
        i += 2;
    5348:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    534a:	8ba6                	mv	s7,s1
      state = 0;
    534c:	4981                	li	s3,0
        i += 2;
    534e:	b579                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    5350:	008b8493          	addi	s1,s7,8
    5354:	4681                	li	a3,0
    5356:	4641                	li	a2,16
    5358:	000be583          	lwu	a1,0(s7)
    535c:	855a                	mv	a0,s6
    535e:	d9bff0ef          	jal	50f8 <printint>
    5362:	8ba6                	mv	s7,s1
      state = 0;
    5364:	4981                	li	s3,0
    5366:	bd9d                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5368:	008b8493          	addi	s1,s7,8
    536c:	4681                	li	a3,0
    536e:	4641                	li	a2,16
    5370:	000bb583          	ld	a1,0(s7)
    5374:	855a                	mv	a0,s6
    5376:	d83ff0ef          	jal	50f8 <printint>
        i += 1;
    537a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    537c:	8ba6                	mv	s7,s1
      state = 0;
    537e:	4981                	li	s3,0
    5380:	bdb1                	j	51dc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    5382:	008b8493          	addi	s1,s7,8
    5386:	4641                	li	a2,16
    5388:	000bb583          	ld	a1,0(s7)
    538c:	855a                	mv	a0,s6
    538e:	d6bff0ef          	jal	50f8 <printint>
        i += 2;
    5392:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    5394:	8ba6                	mv	s7,s1
      state = 0;
    5396:	4981                	li	s3,0
        i += 2;
    5398:	b591                	j	51dc <vprintf+0x44>
    539a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    539c:	008b8793          	addi	a5,s7,8
    53a0:	8cbe                	mv	s9,a5
    53a2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    53a6:	03000593          	li	a1,48
    53aa:	855a                	mv	a0,s6
    53ac:	d2fff0ef          	jal	50da <putc>
  putc(fd, 'x');
    53b0:	07800593          	li	a1,120
    53b4:	855a                	mv	a0,s6
    53b6:	d25ff0ef          	jal	50da <putc>
    53ba:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    53bc:	00003b97          	auipc	s7,0x3
    53c0:	8dcb8b93          	addi	s7,s7,-1828 # 7c98 <digits>
    53c4:	03c9d793          	srli	a5,s3,0x3c
    53c8:	97de                	add	a5,a5,s7
    53ca:	0007c583          	lbu	a1,0(a5)
    53ce:	855a                	mv	a0,s6
    53d0:	d0bff0ef          	jal	50da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    53d4:	0992                	slli	s3,s3,0x4
    53d6:	34fd                	addiw	s1,s1,-1
    53d8:	f4f5                	bnez	s1,53c4 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
    53da:	8be6                	mv	s7,s9
      state = 0;
    53dc:	4981                	li	s3,0
    53de:	6ca2                	ld	s9,8(sp)
    53e0:	bbf5                	j	51dc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    53e2:	008b8493          	addi	s1,s7,8
    53e6:	000bc583          	lbu	a1,0(s7)
    53ea:	855a                	mv	a0,s6
    53ec:	cefff0ef          	jal	50da <putc>
    53f0:	8ba6                	mv	s7,s1
      state = 0;
    53f2:	4981                	li	s3,0
    53f4:	b3e5                	j	51dc <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
    53f6:	008b8993          	addi	s3,s7,8
    53fa:	000bb483          	ld	s1,0(s7)
    53fe:	cc91                	beqz	s1,541a <vprintf+0x282>
        for (; *s; s++)
    5400:	0004c583          	lbu	a1,0(s1)
    5404:	c195                	beqz	a1,5428 <vprintf+0x290>
          putc(fd, *s);
    5406:	855a                	mv	a0,s6
    5408:	cd3ff0ef          	jal	50da <putc>
        for (; *s; s++)
    540c:	0485                	addi	s1,s1,1
    540e:	0004c583          	lbu	a1,0(s1)
    5412:	f9f5                	bnez	a1,5406 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5414:	8bce                	mv	s7,s3
      state = 0;
    5416:	4981                	li	s3,0
    5418:	b3d1                	j	51dc <vprintf+0x44>
          s = "(null)";
    541a:	00002497          	auipc	s1,0x2
    541e:	7ce48493          	addi	s1,s1,1998 # 7be8 <malloc+0x269c>
        for (; *s; s++)
    5422:	02800593          	li	a1,40
    5426:	b7c5                	j	5406 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
    5428:	8bce                	mv	s7,s3
      state = 0;
    542a:	4981                	li	s3,0
    542c:	bb45                	j	51dc <vprintf+0x44>
        putc(fd, '%');
    542e:	85be                	mv	a1,a5
    5430:	855a                	mv	a0,s6
    5432:	ca9ff0ef          	jal	50da <putc>
    5436:	bdbd                	j	52b4 <vprintf+0x11c>
    5438:	6906                	ld	s2,64(sp)
    543a:	79e2                	ld	s3,56(sp)
    543c:	7a42                	ld	s4,48(sp)
    543e:	7aa2                	ld	s5,40(sp)
    5440:	7b02                	ld	s6,32(sp)
    5442:	6be2                	ld	s7,24(sp)
    5444:	6c42                	ld	s8,16(sp)
    }
  }
}
    5446:	60e6                	ld	ra,88(sp)
    5448:	6446                	ld	s0,80(sp)
    544a:	64a6                	ld	s1,72(sp)
    544c:	6125                	addi	sp,sp,96
    544e:	8082                	ret
      if (c0 == 'd') {
    5450:	06400713          	li	a4,100
    5454:	e6e782e3          	beq	a5,a4,52b8 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
    5458:	f9478693          	addi	a3,a5,-108
    545c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    5460:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
    5462:	4701                	li	a4,0
    5464:	bbe9                	j	523e <vprintf+0xa6>

0000000000005466 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5466:	715d                	addi	sp,sp,-80
    5468:	ec06                	sd	ra,24(sp)
    546a:	e822                	sd	s0,16(sp)
    546c:	1000                	addi	s0,sp,32
    546e:	e010                	sd	a2,0(s0)
    5470:	e414                	sd	a3,8(s0)
    5472:	e818                	sd	a4,16(s0)
    5474:	ec1c                	sd	a5,24(s0)
    5476:	03043023          	sd	a6,32(s0)
    547a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    547e:	8622                	mv	a2,s0
    5480:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    5484:	d15ff0ef          	jal	5198 <vprintf>
}
    5488:	60e2                	ld	ra,24(sp)
    548a:	6442                	ld	s0,16(sp)
    548c:	6161                	addi	sp,sp,80
    548e:	8082                	ret

0000000000005490 <printf>:

void
printf(const char *fmt, ...)
{
    5490:	711d                	addi	sp,sp,-96
    5492:	ec06                	sd	ra,24(sp)
    5494:	e822                	sd	s0,16(sp)
    5496:	1000                	addi	s0,sp,32
    5498:	e40c                	sd	a1,8(s0)
    549a:	e810                	sd	a2,16(s0)
    549c:	ec14                	sd	a3,24(s0)
    549e:	f018                	sd	a4,32(s0)
    54a0:	f41c                	sd	a5,40(s0)
    54a2:	03043823          	sd	a6,48(s0)
    54a6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    54aa:	00840613          	addi	a2,s0,8
    54ae:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    54b2:	85aa                	mv	a1,a0
    54b4:	4505                	li	a0,1
    54b6:	ce3ff0ef          	jal	5198 <vprintf>
}
    54ba:	60e2                	ld	ra,24(sp)
    54bc:	6442                	ld	s0,16(sp)
    54be:	6125                	addi	sp,sp,96
    54c0:	8082                	ret

00000000000054c2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    54c2:	1141                	addi	sp,sp,-16
    54c4:	e406                	sd	ra,8(sp)
    54c6:	e022                	sd	s0,0(sp)
    54c8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
    54ca:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    54ce:	00003797          	auipc	a5,0x3
    54d2:	fc27b783          	ld	a5,-62(a5) # 8490 <freep>
    54d6:	a095                	j	553a <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
    54d8:	ff852583          	lw	a1,-8(a0)
    54dc:	6390                	ld	a2,0(a5)
    54de:	02059813          	slli	a6,a1,0x20
    54e2:	01c85693          	srli	a3,a6,0x1c
    54e6:	96ba                	add	a3,a3,a4
    54e8:	02d60563          	beq	a2,a3,5512 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    54ec:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
    54f0:	4790                	lw	a2,8(a5)
    54f2:	02061593          	slli	a1,a2,0x20
    54f6:	01c5d693          	srli	a3,a1,0x1c
    54fa:	96be                	add	a3,a3,a5
    54fc:	02d70263          	beq	a4,a3,5520 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    5500:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    5502:	00003717          	auipc	a4,0x3
    5506:	f8f73723          	sd	a5,-114(a4) # 8490 <freep>
}
    550a:	60a2                	ld	ra,8(sp)
    550c:	6402                	ld	s0,0(sp)
    550e:	0141                	addi	sp,sp,16
    5510:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    5512:	4614                	lw	a3,8(a2)
    5514:	9ead                	addw	a3,a3,a1
    5516:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    551a:	6394                	ld	a3,0(a5)
    551c:	6290                	ld	a2,0(a3)
    551e:	b7f9                	j	54ec <free+0x2a>
    p->s.size += bp->s.size;
    5520:	ff852703          	lw	a4,-8(a0)
    5524:	9f31                	addw	a4,a4,a2
    5526:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    5528:	ff053703          	ld	a4,-16(a0)
    552c:	bfd1                	j	5500 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    552e:	6394                	ld	a3,0(a5)
    5530:	00d7e463          	bltu	a5,a3,5538 <free+0x76>
    5534:	fad762e3          	bltu	a4,a3,54d8 <free+0x16>
    5538:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    553a:	fee7fae3          	bgeu	a5,a4,552e <free+0x6c>
    553e:	6394                	ld	a3,0(a5)
    5540:	f8d76ce3          	bltu	a4,a3,54d8 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5544:	f8d7fae3          	bgeu	a5,a3,54d8 <free+0x16>
    5548:	87b6                	mv	a5,a3
    554a:	bfc5                	j	553a <free+0x78>

000000000000554c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
    554c:	7139                	addi	sp,sp,-64
    554e:	fc06                	sd	ra,56(sp)
    5550:	f822                	sd	s0,48(sp)
    5552:	f04a                	sd	s2,32(sp)
    5554:	ec4e                	sd	s3,24(sp)
    5556:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
    5558:	02051993          	slli	s3,a0,0x20
    555c:	0209d993          	srli	s3,s3,0x20
    5560:	09bd                	addi	s3,s3,15
    5562:	0049d993          	srli	s3,s3,0x4
    5566:	2985                	addiw	s3,s3,1
    5568:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
    556a:	00003517          	auipc	a0,0x3
    556e:	f2653503          	ld	a0,-218(a0) # 8490 <freep>
    5572:	c905                	beqz	a0,55a2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    5574:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    5576:	4798                	lw	a4,8(a5)
    5578:	09377663          	bgeu	a4,s3,5604 <malloc+0xb8>
    557c:	f426                	sd	s1,40(sp)
    557e:	e852                	sd	s4,16(sp)
    5580:	e456                	sd	s5,8(sp)
    5582:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
    5584:	8a4e                	mv	s4,s3
    5586:	6705                	lui	a4,0x1
    5588:	00e9f363          	bgeu	s3,a4,558e <malloc+0x42>
    558c:	6a05                	lui	s4,0x1
    558e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5592:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
    5596:	00003497          	auipc	s1,0x3
    559a:	efa48493          	addi	s1,s1,-262 # 8490 <freep>
  if (p == SBRK_ERROR)
    559e:	5afd                	li	s5,-1
    55a0:	a83d                	j	55de <malloc+0x92>
    55a2:	f426                	sd	s1,40(sp)
    55a4:	e852                	sd	s4,16(sp)
    55a6:	e456                	sd	s5,8(sp)
    55a8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    55aa:	00009797          	auipc	a5,0x9
    55ae:	70e78793          	addi	a5,a5,1806 # ecb8 <base>
    55b2:	00003717          	auipc	a4,0x3
    55b6:	ecf73f23          	sd	a5,-290(a4) # 8490 <freep>
    55ba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    55bc:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
    55c0:	b7d1                	j	5584 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    55c2:	6398                	ld	a4,0(a5)
    55c4:	e118                	sd	a4,0(a0)
    55c6:	a899                	j	561c <malloc+0xd0>
  hp->s.size = nu;
    55c8:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
    55cc:	0541                	addi	a0,a0,16
    55ce:	ef5ff0ef          	jal	54c2 <free>
  return freep;
    55d2:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
    55d4:	c125                	beqz	a0,5634 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
    55d6:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
    55d8:	4798                	lw	a4,8(a5)
    55da:	03277163          	bgeu	a4,s2,55fc <malloc+0xb0>
    if (p == freep)
    55de:	6098                	ld	a4,0(s1)
    55e0:	853e                	mv	a0,a5
    55e2:	fef71ae3          	bne	a4,a5,55d6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    55e6:	8552                	mv	a0,s4
    55e8:	a0fff0ef          	jal	4ff6 <sbrk>
  if (p == SBRK_ERROR)
    55ec:	fd551ee3          	bne	a0,s5,55c8 <malloc+0x7c>
        return 0;
    55f0:	4501                	li	a0,0
    55f2:	74a2                	ld	s1,40(sp)
    55f4:	6a42                	ld	s4,16(sp)
    55f6:	6aa2                	ld	s5,8(sp)
    55f8:	6b02                	ld	s6,0(sp)
    55fa:	a03d                	j	5628 <malloc+0xdc>
    55fc:	74a2                	ld	s1,40(sp)
    55fe:	6a42                	ld	s4,16(sp)
    5600:	6aa2                	ld	s5,8(sp)
    5602:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
    5604:	fae90fe3          	beq	s2,a4,55c2 <malloc+0x76>
        p->s.size -= nunits;
    5608:	4137073b          	subw	a4,a4,s3
    560c:	c798                	sw	a4,8(a5)
        p += p->s.size;
    560e:	02071693          	slli	a3,a4,0x20
    5612:	01c6d713          	srli	a4,a3,0x1c
    5616:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    5618:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    561c:	00003717          	auipc	a4,0x3
    5620:	e6a73a23          	sd	a0,-396(a4) # 8490 <freep>
      return (void *)(p + 1);
    5624:	01078513          	addi	a0,a5,16
  }
}
    5628:	70e2                	ld	ra,56(sp)
    562a:	7442                	ld	s0,48(sp)
    562c:	7902                	ld	s2,32(sp)
    562e:	69e2                	ld	s3,24(sp)
    5630:	6121                	addi	sp,sp,64
    5632:	8082                	ret
    5634:	74a2                	ld	s1,40(sp)
    5636:	6a42                	ld	s4,16(sp)
    5638:	6aa2                	ld	s5,8(sp)
    563a:	6b02                	ld	s6,0(sp)
    563c:	b7f5                	j	5628 <malloc+0xdc>
