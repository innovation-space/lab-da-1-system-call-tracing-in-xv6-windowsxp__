#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  if(argc < 3){
    fprintf(2, "Usage: %s <0|1> <command> [args...]\n", argv[0]);
    exit(1);
  }

  int trace_on = atoi(argv[1]);
  if(trace(trace_on) < 0){
    fprintf(2, "%s: trace failed\n", argv[0]);
    exit(1);
  }

  exec(argv[2], &argv[2]);
  fprintf(2, "exec %s failed\n", argv[2]);
  exit(1);
}

