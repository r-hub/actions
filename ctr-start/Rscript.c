#include <stdio.h>
#include <stdlib.h>
#include <string.h>
int main(int argc, char **argv) {
  char cmd[8192];
  if (argc <= 1)
    return 0;
  cmd[0] = 0;
  strncat(cmd, "Rscript2 ", sizeof(cmd) - 1);
  strncat(cmd, argv[1], sizeof(cmd) - 1);
  int ret = system(cmd);
  return ret == 0 ? 0 : 2;
}
