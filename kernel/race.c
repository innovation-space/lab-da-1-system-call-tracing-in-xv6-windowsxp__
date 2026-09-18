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
