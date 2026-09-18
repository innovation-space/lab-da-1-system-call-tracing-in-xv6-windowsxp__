# xv6 Multiprocessor Concurrency & Spinlock Synchronization Manual
## Live Demonstration of Race Conditions on Shared Kernel Data Structures and Mutual Exclusion Elimination using xv6 Spinlocks on RISC-V SMP

---

### Document & Team Metadata

| Field | Detail |
| :--- | :--- |
| **Project Title** | Multiprocessor Race Condition Demonstration & Spinlock Elimination in xv6-riscv |
| **Operating System** | xv6 (RISC-V 64-bit Architecture, SMP `CPUS=2` / `CPUS=3`) |
| **Hardware Emulation** | QEMU Virt Platform (`qemu-system-riscv64`) |
| **Team Name** | **WindowsXP** |
| **Course / Lab** | Operating Systems Lab — Concurrency & Synchronization DA |

#### Presenter Roster & Assigned Technical Modules

| Order | Presenter Name | Registration No. | Core Presentation Scope |
| :---: | :--- | :---: | :--- |
| **1st** | **Tejas Deshpande** | `24BKT0145` | **Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race** |
| **2nd** | **Vidit Agrawal** | `24BKT0139` | **xv6 Spinlock Internals, RISC-V Hardware Atomics (`amoswap.w.aq`), Memory Fences & GDB Hardware Step-Through** |
| **3rd** | **Devarsh Patel** | `24BCT0267` | **Nested Interrupt Invariants (`push_off`/`pop_off`), Complete Race Elimination, Benchmark Verification & Grand Finale** |

---

## Executive Summary & System Architecture

In symmetric multiprocessing (SMP) operating systems, multiple hardware CPU cores simultaneously execute kernel threads accessing shared memory addresses. Without synchronization, concurrent read-modify-write operations on shared kernel data structures exhibit non-deterministic interleaving, resulting in **race conditions** and silent **lost updates**.

This laboratory demonstration implements:
1. A shared kernel resource (`struct shared_resource`) consisting of an integer counter, an operation audit register, and a dedicated xv6 `struct spinlock`.
2. An unprotected kernel execution pathway (`race_increment(iters, 0)`) demonstrating concurrent execution collisions under SMP (`CPUS=2`).
3. A synchronized kernel execution pathway (`race_increment(iters, 1)`) employing xv6's native `acquire()` and `release()` spinlock primitives.
4. Three system calls (`SYS_race_inc`, `SYS_race_get`, `SYS_race_reset`) exposing control to user-space benchmark processes.
5. A user-space benchmarking suite (`user/racetest.c`) demonstrating reproducible data loss in unlocked mode (up to 75% lost updates) and perfect 100% data integrity under spinlock mutual exclusion.
6. Direct machine-level assembly verification using RISC-V hardware atomics (`amoswap.w.aq`), hardware memory barriers (`fence rw,w`), and interrupt disablement state tracking (`push_off`/`pop_off`).

```
+--------------------------------------------------------------------------------------------------+
|                                    USER SPACE (racetest)                                         |
|                                                                                                  |
|   Child Process 1 (PID 4)   Child Process 2 (PID 5)   Child Process 3 (PID 6)   Child Process 4  |
|      race_inc(1000, 0)         race_inc(1000, 0)         race_inc(1000, 0)      race_inc(1000, 0)|
+-------------+-------------------------+-------------------------+-----------------------+--------+
              |                         |                         |                       |
              | ecall (SYS_race_inc)    | ecall (SYS_race_inc)    | ecall (SYS_race_inc)  | ecall
              v                         v                         v                       v
+--------------------------------------------------------------------------------------------------+
|                                    KERNEL SPACE (xv6-riscv)                                      |
|                                                                                                  |
|   +---------------------------------------+     +--------------------------------------------+   |
|   |         CPU 0 (Hart 0)                |     |              CPU 1 (Hart 1)                |   |
|   |   Reads counter = 100                 |     |   Reads counter = 100 (STALE READ!)        |   |
|   |   Interleaved delay / preemption      |     |   Computes 100 + 1 = 101                   |   |
|   |   Computes 100 + 1 = 101              |     |   Stores counter = 101                     |   |
|   |   Stores counter = 101 (OVERWRITE!)   |     |   CPU 1 update is OVERWRITTEN and LOST!    |   |
|   +---------------------------------------+     +--------------------------------------------+   |
|                                                  |                                               |
|                      ============================+============================                   |
|                                                  v                                               |
|                             SHARED KERNEL MEMORY: struct shared_resource                         |
|                             +----------------------------------------------+                     |
|                             | struct spinlock lock  (24 bytes)             |                     |
|                             | volatile int counter  (4 bytes, offset 24)   |                     |
|                             | volatile int total_ops(4 bytes, offset 28)   |                     |
|                             +----------------------------------------------+                     |
|                                                                                                  |
|   WITH SPINLOCK MUTUAL EXCLUSION:                                                                |
|   CPU 0 executes: acquire(&shared_res.lock) -> amoswap.w.aq succeeds -> CPU 0 enters CS          |
|   CPU 1 executes: acquire(&shared_res.lock) -> amoswap.w.aq returns 1 -> CPU 1 SPINS in loop    |
|   CPU 0 finishes: release(&shared_res.lock) -> fence rw,w -> sw zero -> CPU 1 acquires lock     |
|   Result: 100% updates serialized, ZERO lost updates, 100% data integrity guaranteed!           |
+--------------------------------------------------------------------------------------------------+
```

---

## Detailed Presenter Modules & Spoken Scripts

---

### PRESENTER 1: Tejas Deshpande (`24BKT0145`)
#### Topic: Concurrency Foundations, Multiprocessor Race Windows & Ground Zero Live Unlocked Race

#### Spoken Presentation Script

> "Good morning, respected professors and evaluators. I am **Tejas Deshpande**, registration number **24BKT0145**, representing team **WindowsXP**.
>
> Today, my teammates Vidit, Devarsh, and I will be dissecting one of the most critical and treacherous problems in operating systems engineering: **multiprocessor race conditions on shared kernel data structures**, and the mathematical mechanics of **mutual exclusion using xv6 spinlocks**.
>
> To begin, let us define what a race condition truly is at the hardware level. When an operating system runs on symmetric multiprocessing hardware—such as our xv6 kernel running on multiple RISC-V cores in QEMU—multiple CPUs execute kernel code simultaneously.
>
> If two CPUs attempt to modify the same kernel variable concurrently without synchronization, the correctness of the system becomes dependent on the micro-architectural timing of instruction execution. That is a **race condition**.
>
> Consider a seemingly trivial operation in C:
> ```c
> shared_res.counter++;
> ```
> To a high-level programmer, this looks like a single step. But at the machine level, the compiler generates three separate instructions:
> 1. A **Load Word** (`lw`) instruction to read the value from memory into a CPU register.
> 2. An **Add Immediate Word** (`addiw`) instruction to increment the register.
> 3. A **Store Word** (`sw`) instruction to write the result back to physical memory.
>
> When CPU 0 and CPU 1 execute this sequence concurrently without locks, both cores read the identical initial value—say, 100—before either core writes back the increment. CPU 0 adds 1 and stores 101. CPU 1 also adds 1 and stores 101. Two increments occurred, but the counter only increased by 1! One of those operations has vanished into thin air. In operating systems, this is known as a **Lost Update**.
>
> To demonstrate this live on real kernel memory, our team built `kernel/race.c` inside the xv6 kernel. We defined a shared kernel structure:
> ```c
> struct shared_resource {
>   struct spinlock lock;
>   volatile int counter;
>   volatile int total_ops;
> };
> ```
> We exposed this shared resource to user space via three custom system calls: `SYS_race_inc`, `SYS_race_get`, and `SYS_race_reset`.
>
> In our unlocked test, multiple concurrent child processes call `race_inc()` without acquiring the lock. Let us observe the live execution right now on an SMP xv6 instance running with 2 CPUs."

#### Live Terminal Demonstration Commands & Live Outputs

##### Step 1: Launch xv6 in QEMU with SMP (`CPUS=2`)
```bash
make qemu CPUS=2
```
*Console Boot Output:*
```text
xv6 kernel is booting

hart 1 starting
init: starting sh
$ 
```

##### Step 2: Execute Unlocked Race Demonstration
```bash
$ racetest unlocked
```
*Exact Live System Output:*
```text
############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 1000
  >> Lost Updates    : 3000 (75% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 3000 lost updates.
============================================================
$ 
```

##### Step 3: Parametric Verification with Varying Process Counts
```bash
$ racetest 2 500 0
```
*Exact Live System Output:*
```text
############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 2 child processes x 500 iterations
Expected Counter Result: 1000
------------------------------------------------------------
Spawning 2 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 1000
  >> Actual Counter  : 500
  >> Lost Updates    : 500 (50% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 500 lost updates.
============================================================
$ 
```

#### Under-the-Hood Technical Breakdown (Presenter 1)

> "Look at the terminal output on the screen.
>
> In our 4-process benchmark, each of the four children executed 1,000 increments in kernel space. We mathematically expect a final counter value of **4,000**.
>
> But the actual counter reading is only **1,000**! That means **3,000 increments were completely lost—a staggering 75% data loss!**
>
> In our 2-process trial, 2 children each ran 500 increments, expecting 1,000. The actual result was 500—exactly **500 lost updates (50% data loss)**!
>
> Why did this happen? Because in `kernel/race.c`, when `use_lock == 0`:
> ```c
> volatile int temp = shared_res.counter;
> if ((i % 5) == 0) {
>   yield();
> } else {
>   for (volatile int d = 0; d < 30; d++) ;
> }
> shared_res.counter = temp + 1;
> ```
> Process 1 reads `temp = shared_res.counter`. During the race window, a timer interrupt occurs or the process yields, allowing Process 2 on the same or another CPU core to run. Process 2 reads the identical stale counter, performs its increments, and commits them to memory.
>
> When Process 1 is rescheduled, it blindly overwrites `shared_res.counter` with `temp + 1`, completely obliterating everything Process 2 just wrote!
>
> If this were a kernel process table, an inode allocation bitmap, or a physical page free list, this silent corruption would lead to kernel panics, double-free vulnerabilities, or disk corruption.
>
> How does an operating system stop this? By enforcing **Mutual Exclusion**—guaranteeing that only one CPU can ever enter the critical section at a time.
>
> To show how xv6 implements this at the silicon level using RISC-V hardware atomic instructions, I will now hand over to **Vidit Agrawal**."

---

### PRESENTER 2: Vidit Agrawal (`24BKT0139`)
#### Topic: xv6 Spinlock Internals, RISC-V Hardware Atomics (`amoswap.w.aq`), Memory Fences & GDB Hardware Step-Through

#### Spoken Presentation Script

> "Thank you, Tejas. Respected evaluators, I am **Vidit Agrawal**, registration number **24BKT0139**.
>
> As Tejas demonstrated, software-level checks alone cannot prevent race conditions because any check-and-set sequence itself can be interrupted. We need a fundamental hardware guarantee: **atomicity**.
>
> In xv6, the primary synchronization primitive for short critical sections is the **spinlock**, represented by `struct spinlock` defined in `kernel/spinlock.h`:
> ```c
> struct spinlock {
>   uint locked;       // Is the lock held? (0 = free, 1 = held)
>   char *name;        // Name of lock for debugging
>   struct cpu *cpu;   // The CPU that currently holds the lock
> };
> ```
> Let us inspect the exact memory layout of this struct. Using GDB, we can run `ptype /o struct shared_resource` directly on the compiled kernel binary:
> ```text
> /* offset | size */ type = struct shared_resource {
> /*   0    |  24  */    struct spinlock {
> /*   0    |   4  */        uint locked;
> /* XXX 4-byte hole */
> /*   8    |   8  */        char *name;
> /*  16    |   8  */        struct cpu *cpu;
>                        } lock;
> /*  24    |   4  */    volatile int counter;
> /*  28    |   4  */    volatile int total_ops;
>                        /* total size: 32 bytes */
> }
> ```
> Notice the 4-byte padding hole between `locked` and `name`! Because RISC-V 64-bit pointers must be 8-byte aligned, the compiler pads 4 bytes after `uint locked`. The entire `struct spinlock` occupies 24 bytes, and our `struct shared_resource` occupies 32 bytes.
>
> Now, how does `acquire()` actually claim this lock? Let us look at `kernel/spinlock.c`:
> ```c
> void acquire(struct spinlock *lk) {
>   push_off(); // disable interrupts to avoid deadlock
>   if(holding(lk))
>     panic("acquire");
>   while(__atomic_exchange_n(&lk->locked, 1, __ATOMIC_ACQUIRE) != 0)
>     ;
>   __sync_synchronize();
>   lk->cpu = mycpu();
> }
> ```
> The heart of this function is the GCC intrinsic `__atomic_exchange_n`. When compiled for RISC-V, what instruction does this produce?
>
> It emits **`amoswap.w.aq`**—Atomic Memory Operation: Swap Word with Acquire Semantics!
>
> Let us look at the disassembled assembly from our compiled xv6 kernel:
> ```assembly
> 0x80000c2e <acquire+22>:  li           a4, 1
> 0x80000c30 <acquire+24>:  bnez         a0, panic
> 0x80000c32 <acquire+26>:  amoswap.w.aq a5, a4, (s1)
> 0x80000c36 <acquire+30>:  bnez         a5, 0x80000c32 <acquire+26>
> ```
> Let us walk through this instruction line by line:
> 1. Register `a4` is loaded with immediate value `1`.
> 2. `s1` contains the 64-bit memory address of `lk->locked`.
> 3. `amoswap.w.aq a5, a4, (s1)` executes as a **single indivisible hardware bus cycle**. It writes `1` from `a4` into memory at `(s1)`, and loads the *previous* value from memory into `a5`.
> 4. If the lock was free (previous value was `0`), `a5` receives `0`. The branch instruction `bnez a5` evaluates to FALSE, so the CPU exits the loop! The core now holds the lock.
> 5. If another CPU already held the lock (value was `1`), `a5` receives `1`. The branch instruction `bnez a5` evaluates to TRUE, jumping right back to `0x80000c32`. The CPU continuously loops—it **spins**—until the holding core releases it!
>
> Crucially, note the **`.aq`** suffix! In the RISC-V memory model, `.aq` stands for **Acquire Semantics**. It guarantees that the processor and memory bus cannot reorder any subsequent reads or writes to precede this atomic instruction. All critical section operations stay strictly inside the locked region!
>
> Now, how does `release()` work? Let us view its assembly:
> ```assembly
> 0x80000cae <release+18>:  sd         zero, 16(s1)   # lk->cpu = 0
> 0x80000cb2 <release+22>:  fence      rw, w          # Memory Barrier!
> 0x80000cb6 <release+26>:  sw         zero, 0(s1)    # lk->locked = 0
> 0x80000cba <release+30>:  jal        pop_off        # Re-enable interrupts
> ```
> Notice instruction `0x80000cb2`: **`fence rw,w`**!
> This is a hardware memory barrier. It forces all pending memory reads and writes performed inside the critical section to be globally committed to RAM and cache coherency before the store word instruction (`sw zero, 0(s1)`) clears the lock bit. Without this fence, another CPU could observe the released lock before the data updates were committed, reintroducing race conditions!
>
> Let us verify these exact assembly instructions live inside GDB right now."

#### Live Terminal Demonstration Commands & Live Outputs

##### Step 1: Disassemble `acquire` using RISC-V GDB
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "disassemble acquire"
```
*Exact Live System Output:*
```text
Dump of assembler code for function acquire:
   0x0000000080000c18 <+0>:	addi	sp,sp,-32
   0x0000000080000c1a <+2>:	sd	ra,24(sp)
   0x0000000080000c1c <+4>:	sd	s0,16(sp)
   0x0000000080000c1e <+6>:	sd	s1,8(sp)
   0x0000000080000c20 <+8>:	addi	s0,sp,32
   0x0000000080000c22 <+10>:	mv	s1,a0
   0x0000000080000c24 <+12>:	jal	0x80000bde <push_off>
   0x0000000080000c28 <+16>:	mv	a0,s1
   0x0000000080000c2a <+18>:	jal	0x80000bb2 <holding>
   0x0000000080000c2e <+22>:	li	a4,1
   0x0000000080000c30 <+24>:	bnez	a0,0x80000c48 <acquire+48>
   0x0000000080000c32 <+26>:	amoswap.w.aq	a5,a4,(s1)
   0x0000000080000c36 <+30>:	bnez	a5,0x80000c32 <acquire+26>
   0x0000000080000c38 <+32>:	jal	0x800018be <mycpu>
   0x0000000080000c3c <+36>:	sd	a0,16(s1)
   0x0000000080000c3e <+38>:	ld	ra,24(sp)
   0x0000000080000c40 <+40>:	ld	s0,16(sp)
   0x0000000080000c42 <+42>:	ld	s1,8(sp)
   0x0000000080000c44 <+44>:	addi	sp,sp,32
   0x0000000080000c46 <+46>:	ret
   0x0000000080000c48 <+48>:	auipc	a0,0x6
   0x0000000080000c4c <+52>:	addi	a0,a0,1024 # 0x80007048
   0x0000000080000c50 <+56>:	jal	0x8000083a <panic>
End of assembler dump.
```

##### Step 2: Disassemble `release` using RISC-V GDB
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "disassemble release"
```
*Exact Live System Output:*
```text
Dump of assembler code for function release:
   0x0000000080000c9c <+0>:	addi	sp,sp,-32
   0x0000000080000c9e <+2>:	sd	ra,24(sp)
   0x0000000080000ca0 <+4>:	sd	s0,16(sp)
   0x0000000080000ca2 <+6>:	sd	s1,8(sp)
   0x0000000080000ca4 <+8>:	addi	s0,sp,32
   0x0000000080000ca6 <+10>:	mv	s1,a0
   0x0000000080000ca8 <+12>:	jal	0x80000bb2 <holding>
   0x0000000080000cac <+16>:	beqz	a0,0x80000cc8 <release+44>
   0x0000000080000cae <+18>:	sd	zero,16(s1)
   0x0000000080000cb2 <+22>:	fence	rw,w
   0x0000000080000cb6 <+26>:	sw	zero,0(s1)
   0x0000000080000cba <+30>:	jal	0x80000c54 <pop_off>
   0x0000000080000cbe <+34>:	ld	ra,24(sp)
   0x0000000080000cc0 <+36>:	ld	s0,16(sp)
   0x0000000080000cc2 <+38>:	ld	s1,8(sp)
   0x0000000080000cc4 <+40>:	addi	sp,sp,32
   0x0000000080000cc6 <+42>:	ret
   0x0000000080000cc8 <+44>:	auipc	a0,0x6
   0x0000000080000ccc <+48>:	addi	a0,a0,936 # 0x80007070
   0x0000000080000cd0 <+52>:	jal	0x8000083a <panic>
End of assembler dump.
```

##### Step 3: Inspect Struct Memory Offsets & Alignment
```bash
riscv64-elf-gdb -batch -ex "file kernel/kernel" -ex "ptype /o struct shared_resource"
```
*Exact Live System Output:*
```text
/* offset      |    size */  type = struct shared_resource {
/*      0      |      24 */    struct spinlock {
/*      0      |       4 */        uint locked;
/* XXX  4-byte hole      */
/*      8      |       8 */        char *name;
/*     16      |       8 */        struct cpu *cpu;

                                   /* total size (bytes):   24 */
                               } lock;
/*     24      |       4 */    volatile int counter;
/*     28      |       4 */    volatile int total_ops;

                               /* total size (bytes):   32 */
                             }
```

#### Under-the-Hood Technical Breakdown (Presenter 2)

> "As you can see from our live GDB output:
> - At offset `+26` of `acquire`: instruction `amoswap.w.aq a5, a4, (s1)` executes the hardware lock acquisition atomically.
> - At offset `+30`: instruction `bnez a5, 0x80000c32` executes the spin-wait loop.
> - At offset `+36`: instruction `sd a0, 16(s1)` stores the holding CPU pointer into offset 16 of the struct.
> - In `release`, at offset `+22`: instruction `fence rw,w` enforces memory ordering, followed immediately at `+26` by `sw zero, 0(s1)` which clears the lock word.
>
> However, there is an even deeper trap in spinlock design: **what happens if an interrupt fires while a CPU is holding a spinlock?**
>
> If an interrupt handler on the same CPU attempts to acquire the same lock, the CPU will spin forever waiting for itself to release the lock—an unrecoverable **deadlock**!
>
> To explain how xv6 solves this through nested interrupt tracking (`push_off` and `pop_off`), and to present the final benchmark proving 100% mutual exclusion, I pass the floor to **Devarsh Patel**."

---

### PRESENTER 3: Devarsh Patel (`24BCT0267`)
#### Topic: Nested Interrupt Invariants (`push_off`/`pop_off`), Complete Race Elimination, Benchmark Verification & Grand Finale

#### Spoken Presentation Script

> "Thank you, Vidit. Respected professors and examiners, I am **Devarsh Patel**, registration number **24BCT0267**.
>
> To complete our architectural exploration, let us examine the critical interaction between **spinlocks** and **hardware interrupts**.
>
> Why must spinlocks disable interrupts?
> Consider this scenario: CPU 0 acquires a spinlock—for instance, `tickslock` or our `shared_res.lock`. While CPU 0 is executing the critical section, a hardware timer interrupt or device interrupt arrives on CPU 0.
>
> CPU 0 suspends the current thread and jumps to the interrupt handler (`trap.c`). If that interrupt handler also tries to acquire `shared_res.lock`, what happens?
> The lock is already held by CPU 0!
> But CPU 0 cannot continue the original thread to release the lock because it is trapped in the interrupt handler. And the interrupt handler cannot proceed because the lock is held. CPU 0 is waiting for itself! This is a **single-core recursive deadlock**, and the entire operating system freezes instantly.
>
> Therefore, xv6 enforces an absolute operational invariant:
> **Whenever a CPU acquires ANY spinlock, interrupts MUST be disabled on that CPU!**
>
> But simply calling `intr_off()` and `intr_on()` is dangerously flawed. What if a function holding Lock A calls another function that acquires and releases Lock B?
> If releasing Lock B called `intr_on()`, interrupts would be turned back on while Lock A is still held!
>
> To solve this, xv6 maintains a per-CPU interrupt nesting counter:
> In `kernel/proc.h`:
> ```c
> struct cpu {
>   int noff;       // Depth of push_off() nesting
>   int intena;     // Were interrupts enabled before push_off()?
> };
> ```
> In `push_off()`:
> ```c
> void push_off(void) {
>   int old = intr_get();
>   intr_off();
>   if(mycpu()->noff == 0)
>     mycpu()->intena = old;
>   mycpu()->noff += 1;
> }
> ```
> On the first lock acquisition, `noff == 0`. xv6 saves whether interrupts were originally on in `mycpu()->intena`, and then disables interrupts (`intr_off()`). Any nested locks increment `noff`.
>
> In `pop_off()`:
> ```c
> void pop_off(void) {
>   struct cpu *c = mycpu();
>   if(intr_get()) panic("pop_off - interruptible");
>   if(c->noff < 1) panic("pop_off");
>   c->noff -= 1;
>   if(c->noff == 0 && c->intena)
>     intr_on();
> }
> ```
> Only when `noff` decrements back to zero does xv6 restore interrupts to their original state!
>
> Now, let us witness the power of this complete synchronization architecture.
> When we run `racetest locked`, our 4 concurrent child processes execute the exact same 1,000 increments per process, but this time protected by `acquire(&shared_res.lock)` and `release(&shared_res.lock)`.
>
> Let us run the live benchmark."

#### Live Terminal Demonstration Commands & Live Outputs

##### Step 1: Execute Spinlock Synchronized Demonstration
```bash
$ racetest locked
```
*Exact Live System Output:*
```text
############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 4000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
$ 
```

##### Step 2: Run Full Automated Head-to-Head Benchmark Suite
```bash
$ racetest
```
*Exact Live System Output:*
```text
############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

Running automated comprehensive benchmark (4 processes x 1000 ops)...

============================================================
[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)
Protection: NONE (Vulnerable to SMP Race Window)
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 1000
  >> Lost Updates    : 3000 (75% data loss)
------------------------------------------------------------
VERDICT: RACE CONDITION CONFIRMED!
Interleaved memory access on multi-core CPU caused 3000 lost updates.
============================================================

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 4 child processes x 1000 iterations
Expected Counter Result: 4000
------------------------------------------------------------
Spawning 4 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 4000
  >> Actual Counter  : 4000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
$ 
```

##### Step 3: Parametric Synchronized Test with 2 Processes
```bash
$ racetest 2 500 1
```
*Exact Live System Output:*
```text
############################################################
#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #
#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #
############################################################

============================================================
[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)
Protection: Mutual Exclusion ENABLED
Configuration: 2 child processes x 500 iterations
Expected Counter Result: 1000
------------------------------------------------------------
Spawning 2 concurrent processes across CPUs...
Execution Complete. Reading final shared kernel counter...
------------------------------------------------------------
  >> Expected Value  : 1000
  >> Actual Counter  : 1000
  >> Lost Updates    : 0 (0% data loss)
------------------------------------------------------------
VERDICT: PERFECT MUTUAL EXCLUSION!
xv6 Spinlock eliminated race condition. 100% updates preserved.
============================================================
$ 
```

#### Under-the-Hood Technical Breakdown & Grand Finale (Presenter 3)

> "Look at the synchronized test results!
>
> In the exact same multiprocessor environment (`CPUS=2`) with 4 concurrent child processes executing simultaneously:
> - **Expected Value**: 4,000
> - **Actual Counter**: **4,000**
> - **Lost Updates**: **0 (0% data loss!)**
>
> When run head-to-head in our automated test suite:
> In unlocked mode, we suffered **3,000 lost updates (75% corruption)**.
> In spinlock-protected mode, we achieved **100.0% data integrity with ZERO lost updates**!
>
> Every single increment was serialized through the hardware `amoswap.w.aq` atomic instruction, memory fences guaranteed cache consistency, and nested interrupt management (`push_off`/`pop_off`) prevented deadlocks.
>
> To summarize the key lessons of our assessment:
> 1. **Concurrency Bug Mechanics**: Unprotected read-modify-write sequences (`lw`, `addiw`, `sw`) allow race windows where concurrent CPU cores overwrite each other's memory updates.
> 2. **Hardware Primitives**: Software locks require atomic hardware support (`amoswap.w.aq` on RISC-V) and memory ordering fences (`fence rw,w`) to prevent out-of-order execution anomalies.
> 3. **Interrupt Safety Invariant**: Spinlocks must disable interrupts on the holding core using nested tracking (`push_off`/`pop_off`) to eliminate fatal recursive deadlocks.
>
> This concludes our live demonstration. Tejas, Vidit, and I are now fully prepared to take any questions from the evaluators. Thank you!"

---

## Comparative Experimental Results Matrix

| Metric / Parameter | Unlocked Benchmark (Test 1) | Spinlock-Protected Benchmark (Test 2) |
| :--- | :---: | :---: |
| **Concurrency Mode** | Unsynchronized Read-Modify-Write | `acquire(&shared_res.lock)` / `release()` |
| **QEMU Symmetric Multiprocessing** | `CPUS=2` (2 Active Hardware Harts) | `CPUS=2` (2 Active Hardware Harts) |
| **Number of Child Processes** | 4 Concurrent Processes | 4 Concurrent Processes |
| **Iterations per Process** | 1,000 Increments | 1,000 Increments |
| **Expected Final Counter** | **4,000** | **4,000** |
| **Actual Final Counter** | **1,000** | **4,000** |
| **Lost Updates (Data Corruption)** | **3,000 Lost Updates** | **0 Lost Updates** |
| **Percentage Data Loss** | **75.0% Data Loss** | **0.0% (100% Data Integrity)** |
| **Hardware Atomic Instruction** | None (Separate `lw`, `addiw`, `sw`) | `amoswap.w.aq a5, a4, (s1)` |
| **Memory Barrier** | None | `fence rw,w` |
| **Interrupt Handling** | Unprotected | Disabled via `push_off()`, restored via `pop_off()` |
| **Operational Verdict** | **RACE CONDITION DETECTED** | **PERFECT MUTUAL EXCLUSION** |

---

## Exhaustive Viva & Defense Preparation (Examiner Q&A)

### Q1: What is the fundamental difference between a spinlock and a sleeplock in xv6? When should each be used?
**Answer:**
- A **spinlock** keeps the CPU actively executing in a tight polling loop (`while(amoswap...)`) until the lock becomes free. It **disables interrupts** on the local core via `push_off()` and **prohibits yielding or sleeping** (`sched()` explicitly checks `mycpu()->noff == 1;` otherwise it panics). Spinlocks are designed for very short critical sections (e.g. updating process state, manipulating free lists, buffer cache pointers) where holding time is negligible.
- A **sleeplock** (`kernel/sleeplock.c`) puts the calling process to sleep (`sleep()`), yielding the CPU to the scheduler so other processes can execute while waiting. Sleeplocks leave interrupts enabled and are used for long-duration operations involving disk I/O or pipe waits where spinning would waste millions of CPU cycles.

### Q2: Why does xv6 panic if a kernel thread tries to sleep (`sleep()`) or yield (`yield()`) while holding a spinlock?
**Answer:**
If Process A holds a spinlock on CPU 0 and yields or goes to sleep:
1. CPU 0 is switched to Process B.
2. If Process B (or another process on CPU 1) attempts to acquire that same spinlock, it will spin continuously.
3. If Process B is running on CPU 0, Process A cannot run to release the lock because Process B is monopolizing CPU 0 spinning.
4. Even worse, if Process A was holding `p->lock` or a shared subsystem lock, deadlocks propagate across all cores.
To prevent this, xv6's `sched()` asserts:
```c
if(mycpu()->noff != 1) panic("sched locks");
```
(where `noff == 1` accounts only for the scheduler's own `p->lock`).

### Q3: What is the purpose of the `.aq` suffix in `amoswap.w.aq`? What would go wrong without it?
**Answer:**
The `.aq` suffix denotes **Acquire Semantics** in the RISC-V memory consistency model. Modern superscalar out-of-order processors and memory controllers can reorder read and write instructions for performance. Without `.aq`, memory accesses belonging *inside* the critical section could be speculatively fetched or executed *before* the lock is officially acquired, allowing another core to observe or overwrite data concurrently, violating mutual exclusion!

### Q4: Why does `release()` require `fence rw,w` before clearing the lock word?
**Answer:**
`fence rw,w` is a memory barrier instruction. It dictates that all Device and Memory Read and Write operations preceding the fence must be committed and visible to all other CPU cores before the Write operation following the fence (`sw zero, 0(s1)`) is executed. Without this fence, a processor might flush the lock release to memory before the modifications made inside the critical section reach the cache coherency bus. Another CPU acquiring the lock would then read stale data.

### Q5: Can a spinlock be acquired recursively by the same CPU? What happens in xv6?
**Answer:**
No! xv6 spinlocks are **non-recursive**. If a CPU holding lock `lk` attempts to call `acquire(lk)` again, xv6 detects this via `holding(lk)`:
```c
if(holding(lk)) panic("acquire");
```
If this check did not exist, `amoswap.w.aq` would see `lk->locked == 1` and spin forever waiting for the lock to be released, which will never happen because the only core capable of releasing it is stuck spinning!

### Q6: Why does `push_off()` record `intena` only when `noff == 0`?
**Answer:**
When locks are nested:
- Lock 1 is acquired when interrupts might be ON (`intena = 1`). `noff` increments from 0 to 1.
- Lock 2 is acquired. Interrupts are ALREADY off due to Lock 1! `noff` increments from 1 to 2.
If `push_off()` recorded `intena` when `noff == 1`, it would record `intena = 0` (interrupts disabled). Then, when Lock 2 was released, `pop_off()` would see `intena = 0` and fail to restore interrupts when Lock 1 is finally released! Recording only at `noff == 0` preserves the true initial interrupt state of the processor before any locks were taken.

### Q7: Why are spinlocks ineffective on a single-core uniprocessor (`CPUS=1`) without preemption?
**Answer:**
On a single core without preemption, if a thread attempts to acquire a held spinlock, no other thread or core can run to release it. The CPU will spin indefinitely, resulting in a permanent hang. On uniprocessors, mutual exclusion is achieved simply by disabling interrupts (`intr_off()`). Spinlocks are specifically designed for symmetric multiprocessor (SMP) architectures where the lock holder is concurrently executing on a different physical CPU.

---

## Complete Kernel & User Source Code Appendix

### 1. `kernel/race.c`
```c
// kernel/race.c
// Multiprocessor Race Condition & Spinlock Synchronization Demonstration
// Team: WindowsXP

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "proc.h"
#include "defs.h"

// Shared kernel data structure subject to concurrent manipulation
struct shared_resource {
  struct spinlock lock;        // Dedicated xv6 spinlock for mutual exclusion
  volatile int counter;        // Shared integer counter
  volatile int total_ops;      // Audit tracker for completed increments
};

static struct shared_resource shared_res;

// Initialize the shared resource and its spinlock
void
race_init(void)
{
  initlock(&shared_res.lock, "race_counter");
  shared_res.counter = 0;
  shared_res.total_ops = 0;
}

// Reset counter to zero
int
race_reset(void)
{
  acquire(&shared_res.lock);
  shared_res.counter = 0;
  shared_res.total_ops = 0;
  release(&shared_res.lock);
  return 0;
}

// Read current counter value (thread-safe read)
int
race_get_counter(void)
{
  int val;
  acquire(&shared_res.lock);
  val = shared_res.counter;
  release(&shared_res.lock);
  return val;
}

// Execute 'iterations' increments.
// If use_lock == 0: executes unprotected non-atomic read-modify-write.
// If use_lock == 1: protects critical section using acquire() and release().
int
race_increment(int iterations, int use_lock)
{
  for (int i = 0; i < iterations; i++) {
    if (use_lock) {
      // Synchronized critical section using xv6 spinlock
      acquire(&shared_res.lock);

      volatile int temp = shared_res.counter;
      for (volatile int d = 0; d < 30; d++)
        ;
      shared_res.counter = temp + 1;
      shared_res.total_ops++;

      release(&shared_res.lock);
    } else {
      // Unprotected critical section (VULNERABLE TO RACE CONDITIONS)
      // Read shared state into local register
      volatile int temp = shared_res.counter;

      // In unlocked mode, preemption/context-switching or core interleaving
      // during the vulnerable read-modify-write window causes lost updates.
      if ((i % 5) == 0) {
        yield();
      } else {
        for (volatile int d = 0; d < 30; d++)
          ;
      }

      // Overwrite shared state with stale computation -> Lost Update occurs
      shared_res.counter = temp + 1;
      shared_res.total_ops++;
    }
  }
  return 0;
}
```

### 2. `user/racetest.c`
```c
// user/racetest.c
// Multiprocessor Race Condition and Spinlock Verification Utility
// Team: WindowsXP
// Authors: Tejas Deshpande, Vidit Agrawal, Devarsh Patel

#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

static void
run_experiment(int num_children, int iters, int use_lock)
{
  int expected = num_children * iters;

  printf("\n============================================================\n");
  if (use_lock) {
    printf("[SYNCHRONIZED TEST] Mode: xv6 Spinlock (acquire / release)\n");
    printf("Protection: Mutual Exclusion ENABLED\n");
  } else {
    printf("[RACE CONDITION TEST] Mode: Unlocked (Concurrent Read-Modify-Write)\n");
    printf("Protection: NONE (Vulnerable to SMP Race Window)\n");
  }
  printf("Configuration: %d child processes x %d iterations\n", num_children, iters);
  printf("Expected Counter Result: %d\n", expected);
  printf("------------------------------------------------------------\n");

  race_reset();

  printf("Spawning %d concurrent processes across CPUs...\n", num_children);
  for (int i = 0; i < num_children; i++) {
    int pid = fork();
    if (pid < 0) {
      printf("racetest: fork failed on child %d\n", i);
      exit(1);
    }
    if (pid == 0) {
      // Child process: execute kernel increments concurrently
      race_inc(iters, use_lock);
      exit(0);
    }
  }

  // Parent process: await completion of all concurrent children
  for (int i = 0; i < num_children; i++) {
    wait(0);
  }

  int actual = race_get();
  int lost = expected - actual;
  int loss_pct = (expected > 0) ? (lost * 100) / expected : 0;

  printf("Execution Complete. Reading final shared kernel counter...\n");
  printf("------------------------------------------------------------\n");
  printf("  >> Expected Value  : %d\n", expected);
  printf("  >> Actual Counter  : %d\n", actual);
  printf("  >> Lost Updates    : %d (%d%% data loss)\n", lost, loss_pct);
  printf("------------------------------------------------------------\n");

  if (!use_lock) {
    if (lost > 0) {
      printf("VERDICT: RACE CONDITION CONFIRMED!\n");
      printf("Interleaved memory access on multi-core CPU caused %d lost updates.\n", lost);
    } else {
      printf("VERDICT: No lost updates observed in this trial. Increase iterations.\n");
    }
  } else {
    if (actual == expected) {
      printf("VERDICT: PERFECT MUTUAL EXCLUSION!\n");
      printf("xv6 Spinlock eliminated race condition. 100%% updates preserved.\n");
    } else {
      printf("VERDICT: UNEXPECTED DISCREPANCY detected under locking.\n");
    }
  }
  printf("============================================================\n");
}

int
main(int argc, char *argv[])
{
  printf("\n############################################################\n");
  printf("#  xv6 MULTIPROCESSOR RACE CONDITION & SPINLOCK SUITE      #\n");
  printf("#  Team: WindowsXP | Tejas, Vidit, Devarsh                 #\n");
  printf("############################################################\n");

  if (argc == 1) {
    // Automated comparative demonstration: 4 processes x 1000 iterations
    printf("\nRunning automated comprehensive benchmark (4 processes x 1000 ops)...\n");
    run_experiment(4, 1000, 0); // Unlocked Race Condition
    run_experiment(4, 1000, 1); // Spinlock Protected
  } else if (argc == 2 && strcmp(argv[1], "unlocked") == 0) {
    run_experiment(4, 1000, 0);
  } else if (argc == 2 && strcmp(argv[1], "locked") == 0) {
    run_experiment(4, 1000, 1);
  } else if (argc == 4) {
    int children = atoi(argv[1]);
    int iters = atoi(argv[2]);
    int lock = atoi(argv[3]);
    if (children <= 0 || iters <= 0) {
      printf("Usage: racetest [children] [iterations] [0=unlocked, 1=locked]\n");
      exit(1);
    }
    run_experiment(children, iters, lock);
  } else {
    printf("Usage:\n");
    printf("  racetest                       (Run full automated comparison)\n");
    printf("  racetest unlocked              (Run unlocked race test)\n");
    printf("  racetest locked                (Run spinlock protected test)\n");
    printf("  racetest <procs> <iters> <0|1> (Custom benchmark)\n");
    exit(1);
  }

  exit(0);
}
```

### 3. Modifications in Kernel Subsystems
- **`kernel/syscall.h`**:
  ```c
  #define SYS_race_inc   24
  #define SYS_race_get   25
  #define SYS_race_reset 26
  ```
- **`kernel/syscall.c`**:
  Added function pointers and syscall name strings for `SYS_race_inc`, `SYS_race_get`, and `SYS_race_reset`.
- **`kernel/sysproc.c`**:
  ```c
  uint64 sys_race_inc(void) {
    int iters, use_lock;
    argint(0, &iters);
    argint(1, &use_lock);
    return race_increment(iters, use_lock);
  }
  uint64 sys_race_get(void) {
    return race_get_counter();
  }
  uint64 sys_race_reset(void) {
    return race_reset();
  }
  ```
- **`kernel/main.c`**:
  Added `race_init();` inside CPU 0 initialization sequence right after `userinit();`.
- **`user/user.h` & `user/usys.pl`**:
  Added prototypes and assembly stubs for `race_inc`, `race_get`, and `race_reset`.
- **`Makefile`**:
  Added `$K/race.o` to `OBJS` and `$U/_racetest` to `UPROGS`.
