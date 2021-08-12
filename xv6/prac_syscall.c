#include "types.h"
#include "defs.h"

//간단한 system call
int
myfunction (char* str)
{
    cprintf("%s\n", str);
    return 0xABCDABCD;
} 

//my_ syscall에 대한 Wrapper 함수
int
sys_myfunction (void)
{
    char* str;
//Argstr을 사용해서 argument를 해독
    if(argstr(0, &str) < 0)
        return -1;
    return myfunction(str);
}
