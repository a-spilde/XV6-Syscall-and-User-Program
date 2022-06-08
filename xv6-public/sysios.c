#include "types.h"
#include "stat.h"
#include "user.h"

struct iostat
{
  int readcount;  // total number of times read() is invoked by the current running process (including failed calls)
  int writecount; // total number of times write() is invoked by the current running process (including failed calls)
};

int main(int argc, char **argv)
{
  int reads = atoi(argv[1]);
  int writes  = atoi(argv[2]);

  char* tmp = malloc(1);
  struct iostat *i = malloc(2*sizeof(int));

  i->readcount=0;
  i->writecount=0;

  for (int j = 0; j < reads; j++) {
    read(-1,tmp,10);
  }
  for (int h = 0; h < writes; h++) {
    write(-1,tmp,10);
  }

  int success = getiocounts(i);

  printf(1,"%d %d %d\n", success, i->readcount, i->writecount);

  free(i);
  free(tmp);

  exit();
  return 0;
}