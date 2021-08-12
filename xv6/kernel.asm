
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 a0 10 00       	mov    $0x10a000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc f0 c7 10 80       	mov    $0x8010c7f0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 50 30 10 80       	mov    $0x80103050,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 34 c8 10 80       	mov    $0x8010c834,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 40 76 10 80       	push   $0x80107640
80100051:	68 00 c8 10 80       	push   $0x8010c800
80100056:	e8 c5 47 00 00       	call   80104820 <initlock>
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 4c 0f 11 80 fc 	movl   $0x80110efc,0x80110f4c
80100062:	0e 11 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 50 0f 11 80 fc 	movl   $0x80110efc,0x80110f50
8010006c:	0e 11 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba fc 0e 11 80       	mov    $0x80110efc,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 fc 0e 11 80 	movl   $0x80110efc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 47 76 10 80       	push   $0x80107647
80100097:	50                   	push   %eax
80100098:	e8 53 46 00 00       	call   801046f0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 50 0f 11 80       	mov    0x80110f50,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    bcache.head.next = b;
801000b0:	89 1d 50 0f 11 80    	mov    %ebx,0x80110f50
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d fc 0e 11 80       	cmp    $0x80110efc,%eax
801000bb:	72 c3                	jb     80100080 <binit+0x40>
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  acquire(&bcache.lock);
801000df:	68 00 c8 10 80       	push   $0x8010c800
801000e4:	e8 77 48 00 00       	call   80104960 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 50 0f 11 80    	mov    0x80110f50,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb fc 0e 11 80    	cmp    $0x80110efc,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb fc 0e 11 80    	cmp    $0x80110efc,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 4c 0f 11 80    	mov    0x80110f4c,%ebx
80100126:	81 fb fc 0e 11 80    	cmp    $0x80110efc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb fc 0e 11 80    	cmp    $0x80110efc,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 00 c8 10 80       	push   $0x8010c800
80100162:	e8 b9 48 00 00       	call   80104a20 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 be 45 00 00       	call   80104730 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 4d 21 00 00       	call   801022d0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;//cache memory에 있는 buf 를 리턴해줌. 
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 4e 76 10 80       	push   $0x8010764e
80100198:	e8 f3 01 00 00       	call   80100390 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 1d 46 00 00       	call   801047d0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
  iderw(b);
801001c4:	e9 07 21 00 00       	jmp    801022d0 <iderw>
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 5f 76 10 80       	push   $0x8010765f
801001d1:	e8 ba 01 00 00       	call   80100390 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 dc 45 00 00       	call   801047d0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 8c 45 00 00       	call   80104790 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 00 c8 10 80 	movl   $0x8010c800,(%esp)
8010020b:	e8 50 47 00 00       	call   80104960 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 50 0f 11 80       	mov    0x80110f50,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 fc 0e 11 80 	movl   $0x80110efc,0x50(%ebx)
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100241:	a1 50 0f 11 80       	mov    0x80110f50,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 50 0f 11 80    	mov    %ebx,0x80110f50
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 00 c8 10 80 	movl   $0x8010c800,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010025c:	e9 bf 47 00 00       	jmp    80104a20 <release>
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 66 76 10 80       	push   $0x80107666
80100269:	e8 22 01 00 00       	call   80100390 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 db 15 00 00       	call   80101860 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010028c:	e8 cf 46 00 00       	call   80104960 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e a1 00 00 00    	jle    80100342 <consoleread+0xd2>
    while(input.r == input.w){
801002a1:	8b 15 e0 11 11 80    	mov    0x801111e0,%edx
801002a7:	39 15 e4 11 11 80    	cmp    %edx,0x801111e4
801002ad:	74 2c                	je     801002db <consoleread+0x6b>
801002af:	eb 5f                	jmp    80100310 <consoleread+0xa0>
801002b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b8:	83 ec 08             	sub    $0x8,%esp
801002bb:	68 20 b5 10 80       	push   $0x8010b520
801002c0:	68 e0 11 11 80       	push   $0x801111e0
801002c5:	e8 56 3e 00 00       	call   80104120 <sleep>
    while(input.r == input.w){
801002ca:	8b 15 e0 11 11 80    	mov    0x801111e0,%edx
801002d0:	83 c4 10             	add    $0x10,%esp
801002d3:	3b 15 e4 11 11 80    	cmp    0x801111e4,%edx
801002d9:	75 35                	jne    80100310 <consoleread+0xa0>
      if(myproc()->killed){
801002db:	e8 d0 36 00 00       	call   801039b0 <myproc>
801002e0:	8b 40 24             	mov    0x24(%eax),%eax
801002e3:	85 c0                	test   %eax,%eax
801002e5:	74 d1                	je     801002b8 <consoleread+0x48>
        release(&cons.lock);
801002e7:	83 ec 0c             	sub    $0xc,%esp
801002ea:	68 20 b5 10 80       	push   $0x8010b520
801002ef:	e8 2c 47 00 00       	call   80104a20 <release>
        ilock(ip);
801002f4:	89 3c 24             	mov    %edi,(%esp)
801002f7:	e8 84 14 00 00       	call   80101780 <ilock>
        return -1;
801002fc:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002ff:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
80100302:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100307:	5b                   	pop    %ebx
80100308:	5e                   	pop    %esi
80100309:	5f                   	pop    %edi
8010030a:	5d                   	pop    %ebp
8010030b:	c3                   	ret    
8010030c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100310:	8d 42 01             	lea    0x1(%edx),%eax
80100313:	a3 e0 11 11 80       	mov    %eax,0x801111e0
80100318:	89 d0                	mov    %edx,%eax
8010031a:	83 e0 7f             	and    $0x7f,%eax
8010031d:	0f be 80 60 11 11 80 	movsbl -0x7feeeea0(%eax),%eax
    if(c == C('D')){  // EOF
80100324:	83 f8 04             	cmp    $0x4,%eax
80100327:	74 3f                	je     80100368 <consoleread+0xf8>
    *dst++ = c;
80100329:	83 c6 01             	add    $0x1,%esi
    --n;
8010032c:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
8010032f:	83 f8 0a             	cmp    $0xa,%eax
    *dst++ = c;
80100332:	88 46 ff             	mov    %al,-0x1(%esi)
    if(c == '\n')
80100335:	74 43                	je     8010037a <consoleread+0x10a>
  while(n > 0){
80100337:	85 db                	test   %ebx,%ebx
80100339:	0f 85 62 ff ff ff    	jne    801002a1 <consoleread+0x31>
8010033f:	8b 45 10             	mov    0x10(%ebp),%eax
  release(&cons.lock);
80100342:	83 ec 0c             	sub    $0xc,%esp
80100345:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100348:	68 20 b5 10 80       	push   $0x8010b520
8010034d:	e8 ce 46 00 00       	call   80104a20 <release>
  ilock(ip);
80100352:	89 3c 24             	mov    %edi,(%esp)
80100355:	e8 26 14 00 00       	call   80101780 <ilock>
  return target - n;
8010035a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010035d:	83 c4 10             	add    $0x10,%esp
}
80100360:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100363:	5b                   	pop    %ebx
80100364:	5e                   	pop    %esi
80100365:	5f                   	pop    %edi
80100366:	5d                   	pop    %ebp
80100367:	c3                   	ret    
80100368:	8b 45 10             	mov    0x10(%ebp),%eax
8010036b:	29 d8                	sub    %ebx,%eax
      if(n < target){
8010036d:	3b 5d 10             	cmp    0x10(%ebp),%ebx
80100370:	73 d0                	jae    80100342 <consoleread+0xd2>
        input.r--;
80100372:	89 15 e0 11 11 80    	mov    %edx,0x801111e0
80100378:	eb c8                	jmp    80100342 <consoleread+0xd2>
8010037a:	8b 45 10             	mov    0x10(%ebp),%eax
8010037d:	29 d8                	sub    %ebx,%eax
8010037f:	eb c1                	jmp    80100342 <consoleread+0xd2>
80100381:	eb 0d                	jmp    80100390 <panic>
80100383:	90                   	nop
80100384:	90                   	nop
80100385:	90                   	nop
80100386:	90                   	nop
80100387:	90                   	nop
80100388:	90                   	nop
80100389:	90                   	nop
8010038a:	90                   	nop
8010038b:	90                   	nop
8010038c:	90                   	nop
8010038d:	90                   	nop
8010038e:	90                   	nop
8010038f:	90                   	nop

80100390 <panic>:
{
80100390:	55                   	push   %ebp
80100391:	89 e5                	mov    %esp,%ebp
80100393:	56                   	push   %esi
80100394:	53                   	push   %ebx
80100395:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100398:	fa                   	cli    
  cons.locking = 0;
80100399:	c7 05 54 b5 10 80 00 	movl   $0x0,0x8010b554
801003a0:	00 00 00 
  getcallerpcs(&s, pcs);
801003a3:	8d 5d d0             	lea    -0x30(%ebp),%ebx
801003a6:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
801003a9:	e8 32 25 00 00       	call   801028e0 <lapicid>
801003ae:	83 ec 08             	sub    $0x8,%esp
801003b1:	50                   	push   %eax
801003b2:	68 6d 76 10 80       	push   $0x8010766d
801003b7:	e8 a4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
801003bc:	58                   	pop    %eax
801003bd:	ff 75 08             	pushl  0x8(%ebp)
801003c0:	e8 9b 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003c5:	c7 04 24 10 7e 10 80 	movl   $0x80107e10,(%esp)
801003cc:	e8 8f 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003d1:	5a                   	pop    %edx
801003d2:	8d 45 08             	lea    0x8(%ebp),%eax
801003d5:	59                   	pop    %ecx
801003d6:	53                   	push   %ebx
801003d7:	50                   	push   %eax
801003d8:	e8 63 44 00 00       	call   80104840 <getcallerpcs>
801003dd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003e0:	83 ec 08             	sub    $0x8,%esp
801003e3:	ff 33                	pushl  (%ebx)
801003e5:	83 c3 04             	add    $0x4,%ebx
801003e8:	68 81 76 10 80       	push   $0x80107681
801003ed:	e8 6e 02 00 00       	call   80100660 <cprintf>
  for(i=0; i<10; i++)
801003f2:	83 c4 10             	add    $0x10,%esp
801003f5:	39 f3                	cmp    %esi,%ebx
801003f7:	75 e7                	jne    801003e0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003f9:	c7 05 58 b5 10 80 01 	movl   $0x1,0x8010b558
80100400:	00 00 00 
80100403:	eb fe                	jmp    80100403 <panic+0x73>
80100405:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100409:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100410 <consputc>:
  if(panicked){
80100410:	8b 0d 58 b5 10 80    	mov    0x8010b558,%ecx
80100416:	85 c9                	test   %ecx,%ecx
80100418:	74 06                	je     80100420 <consputc+0x10>
8010041a:	fa                   	cli    
8010041b:	eb fe                	jmp    8010041b <consputc+0xb>
8010041d:	8d 76 00             	lea    0x0(%esi),%esi
{
80100420:	55                   	push   %ebp
80100421:	89 e5                	mov    %esp,%ebp
80100423:	57                   	push   %edi
80100424:	56                   	push   %esi
80100425:	53                   	push   %ebx
80100426:	89 c6                	mov    %eax,%esi
80100428:	83 ec 0c             	sub    $0xc,%esp
  if(c == BACKSPACE){
8010042b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100430:	0f 84 b1 00 00 00    	je     801004e7 <consputc+0xd7>
    uartputc(c);
80100436:	83 ec 0c             	sub    $0xc,%esp
80100439:	50                   	push   %eax
8010043a:	e8 91 5d 00 00       	call   801061d0 <uartputc>
8010043f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100442:	bb d4 03 00 00       	mov    $0x3d4,%ebx
80100447:	b8 0e 00 00 00       	mov    $0xe,%eax
8010044c:	89 da                	mov    %ebx,%edx
8010044e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010044f:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100454:	89 ca                	mov    %ecx,%edx
80100456:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100457:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010045a:	89 da                	mov    %ebx,%edx
8010045c:	c1 e0 08             	shl    $0x8,%eax
8010045f:	89 c7                	mov    %eax,%edi
80100461:	b8 0f 00 00 00       	mov    $0xf,%eax
80100466:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100467:	89 ca                	mov    %ecx,%edx
80100469:	ec                   	in     (%dx),%al
8010046a:	0f b6 d8             	movzbl %al,%ebx
  pos |= inb(CRTPORT+1);
8010046d:	09 fb                	or     %edi,%ebx
  if(c == '\n')
8010046f:	83 fe 0a             	cmp    $0xa,%esi
80100472:	0f 84 f3 00 00 00    	je     8010056b <consputc+0x15b>
  else if(c == BACKSPACE){
80100478:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010047e:	0f 84 d7 00 00 00    	je     8010055b <consputc+0x14b>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100484:	89 f0                	mov    %esi,%eax
80100486:	0f b6 c0             	movzbl %al,%eax
80100489:	80 cc 07             	or     $0x7,%ah
8010048c:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
80100493:	80 
80100494:	83 c3 01             	add    $0x1,%ebx
  if(pos < 0 || pos > 25*80)
80100497:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010049d:	0f 8f ab 00 00 00    	jg     8010054e <consputc+0x13e>
  if((pos/80) >= 24){  // Scroll up.
801004a3:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
801004a9:	7f 66                	jg     80100511 <consputc+0x101>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801004ab:	be d4 03 00 00       	mov    $0x3d4,%esi
801004b0:	b8 0e 00 00 00       	mov    $0xe,%eax
801004b5:	89 f2                	mov    %esi,%edx
801004b7:	ee                   	out    %al,(%dx)
801004b8:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
  outb(CRTPORT+1, pos>>8);
801004bd:	89 d8                	mov    %ebx,%eax
801004bf:	c1 f8 08             	sar    $0x8,%eax
801004c2:	89 ca                	mov    %ecx,%edx
801004c4:	ee                   	out    %al,(%dx)
801004c5:	b8 0f 00 00 00       	mov    $0xf,%eax
801004ca:	89 f2                	mov    %esi,%edx
801004cc:	ee                   	out    %al,(%dx)
801004cd:	89 d8                	mov    %ebx,%eax
801004cf:	89 ca                	mov    %ecx,%edx
801004d1:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004d2:	b8 20 07 00 00       	mov    $0x720,%eax
801004d7:	66 89 84 1b 00 80 0b 	mov    %ax,-0x7ff48000(%ebx,%ebx,1)
801004de:	80 
}
801004df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004e2:	5b                   	pop    %ebx
801004e3:	5e                   	pop    %esi
801004e4:	5f                   	pop    %edi
801004e5:	5d                   	pop    %ebp
801004e6:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004e7:	83 ec 0c             	sub    $0xc,%esp
801004ea:	6a 08                	push   $0x8
801004ec:	e8 df 5c 00 00       	call   801061d0 <uartputc>
801004f1:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004f8:	e8 d3 5c 00 00       	call   801061d0 <uartputc>
801004fd:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100504:	e8 c7 5c 00 00       	call   801061d0 <uartputc>
80100509:	83 c4 10             	add    $0x10,%esp
8010050c:	e9 31 ff ff ff       	jmp    80100442 <consputc+0x32>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100511:	52                   	push   %edx
80100512:	68 60 0e 00 00       	push   $0xe60
    pos -= 80;
80100517:	83 eb 50             	sub    $0x50,%ebx
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
8010051a:	68 a0 80 0b 80       	push   $0x800b80a0
8010051f:	68 00 80 0b 80       	push   $0x800b8000
80100524:	e8 f7 45 00 00       	call   80104b20 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100529:	b8 80 07 00 00       	mov    $0x780,%eax
8010052e:	83 c4 0c             	add    $0xc,%esp
80100531:	29 d8                	sub    %ebx,%eax
80100533:	01 c0                	add    %eax,%eax
80100535:	50                   	push   %eax
80100536:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80100539:	6a 00                	push   $0x0
8010053b:	2d 00 80 f4 7f       	sub    $0x7ff48000,%eax
80100540:	50                   	push   %eax
80100541:	e8 2a 45 00 00       	call   80104a70 <memset>
80100546:	83 c4 10             	add    $0x10,%esp
80100549:	e9 5d ff ff ff       	jmp    801004ab <consputc+0x9b>
    panic("pos under/overflow");
8010054e:	83 ec 0c             	sub    $0xc,%esp
80100551:	68 85 76 10 80       	push   $0x80107685
80100556:	e8 35 fe ff ff       	call   80100390 <panic>
    if(pos > 0) --pos;
8010055b:	85 db                	test   %ebx,%ebx
8010055d:	0f 84 48 ff ff ff    	je     801004ab <consputc+0x9b>
80100563:	83 eb 01             	sub    $0x1,%ebx
80100566:	e9 2c ff ff ff       	jmp    80100497 <consputc+0x87>
    pos += 80 - pos%80;
8010056b:	89 d8                	mov    %ebx,%eax
8010056d:	b9 50 00 00 00       	mov    $0x50,%ecx
80100572:	99                   	cltd   
80100573:	f7 f9                	idiv   %ecx
80100575:	29 d1                	sub    %edx,%ecx
80100577:	01 cb                	add    %ecx,%ebx
80100579:	e9 19 ff ff ff       	jmp    80100497 <consputc+0x87>
8010057e:	66 90                	xchg   %ax,%ax

80100580 <printint>:
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d3                	mov    %edx,%ebx
80100588:	83 ec 2c             	sub    $0x2c,%esp
  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100590:	74 04                	je     80100596 <printint+0x16>
80100592:	85 c0                	test   %eax,%eax
80100594:	78 5a                	js     801005f0 <printint+0x70>
    x = xx;
80100596:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  i = 0;
8010059d:	31 c9                	xor    %ecx,%ecx
8010059f:	8d 75 d7             	lea    -0x29(%ebp),%esi
801005a2:	eb 06                	jmp    801005aa <printint+0x2a>
801005a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    buf[i++] = digits[x % base];
801005a8:	89 f9                	mov    %edi,%ecx
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 79 01             	lea    0x1(%ecx),%edi
801005af:	f7 f3                	div    %ebx
801005b1:	0f b6 92 b0 76 10 80 	movzbl -0x7fef8950(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
    buf[i++] = digits[x % base];
801005ba:	88 14 3e             	mov    %dl,(%esi,%edi,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>
  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 3d d8 2d       	movb   $0x2d,-0x28(%ebp,%edi,1)
801005cb:	8d 79 02             	lea    0x2(%ecx),%edi
801005ce:	8d 5c 3d d7          	lea    -0x29(%ebp,%edi,1),%ebx
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    consputc(buf[i]);
801005d8:	0f be 03             	movsbl (%ebx),%eax
801005db:	83 eb 01             	sub    $0x1,%ebx
801005de:	e8 2d fe ff ff       	call   80100410 <consputc>
  while(--i >= 0)
801005e3:	39 f3                	cmp    %esi,%ebx
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
801005ef:	90                   	nop
    x = -xx;
801005f0:	f7 d8                	neg    %eax
801005f2:	eb a9                	jmp    8010059d <printint+0x1d>
801005f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100600 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
80100609:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060c:	ff 75 08             	pushl  0x8(%ebp)
8010060f:	e8 4c 12 00 00       	call   80101860 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010061b:	e8 40 43 00 00       	call   80104960 <acquire>
  for(i = 0; i < n; i++)
80100620:	83 c4 10             	add    $0x10,%esp
80100623:	85 f6                	test   %esi,%esi
80100625:	7e 18                	jle    8010063f <consolewrite+0x3f>
80100627:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010062a:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 d5 fd ff ff       	call   80100410 <consputc>
  for(i = 0; i < n; i++)
8010063b:	39 fb                	cmp    %edi,%ebx
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 20 b5 10 80       	push   $0x8010b520
80100647:	e8 d4 43 00 00       	call   80104a20 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 2b 11 00 00       	call   80101780 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100669:	a1 54 b5 10 80       	mov    0x8010b554,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
  locking = cons.locking;
80100670:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(locking)
80100673:	0f 85 6f 01 00 00    	jne    801007e8 <cprintf+0x188>
  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c7                	mov    %eax,%edi
80100680:	0f 84 77 01 00 00    	je     801007fd <cprintf+0x19d>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
  argp = (uint*)(void*)(&fmt + 1);
80100689:	8d 4d 0c             	lea    0xc(%ebp),%ecx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010068c:	31 db                	xor    %ebx,%ebx
  argp = (uint*)(void*)(&fmt + 1);
8010068e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100691:	85 c0                	test   %eax,%eax
80100693:	75 56                	jne    801006eb <cprintf+0x8b>
80100695:	eb 79                	jmp    80100710 <cprintf+0xb0>
80100697:	89 f6                	mov    %esi,%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    c = fmt[++i] & 0xff;
801006a0:	0f b6 16             	movzbl (%esi),%edx
    if(c == 0)
801006a3:	85 d2                	test   %edx,%edx
801006a5:	74 69                	je     80100710 <cprintf+0xb0>
801006a7:	83 c3 02             	add    $0x2,%ebx
    switch(c){
801006aa:	83 fa 70             	cmp    $0x70,%edx
801006ad:	8d 34 1f             	lea    (%edi,%ebx,1),%esi
801006b0:	0f 84 84 00 00 00    	je     8010073a <cprintf+0xda>
801006b6:	7f 78                	jg     80100730 <cprintf+0xd0>
801006b8:	83 fa 25             	cmp    $0x25,%edx
801006bb:	0f 84 ff 00 00 00    	je     801007c0 <cprintf+0x160>
801006c1:	83 fa 64             	cmp    $0x64,%edx
801006c4:	0f 85 8e 00 00 00    	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 10, 1);
801006ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801006cd:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d2:	8d 48 04             	lea    0x4(%eax),%ecx
801006d5:	8b 00                	mov    (%eax),%eax
801006d7:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801006da:	b9 01 00 00 00       	mov    $0x1,%ecx
801006df:	e8 9c fe ff ff       	call   80100580 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006e4:	0f b6 06             	movzbl (%esi),%eax
801006e7:	85 c0                	test   %eax,%eax
801006e9:	74 25                	je     80100710 <cprintf+0xb0>
801006eb:	8d 53 01             	lea    0x1(%ebx),%edx
    if(c != '%'){
801006ee:	83 f8 25             	cmp    $0x25,%eax
801006f1:	8d 34 17             	lea    (%edi,%edx,1),%esi
801006f4:	74 aa                	je     801006a0 <cprintf+0x40>
801006f6:	89 55 e0             	mov    %edx,-0x20(%ebp)
      consputc(c);
801006f9:	e8 12 fd ff ff       	call   80100410 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006fe:	0f b6 06             	movzbl (%esi),%eax
      continue;
80100701:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100704:	89 d3                	mov    %edx,%ebx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100706:	85 c0                	test   %eax,%eax
80100708:	75 e1                	jne    801006eb <cprintf+0x8b>
8010070a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(locking)
80100710:	8b 45 dc             	mov    -0x24(%ebp),%eax
80100713:	85 c0                	test   %eax,%eax
80100715:	74 10                	je     80100727 <cprintf+0xc7>
    release(&cons.lock);
80100717:	83 ec 0c             	sub    $0xc,%esp
8010071a:	68 20 b5 10 80       	push   $0x8010b520
8010071f:	e8 fc 42 00 00       	call   80104a20 <release>
80100724:	83 c4 10             	add    $0x10,%esp
}
80100727:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010072a:	5b                   	pop    %ebx
8010072b:	5e                   	pop    %esi
8010072c:	5f                   	pop    %edi
8010072d:	5d                   	pop    %ebp
8010072e:	c3                   	ret    
8010072f:	90                   	nop
    switch(c){
80100730:	83 fa 73             	cmp    $0x73,%edx
80100733:	74 43                	je     80100778 <cprintf+0x118>
80100735:	83 fa 78             	cmp    $0x78,%edx
80100738:	75 1e                	jne    80100758 <cprintf+0xf8>
      printint(*argp++, 16, 0);
8010073a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010073d:	ba 10 00 00 00       	mov    $0x10,%edx
80100742:	8d 48 04             	lea    0x4(%eax),%ecx
80100745:	8b 00                	mov    (%eax),%eax
80100747:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010074a:	31 c9                	xor    %ecx,%ecx
8010074c:	e8 2f fe ff ff       	call   80100580 <printint>
      break;
80100751:	eb 91                	jmp    801006e4 <cprintf+0x84>
80100753:	90                   	nop
80100754:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      consputc('%');
80100758:	b8 25 00 00 00       	mov    $0x25,%eax
8010075d:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100760:	e8 ab fc ff ff       	call   80100410 <consputc>
      consputc(c);
80100765:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100768:	89 d0                	mov    %edx,%eax
8010076a:	e8 a1 fc ff ff       	call   80100410 <consputc>
      break;
8010076f:	e9 70 ff ff ff       	jmp    801006e4 <cprintf+0x84>
80100774:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if((s = (char*)*argp++) == 0)
80100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010077b:	8b 10                	mov    (%eax),%edx
8010077d:	8d 48 04             	lea    0x4(%eax),%ecx
80100780:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80100783:	85 d2                	test   %edx,%edx
80100785:	74 49                	je     801007d0 <cprintf+0x170>
      for(; *s; s++)
80100787:	0f be 02             	movsbl (%edx),%eax
      if((s = (char*)*argp++) == 0)
8010078a:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
      for(; *s; s++)
8010078d:	84 c0                	test   %al,%al
8010078f:	0f 84 4f ff ff ff    	je     801006e4 <cprintf+0x84>
80100795:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80100798:	89 d3                	mov    %edx,%ebx
8010079a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801007a0:	83 c3 01             	add    $0x1,%ebx
        consputc(*s);
801007a3:	e8 68 fc ff ff       	call   80100410 <consputc>
      for(; *s; s++)
801007a8:	0f be 03             	movsbl (%ebx),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
      if((s = (char*)*argp++) == 0)
801007af:	8b 45 e0             	mov    -0x20(%ebp),%eax
801007b2:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801007b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801007b8:	e9 27 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007bd:	8d 76 00             	lea    0x0(%esi),%esi
      consputc('%');
801007c0:	b8 25 00 00 00       	mov    $0x25,%eax
801007c5:	e8 46 fc ff ff       	call   80100410 <consputc>
      break;
801007ca:	e9 15 ff ff ff       	jmp    801006e4 <cprintf+0x84>
801007cf:	90                   	nop
        s = "(null)";
801007d0:	ba 98 76 10 80       	mov    $0x80107698,%edx
      for(; *s; s++)
801007d5:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801007d8:	b8 28 00 00 00       	mov    $0x28,%eax
801007dd:	89 d3                	mov    %edx,%ebx
801007df:	eb bf                	jmp    801007a0 <cprintf+0x140>
801007e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    acquire(&cons.lock);
801007e8:	83 ec 0c             	sub    $0xc,%esp
801007eb:	68 20 b5 10 80       	push   $0x8010b520
801007f0:	e8 6b 41 00 00       	call   80104960 <acquire>
801007f5:	83 c4 10             	add    $0x10,%esp
801007f8:	e9 7c fe ff ff       	jmp    80100679 <cprintf+0x19>
    panic("null fmt");
801007fd:	83 ec 0c             	sub    $0xc,%esp
80100800:	68 9f 76 10 80       	push   $0x8010769f
80100805:	e8 86 fb ff ff       	call   80100390 <panic>
8010080a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100810 <consoleintr>:
{
80100810:	55                   	push   %ebp
80100811:	89 e5                	mov    %esp,%ebp
80100813:	57                   	push   %edi
80100814:	56                   	push   %esi
80100815:	53                   	push   %ebx
  int c, doprocdump = 0;
80100816:	31 f6                	xor    %esi,%esi
{
80100818:	83 ec 18             	sub    $0x18,%esp
8010081b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
8010081e:	68 20 b5 10 80       	push   $0x8010b520
80100823:	e8 38 41 00 00       	call   80104960 <acquire>
  while((c = getc()) >= 0){
80100828:	83 c4 10             	add    $0x10,%esp
8010082b:	90                   	nop
8010082c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100830:	ff d3                	call   *%ebx
80100832:	85 c0                	test   %eax,%eax
80100834:	89 c7                	mov    %eax,%edi
80100836:	78 48                	js     80100880 <consoleintr+0x70>
    switch(c){
80100838:	83 ff 10             	cmp    $0x10,%edi
8010083b:	0f 84 e7 00 00 00    	je     80100928 <consoleintr+0x118>
80100841:	7e 5d                	jle    801008a0 <consoleintr+0x90>
80100843:	83 ff 15             	cmp    $0x15,%edi
80100846:	0f 84 ec 00 00 00    	je     80100938 <consoleintr+0x128>
8010084c:	83 ff 7f             	cmp    $0x7f,%edi
8010084f:	75 54                	jne    801008a5 <consoleintr+0x95>
      if(input.e != input.w){
80100851:	a1 e8 11 11 80       	mov    0x801111e8,%eax
80100856:	3b 05 e4 11 11 80    	cmp    0x801111e4,%eax
8010085c:	74 d2                	je     80100830 <consoleintr+0x20>
        input.e--;
8010085e:	83 e8 01             	sub    $0x1,%eax
80100861:	a3 e8 11 11 80       	mov    %eax,0x801111e8
        consputc(BACKSPACE);
80100866:	b8 00 01 00 00       	mov    $0x100,%eax
8010086b:	e8 a0 fb ff ff       	call   80100410 <consputc>
  while((c = getc()) >= 0){
80100870:	ff d3                	call   *%ebx
80100872:	85 c0                	test   %eax,%eax
80100874:	89 c7                	mov    %eax,%edi
80100876:	79 c0                	jns    80100838 <consoleintr+0x28>
80100878:	90                   	nop
80100879:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
80100880:	83 ec 0c             	sub    $0xc,%esp
80100883:	68 20 b5 10 80       	push   $0x8010b520
80100888:	e8 93 41 00 00       	call   80104a20 <release>
  if(doprocdump) {
8010088d:	83 c4 10             	add    $0x10,%esp
80100890:	85 f6                	test   %esi,%esi
80100892:	0f 85 f8 00 00 00    	jne    80100990 <consoleintr+0x180>
}
80100898:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010089b:	5b                   	pop    %ebx
8010089c:	5e                   	pop    %esi
8010089d:	5f                   	pop    %edi
8010089e:	5d                   	pop    %ebp
8010089f:	c3                   	ret    
    switch(c){
801008a0:	83 ff 08             	cmp    $0x8,%edi
801008a3:	74 ac                	je     80100851 <consoleintr+0x41>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008a5:	85 ff                	test   %edi,%edi
801008a7:	74 87                	je     80100830 <consoleintr+0x20>
801008a9:	a1 e8 11 11 80       	mov    0x801111e8,%eax
801008ae:	89 c2                	mov    %eax,%edx
801008b0:	2b 15 e0 11 11 80    	sub    0x801111e0,%edx
801008b6:	83 fa 7f             	cmp    $0x7f,%edx
801008b9:	0f 87 71 ff ff ff    	ja     80100830 <consoleintr+0x20>
801008bf:	8d 50 01             	lea    0x1(%eax),%edx
801008c2:	83 e0 7f             	and    $0x7f,%eax
        c = (c == '\r') ? '\n' : c;
801008c5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008c8:	89 15 e8 11 11 80    	mov    %edx,0x801111e8
        c = (c == '\r') ? '\n' : c;
801008ce:	0f 84 cc 00 00 00    	je     801009a0 <consoleintr+0x190>
        input.buf[input.e++ % INPUT_BUF] = c;
801008d4:	89 f9                	mov    %edi,%ecx
801008d6:	88 88 60 11 11 80    	mov    %cl,-0x7feeeea0(%eax)
        consputc(c);
801008dc:	89 f8                	mov    %edi,%eax
801008de:	e8 2d fb ff ff       	call   80100410 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008e3:	83 ff 0a             	cmp    $0xa,%edi
801008e6:	0f 84 c5 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008ec:	83 ff 04             	cmp    $0x4,%edi
801008ef:	0f 84 bc 00 00 00    	je     801009b1 <consoleintr+0x1a1>
801008f5:	a1 e0 11 11 80       	mov    0x801111e0,%eax
801008fa:	83 e8 80             	sub    $0xffffff80,%eax
801008fd:	39 05 e8 11 11 80    	cmp    %eax,0x801111e8
80100903:	0f 85 27 ff ff ff    	jne    80100830 <consoleintr+0x20>
          wakeup(&input.r);
80100909:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
8010090c:	a3 e4 11 11 80       	mov    %eax,0x801111e4
          wakeup(&input.r);
80100911:	68 e0 11 11 80       	push   $0x801111e0
80100916:	e8 c5 39 00 00       	call   801042e0 <wakeup>
8010091b:	83 c4 10             	add    $0x10,%esp
8010091e:	e9 0d ff ff ff       	jmp    80100830 <consoleintr+0x20>
80100923:	90                   	nop
80100924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      doprocdump = 1;
80100928:	be 01 00 00 00       	mov    $0x1,%esi
8010092d:	e9 fe fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100932:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      while(input.e != input.w &&
80100938:	a1 e8 11 11 80       	mov    0x801111e8,%eax
8010093d:	39 05 e4 11 11 80    	cmp    %eax,0x801111e4
80100943:	75 2b                	jne    80100970 <consoleintr+0x160>
80100945:	e9 e6 fe ff ff       	jmp    80100830 <consoleintr+0x20>
8010094a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        input.e--;
80100950:	a3 e8 11 11 80       	mov    %eax,0x801111e8
        consputc(BACKSPACE);
80100955:	b8 00 01 00 00       	mov    $0x100,%eax
8010095a:	e8 b1 fa ff ff       	call   80100410 <consputc>
      while(input.e != input.w &&
8010095f:	a1 e8 11 11 80       	mov    0x801111e8,%eax
80100964:	3b 05 e4 11 11 80    	cmp    0x801111e4,%eax
8010096a:	0f 84 c0 fe ff ff    	je     80100830 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100970:	83 e8 01             	sub    $0x1,%eax
80100973:	89 c2                	mov    %eax,%edx
80100975:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100978:	80 ba 60 11 11 80 0a 	cmpb   $0xa,-0x7feeeea0(%edx)
8010097f:	75 cf                	jne    80100950 <consoleintr+0x140>
80100981:	e9 aa fe ff ff       	jmp    80100830 <consoleintr+0x20>
80100986:	8d 76 00             	lea    0x0(%esi),%esi
80100989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
}
80100990:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100993:	5b                   	pop    %ebx
80100994:	5e                   	pop    %esi
80100995:	5f                   	pop    %edi
80100996:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100997:	e9 74 3c 00 00       	jmp    80104610 <procdump>
8010099c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        input.buf[input.e++ % INPUT_BUF] = c;
801009a0:	c6 80 60 11 11 80 0a 	movb   $0xa,-0x7feeeea0(%eax)
        consputc(c);
801009a7:	b8 0a 00 00 00       	mov    $0xa,%eax
801009ac:	e8 5f fa ff ff       	call   80100410 <consputc>
801009b1:	a1 e8 11 11 80       	mov    0x801111e8,%eax
801009b6:	e9 4e ff ff ff       	jmp    80100909 <consoleintr+0xf9>
801009bb:	90                   	nop
801009bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801009c0 <consoleinit>:

void
consoleinit(void)
{
801009c0:	55                   	push   %ebp
801009c1:	89 e5                	mov    %esp,%ebp
801009c3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009c6:	68 a8 76 10 80       	push   $0x801076a8
801009cb:	68 20 b5 10 80       	push   $0x8010b520
801009d0:	e8 4b 3e 00 00       	call   80104820 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009d5:	58                   	pop    %eax
801009d6:	5a                   	pop    %edx
801009d7:	6a 00                	push   $0x0
801009d9:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
801009db:	c7 05 ac 1b 11 80 00 	movl   $0x80100600,0x80111bac
801009e2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009e5:	c7 05 a8 1b 11 80 70 	movl   $0x80100270,0x80111ba8
801009ec:	02 10 80 
  cons.locking = 1;
801009ef:	c7 05 54 b5 10 80 01 	movl   $0x1,0x8010b554
801009f6:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
801009f9:	e8 82 1a 00 00       	call   80102480 <ioapicenable>
}
801009fe:	83 c4 10             	add    $0x10,%esp
80100a01:	c9                   	leave  
80100a02:	c3                   	ret    
80100a03:	66 90                	xchg   %ax,%ax
80100a05:	66 90                	xchg   %ax,%ax
80100a07:	66 90                	xchg   %ax,%ax
80100a09:	66 90                	xchg   %ax,%ax
80100a0b:	66 90                	xchg   %ax,%ax
80100a0d:	66 90                	xchg   %ax,%ax
80100a0f:	90                   	nop

80100a10 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
80100a10:	55                   	push   %ebp
80100a11:	89 e5                	mov    %esp,%ebp
80100a13:	57                   	push   %edi
80100a14:	56                   	push   %esi
80100a15:	53                   	push   %ebx
80100a16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100a1c:	e8 8f 2f 00 00       	call   801039b0 <myproc>
80100a21:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a27:	e8 24 23 00 00       	call   80102d50 <begin_op>

  if((ip = namei(path)) == 0){
80100a2c:	83 ec 0c             	sub    $0xc,%esp
80100a2f:	ff 75 08             	pushl  0x8(%ebp)
80100a32:	e8 59 16 00 00       	call   80102090 <namei>
80100a37:	83 c4 10             	add    $0x10,%esp
80100a3a:	85 c0                	test   %eax,%eax
80100a3c:	0f 84 91 01 00 00    	je     80100bd3 <exec+0x1c3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a42:	83 ec 0c             	sub    $0xc,%esp
80100a45:	89 c3                	mov    %eax,%ebx
80100a47:	50                   	push   %eax
80100a48:	e8 33 0d 00 00       	call   80101780 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a53:	6a 34                	push   $0x34
80100a55:	6a 00                	push   $0x0
80100a57:	50                   	push   %eax
80100a58:	53                   	push   %ebx
80100a59:	e8 b2 10 00 00       	call   80101b10 <readi>
80100a5e:	83 c4 20             	add    $0x20,%esp
80100a61:	83 f8 34             	cmp    $0x34,%eax
80100a64:	74 22                	je     80100a88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a66:	83 ec 0c             	sub    $0xc,%esp
80100a69:	53                   	push   %ebx
80100a6a:	e8 51 10 00 00       	call   80101ac0 <iunlockput>
    end_op();
80100a6f:	e8 4c 23 00 00       	call   80102dc0 <end_op>
80100a74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a7f:	5b                   	pop    %ebx
80100a80:	5e                   	pop    %esi
80100a81:	5f                   	pop    %edi
80100a82:	5d                   	pop    %ebp
80100a83:	c3                   	ret    
80100a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100a88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a8f:	45 4c 46 
80100a92:	75 d2                	jne    80100a66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100a94:	e8 87 68 00 00       	call   80107320 <setupkvm>
80100a99:	85 c0                	test   %eax,%eax
80100a9b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100aa1:	74 c3                	je     80100a66 <exec+0x56>
  sz = 0;
80100aa3:	31 ff                	xor    %edi,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100aa5:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100aac:	00 
80100aad:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
80100ab3:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100ab9:	0f 84 8c 02 00 00    	je     80100d4b <exec+0x33b>
80100abf:	31 f6                	xor    %esi,%esi
80100ac1:	eb 7f                	jmp    80100b42 <exec+0x132>
80100ac3:	90                   	nop
80100ac4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ph.type != ELF_PROG_LOAD)
80100ac8:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100acf:	75 63                	jne    80100b34 <exec+0x124>
    if(ph.memsz < ph.filesz)
80100ad1:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ad7:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100add:	0f 82 86 00 00 00    	jb     80100b69 <exec+0x159>
80100ae3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ae9:	72 7e                	jb     80100b69 <exec+0x159>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100aeb:	83 ec 04             	sub    $0x4,%esp
80100aee:	50                   	push   %eax
80100aef:	57                   	push   %edi
80100af0:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100af6:	e8 45 66 00 00       	call   80107140 <allocuvm>
80100afb:	83 c4 10             	add    $0x10,%esp
80100afe:	85 c0                	test   %eax,%eax
80100b00:	89 c7                	mov    %eax,%edi
80100b02:	74 65                	je     80100b69 <exec+0x159>
    if(ph.vaddr % PGSIZE != 0)
80100b04:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b0a:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b0f:	75 58                	jne    80100b69 <exec+0x159>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b11:	83 ec 0c             	sub    $0xc,%esp
80100b14:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b1a:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b20:	53                   	push   %ebx
80100b21:	50                   	push   %eax
80100b22:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b28:	e8 53 65 00 00       	call   80107080 <loaduvm>
80100b2d:	83 c4 20             	add    $0x20,%esp
80100b30:	85 c0                	test   %eax,%eax
80100b32:	78 35                	js     80100b69 <exec+0x159>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100b34:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100b3b:	83 c6 01             	add    $0x1,%esi
80100b3e:	39 f0                	cmp    %esi,%eax
80100b40:	7e 3d                	jle    80100b7f <exec+0x16f>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100b42:	89 f0                	mov    %esi,%eax
80100b44:	6a 20                	push   $0x20
80100b46:	c1 e0 05             	shl    $0x5,%eax
80100b49:	03 85 ec fe ff ff    	add    -0x114(%ebp),%eax
80100b4f:	50                   	push   %eax
80100b50:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100b56:	50                   	push   %eax
80100b57:	53                   	push   %ebx
80100b58:	e8 b3 0f 00 00       	call   80101b10 <readi>
80100b5d:	83 c4 10             	add    $0x10,%esp
80100b60:	83 f8 20             	cmp    $0x20,%eax
80100b63:	0f 84 5f ff ff ff    	je     80100ac8 <exec+0xb8>
    freevm(pgdir);
80100b69:	83 ec 0c             	sub    $0xc,%esp
80100b6c:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b72:	e8 29 67 00 00       	call   801072a0 <freevm>
80100b77:	83 c4 10             	add    $0x10,%esp
80100b7a:	e9 e7 fe ff ff       	jmp    80100a66 <exec+0x56>
80100b7f:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100b85:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
80100b8b:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100b91:	83 ec 0c             	sub    $0xc,%esp
80100b94:	53                   	push   %ebx
80100b95:	e8 26 0f 00 00       	call   80101ac0 <iunlockput>
  end_op();
80100b9a:	e8 21 22 00 00       	call   80102dc0 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b9f:	83 c4 0c             	add    $0xc,%esp
80100ba2:	56                   	push   %esi
80100ba3:	57                   	push   %edi
80100ba4:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100baa:	e8 91 65 00 00       	call   80107140 <allocuvm>
80100baf:	83 c4 10             	add    $0x10,%esp
80100bb2:	85 c0                	test   %eax,%eax
80100bb4:	89 c6                	mov    %eax,%esi
80100bb6:	75 3a                	jne    80100bf2 <exec+0x1e2>
    freevm(pgdir);
80100bb8:	83 ec 0c             	sub    $0xc,%esp
80100bbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bc1:	e8 da 66 00 00       	call   801072a0 <freevm>
80100bc6:	83 c4 10             	add    $0x10,%esp
  return -1;
80100bc9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bce:	e9 a9 fe ff ff       	jmp    80100a7c <exec+0x6c>
    end_op();
80100bd3:	e8 e8 21 00 00       	call   80102dc0 <end_op>
    cprintf("exec: fail\n");
80100bd8:	83 ec 0c             	sub    $0xc,%esp
80100bdb:	68 c1 76 10 80       	push   $0x801076c1
80100be0:	e8 7b fa ff ff       	call   80100660 <cprintf>
    return -1;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bed:	e9 8a fe ff ff       	jmp    80100a7c <exec+0x6c>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bf2:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100bf8:	83 ec 08             	sub    $0x8,%esp
  for(argc = 0; argv[argc]; argc++) {
80100bfb:	31 ff                	xor    %edi,%edi
80100bfd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bff:	50                   	push   %eax
80100c00:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100c06:	e8 b5 67 00 00       	call   801073c0 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100c0b:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c17:	8b 00                	mov    (%eax),%eax
80100c19:	85 c0                	test   %eax,%eax
80100c1b:	74 70                	je     80100c8d <exec+0x27d>
80100c1d:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c23:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c29:	eb 0a                	jmp    80100c35 <exec+0x225>
80100c2b:	90                   	nop
80100c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(argc >= MAXARG)
80100c30:	83 ff 20             	cmp    $0x20,%edi
80100c33:	74 83                	je     80100bb8 <exec+0x1a8>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c35:	83 ec 0c             	sub    $0xc,%esp
80100c38:	50                   	push   %eax
80100c39:	e8 52 40 00 00       	call   80104c90 <strlen>
80100c3e:	f7 d0                	not    %eax
80100c40:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c42:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c45:	5a                   	pop    %edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c46:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c49:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4c:	e8 3f 40 00 00       	call   80104c90 <strlen>
80100c51:	83 c0 01             	add    $0x1,%eax
80100c54:	50                   	push   %eax
80100c55:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c58:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c5b:	53                   	push   %ebx
80100c5c:	56                   	push   %esi
80100c5d:	e8 be 68 00 00       	call   80107520 <copyout>
80100c62:	83 c4 20             	add    $0x20,%esp
80100c65:	85 c0                	test   %eax,%eax
80100c67:	0f 88 4b ff ff ff    	js     80100bb8 <exec+0x1a8>
  for(argc = 0; argv[argc]; argc++) {
80100c6d:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100c70:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100c77:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100c7a:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100c80:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c83:	85 c0                	test   %eax,%eax
80100c85:	75 a9                	jne    80100c30 <exec+0x220>
80100c87:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c8d:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c94:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100c96:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c9d:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100ca1:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100ca8:	ff ff ff 
  ustack[1] = argc;
80100cab:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb1:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100cb3:	83 c0 0c             	add    $0xc,%eax
80100cb6:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cb8:	50                   	push   %eax
80100cb9:	52                   	push   %edx
80100cba:	53                   	push   %ebx
80100cbb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cc1:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cc7:	e8 54 68 00 00       	call   80107520 <copyout>
80100ccc:	83 c4 10             	add    $0x10,%esp
80100ccf:	85 c0                	test   %eax,%eax
80100cd1:	0f 88 e1 fe ff ff    	js     80100bb8 <exec+0x1a8>
  for(last=s=path; *s; s++)
80100cd7:	8b 45 08             	mov    0x8(%ebp),%eax
80100cda:	0f b6 00             	movzbl (%eax),%eax
80100cdd:	84 c0                	test   %al,%al
80100cdf:	74 17                	je     80100cf8 <exec+0x2e8>
80100ce1:	8b 55 08             	mov    0x8(%ebp),%edx
80100ce4:	89 d1                	mov    %edx,%ecx
80100ce6:	83 c1 01             	add    $0x1,%ecx
80100ce9:	3c 2f                	cmp    $0x2f,%al
80100ceb:	0f b6 01             	movzbl (%ecx),%eax
80100cee:	0f 44 d1             	cmove  %ecx,%edx
80100cf1:	84 c0                	test   %al,%al
80100cf3:	75 f1                	jne    80100ce6 <exec+0x2d6>
80100cf5:	89 55 08             	mov    %edx,0x8(%ebp)
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cf8:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cfe:	50                   	push   %eax
80100cff:	6a 10                	push   $0x10
80100d01:	ff 75 08             	pushl  0x8(%ebp)
80100d04:	89 f8                	mov    %edi,%eax
80100d06:	83 e8 80             	sub    $0xffffff80,%eax
80100d09:	50                   	push   %eax
80100d0a:	e8 41 3f 00 00       	call   80104c50 <safestrcpy>
  curproc->pgdir = pgdir;
80100d0f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  oldpgdir = curproc->pgdir;
80100d15:	89 f9                	mov    %edi,%ecx
80100d17:	8b 7f 04             	mov    0x4(%edi),%edi
  curproc->tf->eip = elf.entry;  // main
80100d1a:	8b 41 18             	mov    0x18(%ecx),%eax
  curproc->sz = sz;
80100d1d:	89 31                	mov    %esi,(%ecx)
  curproc->pgdir = pgdir;
80100d1f:	89 51 04             	mov    %edx,0x4(%ecx)
  curproc->tf->eip = elf.entry;  // main
80100d22:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d28:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d2b:	8b 41 18             	mov    0x18(%ecx),%eax
80100d2e:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d31:	89 0c 24             	mov    %ecx,(%esp)
80100d34:	e8 b7 61 00 00       	call   80106ef0 <switchuvm>
  freevm(oldpgdir);
80100d39:	89 3c 24             	mov    %edi,(%esp)
80100d3c:	e8 5f 65 00 00       	call   801072a0 <freevm>
  return 0;
80100d41:	83 c4 10             	add    $0x10,%esp
80100d44:	31 c0                	xor    %eax,%eax
80100d46:	e9 31 fd ff ff       	jmp    80100a7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100d4b:	be 00 20 00 00       	mov    $0x2000,%esi
80100d50:	e9 3c fe ff ff       	jmp    80100b91 <exec+0x181>
80100d55:	66 90                	xchg   %ax,%ax
80100d57:	66 90                	xchg   %ax,%ax
80100d59:	66 90                	xchg   %ax,%ax
80100d5b:	66 90                	xchg   %ax,%ax
80100d5d:	66 90                	xchg   %ax,%ax
80100d5f:	90                   	nop

80100d60 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d60:	55                   	push   %ebp
80100d61:	89 e5                	mov    %esp,%ebp
80100d63:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d66:	68 cd 76 10 80       	push   $0x801076cd
80100d6b:	68 00 12 11 80       	push   $0x80111200
80100d70:	e8 ab 3a 00 00       	call   80104820 <initlock>
}
80100d75:	83 c4 10             	add    $0x10,%esp
80100d78:	c9                   	leave  
80100d79:	c3                   	ret    
80100d7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d80 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d80:	55                   	push   %ebp
80100d81:	89 e5                	mov    %esp,%ebp
80100d83:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d84:	bb 34 12 11 80       	mov    $0x80111234,%ebx
{
80100d89:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100d8c:	68 00 12 11 80       	push   $0x80111200
80100d91:	e8 ca 3b 00 00       	call   80104960 <acquire>
80100d96:	83 c4 10             	add    $0x10,%esp
80100d99:	eb 10                	jmp    80100dab <filealloc+0x2b>
80100d9b:	90                   	nop
80100d9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100da0:	83 c3 18             	add    $0x18,%ebx
80100da3:	81 fb 94 1b 11 80    	cmp    $0x80111b94,%ebx
80100da9:	73 25                	jae    80100dd0 <filealloc+0x50>
    if(f->ref == 0){
80100dab:	8b 43 04             	mov    0x4(%ebx),%eax
80100dae:	85 c0                	test   %eax,%eax
80100db0:	75 ee                	jne    80100da0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100db2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100db5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dbc:	68 00 12 11 80       	push   $0x80111200
80100dc1:	e8 5a 3c 00 00       	call   80104a20 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dc6:	89 d8                	mov    %ebx,%eax
      return f;
80100dc8:	83 c4 10             	add    $0x10,%esp
}
80100dcb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dce:	c9                   	leave  
80100dcf:	c3                   	ret    
  release(&ftable.lock);
80100dd0:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100dd3:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100dd5:	68 00 12 11 80       	push   $0x80111200
80100dda:	e8 41 3c 00 00       	call   80104a20 <release>
}
80100ddf:	89 d8                	mov    %ebx,%eax
  return 0;
80100de1:	83 c4 10             	add    $0x10,%esp
}
80100de4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100de7:	c9                   	leave  
80100de8:	c3                   	ret    
80100de9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100df0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100df0:	55                   	push   %ebp
80100df1:	89 e5                	mov    %esp,%ebp
80100df3:	53                   	push   %ebx
80100df4:	83 ec 10             	sub    $0x10,%esp
80100df7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dfa:	68 00 12 11 80       	push   $0x80111200
80100dff:	e8 5c 3b 00 00       	call   80104960 <acquire>
  if(f->ref < 1)
80100e04:	8b 43 04             	mov    0x4(%ebx),%eax
80100e07:	83 c4 10             	add    $0x10,%esp
80100e0a:	85 c0                	test   %eax,%eax
80100e0c:	7e 1a                	jle    80100e28 <filedup+0x38>
    panic("filedup");
  f->ref++;// race condition 발생가능
80100e0e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e11:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;// race condition 발생가능
80100e14:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e17:	68 00 12 11 80       	push   $0x80111200
80100e1c:	e8 ff 3b 00 00       	call   80104a20 <release>
  return f;
}
80100e21:	89 d8                	mov    %ebx,%eax
80100e23:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e26:	c9                   	leave  
80100e27:	c3                   	ret    
    panic("filedup");
80100e28:	83 ec 0c             	sub    $0xc,%esp
80100e2b:	68 d4 76 10 80       	push   $0x801076d4
80100e30:	e8 5b f5 ff ff       	call   80100390 <panic>
80100e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e40 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e40:	55                   	push   %ebp
80100e41:	89 e5                	mov    %esp,%ebp
80100e43:	57                   	push   %edi
80100e44:	56                   	push   %esi
80100e45:	53                   	push   %ebx
80100e46:	83 ec 28             	sub    $0x28,%esp
80100e49:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100e4c:	68 00 12 11 80       	push   $0x80111200
80100e51:	e8 0a 3b 00 00       	call   80104960 <acquire>
  if(f->ref < 1)
80100e56:	8b 43 04             	mov    0x4(%ebx),%eax
80100e59:	83 c4 10             	add    $0x10,%esp
80100e5c:	85 c0                	test   %eax,%eax
80100e5e:	0f 8e 9b 00 00 00    	jle    80100eff <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e64:	83 e8 01             	sub    $0x1,%eax
80100e67:	85 c0                	test   %eax,%eax
80100e69:	89 43 04             	mov    %eax,0x4(%ebx)
80100e6c:	74 1a                	je     80100e88 <fileclose+0x48>
    release(&ftable.lock);
80100e6e:	c7 45 08 00 12 11 80 	movl   $0x80111200,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e75:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e78:	5b                   	pop    %ebx
80100e79:	5e                   	pop    %esi
80100e7a:	5f                   	pop    %edi
80100e7b:	5d                   	pop    %ebp
    release(&ftable.lock);
80100e7c:	e9 9f 3b 00 00       	jmp    80104a20 <release>
80100e81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  ff = *f;
80100e88:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
80100e8c:	8b 3b                	mov    (%ebx),%edi
  release(&ftable.lock);
80100e8e:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100e91:	8b 73 0c             	mov    0xc(%ebx),%esi
  f->type = FD_NONE;
80100e94:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100e9a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e9d:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100ea0:	68 00 12 11 80       	push   $0x80111200
  ff = *f;
80100ea5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100ea8:	e8 73 3b 00 00       	call   80104a20 <release>
  if(ff.type == FD_PIPE)
80100ead:	83 c4 10             	add    $0x10,%esp
80100eb0:	83 ff 01             	cmp    $0x1,%edi
80100eb3:	74 13                	je     80100ec8 <fileclose+0x88>
  else if(ff.type == FD_INODE){
80100eb5:	83 ff 02             	cmp    $0x2,%edi
80100eb8:	74 26                	je     80100ee0 <fileclose+0xa0>
}
80100eba:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ebd:	5b                   	pop    %ebx
80100ebe:	5e                   	pop    %esi
80100ebf:	5f                   	pop    %edi
80100ec0:	5d                   	pop    %ebp
80100ec1:	c3                   	ret    
80100ec2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pipeclose(ff.pipe, ff.writable);
80100ec8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ecc:	83 ec 08             	sub    $0x8,%esp
80100ecf:	53                   	push   %ebx
80100ed0:	56                   	push   %esi
80100ed1:	e8 2a 26 00 00       	call   80103500 <pipeclose>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb df                	jmp    80100eba <fileclose+0x7a>
80100edb:	90                   	nop
80100edc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    begin_op();
80100ee0:	e8 6b 1e 00 00       	call   80102d50 <begin_op>
    iput(ff.ip);
80100ee5:	83 ec 0c             	sub    $0xc,%esp
80100ee8:	ff 75 e0             	pushl  -0x20(%ebp)
80100eeb:	e8 c0 09 00 00       	call   801018b0 <iput>
    end_op();
80100ef0:	83 c4 10             	add    $0x10,%esp
}
80100ef3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ef6:	5b                   	pop    %ebx
80100ef7:	5e                   	pop    %esi
80100ef8:	5f                   	pop    %edi
80100ef9:	5d                   	pop    %ebp
    end_op();
80100efa:	e9 c1 1e 00 00       	jmp    80102dc0 <end_op>
    panic("fileclose");
80100eff:	83 ec 0c             	sub    $0xc,%esp
80100f02:	68 dc 76 10 80       	push   $0x801076dc
80100f07:	e8 84 f4 ff ff       	call   80100390 <panic>
80100f0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f10 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f10:	55                   	push   %ebp
80100f11:	89 e5                	mov    %esp,%ebp
80100f13:	53                   	push   %ebx
80100f14:	83 ec 04             	sub    $0x4,%esp
80100f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f1a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f1d:	75 31                	jne    80100f50 <filestat+0x40>
    ilock(f->ip);
80100f1f:	83 ec 0c             	sub    $0xc,%esp
80100f22:	ff 73 10             	pushl  0x10(%ebx)
80100f25:	e8 56 08 00 00       	call   80101780 <ilock>
    stati(f->ip, st);
80100f2a:	58                   	pop    %eax
80100f2b:	5a                   	pop    %edx
80100f2c:	ff 75 0c             	pushl  0xc(%ebp)
80100f2f:	ff 73 10             	pushl  0x10(%ebx)
80100f32:	e8 a9 0b 00 00       	call   80101ae0 <stati>
    iunlock(f->ip);
80100f37:	59                   	pop    %ecx
80100f38:	ff 73 10             	pushl  0x10(%ebx)
80100f3b:	e8 20 09 00 00       	call   80101860 <iunlock>
    return 0;
80100f40:	83 c4 10             	add    $0x10,%esp
80100f43:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return -1;
80100f50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f55:	eb ee                	jmp    80100f45 <filestat+0x35>
80100f57:	89 f6                	mov    %esi,%esi
80100f59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100f60 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f60:	55                   	push   %ebp
80100f61:	89 e5                	mov    %esp,%ebp
80100f63:	57                   	push   %edi
80100f64:	56                   	push   %esi
80100f65:	53                   	push   %ebx
80100f66:	83 ec 0c             	sub    $0xc,%esp
80100f69:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f6c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f6f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f72:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f76:	74 60                	je     80100fd8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f78:	8b 03                	mov    (%ebx),%eax
80100f7a:	83 f8 01             	cmp    $0x1,%eax
80100f7d:	74 41                	je     80100fc0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f7f:	83 f8 02             	cmp    $0x2,%eax
80100f82:	75 5b                	jne    80100fdf <fileread+0x7f>
    ilock(f->ip);
80100f84:	83 ec 0c             	sub    $0xc,%esp
80100f87:	ff 73 10             	pushl  0x10(%ebx)
80100f8a:	e8 f1 07 00 00       	call   80101780 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f8f:	57                   	push   %edi
80100f90:	ff 73 14             	pushl  0x14(%ebx)
80100f93:	56                   	push   %esi
80100f94:	ff 73 10             	pushl  0x10(%ebx)
80100f97:	e8 74 0b 00 00       	call   80101b10 <readi>
80100f9c:	83 c4 20             	add    $0x20,%esp
80100f9f:	85 c0                	test   %eax,%eax
80100fa1:	89 c6                	mov    %eax,%esi
80100fa3:	7e 03                	jle    80100fa8 <fileread+0x48>
      f->off += r;
80100fa5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100fa8:	83 ec 0c             	sub    $0xc,%esp
80100fab:	ff 73 10             	pushl  0x10(%ebx)
80100fae:	e8 ad 08 00 00       	call   80101860 <iunlock>
    return r;
80100fb3:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	89 f0                	mov    %esi,%eax
80100fbb:	5b                   	pop    %ebx
80100fbc:	5e                   	pop    %esi
80100fbd:	5f                   	pop    %edi
80100fbe:	5d                   	pop    %ebp
80100fbf:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100fc0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fc3:	89 45 08             	mov    %eax,0x8(%ebp)
}
80100fc6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fc9:	5b                   	pop    %ebx
80100fca:	5e                   	pop    %esi
80100fcb:	5f                   	pop    %edi
80100fcc:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
80100fcd:	e9 de 26 00 00       	jmp    801036b0 <piperead>
80100fd2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80100fd8:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100fdd:	eb d7                	jmp    80100fb6 <fileread+0x56>
  panic("fileread");
80100fdf:	83 ec 0c             	sub    $0xc,%esp
80100fe2:	68 e6 76 10 80       	push   $0x801076e6
80100fe7:	e8 a4 f3 ff ff       	call   80100390 <panic>
80100fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100ff0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff0:	55                   	push   %ebp
80100ff1:	89 e5                	mov    %esp,%ebp
80100ff3:	57                   	push   %edi
80100ff4:	56                   	push   %esi
80100ff5:	53                   	push   %ebx
80100ff6:	83 ec 1c             	sub    $0x1c,%esp
80100ff9:	8b 75 08             	mov    0x8(%ebp),%esi
80100ffc:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fff:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
{
80101003:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101006:	8b 45 10             	mov    0x10(%ebp),%eax
80101009:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010100c:	0f 84 aa 00 00 00    	je     801010bc <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101012:	8b 06                	mov    (%esi),%eax
80101014:	83 f8 01             	cmp    $0x1,%eax
80101017:	0f 84 c3 00 00 00    	je     801010e0 <filewrite+0xf0>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010101d:	83 f8 02             	cmp    $0x2,%eax
80101020:	0f 85 d9 00 00 00    	jne    801010ff <filewrite+0x10f>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101029:	31 ff                	xor    %edi,%edi
    while(i < n){
8010102b:	85 c0                	test   %eax,%eax
8010102d:	7f 34                	jg     80101063 <filewrite+0x73>
8010102f:	e9 9c 00 00 00       	jmp    801010d0 <filewrite+0xe0>
80101034:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101038:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010103b:	83 ec 0c             	sub    $0xc,%esp
8010103e:	ff 76 10             	pushl  0x10(%esi)
        f->off += r;
80101041:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101044:	e8 17 08 00 00       	call   80101860 <iunlock>
      end_op();
80101049:	e8 72 1d 00 00       	call   80102dc0 <end_op>
8010104e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101051:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101054:	39 c3                	cmp    %eax,%ebx
80101056:	0f 85 96 00 00 00    	jne    801010f2 <filewrite+0x102>
        panic("short filewrite");
      i += r;
8010105c:	01 df                	add    %ebx,%edi
    while(i < n){
8010105e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101061:	7e 6d                	jle    801010d0 <filewrite+0xe0>
      int n1 = n - i;
80101063:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101066:	b8 00 06 00 00       	mov    $0x600,%eax
8010106b:	29 fb                	sub    %edi,%ebx
8010106d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101073:	0f 4f d8             	cmovg  %eax,%ebx
      begin_op();
80101076:	e8 d5 1c 00 00       	call   80102d50 <begin_op>
      ilock(f->ip);
8010107b:	83 ec 0c             	sub    $0xc,%esp
8010107e:	ff 76 10             	pushl  0x10(%esi)
80101081:	e8 fa 06 00 00       	call   80101780 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101086:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101089:	53                   	push   %ebx
8010108a:	ff 76 14             	pushl  0x14(%esi)
8010108d:	01 f8                	add    %edi,%eax
8010108f:	50                   	push   %eax
80101090:	ff 76 10             	pushl  0x10(%esi)
80101093:	e8 78 0b 00 00       	call   80101c10 <writei>
80101098:	83 c4 20             	add    $0x20,%esp
8010109b:	85 c0                	test   %eax,%eax
8010109d:	7f 99                	jg     80101038 <filewrite+0x48>
      iunlock(f->ip);
8010109f:	83 ec 0c             	sub    $0xc,%esp
801010a2:	ff 76 10             	pushl  0x10(%esi)
801010a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
801010a8:	e8 b3 07 00 00       	call   80101860 <iunlock>
      end_op();
801010ad:	e8 0e 1d 00 00       	call   80102dc0 <end_op>
      if(r < 0)
801010b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010b5:	83 c4 10             	add    $0x10,%esp
801010b8:	85 c0                	test   %eax,%eax
801010ba:	74 98                	je     80101054 <filewrite+0x64>
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
801010bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
}
801010c4:	89 f8                	mov    %edi,%eax
801010c6:	5b                   	pop    %ebx
801010c7:	5e                   	pop    %esi
801010c8:	5f                   	pop    %edi
801010c9:	5d                   	pop    %ebp
801010ca:	c3                   	ret    
801010cb:	90                   	nop
801010cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return i == n ? n : -1;
801010d0:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
801010d3:	75 e7                	jne    801010bc <filewrite+0xcc>
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	89 f8                	mov    %edi,%eax
801010da:	5b                   	pop    %ebx
801010db:	5e                   	pop    %esi
801010dc:	5f                   	pop    %edi
801010dd:	5d                   	pop    %ebp
801010de:	c3                   	ret    
801010df:	90                   	nop
    return pipewrite(f->pipe, addr, n);
801010e0:	8b 46 0c             	mov    0xc(%esi),%eax
801010e3:	89 45 08             	mov    %eax,0x8(%ebp)
}
801010e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010e9:	5b                   	pop    %ebx
801010ea:	5e                   	pop    %esi
801010eb:	5f                   	pop    %edi
801010ec:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
801010ed:	e9 ae 24 00 00       	jmp    801035a0 <pipewrite>
        panic("short filewrite");
801010f2:	83 ec 0c             	sub    $0xc,%esp
801010f5:	68 ef 76 10 80       	push   $0x801076ef
801010fa:	e8 91 f2 ff ff       	call   80100390 <panic>
  panic("filewrite");
801010ff:	83 ec 0c             	sub    $0xc,%esp
80101102:	68 f5 76 10 80       	push   $0x801076f5
80101107:	e8 84 f2 ff ff       	call   80100390 <panic>
8010110c:	66 90                	xchg   %ax,%ax
8010110e:	66 90                	xchg   %ax,%ax

80101110 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101110:	55                   	push   %ebp
80101111:	89 e5                	mov    %esp,%ebp
80101113:	56                   	push   %esi
80101114:	53                   	push   %ebx
80101115:	89 d3                	mov    %edx,%ebx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101117:	c1 ea 0c             	shr    $0xc,%edx
8010111a:	03 15 18 1c 11 80    	add    0x80111c18,%edx
80101120:	83 ec 08             	sub    $0x8,%esp
80101123:	52                   	push   %edx
80101124:	50                   	push   %eax
80101125:	e8 a6 ef ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010112a:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010112c:	c1 fb 03             	sar    $0x3,%ebx
  m = 1 << (bi % 8);
8010112f:	ba 01 00 00 00       	mov    $0x1,%edx
80101134:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101137:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
8010113d:	83 c4 10             	add    $0x10,%esp
  m = 1 << (bi % 8);
80101140:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101142:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101147:	85 d1                	test   %edx,%ecx
80101149:	74 25                	je     80101170 <bfree+0x60>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010114b:	f7 d2                	not    %edx
8010114d:	89 c6                	mov    %eax,%esi
  log_write(bp);
8010114f:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101152:	21 ca                	and    %ecx,%edx
80101154:	88 54 1e 5c          	mov    %dl,0x5c(%esi,%ebx,1)
  log_write(bp);
80101158:	56                   	push   %esi
80101159:	e8 c2 1d 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010115e:	89 34 24             	mov    %esi,(%esp)
80101161:	e8 7a f0 ff ff       	call   801001e0 <brelse>
}
80101166:	83 c4 10             	add    $0x10,%esp
80101169:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010116c:	5b                   	pop    %ebx
8010116d:	5e                   	pop    %esi
8010116e:	5d                   	pop    %ebp
8010116f:	c3                   	ret    
    panic("freeing free block");
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	68 ff 76 10 80       	push   $0x801076ff
80101178:	e8 13 f2 ff ff       	call   80100390 <panic>
8010117d:	8d 76 00             	lea    0x0(%esi),%esi

80101180 <balloc>:
{
80101180:	55                   	push   %ebp
80101181:	89 e5                	mov    %esp,%ebp
80101183:	57                   	push   %edi
80101184:	56                   	push   %esi
80101185:	53                   	push   %ebx
80101186:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101189:	8b 0d 00 1c 11 80    	mov    0x80111c00,%ecx
{
8010118f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
80101192:	85 c9                	test   %ecx,%ecx
80101194:	0f 84 87 00 00 00    	je     80101221 <balloc+0xa1>
8010119a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801011a1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801011a4:	83 ec 08             	sub    $0x8,%esp
801011a7:	89 f0                	mov    %esi,%eax
801011a9:	c1 f8 0c             	sar    $0xc,%eax
801011ac:	03 05 18 1c 11 80    	add    0x80111c18,%eax
801011b2:	50                   	push   %eax
801011b3:	ff 75 d8             	pushl  -0x28(%ebp)
801011b6:	e8 15 ef ff ff       	call   801000d0 <bread>
801011bb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011be:	a1 00 1c 11 80       	mov    0x80111c00,%eax
801011c3:	83 c4 10             	add    $0x10,%esp
801011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
801011c9:	31 c0                	xor    %eax,%eax
801011cb:	eb 2f                	jmp    801011fc <balloc+0x7c>
801011cd:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
801011d0:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011d2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
801011d5:	bb 01 00 00 00       	mov    $0x1,%ebx
801011da:	83 e1 07             	and    $0x7,%ecx
801011dd:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
801011df:	89 c1                	mov    %eax,%ecx
801011e1:	c1 f9 03             	sar    $0x3,%ecx
801011e4:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
801011e9:	85 df                	test   %ebx,%edi
801011eb:	89 fa                	mov    %edi,%edx
801011ed:	74 41                	je     80101230 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801011ef:	83 c0 01             	add    $0x1,%eax
801011f2:	83 c6 01             	add    $0x1,%esi
801011f5:	3d 00 10 00 00       	cmp    $0x1000,%eax
801011fa:	74 05                	je     80101201 <balloc+0x81>
801011fc:	39 75 e0             	cmp    %esi,-0x20(%ebp)
801011ff:	77 cf                	ja     801011d0 <balloc+0x50>
    brelse(bp);
80101201:	83 ec 0c             	sub    $0xc,%esp
80101204:	ff 75 e4             	pushl  -0x1c(%ebp)
80101207:	e8 d4 ef ff ff       	call   801001e0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010120c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101213:	83 c4 10             	add    $0x10,%esp
80101216:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101219:	39 05 00 1c 11 80    	cmp    %eax,0x80111c00
8010121f:	77 80                	ja     801011a1 <balloc+0x21>
  panic("balloc: out of blocks");
80101221:	83 ec 0c             	sub    $0xc,%esp
80101224:	68 12 77 10 80       	push   $0x80107712
80101229:	e8 62 f1 ff ff       	call   80100390 <panic>
8010122e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101230:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101233:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101236:	09 da                	or     %ebx,%edx
80101238:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010123c:	57                   	push   %edi
8010123d:	e8 de 1c 00 00       	call   80102f20 <log_write>
        brelse(bp);
80101242:	89 3c 24             	mov    %edi,(%esp)
80101245:	e8 96 ef ff ff       	call   801001e0 <brelse>
  bp = bread(dev, bno);
8010124a:	58                   	pop    %eax
8010124b:	5a                   	pop    %edx
8010124c:	56                   	push   %esi
8010124d:	ff 75 d8             	pushl  -0x28(%ebp)
80101250:	e8 7b ee ff ff       	call   801000d0 <bread>
80101255:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101257:	8d 40 5c             	lea    0x5c(%eax),%eax
8010125a:	83 c4 0c             	add    $0xc,%esp
8010125d:	68 00 02 00 00       	push   $0x200
80101262:	6a 00                	push   $0x0
80101264:	50                   	push   %eax
80101265:	e8 06 38 00 00       	call   80104a70 <memset>
  log_write(bp);
8010126a:	89 1c 24             	mov    %ebx,(%esp)
8010126d:	e8 ae 1c 00 00       	call   80102f20 <log_write>
  brelse(bp);
80101272:	89 1c 24             	mov    %ebx,(%esp)
80101275:	e8 66 ef ff ff       	call   801001e0 <brelse>
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010128a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101290 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101290:	55                   	push   %ebp
80101291:	89 e5                	mov    %esp,%ebp
80101293:	57                   	push   %edi
80101294:	56                   	push   %esi
80101295:	53                   	push   %ebx
80101296:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101298:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010129a:	bb 54 1c 11 80       	mov    $0x80111c54,%ebx
{
8010129f:	83 ec 28             	sub    $0x28,%esp
801012a2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801012a5:	68 20 1c 11 80       	push   $0x80111c20
801012aa:	e8 b1 36 00 00       	call   80104960 <acquire>
801012af:	83 c4 10             	add    $0x10,%esp
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801012b5:	eb 17                	jmp    801012ce <iget+0x3e>
801012b7:	89 f6                	mov    %esi,%esi
801012b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801012c0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012c6:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
801012cc:	73 22                	jae    801012f0 <iget+0x60>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801012ce:	8b 4b 08             	mov    0x8(%ebx),%ecx
801012d1:	85 c9                	test   %ecx,%ecx
801012d3:	7e 04                	jle    801012d9 <iget+0x49>
801012d5:	39 3b                	cmp    %edi,(%ebx)
801012d7:	74 4f                	je     80101328 <iget+0x98>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012d9:	85 f6                	test   %esi,%esi
801012db:	75 e3                	jne    801012c0 <iget+0x30>
801012dd:	85 c9                	test   %ecx,%ecx
801012df:	0f 44 f3             	cmove  %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801012e2:	81 c3 90 00 00 00    	add    $0x90,%ebx
801012e8:	81 fb 74 38 11 80    	cmp    $0x80113874,%ebx
801012ee:	72 de                	jb     801012ce <iget+0x3e>
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012f0:	85 f6                	test   %esi,%esi
801012f2:	74 5b                	je     8010134f <iget+0xbf>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012f4:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
801012f7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012f9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012fc:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
80101303:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
8010130a:	68 20 1c 11 80       	push   $0x80111c20
8010130f:	e8 0c 37 00 00       	call   80104a20 <release>

  return ip;
80101314:	83 c4 10             	add    $0x10,%esp
}
80101317:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010131a:	89 f0                	mov    %esi,%eax
8010131c:	5b                   	pop    %ebx
8010131d:	5e                   	pop    %esi
8010131e:	5f                   	pop    %edi
8010131f:	5d                   	pop    %ebp
80101320:	c3                   	ret    
80101321:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101328:	39 53 04             	cmp    %edx,0x4(%ebx)
8010132b:	75 ac                	jne    801012d9 <iget+0x49>
      release(&icache.lock);
8010132d:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101330:	83 c1 01             	add    $0x1,%ecx
      return ip;
80101333:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
80101335:	68 20 1c 11 80       	push   $0x80111c20
      ip->ref++;
8010133a:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
8010133d:	e8 de 36 00 00       	call   80104a20 <release>
      return ip;
80101342:	83 c4 10             	add    $0x10,%esp
}
80101345:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101348:	89 f0                	mov    %esi,%eax
8010134a:	5b                   	pop    %ebx
8010134b:	5e                   	pop    %esi
8010134c:	5f                   	pop    %edi
8010134d:	5d                   	pop    %ebp
8010134e:	c3                   	ret    
    panic("iget: no inodes");
8010134f:	83 ec 0c             	sub    $0xc,%esp
80101352:	68 28 77 10 80       	push   $0x80107728
80101357:	e8 34 f0 ff ff       	call   80100390 <panic>
8010135c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101360 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
80101360:	55                   	push   %ebp
80101361:	89 e5                	mov    %esp,%ebp
80101363:	57                   	push   %edi
80101364:	56                   	push   %esi
80101365:	53                   	push   %ebx
80101366:	89 c6                	mov    %eax,%esi
80101368:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
8010136b:	83 fa 0a             	cmp    $0xa,%edx
8010136e:	77 20                	ja     80101390 <bmap+0x30>
80101370:	8d 3c 90             	lea    (%eax,%edx,4),%edi
    if((addr = ip->addrs[bn]) == 0)
80101373:	8b 5f 5c             	mov    0x5c(%edi),%ebx
80101376:	85 db                	test   %ebx,%ebx
80101378:	0f 84 e2 00 00 00    	je     80101460 <bmap+0x100>
    brelse(bp);
    return addr;
    }
    
  panic("bmap: out of range");
}
8010137e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101381:	89 d8                	mov    %ebx,%eax
80101383:	5b                   	pop    %ebx
80101384:	5e                   	pop    %esi
80101385:	5f                   	pop    %edi
80101386:	5d                   	pop    %ebp
80101387:	c3                   	ret    
80101388:	90                   	nop
80101389:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  bn -= NDIRECT;
80101390:	8d 5a f5             	lea    -0xb(%edx),%ebx
  if(bn < NINDIRECT) {
80101393:	83 fb 7f             	cmp    $0x7f,%ebx
80101396:	0f 86 84 00 00 00    	jbe    80101420 <bmap+0xc0>
  bn -= NINDIRECT;
8010139c:	8d 9a 75 ff ff ff    	lea    -0x8b(%edx),%ebx
  if(bn < NINDIRECT * NINDIRECT){
801013a2:	81 fb ff 3f 00 00    	cmp    $0x3fff,%ebx
801013a8:	0f 87 7e 01 00 00    	ja     8010152c <bmap+0x1cc>
    if((addr = ip->addrs[NDIRECT+1]) == 0)
801013ae:	8b 90 8c 00 00 00    	mov    0x8c(%eax),%edx
801013b4:	8b 00                	mov    (%eax),%eax
801013b6:	85 d2                	test   %edx,%edx
801013b8:	0f 84 5a 01 00 00    	je     80101518 <bmap+0x1b8>
    bp = bread(ip->dev, addr);
801013be:	83 ec 08             	sub    $0x8,%esp
    int second = bn % NINDIRECT;
801013c1:	89 df                	mov    %ebx,%edi
    int first = bn / NINDIRECT;
801013c3:	c1 eb 07             	shr    $0x7,%ebx
    bp = bread(ip->dev, addr);
801013c6:	52                   	push   %edx
801013c7:	50                   	push   %eax
    int second = bn % NINDIRECT;
801013c8:	83 e7 7f             	and    $0x7f,%edi
    bp = bread(ip->dev, addr);
801013cb:	e8 00 ed ff ff       	call   801000d0 <bread>
    if((addr = a[first]) == 0){
801013d0:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
801013d4:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013d7:	89 c1                	mov    %eax,%ecx
    if((addr = a[first]) == 0){
801013d9:	8b 1a                	mov    (%edx),%ebx
801013db:	85 db                	test   %ebx,%ebx
801013dd:	0f 84 ed 00 00 00    	je     801014d0 <bmap+0x170>
    brelse(bp);
801013e3:	83 ec 0c             	sub    $0xc,%esp
801013e6:	51                   	push   %ecx
801013e7:	e8 f4 ed ff ff       	call   801001e0 <brelse>
    bp = bread(ip->dev, addr);
801013ec:	58                   	pop    %eax
801013ed:	5a                   	pop    %edx
801013ee:	53                   	push   %ebx
801013ef:	ff 36                	pushl  (%esi)
801013f1:	e8 da ec ff ff       	call   801000d0 <bread>
    if((addr = a[second]) == 0) {
801013f6:	8d 7c b8 5c          	lea    0x5c(%eax,%edi,4),%edi
801013fa:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
801013fd:	89 c2                	mov    %eax,%edx
    if((addr = a[second]) == 0) {
801013ff:	8b 1f                	mov    (%edi),%ebx
80101401:	85 db                	test   %ebx,%ebx
80101403:	74 7b                	je     80101480 <bmap+0x120>
    brelse(bp);
80101405:	83 ec 0c             	sub    $0xc,%esp
80101408:	52                   	push   %edx
80101409:	e8 d2 ed ff ff       	call   801001e0 <brelse>
8010140e:	83 c4 10             	add    $0x10,%esp
}
80101411:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101414:	89 d8                	mov    %ebx,%eax
80101416:	5b                   	pop    %ebx
80101417:	5e                   	pop    %esi
80101418:	5f                   	pop    %edi
80101419:	5d                   	pop    %ebp
8010141a:	c3                   	ret    
8010141b:	90                   	nop
8010141c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((addr = ip->addrs[NDIRECT]) == 0) // 128 addrs 까지 가지고있는 block이 할당이 안되어있으면 할당해줌.
80101420:	8b 90 88 00 00 00    	mov    0x88(%eax),%edx
80101426:	8b 00                	mov    (%eax),%eax
80101428:	85 d2                	test   %edx,%edx
8010142a:	0f 84 d0 00 00 00    	je     80101500 <bmap+0x1a0>
    bp = bread(ip->dev, addr);
80101430:	83 ec 08             	sub    $0x8,%esp
80101433:	52                   	push   %edx
80101434:	50                   	push   %eax
80101435:	e8 96 ec ff ff       	call   801000d0 <bread>
    if((addr = a[bn]) == 0){
8010143a:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010143e:	83 c4 10             	add    $0x10,%esp
    bp = bread(ip->dev, addr);
80101441:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101443:	8b 1a                	mov    (%edx),%ebx
80101445:	85 db                	test   %ebx,%ebx
80101447:	74 5f                	je     801014a8 <bmap+0x148>
    brelse(bp);
80101449:	83 ec 0c             	sub    $0xc,%esp
8010144c:	57                   	push   %edi
8010144d:	e8 8e ed ff ff       	call   801001e0 <brelse>
80101452:	83 c4 10             	add    $0x10,%esp
}
80101455:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101458:	89 d8                	mov    %ebx,%eax
8010145a:	5b                   	pop    %ebx
8010145b:	5e                   	pop    %esi
8010145c:	5f                   	pop    %edi
8010145d:	5d                   	pop    %ebp
8010145e:	c3                   	ret    
8010145f:	90                   	nop
      ip->addrs[bn] = addr = balloc(ip->dev);
80101460:	8b 00                	mov    (%eax),%eax
80101462:	e8 19 fd ff ff       	call   80101180 <balloc>
80101467:	89 47 5c             	mov    %eax,0x5c(%edi)
}
8010146a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      ip->addrs[bn] = addr = balloc(ip->dev);
8010146d:	89 c3                	mov    %eax,%ebx
}
8010146f:	89 d8                	mov    %ebx,%eax
80101471:	5b                   	pop    %ebx
80101472:	5e                   	pop    %esi
80101473:	5f                   	pop    %edi
80101474:	5d                   	pop    %ebp
80101475:	c3                   	ret    
80101476:	8d 76 00             	lea    0x0(%esi),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80101480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[second] = addr = balloc(ip->dev);
80101483:	8b 06                	mov    (%esi),%eax
80101485:	e8 f6 fc ff ff       	call   80101180 <balloc>
      log_write(bp);
8010148a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010148d:	83 ec 0c             	sub    $0xc,%esp
      a[second] = addr = balloc(ip->dev);
80101490:	89 07                	mov    %eax,(%edi)
80101492:	89 c3                	mov    %eax,%ebx
      log_write(bp);
80101494:	52                   	push   %edx
80101495:	e8 86 1a 00 00       	call   80102f20 <log_write>
8010149a:	83 c4 10             	add    $0x10,%esp
8010149d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801014a0:	e9 60 ff ff ff       	jmp    80101405 <bmap+0xa5>
801014a5:	8d 76 00             	lea    0x0(%esi),%esi
      a[bn] = addr = balloc(ip->dev);
801014a8:	8b 06                	mov    (%esi),%eax
801014aa:	89 55 e4             	mov    %edx,-0x1c(%ebp)
801014ad:	e8 ce fc ff ff       	call   80101180 <balloc>
801014b2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
801014b5:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
801014b8:	89 c3                	mov    %eax,%ebx
801014ba:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014bc:	57                   	push   %edi
801014bd:	e8 5e 1a 00 00       	call   80102f20 <log_write>
801014c2:	83 c4 10             	add    $0x10,%esp
801014c5:	eb 82                	jmp    80101449 <bmap+0xe9>
801014c7:	89 f6                	mov    %esi,%esi
801014c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801014d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[first] = addr = balloc(ip->dev);
801014d3:	8b 06                	mov    (%esi),%eax
801014d5:	89 55 e0             	mov    %edx,-0x20(%ebp)
801014d8:	e8 a3 fc ff ff       	call   80101180 <balloc>
      log_write(bp);
801014dd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      a[first] = addr = balloc(ip->dev);
801014e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
      log_write(bp);
801014e3:	83 ec 0c             	sub    $0xc,%esp
      a[first] = addr = balloc(ip->dev);
801014e6:	89 c3                	mov    %eax,%ebx
801014e8:	89 02                	mov    %eax,(%edx)
      log_write(bp);
801014ea:	51                   	push   %ecx
801014eb:	e8 30 1a 00 00       	call   80102f20 <log_write>
801014f0:	83 c4 10             	add    $0x10,%esp
801014f3:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801014f6:	e9 e8 fe ff ff       	jmp    801013e3 <bmap+0x83>
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101500:	e8 7b fc ff ff       	call   80101180 <balloc>
80101505:	89 c2                	mov    %eax,%edx
80101507:	89 86 88 00 00 00    	mov    %eax,0x88(%esi)
8010150d:	8b 06                	mov    (%esi),%eax
8010150f:	e9 1c ff ff ff       	jmp    80101430 <bmap+0xd0>
80101514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ip->addrs[NDIRECT + 1] = addr = balloc(ip->dev);
80101518:	e8 63 fc ff ff       	call   80101180 <balloc>
8010151d:	89 c2                	mov    %eax,%edx
8010151f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101525:	8b 06                	mov    (%esi),%eax
80101527:	e9 92 fe ff ff       	jmp    801013be <bmap+0x5e>
  panic("bmap: out of range");
8010152c:	83 ec 0c             	sub    $0xc,%esp
8010152f:	68 38 77 10 80       	push   $0x80107738
80101534:	e8 57 ee ff ff       	call   80100390 <panic>
80101539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101540 <readsb>:
{
80101540:	55                   	push   %ebp
80101541:	89 e5                	mov    %esp,%ebp
80101543:	56                   	push   %esi
80101544:	53                   	push   %ebx
80101545:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
80101548:	83 ec 08             	sub    $0x8,%esp
8010154b:	6a 01                	push   $0x1
8010154d:	ff 75 08             	pushl  0x8(%ebp)
80101550:	e8 7b eb ff ff       	call   801000d0 <bread>
80101555:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101557:	8d 40 5c             	lea    0x5c(%eax),%eax
8010155a:	83 c4 0c             	add    $0xc,%esp
8010155d:	6a 1c                	push   $0x1c
8010155f:	50                   	push   %eax
80101560:	56                   	push   %esi
80101561:	e8 ba 35 00 00       	call   80104b20 <memmove>
  brelse(bp);
80101566:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101569:	83 c4 10             	add    $0x10,%esp
}
8010156c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010156f:	5b                   	pop    %ebx
80101570:	5e                   	pop    %esi
80101571:	5d                   	pop    %ebp
  brelse(bp);
80101572:	e9 69 ec ff ff       	jmp    801001e0 <brelse>
80101577:	89 f6                	mov    %esi,%esi
80101579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101580 <iinit>:
{
80101580:	55                   	push   %ebp
80101581:	89 e5                	mov    %esp,%ebp
80101583:	53                   	push   %ebx
80101584:	bb 60 1c 11 80       	mov    $0x80111c60,%ebx
80101589:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
8010158c:	68 4b 77 10 80       	push   $0x8010774b
80101591:	68 20 1c 11 80       	push   $0x80111c20
80101596:	e8 85 32 00 00       	call   80104820 <initlock>
8010159b:	83 c4 10             	add    $0x10,%esp
8010159e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
801015a0:	83 ec 08             	sub    $0x8,%esp
801015a3:	68 52 77 10 80       	push   $0x80107752
801015a8:	53                   	push   %ebx
801015a9:	81 c3 90 00 00 00    	add    $0x90,%ebx
801015af:	e8 3c 31 00 00       	call   801046f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801015b4:	83 c4 10             	add    $0x10,%esp
801015b7:	81 fb 80 38 11 80    	cmp    $0x80113880,%ebx
801015bd:	75 e1                	jne    801015a0 <iinit+0x20>
  readsb(dev, &sb);
801015bf:	83 ec 08             	sub    $0x8,%esp
801015c2:	68 00 1c 11 80       	push   $0x80111c00
801015c7:	ff 75 08             	pushl  0x8(%ebp)
801015ca:	e8 71 ff ff ff       	call   80101540 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801015cf:	ff 35 18 1c 11 80    	pushl  0x80111c18
801015d5:	ff 35 14 1c 11 80    	pushl  0x80111c14
801015db:	ff 35 10 1c 11 80    	pushl  0x80111c10
801015e1:	ff 35 0c 1c 11 80    	pushl  0x80111c0c
801015e7:	ff 35 08 1c 11 80    	pushl  0x80111c08
801015ed:	ff 35 04 1c 11 80    	pushl  0x80111c04
801015f3:	ff 35 00 1c 11 80    	pushl  0x80111c00
801015f9:	68 b8 77 10 80       	push   $0x801077b8
801015fe:	e8 5d f0 ff ff       	call   80100660 <cprintf>
}
80101603:	83 c4 30             	add    $0x30,%esp
80101606:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101609:	c9                   	leave  
8010160a:	c3                   	ret    
8010160b:	90                   	nop
8010160c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101610 <ialloc>:
{
80101610:	55                   	push   %ebp
80101611:	89 e5                	mov    %esp,%ebp
80101613:	57                   	push   %edi
80101614:	56                   	push   %esi
80101615:	53                   	push   %ebx
80101616:	83 ec 1c             	sub    $0x1c,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101619:	83 3d 08 1c 11 80 01 	cmpl   $0x1,0x80111c08
{
80101620:	8b 45 0c             	mov    0xc(%ebp),%eax
80101623:	8b 75 08             	mov    0x8(%ebp),%esi
80101626:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
80101629:	0f 86 91 00 00 00    	jbe    801016c0 <ialloc+0xb0>
8010162f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101634:	eb 21                	jmp    80101657 <ialloc+0x47>
80101636:	8d 76 00             	lea    0x0(%esi),%esi
80101639:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    brelse(bp);
80101640:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
80101643:	83 c3 01             	add    $0x1,%ebx
    brelse(bp);
80101646:	57                   	push   %edi
80101647:	e8 94 eb ff ff       	call   801001e0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
8010164c:	83 c4 10             	add    $0x10,%esp
8010164f:	39 1d 08 1c 11 80    	cmp    %ebx,0x80111c08
80101655:	76 69                	jbe    801016c0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101657:	89 d8                	mov    %ebx,%eax
80101659:	83 ec 08             	sub    $0x8,%esp
8010165c:	c1 e8 03             	shr    $0x3,%eax
8010165f:	03 05 14 1c 11 80    	add    0x80111c14,%eax
80101665:	50                   	push   %eax
80101666:	56                   	push   %esi
80101667:	e8 64 ea ff ff       	call   801000d0 <bread>
8010166c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010166e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101670:	83 c4 10             	add    $0x10,%esp
    dip = (struct dinode*)bp->data + inum%IPB;
80101673:	83 e0 07             	and    $0x7,%eax
80101676:	c1 e0 06             	shl    $0x6,%eax
80101679:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010167d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101681:	75 bd                	jne    80101640 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101683:	83 ec 04             	sub    $0x4,%esp
80101686:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101689:	6a 40                	push   $0x40
8010168b:	6a 00                	push   $0x0
8010168d:	51                   	push   %ecx
8010168e:	e8 dd 33 00 00       	call   80104a70 <memset>
      dip->type = type;
80101693:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101697:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010169a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010169d:	89 3c 24             	mov    %edi,(%esp)
801016a0:	e8 7b 18 00 00       	call   80102f20 <log_write>
      brelse(bp);
801016a5:	89 3c 24             	mov    %edi,(%esp)
801016a8:	e8 33 eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
801016ad:	83 c4 10             	add    $0x10,%esp
}
801016b0:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
801016b3:	89 da                	mov    %ebx,%edx
801016b5:	89 f0                	mov    %esi,%eax
}
801016b7:	5b                   	pop    %ebx
801016b8:	5e                   	pop    %esi
801016b9:	5f                   	pop    %edi
801016ba:	5d                   	pop    %ebp
      return iget(dev, inum);
801016bb:	e9 d0 fb ff ff       	jmp    80101290 <iget>
  panic("ialloc: no inodes");
801016c0:	83 ec 0c             	sub    $0xc,%esp
801016c3:	68 58 77 10 80       	push   $0x80107758
801016c8:	e8 c3 ec ff ff       	call   80100390 <panic>
801016cd:	8d 76 00             	lea    0x0(%esi),%esi

801016d0 <iupdate>:
{
801016d0:	55                   	push   %ebp
801016d1:	89 e5                	mov    %esp,%ebp
801016d3:	56                   	push   %esi
801016d4:	53                   	push   %ebx
801016d5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016d8:	83 ec 08             	sub    $0x8,%esp
801016db:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016de:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016e1:	c1 e8 03             	shr    $0x3,%eax
801016e4:	03 05 14 1c 11 80    	add    0x80111c14,%eax
801016ea:	50                   	push   %eax
801016eb:	ff 73 a4             	pushl  -0x5c(%ebx)
801016ee:	e8 dd e9 ff ff       	call   801000d0 <bread>
801016f3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016f5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801016f8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801016fc:	83 c4 0c             	add    $0xc,%esp
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801016ff:	83 e0 07             	and    $0x7,%eax
80101702:	c1 e0 06             	shl    $0x6,%eax
80101705:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101709:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010170c:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101710:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
80101713:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101717:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010171b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010171f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101723:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101727:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010172a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010172d:	6a 34                	push   $0x34
8010172f:	53                   	push   %ebx
80101730:	50                   	push   %eax
80101731:	e8 ea 33 00 00       	call   80104b20 <memmove>
  log_write(bp);
80101736:	89 34 24             	mov    %esi,(%esp)
80101739:	e8 e2 17 00 00       	call   80102f20 <log_write>
  brelse(bp);
8010173e:	89 75 08             	mov    %esi,0x8(%ebp)
80101741:	83 c4 10             	add    $0x10,%esp
}
80101744:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101747:	5b                   	pop    %ebx
80101748:	5e                   	pop    %esi
80101749:	5d                   	pop    %ebp
  brelse(bp);
8010174a:	e9 91 ea ff ff       	jmp    801001e0 <brelse>
8010174f:	90                   	nop

80101750 <idup>:
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	53                   	push   %ebx
80101754:	83 ec 10             	sub    $0x10,%esp
80101757:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010175a:	68 20 1c 11 80       	push   $0x80111c20
8010175f:	e8 fc 31 00 00       	call   80104960 <acquire>
  ip->ref++;
80101764:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101768:	c7 04 24 20 1c 11 80 	movl   $0x80111c20,(%esp)
8010176f:	e8 ac 32 00 00       	call   80104a20 <release>
}
80101774:	89 d8                	mov    %ebx,%eax
80101776:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101779:	c9                   	leave  
8010177a:	c3                   	ret    
8010177b:	90                   	nop
8010177c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101780 <ilock>:
{
80101780:	55                   	push   %ebp
80101781:	89 e5                	mov    %esp,%ebp
80101783:	56                   	push   %esi
80101784:	53                   	push   %ebx
80101785:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101788:	85 db                	test   %ebx,%ebx
8010178a:	0f 84 b7 00 00 00    	je     80101847 <ilock+0xc7>
80101790:	8b 53 08             	mov    0x8(%ebx),%edx
80101793:	85 d2                	test   %edx,%edx
80101795:	0f 8e ac 00 00 00    	jle    80101847 <ilock+0xc7>
  acquiresleep(&ip->lock);
8010179b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010179e:	83 ec 0c             	sub    $0xc,%esp
801017a1:	50                   	push   %eax
801017a2:	e8 89 2f 00 00       	call   80104730 <acquiresleep>
  if(ip->valid == 0){
801017a7:	8b 43 4c             	mov    0x4c(%ebx),%eax
801017aa:	83 c4 10             	add    $0x10,%esp
801017ad:	85 c0                	test   %eax,%eax
801017af:	74 0f                	je     801017c0 <ilock+0x40>
}
801017b1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017b4:	5b                   	pop    %ebx
801017b5:	5e                   	pop    %esi
801017b6:	5d                   	pop    %ebp
801017b7:	c3                   	ret    
801017b8:	90                   	nop
801017b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801017c0:	8b 43 04             	mov    0x4(%ebx),%eax
801017c3:	83 ec 08             	sub    $0x8,%esp
801017c6:	c1 e8 03             	shr    $0x3,%eax
801017c9:	03 05 14 1c 11 80    	add    0x80111c14,%eax
801017cf:	50                   	push   %eax
801017d0:	ff 33                	pushl  (%ebx)
801017d2:	e8 f9 e8 ff ff       	call   801000d0 <bread>
801017d7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017d9:	8b 43 04             	mov    0x4(%ebx),%eax
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017dc:	83 c4 0c             	add    $0xc,%esp
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801017df:	83 e0 07             	and    $0x7,%eax
801017e2:	c1 e0 06             	shl    $0x6,%eax
801017e5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801017e9:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801017ec:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
801017ef:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801017f3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801017f7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801017fb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801017ff:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101803:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
80101807:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010180b:	8b 50 fc             	mov    -0x4(%eax),%edx
8010180e:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101811:	6a 34                	push   $0x34
80101813:	50                   	push   %eax
80101814:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101817:	50                   	push   %eax
80101818:	e8 03 33 00 00       	call   80104b20 <memmove>
    brelse(bp);
8010181d:	89 34 24             	mov    %esi,(%esp)
80101820:	e8 bb e9 ff ff       	call   801001e0 <brelse>
    if(ip->type == 0)
80101825:	83 c4 10             	add    $0x10,%esp
80101828:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
8010182d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101834:	0f 85 77 ff ff ff    	jne    801017b1 <ilock+0x31>
      panic("ilock: no type");
8010183a:	83 ec 0c             	sub    $0xc,%esp
8010183d:	68 70 77 10 80       	push   $0x80107770
80101842:	e8 49 eb ff ff       	call   80100390 <panic>
    panic("ilock");
80101847:	83 ec 0c             	sub    $0xc,%esp
8010184a:	68 6a 77 10 80       	push   $0x8010776a
8010184f:	e8 3c eb ff ff       	call   80100390 <panic>
80101854:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010185a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101860 <iunlock>:
{
80101860:	55                   	push   %ebp
80101861:	89 e5                	mov    %esp,%ebp
80101863:	56                   	push   %esi
80101864:	53                   	push   %ebx
80101865:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101868:	85 db                	test   %ebx,%ebx
8010186a:	74 28                	je     80101894 <iunlock+0x34>
8010186c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010186f:	83 ec 0c             	sub    $0xc,%esp
80101872:	56                   	push   %esi
80101873:	e8 58 2f 00 00       	call   801047d0 <holdingsleep>
80101878:	83 c4 10             	add    $0x10,%esp
8010187b:	85 c0                	test   %eax,%eax
8010187d:	74 15                	je     80101894 <iunlock+0x34>
8010187f:	8b 43 08             	mov    0x8(%ebx),%eax
80101882:	85 c0                	test   %eax,%eax
80101884:	7e 0e                	jle    80101894 <iunlock+0x34>
  releasesleep(&ip->lock);
80101886:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101889:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010188c:	5b                   	pop    %ebx
8010188d:	5e                   	pop    %esi
8010188e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010188f:	e9 fc 2e 00 00       	jmp    80104790 <releasesleep>
    panic("iunlock");
80101894:	83 ec 0c             	sub    $0xc,%esp
80101897:	68 7f 77 10 80       	push   $0x8010777f
8010189c:	e8 ef ea ff ff       	call   80100390 <panic>
801018a1:	eb 0d                	jmp    801018b0 <iput>
801018a3:	90                   	nop
801018a4:	90                   	nop
801018a5:	90                   	nop
801018a6:	90                   	nop
801018a7:	90                   	nop
801018a8:	90                   	nop
801018a9:	90                   	nop
801018aa:	90                   	nop
801018ab:	90                   	nop
801018ac:	90                   	nop
801018ad:	90                   	nop
801018ae:	90                   	nop
801018af:	90                   	nop

801018b0 <iput>:
{
801018b0:	55                   	push   %ebp
801018b1:	89 e5                	mov    %esp,%ebp
801018b3:	57                   	push   %edi
801018b4:	56                   	push   %esi
801018b5:	53                   	push   %ebx
801018b6:	83 ec 38             	sub    $0x38,%esp
801018b9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801018bc:	8d 46 0c             	lea    0xc(%esi),%eax
801018bf:	50                   	push   %eax
801018c0:	89 45 e0             	mov    %eax,-0x20(%ebp)
801018c3:	e8 68 2e 00 00       	call   80104730 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801018c8:	8b 56 4c             	mov    0x4c(%esi),%edx
801018cb:	83 c4 10             	add    $0x10,%esp
801018ce:	85 d2                	test   %edx,%edx
801018d0:	74 07                	je     801018d9 <iput+0x29>
801018d2:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801018d7:	74 31                	je     8010190a <iput+0x5a>
  releasesleep(&ip->lock);
801018d9:	83 ec 0c             	sub    $0xc,%esp
801018dc:	ff 75 e0             	pushl  -0x20(%ebp)
801018df:	e8 ac 2e 00 00       	call   80104790 <releasesleep>
  acquire(&icache.lock);
801018e4:	c7 04 24 20 1c 11 80 	movl   $0x80111c20,(%esp)
801018eb:	e8 70 30 00 00       	call   80104960 <acquire>
  ip->ref--;
801018f0:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801018f4:	83 c4 10             	add    $0x10,%esp
801018f7:	c7 45 08 20 1c 11 80 	movl   $0x80111c20,0x8(%ebp)
}
801018fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101901:	5b                   	pop    %ebx
80101902:	5e                   	pop    %esi
80101903:	5f                   	pop    %edi
80101904:	5d                   	pop    %ebp
  release(&icache.lock);
80101905:	e9 16 31 00 00       	jmp    80104a20 <release>
    acquire(&icache.lock);
8010190a:	83 ec 0c             	sub    $0xc,%esp
8010190d:	68 20 1c 11 80       	push   $0x80111c20
80101912:	e8 49 30 00 00       	call   80104960 <acquire>
    int r = ip->ref;
80101917:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010191a:	c7 04 24 20 1c 11 80 	movl   $0x80111c20,(%esp)
80101921:	e8 fa 30 00 00       	call   80104a20 <release>
    if(r == 1){
80101926:	83 c4 10             	add    $0x10,%esp
80101929:	83 fb 01             	cmp    $0x1,%ebx
8010192c:	75 ab                	jne    801018d9 <iput+0x29>
8010192e:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101931:	8d be 88 00 00 00    	lea    0x88(%esi),%edi
80101937:	eb 0e                	jmp    80101947 <iput+0x97>
80101939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101940:	83 c3 04             	add    $0x4,%ebx
  struct buf *bp;
  struct buf *bp1;
  uint *b;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101943:	39 fb                	cmp    %edi,%ebx
80101945:	74 15                	je     8010195c <iput+0xac>
    if(ip->addrs[i]){
80101947:	8b 13                	mov    (%ebx),%edx
80101949:	85 d2                	test   %edx,%edx
8010194b:	74 f3                	je     80101940 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010194d:	8b 06                	mov    (%esi),%eax
8010194f:	e8 bc f7 ff ff       	call   80101110 <bfree>
      ip->addrs[i] = 0;
80101954:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010195a:	eb e4                	jmp    80101940 <iput+0x90>
    }
  }
//single
  if(ip->addrs[NDIRECT]){
8010195c:	8b 86 88 00 00 00    	mov    0x88(%esi),%eax
80101962:	85 c0                	test   %eax,%eax
80101964:	0f 85 f7 00 00 00    	jne    80101a61 <iput+0x1b1>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

//double
  if(ip->addrs[NDIRECT+1]) {
8010196a:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101970:	85 c0                	test   %eax,%eax
80101972:	75 2d                	jne    801019a1 <iput+0xf1>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }
   ip->size = 0;
   iupdate(ip);
80101974:	83 ec 0c             	sub    $0xc,%esp
   ip->size = 0;
80101977:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
   iupdate(ip);
8010197e:	56                   	push   %esi
8010197f:	e8 4c fd ff ff       	call   801016d0 <iupdate>
      ip->type = 0;
80101984:	31 c0                	xor    %eax,%eax
80101986:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
8010198a:	89 34 24             	mov    %esi,(%esp)
8010198d:	e8 3e fd ff ff       	call   801016d0 <iupdate>
      ip->valid = 0;
80101992:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101999:	83 c4 10             	add    $0x10,%esp
8010199c:	e9 38 ff ff ff       	jmp    801018d9 <iput+0x29>
     bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
801019a1:	83 ec 08             	sub    $0x8,%esp
801019a4:	50                   	push   %eax
801019a5:	ff 36                	pushl  (%esi)
801019a7:	e8 24 e7 ff ff       	call   801000d0 <bread>
     a = (uint*)bp->data;
801019ac:	8d 48 5c             	lea    0x5c(%eax),%ecx
     bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
801019af:	89 45 d4             	mov    %eax,-0x2c(%ebp)
801019b2:	05 5c 02 00 00       	add    $0x25c,%eax
801019b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801019ba:	83 c4 10             	add    $0x10,%esp
     a = (uint*)bp->data;
801019bd:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801019c0:	eb 12                	jmp    801019d4 <iput+0x124>
801019c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801019c8:	83 45 e4 04          	addl   $0x4,-0x1c(%ebp)
801019cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     for(k = 0; k < NINDIRECT; k++)
801019cf:	39 45 dc             	cmp    %eax,-0x24(%ebp)
801019d2:	74 63                	je     80101a37 <iput+0x187>
       if(a[k])
801019d4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d7:	8b 00                	mov    (%eax),%eax
801019d9:	85 c0                	test   %eax,%eax
801019db:	74 eb                	je     801019c8 <iput+0x118>
          bp1 = bread(ip->dev, a[k]);
801019dd:	83 ec 08             	sub    $0x8,%esp
801019e0:	50                   	push   %eax
801019e1:	ff 36                	pushl  (%esi)
801019e3:	e8 e8 e6 ff ff       	call   801000d0 <bread>
801019e8:	83 c4 10             	add    $0x10,%esp
801019eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
          b = (uint*)bp1->data;
801019ee:	8d 58 5c             	lea    0x5c(%eax),%ebx
801019f1:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
801019f7:	eb 0e                	jmp    80101a07 <iput+0x157>
801019f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101a00:	83 c3 04             	add    $0x4,%ebx
         for(j = 0; j < NINDIRECT; j++){
80101a03:	39 df                	cmp    %ebx,%edi
80101a05:	74 14                	je     80101a1b <iput+0x16b>
           if(b[j])
80101a07:	8b 13                	mov    (%ebx),%edx
80101a09:	85 d2                	test   %edx,%edx
80101a0b:	74 f3                	je     80101a00 <iput+0x150>
             bfree(ip->dev, b[j]);
80101a0d:	8b 06                	mov    (%esi),%eax
80101a0f:	83 c3 04             	add    $0x4,%ebx
80101a12:	e8 f9 f6 ff ff       	call   80101110 <bfree>
         for(j = 0; j < NINDIRECT; j++){
80101a17:	39 df                	cmp    %ebx,%edi
80101a19:	75 ec                	jne    80101a07 <iput+0x157>
         brelse(bp1);
80101a1b:	83 ec 0c             	sub    $0xc,%esp
80101a1e:	ff 75 d8             	pushl  -0x28(%ebp)
80101a21:	e8 ba e7 ff ff       	call   801001e0 <brelse>
         bfree(ip->dev, a[k]);
80101a26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101a29:	8b 10                	mov    (%eax),%edx
80101a2b:	8b 06                	mov    (%esi),%eax
80101a2d:	e8 de f6 ff ff       	call   80101110 <bfree>
80101a32:	83 c4 10             	add    $0x10,%esp
80101a35:	eb 91                	jmp    801019c8 <iput+0x118>
    brelse(bp);
80101a37:	83 ec 0c             	sub    $0xc,%esp
80101a3a:	ff 75 d4             	pushl  -0x2c(%ebp)
80101a3d:	e8 9e e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
80101a42:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101a48:	8b 06                	mov    (%esi),%eax
80101a4a:	e8 c1 f6 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT+1] = 0;
80101a4f:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101a56:	00 00 00 
80101a59:	83 c4 10             	add    $0x10,%esp
80101a5c:	e9 13 ff ff ff       	jmp    80101974 <iput+0xc4>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);//cache에 있는 buf 읽어옴
80101a61:	83 ec 08             	sub    $0x8,%esp
80101a64:	50                   	push   %eax
80101a65:	ff 36                	pushl  (%esi)
80101a67:	e8 64 e6 ff ff       	call   801000d0 <bread>
80101a6c:	83 c4 10             	add    $0x10,%esp
80101a6f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
80101a72:	8d 58 5c             	lea    0x5c(%eax),%ebx
80101a75:	8d b8 5c 02 00 00    	lea    0x25c(%eax),%edi
80101a7b:	eb 0a                	jmp    80101a87 <iput+0x1d7>
80101a7d:	8d 76 00             	lea    0x0(%esi),%esi
80101a80:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
80101a83:	39 fb                	cmp    %edi,%ebx
80101a85:	74 0f                	je     80101a96 <iput+0x1e6>
      if(a[j])
80101a87:	8b 13                	mov    (%ebx),%edx
80101a89:	85 d2                	test   %edx,%edx
80101a8b:	74 f3                	je     80101a80 <iput+0x1d0>
        bfree(ip->dev, a[j]);// data free 시킴.
80101a8d:	8b 06                	mov    (%esi),%eax
80101a8f:	e8 7c f6 ff ff       	call   80101110 <bfree>
80101a94:	eb ea                	jmp    80101a80 <iput+0x1d0>
    brelse(bp);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a9c:	e8 3f e7 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101aa1:	8b 96 88 00 00 00    	mov    0x88(%esi),%edx
80101aa7:	8b 06                	mov    (%esi),%eax
80101aa9:	e8 62 f6 ff ff       	call   80101110 <bfree>
    ip->addrs[NDIRECT] = 0;
80101aae:	c7 86 88 00 00 00 00 	movl   $0x0,0x88(%esi)
80101ab5:	00 00 00 
80101ab8:	83 c4 10             	add    $0x10,%esp
80101abb:	e9 aa fe ff ff       	jmp    8010196a <iput+0xba>

80101ac0 <iunlockput>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	53                   	push   %ebx
80101ac4:	83 ec 10             	sub    $0x10,%esp
80101ac7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
80101aca:	53                   	push   %ebx
80101acb:	e8 90 fd ff ff       	call   80101860 <iunlock>
  iput(ip);
80101ad0:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101ad3:	83 c4 10             	add    $0x10,%esp
}
80101ad6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101ad9:	c9                   	leave  
  iput(ip);
80101ada:	e9 d1 fd ff ff       	jmp    801018b0 <iput>
80101adf:	90                   	nop

80101ae0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101ae0:	55                   	push   %ebp
80101ae1:	89 e5                	mov    %esp,%ebp
80101ae3:	8b 55 08             	mov    0x8(%ebp),%edx
80101ae6:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101ae9:	8b 0a                	mov    (%edx),%ecx
80101aeb:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101aee:	8b 4a 04             	mov    0x4(%edx),%ecx
80101af1:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101af4:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101af8:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101afb:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101aff:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b03:	8b 52 58             	mov    0x58(%edx),%edx
80101b06:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b09:	5d                   	pop    %ebp
80101b0a:	c3                   	ret    
80101b0b:	90                   	nop
80101b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101b10 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	57                   	push   %edi
80101b14:	56                   	push   %esi
80101b15:	53                   	push   %ebx
80101b16:	83 ec 1c             	sub    $0x1c,%esp
80101b19:	8b 45 08             	mov    0x8(%ebp),%eax
80101b1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101b1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b27:	89 75 e0             	mov    %esi,-0x20(%ebp)
80101b2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101b30:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b33:	0f 84 a7 00 00 00    	je     80101be0 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3c:	8b 40 58             	mov    0x58(%eax),%eax
80101b3f:	39 c6                	cmp    %eax,%esi
80101b41:	0f 87 ba 00 00 00    	ja     80101c01 <readi+0xf1>
80101b47:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101b4a:	89 f9                	mov    %edi,%ecx
80101b4c:	01 f1                	add    %esi,%ecx
80101b4e:	0f 82 ad 00 00 00    	jb     80101c01 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b54:	89 c2                	mov    %eax,%edx
80101b56:	29 f2                	sub    %esi,%edx
80101b58:	39 c8                	cmp    %ecx,%eax
80101b5a:	0f 43 d7             	cmovae %edi,%edx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b5d:	31 ff                	xor    %edi,%edi
80101b5f:	85 d2                	test   %edx,%edx
    n = ip->size - off;
80101b61:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b64:	74 6c                	je     80101bd2 <readi+0xc2>
80101b66:	8d 76 00             	lea    0x0(%esi),%esi
80101b69:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b70:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101b73:	89 f2                	mov    %esi,%edx
80101b75:	c1 ea 09             	shr    $0x9,%edx
80101b78:	89 d8                	mov    %ebx,%eax
80101b7a:	e8 e1 f7 ff ff       	call   80101360 <bmap>
80101b7f:	83 ec 08             	sub    $0x8,%esp
80101b82:	50                   	push   %eax
80101b83:	ff 33                	pushl  (%ebx)
80101b85:	e8 46 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8a:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101b8d:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101b8f:	89 f0                	mov    %esi,%eax
80101b91:	25 ff 01 00 00       	and    $0x1ff,%eax
80101b96:	b9 00 02 00 00       	mov    $0x200,%ecx
80101b9b:	83 c4 0c             	add    $0xc,%esp
80101b9e:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101ba0:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
80101ba4:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101ba7:	29 fb                	sub    %edi,%ebx
80101ba9:	39 d9                	cmp    %ebx,%ecx
80101bab:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bae:	53                   	push   %ebx
80101baf:	50                   	push   %eax
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb0:	01 df                	add    %ebx,%edi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb2:	ff 75 e0             	pushl  -0x20(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bb5:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101bb7:	e8 64 2f 00 00       	call   80104b20 <memmove>
    brelse(bp);
80101bbc:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bbf:	89 14 24             	mov    %edx,(%esp)
80101bc2:	e8 19 e6 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bc7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bca:	83 c4 10             	add    $0x10,%esp
80101bcd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101bd0:	77 9e                	ja     80101b70 <readi+0x60>
  }
  return n;
80101bd2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101bd5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bd8:	5b                   	pop    %ebx
80101bd9:	5e                   	pop    %esi
80101bda:	5f                   	pop    %edi
80101bdb:	5d                   	pop    %ebp
80101bdc:	c3                   	ret    
80101bdd:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101be0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101be4:	66 83 f8 09          	cmp    $0x9,%ax
80101be8:	77 17                	ja     80101c01 <readi+0xf1>
80101bea:	8b 04 c5 a0 1b 11 80 	mov    -0x7feee460(,%eax,8),%eax
80101bf1:	85 c0                	test   %eax,%eax
80101bf3:	74 0c                	je     80101c01 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101bf5:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101bf8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101bfb:	5b                   	pop    %ebx
80101bfc:	5e                   	pop    %esi
80101bfd:	5f                   	pop    %edi
80101bfe:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101bff:	ff e0                	jmp    *%eax
      return -1;
80101c01:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c06:	eb cd                	jmp    80101bd5 <readi+0xc5>
80101c08:	90                   	nop
80101c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101c10 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c10:	55                   	push   %ebp
80101c11:	89 e5                	mov    %esp,%ebp
80101c13:	57                   	push   %edi
80101c14:	56                   	push   %esi
80101c15:	53                   	push   %ebx
80101c16:	83 ec 1c             	sub    $0x1c,%esp
80101c19:	8b 45 08             	mov    0x8(%ebp),%eax
80101c1c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c1f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c22:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c27:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c2a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c2d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c30:	89 7d e0             	mov    %edi,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c33:	0f 84 b7 00 00 00    	je     80101cf0 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c39:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c3c:	39 70 58             	cmp    %esi,0x58(%eax)
80101c3f:	0f 82 eb 00 00 00    	jb     80101d30 <writei+0x120>
80101c45:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c48:	31 d2                	xor    %edx,%edx
80101c4a:	89 f8                	mov    %edi,%eax
80101c4c:	01 f0                	add    %esi,%eax
80101c4e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c51:	3d 00 16 81 00       	cmp    $0x811600,%eax
80101c56:	0f 87 d4 00 00 00    	ja     80101d30 <writei+0x120>
80101c5c:	85 d2                	test   %edx,%edx
80101c5e:	0f 85 cc 00 00 00    	jne    80101d30 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c64:	85 ff                	test   %edi,%edi
80101c66:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c6d:	74 72                	je     80101ce1 <writei+0xd1>
80101c6f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c70:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101c73:	89 f2                	mov    %esi,%edx
80101c75:	c1 ea 09             	shr    $0x9,%edx
80101c78:	89 f8                	mov    %edi,%eax
80101c7a:	e8 e1 f6 ff ff       	call   80101360 <bmap>
80101c7f:	83 ec 08             	sub    $0x8,%esp
80101c82:	50                   	push   %eax
80101c83:	ff 37                	pushl  (%edi)
80101c85:	e8 46 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101c8a:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101c8d:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101c90:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101c92:	89 f0                	mov    %esi,%eax
80101c94:	b9 00 02 00 00       	mov    $0x200,%ecx
80101c99:	83 c4 0c             	add    $0xc,%esp
80101c9c:	25 ff 01 00 00       	and    $0x1ff,%eax
80101ca1:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101ca3:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101ca7:	39 d9                	cmp    %ebx,%ecx
80101ca9:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cac:	53                   	push   %ebx
80101cad:	ff 75 dc             	pushl  -0x24(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cb0:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cb2:	50                   	push   %eax
80101cb3:	e8 68 2e 00 00       	call   80104b20 <memmove>
    log_write(bp);
80101cb8:	89 3c 24             	mov    %edi,(%esp)
80101cbb:	e8 60 12 00 00       	call   80102f20 <log_write>
    brelse(bp);
80101cc0:	89 3c 24             	mov    %edi,(%esp)
80101cc3:	e8 18 e5 ff ff       	call   801001e0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cc8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101ccb:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101cce:	83 c4 10             	add    $0x10,%esp
80101cd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101cd4:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101cd7:	77 97                	ja     80101c70 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101cd9:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101cdc:	3b 70 58             	cmp    0x58(%eax),%esi
80101cdf:	77 37                	ja     80101d18 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101ce1:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101ce4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ce7:	5b                   	pop    %ebx
80101ce8:	5e                   	pop    %esi
80101ce9:	5f                   	pop    %edi
80101cea:	5d                   	pop    %ebp
80101ceb:	c3                   	ret    
80101cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101cf0:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101cf4:	66 83 f8 09          	cmp    $0x9,%ax
80101cf8:	77 36                	ja     80101d30 <writei+0x120>
80101cfa:	8b 04 c5 a4 1b 11 80 	mov    -0x7feee45c(,%eax,8),%eax
80101d01:	85 c0                	test   %eax,%eax
80101d03:	74 2b                	je     80101d30 <writei+0x120>
    return devsw[ip->major].write(ip, src, n);
80101d05:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101d08:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d0b:	5b                   	pop    %ebx
80101d0c:	5e                   	pop    %esi
80101d0d:	5f                   	pop    %edi
80101d0e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d0f:	ff e0                	jmp    *%eax
80101d11:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d18:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d1b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d1e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d21:	50                   	push   %eax
80101d22:	e8 a9 f9 ff ff       	call   801016d0 <iupdate>
80101d27:	83 c4 10             	add    $0x10,%esp
80101d2a:	eb b5                	jmp    80101ce1 <writei+0xd1>
80101d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return -1;
80101d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d35:	eb ad                	jmp    80101ce4 <writei+0xd4>
80101d37:	89 f6                	mov    %esi,%esi
80101d39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d40 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d40:	55                   	push   %ebp
80101d41:	89 e5                	mov    %esp,%ebp
80101d43:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d46:	6a 0e                	push   $0xe
80101d48:	ff 75 0c             	pushl  0xc(%ebp)
80101d4b:	ff 75 08             	pushl  0x8(%ebp)
80101d4e:	e8 3d 2e 00 00       	call   80104b90 <strncmp>
}
80101d53:	c9                   	leave  
80101d54:	c3                   	ret    
80101d55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101d59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101d60 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d60:	55                   	push   %ebp
80101d61:	89 e5                	mov    %esp,%ebp
80101d63:	57                   	push   %edi
80101d64:	56                   	push   %esi
80101d65:	53                   	push   %ebx
80101d66:	83 ec 1c             	sub    $0x1c,%esp
80101d69:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d6c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101d71:	0f 85 85 00 00 00    	jne    80101dfc <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101d77:	8b 53 58             	mov    0x58(%ebx),%edx
80101d7a:	31 ff                	xor    %edi,%edi
80101d7c:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101d7f:	85 d2                	test   %edx,%edx
80101d81:	74 3e                	je     80101dc1 <dirlookup+0x61>
80101d83:	90                   	nop
80101d84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101d88:	6a 10                	push   $0x10
80101d8a:	57                   	push   %edi
80101d8b:	56                   	push   %esi
80101d8c:	53                   	push   %ebx
80101d8d:	e8 7e fd ff ff       	call   80101b10 <readi>
80101d92:	83 c4 10             	add    $0x10,%esp
80101d95:	83 f8 10             	cmp    $0x10,%eax
80101d98:	75 55                	jne    80101def <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101d9a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101d9f:	74 18                	je     80101db9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101da1:	8d 45 da             	lea    -0x26(%ebp),%eax
80101da4:	83 ec 04             	sub    $0x4,%esp
80101da7:	6a 0e                	push   $0xe
80101da9:	50                   	push   %eax
80101daa:	ff 75 0c             	pushl  0xc(%ebp)
80101dad:	e8 de 2d 00 00       	call   80104b90 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101db2:	83 c4 10             	add    $0x10,%esp
80101db5:	85 c0                	test   %eax,%eax
80101db7:	74 17                	je     80101dd0 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101db9:	83 c7 10             	add    $0x10,%edi
80101dbc:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101dbf:	72 c7                	jb     80101d88 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101dc1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101dc4:	31 c0                	xor    %eax,%eax
}
80101dc6:	5b                   	pop    %ebx
80101dc7:	5e                   	pop    %esi
80101dc8:	5f                   	pop    %edi
80101dc9:	5d                   	pop    %ebp
80101dca:	c3                   	ret    
80101dcb:	90                   	nop
80101dcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(poff)
80101dd0:	8b 45 10             	mov    0x10(%ebp),%eax
80101dd3:	85 c0                	test   %eax,%eax
80101dd5:	74 05                	je     80101ddc <dirlookup+0x7c>
        *poff = off;
80101dd7:	8b 45 10             	mov    0x10(%ebp),%eax
80101dda:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101ddc:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101de0:	8b 03                	mov    (%ebx),%eax
80101de2:	e8 a9 f4 ff ff       	call   80101290 <iget>
}
80101de7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101dea:	5b                   	pop    %ebx
80101deb:	5e                   	pop    %esi
80101dec:	5f                   	pop    %edi
80101ded:	5d                   	pop    %ebp
80101dee:	c3                   	ret    
      panic("dirlookup read");
80101def:	83 ec 0c             	sub    $0xc,%esp
80101df2:	68 99 77 10 80       	push   $0x80107799
80101df7:	e8 94 e5 ff ff       	call   80100390 <panic>
    panic("dirlookup not DIR");
80101dfc:	83 ec 0c             	sub    $0xc,%esp
80101dff:	68 87 77 10 80       	push   $0x80107787
80101e04:	e8 87 e5 ff ff       	call   80100390 <panic>
80101e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e10 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e10:	55                   	push   %ebp
80101e11:	89 e5                	mov    %esp,%ebp
80101e13:	57                   	push   %edi
80101e14:	56                   	push   %esi
80101e15:	53                   	push   %ebx
80101e16:	89 cf                	mov    %ecx,%edi
80101e18:	89 c3                	mov    %eax,%ebx
80101e1a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e1d:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e20:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(*path == '/')
80101e23:	0f 84 67 01 00 00    	je     80101f90 <namex+0x180>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e29:	e8 82 1b 00 00       	call   801039b0 <myproc>
  acquire(&icache.lock);
80101e2e:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e31:	8b 70 7c             	mov    0x7c(%eax),%esi
  acquire(&icache.lock);
80101e34:	68 20 1c 11 80       	push   $0x80111c20
80101e39:	e8 22 2b 00 00       	call   80104960 <acquire>
  ip->ref++;
80101e3e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e42:	c7 04 24 20 1c 11 80 	movl   $0x80111c20,(%esp)
80101e49:	e8 d2 2b 00 00       	call   80104a20 <release>
80101e4e:	83 c4 10             	add    $0x10,%esp
80101e51:	eb 08                	jmp    80101e5b <namex+0x4b>
80101e53:	90                   	nop
80101e54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e58:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e5b:	0f b6 03             	movzbl (%ebx),%eax
80101e5e:	3c 2f                	cmp    $0x2f,%al
80101e60:	74 f6                	je     80101e58 <namex+0x48>
  if(*path == 0)
80101e62:	84 c0                	test   %al,%al
80101e64:	0f 84 ee 00 00 00    	je     80101f58 <namex+0x148>
  while(*path != '/' && *path != 0)
80101e6a:	0f b6 03             	movzbl (%ebx),%eax
80101e6d:	3c 2f                	cmp    $0x2f,%al
80101e6f:	0f 84 b3 00 00 00    	je     80101f28 <namex+0x118>
80101e75:	84 c0                	test   %al,%al
80101e77:	89 da                	mov    %ebx,%edx
80101e79:	75 09                	jne    80101e84 <namex+0x74>
80101e7b:	e9 a8 00 00 00       	jmp    80101f28 <namex+0x118>
80101e80:	84 c0                	test   %al,%al
80101e82:	74 0a                	je     80101e8e <namex+0x7e>
    path++;
80101e84:	83 c2 01             	add    $0x1,%edx
  while(*path != '/' && *path != 0)
80101e87:	0f b6 02             	movzbl (%edx),%eax
80101e8a:	3c 2f                	cmp    $0x2f,%al
80101e8c:	75 f2                	jne    80101e80 <namex+0x70>
80101e8e:	89 d1                	mov    %edx,%ecx
80101e90:	29 d9                	sub    %ebx,%ecx
  if(len >= DIRSIZ)
80101e92:	83 f9 0d             	cmp    $0xd,%ecx
80101e95:	0f 8e 91 00 00 00    	jle    80101f2c <namex+0x11c>
    memmove(name, s, DIRSIZ);
80101e9b:	83 ec 04             	sub    $0x4,%esp
80101e9e:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ea1:	6a 0e                	push   $0xe
80101ea3:	53                   	push   %ebx
80101ea4:	57                   	push   %edi
80101ea5:	e8 76 2c 00 00       	call   80104b20 <memmove>
    path++;
80101eaa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    memmove(name, s, DIRSIZ);
80101ead:	83 c4 10             	add    $0x10,%esp
    path++;
80101eb0:	89 d3                	mov    %edx,%ebx
  while(*path == '/')
80101eb2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101eb5:	75 11                	jne    80101ec8 <namex+0xb8>
80101eb7:	89 f6                	mov    %esi,%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101ec0:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101ec3:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101ec6:	74 f8                	je     80101ec0 <namex+0xb0>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ec8:	83 ec 0c             	sub    $0xc,%esp
80101ecb:	56                   	push   %esi
80101ecc:	e8 af f8 ff ff       	call   80101780 <ilock>
    if(ip->type != T_DIR){
80101ed1:	83 c4 10             	add    $0x10,%esp
80101ed4:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101ed9:	0f 85 91 00 00 00    	jne    80101f70 <namex+0x160>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101edf:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101ee2:	85 d2                	test   %edx,%edx
80101ee4:	74 09                	je     80101eef <namex+0xdf>
80101ee6:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ee9:	0f 84 b7 00 00 00    	je     80101fa6 <namex+0x196>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101eef:	83 ec 04             	sub    $0x4,%esp
80101ef2:	6a 00                	push   $0x0
80101ef4:	57                   	push   %edi
80101ef5:	56                   	push   %esi
80101ef6:	e8 65 fe ff ff       	call   80101d60 <dirlookup>
80101efb:	83 c4 10             	add    $0x10,%esp
80101efe:	85 c0                	test   %eax,%eax
80101f00:	74 6e                	je     80101f70 <namex+0x160>
  iunlock(ip);
80101f02:	83 ec 0c             	sub    $0xc,%esp
80101f05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101f08:	56                   	push   %esi
80101f09:	e8 52 f9 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101f0e:	89 34 24             	mov    %esi,(%esp)
80101f11:	e8 9a f9 ff ff       	call   801018b0 <iput>
80101f16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101f19:	83 c4 10             	add    $0x10,%esp
80101f1c:	89 c6                	mov    %eax,%esi
80101f1e:	e9 38 ff ff ff       	jmp    80101e5b <namex+0x4b>
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(*path != '/' && *path != 0)
80101f28:	89 da                	mov    %ebx,%edx
80101f2a:	31 c9                	xor    %ecx,%ecx
    memmove(name, s, len);
80101f2c:	83 ec 04             	sub    $0x4,%esp
80101f2f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101f32:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101f35:	51                   	push   %ecx
80101f36:	53                   	push   %ebx
80101f37:	57                   	push   %edi
80101f38:	e8 e3 2b 00 00       	call   80104b20 <memmove>
    name[len] = 0;
80101f3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f40:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101f43:	83 c4 10             	add    $0x10,%esp
80101f46:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101f4a:	89 d3                	mov    %edx,%ebx
80101f4c:	e9 61 ff ff ff       	jmp    80101eb2 <namex+0xa2>
80101f51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101f58:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101f5b:	85 c0                	test   %eax,%eax
80101f5d:	75 5d                	jne    80101fbc <namex+0x1ac>
    iput(ip);
    return 0;
  }
  return ip;
}
80101f5f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f62:	89 f0                	mov    %esi,%eax
80101f64:	5b                   	pop    %ebx
80101f65:	5e                   	pop    %esi
80101f66:	5f                   	pop    %edi
80101f67:	5d                   	pop    %ebp
80101f68:	c3                   	ret    
80101f69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  iunlock(ip);
80101f70:	83 ec 0c             	sub    $0xc,%esp
80101f73:	56                   	push   %esi
80101f74:	e8 e7 f8 ff ff       	call   80101860 <iunlock>
  iput(ip);
80101f79:	89 34 24             	mov    %esi,(%esp)
      return 0;
80101f7c:	31 f6                	xor    %esi,%esi
  iput(ip);
80101f7e:	e8 2d f9 ff ff       	call   801018b0 <iput>
      return 0;
80101f83:	83 c4 10             	add    $0x10,%esp
}
80101f86:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f89:	89 f0                	mov    %esi,%eax
80101f8b:	5b                   	pop    %ebx
80101f8c:	5e                   	pop    %esi
80101f8d:	5f                   	pop    %edi
80101f8e:	5d                   	pop    %ebp
80101f8f:	c3                   	ret    
    ip = iget(ROOTDEV, ROOTINO);
80101f90:	ba 01 00 00 00       	mov    $0x1,%edx
80101f95:	b8 01 00 00 00       	mov    $0x1,%eax
80101f9a:	e8 f1 f2 ff ff       	call   80101290 <iget>
80101f9f:	89 c6                	mov    %eax,%esi
80101fa1:	e9 b5 fe ff ff       	jmp    80101e5b <namex+0x4b>
      iunlock(ip);
80101fa6:	83 ec 0c             	sub    $0xc,%esp
80101fa9:	56                   	push   %esi
80101faa:	e8 b1 f8 ff ff       	call   80101860 <iunlock>
      return ip;
80101faf:	83 c4 10             	add    $0x10,%esp
}
80101fb2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fb5:	89 f0                	mov    %esi,%eax
80101fb7:	5b                   	pop    %ebx
80101fb8:	5e                   	pop    %esi
80101fb9:	5f                   	pop    %edi
80101fba:	5d                   	pop    %ebp
80101fbb:	c3                   	ret    
    iput(ip);
80101fbc:	83 ec 0c             	sub    $0xc,%esp
80101fbf:	56                   	push   %esi
    return 0;
80101fc0:	31 f6                	xor    %esi,%esi
    iput(ip);
80101fc2:	e8 e9 f8 ff ff       	call   801018b0 <iput>
    return 0;
80101fc7:	83 c4 10             	add    $0x10,%esp
80101fca:	eb 93                	jmp    80101f5f <namex+0x14f>
80101fcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101fd0 <dirlink>:
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	57                   	push   %edi
80101fd4:	56                   	push   %esi
80101fd5:	53                   	push   %ebx
80101fd6:	83 ec 20             	sub    $0x20,%esp
80101fd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
80101fdc:	6a 00                	push   $0x0
80101fde:	ff 75 0c             	pushl  0xc(%ebp)
80101fe1:	53                   	push   %ebx
80101fe2:	e8 79 fd ff ff       	call   80101d60 <dirlookup>
80101fe7:	83 c4 10             	add    $0x10,%esp
80101fea:	85 c0                	test   %eax,%eax
80101fec:	75 67                	jne    80102055 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101fee:	8b 7b 58             	mov    0x58(%ebx),%edi
80101ff1:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ff4:	85 ff                	test   %edi,%edi
80101ff6:	74 29                	je     80102021 <dirlink+0x51>
80101ff8:	31 ff                	xor    %edi,%edi
80101ffa:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101ffd:	eb 09                	jmp    80102008 <dirlink+0x38>
80101fff:	90                   	nop
80102000:	83 c7 10             	add    $0x10,%edi
80102003:	3b 7b 58             	cmp    0x58(%ebx),%edi
80102006:	73 19                	jae    80102021 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102008:	6a 10                	push   $0x10
8010200a:	57                   	push   %edi
8010200b:	56                   	push   %esi
8010200c:	53                   	push   %ebx
8010200d:	e8 fe fa ff ff       	call   80101b10 <readi>
80102012:	83 c4 10             	add    $0x10,%esp
80102015:	83 f8 10             	cmp    $0x10,%eax
80102018:	75 4e                	jne    80102068 <dirlink+0x98>
    if(de.inum == 0)
8010201a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010201f:	75 df                	jne    80102000 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
80102021:	8d 45 da             	lea    -0x26(%ebp),%eax
80102024:	83 ec 04             	sub    $0x4,%esp
80102027:	6a 0e                	push   $0xe
80102029:	ff 75 0c             	pushl  0xc(%ebp)
8010202c:	50                   	push   %eax
8010202d:	e8 be 2b 00 00       	call   80104bf0 <strncpy>
  de.inum = inum;
80102032:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80102035:	6a 10                	push   $0x10
80102037:	57                   	push   %edi
80102038:	56                   	push   %esi
80102039:	53                   	push   %ebx
  de.inum = inum;
8010203a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010203e:	e8 cd fb ff ff       	call   80101c10 <writei>
80102043:	83 c4 20             	add    $0x20,%esp
80102046:	83 f8 10             	cmp    $0x10,%eax
80102049:	75 2a                	jne    80102075 <dirlink+0xa5>
  return 0;
8010204b:	31 c0                	xor    %eax,%eax
}
8010204d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102050:	5b                   	pop    %ebx
80102051:	5e                   	pop    %esi
80102052:	5f                   	pop    %edi
80102053:	5d                   	pop    %ebp
80102054:	c3                   	ret    
    iput(ip);
80102055:	83 ec 0c             	sub    $0xc,%esp
80102058:	50                   	push   %eax
80102059:	e8 52 f8 ff ff       	call   801018b0 <iput>
    return -1;
8010205e:	83 c4 10             	add    $0x10,%esp
80102061:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102066:	eb e5                	jmp    8010204d <dirlink+0x7d>
      panic("dirlink read");
80102068:	83 ec 0c             	sub    $0xc,%esp
8010206b:	68 a8 77 10 80       	push   $0x801077a8
80102070:	e8 1b e3 ff ff       	call   80100390 <panic>
    panic("dirlink");
80102075:	83 ec 0c             	sub    $0xc,%esp
80102078:	68 b6 7d 10 80       	push   $0x80107db6
8010207d:	e8 0e e3 ff ff       	call   80100390 <panic>
80102082:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102089:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102090 <namei>:

struct inode*
namei(char *path)
{
80102090:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102091:	31 d2                	xor    %edx,%edx
{
80102093:	89 e5                	mov    %esp,%ebp
80102095:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102098:	8b 45 08             	mov    0x8(%ebp),%eax
8010209b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010209e:	e8 6d fd ff ff       	call   80101e10 <namex>
}
801020a3:	c9                   	leave  
801020a4:	c3                   	ret    
801020a5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801020a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801020b0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
801020b0:	55                   	push   %ebp
  return namex(path, 1, name);
801020b1:	ba 01 00 00 00       	mov    $0x1,%edx
{
801020b6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
801020b8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801020bb:	8b 45 08             	mov    0x8(%ebp),%eax
}
801020be:	5d                   	pop    %ebp
  return namex(path, 1, name);
801020bf:	e9 4c fd ff ff       	jmp    80101e10 <namex>
801020c4:	66 90                	xchg   %ax,%ax
801020c6:	66 90                	xchg   %ax,%ax
801020c8:	66 90                	xchg   %ax,%ax
801020ca:	66 90                	xchg   %ax,%ax
801020cc:	66 90                	xchg   %ax,%ax
801020ce:	66 90                	xchg   %ax,%ax

801020d0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
801020d0:	55                   	push   %ebp
801020d1:	89 e5                	mov    %esp,%ebp
801020d3:	57                   	push   %edi
801020d4:	56                   	push   %esi
801020d5:	53                   	push   %ebx
801020d6:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
801020d9:	85 c0                	test   %eax,%eax
801020db:	0f 84 b4 00 00 00    	je     80102195 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801020e1:	8b 58 08             	mov    0x8(%eax),%ebx
801020e4:	89 c6                	mov    %eax,%esi
801020e6:	81 fb 1f 4e 00 00    	cmp    $0x4e1f,%ebx
801020ec:	0f 87 96 00 00 00    	ja     80102188 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801020f7:	89 f6                	mov    %esi,%esi
801020f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102100:	89 ca                	mov    %ecx,%edx
80102102:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102103:	83 e0 c0             	and    $0xffffffc0,%eax
80102106:	3c 40                	cmp    $0x40,%al
80102108:	75 f6                	jne    80102100 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010210a:	31 ff                	xor    %edi,%edi
8010210c:	ba f6 03 00 00       	mov    $0x3f6,%edx
80102111:	89 f8                	mov    %edi,%eax
80102113:	ee                   	out    %al,(%dx)
80102114:	b8 01 00 00 00       	mov    $0x1,%eax
80102119:	ba f2 01 00 00       	mov    $0x1f2,%edx
8010211e:	ee                   	out    %al,(%dx)
8010211f:	ba f3 01 00 00       	mov    $0x1f3,%edx
80102124:	89 d8                	mov    %ebx,%eax
80102126:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80102127:	89 d8                	mov    %ebx,%eax
80102129:	ba f4 01 00 00       	mov    $0x1f4,%edx
8010212e:	c1 f8 08             	sar    $0x8,%eax
80102131:	ee                   	out    %al,(%dx)
80102132:	ba f5 01 00 00       	mov    $0x1f5,%edx
80102137:	89 f8                	mov    %edi,%eax
80102139:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
8010213a:	0f b6 46 04          	movzbl 0x4(%esi),%eax
8010213e:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102143:	c1 e0 04             	shl    $0x4,%eax
80102146:	83 e0 10             	and    $0x10,%eax
80102149:	83 c8 e0             	or     $0xffffffe0,%eax
8010214c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010214d:	f6 06 04             	testb  $0x4,(%esi)
80102150:	75 16                	jne    80102168 <idestart+0x98>
80102152:	b8 20 00 00 00       	mov    $0x20,%eax
80102157:	89 ca                	mov    %ecx,%edx
80102159:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010215a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010215d:	5b                   	pop    %ebx
8010215e:	5e                   	pop    %esi
8010215f:	5f                   	pop    %edi
80102160:	5d                   	pop    %ebp
80102161:	c3                   	ret    
80102162:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102168:	b8 30 00 00 00       	mov    $0x30,%eax
8010216d:	89 ca                	mov    %ecx,%edx
8010216f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102170:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102175:	83 c6 5c             	add    $0x5c,%esi
80102178:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010217d:	fc                   	cld    
8010217e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102180:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102183:	5b                   	pop    %ebx
80102184:	5e                   	pop    %esi
80102185:	5f                   	pop    %edi
80102186:	5d                   	pop    %ebp
80102187:	c3                   	ret    
    panic("incorrect blockno");
80102188:	83 ec 0c             	sub    $0xc,%esp
8010218b:	68 14 78 10 80       	push   $0x80107814
80102190:	e8 fb e1 ff ff       	call   80100390 <panic>
    panic("idestart");
80102195:	83 ec 0c             	sub    $0xc,%esp
80102198:	68 0b 78 10 80       	push   $0x8010780b
8010219d:	e8 ee e1 ff ff       	call   80100390 <panic>
801021a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801021b0 <ideinit>:
{
801021b0:	55                   	push   %ebp
801021b1:	89 e5                	mov    %esp,%ebp
801021b3:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
801021b6:	68 26 78 10 80       	push   $0x80107826
801021bb:	68 80 b5 10 80       	push   $0x8010b580
801021c0:	e8 5b 26 00 00       	call   80104820 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
801021c5:	58                   	pop    %eax
801021c6:	a1 60 3f 11 80       	mov    0x80113f60,%eax
801021cb:	5a                   	pop    %edx
801021cc:	83 e8 01             	sub    $0x1,%eax
801021cf:	50                   	push   %eax
801021d0:	6a 0e                	push   $0xe
801021d2:	e8 a9 02 00 00       	call   80102480 <ioapicenable>
801021d7:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021da:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021df:	90                   	nop
801021e0:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021e1:	83 e0 c0             	and    $0xffffffc0,%eax
801021e4:	3c 40                	cmp    $0x40,%al
801021e6:	75 f8                	jne    801021e0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021e8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801021ed:	ba f6 01 00 00       	mov    $0x1f6,%edx
801021f2:	ee                   	out    %al,(%dx)
801021f3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801021fd:	eb 06                	jmp    80102205 <ideinit+0x55>
801021ff:	90                   	nop
  for(i=0; i<1000; i++){
80102200:	83 e9 01             	sub    $0x1,%ecx
80102203:	74 0f                	je     80102214 <ideinit+0x64>
80102205:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102206:	84 c0                	test   %al,%al
80102208:	74 f6                	je     80102200 <ideinit+0x50>
      havedisk1 = 1;
8010220a:	c7 05 60 b5 10 80 01 	movl   $0x1,0x8010b560
80102211:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102214:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102219:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010221e:	ee                   	out    %al,(%dx)
}
8010221f:	c9                   	leave  
80102220:	c3                   	ret    
80102221:	eb 0d                	jmp    80102230 <ideintr>
80102223:	90                   	nop
80102224:	90                   	nop
80102225:	90                   	nop
80102226:	90                   	nop
80102227:	90                   	nop
80102228:	90                   	nop
80102229:	90                   	nop
8010222a:	90                   	nop
8010222b:	90                   	nop
8010222c:	90                   	nop
8010222d:	90                   	nop
8010222e:	90                   	nop
8010222f:	90                   	nop

80102230 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80102230:	55                   	push   %ebp
80102231:	89 e5                	mov    %esp,%ebp
80102233:	57                   	push   %edi
80102234:	56                   	push   %esi
80102235:	53                   	push   %ebx
80102236:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102239:	68 80 b5 10 80       	push   $0x8010b580
8010223e:	e8 1d 27 00 00       	call   80104960 <acquire>

  if((b = idequeue) == 0){
80102243:	8b 1d 64 b5 10 80    	mov    0x8010b564,%ebx
80102249:	83 c4 10             	add    $0x10,%esp
8010224c:	85 db                	test   %ebx,%ebx
8010224e:	74 67                	je     801022b7 <ideintr+0x87>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102250:	8b 43 58             	mov    0x58(%ebx),%eax
80102253:	a3 64 b5 10 80       	mov    %eax,0x8010b564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102258:	8b 3b                	mov    (%ebx),%edi
8010225a:	f7 c7 04 00 00 00    	test   $0x4,%edi
80102260:	75 31                	jne    80102293 <ideintr+0x63>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102262:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102267:	89 f6                	mov    %esi,%esi
80102269:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80102270:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102271:	89 c6                	mov    %eax,%esi
80102273:	83 e6 c0             	and    $0xffffffc0,%esi
80102276:	89 f1                	mov    %esi,%ecx
80102278:	80 f9 40             	cmp    $0x40,%cl
8010227b:	75 f3                	jne    80102270 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010227d:	a8 21                	test   $0x21,%al
8010227f:	75 12                	jne    80102293 <ideintr+0x63>
    insl(0x1f0, b->data, BSIZE/4);
80102281:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102284:	b9 80 00 00 00       	mov    $0x80,%ecx
80102289:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010228e:	fc                   	cld    
8010228f:	f3 6d                	rep insl (%dx),%es:(%edi)
80102291:	8b 3b                	mov    (%ebx),%edi

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102293:	83 e7 fb             	and    $0xfffffffb,%edi
  wakeup(b);
80102296:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102299:	89 f9                	mov    %edi,%ecx
8010229b:	83 c9 02             	or     $0x2,%ecx
8010229e:	89 0b                	mov    %ecx,(%ebx)
  wakeup(b);
801022a0:	53                   	push   %ebx
801022a1:	e8 3a 20 00 00       	call   801042e0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801022a6:	a1 64 b5 10 80       	mov    0x8010b564,%eax
801022ab:	83 c4 10             	add    $0x10,%esp
801022ae:	85 c0                	test   %eax,%eax
801022b0:	74 05                	je     801022b7 <ideintr+0x87>
    idestart(idequeue);
801022b2:	e8 19 fe ff ff       	call   801020d0 <idestart>
    release(&idelock);
801022b7:	83 ec 0c             	sub    $0xc,%esp
801022ba:	68 80 b5 10 80       	push   $0x8010b580
801022bf:	e8 5c 27 00 00       	call   80104a20 <release>

  release(&idelock);
}
801022c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801022c7:	5b                   	pop    %ebx
801022c8:	5e                   	pop    %esi
801022c9:	5f                   	pop    %edi
801022ca:	5d                   	pop    %ebp
801022cb:	c3                   	ret    
801022cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801022d0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801022d0:	55                   	push   %ebp
801022d1:	89 e5                	mov    %esp,%ebp
801022d3:	53                   	push   %ebx
801022d4:	83 ec 10             	sub    $0x10,%esp
801022d7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801022da:	8d 43 0c             	lea    0xc(%ebx),%eax
801022dd:	50                   	push   %eax
801022de:	e8 ed 24 00 00       	call   801047d0 <holdingsleep>
801022e3:	83 c4 10             	add    $0x10,%esp
801022e6:	85 c0                	test   %eax,%eax
801022e8:	0f 84 c6 00 00 00    	je     801023b4 <iderw+0xe4>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801022ee:	8b 03                	mov    (%ebx),%eax
801022f0:	83 e0 06             	and    $0x6,%eax
801022f3:	83 f8 02             	cmp    $0x2,%eax
801022f6:	0f 84 ab 00 00 00    	je     801023a7 <iderw+0xd7>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801022fc:	8b 53 04             	mov    0x4(%ebx),%edx
801022ff:	85 d2                	test   %edx,%edx
80102301:	74 0d                	je     80102310 <iderw+0x40>
80102303:	a1 60 b5 10 80       	mov    0x8010b560,%eax
80102308:	85 c0                	test   %eax,%eax
8010230a:	0f 84 b1 00 00 00    	je     801023c1 <iderw+0xf1>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102310:	83 ec 0c             	sub    $0xc,%esp
80102313:	68 80 b5 10 80       	push   $0x8010b580
80102318:	e8 43 26 00 00       	call   80104960 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010231d:	8b 15 64 b5 10 80    	mov    0x8010b564,%edx
80102323:	83 c4 10             	add    $0x10,%esp
  b->qnext = 0;
80102326:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010232d:	85 d2                	test   %edx,%edx
8010232f:	75 09                	jne    8010233a <iderw+0x6a>
80102331:	eb 6d                	jmp    801023a0 <iderw+0xd0>
80102333:	90                   	nop
80102334:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102338:	89 c2                	mov    %eax,%edx
8010233a:	8b 42 58             	mov    0x58(%edx),%eax
8010233d:	85 c0                	test   %eax,%eax
8010233f:	75 f7                	jne    80102338 <iderw+0x68>
80102341:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102344:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102346:	39 1d 64 b5 10 80    	cmp    %ebx,0x8010b564
8010234c:	74 42                	je     80102390 <iderw+0xc0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010234e:	8b 03                	mov    (%ebx),%eax
80102350:	83 e0 06             	and    $0x6,%eax
80102353:	83 f8 02             	cmp    $0x2,%eax
80102356:	74 23                	je     8010237b <iderw+0xab>
80102358:	90                   	nop
80102359:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102360:	83 ec 08             	sub    $0x8,%esp
80102363:	68 80 b5 10 80       	push   $0x8010b580
80102368:	53                   	push   %ebx
80102369:	e8 b2 1d 00 00       	call   80104120 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010236e:	8b 03                	mov    (%ebx),%eax
80102370:	83 c4 10             	add    $0x10,%esp
80102373:	83 e0 06             	and    $0x6,%eax
80102376:	83 f8 02             	cmp    $0x2,%eax
80102379:	75 e5                	jne    80102360 <iderw+0x90>
  }


  release(&idelock);
8010237b:	c7 45 08 80 b5 10 80 	movl   $0x8010b580,0x8(%ebp)
}
80102382:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102385:	c9                   	leave  
  release(&idelock);
80102386:	e9 95 26 00 00       	jmp    80104a20 <release>
8010238b:	90                   	nop
8010238c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    idestart(b);
80102390:	89 d8                	mov    %ebx,%eax
80102392:	e8 39 fd ff ff       	call   801020d0 <idestart>
80102397:	eb b5                	jmp    8010234e <iderw+0x7e>
80102399:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023a0:	ba 64 b5 10 80       	mov    $0x8010b564,%edx
801023a5:	eb 9d                	jmp    80102344 <iderw+0x74>
    panic("iderw: nothing to do");
801023a7:	83 ec 0c             	sub    $0xc,%esp
801023aa:	68 40 78 10 80       	push   $0x80107840
801023af:	e8 dc df ff ff       	call   80100390 <panic>
    panic("iderw: buf not locked");
801023b4:	83 ec 0c             	sub    $0xc,%esp
801023b7:	68 2a 78 10 80       	push   $0x8010782a
801023bc:	e8 cf df ff ff       	call   80100390 <panic>
    panic("iderw: ide disk 1 not present");
801023c1:	83 ec 0c             	sub    $0xc,%esp
801023c4:	68 55 78 10 80       	push   $0x80107855
801023c9:	e8 c2 df ff ff       	call   80100390 <panic>
801023ce:	66 90                	xchg   %ax,%ax

801023d0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801023d0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801023d1:	c7 05 74 38 11 80 00 	movl   $0xfec00000,0x80113874
801023d8:	00 c0 fe 
{
801023db:	89 e5                	mov    %esp,%ebp
801023dd:	56                   	push   %esi
801023de:	53                   	push   %ebx
  ioapic->reg = reg;
801023df:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
801023e6:	00 00 00 
  return ioapic->data;
801023e9:	a1 74 38 11 80       	mov    0x80113874,%eax
801023ee:	8b 58 10             	mov    0x10(%eax),%ebx
  ioapic->reg = reg;
801023f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  return ioapic->data;
801023f7:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801023fd:	0f b6 15 a0 39 11 80 	movzbl 0x801139a0,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102404:	c1 eb 10             	shr    $0x10,%ebx
  return ioapic->data;
80102407:	8b 41 10             	mov    0x10(%ecx),%eax
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
8010240a:	0f b6 db             	movzbl %bl,%ebx
  id = ioapicread(REG_ID) >> 24;
8010240d:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102410:	39 c2                	cmp    %eax,%edx
80102412:	74 16                	je     8010242a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102414:	83 ec 0c             	sub    $0xc,%esp
80102417:	68 74 78 10 80       	push   $0x80107874
8010241c:	e8 3f e2 ff ff       	call   80100660 <cprintf>
80102421:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx
80102427:	83 c4 10             	add    $0x10,%esp
8010242a:	83 c3 21             	add    $0x21,%ebx
{
8010242d:	ba 10 00 00 00       	mov    $0x10,%edx
80102432:	b8 20 00 00 00       	mov    $0x20,%eax
80102437:	89 f6                	mov    %esi,%esi
80102439:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ioapic->reg = reg;
80102440:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102442:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102448:	89 c6                	mov    %eax,%esi
8010244a:	81 ce 00 00 01 00    	or     $0x10000,%esi
80102450:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
80102453:	89 71 10             	mov    %esi,0x10(%ecx)
80102456:	8d 72 01             	lea    0x1(%edx),%esi
80102459:	83 c2 02             	add    $0x2,%edx
  for(i = 0; i <= maxintr; i++){
8010245c:	39 d8                	cmp    %ebx,%eax
  ioapic->reg = reg;
8010245e:	89 31                	mov    %esi,(%ecx)
  ioapic->data = data;
80102460:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx
80102466:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010246d:	75 d1                	jne    80102440 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010246f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102472:	5b                   	pop    %ebx
80102473:	5e                   	pop    %esi
80102474:	5d                   	pop    %ebp
80102475:	c3                   	ret    
80102476:	8d 76 00             	lea    0x0(%esi),%esi
80102479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102480 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102480:	55                   	push   %ebp
  ioapic->reg = reg;
80102481:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx
{
80102487:	89 e5                	mov    %esp,%ebp
80102489:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010248c:	8d 50 20             	lea    0x20(%eax),%edx
8010248f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102493:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102495:	8b 0d 74 38 11 80    	mov    0x80113874,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010249b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010249e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
801024a4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801024a6:	a1 74 38 11 80       	mov    0x80113874,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801024ab:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
801024ae:	89 50 10             	mov    %edx,0x10(%eax)
}
801024b1:	5d                   	pop    %ebp
801024b2:	c3                   	ret    
801024b3:	66 90                	xchg   %ax,%ax
801024b5:	66 90                	xchg   %ax,%ax
801024b7:	66 90                	xchg   %ax,%ax
801024b9:	66 90                	xchg   %ax,%ax
801024bb:	66 90                	xchg   %ax,%ax
801024bd:	66 90                	xchg   %ax,%ax
801024bf:	90                   	nop

801024c0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801024c0:	55                   	push   %ebp
801024c1:	89 e5                	mov    %esp,%ebp
801024c3:	53                   	push   %ebx
801024c4:	83 ec 04             	sub    $0x4,%esp
801024c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801024ca:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801024d0:	75 70                	jne    80102542 <kfree+0x82>
801024d2:	81 fb 08 6c 11 80    	cmp    $0x80116c08,%ebx
801024d8:	72 68                	jb     80102542 <kfree+0x82>
801024da:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801024e0:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
801024e5:	77 5b                	ja     80102542 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
801024e7:	83 ec 04             	sub    $0x4,%esp
801024ea:	68 00 10 00 00       	push   $0x1000
801024ef:	6a 01                	push   $0x1
801024f1:	53                   	push   %ebx
801024f2:	e8 79 25 00 00       	call   80104a70 <memset>

  if(kmem.use_lock)
801024f7:	8b 15 b4 38 11 80    	mov    0x801138b4,%edx
801024fd:	83 c4 10             	add    $0x10,%esp
80102500:	85 d2                	test   %edx,%edx
80102502:	75 2c                	jne    80102530 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102504:	a1 b8 38 11 80       	mov    0x801138b8,%eax
80102509:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010250b:	a1 b4 38 11 80       	mov    0x801138b4,%eax
  kmem.freelist = r;
80102510:	89 1d b8 38 11 80    	mov    %ebx,0x801138b8
  if(kmem.use_lock)
80102516:	85 c0                	test   %eax,%eax
80102518:	75 06                	jne    80102520 <kfree+0x60>
    release(&kmem.lock);
}
8010251a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010251d:	c9                   	leave  
8010251e:	c3                   	ret    
8010251f:	90                   	nop
    release(&kmem.lock);
80102520:	c7 45 08 80 38 11 80 	movl   $0x80113880,0x8(%ebp)
}
80102527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010252a:	c9                   	leave  
    release(&kmem.lock);
8010252b:	e9 f0 24 00 00       	jmp    80104a20 <release>
    acquire(&kmem.lock);
80102530:	83 ec 0c             	sub    $0xc,%esp
80102533:	68 80 38 11 80       	push   $0x80113880
80102538:	e8 23 24 00 00       	call   80104960 <acquire>
8010253d:	83 c4 10             	add    $0x10,%esp
80102540:	eb c2                	jmp    80102504 <kfree+0x44>
    panic("kfree");
80102542:	83 ec 0c             	sub    $0xc,%esp
80102545:	68 a6 78 10 80       	push   $0x801078a6
8010254a:	e8 41 de ff ff       	call   80100390 <panic>
8010254f:	90                   	nop

80102550 <freerange>:
{
80102550:	55                   	push   %ebp
80102551:	89 e5                	mov    %esp,%ebp
80102553:	56                   	push   %esi
80102554:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102555:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102558:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010255b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102561:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102567:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010256d:	39 de                	cmp    %ebx,%esi
8010256f:	72 23                	jb     80102594 <freerange+0x44>
80102571:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102578:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010257e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102581:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102587:	50                   	push   %eax
80102588:	e8 33 ff ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010258d:	83 c4 10             	add    $0x10,%esp
80102590:	39 f3                	cmp    %esi,%ebx
80102592:	76 e4                	jbe    80102578 <freerange+0x28>
}
80102594:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102597:	5b                   	pop    %ebx
80102598:	5e                   	pop    %esi
80102599:	5d                   	pop    %ebp
8010259a:	c3                   	ret    
8010259b:	90                   	nop
8010259c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801025a0 <kinit1>:
{
801025a0:	55                   	push   %ebp
801025a1:	89 e5                	mov    %esp,%ebp
801025a3:	56                   	push   %esi
801025a4:	53                   	push   %ebx
801025a5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801025a8:	83 ec 08             	sub    $0x8,%esp
801025ab:	68 ac 78 10 80       	push   $0x801078ac
801025b0:	68 80 38 11 80       	push   $0x80113880
801025b5:	e8 66 22 00 00       	call   80104820 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801025ba:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025bd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801025c0:	c7 05 b4 38 11 80 00 	movl   $0x0,0x801138b4
801025c7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801025ca:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801025d0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025d6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801025dc:	39 de                	cmp    %ebx,%esi
801025de:	72 1c                	jb     801025fc <kinit1+0x5c>
    kfree(p);
801025e0:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
801025e6:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025e9:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801025ef:	50                   	push   %eax
801025f0:	e8 cb fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801025f5:	83 c4 10             	add    $0x10,%esp
801025f8:	39 de                	cmp    %ebx,%esi
801025fa:	73 e4                	jae    801025e0 <kinit1+0x40>
}
801025fc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801025ff:	5b                   	pop    %ebx
80102600:	5e                   	pop    %esi
80102601:	5d                   	pop    %ebp
80102602:	c3                   	ret    
80102603:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102610 <kinit2>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
80102614:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
80102615:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102618:	8b 75 0c             	mov    0xc(%ebp),%esi
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <kinit2+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010263e:	83 ec 0c             	sub    $0xc,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 73 fe ff ff       	call   801024c0 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 de                	cmp    %ebx,%esi
80102652:	73 e4                	jae    80102638 <kinit2+0x28>
  kmem.use_lock = 1;
80102654:	c7 05 b4 38 11 80 01 	movl   $0x1,0x801138b4
8010265b:	00 00 00 
}
8010265e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102661:	5b                   	pop    %ebx
80102662:	5e                   	pop    %esi
80102663:	5d                   	pop    %ebp
80102664:	c3                   	ret    
80102665:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102669:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102670 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102670:	a1 b4 38 11 80       	mov    0x801138b4,%eax
80102675:	85 c0                	test   %eax,%eax
80102677:	75 1f                	jne    80102698 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102679:	a1 b8 38 11 80       	mov    0x801138b8,%eax
  if(r)
8010267e:	85 c0                	test   %eax,%eax
80102680:	74 0e                	je     80102690 <kalloc+0x20>
    kmem.freelist = r->next;
80102682:	8b 10                	mov    (%eax),%edx
80102684:	89 15 b8 38 11 80    	mov    %edx,0x801138b8
8010268a:	c3                   	ret    
8010268b:	90                   	nop
8010268c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(kmem.use_lock)
    release(&kmem.lock);
  return (char*)r;
}
80102690:	f3 c3                	repz ret 
80102692:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
80102698:	55                   	push   %ebp
80102699:	89 e5                	mov    %esp,%ebp
8010269b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010269e:	68 80 38 11 80       	push   $0x80113880
801026a3:	e8 b8 22 00 00       	call   80104960 <acquire>
  r = kmem.freelist;
801026a8:	a1 b8 38 11 80       	mov    0x801138b8,%eax
  if(r)
801026ad:	83 c4 10             	add    $0x10,%esp
801026b0:	8b 15 b4 38 11 80    	mov    0x801138b4,%edx
801026b6:	85 c0                	test   %eax,%eax
801026b8:	74 08                	je     801026c2 <kalloc+0x52>
    kmem.freelist = r->next;
801026ba:	8b 08                	mov    (%eax),%ecx
801026bc:	89 0d b8 38 11 80    	mov    %ecx,0x801138b8
  if(kmem.use_lock)
801026c2:	85 d2                	test   %edx,%edx
801026c4:	74 16                	je     801026dc <kalloc+0x6c>
    release(&kmem.lock);
801026c6:	83 ec 0c             	sub    $0xc,%esp
801026c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
801026cc:	68 80 38 11 80       	push   $0x80113880
801026d1:	e8 4a 23 00 00       	call   80104a20 <release>
  return (char*)r;
801026d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
801026d9:	83 c4 10             	add    $0x10,%esp
}
801026dc:	c9                   	leave  
801026dd:	c3                   	ret    
801026de:	66 90                	xchg   %ax,%ax

801026e0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801026e0:	ba 64 00 00 00       	mov    $0x64,%edx
801026e5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801026e6:	a8 01                	test   $0x1,%al
801026e8:	0f 84 c2 00 00 00    	je     801027b0 <kbdgetc+0xd0>
801026ee:	ba 60 00 00 00       	mov    $0x60,%edx
801026f3:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801026f4:	0f b6 d0             	movzbl %al,%edx
801026f7:	8b 0d b4 b5 10 80    	mov    0x8010b5b4,%ecx

  if(data == 0xE0){
801026fd:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102703:	0f 84 7f 00 00 00    	je     80102788 <kbdgetc+0xa8>
{
80102709:	55                   	push   %ebp
8010270a:	89 e5                	mov    %esp,%ebp
8010270c:	53                   	push   %ebx
8010270d:	89 cb                	mov    %ecx,%ebx
8010270f:	83 e3 40             	and    $0x40,%ebx
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102712:	84 c0                	test   %al,%al
80102714:	78 4a                	js     80102760 <kbdgetc+0x80>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102716:	85 db                	test   %ebx,%ebx
80102718:	74 09                	je     80102723 <kbdgetc+0x43>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010271a:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
8010271d:	83 e1 bf             	and    $0xffffffbf,%ecx
    data |= 0x80;
80102720:	0f b6 d0             	movzbl %al,%edx
  }

  shift |= shiftcode[data];
80102723:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
8010272a:	09 c1                	or     %eax,%ecx
  shift ^= togglecode[data];
8010272c:	0f b6 82 e0 78 10 80 	movzbl -0x7fef8720(%edx),%eax
80102733:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102735:	89 c8                	mov    %ecx,%eax
  shift ^= togglecode[data];
80102737:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
  c = charcode[shift & (CTL | SHIFT)][data];
8010273d:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
80102740:	83 e1 08             	and    $0x8,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102743:	8b 04 85 c0 78 10 80 	mov    -0x7fef8740(,%eax,4),%eax
8010274a:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
8010274e:	74 31                	je     80102781 <kbdgetc+0xa1>
    if('a' <= c && c <= 'z')
80102750:	8d 50 9f             	lea    -0x61(%eax),%edx
80102753:	83 fa 19             	cmp    $0x19,%edx
80102756:	77 40                	ja     80102798 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102758:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010275b:	5b                   	pop    %ebx
8010275c:	5d                   	pop    %ebp
8010275d:	c3                   	ret    
8010275e:	66 90                	xchg   %ax,%ax
    data = (shift & E0ESC ? data : data & 0x7F);
80102760:	83 e0 7f             	and    $0x7f,%eax
80102763:	85 db                	test   %ebx,%ebx
80102765:	0f 44 d0             	cmove  %eax,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102768:	0f b6 82 e0 79 10 80 	movzbl -0x7fef8620(%edx),%eax
8010276f:	83 c8 40             	or     $0x40,%eax
80102772:	0f b6 c0             	movzbl %al,%eax
80102775:	f7 d0                	not    %eax
80102777:	21 c1                	and    %eax,%ecx
    return 0;
80102779:	31 c0                	xor    %eax,%eax
    shift &= ~(shiftcode[data] | E0ESC);
8010277b:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
}
80102781:	5b                   	pop    %ebx
80102782:	5d                   	pop    %ebp
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    shift |= E0ESC;
80102788:	83 c9 40             	or     $0x40,%ecx
    return 0;
8010278b:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
8010278d:	89 0d b4 b5 10 80    	mov    %ecx,0x8010b5b4
    return 0;
80102793:	c3                   	ret    
80102794:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    else if('A' <= c && c <= 'Z')
80102798:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010279b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010279e:	5b                   	pop    %ebx
      c += 'a' - 'A';
8010279f:	83 f9 1a             	cmp    $0x1a,%ecx
801027a2:	0f 42 c2             	cmovb  %edx,%eax
}
801027a5:	5d                   	pop    %ebp
801027a6:	c3                   	ret    
801027a7:	89 f6                	mov    %esi,%esi
801027a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801027b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801027b5:	c3                   	ret    
801027b6:	8d 76 00             	lea    0x0(%esi),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <kbdintr>:

void
kbdintr(void)
{
801027c0:	55                   	push   %ebp
801027c1:	89 e5                	mov    %esp,%ebp
801027c3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801027c6:	68 e0 26 10 80       	push   $0x801026e0
801027cb:	e8 40 e0 ff ff       	call   80100810 <consoleintr>
}
801027d0:	83 c4 10             	add    $0x10,%esp
801027d3:	c9                   	leave  
801027d4:	c3                   	ret    
801027d5:	66 90                	xchg   %ax,%ax
801027d7:	66 90                	xchg   %ax,%ax
801027d9:	66 90                	xchg   %ax,%ax
801027db:	66 90                	xchg   %ax,%ax
801027dd:	66 90                	xchg   %ax,%ax
801027df:	90                   	nop

801027e0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801027e0:	a1 bc 38 11 80       	mov    0x801138bc,%eax
{
801027e5:	55                   	push   %ebp
801027e6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801027e8:	85 c0                	test   %eax,%eax
801027ea:	0f 84 c8 00 00 00    	je     801028b8 <lapicinit+0xd8>
  lapic[index] = value;
801027f0:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801027f7:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027fa:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801027fd:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102804:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102807:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010280a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102811:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102814:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102817:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010281e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102821:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102824:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010282b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010282e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102831:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102838:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010283e:	8b 50 30             	mov    0x30(%eax),%edx
80102841:	c1 ea 10             	shr    $0x10,%edx
80102844:	80 fa 03             	cmp    $0x3,%dl
80102847:	77 77                	ja     801028c0 <lapicinit+0xe0>
  lapic[index] = value;
80102849:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102850:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102853:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102856:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010285d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102860:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102863:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010286a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010286d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102870:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102877:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010287a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010287d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102884:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102887:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010288a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102891:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102894:	8b 50 20             	mov    0x20(%eax),%edx
80102897:	89 f6                	mov    %esi,%esi
80102899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801028a0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801028a6:	80 e6 10             	and    $0x10,%dh
801028a9:	75 f5                	jne    801028a0 <lapicinit+0xc0>
  lapic[index] = value;
801028ab:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801028b2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b5:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801028b8:	5d                   	pop    %ebp
801028b9:	c3                   	ret    
801028ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  lapic[index] = value;
801028c0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801028c7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028ca:	8b 50 20             	mov    0x20(%eax),%edx
801028cd:	e9 77 ff ff ff       	jmp    80102849 <lapicinit+0x69>
801028d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801028d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801028e0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801028e0:	8b 15 bc 38 11 80    	mov    0x801138bc,%edx
{
801028e6:	55                   	push   %ebp
801028e7:	31 c0                	xor    %eax,%eax
801028e9:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801028eb:	85 d2                	test   %edx,%edx
801028ed:	74 06                	je     801028f5 <lapicid+0x15>
    return 0;
  return lapic[ID] >> 24;
801028ef:	8b 42 20             	mov    0x20(%edx),%eax
801028f2:	c1 e8 18             	shr    $0x18,%eax
}
801028f5:	5d                   	pop    %ebp
801028f6:	c3                   	ret    
801028f7:	89 f6                	mov    %esi,%esi
801028f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102900 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102900:	a1 bc 38 11 80       	mov    0x801138bc,%eax
{
80102905:	55                   	push   %ebp
80102906:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102908:	85 c0                	test   %eax,%eax
8010290a:	74 0d                	je     80102919 <lapiceoi+0x19>
  lapic[index] = value;
8010290c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102913:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102916:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
80102919:	5d                   	pop    %ebp
8010291a:	c3                   	ret    
8010291b:	90                   	nop
8010291c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102920 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102920:	55                   	push   %ebp
80102921:	89 e5                	mov    %esp,%ebp
}
80102923:	5d                   	pop    %ebp
80102924:	c3                   	ret    
80102925:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102929:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102930 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102930:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102931:	b8 0f 00 00 00       	mov    $0xf,%eax
80102936:	ba 70 00 00 00       	mov    $0x70,%edx
8010293b:	89 e5                	mov    %esp,%ebp
8010293d:	53                   	push   %ebx
8010293e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102941:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102944:	ee                   	out    %al,(%dx)
80102945:	b8 0a 00 00 00       	mov    $0xa,%eax
8010294a:	ba 71 00 00 00       	mov    $0x71,%edx
8010294f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102950:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102952:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102955:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010295b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010295d:	c1 e9 0c             	shr    $0xc,%ecx
  wrv[1] = addr >> 4;
80102960:	c1 e8 04             	shr    $0x4,%eax
  lapicw(ICRHI, apicid<<24);
80102963:	89 da                	mov    %ebx,%edx
    lapicw(ICRLO, STARTUP | (addr>>12));
80102965:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102968:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
8010296e:	a1 bc 38 11 80       	mov    0x801138bc,%eax
80102973:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102979:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010297c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102983:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102986:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102989:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102990:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102993:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102996:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010299c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
8010299f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029a5:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
801029a8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029ae:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801029b1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801029b7:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
801029ba:	5b                   	pop    %ebx
801029bb:	5d                   	pop    %ebp
801029bc:	c3                   	ret    
801029bd:	8d 76 00             	lea    0x0(%esi),%esi

801029c0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801029c0:	55                   	push   %ebp
801029c1:	b8 0b 00 00 00       	mov    $0xb,%eax
801029c6:	ba 70 00 00 00       	mov    $0x70,%edx
801029cb:	89 e5                	mov    %esp,%ebp
801029cd:	57                   	push   %edi
801029ce:	56                   	push   %esi
801029cf:	53                   	push   %ebx
801029d0:	83 ec 4c             	sub    $0x4c,%esp
801029d3:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029d4:	ba 71 00 00 00       	mov    $0x71,%edx
801029d9:	ec                   	in     (%dx),%al
801029da:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029dd:	bb 70 00 00 00       	mov    $0x70,%ebx
801029e2:	88 45 b3             	mov    %al,-0x4d(%ebp)
801029e5:	8d 76 00             	lea    0x0(%esi),%esi
801029e8:	31 c0                	xor    %eax,%eax
801029ea:	89 da                	mov    %ebx,%edx
801029ec:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801029ed:	b9 71 00 00 00       	mov    $0x71,%ecx
801029f2:	89 ca                	mov    %ecx,%edx
801029f4:	ec                   	in     (%dx),%al
801029f5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f8:	89 da                	mov    %ebx,%edx
801029fa:	b8 02 00 00 00       	mov    $0x2,%eax
801029ff:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a00:	89 ca                	mov    %ecx,%edx
80102a02:	ec                   	in     (%dx),%al
80102a03:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a06:	89 da                	mov    %ebx,%edx
80102a08:	b8 04 00 00 00       	mov    $0x4,%eax
80102a0d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a0e:	89 ca                	mov    %ecx,%edx
80102a10:	ec                   	in     (%dx),%al
80102a11:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a14:	89 da                	mov    %ebx,%edx
80102a16:	b8 07 00 00 00       	mov    $0x7,%eax
80102a1b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a1c:	89 ca                	mov    %ecx,%edx
80102a1e:	ec                   	in     (%dx),%al
80102a1f:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a22:	89 da                	mov    %ebx,%edx
80102a24:	b8 08 00 00 00       	mov    $0x8,%eax
80102a29:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a2a:	89 ca                	mov    %ecx,%edx
80102a2c:	ec                   	in     (%dx),%al
80102a2d:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a2f:	89 da                	mov    %ebx,%edx
80102a31:	b8 09 00 00 00       	mov    $0x9,%eax
80102a36:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a37:	89 ca                	mov    %ecx,%edx
80102a39:	ec                   	in     (%dx),%al
80102a3a:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a3c:	89 da                	mov    %ebx,%edx
80102a3e:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a43:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a44:	89 ca                	mov    %ecx,%edx
80102a46:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102a47:	84 c0                	test   %al,%al
80102a49:	78 9d                	js     801029e8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102a4b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102a4f:	89 fa                	mov    %edi,%edx
80102a51:	0f b6 fa             	movzbl %dl,%edi
80102a54:	89 f2                	mov    %esi,%edx
80102a56:	0f b6 f2             	movzbl %dl,%esi
80102a59:	89 7d c8             	mov    %edi,-0x38(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a5c:	89 da                	mov    %ebx,%edx
80102a5e:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102a61:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102a64:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102a68:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102a6b:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102a6f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102a72:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102a76:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102a79:	31 c0                	xor    %eax,%eax
80102a7b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a7c:	89 ca                	mov    %ecx,%edx
80102a7e:	ec                   	in     (%dx),%al
80102a7f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a82:	89 da                	mov    %ebx,%edx
80102a84:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102a87:	b8 02 00 00 00       	mov    $0x2,%eax
80102a8c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a8d:	89 ca                	mov    %ecx,%edx
80102a8f:	ec                   	in     (%dx),%al
80102a90:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a93:	89 da                	mov    %ebx,%edx
80102a95:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102a98:	b8 04 00 00 00       	mov    $0x4,%eax
80102a9d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a9e:	89 ca                	mov    %ecx,%edx
80102aa0:	ec                   	in     (%dx),%al
80102aa1:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aa4:	89 da                	mov    %ebx,%edx
80102aa6:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102aa9:	b8 07 00 00 00       	mov    $0x7,%eax
80102aae:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aaf:	89 ca                	mov    %ecx,%edx
80102ab1:	ec                   	in     (%dx),%al
80102ab2:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab5:	89 da                	mov    %ebx,%edx
80102ab7:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102aba:	b8 08 00 00 00       	mov    $0x8,%eax
80102abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
80102ac3:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac6:	89 da                	mov    %ebx,%edx
80102ac8:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102acb:	b8 09 00 00 00       	mov    $0x9,%eax
80102ad0:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ad1:	89 ca                	mov    %ecx,%edx
80102ad3:	ec                   	in     (%dx),%al
80102ad4:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102ad7:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102ada:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102add:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ae0:	6a 18                	push   $0x18
80102ae2:	50                   	push   %eax
80102ae3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ae6:	50                   	push   %eax
80102ae7:	e8 d4 1f 00 00       	call   80104ac0 <memcmp>
80102aec:	83 c4 10             	add    $0x10,%esp
80102aef:	85 c0                	test   %eax,%eax
80102af1:	0f 85 f1 fe ff ff    	jne    801029e8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102af7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102afb:	75 78                	jne    80102b75 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102afd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b00:	89 c2                	mov    %eax,%edx
80102b02:	83 e0 0f             	and    $0xf,%eax
80102b05:	c1 ea 04             	shr    $0x4,%edx
80102b08:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b0b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b0e:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102b11:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b14:	89 c2                	mov    %eax,%edx
80102b16:	83 e0 0f             	and    $0xf,%eax
80102b19:	c1 ea 04             	shr    $0x4,%edx
80102b1c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b1f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b22:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102b25:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b28:	89 c2                	mov    %eax,%edx
80102b2a:	83 e0 0f             	and    $0xf,%eax
80102b2d:	c1 ea 04             	shr    $0x4,%edx
80102b30:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b33:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b36:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102b39:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b3c:	89 c2                	mov    %eax,%edx
80102b3e:	83 e0 0f             	and    $0xf,%eax
80102b41:	c1 ea 04             	shr    $0x4,%edx
80102b44:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b47:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b4a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102b4d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b50:	89 c2                	mov    %eax,%edx
80102b52:	83 e0 0f             	and    $0xf,%eax
80102b55:	c1 ea 04             	shr    $0x4,%edx
80102b58:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b5b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b5e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102b61:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b64:	89 c2                	mov    %eax,%edx
80102b66:	83 e0 0f             	and    $0xf,%eax
80102b69:	c1 ea 04             	shr    $0x4,%edx
80102b6c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102b6f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102b72:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102b75:	8b 75 08             	mov    0x8(%ebp),%esi
80102b78:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102b7b:	89 06                	mov    %eax,(%esi)
80102b7d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102b80:	89 46 04             	mov    %eax,0x4(%esi)
80102b83:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102b86:	89 46 08             	mov    %eax,0x8(%esi)
80102b89:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102b8c:	89 46 0c             	mov    %eax,0xc(%esi)
80102b8f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102b92:	89 46 10             	mov    %eax,0x10(%esi)
80102b95:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102b98:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102b9b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102ba2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ba5:	5b                   	pop    %ebx
80102ba6:	5e                   	pop    %esi
80102ba7:	5f                   	pop    %edi
80102ba8:	5d                   	pop    %ebp
80102ba9:	c3                   	ret    
80102baa:	66 90                	xchg   %ax,%ax
80102bac:	66 90                	xchg   %ax,%ax
80102bae:	66 90                	xchg   %ax,%ax

80102bb0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102bb0:	8b 0d 08 39 11 80    	mov    0x80113908,%ecx
80102bb6:	85 c9                	test   %ecx,%ecx
80102bb8:	0f 8e 8a 00 00 00    	jle    80102c48 <install_trans+0x98>
{
80102bbe:	55                   	push   %ebp
80102bbf:	89 e5                	mov    %esp,%ebp
80102bc1:	57                   	push   %edi
80102bc2:	56                   	push   %esi
80102bc3:	53                   	push   %ebx
  for (tail = 0; tail < log.lh.n; tail++) {
80102bc4:	31 db                	xor    %ebx,%ebx
{
80102bc6:	83 ec 0c             	sub    $0xc,%esp
80102bc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102bd0:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102bd5:	83 ec 08             	sub    $0x8,%esp
80102bd8:	01 d8                	add    %ebx,%eax
80102bda:	83 c0 01             	add    $0x1,%eax
80102bdd:	50                   	push   %eax
80102bde:	ff 35 04 39 11 80    	pushl  0x80113904
80102be4:	e8 e7 d4 ff ff       	call   801000d0 <bread>
80102be9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102beb:	58                   	pop    %eax
80102bec:	5a                   	pop    %edx
80102bed:	ff 34 9d 0c 39 11 80 	pushl  -0x7feec6f4(,%ebx,4)
80102bf4:	ff 35 04 39 11 80    	pushl  0x80113904
  for (tail = 0; tail < log.lh.n; tail++) {
80102bfa:	83 c3 01             	add    $0x1,%ebx
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102bfd:	e8 ce d4 ff ff       	call   801000d0 <bread>
80102c02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102c04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102c07:	83 c4 0c             	add    $0xc,%esp
80102c0a:	68 00 02 00 00       	push   $0x200
80102c0f:	50                   	push   %eax
80102c10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c13:	50                   	push   %eax
80102c14:	e8 07 1f 00 00       	call   80104b20 <memmove>
    bwrite(dbuf);  // write dst to disk
80102c19:	89 34 24             	mov    %esi,(%esp)
80102c1c:	e8 7f d5 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102c21:	89 3c 24             	mov    %edi,(%esp)
80102c24:	e8 b7 d5 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102c29:	89 34 24             	mov    %esi,(%esp)
80102c2c:	e8 af d5 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102c31:	83 c4 10             	add    $0x10,%esp
80102c34:	39 1d 08 39 11 80    	cmp    %ebx,0x80113908
80102c3a:	7f 94                	jg     80102bd0 <install_trans+0x20>
  }
}
80102c3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c3f:	5b                   	pop    %ebx
80102c40:	5e                   	pop    %esi
80102c41:	5f                   	pop    %edi
80102c42:	5d                   	pop    %ebp
80102c43:	c3                   	ret    
80102c44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102c48:	f3 c3                	repz ret 
80102c4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102c50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102c50:	55                   	push   %ebp
80102c51:	89 e5                	mov    %esp,%ebp
80102c53:	56                   	push   %esi
80102c54:	53                   	push   %ebx
  struct buf *buf = bread(log.dev, log.start);
80102c55:	83 ec 08             	sub    $0x8,%esp
80102c58:	ff 35 f4 38 11 80    	pushl  0x801138f4
80102c5e:	ff 35 04 39 11 80    	pushl  0x80113904
80102c64:	e8 67 d4 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102c69:	8b 1d 08 39 11 80    	mov    0x80113908,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102c6f:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102c72:	89 c6                	mov    %eax,%esi
  for (i = 0; i < log.lh.n; i++) {
80102c74:	85 db                	test   %ebx,%ebx
  hb->n = log.lh.n;
80102c76:	89 58 5c             	mov    %ebx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102c79:	7e 16                	jle    80102c91 <write_head+0x41>
80102c7b:	c1 e3 02             	shl    $0x2,%ebx
80102c7e:	31 d2                	xor    %edx,%edx
    hb->block[i] = log.lh.block[i];
80102c80:	8b 8a 0c 39 11 80    	mov    -0x7feec6f4(%edx),%ecx
80102c86:	89 4c 16 60          	mov    %ecx,0x60(%esi,%edx,1)
80102c8a:	83 c2 04             	add    $0x4,%edx
  for (i = 0; i < log.lh.n; i++) {
80102c8d:	39 da                	cmp    %ebx,%edx
80102c8f:	75 ef                	jne    80102c80 <write_head+0x30>
  }
  bwrite(buf);
80102c91:	83 ec 0c             	sub    $0xc,%esp
80102c94:	56                   	push   %esi
80102c95:	e8 06 d5 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102c9a:	89 34 24             	mov    %esi,(%esp)
80102c9d:	e8 3e d5 ff ff       	call   801001e0 <brelse>
}
80102ca2:	83 c4 10             	add    $0x10,%esp
80102ca5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ca8:	5b                   	pop    %ebx
80102ca9:	5e                   	pop    %esi
80102caa:	5d                   	pop    %ebp
80102cab:	c3                   	ret    
80102cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102cb0 <initlog>:
{
80102cb0:	55                   	push   %ebp
80102cb1:	89 e5                	mov    %esp,%ebp
80102cb3:	53                   	push   %ebx
80102cb4:	83 ec 2c             	sub    $0x2c,%esp
80102cb7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102cba:	68 e0 7a 10 80       	push   $0x80107ae0
80102cbf:	68 c0 38 11 80       	push   $0x801138c0
80102cc4:	e8 57 1b 00 00       	call   80104820 <initlock>
  readsb(dev, &sb);
80102cc9:	58                   	pop    %eax
80102cca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102ccd:	5a                   	pop    %edx
80102cce:	50                   	push   %eax
80102ccf:	53                   	push   %ebx
80102cd0:	e8 6b e8 ff ff       	call   80101540 <readsb>
  log.size = sb.nlog;
80102cd5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102cd8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102cdb:	59                   	pop    %ecx
  log.dev = dev;
80102cdc:	89 1d 04 39 11 80    	mov    %ebx,0x80113904
  log.size = sb.nlog;
80102ce2:	89 15 f8 38 11 80    	mov    %edx,0x801138f8
  log.start = sb.logstart;
80102ce8:	a3 f4 38 11 80       	mov    %eax,0x801138f4
  struct buf *buf = bread(log.dev, log.start);
80102ced:	5a                   	pop    %edx
80102cee:	50                   	push   %eax
80102cef:	53                   	push   %ebx
80102cf0:	e8 db d3 ff ff       	call   801000d0 <bread>
  log.lh.n = lh->n;
80102cf5:	8b 58 5c             	mov    0x5c(%eax),%ebx
  for (i = 0; i < log.lh.n; i++) {
80102cf8:	83 c4 10             	add    $0x10,%esp
80102cfb:	85 db                	test   %ebx,%ebx
  log.lh.n = lh->n;
80102cfd:	89 1d 08 39 11 80    	mov    %ebx,0x80113908
  for (i = 0; i < log.lh.n; i++) {
80102d03:	7e 1c                	jle    80102d21 <initlog+0x71>
80102d05:	c1 e3 02             	shl    $0x2,%ebx
80102d08:	31 d2                	xor    %edx,%edx
80102d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    log.lh.block[i] = lh->block[i];
80102d10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102d14:	83 c2 04             	add    $0x4,%edx
80102d17:	89 8a 08 39 11 80    	mov    %ecx,-0x7feec6f8(%edx)
  for (i = 0; i < log.lh.n; i++) {
80102d1d:	39 d3                	cmp    %edx,%ebx
80102d1f:	75 ef                	jne    80102d10 <initlog+0x60>
  brelse(buf);
80102d21:	83 ec 0c             	sub    $0xc,%esp
80102d24:	50                   	push   %eax
80102d25:	e8 b6 d4 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102d2a:	e8 81 fe ff ff       	call   80102bb0 <install_trans>
  log.lh.n = 0;
80102d2f:	c7 05 08 39 11 80 00 	movl   $0x0,0x80113908
80102d36:	00 00 00 
  write_head(); // clear the log
80102d39:	e8 12 ff ff ff       	call   80102c50 <write_head>
}
80102d3e:	83 c4 10             	add    $0x10,%esp
80102d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d44:	c9                   	leave  
80102d45:	c3                   	ret    
80102d46:	8d 76 00             	lea    0x0(%esi),%esi
80102d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102d50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102d50:	55                   	push   %ebp
80102d51:	89 e5                	mov    %esp,%ebp
80102d53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102d56:	68 c0 38 11 80       	push   $0x801138c0
80102d5b:	e8 00 1c 00 00       	call   80104960 <acquire>
80102d60:	83 c4 10             	add    $0x10,%esp
80102d63:	eb 18                	jmp    80102d7d <begin_op+0x2d>
80102d65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102d68:	83 ec 08             	sub    $0x8,%esp
80102d6b:	68 c0 38 11 80       	push   $0x801138c0
80102d70:	68 c0 38 11 80       	push   $0x801138c0
80102d75:	e8 a6 13 00 00       	call   80104120 <sleep>
80102d7a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102d7d:	a1 00 39 11 80       	mov    0x80113900,%eax
80102d82:	85 c0                	test   %eax,%eax
80102d84:	75 e2                	jne    80102d68 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102d86:	a1 fc 38 11 80       	mov    0x801138fc,%eax
80102d8b:	8b 15 08 39 11 80    	mov    0x80113908,%edx
80102d91:	83 c0 01             	add    $0x1,%eax
80102d94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102d97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102d9a:	83 fa 1e             	cmp    $0x1e,%edx
80102d9d:	7f c9                	jg     80102d68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102d9f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102da2:	a3 fc 38 11 80       	mov    %eax,0x801138fc
      release(&log.lock);
80102da7:	68 c0 38 11 80       	push   $0x801138c0
80102dac:	e8 6f 1c 00 00       	call   80104a20 <release>
      break;
    }
  }
}
80102db1:	83 c4 10             	add    $0x10,%esp
80102db4:	c9                   	leave  
80102db5:	c3                   	ret    
80102db6:	8d 76 00             	lea    0x0(%esi),%esi
80102db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102dc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102dc0:	55                   	push   %ebp
80102dc1:	89 e5                	mov    %esp,%ebp
80102dc3:	57                   	push   %edi
80102dc4:	56                   	push   %esi
80102dc5:	53                   	push   %ebx
80102dc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102dc9:	68 c0 38 11 80       	push   $0x801138c0
80102dce:	e8 8d 1b 00 00       	call   80104960 <acquire>
  log.outstanding -= 1;
80102dd3:	a1 fc 38 11 80       	mov    0x801138fc,%eax
  if(log.committing)
80102dd8:	8b 35 00 39 11 80    	mov    0x80113900,%esi
80102dde:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102de1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  if(log.committing)
80102de4:	85 f6                	test   %esi,%esi
  log.outstanding -= 1;
80102de6:	89 1d fc 38 11 80    	mov    %ebx,0x801138fc
  if(log.committing)
80102dec:	0f 85 1a 01 00 00    	jne    80102f0c <end_op+0x14c>
    panic("log.committing");
  if(log.outstanding == 0){
80102df2:	85 db                	test   %ebx,%ebx
80102df4:	0f 85 ee 00 00 00    	jne    80102ee8 <end_op+0x128>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102dfa:	83 ec 0c             	sub    $0xc,%esp
    log.committing = 1;
80102dfd:	c7 05 00 39 11 80 01 	movl   $0x1,0x80113900
80102e04:	00 00 00 
  release(&log.lock);
80102e07:	68 c0 38 11 80       	push   $0x801138c0
80102e0c:	e8 0f 1c 00 00       	call   80104a20 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102e11:	8b 0d 08 39 11 80    	mov    0x80113908,%ecx
80102e17:	83 c4 10             	add    $0x10,%esp
80102e1a:	85 c9                	test   %ecx,%ecx
80102e1c:	0f 8e 85 00 00 00    	jle    80102ea7 <end_op+0xe7>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102e22:	a1 f4 38 11 80       	mov    0x801138f4,%eax
80102e27:	83 ec 08             	sub    $0x8,%esp
80102e2a:	01 d8                	add    %ebx,%eax
80102e2c:	83 c0 01             	add    $0x1,%eax
80102e2f:	50                   	push   %eax
80102e30:	ff 35 04 39 11 80    	pushl  0x80113904
80102e36:	e8 95 d2 ff ff       	call   801000d0 <bread>
80102e3b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e3d:	58                   	pop    %eax
80102e3e:	5a                   	pop    %edx
80102e3f:	ff 34 9d 0c 39 11 80 	pushl  -0x7feec6f4(,%ebx,4)
80102e46:	ff 35 04 39 11 80    	pushl  0x80113904
  for (tail = 0; tail < log.lh.n; tail++) {
80102e4c:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102e4f:	e8 7c d2 ff ff       	call   801000d0 <bread>
80102e54:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102e56:	8d 40 5c             	lea    0x5c(%eax),%eax
80102e59:	83 c4 0c             	add    $0xc,%esp
80102e5c:	68 00 02 00 00       	push   $0x200
80102e61:	50                   	push   %eax
80102e62:	8d 46 5c             	lea    0x5c(%esi),%eax
80102e65:	50                   	push   %eax
80102e66:	e8 b5 1c 00 00       	call   80104b20 <memmove>
    bwrite(to);  // write the log
80102e6b:	89 34 24             	mov    %esi,(%esp)
80102e6e:	e8 2d d3 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102e73:	89 3c 24             	mov    %edi,(%esp)
80102e76:	e8 65 d3 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102e7b:	89 34 24             	mov    %esi,(%esp)
80102e7e:	e8 5d d3 ff ff       	call   801001e0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102e83:	83 c4 10             	add    $0x10,%esp
80102e86:	3b 1d 08 39 11 80    	cmp    0x80113908,%ebx
80102e8c:	7c 94                	jl     80102e22 <end_op+0x62>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102e8e:	e8 bd fd ff ff       	call   80102c50 <write_head>
    install_trans(); // Now install writes to home locations
80102e93:	e8 18 fd ff ff       	call   80102bb0 <install_trans>
    log.lh.n = 0;
80102e98:	c7 05 08 39 11 80 00 	movl   $0x0,0x80113908
80102e9f:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ea2:	e8 a9 fd ff ff       	call   80102c50 <write_head>
    acquire(&log.lock);
80102ea7:	83 ec 0c             	sub    $0xc,%esp
80102eaa:	68 c0 38 11 80       	push   $0x801138c0
80102eaf:	e8 ac 1a 00 00       	call   80104960 <acquire>
    wakeup(&log);
80102eb4:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
    log.committing = 0;
80102ebb:	c7 05 00 39 11 80 00 	movl   $0x0,0x80113900
80102ec2:	00 00 00 
    wakeup(&log);
80102ec5:	e8 16 14 00 00       	call   801042e0 <wakeup>
    release(&log.lock);
80102eca:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80102ed1:	e8 4a 1b 00 00       	call   80104a20 <release>
80102ed6:	83 c4 10             	add    $0x10,%esp
}
80102ed9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102edc:	5b                   	pop    %ebx
80102edd:	5e                   	pop    %esi
80102ede:	5f                   	pop    %edi
80102edf:	5d                   	pop    %ebp
80102ee0:	c3                   	ret    
80102ee1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&log);
80102ee8:	83 ec 0c             	sub    $0xc,%esp
80102eeb:	68 c0 38 11 80       	push   $0x801138c0
80102ef0:	e8 eb 13 00 00       	call   801042e0 <wakeup>
  release(&log.lock);
80102ef5:	c7 04 24 c0 38 11 80 	movl   $0x801138c0,(%esp)
80102efc:	e8 1f 1b 00 00       	call   80104a20 <release>
80102f01:	83 c4 10             	add    $0x10,%esp
}
80102f04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f07:	5b                   	pop    %ebx
80102f08:	5e                   	pop    %esi
80102f09:	5f                   	pop    %edi
80102f0a:	5d                   	pop    %ebp
80102f0b:	c3                   	ret    
    panic("log.committing");
80102f0c:	83 ec 0c             	sub    $0xc,%esp
80102f0f:	68 e4 7a 10 80       	push   $0x80107ae4
80102f14:	e8 77 d4 ff ff       	call   80100390 <panic>
80102f19:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102f20 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102f20:	55                   	push   %ebp
80102f21:	89 e5                	mov    %esp,%ebp
80102f23:	53                   	push   %ebx
80102f24:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f27:	8b 15 08 39 11 80    	mov    0x80113908,%edx
{
80102f2d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102f30:	83 fa 1d             	cmp    $0x1d,%edx
80102f33:	0f 8f 9d 00 00 00    	jg     80102fd6 <log_write+0xb6>
80102f39:	a1 f8 38 11 80       	mov    0x801138f8,%eax
80102f3e:	83 e8 01             	sub    $0x1,%eax
80102f41:	39 c2                	cmp    %eax,%edx
80102f43:	0f 8d 8d 00 00 00    	jge    80102fd6 <log_write+0xb6>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102f49:	a1 fc 38 11 80       	mov    0x801138fc,%eax
80102f4e:	85 c0                	test   %eax,%eax
80102f50:	0f 8e 8d 00 00 00    	jle    80102fe3 <log_write+0xc3>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102f56:	83 ec 0c             	sub    $0xc,%esp
80102f59:	68 c0 38 11 80       	push   $0x801138c0
80102f5e:	e8 fd 19 00 00       	call   80104960 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102f63:	8b 0d 08 39 11 80    	mov    0x80113908,%ecx
80102f69:	83 c4 10             	add    $0x10,%esp
80102f6c:	83 f9 00             	cmp    $0x0,%ecx
80102f6f:	7e 57                	jle    80102fc8 <log_write+0xa8>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f71:	8b 53 08             	mov    0x8(%ebx),%edx
  for (i = 0; i < log.lh.n; i++) {
80102f74:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102f76:	3b 15 0c 39 11 80    	cmp    0x8011390c,%edx
80102f7c:	75 0b                	jne    80102f89 <log_write+0x69>
80102f7e:	eb 38                	jmp    80102fb8 <log_write+0x98>
80102f80:	39 14 85 0c 39 11 80 	cmp    %edx,-0x7feec6f4(,%eax,4)
80102f87:	74 2f                	je     80102fb8 <log_write+0x98>
  for (i = 0; i < log.lh.n; i++) {
80102f89:	83 c0 01             	add    $0x1,%eax
80102f8c:	39 c1                	cmp    %eax,%ecx
80102f8e:	75 f0                	jne    80102f80 <log_write+0x60>
      break;
  }
  log.lh.block[i] = b->blockno;
80102f90:	89 14 85 0c 39 11 80 	mov    %edx,-0x7feec6f4(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
80102f97:	83 c0 01             	add    $0x1,%eax
80102f9a:	a3 08 39 11 80       	mov    %eax,0x80113908
  b->flags |= B_DIRTY; // prevent eviction
80102f9f:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102fa2:	c7 45 08 c0 38 11 80 	movl   $0x801138c0,0x8(%ebp)
}
80102fa9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102fac:	c9                   	leave  
  release(&log.lock);
80102fad:	e9 6e 1a 00 00       	jmp    80104a20 <release>
80102fb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80102fb8:	89 14 85 0c 39 11 80 	mov    %edx,-0x7feec6f4(,%eax,4)
80102fbf:	eb de                	jmp    80102f9f <log_write+0x7f>
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fc8:	8b 43 08             	mov    0x8(%ebx),%eax
80102fcb:	a3 0c 39 11 80       	mov    %eax,0x8011390c
  if (i == log.lh.n)
80102fd0:	75 cd                	jne    80102f9f <log_write+0x7f>
80102fd2:	31 c0                	xor    %eax,%eax
80102fd4:	eb c1                	jmp    80102f97 <log_write+0x77>
    panic("too big a transaction");
80102fd6:	83 ec 0c             	sub    $0xc,%esp
80102fd9:	68 f3 7a 10 80       	push   $0x80107af3
80102fde:	e8 ad d3 ff ff       	call   80100390 <panic>
    panic("log_write outside of trans");
80102fe3:	83 ec 0c             	sub    $0xc,%esp
80102fe6:	68 09 7b 10 80       	push   $0x80107b09
80102feb:	e8 a0 d3 ff ff       	call   80100390 <panic>

80102ff0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102ff7:	e8 94 09 00 00       	call   80103990 <cpuid>
80102ffc:	89 c3                	mov    %eax,%ebx
80102ffe:	e8 8d 09 00 00       	call   80103990 <cpuid>
80103003:	83 ec 04             	sub    $0x4,%esp
80103006:	53                   	push   %ebx
80103007:	50                   	push   %eax
80103008:	68 24 7b 10 80       	push   $0x80107b24
8010300d:	e8 4e d6 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80103012:	e8 a9 2d 00 00       	call   80105dc0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80103017:	e8 f4 08 00 00       	call   80103910 <mycpu>
8010301c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010301e:	b8 01 00 00 00       	mov    $0x1,%eax
80103023:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
8010302a:	e8 11 0e 00 00       	call   80103e40 <scheduler>
8010302f:	90                   	nop

80103030 <mpenter>:
{
80103030:	55                   	push   %ebp
80103031:	89 e5                	mov    %esp,%ebp
80103033:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80103036:	e8 95 3e 00 00       	call   80106ed0 <switchkvm>
  seginit();
8010303b:	e8 00 3e 00 00       	call   80106e40 <seginit>
  lapicinit();
80103040:	e8 9b f7 ff ff       	call   801027e0 <lapicinit>
  mpmain();
80103045:	e8 a6 ff ff ff       	call   80102ff0 <mpmain>
8010304a:	66 90                	xchg   %ax,%ax
8010304c:	66 90                	xchg   %ax,%ax
8010304e:	66 90                	xchg   %ax,%ax

80103050 <main>:
{
80103050:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103054:	83 e4 f0             	and    $0xfffffff0,%esp
80103057:	ff 71 fc             	pushl  -0x4(%ecx)
8010305a:	55                   	push   %ebp
8010305b:	89 e5                	mov    %esp,%ebp
8010305d:	53                   	push   %ebx
8010305e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010305f:	83 ec 08             	sub    $0x8,%esp
80103062:	68 00 00 40 80       	push   $0x80400000
80103067:	68 08 6c 11 80       	push   $0x80116c08
8010306c:	e8 2f f5 ff ff       	call   801025a0 <kinit1>
  kvmalloc();      // kernel page table
80103071:	e8 2a 43 00 00       	call   801073a0 <kvmalloc>
  mpinit();        // detect other processors
80103076:	e8 75 01 00 00       	call   801031f0 <mpinit>
  lapicinit();     // interrupt controller
8010307b:	e8 60 f7 ff ff       	call   801027e0 <lapicinit>
  seginit();       // segment descriptors
80103080:	e8 bb 3d 00 00       	call   80106e40 <seginit>
  picinit();       // disable pic
80103085:	e8 46 03 00 00       	call   801033d0 <picinit>
  ioapicinit();    // another interrupt controller
8010308a:	e8 41 f3 ff ff       	call   801023d0 <ioapicinit>
  consoleinit();   // console hardware
8010308f:	e8 2c d9 ff ff       	call   801009c0 <consoleinit>
  uartinit();      // serial port
80103094:	e8 77 30 00 00       	call   80106110 <uartinit>
  pinit();         // process table
80103099:	e8 52 08 00 00       	call   801038f0 <pinit>
  tvinit();        // trap vectors
8010309e:	e8 7d 2c 00 00       	call   80105d20 <tvinit>
  binit();         // buffer cache
801030a3:	e8 98 cf ff ff       	call   80100040 <binit>
  fileinit();      // file table
801030a8:	e8 b3 dc ff ff       	call   80100d60 <fileinit>
  ideinit();       // disk 
801030ad:	e8 fe f0 ff ff       	call   801021b0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801030b2:	83 c4 0c             	add    $0xc,%esp
801030b5:	68 8a 00 00 00       	push   $0x8a
801030ba:	68 8c b4 10 80       	push   $0x8010b48c
801030bf:	68 00 70 00 80       	push   $0x80007000
801030c4:	e8 57 1a 00 00       	call   80104b20 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
801030c9:	69 05 60 3f 11 80 b4 	imul   $0xb4,0x80113f60,%eax
801030d0:	00 00 00 
801030d3:	83 c4 10             	add    $0x10,%esp
801030d6:	05 c0 39 11 80       	add    $0x801139c0,%eax
801030db:	3d c0 39 11 80       	cmp    $0x801139c0,%eax
801030e0:	76 71                	jbe    80103153 <main+0x103>
801030e2:	bb c0 39 11 80       	mov    $0x801139c0,%ebx
801030e7:	89 f6                	mov    %esi,%esi
801030e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c == mycpu())  // We've started already.
801030f0:	e8 1b 08 00 00       	call   80103910 <mycpu>
801030f5:	39 d8                	cmp    %ebx,%eax
801030f7:	74 41                	je     8010313a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801030f9:	e8 72 f5 ff ff       	call   80102670 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
801030fe:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80103103:	c7 05 f8 6f 00 80 30 	movl   $0x80103030,0x80006ff8
8010310a:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010310d:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
80103114:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
80103117:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc

    lapicstartap(c->apicid, V2P(code));
8010311c:	0f b6 03             	movzbl (%ebx),%eax
8010311f:	83 ec 08             	sub    $0x8,%esp
80103122:	68 00 70 00 00       	push   $0x7000
80103127:	50                   	push   %eax
80103128:	e8 03 f8 ff ff       	call   80102930 <lapicstartap>
8010312d:	83 c4 10             	add    $0x10,%esp

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103130:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103136:	85 c0                	test   %eax,%eax
80103138:	74 f6                	je     80103130 <main+0xe0>
  for(c = cpus; c < cpus+ncpu; c++){
8010313a:	69 05 60 3f 11 80 b4 	imul   $0xb4,0x80113f60,%eax
80103141:	00 00 00 
80103144:	81 c3 b4 00 00 00    	add    $0xb4,%ebx
8010314a:	05 c0 39 11 80       	add    $0x801139c0,%eax
8010314f:	39 c3                	cmp    %eax,%ebx
80103151:	72 9d                	jb     801030f0 <main+0xa0>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103153:	83 ec 08             	sub    $0x8,%esp
80103156:	68 00 00 00 8e       	push   $0x8e000000
8010315b:	68 00 00 40 80       	push   $0x80400000
80103160:	e8 ab f4 ff ff       	call   80102610 <kinit2>
  userinit();      // first user process
80103165:	e8 76 08 00 00       	call   801039e0 <userinit>
  mpmain();        // finish this processor's setup
8010316a:	e8 81 fe ff ff       	call   80102ff0 <mpmain>
8010316f:	90                   	nop

80103170 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103170:	55                   	push   %ebp
80103171:	89 e5                	mov    %esp,%ebp
80103173:	57                   	push   %edi
80103174:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103175:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010317b:	53                   	push   %ebx
  e = addr+len;
8010317c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010317f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103182:	39 de                	cmp    %ebx,%esi
80103184:	72 10                	jb     80103196 <mpsearch1+0x26>
80103186:	eb 50                	jmp    801031d8 <mpsearch1+0x68>
80103188:	90                   	nop
80103189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103190:	39 fb                	cmp    %edi,%ebx
80103192:	89 fe                	mov    %edi,%esi
80103194:	76 42                	jbe    801031d8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103196:	83 ec 04             	sub    $0x4,%esp
80103199:	8d 7e 10             	lea    0x10(%esi),%edi
8010319c:	6a 04                	push   $0x4
8010319e:	68 38 7b 10 80       	push   $0x80107b38
801031a3:	56                   	push   %esi
801031a4:	e8 17 19 00 00       	call   80104ac0 <memcmp>
801031a9:	83 c4 10             	add    $0x10,%esp
801031ac:	85 c0                	test   %eax,%eax
801031ae:	75 e0                	jne    80103190 <mpsearch1+0x20>
801031b0:	89 f1                	mov    %esi,%ecx
801031b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
801031b8:	0f b6 11             	movzbl (%ecx),%edx
801031bb:	83 c1 01             	add    $0x1,%ecx
801031be:	01 d0                	add    %edx,%eax
  for(i=0; i<len; i++)
801031c0:	39 f9                	cmp    %edi,%ecx
801031c2:	75 f4                	jne    801031b8 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
801031c4:	84 c0                	test   %al,%al
801031c6:	75 c8                	jne    80103190 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
801031c8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801031cb:	89 f0                	mov    %esi,%eax
801031cd:	5b                   	pop    %ebx
801031ce:	5e                   	pop    %esi
801031cf:	5f                   	pop    %edi
801031d0:	5d                   	pop    %ebp
801031d1:	c3                   	ret    
801031d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801031db:	31 f6                	xor    %esi,%esi
}
801031dd:	89 f0                	mov    %esi,%eax
801031df:	5b                   	pop    %ebx
801031e0:	5e                   	pop    %esi
801031e1:	5f                   	pop    %edi
801031e2:	5d                   	pop    %ebp
801031e3:	c3                   	ret    
801031e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801031ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801031f0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801031f9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103200:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103207:	c1 e0 08             	shl    $0x8,%eax
8010320a:	09 d0                	or     %edx,%eax
8010320c:	c1 e0 04             	shl    $0x4,%eax
8010320f:	85 c0                	test   %eax,%eax
80103211:	75 1b                	jne    8010322e <mpinit+0x3e>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80103213:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010321a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103221:	c1 e0 08             	shl    $0x8,%eax
80103224:	09 d0                	or     %edx,%eax
80103226:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80103229:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
8010322e:	ba 00 04 00 00       	mov    $0x400,%edx
80103233:	e8 38 ff ff ff       	call   80103170 <mpsearch1>
80103238:	85 c0                	test   %eax,%eax
8010323a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010323d:	0f 84 3d 01 00 00    	je     80103380 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103243:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103246:	8b 58 04             	mov    0x4(%eax),%ebx
80103249:	85 db                	test   %ebx,%ebx
8010324b:	0f 84 4f 01 00 00    	je     801033a0 <mpinit+0x1b0>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103251:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103257:	83 ec 04             	sub    $0x4,%esp
8010325a:	6a 04                	push   $0x4
8010325c:	68 55 7b 10 80       	push   $0x80107b55
80103261:	56                   	push   %esi
80103262:	e8 59 18 00 00       	call   80104ac0 <memcmp>
80103267:	83 c4 10             	add    $0x10,%esp
8010326a:	85 c0                	test   %eax,%eax
8010326c:	0f 85 2e 01 00 00    	jne    801033a0 <mpinit+0x1b0>
  if(conf->version != 1 && conf->version != 4)
80103272:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103279:	3c 01                	cmp    $0x1,%al
8010327b:	0f 95 c2             	setne  %dl
8010327e:	3c 04                	cmp    $0x4,%al
80103280:	0f 95 c0             	setne  %al
80103283:	20 c2                	and    %al,%dl
80103285:	0f 85 15 01 00 00    	jne    801033a0 <mpinit+0x1b0>
  if(sum((uchar*)conf, conf->length) != 0)
8010328b:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
  for(i=0; i<len; i++)
80103292:	66 85 ff             	test   %di,%di
80103295:	74 1a                	je     801032b1 <mpinit+0xc1>
80103297:	89 f0                	mov    %esi,%eax
80103299:	01 f7                	add    %esi,%edi
  sum = 0;
8010329b:	31 d2                	xor    %edx,%edx
8010329d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
801032a0:	0f b6 08             	movzbl (%eax),%ecx
801032a3:	83 c0 01             	add    $0x1,%eax
801032a6:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
801032a8:	39 c7                	cmp    %eax,%edi
801032aa:	75 f4                	jne    801032a0 <mpinit+0xb0>
801032ac:	84 d2                	test   %dl,%dl
801032ae:	0f 95 c2             	setne  %dl
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801032b1:	85 f6                	test   %esi,%esi
801032b3:	0f 84 e7 00 00 00    	je     801033a0 <mpinit+0x1b0>
801032b9:	84 d2                	test   %dl,%dl
801032bb:	0f 85 df 00 00 00    	jne    801033a0 <mpinit+0x1b0>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801032c1:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801032c7:	a3 bc 38 11 80       	mov    %eax,0x801138bc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032cc:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801032d3:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  ismp = 1;
801032d9:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801032de:	01 d6                	add    %edx,%esi
801032e0:	39 c6                	cmp    %eax,%esi
801032e2:	76 23                	jbe    80103307 <mpinit+0x117>
    switch(*p){
801032e4:	0f b6 10             	movzbl (%eax),%edx
801032e7:	80 fa 04             	cmp    $0x4,%dl
801032ea:	0f 87 ca 00 00 00    	ja     801033ba <mpinit+0x1ca>
801032f0:	ff 24 95 7c 7b 10 80 	jmp    *-0x7fef8484(,%edx,4)
801032f7:	89 f6                	mov    %esi,%esi
801032f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103300:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103303:	39 c6                	cmp    %eax,%esi
80103305:	77 dd                	ja     801032e4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103307:	85 db                	test   %ebx,%ebx
80103309:	0f 84 9e 00 00 00    	je     801033ad <mpinit+0x1bd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010330f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103312:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103316:	74 15                	je     8010332d <mpinit+0x13d>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103318:	b8 70 00 00 00       	mov    $0x70,%eax
8010331d:	ba 22 00 00 00       	mov    $0x22,%edx
80103322:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103323:	ba 23 00 00 00       	mov    $0x23,%edx
80103328:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80103329:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010332c:	ee                   	out    %al,(%dx)
  }
}
8010332d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103330:	5b                   	pop    %ebx
80103331:	5e                   	pop    %esi
80103332:	5f                   	pop    %edi
80103333:	5d                   	pop    %ebp
80103334:	c3                   	ret    
80103335:	8d 76 00             	lea    0x0(%esi),%esi
      if(ncpu < NCPU) {
80103338:	8b 0d 60 3f 11 80    	mov    0x80113f60,%ecx
8010333e:	83 f9 07             	cmp    $0x7,%ecx
80103341:	7f 19                	jg     8010335c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103343:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103347:	69 f9 b4 00 00 00    	imul   $0xb4,%ecx,%edi
        ncpu++;
8010334d:	83 c1 01             	add    $0x1,%ecx
80103350:	89 0d 60 3f 11 80    	mov    %ecx,0x80113f60
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103356:	88 97 c0 39 11 80    	mov    %dl,-0x7feec640(%edi)
      p += sizeof(struct mpproc);
8010335c:	83 c0 14             	add    $0x14,%eax
      continue;
8010335f:	e9 7c ff ff ff       	jmp    801032e0 <mpinit+0xf0>
80103364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103368:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010336c:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
8010336f:	88 15 a0 39 11 80    	mov    %dl,0x801139a0
      continue;
80103375:	e9 66 ff ff ff       	jmp    801032e0 <mpinit+0xf0>
8010337a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return mpsearch1(0xF0000, 0x10000);
80103380:	ba 00 00 01 00       	mov    $0x10000,%edx
80103385:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010338a:	e8 e1 fd ff ff       	call   80103170 <mpsearch1>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010338f:	85 c0                	test   %eax,%eax
  return mpsearch1(0xF0000, 0x10000);
80103391:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103394:	0f 85 a9 fe ff ff    	jne    80103243 <mpinit+0x53>
8010339a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    panic("Expect to run on an SMP");
801033a0:	83 ec 0c             	sub    $0xc,%esp
801033a3:	68 3d 7b 10 80       	push   $0x80107b3d
801033a8:	e8 e3 cf ff ff       	call   80100390 <panic>
    panic("Didn't find a suitable machine");
801033ad:	83 ec 0c             	sub    $0xc,%esp
801033b0:	68 5c 7b 10 80       	push   $0x80107b5c
801033b5:	e8 d6 cf ff ff       	call   80100390 <panic>
      ismp = 0;
801033ba:	31 db                	xor    %ebx,%ebx
801033bc:	e9 26 ff ff ff       	jmp    801032e7 <mpinit+0xf7>
801033c1:	66 90                	xchg   %ax,%ax
801033c3:	66 90                	xchg   %ax,%ax
801033c5:	66 90                	xchg   %ax,%ax
801033c7:	66 90                	xchg   %ax,%ax
801033c9:	66 90                	xchg   %ax,%ax
801033cb:	66 90                	xchg   %ax,%ax
801033cd:	66 90                	xchg   %ax,%ax
801033cf:	90                   	nop

801033d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801033d0:	55                   	push   %ebp
801033d1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801033d6:	ba 21 00 00 00       	mov    $0x21,%edx
801033db:	89 e5                	mov    %esp,%ebp
801033dd:	ee                   	out    %al,(%dx)
801033de:	ba a1 00 00 00       	mov    $0xa1,%edx
801033e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801033e4:	5d                   	pop    %ebp
801033e5:	c3                   	ret    
801033e6:	66 90                	xchg   %ax,%ax
801033e8:	66 90                	xchg   %ax,%ax
801033ea:	66 90                	xchg   %ax,%ax
801033ec:	66 90                	xchg   %ax,%ax
801033ee:	66 90                	xchg   %ax,%ax

801033f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 0c             	sub    $0xc,%esp
801033f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801033fc:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801033ff:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80103405:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010340b:	e8 70 d9 ff ff       	call   80100d80 <filealloc>
80103410:	85 c0                	test   %eax,%eax
80103412:	89 03                	mov    %eax,(%ebx)
80103414:	74 22                	je     80103438 <pipealloc+0x48>
80103416:	e8 65 d9 ff ff       	call   80100d80 <filealloc>
8010341b:	85 c0                	test   %eax,%eax
8010341d:	89 06                	mov    %eax,(%esi)
8010341f:	74 3f                	je     80103460 <pipealloc+0x70>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103421:	e8 4a f2 ff ff       	call   80102670 <kalloc>
80103426:	85 c0                	test   %eax,%eax
80103428:	89 c7                	mov    %eax,%edi
8010342a:	75 54                	jne    80103480 <pipealloc+0x90>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
8010342c:	8b 03                	mov    (%ebx),%eax
8010342e:	85 c0                	test   %eax,%eax
80103430:	75 34                	jne    80103466 <pipealloc+0x76>
80103432:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    fileclose(*f0);
  if(*f1)
80103438:	8b 06                	mov    (%esi),%eax
8010343a:	85 c0                	test   %eax,%eax
8010343c:	74 0c                	je     8010344a <pipealloc+0x5a>
    fileclose(*f1);
8010343e:	83 ec 0c             	sub    $0xc,%esp
80103441:	50                   	push   %eax
80103442:	e8 f9 d9 ff ff       	call   80100e40 <fileclose>
80103447:	83 c4 10             	add    $0x10,%esp
  return -1;
}
8010344a:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
8010344d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103452:	5b                   	pop    %ebx
80103453:	5e                   	pop    %esi
80103454:	5f                   	pop    %edi
80103455:	5d                   	pop    %ebp
80103456:	c3                   	ret    
80103457:	89 f6                	mov    %esi,%esi
80103459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  if(*f0)
80103460:	8b 03                	mov    (%ebx),%eax
80103462:	85 c0                	test   %eax,%eax
80103464:	74 e4                	je     8010344a <pipealloc+0x5a>
    fileclose(*f0);
80103466:	83 ec 0c             	sub    $0xc,%esp
80103469:	50                   	push   %eax
8010346a:	e8 d1 d9 ff ff       	call   80100e40 <fileclose>
  if(*f1)
8010346f:	8b 06                	mov    (%esi),%eax
    fileclose(*f0);
80103471:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80103474:	85 c0                	test   %eax,%eax
80103476:	75 c6                	jne    8010343e <pipealloc+0x4e>
80103478:	eb d0                	jmp    8010344a <pipealloc+0x5a>
8010347a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  initlock(&p->lock, "pipe");
80103480:	83 ec 08             	sub    $0x8,%esp
  p->readopen = 1;
80103483:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010348a:	00 00 00 
  p->writeopen = 1;
8010348d:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80103494:	00 00 00 
  p->nwrite = 0;
80103497:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
8010349e:	00 00 00 
  p->nread = 0;
801034a1:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801034a8:	00 00 00 
  initlock(&p->lock, "pipe");
801034ab:	68 90 7b 10 80       	push   $0x80107b90
801034b0:	50                   	push   %eax
801034b1:	e8 6a 13 00 00       	call   80104820 <initlock>
  (*f0)->type = FD_PIPE;
801034b6:	8b 03                	mov    (%ebx),%eax
  return 0;
801034b8:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
801034bb:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
801034c1:	8b 03                	mov    (%ebx),%eax
801034c3:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
801034c7:	8b 03                	mov    (%ebx),%eax
801034c9:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
801034cd:	8b 03                	mov    (%ebx),%eax
801034cf:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
801034d2:	8b 06                	mov    (%esi),%eax
801034d4:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
801034da:	8b 06                	mov    (%esi),%eax
801034dc:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
801034e0:	8b 06                	mov    (%esi),%eax
801034e2:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
801034e6:	8b 06                	mov    (%esi),%eax
801034e8:	89 78 0c             	mov    %edi,0xc(%eax)
}
801034eb:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801034ee:	31 c0                	xor    %eax,%eax
}
801034f0:	5b                   	pop    %ebx
801034f1:	5e                   	pop    %esi
801034f2:	5f                   	pop    %edi
801034f3:	5d                   	pop    %ebp
801034f4:	c3                   	ret    
801034f5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103500 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103500:	55                   	push   %ebp
80103501:	89 e5                	mov    %esp,%ebp
80103503:	56                   	push   %esi
80103504:	53                   	push   %ebx
80103505:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103508:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010350b:	83 ec 0c             	sub    $0xc,%esp
8010350e:	53                   	push   %ebx
8010350f:	e8 4c 14 00 00       	call   80104960 <acquire>
  if(writable){
80103514:	83 c4 10             	add    $0x10,%esp
80103517:	85 f6                	test   %esi,%esi
80103519:	74 45                	je     80103560 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010351b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103521:	83 ec 0c             	sub    $0xc,%esp
    p->writeopen = 0;
80103524:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010352b:	00 00 00 
    wakeup(&p->nread);
8010352e:	50                   	push   %eax
8010352f:	e8 ac 0d 00 00       	call   801042e0 <wakeup>
80103534:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103537:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010353d:	85 d2                	test   %edx,%edx
8010353f:	75 0a                	jne    8010354b <pipeclose+0x4b>
80103541:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103547:	85 c0                	test   %eax,%eax
80103549:	74 35                	je     80103580 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010354b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010354e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103551:	5b                   	pop    %ebx
80103552:	5e                   	pop    %esi
80103553:	5d                   	pop    %ebp
    release(&p->lock);
80103554:	e9 c7 14 00 00       	jmp    80104a20 <release>
80103559:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    wakeup(&p->nwrite);
80103560:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103566:	83 ec 0c             	sub    $0xc,%esp
    p->readopen = 0;
80103569:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103570:	00 00 00 
    wakeup(&p->nwrite);
80103573:	50                   	push   %eax
80103574:	e8 67 0d 00 00       	call   801042e0 <wakeup>
80103579:	83 c4 10             	add    $0x10,%esp
8010357c:	eb b9                	jmp    80103537 <pipeclose+0x37>
8010357e:	66 90                	xchg   %ax,%ax
    release(&p->lock);
80103580:	83 ec 0c             	sub    $0xc,%esp
80103583:	53                   	push   %ebx
80103584:	e8 97 14 00 00       	call   80104a20 <release>
    kfree((char*)p);
80103589:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010358c:	83 c4 10             	add    $0x10,%esp
}
8010358f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103592:	5b                   	pop    %ebx
80103593:	5e                   	pop    %esi
80103594:	5d                   	pop    %ebp
    kfree((char*)p);
80103595:	e9 26 ef ff ff       	jmp    801024c0 <kfree>
8010359a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801035a0 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	57                   	push   %edi
801035a4:	56                   	push   %esi
801035a5:	53                   	push   %ebx
801035a6:	83 ec 28             	sub    $0x28,%esp
801035a9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
801035ac:	53                   	push   %ebx
801035ad:	e8 ae 13 00 00       	call   80104960 <acquire>
  for(i = 0; i < n; i++){
801035b2:	8b 45 10             	mov    0x10(%ebp),%eax
801035b5:	83 c4 10             	add    $0x10,%esp
801035b8:	85 c0                	test   %eax,%eax
801035ba:	0f 8e c9 00 00 00    	jle    80103689 <pipewrite+0xe9>
801035c0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801035c3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801035c9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801035cf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801035d2:	03 4d 10             	add    0x10(%ebp),%ecx
801035d5:	89 4d e0             	mov    %ecx,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801035d8:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801035de:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801035e4:	39 d0                	cmp    %edx,%eax
801035e6:	75 71                	jne    80103659 <pipewrite+0xb9>
      if(p->readopen == 0 || myproc()->killed){
801035e8:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
801035ee:	85 c0                	test   %eax,%eax
801035f0:	74 4e                	je     80103640 <pipewrite+0xa0>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801035f2:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801035f8:	eb 3a                	jmp    80103634 <pipewrite+0x94>
801035fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      wakeup(&p->nread);
80103600:	83 ec 0c             	sub    $0xc,%esp
80103603:	57                   	push   %edi
80103604:	e8 d7 0c 00 00       	call   801042e0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103609:	5a                   	pop    %edx
8010360a:	59                   	pop    %ecx
8010360b:	53                   	push   %ebx
8010360c:	56                   	push   %esi
8010360d:	e8 0e 0b 00 00       	call   80104120 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103612:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103618:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010361e:	83 c4 10             	add    $0x10,%esp
80103621:	05 00 02 00 00       	add    $0x200,%eax
80103626:	39 c2                	cmp    %eax,%edx
80103628:	75 36                	jne    80103660 <pipewrite+0xc0>
      if(p->readopen == 0 || myproc()->killed){
8010362a:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103630:	85 c0                	test   %eax,%eax
80103632:	74 0c                	je     80103640 <pipewrite+0xa0>
80103634:	e8 77 03 00 00       	call   801039b0 <myproc>
80103639:	8b 40 24             	mov    0x24(%eax),%eax
8010363c:	85 c0                	test   %eax,%eax
8010363e:	74 c0                	je     80103600 <pipewrite+0x60>
        release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 d7 13 00 00       	call   80104a20 <release>
        return -1;
80103649:	83 c4 10             	add    $0x10,%esp
8010364c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103651:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103654:	5b                   	pop    %ebx
80103655:	5e                   	pop    %esi
80103656:	5f                   	pop    %edi
80103657:	5d                   	pop    %ebp
80103658:	c3                   	ret    
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103659:	89 c2                	mov    %eax,%edx
8010365b:	90                   	nop
8010365c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103660:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80103663:	8d 42 01             	lea    0x1(%edx),%eax
80103666:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
8010366c:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103672:	83 c6 01             	add    $0x1,%esi
80103675:	0f b6 4e ff          	movzbl -0x1(%esi),%ecx
  for(i = 0; i < n; i++){
80103679:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010367c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010367f:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103683:	0f 85 4f ff ff ff    	jne    801035d8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103689:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010368f:	83 ec 0c             	sub    $0xc,%esp
80103692:	50                   	push   %eax
80103693:	e8 48 0c 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
80103698:	89 1c 24             	mov    %ebx,(%esp)
8010369b:	e8 80 13 00 00       	call   80104a20 <release>
  return n;
801036a0:	83 c4 10             	add    $0x10,%esp
801036a3:	8b 45 10             	mov    0x10(%ebp),%eax
801036a6:	eb a9                	jmp    80103651 <pipewrite+0xb1>
801036a8:	90                   	nop
801036a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801036b0 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	57                   	push   %edi
801036b4:	56                   	push   %esi
801036b5:	53                   	push   %ebx
801036b6:	83 ec 18             	sub    $0x18,%esp
801036b9:	8b 75 08             	mov    0x8(%ebp),%esi
801036bc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801036bf:	56                   	push   %esi
801036c0:	e8 9b 12 00 00       	call   80104960 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036c5:	83 c4 10             	add    $0x10,%esp
801036c8:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
801036ce:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
801036d4:	75 6a                	jne    80103740 <piperead+0x90>
801036d6:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
801036dc:	85 db                	test   %ebx,%ebx
801036de:	0f 84 c4 00 00 00    	je     801037a8 <piperead+0xf8>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801036e4:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
801036ea:	eb 2d                	jmp    80103719 <piperead+0x69>
801036ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036f0:	83 ec 08             	sub    $0x8,%esp
801036f3:	56                   	push   %esi
801036f4:	53                   	push   %ebx
801036f5:	e8 26 0a 00 00       	call   80104120 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801036fa:	83 c4 10             	add    $0x10,%esp
801036fd:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103703:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
80103709:	75 35                	jne    80103740 <piperead+0x90>
8010370b:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103711:	85 d2                	test   %edx,%edx
80103713:	0f 84 8f 00 00 00    	je     801037a8 <piperead+0xf8>
    if(myproc()->killed){
80103719:	e8 92 02 00 00       	call   801039b0 <myproc>
8010371e:	8b 48 24             	mov    0x24(%eax),%ecx
80103721:	85 c9                	test   %ecx,%ecx
80103723:	74 cb                	je     801036f0 <piperead+0x40>
      release(&p->lock);
80103725:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103728:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
8010372d:	56                   	push   %esi
8010372e:	e8 ed 12 00 00       	call   80104a20 <release>
      return -1;
80103733:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103736:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103739:	89 d8                	mov    %ebx,%eax
8010373b:	5b                   	pop    %ebx
8010373c:	5e                   	pop    %esi
8010373d:	5f                   	pop    %edi
8010373e:	5d                   	pop    %ebp
8010373f:	c3                   	ret    
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103740:	8b 45 10             	mov    0x10(%ebp),%eax
80103743:	85 c0                	test   %eax,%eax
80103745:	7e 61                	jle    801037a8 <piperead+0xf8>
    if(p->nread == p->nwrite)
80103747:	31 db                	xor    %ebx,%ebx
80103749:	eb 13                	jmp    8010375e <piperead+0xae>
8010374b:	90                   	nop
8010374c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103750:	8b 8e 34 02 00 00    	mov    0x234(%esi),%ecx
80103756:	3b 8e 38 02 00 00    	cmp    0x238(%esi),%ecx
8010375c:	74 1f                	je     8010377d <piperead+0xcd>
    addr[i] = p->data[p->nread++ % PIPESIZE];
8010375e:	8d 41 01             	lea    0x1(%ecx),%eax
80103761:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80103767:	89 86 34 02 00 00    	mov    %eax,0x234(%esi)
8010376d:	0f b6 44 0e 34       	movzbl 0x34(%esi,%ecx,1),%eax
80103772:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103775:	83 c3 01             	add    $0x1,%ebx
80103778:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010377b:	75 d3                	jne    80103750 <piperead+0xa0>
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010377d:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103783:	83 ec 0c             	sub    $0xc,%esp
80103786:	50                   	push   %eax
80103787:	e8 54 0b 00 00       	call   801042e0 <wakeup>
  release(&p->lock);
8010378c:	89 34 24             	mov    %esi,(%esp)
8010378f:	e8 8c 12 00 00       	call   80104a20 <release>
  return i;
80103794:	83 c4 10             	add    $0x10,%esp
}
80103797:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010379a:	89 d8                	mov    %ebx,%eax
8010379c:	5b                   	pop    %ebx
8010379d:	5e                   	pop    %esi
8010379e:	5f                   	pop    %edi
8010379f:	5d                   	pop    %ebp
801037a0:	c3                   	ret    
801037a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801037a8:	31 db                	xor    %ebx,%ebx
801037aa:	eb d1                	jmp    8010377d <piperead+0xcd>
801037ac:	66 90                	xchg   %ax,%ax
801037ae:	66 90                	xchg   %ax,%ax

801037b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801037b0:	55                   	push   %ebp
801037b1:	89 e5                	mov    %esp,%ebp
801037b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037b4:	bb b4 3f 11 80       	mov    $0x80113fb4,%ebx
{
801037b9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
801037bc:	68 80 3f 11 80       	push   $0x80113f80
801037c1:	e8 9a 11 00 00       	call   80104960 <acquire>
801037c6:	83 c4 10             	add    $0x10,%esp
801037c9:	eb 13                	jmp    801037de <allocproc+0x2e>
801037cb:	90                   	nop
801037cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801037d0:	81 c3 90 00 00 00    	add    $0x90,%ebx
801037d6:	81 fb b4 63 11 80    	cmp    $0x801163b4,%ebx
801037dc:	73 7a                	jae    80103858 <allocproc+0xa8>
    if(p->state == UNUSED)
801037de:	8b 43 0c             	mov    0xc(%ebx),%eax
801037e1:	85 c0                	test   %eax,%eax
801037e3:	75 eb                	jne    801037d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801037e5:	a1 04 b0 10 80       	mov    0x8010b004,%eax
      boosting = ticks;
   }
 
#endif

  release(&ptable.lock);
801037ea:	83 ec 0c             	sub    $0xc,%esp
  p->state = EMBRYO;
801037ed:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801037f4:	8d 50 01             	lea    0x1(%eax),%edx
801037f7:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
801037fa:	68 80 3f 11 80       	push   $0x80113f80
  p->pid = nextpid++;
801037ff:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  release(&ptable.lock);
80103805:	e8 16 12 00 00       	call   80104a20 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010380a:	e8 61 ee ff ff       	call   80102670 <kalloc>
8010380f:	83 c4 10             	add    $0x10,%esp
80103812:	85 c0                	test   %eax,%eax
80103814:	89 43 08             	mov    %eax,0x8(%ebx)
80103817:	74 58                	je     80103871 <allocproc+0xc1>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103819:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010381f:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
80103822:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103827:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
8010382a:	c7 40 14 12 5d 10 80 	movl   $0x80105d12,0x14(%eax)
  p->context = (struct context*)sp;
80103831:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103834:	6a 14                	push   $0x14
80103836:	6a 00                	push   $0x0
80103838:	50                   	push   %eax
80103839:	e8 32 12 00 00       	call   80104a70 <memset>
  p->context->eip = (uint)forkret;
8010383e:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
80103841:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103844:	c7 40 10 80 38 10 80 	movl   $0x80103880,0x10(%eax)
}
8010384b:	89 d8                	mov    %ebx,%eax
8010384d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103850:	c9                   	leave  
80103851:	c3                   	ret    
80103852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  release(&ptable.lock);
80103858:	83 ec 0c             	sub    $0xc,%esp
  return 0;
8010385b:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
8010385d:	68 80 3f 11 80       	push   $0x80113f80
80103862:	e8 b9 11 00 00       	call   80104a20 <release>
}
80103867:	89 d8                	mov    %ebx,%eax
  return 0;
80103869:	83 c4 10             	add    $0x10,%esp
}
8010386c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010386f:	c9                   	leave  
80103870:	c3                   	ret    
    p->state = UNUSED;
80103871:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103878:	31 db                	xor    %ebx,%ebx
8010387a:	eb cf                	jmp    8010384b <allocproc+0x9b>
8010387c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103880 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103880:	55                   	push   %ebp
80103881:	89 e5                	mov    %esp,%ebp
80103883:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103886:	68 80 3f 11 80       	push   $0x80113f80
8010388b:	e8 90 11 00 00       	call   80104a20 <release>

  if (first) {
80103890:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103895:	83 c4 10             	add    $0x10,%esp
80103898:	85 c0                	test   %eax,%eax
8010389a:	75 04                	jne    801038a0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010389c:	c9                   	leave  
8010389d:	c3                   	ret    
8010389e:	66 90                	xchg   %ax,%ax
    iinit(ROOTDEV);
801038a0:	83 ec 0c             	sub    $0xc,%esp
    first = 0;
801038a3:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
801038aa:	00 00 00 
    iinit(ROOTDEV);
801038ad:	6a 01                	push   $0x1
801038af:	e8 cc dc ff ff       	call   80101580 <iinit>
    initlog(ROOTDEV);
801038b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801038bb:	e8 f0 f3 ff ff       	call   80102cb0 <initlog>
801038c0:	83 c4 10             	add    $0x10,%esp
}
801038c3:	c9                   	leave  
801038c4:	c3                   	ret    
801038c5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801038c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801038d0 <enqueue>:
{
801038d0:	55                   	push   %ebp
801038d1:	89 e5                	mov    %esp,%ebp
801038d3:	8b 55 08             	mov    0x8(%ebp),%edx
  Q->q[Q->count] = p;
801038d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801038d9:	8b 82 00 01 00 00    	mov    0x100(%edx),%eax
801038df:	89 0c 82             	mov    %ecx,(%edx,%eax,4)
  Q->count++;
801038e2:	83 c0 01             	add    $0x1,%eax
801038e5:	89 82 00 01 00 00    	mov    %eax,0x100(%edx)
}
801038eb:	5d                   	pop    %ebp
801038ec:	c3                   	ret    
801038ed:	8d 76 00             	lea    0x0(%esi),%esi

801038f0 <pinit>:
{
801038f0:	55                   	push   %ebp
801038f1:	89 e5                	mov    %esp,%ebp
801038f3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801038f6:	68 95 7b 10 80       	push   $0x80107b95
801038fb:	68 80 3f 11 80       	push   $0x80113f80
80103900:	e8 1b 0f 00 00       	call   80104820 <initlock>
}
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	c9                   	leave  
80103909:	c3                   	ret    
8010390a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103910 <mycpu>:
{
80103910:	55                   	push   %ebp
80103911:	89 e5                	mov    %esp,%ebp
80103913:	56                   	push   %esi
80103914:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103915:	9c                   	pushf  
80103916:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103917:	f6 c4 02             	test   $0x2,%ah
8010391a:	75 5e                	jne    8010397a <mycpu+0x6a>
  apicid = lapicid();
8010391c:	e8 bf ef ff ff       	call   801028e0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103921:	8b 35 60 3f 11 80    	mov    0x80113f60,%esi
80103927:	85 f6                	test   %esi,%esi
80103929:	7e 42                	jle    8010396d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
8010392b:	0f b6 15 c0 39 11 80 	movzbl 0x801139c0,%edx
80103932:	39 d0                	cmp    %edx,%eax
80103934:	74 30                	je     80103966 <mycpu+0x56>
80103936:	b9 74 3a 11 80       	mov    $0x80113a74,%ecx
  for (i = 0; i < ncpu; ++i) {
8010393b:	31 d2                	xor    %edx,%edx
8010393d:	8d 76 00             	lea    0x0(%esi),%esi
80103940:	83 c2 01             	add    $0x1,%edx
80103943:	39 f2                	cmp    %esi,%edx
80103945:	74 26                	je     8010396d <mycpu+0x5d>
    if (cpus[i].apicid == apicid)
80103947:	0f b6 19             	movzbl (%ecx),%ebx
8010394a:	81 c1 b4 00 00 00    	add    $0xb4,%ecx
80103950:	39 c3                	cmp    %eax,%ebx
80103952:	75 ec                	jne    80103940 <mycpu+0x30>
80103954:	69 c2 b4 00 00 00    	imul   $0xb4,%edx,%eax
8010395a:	05 c0 39 11 80       	add    $0x801139c0,%eax
}
8010395f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103962:	5b                   	pop    %ebx
80103963:	5e                   	pop    %esi
80103964:	5d                   	pop    %ebp
80103965:	c3                   	ret    
    if (cpus[i].apicid == apicid)
80103966:	b8 c0 39 11 80       	mov    $0x801139c0,%eax
      return &cpus[i];
8010396b:	eb f2                	jmp    8010395f <mycpu+0x4f>
  panic("unknown apicid\n");
8010396d:	83 ec 0c             	sub    $0xc,%esp
80103970:	68 9c 7b 10 80       	push   $0x80107b9c
80103975:	e8 16 ca ff ff       	call   80100390 <panic>
    panic("mycpu called with interrupts enabled\n");
8010397a:	83 ec 0c             	sub    $0xc,%esp
8010397d:	68 78 7c 10 80       	push   $0x80107c78
80103982:	e8 09 ca ff ff       	call   80100390 <panic>
80103987:	89 f6                	mov    %esi,%esi
80103989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103990 <cpuid>:
cpuid() {
80103990:	55                   	push   %ebp
80103991:	89 e5                	mov    %esp,%ebp
80103993:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103996:	e8 75 ff ff ff       	call   80103910 <mycpu>
8010399b:	2d c0 39 11 80       	sub    $0x801139c0,%eax
}
801039a0:	c9                   	leave  
  return mycpu()-cpus;
801039a1:	c1 f8 02             	sar    $0x2,%eax
801039a4:	69 c0 a5 4f fa a4    	imul   $0xa4fa4fa5,%eax,%eax
}
801039aa:	c3                   	ret    
801039ab:	90                   	nop
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039b0 <myproc>:
struct proc* myproc(void) {
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801039b7:	e8 d4 0e 00 00       	call   80104890 <pushcli>
  c = mycpu();
801039bc:	e8 4f ff ff ff       	call   80103910 <mycpu>
  p = c->proc;
801039c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801039c7:	e8 04 0f 00 00       	call   801048d0 <popcli>
}
801039cc:	83 c4 04             	add    $0x4,%esp
801039cf:	89 d8                	mov    %ebx,%eax
801039d1:	5b                   	pop    %ebx
801039d2:	5d                   	pop    %ebp
801039d3:	c3                   	ret    
801039d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801039da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801039e0 <userinit>:
{
801039e0:	55                   	push   %ebp
801039e1:	89 e5                	mov    %esp,%ebp
801039e3:	53                   	push   %ebx
801039e4:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801039e7:	e8 c4 fd ff ff       	call   801037b0 <allocproc>
801039ec:	89 c3                	mov    %eax,%ebx
  initproc = p;
801039ee:	a3 e4 b7 10 80       	mov    %eax,0x8010b7e4
  if((p->pgdir = setupkvm()) == 0)
801039f3:	e8 28 39 00 00       	call   80107320 <setupkvm>
801039f8:	85 c0                	test   %eax,%eax
801039fa:	89 43 04             	mov    %eax,0x4(%ebx)
801039fd:	0f 84 c0 00 00 00    	je     80103ac3 <userinit+0xe3>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103a03:	83 ec 04             	sub    $0x4,%esp
80103a06:	68 2c 00 00 00       	push   $0x2c
80103a0b:	68 60 b4 10 80       	push   $0x8010b460
80103a10:	50                   	push   %eax
80103a11:	e8 ea 35 00 00       	call   80107000 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103a16:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103a19:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103a1f:	6a 4c                	push   $0x4c
80103a21:	6a 00                	push   $0x0
80103a23:	ff 73 18             	pushl  0x18(%ebx)
80103a26:	e8 45 10 00 00       	call   80104a70 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a2b:	8b 43 18             	mov    0x18(%ebx),%eax
80103a2e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a33:	b9 23 00 00 00       	mov    $0x23,%ecx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a38:	83 c4 0c             	add    $0xc,%esp
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103a3b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103a3f:	8b 43 18             	mov    0x18(%ebx),%eax
80103a42:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103a46:	8b 43 18             	mov    0x18(%ebx),%eax
80103a49:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a4d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103a51:	8b 43 18             	mov    0x18(%ebx),%eax
80103a54:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103a58:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103a5c:	8b 43 18             	mov    0x18(%ebx),%eax
80103a5f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103a66:	8b 43 18             	mov    0x18(%ebx),%eax
80103a69:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103a70:	8b 43 18             	mov    0x18(%ebx),%eax
80103a73:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103a7a:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80103a80:	6a 10                	push   $0x10
80103a82:	68 c5 7b 10 80       	push   $0x80107bc5
80103a87:	50                   	push   %eax
80103a88:	e8 c3 11 00 00       	call   80104c50 <safestrcpy>
  p->cwd = namei("/");
80103a8d:	c7 04 24 ce 7b 10 80 	movl   $0x80107bce,(%esp)
80103a94:	e8 f7 e5 ff ff       	call   80102090 <namei>
80103a99:	89 43 7c             	mov    %eax,0x7c(%ebx)
  acquire(&ptable.lock);
80103a9c:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80103aa3:	e8 b8 0e 00 00       	call   80104960 <acquire>
  p->state = RUNNABLE;
80103aa8:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103aaf:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80103ab6:	e8 65 0f 00 00       	call   80104a20 <release>
}
80103abb:	83 c4 10             	add    $0x10,%esp
80103abe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ac1:	c9                   	leave  
80103ac2:	c3                   	ret    
    panic("userinit: out of memory?");
80103ac3:	83 ec 0c             	sub    $0xc,%esp
80103ac6:	68 ac 7b 10 80       	push   $0x80107bac
80103acb:	e8 c0 c8 ff ff       	call   80100390 <panic>

80103ad0 <growproc>:
{
80103ad0:	55                   	push   %ebp
80103ad1:	89 e5                	mov    %esp,%ebp
80103ad3:	56                   	push   %esi
80103ad4:	53                   	push   %ebx
80103ad5:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103ad8:	e8 b3 0d 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103add:	e8 2e fe ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103ae2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ae8:	e8 e3 0d 00 00       	call   801048d0 <popcli>
  if(n > 0){
80103aed:	83 fe 00             	cmp    $0x0,%esi
  sz = curproc->sz;
80103af0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103af2:	7f 1c                	jg     80103b10 <growproc+0x40>
  } else if(n < 0){
80103af4:	75 3a                	jne    80103b30 <growproc+0x60>
  switchuvm(curproc);
80103af6:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103af9:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103afb:	53                   	push   %ebx
80103afc:	e8 ef 33 00 00       	call   80106ef0 <switchuvm>
  return 0;
80103b01:	83 c4 10             	add    $0x10,%esp
80103b04:	31 c0                	xor    %eax,%eax
}
80103b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b09:	5b                   	pop    %ebx
80103b0a:	5e                   	pop    %esi
80103b0b:	5d                   	pop    %ebp
80103b0c:	c3                   	ret    
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b10:	83 ec 04             	sub    $0x4,%esp
80103b13:	01 c6                	add    %eax,%esi
80103b15:	56                   	push   %esi
80103b16:	50                   	push   %eax
80103b17:	ff 73 04             	pushl  0x4(%ebx)
80103b1a:	e8 21 36 00 00       	call   80107140 <allocuvm>
80103b1f:	83 c4 10             	add    $0x10,%esp
80103b22:	85 c0                	test   %eax,%eax
80103b24:	75 d0                	jne    80103af6 <growproc+0x26>
      return -1;
80103b26:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b2b:	eb d9                	jmp    80103b06 <growproc+0x36>
80103b2d:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103b30:	83 ec 04             	sub    $0x4,%esp
80103b33:	01 c6                	add    %eax,%esi
80103b35:	56                   	push   %esi
80103b36:	50                   	push   %eax
80103b37:	ff 73 04             	pushl  0x4(%ebx)
80103b3a:	e8 31 37 00 00       	call   80107270 <deallocuvm>
80103b3f:	83 c4 10             	add    $0x10,%esp
80103b42:	85 c0                	test   %eax,%eax
80103b44:	75 b0                	jne    80103af6 <growproc+0x26>
80103b46:	eb de                	jmp    80103b26 <growproc+0x56>
80103b48:	90                   	nop
80103b49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103b50 <priorityBoosting>:
  if(boosting != -1 && ticks - boosting > 200)//priority boosting.
80103b50:	a1 08 b0 10 80       	mov    0x8010b008,%eax
{
80103b55:	55                   	push   %ebp
80103b56:	89 e5                	mov    %esp,%ebp
  if(boosting != -1 && ticks - boosting > 200)//priority boosting.
80103b58:	83 f8 ff             	cmp    $0xffffffff,%eax
80103b5b:	0f 84 a6 00 00 00    	je     80103c07 <priorityBoosting+0xb7>
80103b61:	8b 15 00 6c 11 80    	mov    0x80116c00,%edx
80103b67:	89 d1                	mov    %edx,%ecx
80103b69:	29 c1                	sub    %eax,%ecx
80103b6b:	81 f9 c8 00 00 00    	cmp    $0xc8,%ecx
80103b71:	0f 86 90 00 00 00    	jbe    80103c07 <priorityBoosting+0xb7>
    if(l1.count > 0)
80103b77:	a1 c0 b6 10 80       	mov    0x8010b6c0,%eax
    boosting = ticks;
80103b7c:	89 15 08 b0 10 80    	mov    %edx,0x8010b008
    if(l1.count > 0)
80103b82:	85 c0                	test   %eax,%eax
80103b84:	0f 8e 7d 00 00 00    	jle    80103c07 <priorityBoosting+0xb7>
       for(int i = 0; i < l1.count; i++)
80103b8a:	31 c0                	xor    %eax,%eax
80103b8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
          if(l1.q[i]->pid <= 0) continue;
80103b90:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80103b97:	8b 4a 10             	mov    0x10(%edx),%ecx
80103b9a:	85 c9                	test   %ecx,%ecx
80103b9c:	7e 32                	jle    80103bd0 <priorityBoosting+0x80>
          l1.q[i]->priority = 0;
80103b9e:	c7 42 30 00 00 00 00 	movl   $0x0,0x30(%edx)
          l1.q[i]->lev = 0;
80103ba5:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80103bac:	c7 42 34 00 00 00 00 	movl   $0x0,0x34(%edx)
          l0.q[l0.count] = l1.q[i];
80103bb3:	8b 15 e0 b7 10 80    	mov    0x8010b7e0,%edx
80103bb9:	8b 0c 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%ecx
80103bc0:	89 0c 95 e0 b6 10 80 	mov    %ecx,-0x7fef4920(,%edx,4)
          l0.count++;
80103bc7:	83 c2 01             	add    $0x1,%edx
80103bca:	89 15 e0 b7 10 80    	mov    %edx,0x8010b7e0
       for(int i = 0; i < l1.count; i++)
80103bd0:	8b 15 c0 b6 10 80    	mov    0x8010b6c0,%edx
80103bd6:	83 c0 01             	add    $0x1,%eax
80103bd9:	39 c2                	cmp    %eax,%edx
80103bdb:	7f b3                	jg     80103b90 <priorityBoosting+0x40>
       for(int i = 0; i < l1.count; i++)
80103bdd:	85 d2                	test   %edx,%edx
80103bdf:	7e 1c                	jle    80103bfd <priorityBoosting+0xad>
80103be1:	8d 14 95 c0 b5 10 80 	lea    -0x7fef4a40(,%edx,4),%edx
80103be8:	b8 c0 b5 10 80       	mov    $0x8010b5c0,%eax
80103bed:	8d 76 00             	lea    0x0(%esi),%esi
          l1.q[i] = 0;
80103bf0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80103bf6:	83 c0 04             	add    $0x4,%eax
       for(int i = 0; i < l1.count; i++)
80103bf9:	39 c2                	cmp    %eax,%edx
80103bfb:	75 f3                	jne    80103bf0 <priorityBoosting+0xa0>
       l1.count = 0;
80103bfd:	c7 05 c0 b6 10 80 00 	movl   $0x0,0x8010b6c0
80103c04:	00 00 00 
}
80103c07:	5d                   	pop    %ebp
80103c08:	c3                   	ret    
80103c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103c10 <getlev>:
{   
80103c10:	55                   	push   %ebp
80103c11:	89 e5                	mov    %esp,%ebp
80103c13:	53                   	push   %ebx
80103c14:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c17:	e8 74 0c 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103c1c:	e8 ef fc ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103c21:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c27:	e8 a4 0c 00 00       	call   801048d0 <popcli>
    return myproc()->lev;
80103c2c:	8b 43 34             	mov    0x34(%ebx),%eax
}
80103c2f:	83 c4 04             	add    $0x4,%esp
80103c32:	5b                   	pop    %ebx
80103c33:	5d                   	pop    %ebp
80103c34:	c3                   	ret    
80103c35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103c40 <setpriority>:
{
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	56                   	push   %esi
80103c44:	53                   	push   %ebx
80103c45:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103c48:	8b 75 08             	mov    0x8(%ebp),%esi
   acquire(&ptable.lock);
80103c4b:	83 ec 0c             	sub    $0xc,%esp
80103c4e:	68 80 3f 11 80       	push   $0x80113f80
80103c53:	e8 08 0d 00 00       	call   80104960 <acquire>
   if(priority<0 || priority >10) 
80103c58:	83 c4 10             	add    $0x10,%esp
80103c5b:	83 fb 0a             	cmp    $0xa,%ebx
80103c5e:	0f 87 98 00 00 00    	ja     80103cfc <setpriority+0xbc>
   for(int i = 0; i < l0.count; i++)
80103c64:	8b 0d e0 b7 10 80    	mov    0x8010b7e0,%ecx
80103c6a:	85 c9                	test   %ecx,%ecx
80103c6c:	7e 25                	jle    80103c93 <setpriority+0x53>
     if(l0.q[i]->pid == pid)
80103c6e:	8b 15 e0 b6 10 80    	mov    0x8010b6e0,%edx
80103c74:	3b 72 10             	cmp    0x10(%edx),%esi
80103c77:	74 67                	je     80103ce0 <setpriority+0xa0>
   for(int i = 0; i < l0.count; i++)
80103c79:	31 c0                	xor    %eax,%eax
80103c7b:	eb 0f                	jmp    80103c8c <setpriority+0x4c>
80103c7d:	8d 76 00             	lea    0x0(%esi),%esi
     if(l0.q[i]->pid == pid)
80103c80:	8b 14 85 e0 b6 10 80 	mov    -0x7fef4920(,%eax,4),%edx
80103c87:	39 72 10             	cmp    %esi,0x10(%edx)
80103c8a:	74 54                	je     80103ce0 <setpriority+0xa0>
   for(int i = 0; i < l0.count; i++)
80103c8c:	83 c0 01             	add    $0x1,%eax
80103c8f:	39 c8                	cmp    %ecx,%eax
80103c91:	75 ed                	jne    80103c80 <setpriority+0x40>
    for(int i = 0; i < l1.count; i++)
80103c93:	8b 0d c0 b6 10 80    	mov    0x8010b6c0,%ecx
80103c99:	85 c9                	test   %ecx,%ecx
80103c9b:	7e 26                	jle    80103cc3 <setpriority+0x83>
      if(l1.q[i]->pid == pid)
80103c9d:	8b 15 c0 b5 10 80    	mov    0x8010b5c0,%edx
80103ca3:	3b 72 10             	cmp    0x10(%edx),%esi
80103ca6:	74 38                	je     80103ce0 <setpriority+0xa0>
    for(int i = 0; i < l1.count; i++)
80103ca8:	31 c0                	xor    %eax,%eax
80103caa:	eb 10                	jmp    80103cbc <setpriority+0x7c>
80103cac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(l1.q[i]->pid == pid)
80103cb0:	8b 14 85 c0 b5 10 80 	mov    -0x7fef4a40(,%eax,4),%edx
80103cb7:	39 72 10             	cmp    %esi,0x10(%edx)
80103cba:	74 24                	je     80103ce0 <setpriority+0xa0>
    for(int i = 0; i < l1.count; i++)
80103cbc:	83 c0 01             	add    $0x1,%eax
80103cbf:	39 c1                	cmp    %eax,%ecx
80103cc1:	75 ed                	jne    80103cb0 <setpriority+0x70>
  release(&ptable.lock);
80103cc3:	83 ec 0c             	sub    $0xc,%esp
80103cc6:	68 80 3f 11 80       	push   $0x80113f80
80103ccb:	e8 50 0d 00 00       	call   80104a20 <release>
  return -1;
80103cd0:	83 c4 10             	add    $0x10,%esp
}
80103cd3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  return -1;
80103cd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103cdb:	5b                   	pop    %ebx
80103cdc:	5e                   	pop    %esi
80103cdd:	5d                   	pop    %ebp
80103cde:	c3                   	ret    
80103cdf:	90                   	nop
         release(&ptable.lock);
80103ce0:	83 ec 0c             	sub    $0xc,%esp
         l1.q[i]->priority = priority;
80103ce3:	89 5a 30             	mov    %ebx,0x30(%edx)
         release(&ptable.lock);
80103ce6:	68 80 3f 11 80       	push   $0x80113f80
80103ceb:	e8 30 0d 00 00       	call   80104a20 <release>
         return 0;
80103cf0:	83 c4 10             	add    $0x10,%esp
80103cf3:	31 c0                	xor    %eax,%eax
}
80103cf5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103cf8:	5b                   	pop    %ebx
80103cf9:	5e                   	pop    %esi
80103cfa:	5d                   	pop    %ebp
80103cfb:	c3                   	ret    
      release(&ptable.lock);
80103cfc:	83 ec 0c             	sub    $0xc,%esp
80103cff:	68 80 3f 11 80       	push   $0x80113f80
80103d04:	e8 17 0d 00 00       	call   80104a20 <release>
      return -2;
80103d09:	83 c4 10             	add    $0x10,%esp
80103d0c:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
80103d11:	eb e2                	jmp    80103cf5 <setpriority+0xb5>
80103d13:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d20 <fork>:
{
80103d20:	55                   	push   %ebp
80103d21:	89 e5                	mov    %esp,%ebp
80103d23:	57                   	push   %edi
80103d24:	56                   	push   %esi
80103d25:	53                   	push   %ebx
80103d26:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103d29:	e8 62 0b 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103d2e:	e8 dd fb ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103d33:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d39:	e8 92 0b 00 00       	call   801048d0 <popcli>
  if((np = allocproc()) == 0){
80103d3e:	e8 6d fa ff ff       	call   801037b0 <allocproc>
80103d43:	85 c0                	test   %eax,%eax
80103d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103d48:	0f 84 ba 00 00 00    	je     80103e08 <fork+0xe8>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){ 
80103d4e:	83 ec 08             	sub    $0x8,%esp
80103d51:	ff 33                	pushl  (%ebx)
80103d53:	ff 73 04             	pushl  0x4(%ebx)
80103d56:	89 c7                	mov    %eax,%edi
80103d58:	e8 93 36 00 00       	call   801073f0 <copyuvm>
80103d5d:	83 c4 10             	add    $0x10,%esp
80103d60:	85 c0                	test   %eax,%eax
80103d62:	89 47 04             	mov    %eax,0x4(%edi)
80103d65:	0f 84 a4 00 00 00    	je     80103e0f <fork+0xef>
  np->sz = curproc->sz;
80103d6b:	8b 03                	mov    (%ebx),%eax
80103d6d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103d70:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103d72:	89 59 14             	mov    %ebx,0x14(%ecx)
80103d75:	89 c8                	mov    %ecx,%eax
  *np->tf = *curproc->tf;
80103d77:	8b 79 18             	mov    0x18(%ecx),%edi
80103d7a:	8b 73 18             	mov    0x18(%ebx),%esi
80103d7d:	b9 13 00 00 00       	mov    $0x13,%ecx
80103d82:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for(i = 0; i < NOFILE; i++)
80103d84:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103d86:	8b 40 18             	mov    0x18(%eax),%eax
80103d89:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    if(curproc->ofile[i])
80103d90:	8b 44 b3 3c          	mov    0x3c(%ebx,%esi,4),%eax
80103d94:	85 c0                	test   %eax,%eax
80103d96:	74 13                	je     80103dab <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103d98:	83 ec 0c             	sub    $0xc,%esp
80103d9b:	50                   	push   %eax
80103d9c:	e8 4f d0 ff ff       	call   80100df0 <filedup>
80103da1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103da4:	83 c4 10             	add    $0x10,%esp
80103da7:	89 44 b2 3c          	mov    %eax,0x3c(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103dab:	83 c6 01             	add    $0x1,%esi
80103dae:	83 fe 10             	cmp    $0x10,%esi
80103db1:	75 dd                	jne    80103d90 <fork+0x70>
  np->cwd = idup(curproc->cwd);
80103db3:	83 ec 0c             	sub    $0xc,%esp
80103db6:	ff 73 7c             	pushl  0x7c(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103db9:	83 eb 80             	sub    $0xffffff80,%ebx
  np->cwd = idup(curproc->cwd);
80103dbc:	e8 8f d9 ff ff       	call   80101750 <idup>
80103dc1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dc4:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103dc7:	89 47 7c             	mov    %eax,0x7c(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103dca:	8d 87 80 00 00 00    	lea    0x80(%edi),%eax
80103dd0:	6a 10                	push   $0x10
80103dd2:	53                   	push   %ebx
80103dd3:	50                   	push   %eax
80103dd4:	e8 77 0e 00 00       	call   80104c50 <safestrcpy>
  pid = np->pid;
80103dd9:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103ddc:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80103de3:	e8 78 0b 00 00       	call   80104960 <acquire>
  np->state = RUNNABLE;
80103de8:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103def:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80103df6:	e8 25 0c 00 00       	call   80104a20 <release>
  return pid;//자신의 Pid를 리턴해줌
80103dfb:	83 c4 10             	add    $0x10,%esp
}
80103dfe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103e01:	89 d8                	mov    %ebx,%eax
80103e03:	5b                   	pop    %ebx
80103e04:	5e                   	pop    %esi
80103e05:	5f                   	pop    %edi
80103e06:	5d                   	pop    %ebp
80103e07:	c3                   	ret    
    return -1;
80103e08:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e0d:	eb ef                	jmp    80103dfe <fork+0xde>
    kfree(np->kstack);
80103e0f:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103e12:	83 ec 0c             	sub    $0xc,%esp
80103e15:	ff 73 08             	pushl  0x8(%ebx)
80103e18:	e8 a3 e6 ff ff       	call   801024c0 <kfree>
    np->kstack = 0;
80103e1d:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
80103e24:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103e2b:	83 c4 10             	add    $0x10,%esp
80103e2e:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103e33:	eb c9                	jmp    80103dfe <fork+0xde>
80103e35:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103e40 <scheduler>:
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	57                   	push   %edi
80103e44:	56                   	push   %esi
80103e45:	53                   	push   %ebx
80103e46:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103e49:	e8 c2 fa ff ff       	call   80103910 <mycpu>
80103e4e:	8d 78 04             	lea    0x4(%eax),%edi
80103e51:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103e53:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103e5a:	00 00 00 
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103e60:	fb                   	sti    
    acquire(&ptable.lock);
80103e61:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e64:	bb b4 3f 11 80       	mov    $0x80113fb4,%ebx
    acquire(&ptable.lock);
80103e69:	68 80 3f 11 80       	push   $0x80113f80
80103e6e:	e8 ed 0a 00 00       	call   80104960 <acquire>
80103e73:	83 c4 10             	add    $0x10,%esp
80103e76:	8d 76 00             	lea    0x0(%esi),%esi
80103e79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      if(p->state != RUNNABLE)
80103e80:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103e84:	75 33                	jne    80103eb9 <scheduler+0x79>
      switchuvm(p);
80103e86:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103e89:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103e8f:	53                   	push   %ebx
80103e90:	e8 5b 30 00 00       	call   80106ef0 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103e95:	58                   	pop    %eax
80103e96:	5a                   	pop    %edx
80103e97:	ff 73 1c             	pushl  0x1c(%ebx)
80103e9a:	57                   	push   %edi
      p->state = RUNNING;
80103e9b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103ea2:	e8 04 0e 00 00       	call   80104cab <swtch>
      switchkvm();
80103ea7:	e8 24 30 00 00       	call   80106ed0 <switchkvm>
      c->proc = 0;
80103eac:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103eb3:	00 00 00 
80103eb6:	83 c4 10             	add    $0x10,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eb9:	81 c3 90 00 00 00    	add    $0x90,%ebx
80103ebf:	81 fb b4 63 11 80    	cmp    $0x801163b4,%ebx
80103ec5:	72 b9                	jb     80103e80 <scheduler+0x40>
    release(&ptable.lock);
80103ec7:	83 ec 0c             	sub    $0xc,%esp
80103eca:	68 80 3f 11 80       	push   $0x80113f80
80103ecf:	e8 4c 0b 00 00       	call   80104a20 <release>
    sti();
80103ed4:	83 c4 10             	add    $0x10,%esp
80103ed7:	eb 87                	jmp    80103e60 <scheduler+0x20>
80103ed9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ee0 <sched>:
{
80103ee0:	55                   	push   %ebp
80103ee1:	89 e5                	mov    %esp,%ebp
80103ee3:	56                   	push   %esi
80103ee4:	53                   	push   %ebx
  pushcli();
80103ee5:	e8 a6 09 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103eea:	e8 21 fa ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103eef:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103ef5:	e8 d6 09 00 00       	call   801048d0 <popcli>
  if(!holding(&ptable.lock))
80103efa:	83 ec 0c             	sub    $0xc,%esp
80103efd:	68 80 3f 11 80       	push   $0x80113f80
80103f02:	e8 29 0a 00 00       	call   80104930 <holding>
80103f07:	83 c4 10             	add    $0x10,%esp
80103f0a:	85 c0                	test   %eax,%eax
80103f0c:	74 4f                	je     80103f5d <sched+0x7d>
  if(mycpu()->ncli != 1)
80103f0e:	e8 fd f9 ff ff       	call   80103910 <mycpu>
80103f13:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103f1a:	75 68                	jne    80103f84 <sched+0xa4>
  if(p->state == RUNNING)
80103f1c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103f20:	74 55                	je     80103f77 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103f22:	9c                   	pushf  
80103f23:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103f24:	f6 c4 02             	test   $0x2,%ah
80103f27:	75 41                	jne    80103f6a <sched+0x8a>
  intena = mycpu()->intena;
80103f29:	e8 e2 f9 ff ff       	call   80103910 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103f2e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80103f31:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103f37:	e8 d4 f9 ff ff       	call   80103910 <mycpu>
80103f3c:	83 ec 08             	sub    $0x8,%esp
80103f3f:	ff 70 04             	pushl  0x4(%eax)
80103f42:	53                   	push   %ebx
80103f43:	e8 63 0d 00 00       	call   80104cab <swtch>
  mycpu()->intena = intena;
80103f48:	e8 c3 f9 ff ff       	call   80103910 <mycpu>
}
80103f4d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80103f50:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103f56:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103f59:	5b                   	pop    %ebx
80103f5a:	5e                   	pop    %esi
80103f5b:	5d                   	pop    %ebp
80103f5c:	c3                   	ret    
    panic("sched ptable.lock");
80103f5d:	83 ec 0c             	sub    $0xc,%esp
80103f60:	68 d0 7b 10 80       	push   $0x80107bd0
80103f65:	e8 26 c4 ff ff       	call   80100390 <panic>
    panic("sched interruptible");
80103f6a:	83 ec 0c             	sub    $0xc,%esp
80103f6d:	68 fc 7b 10 80       	push   $0x80107bfc
80103f72:	e8 19 c4 ff ff       	call   80100390 <panic>
    panic("sched running");
80103f77:	83 ec 0c             	sub    $0xc,%esp
80103f7a:	68 ee 7b 10 80       	push   $0x80107bee
80103f7f:	e8 0c c4 ff ff       	call   80100390 <panic>
    panic("sched locks");
80103f84:	83 ec 0c             	sub    $0xc,%esp
80103f87:	68 e2 7b 10 80       	push   $0x80107be2
80103f8c:	e8 ff c3 ff ff       	call   80100390 <panic>
80103f91:	eb 0d                	jmp    80103fa0 <exit>
80103f93:	90                   	nop
80103f94:	90                   	nop
80103f95:	90                   	nop
80103f96:	90                   	nop
80103f97:	90                   	nop
80103f98:	90                   	nop
80103f99:	90                   	nop
80103f9a:	90                   	nop
80103f9b:	90                   	nop
80103f9c:	90                   	nop
80103f9d:	90                   	nop
80103f9e:	90                   	nop
80103f9f:	90                   	nop

80103fa0 <exit>:
{
80103fa0:	55                   	push   %ebp
80103fa1:	89 e5                	mov    %esp,%ebp
80103fa3:	57                   	push   %edi
80103fa4:	56                   	push   %esi
80103fa5:	53                   	push   %ebx
80103fa6:	83 ec 0c             	sub    $0xc,%esp
  pushcli();
80103fa9:	e8 e2 08 00 00       	call   80104890 <pushcli>
  c = mycpu();
80103fae:	e8 5d f9 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80103fb3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103fb9:	e8 12 09 00 00       	call   801048d0 <popcli>
  if(curproc == initproc)
80103fbe:	39 35 e4 b7 10 80    	cmp    %esi,0x8010b7e4
80103fc4:	8d 5e 3c             	lea    0x3c(%esi),%ebx
80103fc7:	8d 7e 7c             	lea    0x7c(%esi),%edi
80103fca:	0f 84 f1 00 00 00    	je     801040c1 <exit+0x121>
    if(curproc->ofile[fd]){
80103fd0:	8b 03                	mov    (%ebx),%eax
80103fd2:	85 c0                	test   %eax,%eax
80103fd4:	74 12                	je     80103fe8 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103fd6:	83 ec 0c             	sub    $0xc,%esp
80103fd9:	50                   	push   %eax
80103fda:	e8 61 ce ff ff       	call   80100e40 <fileclose>
      curproc->ofile[fd] = 0;
80103fdf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103fe5:	83 c4 10             	add    $0x10,%esp
80103fe8:	83 c3 04             	add    $0x4,%ebx
  for(fd = 0; fd < NOFILE; fd++){
80103feb:	39 fb                	cmp    %edi,%ebx
80103fed:	75 e1                	jne    80103fd0 <exit+0x30>
  begin_op();
80103fef:	e8 5c ed ff ff       	call   80102d50 <begin_op>
  iput(curproc->cwd);
80103ff4:	83 ec 0c             	sub    $0xc,%esp
80103ff7:	ff 76 7c             	pushl  0x7c(%esi)
80103ffa:	e8 b1 d8 ff ff       	call   801018b0 <iput>
  end_op();
80103fff:	e8 bc ed ff ff       	call   80102dc0 <end_op>
  curproc->cwd = 0;
80104004:	c7 46 7c 00 00 00 00 	movl   $0x0,0x7c(%esi)
  acquire(&ptable.lock);
8010400b:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80104012:	e8 49 09 00 00       	call   80104960 <acquire>
  wakeup1(curproc->parent);
80104017:	8b 56 14             	mov    0x14(%esi),%edx
8010401a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010401d:	b8 b4 3f 11 80       	mov    $0x80113fb4,%eax
80104022:	eb 10                	jmp    80104034 <exit+0x94>
80104024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104028:	05 90 00 00 00       	add    $0x90,%eax
8010402d:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
80104032:	73 1e                	jae    80104052 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80104034:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104038:	75 ee                	jne    80104028 <exit+0x88>
8010403a:	3b 50 20             	cmp    0x20(%eax),%edx
8010403d:	75 e9                	jne    80104028 <exit+0x88>
      p->state = RUNNABLE;
8010403f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104046:	05 90 00 00 00       	add    $0x90,%eax
8010404b:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
80104050:	72 e2                	jb     80104034 <exit+0x94>
      p->parent = initproc;
80104052:	8b 0d e4 b7 10 80    	mov    0x8010b7e4,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104058:	ba b4 3f 11 80       	mov    $0x80113fb4,%edx
8010405d:	eb 0f                	jmp    8010406e <exit+0xce>
8010405f:	90                   	nop
80104060:	81 c2 90 00 00 00    	add    $0x90,%edx
80104066:	81 fa b4 63 11 80    	cmp    $0x801163b4,%edx
8010406c:	73 3a                	jae    801040a8 <exit+0x108>
    if(p->parent == curproc){
8010406e:	39 72 14             	cmp    %esi,0x14(%edx)
80104071:	75 ed                	jne    80104060 <exit+0xc0>
      if(p->state == ZOMBIE)
80104073:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
80104077:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
8010407a:	75 e4                	jne    80104060 <exit+0xc0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010407c:	b8 b4 3f 11 80       	mov    $0x80113fb4,%eax
80104081:	eb 11                	jmp    80104094 <exit+0xf4>
80104083:	90                   	nop
80104084:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104088:	05 90 00 00 00       	add    $0x90,%eax
8010408d:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
80104092:	73 cc                	jae    80104060 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80104094:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104098:	75 ee                	jne    80104088 <exit+0xe8>
8010409a:	3b 48 20             	cmp    0x20(%eax),%ecx
8010409d:	75 e9                	jne    80104088 <exit+0xe8>
      p->state = RUNNABLE;
8010409f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801040a6:	eb e0                	jmp    80104088 <exit+0xe8>
  curproc->state = ZOMBIE;
801040a8:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
801040af:	e8 2c fe ff ff       	call   80103ee0 <sched>
  panic("zombie exit");
801040b4:	83 ec 0c             	sub    $0xc,%esp
801040b7:	68 1d 7c 10 80       	push   $0x80107c1d
801040bc:	e8 cf c2 ff ff       	call   80100390 <panic>
    panic("init exiting");
801040c1:	83 ec 0c             	sub    $0xc,%esp
801040c4:	68 10 7c 10 80       	push   $0x80107c10
801040c9:	e8 c2 c2 ff ff       	call   80100390 <panic>
801040ce:	66 90                	xchg   %ax,%ax

801040d0 <yield>:
{
801040d0:	55                   	push   %ebp
801040d1:	89 e5                	mov    %esp,%ebp
801040d3:	53                   	push   %ebx
801040d4:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
801040d7:	68 80 3f 11 80       	push   $0x80113f80
801040dc:	e8 7f 08 00 00       	call   80104960 <acquire>
  pushcli();
801040e1:	e8 aa 07 00 00       	call   80104890 <pushcli>
  c = mycpu();
801040e6:	e8 25 f8 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801040eb:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801040f1:	e8 da 07 00 00       	call   801048d0 <popcli>
  myproc()->state = RUNNABLE;
801040f6:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
801040fd:	e8 de fd ff ff       	call   80103ee0 <sched>
  release(&ptable.lock);
80104102:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
80104109:	e8 12 09 00 00       	call   80104a20 <release>
}
8010410e:	83 c4 10             	add    $0x10,%esp
80104111:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104114:	c9                   	leave  
80104115:	c3                   	ret    
80104116:	8d 76 00             	lea    0x0(%esi),%esi
80104119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104120 <sleep>:
{
80104120:	55                   	push   %ebp
80104121:	89 e5                	mov    %esp,%ebp
80104123:	57                   	push   %edi
80104124:	56                   	push   %esi
80104125:	53                   	push   %ebx
80104126:	83 ec 0c             	sub    $0xc,%esp
80104129:	8b 7d 08             	mov    0x8(%ebp),%edi
8010412c:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
8010412f:	e8 5c 07 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104134:	e8 d7 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104139:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010413f:	e8 8c 07 00 00       	call   801048d0 <popcli>
  if(p == 0)
80104144:	85 db                	test   %ebx,%ebx
80104146:	0f 84 87 00 00 00    	je     801041d3 <sleep+0xb3>
  if(lk == 0)
8010414c:	85 f6                	test   %esi,%esi
8010414e:	74 76                	je     801041c6 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
80104150:	81 fe 80 3f 11 80    	cmp    $0x80113f80,%esi
80104156:	74 50                	je     801041a8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80104158:	83 ec 0c             	sub    $0xc,%esp
8010415b:	68 80 3f 11 80       	push   $0x80113f80
80104160:	e8 fb 07 00 00       	call   80104960 <acquire>
    release(lk);
80104165:	89 34 24             	mov    %esi,(%esp)
80104168:	e8 b3 08 00 00       	call   80104a20 <release>
  p->chan = chan;
8010416d:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80104170:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104177:	e8 64 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
8010417c:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104183:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
8010418a:	e8 91 08 00 00       	call   80104a20 <release>
    acquire(lk);
8010418f:	89 75 08             	mov    %esi,0x8(%ebp)
80104192:	83 c4 10             	add    $0x10,%esp
}
80104195:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104198:	5b                   	pop    %ebx
80104199:	5e                   	pop    %esi
8010419a:	5f                   	pop    %edi
8010419b:	5d                   	pop    %ebp
    acquire(lk);
8010419c:	e9 bf 07 00 00       	jmp    80104960 <acquire>
801041a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
801041a8:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801041ab:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801041b2:	e8 29 fd ff ff       	call   80103ee0 <sched>
  p->chan = 0;
801041b7:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801041be:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041c1:	5b                   	pop    %ebx
801041c2:	5e                   	pop    %esi
801041c3:	5f                   	pop    %edi
801041c4:	5d                   	pop    %ebp
801041c5:	c3                   	ret    
    panic("sleep without lk");
801041c6:	83 ec 0c             	sub    $0xc,%esp
801041c9:	68 2f 7c 10 80       	push   $0x80107c2f
801041ce:	e8 bd c1 ff ff       	call   80100390 <panic>
    panic("sleep");
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	68 29 7c 10 80       	push   $0x80107c29
801041db:	e8 b0 c1 ff ff       	call   80100390 <panic>

801041e0 <wait>:
{
801041e0:	55                   	push   %ebp
801041e1:	89 e5                	mov    %esp,%ebp
801041e3:	56                   	push   %esi
801041e4:	53                   	push   %ebx
  pushcli();
801041e5:	e8 a6 06 00 00       	call   80104890 <pushcli>
  c = mycpu();
801041ea:	e8 21 f7 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801041ef:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801041f5:	e8 d6 06 00 00       	call   801048d0 <popcli>
  acquire(&ptable.lock);
801041fa:	83 ec 0c             	sub    $0xc,%esp
801041fd:	68 80 3f 11 80       	push   $0x80113f80
80104202:	e8 59 07 00 00       	call   80104960 <acquire>
80104207:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010420a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010420c:	bb b4 3f 11 80       	mov    $0x80113fb4,%ebx
80104211:	eb 13                	jmp    80104226 <wait+0x46>
80104213:	90                   	nop
80104214:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104218:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010421e:	81 fb b4 63 11 80    	cmp    $0x801163b4,%ebx
80104224:	73 1e                	jae    80104244 <wait+0x64>
      if(p->parent != curproc)
80104226:	39 73 14             	cmp    %esi,0x14(%ebx)
80104229:	75 ed                	jne    80104218 <wait+0x38>
      if(p->state == ZOMBIE){
8010422b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010422f:	74 37                	je     80104268 <wait+0x88>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104231:	81 c3 90 00 00 00    	add    $0x90,%ebx
      havekids = 1;
80104237:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010423c:	81 fb b4 63 11 80    	cmp    $0x801163b4,%ebx
80104242:	72 e2                	jb     80104226 <wait+0x46>
    if(!havekids || curproc->killed){
80104244:	85 c0                	test   %eax,%eax
80104246:	74 79                	je     801042c1 <wait+0xe1>
80104248:	8b 46 24             	mov    0x24(%esi),%eax
8010424b:	85 c0                	test   %eax,%eax
8010424d:	75 72                	jne    801042c1 <wait+0xe1>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
8010424f:	83 ec 08             	sub    $0x8,%esp
80104252:	68 80 3f 11 80       	push   $0x80113f80
80104257:	56                   	push   %esi
80104258:	e8 c3 fe ff ff       	call   80104120 <sleep>
    havekids = 0;
8010425d:	83 c4 10             	add    $0x10,%esp
80104260:	eb a8                	jmp    8010420a <wait+0x2a>
80104262:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        kfree(p->kstack);
80104268:	83 ec 0c             	sub    $0xc,%esp
8010426b:	ff 73 08             	pushl  0x8(%ebx)
        pid = p->pid;
8010426e:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80104271:	e8 4a e2 ff ff       	call   801024c0 <kfree>
        freevm(p->pgdir);
80104276:	5a                   	pop    %edx
80104277:	ff 73 04             	pushl  0x4(%ebx)
        p->kstack = 0;
8010427a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80104281:	e8 1a 30 00 00       	call   801072a0 <freevm>
        release(&ptable.lock);
80104286:	c7 04 24 80 3f 11 80 	movl   $0x80113f80,(%esp)
        p->pid = 0;
8010428d:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80104294:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
8010429b:	c6 83 80 00 00 00 00 	movb   $0x0,0x80(%ebx)
        p->killed = 0;
801042a2:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
801042a9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
801042b0:	e8 6b 07 00 00       	call   80104a20 <release>
        return pid;
801042b5:	83 c4 10             	add    $0x10,%esp
}
801042b8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801042bb:	89 f0                	mov    %esi,%eax
801042bd:	5b                   	pop    %ebx
801042be:	5e                   	pop    %esi
801042bf:	5d                   	pop    %ebp
801042c0:	c3                   	ret    
      release(&ptable.lock);
801042c1:	83 ec 0c             	sub    $0xc,%esp
      return -1;
801042c4:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
801042c9:	68 80 3f 11 80       	push   $0x80113f80
801042ce:	e8 4d 07 00 00       	call   80104a20 <release>
      return -1;
801042d3:	83 c4 10             	add    $0x10,%esp
801042d6:	eb e0                	jmp    801042b8 <wait+0xd8>
801042d8:	90                   	nop
801042d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801042e0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
801042e0:	55                   	push   %ebp
801042e1:	89 e5                	mov    %esp,%ebp
801042e3:	53                   	push   %ebx
801042e4:	83 ec 10             	sub    $0x10,%esp
801042e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
801042ea:	68 80 3f 11 80       	push   $0x80113f80
801042ef:	e8 6c 06 00 00       	call   80104960 <acquire>
801042f4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801042f7:	b8 b4 3f 11 80       	mov    $0x80113fb4,%eax
801042fc:	eb 0e                	jmp    8010430c <wakeup+0x2c>
801042fe:	66 90                	xchg   %ax,%ax
80104300:	05 90 00 00 00       	add    $0x90,%eax
80104305:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
8010430a:	73 1e                	jae    8010432a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010430c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104310:	75 ee                	jne    80104300 <wakeup+0x20>
80104312:	3b 58 20             	cmp    0x20(%eax),%ebx
80104315:	75 e9                	jne    80104300 <wakeup+0x20>
      p->state = RUNNABLE;
80104317:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010431e:	05 90 00 00 00       	add    $0x90,%eax
80104323:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
80104328:	72 e2                	jb     8010430c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
8010432a:	c7 45 08 80 3f 11 80 	movl   $0x80113f80,0x8(%ebp)
}
80104331:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104334:	c9                   	leave  
  release(&ptable.lock);
80104335:	e9 e6 06 00 00       	jmp    80104a20 <release>
8010433a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104340 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	53                   	push   %ebx
80104344:	83 ec 10             	sub    $0x10,%esp
80104347:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010434a:	68 80 3f 11 80       	push   $0x80113f80
8010434f:	e8 0c 06 00 00       	call   80104960 <acquire>
80104354:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104357:	b8 b4 3f 11 80       	mov    $0x80113fb4,%eax
8010435c:	eb 0e                	jmp    8010436c <kill+0x2c>
8010435e:	66 90                	xchg   %ax,%ax
80104360:	05 90 00 00 00       	add    $0x90,%eax
80104365:	3d b4 63 11 80       	cmp    $0x801163b4,%eax
8010436a:	73 34                	jae    801043a0 <kill+0x60>
    if(p->pid == pid){
8010436c:	39 58 10             	cmp    %ebx,0x10(%eax)
8010436f:	75 ef                	jne    80104360 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80104371:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
80104375:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
8010437c:	75 07                	jne    80104385 <kill+0x45>
        p->state = RUNNABLE;
8010437e:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	68 80 3f 11 80       	push   $0x80113f80
8010438d:	e8 8e 06 00 00       	call   80104a20 <release>
      return 0;
80104392:	83 c4 10             	add    $0x10,%esp
80104395:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80104397:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010439a:	c9                   	leave  
8010439b:	c3                   	ret    
8010439c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
801043a0:	83 ec 0c             	sub    $0xc,%esp
801043a3:	68 80 3f 11 80       	push   $0x80113f80
801043a8:	e8 73 06 00 00       	call   80104a20 <release>
  return -1;
801043ad:	83 c4 10             	add    $0x10,%esp
801043b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801043b5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b8:	c9                   	leave  
801043b9:	c3                   	ret    
801043ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801043c0 <monopolize>:
{
801043c0:	55                   	push   %ebp
801043c1:	89 e5                	mov    %esp,%ebp
801043c3:	56                   	push   %esi
801043c4:	53                   	push   %ebx
  if(password != 2017029452)
801043c5:	81 7d 08 4c 6d 39 78 	cmpl   $0x78396d4c,0x8(%ebp)
801043cc:	74 42                	je     80104410 <monopolize+0x50>
  pushcli();
801043ce:	e8 bd 04 00 00       	call   80104890 <pushcli>
  c = mycpu();
801043d3:	e8 38 f5 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801043d8:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043de:	e8 ed 04 00 00       	call   801048d0 <popcli>
    kill(myproc()->pid);
801043e3:	83 ec 0c             	sub    $0xc,%esp
801043e6:	ff 73 10             	pushl  0x10(%ebx)
801043e9:	e8 52 ff ff ff       	call   80104340 <kill>
    pushcli();
801043ee:	e8 9d 04 00 00       	call   80104890 <pushcli>
    mycpu()->isMono=0;
801043f3:	e8 18 f5 ff ff       	call   80103910 <mycpu>
    popcli();
801043f8:	83 c4 10             	add    $0x10,%esp
    mycpu()->isMono=0;
801043fb:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104402:	00 00 00 
}
80104405:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104408:	5b                   	pop    %ebx
80104409:	5e                   	pop    %esi
8010440a:	5d                   	pop    %ebp
  popcli();
8010440b:	e9 c0 04 00 00       	jmp    801048d0 <popcli>
  pushcli();
80104410:	e8 7b 04 00 00       	call   80104890 <pushcli>
  if(mycpu()->isMono == 0)//이제 독점 해줘야할떄.
80104415:	e8 f6 f4 ff ff       	call   80103910 <mycpu>
8010441a:	8b 90 b0 00 00 00    	mov    0xb0(%eax),%edx
80104420:	85 d2                	test   %edx,%edx
80104422:	0f 84 b0 00 00 00    	je     801044d8 <monopolize+0x118>
    mycpu()->isMono = 0;
80104428:	e8 e3 f4 ff ff       	call   80103910 <mycpu>
8010442d:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80104434:	00 00 00 
  pushcli();
80104437:	e8 54 04 00 00       	call   80104890 <pushcli>
  c = mycpu();
8010443c:	e8 cf f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104441:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104447:	e8 84 04 00 00       	call   801048d0 <popcli>
    myproc()->monopolize = 0;
8010444c:	c7 43 38 00 00 00 00 	movl   $0x0,0x38(%ebx)
  pushcli();
80104453:	e8 38 04 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104458:	e8 b3 f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010445d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104463:	e8 68 04 00 00       	call   801048d0 <popcli>
    myproc()->quantum = 0;
80104468:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
  pushcli();
8010446f:	e8 1c 04 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104474:	e8 97 f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104479:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010447f:	e8 4c 04 00 00       	call   801048d0 <popcli>
    myproc()->priority=0;
80104484:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
  pushcli();
8010448b:	e8 00 04 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104490:	e8 7b f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104495:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010449b:	e8 30 04 00 00       	call   801048d0 <popcli>
    if(myproc()->lev == 1)
801044a0:	83 7b 34 01          	cmpl   $0x1,0x34(%ebx)
801044a4:	0f 84 a6 00 00 00    	je     80104550 <monopolize+0x190>
  pushcli();
801044aa:	e8 e1 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
801044af:	e8 5c f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801044b4:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044ba:	e8 11 04 00 00       	call   801048d0 <popcli>
    myproc()->lev=0;
801044bf:	c7 43 34 00 00 00 00 	movl   $0x0,0x34(%ebx)
}
801044c6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801044c9:	5b                   	pop    %ebx
801044ca:	5e                   	pop    %esi
801044cb:	5d                   	pop    %ebp
  popcli();
801044cc:	e9 ff 03 00 00       	jmp    801048d0 <popcli>
801044d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    mycpu()->isMono = 1;
801044d8:	e8 33 f4 ff ff       	call   80103910 <mycpu>
801044dd:	c7 80 b0 00 00 00 01 	movl   $0x1,0xb0(%eax)
801044e4:	00 00 00 
  pushcli();
801044e7:	e8 a4 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
801044ec:	e8 1f f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801044f1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801044f7:	e8 d4 03 00 00       	call   801048d0 <popcli>
    myproc()->monopolize = 1;
801044fc:	c7 43 38 01 00 00 00 	movl   $0x1,0x38(%ebx)
  pushcli();
80104503:	e8 88 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104508:	e8 03 f4 ff ff       	call   80103910 <mycpu>
  p = c->proc;
8010450d:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104513:	e8 b8 03 00 00       	call   801048d0 <popcli>
    myproc()->quantum = 0;
80104518:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
  pushcli();
8010451f:	e8 6c 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104524:	e8 e7 f3 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104529:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
8010452f:	e8 9c 03 00 00       	call   801048d0 <popcli>
    myproc()->priority=0;
80104534:	c7 43 30 00 00 00 00 	movl   $0x0,0x30(%ebx)
}
8010453b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010453e:	5b                   	pop    %ebx
8010453f:	5e                   	pop    %esi
80104540:	5d                   	pop    %ebp
  popcli();
80104541:	e9 8a 03 00 00       	jmp    801048d0 <popcli>
80104546:	8d 76 00             	lea    0x0(%esi),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
        for(i = 0; i < l1.count; i++)
80104550:	a1 c0 b6 10 80       	mov    0x8010b6c0,%eax
80104555:	31 db                	xor    %ebx,%ebx
80104557:	85 c0                	test   %eax,%eax
80104559:	7f 10                	jg     8010456b <monopolize+0x1ab>
8010455b:	eb 32                	jmp    8010458f <monopolize+0x1cf>
8010455d:	8d 76 00             	lea    0x0(%esi),%esi
80104560:	83 c3 01             	add    $0x1,%ebx
80104563:	39 1d c0 b6 10 80    	cmp    %ebx,0x8010b6c0
80104569:	7e 24                	jle    8010458f <monopolize+0x1cf>
  pushcli();
8010456b:	e8 20 03 00 00       	call   80104890 <pushcli>
  c = mycpu();
80104570:	e8 9b f3 ff ff       	call   80103910 <mycpu>
  p = c->proc;
80104575:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
8010457b:	e8 50 03 00 00       	call   801048d0 <popcli>
            if(myproc()->pid == l1.q[i]->pid)
80104580:	8b 04 9d c0 b5 10 80 	mov    -0x7fef4a40(,%ebx,4),%eax
80104587:	8b 40 10             	mov    0x10(%eax),%eax
8010458a:	39 46 10             	cmp    %eax,0x10(%esi)
8010458d:	75 d1                	jne    80104560 <monopolize+0x1a0>
        l1.q[i] = 0;
8010458f:	c7 04 9d c0 b5 10 80 	movl   $0x0,-0x7fef4a40(,%ebx,4)
80104596:	00 00 00 00 
  pushcli();
8010459a:	e8 f1 02 00 00       	call   80104890 <pushcli>
  c = mycpu();
8010459f:	e8 6c f3 ff ff       	call   80103910 <mycpu>
  p = c->proc;
801045a4:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
801045aa:	e8 21 03 00 00       	call   801048d0 <popcli>
  Q->q[Q->count] = p;
801045af:	a1 e0 b7 10 80       	mov    0x8010b7e0,%eax
        for(int j = i; j < l1.count; j ++)
801045b4:	8b 0d c0 b6 10 80    	mov    0x8010b6c0,%ecx
  Q->q[Q->count] = p;
801045ba:	89 34 85 e0 b6 10 80 	mov    %esi,-0x7fef4920(,%eax,4)
  Q->count++;
801045c1:	83 c0 01             	add    $0x1,%eax
        for(int j = i; j < l1.count; j ++)
801045c4:	39 d9                	cmp    %ebx,%ecx
  Q->count++;
801045c6:	a3 e0 b7 10 80       	mov    %eax,0x8010b7e0
        for(int j = i; j < l1.count; j ++)
801045cb:	7e 20                	jle    801045ed <monopolize+0x22d>
801045cd:	8d 04 9d c0 b5 10 80 	lea    -0x7fef4a40(,%ebx,4),%eax
801045d4:	8d 1c 8d c0 b5 10 80 	lea    -0x7fef4a40(,%ecx,4),%ebx
801045db:	90                   	nop
801045dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
            l1.q[j] = l1.q[j+1];
801045e0:	8b 50 04             	mov    0x4(%eax),%edx
801045e3:	83 c0 04             	add    $0x4,%eax
801045e6:	89 50 fc             	mov    %edx,-0x4(%eax)
        for(int j = i; j < l1.count; j ++)
801045e9:	39 d8                	cmp    %ebx,%eax
801045eb:	75 f3                	jne    801045e0 <monopolize+0x220>
        l1.q[l1.count] = 0;
801045ed:	c7 04 8d c0 b5 10 80 	movl   $0x0,-0x7fef4a40(,%ecx,4)
801045f4:	00 00 00 00 
        l1.count--;
801045f8:	83 e9 01             	sub    $0x1,%ecx
801045fb:	89 0d c0 b6 10 80    	mov    %ecx,0x8010b6c0
80104601:	e9 a4 fe ff ff       	jmp    801044aa <monopolize+0xea>
80104606:	8d 76 00             	lea    0x0(%esi),%esi
80104609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104610 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	57                   	push   %edi
80104614:	56                   	push   %esi
80104615:	53                   	push   %ebx
80104616:	8d 75 e8             	lea    -0x18(%ebp),%esi
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104619:	bb b4 3f 11 80       	mov    $0x80113fb4,%ebx
{
8010461e:	83 ec 3c             	sub    $0x3c,%esp
80104621:	eb 27                	jmp    8010464a <procdump+0x3a>
80104623:	90                   	nop
80104624:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104628:	83 ec 0c             	sub    $0xc,%esp
8010462b:	68 10 7e 10 80       	push   $0x80107e10
80104630:	e8 2b c0 ff ff       	call   80100660 <cprintf>
80104635:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104638:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010463e:	81 fb b4 63 11 80    	cmp    $0x801163b4,%ebx
80104644:	0f 83 96 00 00 00    	jae    801046e0 <procdump+0xd0>
    if(p->state == UNUSED)
8010464a:	8b 43 0c             	mov    0xc(%ebx),%eax
8010464d:	85 c0                	test   %eax,%eax
8010464f:	74 e7                	je     80104638 <procdump+0x28>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104651:	83 f8 05             	cmp    $0x5,%eax
      state = "???";
80104654:	ba 40 7c 10 80       	mov    $0x80107c40,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104659:	77 11                	ja     8010466c <procdump+0x5c>
8010465b:	8b 14 85 a0 7c 10 80 	mov    -0x7fef8360(,%eax,4),%edx
      state = "???";
80104662:	b8 40 7c 10 80       	mov    $0x80107c40,%eax
80104667:	85 d2                	test   %edx,%edx
80104669:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010466c:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
80104672:	50                   	push   %eax
80104673:	52                   	push   %edx
80104674:	ff 73 10             	pushl  0x10(%ebx)
80104677:	68 44 7c 10 80       	push   $0x80107c44
8010467c:	e8 df bf ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
80104681:	83 c4 10             	add    $0x10,%esp
80104684:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80104688:	75 9e                	jne    80104628 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
8010468a:	8d 45 c0             	lea    -0x40(%ebp),%eax
8010468d:	83 ec 08             	sub    $0x8,%esp
80104690:	8d 7d c0             	lea    -0x40(%ebp),%edi
80104693:	50                   	push   %eax
80104694:	8b 43 1c             	mov    0x1c(%ebx),%eax
80104697:	8b 40 0c             	mov    0xc(%eax),%eax
8010469a:	83 c0 08             	add    $0x8,%eax
8010469d:	50                   	push   %eax
8010469e:	e8 9d 01 00 00       	call   80104840 <getcallerpcs>
801046a3:	83 c4 10             	add    $0x10,%esp
801046a6:	8d 76 00             	lea    0x0(%esi),%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      for(i=0; i<10 && pc[i] != 0; i++)
801046b0:	8b 17                	mov    (%edi),%edx
801046b2:	85 d2                	test   %edx,%edx
801046b4:	0f 84 6e ff ff ff    	je     80104628 <procdump+0x18>
        cprintf(" %p", pc[i]);
801046ba:	83 ec 08             	sub    $0x8,%esp
801046bd:	83 c7 04             	add    $0x4,%edi
801046c0:	52                   	push   %edx
801046c1:	68 81 76 10 80       	push   $0x80107681
801046c6:	e8 95 bf ff ff       	call   80100660 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801046cb:	83 c4 10             	add    $0x10,%esp
801046ce:	39 fe                	cmp    %edi,%esi
801046d0:	75 de                	jne    801046b0 <procdump+0xa0>
801046d2:	e9 51 ff ff ff       	jmp    80104628 <procdump+0x18>
801046d7:	89 f6                	mov    %esi,%esi
801046d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }
}
801046e0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801046e3:	5b                   	pop    %ebx
801046e4:	5e                   	pop    %esi
801046e5:	5f                   	pop    %edi
801046e6:	5d                   	pop    %ebp
801046e7:	c3                   	ret    
801046e8:	66 90                	xchg   %ax,%ax
801046ea:	66 90                	xchg   %ax,%ax
801046ec:	66 90                	xchg   %ax,%ax
801046ee:	66 90                	xchg   %ax,%ax

801046f0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801046f0:	55                   	push   %ebp
801046f1:	89 e5                	mov    %esp,%ebp
801046f3:	53                   	push   %ebx
801046f4:	83 ec 0c             	sub    $0xc,%esp
801046f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801046fa:	68 b8 7c 10 80       	push   $0x80107cb8
801046ff:	8d 43 04             	lea    0x4(%ebx),%eax
80104702:	50                   	push   %eax
80104703:	e8 18 01 00 00       	call   80104820 <initlock>
  lk->name = name;
80104708:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010470b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104711:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104714:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010471b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010471e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104721:	c9                   	leave  
80104722:	c3                   	ret    
80104723:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104730 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	56                   	push   %esi
80104734:	53                   	push   %ebx
80104735:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104738:	83 ec 0c             	sub    $0xc,%esp
8010473b:	8d 73 04             	lea    0x4(%ebx),%esi
8010473e:	56                   	push   %esi
8010473f:	e8 1c 02 00 00       	call   80104960 <acquire>
  while (lk->locked) {
80104744:	8b 13                	mov    (%ebx),%edx
80104746:	83 c4 10             	add    $0x10,%esp
80104749:	85 d2                	test   %edx,%edx
8010474b:	74 16                	je     80104763 <acquiresleep+0x33>
8010474d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104750:	83 ec 08             	sub    $0x8,%esp
80104753:	56                   	push   %esi
80104754:	53                   	push   %ebx
80104755:	e8 c6 f9 ff ff       	call   80104120 <sleep>
  while (lk->locked) {
8010475a:	8b 03                	mov    (%ebx),%eax
8010475c:	83 c4 10             	add    $0x10,%esp
8010475f:	85 c0                	test   %eax,%eax
80104761:	75 ed                	jne    80104750 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104763:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104769:	e8 42 f2 ff ff       	call   801039b0 <myproc>
8010476e:	8b 40 10             	mov    0x10(%eax),%eax
80104771:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104774:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104777:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010477a:	5b                   	pop    %ebx
8010477b:	5e                   	pop    %esi
8010477c:	5d                   	pop    %ebp
  release(&lk->lk);
8010477d:	e9 9e 02 00 00       	jmp    80104a20 <release>
80104782:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104789:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104790 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80104790:	55                   	push   %ebp
80104791:	89 e5                	mov    %esp,%ebp
80104793:	56                   	push   %esi
80104794:	53                   	push   %ebx
80104795:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104798:	83 ec 0c             	sub    $0xc,%esp
8010479b:	8d 73 04             	lea    0x4(%ebx),%esi
8010479e:	56                   	push   %esi
8010479f:	e8 bc 01 00 00       	call   80104960 <acquire>
  lk->locked = 0;
801047a4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801047aa:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801047b1:	89 1c 24             	mov    %ebx,(%esp)
801047b4:	e8 27 fb ff ff       	call   801042e0 <wakeup>
  release(&lk->lk);
801047b9:	89 75 08             	mov    %esi,0x8(%ebp)
801047bc:	83 c4 10             	add    $0x10,%esp
}
801047bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047c2:	5b                   	pop    %ebx
801047c3:	5e                   	pop    %esi
801047c4:	5d                   	pop    %ebp
  release(&lk->lk);
801047c5:	e9 56 02 00 00       	jmp    80104a20 <release>
801047ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801047d0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801047d0:	55                   	push   %ebp
801047d1:	89 e5                	mov    %esp,%ebp
801047d3:	57                   	push   %edi
801047d4:	56                   	push   %esi
801047d5:	53                   	push   %ebx
801047d6:	31 ff                	xor    %edi,%edi
801047d8:	83 ec 18             	sub    $0x18,%esp
801047db:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801047de:	8d 73 04             	lea    0x4(%ebx),%esi
801047e1:	56                   	push   %esi
801047e2:	e8 79 01 00 00       	call   80104960 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801047e7:	8b 03                	mov    (%ebx),%eax
801047e9:	83 c4 10             	add    $0x10,%esp
801047ec:	85 c0                	test   %eax,%eax
801047ee:	74 13                	je     80104803 <holdingsleep+0x33>
801047f0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801047f3:	e8 b8 f1 ff ff       	call   801039b0 <myproc>
801047f8:	39 58 10             	cmp    %ebx,0x10(%eax)
801047fb:	0f 94 c0             	sete   %al
801047fe:	0f b6 c0             	movzbl %al,%eax
80104801:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
80104803:	83 ec 0c             	sub    $0xc,%esp
80104806:	56                   	push   %esi
80104807:	e8 14 02 00 00       	call   80104a20 <release>
  return r;
}
8010480c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010480f:	89 f8                	mov    %edi,%eax
80104811:	5b                   	pop    %ebx
80104812:	5e                   	pop    %esi
80104813:	5f                   	pop    %edi
80104814:	5d                   	pop    %ebp
80104815:	c3                   	ret    
80104816:	66 90                	xchg   %ax,%ax
80104818:	66 90                	xchg   %ax,%ax
8010481a:	66 90                	xchg   %ax,%ax
8010481c:	66 90                	xchg   %ax,%ax
8010481e:	66 90                	xchg   %ax,%ax

80104820 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104820:	55                   	push   %ebp
80104821:	89 e5                	mov    %esp,%ebp
80104823:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104826:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010482f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104832:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104839:	5d                   	pop    %ebp
8010483a:	c3                   	ret    
8010483b:	90                   	nop
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104840 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104840:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104841:	31 d2                	xor    %edx,%edx
{
80104843:	89 e5                	mov    %esp,%ebp
80104845:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104846:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104849:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010484c:	83 e8 08             	sub    $0x8,%eax
8010484f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104850:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104856:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010485c:	77 1a                	ja     80104878 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010485e:	8b 58 04             	mov    0x4(%eax),%ebx
80104861:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104864:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104867:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104869:	83 fa 0a             	cmp    $0xa,%edx
8010486c:	75 e2                	jne    80104850 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010486e:	5b                   	pop    %ebx
8010486f:	5d                   	pop    %ebp
80104870:	c3                   	ret    
80104871:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104878:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010487b:	83 c1 28             	add    $0x28,%ecx
8010487e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104880:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
80104886:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
80104889:	39 c1                	cmp    %eax,%ecx
8010488b:	75 f3                	jne    80104880 <getcallerpcs+0x40>
}
8010488d:	5b                   	pop    %ebx
8010488e:	5d                   	pop    %ebp
8010488f:	c3                   	ret    

80104890 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104890:	55                   	push   %ebp
80104891:	89 e5                	mov    %esp,%ebp
80104893:	53                   	push   %ebx
80104894:	83 ec 04             	sub    $0x4,%esp
80104897:	9c                   	pushf  
80104898:	5b                   	pop    %ebx
  asm volatile("cli");
80104899:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010489a:	e8 71 f0 ff ff       	call   80103910 <mycpu>
8010489f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801048a5:	85 c0                	test   %eax,%eax
801048a7:	75 11                	jne    801048ba <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
801048a9:	81 e3 00 02 00 00    	and    $0x200,%ebx
801048af:	e8 5c f0 ff ff       	call   80103910 <mycpu>
801048b4:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
801048ba:	e8 51 f0 ff ff       	call   80103910 <mycpu>
801048bf:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801048c6:	83 c4 04             	add    $0x4,%esp
801048c9:	5b                   	pop    %ebx
801048ca:	5d                   	pop    %ebp
801048cb:	c3                   	ret    
801048cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801048d0 <popcli>:

void
popcli(void)
{
801048d0:	55                   	push   %ebp
801048d1:	89 e5                	mov    %esp,%ebp
801048d3:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801048d6:	9c                   	pushf  
801048d7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801048d8:	f6 c4 02             	test   $0x2,%ah
801048db:	75 35                	jne    80104912 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801048dd:	e8 2e f0 ff ff       	call   80103910 <mycpu>
801048e2:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
801048e9:	78 34                	js     8010491f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801048eb:	e8 20 f0 ff ff       	call   80103910 <mycpu>
801048f0:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801048f6:	85 d2                	test   %edx,%edx
801048f8:	74 06                	je     80104900 <popcli+0x30>
    sti();
}
801048fa:	c9                   	leave  
801048fb:	c3                   	ret    
801048fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104900:	e8 0b f0 ff ff       	call   80103910 <mycpu>
80104905:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010490b:	85 c0                	test   %eax,%eax
8010490d:	74 eb                	je     801048fa <popcli+0x2a>
  asm volatile("sti");
8010490f:	fb                   	sti    
}
80104910:	c9                   	leave  
80104911:	c3                   	ret    
    panic("popcli - interruptible");
80104912:	83 ec 0c             	sub    $0xc,%esp
80104915:	68 c3 7c 10 80       	push   $0x80107cc3
8010491a:	e8 71 ba ff ff       	call   80100390 <panic>
    panic("popcli");
8010491f:	83 ec 0c             	sub    $0xc,%esp
80104922:	68 da 7c 10 80       	push   $0x80107cda
80104927:	e8 64 ba ff ff       	call   80100390 <panic>
8010492c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104930 <holding>:
{
80104930:	55                   	push   %ebp
80104931:	89 e5                	mov    %esp,%ebp
80104933:	56                   	push   %esi
80104934:	53                   	push   %ebx
80104935:	8b 75 08             	mov    0x8(%ebp),%esi
80104938:	31 db                	xor    %ebx,%ebx
  pushcli();
8010493a:	e8 51 ff ff ff       	call   80104890 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010493f:	8b 06                	mov    (%esi),%eax
80104941:	85 c0                	test   %eax,%eax
80104943:	74 10                	je     80104955 <holding+0x25>
80104945:	8b 5e 08             	mov    0x8(%esi),%ebx
80104948:	e8 c3 ef ff ff       	call   80103910 <mycpu>
8010494d:	39 c3                	cmp    %eax,%ebx
8010494f:	0f 94 c3             	sete   %bl
80104952:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104955:	e8 76 ff ff ff       	call   801048d0 <popcli>
}
8010495a:	89 d8                	mov    %ebx,%eax
8010495c:	5b                   	pop    %ebx
8010495d:	5e                   	pop    %esi
8010495e:	5d                   	pop    %ebp
8010495f:	c3                   	ret    

80104960 <acquire>:
{
80104960:	55                   	push   %ebp
80104961:	89 e5                	mov    %esp,%ebp
80104963:	56                   	push   %esi
80104964:	53                   	push   %ebx
  pushcli(); // Deadlock 피하기 위해서 interrupt 끔.
80104965:	e8 26 ff ff ff       	call   80104890 <pushcli>
  if(holding(lk))
8010496a:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	53                   	push   %ebx
80104971:	e8 ba ff ff ff       	call   80104930 <holding>
80104976:	83 c4 10             	add    $0x10,%esp
80104979:	85 c0                	test   %eax,%eax
8010497b:	0f 85 83 00 00 00    	jne    80104a04 <acquire+0xa4>
80104981:	89 c6                	mov    %eax,%esi
  asm volatile("lock; xchgl %0, %1" :
80104983:	ba 01 00 00 00       	mov    $0x1,%edx
80104988:	eb 09                	jmp    80104993 <acquire+0x33>
8010498a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104990:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104993:	89 d0                	mov    %edx,%eax
80104995:	f0 87 03             	lock xchg %eax,(%ebx)
  while(xchg(&lk->locked, 1) != 0)
80104998:	85 c0                	test   %eax,%eax
8010499a:	75 f4                	jne    80104990 <acquire+0x30>
  __sync_synchronize();
8010499c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
801049a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
801049a4:	e8 67 ef ff ff       	call   80103910 <mycpu>
  getcallerpcs(&lk, lk->pcs);
801049a9:	8d 53 0c             	lea    0xc(%ebx),%edx
  lk->cpu = mycpu();
801049ac:	89 43 08             	mov    %eax,0x8(%ebx)
  ebp = (uint*)v - 2;
801049af:	89 e8                	mov    %ebp,%eax
801049b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801049b8:	8d 88 00 00 00 80    	lea    -0x80000000(%eax),%ecx
801049be:	81 f9 fe ff ff 7f    	cmp    $0x7ffffffe,%ecx
801049c4:	77 1a                	ja     801049e0 <acquire+0x80>
    pcs[i] = ebp[1];     // saved %eip
801049c6:	8b 48 04             	mov    0x4(%eax),%ecx
801049c9:	89 0c b2             	mov    %ecx,(%edx,%esi,4)
  for(i = 0; i < 10; i++){
801049cc:	83 c6 01             	add    $0x1,%esi
    ebp = (uint*)ebp[0]; // saved %ebp
801049cf:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
801049d1:	83 fe 0a             	cmp    $0xa,%esi
801049d4:	75 e2                	jne    801049b8 <acquire+0x58>
}
801049d6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801049d9:	5b                   	pop    %ebx
801049da:	5e                   	pop    %esi
801049db:	5d                   	pop    %ebp
801049dc:	c3                   	ret    
801049dd:	8d 76 00             	lea    0x0(%esi),%esi
801049e0:	8d 04 b2             	lea    (%edx,%esi,4),%eax
801049e3:	83 c2 28             	add    $0x28,%edx
801049e6:	8d 76 00             	lea    0x0(%esi),%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    pcs[i] = 0;
801049f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
801049f6:	83 c0 04             	add    $0x4,%eax
  for(; i < 10; i++)
801049f9:	39 d0                	cmp    %edx,%eax
801049fb:	75 f3                	jne    801049f0 <acquire+0x90>
}
801049fd:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104a00:	5b                   	pop    %ebx
80104a01:	5e                   	pop    %esi
80104a02:	5d                   	pop    %ebp
80104a03:	c3                   	ret    
    panic("acquire");
80104a04:	83 ec 0c             	sub    $0xc,%esp
80104a07:	68 e1 7c 10 80       	push   $0x80107ce1
80104a0c:	e8 7f b9 ff ff       	call   80100390 <panic>
80104a11:	eb 0d                	jmp    80104a20 <release>
80104a13:	90                   	nop
80104a14:	90                   	nop
80104a15:	90                   	nop
80104a16:	90                   	nop
80104a17:	90                   	nop
80104a18:	90                   	nop
80104a19:	90                   	nop
80104a1a:	90                   	nop
80104a1b:	90                   	nop
80104a1c:	90                   	nop
80104a1d:	90                   	nop
80104a1e:	90                   	nop
80104a1f:	90                   	nop

80104a20 <release>:
{
80104a20:	55                   	push   %ebp
80104a21:	89 e5                	mov    %esp,%ebp
80104a23:	53                   	push   %ebx
80104a24:	83 ec 10             	sub    $0x10,%esp
80104a27:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80104a2a:	53                   	push   %ebx
80104a2b:	e8 00 ff ff ff       	call   80104930 <holding>
80104a30:	83 c4 10             	add    $0x10,%esp
80104a33:	85 c0                	test   %eax,%eax
80104a35:	74 22                	je     80104a59 <release+0x39>
  lk->pcs[0] = 0;
80104a37:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80104a3e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80104a45:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80104a4a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
80104a50:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104a53:	c9                   	leave  
  popcli();
80104a54:	e9 77 fe ff ff       	jmp    801048d0 <popcli>
    panic("release");
80104a59:	83 ec 0c             	sub    $0xc,%esp
80104a5c:	68 e9 7c 10 80       	push   $0x80107ce9
80104a61:	e8 2a b9 ff ff       	call   80100390 <panic>
80104a66:	66 90                	xchg   %ax,%ax
80104a68:	66 90                	xchg   %ax,%ax
80104a6a:	66 90                	xchg   %ax,%ax
80104a6c:	66 90                	xchg   %ax,%ax
80104a6e:	66 90                	xchg   %ax,%ax

80104a70 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	57                   	push   %edi
80104a74:	53                   	push   %ebx
80104a75:	8b 55 08             	mov    0x8(%ebp),%edx
80104a78:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80104a7b:	f6 c2 03             	test   $0x3,%dl
80104a7e:	75 05                	jne    80104a85 <memset+0x15>
80104a80:	f6 c1 03             	test   $0x3,%cl
80104a83:	74 13                	je     80104a98 <memset+0x28>
  asm volatile("cld; rep stosb" :
80104a85:	89 d7                	mov    %edx,%edi
80104a87:	8b 45 0c             	mov    0xc(%ebp),%eax
80104a8a:	fc                   	cld    
80104a8b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104a8d:	5b                   	pop    %ebx
80104a8e:	89 d0                	mov    %edx,%eax
80104a90:	5f                   	pop    %edi
80104a91:	5d                   	pop    %ebp
80104a92:	c3                   	ret    
80104a93:	90                   	nop
80104a94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c &= 0xFF;
80104a98:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80104a9c:	c1 e9 02             	shr    $0x2,%ecx
80104a9f:	89 f8                	mov    %edi,%eax
80104aa1:	89 fb                	mov    %edi,%ebx
80104aa3:	c1 e0 18             	shl    $0x18,%eax
80104aa6:	c1 e3 10             	shl    $0x10,%ebx
80104aa9:	09 d8                	or     %ebx,%eax
80104aab:	09 f8                	or     %edi,%eax
80104aad:	c1 e7 08             	shl    $0x8,%edi
80104ab0:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80104ab2:	89 d7                	mov    %edx,%edi
80104ab4:	fc                   	cld    
80104ab5:	f3 ab                	rep stos %eax,%es:(%edi)
}
80104ab7:	5b                   	pop    %ebx
80104ab8:	89 d0                	mov    %edx,%eax
80104aba:	5f                   	pop    %edi
80104abb:	5d                   	pop    %ebp
80104abc:	c3                   	ret    
80104abd:	8d 76 00             	lea    0x0(%esi),%esi

80104ac0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104ac0:	55                   	push   %ebp
80104ac1:	89 e5                	mov    %esp,%ebp
80104ac3:	57                   	push   %edi
80104ac4:	56                   	push   %esi
80104ac5:	53                   	push   %ebx
80104ac6:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104ac9:	8b 75 08             	mov    0x8(%ebp),%esi
80104acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104acf:	85 db                	test   %ebx,%ebx
80104ad1:	74 29                	je     80104afc <memcmp+0x3c>
    if(*s1 != *s2)
80104ad3:	0f b6 16             	movzbl (%esi),%edx
80104ad6:	0f b6 0f             	movzbl (%edi),%ecx
80104ad9:	38 d1                	cmp    %dl,%cl
80104adb:	75 2b                	jne    80104b08 <memcmp+0x48>
80104add:	b8 01 00 00 00       	mov    $0x1,%eax
80104ae2:	eb 14                	jmp    80104af8 <memcmp+0x38>
80104ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104ae8:	0f b6 14 06          	movzbl (%esi,%eax,1),%edx
80104aec:	83 c0 01             	add    $0x1,%eax
80104aef:	0f b6 4c 07 ff       	movzbl -0x1(%edi,%eax,1),%ecx
80104af4:	38 ca                	cmp    %cl,%dl
80104af6:	75 10                	jne    80104b08 <memcmp+0x48>
  while(n-- > 0){
80104af8:	39 d8                	cmp    %ebx,%eax
80104afa:	75 ec                	jne    80104ae8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
80104afc:	5b                   	pop    %ebx
  return 0;
80104afd:	31 c0                	xor    %eax,%eax
}
80104aff:	5e                   	pop    %esi
80104b00:	5f                   	pop    %edi
80104b01:	5d                   	pop    %ebp
80104b02:	c3                   	ret    
80104b03:	90                   	nop
80104b04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      return *s1 - *s2;
80104b08:	0f b6 c2             	movzbl %dl,%eax
}
80104b0b:	5b                   	pop    %ebx
      return *s1 - *s2;
80104b0c:	29 c8                	sub    %ecx,%eax
}
80104b0e:	5e                   	pop    %esi
80104b0f:	5f                   	pop    %edi
80104b10:	5d                   	pop    %ebp
80104b11:	c3                   	ret    
80104b12:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b20 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	56                   	push   %esi
80104b24:	53                   	push   %ebx
80104b25:	8b 45 08             	mov    0x8(%ebp),%eax
80104b28:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104b2b:	8b 75 10             	mov    0x10(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104b2e:	39 c3                	cmp    %eax,%ebx
80104b30:	73 26                	jae    80104b58 <memmove+0x38>
80104b32:	8d 0c 33             	lea    (%ebx,%esi,1),%ecx
80104b35:	39 c8                	cmp    %ecx,%eax
80104b37:	73 1f                	jae    80104b58 <memmove+0x38>
    s += n;
    d += n;
    while(n-- > 0)
80104b39:	85 f6                	test   %esi,%esi
80104b3b:	8d 56 ff             	lea    -0x1(%esi),%edx
80104b3e:	74 0f                	je     80104b4f <memmove+0x2f>
      *--d = *--s;
80104b40:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b44:	88 0c 10             	mov    %cl,(%eax,%edx,1)
    while(n-- > 0)
80104b47:	83 ea 01             	sub    $0x1,%edx
80104b4a:	83 fa ff             	cmp    $0xffffffff,%edx
80104b4d:	75 f1                	jne    80104b40 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104b4f:	5b                   	pop    %ebx
80104b50:	5e                   	pop    %esi
80104b51:	5d                   	pop    %ebp
80104b52:	c3                   	ret    
80104b53:	90                   	nop
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(n-- > 0)
80104b58:	31 d2                	xor    %edx,%edx
80104b5a:	85 f6                	test   %esi,%esi
80104b5c:	74 f1                	je     80104b4f <memmove+0x2f>
80104b5e:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
80104b60:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
80104b64:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104b67:	83 c2 01             	add    $0x1,%edx
    while(n-- > 0)
80104b6a:	39 d6                	cmp    %edx,%esi
80104b6c:	75 f2                	jne    80104b60 <memmove+0x40>
}
80104b6e:	5b                   	pop    %ebx
80104b6f:	5e                   	pop    %esi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b80 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104b83:	5d                   	pop    %ebp
  return memmove(dst, src, n);
80104b84:	eb 9a                	jmp    80104b20 <memmove>
80104b86:	8d 76 00             	lea    0x0(%esi),%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104b90 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	57                   	push   %edi
80104b94:	56                   	push   %esi
80104b95:	8b 7d 10             	mov    0x10(%ebp),%edi
80104b98:	53                   	push   %ebx
80104b99:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104b9c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
80104b9f:	85 ff                	test   %edi,%edi
80104ba1:	74 2f                	je     80104bd2 <strncmp+0x42>
80104ba3:	0f b6 01             	movzbl (%ecx),%eax
80104ba6:	0f b6 1e             	movzbl (%esi),%ebx
80104ba9:	84 c0                	test   %al,%al
80104bab:	74 37                	je     80104be4 <strncmp+0x54>
80104bad:	38 c3                	cmp    %al,%bl
80104baf:	75 33                	jne    80104be4 <strncmp+0x54>
80104bb1:	01 f7                	add    %esi,%edi
80104bb3:	eb 13                	jmp    80104bc8 <strncmp+0x38>
80104bb5:	8d 76 00             	lea    0x0(%esi),%esi
80104bb8:	0f b6 01             	movzbl (%ecx),%eax
80104bbb:	84 c0                	test   %al,%al
80104bbd:	74 21                	je     80104be0 <strncmp+0x50>
80104bbf:	0f b6 1a             	movzbl (%edx),%ebx
80104bc2:	89 d6                	mov    %edx,%esi
80104bc4:	38 d8                	cmp    %bl,%al
80104bc6:	75 1c                	jne    80104be4 <strncmp+0x54>
    n--, p++, q++;
80104bc8:	8d 56 01             	lea    0x1(%esi),%edx
80104bcb:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104bce:	39 fa                	cmp    %edi,%edx
80104bd0:	75 e6                	jne    80104bb8 <strncmp+0x28>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104bd2:	5b                   	pop    %ebx
    return 0;
80104bd3:	31 c0                	xor    %eax,%eax
}
80104bd5:	5e                   	pop    %esi
80104bd6:	5f                   	pop    %edi
80104bd7:	5d                   	pop    %ebp
80104bd8:	c3                   	ret    
80104bd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104be0:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
  return (uchar)*p - (uchar)*q;
80104be4:	29 d8                	sub    %ebx,%eax
}
80104be6:	5b                   	pop    %ebx
80104be7:	5e                   	pop    %esi
80104be8:	5f                   	pop    %edi
80104be9:	5d                   	pop    %ebp
80104bea:	c3                   	ret    
80104beb:	90                   	nop
80104bec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104bf0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	56                   	push   %esi
80104bf4:	53                   	push   %ebx
80104bf5:	8b 45 08             	mov    0x8(%ebp),%eax
80104bf8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80104bfb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104bfe:	89 c2                	mov    %eax,%edx
80104c00:	eb 19                	jmp    80104c1b <strncpy+0x2b>
80104c02:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c08:	83 c3 01             	add    $0x1,%ebx
80104c0b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
80104c0f:	83 c2 01             	add    $0x1,%edx
80104c12:	84 c9                	test   %cl,%cl
80104c14:	88 4a ff             	mov    %cl,-0x1(%edx)
80104c17:	74 09                	je     80104c22 <strncpy+0x32>
80104c19:	89 f1                	mov    %esi,%ecx
80104c1b:	85 c9                	test   %ecx,%ecx
80104c1d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104c20:	7f e6                	jg     80104c08 <strncpy+0x18>
    ;
  while(n-- > 0)
80104c22:	31 c9                	xor    %ecx,%ecx
80104c24:	85 f6                	test   %esi,%esi
80104c26:	7e 17                	jle    80104c3f <strncpy+0x4f>
80104c28:	90                   	nop
80104c29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104c30:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104c34:	89 f3                	mov    %esi,%ebx
80104c36:	83 c1 01             	add    $0x1,%ecx
80104c39:	29 cb                	sub    %ecx,%ebx
  while(n-- > 0)
80104c3b:	85 db                	test   %ebx,%ebx
80104c3d:	7f f1                	jg     80104c30 <strncpy+0x40>
  return os;
}
80104c3f:	5b                   	pop    %ebx
80104c40:	5e                   	pop    %esi
80104c41:	5d                   	pop    %ebp
80104c42:	c3                   	ret    
80104c43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c50 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104c50:	55                   	push   %ebp
80104c51:	89 e5                	mov    %esp,%ebp
80104c53:	56                   	push   %esi
80104c54:	53                   	push   %ebx
80104c55:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104c58:	8b 45 08             	mov    0x8(%ebp),%eax
80104c5b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80104c5e:	85 c9                	test   %ecx,%ecx
80104c60:	7e 26                	jle    80104c88 <safestrcpy+0x38>
80104c62:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104c66:	89 c1                	mov    %eax,%ecx
80104c68:	eb 17                	jmp    80104c81 <safestrcpy+0x31>
80104c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104c70:	83 c2 01             	add    $0x1,%edx
80104c73:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104c77:	83 c1 01             	add    $0x1,%ecx
80104c7a:	84 db                	test   %bl,%bl
80104c7c:	88 59 ff             	mov    %bl,-0x1(%ecx)
80104c7f:	74 04                	je     80104c85 <safestrcpy+0x35>
80104c81:	39 f2                	cmp    %esi,%edx
80104c83:	75 eb                	jne    80104c70 <safestrcpy+0x20>
    ;
  *s = 0;
80104c85:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104c88:	5b                   	pop    %ebx
80104c89:	5e                   	pop    %esi
80104c8a:	5d                   	pop    %ebp
80104c8b:	c3                   	ret    
80104c8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104c90 <strlen>:

int
strlen(const char *s)
{
80104c90:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104c91:	31 c0                	xor    %eax,%eax
{
80104c93:	89 e5                	mov    %esp,%ebp
80104c95:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104c98:	80 3a 00             	cmpb   $0x0,(%edx)
80104c9b:	74 0c                	je     80104ca9 <strlen+0x19>
80104c9d:	8d 76 00             	lea    0x0(%esi),%esi
80104ca0:	83 c0 01             	add    $0x1,%eax
80104ca3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104ca7:	75 f7                	jne    80104ca0 <strlen+0x10>
    ;
  return n;
}
80104ca9:	5d                   	pop    %ebp
80104caa:	c3                   	ret    

80104cab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104cab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104caf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104cb3:	55                   	push   %ebp
  pushl %ebx
80104cb4:	53                   	push   %ebx
  pushl %esi
80104cb5:	56                   	push   %esi
  pushl %edi
80104cb6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104cb7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104cb9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104cbb:	5f                   	pop    %edi
  popl %esi
80104cbc:	5e                   	pop    %esi
  popl %ebx
80104cbd:	5b                   	pop    %ebx
  popl %ebp
80104cbe:	5d                   	pop    %ebp
  ret
80104cbf:	c3                   	ret    

80104cc0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104cc0:	55                   	push   %ebp
80104cc1:	89 e5                	mov    %esp,%ebp
80104cc3:	53                   	push   %ebx
80104cc4:	83 ec 04             	sub    $0x4,%esp
80104cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104cca:	e8 e1 ec ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104ccf:	8b 00                	mov    (%eax),%eax
80104cd1:	39 d8                	cmp    %ebx,%eax
80104cd3:	76 1b                	jbe    80104cf0 <fetchint+0x30>
80104cd5:	8d 53 04             	lea    0x4(%ebx),%edx
80104cd8:	39 d0                	cmp    %edx,%eax
80104cda:	72 14                	jb     80104cf0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104cdc:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cdf:	8b 13                	mov    (%ebx),%edx
80104ce1:	89 10                	mov    %edx,(%eax)
  return 0;
80104ce3:	31 c0                	xor    %eax,%eax
}
80104ce5:	83 c4 04             	add    $0x4,%esp
80104ce8:	5b                   	pop    %ebx
80104ce9:	5d                   	pop    %ebp
80104cea:	c3                   	ret    
80104ceb:	90                   	nop
80104cec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cf0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf5:	eb ee                	jmp    80104ce5 <fetchint+0x25>
80104cf7:	89 f6                	mov    %esi,%esi
80104cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104d00 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104d00:	55                   	push   %ebp
80104d01:	89 e5                	mov    %esp,%ebp
80104d03:	53                   	push   %ebx
80104d04:	83 ec 04             	sub    $0x4,%esp
80104d07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104d0a:	e8 a1 ec ff ff       	call   801039b0 <myproc>

  if(addr >= curproc->sz)
80104d0f:	39 18                	cmp    %ebx,(%eax)
80104d11:	76 29                	jbe    80104d3c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104d13:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104d16:	89 da                	mov    %ebx,%edx
80104d18:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
80104d1a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
80104d1c:	39 c3                	cmp    %eax,%ebx
80104d1e:	73 1c                	jae    80104d3c <fetchstr+0x3c>
    if(*s == 0)
80104d20:	80 3b 00             	cmpb   $0x0,(%ebx)
80104d23:	75 10                	jne    80104d35 <fetchstr+0x35>
80104d25:	eb 39                	jmp    80104d60 <fetchstr+0x60>
80104d27:	89 f6                	mov    %esi,%esi
80104d29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d30:	80 3a 00             	cmpb   $0x0,(%edx)
80104d33:	74 1b                	je     80104d50 <fetchstr+0x50>
  for(s = *pp; s < ep; s++){
80104d35:	83 c2 01             	add    $0x1,%edx
80104d38:	39 d0                	cmp    %edx,%eax
80104d3a:	77 f4                	ja     80104d30 <fetchstr+0x30>
    return -1;
80104d3c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return s - *pp;
  }
  return -1;
}
80104d41:	83 c4 04             	add    $0x4,%esp
80104d44:	5b                   	pop    %ebx
80104d45:	5d                   	pop    %ebp
80104d46:	c3                   	ret    
80104d47:	89 f6                	mov    %esi,%esi
80104d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104d50:	83 c4 04             	add    $0x4,%esp
80104d53:	89 d0                	mov    %edx,%eax
80104d55:	29 d8                	sub    %ebx,%eax
80104d57:	5b                   	pop    %ebx
80104d58:	5d                   	pop    %ebp
80104d59:	c3                   	ret    
80104d5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(*s == 0)
80104d60:	31 c0                	xor    %eax,%eax
      return s - *pp;
80104d62:	eb dd                	jmp    80104d41 <fetchstr+0x41>
80104d64:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104d6a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104d70 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104d70:	55                   	push   %ebp
80104d71:	89 e5                	mov    %esp,%ebp
80104d73:	56                   	push   %esi
80104d74:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d75:	e8 36 ec ff ff       	call   801039b0 <myproc>
80104d7a:	8b 40 18             	mov    0x18(%eax),%eax
80104d7d:	8b 55 08             	mov    0x8(%ebp),%edx
80104d80:	8b 40 44             	mov    0x44(%eax),%eax
80104d83:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d86:	e8 25 ec ff ff       	call   801039b0 <myproc>
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d8b:	8b 00                	mov    (%eax),%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d8d:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d90:	39 c6                	cmp    %eax,%esi
80104d92:	73 1c                	jae    80104db0 <argint+0x40>
80104d94:	8d 53 08             	lea    0x8(%ebx),%edx
80104d97:	39 d0                	cmp    %edx,%eax
80104d99:	72 15                	jb     80104db0 <argint+0x40>
  *ip = *(int*)(addr);
80104d9b:	8b 45 0c             	mov    0xc(%ebp),%eax
80104d9e:	8b 53 04             	mov    0x4(%ebx),%edx
80104da1:	89 10                	mov    %edx,(%eax)
  return 0;
80104da3:	31 c0                	xor    %eax,%eax
}
80104da5:	5b                   	pop    %ebx
80104da6:	5e                   	pop    %esi
80104da7:	5d                   	pop    %ebp
80104da8:	c3                   	ret    
80104da9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104db5:	eb ee                	jmp    80104da5 <argint+0x35>
80104db7:	89 f6                	mov    %esi,%esi
80104db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104dc0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	56                   	push   %esi
80104dc4:	53                   	push   %ebx
80104dc5:	83 ec 10             	sub    $0x10,%esp
80104dc8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104dcb:	e8 e0 eb ff ff       	call   801039b0 <myproc>
80104dd0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104dd2:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104dd5:	83 ec 08             	sub    $0x8,%esp
80104dd8:	50                   	push   %eax
80104dd9:	ff 75 08             	pushl  0x8(%ebp)
80104ddc:	e8 8f ff ff ff       	call   80104d70 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104de1:	83 c4 10             	add    $0x10,%esp
80104de4:	85 c0                	test   %eax,%eax
80104de6:	78 28                	js     80104e10 <argptr+0x50>
80104de8:	85 db                	test   %ebx,%ebx
80104dea:	78 24                	js     80104e10 <argptr+0x50>
80104dec:	8b 16                	mov    (%esi),%edx
80104dee:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104df1:	39 c2                	cmp    %eax,%edx
80104df3:	76 1b                	jbe    80104e10 <argptr+0x50>
80104df5:	01 c3                	add    %eax,%ebx
80104df7:	39 da                	cmp    %ebx,%edx
80104df9:	72 15                	jb     80104e10 <argptr+0x50>
    return -1;
  *pp = (char*)i;
80104dfb:	8b 55 0c             	mov    0xc(%ebp),%edx
80104dfe:	89 02                	mov    %eax,(%edx)
  return 0;
80104e00:	31 c0                	xor    %eax,%eax
}
80104e02:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104e05:	5b                   	pop    %ebx
80104e06:	5e                   	pop    %esi
80104e07:	5d                   	pop    %ebp
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e15:	eb eb                	jmp    80104e02 <argptr+0x42>
80104e17:	89 f6                	mov    %esi,%esi
80104e19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e20 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104e20:	55                   	push   %ebp
80104e21:	89 e5                	mov    %esp,%ebp
80104e23:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104e26:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e29:	50                   	push   %eax
80104e2a:	ff 75 08             	pushl  0x8(%ebp)
80104e2d:	e8 3e ff ff ff       	call   80104d70 <argint>
80104e32:	83 c4 10             	add    $0x10,%esp
80104e35:	85 c0                	test   %eax,%eax
80104e37:	78 17                	js     80104e50 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104e39:	83 ec 08             	sub    $0x8,%esp
80104e3c:	ff 75 0c             	pushl  0xc(%ebp)
80104e3f:	ff 75 f4             	pushl  -0xc(%ebp)
80104e42:	e8 b9 fe ff ff       	call   80104d00 <fetchstr>
80104e47:	83 c4 10             	add    $0x10,%esp
}
80104e4a:	c9                   	leave  
80104e4b:	c3                   	ret    
80104e4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104e50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104e55:	c9                   	leave  
80104e56:	c3                   	ret    
80104e57:	89 f6                	mov    %esi,%esi
80104e59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104e60 <syscall>:
[SYS_monopolize]	sys_monopolize,
};

void
syscall(void)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	53                   	push   %ebx
80104e64:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
80104e67:	e8 44 eb ff ff       	call   801039b0 <myproc>
80104e6c:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax; // eax에 해당하는 값을 num에 대입
80104e6e:	8b 40 18             	mov    0x18(%eax),%eax
80104e71:	8b 40 1c             	mov    0x1c(%eax),%eax
//  cprintf("syscall.c num : %d\n",num);
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104e74:	8d 50 ff             	lea    -0x1(%eax),%edx
80104e77:	83 fa 1a             	cmp    $0x1a,%edx
80104e7a:	77 1c                	ja     80104e98 <syscall+0x38>
80104e7c:	8b 14 85 20 7d 10 80 	mov    -0x7fef82e0(,%eax,4),%edx
80104e83:	85 d2                	test   %edx,%edx
80104e85:	74 11                	je     80104e98 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();//syscalls 함수의 num번째를 실행하게 한다.
80104e87:	ff d2                	call   *%edx
80104e89:	8b 53 18             	mov    0x18(%ebx),%edx
80104e8c:	89 42 1c             	mov    %eax,0x1c(%edx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104e8f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e92:	c9                   	leave  
80104e93:	c3                   	ret    
80104e94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e98:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104e99:	8d 83 80 00 00 00    	lea    0x80(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e9f:	50                   	push   %eax
80104ea0:	ff 73 10             	pushl  0x10(%ebx)
80104ea3:	68 f1 7c 10 80       	push   $0x80107cf1
80104ea8:	e8 b3 b7 ff ff       	call   80100660 <cprintf>
    curproc->tf->eax = -1;
80104ead:	8b 43 18             	mov    0x18(%ebx),%eax
80104eb0:	83 c4 10             	add    $0x10,%esp
80104eb3:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104eba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ebd:	c9                   	leave  
80104ebe:	c3                   	ret    
80104ebf:	90                   	nop

80104ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104ec0:	55                   	push   %ebp
80104ec1:	89 e5                	mov    %esp,%ebp
80104ec3:	57                   	push   %edi
80104ec4:	56                   	push   %esi
80104ec5:	53                   	push   %ebx
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104ec6:	8d 75 da             	lea    -0x26(%ebp),%esi
{
80104ec9:	83 ec 34             	sub    $0x34,%esp
80104ecc:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104ecf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104ed2:	56                   	push   %esi
80104ed3:	50                   	push   %eax
{
80104ed4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104ed7:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104eda:	e8 d1 d1 ff ff       	call   801020b0 <nameiparent>
80104edf:	83 c4 10             	add    $0x10,%esp
80104ee2:	85 c0                	test   %eax,%eax
80104ee4:	0f 84 46 01 00 00    	je     80105030 <create+0x170>
    return 0;
  ilock(dp);
80104eea:	83 ec 0c             	sub    $0xc,%esp
80104eed:	89 c3                	mov    %eax,%ebx
80104eef:	50                   	push   %eax
80104ef0:	e8 8b c8 ff ff       	call   80101780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104ef5:	83 c4 0c             	add    $0xc,%esp
80104ef8:	6a 00                	push   $0x0
80104efa:	56                   	push   %esi
80104efb:	53                   	push   %ebx
80104efc:	e8 5f ce ff ff       	call   80101d60 <dirlookup>
80104f01:	83 c4 10             	add    $0x10,%esp
80104f04:	85 c0                	test   %eax,%eax
80104f06:	89 c7                	mov    %eax,%edi
80104f08:	74 36                	je     80104f40 <create+0x80>
    iunlockput(dp);
80104f0a:	83 ec 0c             	sub    $0xc,%esp
80104f0d:	53                   	push   %ebx
80104f0e:	e8 ad cb ff ff       	call   80101ac0 <iunlockput>
    ilock(ip);
80104f13:	89 3c 24             	mov    %edi,(%esp)
80104f16:	e8 65 c8 ff ff       	call   80101780 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104f1b:	83 c4 10             	add    $0x10,%esp
80104f1e:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104f23:	0f 85 97 00 00 00    	jne    80104fc0 <create+0x100>
80104f29:	66 83 7f 50 02       	cmpw   $0x2,0x50(%edi)
80104f2e:	0f 85 8c 00 00 00    	jne    80104fc0 <create+0x100>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104f34:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f37:	89 f8                	mov    %edi,%eax
80104f39:	5b                   	pop    %ebx
80104f3a:	5e                   	pop    %esi
80104f3b:	5f                   	pop    %edi
80104f3c:	5d                   	pop    %ebp
80104f3d:	c3                   	ret    
80104f3e:	66 90                	xchg   %ax,%ax
  if((ip = ialloc(dp->dev, type)) == 0)
80104f40:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f44:	83 ec 08             	sub    $0x8,%esp
80104f47:	50                   	push   %eax
80104f48:	ff 33                	pushl  (%ebx)
80104f4a:	e8 c1 c6 ff ff       	call   80101610 <ialloc>
80104f4f:	83 c4 10             	add    $0x10,%esp
80104f52:	85 c0                	test   %eax,%eax
80104f54:	89 c7                	mov    %eax,%edi
80104f56:	0f 84 e8 00 00 00    	je     80105044 <create+0x184>
  ilock(ip);
80104f5c:	83 ec 0c             	sub    $0xc,%esp
80104f5f:	50                   	push   %eax
80104f60:	e8 1b c8 ff ff       	call   80101780 <ilock>
  ip->major = major;
80104f65:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f69:	66 89 47 52          	mov    %ax,0x52(%edi)
  ip->minor = minor;
80104f6d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f71:	66 89 47 54          	mov    %ax,0x54(%edi)
  ip->nlink = 1;
80104f75:	b8 01 00 00 00       	mov    $0x1,%eax
80104f7a:	66 89 47 56          	mov    %ax,0x56(%edi)
  iupdate(ip);
80104f7e:	89 3c 24             	mov    %edi,(%esp)
80104f81:	e8 4a c7 ff ff       	call   801016d0 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f86:	83 c4 10             	add    $0x10,%esp
80104f89:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f8e:	74 50                	je     80104fe0 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f90:	83 ec 04             	sub    $0x4,%esp
80104f93:	ff 77 04             	pushl  0x4(%edi)
80104f96:	56                   	push   %esi
80104f97:	53                   	push   %ebx
80104f98:	e8 33 d0 ff ff       	call   80101fd0 <dirlink>
80104f9d:	83 c4 10             	add    $0x10,%esp
80104fa0:	85 c0                	test   %eax,%eax
80104fa2:	0f 88 8f 00 00 00    	js     80105037 <create+0x177>
  iunlockput(dp);
80104fa8:	83 ec 0c             	sub    $0xc,%esp
80104fab:	53                   	push   %ebx
80104fac:	e8 0f cb ff ff       	call   80101ac0 <iunlockput>
  return ip;
80104fb1:	83 c4 10             	add    $0x10,%esp
}
80104fb4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fb7:	89 f8                	mov    %edi,%eax
80104fb9:	5b                   	pop    %ebx
80104fba:	5e                   	pop    %esi
80104fbb:	5f                   	pop    %edi
80104fbc:	5d                   	pop    %ebp
80104fbd:	c3                   	ret    
80104fbe:	66 90                	xchg   %ax,%ax
    iunlockput(ip);
80104fc0:	83 ec 0c             	sub    $0xc,%esp
80104fc3:	57                   	push   %edi
    return 0;
80104fc4:	31 ff                	xor    %edi,%edi
    iunlockput(ip);
80104fc6:	e8 f5 ca ff ff       	call   80101ac0 <iunlockput>
    return 0;
80104fcb:	83 c4 10             	add    $0x10,%esp
}
80104fce:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104fd1:	89 f8                	mov    %edi,%eax
80104fd3:	5b                   	pop    %ebx
80104fd4:	5e                   	pop    %esi
80104fd5:	5f                   	pop    %edi
80104fd6:	5d                   	pop    %ebp
80104fd7:	c3                   	ret    
80104fd8:	90                   	nop
80104fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink++;  // for ".."
80104fe0:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104fe5:	83 ec 0c             	sub    $0xc,%esp
80104fe8:	53                   	push   %ebx
80104fe9:	e8 e2 c6 ff ff       	call   801016d0 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104fee:	83 c4 0c             	add    $0xc,%esp
80104ff1:	ff 77 04             	pushl  0x4(%edi)
80104ff4:	68 ac 7d 10 80       	push   $0x80107dac
80104ff9:	57                   	push   %edi
80104ffa:	e8 d1 cf ff ff       	call   80101fd0 <dirlink>
80104fff:	83 c4 10             	add    $0x10,%esp
80105002:	85 c0                	test   %eax,%eax
80105004:	78 1c                	js     80105022 <create+0x162>
80105006:	83 ec 04             	sub    $0x4,%esp
80105009:	ff 73 04             	pushl  0x4(%ebx)
8010500c:	68 ab 7d 10 80       	push   $0x80107dab
80105011:	57                   	push   %edi
80105012:	e8 b9 cf ff ff       	call   80101fd0 <dirlink>
80105017:	83 c4 10             	add    $0x10,%esp
8010501a:	85 c0                	test   %eax,%eax
8010501c:	0f 89 6e ff ff ff    	jns    80104f90 <create+0xd0>
      panic("create dots");
80105022:	83 ec 0c             	sub    $0xc,%esp
80105025:	68 9f 7d 10 80       	push   $0x80107d9f
8010502a:	e8 61 b3 ff ff       	call   80100390 <panic>
8010502f:	90                   	nop
    return 0;
80105030:	31 ff                	xor    %edi,%edi
80105032:	e9 fd fe ff ff       	jmp    80104f34 <create+0x74>
    panic("create: dirlink");
80105037:	83 ec 0c             	sub    $0xc,%esp
8010503a:	68 ae 7d 10 80       	push   $0x80107dae
8010503f:	e8 4c b3 ff ff       	call   80100390 <panic>
    panic("create: ialloc");
80105044:	83 ec 0c             	sub    $0xc,%esp
80105047:	68 90 7d 10 80       	push   $0x80107d90
8010504c:	e8 3f b3 ff ff       	call   80100390 <panic>
80105051:	eb 0d                	jmp    80105060 <argfd.constprop.0>
80105053:	90                   	nop
80105054:	90                   	nop
80105055:	90                   	nop
80105056:	90                   	nop
80105057:	90                   	nop
80105058:	90                   	nop
80105059:	90                   	nop
8010505a:	90                   	nop
8010505b:	90                   	nop
8010505c:	90                   	nop
8010505d:	90                   	nop
8010505e:	90                   	nop
8010505f:	90                   	nop

80105060 <argfd.constprop.0>:
argfd(int n, int *pfd, struct file **pf)
80105060:	55                   	push   %ebp
80105061:	89 e5                	mov    %esp,%ebp
80105063:	56                   	push   %esi
80105064:	53                   	push   %ebx
80105065:	89 c3                	mov    %eax,%ebx
  if(argint(n, &fd) < 0)
80105067:	8d 45 f4             	lea    -0xc(%ebp),%eax
argfd(int n, int *pfd, struct file **pf)
8010506a:	89 d6                	mov    %edx,%esi
8010506c:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010506f:	50                   	push   %eax
80105070:	6a 00                	push   $0x0
80105072:	e8 f9 fc ff ff       	call   80104d70 <argint>
80105077:	83 c4 10             	add    $0x10,%esp
8010507a:	85 c0                	test   %eax,%eax
8010507c:	78 2a                	js     801050a8 <argfd.constprop.0+0x48>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010507e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80105082:	77 24                	ja     801050a8 <argfd.constprop.0+0x48>
80105084:	e8 27 e9 ff ff       	call   801039b0 <myproc>
80105089:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010508c:	8b 44 90 3c          	mov    0x3c(%eax,%edx,4),%eax
80105090:	85 c0                	test   %eax,%eax
80105092:	74 14                	je     801050a8 <argfd.constprop.0+0x48>
  if(pfd)
80105094:	85 db                	test   %ebx,%ebx
80105096:	74 02                	je     8010509a <argfd.constprop.0+0x3a>
    *pfd = fd;
80105098:	89 13                	mov    %edx,(%ebx)
    *pf = f;
8010509a:	89 06                	mov    %eax,(%esi)
  return 0;
8010509c:	31 c0                	xor    %eax,%eax
}
8010509e:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050a1:	5b                   	pop    %ebx
801050a2:	5e                   	pop    %esi
801050a3:	5d                   	pop    %ebp
801050a4:	c3                   	ret    
801050a5:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
801050a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050ad:	eb ef                	jmp    8010509e <argfd.constprop.0+0x3e>
801050af:	90                   	nop

801050b0 <sys_dup>:
{
801050b0:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0)
801050b1:	31 c0                	xor    %eax,%eax
{
801050b3:	89 e5                	mov    %esp,%ebp
801050b5:	56                   	push   %esi
801050b6:	53                   	push   %ebx
  if(argfd(0, 0, &f) < 0)
801050b7:	8d 55 f4             	lea    -0xc(%ebp),%edx
{
801050ba:	83 ec 10             	sub    $0x10,%esp
  if(argfd(0, 0, &f) < 0)
801050bd:	e8 9e ff ff ff       	call   80105060 <argfd.constprop.0>
801050c2:	85 c0                	test   %eax,%eax
801050c4:	78 42                	js     80105108 <sys_dup+0x58>
  if((fd=fdalloc(f)) < 0)
801050c6:	8b 75 f4             	mov    -0xc(%ebp),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050c9:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
801050cb:	e8 e0 e8 ff ff       	call   801039b0 <myproc>
801050d0:	eb 0e                	jmp    801050e0 <sys_dup+0x30>
801050d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(fd = 0; fd < NOFILE; fd++){
801050d8:	83 c3 01             	add    $0x1,%ebx
801050db:	83 fb 10             	cmp    $0x10,%ebx
801050de:	74 28                	je     80105108 <sys_dup+0x58>
    if(curproc->ofile[fd] == 0){
801050e0:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
801050e4:	85 d2                	test   %edx,%edx
801050e6:	75 f0                	jne    801050d8 <sys_dup+0x28>
      curproc->ofile[fd] = f;
801050e8:	89 74 98 3c          	mov    %esi,0x3c(%eax,%ebx,4)
  filedup(f);
801050ec:	83 ec 0c             	sub    $0xc,%esp
801050ef:	ff 75 f4             	pushl  -0xc(%ebp)
801050f2:	e8 f9 bc ff ff       	call   80100df0 <filedup>
  return fd;
801050f7:	83 c4 10             	add    $0x10,%esp
}
801050fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050fd:	89 d8                	mov    %ebx,%eax
801050ff:	5b                   	pop    %ebx
80105100:	5e                   	pop    %esi
80105101:	5d                   	pop    %ebp
80105102:	c3                   	ret    
80105103:	90                   	nop
80105104:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105108:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
8010510b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105110:	89 d8                	mov    %ebx,%eax
80105112:	5b                   	pop    %ebx
80105113:	5e                   	pop    %esi
80105114:	5d                   	pop    %ebp
80105115:	c3                   	ret    
80105116:	8d 76 00             	lea    0x0(%esi),%esi
80105119:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105120 <sys_read>:
{
80105120:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105121:	31 c0                	xor    %eax,%eax
{
80105123:	89 e5                	mov    %esp,%ebp
80105125:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105128:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010512b:	e8 30 ff ff ff       	call   80105060 <argfd.constprop.0>
80105130:	85 c0                	test   %eax,%eax
80105132:	78 4c                	js     80105180 <sys_read+0x60>
80105134:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105137:	83 ec 08             	sub    $0x8,%esp
8010513a:	50                   	push   %eax
8010513b:	6a 02                	push   $0x2
8010513d:	e8 2e fc ff ff       	call   80104d70 <argint>
80105142:	83 c4 10             	add    $0x10,%esp
80105145:	85 c0                	test   %eax,%eax
80105147:	78 37                	js     80105180 <sys_read+0x60>
80105149:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010514c:	83 ec 04             	sub    $0x4,%esp
8010514f:	ff 75 f0             	pushl  -0x10(%ebp)
80105152:	50                   	push   %eax
80105153:	6a 01                	push   $0x1
80105155:	e8 66 fc ff ff       	call   80104dc0 <argptr>
8010515a:	83 c4 10             	add    $0x10,%esp
8010515d:	85 c0                	test   %eax,%eax
8010515f:	78 1f                	js     80105180 <sys_read+0x60>
  return fileread(f, p, n);
80105161:	83 ec 04             	sub    $0x4,%esp
80105164:	ff 75 f0             	pushl  -0x10(%ebp)
80105167:	ff 75 f4             	pushl  -0xc(%ebp)
8010516a:	ff 75 ec             	pushl  -0x14(%ebp)
8010516d:	e8 ee bd ff ff       	call   80100f60 <fileread>
80105172:	83 c4 10             	add    $0x10,%esp
}
80105175:	c9                   	leave  
80105176:	c3                   	ret    
80105177:	89 f6                	mov    %esi,%esi
80105179:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105180:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105185:	c9                   	leave  
80105186:	c3                   	ret    
80105187:	89 f6                	mov    %esi,%esi
80105189:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105190 <sys_write>:
{
80105190:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105191:	31 c0                	xor    %eax,%eax
{
80105193:	89 e5                	mov    %esp,%ebp
80105195:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105198:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010519b:	e8 c0 fe ff ff       	call   80105060 <argfd.constprop.0>
801051a0:	85 c0                	test   %eax,%eax
801051a2:	78 4c                	js     801051f0 <sys_write+0x60>
801051a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051a7:	83 ec 08             	sub    $0x8,%esp
801051aa:	50                   	push   %eax
801051ab:	6a 02                	push   $0x2
801051ad:	e8 be fb ff ff       	call   80104d70 <argint>
801051b2:	83 c4 10             	add    $0x10,%esp
801051b5:	85 c0                	test   %eax,%eax
801051b7:	78 37                	js     801051f0 <sys_write+0x60>
801051b9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051bc:	83 ec 04             	sub    $0x4,%esp
801051bf:	ff 75 f0             	pushl  -0x10(%ebp)
801051c2:	50                   	push   %eax
801051c3:	6a 01                	push   $0x1
801051c5:	e8 f6 fb ff ff       	call   80104dc0 <argptr>
801051ca:	83 c4 10             	add    $0x10,%esp
801051cd:	85 c0                	test   %eax,%eax
801051cf:	78 1f                	js     801051f0 <sys_write+0x60>
  return filewrite(f, p, n);
801051d1:	83 ec 04             	sub    $0x4,%esp
801051d4:	ff 75 f0             	pushl  -0x10(%ebp)
801051d7:	ff 75 f4             	pushl  -0xc(%ebp)
801051da:	ff 75 ec             	pushl  -0x14(%ebp)
801051dd:	e8 0e be ff ff       	call   80100ff0 <filewrite>
801051e2:	83 c4 10             	add    $0x10,%esp
}
801051e5:	c9                   	leave  
801051e6:	c3                   	ret    
801051e7:	89 f6                	mov    %esi,%esi
801051e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
801051f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801051f5:	c9                   	leave  
801051f6:	c3                   	ret    
801051f7:	89 f6                	mov    %esi,%esi
801051f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105200 <sys_close>:
{
80105200:	55                   	push   %ebp
80105201:	89 e5                	mov    %esp,%ebp
80105203:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, &fd, &f) < 0)
80105206:	8d 55 f4             	lea    -0xc(%ebp),%edx
80105209:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010520c:	e8 4f fe ff ff       	call   80105060 <argfd.constprop.0>
80105211:	85 c0                	test   %eax,%eax
80105213:	78 2b                	js     80105240 <sys_close+0x40>
  myproc()->ofile[fd] = 0;
80105215:	e8 96 e7 ff ff       	call   801039b0 <myproc>
8010521a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
8010521d:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
80105220:	c7 44 90 3c 00 00 00 	movl   $0x0,0x3c(%eax,%edx,4)
80105227:	00 
  fileclose(f);
80105228:	ff 75 f4             	pushl  -0xc(%ebp)
8010522b:	e8 10 bc ff ff       	call   80100e40 <fileclose>
  return 0;
80105230:	83 c4 10             	add    $0x10,%esp
80105233:	31 c0                	xor    %eax,%eax
}
80105235:	c9                   	leave  
80105236:	c3                   	ret    
80105237:	89 f6                	mov    %esi,%esi
80105239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
80105240:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105245:	c9                   	leave  
80105246:	c3                   	ret    
80105247:	89 f6                	mov    %esi,%esi
80105249:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105250 <sys_fstat>:
{
80105250:	55                   	push   %ebp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105251:	31 c0                	xor    %eax,%eax
{
80105253:	89 e5                	mov    %esp,%ebp
80105255:	83 ec 18             	sub    $0x18,%esp
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105258:	8d 55 f0             	lea    -0x10(%ebp),%edx
8010525b:	e8 00 fe ff ff       	call   80105060 <argfd.constprop.0>
80105260:	85 c0                	test   %eax,%eax
80105262:	78 2c                	js     80105290 <sys_fstat+0x40>
80105264:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105267:	83 ec 04             	sub    $0x4,%esp
8010526a:	6a 14                	push   $0x14
8010526c:	50                   	push   %eax
8010526d:	6a 01                	push   $0x1
8010526f:	e8 4c fb ff ff       	call   80104dc0 <argptr>
80105274:	83 c4 10             	add    $0x10,%esp
80105277:	85 c0                	test   %eax,%eax
80105279:	78 15                	js     80105290 <sys_fstat+0x40>
  return filestat(f, st);
8010527b:	83 ec 08             	sub    $0x8,%esp
8010527e:	ff 75 f4             	pushl  -0xc(%ebp)
80105281:	ff 75 f0             	pushl  -0x10(%ebp)
80105284:	e8 87 bc ff ff       	call   80100f10 <filestat>
80105289:	83 c4 10             	add    $0x10,%esp
}
8010528c:	c9                   	leave  
8010528d:	c3                   	ret    
8010528e:	66 90                	xchg   %ax,%ax
    return -1;
80105290:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105295:	c9                   	leave  
80105296:	c3                   	ret    
80105297:	89 f6                	mov    %esi,%esi
80105299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052a0 <sys_link>:
{
801052a0:	55                   	push   %ebp
801052a1:	89 e5                	mov    %esp,%ebp
801052a3:	57                   	push   %edi
801052a4:	56                   	push   %esi
801052a5:	53                   	push   %ebx
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052a6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
801052a9:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
801052ac:	50                   	push   %eax
801052ad:	6a 00                	push   $0x0
801052af:	e8 6c fb ff ff       	call   80104e20 <argstr>
801052b4:	83 c4 10             	add    $0x10,%esp
801052b7:	85 c0                	test   %eax,%eax
801052b9:	0f 88 fb 00 00 00    	js     801053ba <sys_link+0x11a>
801052bf:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052c2:	83 ec 08             	sub    $0x8,%esp
801052c5:	50                   	push   %eax
801052c6:	6a 01                	push   $0x1
801052c8:	e8 53 fb ff ff       	call   80104e20 <argstr>
801052cd:	83 c4 10             	add    $0x10,%esp
801052d0:	85 c0                	test   %eax,%eax
801052d2:	0f 88 e2 00 00 00    	js     801053ba <sys_link+0x11a>
  begin_op();
801052d8:	e8 73 da ff ff       	call   80102d50 <begin_op>
  if((ip = namei(old)) == 0){
801052dd:	83 ec 0c             	sub    $0xc,%esp
801052e0:	ff 75 d4             	pushl  -0x2c(%ebp)
801052e3:	e8 a8 cd ff ff       	call   80102090 <namei>
801052e8:	83 c4 10             	add    $0x10,%esp
801052eb:	85 c0                	test   %eax,%eax
801052ed:	89 c3                	mov    %eax,%ebx
801052ef:	0f 84 ea 00 00 00    	je     801053df <sys_link+0x13f>
  ilock(ip);
801052f5:	83 ec 0c             	sub    $0xc,%esp
801052f8:	50                   	push   %eax
801052f9:	e8 82 c4 ff ff       	call   80101780 <ilock>
  if(ip->type == T_DIR){
801052fe:	83 c4 10             	add    $0x10,%esp
80105301:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105306:	0f 84 bb 00 00 00    	je     801053c7 <sys_link+0x127>
  ip->nlink++;
8010530c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80105311:	83 ec 0c             	sub    $0xc,%esp
  if((dp = nameiparent(new, name)) == 0)
80105314:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105317:	53                   	push   %ebx
80105318:	e8 b3 c3 ff ff       	call   801016d0 <iupdate>
  iunlock(ip);
8010531d:	89 1c 24             	mov    %ebx,(%esp)
80105320:	e8 3b c5 ff ff       	call   80101860 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105325:	58                   	pop    %eax
80105326:	5a                   	pop    %edx
80105327:	57                   	push   %edi
80105328:	ff 75 d0             	pushl  -0x30(%ebp)
8010532b:	e8 80 cd ff ff       	call   801020b0 <nameiparent>
80105330:	83 c4 10             	add    $0x10,%esp
80105333:	85 c0                	test   %eax,%eax
80105335:	89 c6                	mov    %eax,%esi
80105337:	74 5b                	je     80105394 <sys_link+0xf4>
  ilock(dp);
80105339:	83 ec 0c             	sub    $0xc,%esp
8010533c:	50                   	push   %eax
8010533d:	e8 3e c4 ff ff       	call   80101780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105342:	83 c4 10             	add    $0x10,%esp
80105345:	8b 03                	mov    (%ebx),%eax
80105347:	39 06                	cmp    %eax,(%esi)
80105349:	75 3d                	jne    80105388 <sys_link+0xe8>
8010534b:	83 ec 04             	sub    $0x4,%esp
8010534e:	ff 73 04             	pushl  0x4(%ebx)
80105351:	57                   	push   %edi
80105352:	56                   	push   %esi
80105353:	e8 78 cc ff ff       	call   80101fd0 <dirlink>
80105358:	83 c4 10             	add    $0x10,%esp
8010535b:	85 c0                	test   %eax,%eax
8010535d:	78 29                	js     80105388 <sys_link+0xe8>
  iunlockput(dp);
8010535f:	83 ec 0c             	sub    $0xc,%esp
80105362:	56                   	push   %esi
80105363:	e8 58 c7 ff ff       	call   80101ac0 <iunlockput>
  iput(ip);
80105368:	89 1c 24             	mov    %ebx,(%esp)
8010536b:	e8 40 c5 ff ff       	call   801018b0 <iput>
  end_op();
80105370:	e8 4b da ff ff       	call   80102dc0 <end_op>
  return 0;
80105375:	83 c4 10             	add    $0x10,%esp
80105378:	31 c0                	xor    %eax,%eax
}
8010537a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010537d:	5b                   	pop    %ebx
8010537e:	5e                   	pop    %esi
8010537f:	5f                   	pop    %edi
80105380:	5d                   	pop    %ebp
80105381:	c3                   	ret    
80105382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105388:	83 ec 0c             	sub    $0xc,%esp
8010538b:	56                   	push   %esi
8010538c:	e8 2f c7 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80105391:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105394:	83 ec 0c             	sub    $0xc,%esp
80105397:	53                   	push   %ebx
80105398:	e8 e3 c3 ff ff       	call   80101780 <ilock>
  ip->nlink--;
8010539d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801053a2:	89 1c 24             	mov    %ebx,(%esp)
801053a5:	e8 26 c3 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801053aa:	89 1c 24             	mov    %ebx,(%esp)
801053ad:	e8 0e c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801053b2:	e8 09 da ff ff       	call   80102dc0 <end_op>
  return -1;
801053b7:	83 c4 10             	add    $0x10,%esp
}
801053ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801053bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801053c2:	5b                   	pop    %ebx
801053c3:	5e                   	pop    %esi
801053c4:	5f                   	pop    %edi
801053c5:	5d                   	pop    %ebp
801053c6:	c3                   	ret    
    iunlockput(ip);
801053c7:	83 ec 0c             	sub    $0xc,%esp
801053ca:	53                   	push   %ebx
801053cb:	e8 f0 c6 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801053d0:	e8 eb d9 ff ff       	call   80102dc0 <end_op>
    return -1;
801053d5:	83 c4 10             	add    $0x10,%esp
801053d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053dd:	eb 9b                	jmp    8010537a <sys_link+0xda>
    end_op();
801053df:	e8 dc d9 ff ff       	call   80102dc0 <end_op>
    return -1;
801053e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053e9:	eb 8f                	jmp    8010537a <sys_link+0xda>
801053eb:	90                   	nop
801053ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053f0 <sys_unlink>:
{
801053f0:	55                   	push   %ebp
801053f1:	89 e5                	mov    %esp,%ebp
801053f3:	57                   	push   %edi
801053f4:	56                   	push   %esi
801053f5:	53                   	push   %ebx
  if(argstr(0, &path) < 0)
801053f6:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053f9:	83 ec 44             	sub    $0x44,%esp
  if(argstr(0, &path) < 0)
801053fc:	50                   	push   %eax
801053fd:	6a 00                	push   $0x0
801053ff:	e8 1c fa ff ff       	call   80104e20 <argstr>
80105404:	83 c4 10             	add    $0x10,%esp
80105407:	85 c0                	test   %eax,%eax
80105409:	0f 88 77 01 00 00    	js     80105586 <sys_unlink+0x196>
  if((dp = nameiparent(path, name)) == 0){
8010540f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  begin_op();
80105412:	e8 39 d9 ff ff       	call   80102d50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105417:	83 ec 08             	sub    $0x8,%esp
8010541a:	53                   	push   %ebx
8010541b:	ff 75 c0             	pushl  -0x40(%ebp)
8010541e:	e8 8d cc ff ff       	call   801020b0 <nameiparent>
80105423:	83 c4 10             	add    $0x10,%esp
80105426:	85 c0                	test   %eax,%eax
80105428:	89 c6                	mov    %eax,%esi
8010542a:	0f 84 60 01 00 00    	je     80105590 <sys_unlink+0x1a0>
  ilock(dp);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	50                   	push   %eax
80105434:	e8 47 c3 ff ff       	call   80101780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80105439:	58                   	pop    %eax
8010543a:	5a                   	pop    %edx
8010543b:	68 ac 7d 10 80       	push   $0x80107dac
80105440:	53                   	push   %ebx
80105441:	e8 fa c8 ff ff       	call   80101d40 <namecmp>
80105446:	83 c4 10             	add    $0x10,%esp
80105449:	85 c0                	test   %eax,%eax
8010544b:	0f 84 03 01 00 00    	je     80105554 <sys_unlink+0x164>
80105451:	83 ec 08             	sub    $0x8,%esp
80105454:	68 ab 7d 10 80       	push   $0x80107dab
80105459:	53                   	push   %ebx
8010545a:	e8 e1 c8 ff ff       	call   80101d40 <namecmp>
8010545f:	83 c4 10             	add    $0x10,%esp
80105462:	85 c0                	test   %eax,%eax
80105464:	0f 84 ea 00 00 00    	je     80105554 <sys_unlink+0x164>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010546a:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010546d:	83 ec 04             	sub    $0x4,%esp
80105470:	50                   	push   %eax
80105471:	53                   	push   %ebx
80105472:	56                   	push   %esi
80105473:	e8 e8 c8 ff ff       	call   80101d60 <dirlookup>
80105478:	83 c4 10             	add    $0x10,%esp
8010547b:	85 c0                	test   %eax,%eax
8010547d:	89 c3                	mov    %eax,%ebx
8010547f:	0f 84 cf 00 00 00    	je     80105554 <sys_unlink+0x164>
  ilock(ip);
80105485:	83 ec 0c             	sub    $0xc,%esp
80105488:	50                   	push   %eax
80105489:	e8 f2 c2 ff ff       	call   80101780 <ilock>
  if(ip->nlink < 1)
8010548e:	83 c4 10             	add    $0x10,%esp
80105491:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80105496:	0f 8e 10 01 00 00    	jle    801055ac <sys_unlink+0x1bc>
  if(ip->type == T_DIR && !isdirempty(ip)){
8010549c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054a1:	74 6d                	je     80105510 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
801054a3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054a6:	83 ec 04             	sub    $0x4,%esp
801054a9:	6a 10                	push   $0x10
801054ab:	6a 00                	push   $0x0
801054ad:	50                   	push   %eax
801054ae:	e8 bd f5 ff ff       	call   80104a70 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054b3:	8d 45 d8             	lea    -0x28(%ebp),%eax
801054b6:	6a 10                	push   $0x10
801054b8:	ff 75 c4             	pushl  -0x3c(%ebp)
801054bb:	50                   	push   %eax
801054bc:	56                   	push   %esi
801054bd:	e8 4e c7 ff ff       	call   80101c10 <writei>
801054c2:	83 c4 20             	add    $0x20,%esp
801054c5:	83 f8 10             	cmp    $0x10,%eax
801054c8:	0f 85 eb 00 00 00    	jne    801055b9 <sys_unlink+0x1c9>
  if(ip->type == T_DIR){
801054ce:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054d3:	0f 84 97 00 00 00    	je     80105570 <sys_unlink+0x180>
  iunlockput(dp);
801054d9:	83 ec 0c             	sub    $0xc,%esp
801054dc:	56                   	push   %esi
801054dd:	e8 de c5 ff ff       	call   80101ac0 <iunlockput>
  ip->nlink--;
801054e2:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054e7:	89 1c 24             	mov    %ebx,(%esp)
801054ea:	e8 e1 c1 ff ff       	call   801016d0 <iupdate>
  iunlockput(ip);
801054ef:	89 1c 24             	mov    %ebx,(%esp)
801054f2:	e8 c9 c5 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801054f7:	e8 c4 d8 ff ff       	call   80102dc0 <end_op>
  return 0;
801054fc:	83 c4 10             	add    $0x10,%esp
801054ff:	31 c0                	xor    %eax,%eax
}
80105501:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105504:	5b                   	pop    %ebx
80105505:	5e                   	pop    %esi
80105506:	5f                   	pop    %edi
80105507:	5d                   	pop    %ebp
80105508:	c3                   	ret    
80105509:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105510:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105514:	76 8d                	jbe    801054a3 <sys_unlink+0xb3>
80105516:	bf 20 00 00 00       	mov    $0x20,%edi
8010551b:	eb 0f                	jmp    8010552c <sys_unlink+0x13c>
8010551d:	8d 76 00             	lea    0x0(%esi),%esi
80105520:	83 c7 10             	add    $0x10,%edi
80105523:	3b 7b 58             	cmp    0x58(%ebx),%edi
80105526:	0f 83 77 ff ff ff    	jae    801054a3 <sys_unlink+0xb3>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
8010552c:	8d 45 d8             	lea    -0x28(%ebp),%eax
8010552f:	6a 10                	push   $0x10
80105531:	57                   	push   %edi
80105532:	50                   	push   %eax
80105533:	53                   	push   %ebx
80105534:	e8 d7 c5 ff ff       	call   80101b10 <readi>
80105539:	83 c4 10             	add    $0x10,%esp
8010553c:	83 f8 10             	cmp    $0x10,%eax
8010553f:	75 5e                	jne    8010559f <sys_unlink+0x1af>
    if(de.inum != 0)
80105541:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80105546:	74 d8                	je     80105520 <sys_unlink+0x130>
    iunlockput(ip);
80105548:	83 ec 0c             	sub    $0xc,%esp
8010554b:	53                   	push   %ebx
8010554c:	e8 6f c5 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80105551:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
80105554:	83 ec 0c             	sub    $0xc,%esp
80105557:	56                   	push   %esi
80105558:	e8 63 c5 ff ff       	call   80101ac0 <iunlockput>
  end_op();
8010555d:	e8 5e d8 ff ff       	call   80102dc0 <end_op>
  return -1;
80105562:	83 c4 10             	add    $0x10,%esp
80105565:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010556a:	eb 95                	jmp    80105501 <sys_unlink+0x111>
8010556c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    dp->nlink--;
80105570:	66 83 6e 56 01       	subw   $0x1,0x56(%esi)
    iupdate(dp);
80105575:	83 ec 0c             	sub    $0xc,%esp
80105578:	56                   	push   %esi
80105579:	e8 52 c1 ff ff       	call   801016d0 <iupdate>
8010557e:	83 c4 10             	add    $0x10,%esp
80105581:	e9 53 ff ff ff       	jmp    801054d9 <sys_unlink+0xe9>
    return -1;
80105586:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558b:	e9 71 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
    end_op();
80105590:	e8 2b d8 ff ff       	call   80102dc0 <end_op>
    return -1;
80105595:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010559a:	e9 62 ff ff ff       	jmp    80105501 <sys_unlink+0x111>
      panic("isdirempty: readi");
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	68 d0 7d 10 80       	push   $0x80107dd0
801055a7:	e8 e4 ad ff ff       	call   80100390 <panic>
    panic("unlink: nlink < 1");
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	68 be 7d 10 80       	push   $0x80107dbe
801055b4:	e8 d7 ad ff ff       	call   80100390 <panic>
    panic("unlink: writei");
801055b9:	83 ec 0c             	sub    $0xc,%esp
801055bc:	68 e2 7d 10 80       	push   $0x80107de2
801055c1:	e8 ca ad ff ff       	call   80100390 <panic>
801055c6:	8d 76 00             	lea    0x0(%esi),%esi
801055c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055d0 <sys_open>:

int
sys_open(void)
{
801055d0:	55                   	push   %ebp
801055d1:	89 e5                	mov    %esp,%ebp
801055d3:	57                   	push   %edi
801055d4:	56                   	push   %esi
801055d5:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055d6:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055d9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055dc:	50                   	push   %eax
801055dd:	6a 00                	push   $0x0
801055df:	e8 3c f8 ff ff       	call   80104e20 <argstr>
801055e4:	83 c4 10             	add    $0x10,%esp
801055e7:	85 c0                	test   %eax,%eax
801055e9:	0f 88 1d 01 00 00    	js     8010570c <sys_open+0x13c>
801055ef:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055f2:	83 ec 08             	sub    $0x8,%esp
801055f5:	50                   	push   %eax
801055f6:	6a 01                	push   $0x1
801055f8:	e8 73 f7 ff ff       	call   80104d70 <argint>
801055fd:	83 c4 10             	add    $0x10,%esp
80105600:	85 c0                	test   %eax,%eax
80105602:	0f 88 04 01 00 00    	js     8010570c <sys_open+0x13c>
    return -1;

  begin_op();
80105608:	e8 43 d7 ff ff       	call   80102d50 <begin_op>

  if(omode & O_CREATE){
8010560d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105611:	0f 85 a9 00 00 00    	jne    801056c0 <sys_open+0xf0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	ff 75 e0             	pushl  -0x20(%ebp)
8010561d:	e8 6e ca ff ff       	call   80102090 <namei>
80105622:	83 c4 10             	add    $0x10,%esp
80105625:	85 c0                	test   %eax,%eax
80105627:	89 c6                	mov    %eax,%esi
80105629:	0f 84 b2 00 00 00    	je     801056e1 <sys_open+0x111>
      end_op();
      return -1;
    }
    ilock(ip);
8010562f:	83 ec 0c             	sub    $0xc,%esp
80105632:	50                   	push   %eax
80105633:	e8 48 c1 ff ff       	call   80101780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105638:	83 c4 10             	add    $0x10,%esp
8010563b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105640:	0f 84 aa 00 00 00    	je     801056f0 <sys_open+0x120>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105646:	e8 35 b7 ff ff       	call   80100d80 <filealloc>
8010564b:	85 c0                	test   %eax,%eax
8010564d:	89 c7                	mov    %eax,%edi
8010564f:	0f 84 a6 00 00 00    	je     801056fb <sys_open+0x12b>
  struct proc *curproc = myproc();
80105655:	e8 56 e3 ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010565a:	31 db                	xor    %ebx,%ebx
8010565c:	eb 0e                	jmp    8010566c <sys_open+0x9c>
8010565e:	66 90                	xchg   %ax,%ax
80105660:	83 c3 01             	add    $0x1,%ebx
80105663:	83 fb 10             	cmp    $0x10,%ebx
80105666:	0f 84 ac 00 00 00    	je     80105718 <sys_open+0x148>
    if(curproc->ofile[fd] == 0){
8010566c:	8b 54 98 3c          	mov    0x3c(%eax,%ebx,4),%edx
80105670:	85 d2                	test   %edx,%edx
80105672:	75 ec                	jne    80105660 <sys_open+0x90>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105674:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105677:	89 7c 98 3c          	mov    %edi,0x3c(%eax,%ebx,4)
  iunlock(ip);
8010567b:	56                   	push   %esi
8010567c:	e8 df c1 ff ff       	call   80101860 <iunlock>
  end_op();
80105681:	e8 3a d7 ff ff       	call   80102dc0 <end_op>

  f->type = FD_INODE;
80105686:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
8010568c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010568f:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
80105692:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105695:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
8010569c:	89 d0                	mov    %edx,%eax
8010569e:	f7 d0                	not    %eax
801056a0:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a3:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056a6:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056a9:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056b0:	89 d8                	mov    %ebx,%eax
801056b2:	5b                   	pop    %ebx
801056b3:	5e                   	pop    %esi
801056b4:	5f                   	pop    %edi
801056b5:	5d                   	pop    %ebp
801056b6:	c3                   	ret    
801056b7:	89 f6                	mov    %esi,%esi
801056b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ip = create(path, T_FILE, 0, 0);
801056c0:	83 ec 0c             	sub    $0xc,%esp
801056c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801056c6:	31 c9                	xor    %ecx,%ecx
801056c8:	6a 00                	push   $0x0
801056ca:	ba 02 00 00 00       	mov    $0x2,%edx
801056cf:	e8 ec f7 ff ff       	call   80104ec0 <create>
    if(ip == 0){
801056d4:	83 c4 10             	add    $0x10,%esp
801056d7:	85 c0                	test   %eax,%eax
    ip = create(path, T_FILE, 0, 0);
801056d9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801056db:	0f 85 65 ff ff ff    	jne    80105646 <sys_open+0x76>
      end_op();
801056e1:	e8 da d6 ff ff       	call   80102dc0 <end_op>
      return -1;
801056e6:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801056eb:	eb c0                	jmp    801056ad <sys_open+0xdd>
801056ed:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->type == T_DIR && omode != O_RDONLY){
801056f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056f3:	85 c9                	test   %ecx,%ecx
801056f5:	0f 84 4b ff ff ff    	je     80105646 <sys_open+0x76>
    iunlockput(ip);
801056fb:	83 ec 0c             	sub    $0xc,%esp
801056fe:	56                   	push   %esi
801056ff:	e8 bc c3 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105704:	e8 b7 d6 ff ff       	call   80102dc0 <end_op>
    return -1;
80105709:	83 c4 10             	add    $0x10,%esp
8010570c:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105711:	eb 9a                	jmp    801056ad <sys_open+0xdd>
80105713:	90                   	nop
80105714:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
80105718:	83 ec 0c             	sub    $0xc,%esp
8010571b:	57                   	push   %edi
8010571c:	e8 1f b7 ff ff       	call   80100e40 <fileclose>
80105721:	83 c4 10             	add    $0x10,%esp
80105724:	eb d5                	jmp    801056fb <sys_open+0x12b>
80105726:	8d 76 00             	lea    0x0(%esi),%esi
80105729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105730 <sys_mkdir>:

int
sys_mkdir(void)
{
80105730:	55                   	push   %ebp
80105731:	89 e5                	mov    %esp,%ebp
80105733:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105736:	e8 15 d6 ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010573b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010573e:	83 ec 08             	sub    $0x8,%esp
80105741:	50                   	push   %eax
80105742:	6a 00                	push   $0x0
80105744:	e8 d7 f6 ff ff       	call   80104e20 <argstr>
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	85 c0                	test   %eax,%eax
8010574e:	78 30                	js     80105780 <sys_mkdir+0x50>
80105750:	83 ec 0c             	sub    $0xc,%esp
80105753:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105756:	31 c9                	xor    %ecx,%ecx
80105758:	6a 00                	push   $0x0
8010575a:	ba 01 00 00 00       	mov    $0x1,%edx
8010575f:	e8 5c f7 ff ff       	call   80104ec0 <create>
80105764:	83 c4 10             	add    $0x10,%esp
80105767:	85 c0                	test   %eax,%eax
80105769:	74 15                	je     80105780 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010576b:	83 ec 0c             	sub    $0xc,%esp
8010576e:	50                   	push   %eax
8010576f:	e8 4c c3 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105774:	e8 47 d6 ff ff       	call   80102dc0 <end_op>
  return 0;
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	31 c0                	xor    %eax,%eax
}
8010577e:	c9                   	leave  
8010577f:	c3                   	ret    
    end_op();
80105780:	e8 3b d6 ff ff       	call   80102dc0 <end_op>
    return -1;
80105785:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010578a:	c9                   	leave  
8010578b:	c3                   	ret    
8010578c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105790 <sys_mknod>:

int
sys_mknod(void)
{
80105790:	55                   	push   %ebp
80105791:	89 e5                	mov    %esp,%ebp
80105793:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105796:	e8 b5 d5 ff ff       	call   80102d50 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010579b:	8d 45 ec             	lea    -0x14(%ebp),%eax
8010579e:	83 ec 08             	sub    $0x8,%esp
801057a1:	50                   	push   %eax
801057a2:	6a 00                	push   $0x0
801057a4:	e8 77 f6 ff ff       	call   80104e20 <argstr>
801057a9:	83 c4 10             	add    $0x10,%esp
801057ac:	85 c0                	test   %eax,%eax
801057ae:	78 60                	js     80105810 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801057b0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801057b3:	83 ec 08             	sub    $0x8,%esp
801057b6:	50                   	push   %eax
801057b7:	6a 01                	push   $0x1
801057b9:	e8 b2 f5 ff ff       	call   80104d70 <argint>
  if((argstr(0, &path)) < 0 ||
801057be:	83 c4 10             	add    $0x10,%esp
801057c1:	85 c0                	test   %eax,%eax
801057c3:	78 4b                	js     80105810 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
801057c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801057c8:	83 ec 08             	sub    $0x8,%esp
801057cb:	50                   	push   %eax
801057cc:	6a 02                	push   $0x2
801057ce:	e8 9d f5 ff ff       	call   80104d70 <argint>
     argint(1, &major) < 0 ||
801057d3:	83 c4 10             	add    $0x10,%esp
801057d6:	85 c0                	test   %eax,%eax
801057d8:	78 36                	js     80105810 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057da:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
     argint(2, &minor) < 0 ||
801057de:	83 ec 0c             	sub    $0xc,%esp
     (ip = create(path, T_DEV, major, minor)) == 0){
801057e1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
     argint(2, &minor) < 0 ||
801057e5:	ba 03 00 00 00       	mov    $0x3,%edx
801057ea:	50                   	push   %eax
801057eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057ee:	e8 cd f6 ff ff       	call   80104ec0 <create>
801057f3:	83 c4 10             	add    $0x10,%esp
801057f6:	85 c0                	test   %eax,%eax
801057f8:	74 16                	je     80105810 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057fa:	83 ec 0c             	sub    $0xc,%esp
801057fd:	50                   	push   %eax
801057fe:	e8 bd c2 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105803:	e8 b8 d5 ff ff       	call   80102dc0 <end_op>
  return 0;
80105808:	83 c4 10             	add    $0x10,%esp
8010580b:	31 c0                	xor    %eax,%eax
}
8010580d:	c9                   	leave  
8010580e:	c3                   	ret    
8010580f:	90                   	nop
    end_op();
80105810:	e8 ab d5 ff ff       	call   80102dc0 <end_op>
    return -1;
80105815:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010581a:	c9                   	leave  
8010581b:	c3                   	ret    
8010581c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105820 <sys_chdir>:

int
sys_chdir(void)
{
80105820:	55                   	push   %ebp
80105821:	89 e5                	mov    %esp,%ebp
80105823:	56                   	push   %esi
80105824:	53                   	push   %ebx
80105825:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105828:	e8 83 e1 ff ff       	call   801039b0 <myproc>
8010582d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010582f:	e8 1c d5 ff ff       	call   80102d50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105834:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105837:	83 ec 08             	sub    $0x8,%esp
8010583a:	50                   	push   %eax
8010583b:	6a 00                	push   $0x0
8010583d:	e8 de f5 ff ff       	call   80104e20 <argstr>
80105842:	83 c4 10             	add    $0x10,%esp
80105845:	85 c0                	test   %eax,%eax
80105847:	78 77                	js     801058c0 <sys_chdir+0xa0>
80105849:	83 ec 0c             	sub    $0xc,%esp
8010584c:	ff 75 f4             	pushl  -0xc(%ebp)
8010584f:	e8 3c c8 ff ff       	call   80102090 <namei>
80105854:	83 c4 10             	add    $0x10,%esp
80105857:	85 c0                	test   %eax,%eax
80105859:	89 c3                	mov    %eax,%ebx
8010585b:	74 63                	je     801058c0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010585d:	83 ec 0c             	sub    $0xc,%esp
80105860:	50                   	push   %eax
80105861:	e8 1a bf ff ff       	call   80101780 <ilock>
  if(ip->type != T_DIR){
80105866:	83 c4 10             	add    $0x10,%esp
80105869:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010586e:	75 30                	jne    801058a0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 e7 bf ff ff       	call   80101860 <iunlock>
  iput(curproc->cwd);
80105879:	58                   	pop    %eax
8010587a:	ff 76 7c             	pushl  0x7c(%esi)
8010587d:	e8 2e c0 ff ff       	call   801018b0 <iput>
  end_op();
80105882:	e8 39 d5 ff ff       	call   80102dc0 <end_op>
  curproc->cwd = ip;
80105887:	89 5e 7c             	mov    %ebx,0x7c(%esi)
  return 0;
8010588a:	83 c4 10             	add    $0x10,%esp
8010588d:	31 c0                	xor    %eax,%eax
}
8010588f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105892:	5b                   	pop    %ebx
80105893:	5e                   	pop    %esi
80105894:	5d                   	pop    %ebp
80105895:	c3                   	ret    
80105896:	8d 76 00             	lea    0x0(%esi),%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    iunlockput(ip);
801058a0:	83 ec 0c             	sub    $0xc,%esp
801058a3:	53                   	push   %ebx
801058a4:	e8 17 c2 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801058a9:	e8 12 d5 ff ff       	call   80102dc0 <end_op>
    return -1;
801058ae:	83 c4 10             	add    $0x10,%esp
801058b1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058b6:	eb d7                	jmp    8010588f <sys_chdir+0x6f>
801058b8:	90                   	nop
801058b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    end_op();
801058c0:	e8 fb d4 ff ff       	call   80102dc0 <end_op>
    return -1;
801058c5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801058ca:	eb c3                	jmp    8010588f <sys_chdir+0x6f>
801058cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058d0 <sys_exec>:

int
sys_exec(void)
{
801058d0:	55                   	push   %ebp
801058d1:	89 e5                	mov    %esp,%ebp
801058d3:	57                   	push   %edi
801058d4:	56                   	push   %esi
801058d5:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058d6:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058dc:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058e2:	50                   	push   %eax
801058e3:	6a 00                	push   $0x0
801058e5:	e8 36 f5 ff ff       	call   80104e20 <argstr>
801058ea:	83 c4 10             	add    $0x10,%esp
801058ed:	85 c0                	test   %eax,%eax
801058ef:	0f 88 87 00 00 00    	js     8010597c <sys_exec+0xac>
801058f5:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058fb:	83 ec 08             	sub    $0x8,%esp
801058fe:	50                   	push   %eax
801058ff:	6a 01                	push   $0x1
80105901:	e8 6a f4 ff ff       	call   80104d70 <argint>
80105906:	83 c4 10             	add    $0x10,%esp
80105909:	85 c0                	test   %eax,%eax
8010590b:	78 6f                	js     8010597c <sys_exec+0xac>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010590d:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105913:	83 ec 04             	sub    $0x4,%esp
  for(i=0;; i++){
80105916:	31 db                	xor    %ebx,%ebx
  memset(argv, 0, sizeof(argv));
80105918:	68 80 00 00 00       	push   $0x80
8010591d:	6a 00                	push   $0x0
8010591f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105925:	50                   	push   %eax
80105926:	e8 45 f1 ff ff       	call   80104a70 <memset>
8010592b:	83 c4 10             	add    $0x10,%esp
8010592e:	eb 2c                	jmp    8010595c <sys_exec+0x8c>
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
80105930:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105936:	85 c0                	test   %eax,%eax
80105938:	74 56                	je     80105990 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
8010593a:	8d 8d 68 ff ff ff    	lea    -0x98(%ebp),%ecx
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	8d 14 31             	lea    (%ecx,%esi,1),%edx
80105946:	52                   	push   %edx
80105947:	50                   	push   %eax
80105948:	e8 b3 f3 ff ff       	call   80104d00 <fetchstr>
8010594d:	83 c4 10             	add    $0x10,%esp
80105950:	85 c0                	test   %eax,%eax
80105952:	78 28                	js     8010597c <sys_exec+0xac>
  for(i=0;; i++){
80105954:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105957:	83 fb 20             	cmp    $0x20,%ebx
8010595a:	74 20                	je     8010597c <sys_exec+0xac>
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
8010595c:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105962:	8d 34 9d 00 00 00 00 	lea    0x0(,%ebx,4),%esi
80105969:	83 ec 08             	sub    $0x8,%esp
8010596c:	57                   	push   %edi
8010596d:	01 f0                	add    %esi,%eax
8010596f:	50                   	push   %eax
80105970:	e8 4b f3 ff ff       	call   80104cc0 <fetchint>
80105975:	83 c4 10             	add    $0x10,%esp
80105978:	85 c0                	test   %eax,%eax
8010597a:	79 b4                	jns    80105930 <sys_exec+0x60>
      return -1;
  }
  return exec(path, argv);
}
8010597c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return -1;
8010597f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105984:	5b                   	pop    %ebx
80105985:	5e                   	pop    %esi
80105986:	5f                   	pop    %edi
80105987:	5d                   	pop    %ebp
80105988:	c3                   	ret    
80105989:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return exec(path, argv);
80105990:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105996:	83 ec 08             	sub    $0x8,%esp
      argv[i] = 0;
80105999:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059a0:	00 00 00 00 
  return exec(path, argv);
801059a4:	50                   	push   %eax
801059a5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801059ab:	e8 60 b0 ff ff       	call   80100a10 <exec>
801059b0:	83 c4 10             	add    $0x10,%esp
}
801059b3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059b6:	5b                   	pop    %ebx
801059b7:	5e                   	pop    %esi
801059b8:	5f                   	pop    %edi
801059b9:	5d                   	pop    %ebp
801059ba:	c3                   	ret    
801059bb:	90                   	nop
801059bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801059c0 <sys_pipe>:

int
sys_pipe(void)
{
801059c0:	55                   	push   %ebp
801059c1:	89 e5                	mov    %esp,%ebp
801059c3:	57                   	push   %edi
801059c4:	56                   	push   %esi
801059c5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059c6:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059c9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059cc:	6a 08                	push   $0x8
801059ce:	50                   	push   %eax
801059cf:	6a 00                	push   $0x0
801059d1:	e8 ea f3 ff ff       	call   80104dc0 <argptr>
801059d6:	83 c4 10             	add    $0x10,%esp
801059d9:	85 c0                	test   %eax,%eax
801059db:	0f 88 ae 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801059e1:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801059e4:	83 ec 08             	sub    $0x8,%esp
801059e7:	50                   	push   %eax
801059e8:	8d 45 e0             	lea    -0x20(%ebp),%eax
801059eb:	50                   	push   %eax
801059ec:	e8 ff d9 ff ff       	call   801033f0 <pipealloc>
801059f1:	83 c4 10             	add    $0x10,%esp
801059f4:	85 c0                	test   %eax,%eax
801059f6:	0f 88 93 00 00 00    	js     80105a8f <sys_pipe+0xcf>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801059fc:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
801059ff:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a01:	e8 aa df ff ff       	call   801039b0 <myproc>
80105a06:	eb 10                	jmp    80105a18 <sys_pipe+0x58>
80105a08:	90                   	nop
80105a09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(fd = 0; fd < NOFILE; fd++){
80105a10:	83 c3 01             	add    $0x1,%ebx
80105a13:	83 fb 10             	cmp    $0x10,%ebx
80105a16:	74 60                	je     80105a78 <sys_pipe+0xb8>
    if(curproc->ofile[fd] == 0){
80105a18:	8b 74 98 3c          	mov    0x3c(%eax,%ebx,4),%esi
80105a1c:	85 f6                	test   %esi,%esi
80105a1e:	75 f0                	jne    80105a10 <sys_pipe+0x50>
      curproc->ofile[fd] = f;
80105a20:	8d 73 0c             	lea    0xc(%ebx),%esi
80105a23:	89 7c b0 0c          	mov    %edi,0xc(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a27:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a2a:	e8 81 df ff ff       	call   801039b0 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2f:	31 d2                	xor    %edx,%edx
80105a31:	eb 0d                	jmp    80105a40 <sys_pipe+0x80>
80105a33:	90                   	nop
80105a34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a38:	83 c2 01             	add    $0x1,%edx
80105a3b:	83 fa 10             	cmp    $0x10,%edx
80105a3e:	74 28                	je     80105a68 <sys_pipe+0xa8>
    if(curproc->ofile[fd] == 0){
80105a40:	8b 4c 90 3c          	mov    0x3c(%eax,%edx,4),%ecx
80105a44:	85 c9                	test   %ecx,%ecx
80105a46:	75 f0                	jne    80105a38 <sys_pipe+0x78>
      curproc->ofile[fd] = f;
80105a48:	89 7c 90 3c          	mov    %edi,0x3c(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105a4c:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a4f:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105a51:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105a54:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105a57:	31 c0                	xor    %eax,%eax
}
80105a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a5c:	5b                   	pop    %ebx
80105a5d:	5e                   	pop    %esi
80105a5e:	5f                   	pop    %edi
80105a5f:	5d                   	pop    %ebp
80105a60:	c3                   	ret    
80105a61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      myproc()->ofile[fd0] = 0;
80105a68:	e8 43 df ff ff       	call   801039b0 <myproc>
80105a6d:	c7 44 b0 0c 00 00 00 	movl   $0x0,0xc(%eax,%esi,4)
80105a74:	00 
80105a75:	8d 76 00             	lea    0x0(%esi),%esi
    fileclose(rf);
80105a78:	83 ec 0c             	sub    $0xc,%esp
80105a7b:	ff 75 e0             	pushl  -0x20(%ebp)
80105a7e:	e8 bd b3 ff ff       	call   80100e40 <fileclose>
    fileclose(wf);
80105a83:	58                   	pop    %eax
80105a84:	ff 75 e4             	pushl  -0x1c(%ebp)
80105a87:	e8 b4 b3 ff ff       	call   80100e40 <fileclose>
    return -1;
80105a8c:	83 c4 10             	add    $0x10,%esp
80105a8f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a94:	eb c3                	jmp    80105a59 <sys_pipe+0x99>
80105a96:	66 90                	xchg   %ax,%ax
80105a98:	66 90                	xchg   %ax,%ax
80105a9a:	66 90                	xchg   %ax,%ax
80105a9c:	66 90                	xchg   %ax,%ax
80105a9e:	66 90                	xchg   %ax,%ax

80105aa0 <sys_getlev>:
#include "mmu.h"
#include "proc.h"


int sys_getlev(void)
{
80105aa0:	55                   	push   %ebp
80105aa1:	89 e5                	mov    %esp,%ebp
   return getlev();
}
80105aa3:	5d                   	pop    %ebp
   return getlev();
80105aa4:	e9 67 e1 ff ff       	jmp    80103c10 <getlev>
80105aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105ab0 <sys_setpriority>:

int sys_setpriority(void)
{
80105ab0:	55                   	push   %ebp
80105ab1:	89 e5                	mov    %esp,%ebp
80105ab3:	83 ec 20             	sub    $0x20,%esp
 int pid, priority;
  if(argint(0,&pid) < 0)
80105ab6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105ab9:	50                   	push   %eax
80105aba:	6a 00                	push   $0x0
80105abc:	e8 af f2 ff ff       	call   80104d70 <argint>
80105ac1:	83 c4 10             	add    $0x10,%esp
80105ac4:	85 c0                	test   %eax,%eax
80105ac6:	78 28                	js     80105af0 <sys_setpriority+0x40>
  {
     return -1;
  }

  if(argint(1, &priority) < 0)
80105ac8:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105acb:	83 ec 08             	sub    $0x8,%esp
80105ace:	50                   	push   %eax
80105acf:	6a 01                	push   $0x1
80105ad1:	e8 9a f2 ff ff       	call   80104d70 <argint>
80105ad6:	83 c4 10             	add    $0x10,%esp
80105ad9:	85 c0                	test   %eax,%eax
80105adb:	78 13                	js     80105af0 <sys_setpriority+0x40>
  {
     return -1;
  }

  return setpriority(pid, priority);
80105add:	83 ec 08             	sub    $0x8,%esp
80105ae0:	ff 75 f4             	pushl  -0xc(%ebp)
80105ae3:	ff 75 f0             	pushl  -0x10(%ebp)
80105ae6:	e8 55 e1 ff ff       	call   80103c40 <setpriority>
80105aeb:	83 c4 10             	add    $0x10,%esp
}
80105aee:	c9                   	leave  
80105aef:	c3                   	ret    
     return -1;
80105af0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105af5:	c9                   	leave  
80105af6:	c3                   	ret    
80105af7:	89 f6                	mov    %esi,%esi
80105af9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b00 <sys_monopolize>:

int sys_monopolize(void)
{
80105b00:	55                   	push   %ebp
80105b01:	89 e5                	mov    %esp,%ebp
80105b03:	83 ec 20             	sub    $0x20,%esp
  int password;
  if(argint(0, &password) <0)
80105b06:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b09:	50                   	push   %eax
80105b0a:	6a 00                	push   $0x0
80105b0c:	e8 5f f2 ff ff       	call   80104d70 <argint>
80105b11:	83 c4 10             	add    $0x10,%esp
80105b14:	85 c0                	test   %eax,%eax
80105b16:	78 18                	js     80105b30 <sys_monopolize+0x30>
  {
      return -1;
  }
  monopolize(password);
80105b18:	83 ec 0c             	sub    $0xc,%esp
80105b1b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b1e:	e8 9d e8 ff ff       	call   801043c0 <monopolize>
  return 0;
80105b23:	83 c4 10             	add    $0x10,%esp
80105b26:	31 c0                	xor    %eax,%eax
}
80105b28:	c9                   	leave  
80105b29:	c3                   	ret    
80105b2a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return -1;
80105b30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b35:	c9                   	leave  
80105b36:	c3                   	ret    
80105b37:	89 f6                	mov    %esi,%esi
80105b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105b40 <sys_yield>:

int sys_yield(void)
{	
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	83 ec 08             	sub    $0x8,%esp
   yield();
80105b46:	e8 85 e5 ff ff       	call   801040d0 <yield>
   return 0;
}
80105b4b:	31 c0                	xor    %eax,%eax
80105b4d:	c9                   	leave  
80105b4e:	c3                   	ret    
80105b4f:	90                   	nop

80105b50 <sys_fork>:

int
sys_fork(void)
{
80105b50:	55                   	push   %ebp
80105b51:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105b53:	5d                   	pop    %ebp
  return fork();
80105b54:	e9 c7 e1 ff ff       	jmp    80103d20 <fork>
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <sys_exit>:

int
sys_exit(void)
{
80105b60:	55                   	push   %ebp
80105b61:	89 e5                	mov    %esp,%ebp
80105b63:	83 ec 08             	sub    $0x8,%esp
  exit();
80105b66:	e8 35 e4 ff ff       	call   80103fa0 <exit>
  return 0;  // not reached
}
80105b6b:	31 c0                	xor    %eax,%eax
80105b6d:	c9                   	leave  
80105b6e:	c3                   	ret    
80105b6f:	90                   	nop

80105b70 <sys_wait>:

int
sys_wait(void)
{
80105b70:	55                   	push   %ebp
80105b71:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105b73:	5d                   	pop    %ebp
  return wait();
80105b74:	e9 67 e6 ff ff       	jmp    801041e0 <wait>
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b80 <sys_kill>:

int
sys_kill(void)
{
80105b80:	55                   	push   %ebp
80105b81:	89 e5                	mov    %esp,%ebp
80105b83:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105b86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105b89:	50                   	push   %eax
80105b8a:	6a 00                	push   $0x0
80105b8c:	e8 df f1 ff ff       	call   80104d70 <argint>
80105b91:	83 c4 10             	add    $0x10,%esp
80105b94:	85 c0                	test   %eax,%eax
80105b96:	78 18                	js     80105bb0 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b98:	83 ec 0c             	sub    $0xc,%esp
80105b9b:	ff 75 f4             	pushl  -0xc(%ebp)
80105b9e:	e8 9d e7 ff ff       	call   80104340 <kill>
80105ba3:	83 c4 10             	add    $0x10,%esp
}
80105ba6:	c9                   	leave  
80105ba7:	c3                   	ret    
80105ba8:	90                   	nop
80105ba9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105bb5:	c9                   	leave  
80105bb6:	c3                   	ret    
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bc0 <sys_getpid>:

int
sys_getpid(void)
{
80105bc0:	55                   	push   %ebp
80105bc1:	89 e5                	mov    %esp,%ebp
80105bc3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105bc6:	e8 e5 dd ff ff       	call   801039b0 <myproc>
80105bcb:	8b 40 10             	mov    0x10(%eax),%eax
}
80105bce:	c9                   	leave  
80105bcf:	c3                   	ret    

80105bd0 <sys_sbrk>:

int
sys_sbrk(void)
{
80105bd0:	55                   	push   %ebp
80105bd1:	89 e5                	mov    %esp,%ebp
80105bd3:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105bd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105bd7:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105bda:	50                   	push   %eax
80105bdb:	6a 00                	push   $0x0
80105bdd:	e8 8e f1 ff ff       	call   80104d70 <argint>
80105be2:	83 c4 10             	add    $0x10,%esp
80105be5:	85 c0                	test   %eax,%eax
80105be7:	78 27                	js     80105c10 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105be9:	e8 c2 dd ff ff       	call   801039b0 <myproc>
  if(growproc(n) < 0)
80105bee:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105bf1:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105bf3:	ff 75 f4             	pushl  -0xc(%ebp)
80105bf6:	e8 d5 de ff ff       	call   80103ad0 <growproc>
80105bfb:	83 c4 10             	add    $0x10,%esp
80105bfe:	85 c0                	test   %eax,%eax
80105c00:	78 0e                	js     80105c10 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105c02:	89 d8                	mov    %ebx,%eax
80105c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c07:	c9                   	leave  
80105c08:	c3                   	ret    
80105c09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105c10:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105c15:	eb eb                	jmp    80105c02 <sys_sbrk+0x32>
80105c17:	89 f6                	mov    %esi,%esi
80105c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c20 <sys_sleep>:

int
sys_sleep(void)
{
80105c20:	55                   	push   %ebp
80105c21:	89 e5                	mov    %esp,%ebp
80105c23:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105c24:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105c27:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105c2a:	50                   	push   %eax
80105c2b:	6a 00                	push   $0x0
80105c2d:	e8 3e f1 ff ff       	call   80104d70 <argint>
80105c32:	83 c4 10             	add    $0x10,%esp
80105c35:	85 c0                	test   %eax,%eax
80105c37:	0f 88 8a 00 00 00    	js     80105cc7 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105c3d:	83 ec 0c             	sub    $0xc,%esp
80105c40:	68 c0 63 11 80       	push   $0x801163c0
80105c45:	e8 16 ed ff ff       	call   80104960 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105c4d:	83 c4 10             	add    $0x10,%esp
  ticks0 = ticks;
80105c50:	8b 1d 00 6c 11 80    	mov    0x80116c00,%ebx
  while(ticks - ticks0 < n){
80105c56:	85 d2                	test   %edx,%edx
80105c58:	75 27                	jne    80105c81 <sys_sleep+0x61>
80105c5a:	eb 54                	jmp    80105cb0 <sys_sleep+0x90>
80105c5c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105c60:	83 ec 08             	sub    $0x8,%esp
80105c63:	68 c0 63 11 80       	push   $0x801163c0
80105c68:	68 00 6c 11 80       	push   $0x80116c00
80105c6d:	e8 ae e4 ff ff       	call   80104120 <sleep>
  while(ticks - ticks0 < n){
80105c72:	a1 00 6c 11 80       	mov    0x80116c00,%eax
80105c77:	83 c4 10             	add    $0x10,%esp
80105c7a:	29 d8                	sub    %ebx,%eax
80105c7c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105c7f:	73 2f                	jae    80105cb0 <sys_sleep+0x90>
    if(myproc()->killed){
80105c81:	e8 2a dd ff ff       	call   801039b0 <myproc>
80105c86:	8b 40 24             	mov    0x24(%eax),%eax
80105c89:	85 c0                	test   %eax,%eax
80105c8b:	74 d3                	je     80105c60 <sys_sleep+0x40>
      release(&tickslock);
80105c8d:	83 ec 0c             	sub    $0xc,%esp
80105c90:	68 c0 63 11 80       	push   $0x801163c0
80105c95:	e8 86 ed ff ff       	call   80104a20 <release>
      return -1;
80105c9a:	83 c4 10             	add    $0x10,%esp
80105c9d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&tickslock);
  return 0;
}
80105ca2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105ca5:	c9                   	leave  
80105ca6:	c3                   	ret    
80105ca7:	89 f6                	mov    %esi,%esi
80105ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  release(&tickslock);
80105cb0:	83 ec 0c             	sub    $0xc,%esp
80105cb3:	68 c0 63 11 80       	push   $0x801163c0
80105cb8:	e8 63 ed ff ff       	call   80104a20 <release>
  return 0;
80105cbd:	83 c4 10             	add    $0x10,%esp
80105cc0:	31 c0                	xor    %eax,%eax
}
80105cc2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cc5:	c9                   	leave  
80105cc6:	c3                   	ret    
    return -1;
80105cc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105ccc:	eb f4                	jmp    80105cc2 <sys_sleep+0xa2>
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	53                   	push   %ebx
80105cd4:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105cd7:	68 c0 63 11 80       	push   $0x801163c0
80105cdc:	e8 7f ec ff ff       	call   80104960 <acquire>
  xticks = ticks;
80105ce1:	8b 1d 00 6c 11 80    	mov    0x80116c00,%ebx
  release(&tickslock);
80105ce7:	c7 04 24 c0 63 11 80 	movl   $0x801163c0,(%esp)
80105cee:	e8 2d ed ff ff       	call   80104a20 <release>
  return xticks;
}
80105cf3:	89 d8                	mov    %ebx,%eax
80105cf5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105cf8:	c9                   	leave  
80105cf9:	c3                   	ret    

80105cfa <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105cfa:	1e                   	push   %ds
  pushl %es
80105cfb:	06                   	push   %es
  pushl %fs
80105cfc:	0f a0                	push   %fs
  pushl %gs
80105cfe:	0f a8                	push   %gs
  pushal
80105d00:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105d01:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105d05:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105d07:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105d09:	54                   	push   %esp
  call trap
80105d0a:	e8 e1 00 00 00       	call   80105df0 <trap>
  addl $4, %esp
80105d0f:	83 c4 04             	add    $0x4,%esp

80105d12 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105d12:	61                   	popa   
  popl %gs
80105d13:	0f a9                	pop    %gs
  popl %fs
80105d15:	0f a1                	pop    %fs
  popl %es
80105d17:	07                   	pop    %es
  popl %ds
80105d18:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105d19:	83 c4 08             	add    $0x8,%esp
  iret
80105d1c:	cf                   	iret   
80105d1d:	66 90                	xchg   %ax,%ax
80105d1f:	90                   	nop

80105d20 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105d20:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105d21:	31 c0                	xor    %eax,%eax
{
80105d23:	89 e5                	mov    %esp,%ebp
80105d25:	83 ec 08             	sub    $0x8,%esp
80105d28:	90                   	nop
80105d29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105d30:	8b 14 85 0c b0 10 80 	mov    -0x7fef4ff4(,%eax,4),%edx
80105d37:	c7 04 c5 02 64 11 80 	movl   $0x8e000008,-0x7fee9bfe(,%eax,8)
80105d3e:	08 00 00 8e 
80105d42:	66 89 14 c5 00 64 11 	mov    %dx,-0x7fee9c00(,%eax,8)
80105d49:	80 
80105d4a:	c1 ea 10             	shr    $0x10,%edx
80105d4d:	66 89 14 c5 06 64 11 	mov    %dx,-0x7fee9bfa(,%eax,8)
80105d54:	80 
  for(i = 0; i < 256; i++)
80105d55:	83 c0 01             	add    $0x1,%eax
80105d58:	3d 00 01 00 00       	cmp    $0x100,%eax
80105d5d:	75 d1                	jne    80105d30 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d5f:	a1 0c b1 10 80       	mov    0x8010b10c,%eax
  SETGATE(idt[128], 0, SEG_KCODE<<3, vectors[128], DPL_USER);
//두번쨰 인자가 다른데 이것은 interrupt(0)와 trap(1)인지 구별함. mmu.h에 작성되어있음.
//마지막 인자가 다른데 user mode에서 system call을 실행할 수 있다는 뜻.
  initlock(&tickslock, "time");
80105d64:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d67:	c7 05 02 66 11 80 08 	movl   $0xef000008,0x80116602
80105d6e:	00 00 ef 
  initlock(&tickslock, "time");
80105d71:	68 f1 7d 10 80       	push   $0x80107df1
80105d76:	68 c0 63 11 80       	push   $0x801163c0
  SETGATE(idt[128], 0, SEG_KCODE<<3, vectors[128], DPL_USER);
80105d7b:	c7 05 02 68 11 80 08 	movl   $0xee000008,0x80116802
80105d82:	00 00 ee 
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105d85:	66 a3 00 66 11 80    	mov    %ax,0x80116600
80105d8b:	c1 e8 10             	shr    $0x10,%eax
80105d8e:	66 a3 06 66 11 80    	mov    %ax,0x80116606
  SETGATE(idt[128], 0, SEG_KCODE<<3, vectors[128], DPL_USER);
80105d94:	a1 0c b2 10 80       	mov    0x8010b20c,%eax
80105d99:	66 a3 00 68 11 80    	mov    %ax,0x80116800
80105d9f:	c1 e8 10             	shr    $0x10,%eax
80105da2:	66 a3 06 68 11 80    	mov    %ax,0x80116806
  initlock(&tickslock, "time");
80105da8:	e8 73 ea ff ff       	call   80104820 <initlock>
}
80105dad:	83 c4 10             	add    $0x10,%esp
80105db0:	c9                   	leave  
80105db1:	c3                   	ret    
80105db2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105db9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105dc0 <idtinit>:

void
idtinit(void)
{
80105dc0:	55                   	push   %ebp
  pd[0] = size-1;
80105dc1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105dc6:	89 e5                	mov    %esp,%ebp
80105dc8:	83 ec 10             	sub    $0x10,%esp
80105dcb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105dcf:	b8 00 64 11 80       	mov    $0x80116400,%eax
80105dd4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105dd8:	c1 e8 10             	shr    $0x10,%eax
80105ddb:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105ddf:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105de2:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105de5:	c9                   	leave  
80105de6:	c3                   	ret    
80105de7:	89 f6                	mov    %esi,%esi
80105de9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105df0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105df0:	55                   	push   %ebp
80105df1:	89 e5                	mov    %esp,%ebp
80105df3:	57                   	push   %edi
80105df4:	56                   	push   %esi
80105df5:	53                   	push   %ebx
80105df6:	83 ec 1c             	sub    $0x1c,%esp
80105df9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
80105dfc:	8b 47 30             	mov    0x30(%edi),%eax
80105dff:	83 f8 40             	cmp    $0x40,%eax
80105e02:	0f 84 28 01 00 00    	je     80105f30 <trap+0x140>
    if(myproc()->killed)
      exit();
    return;
  }
//my code  
  if(tf->trapno == 128){
80105e08:	3d 80 00 00 00       	cmp    $0x80,%eax
80105e0d:	0f 84 fd 00 00 00    	je     80105f10 <trap+0x120>
	cprintf("user interrupt 128 called!\n");
	exit();	
	return;
  }

  switch(tf->trapno){
80105e13:	83 e8 20             	sub    $0x20,%eax
80105e16:	83 f8 1f             	cmp    $0x1f,%eax
80105e19:	77 0d                	ja     80105e28 <trap+0x38>
80105e1b:	ff 24 85 b4 7e 10 80 	jmp    *-0x7fef814c(,%eax,4)
80105e22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105e28:	e8 83 db ff ff       	call   801039b0 <myproc>
80105e2d:	85 c0                	test   %eax,%eax
80105e2f:	8b 5f 38             	mov    0x38(%edi),%ebx
80105e32:	0f 84 2c 02 00 00    	je     80106064 <trap+0x274>
80105e38:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
80105e3c:	0f 84 22 02 00 00    	je     80106064 <trap+0x274>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105e42:	0f 20 d1             	mov    %cr2,%ecx
80105e45:	89 4d d8             	mov    %ecx,-0x28(%ebp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e48:	e8 43 db ff ff       	call   80103990 <cpuid>
80105e4d:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105e50:	8b 47 34             	mov    0x34(%edi),%eax
80105e53:	8b 77 30             	mov    0x30(%edi),%esi
80105e56:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105e59:	e8 52 db ff ff       	call   801039b0 <myproc>
80105e5e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105e61:	e8 4a db ff ff       	call   801039b0 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e66:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105e69:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105e6c:	51                   	push   %ecx
80105e6d:	53                   	push   %ebx
80105e6e:	52                   	push   %edx
            myproc()->pid, myproc()->name, tf->trapno,
80105e6f:	8b 55 e0             	mov    -0x20(%ebp),%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e72:	ff 75 e4             	pushl  -0x1c(%ebp)
80105e75:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105e76:	83 ea 80             	sub    $0xffffff80,%edx
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105e79:	52                   	push   %edx
80105e7a:	ff 70 10             	pushl  0x10(%eax)
80105e7d:	68 70 7e 10 80       	push   $0x80107e70
80105e82:	e8 d9 a7 ff ff       	call   80100660 <cprintf>
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
80105e87:	83 c4 20             	add    $0x20,%esp
80105e8a:	e8 21 db ff ff       	call   801039b0 <myproc>
80105e8f:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
80105e96:	8d 76 00             	lea    0x0(%esi),%esi
80105e99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ea0:	e8 0b db ff ff       	call   801039b0 <myproc>
80105ea5:	85 c0                	test   %eax,%eax
80105ea7:	74 1d                	je     80105ec6 <trap+0xd6>
80105ea9:	e8 02 db ff ff       	call   801039b0 <myproc>
80105eae:	8b 50 24             	mov    0x24(%eax),%edx
80105eb1:	85 d2                	test   %edx,%edx
80105eb3:	74 11                	je     80105ec6 <trap+0xd6>
80105eb5:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105eb9:	83 e0 03             	and    $0x3,%eax
80105ebc:	66 83 f8 03          	cmp    $0x3,%ax
80105ec0:	0f 84 5a 01 00 00    	je     80106020 <trap+0x230>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ec6:	e8 e5 da ff ff       	call   801039b0 <myproc>
80105ecb:	85 c0                	test   %eax,%eax
80105ecd:	74 0f                	je     80105ede <trap+0xee>
80105ecf:	e8 dc da ff ff       	call   801039b0 <myproc>
80105ed4:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105ed8:	0f 84 8a 00 00 00    	je     80105f68 <trap+0x178>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ede:	e8 cd da ff ff       	call   801039b0 <myproc>
80105ee3:	85 c0                	test   %eax,%eax
80105ee5:	74 19                	je     80105f00 <trap+0x110>
80105ee7:	e8 c4 da ff ff       	call   801039b0 <myproc>
80105eec:	8b 40 24             	mov    0x24(%eax),%eax
80105eef:	85 c0                	test   %eax,%eax
80105ef1:	74 0d                	je     80105f00 <trap+0x110>
80105ef3:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105ef7:	83 e0 03             	and    $0x3,%eax
80105efa:	66 83 f8 03          	cmp    $0x3,%ax
80105efe:	74 20                	je     80105f20 <trap+0x130>
    exit();
}
80105f00:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f03:	5b                   	pop    %ebx
80105f04:	5e                   	pop    %esi
80105f05:	5f                   	pop    %edi
80105f06:	5d                   	pop    %ebp
80105f07:	c3                   	ret    
80105f08:	90                   	nop
80105f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
	cprintf("user interrupt 128 called!\n");
80105f10:	83 ec 0c             	sub    $0xc,%esp
80105f13:	68 f6 7d 10 80       	push   $0x80107df6
80105f18:	e8 43 a7 ff ff       	call   80100660 <cprintf>
	exit();	
80105f1d:	83 c4 10             	add    $0x10,%esp
}
80105f20:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f23:	5b                   	pop    %ebx
80105f24:	5e                   	pop    %esi
80105f25:	5f                   	pop    %edi
80105f26:	5d                   	pop    %ebp
	exit();	
80105f27:	e9 74 e0 ff ff       	jmp    80103fa0 <exit>
80105f2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed)
80105f30:	e8 7b da ff ff       	call   801039b0 <myproc>
80105f35:	8b 58 24             	mov    0x24(%eax),%ebx
80105f38:	85 db                	test   %ebx,%ebx
80105f3a:	0f 85 d0 00 00 00    	jne    80106010 <trap+0x220>
    myproc()->tf = tf;
80105f40:	e8 6b da ff ff       	call   801039b0 <myproc>
80105f45:	89 78 18             	mov    %edi,0x18(%eax)
    syscall();
80105f48:	e8 13 ef ff ff       	call   80104e60 <syscall>
    if(myproc()->killed)
80105f4d:	e8 5e da ff ff       	call   801039b0 <myproc>
80105f52:	8b 48 24             	mov    0x24(%eax),%ecx
80105f55:	85 c9                	test   %ecx,%ecx
80105f57:	75 c7                	jne    80105f20 <trap+0x130>
}
80105f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f5c:	5b                   	pop    %ebx
80105f5d:	5e                   	pop    %esi
80105f5e:	5f                   	pop    %edi
80105f5f:	5d                   	pop    %ebp
80105f60:	c3                   	ret    
80105f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(myproc() && myproc()->state == RUNNING &&
80105f68:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
80105f6c:	0f 85 6c ff ff ff    	jne    80105ede <trap+0xee>
    yield();
80105f72:	e8 59 e1 ff ff       	call   801040d0 <yield>
80105f77:	e9 62 ff ff ff       	jmp    80105ede <trap+0xee>
80105f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80105f80:	e8 0b da ff ff       	call   80103990 <cpuid>
80105f85:	85 c0                	test   %eax,%eax
80105f87:	0f 84 a3 00 00 00    	je     80106030 <trap+0x240>
    lapiceoi();
80105f8d:	e8 6e c9 ff ff       	call   80102900 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f92:	e8 19 da ff ff       	call   801039b0 <myproc>
80105f97:	85 c0                	test   %eax,%eax
80105f99:	0f 85 0a ff ff ff    	jne    80105ea9 <trap+0xb9>
80105f9f:	e9 22 ff ff ff       	jmp    80105ec6 <trap+0xd6>
80105fa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80105fa8:	e8 13 c8 ff ff       	call   801027c0 <kbdintr>
    lapiceoi();
80105fad:	e8 4e c9 ff ff       	call   80102900 <lapiceoi>
    break;
80105fb2:	e9 e9 fe ff ff       	jmp    80105ea0 <trap+0xb0>
80105fb7:	89 f6                	mov    %esi,%esi
80105fb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    uartintr();
80105fc0:	e8 3b 02 00 00       	call   80106200 <uartintr>
    lapiceoi();
80105fc5:	e8 36 c9 ff ff       	call   80102900 <lapiceoi>
    break;
80105fca:	e9 d1 fe ff ff       	jmp    80105ea0 <trap+0xb0>
80105fcf:	90                   	nop
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fd0:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105fd4:	8b 77 38             	mov    0x38(%edi),%esi
80105fd7:	e8 b4 d9 ff ff       	call   80103990 <cpuid>
80105fdc:	56                   	push   %esi
80105fdd:	53                   	push   %ebx
80105fde:	50                   	push   %eax
80105fdf:	68 18 7e 10 80       	push   $0x80107e18
80105fe4:	e8 77 a6 ff ff       	call   80100660 <cprintf>
    lapiceoi();
80105fe9:	e8 12 c9 ff ff       	call   80102900 <lapiceoi>
    break;
80105fee:	83 c4 10             	add    $0x10,%esp
80105ff1:	e9 aa fe ff ff       	jmp    80105ea0 <trap+0xb0>
80105ff6:	8d 76 00             	lea    0x0(%esi),%esi
80105ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    ideintr();
80106000:	e8 2b c2 ff ff       	call   80102230 <ideintr>
80106005:	eb 86                	jmp    80105f8d <trap+0x19d>
80106007:	89 f6                	mov    %esi,%esi
80106009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      exit();
80106010:	e8 8b df ff ff       	call   80103fa0 <exit>
80106015:	e9 26 ff ff ff       	jmp    80105f40 <trap+0x150>
8010601a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    exit();
80106020:	e8 7b df ff ff       	call   80103fa0 <exit>
80106025:	e9 9c fe ff ff       	jmp    80105ec6 <trap+0xd6>
8010602a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      acquire(&tickslock);
80106030:	83 ec 0c             	sub    $0xc,%esp
80106033:	68 c0 63 11 80       	push   $0x801163c0
80106038:	e8 23 e9 ff ff       	call   80104960 <acquire>
      wakeup(&ticks);
8010603d:	c7 04 24 00 6c 11 80 	movl   $0x80116c00,(%esp)
      ticks++;
80106044:	83 05 00 6c 11 80 01 	addl   $0x1,0x80116c00
      wakeup(&ticks);
8010604b:	e8 90 e2 ff ff       	call   801042e0 <wakeup>
      release(&tickslock);
80106050:	c7 04 24 c0 63 11 80 	movl   $0x801163c0,(%esp)
80106057:	e8 c4 e9 ff ff       	call   80104a20 <release>
8010605c:	83 c4 10             	add    $0x10,%esp
8010605f:	e9 29 ff ff ff       	jmp    80105f8d <trap+0x19d>
80106064:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80106067:	e8 24 d9 ff ff       	call   80103990 <cpuid>
8010606c:	83 ec 0c             	sub    $0xc,%esp
8010606f:	56                   	push   %esi
80106070:	53                   	push   %ebx
80106071:	50                   	push   %eax
80106072:	ff 77 30             	pushl  0x30(%edi)
80106075:	68 3c 7e 10 80       	push   $0x80107e3c
8010607a:	e8 e1 a5 ff ff       	call   80100660 <cprintf>
      panic("trap");
8010607f:	83 c4 14             	add    $0x14,%esp
80106082:	68 12 7e 10 80       	push   $0x80107e12
80106087:	e8 04 a3 ff ff       	call   80100390 <panic>
8010608c:	66 90                	xchg   %ax,%ax
8010608e:	66 90                	xchg   %ax,%ax

80106090 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106090:	a1 e8 b7 10 80       	mov    0x8010b7e8,%eax
{
80106095:	55                   	push   %ebp
80106096:	89 e5                	mov    %esp,%ebp
  if(!uart)
80106098:	85 c0                	test   %eax,%eax
8010609a:	74 1c                	je     801060b8 <uartgetc+0x28>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010609c:	ba fd 03 00 00       	mov    $0x3fd,%edx
801060a1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
801060a2:	a8 01                	test   $0x1,%al
801060a4:	74 12                	je     801060b8 <uartgetc+0x28>
801060a6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060ab:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
801060ac:	0f b6 c0             	movzbl %al,%eax
}
801060af:	5d                   	pop    %ebp
801060b0:	c3                   	ret    
801060b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
801060b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801060bd:	5d                   	pop    %ebp
801060be:	c3                   	ret    
801060bf:	90                   	nop

801060c0 <uartputc.part.0>:
uartputc(int c)
801060c0:	55                   	push   %ebp
801060c1:	89 e5                	mov    %esp,%ebp
801060c3:	57                   	push   %edi
801060c4:	56                   	push   %esi
801060c5:	53                   	push   %ebx
801060c6:	89 c7                	mov    %eax,%edi
801060c8:	bb 80 00 00 00       	mov    $0x80,%ebx
801060cd:	be fd 03 00 00       	mov    $0x3fd,%esi
801060d2:	83 ec 0c             	sub    $0xc,%esp
801060d5:	eb 1b                	jmp    801060f2 <uartputc.part.0+0x32>
801060d7:	89 f6                	mov    %esi,%esi
801060d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    microdelay(10);
801060e0:	83 ec 0c             	sub    $0xc,%esp
801060e3:	6a 0a                	push   $0xa
801060e5:	e8 36 c8 ff ff       	call   80102920 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801060ea:	83 c4 10             	add    $0x10,%esp
801060ed:	83 eb 01             	sub    $0x1,%ebx
801060f0:	74 07                	je     801060f9 <uartputc.part.0+0x39>
801060f2:	89 f2                	mov    %esi,%edx
801060f4:	ec                   	in     (%dx),%al
801060f5:	a8 20                	test   $0x20,%al
801060f7:	74 e7                	je     801060e0 <uartputc.part.0+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801060f9:	ba f8 03 00 00       	mov    $0x3f8,%edx
801060fe:	89 f8                	mov    %edi,%eax
80106100:	ee                   	out    %al,(%dx)
}
80106101:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106104:	5b                   	pop    %ebx
80106105:	5e                   	pop    %esi
80106106:	5f                   	pop    %edi
80106107:	5d                   	pop    %ebp
80106108:	c3                   	ret    
80106109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106110 <uartinit>:
{
80106110:	55                   	push   %ebp
80106111:	31 c9                	xor    %ecx,%ecx
80106113:	89 c8                	mov    %ecx,%eax
80106115:	89 e5                	mov    %esp,%ebp
80106117:	57                   	push   %edi
80106118:	56                   	push   %esi
80106119:	53                   	push   %ebx
8010611a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
8010611f:	89 da                	mov    %ebx,%edx
80106121:	83 ec 0c             	sub    $0xc,%esp
80106124:	ee                   	out    %al,(%dx)
80106125:	bf fb 03 00 00       	mov    $0x3fb,%edi
8010612a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010612f:	89 fa                	mov    %edi,%edx
80106131:	ee                   	out    %al,(%dx)
80106132:	b8 0c 00 00 00       	mov    $0xc,%eax
80106137:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010613c:	ee                   	out    %al,(%dx)
8010613d:	be f9 03 00 00       	mov    $0x3f9,%esi
80106142:	89 c8                	mov    %ecx,%eax
80106144:	89 f2                	mov    %esi,%edx
80106146:	ee                   	out    %al,(%dx)
80106147:	b8 03 00 00 00       	mov    $0x3,%eax
8010614c:	89 fa                	mov    %edi,%edx
8010614e:	ee                   	out    %al,(%dx)
8010614f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106154:	89 c8                	mov    %ecx,%eax
80106156:	ee                   	out    %al,(%dx)
80106157:	b8 01 00 00 00       	mov    $0x1,%eax
8010615c:	89 f2                	mov    %esi,%edx
8010615e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010615f:	ba fd 03 00 00       	mov    $0x3fd,%edx
80106164:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
80106165:	3c ff                	cmp    $0xff,%al
80106167:	74 5a                	je     801061c3 <uartinit+0xb3>
  uart = 1;
80106169:	c7 05 e8 b7 10 80 01 	movl   $0x1,0x8010b7e8
80106170:	00 00 00 
80106173:	89 da                	mov    %ebx,%edx
80106175:	ec                   	in     (%dx),%al
80106176:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617b:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
8010617c:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
8010617f:	bb 34 7f 10 80       	mov    $0x80107f34,%ebx
  ioapicenable(IRQ_COM1, 0);
80106184:	6a 00                	push   $0x0
80106186:	6a 04                	push   $0x4
80106188:	e8 f3 c2 ff ff       	call   80102480 <ioapicenable>
8010618d:	83 c4 10             	add    $0x10,%esp
  for(p="xv6...\n"; *p; p++)
80106190:	b8 78 00 00 00       	mov    $0x78,%eax
80106195:	eb 13                	jmp    801061aa <uartinit+0x9a>
80106197:	89 f6                	mov    %esi,%esi
80106199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061a0:	83 c3 01             	add    $0x1,%ebx
801061a3:	0f be 03             	movsbl (%ebx),%eax
801061a6:	84 c0                	test   %al,%al
801061a8:	74 19                	je     801061c3 <uartinit+0xb3>
  if(!uart)
801061aa:	8b 15 e8 b7 10 80    	mov    0x8010b7e8,%edx
801061b0:	85 d2                	test   %edx,%edx
801061b2:	74 ec                	je     801061a0 <uartinit+0x90>
  for(p="xv6...\n"; *p; p++)
801061b4:	83 c3 01             	add    $0x1,%ebx
801061b7:	e8 04 ff ff ff       	call   801060c0 <uartputc.part.0>
801061bc:	0f be 03             	movsbl (%ebx),%eax
801061bf:	84 c0                	test   %al,%al
801061c1:	75 e7                	jne    801061aa <uartinit+0x9a>
}
801061c3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801061c6:	5b                   	pop    %ebx
801061c7:	5e                   	pop    %esi
801061c8:	5f                   	pop    %edi
801061c9:	5d                   	pop    %ebp
801061ca:	c3                   	ret    
801061cb:	90                   	nop
801061cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801061d0 <uartputc>:
  if(!uart)
801061d0:	8b 15 e8 b7 10 80    	mov    0x8010b7e8,%edx
{
801061d6:	55                   	push   %ebp
801061d7:	89 e5                	mov    %esp,%ebp
  if(!uart)
801061d9:	85 d2                	test   %edx,%edx
{
801061db:	8b 45 08             	mov    0x8(%ebp),%eax
  if(!uart)
801061de:	74 10                	je     801061f0 <uartputc+0x20>
}
801061e0:	5d                   	pop    %ebp
801061e1:	e9 da fe ff ff       	jmp    801060c0 <uartputc.part.0>
801061e6:	8d 76 00             	lea    0x0(%esi),%esi
801061e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
801061f0:	5d                   	pop    %ebp
801061f1:	c3                   	ret    
801061f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801061f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106200 <uartintr>:

void
uartintr(void)
{
80106200:	55                   	push   %ebp
80106201:	89 e5                	mov    %esp,%ebp
80106203:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106206:	68 90 60 10 80       	push   $0x80106090
8010620b:	e8 00 a6 ff ff       	call   80100810 <consoleintr>
}
80106210:	83 c4 10             	add    $0x10,%esp
80106213:	c9                   	leave  
80106214:	c3                   	ret    

80106215 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80106215:	6a 00                	push   $0x0
  pushl $0
80106217:	6a 00                	push   $0x0
  jmp alltraps
80106219:	e9 dc fa ff ff       	jmp    80105cfa <alltraps>

8010621e <vector1>:
.globl vector1
vector1:
  pushl $0
8010621e:	6a 00                	push   $0x0
  pushl $1
80106220:	6a 01                	push   $0x1
  jmp alltraps
80106222:	e9 d3 fa ff ff       	jmp    80105cfa <alltraps>

80106227 <vector2>:
.globl vector2
vector2:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $2
80106229:	6a 02                	push   $0x2
  jmp alltraps
8010622b:	e9 ca fa ff ff       	jmp    80105cfa <alltraps>

80106230 <vector3>:
.globl vector3
vector3:
  pushl $0
80106230:	6a 00                	push   $0x0
  pushl $3
80106232:	6a 03                	push   $0x3
  jmp alltraps
80106234:	e9 c1 fa ff ff       	jmp    80105cfa <alltraps>

80106239 <vector4>:
.globl vector4
vector4:
  pushl $0
80106239:	6a 00                	push   $0x0
  pushl $4
8010623b:	6a 04                	push   $0x4
  jmp alltraps
8010623d:	e9 b8 fa ff ff       	jmp    80105cfa <alltraps>

80106242 <vector5>:
.globl vector5
vector5:
  pushl $0
80106242:	6a 00                	push   $0x0
  pushl $5
80106244:	6a 05                	push   $0x5
  jmp alltraps
80106246:	e9 af fa ff ff       	jmp    80105cfa <alltraps>

8010624b <vector6>:
.globl vector6
vector6:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $6
8010624d:	6a 06                	push   $0x6
  jmp alltraps
8010624f:	e9 a6 fa ff ff       	jmp    80105cfa <alltraps>

80106254 <vector7>:
.globl vector7
vector7:
  pushl $0
80106254:	6a 00                	push   $0x0
  pushl $7
80106256:	6a 07                	push   $0x7
  jmp alltraps
80106258:	e9 9d fa ff ff       	jmp    80105cfa <alltraps>

8010625d <vector8>:
.globl vector8
vector8:
  pushl $8
8010625d:	6a 08                	push   $0x8
  jmp alltraps
8010625f:	e9 96 fa ff ff       	jmp    80105cfa <alltraps>

80106264 <vector9>:
.globl vector9
vector9:
  pushl $0
80106264:	6a 00                	push   $0x0
  pushl $9
80106266:	6a 09                	push   $0x9
  jmp alltraps
80106268:	e9 8d fa ff ff       	jmp    80105cfa <alltraps>

8010626d <vector10>:
.globl vector10
vector10:
  pushl $10
8010626d:	6a 0a                	push   $0xa
  jmp alltraps
8010626f:	e9 86 fa ff ff       	jmp    80105cfa <alltraps>

80106274 <vector11>:
.globl vector11
vector11:
  pushl $11
80106274:	6a 0b                	push   $0xb
  jmp alltraps
80106276:	e9 7f fa ff ff       	jmp    80105cfa <alltraps>

8010627b <vector12>:
.globl vector12
vector12:
  pushl $12
8010627b:	6a 0c                	push   $0xc
  jmp alltraps
8010627d:	e9 78 fa ff ff       	jmp    80105cfa <alltraps>

80106282 <vector13>:
.globl vector13
vector13:
  pushl $13
80106282:	6a 0d                	push   $0xd
  jmp alltraps
80106284:	e9 71 fa ff ff       	jmp    80105cfa <alltraps>

80106289 <vector14>:
.globl vector14
vector14:
  pushl $14
80106289:	6a 0e                	push   $0xe
  jmp alltraps
8010628b:	e9 6a fa ff ff       	jmp    80105cfa <alltraps>

80106290 <vector15>:
.globl vector15
vector15:
  pushl $0
80106290:	6a 00                	push   $0x0
  pushl $15
80106292:	6a 0f                	push   $0xf
  jmp alltraps
80106294:	e9 61 fa ff ff       	jmp    80105cfa <alltraps>

80106299 <vector16>:
.globl vector16
vector16:
  pushl $0
80106299:	6a 00                	push   $0x0
  pushl $16
8010629b:	6a 10                	push   $0x10
  jmp alltraps
8010629d:	e9 58 fa ff ff       	jmp    80105cfa <alltraps>

801062a2 <vector17>:
.globl vector17
vector17:
  pushl $17
801062a2:	6a 11                	push   $0x11
  jmp alltraps
801062a4:	e9 51 fa ff ff       	jmp    80105cfa <alltraps>

801062a9 <vector18>:
.globl vector18
vector18:
  pushl $0
801062a9:	6a 00                	push   $0x0
  pushl $18
801062ab:	6a 12                	push   $0x12
  jmp alltraps
801062ad:	e9 48 fa ff ff       	jmp    80105cfa <alltraps>

801062b2 <vector19>:
.globl vector19
vector19:
  pushl $0
801062b2:	6a 00                	push   $0x0
  pushl $19
801062b4:	6a 13                	push   $0x13
  jmp alltraps
801062b6:	e9 3f fa ff ff       	jmp    80105cfa <alltraps>

801062bb <vector20>:
.globl vector20
vector20:
  pushl $0
801062bb:	6a 00                	push   $0x0
  pushl $20
801062bd:	6a 14                	push   $0x14
  jmp alltraps
801062bf:	e9 36 fa ff ff       	jmp    80105cfa <alltraps>

801062c4 <vector21>:
.globl vector21
vector21:
  pushl $0
801062c4:	6a 00                	push   $0x0
  pushl $21
801062c6:	6a 15                	push   $0x15
  jmp alltraps
801062c8:	e9 2d fa ff ff       	jmp    80105cfa <alltraps>

801062cd <vector22>:
.globl vector22
vector22:
  pushl $0
801062cd:	6a 00                	push   $0x0
  pushl $22
801062cf:	6a 16                	push   $0x16
  jmp alltraps
801062d1:	e9 24 fa ff ff       	jmp    80105cfa <alltraps>

801062d6 <vector23>:
.globl vector23
vector23:
  pushl $0
801062d6:	6a 00                	push   $0x0
  pushl $23
801062d8:	6a 17                	push   $0x17
  jmp alltraps
801062da:	e9 1b fa ff ff       	jmp    80105cfa <alltraps>

801062df <vector24>:
.globl vector24
vector24:
  pushl $0
801062df:	6a 00                	push   $0x0
  pushl $24
801062e1:	6a 18                	push   $0x18
  jmp alltraps
801062e3:	e9 12 fa ff ff       	jmp    80105cfa <alltraps>

801062e8 <vector25>:
.globl vector25
vector25:
  pushl $0
801062e8:	6a 00                	push   $0x0
  pushl $25
801062ea:	6a 19                	push   $0x19
  jmp alltraps
801062ec:	e9 09 fa ff ff       	jmp    80105cfa <alltraps>

801062f1 <vector26>:
.globl vector26
vector26:
  pushl $0
801062f1:	6a 00                	push   $0x0
  pushl $26
801062f3:	6a 1a                	push   $0x1a
  jmp alltraps
801062f5:	e9 00 fa ff ff       	jmp    80105cfa <alltraps>

801062fa <vector27>:
.globl vector27
vector27:
  pushl $0
801062fa:	6a 00                	push   $0x0
  pushl $27
801062fc:	6a 1b                	push   $0x1b
  jmp alltraps
801062fe:	e9 f7 f9 ff ff       	jmp    80105cfa <alltraps>

80106303 <vector28>:
.globl vector28
vector28:
  pushl $0
80106303:	6a 00                	push   $0x0
  pushl $28
80106305:	6a 1c                	push   $0x1c
  jmp alltraps
80106307:	e9 ee f9 ff ff       	jmp    80105cfa <alltraps>

8010630c <vector29>:
.globl vector29
vector29:
  pushl $0
8010630c:	6a 00                	push   $0x0
  pushl $29
8010630e:	6a 1d                	push   $0x1d
  jmp alltraps
80106310:	e9 e5 f9 ff ff       	jmp    80105cfa <alltraps>

80106315 <vector30>:
.globl vector30
vector30:
  pushl $0
80106315:	6a 00                	push   $0x0
  pushl $30
80106317:	6a 1e                	push   $0x1e
  jmp alltraps
80106319:	e9 dc f9 ff ff       	jmp    80105cfa <alltraps>

8010631e <vector31>:
.globl vector31
vector31:
  pushl $0
8010631e:	6a 00                	push   $0x0
  pushl $31
80106320:	6a 1f                	push   $0x1f
  jmp alltraps
80106322:	e9 d3 f9 ff ff       	jmp    80105cfa <alltraps>

80106327 <vector32>:
.globl vector32
vector32:
  pushl $0
80106327:	6a 00                	push   $0x0
  pushl $32
80106329:	6a 20                	push   $0x20
  jmp alltraps
8010632b:	e9 ca f9 ff ff       	jmp    80105cfa <alltraps>

80106330 <vector33>:
.globl vector33
vector33:
  pushl $0
80106330:	6a 00                	push   $0x0
  pushl $33
80106332:	6a 21                	push   $0x21
  jmp alltraps
80106334:	e9 c1 f9 ff ff       	jmp    80105cfa <alltraps>

80106339 <vector34>:
.globl vector34
vector34:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $34
8010633b:	6a 22                	push   $0x22
  jmp alltraps
8010633d:	e9 b8 f9 ff ff       	jmp    80105cfa <alltraps>

80106342 <vector35>:
.globl vector35
vector35:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $35
80106344:	6a 23                	push   $0x23
  jmp alltraps
80106346:	e9 af f9 ff ff       	jmp    80105cfa <alltraps>

8010634b <vector36>:
.globl vector36
vector36:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $36
8010634d:	6a 24                	push   $0x24
  jmp alltraps
8010634f:	e9 a6 f9 ff ff       	jmp    80105cfa <alltraps>

80106354 <vector37>:
.globl vector37
vector37:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $37
80106356:	6a 25                	push   $0x25
  jmp alltraps
80106358:	e9 9d f9 ff ff       	jmp    80105cfa <alltraps>

8010635d <vector38>:
.globl vector38
vector38:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $38
8010635f:	6a 26                	push   $0x26
  jmp alltraps
80106361:	e9 94 f9 ff ff       	jmp    80105cfa <alltraps>

80106366 <vector39>:
.globl vector39
vector39:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $39
80106368:	6a 27                	push   $0x27
  jmp alltraps
8010636a:	e9 8b f9 ff ff       	jmp    80105cfa <alltraps>

8010636f <vector40>:
.globl vector40
vector40:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $40
80106371:	6a 28                	push   $0x28
  jmp alltraps
80106373:	e9 82 f9 ff ff       	jmp    80105cfa <alltraps>

80106378 <vector41>:
.globl vector41
vector41:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $41
8010637a:	6a 29                	push   $0x29
  jmp alltraps
8010637c:	e9 79 f9 ff ff       	jmp    80105cfa <alltraps>

80106381 <vector42>:
.globl vector42
vector42:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $42
80106383:	6a 2a                	push   $0x2a
  jmp alltraps
80106385:	e9 70 f9 ff ff       	jmp    80105cfa <alltraps>

8010638a <vector43>:
.globl vector43
vector43:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $43
8010638c:	6a 2b                	push   $0x2b
  jmp alltraps
8010638e:	e9 67 f9 ff ff       	jmp    80105cfa <alltraps>

80106393 <vector44>:
.globl vector44
vector44:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $44
80106395:	6a 2c                	push   $0x2c
  jmp alltraps
80106397:	e9 5e f9 ff ff       	jmp    80105cfa <alltraps>

8010639c <vector45>:
.globl vector45
vector45:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $45
8010639e:	6a 2d                	push   $0x2d
  jmp alltraps
801063a0:	e9 55 f9 ff ff       	jmp    80105cfa <alltraps>

801063a5 <vector46>:
.globl vector46
vector46:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $46
801063a7:	6a 2e                	push   $0x2e
  jmp alltraps
801063a9:	e9 4c f9 ff ff       	jmp    80105cfa <alltraps>

801063ae <vector47>:
.globl vector47
vector47:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $47
801063b0:	6a 2f                	push   $0x2f
  jmp alltraps
801063b2:	e9 43 f9 ff ff       	jmp    80105cfa <alltraps>

801063b7 <vector48>:
.globl vector48
vector48:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $48
801063b9:	6a 30                	push   $0x30
  jmp alltraps
801063bb:	e9 3a f9 ff ff       	jmp    80105cfa <alltraps>

801063c0 <vector49>:
.globl vector49
vector49:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $49
801063c2:	6a 31                	push   $0x31
  jmp alltraps
801063c4:	e9 31 f9 ff ff       	jmp    80105cfa <alltraps>

801063c9 <vector50>:
.globl vector50
vector50:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $50
801063cb:	6a 32                	push   $0x32
  jmp alltraps
801063cd:	e9 28 f9 ff ff       	jmp    80105cfa <alltraps>

801063d2 <vector51>:
.globl vector51
vector51:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $51
801063d4:	6a 33                	push   $0x33
  jmp alltraps
801063d6:	e9 1f f9 ff ff       	jmp    80105cfa <alltraps>

801063db <vector52>:
.globl vector52
vector52:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $52
801063dd:	6a 34                	push   $0x34
  jmp alltraps
801063df:	e9 16 f9 ff ff       	jmp    80105cfa <alltraps>

801063e4 <vector53>:
.globl vector53
vector53:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $53
801063e6:	6a 35                	push   $0x35
  jmp alltraps
801063e8:	e9 0d f9 ff ff       	jmp    80105cfa <alltraps>

801063ed <vector54>:
.globl vector54
vector54:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $54
801063ef:	6a 36                	push   $0x36
  jmp alltraps
801063f1:	e9 04 f9 ff ff       	jmp    80105cfa <alltraps>

801063f6 <vector55>:
.globl vector55
vector55:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $55
801063f8:	6a 37                	push   $0x37
  jmp alltraps
801063fa:	e9 fb f8 ff ff       	jmp    80105cfa <alltraps>

801063ff <vector56>:
.globl vector56
vector56:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $56
80106401:	6a 38                	push   $0x38
  jmp alltraps
80106403:	e9 f2 f8 ff ff       	jmp    80105cfa <alltraps>

80106408 <vector57>:
.globl vector57
vector57:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $57
8010640a:	6a 39                	push   $0x39
  jmp alltraps
8010640c:	e9 e9 f8 ff ff       	jmp    80105cfa <alltraps>

80106411 <vector58>:
.globl vector58
vector58:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $58
80106413:	6a 3a                	push   $0x3a
  jmp alltraps
80106415:	e9 e0 f8 ff ff       	jmp    80105cfa <alltraps>

8010641a <vector59>:
.globl vector59
vector59:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $59
8010641c:	6a 3b                	push   $0x3b
  jmp alltraps
8010641e:	e9 d7 f8 ff ff       	jmp    80105cfa <alltraps>

80106423 <vector60>:
.globl vector60
vector60:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $60
80106425:	6a 3c                	push   $0x3c
  jmp alltraps
80106427:	e9 ce f8 ff ff       	jmp    80105cfa <alltraps>

8010642c <vector61>:
.globl vector61
vector61:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $61
8010642e:	6a 3d                	push   $0x3d
  jmp alltraps
80106430:	e9 c5 f8 ff ff       	jmp    80105cfa <alltraps>

80106435 <vector62>:
.globl vector62
vector62:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $62
80106437:	6a 3e                	push   $0x3e
  jmp alltraps
80106439:	e9 bc f8 ff ff       	jmp    80105cfa <alltraps>

8010643e <vector63>:
.globl vector63
vector63:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $63
80106440:	6a 3f                	push   $0x3f
  jmp alltraps
80106442:	e9 b3 f8 ff ff       	jmp    80105cfa <alltraps>

80106447 <vector64>:
.globl vector64
vector64:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $64
80106449:	6a 40                	push   $0x40
  jmp alltraps
8010644b:	e9 aa f8 ff ff       	jmp    80105cfa <alltraps>

80106450 <vector65>:
.globl vector65
vector65:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $65
80106452:	6a 41                	push   $0x41
  jmp alltraps
80106454:	e9 a1 f8 ff ff       	jmp    80105cfa <alltraps>

80106459 <vector66>:
.globl vector66
vector66:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $66
8010645b:	6a 42                	push   $0x42
  jmp alltraps
8010645d:	e9 98 f8 ff ff       	jmp    80105cfa <alltraps>

80106462 <vector67>:
.globl vector67
vector67:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $67
80106464:	6a 43                	push   $0x43
  jmp alltraps
80106466:	e9 8f f8 ff ff       	jmp    80105cfa <alltraps>

8010646b <vector68>:
.globl vector68
vector68:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $68
8010646d:	6a 44                	push   $0x44
  jmp alltraps
8010646f:	e9 86 f8 ff ff       	jmp    80105cfa <alltraps>

80106474 <vector69>:
.globl vector69
vector69:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $69
80106476:	6a 45                	push   $0x45
  jmp alltraps
80106478:	e9 7d f8 ff ff       	jmp    80105cfa <alltraps>

8010647d <vector70>:
.globl vector70
vector70:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $70
8010647f:	6a 46                	push   $0x46
  jmp alltraps
80106481:	e9 74 f8 ff ff       	jmp    80105cfa <alltraps>

80106486 <vector71>:
.globl vector71
vector71:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $71
80106488:	6a 47                	push   $0x47
  jmp alltraps
8010648a:	e9 6b f8 ff ff       	jmp    80105cfa <alltraps>

8010648f <vector72>:
.globl vector72
vector72:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $72
80106491:	6a 48                	push   $0x48
  jmp alltraps
80106493:	e9 62 f8 ff ff       	jmp    80105cfa <alltraps>

80106498 <vector73>:
.globl vector73
vector73:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $73
8010649a:	6a 49                	push   $0x49
  jmp alltraps
8010649c:	e9 59 f8 ff ff       	jmp    80105cfa <alltraps>

801064a1 <vector74>:
.globl vector74
vector74:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $74
801064a3:	6a 4a                	push   $0x4a
  jmp alltraps
801064a5:	e9 50 f8 ff ff       	jmp    80105cfa <alltraps>

801064aa <vector75>:
.globl vector75
vector75:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $75
801064ac:	6a 4b                	push   $0x4b
  jmp alltraps
801064ae:	e9 47 f8 ff ff       	jmp    80105cfa <alltraps>

801064b3 <vector76>:
.globl vector76
vector76:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $76
801064b5:	6a 4c                	push   $0x4c
  jmp alltraps
801064b7:	e9 3e f8 ff ff       	jmp    80105cfa <alltraps>

801064bc <vector77>:
.globl vector77
vector77:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $77
801064be:	6a 4d                	push   $0x4d
  jmp alltraps
801064c0:	e9 35 f8 ff ff       	jmp    80105cfa <alltraps>

801064c5 <vector78>:
.globl vector78
vector78:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $78
801064c7:	6a 4e                	push   $0x4e
  jmp alltraps
801064c9:	e9 2c f8 ff ff       	jmp    80105cfa <alltraps>

801064ce <vector79>:
.globl vector79
vector79:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $79
801064d0:	6a 4f                	push   $0x4f
  jmp alltraps
801064d2:	e9 23 f8 ff ff       	jmp    80105cfa <alltraps>

801064d7 <vector80>:
.globl vector80
vector80:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $80
801064d9:	6a 50                	push   $0x50
  jmp alltraps
801064db:	e9 1a f8 ff ff       	jmp    80105cfa <alltraps>

801064e0 <vector81>:
.globl vector81
vector81:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $81
801064e2:	6a 51                	push   $0x51
  jmp alltraps
801064e4:	e9 11 f8 ff ff       	jmp    80105cfa <alltraps>

801064e9 <vector82>:
.globl vector82
vector82:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $82
801064eb:	6a 52                	push   $0x52
  jmp alltraps
801064ed:	e9 08 f8 ff ff       	jmp    80105cfa <alltraps>

801064f2 <vector83>:
.globl vector83
vector83:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $83
801064f4:	6a 53                	push   $0x53
  jmp alltraps
801064f6:	e9 ff f7 ff ff       	jmp    80105cfa <alltraps>

801064fb <vector84>:
.globl vector84
vector84:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $84
801064fd:	6a 54                	push   $0x54
  jmp alltraps
801064ff:	e9 f6 f7 ff ff       	jmp    80105cfa <alltraps>

80106504 <vector85>:
.globl vector85
vector85:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $85
80106506:	6a 55                	push   $0x55
  jmp alltraps
80106508:	e9 ed f7 ff ff       	jmp    80105cfa <alltraps>

8010650d <vector86>:
.globl vector86
vector86:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $86
8010650f:	6a 56                	push   $0x56
  jmp alltraps
80106511:	e9 e4 f7 ff ff       	jmp    80105cfa <alltraps>

80106516 <vector87>:
.globl vector87
vector87:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $87
80106518:	6a 57                	push   $0x57
  jmp alltraps
8010651a:	e9 db f7 ff ff       	jmp    80105cfa <alltraps>

8010651f <vector88>:
.globl vector88
vector88:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $88
80106521:	6a 58                	push   $0x58
  jmp alltraps
80106523:	e9 d2 f7 ff ff       	jmp    80105cfa <alltraps>

80106528 <vector89>:
.globl vector89
vector89:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $89
8010652a:	6a 59                	push   $0x59
  jmp alltraps
8010652c:	e9 c9 f7 ff ff       	jmp    80105cfa <alltraps>

80106531 <vector90>:
.globl vector90
vector90:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $90
80106533:	6a 5a                	push   $0x5a
  jmp alltraps
80106535:	e9 c0 f7 ff ff       	jmp    80105cfa <alltraps>

8010653a <vector91>:
.globl vector91
vector91:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $91
8010653c:	6a 5b                	push   $0x5b
  jmp alltraps
8010653e:	e9 b7 f7 ff ff       	jmp    80105cfa <alltraps>

80106543 <vector92>:
.globl vector92
vector92:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $92
80106545:	6a 5c                	push   $0x5c
  jmp alltraps
80106547:	e9 ae f7 ff ff       	jmp    80105cfa <alltraps>

8010654c <vector93>:
.globl vector93
vector93:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $93
8010654e:	6a 5d                	push   $0x5d
  jmp alltraps
80106550:	e9 a5 f7 ff ff       	jmp    80105cfa <alltraps>

80106555 <vector94>:
.globl vector94
vector94:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $94
80106557:	6a 5e                	push   $0x5e
  jmp alltraps
80106559:	e9 9c f7 ff ff       	jmp    80105cfa <alltraps>

8010655e <vector95>:
.globl vector95
vector95:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $95
80106560:	6a 5f                	push   $0x5f
  jmp alltraps
80106562:	e9 93 f7 ff ff       	jmp    80105cfa <alltraps>

80106567 <vector96>:
.globl vector96
vector96:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $96
80106569:	6a 60                	push   $0x60
  jmp alltraps
8010656b:	e9 8a f7 ff ff       	jmp    80105cfa <alltraps>

80106570 <vector97>:
.globl vector97
vector97:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $97
80106572:	6a 61                	push   $0x61
  jmp alltraps
80106574:	e9 81 f7 ff ff       	jmp    80105cfa <alltraps>

80106579 <vector98>:
.globl vector98
vector98:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $98
8010657b:	6a 62                	push   $0x62
  jmp alltraps
8010657d:	e9 78 f7 ff ff       	jmp    80105cfa <alltraps>

80106582 <vector99>:
.globl vector99
vector99:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $99
80106584:	6a 63                	push   $0x63
  jmp alltraps
80106586:	e9 6f f7 ff ff       	jmp    80105cfa <alltraps>

8010658b <vector100>:
.globl vector100
vector100:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $100
8010658d:	6a 64                	push   $0x64
  jmp alltraps
8010658f:	e9 66 f7 ff ff       	jmp    80105cfa <alltraps>

80106594 <vector101>:
.globl vector101
vector101:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $101
80106596:	6a 65                	push   $0x65
  jmp alltraps
80106598:	e9 5d f7 ff ff       	jmp    80105cfa <alltraps>

8010659d <vector102>:
.globl vector102
vector102:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $102
8010659f:	6a 66                	push   $0x66
  jmp alltraps
801065a1:	e9 54 f7 ff ff       	jmp    80105cfa <alltraps>

801065a6 <vector103>:
.globl vector103
vector103:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $103
801065a8:	6a 67                	push   $0x67
  jmp alltraps
801065aa:	e9 4b f7 ff ff       	jmp    80105cfa <alltraps>

801065af <vector104>:
.globl vector104
vector104:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $104
801065b1:	6a 68                	push   $0x68
  jmp alltraps
801065b3:	e9 42 f7 ff ff       	jmp    80105cfa <alltraps>

801065b8 <vector105>:
.globl vector105
vector105:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $105
801065ba:	6a 69                	push   $0x69
  jmp alltraps
801065bc:	e9 39 f7 ff ff       	jmp    80105cfa <alltraps>

801065c1 <vector106>:
.globl vector106
vector106:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $106
801065c3:	6a 6a                	push   $0x6a
  jmp alltraps
801065c5:	e9 30 f7 ff ff       	jmp    80105cfa <alltraps>

801065ca <vector107>:
.globl vector107
vector107:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $107
801065cc:	6a 6b                	push   $0x6b
  jmp alltraps
801065ce:	e9 27 f7 ff ff       	jmp    80105cfa <alltraps>

801065d3 <vector108>:
.globl vector108
vector108:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $108
801065d5:	6a 6c                	push   $0x6c
  jmp alltraps
801065d7:	e9 1e f7 ff ff       	jmp    80105cfa <alltraps>

801065dc <vector109>:
.globl vector109
vector109:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $109
801065de:	6a 6d                	push   $0x6d
  jmp alltraps
801065e0:	e9 15 f7 ff ff       	jmp    80105cfa <alltraps>

801065e5 <vector110>:
.globl vector110
vector110:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $110
801065e7:	6a 6e                	push   $0x6e
  jmp alltraps
801065e9:	e9 0c f7 ff ff       	jmp    80105cfa <alltraps>

801065ee <vector111>:
.globl vector111
vector111:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $111
801065f0:	6a 6f                	push   $0x6f
  jmp alltraps
801065f2:	e9 03 f7 ff ff       	jmp    80105cfa <alltraps>

801065f7 <vector112>:
.globl vector112
vector112:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $112
801065f9:	6a 70                	push   $0x70
  jmp alltraps
801065fb:	e9 fa f6 ff ff       	jmp    80105cfa <alltraps>

80106600 <vector113>:
.globl vector113
vector113:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $113
80106602:	6a 71                	push   $0x71
  jmp alltraps
80106604:	e9 f1 f6 ff ff       	jmp    80105cfa <alltraps>

80106609 <vector114>:
.globl vector114
vector114:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $114
8010660b:	6a 72                	push   $0x72
  jmp alltraps
8010660d:	e9 e8 f6 ff ff       	jmp    80105cfa <alltraps>

80106612 <vector115>:
.globl vector115
vector115:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $115
80106614:	6a 73                	push   $0x73
  jmp alltraps
80106616:	e9 df f6 ff ff       	jmp    80105cfa <alltraps>

8010661b <vector116>:
.globl vector116
vector116:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $116
8010661d:	6a 74                	push   $0x74
  jmp alltraps
8010661f:	e9 d6 f6 ff ff       	jmp    80105cfa <alltraps>

80106624 <vector117>:
.globl vector117
vector117:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $117
80106626:	6a 75                	push   $0x75
  jmp alltraps
80106628:	e9 cd f6 ff ff       	jmp    80105cfa <alltraps>

8010662d <vector118>:
.globl vector118
vector118:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $118
8010662f:	6a 76                	push   $0x76
  jmp alltraps
80106631:	e9 c4 f6 ff ff       	jmp    80105cfa <alltraps>

80106636 <vector119>:
.globl vector119
vector119:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $119
80106638:	6a 77                	push   $0x77
  jmp alltraps
8010663a:	e9 bb f6 ff ff       	jmp    80105cfa <alltraps>

8010663f <vector120>:
.globl vector120
vector120:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $120
80106641:	6a 78                	push   $0x78
  jmp alltraps
80106643:	e9 b2 f6 ff ff       	jmp    80105cfa <alltraps>

80106648 <vector121>:
.globl vector121
vector121:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $121
8010664a:	6a 79                	push   $0x79
  jmp alltraps
8010664c:	e9 a9 f6 ff ff       	jmp    80105cfa <alltraps>

80106651 <vector122>:
.globl vector122
vector122:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $122
80106653:	6a 7a                	push   $0x7a
  jmp alltraps
80106655:	e9 a0 f6 ff ff       	jmp    80105cfa <alltraps>

8010665a <vector123>:
.globl vector123
vector123:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $123
8010665c:	6a 7b                	push   $0x7b
  jmp alltraps
8010665e:	e9 97 f6 ff ff       	jmp    80105cfa <alltraps>

80106663 <vector124>:
.globl vector124
vector124:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $124
80106665:	6a 7c                	push   $0x7c
  jmp alltraps
80106667:	e9 8e f6 ff ff       	jmp    80105cfa <alltraps>

8010666c <vector125>:
.globl vector125
vector125:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $125
8010666e:	6a 7d                	push   $0x7d
  jmp alltraps
80106670:	e9 85 f6 ff ff       	jmp    80105cfa <alltraps>

80106675 <vector126>:
.globl vector126
vector126:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $126
80106677:	6a 7e                	push   $0x7e
  jmp alltraps
80106679:	e9 7c f6 ff ff       	jmp    80105cfa <alltraps>

8010667e <vector127>:
.globl vector127
vector127:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $127
80106680:	6a 7f                	push   $0x7f
  jmp alltraps
80106682:	e9 73 f6 ff ff       	jmp    80105cfa <alltraps>

80106687 <vector128>:
.globl vector128
vector128:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $128
80106689:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010668e:	e9 67 f6 ff ff       	jmp    80105cfa <alltraps>

80106693 <vector129>:
.globl vector129
vector129:
  pushl $0
80106693:	6a 00                	push   $0x0
  pushl $129
80106695:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010669a:	e9 5b f6 ff ff       	jmp    80105cfa <alltraps>

8010669f <vector130>:
.globl vector130
vector130:
  pushl $0
8010669f:	6a 00                	push   $0x0
  pushl $130
801066a1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801066a6:	e9 4f f6 ff ff       	jmp    80105cfa <alltraps>

801066ab <vector131>:
.globl vector131
vector131:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $131
801066ad:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801066b2:	e9 43 f6 ff ff       	jmp    80105cfa <alltraps>

801066b7 <vector132>:
.globl vector132
vector132:
  pushl $0
801066b7:	6a 00                	push   $0x0
  pushl $132
801066b9:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801066be:	e9 37 f6 ff ff       	jmp    80105cfa <alltraps>

801066c3 <vector133>:
.globl vector133
vector133:
  pushl $0
801066c3:	6a 00                	push   $0x0
  pushl $133
801066c5:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801066ca:	e9 2b f6 ff ff       	jmp    80105cfa <alltraps>

801066cf <vector134>:
.globl vector134
vector134:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $134
801066d1:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801066d6:	e9 1f f6 ff ff       	jmp    80105cfa <alltraps>

801066db <vector135>:
.globl vector135
vector135:
  pushl $0
801066db:	6a 00                	push   $0x0
  pushl $135
801066dd:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801066e2:	e9 13 f6 ff ff       	jmp    80105cfa <alltraps>

801066e7 <vector136>:
.globl vector136
vector136:
  pushl $0
801066e7:	6a 00                	push   $0x0
  pushl $136
801066e9:	68 88 00 00 00       	push   $0x88
  jmp alltraps
801066ee:	e9 07 f6 ff ff       	jmp    80105cfa <alltraps>

801066f3 <vector137>:
.globl vector137
vector137:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $137
801066f5:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801066fa:	e9 fb f5 ff ff       	jmp    80105cfa <alltraps>

801066ff <vector138>:
.globl vector138
vector138:
  pushl $0
801066ff:	6a 00                	push   $0x0
  pushl $138
80106701:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106706:	e9 ef f5 ff ff       	jmp    80105cfa <alltraps>

8010670b <vector139>:
.globl vector139
vector139:
  pushl $0
8010670b:	6a 00                	push   $0x0
  pushl $139
8010670d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106712:	e9 e3 f5 ff ff       	jmp    80105cfa <alltraps>

80106717 <vector140>:
.globl vector140
vector140:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $140
80106719:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010671e:	e9 d7 f5 ff ff       	jmp    80105cfa <alltraps>

80106723 <vector141>:
.globl vector141
vector141:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $141
80106725:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010672a:	e9 cb f5 ff ff       	jmp    80105cfa <alltraps>

8010672f <vector142>:
.globl vector142
vector142:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $142
80106731:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106736:	e9 bf f5 ff ff       	jmp    80105cfa <alltraps>

8010673b <vector143>:
.globl vector143
vector143:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $143
8010673d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106742:	e9 b3 f5 ff ff       	jmp    80105cfa <alltraps>

80106747 <vector144>:
.globl vector144
vector144:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $144
80106749:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010674e:	e9 a7 f5 ff ff       	jmp    80105cfa <alltraps>

80106753 <vector145>:
.globl vector145
vector145:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $145
80106755:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010675a:	e9 9b f5 ff ff       	jmp    80105cfa <alltraps>

8010675f <vector146>:
.globl vector146
vector146:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $146
80106761:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106766:	e9 8f f5 ff ff       	jmp    80105cfa <alltraps>

8010676b <vector147>:
.globl vector147
vector147:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $147
8010676d:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106772:	e9 83 f5 ff ff       	jmp    80105cfa <alltraps>

80106777 <vector148>:
.globl vector148
vector148:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $148
80106779:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010677e:	e9 77 f5 ff ff       	jmp    80105cfa <alltraps>

80106783 <vector149>:
.globl vector149
vector149:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $149
80106785:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010678a:	e9 6b f5 ff ff       	jmp    80105cfa <alltraps>

8010678f <vector150>:
.globl vector150
vector150:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $150
80106791:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106796:	e9 5f f5 ff ff       	jmp    80105cfa <alltraps>

8010679b <vector151>:
.globl vector151
vector151:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $151
8010679d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801067a2:	e9 53 f5 ff ff       	jmp    80105cfa <alltraps>

801067a7 <vector152>:
.globl vector152
vector152:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $152
801067a9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801067ae:	e9 47 f5 ff ff       	jmp    80105cfa <alltraps>

801067b3 <vector153>:
.globl vector153
vector153:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $153
801067b5:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801067ba:	e9 3b f5 ff ff       	jmp    80105cfa <alltraps>

801067bf <vector154>:
.globl vector154
vector154:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $154
801067c1:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801067c6:	e9 2f f5 ff ff       	jmp    80105cfa <alltraps>

801067cb <vector155>:
.globl vector155
vector155:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $155
801067cd:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801067d2:	e9 23 f5 ff ff       	jmp    80105cfa <alltraps>

801067d7 <vector156>:
.globl vector156
vector156:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $156
801067d9:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801067de:	e9 17 f5 ff ff       	jmp    80105cfa <alltraps>

801067e3 <vector157>:
.globl vector157
vector157:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $157
801067e5:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
801067ea:	e9 0b f5 ff ff       	jmp    80105cfa <alltraps>

801067ef <vector158>:
.globl vector158
vector158:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $158
801067f1:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801067f6:	e9 ff f4 ff ff       	jmp    80105cfa <alltraps>

801067fb <vector159>:
.globl vector159
vector159:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $159
801067fd:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106802:	e9 f3 f4 ff ff       	jmp    80105cfa <alltraps>

80106807 <vector160>:
.globl vector160
vector160:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $160
80106809:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010680e:	e9 e7 f4 ff ff       	jmp    80105cfa <alltraps>

80106813 <vector161>:
.globl vector161
vector161:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $161
80106815:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010681a:	e9 db f4 ff ff       	jmp    80105cfa <alltraps>

8010681f <vector162>:
.globl vector162
vector162:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $162
80106821:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106826:	e9 cf f4 ff ff       	jmp    80105cfa <alltraps>

8010682b <vector163>:
.globl vector163
vector163:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $163
8010682d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106832:	e9 c3 f4 ff ff       	jmp    80105cfa <alltraps>

80106837 <vector164>:
.globl vector164
vector164:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $164
80106839:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010683e:	e9 b7 f4 ff ff       	jmp    80105cfa <alltraps>

80106843 <vector165>:
.globl vector165
vector165:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $165
80106845:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010684a:	e9 ab f4 ff ff       	jmp    80105cfa <alltraps>

8010684f <vector166>:
.globl vector166
vector166:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $166
80106851:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106856:	e9 9f f4 ff ff       	jmp    80105cfa <alltraps>

8010685b <vector167>:
.globl vector167
vector167:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $167
8010685d:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106862:	e9 93 f4 ff ff       	jmp    80105cfa <alltraps>

80106867 <vector168>:
.globl vector168
vector168:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $168
80106869:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010686e:	e9 87 f4 ff ff       	jmp    80105cfa <alltraps>

80106873 <vector169>:
.globl vector169
vector169:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $169
80106875:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010687a:	e9 7b f4 ff ff       	jmp    80105cfa <alltraps>

8010687f <vector170>:
.globl vector170
vector170:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $170
80106881:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106886:	e9 6f f4 ff ff       	jmp    80105cfa <alltraps>

8010688b <vector171>:
.globl vector171
vector171:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $171
8010688d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106892:	e9 63 f4 ff ff       	jmp    80105cfa <alltraps>

80106897 <vector172>:
.globl vector172
vector172:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $172
80106899:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010689e:	e9 57 f4 ff ff       	jmp    80105cfa <alltraps>

801068a3 <vector173>:
.globl vector173
vector173:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $173
801068a5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801068aa:	e9 4b f4 ff ff       	jmp    80105cfa <alltraps>

801068af <vector174>:
.globl vector174
vector174:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $174
801068b1:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801068b6:	e9 3f f4 ff ff       	jmp    80105cfa <alltraps>

801068bb <vector175>:
.globl vector175
vector175:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $175
801068bd:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801068c2:	e9 33 f4 ff ff       	jmp    80105cfa <alltraps>

801068c7 <vector176>:
.globl vector176
vector176:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $176
801068c9:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801068ce:	e9 27 f4 ff ff       	jmp    80105cfa <alltraps>

801068d3 <vector177>:
.globl vector177
vector177:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $177
801068d5:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801068da:	e9 1b f4 ff ff       	jmp    80105cfa <alltraps>

801068df <vector178>:
.globl vector178
vector178:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $178
801068e1:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
801068e6:	e9 0f f4 ff ff       	jmp    80105cfa <alltraps>

801068eb <vector179>:
.globl vector179
vector179:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $179
801068ed:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801068f2:	e9 03 f4 ff ff       	jmp    80105cfa <alltraps>

801068f7 <vector180>:
.globl vector180
vector180:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $180
801068f9:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801068fe:	e9 f7 f3 ff ff       	jmp    80105cfa <alltraps>

80106903 <vector181>:
.globl vector181
vector181:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $181
80106905:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010690a:	e9 eb f3 ff ff       	jmp    80105cfa <alltraps>

8010690f <vector182>:
.globl vector182
vector182:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $182
80106911:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106916:	e9 df f3 ff ff       	jmp    80105cfa <alltraps>

8010691b <vector183>:
.globl vector183
vector183:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $183
8010691d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106922:	e9 d3 f3 ff ff       	jmp    80105cfa <alltraps>

80106927 <vector184>:
.globl vector184
vector184:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $184
80106929:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010692e:	e9 c7 f3 ff ff       	jmp    80105cfa <alltraps>

80106933 <vector185>:
.globl vector185
vector185:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $185
80106935:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010693a:	e9 bb f3 ff ff       	jmp    80105cfa <alltraps>

8010693f <vector186>:
.globl vector186
vector186:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $186
80106941:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106946:	e9 af f3 ff ff       	jmp    80105cfa <alltraps>

8010694b <vector187>:
.globl vector187
vector187:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $187
8010694d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106952:	e9 a3 f3 ff ff       	jmp    80105cfa <alltraps>

80106957 <vector188>:
.globl vector188
vector188:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $188
80106959:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010695e:	e9 97 f3 ff ff       	jmp    80105cfa <alltraps>

80106963 <vector189>:
.globl vector189
vector189:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $189
80106965:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
8010696a:	e9 8b f3 ff ff       	jmp    80105cfa <alltraps>

8010696f <vector190>:
.globl vector190
vector190:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $190
80106971:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106976:	e9 7f f3 ff ff       	jmp    80105cfa <alltraps>

8010697b <vector191>:
.globl vector191
vector191:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $191
8010697d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106982:	e9 73 f3 ff ff       	jmp    80105cfa <alltraps>

80106987 <vector192>:
.globl vector192
vector192:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $192
80106989:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010698e:	e9 67 f3 ff ff       	jmp    80105cfa <alltraps>

80106993 <vector193>:
.globl vector193
vector193:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $193
80106995:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
8010699a:	e9 5b f3 ff ff       	jmp    80105cfa <alltraps>

8010699f <vector194>:
.globl vector194
vector194:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $194
801069a1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801069a6:	e9 4f f3 ff ff       	jmp    80105cfa <alltraps>

801069ab <vector195>:
.globl vector195
vector195:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $195
801069ad:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
801069b2:	e9 43 f3 ff ff       	jmp    80105cfa <alltraps>

801069b7 <vector196>:
.globl vector196
vector196:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $196
801069b9:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
801069be:	e9 37 f3 ff ff       	jmp    80105cfa <alltraps>

801069c3 <vector197>:
.globl vector197
vector197:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $197
801069c5:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
801069ca:	e9 2b f3 ff ff       	jmp    80105cfa <alltraps>

801069cf <vector198>:
.globl vector198
vector198:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $198
801069d1:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
801069d6:	e9 1f f3 ff ff       	jmp    80105cfa <alltraps>

801069db <vector199>:
.globl vector199
vector199:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $199
801069dd:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
801069e2:	e9 13 f3 ff ff       	jmp    80105cfa <alltraps>

801069e7 <vector200>:
.globl vector200
vector200:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $200
801069e9:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
801069ee:	e9 07 f3 ff ff       	jmp    80105cfa <alltraps>

801069f3 <vector201>:
.globl vector201
vector201:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $201
801069f5:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801069fa:	e9 fb f2 ff ff       	jmp    80105cfa <alltraps>

801069ff <vector202>:
.globl vector202
vector202:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $202
80106a01:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a06:	e9 ef f2 ff ff       	jmp    80105cfa <alltraps>

80106a0b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $203
80106a0d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106a12:	e9 e3 f2 ff ff       	jmp    80105cfa <alltraps>

80106a17 <vector204>:
.globl vector204
vector204:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $204
80106a19:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106a1e:	e9 d7 f2 ff ff       	jmp    80105cfa <alltraps>

80106a23 <vector205>:
.globl vector205
vector205:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $205
80106a25:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106a2a:	e9 cb f2 ff ff       	jmp    80105cfa <alltraps>

80106a2f <vector206>:
.globl vector206
vector206:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $206
80106a31:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106a36:	e9 bf f2 ff ff       	jmp    80105cfa <alltraps>

80106a3b <vector207>:
.globl vector207
vector207:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $207
80106a3d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106a42:	e9 b3 f2 ff ff       	jmp    80105cfa <alltraps>

80106a47 <vector208>:
.globl vector208
vector208:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $208
80106a49:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106a4e:	e9 a7 f2 ff ff       	jmp    80105cfa <alltraps>

80106a53 <vector209>:
.globl vector209
vector209:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $209
80106a55:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106a5a:	e9 9b f2 ff ff       	jmp    80105cfa <alltraps>

80106a5f <vector210>:
.globl vector210
vector210:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $210
80106a61:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106a66:	e9 8f f2 ff ff       	jmp    80105cfa <alltraps>

80106a6b <vector211>:
.globl vector211
vector211:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $211
80106a6d:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106a72:	e9 83 f2 ff ff       	jmp    80105cfa <alltraps>

80106a77 <vector212>:
.globl vector212
vector212:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $212
80106a79:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106a7e:	e9 77 f2 ff ff       	jmp    80105cfa <alltraps>

80106a83 <vector213>:
.globl vector213
vector213:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $213
80106a85:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106a8a:	e9 6b f2 ff ff       	jmp    80105cfa <alltraps>

80106a8f <vector214>:
.globl vector214
vector214:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $214
80106a91:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106a96:	e9 5f f2 ff ff       	jmp    80105cfa <alltraps>

80106a9b <vector215>:
.globl vector215
vector215:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $215
80106a9d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106aa2:	e9 53 f2 ff ff       	jmp    80105cfa <alltraps>

80106aa7 <vector216>:
.globl vector216
vector216:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $216
80106aa9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106aae:	e9 47 f2 ff ff       	jmp    80105cfa <alltraps>

80106ab3 <vector217>:
.globl vector217
vector217:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $217
80106ab5:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106aba:	e9 3b f2 ff ff       	jmp    80105cfa <alltraps>

80106abf <vector218>:
.globl vector218
vector218:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $218
80106ac1:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106ac6:	e9 2f f2 ff ff       	jmp    80105cfa <alltraps>

80106acb <vector219>:
.globl vector219
vector219:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $219
80106acd:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106ad2:	e9 23 f2 ff ff       	jmp    80105cfa <alltraps>

80106ad7 <vector220>:
.globl vector220
vector220:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $220
80106ad9:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106ade:	e9 17 f2 ff ff       	jmp    80105cfa <alltraps>

80106ae3 <vector221>:
.globl vector221
vector221:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $221
80106ae5:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106aea:	e9 0b f2 ff ff       	jmp    80105cfa <alltraps>

80106aef <vector222>:
.globl vector222
vector222:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $222
80106af1:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106af6:	e9 ff f1 ff ff       	jmp    80105cfa <alltraps>

80106afb <vector223>:
.globl vector223
vector223:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $223
80106afd:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b02:	e9 f3 f1 ff ff       	jmp    80105cfa <alltraps>

80106b07 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $224
80106b09:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b0e:	e9 e7 f1 ff ff       	jmp    80105cfa <alltraps>

80106b13 <vector225>:
.globl vector225
vector225:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $225
80106b15:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106b1a:	e9 db f1 ff ff       	jmp    80105cfa <alltraps>

80106b1f <vector226>:
.globl vector226
vector226:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $226
80106b21:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106b26:	e9 cf f1 ff ff       	jmp    80105cfa <alltraps>

80106b2b <vector227>:
.globl vector227
vector227:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $227
80106b2d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106b32:	e9 c3 f1 ff ff       	jmp    80105cfa <alltraps>

80106b37 <vector228>:
.globl vector228
vector228:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $228
80106b39:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106b3e:	e9 b7 f1 ff ff       	jmp    80105cfa <alltraps>

80106b43 <vector229>:
.globl vector229
vector229:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $229
80106b45:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106b4a:	e9 ab f1 ff ff       	jmp    80105cfa <alltraps>

80106b4f <vector230>:
.globl vector230
vector230:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $230
80106b51:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106b56:	e9 9f f1 ff ff       	jmp    80105cfa <alltraps>

80106b5b <vector231>:
.globl vector231
vector231:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $231
80106b5d:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106b62:	e9 93 f1 ff ff       	jmp    80105cfa <alltraps>

80106b67 <vector232>:
.globl vector232
vector232:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $232
80106b69:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106b6e:	e9 87 f1 ff ff       	jmp    80105cfa <alltraps>

80106b73 <vector233>:
.globl vector233
vector233:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $233
80106b75:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106b7a:	e9 7b f1 ff ff       	jmp    80105cfa <alltraps>

80106b7f <vector234>:
.globl vector234
vector234:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $234
80106b81:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106b86:	e9 6f f1 ff ff       	jmp    80105cfa <alltraps>

80106b8b <vector235>:
.globl vector235
vector235:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $235
80106b8d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106b92:	e9 63 f1 ff ff       	jmp    80105cfa <alltraps>

80106b97 <vector236>:
.globl vector236
vector236:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $236
80106b99:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106b9e:	e9 57 f1 ff ff       	jmp    80105cfa <alltraps>

80106ba3 <vector237>:
.globl vector237
vector237:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $237
80106ba5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106baa:	e9 4b f1 ff ff       	jmp    80105cfa <alltraps>

80106baf <vector238>:
.globl vector238
vector238:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $238
80106bb1:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106bb6:	e9 3f f1 ff ff       	jmp    80105cfa <alltraps>

80106bbb <vector239>:
.globl vector239
vector239:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $239
80106bbd:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106bc2:	e9 33 f1 ff ff       	jmp    80105cfa <alltraps>

80106bc7 <vector240>:
.globl vector240
vector240:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $240
80106bc9:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106bce:	e9 27 f1 ff ff       	jmp    80105cfa <alltraps>

80106bd3 <vector241>:
.globl vector241
vector241:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $241
80106bd5:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106bda:	e9 1b f1 ff ff       	jmp    80105cfa <alltraps>

80106bdf <vector242>:
.globl vector242
vector242:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $242
80106be1:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106be6:	e9 0f f1 ff ff       	jmp    80105cfa <alltraps>

80106beb <vector243>:
.globl vector243
vector243:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $243
80106bed:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106bf2:	e9 03 f1 ff ff       	jmp    80105cfa <alltraps>

80106bf7 <vector244>:
.globl vector244
vector244:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $244
80106bf9:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106bfe:	e9 f7 f0 ff ff       	jmp    80105cfa <alltraps>

80106c03 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $245
80106c05:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c0a:	e9 eb f0 ff ff       	jmp    80105cfa <alltraps>

80106c0f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $246
80106c11:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106c16:	e9 df f0 ff ff       	jmp    80105cfa <alltraps>

80106c1b <vector247>:
.globl vector247
vector247:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $247
80106c1d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106c22:	e9 d3 f0 ff ff       	jmp    80105cfa <alltraps>

80106c27 <vector248>:
.globl vector248
vector248:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $248
80106c29:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106c2e:	e9 c7 f0 ff ff       	jmp    80105cfa <alltraps>

80106c33 <vector249>:
.globl vector249
vector249:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $249
80106c35:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106c3a:	e9 bb f0 ff ff       	jmp    80105cfa <alltraps>

80106c3f <vector250>:
.globl vector250
vector250:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $250
80106c41:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106c46:	e9 af f0 ff ff       	jmp    80105cfa <alltraps>

80106c4b <vector251>:
.globl vector251
vector251:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $251
80106c4d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106c52:	e9 a3 f0 ff ff       	jmp    80105cfa <alltraps>

80106c57 <vector252>:
.globl vector252
vector252:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $252
80106c59:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106c5e:	e9 97 f0 ff ff       	jmp    80105cfa <alltraps>

80106c63 <vector253>:
.globl vector253
vector253:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $253
80106c65:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106c6a:	e9 8b f0 ff ff       	jmp    80105cfa <alltraps>

80106c6f <vector254>:
.globl vector254
vector254:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $254
80106c71:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106c76:	e9 7f f0 ff ff       	jmp    80105cfa <alltraps>

80106c7b <vector255>:
.globl vector255
vector255:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $255
80106c7d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106c82:	e9 73 f0 ff ff       	jmp    80105cfa <alltraps>
80106c87:	66 90                	xchg   %ax,%ax
80106c89:	66 90                	xchg   %ax,%ax
80106c8b:	66 90                	xchg   %ax,%ax
80106c8d:	66 90                	xchg   %ax,%ax
80106c8f:	90                   	nop

80106c90 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106c90:	55                   	push   %ebp
80106c91:	89 e5                	mov    %esp,%ebp
80106c93:	57                   	push   %edi
80106c94:	56                   	push   %esi
80106c95:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106c96:	89 d3                	mov    %edx,%ebx
{
80106c98:	89 d7                	mov    %edx,%edi
  pde = &pgdir[PDX(va)];
80106c9a:	c1 eb 16             	shr    $0x16,%ebx
80106c9d:	8d 34 98             	lea    (%eax,%ebx,4),%esi
{
80106ca0:	83 ec 0c             	sub    $0xc,%esp
  if(*pde & PTE_P){
80106ca3:	8b 06                	mov    (%esi),%eax
80106ca5:	a8 01                	test   $0x1,%al
80106ca7:	74 27                	je     80106cd0 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106ca9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106cae:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106cb4:	c1 ef 0a             	shr    $0xa,%edi
}
80106cb7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return &pgtab[PTX(va)];
80106cba:	89 fa                	mov    %edi,%edx
80106cbc:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106cc2:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106cc5:	5b                   	pop    %ebx
80106cc6:	5e                   	pop    %esi
80106cc7:	5f                   	pop    %edi
80106cc8:	5d                   	pop    %ebp
80106cc9:	c3                   	ret    
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106cd0:	85 c9                	test   %ecx,%ecx
80106cd2:	74 2c                	je     80106d00 <walkpgdir+0x70>
80106cd4:	e8 97 b9 ff ff       	call   80102670 <kalloc>
80106cd9:	85 c0                	test   %eax,%eax
80106cdb:	89 c3                	mov    %eax,%ebx
80106cdd:	74 21                	je     80106d00 <walkpgdir+0x70>
    memset(pgtab, 0, PGSIZE);
80106cdf:	83 ec 04             	sub    $0x4,%esp
80106ce2:	68 00 10 00 00       	push   $0x1000
80106ce7:	6a 00                	push   $0x0
80106ce9:	50                   	push   %eax
80106cea:	e8 81 dd ff ff       	call   80104a70 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106cef:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106cf5:	83 c4 10             	add    $0x10,%esp
80106cf8:	83 c8 07             	or     $0x7,%eax
80106cfb:	89 06                	mov    %eax,(%esi)
80106cfd:	eb b5                	jmp    80106cb4 <walkpgdir+0x24>
80106cff:	90                   	nop
}
80106d00:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
80106d03:	31 c0                	xor    %eax,%eax
}
80106d05:	5b                   	pop    %ebx
80106d06:	5e                   	pop    %esi
80106d07:	5f                   	pop    %edi
80106d08:	5d                   	pop    %ebp
80106d09:	c3                   	ret    
80106d0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d10 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	57                   	push   %edi
80106d14:	56                   	push   %esi
80106d15:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106d16:	89 d3                	mov    %edx,%ebx
80106d18:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106d1e:	83 ec 1c             	sub    $0x1c,%esp
80106d21:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106d24:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106d28:	8b 7d 08             	mov    0x8(%ebp),%edi
80106d2b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d30:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106d33:	8b 45 0c             	mov    0xc(%ebp),%eax
80106d36:	29 df                	sub    %ebx,%edi
80106d38:	83 c8 01             	or     $0x1,%eax
80106d3b:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106d3e:	eb 15                	jmp    80106d55 <mappages+0x45>
    if(*pte & PTE_P)
80106d40:	f6 00 01             	testb  $0x1,(%eax)
80106d43:	75 45                	jne    80106d8a <mappages+0x7a>
    *pte = pa | perm | PTE_P;
80106d45:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106d48:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
    *pte = pa | perm | PTE_P;
80106d4b:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106d4d:	74 31                	je     80106d80 <mappages+0x70>
      break;
    a += PGSIZE;
80106d4f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106d55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106d58:	b9 01 00 00 00       	mov    $0x1,%ecx
80106d5d:	89 da                	mov    %ebx,%edx
80106d5f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106d62:	e8 29 ff ff ff       	call   80106c90 <walkpgdir>
80106d67:	85 c0                	test   %eax,%eax
80106d69:	75 d5                	jne    80106d40 <mappages+0x30>
    pa += PGSIZE;
  }
  return 0;
}
80106d6b:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106d6e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106d73:	5b                   	pop    %ebx
80106d74:	5e                   	pop    %esi
80106d75:	5f                   	pop    %edi
80106d76:	5d                   	pop    %ebp
80106d77:	c3                   	ret    
80106d78:	90                   	nop
80106d79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d80:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106d83:	31 c0                	xor    %eax,%eax
}
80106d85:	5b                   	pop    %ebx
80106d86:	5e                   	pop    %esi
80106d87:	5f                   	pop    %edi
80106d88:	5d                   	pop    %ebp
80106d89:	c3                   	ret    
      panic("remap");
80106d8a:	83 ec 0c             	sub    $0xc,%esp
80106d8d:	68 3c 7f 10 80       	push   $0x80107f3c
80106d92:	e8 f9 95 ff ff       	call   80100390 <panic>
80106d97:	89 f6                	mov    %esi,%esi
80106d99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106da0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106da0:	55                   	push   %ebp
80106da1:	89 e5                	mov    %esp,%ebp
80106da3:	57                   	push   %edi
80106da4:	56                   	push   %esi
80106da5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106da6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106dac:	89 c7                	mov    %eax,%edi
  a = PGROUNDUP(newsz);
80106dae:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106db4:	83 ec 1c             	sub    $0x1c,%esp
80106db7:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106dba:	39 d3                	cmp    %edx,%ebx
80106dbc:	73 66                	jae    80106e24 <deallocuvm.part.0+0x84>
80106dbe:	89 d6                	mov    %edx,%esi
80106dc0:	eb 3d                	jmp    80106dff <deallocuvm.part.0+0x5f>
80106dc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106dc8:	8b 10                	mov    (%eax),%edx
80106dca:	f6 c2 01             	test   $0x1,%dl
80106dcd:	74 26                	je     80106df5 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106dcf:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106dd5:	74 58                	je     80106e2f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106dd7:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106dda:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106de0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      kfree(v);
80106de3:	52                   	push   %edx
80106de4:	e8 d7 b6 ff ff       	call   801024c0 <kfree>
      *pte = 0;
80106de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106dec:	83 c4 10             	add    $0x10,%esp
80106def:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; a  < oldsz; a += PGSIZE){
80106df5:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106dfb:	39 f3                	cmp    %esi,%ebx
80106dfd:	73 25                	jae    80106e24 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106dff:	31 c9                	xor    %ecx,%ecx
80106e01:	89 da                	mov    %ebx,%edx
80106e03:	89 f8                	mov    %edi,%eax
80106e05:	e8 86 fe ff ff       	call   80106c90 <walkpgdir>
    if(!pte)
80106e0a:	85 c0                	test   %eax,%eax
80106e0c:	75 ba                	jne    80106dc8 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106e0e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106e14:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106e1a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106e20:	39 f3                	cmp    %esi,%ebx
80106e22:	72 db                	jb     80106dff <deallocuvm.part.0+0x5f>
    }
  }
  return newsz;
}
80106e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106e27:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106e2a:	5b                   	pop    %ebx
80106e2b:	5e                   	pop    %esi
80106e2c:	5f                   	pop    %edi
80106e2d:	5d                   	pop    %ebp
80106e2e:	c3                   	ret    
        panic("kfree");
80106e2f:	83 ec 0c             	sub    $0xc,%esp
80106e32:	68 a6 78 10 80       	push   $0x801078a6
80106e37:	e8 54 95 ff ff       	call   80100390 <panic>
80106e3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e40 <seginit>:
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106e46:	e8 45 cb ff ff       	call   80103990 <cpuid>
80106e4b:	69 c0 b4 00 00 00    	imul   $0xb4,%eax,%eax
  pd[0] = size-1;
80106e51:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106e56:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106e5a:	c7 80 38 3a 11 80 ff 	movl   $0xffff,-0x7feec5c8(%eax)
80106e61:	ff 00 00 
80106e64:	c7 80 3c 3a 11 80 00 	movl   $0xcf9a00,-0x7feec5c4(%eax)
80106e6b:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106e6e:	c7 80 40 3a 11 80 ff 	movl   $0xffff,-0x7feec5c0(%eax)
80106e75:	ff 00 00 
80106e78:	c7 80 44 3a 11 80 00 	movl   $0xcf9200,-0x7feec5bc(%eax)
80106e7f:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106e82:	c7 80 48 3a 11 80 ff 	movl   $0xffff,-0x7feec5b8(%eax)
80106e89:	ff 00 00 
80106e8c:	c7 80 4c 3a 11 80 00 	movl   $0xcffa00,-0x7feec5b4(%eax)
80106e93:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106e96:	c7 80 50 3a 11 80 ff 	movl   $0xffff,-0x7feec5b0(%eax)
80106e9d:	ff 00 00 
80106ea0:	c7 80 54 3a 11 80 00 	movl   $0xcff200,-0x7feec5ac(%eax)
80106ea7:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106eaa:	05 30 3a 11 80       	add    $0x80113a30,%eax
  pd[1] = (uint)p;
80106eaf:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106eb3:	c1 e8 10             	shr    $0x10,%eax
80106eb6:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106eba:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106ebd:	0f 01 10             	lgdtl  (%eax)
}
80106ec0:	c9                   	leave  
80106ec1:	c3                   	ret    
80106ec2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ec9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ed0 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ed0:	a1 04 6c 11 80       	mov    0x80116c04,%eax
{
80106ed5:	55                   	push   %ebp
80106ed6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106ed8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106edd:	0f 22 d8             	mov    %eax,%cr3
}
80106ee0:	5d                   	pop    %ebp
80106ee1:	c3                   	ret    
80106ee2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ee9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ef0 <switchuvm>:
{
80106ef0:	55                   	push   %ebp
80106ef1:	89 e5                	mov    %esp,%ebp
80106ef3:	57                   	push   %edi
80106ef4:	56                   	push   %esi
80106ef5:	53                   	push   %ebx
80106ef6:	83 ec 1c             	sub    $0x1c,%esp
80106ef9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(p == 0)
80106efc:	85 db                	test   %ebx,%ebx
80106efe:	0f 84 cb 00 00 00    	je     80106fcf <switchuvm+0xdf>
  if(p->kstack == 0)
80106f04:	8b 43 08             	mov    0x8(%ebx),%eax
80106f07:	85 c0                	test   %eax,%eax
80106f09:	0f 84 da 00 00 00    	je     80106fe9 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f0f:	8b 43 04             	mov    0x4(%ebx),%eax
80106f12:	85 c0                	test   %eax,%eax
80106f14:	0f 84 c2 00 00 00    	je     80106fdc <switchuvm+0xec>
  pushcli();
80106f1a:	e8 71 d9 ff ff       	call   80104890 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f1f:	e8 ec c9 ff ff       	call   80103910 <mycpu>
80106f24:	89 c6                	mov    %eax,%esi
80106f26:	e8 e5 c9 ff ff       	call   80103910 <mycpu>
80106f2b:	89 c7                	mov    %eax,%edi
80106f2d:	e8 de c9 ff ff       	call   80103910 <mycpu>
80106f32:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106f35:	83 c7 08             	add    $0x8,%edi
80106f38:	e8 d3 c9 ff ff       	call   80103910 <mycpu>
80106f3d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106f40:	83 c0 08             	add    $0x8,%eax
80106f43:	ba 67 00 00 00       	mov    $0x67,%edx
80106f48:	c1 e8 18             	shr    $0x18,%eax
80106f4b:	66 89 96 98 00 00 00 	mov    %dx,0x98(%esi)
80106f52:	66 89 be 9a 00 00 00 	mov    %di,0x9a(%esi)
80106f59:	88 86 9f 00 00 00    	mov    %al,0x9f(%esi)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106f5f:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f64:	83 c1 08             	add    $0x8,%ecx
80106f67:	c1 e9 10             	shr    $0x10,%ecx
80106f6a:	88 8e 9c 00 00 00    	mov    %cl,0x9c(%esi)
80106f70:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106f75:	66 89 8e 9d 00 00 00 	mov    %cx,0x9d(%esi)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f7c:	be 10 00 00 00       	mov    $0x10,%esi
  mycpu()->gdt[SEG_TSS].s = 0;
80106f81:	e8 8a c9 ff ff       	call   80103910 <mycpu>
80106f86:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106f8d:	e8 7e c9 ff ff       	call   80103910 <mycpu>
80106f92:	66 89 70 10          	mov    %si,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106f96:	8b 73 08             	mov    0x8(%ebx),%esi
80106f99:	e8 72 c9 ff ff       	call   80103910 <mycpu>
80106f9e:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106fa4:	89 70 0c             	mov    %esi,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fa7:	e8 64 c9 ff ff       	call   80103910 <mycpu>
80106fac:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106fb0:	b8 28 00 00 00       	mov    $0x28,%eax
80106fb5:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106fb8:	8b 43 04             	mov    0x4(%ebx),%eax
80106fbb:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106fc0:	0f 22 d8             	mov    %eax,%cr3
}
80106fc3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106fc6:	5b                   	pop    %ebx
80106fc7:	5e                   	pop    %esi
80106fc8:	5f                   	pop    %edi
80106fc9:	5d                   	pop    %ebp
  popcli();
80106fca:	e9 01 d9 ff ff       	jmp    801048d0 <popcli>
    panic("switchuvm: no process");
80106fcf:	83 ec 0c             	sub    $0xc,%esp
80106fd2:	68 42 7f 10 80       	push   $0x80107f42
80106fd7:	e8 b4 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no pgdir");
80106fdc:	83 ec 0c             	sub    $0xc,%esp
80106fdf:	68 6d 7f 10 80       	push   $0x80107f6d
80106fe4:	e8 a7 93 ff ff       	call   80100390 <panic>
    panic("switchuvm: no kstack");
80106fe9:	83 ec 0c             	sub    $0xc,%esp
80106fec:	68 58 7f 10 80       	push   $0x80107f58
80106ff1:	e8 9a 93 ff ff       	call   80100390 <panic>
80106ff6:	8d 76 00             	lea    0x0(%esi),%esi
80106ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107000 <inituvm>:
{
80107000:	55                   	push   %ebp
80107001:	89 e5                	mov    %esp,%ebp
80107003:	57                   	push   %edi
80107004:	56                   	push   %esi
80107005:	53                   	push   %ebx
80107006:	83 ec 1c             	sub    $0x1c,%esp
80107009:	8b 75 10             	mov    0x10(%ebp),%esi
8010700c:	8b 45 08             	mov    0x8(%ebp),%eax
8010700f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(sz >= PGSIZE)
80107012:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
{
80107018:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
8010701b:	77 49                	ja     80107066 <inituvm+0x66>
  mem = kalloc();
8010701d:	e8 4e b6 ff ff       	call   80102670 <kalloc>
  memset(mem, 0, PGSIZE);
80107022:	83 ec 04             	sub    $0x4,%esp
  mem = kalloc();
80107025:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80107027:	68 00 10 00 00       	push   $0x1000
8010702c:	6a 00                	push   $0x0
8010702e:	50                   	push   %eax
8010702f:	e8 3c da ff ff       	call   80104a70 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80107034:	58                   	pop    %eax
80107035:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010703b:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107040:	5a                   	pop    %edx
80107041:	6a 06                	push   $0x6
80107043:	50                   	push   %eax
80107044:	31 d2                	xor    %edx,%edx
80107046:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107049:	e8 c2 fc ff ff       	call   80106d10 <mappages>
  memmove(mem, init, sz);
8010704e:	89 75 10             	mov    %esi,0x10(%ebp)
80107051:	89 7d 0c             	mov    %edi,0xc(%ebp)
80107054:	83 c4 10             	add    $0x10,%esp
80107057:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010705a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010705d:	5b                   	pop    %ebx
8010705e:	5e                   	pop    %esi
8010705f:	5f                   	pop    %edi
80107060:	5d                   	pop    %ebp
  memmove(mem, init, sz);
80107061:	e9 ba da ff ff       	jmp    80104b20 <memmove>
    panic("inituvm: more than a page");
80107066:	83 ec 0c             	sub    $0xc,%esp
80107069:	68 81 7f 10 80       	push   $0x80107f81
8010706e:	e8 1d 93 ff ff       	call   80100390 <panic>
80107073:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107079:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107080 <loaduvm>:
{
80107080:	55                   	push   %ebp
80107081:	89 e5                	mov    %esp,%ebp
80107083:	57                   	push   %edi
80107084:	56                   	push   %esi
80107085:	53                   	push   %ebx
80107086:	83 ec 0c             	sub    $0xc,%esp
  if((uint) addr % PGSIZE != 0)
80107089:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80107090:	0f 85 91 00 00 00    	jne    80107127 <loaduvm+0xa7>
  for(i = 0; i < sz; i += PGSIZE){
80107096:	8b 75 18             	mov    0x18(%ebp),%esi
80107099:	31 db                	xor    %ebx,%ebx
8010709b:	85 f6                	test   %esi,%esi
8010709d:	75 1a                	jne    801070b9 <loaduvm+0x39>
8010709f:	eb 6f                	jmp    80107110 <loaduvm+0x90>
801070a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070a8:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801070ae:	81 ee 00 10 00 00    	sub    $0x1000,%esi
801070b4:	39 5d 18             	cmp    %ebx,0x18(%ebp)
801070b7:	76 57                	jbe    80107110 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801070b9:	8b 55 0c             	mov    0xc(%ebp),%edx
801070bc:	8b 45 08             	mov    0x8(%ebp),%eax
801070bf:	31 c9                	xor    %ecx,%ecx
801070c1:	01 da                	add    %ebx,%edx
801070c3:	e8 c8 fb ff ff       	call   80106c90 <walkpgdir>
801070c8:	85 c0                	test   %eax,%eax
801070ca:	74 4e                	je     8010711a <loaduvm+0x9a>
    pa = PTE_ADDR(*pte);
801070cc:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070ce:	8b 4d 14             	mov    0x14(%ebp),%ecx
    if(sz - i < PGSIZE)
801070d1:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
801070d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801070db:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801070e1:	0f 46 fe             	cmovbe %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
801070e4:	01 d9                	add    %ebx,%ecx
801070e6:	05 00 00 00 80       	add    $0x80000000,%eax
801070eb:	57                   	push   %edi
801070ec:	51                   	push   %ecx
801070ed:	50                   	push   %eax
801070ee:	ff 75 10             	pushl  0x10(%ebp)
801070f1:	e8 1a aa ff ff       	call   80101b10 <readi>
801070f6:	83 c4 10             	add    $0x10,%esp
801070f9:	39 f8                	cmp    %edi,%eax
801070fb:	74 ab                	je     801070a8 <loaduvm+0x28>
}
801070fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107100:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80107105:	5b                   	pop    %ebx
80107106:	5e                   	pop    %esi
80107107:	5f                   	pop    %edi
80107108:	5d                   	pop    %ebp
80107109:	c3                   	ret    
8010710a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80107110:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80107113:	31 c0                	xor    %eax,%eax
}
80107115:	5b                   	pop    %ebx
80107116:	5e                   	pop    %esi
80107117:	5f                   	pop    %edi
80107118:	5d                   	pop    %ebp
80107119:	c3                   	ret    
      panic("loaduvm: address should exist");
8010711a:	83 ec 0c             	sub    $0xc,%esp
8010711d:	68 9b 7f 10 80       	push   $0x80107f9b
80107122:	e8 69 92 ff ff       	call   80100390 <panic>
    panic("loaduvm: addr must be page aligned");
80107127:	83 ec 0c             	sub    $0xc,%esp
8010712a:	68 3c 80 10 80       	push   $0x8010803c
8010712f:	e8 5c 92 ff ff       	call   80100390 <panic>
80107134:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010713a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80107140 <allocuvm>:
{
80107140:	55                   	push   %ebp
80107141:	89 e5                	mov    %esp,%ebp
80107143:	57                   	push   %edi
80107144:	56                   	push   %esi
80107145:	53                   	push   %ebx
80107146:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
80107149:	8b 7d 10             	mov    0x10(%ebp),%edi
8010714c:	85 ff                	test   %edi,%edi
8010714e:	0f 88 8e 00 00 00    	js     801071e2 <allocuvm+0xa2>
  if(newsz < oldsz)
80107154:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80107157:	0f 82 93 00 00 00    	jb     801071f0 <allocuvm+0xb0>
  a = PGROUNDUP(oldsz);
8010715d:	8b 45 0c             	mov    0xc(%ebp),%eax
80107160:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80107166:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
8010716c:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010716f:	0f 86 7e 00 00 00    	jbe    801071f3 <allocuvm+0xb3>
80107175:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80107178:	8b 7d 08             	mov    0x8(%ebp),%edi
8010717b:	eb 42                	jmp    801071bf <allocuvm+0x7f>
8010717d:	8d 76 00             	lea    0x0(%esi),%esi
    memset(mem, 0, PGSIZE);
80107180:	83 ec 04             	sub    $0x4,%esp
80107183:	68 00 10 00 00       	push   $0x1000
80107188:	6a 00                	push   $0x0
8010718a:	50                   	push   %eax
8010718b:	e8 e0 d8 ff ff       	call   80104a70 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107190:	58                   	pop    %eax
80107191:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80107197:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010719c:	5a                   	pop    %edx
8010719d:	6a 06                	push   $0x6
8010719f:	50                   	push   %eax
801071a0:	89 da                	mov    %ebx,%edx
801071a2:	89 f8                	mov    %edi,%eax
801071a4:	e8 67 fb ff ff       	call   80106d10 <mappages>
801071a9:	83 c4 10             	add    $0x10,%esp
801071ac:	85 c0                	test   %eax,%eax
801071ae:	78 50                	js     80107200 <allocuvm+0xc0>
  for(; a < newsz; a += PGSIZE){
801071b0:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801071b6:	39 5d 10             	cmp    %ebx,0x10(%ebp)
801071b9:	0f 86 81 00 00 00    	jbe    80107240 <allocuvm+0x100>
    mem = kalloc();
801071bf:	e8 ac b4 ff ff       	call   80102670 <kalloc>
    if(mem == 0){
801071c4:	85 c0                	test   %eax,%eax
    mem = kalloc();
801071c6:	89 c6                	mov    %eax,%esi
    if(mem == 0){
801071c8:	75 b6                	jne    80107180 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
801071ca:	83 ec 0c             	sub    $0xc,%esp
801071cd:	68 b9 7f 10 80       	push   $0x80107fb9
801071d2:	e8 89 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
801071d7:	83 c4 10             	add    $0x10,%esp
801071da:	8b 45 0c             	mov    0xc(%ebp),%eax
801071dd:	39 45 10             	cmp    %eax,0x10(%ebp)
801071e0:	77 6e                	ja     80107250 <allocuvm+0x110>
}
801071e2:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
801071e5:	31 ff                	xor    %edi,%edi
}
801071e7:	89 f8                	mov    %edi,%eax
801071e9:	5b                   	pop    %ebx
801071ea:	5e                   	pop    %esi
801071eb:	5f                   	pop    %edi
801071ec:	5d                   	pop    %ebp
801071ed:	c3                   	ret    
801071ee:	66 90                	xchg   %ax,%ax
    return oldsz;
801071f0:	8b 7d 0c             	mov    0xc(%ebp),%edi
}
801071f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801071f6:	89 f8                	mov    %edi,%eax
801071f8:	5b                   	pop    %ebx
801071f9:	5e                   	pop    %esi
801071fa:	5f                   	pop    %edi
801071fb:	5d                   	pop    %ebp
801071fc:	c3                   	ret    
801071fd:	8d 76 00             	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
80107200:	83 ec 0c             	sub    $0xc,%esp
80107203:	68 d1 7f 10 80       	push   $0x80107fd1
80107208:	e8 53 94 ff ff       	call   80100660 <cprintf>
  if(newsz >= oldsz)
8010720d:	83 c4 10             	add    $0x10,%esp
80107210:	8b 45 0c             	mov    0xc(%ebp),%eax
80107213:	39 45 10             	cmp    %eax,0x10(%ebp)
80107216:	76 0d                	jbe    80107225 <allocuvm+0xe5>
80107218:	89 c1                	mov    %eax,%ecx
8010721a:	8b 55 10             	mov    0x10(%ebp),%edx
8010721d:	8b 45 08             	mov    0x8(%ebp),%eax
80107220:	e8 7b fb ff ff       	call   80106da0 <deallocuvm.part.0>
      kfree(mem);
80107225:	83 ec 0c             	sub    $0xc,%esp
      return 0;
80107228:	31 ff                	xor    %edi,%edi
      kfree(mem);
8010722a:	56                   	push   %esi
8010722b:	e8 90 b2 ff ff       	call   801024c0 <kfree>
      return 0;
80107230:	83 c4 10             	add    $0x10,%esp
}
80107233:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107236:	89 f8                	mov    %edi,%eax
80107238:	5b                   	pop    %ebx
80107239:	5e                   	pop    %esi
8010723a:	5f                   	pop    %edi
8010723b:	5d                   	pop    %ebp
8010723c:	c3                   	ret    
8010723d:	8d 76 00             	lea    0x0(%esi),%esi
80107240:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80107243:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107246:	5b                   	pop    %ebx
80107247:	89 f8                	mov    %edi,%eax
80107249:	5e                   	pop    %esi
8010724a:	5f                   	pop    %edi
8010724b:	5d                   	pop    %ebp
8010724c:	c3                   	ret    
8010724d:	8d 76 00             	lea    0x0(%esi),%esi
80107250:	89 c1                	mov    %eax,%ecx
80107252:	8b 55 10             	mov    0x10(%ebp),%edx
80107255:	8b 45 08             	mov    0x8(%ebp),%eax
      return 0;
80107258:	31 ff                	xor    %edi,%edi
8010725a:	e8 41 fb ff ff       	call   80106da0 <deallocuvm.part.0>
8010725f:	eb 92                	jmp    801071f3 <allocuvm+0xb3>
80107261:	eb 0d                	jmp    80107270 <deallocuvm>
80107263:	90                   	nop
80107264:	90                   	nop
80107265:	90                   	nop
80107266:	90                   	nop
80107267:	90                   	nop
80107268:	90                   	nop
80107269:	90                   	nop
8010726a:	90                   	nop
8010726b:	90                   	nop
8010726c:	90                   	nop
8010726d:	90                   	nop
8010726e:	90                   	nop
8010726f:	90                   	nop

80107270 <deallocuvm>:
{
80107270:	55                   	push   %ebp
80107271:	89 e5                	mov    %esp,%ebp
80107273:	8b 55 0c             	mov    0xc(%ebp),%edx
80107276:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107279:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010727c:	39 d1                	cmp    %edx,%ecx
8010727e:	73 10                	jae    80107290 <deallocuvm+0x20>
}
80107280:	5d                   	pop    %ebp
80107281:	e9 1a fb ff ff       	jmp    80106da0 <deallocuvm.part.0>
80107286:	8d 76 00             	lea    0x0(%esi),%esi
80107289:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80107290:	89 d0                	mov    %edx,%eax
80107292:	5d                   	pop    %ebp
80107293:	c3                   	ret    
80107294:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010729a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801072a0 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
801072a0:	55                   	push   %ebp
801072a1:	89 e5                	mov    %esp,%ebp
801072a3:	57                   	push   %edi
801072a4:	56                   	push   %esi
801072a5:	53                   	push   %ebx
801072a6:	83 ec 0c             	sub    $0xc,%esp
801072a9:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801072ac:	85 f6                	test   %esi,%esi
801072ae:	74 59                	je     80107309 <freevm+0x69>
801072b0:	31 c9                	xor    %ecx,%ecx
801072b2:	ba 00 00 00 80       	mov    $0x80000000,%edx
801072b7:	89 f0                	mov    %esi,%eax
801072b9:	e8 e2 fa ff ff       	call   80106da0 <deallocuvm.part.0>
801072be:	89 f3                	mov    %esi,%ebx
801072c0:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
801072c6:	eb 0f                	jmp    801072d7 <freevm+0x37>
801072c8:	90                   	nop
801072c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801072d0:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
801072d3:	39 fb                	cmp    %edi,%ebx
801072d5:	74 23                	je     801072fa <freevm+0x5a>
    if(pgdir[i] & PTE_P){
801072d7:	8b 03                	mov    (%ebx),%eax
801072d9:	a8 01                	test   $0x1,%al
801072db:	74 f3                	je     801072d0 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072dd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
801072e2:	83 ec 0c             	sub    $0xc,%esp
801072e5:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
801072e8:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801072ed:	50                   	push   %eax
801072ee:	e8 cd b1 ff ff       	call   801024c0 <kfree>
801072f3:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801072f6:	39 fb                	cmp    %edi,%ebx
801072f8:	75 dd                	jne    801072d7 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801072fa:	89 75 08             	mov    %esi,0x8(%ebp)
}
801072fd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107300:	5b                   	pop    %ebx
80107301:	5e                   	pop    %esi
80107302:	5f                   	pop    %edi
80107303:	5d                   	pop    %ebp
  kfree((char*)pgdir);
80107304:	e9 b7 b1 ff ff       	jmp    801024c0 <kfree>
    panic("freevm: no pgdir");
80107309:	83 ec 0c             	sub    $0xc,%esp
8010730c:	68 ed 7f 10 80       	push   $0x80107fed
80107311:	e8 7a 90 ff ff       	call   80100390 <panic>
80107316:	8d 76 00             	lea    0x0(%esi),%esi
80107319:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80107320 <setupkvm>:
{
80107320:	55                   	push   %ebp
80107321:	89 e5                	mov    %esp,%ebp
80107323:	56                   	push   %esi
80107324:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80107325:	e8 46 b3 ff ff       	call   80102670 <kalloc>
8010732a:	85 c0                	test   %eax,%eax
8010732c:	89 c6                	mov    %eax,%esi
8010732e:	74 42                	je     80107372 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
80107330:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107333:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
80107338:	68 00 10 00 00       	push   $0x1000
8010733d:	6a 00                	push   $0x0
8010733f:	50                   	push   %eax
80107340:	e8 2b d7 ff ff       	call   80104a70 <memset>
80107345:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
80107348:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
8010734b:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010734e:	83 ec 08             	sub    $0x8,%esp
80107351:	8b 13                	mov    (%ebx),%edx
80107353:	ff 73 0c             	pushl  0xc(%ebx)
80107356:	50                   	push   %eax
80107357:	29 c1                	sub    %eax,%ecx
80107359:	89 f0                	mov    %esi,%eax
8010735b:	e8 b0 f9 ff ff       	call   80106d10 <mappages>
80107360:	83 c4 10             	add    $0x10,%esp
80107363:	85 c0                	test   %eax,%eax
80107365:	78 19                	js     80107380 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107367:	83 c3 10             	add    $0x10,%ebx
8010736a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107370:	75 d6                	jne    80107348 <setupkvm+0x28>
}
80107372:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107375:	89 f0                	mov    %esi,%eax
80107377:	5b                   	pop    %ebx
80107378:	5e                   	pop    %esi
80107379:	5d                   	pop    %ebp
8010737a:	c3                   	ret    
8010737b:	90                   	nop
8010737c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      freevm(pgdir);
80107380:	83 ec 0c             	sub    $0xc,%esp
80107383:	56                   	push   %esi
      return 0;
80107384:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107386:	e8 15 ff ff ff       	call   801072a0 <freevm>
      return 0;
8010738b:	83 c4 10             	add    $0x10,%esp
}
8010738e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107391:	89 f0                	mov    %esi,%eax
80107393:	5b                   	pop    %ebx
80107394:	5e                   	pop    %esi
80107395:	5d                   	pop    %ebp
80107396:	c3                   	ret    
80107397:	89 f6                	mov    %esi,%esi
80107399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801073a0 <kvmalloc>:
{
801073a0:	55                   	push   %ebp
801073a1:	89 e5                	mov    %esp,%ebp
801073a3:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
801073a6:	e8 75 ff ff ff       	call   80107320 <setupkvm>
801073ab:	a3 04 6c 11 80       	mov    %eax,0x80116c04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801073b0:	05 00 00 00 80       	add    $0x80000000,%eax
801073b5:	0f 22 d8             	mov    %eax,%cr3
}
801073b8:	c9                   	leave  
801073b9:	c3                   	ret    
801073ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801073c0 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
801073c0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801073c1:	31 c9                	xor    %ecx,%ecx
{
801073c3:	89 e5                	mov    %esp,%ebp
801073c5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801073c8:	8b 55 0c             	mov    0xc(%ebp),%edx
801073cb:	8b 45 08             	mov    0x8(%ebp),%eax
801073ce:	e8 bd f8 ff ff       	call   80106c90 <walkpgdir>
  if(pte == 0)
801073d3:	85 c0                	test   %eax,%eax
801073d5:	74 05                	je     801073dc <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
801073d7:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801073da:	c9                   	leave  
801073db:	c3                   	ret    
    panic("clearpteu");
801073dc:	83 ec 0c             	sub    $0xc,%esp
801073df:	68 fe 7f 10 80       	push   $0x80107ffe
801073e4:	e8 a7 8f ff ff       	call   80100390 <panic>
801073e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801073f0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801073f0:	55                   	push   %ebp
801073f1:	89 e5                	mov    %esp,%ebp
801073f3:	57                   	push   %edi
801073f4:	56                   	push   %esi
801073f5:	53                   	push   %ebx
801073f6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801073f9:	e8 22 ff ff ff       	call   80107320 <setupkvm>
801073fe:	85 c0                	test   %eax,%eax
80107400:	89 45 e0             	mov    %eax,-0x20(%ebp)
80107403:	0f 84 9f 00 00 00    	je     801074a8 <copyuvm+0xb8>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80107409:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010740c:	85 c9                	test   %ecx,%ecx
8010740e:	0f 84 94 00 00 00    	je     801074a8 <copyuvm+0xb8>
80107414:	31 ff                	xor    %edi,%edi
80107416:	eb 4a                	jmp    80107462 <copyuvm+0x72>
80107418:	90                   	nop
80107419:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107420:	83 ec 04             	sub    $0x4,%esp
80107423:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80107429:	68 00 10 00 00       	push   $0x1000
8010742e:	53                   	push   %ebx
8010742f:	50                   	push   %eax
80107430:	e8 eb d6 ff ff       	call   80104b20 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107435:	58                   	pop    %eax
80107436:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
8010743c:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107441:	5a                   	pop    %edx
80107442:	ff 75 e4             	pushl  -0x1c(%ebp)
80107445:	50                   	push   %eax
80107446:	89 fa                	mov    %edi,%edx
80107448:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010744b:	e8 c0 f8 ff ff       	call   80106d10 <mappages>
80107450:	83 c4 10             	add    $0x10,%esp
80107453:	85 c0                	test   %eax,%eax
80107455:	78 61                	js     801074b8 <copyuvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
80107457:	81 c7 00 10 00 00    	add    $0x1000,%edi
8010745d:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80107460:	76 46                	jbe    801074a8 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107462:	8b 45 08             	mov    0x8(%ebp),%eax
80107465:	31 c9                	xor    %ecx,%ecx
80107467:	89 fa                	mov    %edi,%edx
80107469:	e8 22 f8 ff ff       	call   80106c90 <walkpgdir>
8010746e:	85 c0                	test   %eax,%eax
80107470:	74 61                	je     801074d3 <copyuvm+0xe3>
    if(!(*pte & PTE_P))
80107472:	8b 00                	mov    (%eax),%eax
80107474:	a8 01                	test   $0x1,%al
80107476:	74 4e                	je     801074c6 <copyuvm+0xd6>
    pa = PTE_ADDR(*pte);
80107478:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
8010747a:	25 ff 0f 00 00       	and    $0xfff,%eax
    pa = PTE_ADDR(*pte);
8010747f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80107485:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80107488:	e8 e3 b1 ff ff       	call   80102670 <kalloc>
8010748d:	85 c0                	test   %eax,%eax
8010748f:	89 c6                	mov    %eax,%esi
80107491:	75 8d                	jne    80107420 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80107493:	83 ec 0c             	sub    $0xc,%esp
80107496:	ff 75 e0             	pushl  -0x20(%ebp)
80107499:	e8 02 fe ff ff       	call   801072a0 <freevm>
  return 0;
8010749e:	83 c4 10             	add    $0x10,%esp
801074a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
}
801074a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
801074ab:	8d 65 f4             	lea    -0xc(%ebp),%esp
801074ae:	5b                   	pop    %ebx
801074af:	5e                   	pop    %esi
801074b0:	5f                   	pop    %edi
801074b1:	5d                   	pop    %ebp
801074b2:	c3                   	ret    
801074b3:	90                   	nop
801074b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
801074b8:	83 ec 0c             	sub    $0xc,%esp
801074bb:	56                   	push   %esi
801074bc:	e8 ff af ff ff       	call   801024c0 <kfree>
      goto bad;
801074c1:	83 c4 10             	add    $0x10,%esp
801074c4:	eb cd                	jmp    80107493 <copyuvm+0xa3>
      panic("copyuvm: page not present");
801074c6:	83 ec 0c             	sub    $0xc,%esp
801074c9:	68 22 80 10 80       	push   $0x80108022
801074ce:	e8 bd 8e ff ff       	call   80100390 <panic>
      panic("copyuvm: pte should exist");
801074d3:	83 ec 0c             	sub    $0xc,%esp
801074d6:	68 08 80 10 80       	push   $0x80108008
801074db:	e8 b0 8e ff ff       	call   80100390 <panic>

801074e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801074e0:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801074e1:	31 c9                	xor    %ecx,%ecx
{
801074e3:	89 e5                	mov    %esp,%ebp
801074e5:	83 ec 08             	sub    $0x8,%esp
  pte = walkpgdir(pgdir, uva, 0);
801074e8:	8b 55 0c             	mov    0xc(%ebp),%edx
801074eb:	8b 45 08             	mov    0x8(%ebp),%eax
801074ee:	e8 9d f7 ff ff       	call   80106c90 <walkpgdir>
  if((*pte & PTE_P) == 0)
801074f3:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
801074f5:	c9                   	leave  
  if((*pte & PTE_U) == 0)
801074f6:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
801074f8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
801074fd:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107500:	05 00 00 00 80       	add    $0x80000000,%eax
80107505:	83 fa 05             	cmp    $0x5,%edx
80107508:	ba 00 00 00 00       	mov    $0x0,%edx
8010750d:	0f 45 c2             	cmovne %edx,%eax
}
80107510:	c3                   	ret    
80107511:	eb 0d                	jmp    80107520 <copyout>
80107513:	90                   	nop
80107514:	90                   	nop
80107515:	90                   	nop
80107516:	90                   	nop
80107517:	90                   	nop
80107518:	90                   	nop
80107519:	90                   	nop
8010751a:	90                   	nop
8010751b:	90                   	nop
8010751c:	90                   	nop
8010751d:	90                   	nop
8010751e:	90                   	nop
8010751f:	90                   	nop

80107520 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107520:	55                   	push   %ebp
80107521:	89 e5                	mov    %esp,%ebp
80107523:	57                   	push   %edi
80107524:	56                   	push   %esi
80107525:	53                   	push   %ebx
80107526:	83 ec 1c             	sub    $0x1c,%esp
80107529:	8b 5d 14             	mov    0x14(%ebp),%ebx
8010752c:	8b 55 0c             	mov    0xc(%ebp),%edx
8010752f:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107532:	85 db                	test   %ebx,%ebx
80107534:	75 40                	jne    80107576 <copyout+0x56>
80107536:	eb 70                	jmp    801075a8 <copyout+0x88>
80107538:	90                   	nop
80107539:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80107540:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80107543:	89 f1                	mov    %esi,%ecx
80107545:	29 d1                	sub    %edx,%ecx
80107547:	81 c1 00 10 00 00    	add    $0x1000,%ecx
8010754d:	39 d9                	cmp    %ebx,%ecx
8010754f:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107552:	29 f2                	sub    %esi,%edx
80107554:	83 ec 04             	sub    $0x4,%esp
80107557:	01 d0                	add    %edx,%eax
80107559:	51                   	push   %ecx
8010755a:	57                   	push   %edi
8010755b:	50                   	push   %eax
8010755c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010755f:	e8 bc d5 ff ff       	call   80104b20 <memmove>
    len -= n;
    buf += n;
80107564:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
  while(len > 0){
80107567:	83 c4 10             	add    $0x10,%esp
    va = va0 + PGSIZE;
8010756a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    buf += n;
80107570:	01 cf                	add    %ecx,%edi
  while(len > 0){
80107572:	29 cb                	sub    %ecx,%ebx
80107574:	74 32                	je     801075a8 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107576:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107578:	83 ec 08             	sub    $0x8,%esp
    va0 = (uint)PGROUNDDOWN(va);
8010757b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010757e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107584:	56                   	push   %esi
80107585:	ff 75 08             	pushl  0x8(%ebp)
80107588:	e8 53 ff ff ff       	call   801074e0 <uva2ka>
    if(pa0 == 0)
8010758d:	83 c4 10             	add    $0x10,%esp
80107590:	85 c0                	test   %eax,%eax
80107592:	75 ac                	jne    80107540 <copyout+0x20>
  }
  return 0;
}
80107594:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80107597:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010759c:	5b                   	pop    %ebx
8010759d:	5e                   	pop    %esi
8010759e:	5f                   	pop    %edi
8010759f:	5d                   	pop    %ebp
801075a0:	c3                   	ret    
801075a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801075ab:	31 c0                	xor    %eax,%eax
}
801075ad:	5b                   	pop    %ebx
801075ae:	5e                   	pop    %esi
801075af:	5f                   	pop    %edi
801075b0:	5d                   	pop    %ebp
801075b1:	c3                   	ret    
801075b2:	66 90                	xchg   %ax,%ax
801075b4:	66 90                	xchg   %ax,%ax
801075b6:	66 90                	xchg   %ax,%ax
801075b8:	66 90                	xchg   %ax,%ax
801075ba:	66 90                	xchg   %ax,%ax
801075bc:	66 90                	xchg   %ax,%ax
801075be:	66 90                	xchg   %ax,%ax

801075c0 <myfunction>:
#include "defs.h"

//간단한 system call
int
myfunction (char* str)
{
801075c0:	55                   	push   %ebp
801075c1:	89 e5                	mov    %esp,%ebp
801075c3:	83 ec 10             	sub    $0x10,%esp
    cprintf("%s\n", str);
801075c6:	ff 75 08             	pushl  0x8(%ebp)
801075c9:	68 60 80 10 80       	push   $0x80108060
801075ce:	e8 8d 90 ff ff       	call   80100660 <cprintf>
    return 0xABCDABCD;
} 
801075d3:	b8 cd ab cd ab       	mov    $0xabcdabcd,%eax
801075d8:	c9                   	leave  
801075d9:	c3                   	ret    
801075da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801075e0 <sys_myfunction>:

//my_ syscall에 대한 Wrapper 함수
int
sys_myfunction (void)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	83 ec 20             	sub    $0x20,%esp
    char* str;
//Argstr을 사용해서 argument를 해독
    if(argstr(0, &str) < 0)
801075e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801075e9:	50                   	push   %eax
801075ea:	6a 00                	push   $0x0
801075ec:	e8 2f d8 ff ff       	call   80104e20 <argstr>
801075f1:	83 c4 10             	add    $0x10,%esp
801075f4:	85 c0                	test   %eax,%eax
801075f6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801075fb:	78 18                	js     80107615 <sys_myfunction+0x35>
    cprintf("%s\n", str);
801075fd:	83 ec 08             	sub    $0x8,%esp
80107600:	ff 75 f4             	pushl  -0xc(%ebp)
80107603:	68 60 80 10 80       	push   $0x80108060
80107608:	e8 53 90 ff ff       	call   80100660 <cprintf>
        return -1;
    return myfunction(str);
8010760d:	83 c4 10             	add    $0x10,%esp
80107610:	ba cd ab cd ab       	mov    $0xabcdabcd,%edx
}
80107615:	89 d0                	mov    %edx,%eax
80107617:	c9                   	leave  
80107618:	c3                   	ret    
80107619:	66 90                	xchg   %ax,%ax
8010761b:	66 90                	xchg   %ax,%ax
8010761d:	66 90                	xchg   %ax,%ax
8010761f:	90                   	nop

80107620 <sys_getppid>:
#include "mmu.h"
#include "proc.h"

int
sys_getppid(void)
{
80107620:	55                   	push   %ebp
80107621:	89 e5                	mov    %esp,%ebp
80107623:	83 ec 08             	sub    $0x8,%esp
	return myproc()->parent->pid;
80107626:	e8 85 c3 ff ff       	call   801039b0 <myproc>
8010762b:	8b 40 14             	mov    0x14(%eax),%eax
8010762e:	8b 40 10             	mov    0x10(%eax),%eax
}
80107631:	c9                   	leave  
80107632:	c3                   	ret    
