
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
80100028:	bc c0 b5 10 80       	mov    $0x8010b5c0,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 15 2b 10 80       	mov    $0x80102b15,%eax
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
80100041:	68 c0 b5 10 80       	push   $0x8010b5c0
80100046:	e8 84 3c 00 00       	call   80103ccf <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
8010004b:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
80100051:	83 c4 10             	add    $0x10,%esp
80100054:	eb 03                	jmp    80100059 <bget+0x25>
80100056:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100059:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010005f:	74 30                	je     80100091 <bget+0x5d>
    if(b->dev == dev && b->blockno == blockno){
80100061:	39 73 04             	cmp    %esi,0x4(%ebx)
80100064:	75 f0                	jne    80100056 <bget+0x22>
80100066:	39 7b 08             	cmp    %edi,0x8(%ebx)
80100069:	75 eb                	jne    80100056 <bget+0x22>
      b->refcnt++;
8010006b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010006e:	83 c0 01             	add    $0x1,%eax
80100071:	89 43 4c             	mov    %eax,0x4c(%ebx)
      release(&bcache.lock);
80100074:	83 ec 0c             	sub    $0xc,%esp
80100077:	68 c0 b5 10 80       	push   $0x8010b5c0
8010007c:	e8 b7 3c 00 00       	call   80103d38 <release>
      acquiresleep(&b->lock);
80100081:	8d 43 0c             	lea    0xc(%ebx),%eax
80100084:	89 04 24             	mov    %eax,(%esp)
80100087:	e8 0f 3a 00 00       	call   80103a9b <acquiresleep>
      return b;
8010008c:	83 c4 10             	add    $0x10,%esp
8010008f:	eb 4c                	jmp    801000dd <bget+0xa9>
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100091:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100097:	eb 03                	jmp    8010009c <bget+0x68>
80100099:	8b 5b 50             	mov    0x50(%ebx),%ebx
8010009c:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000a2:	74 43                	je     801000e7 <bget+0xb3>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
801000a4:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801000a8:	75 ef                	jne    80100099 <bget+0x65>
801000aa:	f6 03 04             	testb  $0x4,(%ebx)
801000ad:	75 ea                	jne    80100099 <bget+0x65>
      b->dev = dev;
801000af:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
801000b2:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
801000b5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
801000bb:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
801000c2:	83 ec 0c             	sub    $0xc,%esp
801000c5:	68 c0 b5 10 80       	push   $0x8010b5c0
801000ca:	e8 69 3c 00 00       	call   80103d38 <release>
      acquiresleep(&b->lock);
801000cf:	8d 43 0c             	lea    0xc(%ebx),%eax
801000d2:	89 04 24             	mov    %eax,(%esp)
801000d5:	e8 c1 39 00 00       	call   80103a9b <acquiresleep>
      return b;
801000da:	83 c4 10             	add    $0x10,%esp
    }
  }
  panic("bget: no buffers");
}
801000dd:	89 d8                	mov    %ebx,%eax
801000df:	8d 65 f4             	lea    -0xc(%ebp),%esp
801000e2:	5b                   	pop    %ebx
801000e3:	5e                   	pop    %esi
801000e4:	5f                   	pop    %edi
801000e5:	5d                   	pop    %ebp
801000e6:	c3                   	ret    
  panic("bget: no buffers");
801000e7:	83 ec 0c             	sub    $0xc,%esp
801000ea:	68 80 66 10 80       	push   $0x80106680
801000ef:	e8 68 02 00 00       	call   8010035c <panic>

801000f4 <binit>:
{
801000f4:	f3 0f 1e fb          	endbr32 
801000f8:	55                   	push   %ebp
801000f9:	89 e5                	mov    %esp,%ebp
801000fb:	53                   	push   %ebx
801000fc:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
801000ff:	68 91 66 10 80       	push   $0x80106691
80100104:	68 c0 b5 10 80       	push   $0x8010b5c0
80100109:	e8 71 3a 00 00       	call   80103b7f <initlock>
  bcache.head.prev = &bcache.head;
8010010e:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
80100115:	fc 10 80 
  bcache.head.next = &bcache.head;
80100118:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
8010011f:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100122:	83 c4 10             	add    $0x10,%esp
80100125:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
8010012a:	eb 37                	jmp    80100163 <binit+0x6f>
    b->next = bcache.head.next;
8010012c:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100131:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
80100134:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
8010013b:	83 ec 08             	sub    $0x8,%esp
8010013e:	68 98 66 10 80       	push   $0x80106698
80100143:	8d 43 0c             	lea    0xc(%ebx),%eax
80100146:	50                   	push   %eax
80100147:	e8 18 39 00 00       	call   80103a64 <initsleeplock>
    bcache.head.next->prev = b;
8010014c:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
80100151:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100154:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
8010015a:	81 c3 5c 02 00 00    	add    $0x25c,%ebx
80100160:	83 c4 10             	add    $0x10,%esp
80100163:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100169:	72 c1                	jb     8010012c <binit+0x38>
}
8010016b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010016e:	c9                   	leave  
8010016f:	c3                   	ret    

80100170 <bread>:

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
80100170:	f3 0f 1e fb          	endbr32 
80100174:	55                   	push   %ebp
80100175:	89 e5                	mov    %esp,%ebp
80100177:	53                   	push   %ebx
80100178:	83 ec 04             	sub    $0x4,%esp
  struct buf *b;

  b = bget(dev, blockno);
8010017b:	8b 55 0c             	mov    0xc(%ebp),%edx
8010017e:	8b 45 08             	mov    0x8(%ebp),%eax
80100181:	e8 ae fe ff ff       	call   80100034 <bget>
80100186:	89 c3                	mov    %eax,%ebx
  if((b->flags & B_VALID) == 0) {
80100188:	f6 00 02             	testb  $0x2,(%eax)
8010018b:	74 07                	je     80100194 <bread+0x24>
    iderw(b);
  }
  return b;
}
8010018d:	89 d8                	mov    %ebx,%eax
8010018f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100192:	c9                   	leave  
80100193:	c3                   	ret    
    iderw(b);
80100194:	83 ec 0c             	sub    $0xc,%esp
80100197:	50                   	push   %eax
80100198:	e8 ec 1c 00 00       	call   80101e89 <iderw>
8010019d:	83 c4 10             	add    $0x10,%esp
  return b;
801001a0:	eb eb                	jmp    8010018d <bread+0x1d>

801001a2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a2:	f3 0f 1e fb          	endbr32 
801001a6:	55                   	push   %ebp
801001a7:	89 e5                	mov    %esp,%ebp
801001a9:	53                   	push   %ebx
801001aa:	83 ec 10             	sub    $0x10,%esp
801001ad:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001b0:	8d 43 0c             	lea    0xc(%ebx),%eax
801001b3:	50                   	push   %eax
801001b4:	e8 74 39 00 00       	call   80103b2d <holdingsleep>
801001b9:	83 c4 10             	add    $0x10,%esp
801001bc:	85 c0                	test   %eax,%eax
801001be:	74 14                	je     801001d4 <bwrite+0x32>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001c0:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001c3:	83 ec 0c             	sub    $0xc,%esp
801001c6:	53                   	push   %ebx
801001c7:	e8 bd 1c 00 00       	call   80101e89 <iderw>
}
801001cc:	83 c4 10             	add    $0x10,%esp
801001cf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d2:	c9                   	leave  
801001d3:	c3                   	ret    
    panic("bwrite");
801001d4:	83 ec 0c             	sub    $0xc,%esp
801001d7:	68 9f 66 10 80       	push   $0x8010669f
801001dc:	e8 7b 01 00 00       	call   8010035c <panic>

801001e1 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e1:	f3 0f 1e fb          	endbr32 
801001e5:	55                   	push   %ebp
801001e6:	89 e5                	mov    %esp,%ebp
801001e8:	56                   	push   %esi
801001e9:	53                   	push   %ebx
801001ea:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ed:	8d 73 0c             	lea    0xc(%ebx),%esi
801001f0:	83 ec 0c             	sub    $0xc,%esp
801001f3:	56                   	push   %esi
801001f4:	e8 34 39 00 00       	call   80103b2d <holdingsleep>
801001f9:	83 c4 10             	add    $0x10,%esp
801001fc:	85 c0                	test   %eax,%eax
801001fe:	74 6b                	je     8010026b <brelse+0x8a>
    panic("brelse");

  releasesleep(&b->lock);
80100200:	83 ec 0c             	sub    $0xc,%esp
80100203:	56                   	push   %esi
80100204:	e8 e5 38 00 00       	call   80103aee <releasesleep>

  acquire(&bcache.lock);
80100209:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100210:	e8 ba 3a 00 00       	call   80103ccf <acquire>
  b->refcnt--;
80100215:	8b 43 4c             	mov    0x4c(%ebx),%eax
80100218:	83 e8 01             	sub    $0x1,%eax
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	83 c4 10             	add    $0x10,%esp
80100221:	85 c0                	test   %eax,%eax
80100223:	75 2f                	jne    80100254 <brelse+0x73>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100225:	8b 43 54             	mov    0x54(%ebx),%eax
80100228:	8b 53 50             	mov    0x50(%ebx),%edx
8010022b:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010022e:	8b 43 50             	mov    0x50(%ebx),%eax
80100231:	8b 53 54             	mov    0x54(%ebx),%edx
80100234:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100237:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023c:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
8010023f:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    bcache.head.next->prev = b;
80100246:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010024b:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010024e:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100254:	83 ec 0c             	sub    $0xc,%esp
80100257:	68 c0 b5 10 80       	push   $0x8010b5c0
8010025c:	e8 d7 3a 00 00       	call   80103d38 <release>
}
80100261:	83 c4 10             	add    $0x10,%esp
80100264:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100267:	5b                   	pop    %ebx
80100268:	5e                   	pop    %esi
80100269:	5d                   	pop    %ebp
8010026a:	c3                   	ret    
    panic("brelse");
8010026b:	83 ec 0c             	sub    $0xc,%esp
8010026e:	68 a6 66 10 80       	push   $0x801066a6
80100273:	e8 e4 00 00 00       	call   8010035c <panic>

80100278 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100278:	f3 0f 1e fb          	endbr32 
8010027c:	55                   	push   %ebp
8010027d:	89 e5                	mov    %esp,%ebp
8010027f:	57                   	push   %edi
80100280:	56                   	push   %esi
80100281:	53                   	push   %ebx
80100282:	83 ec 28             	sub    $0x28,%esp
80100285:	8b 7d 08             	mov    0x8(%ebp),%edi
80100288:	8b 75 0c             	mov    0xc(%ebp),%esi
8010028b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  uint target;
  int c;

  iunlock(ip);
8010028e:	57                   	push   %edi
8010028f:	e8 fc 13 00 00       	call   80101690 <iunlock>
  target = n;
80100294:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  acquire(&cons.lock);
80100297:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010029e:	e8 2c 3a 00 00       	call   80103ccf <acquire>
  while(n > 0){
801002a3:	83 c4 10             	add    $0x10,%esp
801002a6:	85 db                	test   %ebx,%ebx
801002a8:	0f 8e 8f 00 00 00    	jle    8010033d <consoleread+0xc5>
    while(input.r == input.w){
801002ae:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002b3:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002b9:	75 47                	jne    80100302 <consoleread+0x8a>
      if(myproc()->killed){
801002bb:	e8 0b 30 00 00       	call   801032cb <myproc>
801002c0:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
801002c4:	75 17                	jne    801002dd <consoleread+0x65>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c6:	83 ec 08             	sub    $0x8,%esp
801002c9:	68 20 a5 10 80       	push   $0x8010a520
801002ce:	68 a0 ff 10 80       	push   $0x8010ffa0
801002d3:	e8 bc 34 00 00       	call   80103794 <sleep>
801002d8:	83 c4 10             	add    $0x10,%esp
801002db:	eb d1                	jmp    801002ae <consoleread+0x36>
        release(&cons.lock);
801002dd:	83 ec 0c             	sub    $0xc,%esp
801002e0:	68 20 a5 10 80       	push   $0x8010a520
801002e5:	e8 4e 3a 00 00       	call   80103d38 <release>
        ilock(ip);
801002ea:	89 3c 24             	mov    %edi,(%esp)
801002ed:	e8 d8 12 00 00       	call   801015ca <ilock>
        return -1;
801002f2:	83 c4 10             	add    $0x10,%esp
801002f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fd:	5b                   	pop    %ebx
801002fe:	5e                   	pop    %esi
801002ff:	5f                   	pop    %edi
80100300:	5d                   	pop    %ebp
80100301:	c3                   	ret    
    c = input.buf[input.r++ % INPUT_BUF];
80100302:	8d 50 01             	lea    0x1(%eax),%edx
80100305:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
8010030b:	89 c2                	mov    %eax,%edx
8010030d:	83 e2 7f             	and    $0x7f,%edx
80100310:	0f b6 92 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%edx
80100317:	0f be ca             	movsbl %dl,%ecx
    if(c == C('D')){  // EOF
8010031a:	80 fa 04             	cmp    $0x4,%dl
8010031d:	74 14                	je     80100333 <consoleread+0xbb>
    *dst++ = c;
8010031f:	8d 46 01             	lea    0x1(%esi),%eax
80100322:	88 16                	mov    %dl,(%esi)
    --n;
80100324:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100327:	83 f9 0a             	cmp    $0xa,%ecx
8010032a:	74 11                	je     8010033d <consoleread+0xc5>
    *dst++ = c;
8010032c:	89 c6                	mov    %eax,%esi
8010032e:	e9 73 ff ff ff       	jmp    801002a6 <consoleread+0x2e>
      if(n < target){
80100333:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
80100336:	73 05                	jae    8010033d <consoleread+0xc5>
        input.r--;
80100338:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
  release(&cons.lock);
8010033d:	83 ec 0c             	sub    $0xc,%esp
80100340:	68 20 a5 10 80       	push   $0x8010a520
80100345:	e8 ee 39 00 00       	call   80103d38 <release>
  ilock(ip);
8010034a:	89 3c 24             	mov    %edi,(%esp)
8010034d:	e8 78 12 00 00       	call   801015ca <ilock>
  return target - n;
80100352:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100355:	29 d8                	sub    %ebx,%eax
80100357:	83 c4 10             	add    $0x10,%esp
8010035a:	eb 9e                	jmp    801002fa <consoleread+0x82>

8010035c <panic>:
{
8010035c:	f3 0f 1e fb          	endbr32 
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	53                   	push   %ebx
80100364:	83 ec 34             	sub    $0x34,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100367:	fa                   	cli    
  cons.locking = 0;
80100368:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
8010036f:	00 00 00 
  cprintf("lapicid %d: panic: ", lapicid());
80100372:	e8 a2 20 00 00       	call   80102419 <lapicid>
80100377:	83 ec 08             	sub    $0x8,%esp
8010037a:	50                   	push   %eax
8010037b:	68 ad 66 10 80       	push   $0x801066ad
80100380:	e8 a4 02 00 00       	call   80100629 <cprintf>
  cprintf(s);
80100385:	83 c4 04             	add    $0x4,%esp
80100388:	ff 75 08             	pushl  0x8(%ebp)
8010038b:	e8 99 02 00 00       	call   80100629 <cprintf>
  cprintf("\n");
80100390:	c7 04 24 db 6f 10 80 	movl   $0x80106fdb,(%esp)
80100397:	e8 8d 02 00 00       	call   80100629 <cprintf>
  getcallerpcs(&s, pcs);
8010039c:	83 c4 08             	add    $0x8,%esp
8010039f:	8d 45 d0             	lea    -0x30(%ebp),%eax
801003a2:	50                   	push   %eax
801003a3:	8d 45 08             	lea    0x8(%ebp),%eax
801003a6:	50                   	push   %eax
801003a7:	e8 f2 37 00 00       	call   80103b9e <getcallerpcs>
  for(i=0; i<10; i++)
801003ac:	83 c4 10             	add    $0x10,%esp
801003af:	bb 00 00 00 00       	mov    $0x0,%ebx
801003b4:	eb 17                	jmp    801003cd <panic+0x71>
    cprintf(" %p", pcs[i]);
801003b6:	83 ec 08             	sub    $0x8,%esp
801003b9:	ff 74 9d d0          	pushl  -0x30(%ebp,%ebx,4)
801003bd:	68 c1 66 10 80       	push   $0x801066c1
801003c2:	e8 62 02 00 00       	call   80100629 <cprintf>
  for(i=0; i<10; i++)
801003c7:	83 c3 01             	add    $0x1,%ebx
801003ca:	83 c4 10             	add    $0x10,%esp
801003cd:	83 fb 09             	cmp    $0x9,%ebx
801003d0:	7e e4                	jle    801003b6 <panic+0x5a>
  panicked = 1; // freeze other CPU
801003d2:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d9:	00 00 00 
  for(;;)
801003dc:	eb fe                	jmp    801003dc <panic+0x80>

801003de <cgaputc>:
{
801003de:	55                   	push   %ebp
801003df:	89 e5                	mov    %esp,%ebp
801003e1:	57                   	push   %edi
801003e2:	56                   	push   %esi
801003e3:	53                   	push   %ebx
801003e4:	83 ec 0c             	sub    $0xc,%esp
801003e7:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801003e9:	b9 d4 03 00 00       	mov    $0x3d4,%ecx
801003ee:	b8 0e 00 00 00       	mov    $0xe,%eax
801003f3:	89 ca                	mov    %ecx,%edx
801003f5:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801003f6:	bb d5 03 00 00       	mov    $0x3d5,%ebx
801003fb:	89 da                	mov    %ebx,%edx
801003fd:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
801003fe:	0f b6 f8             	movzbl %al,%edi
80100401:	c1 e7 08             	shl    $0x8,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100404:	b8 0f 00 00 00       	mov    $0xf,%eax
80100409:	89 ca                	mov    %ecx,%edx
8010040b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010040c:	89 da                	mov    %ebx,%edx
8010040e:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
8010040f:	0f b6 c8             	movzbl %al,%ecx
80100412:	09 f9                	or     %edi,%ecx
  if(c == '\n')
80100414:	83 fe 0a             	cmp    $0xa,%esi
80100417:	74 66                	je     8010047f <cgaputc+0xa1>
  else if(c == BACKSPACE){
80100419:	81 fe 00 01 00 00    	cmp    $0x100,%esi
8010041f:	74 7f                	je     801004a0 <cgaputc+0xc2>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100421:	89 f0                	mov    %esi,%eax
80100423:	0f b6 f0             	movzbl %al,%esi
80100426:	8d 59 01             	lea    0x1(%ecx),%ebx
80100429:	66 81 ce 00 07       	or     $0x700,%si
8010042e:	66 89 b4 09 00 80 0b 	mov    %si,-0x7ff48000(%ecx,%ecx,1)
80100435:	80 
  if(pos < 0 || pos > 25*80)
80100436:	81 fb d0 07 00 00    	cmp    $0x7d0,%ebx
8010043c:	77 6f                	ja     801004ad <cgaputc+0xcf>
  if((pos/80) >= 24){  // Scroll up.
8010043e:	81 fb 7f 07 00 00    	cmp    $0x77f,%ebx
80100444:	7f 74                	jg     801004ba <cgaputc+0xdc>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100446:	be d4 03 00 00       	mov    $0x3d4,%esi
8010044b:	b8 0e 00 00 00       	mov    $0xe,%eax
80100450:	89 f2                	mov    %esi,%edx
80100452:	ee                   	out    %al,(%dx)
  outb(CRTPORT+1, pos>>8);
80100453:	89 d8                	mov    %ebx,%eax
80100455:	c1 f8 08             	sar    $0x8,%eax
80100458:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
8010045d:	89 ca                	mov    %ecx,%edx
8010045f:	ee                   	out    %al,(%dx)
80100460:	b8 0f 00 00 00       	mov    $0xf,%eax
80100465:	89 f2                	mov    %esi,%edx
80100467:	ee                   	out    %al,(%dx)
80100468:	89 d8                	mov    %ebx,%eax
8010046a:	89 ca                	mov    %ecx,%edx
8010046c:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
8010046d:	66 c7 84 1b 00 80 0b 	movw   $0x720,-0x7ff48000(%ebx,%ebx,1)
80100474:	80 20 07 
}
80100477:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010047a:	5b                   	pop    %ebx
8010047b:	5e                   	pop    %esi
8010047c:	5f                   	pop    %edi
8010047d:	5d                   	pop    %ebp
8010047e:	c3                   	ret    
    pos += 80 - pos%80;
8010047f:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100484:	89 c8                	mov    %ecx,%eax
80100486:	f7 ea                	imul   %edx
80100488:	c1 fa 05             	sar    $0x5,%edx
8010048b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010048e:	c1 e0 04             	shl    $0x4,%eax
80100491:	89 ca                	mov    %ecx,%edx
80100493:	29 c2                	sub    %eax,%edx
80100495:	bb 50 00 00 00       	mov    $0x50,%ebx
8010049a:	29 d3                	sub    %edx,%ebx
8010049c:	01 cb                	add    %ecx,%ebx
8010049e:	eb 96                	jmp    80100436 <cgaputc+0x58>
    if(pos > 0) --pos;
801004a0:	85 c9                	test   %ecx,%ecx
801004a2:	7e 05                	jle    801004a9 <cgaputc+0xcb>
801004a4:	8d 59 ff             	lea    -0x1(%ecx),%ebx
801004a7:	eb 8d                	jmp    80100436 <cgaputc+0x58>
  pos |= inb(CRTPORT+1);
801004a9:	89 cb                	mov    %ecx,%ebx
801004ab:	eb 89                	jmp    80100436 <cgaputc+0x58>
    panic("pos under/overflow");
801004ad:	83 ec 0c             	sub    $0xc,%esp
801004b0:	68 c5 66 10 80       	push   $0x801066c5
801004b5:	e8 a2 fe ff ff       	call   8010035c <panic>
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004ba:	83 ec 04             	sub    $0x4,%esp
801004bd:	68 60 0e 00 00       	push   $0xe60
801004c2:	68 a0 80 0b 80       	push   $0x800b80a0
801004c7:	68 00 80 0b 80       	push   $0x800b8000
801004cc:	e8 32 39 00 00       	call   80103e03 <memmove>
    pos -= 80;
801004d1:	83 eb 50             	sub    $0x50,%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004d4:	b8 80 07 00 00       	mov    $0x780,%eax
801004d9:	29 d8                	sub    %ebx,%eax
801004db:	8d 94 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%edx
801004e2:	83 c4 0c             	add    $0xc,%esp
801004e5:	01 c0                	add    %eax,%eax
801004e7:	50                   	push   %eax
801004e8:	6a 00                	push   $0x0
801004ea:	52                   	push   %edx
801004eb:	e8 93 38 00 00       	call   80103d83 <memset>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 4e ff ff ff       	jmp    80100446 <cgaputc+0x68>

801004f8 <consputc>:
  if(panicked){
801004f8:	83 3d 58 a5 10 80 00 	cmpl   $0x0,0x8010a558
801004ff:	74 03                	je     80100504 <consputc+0xc>
  asm volatile("cli");
80100501:	fa                   	cli    
    for(;;)
80100502:	eb fe                	jmp    80100502 <consputc+0xa>
{
80100504:	55                   	push   %ebp
80100505:	89 e5                	mov    %esp,%ebp
80100507:	53                   	push   %ebx
80100508:	83 ec 04             	sub    $0x4,%esp
8010050b:	89 c3                	mov    %eax,%ebx
  if(c == BACKSPACE){
8010050d:	3d 00 01 00 00       	cmp    $0x100,%eax
80100512:	74 18                	je     8010052c <consputc+0x34>
    uartputc(c);
80100514:	83 ec 0c             	sub    $0xc,%esp
80100517:	50                   	push   %eax
80100518:	e8 0a 4d 00 00       	call   80105227 <uartputc>
8010051d:	83 c4 10             	add    $0x10,%esp
  cgaputc(c);
80100520:	89 d8                	mov    %ebx,%eax
80100522:	e8 b7 fe ff ff       	call   801003de <cgaputc>
}
80100527:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010052a:	c9                   	leave  
8010052b:	c3                   	ret    
    uartputc('\b'); uartputc(' '); uartputc('\b');
8010052c:	83 ec 0c             	sub    $0xc,%esp
8010052f:	6a 08                	push   $0x8
80100531:	e8 f1 4c 00 00       	call   80105227 <uartputc>
80100536:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
8010053d:	e8 e5 4c 00 00       	call   80105227 <uartputc>
80100542:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
80100549:	e8 d9 4c 00 00       	call   80105227 <uartputc>
8010054e:	83 c4 10             	add    $0x10,%esp
80100551:	eb cd                	jmp    80100520 <consputc+0x28>

80100553 <printint>:
{
80100553:	55                   	push   %ebp
80100554:	89 e5                	mov    %esp,%ebp
80100556:	57                   	push   %edi
80100557:	56                   	push   %esi
80100558:	53                   	push   %ebx
80100559:	83 ec 2c             	sub    $0x2c,%esp
8010055c:	89 d6                	mov    %edx,%esi
8010055e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  if(sign && (sign = xx < 0))
80100561:	85 c9                	test   %ecx,%ecx
80100563:	74 0c                	je     80100571 <printint+0x1e>
80100565:	89 c7                	mov    %eax,%edi
80100567:	c1 ef 1f             	shr    $0x1f,%edi
8010056a:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010056d:	85 c0                	test   %eax,%eax
8010056f:	78 38                	js     801005a9 <printint+0x56>
    x = xx;
80100571:	89 c1                	mov    %eax,%ecx
  i = 0;
80100573:	bb 00 00 00 00       	mov    $0x0,%ebx
    buf[i++] = digits[x % base];
80100578:	89 c8                	mov    %ecx,%eax
8010057a:	ba 00 00 00 00       	mov    $0x0,%edx
8010057f:	f7 f6                	div    %esi
80100581:	89 df                	mov    %ebx,%edi
80100583:	83 c3 01             	add    $0x1,%ebx
80100586:	0f b6 92 f0 66 10 80 	movzbl -0x7fef9910(%edx),%edx
8010058d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
80100591:	89 ca                	mov    %ecx,%edx
80100593:	89 c1                	mov    %eax,%ecx
80100595:	39 d6                	cmp    %edx,%esi
80100597:	76 df                	jbe    80100578 <printint+0x25>
  if(sign)
80100599:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
8010059d:	74 1a                	je     801005b9 <printint+0x66>
    buf[i++] = '-';
8010059f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
801005a4:	8d 5f 02             	lea    0x2(%edi),%ebx
801005a7:	eb 10                	jmp    801005b9 <printint+0x66>
    x = -xx;
801005a9:	f7 d8                	neg    %eax
801005ab:	89 c1                	mov    %eax,%ecx
801005ad:	eb c4                	jmp    80100573 <printint+0x20>
    consputc(buf[i]);
801005af:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
801005b4:	e8 3f ff ff ff       	call   801004f8 <consputc>
  while(--i >= 0)
801005b9:	83 eb 01             	sub    $0x1,%ebx
801005bc:	79 f1                	jns    801005af <printint+0x5c>
}
801005be:	83 c4 2c             	add    $0x2c,%esp
801005c1:	5b                   	pop    %ebx
801005c2:	5e                   	pop    %esi
801005c3:	5f                   	pop    %edi
801005c4:	5d                   	pop    %ebp
801005c5:	c3                   	ret    

801005c6 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005c6:	f3 0f 1e fb          	endbr32 
801005ca:	55                   	push   %ebp
801005cb:	89 e5                	mov    %esp,%ebp
801005cd:	57                   	push   %edi
801005ce:	56                   	push   %esi
801005cf:	53                   	push   %ebx
801005d0:	83 ec 18             	sub    $0x18,%esp
801005d3:	8b 7d 0c             	mov    0xc(%ebp),%edi
801005d6:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005d9:	ff 75 08             	pushl  0x8(%ebp)
801005dc:	e8 af 10 00 00       	call   80101690 <iunlock>
  acquire(&cons.lock);
801005e1:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801005e8:	e8 e2 36 00 00       	call   80103ccf <acquire>
  for(i = 0; i < n; i++)
801005ed:	83 c4 10             	add    $0x10,%esp
801005f0:	bb 00 00 00 00       	mov    $0x0,%ebx
801005f5:	39 f3                	cmp    %esi,%ebx
801005f7:	7d 0e                	jge    80100607 <consolewrite+0x41>
    consputc(buf[i] & 0xff);
801005f9:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801005fd:	e8 f6 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; i < n; i++)
80100602:	83 c3 01             	add    $0x1,%ebx
80100605:	eb ee                	jmp    801005f5 <consolewrite+0x2f>
  release(&cons.lock);
80100607:	83 ec 0c             	sub    $0xc,%esp
8010060a:	68 20 a5 10 80       	push   $0x8010a520
8010060f:	e8 24 37 00 00       	call   80103d38 <release>
  ilock(ip);
80100614:	83 c4 04             	add    $0x4,%esp
80100617:	ff 75 08             	pushl  0x8(%ebp)
8010061a:	e8 ab 0f 00 00       	call   801015ca <ilock>

  return n;
}
8010061f:	89 f0                	mov    %esi,%eax
80100621:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100624:	5b                   	pop    %ebx
80100625:	5e                   	pop    %esi
80100626:	5f                   	pop    %edi
80100627:	5d                   	pop    %ebp
80100628:	c3                   	ret    

80100629 <cprintf>:
{
80100629:	f3 0f 1e fb          	endbr32 
8010062d:	55                   	push   %ebp
8010062e:	89 e5                	mov    %esp,%ebp
80100630:	57                   	push   %edi
80100631:	56                   	push   %esi
80100632:	53                   	push   %ebx
80100633:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
80100636:	a1 54 a5 10 80       	mov    0x8010a554,%eax
8010063b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
8010063e:	85 c0                	test   %eax,%eax
80100640:	75 10                	jne    80100652 <cprintf+0x29>
  if (fmt == 0)
80100642:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
80100646:	74 1c                	je     80100664 <cprintf+0x3b>
  argp = (uint*)(void*)(&fmt + 1);
80100648:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010064b:	be 00 00 00 00       	mov    $0x0,%esi
80100650:	eb 27                	jmp    80100679 <cprintf+0x50>
    acquire(&cons.lock);
80100652:	83 ec 0c             	sub    $0xc,%esp
80100655:	68 20 a5 10 80       	push   $0x8010a520
8010065a:	e8 70 36 00 00       	call   80103ccf <acquire>
8010065f:	83 c4 10             	add    $0x10,%esp
80100662:	eb de                	jmp    80100642 <cprintf+0x19>
    panic("null fmt");
80100664:	83 ec 0c             	sub    $0xc,%esp
80100667:	68 df 66 10 80       	push   $0x801066df
8010066c:	e8 eb fc ff ff       	call   8010035c <panic>
      consputc(c);
80100671:	e8 82 fe ff ff       	call   801004f8 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	83 c6 01             	add    $0x1,%esi
80100679:	8b 55 08             	mov    0x8(%ebp),%edx
8010067c:	0f b6 04 32          	movzbl (%edx,%esi,1),%eax
80100680:	85 c0                	test   %eax,%eax
80100682:	0f 84 b1 00 00 00    	je     80100739 <cprintf+0x110>
    if(c != '%'){
80100688:	83 f8 25             	cmp    $0x25,%eax
8010068b:	75 e4                	jne    80100671 <cprintf+0x48>
    c = fmt[++i] & 0xff;
8010068d:	83 c6 01             	add    $0x1,%esi
80100690:	0f b6 1c 32          	movzbl (%edx,%esi,1),%ebx
    if(c == 0)
80100694:	85 db                	test   %ebx,%ebx
80100696:	0f 84 9d 00 00 00    	je     80100739 <cprintf+0x110>
    switch(c){
8010069c:	83 fb 70             	cmp    $0x70,%ebx
8010069f:	74 2e                	je     801006cf <cprintf+0xa6>
801006a1:	7f 22                	jg     801006c5 <cprintf+0x9c>
801006a3:	83 fb 25             	cmp    $0x25,%ebx
801006a6:	74 6c                	je     80100714 <cprintf+0xeb>
801006a8:	83 fb 64             	cmp    $0x64,%ebx
801006ab:	75 76                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 10, 1);
801006ad:	8d 5f 04             	lea    0x4(%edi),%ebx
801006b0:	8b 07                	mov    (%edi),%eax
801006b2:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b7:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bc:	e8 92 fe ff ff       	call   80100553 <printint>
801006c1:	89 df                	mov    %ebx,%edi
      break;
801006c3:	eb b1                	jmp    80100676 <cprintf+0x4d>
    switch(c){
801006c5:	83 fb 73             	cmp    $0x73,%ebx
801006c8:	74 1d                	je     801006e7 <cprintf+0xbe>
801006ca:	83 fb 78             	cmp    $0x78,%ebx
801006cd:	75 54                	jne    80100723 <cprintf+0xfa>
      printint(*argp++, 16, 0);
801006cf:	8d 5f 04             	lea    0x4(%edi),%ebx
801006d2:	8b 07                	mov    (%edi),%eax
801006d4:	b9 00 00 00 00       	mov    $0x0,%ecx
801006d9:	ba 10 00 00 00       	mov    $0x10,%edx
801006de:	e8 70 fe ff ff       	call   80100553 <printint>
801006e3:	89 df                	mov    %ebx,%edi
      break;
801006e5:	eb 8f                	jmp    80100676 <cprintf+0x4d>
      if((s = (char*)*argp++) == 0)
801006e7:	8d 47 04             	lea    0x4(%edi),%eax
801006ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006ed:	8b 1f                	mov    (%edi),%ebx
801006ef:	85 db                	test   %ebx,%ebx
801006f1:	75 05                	jne    801006f8 <cprintf+0xcf>
        s = "(null)";
801006f3:	bb d8 66 10 80       	mov    $0x801066d8,%ebx
      for(; *s; s++)
801006f8:	0f b6 03             	movzbl (%ebx),%eax
801006fb:	84 c0                	test   %al,%al
801006fd:	74 0d                	je     8010070c <cprintf+0xe3>
        consputc(*s);
801006ff:	0f be c0             	movsbl %al,%eax
80100702:	e8 f1 fd ff ff       	call   801004f8 <consputc>
      for(; *s; s++)
80100707:	83 c3 01             	add    $0x1,%ebx
8010070a:	eb ec                	jmp    801006f8 <cprintf+0xcf>
      if((s = (char*)*argp++) == 0)
8010070c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010070f:	e9 62 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100714:	b8 25 00 00 00       	mov    $0x25,%eax
80100719:	e8 da fd ff ff       	call   801004f8 <consputc>
      break;
8010071e:	e9 53 ff ff ff       	jmp    80100676 <cprintf+0x4d>
      consputc('%');
80100723:	b8 25 00 00 00       	mov    $0x25,%eax
80100728:	e8 cb fd ff ff       	call   801004f8 <consputc>
      consputc(c);
8010072d:	89 d8                	mov    %ebx,%eax
8010072f:	e8 c4 fd ff ff       	call   801004f8 <consputc>
      break;
80100734:	e9 3d ff ff ff       	jmp    80100676 <cprintf+0x4d>
  if(locking)
80100739:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010073d:	75 08                	jne    80100747 <cprintf+0x11e>
}
8010073f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100742:	5b                   	pop    %ebx
80100743:	5e                   	pop    %esi
80100744:	5f                   	pop    %edi
80100745:	5d                   	pop    %ebp
80100746:	c3                   	ret    
    release(&cons.lock);
80100747:	83 ec 0c             	sub    $0xc,%esp
8010074a:	68 20 a5 10 80       	push   $0x8010a520
8010074f:	e8 e4 35 00 00       	call   80103d38 <release>
80100754:	83 c4 10             	add    $0x10,%esp
}
80100757:	eb e6                	jmp    8010073f <cprintf+0x116>

80100759 <consoleintr>:
{
80100759:	f3 0f 1e fb          	endbr32 
8010075d:	55                   	push   %ebp
8010075e:	89 e5                	mov    %esp,%ebp
80100760:	57                   	push   %edi
80100761:	56                   	push   %esi
80100762:	53                   	push   %ebx
80100763:	83 ec 18             	sub    $0x18,%esp
80100766:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&cons.lock);
80100769:	68 20 a5 10 80       	push   $0x8010a520
8010076e:	e8 5c 35 00 00       	call   80103ccf <acquire>
  while((c = getc()) >= 0){
80100773:	83 c4 10             	add    $0x10,%esp
  int c, doprocdump = 0;
80100776:	be 00 00 00 00       	mov    $0x0,%esi
  while((c = getc()) >= 0){
8010077b:	eb 13                	jmp    80100790 <consoleintr+0x37>
    switch(c){
8010077d:	83 ff 08             	cmp    $0x8,%edi
80100780:	0f 84 d9 00 00 00    	je     8010085f <consoleintr+0x106>
80100786:	83 ff 10             	cmp    $0x10,%edi
80100789:	75 25                	jne    801007b0 <consoleintr+0x57>
8010078b:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
80100790:	ff d3                	call   *%ebx
80100792:	89 c7                	mov    %eax,%edi
80100794:	85 c0                	test   %eax,%eax
80100796:	0f 88 f5 00 00 00    	js     80100891 <consoleintr+0x138>
    switch(c){
8010079c:	83 ff 15             	cmp    $0x15,%edi
8010079f:	0f 84 93 00 00 00    	je     80100838 <consoleintr+0xdf>
801007a5:	7e d6                	jle    8010077d <consoleintr+0x24>
801007a7:	83 ff 7f             	cmp    $0x7f,%edi
801007aa:	0f 84 af 00 00 00    	je     8010085f <consoleintr+0x106>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801007b0:	85 ff                	test   %edi,%edi
801007b2:	74 dc                	je     80100790 <consoleintr+0x37>
801007b4:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007b9:	89 c2                	mov    %eax,%edx
801007bb:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
801007c1:	83 fa 7f             	cmp    $0x7f,%edx
801007c4:	77 ca                	ja     80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
801007c6:	83 ff 0d             	cmp    $0xd,%edi
801007c9:	0f 84 b8 00 00 00    	je     80100887 <consoleintr+0x12e>
        input.buf[input.e++ % INPUT_BUF] = c;
801007cf:	8d 50 01             	lea    0x1(%eax),%edx
801007d2:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
801007d8:	83 e0 7f             	and    $0x7f,%eax
801007db:	89 f9                	mov    %edi,%ecx
801007dd:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
801007e3:	89 f8                	mov    %edi,%eax
801007e5:	e8 0e fd ff ff       	call   801004f8 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801007ea:	83 ff 0a             	cmp    $0xa,%edi
801007ed:	0f 94 c2             	sete   %dl
801007f0:	83 ff 04             	cmp    $0x4,%edi
801007f3:	0f 94 c0             	sete   %al
801007f6:	08 c2                	or     %al,%dl
801007f8:	75 10                	jne    8010080a <consoleintr+0xb1>
801007fa:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801007ff:	83 e8 80             	sub    $0xffffff80,%eax
80100802:	39 05 a8 ff 10 80    	cmp    %eax,0x8010ffa8
80100808:	75 86                	jne    80100790 <consoleintr+0x37>
          input.w = input.e;
8010080a:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010080f:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
80100814:	83 ec 0c             	sub    $0xc,%esp
80100817:	68 a0 ff 10 80       	push   $0x8010ffa0
8010081c:	e8 e3 30 00 00       	call   80103904 <wakeup>
80100821:	83 c4 10             	add    $0x10,%esp
80100824:	e9 67 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        input.e--;
80100829:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
8010082e:	b8 00 01 00 00       	mov    $0x100,%eax
80100833:	e8 c0 fc ff ff       	call   801004f8 <consputc>
      while(input.e != input.w &&
80100838:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010083d:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
80100843:	0f 84 47 ff ff ff    	je     80100790 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100849:	83 e8 01             	sub    $0x1,%eax
8010084c:	89 c2                	mov    %eax,%edx
8010084e:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100851:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100858:	75 cf                	jne    80100829 <consoleintr+0xd0>
8010085a:	e9 31 ff ff ff       	jmp    80100790 <consoleintr+0x37>
      if(input.e != input.w){
8010085f:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100864:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
8010086a:	0f 84 20 ff ff ff    	je     80100790 <consoleintr+0x37>
        input.e--;
80100870:	83 e8 01             	sub    $0x1,%eax
80100873:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100878:	b8 00 01 00 00       	mov    $0x100,%eax
8010087d:	e8 76 fc ff ff       	call   801004f8 <consputc>
80100882:	e9 09 ff ff ff       	jmp    80100790 <consoleintr+0x37>
        c = (c == '\r') ? '\n' : c;
80100887:	bf 0a 00 00 00       	mov    $0xa,%edi
8010088c:	e9 3e ff ff ff       	jmp    801007cf <consoleintr+0x76>
  release(&cons.lock);
80100891:	83 ec 0c             	sub    $0xc,%esp
80100894:	68 20 a5 10 80       	push   $0x8010a520
80100899:	e8 9a 34 00 00       	call   80103d38 <release>
  if(doprocdump) {
8010089e:	83 c4 10             	add    $0x10,%esp
801008a1:	85 f6                	test   %esi,%esi
801008a3:	75 08                	jne    801008ad <consoleintr+0x154>
}
801008a5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801008a8:	5b                   	pop    %ebx
801008a9:	5e                   	pop    %esi
801008aa:	5f                   	pop    %edi
801008ab:	5d                   	pop    %ebp
801008ac:	c3                   	ret    
    procdump();  // now call procdump() wo. cons.lock held
801008ad:	e8 f9 30 00 00       	call   801039ab <procdump>
}
801008b2:	eb f1                	jmp    801008a5 <consoleintr+0x14c>

801008b4 <consoleinit>:

void
consoleinit(void)
{
801008b4:	f3 0f 1e fb          	endbr32 
801008b8:	55                   	push   %ebp
801008b9:	89 e5                	mov    %esp,%ebp
801008bb:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801008be:	68 e8 66 10 80       	push   $0x801066e8
801008c3:	68 20 a5 10 80       	push   $0x8010a520
801008c8:	e8 b2 32 00 00       	call   80103b7f <initlock>

  devsw[CONSOLE].write = consolewrite;
801008cd:	c7 05 6c 09 11 80 c6 	movl   $0x801005c6,0x8011096c
801008d4:	05 10 80 
  devsw[CONSOLE].read = consoleread;
801008d7:	c7 05 68 09 11 80 78 	movl   $0x80100278,0x80110968
801008de:	02 10 80 
  cons.locking = 1;
801008e1:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
801008e8:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801008eb:	83 c4 08             	add    $0x8,%esp
801008ee:	6a 00                	push   $0x0
801008f0:	6a 01                	push   $0x1
801008f2:	e8 04 17 00 00       	call   80101ffb <ioapicenable>
}
801008f7:	83 c4 10             	add    $0x10,%esp
801008fa:	c9                   	leave  
801008fb:	c3                   	ret    

801008fc <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801008fc:	f3 0f 1e fb          	endbr32 
80100900:	55                   	push   %ebp
80100901:	89 e5                	mov    %esp,%ebp
80100903:	57                   	push   %edi
80100904:	56                   	push   %esi
80100905:	53                   	push   %ebx
80100906:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
8010090c:	e8 ba 29 00 00       	call   801032cb <myproc>
80100911:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100917:	e8 33 1f 00 00       	call   8010284f <begin_op>

  if((ip = namei(path)) == 0){
8010091c:	83 ec 0c             	sub    $0xc,%esp
8010091f:	ff 75 08             	pushl  0x8(%ebp)
80100922:	e8 28 13 00 00       	call   80101c4f <namei>
80100927:	83 c4 10             	add    $0x10,%esp
8010092a:	85 c0                	test   %eax,%eax
8010092c:	74 56                	je     80100984 <exec+0x88>
8010092e:	89 c3                	mov    %eax,%ebx
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100930:	83 ec 0c             	sub    $0xc,%esp
80100933:	50                   	push   %eax
80100934:	e8 91 0c 00 00       	call   801015ca <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100939:	6a 34                	push   $0x34
8010093b:	6a 00                	push   $0x0
8010093d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100943:	50                   	push   %eax
80100944:	53                   	push   %ebx
80100945:	e8 86 0e 00 00       	call   801017d0 <readi>
8010094a:	83 c4 20             	add    $0x20,%esp
8010094d:	83 f8 34             	cmp    $0x34,%eax
80100950:	75 0c                	jne    8010095e <exec+0x62>
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100952:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100959:	45 4c 46 
8010095c:	74 42                	je     801009a0 <exec+0xa4>
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
8010095e:	85 db                	test   %ebx,%ebx
80100960:	0f 84 c9 02 00 00    	je     80100c2f <exec+0x333>
    iunlockput(ip);
80100966:	83 ec 0c             	sub    $0xc,%esp
80100969:	53                   	push   %ebx
8010096a:	e8 0e 0e 00 00       	call   8010177d <iunlockput>
    end_op();
8010096f:	e8 59 1f 00 00       	call   801028cd <end_op>
80100974:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100977:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010097c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010097f:	5b                   	pop    %ebx
80100980:	5e                   	pop    %esi
80100981:	5f                   	pop    %edi
80100982:	5d                   	pop    %ebp
80100983:	c3                   	ret    
    end_op();
80100984:	e8 44 1f 00 00       	call   801028cd <end_op>
    cprintf("exec: fail\n");
80100989:	83 ec 0c             	sub    $0xc,%esp
8010098c:	68 01 67 10 80       	push   $0x80106701
80100991:	e8 93 fc ff ff       	call   80100629 <cprintf>
    return -1;
80100996:	83 c4 10             	add    $0x10,%esp
80100999:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010099e:	eb dc                	jmp    8010097c <exec+0x80>
  if((pgdir = setupkvm()) == 0)
801009a0:	e8 64 5a 00 00       	call   80106409 <setupkvm>
801009a5:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
801009ab:	85 c0                	test   %eax,%eax
801009ad:	0f 84 09 01 00 00    	je     80100abc <exec+0x1c0>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009b3:	8b 85 40 ff ff ff    	mov    -0xc0(%ebp),%eax
  sz = 0;
801009b9:	bf 00 00 00 00       	mov    $0x0,%edi
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
801009be:	be 00 00 00 00       	mov    $0x0,%esi
801009c3:	eb 0c                	jmp    801009d1 <exec+0xd5>
801009c5:	83 c6 01             	add    $0x1,%esi
801009c8:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
801009ce:	83 c0 20             	add    $0x20,%eax
801009d1:	0f b7 95 50 ff ff ff 	movzwl -0xb0(%ebp),%edx
801009d8:	39 f2                	cmp    %esi,%edx
801009da:	0f 8e 98 00 00 00    	jle    80100a78 <exec+0x17c>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
801009e0:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
801009e6:	6a 20                	push   $0x20
801009e8:	50                   	push   %eax
801009e9:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
801009ef:	50                   	push   %eax
801009f0:	53                   	push   %ebx
801009f1:	e8 da 0d 00 00       	call   801017d0 <readi>
801009f6:	83 c4 10             	add    $0x10,%esp
801009f9:	83 f8 20             	cmp    $0x20,%eax
801009fc:	0f 85 ba 00 00 00    	jne    80100abc <exec+0x1c0>
    if(ph.type != ELF_PROG_LOAD)
80100a02:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100a09:	75 ba                	jne    801009c5 <exec+0xc9>
    if(ph.memsz < ph.filesz)
80100a0b:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100a11:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100a17:	0f 82 9f 00 00 00    	jb     80100abc <exec+0x1c0>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100a1d:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100a23:	0f 82 93 00 00 00    	jb     80100abc <exec+0x1c0>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100a29:	83 ec 04             	sub    $0x4,%esp
80100a2c:	50                   	push   %eax
80100a2d:	57                   	push   %edi
80100a2e:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a34:	e8 6f 58 00 00       	call   801062a8 <allocuvm>
80100a39:	89 c7                	mov    %eax,%edi
80100a3b:	83 c4 10             	add    $0x10,%esp
80100a3e:	85 c0                	test   %eax,%eax
80100a40:	74 7a                	je     80100abc <exec+0x1c0>
    if(ph.vaddr % PGSIZE != 0)
80100a42:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100a48:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100a4d:	75 6d                	jne    80100abc <exec+0x1c0>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100a4f:	83 ec 0c             	sub    $0xc,%esp
80100a52:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100a58:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100a5e:	53                   	push   %ebx
80100a5f:	50                   	push   %eax
80100a60:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100a66:	e8 08 57 00 00       	call   80106173 <loaduvm>
80100a6b:	83 c4 20             	add    $0x20,%esp
80100a6e:	85 c0                	test   %eax,%eax
80100a70:	0f 89 4f ff ff ff    	jns    801009c5 <exec+0xc9>
80100a76:	eb 44                	jmp    80100abc <exec+0x1c0>
  iunlockput(ip);
80100a78:	83 ec 0c             	sub    $0xc,%esp
80100a7b:	53                   	push   %ebx
80100a7c:	e8 fc 0c 00 00       	call   8010177d <iunlockput>
  end_op();
80100a81:	e8 47 1e 00 00       	call   801028cd <end_op>
  sz = PGROUNDUP(sz);
80100a86:	8d 87 ff 0f 00 00    	lea    0xfff(%edi),%eax
80100a8c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100a91:	83 c4 0c             	add    $0xc,%esp
80100a94:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100a9a:	52                   	push   %edx
80100a9b:	50                   	push   %eax
80100a9c:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100aa2:	57                   	push   %edi
80100aa3:	e8 00 58 00 00       	call   801062a8 <allocuvm>
80100aa8:	89 c6                	mov    %eax,%esi
80100aaa:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100ab0:	83 c4 10             	add    $0x10,%esp
80100ab3:	85 c0                	test   %eax,%eax
80100ab5:	75 24                	jne    80100adb <exec+0x1df>
  ip = 0;
80100ab7:	bb 00 00 00 00       	mov    $0x0,%ebx
  if(pgdir)
80100abc:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100ac2:	85 c0                	test   %eax,%eax
80100ac4:	0f 84 94 fe ff ff    	je     8010095e <exec+0x62>
    freevm(pgdir);
80100aca:	83 ec 0c             	sub    $0xc,%esp
80100acd:	50                   	push   %eax
80100ace:	e8 c2 58 00 00       	call   80106395 <freevm>
80100ad3:	83 c4 10             	add    $0x10,%esp
80100ad6:	e9 83 fe ff ff       	jmp    8010095e <exec+0x62>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100adb:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100ae1:	83 ec 08             	sub    $0x8,%esp
80100ae4:	50                   	push   %eax
80100ae5:	57                   	push   %edi
80100ae6:	e8 ab 59 00 00       	call   80106496 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100aeb:	83 c4 10             	add    $0x10,%esp
80100aee:	bf 00 00 00 00       	mov    $0x0,%edi
80100af3:	8b 45 0c             	mov    0xc(%ebp),%eax
80100af6:	8d 1c b8             	lea    (%eax,%edi,4),%ebx
80100af9:	8b 03                	mov    (%ebx),%eax
80100afb:	85 c0                	test   %eax,%eax
80100afd:	74 4d                	je     80100b4c <exec+0x250>
    if(argc >= MAXARG)
80100aff:	83 ff 1f             	cmp    $0x1f,%edi
80100b02:	0f 87 13 01 00 00    	ja     80100c1b <exec+0x31f>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100b08:	83 ec 0c             	sub    $0xc,%esp
80100b0b:	50                   	push   %eax
80100b0c:	e8 33 34 00 00       	call   80103f44 <strlen>
80100b11:	29 c6                	sub    %eax,%esi
80100b13:	83 ee 01             	sub    $0x1,%esi
80100b16:	83 e6 fc             	and    $0xfffffffc,%esi
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100b19:	83 c4 04             	add    $0x4,%esp
80100b1c:	ff 33                	pushl  (%ebx)
80100b1e:	e8 21 34 00 00       	call   80103f44 <strlen>
80100b23:	83 c0 01             	add    $0x1,%eax
80100b26:	50                   	push   %eax
80100b27:	ff 33                	pushl  (%ebx)
80100b29:	56                   	push   %esi
80100b2a:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b30:	e8 bb 5a 00 00       	call   801065f0 <copyout>
80100b35:	83 c4 20             	add    $0x20,%esp
80100b38:	85 c0                	test   %eax,%eax
80100b3a:	0f 88 e5 00 00 00    	js     80100c25 <exec+0x329>
    ustack[3+argc] = sp;
80100b40:	89 b4 bd 64 ff ff ff 	mov    %esi,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100b47:	83 c7 01             	add    $0x1,%edi
80100b4a:	eb a7                	jmp    80100af3 <exec+0x1f7>
80100b4c:	89 f1                	mov    %esi,%ecx
80100b4e:	89 c3                	mov    %eax,%ebx
  ustack[3+argc] = 0;
80100b50:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100b57:	00 00 00 00 
  ustack[0] = 0xffffffff;  // fake return PC
80100b5b:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100b62:	ff ff ff 
  ustack[1] = argc;
80100b65:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100b6b:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100b72:	89 f2                	mov    %esi,%edx
80100b74:	29 c2                	sub    %eax,%edx
80100b76:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)
  sp -= (3+argc+1) * 4;
80100b7c:	8d 04 bd 10 00 00 00 	lea    0x10(,%edi,4),%eax
80100b83:	29 c1                	sub    %eax,%ecx
80100b85:	89 ce                	mov    %ecx,%esi
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100b87:	50                   	push   %eax
80100b88:	8d 85 58 ff ff ff    	lea    -0xa8(%ebp),%eax
80100b8e:	50                   	push   %eax
80100b8f:	51                   	push   %ecx
80100b90:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b96:	e8 55 5a 00 00       	call   801065f0 <copyout>
80100b9b:	83 c4 10             	add    $0x10,%esp
80100b9e:	85 c0                	test   %eax,%eax
80100ba0:	0f 88 16 ff ff ff    	js     80100abc <exec+0x1c0>
  for(last=s=path; *s; s++)
80100ba6:	8b 55 08             	mov    0x8(%ebp),%edx
80100ba9:	89 d0                	mov    %edx,%eax
80100bab:	eb 03                	jmp    80100bb0 <exec+0x2b4>
80100bad:	83 c0 01             	add    $0x1,%eax
80100bb0:	0f b6 08             	movzbl (%eax),%ecx
80100bb3:	84 c9                	test   %cl,%cl
80100bb5:	74 0a                	je     80100bc1 <exec+0x2c5>
    if(*s == '/')
80100bb7:	80 f9 2f             	cmp    $0x2f,%cl
80100bba:	75 f1                	jne    80100bad <exec+0x2b1>
      last = s+1;
80100bbc:	8d 50 01             	lea    0x1(%eax),%edx
80100bbf:	eb ec                	jmp    80100bad <exec+0x2b1>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100bc1:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100bc7:	89 f8                	mov    %edi,%eax
80100bc9:	83 c0 6c             	add    $0x6c,%eax
80100bcc:	83 ec 04             	sub    $0x4,%esp
80100bcf:	6a 10                	push   $0x10
80100bd1:	52                   	push   %edx
80100bd2:	50                   	push   %eax
80100bd3:	e8 2b 33 00 00       	call   80103f03 <safestrcpy>
  oldpgdir = curproc->pgdir;
80100bd8:	8b 5f 04             	mov    0x4(%edi),%ebx
  curproc->pgdir = pgdir;
80100bdb:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
80100be1:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100be4:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
80100bea:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100bec:	8b 47 18             	mov    0x18(%edi),%eax
80100bef:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100bf5:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100bf8:	8b 47 18             	mov    0x18(%edi),%eax
80100bfb:	89 70 44             	mov    %esi,0x44(%eax)
  switchuvm(curproc);
80100bfe:	89 3c 24             	mov    %edi,(%esp)
80100c01:	e8 e4 53 00 00       	call   80105fea <switchuvm>
  freevm(oldpgdir);
80100c06:	89 1c 24             	mov    %ebx,(%esp)
80100c09:	e8 87 57 00 00       	call   80106395 <freevm>
  return 0;
80100c0e:	83 c4 10             	add    $0x10,%esp
80100c11:	b8 00 00 00 00       	mov    $0x0,%eax
80100c16:	e9 61 fd ff ff       	jmp    8010097c <exec+0x80>
  ip = 0;
80100c1b:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c20:	e9 97 fe ff ff       	jmp    80100abc <exec+0x1c0>
80100c25:	bb 00 00 00 00       	mov    $0x0,%ebx
80100c2a:	e9 8d fe ff ff       	jmp    80100abc <exec+0x1c0>
  return -1;
80100c2f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100c34:	e9 43 fd ff ff       	jmp    8010097c <exec+0x80>

80100c39 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100c39:	f3 0f 1e fb          	endbr32 
80100c3d:	55                   	push   %ebp
80100c3e:	89 e5                	mov    %esp,%ebp
80100c40:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100c43:	68 0d 67 10 80       	push   $0x8010670d
80100c48:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c4d:	e8 2d 2f 00 00       	call   80103b7f <initlock>
}
80100c52:	83 c4 10             	add    $0x10,%esp
80100c55:	c9                   	leave  
80100c56:	c3                   	ret    

80100c57 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100c57:	f3 0f 1e fb          	endbr32 
80100c5b:	55                   	push   %ebp
80100c5c:	89 e5                	mov    %esp,%ebp
80100c5e:	53                   	push   %ebx
80100c5f:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100c62:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c67:	e8 63 30 00 00       	call   80103ccf <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100c6c:	83 c4 10             	add    $0x10,%esp
80100c6f:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
80100c74:	eb 03                	jmp    80100c79 <filealloc+0x22>
80100c76:	83 c3 18             	add    $0x18,%ebx
80100c79:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100c7f:	73 24                	jae    80100ca5 <filealloc+0x4e>
    if(f->ref == 0){
80100c81:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80100c85:	75 ef                	jne    80100c76 <filealloc+0x1f>
      f->ref = 1;
80100c87:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100c8e:	83 ec 0c             	sub    $0xc,%esp
80100c91:	68 c0 ff 10 80       	push   $0x8010ffc0
80100c96:	e8 9d 30 00 00       	call   80103d38 <release>
      return f;
80100c9b:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100c9e:	89 d8                	mov    %ebx,%eax
80100ca0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100ca3:	c9                   	leave  
80100ca4:	c3                   	ret    
  release(&ftable.lock);
80100ca5:	83 ec 0c             	sub    $0xc,%esp
80100ca8:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cad:	e8 86 30 00 00       	call   80103d38 <release>
  return 0;
80100cb2:	83 c4 10             	add    $0x10,%esp
80100cb5:	bb 00 00 00 00       	mov    $0x0,%ebx
80100cba:	eb e2                	jmp    80100c9e <filealloc+0x47>

80100cbc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100cbc:	f3 0f 1e fb          	endbr32 
80100cc0:	55                   	push   %ebp
80100cc1:	89 e5                	mov    %esp,%ebp
80100cc3:	53                   	push   %ebx
80100cc4:	83 ec 10             	sub    $0x10,%esp
80100cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100cca:	68 c0 ff 10 80       	push   $0x8010ffc0
80100ccf:	e8 fb 2f 00 00       	call   80103ccf <acquire>
  if(f->ref < 1)
80100cd4:	8b 43 04             	mov    0x4(%ebx),%eax
80100cd7:	83 c4 10             	add    $0x10,%esp
80100cda:	85 c0                	test   %eax,%eax
80100cdc:	7e 1a                	jle    80100cf8 <filedup+0x3c>
    panic("filedup");
  f->ref++;
80100cde:	83 c0 01             	add    $0x1,%eax
80100ce1:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100ce4:	83 ec 0c             	sub    $0xc,%esp
80100ce7:	68 c0 ff 10 80       	push   $0x8010ffc0
80100cec:	e8 47 30 00 00       	call   80103d38 <release>
  return f;
}
80100cf1:	89 d8                	mov    %ebx,%eax
80100cf3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100cf6:	c9                   	leave  
80100cf7:	c3                   	ret    
    panic("filedup");
80100cf8:	83 ec 0c             	sub    $0xc,%esp
80100cfb:	68 14 67 10 80       	push   $0x80106714
80100d00:	e8 57 f6 ff ff       	call   8010035c <panic>

80100d05 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100d05:	f3 0f 1e fb          	endbr32 
80100d09:	55                   	push   %ebp
80100d0a:	89 e5                	mov    %esp,%ebp
80100d0c:	53                   	push   %ebx
80100d0d:	83 ec 30             	sub    $0x30,%esp
80100d10:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100d13:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d18:	e8 b2 2f 00 00       	call   80103ccf <acquire>
  if(f->ref < 1)
80100d1d:	8b 43 04             	mov    0x4(%ebx),%eax
80100d20:	83 c4 10             	add    $0x10,%esp
80100d23:	85 c0                	test   %eax,%eax
80100d25:	7e 65                	jle    80100d8c <fileclose+0x87>
    panic("fileclose");
  if(--f->ref > 0){
80100d27:	83 e8 01             	sub    $0x1,%eax
80100d2a:	89 43 04             	mov    %eax,0x4(%ebx)
80100d2d:	85 c0                	test   %eax,%eax
80100d2f:	7f 68                	jg     80100d99 <fileclose+0x94>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100d31:	8b 03                	mov    (%ebx),%eax
80100d33:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100d36:	8b 43 08             	mov    0x8(%ebx),%eax
80100d39:	89 45 e8             	mov    %eax,-0x18(%ebp)
80100d3c:	8b 43 0c             	mov    0xc(%ebx),%eax
80100d3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
80100d42:	8b 43 10             	mov    0x10(%ebx),%eax
80100d45:	89 45 f0             	mov    %eax,-0x10(%ebp)
  f->ref = 0;
80100d48:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  f->type = FD_NONE;
80100d4f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  release(&ftable.lock);
80100d55:	83 ec 0c             	sub    $0xc,%esp
80100d58:	68 c0 ff 10 80       	push   $0x8010ffc0
80100d5d:	e8 d6 2f 00 00       	call   80103d38 <release>

  if(ff.type == FD_PIPE)
80100d62:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	83 f8 01             	cmp    $0x1,%eax
80100d6b:	74 41                	je     80100dae <fileclose+0xa9>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100d6d:	83 f8 02             	cmp    $0x2,%eax
80100d70:	75 37                	jne    80100da9 <fileclose+0xa4>
    begin_op();
80100d72:	e8 d8 1a 00 00       	call   8010284f <begin_op>
    iput(ff.ip);
80100d77:	83 ec 0c             	sub    $0xc,%esp
80100d7a:	ff 75 f0             	pushl  -0x10(%ebp)
80100d7d:	e8 57 09 00 00       	call   801016d9 <iput>
    end_op();
80100d82:	e8 46 1b 00 00       	call   801028cd <end_op>
80100d87:	83 c4 10             	add    $0x10,%esp
80100d8a:	eb 1d                	jmp    80100da9 <fileclose+0xa4>
    panic("fileclose");
80100d8c:	83 ec 0c             	sub    $0xc,%esp
80100d8f:	68 1c 67 10 80       	push   $0x8010671c
80100d94:	e8 c3 f5 ff ff       	call   8010035c <panic>
    release(&ftable.lock);
80100d99:	83 ec 0c             	sub    $0xc,%esp
80100d9c:	68 c0 ff 10 80       	push   $0x8010ffc0
80100da1:	e8 92 2f 00 00       	call   80103d38 <release>
    return;
80100da6:	83 c4 10             	add    $0x10,%esp
  }
}
80100da9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dac:	c9                   	leave  
80100dad:	c3                   	ret    
    pipeclose(ff.pipe, ff.writable);
80100dae:	83 ec 08             	sub    $0x8,%esp
80100db1:	0f be 45 e9          	movsbl -0x17(%ebp),%eax
80100db5:	50                   	push   %eax
80100db6:	ff 75 ec             	pushl  -0x14(%ebp)
80100db9:	e8 24 21 00 00       	call   80102ee2 <pipeclose>
80100dbe:	83 c4 10             	add    $0x10,%esp
80100dc1:	eb e6                	jmp    80100da9 <fileclose+0xa4>

80100dc3 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100dc3:	f3 0f 1e fb          	endbr32 
80100dc7:	55                   	push   %ebp
80100dc8:	89 e5                	mov    %esp,%ebp
80100dca:	53                   	push   %ebx
80100dcb:	83 ec 04             	sub    $0x4,%esp
80100dce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100dd1:	83 3b 02             	cmpl   $0x2,(%ebx)
80100dd4:	75 31                	jne    80100e07 <filestat+0x44>
    ilock(f->ip);
80100dd6:	83 ec 0c             	sub    $0xc,%esp
80100dd9:	ff 73 10             	pushl  0x10(%ebx)
80100ddc:	e8 e9 07 00 00       	call   801015ca <ilock>
    stati(f->ip, st);
80100de1:	83 c4 08             	add    $0x8,%esp
80100de4:	ff 75 0c             	pushl  0xc(%ebp)
80100de7:	ff 73 10             	pushl  0x10(%ebx)
80100dea:	e8 b2 09 00 00       	call   801017a1 <stati>
    iunlock(f->ip);
80100def:	83 c4 04             	add    $0x4,%esp
80100df2:	ff 73 10             	pushl  0x10(%ebx)
80100df5:	e8 96 08 00 00       	call   80101690 <iunlock>
    return 0;
80100dfa:	83 c4 10             	add    $0x10,%esp
80100dfd:	b8 00 00 00 00       	mov    $0x0,%eax
  }
  return -1;
}
80100e02:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e05:	c9                   	leave  
80100e06:	c3                   	ret    
  return -1;
80100e07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e0c:	eb f4                	jmp    80100e02 <filestat+0x3f>

80100e0e <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100e0e:	f3 0f 1e fb          	endbr32 
80100e12:	55                   	push   %ebp
80100e13:	89 e5                	mov    %esp,%ebp
80100e15:	56                   	push   %esi
80100e16:	53                   	push   %ebx
80100e17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;

  if(f->readable == 0)
80100e1a:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100e1e:	74 70                	je     80100e90 <fileread+0x82>
    return -1;
  if(f->type == FD_PIPE)
80100e20:	8b 03                	mov    (%ebx),%eax
80100e22:	83 f8 01             	cmp    $0x1,%eax
80100e25:	74 44                	je     80100e6b <fileread+0x5d>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100e27:	83 f8 02             	cmp    $0x2,%eax
80100e2a:	75 57                	jne    80100e83 <fileread+0x75>
    ilock(f->ip);
80100e2c:	83 ec 0c             	sub    $0xc,%esp
80100e2f:	ff 73 10             	pushl  0x10(%ebx)
80100e32:	e8 93 07 00 00       	call   801015ca <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100e37:	ff 75 10             	pushl  0x10(%ebp)
80100e3a:	ff 73 14             	pushl  0x14(%ebx)
80100e3d:	ff 75 0c             	pushl  0xc(%ebp)
80100e40:	ff 73 10             	pushl  0x10(%ebx)
80100e43:	e8 88 09 00 00       	call   801017d0 <readi>
80100e48:	89 c6                	mov    %eax,%esi
80100e4a:	83 c4 20             	add    $0x20,%esp
80100e4d:	85 c0                	test   %eax,%eax
80100e4f:	7e 03                	jle    80100e54 <fileread+0x46>
      f->off += r;
80100e51:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100e54:	83 ec 0c             	sub    $0xc,%esp
80100e57:	ff 73 10             	pushl  0x10(%ebx)
80100e5a:	e8 31 08 00 00       	call   80101690 <iunlock>
    return r;
80100e5f:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80100e62:	89 f0                	mov    %esi,%eax
80100e64:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5d                   	pop    %ebp
80100e6a:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80100e6b:	83 ec 04             	sub    $0x4,%esp
80100e6e:	ff 75 10             	pushl  0x10(%ebp)
80100e71:	ff 75 0c             	pushl  0xc(%ebp)
80100e74:	ff 73 0c             	pushl  0xc(%ebx)
80100e77:	e8 c0 21 00 00       	call   8010303c <piperead>
80100e7c:	89 c6                	mov    %eax,%esi
80100e7e:	83 c4 10             	add    $0x10,%esp
80100e81:	eb df                	jmp    80100e62 <fileread+0x54>
  panic("fileread");
80100e83:	83 ec 0c             	sub    $0xc,%esp
80100e86:	68 26 67 10 80       	push   $0x80106726
80100e8b:	e8 cc f4 ff ff       	call   8010035c <panic>
    return -1;
80100e90:	be ff ff ff ff       	mov    $0xffffffff,%esi
80100e95:	eb cb                	jmp    80100e62 <fileread+0x54>

80100e97 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100e97:	f3 0f 1e fb          	endbr32 
80100e9b:	55                   	push   %ebp
80100e9c:	89 e5                	mov    %esp,%ebp
80100e9e:	57                   	push   %edi
80100e9f:	56                   	push   %esi
80100ea0:	53                   	push   %ebx
80100ea1:	83 ec 1c             	sub    $0x1c,%esp
80100ea4:	8b 75 08             	mov    0x8(%ebp),%esi
  int r;

  if(f->writable == 0)
80100ea7:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)
80100eab:	0f 84 cc 00 00 00    	je     80100f7d <filewrite+0xe6>
    return -1;
  if(f->type == FD_PIPE)
80100eb1:	8b 06                	mov    (%esi),%eax
80100eb3:	83 f8 01             	cmp    $0x1,%eax
80100eb6:	74 10                	je     80100ec8 <filewrite+0x31>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100eb8:	83 f8 02             	cmp    $0x2,%eax
80100ebb:	0f 85 af 00 00 00    	jne    80100f70 <filewrite+0xd9>
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
80100ec1:	bf 00 00 00 00       	mov    $0x0,%edi
80100ec6:	eb 67                	jmp    80100f2f <filewrite+0x98>
    return pipewrite(f->pipe, addr, n);
80100ec8:	83 ec 04             	sub    $0x4,%esp
80100ecb:	ff 75 10             	pushl  0x10(%ebp)
80100ece:	ff 75 0c             	pushl  0xc(%ebp)
80100ed1:	ff 76 0c             	pushl  0xc(%esi)
80100ed4:	e8 99 20 00 00       	call   80102f72 <pipewrite>
80100ed9:	83 c4 10             	add    $0x10,%esp
80100edc:	e9 82 00 00 00       	jmp    80100f63 <filewrite+0xcc>
    while(i < n){
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
80100ee1:	e8 69 19 00 00       	call   8010284f <begin_op>
      ilock(f->ip);
80100ee6:	83 ec 0c             	sub    $0xc,%esp
80100ee9:	ff 76 10             	pushl  0x10(%esi)
80100eec:	e8 d9 06 00 00       	call   801015ca <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80100ef1:	ff 75 e4             	pushl  -0x1c(%ebp)
80100ef4:	ff 76 14             	pushl  0x14(%esi)
80100ef7:	89 f8                	mov    %edi,%eax
80100ef9:	03 45 0c             	add    0xc(%ebp),%eax
80100efc:	50                   	push   %eax
80100efd:	ff 76 10             	pushl  0x10(%esi)
80100f00:	e8 cc 09 00 00       	call   801018d1 <writei>
80100f05:	89 c3                	mov    %eax,%ebx
80100f07:	83 c4 20             	add    $0x20,%esp
80100f0a:	85 c0                	test   %eax,%eax
80100f0c:	7e 03                	jle    80100f11 <filewrite+0x7a>
        f->off += r;
80100f0e:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
80100f11:	83 ec 0c             	sub    $0xc,%esp
80100f14:	ff 76 10             	pushl  0x10(%esi)
80100f17:	e8 74 07 00 00       	call   80101690 <iunlock>
      end_op();
80100f1c:	e8 ac 19 00 00       	call   801028cd <end_op>

      if(r < 0)
80100f21:	83 c4 10             	add    $0x10,%esp
80100f24:	85 db                	test   %ebx,%ebx
80100f26:	78 31                	js     80100f59 <filewrite+0xc2>
        break;
      if(r != n1)
80100f28:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
80100f2b:	75 1f                	jne    80100f4c <filewrite+0xb5>
        panic("short filewrite");
      i += r;
80100f2d:	01 df                	add    %ebx,%edi
    while(i < n){
80100f2f:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f32:	7d 25                	jge    80100f59 <filewrite+0xc2>
      int n1 = n - i;
80100f34:	8b 45 10             	mov    0x10(%ebp),%eax
80100f37:	29 f8                	sub    %edi,%eax
80100f39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      if(n1 > max)
80100f3c:	3d 00 06 00 00       	cmp    $0x600,%eax
80100f41:	7e 9e                	jle    80100ee1 <filewrite+0x4a>
        n1 = max;
80100f43:	c7 45 e4 00 06 00 00 	movl   $0x600,-0x1c(%ebp)
80100f4a:	eb 95                	jmp    80100ee1 <filewrite+0x4a>
        panic("short filewrite");
80100f4c:	83 ec 0c             	sub    $0xc,%esp
80100f4f:	68 2f 67 10 80       	push   $0x8010672f
80100f54:	e8 03 f4 ff ff       	call   8010035c <panic>
    }
    return i == n ? n : -1;
80100f59:	3b 7d 10             	cmp    0x10(%ebp),%edi
80100f5c:	74 0d                	je     80100f6b <filewrite+0xd4>
80100f5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80100f63:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100f66:	5b                   	pop    %ebx
80100f67:	5e                   	pop    %esi
80100f68:	5f                   	pop    %edi
80100f69:	5d                   	pop    %ebp
80100f6a:	c3                   	ret    
    return i == n ? n : -1;
80100f6b:	8b 45 10             	mov    0x10(%ebp),%eax
80100f6e:	eb f3                	jmp    80100f63 <filewrite+0xcc>
  panic("filewrite");
80100f70:	83 ec 0c             	sub    $0xc,%esp
80100f73:	68 35 67 10 80       	push   $0x80106735
80100f78:	e8 df f3 ff ff       	call   8010035c <panic>
    return -1;
80100f7d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100f82:	eb df                	jmp    80100f63 <filewrite+0xcc>

80100f84 <skipelem>:
//   skipelem("a", name) = "", setting name = "a"
//   skipelem("", name) = skipelem("////", name) = 0
//
static char*
skipelem(char *path, char *name)
{
80100f84:	55                   	push   %ebp
80100f85:	89 e5                	mov    %esp,%ebp
80100f87:	57                   	push   %edi
80100f88:	56                   	push   %esi
80100f89:	53                   	push   %ebx
80100f8a:	83 ec 0c             	sub    $0xc,%esp
80100f8d:	89 d6                	mov    %edx,%esi
  char *s;
  int len;

  while(*path == '/')
80100f8f:	0f b6 10             	movzbl (%eax),%edx
80100f92:	80 fa 2f             	cmp    $0x2f,%dl
80100f95:	75 05                	jne    80100f9c <skipelem+0x18>
    path++;
80100f97:	83 c0 01             	add    $0x1,%eax
80100f9a:	eb f3                	jmp    80100f8f <skipelem+0xb>
  if(*path == 0)
80100f9c:	84 d2                	test   %dl,%dl
80100f9e:	74 59                	je     80100ff9 <skipelem+0x75>
80100fa0:	89 c3                	mov    %eax,%ebx
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80100fa2:	0f b6 13             	movzbl (%ebx),%edx
80100fa5:	80 fa 2f             	cmp    $0x2f,%dl
80100fa8:	0f 95 c1             	setne  %cl
80100fab:	84 d2                	test   %dl,%dl
80100fad:	0f 95 c2             	setne  %dl
80100fb0:	84 d1                	test   %dl,%cl
80100fb2:	74 05                	je     80100fb9 <skipelem+0x35>
    path++;
80100fb4:	83 c3 01             	add    $0x1,%ebx
80100fb7:	eb e9                	jmp    80100fa2 <skipelem+0x1e>
  len = path - s;
80100fb9:	89 df                	mov    %ebx,%edi
80100fbb:	29 c7                	sub    %eax,%edi
  if(len >= DIRSIZ)
80100fbd:	83 ff 0d             	cmp    $0xd,%edi
80100fc0:	7e 11                	jle    80100fd3 <skipelem+0x4f>
    memmove(name, s, DIRSIZ);
80100fc2:	83 ec 04             	sub    $0x4,%esp
80100fc5:	6a 0e                	push   $0xe
80100fc7:	50                   	push   %eax
80100fc8:	56                   	push   %esi
80100fc9:	e8 35 2e 00 00       	call   80103e03 <memmove>
80100fce:	83 c4 10             	add    $0x10,%esp
80100fd1:	eb 17                	jmp    80100fea <skipelem+0x66>
  else {
    memmove(name, s, len);
80100fd3:	83 ec 04             	sub    $0x4,%esp
80100fd6:	57                   	push   %edi
80100fd7:	50                   	push   %eax
80100fd8:	56                   	push   %esi
80100fd9:	e8 25 2e 00 00       	call   80103e03 <memmove>
    name[len] = 0;
80100fde:	c6 04 3e 00          	movb   $0x0,(%esi,%edi,1)
80100fe2:	83 c4 10             	add    $0x10,%esp
80100fe5:	eb 03                	jmp    80100fea <skipelem+0x66>
  }
  while(*path == '/')
    path++;
80100fe7:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80100fea:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80100fed:	74 f8                	je     80100fe7 <skipelem+0x63>
  return path;
}
80100fef:	89 d8                	mov    %ebx,%eax
80100ff1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ff4:	5b                   	pop    %ebx
80100ff5:	5e                   	pop    %esi
80100ff6:	5f                   	pop    %edi
80100ff7:	5d                   	pop    %ebp
80100ff8:	c3                   	ret    
    return 0;
80100ff9:	bb 00 00 00 00       	mov    $0x0,%ebx
80100ffe:	eb ef                	jmp    80100fef <skipelem+0x6b>

80101000 <bzero>:
{
80101000:	55                   	push   %ebp
80101001:	89 e5                	mov    %esp,%ebp
80101003:	53                   	push   %ebx
80101004:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, bno);
80101007:	52                   	push   %edx
80101008:	50                   	push   %eax
80101009:	e8 62 f1 ff ff       	call   80100170 <bread>
8010100e:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
80101010:	8d 40 5c             	lea    0x5c(%eax),%eax
80101013:	83 c4 0c             	add    $0xc,%esp
80101016:	68 00 02 00 00       	push   $0x200
8010101b:	6a 00                	push   $0x0
8010101d:	50                   	push   %eax
8010101e:	e8 60 2d 00 00       	call   80103d83 <memset>
  log_write(bp);
80101023:	89 1c 24             	mov    %ebx,(%esp)
80101026:	e8 55 19 00 00       	call   80102980 <log_write>
  brelse(bp);
8010102b:	89 1c 24             	mov    %ebx,(%esp)
8010102e:	e8 ae f1 ff ff       	call   801001e1 <brelse>
}
80101033:	83 c4 10             	add    $0x10,%esp
80101036:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101039:	c9                   	leave  
8010103a:	c3                   	ret    

8010103b <bfree>:
{
8010103b:	55                   	push   %ebp
8010103c:	89 e5                	mov    %esp,%ebp
8010103e:	57                   	push   %edi
8010103f:	56                   	push   %esi
80101040:	53                   	push   %ebx
80101041:	83 ec 14             	sub    $0x14,%esp
80101044:	89 c3                	mov    %eax,%ebx
80101046:	89 d6                	mov    %edx,%esi
  bp = bread(dev, BBLOCK(b, sb));
80101048:	89 d0                	mov    %edx,%eax
8010104a:	c1 e8 0c             	shr    $0xc,%eax
8010104d:	03 05 d8 09 11 80    	add    0x801109d8,%eax
80101053:	50                   	push   %eax
80101054:	53                   	push   %ebx
80101055:	e8 16 f1 ff ff       	call   80100170 <bread>
8010105a:	89 c3                	mov    %eax,%ebx
  bi = b % BPB;
8010105c:	89 f7                	mov    %esi,%edi
8010105e:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
  m = 1 << (bi % 8);
80101064:	89 f1                	mov    %esi,%ecx
80101066:	83 e1 07             	and    $0x7,%ecx
80101069:	b8 01 00 00 00       	mov    $0x1,%eax
8010106e:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101070:	83 c4 10             	add    $0x10,%esp
80101073:	c1 ff 03             	sar    $0x3,%edi
80101076:	0f b6 54 3b 5c       	movzbl 0x5c(%ebx,%edi,1),%edx
8010107b:	0f b6 ca             	movzbl %dl,%ecx
8010107e:	85 c1                	test   %eax,%ecx
80101080:	74 24                	je     801010a6 <bfree+0x6b>
  bp->data[bi/8] &= ~m;
80101082:	f7 d0                	not    %eax
80101084:	21 d0                	and    %edx,%eax
80101086:	88 44 3b 5c          	mov    %al,0x5c(%ebx,%edi,1)
  log_write(bp);
8010108a:	83 ec 0c             	sub    $0xc,%esp
8010108d:	53                   	push   %ebx
8010108e:	e8 ed 18 00 00       	call   80102980 <log_write>
  brelse(bp);
80101093:	89 1c 24             	mov    %ebx,(%esp)
80101096:	e8 46 f1 ff ff       	call   801001e1 <brelse>
}
8010109b:	83 c4 10             	add    $0x10,%esp
8010109e:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010a1:	5b                   	pop    %ebx
801010a2:	5e                   	pop    %esi
801010a3:	5f                   	pop    %edi
801010a4:	5d                   	pop    %ebp
801010a5:	c3                   	ret    
    panic("freeing free block");
801010a6:	83 ec 0c             	sub    $0xc,%esp
801010a9:	68 3f 67 10 80       	push   $0x8010673f
801010ae:	e8 a9 f2 ff ff       	call   8010035c <panic>

801010b3 <balloc>:
{
801010b3:	55                   	push   %ebp
801010b4:	89 e5                	mov    %esp,%ebp
801010b6:	57                   	push   %edi
801010b7:	56                   	push   %esi
801010b8:	53                   	push   %ebx
801010b9:	83 ec 1c             	sub    $0x1c,%esp
801010bc:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801010bf:	be 00 00 00 00       	mov    $0x0,%esi
801010c4:	eb 14                	jmp    801010da <balloc+0x27>
    brelse(bp);
801010c6:	83 ec 0c             	sub    $0xc,%esp
801010c9:	ff 75 e4             	pushl  -0x1c(%ebp)
801010cc:	e8 10 f1 ff ff       	call   801001e1 <brelse>
  for(b = 0; b < sb.size; b += BPB){
801010d1:	81 c6 00 10 00 00    	add    $0x1000,%esi
801010d7:	83 c4 10             	add    $0x10,%esp
801010da:	39 35 c0 09 11 80    	cmp    %esi,0x801109c0
801010e0:	76 75                	jbe    80101157 <balloc+0xa4>
    bp = bread(dev, BBLOCK(b, sb));
801010e2:	8d 86 ff 0f 00 00    	lea    0xfff(%esi),%eax
801010e8:	85 f6                	test   %esi,%esi
801010ea:	0f 49 c6             	cmovns %esi,%eax
801010ed:	c1 f8 0c             	sar    $0xc,%eax
801010f0:	83 ec 08             	sub    $0x8,%esp
801010f3:	03 05 d8 09 11 80    	add    0x801109d8,%eax
801010f9:	50                   	push   %eax
801010fa:	ff 75 d8             	pushl  -0x28(%ebp)
801010fd:	e8 6e f0 ff ff       	call   80100170 <bread>
80101102:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101105:	83 c4 10             	add    $0x10,%esp
80101108:	b8 00 00 00 00       	mov    $0x0,%eax
8010110d:	3d ff 0f 00 00       	cmp    $0xfff,%eax
80101112:	7f b2                	jg     801010c6 <balloc+0x13>
80101114:	8d 1c 06             	lea    (%esi,%eax,1),%ebx
80101117:	89 5d e0             	mov    %ebx,-0x20(%ebp)
8010111a:	3b 1d c0 09 11 80    	cmp    0x801109c0,%ebx
80101120:	73 a4                	jae    801010c6 <balloc+0x13>
      m = 1 << (bi % 8);
80101122:	99                   	cltd   
80101123:	c1 ea 1d             	shr    $0x1d,%edx
80101126:	8d 0c 10             	lea    (%eax,%edx,1),%ecx
80101129:	83 e1 07             	and    $0x7,%ecx
8010112c:	29 d1                	sub    %edx,%ecx
8010112e:	ba 01 00 00 00       	mov    $0x1,%edx
80101133:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101135:	8d 48 07             	lea    0x7(%eax),%ecx
80101138:	85 c0                	test   %eax,%eax
8010113a:	0f 49 c8             	cmovns %eax,%ecx
8010113d:	c1 f9 03             	sar    $0x3,%ecx
80101140:	89 4d dc             	mov    %ecx,-0x24(%ebp)
80101143:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101146:	0f b6 4c 0f 5c       	movzbl 0x5c(%edi,%ecx,1),%ecx
8010114b:	0f b6 f9             	movzbl %cl,%edi
8010114e:	85 d7                	test   %edx,%edi
80101150:	74 12                	je     80101164 <balloc+0xb1>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101152:	83 c0 01             	add    $0x1,%eax
80101155:	eb b6                	jmp    8010110d <balloc+0x5a>
  panic("balloc: out of blocks");
80101157:	83 ec 0c             	sub    $0xc,%esp
8010115a:	68 52 67 10 80       	push   $0x80106752
8010115f:	e8 f8 f1 ff ff       	call   8010035c <panic>
        bp->data[bi/8] |= m;  // Mark block in use.
80101164:	09 ca                	or     %ecx,%edx
80101166:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101169:	8b 75 dc             	mov    -0x24(%ebp),%esi
8010116c:	88 54 30 5c          	mov    %dl,0x5c(%eax,%esi,1)
        log_write(bp);
80101170:	83 ec 0c             	sub    $0xc,%esp
80101173:	89 c6                	mov    %eax,%esi
80101175:	50                   	push   %eax
80101176:	e8 05 18 00 00       	call   80102980 <log_write>
        brelse(bp);
8010117b:	89 34 24             	mov    %esi,(%esp)
8010117e:	e8 5e f0 ff ff       	call   801001e1 <brelse>
        bzero(dev, b + bi);
80101183:	89 da                	mov    %ebx,%edx
80101185:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101188:	e8 73 fe ff ff       	call   80101000 <bzero>
}
8010118d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101190:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101193:	5b                   	pop    %ebx
80101194:	5e                   	pop    %esi
80101195:	5f                   	pop    %edi
80101196:	5d                   	pop    %ebp
80101197:	c3                   	ret    

80101198 <bmap>:
{
80101198:	55                   	push   %ebp
80101199:	89 e5                	mov    %esp,%ebp
8010119b:	57                   	push   %edi
8010119c:	56                   	push   %esi
8010119d:	53                   	push   %ebx
8010119e:	83 ec 1c             	sub    $0x1c,%esp
801011a1:	89 c3                	mov    %eax,%ebx
801011a3:	89 d7                	mov    %edx,%edi
  if(bn < NDIRECT){
801011a5:	83 fa 0b             	cmp    $0xb,%edx
801011a8:	76 45                	jbe    801011ef <bmap+0x57>
  bn -= NDIRECT;
801011aa:	8d 72 f4             	lea    -0xc(%edx),%esi
  if(bn < NINDIRECT){
801011ad:	83 fe 7f             	cmp    $0x7f,%esi
801011b0:	77 7f                	ja     80101231 <bmap+0x99>
    if((addr = ip->addrs[NDIRECT]) == 0)
801011b2:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
801011b8:	85 c0                	test   %eax,%eax
801011ba:	74 4a                	je     80101206 <bmap+0x6e>
    bp = bread(ip->dev, addr);
801011bc:	83 ec 08             	sub    $0x8,%esp
801011bf:	50                   	push   %eax
801011c0:	ff 33                	pushl  (%ebx)
801011c2:	e8 a9 ef ff ff       	call   80100170 <bread>
801011c7:	89 c7                	mov    %eax,%edi
    if((addr = a[bn]) == 0){
801011c9:	8d 44 b0 5c          	lea    0x5c(%eax,%esi,4),%eax
801011cd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011d0:	8b 30                	mov    (%eax),%esi
801011d2:	83 c4 10             	add    $0x10,%esp
801011d5:	85 f6                	test   %esi,%esi
801011d7:	74 3c                	je     80101215 <bmap+0x7d>
    brelse(bp);
801011d9:	83 ec 0c             	sub    $0xc,%esp
801011dc:	57                   	push   %edi
801011dd:	e8 ff ef ff ff       	call   801001e1 <brelse>
    return addr;
801011e2:	83 c4 10             	add    $0x10,%esp
}
801011e5:	89 f0                	mov    %esi,%eax
801011e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011ea:	5b                   	pop    %ebx
801011eb:	5e                   	pop    %esi
801011ec:	5f                   	pop    %edi
801011ed:	5d                   	pop    %ebp
801011ee:	c3                   	ret    
    if((addr = ip->addrs[bn]) == 0)
801011ef:	8b 74 90 5c          	mov    0x5c(%eax,%edx,4),%esi
801011f3:	85 f6                	test   %esi,%esi
801011f5:	75 ee                	jne    801011e5 <bmap+0x4d>
      ip->addrs[bn] = addr = balloc(ip->dev);
801011f7:	8b 00                	mov    (%eax),%eax
801011f9:	e8 b5 fe ff ff       	call   801010b3 <balloc>
801011fe:	89 c6                	mov    %eax,%esi
80101200:	89 44 bb 5c          	mov    %eax,0x5c(%ebx,%edi,4)
    return addr;
80101204:	eb df                	jmp    801011e5 <bmap+0x4d>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101206:	8b 03                	mov    (%ebx),%eax
80101208:	e8 a6 fe ff ff       	call   801010b3 <balloc>
8010120d:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101213:	eb a7                	jmp    801011bc <bmap+0x24>
      a[bn] = addr = balloc(ip->dev);
80101215:	8b 03                	mov    (%ebx),%eax
80101217:	e8 97 fe ff ff       	call   801010b3 <balloc>
8010121c:	89 c6                	mov    %eax,%esi
8010121e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101221:	89 30                	mov    %esi,(%eax)
      log_write(bp);
80101223:	83 ec 0c             	sub    $0xc,%esp
80101226:	57                   	push   %edi
80101227:	e8 54 17 00 00       	call   80102980 <log_write>
8010122c:	83 c4 10             	add    $0x10,%esp
8010122f:	eb a8                	jmp    801011d9 <bmap+0x41>
  panic("bmap: out of range");
80101231:	83 ec 0c             	sub    $0xc,%esp
80101234:	68 68 67 10 80       	push   $0x80106768
80101239:	e8 1e f1 ff ff       	call   8010035c <panic>

8010123e <iget>:
{
8010123e:	55                   	push   %ebp
8010123f:	89 e5                	mov    %esp,%ebp
80101241:	57                   	push   %edi
80101242:	56                   	push   %esi
80101243:	53                   	push   %ebx
80101244:	83 ec 28             	sub    $0x28,%esp
80101247:	89 c7                	mov    %eax,%edi
80101249:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
8010124c:	68 e0 09 11 80       	push   $0x801109e0
80101251:	e8 79 2a 00 00       	call   80103ccf <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101256:	83 c4 10             	add    $0x10,%esp
  empty = 0;
80101259:	be 00 00 00 00       	mov    $0x0,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010125e:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
80101263:	eb 0a                	jmp    8010126f <iget+0x31>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101265:	85 f6                	test   %esi,%esi
80101267:	74 3b                	je     801012a4 <iget+0x66>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101269:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010126f:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101275:	73 35                	jae    801012ac <iget+0x6e>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101277:	8b 43 08             	mov    0x8(%ebx),%eax
8010127a:	85 c0                	test   %eax,%eax
8010127c:	7e e7                	jle    80101265 <iget+0x27>
8010127e:	39 3b                	cmp    %edi,(%ebx)
80101280:	75 e3                	jne    80101265 <iget+0x27>
80101282:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101285:	39 4b 04             	cmp    %ecx,0x4(%ebx)
80101288:	75 db                	jne    80101265 <iget+0x27>
      ip->ref++;
8010128a:	83 c0 01             	add    $0x1,%eax
8010128d:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101290:	83 ec 0c             	sub    $0xc,%esp
80101293:	68 e0 09 11 80       	push   $0x801109e0
80101298:	e8 9b 2a 00 00       	call   80103d38 <release>
      return ip;
8010129d:	83 c4 10             	add    $0x10,%esp
801012a0:	89 de                	mov    %ebx,%esi
801012a2:	eb 32                	jmp    801012d6 <iget+0x98>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
801012a4:	85 c0                	test   %eax,%eax
801012a6:	75 c1                	jne    80101269 <iget+0x2b>
      empty = ip;
801012a8:	89 de                	mov    %ebx,%esi
801012aa:	eb bd                	jmp    80101269 <iget+0x2b>
  if(empty == 0)
801012ac:	85 f6                	test   %esi,%esi
801012ae:	74 30                	je     801012e0 <iget+0xa2>
  ip->dev = dev;
801012b0:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801012b5:	89 46 04             	mov    %eax,0x4(%esi)
  ip->ref = 1;
801012b8:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012bf:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012c6:	83 ec 0c             	sub    $0xc,%esp
801012c9:	68 e0 09 11 80       	push   $0x801109e0
801012ce:	e8 65 2a 00 00       	call   80103d38 <release>
  return ip;
801012d3:	83 c4 10             	add    $0x10,%esp
}
801012d6:	89 f0                	mov    %esi,%eax
801012d8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012db:	5b                   	pop    %ebx
801012dc:	5e                   	pop    %esi
801012dd:	5f                   	pop    %edi
801012de:	5d                   	pop    %ebp
801012df:	c3                   	ret    
    panic("iget: no inodes");
801012e0:	83 ec 0c             	sub    $0xc,%esp
801012e3:	68 7b 67 10 80       	push   $0x8010677b
801012e8:	e8 6f f0 ff ff       	call   8010035c <panic>

801012ed <readsb>:
{
801012ed:	f3 0f 1e fb          	endbr32 
801012f1:	55                   	push   %ebp
801012f2:	89 e5                	mov    %esp,%ebp
801012f4:	53                   	push   %ebx
801012f5:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, 1);
801012f8:	6a 01                	push   $0x1
801012fa:	ff 75 08             	pushl  0x8(%ebp)
801012fd:	e8 6e ee ff ff       	call   80100170 <bread>
80101302:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101304:	8d 40 5c             	lea    0x5c(%eax),%eax
80101307:	83 c4 0c             	add    $0xc,%esp
8010130a:	6a 1c                	push   $0x1c
8010130c:	50                   	push   %eax
8010130d:	ff 75 0c             	pushl  0xc(%ebp)
80101310:	e8 ee 2a 00 00       	call   80103e03 <memmove>
  brelse(bp);
80101315:	89 1c 24             	mov    %ebx,(%esp)
80101318:	e8 c4 ee ff ff       	call   801001e1 <brelse>
}
8010131d:	83 c4 10             	add    $0x10,%esp
80101320:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101323:	c9                   	leave  
80101324:	c3                   	ret    

80101325 <iinit>:
{
80101325:	f3 0f 1e fb          	endbr32 
80101329:	55                   	push   %ebp
8010132a:	89 e5                	mov    %esp,%ebp
8010132c:	53                   	push   %ebx
8010132d:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
80101330:	68 8b 67 10 80       	push   $0x8010678b
80101335:	68 e0 09 11 80       	push   $0x801109e0
8010133a:	e8 40 28 00 00       	call   80103b7f <initlock>
  for(i = 0; i < NINODE; i++) {
8010133f:	83 c4 10             	add    $0x10,%esp
80101342:	bb 00 00 00 00       	mov    $0x0,%ebx
80101347:	83 fb 31             	cmp    $0x31,%ebx
8010134a:	7f 23                	jg     8010136f <iinit+0x4a>
    initsleeplock(&icache.inode[i].lock, "inode");
8010134c:	83 ec 08             	sub    $0x8,%esp
8010134f:	68 92 67 10 80       	push   $0x80106792
80101354:	8d 14 db             	lea    (%ebx,%ebx,8),%edx
80101357:	89 d0                	mov    %edx,%eax
80101359:	c1 e0 04             	shl    $0x4,%eax
8010135c:	05 20 0a 11 80       	add    $0x80110a20,%eax
80101361:	50                   	push   %eax
80101362:	e8 fd 26 00 00       	call   80103a64 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101367:	83 c3 01             	add    $0x1,%ebx
8010136a:	83 c4 10             	add    $0x10,%esp
8010136d:	eb d8                	jmp    80101347 <iinit+0x22>
  readsb(dev, &sb);
8010136f:	83 ec 08             	sub    $0x8,%esp
80101372:	68 c0 09 11 80       	push   $0x801109c0
80101377:	ff 75 08             	pushl  0x8(%ebp)
8010137a:	e8 6e ff ff ff       	call   801012ed <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
8010137f:	ff 35 d8 09 11 80    	pushl  0x801109d8
80101385:	ff 35 d4 09 11 80    	pushl  0x801109d4
8010138b:	ff 35 d0 09 11 80    	pushl  0x801109d0
80101391:	ff 35 cc 09 11 80    	pushl  0x801109cc
80101397:	ff 35 c8 09 11 80    	pushl  0x801109c8
8010139d:	ff 35 c4 09 11 80    	pushl  0x801109c4
801013a3:	ff 35 c0 09 11 80    	pushl  0x801109c0
801013a9:	68 f8 67 10 80       	push   $0x801067f8
801013ae:	e8 76 f2 ff ff       	call   80100629 <cprintf>
}
801013b3:	83 c4 30             	add    $0x30,%esp
801013b6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801013b9:	c9                   	leave  
801013ba:	c3                   	ret    

801013bb <ialloc>:
{
801013bb:	f3 0f 1e fb          	endbr32 
801013bf:	55                   	push   %ebp
801013c0:	89 e5                	mov    %esp,%ebp
801013c2:	57                   	push   %edi
801013c3:	56                   	push   %esi
801013c4:	53                   	push   %ebx
801013c5:	83 ec 1c             	sub    $0x1c,%esp
801013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801013cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801013ce:	bb 01 00 00 00       	mov    $0x1,%ebx
801013d3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801013d6:	39 1d c8 09 11 80    	cmp    %ebx,0x801109c8
801013dc:	76 76                	jbe    80101454 <ialloc+0x99>
    bp = bread(dev, IBLOCK(inum, sb));
801013de:	89 d8                	mov    %ebx,%eax
801013e0:	c1 e8 03             	shr    $0x3,%eax
801013e3:	83 ec 08             	sub    $0x8,%esp
801013e6:	03 05 d4 09 11 80    	add    0x801109d4,%eax
801013ec:	50                   	push   %eax
801013ed:	ff 75 08             	pushl  0x8(%ebp)
801013f0:	e8 7b ed ff ff       	call   80100170 <bread>
801013f5:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + inum%IPB;
801013f7:	89 d8                	mov    %ebx,%eax
801013f9:	83 e0 07             	and    $0x7,%eax
801013fc:	c1 e0 06             	shl    $0x6,%eax
801013ff:	8d 7c 06 5c          	lea    0x5c(%esi,%eax,1),%edi
    if(dip->type == 0){  // a free inode
80101403:	83 c4 10             	add    $0x10,%esp
80101406:	66 83 3f 00          	cmpw   $0x0,(%edi)
8010140a:	74 11                	je     8010141d <ialloc+0x62>
    brelse(bp);
8010140c:	83 ec 0c             	sub    $0xc,%esp
8010140f:	56                   	push   %esi
80101410:	e8 cc ed ff ff       	call   801001e1 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
80101415:	83 c3 01             	add    $0x1,%ebx
80101418:	83 c4 10             	add    $0x10,%esp
8010141b:	eb b6                	jmp    801013d3 <ialloc+0x18>
      memset(dip, 0, sizeof(*dip));
8010141d:	83 ec 04             	sub    $0x4,%esp
80101420:	6a 40                	push   $0x40
80101422:	6a 00                	push   $0x0
80101424:	57                   	push   %edi
80101425:	e8 59 29 00 00       	call   80103d83 <memset>
      dip->type = type;
8010142a:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
8010142e:	66 89 07             	mov    %ax,(%edi)
      log_write(bp);   // mark it allocated on the disk
80101431:	89 34 24             	mov    %esi,(%esp)
80101434:	e8 47 15 00 00       	call   80102980 <log_write>
      brelse(bp);
80101439:	89 34 24             	mov    %esi,(%esp)
8010143c:	e8 a0 ed ff ff       	call   801001e1 <brelse>
      return iget(dev, inum);
80101441:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101444:	8b 45 08             	mov    0x8(%ebp),%eax
80101447:	e8 f2 fd ff ff       	call   8010123e <iget>
}
8010144c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010144f:	5b                   	pop    %ebx
80101450:	5e                   	pop    %esi
80101451:	5f                   	pop    %edi
80101452:	5d                   	pop    %ebp
80101453:	c3                   	ret    
  panic("ialloc: no inodes");
80101454:	83 ec 0c             	sub    $0xc,%esp
80101457:	68 98 67 10 80       	push   $0x80106798
8010145c:	e8 fb ee ff ff       	call   8010035c <panic>

80101461 <iupdate>:
{
80101461:	f3 0f 1e fb          	endbr32 
80101465:	55                   	push   %ebp
80101466:	89 e5                	mov    %esp,%ebp
80101468:	56                   	push   %esi
80101469:	53                   	push   %ebx
8010146a:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010146d:	8b 43 04             	mov    0x4(%ebx),%eax
80101470:	c1 e8 03             	shr    $0x3,%eax
80101473:	83 ec 08             	sub    $0x8,%esp
80101476:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010147c:	50                   	push   %eax
8010147d:	ff 33                	pushl  (%ebx)
8010147f:	e8 ec ec ff ff       	call   80100170 <bread>
80101484:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101486:	8b 43 04             	mov    0x4(%ebx),%eax
80101489:	83 e0 07             	and    $0x7,%eax
8010148c:	c1 e0 06             	shl    $0x6,%eax
8010148f:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
80101493:	0f b7 53 50          	movzwl 0x50(%ebx),%edx
80101497:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
8010149a:	0f b7 53 52          	movzwl 0x52(%ebx),%edx
8010149e:	66 89 50 02          	mov    %dx,0x2(%eax)
  dip->minor = ip->minor;
801014a2:	0f b7 53 54          	movzwl 0x54(%ebx),%edx
801014a6:	66 89 50 04          	mov    %dx,0x4(%eax)
  dip->nlink = ip->nlink;
801014aa:	0f b7 53 56          	movzwl 0x56(%ebx),%edx
801014ae:	66 89 50 06          	mov    %dx,0x6(%eax)
  dip->size = ip->size;
801014b2:	8b 53 58             	mov    0x58(%ebx),%edx
801014b5:	89 50 08             	mov    %edx,0x8(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801014b8:	83 c3 5c             	add    $0x5c,%ebx
801014bb:	83 c0 0c             	add    $0xc,%eax
801014be:	83 c4 0c             	add    $0xc,%esp
801014c1:	6a 34                	push   $0x34
801014c3:	53                   	push   %ebx
801014c4:	50                   	push   %eax
801014c5:	e8 39 29 00 00       	call   80103e03 <memmove>
  log_write(bp);
801014ca:	89 34 24             	mov    %esi,(%esp)
801014cd:	e8 ae 14 00 00       	call   80102980 <log_write>
  brelse(bp);
801014d2:	89 34 24             	mov    %esi,(%esp)
801014d5:	e8 07 ed ff ff       	call   801001e1 <brelse>
}
801014da:	83 c4 10             	add    $0x10,%esp
801014dd:	8d 65 f8             	lea    -0x8(%ebp),%esp
801014e0:	5b                   	pop    %ebx
801014e1:	5e                   	pop    %esi
801014e2:	5d                   	pop    %ebp
801014e3:	c3                   	ret    

801014e4 <itrunc>:
{
801014e4:	55                   	push   %ebp
801014e5:	89 e5                	mov    %esp,%ebp
801014e7:	57                   	push   %edi
801014e8:	56                   	push   %esi
801014e9:	53                   	push   %ebx
801014ea:	83 ec 1c             	sub    $0x1c,%esp
801014ed:	89 c6                	mov    %eax,%esi
  for(i = 0; i < NDIRECT; i++){
801014ef:	bb 00 00 00 00       	mov    $0x0,%ebx
801014f4:	eb 03                	jmp    801014f9 <itrunc+0x15>
801014f6:	83 c3 01             	add    $0x1,%ebx
801014f9:	83 fb 0b             	cmp    $0xb,%ebx
801014fc:	7f 19                	jg     80101517 <itrunc+0x33>
    if(ip->addrs[i]){
801014fe:	8b 54 9e 5c          	mov    0x5c(%esi,%ebx,4),%edx
80101502:	85 d2                	test   %edx,%edx
80101504:	74 f0                	je     801014f6 <itrunc+0x12>
      bfree(ip->dev, ip->addrs[i]);
80101506:	8b 06                	mov    (%esi),%eax
80101508:	e8 2e fb ff ff       	call   8010103b <bfree>
      ip->addrs[i] = 0;
8010150d:	c7 44 9e 5c 00 00 00 	movl   $0x0,0x5c(%esi,%ebx,4)
80101514:	00 
80101515:	eb df                	jmp    801014f6 <itrunc+0x12>
  if(ip->addrs[NDIRECT]){
80101517:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
8010151d:	85 c0                	test   %eax,%eax
8010151f:	75 1b                	jne    8010153c <itrunc+0x58>
  ip->size = 0;
80101521:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101528:	83 ec 0c             	sub    $0xc,%esp
8010152b:	56                   	push   %esi
8010152c:	e8 30 ff ff ff       	call   80101461 <iupdate>
}
80101531:	83 c4 10             	add    $0x10,%esp
80101534:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101537:	5b                   	pop    %ebx
80101538:	5e                   	pop    %esi
80101539:	5f                   	pop    %edi
8010153a:	5d                   	pop    %ebp
8010153b:	c3                   	ret    
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
8010153c:	83 ec 08             	sub    $0x8,%esp
8010153f:	50                   	push   %eax
80101540:	ff 36                	pushl  (%esi)
80101542:	e8 29 ec ff ff       	call   80100170 <bread>
80101547:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
8010154a:	8d 78 5c             	lea    0x5c(%eax),%edi
    for(j = 0; j < NINDIRECT; j++){
8010154d:	83 c4 10             	add    $0x10,%esp
80101550:	bb 00 00 00 00       	mov    $0x0,%ebx
80101555:	eb 0a                	jmp    80101561 <itrunc+0x7d>
        bfree(ip->dev, a[j]);
80101557:	8b 06                	mov    (%esi),%eax
80101559:	e8 dd fa ff ff       	call   8010103b <bfree>
    for(j = 0; j < NINDIRECT; j++){
8010155e:	83 c3 01             	add    $0x1,%ebx
80101561:	83 fb 7f             	cmp    $0x7f,%ebx
80101564:	77 09                	ja     8010156f <itrunc+0x8b>
      if(a[j])
80101566:	8b 14 9f             	mov    (%edi,%ebx,4),%edx
80101569:	85 d2                	test   %edx,%edx
8010156b:	74 f1                	je     8010155e <itrunc+0x7a>
8010156d:	eb e8                	jmp    80101557 <itrunc+0x73>
    brelse(bp);
8010156f:	83 ec 0c             	sub    $0xc,%esp
80101572:	ff 75 e4             	pushl  -0x1c(%ebp)
80101575:	e8 67 ec ff ff       	call   801001e1 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
8010157a:	8b 06                	mov    (%esi),%eax
8010157c:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101582:	e8 b4 fa ff ff       	call   8010103b <bfree>
    ip->addrs[NDIRECT] = 0;
80101587:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
8010158e:	00 00 00 
80101591:	83 c4 10             	add    $0x10,%esp
80101594:	eb 8b                	jmp    80101521 <itrunc+0x3d>

80101596 <idup>:
{
80101596:	f3 0f 1e fb          	endbr32 
8010159a:	55                   	push   %ebp
8010159b:	89 e5                	mov    %esp,%ebp
8010159d:	53                   	push   %ebx
8010159e:	83 ec 10             	sub    $0x10,%esp
801015a1:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
801015a4:	68 e0 09 11 80       	push   $0x801109e0
801015a9:	e8 21 27 00 00       	call   80103ccf <acquire>
  ip->ref++;
801015ae:	8b 43 08             	mov    0x8(%ebx),%eax
801015b1:	83 c0 01             	add    $0x1,%eax
801015b4:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
801015b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801015be:	e8 75 27 00 00       	call   80103d38 <release>
}
801015c3:	89 d8                	mov    %ebx,%eax
801015c5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801015c8:	c9                   	leave  
801015c9:	c3                   	ret    

801015ca <ilock>:
{
801015ca:	f3 0f 1e fb          	endbr32 
801015ce:	55                   	push   %ebp
801015cf:	89 e5                	mov    %esp,%ebp
801015d1:	56                   	push   %esi
801015d2:	53                   	push   %ebx
801015d3:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
801015d6:	85 db                	test   %ebx,%ebx
801015d8:	74 22                	je     801015fc <ilock+0x32>
801015da:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801015de:	7e 1c                	jle    801015fc <ilock+0x32>
  acquiresleep(&ip->lock);
801015e0:	83 ec 0c             	sub    $0xc,%esp
801015e3:	8d 43 0c             	lea    0xc(%ebx),%eax
801015e6:	50                   	push   %eax
801015e7:	e8 af 24 00 00       	call   80103a9b <acquiresleep>
  if(ip->valid == 0){
801015ec:	83 c4 10             	add    $0x10,%esp
801015ef:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801015f3:	74 14                	je     80101609 <ilock+0x3f>
}
801015f5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015f8:	5b                   	pop    %ebx
801015f9:	5e                   	pop    %esi
801015fa:	5d                   	pop    %ebp
801015fb:	c3                   	ret    
    panic("ilock");
801015fc:	83 ec 0c             	sub    $0xc,%esp
801015ff:	68 aa 67 10 80       	push   $0x801067aa
80101604:	e8 53 ed ff ff       	call   8010035c <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101609:	8b 43 04             	mov    0x4(%ebx),%eax
8010160c:	c1 e8 03             	shr    $0x3,%eax
8010160f:	83 ec 08             	sub    $0x8,%esp
80101612:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101618:	50                   	push   %eax
80101619:	ff 33                	pushl  (%ebx)
8010161b:	e8 50 eb ff ff       	call   80100170 <bread>
80101620:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101622:	8b 43 04             	mov    0x4(%ebx),%eax
80101625:	83 e0 07             	and    $0x7,%eax
80101628:	c1 e0 06             	shl    $0x6,%eax
8010162b:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
8010162f:	0f b7 10             	movzwl (%eax),%edx
80101632:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
80101636:	0f b7 50 02          	movzwl 0x2(%eax),%edx
8010163a:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
8010163e:	0f b7 50 04          	movzwl 0x4(%eax),%edx
80101642:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
80101646:	0f b7 50 06          	movzwl 0x6(%eax),%edx
8010164a:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
8010164e:	8b 50 08             	mov    0x8(%eax),%edx
80101651:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101654:	83 c0 0c             	add    $0xc,%eax
80101657:	8d 53 5c             	lea    0x5c(%ebx),%edx
8010165a:	83 c4 0c             	add    $0xc,%esp
8010165d:	6a 34                	push   $0x34
8010165f:	50                   	push   %eax
80101660:	52                   	push   %edx
80101661:	e8 9d 27 00 00       	call   80103e03 <memmove>
    brelse(bp);
80101666:	89 34 24             	mov    %esi,(%esp)
80101669:	e8 73 eb ff ff       	call   801001e1 <brelse>
    ip->valid = 1;
8010166e:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101675:	83 c4 10             	add    $0x10,%esp
80101678:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
8010167d:	0f 85 72 ff ff ff    	jne    801015f5 <ilock+0x2b>
      panic("ilock: no type");
80101683:	83 ec 0c             	sub    $0xc,%esp
80101686:	68 b0 67 10 80       	push   $0x801067b0
8010168b:	e8 cc ec ff ff       	call   8010035c <panic>

80101690 <iunlock>:
{
80101690:	f3 0f 1e fb          	endbr32 
80101694:	55                   	push   %ebp
80101695:	89 e5                	mov    %esp,%ebp
80101697:	56                   	push   %esi
80101698:	53                   	push   %ebx
80101699:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
8010169c:	85 db                	test   %ebx,%ebx
8010169e:	74 2c                	je     801016cc <iunlock+0x3c>
801016a0:	8d 73 0c             	lea    0xc(%ebx),%esi
801016a3:	83 ec 0c             	sub    $0xc,%esp
801016a6:	56                   	push   %esi
801016a7:	e8 81 24 00 00       	call   80103b2d <holdingsleep>
801016ac:	83 c4 10             	add    $0x10,%esp
801016af:	85 c0                	test   %eax,%eax
801016b1:	74 19                	je     801016cc <iunlock+0x3c>
801016b3:	83 7b 08 00          	cmpl   $0x0,0x8(%ebx)
801016b7:	7e 13                	jle    801016cc <iunlock+0x3c>
  releasesleep(&ip->lock);
801016b9:	83 ec 0c             	sub    $0xc,%esp
801016bc:	56                   	push   %esi
801016bd:	e8 2c 24 00 00       	call   80103aee <releasesleep>
}
801016c2:	83 c4 10             	add    $0x10,%esp
801016c5:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016c8:	5b                   	pop    %ebx
801016c9:	5e                   	pop    %esi
801016ca:	5d                   	pop    %ebp
801016cb:	c3                   	ret    
    panic("iunlock");
801016cc:	83 ec 0c             	sub    $0xc,%esp
801016cf:	68 bf 67 10 80       	push   $0x801067bf
801016d4:	e8 83 ec ff ff       	call   8010035c <panic>

801016d9 <iput>:
{
801016d9:	f3 0f 1e fb          	endbr32 
801016dd:	55                   	push   %ebp
801016de:	89 e5                	mov    %esp,%ebp
801016e0:	57                   	push   %edi
801016e1:	56                   	push   %esi
801016e2:	53                   	push   %ebx
801016e3:	83 ec 18             	sub    $0x18,%esp
801016e6:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
801016e9:	8d 73 0c             	lea    0xc(%ebx),%esi
801016ec:	56                   	push   %esi
801016ed:	e8 a9 23 00 00       	call   80103a9b <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801016f2:	83 c4 10             	add    $0x10,%esp
801016f5:	83 7b 4c 00          	cmpl   $0x0,0x4c(%ebx)
801016f9:	74 07                	je     80101702 <iput+0x29>
801016fb:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101700:	74 35                	je     80101737 <iput+0x5e>
  releasesleep(&ip->lock);
80101702:	83 ec 0c             	sub    $0xc,%esp
80101705:	56                   	push   %esi
80101706:	e8 e3 23 00 00       	call   80103aee <releasesleep>
  acquire(&icache.lock);
8010170b:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101712:	e8 b8 25 00 00       	call   80103ccf <acquire>
  ip->ref--;
80101717:	8b 43 08             	mov    0x8(%ebx),%eax
8010171a:	83 e8 01             	sub    $0x1,%eax
8010171d:	89 43 08             	mov    %eax,0x8(%ebx)
  release(&icache.lock);
80101720:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101727:	e8 0c 26 00 00       	call   80103d38 <release>
}
8010172c:	83 c4 10             	add    $0x10,%esp
8010172f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101732:	5b                   	pop    %ebx
80101733:	5e                   	pop    %esi
80101734:	5f                   	pop    %edi
80101735:	5d                   	pop    %ebp
80101736:	c3                   	ret    
    acquire(&icache.lock);
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 e0 09 11 80       	push   $0x801109e0
8010173f:	e8 8b 25 00 00       	call   80103ccf <acquire>
    int r = ip->ref;
80101744:	8b 7b 08             	mov    0x8(%ebx),%edi
    release(&icache.lock);
80101747:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010174e:	e8 e5 25 00 00       	call   80103d38 <release>
    if(r == 1){
80101753:	83 c4 10             	add    $0x10,%esp
80101756:	83 ff 01             	cmp    $0x1,%edi
80101759:	75 a7                	jne    80101702 <iput+0x29>
      itrunc(ip);
8010175b:	89 d8                	mov    %ebx,%eax
8010175d:	e8 82 fd ff ff       	call   801014e4 <itrunc>
      ip->type = 0;
80101762:	66 c7 43 50 00 00    	movw   $0x0,0x50(%ebx)
      iupdate(ip);
80101768:	83 ec 0c             	sub    $0xc,%esp
8010176b:	53                   	push   %ebx
8010176c:	e8 f0 fc ff ff       	call   80101461 <iupdate>
      ip->valid = 0;
80101771:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101778:	83 c4 10             	add    $0x10,%esp
8010177b:	eb 85                	jmp    80101702 <iput+0x29>

8010177d <iunlockput>:
{
8010177d:	f3 0f 1e fb          	endbr32 
80101781:	55                   	push   %ebp
80101782:	89 e5                	mov    %esp,%ebp
80101784:	53                   	push   %ebx
80101785:	83 ec 10             	sub    $0x10,%esp
80101788:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010178b:	53                   	push   %ebx
8010178c:	e8 ff fe ff ff       	call   80101690 <iunlock>
  iput(ip);
80101791:	89 1c 24             	mov    %ebx,(%esp)
80101794:	e8 40 ff ff ff       	call   801016d9 <iput>
}
80101799:	83 c4 10             	add    $0x10,%esp
8010179c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010179f:	c9                   	leave  
801017a0:	c3                   	ret    

801017a1 <stati>:
{
801017a1:	f3 0f 1e fb          	endbr32 
801017a5:	55                   	push   %ebp
801017a6:	89 e5                	mov    %esp,%ebp
801017a8:	8b 55 08             	mov    0x8(%ebp),%edx
801017ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
801017ae:	8b 0a                	mov    (%edx),%ecx
801017b0:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
801017b3:	8b 4a 04             	mov    0x4(%edx),%ecx
801017b6:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
801017b9:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
801017bd:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
801017c0:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
801017c4:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
801017c8:	8b 52 58             	mov    0x58(%edx),%edx
801017cb:	89 50 10             	mov    %edx,0x10(%eax)
}
801017ce:	5d                   	pop    %ebp
801017cf:	c3                   	ret    

801017d0 <readi>:
{
801017d0:	f3 0f 1e fb          	endbr32 
801017d4:	55                   	push   %ebp
801017d5:	89 e5                	mov    %esp,%ebp
801017d7:	57                   	push   %edi
801017d8:	56                   	push   %esi
801017d9:	53                   	push   %ebx
801017da:	83 ec 1c             	sub    $0x1c,%esp
801017dd:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801017e0:	8b 45 08             	mov    0x8(%ebp),%eax
801017e3:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801017e8:	74 2c                	je     80101816 <readi+0x46>
  if(off > ip->size || off + n < off)
801017ea:	8b 45 08             	mov    0x8(%ebp),%eax
801017ed:	8b 40 58             	mov    0x58(%eax),%eax
801017f0:	39 f0                	cmp    %esi,%eax
801017f2:	0f 82 cb 00 00 00    	jb     801018c3 <readi+0xf3>
801017f8:	89 f2                	mov    %esi,%edx
801017fa:	03 55 14             	add    0x14(%ebp),%edx
801017fd:	0f 82 c7 00 00 00    	jb     801018ca <readi+0xfa>
  if(off + n > ip->size)
80101803:	39 d0                	cmp    %edx,%eax
80101805:	73 05                	jae    8010180c <readi+0x3c>
    n = ip->size - off;
80101807:	29 f0                	sub    %esi,%eax
80101809:	89 45 14             	mov    %eax,0x14(%ebp)
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010180c:	bf 00 00 00 00       	mov    $0x0,%edi
80101811:	e9 8f 00 00 00       	jmp    801018a5 <readi+0xd5>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101816:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010181a:	66 83 f8 09          	cmp    $0x9,%ax
8010181e:	0f 87 91 00 00 00    	ja     801018b5 <readi+0xe5>
80101824:	98                   	cwtl   
80101825:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
8010182c:	85 c0                	test   %eax,%eax
8010182e:	0f 84 88 00 00 00    	je     801018bc <readi+0xec>
    return devsw[ip->major].read(ip, dst, n);
80101834:	83 ec 04             	sub    $0x4,%esp
80101837:	ff 75 14             	pushl  0x14(%ebp)
8010183a:	ff 75 0c             	pushl  0xc(%ebp)
8010183d:	ff 75 08             	pushl  0x8(%ebp)
80101840:	ff d0                	call   *%eax
80101842:	83 c4 10             	add    $0x10,%esp
80101845:	eb 66                	jmp    801018ad <readi+0xdd>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101847:	89 f2                	mov    %esi,%edx
80101849:	c1 ea 09             	shr    $0x9,%edx
8010184c:	8b 45 08             	mov    0x8(%ebp),%eax
8010184f:	e8 44 f9 ff ff       	call   80101198 <bmap>
80101854:	83 ec 08             	sub    $0x8,%esp
80101857:	50                   	push   %eax
80101858:	8b 45 08             	mov    0x8(%ebp),%eax
8010185b:	ff 30                	pushl  (%eax)
8010185d:	e8 0e e9 ff ff       	call   80100170 <bread>
80101862:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
80101864:	89 f0                	mov    %esi,%eax
80101866:	25 ff 01 00 00       	and    $0x1ff,%eax
8010186b:	bb 00 02 00 00       	mov    $0x200,%ebx
80101870:	29 c3                	sub    %eax,%ebx
80101872:	8b 55 14             	mov    0x14(%ebp),%edx
80101875:	29 fa                	sub    %edi,%edx
80101877:	83 c4 0c             	add    $0xc,%esp
8010187a:	39 d3                	cmp    %edx,%ebx
8010187c:	0f 47 da             	cmova  %edx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
8010187f:	53                   	push   %ebx
80101880:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101883:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101887:	50                   	push   %eax
80101888:	ff 75 0c             	pushl  0xc(%ebp)
8010188b:	e8 73 25 00 00       	call   80103e03 <memmove>
    brelse(bp);
80101890:	83 c4 04             	add    $0x4,%esp
80101893:	ff 75 e4             	pushl  -0x1c(%ebp)
80101896:	e8 46 e9 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010189b:	01 df                	add    %ebx,%edi
8010189d:	01 de                	add    %ebx,%esi
8010189f:	01 5d 0c             	add    %ebx,0xc(%ebp)
801018a2:	83 c4 10             	add    $0x10,%esp
801018a5:	39 7d 14             	cmp    %edi,0x14(%ebp)
801018a8:	77 9d                	ja     80101847 <readi+0x77>
  return n;
801018aa:	8b 45 14             	mov    0x14(%ebp),%eax
}
801018ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801018b0:	5b                   	pop    %ebx
801018b1:	5e                   	pop    %esi
801018b2:	5f                   	pop    %edi
801018b3:	5d                   	pop    %ebp
801018b4:	c3                   	ret    
      return -1;
801018b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018ba:	eb f1                	jmp    801018ad <readi+0xdd>
801018bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c1:	eb ea                	jmp    801018ad <readi+0xdd>
    return -1;
801018c3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018c8:	eb e3                	jmp    801018ad <readi+0xdd>
801018ca:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801018cf:	eb dc                	jmp    801018ad <readi+0xdd>

801018d1 <writei>:
{
801018d1:	f3 0f 1e fb          	endbr32 
801018d5:	55                   	push   %ebp
801018d6:	89 e5                	mov    %esp,%ebp
801018d8:	57                   	push   %edi
801018d9:	56                   	push   %esi
801018da:	53                   	push   %ebx
801018db:	83 ec 1c             	sub    $0x1c,%esp
801018de:	8b 75 10             	mov    0x10(%ebp),%esi
  if(ip->type == T_DEV){
801018e1:	8b 45 08             	mov    0x8(%ebp),%eax
801018e4:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
801018e9:	0f 84 9b 00 00 00    	je     8010198a <writei+0xb9>
  if(off > ip->size || off + n < off)
801018ef:	8b 45 08             	mov    0x8(%ebp),%eax
801018f2:	39 70 58             	cmp    %esi,0x58(%eax)
801018f5:	0f 82 f0 00 00 00    	jb     801019eb <writei+0x11a>
801018fb:	89 f0                	mov    %esi,%eax
801018fd:	03 45 14             	add    0x14(%ebp),%eax
80101900:	0f 82 ec 00 00 00    	jb     801019f2 <writei+0x121>
  if(off + n > MAXFILE*BSIZE)
80101906:	3d 00 18 01 00       	cmp    $0x11800,%eax
8010190b:	0f 87 e8 00 00 00    	ja     801019f9 <writei+0x128>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101911:	bf 00 00 00 00       	mov    $0x0,%edi
80101916:	3b 7d 14             	cmp    0x14(%ebp),%edi
80101919:	0f 83 94 00 00 00    	jae    801019b3 <writei+0xe2>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
8010191f:	89 f2                	mov    %esi,%edx
80101921:	c1 ea 09             	shr    $0x9,%edx
80101924:	8b 45 08             	mov    0x8(%ebp),%eax
80101927:	e8 6c f8 ff ff       	call   80101198 <bmap>
8010192c:	83 ec 08             	sub    $0x8,%esp
8010192f:	50                   	push   %eax
80101930:	8b 45 08             	mov    0x8(%ebp),%eax
80101933:	ff 30                	pushl  (%eax)
80101935:	e8 36 e8 ff ff       	call   80100170 <bread>
8010193a:	89 c1                	mov    %eax,%ecx
    m = min(n - tot, BSIZE - off%BSIZE);
8010193c:	89 f0                	mov    %esi,%eax
8010193e:	25 ff 01 00 00       	and    $0x1ff,%eax
80101943:	bb 00 02 00 00       	mov    $0x200,%ebx
80101948:	29 c3                	sub    %eax,%ebx
8010194a:	8b 55 14             	mov    0x14(%ebp),%edx
8010194d:	29 fa                	sub    %edi,%edx
8010194f:	83 c4 0c             	add    $0xc,%esp
80101952:	39 d3                	cmp    %edx,%ebx
80101954:	0f 47 da             	cmova  %edx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101957:	53                   	push   %ebx
80101958:	ff 75 0c             	pushl  0xc(%ebp)
8010195b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
8010195e:	8d 44 01 5c          	lea    0x5c(%ecx,%eax,1),%eax
80101962:	50                   	push   %eax
80101963:	e8 9b 24 00 00       	call   80103e03 <memmove>
    log_write(bp);
80101968:	83 c4 04             	add    $0x4,%esp
8010196b:	ff 75 e4             	pushl  -0x1c(%ebp)
8010196e:	e8 0d 10 00 00       	call   80102980 <log_write>
    brelse(bp);
80101973:	83 c4 04             	add    $0x4,%esp
80101976:	ff 75 e4             	pushl  -0x1c(%ebp)
80101979:	e8 63 e8 ff ff       	call   801001e1 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
8010197e:	01 df                	add    %ebx,%edi
80101980:	01 de                	add    %ebx,%esi
80101982:	01 5d 0c             	add    %ebx,0xc(%ebp)
80101985:	83 c4 10             	add    $0x10,%esp
80101988:	eb 8c                	jmp    80101916 <writei+0x45>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
8010198a:	0f b7 40 52          	movzwl 0x52(%eax),%eax
8010198e:	66 83 f8 09          	cmp    $0x9,%ax
80101992:	77 49                	ja     801019dd <writei+0x10c>
80101994:	98                   	cwtl   
80101995:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
8010199c:	85 c0                	test   %eax,%eax
8010199e:	74 44                	je     801019e4 <writei+0x113>
    return devsw[ip->major].write(ip, src, n);
801019a0:	83 ec 04             	sub    $0x4,%esp
801019a3:	ff 75 14             	pushl  0x14(%ebp)
801019a6:	ff 75 0c             	pushl  0xc(%ebp)
801019a9:	ff 75 08             	pushl  0x8(%ebp)
801019ac:	ff d0                	call   *%eax
801019ae:	83 c4 10             	add    $0x10,%esp
801019b1:	eb 11                	jmp    801019c4 <writei+0xf3>
  if(n > 0 && off > ip->size){
801019b3:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
801019b7:	74 08                	je     801019c1 <writei+0xf0>
801019b9:	8b 45 08             	mov    0x8(%ebp),%eax
801019bc:	39 70 58             	cmp    %esi,0x58(%eax)
801019bf:	72 0b                	jb     801019cc <writei+0xfb>
  return n;
801019c1:	8b 45 14             	mov    0x14(%ebp),%eax
}
801019c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019c7:	5b                   	pop    %ebx
801019c8:	5e                   	pop    %esi
801019c9:	5f                   	pop    %edi
801019ca:	5d                   	pop    %ebp
801019cb:	c3                   	ret    
    ip->size = off;
801019cc:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
801019cf:	83 ec 0c             	sub    $0xc,%esp
801019d2:	50                   	push   %eax
801019d3:	e8 89 fa ff ff       	call   80101461 <iupdate>
801019d8:	83 c4 10             	add    $0x10,%esp
801019db:	eb e4                	jmp    801019c1 <writei+0xf0>
      return -1;
801019dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e2:	eb e0                	jmp    801019c4 <writei+0xf3>
801019e4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019e9:	eb d9                	jmp    801019c4 <writei+0xf3>
    return -1;
801019eb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f0:	eb d2                	jmp    801019c4 <writei+0xf3>
801019f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019f7:	eb cb                	jmp    801019c4 <writei+0xf3>
    return -1;
801019f9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801019fe:	eb c4                	jmp    801019c4 <writei+0xf3>

80101a00 <namecmp>:
{
80101a00:	f3 0f 1e fb          	endbr32 
80101a04:	55                   	push   %ebp
80101a05:	89 e5                	mov    %esp,%ebp
80101a07:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101a0a:	6a 0e                	push   $0xe
80101a0c:	ff 75 0c             	pushl  0xc(%ebp)
80101a0f:	ff 75 08             	pushl  0x8(%ebp)
80101a12:	e8 5e 24 00 00       	call   80103e75 <strncmp>
}
80101a17:	c9                   	leave  
80101a18:	c3                   	ret    

80101a19 <dirlookup>:
{
80101a19:	f3 0f 1e fb          	endbr32 
80101a1d:	55                   	push   %ebp
80101a1e:	89 e5                	mov    %esp,%ebp
80101a20:	57                   	push   %edi
80101a21:	56                   	push   %esi
80101a22:	53                   	push   %ebx
80101a23:	83 ec 1c             	sub    $0x1c,%esp
80101a26:	8b 75 08             	mov    0x8(%ebp),%esi
80101a29:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if(dp->type != T_DIR)
80101a2c:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101a31:	75 07                	jne    80101a3a <dirlookup+0x21>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a33:	bb 00 00 00 00       	mov    $0x0,%ebx
80101a38:	eb 1d                	jmp    80101a57 <dirlookup+0x3e>
    panic("dirlookup not DIR");
80101a3a:	83 ec 0c             	sub    $0xc,%esp
80101a3d:	68 c7 67 10 80       	push   $0x801067c7
80101a42:	e8 15 e9 ff ff       	call   8010035c <panic>
      panic("dirlookup read");
80101a47:	83 ec 0c             	sub    $0xc,%esp
80101a4a:	68 d9 67 10 80       	push   $0x801067d9
80101a4f:	e8 08 e9 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101a54:	83 c3 10             	add    $0x10,%ebx
80101a57:	39 5e 58             	cmp    %ebx,0x58(%esi)
80101a5a:	76 48                	jbe    80101aa4 <dirlookup+0x8b>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101a5c:	6a 10                	push   $0x10
80101a5e:	53                   	push   %ebx
80101a5f:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101a62:	50                   	push   %eax
80101a63:	56                   	push   %esi
80101a64:	e8 67 fd ff ff       	call   801017d0 <readi>
80101a69:	83 c4 10             	add    $0x10,%esp
80101a6c:	83 f8 10             	cmp    $0x10,%eax
80101a6f:	75 d6                	jne    80101a47 <dirlookup+0x2e>
    if(de.inum == 0)
80101a71:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101a76:	74 dc                	je     80101a54 <dirlookup+0x3b>
    if(namecmp(name, de.name) == 0){
80101a78:	83 ec 08             	sub    $0x8,%esp
80101a7b:	8d 45 da             	lea    -0x26(%ebp),%eax
80101a7e:	50                   	push   %eax
80101a7f:	57                   	push   %edi
80101a80:	e8 7b ff ff ff       	call   80101a00 <namecmp>
80101a85:	83 c4 10             	add    $0x10,%esp
80101a88:	85 c0                	test   %eax,%eax
80101a8a:	75 c8                	jne    80101a54 <dirlookup+0x3b>
      if(poff)
80101a8c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
80101a90:	74 05                	je     80101a97 <dirlookup+0x7e>
        *poff = off;
80101a92:	8b 45 10             	mov    0x10(%ebp),%eax
80101a95:	89 18                	mov    %ebx,(%eax)
      inum = de.inum;
80101a97:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101a9b:	8b 06                	mov    (%esi),%eax
80101a9d:	e8 9c f7 ff ff       	call   8010123e <iget>
80101aa2:	eb 05                	jmp    80101aa9 <dirlookup+0x90>
  return 0;
80101aa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101aa9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101aac:	5b                   	pop    %ebx
80101aad:	5e                   	pop    %esi
80101aae:	5f                   	pop    %edi
80101aaf:	5d                   	pop    %ebp
80101ab0:	c3                   	ret    

80101ab1 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ab1:	55                   	push   %ebp
80101ab2:	89 e5                	mov    %esp,%ebp
80101ab4:	57                   	push   %edi
80101ab5:	56                   	push   %esi
80101ab6:	53                   	push   %ebx
80101ab7:	83 ec 1c             	sub    $0x1c,%esp
80101aba:	89 c3                	mov    %eax,%ebx
80101abc:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101abf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ac2:	80 38 2f             	cmpb   $0x2f,(%eax)
80101ac5:	74 17                	je     80101ade <namex+0x2d>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ac7:	e8 ff 17 00 00       	call   801032cb <myproc>
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	ff 70 68             	pushl  0x68(%eax)
80101ad2:	e8 bf fa ff ff       	call   80101596 <idup>
80101ad7:	89 c6                	mov    %eax,%esi
80101ad9:	83 c4 10             	add    $0x10,%esp
80101adc:	eb 53                	jmp    80101b31 <namex+0x80>
    ip = iget(ROOTDEV, ROOTINO);
80101ade:	ba 01 00 00 00       	mov    $0x1,%edx
80101ae3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ae8:	e8 51 f7 ff ff       	call   8010123e <iget>
80101aed:	89 c6                	mov    %eax,%esi
80101aef:	eb 40                	jmp    80101b31 <namex+0x80>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
      iunlockput(ip);
80101af1:	83 ec 0c             	sub    $0xc,%esp
80101af4:	56                   	push   %esi
80101af5:	e8 83 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101afa:	83 c4 10             	add    $0x10,%esp
80101afd:	be 00 00 00 00       	mov    $0x0,%esi
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101b02:	89 f0                	mov    %esi,%eax
80101b04:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b07:	5b                   	pop    %ebx
80101b08:	5e                   	pop    %esi
80101b09:	5f                   	pop    %edi
80101b0a:	5d                   	pop    %ebp
80101b0b:	c3                   	ret    
    if((next = dirlookup(ip, name, 0)) == 0){
80101b0c:	83 ec 04             	sub    $0x4,%esp
80101b0f:	6a 00                	push   $0x0
80101b11:	ff 75 e4             	pushl  -0x1c(%ebp)
80101b14:	56                   	push   %esi
80101b15:	e8 ff fe ff ff       	call   80101a19 <dirlookup>
80101b1a:	89 c7                	mov    %eax,%edi
80101b1c:	83 c4 10             	add    $0x10,%esp
80101b1f:	85 c0                	test   %eax,%eax
80101b21:	74 4a                	je     80101b6d <namex+0xbc>
    iunlockput(ip);
80101b23:	83 ec 0c             	sub    $0xc,%esp
80101b26:	56                   	push   %esi
80101b27:	e8 51 fc ff ff       	call   8010177d <iunlockput>
80101b2c:	83 c4 10             	add    $0x10,%esp
    ip = next;
80101b2f:	89 fe                	mov    %edi,%esi
  while((path = skipelem(path, name)) != 0){
80101b31:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b34:	89 d8                	mov    %ebx,%eax
80101b36:	e8 49 f4 ff ff       	call   80100f84 <skipelem>
80101b3b:	89 c3                	mov    %eax,%ebx
80101b3d:	85 c0                	test   %eax,%eax
80101b3f:	74 3c                	je     80101b7d <namex+0xcc>
    ilock(ip);
80101b41:	83 ec 0c             	sub    $0xc,%esp
80101b44:	56                   	push   %esi
80101b45:	e8 80 fa ff ff       	call   801015ca <ilock>
    if(ip->type != T_DIR){
80101b4a:	83 c4 10             	add    $0x10,%esp
80101b4d:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101b52:	75 9d                	jne    80101af1 <namex+0x40>
    if(nameiparent && *path == '\0'){
80101b54:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b58:	74 b2                	je     80101b0c <namex+0x5b>
80101b5a:	80 3b 00             	cmpb   $0x0,(%ebx)
80101b5d:	75 ad                	jne    80101b0c <namex+0x5b>
      iunlock(ip);
80101b5f:	83 ec 0c             	sub    $0xc,%esp
80101b62:	56                   	push   %esi
80101b63:	e8 28 fb ff ff       	call   80101690 <iunlock>
      return ip;
80101b68:	83 c4 10             	add    $0x10,%esp
80101b6b:	eb 95                	jmp    80101b02 <namex+0x51>
      iunlockput(ip);
80101b6d:	83 ec 0c             	sub    $0xc,%esp
80101b70:	56                   	push   %esi
80101b71:	e8 07 fc ff ff       	call   8010177d <iunlockput>
      return 0;
80101b76:	83 c4 10             	add    $0x10,%esp
80101b79:	89 fe                	mov    %edi,%esi
80101b7b:	eb 85                	jmp    80101b02 <namex+0x51>
  if(nameiparent){
80101b7d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
80101b81:	0f 84 7b ff ff ff    	je     80101b02 <namex+0x51>
    iput(ip);
80101b87:	83 ec 0c             	sub    $0xc,%esp
80101b8a:	56                   	push   %esi
80101b8b:	e8 49 fb ff ff       	call   801016d9 <iput>
    return 0;
80101b90:	83 c4 10             	add    $0x10,%esp
80101b93:	89 de                	mov    %ebx,%esi
80101b95:	e9 68 ff ff ff       	jmp    80101b02 <namex+0x51>

80101b9a <dirlink>:
{
80101b9a:	f3 0f 1e fb          	endbr32 
80101b9e:	55                   	push   %ebp
80101b9f:	89 e5                	mov    %esp,%ebp
80101ba1:	57                   	push   %edi
80101ba2:	56                   	push   %esi
80101ba3:	53                   	push   %ebx
80101ba4:	83 ec 20             	sub    $0x20,%esp
80101ba7:	8b 5d 08             	mov    0x8(%ebp),%ebx
80101baa:	8b 7d 0c             	mov    0xc(%ebp),%edi
  if((ip = dirlookup(dp, name, 0)) != 0){
80101bad:	6a 00                	push   $0x0
80101baf:	57                   	push   %edi
80101bb0:	53                   	push   %ebx
80101bb1:	e8 63 fe ff ff       	call   80101a19 <dirlookup>
80101bb6:	83 c4 10             	add    $0x10,%esp
80101bb9:	85 c0                	test   %eax,%eax
80101bbb:	75 07                	jne    80101bc4 <dirlink+0x2a>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101bbd:	b8 00 00 00 00       	mov    $0x0,%eax
80101bc2:	eb 23                	jmp    80101be7 <dirlink+0x4d>
    iput(ip);
80101bc4:	83 ec 0c             	sub    $0xc,%esp
80101bc7:	50                   	push   %eax
80101bc8:	e8 0c fb ff ff       	call   801016d9 <iput>
    return -1;
80101bcd:	83 c4 10             	add    $0x10,%esp
80101bd0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101bd5:	eb 63                	jmp    80101c3a <dirlink+0xa0>
      panic("dirlink read");
80101bd7:	83 ec 0c             	sub    $0xc,%esp
80101bda:	68 e8 67 10 80       	push   $0x801067e8
80101bdf:	e8 78 e7 ff ff       	call   8010035c <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101be4:	8d 46 10             	lea    0x10(%esi),%eax
80101be7:	89 c6                	mov    %eax,%esi
80101be9:	39 43 58             	cmp    %eax,0x58(%ebx)
80101bec:	76 1c                	jbe    80101c0a <dirlink+0x70>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bee:	6a 10                	push   $0x10
80101bf0:	50                   	push   %eax
80101bf1:	8d 45 d8             	lea    -0x28(%ebp),%eax
80101bf4:	50                   	push   %eax
80101bf5:	53                   	push   %ebx
80101bf6:	e8 d5 fb ff ff       	call   801017d0 <readi>
80101bfb:	83 c4 10             	add    $0x10,%esp
80101bfe:	83 f8 10             	cmp    $0x10,%eax
80101c01:	75 d4                	jne    80101bd7 <dirlink+0x3d>
    if(de.inum == 0)
80101c03:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c08:	75 da                	jne    80101be4 <dirlink+0x4a>
  strncpy(de.name, name, DIRSIZ);
80101c0a:	83 ec 04             	sub    $0x4,%esp
80101c0d:	6a 0e                	push   $0xe
80101c0f:	57                   	push   %edi
80101c10:	8d 7d d8             	lea    -0x28(%ebp),%edi
80101c13:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c16:	50                   	push   %eax
80101c17:	e8 9a 22 00 00       	call   80103eb6 <strncpy>
  de.inum = inum;
80101c1c:	8b 45 10             	mov    0x10(%ebp),%eax
80101c1f:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c23:	6a 10                	push   $0x10
80101c25:	56                   	push   %esi
80101c26:	57                   	push   %edi
80101c27:	53                   	push   %ebx
80101c28:	e8 a4 fc ff ff       	call   801018d1 <writei>
80101c2d:	83 c4 20             	add    $0x20,%esp
80101c30:	83 f8 10             	cmp    $0x10,%eax
80101c33:	75 0d                	jne    80101c42 <dirlink+0xa8>
  return 0;
80101c35:	b8 00 00 00 00       	mov    $0x0,%eax
}
80101c3a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c3d:	5b                   	pop    %ebx
80101c3e:	5e                   	pop    %esi
80101c3f:	5f                   	pop    %edi
80101c40:	5d                   	pop    %ebp
80101c41:	c3                   	ret    
    panic("dirlink");
80101c42:	83 ec 0c             	sub    $0xc,%esp
80101c45:	68 d4 6d 10 80       	push   $0x80106dd4
80101c4a:	e8 0d e7 ff ff       	call   8010035c <panic>

80101c4f <namei>:

struct inode*
namei(char *path)
{
80101c4f:	f3 0f 1e fb          	endbr32 
80101c53:	55                   	push   %ebp
80101c54:	89 e5                	mov    %esp,%ebp
80101c56:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101c59:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101c5c:	ba 00 00 00 00       	mov    $0x0,%edx
80101c61:	8b 45 08             	mov    0x8(%ebp),%eax
80101c64:	e8 48 fe ff ff       	call   80101ab1 <namex>
}
80101c69:	c9                   	leave  
80101c6a:	c3                   	ret    

80101c6b <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101c6b:	f3 0f 1e fb          	endbr32 
80101c6f:	55                   	push   %ebp
80101c70:	89 e5                	mov    %esp,%ebp
80101c72:	83 ec 08             	sub    $0x8,%esp
  return namex(path, 1, name);
80101c75:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101c78:	ba 01 00 00 00       	mov    $0x1,%edx
80101c7d:	8b 45 08             	mov    0x8(%ebp),%eax
80101c80:	e8 2c fe ff ff       	call   80101ab1 <namex>
}
80101c85:	c9                   	leave  
80101c86:	c3                   	ret    

80101c87 <idewait>:
static void idestart(struct buf*);

// Wait for IDE disk to become ready.
static int
idewait(int checkerr)
{
80101c87:	89 c1                	mov    %eax,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101c89:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101c8e:	ec                   	in     (%dx),%al
80101c8f:	89 c2                	mov    %eax,%edx
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101c91:	83 e0 c0             	and    $0xffffffc0,%eax
80101c94:	3c 40                	cmp    $0x40,%al
80101c96:	75 f1                	jne    80101c89 <idewait+0x2>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
80101c98:	85 c9                	test   %ecx,%ecx
80101c9a:	74 0a                	je     80101ca6 <idewait+0x1f>
80101c9c:	f6 c2 21             	test   $0x21,%dl
80101c9f:	75 08                	jne    80101ca9 <idewait+0x22>
    return -1;
  return 0;
80101ca1:	b9 00 00 00 00       	mov    $0x0,%ecx
}
80101ca6:	89 c8                	mov    %ecx,%eax
80101ca8:	c3                   	ret    
    return -1;
80101ca9:	b9 ff ff ff ff       	mov    $0xffffffff,%ecx
80101cae:	eb f6                	jmp    80101ca6 <idewait+0x1f>

80101cb0 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101cb0:	55                   	push   %ebp
80101cb1:	89 e5                	mov    %esp,%ebp
80101cb3:	56                   	push   %esi
80101cb4:	53                   	push   %ebx
  if(b == 0)
80101cb5:	85 c0                	test   %eax,%eax
80101cb7:	0f 84 91 00 00 00    	je     80101d4e <idestart+0x9e>
80101cbd:	89 c6                	mov    %eax,%esi
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101cbf:	8b 58 08             	mov    0x8(%eax),%ebx
80101cc2:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101cc8:	0f 87 8d 00 00 00    	ja     80101d5b <idestart+0xab>
  int read_cmd = (sector_per_block == 1) ? IDE_CMD_READ :  IDE_CMD_RDMUL;
  int write_cmd = (sector_per_block == 1) ? IDE_CMD_WRITE : IDE_CMD_WRMUL;

  if (sector_per_block > 7) panic("idestart");

  idewait(0);
80101cce:	b8 00 00 00 00       	mov    $0x0,%eax
80101cd3:	e8 af ff ff ff       	call   80101c87 <idewait>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101cd8:	b8 00 00 00 00       	mov    $0x0,%eax
80101cdd:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101ce2:	ee                   	out    %al,(%dx)
80101ce3:	b8 01 00 00 00       	mov    $0x1,%eax
80101ce8:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101ced:	ee                   	out    %al,(%dx)
80101cee:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101cf3:	89 d8                	mov    %ebx,%eax
80101cf5:	ee                   	out    %al,(%dx)
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101cf6:	89 d8                	mov    %ebx,%eax
80101cf8:	c1 f8 08             	sar    $0x8,%eax
80101cfb:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101d00:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
80101d01:	89 d8                	mov    %ebx,%eax
80101d03:	c1 f8 10             	sar    $0x10,%eax
80101d06:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101d0b:	ee                   	out    %al,(%dx)
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101d0c:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101d10:	c1 e0 04             	shl    $0x4,%eax
80101d13:	83 e0 10             	and    $0x10,%eax
80101d16:	c1 fb 18             	sar    $0x18,%ebx
80101d19:	83 e3 0f             	and    $0xf,%ebx
80101d1c:	09 d8                	or     %ebx,%eax
80101d1e:	83 c8 e0             	or     $0xffffffe0,%eax
80101d21:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101d26:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101d27:	f6 06 04             	testb  $0x4,(%esi)
80101d2a:	74 3c                	je     80101d68 <idestart+0xb8>
80101d2c:	b8 30 00 00 00       	mov    $0x30,%eax
80101d31:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d36:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101d37:	83 c6 5c             	add    $0x5c,%esi
  asm volatile("cld; rep outsl" :
80101d3a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101d3f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101d44:	fc                   	cld    
80101d45:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101d47:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101d4a:	5b                   	pop    %ebx
80101d4b:	5e                   	pop    %esi
80101d4c:	5d                   	pop    %ebp
80101d4d:	c3                   	ret    
    panic("idestart");
80101d4e:	83 ec 0c             	sub    $0xc,%esp
80101d51:	68 4b 68 10 80       	push   $0x8010684b
80101d56:	e8 01 e6 ff ff       	call   8010035c <panic>
    panic("incorrect blockno");
80101d5b:	83 ec 0c             	sub    $0xc,%esp
80101d5e:	68 54 68 10 80       	push   $0x80106854
80101d63:	e8 f4 e5 ff ff       	call   8010035c <panic>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101d68:	b8 20 00 00 00       	mov    $0x20,%eax
80101d6d:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101d72:	ee                   	out    %al,(%dx)
}
80101d73:	eb d2                	jmp    80101d47 <idestart+0x97>

80101d75 <ideinit>:
{
80101d75:	f3 0f 1e fb          	endbr32 
80101d79:	55                   	push   %ebp
80101d7a:	89 e5                	mov    %esp,%ebp
80101d7c:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80101d7f:	68 66 68 10 80       	push   $0x80106866
80101d84:	68 80 a5 10 80       	push   $0x8010a580
80101d89:	e8 f1 1d 00 00       	call   80103b7f <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101d8e:	83 c4 08             	add    $0x8,%esp
80101d91:	a1 00 2d 11 80       	mov    0x80112d00,%eax
80101d96:	83 e8 01             	sub    $0x1,%eax
80101d99:	50                   	push   %eax
80101d9a:	6a 0e                	push   $0xe
80101d9c:	e8 5a 02 00 00       	call   80101ffb <ioapicenable>
  idewait(0);
80101da1:	b8 00 00 00 00       	mov    $0x0,%eax
80101da6:	e8 dc fe ff ff       	call   80101c87 <idewait>
80101dab:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80101db0:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101db5:	ee                   	out    %al,(%dx)
  for(i=0; i<1000; i++){
80101db6:	83 c4 10             	add    $0x10,%esp
80101db9:	b9 00 00 00 00       	mov    $0x0,%ecx
80101dbe:	eb 03                	jmp    80101dc3 <ideinit+0x4e>
80101dc0:	83 c1 01             	add    $0x1,%ecx
80101dc3:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101dc9:	7f 14                	jg     80101ddf <ideinit+0x6a>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101dcb:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101dd0:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80101dd1:	84 c0                	test   %al,%al
80101dd3:	74 eb                	je     80101dc0 <ideinit+0x4b>
      havedisk1 = 1;
80101dd5:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80101ddc:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101ddf:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80101de4:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101de9:	ee                   	out    %al,(%dx)
}
80101dea:	c9                   	leave  
80101deb:	c3                   	ret    

80101dec <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
80101dec:	f3 0f 1e fb          	endbr32 
80101df0:	55                   	push   %ebp
80101df1:	89 e5                	mov    %esp,%ebp
80101df3:	57                   	push   %edi
80101df4:	53                   	push   %ebx
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80101df5:	83 ec 0c             	sub    $0xc,%esp
80101df8:	68 80 a5 10 80       	push   $0x8010a580
80101dfd:	e8 cd 1e 00 00       	call   80103ccf <acquire>

  if((b = idequeue) == 0){
80101e02:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
80101e08:	83 c4 10             	add    $0x10,%esp
80101e0b:	85 db                	test   %ebx,%ebx
80101e0d:	74 48                	je     80101e57 <ideintr+0x6b>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80101e0f:	8b 43 58             	mov    0x58(%ebx),%eax
80101e12:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e17:	f6 03 04             	testb  $0x4,(%ebx)
80101e1a:	74 4d                	je     80101e69 <ideintr+0x7d>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
80101e1c:	8b 03                	mov    (%ebx),%eax
80101e1e:	83 c8 02             	or     $0x2,%eax
  b->flags &= ~B_DIRTY;
80101e21:	83 e0 fb             	and    $0xfffffffb,%eax
80101e24:	89 03                	mov    %eax,(%ebx)
  wakeup(b);
80101e26:	83 ec 0c             	sub    $0xc,%esp
80101e29:	53                   	push   %ebx
80101e2a:	e8 d5 1a 00 00       	call   80103904 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80101e2f:	a1 64 a5 10 80       	mov    0x8010a564,%eax
80101e34:	83 c4 10             	add    $0x10,%esp
80101e37:	85 c0                	test   %eax,%eax
80101e39:	74 05                	je     80101e40 <ideintr+0x54>
    idestart(idequeue);
80101e3b:	e8 70 fe ff ff       	call   80101cb0 <idestart>

  release(&idelock);
80101e40:	83 ec 0c             	sub    $0xc,%esp
80101e43:	68 80 a5 10 80       	push   $0x8010a580
80101e48:	e8 eb 1e 00 00       	call   80103d38 <release>
80101e4d:	83 c4 10             	add    $0x10,%esp
}
80101e50:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101e53:	5b                   	pop    %ebx
80101e54:	5f                   	pop    %edi
80101e55:	5d                   	pop    %ebp
80101e56:	c3                   	ret    
    release(&idelock);
80101e57:	83 ec 0c             	sub    $0xc,%esp
80101e5a:	68 80 a5 10 80       	push   $0x8010a580
80101e5f:	e8 d4 1e 00 00       	call   80103d38 <release>
    return;
80101e64:	83 c4 10             	add    $0x10,%esp
80101e67:	eb e7                	jmp    80101e50 <ideintr+0x64>
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80101e69:	b8 01 00 00 00       	mov    $0x1,%eax
80101e6e:	e8 14 fe ff ff       	call   80101c87 <idewait>
80101e73:	85 c0                	test   %eax,%eax
80101e75:	78 a5                	js     80101e1c <ideintr+0x30>
    insl(0x1f0, b->data, BSIZE/4);
80101e77:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80101e7a:	b9 80 00 00 00       	mov    $0x80,%ecx
80101e7f:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101e84:	fc                   	cld    
80101e85:	f3 6d                	rep insl (%dx),%es:(%edi)
}
80101e87:	eb 93                	jmp    80101e1c <ideintr+0x30>

80101e89 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80101e89:	f3 0f 1e fb          	endbr32 
80101e8d:	55                   	push   %ebp
80101e8e:	89 e5                	mov    %esp,%ebp
80101e90:	53                   	push   %ebx
80101e91:	83 ec 10             	sub    $0x10,%esp
80101e94:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
80101e97:	8d 43 0c             	lea    0xc(%ebx),%eax
80101e9a:	50                   	push   %eax
80101e9b:	e8 8d 1c 00 00       	call   80103b2d <holdingsleep>
80101ea0:	83 c4 10             	add    $0x10,%esp
80101ea3:	85 c0                	test   %eax,%eax
80101ea5:	74 37                	je     80101ede <iderw+0x55>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
80101ea7:	8b 03                	mov    (%ebx),%eax
80101ea9:	83 e0 06             	and    $0x6,%eax
80101eac:	83 f8 02             	cmp    $0x2,%eax
80101eaf:	74 3a                	je     80101eeb <iderw+0x62>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
80101eb1:	83 7b 04 00          	cmpl   $0x0,0x4(%ebx)
80101eb5:	74 09                	je     80101ec0 <iderw+0x37>
80101eb7:	83 3d 60 a5 10 80 00 	cmpl   $0x0,0x8010a560
80101ebe:	74 38                	je     80101ef8 <iderw+0x6f>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80101ec0:	83 ec 0c             	sub    $0xc,%esp
80101ec3:	68 80 a5 10 80       	push   $0x8010a580
80101ec8:	e8 02 1e 00 00       	call   80103ccf <acquire>

  // Append b to idequeue.
  b->qnext = 0;
80101ecd:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101ed4:	83 c4 10             	add    $0x10,%esp
80101ed7:	ba 64 a5 10 80       	mov    $0x8010a564,%edx
80101edc:	eb 2a                	jmp    80101f08 <iderw+0x7f>
    panic("iderw: buf not locked");
80101ede:	83 ec 0c             	sub    $0xc,%esp
80101ee1:	68 6a 68 10 80       	push   $0x8010686a
80101ee6:	e8 71 e4 ff ff       	call   8010035c <panic>
    panic("iderw: nothing to do");
80101eeb:	83 ec 0c             	sub    $0xc,%esp
80101eee:	68 80 68 10 80       	push   $0x80106880
80101ef3:	e8 64 e4 ff ff       	call   8010035c <panic>
    panic("iderw: ide disk 1 not present");
80101ef8:	83 ec 0c             	sub    $0xc,%esp
80101efb:	68 95 68 10 80       	push   $0x80106895
80101f00:	e8 57 e4 ff ff       	call   8010035c <panic>
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80101f05:	8d 50 58             	lea    0x58(%eax),%edx
80101f08:	8b 02                	mov    (%edx),%eax
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	75 f7                	jne    80101f05 <iderw+0x7c>
    ;
  *pp = b;
80101f0e:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80101f10:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
80101f16:	75 1a                	jne    80101f32 <iderw+0xa9>
    idestart(b);
80101f18:	89 d8                	mov    %ebx,%eax
80101f1a:	e8 91 fd ff ff       	call   80101cb0 <idestart>
80101f1f:	eb 11                	jmp    80101f32 <iderw+0xa9>

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
80101f21:	83 ec 08             	sub    $0x8,%esp
80101f24:	68 80 a5 10 80       	push   $0x8010a580
80101f29:	53                   	push   %ebx
80101f2a:	e8 65 18 00 00       	call   80103794 <sleep>
80101f2f:	83 c4 10             	add    $0x10,%esp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80101f32:	8b 03                	mov    (%ebx),%eax
80101f34:	83 e0 06             	and    $0x6,%eax
80101f37:	83 f8 02             	cmp    $0x2,%eax
80101f3a:	75 e5                	jne    80101f21 <iderw+0x98>
  }


  release(&idelock);
80101f3c:	83 ec 0c             	sub    $0xc,%esp
80101f3f:	68 80 a5 10 80       	push   $0x8010a580
80101f44:	e8 ef 1d 00 00       	call   80103d38 <release>
}
80101f49:	83 c4 10             	add    $0x10,%esp
80101f4c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101f4f:	c9                   	leave  
80101f50:	c3                   	ret    

80101f51 <ioapicread>:
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80101f51:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80101f57:	89 02                	mov    %eax,(%edx)
  return ioapic->data;
80101f59:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f5e:	8b 40 10             	mov    0x10(%eax),%eax
}
80101f61:	c3                   	ret    

80101f62 <ioapicwrite>:

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80101f62:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
80101f68:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80101f6a:	a1 34 26 11 80       	mov    0x80112634,%eax
80101f6f:	89 50 10             	mov    %edx,0x10(%eax)
}
80101f72:	c3                   	ret    

80101f73 <ioapicinit>:

void
ioapicinit(void)
{
80101f73:	f3 0f 1e fb          	endbr32 
80101f77:	55                   	push   %ebp
80101f78:	89 e5                	mov    %esp,%ebp
80101f7a:	57                   	push   %edi
80101f7b:	56                   	push   %esi
80101f7c:	53                   	push   %ebx
80101f7d:	83 ec 0c             	sub    $0xc,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80101f80:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
80101f87:	00 c0 fe 
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80101f8a:	b8 01 00 00 00       	mov    $0x1,%eax
80101f8f:	e8 bd ff ff ff       	call   80101f51 <ioapicread>
80101f94:	c1 e8 10             	shr    $0x10,%eax
80101f97:	0f b6 f8             	movzbl %al,%edi
  id = ioapicread(REG_ID) >> 24;
80101f9a:	b8 00 00 00 00       	mov    $0x0,%eax
80101f9f:	e8 ad ff ff ff       	call   80101f51 <ioapicread>
80101fa4:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80101fa7:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
80101fae:	39 c2                	cmp    %eax,%edx
80101fb0:	75 2f                	jne    80101fe1 <ioapicinit+0x6e>
{
80101fb2:	bb 00 00 00 00       	mov    $0x0,%ebx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
80101fb7:	39 fb                	cmp    %edi,%ebx
80101fb9:	7f 38                	jg     80101ff3 <ioapicinit+0x80>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80101fbb:	8d 53 20             	lea    0x20(%ebx),%edx
80101fbe:	81 ca 00 00 01 00    	or     $0x10000,%edx
80101fc4:	8d 74 1b 10          	lea    0x10(%ebx,%ebx,1),%esi
80101fc8:	89 f0                	mov    %esi,%eax
80101fca:	e8 93 ff ff ff       	call   80101f62 <ioapicwrite>
    ioapicwrite(REG_TABLE+2*i+1, 0);
80101fcf:	8d 46 01             	lea    0x1(%esi),%eax
80101fd2:	ba 00 00 00 00       	mov    $0x0,%edx
80101fd7:	e8 86 ff ff ff       	call   80101f62 <ioapicwrite>
  for(i = 0; i <= maxintr; i++){
80101fdc:	83 c3 01             	add    $0x1,%ebx
80101fdf:	eb d6                	jmp    80101fb7 <ioapicinit+0x44>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80101fe1:	83 ec 0c             	sub    $0xc,%esp
80101fe4:	68 b4 68 10 80       	push   $0x801068b4
80101fe9:	e8 3b e6 ff ff       	call   80100629 <cprintf>
80101fee:	83 c4 10             	add    $0x10,%esp
80101ff1:	eb bf                	jmp    80101fb2 <ioapicinit+0x3f>
  }
}
80101ff3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101ff6:	5b                   	pop    %ebx
80101ff7:	5e                   	pop    %esi
80101ff8:	5f                   	pop    %edi
80101ff9:	5d                   	pop    %ebp
80101ffa:	c3                   	ret    

80101ffb <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80101ffb:	f3 0f 1e fb          	endbr32 
80101fff:	55                   	push   %ebp
80102000:	89 e5                	mov    %esp,%ebp
80102002:	53                   	push   %ebx
80102003:	83 ec 04             	sub    $0x4,%esp
80102006:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
80102009:	8d 50 20             	lea    0x20(%eax),%edx
8010200c:	8d 5c 00 10          	lea    0x10(%eax,%eax,1),%ebx
80102010:	89 d8                	mov    %ebx,%eax
80102012:	e8 4b ff ff ff       	call   80101f62 <ioapicwrite>
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102017:	8b 55 0c             	mov    0xc(%ebp),%edx
8010201a:	c1 e2 18             	shl    $0x18,%edx
8010201d:	8d 43 01             	lea    0x1(%ebx),%eax
80102020:	e8 3d ff ff ff       	call   80101f62 <ioapicwrite>
}
80102025:	83 c4 04             	add    $0x4,%esp
80102028:	5b                   	pop    %ebx
80102029:	5d                   	pop    %ebp
8010202a:	c3                   	ret    

8010202b <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
8010202b:	f3 0f 1e fb          	endbr32 
8010202f:	55                   	push   %ebp
80102030:	89 e5                	mov    %esp,%ebp
80102032:	53                   	push   %ebx
80102033:	83 ec 04             	sub    $0x4,%esp
80102036:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
80102039:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
8010203f:	75 4c                	jne    8010208d <kfree+0x62>
80102041:	81 fb a8 56 11 80    	cmp    $0x801156a8,%ebx
80102047:	72 44                	jb     8010208d <kfree+0x62>
80102049:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010204f:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102054:	77 37                	ja     8010208d <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102056:	83 ec 04             	sub    $0x4,%esp
80102059:	68 00 10 00 00       	push   $0x1000
8010205e:	6a 01                	push   $0x1
80102060:	53                   	push   %ebx
80102061:	e8 1d 1d 00 00       	call   80103d83 <memset>

  if(kmem.use_lock)
80102066:	83 c4 10             	add    $0x10,%esp
80102069:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102070:	75 28                	jne    8010209a <kfree+0x6f>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102072:	a1 78 26 11 80       	mov    0x80112678,%eax
80102077:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
80102079:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010207f:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102086:	75 24                	jne    801020ac <kfree+0x81>
    release(&kmem.lock);
}
80102088:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010208b:	c9                   	leave  
8010208c:	c3                   	ret    
    panic("kfree");
8010208d:	83 ec 0c             	sub    $0xc,%esp
80102090:	68 e6 68 10 80       	push   $0x801068e6
80102095:	e8 c2 e2 ff ff       	call   8010035c <panic>
    acquire(&kmem.lock);
8010209a:	83 ec 0c             	sub    $0xc,%esp
8010209d:	68 40 26 11 80       	push   $0x80112640
801020a2:	e8 28 1c 00 00       	call   80103ccf <acquire>
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	eb c6                	jmp    80102072 <kfree+0x47>
    release(&kmem.lock);
801020ac:	83 ec 0c             	sub    $0xc,%esp
801020af:	68 40 26 11 80       	push   $0x80112640
801020b4:	e8 7f 1c 00 00       	call   80103d38 <release>
801020b9:	83 c4 10             	add    $0x10,%esp
}
801020bc:	eb ca                	jmp    80102088 <kfree+0x5d>

801020be <freerange>:
{
801020be:	f3 0f 1e fb          	endbr32 
801020c2:	55                   	push   %ebp
801020c3:	89 e5                	mov    %esp,%ebp
801020c5:	56                   	push   %esi
801020c6:	53                   	push   %ebx
801020c7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  p = (char*)PGROUNDUP((uint)vstart);
801020ca:	8b 45 08             	mov    0x8(%ebp),%eax
801020cd:	05 ff 0f 00 00       	add    $0xfff,%eax
801020d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020d7:	8d b0 00 10 00 00    	lea    0x1000(%eax),%esi
801020dd:	39 de                	cmp    %ebx,%esi
801020df:	77 10                	ja     801020f1 <freerange+0x33>
    kfree(p);
801020e1:	83 ec 0c             	sub    $0xc,%esp
801020e4:	50                   	push   %eax
801020e5:	e8 41 ff ff ff       	call   8010202b <kfree>
801020ea:	83 c4 10             	add    $0x10,%esp
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801020ed:	89 f0                	mov    %esi,%eax
801020ef:	eb e6                	jmp    801020d7 <freerange+0x19>
}
801020f1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801020f4:	5b                   	pop    %ebx
801020f5:	5e                   	pop    %esi
801020f6:	5d                   	pop    %ebp
801020f7:	c3                   	ret    

801020f8 <kinit1>:
{
801020f8:	f3 0f 1e fb          	endbr32 
801020fc:	55                   	push   %ebp
801020fd:	89 e5                	mov    %esp,%ebp
801020ff:	83 ec 10             	sub    $0x10,%esp
  initlock(&kmem.lock, "kmem");
80102102:	68 ec 68 10 80       	push   $0x801068ec
80102107:	68 40 26 11 80       	push   $0x80112640
8010210c:	e8 6e 1a 00 00       	call   80103b7f <initlock>
  kmem.use_lock = 0;
80102111:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102118:	00 00 00 
  freerange(vstart, vend);
8010211b:	83 c4 08             	add    $0x8,%esp
8010211e:	ff 75 0c             	pushl  0xc(%ebp)
80102121:	ff 75 08             	pushl  0x8(%ebp)
80102124:	e8 95 ff ff ff       	call   801020be <freerange>
}
80102129:	83 c4 10             	add    $0x10,%esp
8010212c:	c9                   	leave  
8010212d:	c3                   	ret    

8010212e <kinit2>:
{
8010212e:	f3 0f 1e fb          	endbr32 
80102132:	55                   	push   %ebp
80102133:	89 e5                	mov    %esp,%ebp
80102135:	83 ec 10             	sub    $0x10,%esp
  freerange(vstart, vend);
80102138:	ff 75 0c             	pushl  0xc(%ebp)
8010213b:	ff 75 08             	pushl  0x8(%ebp)
8010213e:	e8 7b ff ff ff       	call   801020be <freerange>
  kmem.use_lock = 1;
80102143:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
8010214a:	00 00 00 
}
8010214d:	83 c4 10             	add    $0x10,%esp
80102150:	c9                   	leave  
80102151:	c3                   	ret    

80102152 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102152:	f3 0f 1e fb          	endbr32 
80102156:	55                   	push   %ebp
80102157:	89 e5                	mov    %esp,%ebp
80102159:	53                   	push   %ebx
8010215a:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
8010215d:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
80102164:	75 21                	jne    80102187 <kalloc+0x35>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102166:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
8010216c:	85 db                	test   %ebx,%ebx
8010216e:	74 07                	je     80102177 <kalloc+0x25>
    kmem.freelist = r->next;
80102170:	8b 03                	mov    (%ebx),%eax
80102172:	a3 78 26 11 80       	mov    %eax,0x80112678
  if(kmem.use_lock)
80102177:	83 3d 74 26 11 80 00 	cmpl   $0x0,0x80112674
8010217e:	75 19                	jne    80102199 <kalloc+0x47>
    release(&kmem.lock);
  return (char*)r;
}
80102180:	89 d8                	mov    %ebx,%eax
80102182:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102185:	c9                   	leave  
80102186:	c3                   	ret    
    acquire(&kmem.lock);
80102187:	83 ec 0c             	sub    $0xc,%esp
8010218a:	68 40 26 11 80       	push   $0x80112640
8010218f:	e8 3b 1b 00 00       	call   80103ccf <acquire>
80102194:	83 c4 10             	add    $0x10,%esp
80102197:	eb cd                	jmp    80102166 <kalloc+0x14>
    release(&kmem.lock);
80102199:	83 ec 0c             	sub    $0xc,%esp
8010219c:	68 40 26 11 80       	push   $0x80112640
801021a1:	e8 92 1b 00 00       	call   80103d38 <release>
801021a6:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
801021a9:	eb d5                	jmp    80102180 <kalloc+0x2e>

801021ab <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
801021ab:	f3 0f 1e fb          	endbr32 
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021af:	ba 64 00 00 00       	mov    $0x64,%edx
801021b4:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801021b5:	a8 01                	test   $0x1,%al
801021b7:	0f 84 ad 00 00 00    	je     8010226a <kbdgetc+0xbf>
801021bd:	ba 60 00 00 00       	mov    $0x60,%edx
801021c2:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
801021c3:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
801021c6:	3c e0                	cmp    $0xe0,%al
801021c8:	74 5b                	je     80102225 <kbdgetc+0x7a>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
801021ca:	84 c0                	test   %al,%al
801021cc:	78 64                	js     80102232 <kbdgetc+0x87>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801021ce:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
801021d4:	f6 c1 40             	test   $0x40,%cl
801021d7:	74 0f                	je     801021e8 <kbdgetc+0x3d>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801021d9:	83 c8 80             	or     $0xffffff80,%eax
801021dc:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
801021df:	83 e1 bf             	and    $0xffffffbf,%ecx
801021e2:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  }

  shift |= shiftcode[data];
801021e8:	0f b6 8a 20 6a 10 80 	movzbl -0x7fef95e0(%edx),%ecx
801021ef:	0b 0d b4 a5 10 80    	or     0x8010a5b4,%ecx
  shift ^= togglecode[data];
801021f5:	0f b6 82 20 69 10 80 	movzbl -0x7fef96e0(%edx),%eax
801021fc:	31 c1                	xor    %eax,%ecx
801021fe:	89 0d b4 a5 10 80    	mov    %ecx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
80102204:	89 c8                	mov    %ecx,%eax
80102206:	83 e0 03             	and    $0x3,%eax
80102209:	8b 04 85 00 69 10 80 	mov    -0x7fef9700(,%eax,4),%eax
80102210:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102214:	f6 c1 08             	test   $0x8,%cl
80102217:	74 56                	je     8010226f <kbdgetc+0xc4>
    if('a' <= c && c <= 'z')
80102219:	8d 50 9f             	lea    -0x61(%eax),%edx
8010221c:	83 fa 19             	cmp    $0x19,%edx
8010221f:	77 3d                	ja     8010225e <kbdgetc+0xb3>
      c += 'A' - 'a';
80102221:	83 e8 20             	sub    $0x20,%eax
80102224:	c3                   	ret    
    shift |= E0ESC;
80102225:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
8010222c:	b8 00 00 00 00       	mov    $0x0,%eax
80102231:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102232:	8b 0d b4 a5 10 80    	mov    0x8010a5b4,%ecx
80102238:	f6 c1 40             	test   $0x40,%cl
8010223b:	75 05                	jne    80102242 <kbdgetc+0x97>
8010223d:	89 c2                	mov    %eax,%edx
8010223f:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102242:	0f b6 82 20 6a 10 80 	movzbl -0x7fef95e0(%edx),%eax
80102249:	83 c8 40             	or     $0x40,%eax
8010224c:	0f b6 c0             	movzbl %al,%eax
8010224f:	f7 d0                	not    %eax
80102251:	21 c8                	and    %ecx,%eax
80102253:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
80102258:	b8 00 00 00 00       	mov    $0x0,%eax
8010225d:	c3                   	ret    
    else if('A' <= c && c <= 'Z')
8010225e:	8d 50 bf             	lea    -0x41(%eax),%edx
80102261:	83 fa 19             	cmp    $0x19,%edx
80102264:	77 09                	ja     8010226f <kbdgetc+0xc4>
      c += 'a' - 'A';
80102266:	83 c0 20             	add    $0x20,%eax
  }
  return c;
80102269:	c3                   	ret    
    return -1;
8010226a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010226f:	c3                   	ret    

80102270 <kbdintr>:

void
kbdintr(void)
{
80102270:	f3 0f 1e fb          	endbr32 
80102274:	55                   	push   %ebp
80102275:	89 e5                	mov    %esp,%ebp
80102277:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
8010227a:	68 ab 21 10 80       	push   $0x801021ab
8010227f:	e8 d5 e4 ff ff       	call   80100759 <consoleintr>
}
80102284:	83 c4 10             	add    $0x10,%esp
80102287:	c9                   	leave  
80102288:	c3                   	ret    

80102289 <lapicw>:

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102289:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
8010228f:	8d 04 81             	lea    (%ecx,%eax,4),%eax
80102292:	89 10                	mov    %edx,(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102294:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102299:	8b 40 20             	mov    0x20(%eax),%eax
}
8010229c:	c3                   	ret    

8010229d <cmos_read>:
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010229d:	ba 70 00 00 00       	mov    $0x70,%edx
801022a2:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022a3:	ba 71 00 00 00       	mov    $0x71,%edx
801022a8:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
801022a9:	0f b6 c0             	movzbl %al,%eax
}
801022ac:	c3                   	ret    

801022ad <fill_rtcdate>:

static void
fill_rtcdate(struct rtcdate *r)
{
801022ad:	55                   	push   %ebp
801022ae:	89 e5                	mov    %esp,%ebp
801022b0:	53                   	push   %ebx
801022b1:	83 ec 04             	sub    $0x4,%esp
801022b4:	89 c3                	mov    %eax,%ebx
  r->second = cmos_read(SECS);
801022b6:	b8 00 00 00 00       	mov    $0x0,%eax
801022bb:	e8 dd ff ff ff       	call   8010229d <cmos_read>
801022c0:	89 03                	mov    %eax,(%ebx)
  r->minute = cmos_read(MINS);
801022c2:	b8 02 00 00 00       	mov    $0x2,%eax
801022c7:	e8 d1 ff ff ff       	call   8010229d <cmos_read>
801022cc:	89 43 04             	mov    %eax,0x4(%ebx)
  r->hour   = cmos_read(HOURS);
801022cf:	b8 04 00 00 00       	mov    $0x4,%eax
801022d4:	e8 c4 ff ff ff       	call   8010229d <cmos_read>
801022d9:	89 43 08             	mov    %eax,0x8(%ebx)
  r->day    = cmos_read(DAY);
801022dc:	b8 07 00 00 00       	mov    $0x7,%eax
801022e1:	e8 b7 ff ff ff       	call   8010229d <cmos_read>
801022e6:	89 43 0c             	mov    %eax,0xc(%ebx)
  r->month  = cmos_read(MONTH);
801022e9:	b8 08 00 00 00       	mov    $0x8,%eax
801022ee:	e8 aa ff ff ff       	call   8010229d <cmos_read>
801022f3:	89 43 10             	mov    %eax,0x10(%ebx)
  r->year   = cmos_read(YEAR);
801022f6:	b8 09 00 00 00       	mov    $0x9,%eax
801022fb:	e8 9d ff ff ff       	call   8010229d <cmos_read>
80102300:	89 43 14             	mov    %eax,0x14(%ebx)
}
80102303:	83 c4 04             	add    $0x4,%esp
80102306:	5b                   	pop    %ebx
80102307:	5d                   	pop    %ebp
80102308:	c3                   	ret    

80102309 <lapicinit>:
{
80102309:	f3 0f 1e fb          	endbr32 
  if(!lapic)
8010230d:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
80102314:	0f 84 fe 00 00 00    	je     80102418 <lapicinit+0x10f>
{
8010231a:	55                   	push   %ebp
8010231b:	89 e5                	mov    %esp,%ebp
8010231d:	83 ec 08             	sub    $0x8,%esp
  lapicw(SVR, ENABLE | (T_IRQ0 + IRQ_SPURIOUS));
80102320:	ba 3f 01 00 00       	mov    $0x13f,%edx
80102325:	b8 3c 00 00 00       	mov    $0x3c,%eax
8010232a:	e8 5a ff ff ff       	call   80102289 <lapicw>
  lapicw(TDCR, X1);
8010232f:	ba 0b 00 00 00       	mov    $0xb,%edx
80102334:	b8 f8 00 00 00       	mov    $0xf8,%eax
80102339:	e8 4b ff ff ff       	call   80102289 <lapicw>
  lapicw(TIMER, PERIODIC | (T_IRQ0 + IRQ_TIMER));
8010233e:	ba 20 00 02 00       	mov    $0x20020,%edx
80102343:	b8 c8 00 00 00       	mov    $0xc8,%eax
80102348:	e8 3c ff ff ff       	call   80102289 <lapicw>
  lapicw(TICR, 10000000);
8010234d:	ba 80 96 98 00       	mov    $0x989680,%edx
80102352:	b8 e0 00 00 00       	mov    $0xe0,%eax
80102357:	e8 2d ff ff ff       	call   80102289 <lapicw>
  lapicw(LINT0, MASKED);
8010235c:	ba 00 00 01 00       	mov    $0x10000,%edx
80102361:	b8 d4 00 00 00       	mov    $0xd4,%eax
80102366:	e8 1e ff ff ff       	call   80102289 <lapicw>
  lapicw(LINT1, MASKED);
8010236b:	ba 00 00 01 00       	mov    $0x10000,%edx
80102370:	b8 d8 00 00 00       	mov    $0xd8,%eax
80102375:	e8 0f ff ff ff       	call   80102289 <lapicw>
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010237a:	a1 7c 26 11 80       	mov    0x8011267c,%eax
8010237f:	8b 40 30             	mov    0x30(%eax),%eax
80102382:	c1 e8 10             	shr    $0x10,%eax
80102385:	a8 fc                	test   $0xfc,%al
80102387:	75 7b                	jne    80102404 <lapicinit+0xfb>
  lapicw(ERROR, T_IRQ0 + IRQ_ERROR);
80102389:	ba 33 00 00 00       	mov    $0x33,%edx
8010238e:	b8 dc 00 00 00       	mov    $0xdc,%eax
80102393:	e8 f1 fe ff ff       	call   80102289 <lapicw>
  lapicw(ESR, 0);
80102398:	ba 00 00 00 00       	mov    $0x0,%edx
8010239d:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023a2:	e8 e2 fe ff ff       	call   80102289 <lapicw>
  lapicw(ESR, 0);
801023a7:	ba 00 00 00 00       	mov    $0x0,%edx
801023ac:	b8 a0 00 00 00       	mov    $0xa0,%eax
801023b1:	e8 d3 fe ff ff       	call   80102289 <lapicw>
  lapicw(EOI, 0);
801023b6:	ba 00 00 00 00       	mov    $0x0,%edx
801023bb:	b8 2c 00 00 00       	mov    $0x2c,%eax
801023c0:	e8 c4 fe ff ff       	call   80102289 <lapicw>
  lapicw(ICRHI, 0);
801023c5:	ba 00 00 00 00       	mov    $0x0,%edx
801023ca:	b8 c4 00 00 00       	mov    $0xc4,%eax
801023cf:	e8 b5 fe ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, BCAST | INIT | LEVEL);
801023d4:	ba 00 85 08 00       	mov    $0x88500,%edx
801023d9:	b8 c0 00 00 00       	mov    $0xc0,%eax
801023de:	e8 a6 fe ff ff       	call   80102289 <lapicw>
  while(lapic[ICRLO] & DELIVS)
801023e3:	a1 7c 26 11 80       	mov    0x8011267c,%eax
801023e8:	8b 80 00 03 00 00    	mov    0x300(%eax),%eax
801023ee:	f6 c4 10             	test   $0x10,%ah
801023f1:	75 f0                	jne    801023e3 <lapicinit+0xda>
  lapicw(TPR, 0);
801023f3:	ba 00 00 00 00       	mov    $0x0,%edx
801023f8:	b8 20 00 00 00       	mov    $0x20,%eax
801023fd:	e8 87 fe ff ff       	call   80102289 <lapicw>
}
80102402:	c9                   	leave  
80102403:	c3                   	ret    
    lapicw(PCINT, MASKED);
80102404:	ba 00 00 01 00       	mov    $0x10000,%edx
80102409:	b8 d0 00 00 00       	mov    $0xd0,%eax
8010240e:	e8 76 fe ff ff       	call   80102289 <lapicw>
80102413:	e9 71 ff ff ff       	jmp    80102389 <lapicinit+0x80>
80102418:	c3                   	ret    

80102419 <lapicid>:
{
80102419:	f3 0f 1e fb          	endbr32 
  if (!lapic)
8010241d:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80102422:	85 c0                	test   %eax,%eax
80102424:	74 07                	je     8010242d <lapicid+0x14>
  return lapic[ID] >> 24;
80102426:	8b 40 20             	mov    0x20(%eax),%eax
80102429:	c1 e8 18             	shr    $0x18,%eax
8010242c:	c3                   	ret    
    return 0;
8010242d:	b8 00 00 00 00       	mov    $0x0,%eax
}
80102432:	c3                   	ret    

80102433 <lapiceoi>:
{
80102433:	f3 0f 1e fb          	endbr32 
  if(lapic)
80102437:	83 3d 7c 26 11 80 00 	cmpl   $0x0,0x8011267c
8010243e:	74 17                	je     80102457 <lapiceoi+0x24>
{
80102440:	55                   	push   %ebp
80102441:	89 e5                	mov    %esp,%ebp
80102443:	83 ec 08             	sub    $0x8,%esp
    lapicw(EOI, 0);
80102446:	ba 00 00 00 00       	mov    $0x0,%edx
8010244b:	b8 2c 00 00 00       	mov    $0x2c,%eax
80102450:	e8 34 fe ff ff       	call   80102289 <lapicw>
}
80102455:	c9                   	leave  
80102456:	c3                   	ret    
80102457:	c3                   	ret    

80102458 <microdelay>:
{
80102458:	f3 0f 1e fb          	endbr32 
}
8010245c:	c3                   	ret    

8010245d <lapicstartap>:
{
8010245d:	f3 0f 1e fb          	endbr32 
80102461:	55                   	push   %ebp
80102462:	89 e5                	mov    %esp,%ebp
80102464:	57                   	push   %edi
80102465:	56                   	push   %esi
80102466:	53                   	push   %ebx
80102467:	83 ec 0c             	sub    $0xc,%esp
8010246a:	8b 75 08             	mov    0x8(%ebp),%esi
8010246d:	8b 7d 0c             	mov    0xc(%ebp),%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102470:	b8 0f 00 00 00       	mov    $0xf,%eax
80102475:	ba 70 00 00 00       	mov    $0x70,%edx
8010247a:	ee                   	out    %al,(%dx)
8010247b:	b8 0a 00 00 00       	mov    $0xa,%eax
80102480:	ba 71 00 00 00       	mov    $0x71,%edx
80102485:	ee                   	out    %al,(%dx)
  wrv[0] = 0;
80102486:	66 c7 05 67 04 00 80 	movw   $0x0,0x80000467
8010248d:	00 00 
  wrv[1] = addr >> 4;
8010248f:	89 f8                	mov    %edi,%eax
80102491:	c1 e8 04             	shr    $0x4,%eax
80102494:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapicw(ICRHI, apicid<<24);
8010249a:	c1 e6 18             	shl    $0x18,%esi
8010249d:	89 f2                	mov    %esi,%edx
8010249f:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024a4:	e8 e0 fd ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, INIT | LEVEL | ASSERT);
801024a9:	ba 00 c5 00 00       	mov    $0xc500,%edx
801024ae:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024b3:	e8 d1 fd ff ff       	call   80102289 <lapicw>
  lapicw(ICRLO, INIT | LEVEL);
801024b8:	ba 00 85 00 00       	mov    $0x8500,%edx
801024bd:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024c2:	e8 c2 fd ff ff       	call   80102289 <lapicw>
  for(i = 0; i < 2; i++){
801024c7:	bb 00 00 00 00       	mov    $0x0,%ebx
801024cc:	eb 21                	jmp    801024ef <lapicstartap+0x92>
    lapicw(ICRHI, apicid<<24);
801024ce:	89 f2                	mov    %esi,%edx
801024d0:	b8 c4 00 00 00       	mov    $0xc4,%eax
801024d5:	e8 af fd ff ff       	call   80102289 <lapicw>
    lapicw(ICRLO, STARTUP | (addr>>12));
801024da:	89 fa                	mov    %edi,%edx
801024dc:	c1 ea 0c             	shr    $0xc,%edx
801024df:	80 ce 06             	or     $0x6,%dh
801024e2:	b8 c0 00 00 00       	mov    $0xc0,%eax
801024e7:	e8 9d fd ff ff       	call   80102289 <lapicw>
  for(i = 0; i < 2; i++){
801024ec:	83 c3 01             	add    $0x1,%ebx
801024ef:	83 fb 01             	cmp    $0x1,%ebx
801024f2:	7e da                	jle    801024ce <lapicstartap+0x71>
}
801024f4:	83 c4 0c             	add    $0xc,%esp
801024f7:	5b                   	pop    %ebx
801024f8:	5e                   	pop    %esi
801024f9:	5f                   	pop    %edi
801024fa:	5d                   	pop    %ebp
801024fb:	c3                   	ret    

801024fc <cmostime>:

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801024fc:	f3 0f 1e fb          	endbr32 
80102500:	55                   	push   %ebp
80102501:	89 e5                	mov    %esp,%ebp
80102503:	57                   	push   %edi
80102504:	56                   	push   %esi
80102505:	53                   	push   %ebx
80102506:	83 ec 3c             	sub    $0x3c,%esp
80102509:	8b 75 08             	mov    0x8(%ebp),%esi
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);
8010250c:	b8 0b 00 00 00       	mov    $0xb,%eax
80102511:	e8 87 fd ff ff       	call   8010229d <cmos_read>

  bcd = (sb & (1 << 2)) == 0;
80102516:	83 e0 04             	and    $0x4,%eax
80102519:	89 c7                	mov    %eax,%edi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010251b:	8d 45 d0             	lea    -0x30(%ebp),%eax
8010251e:	e8 8a fd ff ff       	call   801022ad <fill_rtcdate>
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102523:	b8 0a 00 00 00       	mov    $0xa,%eax
80102528:	e8 70 fd ff ff       	call   8010229d <cmos_read>
8010252d:	a8 80                	test   $0x80,%al
8010252f:	75 ea                	jne    8010251b <cmostime+0x1f>
        continue;
    fill_rtcdate(&t2);
80102531:	8d 5d b8             	lea    -0x48(%ebp),%ebx
80102534:	89 d8                	mov    %ebx,%eax
80102536:	e8 72 fd ff ff       	call   801022ad <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010253b:	83 ec 04             	sub    $0x4,%esp
8010253e:	6a 18                	push   $0x18
80102540:	53                   	push   %ebx
80102541:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102544:	50                   	push   %eax
80102545:	e8 80 18 00 00       	call   80103dca <memcmp>
8010254a:	83 c4 10             	add    $0x10,%esp
8010254d:	85 c0                	test   %eax,%eax
8010254f:	75 ca                	jne    8010251b <cmostime+0x1f>
      break;
  }

  // convert
  if(bcd) {
80102551:	85 ff                	test   %edi,%edi
80102553:	75 78                	jne    801025cd <cmostime+0xd1>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102555:	8b 45 d0             	mov    -0x30(%ebp),%eax
80102558:	89 c2                	mov    %eax,%edx
8010255a:	c1 ea 04             	shr    $0x4,%edx
8010255d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102560:	83 e0 0f             	and    $0xf,%eax
80102563:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102566:	89 45 d0             	mov    %eax,-0x30(%ebp)
    CONV(minute);
80102569:	8b 45 d4             	mov    -0x2c(%ebp),%eax
8010256c:	89 c2                	mov    %eax,%edx
8010256e:	c1 ea 04             	shr    $0x4,%edx
80102571:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102574:	83 e0 0f             	and    $0xf,%eax
80102577:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010257a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    CONV(hour  );
8010257d:	8b 45 d8             	mov    -0x28(%ebp),%eax
80102580:	89 c2                	mov    %eax,%edx
80102582:	c1 ea 04             	shr    $0x4,%edx
80102585:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102588:	83 e0 0f             	and    $0xf,%eax
8010258b:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010258e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    CONV(day   );
80102591:	8b 45 dc             	mov    -0x24(%ebp),%eax
80102594:	89 c2                	mov    %eax,%edx
80102596:	c1 ea 04             	shr    $0x4,%edx
80102599:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010259c:	83 e0 0f             	and    $0xf,%eax
8010259f:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025a2:	89 45 dc             	mov    %eax,-0x24(%ebp)
    CONV(month );
801025a5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025a8:	89 c2                	mov    %eax,%edx
801025aa:	c1 ea 04             	shr    $0x4,%edx
801025ad:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025b0:	83 e0 0f             	and    $0xf,%eax
801025b3:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025b6:	89 45 e0             	mov    %eax,-0x20(%ebp)
    CONV(year  );
801025b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025bc:	89 c2                	mov    %eax,%edx
801025be:	c1 ea 04             	shr    $0x4,%edx
801025c1:	8d 14 92             	lea    (%edx,%edx,4),%edx
801025c4:	83 e0 0f             	and    $0xf,%eax
801025c7:	8d 04 50             	lea    (%eax,%edx,2),%eax
801025ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
#undef     CONV
  }

  *r = t1;
801025cd:	8b 45 d0             	mov    -0x30(%ebp),%eax
801025d0:	89 06                	mov    %eax,(%esi)
801025d2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801025d5:	89 46 04             	mov    %eax,0x4(%esi)
801025d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
801025db:	89 46 08             	mov    %eax,0x8(%esi)
801025de:	8b 45 dc             	mov    -0x24(%ebp),%eax
801025e1:	89 46 0c             	mov    %eax,0xc(%esi)
801025e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
801025e7:	89 46 10             	mov    %eax,0x10(%esi)
801025ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801025ed:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
801025f0:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
801025f7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801025fa:	5b                   	pop    %ebx
801025fb:	5e                   	pop    %esi
801025fc:	5f                   	pop    %edi
801025fd:	5d                   	pop    %ebp
801025fe:	c3                   	ret    

801025ff <read_head>:
}

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
801025ff:	55                   	push   %ebp
80102600:	89 e5                	mov    %esp,%ebp
80102602:	53                   	push   %ebx
80102603:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102606:	ff 35 b4 26 11 80    	pushl  0x801126b4
8010260c:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102612:	e8 59 db ff ff       	call   80100170 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102617:	8b 58 5c             	mov    0x5c(%eax),%ebx
8010261a:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102620:	83 c4 10             	add    $0x10,%esp
80102623:	ba 00 00 00 00       	mov    $0x0,%edx
80102628:	39 d3                	cmp    %edx,%ebx
8010262a:	7e 10                	jle    8010263c <read_head+0x3d>
    log.lh.block[i] = lh->block[i];
8010262c:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102630:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102637:	83 c2 01             	add    $0x1,%edx
8010263a:	eb ec                	jmp    80102628 <read_head+0x29>
  }
  brelse(buf);
8010263c:	83 ec 0c             	sub    $0xc,%esp
8010263f:	50                   	push   %eax
80102640:	e8 9c db ff ff       	call   801001e1 <brelse>
}
80102645:	83 c4 10             	add    $0x10,%esp
80102648:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010264b:	c9                   	leave  
8010264c:	c3                   	ret    

8010264d <install_trans>:
{
8010264d:	55                   	push   %ebp
8010264e:	89 e5                	mov    %esp,%ebp
80102650:	57                   	push   %edi
80102651:	56                   	push   %esi
80102652:	53                   	push   %ebx
80102653:	83 ec 0c             	sub    $0xc,%esp
  for (tail = 0; tail < log.lh.n; tail++) {
80102656:	be 00 00 00 00       	mov    $0x0,%esi
8010265b:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102661:	7e 68                	jle    801026cb <install_trans+0x7e>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102663:	89 f0                	mov    %esi,%eax
80102665:	03 05 b4 26 11 80    	add    0x801126b4,%eax
8010266b:	83 c0 01             	add    $0x1,%eax
8010266e:	83 ec 08             	sub    $0x8,%esp
80102671:	50                   	push   %eax
80102672:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102678:	e8 f3 da ff ff       	call   80100170 <bread>
8010267d:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
8010267f:	83 c4 08             	add    $0x8,%esp
80102682:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102689:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010268f:	e8 dc da ff ff       	call   80100170 <bread>
80102694:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102696:	8d 57 5c             	lea    0x5c(%edi),%edx
80102699:	8d 40 5c             	lea    0x5c(%eax),%eax
8010269c:	83 c4 0c             	add    $0xc,%esp
8010269f:	68 00 02 00 00       	push   $0x200
801026a4:	52                   	push   %edx
801026a5:	50                   	push   %eax
801026a6:	e8 58 17 00 00       	call   80103e03 <memmove>
    bwrite(dbuf);  // write dst to disk
801026ab:	89 1c 24             	mov    %ebx,(%esp)
801026ae:	e8 ef da ff ff       	call   801001a2 <bwrite>
    brelse(lbuf);
801026b3:	89 3c 24             	mov    %edi,(%esp)
801026b6:	e8 26 db ff ff       	call   801001e1 <brelse>
    brelse(dbuf);
801026bb:	89 1c 24             	mov    %ebx,(%esp)
801026be:	e8 1e db ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801026c3:	83 c6 01             	add    $0x1,%esi
801026c6:	83 c4 10             	add    $0x10,%esp
801026c9:	eb 90                	jmp    8010265b <install_trans+0xe>
}
801026cb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801026ce:	5b                   	pop    %ebx
801026cf:	5e                   	pop    %esi
801026d0:	5f                   	pop    %edi
801026d1:	5d                   	pop    %ebp
801026d2:	c3                   	ret    

801026d3 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
801026d3:	55                   	push   %ebp
801026d4:	89 e5                	mov    %esp,%ebp
801026d6:	53                   	push   %ebx
801026d7:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
801026da:	ff 35 b4 26 11 80    	pushl  0x801126b4
801026e0:	ff 35 c4 26 11 80    	pushl  0x801126c4
801026e6:	e8 85 da ff ff       	call   80100170 <bread>
801026eb:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
801026ed:	8b 0d c8 26 11 80    	mov    0x801126c8,%ecx
801026f3:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
801026f6:	83 c4 10             	add    $0x10,%esp
801026f9:	b8 00 00 00 00       	mov    $0x0,%eax
801026fe:	39 c1                	cmp    %eax,%ecx
80102700:	7e 10                	jle    80102712 <write_head+0x3f>
    hb->block[i] = log.lh.block[i];
80102702:	8b 14 85 cc 26 11 80 	mov    -0x7feed934(,%eax,4),%edx
80102709:	89 54 83 60          	mov    %edx,0x60(%ebx,%eax,4)
  for (i = 0; i < log.lh.n; i++) {
8010270d:	83 c0 01             	add    $0x1,%eax
80102710:	eb ec                	jmp    801026fe <write_head+0x2b>
  }
  bwrite(buf);
80102712:	83 ec 0c             	sub    $0xc,%esp
80102715:	53                   	push   %ebx
80102716:	e8 87 da ff ff       	call   801001a2 <bwrite>
  brelse(buf);
8010271b:	89 1c 24             	mov    %ebx,(%esp)
8010271e:	e8 be da ff ff       	call   801001e1 <brelse>
}
80102723:	83 c4 10             	add    $0x10,%esp
80102726:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102729:	c9                   	leave  
8010272a:	c3                   	ret    

8010272b <recover_from_log>:

static void
recover_from_log(void)
{
8010272b:	55                   	push   %ebp
8010272c:	89 e5                	mov    %esp,%ebp
8010272e:	83 ec 08             	sub    $0x8,%esp
  read_head();
80102731:	e8 c9 fe ff ff       	call   801025ff <read_head>
  install_trans(); // if committed, copy from log to disk
80102736:	e8 12 ff ff ff       	call   8010264d <install_trans>
  log.lh.n = 0;
8010273b:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102742:	00 00 00 
  write_head(); // clear the log
80102745:	e8 89 ff ff ff       	call   801026d3 <write_head>
}
8010274a:	c9                   	leave  
8010274b:	c3                   	ret    

8010274c <write_log>:
}

// Copy modified blocks from cache to log.
static void
write_log(void)
{
8010274c:	55                   	push   %ebp
8010274d:	89 e5                	mov    %esp,%ebp
8010274f:	57                   	push   %edi
80102750:	56                   	push   %esi
80102751:	53                   	push   %ebx
80102752:	83 ec 0c             	sub    $0xc,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102755:	be 00 00 00 00       	mov    $0x0,%esi
8010275a:	39 35 c8 26 11 80    	cmp    %esi,0x801126c8
80102760:	7e 68                	jle    801027ca <write_log+0x7e>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102762:	89 f0                	mov    %esi,%eax
80102764:	03 05 b4 26 11 80    	add    0x801126b4,%eax
8010276a:	83 c0 01             	add    $0x1,%eax
8010276d:	83 ec 08             	sub    $0x8,%esp
80102770:	50                   	push   %eax
80102771:	ff 35 c4 26 11 80    	pushl  0x801126c4
80102777:	e8 f4 d9 ff ff       	call   80100170 <bread>
8010277c:	89 c3                	mov    %eax,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
8010277e:	83 c4 08             	add    $0x8,%esp
80102781:	ff 34 b5 cc 26 11 80 	pushl  -0x7feed934(,%esi,4)
80102788:	ff 35 c4 26 11 80    	pushl  0x801126c4
8010278e:	e8 dd d9 ff ff       	call   80100170 <bread>
80102793:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102795:	8d 50 5c             	lea    0x5c(%eax),%edx
80102798:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010279b:	83 c4 0c             	add    $0xc,%esp
8010279e:	68 00 02 00 00       	push   $0x200
801027a3:	52                   	push   %edx
801027a4:	50                   	push   %eax
801027a5:	e8 59 16 00 00       	call   80103e03 <memmove>
    bwrite(to);  // write the log
801027aa:	89 1c 24             	mov    %ebx,(%esp)
801027ad:	e8 f0 d9 ff ff       	call   801001a2 <bwrite>
    brelse(from);
801027b2:	89 3c 24             	mov    %edi,(%esp)
801027b5:	e8 27 da ff ff       	call   801001e1 <brelse>
    brelse(to);
801027ba:	89 1c 24             	mov    %ebx,(%esp)
801027bd:	e8 1f da ff ff       	call   801001e1 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
801027c2:	83 c6 01             	add    $0x1,%esi
801027c5:	83 c4 10             	add    $0x10,%esp
801027c8:	eb 90                	jmp    8010275a <write_log+0xe>
  }
}
801027ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801027cd:	5b                   	pop    %ebx
801027ce:	5e                   	pop    %esi
801027cf:	5f                   	pop    %edi
801027d0:	5d                   	pop    %ebp
801027d1:	c3                   	ret    

801027d2 <commit>:

static void
commit()
{
  if (log.lh.n > 0) {
801027d2:	83 3d c8 26 11 80 00 	cmpl   $0x0,0x801126c8
801027d9:	7f 01                	jg     801027dc <commit+0xa>
801027db:	c3                   	ret    
{
801027dc:	55                   	push   %ebp
801027dd:	89 e5                	mov    %esp,%ebp
801027df:	83 ec 08             	sub    $0x8,%esp
    write_log();     // Write modified blocks from cache to log
801027e2:	e8 65 ff ff ff       	call   8010274c <write_log>
    write_head();    // Write header to disk -- the real commit
801027e7:	e8 e7 fe ff ff       	call   801026d3 <write_head>
    install_trans(); // Now install writes to home locations
801027ec:	e8 5c fe ff ff       	call   8010264d <install_trans>
    log.lh.n = 0;
801027f1:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
801027f8:	00 00 00 
    write_head();    // Erase the transaction from the log
801027fb:	e8 d3 fe ff ff       	call   801026d3 <write_head>
  }
}
80102800:	c9                   	leave  
80102801:	c3                   	ret    

80102802 <initlog>:
{
80102802:	f3 0f 1e fb          	endbr32 
80102806:	55                   	push   %ebp
80102807:	89 e5                	mov    %esp,%ebp
80102809:	53                   	push   %ebx
8010280a:	83 ec 2c             	sub    $0x2c,%esp
8010280d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102810:	68 20 6b 10 80       	push   $0x80106b20
80102815:	68 80 26 11 80       	push   $0x80112680
8010281a:	e8 60 13 00 00       	call   80103b7f <initlock>
  readsb(dev, &sb);
8010281f:	83 c4 08             	add    $0x8,%esp
80102822:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102825:	50                   	push   %eax
80102826:	53                   	push   %ebx
80102827:	e8 c1 ea ff ff       	call   801012ed <readsb>
  log.start = sb.logstart;
8010282c:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010282f:	a3 b4 26 11 80       	mov    %eax,0x801126b4
  log.size = sb.nlog;
80102834:	8b 45 e8             	mov    -0x18(%ebp),%eax
80102837:	a3 b8 26 11 80       	mov    %eax,0x801126b8
  log.dev = dev;
8010283c:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4
  recover_from_log();
80102842:	e8 e4 fe ff ff       	call   8010272b <recover_from_log>
}
80102847:	83 c4 10             	add    $0x10,%esp
8010284a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010284d:	c9                   	leave  
8010284e:	c3                   	ret    

8010284f <begin_op>:
{
8010284f:	f3 0f 1e fb          	endbr32 
80102853:	55                   	push   %ebp
80102854:	89 e5                	mov    %esp,%ebp
80102856:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102859:	68 80 26 11 80       	push   $0x80112680
8010285e:	e8 6c 14 00 00       	call   80103ccf <acquire>
80102863:	83 c4 10             	add    $0x10,%esp
80102866:	eb 15                	jmp    8010287d <begin_op+0x2e>
      sleep(&log, &log.lock);
80102868:	83 ec 08             	sub    $0x8,%esp
8010286b:	68 80 26 11 80       	push   $0x80112680
80102870:	68 80 26 11 80       	push   $0x80112680
80102875:	e8 1a 0f 00 00       	call   80103794 <sleep>
8010287a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
8010287d:	83 3d c0 26 11 80 00 	cmpl   $0x0,0x801126c0
80102884:	75 e2                	jne    80102868 <begin_op+0x19>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102886:	a1 bc 26 11 80       	mov    0x801126bc,%eax
8010288b:	83 c0 01             	add    $0x1,%eax
8010288e:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102891:	8d 14 09             	lea    (%ecx,%ecx,1),%edx
80102894:	03 15 c8 26 11 80    	add    0x801126c8,%edx
8010289a:	83 fa 1e             	cmp    $0x1e,%edx
8010289d:	7e 17                	jle    801028b6 <begin_op+0x67>
      sleep(&log, &log.lock);
8010289f:	83 ec 08             	sub    $0x8,%esp
801028a2:	68 80 26 11 80       	push   $0x80112680
801028a7:	68 80 26 11 80       	push   $0x80112680
801028ac:	e8 e3 0e 00 00       	call   80103794 <sleep>
801028b1:	83 c4 10             	add    $0x10,%esp
801028b4:	eb c7                	jmp    8010287d <begin_op+0x2e>
      log.outstanding += 1;
801028b6:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
801028bb:	83 ec 0c             	sub    $0xc,%esp
801028be:	68 80 26 11 80       	push   $0x80112680
801028c3:	e8 70 14 00 00       	call   80103d38 <release>
}
801028c8:	83 c4 10             	add    $0x10,%esp
801028cb:	c9                   	leave  
801028cc:	c3                   	ret    

801028cd <end_op>:
{
801028cd:	f3 0f 1e fb          	endbr32 
801028d1:	55                   	push   %ebp
801028d2:	89 e5                	mov    %esp,%ebp
801028d4:	53                   	push   %ebx
801028d5:	83 ec 10             	sub    $0x10,%esp
  acquire(&log.lock);
801028d8:	68 80 26 11 80       	push   $0x80112680
801028dd:	e8 ed 13 00 00       	call   80103ccf <acquire>
  log.outstanding -= 1;
801028e2:	a1 bc 26 11 80       	mov    0x801126bc,%eax
801028e7:	83 e8 01             	sub    $0x1,%eax
801028ea:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
801028ef:	8b 1d c0 26 11 80    	mov    0x801126c0,%ebx
801028f5:	83 c4 10             	add    $0x10,%esp
801028f8:	85 db                	test   %ebx,%ebx
801028fa:	75 2c                	jne    80102928 <end_op+0x5b>
  if(log.outstanding == 0){
801028fc:	85 c0                	test   %eax,%eax
801028fe:	75 35                	jne    80102935 <end_op+0x68>
    log.committing = 1;
80102900:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102907:	00 00 00 
    do_commit = 1;
8010290a:	bb 01 00 00 00       	mov    $0x1,%ebx
  release(&log.lock);
8010290f:	83 ec 0c             	sub    $0xc,%esp
80102912:	68 80 26 11 80       	push   $0x80112680
80102917:	e8 1c 14 00 00       	call   80103d38 <release>
  if(do_commit){
8010291c:	83 c4 10             	add    $0x10,%esp
8010291f:	85 db                	test   %ebx,%ebx
80102921:	75 24                	jne    80102947 <end_op+0x7a>
}
80102923:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102926:	c9                   	leave  
80102927:	c3                   	ret    
    panic("log.committing");
80102928:	83 ec 0c             	sub    $0xc,%esp
8010292b:	68 24 6b 10 80       	push   $0x80106b24
80102930:	e8 27 da ff ff       	call   8010035c <panic>
    wakeup(&log);
80102935:	83 ec 0c             	sub    $0xc,%esp
80102938:	68 80 26 11 80       	push   $0x80112680
8010293d:	e8 c2 0f 00 00       	call   80103904 <wakeup>
80102942:	83 c4 10             	add    $0x10,%esp
80102945:	eb c8                	jmp    8010290f <end_op+0x42>
    commit();
80102947:	e8 86 fe ff ff       	call   801027d2 <commit>
    acquire(&log.lock);
8010294c:	83 ec 0c             	sub    $0xc,%esp
8010294f:	68 80 26 11 80       	push   $0x80112680
80102954:	e8 76 13 00 00       	call   80103ccf <acquire>
    log.committing = 0;
80102959:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102960:	00 00 00 
    wakeup(&log);
80102963:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
8010296a:	e8 95 0f 00 00       	call   80103904 <wakeup>
    release(&log.lock);
8010296f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102976:	e8 bd 13 00 00       	call   80103d38 <release>
8010297b:	83 c4 10             	add    $0x10,%esp
}
8010297e:	eb a3                	jmp    80102923 <end_op+0x56>

80102980 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102980:	f3 0f 1e fb          	endbr32 
80102984:	55                   	push   %ebp
80102985:	89 e5                	mov    %esp,%ebp
80102987:	53                   	push   %ebx
80102988:	83 ec 04             	sub    $0x4,%esp
8010298b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
8010298e:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102994:	83 fa 1d             	cmp    $0x1d,%edx
80102997:	7f 45                	jg     801029de <log_write+0x5e>
80102999:	a1 b8 26 11 80       	mov    0x801126b8,%eax
8010299e:	83 e8 01             	sub    $0x1,%eax
801029a1:	39 c2                	cmp    %eax,%edx
801029a3:	7d 39                	jge    801029de <log_write+0x5e>
    panic("too big a transaction");
  if (log.outstanding < 1)
801029a5:	83 3d bc 26 11 80 00 	cmpl   $0x0,0x801126bc
801029ac:	7e 3d                	jle    801029eb <log_write+0x6b>
    panic("log_write outside of trans");

  acquire(&log.lock);
801029ae:	83 ec 0c             	sub    $0xc,%esp
801029b1:	68 80 26 11 80       	push   $0x80112680
801029b6:	e8 14 13 00 00       	call   80103ccf <acquire>
  for (i = 0; i < log.lh.n; i++) {
801029bb:	83 c4 10             	add    $0x10,%esp
801029be:	b8 00 00 00 00       	mov    $0x0,%eax
801029c3:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
801029c9:	39 c2                	cmp    %eax,%edx
801029cb:	7e 2b                	jle    801029f8 <log_write+0x78>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
801029cd:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029d0:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
801029d7:	74 1f                	je     801029f8 <log_write+0x78>
  for (i = 0; i < log.lh.n; i++) {
801029d9:	83 c0 01             	add    $0x1,%eax
801029dc:	eb e5                	jmp    801029c3 <log_write+0x43>
    panic("too big a transaction");
801029de:	83 ec 0c             	sub    $0xc,%esp
801029e1:	68 33 6b 10 80       	push   $0x80106b33
801029e6:	e8 71 d9 ff ff       	call   8010035c <panic>
    panic("log_write outside of trans");
801029eb:	83 ec 0c             	sub    $0xc,%esp
801029ee:	68 49 6b 10 80       	push   $0x80106b49
801029f3:	e8 64 d9 ff ff       	call   8010035c <panic>
      break;
  }
  log.lh.block[i] = b->blockno;
801029f8:	8b 4b 08             	mov    0x8(%ebx),%ecx
801029fb:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
  if (i == log.lh.n)
80102a02:	39 c2                	cmp    %eax,%edx
80102a04:	74 18                	je     80102a1e <log_write+0x9e>
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80102a06:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102a09:	83 ec 0c             	sub    $0xc,%esp
80102a0c:	68 80 26 11 80       	push   $0x80112680
80102a11:	e8 22 13 00 00       	call   80103d38 <release>
}
80102a16:	83 c4 10             	add    $0x10,%esp
80102a19:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a1c:	c9                   	leave  
80102a1d:	c3                   	ret    
    log.lh.n++;
80102a1e:	83 c2 01             	add    $0x1,%edx
80102a21:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
80102a27:	eb dd                	jmp    80102a06 <log_write+0x86>

80102a29 <startothers>:
pde_t entrypgdir[];  // For entry.S

// Start the non-boot (AP) processors.
static void
startothers(void)
{
80102a29:	55                   	push   %ebp
80102a2a:	89 e5                	mov    %esp,%ebp
80102a2c:	53                   	push   %ebx
80102a2d:	83 ec 08             	sub    $0x8,%esp

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102a30:	68 8a 00 00 00       	push   $0x8a
80102a35:	68 8c a4 10 80       	push   $0x8010a48c
80102a3a:	68 00 70 00 80       	push   $0x80007000
80102a3f:	e8 bf 13 00 00       	call   80103e03 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102a44:	83 c4 10             	add    $0x10,%esp
80102a47:	bb 80 27 11 80       	mov    $0x80112780,%ebx
80102a4c:	eb 47                	jmp    80102a95 <startothers+0x6c>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102a4e:	e8 ff f6 ff ff       	call   80102152 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102a53:	05 00 10 00 00       	add    $0x1000,%eax
80102a58:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
80102a5d:	c7 05 f8 6f 00 80 f7 	movl   $0x80102af7,0x80006ff8
80102a64:	2a 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102a67:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102a6e:	90 10 00 

    lapicstartap(c->apicid, V2P(code));
80102a71:	83 ec 08             	sub    $0x8,%esp
80102a74:	68 00 70 00 00       	push   $0x7000
80102a79:	0f b6 03             	movzbl (%ebx),%eax
80102a7c:	50                   	push   %eax
80102a7d:	e8 db f9 ff ff       	call   8010245d <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102a82:	83 c4 10             	add    $0x10,%esp
80102a85:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102a8b:	85 c0                	test   %eax,%eax
80102a8d:	74 f6                	je     80102a85 <startothers+0x5c>
  for(c = cpus; c < cpus+ncpu; c++){
80102a8f:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102a95:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102a9c:	00 00 00 
80102a9f:	05 80 27 11 80       	add    $0x80112780,%eax
80102aa4:	39 d8                	cmp    %ebx,%eax
80102aa6:	76 0b                	jbe    80102ab3 <startothers+0x8a>
    if(c == mycpu())  // We've started already.
80102aa8:	e8 9f 07 00 00       	call   8010324c <mycpu>
80102aad:	39 c3                	cmp    %eax,%ebx
80102aaf:	74 de                	je     80102a8f <startothers+0x66>
80102ab1:	eb 9b                	jmp    80102a4e <startothers+0x25>
      ;
  }
}
80102ab3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102ab6:	c9                   	leave  
80102ab7:	c3                   	ret    

80102ab8 <mpmain>:
{
80102ab8:	55                   	push   %ebp
80102ab9:	89 e5                	mov    %esp,%ebp
80102abb:	53                   	push   %ebx
80102abc:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102abf:	e8 e8 07 00 00       	call   801032ac <cpuid>
80102ac4:	89 c3                	mov    %eax,%ebx
80102ac6:	e8 e1 07 00 00       	call   801032ac <cpuid>
80102acb:	83 ec 04             	sub    $0x4,%esp
80102ace:	53                   	push   %ebx
80102acf:	50                   	push   %eax
80102ad0:	68 64 6b 10 80       	push   $0x80106b64
80102ad5:	e8 4f db ff ff       	call   80100629 <cprintf>
  idtinit();       // load idt register
80102ada:	e8 d9 24 00 00       	call   80104fb8 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102adf:	e8 68 07 00 00       	call   8010324c <mycpu>
80102ae4:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102ae6:	b8 01 00 00 00       	mov    $0x1,%eax
80102aeb:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102af2:	e8 62 0a 00 00       	call   80103559 <scheduler>

80102af7 <mpenter>:
{
80102af7:	f3 0f 1e fb          	endbr32 
80102afb:	55                   	push   %ebp
80102afc:	89 e5                	mov    %esp,%ebp
80102afe:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102b01:	e8 d2 34 00 00       	call   80105fd8 <switchkvm>
  seginit();
80102b06:	e8 7d 33 00 00       	call   80105e88 <seginit>
  lapicinit();
80102b0b:	e8 f9 f7 ff ff       	call   80102309 <lapicinit>
  mpmain();
80102b10:	e8 a3 ff ff ff       	call   80102ab8 <mpmain>

80102b15 <main>:
{
80102b15:	f3 0f 1e fb          	endbr32 
80102b19:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102b1d:	83 e4 f0             	and    $0xfffffff0,%esp
80102b20:	ff 71 fc             	pushl  -0x4(%ecx)
80102b23:	55                   	push   %ebp
80102b24:	89 e5                	mov    %esp,%ebp
80102b26:	51                   	push   %ecx
80102b27:	83 ec 0c             	sub    $0xc,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102b2a:	68 00 00 40 80       	push   $0x80400000
80102b2f:	68 a8 56 11 80       	push   $0x801156a8
80102b34:	e8 bf f5 ff ff       	call   801020f8 <kinit1>
  kvmalloc();      // kernel page table
80102b39:	e8 3d 39 00 00       	call   8010647b <kvmalloc>
  mpinit();        // detect other processors
80102b3e:	e8 c1 01 00 00       	call   80102d04 <mpinit>
  lapicinit();     // interrupt controller
80102b43:	e8 c1 f7 ff ff       	call   80102309 <lapicinit>
  seginit();       // segment descriptors
80102b48:	e8 3b 33 00 00       	call   80105e88 <seginit>
  picinit();       // disable pic
80102b4d:	e8 8c 02 00 00       	call   80102dde <picinit>
  ioapicinit();    // another interrupt controller
80102b52:	e8 1c f4 ff ff       	call   80101f73 <ioapicinit>
  consoleinit();   // console hardware
80102b57:	e8 58 dd ff ff       	call   801008b4 <consoleinit>
  uartinit();      // serial port
80102b5c:	e8 0f 27 00 00       	call   80105270 <uartinit>
  pinit();         // process table
80102b61:	e8 c8 06 00 00       	call   8010322e <pinit>
  tvinit();        // trap vectors
80102b66:	e8 98 23 00 00       	call   80104f03 <tvinit>
  binit();         // buffer cache
80102b6b:	e8 84 d5 ff ff       	call   801000f4 <binit>
  fileinit();      // file table
80102b70:	e8 c4 e0 ff ff       	call   80100c39 <fileinit>
  ideinit();       // disk 
80102b75:	e8 fb f1 ff ff       	call   80101d75 <ideinit>
  startothers();   // start other processors
80102b7a:	e8 aa fe ff ff       	call   80102a29 <startothers>
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102b7f:	83 c4 08             	add    $0x8,%esp
80102b82:	68 00 00 00 8e       	push   $0x8e000000
80102b87:	68 00 00 40 80       	push   $0x80400000
80102b8c:	e8 9d f5 ff ff       	call   8010212e <kinit2>
  userinit();      // first user process
80102b91:	e8 5d 07 00 00       	call   801032f3 <userinit>
  mpmain();        // finish this processor's setup
80102b96:	e8 1d ff ff ff       	call   80102ab8 <mpmain>

80102b9b <sum>:
int ncpu;
uchar ioapicid;

static uchar
sum(uchar *addr, int len)
{
80102b9b:	55                   	push   %ebp
80102b9c:	89 e5                	mov    %esp,%ebp
80102b9e:	56                   	push   %esi
80102b9f:	53                   	push   %ebx
80102ba0:	89 c6                	mov    %eax,%esi
  int i, sum;

  sum = 0;
80102ba2:	b8 00 00 00 00       	mov    $0x0,%eax
  for(i=0; i<len; i++)
80102ba7:	b9 00 00 00 00       	mov    $0x0,%ecx
80102bac:	39 d1                	cmp    %edx,%ecx
80102bae:	7d 0b                	jge    80102bbb <sum+0x20>
    sum += addr[i];
80102bb0:	0f b6 1c 0e          	movzbl (%esi,%ecx,1),%ebx
80102bb4:	01 d8                	add    %ebx,%eax
  for(i=0; i<len; i++)
80102bb6:	83 c1 01             	add    $0x1,%ecx
80102bb9:	eb f1                	jmp    80102bac <sum+0x11>
  return sum;
}
80102bbb:	5b                   	pop    %ebx
80102bbc:	5e                   	pop    %esi
80102bbd:	5d                   	pop    %ebp
80102bbe:	c3                   	ret    

80102bbf <mpsearch1>:

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102bbf:	55                   	push   %ebp
80102bc0:	89 e5                	mov    %esp,%ebp
80102bc2:	56                   	push   %esi
80102bc3:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
80102bc4:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
80102bca:	89 f3                	mov    %esi,%ebx
  e = addr+len;
80102bcc:	01 d6                	add    %edx,%esi
  for(p = addr; p < e; p += sizeof(struct mp))
80102bce:	eb 03                	jmp    80102bd3 <mpsearch1+0x14>
80102bd0:	83 c3 10             	add    $0x10,%ebx
80102bd3:	39 f3                	cmp    %esi,%ebx
80102bd5:	73 29                	jae    80102c00 <mpsearch1+0x41>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102bd7:	83 ec 04             	sub    $0x4,%esp
80102bda:	6a 04                	push   $0x4
80102bdc:	68 78 6b 10 80       	push   $0x80106b78
80102be1:	53                   	push   %ebx
80102be2:	e8 e3 11 00 00       	call   80103dca <memcmp>
80102be7:	83 c4 10             	add    $0x10,%esp
80102bea:	85 c0                	test   %eax,%eax
80102bec:	75 e2                	jne    80102bd0 <mpsearch1+0x11>
80102bee:	ba 10 00 00 00       	mov    $0x10,%edx
80102bf3:	89 d8                	mov    %ebx,%eax
80102bf5:	e8 a1 ff ff ff       	call   80102b9b <sum>
80102bfa:	84 c0                	test   %al,%al
80102bfc:	75 d2                	jne    80102bd0 <mpsearch1+0x11>
80102bfe:	eb 05                	jmp    80102c05 <mpsearch1+0x46>
      return (struct mp*)p;
  return 0;
80102c00:	bb 00 00 00 00       	mov    $0x0,%ebx
}
80102c05:	89 d8                	mov    %ebx,%eax
80102c07:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102c0a:	5b                   	pop    %ebx
80102c0b:	5e                   	pop    %esi
80102c0c:	5d                   	pop    %ebp
80102c0d:	c3                   	ret    

80102c0e <mpsearch>:
// 1) in the first KB of the EBDA;
// 2) in the last KB of system base memory;
// 3) in the BIOS ROM between 0xE0000 and 0xFFFFF.
static struct mp*
mpsearch(void)
{
80102c0e:	55                   	push   %ebp
80102c0f:	89 e5                	mov    %esp,%ebp
80102c11:	83 ec 08             	sub    $0x8,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102c14:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102c1b:	c1 e0 08             	shl    $0x8,%eax
80102c1e:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102c25:	09 d0                	or     %edx,%eax
80102c27:	c1 e0 04             	shl    $0x4,%eax
80102c2a:	74 1f                	je     80102c4b <mpsearch+0x3d>
    if((mp = mpsearch1(p, 1024)))
80102c2c:	ba 00 04 00 00       	mov    $0x400,%edx
80102c31:	e8 89 ff ff ff       	call   80102bbf <mpsearch1>
80102c36:	85 c0                	test   %eax,%eax
80102c38:	75 0f                	jne    80102c49 <mpsearch+0x3b>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80102c3a:	ba 00 00 01 00       	mov    $0x10000,%edx
80102c3f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80102c44:	e8 76 ff ff ff       	call   80102bbf <mpsearch1>
}
80102c49:	c9                   	leave  
80102c4a:	c3                   	ret    
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102c4b:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102c52:	c1 e0 08             	shl    $0x8,%eax
80102c55:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102c5c:	09 d0                	or     %edx,%eax
80102c5e:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102c61:	2d 00 04 00 00       	sub    $0x400,%eax
80102c66:	ba 00 04 00 00       	mov    $0x400,%edx
80102c6b:	e8 4f ff ff ff       	call   80102bbf <mpsearch1>
80102c70:	85 c0                	test   %eax,%eax
80102c72:	75 d5                	jne    80102c49 <mpsearch+0x3b>
80102c74:	eb c4                	jmp    80102c3a <mpsearch+0x2c>

80102c76 <mpconfig>:
// Check for correct signature, calculate the checksum and,
// if correct, check the version.
// To do: check extended table checksum.
static struct mpconf*
mpconfig(struct mp **pmp)
{
80102c76:	55                   	push   %ebp
80102c77:	89 e5                	mov    %esp,%ebp
80102c79:	57                   	push   %edi
80102c7a:	56                   	push   %esi
80102c7b:	53                   	push   %ebx
80102c7c:	83 ec 1c             	sub    $0x1c,%esp
80102c7f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102c82:	e8 87 ff ff ff       	call   80102c0e <mpsearch>
80102c87:	89 c3                	mov    %eax,%ebx
80102c89:	85 c0                	test   %eax,%eax
80102c8b:	74 5a                	je     80102ce7 <mpconfig+0x71>
80102c8d:	8b 70 04             	mov    0x4(%eax),%esi
80102c90:	85 f6                	test   %esi,%esi
80102c92:	74 57                	je     80102ceb <mpconfig+0x75>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102c94:	8d be 00 00 00 80    	lea    -0x80000000(%esi),%edi
  if(memcmp(conf, "PCMP", 4) != 0)
80102c9a:	83 ec 04             	sub    $0x4,%esp
80102c9d:	6a 04                	push   $0x4
80102c9f:	68 7d 6b 10 80       	push   $0x80106b7d
80102ca4:	57                   	push   %edi
80102ca5:	e8 20 11 00 00       	call   80103dca <memcmp>
80102caa:	83 c4 10             	add    $0x10,%esp
80102cad:	85 c0                	test   %eax,%eax
80102caf:	75 3e                	jne    80102cef <mpconfig+0x79>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80102cb1:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80102cb8:	3c 01                	cmp    $0x1,%al
80102cba:	0f 95 c2             	setne  %dl
80102cbd:	3c 04                	cmp    $0x4,%al
80102cbf:	0f 95 c0             	setne  %al
80102cc2:	84 c2                	test   %al,%dl
80102cc4:	75 30                	jne    80102cf6 <mpconfig+0x80>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80102cc6:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80102ccd:	89 f8                	mov    %edi,%eax
80102ccf:	e8 c7 fe ff ff       	call   80102b9b <sum>
80102cd4:	84 c0                	test   %al,%al
80102cd6:	75 25                	jne    80102cfd <mpconfig+0x87>
    return 0;
  *pmp = mp;
80102cd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102cdb:	89 18                	mov    %ebx,(%eax)
  return conf;
}
80102cdd:	89 f8                	mov    %edi,%eax
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
    return 0;
80102ce7:	89 c7                	mov    %eax,%edi
80102ce9:	eb f2                	jmp    80102cdd <mpconfig+0x67>
80102ceb:	89 f7                	mov    %esi,%edi
80102ced:	eb ee                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cef:	bf 00 00 00 00       	mov    $0x0,%edi
80102cf4:	eb e7                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cf6:	bf 00 00 00 00       	mov    $0x0,%edi
80102cfb:	eb e0                	jmp    80102cdd <mpconfig+0x67>
    return 0;
80102cfd:	bf 00 00 00 00       	mov    $0x0,%edi
80102d02:	eb d9                	jmp    80102cdd <mpconfig+0x67>

80102d04 <mpinit>:

void
mpinit(void)
{
80102d04:	f3 0f 1e fb          	endbr32 
80102d08:	55                   	push   %ebp
80102d09:	89 e5                	mov    %esp,%ebp
80102d0b:	57                   	push   %edi
80102d0c:	56                   	push   %esi
80102d0d:	53                   	push   %ebx
80102d0e:	83 ec 1c             	sub    $0x1c,%esp
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80102d11:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80102d14:	e8 5d ff ff ff       	call   80102c76 <mpconfig>
80102d19:	85 c0                	test   %eax,%eax
80102d1b:	74 19                	je     80102d36 <mpinit+0x32>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80102d1d:	8b 50 24             	mov    0x24(%eax),%edx
80102d20:	89 15 7c 26 11 80    	mov    %edx,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d26:	8d 50 2c             	lea    0x2c(%eax),%edx
80102d29:	0f b7 48 04          	movzwl 0x4(%eax),%ecx
80102d2d:	01 c1                	add    %eax,%ecx
  ismp = 1;
80102d2f:	bb 01 00 00 00       	mov    $0x1,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d34:	eb 20                	jmp    80102d56 <mpinit+0x52>
    panic("Expect to run on an SMP");
80102d36:	83 ec 0c             	sub    $0xc,%esp
80102d39:	68 82 6b 10 80       	push   $0x80106b82
80102d3e:	e8 19 d6 ff ff       	call   8010035c <panic>
    switch(*p){
80102d43:	bb 00 00 00 00       	mov    $0x0,%ebx
80102d48:	eb 0c                	jmp    80102d56 <mpinit+0x52>
80102d4a:	83 e8 03             	sub    $0x3,%eax
80102d4d:	3c 01                	cmp    $0x1,%al
80102d4f:	76 1a                	jbe    80102d6b <mpinit+0x67>
80102d51:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80102d56:	39 ca                	cmp    %ecx,%edx
80102d58:	73 4d                	jae    80102da7 <mpinit+0xa3>
    switch(*p){
80102d5a:	0f b6 02             	movzbl (%edx),%eax
80102d5d:	3c 02                	cmp    $0x2,%al
80102d5f:	74 38                	je     80102d99 <mpinit+0x95>
80102d61:	77 e7                	ja     80102d4a <mpinit+0x46>
80102d63:	84 c0                	test   %al,%al
80102d65:	74 09                	je     80102d70 <mpinit+0x6c>
80102d67:	3c 01                	cmp    $0x1,%al
80102d69:	75 d8                	jne    80102d43 <mpinit+0x3f>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80102d6b:	83 c2 08             	add    $0x8,%edx
      continue;
80102d6e:	eb e6                	jmp    80102d56 <mpinit+0x52>
      if(ncpu < NCPU) {
80102d70:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
80102d76:	83 fe 07             	cmp    $0x7,%esi
80102d79:	7f 19                	jg     80102d94 <mpinit+0x90>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80102d7b:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102d7f:	69 fe b0 00 00 00    	imul   $0xb0,%esi,%edi
80102d85:	88 87 80 27 11 80    	mov    %al,-0x7feed880(%edi)
        ncpu++;
80102d8b:	83 c6 01             	add    $0x1,%esi
80102d8e:	89 35 00 2d 11 80    	mov    %esi,0x80112d00
      p += sizeof(struct mpproc);
80102d94:	83 c2 14             	add    $0x14,%edx
      continue;
80102d97:	eb bd                	jmp    80102d56 <mpinit+0x52>
      ioapicid = ioapic->apicno;
80102d99:	0f b6 42 01          	movzbl 0x1(%edx),%eax
80102d9d:	a2 60 27 11 80       	mov    %al,0x80112760
      p += sizeof(struct mpioapic);
80102da2:	83 c2 08             	add    $0x8,%edx
      continue;
80102da5:	eb af                	jmp    80102d56 <mpinit+0x52>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80102da7:	85 db                	test   %ebx,%ebx
80102da9:	74 26                	je     80102dd1 <mpinit+0xcd>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
80102dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80102dae:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80102db2:	74 15                	je     80102dc9 <mpinit+0xc5>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102db4:	b8 70 00 00 00       	mov    $0x70,%eax
80102db9:	ba 22 00 00 00       	mov    $0x22,%edx
80102dbe:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102dbf:	ba 23 00 00 00       	mov    $0x23,%edx
80102dc4:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
80102dc5:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102dc8:	ee                   	out    %al,(%dx)
  }
}
80102dc9:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102dcc:	5b                   	pop    %ebx
80102dcd:	5e                   	pop    %esi
80102dce:	5f                   	pop    %edi
80102dcf:	5d                   	pop    %ebp
80102dd0:	c3                   	ret    
    panic("Didn't find a suitable machine");
80102dd1:	83 ec 0c             	sub    $0xc,%esp
80102dd4:	68 9c 6b 10 80       	push   $0x80106b9c
80102dd9:	e8 7e d5 ff ff       	call   8010035c <panic>

80102dde <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80102dde:	f3 0f 1e fb          	endbr32 
80102de2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102de7:	ba 21 00 00 00       	mov    $0x21,%edx
80102dec:	ee                   	out    %al,(%dx)
80102ded:	ba a1 00 00 00       	mov    $0xa1,%edx
80102df2:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80102df3:	c3                   	ret    

80102df4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80102df4:	f3 0f 1e fb          	endbr32 
80102df8:	55                   	push   %ebp
80102df9:	89 e5                	mov    %esp,%ebp
80102dfb:	57                   	push   %edi
80102dfc:	56                   	push   %esi
80102dfd:	53                   	push   %ebx
80102dfe:	83 ec 0c             	sub    $0xc,%esp
80102e01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102e04:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
80102e07:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80102e0d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
80102e13:	e8 3f de ff ff       	call   80100c57 <filealloc>
80102e18:	89 03                	mov    %eax,(%ebx)
80102e1a:	85 c0                	test   %eax,%eax
80102e1c:	0f 84 88 00 00 00    	je     80102eaa <pipealloc+0xb6>
80102e22:	e8 30 de ff ff       	call   80100c57 <filealloc>
80102e27:	89 06                	mov    %eax,(%esi)
80102e29:	85 c0                	test   %eax,%eax
80102e2b:	74 7d                	je     80102eaa <pipealloc+0xb6>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80102e2d:	e8 20 f3 ff ff       	call   80102152 <kalloc>
80102e32:	89 c7                	mov    %eax,%edi
80102e34:	85 c0                	test   %eax,%eax
80102e36:	74 72                	je     80102eaa <pipealloc+0xb6>
    goto bad;
  p->readopen = 1;
80102e38:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80102e3f:	00 00 00 
  p->writeopen = 1;
80102e42:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
80102e49:	00 00 00 
  p->nwrite = 0;
80102e4c:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80102e53:	00 00 00 
  p->nread = 0;
80102e56:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80102e5d:	00 00 00 
  initlock(&p->lock, "pipe");
80102e60:	83 ec 08             	sub    $0x8,%esp
80102e63:	68 bb 6b 10 80       	push   $0x80106bbb
80102e68:	50                   	push   %eax
80102e69:	e8 11 0d 00 00       	call   80103b7f <initlock>
  (*f0)->type = FD_PIPE;
80102e6e:	8b 03                	mov    (%ebx),%eax
80102e70:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80102e76:	8b 03                	mov    (%ebx),%eax
80102e78:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
80102e7c:	8b 03                	mov    (%ebx),%eax
80102e7e:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80102e82:	8b 03                	mov    (%ebx),%eax
80102e84:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80102e87:	8b 06                	mov    (%esi),%eax
80102e89:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80102e8f:	8b 06                	mov    (%esi),%eax
80102e91:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80102e95:	8b 06                	mov    (%esi),%eax
80102e97:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80102e9b:	8b 06                	mov    (%esi),%eax
80102e9d:	89 78 0c             	mov    %edi,0xc(%eax)
  return 0;
80102ea0:	83 c4 10             	add    $0x10,%esp
80102ea3:	b8 00 00 00 00       	mov    $0x0,%eax
80102ea8:	eb 29                	jmp    80102ed3 <pipealloc+0xdf>

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80102eaa:	8b 03                	mov    (%ebx),%eax
80102eac:	85 c0                	test   %eax,%eax
80102eae:	74 0c                	je     80102ebc <pipealloc+0xc8>
    fileclose(*f0);
80102eb0:	83 ec 0c             	sub    $0xc,%esp
80102eb3:	50                   	push   %eax
80102eb4:	e8 4c de ff ff       	call   80100d05 <fileclose>
80102eb9:	83 c4 10             	add    $0x10,%esp
  if(*f1)
80102ebc:	8b 06                	mov    (%esi),%eax
80102ebe:	85 c0                	test   %eax,%eax
80102ec0:	74 19                	je     80102edb <pipealloc+0xe7>
    fileclose(*f1);
80102ec2:	83 ec 0c             	sub    $0xc,%esp
80102ec5:	50                   	push   %eax
80102ec6:	e8 3a de ff ff       	call   80100d05 <fileclose>
80102ecb:	83 c4 10             	add    $0x10,%esp
  return -1;
80102ece:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102ed3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ed6:	5b                   	pop    %ebx
80102ed7:	5e                   	pop    %esi
80102ed8:	5f                   	pop    %edi
80102ed9:	5d                   	pop    %ebp
80102eda:	c3                   	ret    
  return -1;
80102edb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102ee0:	eb f1                	jmp    80102ed3 <pipealloc+0xdf>

80102ee2 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80102ee2:	f3 0f 1e fb          	endbr32 
80102ee6:	55                   	push   %ebp
80102ee7:	89 e5                	mov    %esp,%ebp
80102ee9:	53                   	push   %ebx
80102eea:	83 ec 10             	sub    $0x10,%esp
80102eed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&p->lock);
80102ef0:	53                   	push   %ebx
80102ef1:	e8 d9 0d 00 00       	call   80103ccf <acquire>
  if(writable){
80102ef6:	83 c4 10             	add    $0x10,%esp
80102ef9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
80102efd:	74 3f                	je     80102f3e <pipeclose+0x5c>
    p->writeopen = 0;
80102eff:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80102f06:	00 00 00 
    wakeup(&p->nread);
80102f09:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f0f:	83 ec 0c             	sub    $0xc,%esp
80102f12:	50                   	push   %eax
80102f13:	e8 ec 09 00 00       	call   80103904 <wakeup>
80102f18:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80102f1b:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102f22:	75 09                	jne    80102f2d <pipeclose+0x4b>
80102f24:	83 bb 40 02 00 00 00 	cmpl   $0x0,0x240(%ebx)
80102f2b:	74 2f                	je     80102f5c <pipeclose+0x7a>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80102f2d:	83 ec 0c             	sub    $0xc,%esp
80102f30:	53                   	push   %ebx
80102f31:	e8 02 0e 00 00       	call   80103d38 <release>
80102f36:	83 c4 10             	add    $0x10,%esp
}
80102f39:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102f3c:	c9                   	leave  
80102f3d:	c3                   	ret    
    p->readopen = 0;
80102f3e:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80102f45:	00 00 00 
    wakeup(&p->nwrite);
80102f48:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102f4e:	83 ec 0c             	sub    $0xc,%esp
80102f51:	50                   	push   %eax
80102f52:	e8 ad 09 00 00       	call   80103904 <wakeup>
80102f57:	83 c4 10             	add    $0x10,%esp
80102f5a:	eb bf                	jmp    80102f1b <pipeclose+0x39>
    release(&p->lock);
80102f5c:	83 ec 0c             	sub    $0xc,%esp
80102f5f:	53                   	push   %ebx
80102f60:	e8 d3 0d 00 00       	call   80103d38 <release>
    kfree((char*)p);
80102f65:	89 1c 24             	mov    %ebx,(%esp)
80102f68:	e8 be f0 ff ff       	call   8010202b <kfree>
80102f6d:	83 c4 10             	add    $0x10,%esp
80102f70:	eb c7                	jmp    80102f39 <pipeclose+0x57>

80102f72 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80102f72:	f3 0f 1e fb          	endbr32 
80102f76:	55                   	push   %ebp
80102f77:	89 e5                	mov    %esp,%ebp
80102f79:	57                   	push   %edi
80102f7a:	56                   	push   %esi
80102f7b:	53                   	push   %ebx
80102f7c:	83 ec 18             	sub    $0x18,%esp
80102f7f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
80102f82:	89 de                	mov    %ebx,%esi
80102f84:	53                   	push   %ebx
80102f85:	e8 45 0d 00 00       	call   80103ccf <acquire>
  for(i = 0; i < n; i++){
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	bf 00 00 00 00       	mov    $0x0,%edi
80102f92:	3b 7d 10             	cmp    0x10(%ebp),%edi
80102f95:	7c 41                	jl     80102fd8 <pipewrite+0x66>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80102f97:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102f9d:	83 ec 0c             	sub    $0xc,%esp
80102fa0:	50                   	push   %eax
80102fa1:	e8 5e 09 00 00       	call   80103904 <wakeup>
  release(&p->lock);
80102fa6:	89 1c 24             	mov    %ebx,(%esp)
80102fa9:	e8 8a 0d 00 00       	call   80103d38 <release>
  return n;
80102fae:	83 c4 10             	add    $0x10,%esp
80102fb1:	8b 45 10             	mov    0x10(%ebp),%eax
80102fb4:	eb 5c                	jmp    80103012 <pipewrite+0xa0>
      wakeup(&p->nread);
80102fb6:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80102fbc:	83 ec 0c             	sub    $0xc,%esp
80102fbf:	50                   	push   %eax
80102fc0:	e8 3f 09 00 00       	call   80103904 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80102fc5:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80102fcb:	83 c4 08             	add    $0x8,%esp
80102fce:	56                   	push   %esi
80102fcf:	50                   	push   %eax
80102fd0:	e8 bf 07 00 00       	call   80103794 <sleep>
80102fd5:	83 c4 10             	add    $0x10,%esp
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80102fd8:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80102fde:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80102fe4:	05 00 02 00 00       	add    $0x200,%eax
80102fe9:	39 c2                	cmp    %eax,%edx
80102feb:	75 2d                	jne    8010301a <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80102fed:	83 bb 3c 02 00 00 00 	cmpl   $0x0,0x23c(%ebx)
80102ff4:	74 0b                	je     80103001 <pipewrite+0x8f>
80102ff6:	e8 d0 02 00 00       	call   801032cb <myproc>
80102ffb:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80102fff:	74 b5                	je     80102fb6 <pipewrite+0x44>
        release(&p->lock);
80103001:	83 ec 0c             	sub    $0xc,%esp
80103004:	53                   	push   %ebx
80103005:	e8 2e 0d 00 00       	call   80103d38 <release>
        return -1;
8010300a:	83 c4 10             	add    $0x10,%esp
8010300d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103012:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103015:	5b                   	pop    %ebx
80103016:	5e                   	pop    %esi
80103017:	5f                   	pop    %edi
80103018:	5d                   	pop    %ebp
80103019:	c3                   	ret    
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
8010301a:	8d 42 01             	lea    0x1(%edx),%eax
8010301d:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103023:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103029:	8b 45 0c             	mov    0xc(%ebp),%eax
8010302c:	0f b6 04 38          	movzbl (%eax,%edi,1),%eax
80103030:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103034:	83 c7 01             	add    $0x1,%edi
80103037:	e9 56 ff ff ff       	jmp    80102f92 <pipewrite+0x20>

8010303c <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
8010303c:	f3 0f 1e fb          	endbr32 
80103040:	55                   	push   %ebp
80103041:	89 e5                	mov    %esp,%ebp
80103043:	57                   	push   %edi
80103044:	56                   	push   %esi
80103045:	53                   	push   %ebx
80103046:	83 ec 18             	sub    $0x18,%esp
80103049:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010304c:	89 df                	mov    %ebx,%edi
8010304e:	53                   	push   %ebx
8010304f:	e8 7b 0c 00 00       	call   80103ccf <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103054:	83 c4 10             	add    $0x10,%esp
80103057:	eb 13                	jmp    8010306c <piperead+0x30>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
80103059:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010305f:	83 ec 08             	sub    $0x8,%esp
80103062:	57                   	push   %edi
80103063:	50                   	push   %eax
80103064:	e8 2b 07 00 00       	call   80103794 <sleep>
80103069:	83 c4 10             	add    $0x10,%esp
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010306c:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
80103072:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
80103078:	75 28                	jne    801030a2 <piperead+0x66>
8010307a:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
80103080:	85 f6                	test   %esi,%esi
80103082:	74 23                	je     801030a7 <piperead+0x6b>
    if(myproc()->killed){
80103084:	e8 42 02 00 00       	call   801032cb <myproc>
80103089:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010308d:	74 ca                	je     80103059 <piperead+0x1d>
      release(&p->lock);
8010308f:	83 ec 0c             	sub    $0xc,%esp
80103092:	53                   	push   %ebx
80103093:	e8 a0 0c 00 00       	call   80103d38 <release>
      return -1;
80103098:	83 c4 10             	add    $0x10,%esp
8010309b:	be ff ff ff ff       	mov    $0xffffffff,%esi
801030a0:	eb 50                	jmp    801030f2 <piperead+0xb6>
801030a2:	be 00 00 00 00       	mov    $0x0,%esi
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030a7:	3b 75 10             	cmp    0x10(%ebp),%esi
801030aa:	7d 2c                	jge    801030d8 <piperead+0x9c>
    if(p->nread == p->nwrite)
801030ac:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801030b2:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
801030b8:	74 1e                	je     801030d8 <piperead+0x9c>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801030ba:	8d 50 01             	lea    0x1(%eax),%edx
801030bd:	89 93 34 02 00 00    	mov    %edx,0x234(%ebx)
801030c3:	25 ff 01 00 00       	and    $0x1ff,%eax
801030c8:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
801030cd:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801030d0:	88 04 31             	mov    %al,(%ecx,%esi,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801030d3:	83 c6 01             	add    $0x1,%esi
801030d6:	eb cf                	jmp    801030a7 <piperead+0x6b>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801030d8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
801030de:	83 ec 0c             	sub    $0xc,%esp
801030e1:	50                   	push   %eax
801030e2:	e8 1d 08 00 00       	call   80103904 <wakeup>
  release(&p->lock);
801030e7:	89 1c 24             	mov    %ebx,(%esp)
801030ea:	e8 49 0c 00 00       	call   80103d38 <release>
  return i;
801030ef:	83 c4 10             	add    $0x10,%esp
}
801030f2:	89 f0                	mov    %esi,%eax
801030f4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801030f7:	5b                   	pop    %ebx
801030f8:	5e                   	pop    %esi
801030f9:	5f                   	pop    %edi
801030fa:	5d                   	pop    %ebp
801030fb:	c3                   	ret    

801030fc <wakeup1>:
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801030fc:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103101:	eb 0d                	jmp    80103110 <wakeup1+0x14>
    if(p->state == SLEEPING && p->chan == chan)
      p->state = RUNNABLE;
80103103:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010310a:	81 c2 84 00 00 00    	add    $0x84,%edx
80103110:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103116:	73 0d                	jae    80103125 <wakeup1+0x29>
    if(p->state == SLEEPING && p->chan == chan)
80103118:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
8010311c:	75 ec                	jne    8010310a <wakeup1+0xe>
8010311e:	39 42 20             	cmp    %eax,0x20(%edx)
80103121:	75 e7                	jne    8010310a <wakeup1+0xe>
80103123:	eb de                	jmp    80103103 <wakeup1+0x7>
}
80103125:	c3                   	ret    

80103126 <allocproc>:
{
80103126:	55                   	push   %ebp
80103127:	89 e5                	mov    %esp,%ebp
80103129:	53                   	push   %ebx
8010312a:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010312d:	68 20 2d 11 80       	push   $0x80112d20
80103132:	e8 98 0b 00 00       	call   80103ccf <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103137:	83 c4 10             	add    $0x10,%esp
8010313a:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010313f:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103145:	73 7e                	jae    801031c5 <allocproc+0x9f>
    if(p->state == UNUSED)
80103147:	83 7b 0c 00          	cmpl   $0x0,0xc(%ebx)
8010314b:	74 08                	je     80103155 <allocproc+0x2f>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010314d:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103153:	eb ea                	jmp    8010313f <allocproc+0x19>
  p->state = EMBRYO;
80103155:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
8010315c:	a1 04 a0 10 80       	mov    0x8010a004,%eax
80103161:	8d 50 01             	lea    0x1(%eax),%edx
80103164:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
8010316a:	89 43 10             	mov    %eax,0x10(%ebx)
  release(&ptable.lock);
8010316d:	83 ec 0c             	sub    $0xc,%esp
80103170:	68 20 2d 11 80       	push   $0x80112d20
80103175:	e8 be 0b 00 00       	call   80103d38 <release>
  if((p->kstack = kalloc()) == 0){
8010317a:	e8 d3 ef ff ff       	call   80102152 <kalloc>
8010317f:	89 43 08             	mov    %eax,0x8(%ebx)
80103182:	83 c4 10             	add    $0x10,%esp
80103185:	85 c0                	test   %eax,%eax
80103187:	74 53                	je     801031dc <allocproc+0xb6>
  sp -= sizeof *p->tf;
80103189:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  p->tf = (struct trapframe*)sp;
8010318f:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103192:	c7 80 b0 0f 00 00 f8 	movl   $0x80104ef8,0xfb0(%eax)
80103199:	4e 10 80 
  sp -= sizeof *p->context;
8010319c:	05 9c 0f 00 00       	add    $0xf9c,%eax
  p->context = (struct context*)sp;
801031a1:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
801031a4:	83 ec 04             	sub    $0x4,%esp
801031a7:	6a 14                	push   $0x14
801031a9:	6a 00                	push   $0x0
801031ab:	50                   	push   %eax
801031ac:	e8 d2 0b 00 00       	call   80103d83 <memset>
  p->context->eip = (uint)forkret;
801031b1:	8b 43 1c             	mov    0x1c(%ebx),%eax
801031b4:	c7 40 10 e7 31 10 80 	movl   $0x801031e7,0x10(%eax)
  return p;
801031bb:	83 c4 10             	add    $0x10,%esp
}
801031be:	89 d8                	mov    %ebx,%eax
801031c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801031c3:	c9                   	leave  
801031c4:	c3                   	ret    
  release(&ptable.lock);
801031c5:	83 ec 0c             	sub    $0xc,%esp
801031c8:	68 20 2d 11 80       	push   $0x80112d20
801031cd:	e8 66 0b 00 00       	call   80103d38 <release>
  return 0;
801031d2:	83 c4 10             	add    $0x10,%esp
801031d5:	bb 00 00 00 00       	mov    $0x0,%ebx
801031da:	eb e2                	jmp    801031be <allocproc+0x98>
    p->state = UNUSED;
801031dc:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
801031e3:	89 c3                	mov    %eax,%ebx
801031e5:	eb d7                	jmp    801031be <allocproc+0x98>

801031e7 <forkret>:
{
801031e7:	f3 0f 1e fb          	endbr32 
801031eb:	55                   	push   %ebp
801031ec:	89 e5                	mov    %esp,%ebp
801031ee:	83 ec 14             	sub    $0x14,%esp
  release(&ptable.lock);
801031f1:	68 20 2d 11 80       	push   $0x80112d20
801031f6:	e8 3d 0b 00 00       	call   80103d38 <release>
  if (first) {
801031fb:	83 c4 10             	add    $0x10,%esp
801031fe:	83 3d 00 a0 10 80 00 	cmpl   $0x0,0x8010a000
80103205:	75 02                	jne    80103209 <forkret+0x22>
}
80103207:	c9                   	leave  
80103208:	c3                   	ret    
    first = 0;
80103209:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
80103210:	00 00 00 
    iinit(ROOTDEV);
80103213:	83 ec 0c             	sub    $0xc,%esp
80103216:	6a 01                	push   $0x1
80103218:	e8 08 e1 ff ff       	call   80101325 <iinit>
    initlog(ROOTDEV);
8010321d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80103224:	e8 d9 f5 ff ff       	call   80102802 <initlog>
80103229:	83 c4 10             	add    $0x10,%esp
}
8010322c:	eb d9                	jmp    80103207 <forkret+0x20>

8010322e <pinit>:
{
8010322e:	f3 0f 1e fb          	endbr32 
80103232:	55                   	push   %ebp
80103233:	89 e5                	mov    %esp,%ebp
80103235:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103238:	68 c0 6b 10 80       	push   $0x80106bc0
8010323d:	68 20 2d 11 80       	push   $0x80112d20
80103242:	e8 38 09 00 00       	call   80103b7f <initlock>
}
80103247:	83 c4 10             	add    $0x10,%esp
8010324a:	c9                   	leave  
8010324b:	c3                   	ret    

8010324c <mycpu>:
{
8010324c:	f3 0f 1e fb          	endbr32 
80103250:	55                   	push   %ebp
80103251:	89 e5                	mov    %esp,%ebp
80103253:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103256:	9c                   	pushf  
80103257:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103258:	f6 c4 02             	test   $0x2,%ah
8010325b:	75 28                	jne    80103285 <mycpu+0x39>
  apicid = lapicid();
8010325d:	e8 b7 f1 ff ff       	call   80102419 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103262:	ba 00 00 00 00       	mov    $0x0,%edx
80103267:	39 15 00 2d 11 80    	cmp    %edx,0x80112d00
8010326d:	7e 30                	jle    8010329f <mycpu+0x53>
    if (cpus[i].apicid == apicid)
8010326f:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103275:	0f b6 89 80 27 11 80 	movzbl -0x7feed880(%ecx),%ecx
8010327c:	39 c1                	cmp    %eax,%ecx
8010327e:	74 12                	je     80103292 <mycpu+0x46>
  for (i = 0; i < ncpu; ++i) {
80103280:	83 c2 01             	add    $0x1,%edx
80103283:	eb e2                	jmp    80103267 <mycpu+0x1b>
    panic("mycpu called with interrupts enabled\n");
80103285:	83 ec 0c             	sub    $0xc,%esp
80103288:	68 a4 6c 10 80       	push   $0x80106ca4
8010328d:	e8 ca d0 ff ff       	call   8010035c <panic>
      return &cpus[i];
80103292:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
80103298:	05 80 27 11 80       	add    $0x80112780,%eax
}
8010329d:	c9                   	leave  
8010329e:	c3                   	ret    
  panic("unknown apicid\n");
8010329f:	83 ec 0c             	sub    $0xc,%esp
801032a2:	68 c7 6b 10 80       	push   $0x80106bc7
801032a7:	e8 b0 d0 ff ff       	call   8010035c <panic>

801032ac <cpuid>:
cpuid() {
801032ac:	f3 0f 1e fb          	endbr32 
801032b0:	55                   	push   %ebp
801032b1:	89 e5                	mov    %esp,%ebp
801032b3:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
801032b6:	e8 91 ff ff ff       	call   8010324c <mycpu>
801032bb:	2d 80 27 11 80       	sub    $0x80112780,%eax
801032c0:	c1 f8 04             	sar    $0x4,%eax
801032c3:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801032c9:	c9                   	leave  
801032ca:	c3                   	ret    

801032cb <myproc>:
myproc(void) {
801032cb:	f3 0f 1e fb          	endbr32 
801032cf:	55                   	push   %ebp
801032d0:	89 e5                	mov    %esp,%ebp
801032d2:	53                   	push   %ebx
801032d3:	83 ec 04             	sub    $0x4,%esp
  pushcli();
801032d6:	e8 0b 09 00 00       	call   80103be6 <pushcli>
  c = mycpu();
801032db:	e8 6c ff ff ff       	call   8010324c <mycpu>
  p = c->proc;
801032e0:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801032e6:	e8 3c 09 00 00       	call   80103c27 <popcli>
}
801032eb:	89 d8                	mov    %ebx,%eax
801032ed:	83 c4 04             	add    $0x4,%esp
801032f0:	5b                   	pop    %ebx
801032f1:	5d                   	pop    %ebp
801032f2:	c3                   	ret    

801032f3 <userinit>:
{
801032f3:	f3 0f 1e fb          	endbr32 
801032f7:	55                   	push   %ebp
801032f8:	89 e5                	mov    %esp,%ebp
801032fa:	53                   	push   %ebx
801032fb:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
801032fe:	e8 23 fe ff ff       	call   80103126 <allocproc>
80103303:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103305:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
8010330a:	e8 fa 30 00 00       	call   80106409 <setupkvm>
8010330f:	89 43 04             	mov    %eax,0x4(%ebx)
80103312:	85 c0                	test   %eax,%eax
80103314:	0f 84 b8 00 00 00    	je     801033d2 <userinit+0xdf>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
8010331a:	83 ec 04             	sub    $0x4,%esp
8010331d:	68 2c 00 00 00       	push   $0x2c
80103322:	68 60 a4 10 80       	push   $0x8010a460
80103327:	50                   	push   %eax
80103328:	e8 d9 2d 00 00       	call   80106106 <inituvm>
  p->sz = PGSIZE;
8010332d:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103333:	8b 43 18             	mov    0x18(%ebx),%eax
80103336:	83 c4 0c             	add    $0xc,%esp
80103339:	6a 4c                	push   $0x4c
8010333b:	6a 00                	push   $0x0
8010333d:	50                   	push   %eax
8010333e:	e8 40 0a 00 00       	call   80103d83 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103343:	8b 43 18             	mov    0x18(%ebx),%eax
80103346:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010334c:	8b 43 18             	mov    0x18(%ebx),%eax
8010334f:	66 c7 40 2c 23 00    	movw   $0x23,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103355:	8b 43 18             	mov    0x18(%ebx),%eax
80103358:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010335c:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103360:	8b 43 18             	mov    0x18(%ebx),%eax
80103363:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103367:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010336b:	8b 43 18             	mov    0x18(%ebx),%eax
8010336e:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103375:	8b 43 18             	mov    0x18(%ebx),%eax
80103378:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010337f:	8b 43 18             	mov    0x18(%ebx),%eax
80103382:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103389:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010338c:	83 c4 0c             	add    $0xc,%esp
8010338f:	6a 10                	push   $0x10
80103391:	68 f0 6b 10 80       	push   $0x80106bf0
80103396:	50                   	push   %eax
80103397:	e8 67 0b 00 00       	call   80103f03 <safestrcpy>
  p->cwd = namei("/");
8010339c:	c7 04 24 f9 6b 10 80 	movl   $0x80106bf9,(%esp)
801033a3:	e8 a7 e8 ff ff       	call   80101c4f <namei>
801033a8:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
801033ab:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801033b2:	e8 18 09 00 00       	call   80103ccf <acquire>
  p->state = RUNNABLE;
801033b7:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
801033be:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801033c5:	e8 6e 09 00 00       	call   80103d38 <release>
}
801033ca:	83 c4 10             	add    $0x10,%esp
801033cd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801033d0:	c9                   	leave  
801033d1:	c3                   	ret    
    panic("userinit: out of memory?");
801033d2:	83 ec 0c             	sub    $0xc,%esp
801033d5:	68 d7 6b 10 80       	push   $0x80106bd7
801033da:	e8 7d cf ff ff       	call   8010035c <panic>

801033df <growproc>:
{
801033df:	f3 0f 1e fb          	endbr32 
801033e3:	55                   	push   %ebp
801033e4:	89 e5                	mov    %esp,%ebp
801033e6:	56                   	push   %esi
801033e7:	53                   	push   %ebx
801033e8:	8b 75 08             	mov    0x8(%ebp),%esi
  struct proc *curproc = myproc();
801033eb:	e8 db fe ff ff       	call   801032cb <myproc>
801033f0:	89 c3                	mov    %eax,%ebx
  sz = curproc->sz;
801033f2:	8b 00                	mov    (%eax),%eax
  if(n > 0){
801033f4:	85 f6                	test   %esi,%esi
801033f6:	7f 1c                	jg     80103414 <growproc+0x35>
  } else if(n < 0){
801033f8:	78 37                	js     80103431 <growproc+0x52>
  curproc->sz = sz;
801033fa:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801033fc:	83 ec 0c             	sub    $0xc,%esp
801033ff:	53                   	push   %ebx
80103400:	e8 e5 2b 00 00       	call   80105fea <switchuvm>
  return 0;
80103405:	83 c4 10             	add    $0x10,%esp
80103408:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010340d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103410:	5b                   	pop    %ebx
80103411:	5e                   	pop    %esi
80103412:	5d                   	pop    %ebp
80103413:	c3                   	ret    
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103414:	83 ec 04             	sub    $0x4,%esp
80103417:	01 c6                	add    %eax,%esi
80103419:	56                   	push   %esi
8010341a:	50                   	push   %eax
8010341b:	ff 73 04             	pushl  0x4(%ebx)
8010341e:	e8 85 2e 00 00       	call   801062a8 <allocuvm>
80103423:	83 c4 10             	add    $0x10,%esp
80103426:	85 c0                	test   %eax,%eax
80103428:	75 d0                	jne    801033fa <growproc+0x1b>
      return -1;
8010342a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010342f:	eb dc                	jmp    8010340d <growproc+0x2e>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103431:	83 ec 04             	sub    $0x4,%esp
80103434:	01 c6                	add    %eax,%esi
80103436:	56                   	push   %esi
80103437:	50                   	push   %eax
80103438:	ff 73 04             	pushl  0x4(%ebx)
8010343b:	e8 d2 2d 00 00       	call   80106212 <deallocuvm>
80103440:	83 c4 10             	add    $0x10,%esp
80103443:	85 c0                	test   %eax,%eax
80103445:	75 b3                	jne    801033fa <growproc+0x1b>
      return -1;
80103447:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010344c:	eb bf                	jmp    8010340d <growproc+0x2e>

8010344e <fork>:
{
8010344e:	f3 0f 1e fb          	endbr32 
80103452:	55                   	push   %ebp
80103453:	89 e5                	mov    %esp,%ebp
80103455:	57                   	push   %edi
80103456:	56                   	push   %esi
80103457:	53                   	push   %ebx
80103458:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *curproc = myproc();
8010345b:	e8 6b fe ff ff       	call   801032cb <myproc>
80103460:	89 c3                	mov    %eax,%ebx
  if((np = allocproc()) == 0){
80103462:	e8 bf fc ff ff       	call   80103126 <allocproc>
80103467:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010346a:	85 c0                	test   %eax,%eax
8010346c:	0f 84 e0 00 00 00    	je     80103552 <fork+0x104>
80103472:	89 c7                	mov    %eax,%edi
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103474:	83 ec 08             	sub    $0x8,%esp
80103477:	ff 33                	pushl  (%ebx)
80103479:	ff 73 04             	pushl  0x4(%ebx)
8010347c:	e8 45 30 00 00       	call   801064c6 <copyuvm>
80103481:	89 47 04             	mov    %eax,0x4(%edi)
80103484:	83 c4 10             	add    $0x10,%esp
80103487:	85 c0                	test   %eax,%eax
80103489:	74 2a                	je     801034b5 <fork+0x67>
  np->sz = curproc->sz;
8010348b:	8b 03                	mov    (%ebx),%eax
8010348d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103490:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103492:	89 c8                	mov    %ecx,%eax
80103494:	89 59 14             	mov    %ebx,0x14(%ecx)
  *np->tf = *curproc->tf;
80103497:	8b 73 18             	mov    0x18(%ebx),%esi
8010349a:	8b 79 18             	mov    0x18(%ecx),%edi
8010349d:	b9 13 00 00 00       	mov    $0x13,%ecx
801034a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  np->tf->eax = 0;
801034a4:	8b 40 18             	mov    0x18(%eax),%eax
801034a7:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
801034ae:	be 00 00 00 00       	mov    $0x0,%esi
801034b3:	eb 3c                	jmp    801034f1 <fork+0xa3>
    kfree(np->kstack);
801034b5:	83 ec 0c             	sub    $0xc,%esp
801034b8:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801034bb:	ff 73 08             	pushl  0x8(%ebx)
801034be:	e8 68 eb ff ff       	call   8010202b <kfree>
    np->kstack = 0;
801034c3:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
801034ca:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
801034d1:	83 c4 10             	add    $0x10,%esp
801034d4:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801034d9:	eb 6d                	jmp    80103548 <fork+0xfa>
      np->ofile[i] = filedup(curproc->ofile[i]);
801034db:	83 ec 0c             	sub    $0xc,%esp
801034de:	50                   	push   %eax
801034df:	e8 d8 d7 ff ff       	call   80100cbc <filedup>
801034e4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801034e7:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
801034eb:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NOFILE; i++)
801034ee:	83 c6 01             	add    $0x1,%esi
801034f1:	83 fe 0f             	cmp    $0xf,%esi
801034f4:	7f 0a                	jg     80103500 <fork+0xb2>
    if(curproc->ofile[i])
801034f6:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801034fa:	85 c0                	test   %eax,%eax
801034fc:	75 dd                	jne    801034db <fork+0x8d>
801034fe:	eb ee                	jmp    801034ee <fork+0xa0>
  np->cwd = idup(curproc->cwd);
80103500:	83 ec 0c             	sub    $0xc,%esp
80103503:	ff 73 68             	pushl  0x68(%ebx)
80103506:	e8 8b e0 ff ff       	call   80101596 <idup>
8010350b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010350e:	89 47 68             	mov    %eax,0x68(%edi)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103511:	83 c3 6c             	add    $0x6c,%ebx
80103514:	8d 47 6c             	lea    0x6c(%edi),%eax
80103517:	83 c4 0c             	add    $0xc,%esp
8010351a:	6a 10                	push   $0x10
8010351c:	53                   	push   %ebx
8010351d:	50                   	push   %eax
8010351e:	e8 e0 09 00 00       	call   80103f03 <safestrcpy>
  pid = np->pid;
80103523:	8b 5f 10             	mov    0x10(%edi),%ebx
  acquire(&ptable.lock);
80103526:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010352d:	e8 9d 07 00 00       	call   80103ccf <acquire>
  np->state = RUNNABLE;
80103532:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  release(&ptable.lock);
80103539:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103540:	e8 f3 07 00 00       	call   80103d38 <release>
  return pid;
80103545:	83 c4 10             	add    $0x10,%esp
}
80103548:	89 d8                	mov    %ebx,%eax
8010354a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010354d:	5b                   	pop    %ebx
8010354e:	5e                   	pop    %esi
8010354f:	5f                   	pop    %edi
80103550:	5d                   	pop    %ebp
80103551:	c3                   	ret    
    return -1;
80103552:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103557:	eb ef                	jmp    80103548 <fork+0xfa>

80103559 <scheduler>:
{
80103559:	f3 0f 1e fb          	endbr32 
8010355d:	55                   	push   %ebp
8010355e:	89 e5                	mov    %esp,%ebp
80103560:	56                   	push   %esi
80103561:	53                   	push   %ebx
  struct cpu *c = mycpu();
80103562:	e8 e5 fc ff ff       	call   8010324c <mycpu>
80103567:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103569:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103570:	00 00 00 
80103573:	eb 5d                	jmp    801035d2 <scheduler+0x79>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103575:	81 c3 84 00 00 00    	add    $0x84,%ebx
8010357b:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103581:	73 3f                	jae    801035c2 <scheduler+0x69>
      if(p->state != RUNNABLE)
80103583:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103587:	75 ec                	jne    80103575 <scheduler+0x1c>
      c->proc = p;
80103589:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
8010358f:	83 ec 0c             	sub    $0xc,%esp
80103592:	53                   	push   %ebx
80103593:	e8 52 2a 00 00       	call   80105fea <switchuvm>
      p->state = RUNNING;
80103598:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
8010359f:	83 c4 08             	add    $0x8,%esp
801035a2:	ff 73 1c             	pushl  0x1c(%ebx)
801035a5:	8d 46 04             	lea    0x4(%esi),%eax
801035a8:	50                   	push   %eax
801035a9:	e8 b2 09 00 00       	call   80103f60 <swtch>
      switchkvm();
801035ae:	e8 25 2a 00 00       	call   80105fd8 <switchkvm>
      c->proc = 0;
801035b3:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
801035ba:	00 00 00 
801035bd:	83 c4 10             	add    $0x10,%esp
801035c0:	eb b3                	jmp    80103575 <scheduler+0x1c>
    release(&ptable.lock);
801035c2:	83 ec 0c             	sub    $0xc,%esp
801035c5:	68 20 2d 11 80       	push   $0x80112d20
801035ca:	e8 69 07 00 00       	call   80103d38 <release>
    sti();
801035cf:	83 c4 10             	add    $0x10,%esp
  asm volatile("sti");
801035d2:	fb                   	sti    
    acquire(&ptable.lock);
801035d3:	83 ec 0c             	sub    $0xc,%esp
801035d6:	68 20 2d 11 80       	push   $0x80112d20
801035db:	e8 ef 06 00 00       	call   80103ccf <acquire>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801035e0:	83 c4 10             	add    $0x10,%esp
801035e3:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801035e8:	eb 91                	jmp    8010357b <scheduler+0x22>

801035ea <sched>:
{
801035ea:	f3 0f 1e fb          	endbr32 
801035ee:	55                   	push   %ebp
801035ef:	89 e5                	mov    %esp,%ebp
801035f1:	56                   	push   %esi
801035f2:	53                   	push   %ebx
  struct proc *p = myproc();
801035f3:	e8 d3 fc ff ff       	call   801032cb <myproc>
801035f8:	89 c3                	mov    %eax,%ebx
  if(!holding(&ptable.lock))
801035fa:	83 ec 0c             	sub    $0xc,%esp
801035fd:	68 20 2d 11 80       	push   $0x80112d20
80103602:	e8 84 06 00 00       	call   80103c8b <holding>
80103607:	83 c4 10             	add    $0x10,%esp
8010360a:	85 c0                	test   %eax,%eax
8010360c:	74 4f                	je     8010365d <sched+0x73>
  if(mycpu()->ncli != 1)
8010360e:	e8 39 fc ff ff       	call   8010324c <mycpu>
80103613:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010361a:	75 4e                	jne    8010366a <sched+0x80>
  if(p->state == RUNNING)
8010361c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103620:	74 55                	je     80103677 <sched+0x8d>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103622:	9c                   	pushf  
80103623:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103624:	f6 c4 02             	test   $0x2,%ah
80103627:	75 5b                	jne    80103684 <sched+0x9a>
  intena = mycpu()->intena;
80103629:	e8 1e fc ff ff       	call   8010324c <mycpu>
8010362e:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103634:	e8 13 fc ff ff       	call   8010324c <mycpu>
80103639:	83 ec 08             	sub    $0x8,%esp
8010363c:	ff 70 04             	pushl  0x4(%eax)
8010363f:	83 c3 1c             	add    $0x1c,%ebx
80103642:	53                   	push   %ebx
80103643:	e8 18 09 00 00       	call   80103f60 <swtch>
  mycpu()->intena = intena;
80103648:	e8 ff fb ff ff       	call   8010324c <mycpu>
8010364d:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103653:	83 c4 10             	add    $0x10,%esp
80103656:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103659:	5b                   	pop    %ebx
8010365a:	5e                   	pop    %esi
8010365b:	5d                   	pop    %ebp
8010365c:	c3                   	ret    
    panic("sched ptable.lock");
8010365d:	83 ec 0c             	sub    $0xc,%esp
80103660:	68 fb 6b 10 80       	push   $0x80106bfb
80103665:	e8 f2 cc ff ff       	call   8010035c <panic>
    panic("sched locks");
8010366a:	83 ec 0c             	sub    $0xc,%esp
8010366d:	68 0d 6c 10 80       	push   $0x80106c0d
80103672:	e8 e5 cc ff ff       	call   8010035c <panic>
    panic("sched running");
80103677:	83 ec 0c             	sub    $0xc,%esp
8010367a:	68 19 6c 10 80       	push   $0x80106c19
8010367f:	e8 d8 cc ff ff       	call   8010035c <panic>
    panic("sched interruptible");
80103684:	83 ec 0c             	sub    $0xc,%esp
80103687:	68 27 6c 10 80       	push   $0x80106c27
8010368c:	e8 cb cc ff ff       	call   8010035c <panic>

80103691 <exit>:
{
80103691:	f3 0f 1e fb          	endbr32 
80103695:	55                   	push   %ebp
80103696:	89 e5                	mov    %esp,%ebp
80103698:	56                   	push   %esi
80103699:	53                   	push   %ebx
  struct proc *curproc = myproc();
8010369a:	e8 2c fc ff ff       	call   801032cb <myproc>
  if(curproc == initproc)
8010369f:	39 05 b8 a5 10 80    	cmp    %eax,0x8010a5b8
801036a5:	74 09                	je     801036b0 <exit+0x1f>
801036a7:	89 c6                	mov    %eax,%esi
  for(fd = 0; fd < NOFILE; fd++){
801036a9:	bb 00 00 00 00       	mov    $0x0,%ebx
801036ae:	eb 24                	jmp    801036d4 <exit+0x43>
    panic("init exiting");
801036b0:	83 ec 0c             	sub    $0xc,%esp
801036b3:	68 3b 6c 10 80       	push   $0x80106c3b
801036b8:	e8 9f cc ff ff       	call   8010035c <panic>
      fileclose(curproc->ofile[fd]);
801036bd:	83 ec 0c             	sub    $0xc,%esp
801036c0:	50                   	push   %eax
801036c1:	e8 3f d6 ff ff       	call   80100d05 <fileclose>
      curproc->ofile[fd] = 0;
801036c6:	c7 44 9e 28 00 00 00 	movl   $0x0,0x28(%esi,%ebx,4)
801036cd:	00 
801036ce:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
801036d1:	83 c3 01             	add    $0x1,%ebx
801036d4:	83 fb 0f             	cmp    $0xf,%ebx
801036d7:	7f 0a                	jg     801036e3 <exit+0x52>
    if(curproc->ofile[fd]){
801036d9:	8b 44 9e 28          	mov    0x28(%esi,%ebx,4),%eax
801036dd:	85 c0                	test   %eax,%eax
801036df:	75 dc                	jne    801036bd <exit+0x2c>
801036e1:	eb ee                	jmp    801036d1 <exit+0x40>
  begin_op();
801036e3:	e8 67 f1 ff ff       	call   8010284f <begin_op>
  iput(curproc->cwd);
801036e8:	83 ec 0c             	sub    $0xc,%esp
801036eb:	ff 76 68             	pushl  0x68(%esi)
801036ee:	e8 e6 df ff ff       	call   801016d9 <iput>
  end_op();
801036f3:	e8 d5 f1 ff ff       	call   801028cd <end_op>
  curproc->cwd = 0;
801036f8:	c7 46 68 00 00 00 00 	movl   $0x0,0x68(%esi)
  acquire(&ptable.lock);
801036ff:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103706:	e8 c4 05 00 00       	call   80103ccf <acquire>
  wakeup1(curproc->parent);
8010370b:	8b 46 14             	mov    0x14(%esi),%eax
8010370e:	e8 e9 f9 ff ff       	call   801030fc <wakeup1>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103713:	83 c4 10             	add    $0x10,%esp
80103716:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
8010371b:	eb 06                	jmp    80103723 <exit+0x92>
8010371d:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103723:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103729:	73 1a                	jae    80103745 <exit+0xb4>
    if(p->parent == curproc){
8010372b:	39 73 14             	cmp    %esi,0x14(%ebx)
8010372e:	75 ed                	jne    8010371d <exit+0x8c>
      p->parent = initproc;
80103730:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103735:	89 43 14             	mov    %eax,0x14(%ebx)
      if(p->state == ZOMBIE)
80103738:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010373c:	75 df                	jne    8010371d <exit+0x8c>
        wakeup1(initproc);
8010373e:	e8 b9 f9 ff ff       	call   801030fc <wakeup1>
80103743:	eb d8                	jmp    8010371d <exit+0x8c>
  curproc->state = ZOMBIE;
80103745:	c7 46 0c 05 00 00 00 	movl   $0x5,0xc(%esi)
  sched();
8010374c:	e8 99 fe ff ff       	call   801035ea <sched>
  panic("zombie exit");
80103751:	83 ec 0c             	sub    $0xc,%esp
80103754:	68 48 6c 10 80       	push   $0x80106c48
80103759:	e8 fe cb ff ff       	call   8010035c <panic>

8010375e <yield>:
{
8010375e:	f3 0f 1e fb          	endbr32 
80103762:	55                   	push   %ebp
80103763:	89 e5                	mov    %esp,%ebp
80103765:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103768:	68 20 2d 11 80       	push   $0x80112d20
8010376d:	e8 5d 05 00 00       	call   80103ccf <acquire>
  myproc()->state = RUNNABLE;
80103772:	e8 54 fb ff ff       	call   801032cb <myproc>
80103777:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
8010377e:	e8 67 fe ff ff       	call   801035ea <sched>
  release(&ptable.lock);
80103783:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010378a:	e8 a9 05 00 00       	call   80103d38 <release>
}
8010378f:	83 c4 10             	add    $0x10,%esp
80103792:	c9                   	leave  
80103793:	c3                   	ret    

80103794 <sleep>:
{
80103794:	f3 0f 1e fb          	endbr32 
80103798:	55                   	push   %ebp
80103799:	89 e5                	mov    %esp,%ebp
8010379b:	56                   	push   %esi
8010379c:	53                   	push   %ebx
8010379d:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
801037a0:	e8 26 fb ff ff       	call   801032cb <myproc>
  if(p == 0)
801037a5:	85 c0                	test   %eax,%eax
801037a7:	74 66                	je     8010380f <sleep+0x7b>
801037a9:	89 c3                	mov    %eax,%ebx
  if(lk == 0)
801037ab:	85 f6                	test   %esi,%esi
801037ad:	74 6d                	je     8010381c <sleep+0x88>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801037af:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801037b5:	74 18                	je     801037cf <sleep+0x3b>
    acquire(&ptable.lock);  //DOC: sleeplock1
801037b7:	83 ec 0c             	sub    $0xc,%esp
801037ba:	68 20 2d 11 80       	push   $0x80112d20
801037bf:	e8 0b 05 00 00       	call   80103ccf <acquire>
    release(lk);
801037c4:	89 34 24             	mov    %esi,(%esp)
801037c7:	e8 6c 05 00 00       	call   80103d38 <release>
801037cc:	83 c4 10             	add    $0x10,%esp
  p->chan = chan;
801037cf:	8b 45 08             	mov    0x8(%ebp),%eax
801037d2:	89 43 20             	mov    %eax,0x20(%ebx)
  p->state = SLEEPING;
801037d5:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801037dc:	e8 09 fe ff ff       	call   801035ea <sched>
  p->chan = 0;
801037e1:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  if(lk != &ptable.lock){  //DOC: sleeplock2
801037e8:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
801037ee:	74 18                	je     80103808 <sleep+0x74>
    release(&ptable.lock);
801037f0:	83 ec 0c             	sub    $0xc,%esp
801037f3:	68 20 2d 11 80       	push   $0x80112d20
801037f8:	e8 3b 05 00 00       	call   80103d38 <release>
    acquire(lk);
801037fd:	89 34 24             	mov    %esi,(%esp)
80103800:	e8 ca 04 00 00       	call   80103ccf <acquire>
80103805:	83 c4 10             	add    $0x10,%esp
}
80103808:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010380b:	5b                   	pop    %ebx
8010380c:	5e                   	pop    %esi
8010380d:	5d                   	pop    %ebp
8010380e:	c3                   	ret    
    panic("sleep");
8010380f:	83 ec 0c             	sub    $0xc,%esp
80103812:	68 54 6c 10 80       	push   $0x80106c54
80103817:	e8 40 cb ff ff       	call   8010035c <panic>
    panic("sleep without lk");
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	68 5a 6c 10 80       	push   $0x80106c5a
80103824:	e8 33 cb ff ff       	call   8010035c <panic>

80103829 <wait>:
{
80103829:	f3 0f 1e fb          	endbr32 
8010382d:	55                   	push   %ebp
8010382e:	89 e5                	mov    %esp,%ebp
80103830:	56                   	push   %esi
80103831:	53                   	push   %ebx
  struct proc *curproc = myproc();
80103832:	e8 94 fa ff ff       	call   801032cb <myproc>
80103837:	89 c6                	mov    %eax,%esi
  acquire(&ptable.lock);
80103839:	83 ec 0c             	sub    $0xc,%esp
8010383c:	68 20 2d 11 80       	push   $0x80112d20
80103841:	e8 89 04 00 00       	call   80103ccf <acquire>
80103846:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
80103849:	b8 00 00 00 00       	mov    $0x0,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010384e:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103853:	eb 5e                	jmp    801038b3 <wait+0x8a>
        pid = p->pid;
80103855:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103858:	83 ec 0c             	sub    $0xc,%esp
8010385b:	ff 73 08             	pushl  0x8(%ebx)
8010385e:	e8 c8 e7 ff ff       	call   8010202b <kfree>
        p->kstack = 0;
80103863:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
8010386a:	83 c4 04             	add    $0x4,%esp
8010386d:	ff 73 04             	pushl  0x4(%ebx)
80103870:	e8 20 2b 00 00       	call   80106395 <freevm>
        p->pid = 0;
80103875:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
8010387c:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103883:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103887:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
8010388e:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103895:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010389c:	e8 97 04 00 00       	call   80103d38 <release>
        return pid;
801038a1:	83 c4 10             	add    $0x10,%esp
}
801038a4:	89 f0                	mov    %esi,%eax
801038a6:	8d 65 f8             	lea    -0x8(%ebp),%esp
801038a9:	5b                   	pop    %ebx
801038aa:	5e                   	pop    %esi
801038ab:	5d                   	pop    %ebp
801038ac:	c3                   	ret    
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801038ad:	81 c3 84 00 00 00    	add    $0x84,%ebx
801038b3:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801038b9:	73 12                	jae    801038cd <wait+0xa4>
      if(p->parent != curproc)
801038bb:	39 73 14             	cmp    %esi,0x14(%ebx)
801038be:	75 ed                	jne    801038ad <wait+0x84>
      if(p->state == ZOMBIE){
801038c0:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
801038c4:	74 8f                	je     80103855 <wait+0x2c>
      havekids = 1;
801038c6:	b8 01 00 00 00       	mov    $0x1,%eax
801038cb:	eb e0                	jmp    801038ad <wait+0x84>
    if(!havekids || curproc->killed){
801038cd:	85 c0                	test   %eax,%eax
801038cf:	74 06                	je     801038d7 <wait+0xae>
801038d1:	83 7e 24 00          	cmpl   $0x0,0x24(%esi)
801038d5:	74 17                	je     801038ee <wait+0xc5>
      release(&ptable.lock);
801038d7:	83 ec 0c             	sub    $0xc,%esp
801038da:	68 20 2d 11 80       	push   $0x80112d20
801038df:	e8 54 04 00 00       	call   80103d38 <release>
      return -1;
801038e4:	83 c4 10             	add    $0x10,%esp
801038e7:	be ff ff ff ff       	mov    $0xffffffff,%esi
801038ec:	eb b6                	jmp    801038a4 <wait+0x7b>
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
801038ee:	83 ec 08             	sub    $0x8,%esp
801038f1:	68 20 2d 11 80       	push   $0x80112d20
801038f6:	56                   	push   %esi
801038f7:	e8 98 fe ff ff       	call   80103794 <sleep>
    havekids = 0;
801038fc:	83 c4 10             	add    $0x10,%esp
801038ff:	e9 45 ff ff ff       	jmp    80103849 <wait+0x20>

80103904 <wakeup>:

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103904:	f3 0f 1e fb          	endbr32 
80103908:	55                   	push   %ebp
80103909:	89 e5                	mov    %esp,%ebp
8010390b:	83 ec 14             	sub    $0x14,%esp
  acquire(&ptable.lock);
8010390e:	68 20 2d 11 80       	push   $0x80112d20
80103913:	e8 b7 03 00 00       	call   80103ccf <acquire>
  wakeup1(chan);
80103918:	8b 45 08             	mov    0x8(%ebp),%eax
8010391b:	e8 dc f7 ff ff       	call   801030fc <wakeup1>
  release(&ptable.lock);
80103920:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103927:	e8 0c 04 00 00       	call   80103d38 <release>
}
8010392c:	83 c4 10             	add    $0x10,%esp
8010392f:	c9                   	leave  
80103930:	c3                   	ret    

80103931 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103931:	f3 0f 1e fb          	endbr32 
80103935:	55                   	push   %ebp
80103936:	89 e5                	mov    %esp,%ebp
80103938:	53                   	push   %ebx
80103939:	83 ec 10             	sub    $0x10,%esp
8010393c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
8010393f:	68 20 2d 11 80       	push   $0x80112d20
80103944:	e8 86 03 00 00       	call   80103ccf <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103949:	83 c4 10             	add    $0x10,%esp
8010394c:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103951:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103956:	73 3c                	jae    80103994 <kill+0x63>
    if(p->pid == pid){
80103958:	39 58 10             	cmp    %ebx,0x10(%eax)
8010395b:	74 07                	je     80103964 <kill+0x33>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010395d:	05 84 00 00 00       	add    $0x84,%eax
80103962:	eb ed                	jmp    80103951 <kill+0x20>
      p->killed = 1;
80103964:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
8010396b:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
8010396f:	74 1a                	je     8010398b <kill+0x5a>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103971:	83 ec 0c             	sub    $0xc,%esp
80103974:	68 20 2d 11 80       	push   $0x80112d20
80103979:	e8 ba 03 00 00       	call   80103d38 <release>
      return 0;
8010397e:	83 c4 10             	add    $0x10,%esp
80103981:	b8 00 00 00 00       	mov    $0x0,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103986:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103989:	c9                   	leave  
8010398a:	c3                   	ret    
        p->state = RUNNABLE;
8010398b:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103992:	eb dd                	jmp    80103971 <kill+0x40>
  release(&ptable.lock);
80103994:	83 ec 0c             	sub    $0xc,%esp
80103997:	68 20 2d 11 80       	push   $0x80112d20
8010399c:	e8 97 03 00 00       	call   80103d38 <release>
  return -1;
801039a1:	83 c4 10             	add    $0x10,%esp
801039a4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801039a9:	eb db                	jmp    80103986 <kill+0x55>

801039ab <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
801039ab:	f3 0f 1e fb          	endbr32 
801039af:	55                   	push   %ebp
801039b0:	89 e5                	mov    %esp,%ebp
801039b2:	56                   	push   %esi
801039b3:	53                   	push   %ebx
801039b4:	83 ec 30             	sub    $0x30,%esp
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b7:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
801039bc:	eb 36                	jmp    801039f4 <procdump+0x49>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
      state = states[p->state];
    else
      state = "???";
801039be:	b8 6b 6c 10 80       	mov    $0x80106c6b,%eax
    cprintf("%d %s %s", p->pid, state, p->name);
801039c3:	8d 53 6c             	lea    0x6c(%ebx),%edx
801039c6:	52                   	push   %edx
801039c7:	50                   	push   %eax
801039c8:	ff 73 10             	pushl  0x10(%ebx)
801039cb:	68 6f 6c 10 80       	push   $0x80106c6f
801039d0:	e8 54 cc ff ff       	call   80100629 <cprintf>
    if(p->state == SLEEPING){
801039d5:	83 c4 10             	add    $0x10,%esp
801039d8:	83 7b 0c 02          	cmpl   $0x2,0xc(%ebx)
801039dc:	74 3c                	je     80103a1a <procdump+0x6f>
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
801039de:	83 ec 0c             	sub    $0xc,%esp
801039e1:	68 db 6f 10 80       	push   $0x80106fdb
801039e6:	e8 3e cc ff ff       	call   80100629 <cprintf>
801039eb:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039ee:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039f4:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801039fa:	73 61                	jae    80103a5d <procdump+0xb2>
    if(p->state == UNUSED)
801039fc:	8b 43 0c             	mov    0xc(%ebx),%eax
801039ff:	85 c0                	test   %eax,%eax
80103a01:	74 eb                	je     801039ee <procdump+0x43>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103a03:	83 f8 05             	cmp    $0x5,%eax
80103a06:	77 b6                	ja     801039be <procdump+0x13>
80103a08:	8b 04 85 cc 6c 10 80 	mov    -0x7fef9334(,%eax,4),%eax
80103a0f:	85 c0                	test   %eax,%eax
80103a11:	75 b0                	jne    801039c3 <procdump+0x18>
      state = "???";
80103a13:	b8 6b 6c 10 80       	mov    $0x80106c6b,%eax
80103a18:	eb a9                	jmp    801039c3 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103a1a:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103a1d:	8b 40 0c             	mov    0xc(%eax),%eax
80103a20:	83 c0 08             	add    $0x8,%eax
80103a23:	83 ec 08             	sub    $0x8,%esp
80103a26:	8d 55 d0             	lea    -0x30(%ebp),%edx
80103a29:	52                   	push   %edx
80103a2a:	50                   	push   %eax
80103a2b:	e8 6e 01 00 00       	call   80103b9e <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a30:	83 c4 10             	add    $0x10,%esp
80103a33:	be 00 00 00 00       	mov    $0x0,%esi
80103a38:	eb 14                	jmp    80103a4e <procdump+0xa3>
        cprintf(" %p", pc[i]);
80103a3a:	83 ec 08             	sub    $0x8,%esp
80103a3d:	50                   	push   %eax
80103a3e:	68 c1 66 10 80       	push   $0x801066c1
80103a43:	e8 e1 cb ff ff       	call   80100629 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
80103a48:	83 c6 01             	add    $0x1,%esi
80103a4b:	83 c4 10             	add    $0x10,%esp
80103a4e:	83 fe 09             	cmp    $0x9,%esi
80103a51:	7f 8b                	jg     801039de <procdump+0x33>
80103a53:	8b 44 b5 d0          	mov    -0x30(%ebp,%esi,4),%eax
80103a57:	85 c0                	test   %eax,%eax
80103a59:	75 df                	jne    80103a3a <procdump+0x8f>
80103a5b:	eb 81                	jmp    801039de <procdump+0x33>
  }
}
80103a5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103a60:	5b                   	pop    %ebx
80103a61:	5e                   	pop    %esi
80103a62:	5d                   	pop    %ebp
80103a63:	c3                   	ret    

80103a64 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103a64:	f3 0f 1e fb          	endbr32 
80103a68:	55                   	push   %ebp
80103a69:	89 e5                	mov    %esp,%ebp
80103a6b:	53                   	push   %ebx
80103a6c:	83 ec 0c             	sub    $0xc,%esp
80103a6f:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103a72:	68 e4 6c 10 80       	push   $0x80106ce4
80103a77:	8d 43 04             	lea    0x4(%ebx),%eax
80103a7a:	50                   	push   %eax
80103a7b:	e8 ff 00 00 00       	call   80103b7f <initlock>
  lk->name = name;
80103a80:	8b 45 0c             	mov    0xc(%ebp),%eax
80103a83:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
80103a86:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103a8c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
}
80103a93:	83 c4 10             	add    $0x10,%esp
80103a96:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103a99:	c9                   	leave  
80103a9a:	c3                   	ret    

80103a9b <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103a9b:	f3 0f 1e fb          	endbr32 
80103a9f:	55                   	push   %ebp
80103aa0:	89 e5                	mov    %esp,%ebp
80103aa2:	56                   	push   %esi
80103aa3:	53                   	push   %ebx
80103aa4:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103aa7:	8d 73 04             	lea    0x4(%ebx),%esi
80103aaa:	83 ec 0c             	sub    $0xc,%esp
80103aad:	56                   	push   %esi
80103aae:	e8 1c 02 00 00       	call   80103ccf <acquire>
  while (lk->locked) {
80103ab3:	83 c4 10             	add    $0x10,%esp
80103ab6:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ab9:	74 0f                	je     80103aca <acquiresleep+0x2f>
    sleep(lk, &lk->lk);
80103abb:	83 ec 08             	sub    $0x8,%esp
80103abe:	56                   	push   %esi
80103abf:	53                   	push   %ebx
80103ac0:	e8 cf fc ff ff       	call   80103794 <sleep>
80103ac5:	83 c4 10             	add    $0x10,%esp
80103ac8:	eb ec                	jmp    80103ab6 <acquiresleep+0x1b>
  }
  lk->locked = 1;
80103aca:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80103ad0:	e8 f6 f7 ff ff       	call   801032cb <myproc>
80103ad5:	8b 40 10             	mov    0x10(%eax),%eax
80103ad8:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80103adb:	83 ec 0c             	sub    $0xc,%esp
80103ade:	56                   	push   %esi
80103adf:	e8 54 02 00 00       	call   80103d38 <release>
}
80103ae4:	83 c4 10             	add    $0x10,%esp
80103ae7:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103aea:	5b                   	pop    %ebx
80103aeb:	5e                   	pop    %esi
80103aec:	5d                   	pop    %ebp
80103aed:	c3                   	ret    

80103aee <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
80103aee:	f3 0f 1e fb          	endbr32 
80103af2:	55                   	push   %ebp
80103af3:	89 e5                	mov    %esp,%ebp
80103af5:	56                   	push   %esi
80103af6:	53                   	push   %ebx
80103af7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103afa:	8d 73 04             	lea    0x4(%ebx),%esi
80103afd:	83 ec 0c             	sub    $0xc,%esp
80103b00:	56                   	push   %esi
80103b01:	e8 c9 01 00 00       	call   80103ccf <acquire>
  lk->locked = 0;
80103b06:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103b0c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80103b13:	89 1c 24             	mov    %ebx,(%esp)
80103b16:	e8 e9 fd ff ff       	call   80103904 <wakeup>
  release(&lk->lk);
80103b1b:	89 34 24             	mov    %esi,(%esp)
80103b1e:	e8 15 02 00 00       	call   80103d38 <release>
}
80103b23:	83 c4 10             	add    $0x10,%esp
80103b26:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b29:	5b                   	pop    %ebx
80103b2a:	5e                   	pop    %esi
80103b2b:	5d                   	pop    %ebp
80103b2c:	c3                   	ret    

80103b2d <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
80103b2d:	f3 0f 1e fb          	endbr32 
80103b31:	55                   	push   %ebp
80103b32:	89 e5                	mov    %esp,%ebp
80103b34:	56                   	push   %esi
80103b35:	53                   	push   %ebx
80103b36:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
80103b39:	8d 73 04             	lea    0x4(%ebx),%esi
80103b3c:	83 ec 0c             	sub    $0xc,%esp
80103b3f:	56                   	push   %esi
80103b40:	e8 8a 01 00 00       	call   80103ccf <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80103b45:	83 c4 10             	add    $0x10,%esp
80103b48:	83 3b 00             	cmpl   $0x0,(%ebx)
80103b4b:	75 17                	jne    80103b64 <holdingsleep+0x37>
80103b4d:	bb 00 00 00 00       	mov    $0x0,%ebx
  release(&lk->lk);
80103b52:	83 ec 0c             	sub    $0xc,%esp
80103b55:	56                   	push   %esi
80103b56:	e8 dd 01 00 00       	call   80103d38 <release>
  return r;
}
80103b5b:	89 d8                	mov    %ebx,%eax
80103b5d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b60:	5b                   	pop    %ebx
80103b61:	5e                   	pop    %esi
80103b62:	5d                   	pop    %ebp
80103b63:	c3                   	ret    
  r = lk->locked && (lk->pid == myproc()->pid);
80103b64:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80103b67:	e8 5f f7 ff ff       	call   801032cb <myproc>
80103b6c:	3b 58 10             	cmp    0x10(%eax),%ebx
80103b6f:	74 07                	je     80103b78 <holdingsleep+0x4b>
80103b71:	bb 00 00 00 00       	mov    $0x0,%ebx
80103b76:	eb da                	jmp    80103b52 <holdingsleep+0x25>
80103b78:	bb 01 00 00 00       	mov    $0x1,%ebx
80103b7d:	eb d3                	jmp    80103b52 <holdingsleep+0x25>

80103b7f <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80103b7f:	f3 0f 1e fb          	endbr32 
80103b83:	55                   	push   %ebp
80103b84:	89 e5                	mov    %esp,%ebp
80103b86:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80103b89:	8b 55 0c             	mov    0xc(%ebp),%edx
80103b8c:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
80103b8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->cpu = 0;
80103b95:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80103b9c:	5d                   	pop    %ebp
80103b9d:	c3                   	ret    

80103b9e <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80103b9e:	f3 0f 1e fb          	endbr32 
80103ba2:	55                   	push   %ebp
80103ba3:	89 e5                	mov    %esp,%ebp
80103ba5:	53                   	push   %ebx
80103ba6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80103ba9:	8b 45 08             	mov    0x8(%ebp),%eax
80103bac:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
80103baf:	b8 00 00 00 00       	mov    $0x0,%eax
80103bb4:	83 f8 09             	cmp    $0x9,%eax
80103bb7:	7f 25                	jg     80103bde <getcallerpcs+0x40>
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80103bb9:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80103bbf:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
80103bc5:	77 17                	ja     80103bde <getcallerpcs+0x40>
      break;
    pcs[i] = ebp[1];     // saved %eip
80103bc7:	8b 5a 04             	mov    0x4(%edx),%ebx
80103bca:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
    ebp = (uint*)ebp[0]; // saved %ebp
80103bcd:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
80103bcf:	83 c0 01             	add    $0x1,%eax
80103bd2:	eb e0                	jmp    80103bb4 <getcallerpcs+0x16>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80103bd4:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
  for(; i < 10; i++)
80103bdb:	83 c0 01             	add    $0x1,%eax
80103bde:	83 f8 09             	cmp    $0x9,%eax
80103be1:	7e f1                	jle    80103bd4 <getcallerpcs+0x36>
}
80103be3:	5b                   	pop    %ebx
80103be4:	5d                   	pop    %ebp
80103be5:	c3                   	ret    

80103be6 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80103be6:	f3 0f 1e fb          	endbr32 
80103bea:	55                   	push   %ebp
80103beb:	89 e5                	mov    %esp,%ebp
80103bed:	53                   	push   %ebx
80103bee:	83 ec 04             	sub    $0x4,%esp
80103bf1:	9c                   	pushf  
80103bf2:	5b                   	pop    %ebx
  asm volatile("cli");
80103bf3:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
80103bf4:	e8 53 f6 ff ff       	call   8010324c <mycpu>
80103bf9:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c00:	74 12                	je     80103c14 <pushcli+0x2e>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
80103c02:	e8 45 f6 ff ff       	call   8010324c <mycpu>
80103c07:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80103c0e:	83 c4 04             	add    $0x4,%esp
80103c11:	5b                   	pop    %ebx
80103c12:	5d                   	pop    %ebp
80103c13:	c3                   	ret    
    mycpu()->intena = eflags & FL_IF;
80103c14:	e8 33 f6 ff ff       	call   8010324c <mycpu>
80103c19:	81 e3 00 02 00 00    	and    $0x200,%ebx
80103c1f:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
80103c25:	eb db                	jmp    80103c02 <pushcli+0x1c>

80103c27 <popcli>:

void
popcli(void)
{
80103c27:	f3 0f 1e fb          	endbr32 
80103c2b:	55                   	push   %ebp
80103c2c:	89 e5                	mov    %esp,%ebp
80103c2e:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103c31:	9c                   	pushf  
80103c32:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103c33:	f6 c4 02             	test   $0x2,%ah
80103c36:	75 28                	jne    80103c60 <popcli+0x39>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
80103c38:	e8 0f f6 ff ff       	call   8010324c <mycpu>
80103c3d:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80103c43:	8d 51 ff             	lea    -0x1(%ecx),%edx
80103c46:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
80103c4c:	85 d2                	test   %edx,%edx
80103c4e:	78 1d                	js     80103c6d <popcli+0x46>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c50:	e8 f7 f5 ff ff       	call   8010324c <mycpu>
80103c55:	83 b8 a4 00 00 00 00 	cmpl   $0x0,0xa4(%eax)
80103c5c:	74 1c                	je     80103c7a <popcli+0x53>
    sti();
}
80103c5e:	c9                   	leave  
80103c5f:	c3                   	ret    
    panic("popcli - interruptible");
80103c60:	83 ec 0c             	sub    $0xc,%esp
80103c63:	68 ef 6c 10 80       	push   $0x80106cef
80103c68:	e8 ef c6 ff ff       	call   8010035c <panic>
    panic("popcli");
80103c6d:	83 ec 0c             	sub    $0xc,%esp
80103c70:	68 06 6d 10 80       	push   $0x80106d06
80103c75:	e8 e2 c6 ff ff       	call   8010035c <panic>
  if(mycpu()->ncli == 0 && mycpu()->intena)
80103c7a:	e8 cd f5 ff ff       	call   8010324c <mycpu>
80103c7f:	83 b8 a8 00 00 00 00 	cmpl   $0x0,0xa8(%eax)
80103c86:	74 d6                	je     80103c5e <popcli+0x37>
  asm volatile("sti");
80103c88:	fb                   	sti    
}
80103c89:	eb d3                	jmp    80103c5e <popcli+0x37>

80103c8b <holding>:
{
80103c8b:	f3 0f 1e fb          	endbr32 
80103c8f:	55                   	push   %ebp
80103c90:	89 e5                	mov    %esp,%ebp
80103c92:	53                   	push   %ebx
80103c93:	83 ec 04             	sub    $0x4,%esp
80103c96:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
80103c99:	e8 48 ff ff ff       	call   80103be6 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80103c9e:	83 3b 00             	cmpl   $0x0,(%ebx)
80103ca1:	75 12                	jne    80103cb5 <holding+0x2a>
80103ca3:	bb 00 00 00 00       	mov    $0x0,%ebx
  popcli();
80103ca8:	e8 7a ff ff ff       	call   80103c27 <popcli>
}
80103cad:	89 d8                	mov    %ebx,%eax
80103caf:	83 c4 04             	add    $0x4,%esp
80103cb2:	5b                   	pop    %ebx
80103cb3:	5d                   	pop    %ebp
80103cb4:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80103cb5:	8b 5b 08             	mov    0x8(%ebx),%ebx
80103cb8:	e8 8f f5 ff ff       	call   8010324c <mycpu>
80103cbd:	39 c3                	cmp    %eax,%ebx
80103cbf:	74 07                	je     80103cc8 <holding+0x3d>
80103cc1:	bb 00 00 00 00       	mov    $0x0,%ebx
80103cc6:	eb e0                	jmp    80103ca8 <holding+0x1d>
80103cc8:	bb 01 00 00 00       	mov    $0x1,%ebx
80103ccd:	eb d9                	jmp    80103ca8 <holding+0x1d>

80103ccf <acquire>:
{
80103ccf:	f3 0f 1e fb          	endbr32 
80103cd3:	55                   	push   %ebp
80103cd4:	89 e5                	mov    %esp,%ebp
80103cd6:	53                   	push   %ebx
80103cd7:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80103cda:	e8 07 ff ff ff       	call   80103be6 <pushcli>
  if(holding(lk))
80103cdf:	83 ec 0c             	sub    $0xc,%esp
80103ce2:	ff 75 08             	pushl  0x8(%ebp)
80103ce5:	e8 a1 ff ff ff       	call   80103c8b <holding>
80103cea:	83 c4 10             	add    $0x10,%esp
80103ced:	85 c0                	test   %eax,%eax
80103cef:	75 3a                	jne    80103d2b <acquire+0x5c>
  while(xchg(&lk->locked, 1) != 0)
80103cf1:	8b 55 08             	mov    0x8(%ebp),%edx
  asm volatile("lock; xchgl %0, %1" :
80103cf4:	b8 01 00 00 00       	mov    $0x1,%eax
80103cf9:	f0 87 02             	lock xchg %eax,(%edx)
80103cfc:	85 c0                	test   %eax,%eax
80103cfe:	75 f1                	jne    80103cf1 <acquire+0x22>
  __sync_synchronize();
80103d00:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80103d05:	8b 5d 08             	mov    0x8(%ebp),%ebx
80103d08:	e8 3f f5 ff ff       	call   8010324c <mycpu>
80103d0d:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
80103d10:	8b 45 08             	mov    0x8(%ebp),%eax
80103d13:	83 c0 0c             	add    $0xc,%eax
80103d16:	83 ec 08             	sub    $0x8,%esp
80103d19:	50                   	push   %eax
80103d1a:	8d 45 08             	lea    0x8(%ebp),%eax
80103d1d:	50                   	push   %eax
80103d1e:	e8 7b fe ff ff       	call   80103b9e <getcallerpcs>
}
80103d23:	83 c4 10             	add    $0x10,%esp
80103d26:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d29:	c9                   	leave  
80103d2a:	c3                   	ret    
    panic("acquire");
80103d2b:	83 ec 0c             	sub    $0xc,%esp
80103d2e:	68 0d 6d 10 80       	push   $0x80106d0d
80103d33:	e8 24 c6 ff ff       	call   8010035c <panic>

80103d38 <release>:
{
80103d38:	f3 0f 1e fb          	endbr32 
80103d3c:	55                   	push   %ebp
80103d3d:	89 e5                	mov    %esp,%ebp
80103d3f:	53                   	push   %ebx
80103d40:	83 ec 10             	sub    $0x10,%esp
80103d43:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
80103d46:	53                   	push   %ebx
80103d47:	e8 3f ff ff ff       	call   80103c8b <holding>
80103d4c:	83 c4 10             	add    $0x10,%esp
80103d4f:	85 c0                	test   %eax,%eax
80103d51:	74 23                	je     80103d76 <release+0x3e>
  lk->pcs[0] = 0;
80103d53:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
80103d5a:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
80103d61:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
80103d66:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  popcli();
80103d6c:	e8 b6 fe ff ff       	call   80103c27 <popcli>
}
80103d71:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d74:	c9                   	leave  
80103d75:	c3                   	ret    
    panic("release");
80103d76:	83 ec 0c             	sub    $0xc,%esp
80103d79:	68 15 6d 10 80       	push   $0x80106d15
80103d7e:	e8 d9 c5 ff ff       	call   8010035c <panic>

80103d83 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80103d83:	f3 0f 1e fb          	endbr32 
80103d87:	55                   	push   %ebp
80103d88:	89 e5                	mov    %esp,%ebp
80103d8a:	57                   	push   %edi
80103d8b:	53                   	push   %ebx
80103d8c:	8b 55 08             	mov    0x8(%ebp),%edx
80103d8f:	8b 45 0c             	mov    0xc(%ebp),%eax
80103d92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
80103d95:	f6 c2 03             	test   $0x3,%dl
80103d98:	75 25                	jne    80103dbf <memset+0x3c>
80103d9a:	f6 c1 03             	test   $0x3,%cl
80103d9d:	75 20                	jne    80103dbf <memset+0x3c>
    c &= 0xFF;
80103d9f:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
80103da2:	c1 e9 02             	shr    $0x2,%ecx
80103da5:	c1 e0 18             	shl    $0x18,%eax
80103da8:	89 fb                	mov    %edi,%ebx
80103daa:	c1 e3 10             	shl    $0x10,%ebx
80103dad:	09 d8                	or     %ebx,%eax
80103daf:	89 fb                	mov    %edi,%ebx
80103db1:	c1 e3 08             	shl    $0x8,%ebx
80103db4:	09 d8                	or     %ebx,%eax
80103db6:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
80103db8:	89 d7                	mov    %edx,%edi
80103dba:	fc                   	cld    
80103dbb:	f3 ab                	rep stos %eax,%es:(%edi)
}
80103dbd:	eb 05                	jmp    80103dc4 <memset+0x41>
  asm volatile("cld; rep stosb" :
80103dbf:	89 d7                	mov    %edx,%edi
80103dc1:	fc                   	cld    
80103dc2:	f3 aa                	rep stos %al,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80103dc4:	89 d0                	mov    %edx,%eax
80103dc6:	5b                   	pop    %ebx
80103dc7:	5f                   	pop    %edi
80103dc8:	5d                   	pop    %ebp
80103dc9:	c3                   	ret    

80103dca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80103dca:	f3 0f 1e fb          	endbr32 
80103dce:	55                   	push   %ebp
80103dcf:	89 e5                	mov    %esp,%ebp
80103dd1:	56                   	push   %esi
80103dd2:	53                   	push   %ebx
80103dd3:	8b 4d 08             	mov    0x8(%ebp),%ecx
80103dd6:	8b 55 0c             	mov    0xc(%ebp),%edx
80103dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80103ddc:	8d 70 ff             	lea    -0x1(%eax),%esi
80103ddf:	85 c0                	test   %eax,%eax
80103de1:	74 1c                	je     80103dff <memcmp+0x35>
    if(*s1 != *s2)
80103de3:	0f b6 01             	movzbl (%ecx),%eax
80103de6:	0f b6 1a             	movzbl (%edx),%ebx
80103de9:	38 d8                	cmp    %bl,%al
80103deb:	75 0a                	jne    80103df7 <memcmp+0x2d>
      return *s1 - *s2;
    s1++, s2++;
80103ded:	83 c1 01             	add    $0x1,%ecx
80103df0:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80103df3:	89 f0                	mov    %esi,%eax
80103df5:	eb e5                	jmp    80103ddc <memcmp+0x12>
      return *s1 - *s2;
80103df7:	0f b6 c0             	movzbl %al,%eax
80103dfa:	0f b6 db             	movzbl %bl,%ebx
80103dfd:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80103dff:	5b                   	pop    %ebx
80103e00:	5e                   	pop    %esi
80103e01:	5d                   	pop    %ebp
80103e02:	c3                   	ret    

80103e03 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80103e03:	f3 0f 1e fb          	endbr32 
80103e07:	55                   	push   %ebp
80103e08:	89 e5                	mov    %esp,%ebp
80103e0a:	56                   	push   %esi
80103e0b:	53                   	push   %ebx
80103e0c:	8b 75 08             	mov    0x8(%ebp),%esi
80103e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
80103e12:	8b 45 10             	mov    0x10(%ebp),%eax
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80103e15:	39 f2                	cmp    %esi,%edx
80103e17:	73 3a                	jae    80103e53 <memmove+0x50>
80103e19:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
80103e1c:	39 f1                	cmp    %esi,%ecx
80103e1e:	76 37                	jbe    80103e57 <memmove+0x54>
    s += n;
    d += n;
80103e20:	8d 14 06             	lea    (%esi,%eax,1),%edx
    while(n-- > 0)
80103e23:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e26:	85 c0                	test   %eax,%eax
80103e28:	74 23                	je     80103e4d <memmove+0x4a>
      *--d = *--s;
80103e2a:	83 e9 01             	sub    $0x1,%ecx
80103e2d:	83 ea 01             	sub    $0x1,%edx
80103e30:	0f b6 01             	movzbl (%ecx),%eax
80103e33:	88 02                	mov    %al,(%edx)
    while(n-- > 0)
80103e35:	89 d8                	mov    %ebx,%eax
80103e37:	eb ea                	jmp    80103e23 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;
80103e39:	0f b6 02             	movzbl (%edx),%eax
80103e3c:	88 01                	mov    %al,(%ecx)
80103e3e:	8d 49 01             	lea    0x1(%ecx),%ecx
80103e41:	8d 52 01             	lea    0x1(%edx),%edx
    while(n-- > 0)
80103e44:	89 d8                	mov    %ebx,%eax
80103e46:	8d 58 ff             	lea    -0x1(%eax),%ebx
80103e49:	85 c0                	test   %eax,%eax
80103e4b:	75 ec                	jne    80103e39 <memmove+0x36>

  return dst;
}
80103e4d:	89 f0                	mov    %esi,%eax
80103e4f:	5b                   	pop    %ebx
80103e50:	5e                   	pop    %esi
80103e51:	5d                   	pop    %ebp
80103e52:	c3                   	ret    
80103e53:	89 f1                	mov    %esi,%ecx
80103e55:	eb ef                	jmp    80103e46 <memmove+0x43>
80103e57:	89 f1                	mov    %esi,%ecx
80103e59:	eb eb                	jmp    80103e46 <memmove+0x43>

80103e5b <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80103e5b:	f3 0f 1e fb          	endbr32 
80103e5f:	55                   	push   %ebp
80103e60:	89 e5                	mov    %esp,%ebp
80103e62:	83 ec 0c             	sub    $0xc,%esp
  return memmove(dst, src, n);
80103e65:	ff 75 10             	pushl  0x10(%ebp)
80103e68:	ff 75 0c             	pushl  0xc(%ebp)
80103e6b:	ff 75 08             	pushl  0x8(%ebp)
80103e6e:	e8 90 ff ff ff       	call   80103e03 <memmove>
}
80103e73:	c9                   	leave  
80103e74:	c3                   	ret    

80103e75 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
80103e75:	f3 0f 1e fb          	endbr32 
80103e79:	55                   	push   %ebp
80103e7a:	89 e5                	mov    %esp,%ebp
80103e7c:	53                   	push   %ebx
80103e7d:	8b 55 08             	mov    0x8(%ebp),%edx
80103e80:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103e83:	8b 45 10             	mov    0x10(%ebp),%eax
  while(n > 0 && *p && *p == *q)
80103e86:	eb 09                	jmp    80103e91 <strncmp+0x1c>
    n--, p++, q++;
80103e88:	83 e8 01             	sub    $0x1,%eax
80103e8b:	83 c2 01             	add    $0x1,%edx
80103e8e:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80103e91:	85 c0                	test   %eax,%eax
80103e93:	74 0b                	je     80103ea0 <strncmp+0x2b>
80103e95:	0f b6 1a             	movzbl (%edx),%ebx
80103e98:	84 db                	test   %bl,%bl
80103e9a:	74 04                	je     80103ea0 <strncmp+0x2b>
80103e9c:	3a 19                	cmp    (%ecx),%bl
80103e9e:	74 e8                	je     80103e88 <strncmp+0x13>
  if(n == 0)
80103ea0:	85 c0                	test   %eax,%eax
80103ea2:	74 0b                	je     80103eaf <strncmp+0x3a>
    return 0;
  return (uchar)*p - (uchar)*q;
80103ea4:	0f b6 02             	movzbl (%edx),%eax
80103ea7:	0f b6 11             	movzbl (%ecx),%edx
80103eaa:	29 d0                	sub    %edx,%eax
}
80103eac:	5b                   	pop    %ebx
80103ead:	5d                   	pop    %ebp
80103eae:	c3                   	ret    
    return 0;
80103eaf:	b8 00 00 00 00       	mov    $0x0,%eax
80103eb4:	eb f6                	jmp    80103eac <strncmp+0x37>

80103eb6 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80103eb6:	f3 0f 1e fb          	endbr32 
80103eba:	55                   	push   %ebp
80103ebb:	89 e5                	mov    %esp,%ebp
80103ebd:	57                   	push   %edi
80103ebe:	56                   	push   %esi
80103ebf:	53                   	push   %ebx
80103ec0:	8b 7d 08             	mov    0x8(%ebp),%edi
80103ec3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103ec6:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80103ec9:	89 fa                	mov    %edi,%edx
80103ecb:	eb 04                	jmp    80103ed1 <strncpy+0x1b>
80103ecd:	89 f1                	mov    %esi,%ecx
80103ecf:	89 da                	mov    %ebx,%edx
80103ed1:	89 c3                	mov    %eax,%ebx
80103ed3:	83 e8 01             	sub    $0x1,%eax
80103ed6:	85 db                	test   %ebx,%ebx
80103ed8:	7e 1b                	jle    80103ef5 <strncpy+0x3f>
80103eda:	8d 71 01             	lea    0x1(%ecx),%esi
80103edd:	8d 5a 01             	lea    0x1(%edx),%ebx
80103ee0:	0f b6 09             	movzbl (%ecx),%ecx
80103ee3:	88 0a                	mov    %cl,(%edx)
80103ee5:	84 c9                	test   %cl,%cl
80103ee7:	75 e4                	jne    80103ecd <strncpy+0x17>
80103ee9:	89 da                	mov    %ebx,%edx
80103eeb:	eb 08                	jmp    80103ef5 <strncpy+0x3f>
    ;
  while(n-- > 0)
    *s++ = 0;
80103eed:	c6 02 00             	movb   $0x0,(%edx)
  while(n-- > 0)
80103ef0:	89 c8                	mov    %ecx,%eax
    *s++ = 0;
80103ef2:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
80103ef5:	8d 48 ff             	lea    -0x1(%eax),%ecx
80103ef8:	85 c0                	test   %eax,%eax
80103efa:	7f f1                	jg     80103eed <strncpy+0x37>
  return os;
}
80103efc:	89 f8                	mov    %edi,%eax
80103efe:	5b                   	pop    %ebx
80103eff:	5e                   	pop    %esi
80103f00:	5f                   	pop    %edi
80103f01:	5d                   	pop    %ebp
80103f02:	c3                   	ret    

80103f03 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80103f03:	f3 0f 1e fb          	endbr32 
80103f07:	55                   	push   %ebp
80103f08:	89 e5                	mov    %esp,%ebp
80103f0a:	57                   	push   %edi
80103f0b:	56                   	push   %esi
80103f0c:	53                   	push   %ebx
80103f0d:	8b 7d 08             	mov    0x8(%ebp),%edi
80103f10:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80103f13:	8b 45 10             	mov    0x10(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80103f16:	85 c0                	test   %eax,%eax
80103f18:	7e 23                	jle    80103f3d <safestrcpy+0x3a>
80103f1a:	89 fa                	mov    %edi,%edx
80103f1c:	eb 04                	jmp    80103f22 <safestrcpy+0x1f>
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80103f1e:	89 f1                	mov    %esi,%ecx
80103f20:	89 da                	mov    %ebx,%edx
80103f22:	83 e8 01             	sub    $0x1,%eax
80103f25:	85 c0                	test   %eax,%eax
80103f27:	7e 11                	jle    80103f3a <safestrcpy+0x37>
80103f29:	8d 71 01             	lea    0x1(%ecx),%esi
80103f2c:	8d 5a 01             	lea    0x1(%edx),%ebx
80103f2f:	0f b6 09             	movzbl (%ecx),%ecx
80103f32:	88 0a                	mov    %cl,(%edx)
80103f34:	84 c9                	test   %cl,%cl
80103f36:	75 e6                	jne    80103f1e <safestrcpy+0x1b>
80103f38:	89 da                	mov    %ebx,%edx
    ;
  *s = 0;
80103f3a:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80103f3d:	89 f8                	mov    %edi,%eax
80103f3f:	5b                   	pop    %ebx
80103f40:	5e                   	pop    %esi
80103f41:	5f                   	pop    %edi
80103f42:	5d                   	pop    %ebp
80103f43:	c3                   	ret    

80103f44 <strlen>:

int
strlen(const char *s)
{
80103f44:	f3 0f 1e fb          	endbr32 
80103f48:	55                   	push   %ebp
80103f49:	89 e5                	mov    %esp,%ebp
80103f4b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80103f4e:	b8 00 00 00 00       	mov    $0x0,%eax
80103f53:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80103f57:	74 05                	je     80103f5e <strlen+0x1a>
80103f59:	83 c0 01             	add    $0x1,%eax
80103f5c:	eb f5                	jmp    80103f53 <strlen+0xf>
    ;
  return n;
}
80103f5e:	5d                   	pop    %ebp
80103f5f:	c3                   	ret    

80103f60 <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80103f60:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80103f64:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80103f68:	55                   	push   %ebp
  pushl %ebx
80103f69:	53                   	push   %ebx
  pushl %esi
80103f6a:	56                   	push   %esi
  pushl %edi
80103f6b:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80103f6c:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80103f6e:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80103f70:	5f                   	pop    %edi
  popl %esi
80103f71:	5e                   	pop    %esi
  popl %ebx
80103f72:	5b                   	pop    %ebx
  popl %ebp
80103f73:	5d                   	pop    %ebp
  ret
80103f74:	c3                   	ret    

80103f75 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80103f75:	f3 0f 1e fb          	endbr32 
80103f79:	55                   	push   %ebp
80103f7a:	89 e5                	mov    %esp,%ebp
80103f7c:	53                   	push   %ebx
80103f7d:	83 ec 04             	sub    $0x4,%esp
80103f80:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80103f83:	e8 43 f3 ff ff       	call   801032cb <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80103f88:	8b 00                	mov    (%eax),%eax
80103f8a:	39 d8                	cmp    %ebx,%eax
80103f8c:	76 19                	jbe    80103fa7 <fetchint+0x32>
80103f8e:	8d 53 04             	lea    0x4(%ebx),%edx
80103f91:	39 d0                	cmp    %edx,%eax
80103f93:	72 19                	jb     80103fae <fetchint+0x39>
    return -1;
  *ip = *(int*)(addr);
80103f95:	8b 13                	mov    (%ebx),%edx
80103f97:	8b 45 0c             	mov    0xc(%ebp),%eax
80103f9a:	89 10                	mov    %edx,(%eax)
  return 0;
80103f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80103fa1:	83 c4 04             	add    $0x4,%esp
80103fa4:	5b                   	pop    %ebx
80103fa5:	5d                   	pop    %ebp
80103fa6:	c3                   	ret    
    return -1;
80103fa7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fac:	eb f3                	jmp    80103fa1 <fetchint+0x2c>
80103fae:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103fb3:	eb ec                	jmp    80103fa1 <fetchint+0x2c>

80103fb5 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80103fb5:	f3 0f 1e fb          	endbr32 
80103fb9:	55                   	push   %ebp
80103fba:	89 e5                	mov    %esp,%ebp
80103fbc:	53                   	push   %ebx
80103fbd:	83 ec 04             	sub    $0x4,%esp
80103fc0:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80103fc3:	e8 03 f3 ff ff       	call   801032cb <myproc>

  if(addr >= curproc->sz)
80103fc8:	39 18                	cmp    %ebx,(%eax)
80103fca:	76 26                	jbe    80103ff2 <fetchstr+0x3d>
    return -1;
  *pp = (char*)addr;
80103fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80103fcf:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80103fd1:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80103fd3:	89 d8                	mov    %ebx,%eax
80103fd5:	39 d0                	cmp    %edx,%eax
80103fd7:	73 0e                	jae    80103fe7 <fetchstr+0x32>
    if(*s == 0)
80103fd9:	80 38 00             	cmpb   $0x0,(%eax)
80103fdc:	74 05                	je     80103fe3 <fetchstr+0x2e>
  for(s = *pp; s < ep; s++){
80103fde:	83 c0 01             	add    $0x1,%eax
80103fe1:	eb f2                	jmp    80103fd5 <fetchstr+0x20>
      return s - *pp;
80103fe3:	29 d8                	sub    %ebx,%eax
80103fe5:	eb 05                	jmp    80103fec <fetchstr+0x37>
  }
  return -1;
80103fe7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fec:	83 c4 04             	add    $0x4,%esp
80103fef:	5b                   	pop    %ebx
80103ff0:	5d                   	pop    %ebp
80103ff1:	c3                   	ret    
    return -1;
80103ff2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ff7:	eb f3                	jmp    80103fec <fetchstr+0x37>

80103ff9 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80103ff9:	f3 0f 1e fb          	endbr32 
80103ffd:	55                   	push   %ebp
80103ffe:	89 e5                	mov    %esp,%ebp
80104000:	83 ec 08             	sub    $0x8,%esp
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104003:	e8 c3 f2 ff ff       	call   801032cb <myproc>
80104008:	8b 50 18             	mov    0x18(%eax),%edx
8010400b:	8b 45 08             	mov    0x8(%ebp),%eax
8010400e:	c1 e0 02             	shl    $0x2,%eax
80104011:	03 42 44             	add    0x44(%edx),%eax
80104014:	83 ec 08             	sub    $0x8,%esp
80104017:	ff 75 0c             	pushl  0xc(%ebp)
8010401a:	83 c0 04             	add    $0x4,%eax
8010401d:	50                   	push   %eax
8010401e:	e8 52 ff ff ff       	call   80103f75 <fetchint>
}
80104023:	c9                   	leave  
80104024:	c3                   	ret    

80104025 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104025:	f3 0f 1e fb          	endbr32 
80104029:	55                   	push   %ebp
8010402a:	89 e5                	mov    %esp,%ebp
8010402c:	56                   	push   %esi
8010402d:	53                   	push   %ebx
8010402e:	83 ec 10             	sub    $0x10,%esp
80104031:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
80104034:	e8 92 f2 ff ff       	call   801032cb <myproc>
80104039:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
8010403b:	83 ec 08             	sub    $0x8,%esp
8010403e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104041:	50                   	push   %eax
80104042:	ff 75 08             	pushl  0x8(%ebp)
80104045:	e8 af ff ff ff       	call   80103ff9 <argint>
8010404a:	83 c4 10             	add    $0x10,%esp
8010404d:	85 c0                	test   %eax,%eax
8010404f:	78 24                	js     80104075 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104051:	85 db                	test   %ebx,%ebx
80104053:	78 27                	js     8010407c <argptr+0x57>
80104055:	8b 16                	mov    (%esi),%edx
80104057:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010405a:	39 c2                	cmp    %eax,%edx
8010405c:	76 25                	jbe    80104083 <argptr+0x5e>
8010405e:	01 c3                	add    %eax,%ebx
80104060:	39 da                	cmp    %ebx,%edx
80104062:	72 26                	jb     8010408a <argptr+0x65>
    return -1;
  *pp = (char*)i;
80104064:	8b 55 0c             	mov    0xc(%ebp),%edx
80104067:	89 02                	mov    %eax,(%edx)
  return 0;
80104069:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010406e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104071:	5b                   	pop    %ebx
80104072:	5e                   	pop    %esi
80104073:	5d                   	pop    %ebp
80104074:	c3                   	ret    
    return -1;
80104075:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010407a:	eb f2                	jmp    8010406e <argptr+0x49>
    return -1;
8010407c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104081:	eb eb                	jmp    8010406e <argptr+0x49>
80104083:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104088:	eb e4                	jmp    8010406e <argptr+0x49>
8010408a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010408f:	eb dd                	jmp    8010406e <argptr+0x49>

80104091 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104091:	f3 0f 1e fb          	endbr32 
80104095:	55                   	push   %ebp
80104096:	89 e5                	mov    %esp,%ebp
80104098:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
8010409b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010409e:	50                   	push   %eax
8010409f:	ff 75 08             	pushl  0x8(%ebp)
801040a2:	e8 52 ff ff ff       	call   80103ff9 <argint>
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	85 c0                	test   %eax,%eax
801040ac:	78 13                	js     801040c1 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
801040ae:	83 ec 08             	sub    $0x8,%esp
801040b1:	ff 75 0c             	pushl  0xc(%ebp)
801040b4:	ff 75 f4             	pushl  -0xc(%ebp)
801040b7:	e8 f9 fe ff ff       	call   80103fb5 <fetchstr>
801040bc:	83 c4 10             	add    $0x10,%esp
}
801040bf:	c9                   	leave  
801040c0:	c3                   	ret    
    return -1;
801040c1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801040c6:	eb f7                	jmp    801040bf <argstr+0x2e>

801040c8 <syscall>:
[SYS_getiocounts]   sys_getiocounts,
};

void
syscall(void)
{
801040c8:	f3 0f 1e fb          	endbr32 
801040cc:	55                   	push   %ebp
801040cd:	89 e5                	mov    %esp,%ebp
801040cf:	53                   	push   %ebx
801040d0:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *curproc = myproc();
801040d3:	e8 f3 f1 ff ff       	call   801032cb <myproc>
801040d8:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801040da:	8b 40 18             	mov    0x18(%eax),%eax
801040dd:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801040e0:	8d 50 ff             	lea    -0x1(%eax),%edx
801040e3:	83 fa 15             	cmp    $0x15,%edx
801040e6:	77 17                	ja     801040ff <syscall+0x37>
801040e8:	8b 14 85 40 6d 10 80 	mov    -0x7fef92c0(,%eax,4),%edx
801040ef:	85 d2                	test   %edx,%edx
801040f1:	74 0c                	je     801040ff <syscall+0x37>
    curproc->tf->eax = syscalls[num]();
801040f3:	ff d2                	call   *%edx
801040f5:	89 c2                	mov    %eax,%edx
801040f7:	8b 43 18             	mov    0x18(%ebx),%eax
801040fa:	89 50 1c             	mov    %edx,0x1c(%eax)
801040fd:	eb 1f                	jmp    8010411e <syscall+0x56>
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
801040ff:	8d 53 6c             	lea    0x6c(%ebx),%edx
    cprintf("%d %s: unknown sys call %d\n",
80104102:	50                   	push   %eax
80104103:	52                   	push   %edx
80104104:	ff 73 10             	pushl  0x10(%ebx)
80104107:	68 1d 6d 10 80       	push   $0x80106d1d
8010410c:	e8 18 c5 ff ff       	call   80100629 <cprintf>
    curproc->tf->eax = -1;
80104111:	8b 43 18             	mov    0x18(%ebx),%eax
80104114:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
8010411b:	83 c4 10             	add    $0x10,%esp
  }
}
8010411e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104121:	c9                   	leave  
80104122:	c3                   	ret    

80104123 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
80104123:	55                   	push   %ebp
80104124:	89 e5                	mov    %esp,%ebp
80104126:	56                   	push   %esi
80104127:	53                   	push   %ebx
80104128:	83 ec 18             	sub    $0x18,%esp
8010412b:	89 d6                	mov    %edx,%esi
8010412d:	89 cb                	mov    %ecx,%ebx
  int fd;
  struct file *f;

  if (argint(n, &fd) < 0)
8010412f:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104132:	52                   	push   %edx
80104133:	50                   	push   %eax
80104134:	e8 c0 fe ff ff       	call   80103ff9 <argint>
80104139:	83 c4 10             	add    $0x10,%esp
8010413c:	85 c0                	test   %eax,%eax
8010413e:	78 35                	js     80104175 <argfd+0x52>
    return -1;
  if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
80104140:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104144:	77 28                	ja     8010416e <argfd+0x4b>
80104146:	e8 80 f1 ff ff       	call   801032cb <myproc>
8010414b:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010414e:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104152:	85 c0                	test   %eax,%eax
80104154:	74 18                	je     8010416e <argfd+0x4b>
    return -1;
  if (pfd)
80104156:	85 f6                	test   %esi,%esi
80104158:	74 02                	je     8010415c <argfd+0x39>
    *pfd = fd;
8010415a:	89 16                	mov    %edx,(%esi)
  if (pf)
8010415c:	85 db                	test   %ebx,%ebx
8010415e:	74 1c                	je     8010417c <argfd+0x59>
    *pf = f;
80104160:	89 03                	mov    %eax,(%ebx)
  return 0;
80104162:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104167:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010416a:	5b                   	pop    %ebx
8010416b:	5e                   	pop    %esi
8010416c:	5d                   	pop    %ebp
8010416d:	c3                   	ret    
    return -1;
8010416e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104173:	eb f2                	jmp    80104167 <argfd+0x44>
    return -1;
80104175:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010417a:	eb eb                	jmp    80104167 <argfd+0x44>
  return 0;
8010417c:	b8 00 00 00 00       	mov    $0x0,%eax
80104181:	eb e4                	jmp    80104167 <argfd+0x44>

80104183 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104183:	55                   	push   %ebp
80104184:	89 e5                	mov    %esp,%ebp
80104186:	53                   	push   %ebx
80104187:	83 ec 04             	sub    $0x4,%esp
8010418a:	89 c3                	mov    %eax,%ebx
  int fd;
  struct proc *curproc = myproc();
8010418c:	e8 3a f1 ff ff       	call   801032cb <myproc>
80104191:	89 c2                	mov    %eax,%edx

  for (fd = 0; fd < NOFILE; fd++)
80104193:	b8 00 00 00 00       	mov    $0x0,%eax
80104198:	83 f8 0f             	cmp    $0xf,%eax
8010419b:	7f 12                	jg     801041af <fdalloc+0x2c>
  {
    if (curproc->ofile[fd] == 0)
8010419d:	83 7c 82 28 00       	cmpl   $0x0,0x28(%edx,%eax,4)
801041a2:	74 05                	je     801041a9 <fdalloc+0x26>
  for (fd = 0; fd < NOFILE; fd++)
801041a4:	83 c0 01             	add    $0x1,%eax
801041a7:	eb ef                	jmp    80104198 <fdalloc+0x15>
    {
      curproc->ofile[fd] = f;
801041a9:	89 5c 82 28          	mov    %ebx,0x28(%edx,%eax,4)
      return fd;
801041ad:	eb 05                	jmp    801041b4 <fdalloc+0x31>
    }
  }
  return -1;
801041af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801041b4:	83 c4 04             	add    $0x4,%esp
801041b7:	5b                   	pop    %ebx
801041b8:	5d                   	pop    %ebp
801041b9:	c3                   	ret    

801041ba <isdirempty>:
}

// Is the directory dp empty except for "." and ".." ?
static int
isdirempty(struct inode *dp)
{
801041ba:	55                   	push   %ebp
801041bb:	89 e5                	mov    %esp,%ebp
801041bd:	56                   	push   %esi
801041be:	53                   	push   %ebx
801041bf:	83 ec 10             	sub    $0x10,%esp
801041c2:	89 c3                	mov    %eax,%ebx
  int off;
  struct dirent de;

  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801041c4:	b8 20 00 00 00       	mov    $0x20,%eax
801041c9:	89 c6                	mov    %eax,%esi
801041cb:	39 43 58             	cmp    %eax,0x58(%ebx)
801041ce:	76 2e                	jbe    801041fe <isdirempty+0x44>
  {
    if (readi(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801041d0:	6a 10                	push   $0x10
801041d2:	50                   	push   %eax
801041d3:	8d 45 e8             	lea    -0x18(%ebp),%eax
801041d6:	50                   	push   %eax
801041d7:	53                   	push   %ebx
801041d8:	e8 f3 d5 ff ff       	call   801017d0 <readi>
801041dd:	83 c4 10             	add    $0x10,%esp
801041e0:	83 f8 10             	cmp    $0x10,%eax
801041e3:	75 0c                	jne    801041f1 <isdirempty+0x37>
      panic("isdirempty: readi");
    if (de.inum != 0)
801041e5:	66 83 7d e8 00       	cmpw   $0x0,-0x18(%ebp)
801041ea:	75 1e                	jne    8010420a <isdirempty+0x50>
  for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
801041ec:	8d 46 10             	lea    0x10(%esi),%eax
801041ef:	eb d8                	jmp    801041c9 <isdirempty+0xf>
      panic("isdirempty: readi");
801041f1:	83 ec 0c             	sub    $0xc,%esp
801041f4:	68 9c 6d 10 80       	push   $0x80106d9c
801041f9:	e8 5e c1 ff ff       	call   8010035c <panic>
      return 0;
  }
  return 1;
801041fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
80104203:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104206:	5b                   	pop    %ebx
80104207:	5e                   	pop    %esi
80104208:	5d                   	pop    %ebp
80104209:	c3                   	ret    
      return 0;
8010420a:	b8 00 00 00 00       	mov    $0x0,%eax
8010420f:	eb f2                	jmp    80104203 <isdirempty+0x49>

80104211 <create>:
  return -1;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
80104211:	55                   	push   %ebp
80104212:	89 e5                	mov    %esp,%ebp
80104214:	57                   	push   %edi
80104215:	56                   	push   %esi
80104216:	53                   	push   %ebx
80104217:	83 ec 34             	sub    $0x34,%esp
8010421a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010421d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104220:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if ((dp = nameiparent(path, name)) == 0)
80104223:	8d 55 da             	lea    -0x26(%ebp),%edx
80104226:	52                   	push   %edx
80104227:	50                   	push   %eax
80104228:	e8 3e da ff ff       	call   80101c6b <nameiparent>
8010422d:	89 c6                	mov    %eax,%esi
8010422f:	83 c4 10             	add    $0x10,%esp
80104232:	85 c0                	test   %eax,%eax
80104234:	0f 84 33 01 00 00    	je     8010436d <create+0x15c>
    return 0;
  ilock(dp);
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	50                   	push   %eax
8010423e:	e8 87 d3 ff ff       	call   801015ca <ilock>

  if ((ip = dirlookup(dp, name, 0)) != 0)
80104243:	83 c4 0c             	add    $0xc,%esp
80104246:	6a 00                	push   $0x0
80104248:	8d 45 da             	lea    -0x26(%ebp),%eax
8010424b:	50                   	push   %eax
8010424c:	56                   	push   %esi
8010424d:	e8 c7 d7 ff ff       	call   80101a19 <dirlookup>
80104252:	89 c3                	mov    %eax,%ebx
80104254:	83 c4 10             	add    $0x10,%esp
80104257:	85 c0                	test   %eax,%eax
80104259:	74 3d                	je     80104298 <create+0x87>
  {
    iunlockput(dp);
8010425b:	83 ec 0c             	sub    $0xc,%esp
8010425e:	56                   	push   %esi
8010425f:	e8 19 d5 ff ff       	call   8010177d <iunlockput>
    ilock(ip);
80104264:	89 1c 24             	mov    %ebx,(%esp)
80104267:	e8 5e d3 ff ff       	call   801015ca <ilock>
    if (type == T_FILE && ip->type == T_FILE)
8010426c:	83 c4 10             	add    $0x10,%esp
8010426f:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104274:	75 07                	jne    8010427d <create+0x6c>
80104276:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010427b:	74 11                	je     8010428e <create+0x7d>
      return ip;
    iunlockput(ip);
8010427d:	83 ec 0c             	sub    $0xc,%esp
80104280:	53                   	push   %ebx
80104281:	e8 f7 d4 ff ff       	call   8010177d <iunlockput>
    return 0;
80104286:	83 c4 10             	add    $0x10,%esp
80104289:	bb 00 00 00 00       	mov    $0x0,%ebx
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010428e:	89 d8                	mov    %ebx,%eax
80104290:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104293:	5b                   	pop    %ebx
80104294:	5e                   	pop    %esi
80104295:	5f                   	pop    %edi
80104296:	5d                   	pop    %ebp
80104297:	c3                   	ret    
  if ((ip = ialloc(dp->dev, type)) == 0)
80104298:	83 ec 08             	sub    $0x8,%esp
8010429b:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
8010429f:	50                   	push   %eax
801042a0:	ff 36                	pushl  (%esi)
801042a2:	e8 14 d1 ff ff       	call   801013bb <ialloc>
801042a7:	89 c3                	mov    %eax,%ebx
801042a9:	83 c4 10             	add    $0x10,%esp
801042ac:	85 c0                	test   %eax,%eax
801042ae:	74 52                	je     80104302 <create+0xf1>
  ilock(ip);
801042b0:	83 ec 0c             	sub    $0xc,%esp
801042b3:	50                   	push   %eax
801042b4:	e8 11 d3 ff ff       	call   801015ca <ilock>
  ip->major = major;
801042b9:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
801042bd:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
801042c1:	66 89 7b 54          	mov    %di,0x54(%ebx)
  ip->nlink = 1;
801042c5:	66 c7 43 56 01 00    	movw   $0x1,0x56(%ebx)
  iupdate(ip);
801042cb:	89 1c 24             	mov    %ebx,(%esp)
801042ce:	e8 8e d1 ff ff       	call   80101461 <iupdate>
  if (type == T_DIR)
801042d3:	83 c4 10             	add    $0x10,%esp
801042d6:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
801042db:	74 32                	je     8010430f <create+0xfe>
  if (dirlink(dp, name, ip->inum) < 0)
801042dd:	83 ec 04             	sub    $0x4,%esp
801042e0:	ff 73 04             	pushl  0x4(%ebx)
801042e3:	8d 45 da             	lea    -0x26(%ebp),%eax
801042e6:	50                   	push   %eax
801042e7:	56                   	push   %esi
801042e8:	e8 ad d8 ff ff       	call   80101b9a <dirlink>
801042ed:	83 c4 10             	add    $0x10,%esp
801042f0:	85 c0                	test   %eax,%eax
801042f2:	78 6c                	js     80104360 <create+0x14f>
  iunlockput(dp);
801042f4:	83 ec 0c             	sub    $0xc,%esp
801042f7:	56                   	push   %esi
801042f8:	e8 80 d4 ff ff       	call   8010177d <iunlockput>
  return ip;
801042fd:	83 c4 10             	add    $0x10,%esp
80104300:	eb 8c                	jmp    8010428e <create+0x7d>
    panic("create: ialloc");
80104302:	83 ec 0c             	sub    $0xc,%esp
80104305:	68 ae 6d 10 80       	push   $0x80106dae
8010430a:	e8 4d c0 ff ff       	call   8010035c <panic>
    dp->nlink++; // for ".."
8010430f:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104313:	83 c0 01             	add    $0x1,%eax
80104316:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010431a:	83 ec 0c             	sub    $0xc,%esp
8010431d:	56                   	push   %esi
8010431e:	e8 3e d1 ff ff       	call   80101461 <iupdate>
    if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104323:	83 c4 0c             	add    $0xc,%esp
80104326:	ff 73 04             	pushl  0x4(%ebx)
80104329:	68 be 6d 10 80       	push   $0x80106dbe
8010432e:	53                   	push   %ebx
8010432f:	e8 66 d8 ff ff       	call   80101b9a <dirlink>
80104334:	83 c4 10             	add    $0x10,%esp
80104337:	85 c0                	test   %eax,%eax
80104339:	78 18                	js     80104353 <create+0x142>
8010433b:	83 ec 04             	sub    $0x4,%esp
8010433e:	ff 76 04             	pushl  0x4(%esi)
80104341:	68 bd 6d 10 80       	push   $0x80106dbd
80104346:	53                   	push   %ebx
80104347:	e8 4e d8 ff ff       	call   80101b9a <dirlink>
8010434c:	83 c4 10             	add    $0x10,%esp
8010434f:	85 c0                	test   %eax,%eax
80104351:	79 8a                	jns    801042dd <create+0xcc>
      panic("create dots");
80104353:	83 ec 0c             	sub    $0xc,%esp
80104356:	68 c0 6d 10 80       	push   $0x80106dc0
8010435b:	e8 fc bf ff ff       	call   8010035c <panic>
    panic("create: dirlink");
80104360:	83 ec 0c             	sub    $0xc,%esp
80104363:	68 cc 6d 10 80       	push   $0x80106dcc
80104368:	e8 ef bf ff ff       	call   8010035c <panic>
    return 0;
8010436d:	89 c3                	mov    %eax,%ebx
8010436f:	e9 1a ff ff ff       	jmp    8010428e <create+0x7d>

80104374 <sys_dup>:
{
80104374:	f3 0f 1e fb          	endbr32 
80104378:	55                   	push   %ebp
80104379:	89 e5                	mov    %esp,%ebp
8010437b:	53                   	push   %ebx
8010437c:	83 ec 14             	sub    $0x14,%esp
  if (argfd(0, 0, &f) < 0)
8010437f:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104382:	ba 00 00 00 00       	mov    $0x0,%edx
80104387:	b8 00 00 00 00       	mov    $0x0,%eax
8010438c:	e8 92 fd ff ff       	call   80104123 <argfd>
80104391:	85 c0                	test   %eax,%eax
80104393:	78 23                	js     801043b8 <sys_dup+0x44>
  if ((fd = fdalloc(f)) < 0)
80104395:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104398:	e8 e6 fd ff ff       	call   80104183 <fdalloc>
8010439d:	89 c3                	mov    %eax,%ebx
8010439f:	85 c0                	test   %eax,%eax
801043a1:	78 1c                	js     801043bf <sys_dup+0x4b>
  filedup(f);
801043a3:	83 ec 0c             	sub    $0xc,%esp
801043a6:	ff 75 f4             	pushl  -0xc(%ebp)
801043a9:	e8 0e c9 ff ff       	call   80100cbc <filedup>
  return fd;
801043ae:	83 c4 10             	add    $0x10,%esp
}
801043b1:	89 d8                	mov    %ebx,%eax
801043b3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043b6:	c9                   	leave  
801043b7:	c3                   	ret    
    return -1;
801043b8:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043bd:	eb f2                	jmp    801043b1 <sys_dup+0x3d>
    return -1;
801043bf:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
801043c4:	eb eb                	jmp    801043b1 <sys_dup+0x3d>

801043c6 <sys_read>:
{
801043c6:	f3 0f 1e fb          	endbr32 
801043ca:	55                   	push   %ebp
801043cb:	89 e5                	mov    %esp,%ebp
801043cd:	83 ec 18             	sub    $0x18,%esp
  myproc()->rc++;
801043d0:	e8 f6 ee ff ff       	call   801032cb <myproc>
801043d5:	8b 48 7c             	mov    0x7c(%eax),%ecx
801043d8:	8d 51 01             	lea    0x1(%ecx),%edx
801043db:	89 50 7c             	mov    %edx,0x7c(%eax)
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801043de:	8d 4d f4             	lea    -0xc(%ebp),%ecx
801043e1:	ba 00 00 00 00       	mov    $0x0,%edx
801043e6:	b8 00 00 00 00       	mov    $0x0,%eax
801043eb:	e8 33 fd ff ff       	call   80104123 <argfd>
801043f0:	85 c0                	test   %eax,%eax
801043f2:	78 43                	js     80104437 <sys_read+0x71>
801043f4:	83 ec 08             	sub    $0x8,%esp
801043f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
801043fa:	50                   	push   %eax
801043fb:	6a 02                	push   $0x2
801043fd:	e8 f7 fb ff ff       	call   80103ff9 <argint>
80104402:	83 c4 10             	add    $0x10,%esp
80104405:	85 c0                	test   %eax,%eax
80104407:	78 2e                	js     80104437 <sys_read+0x71>
80104409:	83 ec 04             	sub    $0x4,%esp
8010440c:	ff 75 f0             	pushl  -0x10(%ebp)
8010440f:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104412:	50                   	push   %eax
80104413:	6a 01                	push   $0x1
80104415:	e8 0b fc ff ff       	call   80104025 <argptr>
8010441a:	83 c4 10             	add    $0x10,%esp
8010441d:	85 c0                	test   %eax,%eax
8010441f:	78 16                	js     80104437 <sys_read+0x71>
  return fileread(f, p, n);
80104421:	83 ec 04             	sub    $0x4,%esp
80104424:	ff 75 f0             	pushl  -0x10(%ebp)
80104427:	ff 75 ec             	pushl  -0x14(%ebp)
8010442a:	ff 75 f4             	pushl  -0xc(%ebp)
8010442d:	e8 dc c9 ff ff       	call   80100e0e <fileread>
80104432:	83 c4 10             	add    $0x10,%esp
}
80104435:	c9                   	leave  
80104436:	c3                   	ret    
    return -1;
80104437:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010443c:	eb f7                	jmp    80104435 <sys_read+0x6f>

8010443e <sys_write>:
{
8010443e:	f3 0f 1e fb          	endbr32 
80104442:	55                   	push   %ebp
80104443:	89 e5                	mov    %esp,%ebp
80104445:	83 ec 18             	sub    $0x18,%esp
  myproc()->wc++;
80104448:	e8 7e ee ff ff       	call   801032cb <myproc>
8010444d:	8b 88 80 00 00 00    	mov    0x80(%eax),%ecx
80104453:	8d 51 01             	lea    0x1(%ecx),%edx
80104456:	89 90 80 00 00 00    	mov    %edx,0x80(%eax)
  if (argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
8010445c:	8d 4d f4             	lea    -0xc(%ebp),%ecx
8010445f:	ba 00 00 00 00       	mov    $0x0,%edx
80104464:	b8 00 00 00 00       	mov    $0x0,%eax
80104469:	e8 b5 fc ff ff       	call   80104123 <argfd>
8010446e:	85 c0                	test   %eax,%eax
80104470:	78 43                	js     801044b5 <sys_write+0x77>
80104472:	83 ec 08             	sub    $0x8,%esp
80104475:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104478:	50                   	push   %eax
80104479:	6a 02                	push   $0x2
8010447b:	e8 79 fb ff ff       	call   80103ff9 <argint>
80104480:	83 c4 10             	add    $0x10,%esp
80104483:	85 c0                	test   %eax,%eax
80104485:	78 2e                	js     801044b5 <sys_write+0x77>
80104487:	83 ec 04             	sub    $0x4,%esp
8010448a:	ff 75 f0             	pushl  -0x10(%ebp)
8010448d:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104490:	50                   	push   %eax
80104491:	6a 01                	push   $0x1
80104493:	e8 8d fb ff ff       	call   80104025 <argptr>
80104498:	83 c4 10             	add    $0x10,%esp
8010449b:	85 c0                	test   %eax,%eax
8010449d:	78 16                	js     801044b5 <sys_write+0x77>
  return filewrite(f, p, n);
8010449f:	83 ec 04             	sub    $0x4,%esp
801044a2:	ff 75 f0             	pushl  -0x10(%ebp)
801044a5:	ff 75 ec             	pushl  -0x14(%ebp)
801044a8:	ff 75 f4             	pushl  -0xc(%ebp)
801044ab:	e8 e7 c9 ff ff       	call   80100e97 <filewrite>
801044b0:	83 c4 10             	add    $0x10,%esp
}
801044b3:	c9                   	leave  
801044b4:	c3                   	ret    
    return -1;
801044b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801044ba:	eb f7                	jmp    801044b3 <sys_write+0x75>

801044bc <sys_close>:
{
801044bc:	f3 0f 1e fb          	endbr32 
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, &fd, &f) < 0)
801044c6:	8d 4d f0             	lea    -0x10(%ebp),%ecx
801044c9:	8d 55 f4             	lea    -0xc(%ebp),%edx
801044cc:	b8 00 00 00 00       	mov    $0x0,%eax
801044d1:	e8 4d fc ff ff       	call   80104123 <argfd>
801044d6:	85 c0                	test   %eax,%eax
801044d8:	78 25                	js     801044ff <sys_close+0x43>
  myproc()->ofile[fd] = 0;
801044da:	e8 ec ed ff ff       	call   801032cb <myproc>
801044df:	8b 55 f4             	mov    -0xc(%ebp),%edx
801044e2:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
801044e9:	00 
  fileclose(f);
801044ea:	83 ec 0c             	sub    $0xc,%esp
801044ed:	ff 75 f0             	pushl  -0x10(%ebp)
801044f0:	e8 10 c8 ff ff       	call   80100d05 <fileclose>
  return 0;
801044f5:	83 c4 10             	add    $0x10,%esp
801044f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
801044fd:	c9                   	leave  
801044fe:	c3                   	ret    
    return -1;
801044ff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104504:	eb f7                	jmp    801044fd <sys_close+0x41>

80104506 <sys_fstat>:
{
80104506:	f3 0f 1e fb          	endbr32 
8010450a:	55                   	push   %ebp
8010450b:	89 e5                	mov    %esp,%ebp
8010450d:	83 ec 18             	sub    $0x18,%esp
  if (argfd(0, 0, &f) < 0 || argptr(1, (void *)&st, sizeof(*st)) < 0)
80104510:	8d 4d f4             	lea    -0xc(%ebp),%ecx
80104513:	ba 00 00 00 00       	mov    $0x0,%edx
80104518:	b8 00 00 00 00       	mov    $0x0,%eax
8010451d:	e8 01 fc ff ff       	call   80104123 <argfd>
80104522:	85 c0                	test   %eax,%eax
80104524:	78 2a                	js     80104550 <sys_fstat+0x4a>
80104526:	83 ec 04             	sub    $0x4,%esp
80104529:	6a 14                	push   $0x14
8010452b:	8d 45 f0             	lea    -0x10(%ebp),%eax
8010452e:	50                   	push   %eax
8010452f:	6a 01                	push   $0x1
80104531:	e8 ef fa ff ff       	call   80104025 <argptr>
80104536:	83 c4 10             	add    $0x10,%esp
80104539:	85 c0                	test   %eax,%eax
8010453b:	78 13                	js     80104550 <sys_fstat+0x4a>
  return filestat(f, st);
8010453d:	83 ec 08             	sub    $0x8,%esp
80104540:	ff 75 f0             	pushl  -0x10(%ebp)
80104543:	ff 75 f4             	pushl  -0xc(%ebp)
80104546:	e8 78 c8 ff ff       	call   80100dc3 <filestat>
8010454b:	83 c4 10             	add    $0x10,%esp
}
8010454e:	c9                   	leave  
8010454f:	c3                   	ret    
    return -1;
80104550:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104555:	eb f7                	jmp    8010454e <sys_fstat+0x48>

80104557 <getiocounts>:
int getiocounts(struct iostat *iostat) {
80104557:	f3 0f 1e fb          	endbr32 
8010455b:	55                   	push   %ebp
8010455c:	89 e5                	mov    %esp,%ebp
8010455e:	53                   	push   %ebx
8010455f:	83 ec 04             	sub    $0x4,%esp
80104562:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iostat->readcount = myproc()->rc;
80104565:	e8 61 ed ff ff       	call   801032cb <myproc>
8010456a:	8b 40 7c             	mov    0x7c(%eax),%eax
8010456d:	89 03                	mov    %eax,(%ebx)
  iostat->writecount = myproc()->wc;
8010456f:	e8 57 ed ff ff       	call   801032cb <myproc>
80104574:	8b 80 80 00 00 00    	mov    0x80(%eax),%eax
8010457a:	89 43 04             	mov    %eax,0x4(%ebx)
}
8010457d:	b8 00 00 00 00       	mov    $0x0,%eax
80104582:	83 c4 04             	add    $0x4,%esp
80104585:	5b                   	pop    %ebx
80104586:	5d                   	pop    %ebp
80104587:	c3                   	ret    

80104588 <sys_link>:
{
80104588:	f3 0f 1e fb          	endbr32 
8010458c:	55                   	push   %ebp
8010458d:	89 e5                	mov    %esp,%ebp
8010458f:	56                   	push   %esi
80104590:	53                   	push   %ebx
80104591:	83 ec 28             	sub    $0x28,%esp
  if (argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104594:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104597:	50                   	push   %eax
80104598:	6a 00                	push   $0x0
8010459a:	e8 f2 fa ff ff       	call   80104091 <argstr>
8010459f:	83 c4 10             	add    $0x10,%esp
801045a2:	85 c0                	test   %eax,%eax
801045a4:	0f 88 d3 00 00 00    	js     8010467d <sys_link+0xf5>
801045aa:	83 ec 08             	sub    $0x8,%esp
801045ad:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801045b0:	50                   	push   %eax
801045b1:	6a 01                	push   $0x1
801045b3:	e8 d9 fa ff ff       	call   80104091 <argstr>
801045b8:	83 c4 10             	add    $0x10,%esp
801045bb:	85 c0                	test   %eax,%eax
801045bd:	0f 88 ba 00 00 00    	js     8010467d <sys_link+0xf5>
  begin_op();
801045c3:	e8 87 e2 ff ff       	call   8010284f <begin_op>
  if ((ip = namei(old)) == 0)
801045c8:	83 ec 0c             	sub    $0xc,%esp
801045cb:	ff 75 e0             	pushl  -0x20(%ebp)
801045ce:	e8 7c d6 ff ff       	call   80101c4f <namei>
801045d3:	89 c3                	mov    %eax,%ebx
801045d5:	83 c4 10             	add    $0x10,%esp
801045d8:	85 c0                	test   %eax,%eax
801045da:	0f 84 a4 00 00 00    	je     80104684 <sys_link+0xfc>
  ilock(ip);
801045e0:	83 ec 0c             	sub    $0xc,%esp
801045e3:	50                   	push   %eax
801045e4:	e8 e1 cf ff ff       	call   801015ca <ilock>
  if (ip->type == T_DIR)
801045e9:	83 c4 10             	add    $0x10,%esp
801045ec:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801045f1:	0f 84 99 00 00 00    	je     80104690 <sys_link+0x108>
  ip->nlink++;
801045f7:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801045fb:	83 c0 01             	add    $0x1,%eax
801045fe:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
80104602:	83 ec 0c             	sub    $0xc,%esp
80104605:	53                   	push   %ebx
80104606:	e8 56 ce ff ff       	call   80101461 <iupdate>
  iunlock(ip);
8010460b:	89 1c 24             	mov    %ebx,(%esp)
8010460e:	e8 7d d0 ff ff       	call   80101690 <iunlock>
  if ((dp = nameiparent(new, name)) == 0)
80104613:	83 c4 08             	add    $0x8,%esp
80104616:	8d 45 ea             	lea    -0x16(%ebp),%eax
80104619:	50                   	push   %eax
8010461a:	ff 75 e4             	pushl  -0x1c(%ebp)
8010461d:	e8 49 d6 ff ff       	call   80101c6b <nameiparent>
80104622:	89 c6                	mov    %eax,%esi
80104624:	83 c4 10             	add    $0x10,%esp
80104627:	85 c0                	test   %eax,%eax
80104629:	0f 84 85 00 00 00    	je     801046b4 <sys_link+0x12c>
  ilock(dp);
8010462f:	83 ec 0c             	sub    $0xc,%esp
80104632:	50                   	push   %eax
80104633:	e8 92 cf ff ff       	call   801015ca <ilock>
  if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
80104638:	83 c4 10             	add    $0x10,%esp
8010463b:	8b 03                	mov    (%ebx),%eax
8010463d:	39 06                	cmp    %eax,(%esi)
8010463f:	75 67                	jne    801046a8 <sys_link+0x120>
80104641:	83 ec 04             	sub    $0x4,%esp
80104644:	ff 73 04             	pushl  0x4(%ebx)
80104647:	8d 45 ea             	lea    -0x16(%ebp),%eax
8010464a:	50                   	push   %eax
8010464b:	56                   	push   %esi
8010464c:	e8 49 d5 ff ff       	call   80101b9a <dirlink>
80104651:	83 c4 10             	add    $0x10,%esp
80104654:	85 c0                	test   %eax,%eax
80104656:	78 50                	js     801046a8 <sys_link+0x120>
  iunlockput(dp);
80104658:	83 ec 0c             	sub    $0xc,%esp
8010465b:	56                   	push   %esi
8010465c:	e8 1c d1 ff ff       	call   8010177d <iunlockput>
  iput(ip);
80104661:	89 1c 24             	mov    %ebx,(%esp)
80104664:	e8 70 d0 ff ff       	call   801016d9 <iput>
  end_op();
80104669:	e8 5f e2 ff ff       	call   801028cd <end_op>
  return 0;
8010466e:	83 c4 10             	add    $0x10,%esp
80104671:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104676:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104679:	5b                   	pop    %ebx
8010467a:	5e                   	pop    %esi
8010467b:	5d                   	pop    %ebp
8010467c:	c3                   	ret    
    return -1;
8010467d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104682:	eb f2                	jmp    80104676 <sys_link+0xee>
    end_op();
80104684:	e8 44 e2 ff ff       	call   801028cd <end_op>
    return -1;
80104689:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010468e:	eb e6                	jmp    80104676 <sys_link+0xee>
    iunlockput(ip);
80104690:	83 ec 0c             	sub    $0xc,%esp
80104693:	53                   	push   %ebx
80104694:	e8 e4 d0 ff ff       	call   8010177d <iunlockput>
    end_op();
80104699:	e8 2f e2 ff ff       	call   801028cd <end_op>
    return -1;
8010469e:	83 c4 10             	add    $0x10,%esp
801046a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046a6:	eb ce                	jmp    80104676 <sys_link+0xee>
    iunlockput(dp);
801046a8:	83 ec 0c             	sub    $0xc,%esp
801046ab:	56                   	push   %esi
801046ac:	e8 cc d0 ff ff       	call   8010177d <iunlockput>
    goto bad;
801046b1:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
801046b4:	83 ec 0c             	sub    $0xc,%esp
801046b7:	53                   	push   %ebx
801046b8:	e8 0d cf ff ff       	call   801015ca <ilock>
  ip->nlink--;
801046bd:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801046c1:	83 e8 01             	sub    $0x1,%eax
801046c4:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801046c8:	89 1c 24             	mov    %ebx,(%esp)
801046cb:	e8 91 cd ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
801046d0:	89 1c 24             	mov    %ebx,(%esp)
801046d3:	e8 a5 d0 ff ff       	call   8010177d <iunlockput>
  end_op();
801046d8:	e8 f0 e1 ff ff       	call   801028cd <end_op>
  return -1;
801046dd:	83 c4 10             	add    $0x10,%esp
801046e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046e5:	eb 8f                	jmp    80104676 <sys_link+0xee>

801046e7 <sys_unlink>:
{
801046e7:	f3 0f 1e fb          	endbr32 
801046eb:	55                   	push   %ebp
801046ec:	89 e5                	mov    %esp,%ebp
801046ee:	57                   	push   %edi
801046ef:	56                   	push   %esi
801046f0:	53                   	push   %ebx
801046f1:	83 ec 44             	sub    $0x44,%esp
  if (argstr(0, &path) < 0)
801046f4:	8d 45 c4             	lea    -0x3c(%ebp),%eax
801046f7:	50                   	push   %eax
801046f8:	6a 00                	push   $0x0
801046fa:	e8 92 f9 ff ff       	call   80104091 <argstr>
801046ff:	83 c4 10             	add    $0x10,%esp
80104702:	85 c0                	test   %eax,%eax
80104704:	0f 88 83 01 00 00    	js     8010488d <sys_unlink+0x1a6>
  begin_op();
8010470a:	e8 40 e1 ff ff       	call   8010284f <begin_op>
  if ((dp = nameiparent(path, name)) == 0)
8010470f:	83 ec 08             	sub    $0x8,%esp
80104712:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104715:	50                   	push   %eax
80104716:	ff 75 c4             	pushl  -0x3c(%ebp)
80104719:	e8 4d d5 ff ff       	call   80101c6b <nameiparent>
8010471e:	89 c6                	mov    %eax,%esi
80104720:	83 c4 10             	add    $0x10,%esp
80104723:	85 c0                	test   %eax,%eax
80104725:	0f 84 ed 00 00 00    	je     80104818 <sys_unlink+0x131>
  ilock(dp);
8010472b:	83 ec 0c             	sub    $0xc,%esp
8010472e:	50                   	push   %eax
8010472f:	e8 96 ce ff ff       	call   801015ca <ilock>
  if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104734:	83 c4 08             	add    $0x8,%esp
80104737:	68 be 6d 10 80       	push   $0x80106dbe
8010473c:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010473f:	50                   	push   %eax
80104740:	e8 bb d2 ff ff       	call   80101a00 <namecmp>
80104745:	83 c4 10             	add    $0x10,%esp
80104748:	85 c0                	test   %eax,%eax
8010474a:	0f 84 fc 00 00 00    	je     8010484c <sys_unlink+0x165>
80104750:	83 ec 08             	sub    $0x8,%esp
80104753:	68 bd 6d 10 80       	push   $0x80106dbd
80104758:	8d 45 ca             	lea    -0x36(%ebp),%eax
8010475b:	50                   	push   %eax
8010475c:	e8 9f d2 ff ff       	call   80101a00 <namecmp>
80104761:	83 c4 10             	add    $0x10,%esp
80104764:	85 c0                	test   %eax,%eax
80104766:	0f 84 e0 00 00 00    	je     8010484c <sys_unlink+0x165>
  if ((ip = dirlookup(dp, name, &off)) == 0)
8010476c:	83 ec 04             	sub    $0x4,%esp
8010476f:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104772:	50                   	push   %eax
80104773:	8d 45 ca             	lea    -0x36(%ebp),%eax
80104776:	50                   	push   %eax
80104777:	56                   	push   %esi
80104778:	e8 9c d2 ff ff       	call   80101a19 <dirlookup>
8010477d:	89 c3                	mov    %eax,%ebx
8010477f:	83 c4 10             	add    $0x10,%esp
80104782:	85 c0                	test   %eax,%eax
80104784:	0f 84 c2 00 00 00    	je     8010484c <sys_unlink+0x165>
  ilock(ip);
8010478a:	83 ec 0c             	sub    $0xc,%esp
8010478d:	50                   	push   %eax
8010478e:	e8 37 ce ff ff       	call   801015ca <ilock>
  if (ip->nlink < 1)
80104793:	83 c4 10             	add    $0x10,%esp
80104796:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010479b:	0f 8e 83 00 00 00    	jle    80104824 <sys_unlink+0x13d>
  if (ip->type == T_DIR && !isdirempty(ip))
801047a1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047a6:	0f 84 85 00 00 00    	je     80104831 <sys_unlink+0x14a>
  memset(&de, 0, sizeof(de));
801047ac:	83 ec 04             	sub    $0x4,%esp
801047af:	6a 10                	push   $0x10
801047b1:	6a 00                	push   $0x0
801047b3:	8d 7d d8             	lea    -0x28(%ebp),%edi
801047b6:	57                   	push   %edi
801047b7:	e8 c7 f5 ff ff       	call   80103d83 <memset>
  if (writei(dp, (char *)&de, off, sizeof(de)) != sizeof(de))
801047bc:	6a 10                	push   $0x10
801047be:	ff 75 c0             	pushl  -0x40(%ebp)
801047c1:	57                   	push   %edi
801047c2:	56                   	push   %esi
801047c3:	e8 09 d1 ff ff       	call   801018d1 <writei>
801047c8:	83 c4 20             	add    $0x20,%esp
801047cb:	83 f8 10             	cmp    $0x10,%eax
801047ce:	0f 85 90 00 00 00    	jne    80104864 <sys_unlink+0x17d>
  if (ip->type == T_DIR)
801047d4:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801047d9:	0f 84 92 00 00 00    	je     80104871 <sys_unlink+0x18a>
  iunlockput(dp);
801047df:	83 ec 0c             	sub    $0xc,%esp
801047e2:	56                   	push   %esi
801047e3:	e8 95 cf ff ff       	call   8010177d <iunlockput>
  ip->nlink--;
801047e8:	0f b7 43 56          	movzwl 0x56(%ebx),%eax
801047ec:	83 e8 01             	sub    $0x1,%eax
801047ef:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
801047f3:	89 1c 24             	mov    %ebx,(%esp)
801047f6:	e8 66 cc ff ff       	call   80101461 <iupdate>
  iunlockput(ip);
801047fb:	89 1c 24             	mov    %ebx,(%esp)
801047fe:	e8 7a cf ff ff       	call   8010177d <iunlockput>
  end_op();
80104803:	e8 c5 e0 ff ff       	call   801028cd <end_op>
  return 0;
80104808:	83 c4 10             	add    $0x10,%esp
8010480b:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104810:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104813:	5b                   	pop    %ebx
80104814:	5e                   	pop    %esi
80104815:	5f                   	pop    %edi
80104816:	5d                   	pop    %ebp
80104817:	c3                   	ret    
    end_op();
80104818:	e8 b0 e0 ff ff       	call   801028cd <end_op>
    return -1;
8010481d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104822:	eb ec                	jmp    80104810 <sys_unlink+0x129>
    panic("unlink: nlink < 1");
80104824:	83 ec 0c             	sub    $0xc,%esp
80104827:	68 dc 6d 10 80       	push   $0x80106ddc
8010482c:	e8 2b bb ff ff       	call   8010035c <panic>
  if (ip->type == T_DIR && !isdirempty(ip))
80104831:	89 d8                	mov    %ebx,%eax
80104833:	e8 82 f9 ff ff       	call   801041ba <isdirempty>
80104838:	85 c0                	test   %eax,%eax
8010483a:	0f 85 6c ff ff ff    	jne    801047ac <sys_unlink+0xc5>
    iunlockput(ip);
80104840:	83 ec 0c             	sub    $0xc,%esp
80104843:	53                   	push   %ebx
80104844:	e8 34 cf ff ff       	call   8010177d <iunlockput>
    goto bad;
80104849:	83 c4 10             	add    $0x10,%esp
  iunlockput(dp);
8010484c:	83 ec 0c             	sub    $0xc,%esp
8010484f:	56                   	push   %esi
80104850:	e8 28 cf ff ff       	call   8010177d <iunlockput>
  end_op();
80104855:	e8 73 e0 ff ff       	call   801028cd <end_op>
  return -1;
8010485a:	83 c4 10             	add    $0x10,%esp
8010485d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104862:	eb ac                	jmp    80104810 <sys_unlink+0x129>
    panic("unlink: writei");
80104864:	83 ec 0c             	sub    $0xc,%esp
80104867:	68 ee 6d 10 80       	push   $0x80106dee
8010486c:	e8 eb ba ff ff       	call   8010035c <panic>
    dp->nlink--;
80104871:	0f b7 46 56          	movzwl 0x56(%esi),%eax
80104875:	83 e8 01             	sub    $0x1,%eax
80104878:	66 89 46 56          	mov    %ax,0x56(%esi)
    iupdate(dp);
8010487c:	83 ec 0c             	sub    $0xc,%esp
8010487f:	56                   	push   %esi
80104880:	e8 dc cb ff ff       	call   80101461 <iupdate>
80104885:	83 c4 10             	add    $0x10,%esp
80104888:	e9 52 ff ff ff       	jmp    801047df <sys_unlink+0xf8>
    return -1;
8010488d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104892:	e9 79 ff ff ff       	jmp    80104810 <sys_unlink+0x129>

80104897 <sys_open>:

int sys_open(void)
{
80104897:	f3 0f 1e fb          	endbr32 
8010489b:	55                   	push   %ebp
8010489c:	89 e5                	mov    %esp,%ebp
8010489e:	57                   	push   %edi
8010489f:	56                   	push   %esi
801048a0:	53                   	push   %ebx
801048a1:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if (argstr(0, &path) < 0 || argint(1, &omode) < 0)
801048a4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801048a7:	50                   	push   %eax
801048a8:	6a 00                	push   $0x0
801048aa:	e8 e2 f7 ff ff       	call   80104091 <argstr>
801048af:	83 c4 10             	add    $0x10,%esp
801048b2:	85 c0                	test   %eax,%eax
801048b4:	0f 88 a0 00 00 00    	js     8010495a <sys_open+0xc3>
801048ba:	83 ec 08             	sub    $0x8,%esp
801048bd:	8d 45 e0             	lea    -0x20(%ebp),%eax
801048c0:	50                   	push   %eax
801048c1:	6a 01                	push   $0x1
801048c3:	e8 31 f7 ff ff       	call   80103ff9 <argint>
801048c8:	83 c4 10             	add    $0x10,%esp
801048cb:	85 c0                	test   %eax,%eax
801048cd:	0f 88 87 00 00 00    	js     8010495a <sys_open+0xc3>
    return -1;

  begin_op();
801048d3:	e8 77 df ff ff       	call   8010284f <begin_op>

  if (omode & O_CREATE)
801048d8:	f6 45 e1 02          	testb  $0x2,-0x1f(%ebp)
801048dc:	0f 84 8b 00 00 00    	je     8010496d <sys_open+0xd6>
  {
    ip = create(path, T_FILE, 0, 0);
801048e2:	83 ec 0c             	sub    $0xc,%esp
801048e5:	6a 00                	push   $0x0
801048e7:	b9 00 00 00 00       	mov    $0x0,%ecx
801048ec:	ba 02 00 00 00       	mov    $0x2,%edx
801048f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801048f4:	e8 18 f9 ff ff       	call   80104211 <create>
801048f9:	89 c6                	mov    %eax,%esi
    if (ip == 0)
801048fb:	83 c4 10             	add    $0x10,%esp
801048fe:	85 c0                	test   %eax,%eax
80104900:	74 5f                	je     80104961 <sys_open+0xca>
      end_op();
      return -1;
    }
  }

  if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
80104902:	e8 50 c3 ff ff       	call   80100c57 <filealloc>
80104907:	89 c3                	mov    %eax,%ebx
80104909:	85 c0                	test   %eax,%eax
8010490b:	0f 84 b5 00 00 00    	je     801049c6 <sys_open+0x12f>
80104911:	e8 6d f8 ff ff       	call   80104183 <fdalloc>
80104916:	89 c7                	mov    %eax,%edi
80104918:	85 c0                	test   %eax,%eax
8010491a:	0f 88 a6 00 00 00    	js     801049c6 <sys_open+0x12f>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104920:	83 ec 0c             	sub    $0xc,%esp
80104923:	56                   	push   %esi
80104924:	e8 67 cd ff ff       	call   80101690 <iunlock>
  end_op();
80104929:	e8 9f df ff ff       	call   801028cd <end_op>

  f->type = FD_INODE;
8010492e:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
80104934:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104937:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
8010493e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104941:	83 c4 10             	add    $0x10,%esp
80104944:	a8 01                	test   $0x1,%al
80104946:	0f 94 43 08          	sete   0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010494a:	a8 03                	test   $0x3,%al
8010494c:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104950:	89 f8                	mov    %edi,%eax
80104952:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104955:	5b                   	pop    %ebx
80104956:	5e                   	pop    %esi
80104957:	5f                   	pop    %edi
80104958:	5d                   	pop    %ebp
80104959:	c3                   	ret    
    return -1;
8010495a:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010495f:	eb ef                	jmp    80104950 <sys_open+0xb9>
      end_op();
80104961:	e8 67 df ff ff       	call   801028cd <end_op>
      return -1;
80104966:	bf ff ff ff ff       	mov    $0xffffffff,%edi
8010496b:	eb e3                	jmp    80104950 <sys_open+0xb9>
    if ((ip = namei(path)) == 0)
8010496d:	83 ec 0c             	sub    $0xc,%esp
80104970:	ff 75 e4             	pushl  -0x1c(%ebp)
80104973:	e8 d7 d2 ff ff       	call   80101c4f <namei>
80104978:	89 c6                	mov    %eax,%esi
8010497a:	83 c4 10             	add    $0x10,%esp
8010497d:	85 c0                	test   %eax,%eax
8010497f:	74 39                	je     801049ba <sys_open+0x123>
    ilock(ip);
80104981:	83 ec 0c             	sub    $0xc,%esp
80104984:	50                   	push   %eax
80104985:	e8 40 cc ff ff       	call   801015ca <ilock>
    if (ip->type == T_DIR && omode != O_RDONLY)
8010498a:	83 c4 10             	add    $0x10,%esp
8010498d:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104992:	0f 85 6a ff ff ff    	jne    80104902 <sys_open+0x6b>
80104998:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
8010499c:	0f 84 60 ff ff ff    	je     80104902 <sys_open+0x6b>
      iunlockput(ip);
801049a2:	83 ec 0c             	sub    $0xc,%esp
801049a5:	56                   	push   %esi
801049a6:	e8 d2 cd ff ff       	call   8010177d <iunlockput>
      end_op();
801049ab:	e8 1d df ff ff       	call   801028cd <end_op>
      return -1;
801049b0:	83 c4 10             	add    $0x10,%esp
801049b3:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049b8:	eb 96                	jmp    80104950 <sys_open+0xb9>
      end_op();
801049ba:	e8 0e df ff ff       	call   801028cd <end_op>
      return -1;
801049bf:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049c4:	eb 8a                	jmp    80104950 <sys_open+0xb9>
    if (f)
801049c6:	85 db                	test   %ebx,%ebx
801049c8:	74 0c                	je     801049d6 <sys_open+0x13f>
      fileclose(f);
801049ca:	83 ec 0c             	sub    $0xc,%esp
801049cd:	53                   	push   %ebx
801049ce:	e8 32 c3 ff ff       	call   80100d05 <fileclose>
801049d3:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801049d6:	83 ec 0c             	sub    $0xc,%esp
801049d9:	56                   	push   %esi
801049da:	e8 9e cd ff ff       	call   8010177d <iunlockput>
    end_op();
801049df:	e8 e9 de ff ff       	call   801028cd <end_op>
    return -1;
801049e4:	83 c4 10             	add    $0x10,%esp
801049e7:	bf ff ff ff ff       	mov    $0xffffffff,%edi
801049ec:	e9 5f ff ff ff       	jmp    80104950 <sys_open+0xb9>

801049f1 <sys_mkdir>:

int sys_mkdir(void)
{
801049f1:	f3 0f 1e fb          	endbr32 
801049f5:	55                   	push   %ebp
801049f6:	89 e5                	mov    %esp,%ebp
801049f8:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
801049fb:	e8 4f de ff ff       	call   8010284f <begin_op>
  if (argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
80104a00:	83 ec 08             	sub    $0x8,%esp
80104a03:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a06:	50                   	push   %eax
80104a07:	6a 00                	push   $0x0
80104a09:	e8 83 f6 ff ff       	call   80104091 <argstr>
80104a0e:	83 c4 10             	add    $0x10,%esp
80104a11:	85 c0                	test   %eax,%eax
80104a13:	78 36                	js     80104a4b <sys_mkdir+0x5a>
80104a15:	83 ec 0c             	sub    $0xc,%esp
80104a18:	6a 00                	push   $0x0
80104a1a:	b9 00 00 00 00       	mov    $0x0,%ecx
80104a1f:	ba 01 00 00 00       	mov    $0x1,%edx
80104a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a27:	e8 e5 f7 ff ff       	call   80104211 <create>
80104a2c:	83 c4 10             	add    $0x10,%esp
80104a2f:	85 c0                	test   %eax,%eax
80104a31:	74 18                	je     80104a4b <sys_mkdir+0x5a>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104a33:	83 ec 0c             	sub    $0xc,%esp
80104a36:	50                   	push   %eax
80104a37:	e8 41 cd ff ff       	call   8010177d <iunlockput>
  end_op();
80104a3c:	e8 8c de ff ff       	call   801028cd <end_op>
  return 0;
80104a41:	83 c4 10             	add    $0x10,%esp
80104a44:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104a49:	c9                   	leave  
80104a4a:	c3                   	ret    
    end_op();
80104a4b:	e8 7d de ff ff       	call   801028cd <end_op>
    return -1;
80104a50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104a55:	eb f2                	jmp    80104a49 <sys_mkdir+0x58>

80104a57 <sys_mknod>:

int sys_mknod(void)
{
80104a57:	f3 0f 1e fb          	endbr32 
80104a5b:	55                   	push   %ebp
80104a5c:	89 e5                	mov    %esp,%ebp
80104a5e:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104a61:	e8 e9 dd ff ff       	call   8010284f <begin_op>
  if ((argstr(0, &path)) < 0 ||
80104a66:	83 ec 08             	sub    $0x8,%esp
80104a69:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a6c:	50                   	push   %eax
80104a6d:	6a 00                	push   $0x0
80104a6f:	e8 1d f6 ff ff       	call   80104091 <argstr>
80104a74:	83 c4 10             	add    $0x10,%esp
80104a77:	85 c0                	test   %eax,%eax
80104a79:	78 62                	js     80104add <sys_mknod+0x86>
      argint(1, &major) < 0 ||
80104a7b:	83 ec 08             	sub    $0x8,%esp
80104a7e:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a81:	50                   	push   %eax
80104a82:	6a 01                	push   $0x1
80104a84:	e8 70 f5 ff ff       	call   80103ff9 <argint>
  if ((argstr(0, &path)) < 0 ||
80104a89:	83 c4 10             	add    $0x10,%esp
80104a8c:	85 c0                	test   %eax,%eax
80104a8e:	78 4d                	js     80104add <sys_mknod+0x86>
      argint(2, &minor) < 0 ||
80104a90:	83 ec 08             	sub    $0x8,%esp
80104a93:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104a96:	50                   	push   %eax
80104a97:	6a 02                	push   $0x2
80104a99:	e8 5b f5 ff ff       	call   80103ff9 <argint>
      argint(1, &major) < 0 ||
80104a9e:	83 c4 10             	add    $0x10,%esp
80104aa1:	85 c0                	test   %eax,%eax
80104aa3:	78 38                	js     80104add <sys_mknod+0x86>
      (ip = create(path, T_DEV, major, minor)) == 0)
80104aa5:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80104aa9:	83 ec 0c             	sub    $0xc,%esp
80104aac:	0f bf 45 ec          	movswl -0x14(%ebp),%eax
80104ab0:	50                   	push   %eax
80104ab1:	ba 03 00 00 00       	mov    $0x3,%edx
80104ab6:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ab9:	e8 53 f7 ff ff       	call   80104211 <create>
      argint(2, &minor) < 0 ||
80104abe:	83 c4 10             	add    $0x10,%esp
80104ac1:	85 c0                	test   %eax,%eax
80104ac3:	74 18                	je     80104add <sys_mknod+0x86>
  {
    end_op();
    return -1;
  }
  iunlockput(ip);
80104ac5:	83 ec 0c             	sub    $0xc,%esp
80104ac8:	50                   	push   %eax
80104ac9:	e8 af cc ff ff       	call   8010177d <iunlockput>
  end_op();
80104ace:	e8 fa dd ff ff       	call   801028cd <end_op>
  return 0;
80104ad3:	83 c4 10             	add    $0x10,%esp
80104ad6:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104adb:	c9                   	leave  
80104adc:	c3                   	ret    
    end_op();
80104add:	e8 eb dd ff ff       	call   801028cd <end_op>
    return -1;
80104ae2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104ae7:	eb f2                	jmp    80104adb <sys_mknod+0x84>

80104ae9 <sys_chdir>:

int sys_chdir(void)
{
80104ae9:	f3 0f 1e fb          	endbr32 
80104aed:	55                   	push   %ebp
80104aee:	89 e5                	mov    %esp,%ebp
80104af0:	56                   	push   %esi
80104af1:	53                   	push   %ebx
80104af2:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80104af5:	e8 d1 e7 ff ff       	call   801032cb <myproc>
80104afa:	89 c6                	mov    %eax,%esi

  begin_op();
80104afc:	e8 4e dd ff ff       	call   8010284f <begin_op>
  if (argstr(0, &path) < 0 || (ip = namei(path)) == 0)
80104b01:	83 ec 08             	sub    $0x8,%esp
80104b04:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b07:	50                   	push   %eax
80104b08:	6a 00                	push   $0x0
80104b0a:	e8 82 f5 ff ff       	call   80104091 <argstr>
80104b0f:	83 c4 10             	add    $0x10,%esp
80104b12:	85 c0                	test   %eax,%eax
80104b14:	78 52                	js     80104b68 <sys_chdir+0x7f>
80104b16:	83 ec 0c             	sub    $0xc,%esp
80104b19:	ff 75 f4             	pushl  -0xc(%ebp)
80104b1c:	e8 2e d1 ff ff       	call   80101c4f <namei>
80104b21:	89 c3                	mov    %eax,%ebx
80104b23:	83 c4 10             	add    $0x10,%esp
80104b26:	85 c0                	test   %eax,%eax
80104b28:	74 3e                	je     80104b68 <sys_chdir+0x7f>
  {
    end_op();
    return -1;
  }
  ilock(ip);
80104b2a:	83 ec 0c             	sub    $0xc,%esp
80104b2d:	50                   	push   %eax
80104b2e:	e8 97 ca ff ff       	call   801015ca <ilock>
  if (ip->type != T_DIR)
80104b33:	83 c4 10             	add    $0x10,%esp
80104b36:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b3b:	75 37                	jne    80104b74 <sys_chdir+0x8b>
  {
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104b3d:	83 ec 0c             	sub    $0xc,%esp
80104b40:	53                   	push   %ebx
80104b41:	e8 4a cb ff ff       	call   80101690 <iunlock>
  iput(curproc->cwd);
80104b46:	83 c4 04             	add    $0x4,%esp
80104b49:	ff 76 68             	pushl  0x68(%esi)
80104b4c:	e8 88 cb ff ff       	call   801016d9 <iput>
  end_op();
80104b51:	e8 77 dd ff ff       	call   801028cd <end_op>
  curproc->cwd = ip;
80104b56:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
80104b59:	83 c4 10             	add    $0x10,%esp
80104b5c:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104b61:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104b64:	5b                   	pop    %ebx
80104b65:	5e                   	pop    %esi
80104b66:	5d                   	pop    %ebp
80104b67:	c3                   	ret    
    end_op();
80104b68:	e8 60 dd ff ff       	call   801028cd <end_op>
    return -1;
80104b6d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b72:	eb ed                	jmp    80104b61 <sys_chdir+0x78>
    iunlockput(ip);
80104b74:	83 ec 0c             	sub    $0xc,%esp
80104b77:	53                   	push   %ebx
80104b78:	e8 00 cc ff ff       	call   8010177d <iunlockput>
    end_op();
80104b7d:	e8 4b dd ff ff       	call   801028cd <end_op>
    return -1;
80104b82:	83 c4 10             	add    $0x10,%esp
80104b85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104b8a:	eb d5                	jmp    80104b61 <sys_chdir+0x78>

80104b8c <sys_exec>:

int sys_exec(void)
{
80104b8c:	f3 0f 1e fb          	endbr32 
80104b90:	55                   	push   %ebp
80104b91:	89 e5                	mov    %esp,%ebp
80104b93:	53                   	push   %ebx
80104b94:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if (argstr(0, &path) < 0 || argint(1, (int *)&uargv) < 0)
80104b9a:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b9d:	50                   	push   %eax
80104b9e:	6a 00                	push   $0x0
80104ba0:	e8 ec f4 ff ff       	call   80104091 <argstr>
80104ba5:	83 c4 10             	add    $0x10,%esp
80104ba8:	85 c0                	test   %eax,%eax
80104baa:	78 38                	js     80104be4 <sys_exec+0x58>
80104bac:	83 ec 08             	sub    $0x8,%esp
80104baf:	8d 85 70 ff ff ff    	lea    -0x90(%ebp),%eax
80104bb5:	50                   	push   %eax
80104bb6:	6a 01                	push   $0x1
80104bb8:	e8 3c f4 ff ff       	call   80103ff9 <argint>
80104bbd:	83 c4 10             	add    $0x10,%esp
80104bc0:	85 c0                	test   %eax,%eax
80104bc2:	78 20                	js     80104be4 <sys_exec+0x58>
  {
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80104bc4:	83 ec 04             	sub    $0x4,%esp
80104bc7:	68 80 00 00 00       	push   $0x80
80104bcc:	6a 00                	push   $0x0
80104bce:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bd4:	50                   	push   %eax
80104bd5:	e8 a9 f1 ff ff       	call   80103d83 <memset>
80104bda:	83 c4 10             	add    $0x10,%esp
  for (i = 0;; i++)
80104bdd:	bb 00 00 00 00       	mov    $0x0,%ebx
80104be2:	eb 2c                	jmp    80104c10 <sys_exec+0x84>
    return -1;
80104be4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104be9:	eb 78                	jmp    80104c63 <sys_exec+0xd7>
      return -1;
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
      return -1;
    if (uarg == 0)
    {
      argv[i] = 0;
80104beb:	c7 84 9d 74 ff ff ff 	movl   $0x0,-0x8c(%ebp,%ebx,4)
80104bf2:	00 00 00 00 
      break;
    }
    if (fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80104bf6:	83 ec 08             	sub    $0x8,%esp
80104bf9:	8d 85 74 ff ff ff    	lea    -0x8c(%ebp),%eax
80104bff:	50                   	push   %eax
80104c00:	ff 75 f4             	pushl  -0xc(%ebp)
80104c03:	e8 f4 bc ff ff       	call   801008fc <exec>
80104c08:	83 c4 10             	add    $0x10,%esp
80104c0b:	eb 56                	jmp    80104c63 <sys_exec+0xd7>
  for (i = 0;; i++)
80104c0d:	83 c3 01             	add    $0x1,%ebx
    if (i >= NELEM(argv))
80104c10:	83 fb 1f             	cmp    $0x1f,%ebx
80104c13:	77 49                	ja     80104c5e <sys_exec+0xd2>
    if (fetchint(uargv + 4 * i, (int *)&uarg) < 0)
80104c15:	83 ec 08             	sub    $0x8,%esp
80104c18:	8d 85 6c ff ff ff    	lea    -0x94(%ebp),%eax
80104c1e:	50                   	push   %eax
80104c1f:	8b 85 70 ff ff ff    	mov    -0x90(%ebp),%eax
80104c25:	8d 04 98             	lea    (%eax,%ebx,4),%eax
80104c28:	50                   	push   %eax
80104c29:	e8 47 f3 ff ff       	call   80103f75 <fetchint>
80104c2e:	83 c4 10             	add    $0x10,%esp
80104c31:	85 c0                	test   %eax,%eax
80104c33:	78 33                	js     80104c68 <sys_exec+0xdc>
    if (uarg == 0)
80104c35:	8b 85 6c ff ff ff    	mov    -0x94(%ebp),%eax
80104c3b:	85 c0                	test   %eax,%eax
80104c3d:	74 ac                	je     80104beb <sys_exec+0x5f>
    if (fetchstr(uarg, &argv[i]) < 0)
80104c3f:	83 ec 08             	sub    $0x8,%esp
80104c42:	8d 94 9d 74 ff ff ff 	lea    -0x8c(%ebp,%ebx,4),%edx
80104c49:	52                   	push   %edx
80104c4a:	50                   	push   %eax
80104c4b:	e8 65 f3 ff ff       	call   80103fb5 <fetchstr>
80104c50:	83 c4 10             	add    $0x10,%esp
80104c53:	85 c0                	test   %eax,%eax
80104c55:	79 b6                	jns    80104c0d <sys_exec+0x81>
      return -1;
80104c57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c5c:	eb 05                	jmp    80104c63 <sys_exec+0xd7>
      return -1;
80104c5e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c66:	c9                   	leave  
80104c67:	c3                   	ret    
      return -1;
80104c68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c6d:	eb f4                	jmp    80104c63 <sys_exec+0xd7>

80104c6f <sys_pipe>:

int sys_pipe(void)
{
80104c6f:	f3 0f 1e fb          	endbr32 
80104c73:	55                   	push   %ebp
80104c74:	89 e5                	mov    %esp,%ebp
80104c76:	53                   	push   %ebx
80104c77:	83 ec 18             	sub    $0x18,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if (argptr(0, (void *)&fd, 2 * sizeof(fd[0])) < 0)
80104c7a:	6a 08                	push   $0x8
80104c7c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c7f:	50                   	push   %eax
80104c80:	6a 00                	push   $0x0
80104c82:	e8 9e f3 ff ff       	call   80104025 <argptr>
80104c87:	83 c4 10             	add    $0x10,%esp
80104c8a:	85 c0                	test   %eax,%eax
80104c8c:	78 79                	js     80104d07 <sys_pipe+0x98>
    return -1;
  if (pipealloc(&rf, &wf) < 0)
80104c8e:	83 ec 08             	sub    $0x8,%esp
80104c91:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104c94:	50                   	push   %eax
80104c95:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c98:	50                   	push   %eax
80104c99:	e8 56 e1 ff ff       	call   80102df4 <pipealloc>
80104c9e:	83 c4 10             	add    $0x10,%esp
80104ca1:	85 c0                	test   %eax,%eax
80104ca3:	78 69                	js     80104d0e <sys_pipe+0x9f>
    return -1;
  fd0 = -1;
  if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
80104ca5:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104ca8:	e8 d6 f4 ff ff       	call   80104183 <fdalloc>
80104cad:	89 c3                	mov    %eax,%ebx
80104caf:	85 c0                	test   %eax,%eax
80104cb1:	78 21                	js     80104cd4 <sys_pipe+0x65>
80104cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104cb6:	e8 c8 f4 ff ff       	call   80104183 <fdalloc>
80104cbb:	85 c0                	test   %eax,%eax
80104cbd:	78 15                	js     80104cd4 <sys_pipe+0x65>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80104cbf:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cc2:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
80104cc4:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104cc7:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
80104cca:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ccf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104cd2:	c9                   	leave  
80104cd3:	c3                   	ret    
    if (fd0 >= 0)
80104cd4:	85 db                	test   %ebx,%ebx
80104cd6:	79 20                	jns    80104cf8 <sys_pipe+0x89>
    fileclose(rf);
80104cd8:	83 ec 0c             	sub    $0xc,%esp
80104cdb:	ff 75 f0             	pushl  -0x10(%ebp)
80104cde:	e8 22 c0 ff ff       	call   80100d05 <fileclose>
    fileclose(wf);
80104ce3:	83 c4 04             	add    $0x4,%esp
80104ce6:	ff 75 ec             	pushl  -0x14(%ebp)
80104ce9:	e8 17 c0 ff ff       	call   80100d05 <fileclose>
    return -1;
80104cee:	83 c4 10             	add    $0x10,%esp
80104cf1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104cf6:	eb d7                	jmp    80104ccf <sys_pipe+0x60>
      myproc()->ofile[fd0] = 0;
80104cf8:	e8 ce e5 ff ff       	call   801032cb <myproc>
80104cfd:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
80104d04:	00 
80104d05:	eb d1                	jmp    80104cd8 <sys_pipe+0x69>
    return -1;
80104d07:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d0c:	eb c1                	jmp    80104ccf <sys_pipe+0x60>
    return -1;
80104d0e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d13:	eb ba                	jmp    80104ccf <sys_pipe+0x60>

80104d15 <sys_fork>:
#include "memlayout.h"
#include "mmu.h"
#include "proc.h"

int sys_fork(void)
{
80104d15:	f3 0f 1e fb          	endbr32 
80104d19:	55                   	push   %ebp
80104d1a:	89 e5                	mov    %esp,%ebp
80104d1c:	83 ec 08             	sub    $0x8,%esp
  return fork();
80104d1f:	e8 2a e7 ff ff       	call   8010344e <fork>
}
80104d24:	c9                   	leave  
80104d25:	c3                   	ret    

80104d26 <sys_exit>:

int sys_exit(void)
{
80104d26:	f3 0f 1e fb          	endbr32 
80104d2a:	55                   	push   %ebp
80104d2b:	89 e5                	mov    %esp,%ebp
80104d2d:	83 ec 08             	sub    $0x8,%esp
  exit();
80104d30:	e8 5c e9 ff ff       	call   80103691 <exit>
  return 0; // not reached
}
80104d35:	b8 00 00 00 00       	mov    $0x0,%eax
80104d3a:	c9                   	leave  
80104d3b:	c3                   	ret    

80104d3c <sys_wait>:

int sys_wait(void)
{
80104d3c:	f3 0f 1e fb          	endbr32 
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	83 ec 08             	sub    $0x8,%esp
  return wait();
80104d46:	e8 de ea ff ff       	call   80103829 <wait>
}
80104d4b:	c9                   	leave  
80104d4c:	c3                   	ret    

80104d4d <sys_kill>:

int sys_kill(void)
{
80104d4d:	f3 0f 1e fb          	endbr32 
80104d51:	55                   	push   %ebp
80104d52:	89 e5                	mov    %esp,%ebp
80104d54:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if (argint(0, &pid) < 0)
80104d57:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104d5a:	50                   	push   %eax
80104d5b:	6a 00                	push   $0x0
80104d5d:	e8 97 f2 ff ff       	call   80103ff9 <argint>
80104d62:	83 c4 10             	add    $0x10,%esp
80104d65:	85 c0                	test   %eax,%eax
80104d67:	78 10                	js     80104d79 <sys_kill+0x2c>
    return -1;
  return kill(pid);
80104d69:	83 ec 0c             	sub    $0xc,%esp
80104d6c:	ff 75 f4             	pushl  -0xc(%ebp)
80104d6f:	e8 bd eb ff ff       	call   80103931 <kill>
80104d74:	83 c4 10             	add    $0x10,%esp
}
80104d77:	c9                   	leave  
80104d78:	c3                   	ret    
    return -1;
80104d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d7e:	eb f7                	jmp    80104d77 <sys_kill+0x2a>

80104d80 <sys_getpid>:

int sys_getpid(void)
{
80104d80:	f3 0f 1e fb          	endbr32 
80104d84:	55                   	push   %ebp
80104d85:	89 e5                	mov    %esp,%ebp
80104d87:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80104d8a:	e8 3c e5 ff ff       	call   801032cb <myproc>
80104d8f:	8b 40 10             	mov    0x10(%eax),%eax
}
80104d92:	c9                   	leave  
80104d93:	c3                   	ret    

80104d94 <sys_getiocounts>:
  int readcount;  // total number of times read() is invoked by the current running process (including failed calls)
  int writecount; // total number of times write() is invoked by the current running process (including failed calls)
};

int sys_getiocounts(void)
{
80104d94:	f3 0f 1e fb          	endbr32 
80104d98:	55                   	push   %ebp
80104d99:	89 e5                	mov    %esp,%ebp
80104d9b:	83 ec 1c             	sub    $0x1c,%esp
  struct iostat *i;

  if (argptr(0, (void *)&i, sizeof(i)) < 0)
80104d9e:	6a 04                	push   $0x4
80104da0:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104da3:	50                   	push   %eax
80104da4:	6a 00                	push   $0x0
80104da6:	e8 7a f2 ff ff       	call   80104025 <argptr>
80104dab:	83 c4 10             	add    $0x10,%esp
80104dae:	85 c0                	test   %eax,%eax
80104db0:	78 15                	js     80104dc7 <sys_getiocounts+0x33>
  {
    return -1;
  }
  else
  {
    getiocounts(i);
80104db2:	83 ec 0c             	sub    $0xc,%esp
80104db5:	ff 75 f4             	pushl  -0xc(%ebp)
80104db8:	e8 9a f7 ff ff       	call   80104557 <getiocounts>
    return 0;
80104dbd:	83 c4 10             	add    $0x10,%esp
80104dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  }
}
80104dc5:	c9                   	leave  
80104dc6:	c3                   	ret    
    return -1;
80104dc7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104dcc:	eb f7                	jmp    80104dc5 <sys_getiocounts+0x31>

80104dce <sys_sbrk>:

int sys_sbrk(void)
{
80104dce:	f3 0f 1e fb          	endbr32 
80104dd2:	55                   	push   %ebp
80104dd3:	89 e5                	mov    %esp,%ebp
80104dd5:	53                   	push   %ebx
80104dd6:	83 ec 1c             	sub    $0x1c,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
80104dd9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ddc:	50                   	push   %eax
80104ddd:	6a 00                	push   $0x0
80104ddf:	e8 15 f2 ff ff       	call   80103ff9 <argint>
80104de4:	83 c4 10             	add    $0x10,%esp
80104de7:	85 c0                	test   %eax,%eax
80104de9:	78 20                	js     80104e0b <sys_sbrk+0x3d>
    return -1;
  addr = myproc()->sz;
80104deb:	e8 db e4 ff ff       	call   801032cb <myproc>
80104df0:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80104df2:	83 ec 0c             	sub    $0xc,%esp
80104df5:	ff 75 f4             	pushl  -0xc(%ebp)
80104df8:	e8 e2 e5 ff ff       	call   801033df <growproc>
80104dfd:	83 c4 10             	add    $0x10,%esp
80104e00:	85 c0                	test   %eax,%eax
80104e02:	78 0e                	js     80104e12 <sys_sbrk+0x44>
    return -1;
  return addr;
}
80104e04:	89 d8                	mov    %ebx,%eax
80104e06:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e09:	c9                   	leave  
80104e0a:	c3                   	ret    
    return -1;
80104e0b:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e10:	eb f2                	jmp    80104e04 <sys_sbrk+0x36>
    return -1;
80104e12:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80104e17:	eb eb                	jmp    80104e04 <sys_sbrk+0x36>

80104e19 <sys_sleep>:

int sys_sleep(void)
{
80104e19:	f3 0f 1e fb          	endbr32 
80104e1d:	55                   	push   %ebp
80104e1e:	89 e5                	mov    %esp,%ebp
80104e20:	53                   	push   %ebx
80104e21:	83 ec 1c             	sub    $0x1c,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80104e24:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104e27:	50                   	push   %eax
80104e28:	6a 00                	push   $0x0
80104e2a:	e8 ca f1 ff ff       	call   80103ff9 <argint>
80104e2f:	83 c4 10             	add    $0x10,%esp
80104e32:	85 c0                	test   %eax,%eax
80104e34:	78 75                	js     80104eab <sys_sleep+0x92>
    return -1;
  acquire(&tickslock);
80104e36:	83 ec 0c             	sub    $0xc,%esp
80104e39:	68 60 4e 11 80       	push   $0x80114e60
80104e3e:	e8 8c ee ff ff       	call   80103ccf <acquire>
  ticks0 = ticks;
80104e43:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  while (ticks - ticks0 < n)
80104e49:	83 c4 10             	add    $0x10,%esp
80104e4c:	a1 a0 56 11 80       	mov    0x801156a0,%eax
80104e51:	29 d8                	sub    %ebx,%eax
80104e53:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80104e56:	73 39                	jae    80104e91 <sys_sleep+0x78>
  {
    if (myproc()->killed)
80104e58:	e8 6e e4 ff ff       	call   801032cb <myproc>
80104e5d:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80104e61:	75 17                	jne    80104e7a <sys_sleep+0x61>
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80104e63:	83 ec 08             	sub    $0x8,%esp
80104e66:	68 60 4e 11 80       	push   $0x80114e60
80104e6b:	68 a0 56 11 80       	push   $0x801156a0
80104e70:	e8 1f e9 ff ff       	call   80103794 <sleep>
80104e75:	83 c4 10             	add    $0x10,%esp
80104e78:	eb d2                	jmp    80104e4c <sys_sleep+0x33>
      release(&tickslock);
80104e7a:	83 ec 0c             	sub    $0xc,%esp
80104e7d:	68 60 4e 11 80       	push   $0x80114e60
80104e82:	e8 b1 ee ff ff       	call   80103d38 <release>
      return -1;
80104e87:	83 c4 10             	add    $0x10,%esp
80104e8a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e8f:	eb 15                	jmp    80104ea6 <sys_sleep+0x8d>
  }
  release(&tickslock);
80104e91:	83 ec 0c             	sub    $0xc,%esp
80104e94:	68 60 4e 11 80       	push   $0x80114e60
80104e99:	e8 9a ee ff ff       	call   80103d38 <release>
  return 0;
80104e9e:	83 c4 10             	add    $0x10,%esp
80104ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
80104ea6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ea9:	c9                   	leave  
80104eaa:	c3                   	ret    
    return -1;
80104eab:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104eb0:	eb f4                	jmp    80104ea6 <sys_sleep+0x8d>

80104eb2 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
80104eb2:	f3 0f 1e fb          	endbr32 
80104eb6:	55                   	push   %ebp
80104eb7:	89 e5                	mov    %esp,%ebp
80104eb9:	53                   	push   %ebx
80104eba:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80104ebd:	68 60 4e 11 80       	push   $0x80114e60
80104ec2:	e8 08 ee ff ff       	call   80103ccf <acquire>
  xticks = ticks;
80104ec7:	8b 1d a0 56 11 80    	mov    0x801156a0,%ebx
  release(&tickslock);
80104ecd:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
80104ed4:	e8 5f ee ff ff       	call   80103d38 <release>
  return xticks;
}
80104ed9:	89 d8                	mov    %ebx,%eax
80104edb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104ede:	c9                   	leave  
80104edf:	c3                   	ret    

80104ee0 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80104ee0:	1e                   	push   %ds
  pushl %es
80104ee1:	06                   	push   %es
  pushl %fs
80104ee2:	0f a0                	push   %fs
  pushl %gs
80104ee4:	0f a8                	push   %gs
  pushal
80104ee6:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80104ee7:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80104eeb:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80104eed:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80104eef:	54                   	push   %esp
  call trap
80104ef0:	e8 eb 00 00 00       	call   80104fe0 <trap>
  addl $4, %esp
80104ef5:	83 c4 04             	add    $0x4,%esp

80104ef8 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80104ef8:	61                   	popa   
  popl %gs
80104ef9:	0f a9                	pop    %gs
  popl %fs
80104efb:	0f a1                	pop    %fs
  popl %es
80104efd:	07                   	pop    %es
  popl %ds
80104efe:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80104eff:	83 c4 08             	add    $0x8,%esp
  iret
80104f02:	cf                   	iret   

80104f03 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80104f03:	f3 0f 1e fb          	endbr32 
80104f07:	55                   	push   %ebp
80104f08:	89 e5                	mov    %esp,%ebp
80104f0a:	83 ec 08             	sub    $0x8,%esp
  int i;

  for(i = 0; i < 256; i++)
80104f0d:	b8 00 00 00 00       	mov    $0x0,%eax
80104f12:	3d ff 00 00 00       	cmp    $0xff,%eax
80104f17:	7f 4c                	jg     80104f65 <tvinit+0x62>
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80104f19:	8b 0c 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%ecx
80104f20:	66 89 0c c5 a0 4e 11 	mov    %cx,-0x7feeb160(,%eax,8)
80104f27:	80 
80104f28:	66 c7 04 c5 a2 4e 11 	movw   $0x8,-0x7feeb15e(,%eax,8)
80104f2f:	80 08 00 
80104f32:	c6 04 c5 a4 4e 11 80 	movb   $0x0,-0x7feeb15c(,%eax,8)
80104f39:	00 
80104f3a:	0f b6 14 c5 a5 4e 11 	movzbl -0x7feeb15b(,%eax,8),%edx
80104f41:	80 
80104f42:	83 e2 f0             	and    $0xfffffff0,%edx
80104f45:	83 ca 0e             	or     $0xe,%edx
80104f48:	83 e2 8f             	and    $0xffffff8f,%edx
80104f4b:	83 ca 80             	or     $0xffffff80,%edx
80104f4e:	88 14 c5 a5 4e 11 80 	mov    %dl,-0x7feeb15b(,%eax,8)
80104f55:	c1 e9 10             	shr    $0x10,%ecx
80104f58:	66 89 0c c5 a6 4e 11 	mov    %cx,-0x7feeb15a(,%eax,8)
80104f5f:	80 
  for(i = 0; i < 256; i++)
80104f60:	83 c0 01             	add    $0x1,%eax
80104f63:	eb ad                	jmp    80104f12 <tvinit+0xf>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80104f65:	8b 15 08 a1 10 80    	mov    0x8010a108,%edx
80104f6b:	66 89 15 a0 50 11 80 	mov    %dx,0x801150a0
80104f72:	66 c7 05 a2 50 11 80 	movw   $0x8,0x801150a2
80104f79:	08 00 
80104f7b:	c6 05 a4 50 11 80 00 	movb   $0x0,0x801150a4
80104f82:	0f b6 05 a5 50 11 80 	movzbl 0x801150a5,%eax
80104f89:	83 c8 0f             	or     $0xf,%eax
80104f8c:	83 e0 ef             	and    $0xffffffef,%eax
80104f8f:	83 c8 e0             	or     $0xffffffe0,%eax
80104f92:	a2 a5 50 11 80       	mov    %al,0x801150a5
80104f97:	c1 ea 10             	shr    $0x10,%edx
80104f9a:	66 89 15 a6 50 11 80 	mov    %dx,0x801150a6

  initlock(&tickslock, "time");
80104fa1:	83 ec 08             	sub    $0x8,%esp
80104fa4:	68 fd 6d 10 80       	push   $0x80106dfd
80104fa9:	68 60 4e 11 80       	push   $0x80114e60
80104fae:	e8 cc eb ff ff       	call   80103b7f <initlock>
}
80104fb3:	83 c4 10             	add    $0x10,%esp
80104fb6:	c9                   	leave  
80104fb7:	c3                   	ret    

80104fb8 <idtinit>:

void
idtinit(void)
{
80104fb8:	f3 0f 1e fb          	endbr32 
80104fbc:	55                   	push   %ebp
80104fbd:	89 e5                	mov    %esp,%ebp
80104fbf:	83 ec 10             	sub    $0x10,%esp
  pd[0] = size-1;
80104fc2:	66 c7 45 fa ff 07    	movw   $0x7ff,-0x6(%ebp)
  pd[1] = (uint)p;
80104fc8:	b8 a0 4e 11 80       	mov    $0x80114ea0,%eax
80104fcd:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80104fd1:	c1 e8 10             	shr    $0x10,%eax
80104fd4:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80104fd8:	8d 45 fa             	lea    -0x6(%ebp),%eax
80104fdb:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80104fde:	c9                   	leave  
80104fdf:	c3                   	ret    

80104fe0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80104fe0:	f3 0f 1e fb          	endbr32 
80104fe4:	55                   	push   %ebp
80104fe5:	89 e5                	mov    %esp,%ebp
80104fe7:	57                   	push   %edi
80104fe8:	56                   	push   %esi
80104fe9:	53                   	push   %ebx
80104fea:	83 ec 1c             	sub    $0x1c,%esp
80104fed:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80104ff0:	8b 43 30             	mov    0x30(%ebx),%eax
80104ff3:	83 f8 40             	cmp    $0x40,%eax
80104ff6:	74 14                	je     8010500c <trap+0x2c>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80104ff8:	83 e8 20             	sub    $0x20,%eax
80104ffb:	83 f8 1f             	cmp    $0x1f,%eax
80104ffe:	0f 87 3b 01 00 00    	ja     8010513f <trap+0x15f>
80105004:	3e ff 24 85 a4 6e 10 	notrack jmp *-0x7fef915c(,%eax,4)
8010500b:	80 
    if(myproc()->killed)
8010500c:	e8 ba e2 ff ff       	call   801032cb <myproc>
80105011:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
80105015:	75 1f                	jne    80105036 <trap+0x56>
    myproc()->tf = tf;
80105017:	e8 af e2 ff ff       	call   801032cb <myproc>
8010501c:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
8010501f:	e8 a4 f0 ff ff       	call   801040c8 <syscall>
    if(myproc()->killed)
80105024:	e8 a2 e2 ff ff       	call   801032cb <myproc>
80105029:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010502d:	74 7e                	je     801050ad <trap+0xcd>
      exit();
8010502f:	e8 5d e6 ff ff       	call   80103691 <exit>
    return;
80105034:	eb 77                	jmp    801050ad <trap+0xcd>
      exit();
80105036:	e8 56 e6 ff ff       	call   80103691 <exit>
8010503b:	eb da                	jmp    80105017 <trap+0x37>
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
8010503d:	e8 6a e2 ff ff       	call   801032ac <cpuid>
80105042:	85 c0                	test   %eax,%eax
80105044:	74 6f                	je     801050b5 <trap+0xd5>
      acquire(&tickslock);
      ticks++;
      wakeup(&ticks);
      release(&tickslock);
    }
    lapiceoi();
80105046:	e8 e8 d3 ff ff       	call   80102433 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010504b:	e8 7b e2 ff ff       	call   801032cb <myproc>
80105050:	85 c0                	test   %eax,%eax
80105052:	74 1c                	je     80105070 <trap+0x90>
80105054:	e8 72 e2 ff ff       	call   801032cb <myproc>
80105059:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010505d:	74 11                	je     80105070 <trap+0x90>
8010505f:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105063:	83 e0 03             	and    $0x3,%eax
80105066:	66 83 f8 03          	cmp    $0x3,%ax
8010506a:	0f 84 62 01 00 00    	je     801051d2 <trap+0x1f2>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105070:	e8 56 e2 ff ff       	call   801032cb <myproc>
80105075:	85 c0                	test   %eax,%eax
80105077:	74 0f                	je     80105088 <trap+0xa8>
80105079:	e8 4d e2 ff ff       	call   801032cb <myproc>
8010507e:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105082:	0f 84 54 01 00 00    	je     801051dc <trap+0x1fc>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105088:	e8 3e e2 ff ff       	call   801032cb <myproc>
8010508d:	85 c0                	test   %eax,%eax
8010508f:	74 1c                	je     801050ad <trap+0xcd>
80105091:	e8 35 e2 ff ff       	call   801032cb <myproc>
80105096:	83 78 24 00          	cmpl   $0x0,0x24(%eax)
8010509a:	74 11                	je     801050ad <trap+0xcd>
8010509c:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
801050a0:	83 e0 03             	and    $0x3,%eax
801050a3:	66 83 f8 03          	cmp    $0x3,%ax
801050a7:	0f 84 43 01 00 00    	je     801051f0 <trap+0x210>
    exit();
}
801050ad:	8d 65 f4             	lea    -0xc(%ebp),%esp
801050b0:	5b                   	pop    %ebx
801050b1:	5e                   	pop    %esi
801050b2:	5f                   	pop    %edi
801050b3:	5d                   	pop    %ebp
801050b4:	c3                   	ret    
      acquire(&tickslock);
801050b5:	83 ec 0c             	sub    $0xc,%esp
801050b8:	68 60 4e 11 80       	push   $0x80114e60
801050bd:	e8 0d ec ff ff       	call   80103ccf <acquire>
      ticks++;
801050c2:	83 05 a0 56 11 80 01 	addl   $0x1,0x801156a0
      wakeup(&ticks);
801050c9:	c7 04 24 a0 56 11 80 	movl   $0x801156a0,(%esp)
801050d0:	e8 2f e8 ff ff       	call   80103904 <wakeup>
      release(&tickslock);
801050d5:	c7 04 24 60 4e 11 80 	movl   $0x80114e60,(%esp)
801050dc:	e8 57 ec ff ff       	call   80103d38 <release>
801050e1:	83 c4 10             	add    $0x10,%esp
801050e4:	e9 5d ff ff ff       	jmp    80105046 <trap+0x66>
    ideintr();
801050e9:	e8 fe cc ff ff       	call   80101dec <ideintr>
    lapiceoi();
801050ee:	e8 40 d3 ff ff       	call   80102433 <lapiceoi>
    break;
801050f3:	e9 53 ff ff ff       	jmp    8010504b <trap+0x6b>
    kbdintr();
801050f8:	e8 73 d1 ff ff       	call   80102270 <kbdintr>
    lapiceoi();
801050fd:	e8 31 d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105102:	e9 44 ff ff ff       	jmp    8010504b <trap+0x6b>
    uartintr();
80105107:	e8 0a 02 00 00       	call   80105316 <uartintr>
    lapiceoi();
8010510c:	e8 22 d3 ff ff       	call   80102433 <lapiceoi>
    break;
80105111:	e9 35 ff ff ff       	jmp    8010504b <trap+0x6b>
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105116:	8b 7b 38             	mov    0x38(%ebx),%edi
            cpuid(), tf->cs, tf->eip);
80105119:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
8010511d:	e8 8a e1 ff ff       	call   801032ac <cpuid>
80105122:	57                   	push   %edi
80105123:	0f b7 f6             	movzwl %si,%esi
80105126:	56                   	push   %esi
80105127:	50                   	push   %eax
80105128:	68 08 6e 10 80       	push   $0x80106e08
8010512d:	e8 f7 b4 ff ff       	call   80100629 <cprintf>
    lapiceoi();
80105132:	e8 fc d2 ff ff       	call   80102433 <lapiceoi>
    break;
80105137:	83 c4 10             	add    $0x10,%esp
8010513a:	e9 0c ff ff ff       	jmp    8010504b <trap+0x6b>
    if(myproc() == 0 || (tf->cs&3) == 0){
8010513f:	e8 87 e1 ff ff       	call   801032cb <myproc>
80105144:	85 c0                	test   %eax,%eax
80105146:	74 5f                	je     801051a7 <trap+0x1c7>
80105148:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010514c:	74 59                	je     801051a7 <trap+0x1c7>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
8010514e:	0f 20 d7             	mov    %cr2,%edi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105151:	8b 43 38             	mov    0x38(%ebx),%eax
80105154:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105157:	e8 50 e1 ff ff       	call   801032ac <cpuid>
8010515c:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010515f:	8b 53 34             	mov    0x34(%ebx),%edx
80105162:	89 55 dc             	mov    %edx,-0x24(%ebp)
80105165:	8b 73 30             	mov    0x30(%ebx),%esi
            myproc()->pid, myproc()->name, tf->trapno,
80105168:	e8 5e e1 ff ff       	call   801032cb <myproc>
8010516d:	8d 48 6c             	lea    0x6c(%eax),%ecx
80105170:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105173:	e8 53 e1 ff ff       	call   801032cb <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105178:	57                   	push   %edi
80105179:	ff 75 e4             	pushl  -0x1c(%ebp)
8010517c:	ff 75 e0             	pushl  -0x20(%ebp)
8010517f:	ff 75 dc             	pushl  -0x24(%ebp)
80105182:	56                   	push   %esi
80105183:	ff 75 d8             	pushl  -0x28(%ebp)
80105186:	ff 70 10             	pushl  0x10(%eax)
80105189:	68 60 6e 10 80       	push   $0x80106e60
8010518e:	e8 96 b4 ff ff       	call   80100629 <cprintf>
    myproc()->killed = 1;
80105193:	83 c4 20             	add    $0x20,%esp
80105196:	e8 30 e1 ff ff       	call   801032cb <myproc>
8010519b:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801051a2:	e9 a4 fe ff ff       	jmp    8010504b <trap+0x6b>
801051a7:	0f 20 d7             	mov    %cr2,%edi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801051aa:	8b 73 38             	mov    0x38(%ebx),%esi
801051ad:	e8 fa e0 ff ff       	call   801032ac <cpuid>
801051b2:	83 ec 0c             	sub    $0xc,%esp
801051b5:	57                   	push   %edi
801051b6:	56                   	push   %esi
801051b7:	50                   	push   %eax
801051b8:	ff 73 30             	pushl  0x30(%ebx)
801051bb:	68 2c 6e 10 80       	push   $0x80106e2c
801051c0:	e8 64 b4 ff ff       	call   80100629 <cprintf>
      panic("trap");
801051c5:	83 c4 14             	add    $0x14,%esp
801051c8:	68 02 6e 10 80       	push   $0x80106e02
801051cd:	e8 8a b1 ff ff       	call   8010035c <panic>
    exit();
801051d2:	e8 ba e4 ff ff       	call   80103691 <exit>
801051d7:	e9 94 fe ff ff       	jmp    80105070 <trap+0x90>
  if(myproc() && myproc()->state == RUNNING &&
801051dc:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
801051e0:	0f 85 a2 fe ff ff    	jne    80105088 <trap+0xa8>
    yield();
801051e6:	e8 73 e5 ff ff       	call   8010375e <yield>
801051eb:	e9 98 fe ff ff       	jmp    80105088 <trap+0xa8>
    exit();
801051f0:	e8 9c e4 ff ff       	call   80103691 <exit>
801051f5:	e9 b3 fe ff ff       	jmp    801050ad <trap+0xcd>

801051fa <uartgetc>:
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
801051fa:	f3 0f 1e fb          	endbr32 
  if(!uart)
801051fe:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105205:	74 14                	je     8010521b <uartgetc+0x21>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105207:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010520c:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010520d:	a8 01                	test   $0x1,%al
8010520f:	74 10                	je     80105221 <uartgetc+0x27>
80105211:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105216:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105217:	0f b6 c0             	movzbl %al,%eax
8010521a:	c3                   	ret    
    return -1;
8010521b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105220:	c3                   	ret    
    return -1;
80105221:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105226:	c3                   	ret    

80105227 <uartputc>:
{
80105227:	f3 0f 1e fb          	endbr32 
  if(!uart)
8010522b:	83 3d bc a5 10 80 00 	cmpl   $0x0,0x8010a5bc
80105232:	74 3b                	je     8010526f <uartputc+0x48>
{
80105234:	55                   	push   %ebp
80105235:	89 e5                	mov    %esp,%ebp
80105237:	53                   	push   %ebx
80105238:	83 ec 04             	sub    $0x4,%esp
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010523b:	bb 00 00 00 00       	mov    $0x0,%ebx
80105240:	83 fb 7f             	cmp    $0x7f,%ebx
80105243:	7f 1c                	jg     80105261 <uartputc+0x3a>
80105245:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010524a:	ec                   	in     (%dx),%al
8010524b:	a8 20                	test   $0x20,%al
8010524d:	75 12                	jne    80105261 <uartputc+0x3a>
    microdelay(10);
8010524f:	83 ec 0c             	sub    $0xc,%esp
80105252:	6a 0a                	push   $0xa
80105254:	e8 ff d1 ff ff       	call   80102458 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105259:	83 c3 01             	add    $0x1,%ebx
8010525c:	83 c4 10             	add    $0x10,%esp
8010525f:	eb df                	jmp    80105240 <uartputc+0x19>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105261:	8b 45 08             	mov    0x8(%ebp),%eax
80105264:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105269:	ee                   	out    %al,(%dx)
}
8010526a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010526d:	c9                   	leave  
8010526e:	c3                   	ret    
8010526f:	c3                   	ret    

80105270 <uartinit>:
{
80105270:	f3 0f 1e fb          	endbr32 
80105274:	55                   	push   %ebp
80105275:	89 e5                	mov    %esp,%ebp
80105277:	56                   	push   %esi
80105278:	53                   	push   %ebx
80105279:	b9 00 00 00 00       	mov    $0x0,%ecx
8010527e:	ba fa 03 00 00       	mov    $0x3fa,%edx
80105283:	89 c8                	mov    %ecx,%eax
80105285:	ee                   	out    %al,(%dx)
80105286:	be fb 03 00 00       	mov    $0x3fb,%esi
8010528b:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105290:	89 f2                	mov    %esi,%edx
80105292:	ee                   	out    %al,(%dx)
80105293:	b8 0c 00 00 00       	mov    $0xc,%eax
80105298:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010529d:	ee                   	out    %al,(%dx)
8010529e:	bb f9 03 00 00       	mov    $0x3f9,%ebx
801052a3:	89 c8                	mov    %ecx,%eax
801052a5:	89 da                	mov    %ebx,%edx
801052a7:	ee                   	out    %al,(%dx)
801052a8:	b8 03 00 00 00       	mov    $0x3,%eax
801052ad:	89 f2                	mov    %esi,%edx
801052af:	ee                   	out    %al,(%dx)
801052b0:	ba fc 03 00 00       	mov    $0x3fc,%edx
801052b5:	89 c8                	mov    %ecx,%eax
801052b7:	ee                   	out    %al,(%dx)
801052b8:	b8 01 00 00 00       	mov    $0x1,%eax
801052bd:	89 da                	mov    %ebx,%edx
801052bf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801052c0:	ba fd 03 00 00       	mov    $0x3fd,%edx
801052c5:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801052c6:	3c ff                	cmp    $0xff,%al
801052c8:	74 45                	je     8010530f <uartinit+0x9f>
  uart = 1;
801052ca:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
801052d1:	00 00 00 
801052d4:	ba fa 03 00 00       	mov    $0x3fa,%edx
801052d9:	ec                   	in     (%dx),%al
801052da:	ba f8 03 00 00       	mov    $0x3f8,%edx
801052df:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801052e0:	83 ec 08             	sub    $0x8,%esp
801052e3:	6a 00                	push   $0x0
801052e5:	6a 04                	push   $0x4
801052e7:	e8 0f cd ff ff       	call   80101ffb <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801052ec:	83 c4 10             	add    $0x10,%esp
801052ef:	bb 24 6f 10 80       	mov    $0x80106f24,%ebx
801052f4:	eb 12                	jmp    80105308 <uartinit+0x98>
    uartputc(*p);
801052f6:	83 ec 0c             	sub    $0xc,%esp
801052f9:	0f be c0             	movsbl %al,%eax
801052fc:	50                   	push   %eax
801052fd:	e8 25 ff ff ff       	call   80105227 <uartputc>
  for(p="xv6...\n"; *p; p++)
80105302:	83 c3 01             	add    $0x1,%ebx
80105305:	83 c4 10             	add    $0x10,%esp
80105308:	0f b6 03             	movzbl (%ebx),%eax
8010530b:	84 c0                	test   %al,%al
8010530d:	75 e7                	jne    801052f6 <uartinit+0x86>
}
8010530f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105312:	5b                   	pop    %ebx
80105313:	5e                   	pop    %esi
80105314:	5d                   	pop    %ebp
80105315:	c3                   	ret    

80105316 <uartintr>:

void
uartintr(void)
{
80105316:	f3 0f 1e fb          	endbr32 
8010531a:	55                   	push   %ebp
8010531b:	89 e5                	mov    %esp,%ebp
8010531d:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105320:	68 fa 51 10 80       	push   $0x801051fa
80105325:	e8 2f b4 ff ff       	call   80100759 <consoleintr>
}
8010532a:	83 c4 10             	add    $0x10,%esp
8010532d:	c9                   	leave  
8010532e:	c3                   	ret    

8010532f <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
8010532f:	6a 00                	push   $0x0
  pushl $0
80105331:	6a 00                	push   $0x0
  jmp alltraps
80105333:	e9 a8 fb ff ff       	jmp    80104ee0 <alltraps>

80105338 <vector1>:
.globl vector1
vector1:
  pushl $0
80105338:	6a 00                	push   $0x0
  pushl $1
8010533a:	6a 01                	push   $0x1
  jmp alltraps
8010533c:	e9 9f fb ff ff       	jmp    80104ee0 <alltraps>

80105341 <vector2>:
.globl vector2
vector2:
  pushl $0
80105341:	6a 00                	push   $0x0
  pushl $2
80105343:	6a 02                	push   $0x2
  jmp alltraps
80105345:	e9 96 fb ff ff       	jmp    80104ee0 <alltraps>

8010534a <vector3>:
.globl vector3
vector3:
  pushl $0
8010534a:	6a 00                	push   $0x0
  pushl $3
8010534c:	6a 03                	push   $0x3
  jmp alltraps
8010534e:	e9 8d fb ff ff       	jmp    80104ee0 <alltraps>

80105353 <vector4>:
.globl vector4
vector4:
  pushl $0
80105353:	6a 00                	push   $0x0
  pushl $4
80105355:	6a 04                	push   $0x4
  jmp alltraps
80105357:	e9 84 fb ff ff       	jmp    80104ee0 <alltraps>

8010535c <vector5>:
.globl vector5
vector5:
  pushl $0
8010535c:	6a 00                	push   $0x0
  pushl $5
8010535e:	6a 05                	push   $0x5
  jmp alltraps
80105360:	e9 7b fb ff ff       	jmp    80104ee0 <alltraps>

80105365 <vector6>:
.globl vector6
vector6:
  pushl $0
80105365:	6a 00                	push   $0x0
  pushl $6
80105367:	6a 06                	push   $0x6
  jmp alltraps
80105369:	e9 72 fb ff ff       	jmp    80104ee0 <alltraps>

8010536e <vector7>:
.globl vector7
vector7:
  pushl $0
8010536e:	6a 00                	push   $0x0
  pushl $7
80105370:	6a 07                	push   $0x7
  jmp alltraps
80105372:	e9 69 fb ff ff       	jmp    80104ee0 <alltraps>

80105377 <vector8>:
.globl vector8
vector8:
  pushl $8
80105377:	6a 08                	push   $0x8
  jmp alltraps
80105379:	e9 62 fb ff ff       	jmp    80104ee0 <alltraps>

8010537e <vector9>:
.globl vector9
vector9:
  pushl $0
8010537e:	6a 00                	push   $0x0
  pushl $9
80105380:	6a 09                	push   $0x9
  jmp alltraps
80105382:	e9 59 fb ff ff       	jmp    80104ee0 <alltraps>

80105387 <vector10>:
.globl vector10
vector10:
  pushl $10
80105387:	6a 0a                	push   $0xa
  jmp alltraps
80105389:	e9 52 fb ff ff       	jmp    80104ee0 <alltraps>

8010538e <vector11>:
.globl vector11
vector11:
  pushl $11
8010538e:	6a 0b                	push   $0xb
  jmp alltraps
80105390:	e9 4b fb ff ff       	jmp    80104ee0 <alltraps>

80105395 <vector12>:
.globl vector12
vector12:
  pushl $12
80105395:	6a 0c                	push   $0xc
  jmp alltraps
80105397:	e9 44 fb ff ff       	jmp    80104ee0 <alltraps>

8010539c <vector13>:
.globl vector13
vector13:
  pushl $13
8010539c:	6a 0d                	push   $0xd
  jmp alltraps
8010539e:	e9 3d fb ff ff       	jmp    80104ee0 <alltraps>

801053a3 <vector14>:
.globl vector14
vector14:
  pushl $14
801053a3:	6a 0e                	push   $0xe
  jmp alltraps
801053a5:	e9 36 fb ff ff       	jmp    80104ee0 <alltraps>

801053aa <vector15>:
.globl vector15
vector15:
  pushl $0
801053aa:	6a 00                	push   $0x0
  pushl $15
801053ac:	6a 0f                	push   $0xf
  jmp alltraps
801053ae:	e9 2d fb ff ff       	jmp    80104ee0 <alltraps>

801053b3 <vector16>:
.globl vector16
vector16:
  pushl $0
801053b3:	6a 00                	push   $0x0
  pushl $16
801053b5:	6a 10                	push   $0x10
  jmp alltraps
801053b7:	e9 24 fb ff ff       	jmp    80104ee0 <alltraps>

801053bc <vector17>:
.globl vector17
vector17:
  pushl $17
801053bc:	6a 11                	push   $0x11
  jmp alltraps
801053be:	e9 1d fb ff ff       	jmp    80104ee0 <alltraps>

801053c3 <vector18>:
.globl vector18
vector18:
  pushl $0
801053c3:	6a 00                	push   $0x0
  pushl $18
801053c5:	6a 12                	push   $0x12
  jmp alltraps
801053c7:	e9 14 fb ff ff       	jmp    80104ee0 <alltraps>

801053cc <vector19>:
.globl vector19
vector19:
  pushl $0
801053cc:	6a 00                	push   $0x0
  pushl $19
801053ce:	6a 13                	push   $0x13
  jmp alltraps
801053d0:	e9 0b fb ff ff       	jmp    80104ee0 <alltraps>

801053d5 <vector20>:
.globl vector20
vector20:
  pushl $0
801053d5:	6a 00                	push   $0x0
  pushl $20
801053d7:	6a 14                	push   $0x14
  jmp alltraps
801053d9:	e9 02 fb ff ff       	jmp    80104ee0 <alltraps>

801053de <vector21>:
.globl vector21
vector21:
  pushl $0
801053de:	6a 00                	push   $0x0
  pushl $21
801053e0:	6a 15                	push   $0x15
  jmp alltraps
801053e2:	e9 f9 fa ff ff       	jmp    80104ee0 <alltraps>

801053e7 <vector22>:
.globl vector22
vector22:
  pushl $0
801053e7:	6a 00                	push   $0x0
  pushl $22
801053e9:	6a 16                	push   $0x16
  jmp alltraps
801053eb:	e9 f0 fa ff ff       	jmp    80104ee0 <alltraps>

801053f0 <vector23>:
.globl vector23
vector23:
  pushl $0
801053f0:	6a 00                	push   $0x0
  pushl $23
801053f2:	6a 17                	push   $0x17
  jmp alltraps
801053f4:	e9 e7 fa ff ff       	jmp    80104ee0 <alltraps>

801053f9 <vector24>:
.globl vector24
vector24:
  pushl $0
801053f9:	6a 00                	push   $0x0
  pushl $24
801053fb:	6a 18                	push   $0x18
  jmp alltraps
801053fd:	e9 de fa ff ff       	jmp    80104ee0 <alltraps>

80105402 <vector25>:
.globl vector25
vector25:
  pushl $0
80105402:	6a 00                	push   $0x0
  pushl $25
80105404:	6a 19                	push   $0x19
  jmp alltraps
80105406:	e9 d5 fa ff ff       	jmp    80104ee0 <alltraps>

8010540b <vector26>:
.globl vector26
vector26:
  pushl $0
8010540b:	6a 00                	push   $0x0
  pushl $26
8010540d:	6a 1a                	push   $0x1a
  jmp alltraps
8010540f:	e9 cc fa ff ff       	jmp    80104ee0 <alltraps>

80105414 <vector27>:
.globl vector27
vector27:
  pushl $0
80105414:	6a 00                	push   $0x0
  pushl $27
80105416:	6a 1b                	push   $0x1b
  jmp alltraps
80105418:	e9 c3 fa ff ff       	jmp    80104ee0 <alltraps>

8010541d <vector28>:
.globl vector28
vector28:
  pushl $0
8010541d:	6a 00                	push   $0x0
  pushl $28
8010541f:	6a 1c                	push   $0x1c
  jmp alltraps
80105421:	e9 ba fa ff ff       	jmp    80104ee0 <alltraps>

80105426 <vector29>:
.globl vector29
vector29:
  pushl $0
80105426:	6a 00                	push   $0x0
  pushl $29
80105428:	6a 1d                	push   $0x1d
  jmp alltraps
8010542a:	e9 b1 fa ff ff       	jmp    80104ee0 <alltraps>

8010542f <vector30>:
.globl vector30
vector30:
  pushl $0
8010542f:	6a 00                	push   $0x0
  pushl $30
80105431:	6a 1e                	push   $0x1e
  jmp alltraps
80105433:	e9 a8 fa ff ff       	jmp    80104ee0 <alltraps>

80105438 <vector31>:
.globl vector31
vector31:
  pushl $0
80105438:	6a 00                	push   $0x0
  pushl $31
8010543a:	6a 1f                	push   $0x1f
  jmp alltraps
8010543c:	e9 9f fa ff ff       	jmp    80104ee0 <alltraps>

80105441 <vector32>:
.globl vector32
vector32:
  pushl $0
80105441:	6a 00                	push   $0x0
  pushl $32
80105443:	6a 20                	push   $0x20
  jmp alltraps
80105445:	e9 96 fa ff ff       	jmp    80104ee0 <alltraps>

8010544a <vector33>:
.globl vector33
vector33:
  pushl $0
8010544a:	6a 00                	push   $0x0
  pushl $33
8010544c:	6a 21                	push   $0x21
  jmp alltraps
8010544e:	e9 8d fa ff ff       	jmp    80104ee0 <alltraps>

80105453 <vector34>:
.globl vector34
vector34:
  pushl $0
80105453:	6a 00                	push   $0x0
  pushl $34
80105455:	6a 22                	push   $0x22
  jmp alltraps
80105457:	e9 84 fa ff ff       	jmp    80104ee0 <alltraps>

8010545c <vector35>:
.globl vector35
vector35:
  pushl $0
8010545c:	6a 00                	push   $0x0
  pushl $35
8010545e:	6a 23                	push   $0x23
  jmp alltraps
80105460:	e9 7b fa ff ff       	jmp    80104ee0 <alltraps>

80105465 <vector36>:
.globl vector36
vector36:
  pushl $0
80105465:	6a 00                	push   $0x0
  pushl $36
80105467:	6a 24                	push   $0x24
  jmp alltraps
80105469:	e9 72 fa ff ff       	jmp    80104ee0 <alltraps>

8010546e <vector37>:
.globl vector37
vector37:
  pushl $0
8010546e:	6a 00                	push   $0x0
  pushl $37
80105470:	6a 25                	push   $0x25
  jmp alltraps
80105472:	e9 69 fa ff ff       	jmp    80104ee0 <alltraps>

80105477 <vector38>:
.globl vector38
vector38:
  pushl $0
80105477:	6a 00                	push   $0x0
  pushl $38
80105479:	6a 26                	push   $0x26
  jmp alltraps
8010547b:	e9 60 fa ff ff       	jmp    80104ee0 <alltraps>

80105480 <vector39>:
.globl vector39
vector39:
  pushl $0
80105480:	6a 00                	push   $0x0
  pushl $39
80105482:	6a 27                	push   $0x27
  jmp alltraps
80105484:	e9 57 fa ff ff       	jmp    80104ee0 <alltraps>

80105489 <vector40>:
.globl vector40
vector40:
  pushl $0
80105489:	6a 00                	push   $0x0
  pushl $40
8010548b:	6a 28                	push   $0x28
  jmp alltraps
8010548d:	e9 4e fa ff ff       	jmp    80104ee0 <alltraps>

80105492 <vector41>:
.globl vector41
vector41:
  pushl $0
80105492:	6a 00                	push   $0x0
  pushl $41
80105494:	6a 29                	push   $0x29
  jmp alltraps
80105496:	e9 45 fa ff ff       	jmp    80104ee0 <alltraps>

8010549b <vector42>:
.globl vector42
vector42:
  pushl $0
8010549b:	6a 00                	push   $0x0
  pushl $42
8010549d:	6a 2a                	push   $0x2a
  jmp alltraps
8010549f:	e9 3c fa ff ff       	jmp    80104ee0 <alltraps>

801054a4 <vector43>:
.globl vector43
vector43:
  pushl $0
801054a4:	6a 00                	push   $0x0
  pushl $43
801054a6:	6a 2b                	push   $0x2b
  jmp alltraps
801054a8:	e9 33 fa ff ff       	jmp    80104ee0 <alltraps>

801054ad <vector44>:
.globl vector44
vector44:
  pushl $0
801054ad:	6a 00                	push   $0x0
  pushl $44
801054af:	6a 2c                	push   $0x2c
  jmp alltraps
801054b1:	e9 2a fa ff ff       	jmp    80104ee0 <alltraps>

801054b6 <vector45>:
.globl vector45
vector45:
  pushl $0
801054b6:	6a 00                	push   $0x0
  pushl $45
801054b8:	6a 2d                	push   $0x2d
  jmp alltraps
801054ba:	e9 21 fa ff ff       	jmp    80104ee0 <alltraps>

801054bf <vector46>:
.globl vector46
vector46:
  pushl $0
801054bf:	6a 00                	push   $0x0
  pushl $46
801054c1:	6a 2e                	push   $0x2e
  jmp alltraps
801054c3:	e9 18 fa ff ff       	jmp    80104ee0 <alltraps>

801054c8 <vector47>:
.globl vector47
vector47:
  pushl $0
801054c8:	6a 00                	push   $0x0
  pushl $47
801054ca:	6a 2f                	push   $0x2f
  jmp alltraps
801054cc:	e9 0f fa ff ff       	jmp    80104ee0 <alltraps>

801054d1 <vector48>:
.globl vector48
vector48:
  pushl $0
801054d1:	6a 00                	push   $0x0
  pushl $48
801054d3:	6a 30                	push   $0x30
  jmp alltraps
801054d5:	e9 06 fa ff ff       	jmp    80104ee0 <alltraps>

801054da <vector49>:
.globl vector49
vector49:
  pushl $0
801054da:	6a 00                	push   $0x0
  pushl $49
801054dc:	6a 31                	push   $0x31
  jmp alltraps
801054de:	e9 fd f9 ff ff       	jmp    80104ee0 <alltraps>

801054e3 <vector50>:
.globl vector50
vector50:
  pushl $0
801054e3:	6a 00                	push   $0x0
  pushl $50
801054e5:	6a 32                	push   $0x32
  jmp alltraps
801054e7:	e9 f4 f9 ff ff       	jmp    80104ee0 <alltraps>

801054ec <vector51>:
.globl vector51
vector51:
  pushl $0
801054ec:	6a 00                	push   $0x0
  pushl $51
801054ee:	6a 33                	push   $0x33
  jmp alltraps
801054f0:	e9 eb f9 ff ff       	jmp    80104ee0 <alltraps>

801054f5 <vector52>:
.globl vector52
vector52:
  pushl $0
801054f5:	6a 00                	push   $0x0
  pushl $52
801054f7:	6a 34                	push   $0x34
  jmp alltraps
801054f9:	e9 e2 f9 ff ff       	jmp    80104ee0 <alltraps>

801054fe <vector53>:
.globl vector53
vector53:
  pushl $0
801054fe:	6a 00                	push   $0x0
  pushl $53
80105500:	6a 35                	push   $0x35
  jmp alltraps
80105502:	e9 d9 f9 ff ff       	jmp    80104ee0 <alltraps>

80105507 <vector54>:
.globl vector54
vector54:
  pushl $0
80105507:	6a 00                	push   $0x0
  pushl $54
80105509:	6a 36                	push   $0x36
  jmp alltraps
8010550b:	e9 d0 f9 ff ff       	jmp    80104ee0 <alltraps>

80105510 <vector55>:
.globl vector55
vector55:
  pushl $0
80105510:	6a 00                	push   $0x0
  pushl $55
80105512:	6a 37                	push   $0x37
  jmp alltraps
80105514:	e9 c7 f9 ff ff       	jmp    80104ee0 <alltraps>

80105519 <vector56>:
.globl vector56
vector56:
  pushl $0
80105519:	6a 00                	push   $0x0
  pushl $56
8010551b:	6a 38                	push   $0x38
  jmp alltraps
8010551d:	e9 be f9 ff ff       	jmp    80104ee0 <alltraps>

80105522 <vector57>:
.globl vector57
vector57:
  pushl $0
80105522:	6a 00                	push   $0x0
  pushl $57
80105524:	6a 39                	push   $0x39
  jmp alltraps
80105526:	e9 b5 f9 ff ff       	jmp    80104ee0 <alltraps>

8010552b <vector58>:
.globl vector58
vector58:
  pushl $0
8010552b:	6a 00                	push   $0x0
  pushl $58
8010552d:	6a 3a                	push   $0x3a
  jmp alltraps
8010552f:	e9 ac f9 ff ff       	jmp    80104ee0 <alltraps>

80105534 <vector59>:
.globl vector59
vector59:
  pushl $0
80105534:	6a 00                	push   $0x0
  pushl $59
80105536:	6a 3b                	push   $0x3b
  jmp alltraps
80105538:	e9 a3 f9 ff ff       	jmp    80104ee0 <alltraps>

8010553d <vector60>:
.globl vector60
vector60:
  pushl $0
8010553d:	6a 00                	push   $0x0
  pushl $60
8010553f:	6a 3c                	push   $0x3c
  jmp alltraps
80105541:	e9 9a f9 ff ff       	jmp    80104ee0 <alltraps>

80105546 <vector61>:
.globl vector61
vector61:
  pushl $0
80105546:	6a 00                	push   $0x0
  pushl $61
80105548:	6a 3d                	push   $0x3d
  jmp alltraps
8010554a:	e9 91 f9 ff ff       	jmp    80104ee0 <alltraps>

8010554f <vector62>:
.globl vector62
vector62:
  pushl $0
8010554f:	6a 00                	push   $0x0
  pushl $62
80105551:	6a 3e                	push   $0x3e
  jmp alltraps
80105553:	e9 88 f9 ff ff       	jmp    80104ee0 <alltraps>

80105558 <vector63>:
.globl vector63
vector63:
  pushl $0
80105558:	6a 00                	push   $0x0
  pushl $63
8010555a:	6a 3f                	push   $0x3f
  jmp alltraps
8010555c:	e9 7f f9 ff ff       	jmp    80104ee0 <alltraps>

80105561 <vector64>:
.globl vector64
vector64:
  pushl $0
80105561:	6a 00                	push   $0x0
  pushl $64
80105563:	6a 40                	push   $0x40
  jmp alltraps
80105565:	e9 76 f9 ff ff       	jmp    80104ee0 <alltraps>

8010556a <vector65>:
.globl vector65
vector65:
  pushl $0
8010556a:	6a 00                	push   $0x0
  pushl $65
8010556c:	6a 41                	push   $0x41
  jmp alltraps
8010556e:	e9 6d f9 ff ff       	jmp    80104ee0 <alltraps>

80105573 <vector66>:
.globl vector66
vector66:
  pushl $0
80105573:	6a 00                	push   $0x0
  pushl $66
80105575:	6a 42                	push   $0x42
  jmp alltraps
80105577:	e9 64 f9 ff ff       	jmp    80104ee0 <alltraps>

8010557c <vector67>:
.globl vector67
vector67:
  pushl $0
8010557c:	6a 00                	push   $0x0
  pushl $67
8010557e:	6a 43                	push   $0x43
  jmp alltraps
80105580:	e9 5b f9 ff ff       	jmp    80104ee0 <alltraps>

80105585 <vector68>:
.globl vector68
vector68:
  pushl $0
80105585:	6a 00                	push   $0x0
  pushl $68
80105587:	6a 44                	push   $0x44
  jmp alltraps
80105589:	e9 52 f9 ff ff       	jmp    80104ee0 <alltraps>

8010558e <vector69>:
.globl vector69
vector69:
  pushl $0
8010558e:	6a 00                	push   $0x0
  pushl $69
80105590:	6a 45                	push   $0x45
  jmp alltraps
80105592:	e9 49 f9 ff ff       	jmp    80104ee0 <alltraps>

80105597 <vector70>:
.globl vector70
vector70:
  pushl $0
80105597:	6a 00                	push   $0x0
  pushl $70
80105599:	6a 46                	push   $0x46
  jmp alltraps
8010559b:	e9 40 f9 ff ff       	jmp    80104ee0 <alltraps>

801055a0 <vector71>:
.globl vector71
vector71:
  pushl $0
801055a0:	6a 00                	push   $0x0
  pushl $71
801055a2:	6a 47                	push   $0x47
  jmp alltraps
801055a4:	e9 37 f9 ff ff       	jmp    80104ee0 <alltraps>

801055a9 <vector72>:
.globl vector72
vector72:
  pushl $0
801055a9:	6a 00                	push   $0x0
  pushl $72
801055ab:	6a 48                	push   $0x48
  jmp alltraps
801055ad:	e9 2e f9 ff ff       	jmp    80104ee0 <alltraps>

801055b2 <vector73>:
.globl vector73
vector73:
  pushl $0
801055b2:	6a 00                	push   $0x0
  pushl $73
801055b4:	6a 49                	push   $0x49
  jmp alltraps
801055b6:	e9 25 f9 ff ff       	jmp    80104ee0 <alltraps>

801055bb <vector74>:
.globl vector74
vector74:
  pushl $0
801055bb:	6a 00                	push   $0x0
  pushl $74
801055bd:	6a 4a                	push   $0x4a
  jmp alltraps
801055bf:	e9 1c f9 ff ff       	jmp    80104ee0 <alltraps>

801055c4 <vector75>:
.globl vector75
vector75:
  pushl $0
801055c4:	6a 00                	push   $0x0
  pushl $75
801055c6:	6a 4b                	push   $0x4b
  jmp alltraps
801055c8:	e9 13 f9 ff ff       	jmp    80104ee0 <alltraps>

801055cd <vector76>:
.globl vector76
vector76:
  pushl $0
801055cd:	6a 00                	push   $0x0
  pushl $76
801055cf:	6a 4c                	push   $0x4c
  jmp alltraps
801055d1:	e9 0a f9 ff ff       	jmp    80104ee0 <alltraps>

801055d6 <vector77>:
.globl vector77
vector77:
  pushl $0
801055d6:	6a 00                	push   $0x0
  pushl $77
801055d8:	6a 4d                	push   $0x4d
  jmp alltraps
801055da:	e9 01 f9 ff ff       	jmp    80104ee0 <alltraps>

801055df <vector78>:
.globl vector78
vector78:
  pushl $0
801055df:	6a 00                	push   $0x0
  pushl $78
801055e1:	6a 4e                	push   $0x4e
  jmp alltraps
801055e3:	e9 f8 f8 ff ff       	jmp    80104ee0 <alltraps>

801055e8 <vector79>:
.globl vector79
vector79:
  pushl $0
801055e8:	6a 00                	push   $0x0
  pushl $79
801055ea:	6a 4f                	push   $0x4f
  jmp alltraps
801055ec:	e9 ef f8 ff ff       	jmp    80104ee0 <alltraps>

801055f1 <vector80>:
.globl vector80
vector80:
  pushl $0
801055f1:	6a 00                	push   $0x0
  pushl $80
801055f3:	6a 50                	push   $0x50
  jmp alltraps
801055f5:	e9 e6 f8 ff ff       	jmp    80104ee0 <alltraps>

801055fa <vector81>:
.globl vector81
vector81:
  pushl $0
801055fa:	6a 00                	push   $0x0
  pushl $81
801055fc:	6a 51                	push   $0x51
  jmp alltraps
801055fe:	e9 dd f8 ff ff       	jmp    80104ee0 <alltraps>

80105603 <vector82>:
.globl vector82
vector82:
  pushl $0
80105603:	6a 00                	push   $0x0
  pushl $82
80105605:	6a 52                	push   $0x52
  jmp alltraps
80105607:	e9 d4 f8 ff ff       	jmp    80104ee0 <alltraps>

8010560c <vector83>:
.globl vector83
vector83:
  pushl $0
8010560c:	6a 00                	push   $0x0
  pushl $83
8010560e:	6a 53                	push   $0x53
  jmp alltraps
80105610:	e9 cb f8 ff ff       	jmp    80104ee0 <alltraps>

80105615 <vector84>:
.globl vector84
vector84:
  pushl $0
80105615:	6a 00                	push   $0x0
  pushl $84
80105617:	6a 54                	push   $0x54
  jmp alltraps
80105619:	e9 c2 f8 ff ff       	jmp    80104ee0 <alltraps>

8010561e <vector85>:
.globl vector85
vector85:
  pushl $0
8010561e:	6a 00                	push   $0x0
  pushl $85
80105620:	6a 55                	push   $0x55
  jmp alltraps
80105622:	e9 b9 f8 ff ff       	jmp    80104ee0 <alltraps>

80105627 <vector86>:
.globl vector86
vector86:
  pushl $0
80105627:	6a 00                	push   $0x0
  pushl $86
80105629:	6a 56                	push   $0x56
  jmp alltraps
8010562b:	e9 b0 f8 ff ff       	jmp    80104ee0 <alltraps>

80105630 <vector87>:
.globl vector87
vector87:
  pushl $0
80105630:	6a 00                	push   $0x0
  pushl $87
80105632:	6a 57                	push   $0x57
  jmp alltraps
80105634:	e9 a7 f8 ff ff       	jmp    80104ee0 <alltraps>

80105639 <vector88>:
.globl vector88
vector88:
  pushl $0
80105639:	6a 00                	push   $0x0
  pushl $88
8010563b:	6a 58                	push   $0x58
  jmp alltraps
8010563d:	e9 9e f8 ff ff       	jmp    80104ee0 <alltraps>

80105642 <vector89>:
.globl vector89
vector89:
  pushl $0
80105642:	6a 00                	push   $0x0
  pushl $89
80105644:	6a 59                	push   $0x59
  jmp alltraps
80105646:	e9 95 f8 ff ff       	jmp    80104ee0 <alltraps>

8010564b <vector90>:
.globl vector90
vector90:
  pushl $0
8010564b:	6a 00                	push   $0x0
  pushl $90
8010564d:	6a 5a                	push   $0x5a
  jmp alltraps
8010564f:	e9 8c f8 ff ff       	jmp    80104ee0 <alltraps>

80105654 <vector91>:
.globl vector91
vector91:
  pushl $0
80105654:	6a 00                	push   $0x0
  pushl $91
80105656:	6a 5b                	push   $0x5b
  jmp alltraps
80105658:	e9 83 f8 ff ff       	jmp    80104ee0 <alltraps>

8010565d <vector92>:
.globl vector92
vector92:
  pushl $0
8010565d:	6a 00                	push   $0x0
  pushl $92
8010565f:	6a 5c                	push   $0x5c
  jmp alltraps
80105661:	e9 7a f8 ff ff       	jmp    80104ee0 <alltraps>

80105666 <vector93>:
.globl vector93
vector93:
  pushl $0
80105666:	6a 00                	push   $0x0
  pushl $93
80105668:	6a 5d                	push   $0x5d
  jmp alltraps
8010566a:	e9 71 f8 ff ff       	jmp    80104ee0 <alltraps>

8010566f <vector94>:
.globl vector94
vector94:
  pushl $0
8010566f:	6a 00                	push   $0x0
  pushl $94
80105671:	6a 5e                	push   $0x5e
  jmp alltraps
80105673:	e9 68 f8 ff ff       	jmp    80104ee0 <alltraps>

80105678 <vector95>:
.globl vector95
vector95:
  pushl $0
80105678:	6a 00                	push   $0x0
  pushl $95
8010567a:	6a 5f                	push   $0x5f
  jmp alltraps
8010567c:	e9 5f f8 ff ff       	jmp    80104ee0 <alltraps>

80105681 <vector96>:
.globl vector96
vector96:
  pushl $0
80105681:	6a 00                	push   $0x0
  pushl $96
80105683:	6a 60                	push   $0x60
  jmp alltraps
80105685:	e9 56 f8 ff ff       	jmp    80104ee0 <alltraps>

8010568a <vector97>:
.globl vector97
vector97:
  pushl $0
8010568a:	6a 00                	push   $0x0
  pushl $97
8010568c:	6a 61                	push   $0x61
  jmp alltraps
8010568e:	e9 4d f8 ff ff       	jmp    80104ee0 <alltraps>

80105693 <vector98>:
.globl vector98
vector98:
  pushl $0
80105693:	6a 00                	push   $0x0
  pushl $98
80105695:	6a 62                	push   $0x62
  jmp alltraps
80105697:	e9 44 f8 ff ff       	jmp    80104ee0 <alltraps>

8010569c <vector99>:
.globl vector99
vector99:
  pushl $0
8010569c:	6a 00                	push   $0x0
  pushl $99
8010569e:	6a 63                	push   $0x63
  jmp alltraps
801056a0:	e9 3b f8 ff ff       	jmp    80104ee0 <alltraps>

801056a5 <vector100>:
.globl vector100
vector100:
  pushl $0
801056a5:	6a 00                	push   $0x0
  pushl $100
801056a7:	6a 64                	push   $0x64
  jmp alltraps
801056a9:	e9 32 f8 ff ff       	jmp    80104ee0 <alltraps>

801056ae <vector101>:
.globl vector101
vector101:
  pushl $0
801056ae:	6a 00                	push   $0x0
  pushl $101
801056b0:	6a 65                	push   $0x65
  jmp alltraps
801056b2:	e9 29 f8 ff ff       	jmp    80104ee0 <alltraps>

801056b7 <vector102>:
.globl vector102
vector102:
  pushl $0
801056b7:	6a 00                	push   $0x0
  pushl $102
801056b9:	6a 66                	push   $0x66
  jmp alltraps
801056bb:	e9 20 f8 ff ff       	jmp    80104ee0 <alltraps>

801056c0 <vector103>:
.globl vector103
vector103:
  pushl $0
801056c0:	6a 00                	push   $0x0
  pushl $103
801056c2:	6a 67                	push   $0x67
  jmp alltraps
801056c4:	e9 17 f8 ff ff       	jmp    80104ee0 <alltraps>

801056c9 <vector104>:
.globl vector104
vector104:
  pushl $0
801056c9:	6a 00                	push   $0x0
  pushl $104
801056cb:	6a 68                	push   $0x68
  jmp alltraps
801056cd:	e9 0e f8 ff ff       	jmp    80104ee0 <alltraps>

801056d2 <vector105>:
.globl vector105
vector105:
  pushl $0
801056d2:	6a 00                	push   $0x0
  pushl $105
801056d4:	6a 69                	push   $0x69
  jmp alltraps
801056d6:	e9 05 f8 ff ff       	jmp    80104ee0 <alltraps>

801056db <vector106>:
.globl vector106
vector106:
  pushl $0
801056db:	6a 00                	push   $0x0
  pushl $106
801056dd:	6a 6a                	push   $0x6a
  jmp alltraps
801056df:	e9 fc f7 ff ff       	jmp    80104ee0 <alltraps>

801056e4 <vector107>:
.globl vector107
vector107:
  pushl $0
801056e4:	6a 00                	push   $0x0
  pushl $107
801056e6:	6a 6b                	push   $0x6b
  jmp alltraps
801056e8:	e9 f3 f7 ff ff       	jmp    80104ee0 <alltraps>

801056ed <vector108>:
.globl vector108
vector108:
  pushl $0
801056ed:	6a 00                	push   $0x0
  pushl $108
801056ef:	6a 6c                	push   $0x6c
  jmp alltraps
801056f1:	e9 ea f7 ff ff       	jmp    80104ee0 <alltraps>

801056f6 <vector109>:
.globl vector109
vector109:
  pushl $0
801056f6:	6a 00                	push   $0x0
  pushl $109
801056f8:	6a 6d                	push   $0x6d
  jmp alltraps
801056fa:	e9 e1 f7 ff ff       	jmp    80104ee0 <alltraps>

801056ff <vector110>:
.globl vector110
vector110:
  pushl $0
801056ff:	6a 00                	push   $0x0
  pushl $110
80105701:	6a 6e                	push   $0x6e
  jmp alltraps
80105703:	e9 d8 f7 ff ff       	jmp    80104ee0 <alltraps>

80105708 <vector111>:
.globl vector111
vector111:
  pushl $0
80105708:	6a 00                	push   $0x0
  pushl $111
8010570a:	6a 6f                	push   $0x6f
  jmp alltraps
8010570c:	e9 cf f7 ff ff       	jmp    80104ee0 <alltraps>

80105711 <vector112>:
.globl vector112
vector112:
  pushl $0
80105711:	6a 00                	push   $0x0
  pushl $112
80105713:	6a 70                	push   $0x70
  jmp alltraps
80105715:	e9 c6 f7 ff ff       	jmp    80104ee0 <alltraps>

8010571a <vector113>:
.globl vector113
vector113:
  pushl $0
8010571a:	6a 00                	push   $0x0
  pushl $113
8010571c:	6a 71                	push   $0x71
  jmp alltraps
8010571e:	e9 bd f7 ff ff       	jmp    80104ee0 <alltraps>

80105723 <vector114>:
.globl vector114
vector114:
  pushl $0
80105723:	6a 00                	push   $0x0
  pushl $114
80105725:	6a 72                	push   $0x72
  jmp alltraps
80105727:	e9 b4 f7 ff ff       	jmp    80104ee0 <alltraps>

8010572c <vector115>:
.globl vector115
vector115:
  pushl $0
8010572c:	6a 00                	push   $0x0
  pushl $115
8010572e:	6a 73                	push   $0x73
  jmp alltraps
80105730:	e9 ab f7 ff ff       	jmp    80104ee0 <alltraps>

80105735 <vector116>:
.globl vector116
vector116:
  pushl $0
80105735:	6a 00                	push   $0x0
  pushl $116
80105737:	6a 74                	push   $0x74
  jmp alltraps
80105739:	e9 a2 f7 ff ff       	jmp    80104ee0 <alltraps>

8010573e <vector117>:
.globl vector117
vector117:
  pushl $0
8010573e:	6a 00                	push   $0x0
  pushl $117
80105740:	6a 75                	push   $0x75
  jmp alltraps
80105742:	e9 99 f7 ff ff       	jmp    80104ee0 <alltraps>

80105747 <vector118>:
.globl vector118
vector118:
  pushl $0
80105747:	6a 00                	push   $0x0
  pushl $118
80105749:	6a 76                	push   $0x76
  jmp alltraps
8010574b:	e9 90 f7 ff ff       	jmp    80104ee0 <alltraps>

80105750 <vector119>:
.globl vector119
vector119:
  pushl $0
80105750:	6a 00                	push   $0x0
  pushl $119
80105752:	6a 77                	push   $0x77
  jmp alltraps
80105754:	e9 87 f7 ff ff       	jmp    80104ee0 <alltraps>

80105759 <vector120>:
.globl vector120
vector120:
  pushl $0
80105759:	6a 00                	push   $0x0
  pushl $120
8010575b:	6a 78                	push   $0x78
  jmp alltraps
8010575d:	e9 7e f7 ff ff       	jmp    80104ee0 <alltraps>

80105762 <vector121>:
.globl vector121
vector121:
  pushl $0
80105762:	6a 00                	push   $0x0
  pushl $121
80105764:	6a 79                	push   $0x79
  jmp alltraps
80105766:	e9 75 f7 ff ff       	jmp    80104ee0 <alltraps>

8010576b <vector122>:
.globl vector122
vector122:
  pushl $0
8010576b:	6a 00                	push   $0x0
  pushl $122
8010576d:	6a 7a                	push   $0x7a
  jmp alltraps
8010576f:	e9 6c f7 ff ff       	jmp    80104ee0 <alltraps>

80105774 <vector123>:
.globl vector123
vector123:
  pushl $0
80105774:	6a 00                	push   $0x0
  pushl $123
80105776:	6a 7b                	push   $0x7b
  jmp alltraps
80105778:	e9 63 f7 ff ff       	jmp    80104ee0 <alltraps>

8010577d <vector124>:
.globl vector124
vector124:
  pushl $0
8010577d:	6a 00                	push   $0x0
  pushl $124
8010577f:	6a 7c                	push   $0x7c
  jmp alltraps
80105781:	e9 5a f7 ff ff       	jmp    80104ee0 <alltraps>

80105786 <vector125>:
.globl vector125
vector125:
  pushl $0
80105786:	6a 00                	push   $0x0
  pushl $125
80105788:	6a 7d                	push   $0x7d
  jmp alltraps
8010578a:	e9 51 f7 ff ff       	jmp    80104ee0 <alltraps>

8010578f <vector126>:
.globl vector126
vector126:
  pushl $0
8010578f:	6a 00                	push   $0x0
  pushl $126
80105791:	6a 7e                	push   $0x7e
  jmp alltraps
80105793:	e9 48 f7 ff ff       	jmp    80104ee0 <alltraps>

80105798 <vector127>:
.globl vector127
vector127:
  pushl $0
80105798:	6a 00                	push   $0x0
  pushl $127
8010579a:	6a 7f                	push   $0x7f
  jmp alltraps
8010579c:	e9 3f f7 ff ff       	jmp    80104ee0 <alltraps>

801057a1 <vector128>:
.globl vector128
vector128:
  pushl $0
801057a1:	6a 00                	push   $0x0
  pushl $128
801057a3:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801057a8:	e9 33 f7 ff ff       	jmp    80104ee0 <alltraps>

801057ad <vector129>:
.globl vector129
vector129:
  pushl $0
801057ad:	6a 00                	push   $0x0
  pushl $129
801057af:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801057b4:	e9 27 f7 ff ff       	jmp    80104ee0 <alltraps>

801057b9 <vector130>:
.globl vector130
vector130:
  pushl $0
801057b9:	6a 00                	push   $0x0
  pushl $130
801057bb:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801057c0:	e9 1b f7 ff ff       	jmp    80104ee0 <alltraps>

801057c5 <vector131>:
.globl vector131
vector131:
  pushl $0
801057c5:	6a 00                	push   $0x0
  pushl $131
801057c7:	68 83 00 00 00       	push   $0x83
  jmp alltraps
801057cc:	e9 0f f7 ff ff       	jmp    80104ee0 <alltraps>

801057d1 <vector132>:
.globl vector132
vector132:
  pushl $0
801057d1:	6a 00                	push   $0x0
  pushl $132
801057d3:	68 84 00 00 00       	push   $0x84
  jmp alltraps
801057d8:	e9 03 f7 ff ff       	jmp    80104ee0 <alltraps>

801057dd <vector133>:
.globl vector133
vector133:
  pushl $0
801057dd:	6a 00                	push   $0x0
  pushl $133
801057df:	68 85 00 00 00       	push   $0x85
  jmp alltraps
801057e4:	e9 f7 f6 ff ff       	jmp    80104ee0 <alltraps>

801057e9 <vector134>:
.globl vector134
vector134:
  pushl $0
801057e9:	6a 00                	push   $0x0
  pushl $134
801057eb:	68 86 00 00 00       	push   $0x86
  jmp alltraps
801057f0:	e9 eb f6 ff ff       	jmp    80104ee0 <alltraps>

801057f5 <vector135>:
.globl vector135
vector135:
  pushl $0
801057f5:	6a 00                	push   $0x0
  pushl $135
801057f7:	68 87 00 00 00       	push   $0x87
  jmp alltraps
801057fc:	e9 df f6 ff ff       	jmp    80104ee0 <alltraps>

80105801 <vector136>:
.globl vector136
vector136:
  pushl $0
80105801:	6a 00                	push   $0x0
  pushl $136
80105803:	68 88 00 00 00       	push   $0x88
  jmp alltraps
80105808:	e9 d3 f6 ff ff       	jmp    80104ee0 <alltraps>

8010580d <vector137>:
.globl vector137
vector137:
  pushl $0
8010580d:	6a 00                	push   $0x0
  pushl $137
8010580f:	68 89 00 00 00       	push   $0x89
  jmp alltraps
80105814:	e9 c7 f6 ff ff       	jmp    80104ee0 <alltraps>

80105819 <vector138>:
.globl vector138
vector138:
  pushl $0
80105819:	6a 00                	push   $0x0
  pushl $138
8010581b:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80105820:	e9 bb f6 ff ff       	jmp    80104ee0 <alltraps>

80105825 <vector139>:
.globl vector139
vector139:
  pushl $0
80105825:	6a 00                	push   $0x0
  pushl $139
80105827:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
8010582c:	e9 af f6 ff ff       	jmp    80104ee0 <alltraps>

80105831 <vector140>:
.globl vector140
vector140:
  pushl $0
80105831:	6a 00                	push   $0x0
  pushl $140
80105833:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
80105838:	e9 a3 f6 ff ff       	jmp    80104ee0 <alltraps>

8010583d <vector141>:
.globl vector141
vector141:
  pushl $0
8010583d:	6a 00                	push   $0x0
  pushl $141
8010583f:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
80105844:	e9 97 f6 ff ff       	jmp    80104ee0 <alltraps>

80105849 <vector142>:
.globl vector142
vector142:
  pushl $0
80105849:	6a 00                	push   $0x0
  pushl $142
8010584b:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80105850:	e9 8b f6 ff ff       	jmp    80104ee0 <alltraps>

80105855 <vector143>:
.globl vector143
vector143:
  pushl $0
80105855:	6a 00                	push   $0x0
  pushl $143
80105857:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
8010585c:	e9 7f f6 ff ff       	jmp    80104ee0 <alltraps>

80105861 <vector144>:
.globl vector144
vector144:
  pushl $0
80105861:	6a 00                	push   $0x0
  pushl $144
80105863:	68 90 00 00 00       	push   $0x90
  jmp alltraps
80105868:	e9 73 f6 ff ff       	jmp    80104ee0 <alltraps>

8010586d <vector145>:
.globl vector145
vector145:
  pushl $0
8010586d:	6a 00                	push   $0x0
  pushl $145
8010586f:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80105874:	e9 67 f6 ff ff       	jmp    80104ee0 <alltraps>

80105879 <vector146>:
.globl vector146
vector146:
  pushl $0
80105879:	6a 00                	push   $0x0
  pushl $146
8010587b:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80105880:	e9 5b f6 ff ff       	jmp    80104ee0 <alltraps>

80105885 <vector147>:
.globl vector147
vector147:
  pushl $0
80105885:	6a 00                	push   $0x0
  pushl $147
80105887:	68 93 00 00 00       	push   $0x93
  jmp alltraps
8010588c:	e9 4f f6 ff ff       	jmp    80104ee0 <alltraps>

80105891 <vector148>:
.globl vector148
vector148:
  pushl $0
80105891:	6a 00                	push   $0x0
  pushl $148
80105893:	68 94 00 00 00       	push   $0x94
  jmp alltraps
80105898:	e9 43 f6 ff ff       	jmp    80104ee0 <alltraps>

8010589d <vector149>:
.globl vector149
vector149:
  pushl $0
8010589d:	6a 00                	push   $0x0
  pushl $149
8010589f:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801058a4:	e9 37 f6 ff ff       	jmp    80104ee0 <alltraps>

801058a9 <vector150>:
.globl vector150
vector150:
  pushl $0
801058a9:	6a 00                	push   $0x0
  pushl $150
801058ab:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801058b0:	e9 2b f6 ff ff       	jmp    80104ee0 <alltraps>

801058b5 <vector151>:
.globl vector151
vector151:
  pushl $0
801058b5:	6a 00                	push   $0x0
  pushl $151
801058b7:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801058bc:	e9 1f f6 ff ff       	jmp    80104ee0 <alltraps>

801058c1 <vector152>:
.globl vector152
vector152:
  pushl $0
801058c1:	6a 00                	push   $0x0
  pushl $152
801058c3:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801058c8:	e9 13 f6 ff ff       	jmp    80104ee0 <alltraps>

801058cd <vector153>:
.globl vector153
vector153:
  pushl $0
801058cd:	6a 00                	push   $0x0
  pushl $153
801058cf:	68 99 00 00 00       	push   $0x99
  jmp alltraps
801058d4:	e9 07 f6 ff ff       	jmp    80104ee0 <alltraps>

801058d9 <vector154>:
.globl vector154
vector154:
  pushl $0
801058d9:	6a 00                	push   $0x0
  pushl $154
801058db:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
801058e0:	e9 fb f5 ff ff       	jmp    80104ee0 <alltraps>

801058e5 <vector155>:
.globl vector155
vector155:
  pushl $0
801058e5:	6a 00                	push   $0x0
  pushl $155
801058e7:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
801058ec:	e9 ef f5 ff ff       	jmp    80104ee0 <alltraps>

801058f1 <vector156>:
.globl vector156
vector156:
  pushl $0
801058f1:	6a 00                	push   $0x0
  pushl $156
801058f3:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
801058f8:	e9 e3 f5 ff ff       	jmp    80104ee0 <alltraps>

801058fd <vector157>:
.globl vector157
vector157:
  pushl $0
801058fd:	6a 00                	push   $0x0
  pushl $157
801058ff:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80105904:	e9 d7 f5 ff ff       	jmp    80104ee0 <alltraps>

80105909 <vector158>:
.globl vector158
vector158:
  pushl $0
80105909:	6a 00                	push   $0x0
  pushl $158
8010590b:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80105910:	e9 cb f5 ff ff       	jmp    80104ee0 <alltraps>

80105915 <vector159>:
.globl vector159
vector159:
  pushl $0
80105915:	6a 00                	push   $0x0
  pushl $159
80105917:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
8010591c:	e9 bf f5 ff ff       	jmp    80104ee0 <alltraps>

80105921 <vector160>:
.globl vector160
vector160:
  pushl $0
80105921:	6a 00                	push   $0x0
  pushl $160
80105923:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
80105928:	e9 b3 f5 ff ff       	jmp    80104ee0 <alltraps>

8010592d <vector161>:
.globl vector161
vector161:
  pushl $0
8010592d:	6a 00                	push   $0x0
  pushl $161
8010592f:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
80105934:	e9 a7 f5 ff ff       	jmp    80104ee0 <alltraps>

80105939 <vector162>:
.globl vector162
vector162:
  pushl $0
80105939:	6a 00                	push   $0x0
  pushl $162
8010593b:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80105940:	e9 9b f5 ff ff       	jmp    80104ee0 <alltraps>

80105945 <vector163>:
.globl vector163
vector163:
  pushl $0
80105945:	6a 00                	push   $0x0
  pushl $163
80105947:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
8010594c:	e9 8f f5 ff ff       	jmp    80104ee0 <alltraps>

80105951 <vector164>:
.globl vector164
vector164:
  pushl $0
80105951:	6a 00                	push   $0x0
  pushl $164
80105953:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
80105958:	e9 83 f5 ff ff       	jmp    80104ee0 <alltraps>

8010595d <vector165>:
.globl vector165
vector165:
  pushl $0
8010595d:	6a 00                	push   $0x0
  pushl $165
8010595f:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
80105964:	e9 77 f5 ff ff       	jmp    80104ee0 <alltraps>

80105969 <vector166>:
.globl vector166
vector166:
  pushl $0
80105969:	6a 00                	push   $0x0
  pushl $166
8010596b:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80105970:	e9 6b f5 ff ff       	jmp    80104ee0 <alltraps>

80105975 <vector167>:
.globl vector167
vector167:
  pushl $0
80105975:	6a 00                	push   $0x0
  pushl $167
80105977:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
8010597c:	e9 5f f5 ff ff       	jmp    80104ee0 <alltraps>

80105981 <vector168>:
.globl vector168
vector168:
  pushl $0
80105981:	6a 00                	push   $0x0
  pushl $168
80105983:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
80105988:	e9 53 f5 ff ff       	jmp    80104ee0 <alltraps>

8010598d <vector169>:
.globl vector169
vector169:
  pushl $0
8010598d:	6a 00                	push   $0x0
  pushl $169
8010598f:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80105994:	e9 47 f5 ff ff       	jmp    80104ee0 <alltraps>

80105999 <vector170>:
.globl vector170
vector170:
  pushl $0
80105999:	6a 00                	push   $0x0
  pushl $170
8010599b:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801059a0:	e9 3b f5 ff ff       	jmp    80104ee0 <alltraps>

801059a5 <vector171>:
.globl vector171
vector171:
  pushl $0
801059a5:	6a 00                	push   $0x0
  pushl $171
801059a7:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801059ac:	e9 2f f5 ff ff       	jmp    80104ee0 <alltraps>

801059b1 <vector172>:
.globl vector172
vector172:
  pushl $0
801059b1:	6a 00                	push   $0x0
  pushl $172
801059b3:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801059b8:	e9 23 f5 ff ff       	jmp    80104ee0 <alltraps>

801059bd <vector173>:
.globl vector173
vector173:
  pushl $0
801059bd:	6a 00                	push   $0x0
  pushl $173
801059bf:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801059c4:	e9 17 f5 ff ff       	jmp    80104ee0 <alltraps>

801059c9 <vector174>:
.globl vector174
vector174:
  pushl $0
801059c9:	6a 00                	push   $0x0
  pushl $174
801059cb:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
801059d0:	e9 0b f5 ff ff       	jmp    80104ee0 <alltraps>

801059d5 <vector175>:
.globl vector175
vector175:
  pushl $0
801059d5:	6a 00                	push   $0x0
  pushl $175
801059d7:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
801059dc:	e9 ff f4 ff ff       	jmp    80104ee0 <alltraps>

801059e1 <vector176>:
.globl vector176
vector176:
  pushl $0
801059e1:	6a 00                	push   $0x0
  pushl $176
801059e3:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
801059e8:	e9 f3 f4 ff ff       	jmp    80104ee0 <alltraps>

801059ed <vector177>:
.globl vector177
vector177:
  pushl $0
801059ed:	6a 00                	push   $0x0
  pushl $177
801059ef:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
801059f4:	e9 e7 f4 ff ff       	jmp    80104ee0 <alltraps>

801059f9 <vector178>:
.globl vector178
vector178:
  pushl $0
801059f9:	6a 00                	push   $0x0
  pushl $178
801059fb:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80105a00:	e9 db f4 ff ff       	jmp    80104ee0 <alltraps>

80105a05 <vector179>:
.globl vector179
vector179:
  pushl $0
80105a05:	6a 00                	push   $0x0
  pushl $179
80105a07:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80105a0c:	e9 cf f4 ff ff       	jmp    80104ee0 <alltraps>

80105a11 <vector180>:
.globl vector180
vector180:
  pushl $0
80105a11:	6a 00                	push   $0x0
  pushl $180
80105a13:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
80105a18:	e9 c3 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a1d <vector181>:
.globl vector181
vector181:
  pushl $0
80105a1d:	6a 00                	push   $0x0
  pushl $181
80105a1f:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
80105a24:	e9 b7 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a29 <vector182>:
.globl vector182
vector182:
  pushl $0
80105a29:	6a 00                	push   $0x0
  pushl $182
80105a2b:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80105a30:	e9 ab f4 ff ff       	jmp    80104ee0 <alltraps>

80105a35 <vector183>:
.globl vector183
vector183:
  pushl $0
80105a35:	6a 00                	push   $0x0
  pushl $183
80105a37:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80105a3c:	e9 9f f4 ff ff       	jmp    80104ee0 <alltraps>

80105a41 <vector184>:
.globl vector184
vector184:
  pushl $0
80105a41:	6a 00                	push   $0x0
  pushl $184
80105a43:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
80105a48:	e9 93 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a4d <vector185>:
.globl vector185
vector185:
  pushl $0
80105a4d:	6a 00                	push   $0x0
  pushl $185
80105a4f:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
80105a54:	e9 87 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a59 <vector186>:
.globl vector186
vector186:
  pushl $0
80105a59:	6a 00                	push   $0x0
  pushl $186
80105a5b:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80105a60:	e9 7b f4 ff ff       	jmp    80104ee0 <alltraps>

80105a65 <vector187>:
.globl vector187
vector187:
  pushl $0
80105a65:	6a 00                	push   $0x0
  pushl $187
80105a67:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80105a6c:	e9 6f f4 ff ff       	jmp    80104ee0 <alltraps>

80105a71 <vector188>:
.globl vector188
vector188:
  pushl $0
80105a71:	6a 00                	push   $0x0
  pushl $188
80105a73:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
80105a78:	e9 63 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a7d <vector189>:
.globl vector189
vector189:
  pushl $0
80105a7d:	6a 00                	push   $0x0
  pushl $189
80105a7f:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80105a84:	e9 57 f4 ff ff       	jmp    80104ee0 <alltraps>

80105a89 <vector190>:
.globl vector190
vector190:
  pushl $0
80105a89:	6a 00                	push   $0x0
  pushl $190
80105a8b:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80105a90:	e9 4b f4 ff ff       	jmp    80104ee0 <alltraps>

80105a95 <vector191>:
.globl vector191
vector191:
  pushl $0
80105a95:	6a 00                	push   $0x0
  pushl $191
80105a97:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80105a9c:	e9 3f f4 ff ff       	jmp    80104ee0 <alltraps>

80105aa1 <vector192>:
.globl vector192
vector192:
  pushl $0
80105aa1:	6a 00                	push   $0x0
  pushl $192
80105aa3:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80105aa8:	e9 33 f4 ff ff       	jmp    80104ee0 <alltraps>

80105aad <vector193>:
.globl vector193
vector193:
  pushl $0
80105aad:	6a 00                	push   $0x0
  pushl $193
80105aaf:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80105ab4:	e9 27 f4 ff ff       	jmp    80104ee0 <alltraps>

80105ab9 <vector194>:
.globl vector194
vector194:
  pushl $0
80105ab9:	6a 00                	push   $0x0
  pushl $194
80105abb:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80105ac0:	e9 1b f4 ff ff       	jmp    80104ee0 <alltraps>

80105ac5 <vector195>:
.globl vector195
vector195:
  pushl $0
80105ac5:	6a 00                	push   $0x0
  pushl $195
80105ac7:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80105acc:	e9 0f f4 ff ff       	jmp    80104ee0 <alltraps>

80105ad1 <vector196>:
.globl vector196
vector196:
  pushl $0
80105ad1:	6a 00                	push   $0x0
  pushl $196
80105ad3:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80105ad8:	e9 03 f4 ff ff       	jmp    80104ee0 <alltraps>

80105add <vector197>:
.globl vector197
vector197:
  pushl $0
80105add:	6a 00                	push   $0x0
  pushl $197
80105adf:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80105ae4:	e9 f7 f3 ff ff       	jmp    80104ee0 <alltraps>

80105ae9 <vector198>:
.globl vector198
vector198:
  pushl $0
80105ae9:	6a 00                	push   $0x0
  pushl $198
80105aeb:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80105af0:	e9 eb f3 ff ff       	jmp    80104ee0 <alltraps>

80105af5 <vector199>:
.globl vector199
vector199:
  pushl $0
80105af5:	6a 00                	push   $0x0
  pushl $199
80105af7:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80105afc:	e9 df f3 ff ff       	jmp    80104ee0 <alltraps>

80105b01 <vector200>:
.globl vector200
vector200:
  pushl $0
80105b01:	6a 00                	push   $0x0
  pushl $200
80105b03:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80105b08:	e9 d3 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b0d <vector201>:
.globl vector201
vector201:
  pushl $0
80105b0d:	6a 00                	push   $0x0
  pushl $201
80105b0f:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80105b14:	e9 c7 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b19 <vector202>:
.globl vector202
vector202:
  pushl $0
80105b19:	6a 00                	push   $0x0
  pushl $202
80105b1b:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80105b20:	e9 bb f3 ff ff       	jmp    80104ee0 <alltraps>

80105b25 <vector203>:
.globl vector203
vector203:
  pushl $0
80105b25:	6a 00                	push   $0x0
  pushl $203
80105b27:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80105b2c:	e9 af f3 ff ff       	jmp    80104ee0 <alltraps>

80105b31 <vector204>:
.globl vector204
vector204:
  pushl $0
80105b31:	6a 00                	push   $0x0
  pushl $204
80105b33:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80105b38:	e9 a3 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b3d <vector205>:
.globl vector205
vector205:
  pushl $0
80105b3d:	6a 00                	push   $0x0
  pushl $205
80105b3f:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80105b44:	e9 97 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b49 <vector206>:
.globl vector206
vector206:
  pushl $0
80105b49:	6a 00                	push   $0x0
  pushl $206
80105b4b:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80105b50:	e9 8b f3 ff ff       	jmp    80104ee0 <alltraps>

80105b55 <vector207>:
.globl vector207
vector207:
  pushl $0
80105b55:	6a 00                	push   $0x0
  pushl $207
80105b57:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80105b5c:	e9 7f f3 ff ff       	jmp    80104ee0 <alltraps>

80105b61 <vector208>:
.globl vector208
vector208:
  pushl $0
80105b61:	6a 00                	push   $0x0
  pushl $208
80105b63:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80105b68:	e9 73 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b6d <vector209>:
.globl vector209
vector209:
  pushl $0
80105b6d:	6a 00                	push   $0x0
  pushl $209
80105b6f:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80105b74:	e9 67 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b79 <vector210>:
.globl vector210
vector210:
  pushl $0
80105b79:	6a 00                	push   $0x0
  pushl $210
80105b7b:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80105b80:	e9 5b f3 ff ff       	jmp    80104ee0 <alltraps>

80105b85 <vector211>:
.globl vector211
vector211:
  pushl $0
80105b85:	6a 00                	push   $0x0
  pushl $211
80105b87:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80105b8c:	e9 4f f3 ff ff       	jmp    80104ee0 <alltraps>

80105b91 <vector212>:
.globl vector212
vector212:
  pushl $0
80105b91:	6a 00                	push   $0x0
  pushl $212
80105b93:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80105b98:	e9 43 f3 ff ff       	jmp    80104ee0 <alltraps>

80105b9d <vector213>:
.globl vector213
vector213:
  pushl $0
80105b9d:	6a 00                	push   $0x0
  pushl $213
80105b9f:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80105ba4:	e9 37 f3 ff ff       	jmp    80104ee0 <alltraps>

80105ba9 <vector214>:
.globl vector214
vector214:
  pushl $0
80105ba9:	6a 00                	push   $0x0
  pushl $214
80105bab:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80105bb0:	e9 2b f3 ff ff       	jmp    80104ee0 <alltraps>

80105bb5 <vector215>:
.globl vector215
vector215:
  pushl $0
80105bb5:	6a 00                	push   $0x0
  pushl $215
80105bb7:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80105bbc:	e9 1f f3 ff ff       	jmp    80104ee0 <alltraps>

80105bc1 <vector216>:
.globl vector216
vector216:
  pushl $0
80105bc1:	6a 00                	push   $0x0
  pushl $216
80105bc3:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80105bc8:	e9 13 f3 ff ff       	jmp    80104ee0 <alltraps>

80105bcd <vector217>:
.globl vector217
vector217:
  pushl $0
80105bcd:	6a 00                	push   $0x0
  pushl $217
80105bcf:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80105bd4:	e9 07 f3 ff ff       	jmp    80104ee0 <alltraps>

80105bd9 <vector218>:
.globl vector218
vector218:
  pushl $0
80105bd9:	6a 00                	push   $0x0
  pushl $218
80105bdb:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80105be0:	e9 fb f2 ff ff       	jmp    80104ee0 <alltraps>

80105be5 <vector219>:
.globl vector219
vector219:
  pushl $0
80105be5:	6a 00                	push   $0x0
  pushl $219
80105be7:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80105bec:	e9 ef f2 ff ff       	jmp    80104ee0 <alltraps>

80105bf1 <vector220>:
.globl vector220
vector220:
  pushl $0
80105bf1:	6a 00                	push   $0x0
  pushl $220
80105bf3:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80105bf8:	e9 e3 f2 ff ff       	jmp    80104ee0 <alltraps>

80105bfd <vector221>:
.globl vector221
vector221:
  pushl $0
80105bfd:	6a 00                	push   $0x0
  pushl $221
80105bff:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80105c04:	e9 d7 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c09 <vector222>:
.globl vector222
vector222:
  pushl $0
80105c09:	6a 00                	push   $0x0
  pushl $222
80105c0b:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80105c10:	e9 cb f2 ff ff       	jmp    80104ee0 <alltraps>

80105c15 <vector223>:
.globl vector223
vector223:
  pushl $0
80105c15:	6a 00                	push   $0x0
  pushl $223
80105c17:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80105c1c:	e9 bf f2 ff ff       	jmp    80104ee0 <alltraps>

80105c21 <vector224>:
.globl vector224
vector224:
  pushl $0
80105c21:	6a 00                	push   $0x0
  pushl $224
80105c23:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80105c28:	e9 b3 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c2d <vector225>:
.globl vector225
vector225:
  pushl $0
80105c2d:	6a 00                	push   $0x0
  pushl $225
80105c2f:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80105c34:	e9 a7 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c39 <vector226>:
.globl vector226
vector226:
  pushl $0
80105c39:	6a 00                	push   $0x0
  pushl $226
80105c3b:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80105c40:	e9 9b f2 ff ff       	jmp    80104ee0 <alltraps>

80105c45 <vector227>:
.globl vector227
vector227:
  pushl $0
80105c45:	6a 00                	push   $0x0
  pushl $227
80105c47:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80105c4c:	e9 8f f2 ff ff       	jmp    80104ee0 <alltraps>

80105c51 <vector228>:
.globl vector228
vector228:
  pushl $0
80105c51:	6a 00                	push   $0x0
  pushl $228
80105c53:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80105c58:	e9 83 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c5d <vector229>:
.globl vector229
vector229:
  pushl $0
80105c5d:	6a 00                	push   $0x0
  pushl $229
80105c5f:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80105c64:	e9 77 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c69 <vector230>:
.globl vector230
vector230:
  pushl $0
80105c69:	6a 00                	push   $0x0
  pushl $230
80105c6b:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80105c70:	e9 6b f2 ff ff       	jmp    80104ee0 <alltraps>

80105c75 <vector231>:
.globl vector231
vector231:
  pushl $0
80105c75:	6a 00                	push   $0x0
  pushl $231
80105c77:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80105c7c:	e9 5f f2 ff ff       	jmp    80104ee0 <alltraps>

80105c81 <vector232>:
.globl vector232
vector232:
  pushl $0
80105c81:	6a 00                	push   $0x0
  pushl $232
80105c83:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80105c88:	e9 53 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c8d <vector233>:
.globl vector233
vector233:
  pushl $0
80105c8d:	6a 00                	push   $0x0
  pushl $233
80105c8f:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80105c94:	e9 47 f2 ff ff       	jmp    80104ee0 <alltraps>

80105c99 <vector234>:
.globl vector234
vector234:
  pushl $0
80105c99:	6a 00                	push   $0x0
  pushl $234
80105c9b:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80105ca0:	e9 3b f2 ff ff       	jmp    80104ee0 <alltraps>

80105ca5 <vector235>:
.globl vector235
vector235:
  pushl $0
80105ca5:	6a 00                	push   $0x0
  pushl $235
80105ca7:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80105cac:	e9 2f f2 ff ff       	jmp    80104ee0 <alltraps>

80105cb1 <vector236>:
.globl vector236
vector236:
  pushl $0
80105cb1:	6a 00                	push   $0x0
  pushl $236
80105cb3:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80105cb8:	e9 23 f2 ff ff       	jmp    80104ee0 <alltraps>

80105cbd <vector237>:
.globl vector237
vector237:
  pushl $0
80105cbd:	6a 00                	push   $0x0
  pushl $237
80105cbf:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80105cc4:	e9 17 f2 ff ff       	jmp    80104ee0 <alltraps>

80105cc9 <vector238>:
.globl vector238
vector238:
  pushl $0
80105cc9:	6a 00                	push   $0x0
  pushl $238
80105ccb:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80105cd0:	e9 0b f2 ff ff       	jmp    80104ee0 <alltraps>

80105cd5 <vector239>:
.globl vector239
vector239:
  pushl $0
80105cd5:	6a 00                	push   $0x0
  pushl $239
80105cd7:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80105cdc:	e9 ff f1 ff ff       	jmp    80104ee0 <alltraps>

80105ce1 <vector240>:
.globl vector240
vector240:
  pushl $0
80105ce1:	6a 00                	push   $0x0
  pushl $240
80105ce3:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80105ce8:	e9 f3 f1 ff ff       	jmp    80104ee0 <alltraps>

80105ced <vector241>:
.globl vector241
vector241:
  pushl $0
80105ced:	6a 00                	push   $0x0
  pushl $241
80105cef:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80105cf4:	e9 e7 f1 ff ff       	jmp    80104ee0 <alltraps>

80105cf9 <vector242>:
.globl vector242
vector242:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $242
80105cfb:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80105d00:	e9 db f1 ff ff       	jmp    80104ee0 <alltraps>

80105d05 <vector243>:
.globl vector243
vector243:
  pushl $0
80105d05:	6a 00                	push   $0x0
  pushl $243
80105d07:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80105d0c:	e9 cf f1 ff ff       	jmp    80104ee0 <alltraps>

80105d11 <vector244>:
.globl vector244
vector244:
  pushl $0
80105d11:	6a 00                	push   $0x0
  pushl $244
80105d13:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80105d18:	e9 c3 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d1d <vector245>:
.globl vector245
vector245:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $245
80105d1f:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80105d24:	e9 b7 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d29 <vector246>:
.globl vector246
vector246:
  pushl $0
80105d29:	6a 00                	push   $0x0
  pushl $246
80105d2b:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80105d30:	e9 ab f1 ff ff       	jmp    80104ee0 <alltraps>

80105d35 <vector247>:
.globl vector247
vector247:
  pushl $0
80105d35:	6a 00                	push   $0x0
  pushl $247
80105d37:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80105d3c:	e9 9f f1 ff ff       	jmp    80104ee0 <alltraps>

80105d41 <vector248>:
.globl vector248
vector248:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $248
80105d43:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80105d48:	e9 93 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d4d <vector249>:
.globl vector249
vector249:
  pushl $0
80105d4d:	6a 00                	push   $0x0
  pushl $249
80105d4f:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80105d54:	e9 87 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d59 <vector250>:
.globl vector250
vector250:
  pushl $0
80105d59:	6a 00                	push   $0x0
  pushl $250
80105d5b:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80105d60:	e9 7b f1 ff ff       	jmp    80104ee0 <alltraps>

80105d65 <vector251>:
.globl vector251
vector251:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $251
80105d67:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80105d6c:	e9 6f f1 ff ff       	jmp    80104ee0 <alltraps>

80105d71 <vector252>:
.globl vector252
vector252:
  pushl $0
80105d71:	6a 00                	push   $0x0
  pushl $252
80105d73:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80105d78:	e9 63 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d7d <vector253>:
.globl vector253
vector253:
  pushl $0
80105d7d:	6a 00                	push   $0x0
  pushl $253
80105d7f:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80105d84:	e9 57 f1 ff ff       	jmp    80104ee0 <alltraps>

80105d89 <vector254>:
.globl vector254
vector254:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $254
80105d8b:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80105d90:	e9 4b f1 ff ff       	jmp    80104ee0 <alltraps>

80105d95 <vector255>:
.globl vector255
vector255:
  pushl $0
80105d95:	6a 00                	push   $0x0
  pushl $255
80105d97:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80105d9c:	e9 3f f1 ff ff       	jmp    80104ee0 <alltraps>

80105da1 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80105da1:	55                   	push   %ebp
80105da2:	89 e5                	mov    %esp,%ebp
80105da4:	57                   	push   %edi
80105da5:	56                   	push   %esi
80105da6:	53                   	push   %ebx
80105da7:	83 ec 0c             	sub    $0xc,%esp
80105daa:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80105dac:	c1 ea 16             	shr    $0x16,%edx
80105daf:	8d 3c 90             	lea    (%eax,%edx,4),%edi
  if(*pde & PTE_P){
80105db2:	8b 37                	mov    (%edi),%esi
80105db4:	f7 c6 01 00 00 00    	test   $0x1,%esi
80105dba:	74 20                	je     80105ddc <walkpgdir+0x3b>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80105dbc:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
80105dc2:	81 c6 00 00 00 80    	add    $0x80000000,%esi
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80105dc8:	c1 eb 0c             	shr    $0xc,%ebx
80105dcb:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
80105dd1:	8d 04 9e             	lea    (%esi,%ebx,4),%eax
}
80105dd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105dd7:	5b                   	pop    %ebx
80105dd8:	5e                   	pop    %esi
80105dd9:	5f                   	pop    %edi
80105dda:	5d                   	pop    %ebp
80105ddb:	c3                   	ret    
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80105ddc:	85 c9                	test   %ecx,%ecx
80105dde:	74 2b                	je     80105e0b <walkpgdir+0x6a>
80105de0:	e8 6d c3 ff ff       	call   80102152 <kalloc>
80105de5:	89 c6                	mov    %eax,%esi
80105de7:	85 c0                	test   %eax,%eax
80105de9:	74 20                	je     80105e0b <walkpgdir+0x6a>
    memset(pgtab, 0, PGSIZE);
80105deb:	83 ec 04             	sub    $0x4,%esp
80105dee:	68 00 10 00 00       	push   $0x1000
80105df3:	6a 00                	push   $0x0
80105df5:	50                   	push   %eax
80105df6:	e8 88 df ff ff       	call   80103d83 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80105dfb:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80105e01:	83 c8 07             	or     $0x7,%eax
80105e04:	89 07                	mov    %eax,(%edi)
80105e06:	83 c4 10             	add    $0x10,%esp
80105e09:	eb bd                	jmp    80105dc8 <walkpgdir+0x27>
      return 0;
80105e0b:	b8 00 00 00 00       	mov    $0x0,%eax
80105e10:	eb c2                	jmp    80105dd4 <walkpgdir+0x33>

80105e12 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80105e12:	55                   	push   %ebp
80105e13:	89 e5                	mov    %esp,%ebp
80105e15:	57                   	push   %edi
80105e16:	56                   	push   %esi
80105e17:	53                   	push   %ebx
80105e18:	83 ec 1c             	sub    $0x1c,%esp
80105e1b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80105e1e:	8b 75 08             	mov    0x8(%ebp),%esi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80105e21:	89 d3                	mov    %edx,%ebx
80105e23:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80105e29:	8d 7c 0a ff          	lea    -0x1(%edx,%ecx,1),%edi
80105e2d:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e33:	b9 01 00 00 00       	mov    $0x1,%ecx
80105e38:	89 da                	mov    %ebx,%edx
80105e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80105e3d:	e8 5f ff ff ff       	call   80105da1 <walkpgdir>
80105e42:	85 c0                	test   %eax,%eax
80105e44:	74 2e                	je     80105e74 <mappages+0x62>
      return -1;
    if(*pte & PTE_P)
80105e46:	f6 00 01             	testb  $0x1,(%eax)
80105e49:	75 1c                	jne    80105e67 <mappages+0x55>
      panic("remap");
    *pte = pa | perm | PTE_P;
80105e4b:	89 f2                	mov    %esi,%edx
80105e4d:	0b 55 0c             	or     0xc(%ebp),%edx
80105e50:	83 ca 01             	or     $0x1,%edx
80105e53:	89 10                	mov    %edx,(%eax)
    if(a == last)
80105e55:	39 fb                	cmp    %edi,%ebx
80105e57:	74 28                	je     80105e81 <mappages+0x6f>
      break;
    a += PGSIZE;
80105e59:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    pa += PGSIZE;
80105e5f:	81 c6 00 10 00 00    	add    $0x1000,%esi
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80105e65:	eb cc                	jmp    80105e33 <mappages+0x21>
      panic("remap");
80105e67:	83 ec 0c             	sub    $0xc,%esp
80105e6a:	68 2c 6f 10 80       	push   $0x80106f2c
80105e6f:	e8 e8 a4 ff ff       	call   8010035c <panic>
      return -1;
80105e74:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80105e79:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105e7c:	5b                   	pop    %ebx
80105e7d:	5e                   	pop    %esi
80105e7e:	5f                   	pop    %edi
80105e7f:	5d                   	pop    %ebp
80105e80:	c3                   	ret    
  return 0;
80105e81:	b8 00 00 00 00       	mov    $0x0,%eax
80105e86:	eb f1                	jmp    80105e79 <mappages+0x67>

80105e88 <seginit>:
{
80105e88:	f3 0f 1e fb          	endbr32 
80105e8c:	55                   	push   %ebp
80105e8d:	89 e5                	mov    %esp,%ebp
80105e8f:	53                   	push   %ebx
80105e90:	83 ec 14             	sub    $0x14,%esp
  c = &cpus[cpuid()];
80105e93:	e8 14 d4 ff ff       	call   801032ac <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80105e98:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80105e9e:	66 c7 80 f8 27 11 80 	movw   $0xffff,-0x7feed808(%eax)
80105ea5:	ff ff 
80105ea7:	66 c7 80 fa 27 11 80 	movw   $0x0,-0x7feed806(%eax)
80105eae:	00 00 
80105eb0:	c6 80 fc 27 11 80 00 	movb   $0x0,-0x7feed804(%eax)
80105eb7:	0f b6 88 fd 27 11 80 	movzbl -0x7feed803(%eax),%ecx
80105ebe:	83 e1 f0             	and    $0xfffffff0,%ecx
80105ec1:	83 c9 1a             	or     $0x1a,%ecx
80105ec4:	83 e1 9f             	and    $0xffffff9f,%ecx
80105ec7:	83 c9 80             	or     $0xffffff80,%ecx
80105eca:	88 88 fd 27 11 80    	mov    %cl,-0x7feed803(%eax)
80105ed0:	0f b6 88 fe 27 11 80 	movzbl -0x7feed802(%eax),%ecx
80105ed7:	83 c9 0f             	or     $0xf,%ecx
80105eda:	83 e1 cf             	and    $0xffffffcf,%ecx
80105edd:	83 c9 c0             	or     $0xffffffc0,%ecx
80105ee0:	88 88 fe 27 11 80    	mov    %cl,-0x7feed802(%eax)
80105ee6:	c6 80 ff 27 11 80 00 	movb   $0x0,-0x7feed801(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80105eed:	66 c7 80 00 28 11 80 	movw   $0xffff,-0x7feed800(%eax)
80105ef4:	ff ff 
80105ef6:	66 c7 80 02 28 11 80 	movw   $0x0,-0x7feed7fe(%eax)
80105efd:	00 00 
80105eff:	c6 80 04 28 11 80 00 	movb   $0x0,-0x7feed7fc(%eax)
80105f06:	0f b6 88 05 28 11 80 	movzbl -0x7feed7fb(%eax),%ecx
80105f0d:	83 e1 f0             	and    $0xfffffff0,%ecx
80105f10:	83 c9 12             	or     $0x12,%ecx
80105f13:	83 e1 9f             	and    $0xffffff9f,%ecx
80105f16:	83 c9 80             	or     $0xffffff80,%ecx
80105f19:	88 88 05 28 11 80    	mov    %cl,-0x7feed7fb(%eax)
80105f1f:	0f b6 88 06 28 11 80 	movzbl -0x7feed7fa(%eax),%ecx
80105f26:	83 c9 0f             	or     $0xf,%ecx
80105f29:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f2c:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f2f:	88 88 06 28 11 80    	mov    %cl,-0x7feed7fa(%eax)
80105f35:	c6 80 07 28 11 80 00 	movb   $0x0,-0x7feed7f9(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80105f3c:	66 c7 80 08 28 11 80 	movw   $0xffff,-0x7feed7f8(%eax)
80105f43:	ff ff 
80105f45:	66 c7 80 0a 28 11 80 	movw   $0x0,-0x7feed7f6(%eax)
80105f4c:	00 00 
80105f4e:	c6 80 0c 28 11 80 00 	movb   $0x0,-0x7feed7f4(%eax)
80105f55:	c6 80 0d 28 11 80 fa 	movb   $0xfa,-0x7feed7f3(%eax)
80105f5c:	0f b6 88 0e 28 11 80 	movzbl -0x7feed7f2(%eax),%ecx
80105f63:	83 c9 0f             	or     $0xf,%ecx
80105f66:	83 e1 cf             	and    $0xffffffcf,%ecx
80105f69:	83 c9 c0             	or     $0xffffffc0,%ecx
80105f6c:	88 88 0e 28 11 80    	mov    %cl,-0x7feed7f2(%eax)
80105f72:	c6 80 0f 28 11 80 00 	movb   $0x0,-0x7feed7f1(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80105f79:	66 c7 80 10 28 11 80 	movw   $0xffff,-0x7feed7f0(%eax)
80105f80:	ff ff 
80105f82:	66 c7 80 12 28 11 80 	movw   $0x0,-0x7feed7ee(%eax)
80105f89:	00 00 
80105f8b:	c6 80 14 28 11 80 00 	movb   $0x0,-0x7feed7ec(%eax)
80105f92:	c6 80 15 28 11 80 f2 	movb   $0xf2,-0x7feed7eb(%eax)
80105f99:	0f b6 88 16 28 11 80 	movzbl -0x7feed7ea(%eax),%ecx
80105fa0:	83 c9 0f             	or     $0xf,%ecx
80105fa3:	83 e1 cf             	and    $0xffffffcf,%ecx
80105fa6:	83 c9 c0             	or     $0xffffffc0,%ecx
80105fa9:	88 88 16 28 11 80    	mov    %cl,-0x7feed7ea(%eax)
80105faf:	c6 80 17 28 11 80 00 	movb   $0x0,-0x7feed7e9(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
80105fb6:	05 f0 27 11 80       	add    $0x801127f0,%eax
  pd[0] = size-1;
80105fbb:	66 c7 45 f2 2f 00    	movw   $0x2f,-0xe(%ebp)
  pd[1] = (uint)p;
80105fc1:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80105fc5:	c1 e8 10             	shr    $0x10,%eax
80105fc8:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80105fcc:	8d 45 f2             	lea    -0xe(%ebp),%eax
80105fcf:	0f 01 10             	lgdtl  (%eax)
}
80105fd2:	83 c4 14             	add    $0x14,%esp
80105fd5:	5b                   	pop    %ebx
80105fd6:	5d                   	pop    %ebp
80105fd7:	c3                   	ret    

80105fd8 <switchkvm>:

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80105fd8:	f3 0f 1e fb          	endbr32 
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80105fdc:	a1 a4 56 11 80       	mov    0x801156a4,%eax
80105fe1:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80105fe6:	0f 22 d8             	mov    %eax,%cr3
}
80105fe9:	c3                   	ret    

80105fea <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
80105fea:	f3 0f 1e fb          	endbr32 
80105fee:	55                   	push   %ebp
80105fef:	89 e5                	mov    %esp,%ebp
80105ff1:	57                   	push   %edi
80105ff2:	56                   	push   %esi
80105ff3:	53                   	push   %ebx
80105ff4:	83 ec 1c             	sub    $0x1c,%esp
80105ff7:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80105ffa:	85 f6                	test   %esi,%esi
80105ffc:	0f 84 dd 00 00 00    	je     801060df <switchuvm+0xf5>
    panic("switchuvm: no process");
  if(p->kstack == 0)
80106002:	83 7e 08 00          	cmpl   $0x0,0x8(%esi)
80106006:	0f 84 e0 00 00 00    	je     801060ec <switchuvm+0x102>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
8010600c:	83 7e 04 00          	cmpl   $0x0,0x4(%esi)
80106010:	0f 84 e3 00 00 00    	je     801060f9 <switchuvm+0x10f>
    panic("switchuvm: no pgdir");

  pushcli();
80106016:	e8 cb db ff ff       	call   80103be6 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
8010601b:	e8 2c d2 ff ff       	call   8010324c <mycpu>
80106020:	89 c3                	mov    %eax,%ebx
80106022:	e8 25 d2 ff ff       	call   8010324c <mycpu>
80106027:	8d 78 08             	lea    0x8(%eax),%edi
8010602a:	e8 1d d2 ff ff       	call   8010324c <mycpu>
8010602f:	83 c0 08             	add    $0x8,%eax
80106032:	c1 e8 10             	shr    $0x10,%eax
80106035:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106038:	e8 0f d2 ff ff       	call   8010324c <mycpu>
8010603d:	83 c0 08             	add    $0x8,%eax
80106040:	c1 e8 18             	shr    $0x18,%eax
80106043:	66 c7 83 98 00 00 00 	movw   $0x67,0x98(%ebx)
8010604a:	67 00 
8010604c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106053:	0f b6 4d e4          	movzbl -0x1c(%ebp),%ecx
80106057:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
8010605d:	0f b6 93 9d 00 00 00 	movzbl 0x9d(%ebx),%edx
80106064:	83 e2 f0             	and    $0xfffffff0,%edx
80106067:	83 ca 19             	or     $0x19,%edx
8010606a:	83 e2 9f             	and    $0xffffff9f,%edx
8010606d:	83 ca 80             	or     $0xffffff80,%edx
80106070:	88 93 9d 00 00 00    	mov    %dl,0x9d(%ebx)
80106076:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
8010607d:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106083:	e8 c4 d1 ff ff       	call   8010324c <mycpu>
80106088:	0f b6 90 9d 00 00 00 	movzbl 0x9d(%eax),%edx
8010608f:	83 e2 ef             	and    $0xffffffef,%edx
80106092:	88 90 9d 00 00 00    	mov    %dl,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106098:	e8 af d1 ff ff       	call   8010324c <mycpu>
8010609d:	66 c7 40 10 10 00    	movw   $0x10,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
801060a3:	8b 5e 08             	mov    0x8(%esi),%ebx
801060a6:	e8 a1 d1 ff ff       	call   8010324c <mycpu>
801060ab:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801060b1:	89 58 0c             	mov    %ebx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
801060b4:	e8 93 d1 ff ff       	call   8010324c <mycpu>
801060b9:	66 c7 40 6e ff ff    	movw   $0xffff,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
801060bf:	b8 28 00 00 00       	mov    $0x28,%eax
801060c4:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
801060c7:	8b 46 04             	mov    0x4(%esi),%eax
801060ca:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
801060cf:	0f 22 d8             	mov    %eax,%cr3
  popcli();
801060d2:	e8 50 db ff ff       	call   80103c27 <popcli>
}
801060d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801060da:	5b                   	pop    %ebx
801060db:	5e                   	pop    %esi
801060dc:	5f                   	pop    %edi
801060dd:	5d                   	pop    %ebp
801060de:	c3                   	ret    
    panic("switchuvm: no process");
801060df:	83 ec 0c             	sub    $0xc,%esp
801060e2:	68 32 6f 10 80       	push   $0x80106f32
801060e7:	e8 70 a2 ff ff       	call   8010035c <panic>
    panic("switchuvm: no kstack");
801060ec:	83 ec 0c             	sub    $0xc,%esp
801060ef:	68 48 6f 10 80       	push   $0x80106f48
801060f4:	e8 63 a2 ff ff       	call   8010035c <panic>
    panic("switchuvm: no pgdir");
801060f9:	83 ec 0c             	sub    $0xc,%esp
801060fc:	68 5d 6f 10 80       	push   $0x80106f5d
80106101:	e8 56 a2 ff ff       	call   8010035c <panic>

80106106 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106106:	f3 0f 1e fb          	endbr32 
8010610a:	55                   	push   %ebp
8010610b:	89 e5                	mov    %esp,%ebp
8010610d:	56                   	push   %esi
8010610e:	53                   	push   %ebx
8010610f:	8b 75 10             	mov    0x10(%ebp),%esi
  char *mem;

  if(sz >= PGSIZE)
80106112:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106118:	77 4c                	ja     80106166 <inituvm+0x60>
    panic("inituvm: more than a page");
  mem = kalloc();
8010611a:	e8 33 c0 ff ff       	call   80102152 <kalloc>
8010611f:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106121:	83 ec 04             	sub    $0x4,%esp
80106124:	68 00 10 00 00       	push   $0x1000
80106129:	6a 00                	push   $0x0
8010612b:	50                   	push   %eax
8010612c:	e8 52 dc ff ff       	call   80103d83 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106131:	83 c4 08             	add    $0x8,%esp
80106134:	6a 06                	push   $0x6
80106136:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010613c:	50                   	push   %eax
8010613d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106142:	ba 00 00 00 00       	mov    $0x0,%edx
80106147:	8b 45 08             	mov    0x8(%ebp),%eax
8010614a:	e8 c3 fc ff ff       	call   80105e12 <mappages>
  memmove(mem, init, sz);
8010614f:	83 c4 0c             	add    $0xc,%esp
80106152:	56                   	push   %esi
80106153:	ff 75 0c             	pushl  0xc(%ebp)
80106156:	53                   	push   %ebx
80106157:	e8 a7 dc ff ff       	call   80103e03 <memmove>
}
8010615c:	83 c4 10             	add    $0x10,%esp
8010615f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106162:	5b                   	pop    %ebx
80106163:	5e                   	pop    %esi
80106164:	5d                   	pop    %ebp
80106165:	c3                   	ret    
    panic("inituvm: more than a page");
80106166:	83 ec 0c             	sub    $0xc,%esp
80106169:	68 71 6f 10 80       	push   $0x80106f71
8010616e:	e8 e9 a1 ff ff       	call   8010035c <panic>

80106173 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106173:	f3 0f 1e fb          	endbr32 
80106177:	55                   	push   %ebp
80106178:	89 e5                	mov    %esp,%ebp
8010617a:	57                   	push   %edi
8010617b:	56                   	push   %esi
8010617c:	53                   	push   %ebx
8010617d:	83 ec 0c             	sub    $0xc,%esp
80106180:	8b 7d 18             	mov    0x18(%ebp),%edi
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106183:	8b 5d 0c             	mov    0xc(%ebp),%ebx
80106186:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
8010618c:	74 3c                	je     801061ca <loaduvm+0x57>
    panic("loaduvm: addr must be page aligned");
8010618e:	83 ec 0c             	sub    $0xc,%esp
80106191:	68 2c 70 10 80       	push   $0x8010702c
80106196:	e8 c1 a1 ff ff       	call   8010035c <panic>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
8010619b:	83 ec 0c             	sub    $0xc,%esp
8010619e:	68 8b 6f 10 80       	push   $0x80106f8b
801061a3:	e8 b4 a1 ff ff       	call   8010035c <panic>
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
801061a8:	05 00 00 00 80       	add    $0x80000000,%eax
801061ad:	56                   	push   %esi
801061ae:	89 da                	mov    %ebx,%edx
801061b0:	03 55 14             	add    0x14(%ebp),%edx
801061b3:	52                   	push   %edx
801061b4:	50                   	push   %eax
801061b5:	ff 75 10             	pushl  0x10(%ebp)
801061b8:	e8 13 b6 ff ff       	call   801017d0 <readi>
801061bd:	83 c4 10             	add    $0x10,%esp
801061c0:	39 f0                	cmp    %esi,%eax
801061c2:	75 47                	jne    8010620b <loaduvm+0x98>
  for(i = 0; i < sz; i += PGSIZE){
801061c4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801061ca:	39 fb                	cmp    %edi,%ebx
801061cc:	73 30                	jae    801061fe <loaduvm+0x8b>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
801061ce:	89 da                	mov    %ebx,%edx
801061d0:	03 55 0c             	add    0xc(%ebp),%edx
801061d3:	b9 00 00 00 00       	mov    $0x0,%ecx
801061d8:	8b 45 08             	mov    0x8(%ebp),%eax
801061db:	e8 c1 fb ff ff       	call   80105da1 <walkpgdir>
801061e0:	85 c0                	test   %eax,%eax
801061e2:	74 b7                	je     8010619b <loaduvm+0x28>
    pa = PTE_ADDR(*pte);
801061e4:	8b 00                	mov    (%eax),%eax
801061e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
801061eb:	89 fe                	mov    %edi,%esi
801061ed:	29 de                	sub    %ebx,%esi
801061ef:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
801061f5:	76 b1                	jbe    801061a8 <loaduvm+0x35>
      n = PGSIZE;
801061f7:	be 00 10 00 00       	mov    $0x1000,%esi
801061fc:	eb aa                	jmp    801061a8 <loaduvm+0x35>
      return -1;
  }
  return 0;
801061fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
80106203:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106206:	5b                   	pop    %ebx
80106207:	5e                   	pop    %esi
80106208:	5f                   	pop    %edi
80106209:	5d                   	pop    %ebp
8010620a:	c3                   	ret    
      return -1;
8010620b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80106210:	eb f1                	jmp    80106203 <loaduvm+0x90>

80106212 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106212:	f3 0f 1e fb          	endbr32 
80106216:	55                   	push   %ebp
80106217:	89 e5                	mov    %esp,%ebp
80106219:	57                   	push   %edi
8010621a:	56                   	push   %esi
8010621b:	53                   	push   %ebx
8010621c:	83 ec 0c             	sub    $0xc,%esp
8010621f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106222:	39 7d 10             	cmp    %edi,0x10(%ebp)
80106225:	73 11                	jae    80106238 <deallocuvm+0x26>
    return oldsz;

  a = PGROUNDUP(newsz);
80106227:	8b 45 10             	mov    0x10(%ebp),%eax
8010622a:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106230:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106236:	eb 19                	jmp    80106251 <deallocuvm+0x3f>
    return oldsz;
80106238:	89 f8                	mov    %edi,%eax
8010623a:	eb 64                	jmp    801062a0 <deallocuvm+0x8e>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010623c:	c1 eb 16             	shr    $0x16,%ebx
8010623f:	83 c3 01             	add    $0x1,%ebx
80106242:	c1 e3 16             	shl    $0x16,%ebx
80106245:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
  for(; a  < oldsz; a += PGSIZE){
8010624b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106251:	39 fb                	cmp    %edi,%ebx
80106253:	73 48                	jae    8010629d <deallocuvm+0x8b>
    pte = walkpgdir(pgdir, (char*)a, 0);
80106255:	b9 00 00 00 00       	mov    $0x0,%ecx
8010625a:	89 da                	mov    %ebx,%edx
8010625c:	8b 45 08             	mov    0x8(%ebp),%eax
8010625f:	e8 3d fb ff ff       	call   80105da1 <walkpgdir>
80106264:	89 c6                	mov    %eax,%esi
    if(!pte)
80106266:	85 c0                	test   %eax,%eax
80106268:	74 d2                	je     8010623c <deallocuvm+0x2a>
    else if((*pte & PTE_P) != 0){
8010626a:	8b 00                	mov    (%eax),%eax
8010626c:	a8 01                	test   $0x1,%al
8010626e:	74 db                	je     8010624b <deallocuvm+0x39>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
80106270:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106275:	74 19                	je     80106290 <deallocuvm+0x7e>
        panic("kfree");
      char *v = P2V(pa);
80106277:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010627c:	83 ec 0c             	sub    $0xc,%esp
8010627f:	50                   	push   %eax
80106280:	e8 a6 bd ff ff       	call   8010202b <kfree>
      *pte = 0;
80106285:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
8010628b:	83 c4 10             	add    $0x10,%esp
8010628e:	eb bb                	jmp    8010624b <deallocuvm+0x39>
        panic("kfree");
80106290:	83 ec 0c             	sub    $0xc,%esp
80106293:	68 e6 68 10 80       	push   $0x801068e6
80106298:	e8 bf a0 ff ff       	call   8010035c <panic>
    }
  }
  return newsz;
8010629d:	8b 45 10             	mov    0x10(%ebp),%eax
}
801062a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
801062a3:	5b                   	pop    %ebx
801062a4:	5e                   	pop    %esi
801062a5:	5f                   	pop    %edi
801062a6:	5d                   	pop    %ebp
801062a7:	c3                   	ret    

801062a8 <allocuvm>:
{
801062a8:	f3 0f 1e fb          	endbr32 
801062ac:	55                   	push   %ebp
801062ad:	89 e5                	mov    %esp,%ebp
801062af:	57                   	push   %edi
801062b0:	56                   	push   %esi
801062b1:	53                   	push   %ebx
801062b2:	83 ec 1c             	sub    $0x1c,%esp
801062b5:	8b 7d 10             	mov    0x10(%ebp),%edi
  if(newsz >= KERNBASE)
801062b8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801062bb:	85 ff                	test   %edi,%edi
801062bd:	0f 88 c0 00 00 00    	js     80106383 <allocuvm+0xdb>
  if(newsz < oldsz)
801062c3:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801062c6:	72 11                	jb     801062d9 <allocuvm+0x31>
  a = PGROUNDUP(oldsz);
801062c8:	8b 45 0c             	mov    0xc(%ebp),%eax
801062cb:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
801062d1:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
801062d7:	eb 39                	jmp    80106312 <allocuvm+0x6a>
    return oldsz;
801062d9:	8b 45 0c             	mov    0xc(%ebp),%eax
801062dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801062df:	e9 a6 00 00 00       	jmp    8010638a <allocuvm+0xe2>
      cprintf("allocuvm out of memory\n");
801062e4:	83 ec 0c             	sub    $0xc,%esp
801062e7:	68 a9 6f 10 80       	push   $0x80106fa9
801062ec:	e8 38 a3 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
801062f1:	83 c4 0c             	add    $0xc,%esp
801062f4:	ff 75 0c             	pushl  0xc(%ebp)
801062f7:	57                   	push   %edi
801062f8:	ff 75 08             	pushl  0x8(%ebp)
801062fb:	e8 12 ff ff ff       	call   80106212 <deallocuvm>
      return 0;
80106300:	83 c4 10             	add    $0x10,%esp
80106303:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
8010630a:	eb 7e                	jmp    8010638a <allocuvm+0xe2>
  for(; a < newsz; a += PGSIZE){
8010630c:	81 c6 00 10 00 00    	add    $0x1000,%esi
80106312:	39 fe                	cmp    %edi,%esi
80106314:	73 74                	jae    8010638a <allocuvm+0xe2>
    mem = kalloc();
80106316:	e8 37 be ff ff       	call   80102152 <kalloc>
8010631b:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
8010631d:	85 c0                	test   %eax,%eax
8010631f:	74 c3                	je     801062e4 <allocuvm+0x3c>
    memset(mem, 0, PGSIZE);
80106321:	83 ec 04             	sub    $0x4,%esp
80106324:	68 00 10 00 00       	push   $0x1000
80106329:	6a 00                	push   $0x0
8010632b:	50                   	push   %eax
8010632c:	e8 52 da ff ff       	call   80103d83 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106331:	83 c4 08             	add    $0x8,%esp
80106334:	6a 06                	push   $0x6
80106336:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010633c:	50                   	push   %eax
8010633d:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106342:	89 f2                	mov    %esi,%edx
80106344:	8b 45 08             	mov    0x8(%ebp),%eax
80106347:	e8 c6 fa ff ff       	call   80105e12 <mappages>
8010634c:	83 c4 10             	add    $0x10,%esp
8010634f:	85 c0                	test   %eax,%eax
80106351:	79 b9                	jns    8010630c <allocuvm+0x64>
      cprintf("allocuvm out of memory (2)\n");
80106353:	83 ec 0c             	sub    $0xc,%esp
80106356:	68 c1 6f 10 80       	push   $0x80106fc1
8010635b:	e8 c9 a2 ff ff       	call   80100629 <cprintf>
      deallocuvm(pgdir, newsz, oldsz);
80106360:	83 c4 0c             	add    $0xc,%esp
80106363:	ff 75 0c             	pushl  0xc(%ebp)
80106366:	57                   	push   %edi
80106367:	ff 75 08             	pushl  0x8(%ebp)
8010636a:	e8 a3 fe ff ff       	call   80106212 <deallocuvm>
      kfree(mem);
8010636f:	89 1c 24             	mov    %ebx,(%esp)
80106372:	e8 b4 bc ff ff       	call   8010202b <kfree>
      return 0;
80106377:	83 c4 10             	add    $0x10,%esp
8010637a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80106381:	eb 07                	jmp    8010638a <allocuvm+0xe2>
    return 0;
80106383:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
8010638a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010638d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106390:	5b                   	pop    %ebx
80106391:	5e                   	pop    %esi
80106392:	5f                   	pop    %edi
80106393:	5d                   	pop    %ebp
80106394:	c3                   	ret    

80106395 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106395:	f3 0f 1e fb          	endbr32 
80106399:	55                   	push   %ebp
8010639a:	89 e5                	mov    %esp,%ebp
8010639c:	56                   	push   %esi
8010639d:	53                   	push   %ebx
8010639e:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
801063a1:	85 f6                	test   %esi,%esi
801063a3:	74 1a                	je     801063bf <freevm+0x2a>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
801063a5:	83 ec 04             	sub    $0x4,%esp
801063a8:	6a 00                	push   $0x0
801063aa:	68 00 00 00 80       	push   $0x80000000
801063af:	56                   	push   %esi
801063b0:	e8 5d fe ff ff       	call   80106212 <deallocuvm>
  for(i = 0; i < NPDENTRIES; i++){
801063b5:	83 c4 10             	add    $0x10,%esp
801063b8:	bb 00 00 00 00       	mov    $0x0,%ebx
801063bd:	eb 26                	jmp    801063e5 <freevm+0x50>
    panic("freevm: no pgdir");
801063bf:	83 ec 0c             	sub    $0xc,%esp
801063c2:	68 dd 6f 10 80       	push   $0x80106fdd
801063c7:	e8 90 9f ff ff       	call   8010035c <panic>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
801063cc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801063d1:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
801063d6:	83 ec 0c             	sub    $0xc,%esp
801063d9:	50                   	push   %eax
801063da:	e8 4c bc ff ff       	call   8010202b <kfree>
801063df:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
801063e2:	83 c3 01             	add    $0x1,%ebx
801063e5:	81 fb ff 03 00 00    	cmp    $0x3ff,%ebx
801063eb:	77 09                	ja     801063f6 <freevm+0x61>
    if(pgdir[i] & PTE_P){
801063ed:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
801063f0:	a8 01                	test   $0x1,%al
801063f2:	74 ee                	je     801063e2 <freevm+0x4d>
801063f4:	eb d6                	jmp    801063cc <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
801063f6:	83 ec 0c             	sub    $0xc,%esp
801063f9:	56                   	push   %esi
801063fa:	e8 2c bc ff ff       	call   8010202b <kfree>
}
801063ff:	83 c4 10             	add    $0x10,%esp
80106402:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106405:	5b                   	pop    %ebx
80106406:	5e                   	pop    %esi
80106407:	5d                   	pop    %ebp
80106408:	c3                   	ret    

80106409 <setupkvm>:
{
80106409:	f3 0f 1e fb          	endbr32 
8010640d:	55                   	push   %ebp
8010640e:	89 e5                	mov    %esp,%ebp
80106410:	56                   	push   %esi
80106411:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
80106412:	e8 3b bd ff ff       	call   80102152 <kalloc>
80106417:	89 c6                	mov    %eax,%esi
80106419:	85 c0                	test   %eax,%eax
8010641b:	74 55                	je     80106472 <setupkvm+0x69>
  memset(pgdir, 0, PGSIZE);
8010641d:	83 ec 04             	sub    $0x4,%esp
80106420:	68 00 10 00 00       	push   $0x1000
80106425:	6a 00                	push   $0x0
80106427:	50                   	push   %eax
80106428:	e8 56 d9 ff ff       	call   80103d83 <memset>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010642d:	83 c4 10             	add    $0x10,%esp
80106430:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
80106435:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
8010643b:	73 35                	jae    80106472 <setupkvm+0x69>
                (uint)k->phys_start, k->perm) < 0) {
8010643d:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106440:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106443:	29 c1                	sub    %eax,%ecx
80106445:	83 ec 08             	sub    $0x8,%esp
80106448:	ff 73 0c             	pushl  0xc(%ebx)
8010644b:	50                   	push   %eax
8010644c:	8b 13                	mov    (%ebx),%edx
8010644e:	89 f0                	mov    %esi,%eax
80106450:	e8 bd f9 ff ff       	call   80105e12 <mappages>
80106455:	83 c4 10             	add    $0x10,%esp
80106458:	85 c0                	test   %eax,%eax
8010645a:	78 05                	js     80106461 <setupkvm+0x58>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
8010645c:	83 c3 10             	add    $0x10,%ebx
8010645f:	eb d4                	jmp    80106435 <setupkvm+0x2c>
      freevm(pgdir);
80106461:	83 ec 0c             	sub    $0xc,%esp
80106464:	56                   	push   %esi
80106465:	e8 2b ff ff ff       	call   80106395 <freevm>
      return 0;
8010646a:	83 c4 10             	add    $0x10,%esp
8010646d:	be 00 00 00 00       	mov    $0x0,%esi
}
80106472:	89 f0                	mov    %esi,%eax
80106474:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106477:	5b                   	pop    %ebx
80106478:	5e                   	pop    %esi
80106479:	5d                   	pop    %ebp
8010647a:	c3                   	ret    

8010647b <kvmalloc>:
{
8010647b:	f3 0f 1e fb          	endbr32 
8010647f:	55                   	push   %ebp
80106480:	89 e5                	mov    %esp,%ebp
80106482:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106485:	e8 7f ff ff ff       	call   80106409 <setupkvm>
8010648a:	a3 a4 56 11 80       	mov    %eax,0x801156a4
  switchkvm();
8010648f:	e8 44 fb ff ff       	call   80105fd8 <switchkvm>
}
80106494:	c9                   	leave  
80106495:	c3                   	ret    

80106496 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106496:	f3 0f 1e fb          	endbr32 
8010649a:	55                   	push   %ebp
8010649b:	89 e5                	mov    %esp,%ebp
8010649d:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801064a0:	b9 00 00 00 00       	mov    $0x0,%ecx
801064a5:	8b 55 0c             	mov    0xc(%ebp),%edx
801064a8:	8b 45 08             	mov    0x8(%ebp),%eax
801064ab:	e8 f1 f8 ff ff       	call   80105da1 <walkpgdir>
  if(pte == 0)
801064b0:	85 c0                	test   %eax,%eax
801064b2:	74 05                	je     801064b9 <clearpteu+0x23>
    panic("clearpteu");
  *pte &= ~PTE_U;
801064b4:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801064b7:	c9                   	leave  
801064b8:	c3                   	ret    
    panic("clearpteu");
801064b9:	83 ec 0c             	sub    $0xc,%esp
801064bc:	68 ee 6f 10 80       	push   $0x80106fee
801064c1:	e8 96 9e ff ff       	call   8010035c <panic>

801064c6 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801064c6:	f3 0f 1e fb          	endbr32 
801064ca:	55                   	push   %ebp
801064cb:	89 e5                	mov    %esp,%ebp
801064cd:	57                   	push   %edi
801064ce:	56                   	push   %esi
801064cf:	53                   	push   %ebx
801064d0:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801064d3:	e8 31 ff ff ff       	call   80106409 <setupkvm>
801064d8:	89 45 dc             	mov    %eax,-0x24(%ebp)
801064db:	85 c0                	test   %eax,%eax
801064dd:	0f 84 c4 00 00 00    	je     801065a7 <copyuvm+0xe1>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801064e3:	bf 00 00 00 00       	mov    $0x0,%edi
801064e8:	3b 7d 0c             	cmp    0xc(%ebp),%edi
801064eb:	0f 83 b6 00 00 00    	jae    801065a7 <copyuvm+0xe1>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
801064f1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801064f4:	b9 00 00 00 00       	mov    $0x0,%ecx
801064f9:	89 fa                	mov    %edi,%edx
801064fb:	8b 45 08             	mov    0x8(%ebp),%eax
801064fe:	e8 9e f8 ff ff       	call   80105da1 <walkpgdir>
80106503:	85 c0                	test   %eax,%eax
80106505:	74 65                	je     8010656c <copyuvm+0xa6>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106507:	8b 00                	mov    (%eax),%eax
80106509:	a8 01                	test   $0x1,%al
8010650b:	74 6c                	je     80106579 <copyuvm+0xb3>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
8010650d:	89 c6                	mov    %eax,%esi
8010650f:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
80106515:	25 ff 0f 00 00       	and    $0xfff,%eax
8010651a:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if((mem = kalloc()) == 0)
8010651d:	e8 30 bc ff ff       	call   80102152 <kalloc>
80106522:	89 c3                	mov    %eax,%ebx
80106524:	85 c0                	test   %eax,%eax
80106526:	74 6a                	je     80106592 <copyuvm+0xcc>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106528:	81 c6 00 00 00 80    	add    $0x80000000,%esi
8010652e:	83 ec 04             	sub    $0x4,%esp
80106531:	68 00 10 00 00       	push   $0x1000
80106536:	56                   	push   %esi
80106537:	50                   	push   %eax
80106538:	e8 c6 d8 ff ff       	call   80103e03 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
8010653d:	83 c4 08             	add    $0x8,%esp
80106540:	ff 75 e0             	pushl  -0x20(%ebp)
80106543:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106549:	50                   	push   %eax
8010654a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010654f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106552:	8b 45 dc             	mov    -0x24(%ebp),%eax
80106555:	e8 b8 f8 ff ff       	call   80105e12 <mappages>
8010655a:	83 c4 10             	add    $0x10,%esp
8010655d:	85 c0                	test   %eax,%eax
8010655f:	78 25                	js     80106586 <copyuvm+0xc0>
  for(i = 0; i < sz; i += PGSIZE){
80106561:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106567:	e9 7c ff ff ff       	jmp    801064e8 <copyuvm+0x22>
      panic("copyuvm: pte should exist");
8010656c:	83 ec 0c             	sub    $0xc,%esp
8010656f:	68 f8 6f 10 80       	push   $0x80106ff8
80106574:	e8 e3 9d ff ff       	call   8010035c <panic>
      panic("copyuvm: page not present");
80106579:	83 ec 0c             	sub    $0xc,%esp
8010657c:	68 12 70 10 80       	push   $0x80107012
80106581:	e8 d6 9d ff ff       	call   8010035c <panic>
      kfree(mem);
80106586:	83 ec 0c             	sub    $0xc,%esp
80106589:	53                   	push   %ebx
8010658a:	e8 9c ba ff ff       	call   8010202b <kfree>
      goto bad;
8010658f:	83 c4 10             	add    $0x10,%esp
    }
  }
  return d;

bad:
  freevm(d);
80106592:	83 ec 0c             	sub    $0xc,%esp
80106595:	ff 75 dc             	pushl  -0x24(%ebp)
80106598:	e8 f8 fd ff ff       	call   80106395 <freevm>
  return 0;
8010659d:	83 c4 10             	add    $0x10,%esp
801065a0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
}
801065a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
801065aa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801065ad:	5b                   	pop    %ebx
801065ae:	5e                   	pop    %esi
801065af:	5f                   	pop    %edi
801065b0:	5d                   	pop    %ebp
801065b1:	c3                   	ret    

801065b2 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801065b2:	f3 0f 1e fb          	endbr32 
801065b6:	55                   	push   %ebp
801065b7:	89 e5                	mov    %esp,%ebp
801065b9:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
801065bc:	b9 00 00 00 00       	mov    $0x0,%ecx
801065c1:	8b 55 0c             	mov    0xc(%ebp),%edx
801065c4:	8b 45 08             	mov    0x8(%ebp),%eax
801065c7:	e8 d5 f7 ff ff       	call   80105da1 <walkpgdir>
  if((*pte & PTE_P) == 0)
801065cc:	8b 00                	mov    (%eax),%eax
801065ce:	a8 01                	test   $0x1,%al
801065d0:	74 10                	je     801065e2 <uva2ka+0x30>
    return 0;
  if((*pte & PTE_U) == 0)
801065d2:	a8 04                	test   $0x4,%al
801065d4:	74 13                	je     801065e9 <uva2ka+0x37>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
801065d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801065db:	05 00 00 00 80       	add    $0x80000000,%eax
}
801065e0:	c9                   	leave  
801065e1:	c3                   	ret    
    return 0;
801065e2:	b8 00 00 00 00       	mov    $0x0,%eax
801065e7:	eb f7                	jmp    801065e0 <uva2ka+0x2e>
    return 0;
801065e9:	b8 00 00 00 00       	mov    $0x0,%eax
801065ee:	eb f0                	jmp    801065e0 <uva2ka+0x2e>

801065f0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
801065f0:	f3 0f 1e fb          	endbr32 
801065f4:	55                   	push   %ebp
801065f5:	89 e5                	mov    %esp,%ebp
801065f7:	57                   	push   %edi
801065f8:	56                   	push   %esi
801065f9:	53                   	push   %ebx
801065fa:	83 ec 0c             	sub    $0xc,%esp
801065fd:	8b 7d 14             	mov    0x14(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106600:	eb 25                	jmp    80106627 <copyout+0x37>
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106602:	8b 55 0c             	mov    0xc(%ebp),%edx
80106605:	29 f2                	sub    %esi,%edx
80106607:	01 d0                	add    %edx,%eax
80106609:	83 ec 04             	sub    $0x4,%esp
8010660c:	53                   	push   %ebx
8010660d:	ff 75 10             	pushl  0x10(%ebp)
80106610:	50                   	push   %eax
80106611:	e8 ed d7 ff ff       	call   80103e03 <memmove>
    len -= n;
80106616:	29 df                	sub    %ebx,%edi
    buf += n;
80106618:	01 5d 10             	add    %ebx,0x10(%ebp)
    va = va0 + PGSIZE;
8010661b:	8d 86 00 10 00 00    	lea    0x1000(%esi),%eax
80106621:	89 45 0c             	mov    %eax,0xc(%ebp)
80106624:	83 c4 10             	add    $0x10,%esp
  while(len > 0){
80106627:	85 ff                	test   %edi,%edi
80106629:	74 2f                	je     8010665a <copyout+0x6a>
    va0 = (uint)PGROUNDDOWN(va);
8010662b:	8b 75 0c             	mov    0xc(%ebp),%esi
8010662e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80106634:	83 ec 08             	sub    $0x8,%esp
80106637:	56                   	push   %esi
80106638:	ff 75 08             	pushl  0x8(%ebp)
8010663b:	e8 72 ff ff ff       	call   801065b2 <uva2ka>
    if(pa0 == 0)
80106640:	83 c4 10             	add    $0x10,%esp
80106643:	85 c0                	test   %eax,%eax
80106645:	74 20                	je     80106667 <copyout+0x77>
    n = PGSIZE - (va - va0);
80106647:	89 f3                	mov    %esi,%ebx
80106649:	2b 5d 0c             	sub    0xc(%ebp),%ebx
8010664c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    if(n > len)
80106652:	39 df                	cmp    %ebx,%edi
80106654:	73 ac                	jae    80106602 <copyout+0x12>
      n = len;
80106656:	89 fb                	mov    %edi,%ebx
80106658:	eb a8                	jmp    80106602 <copyout+0x12>
  }
  return 0;
8010665a:	b8 00 00 00 00       	mov    $0x0,%eax
}
8010665f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106662:	5b                   	pop    %ebx
80106663:	5e                   	pop    %esi
80106664:	5f                   	pop    %edi
80106665:	5d                   	pop    %ebp
80106666:	c3                   	ret    
      return -1;
80106667:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010666c:	eb f1                	jmp    8010665f <copyout+0x6f>
