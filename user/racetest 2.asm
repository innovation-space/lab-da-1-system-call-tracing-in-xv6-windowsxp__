
user/_racetest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <run_experiment>:
#include "kernel/stat.h"
#include "user/user.h"

static void
run_experiment(int num_children, int iters, int use_lock)
{
   0:	715d                	addi	sp,sp,-80
   2:	e486                	sd	ra,72(sp)
   4:	e0a2                	sd	s0,64(sp)
   6:	fc26                	sd	s1,56(sp)
   8:	f84a                	sd	s2,48(sp)
   a:	f44e                	sd	s3,40(sp)
   c:	f052                	sd	s4,32(sp)
   e:	ec56                	sd	s5,24(sp)
  10:	e85a                	sd	s6,16(sp)
  12:	e45e                	sd	s7,8(sp)
  14:	0880                	addi	s0,sp,80
  16:	892a                	mv	s2,a0
  18:	8aae                	mv	s5,a1
  1a:	8a32                	mv	s4,a2
  int expected = num_children * iters;
  1c:	02b509bb          	mulw	s3,a0,a1
  20:	8b4e                	mv	s6,s3

  printf("\n============================================================\n");
  22:	00001517          	auipc	a0,0x1
  26:	bde50513          	addi	a0,a0,-1058 # c00 <malloc+0xf4>
  2a:	227000ef          	jal	a50 <printf>
  if (use_lock) {
  2e:	060a0063          	beqz	s4,8e <run_experiment+0x8e>
    printf("[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)\n");
  32:	00001517          	auipc	a0,0x1
  36:	c1650513          	addi	a0,a0,-1002 # c48 <malloc+0x13c>
  3a:	217000ef          	jal	a50 <printf>
    printf("Protection: Mutual Exclusion ENABLED\n");
  3e:	00001517          	auipc	a0,0x1
  42:	c4a50513          	addi	a0,a0,-950 # c88 <malloc+0x17c>
  46:	20b000ef          	jal	a50 <printf>
  } else {
    printf("[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n");
    printf("Protection: NONE (Vulnerable to SMP Race Window)\n");
  }
  printf("Configuration: %d child processes x %d iterations\n", num_children, iters);
  4a:	8656                	mv	a2,s5
  4c:	85ca                	mv	a1,s2
  4e:	00001517          	auipc	a0,0x1
  52:	ce250513          	addi	a0,a0,-798 # d30 <malloc+0x224>
  56:	1fb000ef          	jal	a50 <printf>
  printf("Expected Counter Result: %d\n", expected);
  5a:	85ce                	mv	a1,s3
  5c:	00001517          	auipc	a0,0x1
  60:	d0c50513          	addi	a0,a0,-756 # d68 <malloc+0x25c>
  64:	1ed000ef          	jal	a50 <printf>
  printf("------------------------------------------------------------\n");
  68:	00001517          	auipc	a0,0x1
  6c:	d2050513          	addi	a0,a0,-736 # d88 <malloc+0x27c>
  70:	1e1000ef          	jal	a50 <printf>

  race_reset();
  74:	61e000ef          	jal	692 <race_reset>

  printf("Spawning %d concurrent processes across CPUs...\n", num_children);
  78:	85ca                	mv	a1,s2
  7a:	00001517          	auipc	a0,0x1
  7e:	d4e50513          	addi	a0,a0,-690 # dc8 <malloc+0x2bc>
  82:	1cf000ef          	jal	a50 <printf>
  for (int i = 0; i < num_children; i++) {
  86:	05205363          	blez	s2,cc <run_experiment+0xcc>
  8a:	4481                	li	s1,0
  8c:	a839                	j	aa <run_experiment+0xaa>
    printf("[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n");
  8e:	00001517          	auipc	a0,0x1
  92:	c2250513          	addi	a0,a0,-990 # cb0 <malloc+0x1a4>
  96:	1bb000ef          	jal	a50 <printf>
    printf("Protection: NONE (Vulnerable to SMP Race Window)\n");
  9a:	00001517          	auipc	a0,0x1
  9e:	c5e50513          	addi	a0,a0,-930 # cf8 <malloc+0x1ec>
  a2:	1af000ef          	jal	a50 <printf>
  a6:	b755                	j	4a <run_experiment+0x4a>
  for (int i = 0; i < num_children; i++) {
  a8:	84be                	mv	s1,a5
    int pid = fork();
  aa:	520000ef          	jal	5ca <fork>
    if (pid < 0) {
  ae:	0a054863          	bltz	a0,15e <run_experiment+0x15e>
      printf("racetest: fork failed on child %d\n", i);
      exit(1);
    }
    if (pid == 0) {
  b2:	c161                	beqz	a0,172 <run_experiment+0x172>
  for (int i = 0; i < num_children; i++) {
  b4:	0014879b          	addiw	a5,s1,1
  b8:	fef918e3          	bne	s2,a5,a8 <run_experiment+0xa8>
      exit(0);
    }
  }

  // Parent process: await completion of all concurrent children
  for (int i = 0; i < num_children; i++) {
  bc:	4901                	li	s2,0
  be:	84be                	mv	s1,a5
    wait(0);
  c0:	4501                	li	a0,0
  c2:	518000ef          	jal	5da <wait>
  for (int i = 0; i < num_children; i++) {
  c6:	2905                	addiw	s2,s2,1
  c8:	ff249ce3          	bne	s1,s2,c0 <run_experiment+0xc0>
  }

  int actual = race_get();
  cc:	5be000ef          	jal	68a <race_get>
  d0:	84aa                	mv	s1,a0
  int lost = expected - actual;
  d2:	40a98abb          	subw	s5,s3,a0
  d6:	8bd6                	mv	s7,s5
  int loss_pct = (expected > 0) ? (lost * 100) / expected : 0;
  d8:	4901                	li	s2,0
  da:	01605863          	blez	s6,ea <run_experiment+0xea>
  de:	06400913          	li	s2,100
  e2:	0359093b          	mulw	s2,s2,s5
  e6:	0339493b          	divw	s2,s2,s3

  printf("Execution Complete. Reading final shared kernel counter...\n");
  ea:	00001517          	auipc	a0,0x1
  ee:	d3e50513          	addi	a0,a0,-706 # e28 <malloc+0x31c>
  f2:	15f000ef          	jal	a50 <printf>
  printf("------------------------------------------------------------\n");
  f6:	00001517          	auipc	a0,0x1
  fa:	c9250513          	addi	a0,a0,-878 # d88 <malloc+0x27c>
  fe:	153000ef          	jal	a50 <printf>
  printf("  >> Expected Value  : %d\n", expected);
 102:	85ce                	mv	a1,s3
 104:	00001517          	auipc	a0,0x1
 108:	d6450513          	addi	a0,a0,-668 # e68 <malloc+0x35c>
 10c:	145000ef          	jal	a50 <printf>
  printf("  >> Actual Counter  : %d\n", actual);
 110:	85a6                	mv	a1,s1
 112:	00001517          	auipc	a0,0x1
 116:	d7650513          	addi	a0,a0,-650 # e88 <malloc+0x37c>
 11a:	137000ef          	jal	a50 <printf>
  printf("  >> Lost Updates    : %d (%d%% data loss)\n", lost, loss_pct);
 11e:	864a                	mv	a2,s2
 120:	85d6                	mv	a1,s5
 122:	00001517          	auipc	a0,0x1
 126:	d8650513          	addi	a0,a0,-634 # ea8 <malloc+0x39c>
 12a:	127000ef          	jal	a50 <printf>
  printf("------------------------------------------------------------\n");
 12e:	00001517          	auipc	a0,0x1
 132:	c5a50513          	addi	a0,a0,-934 # d88 <malloc+0x27c>
 136:	11b000ef          	jal	a50 <printf>

  if (!use_lock) {
 13a:	040a1a63          	bnez	s4,18e <run_experiment+0x18e>
    if (lost > 0) {
 13e:	05705163          	blez	s7,180 <run_experiment+0x180>
      printf("VERDICT: RACE CONDITION CONFIRMED!\n");
 142:	00001517          	auipc	a0,0x1
 146:	d9650513          	addi	a0,a0,-618 # ed8 <malloc+0x3cc>
 14a:	107000ef          	jal	a50 <printf>
      printf("Interleaved memory access on multi-core CPU caused %d lost updates.\n", lost);
 14e:	85d6                	mv	a1,s5
 150:	00001517          	auipc	a0,0x1
 154:	db050513          	addi	a0,a0,-592 # f00 <malloc+0x3f4>
 158:	0f9000ef          	jal	a50 <printf>
 15c:	a089                	j	19e <run_experiment+0x19e>
      printf("racetest: fork failed on child %d\n", i);
 15e:	85a6                	mv	a1,s1
 160:	00001517          	auipc	a0,0x1
 164:	ca050513          	addi	a0,a0,-864 # e00 <malloc+0x2f4>
 168:	0e9000ef          	jal	a50 <printf>
      exit(1);
 16c:	4505                	li	a0,1
 16e:	464000ef          	jal	5d2 <exit>
      race_inc(iters, use_lock);
 172:	85d2                	mv	a1,s4
 174:	8556                	mv	a0,s5
 176:	50c000ef          	jal	682 <race_inc>
      exit(0);
 17a:	4501                	li	a0,0
 17c:	456000ef          	jal	5d2 <exit>
    } else {
      printf("VERDICT: No lost updates observed in this trial. Increase iterations.\n");
 180:	00001517          	auipc	a0,0x1
 184:	dc850513          	addi	a0,a0,-568 # f48 <malloc+0x43c>
 188:	0c9000ef          	jal	a50 <printf>
 18c:	a809                	j	19e <run_experiment+0x19e>
    }
  } else {
    if (actual == expected) {
 18e:	029b0963          	beq	s6,s1,1c0 <run_experiment+0x1c0>
      printf("VERDICT: PERFECT MUTUAL EXCLUSION!\n");
      printf("xv6 Spinlock eliminated race condition. 100%% updates preserved.\n");
    } else {
      printf("VERDICT: UNEXPECTED DISCREPANCY detected under locking.\n");
 192:	00001517          	auipc	a0,0x1
 196:	e6e50513          	addi	a0,a0,-402 # 1000 <malloc+0x4f4>
 19a:	0b7000ef          	jal	a50 <printf>
    }
  }
  printf("============================================================\n");
 19e:	00001517          	auipc	a0,0x1
 1a2:	ea250513          	addi	a0,a0,-350 # 1040 <malloc+0x534>
 1a6:	0ab000ef          	jal	a50 <printf>
}
 1aa:	60a6                	ld	ra,72(sp)
 1ac:	6406                	ld	s0,64(sp)
 1ae:	74e2                	ld	s1,56(sp)
 1b0:	7942                	ld	s2,48(sp)
 1b2:	79a2                	ld	s3,40(sp)
 1b4:	7a02                	ld	s4,32(sp)
 1b6:	6ae2                	ld	s5,24(sp)
 1b8:	6b42                	ld	s6,16(sp)
 1ba:	6ba2                	ld	s7,8(sp)
 1bc:	6161                	addi	sp,sp,80
 1be:	8082                	ret
      printf("VERDICT: PERFECT MUTUAL EXCLUSION!\n");
 1c0:	00001517          	auipc	a0,0x1
 1c4:	dd050513          	addi	a0,a0,-560 # f90 <malloc+0x484>
 1c8:	089000ef          	jal	a50 <printf>
      printf("xv6 Spinlock eliminated race condition. 100%% updates preserved.\n");
 1cc:	00001517          	auipc	a0,0x1
 1d0:	dec50513          	addi	a0,a0,-532 # fb8 <malloc+0x4ac>
 1d4:	07d000ef          	jal	a50 <printf>
 1d8:	b7d9                	j	19e <run_experiment+0x19e>

00000000000001da <main>:

int
main(int argc, char *argv[])
{
 1da:	7179                	addi	sp,sp,-48
 1dc:	f406                	sd	ra,40(sp)
 1de:	f022                	sd	s0,32(sp)
 1e0:	ec26                	sd	s1,24(sp)
 1e2:	e84a                	sd	s2,16(sp)
 1e4:	e44e                	sd	s3,8(sp)
 1e6:	1800                	addi	s0,sp,48
 1e8:	84aa                	mv	s1,a0
 1ea:	892e                	mv	s2,a1
  printf("\n############################################################\n");
 1ec:	00001517          	auipc	a0,0x1
 1f0:	e9450513          	addi	a0,a0,-364 # 1080 <malloc+0x574>
 1f4:	05d000ef          	jal	a50 <printf>
  printf("#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n");
 1f8:	00001517          	auipc	a0,0x1
 1fc:	ec850513          	addi	a0,a0,-312 # 10c0 <malloc+0x5b4>
 200:	051000ef          	jal	a50 <printf>
  printf("#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n");
 204:	00001517          	auipc	a0,0x1
 208:	efc50513          	addi	a0,a0,-260 # 1100 <malloc+0x5f4>
 20c:	045000ef          	jal	a50 <printf>
  printf("############################################################\n");
 210:	00001517          	auipc	a0,0x1
 214:	f3050513          	addi	a0,a0,-208 # 1140 <malloc+0x634>
 218:	039000ef          	jal	a50 <printf>

  if (argc == 1) {
 21c:	4785                	li	a5,1
 21e:	04f48963          	beq	s1,a5,270 <main+0x96>
    // Automated comparative demonstration: 4 processes x 1000 iterations
    printf("\nRunning automated comprehensive benchmark (4 processes x 1000 ops)...\n");
    run_experiment(4, 1000, 0); // Unlocked Race Condition
    run_experiment(4, 1000, 1); // Spinlock Protected
  } else if (argc == 2 && strcmp(argv[1], "unlocked") == 0) {
 222:	4789                	li	a5,2
 224:	06f48b63          	beq	s1,a5,29a <main+0xc0>
    run_experiment(4, 1000, 0);
  } else if (argc == 2 && strcmp(argv[1], "locked") == 0) {
    run_experiment(4, 1000, 1);
  } else if (argc == 4) {
 228:	4791                	li	a5,4
 22a:	0af48863          	beq	s1,a5,2da <main+0x100>
      printf("Usage: racetest [children] [iterations] [0=unlocked, 1=locked]\n");
      exit(1);
    }
    run_experiment(children, iters, lock);
  } else {
    printf("Usage:\n");
 22e:	00001517          	auipc	a0,0x1
 232:	ff250513          	addi	a0,a0,-14 # 1220 <malloc+0x714>
 236:	01b000ef          	jal	a50 <printf>
    printf("  racetest                       (Run full automated comparison)\n");
 23a:	00001517          	auipc	a0,0x1
 23e:	fee50513          	addi	a0,a0,-18 # 1228 <malloc+0x71c>
 242:	00f000ef          	jal	a50 <printf>
    printf("  racetest unlocked              (Run unlocked race test)\n");
 246:	00001517          	auipc	a0,0x1
 24a:	02a50513          	addi	a0,a0,42 # 1270 <malloc+0x764>
 24e:	003000ef          	jal	a50 <printf>
    printf("  racetest locked                (Run spinlock protected test)\n");
 252:	00001517          	auipc	a0,0x1
 256:	05e50513          	addi	a0,a0,94 # 12b0 <malloc+0x7a4>
 25a:	7f6000ef          	jal	a50 <printf>
    printf("  racetest <procs> <iters> <0|1> (Custom benchmark)\n");
 25e:	00001517          	auipc	a0,0x1
 262:	09250513          	addi	a0,a0,146 # 12f0 <malloc+0x7e4>
 266:	7ea000ef          	jal	a50 <printf>
    exit(1);
 26a:	4505                	li	a0,1
 26c:	366000ef          	jal	5d2 <exit>
    printf("\nRunning automated comprehensive benchmark (4 processes x 1000 ops)...\n");
 270:	00001517          	auipc	a0,0x1
 274:	f1050513          	addi	a0,a0,-240 # 1180 <malloc+0x674>
 278:	7d8000ef          	jal	a50 <printf>
    run_experiment(4, 1000, 0); // Unlocked Race Condition
 27c:	4601                	li	a2,0
 27e:	3e800593          	li	a1,1000
 282:	4511                	li	a0,4
 284:	d7dff0ef          	jal	0 <run_experiment>
    run_experiment(4, 1000, 1); // Spinlock Protected
 288:	8626                	mv	a2,s1
 28a:	3e800593          	li	a1,1000
 28e:	4511                	li	a0,4
 290:	d71ff0ef          	jal	0 <run_experiment>
  }

  exit(0);
 294:	4501                	li	a0,0
 296:	33c000ef          	jal	5d2 <exit>
  } else if (argc == 2 && strcmp(argv[1], "unlocked") == 0) {
 29a:	00001597          	auipc	a1,0x1
 29e:	f2e58593          	addi	a1,a1,-210 # 11c8 <malloc+0x6bc>
 2a2:	00893503          	ld	a0,8(s2)
 2a6:	0a6000ef          	jal	34c <strcmp>
 2aa:	e901                	bnez	a0,2ba <main+0xe0>
    run_experiment(4, 1000, 0);
 2ac:	4601                	li	a2,0
 2ae:	3e800593          	li	a1,1000
 2b2:	4511                	li	a0,4
 2b4:	d4dff0ef          	jal	0 <run_experiment>
 2b8:	bff1                	j	294 <main+0xba>
  } else if (argc == 2 && strcmp(argv[1], "locked") == 0) {
 2ba:	00001597          	auipc	a1,0x1
 2be:	f1e58593          	addi	a1,a1,-226 # 11d8 <malloc+0x6cc>
 2c2:	00893503          	ld	a0,8(s2)
 2c6:	086000ef          	jal	34c <strcmp>
 2ca:	f135                	bnez	a0,22e <main+0x54>
    run_experiment(4, 1000, 1);
 2cc:	4605                	li	a2,1
 2ce:	3e800593          	li	a1,1000
 2d2:	4511                	li	a0,4
 2d4:	d2dff0ef          	jal	0 <run_experiment>
 2d8:	bf75                	j	294 <main+0xba>
    int children = atoi(argv[1]);
 2da:	00893503          	ld	a0,8(s2)
 2de:	1ce000ef          	jal	4ac <atoi>
 2e2:	84aa                	mv	s1,a0
    int iters = atoi(argv[2]);
 2e4:	01093503          	ld	a0,16(s2)
 2e8:	1c4000ef          	jal	4ac <atoi>
 2ec:	89aa                	mv	s3,a0
    int lock = atoi(argv[3]);
 2ee:	01893503          	ld	a0,24(s2)
 2f2:	1ba000ef          	jal	4ac <atoi>
 2f6:	862a                	mv	a2,a0
    if (children <= 0 || iters <= 0) {
 2f8:	00905963          	blez	s1,30a <main+0x130>
 2fc:	01305763          	blez	s3,30a <main+0x130>
    run_experiment(children, iters, lock);
 300:	85ce                	mv	a1,s3
 302:	8526                	mv	a0,s1
 304:	cfdff0ef          	jal	0 <run_experiment>
 308:	b771                	j	294 <main+0xba>
      printf("Usage: racetest [children] [iterations] [0=unlocked, 1=locked]\n");
 30a:	00001517          	auipc	a0,0x1
 30e:	ed650513          	addi	a0,a0,-298 # 11e0 <malloc+0x6d4>
 312:	73e000ef          	jal	a50 <printf>
      exit(1);
 316:	4505                	li	a0,1
 318:	2ba000ef          	jal	5d2 <exit>

000000000000031c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 324:	eb7ff0ef          	jal	1da <main>
  exit(r);
 328:	2aa000ef          	jal	5d2 <exit>

000000000000032c <strcpy>:
}

char *
strcpy(char *s, const char *t)
{
 32c:	1141                	addi	sp,sp,-16
 32e:	e406                	sd	ra,8(sp)
 330:	e022                	sd	s0,0(sp)
 332:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while ((*s++ = *t++) != 0)
 334:	87aa                	mv	a5,a0
 336:	0585                	addi	a1,a1,1
 338:	0785                	addi	a5,a5,1
 33a:	fff5c703          	lbu	a4,-1(a1)
 33e:	fee78fa3          	sb	a4,-1(a5)
 342:	fb75                	bnez	a4,336 <strcpy+0xa>
    ;
  return os;
}
 344:	60a2                	ld	ra,8(sp)
 346:	6402                	ld	s0,0(sp)
 348:	0141                	addi	sp,sp,16
 34a:	8082                	ret

000000000000034c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 34c:	1141                	addi	sp,sp,-16
 34e:	e406                	sd	ra,8(sp)
 350:	e022                	sd	s0,0(sp)
 352:	0800                	addi	s0,sp,16
  while (*p && *p == *q)
 354:	00054783          	lbu	a5,0(a0)
 358:	cb91                	beqz	a5,36c <strcmp+0x20>
 35a:	0005c703          	lbu	a4,0(a1)
 35e:	00f71763          	bne	a4,a5,36c <strcmp+0x20>
    p++, q++;
 362:	0505                	addi	a0,a0,1
 364:	0585                	addi	a1,a1,1
  while (*p && *p == *q)
 366:	00054783          	lbu	a5,0(a0)
 36a:	fbe5                	bnez	a5,35a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 36c:	0005c503          	lbu	a0,0(a1)
}
 370:	40a7853b          	subw	a0,a5,a0
 374:	60a2                	ld	ra,8(sp)
 376:	6402                	ld	s0,0(sp)
 378:	0141                	addi	sp,sp,16
 37a:	8082                	ret

000000000000037c <strlen>:

uint
strlen(const char *s)
{
 37c:	1141                	addi	sp,sp,-16
 37e:	e406                	sd	ra,8(sp)
 380:	e022                	sd	s0,0(sp)
 382:	0800                	addi	s0,sp,16
  int n;

  for (n = 0; s[n]; n++)
 384:	00054783          	lbu	a5,0(a0)
 388:	cf91                	beqz	a5,3a4 <strlen+0x28>
 38a:	00150793          	addi	a5,a0,1
 38e:	86be                	mv	a3,a5
 390:	0785                	addi	a5,a5,1
 392:	fff7c703          	lbu	a4,-1(a5)
 396:	ff65                	bnez	a4,38e <strlen+0x12>
 398:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 39c:	60a2                	ld	ra,8(sp)
 39e:	6402                	ld	s0,0(sp)
 3a0:	0141                	addi	sp,sp,16
 3a2:	8082                	ret
  for (n = 0; s[n]; n++)
 3a4:	4501                	li	a0,0
 3a6:	bfdd                	j	39c <strlen+0x20>

00000000000003a8 <memset>:

void *
memset(void *dst, int c, uint n)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  char *cdst = (char *)dst;
  int i;
  for (i = 0; i < n; i++) {
 3b0:	ca19                	beqz	a2,3c6 <memset+0x1e>
 3b2:	87aa                	mv	a5,a0
 3b4:	1602                	slli	a2,a2,0x20
 3b6:	9201                	srli	a2,a2,0x20
 3b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 3bc:	00b78023          	sb	a1,0(a5)
  for (i = 0; i < n; i++) {
 3c0:	0785                	addi	a5,a5,1
 3c2:	fee79de3          	bne	a5,a4,3bc <memset+0x14>
  }
  return dst;
}
 3c6:	60a2                	ld	ra,8(sp)
 3c8:	6402                	ld	s0,0(sp)
 3ca:	0141                	addi	sp,sp,16
 3cc:	8082                	ret

00000000000003ce <strchr>:

char *
strchr(const char *s, char c)
{
 3ce:	1141                	addi	sp,sp,-16
 3d0:	e406                	sd	ra,8(sp)
 3d2:	e022                	sd	s0,0(sp)
 3d4:	0800                	addi	s0,sp,16
  for (; *s; s++)
 3d6:	00054783          	lbu	a5,0(a0)
 3da:	c799                	beqz	a5,3e8 <strchr+0x1a>
    if (*s == c)
 3dc:	00f58763          	beq	a1,a5,3ea <strchr+0x1c>
  for (; *s; s++)
 3e0:	0505                	addi	a0,a0,1
 3e2:	00054783          	lbu	a5,0(a0)
 3e6:	fbfd                	bnez	a5,3dc <strchr+0xe>
      return (char *)s;
  return 0;
 3e8:	4501                	li	a0,0
}
 3ea:	60a2                	ld	ra,8(sp)
 3ec:	6402                	ld	s0,0(sp)
 3ee:	0141                	addi	sp,sp,16
 3f0:	8082                	ret

00000000000003f2 <gets>:

char *
gets(char *buf, int max)
{
 3f2:	711d                	addi	sp,sp,-96
 3f4:	ec86                	sd	ra,88(sp)
 3f6:	e8a2                	sd	s0,80(sp)
 3f8:	e4a6                	sd	s1,72(sp)
 3fa:	e0ca                	sd	s2,64(sp)
 3fc:	fc4e                	sd	s3,56(sp)
 3fe:	f852                	sd	s4,48(sp)
 400:	f456                	sd	s5,40(sp)
 402:	f05a                	sd	s6,32(sp)
 404:	ec5e                	sd	s7,24(sp)
 406:	e862                	sd	s8,16(sp)
 408:	1080                	addi	s0,sp,96
 40a:	8baa                	mv	s7,a0
 40c:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for (i = 0; i + 1 < max;) {
 40e:	892a                	mv	s2,a0
 410:	4481                	li	s1,0
    cc = read(0, &c, 1);
 412:	faf40b13          	addi	s6,s0,-81
 416:	4a85                	li	s5,1
  for (i = 0; i + 1 < max;) {
 418:	8c26                	mv	s8,s1
 41a:	0014899b          	addiw	s3,s1,1
 41e:	84ce                	mv	s1,s3
 420:	0349d863          	bge	s3,s4,450 <gets+0x5e>
    cc = read(0, &c, 1);
 424:	8656                	mv	a2,s5
 426:	85da                	mv	a1,s6
 428:	4501                	li	a0,0
 42a:	1c0000ef          	jal	5ea <read>
    if (cc < 1)
 42e:	02a05163          	blez	a0,450 <gets+0x5e>
      break;
    buf[i++] = c;
 432:	faf44783          	lbu	a5,-81(s0)
 436:	00f90023          	sb	a5,0(s2)
    if (c == '\n' || c == '\r')
 43a:	0905                	addi	s2,s2,1
 43c:	ff678713          	addi	a4,a5,-10
 440:	00173713          	seqz	a4,a4
 444:	17cd                	addi	a5,a5,-13
 446:	0017b793          	seqz	a5,a5
 44a:	8fd9                	or	a5,a5,a4
 44c:	d7f1                	beqz	a5,418 <gets+0x26>
    buf[i++] = c;
 44e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 450:	9c5e                	add	s8,s8,s7
 452:	000c0023          	sb	zero,0(s8)
  return buf;
}
 456:	855e                	mv	a0,s7
 458:	60e6                	ld	ra,88(sp)
 45a:	6446                	ld	s0,80(sp)
 45c:	64a6                	ld	s1,72(sp)
 45e:	6906                	ld	s2,64(sp)
 460:	79e2                	ld	s3,56(sp)
 462:	7a42                	ld	s4,48(sp)
 464:	7aa2                	ld	s5,40(sp)
 466:	7b02                	ld	s6,32(sp)
 468:	6be2                	ld	s7,24(sp)
 46a:	6c42                	ld	s8,16(sp)
 46c:	6125                	addi	sp,sp,96
 46e:	8082                	ret

0000000000000470 <stat>:

int
stat(const char *n, struct stat *st)
{
 470:	1101                	addi	sp,sp,-32
 472:	ec06                	sd	ra,24(sp)
 474:	e822                	sd	s0,16(sp)
 476:	e04a                	sd	s2,0(sp)
 478:	1000                	addi	s0,sp,32
 47a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 47c:	4581                	li	a1,0
 47e:	194000ef          	jal	612 <open>
  if (fd < 0)
 482:	02054263          	bltz	a0,4a6 <stat+0x36>
 486:	e426                	sd	s1,8(sp)
 488:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 48a:	85ca                	mv	a1,s2
 48c:	19e000ef          	jal	62a <fstat>
 490:	892a                	mv	s2,a0
  close(fd);
 492:	8526                	mv	a0,s1
 494:	166000ef          	jal	5fa <close>
  return r;
 498:	64a2                	ld	s1,8(sp)
}
 49a:	854a                	mv	a0,s2
 49c:	60e2                	ld	ra,24(sp)
 49e:	6442                	ld	s0,16(sp)
 4a0:	6902                	ld	s2,0(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret
    return -1;
 4a6:	57fd                	li	a5,-1
 4a8:	893e                	mv	s2,a5
 4aa:	bfc5                	j	49a <stat+0x2a>

00000000000004ac <atoi>:

int
atoi(const char *s)
{
 4ac:	1141                	addi	sp,sp,-16
 4ae:	e406                	sd	ra,8(sp)
 4b0:	e022                	sd	s0,0(sp)
 4b2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while ('0' <= *s && *s <= '9')
 4b4:	00054683          	lbu	a3,0(a0)
 4b8:	fd06879b          	addiw	a5,a3,-48
 4bc:	0ff7f793          	zext.b	a5,a5
 4c0:	4625                	li	a2,9
 4c2:	02f66963          	bltu	a2,a5,4f4 <atoi+0x48>
 4c6:	872a                	mv	a4,a0
  n = 0;
 4c8:	4501                	li	a0,0
    n = n * 10 + *s++ - '0';
 4ca:	0705                	addi	a4,a4,1
 4cc:	0025179b          	slliw	a5,a0,0x2
 4d0:	9fa9                	addw	a5,a5,a0
 4d2:	0017979b          	slliw	a5,a5,0x1
 4d6:	9fb5                	addw	a5,a5,a3
 4d8:	fd07851b          	addiw	a0,a5,-48
  while ('0' <= *s && *s <= '9')
 4dc:	00074683          	lbu	a3,0(a4)
 4e0:	fd06879b          	addiw	a5,a3,-48
 4e4:	0ff7f793          	zext.b	a5,a5
 4e8:	fef671e3          	bgeu	a2,a5,4ca <atoi+0x1e>
  return n;
}
 4ec:	60a2                	ld	ra,8(sp)
 4ee:	6402                	ld	s0,0(sp)
 4f0:	0141                	addi	sp,sp,16
 4f2:	8082                	ret
  n = 0;
 4f4:	4501                	li	a0,0
 4f6:	bfdd                	j	4ec <atoi+0x40>

00000000000004f8 <memmove>:

void *
memmove(void *vdst, const void *vsrc, int n)
{
 4f8:	1141                	addi	sp,sp,-16
 4fa:	e406                	sd	ra,8(sp)
 4fc:	e022                	sd	s0,0(sp)
 4fe:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 500:	02b57563          	bgeu	a0,a1,52a <memmove+0x32>
    while (n-- > 0)
 504:	00c05f63          	blez	a2,522 <memmove+0x2a>
 508:	1602                	slli	a2,a2,0x20
 50a:	9201                	srli	a2,a2,0x20
 50c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 510:	872a                	mv	a4,a0
      *dst++ = *src++;
 512:	0585                	addi	a1,a1,1
 514:	0705                	addi	a4,a4,1
 516:	fff5c683          	lbu	a3,-1(a1)
 51a:	fed70fa3          	sb	a3,-1(a4)
    while (n-- > 0)
 51e:	fee79ae3          	bne	a5,a4,512 <memmove+0x1a>
    src += n;
    while (n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 522:	60a2                	ld	ra,8(sp)
 524:	6402                	ld	s0,0(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret
    while (n-- > 0)
 52a:	fec05ce3          	blez	a2,522 <memmove+0x2a>
    dst += n;
 52e:	00c50733          	add	a4,a0,a2
    src += n;
 532:	95b2                	add	a1,a1,a2
 534:	fff6079b          	addiw	a5,a2,-1
 538:	1782                	slli	a5,a5,0x20
 53a:	9381                	srli	a5,a5,0x20
 53c:	fff7c793          	not	a5,a5
 540:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 542:	15fd                	addi	a1,a1,-1
 544:	177d                	addi	a4,a4,-1
 546:	0005c683          	lbu	a3,0(a1)
 54a:	00d70023          	sb	a3,0(a4)
    while (n-- > 0)
 54e:	fef71ae3          	bne	a4,a5,542 <memmove+0x4a>
 552:	bfc1                	j	522 <memmove+0x2a>

0000000000000554 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 554:	1141                	addi	sp,sp,-16
 556:	e406                	sd	ra,8(sp)
 558:	e022                	sd	s0,0(sp)
 55a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 55c:	ce19                	beqz	a2,57a <memcmp+0x26>
 55e:	1602                	slli	a2,a2,0x20
 560:	9201                	srli	a2,a2,0x20
 562:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 566:	00054783          	lbu	a5,0(a0)
 56a:	0005c703          	lbu	a4,0(a1)
 56e:	00e79b63          	bne	a5,a4,584 <memcmp+0x30>
      return *p1 - *p2;
    }
    p1++;
 572:	0505                	addi	a0,a0,1
    p2++;
 574:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 576:	fed518e3          	bne	a0,a3,566 <memcmp+0x12>
  }
  return 0;
 57a:	4501                	li	a0,0
}
 57c:	60a2                	ld	ra,8(sp)
 57e:	6402                	ld	s0,0(sp)
 580:	0141                	addi	sp,sp,16
 582:	8082                	ret
      return *p1 - *p2;
 584:	40e7853b          	subw	a0,a5,a4
 588:	bfd5                	j	57c <memcmp+0x28>

000000000000058a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 58a:	1141                	addi	sp,sp,-16
 58c:	e406                	sd	ra,8(sp)
 58e:	e022                	sd	s0,0(sp)
 590:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 592:	f67ff0ef          	jal	4f8 <memmove>
}
 596:	60a2                	ld	ra,8(sp)
 598:	6402                	ld	s0,0(sp)
 59a:	0141                	addi	sp,sp,16
 59c:	8082                	ret

000000000000059e <sbrk>:

char *
sbrk(int n)
{
 59e:	1141                	addi	sp,sp,-16
 5a0:	e406                	sd	ra,8(sp)
 5a2:	e022                	sd	s0,0(sp)
 5a4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 5a6:	4585                	li	a1,1
 5a8:	0b2000ef          	jal	65a <sys_sbrk>
}
 5ac:	60a2                	ld	ra,8(sp)
 5ae:	6402                	ld	s0,0(sp)
 5b0:	0141                	addi	sp,sp,16
 5b2:	8082                	ret

00000000000005b4 <sbrklazy>:

char *
sbrklazy(int n)
{
 5b4:	1141                	addi	sp,sp,-16
 5b6:	e406                	sd	ra,8(sp)
 5b8:	e022                	sd	s0,0(sp)
 5ba:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 5bc:	4589                	li	a1,2
 5be:	09c000ef          	jal	65a <sys_sbrk>
}
 5c2:	60a2                	ld	ra,8(sp)
 5c4:	6402                	ld	s0,0(sp)
 5c6:	0141                	addi	sp,sp,16
 5c8:	8082                	ret

00000000000005ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 5ca:	4885                	li	a7,1
 ecall
 5cc:	00000073          	ecall
 ret
 5d0:	8082                	ret

00000000000005d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 5d2:	4889                	li	a7,2
 ecall
 5d4:	00000073          	ecall
 ret
 5d8:	8082                	ret

00000000000005da <wait>:
.global wait
wait:
 li a7, SYS_wait
 5da:	488d                	li	a7,3
 ecall
 5dc:	00000073          	ecall
 ret
 5e0:	8082                	ret

00000000000005e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 5e2:	4891                	li	a7,4
 ecall
 5e4:	00000073          	ecall
 ret
 5e8:	8082                	ret

00000000000005ea <read>:
.global read
read:
 li a7, SYS_read
 5ea:	4895                	li	a7,5
 ecall
 5ec:	00000073          	ecall
 ret
 5f0:	8082                	ret

00000000000005f2 <write>:
.global write
write:
 li a7, SYS_write
 5f2:	48c1                	li	a7,16
 ecall
 5f4:	00000073          	ecall
 ret
 5f8:	8082                	ret

00000000000005fa <close>:
.global close
close:
 li a7, SYS_close
 5fa:	48d5                	li	a7,21
 ecall
 5fc:	00000073          	ecall
 ret
 600:	8082                	ret

0000000000000602 <kill>:
.global kill
kill:
 li a7, SYS_kill
 602:	4899                	li	a7,6
 ecall
 604:	00000073          	ecall
 ret
 608:	8082                	ret

000000000000060a <exec>:
.global exec
exec:
 li a7, SYS_exec
 60a:	489d                	li	a7,7
 ecall
 60c:	00000073          	ecall
 ret
 610:	8082                	ret

0000000000000612 <open>:
.global open
open:
 li a7, SYS_open
 612:	48bd                	li	a7,15
 ecall
 614:	00000073          	ecall
 ret
 618:	8082                	ret

000000000000061a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 61a:	48c5                	li	a7,17
 ecall
 61c:	00000073          	ecall
 ret
 620:	8082                	ret

0000000000000622 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 622:	48c9                	li	a7,18
 ecall
 624:	00000073          	ecall
 ret
 628:	8082                	ret

000000000000062a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 62a:	48a1                	li	a7,8
 ecall
 62c:	00000073          	ecall
 ret
 630:	8082                	ret

0000000000000632 <link>:
.global link
link:
 li a7, SYS_link
 632:	48cd                	li	a7,19
 ecall
 634:	00000073          	ecall
 ret
 638:	8082                	ret

000000000000063a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 63a:	48d1                	li	a7,20
 ecall
 63c:	00000073          	ecall
 ret
 640:	8082                	ret

0000000000000642 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 642:	48a5                	li	a7,9
 ecall
 644:	00000073          	ecall
 ret
 648:	8082                	ret

000000000000064a <dup>:
.global dup
dup:
 li a7, SYS_dup
 64a:	48a9                	li	a7,10
 ecall
 64c:	00000073          	ecall
 ret
 650:	8082                	ret

0000000000000652 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 652:	48ad                	li	a7,11
 ecall
 654:	00000073          	ecall
 ret
 658:	8082                	ret

000000000000065a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 65a:	48b1                	li	a7,12
 ecall
 65c:	00000073          	ecall
 ret
 660:	8082                	ret

0000000000000662 <pause>:
.global pause
pause:
 li a7, SYS_pause
 662:	48b5                	li	a7,13
 ecall
 664:	00000073          	ecall
 ret
 668:	8082                	ret

000000000000066a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 66a:	48b9                	li	a7,14
 ecall
 66c:	00000073          	ecall
 ret
 670:	8082                	ret

0000000000000672 <sync>:
.global sync
sync:
 li a7, SYS_sync
 672:	48d9                	li	a7,22
 ecall
 674:	00000073          	ecall
 ret
 678:	8082                	ret

000000000000067a <trace>:
.global trace
trace:
 li a7, SYS_trace
 67a:	48dd                	li	a7,23
 ecall
 67c:	00000073          	ecall
 ret
 680:	8082                	ret

0000000000000682 <race_inc>:
.global race_inc
race_inc:
 li a7, SYS_race_inc
 682:	48e1                	li	a7,24
 ecall
 684:	00000073          	ecall
 ret
 688:	8082                	ret

000000000000068a <race_get>:
.global race_get
race_get:
 li a7, SYS_race_get
 68a:	48e5                	li	a7,25
 ecall
 68c:	00000073          	ecall
 ret
 690:	8082                	ret

0000000000000692 <race_reset>:
.global race_reset
race_reset:
 li a7, SYS_race_reset
 692:	48e9                	li	a7,26
 ecall
 694:	00000073          	ecall
 ret
 698:	8082                	ret

000000000000069a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 69a:	1101                	addi	sp,sp,-32
 69c:	ec06                	sd	ra,24(sp)
 69e:	e822                	sd	s0,16(sp)
 6a0:	1000                	addi	s0,sp,32
 6a2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 6a6:	4605                	li	a2,1
 6a8:	fef40593          	addi	a1,s0,-17
 6ac:	f47ff0ef          	jal	5f2 <write>
}
 6b0:	60e2                	ld	ra,24(sp)
 6b2:	6442                	ld	s0,16(sp)
 6b4:	6105                	addi	sp,sp,32
 6b6:	8082                	ret

00000000000006b8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 6b8:	715d                	addi	sp,sp,-80
 6ba:	e486                	sd	ra,72(sp)
 6bc:	e0a2                	sd	s0,64(sp)
 6be:	f84a                	sd	s2,48(sp)
 6c0:	f44e                	sd	s3,40(sp)
 6c2:	0880                	addi	s0,sp,80
 6c4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if (sgn && xx < 0) {
 6c6:	00d036b3          	snez	a3,a3
 6ca:	03f5d793          	srli	a5,a1,0x3f
 6ce:	8efd                	and	a3,a3,a5
  neg = 0;
 6d0:	4301                	li	t1,0
  if (sgn && xx < 0) {
 6d2:	c681                	beqz	a3,6da <printint+0x22>
    neg = 1;
    x = -xx;
 6d4:	40b005b3          	neg	a1,a1
    neg = 1;
 6d8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 6da:	fb840993          	addi	s3,s0,-72
  neg = 0;
 6de:	86ce                	mv	a3,s3
  i = 0;
 6e0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
 6e2:	00001817          	auipc	a6,0x1
 6e6:	c4e80813          	addi	a6,a6,-946 # 1330 <digits>
 6ea:	88ba                	mv	a7,a4
 6ec:	0017051b          	addiw	a0,a4,1
 6f0:	872a                	mv	a4,a0
 6f2:	02c5f7b3          	remu	a5,a1,a2
 6f6:	97c2                	add	a5,a5,a6
 6f8:	0007c783          	lbu	a5,0(a5)
 6fc:	00f68023          	sb	a5,0(a3)
  } while ((x /= base) != 0);
 700:	87ae                	mv	a5,a1
 702:	02c5d5b3          	divu	a1,a1,a2
 706:	0685                	addi	a3,a3,1
 708:	fec7f1e3          	bgeu	a5,a2,6ea <printint+0x32>
  if (neg)
 70c:	00030b63          	beqz	t1,722 <printint+0x6a>
    buf[i++] = '-';
 710:	fd040793          	addi	a5,s0,-48
 714:	953e                	add	a0,a0,a5
 716:	02d00793          	li	a5,45
 71a:	fef50423          	sb	a5,-24(a0)
 71e:	0028871b          	addiw	a4,a7,2

  while (--i >= 0)
 722:	02e05563          	blez	a4,74c <printint+0x94>
 726:	fc26                	sd	s1,56(sp)
 728:	377d                	addiw	a4,a4,-1
 72a:	00e984b3          	add	s1,s3,a4
 72e:	19fd                	addi	s3,s3,-1
 730:	99ba                	add	s3,s3,a4
 732:	1702                	slli	a4,a4,0x20
 734:	9301                	srli	a4,a4,0x20
 736:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 73a:	0004c583          	lbu	a1,0(s1)
 73e:	854a                	mv	a0,s2
 740:	f5bff0ef          	jal	69a <putc>
  while (--i >= 0)
 744:	14fd                	addi	s1,s1,-1
 746:	ff349ae3          	bne	s1,s3,73a <printint+0x82>
 74a:	74e2                	ld	s1,56(sp)
}
 74c:	60a6                	ld	ra,72(sp)
 74e:	6406                	ld	s0,64(sp)
 750:	7942                	ld	s2,48(sp)
 752:	79a2                	ld	s3,40(sp)
 754:	6161                	addi	sp,sp,80
 756:	8082                	ret

0000000000000758 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 758:	711d                	addi	sp,sp,-96
 75a:	ec86                	sd	ra,88(sp)
 75c:	e8a2                	sd	s0,80(sp)
 75e:	e4a6                	sd	s1,72(sp)
 760:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for (i = 0; fmt[i]; i++) {
 762:	0005c483          	lbu	s1,0(a1)
 766:	2a048063          	beqz	s1,a06 <vprintf+0x2ae>
 76a:	e0ca                	sd	s2,64(sp)
 76c:	fc4e                	sd	s3,56(sp)
 76e:	f852                	sd	s4,48(sp)
 770:	f456                	sd	s5,40(sp)
 772:	f05a                	sd	s6,32(sp)
 774:	ec5e                	sd	s7,24(sp)
 776:	e862                	sd	s8,16(sp)
 778:	8b2a                	mv	s6,a0
 77a:	8a2e                	mv	s4,a1
 77c:	8bb2                	mv	s7,a2
  state = 0;
 77e:	4981                	li	s3,0
  for (i = 0; fmt[i]; i++) {
 780:	4901                	li	s2,0
 782:	4701                	li	a4,0
      if (c0 == '%') {
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if (state == '%') {
 784:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if (c0)
        c1 = fmt[i + 1] & 0xff;
      if (c1)
        c2 = fmt[i + 2] & 0xff;
      if (c0 == 'd') {
 788:	06400c13          	li	s8,100
 78c:	a00d                	j	7ae <vprintf+0x56>
        putc(fd, c0);
 78e:	85a6                	mv	a1,s1
 790:	855a                	mv	a0,s6
 792:	f09ff0ef          	jal	69a <putc>
 796:	a019                	j	79c <vprintf+0x44>
    } else if (state == '%') {
 798:	03598363          	beq	s3,s5,7be <vprintf+0x66>
  for (i = 0; fmt[i]; i++) {
 79c:	0019079b          	addiw	a5,s2,1
 7a0:	893e                	mv	s2,a5
 7a2:	873e                	mv	a4,a5
 7a4:	97d2                	add	a5,a5,s4
 7a6:	0007c483          	lbu	s1,0(a5)
 7aa:	24048763          	beqz	s1,9f8 <vprintf+0x2a0>
    c0 = fmt[i] & 0xff;
 7ae:	0004879b          	sext.w	a5,s1
    if (state == 0) {
 7b2:	fe0993e3          	bnez	s3,798 <vprintf+0x40>
      if (c0 == '%') {
 7b6:	fd579ce3          	bne	a5,s5,78e <vprintf+0x36>
        state = '%';
 7ba:	89be                	mv	s3,a5
 7bc:	b7c5                	j	79c <vprintf+0x44>
        c1 = fmt[i + 1] & 0xff;
 7be:	00ea06b3          	add	a3,s4,a4
 7c2:	0016c603          	lbu	a2,1(a3)
      if (c1)
 7c6:	24060563          	beqz	a2,a10 <vprintf+0x2b8>
      if (c0 == 'd') {
 7ca:	0b878763          	beq	a5,s8,878 <vprintf+0x120>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if (c0 == 'l' && c1 == 'd') {
 7ce:	f9478693          	addi	a3,a5,-108
 7d2:	0016b693          	seqz	a3,a3
 7d6:	f9c60593          	addi	a1,a2,-100
 7da:	0015b593          	seqz	a1,a1
 7de:	8df5                	and	a1,a1,a3
 7e0:	e9c5                	bnez	a1,890 <vprintf+0x138>
        c2 = fmt[i + 2] & 0xff;
 7e2:	9752                	add	a4,a4,s4
 7e4:	00274503          	lbu	a0,2(a4)
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 7e8:	f9460713          	addi	a4,a2,-108
 7ec:	00173713          	seqz	a4,a4
 7f0:	8f75                	and	a4,a4,a3
 7f2:	f9c50593          	addi	a1,a0,-100
 7f6:	0015b593          	seqz	a1,a1
 7fa:	8df9                	and	a1,a1,a4
 7fc:	e5dd                	bnez	a1,8aa <vprintf+0x152>
        printint(fd, va_arg(ap, uint64), 10, 1);
        i += 2;
      } else if (c0 == 'u') {
 7fe:	07500593          	li	a1,117
 802:	0cb78163          	beq	a5,a1,8c4 <vprintf+0x16c>
        printint(fd, va_arg(ap, uint32), 10, 0);
      } else if (c0 == 'l' && c1 == 'u') {
 806:	f8b60593          	addi	a1,a2,-117
 80a:	0015b593          	seqz	a1,a1
 80e:	8df5                	and	a1,a1,a3
 810:	e5f1                	bnez	a1,8dc <vprintf+0x184>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'u') {
 812:	f8b50593          	addi	a1,a0,-117
 816:	0015b593          	seqz	a1,a1
 81a:	8df9                	and	a1,a1,a4
 81c:	ede9                	bnez	a1,8f6 <vprintf+0x19e>
        printint(fd, va_arg(ap, uint64), 10, 0);
        i += 2;
      } else if (c0 == 'x') {
 81e:	07800593          	li	a1,120
 822:	0eb78763          	beq	a5,a1,910 <vprintf+0x1b8>
        printint(fd, va_arg(ap, uint32), 16, 0);
      } else if (c0 == 'l' && c1 == 'x') {
 826:	f8860613          	addi	a2,a2,-120
 82a:	00163613          	seqz	a2,a2
 82e:	8ef1                	and	a3,a3,a2
 830:	0e069c63          	bnez	a3,928 <vprintf+0x1d0>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 1;
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'x') {
 834:	f8850513          	addi	a0,a0,-120
 838:	00153513          	seqz	a0,a0
 83c:	8f69                	and	a4,a4,a0
 83e:	10071263          	bnez	a4,942 <vprintf+0x1ea>
        printint(fd, va_arg(ap, uint64), 16, 0);
        i += 2;
      } else if (c0 == 'p') {
 842:	07000713          	li	a4,112
 846:	10e78a63          	beq	a5,a4,95a <vprintf+0x202>
        printptr(fd, va_arg(ap, uint64));
      } else if (c0 == 'c') {
 84a:	06300713          	li	a4,99
 84e:	14e78a63          	beq	a5,a4,9a2 <vprintf+0x24a>
        putc(fd, va_arg(ap, uint32));
      } else if (c0 == 's') {
 852:	07300713          	li	a4,115
 856:	16e78063          	beq	a5,a4,9b6 <vprintf+0x25e>
        if ((s = va_arg(ap, char *)) == 0)
          s = "(null)";
        for (; *s; s++)
          putc(fd, *s);
      } else if (c0 == '%') {
 85a:	02500713          	li	a4,37
 85e:	18e78863          	beq	a5,a4,9ee <vprintf+0x296>
        putc(fd, '%');
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 862:	02500593          	li	a1,37
 866:	855a                	mv	a0,s6
 868:	e33ff0ef          	jal	69a <putc>
        putc(fd, c0);
 86c:	85a6                	mv	a1,s1
 86e:	855a                	mv	a0,s6
 870:	e2bff0ef          	jal	69a <putc>
      }

      state = 0;
 874:	4981                	li	s3,0
 876:	b71d                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 878:	008b8493          	addi	s1,s7,8
 87c:	4685                	li	a3,1
 87e:	4629                	li	a2,10
 880:	000ba583          	lw	a1,0(s7)
 884:	855a                	mv	a0,s6
 886:	e33ff0ef          	jal	6b8 <printint>
 88a:	8ba6                	mv	s7,s1
      state = 0;
 88c:	4981                	li	s3,0
 88e:	b739                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 890:	008b8493          	addi	s1,s7,8
 894:	4685                	li	a3,1
 896:	4629                	li	a2,10
 898:	000bb583          	ld	a1,0(s7)
 89c:	855a                	mv	a0,s6
 89e:	e1bff0ef          	jal	6b8 <printint>
        i += 1;
 8a2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 8a4:	8ba6                	mv	s7,s1
      state = 0;
 8a6:	4981                	li	s3,0
 8a8:	bdd5                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 1);
 8aa:	008b8493          	addi	s1,s7,8
 8ae:	4685                	li	a3,1
 8b0:	4629                	li	a2,10
 8b2:	000bb583          	ld	a1,0(s7)
 8b6:	855a                	mv	a0,s6
 8b8:	e01ff0ef          	jal	6b8 <printint>
        i += 2;
 8bc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 8be:	8ba6                	mv	s7,s1
      state = 0;
 8c0:	4981                	li	s3,0
        i += 2;
 8c2:	bde9                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 8c4:	008b8493          	addi	s1,s7,8
 8c8:	4681                	li	a3,0
 8ca:	4629                	li	a2,10
 8cc:	000be583          	lwu	a1,0(s7)
 8d0:	855a                	mv	a0,s6
 8d2:	de7ff0ef          	jal	6b8 <printint>
 8d6:	8ba6                	mv	s7,s1
      state = 0;
 8d8:	4981                	li	s3,0
 8da:	b5c9                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8dc:	008b8493          	addi	s1,s7,8
 8e0:	4681                	li	a3,0
 8e2:	4629                	li	a2,10
 8e4:	000bb583          	ld	a1,0(s7)
 8e8:	855a                	mv	a0,s6
 8ea:	dcfff0ef          	jal	6b8 <printint>
        i += 1;
 8ee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f0:	8ba6                	mv	s7,s1
      state = 0;
 8f2:	4981                	li	s3,0
 8f4:	b565                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 8f6:	008b8493          	addi	s1,s7,8
 8fa:	4681                	li	a3,0
 8fc:	4629                	li	a2,10
 8fe:	000bb583          	ld	a1,0(s7)
 902:	855a                	mv	a0,s6
 904:	db5ff0ef          	jal	6b8 <printint>
        i += 2;
 908:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 90a:	8ba6                	mv	s7,s1
      state = 0;
 90c:	4981                	li	s3,0
        i += 2;
 90e:	b579                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 910:	008b8493          	addi	s1,s7,8
 914:	4681                	li	a3,0
 916:	4641                	li	a2,16
 918:	000be583          	lwu	a1,0(s7)
 91c:	855a                	mv	a0,s6
 91e:	d9bff0ef          	jal	6b8 <printint>
 922:	8ba6                	mv	s7,s1
      state = 0;
 924:	4981                	li	s3,0
 926:	bd9d                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 928:	008b8493          	addi	s1,s7,8
 92c:	4681                	li	a3,0
 92e:	4641                	li	a2,16
 930:	000bb583          	ld	a1,0(s7)
 934:	855a                	mv	a0,s6
 936:	d83ff0ef          	jal	6b8 <printint>
        i += 1;
 93a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 93c:	8ba6                	mv	s7,s1
      state = 0;
 93e:	4981                	li	s3,0
 940:	bdb1                	j	79c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 942:	008b8493          	addi	s1,s7,8
 946:	4641                	li	a2,16
 948:	000bb583          	ld	a1,0(s7)
 94c:	855a                	mv	a0,s6
 94e:	d6bff0ef          	jal	6b8 <printint>
        i += 2;
 952:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 954:	8ba6                	mv	s7,s1
      state = 0;
 956:	4981                	li	s3,0
        i += 2;
 958:	b591                	j	79c <vprintf+0x44>
 95a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 95c:	008b8793          	addi	a5,s7,8
 960:	8cbe                	mv	s9,a5
 962:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 966:	03000593          	li	a1,48
 96a:	855a                	mv	a0,s6
 96c:	d2fff0ef          	jal	69a <putc>
  putc(fd, 'x');
 970:	07800593          	li	a1,120
 974:	855a                	mv	a0,s6
 976:	d25ff0ef          	jal	69a <putc>
 97a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 97c:	00001b97          	auipc	s7,0x1
 980:	9b4b8b93          	addi	s7,s7,-1612 # 1330 <digits>
 984:	03c9d793          	srli	a5,s3,0x3c
 988:	97de                	add	a5,a5,s7
 98a:	0007c583          	lbu	a1,0(a5)
 98e:	855a                	mv	a0,s6
 990:	d0bff0ef          	jal	69a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 994:	0992                	slli	s3,s3,0x4
 996:	34fd                	addiw	s1,s1,-1
 998:	f4f5                	bnez	s1,984 <vprintf+0x22c>
        printptr(fd, va_arg(ap, uint64));
 99a:	8be6                	mv	s7,s9
      state = 0;
 99c:	4981                	li	s3,0
 99e:	6ca2                	ld	s9,8(sp)
 9a0:	bbf5                	j	79c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 9a2:	008b8493          	addi	s1,s7,8
 9a6:	000bc583          	lbu	a1,0(s7)
 9aa:	855a                	mv	a0,s6
 9ac:	cefff0ef          	jal	69a <putc>
 9b0:	8ba6                	mv	s7,s1
      state = 0;
 9b2:	4981                	li	s3,0
 9b4:	b3e5                	j	79c <vprintf+0x44>
        if ((s = va_arg(ap, char *)) == 0)
 9b6:	008b8993          	addi	s3,s7,8
 9ba:	000bb483          	ld	s1,0(s7)
 9be:	cc91                	beqz	s1,9da <vprintf+0x282>
        for (; *s; s++)
 9c0:	0004c583          	lbu	a1,0(s1)
 9c4:	c195                	beqz	a1,9e8 <vprintf+0x290>
          putc(fd, *s);
 9c6:	855a                	mv	a0,s6
 9c8:	cd3ff0ef          	jal	69a <putc>
        for (; *s; s++)
 9cc:	0485                	addi	s1,s1,1
 9ce:	0004c583          	lbu	a1,0(s1)
 9d2:	f9f5                	bnez	a1,9c6 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 9d4:	8bce                	mv	s7,s3
      state = 0;
 9d6:	4981                	li	s3,0
 9d8:	b3d1                	j	79c <vprintf+0x44>
          s = "(null)";
 9da:	00001497          	auipc	s1,0x1
 9de:	94e48493          	addi	s1,s1,-1714 # 1328 <malloc+0x81c>
        for (; *s; s++)
 9e2:	02800593          	li	a1,40
 9e6:	b7c5                	j	9c6 <vprintf+0x26e>
        if ((s = va_arg(ap, char *)) == 0)
 9e8:	8bce                	mv	s7,s3
      state = 0;
 9ea:	4981                	li	s3,0
 9ec:	bb45                	j	79c <vprintf+0x44>
        putc(fd, '%');
 9ee:	85be                	mv	a1,a5
 9f0:	855a                	mv	a0,s6
 9f2:	ca9ff0ef          	jal	69a <putc>
 9f6:	bdbd                	j	874 <vprintf+0x11c>
 9f8:	6906                	ld	s2,64(sp)
 9fa:	79e2                	ld	s3,56(sp)
 9fc:	7a42                	ld	s4,48(sp)
 9fe:	7aa2                	ld	s5,40(sp)
 a00:	7b02                	ld	s6,32(sp)
 a02:	6be2                	ld	s7,24(sp)
 a04:	6c42                	ld	s8,16(sp)
    }
  }
}
 a06:	60e6                	ld	ra,88(sp)
 a08:	6446                	ld	s0,80(sp)
 a0a:	64a6                	ld	s1,72(sp)
 a0c:	6125                	addi	sp,sp,96
 a0e:	8082                	ret
      if (c0 == 'd') {
 a10:	06400713          	li	a4,100
 a14:	e6e782e3          	beq	a5,a4,878 <vprintf+0x120>
      } else if (c0 == 'l' && c1 == 'd') {
 a18:	f9478693          	addi	a3,a5,-108
 a1c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 a20:	8532                	mv	a0,a2
      } else if (c0 == 'l' && c1 == 'l' && c2 == 'd') {
 a22:	4701                	li	a4,0
 a24:	bbe9                	j	7fe <vprintf+0xa6>

0000000000000a26 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 a26:	715d                	addi	sp,sp,-80
 a28:	ec06                	sd	ra,24(sp)
 a2a:	e822                	sd	s0,16(sp)
 a2c:	1000                	addi	s0,sp,32
 a2e:	e010                	sd	a2,0(s0)
 a30:	e414                	sd	a3,8(s0)
 a32:	e818                	sd	a4,16(s0)
 a34:	ec1c                	sd	a5,24(s0)
 a36:	03043023          	sd	a6,32(s0)
 a3a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 a3e:	8622                	mv	a2,s0
 a40:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 a44:	d15ff0ef          	jal	758 <vprintf>
}
 a48:	60e2                	ld	ra,24(sp)
 a4a:	6442                	ld	s0,16(sp)
 a4c:	6161                	addi	sp,sp,80
 a4e:	8082                	ret

0000000000000a50 <printf>:

void
printf(const char *fmt, ...)
{
 a50:	711d                	addi	sp,sp,-96
 a52:	ec06                	sd	ra,24(sp)
 a54:	e822                	sd	s0,16(sp)
 a56:	1000                	addi	s0,sp,32
 a58:	e40c                	sd	a1,8(s0)
 a5a:	e810                	sd	a2,16(s0)
 a5c:	ec14                	sd	a3,24(s0)
 a5e:	f018                	sd	a4,32(s0)
 a60:	f41c                	sd	a5,40(s0)
 a62:	03043823          	sd	a6,48(s0)
 a66:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 a6a:	00840613          	addi	a2,s0,8
 a6e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 a72:	85aa                	mv	a1,a0
 a74:	4505                	li	a0,1
 a76:	ce3ff0ef          	jal	758 <vprintf>
}
 a7a:	60e2                	ld	ra,24(sp)
 a7c:	6442                	ld	s0,16(sp)
 a7e:	6125                	addi	sp,sp,96
 a80:	8082                	ret

0000000000000a82 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 a82:	1141                	addi	sp,sp,-16
 a84:	e406                	sd	ra,8(sp)
 a86:	e022                	sd	s0,0(sp)
 a88:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header *)ap - 1;
 a8a:	ff050713          	addi	a4,a0,-16
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a8e:	00001797          	auipc	a5,0x1
 a92:	5727b783          	ld	a5,1394(a5) # 2000 <freep>
 a96:	a095                	j	afa <free+0x78>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if (bp + bp->s.size == p->s.ptr) {
 a98:	ff852583          	lw	a1,-8(a0)
 a9c:	6390                	ld	a2,0(a5)
 a9e:	02059813          	slli	a6,a1,0x20
 aa2:	01c85693          	srli	a3,a6,0x1c
 aa6:	96ba                	add	a3,a3,a4
 aa8:	02d60563          	beq	a2,a3,ad2 <free+0x50>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 aac:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if (p + p->s.size == bp) {
 ab0:	4790                	lw	a2,8(a5)
 ab2:	02061593          	slli	a1,a2,0x20
 ab6:	01c5d693          	srli	a3,a1,0x1c
 aba:	96be                	add	a3,a3,a5
 abc:	02d70263          	beq	a4,a3,ae0 <free+0x5e>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 ac0:	e398                	sd	a4,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 ac2:	00001717          	auipc	a4,0x1
 ac6:	52f73f23          	sd	a5,1342(a4) # 2000 <freep>
}
 aca:	60a2                	ld	ra,8(sp)
 acc:	6402                	ld	s0,0(sp)
 ace:	0141                	addi	sp,sp,16
 ad0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 ad2:	4614                	lw	a3,8(a2)
 ad4:	9ead                	addw	a3,a3,a1
 ad6:	fed52c23          	sw	a3,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 ada:	6394                	ld	a3,0(a5)
 adc:	6290                	ld	a2,0(a3)
 ade:	b7f9                	j	aac <free+0x2a>
    p->s.size += bp->s.size;
 ae0:	ff852703          	lw	a4,-8(a0)
 ae4:	9f31                	addw	a4,a4,a2
 ae6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 ae8:	ff053703          	ld	a4,-16(a0)
 aec:	bfd1                	j	ac0 <free+0x3e>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 aee:	6394                	ld	a3,0(a5)
 af0:	00d7e463          	bltu	a5,a3,af8 <free+0x76>
 af4:	fad762e3          	bltu	a4,a3,a98 <free+0x16>
 af8:	87b6                	mv	a5,a3
  for (p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 afa:	fee7fae3          	bgeu	a5,a4,aee <free+0x6c>
 afe:	6394                	ld	a3,0(a5)
 b00:	f8d76ce3          	bltu	a4,a3,a98 <free+0x16>
    if (p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 b04:	f8d7fae3          	bgeu	a5,a3,a98 <free+0x16>
 b08:	87b6                	mv	a5,a3
 b0a:	bfc5                	j	afa <free+0x78>

0000000000000b0c <malloc>:
  return freep;
}

void *
malloc(uint nbytes)
{
 b0c:	7139                	addi	sp,sp,-64
 b0e:	fc06                	sd	ra,56(sp)
 b10:	f822                	sd	s0,48(sp)
 b12:	f04a                	sd	s2,32(sp)
 b14:	ec4e                	sd	s3,24(sp)
 b16:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1) / sizeof(Header) + 1;
 b18:	02051993          	slli	s3,a0,0x20
 b1c:	0209d993          	srli	s3,s3,0x20
 b20:	09bd                	addi	s3,s3,15
 b22:	0049d993          	srli	s3,s3,0x4
 b26:	2985                	addiw	s3,s3,1
 b28:	894e                	mv	s2,s3
  if ((prevp = freep) == 0) {
 b2a:	00001517          	auipc	a0,0x1
 b2e:	4d653503          	ld	a0,1238(a0) # 2000 <freep>
 b32:	c905                	beqz	a0,b62 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b34:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b36:	4798                	lw	a4,8(a5)
 b38:	09377663          	bgeu	a4,s3,bc4 <malloc+0xb8>
 b3c:	f426                	sd	s1,40(sp)
 b3e:	e852                	sd	s4,16(sp)
 b40:	e456                	sd	s5,8(sp)
 b42:	e05a                	sd	s6,0(sp)
  if (nu < 4096)
 b44:	8a4e                	mv	s4,s3
 b46:	6705                	lui	a4,0x1
 b48:	00e9f363          	bgeu	s3,a4,b4e <malloc+0x42>
 b4c:	6a05                	lui	s4,0x1
 b4e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 b52:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void *)(p + 1);
    }
    if (p == freep)
 b56:	00001497          	auipc	s1,0x1
 b5a:	4aa48493          	addi	s1,s1,1194 # 2000 <freep>
  if (p == SBRK_ERROR)
 b5e:	5afd                	li	s5,-1
 b60:	a83d                	j	b9e <malloc+0x92>
 b62:	f426                	sd	s1,40(sp)
 b64:	e852                	sd	s4,16(sp)
 b66:	e456                	sd	s5,8(sp)
 b68:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 b6a:	00001797          	auipc	a5,0x1
 b6e:	4a678793          	addi	a5,a5,1190 # 2010 <base>
 b72:	00001717          	auipc	a4,0x1
 b76:	48f73723          	sd	a5,1166(a4) # 2000 <freep>
 b7a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 b7c:	0007a423          	sw	zero,8(a5)
    if (p->s.size >= nunits) {
 b80:	b7d1                	j	b44 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 b82:	6398                	ld	a4,0(a5)
 b84:	e118                	sd	a4,0(a0)
 b86:	a899                	j	bdc <malloc+0xd0>
  hp->s.size = nu;
 b88:	01652423          	sw	s6,8(a0)
  free((void *)(hp + 1));
 b8c:	0541                	addi	a0,a0,16
 b8e:	ef5ff0ef          	jal	a82 <free>
  return freep;
 b92:	6088                	ld	a0,0(s1)
      if ((p = morecore(nunits)) == 0)
 b94:	c125                	beqz	a0,bf4 <malloc+0xe8>
  for (p = prevp->s.ptr;; prevp = p, p = p->s.ptr) {
 b96:	611c                	ld	a5,0(a0)
    if (p->s.size >= nunits) {
 b98:	4798                	lw	a4,8(a5)
 b9a:	03277163          	bgeu	a4,s2,bbc <malloc+0xb0>
    if (p == freep)
 b9e:	6098                	ld	a4,0(s1)
 ba0:	853e                	mv	a0,a5
 ba2:	fef71ae3          	bne	a4,a5,b96 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ba6:	8552                	mv	a0,s4
 ba8:	9f7ff0ef          	jal	59e <sbrk>
  if (p == SBRK_ERROR)
 bac:	fd551ee3          	bne	a0,s5,b88 <malloc+0x7c>
        return 0;
 bb0:	4501                	li	a0,0
 bb2:	74a2                	ld	s1,40(sp)
 bb4:	6a42                	ld	s4,16(sp)
 bb6:	6aa2                	ld	s5,8(sp)
 bb8:	6b02                	ld	s6,0(sp)
 bba:	a03d                	j	be8 <malloc+0xdc>
 bbc:	74a2                	ld	s1,40(sp)
 bbe:	6a42                	ld	s4,16(sp)
 bc0:	6aa2                	ld	s5,8(sp)
 bc2:	6b02                	ld	s6,0(sp)
      if (p->s.size == nunits)
 bc4:	fae90fe3          	beq	s2,a4,b82 <malloc+0x76>
        p->s.size -= nunits;
 bc8:	4137073b          	subw	a4,a4,s3
 bcc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 bce:	02071693          	slli	a3,a4,0x20
 bd2:	01c6d713          	srli	a4,a3,0x1c
 bd6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 bd8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 bdc:	00001717          	auipc	a4,0x1
 be0:	42a73223          	sd	a0,1060(a4) # 2000 <freep>
      return (void *)(p + 1);
 be4:	01078513          	addi	a0,a5,16
  }
}
 be8:	70e2                	ld	ra,56(sp)
 bea:	7442                	ld	s0,48(sp)
 bec:	7902                	ld	s2,32(sp)
 bee:	69e2                	ld	s3,24(sp)
 bf0:	6121                	addi	sp,sp,64
 bf2:	8082                	ret
 bf4:	74a2                	ld	s1,40(sp)
 bf6:	6a42                	ld	s4,16(sp)
 bf8:	6aa2                	ld	s5,8(sp)
 bfa:	6b02                	ld	s6,0(sp)
 bfc:	b7f5                	j	be8 <malloc+0xdc>
