#include "types.h"
#include "stat.h"
#include "user.h"

int main(int argc, char* argv[])
{
	__asm__("int $128");//어셈블리 명령
	return 0;
}
