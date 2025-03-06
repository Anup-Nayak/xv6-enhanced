
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
80100028:	bc 10 ef 11 80       	mov    $0x8011ef10,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 10 31 10 80       	mov    $0x80103110,%eax
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
80100044:	bb 54 b5 10 80       	mov    $0x8010b554,%ebx
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  initlock(&bcache.lock, "bcache");
8010004c:	68 20 77 10 80       	push   $0x80107720
80100051:	68 20 b5 10 80       	push   $0x8010b520
80100056:	e8 d5 46 00 00       	call   80104730 <initlock>
  bcache.head.next = &bcache.head;
8010005b:	83 c4 10             	add    $0x10,%esp
8010005e:	b8 1c fc 10 80       	mov    $0x8010fc1c,%eax
  bcache.head.prev = &bcache.head;
80100063:	c7 05 6c fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc6c
8010006a:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006d:	c7 05 70 fc 10 80 1c 	movl   $0x8010fc1c,0x8010fc70
80100074:	fc 10 80 
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 d3                	mov    %edx,%ebx
    b->next = bcache.head.next;
80100082:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100085:	83 ec 08             	sub    $0x8,%esp
80100088:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 27 77 10 80       	push   $0x80107727
80100097:	50                   	push   %eax
80100098:	e8 63 45 00 00       	call   80104600 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	8d 93 5c 02 00 00    	lea    0x25c(%ebx),%edx
801000a8:	83 c4 10             	add    $0x10,%esp
    bcache.head.next->prev = b;
801000ab:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
801000ae:	89 d8                	mov    %ebx,%eax
801000b0:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	81 fb c0 f9 10 80    	cmp    $0x8010f9c0,%ebx
801000bc:	75 c2                	jne    80100080 <binit+0x40>
  }
}
801000be:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c1:	c9                   	leave  
801000c2:	c3                   	ret    
801000c3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

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
801000df:	68 20 b5 10 80       	push   $0x8010b520
801000e4:	e8 17 48 00 00       	call   80104900 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fc 10 80    	mov    0x8010fc70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010011f:	90                   	nop
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fc 10 80    	mov    0x8010fc6c,%ebx
80100126:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 6e                	jmp    8010019e <bread+0xce>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fc 10 80    	cmp    $0x8010fc1c,%ebx
80100139:	74 63                	je     8010019e <bread+0xce>
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
8010015d:	68 20 b5 10 80       	push   $0x8010b520
80100162:	e8 39 47 00 00       	call   801048a0 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 ce 44 00 00       	call   80104640 <acquiresleep>
      return b;
80100172:	83 c4 10             	add    $0x10,%esp
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	74 0e                	je     80100188 <bread+0xb8>
    iderw(b);
  }
  return b;
}
8010017a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010017d:	89 d8                	mov    %ebx,%eax
8010017f:	5b                   	pop    %ebx
80100180:	5e                   	pop    %esi
80100181:	5f                   	pop    %edi
80100182:	5d                   	pop    %ebp
80100183:	c3                   	ret    
80100184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    iderw(b);
80100188:	83 ec 0c             	sub    $0xc,%esp
8010018b:	53                   	push   %ebx
8010018c:	e8 ff 21 00 00       	call   80102390 <iderw>
80100191:	83 c4 10             	add    $0x10,%esp
}
80100194:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100197:	89 d8                	mov    %ebx,%eax
80100199:	5b                   	pop    %ebx
8010019a:	5e                   	pop    %esi
8010019b:	5f                   	pop    %edi
8010019c:	5d                   	pop    %ebp
8010019d:	c3                   	ret    
  panic("bget: no buffers");
8010019e:	83 ec 0c             	sub    $0xc,%esp
801001a1:	68 2e 77 10 80       	push   $0x8010772e
801001a6:	e8 d5 01 00 00       	call   80100380 <panic>
801001ab:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801001af:	90                   	nop

801001b0 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001b0:	55                   	push   %ebp
801001b1:	89 e5                	mov    %esp,%ebp
801001b3:	53                   	push   %ebx
801001b4:	83 ec 10             	sub    $0x10,%esp
801001b7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001ba:	8d 43 0c             	lea    0xc(%ebx),%eax
801001bd:	50                   	push   %eax
801001be:	e8 1d 45 00 00       	call   801046e0 <holdingsleep>
801001c3:	83 c4 10             	add    $0x10,%esp
801001c6:	85 c0                	test   %eax,%eax
801001c8:	74 0f                	je     801001d9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ca:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001cd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001d0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001d3:	c9                   	leave  
  iderw(b);
801001d4:	e9 b7 21 00 00       	jmp    80102390 <iderw>
    panic("bwrite");
801001d9:	83 ec 0c             	sub    $0xc,%esp
801001dc:	68 3f 77 10 80       	push   $0x8010773f
801001e1:	e8 9a 01 00 00       	call   80100380 <panic>
801001e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801001ed:	8d 76 00             	lea    0x0(%esi),%esi

801001f0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001f0:	55                   	push   %ebp
801001f1:	89 e5                	mov    %esp,%ebp
801001f3:	56                   	push   %esi
801001f4:	53                   	push   %ebx
801001f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001f8:	8d 73 0c             	lea    0xc(%ebx),%esi
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 dc 44 00 00       	call   801046e0 <holdingsleep>
80100204:	83 c4 10             	add    $0x10,%esp
80100207:	85 c0                	test   %eax,%eax
80100209:	74 66                	je     80100271 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
8010020b:	83 ec 0c             	sub    $0xc,%esp
8010020e:	56                   	push   %esi
8010020f:	e8 8c 44 00 00       	call   801046a0 <releasesleep>

  acquire(&bcache.lock);
80100214:	c7 04 24 20 b5 10 80 	movl   $0x8010b520,(%esp)
8010021b:	e8 e0 46 00 00       	call   80104900 <acquire>
  b->refcnt--;
80100220:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100223:	83 c4 10             	add    $0x10,%esp
  b->refcnt--;
80100226:	83 e8 01             	sub    $0x1,%eax
80100229:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010022c:	85 c0                	test   %eax,%eax
8010022e:	75 2f                	jne    8010025f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100230:	8b 43 54             	mov    0x54(%ebx),%eax
80100233:	8b 53 50             	mov    0x50(%ebx),%edx
80100236:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100239:	8b 43 50             	mov    0x50(%ebx),%eax
8010023c:	8b 53 54             	mov    0x54(%ebx),%edx
8010023f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100242:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
    b->prev = &bcache.head;
80100247:	c7 43 50 1c fc 10 80 	movl   $0x8010fc1c,0x50(%ebx)
    b->next = bcache.head.next;
8010024e:	89 43 54             	mov    %eax,0x54(%ebx)
    bcache.head.next->prev = b;
80100251:	a1 70 fc 10 80       	mov    0x8010fc70,%eax
80100256:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100259:	89 1d 70 fc 10 80    	mov    %ebx,0x8010fc70
  }
  
  release(&bcache.lock);
8010025f:	c7 45 08 20 b5 10 80 	movl   $0x8010b520,0x8(%ebp)
}
80100266:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100269:	5b                   	pop    %ebx
8010026a:	5e                   	pop    %esi
8010026b:	5d                   	pop    %ebp
  release(&bcache.lock);
8010026c:	e9 2f 46 00 00       	jmp    801048a0 <release>
    panic("brelse");
80100271:	83 ec 0c             	sub    $0xc,%esp
80100274:	68 46 77 10 80       	push   $0x80107746
80100279:	e8 02 01 00 00       	call   80100380 <panic>
8010027e:	66 90                	xchg   %ax,%ax

80100280 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100280:	55                   	push   %ebp
80100281:	89 e5                	mov    %esp,%ebp
80100283:	57                   	push   %edi
80100284:	56                   	push   %esi
80100285:	53                   	push   %ebx
80100286:	83 ec 18             	sub    $0x18,%esp
80100289:	8b 5d 10             	mov    0x10(%ebp),%ebx
8010028c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010028f:	ff 75 08             	push   0x8(%ebp)
  target = n;
80100292:	89 df                	mov    %ebx,%edi
  iunlock(ip);
80100294:	e8 77 16 00 00       	call   80101910 <iunlock>
  acquire(&cons.lock);
80100299:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801002a0:	e8 5b 46 00 00       	call   80104900 <acquire>
  while(n > 0){
801002a5:	83 c4 10             	add    $0x10,%esp
801002a8:	85 db                	test   %ebx,%ebx
801002aa:	0f 8e 94 00 00 00    	jle    80100344 <consoleread+0xc4>
    while(input.r == input.w){
801002b0:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002b5:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002bb:	74 25                	je     801002e2 <consoleread+0x62>
801002bd:	eb 59                	jmp    80100318 <consoleread+0x98>
801002bf:	90                   	nop
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002c0:	83 ec 08             	sub    $0x8,%esp
801002c3:	68 20 ff 10 80       	push   $0x8010ff20
801002c8:	68 00 ff 10 80       	push   $0x8010ff00
801002cd:	e8 ce 40 00 00       	call   801043a0 <sleep>
    while(input.r == input.w){
801002d2:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
801002d7:	83 c4 10             	add    $0x10,%esp
801002da:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801002e0:	75 36                	jne    80100318 <consoleread+0x98>
      if(myproc()->killed){
801002e2:	e8 79 39 00 00       	call   80103c60 <myproc>
801002e7:	8b 48 24             	mov    0x24(%eax),%ecx
801002ea:	85 c9                	test   %ecx,%ecx
801002ec:	74 d2                	je     801002c0 <consoleread+0x40>
        release(&cons.lock);
801002ee:	83 ec 0c             	sub    $0xc,%esp
801002f1:	68 20 ff 10 80       	push   $0x8010ff20
801002f6:	e8 a5 45 00 00       	call   801048a0 <release>
        ilock(ip);
801002fb:	5a                   	pop    %edx
801002fc:	ff 75 08             	push   0x8(%ebp)
801002ff:	e8 2c 15 00 00       	call   80101830 <ilock>
        return -1;
80100304:	83 c4 10             	add    $0x10,%esp
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100307:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return -1;
8010030a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010030f:	5b                   	pop    %ebx
80100310:	5e                   	pop    %esi
80100311:	5f                   	pop    %edi
80100312:	5d                   	pop    %ebp
80100313:	c3                   	ret    
80100314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    c = input.buf[input.r++ % INPUT_BUF];
80100318:	8d 50 01             	lea    0x1(%eax),%edx
8010031b:	89 15 00 ff 10 80    	mov    %edx,0x8010ff00
80100321:	89 c2                	mov    %eax,%edx
80100323:	83 e2 7f             	and    $0x7f,%edx
80100326:	0f be 8a 80 fe 10 80 	movsbl -0x7fef0180(%edx),%ecx
    if(c == C('D')){  // EOF
8010032d:	80 f9 04             	cmp    $0x4,%cl
80100330:	74 37                	je     80100369 <consoleread+0xe9>
    *dst++ = c;
80100332:	83 c6 01             	add    $0x1,%esi
    --n;
80100335:	83 eb 01             	sub    $0x1,%ebx
    *dst++ = c;
80100338:	88 4e ff             	mov    %cl,-0x1(%esi)
    if(c == '\n')
8010033b:	83 f9 0a             	cmp    $0xa,%ecx
8010033e:	0f 85 64 ff ff ff    	jne    801002a8 <consoleread+0x28>
  release(&cons.lock);
80100344:	83 ec 0c             	sub    $0xc,%esp
80100347:	68 20 ff 10 80       	push   $0x8010ff20
8010034c:	e8 4f 45 00 00       	call   801048a0 <release>
  ilock(ip);
80100351:	58                   	pop    %eax
80100352:	ff 75 08             	push   0x8(%ebp)
80100355:	e8 d6 14 00 00       	call   80101830 <ilock>
  return target - n;
8010035a:	89 f8                	mov    %edi,%eax
8010035c:	83 c4 10             	add    $0x10,%esp
}
8010035f:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return target - n;
80100362:	29 d8                	sub    %ebx,%eax
}
80100364:	5b                   	pop    %ebx
80100365:	5e                   	pop    %esi
80100366:	5f                   	pop    %edi
80100367:	5d                   	pop    %ebp
80100368:	c3                   	ret    
      if(n < target){
80100369:	39 fb                	cmp    %edi,%ebx
8010036b:	73 d7                	jae    80100344 <consoleread+0xc4>
        input.r--;
8010036d:	a3 00 ff 10 80       	mov    %eax,0x8010ff00
80100372:	eb d0                	jmp    80100344 <consoleread+0xc4>
80100374:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010037b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010037f:	90                   	nop

80100380 <panic>:
{
80100380:	55                   	push   %ebp
80100381:	89 e5                	mov    %esp,%ebp
80100383:	56                   	push   %esi
80100384:	53                   	push   %ebx
80100385:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100388:	fa                   	cli    
  cons.locking = 0;
80100389:	c7 05 54 ff 10 80 00 	movl   $0x0,0x8010ff54
80100390:	00 00 00 
  getcallerpcs(&s, pcs);
80100393:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100396:	8d 75 f8             	lea    -0x8(%ebp),%esi
  cprintf("lapicid %d: panic: ", lapicid());
80100399:	e8 02 26 00 00       	call   801029a0 <lapicid>
8010039e:	83 ec 08             	sub    $0x8,%esp
801003a1:	50                   	push   %eax
801003a2:	68 4d 77 10 80       	push   $0x8010774d
801003a7:	e8 f4 02 00 00       	call   801006a0 <cprintf>
  cprintf(s);
801003ac:	58                   	pop    %eax
801003ad:	ff 75 08             	push   0x8(%ebp)
801003b0:	e8 eb 02 00 00       	call   801006a0 <cprintf>
  cprintf("\n");
801003b5:	c7 04 24 ef 80 10 80 	movl   $0x801080ef,(%esp)
801003bc:	e8 df 02 00 00       	call   801006a0 <cprintf>
  getcallerpcs(&s, pcs);
801003c1:	8d 45 08             	lea    0x8(%ebp),%eax
801003c4:	5a                   	pop    %edx
801003c5:	59                   	pop    %ecx
801003c6:	53                   	push   %ebx
801003c7:	50                   	push   %eax
801003c8:	e8 83 43 00 00       	call   80104750 <getcallerpcs>
  for(i=0; i<10; i++)
801003cd:	83 c4 10             	add    $0x10,%esp
    cprintf(" %p", pcs[i]);
801003d0:	83 ec 08             	sub    $0x8,%esp
801003d3:	ff 33                	push   (%ebx)
  for(i=0; i<10; i++)
801003d5:	83 c3 04             	add    $0x4,%ebx
    cprintf(" %p", pcs[i]);
801003d8:	68 61 77 10 80       	push   $0x80107761
801003dd:	e8 be 02 00 00       	call   801006a0 <cprintf>
  for(i=0; i<10; i++)
801003e2:	83 c4 10             	add    $0x10,%esp
801003e5:	39 f3                	cmp    %esi,%ebx
801003e7:	75 e7                	jne    801003d0 <panic+0x50>
  panicked = 1; // freeze other CPU
801003e9:	c7 05 58 ff 10 80 01 	movl   $0x1,0x8010ff58
801003f0:	00 00 00 
  for(;;)
801003f3:	eb fe                	jmp    801003f3 <panic+0x73>
801003f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801003fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100400 <consputc.part.0>:
consputc(int c)
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 1c             	sub    $0x1c,%esp
  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 ea 00 00 00    	je     80100500 <consputc.part.0+0x100>
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 11 5e 00 00       	call   80106230 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c8             	movzbl %al,%ecx
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	b8 0f 00 00 00       	mov    $0xf,%eax
80100441:	c1 e1 08             	shl    $0x8,%ecx
80100444:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100445:	89 f2                	mov    %esi,%edx
80100447:	ec                   	in     (%dx),%al
  pos |= inb(CRTPORT+1);
80100448:	0f b6 c0             	movzbl %al,%eax
8010044b:	09 c8                	or     %ecx,%eax
  if(c == '\n')
8010044d:	83 fb 0a             	cmp    $0xa,%ebx
80100450:	0f 84 92 00 00 00    	je     801004e8 <consputc.part.0+0xe8>
  else if(c == BACKSPACE){
80100456:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045c:	74 72                	je     801004d0 <consputc.part.0+0xd0>
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010045e:	0f b6 db             	movzbl %bl,%ebx
80100461:	8d 70 01             	lea    0x1(%eax),%esi
80100464:	80 cf 07             	or     $0x7,%bh
80100467:	66 89 9c 00 00 80 0b 	mov    %bx,-0x7ff48000(%eax,%eax,1)
8010046e:	80 
  if(pos < 0 || pos > 25*80)
8010046f:	81 fe d0 07 00 00    	cmp    $0x7d0,%esi
80100475:	0f 8f fb 00 00 00    	jg     80100576 <consputc.part.0+0x176>
  if((pos/80) >= 24){  // Scroll up.
8010047b:	81 fe 7f 07 00 00    	cmp    $0x77f,%esi
80100481:	0f 8f a9 00 00 00    	jg     80100530 <consputc.part.0+0x130>
  outb(CRTPORT+1, pos>>8);
80100487:	89 f0                	mov    %esi,%eax
  crt[pos] = ' ' | 0x0700;
80100489:	8d b4 36 00 80 0b 80 	lea    -0x7ff48000(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
80100490:	88 45 e7             	mov    %al,-0x19(%ebp)
  outb(CRTPORT+1, pos>>8);
80100493:	0f b6 fc             	movzbl %ah,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100496:	bb d4 03 00 00       	mov    $0x3d4,%ebx
8010049b:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a0:	89 da                	mov    %ebx,%edx
801004a2:	ee                   	out    %al,(%dx)
801004a3:	b9 d5 03 00 00       	mov    $0x3d5,%ecx
801004a8:	89 f8                	mov    %edi,%eax
801004aa:	89 ca                	mov    %ecx,%edx
801004ac:	ee                   	out    %al,(%dx)
801004ad:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b2:	89 da                	mov    %ebx,%edx
801004b4:	ee                   	out    %al,(%dx)
801004b5:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
801004b9:	89 ca                	mov    %ecx,%edx
801004bb:	ee                   	out    %al,(%dx)
  crt[pos] = ' ' | 0x0700;
801004bc:	b8 20 07 00 00       	mov    $0x720,%eax
801004c1:	66 89 06             	mov    %ax,(%esi)
}
801004c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c7:	5b                   	pop    %ebx
801004c8:	5e                   	pop    %esi
801004c9:	5f                   	pop    %edi
801004ca:	5d                   	pop    %ebp
801004cb:	c3                   	ret    
801004cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(pos > 0) --pos;
801004d0:	8d 70 ff             	lea    -0x1(%eax),%esi
801004d3:	85 c0                	test   %eax,%eax
801004d5:	75 98                	jne    8010046f <consputc.part.0+0x6f>
801004d7:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
801004db:	be 00 80 0b 80       	mov    $0x800b8000,%esi
801004e0:	31 ff                	xor    %edi,%edi
801004e2:	eb b2                	jmp    80100496 <consputc.part.0+0x96>
801004e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    pos += 80 - pos%80;
801004e8:	ba cd cc cc cc       	mov    $0xcccccccd,%edx
801004ed:	f7 e2                	mul    %edx
801004ef:	c1 ea 06             	shr    $0x6,%edx
801004f2:	8d 04 92             	lea    (%edx,%edx,4),%eax
801004f5:	c1 e0 04             	shl    $0x4,%eax
801004f8:	8d 70 50             	lea    0x50(%eax),%esi
801004fb:	e9 6f ff ff ff       	jmp    8010046f <consputc.part.0+0x6f>
    uartputc('\b'); uartputc(' '); uartputc('\b');
80100500:	83 ec 0c             	sub    $0xc,%esp
80100503:	6a 08                	push   $0x8
80100505:	e8 26 5d 00 00       	call   80106230 <uartputc>
8010050a:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
80100511:	e8 1a 5d 00 00       	call   80106230 <uartputc>
80100516:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
8010051d:	e8 0e 5d 00 00       	call   80106230 <uartputc>
80100522:	83 c4 10             	add    $0x10,%esp
80100525:	e9 f8 fe ff ff       	jmp    80100422 <consputc.part.0+0x22>
8010052a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100530:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
80100533:	8d 5e b0             	lea    -0x50(%esi),%ebx
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100536:	8d b4 36 60 7f 0b 80 	lea    -0x7ff480a0(%esi,%esi,1),%esi
  outb(CRTPORT+1, pos);
8010053d:	bf 07 00 00 00       	mov    $0x7,%edi
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100542:	68 60 0e 00 00       	push   $0xe60
80100547:	68 a0 80 0b 80       	push   $0x800b80a0
8010054c:	68 00 80 0b 80       	push   $0x800b8000
80100551:	e8 0a 45 00 00       	call   80104a60 <memmove>
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100556:	b8 80 07 00 00       	mov    $0x780,%eax
8010055b:	83 c4 0c             	add    $0xc,%esp
8010055e:	29 d8                	sub    %ebx,%eax
80100560:	01 c0                	add    %eax,%eax
80100562:	50                   	push   %eax
80100563:	6a 00                	push   $0x0
80100565:	56                   	push   %esi
80100566:	e8 55 44 00 00       	call   801049c0 <memset>
  outb(CRTPORT+1, pos);
8010056b:	88 5d e7             	mov    %bl,-0x19(%ebp)
8010056e:	83 c4 10             	add    $0x10,%esp
80100571:	e9 20 ff ff ff       	jmp    80100496 <consputc.part.0+0x96>
    panic("pos under/overflow");
80100576:	83 ec 0c             	sub    $0xc,%esp
80100579:	68 65 77 10 80       	push   $0x80107765
8010057e:	e8 fd fd ff ff       	call   80100380 <panic>
80100583:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010058a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100590 <consolewrite>:

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100590:	55                   	push   %ebp
80100591:	89 e5                	mov    %esp,%ebp
80100593:	57                   	push   %edi
80100594:	56                   	push   %esi
80100595:	53                   	push   %ebx
80100596:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100599:	ff 75 08             	push   0x8(%ebp)
{
8010059c:	8b 75 10             	mov    0x10(%ebp),%esi
  iunlock(ip);
8010059f:	e8 6c 13 00 00       	call   80101910 <iunlock>
  acquire(&cons.lock);
801005a4:	c7 04 24 20 ff 10 80 	movl   $0x8010ff20,(%esp)
801005ab:	e8 50 43 00 00       	call   80104900 <acquire>
  for(i = 0; i < n; i++)
801005b0:	83 c4 10             	add    $0x10,%esp
801005b3:	85 f6                	test   %esi,%esi
801005b5:	7e 25                	jle    801005dc <consolewrite+0x4c>
801005b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801005ba:	8d 3c 33             	lea    (%ebx,%esi,1),%edi
  if(panicked){
801005bd:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
    consputc(buf[i] & 0xff);
801005c3:	0f b6 03             	movzbl (%ebx),%eax
  if(panicked){
801005c6:	85 d2                	test   %edx,%edx
801005c8:	74 06                	je     801005d0 <consolewrite+0x40>
  asm volatile("cli");
801005ca:	fa                   	cli    
    for(;;)
801005cb:	eb fe                	jmp    801005cb <consolewrite+0x3b>
801005cd:	8d 76 00             	lea    0x0(%esi),%esi
801005d0:	e8 2b fe ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; i < n; i++)
801005d5:	83 c3 01             	add    $0x1,%ebx
801005d8:	39 df                	cmp    %ebx,%edi
801005da:	75 e1                	jne    801005bd <consolewrite+0x2d>
  release(&cons.lock);
801005dc:	83 ec 0c             	sub    $0xc,%esp
801005df:	68 20 ff 10 80       	push   $0x8010ff20
801005e4:	e8 b7 42 00 00       	call   801048a0 <release>
  ilock(ip);
801005e9:	58                   	pop    %eax
801005ea:	ff 75 08             	push   0x8(%ebp)
801005ed:	e8 3e 12 00 00       	call   80101830 <ilock>

  return n;
}
801005f2:	8d 65 f4             	lea    -0xc(%ebp),%esp
801005f5:	89 f0                	mov    %esi,%eax
801005f7:	5b                   	pop    %ebx
801005f8:	5e                   	pop    %esi
801005f9:	5f                   	pop    %edi
801005fa:	5d                   	pop    %ebp
801005fb:	c3                   	ret    
801005fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100600 <printint>:
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 2c             	sub    $0x2c,%esp
80100609:	89 55 d4             	mov    %edx,-0x2c(%ebp)
8010060c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  if(sign && (sign = xx < 0))
8010060f:	85 c9                	test   %ecx,%ecx
80100611:	74 04                	je     80100617 <printint+0x17>
80100613:	85 c0                	test   %eax,%eax
80100615:	78 6d                	js     80100684 <printint+0x84>
    x = xx;
80100617:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
8010061e:	89 c1                	mov    %eax,%ecx
  i = 0;
80100620:	31 db                	xor    %ebx,%ebx
80100622:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    buf[i++] = digits[x % base];
80100628:	89 c8                	mov    %ecx,%eax
8010062a:	31 d2                	xor    %edx,%edx
8010062c:	89 de                	mov    %ebx,%esi
8010062e:	89 cf                	mov    %ecx,%edi
80100630:	f7 75 d4             	divl   -0x2c(%ebp)
80100633:	8d 5b 01             	lea    0x1(%ebx),%ebx
80100636:	0f b6 92 90 77 10 80 	movzbl -0x7fef8870(%edx),%edx
  }while((x /= base) != 0);
8010063d:	89 c1                	mov    %eax,%ecx
    buf[i++] = digits[x % base];
8010063f:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
80100643:	3b 7d d4             	cmp    -0x2c(%ebp),%edi
80100646:	73 e0                	jae    80100628 <printint+0x28>
  if(sign)
80100648:	8b 4d d0             	mov    -0x30(%ebp),%ecx
8010064b:	85 c9                	test   %ecx,%ecx
8010064d:	74 0c                	je     8010065b <printint+0x5b>
    buf[i++] = '-';
8010064f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
80100654:	89 de                	mov    %ebx,%esi
    buf[i++] = '-';
80100656:	ba 2d 00 00 00       	mov    $0x2d,%edx
  while(--i >= 0)
8010065b:	8d 5c 35 d7          	lea    -0x29(%ebp,%esi,1),%ebx
8010065f:	0f be c2             	movsbl %dl,%eax
  if(panicked){
80100662:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100668:	85 d2                	test   %edx,%edx
8010066a:	74 04                	je     80100670 <printint+0x70>
8010066c:	fa                   	cli    
    for(;;)
8010066d:	eb fe                	jmp    8010066d <printint+0x6d>
8010066f:	90                   	nop
80100670:	e8 8b fd ff ff       	call   80100400 <consputc.part.0>
  while(--i >= 0)
80100675:	8d 45 d7             	lea    -0x29(%ebp),%eax
80100678:	39 c3                	cmp    %eax,%ebx
8010067a:	74 0e                	je     8010068a <printint+0x8a>
    consputc(buf[i]);
8010067c:	0f be 03             	movsbl (%ebx),%eax
8010067f:	83 eb 01             	sub    $0x1,%ebx
80100682:	eb de                	jmp    80100662 <printint+0x62>
    x = -xx;
80100684:	f7 d8                	neg    %eax
80100686:	89 c1                	mov    %eax,%ecx
80100688:	eb 96                	jmp    80100620 <printint+0x20>
}
8010068a:	83 c4 2c             	add    $0x2c,%esp
8010068d:	5b                   	pop    %ebx
8010068e:	5e                   	pop    %esi
8010068f:	5f                   	pop    %edi
80100690:	5d                   	pop    %ebp
80100691:	c3                   	ret    
80100692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801006a0 <cprintf>:
{
801006a0:	55                   	push   %ebp
801006a1:	89 e5                	mov    %esp,%ebp
801006a3:	57                   	push   %edi
801006a4:	56                   	push   %esi
801006a5:	53                   	push   %ebx
801006a6:	83 ec 1c             	sub    $0x1c,%esp
  locking = cons.locking;
801006a9:	a1 54 ff 10 80       	mov    0x8010ff54,%eax
801006ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(locking)
801006b1:	85 c0                	test   %eax,%eax
801006b3:	0f 85 27 01 00 00    	jne    801007e0 <cprintf+0x140>
  if (fmt == 0)
801006b9:	8b 75 08             	mov    0x8(%ebp),%esi
801006bc:	85 f6                	test   %esi,%esi
801006be:	0f 84 ac 01 00 00    	je     80100870 <cprintf+0x1d0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c4:	0f b6 06             	movzbl (%esi),%eax
  argp = (uint*)(void*)(&fmt + 1);
801006c7:	8d 7d 0c             	lea    0xc(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006ca:	31 db                	xor    %ebx,%ebx
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 56                	je     80100726 <cprintf+0x86>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	0f 85 cf 00 00 00    	jne    801007a8 <cprintf+0x108>
    c = fmt[++i] & 0xff;
801006d9:	83 c3 01             	add    $0x1,%ebx
801006dc:	0f b6 14 1e          	movzbl (%esi,%ebx,1),%edx
    if(c == 0)
801006e0:	85 d2                	test   %edx,%edx
801006e2:	74 42                	je     80100726 <cprintf+0x86>
    switch(c){
801006e4:	83 fa 70             	cmp    $0x70,%edx
801006e7:	0f 84 90 00 00 00    	je     8010077d <cprintf+0xdd>
801006ed:	7f 51                	jg     80100740 <cprintf+0xa0>
801006ef:	83 fa 25             	cmp    $0x25,%edx
801006f2:	0f 84 c0 00 00 00    	je     801007b8 <cprintf+0x118>
801006f8:	83 fa 64             	cmp    $0x64,%edx
801006fb:	0f 85 f4 00 00 00    	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 10, 1);
80100701:	8d 47 04             	lea    0x4(%edi),%eax
80100704:	b9 01 00 00 00       	mov    $0x1,%ecx
80100709:	ba 0a 00 00 00       	mov    $0xa,%edx
8010070e:	89 45 e0             	mov    %eax,-0x20(%ebp)
80100711:	8b 07                	mov    (%edi),%eax
80100713:	e8 e8 fe ff ff       	call   80100600 <printint>
80100718:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010071b:	83 c3 01             	add    $0x1,%ebx
8010071e:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
80100722:	85 c0                	test   %eax,%eax
80100724:	75 aa                	jne    801006d0 <cprintf+0x30>
  if(locking)
80100726:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100729:	85 c0                	test   %eax,%eax
8010072b:	0f 85 22 01 00 00    	jne    80100853 <cprintf+0x1b3>
}
80100731:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100734:	5b                   	pop    %ebx
80100735:	5e                   	pop    %esi
80100736:	5f                   	pop    %edi
80100737:	5d                   	pop    %ebp
80100738:	c3                   	ret    
80100739:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100740:	83 fa 73             	cmp    $0x73,%edx
80100743:	75 33                	jne    80100778 <cprintf+0xd8>
      if((s = (char*)*argp++) == 0)
80100745:	8d 47 04             	lea    0x4(%edi),%eax
80100748:	8b 3f                	mov    (%edi),%edi
8010074a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010074d:	85 ff                	test   %edi,%edi
8010074f:	0f 84 e3 00 00 00    	je     80100838 <cprintf+0x198>
      for(; *s; s++)
80100755:	0f be 07             	movsbl (%edi),%eax
80100758:	84 c0                	test   %al,%al
8010075a:	0f 84 08 01 00 00    	je     80100868 <cprintf+0x1c8>
  if(panicked){
80100760:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100766:	85 d2                	test   %edx,%edx
80100768:	0f 84 b2 00 00 00    	je     80100820 <cprintf+0x180>
8010076e:	fa                   	cli    
    for(;;)
8010076f:	eb fe                	jmp    8010076f <cprintf+0xcf>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    switch(c){
80100778:	83 fa 78             	cmp    $0x78,%edx
8010077b:	75 78                	jne    801007f5 <cprintf+0x155>
      printint(*argp++, 16, 0);
8010077d:	8d 47 04             	lea    0x4(%edi),%eax
80100780:	31 c9                	xor    %ecx,%ecx
80100782:	ba 10 00 00 00       	mov    $0x10,%edx
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100787:	83 c3 01             	add    $0x1,%ebx
      printint(*argp++, 16, 0);
8010078a:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010078d:	8b 07                	mov    (%edi),%eax
8010078f:	e8 6c fe ff ff       	call   80100600 <printint>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100794:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
      printint(*argp++, 16, 0);
80100798:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
8010079b:	85 c0                	test   %eax,%eax
8010079d:	0f 85 2d ff ff ff    	jne    801006d0 <cprintf+0x30>
801007a3:	eb 81                	jmp    80100726 <cprintf+0x86>
801007a5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007a8:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007ae:	85 c9                	test   %ecx,%ecx
801007b0:	74 14                	je     801007c6 <cprintf+0x126>
801007b2:	fa                   	cli    
    for(;;)
801007b3:	eb fe                	jmp    801007b3 <cprintf+0x113>
801007b5:	8d 76 00             	lea    0x0(%esi),%esi
  if(panicked){
801007b8:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
801007bd:	85 c0                	test   %eax,%eax
801007bf:	75 6c                	jne    8010082d <cprintf+0x18d>
801007c1:	b8 25 00 00 00       	mov    $0x25,%eax
801007c6:	e8 35 fc ff ff       	call   80100400 <consputc.part.0>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801007cb:	83 c3 01             	add    $0x1,%ebx
801007ce:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
801007d2:	85 c0                	test   %eax,%eax
801007d4:	0f 85 f6 fe ff ff    	jne    801006d0 <cprintf+0x30>
801007da:	e9 47 ff ff ff       	jmp    80100726 <cprintf+0x86>
801007df:	90                   	nop
    acquire(&cons.lock);
801007e0:	83 ec 0c             	sub    $0xc,%esp
801007e3:	68 20 ff 10 80       	push   $0x8010ff20
801007e8:	e8 13 41 00 00       	call   80104900 <acquire>
801007ed:	83 c4 10             	add    $0x10,%esp
801007f0:	e9 c4 fe ff ff       	jmp    801006b9 <cprintf+0x19>
  if(panicked){
801007f5:	8b 0d 58 ff 10 80    	mov    0x8010ff58,%ecx
801007fb:	85 c9                	test   %ecx,%ecx
801007fd:	75 31                	jne    80100830 <cprintf+0x190>
801007ff:	b8 25 00 00 00       	mov    $0x25,%eax
80100804:	89 55 e0             	mov    %edx,-0x20(%ebp)
80100807:	e8 f4 fb ff ff       	call   80100400 <consputc.part.0>
8010080c:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
80100812:	85 d2                	test   %edx,%edx
80100814:	8b 55 e0             	mov    -0x20(%ebp),%edx
80100817:	74 2e                	je     80100847 <cprintf+0x1a7>
80100819:	fa                   	cli    
    for(;;)
8010081a:	eb fe                	jmp    8010081a <cprintf+0x17a>
8010081c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100820:	e8 db fb ff ff       	call   80100400 <consputc.part.0>
      for(; *s; s++)
80100825:	83 c7 01             	add    $0x1,%edi
80100828:	e9 28 ff ff ff       	jmp    80100755 <cprintf+0xb5>
8010082d:	fa                   	cli    
    for(;;)
8010082e:	eb fe                	jmp    8010082e <cprintf+0x18e>
80100830:	fa                   	cli    
80100831:	eb fe                	jmp    80100831 <cprintf+0x191>
80100833:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100837:	90                   	nop
        s = "(null)";
80100838:	bf 78 77 10 80       	mov    $0x80107778,%edi
      for(; *s; s++)
8010083d:	b8 28 00 00 00       	mov    $0x28,%eax
80100842:	e9 19 ff ff ff       	jmp    80100760 <cprintf+0xc0>
80100847:	89 d0                	mov    %edx,%eax
80100849:	e8 b2 fb ff ff       	call   80100400 <consputc.part.0>
8010084e:	e9 c8 fe ff ff       	jmp    8010071b <cprintf+0x7b>
    release(&cons.lock);
80100853:	83 ec 0c             	sub    $0xc,%esp
80100856:	68 20 ff 10 80       	push   $0x8010ff20
8010085b:	e8 40 40 00 00       	call   801048a0 <release>
80100860:	83 c4 10             	add    $0x10,%esp
}
80100863:	e9 c9 fe ff ff       	jmp    80100731 <cprintf+0x91>
      if((s = (char*)*argp++) == 0)
80100868:	8b 7d e0             	mov    -0x20(%ebp),%edi
8010086b:	e9 ab fe ff ff       	jmp    8010071b <cprintf+0x7b>
    panic("null fmt");
80100870:	83 ec 0c             	sub    $0xc,%esp
80100873:	68 7f 77 10 80       	push   $0x8010777f
80100878:	e8 03 fb ff ff       	call   80100380 <panic>
8010087d:	8d 76 00             	lea    0x0(%esi),%esi

80100880 <consoleintr>:
{
80100880:	55                   	push   %ebp
80100881:	89 e5                	mov    %esp,%ebp
80100883:	57                   	push   %edi
80100884:	56                   	push   %esi
  int c, doprocdump = 0;
80100885:	31 f6                	xor    %esi,%esi
{
80100887:	53                   	push   %ebx
80100888:	83 ec 18             	sub    $0x18,%esp
8010088b:	8b 7d 08             	mov    0x8(%ebp),%edi
  acquire(&cons.lock);
8010088e:	68 20 ff 10 80       	push   $0x8010ff20
80100893:	e8 68 40 00 00       	call   80104900 <acquire>
  while((c = getc()) >= 0){
80100898:	83 c4 10             	add    $0x10,%esp
8010089b:	eb 1a                	jmp    801008b7 <consoleintr+0x37>
8010089d:	8d 76 00             	lea    0x0(%esi),%esi
    switch(c){
801008a0:	83 fb 08             	cmp    $0x8,%ebx
801008a3:	0f 84 d7 00 00 00    	je     80100980 <consoleintr+0x100>
801008a9:	83 fb 10             	cmp    $0x10,%ebx
801008ac:	0f 85 32 01 00 00    	jne    801009e4 <consoleintr+0x164>
801008b2:	be 01 00 00 00       	mov    $0x1,%esi
  while((c = getc()) >= 0){
801008b7:	ff d7                	call   *%edi
801008b9:	89 c3                	mov    %eax,%ebx
801008bb:	85 c0                	test   %eax,%eax
801008bd:	0f 88 05 01 00 00    	js     801009c8 <consoleintr+0x148>
    switch(c){
801008c3:	83 fb 15             	cmp    $0x15,%ebx
801008c6:	74 78                	je     80100940 <consoleintr+0xc0>
801008c8:	7e d6                	jle    801008a0 <consoleintr+0x20>
801008ca:	83 fb 7f             	cmp    $0x7f,%ebx
801008cd:	0f 84 ad 00 00 00    	je     80100980 <consoleintr+0x100>
      if(c != 0 && input.e-input.r < INPUT_BUF){
801008d3:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801008d8:	89 c2                	mov    %eax,%edx
801008da:	2b 15 00 ff 10 80    	sub    0x8010ff00,%edx
801008e0:	83 fa 7f             	cmp    $0x7f,%edx
801008e3:	77 d2                	ja     801008b7 <consoleintr+0x37>
        input.buf[input.e++ % INPUT_BUF] = c;
801008e5:	8d 48 01             	lea    0x1(%eax),%ecx
  if(panicked){
801008e8:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.buf[input.e++ % INPUT_BUF] = c;
801008ee:	83 e0 7f             	and    $0x7f,%eax
801008f1:	89 0d 08 ff 10 80    	mov    %ecx,0x8010ff08
        c = (c == '\r') ? '\n' : c;
801008f7:	83 fb 0d             	cmp    $0xd,%ebx
801008fa:	0f 84 13 01 00 00    	je     80100a13 <consoleintr+0x193>
        input.buf[input.e++ % INPUT_BUF] = c;
80100900:	88 98 80 fe 10 80    	mov    %bl,-0x7fef0180(%eax)
  if(panicked){
80100906:	85 d2                	test   %edx,%edx
80100908:	0f 85 10 01 00 00    	jne    80100a1e <consoleintr+0x19e>
8010090e:	89 d8                	mov    %ebx,%eax
80100910:	e8 eb fa ff ff       	call   80100400 <consputc.part.0>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100915:	83 fb 0a             	cmp    $0xa,%ebx
80100918:	0f 84 14 01 00 00    	je     80100a32 <consoleintr+0x1b2>
8010091e:	83 fb 04             	cmp    $0x4,%ebx
80100921:	0f 84 0b 01 00 00    	je     80100a32 <consoleintr+0x1b2>
80100927:	a1 00 ff 10 80       	mov    0x8010ff00,%eax
8010092c:	83 e8 80             	sub    $0xffffff80,%eax
8010092f:	39 05 08 ff 10 80    	cmp    %eax,0x8010ff08
80100935:	75 80                	jne    801008b7 <consoleintr+0x37>
80100937:	e9 fb 00 00 00       	jmp    80100a37 <consoleintr+0x1b7>
8010093c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      while(input.e != input.w &&
80100940:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100945:	39 05 04 ff 10 80    	cmp    %eax,0x8010ff04
8010094b:	0f 84 66 ff ff ff    	je     801008b7 <consoleintr+0x37>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100951:	83 e8 01             	sub    $0x1,%eax
80100954:	89 c2                	mov    %eax,%edx
80100956:	83 e2 7f             	and    $0x7f,%edx
      while(input.e != input.w &&
80100959:	80 ba 80 fe 10 80 0a 	cmpb   $0xa,-0x7fef0180(%edx)
80100960:	0f 84 51 ff ff ff    	je     801008b7 <consoleintr+0x37>
  if(panicked){
80100966:	8b 15 58 ff 10 80    	mov    0x8010ff58,%edx
        input.e--;
8010096c:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100971:	85 d2                	test   %edx,%edx
80100973:	74 33                	je     801009a8 <consoleintr+0x128>
80100975:	fa                   	cli    
    for(;;)
80100976:	eb fe                	jmp    80100976 <consoleintr+0xf6>
80100978:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010097f:	90                   	nop
      if(input.e != input.w){
80100980:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
80100985:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
8010098b:	0f 84 26 ff ff ff    	je     801008b7 <consoleintr+0x37>
        input.e--;
80100991:	83 e8 01             	sub    $0x1,%eax
80100994:	a3 08 ff 10 80       	mov    %eax,0x8010ff08
  if(panicked){
80100999:	a1 58 ff 10 80       	mov    0x8010ff58,%eax
8010099e:	85 c0                	test   %eax,%eax
801009a0:	74 56                	je     801009f8 <consoleintr+0x178>
801009a2:	fa                   	cli    
    for(;;)
801009a3:	eb fe                	jmp    801009a3 <consoleintr+0x123>
801009a5:	8d 76 00             	lea    0x0(%esi),%esi
801009a8:	b8 00 01 00 00       	mov    $0x100,%eax
801009ad:	e8 4e fa ff ff       	call   80100400 <consputc.part.0>
      while(input.e != input.w &&
801009b2:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
801009b7:	3b 05 04 ff 10 80    	cmp    0x8010ff04,%eax
801009bd:	75 92                	jne    80100951 <consoleintr+0xd1>
801009bf:	e9 f3 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
801009c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&cons.lock);
801009c8:	83 ec 0c             	sub    $0xc,%esp
801009cb:	68 20 ff 10 80       	push   $0x8010ff20
801009d0:	e8 cb 3e 00 00       	call   801048a0 <release>
  if(doprocdump) {
801009d5:	83 c4 10             	add    $0x10,%esp
801009d8:	85 f6                	test   %esi,%esi
801009da:	75 2b                	jne    80100a07 <consoleintr+0x187>
}
801009dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801009df:	5b                   	pop    %ebx
801009e0:	5e                   	pop    %esi
801009e1:	5f                   	pop    %edi
801009e2:	5d                   	pop    %ebp
801009e3:	c3                   	ret    
      if(c != 0 && input.e-input.r < INPUT_BUF){
801009e4:	85 db                	test   %ebx,%ebx
801009e6:	0f 84 cb fe ff ff    	je     801008b7 <consoleintr+0x37>
801009ec:	e9 e2 fe ff ff       	jmp    801008d3 <consoleintr+0x53>
801009f1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801009f8:	b8 00 01 00 00       	mov    $0x100,%eax
801009fd:	e8 fe f9 ff ff       	call   80100400 <consputc.part.0>
80100a02:	e9 b0 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
}
80100a07:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a0a:	5b                   	pop    %ebx
80100a0b:	5e                   	pop    %esi
80100a0c:	5f                   	pop    %edi
80100a0d:	5d                   	pop    %ebp
    procdump();  // now call procdump() wo. cons.lock held
80100a0e:	e9 2d 3b 00 00       	jmp    80104540 <procdump>
        input.buf[input.e++ % INPUT_BUF] = c;
80100a13:	c6 80 80 fe 10 80 0a 	movb   $0xa,-0x7fef0180(%eax)
  if(panicked){
80100a1a:	85 d2                	test   %edx,%edx
80100a1c:	74 0a                	je     80100a28 <consoleintr+0x1a8>
80100a1e:	fa                   	cli    
    for(;;)
80100a1f:	eb fe                	jmp    80100a1f <consoleintr+0x19f>
80100a21:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a28:	b8 0a 00 00 00       	mov    $0xa,%eax
80100a2d:	e8 ce f9 ff ff       	call   80100400 <consputc.part.0>
          input.w = input.e;
80100a32:	a1 08 ff 10 80       	mov    0x8010ff08,%eax
          wakeup(&input.r);
80100a37:	83 ec 0c             	sub    $0xc,%esp
          input.w = input.e;
80100a3a:	a3 04 ff 10 80       	mov    %eax,0x8010ff04
          wakeup(&input.r);
80100a3f:	68 00 ff 10 80       	push   $0x8010ff00
80100a44:	e8 17 3a 00 00       	call   80104460 <wakeup>
80100a49:	83 c4 10             	add    $0x10,%esp
80100a4c:	e9 66 fe ff ff       	jmp    801008b7 <consoleintr+0x37>
80100a51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a58:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100a5f:	90                   	nop

80100a60 <consoleinit>:

void
consoleinit(void)
{
80100a60:	55                   	push   %ebp
80100a61:	89 e5                	mov    %esp,%ebp
80100a63:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
80100a66:	68 88 77 10 80       	push   $0x80107788
80100a6b:	68 20 ff 10 80       	push   $0x8010ff20
80100a70:	e8 bb 3c 00 00       	call   80104730 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
80100a75:	58                   	pop    %eax
80100a76:	5a                   	pop    %edx
80100a77:	6a 00                	push   $0x0
80100a79:	6a 01                	push   $0x1
  devsw[CONSOLE].write = consolewrite;
80100a7b:	c7 05 0c 09 11 80 90 	movl   $0x80100590,0x8011090c
80100a82:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100a85:	c7 05 08 09 11 80 80 	movl   $0x80100280,0x80110908
80100a8c:	02 10 80 
  cons.locking = 1;
80100a8f:	c7 05 54 ff 10 80 01 	movl   $0x1,0x8010ff54
80100a96:	00 00 00 
  ioapicenable(IRQ_KBD, 0);
80100a99:	e8 92 1a 00 00       	call   80102530 <ioapicenable>
}
80100a9e:	83 c4 10             	add    $0x10,%esp
80100aa1:	c9                   	leave  
80100aa2:	c3                   	ret    
80100aa3:	66 90                	xchg   %ax,%ax
80100aa5:	66 90                	xchg   %ax,%ax
80100aa7:	66 90                	xchg   %ax,%ax
80100aa9:	66 90                	xchg   %ax,%ax
80100aab:	66 90                	xchg   %ax,%ax
80100aad:	66 90                	xchg   %ax,%ax
80100aaf:	90                   	nop

80100ab0 <strcmp1>:
#include "sleeplock.h"
#include "file.h"

int
strcmp1(const char *s1, const char *s2)
{
80100ab0:	55                   	push   %ebp
80100ab1:	89 e5                	mov    %esp,%ebp
80100ab3:	53                   	push   %ebx
80100ab4:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100ab7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while (*s1 && *s2 && *s1 == *s2) {
80100aba:	0f b6 01             	movzbl (%ecx),%eax
80100abd:	84 c0                	test   %al,%al
80100abf:	75 1b                	jne    80100adc <strcmp1+0x2c>
80100ac1:	eb 3a                	jmp    80100afd <strcmp1+0x4d>
80100ac3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100ac7:	90                   	nop
80100ac8:	84 d2                	test   %dl,%dl
80100aca:	74 17                	je     80100ae3 <strcmp1+0x33>
80100acc:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    s1++;
80100ad0:	83 c1 01             	add    $0x1,%ecx
    s2++;
80100ad3:	8d 53 01             	lea    0x1(%ebx),%edx
  while (*s1 && *s2 && *s1 == *s2) {
80100ad6:	84 c0                	test   %al,%al
80100ad8:	74 16                	je     80100af0 <strcmp1+0x40>
    s2++;
80100ada:	89 d3                	mov    %edx,%ebx
  while (*s1 && *s2 && *s1 == *s2) {
80100adc:	0f b6 13             	movzbl (%ebx),%edx
80100adf:	38 c2                	cmp    %al,%dl
80100ae1:	74 e5                	je     80100ac8 <strcmp1+0x18>
  }
  return (unsigned char)*s1 - (unsigned char)*s2;
}
80100ae3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return (unsigned char)*s1 - (unsigned char)*s2;
80100ae6:	29 d0                	sub    %edx,%eax
}
80100ae8:	c9                   	leave  
80100ae9:	c3                   	ret    
80100aea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (unsigned char)*s1 - (unsigned char)*s2;
80100af0:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
80100af4:	31 c0                	xor    %eax,%eax
}
80100af6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100af9:	c9                   	leave  
  return (unsigned char)*s1 - (unsigned char)*s2;
80100afa:	29 d0                	sub    %edx,%eax
}
80100afc:	c3                   	ret    
  return (unsigned char)*s1 - (unsigned char)*s2;
80100afd:	0f b6 13             	movzbl (%ebx),%edx
80100b00:	31 c0                	xor    %eax,%eax
80100b02:	eb df                	jmp    80100ae3 <strcmp1+0x33>
80100b04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100b0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100b0f:	90                   	nop

80100b10 <exec>:


int
exec(char *path, char **argv)
{
80100b10:	55                   	push   %ebp
80100b11:	89 e5                	mov    %esp,%ebp
80100b13:	57                   	push   %edi
80100b14:	56                   	push   %esi
80100b15:	53                   	push   %ebx
80100b16:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
80100b1c:	e8 3f 31 00 00       	call   80103c60 <myproc>
80100b21:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)

  begin_op();
80100b27:	e8 e4 22 00 00       	call   80102e10 <begin_op>

  if((ip = namei(path)) == 0){
80100b2c:	83 ec 0c             	sub    $0xc,%esp
80100b2f:	ff 75 08             	push   0x8(%ebp)
80100b32:	e8 19 16 00 00       	call   80102150 <namei>
80100b37:	83 c4 10             	add    $0x10,%esp
80100b3a:	85 c0                	test   %eax,%eax
80100b3c:	0f 84 2e 03 00 00    	je     80100e70 <exec+0x360>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100b42:	83 ec 0c             	sub    $0xc,%esp
80100b45:	89 c3                	mov    %eax,%ebx
80100b47:	50                   	push   %eax
80100b48:	e8 e3 0c 00 00       	call   80101830 <ilock>

  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100b4d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100b53:	6a 34                	push   $0x34
80100b55:	6a 00                	push   $0x0
80100b57:	50                   	push   %eax
80100b58:	53                   	push   %ebx
80100b59:	e8 e2 0f 00 00       	call   80101b40 <readi>
80100b5e:	83 c4 20             	add    $0x20,%esp
80100b61:	83 f8 34             	cmp    $0x34,%eax
80100b64:	74 22                	je     80100b88 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 51 0f 00 00       	call   80101ac0 <iunlockput>
    end_op();
80100b6f:	e8 0c 23 00 00       	call   80102e80 <end_op>
80100b74:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100b77:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100b7c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100b7f:	5b                   	pop    %ebx
80100b80:	5e                   	pop    %esi
80100b81:	5f                   	pop    %edi
80100b82:	5d                   	pop    %ebp
80100b83:	c3                   	ret    
80100b84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(elf.magic != ELF_MAGIC)
80100b88:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100b8f:	45 4c 46 
80100b92:	75 d2                	jne    80100b66 <exec+0x56>
  if((pgdir = setupkvm()) == 0)
80100b94:	e8 27 68 00 00       	call   801073c0 <setupkvm>
80100b99:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)
80100b9f:	85 c0                	test   %eax,%eax
80100ba1:	74 c3                	je     80100b66 <exec+0x56>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100ba3:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100baa:	00 
80100bab:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100bb1:	0f 84 d8 02 00 00    	je     80100e8f <exec+0x37f>
  sz = 0;
80100bb7:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
80100bbe:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100bc1:	31 ff                	xor    %edi,%edi
80100bc3:	e9 8e 00 00 00       	jmp    80100c56 <exec+0x146>
80100bc8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100bcf:	90                   	nop
    if(ph.type != ELF_PROG_LOAD)
80100bd0:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100bd7:	75 6c                	jne    80100c45 <exec+0x135>
    if(ph.memsz < ph.filesz)
80100bd9:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100bdf:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100be5:	0f 82 87 00 00 00    	jb     80100c72 <exec+0x162>
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100beb:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100bf1:	72 7f                	jb     80100c72 <exec+0x162>
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100bf3:	83 ec 04             	sub    $0x4,%esp
80100bf6:	50                   	push   %eax
80100bf7:	ff b5 f0 fe ff ff    	push   -0x110(%ebp)
80100bfd:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c03:	e8 d8 65 00 00       	call   801071e0 <allocuvm>
80100c08:	83 c4 10             	add    $0x10,%esp
80100c0b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100c11:	85 c0                	test   %eax,%eax
80100c13:	74 5d                	je     80100c72 <exec+0x162>
    if(ph.vaddr % PGSIZE != 0)
80100c15:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100c1b:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100c20:	75 50                	jne    80100c72 <exec+0x162>
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100c22:	83 ec 0c             	sub    $0xc,%esp
80100c25:	ff b5 14 ff ff ff    	push   -0xec(%ebp)
80100c2b:	ff b5 08 ff ff ff    	push   -0xf8(%ebp)
80100c31:	53                   	push   %ebx
80100c32:	50                   	push   %eax
80100c33:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c39:	e8 b2 64 00 00       	call   801070f0 <loaduvm>
80100c3e:	83 c4 20             	add    $0x20,%esp
80100c41:	85 c0                	test   %eax,%eax
80100c43:	78 2d                	js     80100c72 <exec+0x162>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100c45:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100c4c:	83 c7 01             	add    $0x1,%edi
80100c4f:	83 c6 20             	add    $0x20,%esi
80100c52:	39 f8                	cmp    %edi,%eax
80100c54:	7e 3a                	jle    80100c90 <exec+0x180>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100c56:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100c5c:	6a 20                	push   $0x20
80100c5e:	56                   	push   %esi
80100c5f:	50                   	push   %eax
80100c60:	53                   	push   %ebx
80100c61:	e8 da 0e 00 00       	call   80101b40 <readi>
80100c66:	83 c4 10             	add    $0x10,%esp
80100c69:	83 f8 20             	cmp    $0x20,%eax
80100c6c:	0f 84 5e ff ff ff    	je     80100bd0 <exec+0xc0>
    freevm(pgdir);
80100c72:	83 ec 0c             	sub    $0xc,%esp
80100c75:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100c7b:	e8 c0 66 00 00       	call   80107340 <freevm>
  if(ip){
80100c80:	83 c4 10             	add    $0x10,%esp
80100c83:	e9 de fe ff ff       	jmp    80100b66 <exec+0x56>
80100c88:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100c8f:	90                   	nop
  sz = PGROUNDUP(sz);
80100c90:	8b bd f0 fe ff ff    	mov    -0x110(%ebp),%edi
80100c96:	81 c7 ff 0f 00 00    	add    $0xfff,%edi
80100c9c:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100ca2:	8d b7 00 20 00 00    	lea    0x2000(%edi),%esi
  iunlockput(ip);
80100ca8:	83 ec 0c             	sub    $0xc,%esp
80100cab:	53                   	push   %ebx
80100cac:	e8 0f 0e 00 00       	call   80101ac0 <iunlockput>
  end_op();
80100cb1:	e8 ca 21 00 00       	call   80102e80 <end_op>
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100cb6:	83 c4 0c             	add    $0xc,%esp
80100cb9:	56                   	push   %esi
80100cba:	57                   	push   %edi
80100cbb:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cc1:	57                   	push   %edi
80100cc2:	e8 19 65 00 00       	call   801071e0 <allocuvm>
80100cc7:	83 c4 10             	add    $0x10,%esp
80100cca:	89 c6                	mov    %eax,%esi
80100ccc:	85 c0                	test   %eax,%eax
80100cce:	0f 84 94 00 00 00    	je     80100d68 <exec+0x258>
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cd4:	83 ec 08             	sub    $0x8,%esp
80100cd7:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
  for(argc = 0; argv[argc]; argc++) {
80100cdd:	89 f3                	mov    %esi,%ebx
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100cdf:	50                   	push   %eax
80100ce0:	57                   	push   %edi
  for(argc = 0; argv[argc]; argc++) {
80100ce1:	31 ff                	xor    %edi,%edi
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100ce3:	e8 78 67 00 00       	call   80107460 <clearpteu>
  for(argc = 0; argv[argc]; argc++) {
80100ce8:	8b 45 0c             	mov    0xc(%ebp),%eax
80100ceb:	83 c4 10             	add    $0x10,%esp
80100cee:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100cf4:	8b 00                	mov    (%eax),%eax
80100cf6:	85 c0                	test   %eax,%eax
80100cf8:	0f 84 8b 00 00 00    	je     80100d89 <exec+0x279>
80100cfe:	89 b5 f0 fe ff ff    	mov    %esi,-0x110(%ebp)
80100d04:	8b b5 f4 fe ff ff    	mov    -0x10c(%ebp),%esi
80100d0a:	eb 23                	jmp    80100d2f <exec+0x21f>
80100d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100d10:	8b 45 0c             	mov    0xc(%ebp),%eax
    ustack[3+argc] = sp;
80100d13:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
  for(argc = 0; argv[argc]; argc++) {
80100d1a:	83 c7 01             	add    $0x1,%edi
    ustack[3+argc] = sp;
80100d1d:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
  for(argc = 0; argv[argc]; argc++) {
80100d23:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100d26:	85 c0                	test   %eax,%eax
80100d28:	74 59                	je     80100d83 <exec+0x273>
    if(argc >= MAXARG)
80100d2a:	83 ff 20             	cmp    $0x20,%edi
80100d2d:	74 39                	je     80100d68 <exec+0x258>
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d2f:	83 ec 0c             	sub    $0xc,%esp
80100d32:	50                   	push   %eax
80100d33:	e8 88 3e 00 00       	call   80104bc0 <strlen>
80100d38:	29 c3                	sub    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d3a:	58                   	pop    %eax
80100d3b:	8b 45 0c             	mov    0xc(%ebp),%eax
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d3e:	83 eb 01             	sub    $0x1,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d41:	ff 34 b8             	push   (%eax,%edi,4)
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100d44:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100d47:	e8 74 3e 00 00       	call   80104bc0 <strlen>
80100d4c:	83 c0 01             	add    $0x1,%eax
80100d4f:	50                   	push   %eax
80100d50:	8b 45 0c             	mov    0xc(%ebp),%eax
80100d53:	ff 34 b8             	push   (%eax,%edi,4)
80100d56:	53                   	push   %ebx
80100d57:	56                   	push   %esi
80100d58:	e8 d3 68 00 00       	call   80107630 <copyout>
80100d5d:	83 c4 20             	add    $0x20,%esp
80100d60:	85 c0                	test   %eax,%eax
80100d62:	79 ac                	jns    80100d10 <exec+0x200>
80100d64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    freevm(pgdir);
80100d68:	83 ec 0c             	sub    $0xc,%esp
80100d6b:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
80100d71:	e8 ca 65 00 00       	call   80107340 <freevm>
80100d76:	83 c4 10             	add    $0x10,%esp
  return -1;
80100d79:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100d7e:	e9 f9 fd ff ff       	jmp    80100b7c <exec+0x6c>
80100d83:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d89:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100d90:	89 d9                	mov    %ebx,%ecx
  ustack[3+argc] = 0;
80100d92:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100d99:	00 00 00 00 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100d9d:	29 c1                	sub    %eax,%ecx
  sp -= (3+argc+1) * 4;
80100d9f:	83 c0 0c             	add    $0xc,%eax
  ustack[1] = argc;
80100da2:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  sp -= (3+argc+1) * 4;
80100da8:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100daa:	50                   	push   %eax
80100dab:	52                   	push   %edx
80100dac:	53                   	push   %ebx
80100dad:	ff b5 f4 fe ff ff    	push   -0x10c(%ebp)
  ustack[0] = 0xffffffff;  // fake return PC
80100db3:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100dba:	ff ff ff 
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100dbd:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100dc3:	e8 68 68 00 00       	call   80107630 <copyout>
80100dc8:	83 c4 10             	add    $0x10,%esp
80100dcb:	85 c0                	test   %eax,%eax
80100dcd:	78 99                	js     80100d68 <exec+0x258>
  for(last=s=path; *s; s++)
80100dcf:	8b 45 08             	mov    0x8(%ebp),%eax
80100dd2:	8b 55 08             	mov    0x8(%ebp),%edx
80100dd5:	0f b6 00             	movzbl (%eax),%eax
80100dd8:	84 c0                	test   %al,%al
80100dda:	74 13                	je     80100def <exec+0x2df>
80100ddc:	89 d1                	mov    %edx,%ecx
80100dde:	66 90                	xchg   %ax,%ax
      last = s+1;
80100de0:	83 c1 01             	add    $0x1,%ecx
80100de3:	3c 2f                	cmp    $0x2f,%al
  for(last=s=path; *s; s++)
80100de5:	0f b6 01             	movzbl (%ecx),%eax
      last = s+1;
80100de8:	0f 44 d1             	cmove  %ecx,%edx
  for(last=s=path; *s; s++)
80100deb:	84 c0                	test   %al,%al
80100ded:	75 f1                	jne    80100de0 <exec+0x2d0>
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100def:	8b bd ec fe ff ff    	mov    -0x114(%ebp),%edi
80100df5:	83 ec 04             	sub    $0x4,%esp
80100df8:	6a 10                	push   $0x10
80100dfa:	8d 47 6c             	lea    0x6c(%edi),%eax
80100dfd:	52                   	push   %edx
80100dfe:	50                   	push   %eax
80100dff:	e8 7c 3d 00 00       	call   80104b80 <safestrcpy>
  for (int i = 0; i < MAX_SYSCALLS; i++) {
80100e04:	8d 47 7c             	lea    0x7c(%edi),%eax
80100e07:	8d 97 7c 01 00 00    	lea    0x17c(%edi),%edx
80100e0d:	83 c4 10             	add    $0x10,%esp
    if(curproc->blocked_syscalls[i] && curproc->pass_syscalls[i]==0){
80100e10:	8b b8 00 01 00 00    	mov    0x100(%eax),%edi
80100e16:	85 ff                	test   %edi,%edi
80100e18:	74 0c                	je     80100e26 <exec+0x316>
80100e1a:	8b 08                	mov    (%eax),%ecx
80100e1c:	85 c9                	test   %ecx,%ecx
80100e1e:	75 06                	jne    80100e26 <exec+0x316>
      curproc->pass_syscalls[i] = 1;
80100e20:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  for (int i = 0; i < MAX_SYSCALLS; i++) {
80100e26:	83 c0 04             	add    $0x4,%eax
80100e29:	39 c2                	cmp    %eax,%edx
80100e2b:	75 e3                	jne    80100e10 <exec+0x300>
  oldpgdir = curproc->pgdir;
80100e2d:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  curproc->pgdir = pgdir;
80100e33:	8b 8d f4 fe ff ff    	mov    -0x10c(%ebp),%ecx
  switchuvm(curproc);
80100e39:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80100e3c:	89 30                	mov    %esi,(%eax)
  oldpgdir = curproc->pgdir;
80100e3e:	8b 78 04             	mov    0x4(%eax),%edi
  curproc->pgdir = pgdir;
80100e41:	89 48 04             	mov    %ecx,0x4(%eax)
  curproc->tf->eip = elf.entry;  // main
80100e44:	89 c1                	mov    %eax,%ecx
80100e46:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100e4c:	8b 40 18             	mov    0x18(%eax),%eax
80100e4f:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100e52:	8b 41 18             	mov    0x18(%ecx),%eax
80100e55:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100e58:	51                   	push   %ecx
80100e59:	e8 02 61 00 00       	call   80106f60 <switchuvm>
  freevm(oldpgdir);
80100e5e:	89 3c 24             	mov    %edi,(%esp)
80100e61:	e8 da 64 00 00       	call   80107340 <freevm>
  return 0;
80100e66:	83 c4 10             	add    $0x10,%esp
80100e69:	31 c0                	xor    %eax,%eax
80100e6b:	e9 0c fd ff ff       	jmp    80100b7c <exec+0x6c>
    end_op();
80100e70:	e8 0b 20 00 00       	call   80102e80 <end_op>
    cprintf("exec: fail\n");
80100e75:	83 ec 0c             	sub    $0xc,%esp
80100e78:	68 a1 77 10 80       	push   $0x801077a1
80100e7d:	e8 1e f8 ff ff       	call   801006a0 <cprintf>
    return -1;
80100e82:	83 c4 10             	add    $0x10,%esp
80100e85:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100e8a:	e9 ed fc ff ff       	jmp    80100b7c <exec+0x6c>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100e8f:	be 00 20 00 00       	mov    $0x2000,%esi
80100e94:	31 ff                	xor    %edi,%edi
80100e96:	e9 0d fe ff ff       	jmp    80100ca8 <exec+0x198>
80100e9b:	66 90                	xchg   %ax,%ax
80100e9d:	66 90                	xchg   %ax,%ax
80100e9f:	90                   	nop

80100ea0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100ea0:	55                   	push   %ebp
80100ea1:	89 e5                	mov    %esp,%ebp
80100ea3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100ea6:	68 ad 77 10 80       	push   $0x801077ad
80100eab:	68 60 ff 10 80       	push   $0x8010ff60
80100eb0:	e8 7b 38 00 00       	call   80104730 <initlock>
}
80100eb5:	83 c4 10             	add    $0x10,%esp
80100eb8:	c9                   	leave  
80100eb9:	c3                   	ret    
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100ec0 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100ec0:	55                   	push   %ebp
80100ec1:	89 e5                	mov    %esp,%ebp
80100ec3:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ec4:	bb 94 ff 10 80       	mov    $0x8010ff94,%ebx
{
80100ec9:	83 ec 10             	sub    $0x10,%esp
  acquire(&ftable.lock);
80100ecc:	68 60 ff 10 80       	push   $0x8010ff60
80100ed1:	e8 2a 3a 00 00       	call   80104900 <acquire>
80100ed6:	83 c4 10             	add    $0x10,%esp
80100ed9:	eb 10                	jmp    80100eeb <filealloc+0x2b>
80100edb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100edf:	90                   	nop
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100ee0:	83 c3 18             	add    $0x18,%ebx
80100ee3:	81 fb f4 08 11 80    	cmp    $0x801108f4,%ebx
80100ee9:	74 25                	je     80100f10 <filealloc+0x50>
    if(f->ref == 0){
80100eeb:	8b 43 04             	mov    0x4(%ebx),%eax
80100eee:	85 c0                	test   %eax,%eax
80100ef0:	75 ee                	jne    80100ee0 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100ef2:	83 ec 0c             	sub    $0xc,%esp
      f->ref = 1;
80100ef5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100efc:	68 60 ff 10 80       	push   $0x8010ff60
80100f01:	e8 9a 39 00 00       	call   801048a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100f06:	89 d8                	mov    %ebx,%eax
      return f;
80100f08:	83 c4 10             	add    $0x10,%esp
}
80100f0b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f0e:	c9                   	leave  
80100f0f:	c3                   	ret    
  release(&ftable.lock);
80100f10:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80100f13:	31 db                	xor    %ebx,%ebx
  release(&ftable.lock);
80100f15:	68 60 ff 10 80       	push   $0x8010ff60
80100f1a:	e8 81 39 00 00       	call   801048a0 <release>
}
80100f1f:	89 d8                	mov    %ebx,%eax
  return 0;
80100f21:	83 c4 10             	add    $0x10,%esp
}
80100f24:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f27:	c9                   	leave  
80100f28:	c3                   	ret    
80100f29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100f30 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100f30:	55                   	push   %ebp
80100f31:	89 e5                	mov    %esp,%ebp
80100f33:	53                   	push   %ebx
80100f34:	83 ec 10             	sub    $0x10,%esp
80100f37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100f3a:	68 60 ff 10 80       	push   $0x8010ff60
80100f3f:	e8 bc 39 00 00       	call   80104900 <acquire>
  if(f->ref < 1)
80100f44:	8b 43 04             	mov    0x4(%ebx),%eax
80100f47:	83 c4 10             	add    $0x10,%esp
80100f4a:	85 c0                	test   %eax,%eax
80100f4c:	7e 1a                	jle    80100f68 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100f4e:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100f51:	83 ec 0c             	sub    $0xc,%esp
  f->ref++;
80100f54:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100f57:	68 60 ff 10 80       	push   $0x8010ff60
80100f5c:	e8 3f 39 00 00       	call   801048a0 <release>
  return f;
}
80100f61:	89 d8                	mov    %ebx,%eax
80100f63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f66:	c9                   	leave  
80100f67:	c3                   	ret    
    panic("filedup");
80100f68:	83 ec 0c             	sub    $0xc,%esp
80100f6b:	68 b4 77 10 80       	push   $0x801077b4
80100f70:	e8 0b f4 ff ff       	call   80100380 <panic>
80100f75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100f80:	55                   	push   %ebp
80100f81:	89 e5                	mov    %esp,%ebp
80100f83:	57                   	push   %edi
80100f84:	56                   	push   %esi
80100f85:	53                   	push   %ebx
80100f86:	83 ec 28             	sub    $0x28,%esp
80100f89:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct file ff;

  acquire(&ftable.lock);
80100f8c:	68 60 ff 10 80       	push   $0x8010ff60
80100f91:	e8 6a 39 00 00       	call   80104900 <acquire>
  if(f->ref < 1)
80100f96:	8b 53 04             	mov    0x4(%ebx),%edx
80100f99:	83 c4 10             	add    $0x10,%esp
80100f9c:	85 d2                	test   %edx,%edx
80100f9e:	0f 8e a5 00 00 00    	jle    80101049 <fileclose+0xc9>
    panic("fileclose");
  if(--f->ref > 0){
80100fa4:	83 ea 01             	sub    $0x1,%edx
80100fa7:	89 53 04             	mov    %edx,0x4(%ebx)
80100faa:	75 44                	jne    80100ff0 <fileclose+0x70>
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100fac:	0f b6 43 09          	movzbl 0x9(%ebx),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100fb0:	83 ec 0c             	sub    $0xc,%esp
  ff = *f;
80100fb3:	8b 3b                	mov    (%ebx),%edi
  f->type = FD_NONE;
80100fb5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  ff = *f;
80100fbb:	8b 73 0c             	mov    0xc(%ebx),%esi
80100fbe:	88 45 e7             	mov    %al,-0x19(%ebp)
80100fc1:	8b 43 10             	mov    0x10(%ebx),%eax
  release(&ftable.lock);
80100fc4:	68 60 ff 10 80       	push   $0x8010ff60
  ff = *f;
80100fc9:	89 45 e0             	mov    %eax,-0x20(%ebp)
  release(&ftable.lock);
80100fcc:	e8 cf 38 00 00       	call   801048a0 <release>

  if(ff.type == FD_PIPE)
80100fd1:	83 c4 10             	add    $0x10,%esp
80100fd4:	83 ff 01             	cmp    $0x1,%edi
80100fd7:	74 57                	je     80101030 <fileclose+0xb0>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100fd9:	83 ff 02             	cmp    $0x2,%edi
80100fdc:	74 2a                	je     80101008 <fileclose+0x88>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fe1:	5b                   	pop    %ebx
80100fe2:	5e                   	pop    %esi
80100fe3:	5f                   	pop    %edi
80100fe4:	5d                   	pop    %ebp
80100fe5:	c3                   	ret    
80100fe6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100fed:	8d 76 00             	lea    0x0(%esi),%esi
    release(&ftable.lock);
80100ff0:	c7 45 08 60 ff 10 80 	movl   $0x8010ff60,0x8(%ebp)
}
80100ff7:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ffa:	5b                   	pop    %ebx
80100ffb:	5e                   	pop    %esi
80100ffc:	5f                   	pop    %edi
80100ffd:	5d                   	pop    %ebp
    release(&ftable.lock);
80100ffe:	e9 9d 38 00 00       	jmp    801048a0 <release>
80101003:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101007:	90                   	nop
    begin_op();
80101008:	e8 03 1e 00 00       	call   80102e10 <begin_op>
    iput(ff.ip);
8010100d:	83 ec 0c             	sub    $0xc,%esp
80101010:	ff 75 e0             	push   -0x20(%ebp)
80101013:	e8 48 09 00 00       	call   80101960 <iput>
    end_op();
80101018:	83 c4 10             	add    $0x10,%esp
}
8010101b:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010101e:	5b                   	pop    %ebx
8010101f:	5e                   	pop    %esi
80101020:	5f                   	pop    %edi
80101021:	5d                   	pop    %ebp
    end_op();
80101022:	e9 59 1e 00 00       	jmp    80102e80 <end_op>
80101027:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010102e:	66 90                	xchg   %ax,%ax
    pipeclose(ff.pipe, ff.writable);
80101030:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80101034:	83 ec 08             	sub    $0x8,%esp
80101037:	53                   	push   %ebx
80101038:	56                   	push   %esi
80101039:	e8 a2 25 00 00       	call   801035e0 <pipeclose>
8010103e:	83 c4 10             	add    $0x10,%esp
}
80101041:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101044:	5b                   	pop    %ebx
80101045:	5e                   	pop    %esi
80101046:	5f                   	pop    %edi
80101047:	5d                   	pop    %ebp
80101048:	c3                   	ret    
    panic("fileclose");
80101049:	83 ec 0c             	sub    $0xc,%esp
8010104c:	68 bc 77 10 80       	push   $0x801077bc
80101051:	e8 2a f3 ff ff       	call   80100380 <panic>
80101056:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010105d:	8d 76 00             	lea    0x0(%esi),%esi

80101060 <filestat>:

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80101060:	55                   	push   %ebp
80101061:	89 e5                	mov    %esp,%ebp
80101063:	53                   	push   %ebx
80101064:	83 ec 04             	sub    $0x4,%esp
80101067:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
8010106a:	83 3b 02             	cmpl   $0x2,(%ebx)
8010106d:	75 31                	jne    801010a0 <filestat+0x40>
    ilock(f->ip);
8010106f:	83 ec 0c             	sub    $0xc,%esp
80101072:	ff 73 10             	push   0x10(%ebx)
80101075:	e8 b6 07 00 00       	call   80101830 <ilock>
    stati(f->ip, st);
8010107a:	58                   	pop    %eax
8010107b:	5a                   	pop    %edx
8010107c:	ff 75 0c             	push   0xc(%ebp)
8010107f:	ff 73 10             	push   0x10(%ebx)
80101082:	e8 89 0a 00 00       	call   80101b10 <stati>
    iunlock(f->ip);
80101087:	59                   	pop    %ecx
80101088:	ff 73 10             	push   0x10(%ebx)
8010108b:	e8 80 08 00 00       	call   80101910 <iunlock>
    return 0;
  }
  return -1;
}
80101090:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return 0;
80101093:	83 c4 10             	add    $0x10,%esp
80101096:	31 c0                	xor    %eax,%eax
}
80101098:	c9                   	leave  
80101099:	c3                   	ret    
8010109a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801010a0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
801010a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801010a8:	c9                   	leave  
801010a9:	c3                   	ret    
801010aa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801010b0 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
801010b0:	55                   	push   %ebp
801010b1:	89 e5                	mov    %esp,%ebp
801010b3:	57                   	push   %edi
801010b4:	56                   	push   %esi
801010b5:	53                   	push   %ebx
801010b6:	83 ec 0c             	sub    $0xc,%esp
801010b9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801010bc:	8b 75 0c             	mov    0xc(%ebp),%esi
801010bf:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
801010c2:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
801010c6:	74 60                	je     80101128 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
801010c8:	8b 03                	mov    (%ebx),%eax
801010ca:	83 f8 01             	cmp    $0x1,%eax
801010cd:	74 41                	je     80101110 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
801010cf:	83 f8 02             	cmp    $0x2,%eax
801010d2:	75 5b                	jne    8010112f <fileread+0x7f>
    ilock(f->ip);
801010d4:	83 ec 0c             	sub    $0xc,%esp
801010d7:	ff 73 10             	push   0x10(%ebx)
801010da:	e8 51 07 00 00       	call   80101830 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
801010df:	57                   	push   %edi
801010e0:	ff 73 14             	push   0x14(%ebx)
801010e3:	56                   	push   %esi
801010e4:	ff 73 10             	push   0x10(%ebx)
801010e7:	e8 54 0a 00 00       	call   80101b40 <readi>
801010ec:	83 c4 20             	add    $0x20,%esp
801010ef:	89 c6                	mov    %eax,%esi
801010f1:	85 c0                	test   %eax,%eax
801010f3:	7e 03                	jle    801010f8 <fileread+0x48>
      f->off += r;
801010f5:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
801010f8:	83 ec 0c             	sub    $0xc,%esp
801010fb:	ff 73 10             	push   0x10(%ebx)
801010fe:	e8 0d 08 00 00       	call   80101910 <iunlock>
    return r;
80101103:	83 c4 10             	add    $0x10,%esp
  }
  panic("fileread");
}
80101106:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101109:	89 f0                	mov    %esi,%eax
8010110b:	5b                   	pop    %ebx
8010110c:	5e                   	pop    %esi
8010110d:	5f                   	pop    %edi
8010110e:	5d                   	pop    %ebp
8010110f:	c3                   	ret    
    return piperead(f->pipe, addr, n);
80101110:	8b 43 0c             	mov    0xc(%ebx),%eax
80101113:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101116:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101119:	5b                   	pop    %ebx
8010111a:	5e                   	pop    %esi
8010111b:	5f                   	pop    %edi
8010111c:	5d                   	pop    %ebp
    return piperead(f->pipe, addr, n);
8010111d:	e9 5e 26 00 00       	jmp    80103780 <piperead>
80101122:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80101128:	be ff ff ff ff       	mov    $0xffffffff,%esi
8010112d:	eb d7                	jmp    80101106 <fileread+0x56>
  panic("fileread");
8010112f:	83 ec 0c             	sub    $0xc,%esp
80101132:	68 c6 77 10 80       	push   $0x801077c6
80101137:	e8 44 f2 ff ff       	call   80100380 <panic>
8010113c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101140 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80101140:	55                   	push   %ebp
80101141:	89 e5                	mov    %esp,%ebp
80101143:	57                   	push   %edi
80101144:	56                   	push   %esi
80101145:	53                   	push   %ebx
80101146:	83 ec 1c             	sub    $0x1c,%esp
80101149:	8b 45 0c             	mov    0xc(%ebp),%eax
8010114c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010114f:	89 45 dc             	mov    %eax,-0x24(%ebp)
80101152:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80101155:	80 7b 09 00          	cmpb   $0x0,0x9(%ebx)
{
80101159:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(f->writable == 0)
8010115c:	0f 84 bd 00 00 00    	je     8010121f <filewrite+0xdf>
    return -1;
  if(f->type == FD_PIPE)
80101162:	8b 03                	mov    (%ebx),%eax
80101164:	83 f8 01             	cmp    $0x1,%eax
80101167:	0f 84 bf 00 00 00    	je     8010122c <filewrite+0xec>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010116d:	83 f8 02             	cmp    $0x2,%eax
80101170:	0f 85 c8 00 00 00    	jne    8010123e <filewrite+0xfe>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101176:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    int i = 0;
80101179:	31 f6                	xor    %esi,%esi
    while(i < n){
8010117b:	85 c0                	test   %eax,%eax
8010117d:	7f 30                	jg     801011af <filewrite+0x6f>
8010117f:	e9 94 00 00 00       	jmp    80101218 <filewrite+0xd8>
80101184:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101188:	01 43 14             	add    %eax,0x14(%ebx)
      iunlock(f->ip);
8010118b:	83 ec 0c             	sub    $0xc,%esp
8010118e:	ff 73 10             	push   0x10(%ebx)
        f->off += r;
80101191:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101194:	e8 77 07 00 00       	call   80101910 <iunlock>
      end_op();
80101199:	e8 e2 1c 00 00       	call   80102e80 <end_op>

      if(r < 0)
        break;
      if(r != n1)
8010119e:	8b 45 e0             	mov    -0x20(%ebp),%eax
801011a1:	83 c4 10             	add    $0x10,%esp
801011a4:	39 c7                	cmp    %eax,%edi
801011a6:	75 5c                	jne    80101204 <filewrite+0xc4>
        panic("short filewrite");
      i += r;
801011a8:	01 fe                	add    %edi,%esi
    while(i < n){
801011aa:	39 75 e4             	cmp    %esi,-0x1c(%ebp)
801011ad:	7e 69                	jle    80101218 <filewrite+0xd8>
      int n1 = n - i;
801011af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801011b2:	b8 00 06 00 00       	mov    $0x600,%eax
801011b7:	29 f7                	sub    %esi,%edi
801011b9:	39 c7                	cmp    %eax,%edi
801011bb:	0f 4f f8             	cmovg  %eax,%edi
      begin_op();
801011be:	e8 4d 1c 00 00       	call   80102e10 <begin_op>
      ilock(f->ip);
801011c3:	83 ec 0c             	sub    $0xc,%esp
801011c6:	ff 73 10             	push   0x10(%ebx)
801011c9:	e8 62 06 00 00       	call   80101830 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
801011ce:	8b 45 dc             	mov    -0x24(%ebp),%eax
801011d1:	57                   	push   %edi
801011d2:	ff 73 14             	push   0x14(%ebx)
801011d5:	01 f0                	add    %esi,%eax
801011d7:	50                   	push   %eax
801011d8:	ff 73 10             	push   0x10(%ebx)
801011db:	e8 60 0a 00 00       	call   80101c40 <writei>
801011e0:	83 c4 20             	add    $0x20,%esp
801011e3:	85 c0                	test   %eax,%eax
801011e5:	7f a1                	jg     80101188 <filewrite+0x48>
      iunlock(f->ip);
801011e7:	83 ec 0c             	sub    $0xc,%esp
801011ea:	ff 73 10             	push   0x10(%ebx)
801011ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801011f0:	e8 1b 07 00 00       	call   80101910 <iunlock>
      end_op();
801011f5:	e8 86 1c 00 00       	call   80102e80 <end_op>
      if(r < 0)
801011fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801011fd:	83 c4 10             	add    $0x10,%esp
80101200:	85 c0                	test   %eax,%eax
80101202:	75 1b                	jne    8010121f <filewrite+0xdf>
        panic("short filewrite");
80101204:	83 ec 0c             	sub    $0xc,%esp
80101207:	68 cf 77 10 80       	push   $0x801077cf
8010120c:	e8 6f f1 ff ff       	call   80100380 <panic>
80101211:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    }
    return i == n ? n : -1;
80101218:	89 f0                	mov    %esi,%eax
8010121a:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
8010121d:	74 05                	je     80101224 <filewrite+0xe4>
8010121f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
80101224:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101227:	5b                   	pop    %ebx
80101228:	5e                   	pop    %esi
80101229:	5f                   	pop    %edi
8010122a:	5d                   	pop    %ebp
8010122b:	c3                   	ret    
    return pipewrite(f->pipe, addr, n);
8010122c:	8b 43 0c             	mov    0xc(%ebx),%eax
8010122f:	89 45 08             	mov    %eax,0x8(%ebp)
}
80101232:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101235:	5b                   	pop    %ebx
80101236:	5e                   	pop    %esi
80101237:	5f                   	pop    %edi
80101238:	5d                   	pop    %ebp
    return pipewrite(f->pipe, addr, n);
80101239:	e9 42 24 00 00       	jmp    80103680 <pipewrite>
  panic("filewrite");
8010123e:	83 ec 0c             	sub    $0xc,%esp
80101241:	68 d5 77 10 80       	push   $0x801077d5
80101246:	e8 35 f1 ff ff       	call   80100380 <panic>
8010124b:	66 90                	xchg   %ax,%ax
8010124d:	66 90                	xchg   %ax,%ax
8010124f:	90                   	nop

80101250 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
80101250:	55                   	push   %ebp
80101251:	89 c1                	mov    %eax,%ecx
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
80101253:	89 d0                	mov    %edx,%eax
80101255:	c1 e8 0c             	shr    $0xc,%eax
80101258:	03 05 94 26 11 80    	add    0x80112694,%eax
{
8010125e:	89 e5                	mov    %esp,%ebp
80101260:	56                   	push   %esi
80101261:	53                   	push   %ebx
80101262:	89 d3                	mov    %edx,%ebx
  bp = bread(dev, BBLOCK(b, sb));
80101264:	83 ec 08             	sub    $0x8,%esp
80101267:	50                   	push   %eax
80101268:	51                   	push   %ecx
80101269:	e8 62 ee ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010126e:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
80101270:	c1 fb 03             	sar    $0x3,%ebx
80101273:	83 c4 10             	add    $0x10,%esp
  bp = bread(dev, BBLOCK(b, sb));
80101276:	89 c6                	mov    %eax,%esi
  m = 1 << (bi % 8);
80101278:	83 e1 07             	and    $0x7,%ecx
8010127b:	b8 01 00 00 00       	mov    $0x1,%eax
  if((bp->data[bi/8] & m) == 0)
80101280:	81 e3 ff 01 00 00    	and    $0x1ff,%ebx
  m = 1 << (bi % 8);
80101286:	d3 e0                	shl    %cl,%eax
  if((bp->data[bi/8] & m) == 0)
80101288:	0f b6 4c 1e 5c       	movzbl 0x5c(%esi,%ebx,1),%ecx
8010128d:	85 c1                	test   %eax,%ecx
8010128f:	74 23                	je     801012b4 <bfree+0x64>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101291:	f7 d0                	not    %eax
  log_write(bp);
80101293:	83 ec 0c             	sub    $0xc,%esp
  bp->data[bi/8] &= ~m;
80101296:	21 c8                	and    %ecx,%eax
80101298:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010129c:	56                   	push   %esi
8010129d:	e8 4e 1d 00 00       	call   80102ff0 <log_write>
  brelse(bp);
801012a2:	89 34 24             	mov    %esi,(%esp)
801012a5:	e8 46 ef ff ff       	call   801001f0 <brelse>
}
801012aa:	83 c4 10             	add    $0x10,%esp
801012ad:	8d 65 f8             	lea    -0x8(%ebp),%esp
801012b0:	5b                   	pop    %ebx
801012b1:	5e                   	pop    %esi
801012b2:	5d                   	pop    %ebp
801012b3:	c3                   	ret    
    panic("freeing free block");
801012b4:	83 ec 0c             	sub    $0xc,%esp
801012b7:	68 df 77 10 80       	push   $0x801077df
801012bc:	e8 bf f0 ff ff       	call   80100380 <panic>
801012c1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801012cf:	90                   	nop

801012d0 <balloc>:
{
801012d0:	55                   	push   %ebp
801012d1:	89 e5                	mov    %esp,%ebp
801012d3:	57                   	push   %edi
801012d4:	56                   	push   %esi
801012d5:	53                   	push   %ebx
801012d6:	83 ec 1c             	sub    $0x1c,%esp
  for(b = 0; b < sb.size; b += BPB){
801012d9:	8b 0d 7c 26 11 80    	mov    0x8011267c,%ecx
{
801012df:	89 45 d8             	mov    %eax,-0x28(%ebp)
  for(b = 0; b < sb.size; b += BPB){
801012e2:	85 c9                	test   %ecx,%ecx
801012e4:	0f 84 87 00 00 00    	je     80101371 <balloc+0xa1>
801012ea:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
801012f1:	8b 75 dc             	mov    -0x24(%ebp),%esi
801012f4:	83 ec 08             	sub    $0x8,%esp
801012f7:	89 f0                	mov    %esi,%eax
801012f9:	c1 f8 0c             	sar    $0xc,%eax
801012fc:	03 05 94 26 11 80    	add    0x80112694,%eax
80101302:	50                   	push   %eax
80101303:	ff 75 d8             	push   -0x28(%ebp)
80101306:	e8 c5 ed ff ff       	call   801000d0 <bread>
8010130b:	83 c4 10             	add    $0x10,%esp
8010130e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101311:	a1 7c 26 11 80       	mov    0x8011267c,%eax
80101316:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101319:	31 c0                	xor    %eax,%eax
8010131b:	eb 2f                	jmp    8010134c <balloc+0x7c>
8010131d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101320:	89 c1                	mov    %eax,%ecx
80101322:	bb 01 00 00 00       	mov    $0x1,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101327:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      m = 1 << (bi % 8);
8010132a:	83 e1 07             	and    $0x7,%ecx
8010132d:	d3 e3                	shl    %cl,%ebx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010132f:	89 c1                	mov    %eax,%ecx
80101331:	c1 f9 03             	sar    $0x3,%ecx
80101334:	0f b6 7c 0a 5c       	movzbl 0x5c(%edx,%ecx,1),%edi
80101339:	89 fa                	mov    %edi,%edx
8010133b:	85 df                	test   %ebx,%edi
8010133d:	74 41                	je     80101380 <balloc+0xb0>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010133f:	83 c0 01             	add    $0x1,%eax
80101342:	83 c6 01             	add    $0x1,%esi
80101345:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010134a:	74 05                	je     80101351 <balloc+0x81>
8010134c:	39 75 e0             	cmp    %esi,-0x20(%ebp)
8010134f:	77 cf                	ja     80101320 <balloc+0x50>
    brelse(bp);
80101351:	83 ec 0c             	sub    $0xc,%esp
80101354:	ff 75 e4             	push   -0x1c(%ebp)
80101357:	e8 94 ee ff ff       	call   801001f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
8010135c:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101363:	83 c4 10             	add    $0x10,%esp
80101366:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101369:	39 05 7c 26 11 80    	cmp    %eax,0x8011267c
8010136f:	77 80                	ja     801012f1 <balloc+0x21>
  panic("balloc: out of blocks");
80101371:	83 ec 0c             	sub    $0xc,%esp
80101374:	68 f2 77 10 80       	push   $0x801077f2
80101379:	e8 02 f0 ff ff       	call   80100380 <panic>
8010137e:	66 90                	xchg   %ax,%ax
        bp->data[bi/8] |= m;  // Mark block in use.
80101380:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
80101383:	83 ec 0c             	sub    $0xc,%esp
        bp->data[bi/8] |= m;  // Mark block in use.
80101386:	09 da                	or     %ebx,%edx
80101388:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
8010138c:	57                   	push   %edi
8010138d:	e8 5e 1c 00 00       	call   80102ff0 <log_write>
        brelse(bp);
80101392:	89 3c 24             	mov    %edi,(%esp)
80101395:	e8 56 ee ff ff       	call   801001f0 <brelse>
  bp = bread(dev, bno);
8010139a:	58                   	pop    %eax
8010139b:	5a                   	pop    %edx
8010139c:	56                   	push   %esi
8010139d:	ff 75 d8             	push   -0x28(%ebp)
801013a0:	e8 2b ed ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801013a5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, bno);
801013a8:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801013aa:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ad:	68 00 02 00 00       	push   $0x200
801013b2:	6a 00                	push   $0x0
801013b4:	50                   	push   %eax
801013b5:	e8 06 36 00 00       	call   801049c0 <memset>
  log_write(bp);
801013ba:	89 1c 24             	mov    %ebx,(%esp)
801013bd:	e8 2e 1c 00 00       	call   80102ff0 <log_write>
  brelse(bp);
801013c2:	89 1c 24             	mov    %ebx,(%esp)
801013c5:	e8 26 ee ff ff       	call   801001f0 <brelse>
}
801013ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
801013cd:	89 f0                	mov    %esi,%eax
801013cf:	5b                   	pop    %ebx
801013d0:	5e                   	pop    %esi
801013d1:	5f                   	pop    %edi
801013d2:	5d                   	pop    %ebp
801013d3:	c3                   	ret    
801013d4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801013db:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013df:	90                   	nop

801013e0 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
801013e0:	55                   	push   %ebp
801013e1:	89 e5                	mov    %esp,%ebp
801013e3:	57                   	push   %edi
801013e4:	89 c7                	mov    %eax,%edi
801013e6:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
801013e7:	31 f6                	xor    %esi,%esi
{
801013e9:	53                   	push   %ebx
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ea:	bb 94 09 11 80       	mov    $0x80110994,%ebx
{
801013ef:	83 ec 28             	sub    $0x28,%esp
801013f2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  acquire(&icache.lock);
801013f5:	68 60 09 11 80       	push   $0x80110960
801013fa:	e8 01 35 00 00       	call   80104900 <acquire>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801013ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  acquire(&icache.lock);
80101402:	83 c4 10             	add    $0x10,%esp
80101405:	eb 1b                	jmp    80101422 <iget+0x42>
80101407:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010140e:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101410:	39 3b                	cmp    %edi,(%ebx)
80101412:	74 6c                	je     80101480 <iget+0xa0>
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101414:	81 c3 94 00 00 00    	add    $0x94,%ebx
8010141a:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
80101420:	73 26                	jae    80101448 <iget+0x68>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101422:	8b 43 08             	mov    0x8(%ebx),%eax
80101425:	85 c0                	test   %eax,%eax
80101427:	7f e7                	jg     80101410 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101429:	85 f6                	test   %esi,%esi
8010142b:	75 e7                	jne    80101414 <iget+0x34>
8010142d:	85 c0                	test   %eax,%eax
8010142f:	75 76                	jne    801014a7 <iget+0xc7>
80101431:	89 de                	mov    %ebx,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101433:	81 c3 94 00 00 00    	add    $0x94,%ebx
80101439:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
8010143f:	72 e1                	jb     80101422 <iget+0x42>
80101441:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
80101448:	85 f6                	test   %esi,%esi
8010144a:	74 79                	je     801014c5 <iget+0xe5>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
8010144c:	83 ec 0c             	sub    $0xc,%esp
  ip->dev = dev;
8010144f:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
80101451:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
80101454:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
8010145b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
80101462:	68 60 09 11 80       	push   $0x80110960
80101467:	e8 34 34 00 00       	call   801048a0 <release>

  return ip;
8010146c:	83 c4 10             	add    $0x10,%esp
}
8010146f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101472:	89 f0                	mov    %esi,%eax
80101474:	5b                   	pop    %ebx
80101475:	5e                   	pop    %esi
80101476:	5f                   	pop    %edi
80101477:	5d                   	pop    %ebp
80101478:	c3                   	ret    
80101479:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101480:	39 53 04             	cmp    %edx,0x4(%ebx)
80101483:	75 8f                	jne    80101414 <iget+0x34>
      release(&icache.lock);
80101485:	83 ec 0c             	sub    $0xc,%esp
      ip->ref++;
80101488:	83 c0 01             	add    $0x1,%eax
      return ip;
8010148b:	89 de                	mov    %ebx,%esi
      release(&icache.lock);
8010148d:	68 60 09 11 80       	push   $0x80110960
      ip->ref++;
80101492:	89 43 08             	mov    %eax,0x8(%ebx)
      release(&icache.lock);
80101495:	e8 06 34 00 00       	call   801048a0 <release>
      return ip;
8010149a:	83 c4 10             	add    $0x10,%esp
}
8010149d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801014a0:	89 f0                	mov    %esi,%eax
801014a2:	5b                   	pop    %ebx
801014a3:	5e                   	pop    %esi
801014a4:	5f                   	pop    %edi
801014a5:	5d                   	pop    %ebp
801014a6:	c3                   	ret    
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
801014a7:	81 c3 94 00 00 00    	add    $0x94,%ebx
801014ad:	81 fb 7c 26 11 80    	cmp    $0x8011267c,%ebx
801014b3:	73 10                	jae    801014c5 <iget+0xe5>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
801014b5:	8b 43 08             	mov    0x8(%ebx),%eax
801014b8:	85 c0                	test   %eax,%eax
801014ba:	0f 8f 50 ff ff ff    	jg     80101410 <iget+0x30>
801014c0:	e9 68 ff ff ff       	jmp    8010142d <iget+0x4d>
    panic("iget: no inodes");
801014c5:	83 ec 0c             	sub    $0xc,%esp
801014c8:	68 08 78 10 80       	push   $0x80107808
801014cd:	e8 ae ee ff ff       	call   80100380 <panic>
801014d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801014d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801014e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801014e0:	55                   	push   %ebp
801014e1:	89 e5                	mov    %esp,%ebp
801014e3:	57                   	push   %edi
801014e4:	56                   	push   %esi
801014e5:	89 c6                	mov    %eax,%esi
801014e7:	53                   	push   %ebx
801014e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801014eb:	83 fa 0b             	cmp    $0xb,%edx
801014ee:	0f 86 8c 00 00 00    	jbe    80101580 <bmap+0xa0>
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
801014f4:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
801014f7:	83 fb 7f             	cmp    $0x7f,%ebx
801014fa:	0f 87 a2 00 00 00    	ja     801015a2 <bmap+0xc2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101500:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101506:	85 c0                	test   %eax,%eax
80101508:	74 5e                	je     80101568 <bmap+0x88>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010150a:	83 ec 08             	sub    $0x8,%esp
8010150d:	50                   	push   %eax
8010150e:	ff 36                	push   (%esi)
80101510:	e8 bb eb ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101515:	83 c4 10             	add    $0x10,%esp
80101518:	8d 5c 98 5c          	lea    0x5c(%eax,%ebx,4),%ebx
    bp = bread(ip->dev, addr);
8010151c:	89 c2                	mov    %eax,%edx
    if((addr = a[bn]) == 0){
8010151e:	8b 3b                	mov    (%ebx),%edi
80101520:	85 ff                	test   %edi,%edi
80101522:	74 1c                	je     80101540 <bmap+0x60>
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101524:	83 ec 0c             	sub    $0xc,%esp
80101527:	52                   	push   %edx
80101528:	e8 c3 ec ff ff       	call   801001f0 <brelse>
8010152d:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101530:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101533:	89 f8                	mov    %edi,%eax
80101535:	5b                   	pop    %ebx
80101536:	5e                   	pop    %esi
80101537:	5f                   	pop    %edi
80101538:	5d                   	pop    %ebp
80101539:	c3                   	ret    
8010153a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
      a[bn] = addr = balloc(ip->dev);
80101543:	8b 06                	mov    (%esi),%eax
80101545:	e8 86 fd ff ff       	call   801012d0 <balloc>
      log_write(bp);
8010154a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010154d:	83 ec 0c             	sub    $0xc,%esp
      a[bn] = addr = balloc(ip->dev);
80101550:	89 03                	mov    %eax,(%ebx)
80101552:	89 c7                	mov    %eax,%edi
      log_write(bp);
80101554:	52                   	push   %edx
80101555:	e8 96 1a 00 00       	call   80102ff0 <log_write>
8010155a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
8010155d:	83 c4 10             	add    $0x10,%esp
80101560:	eb c2                	jmp    80101524 <bmap+0x44>
80101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101568:	8b 06                	mov    (%esi),%eax
8010156a:	e8 61 fd ff ff       	call   801012d0 <balloc>
8010156f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101575:	eb 93                	jmp    8010150a <bmap+0x2a>
80101577:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010157e:	66 90                	xchg   %ax,%ax
    if((addr = ip->addrs[bn]) == 0)
80101580:	8d 5a 14             	lea    0x14(%edx),%ebx
80101583:	8b 7c 98 0c          	mov    0xc(%eax,%ebx,4),%edi
80101587:	85 ff                	test   %edi,%edi
80101589:	75 a5                	jne    80101530 <bmap+0x50>
      ip->addrs[bn] = addr = balloc(ip->dev);
8010158b:	8b 00                	mov    (%eax),%eax
8010158d:	e8 3e fd ff ff       	call   801012d0 <balloc>
80101592:	89 44 9e 0c          	mov    %eax,0xc(%esi,%ebx,4)
80101596:	89 c7                	mov    %eax,%edi
}
80101598:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010159b:	5b                   	pop    %ebx
8010159c:	89 f8                	mov    %edi,%eax
8010159e:	5e                   	pop    %esi
8010159f:	5f                   	pop    %edi
801015a0:	5d                   	pop    %ebp
801015a1:	c3                   	ret    
  panic("bmap: out of range");
801015a2:	83 ec 0c             	sub    $0xc,%esp
801015a5:	68 18 78 10 80       	push   $0x80107818
801015aa:	e8 d1 ed ff ff       	call   80100380 <panic>
801015af:	90                   	nop

801015b0 <readsb>:
{
801015b0:	55                   	push   %ebp
801015b1:	89 e5                	mov    %esp,%ebp
801015b3:	56                   	push   %esi
801015b4:	53                   	push   %ebx
801015b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  bp = bread(dev, 1);
801015b8:	83 ec 08             	sub    $0x8,%esp
801015bb:	6a 01                	push   $0x1
801015bd:	ff 75 08             	push   0x8(%ebp)
801015c0:	e8 0b eb ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801015c5:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
801015c8:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801015ca:	8d 40 5c             	lea    0x5c(%eax),%eax
801015cd:	6a 1c                	push   $0x1c
801015cf:	50                   	push   %eax
801015d0:	56                   	push   %esi
801015d1:	e8 8a 34 00 00       	call   80104a60 <memmove>
  brelse(bp);
801015d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801015d9:	83 c4 10             	add    $0x10,%esp
}
801015dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801015df:	5b                   	pop    %ebx
801015e0:	5e                   	pop    %esi
801015e1:	5d                   	pop    %ebp
  brelse(bp);
801015e2:	e9 09 ec ff ff       	jmp    801001f0 <brelse>
801015e7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801015ee:	66 90                	xchg   %ax,%ax

801015f0 <iinit>:
{
801015f0:	55                   	push   %ebp
801015f1:	89 e5                	mov    %esp,%ebp
801015f3:	53                   	push   %ebx
801015f4:	bb a0 09 11 80       	mov    $0x801109a0,%ebx
801015f9:	83 ec 0c             	sub    $0xc,%esp
  initlock(&icache.lock, "icache");
801015fc:	68 2b 78 10 80       	push   $0x8010782b
80101601:	68 60 09 11 80       	push   $0x80110960
80101606:	e8 25 31 00 00       	call   80104730 <initlock>
  for(i = 0; i < NINODE; i++) {
8010160b:	83 c4 10             	add    $0x10,%esp
8010160e:	66 90                	xchg   %ax,%ax
    initsleeplock(&icache.inode[i].lock, "inode");
80101610:	83 ec 08             	sub    $0x8,%esp
80101613:	68 32 78 10 80       	push   $0x80107832
80101618:	53                   	push   %ebx
  for(i = 0; i < NINODE; i++) {
80101619:	81 c3 94 00 00 00    	add    $0x94,%ebx
    initsleeplock(&icache.inode[i].lock, "inode");
8010161f:	e8 dc 2f 00 00       	call   80104600 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
80101624:	83 c4 10             	add    $0x10,%esp
80101627:	81 fb 88 26 11 80    	cmp    $0x80112688,%ebx
8010162d:	75 e1                	jne    80101610 <iinit+0x20>
  bp = bread(dev, 1);
8010162f:	83 ec 08             	sub    $0x8,%esp
80101632:	6a 01                	push   $0x1
80101634:	ff 75 08             	push   0x8(%ebp)
80101637:	e8 94 ea ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
8010163c:	83 c4 0c             	add    $0xc,%esp
  bp = bread(dev, 1);
8010163f:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
80101641:	8d 40 5c             	lea    0x5c(%eax),%eax
80101644:	6a 1c                	push   $0x1c
80101646:	50                   	push   %eax
80101647:	68 7c 26 11 80       	push   $0x8011267c
8010164c:	e8 0f 34 00 00       	call   80104a60 <memmove>
  brelse(bp);
80101651:	89 1c 24             	mov    %ebx,(%esp)
80101654:	e8 97 eb ff ff       	call   801001f0 <brelse>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
80101659:	ff 35 94 26 11 80    	push   0x80112694
8010165f:	ff 35 90 26 11 80    	push   0x80112690
80101665:	ff 35 8c 26 11 80    	push   0x8011268c
8010166b:	ff 35 88 26 11 80    	push   0x80112688
80101671:	ff 35 84 26 11 80    	push   0x80112684
80101677:	ff 35 80 26 11 80    	push   0x80112680
8010167d:	ff 35 7c 26 11 80    	push   0x8011267c
80101683:	68 98 78 10 80       	push   $0x80107898
80101688:	e8 13 f0 ff ff       	call   801006a0 <cprintf>
}
8010168d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101690:	83 c4 30             	add    $0x30,%esp
80101693:	c9                   	leave  
80101694:	c3                   	ret    
80101695:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010169c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801016a0 <ialloc>:
{
801016a0:	55                   	push   %ebp
801016a1:	89 e5                	mov    %esp,%ebp
801016a3:	57                   	push   %edi
801016a4:	56                   	push   %esi
801016a5:	53                   	push   %ebx
801016a6:	83 ec 1c             	sub    $0x1c,%esp
801016a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  for(inum = 1; inum < sb.ninodes; inum++){
801016ac:	83 3d 84 26 11 80 01 	cmpl   $0x1,0x80112684
{
801016b3:	8b 75 08             	mov    0x8(%ebp),%esi
801016b6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
801016b9:	0f 86 9b 00 00 00    	jbe    8010175a <ialloc+0xba>
801016bf:	bf 01 00 00 00       	mov    $0x1,%edi
801016c4:	eb 21                	jmp    801016e7 <ialloc+0x47>
801016c6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801016cd:	8d 76 00             	lea    0x0(%esi),%esi
    brelse(bp);
801016d0:	83 ec 0c             	sub    $0xc,%esp
  for(inum = 1; inum < sb.ninodes; inum++){
801016d3:	83 c7 01             	add    $0x1,%edi
    brelse(bp);
801016d6:	53                   	push   %ebx
801016d7:	e8 14 eb ff ff       	call   801001f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
801016dc:	83 c4 10             	add    $0x10,%esp
801016df:	3b 3d 84 26 11 80    	cmp    0x80112684,%edi
801016e5:	73 73                	jae    8010175a <ialloc+0xba>
    bp = bread(dev, IBLOCK(inum, sb));
801016e7:	89 f8                	mov    %edi,%eax
801016e9:	83 ec 08             	sub    $0x8,%esp
801016ec:	c1 e8 02             	shr    $0x2,%eax
801016ef:	03 05 90 26 11 80    	add    0x80112690,%eax
801016f5:	50                   	push   %eax
801016f6:	56                   	push   %esi
801016f7:	e8 d4 e9 ff ff       	call   801000d0 <bread>
    if(dip->type == 0){  // a free inode
801016fc:	83 c4 10             	add    $0x10,%esp
    bp = bread(dev, IBLOCK(inum, sb));
801016ff:	89 c3                	mov    %eax,%ebx
    dip = (struct dinode*)bp->data + inum%IPB;
80101701:	89 f8                	mov    %edi,%eax
80101703:	83 e0 03             	and    $0x3,%eax
80101706:	c1 e0 07             	shl    $0x7,%eax
80101709:	8d 4c 03 5c          	lea    0x5c(%ebx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010170d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101711:	75 bd                	jne    801016d0 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101713:	83 ec 04             	sub    $0x4,%esp
80101716:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101719:	68 80 00 00 00       	push   $0x80
8010171e:	6a 00                	push   $0x0
80101720:	51                   	push   %ecx
80101721:	e8 9a 32 00 00       	call   801049c0 <memset>
      dip->type = type;
80101726:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
8010172a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010172d:	66 89 01             	mov    %ax,(%ecx)
      dip->mode = 7;
80101730:	c7 41 40 07 00 00 00 	movl   $0x7,0x40(%ecx)
      log_write(bp);   // mark it allocated on the disk
80101737:	89 1c 24             	mov    %ebx,(%esp)
8010173a:	e8 b1 18 00 00       	call   80102ff0 <log_write>
      brelse(bp);
8010173f:	89 1c 24             	mov    %ebx,(%esp)
80101742:	e8 a9 ea ff ff       	call   801001f0 <brelse>
      return iget(dev, inum);
80101747:	83 c4 10             	add    $0x10,%esp
}
8010174a:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return iget(dev, inum);
8010174d:	89 fa                	mov    %edi,%edx
}
8010174f:	5b                   	pop    %ebx
      return iget(dev, inum);
80101750:	89 f0                	mov    %esi,%eax
}
80101752:	5e                   	pop    %esi
80101753:	5f                   	pop    %edi
80101754:	5d                   	pop    %ebp
      return iget(dev, inum);
80101755:	e9 86 fc ff ff       	jmp    801013e0 <iget>
  panic("ialloc: no inodes");
8010175a:	83 ec 0c             	sub    $0xc,%esp
8010175d:	68 38 78 10 80       	push   $0x80107838
80101762:	e8 19 ec ff ff       	call   80100380 <panic>
80101767:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010176e:	66 90                	xchg   %ax,%ax

80101770 <iupdate>:
{
80101770:	55                   	push   %ebp
80101771:	89 e5                	mov    %esp,%ebp
80101773:	56                   	push   %esi
80101774:	53                   	push   %ebx
80101775:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101778:	8b 43 04             	mov    0x4(%ebx),%eax
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010177b:	83 c3 5c             	add    $0x5c,%ebx
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010177e:	83 ec 08             	sub    $0x8,%esp
80101781:	c1 e8 02             	shr    $0x2,%eax
80101784:	03 05 90 26 11 80    	add    0x80112690,%eax
8010178a:	50                   	push   %eax
8010178b:	ff 73 a4             	push   -0x5c(%ebx)
8010178e:	e8 3d e9 ff ff       	call   801000d0 <bread>
  dip->type = ip->type;
80101793:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101797:	83 c4 0c             	add    $0xc,%esp
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010179a:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
8010179c:	8b 43 a8             	mov    -0x58(%ebx),%eax
8010179f:	83 e0 03             	and    $0x3,%eax
801017a2:	c1 e0 07             	shl    $0x7,%eax
801017a5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801017a9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801017ac:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017b0:	83 c0 0c             	add    $0xc,%eax
  dip->major = ip->major;
801017b3:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
801017b7:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
801017bb:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
801017bf:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
801017c3:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
801017c7:	8b 53 fc             	mov    -0x4(%ebx),%edx
801017ca:	89 50 fc             	mov    %edx,-0x4(%eax)
  dip->mode = ip->mode;
801017cd:	8b 53 34             	mov    0x34(%ebx),%edx
801017d0:	89 50 34             	mov    %edx,0x34(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801017d3:	6a 34                	push   $0x34
801017d5:	53                   	push   %ebx
801017d6:	50                   	push   %eax
801017d7:	e8 84 32 00 00       	call   80104a60 <memmove>
  log_write(bp);
801017dc:	89 34 24             	mov    %esi,(%esp)
801017df:	e8 0c 18 00 00       	call   80102ff0 <log_write>
  brelse(bp);
801017e4:	89 75 08             	mov    %esi,0x8(%ebp)
801017e7:	83 c4 10             	add    $0x10,%esp
}
801017ea:	8d 65 f8             	lea    -0x8(%ebp),%esp
801017ed:	5b                   	pop    %ebx
801017ee:	5e                   	pop    %esi
801017ef:	5d                   	pop    %ebp
  brelse(bp);
801017f0:	e9 fb e9 ff ff       	jmp    801001f0 <brelse>
801017f5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801017fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101800 <idup>:
{
80101800:	55                   	push   %ebp
80101801:	89 e5                	mov    %esp,%ebp
80101803:	53                   	push   %ebx
80101804:	83 ec 10             	sub    $0x10,%esp
80101807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010180a:	68 60 09 11 80       	push   $0x80110960
8010180f:	e8 ec 30 00 00       	call   80104900 <acquire>
  ip->ref++;
80101814:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101818:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
8010181f:	e8 7c 30 00 00       	call   801048a0 <release>
}
80101824:	89 d8                	mov    %ebx,%eax
80101826:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101829:	c9                   	leave  
8010182a:	c3                   	ret    
8010182b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010182f:	90                   	nop

80101830 <ilock>:
{
80101830:	55                   	push   %ebp
80101831:	89 e5                	mov    %esp,%ebp
80101833:	56                   	push   %esi
80101834:	53                   	push   %ebx
80101835:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || ip->ref < 1)
80101838:	85 db                	test   %ebx,%ebx
8010183a:	0f 84 c0 00 00 00    	je     80101900 <ilock+0xd0>
80101840:	8b 53 08             	mov    0x8(%ebx),%edx
80101843:	85 d2                	test   %edx,%edx
80101845:	0f 8e b5 00 00 00    	jle    80101900 <ilock+0xd0>
  acquiresleep(&ip->lock);
8010184b:	83 ec 0c             	sub    $0xc,%esp
8010184e:	8d 43 0c             	lea    0xc(%ebx),%eax
80101851:	50                   	push   %eax
80101852:	e8 e9 2d 00 00       	call   80104640 <acquiresleep>
  if(ip->valid == 0){
80101857:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010185a:	83 c4 10             	add    $0x10,%esp
8010185d:	85 c0                	test   %eax,%eax
8010185f:	74 0f                	je     80101870 <ilock+0x40>
}
80101861:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101864:	5b                   	pop    %ebx
80101865:	5e                   	pop    %esi
80101866:	5d                   	pop    %ebp
80101867:	c3                   	ret    
80101868:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010186f:	90                   	nop
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101870:	8b 43 04             	mov    0x4(%ebx),%eax
80101873:	83 ec 08             	sub    $0x8,%esp
80101876:	c1 e8 02             	shr    $0x2,%eax
80101879:	03 05 90 26 11 80    	add    0x80112690,%eax
8010187f:	50                   	push   %eax
80101880:	ff 33                	push   (%ebx)
80101882:	e8 49 e8 ff ff       	call   801000d0 <bread>
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101887:	83 c4 0c             	add    $0xc,%esp
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010188a:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
8010188c:	8b 43 04             	mov    0x4(%ebx),%eax
8010188f:	83 e0 03             	and    $0x3,%eax
80101892:	c1 e0 07             	shl    $0x7,%eax
80101895:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
80101899:	0f b7 10             	movzwl (%eax),%edx
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
8010189c:	83 c0 0c             	add    $0xc,%eax
    ip->type = dip->type;
8010189f:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801018a3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801018a7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801018ab:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801018af:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801018b3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801018b7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801018bb:	8b 50 fc             	mov    -0x4(%eax),%edx
801018be:	89 53 58             	mov    %edx,0x58(%ebx)
    ip->mode = dip->mode;
801018c1:	8b 50 34             	mov    0x34(%eax),%edx
801018c4:	89 93 90 00 00 00    	mov    %edx,0x90(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801018ca:	6a 34                	push   $0x34
801018cc:	50                   	push   %eax
801018cd:	8d 43 5c             	lea    0x5c(%ebx),%eax
801018d0:	50                   	push   %eax
801018d1:	e8 8a 31 00 00       	call   80104a60 <memmove>
    brelse(bp);
801018d6:	89 34 24             	mov    %esi,(%esp)
801018d9:	e8 12 e9 ff ff       	call   801001f0 <brelse>
    if(ip->type == 0)
801018de:	83 c4 10             	add    $0x10,%esp
801018e1:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->valid = 1;
801018e6:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
801018ed:	0f 85 6e ff ff ff    	jne    80101861 <ilock+0x31>
      panic("ilock: no type");
801018f3:	83 ec 0c             	sub    $0xc,%esp
801018f6:	68 50 78 10 80       	push   $0x80107850
801018fb:	e8 80 ea ff ff       	call   80100380 <panic>
    panic("ilock");
80101900:	83 ec 0c             	sub    $0xc,%esp
80101903:	68 4a 78 10 80       	push   $0x8010784a
80101908:	e8 73 ea ff ff       	call   80100380 <panic>
8010190d:	8d 76 00             	lea    0x0(%esi),%esi

80101910 <iunlock>:
{
80101910:	55                   	push   %ebp
80101911:	89 e5                	mov    %esp,%ebp
80101913:	56                   	push   %esi
80101914:	53                   	push   %ebx
80101915:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101918:	85 db                	test   %ebx,%ebx
8010191a:	74 28                	je     80101944 <iunlock+0x34>
8010191c:	83 ec 0c             	sub    $0xc,%esp
8010191f:	8d 73 0c             	lea    0xc(%ebx),%esi
80101922:	56                   	push   %esi
80101923:	e8 b8 2d 00 00       	call   801046e0 <holdingsleep>
80101928:	83 c4 10             	add    $0x10,%esp
8010192b:	85 c0                	test   %eax,%eax
8010192d:	74 15                	je     80101944 <iunlock+0x34>
8010192f:	8b 43 08             	mov    0x8(%ebx),%eax
80101932:	85 c0                	test   %eax,%eax
80101934:	7e 0e                	jle    80101944 <iunlock+0x34>
  releasesleep(&ip->lock);
80101936:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101939:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010193c:	5b                   	pop    %ebx
8010193d:	5e                   	pop    %esi
8010193e:	5d                   	pop    %ebp
  releasesleep(&ip->lock);
8010193f:	e9 5c 2d 00 00       	jmp    801046a0 <releasesleep>
    panic("iunlock");
80101944:	83 ec 0c             	sub    $0xc,%esp
80101947:	68 5f 78 10 80       	push   $0x8010785f
8010194c:	e8 2f ea ff ff       	call   80100380 <panic>
80101951:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101958:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010195f:	90                   	nop

80101960 <iput>:
{
80101960:	55                   	push   %ebp
80101961:	89 e5                	mov    %esp,%ebp
80101963:	57                   	push   %edi
80101964:	56                   	push   %esi
80101965:	53                   	push   %ebx
80101966:	83 ec 28             	sub    $0x28,%esp
80101969:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquiresleep(&ip->lock);
8010196c:	8d 7b 0c             	lea    0xc(%ebx),%edi
8010196f:	57                   	push   %edi
80101970:	e8 cb 2c 00 00       	call   80104640 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
80101975:	8b 53 4c             	mov    0x4c(%ebx),%edx
80101978:	83 c4 10             	add    $0x10,%esp
8010197b:	85 d2                	test   %edx,%edx
8010197d:	74 07                	je     80101986 <iput+0x26>
8010197f:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80101984:	74 32                	je     801019b8 <iput+0x58>
  releasesleep(&ip->lock);
80101986:	83 ec 0c             	sub    $0xc,%esp
80101989:	57                   	push   %edi
8010198a:	e8 11 2d 00 00       	call   801046a0 <releasesleep>
  acquire(&icache.lock);
8010198f:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101996:	e8 65 2f 00 00       	call   80104900 <acquire>
  ip->ref--;
8010199b:	83 6b 08 01          	subl   $0x1,0x8(%ebx)
  release(&icache.lock);
8010199f:	83 c4 10             	add    $0x10,%esp
801019a2:	c7 45 08 60 09 11 80 	movl   $0x80110960,0x8(%ebp)
}
801019a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801019ac:	5b                   	pop    %ebx
801019ad:	5e                   	pop    %esi
801019ae:	5f                   	pop    %edi
801019af:	5d                   	pop    %ebp
  release(&icache.lock);
801019b0:	e9 eb 2e 00 00       	jmp    801048a0 <release>
801019b5:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&icache.lock);
801019b8:	83 ec 0c             	sub    $0xc,%esp
801019bb:	68 60 09 11 80       	push   $0x80110960
801019c0:	e8 3b 2f 00 00       	call   80104900 <acquire>
    int r = ip->ref;
801019c5:	8b 73 08             	mov    0x8(%ebx),%esi
    release(&icache.lock);
801019c8:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
801019cf:	e8 cc 2e 00 00       	call   801048a0 <release>
    if(r == 1){
801019d4:	83 c4 10             	add    $0x10,%esp
801019d7:	83 fe 01             	cmp    $0x1,%esi
801019da:	75 aa                	jne    80101986 <iput+0x26>
801019dc:	8d 8b 8c 00 00 00    	lea    0x8c(%ebx),%ecx
801019e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
801019e5:	8d 73 5c             	lea    0x5c(%ebx),%esi
801019e8:	89 cf                	mov    %ecx,%edi
801019ea:	eb 0b                	jmp    801019f7 <iput+0x97>
801019ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
801019f0:	83 c6 04             	add    $0x4,%esi
801019f3:	39 fe                	cmp    %edi,%esi
801019f5:	74 19                	je     80101a10 <iput+0xb0>
    if(ip->addrs[i]){
801019f7:	8b 16                	mov    (%esi),%edx
801019f9:	85 d2                	test   %edx,%edx
801019fb:	74 f3                	je     801019f0 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
801019fd:	8b 03                	mov    (%ebx),%eax
801019ff:	e8 4c f8 ff ff       	call   80101250 <bfree>
      ip->addrs[i] = 0;
80101a04:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80101a0a:	eb e4                	jmp    801019f0 <iput+0x90>
80101a0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101a10:	8b 83 8c 00 00 00    	mov    0x8c(%ebx),%eax
80101a16:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101a19:	85 c0                	test   %eax,%eax
80101a1b:	75 2d                	jne    80101a4a <iput+0xea>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
80101a1d:	83 ec 0c             	sub    $0xc,%esp
  ip->size = 0;
80101a20:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  iupdate(ip);
80101a27:	53                   	push   %ebx
80101a28:	e8 43 fd ff ff       	call   80101770 <iupdate>
      ip->type = 0;
80101a2d:	31 c0                	xor    %eax,%eax
80101a2f:	66 89 43 50          	mov    %ax,0x50(%ebx)
      iupdate(ip);
80101a33:	89 1c 24             	mov    %ebx,(%esp)
80101a36:	e8 35 fd ff ff       	call   80101770 <iupdate>
      ip->valid = 0;
80101a3b:	c7 43 4c 00 00 00 00 	movl   $0x0,0x4c(%ebx)
80101a42:	83 c4 10             	add    $0x10,%esp
80101a45:	e9 3c ff ff ff       	jmp    80101986 <iput+0x26>
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101a4a:	83 ec 08             	sub    $0x8,%esp
80101a4d:	50                   	push   %eax
80101a4e:	ff 33                	push   (%ebx)
80101a50:	e8 7b e6 ff ff       	call   801000d0 <bread>
80101a55:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101a58:	83 c4 10             	add    $0x10,%esp
80101a5b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
80101a61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    for(j = 0; j < NINDIRECT; j++){
80101a64:	8d 70 5c             	lea    0x5c(%eax),%esi
80101a67:	89 cf                	mov    %ecx,%edi
80101a69:	eb 0c                	jmp    80101a77 <iput+0x117>
80101a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101a6f:	90                   	nop
80101a70:	83 c6 04             	add    $0x4,%esi
80101a73:	39 f7                	cmp    %esi,%edi
80101a75:	74 0f                	je     80101a86 <iput+0x126>
      if(a[j])
80101a77:	8b 16                	mov    (%esi),%edx
80101a79:	85 d2                	test   %edx,%edx
80101a7b:	74 f3                	je     80101a70 <iput+0x110>
        bfree(ip->dev, a[j]);
80101a7d:	8b 03                	mov    (%ebx),%eax
80101a7f:	e8 cc f7 ff ff       	call   80101250 <bfree>
80101a84:	eb ea                	jmp    80101a70 <iput+0x110>
    brelse(bp);
80101a86:	83 ec 0c             	sub    $0xc,%esp
80101a89:	ff 75 e4             	push   -0x1c(%ebp)
80101a8c:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a8f:	e8 5c e7 ff ff       	call   801001f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101a94:	8b 93 8c 00 00 00    	mov    0x8c(%ebx),%edx
80101a9a:	8b 03                	mov    (%ebx),%eax
80101a9c:	e8 af f7 ff ff       	call   80101250 <bfree>
    ip->addrs[NDIRECT] = 0;
80101aa1:	83 c4 10             	add    $0x10,%esp
80101aa4:	c7 83 8c 00 00 00 00 	movl   $0x0,0x8c(%ebx)
80101aab:	00 00 00 
80101aae:	e9 6a ff ff ff       	jmp    80101a1d <iput+0xbd>
80101ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101ac0 <iunlockput>:
{
80101ac0:	55                   	push   %ebp
80101ac1:	89 e5                	mov    %esp,%ebp
80101ac3:	56                   	push   %esi
80101ac4:	53                   	push   %ebx
80101ac5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101ac8:	85 db                	test   %ebx,%ebx
80101aca:	74 34                	je     80101b00 <iunlockput+0x40>
80101acc:	83 ec 0c             	sub    $0xc,%esp
80101acf:	8d 73 0c             	lea    0xc(%ebx),%esi
80101ad2:	56                   	push   %esi
80101ad3:	e8 08 2c 00 00       	call   801046e0 <holdingsleep>
80101ad8:	83 c4 10             	add    $0x10,%esp
80101adb:	85 c0                	test   %eax,%eax
80101add:	74 21                	je     80101b00 <iunlockput+0x40>
80101adf:	8b 43 08             	mov    0x8(%ebx),%eax
80101ae2:	85 c0                	test   %eax,%eax
80101ae4:	7e 1a                	jle    80101b00 <iunlockput+0x40>
  releasesleep(&ip->lock);
80101ae6:	83 ec 0c             	sub    $0xc,%esp
80101ae9:	56                   	push   %esi
80101aea:	e8 b1 2b 00 00       	call   801046a0 <releasesleep>
  iput(ip);
80101aef:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101af2:	83 c4 10             	add    $0x10,%esp
}
80101af5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101af8:	5b                   	pop    %ebx
80101af9:	5e                   	pop    %esi
80101afa:	5d                   	pop    %ebp
  iput(ip);
80101afb:	e9 60 fe ff ff       	jmp    80101960 <iput>
    panic("iunlock");
80101b00:	83 ec 0c             	sub    $0xc,%esp
80101b03:	68 5f 78 10 80       	push   $0x8010785f
80101b08:	e8 73 e8 ff ff       	call   80100380 <panic>
80101b0d:	8d 76 00             	lea    0x0(%esi),%esi

80101b10 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101b10:	55                   	push   %ebp
80101b11:	89 e5                	mov    %esp,%ebp
80101b13:	8b 55 08             	mov    0x8(%ebp),%edx
80101b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101b19:	8b 0a                	mov    (%edx),%ecx
80101b1b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
80101b1e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101b21:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101b24:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101b28:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
80101b2b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
80101b2f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101b33:	8b 52 58             	mov    0x58(%edx),%edx
80101b36:	89 50 10             	mov    %edx,0x10(%eax)
}
80101b39:	5d                   	pop    %ebp
80101b3a:	c3                   	ret    
80101b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b3f:	90                   	nop

80101b40 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101b40:	55                   	push   %ebp
80101b41:	89 e5                	mov    %esp,%ebp
80101b43:	57                   	push   %edi
80101b44:	56                   	push   %esi
80101b45:	53                   	push   %ebx
80101b46:	83 ec 1c             	sub    $0x1c,%esp
80101b49:	8b 7d 0c             	mov    0xc(%ebp),%edi
80101b4c:	8b 45 08             	mov    0x8(%ebp),%eax
80101b4f:	8b 75 10             	mov    0x10(%ebp),%esi
80101b52:	89 7d e0             	mov    %edi,-0x20(%ebp)
80101b55:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101b58:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101b5d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101b60:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  if(ip->type == T_DEV){
80101b63:	0f 84 a7 00 00 00    	je     80101c10 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101b69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b6c:	8b 40 58             	mov    0x58(%eax),%eax
80101b6f:	39 c6                	cmp    %eax,%esi
80101b71:	0f 87 ba 00 00 00    	ja     80101c31 <readi+0xf1>
80101b77:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101b7a:	31 c9                	xor    %ecx,%ecx
80101b7c:	89 da                	mov    %ebx,%edx
80101b7e:	01 f2                	add    %esi,%edx
80101b80:	0f 92 c1             	setb   %cl
80101b83:	89 cf                	mov    %ecx,%edi
80101b85:	0f 82 a6 00 00 00    	jb     80101c31 <readi+0xf1>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101b8b:	89 c1                	mov    %eax,%ecx
80101b8d:	29 f1                	sub    %esi,%ecx
80101b8f:	39 d0                	cmp    %edx,%eax
80101b91:	0f 43 cb             	cmovae %ebx,%ecx
80101b94:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101b97:	85 c9                	test   %ecx,%ecx
80101b99:	74 67                	je     80101c02 <readi+0xc2>
80101b9b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ba0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
80101ba3:	89 f2                	mov    %esi,%edx
80101ba5:	c1 ea 09             	shr    $0x9,%edx
80101ba8:	89 d8                	mov    %ebx,%eax
80101baa:	e8 31 f9 ff ff       	call   801014e0 <bmap>
80101baf:	83 ec 08             	sub    $0x8,%esp
80101bb2:	50                   	push   %eax
80101bb3:	ff 33                	push   (%ebx)
80101bb5:	e8 16 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101bba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101bbd:	b9 00 02 00 00       	mov    $0x200,%ecx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101bc2:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101bc4:	89 f0                	mov    %esi,%eax
80101bc6:	25 ff 01 00 00       	and    $0x1ff,%eax
80101bcb:	29 fb                	sub    %edi,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bcd:	89 55 dc             	mov    %edx,-0x24(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd0:	29 c1                	sub    %eax,%ecx
    memmove(dst, bp->data + off%BSIZE, m);
80101bd2:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101bd6:	39 d9                	cmp    %ebx,%ecx
80101bd8:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101bdb:	83 c4 0c             	add    $0xc,%esp
80101bde:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bdf:	01 df                	add    %ebx,%edi
80101be1:	01 de                	add    %ebx,%esi
    memmove(dst, bp->data + off%BSIZE, m);
80101be3:	50                   	push   %eax
80101be4:	ff 75 e0             	push   -0x20(%ebp)
80101be7:	e8 74 2e 00 00       	call   80104a60 <memmove>
    brelse(bp);
80101bec:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101bef:	89 14 24             	mov    %edx,(%esp)
80101bf2:	e8 f9 e5 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101bf7:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101c00:	77 9e                	ja     80101ba0 <readi+0x60>
  }
  return n;
80101c02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101c05:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c08:	5b                   	pop    %ebx
80101c09:	5e                   	pop    %esi
80101c0a:	5f                   	pop    %edi
80101c0b:	5d                   	pop    %ebp
80101c0c:	c3                   	ret    
80101c0d:	8d 76 00             	lea    0x0(%esi),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101c10:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101c14:	66 83 f8 09          	cmp    $0x9,%ax
80101c18:	77 17                	ja     80101c31 <readi+0xf1>
80101c1a:	8b 04 c5 00 09 11 80 	mov    -0x7feef700(,%eax,8),%eax
80101c21:	85 c0                	test   %eax,%eax
80101c23:	74 0c                	je     80101c31 <readi+0xf1>
    return devsw[ip->major].read(ip, dst, n);
80101c25:	89 7d 10             	mov    %edi,0x10(%ebp)
}
80101c28:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c2b:	5b                   	pop    %ebx
80101c2c:	5e                   	pop    %esi
80101c2d:	5f                   	pop    %edi
80101c2e:	5d                   	pop    %ebp
    return devsw[ip->major].read(ip, dst, n);
80101c2f:	ff e0                	jmp    *%eax
      return -1;
80101c31:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101c36:	eb cd                	jmp    80101c05 <readi+0xc5>
80101c38:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c3f:	90                   	nop

80101c40 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101c40:	55                   	push   %ebp
80101c41:	89 e5                	mov    %esp,%ebp
80101c43:	57                   	push   %edi
80101c44:	56                   	push   %esi
80101c45:	53                   	push   %ebx
80101c46:	83 ec 1c             	sub    $0x1c,%esp
80101c49:	8b 45 08             	mov    0x8(%ebp),%eax
80101c4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101c4f:	8b 55 14             	mov    0x14(%ebp),%edx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101c52:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
{
80101c57:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101c5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101c5d:	8b 75 10             	mov    0x10(%ebp),%esi
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(ip->type == T_DEV){
80101c63:	0f 84 b7 00 00 00    	je     80101d20 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101c69:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101c6c:	3b 70 58             	cmp    0x58(%eax),%esi
80101c6f:	0f 87 e7 00 00 00    	ja     80101d5c <writei+0x11c>
80101c75:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101c78:	31 d2                	xor    %edx,%edx
80101c7a:	89 f8                	mov    %edi,%eax
80101c7c:	01 f0                	add    %esi,%eax
80101c7e:	0f 92 c2             	setb   %dl
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101c81:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101c86:	0f 87 d0 00 00 00    	ja     80101d5c <writei+0x11c>
80101c8c:	85 d2                	test   %edx,%edx
80101c8e:	0f 85 c8 00 00 00    	jne    80101d5c <writei+0x11c>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101c94:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101c9b:	85 ff                	test   %edi,%edi
80101c9d:	74 72                	je     80101d11 <writei+0xd1>
80101c9f:	90                   	nop
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ca0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ca3:	89 f2                	mov    %esi,%edx
80101ca5:	c1 ea 09             	shr    $0x9,%edx
80101ca8:	89 f8                	mov    %edi,%eax
80101caa:	e8 31 f8 ff ff       	call   801014e0 <bmap>
80101caf:	83 ec 08             	sub    $0x8,%esp
80101cb2:	50                   	push   %eax
80101cb3:	ff 37                	push   (%edi)
80101cb5:	e8 16 e4 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101cba:	b9 00 02 00 00       	mov    $0x200,%ecx
80101cbf:	8b 5d e0             	mov    -0x20(%ebp),%ebx
80101cc2:	2b 5d e4             	sub    -0x1c(%ebp),%ebx
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101cc5:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101cc7:	89 f0                	mov    %esi,%eax
80101cc9:	25 ff 01 00 00       	and    $0x1ff,%eax
80101cce:	29 c1                	sub    %eax,%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101cd0:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
80101cd4:	39 d9                	cmp    %ebx,%ecx
80101cd6:	0f 46 d9             	cmovbe %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101cd9:	83 c4 0c             	add    $0xc,%esp
80101cdc:	53                   	push   %ebx
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cdd:	01 de                	add    %ebx,%esi
    memmove(bp->data + off%BSIZE, src, m);
80101cdf:	ff 75 dc             	push   -0x24(%ebp)
80101ce2:	50                   	push   %eax
80101ce3:	e8 78 2d 00 00       	call   80104a60 <memmove>
    log_write(bp);
80101ce8:	89 3c 24             	mov    %edi,(%esp)
80101ceb:	e8 00 13 00 00       	call   80102ff0 <log_write>
    brelse(bp);
80101cf0:	89 3c 24             	mov    %edi,(%esp)
80101cf3:	e8 f8 e4 ff ff       	call   801001f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101cf8:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101cfb:	83 c4 10             	add    $0x10,%esp
80101cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d01:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101d04:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101d07:	77 97                	ja     80101ca0 <writei+0x60>
  }

  if(n > 0 && off > ip->size){
80101d09:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101d0c:	3b 70 58             	cmp    0x58(%eax),%esi
80101d0f:	77 37                	ja     80101d48 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101d11:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101d14:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d17:	5b                   	pop    %ebx
80101d18:	5e                   	pop    %esi
80101d19:	5f                   	pop    %edi
80101d1a:	5d                   	pop    %ebp
80101d1b:	c3                   	ret    
80101d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101d20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101d24:	66 83 f8 09          	cmp    $0x9,%ax
80101d28:	77 32                	ja     80101d5c <writei+0x11c>
80101d2a:	8b 04 c5 04 09 11 80 	mov    -0x7feef6fc(,%eax,8),%eax
80101d31:	85 c0                	test   %eax,%eax
80101d33:	74 27                	je     80101d5c <writei+0x11c>
    return devsw[ip->major].write(ip, src, n);
80101d35:	89 55 10             	mov    %edx,0x10(%ebp)
}
80101d38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d3b:	5b                   	pop    %ebx
80101d3c:	5e                   	pop    %esi
80101d3d:	5f                   	pop    %edi
80101d3e:	5d                   	pop    %ebp
    return devsw[ip->major].write(ip, src, n);
80101d3f:	ff e0                	jmp    *%eax
80101d41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    ip->size = off;
80101d48:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101d4b:	83 ec 0c             	sub    $0xc,%esp
    ip->size = off;
80101d4e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101d51:	50                   	push   %eax
80101d52:	e8 19 fa ff ff       	call   80101770 <iupdate>
80101d57:	83 c4 10             	add    $0x10,%esp
80101d5a:	eb b5                	jmp    80101d11 <writei+0xd1>
      return -1;
80101d5c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101d61:	eb b1                	jmp    80101d14 <writei+0xd4>
80101d63:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101d70 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101d70:	55                   	push   %ebp
80101d71:	89 e5                	mov    %esp,%ebp
80101d73:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101d76:	6a 0e                	push   $0xe
80101d78:	ff 75 0c             	push   0xc(%ebp)
80101d7b:	ff 75 08             	push   0x8(%ebp)
80101d7e:	e8 4d 2d 00 00       	call   80104ad0 <strncmp>
}
80101d83:	c9                   	leave  
80101d84:	c3                   	ret    
80101d85:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101d90 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101d90:	55                   	push   %ebp
80101d91:	89 e5                	mov    %esp,%ebp
80101d93:	57                   	push   %edi
80101d94:	56                   	push   %esi
80101d95:	53                   	push   %ebx
80101d96:	83 ec 1c             	sub    $0x1c,%esp
80101d99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101d9c:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101da1:	0f 85 85 00 00 00    	jne    80101e2c <dirlookup+0x9c>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101da7:	8b 53 58             	mov    0x58(%ebx),%edx
80101daa:	31 ff                	xor    %edi,%edi
80101dac:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101daf:	85 d2                	test   %edx,%edx
80101db1:	74 3e                	je     80101df1 <dirlookup+0x61>
80101db3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101db7:	90                   	nop
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101db8:	6a 10                	push   $0x10
80101dba:	57                   	push   %edi
80101dbb:	56                   	push   %esi
80101dbc:	53                   	push   %ebx
80101dbd:	e8 7e fd ff ff       	call   80101b40 <readi>
80101dc2:	83 c4 10             	add    $0x10,%esp
80101dc5:	83 f8 10             	cmp    $0x10,%eax
80101dc8:	75 55                	jne    80101e1f <dirlookup+0x8f>
      panic("dirlookup read");
    if(de.inum == 0)
80101dca:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101dcf:	74 18                	je     80101de9 <dirlookup+0x59>
  return strncmp(s, t, DIRSIZ);
80101dd1:	83 ec 04             	sub    $0x4,%esp
80101dd4:	8d 45 da             	lea    -0x26(%ebp),%eax
80101dd7:	6a 0e                	push   $0xe
80101dd9:	50                   	push   %eax
80101dda:	ff 75 0c             	push   0xc(%ebp)
80101ddd:	e8 ee 2c 00 00       	call   80104ad0 <strncmp>
      continue;
    if(namecmp(name, de.name) == 0){
80101de2:	83 c4 10             	add    $0x10,%esp
80101de5:	85 c0                	test   %eax,%eax
80101de7:	74 17                	je     80101e00 <dirlookup+0x70>
  for(off = 0; off < dp->size; off += sizeof(de)){
80101de9:	83 c7 10             	add    $0x10,%edi
80101dec:	3b 7b 58             	cmp    0x58(%ebx),%edi
80101def:	72 c7                	jb     80101db8 <dirlookup+0x28>
      return iget(dp->dev, inum);
    }
  }

  return 0;
}
80101df1:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80101df4:	31 c0                	xor    %eax,%eax
}
80101df6:	5b                   	pop    %ebx
80101df7:	5e                   	pop    %esi
80101df8:	5f                   	pop    %edi
80101df9:	5d                   	pop    %ebp
80101dfa:	c3                   	ret    
80101dfb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101dff:	90                   	nop
      if(poff)
80101e00:	8b 45 10             	mov    0x10(%ebp),%eax
80101e03:	85 c0                	test   %eax,%eax
80101e05:	74 05                	je     80101e0c <dirlookup+0x7c>
        *poff = off;
80101e07:	8b 45 10             	mov    0x10(%ebp),%eax
80101e0a:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101e0c:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101e10:	8b 03                	mov    (%ebx),%eax
80101e12:	e8 c9 f5 ff ff       	call   801013e0 <iget>
}
80101e17:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e1a:	5b                   	pop    %ebx
80101e1b:	5e                   	pop    %esi
80101e1c:	5f                   	pop    %edi
80101e1d:	5d                   	pop    %ebp
80101e1e:	c3                   	ret    
      panic("dirlookup read");
80101e1f:	83 ec 0c             	sub    $0xc,%esp
80101e22:	68 79 78 10 80       	push   $0x80107879
80101e27:	e8 54 e5 ff ff       	call   80100380 <panic>
    panic("dirlookup not DIR");
80101e2c:	83 ec 0c             	sub    $0xc,%esp
80101e2f:	68 67 78 10 80       	push   $0x80107867
80101e34:	e8 47 e5 ff ff       	call   80100380 <panic>
80101e39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e40 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101e40:	55                   	push   %ebp
80101e41:	89 e5                	mov    %esp,%ebp
80101e43:	57                   	push   %edi
80101e44:	56                   	push   %esi
80101e45:	53                   	push   %ebx
80101e46:	89 c3                	mov    %eax,%ebx
80101e48:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101e4b:	80 38 2f             	cmpb   $0x2f,(%eax)
{
80101e4e:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101e51:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  if(*path == '/')
80101e54:	0f 84 64 01 00 00    	je     80101fbe <namex+0x17e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101e5a:	e8 01 1e 00 00       	call   80103c60 <myproc>
  acquire(&icache.lock);
80101e5f:	83 ec 0c             	sub    $0xc,%esp
    ip = idup(myproc()->cwd);
80101e62:	8b 70 68             	mov    0x68(%eax),%esi
  acquire(&icache.lock);
80101e65:	68 60 09 11 80       	push   $0x80110960
80101e6a:	e8 91 2a 00 00       	call   80104900 <acquire>
  ip->ref++;
80101e6f:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101e73:	c7 04 24 60 09 11 80 	movl   $0x80110960,(%esp)
80101e7a:	e8 21 2a 00 00       	call   801048a0 <release>
80101e7f:	83 c4 10             	add    $0x10,%esp
80101e82:	eb 07                	jmp    80101e8b <namex+0x4b>
80101e84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101e88:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101e8b:	0f b6 03             	movzbl (%ebx),%eax
80101e8e:	3c 2f                	cmp    $0x2f,%al
80101e90:	74 f6                	je     80101e88 <namex+0x48>
  if(*path == 0)
80101e92:	84 c0                	test   %al,%al
80101e94:	0f 84 06 01 00 00    	je     80101fa0 <namex+0x160>
  while(*path != '/' && *path != 0)
80101e9a:	0f b6 03             	movzbl (%ebx),%eax
80101e9d:	84 c0                	test   %al,%al
80101e9f:	0f 84 10 01 00 00    	je     80101fb5 <namex+0x175>
80101ea5:	89 df                	mov    %ebx,%edi
80101ea7:	3c 2f                	cmp    $0x2f,%al
80101ea9:	0f 84 06 01 00 00    	je     80101fb5 <namex+0x175>
80101eaf:	90                   	nop
80101eb0:	0f b6 47 01          	movzbl 0x1(%edi),%eax
    path++;
80101eb4:	83 c7 01             	add    $0x1,%edi
  while(*path != '/' && *path != 0)
80101eb7:	3c 2f                	cmp    $0x2f,%al
80101eb9:	74 04                	je     80101ebf <namex+0x7f>
80101ebb:	84 c0                	test   %al,%al
80101ebd:	75 f1                	jne    80101eb0 <namex+0x70>
  len = path - s;
80101ebf:	89 f8                	mov    %edi,%eax
80101ec1:	29 d8                	sub    %ebx,%eax
  if(len >= DIRSIZ)
80101ec3:	83 f8 0d             	cmp    $0xd,%eax
80101ec6:	0f 8e ac 00 00 00    	jle    80101f78 <namex+0x138>
    memmove(name, s, DIRSIZ);
80101ecc:	83 ec 04             	sub    $0x4,%esp
80101ecf:	6a 0e                	push   $0xe
80101ed1:	53                   	push   %ebx
    path++;
80101ed2:	89 fb                	mov    %edi,%ebx
    memmove(name, s, DIRSIZ);
80101ed4:	ff 75 e4             	push   -0x1c(%ebp)
80101ed7:	e8 84 2b 00 00       	call   80104a60 <memmove>
80101edc:	83 c4 10             	add    $0x10,%esp
  while(*path == '/')
80101edf:	80 3f 2f             	cmpb   $0x2f,(%edi)
80101ee2:	75 0c                	jne    80101ef0 <namex+0xb0>
80101ee4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    path++;
80101ee8:	83 c3 01             	add    $0x1,%ebx
  while(*path == '/')
80101eeb:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101eee:	74 f8                	je     80101ee8 <namex+0xa8>

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101ef0:	83 ec 0c             	sub    $0xc,%esp
80101ef3:	56                   	push   %esi
80101ef4:	e8 37 f9 ff ff       	call   80101830 <ilock>
    if(ip->type != T_DIR){
80101ef9:	83 c4 10             	add    $0x10,%esp
80101efc:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101f01:	0f 85 cd 00 00 00    	jne    80101fd4 <namex+0x194>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101f07:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101f0a:	85 c0                	test   %eax,%eax
80101f0c:	74 09                	je     80101f17 <namex+0xd7>
80101f0e:	80 3b 00             	cmpb   $0x0,(%ebx)
80101f11:	0f 84 22 01 00 00    	je     80102039 <namex+0x1f9>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101f17:	83 ec 04             	sub    $0x4,%esp
80101f1a:	6a 00                	push   $0x0
80101f1c:	ff 75 e4             	push   -0x1c(%ebp)
80101f1f:	56                   	push   %esi
80101f20:	e8 6b fe ff ff       	call   80101d90 <dirlookup>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f25:	8d 56 0c             	lea    0xc(%esi),%edx
    if((next = dirlookup(ip, name, 0)) == 0){
80101f28:	83 c4 10             	add    $0x10,%esp
80101f2b:	89 c7                	mov    %eax,%edi
80101f2d:	85 c0                	test   %eax,%eax
80101f2f:	0f 84 e1 00 00 00    	je     80102016 <namex+0x1d6>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101f35:	83 ec 0c             	sub    $0xc,%esp
80101f38:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f3b:	52                   	push   %edx
80101f3c:	e8 9f 27 00 00       	call   801046e0 <holdingsleep>
80101f41:	83 c4 10             	add    $0x10,%esp
80101f44:	85 c0                	test   %eax,%eax
80101f46:	0f 84 30 01 00 00    	je     8010207c <namex+0x23c>
80101f4c:	8b 56 08             	mov    0x8(%esi),%edx
80101f4f:	85 d2                	test   %edx,%edx
80101f51:	0f 8e 25 01 00 00    	jle    8010207c <namex+0x23c>
  releasesleep(&ip->lock);
80101f57:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f5a:	83 ec 0c             	sub    $0xc,%esp
80101f5d:	52                   	push   %edx
80101f5e:	e8 3d 27 00 00       	call   801046a0 <releasesleep>
  iput(ip);
80101f63:	89 34 24             	mov    %esi,(%esp)
80101f66:	89 fe                	mov    %edi,%esi
80101f68:	e8 f3 f9 ff ff       	call   80101960 <iput>
80101f6d:	83 c4 10             	add    $0x10,%esp
80101f70:	e9 16 ff ff ff       	jmp    80101e8b <namex+0x4b>
80101f75:	8d 76 00             	lea    0x0(%esi),%esi
    name[len] = 0;
80101f78:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101f7b:	8d 14 01             	lea    (%ecx,%eax,1),%edx
    memmove(name, s, len);
80101f7e:	83 ec 04             	sub    $0x4,%esp
80101f81:	89 55 e0             	mov    %edx,-0x20(%ebp)
80101f84:	50                   	push   %eax
80101f85:	53                   	push   %ebx
    name[len] = 0;
80101f86:	89 fb                	mov    %edi,%ebx
    memmove(name, s, len);
80101f88:	ff 75 e4             	push   -0x1c(%ebp)
80101f8b:	e8 d0 2a 00 00       	call   80104a60 <memmove>
    name[len] = 0;
80101f90:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101f93:	83 c4 10             	add    $0x10,%esp
80101f96:	c6 02 00             	movb   $0x0,(%edx)
80101f99:	e9 41 ff ff ff       	jmp    80101edf <namex+0x9f>
80101f9e:	66 90                	xchg   %ax,%ax
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101fa0:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101fa3:	85 c0                	test   %eax,%eax
80101fa5:	0f 85 be 00 00 00    	jne    80102069 <namex+0x229>
    iput(ip);
    return 0;
  }
  return ip;
}
80101fab:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101fae:	89 f0                	mov    %esi,%eax
80101fb0:	5b                   	pop    %ebx
80101fb1:	5e                   	pop    %esi
80101fb2:	5f                   	pop    %edi
80101fb3:	5d                   	pop    %ebp
80101fb4:	c3                   	ret    
  while(*path != '/' && *path != 0)
80101fb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101fb8:	89 df                	mov    %ebx,%edi
80101fba:	31 c0                	xor    %eax,%eax
80101fbc:	eb c0                	jmp    80101f7e <namex+0x13e>
    ip = iget(ROOTDEV, ROOTINO);
80101fbe:	ba 01 00 00 00       	mov    $0x1,%edx
80101fc3:	b8 01 00 00 00       	mov    $0x1,%eax
80101fc8:	e8 13 f4 ff ff       	call   801013e0 <iget>
80101fcd:	89 c6                	mov    %eax,%esi
80101fcf:	e9 b7 fe ff ff       	jmp    80101e8b <namex+0x4b>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101fd4:	83 ec 0c             	sub    $0xc,%esp
80101fd7:	8d 5e 0c             	lea    0xc(%esi),%ebx
80101fda:	53                   	push   %ebx
80101fdb:	e8 00 27 00 00       	call   801046e0 <holdingsleep>
80101fe0:	83 c4 10             	add    $0x10,%esp
80101fe3:	85 c0                	test   %eax,%eax
80101fe5:	0f 84 91 00 00 00    	je     8010207c <namex+0x23c>
80101feb:	8b 46 08             	mov    0x8(%esi),%eax
80101fee:	85 c0                	test   %eax,%eax
80101ff0:	0f 8e 86 00 00 00    	jle    8010207c <namex+0x23c>
  releasesleep(&ip->lock);
80101ff6:	83 ec 0c             	sub    $0xc,%esp
80101ff9:	53                   	push   %ebx
80101ffa:	e8 a1 26 00 00       	call   801046a0 <releasesleep>
  iput(ip);
80101fff:	89 34 24             	mov    %esi,(%esp)
      return 0;
80102002:	31 f6                	xor    %esi,%esi
  iput(ip);
80102004:	e8 57 f9 ff ff       	call   80101960 <iput>
      return 0;
80102009:	83 c4 10             	add    $0x10,%esp
}
8010200c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010200f:	89 f0                	mov    %esi,%eax
80102011:	5b                   	pop    %ebx
80102012:	5e                   	pop    %esi
80102013:	5f                   	pop    %edi
80102014:	5d                   	pop    %ebp
80102015:	c3                   	ret    
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102016:	83 ec 0c             	sub    $0xc,%esp
80102019:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010201c:	52                   	push   %edx
8010201d:	e8 be 26 00 00       	call   801046e0 <holdingsleep>
80102022:	83 c4 10             	add    $0x10,%esp
80102025:	85 c0                	test   %eax,%eax
80102027:	74 53                	je     8010207c <namex+0x23c>
80102029:	8b 4e 08             	mov    0x8(%esi),%ecx
8010202c:	85 c9                	test   %ecx,%ecx
8010202e:	7e 4c                	jle    8010207c <namex+0x23c>
  releasesleep(&ip->lock);
80102030:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80102033:	83 ec 0c             	sub    $0xc,%esp
80102036:	52                   	push   %edx
80102037:	eb c1                	jmp    80101ffa <namex+0x1ba>
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80102039:	83 ec 0c             	sub    $0xc,%esp
8010203c:	8d 5e 0c             	lea    0xc(%esi),%ebx
8010203f:	53                   	push   %ebx
80102040:	e8 9b 26 00 00       	call   801046e0 <holdingsleep>
80102045:	83 c4 10             	add    $0x10,%esp
80102048:	85 c0                	test   %eax,%eax
8010204a:	74 30                	je     8010207c <namex+0x23c>
8010204c:	8b 7e 08             	mov    0x8(%esi),%edi
8010204f:	85 ff                	test   %edi,%edi
80102051:	7e 29                	jle    8010207c <namex+0x23c>
  releasesleep(&ip->lock);
80102053:	83 ec 0c             	sub    $0xc,%esp
80102056:	53                   	push   %ebx
80102057:	e8 44 26 00 00       	call   801046a0 <releasesleep>
}
8010205c:	83 c4 10             	add    $0x10,%esp
}
8010205f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102062:	89 f0                	mov    %esi,%eax
80102064:	5b                   	pop    %ebx
80102065:	5e                   	pop    %esi
80102066:	5f                   	pop    %edi
80102067:	5d                   	pop    %ebp
80102068:	c3                   	ret    
    iput(ip);
80102069:	83 ec 0c             	sub    $0xc,%esp
8010206c:	56                   	push   %esi
    return 0;
8010206d:	31 f6                	xor    %esi,%esi
    iput(ip);
8010206f:	e8 ec f8 ff ff       	call   80101960 <iput>
    return 0;
80102074:	83 c4 10             	add    $0x10,%esp
80102077:	e9 2f ff ff ff       	jmp    80101fab <namex+0x16b>
    panic("iunlock");
8010207c:	83 ec 0c             	sub    $0xc,%esp
8010207f:	68 5f 78 10 80       	push   $0x8010785f
80102084:	e8 f7 e2 ff ff       	call   80100380 <panic>
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <dirlink>:
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 20             	sub    $0x20,%esp
80102099:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if((ip = dirlookup(dp, name, 0)) != 0){
8010209c:	6a 00                	push   $0x0
8010209e:	ff 75 0c             	push   0xc(%ebp)
801020a1:	53                   	push   %ebx
801020a2:	e8 e9 fc ff ff       	call   80101d90 <dirlookup>
801020a7:	83 c4 10             	add    $0x10,%esp
801020aa:	85 c0                	test   %eax,%eax
801020ac:	75 67                	jne    80102115 <dirlink+0x85>
  for(off = 0; off < dp->size; off += sizeof(de)){
801020ae:	8b 7b 58             	mov    0x58(%ebx),%edi
801020b1:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020b4:	85 ff                	test   %edi,%edi
801020b6:	74 29                	je     801020e1 <dirlink+0x51>
801020b8:	31 ff                	xor    %edi,%edi
801020ba:	8d 75 d8             	lea    -0x28(%ebp),%esi
801020bd:	eb 09                	jmp    801020c8 <dirlink+0x38>
801020bf:	90                   	nop
801020c0:	83 c7 10             	add    $0x10,%edi
801020c3:	3b 7b 58             	cmp    0x58(%ebx),%edi
801020c6:	73 19                	jae    801020e1 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020c8:	6a 10                	push   $0x10
801020ca:	57                   	push   %edi
801020cb:	56                   	push   %esi
801020cc:	53                   	push   %ebx
801020cd:	e8 6e fa ff ff       	call   80101b40 <readi>
801020d2:	83 c4 10             	add    $0x10,%esp
801020d5:	83 f8 10             	cmp    $0x10,%eax
801020d8:	75 4e                	jne    80102128 <dirlink+0x98>
    if(de.inum == 0)
801020da:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
801020df:	75 df                	jne    801020c0 <dirlink+0x30>
  strncpy(de.name, name, DIRSIZ);
801020e1:	83 ec 04             	sub    $0x4,%esp
801020e4:	8d 45 da             	lea    -0x26(%ebp),%eax
801020e7:	6a 0e                	push   $0xe
801020e9:	ff 75 0c             	push   0xc(%ebp)
801020ec:	50                   	push   %eax
801020ed:	e8 2e 2a 00 00       	call   80104b20 <strncpy>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f2:	6a 10                	push   $0x10
  de.inum = inum;
801020f4:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020f7:	57                   	push   %edi
801020f8:	56                   	push   %esi
801020f9:	53                   	push   %ebx
  de.inum = inum;
801020fa:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801020fe:	e8 3d fb ff ff       	call   80101c40 <writei>
80102103:	83 c4 20             	add    $0x20,%esp
80102106:	83 f8 10             	cmp    $0x10,%eax
80102109:	75 2a                	jne    80102135 <dirlink+0xa5>
  return 0;
8010210b:	31 c0                	xor    %eax,%eax
}
8010210d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102110:	5b                   	pop    %ebx
80102111:	5e                   	pop    %esi
80102112:	5f                   	pop    %edi
80102113:	5d                   	pop    %ebp
80102114:	c3                   	ret    
    iput(ip);
80102115:	83 ec 0c             	sub    $0xc,%esp
80102118:	50                   	push   %eax
80102119:	e8 42 f8 ff ff       	call   80101960 <iput>
    return -1;
8010211e:	83 c4 10             	add    $0x10,%esp
80102121:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80102126:	eb e5                	jmp    8010210d <dirlink+0x7d>
      panic("dirlink read");
80102128:	83 ec 0c             	sub    $0xc,%esp
8010212b:	68 88 78 10 80       	push   $0x80107888
80102130:	e8 4b e2 ff ff       	call   80100380 <panic>
    panic("dirlink");
80102135:	83 ec 0c             	sub    $0xc,%esp
80102138:	68 8e 7e 10 80       	push   $0x80107e8e
8010213d:	e8 3e e2 ff ff       	call   80100380 <panic>
80102142:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102149:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102150 <namei>:

struct inode*
namei(char *path)
{
80102150:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80102151:	31 d2                	xor    %edx,%edx
{
80102153:	89 e5                	mov    %esp,%ebp
80102155:	83 ec 18             	sub    $0x18,%esp
  return namex(path, 0, name);
80102158:	8b 45 08             	mov    0x8(%ebp),%eax
8010215b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
8010215e:	e8 dd fc ff ff       	call   80101e40 <namex>
}
80102163:	c9                   	leave  
80102164:	c3                   	ret    
80102165:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010216c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102170 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80102170:	55                   	push   %ebp
  return namex(path, 1, name);
80102171:	ba 01 00 00 00       	mov    $0x1,%edx
{
80102176:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80102178:	8b 4d 0c             	mov    0xc(%ebp),%ecx
8010217b:	8b 45 08             	mov    0x8(%ebp),%eax
}
8010217e:	5d                   	pop    %ebp
  return namex(path, 1, name);
8010217f:	e9 bc fc ff ff       	jmp    80101e40 <namex>
80102184:	66 90                	xchg   %ax,%ax
80102186:	66 90                	xchg   %ax,%ax
80102188:	66 90                	xchg   %ax,%ax
8010218a:	66 90                	xchg   %ax,%ax
8010218c:	66 90                	xchg   %ax,%ax
8010218e:	66 90                	xchg   %ax,%ax

80102190 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80102190:	55                   	push   %ebp
80102191:	89 e5                	mov    %esp,%ebp
80102193:	57                   	push   %edi
80102194:	56                   	push   %esi
80102195:	53                   	push   %ebx
80102196:	83 ec 0c             	sub    $0xc,%esp
  if(b == 0)
80102199:	85 c0                	test   %eax,%eax
8010219b:	0f 84 b4 00 00 00    	je     80102255 <idestart+0xc5>
    panic("idestart");
  if(b->blockno >= FSSIZE)
801021a1:	8b 70 08             	mov    0x8(%eax),%esi
801021a4:	89 c3                	mov    %eax,%ebx
801021a6:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
801021ac:	0f 87 96 00 00 00    	ja     80102248 <idestart+0xb8>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801021b2:	b9 f7 01 00 00       	mov    $0x1f7,%ecx
801021b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801021be:	66 90                	xchg   %ax,%ax
801021c0:	89 ca                	mov    %ecx,%edx
801021c2:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801021c3:	83 e0 c0             	and    $0xffffffc0,%eax
801021c6:	3c 40                	cmp    $0x40,%al
801021c8:	75 f6                	jne    801021c0 <idestart+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801021ca:	31 ff                	xor    %edi,%edi
801021cc:	ba f6 03 00 00       	mov    $0x3f6,%edx
801021d1:	89 f8                	mov    %edi,%eax
801021d3:	ee                   	out    %al,(%dx)
801021d4:	b8 01 00 00 00       	mov    $0x1,%eax
801021d9:	ba f2 01 00 00       	mov    $0x1f2,%edx
801021de:	ee                   	out    %al,(%dx)
801021df:	ba f3 01 00 00       	mov    $0x1f3,%edx
801021e4:	89 f0                	mov    %esi,%eax
801021e6:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
801021e7:	89 f0                	mov    %esi,%eax
801021e9:	ba f4 01 00 00       	mov    $0x1f4,%edx
801021ee:	c1 f8 08             	sar    $0x8,%eax
801021f1:	ee                   	out    %al,(%dx)
801021f2:	ba f5 01 00 00       	mov    $0x1f5,%edx
801021f7:	89 f8                	mov    %edi,%eax
801021f9:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
801021fa:	0f b6 43 04          	movzbl 0x4(%ebx),%eax
801021fe:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102203:	c1 e0 04             	shl    $0x4,%eax
80102206:	83 e0 10             	and    $0x10,%eax
80102209:	83 c8 e0             	or     $0xffffffe0,%eax
8010220c:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
8010220d:	f6 03 04             	testb  $0x4,(%ebx)
80102210:	75 16                	jne    80102228 <idestart+0x98>
80102212:	b8 20 00 00 00       	mov    $0x20,%eax
80102217:	89 ca                	mov    %ecx,%edx
80102219:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
8010221a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010221d:	5b                   	pop    %ebx
8010221e:	5e                   	pop    %esi
8010221f:	5f                   	pop    %edi
80102220:	5d                   	pop    %ebp
80102221:	c3                   	ret    
80102222:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102228:	b8 30 00 00 00       	mov    $0x30,%eax
8010222d:	89 ca                	mov    %ecx,%edx
8010222f:	ee                   	out    %al,(%dx)
  asm volatile("cld; rep outsl" :
80102230:	b9 80 00 00 00       	mov    $0x80,%ecx
    outsl(0x1f0, b->data, BSIZE/4);
80102235:	8d 73 5c             	lea    0x5c(%ebx),%esi
80102238:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010223d:	fc                   	cld    
8010223e:	f3 6f                	rep outsl %ds:(%esi),(%dx)
}
80102240:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102243:	5b                   	pop    %ebx
80102244:	5e                   	pop    %esi
80102245:	5f                   	pop    %edi
80102246:	5d                   	pop    %ebp
80102247:	c3                   	ret    
    panic("incorrect blockno");
80102248:	83 ec 0c             	sub    $0xc,%esp
8010224b:	68 f4 78 10 80       	push   $0x801078f4
80102250:	e8 2b e1 ff ff       	call   80100380 <panic>
    panic("idestart");
80102255:	83 ec 0c             	sub    $0xc,%esp
80102258:	68 eb 78 10 80       	push   $0x801078eb
8010225d:	e8 1e e1 ff ff       	call   80100380 <panic>
80102262:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102270 <ideinit>:
{
80102270:	55                   	push   %ebp
80102271:	89 e5                	mov    %esp,%ebp
80102273:	83 ec 10             	sub    $0x10,%esp
  initlock(&idelock, "ide");
80102276:	68 06 79 10 80       	push   $0x80107906
8010227b:	68 c0 26 11 80       	push   $0x801126c0
80102280:	e8 ab 24 00 00       	call   80104730 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80102285:	58                   	pop    %eax
80102286:	a1 44 28 11 80       	mov    0x80112844,%eax
8010228b:	5a                   	pop    %edx
8010228c:	83 e8 01             	sub    $0x1,%eax
8010228f:	50                   	push   %eax
80102290:	6a 0e                	push   $0xe
80102292:	e8 99 02 00 00       	call   80102530 <ioapicenable>
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102297:	83 c4 10             	add    $0x10,%esp
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010229a:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010229f:	90                   	nop
801022a0:	ec                   	in     (%dx),%al
801022a1:	83 e0 c0             	and    $0xffffffc0,%eax
801022a4:	3c 40                	cmp    $0x40,%al
801022a6:	75 f8                	jne    801022a0 <ideinit+0x30>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022a8:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
801022ad:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022b2:	ee                   	out    %al,(%dx)
801022b3:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801022b8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801022bd:	eb 06                	jmp    801022c5 <ideinit+0x55>
801022bf:	90                   	nop
  for(i=0; i<1000; i++){
801022c0:	83 e9 01             	sub    $0x1,%ecx
801022c3:	74 0f                	je     801022d4 <ideinit+0x64>
801022c5:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
801022c6:	84 c0                	test   %al,%al
801022c8:	74 f6                	je     801022c0 <ideinit+0x50>
      havedisk1 = 1;
801022ca:	c7 05 a0 26 11 80 01 	movl   $0x1,0x801126a0
801022d1:	00 00 00 
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801022d4:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
801022d9:	ba f6 01 00 00       	mov    $0x1f6,%edx
801022de:	ee                   	out    %al,(%dx)
}
801022df:	c9                   	leave  
801022e0:	c3                   	ret    
801022e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801022ef:	90                   	nop

801022f0 <ideintr>:

// Interrupt handler.
void
ideintr(void)
{
801022f0:	55                   	push   %ebp
801022f1:	89 e5                	mov    %esp,%ebp
801022f3:	57                   	push   %edi
801022f4:	56                   	push   %esi
801022f5:	53                   	push   %ebx
801022f6:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
801022f9:	68 c0 26 11 80       	push   $0x801126c0
801022fe:	e8 fd 25 00 00       	call   80104900 <acquire>

  if((b = idequeue) == 0){
80102303:	8b 1d a4 26 11 80    	mov    0x801126a4,%ebx
80102309:	83 c4 10             	add    $0x10,%esp
8010230c:	85 db                	test   %ebx,%ebx
8010230e:	74 63                	je     80102373 <ideintr+0x83>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102310:	8b 43 58             	mov    0x58(%ebx),%eax
80102313:	a3 a4 26 11 80       	mov    %eax,0x801126a4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102318:	8b 33                	mov    (%ebx),%esi
8010231a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102320:	75 2f                	jne    80102351 <ideintr+0x61>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102322:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102327:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010232e:	66 90                	xchg   %ax,%ax
80102330:	ec                   	in     (%dx),%al
  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102331:	89 c1                	mov    %eax,%ecx
80102333:	83 e1 c0             	and    $0xffffffc0,%ecx
80102336:	80 f9 40             	cmp    $0x40,%cl
80102339:	75 f5                	jne    80102330 <ideintr+0x40>
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010233b:	a8 21                	test   $0x21,%al
8010233d:	75 12                	jne    80102351 <ideintr+0x61>
    insl(0x1f0, b->data, BSIZE/4);
8010233f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
  asm volatile("cld; rep insl" :
80102342:	b9 80 00 00 00       	mov    $0x80,%ecx
80102347:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010234c:	fc                   	cld    
8010234d:	f3 6d                	rep insl (%dx),%es:(%edi)

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
8010234f:	8b 33                	mov    (%ebx),%esi
  b->flags &= ~B_DIRTY;
80102351:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102354:	83 ec 0c             	sub    $0xc,%esp
  b->flags &= ~B_DIRTY;
80102357:	83 ce 02             	or     $0x2,%esi
8010235a:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010235c:	53                   	push   %ebx
8010235d:	e8 fe 20 00 00       	call   80104460 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102362:	a1 a4 26 11 80       	mov    0x801126a4,%eax
80102367:	83 c4 10             	add    $0x10,%esp
8010236a:	85 c0                	test   %eax,%eax
8010236c:	74 05                	je     80102373 <ideintr+0x83>
    idestart(idequeue);
8010236e:	e8 1d fe ff ff       	call   80102190 <idestart>
    release(&idelock);
80102373:	83 ec 0c             	sub    $0xc,%esp
80102376:	68 c0 26 11 80       	push   $0x801126c0
8010237b:	e8 20 25 00 00       	call   801048a0 <release>

  release(&idelock);
}
80102380:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102383:	5b                   	pop    %ebx
80102384:	5e                   	pop    %esi
80102385:	5f                   	pop    %edi
80102386:	5d                   	pop    %ebp
80102387:	c3                   	ret    
80102388:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010238f:	90                   	nop

80102390 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102390:	55                   	push   %ebp
80102391:	89 e5                	mov    %esp,%ebp
80102393:	53                   	push   %ebx
80102394:	83 ec 10             	sub    $0x10,%esp
80102397:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010239a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010239d:	50                   	push   %eax
8010239e:	e8 3d 23 00 00       	call   801046e0 <holdingsleep>
801023a3:	83 c4 10             	add    $0x10,%esp
801023a6:	85 c0                	test   %eax,%eax
801023a8:	0f 84 c3 00 00 00    	je     80102471 <iderw+0xe1>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
801023ae:	8b 03                	mov    (%ebx),%eax
801023b0:	83 e0 06             	and    $0x6,%eax
801023b3:	83 f8 02             	cmp    $0x2,%eax
801023b6:	0f 84 a8 00 00 00    	je     80102464 <iderw+0xd4>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
801023bc:	8b 53 04             	mov    0x4(%ebx),%edx
801023bf:	85 d2                	test   %edx,%edx
801023c1:	74 0d                	je     801023d0 <iderw+0x40>
801023c3:	a1 a0 26 11 80       	mov    0x801126a0,%eax
801023c8:	85 c0                	test   %eax,%eax
801023ca:	0f 84 87 00 00 00    	je     80102457 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
801023d0:	83 ec 0c             	sub    $0xc,%esp
801023d3:	68 c0 26 11 80       	push   $0x801126c0
801023d8:	e8 23 25 00 00       	call   80104900 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023dd:	a1 a4 26 11 80       	mov    0x801126a4,%eax
  b->qnext = 0;
801023e2:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801023e9:	83 c4 10             	add    $0x10,%esp
801023ec:	85 c0                	test   %eax,%eax
801023ee:	74 60                	je     80102450 <iderw+0xc0>
801023f0:	89 c2                	mov    %eax,%edx
801023f2:	8b 40 58             	mov    0x58(%eax),%eax
801023f5:	85 c0                	test   %eax,%eax
801023f7:	75 f7                	jne    801023f0 <iderw+0x60>
801023f9:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
801023fc:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
801023fe:	39 1d a4 26 11 80    	cmp    %ebx,0x801126a4
80102404:	74 3a                	je     80102440 <iderw+0xb0>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
80102406:	8b 03                	mov    (%ebx),%eax
80102408:	83 e0 06             	and    $0x6,%eax
8010240b:	83 f8 02             	cmp    $0x2,%eax
8010240e:	74 1b                	je     8010242b <iderw+0x9b>
    sleep(b, &idelock);
80102410:	83 ec 08             	sub    $0x8,%esp
80102413:	68 c0 26 11 80       	push   $0x801126c0
80102418:	53                   	push   %ebx
80102419:	e8 82 1f 00 00       	call   801043a0 <sleep>
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010241e:	8b 03                	mov    (%ebx),%eax
80102420:	83 c4 10             	add    $0x10,%esp
80102423:	83 e0 06             	and    $0x6,%eax
80102426:	83 f8 02             	cmp    $0x2,%eax
80102429:	75 e5                	jne    80102410 <iderw+0x80>
  }


  release(&idelock);
8010242b:	c7 45 08 c0 26 11 80 	movl   $0x801126c0,0x8(%ebp)
}
80102432:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102435:	c9                   	leave  
  release(&idelock);
80102436:	e9 65 24 00 00       	jmp    801048a0 <release>
8010243b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010243f:	90                   	nop
    idestart(b);
80102440:	89 d8                	mov    %ebx,%eax
80102442:	e8 49 fd ff ff       	call   80102190 <idestart>
80102447:	eb bd                	jmp    80102406 <iderw+0x76>
80102449:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102450:	ba a4 26 11 80       	mov    $0x801126a4,%edx
80102455:	eb a5                	jmp    801023fc <iderw+0x6c>
    panic("iderw: ide disk 1 not present");
80102457:	83 ec 0c             	sub    $0xc,%esp
8010245a:	68 35 79 10 80       	push   $0x80107935
8010245f:	e8 1c df ff ff       	call   80100380 <panic>
    panic("iderw: nothing to do");
80102464:	83 ec 0c             	sub    $0xc,%esp
80102467:	68 20 79 10 80       	push   $0x80107920
8010246c:	e8 0f df ff ff       	call   80100380 <panic>
    panic("iderw: buf not locked");
80102471:	83 ec 0c             	sub    $0xc,%esp
80102474:	68 0a 79 10 80       	push   $0x8010790a
80102479:	e8 02 df ff ff       	call   80100380 <panic>
8010247e:	66 90                	xchg   %ax,%ax

80102480 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102480:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102481:	c7 05 f4 26 11 80 00 	movl   $0xfec00000,0x801126f4
80102488:	00 c0 fe 
{
8010248b:	89 e5                	mov    %esp,%ebp
8010248d:	56                   	push   %esi
8010248e:	53                   	push   %ebx
  ioapic->reg = reg;
8010248f:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102496:	00 00 00 
  return ioapic->data;
80102499:	8b 15 f4 26 11 80    	mov    0x801126f4,%edx
8010249f:	8b 72 10             	mov    0x10(%edx),%esi
  ioapic->reg = reg;
801024a2:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
801024a8:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
801024ae:	0f b6 15 40 28 11 80 	movzbl 0x80112840,%edx
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
801024b5:	c1 ee 10             	shr    $0x10,%esi
801024b8:	89 f0                	mov    %esi,%eax
801024ba:	0f b6 f0             	movzbl %al,%esi
  return ioapic->data;
801024bd:	8b 41 10             	mov    0x10(%ecx),%eax
  id = ioapicread(REG_ID) >> 24;
801024c0:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
801024c3:	39 c2                	cmp    %eax,%edx
801024c5:	74 16                	je     801024dd <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
801024c7:	83 ec 0c             	sub    $0xc,%esp
801024ca:	68 54 79 10 80       	push   $0x80107954
801024cf:	e8 cc e1 ff ff       	call   801006a0 <cprintf>
  ioapic->reg = reg;
801024d4:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
801024da:	83 c4 10             	add    $0x10,%esp
801024dd:	83 c6 21             	add    $0x21,%esi
{
801024e0:	ba 10 00 00 00       	mov    $0x10,%edx
801024e5:	b8 20 00 00 00       	mov    $0x20,%eax
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  ioapic->reg = reg;
801024f0:	89 11                	mov    %edx,(%ecx)

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024f2:	89 c3                	mov    %eax,%ebx
  ioapic->data = data;
801024f4:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  for(i = 0; i <= maxintr; i++){
801024fa:	83 c0 01             	add    $0x1,%eax
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
801024fd:	81 cb 00 00 01 00    	or     $0x10000,%ebx
  ioapic->data = data;
80102503:	89 59 10             	mov    %ebx,0x10(%ecx)
  ioapic->reg = reg;
80102506:	8d 5a 01             	lea    0x1(%edx),%ebx
  for(i = 0; i <= maxintr; i++){
80102509:	83 c2 02             	add    $0x2,%edx
  ioapic->reg = reg;
8010250c:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
8010250e:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
80102514:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  for(i = 0; i <= maxintr; i++){
8010251b:	39 f0                	cmp    %esi,%eax
8010251d:	75 d1                	jne    801024f0 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010251f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102522:	5b                   	pop    %ebx
80102523:	5e                   	pop    %esi
80102524:	5d                   	pop    %ebp
80102525:	c3                   	ret    
80102526:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010252d:	8d 76 00             	lea    0x0(%esi),%esi

80102530 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
80102530:	55                   	push   %ebp
  ioapic->reg = reg;
80102531:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
{
80102537:	89 e5                	mov    %esp,%ebp
80102539:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
8010253c:	8d 50 20             	lea    0x20(%eax),%edx
8010253f:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
  ioapic->reg = reg;
80102543:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102545:	8b 0d f4 26 11 80    	mov    0x801126f4,%ecx
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010254b:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
8010254e:	89 51 10             	mov    %edx,0x10(%ecx)
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
80102551:	8b 55 0c             	mov    0xc(%ebp),%edx
  ioapic->reg = reg;
80102554:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
80102556:	a1 f4 26 11 80       	mov    0x801126f4,%eax
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
8010255b:	c1 e2 18             	shl    $0x18,%edx
  ioapic->data = data;
8010255e:	89 50 10             	mov    %edx,0x10(%eax)
}
80102561:	5d                   	pop    %ebp
80102562:	c3                   	ret    
80102563:	66 90                	xchg   %ax,%ax
80102565:	66 90                	xchg   %ax,%ax
80102567:	66 90                	xchg   %ax,%ax
80102569:	66 90                	xchg   %ax,%ax
8010256b:	66 90                	xchg   %ax,%ax
8010256d:	66 90                	xchg   %ax,%ax
8010256f:	90                   	nop

80102570 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102570:	55                   	push   %ebp
80102571:	89 e5                	mov    %esp,%ebp
80102573:	53                   	push   %ebx
80102574:	83 ec 04             	sub    $0x4,%esp
80102577:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010257a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102580:	75 76                	jne    801025f8 <kfree+0x88>
80102582:	81 fb 10 ef 11 80    	cmp    $0x8011ef10,%ebx
80102588:	72 6e                	jb     801025f8 <kfree+0x88>
8010258a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102590:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102595:	77 61                	ja     801025f8 <kfree+0x88>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102597:	83 ec 04             	sub    $0x4,%esp
8010259a:	68 00 10 00 00       	push   $0x1000
8010259f:	6a 01                	push   $0x1
801025a1:	53                   	push   %ebx
801025a2:	e8 19 24 00 00       	call   801049c0 <memset>

  if(kmem.use_lock)
801025a7:	8b 15 34 27 11 80    	mov    0x80112734,%edx
801025ad:	83 c4 10             	add    $0x10,%esp
801025b0:	85 d2                	test   %edx,%edx
801025b2:	75 1c                	jne    801025d0 <kfree+0x60>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
801025b4:	a1 38 27 11 80       	mov    0x80112738,%eax
801025b9:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
801025bb:	a1 34 27 11 80       	mov    0x80112734,%eax
  kmem.freelist = r;
801025c0:	89 1d 38 27 11 80    	mov    %ebx,0x80112738
  if(kmem.use_lock)
801025c6:	85 c0                	test   %eax,%eax
801025c8:	75 1e                	jne    801025e8 <kfree+0x78>
    release(&kmem.lock);
}
801025ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025cd:	c9                   	leave  
801025ce:	c3                   	ret    
801025cf:	90                   	nop
    acquire(&kmem.lock);
801025d0:	83 ec 0c             	sub    $0xc,%esp
801025d3:	68 00 27 11 80       	push   $0x80112700
801025d8:	e8 23 23 00 00       	call   80104900 <acquire>
801025dd:	83 c4 10             	add    $0x10,%esp
801025e0:	eb d2                	jmp    801025b4 <kfree+0x44>
801025e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    release(&kmem.lock);
801025e8:	c7 45 08 00 27 11 80 	movl   $0x80112700,0x8(%ebp)
}
801025ef:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801025f2:	c9                   	leave  
    release(&kmem.lock);
801025f3:	e9 a8 22 00 00       	jmp    801048a0 <release>
    panic("kfree");
801025f8:	83 ec 0c             	sub    $0xc,%esp
801025fb:	68 86 79 10 80       	push   $0x80107986
80102600:	e8 7b dd ff ff       	call   80100380 <panic>
80102605:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010260c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102610 <freerange>:
{
80102610:	55                   	push   %ebp
80102611:	89 e5                	mov    %esp,%ebp
80102613:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102614:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102617:	8b 75 0c             	mov    0xc(%ebp),%esi
8010261a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010261b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102621:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102627:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010262d:	39 de                	cmp    %ebx,%esi
8010262f:	72 23                	jb     80102654 <freerange+0x44>
80102631:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102638:	83 ec 0c             	sub    $0xc,%esp
8010263b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102641:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102647:	50                   	push   %eax
80102648:	e8 23 ff ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010264d:	83 c4 10             	add    $0x10,%esp
80102650:	39 f3                	cmp    %esi,%ebx
80102652:	76 e4                	jbe    80102638 <freerange+0x28>
}
80102654:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102657:	5b                   	pop    %ebx
80102658:	5e                   	pop    %esi
80102659:	5d                   	pop    %ebp
8010265a:	c3                   	ret    
8010265b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010265f:	90                   	nop

80102660 <kinit2>:
{
80102660:	55                   	push   %ebp
80102661:	89 e5                	mov    %esp,%ebp
80102663:	56                   	push   %esi
  p = (char*)PGROUNDUP((uint)vstart);
80102664:	8b 45 08             	mov    0x8(%ebp),%eax
{
80102667:	8b 75 0c             	mov    0xc(%ebp),%esi
8010266a:	53                   	push   %ebx
  p = (char*)PGROUNDUP((uint)vstart);
8010266b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102671:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102677:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010267d:	39 de                	cmp    %ebx,%esi
8010267f:	72 23                	jb     801026a4 <kinit2+0x44>
80102681:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102688:	83 ec 0c             	sub    $0xc,%esp
8010268b:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102691:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102697:	50                   	push   %eax
80102698:	e8 d3 fe ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010269d:	83 c4 10             	add    $0x10,%esp
801026a0:	39 de                	cmp    %ebx,%esi
801026a2:	73 e4                	jae    80102688 <kinit2+0x28>
  kmem.use_lock = 1;
801026a4:	c7 05 34 27 11 80 01 	movl   $0x1,0x80112734
801026ab:	00 00 00 
}
801026ae:	8d 65 f8             	lea    -0x8(%ebp),%esp
801026b1:	5b                   	pop    %ebx
801026b2:	5e                   	pop    %esi
801026b3:	5d                   	pop    %ebp
801026b4:	c3                   	ret    
801026b5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801026c0 <kinit1>:
{
801026c0:	55                   	push   %ebp
801026c1:	89 e5                	mov    %esp,%ebp
801026c3:	56                   	push   %esi
801026c4:	53                   	push   %ebx
801026c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801026c8:	83 ec 08             	sub    $0x8,%esp
801026cb:	68 8c 79 10 80       	push   $0x8010798c
801026d0:	68 00 27 11 80       	push   $0x80112700
801026d5:	e8 56 20 00 00       	call   80104730 <initlock>
  p = (char*)PGROUNDUP((uint)vstart);
801026da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026dd:	83 c4 10             	add    $0x10,%esp
  kmem.use_lock = 0;
801026e0:	c7 05 34 27 11 80 00 	movl   $0x0,0x80112734
801026e7:	00 00 00 
  p = (char*)PGROUNDUP((uint)vstart);
801026ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801026f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801026f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801026fc:	39 de                	cmp    %ebx,%esi
801026fe:	72 1c                	jb     8010271c <kinit1+0x5c>
    kfree(p);
80102700:	83 ec 0c             	sub    $0xc,%esp
80102703:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102709:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010270f:	50                   	push   %eax
80102710:	e8 5b fe ff ff       	call   80102570 <kfree>
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102715:	83 c4 10             	add    $0x10,%esp
80102718:	39 de                	cmp    %ebx,%esi
8010271a:	73 e4                	jae    80102700 <kinit1+0x40>
}
8010271c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010271f:	5b                   	pop    %ebx
80102720:	5e                   	pop    %esi
80102721:	5d                   	pop    %ebp
80102722:	c3                   	ret    
80102723:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010272a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102730 <kalloc>:
char*
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
80102730:	a1 34 27 11 80       	mov    0x80112734,%eax
80102735:	85 c0                	test   %eax,%eax
80102737:	75 1f                	jne    80102758 <kalloc+0x28>
    acquire(&kmem.lock);
  r = kmem.freelist;
80102739:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(r)
8010273e:	85 c0                	test   %eax,%eax
80102740:	74 0e                	je     80102750 <kalloc+0x20>
    kmem.freelist = r->next;
80102742:	8b 10                	mov    (%eax),%edx
80102744:	89 15 38 27 11 80    	mov    %edx,0x80112738
  if(kmem.use_lock)
8010274a:	c3                   	ret    
8010274b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010274f:	90                   	nop
    release(&kmem.lock);
  return (char*)r;
}
80102750:	c3                   	ret    
80102751:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80102758:	55                   	push   %ebp
80102759:	89 e5                	mov    %esp,%ebp
8010275b:	83 ec 24             	sub    $0x24,%esp
    acquire(&kmem.lock);
8010275e:	68 00 27 11 80       	push   $0x80112700
80102763:	e8 98 21 00 00       	call   80104900 <acquire>
  r = kmem.freelist;
80102768:	a1 38 27 11 80       	mov    0x80112738,%eax
  if(kmem.use_lock)
8010276d:	8b 15 34 27 11 80    	mov    0x80112734,%edx
  if(r)
80102773:	83 c4 10             	add    $0x10,%esp
80102776:	85 c0                	test   %eax,%eax
80102778:	74 08                	je     80102782 <kalloc+0x52>
    kmem.freelist = r->next;
8010277a:	8b 08                	mov    (%eax),%ecx
8010277c:	89 0d 38 27 11 80    	mov    %ecx,0x80112738
  if(kmem.use_lock)
80102782:	85 d2                	test   %edx,%edx
80102784:	74 16                	je     8010279c <kalloc+0x6c>
    release(&kmem.lock);
80102786:	83 ec 0c             	sub    $0xc,%esp
80102789:	89 45 f4             	mov    %eax,-0xc(%ebp)
8010278c:	68 00 27 11 80       	push   $0x80112700
80102791:	e8 0a 21 00 00       	call   801048a0 <release>
  return (char*)r;
80102796:	8b 45 f4             	mov    -0xc(%ebp),%eax
    release(&kmem.lock);
80102799:	83 c4 10             	add    $0x10,%esp
}
8010279c:	c9                   	leave  
8010279d:	c3                   	ret    
8010279e:	66 90                	xchg   %ax,%ax

801027a0 <kbdgetc>:
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027a0:	ba 64 00 00 00       	mov    $0x64,%edx
801027a5:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
801027a6:	a8 01                	test   $0x1,%al
801027a8:	0f 84 c2 00 00 00    	je     80102870 <kbdgetc+0xd0>
{
801027ae:	55                   	push   %ebp
801027af:	ba 60 00 00 00       	mov    $0x60,%edx
801027b4:	89 e5                	mov    %esp,%ebp
801027b6:	53                   	push   %ebx
801027b7:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801027b8:	8b 1d 3c 27 11 80    	mov    0x8011273c,%ebx
  data = inb(KBDATAP);
801027be:	0f b6 c8             	movzbl %al,%ecx
  if(data == 0xE0){
801027c1:	3c e0                	cmp    $0xe0,%al
801027c3:	74 5b                	je     80102820 <kbdgetc+0x80>
    return 0;
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
801027c5:	89 da                	mov    %ebx,%edx
801027c7:	83 e2 40             	and    $0x40,%edx
  } else if(data & 0x80){
801027ca:	84 c0                	test   %al,%al
801027cc:	78 62                	js     80102830 <kbdgetc+0x90>
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
801027ce:	85 d2                	test   %edx,%edx
801027d0:	74 09                	je     801027db <kbdgetc+0x3b>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
801027d2:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
801027d5:	83 e3 bf             	and    $0xffffffbf,%ebx
    data |= 0x80;
801027d8:	0f b6 c8             	movzbl %al,%ecx
  }

  shift |= shiftcode[data];
801027db:	0f b6 91 c0 7a 10 80 	movzbl -0x7fef8540(%ecx),%edx
  shift ^= togglecode[data];
801027e2:	0f b6 81 c0 79 10 80 	movzbl -0x7fef8640(%ecx),%eax
  shift |= shiftcode[data];
801027e9:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
801027eb:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027ed:	89 d0                	mov    %edx,%eax
  shift ^= togglecode[data];
801027ef:	89 15 3c 27 11 80    	mov    %edx,0x8011273c
  c = charcode[shift & (CTL | SHIFT)][data];
801027f5:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
801027f8:	83 e2 08             	and    $0x8,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
801027fb:	8b 04 85 a0 79 10 80 	mov    -0x7fef8660(,%eax,4),%eax
80102802:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
80102806:	74 0b                	je     80102813 <kbdgetc+0x73>
    if('a' <= c && c <= 'z')
80102808:	8d 50 9f             	lea    -0x61(%eax),%edx
8010280b:	83 fa 19             	cmp    $0x19,%edx
8010280e:	77 48                	ja     80102858 <kbdgetc+0xb8>
      c += 'A' - 'a';
80102810:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102813:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102816:	c9                   	leave  
80102817:	c3                   	ret    
80102818:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010281f:	90                   	nop
    shift |= E0ESC;
80102820:	83 cb 40             	or     $0x40,%ebx
    return 0;
80102823:	31 c0                	xor    %eax,%eax
    shift |= E0ESC;
80102825:	89 1d 3c 27 11 80    	mov    %ebx,0x8011273c
}
8010282b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010282e:	c9                   	leave  
8010282f:	c3                   	ret    
    data = (shift & E0ESC ? data : data & 0x7F);
80102830:	83 e0 7f             	and    $0x7f,%eax
80102833:	85 d2                	test   %edx,%edx
80102835:	0f 44 c8             	cmove  %eax,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102838:	0f b6 81 c0 7a 10 80 	movzbl -0x7fef8540(%ecx),%eax
8010283f:	83 c8 40             	or     $0x40,%eax
80102842:	0f b6 c0             	movzbl %al,%eax
80102845:	f7 d0                	not    %eax
80102847:	21 d8                	and    %ebx,%eax
}
80102849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    shift &= ~(shiftcode[data] | E0ESC);
8010284c:	a3 3c 27 11 80       	mov    %eax,0x8011273c
    return 0;
80102851:	31 c0                	xor    %eax,%eax
}
80102853:	c9                   	leave  
80102854:	c3                   	ret    
80102855:	8d 76 00             	lea    0x0(%esi),%esi
    else if('A' <= c && c <= 'Z')
80102858:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
8010285b:	8d 50 20             	lea    0x20(%eax),%edx
}
8010285e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102861:	c9                   	leave  
      c += 'a' - 'A';
80102862:	83 f9 1a             	cmp    $0x1a,%ecx
80102865:	0f 42 c2             	cmovb  %edx,%eax
}
80102868:	c3                   	ret    
80102869:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80102870:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80102875:	c3                   	ret    
80102876:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010287d:	8d 76 00             	lea    0x0(%esi),%esi

80102880 <kbdintr>:

void
kbdintr(void)
{
80102880:	55                   	push   %ebp
80102881:	89 e5                	mov    %esp,%ebp
80102883:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
80102886:	68 a0 27 10 80       	push   $0x801027a0
8010288b:	e8 f0 df ff ff       	call   80100880 <consoleintr>
}
80102890:	83 c4 10             	add    $0x10,%esp
80102893:	c9                   	leave  
80102894:	c3                   	ret    
80102895:	66 90                	xchg   %ax,%ax
80102897:	66 90                	xchg   %ax,%ax
80102899:	66 90                	xchg   %ax,%ax
8010289b:	66 90                	xchg   %ax,%ax
8010289d:	66 90                	xchg   %ax,%ax
8010289f:	90                   	nop

801028a0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801028a0:	a1 40 27 11 80       	mov    0x80112740,%eax
801028a5:	85 c0                	test   %eax,%eax
801028a7:	0f 84 cb 00 00 00    	je     80102978 <lapicinit+0xd8>
  lapic[index] = value;
801028ad:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
801028b4:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028b7:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ba:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801028c1:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801028c4:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028c7:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801028ce:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801028d1:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028d4:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801028db:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801028de:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028e1:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801028e8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028eb:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
801028ee:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801028f5:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801028f8:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801028fb:	8b 50 30             	mov    0x30(%eax),%edx
801028fe:	c1 ea 10             	shr    $0x10,%edx
80102901:	81 e2 fc 00 00 00    	and    $0xfc,%edx
80102907:	75 77                	jne    80102980 <lapicinit+0xe0>
  lapic[index] = value;
80102909:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102910:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102913:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102916:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010291d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102920:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102923:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010292a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010292d:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102930:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102937:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010293a:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010293d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102944:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102947:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
8010294a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102951:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102954:	8b 50 20             	mov    0x20(%eax),%edx
80102957:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010295e:	66 90                	xchg   %ax,%ax
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102960:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
80102966:	80 e6 10             	and    $0x10,%dh
80102969:	75 f5                	jne    80102960 <lapicinit+0xc0>
  lapic[index] = value;
8010296b:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
80102972:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102975:	8b 40 20             	mov    0x20(%eax),%eax
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102978:	c3                   	ret    
80102979:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  lapic[index] = value;
80102980:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
80102987:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010298a:	8b 50 20             	mov    0x20(%eax),%edx
}
8010298d:	e9 77 ff ff ff       	jmp    80102909 <lapicinit+0x69>
80102992:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801029a0 <lapicid>:

int
lapicid(void)
{
  if (!lapic)
801029a0:	a1 40 27 11 80       	mov    0x80112740,%eax
801029a5:	85 c0                	test   %eax,%eax
801029a7:	74 07                	je     801029b0 <lapicid+0x10>
    return 0;
  return lapic[ID] >> 24;
801029a9:	8b 40 20             	mov    0x20(%eax),%eax
801029ac:	c1 e8 18             	shr    $0x18,%eax
801029af:	c3                   	ret    
    return 0;
801029b0:	31 c0                	xor    %eax,%eax
}
801029b2:	c3                   	ret    
801029b3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801029c0 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
801029c0:	a1 40 27 11 80       	mov    0x80112740,%eax
801029c5:	85 c0                	test   %eax,%eax
801029c7:	74 0d                	je     801029d6 <lapiceoi+0x16>
  lapic[index] = value;
801029c9:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801029d0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801029d3:	8b 40 20             	mov    0x20(%eax),%eax
    lapicw(EOI, 0);
}
801029d6:	c3                   	ret    
801029d7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029de:	66 90                	xchg   %ax,%ax

801029e0 <microdelay>:
// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
}
801029e0:	c3                   	ret    
801029e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029e8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801029ef:	90                   	nop

801029f0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801029f0:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801029f1:	b8 0f 00 00 00       	mov    $0xf,%eax
801029f6:	ba 70 00 00 00       	mov    $0x70,%edx
801029fb:	89 e5                	mov    %esp,%ebp
801029fd:	53                   	push   %ebx
801029fe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102a01:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102a04:	ee                   	out    %al,(%dx)
80102a05:	b8 0a 00 00 00       	mov    $0xa,%eax
80102a0a:	ba 71 00 00 00       	mov    $0x71,%edx
80102a0f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102a10:	31 c0                	xor    %eax,%eax
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
80102a12:	c1 e3 18             	shl    $0x18,%ebx
  wrv[0] = 0;
80102a15:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
80102a1b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a1d:	c1 e9 0c             	shr    $0xc,%ecx
  lapicw(ICRHI, apicid<<24);
80102a20:	89 da                	mov    %ebx,%edx
  wrv[1] = addr >> 4;
80102a22:	c1 e8 04             	shr    $0x4,%eax
    lapicw(ICRLO, STARTUP | (addr>>12));
80102a25:	80 cd 06             	or     $0x6,%ch
  wrv[1] = addr >> 4;
80102a28:	66 a3 69 04 00 80    	mov    %ax,0x80000469
  lapic[index] = value;
80102a2e:	a1 40 27 11 80       	mov    0x80112740,%eax
80102a33:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a39:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a3c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102a43:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a46:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a49:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102a50:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102a53:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a56:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a5c:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a5f:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a65:	8b 58 20             	mov    0x20(%eax),%ebx
  lapic[index] = value;
80102a68:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a6e:	8b 50 20             	mov    0x20(%eax),%edx
  lapic[index] = value;
80102a71:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102a77:	8b 40 20             	mov    0x20(%eax),%eax
    microdelay(200);
  }
}
80102a7a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102a7d:	c9                   	leave  
80102a7e:	c3                   	ret    
80102a7f:	90                   	nop

80102a80 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102a80:	55                   	push   %ebp
80102a81:	b8 0b 00 00 00       	mov    $0xb,%eax
80102a86:	ba 70 00 00 00       	mov    $0x70,%edx
80102a8b:	89 e5                	mov    %esp,%ebp
80102a8d:	57                   	push   %edi
80102a8e:	56                   	push   %esi
80102a8f:	53                   	push   %ebx
80102a90:	83 ec 4c             	sub    $0x4c,%esp
80102a93:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102a94:	ba 71 00 00 00       	mov    $0x71,%edx
80102a99:	ec                   	in     (%dx),%al
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
80102a9a:	83 e0 04             	and    $0x4,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102a9d:	bb 70 00 00 00       	mov    $0x70,%ebx
80102aa2:	88 45 b3             	mov    %al,-0x4d(%ebp)
80102aa5:	8d 76 00             	lea    0x0(%esi),%esi
80102aa8:	31 c0                	xor    %eax,%eax
80102aaa:	89 da                	mov    %ebx,%edx
80102aac:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aad:	b9 71 00 00 00       	mov    $0x71,%ecx
80102ab2:	89 ca                	mov    %ecx,%edx
80102ab4:	ec                   	in     (%dx),%al
80102ab5:	88 45 b7             	mov    %al,-0x49(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ab8:	89 da                	mov    %ebx,%edx
80102aba:	b8 02 00 00 00       	mov    $0x2,%eax
80102abf:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ac0:	89 ca                	mov    %ecx,%edx
80102ac2:	ec                   	in     (%dx),%al
80102ac3:	88 45 b6             	mov    %al,-0x4a(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ac6:	89 da                	mov    %ebx,%edx
80102ac8:	b8 04 00 00 00       	mov    $0x4,%eax
80102acd:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102ace:	89 ca                	mov    %ecx,%edx
80102ad0:	ec                   	in     (%dx),%al
80102ad1:	88 45 b5             	mov    %al,-0x4b(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ad4:	89 da                	mov    %ebx,%edx
80102ad6:	b8 07 00 00 00       	mov    $0x7,%eax
80102adb:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102adc:	89 ca                	mov    %ecx,%edx
80102ade:	ec                   	in     (%dx),%al
80102adf:	88 45 b4             	mov    %al,-0x4c(%ebp)
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102ae2:	89 da                	mov    %ebx,%edx
80102ae4:	b8 08 00 00 00       	mov    $0x8,%eax
80102ae9:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102aea:	89 ca                	mov    %ecx,%edx
80102aec:	ec                   	in     (%dx),%al
80102aed:	89 c7                	mov    %eax,%edi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102aef:	89 da                	mov    %ebx,%edx
80102af1:	b8 09 00 00 00       	mov    $0x9,%eax
80102af6:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102af7:	89 ca                	mov    %ecx,%edx
80102af9:	ec                   	in     (%dx),%al
80102afa:	89 c6                	mov    %eax,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102afc:	89 da                	mov    %ebx,%edx
80102afe:	b8 0a 00 00 00       	mov    $0xa,%eax
80102b03:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b04:	89 ca                	mov    %ecx,%edx
80102b06:	ec                   	in     (%dx),%al

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102b07:	84 c0                	test   %al,%al
80102b09:	78 9d                	js     80102aa8 <cmostime+0x28>
  return inb(CMOS_RETURN);
80102b0b:	0f b6 45 b7          	movzbl -0x49(%ebp),%eax
80102b0f:	89 fa                	mov    %edi,%edx
80102b11:	0f b6 fa             	movzbl %dl,%edi
80102b14:	89 f2                	mov    %esi,%edx
80102b16:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102b19:	0f b6 45 b6          	movzbl -0x4a(%ebp),%eax
80102b1d:	0f b6 f2             	movzbl %dl,%esi
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b20:	89 da                	mov    %ebx,%edx
80102b22:	89 7d c8             	mov    %edi,-0x38(%ebp)
80102b25:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102b28:	0f b6 45 b5          	movzbl -0x4b(%ebp),%eax
80102b2c:	89 75 cc             	mov    %esi,-0x34(%ebp)
80102b2f:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102b32:	0f b6 45 b4          	movzbl -0x4c(%ebp),%eax
80102b36:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102b39:	31 c0                	xor    %eax,%eax
80102b3b:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b3c:	89 ca                	mov    %ecx,%edx
80102b3e:	ec                   	in     (%dx),%al
80102b3f:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b42:	89 da                	mov    %ebx,%edx
80102b44:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102b47:	b8 02 00 00 00       	mov    $0x2,%eax
80102b4c:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b4d:	89 ca                	mov    %ecx,%edx
80102b4f:	ec                   	in     (%dx),%al
80102b50:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b53:	89 da                	mov    %ebx,%edx
80102b55:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102b58:	b8 04 00 00 00       	mov    $0x4,%eax
80102b5d:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b5e:	89 ca                	mov    %ecx,%edx
80102b60:	ec                   	in     (%dx),%al
80102b61:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b64:	89 da                	mov    %ebx,%edx
80102b66:	89 45 d8             	mov    %eax,-0x28(%ebp)
80102b69:	b8 07 00 00 00       	mov    $0x7,%eax
80102b6e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b6f:	89 ca                	mov    %ecx,%edx
80102b71:	ec                   	in     (%dx),%al
80102b72:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b75:	89 da                	mov    %ebx,%edx
80102b77:	89 45 dc             	mov    %eax,-0x24(%ebp)
80102b7a:	b8 08 00 00 00       	mov    $0x8,%eax
80102b7f:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b80:	89 ca                	mov    %ecx,%edx
80102b82:	ec                   	in     (%dx),%al
80102b83:	0f b6 c0             	movzbl %al,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102b86:	89 da                	mov    %ebx,%edx
80102b88:	89 45 e0             	mov    %eax,-0x20(%ebp)
80102b8b:	b8 09 00 00 00       	mov    $0x9,%eax
80102b90:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102b91:	89 ca                	mov    %ecx,%edx
80102b93:	ec                   	in     (%dx),%al
80102b94:	0f b6 c0             	movzbl %al,%eax
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b97:	83 ec 04             	sub    $0x4,%esp
  return inb(CMOS_RETURN);
80102b9a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
80102b9d:	8d 45 d0             	lea    -0x30(%ebp),%eax
80102ba0:	6a 18                	push   $0x18
80102ba2:	50                   	push   %eax
80102ba3:	8d 45 b8             	lea    -0x48(%ebp),%eax
80102ba6:	50                   	push   %eax
80102ba7:	e8 64 1e 00 00       	call   80104a10 <memcmp>
80102bac:	83 c4 10             	add    $0x10,%esp
80102baf:	85 c0                	test   %eax,%eax
80102bb1:	0f 85 f1 fe ff ff    	jne    80102aa8 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
80102bb7:	80 7d b3 00          	cmpb   $0x0,-0x4d(%ebp)
80102bbb:	75 78                	jne    80102c35 <cmostime+0x1b5>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
80102bbd:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102bc0:	89 c2                	mov    %eax,%edx
80102bc2:	83 e0 0f             	and    $0xf,%eax
80102bc5:	c1 ea 04             	shr    $0x4,%edx
80102bc8:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bcb:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bce:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
80102bd1:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102bd4:	89 c2                	mov    %eax,%edx
80102bd6:	83 e0 0f             	and    $0xf,%eax
80102bd9:	c1 ea 04             	shr    $0x4,%edx
80102bdc:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bdf:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102be2:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102be5:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102be8:	89 c2                	mov    %eax,%edx
80102bea:	83 e0 0f             	and    $0xf,%eax
80102bed:	c1 ea 04             	shr    $0x4,%edx
80102bf0:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102bf3:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102bf6:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102bf9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102bfc:	89 c2                	mov    %eax,%edx
80102bfe:	83 e0 0f             	and    $0xf,%eax
80102c01:	c1 ea 04             	shr    $0x4,%edx
80102c04:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c07:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c0a:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
80102c0d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c10:	89 c2                	mov    %eax,%edx
80102c12:	83 e0 0f             	and    $0xf,%eax
80102c15:	c1 ea 04             	shr    $0x4,%edx
80102c18:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c1b:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c1e:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
80102c21:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c24:	89 c2                	mov    %eax,%edx
80102c26:	83 e0 0f             	and    $0xf,%eax
80102c29:	c1 ea 04             	shr    $0x4,%edx
80102c2c:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102c2f:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102c32:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102c35:	8b 75 08             	mov    0x8(%ebp),%esi
80102c38:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102c3b:	89 06                	mov    %eax,(%esi)
80102c3d:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102c40:	89 46 04             	mov    %eax,0x4(%esi)
80102c43:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102c46:	89 46 08             	mov    %eax,0x8(%esi)
80102c49:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102c4c:	89 46 0c             	mov    %eax,0xc(%esi)
80102c4f:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102c52:	89 46 10             	mov    %eax,0x10(%esi)
80102c55:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102c58:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102c5b:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
80102c62:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102c65:	5b                   	pop    %ebx
80102c66:	5e                   	pop    %esi
80102c67:	5f                   	pop    %edi
80102c68:	5d                   	pop    %ebp
80102c69:	c3                   	ret    
80102c6a:	66 90                	xchg   %ax,%ax
80102c6c:	66 90                	xchg   %ax,%ax
80102c6e:	66 90                	xchg   %ax,%ax

80102c70 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c70:	8b 0d a8 27 11 80    	mov    0x801127a8,%ecx
80102c76:	85 c9                	test   %ecx,%ecx
80102c78:	0f 8e 8a 00 00 00    	jle    80102d08 <install_trans+0x98>
{
80102c7e:	55                   	push   %ebp
80102c7f:	89 e5                	mov    %esp,%ebp
80102c81:	57                   	push   %edi
  for (tail = 0; tail < log.lh.n; tail++) {
80102c82:	31 ff                	xor    %edi,%edi
{
80102c84:	56                   	push   %esi
80102c85:	53                   	push   %ebx
80102c86:	83 ec 0c             	sub    $0xc,%esp
80102c89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102c90:	a1 94 27 11 80       	mov    0x80112794,%eax
80102c95:	83 ec 08             	sub    $0x8,%esp
80102c98:	01 f8                	add    %edi,%eax
80102c9a:	83 c0 01             	add    $0x1,%eax
80102c9d:	50                   	push   %eax
80102c9e:	ff 35 a4 27 11 80    	push   0x801127a4
80102ca4:	e8 27 d4 ff ff       	call   801000d0 <bread>
80102ca9:	89 c6                	mov    %eax,%esi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cab:	58                   	pop    %eax
80102cac:	5a                   	pop    %edx
80102cad:	ff 34 bd ac 27 11 80 	push   -0x7feed854(,%edi,4)
80102cb4:	ff 35 a4 27 11 80    	push   0x801127a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102cba:	83 c7 01             	add    $0x1,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cbd:	e8 0e d4 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc2:	83 c4 0c             	add    $0xc,%esp
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
80102cc5:	89 c3                	mov    %eax,%ebx
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102cc7:	8d 46 5c             	lea    0x5c(%esi),%eax
80102cca:	68 00 02 00 00       	push   $0x200
80102ccf:	50                   	push   %eax
80102cd0:	8d 43 5c             	lea    0x5c(%ebx),%eax
80102cd3:	50                   	push   %eax
80102cd4:	e8 87 1d 00 00       	call   80104a60 <memmove>
    bwrite(dbuf);  // write dst to disk
80102cd9:	89 1c 24             	mov    %ebx,(%esp)
80102cdc:	e8 cf d4 ff ff       	call   801001b0 <bwrite>
    brelse(lbuf);
80102ce1:	89 34 24             	mov    %esi,(%esp)
80102ce4:	e8 07 d5 ff ff       	call   801001f0 <brelse>
    brelse(dbuf);
80102ce9:	89 1c 24             	mov    %ebx,(%esp)
80102cec:	e8 ff d4 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102cf1:	83 c4 10             	add    $0x10,%esp
80102cf4:	39 3d a8 27 11 80    	cmp    %edi,0x801127a8
80102cfa:	7f 94                	jg     80102c90 <install_trans+0x20>
  }
}
80102cfc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102cff:	5b                   	pop    %ebx
80102d00:	5e                   	pop    %esi
80102d01:	5f                   	pop    %edi
80102d02:	5d                   	pop    %ebp
80102d03:	c3                   	ret    
80102d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d08:	c3                   	ret    
80102d09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102d10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102d10:	55                   	push   %ebp
80102d11:	89 e5                	mov    %esp,%ebp
80102d13:	53                   	push   %ebx
80102d14:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d17:	ff 35 94 27 11 80    	push   0x80112794
80102d1d:	ff 35 a4 27 11 80    	push   0x801127a4
80102d23:	e8 a8 d3 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102d28:	83 c4 10             	add    $0x10,%esp
  struct buf *buf = bread(log.dev, log.start);
80102d2b:	89 c3                	mov    %eax,%ebx
  hb->n = log.lh.n;
80102d2d:	a1 a8 27 11 80       	mov    0x801127a8,%eax
80102d32:	89 43 5c             	mov    %eax,0x5c(%ebx)
  for (i = 0; i < log.lh.n; i++) {
80102d35:	85 c0                	test   %eax,%eax
80102d37:	7e 19                	jle    80102d52 <write_head+0x42>
80102d39:	31 d2                	xor    %edx,%edx
80102d3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d3f:	90                   	nop
    hb->block[i] = log.lh.block[i];
80102d40:	8b 0c 95 ac 27 11 80 	mov    -0x7feed854(,%edx,4),%ecx
80102d47:	89 4c 93 60          	mov    %ecx,0x60(%ebx,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102d4b:	83 c2 01             	add    $0x1,%edx
80102d4e:	39 d0                	cmp    %edx,%eax
80102d50:	75 ee                	jne    80102d40 <write_head+0x30>
  }
  bwrite(buf);
80102d52:	83 ec 0c             	sub    $0xc,%esp
80102d55:	53                   	push   %ebx
80102d56:	e8 55 d4 ff ff       	call   801001b0 <bwrite>
  brelse(buf);
80102d5b:	89 1c 24             	mov    %ebx,(%esp)
80102d5e:	e8 8d d4 ff ff       	call   801001f0 <brelse>
}
80102d63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102d66:	83 c4 10             	add    $0x10,%esp
80102d69:	c9                   	leave  
80102d6a:	c3                   	ret    
80102d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d6f:	90                   	nop

80102d70 <initlog>:
{
80102d70:	55                   	push   %ebp
80102d71:	89 e5                	mov    %esp,%ebp
80102d73:	53                   	push   %ebx
80102d74:	83 ec 2c             	sub    $0x2c,%esp
80102d77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&log.lock, "log");
80102d7a:	68 c0 7b 10 80       	push   $0x80107bc0
80102d7f:	68 60 27 11 80       	push   $0x80112760
80102d84:	e8 a7 19 00 00       	call   80104730 <initlock>
  readsb(dev, &sb);
80102d89:	58                   	pop    %eax
80102d8a:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102d8d:	5a                   	pop    %edx
80102d8e:	50                   	push   %eax
80102d8f:	53                   	push   %ebx
80102d90:	e8 1b e8 ff ff       	call   801015b0 <readsb>
  log.start = sb.logstart;
80102d95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  struct buf *buf = bread(log.dev, log.start);
80102d98:	59                   	pop    %ecx
  log.dev = dev;
80102d99:	89 1d a4 27 11 80    	mov    %ebx,0x801127a4
  log.size = sb.nlog;
80102d9f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  log.start = sb.logstart;
80102da2:	a3 94 27 11 80       	mov    %eax,0x80112794
  log.size = sb.nlog;
80102da7:	89 15 98 27 11 80    	mov    %edx,0x80112798
  struct buf *buf = bread(log.dev, log.start);
80102dad:	5a                   	pop    %edx
80102dae:	50                   	push   %eax
80102daf:	53                   	push   %ebx
80102db0:	e8 1b d3 ff ff       	call   801000d0 <bread>
  for (i = 0; i < log.lh.n; i++) {
80102db5:	83 c4 10             	add    $0x10,%esp
  log.lh.n = lh->n;
80102db8:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102dbb:	89 1d a8 27 11 80    	mov    %ebx,0x801127a8
  for (i = 0; i < log.lh.n; i++) {
80102dc1:	85 db                	test   %ebx,%ebx
80102dc3:	7e 1d                	jle    80102de2 <initlog+0x72>
80102dc5:	31 d2                	xor    %edx,%edx
80102dc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102dce:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102dd0:	8b 4c 90 60          	mov    0x60(%eax,%edx,4),%ecx
80102dd4:	89 0c 95 ac 27 11 80 	mov    %ecx,-0x7feed854(,%edx,4)
  for (i = 0; i < log.lh.n; i++) {
80102ddb:	83 c2 01             	add    $0x1,%edx
80102dde:	39 d3                	cmp    %edx,%ebx
80102de0:	75 ee                	jne    80102dd0 <initlog+0x60>
  brelse(buf);
80102de2:	83 ec 0c             	sub    $0xc,%esp
80102de5:	50                   	push   %eax
80102de6:	e8 05 d4 ff ff       	call   801001f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102deb:	e8 80 fe ff ff       	call   80102c70 <install_trans>
  log.lh.n = 0;
80102df0:	c7 05 a8 27 11 80 00 	movl   $0x0,0x801127a8
80102df7:	00 00 00 
  write_head(); // clear the log
80102dfa:	e8 11 ff ff ff       	call   80102d10 <write_head>
}
80102dff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102e02:	83 c4 10             	add    $0x10,%esp
80102e05:	c9                   	leave  
80102e06:	c3                   	ret    
80102e07:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e0e:	66 90                	xchg   %ax,%ax

80102e10 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102e10:	55                   	push   %ebp
80102e11:	89 e5                	mov    %esp,%ebp
80102e13:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102e16:	68 60 27 11 80       	push   $0x80112760
80102e1b:	e8 e0 1a 00 00       	call   80104900 <acquire>
80102e20:	83 c4 10             	add    $0x10,%esp
80102e23:	eb 18                	jmp    80102e3d <begin_op+0x2d>
80102e25:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102e28:	83 ec 08             	sub    $0x8,%esp
80102e2b:	68 60 27 11 80       	push   $0x80112760
80102e30:	68 60 27 11 80       	push   $0x80112760
80102e35:	e8 66 15 00 00       	call   801043a0 <sleep>
80102e3a:	83 c4 10             	add    $0x10,%esp
    if(log.committing){
80102e3d:	a1 a0 27 11 80       	mov    0x801127a0,%eax
80102e42:	85 c0                	test   %eax,%eax
80102e44:	75 e2                	jne    80102e28 <begin_op+0x18>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102e46:	a1 9c 27 11 80       	mov    0x8011279c,%eax
80102e4b:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
80102e51:	83 c0 01             	add    $0x1,%eax
80102e54:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102e57:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102e5a:	83 fa 1e             	cmp    $0x1e,%edx
80102e5d:	7f c9                	jg     80102e28 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102e5f:	83 ec 0c             	sub    $0xc,%esp
      log.outstanding += 1;
80102e62:	a3 9c 27 11 80       	mov    %eax,0x8011279c
      release(&log.lock);
80102e67:	68 60 27 11 80       	push   $0x80112760
80102e6c:	e8 2f 1a 00 00       	call   801048a0 <release>
      break;
    }
  }
}
80102e71:	83 c4 10             	add    $0x10,%esp
80102e74:	c9                   	leave  
80102e75:	c3                   	ret    
80102e76:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102e7d:	8d 76 00             	lea    0x0(%esi),%esi

80102e80 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102e80:	55                   	push   %ebp
80102e81:	89 e5                	mov    %esp,%ebp
80102e83:	57                   	push   %edi
80102e84:	56                   	push   %esi
80102e85:	53                   	push   %ebx
80102e86:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102e89:	68 60 27 11 80       	push   $0x80112760
80102e8e:	e8 6d 1a 00 00       	call   80104900 <acquire>
  log.outstanding -= 1;
80102e93:	a1 9c 27 11 80       	mov    0x8011279c,%eax
  if(log.committing)
80102e98:	8b 35 a0 27 11 80    	mov    0x801127a0,%esi
80102e9e:	83 c4 10             	add    $0x10,%esp
  log.outstanding -= 1;
80102ea1:	8d 58 ff             	lea    -0x1(%eax),%ebx
80102ea4:	89 1d 9c 27 11 80    	mov    %ebx,0x8011279c
  if(log.committing)
80102eaa:	85 f6                	test   %esi,%esi
80102eac:	0f 85 22 01 00 00    	jne    80102fd4 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102eb2:	85 db                	test   %ebx,%ebx
80102eb4:	0f 85 f6 00 00 00    	jne    80102fb0 <end_op+0x130>
    do_commit = 1;
    log.committing = 1;
80102eba:	c7 05 a0 27 11 80 01 	movl   $0x1,0x801127a0
80102ec1:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102ec4:	83 ec 0c             	sub    $0xc,%esp
80102ec7:	68 60 27 11 80       	push   $0x80112760
80102ecc:	e8 cf 19 00 00       	call   801048a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102ed1:	8b 0d a8 27 11 80    	mov    0x801127a8,%ecx
80102ed7:	83 c4 10             	add    $0x10,%esp
80102eda:	85 c9                	test   %ecx,%ecx
80102edc:	7f 42                	jg     80102f20 <end_op+0xa0>
    acquire(&log.lock);
80102ede:	83 ec 0c             	sub    $0xc,%esp
80102ee1:	68 60 27 11 80       	push   $0x80112760
80102ee6:	e8 15 1a 00 00       	call   80104900 <acquire>
    wakeup(&log);
80102eeb:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
    log.committing = 0;
80102ef2:	c7 05 a0 27 11 80 00 	movl   $0x0,0x801127a0
80102ef9:	00 00 00 
    wakeup(&log);
80102efc:	e8 5f 15 00 00       	call   80104460 <wakeup>
    release(&log.lock);
80102f01:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102f08:	e8 93 19 00 00       	call   801048a0 <release>
80102f0d:	83 c4 10             	add    $0x10,%esp
}
80102f10:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102f13:	5b                   	pop    %ebx
80102f14:	5e                   	pop    %esi
80102f15:	5f                   	pop    %edi
80102f16:	5d                   	pop    %ebp
80102f17:	c3                   	ret    
80102f18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102f1f:	90                   	nop
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102f20:	a1 94 27 11 80       	mov    0x80112794,%eax
80102f25:	83 ec 08             	sub    $0x8,%esp
80102f28:	01 d8                	add    %ebx,%eax
80102f2a:	83 c0 01             	add    $0x1,%eax
80102f2d:	50                   	push   %eax
80102f2e:	ff 35 a4 27 11 80    	push   0x801127a4
80102f34:	e8 97 d1 ff ff       	call   801000d0 <bread>
80102f39:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f3b:	58                   	pop    %eax
80102f3c:	5a                   	pop    %edx
80102f3d:	ff 34 9d ac 27 11 80 	push   -0x7feed854(,%ebx,4)
80102f44:	ff 35 a4 27 11 80    	push   0x801127a4
  for (tail = 0; tail < log.lh.n; tail++) {
80102f4a:	83 c3 01             	add    $0x1,%ebx
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f4d:	e8 7e d1 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102f52:	83 c4 0c             	add    $0xc,%esp
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102f55:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102f57:	8d 40 5c             	lea    0x5c(%eax),%eax
80102f5a:	68 00 02 00 00       	push   $0x200
80102f5f:	50                   	push   %eax
80102f60:	8d 46 5c             	lea    0x5c(%esi),%eax
80102f63:	50                   	push   %eax
80102f64:	e8 f7 1a 00 00       	call   80104a60 <memmove>
    bwrite(to);  // write the log
80102f69:	89 34 24             	mov    %esi,(%esp)
80102f6c:	e8 3f d2 ff ff       	call   801001b0 <bwrite>
    brelse(from);
80102f71:	89 3c 24             	mov    %edi,(%esp)
80102f74:	e8 77 d2 ff ff       	call   801001f0 <brelse>
    brelse(to);
80102f79:	89 34 24             	mov    %esi,(%esp)
80102f7c:	e8 6f d2 ff ff       	call   801001f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
80102f81:	83 c4 10             	add    $0x10,%esp
80102f84:	3b 1d a8 27 11 80    	cmp    0x801127a8,%ebx
80102f8a:	7c 94                	jl     80102f20 <end_op+0xa0>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102f8c:	e8 7f fd ff ff       	call   80102d10 <write_head>
    install_trans(); // Now install writes to home locations
80102f91:	e8 da fc ff ff       	call   80102c70 <install_trans>
    log.lh.n = 0;
80102f96:	c7 05 a8 27 11 80 00 	movl   $0x0,0x801127a8
80102f9d:	00 00 00 
    write_head();    // Erase the transaction from the log
80102fa0:	e8 6b fd ff ff       	call   80102d10 <write_head>
80102fa5:	e9 34 ff ff ff       	jmp    80102ede <end_op+0x5e>
80102faa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&log);
80102fb0:	83 ec 0c             	sub    $0xc,%esp
80102fb3:	68 60 27 11 80       	push   $0x80112760
80102fb8:	e8 a3 14 00 00       	call   80104460 <wakeup>
  release(&log.lock);
80102fbd:	c7 04 24 60 27 11 80 	movl   $0x80112760,(%esp)
80102fc4:	e8 d7 18 00 00       	call   801048a0 <release>
80102fc9:	83 c4 10             	add    $0x10,%esp
}
80102fcc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102fcf:	5b                   	pop    %ebx
80102fd0:	5e                   	pop    %esi
80102fd1:	5f                   	pop    %edi
80102fd2:	5d                   	pop    %ebp
80102fd3:	c3                   	ret    
    panic("log.committing");
80102fd4:	83 ec 0c             	sub    $0xc,%esp
80102fd7:	68 c4 7b 10 80       	push   $0x80107bc4
80102fdc:	e8 9f d3 ff ff       	call   80100380 <panic>
80102fe1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fe8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102fef:	90                   	nop

80102ff0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ff0:	55                   	push   %ebp
80102ff1:	89 e5                	mov    %esp,%ebp
80102ff3:	53                   	push   %ebx
80102ff4:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ff7:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
{
80102ffd:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80103000:	83 fa 1d             	cmp    $0x1d,%edx
80103003:	0f 8f 85 00 00 00    	jg     8010308e <log_write+0x9e>
80103009:	a1 98 27 11 80       	mov    0x80112798,%eax
8010300e:	83 e8 01             	sub    $0x1,%eax
80103011:	39 c2                	cmp    %eax,%edx
80103013:	7d 79                	jge    8010308e <log_write+0x9e>
    panic("too big a transaction");
  if (log.outstanding < 1)
80103015:	a1 9c 27 11 80       	mov    0x8011279c,%eax
8010301a:	85 c0                	test   %eax,%eax
8010301c:	7e 7d                	jle    8010309b <log_write+0xab>
    panic("log_write outside of trans");

  acquire(&log.lock);
8010301e:	83 ec 0c             	sub    $0xc,%esp
80103021:	68 60 27 11 80       	push   $0x80112760
80103026:	e8 d5 18 00 00       	call   80104900 <acquire>
  for (i = 0; i < log.lh.n; i++) {
8010302b:	8b 15 a8 27 11 80    	mov    0x801127a8,%edx
80103031:	83 c4 10             	add    $0x10,%esp
80103034:	85 d2                	test   %edx,%edx
80103036:	7e 4a                	jle    80103082 <log_write+0x92>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103038:	8b 4b 08             	mov    0x8(%ebx),%ecx
  for (i = 0; i < log.lh.n; i++) {
8010303b:	31 c0                	xor    %eax,%eax
8010303d:	eb 08                	jmp    80103047 <log_write+0x57>
8010303f:	90                   	nop
80103040:	83 c0 01             	add    $0x1,%eax
80103043:	39 c2                	cmp    %eax,%edx
80103045:	74 29                	je     80103070 <log_write+0x80>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80103047:	39 0c 85 ac 27 11 80 	cmp    %ecx,-0x7feed854(,%eax,4)
8010304e:	75 f0                	jne    80103040 <log_write+0x50>
      break;
  }
  log.lh.block[i] = b->blockno;
80103050:	89 0c 85 ac 27 11 80 	mov    %ecx,-0x7feed854(,%eax,4)
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
80103057:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
}
8010305a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  release(&log.lock);
8010305d:	c7 45 08 60 27 11 80 	movl   $0x80112760,0x8(%ebp)
}
80103064:	c9                   	leave  
  release(&log.lock);
80103065:	e9 36 18 00 00       	jmp    801048a0 <release>
8010306a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  log.lh.block[i] = b->blockno;
80103070:	89 0c 95 ac 27 11 80 	mov    %ecx,-0x7feed854(,%edx,4)
    log.lh.n++;
80103077:	83 c2 01             	add    $0x1,%edx
8010307a:	89 15 a8 27 11 80    	mov    %edx,0x801127a8
80103080:	eb d5                	jmp    80103057 <log_write+0x67>
  log.lh.block[i] = b->blockno;
80103082:	8b 43 08             	mov    0x8(%ebx),%eax
80103085:	a3 ac 27 11 80       	mov    %eax,0x801127ac
  if (i == log.lh.n)
8010308a:	75 cb                	jne    80103057 <log_write+0x67>
8010308c:	eb e9                	jmp    80103077 <log_write+0x87>
    panic("too big a transaction");
8010308e:	83 ec 0c             	sub    $0xc,%esp
80103091:	68 d3 7b 10 80       	push   $0x80107bd3
80103096:	e8 e5 d2 ff ff       	call   80100380 <panic>
    panic("log_write outside of trans");
8010309b:	83 ec 0c             	sub    $0xc,%esp
8010309e:	68 e9 7b 10 80       	push   $0x80107be9
801030a3:	e8 d8 d2 ff ff       	call   80100380 <panic>
801030a8:	66 90                	xchg   %ax,%ax
801030aa:	66 90                	xchg   %ax,%ax
801030ac:	66 90                	xchg   %ax,%ax
801030ae:	66 90                	xchg   %ax,%ax

801030b0 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
801030b0:	55                   	push   %ebp
801030b1:	89 e5                	mov    %esp,%ebp
801030b3:	53                   	push   %ebx
801030b4:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
801030b7:	e8 84 0b 00 00       	call   80103c40 <cpuid>
801030bc:	89 c3                	mov    %eax,%ebx
801030be:	e8 7d 0b 00 00       	call   80103c40 <cpuid>
801030c3:	83 ec 04             	sub    $0x4,%esp
801030c6:	53                   	push   %ebx
801030c7:	50                   	push   %eax
801030c8:	68 04 7c 10 80       	push   $0x80107c04
801030cd:	e8 ce d5 ff ff       	call   801006a0 <cprintf>
  idtinit();       // load idt register
801030d2:	e8 89 2d 00 00       	call   80105e60 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
801030d7:	e8 04 0b 00 00       	call   80103be0 <mycpu>
801030dc:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
801030de:	b8 01 00 00 00       	mov    $0x1,%eax
801030e3:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
801030ea:	e8 61 0e 00 00       	call   80103f50 <scheduler>
801030ef:	90                   	nop

801030f0 <mpenter>:
{
801030f0:	55                   	push   %ebp
801030f1:	89 e5                	mov    %esp,%ebp
801030f3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
801030f6:	e8 55 3e 00 00       	call   80106f50 <switchkvm>
  seginit();
801030fb:	e8 c0 3d 00 00       	call   80106ec0 <seginit>
  lapicinit();
80103100:	e8 9b f7 ff ff       	call   801028a0 <lapicinit>
  mpmain();
80103105:	e8 a6 ff ff ff       	call   801030b0 <mpmain>
8010310a:	66 90                	xchg   %ax,%ax
8010310c:	66 90                	xchg   %ax,%ax
8010310e:	66 90                	xchg   %ax,%ax

80103110 <main>:
{
80103110:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80103114:	83 e4 f0             	and    $0xfffffff0,%esp
80103117:	ff 71 fc             	push   -0x4(%ecx)
8010311a:	55                   	push   %ebp
8010311b:	89 e5                	mov    %esp,%ebp
8010311d:	53                   	push   %ebx
8010311e:	51                   	push   %ecx
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
8010311f:	83 ec 08             	sub    $0x8,%esp
80103122:	68 00 00 40 80       	push   $0x80400000
80103127:	68 10 ef 11 80       	push   $0x8011ef10
8010312c:	e8 8f f5 ff ff       	call   801026c0 <kinit1>
  kvmalloc();      // kernel page table
80103131:	e8 0a 43 00 00       	call   80107440 <kvmalloc>
  mpinit();        // detect other processors
80103136:	e8 85 01 00 00       	call   801032c0 <mpinit>
  lapicinit();     // interrupt controller
8010313b:	e8 60 f7 ff ff       	call   801028a0 <lapicinit>
  seginit();       // segment descriptors
80103140:	e8 7b 3d 00 00       	call   80106ec0 <seginit>
  picinit();       // disable pic
80103145:	e8 76 03 00 00       	call   801034c0 <picinit>
  ioapicinit();    // another interrupt controller
8010314a:	e8 31 f3 ff ff       	call   80102480 <ioapicinit>
  consoleinit();   // console hardware
8010314f:	e8 0c d9 ff ff       	call   80100a60 <consoleinit>
  uartinit();      // serial port
80103154:	e8 f7 2f 00 00       	call   80106150 <uartinit>
  pinit();         // process table
80103159:	e8 62 0a 00 00       	call   80103bc0 <pinit>
  tvinit();        // trap vectors
8010315e:	e8 7d 2c 00 00       	call   80105de0 <tvinit>
  binit();         // buffer cache
80103163:	e8 d8 ce ff ff       	call   80100040 <binit>
  fileinit();      // file table
80103168:	e8 33 dd ff ff       	call   80100ea0 <fileinit>
  ideinit();       // disk 
8010316d:	e8 fe f0 ff ff       	call   80102270 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80103172:	83 c4 0c             	add    $0xc,%esp
80103175:	68 8a 00 00 00       	push   $0x8a
8010317a:	68 8c b4 10 80       	push   $0x8010b48c
8010317f:	68 00 70 00 80       	push   $0x80007000
80103184:	e8 d7 18 00 00       	call   80104a60 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80103189:	83 c4 10             	add    $0x10,%esp
8010318c:	69 05 44 28 11 80 b0 	imul   $0xb0,0x80112844,%eax
80103193:	00 00 00 
80103196:	05 60 28 11 80       	add    $0x80112860,%eax
8010319b:	3d 60 28 11 80       	cmp    $0x80112860,%eax
801031a0:	76 7e                	jbe    80103220 <main+0x110>
801031a2:	bb 60 28 11 80       	mov    $0x80112860,%ebx
801031a7:	eb 20                	jmp    801031c9 <main+0xb9>
801031a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801031b0:	69 05 44 28 11 80 b0 	imul   $0xb0,0x80112844,%eax
801031b7:	00 00 00 
801031ba:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
801031c0:	05 60 28 11 80       	add    $0x80112860,%eax
801031c5:	39 c3                	cmp    %eax,%ebx
801031c7:	73 57                	jae    80103220 <main+0x110>
    if(c == mycpu())  // We've started already.
801031c9:	e8 12 0a 00 00       	call   80103be0 <mycpu>
801031ce:	39 c3                	cmp    %eax,%ebx
801031d0:	74 de                	je     801031b0 <main+0xa0>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
801031d2:	e8 59 f5 ff ff       	call   80102730 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
801031d7:	83 ec 08             	sub    $0x8,%esp
    *(void(**)(void))(code-8) = mpenter;
801031da:	c7 05 f8 6f 00 80 f0 	movl   $0x801030f0,0x80006ff8
801031e1:	30 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
801031e4:	c7 05 f4 6f 00 80 00 	movl   $0x10a000,0x80006ff4
801031eb:	a0 10 00 
    *(void**)(code-4) = stack + KSTACKSIZE;
801031ee:	05 00 10 00 00       	add    $0x1000,%eax
801031f3:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    lapicstartap(c->apicid, V2P(code));
801031f8:	0f b6 03             	movzbl (%ebx),%eax
801031fb:	68 00 70 00 00       	push   $0x7000
80103200:	50                   	push   %eax
80103201:	e8 ea f7 ff ff       	call   801029f0 <lapicstartap>

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80103206:	83 c4 10             	add    $0x10,%esp
80103209:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103210:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80103216:	85 c0                	test   %eax,%eax
80103218:	74 f6                	je     80103210 <main+0x100>
8010321a:	eb 94                	jmp    801031b0 <main+0xa0>
8010321c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80103220:	83 ec 08             	sub    $0x8,%esp
80103223:	68 00 00 00 8e       	push   $0x8e000000
80103228:	68 00 00 40 80       	push   $0x80400000
8010322d:	e8 2e f4 ff ff       	call   80102660 <kinit2>
  userinit();      // first user process
80103232:	e8 59 0a 00 00       	call   80103c90 <userinit>
  mpmain();        // finish this processor's setup
80103237:	e8 74 fe ff ff       	call   801030b0 <mpmain>
8010323c:	66 90                	xchg   %ax,%ax
8010323e:	66 90                	xchg   %ax,%ax

80103240 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80103240:	55                   	push   %ebp
80103241:	89 e5                	mov    %esp,%ebp
80103243:	57                   	push   %edi
80103244:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80103245:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
{
8010324b:	53                   	push   %ebx
  e = addr+len;
8010324c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
{
8010324f:	83 ec 0c             	sub    $0xc,%esp
  for(p = addr; p < e; p += sizeof(struct mp))
80103252:	39 de                	cmp    %ebx,%esi
80103254:	72 10                	jb     80103266 <mpsearch1+0x26>
80103256:	eb 50                	jmp    801032a8 <mpsearch1+0x68>
80103258:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010325f:	90                   	nop
80103260:	89 fe                	mov    %edi,%esi
80103262:	39 fb                	cmp    %edi,%ebx
80103264:	76 42                	jbe    801032a8 <mpsearch1+0x68>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103266:	83 ec 04             	sub    $0x4,%esp
80103269:	8d 7e 10             	lea    0x10(%esi),%edi
8010326c:	6a 04                	push   $0x4
8010326e:	68 18 7c 10 80       	push   $0x80107c18
80103273:	56                   	push   %esi
80103274:	e8 97 17 00 00       	call   80104a10 <memcmp>
80103279:	83 c4 10             	add    $0x10,%esp
8010327c:	85 c0                	test   %eax,%eax
8010327e:	75 e0                	jne    80103260 <mpsearch1+0x20>
80103280:	89 f2                	mov    %esi,%edx
80103282:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    sum += addr[i];
80103288:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
8010328b:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
8010328e:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103290:	39 fa                	cmp    %edi,%edx
80103292:	75 f4                	jne    80103288 <mpsearch1+0x48>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80103294:	84 c0                	test   %al,%al
80103296:	75 c8                	jne    80103260 <mpsearch1+0x20>
      return (struct mp*)p;
  return 0;
}
80103298:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010329b:	89 f0                	mov    %esi,%eax
8010329d:	5b                   	pop    %ebx
8010329e:	5e                   	pop    %esi
8010329f:	5f                   	pop    %edi
801032a0:	5d                   	pop    %ebp
801032a1:	c3                   	ret    
801032a2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801032a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801032ab:	31 f6                	xor    %esi,%esi
}
801032ad:	5b                   	pop    %ebx
801032ae:	89 f0                	mov    %esi,%eax
801032b0:	5e                   	pop    %esi
801032b1:	5f                   	pop    %edi
801032b2:	5d                   	pop    %ebp
801032b3:	c3                   	ret    
801032b4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801032bb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801032bf:	90                   	nop

801032c0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
801032c0:	55                   	push   %ebp
801032c1:	89 e5                	mov    %esp,%ebp
801032c3:	57                   	push   %edi
801032c4:	56                   	push   %esi
801032c5:	53                   	push   %ebx
801032c6:	83 ec 1c             	sub    $0x1c,%esp
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
801032c9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
801032d0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
801032d7:	c1 e0 08             	shl    $0x8,%eax
801032da:	09 d0                	or     %edx,%eax
801032dc:	c1 e0 04             	shl    $0x4,%eax
801032df:	75 1b                	jne    801032fc <mpinit+0x3c>
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
801032e1:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
801032e8:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
801032ef:	c1 e0 08             	shl    $0x8,%eax
801032f2:	09 d0                	or     %edx,%eax
801032f4:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
801032f7:	2d 00 04 00 00       	sub    $0x400,%eax
    if((mp = mpsearch1(p, 1024)))
801032fc:	ba 00 04 00 00       	mov    $0x400,%edx
80103301:	e8 3a ff ff ff       	call   80103240 <mpsearch1>
80103306:	89 c3                	mov    %eax,%ebx
80103308:	85 c0                	test   %eax,%eax
8010330a:	0f 84 40 01 00 00    	je     80103450 <mpinit+0x190>
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103310:	8b 73 04             	mov    0x4(%ebx),%esi
80103313:	85 f6                	test   %esi,%esi
80103315:	0f 84 25 01 00 00    	je     80103440 <mpinit+0x180>
  if(memcmp(conf, "PCMP", 4) != 0)
8010331b:	83 ec 04             	sub    $0x4,%esp
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010331e:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103324:	6a 04                	push   $0x4
80103326:	68 1d 7c 10 80       	push   $0x80107c1d
8010332b:	50                   	push   %eax
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
8010332c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
8010332f:	e8 dc 16 00 00       	call   80104a10 <memcmp>
80103334:	83 c4 10             	add    $0x10,%esp
80103337:	85 c0                	test   %eax,%eax
80103339:	0f 85 01 01 00 00    	jne    80103440 <mpinit+0x180>
  if(conf->version != 1 && conf->version != 4)
8010333f:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
80103346:	3c 01                	cmp    $0x1,%al
80103348:	74 08                	je     80103352 <mpinit+0x92>
8010334a:	3c 04                	cmp    $0x4,%al
8010334c:	0f 85 ee 00 00 00    	jne    80103440 <mpinit+0x180>
  if(sum((uchar*)conf, conf->length) != 0)
80103352:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
  for(i=0; i<len; i++)
80103359:	66 85 d2             	test   %dx,%dx
8010335c:	74 22                	je     80103380 <mpinit+0xc0>
8010335e:	8d 3c 32             	lea    (%edx,%esi,1),%edi
80103361:	89 f0                	mov    %esi,%eax
  sum = 0;
80103363:	31 d2                	xor    %edx,%edx
80103365:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103368:	0f b6 88 00 00 00 80 	movzbl -0x80000000(%eax),%ecx
  for(i=0; i<len; i++)
8010336f:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
80103372:	01 ca                	add    %ecx,%edx
  for(i=0; i<len; i++)
80103374:	39 c7                	cmp    %eax,%edi
80103376:	75 f0                	jne    80103368 <mpinit+0xa8>
  if(sum((uchar*)conf, conf->length) != 0)
80103378:	84 d2                	test   %dl,%dl
8010337a:	0f 85 c0 00 00 00    	jne    80103440 <mpinit+0x180>
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
80103380:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
80103386:	a3 40 27 11 80       	mov    %eax,0x80112740
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010338b:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103392:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
  ismp = 1;
80103398:	be 01 00 00 00       	mov    $0x1,%esi
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010339d:	03 55 e4             	add    -0x1c(%ebp),%edx
801033a0:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
801033a3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801033a7:	90                   	nop
801033a8:	39 d0                	cmp    %edx,%eax
801033aa:	73 15                	jae    801033c1 <mpinit+0x101>
    switch(*p){
801033ac:	0f b6 08             	movzbl (%eax),%ecx
801033af:	80 f9 02             	cmp    $0x2,%cl
801033b2:	74 4c                	je     80103400 <mpinit+0x140>
801033b4:	77 3a                	ja     801033f0 <mpinit+0x130>
801033b6:	84 c9                	test   %cl,%cl
801033b8:	74 56                	je     80103410 <mpinit+0x150>
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801033ba:	83 c0 08             	add    $0x8,%eax
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801033bd:	39 d0                	cmp    %edx,%eax
801033bf:	72 eb                	jb     801033ac <mpinit+0xec>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801033c1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801033c4:	85 f6                	test   %esi,%esi
801033c6:	0f 84 d9 00 00 00    	je     801034a5 <mpinit+0x1e5>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801033cc:	80 7b 0c 00          	cmpb   $0x0,0xc(%ebx)
801033d0:	74 15                	je     801033e7 <mpinit+0x127>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033d2:	b8 70 00 00 00       	mov    $0x70,%eax
801033d7:	ba 22 00 00 00       	mov    $0x22,%edx
801033dc:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801033dd:	ba 23 00 00 00       	mov    $0x23,%edx
801033e2:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801033e3:	83 c8 01             	or     $0x1,%eax
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801033e6:	ee                   	out    %al,(%dx)
  }
}
801033e7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801033ea:	5b                   	pop    %ebx
801033eb:	5e                   	pop    %esi
801033ec:	5f                   	pop    %edi
801033ed:	5d                   	pop    %ebp
801033ee:	c3                   	ret    
801033ef:	90                   	nop
    switch(*p){
801033f0:	83 e9 03             	sub    $0x3,%ecx
801033f3:	80 f9 01             	cmp    $0x1,%cl
801033f6:	76 c2                	jbe    801033ba <mpinit+0xfa>
801033f8:	31 f6                	xor    %esi,%esi
801033fa:	eb ac                	jmp    801033a8 <mpinit+0xe8>
801033fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      ioapicid = ioapic->apicno;
80103400:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103404:	83 c0 08             	add    $0x8,%eax
      ioapicid = ioapic->apicno;
80103407:	88 0d 40 28 11 80    	mov    %cl,0x80112840
      continue;
8010340d:	eb 99                	jmp    801033a8 <mpinit+0xe8>
8010340f:	90                   	nop
      if(ncpu < NCPU) {
80103410:	8b 0d 44 28 11 80    	mov    0x80112844,%ecx
80103416:	83 f9 07             	cmp    $0x7,%ecx
80103419:	7f 19                	jg     80103434 <mpinit+0x174>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010341b:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
80103421:	0f b6 58 01          	movzbl 0x1(%eax),%ebx
        ncpu++;
80103425:	83 c1 01             	add    $0x1,%ecx
80103428:	89 0d 44 28 11 80    	mov    %ecx,0x80112844
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
8010342e:	88 9f 60 28 11 80    	mov    %bl,-0x7feed7a0(%edi)
      p += sizeof(struct mpproc);
80103434:	83 c0 14             	add    $0x14,%eax
      continue;
80103437:	e9 6c ff ff ff       	jmp    801033a8 <mpinit+0xe8>
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    panic("Expect to run on an SMP");
80103440:	83 ec 0c             	sub    $0xc,%esp
80103443:	68 22 7c 10 80       	push   $0x80107c22
80103448:	e8 33 cf ff ff       	call   80100380 <panic>
8010344d:	8d 76 00             	lea    0x0(%esi),%esi
{
80103450:	bb 00 00 0f 80       	mov    $0x800f0000,%ebx
80103455:	eb 13                	jmp    8010346a <mpinit+0x1aa>
80103457:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010345e:	66 90                	xchg   %ax,%ax
  for(p = addr; p < e; p += sizeof(struct mp))
80103460:	89 f3                	mov    %esi,%ebx
80103462:	81 fe 00 00 10 80    	cmp    $0x80100000,%esi
80103468:	74 d6                	je     80103440 <mpinit+0x180>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010346a:	83 ec 04             	sub    $0x4,%esp
8010346d:	8d 73 10             	lea    0x10(%ebx),%esi
80103470:	6a 04                	push   $0x4
80103472:	68 18 7c 10 80       	push   $0x80107c18
80103477:	53                   	push   %ebx
80103478:	e8 93 15 00 00       	call   80104a10 <memcmp>
8010347d:	83 c4 10             	add    $0x10,%esp
80103480:	85 c0                	test   %eax,%eax
80103482:	75 dc                	jne    80103460 <mpinit+0x1a0>
80103484:	89 da                	mov    %ebx,%edx
80103486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010348d:	8d 76 00             	lea    0x0(%esi),%esi
    sum += addr[i];
80103490:	0f b6 0a             	movzbl (%edx),%ecx
  for(i=0; i<len; i++)
80103493:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103496:	01 c8                	add    %ecx,%eax
  for(i=0; i<len; i++)
80103498:	39 d6                	cmp    %edx,%esi
8010349a:	75 f4                	jne    80103490 <mpinit+0x1d0>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
8010349c:	84 c0                	test   %al,%al
8010349e:	75 c0                	jne    80103460 <mpinit+0x1a0>
801034a0:	e9 6b fe ff ff       	jmp    80103310 <mpinit+0x50>
    panic("Didn't find a suitable machine");
801034a5:	83 ec 0c             	sub    $0xc,%esp
801034a8:	68 3c 7c 10 80       	push   $0x80107c3c
801034ad:	e8 ce ce ff ff       	call   80100380 <panic>
801034b2:	66 90                	xchg   %ax,%ax
801034b4:	66 90                	xchg   %ax,%ax
801034b6:	66 90                	xchg   %ax,%ax
801034b8:	66 90                	xchg   %ax,%ax
801034ba:	66 90                	xchg   %ax,%ax
801034bc:	66 90                	xchg   %ax,%ax
801034be:	66 90                	xchg   %ax,%ax

801034c0 <picinit>:
801034c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801034c5:	ba 21 00 00 00       	mov    $0x21,%edx
801034ca:	ee                   	out    %al,(%dx)
801034cb:	ba a1 00 00 00       	mov    $0xa1,%edx
801034d0:	ee                   	out    %al,(%dx)
picinit(void)
{
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801034d1:	c3                   	ret    
801034d2:	66 90                	xchg   %ax,%ax
801034d4:	66 90                	xchg   %ax,%ax
801034d6:	66 90                	xchg   %ax,%ax
801034d8:	66 90                	xchg   %ax,%ax
801034da:	66 90                	xchg   %ax,%ax
801034dc:	66 90                	xchg   %ax,%ax
801034de:	66 90                	xchg   %ax,%ax

801034e0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801034e0:	55                   	push   %ebp
801034e1:	89 e5                	mov    %esp,%ebp
801034e3:	57                   	push   %edi
801034e4:	56                   	push   %esi
801034e5:	53                   	push   %ebx
801034e6:	83 ec 0c             	sub    $0xc,%esp
801034e9:	8b 5d 08             	mov    0x8(%ebp),%ebx
801034ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801034ef:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
801034f5:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
801034fb:	e8 c0 d9 ff ff       	call   80100ec0 <filealloc>
80103500:	89 03                	mov    %eax,(%ebx)
80103502:	85 c0                	test   %eax,%eax
80103504:	0f 84 a8 00 00 00    	je     801035b2 <pipealloc+0xd2>
8010350a:	e8 b1 d9 ff ff       	call   80100ec0 <filealloc>
8010350f:	89 06                	mov    %eax,(%esi)
80103511:	85 c0                	test   %eax,%eax
80103513:	0f 84 87 00 00 00    	je     801035a0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103519:	e8 12 f2 ff ff       	call   80102730 <kalloc>
8010351e:	89 c7                	mov    %eax,%edi
80103520:	85 c0                	test   %eax,%eax
80103522:	0f 84 b0 00 00 00    	je     801035d8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
80103528:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
8010352f:	00 00 00 
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103532:	83 ec 08             	sub    $0x8,%esp
  p->writeopen = 1;
80103535:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010353c:	00 00 00 
  p->nwrite = 0;
8010353f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103546:	00 00 00 
  p->nread = 0;
80103549:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103550:	00 00 00 
  initlock(&p->lock, "pipe");
80103553:	68 5b 7c 10 80       	push   $0x80107c5b
80103558:	50                   	push   %eax
80103559:	e8 d2 11 00 00       	call   80104730 <initlock>
  (*f0)->type = FD_PIPE;
8010355e:	8b 03                	mov    (%ebx),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103560:	83 c4 10             	add    $0x10,%esp
  (*f0)->type = FD_PIPE;
80103563:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103569:	8b 03                	mov    (%ebx),%eax
8010356b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010356f:	8b 03                	mov    (%ebx),%eax
80103571:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103575:	8b 03                	mov    (%ebx),%eax
80103577:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010357a:	8b 06                	mov    (%esi),%eax
8010357c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103582:	8b 06                	mov    (%esi),%eax
80103584:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103588:	8b 06                	mov    (%esi),%eax
8010358a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010358e:	8b 06                	mov    (%esi),%eax
80103590:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103593:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80103596:	31 c0                	xor    %eax,%eax
}
80103598:	5b                   	pop    %ebx
80103599:	5e                   	pop    %esi
8010359a:	5f                   	pop    %edi
8010359b:	5d                   	pop    %ebp
8010359c:	c3                   	ret    
8010359d:	8d 76 00             	lea    0x0(%esi),%esi
  if(*f0)
801035a0:	8b 03                	mov    (%ebx),%eax
801035a2:	85 c0                	test   %eax,%eax
801035a4:	74 1e                	je     801035c4 <pipealloc+0xe4>
    fileclose(*f0);
801035a6:	83 ec 0c             	sub    $0xc,%esp
801035a9:	50                   	push   %eax
801035aa:	e8 d1 d9 ff ff       	call   80100f80 <fileclose>
801035af:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801035b2:	8b 06                	mov    (%esi),%eax
801035b4:	85 c0                	test   %eax,%eax
801035b6:	74 0c                	je     801035c4 <pipealloc+0xe4>
    fileclose(*f1);
801035b8:	83 ec 0c             	sub    $0xc,%esp
801035bb:	50                   	push   %eax
801035bc:	e8 bf d9 ff ff       	call   80100f80 <fileclose>
801035c1:	83 c4 10             	add    $0x10,%esp
}
801035c4:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return -1;
801035c7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801035cc:	5b                   	pop    %ebx
801035cd:	5e                   	pop    %esi
801035ce:	5f                   	pop    %edi
801035cf:	5d                   	pop    %ebp
801035d0:	c3                   	ret    
801035d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(*f0)
801035d8:	8b 03                	mov    (%ebx),%eax
801035da:	85 c0                	test   %eax,%eax
801035dc:	75 c8                	jne    801035a6 <pipealloc+0xc6>
801035de:	eb d2                	jmp    801035b2 <pipealloc+0xd2>

801035e0 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
801035e0:	55                   	push   %ebp
801035e1:	89 e5                	mov    %esp,%ebp
801035e3:	56                   	push   %esi
801035e4:	53                   	push   %ebx
801035e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801035e8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801035eb:	83 ec 0c             	sub    $0xc,%esp
801035ee:	53                   	push   %ebx
801035ef:	e8 0c 13 00 00       	call   80104900 <acquire>
  if(writable){
801035f4:	83 c4 10             	add    $0x10,%esp
801035f7:	85 f6                	test   %esi,%esi
801035f9:	74 65                	je     80103660 <pipeclose+0x80>
    p->writeopen = 0;
    wakeup(&p->nread);
801035fb:	83 ec 0c             	sub    $0xc,%esp
801035fe:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
    p->writeopen = 0;
80103604:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010360b:	00 00 00 
    wakeup(&p->nread);
8010360e:	50                   	push   %eax
8010360f:	e8 4c 0e 00 00       	call   80104460 <wakeup>
80103614:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103617:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010361d:	85 d2                	test   %edx,%edx
8010361f:	75 0a                	jne    8010362b <pipeclose+0x4b>
80103621:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103627:	85 c0                	test   %eax,%eax
80103629:	74 15                	je     80103640 <pipeclose+0x60>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010362b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010362e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103631:	5b                   	pop    %ebx
80103632:	5e                   	pop    %esi
80103633:	5d                   	pop    %ebp
    release(&p->lock);
80103634:	e9 67 12 00 00       	jmp    801048a0 <release>
80103639:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    release(&p->lock);
80103640:	83 ec 0c             	sub    $0xc,%esp
80103643:	53                   	push   %ebx
80103644:	e8 57 12 00 00       	call   801048a0 <release>
    kfree((char*)p);
80103649:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010364c:	83 c4 10             	add    $0x10,%esp
}
8010364f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103652:	5b                   	pop    %ebx
80103653:	5e                   	pop    %esi
80103654:	5d                   	pop    %ebp
    kfree((char*)p);
80103655:	e9 16 ef ff ff       	jmp    80102570 <kfree>
8010365a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    wakeup(&p->nwrite);
80103660:	83 ec 0c             	sub    $0xc,%esp
80103663:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
    p->readopen = 0;
80103669:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103670:	00 00 00 
    wakeup(&p->nwrite);
80103673:	50                   	push   %eax
80103674:	e8 e7 0d 00 00       	call   80104460 <wakeup>
80103679:	83 c4 10             	add    $0x10,%esp
8010367c:	eb 99                	jmp    80103617 <pipeclose+0x37>
8010367e:	66 90                	xchg   %ax,%ax

80103680 <pipewrite>:

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103680:	55                   	push   %ebp
80103681:	89 e5                	mov    %esp,%ebp
80103683:	57                   	push   %edi
80103684:	56                   	push   %esi
80103685:	53                   	push   %ebx
80103686:	83 ec 28             	sub    $0x28,%esp
80103689:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010368c:	53                   	push   %ebx
8010368d:	e8 6e 12 00 00       	call   80104900 <acquire>
  for(i = 0; i < n; i++){
80103692:	8b 45 10             	mov    0x10(%ebp),%eax
80103695:	83 c4 10             	add    $0x10,%esp
80103698:	85 c0                	test   %eax,%eax
8010369a:	0f 8e c0 00 00 00    	jle    80103760 <pipewrite+0xe0>
801036a0:	8b 45 0c             	mov    0xc(%ebp),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036a3:	8b 8b 38 02 00 00    	mov    0x238(%ebx),%ecx
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801036a9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
801036af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801036b2:	03 45 10             	add    0x10(%ebp),%eax
801036b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036b8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036be:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036c4:	89 ca                	mov    %ecx,%edx
801036c6:	05 00 02 00 00       	add    $0x200,%eax
801036cb:	39 c1                	cmp    %eax,%ecx
801036cd:	74 3f                	je     8010370e <pipewrite+0x8e>
801036cf:	eb 67                	jmp    80103738 <pipewrite+0xb8>
801036d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      if(p->readopen == 0 || myproc()->killed){
801036d8:	e8 83 05 00 00       	call   80103c60 <myproc>
801036dd:	8b 48 24             	mov    0x24(%eax),%ecx
801036e0:	85 c9                	test   %ecx,%ecx
801036e2:	75 34                	jne    80103718 <pipewrite+0x98>
      wakeup(&p->nread);
801036e4:	83 ec 0c             	sub    $0xc,%esp
801036e7:	57                   	push   %edi
801036e8:	e8 73 0d 00 00       	call   80104460 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801036ed:	58                   	pop    %eax
801036ee:	5a                   	pop    %edx
801036ef:	53                   	push   %ebx
801036f0:	56                   	push   %esi
801036f1:	e8 aa 0c 00 00       	call   801043a0 <sleep>
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801036f6:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801036fc:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
80103702:	83 c4 10             	add    $0x10,%esp
80103705:	05 00 02 00 00       	add    $0x200,%eax
8010370a:	39 c2                	cmp    %eax,%edx
8010370c:	75 2a                	jne    80103738 <pipewrite+0xb8>
      if(p->readopen == 0 || myproc()->killed){
8010370e:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
80103714:	85 c0                	test   %eax,%eax
80103716:	75 c0                	jne    801036d8 <pipewrite+0x58>
        release(&p->lock);
80103718:	83 ec 0c             	sub    $0xc,%esp
8010371b:	53                   	push   %ebx
8010371c:	e8 7f 11 00 00       	call   801048a0 <release>
        return -1;
80103721:	83 c4 10             	add    $0x10,%esp
80103724:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103729:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010372c:	5b                   	pop    %ebx
8010372d:	5e                   	pop    %esi
8010372e:	5f                   	pop    %edi
8010372f:	5d                   	pop    %ebp
80103730:	c3                   	ret    
80103731:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103738:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010373b:	8d 4a 01             	lea    0x1(%edx),%ecx
8010373e:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103744:	89 8b 38 02 00 00    	mov    %ecx,0x238(%ebx)
8010374a:	0f b6 06             	movzbl (%esi),%eax
  for(i = 0; i < n; i++){
8010374d:	83 c6 01             	add    $0x1,%esi
80103750:	89 75 e4             	mov    %esi,-0x1c(%ebp)
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103753:	88 44 13 34          	mov    %al,0x34(%ebx,%edx,1)
  for(i = 0; i < n; i++){
80103757:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010375a:	0f 85 58 ff ff ff    	jne    801036b8 <pipewrite+0x38>
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103760:	83 ec 0c             	sub    $0xc,%esp
80103763:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103769:	50                   	push   %eax
8010376a:	e8 f1 0c 00 00       	call   80104460 <wakeup>
  release(&p->lock);
8010376f:	89 1c 24             	mov    %ebx,(%esp)
80103772:	e8 29 11 00 00       	call   801048a0 <release>
  return n;
80103777:	8b 45 10             	mov    0x10(%ebp),%eax
8010377a:	83 c4 10             	add    $0x10,%esp
8010377d:	eb aa                	jmp    80103729 <pipewrite+0xa9>
8010377f:	90                   	nop

80103780 <piperead>:

int
piperead(struct pipe *p, char *addr, int n)
{
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	57                   	push   %edi
80103784:	56                   	push   %esi
80103785:	53                   	push   %ebx
80103786:	83 ec 18             	sub    $0x18,%esp
80103789:	8b 75 08             	mov    0x8(%ebp),%esi
8010378c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010378f:	56                   	push   %esi
80103790:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103796:	e8 65 11 00 00       	call   80104900 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
8010379b:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801037a1:	83 c4 10             	add    $0x10,%esp
801037a4:	39 86 38 02 00 00    	cmp    %eax,0x238(%esi)
801037aa:	74 2f                	je     801037db <piperead+0x5b>
801037ac:	eb 37                	jmp    801037e5 <piperead+0x65>
801037ae:	66 90                	xchg   %ax,%ax
    if(myproc()->killed){
801037b0:	e8 ab 04 00 00       	call   80103c60 <myproc>
801037b5:	8b 48 24             	mov    0x24(%eax),%ecx
801037b8:	85 c9                	test   %ecx,%ecx
801037ba:	0f 85 80 00 00 00    	jne    80103840 <piperead+0xc0>
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801037c0:	83 ec 08             	sub    $0x8,%esp
801037c3:	56                   	push   %esi
801037c4:	53                   	push   %ebx
801037c5:	e8 d6 0b 00 00       	call   801043a0 <sleep>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801037ca:	8b 86 38 02 00 00    	mov    0x238(%esi),%eax
801037d0:	83 c4 10             	add    $0x10,%esp
801037d3:	39 86 34 02 00 00    	cmp    %eax,0x234(%esi)
801037d9:	75 0a                	jne    801037e5 <piperead+0x65>
801037db:	8b 86 40 02 00 00    	mov    0x240(%esi),%eax
801037e1:	85 c0                	test   %eax,%eax
801037e3:	75 cb                	jne    801037b0 <piperead+0x30>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
801037e5:	8b 55 10             	mov    0x10(%ebp),%edx
801037e8:	31 db                	xor    %ebx,%ebx
801037ea:	85 d2                	test   %edx,%edx
801037ec:	7f 20                	jg     8010380e <piperead+0x8e>
801037ee:	eb 2c                	jmp    8010381c <piperead+0x9c>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
801037f0:	8d 48 01             	lea    0x1(%eax),%ecx
801037f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801037f8:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
801037fe:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103803:	88 04 1f             	mov    %al,(%edi,%ebx,1)
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103806:	83 c3 01             	add    $0x1,%ebx
80103809:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010380c:	74 0e                	je     8010381c <piperead+0x9c>
    if(p->nread == p->nwrite)
8010380e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
80103814:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
8010381a:	75 d4                	jne    801037f0 <piperead+0x70>
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
8010381c:	83 ec 0c             	sub    $0xc,%esp
8010381f:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
80103825:	50                   	push   %eax
80103826:	e8 35 0c 00 00       	call   80104460 <wakeup>
  release(&p->lock);
8010382b:	89 34 24             	mov    %esi,(%esp)
8010382e:	e8 6d 10 00 00       	call   801048a0 <release>
  return i;
80103833:	83 c4 10             	add    $0x10,%esp
}
80103836:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103839:	89 d8                	mov    %ebx,%eax
8010383b:	5b                   	pop    %ebx
8010383c:	5e                   	pop    %esi
8010383d:	5f                   	pop    %edi
8010383e:	5d                   	pop    %ebp
8010383f:	c3                   	ret    
      release(&p->lock);
80103840:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80103843:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
      release(&p->lock);
80103848:	56                   	push   %esi
80103849:	e8 52 10 00 00       	call   801048a0 <release>
      return -1;
8010384e:	83 c4 10             	add    $0x10,%esp
}
80103851:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103854:	89 d8                	mov    %ebx,%eax
80103856:	5b                   	pop    %ebx
80103857:	5e                   	pop    %esi
80103858:	5f                   	pop    %edi
80103859:	5d                   	pop    %ebp
8010385a:	c3                   	ret    
8010385b:	66 90                	xchg   %ax,%ax
8010385d:	66 90                	xchg   %ax,%ax
8010385f:	90                   	nop

80103860 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103864:	bb 94 37 11 80       	mov    $0x80113794,%ebx
{
80103869:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);
8010386c:	68 60 37 11 80       	push   $0x80113760
80103871:	e8 8a 10 00 00       	call   80104900 <acquire>
80103876:	83 c4 10             	add    $0x10,%esp
80103879:	eb 17                	jmp    80103892 <allocproc+0x32>
8010387b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010387f:	90                   	nop
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103880:	81 c3 7c 02 00 00    	add    $0x27c,%ebx
80103886:	81 fb 94 d6 11 80    	cmp    $0x8011d694,%ebx
8010388c:	0f 84 9e 00 00 00    	je     80103930 <allocproc+0xd0>
    if(p->state == UNUSED)
80103892:	8b 43 0c             	mov    0xc(%ebx),%eax
80103895:	85 c0                	test   %eax,%eax
80103897:	75 e7                	jne    80103880 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103899:	a1 04 b0 10 80       	mov    0x8010b004,%eax
  memset(p->blocked_syscalls, 0, sizeof(p->blocked_syscalls));
8010389e:	83 ec 04             	sub    $0x4,%esp
  p->state = EMBRYO;
801038a1:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
801038a8:	8d 50 01             	lea    0x1(%eax),%edx
801038ab:	89 43 10             	mov    %eax,0x10(%ebx)
  memset(p->blocked_syscalls, 0, sizeof(p->blocked_syscalls));
801038ae:	8d 83 7c 01 00 00    	lea    0x17c(%ebx),%eax
801038b4:	68 00 01 00 00       	push   $0x100
801038b9:	6a 00                	push   $0x0
801038bb:	50                   	push   %eax
  p->pid = nextpid++;
801038bc:	89 15 04 b0 10 80    	mov    %edx,0x8010b004
  memset(p->blocked_syscalls, 0, sizeof(p->blocked_syscalls));
801038c2:	e8 f9 10 00 00       	call   801049c0 <memset>
  memset(p->pass_syscalls, 0, sizeof(p->pass_syscalls));
801038c7:	83 c4 0c             	add    $0xc,%esp
801038ca:	8d 43 7c             	lea    0x7c(%ebx),%eax
801038cd:	68 00 01 00 00       	push   $0x100
801038d2:	6a 00                	push   $0x0
801038d4:	50                   	push   %eax
801038d5:	e8 e6 10 00 00       	call   801049c0 <memset>
  release(&ptable.lock);
801038da:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
801038e1:	e8 ba 0f 00 00       	call   801048a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
801038e6:	e8 45 ee ff ff       	call   80102730 <kalloc>
801038eb:	83 c4 10             	add    $0x10,%esp
801038ee:	89 43 08             	mov    %eax,0x8(%ebx)
801038f1:	85 c0                	test   %eax,%eax
801038f3:	74 54                	je     80103949 <allocproc+0xe9>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
801038f5:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
801038fb:	83 ec 04             	sub    $0x4,%esp
  sp -= sizeof *p->context;
801038fe:	05 9c 0f 00 00       	add    $0xf9c,%eax
  sp -= sizeof *p->tf;
80103903:	89 53 18             	mov    %edx,0x18(%ebx)
  *(uint*)sp = (uint)trapret;
80103906:	c7 40 14 cf 5d 10 80 	movl   $0x80105dcf,0x14(%eax)
  p->context = (struct context*)sp;
8010390d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103910:	6a 14                	push   $0x14
80103912:	6a 00                	push   $0x0
80103914:	50                   	push   %eax
80103915:	e8 a6 10 00 00       	call   801049c0 <memset>
  p->context->eip = (uint)forkret;
8010391a:	8b 43 1c             	mov    0x1c(%ebx),%eax

  return p;
8010391d:	83 c4 10             	add    $0x10,%esp
  p->context->eip = (uint)forkret;
80103920:	c7 40 10 60 39 10 80 	movl   $0x80103960,0x10(%eax)
}
80103927:	89 d8                	mov    %ebx,%eax
80103929:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010392c:	c9                   	leave  
8010392d:	c3                   	ret    
8010392e:	66 90                	xchg   %ax,%ax
  release(&ptable.lock);
80103930:	83 ec 0c             	sub    $0xc,%esp
  return 0;
80103933:	31 db                	xor    %ebx,%ebx
  release(&ptable.lock);
80103935:	68 60 37 11 80       	push   $0x80113760
8010393a:	e8 61 0f 00 00       	call   801048a0 <release>
}
8010393f:	89 d8                	mov    %ebx,%eax
  return 0;
80103941:	83 c4 10             	add    $0x10,%esp
}
80103944:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103947:	c9                   	leave  
80103948:	c3                   	ret    
    p->state = UNUSED;
80103949:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103950:	31 db                	xor    %ebx,%ebx
}
80103952:	89 d8                	mov    %ebx,%eax
80103954:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103957:	c9                   	leave  
80103958:	c3                   	ret    
80103959:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103960 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103960:	55                   	push   %ebp
80103961:	89 e5                	mov    %esp,%ebp
80103963:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103966:	68 60 37 11 80       	push   $0x80113760
8010396b:	e8 30 0f 00 00       	call   801048a0 <release>

  if (first) {
80103970:	a1 00 b0 10 80       	mov    0x8010b000,%eax
80103975:	83 c4 10             	add    $0x10,%esp
80103978:	85 c0                	test   %eax,%eax
8010397a:	75 04                	jne    80103980 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
8010397c:	c9                   	leave  
8010397d:	c3                   	ret    
8010397e:	66 90                	xchg   %ax,%ax
    first = 0;
80103980:	c7 05 00 b0 10 80 00 	movl   $0x0,0x8010b000
80103987:	00 00 00 
    iinit(ROOTDEV);
8010398a:	83 ec 0c             	sub    $0xc,%esp
8010398d:	6a 01                	push   $0x1
8010398f:	e8 5c dc ff ff       	call   801015f0 <iinit>
    initlog(ROOTDEV);
80103994:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010399b:	e8 d0 f3 ff ff       	call   80102d70 <initlog>
}
801039a0:	83 c4 10             	add    $0x10,%esp
801039a3:	c9                   	leave  
801039a4:	c3                   	ret    
801039a5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801039ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801039b0 <strcmp>:
{
801039b0:	55                   	push   %ebp
801039b1:	89 e5                	mov    %esp,%ebp
801039b3:	53                   	push   %ebx
801039b4:	8b 4d 08             	mov    0x8(%ebp),%ecx
801039b7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while (*s1 && *s2 && *s1 == *s2) {
801039ba:	0f b6 01             	movzbl (%ecx),%eax
801039bd:	84 c0                	test   %al,%al
801039bf:	75 1b                	jne    801039dc <strcmp+0x2c>
801039c1:	eb 3a                	jmp    801039fd <strcmp+0x4d>
801039c3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801039c7:	90                   	nop
801039c8:	84 d2                	test   %dl,%dl
801039ca:	74 17                	je     801039e3 <strcmp+0x33>
801039cc:	0f b6 41 01          	movzbl 0x1(%ecx),%eax
    s1++;
801039d0:	83 c1 01             	add    $0x1,%ecx
    s2++;
801039d3:	8d 53 01             	lea    0x1(%ebx),%edx
  while (*s1 && *s2 && *s1 == *s2) {
801039d6:	84 c0                	test   %al,%al
801039d8:	74 16                	je     801039f0 <strcmp+0x40>
    s2++;
801039da:	89 d3                	mov    %edx,%ebx
  while (*s1 && *s2 && *s1 == *s2) {
801039dc:	0f b6 13             	movzbl (%ebx),%edx
801039df:	38 c2                	cmp    %al,%dl
801039e1:	74 e5                	je     801039c8 <strcmp+0x18>
}
801039e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return (unsigned char)*s1 - (unsigned char)*s2;
801039e6:	29 d0                	sub    %edx,%eax
}
801039e8:	c9                   	leave  
801039e9:	c3                   	ret    
801039ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return (unsigned char)*s1 - (unsigned char)*s2;
801039f0:	0f b6 53 01          	movzbl 0x1(%ebx),%edx
801039f4:	31 c0                	xor    %eax,%eax
}
801039f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801039f9:	c9                   	leave  
  return (unsigned char)*s1 - (unsigned char)*s2;
801039fa:	29 d0                	sub    %edx,%eax
}
801039fc:	c3                   	ret    
  return (unsigned char)*s1 - (unsigned char)*s2;
801039fd:	0f b6 13             	movzbl (%ebx),%edx
80103a00:	31 c0                	xor    %eax,%eax
80103a02:	eb df                	jmp    801039e3 <strcmp+0x33>
80103a04:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a0f:	90                   	nop

80103a10 <add_to_history>:
  if (history_count < MAX_HISTORY) {
80103a10:	a1 e0 2d 11 80       	mov    0x80112de0,%eax
80103a15:	83 f8 63             	cmp    $0x63,%eax
80103a18:	7e 06                	jle    80103a20 <add_to_history+0x10>
80103a1a:	c3                   	ret    
80103a1b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a1f:	90                   	nop
{
80103a20:	55                   	push   %ebp
    history[history_count].pid = pid;
80103a21:	8d 04 40             	lea    (%eax,%eax,2),%eax
80103a24:	c1 e0 03             	shl    $0x3,%eax
{
80103a27:	89 e5                	mov    %esp,%ebp
80103a29:	83 ec 0c             	sub    $0xc,%esp
    history[history_count].pid = pid;
80103a2c:	8b 55 08             	mov    0x8(%ebp),%edx
    safestrcpy(history[history_count].name, name, sizeof(history[history_count].name));
80103a2f:	6a 10                	push   $0x10
80103a31:	ff 75 0c             	push   0xc(%ebp)
    history[history_count].pid = pid;
80103a34:	89 90 00 2e 11 80    	mov    %edx,-0x7feed200(%eax)
    safestrcpy(history[history_count].name, name, sizeof(history[history_count].name));
80103a3a:	05 04 2e 11 80       	add    $0x80112e04,%eax
80103a3f:	50                   	push   %eax
80103a40:	e8 3b 11 00 00       	call   80104b80 <safestrcpy>
    history[history_count].memory_utilization = memory_utilization;
80103a45:	a1 e0 2d 11 80       	mov    0x80112de0,%eax
80103a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
    history_count++;
80103a4d:	83 c4 10             	add    $0x10,%esp
    history[history_count].memory_utilization = memory_utilization;
80103a50:	8d 14 40             	lea    (%eax,%eax,2),%edx
    history_count++;
80103a53:	83 c0 01             	add    $0x1,%eax
    history[history_count].memory_utilization = memory_utilization;
80103a56:	89 0c d5 14 2e 11 80 	mov    %ecx,-0x7feed1ec(,%edx,8)
    history_count++;
80103a5d:	a3 e0 2d 11 80       	mov    %eax,0x80112de0
}
80103a62:	c9                   	leave  
80103a63:	c3                   	ret    
80103a64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103a6f:	90                   	nop

80103a70 <gethistory>:
{
80103a70:	55                   	push   %ebp
80103a71:	89 e5                	mov    %esp,%ebp
80103a73:	57                   	push   %edi
80103a74:	56                   	push   %esi
80103a75:	53                   	push   %ebx
80103a76:	83 ec 58             	sub    $0x58,%esp
  acquire(&ptable.lock);
80103a79:	68 60 37 11 80       	push   $0x80113760
80103a7e:	e8 7d 0e 00 00       	call   80104900 <acquire>
  if (history_count == 0) {
80103a83:	8b 15 e0 2d 11 80    	mov    0x80112de0,%edx
80103a89:	83 c4 10             	add    $0x10,%esp
80103a8c:	89 55 b4             	mov    %edx,-0x4c(%ebp)
80103a8f:	85 d2                	test   %edx,%edx
80103a91:	0f 84 e5 00 00 00    	je     80103b7c <gethistory+0x10c>
  for (int i = 0; i < history_count - 1; i++) {
80103a97:	8d 42 ff             	lea    -0x1(%edx),%eax
80103a9a:	85 c0                	test   %eax,%eax
80103a9c:	0f 8e 8b 00 00 00    	jle    80103b2d <gethistory+0xbd>
80103aa2:	89 45 b8             	mov    %eax,-0x48(%ebp)
80103aa5:	8d 04 52             	lea    (%edx,%edx,2),%eax
80103aa8:	8d 0c c5 e8 2d 11 80 	lea    -0x7feed218(,%eax,8),%ecx
80103aaf:	89 ca                	mov    %ecx,%edx
80103ab1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
80103ab8:	b9 00 2e 11 80       	mov    $0x80112e00,%ecx
80103abd:	8d 76 00             	lea    0x0(%esi),%esi
      if (history[j].pid > history[j + 1].pid) {
80103ac0:	8b 01                	mov    (%ecx),%eax
80103ac2:	3b 41 18             	cmp    0x18(%ecx),%eax
80103ac5:	7e 56                	jle    80103b1d <gethistory+0xad>
        history[j] = history[j + 1];
80103ac7:	8b 79 18             	mov    0x18(%ecx),%edi
        struct proc_history temp = history[j];
80103aca:	8b 71 04             	mov    0x4(%ecx),%esi
        history[j + 1] = temp;
80103acd:	89 41 18             	mov    %eax,0x18(%ecx)
        struct proc_history temp = history[j];
80103ad0:	8b 59 0c             	mov    0xc(%ecx),%ebx
        history[j] = history[j + 1];
80103ad3:	89 39                	mov    %edi,(%ecx)
80103ad5:	8b 79 1c             	mov    0x1c(%ecx),%edi
        struct proc_history temp = history[j];
80103ad8:	89 75 c4             	mov    %esi,-0x3c(%ebp)
80103adb:	8b 71 08             	mov    0x8(%ecx),%esi
        history[j] = history[j + 1];
80103ade:	89 79 04             	mov    %edi,0x4(%ecx)
80103ae1:	8b 79 20             	mov    0x20(%ecx),%edi
        history[j + 1] = temp;
80103ae4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
        struct proc_history temp = history[j];
80103ae7:	89 75 c0             	mov    %esi,-0x40(%ebp)
        history[j] = history[j + 1];
80103aea:	89 79 08             	mov    %edi,0x8(%ecx)
80103aed:	8b 79 24             	mov    0x24(%ecx),%edi
        history[j + 1] = temp;
80103af0:	89 41 1c             	mov    %eax,0x1c(%ecx)
80103af3:	8b 45 c0             	mov    -0x40(%ebp),%eax
        history[j] = history[j + 1];
80103af6:	89 79 0c             	mov    %edi,0xc(%ecx)
80103af9:	8b 79 28             	mov    0x28(%ecx),%edi
        struct proc_history temp = history[j];
80103afc:	89 5d bc             	mov    %ebx,-0x44(%ebp)
80103aff:	8b 71 10             	mov    0x10(%ecx),%esi
80103b02:	8b 59 14             	mov    0x14(%ecx),%ebx
        history[j] = history[j + 1];
80103b05:	89 79 10             	mov    %edi,0x10(%ecx)
        history[j + 1] = temp;
80103b08:	89 41 20             	mov    %eax,0x20(%ecx)
        history[j] = history[j + 1];
80103b0b:	8b 79 2c             	mov    0x2c(%ecx),%edi
        history[j + 1] = temp;
80103b0e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80103b11:	89 71 28             	mov    %esi,0x28(%ecx)
        history[j] = history[j + 1];
80103b14:	89 79 14             	mov    %edi,0x14(%ecx)
        history[j + 1] = temp;
80103b17:	89 41 24             	mov    %eax,0x24(%ecx)
80103b1a:	89 59 2c             	mov    %ebx,0x2c(%ecx)
    for (int j = 0; j < history_count - i - 1; j++) {
80103b1d:	83 c1 18             	add    $0x18,%ecx
80103b20:	39 d1                	cmp    %edx,%ecx
80103b22:	75 9c                	jne    80103ac0 <gethistory+0x50>
  for (int i = 0; i < history_count - 1; i++) {
80103b24:	83 ea 18             	sub    $0x18,%edx
80103b27:	83 6d b8 01          	subl   $0x1,-0x48(%ebp)
80103b2b:	75 8b                	jne    80103ab8 <gethistory+0x48>
  for (int i = 0; i < history_count; i++) {
80103b2d:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80103b30:	85 c0                	test   %eax,%eax
80103b32:	7e 2e                	jle    80103b62 <gethistory+0xf2>
80103b34:	bb 04 2e 11 80       	mov    $0x80112e04,%ebx
80103b39:	31 f6                	xor    %esi,%esi
80103b3b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103b3f:	90                   	nop
    cprintf("%d %s %d\n", history[i].pid, history[i].name, history[i].memory_utilization);
80103b40:	ff 73 10             	push   0x10(%ebx)
  for (int i = 0; i < history_count; i++) {
80103b43:	83 c6 01             	add    $0x1,%esi
    cprintf("%d %s %d\n", history[i].pid, history[i].name, history[i].memory_utilization);
80103b46:	53                   	push   %ebx
  for (int i = 0; i < history_count; i++) {
80103b47:	83 c3 18             	add    $0x18,%ebx
    cprintf("%d %s %d\n", history[i].pid, history[i].name, history[i].memory_utilization);
80103b4a:	ff 73 e4             	push   -0x1c(%ebx)
80103b4d:	68 60 7c 10 80       	push   $0x80107c60
80103b52:	e8 49 cb ff ff       	call   801006a0 <cprintf>
  for (int i = 0; i < history_count; i++) {
80103b57:	83 c4 10             	add    $0x10,%esp
80103b5a:	39 35 e0 2d 11 80    	cmp    %esi,0x80112de0
80103b60:	7f de                	jg     80103b40 <gethistory+0xd0>
  release(&ptable.lock);
80103b62:	83 ec 0c             	sub    $0xc,%esp
80103b65:	68 60 37 11 80       	push   $0x80113760
80103b6a:	e8 31 0d 00 00       	call   801048a0 <release>
  return 0; // Success
80103b6f:	83 c4 10             	add    $0x10,%esp
80103b72:	31 c0                	xor    %eax,%eax
}
80103b74:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103b77:	5b                   	pop    %ebx
80103b78:	5e                   	pop    %esi
80103b79:	5f                   	pop    %edi
80103b7a:	5d                   	pop    %ebp
80103b7b:	c3                   	ret    
    release(&ptable.lock);
80103b7c:	83 ec 0c             	sub    $0xc,%esp
80103b7f:	68 60 37 11 80       	push   $0x80113760
80103b84:	e8 17 0d 00 00       	call   801048a0 <release>
    return -1; // No history data available
80103b89:	83 c4 10             	add    $0x10,%esp
80103b8c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103b91:	eb e1                	jmp    80103b74 <gethistory+0x104>
80103b93:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103ba0 <block>:
}
80103ba0:	31 c0                	xor    %eax,%eax
80103ba2:	c3                   	ret    
80103ba3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103baa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bb0 <unblock>:
80103bb0:	31 c0                	xor    %eax,%eax
80103bb2:	c3                   	ret    
80103bb3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103bba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103bc0 <pinit>:
{
80103bc0:	55                   	push   %ebp
80103bc1:	89 e5                	mov    %esp,%ebp
80103bc3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
80103bc6:	68 6a 7c 10 80       	push   $0x80107c6a
80103bcb:	68 60 37 11 80       	push   $0x80113760
80103bd0:	e8 5b 0b 00 00       	call   80104730 <initlock>
}
80103bd5:	83 c4 10             	add    $0x10,%esp
80103bd8:	c9                   	leave  
80103bd9:	c3                   	ret    
80103bda:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103be0 <mycpu>:
{
80103be0:	55                   	push   %ebp
80103be1:	89 e5                	mov    %esp,%ebp
80103be3:	56                   	push   %esi
80103be4:	53                   	push   %ebx
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103be5:	9c                   	pushf  
80103be6:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80103be7:	f6 c4 02             	test   $0x2,%ah
80103bea:	75 46                	jne    80103c32 <mycpu+0x52>
  apicid = lapicid();
80103bec:	e8 af ed ff ff       	call   801029a0 <lapicid>
  for (i = 0; i < ncpu; ++i) {
80103bf1:	8b 35 44 28 11 80    	mov    0x80112844,%esi
80103bf7:	85 f6                	test   %esi,%esi
80103bf9:	7e 2a                	jle    80103c25 <mycpu+0x45>
80103bfb:	31 d2                	xor    %edx,%edx
80103bfd:	eb 08                	jmp    80103c07 <mycpu+0x27>
80103bff:	90                   	nop
80103c00:	83 c2 01             	add    $0x1,%edx
80103c03:	39 f2                	cmp    %esi,%edx
80103c05:	74 1e                	je     80103c25 <mycpu+0x45>
    if (cpus[i].apicid == apicid)
80103c07:	69 ca b0 00 00 00    	imul   $0xb0,%edx,%ecx
80103c0d:	0f b6 99 60 28 11 80 	movzbl -0x7feed7a0(%ecx),%ebx
80103c14:	39 c3                	cmp    %eax,%ebx
80103c16:	75 e8                	jne    80103c00 <mycpu+0x20>
}
80103c18:	8d 65 f8             	lea    -0x8(%ebp),%esp
      return &cpus[i];
80103c1b:	8d 81 60 28 11 80    	lea    -0x7feed7a0(%ecx),%eax
}
80103c21:	5b                   	pop    %ebx
80103c22:	5e                   	pop    %esi
80103c23:	5d                   	pop    %ebp
80103c24:	c3                   	ret    
  panic("unknown apicid\n");
80103c25:	83 ec 0c             	sub    $0xc,%esp
80103c28:	68 71 7c 10 80       	push   $0x80107c71
80103c2d:	e8 4e c7 ff ff       	call   80100380 <panic>
    panic("mycpu called with interrupts enabled\n");
80103c32:	83 ec 0c             	sub    $0xc,%esp
80103c35:	68 50 7d 10 80       	push   $0x80107d50
80103c3a:	e8 41 c7 ff ff       	call   80100380 <panic>
80103c3f:	90                   	nop

80103c40 <cpuid>:
cpuid() {
80103c40:	55                   	push   %ebp
80103c41:	89 e5                	mov    %esp,%ebp
80103c43:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103c46:	e8 95 ff ff ff       	call   80103be0 <mycpu>
}
80103c4b:	c9                   	leave  
  return mycpu()-cpus;
80103c4c:	2d 60 28 11 80       	sub    $0x80112860,%eax
80103c51:	c1 f8 04             	sar    $0x4,%eax
80103c54:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
80103c5a:	c3                   	ret    
80103c5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c5f:	90                   	nop

80103c60 <myproc>:
myproc(void) {
80103c60:	55                   	push   %ebp
80103c61:	89 e5                	mov    %esp,%ebp
80103c63:	53                   	push   %ebx
80103c64:	83 ec 04             	sub    $0x4,%esp
  pushcli();
80103c67:	e8 44 0b 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103c6c:	e8 6f ff ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103c71:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103c77:	e8 84 0b 00 00       	call   80104800 <popcli>
}
80103c7c:	89 d8                	mov    %ebx,%eax
80103c7e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103c81:	c9                   	leave  
80103c82:	c3                   	ret    
80103c83:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103c90 <userinit>:
{
80103c90:	55                   	push   %ebp
80103c91:	89 e5                	mov    %esp,%ebp
80103c93:	53                   	push   %ebx
80103c94:	83 ec 04             	sub    $0x4,%esp
  p = allocproc();
80103c97:	e8 c4 fb ff ff       	call   80103860 <allocproc>
80103c9c:	89 c3                	mov    %eax,%ebx
  initproc = p;
80103c9e:	a3 94 d6 11 80       	mov    %eax,0x8011d694
  if((p->pgdir = setupkvm()) == 0)
80103ca3:	e8 18 37 00 00       	call   801073c0 <setupkvm>
80103ca8:	89 43 04             	mov    %eax,0x4(%ebx)
80103cab:	85 c0                	test   %eax,%eax
80103cad:	0f 84 bd 00 00 00    	je     80103d70 <userinit+0xe0>
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103cb3:	83 ec 04             	sub    $0x4,%esp
80103cb6:	68 2c 00 00 00       	push   $0x2c
80103cbb:	68 60 b4 10 80       	push   $0x8010b460
80103cc0:	50                   	push   %eax
80103cc1:	e8 aa 33 00 00       	call   80107070 <inituvm>
  memset(p->tf, 0, sizeof(*p->tf));
80103cc6:	83 c4 0c             	add    $0xc,%esp
  p->sz = PGSIZE;
80103cc9:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103ccf:	6a 4c                	push   $0x4c
80103cd1:	6a 00                	push   $0x0
80103cd3:	ff 73 18             	push   0x18(%ebx)
80103cd6:	e8 e5 0c 00 00       	call   801049c0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103cdb:	8b 43 18             	mov    0x18(%ebx),%eax
80103cde:	ba 1b 00 00 00       	mov    $0x1b,%edx
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103ce3:	83 c4 0c             	add    $0xc,%esp
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103ce6:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103ceb:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103cef:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf2:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103cf6:	8b 43 18             	mov    0x18(%ebx),%eax
80103cf9:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103cfd:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103d01:	8b 43 18             	mov    0x18(%ebx),%eax
80103d04:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103d08:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
80103d0c:	8b 43 18             	mov    0x18(%ebx),%eax
80103d0f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103d16:	8b 43 18             	mov    0x18(%ebx),%eax
80103d19:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103d20:	8b 43 18             	mov    0x18(%ebx),%eax
80103d23:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)
  safestrcpy(p->name, "initcode", sizeof(p->name));
80103d2a:	8d 43 6c             	lea    0x6c(%ebx),%eax
80103d2d:	6a 10                	push   $0x10
80103d2f:	68 9a 7c 10 80       	push   $0x80107c9a
80103d34:	50                   	push   %eax
80103d35:	e8 46 0e 00 00       	call   80104b80 <safestrcpy>
  p->cwd = namei("/");
80103d3a:	c7 04 24 a3 7c 10 80 	movl   $0x80107ca3,(%esp)
80103d41:	e8 0a e4 ff ff       	call   80102150 <namei>
80103d46:	89 43 68             	mov    %eax,0x68(%ebx)
  acquire(&ptable.lock);
80103d49:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80103d50:	e8 ab 0b 00 00       	call   80104900 <acquire>
  p->state = RUNNABLE;
80103d55:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  release(&ptable.lock);
80103d5c:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80103d63:	e8 38 0b 00 00       	call   801048a0 <release>
}
80103d68:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d6b:	83 c4 10             	add    $0x10,%esp
80103d6e:	c9                   	leave  
80103d6f:	c3                   	ret    
    panic("userinit: out of memory?");
80103d70:	83 ec 0c             	sub    $0xc,%esp
80103d73:	68 81 7c 10 80       	push   $0x80107c81
80103d78:	e8 03 c6 ff ff       	call   80100380 <panic>
80103d7d:	8d 76 00             	lea    0x0(%esi),%esi

80103d80 <growproc>:
{
80103d80:	55                   	push   %ebp
80103d81:	89 e5                	mov    %esp,%ebp
80103d83:	56                   	push   %esi
80103d84:	53                   	push   %ebx
80103d85:	8b 75 08             	mov    0x8(%ebp),%esi
  pushcli();
80103d88:	e8 23 0a 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103d8d:	e8 4e fe ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103d92:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d98:	e8 63 0a 00 00       	call   80104800 <popcli>
  sz = curproc->sz;
80103d9d:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
80103d9f:	85 f6                	test   %esi,%esi
80103da1:	7f 1d                	jg     80103dc0 <growproc+0x40>
  } else if(n < 0){
80103da3:	75 3b                	jne    80103de0 <growproc+0x60>
  switchuvm(curproc);
80103da5:	83 ec 0c             	sub    $0xc,%esp
  curproc->sz = sz;
80103da8:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103daa:	53                   	push   %ebx
80103dab:	e8 b0 31 00 00       	call   80106f60 <switchuvm>
  return 0;
80103db0:	83 c4 10             	add    $0x10,%esp
80103db3:	31 c0                	xor    %eax,%eax
}
80103db5:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103db8:	5b                   	pop    %ebx
80103db9:	5e                   	pop    %esi
80103dba:	5d                   	pop    %ebp
80103dbb:	c3                   	ret    
80103dbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103dc0:	83 ec 04             	sub    $0x4,%esp
80103dc3:	01 c6                	add    %eax,%esi
80103dc5:	56                   	push   %esi
80103dc6:	50                   	push   %eax
80103dc7:	ff 73 04             	push   0x4(%ebx)
80103dca:	e8 11 34 00 00       	call   801071e0 <allocuvm>
80103dcf:	83 c4 10             	add    $0x10,%esp
80103dd2:	85 c0                	test   %eax,%eax
80103dd4:	75 cf                	jne    80103da5 <growproc+0x25>
      return -1;
80103dd6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103ddb:	eb d8                	jmp    80103db5 <growproc+0x35>
80103ddd:	8d 76 00             	lea    0x0(%esi),%esi
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103de0:	83 ec 04             	sub    $0x4,%esp
80103de3:	01 c6                	add    %eax,%esi
80103de5:	56                   	push   %esi
80103de6:	50                   	push   %eax
80103de7:	ff 73 04             	push   0x4(%ebx)
80103dea:	e8 21 35 00 00       	call   80107310 <deallocuvm>
80103def:	83 c4 10             	add    $0x10,%esp
80103df2:	85 c0                	test   %eax,%eax
80103df4:	75 af                	jne    80103da5 <growproc+0x25>
80103df6:	eb de                	jmp    80103dd6 <growproc+0x56>
80103df8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dff:	90                   	nop

80103e00 <fork>:
{
80103e00:	55                   	push   %ebp
80103e01:	89 e5                	mov    %esp,%ebp
80103e03:	57                   	push   %edi
80103e04:	56                   	push   %esi
80103e05:	53                   	push   %ebx
80103e06:	83 ec 1c             	sub    $0x1c,%esp
  pushcli();
80103e09:	e8 a2 09 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103e0e:	e8 cd fd ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103e13:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103e19:	e8 e2 09 00 00       	call   80104800 <popcli>
  if((np = allocproc()) == 0){
80103e1e:	e8 3d fa ff ff       	call   80103860 <allocproc>
80103e23:	85 c0                	test   %eax,%eax
80103e25:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80103e28:	0f 84 eb 00 00 00    	je     80103f19 <fork+0x119>
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103e2e:	83 ec 08             	sub    $0x8,%esp
80103e31:	ff 33                	push   (%ebx)
80103e33:	ff 73 04             	push   0x4(%ebx)
80103e36:	e8 75 36 00 00       	call   801074b0 <copyuvm>
80103e3b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103e3e:	83 c4 10             	add    $0x10,%esp
80103e41:	89 42 04             	mov    %eax,0x4(%edx)
80103e44:	85 c0                	test   %eax,%eax
80103e46:	0f 84 d4 00 00 00    	je     80103f20 <fork+0x120>
  np->sz = curproc->sz;
80103e4c:	8b 03                	mov    (%ebx),%eax
  *np->tf = *curproc->tf;
80103e4e:	8b 7a 18             	mov    0x18(%edx),%edi
  np->parent = curproc;
80103e51:	89 5a 14             	mov    %ebx,0x14(%edx)
  *np->tf = *curproc->tf;
80103e54:	b9 13 00 00 00       	mov    $0x13,%ecx
  np->sz = curproc->sz;
80103e59:	89 02                	mov    %eax,(%edx)
  *np->tf = *curproc->tf;
80103e5b:	8b 73 18             	mov    0x18(%ebx),%esi
  for (i = 0; i < MAX_SYSCALLS; i++) {
80103e5e:	31 c0                	xor    %eax,%eax
  *np->tf = *curproc->tf;
80103e60:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  for (i = 0; i < MAX_SYSCALLS; i++) {
80103e62:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    np->blocked_syscalls[i] = curproc->blocked_syscalls[i];
80103e68:	8b 8c 83 7c 01 00 00 	mov    0x17c(%ebx,%eax,4),%ecx
80103e6f:	89 8c 82 7c 01 00 00 	mov    %ecx,0x17c(%edx,%eax,4)
    np->pass_syscalls[i] = curproc->pass_syscalls[i];
80103e76:	8b 4c 83 7c          	mov    0x7c(%ebx,%eax,4),%ecx
80103e7a:	89 4c 82 7c          	mov    %ecx,0x7c(%edx,%eax,4)
  for (i = 0; i < MAX_SYSCALLS; i++) {
80103e7e:	83 c0 01             	add    $0x1,%eax
80103e81:	83 f8 40             	cmp    $0x40,%eax
80103e84:	75 e2                	jne    80103e68 <fork+0x68>
  np->tf->eax = 0;
80103e86:	8b 42 18             	mov    0x18(%edx),%eax
  for(i = 0; i < NOFILE; i++)
80103e89:	31 f6                	xor    %esi,%esi
  np->tf->eax = 0;
80103e8b:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
  for(i = 0; i < NOFILE; i++)
80103e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[i])
80103e98:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103e9c:	85 c0                	test   %eax,%eax
80103e9e:	74 16                	je     80103eb6 <fork+0xb6>
      np->ofile[i] = filedup(curproc->ofile[i]);
80103ea0:	83 ec 0c             	sub    $0xc,%esp
80103ea3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80103ea6:	50                   	push   %eax
80103ea7:	e8 84 d0 ff ff       	call   80100f30 <filedup>
80103eac:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103eaf:	83 c4 10             	add    $0x10,%esp
80103eb2:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  for(i = 0; i < NOFILE; i++)
80103eb6:	83 c6 01             	add    $0x1,%esi
80103eb9:	83 fe 10             	cmp    $0x10,%esi
80103ebc:	75 da                	jne    80103e98 <fork+0x98>
  np->cwd = idup(curproc->cwd);
80103ebe:	83 ec 0c             	sub    $0xc,%esp
80103ec1:	ff 73 68             	push   0x68(%ebx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ec4:	83 c3 6c             	add    $0x6c,%ebx
80103ec7:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  np->cwd = idup(curproc->cwd);
80103eca:	e8 31 d9 ff ff       	call   80101800 <idup>
80103ecf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ed2:	83 c4 0c             	add    $0xc,%esp
  np->cwd = idup(curproc->cwd);
80103ed5:	89 42 68             	mov    %eax,0x68(%edx)
  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
80103ed8:	8d 42 6c             	lea    0x6c(%edx),%eax
80103edb:	6a 10                	push   $0x10
80103edd:	53                   	push   %ebx
80103ede:	50                   	push   %eax
80103edf:	e8 9c 0c 00 00       	call   80104b80 <safestrcpy>
  pid = np->pid;
80103ee4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ee7:	8b 5a 10             	mov    0x10(%edx),%ebx
  acquire(&ptable.lock);
80103eea:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80103ef1:	e8 0a 0a 00 00       	call   80104900 <acquire>
  np->state = RUNNABLE;
80103ef6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80103ef9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
  release(&ptable.lock);
80103f00:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80103f07:	e8 94 09 00 00       	call   801048a0 <release>
  return pid;
80103f0c:	83 c4 10             	add    $0x10,%esp
}
80103f0f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103f12:	89 d8                	mov    %ebx,%eax
80103f14:	5b                   	pop    %ebx
80103f15:	5e                   	pop    %esi
80103f16:	5f                   	pop    %edi
80103f17:	5d                   	pop    %ebp
80103f18:	c3                   	ret    
    return -1;
80103f19:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80103f1e:	eb ef                	jmp    80103f0f <fork+0x10f>
    kfree(np->kstack);
80103f20:	83 ec 0c             	sub    $0xc,%esp
80103f23:	ff 72 08             	push   0x8(%edx)
    return -1;
80103f26:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    kfree(np->kstack);
80103f2b:	e8 40 e6 ff ff       	call   80102570 <kfree>
    np->kstack = 0;
80103f30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    return -1;
80103f33:	83 c4 10             	add    $0x10,%esp
    np->kstack = 0;
80103f36:	c7 42 08 00 00 00 00 	movl   $0x0,0x8(%edx)
    np->state = UNUSED;
80103f3d:	c7 42 0c 00 00 00 00 	movl   $0x0,0xc(%edx)
    return -1;
80103f44:	eb c9                	jmp    80103f0f <fork+0x10f>
80103f46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f4d:	8d 76 00             	lea    0x0(%esi),%esi

80103f50 <scheduler>:
{
80103f50:	55                   	push   %ebp
80103f51:	89 e5                	mov    %esp,%ebp
80103f53:	57                   	push   %edi
80103f54:	56                   	push   %esi
80103f55:	53                   	push   %ebx
80103f56:	83 ec 0c             	sub    $0xc,%esp
  struct cpu *c = mycpu();
80103f59:	e8 82 fc ff ff       	call   80103be0 <mycpu>
  c->proc = 0;
80103f5e:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103f65:	00 00 00 
  struct cpu *c = mycpu();
80103f68:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103f6a:	8d 78 04             	lea    0x4(%eax),%edi
80103f6d:	8d 76 00             	lea    0x0(%esi),%esi
  asm volatile("sti");
80103f70:	fb                   	sti    
    acquire(&ptable.lock);
80103f71:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f74:	bb 94 37 11 80       	mov    $0x80113794,%ebx
    acquire(&ptable.lock);
80103f79:	68 60 37 11 80       	push   $0x80113760
80103f7e:	e8 7d 09 00 00       	call   80104900 <acquire>
80103f83:	83 c4 10             	add    $0x10,%esp
80103f86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103f8d:	8d 76 00             	lea    0x0(%esi),%esi
      if(p->state != RUNNABLE)
80103f90:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
80103f94:	75 33                	jne    80103fc9 <scheduler+0x79>
      switchuvm(p);
80103f96:	83 ec 0c             	sub    $0xc,%esp
      c->proc = p;
80103f99:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103f9f:	53                   	push   %ebx
80103fa0:	e8 bb 2f 00 00       	call   80106f60 <switchuvm>
      swtch(&(c->scheduler), p->context);
80103fa5:	58                   	pop    %eax
80103fa6:	5a                   	pop    %edx
80103fa7:	ff 73 1c             	push   0x1c(%ebx)
80103faa:	57                   	push   %edi
      p->state = RUNNING;
80103fab:	c7 43 0c 04 00 00 00 	movl   $0x4,0xc(%ebx)
      swtch(&(c->scheduler), p->context);
80103fb2:	e8 24 0c 00 00       	call   80104bdb <swtch>
      switchkvm();
80103fb7:	e8 94 2f 00 00       	call   80106f50 <switchkvm>
      c->proc = 0;
80103fbc:	83 c4 10             	add    $0x10,%esp
80103fbf:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103fc6:	00 00 00 
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103fc9:	81 c3 7c 02 00 00    	add    $0x27c,%ebx
80103fcf:	81 fb 94 d6 11 80    	cmp    $0x8011d694,%ebx
80103fd5:	75 b9                	jne    80103f90 <scheduler+0x40>
    release(&ptable.lock);
80103fd7:	83 ec 0c             	sub    $0xc,%esp
80103fda:	68 60 37 11 80       	push   $0x80113760
80103fdf:	e8 bc 08 00 00       	call   801048a0 <release>
    sti();
80103fe4:	83 c4 10             	add    $0x10,%esp
80103fe7:	eb 87                	jmp    80103f70 <scheduler+0x20>
80103fe9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103ff0 <sched>:
{
80103ff0:	55                   	push   %ebp
80103ff1:	89 e5                	mov    %esp,%ebp
80103ff3:	56                   	push   %esi
80103ff4:	53                   	push   %ebx
  pushcli();
80103ff5:	e8 b6 07 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80103ffa:	e8 e1 fb ff ff       	call   80103be0 <mycpu>
  p = c->proc;
80103fff:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104005:	e8 f6 07 00 00       	call   80104800 <popcli>
  if(!holding(&ptable.lock))
8010400a:	83 ec 0c             	sub    $0xc,%esp
8010400d:	68 60 37 11 80       	push   $0x80113760
80104012:	e8 49 08 00 00       	call   80104860 <holding>
80104017:	83 c4 10             	add    $0x10,%esp
8010401a:	85 c0                	test   %eax,%eax
8010401c:	74 4f                	je     8010406d <sched+0x7d>
  if(mycpu()->ncli != 1)
8010401e:	e8 bd fb ff ff       	call   80103be0 <mycpu>
80104023:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
8010402a:	75 68                	jne    80104094 <sched+0xa4>
  if(p->state == RUNNING)
8010402c:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80104030:	74 55                	je     80104087 <sched+0x97>
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104032:	9c                   	pushf  
80104033:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104034:	f6 c4 02             	test   $0x2,%ah
80104037:	75 41                	jne    8010407a <sched+0x8a>
  intena = mycpu()->intena;
80104039:	e8 a2 fb ff ff       	call   80103be0 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
8010403e:	83 c3 1c             	add    $0x1c,%ebx
  intena = mycpu()->intena;
80104041:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80104047:	e8 94 fb ff ff       	call   80103be0 <mycpu>
8010404c:	83 ec 08             	sub    $0x8,%esp
8010404f:	ff 70 04             	push   0x4(%eax)
80104052:	53                   	push   %ebx
80104053:	e8 83 0b 00 00       	call   80104bdb <swtch>
  mycpu()->intena = intena;
80104058:	e8 83 fb ff ff       	call   80103be0 <mycpu>
}
8010405d:	83 c4 10             	add    $0x10,%esp
  mycpu()->intena = intena;
80104060:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80104066:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104069:	5b                   	pop    %ebx
8010406a:	5e                   	pop    %esi
8010406b:	5d                   	pop    %ebp
8010406c:	c3                   	ret    
    panic("sched ptable.lock");
8010406d:	83 ec 0c             	sub    $0xc,%esp
80104070:	68 a5 7c 10 80       	push   $0x80107ca5
80104075:	e8 06 c3 ff ff       	call   80100380 <panic>
    panic("sched interruptible");
8010407a:	83 ec 0c             	sub    $0xc,%esp
8010407d:	68 d1 7c 10 80       	push   $0x80107cd1
80104082:	e8 f9 c2 ff ff       	call   80100380 <panic>
    panic("sched running");
80104087:	83 ec 0c             	sub    $0xc,%esp
8010408a:	68 c3 7c 10 80       	push   $0x80107cc3
8010408f:	e8 ec c2 ff ff       	call   80100380 <panic>
    panic("sched locks");
80104094:	83 ec 0c             	sub    $0xc,%esp
80104097:	68 b7 7c 10 80       	push   $0x80107cb7
8010409c:	e8 df c2 ff ff       	call   80100380 <panic>
801040a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801040af:	90                   	nop

801040b0 <exit>:
{
801040b0:	55                   	push   %ebp
801040b1:	89 e5                	mov    %esp,%ebp
801040b3:	57                   	push   %edi
801040b4:	56                   	push   %esi
801040b5:	53                   	push   %ebx
801040b6:	83 ec 0c             	sub    $0xc,%esp
  struct proc *curproc = myproc();
801040b9:	e8 a2 fb ff ff       	call   80103c60 <myproc>
  if(!(strcmp("sh", curproc->name) == 0 && curproc->sz != 16384)){
801040be:	83 ec 08             	sub    $0x8,%esp
801040c1:	8d 70 6c             	lea    0x6c(%eax),%esi
  struct proc *curproc = myproc();
801040c4:	89 c3                	mov    %eax,%ebx
  if(!(strcmp("sh", curproc->name) == 0 && curproc->sz != 16384)){
801040c6:	56                   	push   %esi
801040c7:	68 e5 7c 10 80       	push   $0x80107ce5
801040cc:	e8 df f8 ff ff       	call   801039b0 <strcmp>
801040d1:	83 c4 10             	add    $0x10,%esp
801040d4:	85 c0                	test   %eax,%eax
801040d6:	0f 85 fc 00 00 00    	jne    801041d8 <exit+0x128>
801040dc:	81 3b 00 40 00 00    	cmpl   $0x4000,(%ebx)
801040e2:	0f 84 f0 00 00 00    	je     801041d8 <exit+0x128>
  if(curproc == initproc)
801040e8:	8d 73 28             	lea    0x28(%ebx),%esi
801040eb:	8d 7b 68             	lea    0x68(%ebx),%edi
801040ee:	39 1d 94 d6 11 80    	cmp    %ebx,0x8011d694
801040f4:	0f 84 0b 01 00 00    	je     80104205 <exit+0x155>
801040fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(curproc->ofile[fd]){
80104100:	8b 06                	mov    (%esi),%eax
80104102:	85 c0                	test   %eax,%eax
80104104:	74 12                	je     80104118 <exit+0x68>
      fileclose(curproc->ofile[fd]);
80104106:	83 ec 0c             	sub    $0xc,%esp
80104109:	50                   	push   %eax
8010410a:	e8 71 ce ff ff       	call   80100f80 <fileclose>
      curproc->ofile[fd] = 0;
8010410f:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
80104115:	83 c4 10             	add    $0x10,%esp
  for(fd = 0; fd < NOFILE; fd++){
80104118:	83 c6 04             	add    $0x4,%esi
8010411b:	39 f7                	cmp    %esi,%edi
8010411d:	75 e1                	jne    80104100 <exit+0x50>
  begin_op();
8010411f:	e8 ec ec ff ff       	call   80102e10 <begin_op>
  iput(curproc->cwd);
80104124:	83 ec 0c             	sub    $0xc,%esp
80104127:	ff 73 68             	push   0x68(%ebx)
8010412a:	e8 31 d8 ff ff       	call   80101960 <iput>
  end_op();
8010412f:	e8 4c ed ff ff       	call   80102e80 <end_op>
  curproc->cwd = 0;
80104134:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)
  acquire(&ptable.lock);
8010413b:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80104142:	e8 b9 07 00 00       	call   80104900 <acquire>
  wakeup1(curproc->parent);
80104147:	8b 53 14             	mov    0x14(%ebx),%edx
8010414a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010414d:	b8 94 37 11 80       	mov    $0x80113794,%eax
80104152:	eb 10                	jmp    80104164 <exit+0xb4>
80104154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104158:	05 7c 02 00 00       	add    $0x27c,%eax
8010415d:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
80104162:	74 1e                	je     80104182 <exit+0xd2>
    if(p->state == SLEEPING && p->chan == chan)
80104164:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104168:	75 ee                	jne    80104158 <exit+0xa8>
8010416a:	3b 50 20             	cmp    0x20(%eax),%edx
8010416d:	75 e9                	jne    80104158 <exit+0xa8>
      p->state = RUNNABLE;
8010416f:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104176:	05 7c 02 00 00       	add    $0x27c,%eax
8010417b:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
80104180:	75 e2                	jne    80104164 <exit+0xb4>
      p->parent = initproc;
80104182:	8b 0d 94 d6 11 80    	mov    0x8011d694,%ecx
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104188:	ba 94 37 11 80       	mov    $0x80113794,%edx
8010418d:	eb 0f                	jmp    8010419e <exit+0xee>
8010418f:	90                   	nop
80104190:	81 c2 7c 02 00 00    	add    $0x27c,%edx
80104196:	81 fa 94 d6 11 80    	cmp    $0x8011d694,%edx
8010419c:	74 4e                	je     801041ec <exit+0x13c>
    if(p->parent == curproc){
8010419e:	39 5a 14             	cmp    %ebx,0x14(%edx)
801041a1:	75 ed                	jne    80104190 <exit+0xe0>
      if(p->state == ZOMBIE)
801041a3:	83 7a 0c 05          	cmpl   $0x5,0xc(%edx)
      p->parent = initproc;
801041a7:	89 4a 14             	mov    %ecx,0x14(%edx)
      if(p->state == ZOMBIE)
801041aa:	75 e4                	jne    80104190 <exit+0xe0>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801041ac:	b8 94 37 11 80       	mov    $0x80113794,%eax
801041b1:	eb 11                	jmp    801041c4 <exit+0x114>
801041b3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801041b7:	90                   	nop
801041b8:	05 7c 02 00 00       	add    $0x27c,%eax
801041bd:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
801041c2:	74 cc                	je     80104190 <exit+0xe0>
    if(p->state == SLEEPING && p->chan == chan)
801041c4:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
801041c8:	75 ee                	jne    801041b8 <exit+0x108>
801041ca:	3b 48 20             	cmp    0x20(%eax),%ecx
801041cd:	75 e9                	jne    801041b8 <exit+0x108>
      p->state = RUNNABLE;
801041cf:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
801041d6:	eb e0                	jmp    801041b8 <exit+0x108>
    add_to_history(curproc->pid, curproc->name, curproc->sz);
801041d8:	50                   	push   %eax
801041d9:	ff 33                	push   (%ebx)
801041db:	56                   	push   %esi
801041dc:	ff 73 10             	push   0x10(%ebx)
801041df:	e8 2c f8 ff ff       	call   80103a10 <add_to_history>
801041e4:	83 c4 10             	add    $0x10,%esp
801041e7:	e9 fc fe ff ff       	jmp    801040e8 <exit+0x38>
  curproc->state = ZOMBIE;
801041ec:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
801041f3:	e8 f8 fd ff ff       	call   80103ff0 <sched>
  panic("zombie exit");
801041f8:	83 ec 0c             	sub    $0xc,%esp
801041fb:	68 f5 7c 10 80       	push   $0x80107cf5
80104200:	e8 7b c1 ff ff       	call   80100380 <panic>
    panic("init exiting");
80104205:	83 ec 0c             	sub    $0xc,%esp
80104208:	68 e8 7c 10 80       	push   $0x80107ce8
8010420d:	e8 6e c1 ff ff       	call   80100380 <panic>
80104212:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104219:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104220 <wait>:
{
80104220:	55                   	push   %ebp
80104221:	89 e5                	mov    %esp,%ebp
80104223:	56                   	push   %esi
80104224:	53                   	push   %ebx
  pushcli();
80104225:	e8 86 05 00 00       	call   801047b0 <pushcli>
  c = mycpu();
8010422a:	e8 b1 f9 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
8010422f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80104235:	e8 c6 05 00 00       	call   80104800 <popcli>
  acquire(&ptable.lock);
8010423a:	83 ec 0c             	sub    $0xc,%esp
8010423d:	68 60 37 11 80       	push   $0x80113760
80104242:	e8 b9 06 00 00       	call   80104900 <acquire>
80104247:	83 c4 10             	add    $0x10,%esp
    havekids = 0;
8010424a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010424c:	bb 94 37 11 80       	mov    $0x80113794,%ebx
80104251:	eb 13                	jmp    80104266 <wait+0x46>
80104253:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104257:	90                   	nop
80104258:	81 c3 7c 02 00 00    	add    $0x27c,%ebx
8010425e:	81 fb 94 d6 11 80    	cmp    $0x8011d694,%ebx
80104264:	74 1e                	je     80104284 <wait+0x64>
      if(p->parent != curproc)
80104266:	39 73 14             	cmp    %esi,0x14(%ebx)
80104269:	75 ed                	jne    80104258 <wait+0x38>
      if(p->state == ZOMBIE){
8010426b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
8010426f:	74 5f                	je     801042d0 <wait+0xb0>
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104271:	81 c3 7c 02 00 00    	add    $0x27c,%ebx
      havekids = 1;
80104277:	b8 01 00 00 00       	mov    $0x1,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010427c:	81 fb 94 d6 11 80    	cmp    $0x8011d694,%ebx
80104282:	75 e2                	jne    80104266 <wait+0x46>
    if(!havekids || curproc->killed){
80104284:	85 c0                	test   %eax,%eax
80104286:	0f 84 9a 00 00 00    	je     80104326 <wait+0x106>
8010428c:	8b 46 24             	mov    0x24(%esi),%eax
8010428f:	85 c0                	test   %eax,%eax
80104291:	0f 85 8f 00 00 00    	jne    80104326 <wait+0x106>
  pushcli();
80104297:	e8 14 05 00 00       	call   801047b0 <pushcli>
  c = mycpu();
8010429c:	e8 3f f9 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801042a1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801042a7:	e8 54 05 00 00       	call   80104800 <popcli>
  if(p == 0)
801042ac:	85 db                	test   %ebx,%ebx
801042ae:	0f 84 89 00 00 00    	je     8010433d <wait+0x11d>
  p->chan = chan;
801042b4:	89 73 20             	mov    %esi,0x20(%ebx)
  p->state = SLEEPING;
801042b7:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801042be:	e8 2d fd ff ff       	call   80103ff0 <sched>
  p->chan = 0;
801042c3:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
801042ca:	e9 7b ff ff ff       	jmp    8010424a <wait+0x2a>
801042cf:	90                   	nop
        kfree(p->kstack);
801042d0:	83 ec 0c             	sub    $0xc,%esp
        pid = p->pid;
801042d3:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
801042d6:	ff 73 08             	push   0x8(%ebx)
801042d9:	e8 92 e2 ff ff       	call   80102570 <kfree>
        p->kstack = 0;
801042de:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
801042e5:	5a                   	pop    %edx
801042e6:	ff 73 04             	push   0x4(%ebx)
801042e9:	e8 52 30 00 00       	call   80107340 <freevm>
        p->pid = 0;
801042ee:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
801042f5:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
801042fc:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80104300:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80104307:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
8010430e:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80104315:	e8 86 05 00 00       	call   801048a0 <release>
        return pid;
8010431a:	83 c4 10             	add    $0x10,%esp
}
8010431d:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104320:	89 f0                	mov    %esi,%eax
80104322:	5b                   	pop    %ebx
80104323:	5e                   	pop    %esi
80104324:	5d                   	pop    %ebp
80104325:	c3                   	ret    
      release(&ptable.lock);
80104326:	83 ec 0c             	sub    $0xc,%esp
      return -1;
80104329:	be ff ff ff ff       	mov    $0xffffffff,%esi
      release(&ptable.lock);
8010432e:	68 60 37 11 80       	push   $0x80113760
80104333:	e8 68 05 00 00       	call   801048a0 <release>
      return -1;
80104338:	83 c4 10             	add    $0x10,%esp
8010433b:	eb e0                	jmp    8010431d <wait+0xfd>
    panic("sleep");
8010433d:	83 ec 0c             	sub    $0xc,%esp
80104340:	68 01 7d 10 80       	push   $0x80107d01
80104345:	e8 36 c0 ff ff       	call   80100380 <panic>
8010434a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104350 <yield>:
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80104357:	68 60 37 11 80       	push   $0x80113760
8010435c:	e8 9f 05 00 00       	call   80104900 <acquire>
  pushcli();
80104361:	e8 4a 04 00 00       	call   801047b0 <pushcli>
  c = mycpu();
80104366:	e8 75 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
8010436b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80104371:	e8 8a 04 00 00       	call   80104800 <popcli>
  myproc()->state = RUNNABLE;
80104376:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)
  sched();
8010437d:	e8 6e fc ff ff       	call   80103ff0 <sched>
  release(&ptable.lock);
80104382:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
80104389:	e8 12 05 00 00       	call   801048a0 <release>
}
8010438e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104391:	83 c4 10             	add    $0x10,%esp
80104394:	c9                   	leave  
80104395:	c3                   	ret    
80104396:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010439d:	8d 76 00             	lea    0x0(%esi),%esi

801043a0 <sleep>:
{
801043a0:	55                   	push   %ebp
801043a1:	89 e5                	mov    %esp,%ebp
801043a3:	57                   	push   %edi
801043a4:	56                   	push   %esi
801043a5:	53                   	push   %ebx
801043a6:	83 ec 0c             	sub    $0xc,%esp
801043a9:	8b 7d 08             	mov    0x8(%ebp),%edi
801043ac:	8b 75 0c             	mov    0xc(%ebp),%esi
  pushcli();
801043af:	e8 fc 03 00 00       	call   801047b0 <pushcli>
  c = mycpu();
801043b4:	e8 27 f8 ff ff       	call   80103be0 <mycpu>
  p = c->proc;
801043b9:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801043bf:	e8 3c 04 00 00       	call   80104800 <popcli>
  if(p == 0)
801043c4:	85 db                	test   %ebx,%ebx
801043c6:	0f 84 87 00 00 00    	je     80104453 <sleep+0xb3>
  if(lk == 0)
801043cc:	85 f6                	test   %esi,%esi
801043ce:	74 76                	je     80104446 <sleep+0xa6>
  if(lk != &ptable.lock){  //DOC: sleeplock0
801043d0:	81 fe 60 37 11 80    	cmp    $0x80113760,%esi
801043d6:	74 50                	je     80104428 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
801043d8:	83 ec 0c             	sub    $0xc,%esp
801043db:	68 60 37 11 80       	push   $0x80113760
801043e0:	e8 1b 05 00 00       	call   80104900 <acquire>
    release(lk);
801043e5:	89 34 24             	mov    %esi,(%esp)
801043e8:	e8 b3 04 00 00       	call   801048a0 <release>
  p->chan = chan;
801043ed:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
801043f0:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
801043f7:	e8 f4 fb ff ff       	call   80103ff0 <sched>
  p->chan = 0;
801043fc:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
    release(&ptable.lock);
80104403:	c7 04 24 60 37 11 80 	movl   $0x80113760,(%esp)
8010440a:	e8 91 04 00 00       	call   801048a0 <release>
    acquire(lk);
8010440f:	89 75 08             	mov    %esi,0x8(%ebp)
80104412:	83 c4 10             	add    $0x10,%esp
}
80104415:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104418:	5b                   	pop    %ebx
80104419:	5e                   	pop    %esi
8010441a:	5f                   	pop    %edi
8010441b:	5d                   	pop    %ebp
    acquire(lk);
8010441c:	e9 df 04 00 00       	jmp    80104900 <acquire>
80104421:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  p->chan = chan;
80104428:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
8010442b:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)
  sched();
80104432:	e8 b9 fb ff ff       	call   80103ff0 <sched>
  p->chan = 0;
80104437:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
}
8010443e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104441:	5b                   	pop    %ebx
80104442:	5e                   	pop    %esi
80104443:	5f                   	pop    %edi
80104444:	5d                   	pop    %ebp
80104445:	c3                   	ret    
    panic("sleep without lk");
80104446:	83 ec 0c             	sub    $0xc,%esp
80104449:	68 07 7d 10 80       	push   $0x80107d07
8010444e:	e8 2d bf ff ff       	call   80100380 <panic>
    panic("sleep");
80104453:	83 ec 0c             	sub    $0xc,%esp
80104456:	68 01 7d 10 80       	push   $0x80107d01
8010445b:	e8 20 bf ff ff       	call   80100380 <panic>

80104460 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80104460:	55                   	push   %ebp
80104461:	89 e5                	mov    %esp,%ebp
80104463:	53                   	push   %ebx
80104464:	83 ec 10             	sub    $0x10,%esp
80104467:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
8010446a:	68 60 37 11 80       	push   $0x80113760
8010446f:	e8 8c 04 00 00       	call   80104900 <acquire>
80104474:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80104477:	b8 94 37 11 80       	mov    $0x80113794,%eax
8010447c:	eb 0e                	jmp    8010448c <wakeup+0x2c>
8010447e:	66 90                	xchg   %ax,%ax
80104480:	05 7c 02 00 00       	add    $0x27c,%eax
80104485:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
8010448a:	74 1e                	je     801044aa <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
8010448c:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80104490:	75 ee                	jne    80104480 <wakeup+0x20>
80104492:	3b 58 20             	cmp    0x20(%eax),%ebx
80104495:	75 e9                	jne    80104480 <wakeup+0x20>
      p->state = RUNNABLE;
80104497:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010449e:	05 7c 02 00 00       	add    $0x27c,%eax
801044a3:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
801044a8:	75 e2                	jne    8010448c <wakeup+0x2c>
  wakeup1(chan);
  release(&ptable.lock);
801044aa:	c7 45 08 60 37 11 80 	movl   $0x80113760,0x8(%ebp)
}
801044b1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801044b4:	c9                   	leave  
  release(&ptable.lock);
801044b5:	e9 e6 03 00 00       	jmp    801048a0 <release>
801044ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801044c0 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
801044c0:	55                   	push   %ebp
801044c1:	89 e5                	mov    %esp,%ebp
801044c3:	53                   	push   %ebx
801044c4:	83 ec 10             	sub    $0x10,%esp
801044c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
801044ca:	68 60 37 11 80       	push   $0x80113760
801044cf:	e8 2c 04 00 00       	call   80104900 <acquire>
801044d4:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801044d7:	b8 94 37 11 80       	mov    $0x80113794,%eax
801044dc:	eb 0e                	jmp    801044ec <kill+0x2c>
801044de:	66 90                	xchg   %ax,%ax
801044e0:	05 7c 02 00 00       	add    $0x27c,%eax
801044e5:	3d 94 d6 11 80       	cmp    $0x8011d694,%eax
801044ea:	74 34                	je     80104520 <kill+0x60>
    if(p->pid == pid){
801044ec:	39 58 10             	cmp    %ebx,0x10(%eax)
801044ef:	75 ef                	jne    801044e0 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
801044f1:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
      p->killed = 1;
801044f5:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      if(p->state == SLEEPING)
801044fc:	75 07                	jne    80104505 <kill+0x45>
        p->state = RUNNABLE;
801044fe:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
      release(&ptable.lock);
80104505:	83 ec 0c             	sub    $0xc,%esp
80104508:	68 60 37 11 80       	push   $0x80113760
8010450d:	e8 8e 03 00 00       	call   801048a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80104512:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return 0;
80104515:	83 c4 10             	add    $0x10,%esp
80104518:	31 c0                	xor    %eax,%eax
}
8010451a:	c9                   	leave  
8010451b:	c3                   	ret    
8010451c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  release(&ptable.lock);
80104520:	83 ec 0c             	sub    $0xc,%esp
80104523:	68 60 37 11 80       	push   $0x80113760
80104528:	e8 73 03 00 00       	call   801048a0 <release>
}
8010452d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  return -1;
80104530:	83 c4 10             	add    $0x10,%esp
80104533:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104538:	c9                   	leave  
80104539:	c3                   	ret    
8010453a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104540 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	57                   	push   %edi
80104544:	56                   	push   %esi
80104545:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104548:	53                   	push   %ebx
80104549:	bb 00 38 11 80       	mov    $0x80113800,%ebx
8010454e:	83 ec 3c             	sub    $0x3c,%esp
80104551:	eb 27                	jmp    8010457a <procdump+0x3a>
80104553:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104557:	90                   	nop
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104558:	83 ec 0c             	sub    $0xc,%esp
8010455b:	68 ef 80 10 80       	push   $0x801080ef
80104560:	e8 3b c1 ff ff       	call   801006a0 <cprintf>
80104565:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80104568:	81 c3 7c 02 00 00    	add    $0x27c,%ebx
8010456e:	81 fb 00 d7 11 80    	cmp    $0x8011d700,%ebx
80104574:	0f 84 7e 00 00 00    	je     801045f8 <procdump+0xb8>
    if(p->state == UNUSED)
8010457a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010457d:	85 c0                	test   %eax,%eax
8010457f:	74 e7                	je     80104568 <procdump+0x28>
      state = "???";
80104581:	ba 18 7d 10 80       	mov    $0x80107d18,%edx
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104586:	83 f8 05             	cmp    $0x5,%eax
80104589:	77 11                	ja     8010459c <procdump+0x5c>
8010458b:	8b 14 85 78 7d 10 80 	mov    -0x7fef8288(,%eax,4),%edx
      state = "???";
80104592:	b8 18 7d 10 80       	mov    $0x80107d18,%eax
80104597:	85 d2                	test   %edx,%edx
80104599:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010459c:	53                   	push   %ebx
8010459d:	52                   	push   %edx
8010459e:	ff 73 a4             	push   -0x5c(%ebx)
801045a1:	68 1c 7d 10 80       	push   $0x80107d1c
801045a6:	e8 f5 c0 ff ff       	call   801006a0 <cprintf>
    if(p->state == SLEEPING){
801045ab:	83 c4 10             	add    $0x10,%esp
801045ae:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
801045b2:	75 a4                	jne    80104558 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
801045b4:	83 ec 08             	sub    $0x8,%esp
801045b7:	8d 45 c0             	lea    -0x40(%ebp),%eax
801045ba:	8d 7d c0             	lea    -0x40(%ebp),%edi
801045bd:	50                   	push   %eax
801045be:	8b 43 b0             	mov    -0x50(%ebx),%eax
801045c1:	8b 40 0c             	mov    0xc(%eax),%eax
801045c4:	83 c0 08             	add    $0x8,%eax
801045c7:	50                   	push   %eax
801045c8:	e8 83 01 00 00       	call   80104750 <getcallerpcs>
      for(i=0; i<10 && pc[i] != 0; i++)
801045cd:	83 c4 10             	add    $0x10,%esp
801045d0:	8b 17                	mov    (%edi),%edx
801045d2:	85 d2                	test   %edx,%edx
801045d4:	74 82                	je     80104558 <procdump+0x18>
        cprintf(" %p", pc[i]);
801045d6:	83 ec 08             	sub    $0x8,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
801045d9:	83 c7 04             	add    $0x4,%edi
        cprintf(" %p", pc[i]);
801045dc:	52                   	push   %edx
801045dd:	68 61 77 10 80       	push   $0x80107761
801045e2:	e8 b9 c0 ff ff       	call   801006a0 <cprintf>
      for(i=0; i<10 && pc[i] != 0; i++)
801045e7:	83 c4 10             	add    $0x10,%esp
801045ea:	39 fe                	cmp    %edi,%esi
801045ec:	75 e2                	jne    801045d0 <procdump+0x90>
801045ee:	e9 65 ff ff ff       	jmp    80104558 <procdump+0x18>
801045f3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045f7:	90                   	nop
  }
}
801045f8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801045fb:	5b                   	pop    %ebx
801045fc:	5e                   	pop    %esi
801045fd:	5f                   	pop    %edi
801045fe:	5d                   	pop    %ebp
801045ff:	c3                   	ret    

80104600 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80104600:	55                   	push   %ebp
80104601:	89 e5                	mov    %esp,%ebp
80104603:	53                   	push   %ebx
80104604:	83 ec 0c             	sub    $0xc,%esp
80104607:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
8010460a:	68 90 7d 10 80       	push   $0x80107d90
8010460f:	8d 43 04             	lea    0x4(%ebx),%eax
80104612:	50                   	push   %eax
80104613:	e8 18 01 00 00       	call   80104730 <initlock>
  lk->name = name;
80104618:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
8010461b:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
80104621:	83 c4 10             	add    $0x10,%esp
  lk->pid = 0;
80104624:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  lk->name = name;
8010462b:	89 43 38             	mov    %eax,0x38(%ebx)
}
8010462e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104631:	c9                   	leave  
80104632:	c3                   	ret    
80104633:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010463a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104640 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104640:	55                   	push   %ebp
80104641:	89 e5                	mov    %esp,%ebp
80104643:	56                   	push   %esi
80104644:	53                   	push   %ebx
80104645:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104648:	8d 73 04             	lea    0x4(%ebx),%esi
8010464b:	83 ec 0c             	sub    $0xc,%esp
8010464e:	56                   	push   %esi
8010464f:	e8 ac 02 00 00       	call   80104900 <acquire>
  while (lk->locked) {
80104654:	8b 13                	mov    (%ebx),%edx
80104656:	83 c4 10             	add    $0x10,%esp
80104659:	85 d2                	test   %edx,%edx
8010465b:	74 16                	je     80104673 <acquiresleep+0x33>
8010465d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104660:	83 ec 08             	sub    $0x8,%esp
80104663:	56                   	push   %esi
80104664:	53                   	push   %ebx
80104665:	e8 36 fd ff ff       	call   801043a0 <sleep>
  while (lk->locked) {
8010466a:	8b 03                	mov    (%ebx),%eax
8010466c:	83 c4 10             	add    $0x10,%esp
8010466f:	85 c0                	test   %eax,%eax
80104671:	75 ed                	jne    80104660 <acquiresleep+0x20>
  }
  lk->locked = 1;
80104673:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104679:	e8 e2 f5 ff ff       	call   80103c60 <myproc>
8010467e:	8b 40 10             	mov    0x10(%eax),%eax
80104681:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104684:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104687:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010468a:	5b                   	pop    %ebx
8010468b:	5e                   	pop    %esi
8010468c:	5d                   	pop    %ebp
  release(&lk->lk);
8010468d:	e9 0e 02 00 00       	jmp    801048a0 <release>
80104692:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104699:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801046a0 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
801046a0:	55                   	push   %ebp
801046a1:	89 e5                	mov    %esp,%ebp
801046a3:	56                   	push   %esi
801046a4:	53                   	push   %ebx
801046a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
801046a8:	8d 73 04             	lea    0x4(%ebx),%esi
801046ab:	83 ec 0c             	sub    $0xc,%esp
801046ae:	56                   	push   %esi
801046af:	e8 4c 02 00 00       	call   80104900 <acquire>
  lk->locked = 0;
801046b4:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
801046ba:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
801046c1:	89 1c 24             	mov    %ebx,(%esp)
801046c4:	e8 97 fd ff ff       	call   80104460 <wakeup>
  release(&lk->lk);
801046c9:	89 75 08             	mov    %esi,0x8(%ebp)
801046cc:	83 c4 10             	add    $0x10,%esp
}
801046cf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801046d2:	5b                   	pop    %ebx
801046d3:	5e                   	pop    %esi
801046d4:	5d                   	pop    %ebp
  release(&lk->lk);
801046d5:	e9 c6 01 00 00       	jmp    801048a0 <release>
801046da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801046e0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
801046e0:	55                   	push   %ebp
801046e1:	89 e5                	mov    %esp,%ebp
801046e3:	57                   	push   %edi
801046e4:	31 ff                	xor    %edi,%edi
801046e6:	56                   	push   %esi
801046e7:	53                   	push   %ebx
801046e8:	83 ec 18             	sub    $0x18,%esp
801046eb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801046ee:	8d 73 04             	lea    0x4(%ebx),%esi
801046f1:	56                   	push   %esi
801046f2:	e8 09 02 00 00       	call   80104900 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801046f7:	8b 03                	mov    (%ebx),%eax
801046f9:	83 c4 10             	add    $0x10,%esp
801046fc:	85 c0                	test   %eax,%eax
801046fe:	75 18                	jne    80104718 <holdingsleep+0x38>
  release(&lk->lk);
80104700:	83 ec 0c             	sub    $0xc,%esp
80104703:	56                   	push   %esi
80104704:	e8 97 01 00 00       	call   801048a0 <release>
  return r;
}
80104709:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010470c:	89 f8                	mov    %edi,%eax
8010470e:	5b                   	pop    %ebx
8010470f:	5e                   	pop    %esi
80104710:	5f                   	pop    %edi
80104711:	5d                   	pop    %ebp
80104712:	c3                   	ret    
80104713:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104717:	90                   	nop
  r = lk->locked && (lk->pid == myproc()->pid);
80104718:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
8010471b:	e8 40 f5 ff ff       	call   80103c60 <myproc>
80104720:	39 58 10             	cmp    %ebx,0x10(%eax)
80104723:	0f 94 c0             	sete   %al
80104726:	0f b6 c0             	movzbl %al,%eax
80104729:	89 c7                	mov    %eax,%edi
8010472b:	eb d3                	jmp    80104700 <holdingsleep+0x20>
8010472d:	66 90                	xchg   %ax,%ax
8010472f:	90                   	nop

80104730 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
80104730:	55                   	push   %ebp
80104731:	89 e5                	mov    %esp,%ebp
80104733:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
80104736:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
80104739:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  lk->name = name;
8010473f:	89 50 04             	mov    %edx,0x4(%eax)
  lk->cpu = 0;
80104742:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010474f:	90                   	nop

80104750 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104750:	55                   	push   %ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104751:	31 d2                	xor    %edx,%edx
{
80104753:	89 e5                	mov    %esp,%ebp
80104755:	53                   	push   %ebx
  ebp = (uint*)v - 2;
80104756:	8b 45 08             	mov    0x8(%ebp),%eax
{
80104759:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  ebp = (uint*)v - 2;
8010475c:	83 e8 08             	sub    $0x8,%eax
  for(i = 0; i < 10; i++){
8010475f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104760:	8d 98 00 00 00 80    	lea    -0x80000000(%eax),%ebx
80104766:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010476c:	77 1a                	ja     80104788 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010476e:	8b 58 04             	mov    0x4(%eax),%ebx
80104771:	89 1c 91             	mov    %ebx,(%ecx,%edx,4)
  for(i = 0; i < 10; i++){
80104774:	83 c2 01             	add    $0x1,%edx
    ebp = (uint*)ebp[0]; // saved %ebp
80104777:	8b 00                	mov    (%eax),%eax
  for(i = 0; i < 10; i++){
80104779:	83 fa 0a             	cmp    $0xa,%edx
8010477c:	75 e2                	jne    80104760 <getcallerpcs+0x10>
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010477e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104781:	c9                   	leave  
80104782:	c3                   	ret    
80104783:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104787:	90                   	nop
  for(; i < 10; i++)
80104788:	8d 04 91             	lea    (%ecx,%edx,4),%eax
8010478b:	8d 51 28             	lea    0x28(%ecx),%edx
8010478e:	66 90                	xchg   %ax,%ax
    pcs[i] = 0;
80104790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104796:	83 c0 04             	add    $0x4,%eax
80104799:	39 d0                	cmp    %edx,%eax
8010479b:	75 f3                	jne    80104790 <getcallerpcs+0x40>
}
8010479d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047a0:	c9                   	leave  
801047a1:	c3                   	ret    
801047a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801047b0 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	53                   	push   %ebx
801047b4:	83 ec 04             	sub    $0x4,%esp
801047b7:	9c                   	pushf  
801047b8:	5b                   	pop    %ebx
  asm volatile("cli");
801047b9:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
801047ba:	e8 21 f4 ff ff       	call   80103be0 <mycpu>
801047bf:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
801047c5:	85 c0                	test   %eax,%eax
801047c7:	74 17                	je     801047e0 <pushcli+0x30>
    mycpu()->intena = eflags & FL_IF;
  mycpu()->ncli += 1;
801047c9:	e8 12 f4 ff ff       	call   80103be0 <mycpu>
801047ce:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801047d5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801047d8:	c9                   	leave  
801047d9:	c3                   	ret    
801047da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    mycpu()->intena = eflags & FL_IF;
801047e0:	e8 fb f3 ff ff       	call   80103be0 <mycpu>
801047e5:	81 e3 00 02 00 00    	and    $0x200,%ebx
801047eb:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
801047f1:	eb d6                	jmp    801047c9 <pushcli+0x19>
801047f3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801047fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104800 <popcli>:

void
popcli(void)
{
80104800:	55                   	push   %ebp
80104801:	89 e5                	mov    %esp,%ebp
80104803:	83 ec 08             	sub    $0x8,%esp
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104806:	9c                   	pushf  
80104807:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104808:	f6 c4 02             	test   $0x2,%ah
8010480b:	75 35                	jne    80104842 <popcli+0x42>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010480d:	e8 ce f3 ff ff       	call   80103be0 <mycpu>
80104812:	83 a8 a4 00 00 00 01 	subl   $0x1,0xa4(%eax)
80104819:	78 34                	js     8010484f <popcli+0x4f>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
8010481b:	e8 c0 f3 ff ff       	call   80103be0 <mycpu>
80104820:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
80104826:	85 d2                	test   %edx,%edx
80104828:	74 06                	je     80104830 <popcli+0x30>
    sti();
}
8010482a:	c9                   	leave  
8010482b:	c3                   	ret    
8010482c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(mycpu()->ncli == 0 && mycpu()->intena)
80104830:	e8 ab f3 ff ff       	call   80103be0 <mycpu>
80104835:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
8010483b:	85 c0                	test   %eax,%eax
8010483d:	74 eb                	je     8010482a <popcli+0x2a>
  asm volatile("sti");
8010483f:	fb                   	sti    
}
80104840:	c9                   	leave  
80104841:	c3                   	ret    
    panic("popcli - interruptible");
80104842:	83 ec 0c             	sub    $0xc,%esp
80104845:	68 9b 7d 10 80       	push   $0x80107d9b
8010484a:	e8 31 bb ff ff       	call   80100380 <panic>
    panic("popcli");
8010484f:	83 ec 0c             	sub    $0xc,%esp
80104852:	68 b2 7d 10 80       	push   $0x80107db2
80104857:	e8 24 bb ff ff       	call   80100380 <panic>
8010485c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104860 <holding>:
{
80104860:	55                   	push   %ebp
80104861:	89 e5                	mov    %esp,%ebp
80104863:	56                   	push   %esi
80104864:	53                   	push   %ebx
80104865:	8b 75 08             	mov    0x8(%ebp),%esi
80104868:	31 db                	xor    %ebx,%ebx
  pushcli();
8010486a:	e8 41 ff ff ff       	call   801047b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010486f:	8b 06                	mov    (%esi),%eax
80104871:	85 c0                	test   %eax,%eax
80104873:	75 0b                	jne    80104880 <holding+0x20>
  popcli();
80104875:	e8 86 ff ff ff       	call   80104800 <popcli>
}
8010487a:	89 d8                	mov    %ebx,%eax
8010487c:	5b                   	pop    %ebx
8010487d:	5e                   	pop    %esi
8010487e:	5d                   	pop    %ebp
8010487f:	c3                   	ret    
  r = lock->locked && lock->cpu == mycpu();
80104880:	8b 5e 08             	mov    0x8(%esi),%ebx
80104883:	e8 58 f3 ff ff       	call   80103be0 <mycpu>
80104888:	39 c3                	cmp    %eax,%ebx
8010488a:	0f 94 c3             	sete   %bl
  popcli();
8010488d:	e8 6e ff ff ff       	call   80104800 <popcli>
  r = lock->locked && lock->cpu == mycpu();
80104892:	0f b6 db             	movzbl %bl,%ebx
}
80104895:	89 d8                	mov    %ebx,%eax
80104897:	5b                   	pop    %ebx
80104898:	5e                   	pop    %esi
80104899:	5d                   	pop    %ebp
8010489a:	c3                   	ret    
8010489b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010489f:	90                   	nop

801048a0 <release>:
{
801048a0:	55                   	push   %ebp
801048a1:	89 e5                	mov    %esp,%ebp
801048a3:	56                   	push   %esi
801048a4:	53                   	push   %ebx
801048a5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
801048a8:	e8 03 ff ff ff       	call   801047b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801048ad:	8b 03                	mov    (%ebx),%eax
801048af:	85 c0                	test   %eax,%eax
801048b1:	75 15                	jne    801048c8 <release+0x28>
  popcli();
801048b3:	e8 48 ff ff ff       	call   80104800 <popcli>
    panic("release");
801048b8:	83 ec 0c             	sub    $0xc,%esp
801048bb:	68 b9 7d 10 80       	push   $0x80107db9
801048c0:	e8 bb ba ff ff       	call   80100380 <panic>
801048c5:	8d 76 00             	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
801048c8:	8b 73 08             	mov    0x8(%ebx),%esi
801048cb:	e8 10 f3 ff ff       	call   80103be0 <mycpu>
801048d0:	39 c6                	cmp    %eax,%esi
801048d2:	75 df                	jne    801048b3 <release+0x13>
  popcli();
801048d4:	e8 27 ff ff ff       	call   80104800 <popcli>
  lk->pcs[0] = 0;
801048d9:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801048e0:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  __sync_synchronize();
801048e7:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801048ec:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
}
801048f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048f5:	5b                   	pop    %ebx
801048f6:	5e                   	pop    %esi
801048f7:	5d                   	pop    %ebp
  popcli();
801048f8:	e9 03 ff ff ff       	jmp    80104800 <popcli>
801048fd:	8d 76 00             	lea    0x0(%esi),%esi

80104900 <acquire>:
{
80104900:	55                   	push   %ebp
80104901:	89 e5                	mov    %esp,%ebp
80104903:	53                   	push   %ebx
80104904:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104907:	e8 a4 fe ff ff       	call   801047b0 <pushcli>
  if(holding(lk))
8010490c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pushcli();
8010490f:	e8 9c fe ff ff       	call   801047b0 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
80104914:	8b 03                	mov    (%ebx),%eax
80104916:	85 c0                	test   %eax,%eax
80104918:	75 7e                	jne    80104998 <acquire+0x98>
  popcli();
8010491a:	e8 e1 fe ff ff       	call   80104800 <popcli>
  asm volatile("lock; xchgl %0, %1" :
8010491f:	b9 01 00 00 00       	mov    $0x1,%ecx
80104924:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(xchg(&lk->locked, 1) != 0)
80104928:	8b 55 08             	mov    0x8(%ebp),%edx
8010492b:	89 c8                	mov    %ecx,%eax
8010492d:	f0 87 02             	lock xchg %eax,(%edx)
80104930:	85 c0                	test   %eax,%eax
80104932:	75 f4                	jne    80104928 <acquire+0x28>
  __sync_synchronize();
80104934:	f0 83 0c 24 00       	lock orl $0x0,(%esp)
  lk->cpu = mycpu();
80104939:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010493c:	e8 9f f2 ff ff       	call   80103be0 <mycpu>
  getcallerpcs(&lk, lk->pcs);
80104941:	8b 4d 08             	mov    0x8(%ebp),%ecx
  ebp = (uint*)v - 2;
80104944:	89 ea                	mov    %ebp,%edx
  lk->cpu = mycpu();
80104946:	89 43 08             	mov    %eax,0x8(%ebx)
  for(i = 0; i < 10; i++){
80104949:	31 c0                	xor    %eax,%eax
8010494b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010494f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104950:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104956:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010495c:	77 1a                	ja     80104978 <acquire+0x78>
    pcs[i] = ebp[1];     // saved %eip
8010495e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104961:	89 5c 81 0c          	mov    %ebx,0xc(%ecx,%eax,4)
  for(i = 0; i < 10; i++){
80104965:	83 c0 01             	add    $0x1,%eax
    ebp = (uint*)ebp[0]; // saved %ebp
80104968:	8b 12                	mov    (%edx),%edx
  for(i = 0; i < 10; i++){
8010496a:	83 f8 0a             	cmp    $0xa,%eax
8010496d:	75 e1                	jne    80104950 <acquire+0x50>
}
8010496f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104972:	c9                   	leave  
80104973:	c3                   	ret    
80104974:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(; i < 10; i++)
80104978:	8d 44 81 0c          	lea    0xc(%ecx,%eax,4),%eax
8010497c:	8d 51 34             	lea    0x34(%ecx),%edx
8010497f:	90                   	nop
    pcs[i] = 0;
80104980:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  for(; i < 10; i++)
80104986:	83 c0 04             	add    $0x4,%eax
80104989:	39 c2                	cmp    %eax,%edx
8010498b:	75 f3                	jne    80104980 <acquire+0x80>
}
8010498d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104990:	c9                   	leave  
80104991:	c3                   	ret    
80104992:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  r = lock->locked && lock->cpu == mycpu();
80104998:	8b 5b 08             	mov    0x8(%ebx),%ebx
8010499b:	e8 40 f2 ff ff       	call   80103be0 <mycpu>
801049a0:	39 c3                	cmp    %eax,%ebx
801049a2:	0f 85 72 ff ff ff    	jne    8010491a <acquire+0x1a>
  popcli();
801049a8:	e8 53 fe ff ff       	call   80104800 <popcli>
    panic("acquire");
801049ad:	83 ec 0c             	sub    $0xc,%esp
801049b0:	68 c1 7d 10 80       	push   $0x80107dc1
801049b5:	e8 c6 b9 ff ff       	call   80100380 <panic>
801049ba:	66 90                	xchg   %ax,%ax
801049bc:	66 90                	xchg   %ax,%ax
801049be:	66 90                	xchg   %ax,%ax

801049c0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801049c0:	55                   	push   %ebp
801049c1:	89 e5                	mov    %esp,%ebp
801049c3:	57                   	push   %edi
801049c4:	8b 55 08             	mov    0x8(%ebp),%edx
801049c7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801049ca:	53                   	push   %ebx
801049cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  if ((int)dst%4 == 0 && n%4 == 0){
801049ce:	89 d7                	mov    %edx,%edi
801049d0:	09 cf                	or     %ecx,%edi
801049d2:	83 e7 03             	and    $0x3,%edi
801049d5:	75 29                	jne    80104a00 <memset+0x40>
    c &= 0xFF;
801049d7:	0f b6 f8             	movzbl %al,%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
801049da:	c1 e0 18             	shl    $0x18,%eax
801049dd:	89 fb                	mov    %edi,%ebx
801049df:	c1 e9 02             	shr    $0x2,%ecx
801049e2:	c1 e3 10             	shl    $0x10,%ebx
801049e5:	09 d8                	or     %ebx,%eax
801049e7:	09 f8                	or     %edi,%eax
801049e9:	c1 e7 08             	shl    $0x8,%edi
801049ec:	09 f8                	or     %edi,%eax
  asm volatile("cld; rep stosl" :
801049ee:	89 d7                	mov    %edx,%edi
801049f0:	fc                   	cld    
801049f1:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
801049f3:	5b                   	pop    %ebx
801049f4:	89 d0                	mov    %edx,%eax
801049f6:	5f                   	pop    %edi
801049f7:	5d                   	pop    %ebp
801049f8:	c3                   	ret    
801049f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  asm volatile("cld; rep stosb" :
80104a00:	89 d7                	mov    %edx,%edi
80104a02:	fc                   	cld    
80104a03:	f3 aa                	rep stos %al,%es:(%edi)
80104a05:	5b                   	pop    %ebx
80104a06:	89 d0                	mov    %edx,%eax
80104a08:	5f                   	pop    %edi
80104a09:	5d                   	pop    %ebp
80104a0a:	c3                   	ret    
80104a0b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a0f:	90                   	nop

80104a10 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104a10:	55                   	push   %ebp
80104a11:	89 e5                	mov    %esp,%ebp
80104a13:	56                   	push   %esi
80104a14:	8b 75 10             	mov    0x10(%ebp),%esi
80104a17:	8b 55 08             	mov    0x8(%ebp),%edx
80104a1a:	53                   	push   %ebx
80104a1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104a1e:	85 f6                	test   %esi,%esi
80104a20:	74 2e                	je     80104a50 <memcmp+0x40>
80104a22:	01 c6                	add    %eax,%esi
80104a24:	eb 14                	jmp    80104a3a <memcmp+0x2a>
80104a26:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a2d:	8d 76 00             	lea    0x0(%esi),%esi
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
80104a30:	83 c0 01             	add    $0x1,%eax
80104a33:	83 c2 01             	add    $0x1,%edx
  while(n-- > 0){
80104a36:	39 f0                	cmp    %esi,%eax
80104a38:	74 16                	je     80104a50 <memcmp+0x40>
    if(*s1 != *s2)
80104a3a:	0f b6 0a             	movzbl (%edx),%ecx
80104a3d:	0f b6 18             	movzbl (%eax),%ebx
80104a40:	38 d9                	cmp    %bl,%cl
80104a42:	74 ec                	je     80104a30 <memcmp+0x20>
      return *s1 - *s2;
80104a44:	0f b6 c1             	movzbl %cl,%eax
80104a47:	29 d8                	sub    %ebx,%eax
  }

  return 0;
}
80104a49:	5b                   	pop    %ebx
80104a4a:	5e                   	pop    %esi
80104a4b:	5d                   	pop    %ebp
80104a4c:	c3                   	ret    
80104a4d:	8d 76 00             	lea    0x0(%esi),%esi
80104a50:	5b                   	pop    %ebx
  return 0;
80104a51:	31 c0                	xor    %eax,%eax
}
80104a53:	5e                   	pop    %esi
80104a54:	5d                   	pop    %ebp
80104a55:	c3                   	ret    
80104a56:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104a5d:	8d 76 00             	lea    0x0(%esi),%esi

80104a60 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	57                   	push   %edi
80104a64:	8b 55 08             	mov    0x8(%ebp),%edx
80104a67:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104a6a:	56                   	push   %esi
80104a6b:	8b 75 0c             	mov    0xc(%ebp),%esi
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
80104a6e:	39 d6                	cmp    %edx,%esi
80104a70:	73 26                	jae    80104a98 <memmove+0x38>
80104a72:	8d 3c 0e             	lea    (%esi,%ecx,1),%edi
80104a75:	39 fa                	cmp    %edi,%edx
80104a77:	73 1f                	jae    80104a98 <memmove+0x38>
80104a79:	8d 41 ff             	lea    -0x1(%ecx),%eax
    s += n;
    d += n;
    while(n-- > 0)
80104a7c:	85 c9                	test   %ecx,%ecx
80104a7e:	74 0c                	je     80104a8c <memmove+0x2c>
      *--d = *--s;
80104a80:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
80104a84:	88 0c 02             	mov    %cl,(%edx,%eax,1)
    while(n-- > 0)
80104a87:	83 e8 01             	sub    $0x1,%eax
80104a8a:	73 f4                	jae    80104a80 <memmove+0x20>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104a8c:	5e                   	pop    %esi
80104a8d:	89 d0                	mov    %edx,%eax
80104a8f:	5f                   	pop    %edi
80104a90:	5d                   	pop    %ebp
80104a91:	c3                   	ret    
80104a92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    while(n-- > 0)
80104a98:	8d 04 0e             	lea    (%esi,%ecx,1),%eax
80104a9b:	89 d7                	mov    %edx,%edi
80104a9d:	85 c9                	test   %ecx,%ecx
80104a9f:	74 eb                	je     80104a8c <memmove+0x2c>
80104aa1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      *d++ = *s++;
80104aa8:	a4                   	movsb  %ds:(%esi),%es:(%edi)
    while(n-- > 0)
80104aa9:	39 c6                	cmp    %eax,%esi
80104aab:	75 fb                	jne    80104aa8 <memmove+0x48>
}
80104aad:	5e                   	pop    %esi
80104aae:	89 d0                	mov    %edx,%eax
80104ab0:	5f                   	pop    %edi
80104ab1:	5d                   	pop    %ebp
80104ab2:	c3                   	ret    
80104ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104ac0 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104ac0:	eb 9e                	jmp    80104a60 <memmove>
80104ac2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ac9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104ad0 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104ad0:	55                   	push   %ebp
80104ad1:	89 e5                	mov    %esp,%ebp
80104ad3:	56                   	push   %esi
80104ad4:	8b 75 10             	mov    0x10(%ebp),%esi
80104ad7:	8b 4d 08             	mov    0x8(%ebp),%ecx
80104ada:	53                   	push   %ebx
80104adb:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(n > 0 && *p && *p == *q)
80104ade:	85 f6                	test   %esi,%esi
80104ae0:	74 2e                	je     80104b10 <strncmp+0x40>
80104ae2:	01 d6                	add    %edx,%esi
80104ae4:	eb 18                	jmp    80104afe <strncmp+0x2e>
80104ae6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104aed:	8d 76 00             	lea    0x0(%esi),%esi
80104af0:	38 d8                	cmp    %bl,%al
80104af2:	75 14                	jne    80104b08 <strncmp+0x38>
    n--, p++, q++;
80104af4:	83 c2 01             	add    $0x1,%edx
80104af7:	83 c1 01             	add    $0x1,%ecx
  while(n > 0 && *p && *p == *q)
80104afa:	39 f2                	cmp    %esi,%edx
80104afc:	74 12                	je     80104b10 <strncmp+0x40>
80104afe:	0f b6 01             	movzbl (%ecx),%eax
80104b01:	0f b6 1a             	movzbl (%edx),%ebx
80104b04:	84 c0                	test   %al,%al
80104b06:	75 e8                	jne    80104af0 <strncmp+0x20>
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104b08:	29 d8                	sub    %ebx,%eax
}
80104b0a:	5b                   	pop    %ebx
80104b0b:	5e                   	pop    %esi
80104b0c:	5d                   	pop    %ebp
80104b0d:	c3                   	ret    
80104b0e:	66 90                	xchg   %ax,%ax
80104b10:	5b                   	pop    %ebx
    return 0;
80104b11:	31 c0                	xor    %eax,%eax
}
80104b13:	5e                   	pop    %esi
80104b14:	5d                   	pop    %ebp
80104b15:	c3                   	ret    
80104b16:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b1d:	8d 76 00             	lea    0x0(%esi),%esi

80104b20 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
80104b20:	55                   	push   %ebp
80104b21:	89 e5                	mov    %esp,%ebp
80104b23:	57                   	push   %edi
80104b24:	56                   	push   %esi
80104b25:	8b 75 08             	mov    0x8(%ebp),%esi
80104b28:	53                   	push   %ebx
80104b29:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
80104b2c:	89 f0                	mov    %esi,%eax
80104b2e:	eb 15                	jmp    80104b45 <strncpy+0x25>
80104b30:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
80104b34:	8b 7d 0c             	mov    0xc(%ebp),%edi
80104b37:	83 c0 01             	add    $0x1,%eax
80104b3a:	0f b6 57 ff          	movzbl -0x1(%edi),%edx
80104b3e:	88 50 ff             	mov    %dl,-0x1(%eax)
80104b41:	84 d2                	test   %dl,%dl
80104b43:	74 09                	je     80104b4e <strncpy+0x2e>
80104b45:	89 cb                	mov    %ecx,%ebx
80104b47:	83 e9 01             	sub    $0x1,%ecx
80104b4a:	85 db                	test   %ebx,%ebx
80104b4c:	7f e2                	jg     80104b30 <strncpy+0x10>
    ;
  while(n-- > 0)
80104b4e:	89 c2                	mov    %eax,%edx
80104b50:	85 c9                	test   %ecx,%ecx
80104b52:	7e 17                	jle    80104b6b <strncpy+0x4b>
80104b54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104b58:	83 c2 01             	add    $0x1,%edx
80104b5b:	89 c1                	mov    %eax,%ecx
80104b5d:	c6 42 ff 00          	movb   $0x0,-0x1(%edx)
  while(n-- > 0)
80104b61:	29 d1                	sub    %edx,%ecx
80104b63:	8d 4c 0b ff          	lea    -0x1(%ebx,%ecx,1),%ecx
80104b67:	85 c9                	test   %ecx,%ecx
80104b69:	7f ed                	jg     80104b58 <strncpy+0x38>
  return os;
}
80104b6b:	5b                   	pop    %ebx
80104b6c:	89 f0                	mov    %esi,%eax
80104b6e:	5e                   	pop    %esi
80104b6f:	5f                   	pop    %edi
80104b70:	5d                   	pop    %ebp
80104b71:	c3                   	ret    
80104b72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104b80 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104b80:	55                   	push   %ebp
80104b81:	89 e5                	mov    %esp,%ebp
80104b83:	56                   	push   %esi
80104b84:	8b 55 10             	mov    0x10(%ebp),%edx
80104b87:	8b 75 08             	mov    0x8(%ebp),%esi
80104b8a:	53                   	push   %ebx
80104b8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *os;

  os = s;
  if(n <= 0)
80104b8e:	85 d2                	test   %edx,%edx
80104b90:	7e 25                	jle    80104bb7 <safestrcpy+0x37>
80104b92:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
80104b96:	89 f2                	mov    %esi,%edx
80104b98:	eb 16                	jmp    80104bb0 <safestrcpy+0x30>
80104b9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104ba0:	0f b6 08             	movzbl (%eax),%ecx
80104ba3:	83 c0 01             	add    $0x1,%eax
80104ba6:	83 c2 01             	add    $0x1,%edx
80104ba9:	88 4a ff             	mov    %cl,-0x1(%edx)
80104bac:	84 c9                	test   %cl,%cl
80104bae:	74 04                	je     80104bb4 <safestrcpy+0x34>
80104bb0:	39 d8                	cmp    %ebx,%eax
80104bb2:	75 ec                	jne    80104ba0 <safestrcpy+0x20>
    ;
  *s = 0;
80104bb4:	c6 02 00             	movb   $0x0,(%edx)
  return os;
}
80104bb7:	89 f0                	mov    %esi,%eax
80104bb9:	5b                   	pop    %ebx
80104bba:	5e                   	pop    %esi
80104bbb:	5d                   	pop    %ebp
80104bbc:	c3                   	ret    
80104bbd:	8d 76 00             	lea    0x0(%esi),%esi

80104bc0 <strlen>:

int
strlen(const char *s)
{
80104bc0:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104bc1:	31 c0                	xor    %eax,%eax
{
80104bc3:	89 e5                	mov    %esp,%ebp
80104bc5:	8b 55 08             	mov    0x8(%ebp),%edx
  for(n = 0; s[n]; n++)
80104bc8:	80 3a 00             	cmpb   $0x0,(%edx)
80104bcb:	74 0c                	je     80104bd9 <strlen+0x19>
80104bcd:	8d 76 00             	lea    0x0(%esi),%esi
80104bd0:	83 c0 01             	add    $0x1,%eax
80104bd3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104bd7:	75 f7                	jne    80104bd0 <strlen+0x10>
    ;
  return n;
}
80104bd9:	5d                   	pop    %ebp
80104bda:	c3                   	ret    

80104bdb <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
80104bdb:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
80104bdf:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104be3:	55                   	push   %ebp
  pushl %ebx
80104be4:	53                   	push   %ebx
  pushl %esi
80104be5:	56                   	push   %esi
  pushl %edi
80104be6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104be7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104be9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
80104beb:	5f                   	pop    %edi
  popl %esi
80104bec:	5e                   	pop    %esi
  popl %ebx
80104bed:	5b                   	pop    %ebx
  popl %ebp
80104bee:	5d                   	pop    %ebp
  ret
80104bef:	c3                   	ret    

80104bf0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104bf0:	55                   	push   %ebp
80104bf1:	89 e5                	mov    %esp,%ebp
80104bf3:	53                   	push   %ebx
80104bf4:	83 ec 04             	sub    $0x4,%esp
80104bf7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
80104bfa:	e8 61 f0 ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104bff:	8b 00                	mov    (%eax),%eax
80104c01:	39 d8                	cmp    %ebx,%eax
80104c03:	76 1b                	jbe    80104c20 <fetchint+0x30>
80104c05:	8d 53 04             	lea    0x4(%ebx),%edx
80104c08:	39 d0                	cmp    %edx,%eax
80104c0a:	72 14                	jb     80104c20 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
80104c0c:	8b 45 0c             	mov    0xc(%ebp),%eax
80104c0f:	8b 13                	mov    (%ebx),%edx
80104c11:	89 10                	mov    %edx,(%eax)
  return 0;
80104c13:	31 c0                	xor    %eax,%eax
}
80104c15:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c18:	c9                   	leave  
80104c19:	c3                   	ret    
80104c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80104c20:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104c25:	eb ee                	jmp    80104c15 <fetchint+0x25>
80104c27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104c2e:	66 90                	xchg   %ax,%ax

80104c30 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104c30:	55                   	push   %ebp
80104c31:	89 e5                	mov    %esp,%ebp
80104c33:	53                   	push   %ebx
80104c34:	83 ec 04             	sub    $0x4,%esp
80104c37:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
80104c3a:	e8 21 f0 ff ff       	call   80103c60 <myproc>

  if(addr >= curproc->sz)
80104c3f:	39 18                	cmp    %ebx,(%eax)
80104c41:	76 2d                	jbe    80104c70 <fetchstr+0x40>
    return -1;
  *pp = (char*)addr;
80104c43:	8b 55 0c             	mov    0xc(%ebp),%edx
80104c46:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104c48:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104c4a:	39 d3                	cmp    %edx,%ebx
80104c4c:	73 22                	jae    80104c70 <fetchstr+0x40>
80104c4e:	89 d8                	mov    %ebx,%eax
80104c50:	eb 0d                	jmp    80104c5f <fetchstr+0x2f>
80104c52:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104c58:	83 c0 01             	add    $0x1,%eax
80104c5b:	39 c2                	cmp    %eax,%edx
80104c5d:	76 11                	jbe    80104c70 <fetchstr+0x40>
    if(*s == 0)
80104c5f:	80 38 00             	cmpb   $0x0,(%eax)
80104c62:	75 f4                	jne    80104c58 <fetchstr+0x28>
      return s - *pp;
80104c64:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104c66:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104c69:	c9                   	leave  
80104c6a:	c3                   	ret    
80104c6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104c6f:	90                   	nop
80104c70:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    return -1;
80104c73:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c78:	c9                   	leave  
80104c79:	c3                   	ret    
80104c7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104c80 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104c80:	55                   	push   %ebp
80104c81:	89 e5                	mov    %esp,%ebp
80104c83:	56                   	push   %esi
80104c84:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c85:	e8 d6 ef ff ff       	call   80103c60 <myproc>
80104c8a:	8b 55 08             	mov    0x8(%ebp),%edx
80104c8d:	8b 40 18             	mov    0x18(%eax),%eax
80104c90:	8b 40 44             	mov    0x44(%eax),%eax
80104c93:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104c96:	e8 c5 ef ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104c9b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104c9e:	8b 00                	mov    (%eax),%eax
80104ca0:	39 c6                	cmp    %eax,%esi
80104ca2:	73 1c                	jae    80104cc0 <argint+0x40>
80104ca4:	8d 53 08             	lea    0x8(%ebx),%edx
80104ca7:	39 d0                	cmp    %edx,%eax
80104ca9:	72 15                	jb     80104cc0 <argint+0x40>
  *ip = *(int*)(addr);
80104cab:	8b 45 0c             	mov    0xc(%ebp),%eax
80104cae:	8b 53 04             	mov    0x4(%ebx),%edx
80104cb1:	89 10                	mov    %edx,(%eax)
  return 0;
80104cb3:	31 c0                	xor    %eax,%eax
}
80104cb5:	5b                   	pop    %ebx
80104cb6:	5e                   	pop    %esi
80104cb7:	5d                   	pop    %ebp
80104cb8:	c3                   	ret    
80104cb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80104cc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cc5:	eb ee                	jmp    80104cb5 <argint+0x35>
80104cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104cce:	66 90                	xchg   %ax,%ax

80104cd0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104cd0:	55                   	push   %ebp
80104cd1:	89 e5                	mov    %esp,%ebp
80104cd3:	57                   	push   %edi
80104cd4:	56                   	push   %esi
80104cd5:	53                   	push   %ebx
80104cd6:	83 ec 0c             	sub    $0xc,%esp
  int i;
  struct proc *curproc = myproc();
80104cd9:	e8 82 ef ff ff       	call   80103c60 <myproc>
80104cde:	89 c6                	mov    %eax,%esi
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104ce0:	e8 7b ef ff ff       	call   80103c60 <myproc>
80104ce5:	8b 55 08             	mov    0x8(%ebp),%edx
80104ce8:	8b 40 18             	mov    0x18(%eax),%eax
80104ceb:	8b 40 44             	mov    0x44(%eax),%eax
80104cee:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104cf1:	e8 6a ef ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104cf6:	8d 7b 04             	lea    0x4(%ebx),%edi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104cf9:	8b 00                	mov    (%eax),%eax
80104cfb:	39 c7                	cmp    %eax,%edi
80104cfd:	73 31                	jae    80104d30 <argptr+0x60>
80104cff:	8d 4b 08             	lea    0x8(%ebx),%ecx
80104d02:	39 c8                	cmp    %ecx,%eax
80104d04:	72 2a                	jb     80104d30 <argptr+0x60>
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d06:	8b 55 10             	mov    0x10(%ebp),%edx
  *ip = *(int*)(addr);
80104d09:	8b 43 04             	mov    0x4(%ebx),%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104d0c:	85 d2                	test   %edx,%edx
80104d0e:	78 20                	js     80104d30 <argptr+0x60>
80104d10:	8b 16                	mov    (%esi),%edx
80104d12:	39 c2                	cmp    %eax,%edx
80104d14:	76 1a                	jbe    80104d30 <argptr+0x60>
80104d16:	8b 5d 10             	mov    0x10(%ebp),%ebx
80104d19:	01 c3                	add    %eax,%ebx
80104d1b:	39 da                	cmp    %ebx,%edx
80104d1d:	72 11                	jb     80104d30 <argptr+0x60>
    return -1;
  *pp = (char*)i;
80104d1f:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d22:	89 02                	mov    %eax,(%edx)
  return 0;
80104d24:	31 c0                	xor    %eax,%eax
}
80104d26:	83 c4 0c             	add    $0xc,%esp
80104d29:	5b                   	pop    %ebx
80104d2a:	5e                   	pop    %esi
80104d2b:	5f                   	pop    %edi
80104d2c:	5d                   	pop    %ebp
80104d2d:	c3                   	ret    
80104d2e:	66 90                	xchg   %ax,%ax
    return -1;
80104d30:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104d35:	eb ef                	jmp    80104d26 <argptr+0x56>
80104d37:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d3e:	66 90                	xchg   %ax,%ax

80104d40 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104d40:	55                   	push   %ebp
80104d41:	89 e5                	mov    %esp,%ebp
80104d43:	56                   	push   %esi
80104d44:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d45:	e8 16 ef ff ff       	call   80103c60 <myproc>
80104d4a:	8b 55 08             	mov    0x8(%ebp),%edx
80104d4d:	8b 40 18             	mov    0x18(%eax),%eax
80104d50:	8b 40 44             	mov    0x44(%eax),%eax
80104d53:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
  struct proc *curproc = myproc();
80104d56:	e8 05 ef ff ff       	call   80103c60 <myproc>
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104d5b:	8d 73 04             	lea    0x4(%ebx),%esi
  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104d5e:	8b 00                	mov    (%eax),%eax
80104d60:	39 c6                	cmp    %eax,%esi
80104d62:	73 44                	jae    80104da8 <argstr+0x68>
80104d64:	8d 53 08             	lea    0x8(%ebx),%edx
80104d67:	39 d0                	cmp    %edx,%eax
80104d69:	72 3d                	jb     80104da8 <argstr+0x68>
  *ip = *(int*)(addr);
80104d6b:	8b 5b 04             	mov    0x4(%ebx),%ebx
  struct proc *curproc = myproc();
80104d6e:	e8 ed ee ff ff       	call   80103c60 <myproc>
  if(addr >= curproc->sz)
80104d73:	3b 18                	cmp    (%eax),%ebx
80104d75:	73 31                	jae    80104da8 <argstr+0x68>
  *pp = (char*)addr;
80104d77:	8b 55 0c             	mov    0xc(%ebp),%edx
80104d7a:	89 1a                	mov    %ebx,(%edx)
  ep = (char*)curproc->sz;
80104d7c:	8b 10                	mov    (%eax),%edx
  for(s = *pp; s < ep; s++){
80104d7e:	39 d3                	cmp    %edx,%ebx
80104d80:	73 26                	jae    80104da8 <argstr+0x68>
80104d82:	89 d8                	mov    %ebx,%eax
80104d84:	eb 11                	jmp    80104d97 <argstr+0x57>
80104d86:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d8d:	8d 76 00             	lea    0x0(%esi),%esi
80104d90:	83 c0 01             	add    $0x1,%eax
80104d93:	39 c2                	cmp    %eax,%edx
80104d95:	76 11                	jbe    80104da8 <argstr+0x68>
    if(*s == 0)
80104d97:	80 38 00             	cmpb   $0x0,(%eax)
80104d9a:	75 f4                	jne    80104d90 <argstr+0x50>
      return s - *pp;
80104d9c:	29 d8                	sub    %ebx,%eax
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
  return fetchstr(addr, pp);
}
80104d9e:	5b                   	pop    %ebx
80104d9f:	5e                   	pop    %esi
80104da0:	5d                   	pop    %ebp
80104da1:	c3                   	ret    
80104da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104da8:	5b                   	pop    %ebx
    return -1;
80104da9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dae:	5e                   	pop    %esi
80104daf:	5d                   	pop    %ebp
80104db0:	c3                   	ret    
80104db1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104db8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104dbf:	90                   	nop

80104dc0 <syscall>:
[SYS_chmod]   sys_chmod,
};

void
syscall(void)
{
80104dc0:	55                   	push   %ebp
80104dc1:	89 e5                	mov    %esp,%ebp
80104dc3:	53                   	push   %ebx
80104dc4:	83 ec 04             	sub    $0x4,%esp
  int num;
  struct proc *p = myproc();
80104dc7:	e8 94 ee ff ff       	call   80103c60 <myproc>
80104dcc:	89 c3                	mov    %eax,%ebx

  num = p->tf->eax;
80104dce:	8b 40 18             	mov    0x18(%eax),%eax
80104dd1:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104dd4:	8d 50 ff             	lea    -0x1(%eax),%edx
80104dd7:	83 fa 18             	cmp    $0x18,%edx
80104dda:	77 34                	ja     80104e10 <syscall+0x50>
80104ddc:	8b 14 85 00 7e 10 80 	mov    -0x7fef8200(,%eax,4),%edx
80104de3:	85 d2                	test   %edx,%edx
80104de5:	74 29                	je     80104e10 <syscall+0x50>
    if (p->blocked_syscalls[num] && p->pass_syscalls[num]) {
80104de7:	8b 8c 83 7c 01 00 00 	mov    0x17c(%ebx,%eax,4),%ecx
80104dee:	85 c9                	test   %ecx,%ecx
80104df0:	74 08                	je     80104dfa <syscall+0x3a>
80104df2:	8b 4c 83 7c          	mov    0x7c(%ebx,%eax,4),%ecx
80104df6:	85 c9                	test   %ecx,%ecx
80104df8:	75 3e                	jne    80104e38 <syscall+0x78>
      cprintf("syscall %d is blocked\n", num);
      p->tf->eax = -1;  // Return error (-1) instead of executing
      return;
    }
    p->tf->eax = syscalls[num]();
80104dfa:	ff d2                	call   *%edx
80104dfc:	89 c2                	mov    %eax,%edx
80104dfe:	8b 43 18             	mov    0x18(%ebx),%eax
80104e01:	89 50 1c             	mov    %edx,0x1c(%eax)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            p->pid, p->name, num);
    p->tf->eax = -1;
  }
}
80104e04:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e07:	c9                   	leave  
80104e08:	c3                   	ret    
80104e09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    cprintf("%d %s: unknown sys call %d\n",
80104e10:	50                   	push   %eax
            p->pid, p->name, num);
80104e11:	8d 43 6c             	lea    0x6c(%ebx),%eax
    cprintf("%d %s: unknown sys call %d\n",
80104e14:	50                   	push   %eax
80104e15:	ff 73 10             	push   0x10(%ebx)
80104e18:	68 e0 7d 10 80       	push   $0x80107de0
80104e1d:	e8 7e b8 ff ff       	call   801006a0 <cprintf>
    p->tf->eax = -1;
80104e22:	8b 43 18             	mov    0x18(%ebx),%eax
80104e25:	83 c4 10             	add    $0x10,%esp
80104e28:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
}
80104e2f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104e32:	c9                   	leave  
80104e33:	c3                   	ret    
80104e34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      cprintf("syscall %d is blocked\n", num);
80104e38:	83 ec 08             	sub    $0x8,%esp
80104e3b:	50                   	push   %eax
80104e3c:	68 c9 7d 10 80       	push   $0x80107dc9
80104e41:	e8 5a b8 ff ff       	call   801006a0 <cprintf>
      p->tf->eax = -1;  // Return error (-1) instead of executing
80104e46:	8b 43 18             	mov    0x18(%ebx),%eax
      return;
80104e49:	83 c4 10             	add    $0x10,%esp
      p->tf->eax = -1;  // Return error (-1) instead of executing
80104e4c:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
      return;
80104e53:	eb da                	jmp    80104e2f <syscall+0x6f>
80104e55:	66 90                	xchg   %ax,%ax
80104e57:	66 90                	xchg   %ax,%ax
80104e59:	66 90                	xchg   %ax,%ax
80104e5b:	66 90                	xchg   %ax,%ax
80104e5d:	66 90                	xchg   %ax,%ax
80104e5f:	90                   	nop

80104e60 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104e60:	55                   	push   %ebp
80104e61:	89 e5                	mov    %esp,%ebp
80104e63:	57                   	push   %edi
80104e64:	56                   	push   %esi
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
80104e65:	8d 7d da             	lea    -0x26(%ebp),%edi
{
80104e68:	53                   	push   %ebx
80104e69:	83 ec 34             	sub    $0x34,%esp
80104e6c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
80104e6f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  if((dp = nameiparent(path, name)) == 0)
80104e72:	57                   	push   %edi
80104e73:	50                   	push   %eax
{
80104e74:	89 55 d4             	mov    %edx,-0x2c(%ebp)
80104e77:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  if((dp = nameiparent(path, name)) == 0)
80104e7a:	e8 f1 d2 ff ff       	call   80102170 <nameiparent>
80104e7f:	83 c4 10             	add    $0x10,%esp
80104e82:	85 c0                	test   %eax,%eax
80104e84:	0f 84 46 01 00 00    	je     80104fd0 <create+0x170>
    return 0;
  ilock(dp);
80104e8a:	83 ec 0c             	sub    $0xc,%esp
80104e8d:	89 c3                	mov    %eax,%ebx
80104e8f:	50                   	push   %eax
80104e90:	e8 9b c9 ff ff       	call   80101830 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
80104e95:	83 c4 0c             	add    $0xc,%esp
80104e98:	6a 00                	push   $0x0
80104e9a:	57                   	push   %edi
80104e9b:	53                   	push   %ebx
80104e9c:	e8 ef ce ff ff       	call   80101d90 <dirlookup>
80104ea1:	83 c4 10             	add    $0x10,%esp
80104ea4:	89 c6                	mov    %eax,%esi
80104ea6:	85 c0                	test   %eax,%eax
80104ea8:	74 56                	je     80104f00 <create+0xa0>
    iunlockput(dp);
80104eaa:	83 ec 0c             	sub    $0xc,%esp
80104ead:	53                   	push   %ebx
80104eae:	e8 0d cc ff ff       	call   80101ac0 <iunlockput>
    ilock(ip);
80104eb3:	89 34 24             	mov    %esi,(%esp)
80104eb6:	e8 75 c9 ff ff       	call   80101830 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
80104ebb:	83 c4 10             	add    $0x10,%esp
80104ebe:	66 83 7d d4 02       	cmpw   $0x2,-0x2c(%ebp)
80104ec3:	75 1b                	jne    80104ee0 <create+0x80>
80104ec5:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
80104eca:	75 14                	jne    80104ee0 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104ecc:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ecf:	89 f0                	mov    %esi,%eax
80104ed1:	5b                   	pop    %ebx
80104ed2:	5e                   	pop    %esi
80104ed3:	5f                   	pop    %edi
80104ed4:	5d                   	pop    %ebp
80104ed5:	c3                   	ret    
80104ed6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104edd:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80104ee0:	83 ec 0c             	sub    $0xc,%esp
80104ee3:	56                   	push   %esi
    return 0;
80104ee4:	31 f6                	xor    %esi,%esi
    iunlockput(ip);
80104ee6:	e8 d5 cb ff ff       	call   80101ac0 <iunlockput>
    return 0;
80104eeb:	83 c4 10             	add    $0x10,%esp
}
80104eee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104ef1:	89 f0                	mov    %esi,%eax
80104ef3:	5b                   	pop    %ebx
80104ef4:	5e                   	pop    %esi
80104ef5:	5f                   	pop    %edi
80104ef6:	5d                   	pop    %ebp
80104ef7:	c3                   	ret    
80104ef8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104eff:	90                   	nop
  if((ip = ialloc(dp->dev, type)) == 0)
80104f00:	0f bf 45 d4          	movswl -0x2c(%ebp),%eax
80104f04:	83 ec 08             	sub    $0x8,%esp
80104f07:	50                   	push   %eax
80104f08:	ff 33                	push   (%ebx)
80104f0a:	e8 91 c7 ff ff       	call   801016a0 <ialloc>
80104f0f:	83 c4 10             	add    $0x10,%esp
80104f12:	89 c6                	mov    %eax,%esi
80104f14:	85 c0                	test   %eax,%eax
80104f16:	0f 84 cd 00 00 00    	je     80104fe9 <create+0x189>
  ilock(ip);
80104f1c:	83 ec 0c             	sub    $0xc,%esp
80104f1f:	50                   	push   %eax
80104f20:	e8 0b c9 ff ff       	call   80101830 <ilock>
  ip->major = major;
80104f25:	0f b7 45 d0          	movzwl -0x30(%ebp),%eax
80104f29:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
80104f2d:	0f b7 45 cc          	movzwl -0x34(%ebp),%eax
80104f31:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104f35:	b8 01 00 00 00       	mov    $0x1,%eax
80104f3a:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
80104f3e:	89 34 24             	mov    %esi,(%esp)
80104f41:	e8 2a c8 ff ff       	call   80101770 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
80104f46:	83 c4 10             	add    $0x10,%esp
80104f49:	66 83 7d d4 01       	cmpw   $0x1,-0x2c(%ebp)
80104f4e:	74 30                	je     80104f80 <create+0x120>
  if(dirlink(dp, name, ip->inum) < 0)
80104f50:	83 ec 04             	sub    $0x4,%esp
80104f53:	ff 76 04             	push   0x4(%esi)
80104f56:	57                   	push   %edi
80104f57:	53                   	push   %ebx
80104f58:	e8 33 d1 ff ff       	call   80102090 <dirlink>
80104f5d:	83 c4 10             	add    $0x10,%esp
80104f60:	85 c0                	test   %eax,%eax
80104f62:	78 78                	js     80104fdc <create+0x17c>
  iunlockput(dp);
80104f64:	83 ec 0c             	sub    $0xc,%esp
80104f67:	53                   	push   %ebx
80104f68:	e8 53 cb ff ff       	call   80101ac0 <iunlockput>
  return ip;
80104f6d:	83 c4 10             	add    $0x10,%esp
}
80104f70:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f73:	89 f0                	mov    %esi,%eax
80104f75:	5b                   	pop    %ebx
80104f76:	5e                   	pop    %esi
80104f77:	5f                   	pop    %edi
80104f78:	5d                   	pop    %ebp
80104f79:	c3                   	ret    
80104f7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iupdate(dp);
80104f80:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink++;  // for ".."
80104f83:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
    iupdate(dp);
80104f88:	53                   	push   %ebx
80104f89:	e8 e2 c7 ff ff       	call   80101770 <iupdate>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
80104f8e:	83 c4 0c             	add    $0xc,%esp
80104f91:	ff 76 04             	push   0x4(%esi)
80104f94:	68 84 7e 10 80       	push   $0x80107e84
80104f99:	56                   	push   %esi
80104f9a:	e8 f1 d0 ff ff       	call   80102090 <dirlink>
80104f9f:	83 c4 10             	add    $0x10,%esp
80104fa2:	85 c0                	test   %eax,%eax
80104fa4:	78 18                	js     80104fbe <create+0x15e>
80104fa6:	83 ec 04             	sub    $0x4,%esp
80104fa9:	ff 73 04             	push   0x4(%ebx)
80104fac:	68 83 7e 10 80       	push   $0x80107e83
80104fb1:	56                   	push   %esi
80104fb2:	e8 d9 d0 ff ff       	call   80102090 <dirlink>
80104fb7:	83 c4 10             	add    $0x10,%esp
80104fba:	85 c0                	test   %eax,%eax
80104fbc:	79 92                	jns    80104f50 <create+0xf0>
      panic("create dots");
80104fbe:	83 ec 0c             	sub    $0xc,%esp
80104fc1:	68 77 7e 10 80       	push   $0x80107e77
80104fc6:	e8 b5 b3 ff ff       	call   80100380 <panic>
80104fcb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104fcf:	90                   	nop
}
80104fd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
80104fd3:	31 f6                	xor    %esi,%esi
}
80104fd5:	5b                   	pop    %ebx
80104fd6:	89 f0                	mov    %esi,%eax
80104fd8:	5e                   	pop    %esi
80104fd9:	5f                   	pop    %edi
80104fda:	5d                   	pop    %ebp
80104fdb:	c3                   	ret    
    panic("create: dirlink");
80104fdc:	83 ec 0c             	sub    $0xc,%esp
80104fdf:	68 86 7e 10 80       	push   $0x80107e86
80104fe4:	e8 97 b3 ff ff       	call   80100380 <panic>
    panic("create: ialloc");
80104fe9:	83 ec 0c             	sub    $0xc,%esp
80104fec:	68 68 7e 10 80       	push   $0x80107e68
80104ff1:	e8 8a b3 ff ff       	call   80100380 <panic>
80104ff6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ffd:	8d 76 00             	lea    0x0(%esi),%esi

80105000 <sys_dup>:
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	56                   	push   %esi
80105004:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105005:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105008:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010500b:	50                   	push   %eax
8010500c:	6a 00                	push   $0x0
8010500e:	e8 6d fc ff ff       	call   80104c80 <argint>
80105013:	83 c4 10             	add    $0x10,%esp
80105016:	85 c0                	test   %eax,%eax
80105018:	78 36                	js     80105050 <sys_dup+0x50>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010501a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010501e:	77 30                	ja     80105050 <sys_dup+0x50>
80105020:	e8 3b ec ff ff       	call   80103c60 <myproc>
80105025:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105028:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010502c:	85 f6                	test   %esi,%esi
8010502e:	74 20                	je     80105050 <sys_dup+0x50>
  struct proc *curproc = myproc();
80105030:	e8 2b ec ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105035:	31 db                	xor    %ebx,%ebx
80105037:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010503e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105040:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105044:	85 d2                	test   %edx,%edx
80105046:	74 18                	je     80105060 <sys_dup+0x60>
  for(fd = 0; fd < NOFILE; fd++){
80105048:	83 c3 01             	add    $0x1,%ebx
8010504b:	83 fb 10             	cmp    $0x10,%ebx
8010504e:	75 f0                	jne    80105040 <sys_dup+0x40>
}
80105050:	8d 65 f8             	lea    -0x8(%ebp),%esp
    return -1;
80105053:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
}
80105058:	89 d8                	mov    %ebx,%eax
8010505a:	5b                   	pop    %ebx
8010505b:	5e                   	pop    %esi
8010505c:	5d                   	pop    %ebp
8010505d:	c3                   	ret    
8010505e:	66 90                	xchg   %ax,%ax
  filedup(f);
80105060:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
80105063:	89 74 98 28          	mov    %esi,0x28(%eax,%ebx,4)
  filedup(f);
80105067:	56                   	push   %esi
80105068:	e8 c3 be ff ff       	call   80100f30 <filedup>
  return fd;
8010506d:	83 c4 10             	add    $0x10,%esp
}
80105070:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105073:	89 d8                	mov    %ebx,%eax
80105075:	5b                   	pop    %ebx
80105076:	5e                   	pop    %esi
80105077:	5d                   	pop    %ebp
80105078:	c3                   	ret    
80105079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105080 <sys_read>:
{
80105080:	55                   	push   %ebp
80105081:	89 e5                	mov    %esp,%ebp
80105083:	56                   	push   %esi
80105084:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105085:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80105088:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010508b:	56                   	push   %esi
8010508c:	6a 00                	push   $0x0
8010508e:	e8 ed fb ff ff       	call   80104c80 <argint>
80105093:	83 c4 10             	add    $0x10,%esp
80105096:	85 c0                	test   %eax,%eax
80105098:	78 76                	js     80105110 <sys_read+0x90>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010509a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010509e:	77 70                	ja     80105110 <sys_read+0x90>
801050a0:	e8 bb eb ff ff       	call   80103c60 <myproc>
801050a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801050a8:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
801050ac:	85 db                	test   %ebx,%ebx
801050ae:	74 60                	je     80105110 <sys_read+0x90>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
801050b0:	83 ec 08             	sub    $0x8,%esp
801050b3:	8d 45 f0             	lea    -0x10(%ebp),%eax
801050b6:	50                   	push   %eax
801050b7:	6a 02                	push   $0x2
801050b9:	e8 c2 fb ff ff       	call   80104c80 <argint>
801050be:	83 c4 10             	add    $0x10,%esp
801050c1:	85 c0                	test   %eax,%eax
801050c3:	78 4b                	js     80105110 <sys_read+0x90>
801050c5:	83 ec 04             	sub    $0x4,%esp
801050c8:	ff 75 f0             	push   -0x10(%ebp)
801050cb:	56                   	push   %esi
801050cc:	6a 01                	push   $0x1
801050ce:	e8 fd fb ff ff       	call   80104cd0 <argptr>
801050d3:	83 c4 10             	add    $0x10,%esp
801050d6:	85 c0                	test   %eax,%eax
801050d8:	78 36                	js     80105110 <sys_read+0x90>
  if (!(f->ip->mode & 0x1)) { // 0x1 = Read
801050da:	8b 43 10             	mov    0x10(%ebx),%eax
801050dd:	f6 80 90 00 00 00 01 	testb  $0x1,0x90(%eax)
801050e4:	74 1a                	je     80105100 <sys_read+0x80>
  return fileread(f, p, n);
801050e6:	83 ec 04             	sub    $0x4,%esp
801050e9:	ff 75 f0             	push   -0x10(%ebp)
801050ec:	ff 75 f4             	push   -0xc(%ebp)
801050ef:	53                   	push   %ebx
801050f0:	e8 bb bf ff ff       	call   801010b0 <fileread>
801050f5:	83 c4 10             	add    $0x10,%esp
}
801050f8:	8d 65 f8             	lea    -0x8(%ebp),%esp
801050fb:	5b                   	pop    %ebx
801050fc:	5e                   	pop    %esi
801050fd:	5d                   	pop    %ebp
801050fe:	c3                   	ret    
801050ff:	90                   	nop
    cprintf("Operation read failed\n");
80105100:	83 ec 0c             	sub    $0xc,%esp
80105103:	68 96 7e 10 80       	push   $0x80107e96
80105108:	e8 93 b5 ff ff       	call   801006a0 <cprintf>
    return -1;
8010510d:	83 c4 10             	add    $0x10,%esp
80105110:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105115:	eb e1                	jmp    801050f8 <sys_read+0x78>
80105117:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010511e:	66 90                	xchg   %ax,%ax

80105120 <sys_write>:
{
80105120:	55                   	push   %ebp
80105121:	89 e5                	mov    %esp,%ebp
80105123:	56                   	push   %esi
80105124:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105125:	8d 75 f4             	lea    -0xc(%ebp),%esi
{
80105128:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010512b:	56                   	push   %esi
8010512c:	6a 00                	push   $0x0
8010512e:	e8 4d fb ff ff       	call   80104c80 <argint>
80105133:	83 c4 10             	add    $0x10,%esp
80105136:	85 c0                	test   %eax,%eax
80105138:	78 76                	js     801051b0 <sys_write+0x90>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010513a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010513e:	77 70                	ja     801051b0 <sys_write+0x90>
80105140:	e8 1b eb ff ff       	call   80103c60 <myproc>
80105145:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105148:	8b 5c 90 28          	mov    0x28(%eax,%edx,4),%ebx
8010514c:	85 db                	test   %ebx,%ebx
8010514e:	74 60                	je     801051b0 <sys_write+0x90>
  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80105150:	83 ec 08             	sub    $0x8,%esp
80105153:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105156:	50                   	push   %eax
80105157:	6a 02                	push   $0x2
80105159:	e8 22 fb ff ff       	call   80104c80 <argint>
8010515e:	83 c4 10             	add    $0x10,%esp
80105161:	85 c0                	test   %eax,%eax
80105163:	78 4b                	js     801051b0 <sys_write+0x90>
80105165:	83 ec 04             	sub    $0x4,%esp
80105168:	ff 75 f0             	push   -0x10(%ebp)
8010516b:	56                   	push   %esi
8010516c:	6a 01                	push   $0x1
8010516e:	e8 5d fb ff ff       	call   80104cd0 <argptr>
80105173:	83 c4 10             	add    $0x10,%esp
80105176:	85 c0                	test   %eax,%eax
80105178:	78 36                	js     801051b0 <sys_write+0x90>
  if (!(f->ip->mode & 0x2)) { // 0x2 = Write
8010517a:	8b 43 10             	mov    0x10(%ebx),%eax
8010517d:	f6 80 90 00 00 00 02 	testb  $0x2,0x90(%eax)
80105184:	74 1a                	je     801051a0 <sys_write+0x80>
  return filewrite(f, p, n);
80105186:	83 ec 04             	sub    $0x4,%esp
80105189:	ff 75 f0             	push   -0x10(%ebp)
8010518c:	ff 75 f4             	push   -0xc(%ebp)
8010518f:	53                   	push   %ebx
80105190:	e8 ab bf ff ff       	call   80101140 <filewrite>
80105195:	83 c4 10             	add    $0x10,%esp
}
80105198:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010519b:	5b                   	pop    %ebx
8010519c:	5e                   	pop    %esi
8010519d:	5d                   	pop    %ebp
8010519e:	c3                   	ret    
8010519f:	90                   	nop
    cprintf("Operation write failed\n");
801051a0:	83 ec 0c             	sub    $0xc,%esp
801051a3:	68 ad 7e 10 80       	push   $0x80107ead
801051a8:	e8 f3 b4 ff ff       	call   801006a0 <cprintf>
    return -1;
801051ad:	83 c4 10             	add    $0x10,%esp
801051b0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801051b5:	eb e1                	jmp    80105198 <sys_write+0x78>
801051b7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_close>:
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	56                   	push   %esi
801051c4:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
801051c5:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
801051c8:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
801051cb:	50                   	push   %eax
801051cc:	6a 00                	push   $0x0
801051ce:	e8 ad fa ff ff       	call   80104c80 <argint>
801051d3:	83 c4 10             	add    $0x10,%esp
801051d6:	85 c0                	test   %eax,%eax
801051d8:	78 3e                	js     80105218 <sys_close+0x58>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
801051da:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
801051de:	77 38                	ja     80105218 <sys_close+0x58>
801051e0:	e8 7b ea ff ff       	call   80103c60 <myproc>
801051e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
801051e8:	8d 5a 08             	lea    0x8(%edx),%ebx
801051eb:	8b 74 98 08          	mov    0x8(%eax,%ebx,4),%esi
801051ef:	85 f6                	test   %esi,%esi
801051f1:	74 25                	je     80105218 <sys_close+0x58>
  myproc()->ofile[fd] = 0;
801051f3:	e8 68 ea ff ff       	call   80103c60 <myproc>
  fileclose(f);
801051f8:	83 ec 0c             	sub    $0xc,%esp
  myproc()->ofile[fd] = 0;
801051fb:	c7 44 98 08 00 00 00 	movl   $0x0,0x8(%eax,%ebx,4)
80105202:	00 
  fileclose(f);
80105203:	56                   	push   %esi
80105204:	e8 77 bd ff ff       	call   80100f80 <fileclose>
  return 0;
80105209:	83 c4 10             	add    $0x10,%esp
8010520c:	31 c0                	xor    %eax,%eax
}
8010520e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105211:	5b                   	pop    %ebx
80105212:	5e                   	pop    %esi
80105213:	5d                   	pop    %ebp
80105214:	c3                   	ret    
80105215:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80105218:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010521d:	eb ef                	jmp    8010520e <sys_close+0x4e>
8010521f:	90                   	nop

80105220 <sys_fstat>:
{
80105220:	55                   	push   %ebp
80105221:	89 e5                	mov    %esp,%ebp
80105223:	56                   	push   %esi
80105224:	53                   	push   %ebx
  if(argint(n, &fd) < 0)
80105225:	8d 5d f4             	lea    -0xc(%ebp),%ebx
{
80105228:	83 ec 18             	sub    $0x18,%esp
  if(argint(n, &fd) < 0)
8010522b:	53                   	push   %ebx
8010522c:	6a 00                	push   $0x0
8010522e:	e8 4d fa ff ff       	call   80104c80 <argint>
80105233:	83 c4 10             	add    $0x10,%esp
80105236:	85 c0                	test   %eax,%eax
80105238:	78 46                	js     80105280 <sys_fstat+0x60>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
8010523a:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
8010523e:	77 40                	ja     80105280 <sys_fstat+0x60>
80105240:	e8 1b ea ff ff       	call   80103c60 <myproc>
80105245:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105248:	8b 74 90 28          	mov    0x28(%eax,%edx,4),%esi
8010524c:	85 f6                	test   %esi,%esi
8010524e:	74 30                	je     80105280 <sys_fstat+0x60>
  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80105250:	83 ec 04             	sub    $0x4,%esp
80105253:	6a 14                	push   $0x14
80105255:	53                   	push   %ebx
80105256:	6a 01                	push   $0x1
80105258:	e8 73 fa ff ff       	call   80104cd0 <argptr>
8010525d:	83 c4 10             	add    $0x10,%esp
80105260:	85 c0                	test   %eax,%eax
80105262:	78 1c                	js     80105280 <sys_fstat+0x60>
  return filestat(f, st);
80105264:	83 ec 08             	sub    $0x8,%esp
80105267:	ff 75 f4             	push   -0xc(%ebp)
8010526a:	56                   	push   %esi
8010526b:	e8 f0 bd ff ff       	call   80101060 <filestat>
80105270:	83 c4 10             	add    $0x10,%esp
}
80105273:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105276:	5b                   	pop    %ebx
80105277:	5e                   	pop    %esi
80105278:	5d                   	pop    %ebp
80105279:	c3                   	ret    
8010527a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;
80105280:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105285:	eb ec                	jmp    80105273 <sys_fstat+0x53>
80105287:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010528e:	66 90                	xchg   %ax,%ax

80105290 <sys_link>:
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	57                   	push   %edi
80105294:	56                   	push   %esi
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80105295:	8d 45 d4             	lea    -0x2c(%ebp),%eax
{
80105298:	53                   	push   %ebx
80105299:	83 ec 34             	sub    $0x34,%esp
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
8010529c:	50                   	push   %eax
8010529d:	6a 00                	push   $0x0
8010529f:	e8 9c fa ff ff       	call   80104d40 <argstr>
801052a4:	83 c4 10             	add    $0x10,%esp
801052a7:	85 c0                	test   %eax,%eax
801052a9:	0f 88 fb 00 00 00    	js     801053aa <sys_link+0x11a>
801052af:	83 ec 08             	sub    $0x8,%esp
801052b2:	8d 45 d0             	lea    -0x30(%ebp),%eax
801052b5:	50                   	push   %eax
801052b6:	6a 01                	push   $0x1
801052b8:	e8 83 fa ff ff       	call   80104d40 <argstr>
801052bd:	83 c4 10             	add    $0x10,%esp
801052c0:	85 c0                	test   %eax,%eax
801052c2:	0f 88 e2 00 00 00    	js     801053aa <sys_link+0x11a>
  begin_op();
801052c8:	e8 43 db ff ff       	call   80102e10 <begin_op>
  if((ip = namei(old)) == 0){
801052cd:	83 ec 0c             	sub    $0xc,%esp
801052d0:	ff 75 d4             	push   -0x2c(%ebp)
801052d3:	e8 78 ce ff ff       	call   80102150 <namei>
801052d8:	83 c4 10             	add    $0x10,%esp
801052db:	89 c3                	mov    %eax,%ebx
801052dd:	85 c0                	test   %eax,%eax
801052df:	0f 84 e4 00 00 00    	je     801053c9 <sys_link+0x139>
  ilock(ip);
801052e5:	83 ec 0c             	sub    $0xc,%esp
801052e8:	50                   	push   %eax
801052e9:	e8 42 c5 ff ff       	call   80101830 <ilock>
  if(ip->type == T_DIR){
801052ee:	83 c4 10             	add    $0x10,%esp
801052f1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801052f6:	0f 84 b5 00 00 00    	je     801053b1 <sys_link+0x121>
  iupdate(ip);
801052fc:	83 ec 0c             	sub    $0xc,%esp
  ip->nlink++;
801052ff:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  if((dp = nameiparent(new, name)) == 0)
80105304:	8d 7d da             	lea    -0x26(%ebp),%edi
  iupdate(ip);
80105307:	53                   	push   %ebx
80105308:	e8 63 c4 ff ff       	call   80101770 <iupdate>
  iunlock(ip);
8010530d:	89 1c 24             	mov    %ebx,(%esp)
80105310:	e8 fb c5 ff ff       	call   80101910 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
80105315:	58                   	pop    %eax
80105316:	5a                   	pop    %edx
80105317:	57                   	push   %edi
80105318:	ff 75 d0             	push   -0x30(%ebp)
8010531b:	e8 50 ce ff ff       	call   80102170 <nameiparent>
80105320:	83 c4 10             	add    $0x10,%esp
80105323:	89 c6                	mov    %eax,%esi
80105325:	85 c0                	test   %eax,%eax
80105327:	74 5b                	je     80105384 <sys_link+0xf4>
  ilock(dp);
80105329:	83 ec 0c             	sub    $0xc,%esp
8010532c:	50                   	push   %eax
8010532d:	e8 fe c4 ff ff       	call   80101830 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80105332:	8b 03                	mov    (%ebx),%eax
80105334:	83 c4 10             	add    $0x10,%esp
80105337:	39 06                	cmp    %eax,(%esi)
80105339:	75 3d                	jne    80105378 <sys_link+0xe8>
8010533b:	83 ec 04             	sub    $0x4,%esp
8010533e:	ff 73 04             	push   0x4(%ebx)
80105341:	57                   	push   %edi
80105342:	56                   	push   %esi
80105343:	e8 48 cd ff ff       	call   80102090 <dirlink>
80105348:	83 c4 10             	add    $0x10,%esp
8010534b:	85 c0                	test   %eax,%eax
8010534d:	78 29                	js     80105378 <sys_link+0xe8>
  iunlockput(dp);
8010534f:	83 ec 0c             	sub    $0xc,%esp
80105352:	56                   	push   %esi
80105353:	e8 68 c7 ff ff       	call   80101ac0 <iunlockput>
  iput(ip);
80105358:	89 1c 24             	mov    %ebx,(%esp)
8010535b:	e8 00 c6 ff ff       	call   80101960 <iput>
  end_op();
80105360:	e8 1b db ff ff       	call   80102e80 <end_op>
  return 0;
80105365:	83 c4 10             	add    $0x10,%esp
80105368:	31 c0                	xor    %eax,%eax
}
8010536a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010536d:	5b                   	pop    %ebx
8010536e:	5e                   	pop    %esi
8010536f:	5f                   	pop    %edi
80105370:	5d                   	pop    %ebp
80105371:	c3                   	ret    
80105372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    iunlockput(dp);
80105378:	83 ec 0c             	sub    $0xc,%esp
8010537b:	56                   	push   %esi
8010537c:	e8 3f c7 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
80105381:	83 c4 10             	add    $0x10,%esp
  ilock(ip);
80105384:	83 ec 0c             	sub    $0xc,%esp
80105387:	53                   	push   %ebx
80105388:	e8 a3 c4 ff ff       	call   80101830 <ilock>
  ip->nlink--;
8010538d:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80105392:	89 1c 24             	mov    %ebx,(%esp)
80105395:	e8 d6 c3 ff ff       	call   80101770 <iupdate>
  iunlockput(ip);
8010539a:	89 1c 24             	mov    %ebx,(%esp)
8010539d:	e8 1e c7 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801053a2:	e8 d9 da ff ff       	call   80102e80 <end_op>
  return -1;
801053a7:	83 c4 10             	add    $0x10,%esp
801053aa:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053af:	eb b9                	jmp    8010536a <sys_link+0xda>
    iunlockput(ip);
801053b1:	83 ec 0c             	sub    $0xc,%esp
801053b4:	53                   	push   %ebx
801053b5:	e8 06 c7 ff ff       	call   80101ac0 <iunlockput>
    end_op();
801053ba:	e8 c1 da ff ff       	call   80102e80 <end_op>
    return -1;
801053bf:	83 c4 10             	add    $0x10,%esp
801053c2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053c7:	eb a1                	jmp    8010536a <sys_link+0xda>
    end_op();
801053c9:	e8 b2 da ff ff       	call   80102e80 <end_op>
    return -1;
801053ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d3:	eb 95                	jmp    8010536a <sys_link+0xda>
801053d5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_unlink>:
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
  if(argstr(0, &path) < 0)
801053e5:	8d 45 c0             	lea    -0x40(%ebp),%eax
{
801053e8:	53                   	push   %ebx
801053e9:	83 ec 54             	sub    $0x54,%esp
  if(argstr(0, &path) < 0)
801053ec:	50                   	push   %eax
801053ed:	6a 00                	push   $0x0
801053ef:	e8 4c f9 ff ff       	call   80104d40 <argstr>
801053f4:	83 c4 10             	add    $0x10,%esp
801053f7:	85 c0                	test   %eax,%eax
801053f9:	0f 88 7a 01 00 00    	js     80105579 <sys_unlink+0x199>
  begin_op();
801053ff:	e8 0c da ff ff       	call   80102e10 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80105404:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80105407:	83 ec 08             	sub    $0x8,%esp
8010540a:	53                   	push   %ebx
8010540b:	ff 75 c0             	push   -0x40(%ebp)
8010540e:	e8 5d cd ff ff       	call   80102170 <nameiparent>
80105413:	83 c4 10             	add    $0x10,%esp
80105416:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80105419:	85 c0                	test   %eax,%eax
8010541b:	0f 84 62 01 00 00    	je     80105583 <sys_unlink+0x1a3>
  ilock(dp);
80105421:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105424:	83 ec 0c             	sub    $0xc,%esp
80105427:	57                   	push   %edi
80105428:	e8 03 c4 ff ff       	call   80101830 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
8010542d:	58                   	pop    %eax
8010542e:	5a                   	pop    %edx
8010542f:	68 84 7e 10 80       	push   $0x80107e84
80105434:	53                   	push   %ebx
80105435:	e8 36 c9 ff ff       	call   80101d70 <namecmp>
8010543a:	83 c4 10             	add    $0x10,%esp
8010543d:	85 c0                	test   %eax,%eax
8010543f:	0f 84 fb 00 00 00    	je     80105540 <sys_unlink+0x160>
80105445:	83 ec 08             	sub    $0x8,%esp
80105448:	68 83 7e 10 80       	push   $0x80107e83
8010544d:	53                   	push   %ebx
8010544e:	e8 1d c9 ff ff       	call   80101d70 <namecmp>
80105453:	83 c4 10             	add    $0x10,%esp
80105456:	85 c0                	test   %eax,%eax
80105458:	0f 84 e2 00 00 00    	je     80105540 <sys_unlink+0x160>
  if((ip = dirlookup(dp, name, &off)) == 0)
8010545e:	83 ec 04             	sub    $0x4,%esp
80105461:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80105464:	50                   	push   %eax
80105465:	53                   	push   %ebx
80105466:	57                   	push   %edi
80105467:	e8 24 c9 ff ff       	call   80101d90 <dirlookup>
8010546c:	83 c4 10             	add    $0x10,%esp
8010546f:	89 c3                	mov    %eax,%ebx
80105471:	85 c0                	test   %eax,%eax
80105473:	0f 84 c7 00 00 00    	je     80105540 <sys_unlink+0x160>
  ilock(ip);
80105479:	83 ec 0c             	sub    $0xc,%esp
8010547c:	50                   	push   %eax
8010547d:	e8 ae c3 ff ff       	call   80101830 <ilock>
  if(ip->nlink < 1)
80105482:	83 c4 10             	add    $0x10,%esp
80105485:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
8010548a:	0f 8e 1c 01 00 00    	jle    801055ac <sys_unlink+0x1cc>
  if(ip->type == T_DIR && !isdirempty(ip)){
80105490:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80105495:	8d 7d d8             	lea    -0x28(%ebp),%edi
80105498:	74 66                	je     80105500 <sys_unlink+0x120>
  memset(&de, 0, sizeof(de));
8010549a:	83 ec 04             	sub    $0x4,%esp
8010549d:	6a 10                	push   $0x10
8010549f:	6a 00                	push   $0x0
801054a1:	57                   	push   %edi
801054a2:	e8 19 f5 ff ff       	call   801049c0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
801054a7:	6a 10                	push   $0x10
801054a9:	ff 75 c4             	push   -0x3c(%ebp)
801054ac:	57                   	push   %edi
801054ad:	ff 75 b4             	push   -0x4c(%ebp)
801054b0:	e8 8b c7 ff ff       	call   80101c40 <writei>
801054b5:	83 c4 20             	add    $0x20,%esp
801054b8:	83 f8 10             	cmp    $0x10,%eax
801054bb:	0f 85 de 00 00 00    	jne    8010559f <sys_unlink+0x1bf>
  if(ip->type == T_DIR){
801054c1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
801054c6:	0f 84 94 00 00 00    	je     80105560 <sys_unlink+0x180>
  iunlockput(dp);
801054cc:	83 ec 0c             	sub    $0xc,%esp
801054cf:	ff 75 b4             	push   -0x4c(%ebp)
801054d2:	e8 e9 c5 ff ff       	call   80101ac0 <iunlockput>
  ip->nlink--;
801054d7:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
801054dc:	89 1c 24             	mov    %ebx,(%esp)
801054df:	e8 8c c2 ff ff       	call   80101770 <iupdate>
  iunlockput(ip);
801054e4:	89 1c 24             	mov    %ebx,(%esp)
801054e7:	e8 d4 c5 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801054ec:	e8 8f d9 ff ff       	call   80102e80 <end_op>
  return 0;
801054f1:	83 c4 10             	add    $0x10,%esp
801054f4:	31 c0                	xor    %eax,%eax
}
801054f6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801054f9:	5b                   	pop    %ebx
801054fa:	5e                   	pop    %esi
801054fb:	5f                   	pop    %edi
801054fc:	5d                   	pop    %ebp
801054fd:	c3                   	ret    
801054fe:	66 90                	xchg   %ax,%ax
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80105500:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80105504:	76 94                	jbe    8010549a <sys_unlink+0xba>
80105506:	be 20 00 00 00       	mov    $0x20,%esi
8010550b:	eb 0b                	jmp    80105518 <sys_unlink+0x138>
8010550d:	8d 76 00             	lea    0x0(%esi),%esi
80105510:	83 c6 10             	add    $0x10,%esi
80105513:	3b 73 58             	cmp    0x58(%ebx),%esi
80105516:	73 82                	jae    8010549a <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80105518:	6a 10                	push   $0x10
8010551a:	56                   	push   %esi
8010551b:	57                   	push   %edi
8010551c:	53                   	push   %ebx
8010551d:	e8 1e c6 ff ff       	call   80101b40 <readi>
80105522:	83 c4 10             	add    $0x10,%esp
80105525:	83 f8 10             	cmp    $0x10,%eax
80105528:	75 68                	jne    80105592 <sys_unlink+0x1b2>
    if(de.inum != 0)
8010552a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
8010552f:	74 df                	je     80105510 <sys_unlink+0x130>
    iunlockput(ip);
80105531:	83 ec 0c             	sub    $0xc,%esp
80105534:	53                   	push   %ebx
80105535:	e8 86 c5 ff ff       	call   80101ac0 <iunlockput>
    goto bad;
8010553a:	83 c4 10             	add    $0x10,%esp
8010553d:	8d 76 00             	lea    0x0(%esi),%esi
  iunlockput(dp);
80105540:	83 ec 0c             	sub    $0xc,%esp
80105543:	ff 75 b4             	push   -0x4c(%ebp)
80105546:	e8 75 c5 ff ff       	call   80101ac0 <iunlockput>
  end_op();
8010554b:	e8 30 d9 ff ff       	call   80102e80 <end_op>
  return -1;
80105550:	83 c4 10             	add    $0x10,%esp
80105553:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105558:	eb 9c                	jmp    801054f6 <sys_unlink+0x116>
8010555a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    dp->nlink--;
80105560:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80105563:	83 ec 0c             	sub    $0xc,%esp
    dp->nlink--;
80105566:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
8010556b:	50                   	push   %eax
8010556c:	e8 ff c1 ff ff       	call   80101770 <iupdate>
80105571:	83 c4 10             	add    $0x10,%esp
80105574:	e9 53 ff ff ff       	jmp    801054cc <sys_unlink+0xec>
    return -1;
80105579:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010557e:	e9 73 ff ff ff       	jmp    801054f6 <sys_unlink+0x116>
    end_op();
80105583:	e8 f8 d8 ff ff       	call   80102e80 <end_op>
    return -1;
80105588:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010558d:	e9 64 ff ff ff       	jmp    801054f6 <sys_unlink+0x116>
      panic("isdirempty: readi");
80105592:	83 ec 0c             	sub    $0xc,%esp
80105595:	68 d7 7e 10 80       	push   $0x80107ed7
8010559a:	e8 e1 ad ff ff       	call   80100380 <panic>
    panic("unlink: writei");
8010559f:	83 ec 0c             	sub    $0xc,%esp
801055a2:	68 e9 7e 10 80       	push   $0x80107ee9
801055a7:	e8 d4 ad ff ff       	call   80100380 <panic>
    panic("unlink: nlink < 1");
801055ac:	83 ec 0c             	sub    $0xc,%esp
801055af:	68 c5 7e 10 80       	push   $0x80107ec5
801055b4:	e8 c7 ad ff ff       	call   80100380 <panic>
801055b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801055c0 <sys_open>:

int
sys_open(void)
{
801055c0:	55                   	push   %ebp
801055c1:	89 e5                	mov    %esp,%ebp
801055c3:	57                   	push   %edi
801055c4:	56                   	push   %esi
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055c5:	8d 45 e0             	lea    -0x20(%ebp),%eax
{
801055c8:	53                   	push   %ebx
801055c9:	83 ec 24             	sub    $0x24,%esp
  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
801055cc:	50                   	push   %eax
801055cd:	6a 00                	push   $0x0
801055cf:	e8 6c f7 ff ff       	call   80104d40 <argstr>
801055d4:	83 c4 10             	add    $0x10,%esp
801055d7:	85 c0                	test   %eax,%eax
801055d9:	0f 88 8e 00 00 00    	js     8010566d <sys_open+0xad>
801055df:	83 ec 08             	sub    $0x8,%esp
801055e2:	8d 45 e4             	lea    -0x1c(%ebp),%eax
801055e5:	50                   	push   %eax
801055e6:	6a 01                	push   $0x1
801055e8:	e8 93 f6 ff ff       	call   80104c80 <argint>
801055ed:	83 c4 10             	add    $0x10,%esp
801055f0:	85 c0                	test   %eax,%eax
801055f2:	78 79                	js     8010566d <sys_open+0xad>
    return -1;

  begin_op();
801055f4:	e8 17 d8 ff ff       	call   80102e10 <begin_op>

  if(omode & O_CREATE){
801055f9:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
801055fd:	75 79                	jne    80105678 <sys_open+0xb8>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
801055ff:	83 ec 0c             	sub    $0xc,%esp
80105602:	ff 75 e0             	push   -0x20(%ebp)
80105605:	e8 46 cb ff ff       	call   80102150 <namei>
8010560a:	83 c4 10             	add    $0x10,%esp
8010560d:	89 c6                	mov    %eax,%esi
8010560f:	85 c0                	test   %eax,%eax
80105611:	0f 84 7e 00 00 00    	je     80105695 <sys_open+0xd5>
      end_op();
      return -1;
    }
    ilock(ip);
80105617:	83 ec 0c             	sub    $0xc,%esp
8010561a:	50                   	push   %eax
8010561b:	e8 10 c2 ff ff       	call   80101830 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105620:	83 c4 10             	add    $0x10,%esp
80105623:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105628:	0f 84 c2 00 00 00    	je     801056f0 <sys_open+0x130>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
8010562e:	e8 8d b8 ff ff       	call   80100ec0 <filealloc>
80105633:	89 c7                	mov    %eax,%edi
80105635:	85 c0                	test   %eax,%eax
80105637:	74 23                	je     8010565c <sys_open+0x9c>
  struct proc *curproc = myproc();
80105639:	e8 22 e6 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
8010563e:	31 db                	xor    %ebx,%ebx
    if(curproc->ofile[fd] == 0){
80105640:	8b 54 98 28          	mov    0x28(%eax,%ebx,4),%edx
80105644:	85 d2                	test   %edx,%edx
80105646:	74 60                	je     801056a8 <sys_open+0xe8>
  for(fd = 0; fd < NOFILE; fd++){
80105648:	83 c3 01             	add    $0x1,%ebx
8010564b:	83 fb 10             	cmp    $0x10,%ebx
8010564e:	75 f0                	jne    80105640 <sys_open+0x80>
    if(f)
      fileclose(f);
80105650:	83 ec 0c             	sub    $0xc,%esp
80105653:	57                   	push   %edi
80105654:	e8 27 b9 ff ff       	call   80100f80 <fileclose>
80105659:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
8010565c:	83 ec 0c             	sub    $0xc,%esp
8010565f:	56                   	push   %esi
80105660:	e8 5b c4 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105665:	e8 16 d8 ff ff       	call   80102e80 <end_op>
    return -1;
8010566a:	83 c4 10             	add    $0x10,%esp
8010566d:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105672:	eb 6d                	jmp    801056e1 <sys_open+0x121>
80105674:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    ip = create(path, T_FILE, 0, 0);
80105678:	83 ec 0c             	sub    $0xc,%esp
8010567b:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010567e:	31 c9                	xor    %ecx,%ecx
80105680:	ba 02 00 00 00       	mov    $0x2,%edx
80105685:	6a 00                	push   $0x0
80105687:	e8 d4 f7 ff ff       	call   80104e60 <create>
    if(ip == 0){
8010568c:	83 c4 10             	add    $0x10,%esp
    ip = create(path, T_FILE, 0, 0);
8010568f:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80105691:	85 c0                	test   %eax,%eax
80105693:	75 99                	jne    8010562e <sys_open+0x6e>
      end_op();
80105695:	e8 e6 d7 ff ff       	call   80102e80 <end_op>
      return -1;
8010569a:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
8010569f:	eb 40                	jmp    801056e1 <sys_open+0x121>
801056a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }
  iunlock(ip);
801056a8:	83 ec 0c             	sub    $0xc,%esp
      curproc->ofile[fd] = f;
801056ab:	89 7c 98 28          	mov    %edi,0x28(%eax,%ebx,4)
  iunlock(ip);
801056af:	56                   	push   %esi
801056b0:	e8 5b c2 ff ff       	call   80101910 <iunlock>
  end_op();
801056b5:	e8 c6 d7 ff ff       	call   80102e80 <end_op>

  f->type = FD_INODE;
801056ba:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
801056c0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056c3:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
801056c6:	89 77 10             	mov    %esi,0x10(%edi)
  f->readable = !(omode & O_WRONLY);
801056c9:	89 d0                	mov    %edx,%eax
  f->off = 0;
801056cb:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
801056d2:	f7 d0                	not    %eax
801056d4:	83 e0 01             	and    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056d7:	83 e2 03             	and    $0x3,%edx
  f->readable = !(omode & O_WRONLY);
801056da:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
801056dd:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
}
801056e1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801056e4:	89 d8                	mov    %ebx,%eax
801056e6:	5b                   	pop    %ebx
801056e7:	5e                   	pop    %esi
801056e8:	5f                   	pop    %edi
801056e9:	5d                   	pop    %ebp
801056ea:	c3                   	ret    
801056eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801056ef:	90                   	nop
    if(ip->type == T_DIR && omode != O_RDONLY){
801056f0:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801056f3:	85 c9                	test   %ecx,%ecx
801056f5:	0f 84 33 ff ff ff    	je     8010562e <sys_open+0x6e>
801056fb:	e9 5c ff ff ff       	jmp    8010565c <sys_open+0x9c>

80105700 <sys_mkdir>:

int
sys_mkdir(void)
{
80105700:	55                   	push   %ebp
80105701:	89 e5                	mov    %esp,%ebp
80105703:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105706:	e8 05 d7 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010570b:	83 ec 08             	sub    $0x8,%esp
8010570e:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105711:	50                   	push   %eax
80105712:	6a 00                	push   $0x0
80105714:	e8 27 f6 ff ff       	call   80104d40 <argstr>
80105719:	83 c4 10             	add    $0x10,%esp
8010571c:	85 c0                	test   %eax,%eax
8010571e:	78 30                	js     80105750 <sys_mkdir+0x50>
80105720:	83 ec 0c             	sub    $0xc,%esp
80105723:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105726:	31 c9                	xor    %ecx,%ecx
80105728:	ba 01 00 00 00       	mov    $0x1,%edx
8010572d:	6a 00                	push   $0x0
8010572f:	e8 2c f7 ff ff       	call   80104e60 <create>
80105734:	83 c4 10             	add    $0x10,%esp
80105737:	85 c0                	test   %eax,%eax
80105739:	74 15                	je     80105750 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010573b:	83 ec 0c             	sub    $0xc,%esp
8010573e:	50                   	push   %eax
8010573f:	e8 7c c3 ff ff       	call   80101ac0 <iunlockput>
  end_op();
80105744:	e8 37 d7 ff ff       	call   80102e80 <end_op>
  return 0;
80105749:	83 c4 10             	add    $0x10,%esp
8010574c:	31 c0                	xor    %eax,%eax
}
8010574e:	c9                   	leave  
8010574f:	c3                   	ret    
    end_op();
80105750:	e8 2b d7 ff ff       	call   80102e80 <end_op>
    return -1;
80105755:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
8010575a:	c9                   	leave  
8010575b:	c3                   	ret    
8010575c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105760 <sys_mknod>:

int
sys_mknod(void)
{
80105760:	55                   	push   %ebp
80105761:	89 e5                	mov    %esp,%ebp
80105763:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80105766:	e8 a5 d6 ff ff       	call   80102e10 <begin_op>
  if((argstr(0, &path)) < 0 ||
8010576b:	83 ec 08             	sub    $0x8,%esp
8010576e:	8d 45 ec             	lea    -0x14(%ebp),%eax
80105771:	50                   	push   %eax
80105772:	6a 00                	push   $0x0
80105774:	e8 c7 f5 ff ff       	call   80104d40 <argstr>
80105779:	83 c4 10             	add    $0x10,%esp
8010577c:	85 c0                	test   %eax,%eax
8010577e:	78 60                	js     801057e0 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80105780:	83 ec 08             	sub    $0x8,%esp
80105783:	8d 45 f0             	lea    -0x10(%ebp),%eax
80105786:	50                   	push   %eax
80105787:	6a 01                	push   $0x1
80105789:	e8 f2 f4 ff ff       	call   80104c80 <argint>
  if((argstr(0, &path)) < 0 ||
8010578e:	83 c4 10             	add    $0x10,%esp
80105791:	85 c0                	test   %eax,%eax
80105793:	78 4b                	js     801057e0 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
80105795:	83 ec 08             	sub    $0x8,%esp
80105798:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010579b:	50                   	push   %eax
8010579c:	6a 02                	push   $0x2
8010579e:	e8 dd f4 ff ff       	call   80104c80 <argint>
     argint(1, &major) < 0 ||
801057a3:	83 c4 10             	add    $0x10,%esp
801057a6:	85 c0                	test   %eax,%eax
801057a8:	78 36                	js     801057e0 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
801057aa:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
801057ae:	83 ec 0c             	sub    $0xc,%esp
801057b1:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
801057b5:	ba 03 00 00 00       	mov    $0x3,%edx
801057ba:	50                   	push   %eax
801057bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
801057be:	e8 9d f6 ff ff       	call   80104e60 <create>
     argint(2, &minor) < 0 ||
801057c3:	83 c4 10             	add    $0x10,%esp
801057c6:	85 c0                	test   %eax,%eax
801057c8:	74 16                	je     801057e0 <sys_mknod+0x80>
    end_op();
    return -1;
  }
  iunlockput(ip);
801057ca:	83 ec 0c             	sub    $0xc,%esp
801057cd:	50                   	push   %eax
801057ce:	e8 ed c2 ff ff       	call   80101ac0 <iunlockput>
  end_op();
801057d3:	e8 a8 d6 ff ff       	call   80102e80 <end_op>
  return 0;
801057d8:	83 c4 10             	add    $0x10,%esp
801057db:	31 c0                	xor    %eax,%eax
}
801057dd:	c9                   	leave  
801057de:	c3                   	ret    
801057df:	90                   	nop
    end_op();
801057e0:	e8 9b d6 ff ff       	call   80102e80 <end_op>
    return -1;
801057e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801057ea:	c9                   	leave  
801057eb:	c3                   	ret    
801057ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801057f0 <sys_chdir>:

int
sys_chdir(void)
{
801057f0:	55                   	push   %ebp
801057f1:	89 e5                	mov    %esp,%ebp
801057f3:	56                   	push   %esi
801057f4:	53                   	push   %ebx
801057f5:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
801057f8:	e8 63 e4 ff ff       	call   80103c60 <myproc>
801057fd:	89 c6                	mov    %eax,%esi
  
  begin_op();
801057ff:	e8 0c d6 ff ff       	call   80102e10 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105804:	83 ec 08             	sub    $0x8,%esp
80105807:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010580a:	50                   	push   %eax
8010580b:	6a 00                	push   $0x0
8010580d:	e8 2e f5 ff ff       	call   80104d40 <argstr>
80105812:	83 c4 10             	add    $0x10,%esp
80105815:	85 c0                	test   %eax,%eax
80105817:	78 77                	js     80105890 <sys_chdir+0xa0>
80105819:	83 ec 0c             	sub    $0xc,%esp
8010581c:	ff 75 f4             	push   -0xc(%ebp)
8010581f:	e8 2c c9 ff ff       	call   80102150 <namei>
80105824:	83 c4 10             	add    $0x10,%esp
80105827:	89 c3                	mov    %eax,%ebx
80105829:	85 c0                	test   %eax,%eax
8010582b:	74 63                	je     80105890 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010582d:	83 ec 0c             	sub    $0xc,%esp
80105830:	50                   	push   %eax
80105831:	e8 fa bf ff ff       	call   80101830 <ilock>
  if(ip->type != T_DIR){
80105836:	83 c4 10             	add    $0x10,%esp
80105839:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010583e:	75 30                	jne    80105870 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105840:	83 ec 0c             	sub    $0xc,%esp
80105843:	53                   	push   %ebx
80105844:	e8 c7 c0 ff ff       	call   80101910 <iunlock>
  iput(curproc->cwd);
80105849:	58                   	pop    %eax
8010584a:	ff 76 68             	push   0x68(%esi)
8010584d:	e8 0e c1 ff ff       	call   80101960 <iput>
  end_op();
80105852:	e8 29 d6 ff ff       	call   80102e80 <end_op>
  curproc->cwd = ip;
80105857:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
8010585a:	83 c4 10             	add    $0x10,%esp
8010585d:	31 c0                	xor    %eax,%eax
}
8010585f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80105862:	5b                   	pop    %ebx
80105863:	5e                   	pop    %esi
80105864:	5d                   	pop    %ebp
80105865:	c3                   	ret    
80105866:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010586d:	8d 76 00             	lea    0x0(%esi),%esi
    iunlockput(ip);
80105870:	83 ec 0c             	sub    $0xc,%esp
80105873:	53                   	push   %ebx
80105874:	e8 47 c2 ff ff       	call   80101ac0 <iunlockput>
    end_op();
80105879:	e8 02 d6 ff ff       	call   80102e80 <end_op>
    return -1;
8010587e:	83 c4 10             	add    $0x10,%esp
80105881:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105886:	eb d7                	jmp    8010585f <sys_chdir+0x6f>
80105888:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010588f:	90                   	nop
    end_op();
80105890:	e8 eb d5 ff ff       	call   80102e80 <end_op>
    return -1;
80105895:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010589a:	eb c3                	jmp    8010585f <sys_chdir+0x6f>
8010589c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801058a0 <sys_exec>:

int
sys_exec(void)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058a5:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
{
801058ab:	53                   	push   %ebx
801058ac:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801058b2:	50                   	push   %eax
801058b3:	6a 00                	push   $0x0
801058b5:	e8 86 f4 ff ff       	call   80104d40 <argstr>
801058ba:	83 c4 10             	add    $0x10,%esp
801058bd:	85 c0                	test   %eax,%eax
801058bf:	0f 88 c7 00 00 00    	js     8010598c <sys_exec+0xec>
801058c5:	83 ec 08             	sub    $0x8,%esp
801058c8:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
801058ce:	50                   	push   %eax
801058cf:	6a 01                	push   $0x1
801058d1:	e8 aa f3 ff ff       	call   80104c80 <argint>
801058d6:	83 c4 10             	add    $0x10,%esp
801058d9:	85 c0                	test   %eax,%eax
801058db:	0f 88 ab 00 00 00    	js     8010598c <sys_exec+0xec>
    return -1;
  }

  struct inode *ip = namei(path);
801058e1:	83 ec 0c             	sub    $0xc,%esp
801058e4:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801058ea:	e8 61 c8 ff ff       	call   80102150 <namei>
  if (ip == 0)
801058ef:	83 c4 10             	add    $0x10,%esp
  struct inode *ip = namei(path);
801058f2:	89 c3                	mov    %eax,%ebx
  if (ip == 0)
801058f4:	85 c0                	test   %eax,%eax
801058f6:	0f 84 90 00 00 00    	je     8010598c <sys_exec+0xec>
    return -1;

  ilock(ip);
801058fc:	83 ec 0c             	sub    $0xc,%esp
801058ff:	50                   	push   %eax
80105900:	e8 2b bf ff ff       	call   80101830 <ilock>

  if (!(ip->mode & 0x4)) { // 0x4 = Execute
80105905:	83 c4 10             	add    $0x10,%esp
80105908:	f6 83 90 00 00 00 04 	testb  $0x4,0x90(%ebx)
8010590f:	0f 84 b0 00 00 00    	je     801059c5 <sys_exec+0x125>
    iunlockput(ip);
    cprintf("Operation execute failed\n");
    return -1;
  }

  iunlockput(ip);
80105915:	83 ec 0c             	sub    $0xc,%esp


  memset(argv, 0, sizeof(argv));
80105918:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
  iunlockput(ip);
8010591e:	53                   	push   %ebx
  for(i=0;; i++){
8010591f:	31 db                	xor    %ebx,%ebx
  iunlockput(ip);
80105921:	e8 9a c1 ff ff       	call   80101ac0 <iunlockput>
  memset(argv, 0, sizeof(argv));
80105926:	83 c4 0c             	add    $0xc,%esp
80105929:	68 80 00 00 00       	push   $0x80
8010592e:	6a 00                	push   $0x0
80105930:	56                   	push   %esi
80105931:	e8 8a f0 ff ff       	call   801049c0 <memset>
80105936:	83 c4 10             	add    $0x10,%esp
80105939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105940:	83 ec 08             	sub    $0x8,%esp
80105943:	8d 85 64 ff ff ff    	lea    -0x9c(%ebp),%eax
80105949:	8d 3c 9d 00 00 00 00 	lea    0x0(,%ebx,4),%edi
80105950:	50                   	push   %eax
80105951:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105957:	01 f8                	add    %edi,%eax
80105959:	50                   	push   %eax
8010595a:	e8 91 f2 ff ff       	call   80104bf0 <fetchint>
8010595f:	83 c4 10             	add    $0x10,%esp
80105962:	85 c0                	test   %eax,%eax
80105964:	78 26                	js     8010598c <sys_exec+0xec>
      return -1;
    if(uarg == 0){
80105966:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010596c:	85 c0                	test   %eax,%eax
8010596e:	74 30                	je     801059a0 <sys_exec+0x100>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105970:	83 ec 08             	sub    $0x8,%esp
80105973:	8d 14 3e             	lea    (%esi,%edi,1),%edx
80105976:	52                   	push   %edx
80105977:	50                   	push   %eax
80105978:	e8 b3 f2 ff ff       	call   80104c30 <fetchstr>
8010597d:	83 c4 10             	add    $0x10,%esp
80105980:	85 c0                	test   %eax,%eax
80105982:	78 08                	js     8010598c <sys_exec+0xec>
  for(i=0;; i++){
80105984:	83 c3 01             	add    $0x1,%ebx
    if(i >= NELEM(argv))
80105987:	83 fb 20             	cmp    $0x20,%ebx
8010598a:	75 b4                	jne    80105940 <sys_exec+0xa0>
    return -1;
8010598c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      return -1;
  }
  return exec(path, argv);
}
80105991:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105994:	5b                   	pop    %ebx
80105995:	5e                   	pop    %esi
80105996:	5f                   	pop    %edi
80105997:	5d                   	pop    %ebp
80105998:	c3                   	ret    
80105999:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      argv[i] = 0;
801059a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801059a7:	00 00 00 00 
  return exec(path, argv);
801059ab:	83 ec 08             	sub    $0x8,%esp
801059ae:	56                   	push   %esi
801059af:	ff b5 5c ff ff ff    	push   -0xa4(%ebp)
801059b5:	e8 56 b1 ff ff       	call   80100b10 <exec>
801059ba:	83 c4 10             	add    $0x10,%esp
}
801059bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
801059c0:	5b                   	pop    %ebx
801059c1:	5e                   	pop    %esi
801059c2:	5f                   	pop    %edi
801059c3:	5d                   	pop    %ebp
801059c4:	c3                   	ret    
    iunlockput(ip);
801059c5:	83 ec 0c             	sub    $0xc,%esp
801059c8:	53                   	push   %ebx
801059c9:	e8 f2 c0 ff ff       	call   80101ac0 <iunlockput>
    cprintf("Operation execute failed\n");
801059ce:	c7 04 24 f8 7e 10 80 	movl   $0x80107ef8,(%esp)
801059d5:	e8 c6 ac ff ff       	call   801006a0 <cprintf>
    return -1;
801059da:	83 c4 10             	add    $0x10,%esp
801059dd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801059e2:	eb ad                	jmp    80105991 <sys_exec+0xf1>
801059e4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801059eb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801059ef:	90                   	nop

801059f0 <sys_pipe>:

int
sys_pipe(void)
{
801059f0:	55                   	push   %ebp
801059f1:	89 e5                	mov    %esp,%ebp
801059f3:	57                   	push   %edi
801059f4:	56                   	push   %esi
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059f5:	8d 45 dc             	lea    -0x24(%ebp),%eax
{
801059f8:	53                   	push   %ebx
801059f9:	83 ec 20             	sub    $0x20,%esp
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801059fc:	6a 08                	push   $0x8
801059fe:	50                   	push   %eax
801059ff:	6a 00                	push   $0x0
80105a01:	e8 ca f2 ff ff       	call   80104cd0 <argptr>
80105a06:	83 c4 10             	add    $0x10,%esp
80105a09:	85 c0                	test   %eax,%eax
80105a0b:	78 4a                	js     80105a57 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
80105a0d:	83 ec 08             	sub    $0x8,%esp
80105a10:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105a13:	50                   	push   %eax
80105a14:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105a17:	50                   	push   %eax
80105a18:	e8 c3 da ff ff       	call   801034e0 <pipealloc>
80105a1d:	83 c4 10             	add    $0x10,%esp
80105a20:	85 c0                	test   %eax,%eax
80105a22:	78 33                	js     80105a57 <sys_pipe+0x67>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a24:	8b 7d e0             	mov    -0x20(%ebp),%edi
  for(fd = 0; fd < NOFILE; fd++){
80105a27:	31 db                	xor    %ebx,%ebx
  struct proc *curproc = myproc();
80105a29:	e8 32 e2 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a2e:	66 90                	xchg   %ax,%ax
    if(curproc->ofile[fd] == 0){
80105a30:	8b 74 98 28          	mov    0x28(%eax,%ebx,4),%esi
80105a34:	85 f6                	test   %esi,%esi
80105a36:	74 28                	je     80105a60 <sys_pipe+0x70>
  for(fd = 0; fd < NOFILE; fd++){
80105a38:	83 c3 01             	add    $0x1,%ebx
80105a3b:	83 fb 10             	cmp    $0x10,%ebx
80105a3e:	75 f0                	jne    80105a30 <sys_pipe+0x40>
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105a40:	83 ec 0c             	sub    $0xc,%esp
80105a43:	ff 75 e0             	push   -0x20(%ebp)
80105a46:	e8 35 b5 ff ff       	call   80100f80 <fileclose>
    fileclose(wf);
80105a4b:	58                   	pop    %eax
80105a4c:	ff 75 e4             	push   -0x1c(%ebp)
80105a4f:	e8 2c b5 ff ff       	call   80100f80 <fileclose>
    return -1;
80105a54:	83 c4 10             	add    $0x10,%esp
80105a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105a5c:	eb 53                	jmp    80105ab1 <sys_pipe+0xc1>
80105a5e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105a60:	8d 73 08             	lea    0x8(%ebx),%esi
80105a63:	89 7c b0 08          	mov    %edi,0x8(%eax,%esi,4)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105a67:	8b 7d e4             	mov    -0x1c(%ebp),%edi
  struct proc *curproc = myproc();
80105a6a:	e8 f1 e1 ff ff       	call   80103c60 <myproc>
  for(fd = 0; fd < NOFILE; fd++){
80105a6f:	31 d2                	xor    %edx,%edx
80105a71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105a78:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80105a7c:	85 c9                	test   %ecx,%ecx
80105a7e:	74 20                	je     80105aa0 <sys_pipe+0xb0>
  for(fd = 0; fd < NOFILE; fd++){
80105a80:	83 c2 01             	add    $0x1,%edx
80105a83:	83 fa 10             	cmp    $0x10,%edx
80105a86:	75 f0                	jne    80105a78 <sys_pipe+0x88>
      myproc()->ofile[fd0] = 0;
80105a88:	e8 d3 e1 ff ff       	call   80103c60 <myproc>
80105a8d:	c7 44 b0 08 00 00 00 	movl   $0x0,0x8(%eax,%esi,4)
80105a94:	00 
80105a95:	eb a9                	jmp    80105a40 <sys_pipe+0x50>
80105a97:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105a9e:	66 90                	xchg   %ax,%ax
      curproc->ofile[fd] = f;
80105aa0:	89 7c 90 28          	mov    %edi,0x28(%eax,%edx,4)
  }
  fd[0] = fd0;
80105aa4:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aa7:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105aa9:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105aac:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
80105aaf:	31 c0                	xor    %eax,%eax
}
80105ab1:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105ab4:	5b                   	pop    %ebx
80105ab5:	5e                   	pop    %esi
80105ab6:	5f                   	pop    %edi
80105ab7:	5d                   	pop    %ebp
80105ab8:	c3                   	ret    
80105ab9:	66 90                	xchg   %ax,%ax
80105abb:	66 90                	xchg   %ax,%ax
80105abd:	66 90                	xchg   %ax,%ax
80105abf:	90                   	nop

80105ac0 <sys_fork>:
#include "file.h"

int
sys_fork(void)
{
  return fork();
80105ac0:	e9 3b e3 ff ff       	jmp    80103e00 <fork>
80105ac5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105acc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105ad0 <sys_exit>:
}

int
sys_exit(void)
{
80105ad0:	55                   	push   %ebp
80105ad1:	89 e5                	mov    %esp,%ebp
80105ad3:	83 ec 08             	sub    $0x8,%esp
  exit();
80105ad6:	e8 d5 e5 ff ff       	call   801040b0 <exit>
  return 0;  // not reached
}
80105adb:	31 c0                	xor    %eax,%eax
80105add:	c9                   	leave  
80105ade:	c3                   	ret    
80105adf:	90                   	nop

80105ae0 <sys_wait>:

int
sys_wait(void)
{
  return wait();
80105ae0:	e9 3b e7 ff ff       	jmp    80104220 <wait>
80105ae5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105aec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105af0 <sys_kill>:
}

int
sys_kill(void)
{
80105af0:	55                   	push   %ebp
80105af1:	89 e5                	mov    %esp,%ebp
80105af3:	83 ec 20             	sub    $0x20,%esp
  int pid;

  if(argint(0, &pid) < 0)
80105af6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105af9:	50                   	push   %eax
80105afa:	6a 00                	push   $0x0
80105afc:	e8 7f f1 ff ff       	call   80104c80 <argint>
80105b01:	83 c4 10             	add    $0x10,%esp
80105b04:	85 c0                	test   %eax,%eax
80105b06:	78 18                	js     80105b20 <sys_kill+0x30>
    return -1;
  return kill(pid);
80105b08:	83 ec 0c             	sub    $0xc,%esp
80105b0b:	ff 75 f4             	push   -0xc(%ebp)
80105b0e:	e8 ad e9 ff ff       	call   801044c0 <kill>
80105b13:	83 c4 10             	add    $0x10,%esp
}
80105b16:	c9                   	leave  
80105b17:	c3                   	ret    
80105b18:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b1f:	90                   	nop
80105b20:	c9                   	leave  
    return -1;
80105b21:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105b26:	c3                   	ret    
80105b27:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b2e:	66 90                	xchg   %ax,%ax

80105b30 <sys_getpid>:

int
sys_getpid(void)
{
80105b30:	55                   	push   %ebp
80105b31:	89 e5                	mov    %esp,%ebp
80105b33:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
80105b36:	e8 25 e1 ff ff       	call   80103c60 <myproc>
80105b3b:	8b 40 10             	mov    0x10(%eax),%eax
}
80105b3e:	c9                   	leave  
80105b3f:	c3                   	ret    

80105b40 <sys_sbrk>:

int
sys_sbrk(void)
{
80105b40:	55                   	push   %ebp
80105b41:	89 e5                	mov    %esp,%ebp
80105b43:	53                   	push   %ebx
  int addr;
  int n;

  if(argint(0, &n) < 0)
80105b44:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b47:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b4a:	50                   	push   %eax
80105b4b:	6a 00                	push   $0x0
80105b4d:	e8 2e f1 ff ff       	call   80104c80 <argint>
80105b52:	83 c4 10             	add    $0x10,%esp
80105b55:	85 c0                	test   %eax,%eax
80105b57:	78 27                	js     80105b80 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
80105b59:	e8 02 e1 ff ff       	call   80103c60 <myproc>
  if(growproc(n) < 0)
80105b5e:	83 ec 0c             	sub    $0xc,%esp
  addr = myproc()->sz;
80105b61:	8b 18                	mov    (%eax),%ebx
  if(growproc(n) < 0)
80105b63:	ff 75 f4             	push   -0xc(%ebp)
80105b66:	e8 15 e2 ff ff       	call   80103d80 <growproc>
80105b6b:	83 c4 10             	add    $0x10,%esp
80105b6e:	85 c0                	test   %eax,%eax
80105b70:	78 0e                	js     80105b80 <sys_sbrk+0x40>
    return -1;
  return addr;
}
80105b72:	89 d8                	mov    %ebx,%eax
80105b74:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105b77:	c9                   	leave  
80105b78:	c3                   	ret    
80105b79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
80105b80:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
80105b85:	eb eb                	jmp    80105b72 <sys_sbrk+0x32>
80105b87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <sys_sleep>:

int
sys_sleep(void)
{
80105b90:	55                   	push   %ebp
80105b91:	89 e5                	mov    %esp,%ebp
80105b93:	53                   	push   %ebx
  int n;
  uint ticks0;

  if(argint(0, &n) < 0)
80105b94:	8d 45 f4             	lea    -0xc(%ebp),%eax
{
80105b97:	83 ec 1c             	sub    $0x1c,%esp
  if(argint(0, &n) < 0)
80105b9a:	50                   	push   %eax
80105b9b:	6a 00                	push   $0x0
80105b9d:	e8 de f0 ff ff       	call   80104c80 <argint>
80105ba2:	83 c4 10             	add    $0x10,%esp
80105ba5:	85 c0                	test   %eax,%eax
80105ba7:	0f 88 8a 00 00 00    	js     80105c37 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105bad:	83 ec 0c             	sub    $0xc,%esp
80105bb0:	68 c0 d6 11 80       	push   $0x8011d6c0
80105bb5:	e8 46 ed ff ff       	call   80104900 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
80105bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  ticks0 = ticks;
80105bbd:	8b 1d a0 d6 11 80    	mov    0x8011d6a0,%ebx
  while(ticks - ticks0 < n){
80105bc3:	83 c4 10             	add    $0x10,%esp
80105bc6:	85 d2                	test   %edx,%edx
80105bc8:	75 27                	jne    80105bf1 <sys_sleep+0x61>
80105bca:	eb 54                	jmp    80105c20 <sys_sleep+0x90>
80105bcc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(myproc()->killed){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105bd0:	83 ec 08             	sub    $0x8,%esp
80105bd3:	68 c0 d6 11 80       	push   $0x8011d6c0
80105bd8:	68 a0 d6 11 80       	push   $0x8011d6a0
80105bdd:	e8 be e7 ff ff       	call   801043a0 <sleep>
  while(ticks - ticks0 < n){
80105be2:	a1 a0 d6 11 80       	mov    0x8011d6a0,%eax
80105be7:	83 c4 10             	add    $0x10,%esp
80105bea:	29 d8                	sub    %ebx,%eax
80105bec:	3b 45 f4             	cmp    -0xc(%ebp),%eax
80105bef:	73 2f                	jae    80105c20 <sys_sleep+0x90>
    if(myproc()->killed){
80105bf1:	e8 6a e0 ff ff       	call   80103c60 <myproc>
80105bf6:	8b 40 24             	mov    0x24(%eax),%eax
80105bf9:	85 c0                	test   %eax,%eax
80105bfb:	74 d3                	je     80105bd0 <sys_sleep+0x40>
      release(&tickslock);
80105bfd:	83 ec 0c             	sub    $0xc,%esp
80105c00:	68 c0 d6 11 80       	push   $0x8011d6c0
80105c05:	e8 96 ec ff ff       	call   801048a0 <release>
  }
  release(&tickslock);
  return 0;
}
80105c0a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
      return -1;
80105c0d:	83 c4 10             	add    $0x10,%esp
80105c10:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105c15:	c9                   	leave  
80105c16:	c3                   	ret    
80105c17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c1e:	66 90                	xchg   %ax,%ax
  release(&tickslock);
80105c20:	83 ec 0c             	sub    $0xc,%esp
80105c23:	68 c0 d6 11 80       	push   $0x8011d6c0
80105c28:	e8 73 ec ff ff       	call   801048a0 <release>
  return 0;
80105c2d:	83 c4 10             	add    $0x10,%esp
80105c30:	31 c0                	xor    %eax,%eax
}
80105c32:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c35:	c9                   	leave  
80105c36:	c3                   	ret    
    return -1;
80105c37:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105c3c:	eb f4                	jmp    80105c32 <sys_sleep+0xa2>
80105c3e:	66 90                	xchg   %ax,%ax

80105c40 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105c40:	55                   	push   %ebp
80105c41:	89 e5                	mov    %esp,%ebp
80105c43:	53                   	push   %ebx
80105c44:	83 ec 10             	sub    $0x10,%esp
  uint xticks;

  acquire(&tickslock);
80105c47:	68 c0 d6 11 80       	push   $0x8011d6c0
80105c4c:	e8 af ec ff ff       	call   80104900 <acquire>
  xticks = ticks;
80105c51:	8b 1d a0 d6 11 80    	mov    0x8011d6a0,%ebx
  release(&tickslock);
80105c57:	c7 04 24 c0 d6 11 80 	movl   $0x8011d6c0,(%esp)
80105c5e:	e8 3d ec ff ff       	call   801048a0 <release>
  return xticks;
}
80105c63:	89 d8                	mov    %ebx,%eax
80105c65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105c68:	c9                   	leave  
80105c69:	c3                   	ret    
80105c6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c70 <sys_gethistory>:

int
sys_gethistory(void)
{   
  
  return gethistory();
80105c70:	e9 fb dd ff ff       	jmp    80103a70 <gethistory>
80105c75:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c80 <sys_block>:

#define MAX_SYSCALL 64  // Adjust based on the highest syscall number

// int blocked_syscalls[MAX_SYSCALL] = {0}; // 0 means unblocked

int sys_block(void) {
80105c80:	55                   	push   %ebp
80105c81:	89 e5                	mov    %esp,%ebp
80105c83:	83 ec 20             	sub    $0x20,%esp
  int syscall_id;
  if (argint(0, &syscall_id) < 0)
80105c86:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105c89:	50                   	push   %eax
80105c8a:	6a 00                	push   $0x0
80105c8c:	e8 ef ef ff ff       	call   80104c80 <argint>
80105c91:	83 c4 10             	add    $0x10,%esp
80105c94:	85 c0                	test   %eax,%eax
80105c96:	78 28                	js     80105cc0 <sys_block+0x40>
    return -1;
  
  // Prevent blocking fork or exit
  if (syscall_id == 1 || syscall_id == 2)
80105c98:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105c9b:	83 e8 01             	sub    $0x1,%eax
80105c9e:	83 f8 01             	cmp    $0x1,%eax
80105ca1:	76 1d                	jbe    80105cc0 <sys_block+0x40>
    return -1;

  struct proc *p = myproc();
80105ca3:	e8 b8 df ff ff       	call   80103c60 <myproc>
  p->blocked_syscalls[syscall_id] = 1;
80105ca8:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cab:	c7 84 90 7c 01 00 00 	movl   $0x1,0x17c(%eax,%edx,4)
80105cb2:	01 00 00 00 
  

  return 0;
80105cb6:	31 c0                	xor    %eax,%eax
}
80105cb8:	c9                   	leave  
80105cb9:	c3                   	ret    
80105cba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80105cc0:	c9                   	leave  
    return -1;
80105cc1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105cc6:	c3                   	ret    
80105cc7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105cce:	66 90                	xchg   %ax,%ax

80105cd0 <sys_unblock>:

int sys_unblock(void) {
80105cd0:	55                   	push   %ebp
80105cd1:	89 e5                	mov    %esp,%ebp
80105cd3:	83 ec 20             	sub    $0x20,%esp
  int syscall_id;
  if (argint(0, &syscall_id) < 0)
80105cd6:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105cd9:	50                   	push   %eax
80105cda:	6a 00                	push   $0x0
80105cdc:	e8 9f ef ff ff       	call   80104c80 <argint>
80105ce1:	83 c4 10             	add    $0x10,%esp
80105ce4:	85 c0                	test   %eax,%eax
80105ce6:	78 28                	js     80105d10 <sys_unblock+0x40>
    return -1;

  struct proc *p = myproc();
80105ce8:	e8 73 df ff ff       	call   80103c60 <myproc>
  if(p->pass_syscalls[syscall_id] == 1){
80105ced:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105cf0:	83 7c 90 7c 01       	cmpl   $0x1,0x7c(%eax,%edx,4)
80105cf5:	74 19                	je     80105d10 <sys_unblock+0x40>
    return -1;
  }
  p->blocked_syscalls[syscall_id] = 0;
80105cf7:	c7 84 90 7c 01 00 00 	movl   $0x0,0x17c(%eax,%edx,4)
80105cfe:	00 00 00 00 
  return 0;
80105d02:	31 c0                	xor    %eax,%eax
}
80105d04:	c9                   	leave  
80105d05:	c3                   	ret    
80105d06:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d0d:	8d 76 00             	lea    0x0(%esi),%esi
80105d10:	c9                   	leave  
    return -1;
80105d11:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80105d16:	c3                   	ret    
80105d17:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105d1e:	66 90                	xchg   %ax,%ax

80105d20 <sys_chmod>:


// Function to handle the chmod system call
int
sys_chmod(void)
{
80105d20:	55                   	push   %ebp
80105d21:	89 e5                	mov    %esp,%ebp
80105d23:	53                   	push   %ebx
  char *file;
  int mode;

  // Get the filename and mode from user space
  if (argstr(0, &file) < 0 || argint(1, &mode) < 0) {
80105d24:	8d 45 f0             	lea    -0x10(%ebp),%eax
{
80105d27:	83 ec 1c             	sub    $0x1c,%esp
  if (argstr(0, &file) < 0 || argint(1, &mode) < 0) {
80105d2a:	50                   	push   %eax
80105d2b:	6a 00                	push   $0x0
80105d2d:	e8 0e f0 ff ff       	call   80104d40 <argstr>
80105d32:	83 c4 10             	add    $0x10,%esp
80105d35:	85 c0                	test   %eax,%eax
80105d37:	78 77                	js     80105db0 <sys_chmod+0x90>
80105d39:	83 ec 08             	sub    $0x8,%esp
80105d3c:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105d3f:	50                   	push   %eax
80105d40:	6a 01                	push   $0x1
80105d42:	e8 39 ef ff ff       	call   80104c80 <argint>
80105d47:	83 c4 10             	add    $0x10,%esp
80105d4a:	85 c0                	test   %eax,%eax
80105d4c:	78 62                	js     80105db0 <sys_chmod+0x90>
    return -1; // Invalid arguments
  }

  // Validate the mode (3-bit integer)
  if (mode < 0 || mode > 7) {
80105d4e:	83 7d f4 07          	cmpl   $0x7,-0xc(%ebp)
80105d52:	77 5c                	ja     80105db0 <sys_chmod+0x90>
    return -1; // Invalid mode
  }

  // Find the file in the file system
  struct inode *ip = namei(file);
80105d54:	83 ec 0c             	sub    $0xc,%esp
80105d57:	ff 75 f0             	push   -0x10(%ebp)
80105d5a:	e8 f1 c3 ff ff       	call   80102150 <namei>
80105d5f:	89 c3                	mov    %eax,%ebx
  begin_op();
80105d61:	e8 aa d0 ff ff       	call   80102e10 <begin_op>
  if (ip == 0) {
80105d66:	83 c4 10             	add    $0x10,%esp
80105d69:	85 db                	test   %ebx,%ebx
80105d6b:	74 34                	je     80105da1 <sys_chmod+0x81>
    end_op();
    return -1; // File not found
  }

  // Acquire the inode lock
  ilock(ip);
80105d6d:	83 ec 0c             	sub    $0xc,%esp
80105d70:	53                   	push   %ebx
80105d71:	e8 ba ba ff ff       	call   80101830 <ilock>

  // Update the file's mode (permissions)
  ip->mode = mode & 0x7;
80105d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105d79:	83 e0 07             	and    $0x7,%eax
80105d7c:	89 83 90 00 00 00    	mov    %eax,0x90(%ebx)

  // Mark the inode as dirty
  iupdate(ip);
80105d82:	89 1c 24             	mov    %ebx,(%esp)
80105d85:	e8 e6 b9 ff ff       	call   80101770 <iupdate>

  // Release the inode lock
  iunlock(ip);
80105d8a:	89 1c 24             	mov    %ebx,(%esp)
80105d8d:	e8 7e bb ff ff       	call   80101910 <iunlock>

  end_op();
80105d92:	e8 e9 d0 ff ff       	call   80102e80 <end_op>
  return 0; // Success
80105d97:	83 c4 10             	add    $0x10,%esp
80105d9a:	31 c0                	xor    %eax,%eax
80105d9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105d9f:	c9                   	leave  
80105da0:	c3                   	ret    
    end_op();
80105da1:	e8 da d0 ff ff       	call   80102e80 <end_op>
80105da6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105dad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1; // File not found
80105db0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105db5:	eb e5                	jmp    80105d9c <sys_chmod+0x7c>

80105db7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105db7:	1e                   	push   %ds
  pushl %es
80105db8:	06                   	push   %es
  pushl %fs
80105db9:	0f a0                	push   %fs
  pushl %gs
80105dbb:	0f a8                	push   %gs
  pushal
80105dbd:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105dbe:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
80105dc2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
80105dc4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105dc6:	54                   	push   %esp
  call trap
80105dc7:	e8 c4 00 00 00       	call   80105e90 <trap>
  addl $4, %esp
80105dcc:	83 c4 04             	add    $0x4,%esp

80105dcf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105dcf:	61                   	popa   
  popl %gs
80105dd0:	0f a9                	pop    %gs
  popl %fs
80105dd2:	0f a1                	pop    %fs
  popl %es
80105dd4:	07                   	pop    %es
  popl %ds
80105dd5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105dd6:	83 c4 08             	add    $0x8,%esp
  iret
80105dd9:	cf                   	iret   
80105dda:	66 90                	xchg   %ax,%ax
80105ddc:	66 90                	xchg   %ax,%ax
80105dde:	66 90                	xchg   %ax,%ax

80105de0 <tvinit>:
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105de0:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
80105de1:	31 c0                	xor    %eax,%eax
{
80105de3:	89 e5                	mov    %esp,%ebp
80105de5:	83 ec 08             	sub    $0x8,%esp
80105de8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105def:	90                   	nop
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105df0:	8b 14 85 08 b0 10 80 	mov    -0x7fef4ff8(,%eax,4),%edx
80105df7:	c7 04 c5 02 d7 11 80 	movl   $0x8e000008,-0x7fee28fe(,%eax,8)
80105dfe:	08 00 00 8e 
80105e02:	66 89 14 c5 00 d7 11 	mov    %dx,-0x7fee2900(,%eax,8)
80105e09:	80 
80105e0a:	c1 ea 10             	shr    $0x10,%edx
80105e0d:	66 89 14 c5 06 d7 11 	mov    %dx,-0x7fee28fa(,%eax,8)
80105e14:	80 
  for(i = 0; i < 256; i++)
80105e15:	83 c0 01             	add    $0x1,%eax
80105e18:	3d 00 01 00 00       	cmp    $0x100,%eax
80105e1d:	75 d1                	jne    80105df0 <tvinit+0x10>
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);

  initlock(&tickslock, "time");
80105e1f:	83 ec 08             	sub    $0x8,%esp
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e22:	a1 08 b1 10 80       	mov    0x8010b108,%eax
80105e27:	c7 05 02 d9 11 80 08 	movl   $0xef000008,0x8011d902
80105e2e:	00 00 ef 
  initlock(&tickslock, "time");
80105e31:	68 12 7f 10 80       	push   $0x80107f12
80105e36:	68 c0 d6 11 80       	push   $0x8011d6c0
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105e3b:	66 a3 00 d9 11 80    	mov    %ax,0x8011d900
80105e41:	c1 e8 10             	shr    $0x10,%eax
80105e44:	66 a3 06 d9 11 80    	mov    %ax,0x8011d906
  initlock(&tickslock, "time");
80105e4a:	e8 e1 e8 ff ff       	call   80104730 <initlock>
}
80105e4f:	83 c4 10             	add    $0x10,%esp
80105e52:	c9                   	leave  
80105e53:	c3                   	ret    
80105e54:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105e5f:	90                   	nop

80105e60 <idtinit>:

void
idtinit(void)
{
80105e60:	55                   	push   %ebp
  pd[0] = size-1;
80105e61:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105e66:	89 e5                	mov    %esp,%ebp
80105e68:	83 ec 10             	sub    $0x10,%esp
80105e6b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
80105e6f:	b8 00 d7 11 80       	mov    $0x8011d700,%eax
80105e74:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105e78:	c1 e8 10             	shr    $0x10,%eax
80105e7b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)
  asm volatile("lidt (%0)" : : "r" (pd));
80105e7f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105e82:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105e85:	c9                   	leave  
80105e86:	c3                   	ret    
80105e87:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105e8e:	66 90                	xchg   %ax,%ax

80105e90 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105e90:	55                   	push   %ebp
80105e91:	89 e5                	mov    %esp,%ebp
80105e93:	57                   	push   %edi
80105e94:	56                   	push   %esi
80105e95:	53                   	push   %ebx
80105e96:	83 ec 1c             	sub    $0x1c,%esp
80105e99:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
80105e9c:	8b 43 30             	mov    0x30(%ebx),%eax
80105e9f:	83 f8 40             	cmp    $0x40,%eax
80105ea2:	0f 84 68 01 00 00    	je     80106010 <trap+0x180>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105ea8:	83 e8 20             	sub    $0x20,%eax
80105eab:	83 f8 1f             	cmp    $0x1f,%eax
80105eae:	0f 87 8c 00 00 00    	ja     80105f40 <trap+0xb0>
80105eb4:	ff 24 85 b8 7f 10 80 	jmp    *-0x7fef8048(,%eax,4)
80105ebb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105ebf:	90                   	nop
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ec0:	e8 2b c4 ff ff       	call   801022f0 <ideintr>
    lapiceoi();
80105ec5:	e8 f6 ca ff ff       	call   801029c0 <lapiceoi>
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105eca:	e8 91 dd ff ff       	call   80103c60 <myproc>
80105ecf:	85 c0                	test   %eax,%eax
80105ed1:	74 1d                	je     80105ef0 <trap+0x60>
80105ed3:	e8 88 dd ff ff       	call   80103c60 <myproc>
80105ed8:	8b 50 24             	mov    0x24(%eax),%edx
80105edb:	85 d2                	test   %edx,%edx
80105edd:	74 11                	je     80105ef0 <trap+0x60>
80105edf:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105ee3:	83 e0 03             	and    $0x3,%eax
80105ee6:	66 83 f8 03          	cmp    $0x3,%ax
80105eea:	0f 84 e8 01 00 00    	je     801060d8 <trap+0x248>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105ef0:	e8 6b dd ff ff       	call   80103c60 <myproc>
80105ef5:	85 c0                	test   %eax,%eax
80105ef7:	74 0f                	je     80105f08 <trap+0x78>
80105ef9:	e8 62 dd ff ff       	call   80103c60 <myproc>
80105efe:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
80105f02:	0f 84 b8 00 00 00    	je     80105fc0 <trap+0x130>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105f08:	e8 53 dd ff ff       	call   80103c60 <myproc>
80105f0d:	85 c0                	test   %eax,%eax
80105f0f:	74 1d                	je     80105f2e <trap+0x9e>
80105f11:	e8 4a dd ff ff       	call   80103c60 <myproc>
80105f16:	8b 40 24             	mov    0x24(%eax),%eax
80105f19:	85 c0                	test   %eax,%eax
80105f1b:	74 11                	je     80105f2e <trap+0x9e>
80105f1d:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105f21:	83 e0 03             	and    $0x3,%eax
80105f24:	66 83 f8 03          	cmp    $0x3,%ax
80105f28:	0f 84 0f 01 00 00    	je     8010603d <trap+0x1ad>
    exit();
}
80105f2e:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105f31:	5b                   	pop    %ebx
80105f32:	5e                   	pop    %esi
80105f33:	5f                   	pop    %edi
80105f34:	5d                   	pop    %ebp
80105f35:	c3                   	ret    
80105f36:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105f3d:	8d 76 00             	lea    0x0(%esi),%esi
    if(myproc() == 0 || (tf->cs&3) == 0){
80105f40:	e8 1b dd ff ff       	call   80103c60 <myproc>
80105f45:	8b 7b 38             	mov    0x38(%ebx),%edi
80105f48:	85 c0                	test   %eax,%eax
80105f4a:	0f 84 a2 01 00 00    	je     801060f2 <trap+0x262>
80105f50:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
80105f54:	0f 84 98 01 00 00    	je     801060f2 <trap+0x262>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105f5a:	0f 20 d1             	mov    %cr2,%ecx
80105f5d:	89 4d d8             	mov    %ecx,-0x28(%ebp)
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f60:	e8 db dc ff ff       	call   80103c40 <cpuid>
80105f65:	8b 73 30             	mov    0x30(%ebx),%esi
80105f68:	89 45 dc             	mov    %eax,-0x24(%ebp)
80105f6b:	8b 43 34             	mov    0x34(%ebx),%eax
80105f6e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            myproc()->pid, myproc()->name, tf->trapno,
80105f71:	e8 ea dc ff ff       	call   80103c60 <myproc>
80105f76:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105f79:	e8 e2 dc ff ff       	call   80103c60 <myproc>
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f7e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105f81:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105f84:	51                   	push   %ecx
80105f85:	57                   	push   %edi
80105f86:	52                   	push   %edx
80105f87:	ff 75 e4             	push   -0x1c(%ebp)
80105f8a:	56                   	push   %esi
            myproc()->pid, myproc()->name, tf->trapno,
80105f8b:	8b 75 e0             	mov    -0x20(%ebp),%esi
80105f8e:	83 c6 6c             	add    $0x6c,%esi
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105f91:	56                   	push   %esi
80105f92:	ff 70 10             	push   0x10(%eax)
80105f95:	68 74 7f 10 80       	push   $0x80107f74
80105f9a:	e8 01 a7 ff ff       	call   801006a0 <cprintf>
    myproc()->killed = 1;
80105f9f:	83 c4 20             	add    $0x20,%esp
80105fa2:	e8 b9 dc ff ff       	call   80103c60 <myproc>
80105fa7:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105fae:	e8 ad dc ff ff       	call   80103c60 <myproc>
80105fb3:	85 c0                	test   %eax,%eax
80105fb5:	0f 85 18 ff ff ff    	jne    80105ed3 <trap+0x43>
80105fbb:	e9 30 ff ff ff       	jmp    80105ef0 <trap+0x60>
  if(myproc() && myproc()->state == RUNNING &&
80105fc0:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105fc4:	0f 85 3e ff ff ff    	jne    80105f08 <trap+0x78>
    yield();
80105fca:	e8 81 e3 ff ff       	call   80104350 <yield>
80105fcf:	e9 34 ff ff ff       	jmp    80105f08 <trap+0x78>
80105fd4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105fd8:	8b 7b 38             	mov    0x38(%ebx),%edi
80105fdb:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105fdf:	e8 5c dc ff ff       	call   80103c40 <cpuid>
80105fe4:	57                   	push   %edi
80105fe5:	56                   	push   %esi
80105fe6:	50                   	push   %eax
80105fe7:	68 1c 7f 10 80       	push   $0x80107f1c
80105fec:	e8 af a6 ff ff       	call   801006a0 <cprintf>
    lapiceoi();
80105ff1:	e8 ca c9 ff ff       	call   801029c0 <lapiceoi>
    break;
80105ff6:	83 c4 10             	add    $0x10,%esp
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105ff9:	e8 62 dc ff ff       	call   80103c60 <myproc>
80105ffe:	85 c0                	test   %eax,%eax
80106000:	0f 85 cd fe ff ff    	jne    80105ed3 <trap+0x43>
80106006:	e9 e5 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010600b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010600f:	90                   	nop
    if(myproc()->killed)
80106010:	e8 4b dc ff ff       	call   80103c60 <myproc>
80106015:	8b 70 24             	mov    0x24(%eax),%esi
80106018:	85 f6                	test   %esi,%esi
8010601a:	0f 85 c8 00 00 00    	jne    801060e8 <trap+0x258>
    myproc()->tf = tf;
80106020:	e8 3b dc ff ff       	call   80103c60 <myproc>
80106025:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80106028:	e8 93 ed ff ff       	call   80104dc0 <syscall>
    if(myproc()->killed)
8010602d:	e8 2e dc ff ff       	call   80103c60 <myproc>
80106032:	8b 48 24             	mov    0x24(%eax),%ecx
80106035:	85 c9                	test   %ecx,%ecx
80106037:	0f 84 f1 fe ff ff    	je     80105f2e <trap+0x9e>
}
8010603d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106040:	5b                   	pop    %ebx
80106041:	5e                   	pop    %esi
80106042:	5f                   	pop    %edi
80106043:	5d                   	pop    %ebp
      exit();
80106044:	e9 67 e0 ff ff       	jmp    801040b0 <exit>
80106049:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    uartintr();
80106050:	e8 3b 02 00 00       	call   80106290 <uartintr>
    lapiceoi();
80106055:	e8 66 c9 ff ff       	call   801029c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010605a:	e8 01 dc ff ff       	call   80103c60 <myproc>
8010605f:	85 c0                	test   %eax,%eax
80106061:	0f 85 6c fe ff ff    	jne    80105ed3 <trap+0x43>
80106067:	e9 84 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010606c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    kbdintr();
80106070:	e8 0b c8 ff ff       	call   80102880 <kbdintr>
    lapiceoi();
80106075:	e8 46 c9 ff ff       	call   801029c0 <lapiceoi>
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
8010607a:	e8 e1 db ff ff       	call   80103c60 <myproc>
8010607f:	85 c0                	test   %eax,%eax
80106081:	0f 85 4c fe ff ff    	jne    80105ed3 <trap+0x43>
80106087:	e9 64 fe ff ff       	jmp    80105ef0 <trap+0x60>
8010608c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(cpuid() == 0){
80106090:	e8 ab db ff ff       	call   80103c40 <cpuid>
80106095:	85 c0                	test   %eax,%eax
80106097:	0f 85 28 fe ff ff    	jne    80105ec5 <trap+0x35>
      acquire(&tickslock);
8010609d:	83 ec 0c             	sub    $0xc,%esp
801060a0:	68 c0 d6 11 80       	push   $0x8011d6c0
801060a5:	e8 56 e8 ff ff       	call   80104900 <acquire>
      wakeup(&ticks);
801060aa:	c7 04 24 a0 d6 11 80 	movl   $0x8011d6a0,(%esp)
      ticks++;
801060b1:	83 05 a0 d6 11 80 01 	addl   $0x1,0x8011d6a0
      wakeup(&ticks);
801060b8:	e8 a3 e3 ff ff       	call   80104460 <wakeup>
      release(&tickslock);
801060bd:	c7 04 24 c0 d6 11 80 	movl   $0x8011d6c0,(%esp)
801060c4:	e8 d7 e7 ff ff       	call   801048a0 <release>
801060c9:	83 c4 10             	add    $0x10,%esp
    lapiceoi();
801060cc:	e9 f4 fd ff ff       	jmp    80105ec5 <trap+0x35>
801060d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    exit();
801060d8:	e8 d3 df ff ff       	call   801040b0 <exit>
801060dd:	e9 0e fe ff ff       	jmp    80105ef0 <trap+0x60>
801060e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      exit();
801060e8:	e8 c3 df ff ff       	call   801040b0 <exit>
801060ed:	e9 2e ff ff ff       	jmp    80106020 <trap+0x190>
801060f2:	0f 20 d6             	mov    %cr2,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
801060f5:	e8 46 db ff ff       	call   80103c40 <cpuid>
801060fa:	83 ec 0c             	sub    $0xc,%esp
801060fd:	56                   	push   %esi
801060fe:	57                   	push   %edi
801060ff:	50                   	push   %eax
80106100:	ff 73 30             	push   0x30(%ebx)
80106103:	68 40 7f 10 80       	push   $0x80107f40
80106108:	e8 93 a5 ff ff       	call   801006a0 <cprintf>
      panic("trap");
8010610d:	83 c4 14             	add    $0x14,%esp
80106110:	68 17 7f 10 80       	push   $0x80107f17
80106115:	e8 66 a2 ff ff       	call   80100380 <panic>
8010611a:	66 90                	xchg   %ax,%ax
8010611c:	66 90                	xchg   %ax,%ax
8010611e:	66 90                	xchg   %ax,%ax

80106120 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80106120:	a1 00 df 11 80       	mov    0x8011df00,%eax
80106125:	85 c0                	test   %eax,%eax
80106127:	74 17                	je     80106140 <uartgetc+0x20>
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80106129:	ba fd 03 00 00       	mov    $0x3fd,%edx
8010612e:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
8010612f:	a8 01                	test   $0x1,%al
80106131:	74 0d                	je     80106140 <uartgetc+0x20>
80106133:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106138:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80106139:	0f b6 c0             	movzbl %al,%eax
8010613c:	c3                   	ret    
8010613d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
80106140:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106145:	c3                   	ret    
80106146:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010614d:	8d 76 00             	lea    0x0(%esi),%esi

80106150 <uartinit>:
{
80106150:	55                   	push   %ebp
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106151:	31 c9                	xor    %ecx,%ecx
80106153:	89 c8                	mov    %ecx,%eax
80106155:	89 e5                	mov    %esp,%ebp
80106157:	57                   	push   %edi
80106158:	bf fa 03 00 00       	mov    $0x3fa,%edi
8010615d:	56                   	push   %esi
8010615e:	89 fa                	mov    %edi,%edx
80106160:	53                   	push   %ebx
80106161:	83 ec 1c             	sub    $0x1c,%esp
80106164:	ee                   	out    %al,(%dx)
80106165:	be fb 03 00 00       	mov    $0x3fb,%esi
8010616a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
8010616f:	89 f2                	mov    %esi,%edx
80106171:	ee                   	out    %al,(%dx)
80106172:	b8 0c 00 00 00       	mov    $0xc,%eax
80106177:	ba f8 03 00 00       	mov    $0x3f8,%edx
8010617c:	ee                   	out    %al,(%dx)
8010617d:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80106182:	89 c8                	mov    %ecx,%eax
80106184:	89 da                	mov    %ebx,%edx
80106186:	ee                   	out    %al,(%dx)
80106187:	b8 03 00 00 00       	mov    $0x3,%eax
8010618c:	89 f2                	mov    %esi,%edx
8010618e:	ee                   	out    %al,(%dx)
8010618f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80106194:	89 c8                	mov    %ecx,%eax
80106196:	ee                   	out    %al,(%dx)
80106197:	b8 01 00 00 00       	mov    $0x1,%eax
8010619c:	89 da                	mov    %ebx,%edx
8010619e:	ee                   	out    %al,(%dx)
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010619f:	ba fd 03 00 00       	mov    $0x3fd,%edx
801061a4:	ec                   	in     (%dx),%al
  if(inb(COM1+5) == 0xFF)
801061a5:	3c ff                	cmp    $0xff,%al
801061a7:	74 78                	je     80106221 <uartinit+0xd1>
  uart = 1;
801061a9:	c7 05 00 df 11 80 01 	movl   $0x1,0x8011df00
801061b0:	00 00 00 
801061b3:	89 fa                	mov    %edi,%edx
801061b5:	ec                   	in     (%dx),%al
801061b6:	ba f8 03 00 00       	mov    $0x3f8,%edx
801061bb:	ec                   	in     (%dx),%al
  ioapicenable(IRQ_COM1, 0);
801061bc:	83 ec 08             	sub    $0x8,%esp
  for(p="xv6...\n"; *p; p++)
801061bf:	bf 38 80 10 80       	mov    $0x80108038,%edi
801061c4:	be fd 03 00 00       	mov    $0x3fd,%esi
  ioapicenable(IRQ_COM1, 0);
801061c9:	6a 00                	push   $0x0
801061cb:	6a 04                	push   $0x4
801061cd:	e8 5e c3 ff ff       	call   80102530 <ioapicenable>
  for(p="xv6...\n"; *p; p++)
801061d2:	c6 45 e7 78          	movb   $0x78,-0x19(%ebp)
  ioapicenable(IRQ_COM1, 0);
801061d6:	83 c4 10             	add    $0x10,%esp
801061d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(!uart)
801061e0:	a1 00 df 11 80       	mov    0x8011df00,%eax
801061e5:	bb 80 00 00 00       	mov    $0x80,%ebx
801061ea:	85 c0                	test   %eax,%eax
801061ec:	75 14                	jne    80106202 <uartinit+0xb2>
801061ee:	eb 23                	jmp    80106213 <uartinit+0xc3>
    microdelay(10);
801061f0:	83 ec 0c             	sub    $0xc,%esp
801061f3:	6a 0a                	push   $0xa
801061f5:	e8 e6 c7 ff ff       	call   801029e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
801061fa:	83 c4 10             	add    $0x10,%esp
801061fd:	83 eb 01             	sub    $0x1,%ebx
80106200:	74 07                	je     80106209 <uartinit+0xb9>
80106202:	89 f2                	mov    %esi,%edx
80106204:	ec                   	in     (%dx),%al
80106205:	a8 20                	test   $0x20,%al
80106207:	74 e7                	je     801061f0 <uartinit+0xa0>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106209:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
8010620d:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106212:	ee                   	out    %al,(%dx)
  for(p="xv6...\n"; *p; p++)
80106213:	0f b6 47 01          	movzbl 0x1(%edi),%eax
80106217:	83 c7 01             	add    $0x1,%edi
8010621a:	88 45 e7             	mov    %al,-0x19(%ebp)
8010621d:	84 c0                	test   %al,%al
8010621f:	75 bf                	jne    801061e0 <uartinit+0x90>
}
80106221:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106224:	5b                   	pop    %ebx
80106225:	5e                   	pop    %esi
80106226:	5f                   	pop    %edi
80106227:	5d                   	pop    %ebp
80106228:	c3                   	ret    
80106229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106230 <uartputc>:
  if(!uart)
80106230:	a1 00 df 11 80       	mov    0x8011df00,%eax
80106235:	85 c0                	test   %eax,%eax
80106237:	74 47                	je     80106280 <uartputc+0x50>
{
80106239:	55                   	push   %ebp
8010623a:	89 e5                	mov    %esp,%ebp
8010623c:	56                   	push   %esi
  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010623d:	be fd 03 00 00       	mov    $0x3fd,%esi
80106242:	53                   	push   %ebx
80106243:	bb 80 00 00 00       	mov    $0x80,%ebx
80106248:	eb 18                	jmp    80106262 <uartputc+0x32>
8010624a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    microdelay(10);
80106250:	83 ec 0c             	sub    $0xc,%esp
80106253:	6a 0a                	push   $0xa
80106255:	e8 86 c7 ff ff       	call   801029e0 <microdelay>
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
8010625a:	83 c4 10             	add    $0x10,%esp
8010625d:	83 eb 01             	sub    $0x1,%ebx
80106260:	74 07                	je     80106269 <uartputc+0x39>
80106262:	89 f2                	mov    %esi,%edx
80106264:	ec                   	in     (%dx),%al
80106265:	a8 20                	test   $0x20,%al
80106267:	74 e7                	je     80106250 <uartputc+0x20>
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80106269:	8b 45 08             	mov    0x8(%ebp),%eax
8010626c:	ba f8 03 00 00       	mov    $0x3f8,%edx
80106271:	ee                   	out    %al,(%dx)
}
80106272:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106275:	5b                   	pop    %ebx
80106276:	5e                   	pop    %esi
80106277:	5d                   	pop    %ebp
80106278:	c3                   	ret    
80106279:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106280:	c3                   	ret    
80106281:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106288:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010628f:	90                   	nop

80106290 <uartintr>:

void
uartintr(void)
{
80106290:	55                   	push   %ebp
80106291:	89 e5                	mov    %esp,%ebp
80106293:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80106296:	68 20 61 10 80       	push   $0x80106120
8010629b:	e8 e0 a5 ff ff       	call   80100880 <consoleintr>
}
801062a0:	83 c4 10             	add    $0x10,%esp
801062a3:	c9                   	leave  
801062a4:	c3                   	ret    

801062a5 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
801062a5:	6a 00                	push   $0x0
  pushl $0
801062a7:	6a 00                	push   $0x0
  jmp alltraps
801062a9:	e9 09 fb ff ff       	jmp    80105db7 <alltraps>

801062ae <vector1>:
.globl vector1
vector1:
  pushl $0
801062ae:	6a 00                	push   $0x0
  pushl $1
801062b0:	6a 01                	push   $0x1
  jmp alltraps
801062b2:	e9 00 fb ff ff       	jmp    80105db7 <alltraps>

801062b7 <vector2>:
.globl vector2
vector2:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $2
801062b9:	6a 02                	push   $0x2
  jmp alltraps
801062bb:	e9 f7 fa ff ff       	jmp    80105db7 <alltraps>

801062c0 <vector3>:
.globl vector3
vector3:
  pushl $0
801062c0:	6a 00                	push   $0x0
  pushl $3
801062c2:	6a 03                	push   $0x3
  jmp alltraps
801062c4:	e9 ee fa ff ff       	jmp    80105db7 <alltraps>

801062c9 <vector4>:
.globl vector4
vector4:
  pushl $0
801062c9:	6a 00                	push   $0x0
  pushl $4
801062cb:	6a 04                	push   $0x4
  jmp alltraps
801062cd:	e9 e5 fa ff ff       	jmp    80105db7 <alltraps>

801062d2 <vector5>:
.globl vector5
vector5:
  pushl $0
801062d2:	6a 00                	push   $0x0
  pushl $5
801062d4:	6a 05                	push   $0x5
  jmp alltraps
801062d6:	e9 dc fa ff ff       	jmp    80105db7 <alltraps>

801062db <vector6>:
.globl vector6
vector6:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $6
801062dd:	6a 06                	push   $0x6
  jmp alltraps
801062df:	e9 d3 fa ff ff       	jmp    80105db7 <alltraps>

801062e4 <vector7>:
.globl vector7
vector7:
  pushl $0
801062e4:	6a 00                	push   $0x0
  pushl $7
801062e6:	6a 07                	push   $0x7
  jmp alltraps
801062e8:	e9 ca fa ff ff       	jmp    80105db7 <alltraps>

801062ed <vector8>:
.globl vector8
vector8:
  pushl $8
801062ed:	6a 08                	push   $0x8
  jmp alltraps
801062ef:	e9 c3 fa ff ff       	jmp    80105db7 <alltraps>

801062f4 <vector9>:
.globl vector9
vector9:
  pushl $0
801062f4:	6a 00                	push   $0x0
  pushl $9
801062f6:	6a 09                	push   $0x9
  jmp alltraps
801062f8:	e9 ba fa ff ff       	jmp    80105db7 <alltraps>

801062fd <vector10>:
.globl vector10
vector10:
  pushl $10
801062fd:	6a 0a                	push   $0xa
  jmp alltraps
801062ff:	e9 b3 fa ff ff       	jmp    80105db7 <alltraps>

80106304 <vector11>:
.globl vector11
vector11:
  pushl $11
80106304:	6a 0b                	push   $0xb
  jmp alltraps
80106306:	e9 ac fa ff ff       	jmp    80105db7 <alltraps>

8010630b <vector12>:
.globl vector12
vector12:
  pushl $12
8010630b:	6a 0c                	push   $0xc
  jmp alltraps
8010630d:	e9 a5 fa ff ff       	jmp    80105db7 <alltraps>

80106312 <vector13>:
.globl vector13
vector13:
  pushl $13
80106312:	6a 0d                	push   $0xd
  jmp alltraps
80106314:	e9 9e fa ff ff       	jmp    80105db7 <alltraps>

80106319 <vector14>:
.globl vector14
vector14:
  pushl $14
80106319:	6a 0e                	push   $0xe
  jmp alltraps
8010631b:	e9 97 fa ff ff       	jmp    80105db7 <alltraps>

80106320 <vector15>:
.globl vector15
vector15:
  pushl $0
80106320:	6a 00                	push   $0x0
  pushl $15
80106322:	6a 0f                	push   $0xf
  jmp alltraps
80106324:	e9 8e fa ff ff       	jmp    80105db7 <alltraps>

80106329 <vector16>:
.globl vector16
vector16:
  pushl $0
80106329:	6a 00                	push   $0x0
  pushl $16
8010632b:	6a 10                	push   $0x10
  jmp alltraps
8010632d:	e9 85 fa ff ff       	jmp    80105db7 <alltraps>

80106332 <vector17>:
.globl vector17
vector17:
  pushl $17
80106332:	6a 11                	push   $0x11
  jmp alltraps
80106334:	e9 7e fa ff ff       	jmp    80105db7 <alltraps>

80106339 <vector18>:
.globl vector18
vector18:
  pushl $0
80106339:	6a 00                	push   $0x0
  pushl $18
8010633b:	6a 12                	push   $0x12
  jmp alltraps
8010633d:	e9 75 fa ff ff       	jmp    80105db7 <alltraps>

80106342 <vector19>:
.globl vector19
vector19:
  pushl $0
80106342:	6a 00                	push   $0x0
  pushl $19
80106344:	6a 13                	push   $0x13
  jmp alltraps
80106346:	e9 6c fa ff ff       	jmp    80105db7 <alltraps>

8010634b <vector20>:
.globl vector20
vector20:
  pushl $0
8010634b:	6a 00                	push   $0x0
  pushl $20
8010634d:	6a 14                	push   $0x14
  jmp alltraps
8010634f:	e9 63 fa ff ff       	jmp    80105db7 <alltraps>

80106354 <vector21>:
.globl vector21
vector21:
  pushl $0
80106354:	6a 00                	push   $0x0
  pushl $21
80106356:	6a 15                	push   $0x15
  jmp alltraps
80106358:	e9 5a fa ff ff       	jmp    80105db7 <alltraps>

8010635d <vector22>:
.globl vector22
vector22:
  pushl $0
8010635d:	6a 00                	push   $0x0
  pushl $22
8010635f:	6a 16                	push   $0x16
  jmp alltraps
80106361:	e9 51 fa ff ff       	jmp    80105db7 <alltraps>

80106366 <vector23>:
.globl vector23
vector23:
  pushl $0
80106366:	6a 00                	push   $0x0
  pushl $23
80106368:	6a 17                	push   $0x17
  jmp alltraps
8010636a:	e9 48 fa ff ff       	jmp    80105db7 <alltraps>

8010636f <vector24>:
.globl vector24
vector24:
  pushl $0
8010636f:	6a 00                	push   $0x0
  pushl $24
80106371:	6a 18                	push   $0x18
  jmp alltraps
80106373:	e9 3f fa ff ff       	jmp    80105db7 <alltraps>

80106378 <vector25>:
.globl vector25
vector25:
  pushl $0
80106378:	6a 00                	push   $0x0
  pushl $25
8010637a:	6a 19                	push   $0x19
  jmp alltraps
8010637c:	e9 36 fa ff ff       	jmp    80105db7 <alltraps>

80106381 <vector26>:
.globl vector26
vector26:
  pushl $0
80106381:	6a 00                	push   $0x0
  pushl $26
80106383:	6a 1a                	push   $0x1a
  jmp alltraps
80106385:	e9 2d fa ff ff       	jmp    80105db7 <alltraps>

8010638a <vector27>:
.globl vector27
vector27:
  pushl $0
8010638a:	6a 00                	push   $0x0
  pushl $27
8010638c:	6a 1b                	push   $0x1b
  jmp alltraps
8010638e:	e9 24 fa ff ff       	jmp    80105db7 <alltraps>

80106393 <vector28>:
.globl vector28
vector28:
  pushl $0
80106393:	6a 00                	push   $0x0
  pushl $28
80106395:	6a 1c                	push   $0x1c
  jmp alltraps
80106397:	e9 1b fa ff ff       	jmp    80105db7 <alltraps>

8010639c <vector29>:
.globl vector29
vector29:
  pushl $0
8010639c:	6a 00                	push   $0x0
  pushl $29
8010639e:	6a 1d                	push   $0x1d
  jmp alltraps
801063a0:	e9 12 fa ff ff       	jmp    80105db7 <alltraps>

801063a5 <vector30>:
.globl vector30
vector30:
  pushl $0
801063a5:	6a 00                	push   $0x0
  pushl $30
801063a7:	6a 1e                	push   $0x1e
  jmp alltraps
801063a9:	e9 09 fa ff ff       	jmp    80105db7 <alltraps>

801063ae <vector31>:
.globl vector31
vector31:
  pushl $0
801063ae:	6a 00                	push   $0x0
  pushl $31
801063b0:	6a 1f                	push   $0x1f
  jmp alltraps
801063b2:	e9 00 fa ff ff       	jmp    80105db7 <alltraps>

801063b7 <vector32>:
.globl vector32
vector32:
  pushl $0
801063b7:	6a 00                	push   $0x0
  pushl $32
801063b9:	6a 20                	push   $0x20
  jmp alltraps
801063bb:	e9 f7 f9 ff ff       	jmp    80105db7 <alltraps>

801063c0 <vector33>:
.globl vector33
vector33:
  pushl $0
801063c0:	6a 00                	push   $0x0
  pushl $33
801063c2:	6a 21                	push   $0x21
  jmp alltraps
801063c4:	e9 ee f9 ff ff       	jmp    80105db7 <alltraps>

801063c9 <vector34>:
.globl vector34
vector34:
  pushl $0
801063c9:	6a 00                	push   $0x0
  pushl $34
801063cb:	6a 22                	push   $0x22
  jmp alltraps
801063cd:	e9 e5 f9 ff ff       	jmp    80105db7 <alltraps>

801063d2 <vector35>:
.globl vector35
vector35:
  pushl $0
801063d2:	6a 00                	push   $0x0
  pushl $35
801063d4:	6a 23                	push   $0x23
  jmp alltraps
801063d6:	e9 dc f9 ff ff       	jmp    80105db7 <alltraps>

801063db <vector36>:
.globl vector36
vector36:
  pushl $0
801063db:	6a 00                	push   $0x0
  pushl $36
801063dd:	6a 24                	push   $0x24
  jmp alltraps
801063df:	e9 d3 f9 ff ff       	jmp    80105db7 <alltraps>

801063e4 <vector37>:
.globl vector37
vector37:
  pushl $0
801063e4:	6a 00                	push   $0x0
  pushl $37
801063e6:	6a 25                	push   $0x25
  jmp alltraps
801063e8:	e9 ca f9 ff ff       	jmp    80105db7 <alltraps>

801063ed <vector38>:
.globl vector38
vector38:
  pushl $0
801063ed:	6a 00                	push   $0x0
  pushl $38
801063ef:	6a 26                	push   $0x26
  jmp alltraps
801063f1:	e9 c1 f9 ff ff       	jmp    80105db7 <alltraps>

801063f6 <vector39>:
.globl vector39
vector39:
  pushl $0
801063f6:	6a 00                	push   $0x0
  pushl $39
801063f8:	6a 27                	push   $0x27
  jmp alltraps
801063fa:	e9 b8 f9 ff ff       	jmp    80105db7 <alltraps>

801063ff <vector40>:
.globl vector40
vector40:
  pushl $0
801063ff:	6a 00                	push   $0x0
  pushl $40
80106401:	6a 28                	push   $0x28
  jmp alltraps
80106403:	e9 af f9 ff ff       	jmp    80105db7 <alltraps>

80106408 <vector41>:
.globl vector41
vector41:
  pushl $0
80106408:	6a 00                	push   $0x0
  pushl $41
8010640a:	6a 29                	push   $0x29
  jmp alltraps
8010640c:	e9 a6 f9 ff ff       	jmp    80105db7 <alltraps>

80106411 <vector42>:
.globl vector42
vector42:
  pushl $0
80106411:	6a 00                	push   $0x0
  pushl $42
80106413:	6a 2a                	push   $0x2a
  jmp alltraps
80106415:	e9 9d f9 ff ff       	jmp    80105db7 <alltraps>

8010641a <vector43>:
.globl vector43
vector43:
  pushl $0
8010641a:	6a 00                	push   $0x0
  pushl $43
8010641c:	6a 2b                	push   $0x2b
  jmp alltraps
8010641e:	e9 94 f9 ff ff       	jmp    80105db7 <alltraps>

80106423 <vector44>:
.globl vector44
vector44:
  pushl $0
80106423:	6a 00                	push   $0x0
  pushl $44
80106425:	6a 2c                	push   $0x2c
  jmp alltraps
80106427:	e9 8b f9 ff ff       	jmp    80105db7 <alltraps>

8010642c <vector45>:
.globl vector45
vector45:
  pushl $0
8010642c:	6a 00                	push   $0x0
  pushl $45
8010642e:	6a 2d                	push   $0x2d
  jmp alltraps
80106430:	e9 82 f9 ff ff       	jmp    80105db7 <alltraps>

80106435 <vector46>:
.globl vector46
vector46:
  pushl $0
80106435:	6a 00                	push   $0x0
  pushl $46
80106437:	6a 2e                	push   $0x2e
  jmp alltraps
80106439:	e9 79 f9 ff ff       	jmp    80105db7 <alltraps>

8010643e <vector47>:
.globl vector47
vector47:
  pushl $0
8010643e:	6a 00                	push   $0x0
  pushl $47
80106440:	6a 2f                	push   $0x2f
  jmp alltraps
80106442:	e9 70 f9 ff ff       	jmp    80105db7 <alltraps>

80106447 <vector48>:
.globl vector48
vector48:
  pushl $0
80106447:	6a 00                	push   $0x0
  pushl $48
80106449:	6a 30                	push   $0x30
  jmp alltraps
8010644b:	e9 67 f9 ff ff       	jmp    80105db7 <alltraps>

80106450 <vector49>:
.globl vector49
vector49:
  pushl $0
80106450:	6a 00                	push   $0x0
  pushl $49
80106452:	6a 31                	push   $0x31
  jmp alltraps
80106454:	e9 5e f9 ff ff       	jmp    80105db7 <alltraps>

80106459 <vector50>:
.globl vector50
vector50:
  pushl $0
80106459:	6a 00                	push   $0x0
  pushl $50
8010645b:	6a 32                	push   $0x32
  jmp alltraps
8010645d:	e9 55 f9 ff ff       	jmp    80105db7 <alltraps>

80106462 <vector51>:
.globl vector51
vector51:
  pushl $0
80106462:	6a 00                	push   $0x0
  pushl $51
80106464:	6a 33                	push   $0x33
  jmp alltraps
80106466:	e9 4c f9 ff ff       	jmp    80105db7 <alltraps>

8010646b <vector52>:
.globl vector52
vector52:
  pushl $0
8010646b:	6a 00                	push   $0x0
  pushl $52
8010646d:	6a 34                	push   $0x34
  jmp alltraps
8010646f:	e9 43 f9 ff ff       	jmp    80105db7 <alltraps>

80106474 <vector53>:
.globl vector53
vector53:
  pushl $0
80106474:	6a 00                	push   $0x0
  pushl $53
80106476:	6a 35                	push   $0x35
  jmp alltraps
80106478:	e9 3a f9 ff ff       	jmp    80105db7 <alltraps>

8010647d <vector54>:
.globl vector54
vector54:
  pushl $0
8010647d:	6a 00                	push   $0x0
  pushl $54
8010647f:	6a 36                	push   $0x36
  jmp alltraps
80106481:	e9 31 f9 ff ff       	jmp    80105db7 <alltraps>

80106486 <vector55>:
.globl vector55
vector55:
  pushl $0
80106486:	6a 00                	push   $0x0
  pushl $55
80106488:	6a 37                	push   $0x37
  jmp alltraps
8010648a:	e9 28 f9 ff ff       	jmp    80105db7 <alltraps>

8010648f <vector56>:
.globl vector56
vector56:
  pushl $0
8010648f:	6a 00                	push   $0x0
  pushl $56
80106491:	6a 38                	push   $0x38
  jmp alltraps
80106493:	e9 1f f9 ff ff       	jmp    80105db7 <alltraps>

80106498 <vector57>:
.globl vector57
vector57:
  pushl $0
80106498:	6a 00                	push   $0x0
  pushl $57
8010649a:	6a 39                	push   $0x39
  jmp alltraps
8010649c:	e9 16 f9 ff ff       	jmp    80105db7 <alltraps>

801064a1 <vector58>:
.globl vector58
vector58:
  pushl $0
801064a1:	6a 00                	push   $0x0
  pushl $58
801064a3:	6a 3a                	push   $0x3a
  jmp alltraps
801064a5:	e9 0d f9 ff ff       	jmp    80105db7 <alltraps>

801064aa <vector59>:
.globl vector59
vector59:
  pushl $0
801064aa:	6a 00                	push   $0x0
  pushl $59
801064ac:	6a 3b                	push   $0x3b
  jmp alltraps
801064ae:	e9 04 f9 ff ff       	jmp    80105db7 <alltraps>

801064b3 <vector60>:
.globl vector60
vector60:
  pushl $0
801064b3:	6a 00                	push   $0x0
  pushl $60
801064b5:	6a 3c                	push   $0x3c
  jmp alltraps
801064b7:	e9 fb f8 ff ff       	jmp    80105db7 <alltraps>

801064bc <vector61>:
.globl vector61
vector61:
  pushl $0
801064bc:	6a 00                	push   $0x0
  pushl $61
801064be:	6a 3d                	push   $0x3d
  jmp alltraps
801064c0:	e9 f2 f8 ff ff       	jmp    80105db7 <alltraps>

801064c5 <vector62>:
.globl vector62
vector62:
  pushl $0
801064c5:	6a 00                	push   $0x0
  pushl $62
801064c7:	6a 3e                	push   $0x3e
  jmp alltraps
801064c9:	e9 e9 f8 ff ff       	jmp    80105db7 <alltraps>

801064ce <vector63>:
.globl vector63
vector63:
  pushl $0
801064ce:	6a 00                	push   $0x0
  pushl $63
801064d0:	6a 3f                	push   $0x3f
  jmp alltraps
801064d2:	e9 e0 f8 ff ff       	jmp    80105db7 <alltraps>

801064d7 <vector64>:
.globl vector64
vector64:
  pushl $0
801064d7:	6a 00                	push   $0x0
  pushl $64
801064d9:	6a 40                	push   $0x40
  jmp alltraps
801064db:	e9 d7 f8 ff ff       	jmp    80105db7 <alltraps>

801064e0 <vector65>:
.globl vector65
vector65:
  pushl $0
801064e0:	6a 00                	push   $0x0
  pushl $65
801064e2:	6a 41                	push   $0x41
  jmp alltraps
801064e4:	e9 ce f8 ff ff       	jmp    80105db7 <alltraps>

801064e9 <vector66>:
.globl vector66
vector66:
  pushl $0
801064e9:	6a 00                	push   $0x0
  pushl $66
801064eb:	6a 42                	push   $0x42
  jmp alltraps
801064ed:	e9 c5 f8 ff ff       	jmp    80105db7 <alltraps>

801064f2 <vector67>:
.globl vector67
vector67:
  pushl $0
801064f2:	6a 00                	push   $0x0
  pushl $67
801064f4:	6a 43                	push   $0x43
  jmp alltraps
801064f6:	e9 bc f8 ff ff       	jmp    80105db7 <alltraps>

801064fb <vector68>:
.globl vector68
vector68:
  pushl $0
801064fb:	6a 00                	push   $0x0
  pushl $68
801064fd:	6a 44                	push   $0x44
  jmp alltraps
801064ff:	e9 b3 f8 ff ff       	jmp    80105db7 <alltraps>

80106504 <vector69>:
.globl vector69
vector69:
  pushl $0
80106504:	6a 00                	push   $0x0
  pushl $69
80106506:	6a 45                	push   $0x45
  jmp alltraps
80106508:	e9 aa f8 ff ff       	jmp    80105db7 <alltraps>

8010650d <vector70>:
.globl vector70
vector70:
  pushl $0
8010650d:	6a 00                	push   $0x0
  pushl $70
8010650f:	6a 46                	push   $0x46
  jmp alltraps
80106511:	e9 a1 f8 ff ff       	jmp    80105db7 <alltraps>

80106516 <vector71>:
.globl vector71
vector71:
  pushl $0
80106516:	6a 00                	push   $0x0
  pushl $71
80106518:	6a 47                	push   $0x47
  jmp alltraps
8010651a:	e9 98 f8 ff ff       	jmp    80105db7 <alltraps>

8010651f <vector72>:
.globl vector72
vector72:
  pushl $0
8010651f:	6a 00                	push   $0x0
  pushl $72
80106521:	6a 48                	push   $0x48
  jmp alltraps
80106523:	e9 8f f8 ff ff       	jmp    80105db7 <alltraps>

80106528 <vector73>:
.globl vector73
vector73:
  pushl $0
80106528:	6a 00                	push   $0x0
  pushl $73
8010652a:	6a 49                	push   $0x49
  jmp alltraps
8010652c:	e9 86 f8 ff ff       	jmp    80105db7 <alltraps>

80106531 <vector74>:
.globl vector74
vector74:
  pushl $0
80106531:	6a 00                	push   $0x0
  pushl $74
80106533:	6a 4a                	push   $0x4a
  jmp alltraps
80106535:	e9 7d f8 ff ff       	jmp    80105db7 <alltraps>

8010653a <vector75>:
.globl vector75
vector75:
  pushl $0
8010653a:	6a 00                	push   $0x0
  pushl $75
8010653c:	6a 4b                	push   $0x4b
  jmp alltraps
8010653e:	e9 74 f8 ff ff       	jmp    80105db7 <alltraps>

80106543 <vector76>:
.globl vector76
vector76:
  pushl $0
80106543:	6a 00                	push   $0x0
  pushl $76
80106545:	6a 4c                	push   $0x4c
  jmp alltraps
80106547:	e9 6b f8 ff ff       	jmp    80105db7 <alltraps>

8010654c <vector77>:
.globl vector77
vector77:
  pushl $0
8010654c:	6a 00                	push   $0x0
  pushl $77
8010654e:	6a 4d                	push   $0x4d
  jmp alltraps
80106550:	e9 62 f8 ff ff       	jmp    80105db7 <alltraps>

80106555 <vector78>:
.globl vector78
vector78:
  pushl $0
80106555:	6a 00                	push   $0x0
  pushl $78
80106557:	6a 4e                	push   $0x4e
  jmp alltraps
80106559:	e9 59 f8 ff ff       	jmp    80105db7 <alltraps>

8010655e <vector79>:
.globl vector79
vector79:
  pushl $0
8010655e:	6a 00                	push   $0x0
  pushl $79
80106560:	6a 4f                	push   $0x4f
  jmp alltraps
80106562:	e9 50 f8 ff ff       	jmp    80105db7 <alltraps>

80106567 <vector80>:
.globl vector80
vector80:
  pushl $0
80106567:	6a 00                	push   $0x0
  pushl $80
80106569:	6a 50                	push   $0x50
  jmp alltraps
8010656b:	e9 47 f8 ff ff       	jmp    80105db7 <alltraps>

80106570 <vector81>:
.globl vector81
vector81:
  pushl $0
80106570:	6a 00                	push   $0x0
  pushl $81
80106572:	6a 51                	push   $0x51
  jmp alltraps
80106574:	e9 3e f8 ff ff       	jmp    80105db7 <alltraps>

80106579 <vector82>:
.globl vector82
vector82:
  pushl $0
80106579:	6a 00                	push   $0x0
  pushl $82
8010657b:	6a 52                	push   $0x52
  jmp alltraps
8010657d:	e9 35 f8 ff ff       	jmp    80105db7 <alltraps>

80106582 <vector83>:
.globl vector83
vector83:
  pushl $0
80106582:	6a 00                	push   $0x0
  pushl $83
80106584:	6a 53                	push   $0x53
  jmp alltraps
80106586:	e9 2c f8 ff ff       	jmp    80105db7 <alltraps>

8010658b <vector84>:
.globl vector84
vector84:
  pushl $0
8010658b:	6a 00                	push   $0x0
  pushl $84
8010658d:	6a 54                	push   $0x54
  jmp alltraps
8010658f:	e9 23 f8 ff ff       	jmp    80105db7 <alltraps>

80106594 <vector85>:
.globl vector85
vector85:
  pushl $0
80106594:	6a 00                	push   $0x0
  pushl $85
80106596:	6a 55                	push   $0x55
  jmp alltraps
80106598:	e9 1a f8 ff ff       	jmp    80105db7 <alltraps>

8010659d <vector86>:
.globl vector86
vector86:
  pushl $0
8010659d:	6a 00                	push   $0x0
  pushl $86
8010659f:	6a 56                	push   $0x56
  jmp alltraps
801065a1:	e9 11 f8 ff ff       	jmp    80105db7 <alltraps>

801065a6 <vector87>:
.globl vector87
vector87:
  pushl $0
801065a6:	6a 00                	push   $0x0
  pushl $87
801065a8:	6a 57                	push   $0x57
  jmp alltraps
801065aa:	e9 08 f8 ff ff       	jmp    80105db7 <alltraps>

801065af <vector88>:
.globl vector88
vector88:
  pushl $0
801065af:	6a 00                	push   $0x0
  pushl $88
801065b1:	6a 58                	push   $0x58
  jmp alltraps
801065b3:	e9 ff f7 ff ff       	jmp    80105db7 <alltraps>

801065b8 <vector89>:
.globl vector89
vector89:
  pushl $0
801065b8:	6a 00                	push   $0x0
  pushl $89
801065ba:	6a 59                	push   $0x59
  jmp alltraps
801065bc:	e9 f6 f7 ff ff       	jmp    80105db7 <alltraps>

801065c1 <vector90>:
.globl vector90
vector90:
  pushl $0
801065c1:	6a 00                	push   $0x0
  pushl $90
801065c3:	6a 5a                	push   $0x5a
  jmp alltraps
801065c5:	e9 ed f7 ff ff       	jmp    80105db7 <alltraps>

801065ca <vector91>:
.globl vector91
vector91:
  pushl $0
801065ca:	6a 00                	push   $0x0
  pushl $91
801065cc:	6a 5b                	push   $0x5b
  jmp alltraps
801065ce:	e9 e4 f7 ff ff       	jmp    80105db7 <alltraps>

801065d3 <vector92>:
.globl vector92
vector92:
  pushl $0
801065d3:	6a 00                	push   $0x0
  pushl $92
801065d5:	6a 5c                	push   $0x5c
  jmp alltraps
801065d7:	e9 db f7 ff ff       	jmp    80105db7 <alltraps>

801065dc <vector93>:
.globl vector93
vector93:
  pushl $0
801065dc:	6a 00                	push   $0x0
  pushl $93
801065de:	6a 5d                	push   $0x5d
  jmp alltraps
801065e0:	e9 d2 f7 ff ff       	jmp    80105db7 <alltraps>

801065e5 <vector94>:
.globl vector94
vector94:
  pushl $0
801065e5:	6a 00                	push   $0x0
  pushl $94
801065e7:	6a 5e                	push   $0x5e
  jmp alltraps
801065e9:	e9 c9 f7 ff ff       	jmp    80105db7 <alltraps>

801065ee <vector95>:
.globl vector95
vector95:
  pushl $0
801065ee:	6a 00                	push   $0x0
  pushl $95
801065f0:	6a 5f                	push   $0x5f
  jmp alltraps
801065f2:	e9 c0 f7 ff ff       	jmp    80105db7 <alltraps>

801065f7 <vector96>:
.globl vector96
vector96:
  pushl $0
801065f7:	6a 00                	push   $0x0
  pushl $96
801065f9:	6a 60                	push   $0x60
  jmp alltraps
801065fb:	e9 b7 f7 ff ff       	jmp    80105db7 <alltraps>

80106600 <vector97>:
.globl vector97
vector97:
  pushl $0
80106600:	6a 00                	push   $0x0
  pushl $97
80106602:	6a 61                	push   $0x61
  jmp alltraps
80106604:	e9 ae f7 ff ff       	jmp    80105db7 <alltraps>

80106609 <vector98>:
.globl vector98
vector98:
  pushl $0
80106609:	6a 00                	push   $0x0
  pushl $98
8010660b:	6a 62                	push   $0x62
  jmp alltraps
8010660d:	e9 a5 f7 ff ff       	jmp    80105db7 <alltraps>

80106612 <vector99>:
.globl vector99
vector99:
  pushl $0
80106612:	6a 00                	push   $0x0
  pushl $99
80106614:	6a 63                	push   $0x63
  jmp alltraps
80106616:	e9 9c f7 ff ff       	jmp    80105db7 <alltraps>

8010661b <vector100>:
.globl vector100
vector100:
  pushl $0
8010661b:	6a 00                	push   $0x0
  pushl $100
8010661d:	6a 64                	push   $0x64
  jmp alltraps
8010661f:	e9 93 f7 ff ff       	jmp    80105db7 <alltraps>

80106624 <vector101>:
.globl vector101
vector101:
  pushl $0
80106624:	6a 00                	push   $0x0
  pushl $101
80106626:	6a 65                	push   $0x65
  jmp alltraps
80106628:	e9 8a f7 ff ff       	jmp    80105db7 <alltraps>

8010662d <vector102>:
.globl vector102
vector102:
  pushl $0
8010662d:	6a 00                	push   $0x0
  pushl $102
8010662f:	6a 66                	push   $0x66
  jmp alltraps
80106631:	e9 81 f7 ff ff       	jmp    80105db7 <alltraps>

80106636 <vector103>:
.globl vector103
vector103:
  pushl $0
80106636:	6a 00                	push   $0x0
  pushl $103
80106638:	6a 67                	push   $0x67
  jmp alltraps
8010663a:	e9 78 f7 ff ff       	jmp    80105db7 <alltraps>

8010663f <vector104>:
.globl vector104
vector104:
  pushl $0
8010663f:	6a 00                	push   $0x0
  pushl $104
80106641:	6a 68                	push   $0x68
  jmp alltraps
80106643:	e9 6f f7 ff ff       	jmp    80105db7 <alltraps>

80106648 <vector105>:
.globl vector105
vector105:
  pushl $0
80106648:	6a 00                	push   $0x0
  pushl $105
8010664a:	6a 69                	push   $0x69
  jmp alltraps
8010664c:	e9 66 f7 ff ff       	jmp    80105db7 <alltraps>

80106651 <vector106>:
.globl vector106
vector106:
  pushl $0
80106651:	6a 00                	push   $0x0
  pushl $106
80106653:	6a 6a                	push   $0x6a
  jmp alltraps
80106655:	e9 5d f7 ff ff       	jmp    80105db7 <alltraps>

8010665a <vector107>:
.globl vector107
vector107:
  pushl $0
8010665a:	6a 00                	push   $0x0
  pushl $107
8010665c:	6a 6b                	push   $0x6b
  jmp alltraps
8010665e:	e9 54 f7 ff ff       	jmp    80105db7 <alltraps>

80106663 <vector108>:
.globl vector108
vector108:
  pushl $0
80106663:	6a 00                	push   $0x0
  pushl $108
80106665:	6a 6c                	push   $0x6c
  jmp alltraps
80106667:	e9 4b f7 ff ff       	jmp    80105db7 <alltraps>

8010666c <vector109>:
.globl vector109
vector109:
  pushl $0
8010666c:	6a 00                	push   $0x0
  pushl $109
8010666e:	6a 6d                	push   $0x6d
  jmp alltraps
80106670:	e9 42 f7 ff ff       	jmp    80105db7 <alltraps>

80106675 <vector110>:
.globl vector110
vector110:
  pushl $0
80106675:	6a 00                	push   $0x0
  pushl $110
80106677:	6a 6e                	push   $0x6e
  jmp alltraps
80106679:	e9 39 f7 ff ff       	jmp    80105db7 <alltraps>

8010667e <vector111>:
.globl vector111
vector111:
  pushl $0
8010667e:	6a 00                	push   $0x0
  pushl $111
80106680:	6a 6f                	push   $0x6f
  jmp alltraps
80106682:	e9 30 f7 ff ff       	jmp    80105db7 <alltraps>

80106687 <vector112>:
.globl vector112
vector112:
  pushl $0
80106687:	6a 00                	push   $0x0
  pushl $112
80106689:	6a 70                	push   $0x70
  jmp alltraps
8010668b:	e9 27 f7 ff ff       	jmp    80105db7 <alltraps>

80106690 <vector113>:
.globl vector113
vector113:
  pushl $0
80106690:	6a 00                	push   $0x0
  pushl $113
80106692:	6a 71                	push   $0x71
  jmp alltraps
80106694:	e9 1e f7 ff ff       	jmp    80105db7 <alltraps>

80106699 <vector114>:
.globl vector114
vector114:
  pushl $0
80106699:	6a 00                	push   $0x0
  pushl $114
8010669b:	6a 72                	push   $0x72
  jmp alltraps
8010669d:	e9 15 f7 ff ff       	jmp    80105db7 <alltraps>

801066a2 <vector115>:
.globl vector115
vector115:
  pushl $0
801066a2:	6a 00                	push   $0x0
  pushl $115
801066a4:	6a 73                	push   $0x73
  jmp alltraps
801066a6:	e9 0c f7 ff ff       	jmp    80105db7 <alltraps>

801066ab <vector116>:
.globl vector116
vector116:
  pushl $0
801066ab:	6a 00                	push   $0x0
  pushl $116
801066ad:	6a 74                	push   $0x74
  jmp alltraps
801066af:	e9 03 f7 ff ff       	jmp    80105db7 <alltraps>

801066b4 <vector117>:
.globl vector117
vector117:
  pushl $0
801066b4:	6a 00                	push   $0x0
  pushl $117
801066b6:	6a 75                	push   $0x75
  jmp alltraps
801066b8:	e9 fa f6 ff ff       	jmp    80105db7 <alltraps>

801066bd <vector118>:
.globl vector118
vector118:
  pushl $0
801066bd:	6a 00                	push   $0x0
  pushl $118
801066bf:	6a 76                	push   $0x76
  jmp alltraps
801066c1:	e9 f1 f6 ff ff       	jmp    80105db7 <alltraps>

801066c6 <vector119>:
.globl vector119
vector119:
  pushl $0
801066c6:	6a 00                	push   $0x0
  pushl $119
801066c8:	6a 77                	push   $0x77
  jmp alltraps
801066ca:	e9 e8 f6 ff ff       	jmp    80105db7 <alltraps>

801066cf <vector120>:
.globl vector120
vector120:
  pushl $0
801066cf:	6a 00                	push   $0x0
  pushl $120
801066d1:	6a 78                	push   $0x78
  jmp alltraps
801066d3:	e9 df f6 ff ff       	jmp    80105db7 <alltraps>

801066d8 <vector121>:
.globl vector121
vector121:
  pushl $0
801066d8:	6a 00                	push   $0x0
  pushl $121
801066da:	6a 79                	push   $0x79
  jmp alltraps
801066dc:	e9 d6 f6 ff ff       	jmp    80105db7 <alltraps>

801066e1 <vector122>:
.globl vector122
vector122:
  pushl $0
801066e1:	6a 00                	push   $0x0
  pushl $122
801066e3:	6a 7a                	push   $0x7a
  jmp alltraps
801066e5:	e9 cd f6 ff ff       	jmp    80105db7 <alltraps>

801066ea <vector123>:
.globl vector123
vector123:
  pushl $0
801066ea:	6a 00                	push   $0x0
  pushl $123
801066ec:	6a 7b                	push   $0x7b
  jmp alltraps
801066ee:	e9 c4 f6 ff ff       	jmp    80105db7 <alltraps>

801066f3 <vector124>:
.globl vector124
vector124:
  pushl $0
801066f3:	6a 00                	push   $0x0
  pushl $124
801066f5:	6a 7c                	push   $0x7c
  jmp alltraps
801066f7:	e9 bb f6 ff ff       	jmp    80105db7 <alltraps>

801066fc <vector125>:
.globl vector125
vector125:
  pushl $0
801066fc:	6a 00                	push   $0x0
  pushl $125
801066fe:	6a 7d                	push   $0x7d
  jmp alltraps
80106700:	e9 b2 f6 ff ff       	jmp    80105db7 <alltraps>

80106705 <vector126>:
.globl vector126
vector126:
  pushl $0
80106705:	6a 00                	push   $0x0
  pushl $126
80106707:	6a 7e                	push   $0x7e
  jmp alltraps
80106709:	e9 a9 f6 ff ff       	jmp    80105db7 <alltraps>

8010670e <vector127>:
.globl vector127
vector127:
  pushl $0
8010670e:	6a 00                	push   $0x0
  pushl $127
80106710:	6a 7f                	push   $0x7f
  jmp alltraps
80106712:	e9 a0 f6 ff ff       	jmp    80105db7 <alltraps>

80106717 <vector128>:
.globl vector128
vector128:
  pushl $0
80106717:	6a 00                	push   $0x0
  pushl $128
80106719:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010671e:	e9 94 f6 ff ff       	jmp    80105db7 <alltraps>

80106723 <vector129>:
.globl vector129
vector129:
  pushl $0
80106723:	6a 00                	push   $0x0
  pushl $129
80106725:	68 81 00 00 00       	push   $0x81
  jmp alltraps
8010672a:	e9 88 f6 ff ff       	jmp    80105db7 <alltraps>

8010672f <vector130>:
.globl vector130
vector130:
  pushl $0
8010672f:	6a 00                	push   $0x0
  pushl $130
80106731:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106736:	e9 7c f6 ff ff       	jmp    80105db7 <alltraps>

8010673b <vector131>:
.globl vector131
vector131:
  pushl $0
8010673b:	6a 00                	push   $0x0
  pushl $131
8010673d:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106742:	e9 70 f6 ff ff       	jmp    80105db7 <alltraps>

80106747 <vector132>:
.globl vector132
vector132:
  pushl $0
80106747:	6a 00                	push   $0x0
  pushl $132
80106749:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010674e:	e9 64 f6 ff ff       	jmp    80105db7 <alltraps>

80106753 <vector133>:
.globl vector133
vector133:
  pushl $0
80106753:	6a 00                	push   $0x0
  pushl $133
80106755:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010675a:	e9 58 f6 ff ff       	jmp    80105db7 <alltraps>

8010675f <vector134>:
.globl vector134
vector134:
  pushl $0
8010675f:	6a 00                	push   $0x0
  pushl $134
80106761:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106766:	e9 4c f6 ff ff       	jmp    80105db7 <alltraps>

8010676b <vector135>:
.globl vector135
vector135:
  pushl $0
8010676b:	6a 00                	push   $0x0
  pushl $135
8010676d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106772:	e9 40 f6 ff ff       	jmp    80105db7 <alltraps>

80106777 <vector136>:
.globl vector136
vector136:
  pushl $0
80106777:	6a 00                	push   $0x0
  pushl $136
80106779:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010677e:	e9 34 f6 ff ff       	jmp    80105db7 <alltraps>

80106783 <vector137>:
.globl vector137
vector137:
  pushl $0
80106783:	6a 00                	push   $0x0
  pushl $137
80106785:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010678a:	e9 28 f6 ff ff       	jmp    80105db7 <alltraps>

8010678f <vector138>:
.globl vector138
vector138:
  pushl $0
8010678f:	6a 00                	push   $0x0
  pushl $138
80106791:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106796:	e9 1c f6 ff ff       	jmp    80105db7 <alltraps>

8010679b <vector139>:
.globl vector139
vector139:
  pushl $0
8010679b:	6a 00                	push   $0x0
  pushl $139
8010679d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801067a2:	e9 10 f6 ff ff       	jmp    80105db7 <alltraps>

801067a7 <vector140>:
.globl vector140
vector140:
  pushl $0
801067a7:	6a 00                	push   $0x0
  pushl $140
801067a9:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801067ae:	e9 04 f6 ff ff       	jmp    80105db7 <alltraps>

801067b3 <vector141>:
.globl vector141
vector141:
  pushl $0
801067b3:	6a 00                	push   $0x0
  pushl $141
801067b5:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801067ba:	e9 f8 f5 ff ff       	jmp    80105db7 <alltraps>

801067bf <vector142>:
.globl vector142
vector142:
  pushl $0
801067bf:	6a 00                	push   $0x0
  pushl $142
801067c1:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801067c6:	e9 ec f5 ff ff       	jmp    80105db7 <alltraps>

801067cb <vector143>:
.globl vector143
vector143:
  pushl $0
801067cb:	6a 00                	push   $0x0
  pushl $143
801067cd:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801067d2:	e9 e0 f5 ff ff       	jmp    80105db7 <alltraps>

801067d7 <vector144>:
.globl vector144
vector144:
  pushl $0
801067d7:	6a 00                	push   $0x0
  pushl $144
801067d9:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801067de:	e9 d4 f5 ff ff       	jmp    80105db7 <alltraps>

801067e3 <vector145>:
.globl vector145
vector145:
  pushl $0
801067e3:	6a 00                	push   $0x0
  pushl $145
801067e5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801067ea:	e9 c8 f5 ff ff       	jmp    80105db7 <alltraps>

801067ef <vector146>:
.globl vector146
vector146:
  pushl $0
801067ef:	6a 00                	push   $0x0
  pushl $146
801067f1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801067f6:	e9 bc f5 ff ff       	jmp    80105db7 <alltraps>

801067fb <vector147>:
.globl vector147
vector147:
  pushl $0
801067fb:	6a 00                	push   $0x0
  pushl $147
801067fd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106802:	e9 b0 f5 ff ff       	jmp    80105db7 <alltraps>

80106807 <vector148>:
.globl vector148
vector148:
  pushl $0
80106807:	6a 00                	push   $0x0
  pushl $148
80106809:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010680e:	e9 a4 f5 ff ff       	jmp    80105db7 <alltraps>

80106813 <vector149>:
.globl vector149
vector149:
  pushl $0
80106813:	6a 00                	push   $0x0
  pushl $149
80106815:	68 95 00 00 00       	push   $0x95
  jmp alltraps
8010681a:	e9 98 f5 ff ff       	jmp    80105db7 <alltraps>

8010681f <vector150>:
.globl vector150
vector150:
  pushl $0
8010681f:	6a 00                	push   $0x0
  pushl $150
80106821:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106826:	e9 8c f5 ff ff       	jmp    80105db7 <alltraps>

8010682b <vector151>:
.globl vector151
vector151:
  pushl $0
8010682b:	6a 00                	push   $0x0
  pushl $151
8010682d:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106832:	e9 80 f5 ff ff       	jmp    80105db7 <alltraps>

80106837 <vector152>:
.globl vector152
vector152:
  pushl $0
80106837:	6a 00                	push   $0x0
  pushl $152
80106839:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010683e:	e9 74 f5 ff ff       	jmp    80105db7 <alltraps>

80106843 <vector153>:
.globl vector153
vector153:
  pushl $0
80106843:	6a 00                	push   $0x0
  pushl $153
80106845:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010684a:	e9 68 f5 ff ff       	jmp    80105db7 <alltraps>

8010684f <vector154>:
.globl vector154
vector154:
  pushl $0
8010684f:	6a 00                	push   $0x0
  pushl $154
80106851:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106856:	e9 5c f5 ff ff       	jmp    80105db7 <alltraps>

8010685b <vector155>:
.globl vector155
vector155:
  pushl $0
8010685b:	6a 00                	push   $0x0
  pushl $155
8010685d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106862:	e9 50 f5 ff ff       	jmp    80105db7 <alltraps>

80106867 <vector156>:
.globl vector156
vector156:
  pushl $0
80106867:	6a 00                	push   $0x0
  pushl $156
80106869:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010686e:	e9 44 f5 ff ff       	jmp    80105db7 <alltraps>

80106873 <vector157>:
.globl vector157
vector157:
  pushl $0
80106873:	6a 00                	push   $0x0
  pushl $157
80106875:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010687a:	e9 38 f5 ff ff       	jmp    80105db7 <alltraps>

8010687f <vector158>:
.globl vector158
vector158:
  pushl $0
8010687f:	6a 00                	push   $0x0
  pushl $158
80106881:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106886:	e9 2c f5 ff ff       	jmp    80105db7 <alltraps>

8010688b <vector159>:
.globl vector159
vector159:
  pushl $0
8010688b:	6a 00                	push   $0x0
  pushl $159
8010688d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106892:	e9 20 f5 ff ff       	jmp    80105db7 <alltraps>

80106897 <vector160>:
.globl vector160
vector160:
  pushl $0
80106897:	6a 00                	push   $0x0
  pushl $160
80106899:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010689e:	e9 14 f5 ff ff       	jmp    80105db7 <alltraps>

801068a3 <vector161>:
.globl vector161
vector161:
  pushl $0
801068a3:	6a 00                	push   $0x0
  pushl $161
801068a5:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801068aa:	e9 08 f5 ff ff       	jmp    80105db7 <alltraps>

801068af <vector162>:
.globl vector162
vector162:
  pushl $0
801068af:	6a 00                	push   $0x0
  pushl $162
801068b1:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801068b6:	e9 fc f4 ff ff       	jmp    80105db7 <alltraps>

801068bb <vector163>:
.globl vector163
vector163:
  pushl $0
801068bb:	6a 00                	push   $0x0
  pushl $163
801068bd:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801068c2:	e9 f0 f4 ff ff       	jmp    80105db7 <alltraps>

801068c7 <vector164>:
.globl vector164
vector164:
  pushl $0
801068c7:	6a 00                	push   $0x0
  pushl $164
801068c9:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801068ce:	e9 e4 f4 ff ff       	jmp    80105db7 <alltraps>

801068d3 <vector165>:
.globl vector165
vector165:
  pushl $0
801068d3:	6a 00                	push   $0x0
  pushl $165
801068d5:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801068da:	e9 d8 f4 ff ff       	jmp    80105db7 <alltraps>

801068df <vector166>:
.globl vector166
vector166:
  pushl $0
801068df:	6a 00                	push   $0x0
  pushl $166
801068e1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801068e6:	e9 cc f4 ff ff       	jmp    80105db7 <alltraps>

801068eb <vector167>:
.globl vector167
vector167:
  pushl $0
801068eb:	6a 00                	push   $0x0
  pushl $167
801068ed:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801068f2:	e9 c0 f4 ff ff       	jmp    80105db7 <alltraps>

801068f7 <vector168>:
.globl vector168
vector168:
  pushl $0
801068f7:	6a 00                	push   $0x0
  pushl $168
801068f9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801068fe:	e9 b4 f4 ff ff       	jmp    80105db7 <alltraps>

80106903 <vector169>:
.globl vector169
vector169:
  pushl $0
80106903:	6a 00                	push   $0x0
  pushl $169
80106905:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
8010690a:	e9 a8 f4 ff ff       	jmp    80105db7 <alltraps>

8010690f <vector170>:
.globl vector170
vector170:
  pushl $0
8010690f:	6a 00                	push   $0x0
  pushl $170
80106911:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106916:	e9 9c f4 ff ff       	jmp    80105db7 <alltraps>

8010691b <vector171>:
.globl vector171
vector171:
  pushl $0
8010691b:	6a 00                	push   $0x0
  pushl $171
8010691d:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106922:	e9 90 f4 ff ff       	jmp    80105db7 <alltraps>

80106927 <vector172>:
.globl vector172
vector172:
  pushl $0
80106927:	6a 00                	push   $0x0
  pushl $172
80106929:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010692e:	e9 84 f4 ff ff       	jmp    80105db7 <alltraps>

80106933 <vector173>:
.globl vector173
vector173:
  pushl $0
80106933:	6a 00                	push   $0x0
  pushl $173
80106935:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
8010693a:	e9 78 f4 ff ff       	jmp    80105db7 <alltraps>

8010693f <vector174>:
.globl vector174
vector174:
  pushl $0
8010693f:	6a 00                	push   $0x0
  pushl $174
80106941:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106946:	e9 6c f4 ff ff       	jmp    80105db7 <alltraps>

8010694b <vector175>:
.globl vector175
vector175:
  pushl $0
8010694b:	6a 00                	push   $0x0
  pushl $175
8010694d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106952:	e9 60 f4 ff ff       	jmp    80105db7 <alltraps>

80106957 <vector176>:
.globl vector176
vector176:
  pushl $0
80106957:	6a 00                	push   $0x0
  pushl $176
80106959:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010695e:	e9 54 f4 ff ff       	jmp    80105db7 <alltraps>

80106963 <vector177>:
.globl vector177
vector177:
  pushl $0
80106963:	6a 00                	push   $0x0
  pushl $177
80106965:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010696a:	e9 48 f4 ff ff       	jmp    80105db7 <alltraps>

8010696f <vector178>:
.globl vector178
vector178:
  pushl $0
8010696f:	6a 00                	push   $0x0
  pushl $178
80106971:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106976:	e9 3c f4 ff ff       	jmp    80105db7 <alltraps>

8010697b <vector179>:
.globl vector179
vector179:
  pushl $0
8010697b:	6a 00                	push   $0x0
  pushl $179
8010697d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106982:	e9 30 f4 ff ff       	jmp    80105db7 <alltraps>

80106987 <vector180>:
.globl vector180
vector180:
  pushl $0
80106987:	6a 00                	push   $0x0
  pushl $180
80106989:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010698e:	e9 24 f4 ff ff       	jmp    80105db7 <alltraps>

80106993 <vector181>:
.globl vector181
vector181:
  pushl $0
80106993:	6a 00                	push   $0x0
  pushl $181
80106995:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010699a:	e9 18 f4 ff ff       	jmp    80105db7 <alltraps>

8010699f <vector182>:
.globl vector182
vector182:
  pushl $0
8010699f:	6a 00                	push   $0x0
  pushl $182
801069a1:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801069a6:	e9 0c f4 ff ff       	jmp    80105db7 <alltraps>

801069ab <vector183>:
.globl vector183
vector183:
  pushl $0
801069ab:	6a 00                	push   $0x0
  pushl $183
801069ad:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801069b2:	e9 00 f4 ff ff       	jmp    80105db7 <alltraps>

801069b7 <vector184>:
.globl vector184
vector184:
  pushl $0
801069b7:	6a 00                	push   $0x0
  pushl $184
801069b9:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801069be:	e9 f4 f3 ff ff       	jmp    80105db7 <alltraps>

801069c3 <vector185>:
.globl vector185
vector185:
  pushl $0
801069c3:	6a 00                	push   $0x0
  pushl $185
801069c5:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801069ca:	e9 e8 f3 ff ff       	jmp    80105db7 <alltraps>

801069cf <vector186>:
.globl vector186
vector186:
  pushl $0
801069cf:	6a 00                	push   $0x0
  pushl $186
801069d1:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801069d6:	e9 dc f3 ff ff       	jmp    80105db7 <alltraps>

801069db <vector187>:
.globl vector187
vector187:
  pushl $0
801069db:	6a 00                	push   $0x0
  pushl $187
801069dd:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801069e2:	e9 d0 f3 ff ff       	jmp    80105db7 <alltraps>

801069e7 <vector188>:
.globl vector188
vector188:
  pushl $0
801069e7:	6a 00                	push   $0x0
  pushl $188
801069e9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801069ee:	e9 c4 f3 ff ff       	jmp    80105db7 <alltraps>

801069f3 <vector189>:
.globl vector189
vector189:
  pushl $0
801069f3:	6a 00                	push   $0x0
  pushl $189
801069f5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801069fa:	e9 b8 f3 ff ff       	jmp    80105db7 <alltraps>

801069ff <vector190>:
.globl vector190
vector190:
  pushl $0
801069ff:	6a 00                	push   $0x0
  pushl $190
80106a01:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106a06:	e9 ac f3 ff ff       	jmp    80105db7 <alltraps>

80106a0b <vector191>:
.globl vector191
vector191:
  pushl $0
80106a0b:	6a 00                	push   $0x0
  pushl $191
80106a0d:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106a12:	e9 a0 f3 ff ff       	jmp    80105db7 <alltraps>

80106a17 <vector192>:
.globl vector192
vector192:
  pushl $0
80106a17:	6a 00                	push   $0x0
  pushl $192
80106a19:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
80106a1e:	e9 94 f3 ff ff       	jmp    80105db7 <alltraps>

80106a23 <vector193>:
.globl vector193
vector193:
  pushl $0
80106a23:	6a 00                	push   $0x0
  pushl $193
80106a25:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106a2a:	e9 88 f3 ff ff       	jmp    80105db7 <alltraps>

80106a2f <vector194>:
.globl vector194
vector194:
  pushl $0
80106a2f:	6a 00                	push   $0x0
  pushl $194
80106a31:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106a36:	e9 7c f3 ff ff       	jmp    80105db7 <alltraps>

80106a3b <vector195>:
.globl vector195
vector195:
  pushl $0
80106a3b:	6a 00                	push   $0x0
  pushl $195
80106a3d:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106a42:	e9 70 f3 ff ff       	jmp    80105db7 <alltraps>

80106a47 <vector196>:
.globl vector196
vector196:
  pushl $0
80106a47:	6a 00                	push   $0x0
  pushl $196
80106a49:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
80106a4e:	e9 64 f3 ff ff       	jmp    80105db7 <alltraps>

80106a53 <vector197>:
.globl vector197
vector197:
  pushl $0
80106a53:	6a 00                	push   $0x0
  pushl $197
80106a55:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106a5a:	e9 58 f3 ff ff       	jmp    80105db7 <alltraps>

80106a5f <vector198>:
.globl vector198
vector198:
  pushl $0
80106a5f:	6a 00                	push   $0x0
  pushl $198
80106a61:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106a66:	e9 4c f3 ff ff       	jmp    80105db7 <alltraps>

80106a6b <vector199>:
.globl vector199
vector199:
  pushl $0
80106a6b:	6a 00                	push   $0x0
  pushl $199
80106a6d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106a72:	e9 40 f3 ff ff       	jmp    80105db7 <alltraps>

80106a77 <vector200>:
.globl vector200
vector200:
  pushl $0
80106a77:	6a 00                	push   $0x0
  pushl $200
80106a79:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
80106a7e:	e9 34 f3 ff ff       	jmp    80105db7 <alltraps>

80106a83 <vector201>:
.globl vector201
vector201:
  pushl $0
80106a83:	6a 00                	push   $0x0
  pushl $201
80106a85:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
80106a8a:	e9 28 f3 ff ff       	jmp    80105db7 <alltraps>

80106a8f <vector202>:
.globl vector202
vector202:
  pushl $0
80106a8f:	6a 00                	push   $0x0
  pushl $202
80106a91:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106a96:	e9 1c f3 ff ff       	jmp    80105db7 <alltraps>

80106a9b <vector203>:
.globl vector203
vector203:
  pushl $0
80106a9b:	6a 00                	push   $0x0
  pushl $203
80106a9d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106aa2:	e9 10 f3 ff ff       	jmp    80105db7 <alltraps>

80106aa7 <vector204>:
.globl vector204
vector204:
  pushl $0
80106aa7:	6a 00                	push   $0x0
  pushl $204
80106aa9:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
80106aae:	e9 04 f3 ff ff       	jmp    80105db7 <alltraps>

80106ab3 <vector205>:
.globl vector205
vector205:
  pushl $0
80106ab3:	6a 00                	push   $0x0
  pushl $205
80106ab5:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
80106aba:	e9 f8 f2 ff ff       	jmp    80105db7 <alltraps>

80106abf <vector206>:
.globl vector206
vector206:
  pushl $0
80106abf:	6a 00                	push   $0x0
  pushl $206
80106ac1:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106ac6:	e9 ec f2 ff ff       	jmp    80105db7 <alltraps>

80106acb <vector207>:
.globl vector207
vector207:
  pushl $0
80106acb:	6a 00                	push   $0x0
  pushl $207
80106acd:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106ad2:	e9 e0 f2 ff ff       	jmp    80105db7 <alltraps>

80106ad7 <vector208>:
.globl vector208
vector208:
  pushl $0
80106ad7:	6a 00                	push   $0x0
  pushl $208
80106ad9:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
80106ade:	e9 d4 f2 ff ff       	jmp    80105db7 <alltraps>

80106ae3 <vector209>:
.globl vector209
vector209:
  pushl $0
80106ae3:	6a 00                	push   $0x0
  pushl $209
80106ae5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106aea:	e9 c8 f2 ff ff       	jmp    80105db7 <alltraps>

80106aef <vector210>:
.globl vector210
vector210:
  pushl $0
80106aef:	6a 00                	push   $0x0
  pushl $210
80106af1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106af6:	e9 bc f2 ff ff       	jmp    80105db7 <alltraps>

80106afb <vector211>:
.globl vector211
vector211:
  pushl $0
80106afb:	6a 00                	push   $0x0
  pushl $211
80106afd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106b02:	e9 b0 f2 ff ff       	jmp    80105db7 <alltraps>

80106b07 <vector212>:
.globl vector212
vector212:
  pushl $0
80106b07:	6a 00                	push   $0x0
  pushl $212
80106b09:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
80106b0e:	e9 a4 f2 ff ff       	jmp    80105db7 <alltraps>

80106b13 <vector213>:
.globl vector213
vector213:
  pushl $0
80106b13:	6a 00                	push   $0x0
  pushl $213
80106b15:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106b1a:	e9 98 f2 ff ff       	jmp    80105db7 <alltraps>

80106b1f <vector214>:
.globl vector214
vector214:
  pushl $0
80106b1f:	6a 00                	push   $0x0
  pushl $214
80106b21:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106b26:	e9 8c f2 ff ff       	jmp    80105db7 <alltraps>

80106b2b <vector215>:
.globl vector215
vector215:
  pushl $0
80106b2b:	6a 00                	push   $0x0
  pushl $215
80106b2d:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106b32:	e9 80 f2 ff ff       	jmp    80105db7 <alltraps>

80106b37 <vector216>:
.globl vector216
vector216:
  pushl $0
80106b37:	6a 00                	push   $0x0
  pushl $216
80106b39:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
80106b3e:	e9 74 f2 ff ff       	jmp    80105db7 <alltraps>

80106b43 <vector217>:
.globl vector217
vector217:
  pushl $0
80106b43:	6a 00                	push   $0x0
  pushl $217
80106b45:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106b4a:	e9 68 f2 ff ff       	jmp    80105db7 <alltraps>

80106b4f <vector218>:
.globl vector218
vector218:
  pushl $0
80106b4f:	6a 00                	push   $0x0
  pushl $218
80106b51:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106b56:	e9 5c f2 ff ff       	jmp    80105db7 <alltraps>

80106b5b <vector219>:
.globl vector219
vector219:
  pushl $0
80106b5b:	6a 00                	push   $0x0
  pushl $219
80106b5d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106b62:	e9 50 f2 ff ff       	jmp    80105db7 <alltraps>

80106b67 <vector220>:
.globl vector220
vector220:
  pushl $0
80106b67:	6a 00                	push   $0x0
  pushl $220
80106b69:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
80106b6e:	e9 44 f2 ff ff       	jmp    80105db7 <alltraps>

80106b73 <vector221>:
.globl vector221
vector221:
  pushl $0
80106b73:	6a 00                	push   $0x0
  pushl $221
80106b75:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106b7a:	e9 38 f2 ff ff       	jmp    80105db7 <alltraps>

80106b7f <vector222>:
.globl vector222
vector222:
  pushl $0
80106b7f:	6a 00                	push   $0x0
  pushl $222
80106b81:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106b86:	e9 2c f2 ff ff       	jmp    80105db7 <alltraps>

80106b8b <vector223>:
.globl vector223
vector223:
  pushl $0
80106b8b:	6a 00                	push   $0x0
  pushl $223
80106b8d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106b92:	e9 20 f2 ff ff       	jmp    80105db7 <alltraps>

80106b97 <vector224>:
.globl vector224
vector224:
  pushl $0
80106b97:	6a 00                	push   $0x0
  pushl $224
80106b99:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
80106b9e:	e9 14 f2 ff ff       	jmp    80105db7 <alltraps>

80106ba3 <vector225>:
.globl vector225
vector225:
  pushl $0
80106ba3:	6a 00                	push   $0x0
  pushl $225
80106ba5:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
80106baa:	e9 08 f2 ff ff       	jmp    80105db7 <alltraps>

80106baf <vector226>:
.globl vector226
vector226:
  pushl $0
80106baf:	6a 00                	push   $0x0
  pushl $226
80106bb1:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106bb6:	e9 fc f1 ff ff       	jmp    80105db7 <alltraps>

80106bbb <vector227>:
.globl vector227
vector227:
  pushl $0
80106bbb:	6a 00                	push   $0x0
  pushl $227
80106bbd:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106bc2:	e9 f0 f1 ff ff       	jmp    80105db7 <alltraps>

80106bc7 <vector228>:
.globl vector228
vector228:
  pushl $0
80106bc7:	6a 00                	push   $0x0
  pushl $228
80106bc9:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
80106bce:	e9 e4 f1 ff ff       	jmp    80105db7 <alltraps>

80106bd3 <vector229>:
.globl vector229
vector229:
  pushl $0
80106bd3:	6a 00                	push   $0x0
  pushl $229
80106bd5:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
80106bda:	e9 d8 f1 ff ff       	jmp    80105db7 <alltraps>

80106bdf <vector230>:
.globl vector230
vector230:
  pushl $0
80106bdf:	6a 00                	push   $0x0
  pushl $230
80106be1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106be6:	e9 cc f1 ff ff       	jmp    80105db7 <alltraps>

80106beb <vector231>:
.globl vector231
vector231:
  pushl $0
80106beb:	6a 00                	push   $0x0
  pushl $231
80106bed:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106bf2:	e9 c0 f1 ff ff       	jmp    80105db7 <alltraps>

80106bf7 <vector232>:
.globl vector232
vector232:
  pushl $0
80106bf7:	6a 00                	push   $0x0
  pushl $232
80106bf9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
80106bfe:	e9 b4 f1 ff ff       	jmp    80105db7 <alltraps>

80106c03 <vector233>:
.globl vector233
vector233:
  pushl $0
80106c03:	6a 00                	push   $0x0
  pushl $233
80106c05:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106c0a:	e9 a8 f1 ff ff       	jmp    80105db7 <alltraps>

80106c0f <vector234>:
.globl vector234
vector234:
  pushl $0
80106c0f:	6a 00                	push   $0x0
  pushl $234
80106c11:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106c16:	e9 9c f1 ff ff       	jmp    80105db7 <alltraps>

80106c1b <vector235>:
.globl vector235
vector235:
  pushl $0
80106c1b:	6a 00                	push   $0x0
  pushl $235
80106c1d:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106c22:	e9 90 f1 ff ff       	jmp    80105db7 <alltraps>

80106c27 <vector236>:
.globl vector236
vector236:
  pushl $0
80106c27:	6a 00                	push   $0x0
  pushl $236
80106c29:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
80106c2e:	e9 84 f1 ff ff       	jmp    80105db7 <alltraps>

80106c33 <vector237>:
.globl vector237
vector237:
  pushl $0
80106c33:	6a 00                	push   $0x0
  pushl $237
80106c35:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106c3a:	e9 78 f1 ff ff       	jmp    80105db7 <alltraps>

80106c3f <vector238>:
.globl vector238
vector238:
  pushl $0
80106c3f:	6a 00                	push   $0x0
  pushl $238
80106c41:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106c46:	e9 6c f1 ff ff       	jmp    80105db7 <alltraps>

80106c4b <vector239>:
.globl vector239
vector239:
  pushl $0
80106c4b:	6a 00                	push   $0x0
  pushl $239
80106c4d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106c52:	e9 60 f1 ff ff       	jmp    80105db7 <alltraps>

80106c57 <vector240>:
.globl vector240
vector240:
  pushl $0
80106c57:	6a 00                	push   $0x0
  pushl $240
80106c59:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
80106c5e:	e9 54 f1 ff ff       	jmp    80105db7 <alltraps>

80106c63 <vector241>:
.globl vector241
vector241:
  pushl $0
80106c63:	6a 00                	push   $0x0
  pushl $241
80106c65:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106c6a:	e9 48 f1 ff ff       	jmp    80105db7 <alltraps>

80106c6f <vector242>:
.globl vector242
vector242:
  pushl $0
80106c6f:	6a 00                	push   $0x0
  pushl $242
80106c71:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106c76:	e9 3c f1 ff ff       	jmp    80105db7 <alltraps>

80106c7b <vector243>:
.globl vector243
vector243:
  pushl $0
80106c7b:	6a 00                	push   $0x0
  pushl $243
80106c7d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106c82:	e9 30 f1 ff ff       	jmp    80105db7 <alltraps>

80106c87 <vector244>:
.globl vector244
vector244:
  pushl $0
80106c87:	6a 00                	push   $0x0
  pushl $244
80106c89:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
80106c8e:	e9 24 f1 ff ff       	jmp    80105db7 <alltraps>

80106c93 <vector245>:
.globl vector245
vector245:
  pushl $0
80106c93:	6a 00                	push   $0x0
  pushl $245
80106c95:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
80106c9a:	e9 18 f1 ff ff       	jmp    80105db7 <alltraps>

80106c9f <vector246>:
.globl vector246
vector246:
  pushl $0
80106c9f:	6a 00                	push   $0x0
  pushl $246
80106ca1:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106ca6:	e9 0c f1 ff ff       	jmp    80105db7 <alltraps>

80106cab <vector247>:
.globl vector247
vector247:
  pushl $0
80106cab:	6a 00                	push   $0x0
  pushl $247
80106cad:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106cb2:	e9 00 f1 ff ff       	jmp    80105db7 <alltraps>

80106cb7 <vector248>:
.globl vector248
vector248:
  pushl $0
80106cb7:	6a 00                	push   $0x0
  pushl $248
80106cb9:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
80106cbe:	e9 f4 f0 ff ff       	jmp    80105db7 <alltraps>

80106cc3 <vector249>:
.globl vector249
vector249:
  pushl $0
80106cc3:	6a 00                	push   $0x0
  pushl $249
80106cc5:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
80106cca:	e9 e8 f0 ff ff       	jmp    80105db7 <alltraps>

80106ccf <vector250>:
.globl vector250
vector250:
  pushl $0
80106ccf:	6a 00                	push   $0x0
  pushl $250
80106cd1:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106cd6:	e9 dc f0 ff ff       	jmp    80105db7 <alltraps>

80106cdb <vector251>:
.globl vector251
vector251:
  pushl $0
80106cdb:	6a 00                	push   $0x0
  pushl $251
80106cdd:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106ce2:	e9 d0 f0 ff ff       	jmp    80105db7 <alltraps>

80106ce7 <vector252>:
.globl vector252
vector252:
  pushl $0
80106ce7:	6a 00                	push   $0x0
  pushl $252
80106ce9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
80106cee:	e9 c4 f0 ff ff       	jmp    80105db7 <alltraps>

80106cf3 <vector253>:
.globl vector253
vector253:
  pushl $0
80106cf3:	6a 00                	push   $0x0
  pushl $253
80106cf5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106cfa:	e9 b8 f0 ff ff       	jmp    80105db7 <alltraps>

80106cff <vector254>:
.globl vector254
vector254:
  pushl $0
80106cff:	6a 00                	push   $0x0
  pushl $254
80106d01:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106d06:	e9 ac f0 ff ff       	jmp    80105db7 <alltraps>

80106d0b <vector255>:
.globl vector255
vector255:
  pushl $0
80106d0b:	6a 00                	push   $0x0
  pushl $255
80106d0d:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106d12:	e9 a0 f0 ff ff       	jmp    80105db7 <alltraps>
80106d17:	66 90                	xchg   %ax,%ax
80106d19:	66 90                	xchg   %ax,%ax
80106d1b:	66 90                	xchg   %ax,%ax
80106d1d:	66 90                	xchg   %ax,%ax
80106d1f:	90                   	nop

80106d20 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d20:	55                   	push   %ebp
80106d21:	89 e5                	mov    %esp,%ebp
80106d23:	57                   	push   %edi
80106d24:	56                   	push   %esi
80106d25:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106d26:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
80106d2c:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106d32:	83 ec 1c             	sub    $0x1c,%esp
80106d35:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106d38:	39 d3                	cmp    %edx,%ebx
80106d3a:	73 49                	jae    80106d85 <deallocuvm.part.0+0x65>
80106d3c:	89 c7                	mov    %eax,%edi
80106d3e:	eb 0c                	jmp    80106d4c <deallocuvm.part.0+0x2c>
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
80106d40:	83 c0 01             	add    $0x1,%eax
80106d43:	c1 e0 16             	shl    $0x16,%eax
80106d46:	89 c3                	mov    %eax,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106d48:	39 da                	cmp    %ebx,%edx
80106d4a:	76 39                	jbe    80106d85 <deallocuvm.part.0+0x65>
  pde = &pgdir[PDX(va)];
80106d4c:	89 d8                	mov    %ebx,%eax
80106d4e:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
80106d51:	8b 0c 87             	mov    (%edi,%eax,4),%ecx
80106d54:	f6 c1 01             	test   $0x1,%cl
80106d57:	74 e7                	je     80106d40 <deallocuvm.part.0+0x20>
  return &pgtab[PTX(va)];
80106d59:	89 de                	mov    %ebx,%esi
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106d5b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
80106d61:	c1 ee 0a             	shr    $0xa,%esi
80106d64:	81 e6 fc 0f 00 00    	and    $0xffc,%esi
80106d6a:	8d b4 31 00 00 00 80 	lea    -0x80000000(%ecx,%esi,1),%esi
    if(!pte)
80106d71:	85 f6                	test   %esi,%esi
80106d73:	74 cb                	je     80106d40 <deallocuvm.part.0+0x20>
    else if((*pte & PTE_P) != 0){
80106d75:	8b 06                	mov    (%esi),%eax
80106d77:	a8 01                	test   $0x1,%al
80106d79:	75 15                	jne    80106d90 <deallocuvm.part.0+0x70>
  for(; a  < oldsz; a += PGSIZE){
80106d7b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106d81:	39 da                	cmp    %ebx,%edx
80106d83:	77 c7                	ja     80106d4c <deallocuvm.part.0+0x2c>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d85:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106d88:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d8b:	5b                   	pop    %ebx
80106d8c:	5e                   	pop    %esi
80106d8d:	5f                   	pop    %edi
80106d8e:	5d                   	pop    %ebp
80106d8f:	c3                   	ret    
      if(pa == 0)
80106d90:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d95:	74 25                	je     80106dbc <deallocuvm.part.0+0x9c>
      kfree(v);
80106d97:	83 ec 0c             	sub    $0xc,%esp
      char *v = P2V(pa);
80106d9a:	05 00 00 00 80       	add    $0x80000000,%eax
80106d9f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(; a  < oldsz; a += PGSIZE){
80106da2:	81 c3 00 10 00 00    	add    $0x1000,%ebx
      kfree(v);
80106da8:	50                   	push   %eax
80106da9:	e8 c2 b7 ff ff       	call   80102570 <kfree>
      *pte = 0;
80106dae:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  for(; a  < oldsz; a += PGSIZE){
80106db4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106db7:	83 c4 10             	add    $0x10,%esp
80106dba:	eb 8c                	jmp    80106d48 <deallocuvm.part.0+0x28>
        panic("kfree");
80106dbc:	83 ec 0c             	sub    $0xc,%esp
80106dbf:	68 86 79 10 80       	push   $0x80107986
80106dc4:	e8 b7 95 ff ff       	call   80100380 <panic>
80106dc9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106dd0 <mappages>:
{
80106dd0:	55                   	push   %ebp
80106dd1:	89 e5                	mov    %esp,%ebp
80106dd3:	57                   	push   %edi
80106dd4:	56                   	push   %esi
80106dd5:	53                   	push   %ebx
  a = (char*)PGROUNDDOWN((uint)va);
80106dd6:	89 d3                	mov    %edx,%ebx
80106dd8:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
{
80106dde:	83 ec 1c             	sub    $0x1c,%esp
80106de1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106de4:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106de8:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106ded:	89 45 dc             	mov    %eax,-0x24(%ebp)
80106df0:	8b 45 08             	mov    0x8(%ebp),%eax
80106df3:	29 d8                	sub    %ebx,%eax
80106df5:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106df8:	eb 3d                	jmp    80106e37 <mappages+0x67>
80106dfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80106e00:	89 da                	mov    %ebx,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106e02:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80106e07:	c1 ea 0a             	shr    $0xa,%edx
80106e0a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106e10:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106e17:	85 c0                	test   %eax,%eax
80106e19:	74 75                	je     80106e90 <mappages+0xc0>
    if(*pte & PTE_P)
80106e1b:	f6 00 01             	testb  $0x1,(%eax)
80106e1e:	0f 85 86 00 00 00    	jne    80106eaa <mappages+0xda>
    *pte = pa | perm | PTE_P;
80106e24:	0b 75 0c             	or     0xc(%ebp),%esi
80106e27:	83 ce 01             	or     $0x1,%esi
80106e2a:	89 30                	mov    %esi,(%eax)
    if(a == last)
80106e2c:	3b 5d dc             	cmp    -0x24(%ebp),%ebx
80106e2f:	74 6f                	je     80106ea0 <mappages+0xd0>
    a += PGSIZE;
80106e31:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  for(;;){
80106e37:	8b 45 e0             	mov    -0x20(%ebp),%eax
  pde = &pgdir[PDX(va)];
80106e3a:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106e3d:	8d 34 18             	lea    (%eax,%ebx,1),%esi
80106e40:	89 d8                	mov    %ebx,%eax
80106e42:	c1 e8 16             	shr    $0x16,%eax
80106e45:	8d 3c 81             	lea    (%ecx,%eax,4),%edi
  if(*pde & PTE_P){
80106e48:	8b 07                	mov    (%edi),%eax
80106e4a:	a8 01                	test   $0x1,%al
80106e4c:	75 b2                	jne    80106e00 <mappages+0x30>
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106e4e:	e8 dd b8 ff ff       	call   80102730 <kalloc>
80106e53:	85 c0                	test   %eax,%eax
80106e55:	74 39                	je     80106e90 <mappages+0xc0>
    memset(pgtab, 0, PGSIZE);
80106e57:	83 ec 04             	sub    $0x4,%esp
80106e5a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80106e5d:	68 00 10 00 00       	push   $0x1000
80106e62:	6a 00                	push   $0x0
80106e64:	50                   	push   %eax
80106e65:	e8 56 db ff ff       	call   801049c0 <memset>
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e6a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  return &pgtab[PTX(va)];
80106e6d:	83 c4 10             	add    $0x10,%esp
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
80106e70:	8d 82 00 00 00 80    	lea    -0x80000000(%edx),%eax
80106e76:	83 c8 07             	or     $0x7,%eax
80106e79:	89 07                	mov    %eax,(%edi)
  return &pgtab[PTX(va)];
80106e7b:	89 d8                	mov    %ebx,%eax
80106e7d:	c1 e8 0a             	shr    $0xa,%eax
80106e80:	25 fc 0f 00 00       	and    $0xffc,%eax
80106e85:	01 d0                	add    %edx,%eax
80106e87:	eb 92                	jmp    80106e1b <mappages+0x4b>
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
}
80106e90:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
80106e93:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80106e98:	5b                   	pop    %ebx
80106e99:	5e                   	pop    %esi
80106e9a:	5f                   	pop    %edi
80106e9b:	5d                   	pop    %ebp
80106e9c:	c3                   	ret    
80106e9d:	8d 76 00             	lea    0x0(%esi),%esi
80106ea0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
80106ea3:	31 c0                	xor    %eax,%eax
}
80106ea5:	5b                   	pop    %ebx
80106ea6:	5e                   	pop    %esi
80106ea7:	5f                   	pop    %edi
80106ea8:	5d                   	pop    %ebp
80106ea9:	c3                   	ret    
      panic("remap");
80106eaa:	83 ec 0c             	sub    $0xc,%esp
80106ead:	68 40 80 10 80       	push   $0x80108040
80106eb2:	e8 c9 94 ff ff       	call   80100380 <panic>
80106eb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106ebe:	66 90                	xchg   %ax,%ax

80106ec0 <seginit>:
{
80106ec0:	55                   	push   %ebp
80106ec1:	89 e5                	mov    %esp,%ebp
80106ec3:	83 ec 18             	sub    $0x18,%esp
  c = &cpus[cpuid()];
80106ec6:	e8 75 cd ff ff       	call   80103c40 <cpuid>
  pd[0] = size-1;
80106ecb:	ba 2f 00 00 00       	mov    $0x2f,%edx
80106ed0:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106ed6:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106eda:	c7 80 d8 28 11 80 ff 	movl   $0xffff,-0x7feed728(%eax)
80106ee1:	ff 00 00 
80106ee4:	c7 80 dc 28 11 80 00 	movl   $0xcf9a00,-0x7feed724(%eax)
80106eeb:	9a cf 00 
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106eee:	c7 80 e0 28 11 80 ff 	movl   $0xffff,-0x7feed720(%eax)
80106ef5:	ff 00 00 
80106ef8:	c7 80 e4 28 11 80 00 	movl   $0xcf9200,-0x7feed71c(%eax)
80106eff:	92 cf 00 
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106f02:	c7 80 e8 28 11 80 ff 	movl   $0xffff,-0x7feed718(%eax)
80106f09:	ff 00 00 
80106f0c:	c7 80 ec 28 11 80 00 	movl   $0xcffa00,-0x7feed714(%eax)
80106f13:	fa cf 00 
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106f16:	c7 80 f0 28 11 80 ff 	movl   $0xffff,-0x7feed710(%eax)
80106f1d:	ff 00 00 
80106f20:	c7 80 f4 28 11 80 00 	movl   $0xcff200,-0x7feed70c(%eax)
80106f27:	f2 cf 00 
  lgdt(c->gdt, sizeof(c->gdt));
80106f2a:	05 d0 28 11 80       	add    $0x801128d0,%eax
  pd[1] = (uint)p;
80106f2f:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106f33:	c1 e8 10             	shr    $0x10,%eax
80106f36:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
  asm volatile("lgdt (%0)" : : "r" (pd));
80106f3a:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106f3d:	0f 01 10             	lgdtl  (%eax)
}
80106f40:	c9                   	leave  
80106f41:	c3                   	ret    
80106f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106f49:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106f50 <switchkvm>:
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106f50:	a1 04 df 11 80       	mov    0x8011df04,%eax
80106f55:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106f5a:	0f 22 d8             	mov    %eax,%cr3
}
80106f5d:	c3                   	ret    
80106f5e:	66 90                	xchg   %ax,%ax

80106f60 <switchuvm>:
{
80106f60:	55                   	push   %ebp
80106f61:	89 e5                	mov    %esp,%ebp
80106f63:	57                   	push   %edi
80106f64:	56                   	push   %esi
80106f65:	53                   	push   %ebx
80106f66:	83 ec 1c             	sub    $0x1c,%esp
80106f69:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
80106f6c:	85 f6                	test   %esi,%esi
80106f6e:	0f 84 cb 00 00 00    	je     8010703f <switchuvm+0xdf>
  if(p->kstack == 0)
80106f74:	8b 46 08             	mov    0x8(%esi),%eax
80106f77:	85 c0                	test   %eax,%eax
80106f79:	0f 84 da 00 00 00    	je     80107059 <switchuvm+0xf9>
  if(p->pgdir == 0)
80106f7f:	8b 46 04             	mov    0x4(%esi),%eax
80106f82:	85 c0                	test   %eax,%eax
80106f84:	0f 84 c2 00 00 00    	je     8010704c <switchuvm+0xec>
  pushcli();
80106f8a:	e8 21 d8 ff ff       	call   801047b0 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106f8f:	e8 4c cc ff ff       	call   80103be0 <mycpu>
80106f94:	89 c3                	mov    %eax,%ebx
80106f96:	e8 45 cc ff ff       	call   80103be0 <mycpu>
80106f9b:	89 c7                	mov    %eax,%edi
80106f9d:	e8 3e cc ff ff       	call   80103be0 <mycpu>
80106fa2:	83 c7 08             	add    $0x8,%edi
80106fa5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106fa8:	e8 33 cc ff ff       	call   80103be0 <mycpu>
80106fad:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fb0:	ba 67 00 00 00       	mov    $0x67,%edx
80106fb5:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106fbc:	83 c0 08             	add    $0x8,%eax
80106fbf:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106fc6:	bf ff ff ff ff       	mov    $0xffffffff,%edi
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
80106fcb:	83 c1 08             	add    $0x8,%ecx
80106fce:	c1 e8 18             	shr    $0x18,%eax
80106fd1:	c1 e9 10             	shr    $0x10,%ecx
80106fd4:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106fda:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106fe0:	b9 99 40 00 00       	mov    $0x4099,%ecx
80106fe5:	66 89 8b 9d 00 00 00 	mov    %cx,0x9d(%ebx)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106fec:	bb 10 00 00 00       	mov    $0x10,%ebx
  mycpu()->gdt[SEG_TSS].s = 0;
80106ff1:	e8 ea cb ff ff       	call   80103be0 <mycpu>
80106ff6:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106ffd:	e8 de cb ff ff       	call   80103be0 <mycpu>
80107002:	66 89 58 10          	mov    %bx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80107006:	8b 5e 08             	mov    0x8(%esi),%ebx
80107009:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010700f:	e8 cc cb ff ff       	call   80103be0 <mycpu>
80107014:	89 58 0c             	mov    %ebx,0xc(%eax)
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80107017:	e8 c4 cb ff ff       	call   80103be0 <mycpu>
8010701c:	66 89 78 6e          	mov    %di,0x6e(%eax)
  asm volatile("ltr %0" : : "r" (sel));
80107020:	b8 28 00 00 00       	mov    $0x28,%eax
80107025:	0f 00 d8             	ltr    %ax
  lcr3(V2P(p->pgdir));  // switch to process's address space
80107028:	8b 46 04             	mov    0x4(%esi),%eax
8010702b:	05 00 00 00 80       	add    $0x80000000,%eax
  asm volatile("movl %0,%%cr3" : : "r" (val));
80107030:	0f 22 d8             	mov    %eax,%cr3
}
80107033:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
  popcli();
8010703a:	e9 c1 d7 ff ff       	jmp    80104800 <popcli>
    panic("switchuvm: no process");
8010703f:	83 ec 0c             	sub    $0xc,%esp
80107042:	68 46 80 10 80       	push   $0x80108046
80107047:	e8 34 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no pgdir");
8010704c:	83 ec 0c             	sub    $0xc,%esp
8010704f:	68 71 80 10 80       	push   $0x80108071
80107054:	e8 27 93 ff ff       	call   80100380 <panic>
    panic("switchuvm: no kstack");
80107059:	83 ec 0c             	sub    $0xc,%esp
8010705c:	68 5c 80 10 80       	push   $0x8010805c
80107061:	e8 1a 93 ff ff       	call   80100380 <panic>
80107066:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010706d:	8d 76 00             	lea    0x0(%esi),%esi

80107070 <inituvm>:
{
80107070:	55                   	push   %ebp
80107071:	89 e5                	mov    %esp,%ebp
80107073:	57                   	push   %edi
80107074:	56                   	push   %esi
80107075:	53                   	push   %ebx
80107076:	83 ec 1c             	sub    $0x1c,%esp
80107079:	8b 45 0c             	mov    0xc(%ebp),%eax
8010707c:	8b 75 10             	mov    0x10(%ebp),%esi
8010707f:	8b 7d 08             	mov    0x8(%ebp),%edi
80107082:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(sz >= PGSIZE)
80107085:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
8010708b:	77 4b                	ja     801070d8 <inituvm+0x68>
  mem = kalloc();
8010708d:	e8 9e b6 ff ff       	call   80102730 <kalloc>
  memset(mem, 0, PGSIZE);
80107092:	83 ec 04             	sub    $0x4,%esp
80107095:	68 00 10 00 00       	push   $0x1000
  mem = kalloc();
8010709a:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
8010709c:	6a 00                	push   $0x0
8010709e:	50                   	push   %eax
8010709f:	e8 1c d9 ff ff       	call   801049c0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
801070a4:	58                   	pop    %eax
801070a5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801070ab:	5a                   	pop    %edx
801070ac:	6a 06                	push   $0x6
801070ae:	b9 00 10 00 00       	mov    $0x1000,%ecx
801070b3:	31 d2                	xor    %edx,%edx
801070b5:	50                   	push   %eax
801070b6:	89 f8                	mov    %edi,%eax
801070b8:	e8 13 fd ff ff       	call   80106dd0 <mappages>
  memmove(mem, init, sz);
801070bd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801070c0:	89 75 10             	mov    %esi,0x10(%ebp)
801070c3:	83 c4 10             	add    $0x10,%esp
801070c6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801070c9:	89 45 0c             	mov    %eax,0xc(%ebp)
}
801070cc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801070cf:	5b                   	pop    %ebx
801070d0:	5e                   	pop    %esi
801070d1:	5f                   	pop    %edi
801070d2:	5d                   	pop    %ebp
  memmove(mem, init, sz);
801070d3:	e9 88 d9 ff ff       	jmp    80104a60 <memmove>
    panic("inituvm: more than a page");
801070d8:	83 ec 0c             	sub    $0xc,%esp
801070db:	68 85 80 10 80       	push   $0x80108085
801070e0:	e8 9b 92 ff ff       	call   80100380 <panic>
801070e5:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801070ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801070f0 <loaduvm>:
{
801070f0:	55                   	push   %ebp
801070f1:	89 e5                	mov    %esp,%ebp
801070f3:	57                   	push   %edi
801070f4:	56                   	push   %esi
801070f5:	53                   	push   %ebx
801070f6:	83 ec 1c             	sub    $0x1c,%esp
801070f9:	8b 45 0c             	mov    0xc(%ebp),%eax
801070fc:	8b 75 18             	mov    0x18(%ebp),%esi
  if((uint) addr % PGSIZE != 0)
801070ff:	a9 ff 0f 00 00       	test   $0xfff,%eax
80107104:	0f 85 bb 00 00 00    	jne    801071c5 <loaduvm+0xd5>
  for(i = 0; i < sz; i += PGSIZE){
8010710a:	01 f0                	add    %esi,%eax
8010710c:	89 f3                	mov    %esi,%ebx
8010710e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107111:	8b 45 14             	mov    0x14(%ebp),%eax
80107114:	01 f0                	add    %esi,%eax
80107116:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
80107119:	85 f6                	test   %esi,%esi
8010711b:	0f 84 87 00 00 00    	je     801071a8 <loaduvm+0xb8>
80107121:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  pde = &pgdir[PDX(va)];
80107128:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  if(*pde & PTE_P){
8010712b:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010712e:	29 d8                	sub    %ebx,%eax
  pde = &pgdir[PDX(va)];
80107130:	89 c2                	mov    %eax,%edx
80107132:	c1 ea 16             	shr    $0x16,%edx
  if(*pde & PTE_P){
80107135:	8b 14 91             	mov    (%ecx,%edx,4),%edx
80107138:	f6 c2 01             	test   $0x1,%dl
8010713b:	75 13                	jne    80107150 <loaduvm+0x60>
      panic("loaduvm: address should exist");
8010713d:	83 ec 0c             	sub    $0xc,%esp
80107140:	68 9f 80 10 80       	push   $0x8010809f
80107145:	e8 36 92 ff ff       	call   80100380 <panic>
8010714a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107150:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107153:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107159:	25 fc 0f 00 00       	and    $0xffc,%eax
8010715e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80107165:	85 c0                	test   %eax,%eax
80107167:	74 d4                	je     8010713d <loaduvm+0x4d>
    pa = PTE_ADDR(*pte);
80107169:	8b 00                	mov    (%eax),%eax
    if(readi(ip, P2V(pa), offset+i, n) != n)
8010716b:	8b 4d e0             	mov    -0x20(%ebp),%ecx
    if(sz - i < PGSIZE)
8010716e:	bf 00 10 00 00       	mov    $0x1000,%edi
    pa = PTE_ADDR(*pte);
80107173:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80107178:	81 fb ff 0f 00 00    	cmp    $0xfff,%ebx
8010717e:	0f 46 fb             	cmovbe %ebx,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80107181:	29 d9                	sub    %ebx,%ecx
80107183:	05 00 00 00 80       	add    $0x80000000,%eax
80107188:	57                   	push   %edi
80107189:	51                   	push   %ecx
8010718a:	50                   	push   %eax
8010718b:	ff 75 10             	push   0x10(%ebp)
8010718e:	e8 ad a9 ff ff       	call   80101b40 <readi>
80107193:	83 c4 10             	add    $0x10,%esp
80107196:	39 f8                	cmp    %edi,%eax
80107198:	75 1e                	jne    801071b8 <loaduvm+0xc8>
  for(i = 0; i < sz; i += PGSIZE){
8010719a:	81 eb 00 10 00 00    	sub    $0x1000,%ebx
801071a0:	89 f0                	mov    %esi,%eax
801071a2:	29 d8                	sub    %ebx,%eax
801071a4:	39 c6                	cmp    %eax,%esi
801071a6:	77 80                	ja     80107128 <loaduvm+0x38>
}
801071a8:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801071ab:	31 c0                	xor    %eax,%eax
}
801071ad:	5b                   	pop    %ebx
801071ae:	5e                   	pop    %esi
801071af:	5f                   	pop    %edi
801071b0:	5d                   	pop    %ebp
801071b1:	c3                   	ret    
801071b2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801071b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801071bb:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801071c0:	5b                   	pop    %ebx
801071c1:	5e                   	pop    %esi
801071c2:	5f                   	pop    %edi
801071c3:	5d                   	pop    %ebp
801071c4:	c3                   	ret    
    panic("loaduvm: addr must be page aligned");
801071c5:	83 ec 0c             	sub    $0xc,%esp
801071c8:	68 40 81 10 80       	push   $0x80108140
801071cd:	e8 ae 91 ff ff       	call   80100380 <panic>
801071d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801071d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801071e0 <allocuvm>:
{
801071e0:	55                   	push   %ebp
801071e1:	89 e5                	mov    %esp,%ebp
801071e3:	57                   	push   %edi
801071e4:	56                   	push   %esi
801071e5:	53                   	push   %ebx
801071e6:	83 ec 1c             	sub    $0x1c,%esp
  if(newsz >= KERNBASE)
801071e9:	8b 45 10             	mov    0x10(%ebp),%eax
{
801071ec:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(newsz >= KERNBASE)
801071ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801071f2:	85 c0                	test   %eax,%eax
801071f4:	0f 88 b6 00 00 00    	js     801072b0 <allocuvm+0xd0>
  if(newsz < oldsz)
801071fa:	3b 45 0c             	cmp    0xc(%ebp),%eax
    return oldsz;
801071fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(newsz < oldsz)
80107200:	0f 82 9a 00 00 00    	jb     801072a0 <allocuvm+0xc0>
  a = PGROUNDUP(oldsz);
80107206:	8d b0 ff 0f 00 00    	lea    0xfff(%eax),%esi
8010720c:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
  for(; a < newsz; a += PGSIZE){
80107212:	39 75 10             	cmp    %esi,0x10(%ebp)
80107215:	77 44                	ja     8010725b <allocuvm+0x7b>
80107217:	e9 87 00 00 00       	jmp    801072a3 <allocuvm+0xc3>
8010721c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    memset(mem, 0, PGSIZE);
80107220:	83 ec 04             	sub    $0x4,%esp
80107223:	68 00 10 00 00       	push   $0x1000
80107228:	6a 00                	push   $0x0
8010722a:	50                   	push   %eax
8010722b:	e8 90 d7 ff ff       	call   801049c0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80107230:	58                   	pop    %eax
80107231:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80107237:	5a                   	pop    %edx
80107238:	6a 06                	push   $0x6
8010723a:	b9 00 10 00 00       	mov    $0x1000,%ecx
8010723f:	89 f2                	mov    %esi,%edx
80107241:	50                   	push   %eax
80107242:	89 f8                	mov    %edi,%eax
80107244:	e8 87 fb ff ff       	call   80106dd0 <mappages>
80107249:	83 c4 10             	add    $0x10,%esp
8010724c:	85 c0                	test   %eax,%eax
8010724e:	78 78                	js     801072c8 <allocuvm+0xe8>
  for(; a < newsz; a += PGSIZE){
80107250:	81 c6 00 10 00 00    	add    $0x1000,%esi
80107256:	39 75 10             	cmp    %esi,0x10(%ebp)
80107259:	76 48                	jbe    801072a3 <allocuvm+0xc3>
    mem = kalloc();
8010725b:	e8 d0 b4 ff ff       	call   80102730 <kalloc>
80107260:	89 c3                	mov    %eax,%ebx
    if(mem == 0){
80107262:	85 c0                	test   %eax,%eax
80107264:	75 ba                	jne    80107220 <allocuvm+0x40>
      cprintf("allocuvm out of memory\n");
80107266:	83 ec 0c             	sub    $0xc,%esp
80107269:	68 bd 80 10 80       	push   $0x801080bd
8010726e:	e8 2d 94 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
80107273:	8b 45 0c             	mov    0xc(%ebp),%eax
80107276:	83 c4 10             	add    $0x10,%esp
80107279:	39 45 10             	cmp    %eax,0x10(%ebp)
8010727c:	74 32                	je     801072b0 <allocuvm+0xd0>
8010727e:	8b 55 10             	mov    0x10(%ebp),%edx
80107281:	89 c1                	mov    %eax,%ecx
80107283:	89 f8                	mov    %edi,%eax
80107285:	e8 96 fa ff ff       	call   80106d20 <deallocuvm.part.0>
      return 0;
8010728a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
80107291:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107294:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107297:	5b                   	pop    %ebx
80107298:	5e                   	pop    %esi
80107299:	5f                   	pop    %edi
8010729a:	5d                   	pop    %ebp
8010729b:	c3                   	ret    
8010729c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return oldsz;
801072a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
}
801072a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072a6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072a9:	5b                   	pop    %ebx
801072aa:	5e                   	pop    %esi
801072ab:	5f                   	pop    %edi
801072ac:	5d                   	pop    %ebp
801072ad:	c3                   	ret    
801072ae:	66 90                	xchg   %ax,%ax
    return 0;
801072b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
}
801072b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801072ba:	8d 65 f4             	lea    -0xc(%ebp),%esp
801072bd:	5b                   	pop    %ebx
801072be:	5e                   	pop    %esi
801072bf:	5f                   	pop    %edi
801072c0:	5d                   	pop    %ebp
801072c1:	c3                   	ret    
801072c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      cprintf("allocuvm out of memory (2)\n");
801072c8:	83 ec 0c             	sub    $0xc,%esp
801072cb:	68 d5 80 10 80       	push   $0x801080d5
801072d0:	e8 cb 93 ff ff       	call   801006a0 <cprintf>
  if(newsz >= oldsz)
801072d5:	8b 45 0c             	mov    0xc(%ebp),%eax
801072d8:	83 c4 10             	add    $0x10,%esp
801072db:	39 45 10             	cmp    %eax,0x10(%ebp)
801072de:	74 0c                	je     801072ec <allocuvm+0x10c>
801072e0:	8b 55 10             	mov    0x10(%ebp),%edx
801072e3:	89 c1                	mov    %eax,%ecx
801072e5:	89 f8                	mov    %edi,%eax
801072e7:	e8 34 fa ff ff       	call   80106d20 <deallocuvm.part.0>
      kfree(mem);
801072ec:	83 ec 0c             	sub    $0xc,%esp
801072ef:	53                   	push   %ebx
801072f0:	e8 7b b2 ff ff       	call   80102570 <kfree>
      return 0;
801072f5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
801072fc:	83 c4 10             	add    $0x10,%esp
}
801072ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80107302:	8d 65 f4             	lea    -0xc(%ebp),%esp
80107305:	5b                   	pop    %ebx
80107306:	5e                   	pop    %esi
80107307:	5f                   	pop    %edi
80107308:	5d                   	pop    %ebp
80107309:	c3                   	ret    
8010730a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107310 <deallocuvm>:
{
80107310:	55                   	push   %ebp
80107311:	89 e5                	mov    %esp,%ebp
80107313:	8b 55 0c             	mov    0xc(%ebp),%edx
80107316:	8b 4d 10             	mov    0x10(%ebp),%ecx
80107319:	8b 45 08             	mov    0x8(%ebp),%eax
  if(newsz >= oldsz)
8010731c:	39 d1                	cmp    %edx,%ecx
8010731e:	73 10                	jae    80107330 <deallocuvm+0x20>
}
80107320:	5d                   	pop    %ebp
80107321:	e9 fa f9 ff ff       	jmp    80106d20 <deallocuvm.part.0>
80107326:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010732d:	8d 76 00             	lea    0x0(%esi),%esi
80107330:	89 d0                	mov    %edx,%eax
80107332:	5d                   	pop    %ebp
80107333:	c3                   	ret    
80107334:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010733b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010733f:	90                   	nop

80107340 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80107340:	55                   	push   %ebp
80107341:	89 e5                	mov    %esp,%ebp
80107343:	57                   	push   %edi
80107344:	56                   	push   %esi
80107345:	53                   	push   %ebx
80107346:	83 ec 0c             	sub    $0xc,%esp
80107349:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
8010734c:	85 f6                	test   %esi,%esi
8010734e:	74 59                	je     801073a9 <freevm+0x69>
  if(newsz >= oldsz)
80107350:	31 c9                	xor    %ecx,%ecx
80107352:	ba 00 00 00 80       	mov    $0x80000000,%edx
80107357:	89 f0                	mov    %esi,%eax
80107359:	89 f3                	mov    %esi,%ebx
8010735b:	e8 c0 f9 ff ff       	call   80106d20 <deallocuvm.part.0>
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80107360:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80107366:	eb 0f                	jmp    80107377 <freevm+0x37>
80107368:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010736f:	90                   	nop
80107370:	83 c3 04             	add    $0x4,%ebx
80107373:	39 df                	cmp    %ebx,%edi
80107375:	74 23                	je     8010739a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80107377:	8b 03                	mov    (%ebx),%eax
80107379:	a8 01                	test   $0x1,%al
8010737b:	74 f3                	je     80107370 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
8010737d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
      kfree(v);
80107382:	83 ec 0c             	sub    $0xc,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107385:	83 c3 04             	add    $0x4,%ebx
      char * v = P2V(PTE_ADDR(pgdir[i]));
80107388:	05 00 00 00 80       	add    $0x80000000,%eax
      kfree(v);
8010738d:	50                   	push   %eax
8010738e:	e8 dd b1 ff ff       	call   80102570 <kfree>
80107393:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < NPDENTRIES; i++){
80107396:	39 df                	cmp    %ebx,%edi
80107398:	75 dd                	jne    80107377 <freevm+0x37>
    }
  }
  kfree((char*)pgdir);
8010739a:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010739d:	8d 65 f4             	lea    -0xc(%ebp),%esp
801073a0:	5b                   	pop    %ebx
801073a1:	5e                   	pop    %esi
801073a2:	5f                   	pop    %edi
801073a3:	5d                   	pop    %ebp
  kfree((char*)pgdir);
801073a4:	e9 c7 b1 ff ff       	jmp    80102570 <kfree>
    panic("freevm: no pgdir");
801073a9:	83 ec 0c             	sub    $0xc,%esp
801073ac:	68 f1 80 10 80       	push   $0x801080f1
801073b1:	e8 ca 8f ff ff       	call   80100380 <panic>
801073b6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801073bd:	8d 76 00             	lea    0x0(%esi),%esi

801073c0 <setupkvm>:
{
801073c0:	55                   	push   %ebp
801073c1:	89 e5                	mov    %esp,%ebp
801073c3:	56                   	push   %esi
801073c4:	53                   	push   %ebx
  if((pgdir = (pde_t*)kalloc()) == 0)
801073c5:	e8 66 b3 ff ff       	call   80102730 <kalloc>
801073ca:	89 c6                	mov    %eax,%esi
801073cc:	85 c0                	test   %eax,%eax
801073ce:	74 42                	je     80107412 <setupkvm+0x52>
  memset(pgdir, 0, PGSIZE);
801073d0:	83 ec 04             	sub    $0x4,%esp
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
801073d3:	bb 20 b4 10 80       	mov    $0x8010b420,%ebx
  memset(pgdir, 0, PGSIZE);
801073d8:	68 00 10 00 00       	push   $0x1000
801073dd:	6a 00                	push   $0x0
801073df:	50                   	push   %eax
801073e0:	e8 db d5 ff ff       	call   801049c0 <memset>
801073e5:	83 c4 10             	add    $0x10,%esp
                (uint)k->phys_start, k->perm) < 0) {
801073e8:	8b 43 04             	mov    0x4(%ebx),%eax
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
801073eb:	83 ec 08             	sub    $0x8,%esp
801073ee:	8b 4b 08             	mov    0x8(%ebx),%ecx
801073f1:	ff 73 0c             	push   0xc(%ebx)
801073f4:	8b 13                	mov    (%ebx),%edx
801073f6:	50                   	push   %eax
801073f7:	29 c1                	sub    %eax,%ecx
801073f9:	89 f0                	mov    %esi,%eax
801073fb:	e8 d0 f9 ff ff       	call   80106dd0 <mappages>
80107400:	83 c4 10             	add    $0x10,%esp
80107403:	85 c0                	test   %eax,%eax
80107405:	78 19                	js     80107420 <setupkvm+0x60>
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80107407:	83 c3 10             	add    $0x10,%ebx
8010740a:	81 fb 60 b4 10 80    	cmp    $0x8010b460,%ebx
80107410:	75 d6                	jne    801073e8 <setupkvm+0x28>
}
80107412:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107415:	89 f0                	mov    %esi,%eax
80107417:	5b                   	pop    %ebx
80107418:	5e                   	pop    %esi
80107419:	5d                   	pop    %ebp
8010741a:	c3                   	ret    
8010741b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010741f:	90                   	nop
      freevm(pgdir);
80107420:	83 ec 0c             	sub    $0xc,%esp
80107423:	56                   	push   %esi
      return 0;
80107424:	31 f6                	xor    %esi,%esi
      freevm(pgdir);
80107426:	e8 15 ff ff ff       	call   80107340 <freevm>
      return 0;
8010742b:	83 c4 10             	add    $0x10,%esp
}
8010742e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80107431:	89 f0                	mov    %esi,%eax
80107433:	5b                   	pop    %ebx
80107434:	5e                   	pop    %esi
80107435:	5d                   	pop    %ebp
80107436:	c3                   	ret    
80107437:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010743e:	66 90                	xchg   %ax,%ax

80107440 <kvmalloc>:
{
80107440:	55                   	push   %ebp
80107441:	89 e5                	mov    %esp,%ebp
80107443:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80107446:	e8 75 ff ff ff       	call   801073c0 <setupkvm>
8010744b:	a3 04 df 11 80       	mov    %eax,0x8011df04
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80107450:	05 00 00 00 80       	add    $0x80000000,%eax
80107455:	0f 22 d8             	mov    %eax,%cr3
}
80107458:	c9                   	leave  
80107459:	c3                   	ret    
8010745a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80107460 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80107460:	55                   	push   %ebp
80107461:	89 e5                	mov    %esp,%ebp
80107463:	83 ec 08             	sub    $0x8,%esp
80107466:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
80107469:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
8010746c:	89 c1                	mov    %eax,%ecx
8010746e:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
80107471:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
80107474:	f6 c2 01             	test   $0x1,%dl
80107477:	75 17                	jne    80107490 <clearpteu+0x30>
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80107479:	83 ec 0c             	sub    $0xc,%esp
8010747c:	68 02 81 10 80       	push   $0x80108102
80107481:	e8 fa 8e ff ff       	call   80100380 <panic>
80107486:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
8010748d:	8d 76 00             	lea    0x0(%esi),%esi
  return &pgtab[PTX(va)];
80107490:	c1 e8 0a             	shr    $0xa,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107493:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  return &pgtab[PTX(va)];
80107499:	25 fc 0f 00 00       	and    $0xffc,%eax
8010749e:	8d 84 02 00 00 00 80 	lea    -0x80000000(%edx,%eax,1),%eax
  if(pte == 0)
801074a5:	85 c0                	test   %eax,%eax
801074a7:	74 d0                	je     80107479 <clearpteu+0x19>
  *pte &= ~PTE_U;
801074a9:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
801074ac:	c9                   	leave  
801074ad:	c3                   	ret    
801074ae:	66 90                	xchg   %ax,%ax

801074b0 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
801074b0:	55                   	push   %ebp
801074b1:	89 e5                	mov    %esp,%ebp
801074b3:	57                   	push   %edi
801074b4:	56                   	push   %esi
801074b5:	53                   	push   %ebx
801074b6:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
801074b9:	e8 02 ff ff ff       	call   801073c0 <setupkvm>
801074be:	89 45 e0             	mov    %eax,-0x20(%ebp)
801074c1:	85 c0                	test   %eax,%eax
801074c3:	0f 84 bd 00 00 00    	je     80107586 <copyuvm+0xd6>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
801074c9:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801074cc:	85 c9                	test   %ecx,%ecx
801074ce:	0f 84 b2 00 00 00    	je     80107586 <copyuvm+0xd6>
801074d4:	31 f6                	xor    %esi,%esi
801074d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801074dd:	8d 76 00             	lea    0x0(%esi),%esi
  if(*pde & PTE_P){
801074e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  pde = &pgdir[PDX(va)];
801074e3:	89 f0                	mov    %esi,%eax
801074e5:	c1 e8 16             	shr    $0x16,%eax
  if(*pde & PTE_P){
801074e8:	8b 04 81             	mov    (%ecx,%eax,4),%eax
801074eb:	a8 01                	test   $0x1,%al
801074ed:	75 11                	jne    80107500 <copyuvm+0x50>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
801074ef:	83 ec 0c             	sub    $0xc,%esp
801074f2:	68 0c 81 10 80       	push   $0x8010810c
801074f7:	e8 84 8e ff ff       	call   80100380 <panic>
801074fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return &pgtab[PTX(va)];
80107500:	89 f2                	mov    %esi,%edx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80107502:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  return &pgtab[PTX(va)];
80107507:	c1 ea 0a             	shr    $0xa,%edx
8010750a:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80107510:	8d 84 10 00 00 00 80 	lea    -0x80000000(%eax,%edx,1),%eax
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80107517:	85 c0                	test   %eax,%eax
80107519:	74 d4                	je     801074ef <copyuvm+0x3f>
    if(!(*pte & PTE_P))
8010751b:	8b 00                	mov    (%eax),%eax
8010751d:	a8 01                	test   $0x1,%al
8010751f:	0f 84 9f 00 00 00    	je     801075c4 <copyuvm+0x114>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80107525:	89 c7                	mov    %eax,%edi
    flags = PTE_FLAGS(*pte);
80107527:	25 ff 0f 00 00       	and    $0xfff,%eax
8010752c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    pa = PTE_ADDR(*pte);
8010752f:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
    if((mem = kalloc()) == 0)
80107535:	e8 f6 b1 ff ff       	call   80102730 <kalloc>
8010753a:	89 c3                	mov    %eax,%ebx
8010753c:	85 c0                	test   %eax,%eax
8010753e:	74 64                	je     801075a4 <copyuvm+0xf4>
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80107540:	83 ec 04             	sub    $0x4,%esp
80107543:	81 c7 00 00 00 80    	add    $0x80000000,%edi
80107549:	68 00 10 00 00       	push   $0x1000
8010754e:	57                   	push   %edi
8010754f:	50                   	push   %eax
80107550:	e8 0b d5 ff ff       	call   80104a60 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80107555:	58                   	pop    %eax
80107556:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
8010755c:	5a                   	pop    %edx
8010755d:	ff 75 e4             	push   -0x1c(%ebp)
80107560:	b9 00 10 00 00       	mov    $0x1000,%ecx
80107565:	89 f2                	mov    %esi,%edx
80107567:	50                   	push   %eax
80107568:	8b 45 e0             	mov    -0x20(%ebp),%eax
8010756b:	e8 60 f8 ff ff       	call   80106dd0 <mappages>
80107570:	83 c4 10             	add    $0x10,%esp
80107573:	85 c0                	test   %eax,%eax
80107575:	78 21                	js     80107598 <copyuvm+0xe8>
  for(i = 0; i < sz; i += PGSIZE){
80107577:	81 c6 00 10 00 00    	add    $0x1000,%esi
8010757d:	39 75 0c             	cmp    %esi,0xc(%ebp)
80107580:	0f 87 5a ff ff ff    	ja     801074e0 <copyuvm+0x30>
  return d;

bad:
  freevm(d);
  return 0;
}
80107586:	8b 45 e0             	mov    -0x20(%ebp),%eax
80107589:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010758c:	5b                   	pop    %ebx
8010758d:	5e                   	pop    %esi
8010758e:	5f                   	pop    %edi
8010758f:	5d                   	pop    %ebp
80107590:	c3                   	ret    
80107591:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      kfree(mem);
80107598:	83 ec 0c             	sub    $0xc,%esp
8010759b:	53                   	push   %ebx
8010759c:	e8 cf af ff ff       	call   80102570 <kfree>
      goto bad;
801075a1:	83 c4 10             	add    $0x10,%esp
  freevm(d);
801075a4:	83 ec 0c             	sub    $0xc,%esp
801075a7:	ff 75 e0             	push   -0x20(%ebp)
801075aa:	e8 91 fd ff ff       	call   80107340 <freevm>
  return 0;
801075af:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801075b6:	83 c4 10             	add    $0x10,%esp
}
801075b9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801075bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801075bf:	5b                   	pop    %ebx
801075c0:	5e                   	pop    %esi
801075c1:	5f                   	pop    %edi
801075c2:	5d                   	pop    %ebp
801075c3:	c3                   	ret    
      panic("copyuvm: page not present");
801075c4:	83 ec 0c             	sub    $0xc,%esp
801075c7:	68 26 81 10 80       	push   $0x80108126
801075cc:	e8 af 8d ff ff       	call   80100380 <panic>
801075d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075d8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801075df:	90                   	nop

801075e0 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
801075e0:	55                   	push   %ebp
801075e1:	89 e5                	mov    %esp,%ebp
801075e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  if(*pde & PTE_P){
801075e6:	8b 55 08             	mov    0x8(%ebp),%edx
  pde = &pgdir[PDX(va)];
801075e9:	89 c1                	mov    %eax,%ecx
801075eb:	c1 e9 16             	shr    $0x16,%ecx
  if(*pde & PTE_P){
801075ee:	8b 14 8a             	mov    (%edx,%ecx,4),%edx
801075f1:	f6 c2 01             	test   $0x1,%dl
801075f4:	0f 84 00 01 00 00    	je     801076fa <uva2ka.cold>
  return &pgtab[PTX(va)];
801075fa:	c1 e8 0c             	shr    $0xc,%eax
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801075fd:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
}
80107603:	5d                   	pop    %ebp
  return &pgtab[PTX(va)];
80107604:	25 ff 03 00 00       	and    $0x3ff,%eax
  if((*pte & PTE_P) == 0)
80107609:	8b 84 82 00 00 00 80 	mov    -0x80000000(%edx,%eax,4),%eax
  if((*pte & PTE_U) == 0)
80107610:	89 c2                	mov    %eax,%edx
  return (char*)P2V(PTE_ADDR(*pte));
80107612:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((*pte & PTE_U) == 0)
80107617:	83 e2 05             	and    $0x5,%edx
  return (char*)P2V(PTE_ADDR(*pte));
8010761a:	05 00 00 00 80       	add    $0x80000000,%eax
8010761f:	83 fa 05             	cmp    $0x5,%edx
80107622:	ba 00 00 00 00       	mov    $0x0,%edx
80107627:	0f 45 c2             	cmovne %edx,%eax
}
8010762a:	c3                   	ret    
8010762b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010762f:	90                   	nop

80107630 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80107630:	55                   	push   %ebp
80107631:	89 e5                	mov    %esp,%ebp
80107633:	57                   	push   %edi
80107634:	56                   	push   %esi
80107635:	53                   	push   %ebx
80107636:	83 ec 0c             	sub    $0xc,%esp
80107639:	8b 75 14             	mov    0x14(%ebp),%esi
8010763c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010763f:	8b 55 10             	mov    0x10(%ebp),%edx
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107642:	85 f6                	test   %esi,%esi
80107644:	75 51                	jne    80107697 <copyout+0x67>
80107646:	e9 a5 00 00 00       	jmp    801076f0 <copyout+0xc0>
8010764b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
8010764f:	90                   	nop
  return (char*)P2V(PTE_ADDR(*pte));
80107650:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
80107656:	8d 8b 00 00 00 80    	lea    -0x80000000(%ebx),%ecx
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
8010765c:	81 fb 00 00 00 80    	cmp    $0x80000000,%ebx
80107662:	74 75                	je     801076d9 <copyout+0xa9>
      return -1;
    n = PGSIZE - (va - va0);
80107664:	89 fb                	mov    %edi,%ebx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80107666:	89 55 10             	mov    %edx,0x10(%ebp)
    n = PGSIZE - (va - va0);
80107669:	29 c3                	sub    %eax,%ebx
8010766b:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80107671:	39 f3                	cmp    %esi,%ebx
80107673:	0f 47 de             	cmova  %esi,%ebx
    memmove(pa0 + (va - va0), buf, n);
80107676:	29 f8                	sub    %edi,%eax
80107678:	83 ec 04             	sub    $0x4,%esp
8010767b:	01 c1                	add    %eax,%ecx
8010767d:	53                   	push   %ebx
8010767e:	52                   	push   %edx
8010767f:	51                   	push   %ecx
80107680:	e8 db d3 ff ff       	call   80104a60 <memmove>
    len -= n;
    buf += n;
80107685:	8b 55 10             	mov    0x10(%ebp),%edx
    va = va0 + PGSIZE;
80107688:	8d 87 00 10 00 00    	lea    0x1000(%edi),%eax
  while(len > 0){
8010768e:	83 c4 10             	add    $0x10,%esp
    buf += n;
80107691:	01 da                	add    %ebx,%edx
  while(len > 0){
80107693:	29 de                	sub    %ebx,%esi
80107695:	74 59                	je     801076f0 <copyout+0xc0>
  if(*pde & PTE_P){
80107697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  pde = &pgdir[PDX(va)];
8010769a:	89 c1                	mov    %eax,%ecx
    va0 = (uint)PGROUNDDOWN(va);
8010769c:	89 c7                	mov    %eax,%edi
  pde = &pgdir[PDX(va)];
8010769e:	c1 e9 16             	shr    $0x16,%ecx
    va0 = (uint)PGROUNDDOWN(va);
801076a1:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
  if(*pde & PTE_P){
801076a7:	8b 0c 8b             	mov    (%ebx,%ecx,4),%ecx
801076aa:	f6 c1 01             	test   $0x1,%cl
801076ad:	0f 84 4e 00 00 00    	je     80107701 <copyout.cold>
  return &pgtab[PTX(va)];
801076b3:	89 fb                	mov    %edi,%ebx
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801076b5:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  return &pgtab[PTX(va)];
801076bb:	c1 eb 0c             	shr    $0xc,%ebx
801076be:	81 e3 ff 03 00 00    	and    $0x3ff,%ebx
  if((*pte & PTE_P) == 0)
801076c4:	8b 9c 99 00 00 00 80 	mov    -0x80000000(%ecx,%ebx,4),%ebx
  if((*pte & PTE_U) == 0)
801076cb:	89 d9                	mov    %ebx,%ecx
801076cd:	83 e1 05             	and    $0x5,%ecx
801076d0:	83 f9 05             	cmp    $0x5,%ecx
801076d3:	0f 84 77 ff ff ff    	je     80107650 <copyout+0x20>
  }
  return 0;
}
801076d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return -1;
801076dc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801076e1:	5b                   	pop    %ebx
801076e2:	5e                   	pop    %esi
801076e3:	5f                   	pop    %edi
801076e4:	5d                   	pop    %ebp
801076e5:	c3                   	ret    
801076e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801076ed:	8d 76 00             	lea    0x0(%esi),%esi
801076f0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;
801076f3:	31 c0                	xor    %eax,%eax
}
801076f5:	5b                   	pop    %ebx
801076f6:	5e                   	pop    %esi
801076f7:	5f                   	pop    %edi
801076f8:	5d                   	pop    %ebp
801076f9:	c3                   	ret    

801076fa <uva2ka.cold>:
  if((*pte & PTE_P) == 0)
801076fa:	a1 00 00 00 00       	mov    0x0,%eax
801076ff:	0f 0b                	ud2    

80107701 <copyout.cold>:
80107701:	a1 00 00 00 00       	mov    0x0,%eax
80107706:	0f 0b                	ud2    
