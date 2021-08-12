#include "types.h"
#include "stat.h"
#include "user.h"
//header 순서지키기
int
main(int argc, char *argv[])
{
	char *buf = "Hello xv6!";
	int ret_val;
	ret_val = myfunction(buf);
	printf(1,"Return value : 0x%x\n", ret_val);
	exit();

}
