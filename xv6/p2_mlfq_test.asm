
_p2_mlfq_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    while (wait() != -1); // wait for all child processes to finish
  else
    exit();
}

int main(int argc, char **argv) {
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	56                   	push   %esi
   e:	53                   	push   %ebx
   f:	51                   	push   %ecx
  10:	83 ec 24             	sub    $0x24,%esp
  int p; // is this parent?

  printf(1, "MLFQ test start\n");
  13:	68 b8 09 00 00       	push   $0x9b8
  18:	6a 01                	push   $0x1
  1a:	e8 41 06 00 00       	call   660 <printf>

// Test 1
  printf(1, "\nFocused priority\n");
  1f:	59                   	pop    %ecx
  20:	5b                   	pop    %ebx
  21:	68 c9 09 00 00       	push   $0x9c9
  26:	6a 01                	push   $0x1
  28:	e8 33 06 00 00       	call   660 <printf>

  p = create_child();
  2d:	e8 ee 01 00 00       	call   220 <create_child>

  if (!p) {
  32:	83 c4 10             	add    $0x10,%esp
  35:	85 c0                	test   %eax,%eax
  37:	74 74                	je     ad <main+0xad>
  39:	e8 c2 01 00 00       	call   200 <exit_child.part.0>
  }

  exit_child(p);

// Test 2
  printf(1, "\nWithout priority manipulation\n");
  3e:	83 ec 08             	sub    $0x8,%esp
  41:	68 10 0a 00 00       	push   $0xa10
  46:	6a 01                	push   $0x1
  48:	e8 13 06 00 00       	call   660 <printf>

  p = create_child();
  4d:	e8 ce 01 00 00       	call   220 <create_child>

  if (!p) {
  52:	83 c4 10             	add    $0x10,%esp
  55:	85 c0                	test   %eax,%eax
  57:	0f 84 b4 00 00 00    	je     111 <main+0x111>
  5d:	e8 9e 01 00 00       	call   200 <exit_child.part.0>
  }

  exit_child(p);

  // Test 3
  printf(1, "\nWith yield\n");
  62:	52                   	push   %edx
  63:	52                   	push   %edx
  64:	68 f6 09 00 00       	push   $0x9f6
  69:	6a 01                	push   $0x1
  6b:	e8 f0 05 00 00       	call   660 <printf>

  p = create_child();
  70:	e8 ab 01 00 00       	call   220 <create_child>

  if (!p) {
  75:	83 c4 10             	add    $0x10,%esp
  78:	85 c0                	test   %eax,%eax
  7a:	0f 84 c1 00 00 00    	je     141 <main+0x141>
  80:	e8 7b 01 00 00       	call   200 <exit_child.part.0>
  }

  exit_child(p);

  // Test 4
  printf(1, "\nMonopolize\n");
  85:	50                   	push   %eax
  86:	50                   	push   %eax
  87:	68 03 0a 00 00       	push   $0xa03
  8c:	6a 01                	push   $0x1
  8e:	e8 cd 05 00 00       	call   660 <printf>

  p = create_child();
  93:	e8 88 01 00 00       	call   220 <create_child>

  if (!p) {
  98:	83 c4 10             	add    $0x10,%esp
  9b:	85 c0                	test   %eax,%eax
  9d:	0f 84 d6 00 00 00    	je     179 <main+0x179>
  a3:	e8 58 01 00 00       	call   200 <exit_child.part.0>
    if (me == NUM_CHILD - 1)
      monopolize(2017029452);
  }  

  exit_child(p);
  exit();
  a8:	e8 35 04 00 00       	call   4e2 <exit>
    int pid = getpid();
  ad:	e8 b0 04 00 00       	call   562 <getpid>
    int cnt[2] = {0};
  b2:	bb 20 4e 00 00       	mov    $0x4e20,%ebx
    int pid = getpid();
  b7:	89 c6                	mov    %eax,%esi
    int cnt[2] = {0};
  b9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  c0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  c7:	89 f6                	mov    %esi,%esi
  c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      cnt[getlev()]++;
  d0:	e8 c5 04 00 00       	call   59a <getlev>
  d5:	83 44 85 e0 01       	addl   $0x1,-0x20(%ebp,%eax,4)
      setpriority(pid, me * 2);
  da:	a1 68 0d 00 00       	mov    0xd68,%eax
  df:	83 ec 08             	sub    $0x8,%esp
  e2:	01 c0                	add    %eax,%eax
  e4:	50                   	push   %eax
  e5:	56                   	push   %esi
  e6:	e8 b7 04 00 00       	call   5a2 <setpriority>
    for (int i = 0; i < NUM_LOOP1; i++) {
  eb:	83 c4 10             	add    $0x10,%esp
  ee:	83 eb 01             	sub    $0x1,%ebx
  f1:	75 dd                	jne    d0 <main+0xd0>
    printf(1, "process %d: L0=%d, L1=%d\n", pid, cnt[0], cnt[1]);
  f3:	83 ec 0c             	sub    $0xc,%esp
  f6:	ff 75 e4             	pushl  -0x1c(%ebp)
  f9:	ff 75 e0             	pushl  -0x20(%ebp)
  fc:	56                   	push   %esi
  fd:	68 dc 09 00 00       	push   $0x9dc
 102:	6a 01                	push   $0x1
 104:	e8 57 05 00 00       	call   660 <printf>
    exit();
 109:	83 c4 20             	add    $0x20,%esp
 10c:	e8 d1 03 00 00       	call   4e2 <exit>
    int pid = getpid();
 111:	e8 4c 04 00 00       	call   562 <getpid>
    int cnt[2] = {0};
 116:	bb 50 c3 00 00       	mov    $0xc350,%ebx
    int pid = getpid();
 11b:	89 c6                	mov    %eax,%esi
    int cnt[2] = {0};
 11d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 124:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 12b:	90                   	nop
 12c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cnt[getlev()]++;
 130:	e8 65 04 00 00       	call   59a <getlev>
 135:	83 44 85 e0 01       	addl   $0x1,-0x20(%ebp,%eax,4)
    for (int i = 0; i < NUM_LOOP2; i++)
 13a:	83 eb 01             	sub    $0x1,%ebx
 13d:	75 f1                	jne    130 <main+0x130>
 13f:	eb b2                	jmp    f3 <main+0xf3>
    int pid = getpid();
 141:	e8 1c 04 00 00       	call   562 <getpid>
    int cnt[2] = {0};
 146:	bb 10 27 00 00       	mov    $0x2710,%ebx
    int pid = getpid();
 14b:	89 c6                	mov    %eax,%esi
    int cnt[2] = {0};
 14d:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 154:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 15b:	90                   	nop
 15c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cnt[getlev()]++;
 160:	e8 35 04 00 00       	call   59a <getlev>
 165:	83 44 85 e0 01       	addl   $0x1,-0x20(%ebp,%eax,4)
      yield();
 16a:	e8 23 04 00 00       	call   592 <yield>
    for (int i = 0; i < NUM_LOOP3; i++) {
 16f:	83 eb 01             	sub    $0x1,%ebx
 172:	75 ec                	jne    160 <main+0x160>
 174:	e9 7a ff ff ff       	jmp    f3 <main+0xf3>
    int pid = getpid();
 179:	e8 e4 03 00 00       	call   562 <getpid>
    if (me == NUM_CHILD - 1)
 17e:	83 3d 68 0d 00 00 04 	cmpl   $0x4,0xd68
    int pid = getpid();
 185:	89 c6                	mov    %eax,%esi
    int cnt[2] = {0};
 187:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
 18e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    if (me == NUM_CHILD - 1)
 195:	74 53                	je     1ea <main+0x1ea>
    int cnt[2] = {0};
 197:	bb a8 61 00 00       	mov    $0x61a8,%ebx
 19c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cnt[getlev()]++;
 1a0:	e8 f5 03 00 00       	call   59a <getlev>
 1a5:	83 44 85 e0 01       	addl   $0x1,-0x20(%ebp,%eax,4)
    for (int i = 0; i < NUM_LOOP4; i++)
 1aa:	83 eb 01             	sub    $0x1,%ebx
 1ad:	75 f1                	jne    1a0 <main+0x1a0>
    printf(1, "process %d: L0=%d, L1=%d\n", pid, cnt[0], cnt[1]);
 1af:	83 ec 0c             	sub    $0xc,%esp
 1b2:	ff 75 e4             	pushl  -0x1c(%ebp)
 1b5:	ff 75 e0             	pushl  -0x20(%ebp)
 1b8:	56                   	push   %esi
 1b9:	68 dc 09 00 00       	push   $0x9dc
 1be:	6a 01                	push   $0x1
 1c0:	e8 9b 04 00 00       	call   660 <printf>
    if (me == NUM_CHILD - 1)
 1c5:	83 c4 20             	add    $0x20,%esp
 1c8:	83 3d 68 0d 00 00 04 	cmpl   $0x4,0xd68
 1cf:	0f 85 d3 fe ff ff    	jne    a8 <main+0xa8>
      monopolize(2017029452);
 1d5:	83 ec 0c             	sub    $0xc,%esp
 1d8:	68 4c 6d 39 78       	push   $0x78396d4c
 1dd:	e8 c8 03 00 00       	call   5aa <monopolize>
 1e2:	83 c4 10             	add    $0x10,%esp
 1e5:	e9 be fe ff ff       	jmp    a8 <main+0xa8>
      monopolize(2017029452); //본인 학번입력
 1ea:	83 ec 0c             	sub    $0xc,%esp
 1ed:	68 4c 6d 39 78       	push   $0x78396d4c
 1f2:	e8 b3 03 00 00       	call   5aa <monopolize>
 1f7:	83 c4 10             	add    $0x10,%esp
 1fa:	eb 9b                	jmp    197 <main+0x197>
 1fc:	66 90                	xchg   %ax,%ax
 1fe:	66 90                	xchg   %ax,%ax

00000200 <exit_child.part.0>:
void exit_child(int parent) {
 200:	55                   	push   %ebp
 201:	89 e5                	mov    %esp,%ebp
 203:	83 ec 08             	sub    $0x8,%esp
 206:	8d 76 00             	lea    0x0(%esi),%esi
 209:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    while (wait() != -1); // wait for all child processes to finish
 210:	e8 d5 02 00 00       	call   4ea <wait>
 215:	83 f8 ff             	cmp    $0xffffffff,%eax
 218:	75 f6                	jne    210 <exit_child.part.0+0x10>
}
 21a:	c9                   	leave  
 21b:	c3                   	ret    
 21c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000220 <create_child>:
int create_child(void) {
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  for (int i = 0; i < NUM_CHILD; i++) {
 225:	31 db                	xor    %ebx,%ebx
    int pid = fork();
 227:	e8 ae 02 00 00       	call   4da <fork>
    if (pid == 0) {
 22c:	85 c0                	test   %eax,%eax
    int pid = fork();
 22e:	89 c6                	mov    %eax,%esi
    if (pid == 0) {
 230:	74 1e                	je     250 <create_child+0x30>
  for (int i = 0; i < NUM_CHILD; i++) {
 232:	83 c3 01             	add    $0x1,%ebx
 235:	83 fb 05             	cmp    $0x5,%ebx
 238:	75 ed                	jne    227 <create_child+0x7>
}
 23a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return 1;
 23d:	be 01 00 00 00       	mov    $0x1,%esi
}
 242:	89 f0                	mov    %esi,%eax
 244:	5b                   	pop    %ebx
 245:	5e                   	pop    %esi
 246:	5d                   	pop    %ebp
 247:	c3                   	ret    
 248:	90                   	nop
 249:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      sleep(10);
 250:	83 ec 0c             	sub    $0xc,%esp
      me = i;
 253:	89 1d 68 0d 00 00    	mov    %ebx,0xd68
      sleep(10);
 259:	6a 0a                	push   $0xa
 25b:	e8 12 03 00 00       	call   572 <sleep>
      return 0;
 260:	83 c4 10             	add    $0x10,%esp
}
 263:	8d 65 f8             	lea    -0x8(%ebp),%esp
 266:	89 f0                	mov    %esi,%eax
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    
 26c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000270 <exit_child>:
void exit_child(int parent) {
 270:	55                   	push   %ebp
 271:	89 e5                	mov    %esp,%ebp
 273:	83 ec 08             	sub    $0x8,%esp
  if (parent)
 276:	8b 45 08             	mov    0x8(%ebp),%eax
 279:	85 c0                	test   %eax,%eax
 27b:	74 03                	je     280 <exit_child+0x10>
}
 27d:	c9                   	leave  
 27e:	eb 80                	jmp    200 <exit_child.part.0>
    exit();
 280:	e8 5d 02 00 00       	call   4e2 <exit>
 285:	66 90                	xchg   %ax,%ax
 287:	66 90                	xchg   %ax,%ax
 289:	66 90                	xchg   %ax,%ax
 28b:	66 90                	xchg   %ax,%ax
 28d:	66 90                	xchg   %ax,%ax
 28f:	90                   	nop

00000290 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	53                   	push   %ebx
 294:	8b 45 08             	mov    0x8(%ebp),%eax
 297:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29a:	89 c2                	mov    %eax,%edx
 29c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 2a0:	83 c1 01             	add    $0x1,%ecx
 2a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 2a7:	83 c2 01             	add    $0x1,%edx
 2aa:	84 db                	test   %bl,%bl
 2ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 2af:	75 ef                	jne    2a0 <strcpy+0x10>
    ;
  return os;
}
 2b1:	5b                   	pop    %ebx
 2b2:	5d                   	pop    %ebp
 2b3:	c3                   	ret    
 2b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 2ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000002c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c0:	55                   	push   %ebp
 2c1:	89 e5                	mov    %esp,%ebp
 2c3:	53                   	push   %ebx
 2c4:	8b 55 08             	mov    0x8(%ebp),%edx
 2c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 2ca:	0f b6 02             	movzbl (%edx),%eax
 2cd:	0f b6 19             	movzbl (%ecx),%ebx
 2d0:	84 c0                	test   %al,%al
 2d2:	75 1c                	jne    2f0 <strcmp+0x30>
 2d4:	eb 2a                	jmp    300 <strcmp+0x40>
 2d6:	8d 76 00             	lea    0x0(%esi),%esi
 2d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 2e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 2e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 2e6:	83 c1 01             	add    $0x1,%ecx
 2e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 2ec:	84 c0                	test   %al,%al
 2ee:	74 10                	je     300 <strcmp+0x40>
 2f0:	38 d8                	cmp    %bl,%al
 2f2:	74 ec                	je     2e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 2f4:	29 d8                	sub    %ebx,%eax
}
 2f6:	5b                   	pop    %ebx
 2f7:	5d                   	pop    %ebp
 2f8:	c3                   	ret    
 2f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 300:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 302:	29 d8                	sub    %ebx,%eax
}
 304:	5b                   	pop    %ebx
 305:	5d                   	pop    %ebp
 306:	c3                   	ret    
 307:	89 f6                	mov    %esi,%esi
 309:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000310 <strlen>:

uint
strlen(const char *s)
{
 310:	55                   	push   %ebp
 311:	89 e5                	mov    %esp,%ebp
 313:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 316:	80 39 00             	cmpb   $0x0,(%ecx)
 319:	74 15                	je     330 <strlen+0x20>
 31b:	31 d2                	xor    %edx,%edx
 31d:	8d 76 00             	lea    0x0(%esi),%esi
 320:	83 c2 01             	add    $0x1,%edx
 323:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 327:	89 d0                	mov    %edx,%eax
 329:	75 f5                	jne    320 <strlen+0x10>
    ;
  return n;
}
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    
 32d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 330:	31 c0                	xor    %eax,%eax
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    
 334:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 33a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000340 <memset>:

void*
memset(void *dst, int c, uint n)
{
 340:	55                   	push   %ebp
 341:	89 e5                	mov    %esp,%ebp
 343:	57                   	push   %edi
 344:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 347:	8b 4d 10             	mov    0x10(%ebp),%ecx
 34a:	8b 45 0c             	mov    0xc(%ebp),%eax
 34d:	89 d7                	mov    %edx,%edi
 34f:	fc                   	cld    
 350:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 352:	89 d0                	mov    %edx,%eax
 354:	5f                   	pop    %edi
 355:	5d                   	pop    %ebp
 356:	c3                   	ret    
 357:	89 f6                	mov    %esi,%esi
 359:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000360 <strchr>:

char*
strchr(const char *s, char c)
{
 360:	55                   	push   %ebp
 361:	89 e5                	mov    %esp,%ebp
 363:	53                   	push   %ebx
 364:	8b 45 08             	mov    0x8(%ebp),%eax
 367:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 36a:	0f b6 10             	movzbl (%eax),%edx
 36d:	84 d2                	test   %dl,%dl
 36f:	74 1d                	je     38e <strchr+0x2e>
    if(*s == c)
 371:	38 d3                	cmp    %dl,%bl
 373:	89 d9                	mov    %ebx,%ecx
 375:	75 0d                	jne    384 <strchr+0x24>
 377:	eb 17                	jmp    390 <strchr+0x30>
 379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 380:	38 ca                	cmp    %cl,%dl
 382:	74 0c                	je     390 <strchr+0x30>
  for(; *s; s++)
 384:	83 c0 01             	add    $0x1,%eax
 387:	0f b6 10             	movzbl (%eax),%edx
 38a:	84 d2                	test   %dl,%dl
 38c:	75 f2                	jne    380 <strchr+0x20>
      return (char*)s;
  return 0;
 38e:	31 c0                	xor    %eax,%eax
}
 390:	5b                   	pop    %ebx
 391:	5d                   	pop    %ebp
 392:	c3                   	ret    
 393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000003a0 <gets>:

char*
gets(char *buf, int max)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
 3a4:	56                   	push   %esi
 3a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3a6:	31 f6                	xor    %esi,%esi
 3a8:	89 f3                	mov    %esi,%ebx
{
 3aa:	83 ec 1c             	sub    $0x1c,%esp
 3ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 3b0:	eb 2f                	jmp    3e1 <gets+0x41>
 3b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 3b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 3bb:	83 ec 04             	sub    $0x4,%esp
 3be:	6a 01                	push   $0x1
 3c0:	50                   	push   %eax
 3c1:	6a 00                	push   $0x0
 3c3:	e8 32 01 00 00       	call   4fa <read>
    if(cc < 1)
 3c8:	83 c4 10             	add    $0x10,%esp
 3cb:	85 c0                	test   %eax,%eax
 3cd:	7e 1c                	jle    3eb <gets+0x4b>
      break;
    buf[i++] = c;
 3cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 3d3:	83 c7 01             	add    $0x1,%edi
 3d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 3d9:	3c 0a                	cmp    $0xa,%al
 3db:	74 23                	je     400 <gets+0x60>
 3dd:	3c 0d                	cmp    $0xd,%al
 3df:	74 1f                	je     400 <gets+0x60>
  for(i=0; i+1 < max; ){
 3e1:	83 c3 01             	add    $0x1,%ebx
 3e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 3e7:	89 fe                	mov    %edi,%esi
 3e9:	7c cd                	jl     3b8 <gets+0x18>
 3eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 3ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 3f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 3f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5f                   	pop    %edi
 3f9:	5d                   	pop    %ebp
 3fa:	c3                   	ret    
 3fb:	90                   	nop
 3fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 400:	8b 75 08             	mov    0x8(%ebp),%esi
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	01 de                	add    %ebx,%esi
 408:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 40a:	c6 03 00             	movb   $0x0,(%ebx)
}
 40d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 410:	5b                   	pop    %ebx
 411:	5e                   	pop    %esi
 412:	5f                   	pop    %edi
 413:	5d                   	pop    %ebp
 414:	c3                   	ret    
 415:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 419:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000420 <stat>:

int
stat(const char *n, struct stat *st)
{
 420:	55                   	push   %ebp
 421:	89 e5                	mov    %esp,%ebp
 423:	56                   	push   %esi
 424:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 425:	83 ec 08             	sub    $0x8,%esp
 428:	6a 00                	push   $0x0
 42a:	ff 75 08             	pushl  0x8(%ebp)
 42d:	e8 f0 00 00 00       	call   522 <open>
  if(fd < 0)
 432:	83 c4 10             	add    $0x10,%esp
 435:	85 c0                	test   %eax,%eax
 437:	78 27                	js     460 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 439:	83 ec 08             	sub    $0x8,%esp
 43c:	ff 75 0c             	pushl  0xc(%ebp)
 43f:	89 c3                	mov    %eax,%ebx
 441:	50                   	push   %eax
 442:	e8 f3 00 00 00       	call   53a <fstat>
  close(fd);
 447:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 44a:	89 c6                	mov    %eax,%esi
  close(fd);
 44c:	e8 b9 00 00 00       	call   50a <close>
  return r;
 451:	83 c4 10             	add    $0x10,%esp
}
 454:	8d 65 f8             	lea    -0x8(%ebp),%esp
 457:	89 f0                	mov    %esi,%eax
 459:	5b                   	pop    %ebx
 45a:	5e                   	pop    %esi
 45b:	5d                   	pop    %ebp
 45c:	c3                   	ret    
 45d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 460:	be ff ff ff ff       	mov    $0xffffffff,%esi
 465:	eb ed                	jmp    454 <stat+0x34>
 467:	89 f6                	mov    %esi,%esi
 469:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000470 <atoi>:

int
atoi(const char *s)
{
 470:	55                   	push   %ebp
 471:	89 e5                	mov    %esp,%ebp
 473:	53                   	push   %ebx
 474:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 477:	0f be 11             	movsbl (%ecx),%edx
 47a:	8d 42 d0             	lea    -0x30(%edx),%eax
 47d:	3c 09                	cmp    $0x9,%al
  n = 0;
 47f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 484:	77 1f                	ja     4a5 <atoi+0x35>
 486:	8d 76 00             	lea    0x0(%esi),%esi
 489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 490:	8d 04 80             	lea    (%eax,%eax,4),%eax
 493:	83 c1 01             	add    $0x1,%ecx
 496:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 49a:	0f be 11             	movsbl (%ecx),%edx
 49d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 4a0:	80 fb 09             	cmp    $0x9,%bl
 4a3:	76 eb                	jbe    490 <atoi+0x20>
  return n;
}
 4a5:	5b                   	pop    %ebx
 4a6:	5d                   	pop    %ebp
 4a7:	c3                   	ret    
 4a8:	90                   	nop
 4a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000004b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 4b0:	55                   	push   %ebp
 4b1:	89 e5                	mov    %esp,%ebp
 4b3:	56                   	push   %esi
 4b4:	53                   	push   %ebx
 4b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 4be:	85 db                	test   %ebx,%ebx
 4c0:	7e 14                	jle    4d6 <memmove+0x26>
 4c2:	31 d2                	xor    %edx,%edx
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 4c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 4cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 4cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 4d2:	39 d3                	cmp    %edx,%ebx
 4d4:	75 f2                	jne    4c8 <memmove+0x18>
  return vdst;
}
 4d6:	5b                   	pop    %ebx
 4d7:	5e                   	pop    %esi
 4d8:	5d                   	pop    %ebp
 4d9:	c3                   	ret    

000004da <fork>:
  name: \ 
    movl $SYS_ ## name, %eax; \ 
    int $T_SYSCALL; \ 
    ret

SYSCALL(fork)
 4da:	b8 01 00 00 00       	mov    $0x1,%eax
 4df:	cd 40                	int    $0x40
 4e1:	c3                   	ret    

000004e2 <exit>:
SYSCALL(exit)
 4e2:	b8 02 00 00 00       	mov    $0x2,%eax
 4e7:	cd 40                	int    $0x40
 4e9:	c3                   	ret    

000004ea <wait>:
SYSCALL(wait)
 4ea:	b8 03 00 00 00       	mov    $0x3,%eax
 4ef:	cd 40                	int    $0x40
 4f1:	c3                   	ret    

000004f2 <pipe>:
SYSCALL(pipe)
 4f2:	b8 04 00 00 00       	mov    $0x4,%eax
 4f7:	cd 40                	int    $0x40
 4f9:	c3                   	ret    

000004fa <read>:
SYSCALL(read)
 4fa:	b8 05 00 00 00       	mov    $0x5,%eax
 4ff:	cd 40                	int    $0x40
 501:	c3                   	ret    

00000502 <write>:
SYSCALL(write)
 502:	b8 10 00 00 00       	mov    $0x10,%eax
 507:	cd 40                	int    $0x40
 509:	c3                   	ret    

0000050a <close>:
SYSCALL(close)
 50a:	b8 15 00 00 00       	mov    $0x15,%eax
 50f:	cd 40                	int    $0x40
 511:	c3                   	ret    

00000512 <kill>:
SYSCALL(kill)
 512:	b8 06 00 00 00       	mov    $0x6,%eax
 517:	cd 40                	int    $0x40
 519:	c3                   	ret    

0000051a <exec>:
SYSCALL(exec)
 51a:	b8 07 00 00 00       	mov    $0x7,%eax
 51f:	cd 40                	int    $0x40
 521:	c3                   	ret    

00000522 <open>:
SYSCALL(open)
 522:	b8 0f 00 00 00       	mov    $0xf,%eax
 527:	cd 40                	int    $0x40
 529:	c3                   	ret    

0000052a <mknod>:
SYSCALL(mknod)
 52a:	b8 11 00 00 00       	mov    $0x11,%eax
 52f:	cd 40                	int    $0x40
 531:	c3                   	ret    

00000532 <unlink>:
SYSCALL(unlink)
 532:	b8 12 00 00 00       	mov    $0x12,%eax
 537:	cd 40                	int    $0x40
 539:	c3                   	ret    

0000053a <fstat>:
SYSCALL(fstat)
 53a:	b8 08 00 00 00       	mov    $0x8,%eax
 53f:	cd 40                	int    $0x40
 541:	c3                   	ret    

00000542 <link>:
SYSCALL(link)
 542:	b8 13 00 00 00       	mov    $0x13,%eax
 547:	cd 40                	int    $0x40
 549:	c3                   	ret    

0000054a <mkdir>:
SYSCALL(mkdir)
 54a:	b8 14 00 00 00       	mov    $0x14,%eax
 54f:	cd 40                	int    $0x40
 551:	c3                   	ret    

00000552 <chdir>:
SYSCALL(chdir)
 552:	b8 09 00 00 00       	mov    $0x9,%eax
 557:	cd 40                	int    $0x40
 559:	c3                   	ret    

0000055a <dup>:
SYSCALL(dup)
 55a:	b8 0a 00 00 00       	mov    $0xa,%eax
 55f:	cd 40                	int    $0x40
 561:	c3                   	ret    

00000562 <getpid>:
SYSCALL(getpid)
 562:	b8 0b 00 00 00       	mov    $0xb,%eax
 567:	cd 40                	int    $0x40
 569:	c3                   	ret    

0000056a <sbrk>:
SYSCALL(sbrk)
 56a:	b8 0c 00 00 00       	mov    $0xc,%eax
 56f:	cd 40                	int    $0x40
 571:	c3                   	ret    

00000572 <sleep>:
SYSCALL(sleep)
 572:	b8 0d 00 00 00       	mov    $0xd,%eax
 577:	cd 40                	int    $0x40
 579:	c3                   	ret    

0000057a <uptime>:
SYSCALL(uptime)
 57a:	b8 0e 00 00 00       	mov    $0xe,%eax
 57f:	cd 40                	int    $0x40
 581:	c3                   	ret    

00000582 <myfunction>:
SYSCALL(myfunction)
 582:	b8 16 00 00 00       	mov    $0x16,%eax
 587:	cd 40                	int    $0x40
 589:	c3                   	ret    

0000058a <getppid>:
SYSCALL(getppid)
 58a:	b8 17 00 00 00       	mov    $0x17,%eax
 58f:	cd 40                	int    $0x40
 591:	c3                   	ret    

00000592 <yield>:
SYSCALL(yield)
 592:	b8 18 00 00 00       	mov    $0x18,%eax
 597:	cd 40                	int    $0x40
 599:	c3                   	ret    

0000059a <getlev>:
SYSCALL(getlev)
 59a:	b8 19 00 00 00       	mov    $0x19,%eax
 59f:	cd 40                	int    $0x40
 5a1:	c3                   	ret    

000005a2 <setpriority>:
SYSCALL(setpriority)
 5a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 5a7:	cd 40                	int    $0x40
 5a9:	c3                   	ret    

000005aa <monopolize>:
SYSCALL(monopolize)
 5aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 5af:	cd 40                	int    $0x40
 5b1:	c3                   	ret    
 5b2:	66 90                	xchg   %ax,%ax
 5b4:	66 90                	xchg   %ax,%ax
 5b6:	66 90                	xchg   %ax,%ax
 5b8:	66 90                	xchg   %ax,%ax
 5ba:	66 90                	xchg   %ax,%ax
 5bc:	66 90                	xchg   %ax,%ax
 5be:	66 90                	xchg   %ax,%ax

000005c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 5c0:	55                   	push   %ebp
 5c1:	89 e5                	mov    %esp,%ebp
 5c3:	57                   	push   %edi
 5c4:	56                   	push   %esi
 5c5:	53                   	push   %ebx
 5c6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 5c9:	85 d2                	test   %edx,%edx
{
 5cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 5ce:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 5d0:	79 76                	jns    648 <printint+0x88>
 5d2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 5d6:	74 70                	je     648 <printint+0x88>
    x = -xx;
 5d8:	f7 d8                	neg    %eax
    neg = 1;
 5da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 5e1:	31 f6                	xor    %esi,%esi
 5e3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 5e6:	eb 0a                	jmp    5f2 <printint+0x32>
 5e8:	90                   	nop
 5e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 5f0:	89 fe                	mov    %edi,%esi
 5f2:	31 d2                	xor    %edx,%edx
 5f4:	8d 7e 01             	lea    0x1(%esi),%edi
 5f7:	f7 f1                	div    %ecx
 5f9:	0f b6 92 38 0a 00 00 	movzbl 0xa38(%edx),%edx
  }while((x /= base) != 0);
 600:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 602:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 605:	75 e9                	jne    5f0 <printint+0x30>
  if(neg)
 607:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 60a:	85 c0                	test   %eax,%eax
 60c:	74 08                	je     616 <printint+0x56>
    buf[i++] = '-';
 60e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 613:	8d 7e 02             	lea    0x2(%esi),%edi
 616:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 61a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 61d:	8d 76 00             	lea    0x0(%esi),%esi
 620:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 623:	83 ec 04             	sub    $0x4,%esp
 626:	83 ee 01             	sub    $0x1,%esi
 629:	6a 01                	push   $0x1
 62b:	53                   	push   %ebx
 62c:	57                   	push   %edi
 62d:	88 45 d7             	mov    %al,-0x29(%ebp)
 630:	e8 cd fe ff ff       	call   502 <write>

  while(--i >= 0)
 635:	83 c4 10             	add    $0x10,%esp
 638:	39 de                	cmp    %ebx,%esi
 63a:	75 e4                	jne    620 <printint+0x60>
    putc(fd, buf[i]);
}
 63c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 63f:	5b                   	pop    %ebx
 640:	5e                   	pop    %esi
 641:	5f                   	pop    %edi
 642:	5d                   	pop    %ebp
 643:	c3                   	ret    
 644:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 648:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 64f:	eb 90                	jmp    5e1 <printint+0x21>
 651:	eb 0d                	jmp    660 <printf>
 653:	90                   	nop
 654:	90                   	nop
 655:	90                   	nop
 656:	90                   	nop
 657:	90                   	nop
 658:	90                   	nop
 659:	90                   	nop
 65a:	90                   	nop
 65b:	90                   	nop
 65c:	90                   	nop
 65d:	90                   	nop
 65e:	90                   	nop
 65f:	90                   	nop

00000660 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 660:	55                   	push   %ebp
 661:	89 e5                	mov    %esp,%ebp
 663:	57                   	push   %edi
 664:	56                   	push   %esi
 665:	53                   	push   %ebx
 666:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 669:	8b 75 0c             	mov    0xc(%ebp),%esi
 66c:	0f b6 1e             	movzbl (%esi),%ebx
 66f:	84 db                	test   %bl,%bl
 671:	0f 84 b3 00 00 00    	je     72a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 677:	8d 45 10             	lea    0x10(%ebp),%eax
 67a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 67d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 67f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 682:	eb 2f                	jmp    6b3 <printf+0x53>
 684:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 688:	83 f8 25             	cmp    $0x25,%eax
 68b:	0f 84 a7 00 00 00    	je     738 <printf+0xd8>
  write(fd, &c, 1);
 691:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 694:	83 ec 04             	sub    $0x4,%esp
 697:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 69a:	6a 01                	push   $0x1
 69c:	50                   	push   %eax
 69d:	ff 75 08             	pushl  0x8(%ebp)
 6a0:	e8 5d fe ff ff       	call   502 <write>
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 6ab:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 6af:	84 db                	test   %bl,%bl
 6b1:	74 77                	je     72a <printf+0xca>
    if(state == 0){
 6b3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 6b5:	0f be cb             	movsbl %bl,%ecx
 6b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 6bb:	74 cb                	je     688 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 6bd:	83 ff 25             	cmp    $0x25,%edi
 6c0:	75 e6                	jne    6a8 <printf+0x48>
      if(c == 'd'){
 6c2:	83 f8 64             	cmp    $0x64,%eax
 6c5:	0f 84 05 01 00 00    	je     7d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 6cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 6d1:	83 f9 70             	cmp    $0x70,%ecx
 6d4:	74 72                	je     748 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 6d6:	83 f8 73             	cmp    $0x73,%eax
 6d9:	0f 84 99 00 00 00    	je     778 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 6df:	83 f8 63             	cmp    $0x63,%eax
 6e2:	0f 84 08 01 00 00    	je     7f0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 6e8:	83 f8 25             	cmp    $0x25,%eax
 6eb:	0f 84 ef 00 00 00    	je     7e0 <printf+0x180>
  write(fd, &c, 1);
 6f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 6f4:	83 ec 04             	sub    $0x4,%esp
 6f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 6fb:	6a 01                	push   $0x1
 6fd:	50                   	push   %eax
 6fe:	ff 75 08             	pushl  0x8(%ebp)
 701:	e8 fc fd ff ff       	call   502 <write>
 706:	83 c4 0c             	add    $0xc,%esp
 709:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 70c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 70f:	6a 01                	push   $0x1
 711:	50                   	push   %eax
 712:	ff 75 08             	pushl  0x8(%ebp)
 715:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 718:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 71a:	e8 e3 fd ff ff       	call   502 <write>
  for(i = 0; fmt[i]; i++){
 71f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 723:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 726:	84 db                	test   %bl,%bl
 728:	75 89                	jne    6b3 <printf+0x53>
    }
  }
}
 72a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 72d:	5b                   	pop    %ebx
 72e:	5e                   	pop    %esi
 72f:	5f                   	pop    %edi
 730:	5d                   	pop    %ebp
 731:	c3                   	ret    
 732:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 738:	bf 25 00 00 00       	mov    $0x25,%edi
 73d:	e9 66 ff ff ff       	jmp    6a8 <printf+0x48>
 742:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 748:	83 ec 0c             	sub    $0xc,%esp
 74b:	b9 10 00 00 00       	mov    $0x10,%ecx
 750:	6a 00                	push   $0x0
 752:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 755:	8b 45 08             	mov    0x8(%ebp),%eax
 758:	8b 17                	mov    (%edi),%edx
 75a:	e8 61 fe ff ff       	call   5c0 <printint>
        ap++;
 75f:	89 f8                	mov    %edi,%eax
 761:	83 c4 10             	add    $0x10,%esp
      state = 0;
 764:	31 ff                	xor    %edi,%edi
        ap++;
 766:	83 c0 04             	add    $0x4,%eax
 769:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 76c:	e9 37 ff ff ff       	jmp    6a8 <printf+0x48>
 771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 778:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 77b:	8b 08                	mov    (%eax),%ecx
        ap++;
 77d:	83 c0 04             	add    $0x4,%eax
 780:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 783:	85 c9                	test   %ecx,%ecx
 785:	0f 84 8e 00 00 00    	je     819 <printf+0x1b9>
        while(*s != 0){
 78b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 78e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 790:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 792:	84 c0                	test   %al,%al
 794:	0f 84 0e ff ff ff    	je     6a8 <printf+0x48>
 79a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 79d:	89 de                	mov    %ebx,%esi
 79f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 7a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 7a5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 7a8:	83 ec 04             	sub    $0x4,%esp
          s++;
 7ab:	83 c6 01             	add    $0x1,%esi
 7ae:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 7b1:	6a 01                	push   $0x1
 7b3:	57                   	push   %edi
 7b4:	53                   	push   %ebx
 7b5:	e8 48 fd ff ff       	call   502 <write>
        while(*s != 0){
 7ba:	0f b6 06             	movzbl (%esi),%eax
 7bd:	83 c4 10             	add    $0x10,%esp
 7c0:	84 c0                	test   %al,%al
 7c2:	75 e4                	jne    7a8 <printf+0x148>
 7c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 7c7:	31 ff                	xor    %edi,%edi
 7c9:	e9 da fe ff ff       	jmp    6a8 <printf+0x48>
 7ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 7d0:	83 ec 0c             	sub    $0xc,%esp
 7d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 7d8:	6a 01                	push   $0x1
 7da:	e9 73 ff ff ff       	jmp    752 <printf+0xf2>
 7df:	90                   	nop
  write(fd, &c, 1);
 7e0:	83 ec 04             	sub    $0x4,%esp
 7e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 7e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 7e9:	6a 01                	push   $0x1
 7eb:	e9 21 ff ff ff       	jmp    711 <printf+0xb1>
        putc(fd, *ap);
 7f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 7f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 7f6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 7f8:	6a 01                	push   $0x1
        ap++;
 7fa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 7fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 800:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 803:	50                   	push   %eax
 804:	ff 75 08             	pushl  0x8(%ebp)
 807:	e8 f6 fc ff ff       	call   502 <write>
        ap++;
 80c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 80f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 812:	31 ff                	xor    %edi,%edi
 814:	e9 8f fe ff ff       	jmp    6a8 <printf+0x48>
          s = "(null)";
 819:	bb 30 0a 00 00       	mov    $0xa30,%ebx
        while(*s != 0){
 81e:	b8 28 00 00 00       	mov    $0x28,%eax
 823:	e9 72 ff ff ff       	jmp    79a <printf+0x13a>
 828:	66 90                	xchg   %ax,%ax
 82a:	66 90                	xchg   %ax,%ax
 82c:	66 90                	xchg   %ax,%ax
 82e:	66 90                	xchg   %ax,%ax

00000830 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 830:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 831:	a1 5c 0d 00 00       	mov    0xd5c,%eax
{
 836:	89 e5                	mov    %esp,%ebp
 838:	57                   	push   %edi
 839:	56                   	push   %esi
 83a:	53                   	push   %ebx
 83b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 83e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 841:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 848:	39 c8                	cmp    %ecx,%eax
 84a:	8b 10                	mov    (%eax),%edx
 84c:	73 32                	jae    880 <free+0x50>
 84e:	39 d1                	cmp    %edx,%ecx
 850:	72 04                	jb     856 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 852:	39 d0                	cmp    %edx,%eax
 854:	72 32                	jb     888 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 856:	8b 73 fc             	mov    -0x4(%ebx),%esi
 859:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 85c:	39 fa                	cmp    %edi,%edx
 85e:	74 30                	je     890 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 860:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 863:	8b 50 04             	mov    0x4(%eax),%edx
 866:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 869:	39 f1                	cmp    %esi,%ecx
 86b:	74 3a                	je     8a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 86d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 86f:	a3 5c 0d 00 00       	mov    %eax,0xd5c
}
 874:	5b                   	pop    %ebx
 875:	5e                   	pop    %esi
 876:	5f                   	pop    %edi
 877:	5d                   	pop    %ebp
 878:	c3                   	ret    
 879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 880:	39 d0                	cmp    %edx,%eax
 882:	72 04                	jb     888 <free+0x58>
 884:	39 d1                	cmp    %edx,%ecx
 886:	72 ce                	jb     856 <free+0x26>
{
 888:	89 d0                	mov    %edx,%eax
 88a:	eb bc                	jmp    848 <free+0x18>
 88c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 890:	03 72 04             	add    0x4(%edx),%esi
 893:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 896:	8b 10                	mov    (%eax),%edx
 898:	8b 12                	mov    (%edx),%edx
 89a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 89d:	8b 50 04             	mov    0x4(%eax),%edx
 8a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 8a3:	39 f1                	cmp    %esi,%ecx
 8a5:	75 c6                	jne    86d <free+0x3d>
    p->s.size += bp->s.size;
 8a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 8aa:	a3 5c 0d 00 00       	mov    %eax,0xd5c
    p->s.size += bp->s.size;
 8af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 8b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 8b5:	89 10                	mov    %edx,(%eax)
}
 8b7:	5b                   	pop    %ebx
 8b8:	5e                   	pop    %esi
 8b9:	5f                   	pop    %edi
 8ba:	5d                   	pop    %ebp
 8bb:	c3                   	ret    
 8bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000008c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8c0:	55                   	push   %ebp
 8c1:	89 e5                	mov    %esp,%ebp
 8c3:	57                   	push   %edi
 8c4:	56                   	push   %esi
 8c5:	53                   	push   %ebx
 8c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 8cc:	8b 15 5c 0d 00 00    	mov    0xd5c,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d2:	8d 78 07             	lea    0x7(%eax),%edi
 8d5:	c1 ef 03             	shr    $0x3,%edi
 8d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 8db:	85 d2                	test   %edx,%edx
 8dd:	0f 84 9d 00 00 00    	je     980 <malloc+0xc0>
 8e3:	8b 02                	mov    (%edx),%eax
 8e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 8e8:	39 cf                	cmp    %ecx,%edi
 8ea:	76 6c                	jbe    958 <malloc+0x98>
 8ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 8f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 8f7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 8fa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 901:	eb 0e                	jmp    911 <malloc+0x51>
 903:	90                   	nop
 904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 908:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 90a:	8b 48 04             	mov    0x4(%eax),%ecx
 90d:	39 f9                	cmp    %edi,%ecx
 90f:	73 47                	jae    958 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 911:	39 05 5c 0d 00 00    	cmp    %eax,0xd5c
 917:	89 c2                	mov    %eax,%edx
 919:	75 ed                	jne    908 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 91b:	83 ec 0c             	sub    $0xc,%esp
 91e:	56                   	push   %esi
 91f:	e8 46 fc ff ff       	call   56a <sbrk>
  if(p == (char*)-1)
 924:	83 c4 10             	add    $0x10,%esp
 927:	83 f8 ff             	cmp    $0xffffffff,%eax
 92a:	74 1c                	je     948 <malloc+0x88>
  hp->s.size = nu;
 92c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 92f:	83 ec 0c             	sub    $0xc,%esp
 932:	83 c0 08             	add    $0x8,%eax
 935:	50                   	push   %eax
 936:	e8 f5 fe ff ff       	call   830 <free>
  return freep;
 93b:	8b 15 5c 0d 00 00    	mov    0xd5c,%edx
      if((p = morecore(nunits)) == 0)
 941:	83 c4 10             	add    $0x10,%esp
 944:	85 d2                	test   %edx,%edx
 946:	75 c0                	jne    908 <malloc+0x48>
        return 0;
  }
}
 948:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 94b:	31 c0                	xor    %eax,%eax
}
 94d:	5b                   	pop    %ebx
 94e:	5e                   	pop    %esi
 94f:	5f                   	pop    %edi
 950:	5d                   	pop    %ebp
 951:	c3                   	ret    
 952:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 958:	39 cf                	cmp    %ecx,%edi
 95a:	74 54                	je     9b0 <malloc+0xf0>
        p->s.size -= nunits;
 95c:	29 f9                	sub    %edi,%ecx
 95e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 961:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 964:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 967:	89 15 5c 0d 00 00    	mov    %edx,0xd5c
}
 96d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 970:	83 c0 08             	add    $0x8,%eax
}
 973:	5b                   	pop    %ebx
 974:	5e                   	pop    %esi
 975:	5f                   	pop    %edi
 976:	5d                   	pop    %ebp
 977:	c3                   	ret    
 978:	90                   	nop
 979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 980:	c7 05 5c 0d 00 00 60 	movl   $0xd60,0xd5c
 987:	0d 00 00 
 98a:	c7 05 60 0d 00 00 60 	movl   $0xd60,0xd60
 991:	0d 00 00 
    base.s.size = 0;
 994:	b8 60 0d 00 00       	mov    $0xd60,%eax
 999:	c7 05 64 0d 00 00 00 	movl   $0x0,0xd64
 9a0:	00 00 00 
 9a3:	e9 44 ff ff ff       	jmp    8ec <malloc+0x2c>
 9a8:	90                   	nop
 9a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 9b0:	8b 08                	mov    (%eax),%ecx
 9b2:	89 0a                	mov    %ecx,(%edx)
 9b4:	eb b1                	jmp    967 <malloc+0xa7>
