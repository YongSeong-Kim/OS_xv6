#include "types.h"
#include "stat.h"
#include "user.h"

#define NUM_CHILD  5
#define NUM_LOOP   5

// ret: 0: child, 1: parent
int create_child(void) {
  for (int i = 0; i < NUM_CHILD; i++) {
    int pid = fork();
    if (pid == 0) {
      printf(1, "Child %d\n", getpid());
      sleep(10);
//      printf(1,"wake up child now\n");
      return 0;
    }
  }
  printf(1, "Parent %d\n",getpid());
  return 1;
}

void exit_child(int parent) {
  if (parent){
    while (wait() != -1){
    } // wait for all child processes to finish
  }
  else {
//    printf(1,"exit_child %d\n", parent);
    exit();
  }
}

int main(int argc, char **argv) {
  int p;
  
  printf(1, "FCFS test start\n");

  // Test 1
  printf(1, "\nWithout sleep & yield\n");
  
  p = create_child();
  for (int i = 0; i < NUM_LOOP; i++) {
    if (p == 0)//parent 1 child 0
      printf(1, "process %d\n", getpid());
  }
  exit_child(p);
  printf(1,"finish\n");


  // Test 2
  printf(1, "\nWith yield\n");

  p = create_child();

  for (int i = 0; i < NUM_LOOP; i++) {
    if (p == 0) { //child
      printf(1, "process %d\n", getpid());
      yield();
    }
  }

 exit_child(p);

  // Test 3
  printf(1, "\nWith sleep\n");

  p = create_child();

  for (int i = 0; i < NUM_LOOP; i++) {
    if (p == 0) {
      printf(1, "process %d\n", getpid());
      sleep(1);
    }
  }

  exit_child(p);

// Test 4
  printf(1, "\nInfinite loop\n");

  p = create_child();

  if (p == 0)  {
     
    while (1)
    {
    //   printf(1,"%d\n", getpid());
    }
  }

  exit_child(p);
  printf(1, "ok\n");

  exit();
}
