
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
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
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
80100028:	bc d0 83 11 80       	mov    $0x801183d0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 d5 29 10 80       	mov    $0x801029d5,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax

80100034 <bget>:
// Look through buffer cache for block on device dev.
// If not found, allocate a buffer.
// In either case, return locked buffer.
static struct buf*
bget(uint dev, uint blockno)
{
80100034:	55                   	push   %ebp
80100035:	89 e5                	mov    %esp,%ebp
80100037:	57                   	push   %edi
80100038:	56                   	push   %esi
80100039:	53                   	push   %ebx
8010003a:	83 ec 18             	sub    $0x18,%esp
8010003d:	89 c6                	mov    %eax,%esi
8010003f:	89 d7                	mov    %edx,%edi
  struct buf *b;

  acquire(&bcache.lock);
80100041:	68 20 a5 10 80       	push   $0x8010a520
80100046:	e8 a1 3c 00 00       	call   80103cec <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 70 ec 10 80    	mov    0x8010ec70,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
8010005f:	74 2e                	je     8010008f <bget+0x5b>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	40                   	inc    %eax
8010006f:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100072:	83 ec 0c             	sub    $0xc,%esp
80100075:	68 20 a5 10 80       	push   $0x8010a520
8010007a:	e8 d2 3c 00 00       	call   80103d51 <release>
      acquiresleep(&b->lock);
8010007f:	8d 43 0c             	lea    0xc(%ebx),%eax
80100082:	89 04 24             	mov    %eax,(%esp)
80100085:	e8 4a 3a 00 00       	call   80103ad4 <acquiresleep>
      return b;
8010008a:	83 c4 10             	add    $0x10,%esp
8010008d:	eb 4c                	jmp    801000db <bget+0xa7>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
8010008f:	8b 1d 6c ec 10 80    	mov    0x8010ec6c,%ebx
80100095:	eb 03                	jmp    8010009a <bget+0x66>
80100097:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009a:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
801000a0:	74 43                	je     801000e5 <bget+0xb1>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a2:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a6:	75 ef                	jne    80100097 <bget+0x63>
801000a8:	f6 03 04             	testb  $0x4,(%ebx)
801000ab:	75 ea                	jne    80100097 <bget+0x63>
      b->dev = dev;
801000ad:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b0:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b3:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000b9:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c0:	83 ec 0c             	sub    $0xc,%esp
801000c3:	68 20 a5 10 80       	push   $0x8010a520
801000c8:	e8 84 3c 00 00       	call   80103d51 <release>
      acquiresleep(&b->lock);
801000cd:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d0:	89 04 24             	mov    %eax,(%esp)
801000d3:	e8 fc 39 00 00       	call   80103ad4 <acquiresleep>
      return b;
801000d8:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000db:	89 d8                	mov    %ebx,%eax
801000dd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e0:	5b                   	pop    %ebx
801000e1:	5e                   	pop    %esi
801000e2:	5f                   	pop    %edi
801000e3:	5d                   	pop    %ebp
801000e4:	c3                   	ret    
  panic("bget: no buffers");
801000e5:	83 ec 0c             	sub    $0xc,%esp
801000e8:	68 00 68 10 80       	push   $0x80106800
801000ed:	e8 52 02 00 00       	call   80100344 <panic>

801000f2 <binit>:
{
801000f2:	55                   	push   %ebp
801000f3:	89 e5                	mov    %esp,%ebp
801000f5:	53                   	push   %ebx
801000f6:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000f9:	68 11 68 10 80       	push   $0x80106811
801000fe:	68 20 a5 10 80       	push   $0x8010a520
80100103:	e8 a4 3a 00 00       	call   80103bac <initlock>
  bcache.head.prev = &bcache.head;
80100108:	c7 05 6c ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec6c
8010010f:	ec 10 80 
  bcache.head.next = &bcache.head;
80100112:	c7 05 70 ec 10 80 1c 	movl   $0x8010ec1c,0x8010ec70
80100119:	ec 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010011c:	83 c4 10             	add    $0x10,%esp
8010011f:	bb 54 a5 10 80       	mov    $0x8010a554,%ebx
80100124:	eb 37                	jmp    8010015d <binit+0x6b>
    b->next = bcache.head.next;
80100126:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010012b:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010012e:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100135:	83 ec 08             	sub    $0x8,%esp
80100138:	68 18 68 10 80       	push   $0x80106818
8010013d:	8d 43 0c             	lea    0xc(%ebx),%eax
80100140:	50                   	push   %eax
80100141:	e8 5b 39 00 00       	call   80103aa1 <initsleeplock>
    bcache.head.next->prev = b;
80100146:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
8010014b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010014e:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100154:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
8010015a:	83 c4 10             	add    $0x10,%esp
8010015d:	81 fb 1c ec 10 80    	cmp    $0x8010ec1c,%ebx
80100163:	72 c1                	jb     80100126 <binit+0x34>
}
80100165:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100168:	c9                   	leave  
80100169:	c3                   	ret    

8010016a <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
8010016a:	55                   	push   %ebp
8010016b:	89 e5                	mov    %esp,%ebp
8010016d:	53                   	push   %ebx
8010016e:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
80100171:	8b 55 0c             	mov    0xc(%ebp),%edx
80100174:	8b 45 08             	mov    0x8(%ebp),%eax
80100177:	e8 b8 fe ff ff       	call   80100034 <bget>
8010017c:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
8010017e:	f6 00 02             	testb  $0x2,(%eax)
80100181:	74 07                	je     8010018a <bread+0x20>
    iderw(b);
  }
  return b;
}
80100183:	89 d8                	mov    %ebx,%eax
80100185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100188:	c9                   	leave  
80100189:	c3                   	ret    
    iderw(b);
8010018a:	83 ec 0c             	sub    $0xc,%esp
8010018d:	50                   	push   %eax
8010018e:	e8 25 1c 00 00       	call   80101db8 <iderw>
80100193:	83 c4 10             	add    $0x10,%esp
  return b;
80100196:	eb eb                	jmp    80100183 <bread+0x19>

80100198 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
80100198:	55                   	push   %ebp
80100199:	89 e5                	mov    %esp,%ebp
8010019b:	53                   	push   %ebx
8010019c:	83 ec 10             	sub    $0x10,%esp
8010019f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001a2:	8d 43 0c             	lea    0xc(%ebx),%eax
801001a5:	50                   	push   %eax
801001a6:	e8 b3 39 00 00       	call   80103b5e <holdingsleep>
801001ab:	83 c4 10             	add    $0x10,%esp
801001ae:	85 c0                	test   %eax,%eax
801001b0:	74 18                	je     801001ca <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b2:	8b 03                	mov    (%ebx),%eax
801001b4:	83 c8 04             	or     $0x4,%eax
801001b7:	89 03                	mov    %eax,(%ebx)
  iderw(b);
801001b9:	83 ec 0c             	sub    $0xc,%esp
801001bc:	53                   	push   %ebx
801001bd:	e8 f6 1b 00 00       	call   80101db8 <iderw>
}
801001c2:	83 c4 10             	add    $0x10,%esp
801001c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c8:	c9                   	leave  
801001c9:	c3                   	ret    
    panic("bwrite");
801001ca:	83 ec 0c             	sub    $0xc,%esp
801001cd:	68 1f 68 10 80       	push   $0x8010681f
801001d2:	e8 6d 01 00 00       	call   80100344 <panic>

801001d7 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001d7:	55                   	push   %ebp
801001d8:	89 e5                	mov    %esp,%ebp
801001da:	56                   	push   %esi
801001db:	53                   	push   %ebx
801001dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001df:	8d 73 0c             	lea    0xc(%ebx),%esi
801001e2:	83 ec 0c             	sub    $0xc,%esp
801001e5:	56                   	push   %esi
801001e6:	e8 73 39 00 00       	call   80103b5e <holdingsleep>
801001eb:	83 c4 10             	add    $0x10,%esp
801001ee:	85 c0                	test   %eax,%eax
801001f0:	74 66                	je     80100258 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001f2:	83 ec 0c             	sub    $0xc,%esp
801001f5:	56                   	push   %esi
801001f6:	e8 28 39 00 00       	call   80103b23 <releasesleep>

  acquire(&bcache.lock);
801001fb:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100202:	e8 e5 3a 00 00       	call   80103cec <acquire>
  b->refcnt--;
80100207:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010020a:	48                   	dec    %eax
8010020b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010020e:	83 c4 10             	add    $0x10,%esp
80100211:	85 c0                	test   %eax,%eax
80100213:	75 2c                	jne    80100241 <brelse+0x6a>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100215:	8b 53 54             	mov    0x54(%ebx),%edx
80100218:	8b 43 50             	mov    0x50(%ebx),%eax
8010021b:	89 42 50             	mov    %eax,0x50(%edx)
    b->prev->next = b->next;
8010021e:	8b 53 54             	mov    0x54(%ebx),%edx
80100221:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100224:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100229:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010022c:	c7 43 50 1c ec 10 80 	movl   $0x8010ec1c,0x50(%ebx)
    bcache.head.next->prev = b;
80100233:	a1 70 ec 10 80       	mov    0x8010ec70,%eax
80100238:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023b:	89 1d 70 ec 10 80    	mov    %ebx,0x8010ec70
  }
  
  release(&bcache.lock);
80100241:	83 ec 0c             	sub    $0xc,%esp
80100244:	68 20 a5 10 80       	push   $0x8010a520
80100249:	e8 03 3b 00 00       	call   80103d51 <release>
}
8010024e:	83 c4 10             	add    $0x10,%esp
80100251:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100254:	5b                   	pop    %ebx
80100255:	5e                   	pop    %esi
80100256:	5d                   	pop    %ebp
80100257:	c3                   	ret    
    panic("brelse");
80100258:	83 ec 0c             	sub    $0xc,%esp
8010025b:	68 26 68 10 80       	push   $0x80106826
80100260:	e8 df 00 00 00       	call   80100344 <panic>

80100265 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100265:	55                   	push   %ebp
80100266:	89 e5                	mov    %esp,%ebp
80100268:	57                   	push   %edi
80100269:	56                   	push   %esi
8010026a:	53                   	push   %ebx
8010026b:	83 ec 28             	sub    $0x28,%esp
8010026e:	8b 7d 08             	mov    0x8(%ebp),%edi
80100271:	8b 75 0c             	mov    0xc(%ebp),%esi
80100274:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
80100277:	57                   	push   %edi
80100278:	e8 77 13 00 00       	call   801015f4 <iunlock>
  target = n;
8010027d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100280:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
80100287:	e8 60 3a 00 00       	call   80103cec <acquire>
  while(n > 0){
8010028c:	83 c4 10             	add    $0x10,%esp
8010028f:	85 db                	test   %ebx,%ebx
80100291:	0f 8e 8e 00 00 00    	jle    80100325 <consoleread+0xc0>
    while(input.r == input.w){
80100297:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
8010029c:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801002a2:	75 47                	jne    801002eb <consoleread+0x86>
      if(myproc()->killed){
801002a4:	e8 be 2e 00 00       	call   80103167 <myproc>
801002a9:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002ad:	75 17                	jne    801002c6 <consoleread+0x61>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002af:	83 ec 08             	sub    $0x8,%esp
801002b2:	68 20 ef 10 80       	push   $0x8010ef20
801002b7:	68 00 ef 10 80       	push   $0x8010ef00
801002bc:	e8 81 32 00 00       	call   80103542 <sleep>
801002c1:	83 c4 10             	add    $0x10,%esp
801002c4:	eb d1                	jmp    80100297 <consoleread+0x32>
        release(&cons.lock);
801002c6:	83 ec 0c             	sub    $0xc,%esp
801002c9:	68 20 ef 10 80       	push   $0x8010ef20
801002ce:	e8 7e 3a 00 00       	call   80103d51 <release>
        ilock(ip);
801002d3:	89 3c 24             	mov    %edi,(%esp)
801002d6:	e8 59 12 00 00       	call   80101534 <ilock>
        return -1;
801002db:	83 c4 10             	add    $0x10,%esp
801002de:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002e3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002e6:	5b                   	pop    %ebx
801002e7:	5e                   	pop    %esi
801002e8:	5f                   	pop    %edi
801002e9:	5d                   	pop    %ebp
801002ea:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
801002eb:	8d 50 01             	lea    0x1(%eax),%edx
801002ee:	89 15 00 ef 10 80    	mov    %edx,0x8010ef00
801002f4:	89 c2                	mov    %eax,%edx
801002f6:	83 e2 7f             	and    $0x7f,%edx
801002f9:	8a 92 80 ee 10 80    	mov    -0x7fef1180(%edx),%dl
801002ff:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
80100302:	80 fa 04             	cmp    $0x4,%dl
80100305:	74 12                	je     80100319 <consoleread+0xb4>
    *dst++ = c;
80100307:	8d 46 01             	lea    0x1(%esi),%eax
8010030a:	88 16                	mov    %dl,(%esi)
    --n;
8010030c:	4b                   	dec    %ebx
    if(c == '\n')
8010030d:	83 f9 0a             	cmp    $0xa,%ecx
80100310:	74 13                	je     80100325 <consoleread+0xc0>
    *dst++ = c;
80100312:	89 c6                	mov    %eax,%esi
80100314:	e9 76 ff ff ff       	jmp    8010028f <consoleread+0x2a>
      if(n < target){
80100319:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010031c:	39 cb                	cmp    %ecx,%ebx
8010031e:	73 05                	jae    80100325 <consoleread+0xc0>
        input.r--;
80100320:	a3 00 ef 10 80       	mov    %eax,0x8010ef00
  release(&cons.lock);
80100325:	83 ec 0c             	sub    $0xc,%esp
80100328:	68 20 ef 10 80       	push   $0x8010ef20
8010032d:	e8 1f 3a 00 00       	call   80103d51 <release>
  ilock(ip);
80100332:	89 3c 24             	mov    %edi,(%esp)
80100335:	e8 fa 11 00 00       	call   80101534 <ilock>
  return target - n;
8010033a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010033d:	29 d8                	sub    %ebx,%eax
8010033f:	83 c4 10             	add    $0x10,%esp
80100342:	eb 9f                	jmp    801002e3 <consoleread+0x7e>

80100344 <panic>:
{
80100344:	55                   	push   %ebp
80100345:	89 e5                	mov    %esp,%ebp
80100347:	53                   	push   %ebx
80100348:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
8010034b:	fa                   	cli    
  cons.locking = 0;
8010034c:	c7 05 54 ef 10 80 00 	movl   $0x0,0x8010ef54
80100353:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100356:	e8 c3 1f 00 00       	call   8010231e <lapicid>
8010035b:	83 ec 08             	sub    $0x8,%esp
8010035e:	50                   	push   %eax
8010035f:	68 2d 68 10 80       	push   $0x8010682d
80100364:	e8 76 02 00 00       	call   801005df <cprintf>
  cprintf(s);
80100369:	83 c4 04             	add    $0x4,%esp
8010036c:	ff 75 08             	pushl  0x8(%ebp)
8010036f:	e8 6b 02 00 00       	call   801005df <cprintf>
  cprintf("\n");
80100374:	c7 04 24 c7 71 10 80 	movl   $0x801071c7,(%esp)
8010037b:	e8 5f 02 00 00       	call   801005df <cprintf>
  getcallerpcs(&s, pcs);
80100380:	83 c4 08             	add    $0x8,%esp
80100383:	8d 45 d0             	lea    -0x30(%ebp),%eax
80100386:	50                   	push   %eax
80100387:	8d 45 08             	lea    0x8(%ebp),%eax
8010038a:	50                   	push   %eax
8010038b:	e8 37 38 00 00       	call   80103bc7 <getcallerpcs>
  for(i=0; i<10; i++)
80100390:	83 c4 10             	add    $0x10,%esp
80100393:	bb 00 00 00 00       	mov    $0x0,%ebx
80100398:	eb 15                	jmp    801003af <panic+0x6b>
    cprintf(" %p", pcs[i]);
8010039a:	83 ec 08             	sub    $0x8,%esp
8010039d:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003a1:	68 41 68 10 80       	push   $0x80106841
801003a6:	e8 34 02 00 00       	call   801005df <cprintf>
  for(i=0; i<10; i++)
801003ab:	43                   	inc    %ebx
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	83 fb 09             	cmp    $0x9,%ebx
801003b2:	7e e6                	jle    8010039a <panic+0x56>
  panicked = 1; // freeze other CPU
801003b4:	c7 05 58 ef 10 80 01 	movl   $0x1,0x8010ef58
801003bb:	00 00 00 
  for(;;)
801003be:	eb fe                	jmp    801003be <panic+0x7a>

801003c0 <cgaputc>:
{
801003c0:	55                   	push   %ebp
801003c1:	89 e5                	mov    %esp,%ebp
801003c3:	57                   	push   %edi
801003c4:	56                   	push   %esi
801003c5:	53                   	push   %ebx
801003c6:	83 ec 0c             	sub    $0xc,%esp
801003c9:	89 c3                	mov    %eax,%ebx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003cb:	bf d4 03 00 00       	mov    $0x3d4,%edi
801003d0:	b0 0e                	mov    $0xe,%al
801003d2:	89 fa                	mov    %edi,%edx
801003d4:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003d5:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801003da:	89 ca                	mov    %ecx,%edx
801003dc:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003dd:	0f b6 f0             	movzbl %al,%esi
801003e0:	c1 e6 08             	shl    $0x8,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e3:	b0 0f                	mov    $0xf,%al
801003e5:	89 fa                	mov    %edi,%edx
801003e7:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003e8:	89 ca                	mov    %ecx,%edx
801003ea:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
801003eb:	0f b6 c8             	movzbl %al,%ecx
801003ee:	09 f1                	or     %esi,%ecx
  if(c == '\n')
801003f0:	83 fb 0a             	cmp    $0xa,%ebx
801003f3:	74 5a                	je     8010044f <cgaputc+0x8f>
  else if(c == BACKSPACE){
801003f5:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
801003fb:	74 62                	je     8010045f <cgaputc+0x9f>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
801003fd:	0f b6 c3             	movzbl %bl,%eax
80100400:	8d 59 01             	lea    0x1(%ecx),%ebx
80100403:	80 cc 07             	or     $0x7,%ah
80100406:	66 89 84 09 00 80 0b 	mov    %ax,-0x7ff48000(%ecx,%ecx,1)
8010040d:	80 
  if(pos < 0 || pos > 25*80)
8010040e:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
80100414:	77 56                	ja     8010046c <cgaputc+0xac>
  if((pos/80) >= 24){  // Scroll up.
80100416:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
8010041c:	7f 5b                	jg     80100479 <cgaputc+0xb9>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010041e:	be d4 03 00 00       	mov    $0x3d4,%esi
80100423:	b0 0e                	mov    $0xe,%al
80100425:	89 f2                	mov    %esi,%edx
80100427:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100428:	0f b6 c7             	movzbl %bh,%eax
8010042b:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
80100430:	89 ca                	mov    %ecx,%edx
80100432:	ee                   	out    %al,(%dx)
80100433:	b0 0f                	mov    $0xf,%al
80100435:	89 f2                	mov    %esi,%edx
80100437:	ee                   	out    %al,(%dx)
80100438:	88 d8                	mov    %bl,%al
8010043a:	89 ca                	mov    %ecx,%edx
8010043c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010043d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100444:	80 20 07 
}
80100447:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010044a:	5b                   	pop    %ebx
8010044b:	5e                   	pop    %esi
8010044c:	5f                   	pop    %edi
8010044d:	5d                   	pop    %ebp
8010044e:	c3                   	ret    
    pos += 80 - pos%80;
8010044f:	bb 50 00 00 00       	mov    $0x50,%ebx
80100454:	89 c8                	mov    %ecx,%eax
80100456:	99                   	cltd   
80100457:	f7 fb                	idiv   %ebx
80100459:	29 d3                	sub    %edx,%ebx
8010045b:	01 cb                	add    %ecx,%ebx
8010045d:	eb af                	jmp    8010040e <cgaputc+0x4e>
    if(pos > 0) --pos;
8010045f:	85 c9                	test   %ecx,%ecx
80100461:	7e 05                	jle    80100468 <cgaputc+0xa8>
80100463:	8d 59 ff             	lea    -0x1(%ecx),%ebx
80100466:	eb a6                	jmp    8010040e <cgaputc+0x4e>
  pos |= inb(CRTPORT+1);
80100468:	89 cb                	mov    %ecx,%ebx
8010046a:	eb a2                	jmp    8010040e <cgaputc+0x4e>
    panic("pos under/overflow");
8010046c:	83 ec 0c             	sub    $0xc,%esp
8010046f:	68 45 68 10 80       	push   $0x80106845
80100474:	e8 cb fe ff ff       	call   80100344 <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100479:	83 ec 04             	sub    $0x4,%esp
8010047c:	68 60 0e 00 00       	push   $0xe60
80100481:	68 a0 80 0b 80       	push   $0x800b80a0
80100486:	68 00 80 0b 80       	push   $0x800b8000
8010048b:	e8 7e 39 00 00       	call   80103e0e <memmove>
    pos -= 80;
80100490:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100493:	b8 80 07 00 00       	mov    $0x780,%eax
80100498:	29 d8                	sub    %ebx,%eax
8010049a:	01 c0                	add    %eax,%eax
8010049c:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004a3:	83 c4 0c             	add    $0xc,%esp
801004a6:	50                   	push   %eax
801004a7:	6a 00                	push   $0x0
801004a9:	52                   	push   %edx
801004aa:	e8 e9 38 00 00       	call   80103d98 <memset>
801004af:	83 c4 10             	add    $0x10,%esp
801004b2:	e9 67 ff ff ff       	jmp    8010041e <cgaputc+0x5e>

801004b7 <consputc>:
  if(panicked){
801004b7:	83 3d 58 ef 10 80 00 	cmpl   $0x0,0x8010ef58
801004be:	74 03                	je     801004c3 <consputc+0xc>
  asm volatile("cli");
801004c0:	fa                   	cli    
    for(;;)
801004c1:	eb fe                	jmp    801004c1 <consputc+0xa>
{
801004c3:	55                   	push   %ebp
801004c4:	89 e5                	mov    %esp,%ebp
801004c6:	53                   	push   %ebx
801004c7:	83 ec 04             	sub    $0x4,%esp
801004ca:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
801004cc:	3d 00 01 00 00       	cmp    $0x100,%eax
801004d1:	74 18                	je     801004eb <consputc+0x34>
    uartputc(c);
801004d3:	83 ec 0c             	sub    $0xc,%esp
801004d6:	50                   	push   %eax
801004d7:	e8 74 4d 00 00       	call   80105250 <uartputc>
801004dc:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
801004df:	89 d8                	mov    %ebx,%eax
801004e1:	e8 da fe ff ff       	call   801003c0 <cgaputc>
}
801004e6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801004e9:	c9                   	leave  
801004ea:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004eb:	83 ec 0c             	sub    $0xc,%esp
801004ee:	6a 08                	push   $0x8
801004f0:	e8 5b 4d 00 00       	call   80105250 <uartputc>
801004f5:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004fc:	e8 4f 4d 00 00       	call   80105250 <uartputc>
80100501:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100508:	e8 43 4d 00 00       	call   80105250 <uartputc>
8010050d:	83 c4 10             	add    $0x10,%esp
80100510:	eb cd                	jmp    801004df <consputc+0x28>

80100512 <printint>:
{
80100512:	55                   	push   %ebp
80100513:	89 e5                	mov    %esp,%ebp
80100515:	57                   	push   %edi
80100516:	56                   	push   %esi
80100517:	53                   	push   %ebx
80100518:	83 ec 2c             	sub    $0x2c,%esp
8010051b:	89 c3                	mov    %eax,%ebx
8010051d:	89 d6                	mov    %edx,%esi
8010051f:	89 c8                	mov    %ecx,%eax
  if(sign && (sign = xx < 0))
80100521:	85 c9                	test   %ecx,%ecx
80100523:	74 09                	je     8010052e <printint+0x1c>
80100525:	89 d8                	mov    %ebx,%eax
80100527:	c1 e8 1f             	shr    $0x1f,%eax
8010052a:	85 db                	test   %ebx,%ebx
8010052c:	78 39                	js     80100567 <printint+0x55>
    x = xx;
8010052e:	89 d9                	mov    %ebx,%ecx
  i = 0;
80100530:	bb 00 00 00 00       	mov    $0x0,%ebx
80100535:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    buf[i++] = digits[x % base];
80100538:	89 c8                	mov    %ecx,%eax
8010053a:	ba 00 00 00 00       	mov    $0x0,%edx
8010053f:	f7 f6                	div    %esi
80100541:	89 df                	mov    %ebx,%edi
80100543:	43                   	inc    %ebx
80100544:	8a 92 70 68 10 80    	mov    -0x7fef9790(%edx),%dl
8010054a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
8010054e:	89 ca                	mov    %ecx,%edx
80100550:	89 c1                	mov    %eax,%ecx
80100552:	39 f2                	cmp    %esi,%edx
80100554:	73 e2                	jae    80100538 <printint+0x26>
  if(sign)
80100556:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80100559:	85 c0                	test   %eax,%eax
8010055b:	74 1a                	je     80100577 <printint+0x65>
    buf[i++] = '-';
8010055d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
80100562:	8d 5f 02             	lea    0x2(%edi),%ebx
80100565:	eb 10                	jmp    80100577 <printint+0x65>
    x = -xx;
80100567:	89 d9                	mov    %ebx,%ecx
80100569:	f7 d9                	neg    %ecx
8010056b:	eb c3                	jmp    80100530 <printint+0x1e>
    consputc(buf[i]);
8010056d:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
80100572:	e8 40 ff ff ff       	call   801004b7 <consputc>
  while(--i >= 0)
80100577:	4b                   	dec    %ebx
80100578:	79 f3                	jns    8010056d <printint+0x5b>
}
8010057a:	83 c4 2c             	add    $0x2c,%esp
8010057d:	5b                   	pop    %ebx
8010057e:	5e                   	pop    %esi
8010057f:	5f                   	pop    %edi
80100580:	5d                   	pop    %ebp
80100581:	c3                   	ret    

80100582 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100582:	55                   	push   %ebp
80100583:	89 e5                	mov    %esp,%ebp
80100585:	57                   	push   %edi
80100586:	56                   	push   %esi
80100587:	53                   	push   %ebx
80100588:	83 ec 18             	sub    $0x18,%esp
8010058b:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010058e:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
80100591:	ff 75 08             	pushl  0x8(%ebp)
80100594:	e8 5b 10 00 00       	call   801015f4 <iunlock>
  acquire(&cons.lock);
80100599:	c7 04 24 20 ef 10 80 	movl   $0x8010ef20,(%esp)
801005a0:	e8 47 37 00 00       	call   80103cec <acquire>
  for(i = 0; i < n; i++)
801005a5:	83 c4 10             	add    $0x10,%esp
801005a8:	bb 00 00 00 00       	mov    $0x0,%ebx
801005ad:	eb 0a                	jmp    801005b9 <consolewrite+0x37>
    consputc(buf[i] & 0xff);
801005af:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005b3:	e8 ff fe ff ff       	call   801004b7 <consputc>
  for(i = 0; i < n; i++)
801005b8:	43                   	inc    %ebx
801005b9:	39 f3                	cmp    %esi,%ebx
801005bb:	7c f2                	jl     801005af <consolewrite+0x2d>
  release(&cons.lock);
801005bd:	83 ec 0c             	sub    $0xc,%esp
801005c0:	68 20 ef 10 80       	push   $0x8010ef20
801005c5:	e8 87 37 00 00       	call   80103d51 <release>
  ilock(ip);
801005ca:	83 c4 04             	add    $0x4,%esp
801005cd:	ff 75 08             	pushl  0x8(%ebp)
801005d0:	e8 5f 0f 00 00       	call   80101534 <ilock>

  return n;
}
801005d5:	89 f0                	mov    %esi,%eax
801005d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005da:	5b                   	pop    %ebx
801005db:	5e                   	pop    %esi
801005dc:	5f                   	pop    %edi
801005dd:	5d                   	pop    %ebp
801005de:	c3                   	ret    

801005df <cprintf>:
{
801005df:	55                   	push   %ebp
801005e0:	89 e5                	mov    %esp,%ebp
801005e2:	57                   	push   %edi
801005e3:	56                   	push   %esi
801005e4:	53                   	push   %ebx
801005e5:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801005e8:	a1 54 ef 10 80       	mov    0x8010ef54,%eax
801005ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
801005f0:	85 c0                	test   %eax,%eax
801005f2:	75 10                	jne    80100604 <cprintf+0x25>
  if (fmt == 0)
801005f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
801005f8:	74 1c                	je     80100616 <cprintf+0x37>
  argp = (uint*)(void*)(&fmt + 1);
801005fa:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801005fd:	be 00 00 00 00       	mov    $0x0,%esi
80100602:	eb 25                	jmp    80100629 <cprintf+0x4a>
    acquire(&cons.lock);
80100604:	83 ec 0c             	sub    $0xc,%esp
80100607:	68 20 ef 10 80       	push   $0x8010ef20
8010060c:	e8 db 36 00 00       	call   80103cec <acquire>
80100611:	83 c4 10             	add    $0x10,%esp
80100614:	eb de                	jmp    801005f4 <cprintf+0x15>
    panic("null fmt");
80100616:	83 ec 0c             	sub    $0xc,%esp
80100619:	68 5f 68 10 80       	push   $0x8010685f
8010061e:	e8 21 fd ff ff       	call   80100344 <panic>
      consputc(c);
80100623:	e8 8f fe ff ff       	call   801004b7 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100628:	46                   	inc    %esi
80100629:	8b 55 08             	mov    0x8(%ebp),%edx
8010062c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100630:	85 c0                	test   %eax,%eax
80100632:	0f 84 ac 00 00 00    	je     801006e4 <cprintf+0x105>
    if(c != '%'){
80100638:	83 f8 25             	cmp    $0x25,%eax
8010063b:	75 e6                	jne    80100623 <cprintf+0x44>
    c = fmt[++i] & 0xff;
8010063d:	46                   	inc    %esi
8010063e:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100642:	85 db                	test   %ebx,%ebx
80100644:	0f 84 9a 00 00 00    	je     801006e4 <cprintf+0x105>
    switch(c){
8010064a:	83 fb 70             	cmp    $0x70,%ebx
8010064d:	74 2e                	je     8010067d <cprintf+0x9e>
8010064f:	7f 22                	jg     80100673 <cprintf+0x94>
80100651:	83 fb 25             	cmp    $0x25,%ebx
80100654:	74 69                	je     801006bf <cprintf+0xe0>
80100656:	83 fb 64             	cmp    $0x64,%ebx
80100659:	75 73                	jne    801006ce <cprintf+0xef>
      printint(*argp++, 10, 1);
8010065b:	8d 5f 04             	lea    0x4(%edi),%ebx
8010065e:	8b 07                	mov    (%edi),%eax
80100660:	b9 01 00 00 00       	mov    $0x1,%ecx
80100665:	ba 0a 00 00 00       	mov    $0xa,%edx
8010066a:	e8 a3 fe ff ff       	call   80100512 <printint>
8010066f:	89 df                	mov    %ebx,%edi
      break;
80100671:	eb b5                	jmp    80100628 <cprintf+0x49>
    switch(c){
80100673:	83 fb 73             	cmp    $0x73,%ebx
80100676:	74 1d                	je     80100695 <cprintf+0xb6>
80100678:	83 fb 78             	cmp    $0x78,%ebx
8010067b:	75 51                	jne    801006ce <cprintf+0xef>
      printint(*argp++, 16, 0);
8010067d:	8d 5f 04             	lea    0x4(%edi),%ebx
80100680:	8b 07                	mov    (%edi),%eax
80100682:	b9 00 00 00 00       	mov    $0x0,%ecx
80100687:	ba 10 00 00 00       	mov    $0x10,%edx
8010068c:	e8 81 fe ff ff       	call   80100512 <printint>
80100691:	89 df                	mov    %ebx,%edi
      break;
80100693:	eb 93                	jmp    80100628 <cprintf+0x49>
      if((s = (char*)*argp++) == 0)
80100695:	8d 47 04             	lea    0x4(%edi),%eax
80100698:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010069b:	8b 1f                	mov    (%edi),%ebx
8010069d:	85 db                	test   %ebx,%ebx
8010069f:	75 10                	jne    801006b1 <cprintf+0xd2>
        s = "(null)";
801006a1:	bb 58 68 10 80       	mov    $0x80106858,%ebx
801006a6:	eb 09                	jmp    801006b1 <cprintf+0xd2>
        consputc(*s);
801006a8:	0f be c0             	movsbl %al,%eax
801006ab:	e8 07 fe ff ff       	call   801004b7 <consputc>
      for(; *s; s++)
801006b0:	43                   	inc    %ebx
801006b1:	8a 03                	mov    (%ebx),%al
801006b3:	84 c0                	test   %al,%al
801006b5:	75 f1                	jne    801006a8 <cprintf+0xc9>
      if((s = (char*)*argp++) == 0)
801006b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801006ba:	e9 69 ff ff ff       	jmp    80100628 <cprintf+0x49>
      consputc('%');
801006bf:	b8 25 00 00 00       	mov    $0x25,%eax
801006c4:	e8 ee fd ff ff       	call   801004b7 <consputc>
      break;
801006c9:	e9 5a ff ff ff       	jmp    80100628 <cprintf+0x49>
      consputc('%');
801006ce:	b8 25 00 00 00       	mov    $0x25,%eax
801006d3:	e8 df fd ff ff       	call   801004b7 <consputc>
      consputc(c);
801006d8:	89 d8                	mov    %ebx,%eax
801006da:	e8 d8 fd ff ff       	call   801004b7 <consputc>
      break;
801006df:	e9 44 ff ff ff       	jmp    80100628 <cprintf+0x49>
  if(locking)
801006e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
801006e8:	75 08                	jne    801006f2 <cprintf+0x113>
}
801006ea:	8d 65 f4             	lea    -0xc(%ebp),%esp
801006ed:	5b                   	pop    %ebx
801006ee:	5e                   	pop    %esi
801006ef:	5f                   	pop    %edi
801006f0:	5d                   	pop    %ebp
801006f1:	c3                   	ret    
    release(&cons.lock);
801006f2:	83 ec 0c             	sub    $0xc,%esp
801006f5:	68 20 ef 10 80       	push   $0x8010ef20
801006fa:	e8 52 36 00 00       	call   80103d51 <release>
801006ff:	83 c4 10             	add    $0x10,%esp
}
80100702:	eb e6                	jmp    801006ea <cprintf+0x10b>

80100704 <consoleintr>:
{
80100704:	55                   	push   %ebp
80100705:	89 e5                	mov    %esp,%ebp
80100707:	57                   	push   %edi
80100708:	56                   	push   %esi
80100709:	53                   	push   %ebx
8010070a:	83 ec 18             	sub    $0x18,%esp
8010070d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100710:	68 20 ef 10 80       	push   $0x8010ef20
80100715:	e8 d2 35 00 00       	call   80103cec <acquire>
  while((c = getc()) >= 0){
8010071a:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
8010071d:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
80100722:	eb 13                	jmp    80100737 <consoleintr+0x33>
    switch(c){
80100724:	83 ff 08             	cmp    $0x8,%edi
80100727:	0f 84 d1 00 00 00    	je     801007fe <consoleintr+0xfa>
8010072d:	83 ff 10             	cmp    $0x10,%edi
80100730:	75 25                	jne    80100757 <consoleintr+0x53>
80100732:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100737:	ff d3                	call   *%ebx
80100739:	89 c7                	mov    %eax,%edi
8010073b:	85 c0                	test   %eax,%eax
8010073d:	0f 88 eb 00 00 00    	js     8010082e <consoleintr+0x12a>
    switch(c){
80100743:	83 ff 15             	cmp    $0x15,%edi
80100746:	0f 84 8d 00 00 00    	je     801007d9 <consoleintr+0xd5>
8010074c:	7e d6                	jle    80100724 <consoleintr+0x20>
8010074e:	83 ff 7f             	cmp    $0x7f,%edi
80100751:	0f 84 a7 00 00 00    	je     801007fe <consoleintr+0xfa>
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100757:	85 ff                	test   %edi,%edi
80100759:	74 dc                	je     80100737 <consoleintr+0x33>
8010075b:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100760:	89 c2                	mov    %eax,%edx
80100762:	2b 15 00 ef 10 80    	sub    0x8010ef00,%edx
80100768:	83 fa 7f             	cmp    $0x7f,%edx
8010076b:	77 ca                	ja     80100737 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
8010076d:	83 ff 0d             	cmp    $0xd,%edi
80100770:	0f 84 ae 00 00 00    	je     80100824 <consoleintr+0x120>
        input.buf[input.e++ % INPUT_BUF] = c;
80100776:	8d 50 01             	lea    0x1(%eax),%edx
80100779:	89 15 08 ef 10 80    	mov    %edx,0x8010ef08
8010077f:	83 e0 7f             	and    $0x7f,%eax
80100782:	89 f9                	mov    %edi,%ecx
80100784:	88 88 80 ee 10 80    	mov    %cl,-0x7fef1180(%eax)
        consputc(c);
8010078a:	89 f8                	mov    %edi,%eax
8010078c:	e8 26 fd ff ff       	call   801004b7 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100791:	83 ff 0a             	cmp    $0xa,%edi
80100794:	74 15                	je     801007ab <consoleintr+0xa7>
80100796:	83 ff 04             	cmp    $0x4,%edi
80100799:	74 10                	je     801007ab <consoleintr+0xa7>
8010079b:	a1 00 ef 10 80       	mov    0x8010ef00,%eax
801007a0:	83 e8 80             	sub    $0xffffff80,%eax
801007a3:	39 05 08 ef 10 80    	cmp    %eax,0x8010ef08
801007a9:	75 8c                	jne    80100737 <consoleintr+0x33>
          input.w = input.e;
801007ab:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007b0:	a3 04 ef 10 80       	mov    %eax,0x8010ef04
          wakeup(&input.r);
801007b5:	83 ec 0c             	sub    $0xc,%esp
801007b8:	68 00 ef 10 80       	push   $0x8010ef00
801007bd:	e8 e8 2e 00 00       	call   801036aa <wakeup>
801007c2:	83 c4 10             	add    $0x10,%esp
801007c5:	e9 6d ff ff ff       	jmp    80100737 <consoleintr+0x33>
        input.e--;
801007ca:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
801007cf:	b8 00 01 00 00       	mov    $0x100,%eax
801007d4:	e8 de fc ff ff       	call   801004b7 <consputc>
      while(input.e != input.w &&
801007d9:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
801007de:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
801007e4:	0f 84 4d ff ff ff    	je     80100737 <consoleintr+0x33>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801007ea:	48                   	dec    %eax
801007eb:	89 c2                	mov    %eax,%edx
801007ed:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
801007f0:	80 ba 80 ee 10 80 0a 	cmpb   $0xa,-0x7fef1180(%edx)
801007f7:	75 d1                	jne    801007ca <consoleintr+0xc6>
801007f9:	e9 39 ff ff ff       	jmp    80100737 <consoleintr+0x33>
      if(input.e != input.w){
801007fe:	a1 08 ef 10 80       	mov    0x8010ef08,%eax
80100803:	3b 05 04 ef 10 80    	cmp    0x8010ef04,%eax
80100809:	0f 84 28 ff ff ff    	je     80100737 <consoleintr+0x33>
        input.e--;
8010080f:	48                   	dec    %eax
80100810:	a3 08 ef 10 80       	mov    %eax,0x8010ef08
        consputc(BACKSPACE);
80100815:	b8 00 01 00 00       	mov    $0x100,%eax
8010081a:	e8 98 fc ff ff       	call   801004b7 <consputc>
8010081f:	e9 13 ff ff ff       	jmp    80100737 <consoleintr+0x33>
        c = (c == '\r') ? '\n' : c;
80100824:	bf 0a 00 00 00       	mov    $0xa,%edi
80100829:	e9 48 ff ff ff       	jmp    80100776 <consoleintr+0x72>
  release(&cons.lock);
8010082e:	83 ec 0c             	sub    $0xc,%esp
80100831:	68 20 ef 10 80       	push   $0x8010ef20
80100836:	e8 16 35 00 00       	call   80103d51 <release>
  if(doprocdump) {
8010083b:	83 c4 10             	add    $0x10,%esp
8010083e:	85 f6                	test   %esi,%esi
80100840:	75 08                	jne    8010084a <consoleintr+0x146>
}
80100842:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100845:	5b                   	pop    %ebx
80100846:	5e                   	pop    %esi
80100847:	5f                   	pop    %edi
80100848:	5d                   	pop    %ebp
80100849:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
8010084a:	e8 fa 2e 00 00       	call   80103749 <procdump>
}
8010084f:	eb f1                	jmp    80100842 <consoleintr+0x13e>

80100851 <consoleinit>:

void
consoleinit(void)
{
80100851:	55                   	push   %ebp
80100852:	89 e5                	mov    %esp,%ebp
80100854:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100857:	68 68 68 10 80       	push   $0x80106868
8010085c:	68 20 ef 10 80       	push   $0x8010ef20
80100861:	e8 46 33 00 00       	call   80103bac <initlock>

  devsw[CONSOLE].write = consolewrite;
80100866:	c7 05 0c f9 10 80 82 	movl   $0x80100582,0x8010f90c
8010086d:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100870:	c7 05 08 f9 10 80 65 	movl   $0x80100265,0x8010f908
80100877:	02 10 80 
  cons.locking = 1;
8010087a:	c7 05 54 ef 10 80 01 	movl   $0x1,0x8010ef54
80100881:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100884:	83 c4 08             	add    $0x8,%esp
80100887:	6a 00                	push   $0x0
80100889:	6a 01                	push   $0x1
8010088b:	e8 90 16 00 00       	call   80101f20 <ioapicenable>
}
80100890:	83 c4 10             	add    $0x10,%esp
80100893:	c9                   	leave  
80100894:	c3                   	ret    

80100895 <exec>:
#include "defs.h"
#include "x86.h"
#include "elf.h"

int exec(char *path, char **argv)
{
80100895:	55                   	push   %ebp
80100896:	89 e5                	mov    %esp,%ebp
80100898:	57                   	push   %edi
80100899:	56                   	push   %esi
8010089a:	53                   	push   %ebx
8010089b:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
    uint argc, sz, sp, ustack[3 + MAXARG + 1];
    struct elfhdr elf;
    struct inode *ip;
    struct proghdr ph;
    pde_t *pgdir, *oldpgdir;
    struct proc *curproc = myproc();
801008a1:	e8 c1 28 00 00       	call   80103167 <myproc>
801008a6:	89 c7                	mov    %eax,%edi

    begin_op();
801008a8:	e8 6e 1e 00 00       	call   8010271b <begin_op>

    if ((ip = namei(path)) == 0)
801008ad:	83 ec 0c             	sub    $0xc,%esp
801008b0:	ff 75 08             	pushl  0x8(%ebp)
801008b3:	e8 e8 12 00 00       	call   80101ba0 <namei>
801008b8:	83 c4 10             	add    $0x10,%esp
801008bb:	85 c0                	test   %eax,%eax
801008bd:	74 5d                	je     8010091c <exec+0x87>
801008bf:	89 c3                	mov    %eax,%ebx

        cprintf("exec: fail\n");
        return -1;
    }
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    curproc->is_failed = 0;
801008c1:	c7 47 7c 00 00 00 00 	movl   $0x0,0x7c(%edi)
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

    ilock(ip);
801008c8:	83 ec 0c             	sub    $0xc,%esp
801008cb:	50                   	push   %eax
801008cc:	e8 63 0c 00 00       	call   80101534 <ilock>
    pgdir = 0;

    // Check ELF header
    if (readi(ip, (char *)&elf, 0, sizeof(elf)) != sizeof(elf))
801008d1:	6a 34                	push   $0x34
801008d3:	6a 00                	push   $0x0
801008d5:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801008db:	50                   	push   %eax
801008dc:	53                   	push   %ebx
801008dd:	e8 3f 0e 00 00       	call   80101721 <readi>
801008e2:	83 c4 20             	add    $0x20,%esp
801008e5:	83 f8 34             	cmp    $0x34,%eax
801008e8:	75 0c                	jne    801008f6 <exec+0x61>
        goto bad;
    if (elf.magic != ELF_MAGIC)
801008ea:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
801008f1:	45 4c 46 
801008f4:	74 49                	je     8010093f <exec+0xaa>
    return 0;

bad:
    if (pgdir)
        freevm(pgdir);
    if (ip)
801008f6:	85 db                	test   %ebx,%ebx
801008f8:	0f 84 fe 02 00 00    	je     80100bfc <exec+0x367>
    {
        iunlockput(ip);
801008fe:	83 ec 0c             	sub    $0xc,%esp
80100901:	53                   	push   %ebx
80100902:	e8 d0 0d 00 00       	call   801016d7 <iunlockput>
        end_op();
80100907:	e8 8b 1e 00 00       	call   80102797 <end_op>
8010090c:	83 c4 10             	add    $0x10,%esp
    }
    return -1;
8010090f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100914:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100917:	5b                   	pop    %ebx
80100918:	5e                   	pop    %esi
80100919:	5f                   	pop    %edi
8010091a:	5d                   	pop    %ebp
8010091b:	c3                   	ret    
        end_op();
8010091c:	e8 76 1e 00 00       	call   80102797 <end_op>
        curproc->is_failed = 1;
80100921:	c7 47 7c 01 00 00 00 	movl   $0x1,0x7c(%edi)
        cprintf("exec: fail\n");
80100928:	83 ec 0c             	sub    $0xc,%esp
8010092b:	68 81 68 10 80       	push   $0x80106881
80100930:	e8 aa fc ff ff       	call   801005df <cprintf>
        return -1;
80100935:	83 c4 10             	add    $0x10,%esp
80100938:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010093d:	eb d5                	jmp    80100914 <exec+0x7f>
    if ((pgdir = setupkvm()) == 0)
8010093f:	e8 6d 5c 00 00       	call   801065b1 <setupkvm>
80100944:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
8010094a:	85 c0                	test   %eax,%eax
8010094c:	74 a8                	je     801008f6 <exec+0x61>
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
8010094e:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
    sz = 0;
80100954:	b9 00 00 00 00       	mov    $0x0,%ecx
    for (i = 0, off = elf.phoff; i < elf.phnum; i++, off += sizeof(ph))
80100959:	be 00 00 00 00       	mov    $0x0,%esi
8010095e:	89 bd ec fe ff ff    	mov    %edi,-0x114(%ebp)
80100964:	89 cf                	mov    %ecx,%edi
80100966:	eb 0a                	jmp    80100972 <exec+0xdd>
80100968:	46                   	inc    %esi
80100969:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
8010096f:	83 c0 20             	add    $0x20,%eax
80100972:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
80100979:	39 f2                	cmp    %esi,%edx
8010097b:	0f 8e 98 00 00 00    	jle    80100a19 <exec+0x184>
        if (readi(ip, (char *)&ph, off, sizeof(ph)) != sizeof(ph))
80100981:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100987:	6a 20                	push   $0x20
80100989:	50                   	push   %eax
8010098a:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100990:	50                   	push   %eax
80100991:	53                   	push   %ebx
80100992:	e8 8a 0d 00 00       	call   80101721 <readi>
80100997:	83 c4 10             	add    $0x10,%esp
8010099a:	83 f8 20             	cmp    $0x20,%eax
8010099d:	0f 85 bd 00 00 00    	jne    80100a60 <exec+0x1cb>
        if (ph.type != ELF_PROG_LOAD)
801009a3:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
801009aa:	75 bc                	jne    80100968 <exec+0xd3>
        if (ph.memsz < ph.filesz)
801009ac:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
801009b2:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
801009b8:	0f 82 a2 00 00 00    	jb     80100a60 <exec+0x1cb>
        if (ph.vaddr + ph.memsz < ph.vaddr)
801009be:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
801009c4:	0f 82 96 00 00 00    	jb     80100a60 <exec+0x1cb>
        if ((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
801009ca:	83 ec 04             	sub    $0x4,%esp
801009cd:	50                   	push   %eax
801009ce:	57                   	push   %edi
801009cf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
801009d5:	e8 86 5a 00 00       	call   80106460 <allocuvm>
801009da:	89 c7                	mov    %eax,%edi
801009dc:	83 c4 10             	add    $0x10,%esp
801009df:	85 c0                	test   %eax,%eax
801009e1:	74 7d                	je     80100a60 <exec+0x1cb>
        if (ph.vaddr % PGSIZE != 0)
801009e3:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
801009e9:	a9 ff 0f 00 00       	test   $0xfff,%eax
801009ee:	75 70                	jne    80100a60 <exec+0x1cb>
        if (loaduvm(pgdir, (char *)ph.vaddr, ip, ph.off, ph.filesz) < 0)
801009f0:	83 ec 0c             	sub    $0xc,%esp
801009f3:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
801009f9:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
801009ff:	53                   	push   %ebx
80100a00:	50                   	push   %eax
80100a01:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a07:	e8 29 59 00 00       	call   80106335 <loaduvm>
80100a0c:	83 c4 20             	add    $0x20,%esp
80100a0f:	85 c0                	test   %eax,%eax
80100a11:	0f 89 51 ff ff ff    	jns    80100968 <exec+0xd3>
80100a17:	eb 47                	jmp    80100a60 <exec+0x1cb>
    iunlockput(ip);
80100a19:	89 fe                	mov    %edi,%esi
80100a1b:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100a21:	83 ec 0c             	sub    $0xc,%esp
80100a24:	53                   	push   %ebx
80100a25:	e8 ad 0c 00 00       	call   801016d7 <iunlockput>
    end_op();
80100a2a:	e8 68 1d 00 00       	call   80102797 <end_op>
    sz = PGROUNDUP(sz);
80100a2f:	89 f0                	mov    %esi,%eax
80100a31:	05 ff 0f 00 00       	add    $0xfff,%eax
80100a36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if ((sz = allocuvm(pgdir, sz, sz + 2 * PGSIZE)) == 0)
80100a3b:	83 c4 0c             	add    $0xc,%esp
80100a3e:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a44:	52                   	push   %edx
80100a45:	50                   	push   %eax
80100a46:	8b 9d f0 fe ff ff    	mov    -0x110(%ebp),%ebx
80100a4c:	53                   	push   %ebx
80100a4d:	e8 0e 5a 00 00       	call   80106460 <allocuvm>
80100a52:	89 c6                	mov    %eax,%esi
80100a54:	83 c4 10             	add    $0x10,%esp
80100a57:	85 c0                	test   %eax,%eax
80100a59:	75 1b                	jne    80100a76 <exec+0x1e1>
    ip = 0;
80100a5b:	bb 00 00 00 00       	mov    $0x0,%ebx
        freevm(pgdir);
80100a60:	83 ec 0c             	sub    $0xc,%esp
80100a63:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a69:	e8 d5 5a 00 00       	call   80106543 <freevm>
80100a6e:	83 c4 10             	add    $0x10,%esp
80100a71:	e9 80 fe ff ff       	jmp    801008f6 <exec+0x61>
    clearpteu(pgdir, (char *)(sz - 2 * PGSIZE));
80100a76:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100a7c:	83 ec 08             	sub    $0x8,%esp
80100a7f:	50                   	push   %eax
80100a80:	53                   	push   %ebx
80100a81:	e8 b0 5b 00 00       	call   80106636 <clearpteu>
    for (argc = 0; argv[argc]; argc++)
80100a86:	83 c4 10             	add    $0x10,%esp
80100a89:	b8 00 00 00 00       	mov    $0x0,%eax
80100a8e:	89 bd f4 fe ff ff    	mov    %edi,-0x10c(%ebp)
80100a94:	89 c7                	mov    %eax,%edi
80100a96:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100a9c:	eb 08                	jmp    80100aa6 <exec+0x211>
        ustack[3 + argc] = sp;
80100a9e:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
    for (argc = 0; argv[argc]; argc++)
80100aa5:	47                   	inc    %edi
80100aa6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100aa9:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100aac:	8b 03                	mov    (%ebx),%eax
80100aae:	85 c0                	test   %eax,%eax
80100ab0:	74 43                	je     80100af5 <exec+0x260>
        if (argc >= MAXARG)
80100ab2:	83 ff 1f             	cmp    $0x1f,%edi
80100ab5:	0f 87 37 01 00 00    	ja     80100bf2 <exec+0x35d>
        sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100abb:	83 ec 0c             	sub    $0xc,%esp
80100abe:	50                   	push   %eax
80100abf:	e8 64 34 00 00       	call   80103f28 <strlen>
80100ac4:	29 c6                	sub    %eax,%esi
80100ac6:	4e                   	dec    %esi
80100ac7:	83 e6 fc             	and    $0xfffffffc,%esi
        if (copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100aca:	83 c4 04             	add    $0x4,%esp
80100acd:	ff 33                	pushl  (%ebx)
80100acf:	e8 54 34 00 00       	call   80103f28 <strlen>
80100ad4:	40                   	inc    %eax
80100ad5:	50                   	push   %eax
80100ad6:	ff 33                	pushl  (%ebx)
80100ad8:	56                   	push   %esi
80100ad9:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100adf:	e8 a4 5c 00 00       	call   80106788 <copyout>
80100ae4:	83 c4 20             	add    $0x20,%esp
80100ae7:	85 c0                	test   %eax,%eax
80100ae9:	79 b3                	jns    80100a9e <exec+0x209>
    ip = 0;
80100aeb:	bb 00 00 00 00       	mov    $0x0,%ebx
80100af0:	e9 6b ff ff ff       	jmp    80100a60 <exec+0x1cb>
    ustack[3 + argc] = 0;
80100af5:	89 fa                	mov    %edi,%edx
80100af7:	89 f1                	mov    %esi,%ecx
80100af9:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100aff:	89 c3                	mov    %eax,%ebx
80100b01:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
80100b07:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100b0e:	00 00 00 00 
    ustack[0] = 0xffffffff; // fake return PC
80100b12:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b19:	ff ff ff 
    ustack[1] = argc;
80100b1c:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
    ustack[2] = sp - (argc + 1) * 4; // argv pointer
80100b22:	89 95 f4 fe ff ff    	mov    %edx,-0x10c(%ebp)
80100b28:	8d 14 95 04 00 00 00 	lea    0x4(,%edx,4),%edx
80100b2f:	89 c8                	mov    %ecx,%eax
80100b31:	29 d0                	sub    %edx,%eax
80100b33:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
    sp -= (3 + argc + 1) * 4;
80100b39:	8b 95 f4 fe ff ff    	mov    -0x10c(%ebp),%edx
80100b3f:	8d 04 95 10 00 00 00 	lea    0x10(,%edx,4),%eax
80100b46:	29 c1                	sub    %eax,%ecx
80100b48:	89 8d f4 fe ff ff    	mov    %ecx,-0x10c(%ebp)
    if (copyout(pgdir, sp, ustack, (3 + argc + 1) * 4) < 0)
80100b4e:	50                   	push   %eax
80100b4f:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b55:	50                   	push   %eax
80100b56:	51                   	push   %ecx
80100b57:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b5d:	e8 26 5c 00 00       	call   80106788 <copyout>
80100b62:	83 c4 10             	add    $0x10,%esp
80100b65:	85 c0                	test   %eax,%eax
80100b67:	0f 88 f3 fe ff ff    	js     80100a60 <exec+0x1cb>
    for (last = s = path; *s; s++)
80100b6d:	8b 55 08             	mov    0x8(%ebp),%edx
80100b70:	89 d0                	mov    %edx,%eax
80100b72:	eb 01                	jmp    80100b75 <exec+0x2e0>
80100b74:	40                   	inc    %eax
80100b75:	8a 08                	mov    (%eax),%cl
80100b77:	84 c9                	test   %cl,%cl
80100b79:	74 0a                	je     80100b85 <exec+0x2f0>
        if (*s == '/')
80100b7b:	80 f9 2f             	cmp    $0x2f,%cl
80100b7e:	75 f4                	jne    80100b74 <exec+0x2df>
            last = s + 1;
80100b80:	8d 50 01             	lea    0x1(%eax),%edx
80100b83:	eb ef                	jmp    80100b74 <exec+0x2df>
    safestrcpy(curproc->name, last, sizeof(curproc->name));
80100b85:	8d 47 6c             	lea    0x6c(%edi),%eax
80100b88:	83 ec 04             	sub    $0x4,%esp
80100b8b:	6a 10                	push   $0x10
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	e8 5c 33 00 00       	call   80103ef0 <safestrcpy>
    oldpgdir = curproc->pgdir;
80100b94:	8b 5f 04             	mov    0x4(%edi),%ebx
    curproc->pgdir = pgdir;
80100b97:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b9d:	89 47 04             	mov    %eax,0x4(%edi)
    curproc->sz = sz;
80100ba0:	89 37                	mov    %esi,(%edi)
    curproc->time_counter = time_count;
80100ba2:	a1 20 1d 11 80       	mov    0x80111d20,%eax
80100ba7:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)
    time_count = time_count + 1;
80100bad:	40                   	inc    %eax
80100bae:	a3 20 1d 11 80       	mov    %eax,0x80111d20
    curproc->block_bit_vector = 0;
80100bb3:	c7 87 84 00 00 00 00 	movl   $0x0,0x84(%edi)
80100bba:	00 00 00 
    curproc->tf->eip = elf.entry; // main
80100bbd:	8b 47 18             	mov    0x18(%edi),%eax
80100bc0:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bc6:	89 50 38             	mov    %edx,0x38(%eax)
    curproc->tf->esp = sp;
80100bc9:	8b 47 18             	mov    0x18(%edi),%eax
80100bcc:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bd2:	89 48 44             	mov    %ecx,0x44(%eax)
    switchuvm(curproc);
80100bd5:	89 3c 24             	mov    %edi,(%esp)
80100bd8:	e8 93 55 00 00       	call   80106170 <switchuvm>
    freevm(oldpgdir);
80100bdd:	89 1c 24             	mov    %ebx,(%esp)
80100be0:	e8 5e 59 00 00       	call   80106543 <freevm>
    return 0;
80100be5:	83 c4 10             	add    $0x10,%esp
80100be8:	b8 00 00 00 00       	mov    $0x0,%eax
80100bed:	e9 22 fd ff ff       	jmp    80100914 <exec+0x7f>
    ip = 0;
80100bf2:	bb 00 00 00 00       	mov    $0x0,%ebx
80100bf7:	e9 64 fe ff ff       	jmp    80100a60 <exec+0x1cb>
    return -1;
80100bfc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c01:	e9 0e fd ff ff       	jmp    80100914 <exec+0x7f>

80100c06 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c06:	55                   	push   %ebp
80100c07:	89 e5                	mov    %esp,%ebp
80100c09:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c0c:	68 8d 68 10 80       	push   $0x8010688d
80100c11:	68 60 ef 10 80       	push   $0x8010ef60
80100c16:	e8 91 2f 00 00       	call   80103bac <initlock>
}
80100c1b:	83 c4 10             	add    $0x10,%esp
80100c1e:	c9                   	leave  
80100c1f:	c3                   	ret    

80100c20 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c20:	55                   	push   %ebp
80100c21:	89 e5                	mov    %esp,%ebp
80100c23:	53                   	push   %ebx
80100c24:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c27:	68 60 ef 10 80       	push   $0x8010ef60
80100c2c:	e8 bb 30 00 00       	call   80103cec <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c31:	83 c4 10             	add    $0x10,%esp
80100c34:	bb 94 ef 10 80       	mov    $0x8010ef94,%ebx
80100c39:	81 fb f4 f8 10 80    	cmp    $0x8010f8f4,%ebx
80100c3f:	73 29                	jae    80100c6a <filealloc+0x4a>
    if(f->ref == 0){
80100c41:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c45:	74 05                	je     80100c4c <filealloc+0x2c>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c47:	83 c3 18             	add    $0x18,%ebx
80100c4a:	eb ed                	jmp    80100c39 <filealloc+0x19>
      f->ref = 1;
80100c4c:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c53:	83 ec 0c             	sub    $0xc,%esp
80100c56:	68 60 ef 10 80       	push   $0x8010ef60
80100c5b:	e8 f1 30 00 00       	call   80103d51 <release>
      return f;
80100c60:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c63:	89 d8                	mov    %ebx,%eax
80100c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100c68:	c9                   	leave  
80100c69:	c3                   	ret    
  release(&ftable.lock);
80100c6a:	83 ec 0c             	sub    $0xc,%esp
80100c6d:	68 60 ef 10 80       	push   $0x8010ef60
80100c72:	e8 da 30 00 00       	call   80103d51 <release>
  return 0;
80100c77:	83 c4 10             	add    $0x10,%esp
80100c7a:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c7f:	eb e2                	jmp    80100c63 <filealloc+0x43>

80100c81 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100c81:	55                   	push   %ebp
80100c82:	89 e5                	mov    %esp,%ebp
80100c84:	53                   	push   %ebx
80100c85:	83 ec 10             	sub    $0x10,%esp
80100c88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100c8b:	68 60 ef 10 80       	push   $0x8010ef60
80100c90:	e8 57 30 00 00       	call   80103cec <acquire>
  if(f->ref < 1)
80100c95:	8b 43 04             	mov    0x4(%ebx),%eax
80100c98:	83 c4 10             	add    $0x10,%esp
80100c9b:	85 c0                	test   %eax,%eax
80100c9d:	7e 18                	jle    80100cb7 <filedup+0x36>
    panic("filedup");
  f->ref++;
80100c9f:	40                   	inc    %eax
80100ca0:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ca3:	83 ec 0c             	sub    $0xc,%esp
80100ca6:	68 60 ef 10 80       	push   $0x8010ef60
80100cab:	e8 a1 30 00 00       	call   80103d51 <release>
  return f;
}
80100cb0:	89 d8                	mov    %ebx,%eax
80100cb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cb5:	c9                   	leave  
80100cb6:	c3                   	ret    
    panic("filedup");
80100cb7:	83 ec 0c             	sub    $0xc,%esp
80100cba:	68 94 68 10 80       	push   $0x80106894
80100cbf:	e8 80 f6 ff ff       	call   80100344 <panic>

80100cc4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100cc4:	55                   	push   %ebp
80100cc5:	89 e5                	mov    %esp,%ebp
80100cc7:	57                   	push   %edi
80100cc8:	56                   	push   %esi
80100cc9:	53                   	push   %ebx
80100cca:	83 ec 38             	sub    $0x38,%esp
80100ccd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100cd0:	68 60 ef 10 80       	push   $0x8010ef60
80100cd5:	e8 12 30 00 00       	call   80103cec <acquire>
  if(f->ref < 1)
80100cda:	8b 43 04             	mov    0x4(%ebx),%eax
80100cdd:	83 c4 10             	add    $0x10,%esp
80100ce0:	85 c0                	test   %eax,%eax
80100ce2:	7e 58                	jle    80100d3c <fileclose+0x78>
    panic("fileclose");
  if(--f->ref > 0){
80100ce4:	48                   	dec    %eax
80100ce5:	89 43 04             	mov    %eax,0x4(%ebx)
80100ce8:	85 c0                	test   %eax,%eax
80100cea:	7f 5d                	jg     80100d49 <fileclose+0x85>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100cec:	8d 7d d0             	lea    -0x30(%ebp),%edi
80100cef:	b9 06 00 00 00       	mov    $0x6,%ecx
80100cf4:	89 de                	mov    %ebx,%esi
80100cf6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  f->ref = 0;
80100cf8:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100cff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d05:	83 ec 0c             	sub    $0xc,%esp
80100d08:	68 60 ef 10 80       	push   $0x8010ef60
80100d0d:	e8 3f 30 00 00       	call   80103d51 <release>

  if(ff.type == FD_PIPE)
80100d12:	8b 45 d0             	mov    -0x30(%ebp),%eax
80100d15:	83 c4 10             	add    $0x10,%esp
80100d18:	83 f8 01             	cmp    $0x1,%eax
80100d1b:	74 44                	je     80100d61 <fileclose+0x9d>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d1d:	83 f8 02             	cmp    $0x2,%eax
80100d20:	75 37                	jne    80100d59 <fileclose+0x95>
    begin_op();
80100d22:	e8 f4 19 00 00       	call   8010271b <begin_op>
    iput(ff.ip);
80100d27:	83 ec 0c             	sub    $0xc,%esp
80100d2a:	ff 75 e0             	pushl  -0x20(%ebp)
80100d2d:	e8 07 09 00 00       	call   80101639 <iput>
    end_op();
80100d32:	e8 60 1a 00 00       	call   80102797 <end_op>
80100d37:	83 c4 10             	add    $0x10,%esp
80100d3a:	eb 1d                	jmp    80100d59 <fileclose+0x95>
    panic("fileclose");
80100d3c:	83 ec 0c             	sub    $0xc,%esp
80100d3f:	68 9c 68 10 80       	push   $0x8010689c
80100d44:	e8 fb f5 ff ff       	call   80100344 <panic>
    release(&ftable.lock);
80100d49:	83 ec 0c             	sub    $0xc,%esp
80100d4c:	68 60 ef 10 80       	push   $0x8010ef60
80100d51:	e8 fb 2f 00 00       	call   80103d51 <release>
    return;
80100d56:	83 c4 10             	add    $0x10,%esp
  }
}
80100d59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100d5c:	5b                   	pop    %ebx
80100d5d:	5e                   	pop    %esi
80100d5e:	5f                   	pop    %edi
80100d5f:	5d                   	pop    %ebp
80100d60:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100d61:	83 ec 08             	sub    $0x8,%esp
80100d64:	0f be 45 d9          	movsbl -0x27(%ebp),%eax
80100d68:	50                   	push   %eax
80100d69:	ff 75 dc             	pushl  -0x24(%ebp)
80100d6c:	e8 0f 20 00 00       	call   80102d80 <pipeclose>
80100d71:	83 c4 10             	add    $0x10,%esp
80100d74:	eb e3                	jmp    80100d59 <fileclose+0x95>

80100d76 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100d76:	55                   	push   %ebp
80100d77:	89 e5                	mov    %esp,%ebp
80100d79:	53                   	push   %ebx
80100d7a:	83 ec 04             	sub    $0x4,%esp
80100d7d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100d80:	83 3b 02             	cmpl   $0x2,(%ebx)
80100d83:	75 31                	jne    80100db6 <filestat+0x40>
    ilock(f->ip);
80100d85:	83 ec 0c             	sub    $0xc,%esp
80100d88:	ff 73 10             	pushl  0x10(%ebx)
80100d8b:	e8 a4 07 00 00       	call   80101534 <ilock>
    stati(f->ip, st);
80100d90:	83 c4 08             	add    $0x8,%esp
80100d93:	ff 75 0c             	pushl  0xc(%ebp)
80100d96:	ff 73 10             	pushl  0x10(%ebx)
80100d99:	e8 59 09 00 00       	call   801016f7 <stati>
    iunlock(f->ip);
80100d9e:	83 c4 04             	add    $0x4,%esp
80100da1:	ff 73 10             	pushl  0x10(%ebx)
80100da4:	e8 4b 08 00 00       	call   801015f4 <iunlock>
    return 0;
80100da9:	83 c4 10             	add    $0x10,%esp
80100dac:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100db1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100db4:	c9                   	leave  
80100db5:	c3                   	ret    
  return -1;
80100db6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100dbb:	eb f4                	jmp    80100db1 <filestat+0x3b>

80100dbd <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100dbd:	55                   	push   %ebp
80100dbe:	89 e5                	mov    %esp,%ebp
80100dc0:	56                   	push   %esi
80100dc1:	53                   	push   %ebx
80100dc2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100dc5:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100dc9:	74 70                	je     80100e3b <fileread+0x7e>
    return -1;
  if(f->type == FD_PIPE)
80100dcb:	8b 03                	mov    (%ebx),%eax
80100dcd:	83 f8 01             	cmp    $0x1,%eax
80100dd0:	74 44                	je     80100e16 <fileread+0x59>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100dd2:	83 f8 02             	cmp    $0x2,%eax
80100dd5:	75 57                	jne    80100e2e <fileread+0x71>
    ilock(f->ip);
80100dd7:	83 ec 0c             	sub    $0xc,%esp
80100dda:	ff 73 10             	pushl  0x10(%ebx)
80100ddd:	e8 52 07 00 00       	call   80101534 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100de2:	ff 75 10             	pushl  0x10(%ebp)
80100de5:	ff 73 14             	pushl  0x14(%ebx)
80100de8:	ff 75 0c             	pushl  0xc(%ebp)
80100deb:	ff 73 10             	pushl  0x10(%ebx)
80100dee:	e8 2e 09 00 00       	call   80101721 <readi>
80100df3:	89 c6                	mov    %eax,%esi
80100df5:	83 c4 20             	add    $0x20,%esp
80100df8:	85 c0                	test   %eax,%eax
80100dfa:	7e 03                	jle    80100dff <fileread+0x42>
      f->off += r;
80100dfc:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100dff:	83 ec 0c             	sub    $0xc,%esp
80100e02:	ff 73 10             	pushl  0x10(%ebx)
80100e05:	e8 ea 07 00 00       	call   801015f4 <iunlock>
    return r;
80100e0a:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e0d:	89 f0                	mov    %esi,%eax
80100e0f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e12:	5b                   	pop    %ebx
80100e13:	5e                   	pop    %esi
80100e14:	5d                   	pop    %ebp
80100e15:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e16:	83 ec 04             	sub    $0x4,%esp
80100e19:	ff 75 10             	pushl  0x10(%ebp)
80100e1c:	ff 75 0c             	pushl  0xc(%ebp)
80100e1f:	ff 73 0c             	pushl  0xc(%ebx)
80100e22:	e8 aa 20 00 00       	call   80102ed1 <piperead>
80100e27:	89 c6                	mov    %eax,%esi
80100e29:	83 c4 10             	add    $0x10,%esp
80100e2c:	eb df                	jmp    80100e0d <fileread+0x50>
  panic("fileread");
80100e2e:	83 ec 0c             	sub    $0xc,%esp
80100e31:	68 a6 68 10 80       	push   $0x801068a6
80100e36:	e8 09 f5 ff ff       	call   80100344 <panic>
    return -1;
80100e3b:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e40:	eb cb                	jmp    80100e0d <fileread+0x50>

80100e42 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e42:	55                   	push   %ebp
80100e43:	89 e5                	mov    %esp,%ebp
80100e45:	57                   	push   %edi
80100e46:	56                   	push   %esi
80100e47:	53                   	push   %ebx
80100e48:	83 ec 1c             	sub    $0x1c,%esp
80100e4b:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100e4e:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100e52:	0f 84 cc 00 00 00    	je     80100f24 <filewrite+0xe2>
    return -1;
  if(f->type == FD_PIPE)
80100e58:	8b 06                	mov    (%esi),%eax
80100e5a:	83 f8 01             	cmp    $0x1,%eax
80100e5d:	74 10                	je     80100e6f <filewrite+0x2d>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e5f:	83 f8 02             	cmp    $0x2,%eax
80100e62:	0f 85 af 00 00 00    	jne    80100f17 <filewrite+0xd5>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100e68:	bf 00 00 00 00       	mov    $0x0,%edi
80100e6d:	eb 67                	jmp    80100ed6 <filewrite+0x94>
    return pipewrite(f->pipe, addr, n);
80100e6f:	83 ec 04             	sub    $0x4,%esp
80100e72:	ff 75 10             	pushl  0x10(%ebp)
80100e75:	ff 75 0c             	pushl  0xc(%ebp)
80100e78:	ff 76 0c             	pushl  0xc(%esi)
80100e7b:	e8 8c 1f 00 00       	call   80102e0c <pipewrite>
80100e80:	83 c4 10             	add    $0x10,%esp
80100e83:	e9 82 00 00 00       	jmp    80100f0a <filewrite+0xc8>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100e88:	e8 8e 18 00 00       	call   8010271b <begin_op>
      ilock(f->ip);
80100e8d:	83 ec 0c             	sub    $0xc,%esp
80100e90:	ff 76 10             	pushl  0x10(%esi)
80100e93:	e8 9c 06 00 00       	call   80101534 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100e98:	ff 75 e4             	pushl  -0x1c(%ebp)
80100e9b:	ff 76 14             	pushl  0x14(%esi)
80100e9e:	89 f8                	mov    %edi,%eax
80100ea0:	03 45 0c             	add    0xc(%ebp),%eax
80100ea3:	50                   	push   %eax
80100ea4:	ff 76 10             	pushl  0x10(%esi)
80100ea7:	e8 78 09 00 00       	call   80101824 <writei>
80100eac:	89 c3                	mov    %eax,%ebx
80100eae:	83 c4 20             	add    $0x20,%esp
80100eb1:	85 c0                	test   %eax,%eax
80100eb3:	7e 03                	jle    80100eb8 <filewrite+0x76>
        f->off += r;
80100eb5:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100eb8:	83 ec 0c             	sub    $0xc,%esp
80100ebb:	ff 76 10             	pushl  0x10(%esi)
80100ebe:	e8 31 07 00 00       	call   801015f4 <iunlock>
      end_op();
80100ec3:	e8 cf 18 00 00       	call   80102797 <end_op>

      if(r < 0)
80100ec8:	83 c4 10             	add    $0x10,%esp
80100ecb:	85 db                	test   %ebx,%ebx
80100ecd:	78 31                	js     80100f00 <filewrite+0xbe>
        break;
      if(r != n1)
80100ecf:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100ed2:	75 1f                	jne    80100ef3 <filewrite+0xb1>
        panic("short filewrite");
      i += r;
80100ed4:	01 df                	add    %ebx,%edi
    while(i < n){
80100ed6:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100ed9:	7d 25                	jge    80100f00 <filewrite+0xbe>
      int n1 = n - i;
80100edb:	8b 45 10             	mov    0x10(%ebp),%eax
80100ede:	29 f8                	sub    %edi,%eax
80100ee0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100ee3:	3d 00 06 00 00       	cmp    $0x600,%eax
80100ee8:	7e 9e                	jle    80100e88 <filewrite+0x46>
        n1 = max;
80100eea:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100ef1:	eb 95                	jmp    80100e88 <filewrite+0x46>
        panic("short filewrite");
80100ef3:	83 ec 0c             	sub    $0xc,%esp
80100ef6:	68 af 68 10 80       	push   $0x801068af
80100efb:	e8 44 f4 ff ff       	call   80100344 <panic>
    }
    return i == n ? n : -1;
80100f00:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f03:	74 0d                	je     80100f12 <filewrite+0xd0>
80100f05:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f0a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f0d:	5b                   	pop    %ebx
80100f0e:	5e                   	pop    %esi
80100f0f:	5f                   	pop    %edi
80100f10:	5d                   	pop    %ebp
80100f11:	c3                   	ret    
    return i == n ? n : -1;
80100f12:	8b 45 10             	mov    0x10(%ebp),%eax
80100f15:	eb f3                	jmp    80100f0a <filewrite+0xc8>
  panic("filewrite");
80100f17:	83 ec 0c             	sub    $0xc,%esp
80100f1a:	68 b5 68 10 80       	push   $0x801068b5
80100f1f:	e8 20 f4 ff ff       	call   80100344 <panic>
    return -1;
80100f24:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f29:	eb df                	jmp    80100f0a <filewrite+0xc8>

80100f2b <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f2b:	55                   	push   %ebp
80100f2c:	89 e5                	mov    %esp,%ebp
80100f2e:	57                   	push   %edi
80100f2f:	56                   	push   %esi
80100f30:	53                   	push   %ebx
80100f31:	83 ec 0c             	sub    $0xc,%esp
80100f34:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f36:	eb 01                	jmp    80100f39 <skipelem+0xe>
    path++;
80100f38:	40                   	inc    %eax
  while(*path == '/')
80100f39:	8a 10                	mov    (%eax),%dl
80100f3b:	80 fa 2f             	cmp    $0x2f,%dl
80100f3e:	74 f8                	je     80100f38 <skipelem+0xd>
  if(*path == 0)
80100f40:	84 d2                	test   %dl,%dl
80100f42:	74 4e                	je     80100f92 <skipelem+0x67>
80100f44:	89 c3                	mov    %eax,%ebx
80100f46:	eb 01                	jmp    80100f49 <skipelem+0x1e>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80100f48:	43                   	inc    %ebx
  while(*path != '/' && *path != 0)
80100f49:	8a 13                	mov    (%ebx),%dl
80100f4b:	80 fa 2f             	cmp    $0x2f,%dl
80100f4e:	74 04                	je     80100f54 <skipelem+0x29>
80100f50:	84 d2                	test   %dl,%dl
80100f52:	75 f4                	jne    80100f48 <skipelem+0x1d>
  len = path - s;
80100f54:	89 df                	mov    %ebx,%edi
80100f56:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100f58:	83 ff 0d             	cmp    $0xd,%edi
80100f5b:	7e 11                	jle    80100f6e <skipelem+0x43>
    memmove(name, s, DIRSIZ);
80100f5d:	83 ec 04             	sub    $0x4,%esp
80100f60:	6a 0e                	push   $0xe
80100f62:	50                   	push   %eax
80100f63:	56                   	push   %esi
80100f64:	e8 a5 2e 00 00       	call   80103e0e <memmove>
80100f69:	83 c4 10             	add    $0x10,%esp
80100f6c:	eb 15                	jmp    80100f83 <skipelem+0x58>
  else {
    memmove(name, s, len);
80100f6e:	83 ec 04             	sub    $0x4,%esp
80100f71:	57                   	push   %edi
80100f72:	50                   	push   %eax
80100f73:	56                   	push   %esi
80100f74:	e8 95 2e 00 00       	call   80103e0e <memmove>
    name[len] = 0;
80100f79:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100f7d:	83 c4 10             	add    $0x10,%esp
80100f80:	eb 01                	jmp    80100f83 <skipelem+0x58>
  }
  while(*path == '/')
    path++;
80100f82:	43                   	inc    %ebx
  while(*path == '/')
80100f83:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100f86:	74 fa                	je     80100f82 <skipelem+0x57>
  return path;
}
80100f88:	89 d8                	mov    %ebx,%eax
80100f8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f8d:	5b                   	pop    %ebx
80100f8e:	5e                   	pop    %esi
80100f8f:	5f                   	pop    %edi
80100f90:	5d                   	pop    %ebp
80100f91:	c3                   	ret    
    return 0;
80100f92:	bb 00 00 00 00       	mov    $0x0,%ebx
80100f97:	eb ef                	jmp    80100f88 <skipelem+0x5d>

80100f99 <bzero>:
{
80100f99:	55                   	push   %ebp
80100f9a:	89 e5                	mov    %esp,%ebp
80100f9c:	53                   	push   %ebx
80100f9d:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80100fa0:	52                   	push   %edx
80100fa1:	50                   	push   %eax
80100fa2:	e8 c3 f1 ff ff       	call   8010016a <bread>
80100fa7:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80100fa9:	8d 40 5c             	lea    0x5c(%eax),%eax
80100fac:	83 c4 0c             	add    $0xc,%esp
80100faf:	68 00 02 00 00       	push   $0x200
80100fb4:	6a 00                	push   $0x0
80100fb6:	50                   	push   %eax
80100fb7:	e8 dc 2d 00 00       	call   80103d98 <memset>
  log_write(bp);
80100fbc:	89 1c 24             	mov    %ebx,(%esp)
80100fbf:	e8 80 18 00 00       	call   80102844 <log_write>
  brelse(bp);
80100fc4:	89 1c 24             	mov    %ebx,(%esp)
80100fc7:	e8 0b f2 ff ff       	call   801001d7 <brelse>
}
80100fcc:	83 c4 10             	add    $0x10,%esp
80100fcf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100fd2:	c9                   	leave  
80100fd3:	c3                   	ret    

80100fd4 <bfree>:
{
80100fd4:	55                   	push   %ebp
80100fd5:	89 e5                	mov    %esp,%ebp
80100fd7:	56                   	push   %esi
80100fd8:	53                   	push   %ebx
80100fd9:	89 c3                	mov    %eax,%ebx
80100fdb:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80100fdd:	89 d0                	mov    %edx,%eax
80100fdf:	c1 e8 0c             	shr    $0xc,%eax
80100fe2:	83 ec 08             	sub    $0x8,%esp
80100fe5:	03 05 cc 15 11 80    	add    0x801115cc,%eax
80100feb:	50                   	push   %eax
80100fec:	53                   	push   %ebx
80100fed:	e8 78 f1 ff ff       	call   8010016a <bread>
80100ff2:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
80100ff4:	89 f2                	mov    %esi,%edx
80100ff6:	81 e2 ff 0f 00 00    	and    $0xfff,%edx
  m = 1 << (bi % 8);
80100ffc:	89 f1                	mov    %esi,%ecx
80100ffe:	83 e1 07             	and    $0x7,%ecx
80101001:	b8 01 00 00 00       	mov    $0x1,%eax
80101006:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101008:	83 c4 10             	add    $0x10,%esp
8010100b:	c1 fa 03             	sar    $0x3,%edx
8010100e:	8a 4c 13 5c          	mov    0x5c(%ebx,%edx,1),%cl
80101012:	0f b6 f1             	movzbl %cl,%esi
80101015:	85 c6                	test   %eax,%esi
80101017:	74 23                	je     8010103c <bfree+0x68>
  bp->data[bi/8] &= ~m;
80101019:	f7 d0                	not    %eax
8010101b:	21 c8                	and    %ecx,%eax
8010101d:	88 44 13 5c          	mov    %al,0x5c(%ebx,%edx,1)
  log_write(bp);
80101021:	83 ec 0c             	sub    $0xc,%esp
80101024:	53                   	push   %ebx
80101025:	e8 1a 18 00 00       	call   80102844 <log_write>
  brelse(bp);
8010102a:	89 1c 24             	mov    %ebx,(%esp)
8010102d:	e8 a5 f1 ff ff       	call   801001d7 <brelse>
}
80101032:	83 c4 10             	add    $0x10,%esp
80101035:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101038:	5b                   	pop    %ebx
80101039:	5e                   	pop    %esi
8010103a:	5d                   	pop    %ebp
8010103b:	c3                   	ret    
    panic("freeing free block");
8010103c:	83 ec 0c             	sub    $0xc,%esp
8010103f:	68 bf 68 10 80       	push   $0x801068bf
80101044:	e8 fb f2 ff ff       	call   80100344 <panic>

80101049 <balloc>:
{
80101049:	55                   	push   %ebp
8010104a:	89 e5                	mov    %esp,%ebp
8010104c:	57                   	push   %edi
8010104d:	56                   	push   %esi
8010104e:	53                   	push   %ebx
8010104f:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
80101052:	be 00 00 00 00       	mov    $0x0,%esi
80101057:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010105a:	eb 5b                	jmp    801010b7 <balloc+0x6e>
    bp = bread(dev, BBLOCK(b, sb));
8010105c:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
80101062:	eb 61                	jmp    801010c5 <balloc+0x7c>
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101064:	c1 fa 03             	sar    $0x3,%edx
80101067:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010106a:	8a 4c 17 5c          	mov    0x5c(%edi,%edx,1),%cl
8010106e:	0f b6 f9             	movzbl %cl,%edi
80101071:	85 7d e4             	test   %edi,-0x1c(%ebp)
80101074:	74 7e                	je     801010f4 <balloc+0xab>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101076:	40                   	inc    %eax
80101077:	3d ff 0f 00 00       	cmp    $0xfff,%eax
8010107c:	7f 25                	jg     801010a3 <balloc+0x5a>
8010107e:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101081:	3b 1d b4 15 11 80    	cmp    0x801115b4,%ebx
80101087:	73 1a                	jae    801010a3 <balloc+0x5a>
      m = 1 << (bi % 8);
80101089:	89 c1                	mov    %eax,%ecx
8010108b:	83 e1 07             	and    $0x7,%ecx
8010108e:	ba 01 00 00 00       	mov    $0x1,%edx
80101093:	d3 e2                	shl    %cl,%edx
80101095:	89 55 e4             	mov    %edx,-0x1c(%ebp)
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101098:	89 c2                	mov    %eax,%edx
8010109a:	85 c0                	test   %eax,%eax
8010109c:	79 c6                	jns    80101064 <balloc+0x1b>
8010109e:	8d 50 07             	lea    0x7(%eax),%edx
801010a1:	eb c1                	jmp    80101064 <balloc+0x1b>
    brelse(bp);
801010a3:	83 ec 0c             	sub    $0xc,%esp
801010a6:	ff 75 e0             	pushl  -0x20(%ebp)
801010a9:	e8 29 f1 ff ff       	call   801001d7 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010ae:	81 c6 00 10 00 00    	add    $0x1000,%esi
801010b4:	83 c4 10             	add    $0x10,%esp
801010b7:	3b 35 b4 15 11 80    	cmp    0x801115b4,%esi
801010bd:	73 28                	jae    801010e7 <balloc+0x9e>
    bp = bread(dev, BBLOCK(b, sb));
801010bf:	89 f0                	mov    %esi,%eax
801010c1:	85 f6                	test   %esi,%esi
801010c3:	78 97                	js     8010105c <balloc+0x13>
801010c5:	c1 f8 0c             	sar    $0xc,%eax
801010c8:	83 ec 08             	sub    $0x8,%esp
801010cb:	03 05 cc 15 11 80    	add    0x801115cc,%eax
801010d1:	50                   	push   %eax
801010d2:	ff 75 dc             	pushl  -0x24(%ebp)
801010d5:	e8 90 f0 ff ff       	call   8010016a <bread>
801010da:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
801010dd:	83 c4 10             	add    $0x10,%esp
801010e0:	b8 00 00 00 00       	mov    $0x0,%eax
801010e5:	eb 90                	jmp    80101077 <balloc+0x2e>
  panic("balloc: out of blocks");
801010e7:	83 ec 0c             	sub    $0xc,%esp
801010ea:	68 d2 68 10 80       	push   $0x801068d2
801010ef:	e8 50 f2 ff ff       	call   80100344 <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
801010f4:	8b 7d dc             	mov    -0x24(%ebp),%edi
801010f7:	0b 4d e4             	or     -0x1c(%ebp),%ecx
801010fa:	8b 75 e0             	mov    -0x20(%ebp),%esi
801010fd:	88 4c 16 5c          	mov    %cl,0x5c(%esi,%edx,1)
        log_write(bp);
80101101:	83 ec 0c             	sub    $0xc,%esp
80101104:	56                   	push   %esi
80101105:	e8 3a 17 00 00       	call   80102844 <log_write>
        brelse(bp);
8010110a:	89 34 24             	mov    %esi,(%esp)
8010110d:	e8 c5 f0 ff ff       	call   801001d7 <brelse>
        bzero(dev, b + bi);
80101112:	89 da                	mov    %ebx,%edx
80101114:	89 f8                	mov    %edi,%eax
80101116:	e8 7e fe ff ff       	call   80100f99 <bzero>
}
8010111b:	89 d8                	mov    %ebx,%eax
8010111d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101120:	5b                   	pop    %ebx
80101121:	5e                   	pop    %esi
80101122:	5f                   	pop    %edi
80101123:	5d                   	pop    %ebp
80101124:	c3                   	ret    

80101125 <bmap>:
{
80101125:	55                   	push   %ebp
80101126:	89 e5                	mov    %esp,%ebp
80101128:	57                   	push   %edi
80101129:	56                   	push   %esi
8010112a:	53                   	push   %ebx
8010112b:	83 ec 1c             	sub    $0x1c,%esp
8010112e:	89 c3                	mov    %eax,%ebx
80101130:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
80101132:	83 fa 0b             	cmp    $0xb,%edx
80101135:	76 45                	jbe    8010117c <bmap+0x57>
  bn -= NDIRECT;
80101137:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
8010113a:	83 fe 7f             	cmp    $0x7f,%esi
8010113d:	77 7f                	ja     801011be <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
8010113f:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101145:	85 c0                	test   %eax,%eax
80101147:	74 4a                	je     80101193 <bmap+0x6e>
    bp = bread(ip->dev, addr);
80101149:	83 ec 08             	sub    $0x8,%esp
8010114c:	50                   	push   %eax
8010114d:	ff 33                	pushl  (%ebx)
8010114f:	e8 16 f0 ff ff       	call   8010016a <bread>
80101154:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
80101156:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
8010115a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010115d:	8b 30                	mov    (%eax),%esi
8010115f:	83 c4 10             	add    $0x10,%esp
80101162:	85 f6                	test   %esi,%esi
80101164:	74 3c                	je     801011a2 <bmap+0x7d>
    brelse(bp);
80101166:	83 ec 0c             	sub    $0xc,%esp
80101169:	57                   	push   %edi
8010116a:	e8 68 f0 ff ff       	call   801001d7 <brelse>
    return addr;
8010116f:	83 c4 10             	add    $0x10,%esp
}
80101172:	89 f0                	mov    %esi,%eax
80101174:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101177:	5b                   	pop    %ebx
80101178:	5e                   	pop    %esi
80101179:	5f                   	pop    %edi
8010117a:	5d                   	pop    %ebp
8010117b:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
8010117c:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
80101180:	85 f6                	test   %esi,%esi
80101182:	75 ee                	jne    80101172 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
80101184:	8b 00                	mov    (%eax),%eax
80101186:	e8 be fe ff ff       	call   80101049 <balloc>
8010118b:	89 c6                	mov    %eax,%esi
8010118d:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
80101191:	eb df                	jmp    80101172 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101193:	8b 03                	mov    (%ebx),%eax
80101195:	e8 af fe ff ff       	call   80101049 <balloc>
8010119a:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
801011a0:	eb a7                	jmp    80101149 <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
801011a2:	8b 03                	mov    (%ebx),%eax
801011a4:	e8 a0 fe ff ff       	call   80101049 <balloc>
801011a9:	89 c6                	mov    %eax,%esi
801011ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011ae:	89 30                	mov    %esi,(%eax)
      log_write(bp);
801011b0:	83 ec 0c             	sub    $0xc,%esp
801011b3:	57                   	push   %edi
801011b4:	e8 8b 16 00 00       	call   80102844 <log_write>
801011b9:	83 c4 10             	add    $0x10,%esp
801011bc:	eb a8                	jmp    80101166 <bmap+0x41>
  panic("bmap: out of range");
801011be:	83 ec 0c             	sub    $0xc,%esp
801011c1:	68 e8 68 10 80       	push   $0x801068e8
801011c6:	e8 79 f1 ff ff       	call   80100344 <panic>

801011cb <iget>:
{
801011cb:	55                   	push   %ebp
801011cc:	89 e5                	mov    %esp,%ebp
801011ce:	57                   	push   %edi
801011cf:	56                   	push   %esi
801011d0:	53                   	push   %ebx
801011d1:	83 ec 28             	sub    $0x28,%esp
801011d4:	89 c7                	mov    %eax,%edi
801011d6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801011d9:	68 60 f9 10 80       	push   $0x8010f960
801011de:	e8 09 2b 00 00       	call   80103cec <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011e3:	83 c4 10             	add    $0x10,%esp
  empty = 0;
801011e6:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011eb:	bb 94 f9 10 80       	mov    $0x8010f994,%ebx
801011f0:	eb 0a                	jmp    801011fc <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801011f2:	85 f6                	test   %esi,%esi
801011f4:	74 39                	je     8010122f <iget+0x64>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801011f6:	81 c3 90 00 00 00    	add    $0x90,%ebx
801011fc:	81 fb b4 15 11 80    	cmp    $0x801115b4,%ebx
80101202:	73 33                	jae    80101237 <iget+0x6c>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101204:	8b 43 08             	mov    0x8(%ebx),%eax
80101207:	85 c0                	test   %eax,%eax
80101209:	7e e7                	jle    801011f2 <iget+0x27>
8010120b:	39 3b                	cmp    %edi,(%ebx)
8010120d:	75 e3                	jne    801011f2 <iget+0x27>
8010120f:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101212:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101215:	75 db                	jne    801011f2 <iget+0x27>
      ip->ref++;
80101217:	40                   	inc    %eax
80101218:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
8010121b:	83 ec 0c             	sub    $0xc,%esp
8010121e:	68 60 f9 10 80       	push   $0x8010f960
80101223:	e8 29 2b 00 00       	call   80103d51 <release>
      return ip;
80101228:	83 c4 10             	add    $0x10,%esp
8010122b:	89 de                	mov    %ebx,%esi
8010122d:	eb 32                	jmp    80101261 <iget+0x96>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
8010122f:	85 c0                	test   %eax,%eax
80101231:	75 c3                	jne    801011f6 <iget+0x2b>
      empty = ip;
80101233:	89 de                	mov    %ebx,%esi
80101235:	eb bf                	jmp    801011f6 <iget+0x2b>
  if(empty == 0)
80101237:	85 f6                	test   %esi,%esi
80101239:	74 30                	je     8010126b <iget+0xa0>
  ip->dev = dev;
8010123b:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
8010123d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101240:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
80101243:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010124a:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101251:	83 ec 0c             	sub    $0xc,%esp
80101254:	68 60 f9 10 80       	push   $0x8010f960
80101259:	e8 f3 2a 00 00       	call   80103d51 <release>
  return ip;
8010125e:	83 c4 10             	add    $0x10,%esp
}
80101261:	89 f0                	mov    %esi,%eax
80101263:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101266:	5b                   	pop    %ebx
80101267:	5e                   	pop    %esi
80101268:	5f                   	pop    %edi
80101269:	5d                   	pop    %ebp
8010126a:	c3                   	ret    
    panic("iget: no inodes");
8010126b:	83 ec 0c             	sub    $0xc,%esp
8010126e:	68 fb 68 10 80       	push   $0x801068fb
80101273:	e8 cc f0 ff ff       	call   80100344 <panic>

80101278 <readsb>:
{
80101278:	55                   	push   %ebp
80101279:	89 e5                	mov    %esp,%ebp
8010127b:	53                   	push   %ebx
8010127c:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
8010127f:	6a 01                	push   $0x1
80101281:	ff 75 08             	pushl  0x8(%ebp)
80101284:	e8 e1 ee ff ff       	call   8010016a <bread>
80101289:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
8010128b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010128e:	83 c4 0c             	add    $0xc,%esp
80101291:	6a 1c                	push   $0x1c
80101293:	50                   	push   %eax
80101294:	ff 75 0c             	pushl  0xc(%ebp)
80101297:	e8 72 2b 00 00       	call   80103e0e <memmove>
  brelse(bp);
8010129c:	89 1c 24             	mov    %ebx,(%esp)
8010129f:	e8 33 ef ff ff       	call   801001d7 <brelse>
}
801012a4:	83 c4 10             	add    $0x10,%esp
801012a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801012aa:	c9                   	leave  
801012ab:	c3                   	ret    

801012ac <iinit>:
{
801012ac:	55                   	push   %ebp
801012ad:	89 e5                	mov    %esp,%ebp
801012af:	53                   	push   %ebx
801012b0:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801012b3:	68 0b 69 10 80       	push   $0x8010690b
801012b8:	68 60 f9 10 80       	push   $0x8010f960
801012bd:	e8 ea 28 00 00       	call   80103bac <initlock>
  for(i = 0; i < NINODE; i++) {
801012c2:	83 c4 10             	add    $0x10,%esp
801012c5:	bb 00 00 00 00       	mov    $0x0,%ebx
801012ca:	eb 1f                	jmp    801012eb <iinit+0x3f>
    initsleeplock(&icache.inode[i].lock, "inode");
801012cc:	83 ec 08             	sub    $0x8,%esp
801012cf:	68 12 69 10 80       	push   $0x80106912
801012d4:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
801012d7:	89 d0                	mov    %edx,%eax
801012d9:	c1 e0 04             	shl    $0x4,%eax
801012dc:	05 a0 f9 10 80       	add    $0x8010f9a0,%eax
801012e1:	50                   	push   %eax
801012e2:	e8 ba 27 00 00       	call   80103aa1 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
801012e7:	43                   	inc    %ebx
801012e8:	83 c4 10             	add    $0x10,%esp
801012eb:	83 fb 31             	cmp    $0x31,%ebx
801012ee:	7e dc                	jle    801012cc <iinit+0x20>
  readsb(dev, &sb);
801012f0:	83 ec 08             	sub    $0x8,%esp
801012f3:	68 b4 15 11 80       	push   $0x801115b4
801012f8:	ff 75 08             	pushl  0x8(%ebp)
801012fb:	e8 78 ff ff ff       	call   80101278 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101300:	ff 35 cc 15 11 80    	pushl  0x801115cc
80101306:	ff 35 c8 15 11 80    	pushl  0x801115c8
8010130c:	ff 35 c4 15 11 80    	pushl  0x801115c4
80101312:	ff 35 c0 15 11 80    	pushl  0x801115c0
80101318:	ff 35 bc 15 11 80    	pushl  0x801115bc
8010131e:	ff 35 b8 15 11 80    	pushl  0x801115b8
80101324:	ff 35 b4 15 11 80    	pushl  0x801115b4
8010132a:	68 78 69 10 80       	push   $0x80106978
8010132f:	e8 ab f2 ff ff       	call   801005df <cprintf>
}
80101334:	83 c4 30             	add    $0x30,%esp
80101337:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010133a:	c9                   	leave  
8010133b:	c3                   	ret    

8010133c <ialloc>:
{
8010133c:	55                   	push   %ebp
8010133d:	89 e5                	mov    %esp,%ebp
8010133f:	57                   	push   %edi
80101340:	56                   	push   %esi
80101341:	53                   	push   %ebx
80101342:	83 ec 1c             	sub    $0x1c,%esp
80101345:	8b 45 0c             	mov    0xc(%ebp),%eax
80101348:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
8010134b:	bb 01 00 00 00       	mov    $0x1,%ebx
80101350:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
80101353:	3b 1d bc 15 11 80    	cmp    0x801115bc,%ebx
80101359:	73 3d                	jae    80101398 <ialloc+0x5c>
    bp = bread(dev, IBLOCK(inum, sb));
8010135b:	89 d8                	mov    %ebx,%eax
8010135d:	c1 e8 03             	shr    $0x3,%eax
80101360:	03 05 c8 15 11 80    	add    0x801115c8,%eax
80101366:	83 ec 08             	sub    $0x8,%esp
80101369:	50                   	push   %eax
8010136a:	ff 75 08             	pushl  0x8(%ebp)
8010136d:	e8 f8 ed ff ff       	call   8010016a <bread>
80101372:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
80101374:	89 d8                	mov    %ebx,%eax
80101376:	83 e0 07             	and    $0x7,%eax
80101379:	c1 e0 06             	shl    $0x6,%eax
8010137c:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101380:	83 c4 10             	add    $0x10,%esp
80101383:	66 83 3f 00          	cmpw   $0x0,(%edi)
80101387:	74 1c                	je     801013a5 <ialloc+0x69>
    brelse(bp);
80101389:	83 ec 0c             	sub    $0xc,%esp
8010138c:	56                   	push   %esi
8010138d:	e8 45 ee ff ff       	call   801001d7 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101392:	43                   	inc    %ebx
80101393:	83 c4 10             	add    $0x10,%esp
80101396:	eb b8                	jmp    80101350 <ialloc+0x14>
  panic("ialloc: no inodes");
80101398:	83 ec 0c             	sub    $0xc,%esp
8010139b:	68 18 69 10 80       	push   $0x80106918
801013a0:	e8 9f ef ff ff       	call   80100344 <panic>
      memset(dip, 0, sizeof(*dip));
801013a5:	83 ec 04             	sub    $0x4,%esp
801013a8:	6a 40                	push   $0x40
801013aa:	6a 00                	push   $0x0
801013ac:	57                   	push   %edi
801013ad:	e8 e6 29 00 00       	call   80103d98 <memset>
      dip->type = type;
801013b2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801013b5:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
801013b8:	89 34 24             	mov    %esi,(%esp)
801013bb:	e8 84 14 00 00       	call   80102844 <log_write>
      brelse(bp);
801013c0:	89 34 24             	mov    %esi,(%esp)
801013c3:	e8 0f ee ff ff       	call   801001d7 <brelse>
      return iget(dev, inum);
801013c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801013cb:	8b 45 08             	mov    0x8(%ebp),%eax
801013ce:	e8 f8 fd ff ff       	call   801011cb <iget>
}
801013d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013d6:	5b                   	pop    %ebx
801013d7:	5e                   	pop    %esi
801013d8:	5f                   	pop    %edi
801013d9:	5d                   	pop    %ebp
801013da:	c3                   	ret    

801013db <iupdate>:
{
801013db:	55                   	push   %ebp
801013dc:	89 e5                	mov    %esp,%ebp
801013de:	56                   	push   %esi
801013df:	53                   	push   %ebx
801013e0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801013e3:	8b 43 04             	mov    0x4(%ebx),%eax
801013e6:	c1 e8 03             	shr    $0x3,%eax
801013e9:	03 05 c8 15 11 80    	add    0x801115c8,%eax
801013ef:	83 ec 08             	sub    $0x8,%esp
801013f2:	50                   	push   %eax
801013f3:	ff 33                	pushl  (%ebx)
801013f5:	e8 70 ed ff ff       	call   8010016a <bread>
801013fa:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801013fc:	8b 43 04             	mov    0x4(%ebx),%eax
801013ff:	83 e0 07             	and    $0x7,%eax
80101402:	c1 e0 06             	shl    $0x6,%eax
80101405:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101409:	8b 53 50             	mov    0x50(%ebx),%edx
8010140c:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010140f:	66 8b 53 52          	mov    0x52(%ebx),%dx
80101413:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
80101417:	8b 53 54             	mov    0x54(%ebx),%edx
8010141a:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
8010141e:	66 8b 53 56          	mov    0x56(%ebx),%dx
80101422:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
80101426:	8b 53 58             	mov    0x58(%ebx),%edx
80101429:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010142c:	83 c3 5c             	add    $0x5c,%ebx
8010142f:	83 c0 0c             	add    $0xc,%eax
80101432:	83 c4 0c             	add    $0xc,%esp
80101435:	6a 34                	push   $0x34
80101437:	53                   	push   %ebx
80101438:	50                   	push   %eax
80101439:	e8 d0 29 00 00       	call   80103e0e <memmove>
  log_write(bp);
8010143e:	89 34 24             	mov    %esi,(%esp)
80101441:	e8 fe 13 00 00       	call   80102844 <log_write>
  brelse(bp);
80101446:	89 34 24             	mov    %esi,(%esp)
80101449:	e8 89 ed ff ff       	call   801001d7 <brelse>
}
8010144e:	83 c4 10             	add    $0x10,%esp
80101451:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101454:	5b                   	pop    %ebx
80101455:	5e                   	pop    %esi
80101456:	5d                   	pop    %ebp
80101457:	c3                   	ret    

80101458 <itrunc>:
{
80101458:	55                   	push   %ebp
80101459:	89 e5                	mov    %esp,%ebp
8010145b:	57                   	push   %edi
8010145c:	56                   	push   %esi
8010145d:	53                   	push   %ebx
8010145e:	83 ec 1c             	sub    $0x1c,%esp
80101461:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
80101463:	bb 00 00 00 00       	mov    $0x0,%ebx
80101468:	eb 01                	jmp    8010146b <itrunc+0x13>
8010146a:	43                   	inc    %ebx
8010146b:	83 fb 0b             	cmp    $0xb,%ebx
8010146e:	7f 19                	jg     80101489 <itrunc+0x31>
    if(ip->addrs[i]){
80101470:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101474:	85 d2                	test   %edx,%edx
80101476:	74 f2                	je     8010146a <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
80101478:	8b 06                	mov    (%esi),%eax
8010147a:	e8 55 fb ff ff       	call   80100fd4 <bfree>
      ip->addrs[i] = 0;
8010147f:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101486:	00 
80101487:	eb e1                	jmp    8010146a <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101489:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010148f:	85 c0                	test   %eax,%eax
80101491:	75 1b                	jne    801014ae <itrunc+0x56>
  ip->size = 0;
80101493:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
8010149a:	83 ec 0c             	sub    $0xc,%esp
8010149d:	56                   	push   %esi
8010149e:	e8 38 ff ff ff       	call   801013db <iupdate>
}
801014a3:	83 c4 10             	add    $0x10,%esp
801014a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a9:	5b                   	pop    %ebx
801014aa:	5e                   	pop    %esi
801014ab:	5f                   	pop    %edi
801014ac:	5d                   	pop    %ebp
801014ad:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801014ae:	83 ec 08             	sub    $0x8,%esp
801014b1:	50                   	push   %eax
801014b2:	ff 36                	pushl  (%esi)
801014b4:	e8 b1 ec ff ff       	call   8010016a <bread>
801014b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801014bc:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
801014bf:	83 c4 10             	add    $0x10,%esp
801014c2:	bb 00 00 00 00       	mov    $0x0,%ebx
801014c7:	eb 01                	jmp    801014ca <itrunc+0x72>
801014c9:	43                   	inc    %ebx
801014ca:	83 fb 7f             	cmp    $0x7f,%ebx
801014cd:	77 10                	ja     801014df <itrunc+0x87>
      if(a[j])
801014cf:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
801014d2:	85 d2                	test   %edx,%edx
801014d4:	74 f3                	je     801014c9 <itrunc+0x71>
        bfree(ip->dev, a[j]);
801014d6:	8b 06                	mov    (%esi),%eax
801014d8:	e8 f7 fa ff ff       	call   80100fd4 <bfree>
801014dd:	eb ea                	jmp    801014c9 <itrunc+0x71>
    brelse(bp);
801014df:	83 ec 0c             	sub    $0xc,%esp
801014e2:	ff 75 e4             	pushl  -0x1c(%ebp)
801014e5:	e8 ed ec ff ff       	call   801001d7 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801014ea:	8b 06                	mov    (%esi),%eax
801014ec:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801014f2:	e8 dd fa ff ff       	call   80100fd4 <bfree>
    ip->addrs[NDIRECT] = 0;
801014f7:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801014fe:	00 00 00 
80101501:	83 c4 10             	add    $0x10,%esp
80101504:	eb 8d                	jmp    80101493 <itrunc+0x3b>

80101506 <idup>:
{
80101506:	55                   	push   %ebp
80101507:	89 e5                	mov    %esp,%ebp
80101509:	53                   	push   %ebx
8010150a:	83 ec 10             	sub    $0x10,%esp
8010150d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
80101510:	68 60 f9 10 80       	push   $0x8010f960
80101515:	e8 d2 27 00 00       	call   80103cec <acquire>
  ip->ref++;
8010151a:	8b 43 08             	mov    0x8(%ebx),%eax
8010151d:	40                   	inc    %eax
8010151e:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101521:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101528:	e8 24 28 00 00       	call   80103d51 <release>
}
8010152d:	89 d8                	mov    %ebx,%eax
8010152f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101532:	c9                   	leave  
80101533:	c3                   	ret    

80101534 <ilock>:
{
80101534:	55                   	push   %ebp
80101535:	89 e5                	mov    %esp,%ebp
80101537:	56                   	push   %esi
80101538:	53                   	push   %ebx
80101539:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
8010153c:	85 db                	test   %ebx,%ebx
8010153e:	74 22                	je     80101562 <ilock+0x2e>
80101540:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101544:	7e 1c                	jle    80101562 <ilock+0x2e>
  acquiresleep(&ip->lock);
80101546:	83 ec 0c             	sub    $0xc,%esp
80101549:	8d 43 0c             	lea    0xc(%ebx),%eax
8010154c:	50                   	push   %eax
8010154d:	e8 82 25 00 00       	call   80103ad4 <acquiresleep>
  if(ip->valid == 0){
80101552:	83 c4 10             	add    $0x10,%esp
80101555:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101559:	74 14                	je     8010156f <ilock+0x3b>
}
8010155b:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010155e:	5b                   	pop    %ebx
8010155f:	5e                   	pop    %esi
80101560:	5d                   	pop    %ebp
80101561:	c3                   	ret    
    panic("ilock");
80101562:	83 ec 0c             	sub    $0xc,%esp
80101565:	68 2a 69 10 80       	push   $0x8010692a
8010156a:	e8 d5 ed ff ff       	call   80100344 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010156f:	8b 43 04             	mov    0x4(%ebx),%eax
80101572:	c1 e8 03             	shr    $0x3,%eax
80101575:	03 05 c8 15 11 80    	add    0x801115c8,%eax
8010157b:	83 ec 08             	sub    $0x8,%esp
8010157e:	50                   	push   %eax
8010157f:	ff 33                	pushl  (%ebx)
80101581:	e8 e4 eb ff ff       	call   8010016a <bread>
80101586:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101588:	8b 43 04             	mov    0x4(%ebx),%eax
8010158b:	83 e0 07             	and    $0x7,%eax
8010158e:	c1 e0 06             	shl    $0x6,%eax
80101591:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101595:	8b 10                	mov    (%eax),%edx
80101597:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
8010159b:	66 8b 50 02          	mov    0x2(%eax),%dx
8010159f:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801015a3:	8b 50 04             	mov    0x4(%eax),%edx
801015a6:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801015aa:	66 8b 50 06          	mov    0x6(%eax),%dx
801015ae:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801015b2:	8b 50 08             	mov    0x8(%eax),%edx
801015b5:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801015b8:	83 c0 0c             	add    $0xc,%eax
801015bb:	8d 53 5c             	lea    0x5c(%ebx),%edx
801015be:	83 c4 0c             	add    $0xc,%esp
801015c1:	6a 34                	push   $0x34
801015c3:	50                   	push   %eax
801015c4:	52                   	push   %edx
801015c5:	e8 44 28 00 00       	call   80103e0e <memmove>
    brelse(bp);
801015ca:	89 34 24             	mov    %esi,(%esp)
801015cd:	e8 05 ec ff ff       	call   801001d7 <brelse>
    ip->valid = 1;
801015d2:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801015d9:	83 c4 10             	add    $0x10,%esp
801015dc:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
801015e1:	0f 85 74 ff ff ff    	jne    8010155b <ilock+0x27>
      panic("ilock: no type");
801015e7:	83 ec 0c             	sub    $0xc,%esp
801015ea:	68 30 69 10 80       	push   $0x80106930
801015ef:	e8 50 ed ff ff       	call   80100344 <panic>

801015f4 <iunlock>:
{
801015f4:	55                   	push   %ebp
801015f5:	89 e5                	mov    %esp,%ebp
801015f7:	56                   	push   %esi
801015f8:	53                   	push   %ebx
801015f9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801015fc:	85 db                	test   %ebx,%ebx
801015fe:	74 2c                	je     8010162c <iunlock+0x38>
80101600:	8d 73 0c             	lea    0xc(%ebx),%esi
80101603:	83 ec 0c             	sub    $0xc,%esp
80101606:	56                   	push   %esi
80101607:	e8 52 25 00 00       	call   80103b5e <holdingsleep>
8010160c:	83 c4 10             	add    $0x10,%esp
8010160f:	85 c0                	test   %eax,%eax
80101611:	74 19                	je     8010162c <iunlock+0x38>
80101613:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
80101617:	7e 13                	jle    8010162c <iunlock+0x38>
  releasesleep(&ip->lock);
80101619:	83 ec 0c             	sub    $0xc,%esp
8010161c:	56                   	push   %esi
8010161d:	e8 01 25 00 00       	call   80103b23 <releasesleep>
}
80101622:	83 c4 10             	add    $0x10,%esp
80101625:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101628:	5b                   	pop    %ebx
80101629:	5e                   	pop    %esi
8010162a:	5d                   	pop    %ebp
8010162b:	c3                   	ret    
    panic("iunlock");
8010162c:	83 ec 0c             	sub    $0xc,%esp
8010162f:	68 3f 69 10 80       	push   $0x8010693f
80101634:	e8 0b ed ff ff       	call   80100344 <panic>

80101639 <iput>:
{
80101639:	55                   	push   %ebp
8010163a:	89 e5                	mov    %esp,%ebp
8010163c:	57                   	push   %edi
8010163d:	56                   	push   %esi
8010163e:	53                   	push   %ebx
8010163f:	83 ec 18             	sub    $0x18,%esp
80101642:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
80101645:	8d 73 0c             	lea    0xc(%ebx),%esi
80101648:	56                   	push   %esi
80101649:	e8 86 24 00 00       	call   80103ad4 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
8010164e:	83 c4 10             	add    $0x10,%esp
80101651:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
80101655:	74 07                	je     8010165e <iput+0x25>
80101657:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010165c:	74 33                	je     80101691 <iput+0x58>
  releasesleep(&ip->lock);
8010165e:	83 ec 0c             	sub    $0xc,%esp
80101661:	56                   	push   %esi
80101662:	e8 bc 24 00 00       	call   80103b23 <releasesleep>
  acquire(&icache.lock);
80101667:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
8010166e:	e8 79 26 00 00       	call   80103cec <acquire>
  ip->ref--;
80101673:	8b 43 08             	mov    0x8(%ebx),%eax
80101676:	48                   	dec    %eax
80101677:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
8010167a:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
80101681:	e8 cb 26 00 00       	call   80103d51 <release>
}
80101686:	83 c4 10             	add    $0x10,%esp
80101689:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010168c:	5b                   	pop    %ebx
8010168d:	5e                   	pop    %esi
8010168e:	5f                   	pop    %edi
8010168f:	5d                   	pop    %ebp
80101690:	c3                   	ret    
    acquire(&icache.lock);
80101691:	83 ec 0c             	sub    $0xc,%esp
80101694:	68 60 f9 10 80       	push   $0x8010f960
80101699:	e8 4e 26 00 00       	call   80103cec <acquire>
    int r = ip->ref;
8010169e:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
801016a1:	c7 04 24 60 f9 10 80 	movl   $0x8010f960,(%esp)
801016a8:	e8 a4 26 00 00       	call   80103d51 <release>
    if(r == 1){
801016ad:	83 c4 10             	add    $0x10,%esp
801016b0:	83 ff 01             	cmp    $0x1,%edi
801016b3:	75 a9                	jne    8010165e <iput+0x25>
      itrunc(ip);
801016b5:	89 d8                	mov    %ebx,%eax
801016b7:	e8 9c fd ff ff       	call   80101458 <itrunc>
      ip->type = 0;
801016bc:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
801016c2:	83 ec 0c             	sub    $0xc,%esp
801016c5:	53                   	push   %ebx
801016c6:	e8 10 fd ff ff       	call   801013db <iupdate>
      ip->valid = 0;
801016cb:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
801016d2:	83 c4 10             	add    $0x10,%esp
801016d5:	eb 87                	jmp    8010165e <iput+0x25>

801016d7 <iunlockput>:
{
801016d7:	55                   	push   %ebp
801016d8:	89 e5                	mov    %esp,%ebp
801016da:	53                   	push   %ebx
801016db:	83 ec 10             	sub    $0x10,%esp
801016de:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
801016e1:	53                   	push   %ebx
801016e2:	e8 0d ff ff ff       	call   801015f4 <iunlock>
  iput(ip);
801016e7:	89 1c 24             	mov    %ebx,(%esp)
801016ea:	e8 4a ff ff ff       	call   80101639 <iput>
}
801016ef:	83 c4 10             	add    $0x10,%esp
801016f2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801016f5:	c9                   	leave  
801016f6:	c3                   	ret    

801016f7 <stati>:
{
801016f7:	55                   	push   %ebp
801016f8:	89 e5                	mov    %esp,%ebp
801016fa:	8b 55 08             	mov    0x8(%ebp),%edx
801016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101700:	8b 0a                	mov    (%edx),%ecx
80101702:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101705:	8b 4a 04             	mov    0x4(%edx),%ecx
80101708:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
8010170b:	8b 4a 50             	mov    0x50(%edx),%ecx
8010170e:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101711:	66 8b 4a 56          	mov    0x56(%edx),%cx
80101715:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101719:	8b 52 58             	mov    0x58(%edx),%edx
8010171c:	89 50 10             	mov    %edx,0x10(%eax)
}
8010171f:	5d                   	pop    %ebp
80101720:	c3                   	ret    

80101721 <readi>:
{
80101721:	55                   	push   %ebp
80101722:	89 e5                	mov    %esp,%ebp
80101724:	57                   	push   %edi
80101725:	56                   	push   %esi
80101726:	53                   	push   %ebx
80101727:	83 ec 0c             	sub    $0xc,%esp
8010172a:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
8010172d:	8b 45 08             	mov    0x8(%ebp),%eax
80101730:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101735:	74 2c                	je     80101763 <readi+0x42>
  if(off > ip->size || off + n < off)
80101737:	8b 45 08             	mov    0x8(%ebp),%eax
8010173a:	8b 40 58             	mov    0x58(%eax),%eax
8010173d:	39 f8                	cmp    %edi,%eax
8010173f:	0f 82 d1 00 00 00    	jb     80101816 <readi+0xf5>
80101745:	89 fa                	mov    %edi,%edx
80101747:	03 55 14             	add    0x14(%ebp),%edx
8010174a:	0f 82 cd 00 00 00    	jb     8010181d <readi+0xfc>
  if(off + n > ip->size)
80101750:	39 d0                	cmp    %edx,%eax
80101752:	73 05                	jae    80101759 <readi+0x38>
    n = ip->size - off;
80101754:	29 f8                	sub    %edi,%eax
80101756:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101759:	be 00 00 00 00       	mov    $0x0,%esi
8010175e:	89 7d 10             	mov    %edi,0x10(%ebp)
80101761:	eb 55                	jmp    801017b8 <readi+0x97>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101763:	66 8b 40 52          	mov    0x52(%eax),%ax
80101767:	66 83 f8 09          	cmp    $0x9,%ax
8010176b:	0f 87 97 00 00 00    	ja     80101808 <readi+0xe7>
80101771:	98                   	cwtl   
80101772:	8b 04 c5 00 f9 10 80 	mov    -0x7fef0700(,%eax,8),%eax
80101779:	85 c0                	test   %eax,%eax
8010177b:	0f 84 8e 00 00 00    	je     8010180f <readi+0xee>
    return devsw[ip->major].read(ip, dst, n);
80101781:	83 ec 04             	sub    $0x4,%esp
80101784:	ff 75 14             	pushl  0x14(%ebp)
80101787:	ff 75 0c             	pushl  0xc(%ebp)
8010178a:	ff 75 08             	pushl  0x8(%ebp)
8010178d:	ff d0                	call   *%eax
8010178f:	83 c4 10             	add    $0x10,%esp
80101792:	eb 6c                	jmp    80101800 <readi+0xdf>
    memmove(dst, bp->data + off%BSIZE, m);
80101794:	83 ec 04             	sub    $0x4,%esp
80101797:	53                   	push   %ebx
80101798:	8d 44 17 5c          	lea    0x5c(%edi,%edx,1),%eax
8010179c:	50                   	push   %eax
8010179d:	ff 75 0c             	pushl  0xc(%ebp)
801017a0:	e8 69 26 00 00       	call   80103e0e <memmove>
    brelse(bp);
801017a5:	89 3c 24             	mov    %edi,(%esp)
801017a8:	e8 2a ea ff ff       	call   801001d7 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801017ad:	01 de                	add    %ebx,%esi
801017af:	01 5d 10             	add    %ebx,0x10(%ebp)
801017b2:	01 5d 0c             	add    %ebx,0xc(%ebp)
801017b5:	83 c4 10             	add    $0x10,%esp
801017b8:	3b 75 14             	cmp    0x14(%ebp),%esi
801017bb:	73 40                	jae    801017fd <readi+0xdc>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801017bd:	8b 55 10             	mov    0x10(%ebp),%edx
801017c0:	c1 ea 09             	shr    $0x9,%edx
801017c3:	8b 45 08             	mov    0x8(%ebp),%eax
801017c6:	e8 5a f9 ff ff       	call   80101125 <bmap>
801017cb:	83 ec 08             	sub    $0x8,%esp
801017ce:	50                   	push   %eax
801017cf:	8b 45 08             	mov    0x8(%ebp),%eax
801017d2:	ff 30                	pushl  (%eax)
801017d4:	e8 91 e9 ff ff       	call   8010016a <bread>
801017d9:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
801017db:	8b 55 10             	mov    0x10(%ebp),%edx
801017de:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801017e4:	b8 00 02 00 00       	mov    $0x200,%eax
801017e9:	29 d0                	sub    %edx,%eax
801017eb:	8b 4d 14             	mov    0x14(%ebp),%ecx
801017ee:	29 f1                	sub    %esi,%ecx
801017f0:	89 c3                	mov    %eax,%ebx
801017f2:	83 c4 10             	add    $0x10,%esp
801017f5:	39 c1                	cmp    %eax,%ecx
801017f7:	73 9b                	jae    80101794 <readi+0x73>
801017f9:	89 cb                	mov    %ecx,%ebx
801017fb:	eb 97                	jmp    80101794 <readi+0x73>
  return n;
801017fd:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101800:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101803:	5b                   	pop    %ebx
80101804:	5e                   	pop    %esi
80101805:	5f                   	pop    %edi
80101806:	5d                   	pop    %ebp
80101807:	c3                   	ret    
      return -1;
80101808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010180d:	eb f1                	jmp    80101800 <readi+0xdf>
8010180f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101814:	eb ea                	jmp    80101800 <readi+0xdf>
    return -1;
80101816:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010181b:	eb e3                	jmp    80101800 <readi+0xdf>
8010181d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101822:	eb dc                	jmp    80101800 <readi+0xdf>

80101824 <writei>:
{
80101824:	55                   	push   %ebp
80101825:	89 e5                	mov    %esp,%ebp
80101827:	57                   	push   %edi
80101828:	56                   	push   %esi
80101829:	53                   	push   %ebx
8010182a:	83 ec 0c             	sub    $0xc,%esp
8010182d:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(ip->type == T_DEV){
80101830:	8b 45 08             	mov    0x8(%ebp),%eax
80101833:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
80101838:	74 2e                	je     80101868 <writei+0x44>
  if(off > ip->size || off + n < off)
8010183a:	8b 45 08             	mov    0x8(%ebp),%eax
8010183d:	39 78 58             	cmp    %edi,0x58(%eax)
80101840:	0f 82 02 01 00 00    	jb     80101948 <writei+0x124>
80101846:	89 f8                	mov    %edi,%eax
80101848:	03 45 14             	add    0x14(%ebp),%eax
8010184b:	0f 82 fe 00 00 00    	jb     8010194f <writei+0x12b>
  if(off + n > MAXFILE*BSIZE)
80101851:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101856:	0f 87 fa 00 00 00    	ja     80101956 <writei+0x132>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010185c:	bb 00 00 00 00       	mov    $0x0,%ebx
80101861:	89 7d 10             	mov    %edi,0x10(%ebp)
80101864:	89 df                	mov    %ebx,%edi
80101866:	eb 60                	jmp    801018c8 <writei+0xa4>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101868:	66 8b 40 52          	mov    0x52(%eax),%ax
8010186c:	66 83 f8 09          	cmp    $0x9,%ax
80101870:	0f 87 c4 00 00 00    	ja     8010193a <writei+0x116>
80101876:	98                   	cwtl   
80101877:	8b 04 c5 04 f9 10 80 	mov    -0x7fef06fc(,%eax,8),%eax
8010187e:	85 c0                	test   %eax,%eax
80101880:	0f 84 bb 00 00 00    	je     80101941 <writei+0x11d>
    return devsw[ip->major].write(ip, src, n);
80101886:	83 ec 04             	sub    $0x4,%esp
80101889:	ff 75 14             	pushl  0x14(%ebp)
8010188c:	ff 75 0c             	pushl  0xc(%ebp)
8010188f:	ff 75 08             	pushl  0x8(%ebp)
80101892:	ff d0                	call   *%eax
80101894:	83 c4 10             	add    $0x10,%esp
80101897:	e9 85 00 00 00       	jmp    80101921 <writei+0xfd>
    memmove(bp->data + off%BSIZE, src, m);
8010189c:	83 ec 04             	sub    $0x4,%esp
8010189f:	56                   	push   %esi
801018a0:	ff 75 0c             	pushl  0xc(%ebp)
801018a3:	8d 44 13 5c          	lea    0x5c(%ebx,%edx,1),%eax
801018a7:	50                   	push   %eax
801018a8:	e8 61 25 00 00       	call   80103e0e <memmove>
    log_write(bp);
801018ad:	89 1c 24             	mov    %ebx,(%esp)
801018b0:	e8 8f 0f 00 00       	call   80102844 <log_write>
    brelse(bp);
801018b5:	89 1c 24             	mov    %ebx,(%esp)
801018b8:	e8 1a e9 ff ff       	call   801001d7 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
801018bd:	01 f7                	add    %esi,%edi
801018bf:	01 75 10             	add    %esi,0x10(%ebp)
801018c2:	01 75 0c             	add    %esi,0xc(%ebp)
801018c5:	83 c4 10             	add    $0x10,%esp
801018c8:	3b 7d 14             	cmp    0x14(%ebp),%edi
801018cb:	73 40                	jae    8010190d <writei+0xe9>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801018cd:	8b 55 10             	mov    0x10(%ebp),%edx
801018d0:	c1 ea 09             	shr    $0x9,%edx
801018d3:	8b 45 08             	mov    0x8(%ebp),%eax
801018d6:	e8 4a f8 ff ff       	call   80101125 <bmap>
801018db:	83 ec 08             	sub    $0x8,%esp
801018de:	50                   	push   %eax
801018df:	8b 45 08             	mov    0x8(%ebp),%eax
801018e2:	ff 30                	pushl  (%eax)
801018e4:	e8 81 e8 ff ff       	call   8010016a <bread>
801018e9:	89 c3                	mov    %eax,%ebx
    m = min(n - tot, BSIZE - off%BSIZE);
801018eb:	8b 55 10             	mov    0x10(%ebp),%edx
801018ee:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801018f4:	b8 00 02 00 00       	mov    $0x200,%eax
801018f9:	29 d0                	sub    %edx,%eax
801018fb:	8b 4d 14             	mov    0x14(%ebp),%ecx
801018fe:	29 f9                	sub    %edi,%ecx
80101900:	89 c6                	mov    %eax,%esi
80101902:	83 c4 10             	add    $0x10,%esp
80101905:	39 c1                	cmp    %eax,%ecx
80101907:	73 93                	jae    8010189c <writei+0x78>
80101909:	89 ce                	mov    %ecx,%esi
8010190b:	eb 8f                	jmp    8010189c <writei+0x78>
  if(n > 0 && off > ip->size){
8010190d:	8b 7d 10             	mov    0x10(%ebp),%edi
80101910:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
80101914:	74 08                	je     8010191e <writei+0xfa>
80101916:	8b 45 08             	mov    0x8(%ebp),%eax
80101919:	39 78 58             	cmp    %edi,0x58(%eax)
8010191c:	72 0b                	jb     80101929 <writei+0x105>
  return n;
8010191e:	8b 45 14             	mov    0x14(%ebp),%eax
}
80101921:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101924:	5b                   	pop    %ebx
80101925:	5e                   	pop    %esi
80101926:	5f                   	pop    %edi
80101927:	5d                   	pop    %ebp
80101928:	c3                   	ret    
    ip->size = off;
80101929:	89 78 58             	mov    %edi,0x58(%eax)
    iupdate(ip);
8010192c:	83 ec 0c             	sub    $0xc,%esp
8010192f:	50                   	push   %eax
80101930:	e8 a6 fa ff ff       	call   801013db <iupdate>
80101935:	83 c4 10             	add    $0x10,%esp
80101938:	eb e4                	jmp    8010191e <writei+0xfa>
      return -1;
8010193a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010193f:	eb e0                	jmp    80101921 <writei+0xfd>
80101941:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101946:	eb d9                	jmp    80101921 <writei+0xfd>
    return -1;
80101948:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010194d:	eb d2                	jmp    80101921 <writei+0xfd>
8010194f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101954:	eb cb                	jmp    80101921 <writei+0xfd>
    return -1;
80101956:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010195b:	eb c4                	jmp    80101921 <writei+0xfd>

8010195d <namecmp>:
{
8010195d:	55                   	push   %ebp
8010195e:	89 e5                	mov    %esp,%ebp
80101960:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101963:	6a 0e                	push   $0xe
80101965:	ff 75 0c             	pushl  0xc(%ebp)
80101968:	ff 75 08             	pushl  0x8(%ebp)
8010196b:	e8 04 25 00 00       	call   80103e74 <strncmp>
}
80101970:	c9                   	leave  
80101971:	c3                   	ret    

80101972 <dirlookup>:
{
80101972:	55                   	push   %ebp
80101973:	89 e5                	mov    %esp,%ebp
80101975:	57                   	push   %edi
80101976:	56                   	push   %esi
80101977:	53                   	push   %ebx
80101978:	83 ec 1c             	sub    $0x1c,%esp
8010197b:	8b 75 08             	mov    0x8(%ebp),%esi
8010197e:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101981:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101986:	75 07                	jne    8010198f <dirlookup+0x1d>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101988:	bb 00 00 00 00       	mov    $0x0,%ebx
8010198d:	eb 1d                	jmp    801019ac <dirlookup+0x3a>
    panic("dirlookup not DIR");
8010198f:	83 ec 0c             	sub    $0xc,%esp
80101992:	68 47 69 10 80       	push   $0x80106947
80101997:	e8 a8 e9 ff ff       	call   80100344 <panic>
      panic("dirlookup read");
8010199c:	83 ec 0c             	sub    $0xc,%esp
8010199f:	68 59 69 10 80       	push   $0x80106959
801019a4:	e8 9b e9 ff ff       	call   80100344 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
801019a9:	83 c3 10             	add    $0x10,%ebx
801019ac:	3b 5e 58             	cmp    0x58(%esi),%ebx
801019af:	73 48                	jae    801019f9 <dirlookup+0x87>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801019b1:	6a 10                	push   $0x10
801019b3:	53                   	push   %ebx
801019b4:	8d 45 d8             	lea    -0x28(%ebp),%eax
801019b7:	50                   	push   %eax
801019b8:	56                   	push   %esi
801019b9:	e8 63 fd ff ff       	call   80101721 <readi>
801019be:	83 c4 10             	add    $0x10,%esp
801019c1:	83 f8 10             	cmp    $0x10,%eax
801019c4:	75 d6                	jne    8010199c <dirlookup+0x2a>
    if(de.inum == 0)
801019c6:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801019cb:	74 dc                	je     801019a9 <dirlookup+0x37>
    if(namecmp(name, de.name) == 0){
801019cd:	83 ec 08             	sub    $0x8,%esp
801019d0:	8d 45 da             	lea    -0x26(%ebp),%eax
801019d3:	50                   	push   %eax
801019d4:	57                   	push   %edi
801019d5:	e8 83 ff ff ff       	call   8010195d <namecmp>
801019da:	83 c4 10             	add    $0x10,%esp
801019dd:	85 c0                	test   %eax,%eax
801019df:	75 c8                	jne    801019a9 <dirlookup+0x37>
      if(poff)
801019e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
801019e5:	74 05                	je     801019ec <dirlookup+0x7a>
        *poff = off;
801019e7:	8b 45 10             	mov    0x10(%ebp),%eax
801019ea:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
801019ec:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
801019f0:	8b 06                	mov    (%esi),%eax
801019f2:	e8 d4 f7 ff ff       	call   801011cb <iget>
801019f7:	eb 05                	jmp    801019fe <dirlookup+0x8c>
  return 0;
801019f9:	b8 00 00 00 00       	mov    $0x0,%eax
}
801019fe:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a01:	5b                   	pop    %ebx
80101a02:	5e                   	pop    %esi
80101a03:	5f                   	pop    %edi
80101a04:	5d                   	pop    %ebp
80101a05:	c3                   	ret    

80101a06 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101a06:	55                   	push   %ebp
80101a07:	89 e5                	mov    %esp,%ebp
80101a09:	57                   	push   %edi
80101a0a:	56                   	push   %esi
80101a0b:	53                   	push   %ebx
80101a0c:	83 ec 1c             	sub    $0x1c,%esp
80101a0f:	89 c3                	mov    %eax,%ebx
80101a11:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101a14:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101a17:	80 38 2f             	cmpb   $0x2f,(%eax)
80101a1a:	74 17                	je     80101a33 <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101a1c:	e8 46 17 00 00       	call   80103167 <myproc>
80101a21:	83 ec 0c             	sub    $0xc,%esp
80101a24:	ff 70 68             	pushl  0x68(%eax)
80101a27:	e8 da fa ff ff       	call   80101506 <idup>
80101a2c:	89 c6                	mov    %eax,%esi
80101a2e:	83 c4 10             	add    $0x10,%esp
80101a31:	eb 53                	jmp    80101a86 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101a33:	ba 01 00 00 00       	mov    $0x1,%edx
80101a38:	b8 01 00 00 00       	mov    $0x1,%eax
80101a3d:	e8 89 f7 ff ff       	call   801011cb <iget>
80101a42:	89 c6                	mov    %eax,%esi
80101a44:	eb 40                	jmp    80101a86 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101a46:	83 ec 0c             	sub    $0xc,%esp
80101a49:	56                   	push   %esi
80101a4a:	e8 88 fc ff ff       	call   801016d7 <iunlockput>
      return 0;
80101a4f:	83 c4 10             	add    $0x10,%esp
80101a52:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101a57:	89 f0                	mov    %esi,%eax
80101a59:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a5c:	5b                   	pop    %ebx
80101a5d:	5e                   	pop    %esi
80101a5e:	5f                   	pop    %edi
80101a5f:	5d                   	pop    %ebp
80101a60:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101a61:	83 ec 04             	sub    $0x4,%esp
80101a64:	6a 00                	push   $0x0
80101a66:	ff 75 e4             	pushl  -0x1c(%ebp)
80101a69:	56                   	push   %esi
80101a6a:	e8 03 ff ff ff       	call   80101972 <dirlookup>
80101a6f:	89 c7                	mov    %eax,%edi
80101a71:	83 c4 10             	add    $0x10,%esp
80101a74:	85 c0                	test   %eax,%eax
80101a76:	74 4a                	je     80101ac2 <namex+0xbc>
    iunlockput(ip);
80101a78:	83 ec 0c             	sub    $0xc,%esp
80101a7b:	56                   	push   %esi
80101a7c:	e8 56 fc ff ff       	call   801016d7 <iunlockput>
80101a81:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101a84:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101a86:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101a89:	89 d8                	mov    %ebx,%eax
80101a8b:	e8 9b f4 ff ff       	call   80100f2b <skipelem>
80101a90:	89 c3                	mov    %eax,%ebx
80101a92:	85 c0                	test   %eax,%eax
80101a94:	74 3c                	je     80101ad2 <namex+0xcc>
    ilock(ip);
80101a96:	83 ec 0c             	sub    $0xc,%esp
80101a99:	56                   	push   %esi
80101a9a:	e8 95 fa ff ff       	call   80101534 <ilock>
    if(ip->type != T_DIR){
80101a9f:	83 c4 10             	add    $0x10,%esp
80101aa2:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101aa7:	75 9d                	jne    80101a46 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101aa9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101aad:	74 b2                	je     80101a61 <namex+0x5b>
80101aaf:	80 3b 00             	cmpb   $0x0,(%ebx)
80101ab2:	75 ad                	jne    80101a61 <namex+0x5b>
      iunlock(ip);
80101ab4:	83 ec 0c             	sub    $0xc,%esp
80101ab7:	56                   	push   %esi
80101ab8:	e8 37 fb ff ff       	call   801015f4 <iunlock>
      return ip;
80101abd:	83 c4 10             	add    $0x10,%esp
80101ac0:	eb 95                	jmp    80101a57 <namex+0x51>
      iunlockput(ip);
80101ac2:	83 ec 0c             	sub    $0xc,%esp
80101ac5:	56                   	push   %esi
80101ac6:	e8 0c fc ff ff       	call   801016d7 <iunlockput>
      return 0;
80101acb:	83 c4 10             	add    $0x10,%esp
80101ace:	89 fe                	mov    %edi,%esi
80101ad0:	eb 85                	jmp    80101a57 <namex+0x51>
  if(nameiparent){
80101ad2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101ad6:	0f 84 7b ff ff ff    	je     80101a57 <namex+0x51>
    iput(ip);
80101adc:	83 ec 0c             	sub    $0xc,%esp
80101adf:	56                   	push   %esi
80101ae0:	e8 54 fb ff ff       	call   80101639 <iput>
    return 0;
80101ae5:	83 c4 10             	add    $0x10,%esp
80101ae8:	89 de                	mov    %ebx,%esi
80101aea:	e9 68 ff ff ff       	jmp    80101a57 <namex+0x51>

80101aef <dirlink>:
{
80101aef:	55                   	push   %ebp
80101af0:	89 e5                	mov    %esp,%ebp
80101af2:	57                   	push   %edi
80101af3:	56                   	push   %esi
80101af4:	53                   	push   %ebx
80101af5:	83 ec 20             	sub    $0x20,%esp
80101af8:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101afb:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101afe:	6a 00                	push   $0x0
80101b00:	57                   	push   %edi
80101b01:	53                   	push   %ebx
80101b02:	e8 6b fe ff ff       	call   80101972 <dirlookup>
80101b07:	83 c4 10             	add    $0x10,%esp
80101b0a:	85 c0                	test   %eax,%eax
80101b0c:	75 2d                	jne    80101b3b <dirlink+0x4c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b0e:	b8 00 00 00 00       	mov    $0x0,%eax
80101b13:	89 c6                	mov    %eax,%esi
80101b15:	3b 43 58             	cmp    0x58(%ebx),%eax
80101b18:	73 41                	jae    80101b5b <dirlink+0x6c>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b1a:	6a 10                	push   $0x10
80101b1c:	50                   	push   %eax
80101b1d:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101b20:	50                   	push   %eax
80101b21:	53                   	push   %ebx
80101b22:	e8 fa fb ff ff       	call   80101721 <readi>
80101b27:	83 c4 10             	add    $0x10,%esp
80101b2a:	83 f8 10             	cmp    $0x10,%eax
80101b2d:	75 1f                	jne    80101b4e <dirlink+0x5f>
    if(de.inum == 0)
80101b2f:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101b34:	74 25                	je     80101b5b <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101b36:	8d 46 10             	lea    0x10(%esi),%eax
80101b39:	eb d8                	jmp    80101b13 <dirlink+0x24>
    iput(ip);
80101b3b:	83 ec 0c             	sub    $0xc,%esp
80101b3e:	50                   	push   %eax
80101b3f:	e8 f5 fa ff ff       	call   80101639 <iput>
    return -1;
80101b44:	83 c4 10             	add    $0x10,%esp
80101b47:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b4c:	eb 3d                	jmp    80101b8b <dirlink+0x9c>
      panic("dirlink read");
80101b4e:	83 ec 0c             	sub    $0xc,%esp
80101b51:	68 68 69 10 80       	push   $0x80106968
80101b56:	e8 e9 e7 ff ff       	call   80100344 <panic>
  strncpy(de.name, name, DIRSIZ);
80101b5b:	83 ec 04             	sub    $0x4,%esp
80101b5e:	6a 0e                	push   $0xe
80101b60:	57                   	push   %edi
80101b61:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101b64:	8d 45 da             	lea    -0x26(%ebp),%eax
80101b67:	50                   	push   %eax
80101b68:	e8 3f 23 00 00       	call   80103eac <strncpy>
  de.inum = inum;
80101b6d:	8b 45 10             	mov    0x10(%ebp),%eax
80101b70:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101b74:	6a 10                	push   $0x10
80101b76:	56                   	push   %esi
80101b77:	57                   	push   %edi
80101b78:	53                   	push   %ebx
80101b79:	e8 a6 fc ff ff       	call   80101824 <writei>
80101b7e:	83 c4 20             	add    $0x20,%esp
80101b81:	83 f8 10             	cmp    $0x10,%eax
80101b84:	75 0d                	jne    80101b93 <dirlink+0xa4>
  return 0;
80101b86:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101b8b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b8e:	5b                   	pop    %ebx
80101b8f:	5e                   	pop    %esi
80101b90:	5f                   	pop    %edi
80101b91:	5d                   	pop    %ebp
80101b92:	c3                   	ret    
    panic("dirlink");
80101b93:	83 ec 0c             	sub    $0xc,%esp
80101b96:	68 80 6f 10 80       	push   $0x80106f80
80101b9b:	e8 a4 e7 ff ff       	call   80100344 <panic>

80101ba0 <namei>:

struct inode*
namei(char *path)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ba6:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ba9:	ba 00 00 00 00       	mov    $0x0,%edx
80101bae:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb1:	e8 50 fe ff ff       	call   80101a06 <namex>
}
80101bb6:	c9                   	leave  
80101bb7:	c3                   	ret    

80101bb8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101bb8:	55                   	push   %ebp
80101bb9:	89 e5                	mov    %esp,%ebp
80101bbb:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101bbe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101bc1:	ba 01 00 00 00       	mov    $0x1,%edx
80101bc6:	8b 45 08             	mov    0x8(%ebp),%eax
80101bc9:	e8 38 fe ff ff       	call   80101a06 <namex>
}
80101bce:	c9                   	leave  
80101bcf:	c3                   	ret    

80101bd0 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101bd0:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101bd2:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101bd7:	ec                   	in     (%dx),%al
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101bd8:	88 c2                	mov    %al,%dl
80101bda:	83 e2 c0             	and    $0xffffffc0,%edx
80101bdd:	80 fa 40             	cmp    $0x40,%dl
80101be0:	75 f0                	jne    80101bd2 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101be2:	85 c9                	test   %ecx,%ecx
80101be4:	74 09                	je     80101bef <idewait+0x1f>
80101be6:	a8 21                	test   $0x21,%al
80101be8:	75 08                	jne    80101bf2 <idewait+0x22>
    return -1;
  return 0;
80101bea:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101bef:	89 c8                	mov    %ecx,%eax
80101bf1:	c3                   	ret    
    return -1;
80101bf2:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101bf7:	eb f6                	jmp    80101bef <idewait+0x1f>

80101bf9 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101bf9:	55                   	push   %ebp
80101bfa:	89 e5                	mov    %esp,%ebp
80101bfc:	56                   	push   %esi
80101bfd:	53                   	push   %ebx
  if(b == 0)
80101bfe:	85 c0                	test   %eax,%eax
80101c00:	0f 84 85 00 00 00    	je     80101c8b <idestart+0x92>
80101c06:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101c08:	8b 58 08             	mov    0x8(%eax),%ebx
80101c0b:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101c11:	0f 87 81 00 00 00    	ja     80101c98 <idestart+0x9f>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101c17:	b8 00 00 00 00       	mov    $0x0,%eax
80101c1c:	e8 af ff ff ff       	call   80101bd0 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101c21:	b0 00                	mov    $0x0,%al
80101c23:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101c28:	ee                   	out    %al,(%dx)
80101c29:	b0 01                	mov    $0x1,%al
80101c2b:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101c30:	ee                   	out    %al,(%dx)
80101c31:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101c36:	88 d8                	mov    %bl,%al
80101c38:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101c39:	0f b6 c7             	movzbl %bh,%eax
80101c3c:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101c41:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101c42:	89 d8                	mov    %ebx,%eax
80101c44:	c1 f8 10             	sar    $0x10,%eax
80101c47:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101c4c:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101c4d:	8a 46 04             	mov    0x4(%esi),%al
80101c50:	c1 e0 04             	shl    $0x4,%eax
80101c53:	83 e0 10             	and    $0x10,%eax
80101c56:	c1 fb 18             	sar    $0x18,%ebx
80101c59:	83 e3 0f             	and    $0xf,%ebx
80101c5c:	09 d8                	or     %ebx,%eax
80101c5e:	83 c8 e0             	or     $0xffffffe0,%eax
80101c61:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101c66:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101c67:	f6 06 04             	testb  $0x4,(%esi)
80101c6a:	74 39                	je     80101ca5 <idestart+0xac>
80101c6c:	b0 30                	mov    $0x30,%al
80101c6e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c73:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101c74:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101c77:	b9 80 00 00 00       	mov    $0x80,%ecx
80101c7c:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101c81:	fc                   	cld    
80101c82:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101c84:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101c87:	5b                   	pop    %ebx
80101c88:	5e                   	pop    %esi
80101c89:	5d                   	pop    %ebp
80101c8a:	c3                   	ret    
    panic("idestart");
80101c8b:	83 ec 0c             	sub    $0xc,%esp
80101c8e:	68 cb 69 10 80       	push   $0x801069cb
80101c93:	e8 ac e6 ff ff       	call   80100344 <panic>
    panic("incorrect blockno");
80101c98:	83 ec 0c             	sub    $0xc,%esp
80101c9b:	68 d4 69 10 80       	push   $0x801069d4
80101ca0:	e8 9f e6 ff ff       	call   80100344 <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ca5:	b0 20                	mov    $0x20,%al
80101ca7:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cac:	ee                   	out    %al,(%dx)
}
80101cad:	eb d5                	jmp    80101c84 <idestart+0x8b>

80101caf <ideinit>:
{
80101caf:	55                   	push   %ebp
80101cb0:	89 e5                	mov    %esp,%ebp
80101cb2:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101cb5:	68 e6 69 10 80       	push   $0x801069e6
80101cba:	68 00 16 11 80       	push   $0x80111600
80101cbf:	e8 e8 1e 00 00       	call   80103bac <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101cc4:	83 c4 08             	add    $0x8,%esp
80101cc7:	a1 84 17 11 80       	mov    0x80111784,%eax
80101ccc:	48                   	dec    %eax
80101ccd:	50                   	push   %eax
80101cce:	6a 0e                	push   $0xe
80101cd0:	e8 4b 02 00 00       	call   80101f20 <ioapicenable>
  idewait(0);
80101cd5:	b8 00 00 00 00       	mov    $0x0,%eax
80101cda:	e8 f1 fe ff ff       	call   80101bd0 <idewait>
80101cdf:	b0 f0                	mov    $0xf0,%al
80101ce1:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101ce6:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101ce7:	83 c4 10             	add    $0x10,%esp
80101cea:	b9 00 00 00 00       	mov    $0x0,%ecx
80101cef:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101cf5:	7f 17                	jg     80101d0e <ideinit+0x5f>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101cf7:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101cfc:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101cfd:	84 c0                	test   %al,%al
80101cff:	75 03                	jne    80101d04 <ideinit+0x55>
  for(i=0; i<1000; i++){
80101d01:	41                   	inc    %ecx
80101d02:	eb eb                	jmp    80101cef <ideinit+0x40>
      havedisk1 = 1;
80101d04:	c7 05 e0 15 11 80 01 	movl   $0x1,0x801115e0
80101d0b:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d0e:	b0 e0                	mov    $0xe0,%al
80101d10:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d15:	ee                   	out    %al,(%dx)
}
80101d16:	c9                   	leave  
80101d17:	c3                   	ret    

80101d18 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101d18:	55                   	push   %ebp
80101d19:	89 e5                	mov    %esp,%ebp
80101d1b:	57                   	push   %edi
80101d1c:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101d1d:	83 ec 0c             	sub    $0xc,%esp
80101d20:	68 00 16 11 80       	push   $0x80111600
80101d25:	e8 c2 1f 00 00       	call   80103cec <acquire>

  if((b = idequeue) == 0){
80101d2a:	8b 1d e4 15 11 80    	mov    0x801115e4,%ebx
80101d30:	83 c4 10             	add    $0x10,%esp
80101d33:	85 db                	test   %ebx,%ebx
80101d35:	74 4f                	je     80101d86 <ideintr+0x6e>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101d37:	8b 43 58             	mov    0x58(%ebx),%eax
80101d3a:	a3 e4 15 11 80       	mov    %eax,0x801115e4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d3f:	f6 03 04             	testb  $0x4,(%ebx)
80101d42:	74 54                	je     80101d98 <ideintr+0x80>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101d44:	8b 03                	mov    (%ebx),%eax
80101d46:	89 c2                	mov    %eax,%edx
80101d48:	83 ca 02             	or     $0x2,%edx
80101d4b:	89 13                	mov    %edx,(%ebx)
  b->flags &= ~B_DIRTY;
80101d4d:	83 e0 fb             	and    $0xfffffffb,%eax
80101d50:	83 c8 02             	or     $0x2,%eax
80101d53:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101d55:	83 ec 0c             	sub    $0xc,%esp
80101d58:	53                   	push   %ebx
80101d59:	e8 4c 19 00 00       	call   801036aa <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101d5e:	a1 e4 15 11 80       	mov    0x801115e4,%eax
80101d63:	83 c4 10             	add    $0x10,%esp
80101d66:	85 c0                	test   %eax,%eax
80101d68:	74 05                	je     80101d6f <ideintr+0x57>
    idestart(idequeue);
80101d6a:	e8 8a fe ff ff       	call   80101bf9 <idestart>

  release(&idelock);
80101d6f:	83 ec 0c             	sub    $0xc,%esp
80101d72:	68 00 16 11 80       	push   $0x80111600
80101d77:	e8 d5 1f 00 00       	call   80103d51 <release>
80101d7c:	83 c4 10             	add    $0x10,%esp
}
80101d7f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d82:	5b                   	pop    %ebx
80101d83:	5f                   	pop    %edi
80101d84:	5d                   	pop    %ebp
80101d85:	c3                   	ret    
    release(&idelock);
80101d86:	83 ec 0c             	sub    $0xc,%esp
80101d89:	68 00 16 11 80       	push   $0x80111600
80101d8e:	e8 be 1f 00 00       	call   80103d51 <release>
    return;
80101d93:	83 c4 10             	add    $0x10,%esp
80101d96:	eb e7                	jmp    80101d7f <ideintr+0x67>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101d98:	b8 01 00 00 00       	mov    $0x1,%eax
80101d9d:	e8 2e fe ff ff       	call   80101bd0 <idewait>
80101da2:	85 c0                	test   %eax,%eax
80101da4:	78 9e                	js     80101d44 <ideintr+0x2c>
    insl(0x1f0, b->data, BSIZE/4);
80101da6:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101da9:	b9 80 00 00 00       	mov    $0x80,%ecx
80101dae:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101db3:	fc                   	cld    
80101db4:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101db6:	eb 8c                	jmp    80101d44 <ideintr+0x2c>

80101db8 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101db8:	55                   	push   %ebp
80101db9:	89 e5                	mov    %esp,%ebp
80101dbb:	53                   	push   %ebx
80101dbc:	83 ec 10             	sub    $0x10,%esp
80101dbf:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101dc2:	8d 43 0c             	lea    0xc(%ebx),%eax
80101dc5:	50                   	push   %eax
80101dc6:	e8 93 1d 00 00       	call   80103b5e <holdingsleep>
80101dcb:	83 c4 10             	add    $0x10,%esp
80101dce:	85 c0                	test   %eax,%eax
80101dd0:	74 37                	je     80101e09 <iderw+0x51>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101dd2:	8b 03                	mov    (%ebx),%eax
80101dd4:	83 e0 06             	and    $0x6,%eax
80101dd7:	83 f8 02             	cmp    $0x2,%eax
80101dda:	74 3a                	je     80101e16 <iderw+0x5e>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101ddc:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101de0:	74 09                	je     80101deb <iderw+0x33>
80101de2:	83 3d e0 15 11 80 00 	cmpl   $0x0,0x801115e0
80101de9:	74 38                	je     80101e23 <iderw+0x6b>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101deb:	83 ec 0c             	sub    $0xc,%esp
80101dee:	68 00 16 11 80       	push   $0x80111600
80101df3:	e8 f4 1e 00 00       	call   80103cec <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101df8:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101dff:	83 c4 10             	add    $0x10,%esp
80101e02:	ba e4 15 11 80       	mov    $0x801115e4,%edx
80101e07:	eb 2a                	jmp    80101e33 <iderw+0x7b>
    panic("iderw: buf not locked");
80101e09:	83 ec 0c             	sub    $0xc,%esp
80101e0c:	68 ea 69 10 80       	push   $0x801069ea
80101e11:	e8 2e e5 ff ff       	call   80100344 <panic>
    panic("iderw: nothing to do");
80101e16:	83 ec 0c             	sub    $0xc,%esp
80101e19:	68 00 6a 10 80       	push   $0x80106a00
80101e1e:	e8 21 e5 ff ff       	call   80100344 <panic>
    panic("iderw: ide disk 1 not present");
80101e23:	83 ec 0c             	sub    $0xc,%esp
80101e26:	68 15 6a 10 80       	push   $0x80106a15
80101e2b:	e8 14 e5 ff ff       	call   80100344 <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101e30:	8d 50 58             	lea    0x58(%eax),%edx
80101e33:	8b 02                	mov    (%edx),%eax
80101e35:	85 c0                	test   %eax,%eax
80101e37:	75 f7                	jne    80101e30 <iderw+0x78>
    ;
  *pp = b;
80101e39:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101e3b:	39 1d e4 15 11 80    	cmp    %ebx,0x801115e4
80101e41:	75 1a                	jne    80101e5d <iderw+0xa5>
    idestart(b);
80101e43:	89 d8                	mov    %ebx,%eax
80101e45:	e8 af fd ff ff       	call   80101bf9 <idestart>
80101e4a:	eb 11                	jmp    80101e5d <iderw+0xa5>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101e4c:	83 ec 08             	sub    $0x8,%esp
80101e4f:	68 00 16 11 80       	push   $0x80111600
80101e54:	53                   	push   %ebx
80101e55:	e8 e8 16 00 00       	call   80103542 <sleep>
80101e5a:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101e5d:	8b 03                	mov    (%ebx),%eax
80101e5f:	83 e0 06             	and    $0x6,%eax
80101e62:	83 f8 02             	cmp    $0x2,%eax
80101e65:	75 e5                	jne    80101e4c <iderw+0x94>
  }


  release(&idelock);
80101e67:	83 ec 0c             	sub    $0xc,%esp
80101e6a:	68 00 16 11 80       	push   $0x80111600
80101e6f:	e8 dd 1e 00 00       	call   80103d51 <release>
}
80101e74:	83 c4 10             	add    $0x10,%esp
80101e77:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101e7a:	c9                   	leave  
80101e7b:	c3                   	ret    

80101e7c <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101e7c:	8b 15 34 16 11 80    	mov    0x80111634,%edx
80101e82:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101e84:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e89:	8b 40 10             	mov    0x10(%eax),%eax
}
80101e8c:	c3                   	ret    

80101e8d <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101e8d:	8b 0d 34 16 11 80    	mov    0x80111634,%ecx
80101e93:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101e95:	a1 34 16 11 80       	mov    0x80111634,%eax
80101e9a:	89 50 10             	mov    %edx,0x10(%eax)
}
80101e9d:	c3                   	ret    

80101e9e <ioapicinit>:

void
ioapicinit(void)
{
80101e9e:	55                   	push   %ebp
80101e9f:	89 e5                	mov    %esp,%ebp
80101ea1:	57                   	push   %edi
80101ea2:	56                   	push   %esi
80101ea3:	53                   	push   %ebx
80101ea4:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101ea7:	c7 05 34 16 11 80 00 	movl   $0xfec00000,0x80111634
80101eae:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101eb1:	b8 01 00 00 00       	mov    $0x1,%eax
80101eb6:	e8 c1 ff ff ff       	call   80101e7c <ioapicread>
80101ebb:	c1 e8 10             	shr    $0x10,%eax
80101ebe:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101ec1:	b8 00 00 00 00       	mov    $0x0,%eax
80101ec6:	e8 b1 ff ff ff       	call   80101e7c <ioapicread>
80101ecb:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101ece:	0f b6 15 80 17 11 80 	movzbl 0x80111780,%edx
80101ed5:	39 c2                	cmp    %eax,%edx
80101ed7:	75 07                	jne    80101ee0 <ioapicinit+0x42>
{
80101ed9:	bb 00 00 00 00       	mov    $0x0,%ebx
80101ede:	eb 34                	jmp    80101f14 <ioapicinit+0x76>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101ee0:	83 ec 0c             	sub    $0xc,%esp
80101ee3:	68 34 6a 10 80       	push   $0x80106a34
80101ee8:	e8 f2 e6 ff ff       	call   801005df <cprintf>
80101eed:	83 c4 10             	add    $0x10,%esp
80101ef0:	eb e7                	jmp    80101ed9 <ioapicinit+0x3b>

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101ef2:	8d 53 20             	lea    0x20(%ebx),%edx
80101ef5:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101efb:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101eff:	89 f0                	mov    %esi,%eax
80101f01:	e8 87 ff ff ff       	call   80101e8d <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101f06:	8d 46 01             	lea    0x1(%esi),%eax
80101f09:	ba 00 00 00 00       	mov    $0x0,%edx
80101f0e:	e8 7a ff ff ff       	call   80101e8d <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101f13:	43                   	inc    %ebx
80101f14:	39 fb                	cmp    %edi,%ebx
80101f16:	7e da                	jle    80101ef2 <ioapicinit+0x54>
  }
}
80101f18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101f1b:	5b                   	pop    %ebx
80101f1c:	5e                   	pop    %esi
80101f1d:	5f                   	pop    %edi
80101f1e:	5d                   	pop    %ebp
80101f1f:	c3                   	ret    

80101f20 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101f20:	55                   	push   %ebp
80101f21:	89 e5                	mov    %esp,%ebp
80101f23:	53                   	push   %ebx
80101f24:	83 ec 04             	sub    $0x4,%esp
80101f27:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80101f2a:	8d 50 20             	lea    0x20(%eax),%edx
80101f2d:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80101f31:	89 d8                	mov    %ebx,%eax
80101f33:	e8 55 ff ff ff       	call   80101e8d <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80101f38:	8b 55 0c             	mov    0xc(%ebp),%edx
80101f3b:	c1 e2 18             	shl    $0x18,%edx
80101f3e:	8d 43 01             	lea    0x1(%ebx),%eax
80101f41:	e8 47 ff ff ff       	call   80101e8d <ioapicwrite>
}
80101f46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f49:	c9                   	leave  
80101f4a:	c3                   	ret    

80101f4b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80101f4b:	55                   	push   %ebp
80101f4c:	89 e5                	mov    %esp,%ebp
80101f4e:	53                   	push   %ebx
80101f4f:	83 ec 04             	sub    $0x4,%esp
80101f52:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80101f55:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80101f5b:	75 4c                	jne    80101fa9 <kfree+0x5e>
80101f5d:	81 fb d0 83 11 80    	cmp    $0x801183d0,%ebx
80101f63:	72 44                	jb     80101fa9 <kfree+0x5e>
80101f65:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80101f6b:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80101f70:	77 37                	ja     80101fa9 <kfree+0x5e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80101f72:	83 ec 04             	sub    $0x4,%esp
80101f75:	68 00 10 00 00       	push   $0x1000
80101f7a:	6a 01                	push   $0x1
80101f7c:	53                   	push   %ebx
80101f7d:	e8 16 1e 00 00       	call   80103d98 <memset>

  if(kmem.use_lock)
80101f82:	83 c4 10             	add    $0x10,%esp
80101f85:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101f8c:	75 28                	jne    80101fb6 <kfree+0x6b>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80101f8e:	a1 78 16 11 80       	mov    0x80111678,%eax
80101f93:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80101f95:	89 1d 78 16 11 80    	mov    %ebx,0x80111678
  if(kmem.use_lock)
80101f9b:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80101fa2:	75 24                	jne    80101fc8 <kfree+0x7d>
    release(&kmem.lock);
}
80101fa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101fa7:	c9                   	leave  
80101fa8:	c3                   	ret    
    panic("kfree");
80101fa9:	83 ec 0c             	sub    $0xc,%esp
80101fac:	68 66 6a 10 80       	push   $0x80106a66
80101fb1:	e8 8e e3 ff ff       	call   80100344 <panic>
    acquire(&kmem.lock);
80101fb6:	83 ec 0c             	sub    $0xc,%esp
80101fb9:	68 40 16 11 80       	push   $0x80111640
80101fbe:	e8 29 1d 00 00       	call   80103cec <acquire>
80101fc3:	83 c4 10             	add    $0x10,%esp
80101fc6:	eb c6                	jmp    80101f8e <kfree+0x43>
    release(&kmem.lock);
80101fc8:	83 ec 0c             	sub    $0xc,%esp
80101fcb:	68 40 16 11 80       	push   $0x80111640
80101fd0:	e8 7c 1d 00 00       	call   80103d51 <release>
80101fd5:	83 c4 10             	add    $0x10,%esp
}
80101fd8:	eb ca                	jmp    80101fa4 <kfree+0x59>

80101fda <freerange>:
{
80101fda:	55                   	push   %ebp
80101fdb:	89 e5                	mov    %esp,%ebp
80101fdd:	56                   	push   %esi
80101fde:	53                   	push   %ebx
80101fdf:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
80101fe2:	8b 45 08             	mov    0x8(%ebp),%eax
80101fe5:	05 ff 0f 00 00       	add    $0xfff,%eax
80101fea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101fef:	eb 0e                	jmp    80101fff <freerange+0x25>
    kfree(p);
80101ff1:	83 ec 0c             	sub    $0xc,%esp
80101ff4:	50                   	push   %eax
80101ff5:	e8 51 ff ff ff       	call   80101f4b <kfree>
80101ffa:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80101ffd:	89 f0                	mov    %esi,%eax
80101fff:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
80102005:	39 f3                	cmp    %esi,%ebx
80102007:	73 e8                	jae    80101ff1 <freerange+0x17>
}
80102009:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010200c:	5b                   	pop    %ebx
8010200d:	5e                   	pop    %esi
8010200e:	5d                   	pop    %ebp
8010200f:	c3                   	ret    

80102010 <kinit1>:
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102016:	68 6c 6a 10 80       	push   $0x80106a6c
8010201b:	68 40 16 11 80       	push   $0x80111640
80102020:	e8 87 1b 00 00       	call   80103bac <initlock>
  kmem.use_lock = 0;
80102025:	c7 05 74 16 11 80 00 	movl   $0x0,0x80111674
8010202c:	00 00 00 
  freerange(vstart, vend);
8010202f:	83 c4 08             	add    $0x8,%esp
80102032:	ff 75 0c             	pushl  0xc(%ebp)
80102035:	ff 75 08             	pushl  0x8(%ebp)
80102038:	e8 9d ff ff ff       	call   80101fda <freerange>
}
8010203d:	83 c4 10             	add    $0x10,%esp
80102040:	c9                   	leave  
80102041:	c3                   	ret    

80102042 <kinit2>:
{
80102042:	55                   	push   %ebp
80102043:	89 e5                	mov    %esp,%ebp
80102045:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102048:	ff 75 0c             	pushl  0xc(%ebp)
8010204b:	ff 75 08             	pushl  0x8(%ebp)
8010204e:	e8 87 ff ff ff       	call   80101fda <freerange>
  kmem.use_lock = 1;
80102053:	c7 05 74 16 11 80 01 	movl   $0x1,0x80111674
8010205a:	00 00 00 
}
8010205d:	83 c4 10             	add    $0x10,%esp
80102060:	c9                   	leave  
80102061:	c3                   	ret    

80102062 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102062:	55                   	push   %ebp
80102063:	89 e5                	mov    %esp,%ebp
80102065:	53                   	push   %ebx
80102066:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102069:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
80102070:	75 21                	jne    80102093 <kalloc+0x31>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102072:	8b 1d 78 16 11 80    	mov    0x80111678,%ebx
  if(r)
80102078:	85 db                	test   %ebx,%ebx
8010207a:	74 07                	je     80102083 <kalloc+0x21>
    kmem.freelist = r->next;
8010207c:	8b 03                	mov    (%ebx),%eax
8010207e:	a3 78 16 11 80       	mov    %eax,0x80111678
  if(kmem.use_lock)
80102083:	83 3d 74 16 11 80 00 	cmpl   $0x0,0x80111674
8010208a:	75 19                	jne    801020a5 <kalloc+0x43>
    release(&kmem.lock);
  return (char*)r;
}
8010208c:	89 d8                	mov    %ebx,%eax
8010208e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102091:	c9                   	leave  
80102092:	c3                   	ret    
    acquire(&kmem.lock);
80102093:	83 ec 0c             	sub    $0xc,%esp
80102096:	68 40 16 11 80       	push   $0x80111640
8010209b:	e8 4c 1c 00 00       	call   80103cec <acquire>
801020a0:	83 c4 10             	add    $0x10,%esp
801020a3:	eb cd                	jmp    80102072 <kalloc+0x10>
    release(&kmem.lock);
801020a5:	83 ec 0c             	sub    $0xc,%esp
801020a8:	68 40 16 11 80       	push   $0x80111640
801020ad:	e8 9f 1c 00 00       	call   80103d51 <release>
801020b2:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801020b5:	eb d5                	jmp    8010208c <kalloc+0x2a>

801020b7 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020b7:	ba 64 00 00 00       	mov    $0x64,%edx
801020bc:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801020bd:	a8 01                	test   $0x1,%al
801020bf:	0f 84 b3 00 00 00    	je     80102178 <kbdgetc+0xc1>
801020c5:	ba 60 00 00 00       	mov    $0x60,%edx
801020ca:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801020cb:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
801020ce:	3c e0                	cmp    $0xe0,%al
801020d0:	74 61                	je     80102133 <kbdgetc+0x7c>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801020d2:	84 c0                	test   %al,%al
801020d4:	78 6a                	js     80102140 <kbdgetc+0x89>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801020d6:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
801020dc:	f6 c2 40             	test   $0x40,%dl
801020df:	74 0f                	je     801020f0 <kbdgetc+0x39>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801020e1:	83 c8 80             	or     $0xffffff80,%eax
801020e4:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
801020e7:	83 e2 bf             	and    $0xffffffbf,%edx
801020ea:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  }

  shift |= shiftcode[data];
801020f0:	0f b6 91 a0 6b 10 80 	movzbl -0x7fef9460(%ecx),%edx
801020f7:	0b 15 7c 16 11 80    	or     0x8011167c,%edx
801020fd:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  shift ^= togglecode[data];
80102103:	0f b6 81 a0 6a 10 80 	movzbl -0x7fef9560(%ecx),%eax
8010210a:	31 c2                	xor    %eax,%edx
8010210c:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
  c = charcode[shift & (CTL | SHIFT)][data];
80102112:	89 d0                	mov    %edx,%eax
80102114:	83 e0 03             	and    $0x3,%eax
80102117:	8b 04 85 80 6a 10 80 	mov    -0x7fef9580(,%eax,4),%eax
8010211e:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102122:	f6 c2 08             	test   $0x8,%dl
80102125:	74 56                	je     8010217d <kbdgetc+0xc6>
    if('a' <= c && c <= 'z')
80102127:	8d 50 9f             	lea    -0x61(%eax),%edx
8010212a:	83 fa 19             	cmp    $0x19,%edx
8010212d:	77 3d                	ja     8010216c <kbdgetc+0xb5>
      c += 'A' - 'a';
8010212f:	83 e8 20             	sub    $0x20,%eax
80102132:	c3                   	ret    
    shift |= E0ESC;
80102133:	83 0d 7c 16 11 80 40 	orl    $0x40,0x8011167c
    return 0;
8010213a:	b8 00 00 00 00       	mov    $0x0,%eax
8010213f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102140:	8b 15 7c 16 11 80    	mov    0x8011167c,%edx
80102146:	f6 c2 40             	test   $0x40,%dl
80102149:	75 05                	jne    80102150 <kbdgetc+0x99>
8010214b:	89 c1                	mov    %eax,%ecx
8010214d:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102150:	8a 81 a0 6b 10 80    	mov    -0x7fef9460(%ecx),%al
80102156:	83 c8 40             	or     $0x40,%eax
80102159:	0f b6 c0             	movzbl %al,%eax
8010215c:	f7 d0                	not    %eax
8010215e:	21 c2                	and    %eax,%edx
80102160:	89 15 7c 16 11 80    	mov    %edx,0x8011167c
    return 0;
80102166:	b8 00 00 00 00       	mov    $0x0,%eax
8010216b:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010216c:	8d 50 bf             	lea    -0x41(%eax),%edx
8010216f:	83 fa 19             	cmp    $0x19,%edx
80102172:	77 09                	ja     8010217d <kbdgetc+0xc6>
      c += 'a' - 'A';
80102174:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102177:	c3                   	ret    
    return -1;
80102178:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010217d:	c3                   	ret    

8010217e <kbdintr>:

void
kbdintr(void)
{
8010217e:	55                   	push   %ebp
8010217f:	89 e5                	mov    %esp,%ebp
80102181:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102184:	68 b7 20 10 80       	push   $0x801020b7
80102189:	e8 76 e5 ff ff       	call   80100704 <consoleintr>
}
8010218e:	83 c4 10             	add    $0x10,%esp
80102191:	c9                   	leave  
80102192:	c3                   	ret    

80102193 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102193:	8b 0d 80 16 11 80    	mov    0x80111680,%ecx
80102199:	8d 04 81             	lea    (%ecx,%eax,4),%eax
8010219c:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010219e:	a1 80 16 11 80       	mov    0x80111680,%eax
801021a3:	8b 40 20             	mov    0x20(%eax),%eax
}
801021a6:	c3                   	ret    

801021a7 <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021a7:	ba 70 00 00 00       	mov    $0x70,%edx
801021ac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021ad:	ba 71 00 00 00       	mov    $0x71,%edx
801021b2:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801021b3:	0f b6 c0             	movzbl %al,%eax
}
801021b6:	c3                   	ret    

801021b7 <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801021b7:	55                   	push   %ebp
801021b8:	89 e5                	mov    %esp,%ebp
801021ba:	53                   	push   %ebx
801021bb:	83 ec 04             	sub    $0x4,%esp
801021be:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801021c0:	b8 00 00 00 00       	mov    $0x0,%eax
801021c5:	e8 dd ff ff ff       	call   801021a7 <cmos_read>
801021ca:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
801021cc:	b8 02 00 00 00       	mov    $0x2,%eax
801021d1:	e8 d1 ff ff ff       	call   801021a7 <cmos_read>
801021d6:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
801021d9:	b8 04 00 00 00       	mov    $0x4,%eax
801021de:	e8 c4 ff ff ff       	call   801021a7 <cmos_read>
801021e3:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
801021e6:	b8 07 00 00 00       	mov    $0x7,%eax
801021eb:	e8 b7 ff ff ff       	call   801021a7 <cmos_read>
801021f0:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801021f3:	b8 08 00 00 00       	mov    $0x8,%eax
801021f8:	e8 aa ff ff ff       	call   801021a7 <cmos_read>
801021fd:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
80102200:	b8 09 00 00 00       	mov    $0x9,%eax
80102205:	e8 9d ff ff ff       	call   801021a7 <cmos_read>
8010220a:	89 43 14             	mov    %eax,0x14(%ebx)
}
8010220d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102210:	c9                   	leave  
80102211:	c3                   	ret    

80102212 <lapicinit>:
  if(!lapic)
80102212:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
80102219:	0f 84 fe 00 00 00    	je     8010231d <lapicinit+0x10b>
{
8010221f:	55                   	push   %ebp
80102220:	89 e5                	mov    %esp,%ebp
80102222:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102225:	ba 3f 01 00 00       	mov    $0x13f,%edx
8010222a:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010222f:	e8 5f ff ff ff       	call   80102193 <lapicw>
  lapicw(TDCR, X1);
80102234:	ba 0b 00 00 00       	mov    $0xb,%edx
80102239:	b8 f8 00 00 00       	mov    $0xf8,%eax
8010223e:	e8 50 ff ff ff       	call   80102193 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
80102243:	ba 20 00 02 00       	mov    $0x20020,%edx
80102248:	b8 c8 00 00 00       	mov    $0xc8,%eax
8010224d:	e8 41 ff ff ff       	call   80102193 <lapicw>
  lapicw(TICR, 10000000);
80102252:	ba 80 96 98 00       	mov    $0x989680,%edx
80102257:	b8 e0 00 00 00       	mov    $0xe0,%eax
8010225c:	e8 32 ff ff ff       	call   80102193 <lapicw>
  lapicw(LINT0, MASKED);
80102261:	ba 00 00 01 00       	mov    $0x10000,%edx
80102266:	b8 d4 00 00 00       	mov    $0xd4,%eax
8010226b:	e8 23 ff ff ff       	call   80102193 <lapicw>
  lapicw(LINT1, MASKED);
80102270:	ba 00 00 01 00       	mov    $0x10000,%edx
80102275:	b8 d8 00 00 00       	mov    $0xd8,%eax
8010227a:	e8 14 ff ff ff       	call   80102193 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010227f:	a1 80 16 11 80       	mov    0x80111680,%eax
80102284:	8b 40 30             	mov    0x30(%eax),%eax
80102287:	c1 e8 10             	shr    $0x10,%eax
8010228a:	a8 fc                	test   $0xfc,%al
8010228c:	75 7b                	jne    80102309 <lapicinit+0xf7>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
8010228e:	ba 33 00 00 00       	mov    $0x33,%edx
80102293:	b8 dc 00 00 00       	mov    $0xdc,%eax
80102298:	e8 f6 fe ff ff       	call   80102193 <lapicw>
  lapicw(ESR, 0);
8010229d:	ba 00 00 00 00       	mov    $0x0,%edx
801022a2:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022a7:	e8 e7 fe ff ff       	call   80102193 <lapicw>
  lapicw(ESR, 0);
801022ac:	ba 00 00 00 00       	mov    $0x0,%edx
801022b1:	b8 a0 00 00 00       	mov    $0xa0,%eax
801022b6:	e8 d8 fe ff ff       	call   80102193 <lapicw>
  lapicw(EOI, 0);
801022bb:	ba 00 00 00 00       	mov    $0x0,%edx
801022c0:	b8 2c 00 00 00       	mov    $0x2c,%eax
801022c5:	e8 c9 fe ff ff       	call   80102193 <lapicw>
  lapicw(ICRHI, 0);
801022ca:	ba 00 00 00 00       	mov    $0x0,%edx
801022cf:	b8 c4 00 00 00       	mov    $0xc4,%eax
801022d4:	e8 ba fe ff ff       	call   80102193 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801022d9:	ba 00 85 08 00       	mov    $0x88500,%edx
801022de:	b8 c0 00 00 00       	mov    $0xc0,%eax
801022e3:	e8 ab fe ff ff       	call   80102193 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801022e8:	a1 80 16 11 80       	mov    0x80111680,%eax
801022ed:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801022f3:	f6 c4 10             	test   $0x10,%ah
801022f6:	75 f0                	jne    801022e8 <lapicinit+0xd6>
  lapicw(TPR, 0);
801022f8:	ba 00 00 00 00       	mov    $0x0,%edx
801022fd:	b8 20 00 00 00       	mov    $0x20,%eax
80102302:	e8 8c fe ff ff       	call   80102193 <lapicw>
}
80102307:	c9                   	leave  
80102308:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102309:	ba 00 00 01 00       	mov    $0x10000,%edx
8010230e:	b8 d0 00 00 00       	mov    $0xd0,%eax
80102313:	e8 7b fe ff ff       	call   80102193 <lapicw>
80102318:	e9 71 ff ff ff       	jmp    8010228e <lapicinit+0x7c>
8010231d:	c3                   	ret    

8010231e <lapicid>:
  if (!lapic)
8010231e:	a1 80 16 11 80       	mov    0x80111680,%eax
80102323:	85 c0                	test   %eax,%eax
80102325:	74 07                	je     8010232e <lapicid+0x10>
  return lapic[ID] >> 24;
80102327:	8b 40 20             	mov    0x20(%eax),%eax
8010232a:	c1 e8 18             	shr    $0x18,%eax
8010232d:	c3                   	ret    
    return 0;
8010232e:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102333:	c3                   	ret    

80102334 <lapiceoi>:
  if(lapic)
80102334:	83 3d 80 16 11 80 00 	cmpl   $0x0,0x80111680
8010233b:	74 17                	je     80102354 <lapiceoi+0x20>
{
8010233d:	55                   	push   %ebp
8010233e:	89 e5                	mov    %esp,%ebp
80102340:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102343:	ba 00 00 00 00       	mov    $0x0,%edx
80102348:	b8 2c 00 00 00       	mov    $0x2c,%eax
8010234d:	e8 41 fe ff ff       	call   80102193 <lapicw>
}
80102352:	c9                   	leave  
80102353:	c3                   	ret    
80102354:	c3                   	ret    

80102355 <microdelay>:
}
80102355:	c3                   	ret    

80102356 <lapicstartap>:
{
80102356:	55                   	push   %ebp
80102357:	89 e5                	mov    %esp,%ebp
80102359:	57                   	push   %edi
8010235a:	56                   	push   %esi
8010235b:	53                   	push   %ebx
8010235c:	83 ec 0c             	sub    $0xc,%esp
8010235f:	8b 75 08             	mov    0x8(%ebp),%esi
80102362:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102365:	b0 0f                	mov    $0xf,%al
80102367:	ba 70 00 00 00       	mov    $0x70,%edx
8010236c:	ee                   	out    %al,(%dx)
8010236d:	b0 0a                	mov    $0xa,%al
8010236f:	ba 71 00 00 00       	mov    $0x71,%edx
80102374:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102375:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010237c:	00 00 
  wrv[1] = addr >> 4;
8010237e:	89 f8                	mov    %edi,%eax
80102380:	c1 e8 04             	shr    $0x4,%eax
80102383:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
80102389:	c1 e6 18             	shl    $0x18,%esi
8010238c:	89 f2                	mov    %esi,%edx
8010238e:	b8 c4 00 00 00       	mov    $0xc4,%eax
80102393:	e8 fb fd ff ff       	call   80102193 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
80102398:	ba 00 c5 00 00       	mov    $0xc500,%edx
8010239d:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023a2:	e8 ec fd ff ff       	call   80102193 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801023a7:	ba 00 85 00 00       	mov    $0x8500,%edx
801023ac:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023b1:	e8 dd fd ff ff       	call   80102193 <lapicw>
  for(i = 0; i < 2; i++){
801023b6:	bb 00 00 00 00       	mov    $0x0,%ebx
801023bb:	eb 1f                	jmp    801023dc <lapicstartap+0x86>
    lapicw(ICRHI, apicid<<24);
801023bd:	89 f2                	mov    %esi,%edx
801023bf:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023c4:	e8 ca fd ff ff       	call   80102193 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801023c9:	89 fa                	mov    %edi,%edx
801023cb:	c1 ea 0c             	shr    $0xc,%edx
801023ce:	80 ce 06             	or     $0x6,%dh
801023d1:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023d6:	e8 b8 fd ff ff       	call   80102193 <lapicw>
  for(i = 0; i < 2; i++){
801023db:	43                   	inc    %ebx
801023dc:	83 fb 01             	cmp    $0x1,%ebx
801023df:	7e dc                	jle    801023bd <lapicstartap+0x67>
}
801023e1:	83 c4 0c             	add    $0xc,%esp
801023e4:	5b                   	pop    %ebx
801023e5:	5e                   	pop    %esi
801023e6:	5f                   	pop    %edi
801023e7:	5d                   	pop    %ebp
801023e8:	c3                   	ret    

801023e9 <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801023e9:	55                   	push   %ebp
801023ea:	89 e5                	mov    %esp,%ebp
801023ec:	57                   	push   %edi
801023ed:	56                   	push   %esi
801023ee:	53                   	push   %ebx
801023ef:	83 ec 3c             	sub    $0x3c,%esp
801023f2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
801023f5:	b8 0b 00 00 00       	mov    $0xb,%eax
801023fa:	e8 a8 fd ff ff       	call   801021a7 <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
801023ff:	83 e0 04             	and    $0x4,%eax
80102402:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
80102404:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102407:	e8 ab fd ff ff       	call   801021b7 <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
8010240c:	b8 0a 00 00 00       	mov    $0xa,%eax
80102411:	e8 91 fd ff ff       	call   801021a7 <cmos_read>
80102416:	a8 80                	test   $0x80,%al
80102418:	75 ea                	jne    80102404 <cmostime+0x1b>
        continue;
    fill_rtcdate(&t2);
8010241a:	8d 75 b8             	lea    -0x48(%ebp),%esi
8010241d:	89 f0                	mov    %esi,%eax
8010241f:	e8 93 fd ff ff       	call   801021b7 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102424:	83 ec 04             	sub    $0x4,%esp
80102427:	6a 18                	push   $0x18
80102429:	56                   	push   %esi
8010242a:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010242d:	50                   	push   %eax
8010242e:	e8 ac 19 00 00       	call   80103ddf <memcmp>
80102433:	83 c4 10             	add    $0x10,%esp
80102436:	85 c0                	test   %eax,%eax
80102438:	75 ca                	jne    80102404 <cmostime+0x1b>
      break;
  }

  // convert
  if(bcd) {
8010243a:	85 ff                	test   %edi,%edi
8010243c:	75 7e                	jne    801024bc <cmostime+0xd3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
8010243e:	8b 55 d0             	mov    -0x30(%ebp),%edx
80102441:	89 d0                	mov    %edx,%eax
80102443:	c1 e8 04             	shr    $0x4,%eax
80102446:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102449:	01 c0                	add    %eax,%eax
8010244b:	83 e2 0f             	and    $0xf,%edx
8010244e:	01 d0                	add    %edx,%eax
80102450:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102453:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80102456:	89 d0                	mov    %edx,%eax
80102458:	c1 e8 04             	shr    $0x4,%eax
8010245b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010245e:	01 c0                	add    %eax,%eax
80102460:	83 e2 0f             	and    $0xf,%edx
80102463:	01 d0                	add    %edx,%eax
80102465:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
80102468:	8b 55 d8             	mov    -0x28(%ebp),%edx
8010246b:	89 d0                	mov    %edx,%eax
8010246d:	c1 e8 04             	shr    $0x4,%eax
80102470:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102473:	01 c0                	add    %eax,%eax
80102475:	83 e2 0f             	and    $0xf,%edx
80102478:	01 d0                	add    %edx,%eax
8010247a:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
8010247d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80102480:	89 d0                	mov    %edx,%eax
80102482:	c1 e8 04             	shr    $0x4,%eax
80102485:	8d 04 80             	lea    (%eax,%eax,4),%eax
80102488:	01 c0                	add    %eax,%eax
8010248a:	83 e2 0f             	and    $0xf,%edx
8010248d:	01 d0                	add    %edx,%eax
8010248f:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
80102492:	8b 55 e0             	mov    -0x20(%ebp),%edx
80102495:	89 d0                	mov    %edx,%eax
80102497:	c1 e8 04             	shr    $0x4,%eax
8010249a:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010249d:	01 c0                	add    %eax,%eax
8010249f:	83 e2 0f             	and    $0xf,%edx
801024a2:	01 d0                	add    %edx,%eax
801024a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801024a7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801024aa:	89 d0                	mov    %edx,%eax
801024ac:	c1 e8 04             	shr    $0x4,%eax
801024af:	8d 04 80             	lea    (%eax,%eax,4),%eax
801024b2:	01 c0                	add    %eax,%eax
801024b4:	83 e2 0f             	and    $0xf,%edx
801024b7:	01 d0                	add    %edx,%eax
801024b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801024bc:	8d 75 d0             	lea    -0x30(%ebp),%esi
801024bf:	b9 06 00 00 00       	mov    $0x6,%ecx
801024c4:	89 df                	mov    %ebx,%edi
801024c6:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  r->year += 2000;
801024c8:	8b 43 14             	mov    0x14(%ebx),%eax
801024cb:	05 d0 07 00 00       	add    $0x7d0,%eax
801024d0:	89 43 14             	mov    %eax,0x14(%ebx)
}
801024d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801024d6:	5b                   	pop    %ebx
801024d7:	5e                   	pop    %esi
801024d8:	5f                   	pop    %edi
801024d9:	5d                   	pop    %ebp
801024da:	c3                   	ret    

801024db <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801024db:	55                   	push   %ebp
801024dc:	89 e5                	mov    %esp,%ebp
801024de:	53                   	push   %ebx
801024df:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801024e2:	ff 35 d4 16 11 80    	pushl  0x801116d4
801024e8:	ff 35 e4 16 11 80    	pushl  0x801116e4
801024ee:	e8 77 dc ff ff       	call   8010016a <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
801024f3:	8b 58 5c             	mov    0x5c(%eax),%ebx
801024f6:	89 1d e8 16 11 80    	mov    %ebx,0x801116e8
  for (i = 0; i < log.lh.n; i++) {
801024fc:	83 c4 10             	add    $0x10,%esp
801024ff:	ba 00 00 00 00       	mov    $0x0,%edx
80102504:	eb 0c                	jmp    80102512 <read_head+0x37>
    log.lh.block[i] = lh->block[i];
80102506:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
8010250a:	89 0c 95 ec 16 11 80 	mov    %ecx,-0x7feee914(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102511:	42                   	inc    %edx
80102512:	39 d3                	cmp    %edx,%ebx
80102514:	7f f0                	jg     80102506 <read_head+0x2b>
  }
  brelse(buf);
80102516:	83 ec 0c             	sub    $0xc,%esp
80102519:	50                   	push   %eax
8010251a:	e8 b8 dc ff ff       	call   801001d7 <brelse>
}
8010251f:	83 c4 10             	add    $0x10,%esp
80102522:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102525:	c9                   	leave  
80102526:	c3                   	ret    

80102527 <install_trans>:
{
80102527:	55                   	push   %ebp
80102528:	89 e5                	mov    %esp,%ebp
8010252a:	57                   	push   %edi
8010252b:	56                   	push   %esi
8010252c:	53                   	push   %ebx
8010252d:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102530:	be 00 00 00 00       	mov    $0x0,%esi
80102535:	eb 62                	jmp    80102599 <install_trans+0x72>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102537:	89 f0                	mov    %esi,%eax
80102539:	03 05 d4 16 11 80    	add    0x801116d4,%eax
8010253f:	40                   	inc    %eax
80102540:	83 ec 08             	sub    $0x8,%esp
80102543:	50                   	push   %eax
80102544:	ff 35 e4 16 11 80    	pushl  0x801116e4
8010254a:	e8 1b dc ff ff       	call   8010016a <bread>
8010254f:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102551:	83 c4 08             	add    $0x8,%esp
80102554:	ff 34 b5 ec 16 11 80 	pushl  -0x7feee914(,%esi,4)
8010255b:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102561:	e8 04 dc ff ff       	call   8010016a <bread>
80102566:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102568:	8d 57 5c             	lea    0x5c(%edi),%edx
8010256b:	8d 40 5c             	lea    0x5c(%eax),%eax
8010256e:	83 c4 0c             	add    $0xc,%esp
80102571:	68 00 02 00 00       	push   $0x200
80102576:	52                   	push   %edx
80102577:	50                   	push   %eax
80102578:	e8 91 18 00 00       	call   80103e0e <memmove>
    bwrite(dbuf);  // write dst to disk
8010257d:	89 1c 24             	mov    %ebx,(%esp)
80102580:	e8 13 dc ff ff       	call   80100198 <bwrite>
    brelse(lbuf);
80102585:	89 3c 24             	mov    %edi,(%esp)
80102588:	e8 4a dc ff ff       	call   801001d7 <brelse>
    brelse(dbuf);
8010258d:	89 1c 24             	mov    %ebx,(%esp)
80102590:	e8 42 dc ff ff       	call   801001d7 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102595:	46                   	inc    %esi
80102596:	83 c4 10             	add    $0x10,%esp
80102599:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
8010259f:	7f 96                	jg     80102537 <install_trans+0x10>
}
801025a1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025a4:	5b                   	pop    %ebx
801025a5:	5e                   	pop    %esi
801025a6:	5f                   	pop    %edi
801025a7:	5d                   	pop    %ebp
801025a8:	c3                   	ret    

801025a9 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801025a9:	55                   	push   %ebp
801025aa:	89 e5                	mov    %esp,%ebp
801025ac:	53                   	push   %ebx
801025ad:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801025b0:	ff 35 d4 16 11 80    	pushl  0x801116d4
801025b6:	ff 35 e4 16 11 80    	pushl  0x801116e4
801025bc:	e8 a9 db ff ff       	call   8010016a <bread>
801025c1:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801025c3:	8b 0d e8 16 11 80    	mov    0x801116e8,%ecx
801025c9:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801025cc:	83 c4 10             	add    $0x10,%esp
801025cf:	b8 00 00 00 00       	mov    $0x0,%eax
801025d4:	eb 0c                	jmp    801025e2 <write_head+0x39>
    hb->block[i] = log.lh.block[i];
801025d6:	8b 14 85 ec 16 11 80 	mov    -0x7feee914(,%eax,4),%edx
801025dd:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
801025e1:	40                   	inc    %eax
801025e2:	39 c1                	cmp    %eax,%ecx
801025e4:	7f f0                	jg     801025d6 <write_head+0x2d>
  }
  bwrite(buf);
801025e6:	83 ec 0c             	sub    $0xc,%esp
801025e9:	53                   	push   %ebx
801025ea:	e8 a9 db ff ff       	call   80100198 <bwrite>
  brelse(buf);
801025ef:	89 1c 24             	mov    %ebx,(%esp)
801025f2:	e8 e0 db ff ff       	call   801001d7 <brelse>
}
801025f7:	83 c4 10             	add    $0x10,%esp
801025fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025fd:	c9                   	leave  
801025fe:	c3                   	ret    

801025ff <recover_from_log>:

static void
recover_from_log(void)
{
801025ff:	55                   	push   %ebp
80102600:	89 e5                	mov    %esp,%ebp
80102602:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102605:	e8 d1 fe ff ff       	call   801024db <read_head>
  install_trans(); // if committed, copy from log to disk
8010260a:	e8 18 ff ff ff       	call   80102527 <install_trans>
  log.lh.n = 0;
8010260f:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
80102616:	00 00 00 
  write_head(); // clear the log
80102619:	e8 8b ff ff ff       	call   801025a9 <write_head>
}
8010261e:	c9                   	leave  
8010261f:	c3                   	ret    

80102620 <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
80102620:	55                   	push   %ebp
80102621:	89 e5                	mov    %esp,%ebp
80102623:	57                   	push   %edi
80102624:	56                   	push   %esi
80102625:	53                   	push   %ebx
80102626:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102629:	be 00 00 00 00       	mov    $0x0,%esi
8010262e:	eb 62                	jmp    80102692 <write_log+0x72>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102630:	89 f0                	mov    %esi,%eax
80102632:	03 05 d4 16 11 80    	add    0x801116d4,%eax
80102638:	40                   	inc    %eax
80102639:	83 ec 08             	sub    $0x8,%esp
8010263c:	50                   	push   %eax
8010263d:	ff 35 e4 16 11 80    	pushl  0x801116e4
80102643:	e8 22 db ff ff       	call   8010016a <bread>
80102648:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010264a:	83 c4 08             	add    $0x8,%esp
8010264d:	ff 34 b5 ec 16 11 80 	pushl  -0x7feee914(,%esi,4)
80102654:	ff 35 e4 16 11 80    	pushl  0x801116e4
8010265a:	e8 0b db ff ff       	call   8010016a <bread>
8010265f:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102661:	8d 50 5c             	lea    0x5c(%eax),%edx
80102664:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102667:	83 c4 0c             	add    $0xc,%esp
8010266a:	68 00 02 00 00       	push   $0x200
8010266f:	52                   	push   %edx
80102670:	50                   	push   %eax
80102671:	e8 98 17 00 00       	call   80103e0e <memmove>
    bwrite(to);  // write the log
80102676:	89 1c 24             	mov    %ebx,(%esp)
80102679:	e8 1a db ff ff       	call   80100198 <bwrite>
    brelse(from);
8010267e:	89 3c 24             	mov    %edi,(%esp)
80102681:	e8 51 db ff ff       	call   801001d7 <brelse>
    brelse(to);
80102686:	89 1c 24             	mov    %ebx,(%esp)
80102689:	e8 49 db ff ff       	call   801001d7 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
8010268e:	46                   	inc    %esi
8010268f:	83 c4 10             	add    $0x10,%esp
80102692:	39 35 e8 16 11 80    	cmp    %esi,0x801116e8
80102698:	7f 96                	jg     80102630 <write_log+0x10>
  }
}
8010269a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010269d:	5b                   	pop    %ebx
8010269e:	5e                   	pop    %esi
8010269f:	5f                   	pop    %edi
801026a0:	5d                   	pop    %ebp
801026a1:	c3                   	ret    

801026a2 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
801026a2:	83 3d e8 16 11 80 00 	cmpl   $0x0,0x801116e8
801026a9:	7f 01                	jg     801026ac <commit+0xa>
801026ab:	c3                   	ret    
{
801026ac:	55                   	push   %ebp
801026ad:	89 e5                	mov    %esp,%ebp
801026af:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
801026b2:	e8 69 ff ff ff       	call   80102620 <write_log>
    write_head();    // Write header to disk -- the real commit
801026b7:	e8 ed fe ff ff       	call   801025a9 <write_head>
    install_trans(); // Now install writes to home locations
801026bc:	e8 66 fe ff ff       	call   80102527 <install_trans>
    log.lh.n = 0;
801026c1:	c7 05 e8 16 11 80 00 	movl   $0x0,0x801116e8
801026c8:	00 00 00 
    write_head();    // Erase the transaction from the log
801026cb:	e8 d9 fe ff ff       	call   801025a9 <write_head>
  }
}
801026d0:	c9                   	leave  
801026d1:	c3                   	ret    

801026d2 <initlog>:
{
801026d2:	55                   	push   %ebp
801026d3:	89 e5                	mov    %esp,%ebp
801026d5:	53                   	push   %ebx
801026d6:	83 ec 2c             	sub    $0x2c,%esp
801026d9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
801026dc:	68 a0 6c 10 80       	push   $0x80106ca0
801026e1:	68 a0 16 11 80       	push   $0x801116a0
801026e6:	e8 c1 14 00 00       	call   80103bac <initlock>
  readsb(dev, &sb);
801026eb:	83 c4 08             	add    $0x8,%esp
801026ee:	8d 45 dc             	lea    -0x24(%ebp),%eax
801026f1:	50                   	push   %eax
801026f2:	53                   	push   %ebx
801026f3:	e8 80 eb ff ff       	call   80101278 <readsb>
  log.start = sb.logstart;
801026f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
801026fb:	a3 d4 16 11 80       	mov    %eax,0x801116d4
  log.size = sb.nlog;
80102700:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102703:	a3 d8 16 11 80       	mov    %eax,0x801116d8
  log.dev = dev;
80102708:	89 1d e4 16 11 80    	mov    %ebx,0x801116e4
  recover_from_log();
8010270e:	e8 ec fe ff ff       	call   801025ff <recover_from_log>
}
80102713:	83 c4 10             	add    $0x10,%esp
80102716:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102719:	c9                   	leave  
8010271a:	c3                   	ret    

8010271b <begin_op>:
{
8010271b:	55                   	push   %ebp
8010271c:	89 e5                	mov    %esp,%ebp
8010271e:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102721:	68 a0 16 11 80       	push   $0x801116a0
80102726:	e8 c1 15 00 00       	call   80103cec <acquire>
8010272b:	83 c4 10             	add    $0x10,%esp
8010272e:	eb 15                	jmp    80102745 <begin_op+0x2a>
      sleep(&log, &log.lock);
80102730:	83 ec 08             	sub    $0x8,%esp
80102733:	68 a0 16 11 80       	push   $0x801116a0
80102738:	68 a0 16 11 80       	push   $0x801116a0
8010273d:	e8 00 0e 00 00       	call   80103542 <sleep>
80102742:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102745:	83 3d e0 16 11 80 00 	cmpl   $0x0,0x801116e0
8010274c:	75 e2                	jne    80102730 <begin_op+0x15>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
8010274e:	a1 dc 16 11 80       	mov    0x801116dc,%eax
80102753:	8d 48 01             	lea    0x1(%eax),%ecx
80102756:	8d 54 80 05          	lea    0x5(%eax,%eax,4),%edx
8010275a:	8d 04 12             	lea    (%edx,%edx,1),%eax
8010275d:	03 05 e8 16 11 80    	add    0x801116e8,%eax
80102763:	83 f8 1e             	cmp    $0x1e,%eax
80102766:	7e 17                	jle    8010277f <begin_op+0x64>
      sleep(&log, &log.lock);
80102768:	83 ec 08             	sub    $0x8,%esp
8010276b:	68 a0 16 11 80       	push   $0x801116a0
80102770:	68 a0 16 11 80       	push   $0x801116a0
80102775:	e8 c8 0d 00 00       	call   80103542 <sleep>
8010277a:	83 c4 10             	add    $0x10,%esp
8010277d:	eb c6                	jmp    80102745 <begin_op+0x2a>
      log.outstanding += 1;
8010277f:	89 0d dc 16 11 80    	mov    %ecx,0x801116dc
      release(&log.lock);
80102785:	83 ec 0c             	sub    $0xc,%esp
80102788:	68 a0 16 11 80       	push   $0x801116a0
8010278d:	e8 bf 15 00 00       	call   80103d51 <release>
}
80102792:	83 c4 10             	add    $0x10,%esp
80102795:	c9                   	leave  
80102796:	c3                   	ret    

80102797 <end_op>:
{
80102797:	55                   	push   %ebp
80102798:	89 e5                	mov    %esp,%ebp
8010279a:	53                   	push   %ebx
8010279b:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
8010279e:	68 a0 16 11 80       	push   $0x801116a0
801027a3:	e8 44 15 00 00       	call   80103cec <acquire>
  log.outstanding -= 1;
801027a8:	a1 dc 16 11 80       	mov    0x801116dc,%eax
801027ad:	48                   	dec    %eax
801027ae:	a3 dc 16 11 80       	mov    %eax,0x801116dc
  if(log.committing)
801027b3:	8b 1d e0 16 11 80    	mov    0x801116e0,%ebx
801027b9:	83 c4 10             	add    $0x10,%esp
801027bc:	85 db                	test   %ebx,%ebx
801027be:	75 2c                	jne    801027ec <end_op+0x55>
  if(log.outstanding == 0){
801027c0:	85 c0                	test   %eax,%eax
801027c2:	75 35                	jne    801027f9 <end_op+0x62>
    log.committing = 1;
801027c4:	c7 05 e0 16 11 80 01 	movl   $0x1,0x801116e0
801027cb:	00 00 00 
    do_commit = 1;
801027ce:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
801027d3:	83 ec 0c             	sub    $0xc,%esp
801027d6:	68 a0 16 11 80       	push   $0x801116a0
801027db:	e8 71 15 00 00       	call   80103d51 <release>
  if(do_commit){
801027e0:	83 c4 10             	add    $0x10,%esp
801027e3:	85 db                	test   %ebx,%ebx
801027e5:	75 24                	jne    8010280b <end_op+0x74>
}
801027e7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801027ea:	c9                   	leave  
801027eb:	c3                   	ret    
    panic("log.committing");
801027ec:	83 ec 0c             	sub    $0xc,%esp
801027ef:	68 a4 6c 10 80       	push   $0x80106ca4
801027f4:	e8 4b db ff ff       	call   80100344 <panic>
    wakeup(&log);
801027f9:	83 ec 0c             	sub    $0xc,%esp
801027fc:	68 a0 16 11 80       	push   $0x801116a0
80102801:	e8 a4 0e 00 00       	call   801036aa <wakeup>
80102806:	83 c4 10             	add    $0x10,%esp
80102809:	eb c8                	jmp    801027d3 <end_op+0x3c>
    commit();
8010280b:	e8 92 fe ff ff       	call   801026a2 <commit>
    acquire(&log.lock);
80102810:	83 ec 0c             	sub    $0xc,%esp
80102813:	68 a0 16 11 80       	push   $0x801116a0
80102818:	e8 cf 14 00 00       	call   80103cec <acquire>
    log.committing = 0;
8010281d:	c7 05 e0 16 11 80 00 	movl   $0x0,0x801116e0
80102824:	00 00 00 
    wakeup(&log);
80102827:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010282e:	e8 77 0e 00 00       	call   801036aa <wakeup>
    release(&log.lock);
80102833:	c7 04 24 a0 16 11 80 	movl   $0x801116a0,(%esp)
8010283a:	e8 12 15 00 00       	call   80103d51 <release>
8010283f:	83 c4 10             	add    $0x10,%esp
}
80102842:	eb a3                	jmp    801027e7 <end_op+0x50>

80102844 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102844:	55                   	push   %ebp
80102845:	89 e5                	mov    %esp,%ebp
80102847:	53                   	push   %ebx
80102848:	83 ec 04             	sub    $0x4,%esp
8010284b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010284e:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
80102854:	83 fa 1d             	cmp    $0x1d,%edx
80102857:	7f 2a                	jg     80102883 <log_write+0x3f>
80102859:	a1 d8 16 11 80       	mov    0x801116d8,%eax
8010285e:	48                   	dec    %eax
8010285f:	39 c2                	cmp    %eax,%edx
80102861:	7d 20                	jge    80102883 <log_write+0x3f>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102863:	83 3d dc 16 11 80 00 	cmpl   $0x0,0x801116dc
8010286a:	7e 24                	jle    80102890 <log_write+0x4c>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010286c:	83 ec 0c             	sub    $0xc,%esp
8010286f:	68 a0 16 11 80       	push   $0x801116a0
80102874:	e8 73 14 00 00       	call   80103cec <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102879:	83 c4 10             	add    $0x10,%esp
8010287c:	b8 00 00 00 00       	mov    $0x0,%eax
80102881:	eb 1b                	jmp    8010289e <log_write+0x5a>
    panic("too big a transaction");
80102883:	83 ec 0c             	sub    $0xc,%esp
80102886:	68 b3 6c 10 80       	push   $0x80106cb3
8010288b:	e8 b4 da ff ff       	call   80100344 <panic>
    panic("log_write outside of trans");
80102890:	83 ec 0c             	sub    $0xc,%esp
80102893:	68 c9 6c 10 80       	push   $0x80106cc9
80102898:	e8 a7 da ff ff       	call   80100344 <panic>
  for (i = 0; i < log.lh.n; i++) {
8010289d:	40                   	inc    %eax
8010289e:	8b 15 e8 16 11 80    	mov    0x801116e8,%edx
801028a4:	39 c2                	cmp    %eax,%edx
801028a6:	7e 0c                	jle    801028b4 <log_write+0x70>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801028a8:	8b 4b 08             	mov    0x8(%ebx),%ecx
801028ab:	39 0c 85 ec 16 11 80 	cmp    %ecx,-0x7feee914(,%eax,4)
801028b2:	75 e9                	jne    8010289d <log_write+0x59>
      break;
  }
  log.lh.block[i] = b->blockno;
801028b4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801028b7:	89 0c 85 ec 16 11 80 	mov    %ecx,-0x7feee914(,%eax,4)
  if (i == log.lh.n)
801028be:	39 c2                	cmp    %eax,%edx
801028c0:	74 1c                	je     801028de <log_write+0x9a>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
801028c2:	8b 03                	mov    (%ebx),%eax
801028c4:	83 c8 04             	or     $0x4,%eax
801028c7:	89 03                	mov    %eax,(%ebx)
  release(&log.lock);
801028c9:	83 ec 0c             	sub    $0xc,%esp
801028cc:	68 a0 16 11 80       	push   $0x801116a0
801028d1:	e8 7b 14 00 00       	call   80103d51 <release>
}
801028d6:	83 c4 10             	add    $0x10,%esp
801028d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801028dc:	c9                   	leave  
801028dd:	c3                   	ret    
    log.lh.n++;
801028de:	42                   	inc    %edx
801028df:	89 15 e8 16 11 80    	mov    %edx,0x801116e8
801028e5:	eb db                	jmp    801028c2 <log_write+0x7e>

801028e7 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
801028e7:	55                   	push   %ebp
801028e8:	89 e5                	mov    %esp,%ebp
801028ea:	53                   	push   %ebx
801028eb:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
801028ee:	68 8a 00 00 00       	push   $0x8a
801028f3:	68 8c a4 10 80       	push   $0x8010a48c
801028f8:	68 00 70 00 80       	push   $0x80007000
801028fd:	e8 0c 15 00 00       	call   80103e0e <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102902:	83 c4 10             	add    $0x10,%esp
80102905:	bb a0 17 11 80       	mov    $0x801117a0,%ebx
8010290a:	eb 06                	jmp    80102912 <startothers+0x2b>
8010290c:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102912:	8b 15 84 17 11 80    	mov    0x80111784,%edx
80102918:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010291b:	01 c0                	add    %eax,%eax
8010291d:	01 d0                	add    %edx,%eax
8010291f:	c1 e0 04             	shl    $0x4,%eax
80102922:	05 a0 17 11 80       	add    $0x801117a0,%eax
80102927:	39 c3                	cmp    %eax,%ebx
80102929:	73 4c                	jae    80102977 <startothers+0x90>
    if(c == mycpu())  // We've started already.
8010292b:	e8 a2 07 00 00       	call   801030d2 <mycpu>
80102930:	39 c3                	cmp    %eax,%ebx
80102932:	74 d8                	je     8010290c <startothers+0x25>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102934:	e8 29 f7 ff ff       	call   80102062 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102939:	05 00 10 00 00       	add    $0x1000,%eax
8010293e:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102943:	c7 05 f8 6f 00 80 bb 	movl   $0x801029bb,0x80006ff8
8010294a:	29 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
8010294d:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102954:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102957:	83 ec 08             	sub    $0x8,%esp
8010295a:	68 00 70 00 00       	push   $0x7000
8010295f:	0f b6 03             	movzbl (%ebx),%eax
80102962:	50                   	push   %eax
80102963:	e8 ee f9 ff ff       	call   80102356 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102968:	83 c4 10             	add    $0x10,%esp
8010296b:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102971:	85 c0                	test   %eax,%eax
80102973:	74 f6                	je     8010296b <startothers+0x84>
80102975:	eb 95                	jmp    8010290c <startothers+0x25>
      ;
  }
}
80102977:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010297a:	c9                   	leave  
8010297b:	c3                   	ret    

8010297c <mpmain>:
{
8010297c:	55                   	push   %ebp
8010297d:	89 e5                	mov    %esp,%ebp
8010297f:	53                   	push   %ebx
80102980:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102983:	e8 ae 07 00 00       	call   80103136 <cpuid>
80102988:	89 c3                	mov    %eax,%ebx
8010298a:	e8 a7 07 00 00       	call   80103136 <cpuid>
8010298f:	83 ec 04             	sub    $0x4,%esp
80102992:	53                   	push   %ebx
80102993:	50                   	push   %eax
80102994:	68 e4 6c 10 80       	push   $0x80106ce4
80102999:	e8 41 dc ff ff       	call   801005df <cprintf>
  idtinit();       // load idt register
8010299e:	e8 4f 26 00 00       	call   80104ff2 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801029a3:	e8 2a 07 00 00       	call   801030d2 <mycpu>
801029a8:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801029aa:	b8 01 00 00 00       	mov    $0x1,%eax
801029af:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801029b6:	e8 25 0a 00 00       	call   801033e0 <scheduler>

801029bb <mpenter>:
{
801029bb:	55                   	push   %ebp
801029bc:	89 e5                	mov    %esp,%ebp
801029be:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801029c1:	e8 9c 37 00 00       	call   80106162 <switchkvm>
  seginit();
801029c6:	e8 c7 34 00 00       	call   80105e92 <seginit>
  lapicinit();
801029cb:	e8 42 f8 ff ff       	call   80102212 <lapicinit>
  mpmain();
801029d0:	e8 a7 ff ff ff       	call   8010297c <mpmain>

801029d5 <main>:
{
801029d5:	8d 4c 24 04          	lea    0x4(%esp),%ecx
801029d9:	83 e4 f0             	and    $0xfffffff0,%esp
801029dc:	ff 71 fc             	pushl  -0x4(%ecx)
801029df:	55                   	push   %ebp
801029e0:	89 e5                	mov    %esp,%ebp
801029e2:	51                   	push   %ecx
801029e3:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
801029e6:	68 00 00 40 80       	push   $0x80400000
801029eb:	68 d0 83 11 80       	push   $0x801183d0
801029f0:	e8 1b f6 ff ff       	call   80102010 <kinit1>
  kvmalloc();      // kernel page table
801029f5:	e8 25 3c 00 00       	call   8010661f <kvmalloc>
  mpinit();        // detect other processors
801029fa:	e8 b8 01 00 00       	call   80102bb7 <mpinit>
  lapicinit();     // interrupt controller
801029ff:	e8 0e f8 ff ff       	call   80102212 <lapicinit>
  seginit();       // segment descriptors
80102a04:	e8 89 34 00 00       	call   80105e92 <seginit>
  picinit();       // disable pic
80102a09:	e8 79 02 00 00       	call   80102c87 <picinit>
  ioapicinit();    // another interrupt controller
80102a0e:	e8 8b f4 ff ff       	call   80101e9e <ioapicinit>
  consoleinit();   // console hardware
80102a13:	e8 39 de ff ff       	call   80100851 <consoleinit>
  uartinit();      // serial port
80102a18:	e8 76 28 00 00       	call   80105293 <uartinit>
  pinit();         // process table
80102a1d:	e8 96 06 00 00       	call   801030b8 <pinit>
  tvinit();        // trap vectors
80102a22:	e8 ce 24 00 00       	call   80104ef5 <tvinit>
  binit();         // buffer cache
80102a27:	e8 c6 d6 ff ff       	call   801000f2 <binit>
  fileinit();      // file table
80102a2c:	e8 d5 e1 ff ff       	call   80100c06 <fileinit>
  ideinit();       // disk 
80102a31:	e8 79 f2 ff ff       	call   80101caf <ideinit>
  startothers();   // start other processors
80102a36:	e8 ac fe ff ff       	call   801028e7 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102a3b:	83 c4 08             	add    $0x8,%esp
80102a3e:	68 00 00 00 8e       	push   $0x8e000000
80102a43:	68 00 00 40 80       	push   $0x80400000
80102a48:	e8 f5 f5 ff ff       	call   80102042 <kinit2>
  userinit();      // first user process
80102a4d:	e8 38 07 00 00       	call   8010318a <userinit>
  mpmain();        // finish this processor's setup
80102a52:	e8 25 ff ff ff       	call   8010297c <mpmain>

80102a57 <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102a57:	55                   	push   %ebp
80102a58:	89 e5                	mov    %esp,%ebp
80102a5a:	56                   	push   %esi
80102a5b:	53                   	push   %ebx
80102a5c:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102a5e:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102a63:	b9 00 00 00 00       	mov    $0x0,%ecx
80102a68:	eb 07                	jmp    80102a71 <sum+0x1a>
    sum += addr[i];
80102a6a:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102a6e:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102a70:	41                   	inc    %ecx
80102a71:	39 d1                	cmp    %edx,%ecx
80102a73:	7c f5                	jl     80102a6a <sum+0x13>
  return sum;
}
80102a75:	5b                   	pop    %ebx
80102a76:	5e                   	pop    %esi
80102a77:	5d                   	pop    %ebp
80102a78:	c3                   	ret    

80102a79 <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102a79:	55                   	push   %ebp
80102a7a:	89 e5                	mov    %esp,%ebp
80102a7c:	56                   	push   %esi
80102a7d:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102a7e:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102a84:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102a86:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102a88:	eb 03                	jmp    80102a8d <mpsearch1+0x14>
80102a8a:	83 c3 10             	add    $0x10,%ebx
80102a8d:	39 f3                	cmp    %esi,%ebx
80102a8f:	73 29                	jae    80102aba <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102a91:	83 ec 04             	sub    $0x4,%esp
80102a94:	6a 04                	push   $0x4
80102a96:	68 f8 6c 10 80       	push   $0x80106cf8
80102a9b:	53                   	push   %ebx
80102a9c:	e8 3e 13 00 00       	call   80103ddf <memcmp>
80102aa1:	83 c4 10             	add    $0x10,%esp
80102aa4:	85 c0                	test   %eax,%eax
80102aa6:	75 e2                	jne    80102a8a <mpsearch1+0x11>
80102aa8:	ba 10 00 00 00       	mov    $0x10,%edx
80102aad:	89 d8                	mov    %ebx,%eax
80102aaf:	e8 a3 ff ff ff       	call   80102a57 <sum>
80102ab4:	84 c0                	test   %al,%al
80102ab6:	75 d2                	jne    80102a8a <mpsearch1+0x11>
80102ab8:	eb 05                	jmp    80102abf <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102aba:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102abf:	89 d8                	mov    %ebx,%eax
80102ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102ac4:	5b                   	pop    %ebx
80102ac5:	5e                   	pop    %esi
80102ac6:	5d                   	pop    %ebp
80102ac7:	c3                   	ret    

80102ac8 <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102ac8:	55                   	push   %ebp
80102ac9:	89 e5                	mov    %esp,%ebp
80102acb:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102ace:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102ad5:	c1 e0 08             	shl    $0x8,%eax
80102ad8:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102adf:	09 d0                	or     %edx,%eax
80102ae1:	c1 e0 04             	shl    $0x4,%eax
80102ae4:	74 1f                	je     80102b05 <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102ae6:	ba 00 04 00 00       	mov    $0x400,%edx
80102aeb:	e8 89 ff ff ff       	call   80102a79 <mpsearch1>
80102af0:	85 c0                	test   %eax,%eax
80102af2:	75 0f                	jne    80102b03 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102af4:	ba 00 00 01 00       	mov    $0x10000,%edx
80102af9:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102afe:	e8 76 ff ff ff       	call   80102a79 <mpsearch1>
}
80102b03:	c9                   	leave  
80102b04:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102b05:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102b0c:	c1 e0 08             	shl    $0x8,%eax
80102b0f:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102b16:	09 d0                	or     %edx,%eax
80102b18:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102b1b:	2d 00 04 00 00       	sub    $0x400,%eax
80102b20:	ba 00 04 00 00       	mov    $0x400,%edx
80102b25:	e8 4f ff ff ff       	call   80102a79 <mpsearch1>
80102b2a:	85 c0                	test   %eax,%eax
80102b2c:	75 d5                	jne    80102b03 <mpsearch+0x3b>
80102b2e:	eb c4                	jmp    80102af4 <mpsearch+0x2c>

80102b30 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102b30:	55                   	push   %ebp
80102b31:	89 e5                	mov    %esp,%ebp
80102b33:	57                   	push   %edi
80102b34:	56                   	push   %esi
80102b35:	53                   	push   %ebx
80102b36:	83 ec 1c             	sub    $0x1c,%esp
80102b39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102b3c:	e8 87 ff ff ff       	call   80102ac8 <mpsearch>
80102b41:	89 c3                	mov    %eax,%ebx
80102b43:	85 c0                	test   %eax,%eax
80102b45:	74 53                	je     80102b9a <mpconfig+0x6a>
80102b47:	8b 70 04             	mov    0x4(%eax),%esi
80102b4a:	85 f6                	test   %esi,%esi
80102b4c:	74 50                	je     80102b9e <mpconfig+0x6e>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102b4e:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102b54:	83 ec 04             	sub    $0x4,%esp
80102b57:	6a 04                	push   $0x4
80102b59:	68 fd 6c 10 80       	push   $0x80106cfd
80102b5e:	57                   	push   %edi
80102b5f:	e8 7b 12 00 00       	call   80103ddf <memcmp>
80102b64:	83 c4 10             	add    $0x10,%esp
80102b67:	85 c0                	test   %eax,%eax
80102b69:	75 37                	jne    80102ba2 <mpconfig+0x72>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102b6b:	8a 86 06 00 00 80    	mov    -0x7ffffffa(%esi),%al
80102b71:	3c 01                	cmp    $0x1,%al
80102b73:	74 04                	je     80102b79 <mpconfig+0x49>
80102b75:	3c 04                	cmp    $0x4,%al
80102b77:	75 30                	jne    80102ba9 <mpconfig+0x79>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102b79:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102b80:	89 f8                	mov    %edi,%eax
80102b82:	e8 d0 fe ff ff       	call   80102a57 <sum>
80102b87:	84 c0                	test   %al,%al
80102b89:	75 25                	jne    80102bb0 <mpconfig+0x80>
    return 0;
  *pmp = mp;
80102b8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102b8e:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102b90:	89 f8                	mov    %edi,%eax
80102b92:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102b95:	5b                   	pop    %ebx
80102b96:	5e                   	pop    %esi
80102b97:	5f                   	pop    %edi
80102b98:	5d                   	pop    %ebp
80102b99:	c3                   	ret    
    return 0;
80102b9a:	89 c7                	mov    %eax,%edi
80102b9c:	eb f2                	jmp    80102b90 <mpconfig+0x60>
80102b9e:	89 f7                	mov    %esi,%edi
80102ba0:	eb ee                	jmp    80102b90 <mpconfig+0x60>
    return 0;
80102ba2:	bf 00 00 00 00       	mov    $0x0,%edi
80102ba7:	eb e7                	jmp    80102b90 <mpconfig+0x60>
    return 0;
80102ba9:	bf 00 00 00 00       	mov    $0x0,%edi
80102bae:	eb e0                	jmp    80102b90 <mpconfig+0x60>
    return 0;
80102bb0:	bf 00 00 00 00       	mov    $0x0,%edi
80102bb5:	eb d9                	jmp    80102b90 <mpconfig+0x60>

80102bb7 <mpinit>:

void
mpinit(void)
{
80102bb7:	55                   	push   %ebp
80102bb8:	89 e5                	mov    %esp,%ebp
80102bba:	57                   	push   %edi
80102bbb:	56                   	push   %esi
80102bbc:	53                   	push   %ebx
80102bbd:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102bc0:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102bc3:	e8 68 ff ff ff       	call   80102b30 <mpconfig>
80102bc8:	85 c0                	test   %eax,%eax
80102bca:	74 19                	je     80102be5 <mpinit+0x2e>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102bcc:	8b 50 24             	mov    0x24(%eax),%edx
80102bcf:	89 15 80 16 11 80    	mov    %edx,0x80111680
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102bd5:	8d 50 2c             	lea    0x2c(%eax),%edx
80102bd8:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102bdc:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102bde:	bf 01 00 00 00       	mov    $0x1,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102be3:	eb 20                	jmp    80102c05 <mpinit+0x4e>
    panic("Expect to run on an SMP");
80102be5:	83 ec 0c             	sub    $0xc,%esp
80102be8:	68 02 6d 10 80       	push   $0x80106d02
80102bed:	e8 52 d7 ff ff       	call   80100344 <panic>
    switch(*p){
80102bf2:	bf 00 00 00 00       	mov    $0x0,%edi
80102bf7:	eb 0c                	jmp    80102c05 <mpinit+0x4e>
80102bf9:	83 e8 03             	sub    $0x3,%eax
80102bfc:	3c 01                	cmp    $0x1,%al
80102bfe:	76 19                	jbe    80102c19 <mpinit+0x62>
80102c00:	bf 00 00 00 00       	mov    $0x0,%edi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102c05:	39 ca                	cmp    %ecx,%edx
80102c07:	73 4a                	jae    80102c53 <mpinit+0x9c>
    switch(*p){
80102c09:	8a 02                	mov    (%edx),%al
80102c0b:	3c 02                	cmp    $0x2,%al
80102c0d:	74 37                	je     80102c46 <mpinit+0x8f>
80102c0f:	77 e8                	ja     80102bf9 <mpinit+0x42>
80102c11:	84 c0                	test   %al,%al
80102c13:	74 09                	je     80102c1e <mpinit+0x67>
80102c15:	3c 01                	cmp    $0x1,%al
80102c17:	75 d9                	jne    80102bf2 <mpinit+0x3b>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102c19:	83 c2 08             	add    $0x8,%edx
      continue;
80102c1c:	eb e7                	jmp    80102c05 <mpinit+0x4e>
      if(ncpu < NCPU) {
80102c1e:	a1 84 17 11 80       	mov    0x80111784,%eax
80102c23:	83 f8 07             	cmp    $0x7,%eax
80102c26:	7f 19                	jg     80102c41 <mpinit+0x8a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102c28:	8d 34 80             	lea    (%eax,%eax,4),%esi
80102c2b:	01 f6                	add    %esi,%esi
80102c2d:	01 c6                	add    %eax,%esi
80102c2f:	c1 e6 04             	shl    $0x4,%esi
80102c32:	8a 5a 01             	mov    0x1(%edx),%bl
80102c35:	88 9e a0 17 11 80    	mov    %bl,-0x7feee860(%esi)
        ncpu++;
80102c3b:	40                   	inc    %eax
80102c3c:	a3 84 17 11 80       	mov    %eax,0x80111784
      p += sizeof(struct mpproc);
80102c41:	83 c2 14             	add    $0x14,%edx
      continue;
80102c44:	eb bf                	jmp    80102c05 <mpinit+0x4e>
      ioapicid = ioapic->apicno;
80102c46:	8a 42 01             	mov    0x1(%edx),%al
80102c49:	a2 80 17 11 80       	mov    %al,0x80111780
      p += sizeof(struct mpioapic);
80102c4e:	83 c2 08             	add    $0x8,%edx
      continue;
80102c51:	eb b2                	jmp    80102c05 <mpinit+0x4e>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102c53:	85 ff                	test   %edi,%edi
80102c55:	74 23                	je     80102c7a <mpinit+0xc3>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102c57:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102c5a:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102c5e:	74 12                	je     80102c72 <mpinit+0xbb>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c60:	b0 70                	mov    $0x70,%al
80102c62:	ba 22 00 00 00       	mov    $0x22,%edx
80102c67:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102c68:	ba 23 00 00 00       	mov    $0x23,%edx
80102c6d:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102c6e:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102c71:	ee                   	out    %al,(%dx)
  }
}
80102c72:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c75:	5b                   	pop    %ebx
80102c76:	5e                   	pop    %esi
80102c77:	5f                   	pop    %edi
80102c78:	5d                   	pop    %ebp
80102c79:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102c7a:	83 ec 0c             	sub    $0xc,%esp
80102c7d:	68 1c 6d 10 80       	push   $0x80106d1c
80102c82:	e8 bd d6 ff ff       	call   80100344 <panic>

80102c87 <picinit>:
80102c87:	b0 ff                	mov    $0xff,%al
80102c89:	ba 21 00 00 00       	mov    $0x21,%edx
80102c8e:	ee                   	out    %al,(%dx)
80102c8f:	ba a1 00 00 00       	mov    $0xa1,%edx
80102c94:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102c95:	c3                   	ret    

80102c96 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102c96:	55                   	push   %ebp
80102c97:	89 e5                	mov    %esp,%ebp
80102c99:	57                   	push   %edi
80102c9a:	56                   	push   %esi
80102c9b:	53                   	push   %ebx
80102c9c:	83 ec 0c             	sub    $0xc,%esp
80102c9f:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102ca2:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102ca5:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102cab:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102cb1:	e8 6a df ff ff       	call   80100c20 <filealloc>
80102cb6:	89 03                	mov    %eax,(%ebx)
80102cb8:	85 c0                	test   %eax,%eax
80102cba:	0f 84 88 00 00 00    	je     80102d48 <pipealloc+0xb2>
80102cc0:	e8 5b df ff ff       	call   80100c20 <filealloc>
80102cc5:	89 06                	mov    %eax,(%esi)
80102cc7:	85 c0                	test   %eax,%eax
80102cc9:	74 7d                	je     80102d48 <pipealloc+0xb2>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102ccb:	e8 92 f3 ff ff       	call   80102062 <kalloc>
80102cd0:	89 c7                	mov    %eax,%edi
80102cd2:	85 c0                	test   %eax,%eax
80102cd4:	74 72                	je     80102d48 <pipealloc+0xb2>
    goto bad;
  p->readopen = 1;
80102cd6:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102cdd:	00 00 00 
  p->writeopen = 1;
80102ce0:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102ce7:	00 00 00 
  p->nwrite = 0;
80102cea:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102cf1:	00 00 00 
  p->nread = 0;
80102cf4:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102cfb:	00 00 00 
  initlock(&p->lock, "pipe");
80102cfe:	83 ec 08             	sub    $0x8,%esp
80102d01:	68 3b 6d 10 80       	push   $0x80106d3b
80102d06:	50                   	push   %eax
80102d07:	e8 a0 0e 00 00       	call   80103bac <initlock>
  (*f0)->type = FD_PIPE;
80102d0c:	8b 03                	mov    (%ebx),%eax
80102d0e:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102d14:	8b 03                	mov    (%ebx),%eax
80102d16:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102d1a:	8b 03                	mov    (%ebx),%eax
80102d1c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102d20:	8b 03                	mov    (%ebx),%eax
80102d22:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102d25:	8b 06                	mov    (%esi),%eax
80102d27:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102d2d:	8b 06                	mov    (%esi),%eax
80102d2f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102d33:	8b 06                	mov    (%esi),%eax
80102d35:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102d39:	8b 06                	mov    (%esi),%eax
80102d3b:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102d3e:	83 c4 10             	add    $0x10,%esp
80102d41:	b8 00 00 00 00       	mov    $0x0,%eax
80102d46:	eb 29                	jmp    80102d71 <pipealloc+0xdb>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102d48:	8b 03                	mov    (%ebx),%eax
80102d4a:	85 c0                	test   %eax,%eax
80102d4c:	74 0c                	je     80102d5a <pipealloc+0xc4>
    fileclose(*f0);
80102d4e:	83 ec 0c             	sub    $0xc,%esp
80102d51:	50                   	push   %eax
80102d52:	e8 6d df ff ff       	call   80100cc4 <fileclose>
80102d57:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102d5a:	8b 06                	mov    (%esi),%eax
80102d5c:	85 c0                	test   %eax,%eax
80102d5e:	74 19                	je     80102d79 <pipealloc+0xe3>
    fileclose(*f1);
80102d60:	83 ec 0c             	sub    $0xc,%esp
80102d63:	50                   	push   %eax
80102d64:	e8 5b df ff ff       	call   80100cc4 <fileclose>
80102d69:	83 c4 10             	add    $0x10,%esp
  return -1;
80102d6c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102d71:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d74:	5b                   	pop    %ebx
80102d75:	5e                   	pop    %esi
80102d76:	5f                   	pop    %edi
80102d77:	5d                   	pop    %ebp
80102d78:	c3                   	ret    
  return -1;
80102d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102d7e:	eb f1                	jmp    80102d71 <pipealloc+0xdb>

80102d80 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102d80:	55                   	push   %ebp
80102d81:	89 e5                	mov    %esp,%ebp
80102d83:	53                   	push   %ebx
80102d84:	83 ec 10             	sub    $0x10,%esp
80102d87:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102d8a:	53                   	push   %ebx
80102d8b:	e8 5c 0f 00 00       	call   80103cec <acquire>
  if(writable){
80102d90:	83 c4 10             	add    $0x10,%esp
80102d93:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102d97:	74 3f                	je     80102dd8 <pipeclose+0x58>
    p->writeopen = 0;
80102d99:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102da0:	00 00 00 
    wakeup(&p->nread);
80102da3:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102da9:	83 ec 0c             	sub    $0xc,%esp
80102dac:	50                   	push   %eax
80102dad:	e8 f8 08 00 00       	call   801036aa <wakeup>
80102db2:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102db5:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102dbc:	75 09                	jne    80102dc7 <pipeclose+0x47>
80102dbe:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102dc5:	74 2f                	je     80102df6 <pipeclose+0x76>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102dc7:	83 ec 0c             	sub    $0xc,%esp
80102dca:	53                   	push   %ebx
80102dcb:	e8 81 0f 00 00       	call   80103d51 <release>
80102dd0:	83 c4 10             	add    $0x10,%esp
}
80102dd3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dd6:	c9                   	leave  
80102dd7:	c3                   	ret    
    p->readopen = 0;
80102dd8:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102ddf:	00 00 00 
    wakeup(&p->nwrite);
80102de2:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102de8:	83 ec 0c             	sub    $0xc,%esp
80102deb:	50                   	push   %eax
80102dec:	e8 b9 08 00 00       	call   801036aa <wakeup>
80102df1:	83 c4 10             	add    $0x10,%esp
80102df4:	eb bf                	jmp    80102db5 <pipeclose+0x35>
    release(&p->lock);
80102df6:	83 ec 0c             	sub    $0xc,%esp
80102df9:	53                   	push   %ebx
80102dfa:	e8 52 0f 00 00       	call   80103d51 <release>
    kfree((char*)p);
80102dff:	89 1c 24             	mov    %ebx,(%esp)
80102e02:	e8 44 f1 ff ff       	call   80101f4b <kfree>
80102e07:	83 c4 10             	add    $0x10,%esp
80102e0a:	eb c7                	jmp    80102dd3 <pipeclose+0x53>

80102e0c <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102e0c:	55                   	push   %ebp
80102e0d:	89 e5                	mov    %esp,%ebp
80102e0f:	57                   	push   %edi
80102e10:	56                   	push   %esi
80102e11:	53                   	push   %ebx
80102e12:	83 ec 28             	sub    $0x28,%esp
80102e15:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e18:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  acquire(&p->lock);
80102e1b:	53                   	push   %ebx
80102e1c:	e8 cb 0e 00 00       	call   80103cec <acquire>
  for(i = 0; i < n; i++){
80102e21:	83 c4 10             	add    $0x10,%esp
80102e24:	bf 00 00 00 00       	mov    $0x0,%edi
80102e29:	39 f7                	cmp    %esi,%edi
80102e2b:	7c 40                	jl     80102e6d <pipewrite+0x61>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102e2d:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e33:	83 ec 0c             	sub    $0xc,%esp
80102e36:	50                   	push   %eax
80102e37:	e8 6e 08 00 00       	call   801036aa <wakeup>
  release(&p->lock);
80102e3c:	89 1c 24             	mov    %ebx,(%esp)
80102e3f:	e8 0d 0f 00 00       	call   80103d51 <release>
  return n;
80102e44:	83 c4 10             	add    $0x10,%esp
80102e47:	89 f0                	mov    %esi,%eax
80102e49:	eb 5c                	jmp    80102ea7 <pipewrite+0x9b>
      wakeup(&p->nread);
80102e4b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102e51:	83 ec 0c             	sub    $0xc,%esp
80102e54:	50                   	push   %eax
80102e55:	e8 50 08 00 00       	call   801036aa <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102e5a:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102e60:	83 c4 08             	add    $0x8,%esp
80102e63:	53                   	push   %ebx
80102e64:	50                   	push   %eax
80102e65:	e8 d8 06 00 00       	call   80103542 <sleep>
80102e6a:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102e6d:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102e73:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102e79:	05 00 02 00 00       	add    $0x200,%eax
80102e7e:	39 c2                	cmp    %eax,%edx
80102e80:	75 2d                	jne    80102eaf <pipewrite+0xa3>
      if(p->readopen == 0 || myproc()->killed){
80102e82:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102e89:	74 0b                	je     80102e96 <pipewrite+0x8a>
80102e8b:	e8 d7 02 00 00       	call   80103167 <myproc>
80102e90:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102e94:	74 b5                	je     80102e4b <pipewrite+0x3f>
        release(&p->lock);
80102e96:	83 ec 0c             	sub    $0xc,%esp
80102e99:	53                   	push   %ebx
80102e9a:	e8 b2 0e 00 00       	call   80103d51 <release>
        return -1;
80102e9f:	83 c4 10             	add    $0x10,%esp
80102ea2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ea7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102eaa:	5b                   	pop    %ebx
80102eab:	5e                   	pop    %esi
80102eac:	5f                   	pop    %edi
80102ead:	5d                   	pop    %ebp
80102eae:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80102eaf:	8d 42 01             	lea    0x1(%edx),%eax
80102eb2:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80102eb8:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80102ebe:	8b 45 0c             	mov    0xc(%ebp),%eax
80102ec1:	8a 04 38             	mov    (%eax,%edi,1),%al
80102ec4:	88 45 e7             	mov    %al,-0x19(%ebp)
80102ec7:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80102ecb:	47                   	inc    %edi
80102ecc:	e9 58 ff ff ff       	jmp    80102e29 <pipewrite+0x1d>

80102ed1 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80102ed1:	55                   	push   %ebp
80102ed2:	89 e5                	mov    %esp,%ebp
80102ed4:	57                   	push   %edi
80102ed5:	56                   	push   %esi
80102ed6:	53                   	push   %ebx
80102ed7:	83 ec 18             	sub    $0x18,%esp
80102eda:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102edd:	8b 7d 10             	mov    0x10(%ebp),%edi
  int i;

  acquire(&p->lock);
80102ee0:	53                   	push   %ebx
80102ee1:	e8 06 0e 00 00       	call   80103cec <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102ee6:	83 c4 10             	add    $0x10,%esp
80102ee9:	eb 13                	jmp    80102efe <piperead+0x2d>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80102eeb:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102ef1:	83 ec 08             	sub    $0x8,%esp
80102ef4:	53                   	push   %ebx
80102ef5:	50                   	push   %eax
80102ef6:	e8 47 06 00 00       	call   80103542 <sleep>
80102efb:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80102efe:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80102f04:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80102f0a:	75 77                	jne    80102f83 <piperead+0xb2>
80102f0c:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80102f12:	85 f6                	test   %esi,%esi
80102f14:	74 37                	je     80102f4d <piperead+0x7c>
    if(myproc()->killed){
80102f16:	e8 4c 02 00 00       	call   80103167 <myproc>
80102f1b:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102f1f:	74 ca                	je     80102eeb <piperead+0x1a>
      release(&p->lock);
80102f21:	83 ec 0c             	sub    $0xc,%esp
80102f24:	53                   	push   %ebx
80102f25:	e8 27 0e 00 00       	call   80103d51 <release>
      return -1;
80102f2a:	83 c4 10             	add    $0x10,%esp
80102f2d:	be ff ff ff ff       	mov    $0xffffffff,%esi
80102f32:	eb 45                	jmp    80102f79 <piperead+0xa8>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80102f34:	8d 50 01             	lea    0x1(%eax),%edx
80102f37:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
80102f3d:	25 ff 01 00 00       	and    $0x1ff,%eax
80102f42:	8a 44 03 34          	mov    0x34(%ebx,%eax,1),%al
80102f46:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102f49:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80102f4c:	46                   	inc    %esi
80102f4d:	39 fe                	cmp    %edi,%esi
80102f4f:	7d 0e                	jge    80102f5f <piperead+0x8e>
    if(p->nread == p->nwrite)
80102f51:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102f57:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80102f5d:	75 d5                	jne    80102f34 <piperead+0x63>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80102f5f:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f65:	83 ec 0c             	sub    $0xc,%esp
80102f68:	50                   	push   %eax
80102f69:	e8 3c 07 00 00       	call   801036aa <wakeup>
  release(&p->lock);
80102f6e:	89 1c 24             	mov    %ebx,(%esp)
80102f71:	e8 db 0d 00 00       	call   80103d51 <release>
  return i;
80102f76:	83 c4 10             	add    $0x10,%esp
}
80102f79:	89 f0                	mov    %esi,%eax
80102f7b:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f7e:	5b                   	pop    %ebx
80102f7f:	5e                   	pop    %esi
80102f80:	5f                   	pop    %edi
80102f81:	5d                   	pop    %ebp
80102f82:	c3                   	ret    
80102f83:	be 00 00 00 00       	mov    $0x0,%esi
80102f88:	eb c3                	jmp    80102f4d <piperead+0x7c>

80102f8a <wakeup1>:
static void
wakeup1(void *chan)
{
    struct proc *p;

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102f8a:	ba 54 49 11 80       	mov    $0x80114954,%edx
80102f8f:	eb 06                	jmp    80102f97 <wakeup1+0xd>
80102f91:	81 c2 88 00 00 00    	add    $0x88,%edx
80102f97:	81 fa 54 6b 11 80    	cmp    $0x80116b54,%edx
80102f9d:	73 14                	jae    80102fb3 <wakeup1+0x29>
        if (p->state == SLEEPING && p->chan == chan)
80102f9f:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80102fa3:	75 ec                	jne    80102f91 <wakeup1+0x7>
80102fa5:	39 42 20             	cmp    %eax,0x20(%edx)
80102fa8:	75 e7                	jne    80102f91 <wakeup1+0x7>
            p->state = RUNNABLE;
80102faa:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80102fb1:	eb de                	jmp    80102f91 <wakeup1+0x7>
}
80102fb3:	c3                   	ret    

80102fb4 <allocproc>:
{
80102fb4:	55                   	push   %ebp
80102fb5:	89 e5                	mov    %esp,%ebp
80102fb7:	53                   	push   %ebx
80102fb8:	83 ec 10             	sub    $0x10,%esp
    acquire(&ptable.lock);
80102fbb:	68 20 49 11 80       	push   $0x80114920
80102fc0:	e8 27 0d 00 00       	call   80103cec <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80102fc5:	83 c4 10             	add    $0x10,%esp
80102fc8:	bb 54 49 11 80       	mov    $0x80114954,%ebx
80102fcd:	eb 06                	jmp    80102fd5 <allocproc+0x21>
80102fcf:	81 c3 88 00 00 00    	add    $0x88,%ebx
80102fd5:	81 fb 54 6b 11 80    	cmp    $0x80116b54,%ebx
80102fdb:	73 76                	jae    80103053 <allocproc+0x9f>
        if (p->state == UNUSED)
80102fdd:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
80102fe1:	75 ec                	jne    80102fcf <allocproc+0x1b>
    p->state = EMBRYO;
80102fe3:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
    p->pid = nextpid++;
80102fea:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80102fef:	8d 50 01             	lea    0x1(%eax),%edx
80102ff2:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80102ff8:	89 43 10             	mov    %eax,0x10(%ebx)
    release(&ptable.lock);
80102ffb:	83 ec 0c             	sub    $0xc,%esp
80102ffe:	68 20 49 11 80       	push   $0x80114920
80103003:	e8 49 0d 00 00       	call   80103d51 <release>
    if ((p->kstack = kalloc()) == 0)
80103008:	e8 55 f0 ff ff       	call   80102062 <kalloc>
8010300d:	89 43 08             	mov    %eax,0x8(%ebx)
80103010:	83 c4 10             	add    $0x10,%esp
80103013:	85 c0                	test   %eax,%eax
80103015:	74 53                	je     8010306a <allocproc+0xb6>
    sp -= sizeof *p->tf;
80103017:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
    p->tf = (struct trapframe *)sp;
8010301d:	89 53 18             	mov    %edx,0x18(%ebx)
    *(uint *)sp = (uint)trapret;
80103020:	c7 80 b0 0f 00 00 ea 	movl   $0x80104eea,0xfb0(%eax)
80103027:	4e 10 80 
    sp -= sizeof *p->context;
8010302a:	05 9c 0f 00 00       	add    $0xf9c,%eax
    p->context = (struct context *)sp;
8010302f:	89 43 1c             	mov    %eax,0x1c(%ebx)
    memset(p->context, 0, sizeof *p->context);
80103032:	83 ec 04             	sub    $0x4,%esp
80103035:	6a 14                	push   $0x14
80103037:	6a 00                	push   $0x0
80103039:	50                   	push   %eax
8010303a:	e8 59 0d 00 00       	call   80103d98 <memset>
    p->context->eip = (uint)forkret;
8010303f:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103042:	c7 40 10 75 30 10 80 	movl   $0x80103075,0x10(%eax)
    return p;
80103049:	83 c4 10             	add    $0x10,%esp
}
8010304c:	89 d8                	mov    %ebx,%eax
8010304e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103051:	c9                   	leave  
80103052:	c3                   	ret    
    release(&ptable.lock);
80103053:	83 ec 0c             	sub    $0xc,%esp
80103056:	68 20 49 11 80       	push   $0x80114920
8010305b:	e8 f1 0c 00 00       	call   80103d51 <release>
    return 0;
80103060:	83 c4 10             	add    $0x10,%esp
80103063:	bb 00 00 00 00       	mov    $0x0,%ebx
80103068:	eb e2                	jmp    8010304c <allocproc+0x98>
        p->state = UNUSED;
8010306a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return 0;
80103071:	89 c3                	mov    %eax,%ebx
80103073:	eb d7                	jmp    8010304c <allocproc+0x98>

80103075 <forkret>:
{
80103075:	55                   	push   %ebp
80103076:	89 e5                	mov    %esp,%ebp
80103078:	83 ec 14             	sub    $0x14,%esp
    release(&ptable.lock);
8010307b:	68 20 49 11 80       	push   $0x80114920
80103080:	e8 cc 0c 00 00       	call   80103d51 <release>
    if (first)
80103085:	83 c4 10             	add    $0x10,%esp
80103088:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
8010308f:	75 02                	jne    80103093 <forkret+0x1e>
}
80103091:	c9                   	leave  
80103092:	c3                   	ret    
        first = 0;
80103093:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
8010309a:	00 00 00 
        iinit(ROOTDEV);
8010309d:	83 ec 0c             	sub    $0xc,%esp
801030a0:	6a 01                	push   $0x1
801030a2:	e8 05 e2 ff ff       	call   801012ac <iinit>
        initlog(ROOTDEV);
801030a7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801030ae:	e8 1f f6 ff ff       	call   801026d2 <initlog>
801030b3:	83 c4 10             	add    $0x10,%esp
}
801030b6:	eb d9                	jmp    80103091 <forkret+0x1c>

801030b8 <pinit>:
{
801030b8:	55                   	push   %ebp
801030b9:	89 e5                	mov    %esp,%ebp
801030bb:	83 ec 10             	sub    $0x10,%esp
    initlock(&ptable.lock, "ptable");
801030be:	68 40 6d 10 80       	push   $0x80106d40
801030c3:	68 20 49 11 80       	push   $0x80114920
801030c8:	e8 df 0a 00 00       	call   80103bac <initlock>
}
801030cd:	83 c4 10             	add    $0x10,%esp
801030d0:	c9                   	leave  
801030d1:	c3                   	ret    

801030d2 <mycpu>:
{
801030d2:	55                   	push   %ebp
801030d3:	89 e5                	mov    %esp,%ebp
801030d5:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801030d8:	9c                   	pushf  
801030d9:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801030da:	f6 c4 02             	test   $0x2,%ah
801030dd:	75 2c                	jne    8010310b <mycpu+0x39>
    apicid = lapicid();
801030df:	e8 3a f2 ff ff       	call   8010231e <lapicid>
801030e4:	89 c1                	mov    %eax,%ecx
    for (i = 0; i < ncpu; ++i)
801030e6:	ba 00 00 00 00       	mov    $0x0,%edx
801030eb:	39 15 84 17 11 80    	cmp    %edx,0x80111784
801030f1:	7e 25                	jle    80103118 <mycpu+0x46>
        if (cpus[i].apicid == apicid)
801030f3:	8d 04 92             	lea    (%edx,%edx,4),%eax
801030f6:	01 c0                	add    %eax,%eax
801030f8:	01 d0                	add    %edx,%eax
801030fa:	c1 e0 04             	shl    $0x4,%eax
801030fd:	0f b6 80 a0 17 11 80 	movzbl -0x7feee860(%eax),%eax
80103104:	39 c8                	cmp    %ecx,%eax
80103106:	74 1d                	je     80103125 <mycpu+0x53>
    for (i = 0; i < ncpu; ++i)
80103108:	42                   	inc    %edx
80103109:	eb e0                	jmp    801030eb <mycpu+0x19>
        panic("mycpu called with interrupts enabled\n");
8010310b:	83 ec 0c             	sub    $0xc,%esp
8010310e:	68 2c 6e 10 80       	push   $0x80106e2c
80103113:	e8 2c d2 ff ff       	call   80100344 <panic>
    panic("unknown apicid\n");
80103118:	83 ec 0c             	sub    $0xc,%esp
8010311b:	68 47 6d 10 80       	push   $0x80106d47
80103120:	e8 1f d2 ff ff       	call   80100344 <panic>
            return &cpus[i];
80103125:	8d 04 92             	lea    (%edx,%edx,4),%eax
80103128:	01 c0                	add    %eax,%eax
8010312a:	01 d0                	add    %edx,%eax
8010312c:	c1 e0 04             	shl    $0x4,%eax
8010312f:	05 a0 17 11 80       	add    $0x801117a0,%eax
}
80103134:	c9                   	leave  
80103135:	c3                   	ret    

80103136 <cpuid>:
{
80103136:	55                   	push   %ebp
80103137:	89 e5                	mov    %esp,%ebp
80103139:	83 ec 08             	sub    $0x8,%esp
    return mycpu() - cpus;
8010313c:	e8 91 ff ff ff       	call   801030d2 <mycpu>
80103141:	2d a0 17 11 80       	sub    $0x801117a0,%eax
80103146:	c1 f8 04             	sar    $0x4,%eax
80103149:	8d 0c c0             	lea    (%eax,%eax,8),%ecx
8010314c:	89 ca                	mov    %ecx,%edx
8010314e:	c1 e2 05             	shl    $0x5,%edx
80103151:	29 ca                	sub    %ecx,%edx
80103153:	8d 14 90             	lea    (%eax,%edx,4),%edx
80103156:	8d 0c d0             	lea    (%eax,%edx,8),%ecx
80103159:	89 ca                	mov    %ecx,%edx
8010315b:	c1 e2 0f             	shl    $0xf,%edx
8010315e:	29 ca                	sub    %ecx,%edx
80103160:	8d 04 90             	lea    (%eax,%edx,4),%eax
80103163:	f7 d8                	neg    %eax
}
80103165:	c9                   	leave  
80103166:	c3                   	ret    

80103167 <myproc>:
{
80103167:	55                   	push   %ebp
80103168:	89 e5                	mov    %esp,%ebp
8010316a:	53                   	push   %ebx
8010316b:	83 ec 04             	sub    $0x4,%esp
    pushcli();
8010316e:	e8 96 0a 00 00       	call   80103c09 <pushcli>
    c = mycpu();
80103173:	e8 5a ff ff ff       	call   801030d2 <mycpu>
    p = c->proc;
80103178:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
    popcli();
8010317e:	e8 ca 0a 00 00       	call   80103c4d <popcli>
}
80103183:	89 d8                	mov    %ebx,%eax
80103185:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103188:	c9                   	leave  
80103189:	c3                   	ret    

8010318a <userinit>:
{
8010318a:	55                   	push   %ebp
8010318b:	89 e5                	mov    %esp,%ebp
8010318d:	53                   	push   %ebx
8010318e:	83 ec 04             	sub    $0x4,%esp
    p = allocproc();
80103191:	e8 1e fe ff ff       	call   80102fb4 <allocproc>
80103196:	89 c3                	mov    %eax,%ebx
    initproc = p;
80103198:	a3 54 6b 11 80       	mov    %eax,0x80116b54
    if ((p->pgdir = setupkvm()) == 0)
8010319d:	e8 0f 34 00 00       	call   801065b1 <setupkvm>
801031a2:	89 43 04             	mov    %eax,0x4(%ebx)
801031a5:	85 c0                	test   %eax,%eax
801031a7:	0f 84 b6 00 00 00    	je     80103263 <userinit+0xd9>
    inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801031ad:	83 ec 04             	sub    $0x4,%esp
801031b0:	68 2c 00 00 00       	push   $0x2c
801031b5:	68 60 a4 10 80       	push   $0x8010a460
801031ba:	50                   	push   %eax
801031bb:	e8 0c 31 00 00       	call   801062cc <inituvm>
    p->sz = PGSIZE;
801031c0:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
    memset(p->tf, 0, sizeof(*p->tf));
801031c6:	8b 43 18             	mov    0x18(%ebx),%eax
801031c9:	83 c4 0c             	add    $0xc,%esp
801031cc:	6a 4c                	push   $0x4c
801031ce:	6a 00                	push   $0x0
801031d0:	50                   	push   %eax
801031d1:	e8 c2 0b 00 00       	call   80103d98 <memset>
    p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
801031d6:	8b 43 18             	mov    0x18(%ebx),%eax
801031d9:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
801031df:	8b 43 18             	mov    0x18(%ebx),%eax
801031e2:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
    p->tf->es = p->tf->ds;
801031e8:	8b 43 18             	mov    0x18(%ebx),%eax
801031eb:	8b 50 2c             	mov    0x2c(%eax),%edx
801031ee:	66 89 50 28          	mov    %dx,0x28(%eax)
    p->tf->ss = p->tf->ds;
801031f2:	8b 43 18             	mov    0x18(%ebx),%eax
801031f5:	8b 50 2c             	mov    0x2c(%eax),%edx
801031f8:	66 89 50 48          	mov    %dx,0x48(%eax)
    p->tf->eflags = FL_IF;
801031fc:	8b 43 18             	mov    0x18(%ebx),%eax
801031ff:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
    p->tf->esp = PGSIZE;
80103206:	8b 43 18             	mov    0x18(%ebx),%eax
80103209:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
    p->tf->eip = 0; // beginning of initcode.S
80103210:	8b 43 18             	mov    0x18(%ebx),%eax
80103213:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
    safestrcpy(p->name, "initcode", sizeof(p->name));
8010321a:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010321d:	83 c4 0c             	add    $0xc,%esp
80103220:	6a 10                	push   $0x10
80103222:	68 70 6d 10 80       	push   $0x80106d70
80103227:	50                   	push   %eax
80103228:	e8 c3 0c 00 00       	call   80103ef0 <safestrcpy>
    p->cwd = namei("/");
8010322d:	c7 04 24 79 6d 10 80 	movl   $0x80106d79,(%esp)
80103234:	e8 67 e9 ff ff       	call   80101ba0 <namei>
80103239:	89 43 68             	mov    %eax,0x68(%ebx)
    acquire(&ptable.lock);
8010323c:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
80103243:	e8 a4 0a 00 00       	call   80103cec <acquire>
    p->state = RUNNABLE;
80103248:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
    release(&ptable.lock);
8010324f:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
80103256:	e8 f6 0a 00 00       	call   80103d51 <release>
}
8010325b:	83 c4 10             	add    $0x10,%esp
8010325e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103261:	c9                   	leave  
80103262:	c3                   	ret    
        panic("userinit: out of memory?");
80103263:	83 ec 0c             	sub    $0xc,%esp
80103266:	68 57 6d 10 80       	push   $0x80106d57
8010326b:	e8 d4 d0 ff ff       	call   80100344 <panic>

80103270 <growproc>:
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	8b 75 08             	mov    0x8(%ebp),%esi
    struct proc *curproc = myproc();
80103278:	e8 ea fe ff ff       	call   80103167 <myproc>
8010327d:	89 c3                	mov    %eax,%ebx
    sz = curproc->sz;
8010327f:	8b 00                	mov    (%eax),%eax
    if (n > 0)
80103281:	85 f6                	test   %esi,%esi
80103283:	7f 1c                	jg     801032a1 <growproc+0x31>
    else if (n < 0)
80103285:	78 37                	js     801032be <growproc+0x4e>
    curproc->sz = sz;
80103287:	89 03                	mov    %eax,(%ebx)
    switchuvm(curproc);
80103289:	83 ec 0c             	sub    $0xc,%esp
8010328c:	53                   	push   %ebx
8010328d:	e8 de 2e 00 00       	call   80106170 <switchuvm>
    return 0;
80103292:	83 c4 10             	add    $0x10,%esp
80103295:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010329a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010329d:	5b                   	pop    %ebx
8010329e:	5e                   	pop    %esi
8010329f:	5d                   	pop    %ebp
801032a0:	c3                   	ret    
        if ((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032a1:	83 ec 04             	sub    $0x4,%esp
801032a4:	01 c6                	add    %eax,%esi
801032a6:	56                   	push   %esi
801032a7:	50                   	push   %eax
801032a8:	ff 73 04             	pushl  0x4(%ebx)
801032ab:	e8 b0 31 00 00       	call   80106460 <allocuvm>
801032b0:	83 c4 10             	add    $0x10,%esp
801032b3:	85 c0                	test   %eax,%eax
801032b5:	75 d0                	jne    80103287 <growproc+0x17>
            return -1;
801032b7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032bc:	eb dc                	jmp    8010329a <growproc+0x2a>
        if ((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
801032be:	83 ec 04             	sub    $0x4,%esp
801032c1:	01 c6                	add    %eax,%esi
801032c3:	56                   	push   %esi
801032c4:	50                   	push   %eax
801032c5:	ff 73 04             	pushl  0x4(%ebx)
801032c8:	e8 03 31 00 00       	call   801063d0 <deallocuvm>
801032cd:	83 c4 10             	add    $0x10,%esp
801032d0:	85 c0                	test   %eax,%eax
801032d2:	75 b3                	jne    80103287 <growproc+0x17>
            return -1;
801032d4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801032d9:	eb bf                	jmp    8010329a <growproc+0x2a>

801032db <fork>:
{
801032db:	55                   	push   %ebp
801032dc:	89 e5                	mov    %esp,%ebp
801032de:	57                   	push   %edi
801032df:	56                   	push   %esi
801032e0:	53                   	push   %ebx
801032e1:	83 ec 1c             	sub    $0x1c,%esp
    struct proc *curproc = myproc();
801032e4:	e8 7e fe ff ff       	call   80103167 <myproc>
801032e9:	89 c3                	mov    %eax,%ebx
    if ((np = allocproc()) == 0)
801032eb:	e8 c4 fc ff ff       	call   80102fb4 <allocproc>
801032f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801032f3:	85 c0                	test   %eax,%eax
801032f5:	0f 84 de 00 00 00    	je     801033d9 <fork+0xfe>
801032fb:	89 c7                	mov    %eax,%edi
    if ((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0)
801032fd:	83 ec 08             	sub    $0x8,%esp
80103300:	ff 33                	pushl  (%ebx)
80103302:	ff 73 04             	pushl  0x4(%ebx)
80103305:	e8 5c 33 00 00       	call   80106666 <copyuvm>
8010330a:	89 47 04             	mov    %eax,0x4(%edi)
8010330d:	83 c4 10             	add    $0x10,%esp
80103310:	85 c0                	test   %eax,%eax
80103312:	74 2a                	je     8010333e <fork+0x63>
    np->sz = curproc->sz;
80103314:	8b 03                	mov    (%ebx),%eax
80103316:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103319:	89 01                	mov    %eax,(%ecx)
    np->parent = curproc;
8010331b:	89 c8                	mov    %ecx,%eax
8010331d:	89 59 14             	mov    %ebx,0x14(%ecx)
    *np->tf = *curproc->tf;
80103320:	8b 73 18             	mov    0x18(%ebx),%esi
80103323:	8b 79 18             	mov    0x18(%ecx),%edi
80103326:	b9 13 00 00 00       	mov    $0x13,%ecx
8010332b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
    np->tf->eax = 0;
8010332d:	8b 40 18             	mov    0x18(%eax),%eax
80103330:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    for (i = 0; i < NOFILE; i++)
80103337:	be 00 00 00 00       	mov    $0x0,%esi
8010333c:	eb 27                	jmp    80103365 <fork+0x8a>
        kfree(np->kstack);
8010333e:	83 ec 0c             	sub    $0xc,%esp
80103341:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103344:	ff 73 08             	pushl  0x8(%ebx)
80103347:	e8 ff eb ff ff       	call   80101f4b <kfree>
        np->kstack = 0;
8010334c:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        np->state = UNUSED;
80103353:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        return -1;
8010335a:	83 c4 10             	add    $0x10,%esp
8010335d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103362:	eb 6b                	jmp    801033cf <fork+0xf4>
    for (i = 0; i < NOFILE; i++)
80103364:	46                   	inc    %esi
80103365:	83 fe 0f             	cmp    $0xf,%esi
80103368:	7f 1d                	jg     80103387 <fork+0xac>
        if (curproc->ofile[i])
8010336a:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
8010336e:	85 c0                	test   %eax,%eax
80103370:	74 f2                	je     80103364 <fork+0x89>
            np->ofile[i] = filedup(curproc->ofile[i]);
80103372:	83 ec 0c             	sub    $0xc,%esp
80103375:	50                   	push   %eax
80103376:	e8 06 d9 ff ff       	call   80100c81 <filedup>
8010337b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010337e:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
80103382:	83 c4 10             	add    $0x10,%esp
80103385:	eb dd                	jmp    80103364 <fork+0x89>
    np->cwd = idup(curproc->cwd);
80103387:	83 ec 0c             	sub    $0xc,%esp
8010338a:	ff 73 68             	pushl  0x68(%ebx)
8010338d:	e8 74 e1 ff ff       	call   80101506 <idup>
80103392:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103395:	89 47 68             	mov    %eax,0x68(%edi)
    safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103398:	83 c3 6c             	add    $0x6c,%ebx
8010339b:	8d 47 6c             	lea    0x6c(%edi),%eax
8010339e:	83 c4 0c             	add    $0xc,%esp
801033a1:	6a 10                	push   $0x10
801033a3:	53                   	push   %ebx
801033a4:	50                   	push   %eax
801033a5:	e8 46 0b 00 00       	call   80103ef0 <safestrcpy>
    pid = np->pid;
801033aa:	8b 5f 10             	mov    0x10(%edi),%ebx
    acquire(&ptable.lock);
801033ad:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
801033b4:	e8 33 09 00 00       	call   80103cec <acquire>
    np->state = RUNNABLE;
801033b9:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
    release(&ptable.lock);
801033c0:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
801033c7:	e8 85 09 00 00       	call   80103d51 <release>
    return pid;
801033cc:	83 c4 10             	add    $0x10,%esp
}
801033cf:	89 d8                	mov    %ebx,%eax
801033d1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033d4:	5b                   	pop    %ebx
801033d5:	5e                   	pop    %esi
801033d6:	5f                   	pop    %edi
801033d7:	5d                   	pop    %ebp
801033d8:	c3                   	ret    
        return -1;
801033d9:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801033de:	eb ef                	jmp    801033cf <fork+0xf4>

801033e0 <scheduler>:
{
801033e0:	55                   	push   %ebp
801033e1:	89 e5                	mov    %esp,%ebp
801033e3:	56                   	push   %esi
801033e4:	53                   	push   %ebx
    struct cpu *c = mycpu();
801033e5:	e8 e8 fc ff ff       	call   801030d2 <mycpu>
801033ea:	89 c6                	mov    %eax,%esi
    c->proc = 0;
801033ec:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
801033f3:	00 00 00 
801033f6:	eb 5d                	jmp    80103455 <scheduler+0x75>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801033f8:	81 c3 88 00 00 00    	add    $0x88,%ebx
801033fe:	81 fb 54 6b 11 80    	cmp    $0x80116b54,%ebx
80103404:	73 3f                	jae    80103445 <scheduler+0x65>
            if (p->state != RUNNABLE)
80103406:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
8010340a:	75 ec                	jne    801033f8 <scheduler+0x18>
            c->proc = p;
8010340c:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
            switchuvm(p);
80103412:	83 ec 0c             	sub    $0xc,%esp
80103415:	53                   	push   %ebx
80103416:	e8 55 2d 00 00       	call   80106170 <switchuvm>
            p->state = RUNNING;
8010341b:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
            swtch(&(c->scheduler), p->context);
80103422:	83 c4 08             	add    $0x8,%esp
80103425:	ff 73 1c             	pushl  0x1c(%ebx)
80103428:	8d 46 04             	lea    0x4(%esi),%eax
8010342b:	50                   	push   %eax
8010342c:	e8 0d 0b 00 00       	call   80103f3e <swtch>
            switchkvm();
80103431:	e8 2c 2d 00 00       	call   80106162 <switchkvm>
            c->proc = 0;
80103436:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
8010343d:	00 00 00 
80103440:	83 c4 10             	add    $0x10,%esp
80103443:	eb b3                	jmp    801033f8 <scheduler+0x18>
        release(&ptable.lock);
80103445:	83 ec 0c             	sub    $0xc,%esp
80103448:	68 20 49 11 80       	push   $0x80114920
8010344d:	e8 ff 08 00 00       	call   80103d51 <release>
        sti();
80103452:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
80103455:	fb                   	sti    
        acquire(&ptable.lock);
80103456:	83 ec 0c             	sub    $0xc,%esp
80103459:	68 20 49 11 80       	push   $0x80114920
8010345e:	e8 89 08 00 00       	call   80103cec <acquire>
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103463:	83 c4 10             	add    $0x10,%esp
80103466:	bb 54 49 11 80       	mov    $0x80114954,%ebx
8010346b:	eb 91                	jmp    801033fe <scheduler+0x1e>

8010346d <sched>:
{
8010346d:	55                   	push   %ebp
8010346e:	89 e5                	mov    %esp,%ebp
80103470:	56                   	push   %esi
80103471:	53                   	push   %ebx
    struct proc *p = myproc();
80103472:	e8 f0 fc ff ff       	call   80103167 <myproc>
80103477:	89 c3                	mov    %eax,%ebx
    if (!holding(&ptable.lock))
80103479:	83 ec 0c             	sub    $0xc,%esp
8010347c:	68 20 49 11 80       	push   $0x80114920
80103481:	e8 27 08 00 00       	call   80103cad <holding>
80103486:	83 c4 10             	add    $0x10,%esp
80103489:	85 c0                	test   %eax,%eax
8010348b:	74 4f                	je     801034dc <sched+0x6f>
    if (mycpu()->ncli != 1)
8010348d:	e8 40 fc ff ff       	call   801030d2 <mycpu>
80103492:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103499:	75 4e                	jne    801034e9 <sched+0x7c>
    if (p->state == RUNNING)
8010349b:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
8010349f:	74 55                	je     801034f6 <sched+0x89>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801034a1:	9c                   	pushf  
801034a2:	58                   	pop    %eax
    if (readeflags() & FL_IF)
801034a3:	f6 c4 02             	test   $0x2,%ah
801034a6:	75 5b                	jne    80103503 <sched+0x96>
    intena = mycpu()->intena;
801034a8:	e8 25 fc ff ff       	call   801030d2 <mycpu>
801034ad:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
    swtch(&p->context, mycpu()->scheduler);
801034b3:	e8 1a fc ff ff       	call   801030d2 <mycpu>
801034b8:	83 ec 08             	sub    $0x8,%esp
801034bb:	ff 70 04             	pushl  0x4(%eax)
801034be:	83 c3 1c             	add    $0x1c,%ebx
801034c1:	53                   	push   %ebx
801034c2:	e8 77 0a 00 00       	call   80103f3e <swtch>
    mycpu()->intena = intena;
801034c7:	e8 06 fc ff ff       	call   801030d2 <mycpu>
801034cc:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
801034d2:	83 c4 10             	add    $0x10,%esp
801034d5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801034d8:	5b                   	pop    %ebx
801034d9:	5e                   	pop    %esi
801034da:	5d                   	pop    %ebp
801034db:	c3                   	ret    
        panic("sched ptable.lock");
801034dc:	83 ec 0c             	sub    $0xc,%esp
801034df:	68 7b 6d 10 80       	push   $0x80106d7b
801034e4:	e8 5b ce ff ff       	call   80100344 <panic>
        panic("sched locks");
801034e9:	83 ec 0c             	sub    $0xc,%esp
801034ec:	68 8d 6d 10 80       	push   $0x80106d8d
801034f1:	e8 4e ce ff ff       	call   80100344 <panic>
        panic("sched running");
801034f6:	83 ec 0c             	sub    $0xc,%esp
801034f9:	68 99 6d 10 80       	push   $0x80106d99
801034fe:	e8 41 ce ff ff       	call   80100344 <panic>
        panic("sched interruptible");
80103503:	83 ec 0c             	sub    $0xc,%esp
80103506:	68 a7 6d 10 80       	push   $0x80106da7
8010350b:	e8 34 ce ff ff       	call   80100344 <panic>

80103510 <yield>:
{
80103510:	55                   	push   %ebp
80103511:	89 e5                	mov    %esp,%ebp
80103513:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock); // DOC: yieldlock
80103516:	68 20 49 11 80       	push   $0x80114920
8010351b:	e8 cc 07 00 00       	call   80103cec <acquire>
    myproc()->state = RUNNABLE;
80103520:	e8 42 fc ff ff       	call   80103167 <myproc>
80103525:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
    sched();
8010352c:	e8 3c ff ff ff       	call   8010346d <sched>
    release(&ptable.lock);
80103531:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
80103538:	e8 14 08 00 00       	call   80103d51 <release>
}
8010353d:	83 c4 10             	add    $0x10,%esp
80103540:	c9                   	leave  
80103541:	c3                   	ret    

80103542 <sleep>:
{
80103542:	55                   	push   %ebp
80103543:	89 e5                	mov    %esp,%ebp
80103545:	56                   	push   %esi
80103546:	53                   	push   %ebx
80103547:	8b 75 0c             	mov    0xc(%ebp),%esi
    struct proc *p = myproc();
8010354a:	e8 18 fc ff ff       	call   80103167 <myproc>
    if (p == 0)
8010354f:	85 c0                	test   %eax,%eax
80103551:	74 66                	je     801035b9 <sleep+0x77>
80103553:	89 c3                	mov    %eax,%ebx
    if (lk == 0)
80103555:	85 f6                	test   %esi,%esi
80103557:	74 6d                	je     801035c6 <sleep+0x84>
    if (lk != &ptable.lock)
80103559:	81 fe 20 49 11 80    	cmp    $0x80114920,%esi
8010355f:	74 18                	je     80103579 <sleep+0x37>
        acquire(&ptable.lock); // DOC: sleeplock1
80103561:	83 ec 0c             	sub    $0xc,%esp
80103564:	68 20 49 11 80       	push   $0x80114920
80103569:	e8 7e 07 00 00       	call   80103cec <acquire>
        release(lk);
8010356e:	89 34 24             	mov    %esi,(%esp)
80103571:	e8 db 07 00 00       	call   80103d51 <release>
80103576:	83 c4 10             	add    $0x10,%esp
    p->chan = chan;
80103579:	8b 45 08             	mov    0x8(%ebp),%eax
8010357c:	89 43 20             	mov    %eax,0x20(%ebx)
    p->state = SLEEPING;
8010357f:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
    sched();
80103586:	e8 e2 fe ff ff       	call   8010346d <sched>
    p->chan = 0;
8010358b:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    if (lk != &ptable.lock)
80103592:	81 fe 20 49 11 80    	cmp    $0x80114920,%esi
80103598:	74 18                	je     801035b2 <sleep+0x70>
        release(&ptable.lock);
8010359a:	83 ec 0c             	sub    $0xc,%esp
8010359d:	68 20 49 11 80       	push   $0x80114920
801035a2:	e8 aa 07 00 00       	call   80103d51 <release>
        acquire(lk);
801035a7:	89 34 24             	mov    %esi,(%esp)
801035aa:	e8 3d 07 00 00       	call   80103cec <acquire>
801035af:	83 c4 10             	add    $0x10,%esp
}
801035b2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801035b5:	5b                   	pop    %ebx
801035b6:	5e                   	pop    %esi
801035b7:	5d                   	pop    %ebp
801035b8:	c3                   	ret    
        panic("sleep");
801035b9:	83 ec 0c             	sub    $0xc,%esp
801035bc:	68 bb 6d 10 80       	push   $0x80106dbb
801035c1:	e8 7e cd ff ff       	call   80100344 <panic>
        panic("sleep without lk");
801035c6:	83 ec 0c             	sub    $0xc,%esp
801035c9:	68 c1 6d 10 80       	push   $0x80106dc1
801035ce:	e8 71 cd ff ff       	call   80100344 <panic>

801035d3 <wait>:
{
801035d3:	55                   	push   %ebp
801035d4:	89 e5                	mov    %esp,%ebp
801035d6:	56                   	push   %esi
801035d7:	53                   	push   %ebx
    struct proc *curproc = myproc();
801035d8:	e8 8a fb ff ff       	call   80103167 <myproc>
801035dd:	89 c6                	mov    %eax,%esi
    acquire(&ptable.lock);
801035df:	83 ec 0c             	sub    $0xc,%esp
801035e2:	68 20 49 11 80       	push   $0x80114920
801035e7:	e8 00 07 00 00       	call   80103cec <acquire>
801035ec:	83 c4 10             	add    $0x10,%esp
        havekids = 0;
801035ef:	b8 00 00 00 00       	mov    $0x0,%eax
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035f4:	bb 54 49 11 80       	mov    $0x80114954,%ebx
801035f9:	eb 5e                	jmp    80103659 <wait+0x86>
                pid = p->pid;
801035fb:	8b 73 10             	mov    0x10(%ebx),%esi
                kfree(p->kstack);
801035fe:	83 ec 0c             	sub    $0xc,%esp
80103601:	ff 73 08             	pushl  0x8(%ebx)
80103604:	e8 42 e9 ff ff       	call   80101f4b <kfree>
                p->kstack = 0;
80103609:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
                freevm(p->pgdir);
80103610:	83 c4 04             	add    $0x4,%esp
80103613:	ff 73 04             	pushl  0x4(%ebx)
80103616:	e8 28 2f 00 00       	call   80106543 <freevm>
                p->pid = 0;
8010361b:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
                p->parent = 0;
80103622:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
                p->name[0] = 0;
80103629:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
                p->killed = 0;
8010362d:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
                p->state = UNUSED;
80103634:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
                release(&ptable.lock);
8010363b:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
80103642:	e8 0a 07 00 00       	call   80103d51 <release>
                return pid;
80103647:	83 c4 10             	add    $0x10,%esp
}
8010364a:	89 f0                	mov    %esi,%eax
8010364c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010364f:	5b                   	pop    %ebx
80103650:	5e                   	pop    %esi
80103651:	5d                   	pop    %ebp
80103652:	c3                   	ret    
        for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103653:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103659:	81 fb 54 6b 11 80    	cmp    $0x80116b54,%ebx
8010365f:	73 12                	jae    80103673 <wait+0xa0>
            if (p->parent != curproc)
80103661:	39 73 14             	cmp    %esi,0x14(%ebx)
80103664:	75 ed                	jne    80103653 <wait+0x80>
            if (p->state == ZOMBIE)
80103666:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010366a:	74 8f                	je     801035fb <wait+0x28>
            havekids = 1;
8010366c:	b8 01 00 00 00       	mov    $0x1,%eax
80103671:	eb e0                	jmp    80103653 <wait+0x80>
        if (!havekids || curproc->killed)
80103673:	85 c0                	test   %eax,%eax
80103675:	74 1c                	je     80103693 <wait+0xc0>
80103677:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
8010367b:	75 16                	jne    80103693 <wait+0xc0>
        sleep(curproc, &ptable.lock); // DOC: wait-sleep
8010367d:	83 ec 08             	sub    $0x8,%esp
80103680:	68 20 49 11 80       	push   $0x80114920
80103685:	56                   	push   %esi
80103686:	e8 b7 fe ff ff       	call   80103542 <sleep>
        havekids = 0;
8010368b:	83 c4 10             	add    $0x10,%esp
8010368e:	e9 5c ff ff ff       	jmp    801035ef <wait+0x1c>
            release(&ptable.lock);
80103693:	83 ec 0c             	sub    $0xc,%esp
80103696:	68 20 49 11 80       	push   $0x80114920
8010369b:	e8 b1 06 00 00       	call   80103d51 <release>
            return -1;
801036a0:	83 c4 10             	add    $0x10,%esp
801036a3:	be ff ff ff ff       	mov    $0xffffffff,%esi
801036a8:	eb a0                	jmp    8010364a <wait+0x77>

801036aa <wakeup>:

// Wake up all processes sleeping on chan.
void wakeup(void *chan)
{
801036aa:	55                   	push   %ebp
801036ab:	89 e5                	mov    %esp,%ebp
801036ad:	83 ec 14             	sub    $0x14,%esp
    acquire(&ptable.lock);
801036b0:	68 20 49 11 80       	push   $0x80114920
801036b5:	e8 32 06 00 00       	call   80103cec <acquire>
    wakeup1(chan);
801036ba:	8b 45 08             	mov    0x8(%ebp),%eax
801036bd:	e8 c8 f8 ff ff       	call   80102f8a <wakeup1>
    release(&ptable.lock);
801036c2:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
801036c9:	e8 83 06 00 00       	call   80103d51 <release>
}
801036ce:	83 c4 10             	add    $0x10,%esp
801036d1:	c9                   	leave  
801036d2:	c3                   	ret    

801036d3 <kill>:

// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int kill(int pid)
{
801036d3:	55                   	push   %ebp
801036d4:	89 e5                	mov    %esp,%ebp
801036d6:	53                   	push   %ebx
801036d7:	83 ec 10             	sub    $0x10,%esp
801036da:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *p;

    acquire(&ptable.lock);
801036dd:	68 20 49 11 80       	push   $0x80114920
801036e2:	e8 05 06 00 00       	call   80103cec <acquire>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036e7:	83 c4 10             	add    $0x10,%esp
801036ea:	b8 54 49 11 80       	mov    $0x80114954,%eax
801036ef:	eb 0e                	jmp    801036ff <kill+0x2c>
        if (p->pid == pid)
        {
            p->killed = 1;
            // Wake process from sleep if necessary.
            if (p->state == SLEEPING)
                p->state = RUNNABLE;
801036f1:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801036f8:	eb 1e                	jmp    80103718 <kill+0x45>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801036fa:	05 88 00 00 00       	add    $0x88,%eax
801036ff:	3d 54 6b 11 80       	cmp    $0x80116b54,%eax
80103704:	73 2c                	jae    80103732 <kill+0x5f>
        if (p->pid == pid)
80103706:	39 58 10             	cmp    %ebx,0x10(%eax)
80103709:	75 ef                	jne    801036fa <kill+0x27>
            p->killed = 1;
8010370b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
            if (p->state == SLEEPING)
80103712:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103716:	74 d9                	je     801036f1 <kill+0x1e>
            release(&ptable.lock);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	68 20 49 11 80       	push   $0x80114920
80103720:	e8 2c 06 00 00       	call   80103d51 <release>
            return 0;
80103725:	83 c4 10             	add    $0x10,%esp
80103728:	b8 00 00 00 00       	mov    $0x0,%eax
        }
    }
    release(&ptable.lock);
    return -1;
}
8010372d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103730:	c9                   	leave  
80103731:	c3                   	ret    
    release(&ptable.lock);
80103732:	83 ec 0c             	sub    $0xc,%esp
80103735:	68 20 49 11 80       	push   $0x80114920
8010373a:	e8 12 06 00 00       	call   80103d51 <release>
    return -1;
8010373f:	83 c4 10             	add    $0x10,%esp
80103742:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103747:	eb e4                	jmp    8010372d <kill+0x5a>

80103749 <procdump>:
// PAGEBREAK: 36
//  Print a process listing to console.  For debugging.
//  Runs when user types ^P on console.
//  No lock to avoid wedging a stuck machine further.
void procdump(void)
{
80103749:	55                   	push   %ebp
8010374a:	89 e5                	mov    %esp,%ebp
8010374c:	56                   	push   %esi
8010374d:	53                   	push   %ebx
8010374e:	83 ec 30             	sub    $0x30,%esp
    int i;
    struct proc *p;
    char *state;
    uint pc[10];

    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103751:	bb 54 49 11 80       	mov    $0x80114954,%ebx
80103756:	eb 36                	jmp    8010378e <procdump+0x45>
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
            state = states[p->state];
        else
            state = "???";
80103758:	b8 d2 6d 10 80       	mov    $0x80106dd2,%eax
        cprintf("%d %s %s", p->pid, state, p->name);
8010375d:	8d 53 6c             	lea    0x6c(%ebx),%edx
80103760:	52                   	push   %edx
80103761:	50                   	push   %eax
80103762:	ff 73 10             	pushl  0x10(%ebx)
80103765:	68 d6 6d 10 80       	push   $0x80106dd6
8010376a:	e8 70 ce ff ff       	call   801005df <cprintf>
        if (p->state == SLEEPING)
8010376f:	83 c4 10             	add    $0x10,%esp
80103772:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
80103776:	74 3c                	je     801037b4 <procdump+0x6b>
        {
            getcallerpcs((uint *)p->context->ebp + 2, pc);
            for (i = 0; i < 10 && pc[i] != 0; i++)
                cprintf(" %p", pc[i]);
        }
        cprintf("\n");
80103778:	83 ec 0c             	sub    $0xc,%esp
8010377b:	68 c7 71 10 80       	push   $0x801071c7
80103780:	e8 5a ce ff ff       	call   801005df <cprintf>
80103785:	83 c4 10             	add    $0x10,%esp
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103788:	81 c3 88 00 00 00    	add    $0x88,%ebx
8010378e:	81 fb 54 6b 11 80    	cmp    $0x80116b54,%ebx
80103794:	73 5f                	jae    801037f5 <procdump+0xac>
        if (p->state == UNUSED)
80103796:	8b 43 0c             	mov    0xc(%ebx),%eax
80103799:	85 c0                	test   %eax,%eax
8010379b:	74 eb                	je     80103788 <procdump+0x3f>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
8010379d:	83 f8 05             	cmp    $0x5,%eax
801037a0:	77 b6                	ja     80103758 <procdump+0xf>
801037a2:	8b 04 85 54 6e 10 80 	mov    -0x7fef91ac(,%eax,4),%eax
801037a9:	85 c0                	test   %eax,%eax
801037ab:	75 b0                	jne    8010375d <procdump+0x14>
            state = "???";
801037ad:	b8 d2 6d 10 80       	mov    $0x80106dd2,%eax
801037b2:	eb a9                	jmp    8010375d <procdump+0x14>
            getcallerpcs((uint *)p->context->ebp + 2, pc);
801037b4:	8b 43 1c             	mov    0x1c(%ebx),%eax
801037b7:	8b 40 0c             	mov    0xc(%eax),%eax
801037ba:	83 c0 08             	add    $0x8,%eax
801037bd:	83 ec 08             	sub    $0x8,%esp
801037c0:	8d 55 d0             	lea    -0x30(%ebp),%edx
801037c3:	52                   	push   %edx
801037c4:	50                   	push   %eax
801037c5:	e8 fd 03 00 00       	call   80103bc7 <getcallerpcs>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801037ca:	83 c4 10             	add    $0x10,%esp
801037cd:	be 00 00 00 00       	mov    $0x0,%esi
801037d2:	eb 12                	jmp    801037e6 <procdump+0x9d>
                cprintf(" %p", pc[i]);
801037d4:	83 ec 08             	sub    $0x8,%esp
801037d7:	50                   	push   %eax
801037d8:	68 41 68 10 80       	push   $0x80106841
801037dd:	e8 fd cd ff ff       	call   801005df <cprintf>
            for (i = 0; i < 10 && pc[i] != 0; i++)
801037e2:	46                   	inc    %esi
801037e3:	83 c4 10             	add    $0x10,%esp
801037e6:	83 fe 09             	cmp    $0x9,%esi
801037e9:	7f 8d                	jg     80103778 <procdump+0x2f>
801037eb:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
801037ef:	85 c0                	test   %eax,%eax
801037f1:	75 e1                	jne    801037d4 <procdump+0x8b>
801037f3:	eb 83                	jmp    80103778 <procdump+0x2f>
    }
}
801037f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801037f8:	5b                   	pop    %ebx
801037f9:	5e                   	pop    %esi
801037fa:	5d                   	pop    %ebp
801037fb:	c3                   	ret    

801037fc <add_to_hist>:

// Defining the new functions for history entry
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

void add_to_hist(struct proc *p)
{
801037fc:	55                   	push   %ebp
801037fd:	89 e5                	mov    %esp,%ebp
801037ff:	57                   	push   %edi
80103800:	56                   	push   %esi
80103801:	53                   	push   %ebx
80103802:	83 ec 0c             	sub    $0xc,%esp
80103805:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (history_count < max_procs && p->is_failed == 0)
80103808:	a1 00 49 11 80       	mov    0x80114900,%eax
8010380d:	83 f8 63             	cmp    $0x63,%eax
80103810:	7f 06                	jg     80103818 <add_to_hist+0x1c>
80103812:	83 7b 7c 00          	cmpl   $0x0,0x7c(%ebx)
80103816:	74 08                	je     80103820 <add_to_hist+0x24>
        hist_array[history_count].mem_util = p->sz;
        hist_array[history_count].time_stamp = p->time_counter;

        history_count++;
    }
}
80103818:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010381b:	5b                   	pop    %ebx
8010381c:	5e                   	pop    %esi
8010381d:	5f                   	pop    %edi
8010381e:	5d                   	pop    %ebp
8010381f:	c3                   	ret    
        hist_array[history_count].pid = p->pid;
80103820:	8b 4b 10             	mov    0x10(%ebx),%ecx
80103823:	8d 14 00             	lea    (%eax,%eax,1),%edx
80103826:	01 c2                	add    %eax,%edx
80103828:	01 d2                	add    %edx,%edx
8010382a:	8d 3c 02             	lea    (%edx,%eax,1),%edi
8010382d:	c1 e7 04             	shl    $0x4,%edi
80103830:	89 8f 40 1d 11 80    	mov    %ecx,-0x7feee2c0(%edi)
        safestrcpy(hist_array[history_count].proc_name, p->name, sizeof(p->name));
80103836:	8d 4b 6c             	lea    0x6c(%ebx),%ecx
80103839:	89 fa                	mov    %edi,%edx
8010383b:	81 c2 44 1d 11 80    	add    $0x80111d44,%edx
80103841:	83 ec 04             	sub    $0x4,%esp
80103844:	6a 10                	push   $0x10
80103846:	51                   	push   %ecx
80103847:	52                   	push   %edx
80103848:	e8 a3 06 00 00       	call   80103ef0 <safestrcpy>
        hist_array[history_count].mem_util = p->sz;
8010384d:	8b 15 00 49 11 80    	mov    0x80114900,%edx
80103853:	8b 0b                	mov    (%ebx),%ecx
80103855:	8d 04 12             	lea    (%edx,%edx,1),%eax
80103858:	01 d0                	add    %edx,%eax
8010385a:	01 c0                	add    %eax,%eax
8010385c:	01 d0                	add    %edx,%eax
8010385e:	c1 e0 04             	shl    $0x4,%eax
80103861:	89 88 a8 1d 11 80    	mov    %ecx,-0x7feee258(%eax)
        hist_array[history_count].time_stamp = p->time_counter;
80103867:	8b 8b 80 00 00 00    	mov    0x80(%ebx),%ecx
8010386d:	89 88 ac 1d 11 80    	mov    %ecx,-0x7feee254(%eax)
        history_count++;
80103873:	42                   	inc    %edx
80103874:	89 15 00 49 11 80    	mov    %edx,0x80114900
8010387a:	83 c4 10             	add    $0x10,%esp
}
8010387d:	eb 99                	jmp    80103818 <add_to_hist+0x1c>

8010387f <exit>:
{
8010387f:	55                   	push   %ebp
80103880:	89 e5                	mov    %esp,%ebp
80103882:	56                   	push   %esi
80103883:	53                   	push   %ebx
    struct proc *curproc = myproc();
80103884:	e8 de f8 ff ff       	call   80103167 <myproc>
80103889:	89 c6                	mov    %eax,%esi
    add_to_hist(curproc);
8010388b:	83 ec 0c             	sub    $0xc,%esp
8010388e:	50                   	push   %eax
8010388f:	e8 68 ff ff ff       	call   801037fc <add_to_hist>
    if (curproc == initproc)
80103894:	83 c4 10             	add    $0x10,%esp
80103897:	39 35 54 6b 11 80    	cmp    %esi,0x80116b54
8010389d:	74 07                	je     801038a6 <exit+0x27>
    for (fd = 0; fd < NOFILE; fd++)
8010389f:	bb 00 00 00 00       	mov    $0x0,%ebx
801038a4:	eb 22                	jmp    801038c8 <exit+0x49>
        panic("init exiting");
801038a6:	83 ec 0c             	sub    $0xc,%esp
801038a9:	68 df 6d 10 80       	push   $0x80106ddf
801038ae:	e8 91 ca ff ff       	call   80100344 <panic>
            fileclose(curproc->ofile[fd]);
801038b3:	83 ec 0c             	sub    $0xc,%esp
801038b6:	50                   	push   %eax
801038b7:	e8 08 d4 ff ff       	call   80100cc4 <fileclose>
            curproc->ofile[fd] = 0;
801038bc:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801038c3:	00 
801038c4:	83 c4 10             	add    $0x10,%esp
    for (fd = 0; fd < NOFILE; fd++)
801038c7:	43                   	inc    %ebx
801038c8:	83 fb 0f             	cmp    $0xf,%ebx
801038cb:	7f 0a                	jg     801038d7 <exit+0x58>
        if (curproc->ofile[fd])
801038cd:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801038d1:	85 c0                	test   %eax,%eax
801038d3:	75 de                	jne    801038b3 <exit+0x34>
801038d5:	eb f0                	jmp    801038c7 <exit+0x48>
    begin_op();
801038d7:	e8 3f ee ff ff       	call   8010271b <begin_op>
    iput(curproc->cwd);
801038dc:	83 ec 0c             	sub    $0xc,%esp
801038df:	ff 76 68             	pushl  0x68(%esi)
801038e2:	e8 52 dd ff ff       	call   80101639 <iput>
    end_op();
801038e7:	e8 ab ee ff ff       	call   80102797 <end_op>
    curproc->cwd = 0;
801038ec:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
    acquire(&ptable.lock);
801038f3:	c7 04 24 20 49 11 80 	movl   $0x80114920,(%esp)
801038fa:	e8 ed 03 00 00       	call   80103cec <acquire>
    wakeup1(curproc->parent);
801038ff:	8b 46 14             	mov    0x14(%esi),%eax
80103902:	e8 83 f6 ff ff       	call   80102f8a <wakeup1>
    for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103907:	83 c4 10             	add    $0x10,%esp
8010390a:	bb 54 49 11 80       	mov    $0x80114954,%ebx
8010390f:	eb 06                	jmp    80103917 <exit+0x98>
80103911:	81 c3 88 00 00 00    	add    $0x88,%ebx
80103917:	81 fb 54 6b 11 80    	cmp    $0x80116b54,%ebx
8010391d:	73 1a                	jae    80103939 <exit+0xba>
        if (p->parent == curproc)
8010391f:	39 73 14             	cmp    %esi,0x14(%ebx)
80103922:	75 ed                	jne    80103911 <exit+0x92>
            p->parent = initproc;
80103924:	a1 54 6b 11 80       	mov    0x80116b54,%eax
80103929:	89 43 14             	mov    %eax,0x14(%ebx)
            if (p->state == ZOMBIE)
8010392c:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103930:	75 df                	jne    80103911 <exit+0x92>
                wakeup1(initproc);
80103932:	e8 53 f6 ff ff       	call   80102f8a <wakeup1>
80103937:	eb d8                	jmp    80103911 <exit+0x92>
    curproc->state = ZOMBIE;
80103939:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
    sched();
80103940:	e8 28 fb ff ff       	call   8010346d <sched>
    panic("zombie exit");
80103945:	83 ec 0c             	sub    $0xc,%esp
80103948:	68 ec 6d 10 80       	push   $0x80106dec
8010394d:	e8 f2 c9 ff ff       	call   80100344 <panic>

80103952 <proc_get_history>:

int proc_get_history(void)
{
80103952:	55                   	push   %ebp
80103953:	89 e5                	mov    %esp,%ebp
80103955:	57                   	push   %edi
80103956:	56                   	push   %esi
80103957:	53                   	push   %ebx
80103958:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
    // Sorting the history based on the timestamps
    for (int i = 0; i < history_count - 1; i++)
8010395e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103963:	89 9d 74 ff ff ff    	mov    %ebx,-0x8c(%ebp)
80103969:	e9 b1 00 00 00       	jmp    80103a1f <proc_get_history+0xcd>
{
8010396e:	89 da                	mov    %ebx,%edx
    {
        for (int j = 0; j < history_count - i - 1; j++)
80103970:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80103976:	8b bd 74 ff ff ff    	mov    -0x8c(%ebp),%edi
8010397c:	29 f8                	sub    %edi,%eax
8010397e:	48                   	dec    %eax
8010397f:	39 d0                	cmp    %edx,%eax
80103981:	0f 8e 92 00 00 00    	jle    80103a19 <proc_get_history+0xc7>
        {
            if (hist_array[j].time_stamp > hist_array[j + 1].time_stamp)
80103987:	8d 04 12             	lea    (%edx,%edx,1),%eax
8010398a:	01 d0                	add    %edx,%eax
8010398c:	01 c0                	add    %eax,%eax
8010398e:	01 d0                	add    %edx,%eax
80103990:	c1 e0 04             	shl    $0x4,%eax
80103993:	89 c1                	mov    %eax,%ecx
80103995:	8d 5a 01             	lea    0x1(%edx),%ebx
80103998:	8d 44 12 02          	lea    0x2(%edx,%edx,1),%eax
8010399c:	8d 44 02 01          	lea    0x1(%edx,%eax,1),%eax
801039a0:	01 c0                	add    %eax,%eax
801039a2:	8d 74 02 01          	lea    0x1(%edx,%eax,1),%esi
801039a6:	89 f0                	mov    %esi,%eax
801039a8:	c1 e0 04             	shl    $0x4,%eax
801039ab:	8b 80 ac 1d 11 80    	mov    -0x7feee254(%eax),%eax
801039b1:	39 81 ac 1d 11 80    	cmp    %eax,-0x7feee254(%ecx)
801039b7:	7e b5                	jle    8010396e <proc_get_history+0x1c>
            {
                struct proc_history temp = hist_array[j];
801039b9:	8d 04 12             	lea    (%edx,%edx,1),%eax
801039bc:	01 d0                	add    %edx,%eax
801039be:	01 c0                	add    %eax,%eax
801039c0:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
801039c3:	89 ce                	mov    %ecx,%esi
801039c5:	c1 e6 04             	shl    $0x4,%esi
801039c8:	81 c6 40 1d 11 80    	add    $0x80111d40,%esi
801039ce:	8d bd 78 ff ff ff    	lea    -0x88(%ebp),%edi
801039d4:	b9 1c 00 00 00       	mov    $0x1c,%ecx
801039d9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                hist_array[j] = hist_array[j + 1];
801039db:	01 d0                	add    %edx,%eax
801039dd:	c1 e0 04             	shl    $0x4,%eax
801039e0:	8d 80 40 1d 11 80    	lea    -0x7feee2c0(%eax),%eax
801039e6:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
801039e9:	01 da                	add    %ebx,%edx
801039eb:	01 d2                	add    %edx,%edx
801039ed:	01 da                	add    %ebx,%edx
801039ef:	89 d1                	mov    %edx,%ecx
801039f1:	c1 e1 04             	shl    $0x4,%ecx
801039f4:	8d 91 40 1d 11 80    	lea    -0x7feee2c0(%ecx),%edx
801039fa:	b9 1c 00 00 00       	mov    $0x1c,%ecx
801039ff:	89 c7                	mov    %eax,%edi
80103a01:	89 d6                	mov    %edx,%esi
80103a03:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
                hist_array[j + 1] = temp;
80103a05:	8d b5 78 ff ff ff    	lea    -0x88(%ebp),%esi
80103a0b:	b9 1c 00 00 00       	mov    $0x1c,%ecx
80103a10:	89 d7                	mov    %edx,%edi
80103a12:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
80103a14:	e9 55 ff ff ff       	jmp    8010396e <proc_get_history+0x1c>
    for (int i = 0; i < history_count - 1; i++)
80103a19:	ff 85 74 ff ff ff    	incl   -0x8c(%ebp)
80103a1f:	a1 00 49 11 80       	mov    0x80114900,%eax
80103a24:	89 85 70 ff ff ff    	mov    %eax,-0x90(%ebp)
80103a2a:	48                   	dec    %eax
80103a2b:	8b 9d 74 ff ff ff    	mov    -0x8c(%ebp),%ebx
80103a31:	39 d8                	cmp    %ebx,%eax
80103a33:	7e 0a                	jle    80103a3f <proc_get_history+0xed>
        for (int j = 0; j < history_count - i - 1; j++)
80103a35:	ba 00 00 00 00       	mov    $0x0,%edx
80103a3a:	e9 31 ff ff ff       	jmp    80103970 <proc_get_history+0x1e>
            }
        }
    }

    for (int i = 0; i < history_count; i++)
80103a3f:	bb 00 00 00 00       	mov    $0x0,%ebx
80103a44:	eb 4a                	jmp    80103a90 <proc_get_history+0x13e>
    {
        cprintf("%d ", hist_array[i].pid);
80103a46:	83 ec 08             	sub    $0x8,%esp
80103a49:	8d 04 1b             	lea    (%ebx,%ebx,1),%eax
80103a4c:	01 d8                	add    %ebx,%eax
80103a4e:	01 c0                	add    %eax,%eax
80103a50:	01 d8                	add    %ebx,%eax
80103a52:	c1 e0 04             	shl    $0x4,%eax
80103a55:	8d b0 40 1d 11 80    	lea    -0x7feee2c0(%eax),%esi
80103a5b:	ff b0 40 1d 11 80    	pushl  -0x7feee2c0(%eax)
80103a61:	68 f8 6d 10 80       	push   $0x80106df8
80103a66:	e8 74 cb ff ff       	call   801005df <cprintf>
        cprintf("%s ", hist_array[i].proc_name);
80103a6b:	8d 46 04             	lea    0x4(%esi),%eax
80103a6e:	83 c4 08             	add    $0x8,%esp
80103a71:	50                   	push   %eax
80103a72:	68 fc 6d 10 80       	push   $0x80106dfc
80103a77:	e8 63 cb ff ff       	call   801005df <cprintf>
        cprintf("%d\n", hist_array[i].mem_util);
80103a7c:	83 c4 08             	add    $0x8,%esp
80103a7f:	ff 76 68             	pushl  0x68(%esi)
80103a82:	68 f4 6c 10 80       	push   $0x80106cf4
80103a87:	e8 53 cb ff ff       	call   801005df <cprintf>
    for (int i = 0; i < history_count; i++)
80103a8c:	43                   	inc    %ebx
80103a8d:	83 c4 10             	add    $0x10,%esp
80103a90:	a1 00 49 11 80       	mov    0x80114900,%eax
80103a95:	39 d8                	cmp    %ebx,%eax
80103a97:	7f ad                	jg     80103a46 <proc_get_history+0xf4>
    }

    return history_count;
}
80103a99:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a9c:	5b                   	pop    %ebx
80103a9d:	5e                   	pop    %esi
80103a9e:	5f                   	pop    %edi
80103a9f:	5d                   	pop    %ebp
80103aa0:	c3                   	ret    

80103aa1 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103aa1:	55                   	push   %ebp
80103aa2:	89 e5                	mov    %esp,%ebp
80103aa4:	53                   	push   %ebx
80103aa5:	83 ec 0c             	sub    $0xc,%esp
80103aa8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103aab:	68 6c 6e 10 80       	push   $0x80106e6c
80103ab0:	8d 43 04             	lea    0x4(%ebx),%eax
80103ab3:	50                   	push   %eax
80103ab4:	e8 f3 00 00 00       	call   80103bac <initlock>
  lk->name = name;
80103ab9:	8b 45 0c             	mov    0xc(%ebp),%eax
80103abc:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103abf:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103ac5:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103acc:	83 c4 10             	add    $0x10,%esp
80103acf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ad2:	c9                   	leave  
80103ad3:	c3                   	ret    

80103ad4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103ad4:	55                   	push   %ebp
80103ad5:	89 e5                	mov    %esp,%ebp
80103ad7:	56                   	push   %esi
80103ad8:	53                   	push   %ebx
80103ad9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103adc:	8d 73 04             	lea    0x4(%ebx),%esi
80103adf:	83 ec 0c             	sub    $0xc,%esp
80103ae2:	56                   	push   %esi
80103ae3:	e8 04 02 00 00       	call   80103cec <acquire>
  while (lk->locked) {
80103ae8:	83 c4 10             	add    $0x10,%esp
80103aeb:	eb 0d                	jmp    80103afa <acquiresleep+0x26>
    sleep(lk, &lk->lk);
80103aed:	83 ec 08             	sub    $0x8,%esp
80103af0:	56                   	push   %esi
80103af1:	53                   	push   %ebx
80103af2:	e8 4b fa ff ff       	call   80103542 <sleep>
80103af7:	83 c4 10             	add    $0x10,%esp
  while (lk->locked) {
80103afa:	83 3b 00             	cmpl   $0x0,(%ebx)
80103afd:	75 ee                	jne    80103aed <acquiresleep+0x19>
  }
  lk->locked = 1;
80103aff:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103b05:	e8 5d f6 ff ff       	call   80103167 <myproc>
80103b0a:	8b 40 10             	mov    0x10(%eax),%eax
80103b0d:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103b10:	83 ec 0c             	sub    $0xc,%esp
80103b13:	56                   	push   %esi
80103b14:	e8 38 02 00 00       	call   80103d51 <release>
}
80103b19:	83 c4 10             	add    $0x10,%esp
80103b1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b1f:	5b                   	pop    %ebx
80103b20:	5e                   	pop    %esi
80103b21:	5d                   	pop    %ebp
80103b22:	c3                   	ret    

80103b23 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103b23:	55                   	push   %ebp
80103b24:	89 e5                	mov    %esp,%ebp
80103b26:	56                   	push   %esi
80103b27:	53                   	push   %ebx
80103b28:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103b2b:	8d 73 04             	lea    0x4(%ebx),%esi
80103b2e:	83 ec 0c             	sub    $0xc,%esp
80103b31:	56                   	push   %esi
80103b32:	e8 b5 01 00 00       	call   80103cec <acquire>
  lk->locked = 0;
80103b37:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b3d:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b44:	89 1c 24             	mov    %ebx,(%esp)
80103b47:	e8 5e fb ff ff       	call   801036aa <wakeup>
  release(&lk->lk);
80103b4c:	89 34 24             	mov    %esi,(%esp)
80103b4f:	e8 fd 01 00 00       	call   80103d51 <release>
}
80103b54:	83 c4 10             	add    $0x10,%esp
80103b57:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b5a:	5b                   	pop    %ebx
80103b5b:	5e                   	pop    %esi
80103b5c:	5d                   	pop    %ebp
80103b5d:	c3                   	ret    

80103b5e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b5e:	55                   	push   %ebp
80103b5f:	89 e5                	mov    %esp,%ebp
80103b61:	56                   	push   %esi
80103b62:	53                   	push   %ebx
80103b63:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b66:	8d 73 04             	lea    0x4(%ebx),%esi
80103b69:	83 ec 0c             	sub    $0xc,%esp
80103b6c:	56                   	push   %esi
80103b6d:	e8 7a 01 00 00       	call   80103cec <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b72:	83 c4 10             	add    $0x10,%esp
80103b75:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b78:	75 17                	jne    80103b91 <holdingsleep+0x33>
80103b7a:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103b7f:	83 ec 0c             	sub    $0xc,%esp
80103b82:	56                   	push   %esi
80103b83:	e8 c9 01 00 00       	call   80103d51 <release>
  return r;
}
80103b88:	89 d8                	mov    %ebx,%eax
80103b8a:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b8d:	5b                   	pop    %ebx
80103b8e:	5e                   	pop    %esi
80103b8f:	5d                   	pop    %ebp
80103b90:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103b91:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103b94:	e8 ce f5 ff ff       	call   80103167 <myproc>
80103b99:	3b 58 10             	cmp    0x10(%eax),%ebx
80103b9c:	74 07                	je     80103ba5 <holdingsleep+0x47>
80103b9e:	bb 00 00 00 00       	mov    $0x0,%ebx
80103ba3:	eb da                	jmp    80103b7f <holdingsleep+0x21>
80103ba5:	bb 01 00 00 00       	mov    $0x1,%ebx
80103baa:	eb d3                	jmp    80103b7f <holdingsleep+0x21>

80103bac <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103bac:	55                   	push   %ebp
80103bad:	89 e5                	mov    %esp,%ebp
80103baf:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
80103bb5:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103bb8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103bbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103bc5:	5d                   	pop    %ebp
80103bc6:	c3                   	ret    

80103bc7 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103bc7:	55                   	push   %ebp
80103bc8:	89 e5                	mov    %esp,%ebp
80103bca:	53                   	push   %ebx
80103bcb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103bce:	8b 45 08             	mov    0x8(%ebp),%eax
80103bd1:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103bd4:	b8 00 00 00 00       	mov    $0x0,%eax
80103bd9:	83 f8 09             	cmp    $0x9,%eax
80103bdc:	7f 21                	jg     80103bff <getcallerpcs+0x38>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bde:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103be4:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bea:	77 13                	ja     80103bff <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bec:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bef:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bf2:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bf4:	40                   	inc    %eax
80103bf5:	eb e2                	jmp    80103bd9 <getcallerpcs+0x12>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103bf7:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103bfe:	40                   	inc    %eax
80103bff:	83 f8 09             	cmp    $0x9,%eax
80103c02:	7e f3                	jle    80103bf7 <getcallerpcs+0x30>
}
80103c04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c07:	c9                   	leave  
80103c08:	c3                   	ret    

80103c09 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103c09:	55                   	push   %ebp
80103c0a:	89 e5                	mov    %esp,%ebp
80103c0c:	53                   	push   %ebx
80103c0d:	83 ec 04             	sub    $0x4,%esp
80103c10:	9c                   	pushf  
80103c11:	5b                   	pop    %ebx
  asm volatile("cli");
80103c12:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103c13:	e8 ba f4 ff ff       	call   801030d2 <mycpu>
80103c18:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c1f:	74 19                	je     80103c3a <pushcli+0x31>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c21:	e8 ac f4 ff ff       	call   801030d2 <mycpu>
80103c26:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c2c:	8d 51 01             	lea    0x1(%ecx),%edx
80103c2f:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
}
80103c35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c38:	c9                   	leave  
80103c39:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c3a:	e8 93 f4 ff ff       	call   801030d2 <mycpu>
80103c3f:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c45:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c4b:	eb d4                	jmp    80103c21 <pushcli+0x18>

80103c4d <popcli>:

void
popcli(void)
{
80103c4d:	55                   	push   %ebp
80103c4e:	89 e5                	mov    %esp,%ebp
80103c50:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c53:	9c                   	pushf  
80103c54:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c55:	f6 c4 02             	test   $0x2,%ah
80103c58:	75 28                	jne    80103c82 <popcli+0x35>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c5a:	e8 73 f4 ff ff       	call   801030d2 <mycpu>
80103c5f:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c65:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c68:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c6e:	85 d2                	test   %edx,%edx
80103c70:	78 1d                	js     80103c8f <popcli+0x42>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c72:	e8 5b f4 ff ff       	call   801030d2 <mycpu>
80103c77:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c7e:	74 1c                	je     80103c9c <popcli+0x4f>
    sti();
}
80103c80:	c9                   	leave  
80103c81:	c3                   	ret    
    panic("popcli - interruptible");
80103c82:	83 ec 0c             	sub    $0xc,%esp
80103c85:	68 77 6e 10 80       	push   $0x80106e77
80103c8a:	e8 b5 c6 ff ff       	call   80100344 <panic>
    panic("popcli");
80103c8f:	83 ec 0c             	sub    $0xc,%esp
80103c92:	68 8e 6e 10 80       	push   $0x80106e8e
80103c97:	e8 a8 c6 ff ff       	call   80100344 <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c9c:	e8 31 f4 ff ff       	call   801030d2 <mycpu>
80103ca1:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103ca8:	74 d6                	je     80103c80 <popcli+0x33>
  asm volatile("sti");
80103caa:	fb                   	sti    
}
80103cab:	eb d3                	jmp    80103c80 <popcli+0x33>

80103cad <holding>:
{
80103cad:	55                   	push   %ebp
80103cae:	89 e5                	mov    %esp,%ebp
80103cb0:	53                   	push   %ebx
80103cb1:	83 ec 04             	sub    $0x4,%esp
80103cb4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103cb7:	e8 4d ff ff ff       	call   80103c09 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103cbc:	83 3b 00             	cmpl   $0x0,(%ebx)
80103cbf:	75 11                	jne    80103cd2 <holding+0x25>
80103cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103cc6:	e8 82 ff ff ff       	call   80103c4d <popcli>
}
80103ccb:	89 d8                	mov    %ebx,%eax
80103ccd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103cd0:	c9                   	leave  
80103cd1:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103cd2:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103cd5:	e8 f8 f3 ff ff       	call   801030d2 <mycpu>
80103cda:	39 c3                	cmp    %eax,%ebx
80103cdc:	74 07                	je     80103ce5 <holding+0x38>
80103cde:	bb 00 00 00 00       	mov    $0x0,%ebx
80103ce3:	eb e1                	jmp    80103cc6 <holding+0x19>
80103ce5:	bb 01 00 00 00       	mov    $0x1,%ebx
80103cea:	eb da                	jmp    80103cc6 <holding+0x19>

80103cec <acquire>:
{
80103cec:	55                   	push   %ebp
80103ced:	89 e5                	mov    %esp,%ebp
80103cef:	53                   	push   %ebx
80103cf0:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103cf3:	e8 11 ff ff ff       	call   80103c09 <pushcli>
  if(holding(lk))
80103cf8:	83 ec 0c             	sub    $0xc,%esp
80103cfb:	ff 75 08             	pushl  0x8(%ebp)
80103cfe:	e8 aa ff ff ff       	call   80103cad <holding>
80103d03:	83 c4 10             	add    $0x10,%esp
80103d06:	85 c0                	test   %eax,%eax
80103d08:	75 3a                	jne    80103d44 <acquire+0x58>
  while(xchg(&lk->locked, 1) != 0)
80103d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103d0d:	b8 01 00 00 00       	mov    $0x1,%eax
80103d12:	f0 87 02             	lock xchg %eax,(%edx)
80103d15:	85 c0                	test   %eax,%eax
80103d17:	75 f1                	jne    80103d0a <acquire+0x1e>
  __sync_synchronize();
80103d19:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d1e:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d21:	e8 ac f3 ff ff       	call   801030d2 <mycpu>
80103d26:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d29:	8b 45 08             	mov    0x8(%ebp),%eax
80103d2c:	83 c0 0c             	add    $0xc,%eax
80103d2f:	83 ec 08             	sub    $0x8,%esp
80103d32:	50                   	push   %eax
80103d33:	8d 45 08             	lea    0x8(%ebp),%eax
80103d36:	50                   	push   %eax
80103d37:	e8 8b fe ff ff       	call   80103bc7 <getcallerpcs>
}
80103d3c:	83 c4 10             	add    $0x10,%esp
80103d3f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d42:	c9                   	leave  
80103d43:	c3                   	ret    
    panic("acquire");
80103d44:	83 ec 0c             	sub    $0xc,%esp
80103d47:	68 95 6e 10 80       	push   $0x80106e95
80103d4c:	e8 f3 c5 ff ff       	call   80100344 <panic>

80103d51 <release>:
{
80103d51:	55                   	push   %ebp
80103d52:	89 e5                	mov    %esp,%ebp
80103d54:	53                   	push   %ebx
80103d55:	83 ec 10             	sub    $0x10,%esp
80103d58:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d5b:	53                   	push   %ebx
80103d5c:	e8 4c ff ff ff       	call   80103cad <holding>
80103d61:	83 c4 10             	add    $0x10,%esp
80103d64:	85 c0                	test   %eax,%eax
80103d66:	74 23                	je     80103d8b <release+0x3a>
  lk->pcs[0] = 0;
80103d68:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d6f:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d76:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d7b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d81:	e8 c7 fe ff ff       	call   80103c4d <popcli>
}
80103d86:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d89:	c9                   	leave  
80103d8a:	c3                   	ret    
    panic("release");
80103d8b:	83 ec 0c             	sub    $0xc,%esp
80103d8e:	68 9d 6e 10 80       	push   $0x80106e9d
80103d93:	e8 ac c5 ff ff       	call   80100344 <panic>

80103d98 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d98:	55                   	push   %ebp
80103d99:	89 e5                	mov    %esp,%ebp
80103d9b:	57                   	push   %edi
80103d9c:	53                   	push   %ebx
80103d9d:	8b 55 08             	mov    0x8(%ebp),%edx
80103da0:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
80103da3:	f6 c2 03             	test   $0x3,%dl
80103da6:	75 29                	jne    80103dd1 <memset+0x39>
80103da8:	f6 45 10 03          	testb  $0x3,0x10(%ebp)
80103dac:	75 23                	jne    80103dd1 <memset+0x39>
    c &= 0xFF;
80103dae:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103db1:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103db4:	c1 e9 02             	shr    $0x2,%ecx
80103db7:	c1 e0 18             	shl    $0x18,%eax
80103dba:	89 fb                	mov    %edi,%ebx
80103dbc:	c1 e3 10             	shl    $0x10,%ebx
80103dbf:	09 d8                	or     %ebx,%eax
80103dc1:	89 fb                	mov    %edi,%ebx
80103dc3:	c1 e3 08             	shl    $0x8,%ebx
80103dc6:	09 d8                	or     %ebx,%eax
80103dc8:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103dca:	89 d7                	mov    %edx,%edi
80103dcc:	fc                   	cld    
80103dcd:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103dcf:	eb 08                	jmp    80103dd9 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103dd1:	89 d7                	mov    %edx,%edi
80103dd3:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103dd6:	fc                   	cld    
80103dd7:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103dd9:	89 d0                	mov    %edx,%eax
80103ddb:	5b                   	pop    %ebx
80103ddc:	5f                   	pop    %edi
80103ddd:	5d                   	pop    %ebp
80103dde:	c3                   	ret    

80103ddf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103ddf:	55                   	push   %ebp
80103de0:	89 e5                	mov    %esp,%ebp
80103de2:	56                   	push   %esi
80103de3:	53                   	push   %ebx
80103de4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103de7:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dea:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103ded:	eb 04                	jmp    80103df3 <memcmp+0x14>
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80103def:	41                   	inc    %ecx
80103df0:	42                   	inc    %edx
  while(n-- > 0){
80103df1:	89 f0                	mov    %esi,%eax
80103df3:	8d 70 ff             	lea    -0x1(%eax),%esi
80103df6:	85 c0                	test   %eax,%eax
80103df8:	74 10                	je     80103e0a <memcmp+0x2b>
    if(*s1 != *s2)
80103dfa:	8a 01                	mov    (%ecx),%al
80103dfc:	8a 1a                	mov    (%edx),%bl
80103dfe:	38 d8                	cmp    %bl,%al
80103e00:	74 ed                	je     80103def <memcmp+0x10>
      return *s1 - *s2;
80103e02:	0f b6 c0             	movzbl %al,%eax
80103e05:	0f b6 db             	movzbl %bl,%ebx
80103e08:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103e0a:	5b                   	pop    %ebx
80103e0b:	5e                   	pop    %esi
80103e0c:	5d                   	pop    %ebp
80103e0d:	c3                   	ret    

80103e0e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e0e:	55                   	push   %ebp
80103e0f:	89 e5                	mov    %esp,%ebp
80103e11:	56                   	push   %esi
80103e12:	53                   	push   %ebx
80103e13:	8b 75 08             	mov    0x8(%ebp),%esi
80103e16:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e19:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e1c:	39 f2                	cmp    %esi,%edx
80103e1e:	73 36                	jae    80103e56 <memmove+0x48>
80103e20:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e23:	39 ce                	cmp    %ecx,%esi
80103e25:	73 33                	jae    80103e5a <memmove+0x4c>
    s += n;
    d += n;
80103e27:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e2a:	eb 08                	jmp    80103e34 <memmove+0x26>
      *--d = *--s;
80103e2c:	49                   	dec    %ecx
80103e2d:	4a                   	dec    %edx
80103e2e:	8a 01                	mov    (%ecx),%al
80103e30:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e32:	89 d8                	mov    %ebx,%eax
80103e34:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e37:	85 c0                	test   %eax,%eax
80103e39:	75 f1                	jne    80103e2c <memmove+0x1e>
80103e3b:	eb 13                	jmp    80103e50 <memmove+0x42>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e3d:	8a 02                	mov    (%edx),%al
80103e3f:	88 01                	mov    %al,(%ecx)
80103e41:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e44:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e47:	89 d8                	mov    %ebx,%eax
80103e49:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e4c:	85 c0                	test   %eax,%eax
80103e4e:	75 ed                	jne    80103e3d <memmove+0x2f>

  return dst;
}
80103e50:	89 f0                	mov    %esi,%eax
80103e52:	5b                   	pop    %ebx
80103e53:	5e                   	pop    %esi
80103e54:	5d                   	pop    %ebp
80103e55:	c3                   	ret    
80103e56:	89 f1                	mov    %esi,%ecx
80103e58:	eb ef                	jmp    80103e49 <memmove+0x3b>
80103e5a:	89 f1                	mov    %esi,%ecx
80103e5c:	eb eb                	jmp    80103e49 <memmove+0x3b>

80103e5e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e5e:	55                   	push   %ebp
80103e5f:	89 e5                	mov    %esp,%ebp
80103e61:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e64:	ff 75 10             	pushl  0x10(%ebp)
80103e67:	ff 75 0c             	pushl  0xc(%ebp)
80103e6a:	ff 75 08             	pushl  0x8(%ebp)
80103e6d:	e8 9c ff ff ff       	call   80103e0e <memmove>
}
80103e72:	c9                   	leave  
80103e73:	c3                   	ret    

80103e74 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e74:	55                   	push   %ebp
80103e75:	89 e5                	mov    %esp,%ebp
80103e77:	53                   	push   %ebx
80103e78:	8b 55 08             	mov    0x8(%ebp),%edx
80103e7b:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e81:	eb 03                	jmp    80103e86 <strncmp+0x12>
    n--, p++, q++;
80103e83:	48                   	dec    %eax
80103e84:	42                   	inc    %edx
80103e85:	41                   	inc    %ecx
  while(n > 0 && *p && *p == *q)
80103e86:	85 c0                	test   %eax,%eax
80103e88:	74 0a                	je     80103e94 <strncmp+0x20>
80103e8a:	8a 1a                	mov    (%edx),%bl
80103e8c:	84 db                	test   %bl,%bl
80103e8e:	74 04                	je     80103e94 <strncmp+0x20>
80103e90:	3a 19                	cmp    (%ecx),%bl
80103e92:	74 ef                	je     80103e83 <strncmp+0xf>
  if(n == 0)
80103e94:	85 c0                	test   %eax,%eax
80103e96:	74 0d                	je     80103ea5 <strncmp+0x31>
    return 0;
  return (uchar)*p - (uchar)*q;
80103e98:	0f b6 02             	movzbl (%edx),%eax
80103e9b:	0f b6 11             	movzbl (%ecx),%edx
80103e9e:	29 d0                	sub    %edx,%eax
}
80103ea0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ea3:	c9                   	leave  
80103ea4:	c3                   	ret    
    return 0;
80103ea5:	b8 00 00 00 00       	mov    $0x0,%eax
80103eaa:	eb f4                	jmp    80103ea0 <strncmp+0x2c>

80103eac <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103eac:	55                   	push   %ebp
80103ead:	89 e5                	mov    %esp,%ebp
80103eaf:	57                   	push   %edi
80103eb0:	56                   	push   %esi
80103eb1:	53                   	push   %ebx
80103eb2:	8b 45 08             	mov    0x8(%ebp),%eax
80103eb5:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103eb8:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103ebb:	89 c1                	mov    %eax,%ecx
80103ebd:	eb 04                	jmp    80103ec3 <strncpy+0x17>
80103ebf:	89 fb                	mov    %edi,%ebx
80103ec1:	89 f1                	mov    %esi,%ecx
80103ec3:	89 d6                	mov    %edx,%esi
80103ec5:	4a                   	dec    %edx
80103ec6:	85 f6                	test   %esi,%esi
80103ec8:	7e 10                	jle    80103eda <strncpy+0x2e>
80103eca:	8d 7b 01             	lea    0x1(%ebx),%edi
80103ecd:	8d 71 01             	lea    0x1(%ecx),%esi
80103ed0:	8a 1b                	mov    (%ebx),%bl
80103ed2:	88 19                	mov    %bl,(%ecx)
80103ed4:	84 db                	test   %bl,%bl
80103ed6:	75 e7                	jne    80103ebf <strncpy+0x13>
80103ed8:	89 f1                	mov    %esi,%ecx
    ;
  while(n-- > 0)
80103eda:	8d 5a ff             	lea    -0x1(%edx),%ebx
80103edd:	85 d2                	test   %edx,%edx
80103edf:	7e 0a                	jle    80103eeb <strncpy+0x3f>
    *s++ = 0;
80103ee1:	c6 01 00             	movb   $0x0,(%ecx)
  while(n-- > 0)
80103ee4:	89 da                	mov    %ebx,%edx
    *s++ = 0;
80103ee6:	8d 49 01             	lea    0x1(%ecx),%ecx
80103ee9:	eb ef                	jmp    80103eda <strncpy+0x2e>
  return os;
}
80103eeb:	5b                   	pop    %ebx
80103eec:	5e                   	pop    %esi
80103eed:	5f                   	pop    %edi
80103eee:	5d                   	pop    %ebp
80103eef:	c3                   	ret    

80103ef0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103ef0:	55                   	push   %ebp
80103ef1:	89 e5                	mov    %esp,%ebp
80103ef3:	57                   	push   %edi
80103ef4:	56                   	push   %esi
80103ef5:	53                   	push   %ebx
80103ef6:	8b 45 08             	mov    0x8(%ebp),%eax
80103ef9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80103efc:	8b 55 10             	mov    0x10(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
80103eff:	85 d2                	test   %edx,%edx
80103f01:	7e 20                	jle    80103f23 <safestrcpy+0x33>
80103f03:	89 c1                	mov    %eax,%ecx
80103f05:	eb 04                	jmp    80103f0b <safestrcpy+0x1b>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f07:	89 fb                	mov    %edi,%ebx
80103f09:	89 f1                	mov    %esi,%ecx
80103f0b:	4a                   	dec    %edx
80103f0c:	85 d2                	test   %edx,%edx
80103f0e:	7e 10                	jle    80103f20 <safestrcpy+0x30>
80103f10:	8d 7b 01             	lea    0x1(%ebx),%edi
80103f13:	8d 71 01             	lea    0x1(%ecx),%esi
80103f16:	8a 1b                	mov    (%ebx),%bl
80103f18:	88 19                	mov    %bl,(%ecx)
80103f1a:	84 db                	test   %bl,%bl
80103f1c:	75 e9                	jne    80103f07 <safestrcpy+0x17>
80103f1e:	89 f1                	mov    %esi,%ecx
    ;
  *s = 0;
80103f20:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80103f23:	5b                   	pop    %ebx
80103f24:	5e                   	pop    %esi
80103f25:	5f                   	pop    %edi
80103f26:	5d                   	pop    %ebp
80103f27:	c3                   	ret    

80103f28 <strlen>:

int
strlen(const char *s)
{
80103f28:	55                   	push   %ebp
80103f29:	89 e5                	mov    %esp,%ebp
80103f2b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f2e:	b8 00 00 00 00       	mov    $0x0,%eax
80103f33:	eb 01                	jmp    80103f36 <strlen+0xe>
80103f35:	40                   	inc    %eax
80103f36:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f3a:	75 f9                	jne    80103f35 <strlen+0xd>
    ;
  return n;
}
80103f3c:	5d                   	pop    %ebp
80103f3d:	c3                   	ret    

80103f3e <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f3e:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f42:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f46:	55                   	push   %ebp
  pushl %ebx
80103f47:	53                   	push   %ebx
  pushl %esi
80103f48:	56                   	push   %esi
  pushl %edi
80103f49:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f4a:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f4c:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f4e:	5f                   	pop    %edi
  popl %esi
80103f4f:	5e                   	pop    %esi
  popl %ebx
80103f50:	5b                   	pop    %ebx
  popl %ebp
80103f51:	5d                   	pop    %ebp
  ret
80103f52:	c3                   	ret    

80103f53 <fetchint>:
// library system call function. The saved user %esp points
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int fetchint(uint addr, int *ip)
{
80103f53:	55                   	push   %ebp
80103f54:	89 e5                	mov    %esp,%ebp
80103f56:	53                   	push   %ebx
80103f57:	83 ec 04             	sub    $0x4,%esp
80103f5a:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct proc *curproc = myproc();
80103f5d:	e8 05 f2 ff ff       	call   80103167 <myproc>

    if (addr >= curproc->sz || addr + 4 > curproc->sz)
80103f62:	8b 00                	mov    (%eax),%eax
80103f64:	39 c3                	cmp    %eax,%ebx
80103f66:	73 18                	jae    80103f80 <fetchint+0x2d>
80103f68:	8d 53 04             	lea    0x4(%ebx),%edx
80103f6b:	39 d0                	cmp    %edx,%eax
80103f6d:	72 18                	jb     80103f87 <fetchint+0x34>
        return -1;
    *ip = *(int *)(addr);
80103f6f:	8b 13                	mov    (%ebx),%edx
80103f71:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f74:	89 10                	mov    %edx,(%eax)
    return 0;
80103f76:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103f7b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f7e:	c9                   	leave  
80103f7f:	c3                   	ret    
        return -1;
80103f80:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f85:	eb f4                	jmp    80103f7b <fetchint+0x28>
80103f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103f8c:	eb ed                	jmp    80103f7b <fetchint+0x28>

80103f8e <fetchstr>:

// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int fetchstr(uint addr, char **pp)
{
80103f8e:	55                   	push   %ebp
80103f8f:	89 e5                	mov    %esp,%ebp
80103f91:	53                   	push   %ebx
80103f92:	83 ec 04             	sub    $0x4,%esp
80103f95:	8b 5d 08             	mov    0x8(%ebp),%ebx
    char *s, *ep;
    struct proc *curproc = myproc();
80103f98:	e8 ca f1 ff ff       	call   80103167 <myproc>

    if (addr >= curproc->sz)
80103f9d:	3b 18                	cmp    (%eax),%ebx
80103f9f:	73 23                	jae    80103fc4 <fetchstr+0x36>
        return -1;
    *pp = (char *)addr;
80103fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fa4:	89 1a                	mov    %ebx,(%edx)
    ep = (char *)curproc->sz;
80103fa6:	8b 10                	mov    (%eax),%edx
    for (s = *pp; s < ep; s++)
80103fa8:	89 d8                	mov    %ebx,%eax
80103faa:	eb 01                	jmp    80103fad <fetchstr+0x1f>
80103fac:	40                   	inc    %eax
80103fad:	39 d0                	cmp    %edx,%eax
80103faf:	73 09                	jae    80103fba <fetchstr+0x2c>
    {
        if (*s == 0)
80103fb1:	80 38 00             	cmpb   $0x0,(%eax)
80103fb4:	75 f6                	jne    80103fac <fetchstr+0x1e>
            return s - *pp;
80103fb6:	29 d8                	sub    %ebx,%eax
80103fb8:	eb 05                	jmp    80103fbf <fetchstr+0x31>
    }
    return -1;
80103fba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fbf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc2:	c9                   	leave  
80103fc3:	c3                   	ret    
        return -1;
80103fc4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fc9:	eb f4                	jmp    80103fbf <fetchstr+0x31>

80103fcb <argint>:

// Fetch the nth 32-bit system call argument.
int argint(int n, int *ip)
{
80103fcb:	55                   	push   %ebp
80103fcc:	89 e5                	mov    %esp,%ebp
80103fce:	83 ec 08             	sub    $0x8,%esp
    return fetchint((myproc()->tf->esp) + 4 + 4 * n, ip);
80103fd1:	e8 91 f1 ff ff       	call   80103167 <myproc>
80103fd6:	8b 50 18             	mov    0x18(%eax),%edx
80103fd9:	8b 45 08             	mov    0x8(%ebp),%eax
80103fdc:	c1 e0 02             	shl    $0x2,%eax
80103fdf:	03 42 44             	add    0x44(%edx),%eax
80103fe2:	83 ec 08             	sub    $0x8,%esp
80103fe5:	ff 75 0c             	pushl  0xc(%ebp)
80103fe8:	83 c0 04             	add    $0x4,%eax
80103feb:	50                   	push   %eax
80103fec:	e8 62 ff ff ff       	call   80103f53 <fetchint>
}
80103ff1:	c9                   	leave  
80103ff2:	c3                   	ret    

80103ff3 <argptr>:

// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int argptr(int n, char **pp, int size)
{
80103ff3:	55                   	push   %ebp
80103ff4:	89 e5                	mov    %esp,%ebp
80103ff6:	56                   	push   %esi
80103ff7:	53                   	push   %ebx
80103ff8:	83 ec 10             	sub    $0x10,%esp
80103ffb:	8b 5d 10             	mov    0x10(%ebp),%ebx
    int i;
    struct proc *curproc = myproc();
80103ffe:	e8 64 f1 ff ff       	call   80103167 <myproc>
80104003:	89 c6                	mov    %eax,%esi

    if (argint(n, &i) < 0)
80104005:	83 ec 08             	sub    $0x8,%esp
80104008:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010400b:	50                   	push   %eax
8010400c:	ff 75 08             	pushl  0x8(%ebp)
8010400f:	e8 b7 ff ff ff       	call   80103fcb <argint>
80104014:	83 c4 10             	add    $0x10,%esp
80104017:	85 c0                	test   %eax,%eax
80104019:	78 24                	js     8010403f <argptr+0x4c>
        return -1;
    if (size < 0 || (uint)i >= curproc->sz || (uint)i + size > curproc->sz)
8010401b:	85 db                	test   %ebx,%ebx
8010401d:	78 27                	js     80104046 <argptr+0x53>
8010401f:	8b 16                	mov    (%esi),%edx
80104021:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104024:	39 d0                	cmp    %edx,%eax
80104026:	73 25                	jae    8010404d <argptr+0x5a>
80104028:	01 c3                	add    %eax,%ebx
8010402a:	39 da                	cmp    %ebx,%edx
8010402c:	72 26                	jb     80104054 <argptr+0x61>
        return -1;
    *pp = (char *)i;
8010402e:	8b 55 0c             	mov    0xc(%ebp),%edx
80104031:	89 02                	mov    %eax,(%edx)
    return 0;
80104033:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104038:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010403b:	5b                   	pop    %ebx
8010403c:	5e                   	pop    %esi
8010403d:	5d                   	pop    %ebp
8010403e:	c3                   	ret    
        return -1;
8010403f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104044:	eb f2                	jmp    80104038 <argptr+0x45>
        return -1;
80104046:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010404b:	eb eb                	jmp    80104038 <argptr+0x45>
8010404d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104052:	eb e4                	jmp    80104038 <argptr+0x45>
80104054:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104059:	eb dd                	jmp    80104038 <argptr+0x45>

8010405b <argstr>:
// Fetch the nth word-sized system call argument as a string pointer.
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int argstr(int n, char **pp)
{
8010405b:	55                   	push   %ebp
8010405c:	89 e5                	mov    %esp,%ebp
8010405e:	83 ec 20             	sub    $0x20,%esp
    int addr;
    if (argint(n, &addr) < 0)
80104061:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104064:	50                   	push   %eax
80104065:	ff 75 08             	pushl  0x8(%ebp)
80104068:	e8 5e ff ff ff       	call   80103fcb <argint>
8010406d:	83 c4 10             	add    $0x10,%esp
80104070:	85 c0                	test   %eax,%eax
80104072:	78 13                	js     80104087 <argstr+0x2c>
        return -1;
    return fetchstr(addr, pp);
80104074:	83 ec 08             	sub    $0x8,%esp
80104077:	ff 75 0c             	pushl  0xc(%ebp)
8010407a:	ff 75 f4             	pushl  -0xc(%ebp)
8010407d:	e8 0c ff ff ff       	call   80103f8e <fetchstr>
80104082:	83 c4 10             	add    $0x10,%esp
}
80104085:	c9                   	leave  
80104086:	c3                   	ret    
        return -1;
80104087:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010408c:	eb f7                	jmp    80104085 <argstr+0x2a>

8010408e <syscall>:
    [SYS_chmod] sys_chmod,
    ////////////////////////////////////////////////////////////////////////
};

void syscall(void)
{
8010408e:	55                   	push   %ebp
8010408f:	89 e5                	mov    %esp,%ebp
80104091:	53                   	push   %ebx
80104092:	83 ec 04             	sub    $0x4,%esp
    int num;
    struct proc *curproc = myproc();
80104095:	e8 cd f0 ff ff       	call   80103167 <myproc>
8010409a:	89 c3                	mov    %eax,%ebx
    num = curproc->tf->eax;
8010409c:	8b 40 18             	mov    0x18(%eax),%eax
8010409f:	8b 48 1c             	mov    0x1c(%eax),%ecx

    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    int block_bit_vector = curproc->parent->block_bit_vector;
801040a2:	8b 43 14             	mov    0x14(%ebx),%eax
801040a5:	8b 80 84 00 00 00    	mov    0x84(%eax),%eax
    int is_blocked = (block_bit_vector >> num) & 1;
801040ab:	d3 f8                	sar    %cl,%eax

    if (is_blocked && (curproc->pid > 3)){
801040ad:	a8 01                	test   $0x1,%al
801040af:	74 06                	je     801040b7 <syscall+0x29>
801040b1:	83 7b 10 03          	cmpl   $0x3,0x10(%ebx)
801040b5:	7f 1f                	jg     801040d6 <syscall+0x48>
        return;
    }
    /////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////


    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
801040b7:	8d 41 ff             	lea    -0x1(%ecx),%eax
801040ba:	83 f8 18             	cmp    $0x18,%eax
801040bd:	77 2a                	ja     801040e9 <syscall+0x5b>
801040bf:	8b 04 8d e0 6e 10 80 	mov    -0x7fef9120(,%ecx,4),%eax
801040c6:	85 c0                	test   %eax,%eax
801040c8:	74 1f                	je     801040e9 <syscall+0x5b>
    {
        curproc->tf->eax = syscalls[num]();
801040ca:	ff d0                	call   *%eax
801040cc:	89 c2                	mov    %eax,%edx
801040ce:	8b 43 18             	mov    0x18(%ebx),%eax
801040d1:	89 50 1c             	mov    %edx,0x1c(%eax)
801040d4:	eb 32                	jmp    80104108 <syscall+0x7a>
        cprintf("syscall %d is blocked\n", num);
801040d6:	83 ec 08             	sub    $0x8,%esp
801040d9:	51                   	push   %ecx
801040da:	68 a5 6e 10 80       	push   $0x80106ea5
801040df:	e8 fb c4 ff ff       	call   801005df <cprintf>
        return;
801040e4:	83 c4 10             	add    $0x10,%esp
801040e7:	eb 1f                	jmp    80104108 <syscall+0x7a>
    }
    else
    {
        cprintf("%d %s: unknown sys call %d\n",
                curproc->pid, curproc->name, num);
801040e9:	8d 43 6c             	lea    0x6c(%ebx),%eax
        cprintf("%d %s: unknown sys call %d\n",
801040ec:	51                   	push   %ecx
801040ed:	50                   	push   %eax
801040ee:	ff 73 10             	pushl  0x10(%ebx)
801040f1:	68 bc 6e 10 80       	push   $0x80106ebc
801040f6:	e8 e4 c4 ff ff       	call   801005df <cprintf>
        curproc->tf->eax = -1;
801040fb:	8b 43 18             	mov    0x18(%ebx),%eax
801040fe:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
80104105:	83 c4 10             	add    $0x10,%esp
    }
}
80104108:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010410b:	c9                   	leave  
8010410c:	c3                   	ret    

8010410d <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
8010410d:	55                   	push   %ebp
8010410e:	89 e5                	mov    %esp,%ebp
80104110:	56                   	push   %esi
80104111:	53                   	push   %ebx
80104112:	83 ec 18             	sub    $0x18,%esp
80104115:	89 d6                	mov    %edx,%esi
80104117:	89 cb                	mov    %ecx,%ebx
    int fd;
    struct file *f;

    if (argint(n, &fd) < 0)
80104119:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010411c:	52                   	push   %edx
8010411d:	50                   	push   %eax
8010411e:	e8 a8 fe ff ff       	call   80103fcb <argint>
80104123:	83 c4 10             	add    $0x10,%esp
80104126:	85 c0                	test   %eax,%eax
80104128:	78 35                	js     8010415f <argfd+0x52>
        return -1;
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
8010412a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010412e:	77 28                	ja     80104158 <argfd+0x4b>
80104130:	e8 32 f0 ff ff       	call   80103167 <myproc>
80104135:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104138:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
8010413c:	85 c0                	test   %eax,%eax
8010413e:	74 18                	je     80104158 <argfd+0x4b>
        return -1;
    if (pfd)
80104140:	85 f6                	test   %esi,%esi
80104142:	74 02                	je     80104146 <argfd+0x39>
        *pfd = fd;
80104144:	89 16                	mov    %edx,(%esi)
    if (pf)
80104146:	85 db                	test   %ebx,%ebx
80104148:	74 1c                	je     80104166 <argfd+0x59>
        *pf = f;
8010414a:	89 03                	mov    %eax,(%ebx)
    return 0;
8010414c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104151:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104154:	5b                   	pop    %ebx
80104155:	5e                   	pop    %esi
80104156:	5d                   	pop    %ebp
80104157:	c3                   	ret    
        return -1;
80104158:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010415d:	eb f2                	jmp    80104151 <argfd+0x44>
        return -1;
8010415f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104164:	eb eb                	jmp    80104151 <argfd+0x44>
    return 0;
80104166:	b8 00 00 00 00       	mov    $0x0,%eax
8010416b:	eb e4                	jmp    80104151 <argfd+0x44>

8010416d <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
8010416d:	55                   	push   %ebp
8010416e:	89 e5                	mov    %esp,%ebp
80104170:	53                   	push   %ebx
80104171:	83 ec 04             	sub    $0x4,%esp
80104174:	89 c3                	mov    %eax,%ebx
    int fd;
    struct proc *curproc = myproc();
80104176:	e8 ec ef ff ff       	call   80103167 <myproc>
8010417b:	89 c2                	mov    %eax,%edx

    for (fd = 0; fd < NOFILE; fd++)
8010417d:	b8 00 00 00 00       	mov    $0x0,%eax
80104182:	83 f8 0f             	cmp    $0xf,%eax
80104185:	7f 10                	jg     80104197 <fdalloc+0x2a>
    {
        if (curproc->ofile[fd] == 0)
80104187:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
8010418c:	74 03                	je     80104191 <fdalloc+0x24>
    for (fd = 0; fd < NOFILE; fd++)
8010418e:	40                   	inc    %eax
8010418f:	eb f1                	jmp    80104182 <fdalloc+0x15>
        {
            curproc->ofile[fd] = f;
80104191:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
            return fd;
80104195:	eb 05                	jmp    8010419c <fdalloc+0x2f>
        }
    }
    return -1;
80104197:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010419c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010419f:	c9                   	leave  
801041a0:	c3                   	ret    

801041a1 <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801041a1:	55                   	push   %ebp
801041a2:	89 e5                	mov    %esp,%ebp
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	83 ec 10             	sub    $0x10,%esp
801041a9:	89 c3                	mov    %eax,%ebx
    int off;
    struct dirent de;

    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801041ab:	b8 20 00 00 00       	mov    $0x20,%eax
801041b0:	89 c6                	mov    %eax,%esi
801041b2:	3b 43 58             	cmp    0x58(%ebx),%eax
801041b5:	73 2e                	jae    801041e5 <isdirempty+0x44>
    {
        if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801041b7:	6a 10                	push   $0x10
801041b9:	50                   	push   %eax
801041ba:	8d 45 e8             	lea    -0x18(%ebp),%eax
801041bd:	50                   	push   %eax
801041be:	53                   	push   %ebx
801041bf:	e8 5d d5 ff ff       	call   80101721 <readi>
801041c4:	83 c4 10             	add    $0x10,%esp
801041c7:	83 f8 10             	cmp    $0x10,%eax
801041ca:	75 0c                	jne    801041d8 <isdirempty+0x37>
            panic("isdirempty: readi");
        if (de.inum != 0)
801041cc:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801041d1:	75 1e                	jne    801041f1 <isdirempty+0x50>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801041d3:	8d 46 10             	lea    0x10(%esi),%eax
801041d6:	eb d8                	jmp    801041b0 <isdirempty+0xf>
            panic("isdirempty: readi");
801041d8:	83 ec 0c             	sub    $0xc,%esp
801041db:	68 48 6f 10 80       	push   $0x80106f48
801041e0:	e8 5f c1 ff ff       	call   80100344 <panic>
            return 0;
    }
    return 1;
801041e5:	b8 01 00 00 00       	mov    $0x1,%eax
}
801041ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801041ed:	5b                   	pop    %ebx
801041ee:	5e                   	pop    %esi
801041ef:	5d                   	pop    %ebp
801041f0:	c3                   	ret    
            return 0;
801041f1:	b8 00 00 00 00       	mov    $0x0,%eax
801041f6:	eb f2                	jmp    801041ea <isdirempty+0x49>

801041f8 <create>:
    return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
801041f8:	55                   	push   %ebp
801041f9:	89 e5                	mov    %esp,%ebp
801041fb:	57                   	push   %edi
801041fc:	56                   	push   %esi
801041fd:	53                   	push   %ebx
801041fe:	83 ec 34             	sub    $0x34,%esp
80104201:	89 d7                	mov    %edx,%edi
80104203:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80104206:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104209:	89 4d d0             	mov    %ecx,-0x30(%ebp)
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
8010420c:	8d 55 da             	lea    -0x26(%ebp),%edx
8010420f:	52                   	push   %edx
80104210:	50                   	push   %eax
80104211:	e8 a2 d9 ff ff       	call   80101bb8 <nameiparent>
80104216:	89 c6                	mov    %eax,%esi
80104218:	83 c4 10             	add    $0x10,%esp
8010421b:	85 c0                	test   %eax,%eax
8010421d:	0f 84 30 01 00 00    	je     80104353 <create+0x15b>
        return 0;
    ilock(dp);
80104223:	83 ec 0c             	sub    $0xc,%esp
80104226:	50                   	push   %eax
80104227:	e8 08 d3 ff ff       	call   80101534 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
8010422c:	83 c4 0c             	add    $0xc,%esp
8010422f:	6a 00                	push   $0x0
80104231:	8d 45 da             	lea    -0x26(%ebp),%eax
80104234:	50                   	push   %eax
80104235:	56                   	push   %esi
80104236:	e8 37 d7 ff ff       	call   80101972 <dirlookup>
8010423b:	89 c3                	mov    %eax,%ebx
8010423d:	83 c4 10             	add    $0x10,%esp
80104240:	85 c0                	test   %eax,%eax
80104242:	74 3c                	je     80104280 <create+0x88>
    {
        iunlockput(dp);
80104244:	83 ec 0c             	sub    $0xc,%esp
80104247:	56                   	push   %esi
80104248:	e8 8a d4 ff ff       	call   801016d7 <iunlockput>
        ilock(ip);
8010424d:	89 1c 24             	mov    %ebx,(%esp)
80104250:	e8 df d2 ff ff       	call   80101534 <ilock>
        if (type == T_FILE && ip->type == T_FILE)
80104255:	83 c4 10             	add    $0x10,%esp
80104258:	66 83 ff 02          	cmp    $0x2,%di
8010425c:	75 07                	jne    80104265 <create+0x6d>
8010425e:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
80104263:	74 11                	je     80104276 <create+0x7e>
            return ip;
        iunlockput(ip);
80104265:	83 ec 0c             	sub    $0xc,%esp
80104268:	53                   	push   %ebx
80104269:	e8 69 d4 ff ff       	call   801016d7 <iunlockput>
        return 0;
8010426e:	83 c4 10             	add    $0x10,%esp
80104271:	bb 00 00 00 00       	mov    $0x0,%ebx
        panic("create: dirlink");

    iunlockput(dp);

    return ip;
}
80104276:	89 d8                	mov    %ebx,%eax
80104278:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010427b:	5b                   	pop    %ebx
8010427c:	5e                   	pop    %esi
8010427d:	5f                   	pop    %edi
8010427e:	5d                   	pop    %ebp
8010427f:	c3                   	ret    
    if ((ip = ialloc(dp->dev, type)) == 0)
80104280:	83 ec 08             	sub    $0x8,%esp
80104283:	0f bf c7             	movswl %di,%eax
80104286:	50                   	push   %eax
80104287:	ff 36                	pushl  (%esi)
80104289:	e8 ae d0 ff ff       	call   8010133c <ialloc>
8010428e:	89 c3                	mov    %eax,%ebx
80104290:	83 c4 10             	add    $0x10,%esp
80104293:	85 c0                	test   %eax,%eax
80104295:	74 53                	je     801042ea <create+0xf2>
    ilock(ip);
80104297:	83 ec 0c             	sub    $0xc,%esp
8010429a:	50                   	push   %eax
8010429b:	e8 94 d2 ff ff       	call   80101534 <ilock>
    ip->major = major;
801042a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801042a3:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = minor;
801042a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
801042aa:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = 1;
801042ae:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
    iupdate(ip);
801042b4:	89 1c 24             	mov    %ebx,(%esp)
801042b7:	e8 1f d1 ff ff       	call   801013db <iupdate>
    if (type == T_DIR)
801042bc:	83 c4 10             	add    $0x10,%esp
801042bf:	66 83 ff 01          	cmp    $0x1,%di
801042c3:	74 32                	je     801042f7 <create+0xff>
    if (dirlink(dp, name, ip->inum) < 0)
801042c5:	83 ec 04             	sub    $0x4,%esp
801042c8:	ff 73 04             	pushl  0x4(%ebx)
801042cb:	8d 45 da             	lea    -0x26(%ebp),%eax
801042ce:	50                   	push   %eax
801042cf:	56                   	push   %esi
801042d0:	e8 1a d8 ff ff       	call   80101aef <dirlink>
801042d5:	83 c4 10             	add    $0x10,%esp
801042d8:	85 c0                	test   %eax,%eax
801042da:	78 6a                	js     80104346 <create+0x14e>
    iunlockput(dp);
801042dc:	83 ec 0c             	sub    $0xc,%esp
801042df:	56                   	push   %esi
801042e0:	e8 f2 d3 ff ff       	call   801016d7 <iunlockput>
    return ip;
801042e5:	83 c4 10             	add    $0x10,%esp
801042e8:	eb 8c                	jmp    80104276 <create+0x7e>
        panic("create: ialloc");
801042ea:	83 ec 0c             	sub    $0xc,%esp
801042ed:	68 5a 6f 10 80       	push   $0x80106f5a
801042f2:	e8 4d c0 ff ff       	call   80100344 <panic>
        dp->nlink++; // for ".."
801042f7:	66 8b 46 56          	mov    0x56(%esi),%ax
801042fb:	40                   	inc    %eax
801042fc:	66 89 46 56          	mov    %ax,0x56(%esi)
        iupdate(dp);
80104300:	83 ec 0c             	sub    $0xc,%esp
80104303:	56                   	push   %esi
80104304:	e8 d2 d0 ff ff       	call   801013db <iupdate>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104309:	83 c4 0c             	add    $0xc,%esp
8010430c:	ff 73 04             	pushl  0x4(%ebx)
8010430f:	68 6a 6f 10 80       	push   $0x80106f6a
80104314:	53                   	push   %ebx
80104315:	e8 d5 d7 ff ff       	call   80101aef <dirlink>
8010431a:	83 c4 10             	add    $0x10,%esp
8010431d:	85 c0                	test   %eax,%eax
8010431f:	78 18                	js     80104339 <create+0x141>
80104321:	83 ec 04             	sub    $0x4,%esp
80104324:	ff 76 04             	pushl  0x4(%esi)
80104327:	68 69 6f 10 80       	push   $0x80106f69
8010432c:	53                   	push   %ebx
8010432d:	e8 bd d7 ff ff       	call   80101aef <dirlink>
80104332:	83 c4 10             	add    $0x10,%esp
80104335:	85 c0                	test   %eax,%eax
80104337:	79 8c                	jns    801042c5 <create+0xcd>
            panic("create dots");
80104339:	83 ec 0c             	sub    $0xc,%esp
8010433c:	68 6c 6f 10 80       	push   $0x80106f6c
80104341:	e8 fe bf ff ff       	call   80100344 <panic>
        panic("create: dirlink");
80104346:	83 ec 0c             	sub    $0xc,%esp
80104349:	68 78 6f 10 80       	push   $0x80106f78
8010434e:	e8 f1 bf ff ff       	call   80100344 <panic>
        return 0;
80104353:	89 c3                	mov    %eax,%ebx
80104355:	e9 1c ff ff ff       	jmp    80104276 <create+0x7e>

8010435a <sys_dup>:
{
8010435a:	55                   	push   %ebp
8010435b:	89 e5                	mov    %esp,%ebp
8010435d:	53                   	push   %ebx
8010435e:	83 ec 14             	sub    $0x14,%esp
    if (argfd(0, 0, &f) < 0)
80104361:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104364:	ba 00 00 00 00       	mov    $0x0,%edx
80104369:	b8 00 00 00 00       	mov    $0x0,%eax
8010436e:	e8 9a fd ff ff       	call   8010410d <argfd>
80104373:	85 c0                	test   %eax,%eax
80104375:	78 23                	js     8010439a <sys_dup+0x40>
    if ((fd = fdalloc(f)) < 0)
80104377:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010437a:	e8 ee fd ff ff       	call   8010416d <fdalloc>
8010437f:	89 c3                	mov    %eax,%ebx
80104381:	85 c0                	test   %eax,%eax
80104383:	78 1c                	js     801043a1 <sys_dup+0x47>
    filedup(f);
80104385:	83 ec 0c             	sub    $0xc,%esp
80104388:	ff 75 f4             	pushl  -0xc(%ebp)
8010438b:	e8 f1 c8 ff ff       	call   80100c81 <filedup>
    return fd;
80104390:	83 c4 10             	add    $0x10,%esp
}
80104393:	89 d8                	mov    %ebx,%eax
80104395:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104398:	c9                   	leave  
80104399:	c3                   	ret    
        return -1;
8010439a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010439f:	eb f2                	jmp    80104393 <sys_dup+0x39>
        return -1;
801043a1:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043a6:	eb eb                	jmp    80104393 <sys_dup+0x39>

801043a8 <sys_read>:
{
801043a8:	55                   	push   %ebp
801043a9:	89 e5                	mov    %esp,%ebp
801043ab:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043ae:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043b1:	ba 00 00 00 00       	mov    $0x0,%edx
801043b6:	b8 00 00 00 00       	mov    $0x0,%eax
801043bb:	e8 4d fd ff ff       	call   8010410d <argfd>
801043c0:	85 c0                	test   %eax,%eax
801043c2:	78 43                	js     80104407 <sys_read+0x5f>
801043c4:	83 ec 08             	sub    $0x8,%esp
801043c7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043ca:	50                   	push   %eax
801043cb:	6a 02                	push   $0x2
801043cd:	e8 f9 fb ff ff       	call   80103fcb <argint>
801043d2:	83 c4 10             	add    $0x10,%esp
801043d5:	85 c0                	test   %eax,%eax
801043d7:	78 2e                	js     80104407 <sys_read+0x5f>
801043d9:	83 ec 04             	sub    $0x4,%esp
801043dc:	ff 75 f0             	pushl  -0x10(%ebp)
801043df:	8d 45 ec             	lea    -0x14(%ebp),%eax
801043e2:	50                   	push   %eax
801043e3:	6a 01                	push   $0x1
801043e5:	e8 09 fc ff ff       	call   80103ff3 <argptr>
801043ea:	83 c4 10             	add    $0x10,%esp
801043ed:	85 c0                	test   %eax,%eax
801043ef:	78 16                	js     80104407 <sys_read+0x5f>
    return fileread(f, p, n);
801043f1:	83 ec 04             	sub    $0x4,%esp
801043f4:	ff 75 f0             	pushl  -0x10(%ebp)
801043f7:	ff 75 ec             	pushl  -0x14(%ebp)
801043fa:	ff 75 f4             	pushl  -0xc(%ebp)
801043fd:	e8 bb c9 ff ff       	call   80100dbd <fileread>
80104402:	83 c4 10             	add    $0x10,%esp
}
80104405:	c9                   	leave  
80104406:	c3                   	ret    
        return -1;
80104407:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010440c:	eb f7                	jmp    80104405 <sys_read+0x5d>

8010440e <sys_write>:
{
8010440e:	55                   	push   %ebp
8010440f:	89 e5                	mov    %esp,%ebp
80104411:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104414:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104417:	ba 00 00 00 00       	mov    $0x0,%edx
8010441c:	b8 00 00 00 00       	mov    $0x0,%eax
80104421:	e8 e7 fc ff ff       	call   8010410d <argfd>
80104426:	85 c0                	test   %eax,%eax
80104428:	78 43                	js     8010446d <sys_write+0x5f>
8010442a:	83 ec 08             	sub    $0x8,%esp
8010442d:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104430:	50                   	push   %eax
80104431:	6a 02                	push   $0x2
80104433:	e8 93 fb ff ff       	call   80103fcb <argint>
80104438:	83 c4 10             	add    $0x10,%esp
8010443b:	85 c0                	test   %eax,%eax
8010443d:	78 2e                	js     8010446d <sys_write+0x5f>
8010443f:	83 ec 04             	sub    $0x4,%esp
80104442:	ff 75 f0             	pushl  -0x10(%ebp)
80104445:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104448:	50                   	push   %eax
80104449:	6a 01                	push   $0x1
8010444b:	e8 a3 fb ff ff       	call   80103ff3 <argptr>
80104450:	83 c4 10             	add    $0x10,%esp
80104453:	85 c0                	test   %eax,%eax
80104455:	78 16                	js     8010446d <sys_write+0x5f>
    return filewrite(f, p, n);
80104457:	83 ec 04             	sub    $0x4,%esp
8010445a:	ff 75 f0             	pushl  -0x10(%ebp)
8010445d:	ff 75 ec             	pushl  -0x14(%ebp)
80104460:	ff 75 f4             	pushl  -0xc(%ebp)
80104463:	e8 da c9 ff ff       	call   80100e42 <filewrite>
80104468:	83 c4 10             	add    $0x10,%esp
}
8010446b:	c9                   	leave  
8010446c:	c3                   	ret    
        return -1;
8010446d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104472:	eb f7                	jmp    8010446b <sys_write+0x5d>

80104474 <sys_close>:
{
80104474:	55                   	push   %ebp
80104475:	89 e5                	mov    %esp,%ebp
80104477:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, &fd, &f) < 0)
8010447a:	8d 4d f0             	lea    -0x10(%ebp),%ecx
8010447d:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104480:	b8 00 00 00 00       	mov    $0x0,%eax
80104485:	e8 83 fc ff ff       	call   8010410d <argfd>
8010448a:	85 c0                	test   %eax,%eax
8010448c:	78 25                	js     801044b3 <sys_close+0x3f>
    myproc()->ofile[fd] = 0;
8010448e:	e8 d4 ec ff ff       	call   80103167 <myproc>
80104493:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104496:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
8010449d:	00 
    fileclose(f);
8010449e:	83 ec 0c             	sub    $0xc,%esp
801044a1:	ff 75 f0             	pushl  -0x10(%ebp)
801044a4:	e8 1b c8 ff ff       	call   80100cc4 <fileclose>
    return 0;
801044a9:	83 c4 10             	add    $0x10,%esp
801044ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044b1:	c9                   	leave  
801044b2:	c3                   	ret    
        return -1;
801044b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044b8:	eb f7                	jmp    801044b1 <sys_close+0x3d>

801044ba <sys_fstat>:
{
801044ba:	55                   	push   %ebp
801044bb:	89 e5                	mov    %esp,%ebp
801044bd:	83 ec 18             	sub    $0x18,%esp
    if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
801044c0:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801044c3:	ba 00 00 00 00       	mov    $0x0,%edx
801044c8:	b8 00 00 00 00       	mov    $0x0,%eax
801044cd:	e8 3b fc ff ff       	call   8010410d <argfd>
801044d2:	85 c0                	test   %eax,%eax
801044d4:	78 2a                	js     80104500 <sys_fstat+0x46>
801044d6:	83 ec 04             	sub    $0x4,%esp
801044d9:	6a 14                	push   $0x14
801044db:	8d 45 f0             	lea    -0x10(%ebp),%eax
801044de:	50                   	push   %eax
801044df:	6a 01                	push   $0x1
801044e1:	e8 0d fb ff ff       	call   80103ff3 <argptr>
801044e6:	83 c4 10             	add    $0x10,%esp
801044e9:	85 c0                	test   %eax,%eax
801044eb:	78 13                	js     80104500 <sys_fstat+0x46>
    return filestat(f, st);
801044ed:	83 ec 08             	sub    $0x8,%esp
801044f0:	ff 75 f0             	pushl  -0x10(%ebp)
801044f3:	ff 75 f4             	pushl  -0xc(%ebp)
801044f6:	e8 7b c8 ff ff       	call   80100d76 <filestat>
801044fb:	83 c4 10             	add    $0x10,%esp
}
801044fe:	c9                   	leave  
801044ff:	c3                   	ret    
        return -1;
80104500:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104505:	eb f7                	jmp    801044fe <sys_fstat+0x44>

80104507 <sys_link>:
{
80104507:	55                   	push   %ebp
80104508:	89 e5                	mov    %esp,%ebp
8010450a:	56                   	push   %esi
8010450b:	53                   	push   %ebx
8010450c:	83 ec 28             	sub    $0x28,%esp
    if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010450f:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104512:	50                   	push   %eax
80104513:	6a 00                	push   $0x0
80104515:	e8 41 fb ff ff       	call   8010405b <argstr>
8010451a:	83 c4 10             	add    $0x10,%esp
8010451d:	85 c0                	test   %eax,%eax
8010451f:	0f 88 d1 00 00 00    	js     801045f6 <sys_link+0xef>
80104525:	83 ec 08             	sub    $0x8,%esp
80104528:	8d 45 e4             	lea    -0x1c(%ebp),%eax
8010452b:	50                   	push   %eax
8010452c:	6a 01                	push   $0x1
8010452e:	e8 28 fb ff ff       	call   8010405b <argstr>
80104533:	83 c4 10             	add    $0x10,%esp
80104536:	85 c0                	test   %eax,%eax
80104538:	0f 88 b8 00 00 00    	js     801045f6 <sys_link+0xef>
    begin_op();
8010453e:	e8 d8 e1 ff ff       	call   8010271b <begin_op>
    if ((ip = namei(old)) == 0)
80104543:	83 ec 0c             	sub    $0xc,%esp
80104546:	ff 75 e0             	pushl  -0x20(%ebp)
80104549:	e8 52 d6 ff ff       	call   80101ba0 <namei>
8010454e:	89 c3                	mov    %eax,%ebx
80104550:	83 c4 10             	add    $0x10,%esp
80104553:	85 c0                	test   %eax,%eax
80104555:	0f 84 a2 00 00 00    	je     801045fd <sys_link+0xf6>
    ilock(ip);
8010455b:	83 ec 0c             	sub    $0xc,%esp
8010455e:	50                   	push   %eax
8010455f:	e8 d0 cf ff ff       	call   80101534 <ilock>
    if (ip->type == T_DIR)
80104564:	83 c4 10             	add    $0x10,%esp
80104567:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010456c:	0f 84 97 00 00 00    	je     80104609 <sys_link+0x102>
    ip->nlink++;
80104572:	66 8b 43 56          	mov    0x56(%ebx),%ax
80104576:	40                   	inc    %eax
80104577:	66 89 43 56          	mov    %ax,0x56(%ebx)
    iupdate(ip);
8010457b:	83 ec 0c             	sub    $0xc,%esp
8010457e:	53                   	push   %ebx
8010457f:	e8 57 ce ff ff       	call   801013db <iupdate>
    iunlock(ip);
80104584:	89 1c 24             	mov    %ebx,(%esp)
80104587:	e8 68 d0 ff ff       	call   801015f4 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
8010458c:	83 c4 08             	add    $0x8,%esp
8010458f:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104592:	50                   	push   %eax
80104593:	ff 75 e4             	pushl  -0x1c(%ebp)
80104596:	e8 1d d6 ff ff       	call   80101bb8 <nameiparent>
8010459b:	89 c6                	mov    %eax,%esi
8010459d:	83 c4 10             	add    $0x10,%esp
801045a0:	85 c0                	test   %eax,%eax
801045a2:	0f 84 85 00 00 00    	je     8010462d <sys_link+0x126>
    ilock(dp);
801045a8:	83 ec 0c             	sub    $0xc,%esp
801045ab:	50                   	push   %eax
801045ac:	e8 83 cf ff ff       	call   80101534 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
801045b1:	83 c4 10             	add    $0x10,%esp
801045b4:	8b 03                	mov    (%ebx),%eax
801045b6:	39 06                	cmp    %eax,(%esi)
801045b8:	75 67                	jne    80104621 <sys_link+0x11a>
801045ba:	83 ec 04             	sub    $0x4,%esp
801045bd:	ff 73 04             	pushl  0x4(%ebx)
801045c0:	8d 45 ea             	lea    -0x16(%ebp),%eax
801045c3:	50                   	push   %eax
801045c4:	56                   	push   %esi
801045c5:	e8 25 d5 ff ff       	call   80101aef <dirlink>
801045ca:	83 c4 10             	add    $0x10,%esp
801045cd:	85 c0                	test   %eax,%eax
801045cf:	78 50                	js     80104621 <sys_link+0x11a>
    iunlockput(dp);
801045d1:	83 ec 0c             	sub    $0xc,%esp
801045d4:	56                   	push   %esi
801045d5:	e8 fd d0 ff ff       	call   801016d7 <iunlockput>
    iput(ip);
801045da:	89 1c 24             	mov    %ebx,(%esp)
801045dd:	e8 57 d0 ff ff       	call   80101639 <iput>
    end_op();
801045e2:	e8 b0 e1 ff ff       	call   80102797 <end_op>
    return 0;
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
801045ef:	8d 65 f8             	lea    -0x8(%ebp),%esp
801045f2:	5b                   	pop    %ebx
801045f3:	5e                   	pop    %esi
801045f4:	5d                   	pop    %ebp
801045f5:	c3                   	ret    
        return -1;
801045f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801045fb:	eb f2                	jmp    801045ef <sys_link+0xe8>
        end_op();
801045fd:	e8 95 e1 ff ff       	call   80102797 <end_op>
        return -1;
80104602:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104607:	eb e6                	jmp    801045ef <sys_link+0xe8>
        iunlockput(ip);
80104609:	83 ec 0c             	sub    $0xc,%esp
8010460c:	53                   	push   %ebx
8010460d:	e8 c5 d0 ff ff       	call   801016d7 <iunlockput>
        end_op();
80104612:	e8 80 e1 ff ff       	call   80102797 <end_op>
        return -1;
80104617:	83 c4 10             	add    $0x10,%esp
8010461a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010461f:	eb ce                	jmp    801045ef <sys_link+0xe8>
        iunlockput(dp);
80104621:	83 ec 0c             	sub    $0xc,%esp
80104624:	56                   	push   %esi
80104625:	e8 ad d0 ff ff       	call   801016d7 <iunlockput>
        goto bad;
8010462a:	83 c4 10             	add    $0x10,%esp
    ilock(ip);
8010462d:	83 ec 0c             	sub    $0xc,%esp
80104630:	53                   	push   %ebx
80104631:	e8 fe ce ff ff       	call   80101534 <ilock>
    ip->nlink--;
80104636:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010463a:	48                   	dec    %eax
8010463b:	66 89 43 56          	mov    %ax,0x56(%ebx)
    iupdate(ip);
8010463f:	89 1c 24             	mov    %ebx,(%esp)
80104642:	e8 94 cd ff ff       	call   801013db <iupdate>
    iunlockput(ip);
80104647:	89 1c 24             	mov    %ebx,(%esp)
8010464a:	e8 88 d0 ff ff       	call   801016d7 <iunlockput>
    end_op();
8010464f:	e8 43 e1 ff ff       	call   80102797 <end_op>
    return -1;
80104654:	83 c4 10             	add    $0x10,%esp
80104657:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010465c:	eb 91                	jmp    801045ef <sys_link+0xe8>

8010465e <sys_unlink>:
{
8010465e:	55                   	push   %ebp
8010465f:	89 e5                	mov    %esp,%ebp
80104661:	57                   	push   %edi
80104662:	56                   	push   %esi
80104663:	53                   	push   %ebx
80104664:	83 ec 44             	sub    $0x44,%esp
    if (argstr(0, &path) < 0)
80104667:	8d 45 c4             	lea    -0x3c(%ebp),%eax
8010466a:	50                   	push   %eax
8010466b:	6a 00                	push   $0x0
8010466d:	e8 e9 f9 ff ff       	call   8010405b <argstr>
80104672:	83 c4 10             	add    $0x10,%esp
80104675:	85 c0                	test   %eax,%eax
80104677:	0f 88 7f 01 00 00    	js     801047fc <sys_unlink+0x19e>
    begin_op();
8010467d:	e8 99 e0 ff ff       	call   8010271b <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
80104682:	83 ec 08             	sub    $0x8,%esp
80104685:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104688:	50                   	push   %eax
80104689:	ff 75 c4             	pushl  -0x3c(%ebp)
8010468c:	e8 27 d5 ff ff       	call   80101bb8 <nameiparent>
80104691:	89 c6                	mov    %eax,%esi
80104693:	83 c4 10             	add    $0x10,%esp
80104696:	85 c0                	test   %eax,%eax
80104698:	0f 84 eb 00 00 00    	je     80104789 <sys_unlink+0x12b>
    ilock(dp);
8010469e:	83 ec 0c             	sub    $0xc,%esp
801046a1:	50                   	push   %eax
801046a2:	e8 8d ce ff ff       	call   80101534 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
801046a7:	83 c4 08             	add    $0x8,%esp
801046aa:	68 6a 6f 10 80       	push   $0x80106f6a
801046af:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046b2:	50                   	push   %eax
801046b3:	e8 a5 d2 ff ff       	call   8010195d <namecmp>
801046b8:	83 c4 10             	add    $0x10,%esp
801046bb:	85 c0                	test   %eax,%eax
801046bd:	0f 84 fa 00 00 00    	je     801047bd <sys_unlink+0x15f>
801046c3:	83 ec 08             	sub    $0x8,%esp
801046c6:	68 69 6f 10 80       	push   $0x80106f69
801046cb:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046ce:	50                   	push   %eax
801046cf:	e8 89 d2 ff ff       	call   8010195d <namecmp>
801046d4:	83 c4 10             	add    $0x10,%esp
801046d7:	85 c0                	test   %eax,%eax
801046d9:	0f 84 de 00 00 00    	je     801047bd <sys_unlink+0x15f>
    if ((ip = dirlookup(dp, name, &off)) == 0)
801046df:	83 ec 04             	sub    $0x4,%esp
801046e2:	8d 45 c0             	lea    -0x40(%ebp),%eax
801046e5:	50                   	push   %eax
801046e6:	8d 45 ca             	lea    -0x36(%ebp),%eax
801046e9:	50                   	push   %eax
801046ea:	56                   	push   %esi
801046eb:	e8 82 d2 ff ff       	call   80101972 <dirlookup>
801046f0:	89 c3                	mov    %eax,%ebx
801046f2:	83 c4 10             	add    $0x10,%esp
801046f5:	85 c0                	test   %eax,%eax
801046f7:	0f 84 c0 00 00 00    	je     801047bd <sys_unlink+0x15f>
    ilock(ip);
801046fd:	83 ec 0c             	sub    $0xc,%esp
80104700:	50                   	push   %eax
80104701:	e8 2e ce ff ff       	call   80101534 <ilock>
    if (ip->nlink < 1)
80104706:	83 c4 10             	add    $0x10,%esp
80104709:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010470e:	0f 8e 81 00 00 00    	jle    80104795 <sys_unlink+0x137>
    if (ip->type == T_DIR && !isdirempty(ip))
80104714:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104719:	0f 84 83 00 00 00    	je     801047a2 <sys_unlink+0x144>
    memset(&de, 0, sizeof(de));
8010471f:	83 ec 04             	sub    $0x4,%esp
80104722:	6a 10                	push   $0x10
80104724:	6a 00                	push   $0x0
80104726:	8d 7d d8             	lea    -0x28(%ebp),%edi
80104729:	57                   	push   %edi
8010472a:	e8 69 f6 ff ff       	call   80103d98 <memset>
    if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
8010472f:	6a 10                	push   $0x10
80104731:	ff 75 c0             	pushl  -0x40(%ebp)
80104734:	57                   	push   %edi
80104735:	56                   	push   %esi
80104736:	e8 e9 d0 ff ff       	call   80101824 <writei>
8010473b:	83 c4 20             	add    $0x20,%esp
8010473e:	83 f8 10             	cmp    $0x10,%eax
80104741:	0f 85 8e 00 00 00    	jne    801047d5 <sys_unlink+0x177>
    if (ip->type == T_DIR)
80104747:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010474c:	0f 84 90 00 00 00    	je     801047e2 <sys_unlink+0x184>
    iunlockput(dp);
80104752:	83 ec 0c             	sub    $0xc,%esp
80104755:	56                   	push   %esi
80104756:	e8 7c cf ff ff       	call   801016d7 <iunlockput>
    ip->nlink--;
8010475b:	66 8b 43 56          	mov    0x56(%ebx),%ax
8010475f:	48                   	dec    %eax
80104760:	66 89 43 56          	mov    %ax,0x56(%ebx)
    iupdate(ip);
80104764:	89 1c 24             	mov    %ebx,(%esp)
80104767:	e8 6f cc ff ff       	call   801013db <iupdate>
    iunlockput(ip);
8010476c:	89 1c 24             	mov    %ebx,(%esp)
8010476f:	e8 63 cf ff ff       	call   801016d7 <iunlockput>
    end_op();
80104774:	e8 1e e0 ff ff       	call   80102797 <end_op>
    return 0;
80104779:	83 c4 10             	add    $0x10,%esp
8010477c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104781:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104784:	5b                   	pop    %ebx
80104785:	5e                   	pop    %esi
80104786:	5f                   	pop    %edi
80104787:	5d                   	pop    %ebp
80104788:	c3                   	ret    
        end_op();
80104789:	e8 09 e0 ff ff       	call   80102797 <end_op>
        return -1;
8010478e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104793:	eb ec                	jmp    80104781 <sys_unlink+0x123>
        panic("unlink: nlink < 1");
80104795:	83 ec 0c             	sub    $0xc,%esp
80104798:	68 88 6f 10 80       	push   $0x80106f88
8010479d:	e8 a2 bb ff ff       	call   80100344 <panic>
    if (ip->type == T_DIR && !isdirempty(ip))
801047a2:	89 d8                	mov    %ebx,%eax
801047a4:	e8 f8 f9 ff ff       	call   801041a1 <isdirempty>
801047a9:	85 c0                	test   %eax,%eax
801047ab:	0f 85 6e ff ff ff    	jne    8010471f <sys_unlink+0xc1>
        iunlockput(ip);
801047b1:	83 ec 0c             	sub    $0xc,%esp
801047b4:	53                   	push   %ebx
801047b5:	e8 1d cf ff ff       	call   801016d7 <iunlockput>
        goto bad;
801047ba:	83 c4 10             	add    $0x10,%esp
    iunlockput(dp);
801047bd:	83 ec 0c             	sub    $0xc,%esp
801047c0:	56                   	push   %esi
801047c1:	e8 11 cf ff ff       	call   801016d7 <iunlockput>
    end_op();
801047c6:	e8 cc df ff ff       	call   80102797 <end_op>
    return -1;
801047cb:	83 c4 10             	add    $0x10,%esp
801047ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047d3:	eb ac                	jmp    80104781 <sys_unlink+0x123>
        panic("unlink: writei");
801047d5:	83 ec 0c             	sub    $0xc,%esp
801047d8:	68 9a 6f 10 80       	push   $0x80106f9a
801047dd:	e8 62 bb ff ff       	call   80100344 <panic>
        dp->nlink--;
801047e2:	66 8b 46 56          	mov    0x56(%esi),%ax
801047e6:	48                   	dec    %eax
801047e7:	66 89 46 56          	mov    %ax,0x56(%esi)
        iupdate(dp);
801047eb:	83 ec 0c             	sub    $0xc,%esp
801047ee:	56                   	push   %esi
801047ef:	e8 e7 cb ff ff       	call   801013db <iupdate>
801047f4:	83 c4 10             	add    $0x10,%esp
801047f7:	e9 56 ff ff ff       	jmp    80104752 <sys_unlink+0xf4>
        return -1;
801047fc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104801:	e9 7b ff ff ff       	jmp    80104781 <sys_unlink+0x123>

80104806 <sys_open>:

int sys_open(void)
{
80104806:	55                   	push   %ebp
80104807:	89 e5                	mov    %esp,%ebp
80104809:	57                   	push   %edi
8010480a:	56                   	push   %esi
8010480b:	53                   	push   %ebx
8010480c:	83 ec 24             	sub    $0x24,%esp
    char *path;
    int fd, omode;
    struct file *f;
    struct inode *ip;

    if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010480f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104812:	50                   	push   %eax
80104813:	6a 00                	push   $0x0
80104815:	e8 41 f8 ff ff       	call   8010405b <argstr>
8010481a:	83 c4 10             	add    $0x10,%esp
8010481d:	85 c0                	test   %eax,%eax
8010481f:	0f 88 a0 00 00 00    	js     801048c5 <sys_open+0xbf>
80104825:	83 ec 08             	sub    $0x8,%esp
80104828:	8d 45 e0             	lea    -0x20(%ebp),%eax
8010482b:	50                   	push   %eax
8010482c:	6a 01                	push   $0x1
8010482e:	e8 98 f7 ff ff       	call   80103fcb <argint>
80104833:	83 c4 10             	add    $0x10,%esp
80104836:	85 c0                	test   %eax,%eax
80104838:	0f 88 87 00 00 00    	js     801048c5 <sys_open+0xbf>
        return -1;

    begin_op();
8010483e:	e8 d8 de ff ff       	call   8010271b <begin_op>

    if (omode & O_CREATE)
80104843:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
80104847:	0f 84 8b 00 00 00    	je     801048d8 <sys_open+0xd2>
    {
        ip = create(path, T_FILE, 0, 0);
8010484d:	83 ec 0c             	sub    $0xc,%esp
80104850:	6a 00                	push   $0x0
80104852:	b9 00 00 00 00       	mov    $0x0,%ecx
80104857:	ba 02 00 00 00       	mov    $0x2,%edx
8010485c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010485f:	e8 94 f9 ff ff       	call   801041f8 <create>
80104864:	89 c6                	mov    %eax,%esi
        if (ip == 0)
80104866:	83 c4 10             	add    $0x10,%esp
80104869:	85 c0                	test   %eax,%eax
8010486b:	74 5f                	je     801048cc <sys_open+0xc6>
            end_op();
            return -1;
        }
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
8010486d:	e8 ae c3 ff ff       	call   80100c20 <filealloc>
80104872:	89 c3                	mov    %eax,%ebx
80104874:	85 c0                	test   %eax,%eax
80104876:	0f 84 c1 00 00 00    	je     8010493d <sys_open+0x137>
8010487c:	e8 ec f8 ff ff       	call   8010416d <fdalloc>
80104881:	89 c7                	mov    %eax,%edi
80104883:	85 c0                	test   %eax,%eax
80104885:	0f 88 a6 00 00 00    	js     80104931 <sys_open+0x12b>
            fileclose(f);
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
8010488b:	83 ec 0c             	sub    $0xc,%esp
8010488e:	56                   	push   %esi
8010488f:	e8 60 cd ff ff       	call   801015f4 <iunlock>
    end_op();
80104894:	e8 fe de ff ff       	call   80102797 <end_op>

    f->type = FD_INODE;
80104899:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
    f->ip = ip;
8010489f:	89 73 10             	mov    %esi,0x10(%ebx)
    f->off = 0;
801048a2:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    f->readable = !(omode & O_WRONLY);
801048a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801048ac:	83 c4 10             	add    $0x10,%esp
801048af:	a8 01                	test   $0x1,%al
801048b1:	0f 94 43 08          	sete   0x8(%ebx)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801048b5:	a8 03                	test   $0x3,%al
801048b7:	0f 95 43 09          	setne  0x9(%ebx)
    return fd;
}
801048bb:	89 f8                	mov    %edi,%eax
801048bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801048c0:	5b                   	pop    %ebx
801048c1:	5e                   	pop    %esi
801048c2:	5f                   	pop    %edi
801048c3:	5d                   	pop    %ebp
801048c4:	c3                   	ret    
        return -1;
801048c5:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048ca:	eb ef                	jmp    801048bb <sys_open+0xb5>
            end_op();
801048cc:	e8 c6 de ff ff       	call   80102797 <end_op>
            return -1;
801048d1:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801048d6:	eb e3                	jmp    801048bb <sys_open+0xb5>
        if ((ip = namei(path)) == 0)
801048d8:	83 ec 0c             	sub    $0xc,%esp
801048db:	ff 75 e4             	pushl  -0x1c(%ebp)
801048de:	e8 bd d2 ff ff       	call   80101ba0 <namei>
801048e3:	89 c6                	mov    %eax,%esi
801048e5:	83 c4 10             	add    $0x10,%esp
801048e8:	85 c0                	test   %eax,%eax
801048ea:	74 39                	je     80104925 <sys_open+0x11f>
        ilock(ip);
801048ec:	83 ec 0c             	sub    $0xc,%esp
801048ef:	50                   	push   %eax
801048f0:	e8 3f cc ff ff       	call   80101534 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
801048f5:	83 c4 10             	add    $0x10,%esp
801048f8:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
801048fd:	0f 85 6a ff ff ff    	jne    8010486d <sys_open+0x67>
80104903:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80104907:	0f 84 60 ff ff ff    	je     8010486d <sys_open+0x67>
            iunlockput(ip);
8010490d:	83 ec 0c             	sub    $0xc,%esp
80104910:	56                   	push   %esi
80104911:	e8 c1 cd ff ff       	call   801016d7 <iunlockput>
            end_op();
80104916:	e8 7c de ff ff       	call   80102797 <end_op>
            return -1;
8010491b:	83 c4 10             	add    $0x10,%esp
8010491e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104923:	eb 96                	jmp    801048bb <sys_open+0xb5>
            end_op();
80104925:	e8 6d de ff ff       	call   80102797 <end_op>
            return -1;
8010492a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010492f:	eb 8a                	jmp    801048bb <sys_open+0xb5>
            fileclose(f);
80104931:	83 ec 0c             	sub    $0xc,%esp
80104934:	53                   	push   %ebx
80104935:	e8 8a c3 ff ff       	call   80100cc4 <fileclose>
8010493a:	83 c4 10             	add    $0x10,%esp
        iunlockput(ip);
8010493d:	83 ec 0c             	sub    $0xc,%esp
80104940:	56                   	push   %esi
80104941:	e8 91 cd ff ff       	call   801016d7 <iunlockput>
        end_op();
80104946:	e8 4c de ff ff       	call   80102797 <end_op>
        return -1;
8010494b:	83 c4 10             	add    $0x10,%esp
8010494e:	bf ff ff ff ff       	mov    $0xffffffff,%edi
80104953:	e9 63 ff ff ff       	jmp    801048bb <sys_open+0xb5>

80104958 <sys_mkdir>:

int sys_mkdir(void)
{
80104958:	55                   	push   %ebp
80104959:	89 e5                	mov    %esp,%ebp
8010495b:	83 ec 18             	sub    $0x18,%esp
    char *path;
    struct inode *ip;

    begin_op();
8010495e:	e8 b8 dd ff ff       	call   8010271b <begin_op>
    if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80104963:	83 ec 08             	sub    $0x8,%esp
80104966:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104969:	50                   	push   %eax
8010496a:	6a 00                	push   $0x0
8010496c:	e8 ea f6 ff ff       	call   8010405b <argstr>
80104971:	83 c4 10             	add    $0x10,%esp
80104974:	85 c0                	test   %eax,%eax
80104976:	78 36                	js     801049ae <sys_mkdir+0x56>
80104978:	83 ec 0c             	sub    $0xc,%esp
8010497b:	6a 00                	push   $0x0
8010497d:	b9 00 00 00 00       	mov    $0x0,%ecx
80104982:	ba 01 00 00 00       	mov    $0x1,%edx
80104987:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010498a:	e8 69 f8 ff ff       	call   801041f8 <create>
8010498f:	83 c4 10             	add    $0x10,%esp
80104992:	85 c0                	test   %eax,%eax
80104994:	74 18                	je     801049ae <sys_mkdir+0x56>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
80104996:	83 ec 0c             	sub    $0xc,%esp
80104999:	50                   	push   %eax
8010499a:	e8 38 cd ff ff       	call   801016d7 <iunlockput>
    end_op();
8010499f:	e8 f3 dd ff ff       	call   80102797 <end_op>
    return 0;
801049a4:	83 c4 10             	add    $0x10,%esp
801049a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
801049ac:	c9                   	leave  
801049ad:	c3                   	ret    
        end_op();
801049ae:	e8 e4 dd ff ff       	call   80102797 <end_op>
        return -1;
801049b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801049b8:	eb f2                	jmp    801049ac <sys_mkdir+0x54>

801049ba <sys_mknod>:

int sys_mknod(void)
{
801049ba:	55                   	push   %ebp
801049bb:	89 e5                	mov    %esp,%ebp
801049bd:	83 ec 18             	sub    $0x18,%esp
    struct inode *ip;
    char *path;
    int major, minor;

    begin_op();
801049c0:	e8 56 dd ff ff       	call   8010271b <begin_op>
    if ((argstr(0, &path)) < 0 ||
801049c5:	83 ec 08             	sub    $0x8,%esp
801049c8:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049cb:	50                   	push   %eax
801049cc:	6a 00                	push   $0x0
801049ce:	e8 88 f6 ff ff       	call   8010405b <argstr>
801049d3:	83 c4 10             	add    $0x10,%esp
801049d6:	85 c0                	test   %eax,%eax
801049d8:	78 62                	js     80104a3c <sys_mknod+0x82>
        argint(1, &major) < 0 ||
801049da:	83 ec 08             	sub    $0x8,%esp
801049dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049e0:	50                   	push   %eax
801049e1:	6a 01                	push   $0x1
801049e3:	e8 e3 f5 ff ff       	call   80103fcb <argint>
    if ((argstr(0, &path)) < 0 ||
801049e8:	83 c4 10             	add    $0x10,%esp
801049eb:	85 c0                	test   %eax,%eax
801049ed:	78 4d                	js     80104a3c <sys_mknod+0x82>
        argint(2, &minor) < 0 ||
801049ef:	83 ec 08             	sub    $0x8,%esp
801049f2:	8d 45 ec             	lea    -0x14(%ebp),%eax
801049f5:	50                   	push   %eax
801049f6:	6a 02                	push   $0x2
801049f8:	e8 ce f5 ff ff       	call   80103fcb <argint>
        argint(1, &major) < 0 ||
801049fd:	83 c4 10             	add    $0x10,%esp
80104a00:	85 c0                	test   %eax,%eax
80104a02:	78 38                	js     80104a3c <sys_mknod+0x82>
        (ip = create(path, T_DEV, major, minor)) == 0)
80104a04:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104a08:	83 ec 0c             	sub    $0xc,%esp
80104a0b:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104a0f:	50                   	push   %eax
80104a10:	ba 03 00 00 00       	mov    $0x3,%edx
80104a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a18:	e8 db f7 ff ff       	call   801041f8 <create>
        argint(2, &minor) < 0 ||
80104a1d:	83 c4 10             	add    $0x10,%esp
80104a20:	85 c0                	test   %eax,%eax
80104a22:	74 18                	je     80104a3c <sys_mknod+0x82>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
80104a24:	83 ec 0c             	sub    $0xc,%esp
80104a27:	50                   	push   %eax
80104a28:	e8 aa cc ff ff       	call   801016d7 <iunlockput>
    end_op();
80104a2d:	e8 65 dd ff ff       	call   80102797 <end_op>
    return 0;
80104a32:	83 c4 10             	add    $0x10,%esp
80104a35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a3a:	c9                   	leave  
80104a3b:	c3                   	ret    
        end_op();
80104a3c:	e8 56 dd ff ff       	call   80102797 <end_op>
        return -1;
80104a41:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a46:	eb f2                	jmp    80104a3a <sys_mknod+0x80>

80104a48 <sys_chdir>:

int sys_chdir(void)
{
80104a48:	55                   	push   %ebp
80104a49:	89 e5                	mov    %esp,%ebp
80104a4b:	56                   	push   %esi
80104a4c:	53                   	push   %ebx
80104a4d:	83 ec 10             	sub    $0x10,%esp
    char *path;
    struct inode *ip;
    struct proc *curproc = myproc();
80104a50:	e8 12 e7 ff ff       	call   80103167 <myproc>
80104a55:	89 c6                	mov    %eax,%esi

    begin_op();
80104a57:	e8 bf dc ff ff       	call   8010271b <begin_op>
    if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104a5c:	83 ec 08             	sub    $0x8,%esp
80104a5f:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a62:	50                   	push   %eax
80104a63:	6a 00                	push   $0x0
80104a65:	e8 f1 f5 ff ff       	call   8010405b <argstr>
80104a6a:	83 c4 10             	add    $0x10,%esp
80104a6d:	85 c0                	test   %eax,%eax
80104a6f:	78 52                	js     80104ac3 <sys_chdir+0x7b>
80104a71:	83 ec 0c             	sub    $0xc,%esp
80104a74:	ff 75 f4             	pushl  -0xc(%ebp)
80104a77:	e8 24 d1 ff ff       	call   80101ba0 <namei>
80104a7c:	89 c3                	mov    %eax,%ebx
80104a7e:	83 c4 10             	add    $0x10,%esp
80104a81:	85 c0                	test   %eax,%eax
80104a83:	74 3e                	je     80104ac3 <sys_chdir+0x7b>
    {
        end_op();
        return -1;
    }
    ilock(ip);
80104a85:	83 ec 0c             	sub    $0xc,%esp
80104a88:	50                   	push   %eax
80104a89:	e8 a6 ca ff ff       	call   80101534 <ilock>
    if (ip->type != T_DIR)
80104a8e:	83 c4 10             	add    $0x10,%esp
80104a91:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104a96:	75 37                	jne    80104acf <sys_chdir+0x87>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
80104a98:	83 ec 0c             	sub    $0xc,%esp
80104a9b:	53                   	push   %ebx
80104a9c:	e8 53 cb ff ff       	call   801015f4 <iunlock>
    iput(curproc->cwd);
80104aa1:	83 c4 04             	add    $0x4,%esp
80104aa4:	ff 76 68             	pushl  0x68(%esi)
80104aa7:	e8 8d cb ff ff       	call   80101639 <iput>
    end_op();
80104aac:	e8 e6 dc ff ff       	call   80102797 <end_op>
    curproc->cwd = ip;
80104ab1:	89 5e 68             	mov    %ebx,0x68(%esi)
    return 0;
80104ab4:	83 c4 10             	add    $0x10,%esp
80104ab7:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104abc:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104abf:	5b                   	pop    %ebx
80104ac0:	5e                   	pop    %esi
80104ac1:	5d                   	pop    %ebp
80104ac2:	c3                   	ret    
        end_op();
80104ac3:	e8 cf dc ff ff       	call   80102797 <end_op>
        return -1;
80104ac8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104acd:	eb ed                	jmp    80104abc <sys_chdir+0x74>
        iunlockput(ip);
80104acf:	83 ec 0c             	sub    $0xc,%esp
80104ad2:	53                   	push   %ebx
80104ad3:	e8 ff cb ff ff       	call   801016d7 <iunlockput>
        end_op();
80104ad8:	e8 ba dc ff ff       	call   80102797 <end_op>
        return -1;
80104add:	83 c4 10             	add    $0x10,%esp
80104ae0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae5:	eb d5                	jmp    80104abc <sys_chdir+0x74>

80104ae7 <sys_exec>:

int sys_exec(void)
{
80104ae7:	55                   	push   %ebp
80104ae8:	89 e5                	mov    %esp,%ebp
80104aea:	53                   	push   %ebx
80104aeb:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    char *path, *argv[MAXARG];
    int i;
    uint uargv, uarg;

    if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104af1:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104af4:	50                   	push   %eax
80104af5:	6a 00                	push   $0x0
80104af7:	e8 5f f5 ff ff       	call   8010405b <argstr>
80104afc:	83 c4 10             	add    $0x10,%esp
80104aff:	85 c0                	test   %eax,%eax
80104b01:	78 38                	js     80104b3b <sys_exec+0x54>
80104b03:	83 ec 08             	sub    $0x8,%esp
80104b06:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104b0c:	50                   	push   %eax
80104b0d:	6a 01                	push   $0x1
80104b0f:	e8 b7 f4 ff ff       	call   80103fcb <argint>
80104b14:	83 c4 10             	add    $0x10,%esp
80104b17:	85 c0                	test   %eax,%eax
80104b19:	78 20                	js     80104b3b <sys_exec+0x54>
    {
        return -1;
    }
    memset(argv, 0, sizeof(argv));
80104b1b:	83 ec 04             	sub    $0x4,%esp
80104b1e:	68 80 00 00 00       	push   $0x80
80104b23:	6a 00                	push   $0x0
80104b25:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b2b:	50                   	push   %eax
80104b2c:	e8 67 f2 ff ff       	call   80103d98 <memset>
80104b31:	83 c4 10             	add    $0x10,%esp
    for (i = 0;; i++)
80104b34:	bb 00 00 00 00       	mov    $0x0,%ebx
80104b39:	eb 2a                	jmp    80104b65 <sys_exec+0x7e>
        return -1;
80104b3b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b40:	eb 76                	jmp    80104bb8 <sys_exec+0xd1>
            return -1;
        if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
            return -1;
        if (uarg == 0)
        {
            argv[i] = 0;
80104b42:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104b49:	00 00 00 00 
            break;
        }
        if (fetchstr(uarg, &argv[i]) < 0)
            return -1;
    }
    return exec(path, argv);
80104b4d:	83 ec 08             	sub    $0x8,%esp
80104b50:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104b56:	50                   	push   %eax
80104b57:	ff 75 f4             	pushl  -0xc(%ebp)
80104b5a:	e8 36 bd ff ff       	call   80100895 <exec>
80104b5f:	83 c4 10             	add    $0x10,%esp
80104b62:	eb 54                	jmp    80104bb8 <sys_exec+0xd1>
    for (i = 0;; i++)
80104b64:	43                   	inc    %ebx
        if (i >= NELEM(argv))
80104b65:	83 fb 1f             	cmp    $0x1f,%ebx
80104b68:	77 49                	ja     80104bb3 <sys_exec+0xcc>
        if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104b6a:	83 ec 08             	sub    $0x8,%esp
80104b6d:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104b73:	50                   	push   %eax
80104b74:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104b7a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104b7d:	50                   	push   %eax
80104b7e:	e8 d0 f3 ff ff       	call   80103f53 <fetchint>
80104b83:	83 c4 10             	add    $0x10,%esp
80104b86:	85 c0                	test   %eax,%eax
80104b88:	78 33                	js     80104bbd <sys_exec+0xd6>
        if (uarg == 0)
80104b8a:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104b90:	85 c0                	test   %eax,%eax
80104b92:	74 ae                	je     80104b42 <sys_exec+0x5b>
        if (fetchstr(uarg, &argv[i]) < 0)
80104b94:	83 ec 08             	sub    $0x8,%esp
80104b97:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104b9e:	52                   	push   %edx
80104b9f:	50                   	push   %eax
80104ba0:	e8 e9 f3 ff ff       	call   80103f8e <fetchstr>
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	79 b8                	jns    80104b64 <sys_exec+0x7d>
            return -1;
80104bac:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bb1:	eb 05                	jmp    80104bb8 <sys_exec+0xd1>
            return -1;
80104bb3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104bb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104bbb:	c9                   	leave  
80104bbc:	c3                   	ret    
            return -1;
80104bbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104bc2:	eb f4                	jmp    80104bb8 <sys_exec+0xd1>

80104bc4 <sys_pipe>:

int sys_pipe(void)
{
80104bc4:	55                   	push   %ebp
80104bc5:	89 e5                	mov    %esp,%ebp
80104bc7:	53                   	push   %ebx
80104bc8:	83 ec 18             	sub    $0x18,%esp
    int *fd;
    struct file *rf, *wf;
    int fd0, fd1;

    if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104bcb:	6a 08                	push   $0x8
80104bcd:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bd0:	50                   	push   %eax
80104bd1:	6a 00                	push   $0x0
80104bd3:	e8 1b f4 ff ff       	call   80103ff3 <argptr>
80104bd8:	83 c4 10             	add    $0x10,%esp
80104bdb:	85 c0                	test   %eax,%eax
80104bdd:	78 73                	js     80104c52 <sys_pipe+0x8e>
        return -1;
    if (pipealloc(&rf, &wf) < 0)
80104bdf:	83 ec 08             	sub    $0x8,%esp
80104be2:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104be5:	50                   	push   %eax
80104be6:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104be9:	50                   	push   %eax
80104bea:	e8 a7 e0 ff ff       	call   80102c96 <pipealloc>
80104bef:	83 c4 10             	add    $0x10,%esp
80104bf2:	85 c0                	test   %eax,%eax
80104bf4:	78 63                	js     80104c59 <sys_pipe+0x95>
        return -1;
    fd0 = -1;
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104bf6:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104bf9:	e8 6f f5 ff ff       	call   8010416d <fdalloc>
80104bfe:	89 c3                	mov    %eax,%ebx
80104c00:	85 c0                	test   %eax,%eax
80104c02:	78 2e                	js     80104c32 <sys_pipe+0x6e>
80104c04:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104c07:	e8 61 f5 ff ff       	call   8010416d <fdalloc>
80104c0c:	85 c0                	test   %eax,%eax
80104c0e:	78 15                	js     80104c25 <sys_pipe+0x61>
            myproc()->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    fd[0] = fd0;
80104c10:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c13:	89 1a                	mov    %ebx,(%edx)
    fd[1] = fd1;
80104c15:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104c18:	89 42 04             	mov    %eax,0x4(%edx)
    return 0;
80104c1b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104c20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c23:	c9                   	leave  
80104c24:	c3                   	ret    
            myproc()->ofile[fd0] = 0;
80104c25:	e8 3d e5 ff ff       	call   80103167 <myproc>
80104c2a:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104c31:	00 
        fileclose(rf);
80104c32:	83 ec 0c             	sub    $0xc,%esp
80104c35:	ff 75 f0             	pushl  -0x10(%ebp)
80104c38:	e8 87 c0 ff ff       	call   80100cc4 <fileclose>
        fileclose(wf);
80104c3d:	83 c4 04             	add    $0x4,%esp
80104c40:	ff 75 ec             	pushl  -0x14(%ebp)
80104c43:	e8 7c c0 ff ff       	call   80100cc4 <fileclose>
        return -1;
80104c48:	83 c4 10             	add    $0x10,%esp
80104c4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c50:	eb ce                	jmp    80104c20 <sys_pipe+0x5c>
        return -1;
80104c52:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c57:	eb c7                	jmp    80104c20 <sys_pipe+0x5c>
        return -1;
80104c59:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c5e:	eb c0                	jmp    80104c20 <sys_pipe+0x5c>

80104c60 <sys_chmod>:

// Defining the new system calls for files
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

int sys_chmod(void)
{
80104c60:	55                   	push   %ebp
80104c61:	89 e5                	mov    %esp,%ebp
80104c63:	83 ec 20             	sub    $0x20,%esp
    int syscallid;
    char *filename;

    argint(1, &syscallid);
80104c66:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c69:	50                   	push   %eax
80104c6a:	6a 01                	push   $0x1
80104c6c:	e8 5a f3 ff ff       	call   80103fcb <argint>
    argstr(0, &filename);
80104c71:	83 c4 08             	add    $0x8,%esp
80104c74:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c77:	50                   	push   %eax
80104c78:	6a 00                	push   $0x0
80104c7a:	e8 dc f3 ff ff       	call   8010405b <argstr>

    cprintf("chmod called\n");
80104c7f:	c7 04 24 a9 6f 10 80 	movl   $0x80106fa9,(%esp)
80104c86:	e8 54 b9 ff ff       	call   801005df <cprintf>
    cprintf("%d\n", syscallid);
80104c8b:	83 c4 08             	add    $0x8,%esp
80104c8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c91:	68 f4 6c 10 80       	push   $0x80106cf4
80104c96:	e8 44 b9 ff ff       	call   801005df <cprintf>
    cprintf("%s\n", filename);
80104c9b:	83 c4 08             	add    $0x8,%esp
80104c9e:	ff 75 f0             	pushl  -0x10(%ebp)
80104ca1:	68 b7 6f 10 80       	push   $0x80106fb7
80104ca6:	e8 34 b9 ff ff       	call   801005df <cprintf>

    return -1;
}
80104cab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cb0:	c9                   	leave  
80104cb1:	c3                   	ret    

80104cb2 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80104cb2:	55                   	push   %ebp
80104cb3:	89 e5                	mov    %esp,%ebp
80104cb5:	83 ec 08             	sub    $0x8,%esp
    return fork();
80104cb8:	e8 1e e6 ff ff       	call   801032db <fork>
}
80104cbd:	c9                   	leave  
80104cbe:	c3                   	ret    

80104cbf <sys_exit>:

int sys_exit(void)
{
80104cbf:	55                   	push   %ebp
80104cc0:	89 e5                	mov    %esp,%ebp
80104cc2:	83 ec 08             	sub    $0x8,%esp
    exit();
80104cc5:	e8 b5 eb ff ff       	call   8010387f <exit>
    return 0; // not reached
}
80104cca:	b8 00 00 00 00       	mov    $0x0,%eax
80104ccf:	c9                   	leave  
80104cd0:	c3                   	ret    

80104cd1 <sys_wait>:

int sys_wait(void)
{
80104cd1:	55                   	push   %ebp
80104cd2:	89 e5                	mov    %esp,%ebp
80104cd4:	83 ec 08             	sub    $0x8,%esp
    return wait();
80104cd7:	e8 f7 e8 ff ff       	call   801035d3 <wait>
}
80104cdc:	c9                   	leave  
80104cdd:	c3                   	ret    

80104cde <sys_kill>:

int sys_kill(void)
{
80104cde:	55                   	push   %ebp
80104cdf:	89 e5                	mov    %esp,%ebp
80104ce1:	83 ec 20             	sub    $0x20,%esp
    int pid;

    if (argint(0, &pid) < 0)
80104ce4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ce7:	50                   	push   %eax
80104ce8:	6a 00                	push   $0x0
80104cea:	e8 dc f2 ff ff       	call   80103fcb <argint>
80104cef:	83 c4 10             	add    $0x10,%esp
80104cf2:	85 c0                	test   %eax,%eax
80104cf4:	78 10                	js     80104d06 <sys_kill+0x28>
        return -1;
    return kill(pid);
80104cf6:	83 ec 0c             	sub    $0xc,%esp
80104cf9:	ff 75 f4             	pushl  -0xc(%ebp)
80104cfc:	e8 d2 e9 ff ff       	call   801036d3 <kill>
80104d01:	83 c4 10             	add    $0x10,%esp
}
80104d04:	c9                   	leave  
80104d05:	c3                   	ret    
        return -1;
80104d06:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0b:	eb f7                	jmp    80104d04 <sys_kill+0x26>

80104d0d <sys_getpid>:

int sys_getpid(void)
{
80104d0d:	55                   	push   %ebp
80104d0e:	89 e5                	mov    %esp,%ebp
80104d10:	83 ec 08             	sub    $0x8,%esp
    return myproc()->pid;
80104d13:	e8 4f e4 ff ff       	call   80103167 <myproc>
80104d18:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d1b:	c9                   	leave  
80104d1c:	c3                   	ret    

80104d1d <sys_sbrk>:

int sys_sbrk(void)
{
80104d1d:	55                   	push   %ebp
80104d1e:	89 e5                	mov    %esp,%ebp
80104d20:	53                   	push   %ebx
80104d21:	83 ec 1c             	sub    $0x1c,%esp
    int addr;
    int n;

    if (argint(0, &n) < 0)
80104d24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d27:	50                   	push   %eax
80104d28:	6a 00                	push   $0x0
80104d2a:	e8 9c f2 ff ff       	call   80103fcb <argint>
80104d2f:	83 c4 10             	add    $0x10,%esp
80104d32:	85 c0                	test   %eax,%eax
80104d34:	78 20                	js     80104d56 <sys_sbrk+0x39>
        return -1;
    addr = myproc()->sz;
80104d36:	e8 2c e4 ff ff       	call   80103167 <myproc>
80104d3b:	8b 18                	mov    (%eax),%ebx
    if (growproc(n) < 0)
80104d3d:	83 ec 0c             	sub    $0xc,%esp
80104d40:	ff 75 f4             	pushl  -0xc(%ebp)
80104d43:	e8 28 e5 ff ff       	call   80103270 <growproc>
80104d48:	83 c4 10             	add    $0x10,%esp
80104d4b:	85 c0                	test   %eax,%eax
80104d4d:	78 0e                	js     80104d5d <sys_sbrk+0x40>
        return -1;
    return addr;
}
80104d4f:	89 d8                	mov    %ebx,%eax
80104d51:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104d54:	c9                   	leave  
80104d55:	c3                   	ret    
        return -1;
80104d56:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d5b:	eb f2                	jmp    80104d4f <sys_sbrk+0x32>
        return -1;
80104d5d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104d62:	eb eb                	jmp    80104d4f <sys_sbrk+0x32>

80104d64 <sys_sleep>:

int sys_sleep(void)
{
80104d64:	55                   	push   %ebp
80104d65:	89 e5                	mov    %esp,%ebp
80104d67:	53                   	push   %ebx
80104d68:	83 ec 1c             	sub    $0x1c,%esp
    int n;
    uint ticks0;

    if (argint(0, &n) < 0)
80104d6b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d6e:	50                   	push   %eax
80104d6f:	6a 00                	push   $0x0
80104d71:	e8 55 f2 ff ff       	call   80103fcb <argint>
80104d76:	83 c4 10             	add    $0x10,%esp
80104d79:	85 c0                	test   %eax,%eax
80104d7b:	78 75                	js     80104df2 <sys_sleep+0x8e>
        return -1;
    acquire(&tickslock);
80104d7d:	83 ec 0c             	sub    $0xc,%esp
80104d80:	68 80 6b 11 80       	push   $0x80116b80
80104d85:	e8 62 ef ff ff       	call   80103cec <acquire>
    ticks0 = ticks;
80104d8a:	8b 1d 60 6b 11 80    	mov    0x80116b60,%ebx
    while (ticks - ticks0 < n)
80104d90:	83 c4 10             	add    $0x10,%esp
80104d93:	a1 60 6b 11 80       	mov    0x80116b60,%eax
80104d98:	29 d8                	sub    %ebx,%eax
80104d9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104d9d:	73 39                	jae    80104dd8 <sys_sleep+0x74>
    {
        if (myproc()->killed)
80104d9f:	e8 c3 e3 ff ff       	call   80103167 <myproc>
80104da4:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104da8:	75 17                	jne    80104dc1 <sys_sleep+0x5d>
        {
            release(&tickslock);
            return -1;
        }
        sleep(&ticks, &tickslock);
80104daa:	83 ec 08             	sub    $0x8,%esp
80104dad:	68 80 6b 11 80       	push   $0x80116b80
80104db2:	68 60 6b 11 80       	push   $0x80116b60
80104db7:	e8 86 e7 ff ff       	call   80103542 <sleep>
80104dbc:	83 c4 10             	add    $0x10,%esp
80104dbf:	eb d2                	jmp    80104d93 <sys_sleep+0x2f>
            release(&tickslock);
80104dc1:	83 ec 0c             	sub    $0xc,%esp
80104dc4:	68 80 6b 11 80       	push   $0x80116b80
80104dc9:	e8 83 ef ff ff       	call   80103d51 <release>
            return -1;
80104dce:	83 c4 10             	add    $0x10,%esp
80104dd1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dd6:	eb 15                	jmp    80104ded <sys_sleep+0x89>
    }
    release(&tickslock);
80104dd8:	83 ec 0c             	sub    $0xc,%esp
80104ddb:	68 80 6b 11 80       	push   $0x80116b80
80104de0:	e8 6c ef ff ff       	call   80103d51 <release>
    return 0;
80104de5:	83 c4 10             	add    $0x10,%esp
80104de8:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ded:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104df0:	c9                   	leave  
80104df1:	c3                   	ret    
        return -1;
80104df2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df7:	eb f4                	jmp    80104ded <sys_sleep+0x89>

80104df9 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80104df9:	55                   	push   %ebp
80104dfa:	89 e5                	mov    %esp,%ebp
80104dfc:	53                   	push   %ebx
80104dfd:	83 ec 10             	sub    $0x10,%esp
    uint xticks;

    acquire(&tickslock);
80104e00:	68 80 6b 11 80       	push   $0x80116b80
80104e05:	e8 e2 ee ff ff       	call   80103cec <acquire>
    xticks = ticks;
80104e0a:	8b 1d 60 6b 11 80    	mov    0x80116b60,%ebx
    release(&tickslock);
80104e10:	c7 04 24 80 6b 11 80 	movl   $0x80116b80,(%esp)
80104e17:	e8 35 ef ff ff       	call   80103d51 <release>
    return xticks;
}
80104e1c:	89 d8                	mov    %ebx,%eax
80104e1e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e21:	c9                   	leave  
80104e22:	c3                   	ret    

80104e23 <sys_gethistory>:

// Defining the new system calls for processes
////////////////////////////////////////////////////////////////////////////////////////////

int sys_gethistory(void)
{
80104e23:	55                   	push   %ebp
80104e24:	89 e5                	mov    %esp,%ebp
80104e26:	83 ec 08             	sub    $0x8,%esp
    return proc_get_history();
80104e29:	e8 24 eb ff ff       	call   80103952 <proc_get_history>
}
80104e2e:	c9                   	leave  
80104e2f:	c3                   	ret    

80104e30 <sys_block>:

int sys_block(void)
{
80104e30:	55                   	push   %ebp
80104e31:	89 e5                	mov    %esp,%ebp
80104e33:	83 ec 20             	sub    $0x20,%esp
    int syscallid;
    argint(0, &syscallid);
80104e36:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e39:	50                   	push   %eax
80104e3a:	6a 00                	push   $0x0
80104e3c:	e8 8a f1 ff ff       	call   80103fcb <argint>

    if (syscallid == 1 || syscallid == 2){
80104e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104e44:	48                   	dec    %eax
80104e45:	83 c4 10             	add    $0x10,%esp
80104e48:	83 f8 01             	cmp    $0x1,%eax
80104e4b:	76 2f                	jbe    80104e7c <sys_block+0x4c>
        cprintf("block not successful\n");
        return -1;
    }

    struct proc *curproc = myproc();
80104e4d:	e8 15 e3 ff ff       	call   80103167 <myproc>
80104e52:	89 c2                	mov    %eax,%edx
    curproc->block_bit_vector = curproc->block_bit_vector | (1 << syscallid);
80104e54:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104e57:	b8 01 00 00 00       	mov    $0x1,%eax
80104e5c:	d3 e0                	shl    %cl,%eax
80104e5e:	09 82 84 00 00 00    	or     %eax,0x84(%edx)
    cprintf("syscall %d is blocked\n", syscallid);
80104e64:	83 ec 08             	sub    $0x8,%esp
80104e67:	51                   	push   %ecx
80104e68:	68 a5 6e 10 80       	push   $0x80106ea5
80104e6d:	e8 6d b7 ff ff       	call   801005df <cprintf>
    
    return 0;
80104e72:	83 c4 10             	add    $0x10,%esp
80104e75:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104e7a:	c9                   	leave  
80104e7b:	c3                   	ret    
        cprintf("block not successful\n");
80104e7c:	83 ec 0c             	sub    $0xc,%esp
80104e7f:	68 bb 6f 10 80       	push   $0x80106fbb
80104e84:	e8 56 b7 ff ff       	call   801005df <cprintf>
        return -1;
80104e89:	83 c4 10             	add    $0x10,%esp
80104e8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e91:	eb e7                	jmp    80104e7a <sys_block+0x4a>

80104e93 <sys_unblock>:

int sys_unblock(void)
{
80104e93:	55                   	push   %ebp
80104e94:	89 e5                	mov    %esp,%ebp
80104e96:	83 ec 20             	sub    $0x20,%esp
    int syscallid;
    argint(0, &syscallid);
80104e99:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e9c:	50                   	push   %eax
80104e9d:	6a 00                	push   $0x0
80104e9f:	e8 27 f1 ff ff       	call   80103fcb <argint>

    struct proc *curproc = myproc();
80104ea4:	e8 be e2 ff ff       	call   80103167 <myproc>
80104ea9:	89 c2                	mov    %eax,%edx
    curproc->block_bit_vector = curproc->block_bit_vector & ~(1 << syscallid);
80104eab:	8b 4d f4             	mov    -0xc(%ebp),%ecx
80104eae:	b8 01 00 00 00       	mov    $0x1,%eax
80104eb3:	d3 e0                	shl    %cl,%eax
80104eb5:	f7 d0                	not    %eax
80104eb7:	21 82 84 00 00 00    	and    %eax,0x84(%edx)
    cprintf("syscall %d is unblocked\n", syscallid);
80104ebd:	83 c4 08             	add    $0x8,%esp
80104ec0:	51                   	push   %ecx
80104ec1:	68 d1 6f 10 80       	push   $0x80106fd1
80104ec6:	e8 14 b7 ff ff       	call   801005df <cprintf>

    return -1;
}
80104ecb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ed0:	c9                   	leave  
80104ed1:	c3                   	ret    

80104ed2 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104ed2:	1e                   	push   %ds
  pushl %es
80104ed3:	06                   	push   %es
  pushl %fs
80104ed4:	0f a0                	push   %fs
  pushl %gs
80104ed6:	0f a8                	push   %gs
  pushal
80104ed8:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ed9:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104edd:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104edf:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104ee1:	54                   	push   %esp
  call trap
80104ee2:	e8 2f 01 00 00       	call   80105016 <trap>
  addl $4, %esp
80104ee7:	83 c4 04             	add    $0x4,%esp

80104eea <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104eea:	61                   	popa   
  popl %gs
80104eeb:	0f a9                	pop    %gs
  popl %fs
80104eed:	0f a1                	pop    %fs
  popl %es
80104eef:	07                   	pop    %es
  popl %ds
80104ef0:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104ef1:	83 c4 08             	add    $0x8,%esp
  iret
80104ef4:	cf                   	iret   

80104ef5 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104ef5:	55                   	push   %ebp
80104ef6:	89 e5                	mov    %esp,%ebp
80104ef8:	53                   	push   %ebx
80104ef9:	83 ec 04             	sub    $0x4,%esp
  int i;

  for(i = 0; i < 256; i++)
80104efc:	b8 00 00 00 00       	mov    $0x0,%eax
80104f01:	eb 72                	jmp    80104f75 <tvinit+0x80>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f03:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104f0a:	66 89 0c c5 c0 6b 11 	mov    %cx,-0x7fee9440(,%eax,8)
80104f11:	80 
80104f12:	66 c7 04 c5 c2 6b 11 	movw   $0x8,-0x7fee943e(,%eax,8)
80104f19:	80 08 00 
80104f1c:	8a 14 c5 c4 6b 11 80 	mov    -0x7fee943c(,%eax,8),%dl
80104f23:	83 e2 e0             	and    $0xffffffe0,%edx
80104f26:	88 14 c5 c4 6b 11 80 	mov    %dl,-0x7fee943c(,%eax,8)
80104f2d:	c6 04 c5 c4 6b 11 80 	movb   $0x0,-0x7fee943c(,%eax,8)
80104f34:	00 
80104f35:	8a 14 c5 c5 6b 11 80 	mov    -0x7fee943b(,%eax,8),%dl
80104f3c:	83 e2 f0             	and    $0xfffffff0,%edx
80104f3f:	83 ca 0e             	or     $0xe,%edx
80104f42:	88 14 c5 c5 6b 11 80 	mov    %dl,-0x7fee943b(,%eax,8)
80104f49:	88 d3                	mov    %dl,%bl
80104f4b:	83 e3 ef             	and    $0xffffffef,%ebx
80104f4e:	88 1c c5 c5 6b 11 80 	mov    %bl,-0x7fee943b(,%eax,8)
80104f55:	83 e2 8f             	and    $0xffffff8f,%edx
80104f58:	88 14 c5 c5 6b 11 80 	mov    %dl,-0x7fee943b(,%eax,8)
80104f5f:	83 ca 80             	or     $0xffffff80,%edx
80104f62:	88 14 c5 c5 6b 11 80 	mov    %dl,-0x7fee943b(,%eax,8)
80104f69:	c1 e9 10             	shr    $0x10,%ecx
80104f6c:	66 89 0c c5 c6 6b 11 	mov    %cx,-0x7fee943a(,%eax,8)
80104f73:	80 
  for(i = 0; i < 256; i++)
80104f74:	40                   	inc    %eax
80104f75:	3d ff 00 00 00       	cmp    $0xff,%eax
80104f7a:	7e 87                	jle    80104f03 <tvinit+0xe>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f7c:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104f82:	66 89 15 c0 6d 11 80 	mov    %dx,0x80116dc0
80104f89:	66 c7 05 c2 6d 11 80 	movw   $0x8,0x80116dc2
80104f90:	08 00 
80104f92:	a0 c4 6d 11 80       	mov    0x80116dc4,%al
80104f97:	83 e0 e0             	and    $0xffffffe0,%eax
80104f9a:	a2 c4 6d 11 80       	mov    %al,0x80116dc4
80104f9f:	c6 05 c4 6d 11 80 00 	movb   $0x0,0x80116dc4
80104fa6:	a0 c5 6d 11 80       	mov    0x80116dc5,%al
80104fab:	83 c8 0f             	or     $0xf,%eax
80104fae:	a2 c5 6d 11 80       	mov    %al,0x80116dc5
80104fb3:	83 e0 ef             	and    $0xffffffef,%eax
80104fb6:	a2 c5 6d 11 80       	mov    %al,0x80116dc5
80104fbb:	88 c1                	mov    %al,%cl
80104fbd:	83 c9 60             	or     $0x60,%ecx
80104fc0:	88 0d c5 6d 11 80    	mov    %cl,0x80116dc5
80104fc6:	83 c8 e0             	or     $0xffffffe0,%eax
80104fc9:	a2 c5 6d 11 80       	mov    %al,0x80116dc5
80104fce:	c1 ea 10             	shr    $0x10,%edx
80104fd1:	66 89 15 c6 6d 11 80 	mov    %dx,0x80116dc6

  initlock(&tickslock, "time");
80104fd8:	83 ec 08             	sub    $0x8,%esp
80104fdb:	68 ea 6f 10 80       	push   $0x80106fea
80104fe0:	68 80 6b 11 80       	push   $0x80116b80
80104fe5:	e8 c2 eb ff ff       	call   80103bac <initlock>
}
80104fea:	83 c4 10             	add    $0x10,%esp
80104fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ff0:	c9                   	leave  
80104ff1:	c3                   	ret    

80104ff2 <idtinit>:

void
idtinit(void)
{
80104ff2:	55                   	push   %ebp
80104ff3:	89 e5                	mov    %esp,%ebp
80104ff5:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104ff8:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104ffe:	b8 c0 6b 11 80       	mov    $0x80116bc0,%eax
80105003:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105007:	c1 e8 10             	shr    $0x10,%eax
8010500a:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
8010500e:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105011:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105014:	c9                   	leave  
80105015:	c3                   	ret    

80105016 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105016:	55                   	push   %ebp
80105017:	89 e5                	mov    %esp,%ebp
80105019:	57                   	push   %edi
8010501a:	56                   	push   %esi
8010501b:	53                   	push   %ebx
8010501c:	83 ec 1c             	sub    $0x1c,%esp
8010501f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105022:	8b 43 30             	mov    0x30(%ebx),%eax
80105025:	83 f8 40             	cmp    $0x40,%eax
80105028:	74 13                	je     8010503d <trap+0x27>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
8010502a:	83 e8 20             	sub    $0x20,%eax
8010502d:	83 f8 1f             	cmp    $0x1f,%eax
80105030:	0f 87 36 01 00 00    	ja     8010516c <trap+0x156>
80105036:	ff 24 85 90 70 10 80 	jmp    *-0x7fef8f70(,%eax,4)
    if(myproc()->killed)
8010503d:	e8 25 e1 ff ff       	call   80103167 <myproc>
80105042:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105046:	75 1f                	jne    80105067 <trap+0x51>
    myproc()->tf = tf;
80105048:	e8 1a e1 ff ff       	call   80103167 <myproc>
8010504d:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105050:	e8 39 f0 ff ff       	call   8010408e <syscall>
    if(myproc()->killed)
80105055:	e8 0d e1 ff ff       	call   80103167 <myproc>
8010505a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010505e:	74 7c                	je     801050dc <trap+0xc6>
      exit();
80105060:	e8 1a e8 ff ff       	call   8010387f <exit>
    return;
80105065:	eb 75                	jmp    801050dc <trap+0xc6>
      exit();
80105067:	e8 13 e8 ff ff       	call   8010387f <exit>
8010506c:	eb da                	jmp    80105048 <trap+0x32>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010506e:	e8 c3 e0 ff ff       	call   80103136 <cpuid>
80105073:	85 c0                	test   %eax,%eax
80105075:	74 6d                	je     801050e4 <trap+0xce>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105077:	e8 b8 d2 ff ff       	call   80102334 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010507c:	e8 e6 e0 ff ff       	call   80103167 <myproc>
80105081:	85 c0                	test   %eax,%eax
80105083:	74 1b                	je     801050a0 <trap+0x8a>
80105085:	e8 dd e0 ff ff       	call   80103167 <myproc>
8010508a:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010508e:	74 10                	je     801050a0 <trap+0x8a>
80105090:	8b 43 3c             	mov    0x3c(%ebx),%eax
80105093:	83 e0 03             	and    $0x3,%eax
80105096:	66 83 f8 03          	cmp    $0x3,%ax
8010509a:	0f 84 5f 01 00 00    	je     801051ff <trap+0x1e9>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801050a0:	e8 c2 e0 ff ff       	call   80103167 <myproc>
801050a5:	85 c0                	test   %eax,%eax
801050a7:	74 0f                	je     801050b8 <trap+0xa2>
801050a9:	e8 b9 e0 ff ff       	call   80103167 <myproc>
801050ae:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801050b2:	0f 84 51 01 00 00    	je     80105209 <trap+0x1f3>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801050b8:	e8 aa e0 ff ff       	call   80103167 <myproc>
801050bd:	85 c0                	test   %eax,%eax
801050bf:	74 1b                	je     801050dc <trap+0xc6>
801050c1:	e8 a1 e0 ff ff       	call   80103167 <myproc>
801050c6:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801050ca:	74 10                	je     801050dc <trap+0xc6>
801050cc:	8b 43 3c             	mov    0x3c(%ebx),%eax
801050cf:	83 e0 03             	and    $0x3,%eax
801050d2:	66 83 f8 03          	cmp    $0x3,%ax
801050d6:	0f 84 41 01 00 00    	je     8010521d <trap+0x207>
    exit();
}
801050dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050df:	5b                   	pop    %ebx
801050e0:	5e                   	pop    %esi
801050e1:	5f                   	pop    %edi
801050e2:	5d                   	pop    %ebp
801050e3:	c3                   	ret    
      acquire(&tickslock);
801050e4:	83 ec 0c             	sub    $0xc,%esp
801050e7:	68 80 6b 11 80       	push   $0x80116b80
801050ec:	e8 fb eb ff ff       	call   80103cec <acquire>
      ticks++;
801050f1:	ff 05 60 6b 11 80    	incl   0x80116b60
      wakeup(&ticks);
801050f7:	c7 04 24 60 6b 11 80 	movl   $0x80116b60,(%esp)
801050fe:	e8 a7 e5 ff ff       	call   801036aa <wakeup>
      release(&tickslock);
80105103:	c7 04 24 80 6b 11 80 	movl   $0x80116b80,(%esp)
8010510a:	e8 42 ec ff ff       	call   80103d51 <release>
8010510f:	83 c4 10             	add    $0x10,%esp
80105112:	e9 60 ff ff ff       	jmp    80105077 <trap+0x61>
    ideintr();
80105117:	e8 fc cb ff ff       	call   80101d18 <ideintr>
    lapiceoi();
8010511c:	e8 13 d2 ff ff       	call   80102334 <lapiceoi>
    break;
80105121:	e9 56 ff ff ff       	jmp    8010507c <trap+0x66>
    kbdintr();
80105126:	e8 53 d0 ff ff       	call   8010217e <kbdintr>
    lapiceoi();
8010512b:	e8 04 d2 ff ff       	call   80102334 <lapiceoi>
    break;
80105130:	e9 47 ff ff ff       	jmp    8010507c <trap+0x66>
    uartintr();
80105135:	e8 e9 01 00 00       	call   80105323 <uartintr>
    lapiceoi();
8010513a:	e8 f5 d1 ff ff       	call   80102334 <lapiceoi>
    break;
8010513f:	e9 38 ff ff ff       	jmp    8010507c <trap+0x66>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105144:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105147:	8b 73 3c             	mov    0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010514a:	e8 e7 df ff ff       	call   80103136 <cpuid>
8010514f:	57                   	push   %edi
80105150:	0f b7 f6             	movzwl %si,%esi
80105153:	56                   	push   %esi
80105154:	50                   	push   %eax
80105155:	68 f4 6f 10 80       	push   $0x80106ff4
8010515a:	e8 80 b4 ff ff       	call   801005df <cprintf>
    lapiceoi();
8010515f:	e8 d0 d1 ff ff       	call   80102334 <lapiceoi>
    break;
80105164:	83 c4 10             	add    $0x10,%esp
80105167:	e9 10 ff ff ff       	jmp    8010507c <trap+0x66>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010516c:	e8 f6 df ff ff       	call   80103167 <myproc>
80105171:	85 c0                	test   %eax,%eax
80105173:	74 5f                	je     801051d4 <trap+0x1be>
80105175:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105179:	74 59                	je     801051d4 <trap+0x1be>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010517b:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010517e:	8b 43 38             	mov    0x38(%ebx),%eax
80105181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105184:	e8 ad df ff ff       	call   80103136 <cpuid>
80105189:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010518c:	8b 53 34             	mov    0x34(%ebx),%edx
8010518f:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105192:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105195:	e8 cd df ff ff       	call   80103167 <myproc>
8010519a:	8d 48 6c             	lea    0x6c(%eax),%ecx
8010519d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801051a0:	e8 c2 df ff ff       	call   80103167 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801051a5:	57                   	push   %edi
801051a6:	ff 75 e4             	pushl  -0x1c(%ebp)
801051a9:	ff 75 e0             	pushl  -0x20(%ebp)
801051ac:	ff 75 dc             	pushl  -0x24(%ebp)
801051af:	56                   	push   %esi
801051b0:	ff 75 d8             	pushl  -0x28(%ebp)
801051b3:	ff 70 10             	pushl  0x10(%eax)
801051b6:	68 4c 70 10 80       	push   $0x8010704c
801051bb:	e8 1f b4 ff ff       	call   801005df <cprintf>
    myproc()->killed = 1;
801051c0:	83 c4 20             	add    $0x20,%esp
801051c3:	e8 9f df ff ff       	call   80103167 <myproc>
801051c8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801051cf:	e9 a8 fe ff ff       	jmp    8010507c <trap+0x66>
801051d4:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801051d7:	8b 73 38             	mov    0x38(%ebx),%esi
801051da:	e8 57 df ff ff       	call   80103136 <cpuid>
801051df:	83 ec 0c             	sub    $0xc,%esp
801051e2:	57                   	push   %edi
801051e3:	56                   	push   %esi
801051e4:	50                   	push   %eax
801051e5:	ff 73 30             	pushl  0x30(%ebx)
801051e8:	68 18 70 10 80       	push   $0x80107018
801051ed:	e8 ed b3 ff ff       	call   801005df <cprintf>
      panic("trap");
801051f2:	83 c4 14             	add    $0x14,%esp
801051f5:	68 ef 6f 10 80       	push   $0x80106fef
801051fa:	e8 45 b1 ff ff       	call   80100344 <panic>
    exit();
801051ff:	e8 7b e6 ff ff       	call   8010387f <exit>
80105204:	e9 97 fe ff ff       	jmp    801050a0 <trap+0x8a>
  if(myproc() && myproc()->state == RUNNING &&
80105209:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
8010520d:	0f 85 a5 fe ff ff    	jne    801050b8 <trap+0xa2>
    yield();
80105213:	e8 f8 e2 ff ff       	call   80103510 <yield>
80105218:	e9 9b fe ff ff       	jmp    801050b8 <trap+0xa2>
    exit();
8010521d:	e8 5d e6 ff ff       	call   8010387f <exit>
80105222:	e9 b5 fe ff ff       	jmp    801050dc <trap+0xc6>

80105227 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105227:	83 3d c0 73 11 80 00 	cmpl   $0x0,0x801173c0
8010522e:	74 14                	je     80105244 <uartgetc+0x1d>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105230:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105235:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105236:	a8 01                	test   $0x1,%al
80105238:	74 10                	je     8010524a <uartgetc+0x23>
8010523a:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010523f:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105240:	0f b6 c0             	movzbl %al,%eax
80105243:	c3                   	ret    
    return -1;
80105244:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105249:	c3                   	ret    
    return -1;
8010524a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010524f:	c3                   	ret    

80105250 <uartputc>:
  if(!uart)
80105250:	83 3d c0 73 11 80 00 	cmpl   $0x0,0x801173c0
80105257:	74 39                	je     80105292 <uartputc+0x42>
{
80105259:	55                   	push   %ebp
8010525a:	89 e5                	mov    %esp,%ebp
8010525c:	53                   	push   %ebx
8010525d:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105260:	bb 00 00 00 00       	mov    $0x0,%ebx
80105265:	eb 0e                	jmp    80105275 <uartputc+0x25>
    microdelay(10);
80105267:	83 ec 0c             	sub    $0xc,%esp
8010526a:	6a 0a                	push   $0xa
8010526c:	e8 e4 d0 ff ff       	call   80102355 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105271:	43                   	inc    %ebx
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	83 fb 7f             	cmp    $0x7f,%ebx
80105278:	7f 0a                	jg     80105284 <uartputc+0x34>
8010527a:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010527f:	ec                   	in     (%dx),%al
80105280:	a8 20                	test   $0x20,%al
80105282:	74 e3                	je     80105267 <uartputc+0x17>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105284:	8b 45 08             	mov    0x8(%ebp),%eax
80105287:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010528c:	ee                   	out    %al,(%dx)
}
8010528d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105290:	c9                   	leave  
80105291:	c3                   	ret    
80105292:	c3                   	ret    

80105293 <uartinit>:
{
80105293:	55                   	push   %ebp
80105294:	89 e5                	mov    %esp,%ebp
80105296:	56                   	push   %esi
80105297:	53                   	push   %ebx
80105298:	b1 00                	mov    $0x0,%cl
8010529a:	ba fa 03 00 00       	mov    $0x3fa,%edx
8010529f:	88 c8                	mov    %cl,%al
801052a1:	ee                   	out    %al,(%dx)
801052a2:	be fb 03 00 00       	mov    $0x3fb,%esi
801052a7:	b0 80                	mov    $0x80,%al
801052a9:	89 f2                	mov    %esi,%edx
801052ab:	ee                   	out    %al,(%dx)
801052ac:	b0 0c                	mov    $0xc,%al
801052ae:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052b3:	ee                   	out    %al,(%dx)
801052b4:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801052b9:	88 c8                	mov    %cl,%al
801052bb:	89 da                	mov    %ebx,%edx
801052bd:	ee                   	out    %al,(%dx)
801052be:	b0 03                	mov    $0x3,%al
801052c0:	89 f2                	mov    %esi,%edx
801052c2:	ee                   	out    %al,(%dx)
801052c3:	ba fc 03 00 00       	mov    $0x3fc,%edx
801052c8:	88 c8                	mov    %cl,%al
801052ca:	ee                   	out    %al,(%dx)
801052cb:	b0 01                	mov    $0x1,%al
801052cd:	89 da                	mov    %ebx,%edx
801052cf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801052d0:	ba fd 03 00 00       	mov    $0x3fd,%edx
801052d5:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801052d6:	3c ff                	cmp    $0xff,%al
801052d8:	74 42                	je     8010531c <uartinit+0x89>
  uart = 1;
801052da:	c7 05 c0 73 11 80 01 	movl   $0x1,0x801173c0
801052e1:	00 00 00 
801052e4:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052e9:	ec                   	in     (%dx),%al
801052ea:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052ef:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801052f0:	83 ec 08             	sub    $0x8,%esp
801052f3:	6a 00                	push   $0x0
801052f5:	6a 04                	push   $0x4
801052f7:	e8 24 cc ff ff       	call   80101f20 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801052fc:	83 c4 10             	add    $0x10,%esp
801052ff:	bb 10 71 10 80       	mov    $0x80107110,%ebx
80105304:	eb 10                	jmp    80105316 <uartinit+0x83>
    uartputc(*p);
80105306:	83 ec 0c             	sub    $0xc,%esp
80105309:	0f be c0             	movsbl %al,%eax
8010530c:	50                   	push   %eax
8010530d:	e8 3e ff ff ff       	call   80105250 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105312:	43                   	inc    %ebx
80105313:	83 c4 10             	add    $0x10,%esp
80105316:	8a 03                	mov    (%ebx),%al
80105318:	84 c0                	test   %al,%al
8010531a:	75 ea                	jne    80105306 <uartinit+0x73>
}
8010531c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010531f:	5b                   	pop    %ebx
80105320:	5e                   	pop    %esi
80105321:	5d                   	pop    %ebp
80105322:	c3                   	ret    

80105323 <uartintr>:

void
uartintr(void)
{
80105323:	55                   	push   %ebp
80105324:	89 e5                	mov    %esp,%ebp
80105326:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105329:	68 27 52 10 80       	push   $0x80105227
8010532e:	e8 d1 b3 ff ff       	call   80100704 <consoleintr>
}
80105333:	83 c4 10             	add    $0x10,%esp
80105336:	c9                   	leave  
80105337:	c3                   	ret    

80105338 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105338:	6a 00                	push   $0x0
  pushl $0
8010533a:	6a 00                	push   $0x0
  jmp alltraps
8010533c:	e9 91 fb ff ff       	jmp    80104ed2 <alltraps>

80105341 <vector1>:
.globl vector1
vector1:
  pushl $0
80105341:	6a 00                	push   $0x0
  pushl $1
80105343:	6a 01                	push   $0x1
  jmp alltraps
80105345:	e9 88 fb ff ff       	jmp    80104ed2 <alltraps>

8010534a <vector2>:
.globl vector2
vector2:
  pushl $0
8010534a:	6a 00                	push   $0x0
  pushl $2
8010534c:	6a 02                	push   $0x2
  jmp alltraps
8010534e:	e9 7f fb ff ff       	jmp    80104ed2 <alltraps>

80105353 <vector3>:
.globl vector3
vector3:
  pushl $0
80105353:	6a 00                	push   $0x0
  pushl $3
80105355:	6a 03                	push   $0x3
  jmp alltraps
80105357:	e9 76 fb ff ff       	jmp    80104ed2 <alltraps>

8010535c <vector4>:
.globl vector4
vector4:
  pushl $0
8010535c:	6a 00                	push   $0x0
  pushl $4
8010535e:	6a 04                	push   $0x4
  jmp alltraps
80105360:	e9 6d fb ff ff       	jmp    80104ed2 <alltraps>

80105365 <vector5>:
.globl vector5
vector5:
  pushl $0
80105365:	6a 00                	push   $0x0
  pushl $5
80105367:	6a 05                	push   $0x5
  jmp alltraps
80105369:	e9 64 fb ff ff       	jmp    80104ed2 <alltraps>

8010536e <vector6>:
.globl vector6
vector6:
  pushl $0
8010536e:	6a 00                	push   $0x0
  pushl $6
80105370:	6a 06                	push   $0x6
  jmp alltraps
80105372:	e9 5b fb ff ff       	jmp    80104ed2 <alltraps>

80105377 <vector7>:
.globl vector7
vector7:
  pushl $0
80105377:	6a 00                	push   $0x0
  pushl $7
80105379:	6a 07                	push   $0x7
  jmp alltraps
8010537b:	e9 52 fb ff ff       	jmp    80104ed2 <alltraps>

80105380 <vector8>:
.globl vector8
vector8:
  pushl $8
80105380:	6a 08                	push   $0x8
  jmp alltraps
80105382:	e9 4b fb ff ff       	jmp    80104ed2 <alltraps>

80105387 <vector9>:
.globl vector9
vector9:
  pushl $0
80105387:	6a 00                	push   $0x0
  pushl $9
80105389:	6a 09                	push   $0x9
  jmp alltraps
8010538b:	e9 42 fb ff ff       	jmp    80104ed2 <alltraps>

80105390 <vector10>:
.globl vector10
vector10:
  pushl $10
80105390:	6a 0a                	push   $0xa
  jmp alltraps
80105392:	e9 3b fb ff ff       	jmp    80104ed2 <alltraps>

80105397 <vector11>:
.globl vector11
vector11:
  pushl $11
80105397:	6a 0b                	push   $0xb
  jmp alltraps
80105399:	e9 34 fb ff ff       	jmp    80104ed2 <alltraps>

8010539e <vector12>:
.globl vector12
vector12:
  pushl $12
8010539e:	6a 0c                	push   $0xc
  jmp alltraps
801053a0:	e9 2d fb ff ff       	jmp    80104ed2 <alltraps>

801053a5 <vector13>:
.globl vector13
vector13:
  pushl $13
801053a5:	6a 0d                	push   $0xd
  jmp alltraps
801053a7:	e9 26 fb ff ff       	jmp    80104ed2 <alltraps>

801053ac <vector14>:
.globl vector14
vector14:
  pushl $14
801053ac:	6a 0e                	push   $0xe
  jmp alltraps
801053ae:	e9 1f fb ff ff       	jmp    80104ed2 <alltraps>

801053b3 <vector15>:
.globl vector15
vector15:
  pushl $0
801053b3:	6a 00                	push   $0x0
  pushl $15
801053b5:	6a 0f                	push   $0xf
  jmp alltraps
801053b7:	e9 16 fb ff ff       	jmp    80104ed2 <alltraps>

801053bc <vector16>:
.globl vector16
vector16:
  pushl $0
801053bc:	6a 00                	push   $0x0
  pushl $16
801053be:	6a 10                	push   $0x10
  jmp alltraps
801053c0:	e9 0d fb ff ff       	jmp    80104ed2 <alltraps>

801053c5 <vector17>:
.globl vector17
vector17:
  pushl $17
801053c5:	6a 11                	push   $0x11
  jmp alltraps
801053c7:	e9 06 fb ff ff       	jmp    80104ed2 <alltraps>

801053cc <vector18>:
.globl vector18
vector18:
  pushl $0
801053cc:	6a 00                	push   $0x0
  pushl $18
801053ce:	6a 12                	push   $0x12
  jmp alltraps
801053d0:	e9 fd fa ff ff       	jmp    80104ed2 <alltraps>

801053d5 <vector19>:
.globl vector19
vector19:
  pushl $0
801053d5:	6a 00                	push   $0x0
  pushl $19
801053d7:	6a 13                	push   $0x13
  jmp alltraps
801053d9:	e9 f4 fa ff ff       	jmp    80104ed2 <alltraps>

801053de <vector20>:
.globl vector20
vector20:
  pushl $0
801053de:	6a 00                	push   $0x0
  pushl $20
801053e0:	6a 14                	push   $0x14
  jmp alltraps
801053e2:	e9 eb fa ff ff       	jmp    80104ed2 <alltraps>

801053e7 <vector21>:
.globl vector21
vector21:
  pushl $0
801053e7:	6a 00                	push   $0x0
  pushl $21
801053e9:	6a 15                	push   $0x15
  jmp alltraps
801053eb:	e9 e2 fa ff ff       	jmp    80104ed2 <alltraps>

801053f0 <vector22>:
.globl vector22
vector22:
  pushl $0
801053f0:	6a 00                	push   $0x0
  pushl $22
801053f2:	6a 16                	push   $0x16
  jmp alltraps
801053f4:	e9 d9 fa ff ff       	jmp    80104ed2 <alltraps>

801053f9 <vector23>:
.globl vector23
vector23:
  pushl $0
801053f9:	6a 00                	push   $0x0
  pushl $23
801053fb:	6a 17                	push   $0x17
  jmp alltraps
801053fd:	e9 d0 fa ff ff       	jmp    80104ed2 <alltraps>

80105402 <vector24>:
.globl vector24
vector24:
  pushl $0
80105402:	6a 00                	push   $0x0
  pushl $24
80105404:	6a 18                	push   $0x18
  jmp alltraps
80105406:	e9 c7 fa ff ff       	jmp    80104ed2 <alltraps>

8010540b <vector25>:
.globl vector25
vector25:
  pushl $0
8010540b:	6a 00                	push   $0x0
  pushl $25
8010540d:	6a 19                	push   $0x19
  jmp alltraps
8010540f:	e9 be fa ff ff       	jmp    80104ed2 <alltraps>

80105414 <vector26>:
.globl vector26
vector26:
  pushl $0
80105414:	6a 00                	push   $0x0
  pushl $26
80105416:	6a 1a                	push   $0x1a
  jmp alltraps
80105418:	e9 b5 fa ff ff       	jmp    80104ed2 <alltraps>

8010541d <vector27>:
.globl vector27
vector27:
  pushl $0
8010541d:	6a 00                	push   $0x0
  pushl $27
8010541f:	6a 1b                	push   $0x1b
  jmp alltraps
80105421:	e9 ac fa ff ff       	jmp    80104ed2 <alltraps>

80105426 <vector28>:
.globl vector28
vector28:
  pushl $0
80105426:	6a 00                	push   $0x0
  pushl $28
80105428:	6a 1c                	push   $0x1c
  jmp alltraps
8010542a:	e9 a3 fa ff ff       	jmp    80104ed2 <alltraps>

8010542f <vector29>:
.globl vector29
vector29:
  pushl $0
8010542f:	6a 00                	push   $0x0
  pushl $29
80105431:	6a 1d                	push   $0x1d
  jmp alltraps
80105433:	e9 9a fa ff ff       	jmp    80104ed2 <alltraps>

80105438 <vector30>:
.globl vector30
vector30:
  pushl $0
80105438:	6a 00                	push   $0x0
  pushl $30
8010543a:	6a 1e                	push   $0x1e
  jmp alltraps
8010543c:	e9 91 fa ff ff       	jmp    80104ed2 <alltraps>

80105441 <vector31>:
.globl vector31
vector31:
  pushl $0
80105441:	6a 00                	push   $0x0
  pushl $31
80105443:	6a 1f                	push   $0x1f
  jmp alltraps
80105445:	e9 88 fa ff ff       	jmp    80104ed2 <alltraps>

8010544a <vector32>:
.globl vector32
vector32:
  pushl $0
8010544a:	6a 00                	push   $0x0
  pushl $32
8010544c:	6a 20                	push   $0x20
  jmp alltraps
8010544e:	e9 7f fa ff ff       	jmp    80104ed2 <alltraps>

80105453 <vector33>:
.globl vector33
vector33:
  pushl $0
80105453:	6a 00                	push   $0x0
  pushl $33
80105455:	6a 21                	push   $0x21
  jmp alltraps
80105457:	e9 76 fa ff ff       	jmp    80104ed2 <alltraps>

8010545c <vector34>:
.globl vector34
vector34:
  pushl $0
8010545c:	6a 00                	push   $0x0
  pushl $34
8010545e:	6a 22                	push   $0x22
  jmp alltraps
80105460:	e9 6d fa ff ff       	jmp    80104ed2 <alltraps>

80105465 <vector35>:
.globl vector35
vector35:
  pushl $0
80105465:	6a 00                	push   $0x0
  pushl $35
80105467:	6a 23                	push   $0x23
  jmp alltraps
80105469:	e9 64 fa ff ff       	jmp    80104ed2 <alltraps>

8010546e <vector36>:
.globl vector36
vector36:
  pushl $0
8010546e:	6a 00                	push   $0x0
  pushl $36
80105470:	6a 24                	push   $0x24
  jmp alltraps
80105472:	e9 5b fa ff ff       	jmp    80104ed2 <alltraps>

80105477 <vector37>:
.globl vector37
vector37:
  pushl $0
80105477:	6a 00                	push   $0x0
  pushl $37
80105479:	6a 25                	push   $0x25
  jmp alltraps
8010547b:	e9 52 fa ff ff       	jmp    80104ed2 <alltraps>

80105480 <vector38>:
.globl vector38
vector38:
  pushl $0
80105480:	6a 00                	push   $0x0
  pushl $38
80105482:	6a 26                	push   $0x26
  jmp alltraps
80105484:	e9 49 fa ff ff       	jmp    80104ed2 <alltraps>

80105489 <vector39>:
.globl vector39
vector39:
  pushl $0
80105489:	6a 00                	push   $0x0
  pushl $39
8010548b:	6a 27                	push   $0x27
  jmp alltraps
8010548d:	e9 40 fa ff ff       	jmp    80104ed2 <alltraps>

80105492 <vector40>:
.globl vector40
vector40:
  pushl $0
80105492:	6a 00                	push   $0x0
  pushl $40
80105494:	6a 28                	push   $0x28
  jmp alltraps
80105496:	e9 37 fa ff ff       	jmp    80104ed2 <alltraps>

8010549b <vector41>:
.globl vector41
vector41:
  pushl $0
8010549b:	6a 00                	push   $0x0
  pushl $41
8010549d:	6a 29                	push   $0x29
  jmp alltraps
8010549f:	e9 2e fa ff ff       	jmp    80104ed2 <alltraps>

801054a4 <vector42>:
.globl vector42
vector42:
  pushl $0
801054a4:	6a 00                	push   $0x0
  pushl $42
801054a6:	6a 2a                	push   $0x2a
  jmp alltraps
801054a8:	e9 25 fa ff ff       	jmp    80104ed2 <alltraps>

801054ad <vector43>:
.globl vector43
vector43:
  pushl $0
801054ad:	6a 00                	push   $0x0
  pushl $43
801054af:	6a 2b                	push   $0x2b
  jmp alltraps
801054b1:	e9 1c fa ff ff       	jmp    80104ed2 <alltraps>

801054b6 <vector44>:
.globl vector44
vector44:
  pushl $0
801054b6:	6a 00                	push   $0x0
  pushl $44
801054b8:	6a 2c                	push   $0x2c
  jmp alltraps
801054ba:	e9 13 fa ff ff       	jmp    80104ed2 <alltraps>

801054bf <vector45>:
.globl vector45
vector45:
  pushl $0
801054bf:	6a 00                	push   $0x0
  pushl $45
801054c1:	6a 2d                	push   $0x2d
  jmp alltraps
801054c3:	e9 0a fa ff ff       	jmp    80104ed2 <alltraps>

801054c8 <vector46>:
.globl vector46
vector46:
  pushl $0
801054c8:	6a 00                	push   $0x0
  pushl $46
801054ca:	6a 2e                	push   $0x2e
  jmp alltraps
801054cc:	e9 01 fa ff ff       	jmp    80104ed2 <alltraps>

801054d1 <vector47>:
.globl vector47
vector47:
  pushl $0
801054d1:	6a 00                	push   $0x0
  pushl $47
801054d3:	6a 2f                	push   $0x2f
  jmp alltraps
801054d5:	e9 f8 f9 ff ff       	jmp    80104ed2 <alltraps>

801054da <vector48>:
.globl vector48
vector48:
  pushl $0
801054da:	6a 00                	push   $0x0
  pushl $48
801054dc:	6a 30                	push   $0x30
  jmp alltraps
801054de:	e9 ef f9 ff ff       	jmp    80104ed2 <alltraps>

801054e3 <vector49>:
.globl vector49
vector49:
  pushl $0
801054e3:	6a 00                	push   $0x0
  pushl $49
801054e5:	6a 31                	push   $0x31
  jmp alltraps
801054e7:	e9 e6 f9 ff ff       	jmp    80104ed2 <alltraps>

801054ec <vector50>:
.globl vector50
vector50:
  pushl $0
801054ec:	6a 00                	push   $0x0
  pushl $50
801054ee:	6a 32                	push   $0x32
  jmp alltraps
801054f0:	e9 dd f9 ff ff       	jmp    80104ed2 <alltraps>

801054f5 <vector51>:
.globl vector51
vector51:
  pushl $0
801054f5:	6a 00                	push   $0x0
  pushl $51
801054f7:	6a 33                	push   $0x33
  jmp alltraps
801054f9:	e9 d4 f9 ff ff       	jmp    80104ed2 <alltraps>

801054fe <vector52>:
.globl vector52
vector52:
  pushl $0
801054fe:	6a 00                	push   $0x0
  pushl $52
80105500:	6a 34                	push   $0x34
  jmp alltraps
80105502:	e9 cb f9 ff ff       	jmp    80104ed2 <alltraps>

80105507 <vector53>:
.globl vector53
vector53:
  pushl $0
80105507:	6a 00                	push   $0x0
  pushl $53
80105509:	6a 35                	push   $0x35
  jmp alltraps
8010550b:	e9 c2 f9 ff ff       	jmp    80104ed2 <alltraps>

80105510 <vector54>:
.globl vector54
vector54:
  pushl $0
80105510:	6a 00                	push   $0x0
  pushl $54
80105512:	6a 36                	push   $0x36
  jmp alltraps
80105514:	e9 b9 f9 ff ff       	jmp    80104ed2 <alltraps>

80105519 <vector55>:
.globl vector55
vector55:
  pushl $0
80105519:	6a 00                	push   $0x0
  pushl $55
8010551b:	6a 37                	push   $0x37
  jmp alltraps
8010551d:	e9 b0 f9 ff ff       	jmp    80104ed2 <alltraps>

80105522 <vector56>:
.globl vector56
vector56:
  pushl $0
80105522:	6a 00                	push   $0x0
  pushl $56
80105524:	6a 38                	push   $0x38
  jmp alltraps
80105526:	e9 a7 f9 ff ff       	jmp    80104ed2 <alltraps>

8010552b <vector57>:
.globl vector57
vector57:
  pushl $0
8010552b:	6a 00                	push   $0x0
  pushl $57
8010552d:	6a 39                	push   $0x39
  jmp alltraps
8010552f:	e9 9e f9 ff ff       	jmp    80104ed2 <alltraps>

80105534 <vector58>:
.globl vector58
vector58:
  pushl $0
80105534:	6a 00                	push   $0x0
  pushl $58
80105536:	6a 3a                	push   $0x3a
  jmp alltraps
80105538:	e9 95 f9 ff ff       	jmp    80104ed2 <alltraps>

8010553d <vector59>:
.globl vector59
vector59:
  pushl $0
8010553d:	6a 00                	push   $0x0
  pushl $59
8010553f:	6a 3b                	push   $0x3b
  jmp alltraps
80105541:	e9 8c f9 ff ff       	jmp    80104ed2 <alltraps>

80105546 <vector60>:
.globl vector60
vector60:
  pushl $0
80105546:	6a 00                	push   $0x0
  pushl $60
80105548:	6a 3c                	push   $0x3c
  jmp alltraps
8010554a:	e9 83 f9 ff ff       	jmp    80104ed2 <alltraps>

8010554f <vector61>:
.globl vector61
vector61:
  pushl $0
8010554f:	6a 00                	push   $0x0
  pushl $61
80105551:	6a 3d                	push   $0x3d
  jmp alltraps
80105553:	e9 7a f9 ff ff       	jmp    80104ed2 <alltraps>

80105558 <vector62>:
.globl vector62
vector62:
  pushl $0
80105558:	6a 00                	push   $0x0
  pushl $62
8010555a:	6a 3e                	push   $0x3e
  jmp alltraps
8010555c:	e9 71 f9 ff ff       	jmp    80104ed2 <alltraps>

80105561 <vector63>:
.globl vector63
vector63:
  pushl $0
80105561:	6a 00                	push   $0x0
  pushl $63
80105563:	6a 3f                	push   $0x3f
  jmp alltraps
80105565:	e9 68 f9 ff ff       	jmp    80104ed2 <alltraps>

8010556a <vector64>:
.globl vector64
vector64:
  pushl $0
8010556a:	6a 00                	push   $0x0
  pushl $64
8010556c:	6a 40                	push   $0x40
  jmp alltraps
8010556e:	e9 5f f9 ff ff       	jmp    80104ed2 <alltraps>

80105573 <vector65>:
.globl vector65
vector65:
  pushl $0
80105573:	6a 00                	push   $0x0
  pushl $65
80105575:	6a 41                	push   $0x41
  jmp alltraps
80105577:	e9 56 f9 ff ff       	jmp    80104ed2 <alltraps>

8010557c <vector66>:
.globl vector66
vector66:
  pushl $0
8010557c:	6a 00                	push   $0x0
  pushl $66
8010557e:	6a 42                	push   $0x42
  jmp alltraps
80105580:	e9 4d f9 ff ff       	jmp    80104ed2 <alltraps>

80105585 <vector67>:
.globl vector67
vector67:
  pushl $0
80105585:	6a 00                	push   $0x0
  pushl $67
80105587:	6a 43                	push   $0x43
  jmp alltraps
80105589:	e9 44 f9 ff ff       	jmp    80104ed2 <alltraps>

8010558e <vector68>:
.globl vector68
vector68:
  pushl $0
8010558e:	6a 00                	push   $0x0
  pushl $68
80105590:	6a 44                	push   $0x44
  jmp alltraps
80105592:	e9 3b f9 ff ff       	jmp    80104ed2 <alltraps>

80105597 <vector69>:
.globl vector69
vector69:
  pushl $0
80105597:	6a 00                	push   $0x0
  pushl $69
80105599:	6a 45                	push   $0x45
  jmp alltraps
8010559b:	e9 32 f9 ff ff       	jmp    80104ed2 <alltraps>

801055a0 <vector70>:
.globl vector70
vector70:
  pushl $0
801055a0:	6a 00                	push   $0x0
  pushl $70
801055a2:	6a 46                	push   $0x46
  jmp alltraps
801055a4:	e9 29 f9 ff ff       	jmp    80104ed2 <alltraps>

801055a9 <vector71>:
.globl vector71
vector71:
  pushl $0
801055a9:	6a 00                	push   $0x0
  pushl $71
801055ab:	6a 47                	push   $0x47
  jmp alltraps
801055ad:	e9 20 f9 ff ff       	jmp    80104ed2 <alltraps>

801055b2 <vector72>:
.globl vector72
vector72:
  pushl $0
801055b2:	6a 00                	push   $0x0
  pushl $72
801055b4:	6a 48                	push   $0x48
  jmp alltraps
801055b6:	e9 17 f9 ff ff       	jmp    80104ed2 <alltraps>

801055bb <vector73>:
.globl vector73
vector73:
  pushl $0
801055bb:	6a 00                	push   $0x0
  pushl $73
801055bd:	6a 49                	push   $0x49
  jmp alltraps
801055bf:	e9 0e f9 ff ff       	jmp    80104ed2 <alltraps>

801055c4 <vector74>:
.globl vector74
vector74:
  pushl $0
801055c4:	6a 00                	push   $0x0
  pushl $74
801055c6:	6a 4a                	push   $0x4a
  jmp alltraps
801055c8:	e9 05 f9 ff ff       	jmp    80104ed2 <alltraps>

801055cd <vector75>:
.globl vector75
vector75:
  pushl $0
801055cd:	6a 00                	push   $0x0
  pushl $75
801055cf:	6a 4b                	push   $0x4b
  jmp alltraps
801055d1:	e9 fc f8 ff ff       	jmp    80104ed2 <alltraps>

801055d6 <vector76>:
.globl vector76
vector76:
  pushl $0
801055d6:	6a 00                	push   $0x0
  pushl $76
801055d8:	6a 4c                	push   $0x4c
  jmp alltraps
801055da:	e9 f3 f8 ff ff       	jmp    80104ed2 <alltraps>

801055df <vector77>:
.globl vector77
vector77:
  pushl $0
801055df:	6a 00                	push   $0x0
  pushl $77
801055e1:	6a 4d                	push   $0x4d
  jmp alltraps
801055e3:	e9 ea f8 ff ff       	jmp    80104ed2 <alltraps>

801055e8 <vector78>:
.globl vector78
vector78:
  pushl $0
801055e8:	6a 00                	push   $0x0
  pushl $78
801055ea:	6a 4e                	push   $0x4e
  jmp alltraps
801055ec:	e9 e1 f8 ff ff       	jmp    80104ed2 <alltraps>

801055f1 <vector79>:
.globl vector79
vector79:
  pushl $0
801055f1:	6a 00                	push   $0x0
  pushl $79
801055f3:	6a 4f                	push   $0x4f
  jmp alltraps
801055f5:	e9 d8 f8 ff ff       	jmp    80104ed2 <alltraps>

801055fa <vector80>:
.globl vector80
vector80:
  pushl $0
801055fa:	6a 00                	push   $0x0
  pushl $80
801055fc:	6a 50                	push   $0x50
  jmp alltraps
801055fe:	e9 cf f8 ff ff       	jmp    80104ed2 <alltraps>

80105603 <vector81>:
.globl vector81
vector81:
  pushl $0
80105603:	6a 00                	push   $0x0
  pushl $81
80105605:	6a 51                	push   $0x51
  jmp alltraps
80105607:	e9 c6 f8 ff ff       	jmp    80104ed2 <alltraps>

8010560c <vector82>:
.globl vector82
vector82:
  pushl $0
8010560c:	6a 00                	push   $0x0
  pushl $82
8010560e:	6a 52                	push   $0x52
  jmp alltraps
80105610:	e9 bd f8 ff ff       	jmp    80104ed2 <alltraps>

80105615 <vector83>:
.globl vector83
vector83:
  pushl $0
80105615:	6a 00                	push   $0x0
  pushl $83
80105617:	6a 53                	push   $0x53
  jmp alltraps
80105619:	e9 b4 f8 ff ff       	jmp    80104ed2 <alltraps>

8010561e <vector84>:
.globl vector84
vector84:
  pushl $0
8010561e:	6a 00                	push   $0x0
  pushl $84
80105620:	6a 54                	push   $0x54
  jmp alltraps
80105622:	e9 ab f8 ff ff       	jmp    80104ed2 <alltraps>

80105627 <vector85>:
.globl vector85
vector85:
  pushl $0
80105627:	6a 00                	push   $0x0
  pushl $85
80105629:	6a 55                	push   $0x55
  jmp alltraps
8010562b:	e9 a2 f8 ff ff       	jmp    80104ed2 <alltraps>

80105630 <vector86>:
.globl vector86
vector86:
  pushl $0
80105630:	6a 00                	push   $0x0
  pushl $86
80105632:	6a 56                	push   $0x56
  jmp alltraps
80105634:	e9 99 f8 ff ff       	jmp    80104ed2 <alltraps>

80105639 <vector87>:
.globl vector87
vector87:
  pushl $0
80105639:	6a 00                	push   $0x0
  pushl $87
8010563b:	6a 57                	push   $0x57
  jmp alltraps
8010563d:	e9 90 f8 ff ff       	jmp    80104ed2 <alltraps>

80105642 <vector88>:
.globl vector88
vector88:
  pushl $0
80105642:	6a 00                	push   $0x0
  pushl $88
80105644:	6a 58                	push   $0x58
  jmp alltraps
80105646:	e9 87 f8 ff ff       	jmp    80104ed2 <alltraps>

8010564b <vector89>:
.globl vector89
vector89:
  pushl $0
8010564b:	6a 00                	push   $0x0
  pushl $89
8010564d:	6a 59                	push   $0x59
  jmp alltraps
8010564f:	e9 7e f8 ff ff       	jmp    80104ed2 <alltraps>

80105654 <vector90>:
.globl vector90
vector90:
  pushl $0
80105654:	6a 00                	push   $0x0
  pushl $90
80105656:	6a 5a                	push   $0x5a
  jmp alltraps
80105658:	e9 75 f8 ff ff       	jmp    80104ed2 <alltraps>

8010565d <vector91>:
.globl vector91
vector91:
  pushl $0
8010565d:	6a 00                	push   $0x0
  pushl $91
8010565f:	6a 5b                	push   $0x5b
  jmp alltraps
80105661:	e9 6c f8 ff ff       	jmp    80104ed2 <alltraps>

80105666 <vector92>:
.globl vector92
vector92:
  pushl $0
80105666:	6a 00                	push   $0x0
  pushl $92
80105668:	6a 5c                	push   $0x5c
  jmp alltraps
8010566a:	e9 63 f8 ff ff       	jmp    80104ed2 <alltraps>

8010566f <vector93>:
.globl vector93
vector93:
  pushl $0
8010566f:	6a 00                	push   $0x0
  pushl $93
80105671:	6a 5d                	push   $0x5d
  jmp alltraps
80105673:	e9 5a f8 ff ff       	jmp    80104ed2 <alltraps>

80105678 <vector94>:
.globl vector94
vector94:
  pushl $0
80105678:	6a 00                	push   $0x0
  pushl $94
8010567a:	6a 5e                	push   $0x5e
  jmp alltraps
8010567c:	e9 51 f8 ff ff       	jmp    80104ed2 <alltraps>

80105681 <vector95>:
.globl vector95
vector95:
  pushl $0
80105681:	6a 00                	push   $0x0
  pushl $95
80105683:	6a 5f                	push   $0x5f
  jmp alltraps
80105685:	e9 48 f8 ff ff       	jmp    80104ed2 <alltraps>

8010568a <vector96>:
.globl vector96
vector96:
  pushl $0
8010568a:	6a 00                	push   $0x0
  pushl $96
8010568c:	6a 60                	push   $0x60
  jmp alltraps
8010568e:	e9 3f f8 ff ff       	jmp    80104ed2 <alltraps>

80105693 <vector97>:
.globl vector97
vector97:
  pushl $0
80105693:	6a 00                	push   $0x0
  pushl $97
80105695:	6a 61                	push   $0x61
  jmp alltraps
80105697:	e9 36 f8 ff ff       	jmp    80104ed2 <alltraps>

8010569c <vector98>:
.globl vector98
vector98:
  pushl $0
8010569c:	6a 00                	push   $0x0
  pushl $98
8010569e:	6a 62                	push   $0x62
  jmp alltraps
801056a0:	e9 2d f8 ff ff       	jmp    80104ed2 <alltraps>

801056a5 <vector99>:
.globl vector99
vector99:
  pushl $0
801056a5:	6a 00                	push   $0x0
  pushl $99
801056a7:	6a 63                	push   $0x63
  jmp alltraps
801056a9:	e9 24 f8 ff ff       	jmp    80104ed2 <alltraps>

801056ae <vector100>:
.globl vector100
vector100:
  pushl $0
801056ae:	6a 00                	push   $0x0
  pushl $100
801056b0:	6a 64                	push   $0x64
  jmp alltraps
801056b2:	e9 1b f8 ff ff       	jmp    80104ed2 <alltraps>

801056b7 <vector101>:
.globl vector101
vector101:
  pushl $0
801056b7:	6a 00                	push   $0x0
  pushl $101
801056b9:	6a 65                	push   $0x65
  jmp alltraps
801056bb:	e9 12 f8 ff ff       	jmp    80104ed2 <alltraps>

801056c0 <vector102>:
.globl vector102
vector102:
  pushl $0
801056c0:	6a 00                	push   $0x0
  pushl $102
801056c2:	6a 66                	push   $0x66
  jmp alltraps
801056c4:	e9 09 f8 ff ff       	jmp    80104ed2 <alltraps>

801056c9 <vector103>:
.globl vector103
vector103:
  pushl $0
801056c9:	6a 00                	push   $0x0
  pushl $103
801056cb:	6a 67                	push   $0x67
  jmp alltraps
801056cd:	e9 00 f8 ff ff       	jmp    80104ed2 <alltraps>

801056d2 <vector104>:
.globl vector104
vector104:
  pushl $0
801056d2:	6a 00                	push   $0x0
  pushl $104
801056d4:	6a 68                	push   $0x68
  jmp alltraps
801056d6:	e9 f7 f7 ff ff       	jmp    80104ed2 <alltraps>

801056db <vector105>:
.globl vector105
vector105:
  pushl $0
801056db:	6a 00                	push   $0x0
  pushl $105
801056dd:	6a 69                	push   $0x69
  jmp alltraps
801056df:	e9 ee f7 ff ff       	jmp    80104ed2 <alltraps>

801056e4 <vector106>:
.globl vector106
vector106:
  pushl $0
801056e4:	6a 00                	push   $0x0
  pushl $106
801056e6:	6a 6a                	push   $0x6a
  jmp alltraps
801056e8:	e9 e5 f7 ff ff       	jmp    80104ed2 <alltraps>

801056ed <vector107>:
.globl vector107
vector107:
  pushl $0
801056ed:	6a 00                	push   $0x0
  pushl $107
801056ef:	6a 6b                	push   $0x6b
  jmp alltraps
801056f1:	e9 dc f7 ff ff       	jmp    80104ed2 <alltraps>

801056f6 <vector108>:
.globl vector108
vector108:
  pushl $0
801056f6:	6a 00                	push   $0x0
  pushl $108
801056f8:	6a 6c                	push   $0x6c
  jmp alltraps
801056fa:	e9 d3 f7 ff ff       	jmp    80104ed2 <alltraps>

801056ff <vector109>:
.globl vector109
vector109:
  pushl $0
801056ff:	6a 00                	push   $0x0
  pushl $109
80105701:	6a 6d                	push   $0x6d
  jmp alltraps
80105703:	e9 ca f7 ff ff       	jmp    80104ed2 <alltraps>

80105708 <vector110>:
.globl vector110
vector110:
  pushl $0
80105708:	6a 00                	push   $0x0
  pushl $110
8010570a:	6a 6e                	push   $0x6e
  jmp alltraps
8010570c:	e9 c1 f7 ff ff       	jmp    80104ed2 <alltraps>

80105711 <vector111>:
.globl vector111
vector111:
  pushl $0
80105711:	6a 00                	push   $0x0
  pushl $111
80105713:	6a 6f                	push   $0x6f
  jmp alltraps
80105715:	e9 b8 f7 ff ff       	jmp    80104ed2 <alltraps>

8010571a <vector112>:
.globl vector112
vector112:
  pushl $0
8010571a:	6a 00                	push   $0x0
  pushl $112
8010571c:	6a 70                	push   $0x70
  jmp alltraps
8010571e:	e9 af f7 ff ff       	jmp    80104ed2 <alltraps>

80105723 <vector113>:
.globl vector113
vector113:
  pushl $0
80105723:	6a 00                	push   $0x0
  pushl $113
80105725:	6a 71                	push   $0x71
  jmp alltraps
80105727:	e9 a6 f7 ff ff       	jmp    80104ed2 <alltraps>

8010572c <vector114>:
.globl vector114
vector114:
  pushl $0
8010572c:	6a 00                	push   $0x0
  pushl $114
8010572e:	6a 72                	push   $0x72
  jmp alltraps
80105730:	e9 9d f7 ff ff       	jmp    80104ed2 <alltraps>

80105735 <vector115>:
.globl vector115
vector115:
  pushl $0
80105735:	6a 00                	push   $0x0
  pushl $115
80105737:	6a 73                	push   $0x73
  jmp alltraps
80105739:	e9 94 f7 ff ff       	jmp    80104ed2 <alltraps>

8010573e <vector116>:
.globl vector116
vector116:
  pushl $0
8010573e:	6a 00                	push   $0x0
  pushl $116
80105740:	6a 74                	push   $0x74
  jmp alltraps
80105742:	e9 8b f7 ff ff       	jmp    80104ed2 <alltraps>

80105747 <vector117>:
.globl vector117
vector117:
  pushl $0
80105747:	6a 00                	push   $0x0
  pushl $117
80105749:	6a 75                	push   $0x75
  jmp alltraps
8010574b:	e9 82 f7 ff ff       	jmp    80104ed2 <alltraps>

80105750 <vector118>:
.globl vector118
vector118:
  pushl $0
80105750:	6a 00                	push   $0x0
  pushl $118
80105752:	6a 76                	push   $0x76
  jmp alltraps
80105754:	e9 79 f7 ff ff       	jmp    80104ed2 <alltraps>

80105759 <vector119>:
.globl vector119
vector119:
  pushl $0
80105759:	6a 00                	push   $0x0
  pushl $119
8010575b:	6a 77                	push   $0x77
  jmp alltraps
8010575d:	e9 70 f7 ff ff       	jmp    80104ed2 <alltraps>

80105762 <vector120>:
.globl vector120
vector120:
  pushl $0
80105762:	6a 00                	push   $0x0
  pushl $120
80105764:	6a 78                	push   $0x78
  jmp alltraps
80105766:	e9 67 f7 ff ff       	jmp    80104ed2 <alltraps>

8010576b <vector121>:
.globl vector121
vector121:
  pushl $0
8010576b:	6a 00                	push   $0x0
  pushl $121
8010576d:	6a 79                	push   $0x79
  jmp alltraps
8010576f:	e9 5e f7 ff ff       	jmp    80104ed2 <alltraps>

80105774 <vector122>:
.globl vector122
vector122:
  pushl $0
80105774:	6a 00                	push   $0x0
  pushl $122
80105776:	6a 7a                	push   $0x7a
  jmp alltraps
80105778:	e9 55 f7 ff ff       	jmp    80104ed2 <alltraps>

8010577d <vector123>:
.globl vector123
vector123:
  pushl $0
8010577d:	6a 00                	push   $0x0
  pushl $123
8010577f:	6a 7b                	push   $0x7b
  jmp alltraps
80105781:	e9 4c f7 ff ff       	jmp    80104ed2 <alltraps>

80105786 <vector124>:
.globl vector124
vector124:
  pushl $0
80105786:	6a 00                	push   $0x0
  pushl $124
80105788:	6a 7c                	push   $0x7c
  jmp alltraps
8010578a:	e9 43 f7 ff ff       	jmp    80104ed2 <alltraps>

8010578f <vector125>:
.globl vector125
vector125:
  pushl $0
8010578f:	6a 00                	push   $0x0
  pushl $125
80105791:	6a 7d                	push   $0x7d
  jmp alltraps
80105793:	e9 3a f7 ff ff       	jmp    80104ed2 <alltraps>

80105798 <vector126>:
.globl vector126
vector126:
  pushl $0
80105798:	6a 00                	push   $0x0
  pushl $126
8010579a:	6a 7e                	push   $0x7e
  jmp alltraps
8010579c:	e9 31 f7 ff ff       	jmp    80104ed2 <alltraps>

801057a1 <vector127>:
.globl vector127
vector127:
  pushl $0
801057a1:	6a 00                	push   $0x0
  pushl $127
801057a3:	6a 7f                	push   $0x7f
  jmp alltraps
801057a5:	e9 28 f7 ff ff       	jmp    80104ed2 <alltraps>

801057aa <vector128>:
.globl vector128
vector128:
  pushl $0
801057aa:	6a 00                	push   $0x0
  pushl $128
801057ac:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801057b1:	e9 1c f7 ff ff       	jmp    80104ed2 <alltraps>

801057b6 <vector129>:
.globl vector129
vector129:
  pushl $0
801057b6:	6a 00                	push   $0x0
  pushl $129
801057b8:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801057bd:	e9 10 f7 ff ff       	jmp    80104ed2 <alltraps>

801057c2 <vector130>:
.globl vector130
vector130:
  pushl $0
801057c2:	6a 00                	push   $0x0
  pushl $130
801057c4:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801057c9:	e9 04 f7 ff ff       	jmp    80104ed2 <alltraps>

801057ce <vector131>:
.globl vector131
vector131:
  pushl $0
801057ce:	6a 00                	push   $0x0
  pushl $131
801057d0:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801057d5:	e9 f8 f6 ff ff       	jmp    80104ed2 <alltraps>

801057da <vector132>:
.globl vector132
vector132:
  pushl $0
801057da:	6a 00                	push   $0x0
  pushl $132
801057dc:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801057e1:	e9 ec f6 ff ff       	jmp    80104ed2 <alltraps>

801057e6 <vector133>:
.globl vector133
vector133:
  pushl $0
801057e6:	6a 00                	push   $0x0
  pushl $133
801057e8:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801057ed:	e9 e0 f6 ff ff       	jmp    80104ed2 <alltraps>

801057f2 <vector134>:
.globl vector134
vector134:
  pushl $0
801057f2:	6a 00                	push   $0x0
  pushl $134
801057f4:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801057f9:	e9 d4 f6 ff ff       	jmp    80104ed2 <alltraps>

801057fe <vector135>:
.globl vector135
vector135:
  pushl $0
801057fe:	6a 00                	push   $0x0
  pushl $135
80105800:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80105805:	e9 c8 f6 ff ff       	jmp    80104ed2 <alltraps>

8010580a <vector136>:
.globl vector136
vector136:
  pushl $0
8010580a:	6a 00                	push   $0x0
  pushl $136
8010580c:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105811:	e9 bc f6 ff ff       	jmp    80104ed2 <alltraps>

80105816 <vector137>:
.globl vector137
vector137:
  pushl $0
80105816:	6a 00                	push   $0x0
  pushl $137
80105818:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010581d:	e9 b0 f6 ff ff       	jmp    80104ed2 <alltraps>

80105822 <vector138>:
.globl vector138
vector138:
  pushl $0
80105822:	6a 00                	push   $0x0
  pushl $138
80105824:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105829:	e9 a4 f6 ff ff       	jmp    80104ed2 <alltraps>

8010582e <vector139>:
.globl vector139
vector139:
  pushl $0
8010582e:	6a 00                	push   $0x0
  pushl $139
80105830:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80105835:	e9 98 f6 ff ff       	jmp    80104ed2 <alltraps>

8010583a <vector140>:
.globl vector140
vector140:
  pushl $0
8010583a:	6a 00                	push   $0x0
  pushl $140
8010583c:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105841:	e9 8c f6 ff ff       	jmp    80104ed2 <alltraps>

80105846 <vector141>:
.globl vector141
vector141:
  pushl $0
80105846:	6a 00                	push   $0x0
  pushl $141
80105848:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010584d:	e9 80 f6 ff ff       	jmp    80104ed2 <alltraps>

80105852 <vector142>:
.globl vector142
vector142:
  pushl $0
80105852:	6a 00                	push   $0x0
  pushl $142
80105854:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105859:	e9 74 f6 ff ff       	jmp    80104ed2 <alltraps>

8010585e <vector143>:
.globl vector143
vector143:
  pushl $0
8010585e:	6a 00                	push   $0x0
  pushl $143
80105860:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80105865:	e9 68 f6 ff ff       	jmp    80104ed2 <alltraps>

8010586a <vector144>:
.globl vector144
vector144:
  pushl $0
8010586a:	6a 00                	push   $0x0
  pushl $144
8010586c:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105871:	e9 5c f6 ff ff       	jmp    80104ed2 <alltraps>

80105876 <vector145>:
.globl vector145
vector145:
  pushl $0
80105876:	6a 00                	push   $0x0
  pushl $145
80105878:	68 91 00 00 00       	push   $0x91
  jmp alltraps
8010587d:	e9 50 f6 ff ff       	jmp    80104ed2 <alltraps>

80105882 <vector146>:
.globl vector146
vector146:
  pushl $0
80105882:	6a 00                	push   $0x0
  pushl $146
80105884:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105889:	e9 44 f6 ff ff       	jmp    80104ed2 <alltraps>

8010588e <vector147>:
.globl vector147
vector147:
  pushl $0
8010588e:	6a 00                	push   $0x0
  pushl $147
80105890:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80105895:	e9 38 f6 ff ff       	jmp    80104ed2 <alltraps>

8010589a <vector148>:
.globl vector148
vector148:
  pushl $0
8010589a:	6a 00                	push   $0x0
  pushl $148
8010589c:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801058a1:	e9 2c f6 ff ff       	jmp    80104ed2 <alltraps>

801058a6 <vector149>:
.globl vector149
vector149:
  pushl $0
801058a6:	6a 00                	push   $0x0
  pushl $149
801058a8:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801058ad:	e9 20 f6 ff ff       	jmp    80104ed2 <alltraps>

801058b2 <vector150>:
.globl vector150
vector150:
  pushl $0
801058b2:	6a 00                	push   $0x0
  pushl $150
801058b4:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801058b9:	e9 14 f6 ff ff       	jmp    80104ed2 <alltraps>

801058be <vector151>:
.globl vector151
vector151:
  pushl $0
801058be:	6a 00                	push   $0x0
  pushl $151
801058c0:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801058c5:	e9 08 f6 ff ff       	jmp    80104ed2 <alltraps>

801058ca <vector152>:
.globl vector152
vector152:
  pushl $0
801058ca:	6a 00                	push   $0x0
  pushl $152
801058cc:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801058d1:	e9 fc f5 ff ff       	jmp    80104ed2 <alltraps>

801058d6 <vector153>:
.globl vector153
vector153:
  pushl $0
801058d6:	6a 00                	push   $0x0
  pushl $153
801058d8:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801058dd:	e9 f0 f5 ff ff       	jmp    80104ed2 <alltraps>

801058e2 <vector154>:
.globl vector154
vector154:
  pushl $0
801058e2:	6a 00                	push   $0x0
  pushl $154
801058e4:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801058e9:	e9 e4 f5 ff ff       	jmp    80104ed2 <alltraps>

801058ee <vector155>:
.globl vector155
vector155:
  pushl $0
801058ee:	6a 00                	push   $0x0
  pushl $155
801058f0:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801058f5:	e9 d8 f5 ff ff       	jmp    80104ed2 <alltraps>

801058fa <vector156>:
.globl vector156
vector156:
  pushl $0
801058fa:	6a 00                	push   $0x0
  pushl $156
801058fc:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
80105901:	e9 cc f5 ff ff       	jmp    80104ed2 <alltraps>

80105906 <vector157>:
.globl vector157
vector157:
  pushl $0
80105906:	6a 00                	push   $0x0
  pushl $157
80105908:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010590d:	e9 c0 f5 ff ff       	jmp    80104ed2 <alltraps>

80105912 <vector158>:
.globl vector158
vector158:
  pushl $0
80105912:	6a 00                	push   $0x0
  pushl $158
80105914:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105919:	e9 b4 f5 ff ff       	jmp    80104ed2 <alltraps>

8010591e <vector159>:
.globl vector159
vector159:
  pushl $0
8010591e:	6a 00                	push   $0x0
  pushl $159
80105920:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80105925:	e9 a8 f5 ff ff       	jmp    80104ed2 <alltraps>

8010592a <vector160>:
.globl vector160
vector160:
  pushl $0
8010592a:	6a 00                	push   $0x0
  pushl $160
8010592c:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105931:	e9 9c f5 ff ff       	jmp    80104ed2 <alltraps>

80105936 <vector161>:
.globl vector161
vector161:
  pushl $0
80105936:	6a 00                	push   $0x0
  pushl $161
80105938:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010593d:	e9 90 f5 ff ff       	jmp    80104ed2 <alltraps>

80105942 <vector162>:
.globl vector162
vector162:
  pushl $0
80105942:	6a 00                	push   $0x0
  pushl $162
80105944:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105949:	e9 84 f5 ff ff       	jmp    80104ed2 <alltraps>

8010594e <vector163>:
.globl vector163
vector163:
  pushl $0
8010594e:	6a 00                	push   $0x0
  pushl $163
80105950:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80105955:	e9 78 f5 ff ff       	jmp    80104ed2 <alltraps>

8010595a <vector164>:
.globl vector164
vector164:
  pushl $0
8010595a:	6a 00                	push   $0x0
  pushl $164
8010595c:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105961:	e9 6c f5 ff ff       	jmp    80104ed2 <alltraps>

80105966 <vector165>:
.globl vector165
vector165:
  pushl $0
80105966:	6a 00                	push   $0x0
  pushl $165
80105968:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010596d:	e9 60 f5 ff ff       	jmp    80104ed2 <alltraps>

80105972 <vector166>:
.globl vector166
vector166:
  pushl $0
80105972:	6a 00                	push   $0x0
  pushl $166
80105974:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105979:	e9 54 f5 ff ff       	jmp    80104ed2 <alltraps>

8010597e <vector167>:
.globl vector167
vector167:
  pushl $0
8010597e:	6a 00                	push   $0x0
  pushl $167
80105980:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80105985:	e9 48 f5 ff ff       	jmp    80104ed2 <alltraps>

8010598a <vector168>:
.globl vector168
vector168:
  pushl $0
8010598a:	6a 00                	push   $0x0
  pushl $168
8010598c:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105991:	e9 3c f5 ff ff       	jmp    80104ed2 <alltraps>

80105996 <vector169>:
.globl vector169
vector169:
  pushl $0
80105996:	6a 00                	push   $0x0
  pushl $169
80105998:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010599d:	e9 30 f5 ff ff       	jmp    80104ed2 <alltraps>

801059a2 <vector170>:
.globl vector170
vector170:
  pushl $0
801059a2:	6a 00                	push   $0x0
  pushl $170
801059a4:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801059a9:	e9 24 f5 ff ff       	jmp    80104ed2 <alltraps>

801059ae <vector171>:
.globl vector171
vector171:
  pushl $0
801059ae:	6a 00                	push   $0x0
  pushl $171
801059b0:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801059b5:	e9 18 f5 ff ff       	jmp    80104ed2 <alltraps>

801059ba <vector172>:
.globl vector172
vector172:
  pushl $0
801059ba:	6a 00                	push   $0x0
  pushl $172
801059bc:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801059c1:	e9 0c f5 ff ff       	jmp    80104ed2 <alltraps>

801059c6 <vector173>:
.globl vector173
vector173:
  pushl $0
801059c6:	6a 00                	push   $0x0
  pushl $173
801059c8:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801059cd:	e9 00 f5 ff ff       	jmp    80104ed2 <alltraps>

801059d2 <vector174>:
.globl vector174
vector174:
  pushl $0
801059d2:	6a 00                	push   $0x0
  pushl $174
801059d4:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801059d9:	e9 f4 f4 ff ff       	jmp    80104ed2 <alltraps>

801059de <vector175>:
.globl vector175
vector175:
  pushl $0
801059de:	6a 00                	push   $0x0
  pushl $175
801059e0:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801059e5:	e9 e8 f4 ff ff       	jmp    80104ed2 <alltraps>

801059ea <vector176>:
.globl vector176
vector176:
  pushl $0
801059ea:	6a 00                	push   $0x0
  pushl $176
801059ec:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801059f1:	e9 dc f4 ff ff       	jmp    80104ed2 <alltraps>

801059f6 <vector177>:
.globl vector177
vector177:
  pushl $0
801059f6:	6a 00                	push   $0x0
  pushl $177
801059f8:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801059fd:	e9 d0 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a02 <vector178>:
.globl vector178
vector178:
  pushl $0
80105a02:	6a 00                	push   $0x0
  pushl $178
80105a04:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105a09:	e9 c4 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a0e <vector179>:
.globl vector179
vector179:
  pushl $0
80105a0e:	6a 00                	push   $0x0
  pushl $179
80105a10:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105a15:	e9 b8 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a1a <vector180>:
.globl vector180
vector180:
  pushl $0
80105a1a:	6a 00                	push   $0x0
  pushl $180
80105a1c:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105a21:	e9 ac f4 ff ff       	jmp    80104ed2 <alltraps>

80105a26 <vector181>:
.globl vector181
vector181:
  pushl $0
80105a26:	6a 00                	push   $0x0
  pushl $181
80105a28:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105a2d:	e9 a0 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a32 <vector182>:
.globl vector182
vector182:
  pushl $0
80105a32:	6a 00                	push   $0x0
  pushl $182
80105a34:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105a39:	e9 94 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a3e <vector183>:
.globl vector183
vector183:
  pushl $0
80105a3e:	6a 00                	push   $0x0
  pushl $183
80105a40:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105a45:	e9 88 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a4a <vector184>:
.globl vector184
vector184:
  pushl $0
80105a4a:	6a 00                	push   $0x0
  pushl $184
80105a4c:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105a51:	e9 7c f4 ff ff       	jmp    80104ed2 <alltraps>

80105a56 <vector185>:
.globl vector185
vector185:
  pushl $0
80105a56:	6a 00                	push   $0x0
  pushl $185
80105a58:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105a5d:	e9 70 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a62 <vector186>:
.globl vector186
vector186:
  pushl $0
80105a62:	6a 00                	push   $0x0
  pushl $186
80105a64:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105a69:	e9 64 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a6e <vector187>:
.globl vector187
vector187:
  pushl $0
80105a6e:	6a 00                	push   $0x0
  pushl $187
80105a70:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105a75:	e9 58 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a7a <vector188>:
.globl vector188
vector188:
  pushl $0
80105a7a:	6a 00                	push   $0x0
  pushl $188
80105a7c:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105a81:	e9 4c f4 ff ff       	jmp    80104ed2 <alltraps>

80105a86 <vector189>:
.globl vector189
vector189:
  pushl $0
80105a86:	6a 00                	push   $0x0
  pushl $189
80105a88:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105a8d:	e9 40 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a92 <vector190>:
.globl vector190
vector190:
  pushl $0
80105a92:	6a 00                	push   $0x0
  pushl $190
80105a94:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a99:	e9 34 f4 ff ff       	jmp    80104ed2 <alltraps>

80105a9e <vector191>:
.globl vector191
vector191:
  pushl $0
80105a9e:	6a 00                	push   $0x0
  pushl $191
80105aa0:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105aa5:	e9 28 f4 ff ff       	jmp    80104ed2 <alltraps>

80105aaa <vector192>:
.globl vector192
vector192:
  pushl $0
80105aaa:	6a 00                	push   $0x0
  pushl $192
80105aac:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105ab1:	e9 1c f4 ff ff       	jmp    80104ed2 <alltraps>

80105ab6 <vector193>:
.globl vector193
vector193:
  pushl $0
80105ab6:	6a 00                	push   $0x0
  pushl $193
80105ab8:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105abd:	e9 10 f4 ff ff       	jmp    80104ed2 <alltraps>

80105ac2 <vector194>:
.globl vector194
vector194:
  pushl $0
80105ac2:	6a 00                	push   $0x0
  pushl $194
80105ac4:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ac9:	e9 04 f4 ff ff       	jmp    80104ed2 <alltraps>

80105ace <vector195>:
.globl vector195
vector195:
  pushl $0
80105ace:	6a 00                	push   $0x0
  pushl $195
80105ad0:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105ad5:	e9 f8 f3 ff ff       	jmp    80104ed2 <alltraps>

80105ada <vector196>:
.globl vector196
vector196:
  pushl $0
80105ada:	6a 00                	push   $0x0
  pushl $196
80105adc:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ae1:	e9 ec f3 ff ff       	jmp    80104ed2 <alltraps>

80105ae6 <vector197>:
.globl vector197
vector197:
  pushl $0
80105ae6:	6a 00                	push   $0x0
  pushl $197
80105ae8:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105aed:	e9 e0 f3 ff ff       	jmp    80104ed2 <alltraps>

80105af2 <vector198>:
.globl vector198
vector198:
  pushl $0
80105af2:	6a 00                	push   $0x0
  pushl $198
80105af4:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105af9:	e9 d4 f3 ff ff       	jmp    80104ed2 <alltraps>

80105afe <vector199>:
.globl vector199
vector199:
  pushl $0
80105afe:	6a 00                	push   $0x0
  pushl $199
80105b00:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105b05:	e9 c8 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b0a <vector200>:
.globl vector200
vector200:
  pushl $0
80105b0a:	6a 00                	push   $0x0
  pushl $200
80105b0c:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105b11:	e9 bc f3 ff ff       	jmp    80104ed2 <alltraps>

80105b16 <vector201>:
.globl vector201
vector201:
  pushl $0
80105b16:	6a 00                	push   $0x0
  pushl $201
80105b18:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105b1d:	e9 b0 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b22 <vector202>:
.globl vector202
vector202:
  pushl $0
80105b22:	6a 00                	push   $0x0
  pushl $202
80105b24:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105b29:	e9 a4 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b2e <vector203>:
.globl vector203
vector203:
  pushl $0
80105b2e:	6a 00                	push   $0x0
  pushl $203
80105b30:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105b35:	e9 98 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b3a <vector204>:
.globl vector204
vector204:
  pushl $0
80105b3a:	6a 00                	push   $0x0
  pushl $204
80105b3c:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105b41:	e9 8c f3 ff ff       	jmp    80104ed2 <alltraps>

80105b46 <vector205>:
.globl vector205
vector205:
  pushl $0
80105b46:	6a 00                	push   $0x0
  pushl $205
80105b48:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105b4d:	e9 80 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b52 <vector206>:
.globl vector206
vector206:
  pushl $0
80105b52:	6a 00                	push   $0x0
  pushl $206
80105b54:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105b59:	e9 74 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b5e <vector207>:
.globl vector207
vector207:
  pushl $0
80105b5e:	6a 00                	push   $0x0
  pushl $207
80105b60:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105b65:	e9 68 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b6a <vector208>:
.globl vector208
vector208:
  pushl $0
80105b6a:	6a 00                	push   $0x0
  pushl $208
80105b6c:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105b71:	e9 5c f3 ff ff       	jmp    80104ed2 <alltraps>

80105b76 <vector209>:
.globl vector209
vector209:
  pushl $0
80105b76:	6a 00                	push   $0x0
  pushl $209
80105b78:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b7d:	e9 50 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b82 <vector210>:
.globl vector210
vector210:
  pushl $0
80105b82:	6a 00                	push   $0x0
  pushl $210
80105b84:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105b89:	e9 44 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b8e <vector211>:
.globl vector211
vector211:
  pushl $0
80105b8e:	6a 00                	push   $0x0
  pushl $211
80105b90:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b95:	e9 38 f3 ff ff       	jmp    80104ed2 <alltraps>

80105b9a <vector212>:
.globl vector212
vector212:
  pushl $0
80105b9a:	6a 00                	push   $0x0
  pushl $212
80105b9c:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105ba1:	e9 2c f3 ff ff       	jmp    80104ed2 <alltraps>

80105ba6 <vector213>:
.globl vector213
vector213:
  pushl $0
80105ba6:	6a 00                	push   $0x0
  pushl $213
80105ba8:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105bad:	e9 20 f3 ff ff       	jmp    80104ed2 <alltraps>

80105bb2 <vector214>:
.globl vector214
vector214:
  pushl $0
80105bb2:	6a 00                	push   $0x0
  pushl $214
80105bb4:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105bb9:	e9 14 f3 ff ff       	jmp    80104ed2 <alltraps>

80105bbe <vector215>:
.globl vector215
vector215:
  pushl $0
80105bbe:	6a 00                	push   $0x0
  pushl $215
80105bc0:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105bc5:	e9 08 f3 ff ff       	jmp    80104ed2 <alltraps>

80105bca <vector216>:
.globl vector216
vector216:
  pushl $0
80105bca:	6a 00                	push   $0x0
  pushl $216
80105bcc:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105bd1:	e9 fc f2 ff ff       	jmp    80104ed2 <alltraps>

80105bd6 <vector217>:
.globl vector217
vector217:
  pushl $0
80105bd6:	6a 00                	push   $0x0
  pushl $217
80105bd8:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105bdd:	e9 f0 f2 ff ff       	jmp    80104ed2 <alltraps>

80105be2 <vector218>:
.globl vector218
vector218:
  pushl $0
80105be2:	6a 00                	push   $0x0
  pushl $218
80105be4:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105be9:	e9 e4 f2 ff ff       	jmp    80104ed2 <alltraps>

80105bee <vector219>:
.globl vector219
vector219:
  pushl $0
80105bee:	6a 00                	push   $0x0
  pushl $219
80105bf0:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105bf5:	e9 d8 f2 ff ff       	jmp    80104ed2 <alltraps>

80105bfa <vector220>:
.globl vector220
vector220:
  pushl $0
80105bfa:	6a 00                	push   $0x0
  pushl $220
80105bfc:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105c01:	e9 cc f2 ff ff       	jmp    80104ed2 <alltraps>

80105c06 <vector221>:
.globl vector221
vector221:
  pushl $0
80105c06:	6a 00                	push   $0x0
  pushl $221
80105c08:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105c0d:	e9 c0 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c12 <vector222>:
.globl vector222
vector222:
  pushl $0
80105c12:	6a 00                	push   $0x0
  pushl $222
80105c14:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105c19:	e9 b4 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c1e <vector223>:
.globl vector223
vector223:
  pushl $0
80105c1e:	6a 00                	push   $0x0
  pushl $223
80105c20:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105c25:	e9 a8 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c2a <vector224>:
.globl vector224
vector224:
  pushl $0
80105c2a:	6a 00                	push   $0x0
  pushl $224
80105c2c:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105c31:	e9 9c f2 ff ff       	jmp    80104ed2 <alltraps>

80105c36 <vector225>:
.globl vector225
vector225:
  pushl $0
80105c36:	6a 00                	push   $0x0
  pushl $225
80105c38:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105c3d:	e9 90 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c42 <vector226>:
.globl vector226
vector226:
  pushl $0
80105c42:	6a 00                	push   $0x0
  pushl $226
80105c44:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105c49:	e9 84 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c4e <vector227>:
.globl vector227
vector227:
  pushl $0
80105c4e:	6a 00                	push   $0x0
  pushl $227
80105c50:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105c55:	e9 78 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c5a <vector228>:
.globl vector228
vector228:
  pushl $0
80105c5a:	6a 00                	push   $0x0
  pushl $228
80105c5c:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105c61:	e9 6c f2 ff ff       	jmp    80104ed2 <alltraps>

80105c66 <vector229>:
.globl vector229
vector229:
  pushl $0
80105c66:	6a 00                	push   $0x0
  pushl $229
80105c68:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105c6d:	e9 60 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c72 <vector230>:
.globl vector230
vector230:
  pushl $0
80105c72:	6a 00                	push   $0x0
  pushl $230
80105c74:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105c79:	e9 54 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c7e <vector231>:
.globl vector231
vector231:
  pushl $0
80105c7e:	6a 00                	push   $0x0
  pushl $231
80105c80:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105c85:	e9 48 f2 ff ff       	jmp    80104ed2 <alltraps>

80105c8a <vector232>:
.globl vector232
vector232:
  pushl $0
80105c8a:	6a 00                	push   $0x0
  pushl $232
80105c8c:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c91:	e9 3c f2 ff ff       	jmp    80104ed2 <alltraps>

80105c96 <vector233>:
.globl vector233
vector233:
  pushl $0
80105c96:	6a 00                	push   $0x0
  pushl $233
80105c98:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c9d:	e9 30 f2 ff ff       	jmp    80104ed2 <alltraps>

80105ca2 <vector234>:
.globl vector234
vector234:
  pushl $0
80105ca2:	6a 00                	push   $0x0
  pushl $234
80105ca4:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105ca9:	e9 24 f2 ff ff       	jmp    80104ed2 <alltraps>

80105cae <vector235>:
.globl vector235
vector235:
  pushl $0
80105cae:	6a 00                	push   $0x0
  pushl $235
80105cb0:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105cb5:	e9 18 f2 ff ff       	jmp    80104ed2 <alltraps>

80105cba <vector236>:
.globl vector236
vector236:
  pushl $0
80105cba:	6a 00                	push   $0x0
  pushl $236
80105cbc:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105cc1:	e9 0c f2 ff ff       	jmp    80104ed2 <alltraps>

80105cc6 <vector237>:
.globl vector237
vector237:
  pushl $0
80105cc6:	6a 00                	push   $0x0
  pushl $237
80105cc8:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105ccd:	e9 00 f2 ff ff       	jmp    80104ed2 <alltraps>

80105cd2 <vector238>:
.globl vector238
vector238:
  pushl $0
80105cd2:	6a 00                	push   $0x0
  pushl $238
80105cd4:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105cd9:	e9 f4 f1 ff ff       	jmp    80104ed2 <alltraps>

80105cde <vector239>:
.globl vector239
vector239:
  pushl $0
80105cde:	6a 00                	push   $0x0
  pushl $239
80105ce0:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105ce5:	e9 e8 f1 ff ff       	jmp    80104ed2 <alltraps>

80105cea <vector240>:
.globl vector240
vector240:
  pushl $0
80105cea:	6a 00                	push   $0x0
  pushl $240
80105cec:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105cf1:	e9 dc f1 ff ff       	jmp    80104ed2 <alltraps>

80105cf6 <vector241>:
.globl vector241
vector241:
  pushl $0
80105cf6:	6a 00                	push   $0x0
  pushl $241
80105cf8:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105cfd:	e9 d0 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d02 <vector242>:
.globl vector242
vector242:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $242
80105d04:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105d09:	e9 c4 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d0e <vector243>:
.globl vector243
vector243:
  pushl $0
80105d0e:	6a 00                	push   $0x0
  pushl $243
80105d10:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105d15:	e9 b8 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d1a <vector244>:
.globl vector244
vector244:
  pushl $0
80105d1a:	6a 00                	push   $0x0
  pushl $244
80105d1c:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105d21:	e9 ac f1 ff ff       	jmp    80104ed2 <alltraps>

80105d26 <vector245>:
.globl vector245
vector245:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $245
80105d28:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105d2d:	e9 a0 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d32 <vector246>:
.globl vector246
vector246:
  pushl $0
80105d32:	6a 00                	push   $0x0
  pushl $246
80105d34:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105d39:	e9 94 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d3e <vector247>:
.globl vector247
vector247:
  pushl $0
80105d3e:	6a 00                	push   $0x0
  pushl $247
80105d40:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105d45:	e9 88 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d4a <vector248>:
.globl vector248
vector248:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $248
80105d4c:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105d51:	e9 7c f1 ff ff       	jmp    80104ed2 <alltraps>

80105d56 <vector249>:
.globl vector249
vector249:
  pushl $0
80105d56:	6a 00                	push   $0x0
  pushl $249
80105d58:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105d5d:	e9 70 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d62 <vector250>:
.globl vector250
vector250:
  pushl $0
80105d62:	6a 00                	push   $0x0
  pushl $250
80105d64:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105d69:	e9 64 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d6e <vector251>:
.globl vector251
vector251:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $251
80105d70:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105d75:	e9 58 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d7a <vector252>:
.globl vector252
vector252:
  pushl $0
80105d7a:	6a 00                	push   $0x0
  pushl $252
80105d7c:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105d81:	e9 4c f1 ff ff       	jmp    80104ed2 <alltraps>

80105d86 <vector253>:
.globl vector253
vector253:
  pushl $0
80105d86:	6a 00                	push   $0x0
  pushl $253
80105d88:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105d8d:	e9 40 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d92 <vector254>:
.globl vector254
vector254:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $254
80105d94:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d99:	e9 34 f1 ff ff       	jmp    80104ed2 <alltraps>

80105d9e <vector255>:
.globl vector255
vector255:
  pushl $0
80105d9e:	6a 00                	push   $0x0
  pushl $255
80105da0:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105da5:	e9 28 f1 ff ff       	jmp    80104ed2 <alltraps>

80105daa <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105daa:	55                   	push   %ebp
80105dab:	89 e5                	mov    %esp,%ebp
80105dad:	57                   	push   %edi
80105dae:	56                   	push   %esi
80105daf:	53                   	push   %ebx
80105db0:	83 ec 0c             	sub    $0xc,%esp
80105db3:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105db5:	c1 ea 16             	shr    $0x16,%edx
80105db8:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105dbb:	8b 37                	mov    (%edi),%esi
80105dbd:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105dc3:	74 20                	je     80105de5 <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105dc5:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105dcb:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105dd1:	c1 eb 0c             	shr    $0xc,%ebx
80105dd4:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105dda:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105ddd:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105de0:	5b                   	pop    %ebx
80105de1:	5e                   	pop    %esi
80105de2:	5f                   	pop    %edi
80105de3:	5d                   	pop    %ebp
80105de4:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105de5:	85 c9                	test   %ecx,%ecx
80105de7:	74 2b                	je     80105e14 <walkpgdir+0x6a>
80105de9:	e8 74 c2 ff ff       	call   80102062 <kalloc>
80105dee:	89 c6                	mov    %eax,%esi
80105df0:	85 c0                	test   %eax,%eax
80105df2:	74 20                	je     80105e14 <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105df4:	83 ec 04             	sub    $0x4,%esp
80105df7:	68 00 10 00 00       	push   $0x1000
80105dfc:	6a 00                	push   $0x0
80105dfe:	50                   	push   %eax
80105dff:	e8 94 df ff ff       	call   80103d98 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105e04:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105e0a:	83 c8 07             	or     $0x7,%eax
80105e0d:	89 07                	mov    %eax,(%edi)
80105e0f:	83 c4 10             	add    $0x10,%esp
80105e12:	eb bd                	jmp    80105dd1 <walkpgdir+0x27>
      return 0;
80105e14:	b8 00 00 00 00       	mov    $0x0,%eax
80105e19:	eb c2                	jmp    80105ddd <walkpgdir+0x33>

80105e1b <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105e1b:	55                   	push   %ebp
80105e1c:	89 e5                	mov    %esp,%ebp
80105e1e:	57                   	push   %edi
80105e1f:	56                   	push   %esi
80105e20:	53                   	push   %ebx
80105e21:	83 ec 1c             	sub    $0x1c,%esp
80105e24:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e27:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105e2a:	89 d3                	mov    %edx,%ebx
80105e2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105e32:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80105e36:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80105e3b:	89 c7                	mov    %eax,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e3d:	b9 01 00 00 00       	mov    $0x1,%ecx
80105e42:	89 da                	mov    %ebx,%edx
80105e44:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e47:	e8 5e ff ff ff       	call   80105daa <walkpgdir>
80105e4c:	85 c0                	test   %eax,%eax
80105e4e:	74 2e                	je     80105e7e <mappages+0x63>
      return -1;
    if(*pte & PTE_P)
80105e50:	f6 00 01             	testb  $0x1,(%eax)
80105e53:	75 1c                	jne    80105e71 <mappages+0x56>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105e55:	89 f2                	mov    %esi,%edx
80105e57:	0b 55 0c             	or     0xc(%ebp),%edx
80105e5a:	83 ca 01             	or     $0x1,%edx
80105e5d:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105e5f:	39 fb                	cmp    %edi,%ebx
80105e61:	74 28                	je     80105e8b <mappages+0x70>
      break;
    a += PGSIZE;
80105e63:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105e69:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e6f:	eb cc                	jmp    80105e3d <mappages+0x22>
      panic("remap");
80105e71:	83 ec 0c             	sub    $0xc,%esp
80105e74:	68 18 71 10 80       	push   $0x80107118
80105e79:	e8 c6 a4 ff ff       	call   80100344 <panic>
      return -1;
80105e7e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105e83:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e86:	5b                   	pop    %ebx
80105e87:	5e                   	pop    %esi
80105e88:	5f                   	pop    %edi
80105e89:	5d                   	pop    %ebp
80105e8a:	c3                   	ret    
  return 0;
80105e8b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e90:	eb f1                	jmp    80105e83 <mappages+0x68>

80105e92 <seginit>:
{
80105e92:	55                   	push   %ebp
80105e93:	89 e5                	mov    %esp,%ebp
80105e95:	57                   	push   %edi
80105e96:	56                   	push   %esi
80105e97:	53                   	push   %ebx
80105e98:	83 ec 2c             	sub    $0x2c,%esp
  c = &cpus[cpuid()];
80105e9b:	e8 96 d2 ff ff       	call   80103136 <cpuid>
80105ea0:	89 c3                	mov    %eax,%ebx
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105ea2:	8d 14 80             	lea    (%eax,%eax,4),%edx
80105ea5:	8d 0c 12             	lea    (%edx,%edx,1),%ecx
80105ea8:	8d 04 01             	lea    (%ecx,%eax,1),%eax
80105eab:	c1 e0 04             	shl    $0x4,%eax
80105eae:	66 c7 80 18 18 11 80 	movw   $0xffff,-0x7feee7e8(%eax)
80105eb5:	ff ff 
80105eb7:	66 c7 80 1a 18 11 80 	movw   $0x0,-0x7feee7e6(%eax)
80105ebe:	00 00 
80105ec0:	c6 80 1c 18 11 80 00 	movb   $0x0,-0x7feee7e4(%eax)
80105ec7:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
80105eca:	01 d9                	add    %ebx,%ecx
80105ecc:	c1 e1 04             	shl    $0x4,%ecx
80105ecf:	0f b6 b1 1d 18 11 80 	movzbl -0x7feee7e3(%ecx),%esi
80105ed6:	83 e6 f0             	and    $0xfffffff0,%esi
80105ed9:	89 f7                	mov    %esi,%edi
80105edb:	83 cf 0a             	or     $0xa,%edi
80105ede:	89 fa                	mov    %edi,%edx
80105ee0:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105ee6:	83 ce 1a             	or     $0x1a,%esi
80105ee9:	89 f2                	mov    %esi,%edx
80105eeb:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105ef1:	83 e6 9f             	and    $0xffffff9f,%esi
80105ef4:	89 f2                	mov    %esi,%edx
80105ef6:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105efc:	83 ce 80             	or     $0xffffff80,%esi
80105eff:	89 f2                	mov    %esi,%edx
80105f01:	88 91 1d 18 11 80    	mov    %dl,-0x7feee7e3(%ecx)
80105f07:	0f b6 b1 1e 18 11 80 	movzbl -0x7feee7e2(%ecx),%esi
80105f0e:	83 ce 0f             	or     $0xf,%esi
80105f11:	89 f2                	mov    %esi,%edx
80105f13:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105f19:	89 f7                	mov    %esi,%edi
80105f1b:	83 e7 ef             	and    $0xffffffef,%edi
80105f1e:	89 fa                	mov    %edi,%edx
80105f20:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105f26:	83 e6 cf             	and    $0xffffffcf,%esi
80105f29:	89 f2                	mov    %esi,%edx
80105f2b:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105f31:	89 f7                	mov    %esi,%edi
80105f33:	83 cf 40             	or     $0x40,%edi
80105f36:	89 fa                	mov    %edi,%edx
80105f38:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105f3e:	83 ce c0             	or     $0xffffffc0,%esi
80105f41:	89 f2                	mov    %esi,%edx
80105f43:	88 91 1e 18 11 80    	mov    %dl,-0x7feee7e2(%ecx)
80105f49:	c6 80 1f 18 11 80 00 	movb   $0x0,-0x7feee7e1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105f50:	66 c7 80 20 18 11 80 	movw   $0xffff,-0x7feee7e0(%eax)
80105f57:	ff ff 
80105f59:	66 c7 80 22 18 11 80 	movw   $0x0,-0x7feee7de(%eax)
80105f60:	00 00 
80105f62:	c6 80 24 18 11 80 00 	movb   $0x0,-0x7feee7dc(%eax)
80105f69:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80105f6c:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80105f6f:	c1 e1 04             	shl    $0x4,%ecx
80105f72:	0f b6 b1 25 18 11 80 	movzbl -0x7feee7db(%ecx),%esi
80105f79:	83 e6 f0             	and    $0xfffffff0,%esi
80105f7c:	89 f7                	mov    %esi,%edi
80105f7e:	83 cf 02             	or     $0x2,%edi
80105f81:	89 fa                	mov    %edi,%edx
80105f83:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f89:	83 ce 12             	or     $0x12,%esi
80105f8c:	89 f2                	mov    %esi,%edx
80105f8e:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f94:	83 e6 9f             	and    $0xffffff9f,%esi
80105f97:	89 f2                	mov    %esi,%edx
80105f99:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105f9f:	83 ce 80             	or     $0xffffff80,%esi
80105fa2:	89 f2                	mov    %esi,%edx
80105fa4:	88 91 25 18 11 80    	mov    %dl,-0x7feee7db(%ecx)
80105faa:	0f b6 b1 26 18 11 80 	movzbl -0x7feee7da(%ecx),%esi
80105fb1:	83 ce 0f             	or     $0xf,%esi
80105fb4:	89 f2                	mov    %esi,%edx
80105fb6:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105fbc:	89 f7                	mov    %esi,%edi
80105fbe:	83 e7 ef             	and    $0xffffffef,%edi
80105fc1:	89 fa                	mov    %edi,%edx
80105fc3:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105fc9:	83 e6 cf             	and    $0xffffffcf,%esi
80105fcc:	89 f2                	mov    %esi,%edx
80105fce:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105fd4:	89 f7                	mov    %esi,%edi
80105fd6:	83 cf 40             	or     $0x40,%edi
80105fd9:	89 fa                	mov    %edi,%edx
80105fdb:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105fe1:	83 ce c0             	or     $0xffffffc0,%esi
80105fe4:	89 f2                	mov    %esi,%edx
80105fe6:	88 91 26 18 11 80    	mov    %dl,-0x7feee7da(%ecx)
80105fec:	c6 80 27 18 11 80 00 	movb   $0x0,-0x7feee7d9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105ff3:	66 c7 80 28 18 11 80 	movw   $0xffff,-0x7feee7d8(%eax)
80105ffa:	ff ff 
80105ffc:	66 c7 80 2a 18 11 80 	movw   $0x0,-0x7feee7d6(%eax)
80106003:	00 00 
80106005:	c6 80 2c 18 11 80 00 	movb   $0x0,-0x7feee7d4(%eax)
8010600c:	8b 55 d4             	mov    -0x2c(%ebp),%edx
8010600f:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
80106012:	c1 e1 04             	shl    $0x4,%ecx
80106015:	0f b6 b1 2d 18 11 80 	movzbl -0x7feee7d3(%ecx),%esi
8010601c:	83 e6 f0             	and    $0xfffffff0,%esi
8010601f:	89 f7                	mov    %esi,%edi
80106021:	83 cf 0a             	or     $0xa,%edi
80106024:	89 fa                	mov    %edi,%edx
80106026:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
8010602c:	89 f7                	mov    %esi,%edi
8010602e:	83 cf 1a             	or     $0x1a,%edi
80106031:	89 fa                	mov    %edi,%edx
80106033:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80106039:	83 ce 7a             	or     $0x7a,%esi
8010603c:	89 f2                	mov    %esi,%edx
8010603e:	88 91 2d 18 11 80    	mov    %dl,-0x7feee7d3(%ecx)
80106044:	c6 81 2d 18 11 80 fa 	movb   $0xfa,-0x7feee7d3(%ecx)
8010604b:	0f b6 b1 2e 18 11 80 	movzbl -0x7feee7d2(%ecx),%esi
80106052:	83 ce 0f             	or     $0xf,%esi
80106055:	89 f2                	mov    %esi,%edx
80106057:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010605d:	89 f7                	mov    %esi,%edi
8010605f:	83 e7 ef             	and    $0xffffffef,%edi
80106062:	89 fa                	mov    %edi,%edx
80106064:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010606a:	83 e6 cf             	and    $0xffffffcf,%esi
8010606d:	89 f2                	mov    %esi,%edx
8010606f:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106075:	89 f7                	mov    %esi,%edi
80106077:	83 cf 40             	or     $0x40,%edi
8010607a:	89 fa                	mov    %edi,%edx
8010607c:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
80106082:	83 ce c0             	or     $0xffffffc0,%esi
80106085:	89 f2                	mov    %esi,%edx
80106087:	88 91 2e 18 11 80    	mov    %dl,-0x7feee7d2(%ecx)
8010608d:	c6 80 2f 18 11 80 00 	movb   $0x0,-0x7feee7d1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106094:	66 c7 80 30 18 11 80 	movw   $0xffff,-0x7feee7d0(%eax)
8010609b:	ff ff 
8010609d:	66 c7 80 32 18 11 80 	movw   $0x0,-0x7feee7ce(%eax)
801060a4:	00 00 
801060a6:	c6 80 34 18 11 80 00 	movb   $0x0,-0x7feee7cc(%eax)
801060ad:	8b 55 d4             	mov    -0x2c(%ebp),%edx
801060b0:	8d 0c 1a             	lea    (%edx,%ebx,1),%ecx
801060b3:	c1 e1 04             	shl    $0x4,%ecx
801060b6:	0f b6 b1 35 18 11 80 	movzbl -0x7feee7cb(%ecx),%esi
801060bd:	83 e6 f0             	and    $0xfffffff0,%esi
801060c0:	89 f7                	mov    %esi,%edi
801060c2:	83 cf 02             	or     $0x2,%edi
801060c5:	89 fa                	mov    %edi,%edx
801060c7:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
801060cd:	89 f7                	mov    %esi,%edi
801060cf:	83 cf 12             	or     $0x12,%edi
801060d2:	89 fa                	mov    %edi,%edx
801060d4:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
801060da:	83 ce 72             	or     $0x72,%esi
801060dd:	89 f2                	mov    %esi,%edx
801060df:	88 91 35 18 11 80    	mov    %dl,-0x7feee7cb(%ecx)
801060e5:	c6 81 35 18 11 80 f2 	movb   $0xf2,-0x7feee7cb(%ecx)
801060ec:	0f b6 b1 36 18 11 80 	movzbl -0x7feee7ca(%ecx),%esi
801060f3:	83 ce 0f             	or     $0xf,%esi
801060f6:	89 f2                	mov    %esi,%edx
801060f8:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
801060fe:	89 f7                	mov    %esi,%edi
80106100:	83 e7 ef             	and    $0xffffffef,%edi
80106103:	89 fa                	mov    %edi,%edx
80106105:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010610b:	83 e6 cf             	and    $0xffffffcf,%esi
8010610e:	89 f2                	mov    %esi,%edx
80106110:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106116:	89 f7                	mov    %esi,%edi
80106118:	83 cf 40             	or     $0x40,%edi
8010611b:	89 fa                	mov    %edi,%edx
8010611d:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
80106123:	83 ce c0             	or     $0xffffffc0,%esi
80106126:	89 f2                	mov    %esi,%edx
80106128:	88 91 36 18 11 80    	mov    %dl,-0x7feee7ca(%ecx)
8010612e:	c6 80 37 18 11 80 00 	movb   $0x0,-0x7feee7c9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80106135:	8b 55 d4             	mov    -0x2c(%ebp),%edx
80106138:	01 da                	add    %ebx,%edx
8010613a:	c1 e2 04             	shl    $0x4,%edx
8010613d:	81 c2 10 18 11 80    	add    $0x80111810,%edx
  pd[0] = size-1;
80106143:	66 c7 45 e2 2f 00    	movw   $0x2f,-0x1e(%ebp)
  pd[1] = (uint)p;
80106149:	66 89 55 e4          	mov    %dx,-0x1c(%ebp)
  pd[2] = (uint)p >> 16;
8010614d:	c1 ea 10             	shr    $0x10,%edx
80106150:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106154:	8d 45 e2             	lea    -0x1e(%ebp),%eax
80106157:	0f 01 10             	lgdtl  (%eax)
}
8010615a:	83 c4 2c             	add    $0x2c,%esp
8010615d:	5b                   	pop    %ebx
8010615e:	5e                   	pop    %esi
8010615f:	5f                   	pop    %edi
80106160:	5d                   	pop    %ebp
80106161:	c3                   	ret    

80106162 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106162:	a1 c4 73 11 80       	mov    0x801173c4,%eax
80106167:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
8010616c:	0f 22 d8             	mov    %eax,%cr3
}
8010616f:	c3                   	ret    

80106170 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80106170:	55                   	push   %ebp
80106171:	89 e5                	mov    %esp,%ebp
80106173:	57                   	push   %edi
80106174:	56                   	push   %esi
80106175:	53                   	push   %ebx
80106176:	83 ec 1c             	sub    $0x1c,%esp
80106179:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
8010617c:	85 f6                	test   %esi,%esi
8010617e:	0f 84 21 01 00 00    	je     801062a5 <switchuvm+0x135>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106184:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106188:	0f 84 24 01 00 00    	je     801062b2 <switchuvm+0x142>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010618e:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106192:	0f 84 27 01 00 00    	je     801062bf <switchuvm+0x14f>
    panic("switchuvm: no pgdir");

  pushcli();
80106198:	e8 6c da ff ff       	call   80103c09 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010619d:	e8 30 cf ff ff       	call   801030d2 <mycpu>
801061a2:	89 c3                	mov    %eax,%ebx
801061a4:	e8 29 cf ff ff       	call   801030d2 <mycpu>
801061a9:	8d 78 08             	lea    0x8(%eax),%edi
801061ac:	e8 21 cf ff ff       	call   801030d2 <mycpu>
801061b1:	83 c0 08             	add    $0x8,%eax
801061b4:	c1 e8 10             	shr    $0x10,%eax
801061b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801061ba:	e8 13 cf ff ff       	call   801030d2 <mycpu>
801061bf:	83 c0 08             	add    $0x8,%eax
801061c2:	c1 e8 18             	shr    $0x18,%eax
801061c5:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
801061cc:	67 00 
801061ce:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
801061d5:	8a 4d e4             	mov    -0x1c(%ebp),%cl
801061d8:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
801061de:	8a 93 9d 00 00 00    	mov    0x9d(%ebx),%dl
801061e4:	83 e2 f0             	and    $0xfffffff0,%edx
801061e7:	88 d1                	mov    %dl,%cl
801061e9:	83 c9 09             	or     $0x9,%ecx
801061ec:	88 8b 9d 00 00 00    	mov    %cl,0x9d(%ebx)
801061f2:	83 ca 19             	or     $0x19,%edx
801061f5:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
801061fb:	83 e2 9f             	and    $0xffffff9f,%edx
801061fe:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106204:	83 ca 80             	or     $0xffffff80,%edx
80106207:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
8010620d:	8a 93 9e 00 00 00    	mov    0x9e(%ebx),%dl
80106213:	88 d1                	mov    %dl,%cl
80106215:	83 e1 f0             	and    $0xfffffff0,%ecx
80106218:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
8010621e:	88 d1                	mov    %dl,%cl
80106220:	83 e1 e0             	and    $0xffffffe0,%ecx
80106223:	88 8b 9e 00 00 00    	mov    %cl,0x9e(%ebx)
80106229:	83 e2 c0             	and    $0xffffffc0,%edx
8010622c:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106232:	83 ca 40             	or     $0x40,%edx
80106235:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
8010623b:	83 e2 7f             	and    $0x7f,%edx
8010623e:	88 93 9e 00 00 00    	mov    %dl,0x9e(%ebx)
80106244:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
8010624a:	e8 83 ce ff ff       	call   801030d2 <mycpu>
8010624f:	8a 90 9d 00 00 00    	mov    0x9d(%eax),%dl
80106255:	83 e2 ef             	and    $0xffffffef,%edx
80106258:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
8010625e:	e8 6f ce ff ff       	call   801030d2 <mycpu>
80106263:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106269:	8b 5e 08             	mov    0x8(%esi),%ebx
8010626c:	e8 61 ce ff ff       	call   801030d2 <mycpu>
80106271:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106277:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
8010627a:	e8 53 ce ff ff       	call   801030d2 <mycpu>
8010627f:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80106285:	b8 28 00 00 00       	mov    $0x28,%eax
8010628a:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
8010628d:	8b 46 04             	mov    0x4(%esi),%eax
80106290:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106295:	0f 22 d8             	mov    %eax,%cr3
  popcli();
80106298:	e8 b0 d9 ff ff       	call   80103c4d <popcli>
}
8010629d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a0:	5b                   	pop    %ebx
801062a1:	5e                   	pop    %esi
801062a2:	5f                   	pop    %edi
801062a3:	5d                   	pop    %ebp
801062a4:	c3                   	ret    
    panic("switchuvm: no process");
801062a5:	83 ec 0c             	sub    $0xc,%esp
801062a8:	68 1e 71 10 80       	push   $0x8010711e
801062ad:	e8 92 a0 ff ff       	call   80100344 <panic>
    panic("switchuvm: no kstack");
801062b2:	83 ec 0c             	sub    $0xc,%esp
801062b5:	68 34 71 10 80       	push   $0x80107134
801062ba:	e8 85 a0 ff ff       	call   80100344 <panic>
    panic("switchuvm: no pgdir");
801062bf:	83 ec 0c             	sub    $0xc,%esp
801062c2:	68 49 71 10 80       	push   $0x80107149
801062c7:	e8 78 a0 ff ff       	call   80100344 <panic>

801062cc <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
801062cc:	55                   	push   %ebp
801062cd:	89 e5                	mov    %esp,%ebp
801062cf:	56                   	push   %esi
801062d0:	53                   	push   %ebx
801062d1:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
801062d4:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801062da:	77 4c                	ja     80106328 <inituvm+0x5c>
    panic("inituvm: more than a page");
  mem = kalloc();
801062dc:	e8 81 bd ff ff       	call   80102062 <kalloc>
801062e1:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
801062e3:	83 ec 04             	sub    $0x4,%esp
801062e6:	68 00 10 00 00       	push   $0x1000
801062eb:	6a 00                	push   $0x0
801062ed:	50                   	push   %eax
801062ee:	e8 a5 da ff ff       	call   80103d98 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801062f3:	83 c4 08             	add    $0x8,%esp
801062f6:	6a 06                	push   $0x6
801062f8:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801062fe:	50                   	push   %eax
801062ff:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106304:	ba 00 00 00 00       	mov    $0x0,%edx
80106309:	8b 45 08             	mov    0x8(%ebp),%eax
8010630c:	e8 0a fb ff ff       	call   80105e1b <mappages>
  memmove(mem, init, sz);
80106311:	83 c4 0c             	add    $0xc,%esp
80106314:	56                   	push   %esi
80106315:	ff 75 0c             	pushl  0xc(%ebp)
80106318:	53                   	push   %ebx
80106319:	e8 f0 da ff ff       	call   80103e0e <memmove>
}
8010631e:	83 c4 10             	add    $0x10,%esp
80106321:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106324:	5b                   	pop    %ebx
80106325:	5e                   	pop    %esi
80106326:	5d                   	pop    %ebp
80106327:	c3                   	ret    
    panic("inituvm: more than a page");
80106328:	83 ec 0c             	sub    $0xc,%esp
8010632b:	68 5d 71 10 80       	push   $0x8010715d
80106330:	e8 0f a0 ff ff       	call   80100344 <panic>

80106335 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106335:	55                   	push   %ebp
80106336:	89 e5                	mov    %esp,%ebp
80106338:	57                   	push   %edi
80106339:	56                   	push   %esi
8010633a:	53                   	push   %ebx
8010633b:	83 ec 0c             	sub    $0xc,%esp
8010633e:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106341:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106344:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010634a:	74 3c                	je     80106388 <loaduvm+0x53>
    panic("loaduvm: addr must be page aligned");
8010634c:	83 ec 0c             	sub    $0xc,%esp
8010634f:	68 18 72 10 80       	push   $0x80107218
80106354:	e8 eb 9f ff ff       	call   80100344 <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106359:	83 ec 0c             	sub    $0xc,%esp
8010635c:	68 77 71 10 80       	push   $0x80107177
80106361:	e8 de 9f ff ff       	call   80100344 <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106366:	05 00 00 00 80       	add    $0x80000000,%eax
8010636b:	56                   	push   %esi
8010636c:	89 da                	mov    %ebx,%edx
8010636e:	03 55 14             	add    0x14(%ebp),%edx
80106371:	52                   	push   %edx
80106372:	50                   	push   %eax
80106373:	ff 75 10             	pushl  0x10(%ebp)
80106376:	e8 a6 b3 ff ff       	call   80101721 <readi>
8010637b:	83 c4 10             	add    $0x10,%esp
8010637e:	39 f0                	cmp    %esi,%eax
80106380:	75 47                	jne    801063c9 <loaduvm+0x94>
  for(i = 0; i < sz; i += PGSIZE){
80106382:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106388:	39 fb                	cmp    %edi,%ebx
8010638a:	73 30                	jae    801063bc <loaduvm+0x87>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
8010638c:	89 da                	mov    %ebx,%edx
8010638e:	03 55 0c             	add    0xc(%ebp),%edx
80106391:	b9 00 00 00 00       	mov    $0x0,%ecx
80106396:	8b 45 08             	mov    0x8(%ebp),%eax
80106399:	e8 0c fa ff ff       	call   80105daa <walkpgdir>
8010639e:	85 c0                	test   %eax,%eax
801063a0:	74 b7                	je     80106359 <loaduvm+0x24>
    pa = PTE_ADDR(*pte);
801063a2:	8b 00                	mov    (%eax),%eax
801063a4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801063a9:	89 fe                	mov    %edi,%esi
801063ab:	29 de                	sub    %ebx,%esi
801063ad:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801063b3:	76 b1                	jbe    80106366 <loaduvm+0x31>
      n = PGSIZE;
801063b5:	be 00 10 00 00       	mov    $0x1000,%esi
801063ba:	eb aa                	jmp    80106366 <loaduvm+0x31>
      return -1;
  }
  return 0;
801063bc:	b8 00 00 00 00       	mov    $0x0,%eax
}
801063c1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801063c4:	5b                   	pop    %ebx
801063c5:	5e                   	pop    %esi
801063c6:	5f                   	pop    %edi
801063c7:	5d                   	pop    %ebp
801063c8:	c3                   	ret    
      return -1;
801063c9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801063ce:	eb f1                	jmp    801063c1 <loaduvm+0x8c>

801063d0 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
801063d0:	55                   	push   %ebp
801063d1:	89 e5                	mov    %esp,%ebp
801063d3:	57                   	push   %edi
801063d4:	56                   	push   %esi
801063d5:	53                   	push   %ebx
801063d6:	83 ec 0c             	sub    $0xc,%esp
801063d9:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
801063dc:	39 7d 10             	cmp    %edi,0x10(%ebp)
801063df:	73 11                	jae    801063f2 <deallocuvm+0x22>
    return oldsz;

  a = PGROUNDUP(newsz);
801063e1:	8b 45 10             	mov    0x10(%ebp),%eax
801063e4:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801063ea:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
801063f0:	eb 17                	jmp    80106409 <deallocuvm+0x39>
    return oldsz;
801063f2:	89 f8                	mov    %edi,%eax
801063f4:	eb 62                	jmp    80106458 <deallocuvm+0x88>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801063f6:	c1 eb 16             	shr    $0x16,%ebx
801063f9:	43                   	inc    %ebx
801063fa:	c1 e3 16             	shl    $0x16,%ebx
801063fd:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106403:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106409:	39 fb                	cmp    %edi,%ebx
8010640b:	73 48                	jae    80106455 <deallocuvm+0x85>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010640d:	b9 00 00 00 00       	mov    $0x0,%ecx
80106412:	89 da                	mov    %ebx,%edx
80106414:	8b 45 08             	mov    0x8(%ebp),%eax
80106417:	e8 8e f9 ff ff       	call   80105daa <walkpgdir>
8010641c:	89 c6                	mov    %eax,%esi
    if(!pte)
8010641e:	85 c0                	test   %eax,%eax
80106420:	74 d4                	je     801063f6 <deallocuvm+0x26>
    else if((*pte & PTE_P) != 0){
80106422:	8b 00                	mov    (%eax),%eax
80106424:	a8 01                	test   $0x1,%al
80106426:	74 db                	je     80106403 <deallocuvm+0x33>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106428:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010642d:	74 19                	je     80106448 <deallocuvm+0x78>
        panic("kfree");
      char *v = P2V(pa);
8010642f:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106434:	83 ec 0c             	sub    $0xc,%esp
80106437:	50                   	push   %eax
80106438:	e8 0e bb ff ff       	call   80101f4b <kfree>
      *pte = 0;
8010643d:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80106443:	83 c4 10             	add    $0x10,%esp
80106446:	eb bb                	jmp    80106403 <deallocuvm+0x33>
        panic("kfree");
80106448:	83 ec 0c             	sub    $0xc,%esp
8010644b:	68 66 6a 10 80       	push   $0x80106a66
80106450:	e8 ef 9e ff ff       	call   80100344 <panic>
    }
  }
  return newsz;
80106455:	8b 45 10             	mov    0x10(%ebp),%eax
}
80106458:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010645b:	5b                   	pop    %ebx
8010645c:	5e                   	pop    %esi
8010645d:	5f                   	pop    %edi
8010645e:	5d                   	pop    %ebp
8010645f:	c3                   	ret    

80106460 <allocuvm>:
{
80106460:	55                   	push   %ebp
80106461:	89 e5                	mov    %esp,%ebp
80106463:	57                   	push   %edi
80106464:	56                   	push   %esi
80106465:	53                   	push   %ebx
80106466:	83 ec 1c             	sub    $0x1c,%esp
80106469:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
8010646c:	85 ff                	test   %edi,%edi
8010646e:	0f 88 c2 00 00 00    	js     80106536 <allocuvm+0xd6>
  if(newsz < oldsz)
80106474:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106477:	72 5f                	jb     801064d8 <allocuvm+0x78>
  a = PGROUNDUP(oldsz);
80106479:	8b 55 0c             	mov    0xc(%ebp),%edx
8010647c:	8d b2 ff 0f 00 00    	lea    0xfff(%edx),%esi
80106482:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80106488:	89 7d e4             	mov    %edi,-0x1c(%ebp)
8010648b:	39 fe                	cmp    %edi,%esi
8010648d:	0f 83 9e 00 00 00    	jae    80106531 <allocuvm+0xd1>
    mem = kalloc();
80106493:	e8 ca bb ff ff       	call   80102062 <kalloc>
80106498:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010649a:	85 c0                	test   %eax,%eax
8010649c:	74 3f                	je     801064dd <allocuvm+0x7d>
    memset(mem, 0, PGSIZE);
8010649e:	83 ec 04             	sub    $0x4,%esp
801064a1:	68 00 10 00 00       	push   $0x1000
801064a6:	6a 00                	push   $0x0
801064a8:	50                   	push   %eax
801064a9:	e8 ea d8 ff ff       	call   80103d98 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
801064ae:	83 c4 08             	add    $0x8,%esp
801064b1:	6a 06                	push   $0x6
801064b3:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801064b9:	50                   	push   %eax
801064ba:	b9 00 10 00 00       	mov    $0x1000,%ecx
801064bf:	89 f2                	mov    %esi,%edx
801064c1:	8b 45 08             	mov    0x8(%ebp),%eax
801064c4:	e8 52 f9 ff ff       	call   80105e1b <mappages>
801064c9:	83 c4 10             	add    $0x10,%esp
801064cc:	85 c0                	test   %eax,%eax
801064ce:	78 33                	js     80106503 <allocuvm+0xa3>
  for(; a < newsz; a += PGSIZE){
801064d0:	81 c6 00 10 00 00    	add    $0x1000,%esi
801064d6:	eb b3                	jmp    8010648b <allocuvm+0x2b>
    return oldsz;
801064d8:	8b 45 0c             	mov    0xc(%ebp),%eax
801064db:	eb 5e                	jmp    8010653b <allocuvm+0xdb>
      cprintf("allocuvm out of memory\n");
801064dd:	83 ec 0c             	sub    $0xc,%esp
801064e0:	68 95 71 10 80       	push   $0x80107195
801064e5:	e8 f5 a0 ff ff       	call   801005df <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801064ea:	83 c4 0c             	add    $0xc,%esp
801064ed:	ff 75 0c             	pushl  0xc(%ebp)
801064f0:	57                   	push   %edi
801064f1:	ff 75 08             	pushl  0x8(%ebp)
801064f4:	e8 d7 fe ff ff       	call   801063d0 <deallocuvm>
      return 0;
801064f9:	83 c4 10             	add    $0x10,%esp
801064fc:	b8 00 00 00 00       	mov    $0x0,%eax
80106501:	eb 38                	jmp    8010653b <allocuvm+0xdb>
      cprintf("allocuvm out of memory (2)\n");
80106503:	83 ec 0c             	sub    $0xc,%esp
80106506:	68 ad 71 10 80       	push   $0x801071ad
8010650b:	e8 cf a0 ff ff       	call   801005df <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106510:	83 c4 0c             	add    $0xc,%esp
80106513:	ff 75 0c             	pushl  0xc(%ebp)
80106516:	57                   	push   %edi
80106517:	ff 75 08             	pushl  0x8(%ebp)
8010651a:	e8 b1 fe ff ff       	call   801063d0 <deallocuvm>
      kfree(mem);
8010651f:	89 1c 24             	mov    %ebx,(%esp)
80106522:	e8 24 ba ff ff       	call   80101f4b <kfree>
      return 0;
80106527:	83 c4 10             	add    $0x10,%esp
8010652a:	b8 00 00 00 00       	mov    $0x0,%eax
8010652f:	eb 0a                	jmp    8010653b <allocuvm+0xdb>
80106531:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106534:	eb 05                	jmp    8010653b <allocuvm+0xdb>
    return 0;
80106536:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010653b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010653e:	5b                   	pop    %ebx
8010653f:	5e                   	pop    %esi
80106540:	5f                   	pop    %edi
80106541:	5d                   	pop    %ebp
80106542:	c3                   	ret    

80106543 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106543:	55                   	push   %ebp
80106544:	89 e5                	mov    %esp,%ebp
80106546:	56                   	push   %esi
80106547:	53                   	push   %ebx
80106548:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010654b:	85 f6                	test   %esi,%esi
8010654d:	74 1a                	je     80106569 <freevm+0x26>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
8010654f:	83 ec 04             	sub    $0x4,%esp
80106552:	6a 00                	push   $0x0
80106554:	68 00 00 00 80       	push   $0x80000000
80106559:	56                   	push   %esi
8010655a:	e8 71 fe ff ff       	call   801063d0 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
8010655f:	83 c4 10             	add    $0x10,%esp
80106562:	bb 00 00 00 00       	mov    $0x0,%ebx
80106567:	eb 0e                	jmp    80106577 <freevm+0x34>
    panic("freevm: no pgdir");
80106569:	83 ec 0c             	sub    $0xc,%esp
8010656c:	68 c9 71 10 80       	push   $0x801071c9
80106571:	e8 ce 9d ff ff       	call   80100344 <panic>
  for(i = 0; i < NPDENTRIES; i++){
80106576:	43                   	inc    %ebx
80106577:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
8010657d:	77 1f                	ja     8010659e <freevm+0x5b>
    if(pgdir[i] & PTE_P){
8010657f:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
80106582:	a8 01                	test   $0x1,%al
80106584:	74 f0                	je     80106576 <freevm+0x33>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106586:	25 00 f0 ff ff       	and    $0xfffff000,%eax
8010658b:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
80106590:	83 ec 0c             	sub    $0xc,%esp
80106593:	50                   	push   %eax
80106594:	e8 b2 b9 ff ff       	call   80101f4b <kfree>
80106599:	83 c4 10             	add    $0x10,%esp
8010659c:	eb d8                	jmp    80106576 <freevm+0x33>
    }
  }
  kfree((char*)pgdir);
8010659e:	83 ec 0c             	sub    $0xc,%esp
801065a1:	56                   	push   %esi
801065a2:	e8 a4 b9 ff ff       	call   80101f4b <kfree>
}
801065a7:	83 c4 10             	add    $0x10,%esp
801065aa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801065ad:	5b                   	pop    %ebx
801065ae:	5e                   	pop    %esi
801065af:	5d                   	pop    %ebp
801065b0:	c3                   	ret    

801065b1 <setupkvm>:
{
801065b1:	55                   	push   %ebp
801065b2:	89 e5                	mov    %esp,%ebp
801065b4:	56                   	push   %esi
801065b5:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801065b6:	e8 a7 ba ff ff       	call   80102062 <kalloc>
801065bb:	89 c6                	mov    %eax,%esi
801065bd:	85 c0                	test   %eax,%eax
801065bf:	74 55                	je     80106616 <setupkvm+0x65>
  memset(pgdir, 0, PGSIZE);
801065c1:	83 ec 04             	sub    $0x4,%esp
801065c4:	68 00 10 00 00       	push   $0x1000
801065c9:	6a 00                	push   $0x0
801065cb:	50                   	push   %eax
801065cc:	e8 c7 d7 ff ff       	call   80103d98 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801065d1:	83 c4 10             	add    $0x10,%esp
801065d4:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
801065d9:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
801065df:	73 35                	jae    80106616 <setupkvm+0x65>
                (uint)k->phys_start, k->perm) < 0) {
801065e1:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801065e4:	8b 4b 08             	mov    0x8(%ebx),%ecx
801065e7:	29 c1                	sub    %eax,%ecx
801065e9:	8b 13                	mov    (%ebx),%edx
801065eb:	83 ec 08             	sub    $0x8,%esp
801065ee:	ff 73 0c             	pushl  0xc(%ebx)
801065f1:	50                   	push   %eax
801065f2:	89 f0                	mov    %esi,%eax
801065f4:	e8 22 f8 ff ff       	call   80105e1b <mappages>
801065f9:	83 c4 10             	add    $0x10,%esp
801065fc:	85 c0                	test   %eax,%eax
801065fe:	78 05                	js     80106605 <setupkvm+0x54>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106600:	83 c3 10             	add    $0x10,%ebx
80106603:	eb d4                	jmp    801065d9 <setupkvm+0x28>
      freevm(pgdir);
80106605:	83 ec 0c             	sub    $0xc,%esp
80106608:	56                   	push   %esi
80106609:	e8 35 ff ff ff       	call   80106543 <freevm>
      return 0;
8010660e:	83 c4 10             	add    $0x10,%esp
80106611:	be 00 00 00 00       	mov    $0x0,%esi
}
80106616:	89 f0                	mov    %esi,%eax
80106618:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010661b:	5b                   	pop    %ebx
8010661c:	5e                   	pop    %esi
8010661d:	5d                   	pop    %ebp
8010661e:	c3                   	ret    

8010661f <kvmalloc>:
{
8010661f:	55                   	push   %ebp
80106620:	89 e5                	mov    %esp,%ebp
80106622:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106625:	e8 87 ff ff ff       	call   801065b1 <setupkvm>
8010662a:	a3 c4 73 11 80       	mov    %eax,0x801173c4
  switchkvm();
8010662f:	e8 2e fb ff ff       	call   80106162 <switchkvm>
}
80106634:	c9                   	leave  
80106635:	c3                   	ret    

80106636 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106636:	55                   	push   %ebp
80106637:	89 e5                	mov    %esp,%ebp
80106639:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
8010663c:	b9 00 00 00 00       	mov    $0x0,%ecx
80106641:	8b 55 0c             	mov    0xc(%ebp),%edx
80106644:	8b 45 08             	mov    0x8(%ebp),%eax
80106647:	e8 5e f7 ff ff       	call   80105daa <walkpgdir>
  if(pte == 0)
8010664c:	85 c0                	test   %eax,%eax
8010664e:	74 09                	je     80106659 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106650:	8b 10                	mov    (%eax),%edx
80106652:	83 e2 fb             	and    $0xfffffffb,%edx
80106655:	89 10                	mov    %edx,(%eax)
}
80106657:	c9                   	leave  
80106658:	c3                   	ret    
    panic("clearpteu");
80106659:	83 ec 0c             	sub    $0xc,%esp
8010665c:	68 da 71 10 80       	push   $0x801071da
80106661:	e8 de 9c ff ff       	call   80100344 <panic>

80106666 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106666:	55                   	push   %ebp
80106667:	89 e5                	mov    %esp,%ebp
80106669:	57                   	push   %edi
8010666a:	56                   	push   %esi
8010666b:	53                   	push   %ebx
8010666c:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
8010666f:	e8 3d ff ff ff       	call   801065b1 <setupkvm>
80106674:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106677:	85 c0                	test   %eax,%eax
80106679:	0f 84 c4 00 00 00    	je     80106743 <copyuvm+0xdd>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
8010667f:	be 00 00 00 00       	mov    $0x0,%esi
80106684:	3b 75 0c             	cmp    0xc(%ebp),%esi
80106687:	0f 83 b6 00 00 00    	jae    80106743 <copyuvm+0xdd>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
8010668d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
80106690:	b9 00 00 00 00       	mov    $0x0,%ecx
80106695:	89 f2                	mov    %esi,%edx
80106697:	8b 45 08             	mov    0x8(%ebp),%eax
8010669a:	e8 0b f7 ff ff       	call   80105daa <walkpgdir>
8010669f:	85 c0                	test   %eax,%eax
801066a1:	74 65                	je     80106708 <copyuvm+0xa2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
801066a3:	8b 00                	mov    (%eax),%eax
801066a5:	a8 01                	test   $0x1,%al
801066a7:	74 6c                	je     80106715 <copyuvm+0xaf>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
801066a9:	89 c3                	mov    %eax,%ebx
801066ab:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
801066b1:	25 ff 0f 00 00       	and    $0xfff,%eax
801066b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
801066b9:	e8 a4 b9 ff ff       	call   80102062 <kalloc>
801066be:	89 c7                	mov    %eax,%edi
801066c0:	85 c0                	test   %eax,%eax
801066c2:	74 6a                	je     8010672e <copyuvm+0xc8>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
801066c4:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
801066ca:	83 ec 04             	sub    $0x4,%esp
801066cd:	68 00 10 00 00       	push   $0x1000
801066d2:	53                   	push   %ebx
801066d3:	50                   	push   %eax
801066d4:	e8 35 d7 ff ff       	call   80103e0e <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
801066d9:	83 c4 08             	add    $0x8,%esp
801066dc:	ff 75 e0             	pushl  -0x20(%ebp)
801066df:	8d 87 00 00 00 80    	lea    -0x80000000(%edi),%eax
801066e5:	50                   	push   %eax
801066e6:	b9 00 10 00 00       	mov    $0x1000,%ecx
801066eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801066ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
801066f1:	e8 25 f7 ff ff       	call   80105e1b <mappages>
801066f6:	83 c4 10             	add    $0x10,%esp
801066f9:	85 c0                	test   %eax,%eax
801066fb:	78 25                	js     80106722 <copyuvm+0xbc>
  for(i = 0; i < sz; i += PGSIZE){
801066fd:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106703:	e9 7c ff ff ff       	jmp    80106684 <copyuvm+0x1e>
      panic("copyuvm: pte should exist");
80106708:	83 ec 0c             	sub    $0xc,%esp
8010670b:	68 e4 71 10 80       	push   $0x801071e4
80106710:	e8 2f 9c ff ff       	call   80100344 <panic>
      panic("copyuvm: page not present");
80106715:	83 ec 0c             	sub    $0xc,%esp
80106718:	68 fe 71 10 80       	push   $0x801071fe
8010671d:	e8 22 9c ff ff       	call   80100344 <panic>
      kfree(mem);
80106722:	83 ec 0c             	sub    $0xc,%esp
80106725:	57                   	push   %edi
80106726:	e8 20 b8 ff ff       	call   80101f4b <kfree>
      goto bad;
8010672b:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
8010672e:	83 ec 0c             	sub    $0xc,%esp
80106731:	ff 75 dc             	pushl  -0x24(%ebp)
80106734:	e8 0a fe ff ff       	call   80106543 <freevm>
  return 0;
80106739:	83 c4 10             	add    $0x10,%esp
8010673c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
80106743:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106746:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106749:	5b                   	pop    %ebx
8010674a:	5e                   	pop    %esi
8010674b:	5f                   	pop    %edi
8010674c:	5d                   	pop    %ebp
8010674d:	c3                   	ret    

8010674e <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
8010674e:	55                   	push   %ebp
8010674f:	89 e5                	mov    %esp,%ebp
80106751:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106754:	b9 00 00 00 00       	mov    $0x0,%ecx
80106759:	8b 55 0c             	mov    0xc(%ebp),%edx
8010675c:	8b 45 08             	mov    0x8(%ebp),%eax
8010675f:	e8 46 f6 ff ff       	call   80105daa <walkpgdir>
  if((*pte & PTE_P) == 0)
80106764:	8b 00                	mov    (%eax),%eax
80106766:	a8 01                	test   $0x1,%al
80106768:	74 10                	je     8010677a <uva2ka+0x2c>
    return 0;
  if((*pte & PTE_U) == 0)
8010676a:	a8 04                	test   $0x4,%al
8010676c:	74 13                	je     80106781 <uva2ka+0x33>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
8010676e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106773:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106778:	c9                   	leave  
80106779:	c3                   	ret    
    return 0;
8010677a:	b8 00 00 00 00       	mov    $0x0,%eax
8010677f:	eb f7                	jmp    80106778 <uva2ka+0x2a>
    return 0;
80106781:	b8 00 00 00 00       	mov    $0x0,%eax
80106786:	eb f0                	jmp    80106778 <uva2ka+0x2a>

80106788 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106788:	55                   	push   %ebp
80106789:	89 e5                	mov    %esp,%ebp
8010678b:	57                   	push   %edi
8010678c:	56                   	push   %esi
8010678d:	53                   	push   %ebx
8010678e:	83 ec 0c             	sub    $0xc,%esp
80106791:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106794:	eb 20                	jmp    801067b6 <copyout+0x2e>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106796:	29 fe                	sub    %edi,%esi
80106798:	01 f0                	add    %esi,%eax
8010679a:	83 ec 04             	sub    $0x4,%esp
8010679d:	53                   	push   %ebx
8010679e:	ff 75 10             	pushl  0x10(%ebp)
801067a1:	50                   	push   %eax
801067a2:	e8 67 d6 ff ff       	call   80103e0e <memmove>
    len -= n;
801067a7:	29 5d 14             	sub    %ebx,0x14(%ebp)
    buf += n;
801067aa:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
801067ad:	8d b7 00 10 00 00    	lea    0x1000(%edi),%esi
801067b3:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
801067b6:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801067ba:	74 2f                	je     801067eb <copyout+0x63>
    va0 = (uint)PGROUNDDOWN(va);
801067bc:	89 f7                	mov    %esi,%edi
801067be:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    pa0 = uva2ka(pgdir, (char*)va0);
801067c4:	83 ec 08             	sub    $0x8,%esp
801067c7:	57                   	push   %edi
801067c8:	ff 75 08             	pushl  0x8(%ebp)
801067cb:	e8 7e ff ff ff       	call   8010674e <uva2ka>
    if(pa0 == 0)
801067d0:	83 c4 10             	add    $0x10,%esp
801067d3:	85 c0                	test   %eax,%eax
801067d5:	74 21                	je     801067f8 <copyout+0x70>
    n = PGSIZE - (va - va0);
801067d7:	89 fb                	mov    %edi,%ebx
801067d9:	29 f3                	sub    %esi,%ebx
801067db:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
801067e1:	39 5d 14             	cmp    %ebx,0x14(%ebp)
801067e4:	73 b0                	jae    80106796 <copyout+0xe>
      n = len;
801067e6:	8b 5d 14             	mov    0x14(%ebp),%ebx
801067e9:	eb ab                	jmp    80106796 <copyout+0xe>
  }
  return 0;
801067eb:	b8 00 00 00 00       	mov    $0x0,%eax
}
801067f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801067f3:	5b                   	pop    %ebx
801067f4:	5e                   	pop    %esi
801067f5:	5f                   	pop    %edi
801067f6:	5d                   	pop    %ebp
801067f7:	c3                   	ret    
      return -1;
801067f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801067fd:	eb f1                	jmp    801067f0 <copyout+0x68>
