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
