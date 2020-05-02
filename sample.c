#include "types.h"
#include "stat.h"
#include "user.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
  int x;
  double z=0.0;
  fork();
  wait();
  for ( z = 0; z < 4000000.0; z += 0.01 )
         x =  x + 3.14 * 89.64;
  exit();
}