
_file_test:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  if (first)
    printf(1, "Test 2 passed\n\n");
}

int main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	53                   	push   %ebx
  int i;
  for (i = 0; i < NUM_BYTES; i++){
    buf[i] = (i % 26) + 'a';
   e:	bb 4f ec c4 4e       	mov    $0x4ec4ec4f,%ebx
{
  13:	51                   	push   %ecx
  for (i = 0; i < NUM_BYTES; i++){
  14:	31 c9                	xor    %ecx,%ecx
  16:	8d 76 00             	lea    0x0(%esi),%esi
  19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    buf[i] = (i % 26) + 'a';
  20:	89 c8                	mov    %ecx,%eax
  22:	f7 e3                	mul    %ebx
  24:	89 c8                	mov    %ecx,%eax
  for (i = 0; i < NUM_BYTES; i++){
  26:	83 c1 01             	add    $0x1,%ecx
    buf[i] = (i % 26) + 'a';
  29:	c1 ea 03             	shr    $0x3,%edx
  2c:	6b d2 1a             	imul   $0x1a,%edx,%edx
  2f:	29 d0                	sub    %edx,%eax
  31:	83 c0 61             	add    $0x61,%eax
  34:	88 81 7f 0f 80 00    	mov    %al,0x800f7f(%ecx)
  for (i = 0; i < NUM_BYTES; i++){
  3a:	81 f9 00 00 80 00    	cmp    $0x800000,%ecx
  40:	75 de                	jne    20 <main+0x20>
  }
//   printf(1, "%c\n",buf[1]);
  
  test1(1);
  42:	83 ec 0c             	sub    $0xc,%esp
  test2(1);

  printf(1, "Test 3: repeating test 1 & 2\n");
  45:	bb 30 00 00 00       	mov    $0x30,%ebx
  test1(1);
  4a:	6a 01                	push   $0x1
  4c:	e8 ef 00 00 00       	call   140 <test1>
  test2(1);
  51:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  58:	e8 93 01 00 00       	call   1f0 <test2>
  printf(1, "Test 3: repeating test 1 & 2\n");
  5d:	58                   	pop    %eax
  5e:	5a                   	pop    %edx
  5f:	68 80 0b 00 00       	push   $0xb80
  64:	6a 01                	push   $0x1
  66:	e8 f5 06 00 00       	call   760 <printf>
  6b:	83 c4 10             	add    $0x10,%esp
  6e:	66 90                	xchg   %ax,%ax
  for (i = 0; i < NUM_TEST3; i++)
  {
    printf(1, "Loop %d: ", i + 1);
  70:	8d 43 d1             	lea    -0x2f(%ebx),%eax
  73:	83 ec 04             	sub    $0x4,%esp
  76:	50                   	push   %eax
  77:	68 9e 0b 00 00       	push   $0xb9e
  7c:	6a 01                	push   $0x1
  7e:	e8 dd 06 00 00       	call   760 <printf>
    filename[len - 1] = (i % 10) + '0';
    printf(1,"%c\n", filename[len-1]);
  83:	83 c4 0c             	add    $0xc,%esp
    filename[len - 1] = (i % 10) + '0';
  86:	88 1d 3d 0f 00 00    	mov    %bl,0xf3d
    printf(1,"%c\n", filename[len-1]);
  8c:	53                   	push   %ebx
  8d:	68 a8 0b 00 00       	push   $0xba8
  92:	83 c3 01             	add    $0x1,%ebx
  95:	6a 01                	push   $0x1
  97:	e8 c4 06 00 00       	call   760 <printf>
    printf(1, "1.. ");
  9c:	59                   	pop    %ecx
  9d:	58                   	pop    %eax
  9e:	68 ac 0b 00 00       	push   $0xbac
  a3:	6a 01                	push   $0x1
  a5:	e8 b6 06 00 00       	call   760 <printf>
    test1(0);
  aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b1:	e8 8a 00 00 00       	call   140 <test1>

    printf(1, "2.. ");
  b6:	58                   	pop    %eax
  b7:	5a                   	pop    %edx
  b8:	68 b1 0b 00 00       	push   $0xbb1
  bd:	6a 01                	push   $0x1
  bf:	e8 9c 06 00 00       	call   760 <printf>
    test2(0);
  c4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  cb:	e8 20 01 00 00       	call   1f0 <test2>

    printf(1, "ok\n");
  d0:	59                   	pop    %ecx
  d1:	58                   	pop    %eax
  d2:	68 b6 0b 00 00       	push   $0xbb6
  d7:	6a 01                	push   $0x1
  d9:	e8 82 06 00 00       	call   760 <printf>
  for (i = 0; i < NUM_TEST3; i++)
  de:	83 c4 10             	add    $0x10,%esp
  e1:	83 fb 3a             	cmp    $0x3a,%ebx
  e4:	75 8a                	jne    70 <main+0x70>
  }
  printf(1, "Test 3 passed\n");
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	68 ba 0b 00 00       	push   $0xbba
  ee:	6a 01                	push   $0x1
  f0:	e8 6b 06 00 00       	call   760 <printf>
  
  printf(1, "All tests passed!!\n");
  f5:	58                   	pop    %eax
  f6:	5a                   	pop    %edx
  f7:	68 c9 0b 00 00       	push   $0xbc9
  fc:	6a 01                	push   $0x1
  fe:	e8 5d 06 00 00       	call   760 <printf>
  exit();
 103:	e8 da 04 00 00       	call   5e2 <exit>
 108:	66 90                	xchg   %ax,%ax
 10a:	66 90                	xchg   %ax,%ax
 10c:	66 90                	xchg   %ax,%ax
 10e:	66 90                	xchg   %ax,%ax

00000110 <failed>:
{
 110:	55                   	push   %ebp
 111:	89 e5                	mov    %esp,%ebp
 113:	83 ec 10             	sub    $0x10,%esp
  printf(1, msg);
 116:	ff 75 08             	pushl  0x8(%ebp)
 119:	6a 01                	push   $0x1
 11b:	e8 40 06 00 00       	call   760 <printf>
  printf(1, "Test failed!!\n");
 120:	58                   	pop    %eax
 121:	5a                   	pop    %edx
 122:	68 b8 0a 00 00       	push   $0xab8
 127:	6a 01                	push   $0x1
 129:	e8 32 06 00 00       	call   760 <printf>
  exit();
 12e:	e8 af 04 00 00       	call   5e2 <exit>
 133:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 139:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000140 <test1>:
{
 140:	55                   	push   %ebp
 141:	89 e5                	mov    %esp,%ebp
 143:	56                   	push   %esi
 144:	53                   	push   %ebx
 145:	8b 75 08             	mov    0x8(%ebp),%esi
  if (first)
 148:	85 f6                	test   %esi,%esi
 14a:	75 64                	jne    1b0 <test1+0x70>
  fd = open(filename, O_CREATE | O_WRONLY);//filename의 파일을 열기.
 14c:	83 ec 08             	sub    $0x8,%esp
 14f:	68 01 02 00 00       	push   $0x201
 154:	68 34 0f 00 00       	push   $0xf34
 159:	e8 c4 04 00 00       	call   622 <open>
  if (fd < 0)
 15e:	83 c4 10             	add    $0x10,%esp
 161:	85 c0                	test   %eax,%eax
  fd = open(filename, O_CREATE | O_WRONLY);//filename의 파일을 열기.
 163:	89 c3                	mov    %eax,%ebx
  if (fd < 0)
 165:	78 62                	js     1c9 <test1+0x89>
  if (write(fd, buf, NUM_BYTES) < 0)//buf의 내용을 fd에 적음. 
 167:	83 ec 04             	sub    $0x4,%esp
 16a:	68 00 00 80 00       	push   $0x800000
 16f:	68 80 0f 80 00       	push   $0x800f80
 174:	50                   	push   %eax
 175:	e8 88 04 00 00       	call   602 <write>
 17a:	83 c4 10             	add    $0x10,%esp
 17d:	85 c0                	test   %eax,%eax
 17f:	78 62                	js     1e3 <test1+0xa3>
  if (close(fd) < 0)
 181:	83 ec 0c             	sub    $0xc,%esp
 184:	53                   	push   %ebx
 185:	e8 80 04 00 00       	call   60a <close>
 18a:	83 c4 10             	add    $0x10,%esp
 18d:	85 c0                	test   %eax,%eax
 18f:	78 45                	js     1d6 <test1+0x96>
  if (first)
 191:	85 f6                	test   %esi,%esi
 193:	74 12                	je     1a7 <test1+0x67>
    printf(1, "Test 1 passed\n\n");
 195:	83 ec 08             	sub    $0x8,%esp
 198:	68 14 0b 00 00       	push   $0xb14
 19d:	6a 01                	push   $0x1
 19f:	e8 bc 05 00 00       	call   760 <printf>
 1a4:	83 c4 10             	add    $0x10,%esp
}
 1a7:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1aa:	5b                   	pop    %ebx
 1ab:	5e                   	pop    %esi
 1ac:	5d                   	pop    %ebp
 1ad:	c3                   	ret    
 1ae:	66 90                	xchg   %ax,%ax
    printf(1, "Test 1: Write %d bytes\n", NUM_BYTES);
 1b0:	83 ec 04             	sub    $0x4,%esp
 1b3:	68 00 00 80 00       	push   $0x800000
 1b8:	68 c7 0a 00 00       	push   $0xac7
 1bd:	6a 01                	push   $0x1
 1bf:	e8 9c 05 00 00       	call   760 <printf>
 1c4:	83 c4 10             	add    $0x10,%esp
 1c7:	eb 83                	jmp    14c <test1+0xc>
    failed("File open error\n");
 1c9:	83 ec 0c             	sub    $0xc,%esp
 1cc:	68 df 0a 00 00       	push   $0xadf
 1d1:	e8 3a ff ff ff       	call   110 <failed>
    failed("File close error\n");
 1d6:	83 ec 0c             	sub    $0xc,%esp
 1d9:	68 02 0b 00 00       	push   $0xb02
 1de:	e8 2d ff ff ff       	call   110 <failed>
    failed("File write error\n");
 1e3:	83 ec 0c             	sub    $0xc,%esp
 1e6:	68 f0 0a 00 00       	push   $0xaf0
 1eb:	e8 20 ff ff ff       	call   110 <failed>

000001f0 <test2>:
{
 1f0:	55                   	push   %ebp
  for (i = 0; i < NUM_BYTES; i++)
 1f1:	31 c0                	xor    %eax,%eax
{
 1f3:	89 e5                	mov    %esp,%ebp
 1f5:	57                   	push   %edi
 1f6:	56                   	push   %esi
 1f7:	53                   	push   %ebx
 1f8:	83 ec 0c             	sub    $0xc,%esp
 1fb:	90                   	nop
 1fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf2[i] = 0;
 200:	c6 80 80 0f 00 00 00 	movb   $0x0,0xf80(%eax)
  for (i = 0; i < NUM_BYTES; i++)
 207:	83 c0 01             	add    $0x1,%eax
 20a:	3d 00 00 80 00       	cmp    $0x800000,%eax
 20f:	75 ef                	jne    200 <test2+0x10>
  if (first)
 211:	8b 55 08             	mov    0x8(%ebp),%edx
 214:	85 d2                	test   %edx,%edx
 216:	0f 85 e6 00 00 00    	jne    302 <test2+0x112>
  fd = open(filename, O_RDONLY);
 21c:	83 ec 08             	sub    $0x8,%esp
 21f:	6a 00                	push   $0x0
 221:	68 34 0f 00 00       	push   $0xf34
 226:	e8 f7 03 00 00       	call   622 <open>
  if (fd < 0)
 22b:	83 c4 10             	add    $0x10,%esp
 22e:	85 c0                	test   %eax,%eax
  fd = open(filename, O_RDONLY);
 230:	89 c7                	mov    %eax,%edi
  if (fd < 0)
 232:	0f 88 19 01 00 00    	js     351 <test2+0x161>
  if (read(fd, buf2, NUM_BYTES) < 0)
 238:	83 ec 04             	sub    $0x4,%esp
 23b:	68 00 00 80 00       	push   $0x800000
 240:	68 80 0f 00 00       	push   $0xf80
 245:	50                   	push   %eax
 246:	e8 af 03 00 00       	call   5fa <read>
 24b:	83 c4 10             	add    $0x10,%esp
 24e:	85 c0                	test   %eax,%eax
 250:	0f 88 ee 00 00 00    	js     344 <test2+0x154>
    if (buf2[i] != (i % 26) + 'a') {
 256:	0f be 1d 80 0f 00 00 	movsbl 0xf80,%ebx
 25d:	83 fb 61             	cmp    $0x61,%ebx
 260:	0f 85 b8 00 00 00    	jne    31e <test2+0x12e>
  for (i = 0; i < NUM_BYTES; i++) {
 266:	b9 01 00 00 00       	mov    $0x1,%ecx
    if (buf2[i] != (i % 26) + 'a') {
 26b:	be 4f ec c4 4e       	mov    $0x4ec4ec4f,%esi
 270:	89 c8                	mov    %ecx,%eax
 272:	0f be 99 80 0f 00 00 	movsbl 0xf80(%ecx),%ebx
 279:	f7 e6                	mul    %esi
 27b:	89 c8                	mov    %ecx,%eax
 27d:	c1 ea 03             	shr    $0x3,%edx
 280:	6b d2 1a             	imul   $0x1a,%edx,%edx
 283:	29 d0                	sub    %edx,%eax
 285:	83 c0 61             	add    $0x61,%eax
 288:	39 c3                	cmp    %eax,%ebx
 28a:	0f 85 95 00 00 00    	jne    325 <test2+0x135>
  for (i = 0; i < NUM_BYTES; i++) {
 290:	83 c1 01             	add    $0x1,%ecx
 293:	81 f9 00 00 80 00    	cmp    $0x800000,%ecx
 299:	75 d5                	jne    270 <test2+0x80>
  if (close(fd) < 0)
 29b:	83 ec 0c             	sub    $0xc,%esp
 29e:	57                   	push   %edi
 29f:	e8 66 03 00 00       	call   60a <close>
 2a4:	83 c4 10             	add    $0x10,%esp
 2a7:	85 c0                	test   %eax,%eax
 2a9:	0f 88 af 00 00 00    	js     35e <test2+0x16e>
  if (unlink(filename) < 0)
 2af:	83 ec 0c             	sub    $0xc,%esp
 2b2:	68 34 0f 00 00       	push   $0xf34
 2b7:	e8 76 03 00 00       	call   632 <unlink>
 2bc:	83 c4 10             	add    $0x10,%esp
 2bf:	85 c0                	test   %eax,%eax
 2c1:	0f 88 b1 00 00 00    	js     378 <test2+0x188>
  if ((fd = open(filename, O_RDONLY)) >= 0)
 2c7:	83 ec 08             	sub    $0x8,%esp
 2ca:	6a 00                	push   $0x0
 2cc:	68 34 0f 00 00       	push   $0xf34
 2d1:	e8 4c 03 00 00       	call   622 <open>
 2d6:	83 c4 10             	add    $0x10,%esp
 2d9:	85 c0                	test   %eax,%eax
 2db:	0f 89 8a 00 00 00    	jns    36b <test2+0x17b>
  if (first)
 2e1:	8b 45 08             	mov    0x8(%ebp),%eax
 2e4:	85 c0                	test   %eax,%eax
 2e6:	74 12                	je     2fa <test2+0x10a>
    printf(1, "Test 2 passed\n\n");
 2e8:	83 ec 08             	sub    $0x8,%esp
 2eb:	68 70 0b 00 00       	push   $0xb70
 2f0:	6a 01                	push   $0x1
 2f2:	e8 69 04 00 00       	call   760 <printf>
 2f7:	83 c4 10             	add    $0x10,%esp
}
 2fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    
    printf(1, "Test 2: Read %d bytes\n", NUM_BYTES);
 302:	83 ec 04             	sub    $0x4,%esp
 305:	68 00 00 80 00       	push   $0x800000
 30a:	68 24 0b 00 00       	push   $0xb24
 30f:	6a 01                	push   $0x1
 311:	e8 4a 04 00 00       	call   760 <printf>
 316:	83 c4 10             	add    $0x10,%esp
 319:	e9 fe fe ff ff       	jmp    21c <test2+0x2c>
  for (i = 0; i < NUM_BYTES; i++) {
 31e:	31 c9                	xor    %ecx,%ecx
    if (buf2[i] != (i % 26) + 'a') {
 320:	b8 61 00 00 00       	mov    $0x61,%eax
      printf(1, "%dth character, expected %c, found %c\n", i, (i % 26) + 'a', buf2[i]);
 325:	83 ec 0c             	sub    $0xc,%esp
 328:	53                   	push   %ebx
 329:	50                   	push   %eax
 32a:	51                   	push   %ecx
 32b:	68 e0 0b 00 00       	push   $0xbe0
 330:	6a 01                	push   $0x1
 332:	e8 29 04 00 00       	call   760 <printf>
      failed("");
 337:	83 c4 14             	add    $0x14,%esp
 33a:	68 23 0b 00 00       	push   $0xb23
 33f:	e8 cc fd ff ff       	call   110 <failed>
    failed("File read error\n");
 344:	83 ec 0c             	sub    $0xc,%esp
 347:	68 3b 0b 00 00       	push   $0xb3b
 34c:	e8 bf fd ff ff       	call   110 <failed>
    failed("File open error\n");
 351:	83 ec 0c             	sub    $0xc,%esp
 354:	68 df 0a 00 00       	push   $0xadf
 359:	e8 b2 fd ff ff       	call   110 <failed>
    failed("File close error\n");
 35e:	83 ec 0c             	sub    $0xc,%esp
 361:	68 02 0b 00 00       	push   $0xb02
 366:	e8 a5 fd ff ff       	call   110 <failed>
      failed("File not erased\n");
 36b:	83 ec 0c             	sub    $0xc,%esp
 36e:	68 5f 0b 00 00       	push   $0xb5f
 373:	e8 98 fd ff ff       	call   110 <failed>
    failed("File unlink error\n");
 378:	83 ec 0c             	sub    $0xc,%esp
 37b:	68 4c 0b 00 00       	push   $0xb4c
 380:	e8 8b fd ff ff       	call   110 <failed>
 385:	66 90                	xchg   %ax,%ax
 387:	66 90                	xchg   %ax,%ax
 389:	66 90                	xchg   %ax,%ax
 38b:	66 90                	xchg   %ax,%ax
 38d:	66 90                	xchg   %ax,%ax
 38f:	90                   	nop

00000390 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 390:	55                   	push   %ebp
 391:	89 e5                	mov    %esp,%ebp
 393:	53                   	push   %ebx
 394:	8b 45 08             	mov    0x8(%ebp),%eax
 397:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 39a:	89 c2                	mov    %eax,%edx
 39c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 3a0:	83 c1 01             	add    $0x1,%ecx
 3a3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
 3a7:	83 c2 01             	add    $0x1,%edx
 3aa:	84 db                	test   %bl,%bl
 3ac:	88 5a ff             	mov    %bl,-0x1(%edx)
 3af:	75 ef                	jne    3a0 <strcpy+0x10>
    ;
  return os;
}
 3b1:	5b                   	pop    %ebx
 3b2:	5d                   	pop    %ebp
 3b3:	c3                   	ret    
 3b4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 3ba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000003c0 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 3c0:	55                   	push   %ebp
 3c1:	89 e5                	mov    %esp,%ebp
 3c3:	53                   	push   %ebx
 3c4:	8b 55 08             	mov    0x8(%ebp),%edx
 3c7:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 3ca:	0f b6 02             	movzbl (%edx),%eax
 3cd:	0f b6 19             	movzbl (%ecx),%ebx
 3d0:	84 c0                	test   %al,%al
 3d2:	75 1c                	jne    3f0 <strcmp+0x30>
 3d4:	eb 2a                	jmp    400 <strcmp+0x40>
 3d6:	8d 76 00             	lea    0x0(%esi),%esi
 3d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    p++, q++;
 3e0:	83 c2 01             	add    $0x1,%edx
  while(*p && *p == *q)
 3e3:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 3e6:	83 c1 01             	add    $0x1,%ecx
 3e9:	0f b6 19             	movzbl (%ecx),%ebx
  while(*p && *p == *q)
 3ec:	84 c0                	test   %al,%al
 3ee:	74 10                	je     400 <strcmp+0x40>
 3f0:	38 d8                	cmp    %bl,%al
 3f2:	74 ec                	je     3e0 <strcmp+0x20>
  return (uchar)*p - (uchar)*q;
 3f4:	29 d8                	sub    %ebx,%eax
}
 3f6:	5b                   	pop    %ebx
 3f7:	5d                   	pop    %ebp
 3f8:	c3                   	ret    
 3f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 400:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
 402:	29 d8                	sub    %ebx,%eax
}
 404:	5b                   	pop    %ebx
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    
 407:	89 f6                	mov    %esi,%esi
 409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000410 <strlen>:

uint
strlen(const char *s)
{
 410:	55                   	push   %ebp
 411:	89 e5                	mov    %esp,%ebp
 413:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 416:	80 39 00             	cmpb   $0x0,(%ecx)
 419:	74 15                	je     430 <strlen+0x20>
 41b:	31 d2                	xor    %edx,%edx
 41d:	8d 76 00             	lea    0x0(%esi),%esi
 420:	83 c2 01             	add    $0x1,%edx
 423:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 427:	89 d0                	mov    %edx,%eax
 429:	75 f5                	jne    420 <strlen+0x10>
    ;
  return n;
}
 42b:	5d                   	pop    %ebp
 42c:	c3                   	ret    
 42d:	8d 76 00             	lea    0x0(%esi),%esi
  for(n = 0; s[n]; n++)
 430:	31 c0                	xor    %eax,%eax
}
 432:	5d                   	pop    %ebp
 433:	c3                   	ret    
 434:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 43a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000440 <memset>:

void*
memset(void *dst, int c, uint n)
{
 440:	55                   	push   %ebp
 441:	89 e5                	mov    %esp,%ebp
 443:	57                   	push   %edi
 444:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 447:	8b 4d 10             	mov    0x10(%ebp),%ecx
 44a:	8b 45 0c             	mov    0xc(%ebp),%eax
 44d:	89 d7                	mov    %edx,%edi
 44f:	fc                   	cld    
 450:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 452:	89 d0                	mov    %edx,%eax
 454:	5f                   	pop    %edi
 455:	5d                   	pop    %ebp
 456:	c3                   	ret    
 457:	89 f6                	mov    %esi,%esi
 459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000460 <strchr>:

char*
strchr(const char *s, char c)
{
 460:	55                   	push   %ebp
 461:	89 e5                	mov    %esp,%ebp
 463:	53                   	push   %ebx
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  for(; *s; s++)
 46a:	0f b6 10             	movzbl (%eax),%edx
 46d:	84 d2                	test   %dl,%dl
 46f:	74 1d                	je     48e <strchr+0x2e>
    if(*s == c)
 471:	38 d3                	cmp    %dl,%bl
 473:	89 d9                	mov    %ebx,%ecx
 475:	75 0d                	jne    484 <strchr+0x24>
 477:	eb 17                	jmp    490 <strchr+0x30>
 479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 480:	38 ca                	cmp    %cl,%dl
 482:	74 0c                	je     490 <strchr+0x30>
  for(; *s; s++)
 484:	83 c0 01             	add    $0x1,%eax
 487:	0f b6 10             	movzbl (%eax),%edx
 48a:	84 d2                	test   %dl,%dl
 48c:	75 f2                	jne    480 <strchr+0x20>
      return (char*)s;
  return 0;
 48e:	31 c0                	xor    %eax,%eax
}
 490:	5b                   	pop    %ebx
 491:	5d                   	pop    %ebp
 492:	c3                   	ret    
 493:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 499:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000004a0 <gets>:

char*
gets(char *buf, int max)
{
 4a0:	55                   	push   %ebp
 4a1:	89 e5                	mov    %esp,%ebp
 4a3:	57                   	push   %edi
 4a4:	56                   	push   %esi
 4a5:	53                   	push   %ebx
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 4a6:	31 f6                	xor    %esi,%esi
 4a8:	89 f3                	mov    %esi,%ebx
{
 4aa:	83 ec 1c             	sub    $0x1c,%esp
 4ad:	8b 7d 08             	mov    0x8(%ebp),%edi
  for(i=0; i+1 < max; ){
 4b0:	eb 2f                	jmp    4e1 <gets+0x41>
 4b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    cc = read(0, &c, 1);
 4b8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 4bb:	83 ec 04             	sub    $0x4,%esp
 4be:	6a 01                	push   $0x1
 4c0:	50                   	push   %eax
 4c1:	6a 00                	push   $0x0
 4c3:	e8 32 01 00 00       	call   5fa <read>
    if(cc < 1)
 4c8:	83 c4 10             	add    $0x10,%esp
 4cb:	85 c0                	test   %eax,%eax
 4cd:	7e 1c                	jle    4eb <gets+0x4b>
      break;
    buf[i++] = c;
 4cf:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 4d3:	83 c7 01             	add    $0x1,%edi
 4d6:	88 47 ff             	mov    %al,-0x1(%edi)
    if(c == '\n' || c == '\r')
 4d9:	3c 0a                	cmp    $0xa,%al
 4db:	74 23                	je     500 <gets+0x60>
 4dd:	3c 0d                	cmp    $0xd,%al
 4df:	74 1f                	je     500 <gets+0x60>
  for(i=0; i+1 < max; ){
 4e1:	83 c3 01             	add    $0x1,%ebx
 4e4:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 4e7:	89 fe                	mov    %edi,%esi
 4e9:	7c cd                	jl     4b8 <gets+0x18>
 4eb:	89 f3                	mov    %esi,%ebx
      break;
  }
  buf[i] = '\0';
  return buf;
}
 4ed:	8b 45 08             	mov    0x8(%ebp),%eax
  buf[i] = '\0';
 4f0:	c6 03 00             	movb   $0x0,(%ebx)
}
 4f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4f6:	5b                   	pop    %ebx
 4f7:	5e                   	pop    %esi
 4f8:	5f                   	pop    %edi
 4f9:	5d                   	pop    %ebp
 4fa:	c3                   	ret    
 4fb:	90                   	nop
 4fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 500:	8b 75 08             	mov    0x8(%ebp),%esi
 503:	8b 45 08             	mov    0x8(%ebp),%eax
 506:	01 de                	add    %ebx,%esi
 508:	89 f3                	mov    %esi,%ebx
  buf[i] = '\0';
 50a:	c6 03 00             	movb   $0x0,(%ebx)
}
 50d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 510:	5b                   	pop    %ebx
 511:	5e                   	pop    %esi
 512:	5f                   	pop    %edi
 513:	5d                   	pop    %ebp
 514:	c3                   	ret    
 515:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
 519:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000520 <stat>:

int
stat(const char *n, struct stat *st)
{
 520:	55                   	push   %ebp
 521:	89 e5                	mov    %esp,%ebp
 523:	56                   	push   %esi
 524:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 525:	83 ec 08             	sub    $0x8,%esp
 528:	6a 00                	push   $0x0
 52a:	ff 75 08             	pushl  0x8(%ebp)
 52d:	e8 f0 00 00 00       	call   622 <open>
  if(fd < 0)
 532:	83 c4 10             	add    $0x10,%esp
 535:	85 c0                	test   %eax,%eax
 537:	78 27                	js     560 <stat+0x40>
    return -1;
  r = fstat(fd, st);
 539:	83 ec 08             	sub    $0x8,%esp
 53c:	ff 75 0c             	pushl  0xc(%ebp)
 53f:	89 c3                	mov    %eax,%ebx
 541:	50                   	push   %eax
 542:	e8 f3 00 00 00       	call   63a <fstat>
  close(fd);
 547:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
 54a:	89 c6                	mov    %eax,%esi
  close(fd);
 54c:	e8 b9 00 00 00       	call   60a <close>
  return r;
 551:	83 c4 10             	add    $0x10,%esp
}
 554:	8d 65 f8             	lea    -0x8(%ebp),%esp
 557:	89 f0                	mov    %esi,%eax
 559:	5b                   	pop    %ebx
 55a:	5e                   	pop    %esi
 55b:	5d                   	pop    %ebp
 55c:	c3                   	ret    
 55d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
 560:	be ff ff ff ff       	mov    $0xffffffff,%esi
 565:	eb ed                	jmp    554 <stat+0x34>
 567:	89 f6                	mov    %esi,%esi
 569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000570 <atoi>:

int
atoi(const char *s)
{
 570:	55                   	push   %ebp
 571:	89 e5                	mov    %esp,%ebp
 573:	53                   	push   %ebx
 574:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 577:	0f be 11             	movsbl (%ecx),%edx
 57a:	8d 42 d0             	lea    -0x30(%edx),%eax
 57d:	3c 09                	cmp    $0x9,%al
  n = 0;
 57f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 584:	77 1f                	ja     5a5 <atoi+0x35>
 586:	8d 76 00             	lea    0x0(%esi),%esi
 589:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    n = n*10 + *s++ - '0';
 590:	8d 04 80             	lea    (%eax,%eax,4),%eax
 593:	83 c1 01             	add    $0x1,%ecx
 596:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
  while('0' <= *s && *s <= '9')
 59a:	0f be 11             	movsbl (%ecx),%edx
 59d:	8d 5a d0             	lea    -0x30(%edx),%ebx
 5a0:	80 fb 09             	cmp    $0x9,%bl
 5a3:	76 eb                	jbe    590 <atoi+0x20>
  return n;
}
 5a5:	5b                   	pop    %ebx
 5a6:	5d                   	pop    %ebp
 5a7:	c3                   	ret    
 5a8:	90                   	nop
 5a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

000005b0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 5b0:	55                   	push   %ebp
 5b1:	89 e5                	mov    %esp,%ebp
 5b3:	56                   	push   %esi
 5b4:	53                   	push   %ebx
 5b5:	8b 5d 10             	mov    0x10(%ebp),%ebx
 5b8:	8b 45 08             	mov    0x8(%ebp),%eax
 5bb:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 5be:	85 db                	test   %ebx,%ebx
 5c0:	7e 14                	jle    5d6 <memmove+0x26>
 5c2:	31 d2                	xor    %edx,%edx
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 5c8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 5cc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 5cf:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0)
 5d2:	39 d3                	cmp    %edx,%ebx
 5d4:	75 f2                	jne    5c8 <memmove+0x18>
  return vdst;
}
 5d6:	5b                   	pop    %ebx
 5d7:	5e                   	pop    %esi
 5d8:	5d                   	pop    %ebp
 5d9:	c3                   	ret    

000005da <fork>:
  name: \ 
    movl $SYS_ ## name, %eax; \ 
    int $T_SYSCALL; \ 
    ret

SYSCALL(fork)
 5da:	b8 01 00 00 00       	mov    $0x1,%eax
 5df:	cd 40                	int    $0x40
 5e1:	c3                   	ret    

000005e2 <exit>:
SYSCALL(exit)
 5e2:	b8 02 00 00 00       	mov    $0x2,%eax
 5e7:	cd 40                	int    $0x40
 5e9:	c3                   	ret    

000005ea <wait>:
SYSCALL(wait)
 5ea:	b8 03 00 00 00       	mov    $0x3,%eax
 5ef:	cd 40                	int    $0x40
 5f1:	c3                   	ret    

000005f2 <pipe>:
SYSCALL(pipe)
 5f2:	b8 04 00 00 00       	mov    $0x4,%eax
 5f7:	cd 40                	int    $0x40
 5f9:	c3                   	ret    

000005fa <read>:
SYSCALL(read)
 5fa:	b8 05 00 00 00       	mov    $0x5,%eax
 5ff:	cd 40                	int    $0x40
 601:	c3                   	ret    

00000602 <write>:
SYSCALL(write)
 602:	b8 10 00 00 00       	mov    $0x10,%eax
 607:	cd 40                	int    $0x40
 609:	c3                   	ret    

0000060a <close>:
SYSCALL(close)
 60a:	b8 15 00 00 00       	mov    $0x15,%eax
 60f:	cd 40                	int    $0x40
 611:	c3                   	ret    

00000612 <kill>:
SYSCALL(kill)
 612:	b8 06 00 00 00       	mov    $0x6,%eax
 617:	cd 40                	int    $0x40
 619:	c3                   	ret    

0000061a <exec>:
SYSCALL(exec)
 61a:	b8 07 00 00 00       	mov    $0x7,%eax
 61f:	cd 40                	int    $0x40
 621:	c3                   	ret    

00000622 <open>:
SYSCALL(open)
 622:	b8 0f 00 00 00       	mov    $0xf,%eax
 627:	cd 40                	int    $0x40
 629:	c3                   	ret    

0000062a <mknod>:
SYSCALL(mknod)
 62a:	b8 11 00 00 00       	mov    $0x11,%eax
 62f:	cd 40                	int    $0x40
 631:	c3                   	ret    

00000632 <unlink>:
SYSCALL(unlink)
 632:	b8 12 00 00 00       	mov    $0x12,%eax
 637:	cd 40                	int    $0x40
 639:	c3                   	ret    

0000063a <fstat>:
SYSCALL(fstat)
 63a:	b8 08 00 00 00       	mov    $0x8,%eax
 63f:	cd 40                	int    $0x40
 641:	c3                   	ret    

00000642 <link>:
SYSCALL(link)
 642:	b8 13 00 00 00       	mov    $0x13,%eax
 647:	cd 40                	int    $0x40
 649:	c3                   	ret    

0000064a <mkdir>:
SYSCALL(mkdir)
 64a:	b8 14 00 00 00       	mov    $0x14,%eax
 64f:	cd 40                	int    $0x40
 651:	c3                   	ret    

00000652 <chdir>:
SYSCALL(chdir)
 652:	b8 09 00 00 00       	mov    $0x9,%eax
 657:	cd 40                	int    $0x40
 659:	c3                   	ret    

0000065a <dup>:
SYSCALL(dup)
 65a:	b8 0a 00 00 00       	mov    $0xa,%eax
 65f:	cd 40                	int    $0x40
 661:	c3                   	ret    

00000662 <getpid>:
SYSCALL(getpid)
 662:	b8 0b 00 00 00       	mov    $0xb,%eax
 667:	cd 40                	int    $0x40
 669:	c3                   	ret    

0000066a <sbrk>:
SYSCALL(sbrk)
 66a:	b8 0c 00 00 00       	mov    $0xc,%eax
 66f:	cd 40                	int    $0x40
 671:	c3                   	ret    

00000672 <sleep>:
SYSCALL(sleep)
 672:	b8 0d 00 00 00       	mov    $0xd,%eax
 677:	cd 40                	int    $0x40
 679:	c3                   	ret    

0000067a <uptime>:
SYSCALL(uptime)
 67a:	b8 0e 00 00 00       	mov    $0xe,%eax
 67f:	cd 40                	int    $0x40
 681:	c3                   	ret    

00000682 <myfunction>:
SYSCALL(myfunction)
 682:	b8 16 00 00 00       	mov    $0x16,%eax
 687:	cd 40                	int    $0x40
 689:	c3                   	ret    

0000068a <getppid>:
SYSCALL(getppid)
 68a:	b8 17 00 00 00       	mov    $0x17,%eax
 68f:	cd 40                	int    $0x40
 691:	c3                   	ret    

00000692 <yield>:
SYSCALL(yield)
 692:	b8 18 00 00 00       	mov    $0x18,%eax
 697:	cd 40                	int    $0x40
 699:	c3                   	ret    

0000069a <getlev>:
SYSCALL(getlev)
 69a:	b8 19 00 00 00       	mov    $0x19,%eax
 69f:	cd 40                	int    $0x40
 6a1:	c3                   	ret    

000006a2 <setpriority>:
SYSCALL(setpriority)
 6a2:	b8 1a 00 00 00       	mov    $0x1a,%eax
 6a7:	cd 40                	int    $0x40
 6a9:	c3                   	ret    

000006aa <monopolize>:
SYSCALL(monopolize)
 6aa:	b8 1b 00 00 00       	mov    $0x1b,%eax
 6af:	cd 40                	int    $0x40
 6b1:	c3                   	ret    
 6b2:	66 90                	xchg   %ax,%ax
 6b4:	66 90                	xchg   %ax,%ax
 6b6:	66 90                	xchg   %ax,%ax
 6b8:	66 90                	xchg   %ax,%ax
 6ba:	66 90                	xchg   %ax,%ax
 6bc:	66 90                	xchg   %ax,%ax
 6be:	66 90                	xchg   %ax,%ax

000006c0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 6c0:	55                   	push   %ebp
 6c1:	89 e5                	mov    %esp,%ebp
 6c3:	57                   	push   %edi
 6c4:	56                   	push   %esi
 6c5:	53                   	push   %ebx
 6c6:	83 ec 3c             	sub    $0x3c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 6c9:	85 d2                	test   %edx,%edx
{
 6cb:	89 45 c0             	mov    %eax,-0x40(%ebp)
    neg = 1;
    x = -xx;
 6ce:	89 d0                	mov    %edx,%eax
  if(sgn && xx < 0){
 6d0:	79 76                	jns    748 <printint+0x88>
 6d2:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
 6d6:	74 70                	je     748 <printint+0x88>
    x = -xx;
 6d8:	f7 d8                	neg    %eax
    neg = 1;
 6da:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 6e1:	31 f6                	xor    %esi,%esi
 6e3:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 6e6:	eb 0a                	jmp    6f2 <printint+0x32>
 6e8:	90                   	nop
 6e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  do{
    buf[i++] = digits[x % base];
 6f0:	89 fe                	mov    %edi,%esi
 6f2:	31 d2                	xor    %edx,%edx
 6f4:	8d 7e 01             	lea    0x1(%esi),%edi
 6f7:	f7 f1                	div    %ecx
 6f9:	0f b6 92 14 0c 00 00 	movzbl 0xc14(%edx),%edx
  }while((x /= base) != 0);
 700:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
 702:	88 14 3b             	mov    %dl,(%ebx,%edi,1)
  }while((x /= base) != 0);
 705:	75 e9                	jne    6f0 <printint+0x30>
  if(neg)
 707:	8b 45 c4             	mov    -0x3c(%ebp),%eax
 70a:	85 c0                	test   %eax,%eax
 70c:	74 08                	je     716 <printint+0x56>
    buf[i++] = '-';
 70e:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
 713:	8d 7e 02             	lea    0x2(%esi),%edi
 716:	8d 74 3d d7          	lea    -0x29(%ebp,%edi,1),%esi
 71a:	8b 7d c0             	mov    -0x40(%ebp),%edi
 71d:	8d 76 00             	lea    0x0(%esi),%esi
 720:	0f b6 06             	movzbl (%esi),%eax
  write(fd, &c, 1);
 723:	83 ec 04             	sub    $0x4,%esp
 726:	83 ee 01             	sub    $0x1,%esi
 729:	6a 01                	push   $0x1
 72b:	53                   	push   %ebx
 72c:	57                   	push   %edi
 72d:	88 45 d7             	mov    %al,-0x29(%ebp)
 730:	e8 cd fe ff ff       	call   602 <write>

  while(--i >= 0)
 735:	83 c4 10             	add    $0x10,%esp
 738:	39 de                	cmp    %ebx,%esi
 73a:	75 e4                	jne    720 <printint+0x60>
    putc(fd, buf[i]);
}
 73c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 73f:	5b                   	pop    %ebx
 740:	5e                   	pop    %esi
 741:	5f                   	pop    %edi
 742:	5d                   	pop    %ebp
 743:	c3                   	ret    
 744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
 748:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 74f:	eb 90                	jmp    6e1 <printint+0x21>
 751:	eb 0d                	jmp    760 <printf>
 753:	90                   	nop
 754:	90                   	nop
 755:	90                   	nop
 756:	90                   	nop
 757:	90                   	nop
 758:	90                   	nop
 759:	90                   	nop
 75a:	90                   	nop
 75b:	90                   	nop
 75c:	90                   	nop
 75d:	90                   	nop
 75e:	90                   	nop
 75f:	90                   	nop

00000760 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 760:	55                   	push   %ebp
 761:	89 e5                	mov    %esp,%ebp
 763:	57                   	push   %edi
 764:	56                   	push   %esi
 765:	53                   	push   %ebx
 766:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 769:	8b 75 0c             	mov    0xc(%ebp),%esi
 76c:	0f b6 1e             	movzbl (%esi),%ebx
 76f:	84 db                	test   %bl,%bl
 771:	0f 84 b3 00 00 00    	je     82a <printf+0xca>
  ap = (uint*)(void*)&fmt + 1;
 777:	8d 45 10             	lea    0x10(%ebp),%eax
 77a:	83 c6 01             	add    $0x1,%esi
  state = 0;
 77d:	31 ff                	xor    %edi,%edi
  ap = (uint*)(void*)&fmt + 1;
 77f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 782:	eb 2f                	jmp    7b3 <printf+0x53>
 784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 788:	83 f8 25             	cmp    $0x25,%eax
 78b:	0f 84 a7 00 00 00    	je     838 <printf+0xd8>
  write(fd, &c, 1);
 791:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 794:	83 ec 04             	sub    $0x4,%esp
 797:	88 5d e2             	mov    %bl,-0x1e(%ebp)
 79a:	6a 01                	push   $0x1
 79c:	50                   	push   %eax
 79d:	ff 75 08             	pushl  0x8(%ebp)
 7a0:	e8 5d fe ff ff       	call   602 <write>
 7a5:	83 c4 10             	add    $0x10,%esp
 7a8:	83 c6 01             	add    $0x1,%esi
  for(i = 0; fmt[i]; i++){
 7ab:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
 7af:	84 db                	test   %bl,%bl
 7b1:	74 77                	je     82a <printf+0xca>
    if(state == 0){
 7b3:	85 ff                	test   %edi,%edi
    c = fmt[i] & 0xff;
 7b5:	0f be cb             	movsbl %bl,%ecx
 7b8:	0f b6 c3             	movzbl %bl,%eax
    if(state == 0){
 7bb:	74 cb                	je     788 <printf+0x28>
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 7bd:	83 ff 25             	cmp    $0x25,%edi
 7c0:	75 e6                	jne    7a8 <printf+0x48>
      if(c == 'd'){
 7c2:	83 f8 64             	cmp    $0x64,%eax
 7c5:	0f 84 05 01 00 00    	je     8d0 <printf+0x170>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 7cb:	81 e1 f7 00 00 00    	and    $0xf7,%ecx
 7d1:	83 f9 70             	cmp    $0x70,%ecx
 7d4:	74 72                	je     848 <printf+0xe8>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 7d6:	83 f8 73             	cmp    $0x73,%eax
 7d9:	0f 84 99 00 00 00    	je     878 <printf+0x118>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 7df:	83 f8 63             	cmp    $0x63,%eax
 7e2:	0f 84 08 01 00 00    	je     8f0 <printf+0x190>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 7e8:	83 f8 25             	cmp    $0x25,%eax
 7eb:	0f 84 ef 00 00 00    	je     8e0 <printf+0x180>
  write(fd, &c, 1);
 7f1:	8d 45 e7             	lea    -0x19(%ebp),%eax
 7f4:	83 ec 04             	sub    $0x4,%esp
 7f7:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
 7fb:	6a 01                	push   $0x1
 7fd:	50                   	push   %eax
 7fe:	ff 75 08             	pushl  0x8(%ebp)
 801:	e8 fc fd ff ff       	call   602 <write>
 806:	83 c4 0c             	add    $0xc,%esp
 809:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 80c:	88 5d e6             	mov    %bl,-0x1a(%ebp)
 80f:	6a 01                	push   $0x1
 811:	50                   	push   %eax
 812:	ff 75 08             	pushl  0x8(%ebp)
 815:	83 c6 01             	add    $0x1,%esi
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 818:	31 ff                	xor    %edi,%edi
  write(fd, &c, 1);
 81a:	e8 e3 fd ff ff       	call   602 <write>
  for(i = 0; fmt[i]; i++){
 81f:	0f b6 5e ff          	movzbl -0x1(%esi),%ebx
  write(fd, &c, 1);
 823:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
 826:	84 db                	test   %bl,%bl
 828:	75 89                	jne    7b3 <printf+0x53>
    }
  }
}
 82a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 82d:	5b                   	pop    %ebx
 82e:	5e                   	pop    %esi
 82f:	5f                   	pop    %edi
 830:	5d                   	pop    %ebp
 831:	c3                   	ret    
 832:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        state = '%';
 838:	bf 25 00 00 00       	mov    $0x25,%edi
 83d:	e9 66 ff ff ff       	jmp    7a8 <printf+0x48>
 842:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
 848:	83 ec 0c             	sub    $0xc,%esp
 84b:	b9 10 00 00 00       	mov    $0x10,%ecx
 850:	6a 00                	push   $0x0
 852:	8b 7d d4             	mov    -0x2c(%ebp),%edi
 855:	8b 45 08             	mov    0x8(%ebp),%eax
 858:	8b 17                	mov    (%edi),%edx
 85a:	e8 61 fe ff ff       	call   6c0 <printint>
        ap++;
 85f:	89 f8                	mov    %edi,%eax
 861:	83 c4 10             	add    $0x10,%esp
      state = 0;
 864:	31 ff                	xor    %edi,%edi
        ap++;
 866:	83 c0 04             	add    $0x4,%eax
 869:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 86c:	e9 37 ff ff ff       	jmp    7a8 <printf+0x48>
 871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
 878:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 87b:	8b 08                	mov    (%eax),%ecx
        ap++;
 87d:	83 c0 04             	add    $0x4,%eax
 880:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        if(s == 0)
 883:	85 c9                	test   %ecx,%ecx
 885:	0f 84 8e 00 00 00    	je     919 <printf+0x1b9>
        while(*s != 0){
 88b:	0f b6 01             	movzbl (%ecx),%eax
      state = 0;
 88e:	31 ff                	xor    %edi,%edi
        s = (char*)*ap;
 890:	89 cb                	mov    %ecx,%ebx
        while(*s != 0){
 892:	84 c0                	test   %al,%al
 894:	0f 84 0e ff ff ff    	je     7a8 <printf+0x48>
 89a:	89 75 d0             	mov    %esi,-0x30(%ebp)
 89d:	89 de                	mov    %ebx,%esi
 89f:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a2:	8d 7d e3             	lea    -0x1d(%ebp),%edi
 8a5:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
 8a8:	83 ec 04             	sub    $0x4,%esp
          s++;
 8ab:	83 c6 01             	add    $0x1,%esi
 8ae:	88 45 e3             	mov    %al,-0x1d(%ebp)
  write(fd, &c, 1);
 8b1:	6a 01                	push   $0x1
 8b3:	57                   	push   %edi
 8b4:	53                   	push   %ebx
 8b5:	e8 48 fd ff ff       	call   602 <write>
        while(*s != 0){
 8ba:	0f b6 06             	movzbl (%esi),%eax
 8bd:	83 c4 10             	add    $0x10,%esp
 8c0:	84 c0                	test   %al,%al
 8c2:	75 e4                	jne    8a8 <printf+0x148>
 8c4:	8b 75 d0             	mov    -0x30(%ebp),%esi
      state = 0;
 8c7:	31 ff                	xor    %edi,%edi
 8c9:	e9 da fe ff ff       	jmp    7a8 <printf+0x48>
 8ce:	66 90                	xchg   %ax,%ax
        printint(fd, *ap, 10, 1);
 8d0:	83 ec 0c             	sub    $0xc,%esp
 8d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 8d8:	6a 01                	push   $0x1
 8da:	e9 73 ff ff ff       	jmp    852 <printf+0xf2>
 8df:	90                   	nop
  write(fd, &c, 1);
 8e0:	83 ec 04             	sub    $0x4,%esp
 8e3:	88 5d e5             	mov    %bl,-0x1b(%ebp)
 8e6:	8d 45 e5             	lea    -0x1b(%ebp),%eax
 8e9:	6a 01                	push   $0x1
 8eb:	e9 21 ff ff ff       	jmp    811 <printf+0xb1>
        putc(fd, *ap);
 8f0:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  write(fd, &c, 1);
 8f3:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
 8f6:	8b 07                	mov    (%edi),%eax
  write(fd, &c, 1);
 8f8:	6a 01                	push   $0x1
        ap++;
 8fa:	83 c7 04             	add    $0x4,%edi
        putc(fd, *ap);
 8fd:	88 45 e4             	mov    %al,-0x1c(%ebp)
  write(fd, &c, 1);
 900:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 903:	50                   	push   %eax
 904:	ff 75 08             	pushl  0x8(%ebp)
 907:	e8 f6 fc ff ff       	call   602 <write>
        ap++;
 90c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
 90f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 912:	31 ff                	xor    %edi,%edi
 914:	e9 8f fe ff ff       	jmp    7a8 <printf+0x48>
          s = "(null)";
 919:	bb 0c 0c 00 00       	mov    $0xc0c,%ebx
        while(*s != 0){
 91e:	b8 28 00 00 00       	mov    $0x28,%eax
 923:	e9 72 ff ff ff       	jmp    89a <printf+0x13a>
 928:	66 90                	xchg   %ax,%ax
 92a:	66 90                	xchg   %ax,%ax
 92c:	66 90                	xchg   %ax,%ax
 92e:	66 90                	xchg   %ax,%ax

00000930 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 930:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 931:	a1 60 0f 00 00       	mov    0xf60,%eax
{
 936:	89 e5                	mov    %esp,%ebp
 938:	57                   	push   %edi
 939:	56                   	push   %esi
 93a:	53                   	push   %ebx
 93b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
 93e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
 941:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 948:	39 c8                	cmp    %ecx,%eax
 94a:	8b 10                	mov    (%eax),%edx
 94c:	73 32                	jae    980 <free+0x50>
 94e:	39 d1                	cmp    %edx,%ecx
 950:	72 04                	jb     956 <free+0x26>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 952:	39 d0                	cmp    %edx,%eax
 954:	72 32                	jb     988 <free+0x58>
      break;
  if(bp + bp->s.size == p->s.ptr){
 956:	8b 73 fc             	mov    -0x4(%ebx),%esi
 959:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 95c:	39 fa                	cmp    %edi,%edx
 95e:	74 30                	je     990 <free+0x60>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 960:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 963:	8b 50 04             	mov    0x4(%eax),%edx
 966:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 969:	39 f1                	cmp    %esi,%ecx
 96b:	74 3a                	je     9a7 <free+0x77>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 96d:	89 08                	mov    %ecx,(%eax)
  freep = p;
 96f:	a3 60 0f 00 00       	mov    %eax,0xf60
}
 974:	5b                   	pop    %ebx
 975:	5e                   	pop    %esi
 976:	5f                   	pop    %edi
 977:	5d                   	pop    %ebp
 978:	c3                   	ret    
 979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 980:	39 d0                	cmp    %edx,%eax
 982:	72 04                	jb     988 <free+0x58>
 984:	39 d1                	cmp    %edx,%ecx
 986:	72 ce                	jb     956 <free+0x26>
{
 988:	89 d0                	mov    %edx,%eax
 98a:	eb bc                	jmp    948 <free+0x18>
 98c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    bp->s.size += p->s.ptr->s.size;
 990:	03 72 04             	add    0x4(%edx),%esi
 993:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 996:	8b 10                	mov    (%eax),%edx
 998:	8b 12                	mov    (%edx),%edx
 99a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 99d:	8b 50 04             	mov    0x4(%eax),%edx
 9a0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 9a3:	39 f1                	cmp    %esi,%ecx
 9a5:	75 c6                	jne    96d <free+0x3d>
    p->s.size += bp->s.size;
 9a7:	03 53 fc             	add    -0x4(%ebx),%edx
  freep = p;
 9aa:	a3 60 0f 00 00       	mov    %eax,0xf60
    p->s.size += bp->s.size;
 9af:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 9b2:	8b 53 f8             	mov    -0x8(%ebx),%edx
 9b5:	89 10                	mov    %edx,(%eax)
}
 9b7:	5b                   	pop    %ebx
 9b8:	5e                   	pop    %esi
 9b9:	5f                   	pop    %edi
 9ba:	5d                   	pop    %ebp
 9bb:	c3                   	ret    
 9bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

000009c0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9c0:	55                   	push   %ebp
 9c1:	89 e5                	mov    %esp,%ebp
 9c3:	57                   	push   %edi
 9c4:	56                   	push   %esi
 9c5:	53                   	push   %ebx
 9c6:	83 ec 0c             	sub    $0xc,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9c9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 9cc:	8b 15 60 0f 00 00    	mov    0xf60,%edx
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9d2:	8d 78 07             	lea    0x7(%eax),%edi
 9d5:	c1 ef 03             	shr    $0x3,%edi
 9d8:	83 c7 01             	add    $0x1,%edi
  if((prevp = freep) == 0){
 9db:	85 d2                	test   %edx,%edx
 9dd:	0f 84 9d 00 00 00    	je     a80 <malloc+0xc0>
 9e3:	8b 02                	mov    (%edx),%eax
 9e5:	8b 48 04             	mov    0x4(%eax),%ecx
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 9e8:	39 cf                	cmp    %ecx,%edi
 9ea:	76 6c                	jbe    a58 <malloc+0x98>
 9ec:	81 ff 00 10 00 00    	cmp    $0x1000,%edi
 9f2:	bb 00 10 00 00       	mov    $0x1000,%ebx
 9f7:	0f 43 df             	cmovae %edi,%ebx
  p = sbrk(nu * sizeof(Header));
 9fa:	8d 34 dd 00 00 00 00 	lea    0x0(,%ebx,8),%esi
 a01:	eb 0e                	jmp    a11 <malloc+0x51>
 a03:	90                   	nop
 a04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a08:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 a0a:	8b 48 04             	mov    0x4(%eax),%ecx
 a0d:	39 f9                	cmp    %edi,%ecx
 a0f:	73 47                	jae    a58 <malloc+0x98>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a11:	39 05 60 0f 00 00    	cmp    %eax,0xf60
 a17:	89 c2                	mov    %eax,%edx
 a19:	75 ed                	jne    a08 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
 a1b:	83 ec 0c             	sub    $0xc,%esp
 a1e:	56                   	push   %esi
 a1f:	e8 46 fc ff ff       	call   66a <sbrk>
  if(p == (char*)-1)
 a24:	83 c4 10             	add    $0x10,%esp
 a27:	83 f8 ff             	cmp    $0xffffffff,%eax
 a2a:	74 1c                	je     a48 <malloc+0x88>
  hp->s.size = nu;
 a2c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 a2f:	83 ec 0c             	sub    $0xc,%esp
 a32:	83 c0 08             	add    $0x8,%eax
 a35:	50                   	push   %eax
 a36:	e8 f5 fe ff ff       	call   930 <free>
  return freep;
 a3b:	8b 15 60 0f 00 00    	mov    0xf60,%edx
      if((p = morecore(nunits)) == 0)
 a41:	83 c4 10             	add    $0x10,%esp
 a44:	85 d2                	test   %edx,%edx
 a46:	75 c0                	jne    a08 <malloc+0x48>
        return 0;
  }
}
 a48:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
 a4b:	31 c0                	xor    %eax,%eax
}
 a4d:	5b                   	pop    %ebx
 a4e:	5e                   	pop    %esi
 a4f:	5f                   	pop    %edi
 a50:	5d                   	pop    %ebp
 a51:	c3                   	ret    
 a52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
 a58:	39 cf                	cmp    %ecx,%edi
 a5a:	74 54                	je     ab0 <malloc+0xf0>
        p->s.size -= nunits;
 a5c:	29 f9                	sub    %edi,%ecx
 a5e:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
 a61:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
 a64:	89 78 04             	mov    %edi,0x4(%eax)
      freep = prevp;
 a67:	89 15 60 0f 00 00    	mov    %edx,0xf60
}
 a6d:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
 a70:	83 c0 08             	add    $0x8,%eax
}
 a73:	5b                   	pop    %ebx
 a74:	5e                   	pop    %esi
 a75:	5f                   	pop    %edi
 a76:	5d                   	pop    %ebp
 a77:	c3                   	ret    
 a78:	90                   	nop
 a79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    base.s.ptr = freep = prevp = &base;
 a80:	c7 05 60 0f 00 00 64 	movl   $0xf64,0xf60
 a87:	0f 00 00 
 a8a:	c7 05 64 0f 00 00 64 	movl   $0xf64,0xf64
 a91:	0f 00 00 
    base.s.size = 0;
 a94:	b8 64 0f 00 00       	mov    $0xf64,%eax
 a99:	c7 05 68 0f 00 00 00 	movl   $0x0,0xf68
 aa0:	00 00 00 
 aa3:	e9 44 ff ff ff       	jmp    9ec <malloc+0x2c>
 aa8:	90                   	nop
 aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        prevp->s.ptr = p->s.ptr;
 ab0:	8b 08                	mov    (%eax),%ecx
 ab2:	89 0a                	mov    %ecx,(%edx)
 ab4:	eb b1                	jmp    a67 <malloc+0xa7>
