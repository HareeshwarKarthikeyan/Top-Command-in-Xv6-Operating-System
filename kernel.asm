
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4 0f                	in     $0xf,%al

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
8010002d:	b8 00 2e 10 80       	mov    $0x80102e00,%eax
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
80100044:	bb f4 b5 10 80       	mov    $0x8010b5f4,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 14             	sub    $0x14,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	c7 44 24 04 60 70 10 	movl   $0x80107060,0x4(%esp)
80100053:	80 
80100054:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
8010005b:	e8 60 40 00 00       	call   801040c0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
80100060:	ba bc fc 10 80       	mov    $0x8010fcbc,%edx

  initlock(&bcache.lock, "bcache");

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
80100065:	c7 05 0c fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd0c
8010006c:	fc 10 80 
  bcache.head.next = &bcache.head;
8010006f:	c7 05 10 fd 10 80 bc 	movl   $0x8010fcbc,0x8010fd10
80100076:	fc 10 80 
80100079:	eb 09                	jmp    80100084 <binit+0x44>
8010007b:	90                   	nop
8010007c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 da                	mov    %ebx,%edx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100082:	89 c3                	mov    %eax,%ebx
80100084:	8d 43 0c             	lea    0xc(%ebx),%eax
    b->next = bcache.head.next;
80100087:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008a:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100091:	89 04 24             	mov    %eax,(%esp)
80100094:	c7 44 24 04 67 70 10 	movl   $0x80107067,0x4(%esp)
8010009b:	80 
8010009c:	e8 ef 3e 00 00       	call   80103f90 <initsleeplock>
    bcache.head.next->prev = b;
801000a1:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
801000a6:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a9:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
801000af:	3d bc fc 10 80       	cmp    $0x8010fcbc,%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b4:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000ba:	75 c4                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bc:	83 c4 14             	add    $0x14,%esp
801000bf:	5b                   	pop    %ebx
801000c0:	5d                   	pop    %ebp
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
801000d6:	83 ec 1c             	sub    $0x1c,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000dc:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000e3:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000e6:	e8 45 41 00 00       	call   80104230 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000eb:	8b 1d 10 fd 10 80    	mov    0x8010fd10,%ebx
801000f1:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
801000f7:	75 12                	jne    8010010b <bread+0x3b>
801000f9:	eb 25                	jmp    80100120 <bread+0x50>
801000fb:	90                   	nop
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
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
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 0c fd 10 80    	mov    0x8010fd0c,%ebx
80100126:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 58                	jmp    80100188 <bread+0xb8>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb bc fc 10 80    	cmp    $0x8010fcbc,%ebx
80100139:	74 4d                	je     80100188 <bread+0xb8>
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
8010015a:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100161:	e8 3a 41 00 00       	call   801042a0 <release>
      acquiresleep(&b->lock);
80100166:	8d 43 0c             	lea    0xc(%ebx),%eax
80100169:	89 04 24             	mov    %eax,(%esp)
8010016c:	e8 5f 3e 00 00       	call   80103fd0 <acquiresleep>
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100171:	f6 03 02             	testb  $0x2,(%ebx)
80100174:	75 08                	jne    8010017e <bread+0xae>
    iderw(b);
80100176:	89 1c 24             	mov    %ebx,(%esp)
80100179:	e8 b2 1f 00 00       	call   80102130 <iderw>
  }
  return b;
}
8010017e:	83 c4 1c             	add    $0x1c,%esp
80100181:	89 d8                	mov    %ebx,%eax
80100183:	5b                   	pop    %ebx
80100184:	5e                   	pop    %esi
80100185:	5f                   	pop    %edi
80100186:	5d                   	pop    %ebp
80100187:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100188:	c7 04 24 6e 70 10 80 	movl   $0x8010706e,(%esp)
8010018f:	e8 cc 01 00 00       	call   80100360 <panic>
80100194:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010019a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 14             	sub    $0x14,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	89 04 24             	mov    %eax,(%esp)
801001b0:	e8 bb 3e 00 00       	call   80104070 <holdingsleep>
801001b5:	85 c0                	test   %eax,%eax
801001b7:	74 10                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001b9:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bc:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001bf:	83 c4 14             	add    $0x14,%esp
801001c2:	5b                   	pop    %ebx
801001c3:	5d                   	pop    %ebp
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 67 1f 00 00       	jmp    80102130 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	c7 04 24 7f 70 10 80 	movl   $0x8010707f,(%esp)
801001d0:	e8 8b 01 00 00       	call   80100360 <panic>
801001d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
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
801001e5:	83 ec 10             	sub    $0x10,%esp
801001e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	89 34 24             	mov    %esi,(%esp)
801001f1:	e8 7a 3e 00 00       	call   80104070 <holdingsleep>
801001f6:	85 c0                	test   %eax,%eax
801001f8:	74 5b                	je     80100255 <brelse+0x75>
    panic("brelse");

  releasesleep(&b->lock);
801001fa:	89 34 24             	mov    %esi,(%esp)
801001fd:	e8 2e 3e 00 00       	call   80104030 <releasesleep>

  acquire(&bcache.lock);
80100202:	c7 04 24 c0 b5 10 80 	movl   $0x8010b5c0,(%esp)
80100209:	e8 22 40 00 00       	call   80104230 <acquire>
  b->refcnt--;
  if (b->refcnt == 0) {
8010020e:	83 6b 4c 01          	subl   $0x1,0x4c(%ebx)
80100212:	75 2f                	jne    80100243 <brelse+0x63>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100214:	8b 43 54             	mov    0x54(%ebx),%eax
80100217:	8b 53 50             	mov    0x50(%ebx),%edx
8010021a:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
8010021d:	8b 43 50             	mov    0x50(%ebx),%eax
80100220:	8b 53 54             	mov    0x54(%ebx),%edx
80100223:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100226:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
    b->prev = &bcache.head;
8010022b:	c7 43 50 bc fc 10 80 	movl   $0x8010fcbc,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
80100232:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100235:	a1 10 fd 10 80       	mov    0x8010fd10,%eax
8010023a:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
8010023d:	89 1d 10 fd 10 80    	mov    %ebx,0x8010fd10
  }
  
  release(&bcache.lock);
80100243:	c7 45 08 c0 b5 10 80 	movl   $0x8010b5c0,0x8(%ebp)
}
8010024a:	83 c4 10             	add    $0x10,%esp
8010024d:	5b                   	pop    %ebx
8010024e:	5e                   	pop    %esi
8010024f:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
80100250:	e9 4b 40 00 00       	jmp    801042a0 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100255:	c7 04 24 86 70 10 80 	movl   $0x80107086,(%esp)
8010025c:	e8 ff 00 00 00       	call   80100360 <panic>
80100261:	66 90                	xchg   %ax,%ax
80100263:	66 90                	xchg   %ax,%ax
80100265:	66 90                	xchg   %ax,%ax
80100267:	66 90                	xchg   %ax,%ax
80100269:	66 90                	xchg   %ax,%ax
8010026b:	66 90                	xchg   %ax,%ax
8010026d:	66 90                	xchg   %ax,%ax
8010026f:	90                   	nop

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
80100276:	83 ec 1c             	sub    $0x1c,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	89 3c 24             	mov    %edi,(%esp)
80100282:	e8 19 15 00 00       	call   801017a0 <iunlock>
  target = n;
  acquire(&cons.lock);
80100287:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010028e:	e8 9d 3f 00 00       	call   80104230 <acquire>
  while(n > 0){
80100293:	8b 55 10             	mov    0x10(%ebp),%edx
80100296:	85 d2                	test   %edx,%edx
80100298:	0f 8e bc 00 00 00    	jle    8010035a <consoleread+0xea>
8010029e:	8b 5d 10             	mov    0x10(%ebp),%ebx
801002a1:	eb 25                	jmp    801002c8 <consoleread+0x58>
801002a3:	90                   	nop
801002a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(input.r == input.w){
      if(myproc()->killed){
801002a8:	e8 03 34 00 00       	call   801036b0 <myproc>
801002ad:	8b 40 24             	mov    0x24(%eax),%eax
801002b0:	85 c0                	test   %eax,%eax
801002b2:	75 74                	jne    80100328 <consoleread+0xb8>
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b4:	c7 44 24 04 20 a5 10 	movl   $0x8010a520,0x4(%esp)
801002bb:	80 
801002bc:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
801002c3:	e8 68 39 00 00       	call   80103c30 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c8:	a1 a0 ff 10 80       	mov    0x8010ffa0,%eax
801002cd:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801002d3:	74 d3                	je     801002a8 <consoleread+0x38>
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
801002d5:	8d 50 01             	lea    0x1(%eax),%edx
801002d8:	89 15 a0 ff 10 80    	mov    %edx,0x8010ffa0
801002de:	89 c2                	mov    %eax,%edx
801002e0:	83 e2 7f             	and    $0x7f,%edx
801002e3:	0f b6 8a 20 ff 10 80 	movzbl -0x7fef00e0(%edx),%ecx
801002ea:	0f be d1             	movsbl %cl,%edx
    if(c == C('D')){  // EOF
801002ed:	83 fa 04             	cmp    $0x4,%edx
801002f0:	74 57                	je     80100349 <consoleread+0xd9>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002f2:	83 c6 01             	add    $0x1,%esi
    --n;
801002f5:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
801002f8:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
801002fb:	88 4e ff             	mov    %cl,-0x1(%esi)
    --n;
    if(c == '\n')
801002fe:	74 53                	je     80100353 <consoleread+0xe3>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100300:	85 db                	test   %ebx,%ebx
80100302:	75 c4                	jne    801002c8 <consoleread+0x58>
80100304:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
80100307:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010030e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100311:	e8 8a 3f 00 00       	call   801042a0 <release>
  ilock(ip);
80100316:	89 3c 24             	mov    %edi,(%esp)
80100319:	e8 a2 13 00 00       	call   801016c0 <ilock>
8010031e:	8b 45 e4             	mov    -0x1c(%ebp),%eax

  return target - n;
80100321:	eb 1e                	jmp    80100341 <consoleread+0xd1>
80100323:	90                   	nop
80100324:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
      if(myproc()->killed){
        release(&cons.lock);
80100328:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010032f:	e8 6c 3f 00 00       	call   801042a0 <release>
        ilock(ip);
80100334:	89 3c 24             	mov    %edi,(%esp)
80100337:	e8 84 13 00 00       	call   801016c0 <ilock>
        return -1;
8010033c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
80100341:	83 c4 1c             	add    $0x1c,%esp
80100344:	5b                   	pop    %ebx
80100345:	5e                   	pop    %esi
80100346:	5f                   	pop    %edi
80100347:	5d                   	pop    %ebp
80100348:	c3                   	ret    
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
80100349:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010034c:	76 05                	jbe    80100353 <consoleread+0xe3>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
8010034e:	a3 a0 ff 10 80       	mov    %eax,0x8010ffa0
80100353:	8b 45 10             	mov    0x10(%ebp),%eax
80100356:	29 d8                	sub    %ebx,%eax
80100358:	eb ad                	jmp    80100307 <consoleread+0x97>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
8010035a:	31 c0                	xor    %eax,%eax
8010035c:	eb a9                	jmp    80100307 <consoleread+0x97>
8010035e:	66 90                	xchg   %ax,%ax

80100360 <panic>:



void
panic(char *s)
{
80100360:	55                   	push   %ebp
80100361:	89 e5                	mov    %esp,%ebp
80100363:	56                   	push   %esi
80100364:	53                   	push   %ebx
80100365:	83 ec 40             	sub    $0x40,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100368:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100369:	c7 05 54 a5 10 80 00 	movl   $0x0,0x8010a554
80100370:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100373:	8d 5d d0             	lea    -0x30(%ebp),%ebx
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100376:	e8 f5 23 00 00       	call   80102770 <lapicid>
8010037b:	8d 75 f8             	lea    -0x8(%ebp),%esi
8010037e:	c7 04 24 8d 70 10 80 	movl   $0x8010708d,(%esp)
80100385:	89 44 24 04          	mov    %eax,0x4(%esp)
80100389:	e8 c2 02 00 00       	call   80100650 <cprintf>
  cprintf(s);
8010038e:	8b 45 08             	mov    0x8(%ebp),%eax
80100391:	89 04 24             	mov    %eax,(%esp)
80100394:	e8 b7 02 00 00       	call   80100650 <cprintf>
  cprintf("\n");
80100399:	c7 04 24 5b 7b 10 80 	movl   $0x80107b5b,(%esp)
801003a0:	e8 ab 02 00 00       	call   80100650 <cprintf>
  getcallerpcs(&s, pcs);
801003a5:	8d 45 08             	lea    0x8(%ebp),%eax
801003a8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801003ac:	89 04 24             	mov    %eax,(%esp)
801003af:	e8 2c 3d 00 00       	call   801040e0 <getcallerpcs>
801003b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003b8:	8b 03                	mov    (%ebx),%eax
801003ba:	83 c3 04             	add    $0x4,%ebx
801003bd:	c7 04 24 a1 70 10 80 	movl   $0x801070a1,(%esp)
801003c4:	89 44 24 04          	mov    %eax,0x4(%esp)
801003c8:	e8 83 02 00 00       	call   80100650 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003cd:	39 f3                	cmp    %esi,%ebx
801003cf:	75 e7                	jne    801003b8 <panic+0x58>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d1:	c7 05 58 a5 10 80 01 	movl   $0x1,0x8010a558
801003d8:	00 00 00 
801003db:	eb fe                	jmp    801003db <panic+0x7b>
801003dd:	8d 76 00             	lea    0x0(%esi),%esi

801003e0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003e0:	8b 15 58 a5 10 80    	mov    0x8010a558,%edx
801003e6:	85 d2                	test   %edx,%edx
801003e8:	74 06                	je     801003f0 <consputc+0x10>
801003ea:	fa                   	cli    
801003eb:	eb fe                	jmp    801003eb <consputc+0xb>
801003ed:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
801003f0:	55                   	push   %ebp
801003f1:	89 e5                	mov    %esp,%ebp
801003f3:	57                   	push   %edi
801003f4:	56                   	push   %esi
801003f5:	53                   	push   %ebx
801003f6:	89 c3                	mov    %eax,%ebx
801003f8:	83 ec 1c             	sub    $0x1c,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
801003fb:	3d 00 01 00 00       	cmp    $0x100,%eax
80100400:	0f 84 ac 00 00 00    	je     801004b2 <consputc+0xd2>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100406:	89 04 24             	mov    %eax,(%esp)
80100409:	e8 b2 57 00 00       	call   80105bc0 <uartputc>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010040e:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100413:	b8 0e 00 00 00       	mov    $0xe,%eax
80100418:	89 fa                	mov    %edi,%edx
8010041a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010041b:	be d5 03 00 00       	mov    $0x3d5,%esi
80100420:	89 f2                	mov    %esi,%edx
80100422:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100423:	0f b6 c8             	movzbl %al,%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100426:	89 fa                	mov    %edi,%edx
80100428:	c1 e1 08             	shl    $0x8,%ecx
8010042b:	b8 0f 00 00 00       	mov    $0xf,%eax
80100430:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100431:	89 f2                	mov    %esi,%edx
80100433:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
80100434:	0f b6 c0             	movzbl %al,%eax
80100437:	09 c1                	or     %eax,%ecx

  if(c == '\n')
80100439:	83 fb 0a             	cmp    $0xa,%ebx
8010043c:	0f 84 0d 01 00 00    	je     8010054f <consputc+0x16f>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100442:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
80100448:	0f 84 e8 00 00 00    	je     80100536 <consputc+0x156>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
8010044e:	0f b6 db             	movzbl %bl,%ebx
80100451:	80 cf 07             	or     $0x7,%bh
80100454:	8d 79 01             	lea    0x1(%ecx),%edi
80100457:	66 89 9c 09 00 80 0b 	mov    %bx,-0x7ff48000(%ecx,%ecx,1)
8010045e:	80 

  if(pos < 0 || pos > 25*80)
8010045f:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
80100465:	0f 87 bf 00 00 00    	ja     8010052a <consputc+0x14a>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
8010046b:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100471:	7f 68                	jg     801004db <consputc+0xfb>
80100473:	89 f8                	mov    %edi,%eax
80100475:	89 fb                	mov    %edi,%ebx
80100477:	c1 e8 08             	shr    $0x8,%eax
8010047a:	89 c6                	mov    %eax,%esi
8010047c:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100483:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100488:	b8 0e 00 00 00       	mov    $0xe,%eax
8010048d:	89 fa                	mov    %edi,%edx
8010048f:	ee                   	out    %al,(%dx)
80100490:	89 f0                	mov    %esi,%eax
80100492:	b2 d5                	mov    $0xd5,%dl
80100494:	ee                   	out    %al,(%dx)
80100495:	b8 0f 00 00 00       	mov    $0xf,%eax
8010049a:	89 fa                	mov    %edi,%edx
8010049c:	ee                   	out    %al,(%dx)
8010049d:	89 d8                	mov    %ebx,%eax
8010049f:	b2 d5                	mov    $0xd5,%dl
801004a1:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004a2:	b8 20 07 00 00       	mov    $0x720,%eax
801004a7:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004aa:	83 c4 1c             	add    $0x1c,%esp
801004ad:	5b                   	pop    %ebx
801004ae:	5e                   	pop    %esi
801004af:	5f                   	pop    %edi
801004b0:	5d                   	pop    %ebp
801004b1:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004b2:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004b9:	e8 02 57 00 00       	call   80105bc0 <uartputc>
801004be:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004c5:	e8 f6 56 00 00       	call   80105bc0 <uartputc>
801004ca:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004d1:	e8 ea 56 00 00       	call   80105bc0 <uartputc>
801004d6:	e9 33 ff ff ff       	jmp    8010040e <consputc+0x2e>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004db:	c7 44 24 08 60 0e 00 	movl   $0xe60,0x8(%esp)
801004e2:	00 
    pos -= 80;
801004e3:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004e6:	c7 44 24 04 a0 80 0b 	movl   $0x800b80a0,0x4(%esp)
801004ed:	80 
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
801004ee:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f5:	c7 04 24 00 80 0b 80 	movl   $0x800b8000,(%esp)
801004fc:	e8 8f 3e 00 00       	call   80104390 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100501:	b8 d0 07 00 00       	mov    $0x7d0,%eax
80100506:	29 f8                	sub    %edi,%eax
80100508:	01 c0                	add    %eax,%eax
8010050a:	89 34 24             	mov    %esi,(%esp)
8010050d:	89 44 24 08          	mov    %eax,0x8(%esp)
80100511:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100518:	00 
80100519:	e8 d2 3d 00 00       	call   801042f0 <memset>
8010051e:	89 f1                	mov    %esi,%ecx
80100520:	be 07 00 00 00       	mov    $0x7,%esi
80100525:	e9 59 ff ff ff       	jmp    80100483 <consputc+0xa3>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010052a:	c7 04 24 a5 70 10 80 	movl   $0x801070a5,(%esp)
80100531:	e8 2a fe ff ff       	call   80100360 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
80100536:	85 c9                	test   %ecx,%ecx
80100538:	8d 79 ff             	lea    -0x1(%ecx),%edi
8010053b:	0f 85 1e ff ff ff    	jne    8010045f <consputc+0x7f>
80100541:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
80100546:	31 db                	xor    %ebx,%ebx
80100548:	31 f6                	xor    %esi,%esi
8010054a:	e9 34 ff ff ff       	jmp    80100483 <consputc+0xa3>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
8010054f:	89 c8                	mov    %ecx,%eax
80100551:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100556:	f7 ea                	imul   %edx
80100558:	c1 ea 05             	shr    $0x5,%edx
8010055b:	8d 04 92             	lea    (%edx,%edx,4),%eax
8010055e:	c1 e0 04             	shl    $0x4,%eax
80100561:	8d 78 50             	lea    0x50(%eax),%edi
80100564:	e9 f6 fe ff ff       	jmp    8010045f <consputc+0x7f>
80100569:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100570 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100570:	55                   	push   %ebp
80100571:	89 e5                	mov    %esp,%ebp
80100573:	57                   	push   %edi
80100574:	56                   	push   %esi
80100575:	89 d6                	mov    %edx,%esi
80100577:	53                   	push   %ebx
80100578:	83 ec 1c             	sub    $0x1c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010057b:	85 c9                	test   %ecx,%ecx
8010057d:	74 61                	je     801005e0 <printint+0x70>
8010057f:	85 c0                	test   %eax,%eax
80100581:	79 5d                	jns    801005e0 <printint+0x70>
    x = -xx;
80100583:	f7 d8                	neg    %eax
80100585:	bf 01 00 00 00       	mov    $0x1,%edi
  else
    x = xx;

  i = 0;
8010058a:	31 c9                	xor    %ecx,%ecx
8010058c:	eb 04                	jmp    80100592 <printint+0x22>
8010058e:	66 90                	xchg   %ax,%ax
  do{
    buf[i++] = digits[x % base];
80100590:	89 d9                	mov    %ebx,%ecx
80100592:	31 d2                	xor    %edx,%edx
80100594:	f7 f6                	div    %esi
80100596:	8d 59 01             	lea    0x1(%ecx),%ebx
80100599:	0f b6 92 d0 70 10 80 	movzbl -0x7fef8f30(%edx),%edx
  }while((x /= base) != 0);
801005a0:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005a2:	88 54 1d d7          	mov    %dl,-0x29(%ebp,%ebx,1)
  }while((x /= base) != 0);
801005a6:	75 e8                	jne    80100590 <printint+0x20>

  if(sign)
801005a8:	85 ff                	test   %edi,%edi
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005aa:	89 d8                	mov    %ebx,%eax
  }while((x /= base) != 0);

  if(sign)
801005ac:	74 08                	je     801005b6 <printint+0x46>
    buf[i++] = '-';
801005ae:	8d 59 02             	lea    0x2(%ecx),%ebx
801005b1:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
801005b6:	83 eb 01             	sub    $0x1,%ebx
801005b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    consputc(buf[i]);
801005c0:	0f be 44 1d d8       	movsbl -0x28(%ebp,%ebx,1),%eax
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005c5:	83 eb 01             	sub    $0x1,%ebx
    consputc(buf[i]);
801005c8:	e8 13 fe ff ff       	call   801003e0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005cd:	83 fb ff             	cmp    $0xffffffff,%ebx
801005d0:	75 ee                	jne    801005c0 <printint+0x50>
    consputc(buf[i]);
}
801005d2:	83 c4 1c             	add    $0x1c,%esp
801005d5:	5b                   	pop    %ebx
801005d6:	5e                   	pop    %esi
801005d7:	5f                   	pop    %edi
801005d8:	5d                   	pop    %ebp
801005d9:	c3                   	ret    
801005da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
  else
    x = xx;
801005e0:	31 ff                	xor    %edi,%edi
801005e2:	eb a6                	jmp    8010058a <printint+0x1a>
801005e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801005f0 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005f0:	55                   	push   %ebp
801005f1:	89 e5                	mov    %esp,%ebp
801005f3:	57                   	push   %edi
801005f4:	56                   	push   %esi
801005f5:	53                   	push   %ebx
801005f6:	83 ec 1c             	sub    $0x1c,%esp
  int i;

  iunlock(ip);
801005f9:	8b 45 08             	mov    0x8(%ebp),%eax
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
801005fc:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
801005ff:	89 04 24             	mov    %eax,(%esp)
80100602:	e8 99 11 00 00       	call   801017a0 <iunlock>
  acquire(&cons.lock);
80100607:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
8010060e:	e8 1d 3c 00 00       	call   80104230 <acquire>
80100613:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100616:	85 f6                	test   %esi,%esi
80100618:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010061b:	7e 12                	jle    8010062f <consolewrite+0x3f>
8010061d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100620:	0f b6 07             	movzbl (%edi),%eax
80100623:	83 c7 01             	add    $0x1,%edi
80100626:	e8 b5 fd ff ff       	call   801003e0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010062b:	39 df                	cmp    %ebx,%edi
8010062d:	75 f1                	jne    80100620 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010062f:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100636:	e8 65 3c 00 00       	call   801042a0 <release>
  ilock(ip);
8010063b:	8b 45 08             	mov    0x8(%ebp),%eax
8010063e:	89 04 24             	mov    %eax,(%esp)
80100641:	e8 7a 10 00 00       	call   801016c0 <ilock>

  return n;
}
80100646:	83 c4 1c             	add    $0x1c,%esp
80100649:	89 f0                	mov    %esi,%eax
8010064b:	5b                   	pop    %ebx
8010064c:	5e                   	pop    %esi
8010064d:	5f                   	pop    %edi
8010064e:	5d                   	pop    %ebp
8010064f:	c3                   	ret    

80100650 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100650:	55                   	push   %ebp
80100651:	89 e5                	mov    %esp,%ebp
80100653:	57                   	push   %edi
80100654:	56                   	push   %esi
80100655:	53                   	push   %ebx
80100656:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100659:	a1 54 a5 10 80       	mov    0x8010a554,%eax
  if(locking)
8010065e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100660:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100663:	0f 85 27 01 00 00    	jne    80100790 <cprintf+0x140>
    acquire(&cons.lock);

  if (fmt == 0)
80100669:	8b 45 08             	mov    0x8(%ebp),%eax
8010066c:	85 c0                	test   %eax,%eax
8010066e:	89 c1                	mov    %eax,%ecx
80100670:	0f 84 2b 01 00 00    	je     801007a1 <cprintf+0x151>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100676:	0f b6 00             	movzbl (%eax),%eax
80100679:	31 db                	xor    %ebx,%ebx
8010067b:	89 cf                	mov    %ecx,%edi
8010067d:	8d 75 0c             	lea    0xc(%ebp),%esi
80100680:	85 c0                	test   %eax,%eax
80100682:	75 4c                	jne    801006d0 <cprintf+0x80>
80100684:	eb 5f                	jmp    801006e5 <cprintf+0x95>
80100686:	66 90                	xchg   %ax,%ax
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
80100688:	83 c3 01             	add    $0x1,%ebx
8010068b:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
8010068f:	85 d2                	test   %edx,%edx
80100691:	74 52                	je     801006e5 <cprintf+0x95>
      break;
    switch(c){
80100693:	83 fa 70             	cmp    $0x70,%edx
80100696:	74 72                	je     8010070a <cprintf+0xba>
80100698:	7f 66                	jg     80100700 <cprintf+0xb0>
8010069a:	83 fa 25             	cmp    $0x25,%edx
8010069d:	8d 76 00             	lea    0x0(%esi),%esi
801006a0:	0f 84 a2 00 00 00    	je     80100748 <cprintf+0xf8>
801006a6:	83 fa 64             	cmp    $0x64,%edx
801006a9:	75 7d                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
801006ab:	8d 46 04             	lea    0x4(%esi),%eax
801006ae:	b9 01 00 00 00       	mov    $0x1,%ecx
801006b3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006b6:	8b 06                	mov    (%esi),%eax
801006b8:	ba 0a 00 00 00       	mov    $0xa,%edx
801006bd:	e8 ae fe ff ff       	call   80100570 <printint>
801006c2:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006c5:	83 c3 01             	add    $0x1,%ebx
801006c8:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006cc:	85 c0                	test   %eax,%eax
801006ce:	74 15                	je     801006e5 <cprintf+0x95>
    if(c != '%'){
801006d0:	83 f8 25             	cmp    $0x25,%eax
801006d3:	74 b3                	je     80100688 <cprintf+0x38>
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
      consputc(c);
801006d5:	e8 06 fd ff ff       	call   801003e0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006da:	83 c3 01             	add    $0x1,%ebx
801006dd:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e1:	85 c0                	test   %eax,%eax
801006e3:	75 eb                	jne    801006d0 <cprintf+0x80>
      consputc(c);
      break;
    }
  }

  if(locking)
801006e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
801006e8:	85 c0                	test   %eax,%eax
801006ea:	74 0c                	je     801006f8 <cprintf+0xa8>
    release(&cons.lock);
801006ec:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801006f3:	e8 a8 3b 00 00       	call   801042a0 <release>
}
801006f8:	83 c4 1c             	add    $0x1c,%esp
801006fb:	5b                   	pop    %ebx
801006fc:	5e                   	pop    %esi
801006fd:	5f                   	pop    %edi
801006fe:	5d                   	pop    %ebp
801006ff:	c3                   	ret    
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100700:	83 fa 73             	cmp    $0x73,%edx
80100703:	74 53                	je     80100758 <cprintf+0x108>
80100705:	83 fa 78             	cmp    $0x78,%edx
80100708:	75 1e                	jne    80100728 <cprintf+0xd8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010070a:	8d 46 04             	lea    0x4(%esi),%eax
8010070d:	31 c9                	xor    %ecx,%ecx
8010070f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100712:	8b 06                	mov    (%esi),%eax
80100714:	ba 10 00 00 00       	mov    $0x10,%edx
80100719:	e8 52 fe ff ff       	call   80100570 <printint>
8010071e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100721:	eb a2                	jmp    801006c5 <cprintf+0x75>
80100723:	90                   	nop
80100724:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100728:	b8 25 00 00 00       	mov    $0x25,%eax
8010072d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100730:	e8 ab fc ff ff       	call   801003e0 <consputc>
      consputc(c);
80100735:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100738:	89 d0                	mov    %edx,%eax
8010073a:	e8 a1 fc ff ff       	call   801003e0 <consputc>
8010073f:	eb 99                	jmp    801006da <cprintf+0x8a>
80100741:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	e8 8e fc ff ff       	call   801003e0 <consputc>
      break;
80100752:	e9 6e ff ff ff       	jmp    801006c5 <cprintf+0x75>
80100757:	90                   	nop
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100758:	8d 46 04             	lea    0x4(%esi),%eax
8010075b:	8b 36                	mov    (%esi),%esi
8010075d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100760:	b8 b8 70 10 80       	mov    $0x801070b8,%eax
80100765:	85 f6                	test   %esi,%esi
80100767:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
8010076a:	0f be 06             	movsbl (%esi),%eax
8010076d:	84 c0                	test   %al,%al
8010076f:	74 16                	je     80100787 <cprintf+0x137>
80100771:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100778:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
8010077b:	e8 60 fc ff ff       	call   801003e0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
80100780:	0f be 06             	movsbl (%esi),%eax
80100783:	84 c0                	test   %al,%al
80100785:	75 f1                	jne    80100778 <cprintf+0x128>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100787:	8b 75 e4             	mov    -0x1c(%ebp),%esi
8010078a:	e9 36 ff ff ff       	jmp    801006c5 <cprintf+0x75>
8010078f:	90                   	nop
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
80100790:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100797:	e8 94 3a 00 00       	call   80104230 <acquire>
8010079c:	e9 c8 fe ff ff       	jmp    80100669 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007a1:	c7 04 24 bf 70 10 80 	movl   $0x801070bf,(%esp)
801007a8:	e8 b3 fb ff ff       	call   80100360 <panic>
801007ad:	8d 76 00             	lea    0x0(%esi),%esi

801007b0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b0:	55                   	push   %ebp
801007b1:	89 e5                	mov    %esp,%ebp
801007b3:	57                   	push   %edi
801007b4:	56                   	push   %esi
  int c, doprocdump = 0;
801007b5:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007b7:	53                   	push   %ebx
801007b8:	83 ec 1c             	sub    $0x1c,%esp
801007bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007be:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
801007c5:	e8 66 3a 00 00       	call   80104230 <acquire>
801007ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  while((c = getc()) >= 0){
801007d0:	ff d3                	call   *%ebx
801007d2:	85 c0                	test   %eax,%eax
801007d4:	89 c7                	mov    %eax,%edi
801007d6:	78 48                	js     80100820 <consoleintr+0x70>
    switch(c){
801007d8:	83 ff 10             	cmp    $0x10,%edi
801007db:	0f 84 2f 01 00 00    	je     80100910 <consoleintr+0x160>
801007e1:	7e 5d                	jle    80100840 <consoleintr+0x90>
801007e3:	83 ff 15             	cmp    $0x15,%edi
801007e6:	0f 84 d4 00 00 00    	je     801008c0 <consoleintr+0x110>
801007ec:	83 ff 7f             	cmp    $0x7f,%edi
801007ef:	90                   	nop
801007f0:	75 53                	jne    80100845 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
801007f2:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801007f7:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801007fd:	74 d1                	je     801007d0 <consoleintr+0x20>
        input.e--;
801007ff:	83 e8 01             	sub    $0x1,%eax
80100802:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
80100807:	b8 00 01 00 00       	mov    $0x100,%eax
8010080c:	e8 cf fb ff ff       	call   801003e0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100811:	ff d3                	call   *%ebx
80100813:	85 c0                	test   %eax,%eax
80100815:	89 c7                	mov    %eax,%edi
80100817:	79 bf                	jns    801007d8 <consoleintr+0x28>
80100819:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100820:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100827:	e8 74 3a 00 00       	call   801042a0 <release>
  if(doprocdump) {
8010082c:	85 f6                	test   %esi,%esi
8010082e:	0f 85 ec 00 00 00    	jne    80100920 <consoleintr+0x170>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100834:	83 c4 1c             	add    $0x1c,%esp
80100837:	5b                   	pop    %ebx
80100838:	5e                   	pop    %esi
80100839:	5f                   	pop    %edi
8010083a:	5d                   	pop    %ebp
8010083b:	c3                   	ret    
8010083c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100840:	83 ff 08             	cmp    $0x8,%edi
80100843:	74 ad                	je     801007f2 <consoleintr+0x42>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100845:	85 ff                	test   %edi,%edi
80100847:	74 87                	je     801007d0 <consoleintr+0x20>
80100849:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010084e:	89 c2                	mov    %eax,%edx
80100850:	2b 15 a0 ff 10 80    	sub    0x8010ffa0,%edx
80100856:	83 fa 7f             	cmp    $0x7f,%edx
80100859:	0f 87 71 ff ff ff    	ja     801007d0 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010085f:	8d 50 01             	lea    0x1(%eax),%edx
80100862:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
80100865:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
80100868:	89 15 a8 ff 10 80    	mov    %edx,0x8010ffa8
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
8010086e:	0f 84 b8 00 00 00    	je     8010092c <consoleintr+0x17c>
        input.buf[input.e++ % INPUT_BUF] = c;
80100874:	89 f9                	mov    %edi,%ecx
80100876:	88 88 20 ff 10 80    	mov    %cl,-0x7fef00e0(%eax)
        consputc(c);
8010087c:	89 f8                	mov    %edi,%eax
8010087e:	e8 5d fb ff ff       	call   801003e0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
80100883:	83 ff 04             	cmp    $0x4,%edi
80100886:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
8010088b:	74 19                	je     801008a6 <consoleintr+0xf6>
8010088d:	83 ff 0a             	cmp    $0xa,%edi
80100890:	74 14                	je     801008a6 <consoleintr+0xf6>
80100892:	8b 0d a0 ff 10 80    	mov    0x8010ffa0,%ecx
80100898:	8d 91 80 00 00 00    	lea    0x80(%ecx),%edx
8010089e:	39 d0                	cmp    %edx,%eax
801008a0:	0f 85 2a ff ff ff    	jne    801007d0 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008a6:	c7 04 24 a0 ff 10 80 	movl   $0x8010ffa0,(%esp)
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ad:	a3 a4 ff 10 80       	mov    %eax,0x8010ffa4
          wakeup(&input.r);
801008b2:	e8 19 35 00 00       	call   80103dd0 <wakeup>
801008b7:	e9 14 ff ff ff       	jmp    801007d0 <consoleintr+0x20>
801008bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008c0:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008c5:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008cb:	75 2b                	jne    801008f8 <consoleintr+0x148>
801008cd:	e9 fe fe ff ff       	jmp    801007d0 <consoleintr+0x20>
801008d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
801008d8:	a3 a8 ff 10 80       	mov    %eax,0x8010ffa8
        consputc(BACKSPACE);
801008dd:	b8 00 01 00 00       	mov    $0x100,%eax
801008e2:	e8 f9 fa ff ff       	call   801003e0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
801008e7:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
801008ec:	3b 05 a4 ff 10 80    	cmp    0x8010ffa4,%eax
801008f2:	0f 84 d8 fe ff ff    	je     801007d0 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
801008f8:	83 e8 01             	sub    $0x1,%eax
801008fb:	89 c2                	mov    %eax,%edx
801008fd:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100900:	80 ba 20 ff 10 80 0a 	cmpb   $0xa,-0x7fef00e0(%edx)
80100907:	75 cf                	jne    801008d8 <consoleintr+0x128>
80100909:	e9 c2 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010090e:	66 90                	xchg   %ax,%ax
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100910:	be 01 00 00 00       	mov    $0x1,%esi
80100915:	e9 b6 fe ff ff       	jmp    801007d0 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100920:	83 c4 1c             	add    $0x1c,%esp
80100923:	5b                   	pop    %ebx
80100924:	5e                   	pop    %esi
80100925:	5f                   	pop    %edi
80100926:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100927:	e9 94 35 00 00       	jmp    80103ec0 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010092c:	c6 80 20 ff 10 80 0a 	movb   $0xa,-0x7fef00e0(%eax)
        consputc(c);
80100933:	b8 0a 00 00 00       	mov    $0xa,%eax
80100938:	e8 a3 fa ff ff       	call   801003e0 <consputc>
8010093d:	a1 a8 ff 10 80       	mov    0x8010ffa8,%eax
80100942:	e9 5f ff ff ff       	jmp    801008a6 <consoleintr+0xf6>
80100947:	89 f6                	mov    %esi,%esi
80100949:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100950 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
80100950:	55                   	push   %ebp
80100951:	89 e5                	mov    %esp,%ebp
80100953:	83 ec 18             	sub    $0x18,%esp
  initlock(&cons.lock, "console");
80100956:	c7 44 24 04 c8 70 10 	movl   $0x801070c8,0x4(%esp)
8010095d:	80 
8010095e:	c7 04 24 20 a5 10 80 	movl   $0x8010a520,(%esp)
80100965:	e8 56 37 00 00       	call   801040c0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
8010096a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80100971:	00 
80100972:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
80100979:	c7 05 6c 09 11 80 f0 	movl   $0x801005f0,0x8011096c
80100980:	05 10 80 
  devsw[CONSOLE].read = consoleread;
80100983:	c7 05 68 09 11 80 70 	movl   $0x80100270,0x80110968
8010098a:	02 10 80 
  cons.locking = 1;
8010098d:	c7 05 54 a5 10 80 01 	movl   $0x1,0x8010a554
80100994:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
80100997:	e8 24 19 00 00       	call   801022c0 <ioapicenable>
}
8010099c:	c9                   	leave  
8010099d:	c3                   	ret    
8010099e:	66 90                	xchg   %ax,%ax

801009a0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	57                   	push   %edi
801009a4:	56                   	push   %esi
801009a5:	53                   	push   %ebx
801009a6:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009ac:	e8 ff 2c 00 00       	call   801036b0 <myproc>
801009b1:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
801009b7:	e8 64 21 00 00       	call   80102b20 <begin_op>

  if((ip = namei(path)) == 0){
801009bc:	8b 45 08             	mov    0x8(%ebp),%eax
801009bf:	89 04 24             	mov    %eax,(%esp)
801009c2:	e8 49 15 00 00       	call   80101f10 <namei>
801009c7:	85 c0                	test   %eax,%eax
801009c9:	89 c3                	mov    %eax,%ebx
801009cb:	0f 84 c2 01 00 00    	je     80100b93 <exec+0x1f3>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
801009d1:	89 04 24             	mov    %eax,(%esp)
801009d4:	e8 e7 0c 00 00       	call   801016c0 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
801009d9:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
801009df:	c7 44 24 0c 34 00 00 	movl   $0x34,0xc(%esp)
801009e6:	00 
801009e7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
801009ee:	00 
801009ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801009f3:	89 1c 24             	mov    %ebx,(%esp)
801009f6:	e8 75 0f 00 00       	call   80101970 <readi>
801009fb:	83 f8 34             	cmp    $0x34,%eax
801009fe:	74 20                	je     80100a20 <exec+0x80>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a00:	89 1c 24             	mov    %ebx,(%esp)
80100a03:	e8 18 0f 00 00       	call   80101920 <iunlockput>
    end_op();
80100a08:	e8 83 21 00 00       	call   80102b90 <end_op>
  }
  return -1;
80100a0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a12:	81 c4 2c 01 00 00    	add    $0x12c,%esp
80100a18:	5b                   	pop    %ebx
80100a19:	5e                   	pop    %esi
80100a1a:	5f                   	pop    %edi
80100a1b:	5d                   	pop    %ebp
80100a1c:	c3                   	ret    
80100a1d:	8d 76 00             	lea    0x0(%esi),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a20:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a27:	45 4c 46 
80100a2a:	75 d4                	jne    80100a00 <exec+0x60>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a2c:	e8 7f 63 00 00       	call   80106db0 <setupkvm>
80100a31:	85 c0                	test   %eax,%eax
80100a33:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a39:	74 c5                	je     80100a00 <exec+0x60>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a3b:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a42:	00 
80100a43:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi

  if((pgdir = setupkvm()) == 0)
    goto bad;

  // Load program into memory.
  sz = 0;
80100a49:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a50:	00 00 00 
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a53:	0f 84 da 00 00 00    	je     80100b33 <exec+0x193>
80100a59:	31 ff                	xor    %edi,%edi
80100a5b:	eb 18                	jmp    80100a75 <exec+0xd5>
80100a5d:	8d 76 00             	lea    0x0(%esi),%esi
80100a60:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100a67:	83 c7 01             	add    $0x1,%edi
80100a6a:	83 c6 20             	add    $0x20,%esi
80100a6d:	39 f8                	cmp    %edi,%eax
80100a6f:	0f 8e be 00 00 00    	jle    80100b33 <exec+0x193>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100a75:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100a7b:	c7 44 24 0c 20 00 00 	movl   $0x20,0xc(%esp)
80100a82:	00 
80100a83:	89 74 24 08          	mov    %esi,0x8(%esp)
80100a87:	89 44 24 04          	mov    %eax,0x4(%esp)
80100a8b:	89 1c 24             	mov    %ebx,(%esp)
80100a8e:	e8 dd 0e 00 00       	call   80101970 <readi>
80100a93:	83 f8 20             	cmp    $0x20,%eax
80100a96:	0f 85 84 00 00 00    	jne    80100b20 <exec+0x180>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100a9c:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100aa3:	75 bb                	jne    80100a60 <exec+0xc0>
      continue;
    if(ph.memsz < ph.filesz)
80100aa5:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100aab:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100ab1:	72 6d                	jb     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100ab3:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100ab9:	72 65                	jb     80100b20 <exec+0x180>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100abb:	89 44 24 08          	mov    %eax,0x8(%esp)
80100abf:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ac9:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100acf:	89 04 24             	mov    %eax,(%esp)
80100ad2:	e8 49 61 00 00       	call   80106c20 <allocuvm>
80100ad7:	85 c0                	test   %eax,%eax
80100ad9:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100adf:	74 3f                	je     80100b20 <exec+0x180>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100ae1:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100ae7:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100aec:	75 32                	jne    80100b20 <exec+0x180>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100aee:	8b 95 14 ff ff ff    	mov    -0xec(%ebp),%edx
80100af4:	89 44 24 04          	mov    %eax,0x4(%esp)
80100af8:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100afe:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80100b02:	89 54 24 10          	mov    %edx,0x10(%esp)
80100b06:	8b 95 08 ff ff ff    	mov    -0xf8(%ebp),%edx
80100b0c:	89 04 24             	mov    %eax,(%esp)
80100b0f:	89 54 24 0c          	mov    %edx,0xc(%esp)
80100b13:	e8 48 60 00 00       	call   80106b60 <loaduvm>
80100b18:	85 c0                	test   %eax,%eax
80100b1a:	0f 89 40 ff ff ff    	jns    80100a60 <exec+0xc0>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b20:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b26:	89 04 24             	mov    %eax,(%esp)
80100b29:	e8 02 62 00 00       	call   80106d30 <freevm>
80100b2e:	e9 cd fe ff ff       	jmp    80100a00 <exec+0x60>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b33:	89 1c 24             	mov    %ebx,(%esp)
80100b36:	e8 e5 0d 00 00       	call   80101920 <iunlockput>
80100b3b:	90                   	nop
80100b3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  end_op();
80100b40:	e8 4b 20 00 00       	call   80102b90 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b45:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
80100b4b:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b50:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b55:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b5b:	89 44 24 04          	mov    %eax,0x4(%esp)
80100b5f:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b65:	89 54 24 08          	mov    %edx,0x8(%esp)
80100b69:	89 04 24             	mov    %eax,(%esp)
80100b6c:	e8 af 60 00 00       	call   80106c20 <allocuvm>
80100b71:	85 c0                	test   %eax,%eax
80100b73:	89 85 e8 fe ff ff    	mov    %eax,-0x118(%ebp)
80100b79:	75 33                	jne    80100bae <exec+0x20e>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b7b:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100b81:	89 04 24             	mov    %eax,(%esp)
80100b84:	e8 a7 61 00 00       	call   80106d30 <freevm>
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100b89:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100b8e:	e9 7f fe ff ff       	jmp    80100a12 <exec+0x72>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100b93:	e8 f8 1f 00 00       	call   80102b90 <end_op>
    cprintf("exec: fail\n");
80100b98:	c7 04 24 e1 70 10 80 	movl   $0x801070e1,(%esp)
80100b9f:	e8 ac fa ff ff       	call   80100650 <cprintf>
    return -1;
80100ba4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100ba9:	e9 64 fe ff ff       	jmp    80100a12 <exec+0x72>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bae:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100bb4:	89 d8                	mov    %ebx,%eax
80100bb6:	2d 00 20 00 00       	sub    $0x2000,%eax
80100bbb:	89 44 24 04          	mov    %eax,0x4(%esp)
80100bbf:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100bc5:	89 04 24             	mov    %eax,(%esp)
80100bc8:	e8 93 62 00 00       	call   80106e60 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bd0:	8b 00                	mov    (%eax),%eax
80100bd2:	85 c0                	test   %eax,%eax
80100bd4:	0f 84 59 01 00 00    	je     80100d33 <exec+0x393>
80100bda:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80100bdd:	31 d2                	xor    %edx,%edx
80100bdf:	8d 71 04             	lea    0x4(%ecx),%esi
80100be2:	89 cf                	mov    %ecx,%edi
80100be4:	89 d1                	mov    %edx,%ecx
80100be6:	89 f2                	mov    %esi,%edx
80100be8:	89 fe                	mov    %edi,%esi
80100bea:	89 cf                	mov    %ecx,%edi
80100bec:	eb 0a                	jmp    80100bf8 <exec+0x258>
80100bee:	66 90                	xchg   %ax,%ax
80100bf0:	83 c2 04             	add    $0x4,%edx
    if(argc >= MAXARG)
80100bf3:	83 ff 20             	cmp    $0x20,%edi
80100bf6:	74 83                	je     80100b7b <exec+0x1db>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100bf8:	89 04 24             	mov    %eax,(%esp)
80100bfb:	89 95 ec fe ff ff    	mov    %edx,-0x114(%ebp)
80100c01:	e8 0a 39 00 00       	call   80104510 <strlen>
80100c06:	f7 d0                	not    %eax
80100c08:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0a:	8b 06                	mov    (%esi),%eax

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c0c:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c0f:	89 04 24             	mov    %eax,(%esp)
80100c12:	e8 f9 38 00 00       	call   80104510 <strlen>
80100c17:	83 c0 01             	add    $0x1,%eax
80100c1a:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c1e:	8b 06                	mov    (%esi),%eax
80100c20:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80100c24:	89 44 24 08          	mov    %eax,0x8(%esp)
80100c28:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c2e:	89 04 24             	mov    %eax,(%esp)
80100c31:	e8 8a 63 00 00       	call   80106fc0 <copyout>
80100c36:	85 c0                	test   %eax,%eax
80100c38:	0f 88 3d ff ff ff    	js     80100b7b <exec+0x1db>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c3e:	8b 95 ec fe ff ff    	mov    -0x114(%ebp),%edx
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c44:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100c4a:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c51:	83 c7 01             	add    $0x1,%edi
80100c54:	8b 02                	mov    (%edx),%eax
80100c56:	89 d6                	mov    %edx,%esi
80100c58:	85 c0                	test   %eax,%eax
80100c5a:	75 94                	jne    80100bf0 <exec+0x250>
80100c5c:	89 fa                	mov    %edi,%edx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c5e:	c7 84 95 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edx,4)
80100c65:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c69:	8d 04 95 04 00 00 00 	lea    0x4(,%edx,4),%eax
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
80100c70:	89 95 5c ff ff ff    	mov    %edx,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c76:	89 da                	mov    %ebx,%edx
80100c78:	29 c2                	sub    %eax,%edx

  sp -= (3+argc+1) * 4;
80100c7a:	83 c0 0c             	add    $0xc,%eax
80100c7d:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c7f:	89 44 24 0c          	mov    %eax,0xc(%esp)
80100c83:	8b 85 f0 fe ff ff    	mov    -0x110(%ebp),%eax
80100c89:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80100c8d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
80100c91:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c98:	ff ff ff 
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100c9b:	89 04 24             	mov    %eax,(%esp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c9e:	89 95 60 ff ff ff    	mov    %edx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100ca4:	e8 17 63 00 00       	call   80106fc0 <copyout>
80100ca9:	85 c0                	test   %eax,%eax
80100cab:	0f 88 ca fe ff ff    	js     80100b7b <exec+0x1db>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cb1:	8b 45 08             	mov    0x8(%ebp),%eax
80100cb4:	0f b6 10             	movzbl (%eax),%edx
80100cb7:	84 d2                	test   %dl,%dl
80100cb9:	74 19                	je     80100cd4 <exec+0x334>
80100cbb:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cbe:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cc1:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cc4:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100cc7:	0f 44 c8             	cmove  %eax,%ecx
80100cca:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccd:	84 d2                	test   %dl,%dl
80100ccf:	75 f0                	jne    80100cc1 <exec+0x321>
80100cd1:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cd4:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cda:	8b 45 08             	mov    0x8(%ebp),%eax
80100cdd:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80100ce4:	00 
80100ce5:	89 44 24 04          	mov    %eax,0x4(%esp)
80100ce9:	89 f8                	mov    %edi,%eax
80100ceb:	83 c0 6c             	add    $0x6c,%eax
80100cee:	89 04 24             	mov    %eax,(%esp)
80100cf1:	e8 da 37 00 00       	call   801044d0 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100cf6:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100cfc:	8b 77 04             	mov    0x4(%edi),%esi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100cff:	8b 47 18             	mov    0x18(%edi),%eax
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d02:	89 4f 04             	mov    %ecx,0x4(%edi)
  curproc->sz = sz;
80100d05:	8b 8d e8 fe ff ff    	mov    -0x118(%ebp),%ecx
80100d0b:	89 0f                	mov    %ecx,(%edi)
  curproc->tf->eip = elf.entry;  // main
80100d0d:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d13:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d16:	8b 47 18             	mov    0x18(%edi),%eax
80100d19:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d1c:	89 3c 24             	mov    %edi,(%esp)
80100d1f:	e8 ac 5c 00 00       	call   801069d0 <switchuvm>
  freevm(oldpgdir);
80100d24:	89 34 24             	mov    %esi,(%esp)
80100d27:	e8 04 60 00 00       	call   80106d30 <freevm>
  return 0;
80100d2c:	31 c0                	xor    %eax,%eax
80100d2e:	e9 df fc ff ff       	jmp    80100a12 <exec+0x72>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100d33:	8b 9d e8 fe ff ff    	mov    -0x118(%ebp),%ebx
80100d39:	31 d2                	xor    %edx,%edx
80100d3b:	8d 8d 58 ff ff ff    	lea    -0xa8(%ebp),%ecx
80100d41:	e9 18 ff ff ff       	jmp    80100c5e <exec+0x2be>
80100d46:	66 90                	xchg   %ax,%ax
80100d48:	66 90                	xchg   %ax,%ax
80100d4a:	66 90                	xchg   %ax,%ax
80100d4c:	66 90                	xchg   %ax,%ax
80100d4e:	66 90                	xchg   %ax,%ax

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 18             	sub    $0x18,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	c7 44 24 04 ed 70 10 	movl   $0x801070ed,0x4(%esp)
80100d5d:	80 
80100d5e:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d65:	e8 56 33 00 00       	call   801040c0 <initlock>
}
80100d6a:	c9                   	leave  
80100d6b:	c3                   	ret    
80100d6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb f4 ff 10 80       	mov    $0x8010fff4,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 14             	sub    $0x14,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100d83:	e8 a8 34 00 00       	call   80104230 <acquire>
80100d88:	eb 11                	jmp    80100d9b <filealloc+0x2b>
80100d8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb 54 09 11 80    	cmp    $0x80110954,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da9:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100db0:	e8 eb 34 00 00       	call   801042a0 <release>
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
}
80100db5:	83 c4 14             	add    $0x14,%esp
  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
      release(&ftable.lock);
      return f;
80100db8:	89 d8                	mov    %ebx,%eax
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dba:	5b                   	pop    %ebx
80100dbb:	5d                   	pop    %ebp
80100dbc:	c3                   	ret    
80100dbd:	8d 76 00             	lea    0x0(%esi),%esi
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100dc7:	e8 d4 34 00 00       	call   801042a0 <release>
  return 0;
}
80100dcc:	83 c4 14             	add    $0x14,%esp
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
  return 0;
80100dcf:	31 c0                	xor    %eax,%eax
}
80100dd1:	5b                   	pop    %ebx
80100dd2:	5d                   	pop    %ebp
80100dd3:	c3                   	ret    
80100dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 14             	sub    $0x14,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100df1:	e8 3a 34 00 00       	call   80104230 <acquire>
  if(f->ref < 1)
80100df6:	8b 43 04             	mov    0x4(%ebx),%eax
80100df9:	85 c0                	test   %eax,%eax
80100dfb:	7e 1a                	jle    80100e17 <filedup+0x37>
    panic("filedup");
  f->ref++;
80100dfd:	83 c0 01             	add    $0x1,%eax
80100e00:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e03:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e0a:	e8 91 34 00 00       	call   801042a0 <release>
  return f;
}
80100e0f:	83 c4 14             	add    $0x14,%esp
80100e12:	89 d8                	mov    %ebx,%eax
80100e14:	5b                   	pop    %ebx
80100e15:	5d                   	pop    %ebp
80100e16:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e17:	c7 04 24 f4 70 10 80 	movl   $0x801070f4,(%esp)
80100e1e:	e8 3d f5 ff ff       	call   80100360 <panic>
80100e23:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 1c             	sub    $0x1c,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
80100e43:	e8 e8 33 00 00       	call   80104230 <acquire>
  if(f->ref < 1)
80100e48:	8b 57 04             	mov    0x4(%edi),%edx
80100e4b:	85 d2                	test   %edx,%edx
80100e4d:	0f 8e 89 00 00 00    	jle    80100edc <fileclose+0xac>
    panic("fileclose");
  if(--f->ref > 0){
80100e53:	83 ea 01             	sub    $0x1,%edx
80100e56:	85 d2                	test   %edx,%edx
80100e58:	89 57 04             	mov    %edx,0x4(%edi)
80100e5b:	74 13                	je     80100e70 <fileclose+0x40>
    release(&ftable.lock);
80100e5d:	c7 45 08 c0 ff 10 80 	movl   $0x8010ffc0,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e64:	83 c4 1c             	add    $0x1c,%esp
80100e67:	5b                   	pop    %ebx
80100e68:	5e                   	pop    %esi
80100e69:	5f                   	pop    %edi
80100e6a:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6b:	e9 30 34 00 00       	jmp    801042a0 <release>
    return;
  }
  ff = *f;
80100e70:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e74:	8b 37                	mov    (%edi),%esi
80100e76:	8b 5f 0c             	mov    0xc(%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
80100e79:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e7f:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e82:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e85:	c7 04 24 c0 ff 10 80 	movl   $0x8010ffc0,(%esp)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e8f:	e8 0c 34 00 00       	call   801042a0 <release>

  if(ff.type == FD_PIPE)
80100e94:	83 fe 01             	cmp    $0x1,%esi
80100e97:	74 0f                	je     80100ea8 <fileclose+0x78>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100e99:	83 fe 02             	cmp    $0x2,%esi
80100e9c:	74 22                	je     80100ec0 <fileclose+0x90>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e9e:	83 c4 1c             	add    $0x1c,%esp
80100ea1:	5b                   	pop    %ebx
80100ea2:	5e                   	pop    %esi
80100ea3:	5f                   	pop    %edi
80100ea4:	5d                   	pop    %ebp
80100ea5:	c3                   	ret    
80100ea6:	66 90                	xchg   %ax,%ax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100ea8:	0f be 75 e7          	movsbl -0x19(%ebp),%esi
80100eac:	89 1c 24             	mov    %ebx,(%esp)
80100eaf:	89 74 24 04          	mov    %esi,0x4(%esp)
80100eb3:	e8 b8 23 00 00       	call   80103270 <pipeclose>
80100eb8:	eb e4                	jmp    80100e9e <fileclose+0x6e>
80100eba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ec0:	e8 5b 1c 00 00       	call   80102b20 <begin_op>
    iput(ff.ip);
80100ec5:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100ec8:	89 04 24             	mov    %eax,(%esp)
80100ecb:	e8 10 09 00 00       	call   801017e0 <iput>
    end_op();
  }
}
80100ed0:	83 c4 1c             	add    $0x1c,%esp
80100ed3:	5b                   	pop    %ebx
80100ed4:	5e                   	pop    %esi
80100ed5:	5f                   	pop    %edi
80100ed6:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100ed7:	e9 b4 1c 00 00       	jmp    80102b90 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100edc:	c7 04 24 fc 70 10 80 	movl   $0x801070fc,(%esp)
80100ee3:	e8 78 f4 ff ff       	call   80100360 <panic>
80100ee8:	90                   	nop
80100ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80100ef0 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100ef0:	55                   	push   %ebp
80100ef1:	89 e5                	mov    %esp,%ebp
80100ef3:	53                   	push   %ebx
80100ef4:	83 ec 14             	sub    $0x14,%esp
80100ef7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100efa:	83 3b 02             	cmpl   $0x2,(%ebx)
80100efd:	75 31                	jne    80100f30 <filestat+0x40>
    ilock(f->ip);
80100eff:	8b 43 10             	mov    0x10(%ebx),%eax
80100f02:	89 04 24             	mov    %eax,(%esp)
80100f05:	e8 b6 07 00 00       	call   801016c0 <ilock>
    stati(f->ip, st);
80100f0a:	8b 45 0c             	mov    0xc(%ebp),%eax
80100f0d:	89 44 24 04          	mov    %eax,0x4(%esp)
80100f11:	8b 43 10             	mov    0x10(%ebx),%eax
80100f14:	89 04 24             	mov    %eax,(%esp)
80100f17:	e8 24 0a 00 00       	call   80101940 <stati>
    iunlock(f->ip);
80100f1c:	8b 43 10             	mov    0x10(%ebx),%eax
80100f1f:	89 04 24             	mov    %eax,(%esp)
80100f22:	e8 79 08 00 00       	call   801017a0 <iunlock>
    return 0;
  }
  return -1;
}
80100f27:	83 c4 14             	add    $0x14,%esp
{
  if(f->type == FD_INODE){
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
80100f2a:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f2c:	5b                   	pop    %ebx
80100f2d:	5d                   	pop    %ebp
80100f2e:	c3                   	ret    
80100f2f:	90                   	nop
80100f30:	83 c4 14             	add    $0x14,%esp
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f33:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f38:	5b                   	pop    %ebx
80100f39:	5d                   	pop    %ebp
80100f3a:	c3                   	ret    
80100f3b:	90                   	nop
80100f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f40 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f40:	55                   	push   %ebp
80100f41:	89 e5                	mov    %esp,%ebp
80100f43:	57                   	push   %edi
80100f44:	56                   	push   %esi
80100f45:	53                   	push   %ebx
80100f46:	83 ec 1c             	sub    $0x1c,%esp
80100f49:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f4c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f4f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f52:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f56:	74 68                	je     80100fc0 <fileread+0x80>
    return -1;
  if(f->type == FD_PIPE)
80100f58:	8b 03                	mov    (%ebx),%eax
80100f5a:	83 f8 01             	cmp    $0x1,%eax
80100f5d:	74 49                	je     80100fa8 <fileread+0x68>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f5f:	83 f8 02             	cmp    $0x2,%eax
80100f62:	75 63                	jne    80100fc7 <fileread+0x87>
    ilock(f->ip);
80100f64:	8b 43 10             	mov    0x10(%ebx),%eax
80100f67:	89 04 24             	mov    %eax,(%esp)
80100f6a:	e8 51 07 00 00       	call   801016c0 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f6f:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80100f73:	8b 43 14             	mov    0x14(%ebx),%eax
80100f76:	89 74 24 04          	mov    %esi,0x4(%esp)
80100f7a:	89 44 24 08          	mov    %eax,0x8(%esp)
80100f7e:	8b 43 10             	mov    0x10(%ebx),%eax
80100f81:	89 04 24             	mov    %eax,(%esp)
80100f84:	e8 e7 09 00 00       	call   80101970 <readi>
80100f89:	85 c0                	test   %eax,%eax
80100f8b:	89 c6                	mov    %eax,%esi
80100f8d:	7e 03                	jle    80100f92 <fileread+0x52>
      f->off += r;
80100f8f:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f92:	8b 43 10             	mov    0x10(%ebx),%eax
80100f95:	89 04 24             	mov    %eax,(%esp)
80100f98:	e8 03 08 00 00       	call   801017a0 <iunlock>
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f9d:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100f9f:	83 c4 1c             	add    $0x1c,%esp
80100fa2:	5b                   	pop    %ebx
80100fa3:	5e                   	pop    %esi
80100fa4:	5f                   	pop    %edi
80100fa5:	5d                   	pop    %ebp
80100fa6:	c3                   	ret    
80100fa7:	90                   	nop
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fa8:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fab:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fae:	83 c4 1c             	add    $0x1c,%esp
80100fb1:	5b                   	pop    %ebx
80100fb2:	5e                   	pop    %esi
80100fb3:	5f                   	pop    %edi
80100fb4:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb5:	e9 36 24 00 00       	jmp    801033f0 <piperead>
80100fba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fc5:	eb d8                	jmp    80100f9f <fileread+0x5f>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fc7:	c7 04 24 06 71 10 80 	movl   $0x80107106,(%esp)
80100fce:	e8 8d f3 ff ff       	call   80100360 <panic>
80100fd3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80100fd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 2c             	sub    $0x2c,%esp
80100fe9:	8b 45 0c             	mov    0xc(%ebp),%eax
80100fec:	8b 7d 08             	mov    0x8(%ebp),%edi
80100fef:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff2:	8b 45 10             	mov    0x10(%ebp),%eax
  int r;

  if(f->writable == 0)
80100ff5:	80 7f 09 00          	cmpb   $0x0,0x9(%edi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 ae 00 00 00    	je     801010b0 <filewrite+0xd0>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 07                	mov    (%edi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d7 00 00 00    	jne    801010ed <filewrite+0x10d>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 db                	xor    %ebx,%ebx
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 31                	jg     80101050 <filewrite+0x70>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
      iunlock(f->ip);
80101028:	8b 4f 10             	mov    0x10(%edi),%ecx
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
8010102b:	01 47 14             	add    %eax,0x14(%edi)
8010102e:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101031:	89 0c 24             	mov    %ecx,(%esp)
80101034:	e8 67 07 00 00       	call   801017a0 <iunlock>
      end_op();
80101039:	e8 52 1b 00 00       	call   80102b90 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax

      if(r < 0)
        break;
      if(r != n1)
80101041:	39 f0                	cmp    %esi,%eax
80101043:	0f 85 98 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
80101049:	01 c3                	add    %eax,%ebx
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104b:	39 5d e4             	cmp    %ebx,-0x1c(%ebp)
8010104e:	7e 70                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101050:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101053:	b8 00 06 00 00       	mov    $0x600,%eax
80101058:	29 de                	sub    %ebx,%esi
8010105a:	81 fe 00 06 00 00    	cmp    $0x600,%esi
80101060:	0f 4f f0             	cmovg  %eax,%esi
      if(n1 > max)
        n1 = max;

      begin_op();
80101063:	e8 b8 1a 00 00       	call   80102b20 <begin_op>
      ilock(f->ip);
80101068:	8b 47 10             	mov    0x10(%edi),%eax
8010106b:	89 04 24             	mov    %eax,(%esp)
8010106e:	e8 4d 06 00 00       	call   801016c0 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101073:	89 74 24 0c          	mov    %esi,0xc(%esp)
80101077:	8b 47 14             	mov    0x14(%edi),%eax
8010107a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010107e:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101081:	01 d8                	add    %ebx,%eax
80101083:	89 44 24 04          	mov    %eax,0x4(%esp)
80101087:	8b 47 10             	mov    0x10(%edi),%eax
8010108a:	89 04 24             	mov    %eax,(%esp)
8010108d:	e8 de 09 00 00       	call   80101a70 <writei>
80101092:	85 c0                	test   %eax,%eax
80101094:	7f 92                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
80101096:	8b 4f 10             	mov    0x10(%edi),%ecx
80101099:	89 45 e0             	mov    %eax,-0x20(%ebp)
8010109c:	89 0c 24             	mov    %ecx,(%esp)
8010109f:	e8 fc 06 00 00       	call   801017a0 <iunlock>
      end_op();
801010a4:	e8 e7 1a 00 00       	call   80102b90 <end_op>

      if(r < 0)
801010a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010ac:	85 c0                	test   %eax,%eax
801010ae:	74 91                	je     80101041 <filewrite+0x61>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b0:	83 c4 2c             	add    $0x2c,%esp
filewrite(struct file *f, char *addr, int n)
{
  int r;

  if(f->writable == 0)
    return -1;
801010b3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010b8:	5b                   	pop    %ebx
801010b9:	5e                   	pop    %esi
801010ba:	5f                   	pop    %edi
801010bb:	5d                   	pop    %ebp
801010bc:	c3                   	ret    
801010bd:	8d 76 00             	lea    0x0(%esi),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
801010c3:	89 d8                	mov    %ebx,%eax
801010c5:	75 e9                	jne    801010b0 <filewrite+0xd0>
  }
  panic("filewrite");
}
801010c7:	83 c4 2c             	add    $0x2c,%esp
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 47 0c             	mov    0xc(%edi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	83 c4 2c             	add    $0x2c,%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 1f 22 00 00       	jmp    80103300 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	c7 04 24 0f 71 10 80 	movl   $0x8010710f,(%esp)
801010e8:	e8 73 f2 ff ff       	call   80100360 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ed:	c7 04 24 15 71 10 80 	movl   $0x80107115,(%esp)
801010f4:	e8 67 f2 ff ff       	call   80100360 <panic>
801010f9:	66 90                	xchg   %ax,%ax
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 2c             	sub    $0x2c,%esp
80101109:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010110c:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101111:	85 c0                	test   %eax,%eax
80101113:	0f 84 8c 00 00 00    	je     801011a5 <balloc+0xa5>
80101119:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101120:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101123:	89 f0                	mov    %esi,%eax
80101125:	c1 f8 0c             	sar    $0xc,%eax
80101128:	03 05 d8 09 11 80    	add    0x801109d8,%eax
8010112e:	89 44 24 04          	mov    %eax,0x4(%esp)
80101132:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101135:	89 04 24             	mov    %eax,(%esp)
80101138:	e8 93 ef ff ff       	call   801000d0 <bread>
8010113d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101140:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101145:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101148:	31 c0                	xor    %eax,%eax
8010114a:	eb 33                	jmp    8010117f <balloc+0x7f>
8010114c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101150:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101153:	89 c2                	mov    %eax,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101155:	89 c1                	mov    %eax,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	c1 fa 03             	sar    $0x3,%edx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	bf 01 00 00 00       	mov    $0x1,%edi
80101162:	d3 e7                	shl    %cl,%edi
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101164:	0f b6 5c 13 5c       	movzbl 0x5c(%ebx,%edx,1),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
80101169:	89 f9                	mov    %edi,%ecx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010116b:	0f b6 fb             	movzbl %bl,%edi
8010116e:	85 cf                	test   %ecx,%edi
80101170:	74 46                	je     801011b8 <balloc+0xb8>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101172:	83 c0 01             	add    $0x1,%eax
80101175:	83 c6 01             	add    $0x1,%esi
80101178:	3d 00 10 00 00       	cmp    $0x1000,%eax
8010117d:	74 05                	je     80101184 <balloc+0x84>
8010117f:	3b 75 e0             	cmp    -0x20(%ebp),%esi
80101182:	72 cc                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
80101184:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101187:	89 04 24             	mov    %eax,(%esp)
8010118a:	e8 51 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118f:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101196:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101199:	3b 05 c0 09 11 80    	cmp    0x801109c0,%eax
8010119f:	0f 82 7b ff ff ff    	jb     80101120 <balloc+0x20>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
801011a5:	c7 04 24 1f 71 10 80 	movl   $0x8010711f,(%esp)
801011ac:	e8 af f1 ff ff       	call   80100360 <panic>
801011b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	09 d9                	or     %ebx,%ecx
801011ba:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801011bd:	88 4c 13 5c          	mov    %cl,0x5c(%ebx,%edx,1)
        log_write(bp);
801011c1:	89 1c 24             	mov    %ebx,(%esp)
801011c4:	e8 f7 1a 00 00       	call   80102cc0 <log_write>
        brelse(bp);
801011c9:	89 1c 24             	mov    %ebx,(%esp)
801011cc:	e8 0f f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
801011d4:	89 74 24 04          	mov    %esi,0x4(%esp)
801011d8:	89 04 24             	mov    %eax,(%esp)
801011db:	e8 f0 ee ff ff       	call   801000d0 <bread>
  memset(bp->data, 0, BSIZE);
801011e0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801011e7:	00 
801011e8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801011ef:	00 
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011f0:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011f2:	8d 40 5c             	lea    0x5c(%eax),%eax
801011f5:	89 04 24             	mov    %eax,(%esp)
801011f8:	e8 f3 30 00 00       	call   801042f0 <memset>
  log_write(bp);
801011fd:	89 1c 24             	mov    %ebx,(%esp)
80101200:	e8 bb 1a 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101205:	89 1c 24             	mov    %ebx,(%esp)
80101208:	e8 d3 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
8010120d:	83 c4 2c             	add    $0x2c,%esp
80101210:	89 f0                	mov    %esi,%eax
80101212:	5b                   	pop    %ebx
80101213:	5e                   	pop    %esi
80101214:	5f                   	pop    %edi
80101215:	5d                   	pop    %ebp
80101216:	c3                   	ret    
80101217:	89 f6                	mov    %esi,%esi
80101219:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101220 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101220:	55                   	push   %ebp
80101221:	89 e5                	mov    %esp,%ebp
80101223:	57                   	push   %edi
80101224:	89 c7                	mov    %eax,%edi
80101226:	56                   	push   %esi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101227:	31 f6                	xor    %esi,%esi
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101229:	53                   	push   %ebx

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010122a:	bb 14 0a 11 80       	mov    $0x80110a14,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010122f:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101232:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101239:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
8010123c:	e8 ef 2f 00 00       	call   80104230 <acquire>

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101241:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101244:	eb 14                	jmp    8010125a <iget+0x3a>
80101246:	66 90                	xchg   %ax,%ax
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101248:	85 f6                	test   %esi,%esi
8010124a:	74 3c                	je     80101288 <iget+0x68>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010124c:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101252:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101258:	74 46                	je     801012a0 <iget+0x80>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
8010125a:	8b 4b 08             	mov    0x8(%ebx),%ecx
8010125d:	85 c9                	test   %ecx,%ecx
8010125f:	7e e7                	jle    80101248 <iget+0x28>
80101261:	39 3b                	cmp    %edi,(%ebx)
80101263:	75 e3                	jne    80101248 <iget+0x28>
80101265:	39 53 04             	cmp    %edx,0x4(%ebx)
80101268:	75 de                	jne    80101248 <iget+0x28>
      ip->ref++;
8010126a:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
8010126d:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101276:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101279:	e8 22 30 00 00       	call   801042a0 <release>
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127e:	83 c4 1c             	add    $0x1c,%esp
80101281:	89 f0                	mov    %esi,%eax
80101283:	5b                   	pop    %ebx
80101284:	5e                   	pop    %esi
80101285:	5f                   	pop    %edi
80101286:	5d                   	pop    %ebp
80101287:	c3                   	ret    
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 34 26 11 80    	cmp    $0x80112634,%ebx
80101299:	75 bf                	jne    8010125a <iget+0x3a>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 29                	je     801012cd <iget+0xad>
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a4:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a6:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012a9:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b0:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012b7:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801012be:	e8 dd 2f 00 00       	call   801042a0 <release>

  return ip;
}
801012c3:	83 c4 1c             	add    $0x1c,%esp
801012c6:	89 f0                	mov    %esi,%eax
801012c8:	5b                   	pop    %ebx
801012c9:	5e                   	pop    %esi
801012ca:	5f                   	pop    %edi
801012cb:	5d                   	pop    %ebp
801012cc:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012cd:	c7 04 24 35 71 10 80 	movl   $0x80107135,(%esp)
801012d4:	e8 87 f0 ff ff       	call   80100360 <panic>
801012d9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c3                	mov    %eax,%ebx
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 34 90             	lea    (%eax,%edx,4),%esi
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 46 5c             	mov    0x5c(%esi),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 66                	je     80101360 <bmap+0x80>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	83 c4 1c             	add    $0x1c,%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 72 f4             	lea    -0xc(%edx),%esi

  if(bn < NINDIRECT){
8010130b:	83 fe 7f             	cmp    $0x7f,%esi
8010130e:	77 77                	ja     80101387 <bmap+0xa7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101310:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
80101316:	85 c0                	test   %eax,%eax
80101318:	74 5e                	je     80101378 <bmap+0x98>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010131e:	8b 03                	mov    (%ebx),%eax
80101320:	89 04 24             	mov    %eax,(%esp)
80101323:	e8 a8 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101328:	8d 54 b0 5c          	lea    0x5c(%eax,%esi,4),%edx

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010132c:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
8010132e:	8b 32                	mov    (%edx),%esi
80101330:	85 f6                	test   %esi,%esi
80101332:	75 19                	jne    8010134d <bmap+0x6d>
      a[bn] = addr = balloc(ip->dev);
80101334:	8b 03                	mov    (%ebx),%eax
80101336:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101339:	e8 c2 fd ff ff       	call   80101100 <balloc>
8010133e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101341:	89 02                	mov    %eax,(%edx)
80101343:	89 c6                	mov    %eax,%esi
      log_write(bp);
80101345:	89 3c 24             	mov    %edi,(%esp)
80101348:	e8 73 19 00 00       	call   80102cc0 <log_write>
    }
    brelse(bp);
8010134d:	89 3c 24             	mov    %edi,(%esp)
80101350:	e8 8b ee ff ff       	call   801001e0 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
80101355:	83 c4 1c             	add    $0x1c,%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101358:	89 f0                	mov    %esi,%eax
    return addr;
  }

  panic("bmap: out of range");
}
8010135a:	5b                   	pop    %ebx
8010135b:	5e                   	pop    %esi
8010135c:	5f                   	pop    %edi
8010135d:	5d                   	pop    %ebp
8010135e:	c3                   	ret    
8010135f:	90                   	nop
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101360:	8b 03                	mov    (%ebx),%eax
80101362:	e8 99 fd ff ff       	call   80101100 <balloc>
80101367:	89 46 5c             	mov    %eax,0x5c(%esi)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010136a:	83 c4 1c             	add    $0x1c,%esp
8010136d:	5b                   	pop    %ebx
8010136e:	5e                   	pop    %esi
8010136f:	5f                   	pop    %edi
80101370:	5d                   	pop    %ebp
80101371:	c3                   	ret    
80101372:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101378:	8b 03                	mov    (%ebx),%eax
8010137a:	e8 81 fd ff ff       	call   80101100 <balloc>
8010137f:	89 83 8c 00 00 00    	mov    %eax,0x8c(%ebx)
80101385:	eb 93                	jmp    8010131a <bmap+0x3a>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101387:	c7 04 24 45 71 10 80 	movl   $0x80107145,(%esp)
8010138e:	e8 cd ef ff ff       	call   80100360 <panic>
80101393:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101399:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013a0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013a0:	55                   	push   %ebp
801013a1:	89 e5                	mov    %esp,%ebp
801013a3:	56                   	push   %esi
801013a4:	53                   	push   %ebx
801013a5:	83 ec 10             	sub    $0x10,%esp
  struct buf *bp;

  bp = bread(dev, 1);
801013a8:	8b 45 08             	mov    0x8(%ebp),%eax
801013ab:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
801013b2:	00 
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b3:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b6:	89 04 24             	mov    %eax,(%esp)
801013b9:	e8 12 ed ff ff       	call   801000d0 <bread>
  memmove(sb, bp->data, sizeof(*sb));
801013be:	89 34 24             	mov    %esi,(%esp)
801013c1:	c7 44 24 08 1c 00 00 	movl   $0x1c,0x8(%esp)
801013c8:	00 
void
readsb(int dev, struct superblock *sb)
{
  struct buf *bp;

  bp = bread(dev, 1);
801013c9:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013cb:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ce:	89 44 24 04          	mov    %eax,0x4(%esp)
801013d2:	e8 b9 2f 00 00       	call   80104390 <memmove>
  brelse(bp);
801013d7:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801013da:	83 c4 10             	add    $0x10,%esp
801013dd:	5b                   	pop    %ebx
801013de:	5e                   	pop    %esi
801013df:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e0:	e9 fb ed ff ff       	jmp    801001e0 <brelse>
801013e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	57                   	push   %edi
801013f4:	89 d7                	mov    %edx,%edi
801013f6:	56                   	push   %esi
801013f7:	53                   	push   %ebx
801013f8:	89 c3                	mov    %eax,%ebx
801013fa:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013fd:	89 04 24             	mov    %eax,(%esp)
80101400:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
80101407:	80 
80101408:	e8 93 ff ff ff       	call   801013a0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
8010140d:	89 fa                	mov    %edi,%edx
8010140f:	c1 ea 0c             	shr    $0xc,%edx
80101412:	03 15 d8 09 11 80    	add    0x801109d8,%edx
80101418:	89 1c 24             	mov    %ebx,(%esp)
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	bb 01 00 00 00       	mov    $0x1,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
80101420:	89 54 24 04          	mov    %edx,0x4(%esp)
80101424:	e8 a7 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
80101429:	89 f9                	mov    %edi,%ecx
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
8010142b:	81 e7 ff 0f 00 00    	and    $0xfff,%edi
80101431:	89 fa                	mov    %edi,%edx
  m = 1 << (bi % 8);
80101433:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
80101436:	c1 fa 03             	sar    $0x3,%edx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101439:	d3 e3                	shl    %cl,%ebx
{
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
8010143b:	89 c6                	mov    %eax,%esi
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
8010143d:	0f b6 44 10 5c       	movzbl 0x5c(%eax,%edx,1),%eax
80101442:	0f b6 c8             	movzbl %al,%ecx
80101445:	85 d9                	test   %ebx,%ecx
80101447:	74 20                	je     80101469 <bfree+0x79>
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101449:	f7 d3                	not    %ebx
8010144b:	21 c3                	and    %eax,%ebx
8010144d:	88 5c 16 5c          	mov    %bl,0x5c(%esi,%edx,1)
  log_write(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 67 18 00 00       	call   80102cc0 <log_write>
  brelse(bp);
80101459:	89 34 24             	mov    %esi,(%esp)
8010145c:	e8 7f ed ff ff       	call   801001e0 <brelse>
}
80101461:	83 c4 1c             	add    $0x1c,%esp
80101464:	5b                   	pop    %ebx
80101465:	5e                   	pop    %esi
80101466:	5f                   	pop    %edi
80101467:	5d                   	pop    %ebp
80101468:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101469:	c7 04 24 58 71 10 80 	movl   $0x80107158,(%esp)
80101470:	e8 eb ee ff ff       	call   80100360 <panic>
80101475:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101479:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101480 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101480:	55                   	push   %ebp
80101481:	89 e5                	mov    %esp,%ebp
80101483:	53                   	push   %ebx
80101484:	bb 20 0a 11 80       	mov    $0x80110a20,%ebx
80101489:	83 ec 24             	sub    $0x24,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010148c:	c7 44 24 04 6b 71 10 	movl   $0x8010716b,0x4(%esp)
80101493:	80 
80101494:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
8010149b:	e8 20 2c 00 00       	call   801040c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
801014a0:	89 1c 24             	mov    %ebx,(%esp)
801014a3:	81 c3 90 00 00 00    	add    $0x90,%ebx
801014a9:	c7 44 24 04 72 71 10 	movl   $0x80107172,0x4(%esp)
801014b0:	80 
801014b1:	e8 da 2a 00 00       	call   80103f90 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014b6:	81 fb 40 26 11 80    	cmp    $0x80112640,%ebx
801014bc:	75 e2                	jne    801014a0 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014be:	8b 45 08             	mov    0x8(%ebp),%eax
801014c1:	c7 44 24 04 c0 09 11 	movl   $0x801109c0,0x4(%esp)
801014c8:	80 
801014c9:	89 04 24             	mov    %eax,(%esp)
801014cc:	e8 cf fe ff ff       	call   801013a0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014d1:	a1 d8 09 11 80       	mov    0x801109d8,%eax
801014d6:	c7 04 24 d8 71 10 80 	movl   $0x801071d8,(%esp)
801014dd:	89 44 24 1c          	mov    %eax,0x1c(%esp)
801014e1:	a1 d4 09 11 80       	mov    0x801109d4,%eax
801014e6:	89 44 24 18          	mov    %eax,0x18(%esp)
801014ea:	a1 d0 09 11 80       	mov    0x801109d0,%eax
801014ef:	89 44 24 14          	mov    %eax,0x14(%esp)
801014f3:	a1 cc 09 11 80       	mov    0x801109cc,%eax
801014f8:	89 44 24 10          	mov    %eax,0x10(%esp)
801014fc:	a1 c8 09 11 80       	mov    0x801109c8,%eax
80101501:	89 44 24 0c          	mov    %eax,0xc(%esp)
80101505:	a1 c4 09 11 80       	mov    0x801109c4,%eax
8010150a:	89 44 24 08          	mov    %eax,0x8(%esp)
8010150e:	a1 c0 09 11 80       	mov    0x801109c0,%eax
80101513:	89 44 24 04          	mov    %eax,0x4(%esp)
80101517:	e8 34 f1 ff ff       	call   80100650 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
8010151c:	83 c4 24             	add    $0x24,%esp
8010151f:	5b                   	pop    %ebx
80101520:	5d                   	pop    %ebp
80101521:	c3                   	ret    
80101522:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101530 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101530:	55                   	push   %ebp
80101531:	89 e5                	mov    %esp,%ebp
80101533:	57                   	push   %edi
80101534:	56                   	push   %esi
80101535:	53                   	push   %ebx
80101536:	83 ec 2c             	sub    $0x2c,%esp
80101539:	8b 45 0c             	mov    0xc(%ebp),%eax
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 3d c8 09 11 80 01 	cmpl   $0x1,0x801109c8
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101543:	8b 7d 08             	mov    0x8(%ebp),%edi
80101546:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101549:	0f 86 a2 00 00 00    	jbe    801015f1 <ialloc+0xc1>
8010154f:	be 01 00 00 00       	mov    $0x1,%esi
80101554:	bb 01 00 00 00       	mov    $0x1,%ebx
80101559:	eb 1a                	jmp    80101575 <ialloc+0x45>
8010155b:	90                   	nop
8010155c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101560:	89 14 24             	mov    %edx,(%esp)
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101563:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101566:	e8 75 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010156b:	89 de                	mov    %ebx,%esi
8010156d:	3b 1d c8 09 11 80    	cmp    0x801109c8,%ebx
80101573:	73 7c                	jae    801015f1 <ialloc+0xc1>
    bp = bread(dev, IBLOCK(inum, sb));
80101575:	89 f0                	mov    %esi,%eax
80101577:	c1 e8 03             	shr    $0x3,%eax
8010157a:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101580:	89 3c 24             	mov    %edi,(%esp)
80101583:	89 44 24 04          	mov    %eax,0x4(%esp)
80101587:	e8 44 eb ff ff       	call   801000d0 <bread>
8010158c:	89 c2                	mov    %eax,%edx
    dip = (struct dinode*)bp->data + inum%IPB;
8010158e:	89 f0                	mov    %esi,%eax
80101590:	83 e0 07             	and    $0x7,%eax
80101593:	c1 e0 06             	shl    $0x6,%eax
80101596:	8d 4c 02 5c          	lea    0x5c(%edx,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010159a:	66 83 39 00          	cmpw   $0x0,(%ecx)
8010159e:	75 c0                	jne    80101560 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
801015a0:	89 0c 24             	mov    %ecx,(%esp)
801015a3:	c7 44 24 08 40 00 00 	movl   $0x40,0x8(%esp)
801015aa:	00 
801015ab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
801015b2:	00 
801015b3:	89 55 dc             	mov    %edx,-0x24(%ebp)
801015b6:	89 4d e0             	mov    %ecx,-0x20(%ebp)
801015b9:	e8 32 2d 00 00       	call   801042f0 <memset>
      dip->type = type;
801015be:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
      log_write(bp);   // mark it allocated on the disk
801015c2:	8b 55 dc             	mov    -0x24(%ebp),%edx
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015c5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
      log_write(bp);   // mark it allocated on the disk
801015c8:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
801015cb:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
801015ce:	89 14 24             	mov    %edx,(%esp)
801015d1:	e8 ea 16 00 00       	call   80102cc0 <log_write>
      brelse(bp);
801015d6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801015d9:	89 14 24             	mov    %edx,(%esp)
801015dc:	e8 ff eb ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e1:	83 c4 2c             	add    $0x2c,%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e4:	89 f2                	mov    %esi,%edx
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e6:	5b                   	pop    %ebx
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015e7:	89 f8                	mov    %edi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015e9:	5e                   	pop    %esi
801015ea:	5f                   	pop    %edi
801015eb:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ec:	e9 2f fc ff ff       	jmp    80101220 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015f1:	c7 04 24 78 71 10 80 	movl   $0x80107178,(%esp)
801015f8:	e8 63 ed ff ff       	call   80100360 <panic>
801015fd:	8d 76 00             	lea    0x0(%esi),%esi

80101600 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
80101600:	55                   	push   %ebp
80101601:	89 e5                	mov    %esp,%ebp
80101603:	56                   	push   %esi
80101604:	53                   	push   %ebx
80101605:	83 ec 10             	sub    $0x10,%esp
80101608:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010160b:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010160e:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101611:	c1 e8 03             	shr    $0x3,%eax
80101614:	03 05 d4 09 11 80    	add    0x801109d4,%eax
8010161a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010161e:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80101621:	89 04 24             	mov    %eax,(%esp)
80101624:	e8 a7 ea ff ff       	call   801000d0 <bread>
  dip = (struct dinode*)bp->data + ip->inum%IPB;
80101629:	8b 53 a8             	mov    -0x58(%ebx),%edx
8010162c:	83 e2 07             	and    $0x7,%edx
8010162f:	c1 e2 06             	shl    $0x6,%edx
80101632:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
80101636:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
80101638:	0f b7 43 f4          	movzwl -0xc(%ebx),%eax
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010163c:	83 c2 0c             	add    $0xc,%edx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
8010163f:	66 89 42 f4          	mov    %ax,-0xc(%edx)
  dip->major = ip->major;
80101643:	0f b7 43 f6          	movzwl -0xa(%ebx),%eax
80101647:	66 89 42 f6          	mov    %ax,-0xa(%edx)
  dip->minor = ip->minor;
8010164b:	0f b7 43 f8          	movzwl -0x8(%ebx),%eax
8010164f:	66 89 42 f8          	mov    %ax,-0x8(%edx)
  dip->nlink = ip->nlink;
80101653:	0f b7 43 fa          	movzwl -0x6(%ebx),%eax
80101657:	66 89 42 fa          	mov    %ax,-0x6(%edx)
  dip->size = ip->size;
8010165b:	8b 43 fc             	mov    -0x4(%ebx),%eax
8010165e:	89 42 fc             	mov    %eax,-0x4(%edx)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101661:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101665:	89 14 24             	mov    %edx,(%esp)
80101668:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
8010166f:	00 
80101670:	e8 1b 2d 00 00       	call   80104390 <memmove>
  log_write(bp);
80101675:	89 34 24             	mov    %esi,(%esp)
80101678:	e8 43 16 00 00       	call   80102cc0 <log_write>
  brelse(bp);
8010167d:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101680:	83 c4 10             	add    $0x10,%esp
80101683:	5b                   	pop    %ebx
80101684:	5e                   	pop    %esi
80101685:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
80101686:	e9 55 eb ff ff       	jmp    801001e0 <brelse>
8010168b:	90                   	nop
8010168c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101690 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101690:	55                   	push   %ebp
80101691:	89 e5                	mov    %esp,%ebp
80101693:	53                   	push   %ebx
80101694:	83 ec 14             	sub    $0x14,%esp
80101697:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010169a:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016a1:	e8 8a 2b 00 00       	call   80104230 <acquire>
  ip->ref++;
801016a6:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
801016aa:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
801016b1:	e8 ea 2b 00 00       	call   801042a0 <release>
  return ip;
}
801016b6:	83 c4 14             	add    $0x14,%esp
801016b9:	89 d8                	mov    %ebx,%eax
801016bb:	5b                   	pop    %ebx
801016bc:	5d                   	pop    %ebp
801016bd:	c3                   	ret    
801016be:	66 90                	xchg   %ax,%ax

801016c0 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
801016c0:	55                   	push   %ebp
801016c1:	89 e5                	mov    %esp,%ebp
801016c3:	56                   	push   %esi
801016c4:	53                   	push   %ebx
801016c5:	83 ec 10             	sub    $0x10,%esp
801016c8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
801016cb:	85 db                	test   %ebx,%ebx
801016cd:	0f 84 b3 00 00 00    	je     80101786 <ilock+0xc6>
801016d3:	8b 53 08             	mov    0x8(%ebx),%edx
801016d6:	85 d2                	test   %edx,%edx
801016d8:	0f 8e a8 00 00 00    	jle    80101786 <ilock+0xc6>
    panic("ilock");

  acquiresleep(&ip->lock);
801016de:	8d 43 0c             	lea    0xc(%ebx),%eax
801016e1:	89 04 24             	mov    %eax,(%esp)
801016e4:	e8 e7 28 00 00       	call   80103fd0 <acquiresleep>

  if(ip->valid == 0){
801016e9:	8b 43 4c             	mov    0x4c(%ebx),%eax
801016ec:	85 c0                	test   %eax,%eax
801016ee:	74 08                	je     801016f8 <ilock+0x38>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016f0:	83 c4 10             	add    $0x10,%esp
801016f3:	5b                   	pop    %ebx
801016f4:	5e                   	pop    %esi
801016f5:	5d                   	pop    %ebp
801016f6:	c3                   	ret    
801016f7:	90                   	nop
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016f8:	8b 43 04             	mov    0x4(%ebx),%eax
801016fb:	c1 e8 03             	shr    $0x3,%eax
801016fe:	03 05 d4 09 11 80    	add    0x801109d4,%eax
80101704:	89 44 24 04          	mov    %eax,0x4(%esp)
80101708:	8b 03                	mov    (%ebx),%eax
8010170a:	89 04 24             	mov    %eax,(%esp)
8010170d:	e8 be e9 ff ff       	call   801000d0 <bread>
    dip = (struct dinode*)bp->data + ip->inum%IPB;
80101712:	8b 53 04             	mov    0x4(%ebx),%edx
80101715:	83 e2 07             	and    $0x7,%edx
80101718:	c1 e2 06             	shl    $0x6,%edx
8010171b:	8d 54 10 5c          	lea    0x5c(%eax,%edx,1),%edx
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
8010171f:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101721:	0f b7 02             	movzwl (%edx),%eax
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101724:	83 c2 0c             	add    $0xc,%edx
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
80101727:	66 89 43 50          	mov    %ax,0x50(%ebx)
    ip->major = dip->major;
8010172b:	0f b7 42 f6          	movzwl -0xa(%edx),%eax
8010172f:	66 89 43 52          	mov    %ax,0x52(%ebx)
    ip->minor = dip->minor;
80101733:	0f b7 42 f8          	movzwl -0x8(%edx),%eax
80101737:	66 89 43 54          	mov    %ax,0x54(%ebx)
    ip->nlink = dip->nlink;
8010173b:	0f b7 42 fa          	movzwl -0x6(%edx),%eax
8010173f:	66 89 43 56          	mov    %ax,0x56(%ebx)
    ip->size = dip->size;
80101743:	8b 42 fc             	mov    -0x4(%edx),%eax
80101746:	89 43 58             	mov    %eax,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101749:	8d 43 5c             	lea    0x5c(%ebx),%eax
8010174c:	89 54 24 04          	mov    %edx,0x4(%esp)
80101750:	c7 44 24 08 34 00 00 	movl   $0x34,0x8(%esp)
80101757:	00 
80101758:	89 04 24             	mov    %eax,(%esp)
8010175b:	e8 30 2c 00 00       	call   80104390 <memmove>
    brelse(bp);
80101760:	89 34 24             	mov    %esi,(%esp)
80101763:	e8 78 ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101768:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010176d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101774:	0f 85 76 ff ff ff    	jne    801016f0 <ilock+0x30>
      panic("ilock: no type");
8010177a:	c7 04 24 90 71 10 80 	movl   $0x80107190,(%esp)
80101781:	e8 da eb ff ff       	call   80100360 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101786:	c7 04 24 8a 71 10 80 	movl   $0x8010718a,(%esp)
8010178d:	e8 ce eb ff ff       	call   80100360 <panic>
80101792:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101799:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801017a0 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	56                   	push   %esi
801017a4:	53                   	push   %ebx
801017a5:	83 ec 10             	sub    $0x10,%esp
801017a8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
801017ab:	85 db                	test   %ebx,%ebx
801017ad:	74 24                	je     801017d3 <iunlock+0x33>
801017af:	8d 73 0c             	lea    0xc(%ebx),%esi
801017b2:	89 34 24             	mov    %esi,(%esp)
801017b5:	e8 b6 28 00 00       	call   80104070 <holdingsleep>
801017ba:	85 c0                	test   %eax,%eax
801017bc:	74 15                	je     801017d3 <iunlock+0x33>
801017be:	8b 43 08             	mov    0x8(%ebx),%eax
801017c1:	85 c0                	test   %eax,%eax
801017c3:	7e 0e                	jle    801017d3 <iunlock+0x33>
    panic("iunlock");

  releasesleep(&ip->lock);
801017c5:	89 75 08             	mov    %esi,0x8(%ebp)
}
801017c8:	83 c4 10             	add    $0x10,%esp
801017cb:	5b                   	pop    %ebx
801017cc:	5e                   	pop    %esi
801017cd:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
801017ce:	e9 5d 28 00 00       	jmp    80104030 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
801017d3:	c7 04 24 9f 71 10 80 	movl   $0x8010719f,(%esp)
801017da:	e8 81 eb ff ff       	call   80100360 <panic>
801017df:	90                   	nop

801017e0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017e0:	55                   	push   %ebp
801017e1:	89 e5                	mov    %esp,%ebp
801017e3:	57                   	push   %edi
801017e4:	56                   	push   %esi
801017e5:	53                   	push   %ebx
801017e6:	83 ec 1c             	sub    $0x1c,%esp
801017e9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ec:	8d 7e 0c             	lea    0xc(%esi),%edi
801017ef:	89 3c 24             	mov    %edi,(%esp)
801017f2:	e8 d9 27 00 00       	call   80103fd0 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017f7:	8b 56 4c             	mov    0x4c(%esi),%edx
801017fa:	85 d2                	test   %edx,%edx
801017fc:	74 07                	je     80101805 <iput+0x25>
801017fe:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
80101803:	74 2b                	je     80101830 <iput+0x50>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
80101805:	89 3c 24             	mov    %edi,(%esp)
80101808:	e8 23 28 00 00       	call   80104030 <releasesleep>

  acquire(&icache.lock);
8010180d:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101814:	e8 17 2a 00 00       	call   80104230 <acquire>
  ip->ref--;
80101819:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
8010181d:	c7 45 08 e0 09 11 80 	movl   $0x801109e0,0x8(%ebp)
}
80101824:	83 c4 1c             	add    $0x1c,%esp
80101827:	5b                   	pop    %ebx
80101828:	5e                   	pop    %esi
80101829:	5f                   	pop    %edi
8010182a:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
8010182b:	e9 70 2a 00 00       	jmp    801042a0 <release>
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
80101830:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101837:	e8 f4 29 00 00       	call   80104230 <acquire>
    int r = ip->ref;
8010183c:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
8010183f:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101846:	e8 55 2a 00 00       	call   801042a0 <release>
    if(r == 1){
8010184b:	83 fb 01             	cmp    $0x1,%ebx
8010184e:	75 b5                	jne    80101805 <iput+0x25>
80101850:	8d 4e 30             	lea    0x30(%esi),%ecx
80101853:	89 f3                	mov    %esi,%ebx
80101855:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101858:	89 cf                	mov    %ecx,%edi
8010185a:	eb 0b                	jmp    80101867 <iput+0x87>
8010185c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101860:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101863:	39 fb                	cmp    %edi,%ebx
80101865:	74 19                	je     80101880 <iput+0xa0>
    if(ip->addrs[i]){
80101867:	8b 53 5c             	mov    0x5c(%ebx),%edx
8010186a:	85 d2                	test   %edx,%edx
8010186c:	74 f2                	je     80101860 <iput+0x80>
      bfree(ip->dev, ip->addrs[i]);
8010186e:	8b 06                	mov    (%esi),%eax
80101870:	e8 7b fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101875:	c7 43 5c 00 00 00 00 	movl   $0x0,0x5c(%ebx)
8010187c:	eb e2                	jmp    80101860 <iput+0x80>
8010187e:	66 90                	xchg   %ax,%ax
    }
  }

  if(ip->addrs[NDIRECT]){
80101880:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101886:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101889:	85 c0                	test   %eax,%eax
8010188b:	75 2b                	jne    801018b8 <iput+0xd8>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
8010188d:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101894:	89 34 24             	mov    %esi,(%esp)
80101897:	e8 64 fd ff ff       	call   80101600 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010189c:	31 c0                	xor    %eax,%eax
8010189e:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
801018a2:	89 34 24             	mov    %esi,(%esp)
801018a5:	e8 56 fd ff ff       	call   80101600 <iupdate>
      ip->valid = 0;
801018aa:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
801018b1:	e9 4f ff ff ff       	jmp    80101805 <iput+0x25>
801018b6:	66 90                	xchg   %ax,%ax
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018b8:	89 44 24 04          	mov    %eax,0x4(%esp)
801018bc:	8b 06                	mov    (%esi),%eax
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018be:	31 db                	xor    %ebx,%ebx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018c0:	89 04 24             	mov    %eax,(%esp)
801018c3:	e8 08 e8 ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018c8:	89 7d e0             	mov    %edi,-0x20(%ebp)
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    a = (uint*)bp->data;
801018cb:	8d 48 5c             	lea    0x5c(%eax),%ecx
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
801018ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
    for(j = 0; j < NINDIRECT; j++){
801018d1:	89 cf                	mov    %ecx,%edi
801018d3:	31 c0                	xor    %eax,%eax
801018d5:	eb 0e                	jmp    801018e5 <iput+0x105>
801018d7:	90                   	nop
801018d8:	83 c3 01             	add    $0x1,%ebx
801018db:	81 fb 80 00 00 00    	cmp    $0x80,%ebx
801018e1:	89 d8                	mov    %ebx,%eax
801018e3:	74 10                	je     801018f5 <iput+0x115>
      if(a[j])
801018e5:	8b 14 87             	mov    (%edi,%eax,4),%edx
801018e8:	85 d2                	test   %edx,%edx
801018ea:	74 ec                	je     801018d8 <iput+0xf8>
        bfree(ip->dev, a[j]);
801018ec:	8b 06                	mov    (%esi),%eax
801018ee:	e8 fd fa ff ff       	call   801013f0 <bfree>
801018f3:	eb e3                	jmp    801018d8 <iput+0xf8>
    }
    brelse(bp);
801018f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801018f8:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018fb:	89 04 24             	mov    %eax,(%esp)
801018fe:	e8 dd e8 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
80101903:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
80101909:	8b 06                	mov    (%esi),%eax
8010190b:	e8 e0 fa ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
80101910:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
80101917:	00 00 00 
8010191a:	e9 6e ff ff ff       	jmp    8010188d <iput+0xad>
8010191f:	90                   	nop

80101920 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	53                   	push   %ebx
80101924:	83 ec 14             	sub    $0x14,%esp
80101927:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010192a:	89 1c 24             	mov    %ebx,(%esp)
8010192d:	e8 6e fe ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101932:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80101935:	83 c4 14             	add    $0x14,%esp
80101938:	5b                   	pop    %ebx
80101939:	5d                   	pop    %ebp
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010193a:	e9 a1 fe ff ff       	jmp    801017e0 <iput>
8010193f:	90                   	nop

80101940 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101940:	55                   	push   %ebp
80101941:	89 e5                	mov    %esp,%ebp
80101943:	8b 55 08             	mov    0x8(%ebp),%edx
80101946:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101949:	8b 0a                	mov    (%edx),%ecx
8010194b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010194e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101951:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101954:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101958:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010195b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010195f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101963:	8b 52 58             	mov    0x58(%edx),%edx
80101966:	89 50 10             	mov    %edx,0x10(%eax)
}
80101969:	5d                   	pop    %ebp
8010196a:	c3                   	ret    
8010196b:	90                   	nop
8010196c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101970 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101970:	55                   	push   %ebp
80101971:	89 e5                	mov    %esp,%ebp
80101973:	57                   	push   %edi
80101974:	56                   	push   %esi
80101975:	53                   	push   %ebx
80101976:	83 ec 2c             	sub    $0x2c,%esp
80101979:	8b 45 0c             	mov    0xc(%ebp),%eax
8010197c:	8b 7d 08             	mov    0x8(%ebp),%edi
8010197f:	8b 75 10             	mov    0x10(%ebp),%esi
80101982:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101985:	8b 45 14             	mov    0x14(%ebp),%eax
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101988:	66 83 7f 50 03       	cmpw   $0x3,0x50(%edi)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
8010198d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101990:	0f 84 aa 00 00 00    	je     80101a40 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101996:	8b 47 58             	mov    0x58(%edi),%eax
80101999:	39 f0                	cmp    %esi,%eax
8010199b:	0f 82 c7 00 00 00    	jb     80101a68 <readi+0xf8>
801019a1:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
801019a4:	89 da                	mov    %ebx,%edx
801019a6:	01 f2                	add    %esi,%edx
801019a8:	0f 82 ba 00 00 00    	jb     80101a68 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019ae:	89 c1                	mov    %eax,%ecx
801019b0:	29 f1                	sub    %esi,%ecx
801019b2:	39 d0                	cmp    %edx,%eax
801019b4:	0f 43 cb             	cmovae %ebx,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019b7:	31 c0                	xor    %eax,%eax
801019b9:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019bb:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019be:	74 70                	je     80101a30 <readi+0xc0>
801019c0:	89 7d d8             	mov    %edi,-0x28(%ebp)
801019c3:	89 c7                	mov    %eax,%edi
801019c5:	8d 76 00             	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019c8:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019cb:	89 f2                	mov    %esi,%edx
801019cd:	c1 ea 09             	shr    $0x9,%edx
801019d0:	89 d8                	mov    %ebx,%eax
801019d2:	e8 09 f9 ff ff       	call   801012e0 <bmap>
801019d7:	89 44 24 04          	mov    %eax,0x4(%esp)
801019db:	8b 03                	mov    (%ebx),%eax
    m = min(n - tot, BSIZE - off%BSIZE);
801019dd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019e2:	89 04 24             	mov    %eax,(%esp)
801019e5:	e8 e6 e6 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
801019ea:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801019ed:	29 f9                	sub    %edi,%ecx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ef:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019f1:	89 f0                	mov    %esi,%eax
801019f3:	25 ff 01 00 00       	and    $0x1ff,%eax
801019f8:	29 c3                	sub    %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019fa:	8d 44 02 5c          	lea    0x5c(%edx,%eax,1),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019fe:	39 cb                	cmp    %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a00:	89 44 24 04          	mov    %eax,0x4(%esp)
80101a04:	8b 45 e0             	mov    -0x20(%ebp),%eax
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
80101a07:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
80101a0a:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a0e:	01 df                	add    %ebx,%edi
80101a10:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
80101a12:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101a15:	89 04 24             	mov    %eax,(%esp)
80101a18:	e8 73 29 00 00       	call   80104390 <memmove>
    brelse(bp);
80101a1d:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a20:	89 14 24             	mov    %edx,(%esp)
80101a23:	e8 b8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a28:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a2b:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a2e:	77 98                	ja     801019c8 <readi+0x58>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a33:	83 c4 2c             	add    $0x2c,%esp
80101a36:	5b                   	pop    %ebx
80101a37:	5e                   	pop    %esi
80101a38:	5f                   	pop    %edi
80101a39:	5d                   	pop    %ebp
80101a3a:	c3                   	ret    
80101a3b:	90                   	nop
80101a3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a40:	0f bf 47 52          	movswl 0x52(%edi),%eax
80101a44:	66 83 f8 09          	cmp    $0x9,%ax
80101a48:	77 1e                	ja     80101a68 <readi+0xf8>
80101a4a:	8b 04 c5 60 09 11 80 	mov    -0x7feef6a0(,%eax,8),%eax
80101a51:	85 c0                	test   %eax,%eax
80101a53:	74 13                	je     80101a68 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a55:	8b 75 e4             	mov    -0x1c(%ebp),%esi
80101a58:	89 75 10             	mov    %esi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a5b:	83 c4 2c             	add    $0x2c,%esp
80101a5e:	5b                   	pop    %ebx
80101a5f:	5e                   	pop    %esi
80101a60:	5f                   	pop    %edi
80101a61:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a62:	ff e0                	jmp    *%eax
80101a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a6d:	eb c4                	jmp    80101a33 <readi+0xc3>
80101a6f:	90                   	nop

80101a70 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a70:	55                   	push   %ebp
80101a71:	89 e5                	mov    %esp,%ebp
80101a73:	57                   	push   %edi
80101a74:	56                   	push   %esi
80101a75:	53                   	push   %ebx
80101a76:	83 ec 2c             	sub    $0x2c,%esp
80101a79:	8b 45 08             	mov    0x8(%ebp),%eax
80101a7c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a7f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a82:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a87:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a8a:	8b 75 10             	mov    0x10(%ebp),%esi
80101a8d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a90:	89 4d e0             	mov    %ecx,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a93:	0f 84 b7 00 00 00    	je     80101b50 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a99:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a9c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a9f:	0f 82 e3 00 00 00    	jb     80101b88 <writei+0x118>
80101aa5:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aa8:	89 c8                	mov    %ecx,%eax
80101aaa:	01 f0                	add    %esi,%eax
80101aac:	0f 82 d6 00 00 00    	jb     80101b88 <writei+0x118>
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101ab2:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101ab7:	0f 87 cb 00 00 00    	ja     80101b88 <writei+0x118>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101abd:	85 c9                	test   %ecx,%ecx
80101abf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101ac6:	74 77                	je     80101b3f <writei+0xcf>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ac8:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101acb:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101acd:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ad2:	c1 ea 09             	shr    $0x9,%edx
80101ad5:	89 f8                	mov    %edi,%eax
80101ad7:	e8 04 f8 ff ff       	call   801012e0 <bmap>
80101adc:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ae0:	8b 07                	mov    (%edi),%eax
80101ae2:	89 04 24             	mov    %eax,(%esp)
80101ae5:	e8 e6 e5 ff ff       	call   801000d0 <bread>
    m = min(n - tot, BSIZE - off%BSIZE);
80101aea:	8b 4d e0             	mov    -0x20(%ebp),%ecx
80101aed:	2b 4d e4             	sub    -0x1c(%ebp),%ecx
    memmove(bp->data + off%BSIZE, src, m);
80101af0:	8b 55 dc             	mov    -0x24(%ebp),%edx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101af3:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101af5:	89 f0                	mov    %esi,%eax
80101af7:	25 ff 01 00 00       	and    $0x1ff,%eax
80101afc:	29 c3                	sub    %eax,%ebx
80101afe:	39 cb                	cmp    %ecx,%ebx
80101b00:	0f 47 d9             	cmova  %ecx,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101b03:	8d 44 07 5c          	lea    0x5c(%edi,%eax,1),%eax
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b07:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101b09:	89 54 24 04          	mov    %edx,0x4(%esp)
80101b0d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80101b11:	89 04 24             	mov    %eax,(%esp)
80101b14:	e8 77 28 00 00       	call   80104390 <memmove>
    log_write(bp);
80101b19:	89 3c 24             	mov    %edi,(%esp)
80101b1c:	e8 9f 11 00 00       	call   80102cc0 <log_write>
    brelse(bp);
80101b21:	89 3c 24             	mov    %edi,(%esp)
80101b24:	e8 b7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b29:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b2c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101b2f:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b32:	39 45 e0             	cmp    %eax,-0x20(%ebp)
80101b35:	77 91                	ja     80101ac8 <writei+0x58>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b37:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b3a:	39 70 58             	cmp    %esi,0x58(%eax)
80101b3d:	72 39                	jb     80101b78 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b3f:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b42:	83 c4 2c             	add    $0x2c,%esp
80101b45:	5b                   	pop    %ebx
80101b46:	5e                   	pop    %esi
80101b47:	5f                   	pop    %edi
80101b48:	5d                   	pop    %ebp
80101b49:	c3                   	ret    
80101b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b50:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b54:	66 83 f8 09          	cmp    $0x9,%ax
80101b58:	77 2e                	ja     80101b88 <writei+0x118>
80101b5a:	8b 04 c5 64 09 11 80 	mov    -0x7feef69c(,%eax,8),%eax
80101b61:	85 c0                	test   %eax,%eax
80101b63:	74 23                	je     80101b88 <writei+0x118>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b65:	89 4d 10             	mov    %ecx,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b68:	83 c4 2c             	add    $0x2c,%esp
80101b6b:	5b                   	pop    %ebx
80101b6c:	5e                   	pop    %esi
80101b6d:	5f                   	pop    %edi
80101b6e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b6f:	ff e0                	jmp    *%eax
80101b71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b78:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b7b:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b7e:	89 04 24             	mov    %eax,(%esp)
80101b81:	e8 7a fa ff ff       	call   80101600 <iupdate>
80101b86:	eb b7                	jmp    80101b3f <writei+0xcf>
  }
  return n;
}
80101b88:	83 c4 2c             	add    $0x2c,%esp
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b8b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b90:	5b                   	pop    %ebx
80101b91:	5e                   	pop    %esi
80101b92:	5f                   	pop    %edi
80101b93:	5d                   	pop    %ebp
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	83 ec 18             	sub    $0x18,%esp
  return strncmp(s, t, DIRSIZ);
80101ba6:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ba9:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101bb0:	00 
80101bb1:	89 44 24 04          	mov    %eax,0x4(%esp)
80101bb5:	8b 45 08             	mov    0x8(%ebp),%eax
80101bb8:	89 04 24             	mov    %eax,(%esp)
80101bbb:	e8 50 28 00 00       	call   80104410 <strncmp>
}
80101bc0:	c9                   	leave  
80101bc1:	c3                   	ret    
80101bc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101bc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101bd0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101bd0:	55                   	push   %ebp
80101bd1:	89 e5                	mov    %esp,%ebp
80101bd3:	57                   	push   %edi
80101bd4:	56                   	push   %esi
80101bd5:	53                   	push   %ebx
80101bd6:	83 ec 2c             	sub    $0x2c,%esp
80101bd9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bdc:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101be1:	0f 85 97 00 00 00    	jne    80101c7e <dirlookup+0xae>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101be7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bea:	31 ff                	xor    %edi,%edi
80101bec:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bef:	85 d2                	test   %edx,%edx
80101bf1:	75 0d                	jne    80101c00 <dirlookup+0x30>
80101bf3:	eb 73                	jmp    80101c68 <dirlookup+0x98>
80101bf5:	8d 76 00             	lea    0x0(%esi),%esi
80101bf8:	83 c7 10             	add    $0x10,%edi
80101bfb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bfe:	76 68                	jbe    80101c68 <dirlookup+0x98>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101c00:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101c07:	00 
80101c08:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101c0c:	89 74 24 04          	mov    %esi,0x4(%esp)
80101c10:	89 1c 24             	mov    %ebx,(%esp)
80101c13:	e8 58 fd ff ff       	call   80101970 <readi>
80101c18:	83 f8 10             	cmp    $0x10,%eax
80101c1b:	75 55                	jne    80101c72 <dirlookup+0xa2>
      panic("dirlookup read");
    if(de.inum == 0)
80101c1d:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101c22:	74 d4                	je     80101bf8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101c24:	8d 45 da             	lea    -0x26(%ebp),%eax
80101c27:	89 44 24 04          	mov    %eax,0x4(%esp)
80101c2b:	8b 45 0c             	mov    0xc(%ebp),%eax
80101c2e:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101c35:	00 
80101c36:	89 04 24             	mov    %eax,(%esp)
80101c39:	e8 d2 27 00 00       	call   80104410 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101c3e:	85 c0                	test   %eax,%eax
80101c40:	75 b6                	jne    80101bf8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c42:	8b 45 10             	mov    0x10(%ebp),%eax
80101c45:	85 c0                	test   %eax,%eax
80101c47:	74 05                	je     80101c4e <dirlookup+0x7e>
        *poff = off;
80101c49:	8b 45 10             	mov    0x10(%ebp),%eax
80101c4c:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
80101c4e:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
      return iget(dp->dev, inum);
80101c52:	8b 03                	mov    (%ebx),%eax
80101c54:	e8 c7 f5 ff ff       	call   80101220 <iget>
    }
  }

  return 0;
}
80101c59:	83 c4 2c             	add    $0x2c,%esp
80101c5c:	5b                   	pop    %ebx
80101c5d:	5e                   	pop    %esi
80101c5e:	5f                   	pop    %edi
80101c5f:	5d                   	pop    %ebp
80101c60:	c3                   	ret    
80101c61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101c68:	83 c4 2c             	add    $0x2c,%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c6b:	31 c0                	xor    %eax,%eax
}
80101c6d:	5b                   	pop    %ebx
80101c6e:	5e                   	pop    %esi
80101c6f:	5f                   	pop    %edi
80101c70:	5d                   	pop    %ebp
80101c71:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c72:	c7 04 24 b9 71 10 80 	movl   $0x801071b9,(%esp)
80101c79:	e8 e2 e6 ff ff       	call   80100360 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c7e:	c7 04 24 a7 71 10 80 	movl   $0x801071a7,(%esp)
80101c85:	e8 d6 e6 ff ff       	call   80100360 <panic>
80101c8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80101c90 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c90:	55                   	push   %ebp
80101c91:	89 e5                	mov    %esp,%ebp
80101c93:	57                   	push   %edi
80101c94:	89 cf                	mov    %ecx,%edi
80101c96:	56                   	push   %esi
80101c97:	53                   	push   %ebx
80101c98:	89 c3                	mov    %eax,%ebx
80101c9a:	83 ec 2c             	sub    $0x2c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c9d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101ca0:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101ca3:	0f 84 51 01 00 00    	je     80101dfa <namex+0x16a>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101ca9:	e8 02 1a 00 00       	call   801036b0 <myproc>
80101cae:	8b 70 68             	mov    0x68(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101cb1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cb8:	e8 73 25 00 00       	call   80104230 <acquire>
  ip->ref++;
80101cbd:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101cc1:	c7 04 24 e0 09 11 80 	movl   $0x801109e0,(%esp)
80101cc8:	e8 d3 25 00 00       	call   801042a0 <release>
80101ccd:	eb 04                	jmp    80101cd3 <namex+0x43>
80101ccf:	90                   	nop
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101cd0:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101cd3:	0f b6 03             	movzbl (%ebx),%eax
80101cd6:	3c 2f                	cmp    $0x2f,%al
80101cd8:	74 f6                	je     80101cd0 <namex+0x40>
    path++;
  if(*path == 0)
80101cda:	84 c0                	test   %al,%al
80101cdc:	0f 84 ed 00 00 00    	je     80101dcf <namex+0x13f>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101ce2:	0f b6 03             	movzbl (%ebx),%eax
80101ce5:	89 da                	mov    %ebx,%edx
80101ce7:	84 c0                	test   %al,%al
80101ce9:	0f 84 b1 00 00 00    	je     80101da0 <namex+0x110>
80101cef:	3c 2f                	cmp    $0x2f,%al
80101cf1:	75 0f                	jne    80101d02 <namex+0x72>
80101cf3:	e9 a8 00 00 00       	jmp    80101da0 <namex+0x110>
80101cf8:	3c 2f                	cmp    $0x2f,%al
80101cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101d00:	74 0a                	je     80101d0c <namex+0x7c>
    path++;
80101d02:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d05:	0f b6 02             	movzbl (%edx),%eax
80101d08:	84 c0                	test   %al,%al
80101d0a:	75 ec                	jne    80101cf8 <namex+0x68>
80101d0c:	89 d1                	mov    %edx,%ecx
80101d0e:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101d10:	83 f9 0d             	cmp    $0xd,%ecx
80101d13:	0f 8e 8f 00 00 00    	jle    80101da8 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101d19:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101d1d:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101d24:	00 
80101d25:	89 3c 24             	mov    %edi,(%esp)
80101d28:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101d2b:	e8 60 26 00 00       	call   80104390 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101d30:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101d33:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d35:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101d38:	75 0e                	jne    80101d48 <namex+0xb8>
80101d3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
80101d40:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d43:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d46:	74 f8                	je     80101d40 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d48:	89 34 24             	mov    %esi,(%esp)
80101d4b:	e8 70 f9 ff ff       	call   801016c0 <ilock>
    if(ip->type != T_DIR){
80101d50:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d55:	0f 85 85 00 00 00    	jne    80101de0 <namex+0x150>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d5b:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d5e:	85 d2                	test   %edx,%edx
80101d60:	74 09                	je     80101d6b <namex+0xdb>
80101d62:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d65:	0f 84 a5 00 00 00    	je     80101e10 <namex+0x180>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d6b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101d72:	00 
80101d73:	89 7c 24 04          	mov    %edi,0x4(%esp)
80101d77:	89 34 24             	mov    %esi,(%esp)
80101d7a:	e8 51 fe ff ff       	call   80101bd0 <dirlookup>
80101d7f:	85 c0                	test   %eax,%eax
80101d81:	74 5d                	je     80101de0 <namex+0x150>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d83:	89 34 24             	mov    %esi,(%esp)
80101d86:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d89:	e8 12 fa ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101d8e:	89 34 24             	mov    %esi,(%esp)
80101d91:	e8 4a fa ff ff       	call   801017e0 <iput>
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
    }
    iunlockput(ip);
    ip = next;
80101d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d99:	89 c6                	mov    %eax,%esi
80101d9b:	e9 33 ff ff ff       	jmp    80101cd3 <namex+0x43>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101da0:	31 c9                	xor    %ecx,%ecx
80101da2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101da8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80101dac:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80101db0:	89 3c 24             	mov    %edi,(%esp)
80101db3:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101db6:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101db9:	e8 d2 25 00 00       	call   80104390 <memmove>
    name[len] = 0;
80101dbe:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101dc1:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101dc4:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101dc8:	89 d3                	mov    %edx,%ebx
80101dca:	e9 66 ff ff ff       	jmp    80101d35 <namex+0xa5>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101dcf:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101dd2:	85 c0                	test   %eax,%eax
80101dd4:	75 4c                	jne    80101e22 <namex+0x192>
80101dd6:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101dd8:	83 c4 2c             	add    $0x2c,%esp
80101ddb:	5b                   	pop    %ebx
80101ddc:	5e                   	pop    %esi
80101ddd:	5f                   	pop    %edi
80101dde:	5d                   	pop    %ebp
80101ddf:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101de0:	89 34 24             	mov    %esi,(%esp)
80101de3:	e8 b8 f9 ff ff       	call   801017a0 <iunlock>
  iput(ip);
80101de8:	89 34 24             	mov    %esi,(%esp)
80101deb:	e8 f0 f9 ff ff       	call   801017e0 <iput>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df0:	83 c4 2c             	add    $0x2c,%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101df3:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101df5:	5b                   	pop    %ebx
80101df6:	5e                   	pop    %esi
80101df7:	5f                   	pop    %edi
80101df8:	5d                   	pop    %ebp
80101df9:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dfa:	ba 01 00 00 00       	mov    $0x1,%edx
80101dff:	b8 01 00 00 00       	mov    $0x1,%eax
80101e04:	e8 17 f4 ff ff       	call   80101220 <iget>
80101e09:	89 c6                	mov    %eax,%esi
80101e0b:	e9 c3 fe ff ff       	jmp    80101cd3 <namex+0x43>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101e10:	89 34 24             	mov    %esi,(%esp)
80101e13:	e8 88 f9 ff ff       	call   801017a0 <iunlock>
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e18:	83 c4 2c             	add    $0x2c,%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101e1b:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101e1d:	5b                   	pop    %ebx
80101e1e:	5e                   	pop    %esi
80101e1f:	5f                   	pop    %edi
80101e20:	5d                   	pop    %ebp
80101e21:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101e22:	89 34 24             	mov    %esi,(%esp)
80101e25:	e8 b6 f9 ff ff       	call   801017e0 <iput>
    return 0;
80101e2a:	31 c0                	xor    %eax,%eax
80101e2c:	eb aa                	jmp    80101dd8 <namex+0x148>
80101e2e:	66 90                	xchg   %ax,%ax

80101e30 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e30:	55                   	push   %ebp
80101e31:	89 e5                	mov    %esp,%ebp
80101e33:	57                   	push   %edi
80101e34:	56                   	push   %esi
80101e35:	53                   	push   %ebx
80101e36:	83 ec 2c             	sub    $0x2c,%esp
80101e39:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e3c:	8b 45 0c             	mov    0xc(%ebp),%eax
80101e3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
80101e46:	00 
80101e47:	89 1c 24             	mov    %ebx,(%esp)
80101e4a:	89 44 24 04          	mov    %eax,0x4(%esp)
80101e4e:	e8 7d fd ff ff       	call   80101bd0 <dirlookup>
80101e53:	85 c0                	test   %eax,%eax
80101e55:	0f 85 8b 00 00 00    	jne    80101ee6 <dirlink+0xb6>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e5b:	8b 43 58             	mov    0x58(%ebx),%eax
80101e5e:	31 ff                	xor    %edi,%edi
80101e60:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e63:	85 c0                	test   %eax,%eax
80101e65:	75 13                	jne    80101e7a <dirlink+0x4a>
80101e67:	eb 35                	jmp    80101e9e <dirlink+0x6e>
80101e69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101e70:	8d 57 10             	lea    0x10(%edi),%edx
80101e73:	39 53 58             	cmp    %edx,0x58(%ebx)
80101e76:	89 d7                	mov    %edx,%edi
80101e78:	76 24                	jbe    80101e9e <dirlink+0x6e>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e7a:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101e81:	00 
80101e82:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101e86:	89 74 24 04          	mov    %esi,0x4(%esp)
80101e8a:	89 1c 24             	mov    %ebx,(%esp)
80101e8d:	e8 de fa ff ff       	call   80101970 <readi>
80101e92:	83 f8 10             	cmp    $0x10,%eax
80101e95:	75 5e                	jne    80101ef5 <dirlink+0xc5>
      panic("dirlink read");
    if(de.inum == 0)
80101e97:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e9c:	75 d2                	jne    80101e70 <dirlink+0x40>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e9e:	8b 45 0c             	mov    0xc(%ebp),%eax
80101ea1:	c7 44 24 08 0e 00 00 	movl   $0xe,0x8(%esp)
80101ea8:	00 
80101ea9:	89 44 24 04          	mov    %eax,0x4(%esp)
80101ead:	8d 45 da             	lea    -0x26(%ebp),%eax
80101eb0:	89 04 24             	mov    %eax,(%esp)
80101eb3:	e8 c8 25 00 00       	call   80104480 <strncpy>
  de.inum = inum;
80101eb8:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ebb:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80101ec2:	00 
80101ec3:	89 7c 24 08          	mov    %edi,0x8(%esp)
80101ec7:	89 74 24 04          	mov    %esi,0x4(%esp)
80101ecb:	89 1c 24             	mov    %ebx,(%esp)
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101ece:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101ed2:	e8 99 fb ff ff       	call   80101a70 <writei>
80101ed7:	83 f8 10             	cmp    $0x10,%eax
80101eda:	75 25                	jne    80101f01 <dirlink+0xd1>
    panic("dirlink");

  return 0;
80101edc:	31 c0                	xor    %eax,%eax
}
80101ede:	83 c4 2c             	add    $0x2c,%esp
80101ee1:	5b                   	pop    %ebx
80101ee2:	5e                   	pop    %esi
80101ee3:	5f                   	pop    %edi
80101ee4:	5d                   	pop    %ebp
80101ee5:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101ee6:	89 04 24             	mov    %eax,(%esp)
80101ee9:	e8 f2 f8 ff ff       	call   801017e0 <iput>
    return -1;
80101eee:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101ef3:	eb e9                	jmp    80101ede <dirlink+0xae>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101ef5:	c7 04 24 c8 71 10 80 	movl   $0x801071c8,(%esp)
80101efc:	e8 5f e4 ff ff       	call   80100360 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101f01:	c7 04 24 ca 77 10 80 	movl   $0x801077ca,(%esp)
80101f08:	e8 53 e4 ff ff       	call   80100360 <panic>
80101f0d:	8d 76 00             	lea    0x0(%esi),%esi

80101f10 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101f10:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f11:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101f13:	89 e5                	mov    %esp,%ebp
80101f15:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101f18:	8b 45 08             	mov    0x8(%ebp),%eax
80101f1b:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101f1e:	e8 6d fd ff ff       	call   80101c90 <namex>
}
80101f23:	c9                   	leave  
80101f24:	c3                   	ret    
80101f25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101f30 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101f30:	55                   	push   %ebp
  return namex(path, 1, name);
80101f31:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101f36:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101f38:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101f3b:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101f3e:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101f3f:	e9 4c fd ff ff       	jmp    80101c90 <namex>
80101f44:	66 90                	xchg   %ax,%ax
80101f46:	66 90                	xchg   %ax,%ax
80101f48:	66 90                	xchg   %ax,%ax
80101f4a:	66 90                	xchg   %ax,%ax
80101f4c:	66 90                	xchg   %ax,%ax
80101f4e:	66 90                	xchg   %ax,%ax

80101f50 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f50:	55                   	push   %ebp
80101f51:	89 e5                	mov    %esp,%ebp
80101f53:	56                   	push   %esi
80101f54:	89 c6                	mov    %eax,%esi
80101f56:	53                   	push   %ebx
80101f57:	83 ec 10             	sub    $0x10,%esp
  if(b == 0)
80101f5a:	85 c0                	test   %eax,%eax
80101f5c:	0f 84 99 00 00 00    	je     80101ffb <idestart+0xab>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f62:	8b 48 08             	mov    0x8(%eax),%ecx
80101f65:	81 f9 e7 03 00 00    	cmp    $0x3e7,%ecx
80101f6b:	0f 87 7e 00 00 00    	ja     80101fef <idestart+0x9f>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f71:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f76:	66 90                	xchg   %ax,%ax
80101f78:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f79:	83 e0 c0             	and    $0xffffffc0,%eax
80101f7c:	3c 40                	cmp    $0x40,%al
80101f7e:	75 f8                	jne    80101f78 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f80:	31 db                	xor    %ebx,%ebx
80101f82:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f87:	89 d8                	mov    %ebx,%eax
80101f89:	ee                   	out    %al,(%dx)
80101f8a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f8f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f94:	ee                   	out    %al,(%dx)
80101f95:	0f b6 c1             	movzbl %cl,%eax
80101f98:	b2 f3                	mov    $0xf3,%dl
80101f9a:	ee                   	out    %al,(%dx)

  idewait(0);
  outb(0x3f6, 0);  // generate interrupt
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
80101f9b:	89 c8                	mov    %ecx,%eax
80101f9d:	b2 f4                	mov    $0xf4,%dl
80101f9f:	c1 f8 08             	sar    $0x8,%eax
80101fa2:	ee                   	out    %al,(%dx)
80101fa3:	b2 f5                	mov    $0xf5,%dl
80101fa5:	89 d8                	mov    %ebx,%eax
80101fa7:	ee                   	out    %al,(%dx)
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
80101fa8:	0f b6 46 04          	movzbl 0x4(%esi),%eax
80101fac:	b2 f6                	mov    $0xf6,%dl
80101fae:	83 e0 01             	and    $0x1,%eax
80101fb1:	c1 e0 04             	shl    $0x4,%eax
80101fb4:	83 c8 e0             	or     $0xffffffe0,%eax
80101fb7:	ee                   	out    %al,(%dx)
  if(b->flags & B_DIRTY){
80101fb8:	f6 06 04             	testb  $0x4,(%esi)
80101fbb:	75 13                	jne    80101fd0 <idestart+0x80>
80101fbd:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fc2:	b8 20 00 00 00       	mov    $0x20,%eax
80101fc7:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fc8:	83 c4 10             	add    $0x10,%esp
80101fcb:	5b                   	pop    %ebx
80101fcc:	5e                   	pop    %esi
80101fcd:	5d                   	pop    %ebp
80101fce:	c3                   	ret    
80101fcf:	90                   	nop
80101fd0:	b2 f7                	mov    $0xf7,%dl
80101fd2:	b8 30 00 00 00       	mov    $0x30,%eax
80101fd7:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101fd8:	b9 80 00 00 00       	mov    $0x80,%ecx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101fdd:	83 c6 5c             	add    $0x5c,%esi
80101fe0:	ba f0 01 00 00       	mov    $0x1f0,%edx
80101fe5:	fc                   	cld    
80101fe6:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fe8:	83 c4 10             	add    $0x10,%esp
80101feb:	5b                   	pop    %ebx
80101fec:	5e                   	pop    %esi
80101fed:	5d                   	pop    %ebp
80101fee:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fef:	c7 04 24 34 72 10 80 	movl   $0x80107234,(%esp)
80101ff6:	e8 65 e3 ff ff       	call   80100360 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101ffb:	c7 04 24 2b 72 10 80 	movl   $0x8010722b,(%esp)
80102002:	e8 59 e3 ff ff       	call   80100360 <panic>
80102007:	89 f6                	mov    %esi,%esi
80102009:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102010 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80102010:	55                   	push   %ebp
80102011:	89 e5                	mov    %esp,%ebp
80102013:	83 ec 18             	sub    $0x18,%esp
  int i;

  initlock(&idelock, "ide");
80102016:	c7 44 24 04 46 72 10 	movl   $0x80107246,0x4(%esp)
8010201d:	80 
8010201e:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102025:	e8 96 20 00 00       	call   801040c0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
8010202a:	a1 00 2d 11 80       	mov    0x80112d00,%eax
8010202f:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
80102036:	83 e8 01             	sub    $0x1,%eax
80102039:	89 44 24 04          	mov    %eax,0x4(%esp)
8010203d:	e8 7e 02 00 00       	call   801022c0 <ioapicenable>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102042:	ba f7 01 00 00       	mov    $0x1f7,%edx
80102047:	90                   	nop
80102048:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102049:	83 e0 c0             	and    $0xffffffc0,%eax
8010204c:	3c 40                	cmp    $0x40,%al
8010204e:	75 f8                	jne    80102048 <ideinit+0x38>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102050:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102055:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
8010205a:	ee                   	out    %al,(%dx)
8010205b:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102060:	b2 f7                	mov    $0xf7,%dl
80102062:	eb 09                	jmp    8010206d <ideinit+0x5d>
80102064:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102068:	83 e9 01             	sub    $0x1,%ecx
8010206b:	74 0f                	je     8010207c <ideinit+0x6c>
8010206d:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
8010206e:	84 c0                	test   %al,%al
80102070:	74 f6                	je     80102068 <ideinit+0x58>
      havedisk1 = 1;
80102072:	c7 05 60 a5 10 80 01 	movl   $0x1,0x8010a560
80102079:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010207c:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102081:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
80102086:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
80102087:	c9                   	leave  
80102088:	c3                   	ret    
80102089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80102090 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102090:	55                   	push   %ebp
80102091:	89 e5                	mov    %esp,%ebp
80102093:	57                   	push   %edi
80102094:	56                   	push   %esi
80102095:	53                   	push   %ebx
80102096:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102099:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020a0:	e8 8b 21 00 00       	call   80104230 <acquire>

  if((b = idequeue) == 0){
801020a5:	8b 1d 64 a5 10 80    	mov    0x8010a564,%ebx
801020ab:	85 db                	test   %ebx,%ebx
801020ad:	74 30                	je     801020df <ideintr+0x4f>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
801020af:	8b 43 58             	mov    0x58(%ebx),%eax
801020b2:	a3 64 a5 10 80       	mov    %eax,0x8010a564

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
801020b7:	8b 33                	mov    (%ebx),%esi
801020b9:	f7 c6 04 00 00 00    	test   $0x4,%esi
801020bf:	74 37                	je     801020f8 <ideintr+0x68>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
801020c1:	83 e6 fb             	and    $0xfffffffb,%esi
801020c4:	83 ce 02             	or     $0x2,%esi
801020c7:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
801020c9:	89 1c 24             	mov    %ebx,(%esp)
801020cc:	e8 ff 1c 00 00       	call   80103dd0 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
801020d1:	a1 64 a5 10 80       	mov    0x8010a564,%eax
801020d6:	85 c0                	test   %eax,%eax
801020d8:	74 05                	je     801020df <ideintr+0x4f>
    idestart(idequeue);
801020da:	e8 71 fe ff ff       	call   80101f50 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020df:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
801020e6:	e8 b5 21 00 00       	call   801042a0 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020eb:	83 c4 1c             	add    $0x1c,%esp
801020ee:	5b                   	pop    %ebx
801020ef:	5e                   	pop    %esi
801020f0:	5f                   	pop    %edi
801020f1:	5d                   	pop    %ebp
801020f2:	c3                   	ret    
801020f3:	90                   	nop
801020f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020f8:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020fd:	8d 76 00             	lea    0x0(%esi),%esi
80102100:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102101:	89 c1                	mov    %eax,%ecx
80102103:	83 e1 c0             	and    $0xffffffc0,%ecx
80102106:	80 f9 40             	cmp    $0x40,%cl
80102109:	75 f5                	jne    80102100 <ideintr+0x70>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
8010210b:	a8 21                	test   $0x21,%al
8010210d:	75 b2                	jne    801020c1 <ideintr+0x31>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
8010210f:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
80102112:	b9 80 00 00 00       	mov    $0x80,%ecx
80102117:	ba f0 01 00 00       	mov    $0x1f0,%edx
8010211c:	fc                   	cld    
8010211d:	f3 6d                	rep insl (%dx),%es:(%edi)
8010211f:	8b 33                	mov    (%ebx),%esi
80102121:	eb 9e                	jmp    801020c1 <ideintr+0x31>
80102123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102130 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
80102130:	55                   	push   %ebp
80102131:	89 e5                	mov    %esp,%ebp
80102133:	53                   	push   %ebx
80102134:	83 ec 14             	sub    $0x14,%esp
80102137:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
8010213a:	8d 43 0c             	lea    0xc(%ebx),%eax
8010213d:	89 04 24             	mov    %eax,(%esp)
80102140:	e8 2b 1f 00 00       	call   80104070 <holdingsleep>
80102145:	85 c0                	test   %eax,%eax
80102147:	0f 84 9e 00 00 00    	je     801021eb <iderw+0xbb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010214d:	8b 03                	mov    (%ebx),%eax
8010214f:	83 e0 06             	and    $0x6,%eax
80102152:	83 f8 02             	cmp    $0x2,%eax
80102155:	0f 84 a8 00 00 00    	je     80102203 <iderw+0xd3>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010215b:	8b 53 04             	mov    0x4(%ebx),%edx
8010215e:	85 d2                	test   %edx,%edx
80102160:	74 0d                	je     8010216f <iderw+0x3f>
80102162:	a1 60 a5 10 80       	mov    0x8010a560,%eax
80102167:	85 c0                	test   %eax,%eax
80102169:	0f 84 88 00 00 00    	je     801021f7 <iderw+0xc7>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
8010216f:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
80102176:	e8 b5 20 00 00       	call   80104230 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010217b:	a1 64 a5 10 80       	mov    0x8010a564,%eax
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102180:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
80102187:	85 c0                	test   %eax,%eax
80102189:	75 07                	jne    80102192 <iderw+0x62>
8010218b:	eb 4e                	jmp    801021db <iderw+0xab>
8010218d:	8d 76 00             	lea    0x0(%esi),%esi
80102190:	89 d0                	mov    %edx,%eax
80102192:	8b 50 58             	mov    0x58(%eax),%edx
80102195:	85 d2                	test   %edx,%edx
80102197:	75 f7                	jne    80102190 <iderw+0x60>
80102199:	83 c0 58             	add    $0x58,%eax
    ;
  *pp = b;
8010219c:	89 18                	mov    %ebx,(%eax)

  // Start disk if necessary.
  if(idequeue == b)
8010219e:	39 1d 64 a5 10 80    	cmp    %ebx,0x8010a564
801021a4:	74 3c                	je     801021e2 <iderw+0xb2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021a6:	8b 03                	mov    (%ebx),%eax
801021a8:	83 e0 06             	and    $0x6,%eax
801021ab:	83 f8 02             	cmp    $0x2,%eax
801021ae:	74 1a                	je     801021ca <iderw+0x9a>
    sleep(b, &idelock);
801021b0:	c7 44 24 04 80 a5 10 	movl   $0x8010a580,0x4(%esp)
801021b7:	80 
801021b8:	89 1c 24             	mov    %ebx,(%esp)
801021bb:	e8 70 1a 00 00       	call   80103c30 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
801021c0:	8b 13                	mov    (%ebx),%edx
801021c2:	83 e2 06             	and    $0x6,%edx
801021c5:	83 fa 02             	cmp    $0x2,%edx
801021c8:	75 e6                	jne    801021b0 <iderw+0x80>
    sleep(b, &idelock);
  }


  release(&idelock);
801021ca:	c7 45 08 80 a5 10 80 	movl   $0x8010a580,0x8(%ebp)
}
801021d1:	83 c4 14             	add    $0x14,%esp
801021d4:	5b                   	pop    %ebx
801021d5:	5d                   	pop    %ebp
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021d6:	e9 c5 20 00 00       	jmp    801042a0 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021db:	b8 64 a5 10 80       	mov    $0x8010a564,%eax
801021e0:	eb ba                	jmp    8010219c <iderw+0x6c>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021e2:	89 d8                	mov    %ebx,%eax
801021e4:	e8 67 fd ff ff       	call   80101f50 <idestart>
801021e9:	eb bb                	jmp    801021a6 <iderw+0x76>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021eb:	c7 04 24 4a 72 10 80 	movl   $0x8010724a,(%esp)
801021f2:	e8 69 e1 ff ff       	call   80100360 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021f7:	c7 04 24 75 72 10 80 	movl   $0x80107275,(%esp)
801021fe:	e8 5d e1 ff ff       	call   80100360 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
80102203:	c7 04 24 60 72 10 80 	movl   $0x80107260,(%esp)
8010220a:	e8 51 e1 ff ff       	call   80100360 <panic>
8010220f:	90                   	nop

80102210 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102210:	55                   	push   %ebp
80102211:	89 e5                	mov    %esp,%ebp
80102213:	56                   	push   %esi
80102214:	53                   	push   %ebx
80102215:	83 ec 10             	sub    $0x10,%esp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
80102218:	c7 05 34 26 11 80 00 	movl   $0xfec00000,0x80112634
8010221f:	00 c0 fe 
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102222:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102229:	00 00 00 
  return ioapic->data;
8010222c:	8b 15 34 26 11 80    	mov    0x80112634,%edx
80102232:	8b 42 10             	mov    0x10(%edx),%eax
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102235:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
8010223b:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102241:	0f b6 15 60 27 11 80 	movzbl 0x80112760,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102248:	c1 e8 10             	shr    $0x10,%eax
8010224b:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010224e:	8b 43 10             	mov    0x10(%ebx),%eax
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
80102251:	c1 e8 18             	shr    $0x18,%eax
  if(id != ioapicid)
80102254:	39 c2                	cmp    %eax,%edx
80102256:	74 12                	je     8010226a <ioapicinit+0x5a>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102258:	c7 04 24 94 72 10 80 	movl   $0x80107294,(%esp)
8010225f:	e8 ec e3 ff ff       	call   80100650 <cprintf>
80102264:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
8010226a:	ba 10 00 00 00       	mov    $0x10,%edx
8010226f:	31 c0                	xor    %eax,%eax
80102271:	eb 07                	jmp    8010227a <ioapicinit+0x6a>
80102273:	90                   	nop
80102274:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102278:	89 cb                	mov    %ecx,%ebx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227a:	89 13                	mov    %edx,(%ebx)
  ioapic->data = data;
8010227c:	8b 1d 34 26 11 80    	mov    0x80112634,%ebx
80102282:	8d 48 20             	lea    0x20(%eax),%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102285:	81 c9 00 00 01 00    	or     $0x10000,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228b:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
8010228e:	89 4b 10             	mov    %ecx,0x10(%ebx)
80102291:	8d 4a 01             	lea    0x1(%edx),%ecx
80102294:	83 c2 02             	add    $0x2,%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102297:	89 0b                	mov    %ecx,(%ebx)
  ioapic->data = data;
80102299:	8b 0d 34 26 11 80    	mov    0x80112634,%ecx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010229f:	39 c6                	cmp    %eax,%esi

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022a1:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
801022a8:	7d ce                	jge    80102278 <ioapicinit+0x68>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
801022aa:	83 c4 10             	add    $0x10,%esp
801022ad:	5b                   	pop    %ebx
801022ae:	5e                   	pop    %esi
801022af:	5d                   	pop    %ebp
801022b0:	c3                   	ret    
801022b1:	eb 0d                	jmp    801022c0 <ioapicenable>
801022b3:	90                   	nop
801022b4:	90                   	nop
801022b5:	90                   	nop
801022b6:	90                   	nop
801022b7:	90                   	nop
801022b8:	90                   	nop
801022b9:	90                   	nop
801022ba:	90                   	nop
801022bb:	90                   	nop
801022bc:	90                   	nop
801022bd:	90                   	nop
801022be:	90                   	nop
801022bf:	90                   	nop

801022c0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022c0:	55                   	push   %ebp
801022c1:	89 e5                	mov    %esp,%ebp
801022c3:	8b 55 08             	mov    0x8(%ebp),%edx
801022c6:	53                   	push   %ebx
801022c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ca:	8d 5a 20             	lea    0x20(%edx),%ebx
801022cd:	8d 4c 12 10          	lea    0x10(%edx,%edx,1),%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022d1:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022d7:	c1 e0 18             	shl    $0x18,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022da:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022dc:	8b 15 34 26 11 80    	mov    0x80112634,%edx
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022e2:	83 c1 01             	add    $0x1,%ecx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022e5:	89 5a 10             	mov    %ebx,0x10(%edx)
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022e8:	89 0a                	mov    %ecx,(%edx)
  ioapic->data = data;
801022ea:	8b 15 34 26 11 80    	mov    0x80112634,%edx
801022f0:	89 42 10             	mov    %eax,0x10(%edx)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022f3:	5b                   	pop    %ebx
801022f4:	5d                   	pop    %ebp
801022f5:	c3                   	ret    
801022f6:	66 90                	xchg   %ax,%ax
801022f8:	66 90                	xchg   %ax,%ax
801022fa:	66 90                	xchg   %ax,%ax
801022fc:	66 90                	xchg   %ax,%ax
801022fe:	66 90                	xchg   %ax,%ax

80102300 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
80102300:	55                   	push   %ebp
80102301:	89 e5                	mov    %esp,%ebp
80102303:	53                   	push   %ebx
80102304:	83 ec 14             	sub    $0x14,%esp
80102307:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
8010230a:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
80102310:	75 7c                	jne    8010238e <kfree+0x8e>
80102312:	81 fb a8 5b 11 80    	cmp    $0x80115ba8,%ebx
80102318:	72 74                	jb     8010238e <kfree+0x8e>
8010231a:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102320:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102325:	77 67                	ja     8010238e <kfree+0x8e>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102327:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
8010232e:	00 
8010232f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
80102336:	00 
80102337:	89 1c 24             	mov    %ebx,(%esp)
8010233a:	e8 b1 1f 00 00       	call   801042f0 <memset>

  if(kmem.use_lock)
8010233f:	8b 15 74 26 11 80    	mov    0x80112674,%edx
80102345:	85 d2                	test   %edx,%edx
80102347:	75 37                	jne    80102380 <kfree+0x80>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102349:	a1 78 26 11 80       	mov    0x80112678,%eax
8010234e:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
80102350:	a1 74 26 11 80       	mov    0x80112674,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102355:	89 1d 78 26 11 80    	mov    %ebx,0x80112678
  if(kmem.use_lock)
8010235b:	85 c0                	test   %eax,%eax
8010235d:	75 09                	jne    80102368 <kfree+0x68>
    release(&kmem.lock);
}
8010235f:	83 c4 14             	add    $0x14,%esp
80102362:	5b                   	pop    %ebx
80102363:	5d                   	pop    %ebp
80102364:	c3                   	ret    
80102365:	8d 76 00             	lea    0x0(%esi),%esi
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102368:	c7 45 08 40 26 11 80 	movl   $0x80112640,0x8(%ebp)
}
8010236f:	83 c4 14             	add    $0x14,%esp
80102372:	5b                   	pop    %ebx
80102373:	5d                   	pop    %ebp
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102374:	e9 27 1f 00 00       	jmp    801042a0 <release>
80102379:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102380:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
80102387:	e8 a4 1e 00 00       	call   80104230 <acquire>
8010238c:	eb bb                	jmp    80102349 <kfree+0x49>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
8010238e:	c7 04 24 c6 72 10 80 	movl   $0x801072c6,(%esp)
80102395:	e8 c6 df ff ff       	call   80100360 <panic>
8010239a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801023a0 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023a0:	55                   	push   %ebp
801023a1:	89 e5                	mov    %esp,%ebp
801023a3:	56                   	push   %esi
801023a4:	53                   	push   %ebx
801023a5:	83 ec 10             	sub    $0x10,%esp
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023a8:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
801023ab:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ae:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
801023b4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ba:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
801023c0:	39 de                	cmp    %ebx,%esi
801023c2:	73 08                	jae    801023cc <freerange+0x2c>
801023c4:	eb 18                	jmp    801023de <freerange+0x3e>
801023c6:	66 90                	xchg   %ax,%ax
801023c8:	89 da                	mov    %ebx,%edx
801023ca:	89 c3                	mov    %eax,%ebx
    kfree(p);
801023cc:	89 14 24             	mov    %edx,(%esp)
801023cf:	e8 2c ff ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023d4:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
801023da:	39 f0                	cmp    %esi,%eax
801023dc:	76 ea                	jbe    801023c8 <freerange+0x28>
    kfree(p);
}
801023de:	83 c4 10             	add    $0x10,%esp
801023e1:	5b                   	pop    %ebx
801023e2:	5e                   	pop    %esi
801023e3:	5d                   	pop    %ebp
801023e4:	c3                   	ret    
801023e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801023e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801023f0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023f0:	55                   	push   %ebp
801023f1:	89 e5                	mov    %esp,%ebp
801023f3:	56                   	push   %esi
801023f4:	53                   	push   %ebx
801023f5:	83 ec 10             	sub    $0x10,%esp
801023f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023fb:	c7 44 24 04 cc 72 10 	movl   $0x801072cc,0x4(%esp)
80102402:	80 
80102403:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
8010240a:	e8 b1 1c 00 00       	call   801040c0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010240f:	8b 45 08             	mov    0x8(%ebp),%eax
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
80102412:	c7 05 74 26 11 80 00 	movl   $0x0,0x80112674
80102419:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010241c:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102422:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102428:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
8010242e:	39 de                	cmp    %ebx,%esi
80102430:	73 0a                	jae    8010243c <kinit1+0x4c>
80102432:	eb 1a                	jmp    8010244e <kinit1+0x5e>
80102434:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102438:	89 da                	mov    %ebx,%edx
8010243a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010243c:	89 14 24             	mov    %edx,(%esp)
8010243f:	e8 bc fe ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102444:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010244a:	39 c6                	cmp    %eax,%esi
8010244c:	73 ea                	jae    80102438 <kinit1+0x48>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010244e:	83 c4 10             	add    $0x10,%esp
80102451:	5b                   	pop    %ebx
80102452:	5e                   	pop    %esi
80102453:	5d                   	pop    %ebp
80102454:	c3                   	ret    
80102455:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102459:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102460 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102460:	55                   	push   %ebp
80102461:	89 e5                	mov    %esp,%ebp
80102463:	56                   	push   %esi
80102464:	53                   	push   %ebx
80102465:	83 ec 10             	sub    $0x10,%esp

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102468:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
8010246b:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010246e:	8d 90 ff 0f 00 00    	lea    0xfff(%eax),%edx
80102474:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010247a:	8d 9a 00 10 00 00    	lea    0x1000(%edx),%ebx
80102480:	39 de                	cmp    %ebx,%esi
80102482:	73 08                	jae    8010248c <kinit2+0x2c>
80102484:	eb 18                	jmp    8010249e <kinit2+0x3e>
80102486:	66 90                	xchg   %ax,%ax
80102488:	89 da                	mov    %ebx,%edx
8010248a:	89 c3                	mov    %eax,%ebx
    kfree(p);
8010248c:	89 14 24             	mov    %edx,(%esp)
8010248f:	e8 6c fe ff ff       	call   80102300 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102494:	8d 83 00 10 00 00    	lea    0x1000(%ebx),%eax
8010249a:	39 c6                	cmp    %eax,%esi
8010249c:	73 ea                	jae    80102488 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
8010249e:	c7 05 74 26 11 80 01 	movl   $0x1,0x80112674
801024a5:	00 00 00 
}
801024a8:	83 c4 10             	add    $0x10,%esp
801024ab:	5b                   	pop    %ebx
801024ac:	5e                   	pop    %esi
801024ad:	5d                   	pop    %ebp
801024ae:	c3                   	ret    
801024af:	90                   	nop

801024b0 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
801024b0:	55                   	push   %ebp
801024b1:	89 e5                	mov    %esp,%ebp
801024b3:	53                   	push   %ebx
801024b4:	83 ec 14             	sub    $0x14,%esp
  struct run *r;

  if(kmem.use_lock)
801024b7:	a1 74 26 11 80       	mov    0x80112674,%eax
801024bc:	85 c0                	test   %eax,%eax
801024be:	75 30                	jne    801024f0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024c0:	8b 1d 78 26 11 80    	mov    0x80112678,%ebx
  if(r)
801024c6:	85 db                	test   %ebx,%ebx
801024c8:	74 08                	je     801024d2 <kalloc+0x22>
    kmem.freelist = r->next;
801024ca:	8b 13                	mov    (%ebx),%edx
801024cc:	89 15 78 26 11 80    	mov    %edx,0x80112678
  if(kmem.use_lock)
801024d2:	85 c0                	test   %eax,%eax
801024d4:	74 0c                	je     801024e2 <kalloc+0x32>
    release(&kmem.lock);
801024d6:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024dd:	e8 be 1d 00 00       	call   801042a0 <release>
  return (char*)r;
}
801024e2:	83 c4 14             	add    $0x14,%esp
801024e5:	89 d8                	mov    %ebx,%eax
801024e7:	5b                   	pop    %ebx
801024e8:	5d                   	pop    %ebp
801024e9:	c3                   	ret    
801024ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024f0:	c7 04 24 40 26 11 80 	movl   $0x80112640,(%esp)
801024f7:	e8 34 1d 00 00       	call   80104230 <acquire>
801024fc:	a1 74 26 11 80       	mov    0x80112674,%eax
80102501:	eb bd                	jmp    801024c0 <kalloc+0x10>
80102503:	66 90                	xchg   %ax,%ax
80102505:	66 90                	xchg   %ax,%ax
80102507:	66 90                	xchg   %ax,%ax
80102509:	66 90                	xchg   %ax,%ax
8010250b:	66 90                	xchg   %ax,%ax
8010250d:	66 90                	xchg   %ax,%ax
8010250f:	90                   	nop

80102510 <kbdgetc>:
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102510:	ba 64 00 00 00       	mov    $0x64,%edx
80102515:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102516:	a8 01                	test   $0x1,%al
80102518:	0f 84 ba 00 00 00    	je     801025d8 <kbdgetc+0xc8>
8010251e:	b2 60                	mov    $0x60,%dl
80102520:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102521:	0f b6 c8             	movzbl %al,%ecx

  if(data == 0xE0){
80102524:	81 f9 e0 00 00 00    	cmp    $0xe0,%ecx
8010252a:	0f 84 88 00 00 00    	je     801025b8 <kbdgetc+0xa8>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102530:	84 c0                	test   %al,%al
80102532:	79 2c                	jns    80102560 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102534:	8b 15 b4 a5 10 80    	mov    0x8010a5b4,%edx
8010253a:	f6 c2 40             	test   $0x40,%dl
8010253d:	75 05                	jne    80102544 <kbdgetc+0x34>
8010253f:	89 c1                	mov    %eax,%ecx
80102541:	83 e1 7f             	and    $0x7f,%ecx
    shift &= ~(shiftcode[data] | E0ESC);
80102544:	0f b6 81 00 74 10 80 	movzbl -0x7fef8c00(%ecx),%eax
8010254b:	83 c8 40             	or     $0x40,%eax
8010254e:	0f b6 c0             	movzbl %al,%eax
80102551:	f7 d0                	not    %eax
80102553:	21 d0                	and    %edx,%eax
80102555:	a3 b4 a5 10 80       	mov    %eax,0x8010a5b4
    return 0;
8010255a:	31 c0                	xor    %eax,%eax
8010255c:	c3                   	ret    
8010255d:	8d 76 00             	lea    0x0(%esi),%esi
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102560:	55                   	push   %ebp
80102561:	89 e5                	mov    %esp,%ebp
80102563:	53                   	push   %ebx
80102564:	8b 1d b4 a5 10 80    	mov    0x8010a5b4,%ebx
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
8010256a:	f6 c3 40             	test   $0x40,%bl
8010256d:	74 09                	je     80102578 <kbdgetc+0x68>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010256f:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102572:	83 e3 bf             	and    $0xffffffbf,%ebx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102575:	0f b6 c8             	movzbl %al,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102578:	0f b6 91 00 74 10 80 	movzbl -0x7fef8c00(%ecx),%edx
  shift ^= togglecode[data];
8010257f:	0f b6 81 00 73 10 80 	movzbl -0x7fef8d00(%ecx),%eax
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
80102586:	09 da                	or     %ebx,%edx
  shift ^= togglecode[data];
80102588:	31 c2                	xor    %eax,%edx
  c = charcode[shift & (CTL | SHIFT)][data];
8010258a:	89 d0                	mov    %edx,%eax
8010258c:	83 e0 03             	and    $0x3,%eax
8010258f:	8b 04 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102596:	89 15 b4 a5 10 80    	mov    %edx,0x8010a5b4
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
8010259c:	83 e2 08             	and    $0x8,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010259f:	0f b6 04 08          	movzbl (%eax,%ecx,1),%eax
  if(shift & CAPSLOCK){
801025a3:	74 0b                	je     801025b0 <kbdgetc+0xa0>
    if('a' <= c && c <= 'z')
801025a5:	8d 50 9f             	lea    -0x61(%eax),%edx
801025a8:	83 fa 19             	cmp    $0x19,%edx
801025ab:	77 1b                	ja     801025c8 <kbdgetc+0xb8>
      c += 'A' - 'a';
801025ad:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025b0:	5b                   	pop    %ebx
801025b1:	5d                   	pop    %ebp
801025b2:	c3                   	ret    
801025b3:	90                   	nop
801025b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025b8:	83 0d b4 a5 10 80 40 	orl    $0x40,0x8010a5b4
    return 0;
801025bf:	31 c0                	xor    %eax,%eax
801025c1:	c3                   	ret    
801025c2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025c8:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025cb:	8d 50 20             	lea    0x20(%eax),%edx
801025ce:	83 f9 19             	cmp    $0x19,%ecx
801025d1:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
801025d4:	eb da                	jmp    801025b0 <kbdgetc+0xa0>
801025d6:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801025dd:	c3                   	ret    
801025de:	66 90                	xchg   %ax,%ax

801025e0 <kbdintr>:
  return c;
}

void
kbdintr(void)
{
801025e0:	55                   	push   %ebp
801025e1:	89 e5                	mov    %esp,%ebp
801025e3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(kbdgetc);
801025e6:	c7 04 24 10 25 10 80 	movl   $0x80102510,(%esp)
801025ed:	e8 be e1 ff ff       	call   801007b0 <consoleintr>
}
801025f2:	c9                   	leave  
801025f3:	c3                   	ret    
801025f4:	66 90                	xchg   %ax,%ax
801025f6:	66 90                	xchg   %ax,%ax
801025f8:	66 90                	xchg   %ax,%ax
801025fa:	66 90                	xchg   %ax,%ax
801025fc:	66 90                	xchg   %ax,%ax
801025fe:	66 90                	xchg   %ax,%ax

80102600 <fill_rtcdate>:
  return inb(CMOS_RETURN);
}

static void
fill_rtcdate(struct rtcdate *r)
{
80102600:	55                   	push   %ebp
80102601:	89 c1                	mov    %eax,%ecx
80102603:	89 e5                	mov    %esp,%ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102605:	ba 70 00 00 00       	mov    $0x70,%edx
8010260a:	53                   	push   %ebx
8010260b:	31 c0                	xor    %eax,%eax
8010260d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010260e:	bb 71 00 00 00       	mov    $0x71,%ebx
80102613:	89 da                	mov    %ebx,%edx
80102615:	ec                   	in     (%dx),%al
cmos_read(uint reg)
{
  outb(CMOS_PORT,  reg);
  microdelay(200);

  return inb(CMOS_RETURN);
80102616:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102619:	b2 70                	mov    $0x70,%dl
8010261b:	89 01                	mov    %eax,(%ecx)
8010261d:	b8 02 00 00 00       	mov    $0x2,%eax
80102622:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102623:	89 da                	mov    %ebx,%edx
80102625:	ec                   	in     (%dx),%al
80102626:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102629:	b2 70                	mov    $0x70,%dl
8010262b:	89 41 04             	mov    %eax,0x4(%ecx)
8010262e:	b8 04 00 00 00       	mov    $0x4,%eax
80102633:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102634:	89 da                	mov    %ebx,%edx
80102636:	ec                   	in     (%dx),%al
80102637:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010263a:	b2 70                	mov    $0x70,%dl
8010263c:	89 41 08             	mov    %eax,0x8(%ecx)
8010263f:	b8 07 00 00 00       	mov    $0x7,%eax
80102644:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102645:	89 da                	mov    %ebx,%edx
80102647:	ec                   	in     (%dx),%al
80102648:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010264b:	b2 70                	mov    $0x70,%dl
8010264d:	89 41 0c             	mov    %eax,0xc(%ecx)
80102650:	b8 08 00 00 00       	mov    $0x8,%eax
80102655:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102656:	89 da                	mov    %ebx,%edx
80102658:	ec                   	in     (%dx),%al
80102659:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010265c:	b2 70                	mov    $0x70,%dl
8010265e:	89 41 10             	mov    %eax,0x10(%ecx)
80102661:	b8 09 00 00 00       	mov    $0x9,%eax
80102666:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102667:	89 da                	mov    %ebx,%edx
80102669:	ec                   	in     (%dx),%al
8010266a:	0f b6 d8             	movzbl %al,%ebx
8010266d:	89 59 14             	mov    %ebx,0x14(%ecx)
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
}
80102670:	5b                   	pop    %ebx
80102671:	5d                   	pop    %ebp
80102672:	c3                   	ret    
80102673:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102679:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102680 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
80102680:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
80102685:	55                   	push   %ebp
80102686:	89 e5                	mov    %esp,%ebp
  if(!lapic)
80102688:	85 c0                	test   %eax,%eax
8010268a:	0f 84 c0 00 00 00    	je     80102750 <lapicinit+0xd0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102690:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102697:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010269a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
801026a4:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026a7:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026aa:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
801026b1:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
801026b4:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026b7:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
801026be:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
801026c1:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026c4:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
801026cb:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026ce:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d1:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
801026d8:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026db:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
801026de:	8b 50 30             	mov    0x30(%eax),%edx
801026e1:	c1 ea 10             	shr    $0x10,%edx
801026e4:	80 fa 03             	cmp    $0x3,%dl
801026e7:	77 6f                	ja     80102758 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026e9:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
801026f0:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026f3:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026f6:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
801026fd:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102700:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102703:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010270a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010270d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102710:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102717:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010271a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102724:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102727:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010272a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
80102731:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
80102734:	8b 50 20             	mov    0x20(%eax),%edx
80102737:	90                   	nop
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
80102738:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
8010273e:	80 e6 10             	and    $0x10,%dh
80102741:	75 f5                	jne    80102738 <lapicinit+0xb8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102743:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
8010274a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010274d:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
80102750:	5d                   	pop    %ebp
80102751:	c3                   	ret    
80102752:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102758:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
8010275f:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
80102762:	8b 50 20             	mov    0x20(%eax),%edx
80102765:	eb 82                	jmp    801026e9 <lapicinit+0x69>
80102767:	89 f6                	mov    %esi,%esi
80102769:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102770 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
80102770:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
80102775:	55                   	push   %ebp
80102776:	89 e5                	mov    %esp,%ebp
  if (!lapic)
80102778:	85 c0                	test   %eax,%eax
8010277a:	74 0c                	je     80102788 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
8010277c:	8b 40 20             	mov    0x20(%eax),%eax
}
8010277f:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102780:	c1 e8 18             	shr    $0x18,%eax
}
80102783:	c3                   	ret    
80102784:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102788:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010278a:	5d                   	pop    %ebp
8010278b:	c3                   	ret    
8010278c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102790 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102790:	a1 7c 26 11 80       	mov    0x8011267c,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102795:	55                   	push   %ebp
80102796:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102798:	85 c0                	test   %eax,%eax
8010279a:	74 0d                	je     801027a9 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010279c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
801027a3:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a6:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
801027a9:	5d                   	pop    %ebp
801027aa:	c3                   	ret    
801027ab:	90                   	nop
801027ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801027b0 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
801027b0:	55                   	push   %ebp
801027b1:	89 e5                	mov    %esp,%ebp
}
801027b3:	5d                   	pop    %ebp
801027b4:	c3                   	ret    
801027b5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801027b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801027c0 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
801027c0:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027c1:	ba 70 00 00 00       	mov    $0x70,%edx
801027c6:	89 e5                	mov    %esp,%ebp
801027c8:	b8 0f 00 00 00       	mov    $0xf,%eax
801027cd:	53                   	push   %ebx
801027ce:	8b 4d 08             	mov    0x8(%ebp),%ecx
801027d1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801027d4:	ee                   	out    %al,(%dx)
801027d5:	b8 0a 00 00 00       	mov    $0xa,%eax
801027da:	b2 71                	mov    $0x71,%dl
801027dc:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
801027dd:	31 c0                	xor    %eax,%eax
801027df:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
801027e5:	89 d8                	mov    %ebx,%eax
801027e7:	c1 e8 04             	shr    $0x4,%eax
801027ea:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027f0:	a1 7c 26 11 80       	mov    0x8011267c,%eax
  wrv[0] = 0;
  wrv[1] = addr >> 4;

  // "Universal startup algorithm."
  // Send INIT (level-triggered) interrupt to reset other CPU.
  lapicw(ICRHI, apicid<<24);
801027f5:	c1 e1 18             	shl    $0x18,%ecx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
801027f8:	c1 eb 0c             	shr    $0xc,%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027fb:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102801:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102804:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
8010280b:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010280e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102811:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
80102818:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010281b:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010281e:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102824:	8b 50 20             	mov    0x20(%eax),%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102827:	89 da                	mov    %ebx,%edx
80102829:	80 ce 06             	or     $0x6,%dh

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010282c:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102832:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102835:	89 88 10 03 00 00    	mov    %ecx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
8010283b:	8b 48 20             	mov    0x20(%eax),%ecx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010283e:	89 90 00 03 00 00    	mov    %edx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102844:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
80102847:	5b                   	pop    %ebx
80102848:	5d                   	pop    %ebp
80102849:	c3                   	ret    
8010284a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80102850 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
80102850:	55                   	push   %ebp
80102851:	ba 70 00 00 00       	mov    $0x70,%edx
80102856:	89 e5                	mov    %esp,%ebp
80102858:	b8 0b 00 00 00       	mov    $0xb,%eax
8010285d:	57                   	push   %edi
8010285e:	56                   	push   %esi
8010285f:	53                   	push   %ebx
80102860:	83 ec 4c             	sub    $0x4c,%esp
80102863:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102864:	b2 71                	mov    $0x71,%dl
80102866:	ec                   	in     (%dx),%al
80102867:	88 45 b7             	mov    %al,-0x49(%ebp)
8010286a:	8d 5d b8             	lea    -0x48(%ebp),%ebx
  struct rtcdate t1, t2;
  int sb, bcd;

  sb = cmos_read(CMOS_STATB);

  bcd = (sb & (1 << 2)) == 0;
8010286d:	80 65 b7 04          	andb   $0x4,-0x49(%ebp)
80102871:	8d 7d d0             	lea    -0x30(%ebp),%edi
80102874:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102878:	be 70 00 00 00       	mov    $0x70,%esi

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
8010287d:	89 d8                	mov    %ebx,%eax
8010287f:	e8 7c fd ff ff       	call   80102600 <fill_rtcdate>
80102884:	b8 0a 00 00 00       	mov    $0xa,%eax
80102889:	89 f2                	mov    %esi,%edx
8010288b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288c:	ba 71 00 00 00       	mov    $0x71,%edx
80102891:	ec                   	in     (%dx),%al
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102892:	84 c0                	test   %al,%al
80102894:	78 e7                	js     8010287d <cmostime+0x2d>
        continue;
    fill_rtcdate(&t2);
80102896:	89 f8                	mov    %edi,%eax
80102898:	e8 63 fd ff ff       	call   80102600 <fill_rtcdate>
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
8010289d:	c7 44 24 08 18 00 00 	movl   $0x18,0x8(%esp)
801028a4:	00 
801028a5:	89 7c 24 04          	mov    %edi,0x4(%esp)
801028a9:	89 1c 24             	mov    %ebx,(%esp)
801028ac:	e8 8f 1a 00 00       	call   80104340 <memcmp>
801028b1:	85 c0                	test   %eax,%eax
801028b3:	75 c3                	jne    80102878 <cmostime+0x28>
      break;
  }

  // convert
  if(bcd) {
801028b5:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028b9:	75 78                	jne    80102933 <cmostime+0xe3>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028bb:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028be:	89 c2                	mov    %eax,%edx
801028c0:	83 e0 0f             	and    $0xf,%eax
801028c3:	c1 ea 04             	shr    $0x4,%edx
801028c6:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028c9:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028cc:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
801028cf:	8b 45 bc             	mov    -0x44(%ebp),%eax
801028d2:	89 c2                	mov    %eax,%edx
801028d4:	83 e0 0f             	and    $0xf,%eax
801028d7:	c1 ea 04             	shr    $0x4,%edx
801028da:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028dd:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028e0:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
801028e3:	8b 45 c0             	mov    -0x40(%ebp),%eax
801028e6:	89 c2                	mov    %eax,%edx
801028e8:	83 e0 0f             	and    $0xf,%eax
801028eb:	c1 ea 04             	shr    $0x4,%edx
801028ee:	8d 14 92             	lea    (%edx,%edx,4),%edx
801028f1:	8d 04 50             	lea    (%eax,%edx,2),%eax
801028f4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
801028f7:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801028fa:	89 c2                	mov    %eax,%edx
801028fc:	83 e0 0f             	and    $0xf,%eax
801028ff:	c1 ea 04             	shr    $0x4,%edx
80102902:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102905:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102908:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010290b:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010290e:	89 c2                	mov    %eax,%edx
80102910:	83 e0 0f             	and    $0xf,%eax
80102913:	c1 ea 04             	shr    $0x4,%edx
80102916:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102919:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291c:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010291f:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102922:	89 c2                	mov    %eax,%edx
80102924:	83 e0 0f             	and    $0xf,%eax
80102927:	c1 ea 04             	shr    $0x4,%edx
8010292a:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010292d:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102930:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102933:	8b 4d 08             	mov    0x8(%ebp),%ecx
80102936:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102939:	89 01                	mov    %eax,(%ecx)
8010293b:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010293e:	89 41 04             	mov    %eax,0x4(%ecx)
80102941:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102944:	89 41 08             	mov    %eax,0x8(%ecx)
80102947:	8b 45 c4             	mov    -0x3c(%ebp),%eax
8010294a:	89 41 0c             	mov    %eax,0xc(%ecx)
8010294d:	8b 45 c8             	mov    -0x38(%ebp),%eax
80102950:	89 41 10             	mov    %eax,0x10(%ecx)
80102953:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102956:	89 41 14             	mov    %eax,0x14(%ecx)
  r->year += 2000;
80102959:	81 41 14 d0 07 00 00 	addl   $0x7d0,0x14(%ecx)
}
80102960:	83 c4 4c             	add    $0x4c,%esp
80102963:	5b                   	pop    %ebx
80102964:	5e                   	pop    %esi
80102965:	5f                   	pop    %edi
80102966:	5d                   	pop    %ebp
80102967:	c3                   	ret    
80102968:	66 90                	xchg   %ax,%ax
8010296a:	66 90                	xchg   %ax,%ax
8010296c:	66 90                	xchg   %ax,%ax
8010296e:	66 90                	xchg   %ax,%ax

80102970 <install_trans>:
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102970:	55                   	push   %ebp
80102971:	89 e5                	mov    %esp,%ebp
80102973:	57                   	push   %edi
80102974:	56                   	push   %esi
80102975:	53                   	push   %ebx
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102976:	31 db                	xor    %ebx,%ebx
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
80102978:	83 ec 1c             	sub    $0x1c,%esp
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
8010297b:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102980:	85 c0                	test   %eax,%eax
80102982:	7e 78                	jle    801029fc <install_trans+0x8c>
80102984:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
80102988:	a1 b4 26 11 80       	mov    0x801126b4,%eax
8010298d:	01 d8                	add    %ebx,%eax
8010298f:	83 c0 01             	add    $0x1,%eax
80102992:	89 44 24 04          	mov    %eax,0x4(%esp)
80102996:	a1 c4 26 11 80       	mov    0x801126c4,%eax
8010299b:	89 04 24             	mov    %eax,(%esp)
8010299e:	e8 2d d7 ff ff       	call   801000d0 <bread>
801029a3:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029a5:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029ac:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029af:	89 44 24 04          	mov    %eax,0x4(%esp)
801029b3:	a1 c4 26 11 80       	mov    0x801126c4,%eax
801029b8:	89 04 24             	mov    %eax,(%esp)
801029bb:	e8 10 d7 ff ff       	call   801000d0 <bread>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029c0:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
801029c7:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029c8:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
801029ca:	8d 47 5c             	lea    0x5c(%edi),%eax
801029cd:	89 44 24 04          	mov    %eax,0x4(%esp)
801029d1:	8d 46 5c             	lea    0x5c(%esi),%eax
801029d4:	89 04 24             	mov    %eax,(%esp)
801029d7:	e8 b4 19 00 00       	call   80104390 <memmove>
    bwrite(dbuf);  // write dst to disk
801029dc:	89 34 24             	mov    %esi,(%esp)
801029df:	e8 bc d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
801029e4:	89 3c 24             	mov    %edi,(%esp)
801029e7:	e8 f4 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
801029ec:	89 34 24             	mov    %esi,(%esp)
801029ef:	e8 ec d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029f4:	39 1d c8 26 11 80    	cmp    %ebx,0x801126c8
801029fa:	7f 8c                	jg     80102988 <install_trans+0x18>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
801029fc:	83 c4 1c             	add    $0x1c,%esp
801029ff:	5b                   	pop    %ebx
80102a00:	5e                   	pop    %esi
80102a01:	5f                   	pop    %edi
80102a02:	5d                   	pop    %ebp
80102a03:	c3                   	ret    
80102a04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102a0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102a10 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a10:	55                   	push   %ebp
80102a11:	89 e5                	mov    %esp,%ebp
80102a13:	57                   	push   %edi
80102a14:	56                   	push   %esi
80102a15:	53                   	push   %ebx
80102a16:	83 ec 1c             	sub    $0x1c,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a19:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
80102a22:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102a27:	89 04 24             	mov    %eax,(%esp)
80102a2a:	e8 a1 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a2f:	8b 1d c8 26 11 80    	mov    0x801126c8,%ebx
  for (i = 0; i < log.lh.n; i++) {
80102a35:	31 d2                	xor    %edx,%edx
80102a37:	85 db                	test   %ebx,%ebx
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a39:	89 c7                	mov    %eax,%edi
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a3b:	89 58 5c             	mov    %ebx,0x5c(%eax)
80102a3e:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102a41:	7e 17                	jle    80102a5a <write_head+0x4a>
80102a43:	90                   	nop
80102a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a48:	8b 0c 95 cc 26 11 80 	mov    -0x7feed934(,%edx,4),%ecx
80102a4f:	89 4c 96 04          	mov    %ecx,0x4(%esi,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a53:	83 c2 01             	add    $0x1,%edx
80102a56:	39 da                	cmp    %ebx,%edx
80102a58:	75 ee                	jne    80102a48 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a5a:	89 3c 24             	mov    %edi,(%esp)
80102a5d:	e8 3e d7 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102a62:	89 3c 24             	mov    %edi,(%esp)
80102a65:	e8 76 d7 ff ff       	call   801001e0 <brelse>
}
80102a6a:	83 c4 1c             	add    $0x1c,%esp
80102a6d:	5b                   	pop    %ebx
80102a6e:	5e                   	pop    %esi
80102a6f:	5f                   	pop    %edi
80102a70:	5d                   	pop    %ebp
80102a71:	c3                   	ret    
80102a72:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102a79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a80 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102a80:	55                   	push   %ebp
80102a81:	89 e5                	mov    %esp,%ebp
80102a83:	56                   	push   %esi
80102a84:	53                   	push   %ebx
80102a85:	83 ec 30             	sub    $0x30,%esp
80102a88:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102a8b:	c7 44 24 04 00 75 10 	movl   $0x80107500,0x4(%esp)
80102a92:	80 
80102a93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102a9a:	e8 21 16 00 00       	call   801040c0 <initlock>
  readsb(dev, &sb);
80102a9f:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102aa2:	89 44 24 04          	mov    %eax,0x4(%esp)
80102aa6:	89 1c 24             	mov    %ebx,(%esp)
80102aa9:	e8 f2 e8 ff ff       	call   801013a0 <readsb>
  log.start = sb.logstart;
80102aae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  log.size = sb.nlog;
80102ab1:	8b 55 e8             	mov    -0x18(%ebp),%edx

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102ab4:	89 1c 24             	mov    %ebx,(%esp)
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102ab7:	89 1d c4 26 11 80    	mov    %ebx,0x801126c4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102abd:	89 44 24 04          	mov    %eax,0x4(%esp)

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ac1:	89 15 b8 26 11 80    	mov    %edx,0x801126b8
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ac7:	a3 b4 26 11 80       	mov    %eax,0x801126b4

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102acc:	e8 ff d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102ad1:	31 d2                	xor    %edx,%edx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102ad3:	8b 58 5c             	mov    0x5c(%eax),%ebx
80102ad6:	8d 70 5c             	lea    0x5c(%eax),%esi
  for (i = 0; i < log.lh.n; i++) {
80102ad9:	85 db                	test   %ebx,%ebx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102adb:	89 1d c8 26 11 80    	mov    %ebx,0x801126c8
  for (i = 0; i < log.lh.n; i++) {
80102ae1:	7e 17                	jle    80102afa <initlog+0x7a>
80102ae3:	90                   	nop
80102ae4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    log.lh.block[i] = lh->block[i];
80102ae8:	8b 4c 96 04          	mov    0x4(%esi,%edx,4),%ecx
80102aec:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102af3:	83 c2 01             	add    $0x1,%edx
80102af6:	39 da                	cmp    %ebx,%edx
80102af8:	75 ee                	jne    80102ae8 <initlog+0x68>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102afa:	89 04 24             	mov    %eax,(%esp)
80102afd:	e8 de d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b02:	e8 69 fe ff ff       	call   80102970 <install_trans>
  log.lh.n = 0;
80102b07:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102b0e:	00 00 00 
  write_head(); // clear the log
80102b11:	e8 fa fe ff ff       	call   80102a10 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b16:	83 c4 30             	add    $0x30,%esp
80102b19:	5b                   	pop    %ebx
80102b1a:	5e                   	pop    %esi
80102b1b:	5d                   	pop    %ebp
80102b1c:	c3                   	ret    
80102b1d:	8d 76 00             	lea    0x0(%esi),%esi

80102b20 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b20:	55                   	push   %ebp
80102b21:	89 e5                	mov    %esp,%ebp
80102b23:	83 ec 18             	sub    $0x18,%esp
  acquire(&log.lock);
80102b26:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b2d:	e8 fe 16 00 00       	call   80104230 <acquire>
80102b32:	eb 18                	jmp    80102b4c <begin_op+0x2c>
80102b34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b38:	c7 44 24 04 80 26 11 	movl   $0x80112680,0x4(%esp)
80102b3f:	80 
80102b40:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102b47:	e8 e4 10 00 00       	call   80103c30 <sleep>
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b4c:	a1 c0 26 11 80       	mov    0x801126c0,%eax
80102b51:	85 c0                	test   %eax,%eax
80102b53:	75 e3                	jne    80102b38 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b55:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102b5a:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102b60:	83 c0 01             	add    $0x1,%eax
80102b63:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b66:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b69:	83 fa 1e             	cmp    $0x1e,%edx
80102b6c:	7f ca                	jg     80102b38 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b6e:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102b75:	a3 bc 26 11 80       	mov    %eax,0x801126bc
      release(&log.lock);
80102b7a:	e8 21 17 00 00       	call   801042a0 <release>
      break;
    }
  }
}
80102b7f:	c9                   	leave  
80102b80:	c3                   	ret    
80102b81:	eb 0d                	jmp    80102b90 <end_op>
80102b83:	90                   	nop
80102b84:	90                   	nop
80102b85:	90                   	nop
80102b86:	90                   	nop
80102b87:	90                   	nop
80102b88:	90                   	nop
80102b89:	90                   	nop
80102b8a:	90                   	nop
80102b8b:	90                   	nop
80102b8c:	90                   	nop
80102b8d:	90                   	nop
80102b8e:	90                   	nop
80102b8f:	90                   	nop

80102b90 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102b90:	55                   	push   %ebp
80102b91:	89 e5                	mov    %esp,%ebp
80102b93:	57                   	push   %edi
80102b94:	56                   	push   %esi
80102b95:	53                   	push   %ebx
80102b96:	83 ec 1c             	sub    $0x1c,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102b99:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ba0:	e8 8b 16 00 00       	call   80104230 <acquire>
  log.outstanding -= 1;
80102ba5:	a1 bc 26 11 80       	mov    0x801126bc,%eax
  if(log.committing)
80102baa:	8b 15 c0 26 11 80    	mov    0x801126c0,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb0:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102bb3:	85 d2                	test   %edx,%edx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102bb5:	a3 bc 26 11 80       	mov    %eax,0x801126bc
  if(log.committing)
80102bba:	0f 85 f3 00 00 00    	jne    80102cb3 <end_op+0x123>
    panic("log.committing");
  if(log.outstanding == 0){
80102bc0:	85 c0                	test   %eax,%eax
80102bc2:	0f 85 cb 00 00 00    	jne    80102c93 <end_op+0x103>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bc8:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
}

static void
commit()
{
  if (log.lh.n > 0) {
80102bcf:	31 db                	xor    %ebx,%ebx
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bd1:	c7 05 c0 26 11 80 01 	movl   $0x1,0x801126c0
80102bd8:	00 00 00 
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bdb:	e8 c0 16 00 00       	call   801042a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102be0:	a1 c8 26 11 80       	mov    0x801126c8,%eax
80102be5:	85 c0                	test   %eax,%eax
80102be7:	0f 8e 90 00 00 00    	jle    80102c7d <end_op+0xed>
80102bed:	8d 76 00             	lea    0x0(%esi),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102bf0:	a1 b4 26 11 80       	mov    0x801126b4,%eax
80102bf5:	01 d8                	add    %ebx,%eax
80102bf7:	83 c0 01             	add    $0x1,%eax
80102bfa:	89 44 24 04          	mov    %eax,0x4(%esp)
80102bfe:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c03:	89 04 24             	mov    %eax,(%esp)
80102c06:	e8 c5 d4 ff ff       	call   801000d0 <bread>
80102c0b:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c0d:	8b 04 9d cc 26 11 80 	mov    -0x7feed934(,%ebx,4),%eax
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c14:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c17:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c1b:	a1 c4 26 11 80       	mov    0x801126c4,%eax
80102c20:	89 04 24             	mov    %eax,(%esp)
80102c23:	e8 a8 d4 ff ff       	call   801000d0 <bread>
    memmove(to->data, from->data, BSIZE);
80102c28:	c7 44 24 08 00 02 00 	movl   $0x200,0x8(%esp)
80102c2f:	00 
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c30:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c32:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c35:	89 44 24 04          	mov    %eax,0x4(%esp)
80102c39:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c3c:	89 04 24             	mov    %eax,(%esp)
80102c3f:	e8 4c 17 00 00       	call   80104390 <memmove>
    bwrite(to);  // write the log
80102c44:	89 34 24             	mov    %esi,(%esp)
80102c47:	e8 54 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c4c:	89 3c 24             	mov    %edi,(%esp)
80102c4f:	e8 8c d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c54:	89 34 24             	mov    %esi,(%esp)
80102c57:	e8 84 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c5c:	3b 1d c8 26 11 80    	cmp    0x801126c8,%ebx
80102c62:	7c 8c                	jl     80102bf0 <end_op+0x60>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c64:	e8 a7 fd ff ff       	call   80102a10 <write_head>
    install_trans(); // Now install writes to home locations
80102c69:	e8 02 fd ff ff       	call   80102970 <install_trans>
    log.lh.n = 0;
80102c6e:	c7 05 c8 26 11 80 00 	movl   $0x0,0x801126c8
80102c75:	00 00 00 
    write_head();    // Erase the transaction from the log
80102c78:	e8 93 fd ff ff       	call   80102a10 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102c7d:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c84:	e8 a7 15 00 00       	call   80104230 <acquire>
    log.committing = 0;
80102c89:	c7 05 c0 26 11 80 00 	movl   $0x0,0x801126c0
80102c90:	00 00 00 
    wakeup(&log);
80102c93:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102c9a:	e8 31 11 00 00       	call   80103dd0 <wakeup>
    release(&log.lock);
80102c9f:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102ca6:	e8 f5 15 00 00       	call   801042a0 <release>
  }
}
80102cab:	83 c4 1c             	add    $0x1c,%esp
80102cae:	5b                   	pop    %ebx
80102caf:	5e                   	pop    %esi
80102cb0:	5f                   	pop    %edi
80102cb1:	5d                   	pop    %ebp
80102cb2:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102cb3:	c7 04 24 04 75 10 80 	movl   $0x80107504,(%esp)
80102cba:	e8 a1 d6 ff ff       	call   80100360 <panic>
80102cbf:	90                   	nop

80102cc0 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102cc0:	55                   	push   %ebp
80102cc1:	89 e5                	mov    %esp,%ebp
80102cc3:	53                   	push   %ebx
80102cc4:	83 ec 14             	sub    $0x14,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102cc7:	a1 c8 26 11 80       	mov    0x801126c8,%eax
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102ccc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102ccf:	83 f8 1d             	cmp    $0x1d,%eax
80102cd2:	0f 8f 98 00 00 00    	jg     80102d70 <log_write+0xb0>
80102cd8:	8b 0d b8 26 11 80    	mov    0x801126b8,%ecx
80102cde:	8d 51 ff             	lea    -0x1(%ecx),%edx
80102ce1:	39 d0                	cmp    %edx,%eax
80102ce3:	0f 8d 87 00 00 00    	jge    80102d70 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102ce9:	a1 bc 26 11 80       	mov    0x801126bc,%eax
80102cee:	85 c0                	test   %eax,%eax
80102cf0:	0f 8e 86 00 00 00    	jle    80102d7c <log_write+0xbc>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102cf6:	c7 04 24 80 26 11 80 	movl   $0x80112680,(%esp)
80102cfd:	e8 2e 15 00 00       	call   80104230 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d02:	8b 15 c8 26 11 80    	mov    0x801126c8,%edx
80102d08:	83 fa 00             	cmp    $0x0,%edx
80102d0b:	7e 54                	jle    80102d61 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d0d:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d10:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d12:	39 0d cc 26 11 80    	cmp    %ecx,0x801126cc
80102d18:	75 0f                	jne    80102d29 <log_write+0x69>
80102d1a:	eb 3c                	jmp    80102d58 <log_write+0x98>
80102d1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102d20:	39 0c 85 cc 26 11 80 	cmp    %ecx,-0x7feed934(,%eax,4)
80102d27:	74 2f                	je     80102d58 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d29:	83 c0 01             	add    $0x1,%eax
80102d2c:	39 d0                	cmp    %edx,%eax
80102d2e:	75 f0                	jne    80102d20 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d30:	89 0c 95 cc 26 11 80 	mov    %ecx,-0x7feed934(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102d37:	83 c2 01             	add    $0x1,%edx
80102d3a:	89 15 c8 26 11 80    	mov    %edx,0x801126c8
  b->flags |= B_DIRTY; // prevent eviction
80102d40:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102d43:	c7 45 08 80 26 11 80 	movl   $0x80112680,0x8(%ebp)
}
80102d4a:	83 c4 14             	add    $0x14,%esp
80102d4d:	5b                   	pop    %ebx
80102d4e:	5d                   	pop    %ebp
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102d4f:	e9 4c 15 00 00       	jmp    801042a0 <release>
80102d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102d58:	89 0c 85 cc 26 11 80 	mov    %ecx,-0x7feed934(,%eax,4)
80102d5f:	eb df                	jmp    80102d40 <log_write+0x80>
80102d61:	8b 43 08             	mov    0x8(%ebx),%eax
80102d64:	a3 cc 26 11 80       	mov    %eax,0x801126cc
  if (i == log.lh.n)
80102d69:	75 d5                	jne    80102d40 <log_write+0x80>
80102d6b:	eb ca                	jmp    80102d37 <log_write+0x77>
80102d6d:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102d70:	c7 04 24 13 75 10 80 	movl   $0x80107513,(%esp)
80102d77:	e8 e4 d5 ff ff       	call   80100360 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102d7c:	c7 04 24 29 75 10 80 	movl   $0x80107529,(%esp)
80102d83:	e8 d8 d5 ff ff       	call   80100360 <panic>
80102d88:	66 90                	xchg   %ax,%ax
80102d8a:	66 90                	xchg   %ax,%ax
80102d8c:	66 90                	xchg   %ax,%ax
80102d8e:	66 90                	xchg   %ax,%ax

80102d90 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102d90:	55                   	push   %ebp
80102d91:	89 e5                	mov    %esp,%ebp
80102d93:	53                   	push   %ebx
80102d94:	83 ec 14             	sub    $0x14,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102d97:	e8 f4 08 00 00       	call   80103690 <cpuid>
80102d9c:	89 c3                	mov    %eax,%ebx
80102d9e:	e8 ed 08 00 00       	call   80103690 <cpuid>
80102da3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80102da7:	c7 04 24 44 75 10 80 	movl   $0x80107544,(%esp)
80102dae:	89 44 24 04          	mov    %eax,0x4(%esp)
80102db2:	e8 99 d8 ff ff       	call   80100650 <cprintf>
  idtinit();       // load idt register
80102db7:	e8 34 2b 00 00       	call   801058f0 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102dbc:	e8 4f 08 00 00       	call   80103610 <mycpu>
80102dc1:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102dc3:	b8 01 00 00 00       	mov    $0x1,%eax
80102dc8:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102dcf:	e8 ac 0b 00 00       	call   80103980 <scheduler>
80102dd4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102dda:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80102de0 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102de0:	55                   	push   %ebp
80102de1:	89 e5                	mov    %esp,%ebp
80102de3:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102de6:	e8 c5 3b 00 00       	call   801069b0 <switchkvm>
  seginit();
80102deb:	e8 00 3b 00 00       	call   801068f0 <seginit>
  lapicinit();
80102df0:	e8 8b f8 ff ff       	call   80102680 <lapicinit>
  mpmain();
80102df5:	e8 96 ff ff ff       	call   80102d90 <mpmain>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e04:	bb 80 27 11 80       	mov    $0x80112780,%ebx
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e09:	83 e4 f0             	and    $0xfffffff0,%esp
80102e0c:	83 ec 10             	sub    $0x10,%esp
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e0f:	c7 44 24 04 00 00 40 	movl   $0x80400000,0x4(%esp)
80102e16:	80 
80102e17:	c7 04 24 a8 5b 11 80 	movl   $0x80115ba8,(%esp)
80102e1e:	e8 cd f5 ff ff       	call   801023f0 <kinit1>
  kvmalloc();      // kernel page table
80102e23:	e8 18 40 00 00       	call   80106e40 <kvmalloc>
  mpinit();        // detect other processors
80102e28:	e8 73 01 00 00       	call   80102fa0 <mpinit>
80102e2d:	8d 76 00             	lea    0x0(%esi),%esi
  lapicinit();     // interrupt controller
80102e30:	e8 4b f8 ff ff       	call   80102680 <lapicinit>
  seginit();       // segment descriptors
80102e35:	e8 b6 3a 00 00       	call   801068f0 <seginit>
  picinit();       // disable pic
80102e3a:	e8 21 03 00 00       	call   80103160 <picinit>
80102e3f:	90                   	nop
  ioapicinit();    // another interrupt controller
80102e40:	e8 cb f3 ff ff       	call   80102210 <ioapicinit>
  consoleinit();   // console hardware
80102e45:	e8 06 db ff ff       	call   80100950 <consoleinit>
  uartinit();      // serial port
80102e4a:	e8 c1 2d 00 00       	call   80105c10 <uartinit>
80102e4f:	90                   	nop
  pinit();         // process table
80102e50:	e8 9b 07 00 00       	call   801035f0 <pinit>
  tvinit();        // trap vectors
80102e55:	e8 f6 29 00 00       	call   80105850 <tvinit>
  binit();         // buffer cache
80102e5a:	e8 e1 d1 ff ff       	call   80100040 <binit>
80102e5f:	90                   	nop
  fileinit();      // file table
80102e60:	e8 eb de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102e65:	e8 a6 f1 ff ff       	call   80102010 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102e6a:	c7 44 24 08 8a 00 00 	movl   $0x8a,0x8(%esp)
80102e71:	00 
80102e72:	c7 44 24 04 8c a4 10 	movl   $0x8010a48c,0x4(%esp)
80102e79:	80 
80102e7a:	c7 04 24 00 70 00 80 	movl   $0x80007000,(%esp)
80102e81:	e8 0a 15 00 00       	call   80104390 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102e86:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102e8d:	00 00 00 
80102e90:	05 80 27 11 80       	add    $0x80112780,%eax
80102e95:	39 d8                	cmp    %ebx,%eax
80102e97:	76 6a                	jbe    80102f03 <main+0x103>
80102e99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ea0:	e8 6b 07 00 00       	call   80103610 <mycpu>
80102ea5:	39 d8                	cmp    %ebx,%eax
80102ea7:	74 41                	je     80102eea <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102ea9:	e8 02 f6 ff ff       	call   801024b0 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
    *(void(**)(void))(code-8) = mpenter;
80102eae:	c7 05 f8 6f 00 80 e0 	movl   $0x80102de0,0x80006ff8
80102eb5:	2d 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102eb8:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102ebf:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102ec2:	05 00 10 00 00       	add    $0x1000,%eax
80102ec7:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102ecc:	0f b6 03             	movzbl (%ebx),%eax
80102ecf:	c7 44 24 04 00 70 00 	movl   $0x7000,0x4(%esp)
80102ed6:	00 
80102ed7:	89 04 24             	mov    %eax,(%esp)
80102eda:	e8 e1 f8 ff ff       	call   801027c0 <lapicstartap>
80102edf:	90                   	nop

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102ee0:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102ee6:	85 c0                	test   %eax,%eax
80102ee8:	74 f6                	je     80102ee0 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102eea:	69 05 00 2d 11 80 b0 	imul   $0xb0,0x80112d00,%eax
80102ef1:	00 00 00 
80102ef4:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102efa:	05 80 27 11 80       	add    $0x80112780,%eax
80102eff:	39 c3                	cmp    %eax,%ebx
80102f01:	72 9d                	jb     80102ea0 <main+0xa0>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f03:	c7 44 24 04 00 00 00 	movl   $0x8e000000,0x4(%esp)
80102f0a:	8e 
80102f0b:	c7 04 24 00 00 40 80 	movl   $0x80400000,(%esp)
80102f12:	e8 49 f5 ff ff       	call   80102460 <kinit2>
  userinit();      // first user process
80102f17:	e8 c4 07 00 00       	call   801036e0 <userinit>
  mpmain();        // finish this processor's setup
80102f1c:	e8 6f fe ff ff       	call   80102d90 <mpmain>
80102f21:	66 90                	xchg   %ax,%ax
80102f23:	66 90                	xchg   %ax,%ax
80102f25:	66 90                	xchg   %ax,%ax
80102f27:	66 90                	xchg   %ax,%ax
80102f29:	66 90                	xchg   %ax,%ax
80102f2b:	66 90                	xchg   %ax,%ax
80102f2d:	66 90                	xchg   %ax,%ax
80102f2f:	90                   	nop

80102f30 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f30:	55                   	push   %ebp
80102f31:	89 e5                	mov    %esp,%ebp
80102f33:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f34:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f3a:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f3b:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f3e:	83 ec 10             	sub    $0x10,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f41:	39 de                	cmp    %ebx,%esi
80102f43:	73 3c                	jae    80102f81 <mpsearch1+0x51>
80102f45:	8d 76 00             	lea    0x0(%esi),%esi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f48:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
80102f4f:	00 
80102f50:	c7 44 24 04 58 75 10 	movl   $0x80107558,0x4(%esp)
80102f57:	80 
80102f58:	89 34 24             	mov    %esi,(%esp)
80102f5b:	e8 e0 13 00 00       	call   80104340 <memcmp>
80102f60:	85 c0                	test   %eax,%eax
80102f62:	75 16                	jne    80102f7a <mpsearch1+0x4a>
80102f64:	31 c9                	xor    %ecx,%ecx
80102f66:	31 d2                	xor    %edx,%edx
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102f68:	0f b6 04 16          	movzbl (%esi,%edx,1),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f6c:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80102f6f:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102f71:	83 fa 10             	cmp    $0x10,%edx
80102f74:	75 f2                	jne    80102f68 <mpsearch1+0x38>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102f76:	84 c9                	test   %cl,%cl
80102f78:	74 10                	je     80102f8a <mpsearch1+0x5a>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f7a:	83 c6 10             	add    $0x10,%esi
80102f7d:	39 f3                	cmp    %esi,%ebx
80102f7f:	77 c7                	ja     80102f48 <mpsearch1+0x18>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102f81:	83 c4 10             	add    $0x10,%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102f84:	31 c0                	xor    %eax,%eax
}
80102f86:	5b                   	pop    %ebx
80102f87:	5e                   	pop    %esi
80102f88:	5d                   	pop    %ebp
80102f89:	c3                   	ret    
80102f8a:	83 c4 10             	add    $0x10,%esp
80102f8d:	89 f0                	mov    %esi,%eax
80102f8f:	5b                   	pop    %ebx
80102f90:	5e                   	pop    %esi
80102f91:	5d                   	pop    %ebp
80102f92:	c3                   	ret    
80102f93:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102fa0 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80102fa0:	55                   	push   %ebp
80102fa1:	89 e5                	mov    %esp,%ebp
80102fa3:	57                   	push   %edi
80102fa4:	56                   	push   %esi
80102fa5:	53                   	push   %ebx
80102fa6:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80102fa9:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80102fb0:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80102fb7:	c1 e0 08             	shl    $0x8,%eax
80102fba:	09 d0                	or     %edx,%eax
80102fbc:	c1 e0 04             	shl    $0x4,%eax
80102fbf:	85 c0                	test   %eax,%eax
80102fc1:	75 1b                	jne    80102fde <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
80102fc3:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
80102fca:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80102fd1:	c1 e0 08             	shl    $0x8,%eax
80102fd4:	09 d0                	or     %edx,%eax
80102fd6:	c1 e0 0a             	shl    $0xa,%eax
    if((mp = mpsearch1(p-1024, 1024)))
80102fd9:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
80102fde:	ba 00 04 00 00       	mov    $0x400,%edx
80102fe3:	e8 48 ff ff ff       	call   80102f30 <mpsearch1>
80102fe8:	85 c0                	test   %eax,%eax
80102fea:	89 c7                	mov    %eax,%edi
80102fec:	0f 84 22 01 00 00    	je     80103114 <mpinit+0x174>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80102ff2:	8b 77 04             	mov    0x4(%edi),%esi
80102ff5:	85 f6                	test   %esi,%esi
80102ff7:	0f 84 30 01 00 00    	je     8010312d <mpinit+0x18d>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80102ffd:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
  if(memcmp(conf, "PCMP", 4) != 0)
80103003:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
8010300a:	00 
8010300b:	c7 44 24 04 5d 75 10 	movl   $0x8010755d,0x4(%esp)
80103012:	80 
80103013:	89 04 24             	mov    %eax,(%esp)
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103016:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  if(memcmp(conf, "PCMP", 4) != 0)
80103019:	e8 22 13 00 00       	call   80104340 <memcmp>
8010301e:	85 c0                	test   %eax,%eax
80103020:	0f 85 07 01 00 00    	jne    8010312d <mpinit+0x18d>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103026:	0f b6 86 06 00 00 80 	movzbl -0x7ffffffa(%esi),%eax
8010302d:	3c 04                	cmp    $0x4,%al
8010302f:	0f 85 0b 01 00 00    	jne    80103140 <mpinit+0x1a0>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103035:	0f b7 86 04 00 00 80 	movzwl -0x7ffffffc(%esi),%eax
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010303c:	85 c0                	test   %eax,%eax
8010303e:	74 21                	je     80103061 <mpinit+0xc1>
static uchar
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
80103040:	31 c9                	xor    %ecx,%ecx
  for(i=0; i<len; i++)
80103042:	31 d2                	xor    %edx,%edx
80103044:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
80103048:	0f b6 9c 16 00 00 00 	movzbl -0x80000000(%esi,%edx,1),%ebx
8010304f:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103050:	83 c2 01             	add    $0x1,%edx
    sum += addr[i];
80103053:	01 d9                	add    %ebx,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80103055:	39 d0                	cmp    %edx,%eax
80103057:	7f ef                	jg     80103048 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103059:	84 c9                	test   %cl,%cl
8010305b:	0f 85 cc 00 00 00    	jne    8010312d <mpinit+0x18d>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
80103061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103064:	85 c0                	test   %eax,%eax
80103066:	0f 84 c1 00 00 00    	je     8010312d <mpinit+0x18d>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
8010306c:	8b 86 24 00 00 80    	mov    -0x7fffffdc(%esi),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
80103072:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
80103077:	a3 7c 26 11 80       	mov    %eax,0x8011267c
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
8010307c:	0f b7 96 04 00 00 80 	movzwl -0x7ffffffc(%esi),%edx
80103083:	8d 86 2c 00 00 80    	lea    -0x7fffffd4(%esi),%eax
80103089:	03 55 e4             	add    -0x1c(%ebp),%edx
8010308c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103090:	39 c2                	cmp    %eax,%edx
80103092:	76 1b                	jbe    801030af <mpinit+0x10f>
80103094:	0f b6 08             	movzbl (%eax),%ecx
    switch(*p){
80103097:	80 f9 04             	cmp    $0x4,%cl
8010309a:	77 74                	ja     80103110 <mpinit+0x170>
8010309c:	ff 24 8d 9c 75 10 80 	jmp    *-0x7fef8a64(,%ecx,4)
801030a3:	90                   	nop
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
801030a8:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030ab:	39 c2                	cmp    %eax,%edx
801030ad:	77 e5                	ja     80103094 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
801030af:	85 db                	test   %ebx,%ebx
801030b1:	0f 84 93 00 00 00    	je     8010314a <mpinit+0x1aa>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
801030b7:	80 7f 0c 00          	cmpb   $0x0,0xc(%edi)
801030bb:	74 12                	je     801030cf <mpinit+0x12f>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030bd:	ba 22 00 00 00       	mov    $0x22,%edx
801030c2:	b8 70 00 00 00       	mov    $0x70,%eax
801030c7:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801030c8:	b2 23                	mov    $0x23,%dl
801030ca:	ec                   	in     (%dx),%al
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
801030cb:	83 c8 01             	or     $0x1,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801030ce:	ee                   	out    %al,(%dx)
  }
}
801030cf:	83 c4 1c             	add    $0x1c,%esp
801030d2:	5b                   	pop    %ebx
801030d3:	5e                   	pop    %esi
801030d4:	5f                   	pop    %edi
801030d5:	5d                   	pop    %ebp
801030d6:	c3                   	ret    
801030d7:	90                   	nop
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
801030d8:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
801030de:	83 fe 07             	cmp    $0x7,%esi
801030e1:	7f 17                	jg     801030fa <mpinit+0x15a>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030e3:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
801030e7:	69 f6 b0 00 00 00    	imul   $0xb0,%esi,%esi
        ncpu++;
801030ed:	83 05 00 2d 11 80 01 	addl   $0x1,0x80112d00
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
801030f4:	88 8e 80 27 11 80    	mov    %cl,-0x7feed880(%esi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
801030fa:	83 c0 14             	add    $0x14,%eax
      continue;
801030fd:	eb 91                	jmp    80103090 <mpinit+0xf0>
801030ff:	90                   	nop
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103100:	0f b6 48 01          	movzbl 0x1(%eax),%ecx
      p += sizeof(struct mpioapic);
80103104:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103107:	88 0d 60 27 11 80    	mov    %cl,0x80112760
      p += sizeof(struct mpioapic);
      continue;
8010310d:	eb 81                	jmp    80103090 <mpinit+0xf0>
8010310f:	90                   	nop
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
80103110:	31 db                	xor    %ebx,%ebx
80103112:	eb 83                	jmp    80103097 <mpinit+0xf7>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103114:	ba 00 00 01 00       	mov    $0x10000,%edx
80103119:	b8 00 00 0f 00       	mov    $0xf0000,%eax
8010311e:	e8 0d fe ff ff       	call   80102f30 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103123:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
80103125:	89 c7                	mov    %eax,%edi
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103127:	0f 85 c5 fe ff ff    	jne    80102ff2 <mpinit+0x52>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
8010312d:	c7 04 24 62 75 10 80 	movl   $0x80107562,(%esp)
80103134:	e8 27 d2 ff ff       	call   80100360 <panic>
80103139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103140:	3c 01                	cmp    $0x1,%al
80103142:	0f 84 ed fe ff ff    	je     80103035 <mpinit+0x95>
80103148:	eb e3                	jmp    8010312d <mpinit+0x18d>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
8010314a:	c7 04 24 7c 75 10 80 	movl   $0x8010757c,(%esp)
80103151:	e8 0a d2 ff ff       	call   80100360 <panic>
80103156:	66 90                	xchg   %ax,%ax
80103158:	66 90                	xchg   %ax,%ax
8010315a:	66 90                	xchg   %ax,%ax
8010315c:	66 90                	xchg   %ax,%ax
8010315e:	66 90                	xchg   %ax,%ax

80103160 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
80103160:	55                   	push   %ebp
80103161:	ba 21 00 00 00       	mov    $0x21,%edx
80103166:	89 e5                	mov    %esp,%ebp
80103168:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010316d:	ee                   	out    %al,(%dx)
8010316e:	b2 a1                	mov    $0xa1,%dl
80103170:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
80103171:	5d                   	pop    %ebp
80103172:	c3                   	ret    
80103173:	66 90                	xchg   %ax,%ax
80103175:	66 90                	xchg   %ax,%ax
80103177:	66 90                	xchg   %ax,%ax
80103179:	66 90                	xchg   %ax,%ax
8010317b:	66 90                	xchg   %ax,%ax
8010317d:	66 90                	xchg   %ax,%ax
8010317f:	90                   	nop

80103180 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
80103180:	55                   	push   %ebp
80103181:	89 e5                	mov    %esp,%ebp
80103183:	57                   	push   %edi
80103184:	56                   	push   %esi
80103185:	53                   	push   %ebx
80103186:	83 ec 1c             	sub    $0x1c,%esp
80103189:	8b 75 08             	mov    0x8(%ebp),%esi
8010318c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
8010318f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103195:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010319b:	e8 d0 db ff ff       	call   80100d70 <filealloc>
801031a0:	85 c0                	test   %eax,%eax
801031a2:	89 06                	mov    %eax,(%esi)
801031a4:	0f 84 a4 00 00 00    	je     8010324e <pipealloc+0xce>
801031aa:	e8 c1 db ff ff       	call   80100d70 <filealloc>
801031af:	85 c0                	test   %eax,%eax
801031b1:	89 03                	mov    %eax,(%ebx)
801031b3:	0f 84 87 00 00 00    	je     80103240 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
801031b9:	e8 f2 f2 ff ff       	call   801024b0 <kalloc>
801031be:	85 c0                	test   %eax,%eax
801031c0:	89 c7                	mov    %eax,%edi
801031c2:	74 7c                	je     80103240 <pipealloc+0xc0>
    goto bad;
  p->readopen = 1;
801031c4:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
801031cb:	00 00 00 
  p->writeopen = 1;
801031ce:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
801031d5:	00 00 00 
  p->nwrite = 0;
801031d8:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
801031df:	00 00 00 
  p->nread = 0;
801031e2:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
801031e9:	00 00 00 
  initlock(&p->lock, "pipe");
801031ec:	89 04 24             	mov    %eax,(%esp)
801031ef:	c7 44 24 04 b0 75 10 	movl   $0x801075b0,0x4(%esp)
801031f6:	80 
801031f7:	e8 c4 0e 00 00       	call   801040c0 <initlock>
  (*f0)->type = FD_PIPE;
801031fc:	8b 06                	mov    (%esi),%eax
801031fe:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103204:	8b 06                	mov    (%esi),%eax
80103206:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010320a:	8b 06                	mov    (%esi),%eax
8010320c:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103210:	8b 06                	mov    (%esi),%eax
80103212:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
80103215:	8b 03                	mov    (%ebx),%eax
80103217:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
8010321d:	8b 03                	mov    (%ebx),%eax
8010321f:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103223:	8b 03                	mov    (%ebx),%eax
80103225:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
80103229:	8b 03                	mov    (%ebx),%eax
  return 0;
8010322b:	31 db                	xor    %ebx,%ebx
  (*f0)->writable = 0;
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
8010322d:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
80103230:	83 c4 1c             	add    $0x1c,%esp
80103233:	89 d8                	mov    %ebx,%eax
80103235:	5b                   	pop    %ebx
80103236:	5e                   	pop    %esi
80103237:	5f                   	pop    %edi
80103238:	5d                   	pop    %ebp
80103239:	c3                   	ret    
8010323a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
80103240:	8b 06                	mov    (%esi),%eax
80103242:	85 c0                	test   %eax,%eax
80103244:	74 08                	je     8010324e <pipealloc+0xce>
    fileclose(*f0);
80103246:	89 04 24             	mov    %eax,(%esp)
80103249:	e8 e2 db ff ff       	call   80100e30 <fileclose>
  if(*f1)
8010324e:	8b 03                	mov    (%ebx),%eax
    fileclose(*f1);
  return -1;
80103250:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
80103255:	85 c0                	test   %eax,%eax
80103257:	74 d7                	je     80103230 <pipealloc+0xb0>
    fileclose(*f1);
80103259:	89 04 24             	mov    %eax,(%esp)
8010325c:	e8 cf db ff ff       	call   80100e30 <fileclose>
  return -1;
}
80103261:	83 c4 1c             	add    $0x1c,%esp
80103264:	89 d8                	mov    %ebx,%eax
80103266:	5b                   	pop    %ebx
80103267:	5e                   	pop    %esi
80103268:	5f                   	pop    %edi
80103269:	5d                   	pop    %ebp
8010326a:	c3                   	ret    
8010326b:	90                   	nop
8010326c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103270 <pipeclose>:

void
pipeclose(struct pipe *p, int writable)
{
80103270:	55                   	push   %ebp
80103271:	89 e5                	mov    %esp,%ebp
80103273:	56                   	push   %esi
80103274:	53                   	push   %ebx
80103275:	83 ec 10             	sub    $0x10,%esp
80103278:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010327b:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
8010327e:	89 1c 24             	mov    %ebx,(%esp)
80103281:	e8 aa 0f 00 00       	call   80104230 <acquire>
  if(writable){
80103286:	85 f6                	test   %esi,%esi
80103288:	74 3e                	je     801032c8 <pipeclose+0x58>
    p->writeopen = 0;
    wakeup(&p->nread);
8010328a:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103290:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
80103297:	00 00 00 
    wakeup(&p->nread);
8010329a:	89 04 24             	mov    %eax,(%esp)
8010329d:	e8 2e 0b 00 00       	call   80103dd0 <wakeup>
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
801032a2:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
801032a8:	85 d2                	test   %edx,%edx
801032aa:	75 0a                	jne    801032b6 <pipeclose+0x46>
801032ac:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 32                	je     801032e8 <pipeclose+0x78>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032b6:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801032b9:	83 c4 10             	add    $0x10,%esp
801032bc:	5b                   	pop    %ebx
801032bd:	5e                   	pop    %esi
801032be:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
801032bf:	e9 dc 0f 00 00       	jmp    801042a0 <release>
801032c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
801032c8:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
801032ce:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
801032d5:	00 00 00 
    wakeup(&p->nwrite);
801032d8:	89 04 24             	mov    %eax,(%esp)
801032db:	e8 f0 0a 00 00       	call   80103dd0 <wakeup>
801032e0:	eb c0                	jmp    801032a2 <pipeclose+0x32>
801032e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
801032e8:	89 1c 24             	mov    %ebx,(%esp)
801032eb:	e8 b0 0f 00 00       	call   801042a0 <release>
    kfree((char*)p);
801032f0:	89 5d 08             	mov    %ebx,0x8(%ebp)
  } else
    release(&p->lock);
}
801032f3:	83 c4 10             	add    $0x10,%esp
801032f6:	5b                   	pop    %ebx
801032f7:	5e                   	pop    %esi
801032f8:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
801032f9:	e9 02 f0 ff ff       	jmp    80102300 <kfree>
801032fe:	66 90                	xchg   %ax,%ax

80103300 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103300:	55                   	push   %ebp
80103301:	89 e5                	mov    %esp,%ebp
80103303:	57                   	push   %edi
80103304:	56                   	push   %esi
80103305:	53                   	push   %ebx
80103306:	83 ec 1c             	sub    $0x1c,%esp
80103309:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010330c:	89 1c 24             	mov    %ebx,(%esp)
8010330f:	e8 1c 0f 00 00       	call   80104230 <acquire>
  for(i = 0; i < n; i++){
80103314:	8b 4d 10             	mov    0x10(%ebp),%ecx
80103317:	85 c9                	test   %ecx,%ecx
80103319:	0f 8e b2 00 00 00    	jle    801033d1 <pipewrite+0xd1>
8010331f:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
80103322:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
80103328:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
8010332e:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
80103334:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80103337:	03 4d 10             	add    0x10(%ebp),%ecx
8010333a:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
8010333d:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
80103343:	81 c1 00 02 00 00    	add    $0x200,%ecx
80103349:	39 c8                	cmp    %ecx,%eax
8010334b:	74 38                	je     80103385 <pipewrite+0x85>
8010334d:	eb 55                	jmp    801033a4 <pipewrite+0xa4>
8010334f:	90                   	nop
      if(p->readopen == 0 || myproc()->killed){
80103350:	e8 5b 03 00 00       	call   801036b0 <myproc>
80103355:	8b 40 24             	mov    0x24(%eax),%eax
80103358:	85 c0                	test   %eax,%eax
8010335a:	75 33                	jne    8010338f <pipewrite+0x8f>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
8010335c:	89 3c 24             	mov    %edi,(%esp)
8010335f:	e8 6c 0a 00 00       	call   80103dd0 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
80103364:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103368:	89 34 24             	mov    %esi,(%esp)
8010336b:	e8 c0 08 00 00       	call   80103c30 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103370:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103376:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010337c:	05 00 02 00 00       	add    $0x200,%eax
80103381:	39 c2                	cmp    %eax,%edx
80103383:	75 23                	jne    801033a8 <pipewrite+0xa8>
      if(p->readopen == 0 || myproc()->killed){
80103385:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010338b:	85 d2                	test   %edx,%edx
8010338d:	75 c1                	jne    80103350 <pipewrite+0x50>
        release(&p->lock);
8010338f:	89 1c 24             	mov    %ebx,(%esp)
80103392:	e8 09 0f 00 00       	call   801042a0 <release>
        return -1;
80103397:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
8010339c:	83 c4 1c             	add    $0x1c,%esp
8010339f:	5b                   	pop    %ebx
801033a0:	5e                   	pop    %esi
801033a1:	5f                   	pop    %edi
801033a2:	5d                   	pop    %ebp
801033a3:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033a4:	89 c2                	mov    %eax,%edx
801033a6:	66 90                	xchg   %ax,%ax
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
801033a8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033ab:	8d 42 01             	lea    0x1(%edx),%eax
801033ae:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
801033b4:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
801033ba:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
801033be:	0f b6 09             	movzbl (%ecx),%ecx
801033c1:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
801033c5:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
801033c8:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
801033cb:	0f 85 6c ff ff ff    	jne    8010333d <pipewrite+0x3d>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
801033d1:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
801033d7:	89 04 24             	mov    %eax,(%esp)
801033da:	e8 f1 09 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
801033df:	89 1c 24             	mov    %ebx,(%esp)
801033e2:	e8 b9 0e 00 00       	call   801042a0 <release>
  return n;
801033e7:	8b 45 10             	mov    0x10(%ebp),%eax
801033ea:	eb b0                	jmp    8010339c <pipewrite+0x9c>
801033ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801033f0 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
801033f0:	55                   	push   %ebp
801033f1:	89 e5                	mov    %esp,%ebp
801033f3:	57                   	push   %edi
801033f4:	56                   	push   %esi
801033f5:	53                   	push   %ebx
801033f6:	83 ec 1c             	sub    $0x1c,%esp
801033f9:	8b 75 08             	mov    0x8(%ebp),%esi
801033fc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
801033ff:	89 34 24             	mov    %esi,(%esp)
80103402:	e8 29 0e 00 00       	call   80104230 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103407:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010340d:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103413:	75 5b                	jne    80103470 <piperead+0x80>
80103415:	8b 9e 40 02 00 00    	mov    0x240(%esi),%ebx
8010341b:	85 db                	test   %ebx,%ebx
8010341d:	74 51                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
8010341f:	8d 9e 34 02 00 00    	lea    0x234(%esi),%ebx
80103425:	eb 25                	jmp    8010344c <piperead+0x5c>
80103427:	90                   	nop
80103428:	89 74 24 04          	mov    %esi,0x4(%esp)
8010342c:	89 1c 24             	mov    %ebx,(%esp)
8010342f:	e8 fc 07 00 00       	call   80103c30 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
80103434:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
8010343a:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
80103440:	75 2e                	jne    80103470 <piperead+0x80>
80103442:	8b 96 40 02 00 00    	mov    0x240(%esi),%edx
80103448:	85 d2                	test   %edx,%edx
8010344a:	74 24                	je     80103470 <piperead+0x80>
    if(myproc()->killed){
8010344c:	e8 5f 02 00 00       	call   801036b0 <myproc>
80103451:	8b 48 24             	mov    0x24(%eax),%ecx
80103454:	85 c9                	test   %ecx,%ecx
80103456:	74 d0                	je     80103428 <piperead+0x38>
      release(&p->lock);
80103458:	89 34 24             	mov    %esi,(%esp)
8010345b:	e8 40 0e 00 00       	call   801042a0 <release>
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103460:	83 c4 1c             	add    $0x1c,%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103463:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103468:	5b                   	pop    %ebx
80103469:	5e                   	pop    %esi
8010346a:	5f                   	pop    %edi
8010346b:	5d                   	pop    %ebp
8010346c:	c3                   	ret    
8010346d:	8d 76 00             	lea    0x0(%esi),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103470:	8b 55 10             	mov    0x10(%ebp),%edx
    if(p->nread == p->nwrite)
80103473:	31 db                	xor    %ebx,%ebx
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103475:	85 d2                	test   %edx,%edx
80103477:	7f 2b                	jg     801034a4 <piperead+0xb4>
80103479:	eb 31                	jmp    801034ac <piperead+0xbc>
8010347b:	90                   	nop
8010347c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103480:	8d 48 01             	lea    0x1(%eax),%ecx
80103483:	25 ff 01 00 00       	and    $0x1ff,%eax
80103488:	89 8e 34 02 00 00    	mov    %ecx,0x234(%esi)
8010348e:	0f b6 44 06 34       	movzbl 0x34(%esi,%eax,1),%eax
80103493:	88 04 1f             	mov    %al,(%edi,%ebx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103496:	83 c3 01             	add    $0x1,%ebx
80103499:	3b 5d 10             	cmp    0x10(%ebp),%ebx
8010349c:	74 0e                	je     801034ac <piperead+0xbc>
    if(p->nread == p->nwrite)
8010349e:	8b 86 34 02 00 00    	mov    0x234(%esi),%eax
801034a4:	3b 86 38 02 00 00    	cmp    0x238(%esi),%eax
801034aa:	75 d4                	jne    80103480 <piperead+0x90>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
801034ac:	8d 86 38 02 00 00    	lea    0x238(%esi),%eax
801034b2:	89 04 24             	mov    %eax,(%esp)
801034b5:	e8 16 09 00 00       	call   80103dd0 <wakeup>
  release(&p->lock);
801034ba:	89 34 24             	mov    %esi,(%esp)
801034bd:	e8 de 0d 00 00       	call   801042a0 <release>
  return i;
}
801034c2:	83 c4 1c             	add    $0x1c,%esp
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
801034c5:	89 d8                	mov    %ebx,%eax
}
801034c7:	5b                   	pop    %ebx
801034c8:	5e                   	pop    %esi
801034c9:	5f                   	pop    %edi
801034ca:	5d                   	pop    %ebp
801034cb:	c3                   	ret    
801034cc:	66 90                	xchg   %ax,%ax
801034ce:	66 90                	xchg   %ax,%ax

801034d0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d0:	55                   	push   %ebp
801034d1:	89 e5                	mov    %esp,%ebp
801034d3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034d4:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801034d9:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801034dc:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801034e3:	e8 48 0d 00 00       	call   80104230 <acquire>
801034e8:	eb 14                	jmp    801034fe <allocproc+0x2e>
801034ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801034f0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801034f6:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801034fc:	74 7a                	je     80103578 <allocproc+0xa8>
    if(p->state == UNUSED)
801034fe:	8b 43 0c             	mov    0xc(%ebx),%eax
80103501:	85 c0                	test   %eax,%eax
80103503:	75 eb                	jne    801034f0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
80103505:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
8010350a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
80103511:	c7 43 0c 01 00 00 00 	movl   $0x1,0xc(%ebx)
  p->pid = nextpid++;
80103518:	8d 50 01             	lea    0x1(%eax),%edx
8010351b:	89 15 04 a0 10 80    	mov    %edx,0x8010a004
80103521:	89 43 10             	mov    %eax,0x10(%ebx)

  release(&ptable.lock);
80103524:	e8 77 0d 00 00       	call   801042a0 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
80103529:	e8 82 ef ff ff       	call   801024b0 <kalloc>
8010352e:	85 c0                	test   %eax,%eax
80103530:	89 43 08             	mov    %eax,0x8(%ebx)
80103533:	74 57                	je     8010358c <allocproc+0xbc>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103535:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
8010353b:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
80103540:	89 53 18             	mov    %edx,0x18(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
80103543:	c7 40 14 39 58 10 80 	movl   $0x80105839,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
8010354a:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80103551:	00 
80103552:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103559:	00 
8010355a:	89 04 24             	mov    %eax,(%esp)
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010355d:	89 43 1c             	mov    %eax,0x1c(%ebx)
  memset(p->context, 0, sizeof *p->context);
80103560:	e8 8b 0d 00 00       	call   801042f0 <memset>
  p->context->eip = (uint)forkret;
80103565:	8b 43 1c             	mov    0x1c(%ebx),%eax
80103568:	c7 40 10 a0 35 10 80 	movl   $0x801035a0,0x10(%eax)

  return p;
8010356f:	89 d8                	mov    %ebx,%eax
}
80103571:	83 c4 14             	add    $0x14,%esp
80103574:	5b                   	pop    %ebx
80103575:	5d                   	pop    %ebp
80103576:	c3                   	ret    
80103577:	90                   	nop

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103578:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010357f:	e8 1c 0d 00 00       	call   801042a0 <release>
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103584:	83 c4 14             	add    $0x14,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
  return 0;
80103587:	31 c0                	xor    %eax,%eax
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  return p;
}
80103589:	5b                   	pop    %ebx
8010358a:	5d                   	pop    %ebp
8010358b:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010358c:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return 0;
80103593:	eb dc                	jmp    80103571 <allocproc+0xa1>
80103595:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103599:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801035a0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
801035a0:	55                   	push   %ebp
801035a1:	89 e5                	mov    %esp,%ebp
801035a3:	83 ec 18             	sub    $0x18,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
801035a6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801035ad:	e8 ee 0c 00 00       	call   801042a0 <release>

  if (first) {
801035b2:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801035b7:	85 c0                	test   %eax,%eax
801035b9:	75 05                	jne    801035c0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035bb:	c9                   	leave  
801035bc:	c3                   	ret    
801035bd:	8d 76 00             	lea    0x0(%esi),%esi
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801035c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801035c7:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801035ce:	00 00 00 
    iinit(ROOTDEV);
801035d1:	e8 aa de ff ff       	call   80101480 <iinit>
    initlog(ROOTDEV);
801035d6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801035dd:	e8 9e f4 ff ff       	call   80102a80 <initlog>
  }

  // Return to "caller", actually trapret (see allocproc).
}
801035e2:	c9                   	leave  
801035e3:	c3                   	ret    
801035e4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801035ea:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801035f0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801035f0:	55                   	push   %ebp
801035f1:	89 e5                	mov    %esp,%ebp
801035f3:	83 ec 18             	sub    $0x18,%esp
  initlock(&ptable.lock, "ptable");
801035f6:	c7 44 24 04 b5 75 10 	movl   $0x801075b5,0x4(%esp)
801035fd:	80 
801035fe:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103605:	e8 b6 0a 00 00       	call   801040c0 <initlock>
}
8010360a:	c9                   	leave  
8010360b:	c3                   	ret    
8010360c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80103610 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103610:	55                   	push   %ebp
80103611:	89 e5                	mov    %esp,%ebp
80103613:	56                   	push   %esi
80103614:	53                   	push   %ebx
80103615:	83 ec 10             	sub    $0x10,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103618:	9c                   	pushf  
80103619:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
8010361a:	f6 c4 02             	test   $0x2,%ah
8010361d:	75 57                	jne    80103676 <mycpu+0x66>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010361f:	e8 4c f1 ff ff       	call   80102770 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103624:	8b 35 00 2d 11 80    	mov    0x80112d00,%esi
8010362a:	85 f6                	test   %esi,%esi
8010362c:	7e 3c                	jle    8010366a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010362e:	0f b6 15 80 27 11 80 	movzbl 0x80112780,%edx
80103635:	39 c2                	cmp    %eax,%edx
80103637:	74 2d                	je     80103666 <mycpu+0x56>
80103639:	b9 30 28 11 80       	mov    $0x80112830,%ecx
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
8010363e:	31 d2                	xor    %edx,%edx
80103640:	83 c2 01             	add    $0x1,%edx
80103643:	39 f2                	cmp    %esi,%edx
80103645:	74 23                	je     8010366a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103647:	0f b6 19             	movzbl (%ecx),%ebx
8010364a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103650:	39 c3                	cmp    %eax,%ebx
80103652:	75 ec                	jne    80103640 <mycpu+0x30>
      return &cpus[i];
80103654:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010365a:	83 c4 10             	add    $0x10,%esp
8010365d:	5b                   	pop    %ebx
8010365e:	5e                   	pop    %esi
8010365f:	5d                   	pop    %ebp
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
80103660:	05 80 27 11 80       	add    $0x80112780,%eax
  }
  panic("unknown apicid\n");
}
80103665:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103666:	31 d2                	xor    %edx,%edx
80103668:	eb ea                	jmp    80103654 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010366a:	c7 04 24 bc 75 10 80 	movl   $0x801075bc,(%esp)
80103671:	e8 ea cc ff ff       	call   80100360 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103676:	c7 04 24 98 76 10 80 	movl   $0x80107698,(%esp)
8010367d:	e8 de cc ff ff       	call   80100360 <panic>
80103682:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103689:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103690 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103696:	e8 75 ff ff ff       	call   80103610 <mycpu>
}
8010369b:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
8010369c:	2d 80 27 11 80       	sub    $0x80112780,%eax
801036a1:	c1 f8 04             	sar    $0x4,%eax
801036a4:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
801036aa:	c3                   	ret    
801036ab:	90                   	nop
801036ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801036b0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801036b0:	55                   	push   %ebp
801036b1:	89 e5                	mov    %esp,%ebp
801036b3:	53                   	push   %ebx
801036b4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801036b7:	e8 84 0a 00 00       	call   80104140 <pushcli>
  c = mycpu();
801036bc:	e8 4f ff ff ff       	call   80103610 <mycpu>
  p = c->proc;
801036c1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801036c7:	e8 b4 0a 00 00       	call   80104180 <popcli>
  return p;
}
801036cc:	83 c4 04             	add    $0x4,%esp
801036cf:	89 d8                	mov    %ebx,%eax
801036d1:	5b                   	pop    %ebx
801036d2:	5d                   	pop    %ebp
801036d3:	c3                   	ret    
801036d4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801036da:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801036e0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	53                   	push   %ebx
801036e4:	83 ec 14             	sub    $0x14,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801036e7:	e8 e4 fd ff ff       	call   801034d0 <allocproc>
801036ec:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801036ee:	a3 b8 a5 10 80       	mov    %eax,0x8010a5b8
  if((p->pgdir = setupkvm()) == 0)
801036f3:	e8 b8 36 00 00       	call   80106db0 <setupkvm>
801036f8:	85 c0                	test   %eax,%eax
801036fa:	89 43 04             	mov    %eax,0x4(%ebx)
801036fd:	0f 84 d4 00 00 00    	je     801037d7 <userinit+0xf7>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
80103703:	89 04 24             	mov    %eax,(%esp)
80103706:	c7 44 24 08 2c 00 00 	movl   $0x2c,0x8(%esp)
8010370d:	00 
8010370e:	c7 44 24 04 60 a4 10 	movl   $0x8010a460,0x4(%esp)
80103715:	80 
80103716:	e8 c5 33 00 00       	call   80106ae0 <inituvm>
  p->sz = PGSIZE;
8010371b:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
80103721:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
80103728:	00 
80103729:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80103730:	00 
80103731:	8b 43 18             	mov    0x18(%ebx),%eax
80103734:	89 04 24             	mov    %eax,(%esp)
80103737:	e8 b4 0b 00 00       	call   801042f0 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010373c:	8b 43 18             	mov    0x18(%ebx),%eax
8010373f:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103744:	b9 23 00 00 00       	mov    $0x23,%ecx
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
80103749:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010374d:	8b 43 18             	mov    0x18(%ebx),%eax
80103750:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103754:	8b 43 18             	mov    0x18(%ebx),%eax
80103757:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010375b:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
8010375f:	8b 43 18             	mov    0x18(%ebx),%eax
80103762:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103766:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010376a:	8b 43 18             	mov    0x18(%ebx),%eax
8010376d:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103774:	8b 43 18             	mov    0x18(%ebx),%eax
80103777:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
8010377e:	8b 43 18             	mov    0x18(%ebx),%eax
80103781:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103788:	8d 43 6c             	lea    0x6c(%ebx),%eax
8010378b:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103792:	00 
80103793:	c7 44 24 04 e5 75 10 	movl   $0x801075e5,0x4(%esp)
8010379a:	80 
8010379b:	89 04 24             	mov    %eax,(%esp)
8010379e:	e8 2d 0d 00 00       	call   801044d0 <safestrcpy>
  p->cwd = namei("/");
801037a3:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
801037aa:	e8 61 e7 ff ff       	call   80101f10 <namei>
801037af:	89 43 68             	mov    %eax,0x68(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
801037b2:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037b9:	e8 72 0a 00 00       	call   80104230 <acquire>

  p->state = RUNNABLE;
801037be:	c7 43 0c 03 00 00 00 	movl   $0x3,0xc(%ebx)

  release(&ptable.lock);
801037c5:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
801037cc:	e8 cf 0a 00 00       	call   801042a0 <release>
}
801037d1:	83 c4 14             	add    $0x14,%esp
801037d4:	5b                   	pop    %ebx
801037d5:	5d                   	pop    %ebp
801037d6:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801037d7:	c7 04 24 cc 75 10 80 	movl   $0x801075cc,(%esp)
801037de:	e8 7d cb ff ff       	call   80100360 <panic>
801037e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801037f0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801037f0:	55                   	push   %ebp
801037f1:	89 e5                	mov    %esp,%ebp
801037f3:	56                   	push   %esi
801037f4:	53                   	push   %ebx
801037f5:	83 ec 10             	sub    $0x10,%esp
801037f8:	8b 75 08             	mov    0x8(%ebp),%esi
  uint sz;
  struct proc *curproc = myproc();
801037fb:	e8 b0 fe ff ff       	call   801036b0 <myproc>

  sz = curproc->sz;
  if(n > 0){
80103800:	83 fe 00             	cmp    $0x0,%esi
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();
80103803:	89 c3                	mov    %eax,%ebx

  sz = curproc->sz;
80103805:	8b 00                	mov    (%eax),%eax
  if(n > 0){
80103807:	7e 2f                	jle    80103838 <growproc+0x48>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
80103809:	01 c6                	add    %eax,%esi
8010380b:	89 74 24 08          	mov    %esi,0x8(%esp)
8010380f:	89 44 24 04          	mov    %eax,0x4(%esp)
80103813:	8b 43 04             	mov    0x4(%ebx),%eax
80103816:	89 04 24             	mov    %eax,(%esp)
80103819:	e8 02 34 00 00       	call   80106c20 <allocuvm>
8010381e:	85 c0                	test   %eax,%eax
80103820:	74 36                	je     80103858 <growproc+0x68>
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
80103822:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
80103824:	89 1c 24             	mov    %ebx,(%esp)
80103827:	e8 a4 31 00 00       	call   801069d0 <switchuvm>
  return 0;
8010382c:	31 c0                	xor    %eax,%eax
}
8010382e:	83 c4 10             	add    $0x10,%esp
80103831:	5b                   	pop    %ebx
80103832:	5e                   	pop    %esi
80103833:	5d                   	pop    %ebp
80103834:	c3                   	ret    
80103835:	8d 76 00             	lea    0x0(%esi),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103838:	74 e8                	je     80103822 <growproc+0x32>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010383a:	01 c6                	add    %eax,%esi
8010383c:	89 74 24 08          	mov    %esi,0x8(%esp)
80103840:	89 44 24 04          	mov    %eax,0x4(%esp)
80103844:	8b 43 04             	mov    0x4(%ebx),%eax
80103847:	89 04 24             	mov    %eax,(%esp)
8010384a:	e8 c1 34 00 00       	call   80106d10 <deallocuvm>
8010384f:	85 c0                	test   %eax,%eax
80103851:	75 cf                	jne    80103822 <growproc+0x32>
80103853:	90                   	nop
80103854:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103858:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010385d:	eb cf                	jmp    8010382e <growproc+0x3e>
8010385f:	90                   	nop

80103860 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103860:	55                   	push   %ebp
80103861:	89 e5                	mov    %esp,%ebp
80103863:	57                   	push   %edi
80103864:	56                   	push   %esi
80103865:	53                   	push   %ebx
80103866:	83 ec 1c             	sub    $0x1c,%esp
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();
80103869:	e8 42 fe ff ff       	call   801036b0 <myproc>
8010386e:	89 c3                	mov    %eax,%ebx

  // Allocate process.
  if((np = allocproc()) == 0){
80103870:	e8 5b fc ff ff       	call   801034d0 <allocproc>
80103875:	85 c0                	test   %eax,%eax
80103877:	89 c7                	mov    %eax,%edi
80103879:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010387c:	0f 84 c7 00 00 00    	je     80103949 <fork+0xe9>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103882:	8b 03                	mov    (%ebx),%eax
80103884:	89 44 24 04          	mov    %eax,0x4(%esp)
80103888:	8b 43 04             	mov    0x4(%ebx),%eax
8010388b:	89 04 24             	mov    %eax,(%esp)
8010388e:	e8 fd 35 00 00       	call   80106e90 <copyuvm>
80103893:	85 c0                	test   %eax,%eax
80103895:	89 47 04             	mov    %eax,0x4(%edi)
80103898:	0f 84 b2 00 00 00    	je     80103950 <fork+0xf0>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010389e:	8b 03                	mov    (%ebx),%eax
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038a0:	b9 13 00 00 00       	mov    $0x13,%ecx
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
801038a5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038a8:	89 07                	mov    %eax,(%edi)
  np->parent = curproc;
  *np->tf = *curproc->tf;
801038aa:	89 f8                	mov    %edi,%eax
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
  np->parent = curproc;
801038ac:	89 5f 14             	mov    %ebx,0x14(%edi)
  *np->tf = *curproc->tf;
801038af:	8b 7f 18             	mov    0x18(%edi),%edi
801038b2:	8b 73 18             	mov    0x18(%ebx),%esi
801038b5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038b7:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801038b9:	8b 40 18             	mov    0x18(%eax),%eax
801038bc:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
801038c3:	90                   	nop
801038c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801038c8:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
801038cc:	85 c0                	test   %eax,%eax
801038ce:	74 0f                	je     801038df <fork+0x7f>
      np->ofile[i] = filedup(curproc->ofile[i]);
801038d0:	89 04 24             	mov    %eax,(%esp)
801038d3:	e8 08 d5 ff ff       	call   80100de0 <filedup>
801038d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801038db:	89 44 b2 28          	mov    %eax,0x28(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801038df:	83 c6 01             	add    $0x1,%esi
801038e2:	83 fe 10             	cmp    $0x10,%esi
801038e5:	75 e1                	jne    801038c8 <fork+0x68>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038e7:	8b 43 68             	mov    0x68(%ebx),%eax

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038ea:	83 c3 6c             	add    $0x6c,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801038ed:	89 04 24             	mov    %eax,(%esp)
801038f0:	e8 9b dd ff ff       	call   80101690 <idup>
801038f5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
801038f8:	89 47 68             	mov    %eax,0x68(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801038fb:	8d 47 6c             	lea    0x6c(%edi),%eax
801038fe:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80103902:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80103909:	00 
8010390a:	89 04 24             	mov    %eax,(%esp)
8010390d:	e8 be 0b 00 00       	call   801044d0 <safestrcpy>

  pid = np->pid;
80103912:	8b 5f 10             	mov    0x10(%edi),%ebx

  acquire(&ptable.lock);
80103915:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010391c:	e8 0f 09 00 00       	call   80104230 <acquire>

  np->state = RUNNABLE;
  np->myticks = ticks;
80103921:	a1 a0 5b 11 80       	mov    0x80115ba0,%eax

  pid = np->pid;

  acquire(&ptable.lock);

  np->state = RUNNABLE;
80103926:	c7 47 0c 03 00 00 00 	movl   $0x3,0xc(%edi)
  np->myticks = ticks;
8010392d:	89 87 80 00 00 00    	mov    %eax,0x80(%edi)

  release(&ptable.lock);
80103933:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
8010393a:	e8 61 09 00 00       	call   801042a0 <release>

  return pid;
8010393f:	89 d8                	mov    %ebx,%eax
}
80103941:	83 c4 1c             	add    $0x1c,%esp
80103944:	5b                   	pop    %ebx
80103945:	5e                   	pop    %esi
80103946:	5f                   	pop    %edi
80103947:	5d                   	pop    %ebp
80103948:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103949:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010394e:	eb f1                	jmp    80103941 <fork+0xe1>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103950:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80103953:	8b 43 08             	mov    0x8(%ebx),%eax
80103956:	89 04 24             	mov    %eax,(%esp)
80103959:	e8 a2 e9 ff ff       	call   80102300 <kfree>
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
8010395e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
    np->kstack = 0;
80103963:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
    np->state = UNUSED;
8010396a:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
    return -1;
80103971:	eb ce                	jmp    80103941 <fork+0xe1>
80103973:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103979:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103980 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103980:	55                   	push   %ebp
80103981:	89 e5                	mov    %esp,%ebp
80103983:	57                   	push   %edi
80103984:	56                   	push   %esi
80103985:	53                   	push   %ebx
80103986:	83 ec 1c             	sub    $0x1c,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103989:	e8 82 fc ff ff       	call   80103610 <mycpu>
8010398e:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103990:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103997:	00 00 00 
8010399a:	8d 78 04             	lea    0x4(%eax),%edi
8010399d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
801039a0:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039a1:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039a8:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
801039ad:	e8 7e 08 00 00       	call   80104230 <acquire>
801039b2:	eb 12                	jmp    801039c6 <scheduler+0x46>
801039b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039b8:	81 c3 84 00 00 00    	add    $0x84,%ebx
801039be:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
801039c4:	74 4a                	je     80103a10 <scheduler+0x90>
      if(p->state != RUNNABLE)
801039c6:	83 7b 0c 03          	cmpl   $0x3,0xc(%ebx)
801039ca:	75 ec                	jne    801039b8 <scheduler+0x38>
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
801039cc:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
801039d2:	89 1c 24             	mov    %ebx,(%esp)
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039d5:	81 c3 84 00 00 00    	add    $0x84,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
801039db:	e8 f0 2f 00 00       	call   801069d0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
801039e0:	8b 43 98             	mov    -0x68(%ebx),%eax
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
801039e3:	c7 43 88 04 00 00 00 	movl   $0x4,-0x78(%ebx)

      swtch(&(c->scheduler), p->context);
801039ea:	89 3c 24             	mov    %edi,(%esp)
801039ed:	89 44 24 04          	mov    %eax,0x4(%esp)
801039f1:	e8 35 0b 00 00       	call   8010452b <swtch>
      switchkvm();
801039f6:	e8 b5 2f 00 00       	call   801069b0 <switchkvm>
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
801039fb:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103a01:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103a08:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a0b:	75 b9                	jne    801039c6 <scheduler+0x46>
80103a0d:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103a10:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103a17:	e8 84 08 00 00       	call   801042a0 <release>

  }
80103a1c:	eb 82                	jmp    801039a0 <scheduler+0x20>
80103a1e:	66 90                	xchg   %ax,%ax

80103a20 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103a20:	55                   	push   %ebp
80103a21:	89 e5                	mov    %esp,%ebp
80103a23:	56                   	push   %esi
80103a24:	53                   	push   %ebx
80103a25:	83 ec 10             	sub    $0x10,%esp
  int intena;
  struct proc *p = myproc();
80103a28:	e8 83 fc ff ff       	call   801036b0 <myproc>

  if(!holding(&ptable.lock))
80103a2d:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
// there's no process.
void
sched(void)
{
  int intena;
  struct proc *p = myproc();
80103a34:	89 c3                	mov    %eax,%ebx

  if(!holding(&ptable.lock))
80103a36:	e8 b5 07 00 00       	call   801041f0 <holding>
80103a3b:	85 c0                	test   %eax,%eax
80103a3d:	74 4f                	je     80103a8e <sched+0x6e>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103a3f:	e8 cc fb ff ff       	call   80103610 <mycpu>
80103a44:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103a4b:	75 65                	jne    80103ab2 <sched+0x92>
    panic("sched locks");
  if(p->state == RUNNING)
80103a4d:	83 7b 0c 04          	cmpl   $0x4,0xc(%ebx)
80103a51:	74 53                	je     80103aa6 <sched+0x86>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103a53:	9c                   	pushf  
80103a54:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103a55:	f6 c4 02             	test   $0x2,%ah
80103a58:	75 40                	jne    80103a9a <sched+0x7a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a5a:	e8 b1 fb ff ff       	call   80103610 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103a5f:	83 c3 1c             	add    $0x1c,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103a62:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103a68:	e8 a3 fb ff ff       	call   80103610 <mycpu>
80103a6d:	8b 40 04             	mov    0x4(%eax),%eax
80103a70:	89 1c 24             	mov    %ebx,(%esp)
80103a73:	89 44 24 04          	mov    %eax,0x4(%esp)
80103a77:	e8 af 0a 00 00       	call   8010452b <swtch>
  mycpu()->intena = intena;
80103a7c:	e8 8f fb ff ff       	call   80103610 <mycpu>
80103a81:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103a87:	83 c4 10             	add    $0x10,%esp
80103a8a:	5b                   	pop    %ebx
80103a8b:	5e                   	pop    %esi
80103a8c:	5d                   	pop    %ebp
80103a8d:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103a8e:	c7 04 24 f0 75 10 80 	movl   $0x801075f0,(%esp)
80103a95:	e8 c6 c8 ff ff       	call   80100360 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103a9a:	c7 04 24 1c 76 10 80 	movl   $0x8010761c,(%esp)
80103aa1:	e8 ba c8 ff ff       	call   80100360 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103aa6:	c7 04 24 0e 76 10 80 	movl   $0x8010760e,(%esp)
80103aad:	e8 ae c8 ff ff       	call   80100360 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103ab2:	c7 04 24 02 76 10 80 	movl   $0x80107602,(%esp)
80103ab9:	e8 a2 c8 ff ff       	call   80100360 <panic>
80103abe:	66 90                	xchg   %ax,%ax

80103ac0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ac0:	55                   	push   %ebp
80103ac1:	89 e5                	mov    %esp,%ebp
80103ac3:	56                   	push   %esi
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103ac4:	31 f6                	xor    %esi,%esi
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103ac6:	53                   	push   %ebx
80103ac7:	83 ec 10             	sub    $0x10,%esp
  struct proc *curproc = myproc();
80103aca:	e8 e1 fb ff ff       	call   801036b0 <myproc>
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103acf:	3b 05 b8 a5 10 80    	cmp    0x8010a5b8,%eax
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
  struct proc *curproc = myproc();
80103ad5:	89 c3                	mov    %eax,%ebx
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103ad7:	0f 84 fd 00 00 00    	je     80103bda <exit+0x11a>
80103add:	8d 76 00             	lea    0x0(%esi),%esi
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103ae0:	8b 44 b3 28          	mov    0x28(%ebx,%esi,4),%eax
80103ae4:	85 c0                	test   %eax,%eax
80103ae6:	74 10                	je     80103af8 <exit+0x38>
      fileclose(curproc->ofile[fd]);
80103ae8:	89 04 24             	mov    %eax,(%esp)
80103aeb:	e8 40 d3 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103af0:	c7 44 b3 28 00 00 00 	movl   $0x0,0x28(%ebx,%esi,4)
80103af7:	00 

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103af8:	83 c6 01             	add    $0x1,%esi
80103afb:	83 fe 10             	cmp    $0x10,%esi
80103afe:	75 e0                	jne    80103ae0 <exit+0x20>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103b00:	e8 1b f0 ff ff       	call   80102b20 <begin_op>
  iput(curproc->cwd);
80103b05:	8b 43 68             	mov    0x68(%ebx),%eax
80103b08:	89 04 24             	mov    %eax,(%esp)
80103b0b:	e8 d0 dc ff ff       	call   801017e0 <iput>
  end_op();
80103b10:	e8 7b f0 ff ff       	call   80102b90 <end_op>
  curproc->cwd = 0;
80103b15:	c7 43 68 00 00 00 00 	movl   $0x0,0x68(%ebx)

  acquire(&ptable.lock);
80103b1c:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103b23:	e8 08 07 00 00       	call   80104230 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103b28:	8b 43 14             	mov    0x14(%ebx),%eax
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b2b:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b30:	eb 14                	jmp    80103b46 <exit+0x86>
80103b32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80103b38:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b3e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b44:	74 20                	je     80103b66 <exit+0xa6>
    if(p->state == SLEEPING && p->chan == chan)
80103b46:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103b4a:	75 ec                	jne    80103b38 <exit+0x78>
80103b4c:	3b 42 20             	cmp    0x20(%edx),%eax
80103b4f:	75 e7                	jne    80103b38 <exit+0x78>
      p->state = RUNNABLE;
80103b51:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103b58:	81 c2 84 00 00 00    	add    $0x84,%edx
80103b5e:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103b64:	75 e0                	jne    80103b46 <exit+0x86>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b66:	a1 b8 a5 10 80       	mov    0x8010a5b8,%eax
80103b6b:	b9 54 2d 11 80       	mov    $0x80112d54,%ecx
80103b70:	eb 14                	jmp    80103b86 <exit+0xc6>
80103b72:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103b78:	81 c1 84 00 00 00    	add    $0x84,%ecx
80103b7e:	81 f9 54 4e 11 80    	cmp    $0x80114e54,%ecx
80103b84:	74 3c                	je     80103bc2 <exit+0x102>
    if(p->parent == curproc){
80103b86:	39 59 14             	cmp    %ebx,0x14(%ecx)
80103b89:	75 ed                	jne    80103b78 <exit+0xb8>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103b8b:	83 79 0c 05          	cmpl   $0x5,0xc(%ecx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103b8f:	89 41 14             	mov    %eax,0x14(%ecx)
      if(p->state == ZOMBIE)
80103b92:	75 e4                	jne    80103b78 <exit+0xb8>
80103b94:	ba 54 2d 11 80       	mov    $0x80112d54,%edx
80103b99:	eb 13                	jmp    80103bae <exit+0xee>
80103b9b:	90                   	nop
80103b9c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103ba0:	81 c2 84 00 00 00    	add    $0x84,%edx
80103ba6:	81 fa 54 4e 11 80    	cmp    $0x80114e54,%edx
80103bac:	74 ca                	je     80103b78 <exit+0xb8>
    if(p->state == SLEEPING && p->chan == chan)
80103bae:	83 7a 0c 02          	cmpl   $0x2,0xc(%edx)
80103bb2:	75 ec                	jne    80103ba0 <exit+0xe0>
80103bb4:	3b 42 20             	cmp    0x20(%edx),%eax
80103bb7:	75 e7                	jne    80103ba0 <exit+0xe0>
      p->state = RUNNABLE;
80103bb9:	c7 42 0c 03 00 00 00 	movl   $0x3,0xc(%edx)
80103bc0:	eb de                	jmp    80103ba0 <exit+0xe0>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103bc2:	c7 43 0c 05 00 00 00 	movl   $0x5,0xc(%ebx)
  sched();
80103bc9:	e8 52 fe ff ff       	call   80103a20 <sched>
  panic("zombie exit");
80103bce:	c7 04 24 3d 76 10 80 	movl   $0x8010763d,(%esp)
80103bd5:	e8 86 c7 ff ff       	call   80100360 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103bda:	c7 04 24 30 76 10 80 	movl   $0x80107630,(%esp)
80103be1:	e8 7a c7 ff ff       	call   80100360 <panic>
80103be6:	8d 76 00             	lea    0x0(%esi),%esi
80103be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103bf0 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103bf0:	55                   	push   %ebp
80103bf1:	89 e5                	mov    %esp,%ebp
80103bf3:	83 ec 18             	sub    $0x18,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103bf6:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103bfd:	e8 2e 06 00 00       	call   80104230 <acquire>
  myproc()->state = RUNNABLE;
80103c02:	e8 a9 fa ff ff       	call   801036b0 <myproc>
80103c07:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
  sched();
80103c0e:	e8 0d fe ff ff       	call   80103a20 <sched>
  release(&ptable.lock);
80103c13:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c1a:	e8 81 06 00 00       	call   801042a0 <release>
}
80103c1f:	c9                   	leave  
80103c20:	c3                   	ret    
80103c21:	eb 0d                	jmp    80103c30 <sleep>
80103c23:	90                   	nop
80103c24:	90                   	nop
80103c25:	90                   	nop
80103c26:	90                   	nop
80103c27:	90                   	nop
80103c28:	90                   	nop
80103c29:	90                   	nop
80103c2a:	90                   	nop
80103c2b:	90                   	nop
80103c2c:	90                   	nop
80103c2d:	90                   	nop
80103c2e:	90                   	nop
80103c2f:	90                   	nop

80103c30 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103c30:	55                   	push   %ebp
80103c31:	89 e5                	mov    %esp,%ebp
80103c33:	57                   	push   %edi
80103c34:	56                   	push   %esi
80103c35:	53                   	push   %ebx
80103c36:	83 ec 1c             	sub    $0x1c,%esp
80103c39:	8b 7d 08             	mov    0x8(%ebp),%edi
80103c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct proc *p = myproc();
80103c3f:	e8 6c fa ff ff       	call   801036b0 <myproc>
  
  if(p == 0)
80103c44:	85 c0                	test   %eax,%eax
// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
80103c46:	89 c3                	mov    %eax,%ebx
  
  if(p == 0)
80103c48:	0f 84 7c 00 00 00    	je     80103cca <sleep+0x9a>
    panic("sleep");

  if(lk == 0)
80103c4e:	85 f6                	test   %esi,%esi
80103c50:	74 6c                	je     80103cbe <sleep+0x8e>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103c52:	81 fe 20 2d 11 80    	cmp    $0x80112d20,%esi
80103c58:	74 46                	je     80103ca0 <sleep+0x70>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103c5a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c61:	e8 ca 05 00 00       	call   80104230 <acquire>
    release(lk);
80103c66:	89 34 24             	mov    %esi,(%esp)
80103c69:	e8 32 06 00 00       	call   801042a0 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103c6e:	89 7b 20             	mov    %edi,0x20(%ebx)
  p->state = SLEEPING;
80103c71:	c7 43 0c 02 00 00 00 	movl   $0x2,0xc(%ebx)

  sched();
80103c78:	e8 a3 fd ff ff       	call   80103a20 <sched>

  // Tidy up.
  p->chan = 0;
80103c7d:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103c84:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103c8b:	e8 10 06 00 00       	call   801042a0 <release>
    acquire(lk);
80103c90:	89 75 08             	mov    %esi,0x8(%ebp)
  }
}
80103c93:	83 c4 1c             	add    $0x1c,%esp
80103c96:	5b                   	pop    %ebx
80103c97:	5e                   	pop    %esi
80103c98:	5f                   	pop    %edi
80103c99:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103c9a:	e9 91 05 00 00       	jmp    80104230 <acquire>
80103c9f:	90                   	nop
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103ca0:	89 78 20             	mov    %edi,0x20(%eax)
  p->state = SLEEPING;
80103ca3:	c7 40 0c 02 00 00 00 	movl   $0x2,0xc(%eax)

  sched();
80103caa:	e8 71 fd ff ff       	call   80103a20 <sched>

  // Tidy up.
  p->chan = 0;
80103caf:	c7 43 20 00 00 00 00 	movl   $0x0,0x20(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103cb6:	83 c4 1c             	add    $0x1c,%esp
80103cb9:	5b                   	pop    %ebx
80103cba:	5e                   	pop    %esi
80103cbb:	5f                   	pop    %edi
80103cbc:	5d                   	pop    %ebp
80103cbd:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103cbe:	c7 04 24 4f 76 10 80 	movl   $0x8010764f,(%esp)
80103cc5:	e8 96 c6 ff ff       	call   80100360 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103cca:	c7 04 24 49 76 10 80 	movl   $0x80107649,(%esp)
80103cd1:	e8 8a c6 ff ff       	call   80100360 <panic>
80103cd6:	8d 76 00             	lea    0x0(%esi),%esi
80103cd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103ce0 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103ce0:	55                   	push   %ebp
80103ce1:	89 e5                	mov    %esp,%ebp
80103ce3:	56                   	push   %esi
80103ce4:	53                   	push   %ebx
80103ce5:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103ce8:	e8 c3 f9 ff ff       	call   801036b0 <myproc>
  
  acquire(&ptable.lock);
80103ced:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
int
wait(void)
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
80103cf4:	89 c6                	mov    %eax,%esi
  
  acquire(&ptable.lock);
80103cf6:	e8 35 05 00 00       	call   80104230 <acquire>
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103cfb:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103cfd:	bb 54 2d 11 80       	mov    $0x80112d54,%ebx
80103d02:	eb 12                	jmp    80103d16 <wait+0x36>
80103d04:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103d08:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103d0e:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d14:	74 22                	je     80103d38 <wait+0x58>
      if(p->parent != curproc)
80103d16:	39 73 14             	cmp    %esi,0x14(%ebx)
80103d19:	75 ed                	jne    80103d08 <wait+0x28>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103d1b:	83 7b 0c 05          	cmpl   $0x5,0xc(%ebx)
80103d1f:	74 34                	je     80103d55 <wait+0x75>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d21:	81 c3 84 00 00 00    	add    $0x84,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103d27:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103d2c:	81 fb 54 4e 11 80    	cmp    $0x80114e54,%ebx
80103d32:	75 e2                	jne    80103d16 <wait+0x36>
80103d34:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103d38:	85 c0                	test   %eax,%eax
80103d3a:	74 6e                	je     80103daa <wait+0xca>
80103d3c:	8b 46 24             	mov    0x24(%esi),%eax
80103d3f:	85 c0                	test   %eax,%eax
80103d41:	75 67                	jne    80103daa <wait+0xca>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103d43:	c7 44 24 04 20 2d 11 	movl   $0x80112d20,0x4(%esp)
80103d4a:	80 
80103d4b:	89 34 24             	mov    %esi,(%esp)
80103d4e:	e8 dd fe ff ff       	call   80103c30 <sleep>
  }
80103d53:	eb a6                	jmp    80103cfb <wait+0x1b>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103d55:	8b 43 08             	mov    0x8(%ebx),%eax
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103d58:	8b 73 10             	mov    0x10(%ebx),%esi
        kfree(p->kstack);
80103d5b:	89 04 24             	mov    %eax,(%esp)
80103d5e:	e8 9d e5 ff ff       	call   80102300 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103d63:	8b 43 04             	mov    0x4(%ebx),%eax
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103d66:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
        freevm(p->pgdir);
80103d6d:	89 04 24             	mov    %eax,(%esp)
80103d70:	e8 bb 2f 00 00       	call   80106d30 <freevm>
        p->pid = 0;
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
80103d75:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
        freevm(p->pgdir);
        p->pid = 0;
80103d7c:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        p->parent = 0;
80103d83:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        p->name[0] = 0;
80103d8a:	c6 43 6c 00          	movb   $0x0,0x6c(%ebx)
        p->killed = 0;
80103d8e:	c7 43 24 00 00 00 00 	movl   $0x0,0x24(%ebx)
        p->state = UNUSED;
80103d95:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
        release(&ptable.lock);
80103d9c:	e8 ff 04 00 00       	call   801042a0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103da1:	83 c4 10             	add    $0x10,%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103da4:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103da6:	5b                   	pop    %ebx
80103da7:	5e                   	pop    %esi
80103da8:	5d                   	pop    %ebp
80103da9:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103daa:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103db1:	e8 ea 04 00 00       	call   801042a0 <release>
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103db6:	83 c4 10             	add    $0x10,%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103db9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103dbe:	5b                   	pop    %ebx
80103dbf:	5e                   	pop    %esi
80103dc0:	5d                   	pop    %ebp
80103dc1:	c3                   	ret    
80103dc2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103dc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103dd0 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103dd0:	55                   	push   %ebp
80103dd1:	89 e5                	mov    %esp,%ebp
80103dd3:	53                   	push   %ebx
80103dd4:	83 ec 14             	sub    $0x14,%esp
80103dd7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103dda:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103de1:	e8 4a 04 00 00       	call   80104230 <acquire>
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103de6:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103deb:	eb 0f                	jmp    80103dfc <wakeup+0x2c>
80103ded:	8d 76 00             	lea    0x0(%esi),%esi
80103df0:	05 84 00 00 00       	add    $0x84,%eax
80103df5:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103dfa:	74 24                	je     80103e20 <wakeup+0x50>
    if(p->state == SLEEPING && p->chan == chan)
80103dfc:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
80103e00:	75 ee                	jne    80103df0 <wakeup+0x20>
80103e02:	3b 58 20             	cmp    0x20(%eax),%ebx
80103e05:	75 e9                	jne    80103df0 <wakeup+0x20>
      p->state = RUNNABLE;
80103e07:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103e0e:	05 84 00 00 00       	add    $0x84,%eax
80103e13:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e18:	75 e2                	jne    80103dfc <wakeup+0x2c>
80103e1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e20:	c7 45 08 20 2d 11 80 	movl   $0x80112d20,0x8(%ebp)
}
80103e27:	83 c4 14             	add    $0x14,%esp
80103e2a:	5b                   	pop    %ebx
80103e2b:	5d                   	pop    %ebp
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103e2c:	e9 6f 04 00 00       	jmp    801042a0 <release>
80103e31:	eb 0d                	jmp    80103e40 <kill>
80103e33:	90                   	nop
80103e34:	90                   	nop
80103e35:	90                   	nop
80103e36:	90                   	nop
80103e37:	90                   	nop
80103e38:	90                   	nop
80103e39:	90                   	nop
80103e3a:	90                   	nop
80103e3b:	90                   	nop
80103e3c:	90                   	nop
80103e3d:	90                   	nop
80103e3e:	90                   	nop
80103e3f:	90                   	nop

80103e40 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103e40:	55                   	push   %ebp
80103e41:	89 e5                	mov    %esp,%ebp
80103e43:	53                   	push   %ebx
80103e44:	83 ec 14             	sub    $0x14,%esp
80103e47:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103e4a:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e51:	e8 da 03 00 00       	call   80104230 <acquire>
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e56:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
80103e5b:	eb 0f                	jmp    80103e6c <kill+0x2c>
80103e5d:	8d 76 00             	lea    0x0(%esi),%esi
80103e60:	05 84 00 00 00       	add    $0x84,%eax
80103e65:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
80103e6a:	74 3c                	je     80103ea8 <kill+0x68>
    if(p->pid == pid){
80103e6c:	39 58 10             	cmp    %ebx,0x10(%eax)
80103e6f:	75 ef                	jne    80103e60 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e71:	83 78 0c 02          	cmpl   $0x2,0xc(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103e75:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103e7c:	74 1a                	je     80103e98 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103e7e:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103e85:	e8 16 04 00 00       	call   801042a0 <release>
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e8a:	83 c4 14             	add    $0x14,%esp
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
      release(&ptable.lock);
      return 0;
80103e8d:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103e8f:	5b                   	pop    %ebx
80103e90:	5d                   	pop    %ebp
80103e91:	c3                   	ret    
80103e92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103e98:	c7 40 0c 03 00 00 00 	movl   $0x3,0xc(%eax)
80103e9f:	eb dd                	jmp    80103e7e <kill+0x3e>
80103ea1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103ea8:	c7 04 24 20 2d 11 80 	movl   $0x80112d20,(%esp)
80103eaf:	e8 ec 03 00 00       	call   801042a0 <release>
  return -1;
}
80103eb4:	83 c4 14             	add    $0x14,%esp
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
  return -1;
80103eb7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103ebc:	5b                   	pop    %ebx
80103ebd:	5d                   	pop    %ebp
80103ebe:	c3                   	ret    
80103ebf:	90                   	nop

80103ec0 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80103ec0:	55                   	push   %ebp
80103ec1:	89 e5                	mov    %esp,%ebp
80103ec3:	57                   	push   %edi
80103ec4:	56                   	push   %esi
80103ec5:	53                   	push   %ebx
80103ec6:	bb c0 2d 11 80       	mov    $0x80112dc0,%ebx
80103ecb:	83 ec 4c             	sub    $0x4c,%esp
80103ece:	8d 75 e8             	lea    -0x18(%ebp),%esi
80103ed1:	eb 23                	jmp    80103ef6 <procdump+0x36>
80103ed3:	90                   	nop
80103ed4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80103ed8:	c7 04 24 5b 7b 10 80 	movl   $0x80107b5b,(%esp)
80103edf:	e8 6c c7 ff ff       	call   80100650 <cprintf>
80103ee4:	81 c3 84 00 00 00    	add    $0x84,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103eea:	81 fb c0 4e 11 80    	cmp    $0x80114ec0,%ebx
80103ef0:	0f 84 8a 00 00 00    	je     80103f80 <procdump+0xc0>
    if(p->state == UNUSED)
80103ef6:	8b 43 a0             	mov    -0x60(%ebx),%eax
80103ef9:	85 c0                	test   %eax,%eax
80103efb:	74 e7                	je     80103ee4 <procdump+0x24>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103efd:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80103f00:	ba 60 76 10 80       	mov    $0x80107660,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80103f05:	77 11                	ja     80103f18 <procdump+0x58>
80103f07:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80103f0e:	b8 60 76 10 80       	mov    $0x80107660,%eax
80103f13:	85 d2                	test   %edx,%edx
80103f15:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
80103f18:	8b 43 a4             	mov    -0x5c(%ebx),%eax
80103f1b:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
80103f1f:	89 54 24 08          	mov    %edx,0x8(%esp)
80103f23:	c7 04 24 64 76 10 80 	movl   $0x80107664,(%esp)
80103f2a:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f2e:	e8 1d c7 ff ff       	call   80100650 <cprintf>
    if(p->state == SLEEPING){
80103f33:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80103f37:	75 9f                	jne    80103ed8 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80103f39:	8d 45 c0             	lea    -0x40(%ebp),%eax
80103f3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80103f40:	8b 43 b0             	mov    -0x50(%ebx),%eax
80103f43:	8d 7d c0             	lea    -0x40(%ebp),%edi
80103f46:	8b 40 0c             	mov    0xc(%eax),%eax
80103f49:	83 c0 08             	add    $0x8,%eax
80103f4c:	89 04 24             	mov    %eax,(%esp)
80103f4f:	e8 8c 01 00 00       	call   801040e0 <getcallerpcs>
80103f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      for(i=0; i<10 && pc[i] != 0; i++)
80103f58:	8b 17                	mov    (%edi),%edx
80103f5a:	85 d2                	test   %edx,%edx
80103f5c:	0f 84 76 ff ff ff    	je     80103ed8 <procdump+0x18>
        cprintf(" %p", pc[i]);
80103f62:	89 54 24 04          	mov    %edx,0x4(%esp)
80103f66:	83 c7 04             	add    $0x4,%edi
80103f69:	c7 04 24 a1 70 10 80 	movl   $0x801070a1,(%esp)
80103f70:	e8 db c6 ff ff       	call   80100650 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
80103f75:	39 f7                	cmp    %esi,%edi
80103f77:	75 df                	jne    80103f58 <procdump+0x98>
80103f79:	e9 5a ff ff ff       	jmp    80103ed8 <procdump+0x18>
80103f7e:	66 90                	xchg   %ax,%ax
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
}
80103f80:	83 c4 4c             	add    $0x4c,%esp
80103f83:	5b                   	pop    %ebx
80103f84:	5e                   	pop    %esi
80103f85:	5f                   	pop    %edi
80103f86:	5d                   	pop    %ebp
80103f87:	c3                   	ret    
80103f88:	66 90                	xchg   %ax,%ax
80103f8a:	66 90                	xchg   %ax,%ax
80103f8c:	66 90                	xchg   %ax,%ax
80103f8e:	66 90                	xchg   %ax,%ax

80103f90 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
80103f90:	55                   	push   %ebp
80103f91:	89 e5                	mov    %esp,%ebp
80103f93:	53                   	push   %ebx
80103f94:	83 ec 14             	sub    $0x14,%esp
80103f97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
80103f9a:	c7 44 24 04 d8 76 10 	movl   $0x801076d8,0x4(%esp)
80103fa1:	80 
80103fa2:	8d 43 04             	lea    0x4(%ebx),%eax
80103fa5:	89 04 24             	mov    %eax,(%esp)
80103fa8:	e8 13 01 00 00       	call   801040c0 <initlock>
  lk->name = name;
80103fad:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
80103fb0:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
80103fb6:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
80103fbd:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
80103fc0:	83 c4 14             	add    $0x14,%esp
80103fc3:	5b                   	pop    %ebx
80103fc4:	5d                   	pop    %ebp
80103fc5:	c3                   	ret    
80103fc6:	8d 76 00             	lea    0x0(%esi),%esi
80103fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103fd0 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80103fd0:	55                   	push   %ebp
80103fd1:	89 e5                	mov    %esp,%ebp
80103fd3:	56                   	push   %esi
80103fd4:	53                   	push   %ebx
80103fd5:	83 ec 10             	sub    $0x10,%esp
80103fd8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80103fdb:	8d 73 04             	lea    0x4(%ebx),%esi
80103fde:	89 34 24             	mov    %esi,(%esp)
80103fe1:	e8 4a 02 00 00       	call   80104230 <acquire>
  while (lk->locked) {
80103fe6:	8b 13                	mov    (%ebx),%edx
80103fe8:	85 d2                	test   %edx,%edx
80103fea:	74 16                	je     80104002 <acquiresleep+0x32>
80103fec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sleep(lk, &lk->lk);
80103ff0:	89 74 24 04          	mov    %esi,0x4(%esp)
80103ff4:	89 1c 24             	mov    %ebx,(%esp)
80103ff7:	e8 34 fc ff ff       	call   80103c30 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
80103ffc:	8b 03                	mov    (%ebx),%eax
80103ffe:	85 c0                	test   %eax,%eax
80104000:	75 ee                	jne    80103ff0 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104002:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104008:	e8 a3 f6 ff ff       	call   801036b0 <myproc>
8010400d:	8b 40 10             	mov    0x10(%eax),%eax
80104010:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104013:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104016:	83 c4 10             	add    $0x10,%esp
80104019:	5b                   	pop    %ebx
8010401a:	5e                   	pop    %esi
8010401b:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010401c:	e9 7f 02 00 00       	jmp    801042a0 <release>
80104021:	eb 0d                	jmp    80104030 <releasesleep>
80104023:	90                   	nop
80104024:	90                   	nop
80104025:	90                   	nop
80104026:	90                   	nop
80104027:	90                   	nop
80104028:	90                   	nop
80104029:	90                   	nop
8010402a:	90                   	nop
8010402b:	90                   	nop
8010402c:	90                   	nop
8010402d:	90                   	nop
8010402e:	90                   	nop
8010402f:	90                   	nop

80104030 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104030:	55                   	push   %ebp
80104031:	89 e5                	mov    %esp,%ebp
80104033:	56                   	push   %esi
80104034:	53                   	push   %ebx
80104035:	83 ec 10             	sub    $0x10,%esp
80104038:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
8010403b:	8d 73 04             	lea    0x4(%ebx),%esi
8010403e:	89 34 24             	mov    %esi,(%esp)
80104041:	e8 ea 01 00 00       	call   80104230 <acquire>
  lk->locked = 0;
80104046:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010404c:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104053:	89 1c 24             	mov    %ebx,(%esp)
80104056:	e8 75 fd ff ff       	call   80103dd0 <wakeup>
  release(&lk->lk);
8010405b:	89 75 08             	mov    %esi,0x8(%ebp)
}
8010405e:	83 c4 10             	add    $0x10,%esp
80104061:	5b                   	pop    %ebx
80104062:	5e                   	pop    %esi
80104063:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104064:	e9 37 02 00 00       	jmp    801042a0 <release>
80104069:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104070 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
80104070:	55                   	push   %ebp
80104071:	89 e5                	mov    %esp,%ebp
80104073:	57                   	push   %edi
  int r;
  
  acquire(&lk->lk);
  r = lk->locked && (lk->pid == myproc()->pid);
80104074:	31 ff                	xor    %edi,%edi
  release(&lk->lk);
}

int
holdingsleep(struct sleeplock *lk)
{
80104076:	56                   	push   %esi
80104077:	53                   	push   %ebx
80104078:	83 ec 1c             	sub    $0x1c,%esp
8010407b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
8010407e:	8d 73 04             	lea    0x4(%ebx),%esi
80104081:	89 34 24             	mov    %esi,(%esp)
80104084:	e8 a7 01 00 00       	call   80104230 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
80104089:	8b 03                	mov    (%ebx),%eax
8010408b:	85 c0                	test   %eax,%eax
8010408d:	74 13                	je     801040a2 <holdingsleep+0x32>
8010408f:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
80104092:	e8 19 f6 ff ff       	call   801036b0 <myproc>
80104097:	3b 58 10             	cmp    0x10(%eax),%ebx
8010409a:	0f 94 c0             	sete   %al
8010409d:	0f b6 c0             	movzbl %al,%eax
801040a0:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801040a2:	89 34 24             	mov    %esi,(%esp)
801040a5:	e8 f6 01 00 00       	call   801042a0 <release>
  return r;
}
801040aa:	83 c4 1c             	add    $0x1c,%esp
801040ad:	89 f8                	mov    %edi,%eax
801040af:	5b                   	pop    %ebx
801040b0:	5e                   	pop    %esi
801040b1:	5f                   	pop    %edi
801040b2:	5d                   	pop    %ebp
801040b3:	c3                   	ret    
801040b4:	66 90                	xchg   %ax,%ax
801040b6:	66 90                	xchg   %ax,%ax
801040b8:	66 90                	xchg   %ax,%ax
801040ba:	66 90                	xchg   %ax,%ax
801040bc:	66 90                	xchg   %ax,%ax
801040be:	66 90                	xchg   %ax,%ax

801040c0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801040c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801040c9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801040cf:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
801040d2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
801040d9:	5d                   	pop    %ebp
801040da:	c3                   	ret    
801040db:	90                   	nop
801040dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801040e0 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040e0:	55                   	push   %ebp
801040e1:	89 e5                	mov    %esp,%ebp
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040e3:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
801040e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801040e9:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
801040ea:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
801040ed:	31 c0                	xor    %eax,%eax
801040ef:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801040f0:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801040f6:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801040fc:	77 1a                	ja     80104118 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
801040fe:	8b 5a 04             	mov    0x4(%edx),%ebx
80104101:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104104:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104107:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104109:	83 f8 0a             	cmp    $0xa,%eax
8010410c:	75 e2                	jne    801040f0 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010410e:	5b                   	pop    %ebx
8010410f:	5d                   	pop    %ebp
80104110:	c3                   	ret    
80104111:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104118:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010411f:	83 c0 01             	add    $0x1,%eax
80104122:	83 f8 0a             	cmp    $0xa,%eax
80104125:	74 e7                	je     8010410e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104127:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010412e:	83 c0 01             	add    $0x1,%eax
80104131:	83 f8 0a             	cmp    $0xa,%eax
80104134:	75 e2                	jne    80104118 <getcallerpcs+0x38>
80104136:	eb d6                	jmp    8010410e <getcallerpcs+0x2e>
80104138:	90                   	nop
80104139:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104140 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104140:	55                   	push   %ebp
80104141:	89 e5                	mov    %esp,%ebp
80104143:	53                   	push   %ebx
80104144:	83 ec 04             	sub    $0x4,%esp
80104147:	9c                   	pushf  
80104148:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104149:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010414a:	e8 c1 f4 ff ff       	call   80103610 <mycpu>
8010414f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104155:	85 c0                	test   %eax,%eax
80104157:	75 11                	jne    8010416a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104159:	e8 b2 f4 ff ff       	call   80103610 <mycpu>
8010415e:	81 e3 00 02 00 00    	and    $0x200,%ebx
80104164:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010416a:	e8 a1 f4 ff ff       	call   80103610 <mycpu>
8010416f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
80104176:	83 c4 04             	add    $0x4,%esp
80104179:	5b                   	pop    %ebx
8010417a:	5d                   	pop    %ebp
8010417b:	c3                   	ret    
8010417c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104180 <popcli>:

void
popcli(void)
{
80104180:	55                   	push   %ebp
80104181:	89 e5                	mov    %esp,%ebp
80104183:	83 ec 18             	sub    $0x18,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80104186:	9c                   	pushf  
80104187:	58                   	pop    %eax
  if(readeflags()&FL_IF)
80104188:	f6 c4 02             	test   $0x2,%ah
8010418b:	75 49                	jne    801041d6 <popcli+0x56>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
8010418d:	e8 7e f4 ff ff       	call   80103610 <mycpu>
80104192:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
80104198:	8d 51 ff             	lea    -0x1(%ecx),%edx
8010419b:	85 d2                	test   %edx,%edx
8010419d:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801041a3:	78 25                	js     801041ca <popcli+0x4a>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041a5:	e8 66 f4 ff ff       	call   80103610 <mycpu>
801041aa:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801041b0:	85 d2                	test   %edx,%edx
801041b2:	74 04                	je     801041b8 <popcli+0x38>
    sti();
}
801041b4:	c9                   	leave  
801041b5:	c3                   	ret    
801041b6:	66 90                	xchg   %ax,%ax
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801041b8:	e8 53 f4 ff ff       	call   80103610 <mycpu>
801041bd:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801041c3:	85 c0                	test   %eax,%eax
801041c5:	74 ed                	je     801041b4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801041c7:	fb                   	sti    
    sti();
}
801041c8:	c9                   	leave  
801041c9:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
801041ca:	c7 04 24 fa 76 10 80 	movl   $0x801076fa,(%esp)
801041d1:	e8 8a c1 ff ff       	call   80100360 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
801041d6:	c7 04 24 e3 76 10 80 	movl   $0x801076e3,(%esp)
801041dd:	e8 7e c1 ff ff       	call   80100360 <panic>
801041e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801041e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801041f0 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	56                   	push   %esi
  int r;
  pushcli();
  r = lock->locked && lock->cpu == mycpu();
801041f4:	31 f6                	xor    %esi,%esi
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
801041f6:	53                   	push   %ebx
801041f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  pushcli();
801041fa:	e8 41 ff ff ff       	call   80104140 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
801041ff:	8b 03                	mov    (%ebx),%eax
80104201:	85 c0                	test   %eax,%eax
80104203:	74 12                	je     80104217 <holding+0x27>
80104205:	8b 5b 08             	mov    0x8(%ebx),%ebx
80104208:	e8 03 f4 ff ff       	call   80103610 <mycpu>
8010420d:	39 c3                	cmp    %eax,%ebx
8010420f:	0f 94 c0             	sete   %al
80104212:	0f b6 c0             	movzbl %al,%eax
80104215:	89 c6                	mov    %eax,%esi
  popcli();
80104217:	e8 64 ff ff ff       	call   80104180 <popcli>
  return r;
}
8010421c:	89 f0                	mov    %esi,%eax
8010421e:	5b                   	pop    %ebx
8010421f:	5e                   	pop    %esi
80104220:	5d                   	pop    %ebp
80104221:	c3                   	ret    
80104222:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104229:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104230 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104230:	55                   	push   %ebp
80104231:	89 e5                	mov    %esp,%ebp
80104233:	53                   	push   %ebx
80104234:	83 ec 14             	sub    $0x14,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104237:	e8 04 ff ff ff       	call   80104140 <pushcli>
  if(holding(lk))
8010423c:	8b 45 08             	mov    0x8(%ebp),%eax
8010423f:	89 04 24             	mov    %eax,(%esp)
80104242:	e8 a9 ff ff ff       	call   801041f0 <holding>
80104247:	85 c0                	test   %eax,%eax
80104249:	75 3c                	jne    80104287 <acquire+0x57>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
8010424b:	b9 01 00 00 00       	mov    $0x1,%ecx
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104250:	8b 55 08             	mov    0x8(%ebp),%edx
80104253:	89 c8                	mov    %ecx,%eax
80104255:	f0 87 02             	lock xchg %eax,(%edx)
80104258:	85 c0                	test   %eax,%eax
8010425a:	75 f4                	jne    80104250 <acquire+0x20>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010425c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104261:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104264:	e8 a7 f3 ff ff       	call   80103610 <mycpu>
80104269:	89 43 08             	mov    %eax,0x8(%ebx)
  getcallerpcs(&lk, lk->pcs);
8010426c:	8b 45 08             	mov    0x8(%ebp),%eax
8010426f:	83 c0 0c             	add    $0xc,%eax
80104272:	89 44 24 04          	mov    %eax,0x4(%esp)
80104276:	8d 45 08             	lea    0x8(%ebp),%eax
80104279:	89 04 24             	mov    %eax,(%esp)
8010427c:	e8 5f fe ff ff       	call   801040e0 <getcallerpcs>
}
80104281:	83 c4 14             	add    $0x14,%esp
80104284:	5b                   	pop    %ebx
80104285:	5d                   	pop    %ebp
80104286:	c3                   	ret    
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
80104287:	c7 04 24 01 77 10 80 	movl   $0x80107701,(%esp)
8010428e:	e8 cd c0 ff ff       	call   80100360 <panic>
80104293:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801042a0 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
801042a0:	55                   	push   %ebp
801042a1:	89 e5                	mov    %esp,%ebp
801042a3:	53                   	push   %ebx
801042a4:	83 ec 14             	sub    $0x14,%esp
801042a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
801042aa:	89 1c 24             	mov    %ebx,(%esp)
801042ad:	e8 3e ff ff ff       	call   801041f0 <holding>
801042b2:	85 c0                	test   %eax,%eax
801042b4:	74 23                	je     801042d9 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
801042b6:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
801042bd:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
801042c4:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
801042c9:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
801042cf:	83 c4 14             	add    $0x14,%esp
801042d2:	5b                   	pop    %ebx
801042d3:	5d                   	pop    %ebp
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
801042d4:	e9 a7 fe ff ff       	jmp    80104180 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
801042d9:	c7 04 24 09 77 10 80 	movl   $0x80107709,(%esp)
801042e0:	e8 7b c0 ff ff       	call   80100360 <panic>
801042e5:	66 90                	xchg   %ax,%ax
801042e7:	66 90                	xchg   %ax,%ax
801042e9:	66 90                	xchg   %ax,%ax
801042eb:	66 90                	xchg   %ax,%ax
801042ed:	66 90                	xchg   %ax,%ax
801042ef:	90                   	nop

801042f0 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
801042f0:	55                   	push   %ebp
801042f1:	89 e5                	mov    %esp,%ebp
801042f3:	8b 55 08             	mov    0x8(%ebp),%edx
801042f6:	57                   	push   %edi
801042f7:	8b 4d 10             	mov    0x10(%ebp),%ecx
801042fa:	53                   	push   %ebx
  if ((int)dst%4 == 0 && n%4 == 0){
801042fb:	f6 c2 03             	test   $0x3,%dl
801042fe:	75 05                	jne    80104305 <memset+0x15>
80104300:	f6 c1 03             	test   $0x3,%cl
80104303:	74 13                	je     80104318 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104305:	89 d7                	mov    %edx,%edi
80104307:	8b 45 0c             	mov    0xc(%ebp),%eax
8010430a:	fc                   	cld    
8010430b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010430d:	5b                   	pop    %ebx
8010430e:	89 d0                	mov    %edx,%eax
80104310:	5f                   	pop    %edi
80104311:	5d                   	pop    %ebp
80104312:	c3                   	ret    
80104313:	90                   	nop
80104314:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104318:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
8010431c:	c1 e9 02             	shr    $0x2,%ecx
8010431f:	89 f8                	mov    %edi,%eax
80104321:	89 fb                	mov    %edi,%ebx
80104323:	c1 e0 18             	shl    $0x18,%eax
80104326:	c1 e3 10             	shl    $0x10,%ebx
80104329:	09 d8                	or     %ebx,%eax
8010432b:	09 f8                	or     %edi,%eax
8010432d:	c1 e7 08             	shl    $0x8,%edi
80104330:	09 f8                	or     %edi,%eax
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
80104332:	89 d7                	mov    %edx,%edi
80104334:	fc                   	cld    
80104335:	f3 ab                	rep stos %eax,%es:(%edi)
  } else
    stosb(dst, c, n);
  return dst;
}
80104337:	5b                   	pop    %ebx
80104338:	89 d0                	mov    %edx,%eax
8010433a:	5f                   	pop    %edi
8010433b:	5d                   	pop    %ebp
8010433c:	c3                   	ret    
8010433d:	8d 76 00             	lea    0x0(%esi),%esi

80104340 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
80104340:	55                   	push   %ebp
80104341:	89 e5                	mov    %esp,%ebp
80104343:	8b 45 10             	mov    0x10(%ebp),%eax
80104346:	57                   	push   %edi
80104347:	56                   	push   %esi
80104348:	8b 75 0c             	mov    0xc(%ebp),%esi
8010434b:	53                   	push   %ebx
8010434c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
8010434f:	85 c0                	test   %eax,%eax
80104351:	8d 78 ff             	lea    -0x1(%eax),%edi
80104354:	74 26                	je     8010437c <memcmp+0x3c>
    if(*s1 != *s2)
80104356:	0f b6 03             	movzbl (%ebx),%eax
80104359:	31 d2                	xor    %edx,%edx
8010435b:	0f b6 0e             	movzbl (%esi),%ecx
8010435e:	38 c8                	cmp    %cl,%al
80104360:	74 16                	je     80104378 <memcmp+0x38>
80104362:	eb 24                	jmp    80104388 <memcmp+0x48>
80104364:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104368:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
8010436d:	83 c2 01             	add    $0x1,%edx
80104370:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104374:	38 c8                	cmp    %cl,%al
80104376:	75 10                	jne    80104388 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
80104378:	39 fa                	cmp    %edi,%edx
8010437a:	75 ec                	jne    80104368 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
8010437c:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
8010437d:	31 c0                	xor    %eax,%eax
}
8010437f:	5e                   	pop    %esi
80104380:	5f                   	pop    %edi
80104381:	5d                   	pop    %ebp
80104382:	c3                   	ret    
80104383:	90                   	nop
80104384:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104388:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
80104389:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
8010438b:	5e                   	pop    %esi
8010438c:	5f                   	pop    %edi
8010438d:	5d                   	pop    %ebp
8010438e:	c3                   	ret    
8010438f:	90                   	nop

80104390 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104390:	55                   	push   %ebp
80104391:	89 e5                	mov    %esp,%ebp
80104393:	57                   	push   %edi
80104394:	8b 45 08             	mov    0x8(%ebp),%eax
80104397:	56                   	push   %esi
80104398:	8b 75 0c             	mov    0xc(%ebp),%esi
8010439b:	53                   	push   %ebx
8010439c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010439f:	39 c6                	cmp    %eax,%esi
801043a1:	73 35                	jae    801043d8 <memmove+0x48>
801043a3:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
801043a6:	39 c8                	cmp    %ecx,%eax
801043a8:	73 2e                	jae    801043d8 <memmove+0x48>
    s += n;
    d += n;
    while(n-- > 0)
801043aa:	85 db                	test   %ebx,%ebx

  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
801043ac:	8d 3c 18             	lea    (%eax,%ebx,1),%edi
    while(n-- > 0)
801043af:	8d 53 ff             	lea    -0x1(%ebx),%edx
801043b2:	74 1b                	je     801043cf <memmove+0x3f>
801043b4:	f7 db                	neg    %ebx
801043b6:	8d 34 19             	lea    (%ecx,%ebx,1),%esi
801043b9:	01 fb                	add    %edi,%ebx
801043bb:	90                   	nop
801043bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      *--d = *--s;
801043c0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043c4:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
801043c7:	83 ea 01             	sub    $0x1,%edx
801043ca:	83 fa ff             	cmp    $0xffffffff,%edx
801043cd:	75 f1                	jne    801043c0 <memmove+0x30>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
801043cf:	5b                   	pop    %ebx
801043d0:	5e                   	pop    %esi
801043d1:	5f                   	pop    %edi
801043d2:	5d                   	pop    %ebp
801043d3:	c3                   	ret    
801043d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043d8:	31 d2                	xor    %edx,%edx
801043da:	85 db                	test   %ebx,%ebx
801043dc:	74 f1                	je     801043cf <memmove+0x3f>
801043de:	66 90                	xchg   %ax,%ax
      *d++ = *s++;
801043e0:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
801043e4:	88 0c 10             	mov    %cl,(%eax,%edx,1)
801043e7:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
801043ea:	39 da                	cmp    %ebx,%edx
801043ec:	75 f2                	jne    801043e0 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
801043ee:	5b                   	pop    %ebx
801043ef:	5e                   	pop    %esi
801043f0:	5f                   	pop    %edi
801043f1:	5d                   	pop    %ebp
801043f2:	c3                   	ret    
801043f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801043f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104400 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104403:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104404:	e9 87 ff ff ff       	jmp    80104390 <memmove>
80104409:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104410 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104410:	55                   	push   %ebp
80104411:	89 e5                	mov    %esp,%ebp
80104413:	56                   	push   %esi
80104414:	8b 75 10             	mov    0x10(%ebp),%esi
80104417:	53                   	push   %ebx
80104418:	8b 4d 08             	mov    0x8(%ebp),%ecx
8010441b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  while(n > 0 && *p && *p == *q)
8010441e:	85 f6                	test   %esi,%esi
80104420:	74 30                	je     80104452 <strncmp+0x42>
80104422:	0f b6 01             	movzbl (%ecx),%eax
80104425:	84 c0                	test   %al,%al
80104427:	74 2f                	je     80104458 <strncmp+0x48>
80104429:	0f b6 13             	movzbl (%ebx),%edx
8010442c:	38 d0                	cmp    %dl,%al
8010442e:	75 46                	jne    80104476 <strncmp+0x66>
80104430:	8d 51 01             	lea    0x1(%ecx),%edx
80104433:	01 ce                	add    %ecx,%esi
80104435:	eb 14                	jmp    8010444b <strncmp+0x3b>
80104437:	90                   	nop
80104438:	0f b6 02             	movzbl (%edx),%eax
8010443b:	84 c0                	test   %al,%al
8010443d:	74 31                	je     80104470 <strncmp+0x60>
8010443f:	0f b6 19             	movzbl (%ecx),%ebx
80104442:	83 c2 01             	add    $0x1,%edx
80104445:	38 d8                	cmp    %bl,%al
80104447:	75 17                	jne    80104460 <strncmp+0x50>
    n--, p++, q++;
80104449:	89 cb                	mov    %ecx,%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010444b:	39 f2                	cmp    %esi,%edx
    n--, p++, q++;
8010444d:	8d 4b 01             	lea    0x1(%ebx),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104450:	75 e6                	jne    80104438 <strncmp+0x28>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
80104452:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
80104453:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
80104455:	5e                   	pop    %esi
80104456:	5d                   	pop    %ebp
80104457:	c3                   	ret    
80104458:	0f b6 1b             	movzbl (%ebx),%ebx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
8010445b:	31 c0                	xor    %eax,%eax
8010445d:	8d 76 00             	lea    0x0(%esi),%esi
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
80104460:	0f b6 d3             	movzbl %bl,%edx
80104463:	29 d0                	sub    %edx,%eax
}
80104465:	5b                   	pop    %ebx
80104466:	5e                   	pop    %esi
80104467:	5d                   	pop    %ebp
80104468:	c3                   	ret    
80104469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104470:	0f b6 5b 01          	movzbl 0x1(%ebx),%ebx
80104474:	eb ea                	jmp    80104460 <strncmp+0x50>
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
80104476:	89 d3                	mov    %edx,%ebx
80104478:	eb e6                	jmp    80104460 <strncmp+0x50>
8010447a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104480 <strncpy>:
  return (uchar)*p - (uchar)*q;
}

char*
strncpy(char *s, const char *t, int n)
{
80104480:	55                   	push   %ebp
80104481:	89 e5                	mov    %esp,%ebp
80104483:	8b 45 08             	mov    0x8(%ebp),%eax
80104486:	56                   	push   %esi
80104487:	8b 4d 10             	mov    0x10(%ebp),%ecx
8010448a:	53                   	push   %ebx
8010448b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
8010448e:	89 c2                	mov    %eax,%edx
80104490:	eb 19                	jmp    801044ab <strncpy+0x2b>
80104492:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104498:	83 c3 01             	add    $0x1,%ebx
8010449b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010449f:	83 c2 01             	add    $0x1,%edx
801044a2:	84 c9                	test   %cl,%cl
801044a4:	88 4a ff             	mov    %cl,-0x1(%edx)
801044a7:	74 09                	je     801044b2 <strncpy+0x32>
801044a9:	89 f1                	mov    %esi,%ecx
801044ab:	85 c9                	test   %ecx,%ecx
801044ad:	8d 71 ff             	lea    -0x1(%ecx),%esi
801044b0:	7f e6                	jg     80104498 <strncpy+0x18>
    ;
  while(n-- > 0)
801044b2:	31 c9                	xor    %ecx,%ecx
801044b4:	85 f6                	test   %esi,%esi
801044b6:	7e 0f                	jle    801044c7 <strncpy+0x47>
    *s++ = 0;
801044b8:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
801044bc:	89 f3                	mov    %esi,%ebx
801044be:	83 c1 01             	add    $0x1,%ecx
801044c1:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
801044c3:	85 db                	test   %ebx,%ebx
801044c5:	7f f1                	jg     801044b8 <strncpy+0x38>
    *s++ = 0;
  return os;
}
801044c7:	5b                   	pop    %ebx
801044c8:	5e                   	pop    %esi
801044c9:	5d                   	pop    %ebp
801044ca:	c3                   	ret    
801044cb:	90                   	nop
801044cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801044d0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
801044d0:	55                   	push   %ebp
801044d1:	89 e5                	mov    %esp,%ebp
801044d3:	8b 4d 10             	mov    0x10(%ebp),%ecx
801044d6:	56                   	push   %esi
801044d7:	8b 45 08             	mov    0x8(%ebp),%eax
801044da:	53                   	push   %ebx
801044db:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
801044de:	85 c9                	test   %ecx,%ecx
801044e0:	7e 26                	jle    80104508 <safestrcpy+0x38>
801044e2:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
801044e6:	89 c1                	mov    %eax,%ecx
801044e8:	eb 17                	jmp    80104501 <safestrcpy+0x31>
801044ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
801044f0:	83 c2 01             	add    $0x1,%edx
801044f3:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
801044f7:	83 c1 01             	add    $0x1,%ecx
801044fa:	84 db                	test   %bl,%bl
801044fc:	88 59 ff             	mov    %bl,-0x1(%ecx)
801044ff:	74 04                	je     80104505 <safestrcpy+0x35>
80104501:	39 f2                	cmp    %esi,%edx
80104503:	75 eb                	jne    801044f0 <safestrcpy+0x20>
    ;
  *s = 0;
80104505:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104508:	5b                   	pop    %ebx
80104509:	5e                   	pop    %esi
8010450a:	5d                   	pop    %ebp
8010450b:	c3                   	ret    
8010450c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104510 <strlen>:

int
strlen(const char *s)
{
80104510:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104511:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104513:	89 e5                	mov    %esp,%ebp
80104515:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104518:	80 3a 00             	cmpb   $0x0,(%edx)
8010451b:	74 0c                	je     80104529 <strlen+0x19>
8010451d:	8d 76 00             	lea    0x0(%esi),%esi
80104520:	83 c0 01             	add    $0x1,%eax
80104523:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
80104527:	75 f7                	jne    80104520 <strlen+0x10>
    ;
  return n;
}
80104529:	5d                   	pop    %ebp
8010452a:	c3                   	ret    

8010452b <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
8010452b:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
8010452f:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
80104533:	55                   	push   %ebp
  pushl %ebx
80104534:	53                   	push   %ebx
  pushl %esi
80104535:	56                   	push   %esi
  pushl %edi
80104536:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
80104537:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
80104539:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
8010453b:	5f                   	pop    %edi
  popl %esi
8010453c:	5e                   	pop    %esi
  popl %ebx
8010453d:	5b                   	pop    %ebx
  popl %ebp
8010453e:	5d                   	pop    %ebp
  ret
8010453f:	c3                   	ret    

80104540 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
80104540:	55                   	push   %ebp
80104541:	89 e5                	mov    %esp,%ebp
80104543:	53                   	push   %ebx
80104544:	83 ec 04             	sub    $0x4,%esp
80104547:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
8010454a:	e8 61 f1 ff ff       	call   801036b0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010454f:	8b 00                	mov    (%eax),%eax
80104551:	39 d8                	cmp    %ebx,%eax
80104553:	76 1b                	jbe    80104570 <fetchint+0x30>
80104555:	8d 53 04             	lea    0x4(%ebx),%edx
80104558:	39 d0                	cmp    %edx,%eax
8010455a:	72 14                	jb     80104570 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
8010455c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010455f:	8b 13                	mov    (%ebx),%edx
80104561:	89 10                	mov    %edx,(%eax)
  return 0;
80104563:	31 c0                	xor    %eax,%eax
}
80104565:	83 c4 04             	add    $0x4,%esp
80104568:	5b                   	pop    %ebx
80104569:	5d                   	pop    %ebp
8010456a:	c3                   	ret    
8010456b:	90                   	nop
8010456c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
80104570:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104575:	eb ee                	jmp    80104565 <fetchint+0x25>
80104577:	89 f6                	mov    %esi,%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	53                   	push   %ebx
80104584:	83 ec 04             	sub    $0x4,%esp
80104587:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010458a:	e8 21 f1 ff ff       	call   801036b0 <myproc>

  if(addr >= curproc->sz)
8010458f:	39 18                	cmp    %ebx,(%eax)
80104591:	76 26                	jbe    801045b9 <fetchstr+0x39>
    return -1;
  *pp = (char*)addr;
80104593:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104596:	89 da                	mov    %ebx,%edx
80104598:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010459a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010459c:	39 c3                	cmp    %eax,%ebx
8010459e:	73 19                	jae    801045b9 <fetchstr+0x39>
    if(*s == 0)
801045a0:	80 3b 00             	cmpb   $0x0,(%ebx)
801045a3:	75 0d                	jne    801045b2 <fetchstr+0x32>
801045a5:	eb 21                	jmp    801045c8 <fetchstr+0x48>
801045a7:	90                   	nop
801045a8:	80 3a 00             	cmpb   $0x0,(%edx)
801045ab:	90                   	nop
801045ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045b0:	74 16                	je     801045c8 <fetchstr+0x48>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
801045b2:	83 c2 01             	add    $0x1,%edx
801045b5:	39 d0                	cmp    %edx,%eax
801045b7:	77 ef                	ja     801045a8 <fetchstr+0x28>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045b9:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
801045bc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
801045c1:	5b                   	pop    %ebx
801045c2:	5d                   	pop    %ebp
801045c3:	c3                   	ret    
801045c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801045c8:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
801045cb:	89 d0                	mov    %edx,%eax
801045cd:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
801045cf:	5b                   	pop    %ebx
801045d0:	5d                   	pop    %ebp
801045d1:	c3                   	ret    
801045d2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045e0 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
801045e0:	55                   	push   %ebp
801045e1:	89 e5                	mov    %esp,%ebp
801045e3:	56                   	push   %esi
801045e4:	8b 75 0c             	mov    0xc(%ebp),%esi
801045e7:	53                   	push   %ebx
801045e8:	8b 5d 08             	mov    0x8(%ebp),%ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
801045eb:	e8 c0 f0 ff ff       	call   801036b0 <myproc>
801045f0:	89 75 0c             	mov    %esi,0xc(%ebp)
801045f3:	8b 40 18             	mov    0x18(%eax),%eax
801045f6:	8b 40 44             	mov    0x44(%eax),%eax
801045f9:	8d 44 98 04          	lea    0x4(%eax,%ebx,4),%eax
801045fd:	89 45 08             	mov    %eax,0x8(%ebp)
}
80104600:	5b                   	pop    %ebx
80104601:	5e                   	pop    %esi
80104602:	5d                   	pop    %ebp

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104603:	e9 38 ff ff ff       	jmp    80104540 <fetchint>
80104608:	90                   	nop
80104609:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104610 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
80104610:	55                   	push   %ebp
80104611:	89 e5                	mov    %esp,%ebp
80104613:	56                   	push   %esi
80104614:	53                   	push   %ebx
80104615:	83 ec 20             	sub    $0x20,%esp
80104618:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
8010461b:	e8 90 f0 ff ff       	call   801036b0 <myproc>
80104620:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
80104622:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104625:	89 44 24 04          	mov    %eax,0x4(%esp)
80104629:	8b 45 08             	mov    0x8(%ebp),%eax
8010462c:	89 04 24             	mov    %eax,(%esp)
8010462f:	e8 ac ff ff ff       	call   801045e0 <argint>
80104634:	85 c0                	test   %eax,%eax
80104636:	78 28                	js     80104660 <argptr+0x50>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
80104638:	85 db                	test   %ebx,%ebx
8010463a:	78 24                	js     80104660 <argptr+0x50>
8010463c:	8b 55 f4             	mov    -0xc(%ebp),%edx
8010463f:	8b 06                	mov    (%esi),%eax
80104641:	39 c2                	cmp    %eax,%edx
80104643:	73 1b                	jae    80104660 <argptr+0x50>
80104645:	01 d3                	add    %edx,%ebx
80104647:	39 d8                	cmp    %ebx,%eax
80104649:	72 15                	jb     80104660 <argptr+0x50>
    return -1;
  *pp = (char*)i;
8010464b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010464e:	89 10                	mov    %edx,(%eax)
  return 0;
}
80104650:	83 c4 20             	add    $0x20,%esp
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
80104653:	31 c0                	xor    %eax,%eax
}
80104655:	5b                   	pop    %ebx
80104656:	5e                   	pop    %esi
80104657:	5d                   	pop    %ebp
80104658:	c3                   	ret    
80104659:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104660:	83 c4 20             	add    $0x20,%esp
{
  int i;
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
80104663:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
  *pp = (char*)i;
  return 0;
}
80104668:	5b                   	pop    %ebx
80104669:	5e                   	pop    %esi
8010466a:	5d                   	pop    %ebp
8010466b:	c3                   	ret    
8010466c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104670 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104670:	55                   	push   %ebp
80104671:	89 e5                	mov    %esp,%ebp
80104673:	83 ec 28             	sub    $0x28,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104676:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104679:	89 44 24 04          	mov    %eax,0x4(%esp)
8010467d:	8b 45 08             	mov    0x8(%ebp),%eax
80104680:	89 04 24             	mov    %eax,(%esp)
80104683:	e8 58 ff ff ff       	call   801045e0 <argint>
80104688:	85 c0                	test   %eax,%eax
8010468a:	78 14                	js     801046a0 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
8010468c:	8b 45 0c             	mov    0xc(%ebp),%eax
8010468f:	89 44 24 04          	mov    %eax,0x4(%esp)
80104693:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104696:	89 04 24             	mov    %eax,(%esp)
80104699:	e8 e2 fe ff ff       	call   80104580 <fetchstr>
}
8010469e:	c9                   	leave  
8010469f:	c3                   	ret    
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
801046a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
801046a5:	c9                   	leave  
801046a6:	c3                   	ret    
801046a7:	89 f6                	mov    %esi,%esi
801046a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801046b0 <syscall>:
[SYS_gettop]  sys_gettop,
};

void
syscall(void)
{
801046b0:	55                   	push   %ebp
801046b1:	89 e5                	mov    %esp,%ebp
801046b3:	56                   	push   %esi
801046b4:	53                   	push   %ebx
801046b5:	83 ec 10             	sub    $0x10,%esp
  int num;
  struct proc *curproc = myproc();
801046b8:	e8 f3 ef ff ff       	call   801036b0 <myproc>

  num = curproc->tf->eax;
801046bd:	8b 70 18             	mov    0x18(%eax),%esi

void
syscall(void)
{
  int num;
  struct proc *curproc = myproc();
801046c0:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
801046c2:	8b 46 1c             	mov    0x1c(%esi),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
801046c5:	8d 50 ff             	lea    -0x1(%eax),%edx
801046c8:	83 fa 17             	cmp    $0x17,%edx
801046cb:	77 1b                	ja     801046e8 <syscall+0x38>
801046cd:	8b 14 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%edx
801046d4:	85 d2                	test   %edx,%edx
801046d6:	74 10                	je     801046e8 <syscall+0x38>
    curproc->tf->eax = syscalls[num]();
801046d8:	ff d2                	call   *%edx
801046da:	89 46 1c             	mov    %eax,0x1c(%esi)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
801046dd:	83 c4 10             	add    $0x10,%esp
801046e0:	5b                   	pop    %ebx
801046e1:	5e                   	pop    %esi
801046e2:	5d                   	pop    %ebp
801046e3:	c3                   	ret    
801046e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046e8:	89 44 24 0c          	mov    %eax,0xc(%esp)
            curproc->pid, curproc->name, num);
801046ec:	8d 43 6c             	lea    0x6c(%ebx),%eax
801046ef:	89 44 24 08          	mov    %eax,0x8(%esp)

  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
801046f3:	8b 43 10             	mov    0x10(%ebx),%eax
801046f6:	c7 04 24 11 77 10 80 	movl   $0x80107711,(%esp)
801046fd:	89 44 24 04          	mov    %eax,0x4(%esp)
80104701:	e8 4a bf ff ff       	call   80100650 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
80104706:	8b 43 18             	mov    0x18(%ebx),%eax
80104709:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
80104710:	83 c4 10             	add    $0x10,%esp
80104713:	5b                   	pop    %ebx
80104714:	5e                   	pop    %esi
80104715:	5d                   	pop    %ebp
80104716:	c3                   	ret    
80104717:	66 90                	xchg   %ax,%ax
80104719:	66 90                	xchg   %ax,%ax
8010471b:	66 90                	xchg   %ax,%ax
8010471d:	66 90                	xchg   %ax,%ax
8010471f:	90                   	nop

80104720 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
80104720:	55                   	push   %ebp
80104721:	89 e5                	mov    %esp,%ebp
80104723:	53                   	push   %ebx
80104724:	89 c3                	mov    %eax,%ebx
80104726:	83 ec 04             	sub    $0x4,%esp
  int fd;
  struct proc *curproc = myproc();
80104729:	e8 82 ef ff ff       	call   801036b0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
8010472e:	31 d2                	xor    %edx,%edx
    if(curproc->ofile[fd] == 0){
80104730:	8b 4c 90 28          	mov    0x28(%eax,%edx,4),%ecx
80104734:	85 c9                	test   %ecx,%ecx
80104736:	74 18                	je     80104750 <fdalloc+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104738:	83 c2 01             	add    $0x1,%edx
8010473b:	83 fa 10             	cmp    $0x10,%edx
8010473e:	75 f0                	jne    80104730 <fdalloc+0x10>
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
}
80104740:	83 c4 04             	add    $0x4,%esp
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
80104743:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104748:	5b                   	pop    %ebx
80104749:	5d                   	pop    %ebp
8010474a:	c3                   	ret    
8010474b:	90                   	nop
8010474c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104750:	89 5c 90 28          	mov    %ebx,0x28(%eax,%edx,4)
      return fd;
    }
  }
  return -1;
}
80104754:	83 c4 04             	add    $0x4,%esp
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
      return fd;
80104757:	89 d0                	mov    %edx,%eax
    }
  }
  return -1;
}
80104759:	5b                   	pop    %ebx
8010475a:	5d                   	pop    %ebp
8010475b:	c3                   	ret    
8010475c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104760 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	57                   	push   %edi
80104764:	56                   	push   %esi
80104765:	53                   	push   %ebx
80104766:	83 ec 4c             	sub    $0x4c,%esp
80104769:	89 4d c0             	mov    %ecx,-0x40(%ebp)
8010476c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010476f:	8d 5d da             	lea    -0x26(%ebp),%ebx
80104772:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104776:	89 04 24             	mov    %eax,(%esp)
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
80104779:	89 55 c4             	mov    %edx,-0x3c(%ebp)
8010477c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
8010477f:	e8 ac d7 ff ff       	call   80101f30 <nameiparent>
80104784:	85 c0                	test   %eax,%eax
80104786:	89 c7                	mov    %eax,%edi
80104788:	0f 84 da 00 00 00    	je     80104868 <create+0x108>
    return 0;
  ilock(dp);
8010478e:	89 04 24             	mov    %eax,(%esp)
80104791:	e8 2a cf ff ff       	call   801016c0 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
80104796:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104799:	89 44 24 08          	mov    %eax,0x8(%esp)
8010479d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
801047a1:	89 3c 24             	mov    %edi,(%esp)
801047a4:	e8 27 d4 ff ff       	call   80101bd0 <dirlookup>
801047a9:	85 c0                	test   %eax,%eax
801047ab:	89 c6                	mov    %eax,%esi
801047ad:	74 41                	je     801047f0 <create+0x90>
    iunlockput(dp);
801047af:	89 3c 24             	mov    %edi,(%esp)
801047b2:	e8 69 d1 ff ff       	call   80101920 <iunlockput>
    ilock(ip);
801047b7:	89 34 24             	mov    %esi,(%esp)
801047ba:	e8 01 cf ff ff       	call   801016c0 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
801047bf:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
801047c4:	75 12                	jne    801047d8 <create+0x78>
801047c6:	66 83 7e 50 02       	cmpw   $0x2,0x50(%esi)
801047cb:	89 f0                	mov    %esi,%eax
801047cd:	75 09                	jne    801047d8 <create+0x78>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047cf:	83 c4 4c             	add    $0x4c,%esp
801047d2:	5b                   	pop    %ebx
801047d3:	5e                   	pop    %esi
801047d4:	5f                   	pop    %edi
801047d5:	5d                   	pop    %ebp
801047d6:	c3                   	ret    
801047d7:	90                   	nop
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
801047d8:	89 34 24             	mov    %esi,(%esp)
801047db:	e8 40 d1 ff ff       	call   80101920 <iunlockput>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047e0:	83 c4 4c             	add    $0x4c,%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
801047e3:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
801047e5:	5b                   	pop    %ebx
801047e6:	5e                   	pop    %esi
801047e7:	5f                   	pop    %edi
801047e8:	5d                   	pop    %ebp
801047e9:	c3                   	ret    
801047ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
801047f0:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
801047f4:	89 44 24 04          	mov    %eax,0x4(%esp)
801047f8:	8b 07                	mov    (%edi),%eax
801047fa:	89 04 24             	mov    %eax,(%esp)
801047fd:	e8 2e cd ff ff       	call   80101530 <ialloc>
80104802:	85 c0                	test   %eax,%eax
80104804:	89 c6                	mov    %eax,%esi
80104806:	0f 84 bf 00 00 00    	je     801048cb <create+0x16b>
    panic("create: ialloc");

  ilock(ip);
8010480c:	89 04 24             	mov    %eax,(%esp)
8010480f:	e8 ac ce ff ff       	call   801016c0 <ilock>
  ip->major = major;
80104814:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104818:	66 89 46 52          	mov    %ax,0x52(%esi)
  ip->minor = minor;
8010481c:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104820:	66 89 46 54          	mov    %ax,0x54(%esi)
  ip->nlink = 1;
80104824:	b8 01 00 00 00       	mov    $0x1,%eax
80104829:	66 89 46 56          	mov    %ax,0x56(%esi)
  iupdate(ip);
8010482d:	89 34 24             	mov    %esi,(%esp)
80104830:	e8 cb cd ff ff       	call   80101600 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
80104835:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
8010483a:	74 34                	je     80104870 <create+0x110>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
8010483c:	8b 46 04             	mov    0x4(%esi),%eax
8010483f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104843:	89 3c 24             	mov    %edi,(%esp)
80104846:	89 44 24 08          	mov    %eax,0x8(%esp)
8010484a:	e8 e1 d5 ff ff       	call   80101e30 <dirlink>
8010484f:	85 c0                	test   %eax,%eax
80104851:	78 6c                	js     801048bf <create+0x15f>
    panic("create: dirlink");

  iunlockput(dp);
80104853:	89 3c 24             	mov    %edi,(%esp)
80104856:	e8 c5 d0 ff ff       	call   80101920 <iunlockput>

  return ip;
}
8010485b:	83 c4 4c             	add    $0x4c,%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
8010485e:	89 f0                	mov    %esi,%eax
}
80104860:	5b                   	pop    %ebx
80104861:	5e                   	pop    %esi
80104862:	5f                   	pop    %edi
80104863:	5d                   	pop    %ebp
80104864:	c3                   	ret    
80104865:	8d 76 00             	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
80104868:	31 c0                	xor    %eax,%eax
8010486a:	e9 60 ff ff ff       	jmp    801047cf <create+0x6f>
8010486f:	90                   	nop
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
80104870:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
80104875:	89 3c 24             	mov    %edi,(%esp)
80104878:	e8 83 cd ff ff       	call   80101600 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
8010487d:	8b 46 04             	mov    0x4(%esi),%eax
80104880:	c7 44 24 04 c0 77 10 	movl   $0x801077c0,0x4(%esp)
80104887:	80 
80104888:	89 34 24             	mov    %esi,(%esp)
8010488b:	89 44 24 08          	mov    %eax,0x8(%esp)
8010488f:	e8 9c d5 ff ff       	call   80101e30 <dirlink>
80104894:	85 c0                	test   %eax,%eax
80104896:	78 1b                	js     801048b3 <create+0x153>
80104898:	8b 47 04             	mov    0x4(%edi),%eax
8010489b:	c7 44 24 04 bf 77 10 	movl   $0x801077bf,0x4(%esp)
801048a2:	80 
801048a3:	89 34 24             	mov    %esi,(%esp)
801048a6:	89 44 24 08          	mov    %eax,0x8(%esp)
801048aa:	e8 81 d5 ff ff       	call   80101e30 <dirlink>
801048af:	85 c0                	test   %eax,%eax
801048b1:	79 89                	jns    8010483c <create+0xdc>
      panic("create dots");
801048b3:	c7 04 24 b3 77 10 80 	movl   $0x801077b3,(%esp)
801048ba:	e8 a1 ba ff ff       	call   80100360 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
801048bf:	c7 04 24 c2 77 10 80 	movl   $0x801077c2,(%esp)
801048c6:	e8 95 ba ff ff       	call   80100360 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
801048cb:	c7 04 24 a4 77 10 80 	movl   $0x801077a4,(%esp)
801048d2:	e8 89 ba ff ff       	call   80100360 <panic>
801048d7:	89 f6                	mov    %esi,%esi
801048d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801048e0 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
801048e0:	55                   	push   %ebp
801048e1:	89 e5                	mov    %esp,%ebp
801048e3:	56                   	push   %esi
801048e4:	89 c6                	mov    %eax,%esi
801048e6:	53                   	push   %ebx
801048e7:	89 d3                	mov    %edx,%ebx
801048e9:	83 ec 20             	sub    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
801048ec:	8d 45 f4             	lea    -0xc(%ebp),%eax
801048ef:	89 44 24 04          	mov    %eax,0x4(%esp)
801048f3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801048fa:	e8 e1 fc ff ff       	call   801045e0 <argint>
801048ff:	85 c0                	test   %eax,%eax
80104901:	78 2d                	js     80104930 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104903:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104907:	77 27                	ja     80104930 <argfd.constprop.0+0x50>
80104909:	e8 a2 ed ff ff       	call   801036b0 <myproc>
8010490e:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104911:	8b 44 90 28          	mov    0x28(%eax,%edx,4),%eax
80104915:	85 c0                	test   %eax,%eax
80104917:	74 17                	je     80104930 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104919:	85 f6                	test   %esi,%esi
8010491b:	74 02                	je     8010491f <argfd.constprop.0+0x3f>
    *pfd = fd;
8010491d:	89 16                	mov    %edx,(%esi)
  if(pf)
8010491f:	85 db                	test   %ebx,%ebx
80104921:	74 1d                	je     80104940 <argfd.constprop.0+0x60>
    *pf = f;
80104923:	89 03                	mov    %eax,(%ebx)
  return 0;
80104925:	31 c0                	xor    %eax,%eax
}
80104927:	83 c4 20             	add    $0x20,%esp
8010492a:	5b                   	pop    %ebx
8010492b:	5e                   	pop    %esi
8010492c:	5d                   	pop    %ebp
8010492d:	c3                   	ret    
8010492e:	66 90                	xchg   %ax,%ax
80104930:	83 c4 20             	add    $0x20,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104933:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104938:	5b                   	pop    %ebx
80104939:	5e                   	pop    %esi
8010493a:	5d                   	pop    %ebp
8010493b:	c3                   	ret    
8010493c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104940:	31 c0                	xor    %eax,%eax
80104942:	eb e3                	jmp    80104927 <argfd.constprop.0+0x47>
80104944:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010494a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104950 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104950:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104951:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104953:	89 e5                	mov    %esp,%ebp
80104955:	53                   	push   %ebx
80104956:	83 ec 24             	sub    $0x24,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104959:	8d 55 f4             	lea    -0xc(%ebp),%edx
8010495c:	e8 7f ff ff ff       	call   801048e0 <argfd.constprop.0>
80104961:	85 c0                	test   %eax,%eax
80104963:	78 23                	js     80104988 <sys_dup+0x38>
    return -1;
  if((fd=fdalloc(f)) < 0)
80104965:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104968:	e8 b3 fd ff ff       	call   80104720 <fdalloc>
8010496d:	85 c0                	test   %eax,%eax
8010496f:	89 c3                	mov    %eax,%ebx
80104971:	78 15                	js     80104988 <sys_dup+0x38>
    return -1;
  filedup(f);
80104973:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104976:	89 04 24             	mov    %eax,(%esp)
80104979:	e8 62 c4 ff ff       	call   80100de0 <filedup>
  return fd;
8010497e:	89 d8                	mov    %ebx,%eax
}
80104980:	83 c4 24             	add    $0x24,%esp
80104983:	5b                   	pop    %ebx
80104984:	5d                   	pop    %ebp
80104985:	c3                   	ret    
80104986:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104988:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010498d:	eb f1                	jmp    80104980 <sys_dup+0x30>
8010498f:	90                   	nop

80104990 <sys_read>:
  return fd;
}

int
sys_read(void)
{
80104990:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104991:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104993:	89 e5                	mov    %esp,%ebp
80104995:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104998:	8d 55 ec             	lea    -0x14(%ebp),%edx
8010499b:	e8 40 ff ff ff       	call   801048e0 <argfd.constprop.0>
801049a0:	85 c0                	test   %eax,%eax
801049a2:	78 54                	js     801049f8 <sys_read+0x68>
801049a4:	8d 45 f0             	lea    -0x10(%ebp),%eax
801049a7:	89 44 24 04          	mov    %eax,0x4(%esp)
801049ab:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
801049b2:	e8 29 fc ff ff       	call   801045e0 <argint>
801049b7:	85 c0                	test   %eax,%eax
801049b9:	78 3d                	js     801049f8 <sys_read+0x68>
801049bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801049c5:	89 44 24 08          	mov    %eax,0x8(%esp)
801049c9:	8d 45 f4             	lea    -0xc(%ebp),%eax
801049cc:	89 44 24 04          	mov    %eax,0x4(%esp)
801049d0:	e8 3b fc ff ff       	call   80104610 <argptr>
801049d5:	85 c0                	test   %eax,%eax
801049d7:	78 1f                	js     801049f8 <sys_read+0x68>
    return -1;
  return fileread(f, p, n);
801049d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
801049dc:	89 44 24 08          	mov    %eax,0x8(%esp)
801049e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
801049e3:	89 44 24 04          	mov    %eax,0x4(%esp)
801049e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
801049ea:	89 04 24             	mov    %eax,(%esp)
801049ed:	e8 4e c5 ff ff       	call   80100f40 <fileread>
}
801049f2:	c9                   	leave  
801049f3:	c3                   	ret    
801049f4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
801049f8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
801049fd:	c9                   	leave  
801049fe:	c3                   	ret    
801049ff:	90                   	nop

80104a00 <sys_write>:

int
sys_write(void)
{
80104a00:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a01:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104a03:	89 e5                	mov    %esp,%ebp
80104a05:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104a08:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104a0b:	e8 d0 fe ff ff       	call   801048e0 <argfd.constprop.0>
80104a10:	85 c0                	test   %eax,%eax
80104a12:	78 54                	js     80104a68 <sys_write+0x68>
80104a14:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a17:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a1b:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104a22:	e8 b9 fb ff ff       	call   801045e0 <argint>
80104a27:	85 c0                	test   %eax,%eax
80104a29:	78 3d                	js     80104a68 <sys_write+0x68>
80104a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a2e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104a35:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a39:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104a3c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a40:	e8 cb fb ff ff       	call   80104610 <argptr>
80104a45:	85 c0                	test   %eax,%eax
80104a47:	78 1f                	js     80104a68 <sys_write+0x68>
    return -1;
  return filewrite(f, p, n);
80104a49:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104a4c:	89 44 24 08          	mov    %eax,0x8(%esp)
80104a50:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a53:	89 44 24 04          	mov    %eax,0x4(%esp)
80104a57:	8b 45 ec             	mov    -0x14(%ebp),%eax
80104a5a:	89 04 24             	mov    %eax,(%esp)
80104a5d:	e8 7e c5 ff ff       	call   80100fe0 <filewrite>
}
80104a62:	c9                   	leave  
80104a63:	c3                   	ret    
80104a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104a68:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104a6d:	c9                   	leave  
80104a6e:	c3                   	ret    
80104a6f:	90                   	nop

80104a70 <sys_close>:

int
sys_close(void)
{
80104a70:	55                   	push   %ebp
80104a71:	89 e5                	mov    %esp,%ebp
80104a73:	83 ec 28             	sub    $0x28,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104a76:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104a79:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104a7c:	e8 5f fe ff ff       	call   801048e0 <argfd.constprop.0>
80104a81:	85 c0                	test   %eax,%eax
80104a83:	78 23                	js     80104aa8 <sys_close+0x38>
    return -1;
  myproc()->ofile[fd] = 0;
80104a85:	e8 26 ec ff ff       	call   801036b0 <myproc>
80104a8a:	8b 55 f0             	mov    -0x10(%ebp),%edx
80104a8d:	c7 44 90 28 00 00 00 	movl   $0x0,0x28(%eax,%edx,4)
80104a94:	00 
  fileclose(f);
80104a95:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104a98:	89 04 24             	mov    %eax,(%esp)
80104a9b:	e8 90 c3 ff ff       	call   80100e30 <fileclose>
  return 0;
80104aa0:	31 c0                	xor    %eax,%eax
}
80104aa2:	c9                   	leave  
80104aa3:	c3                   	ret    
80104aa4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104aa8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104aad:	c9                   	leave  
80104aae:	c3                   	ret    
80104aaf:	90                   	nop

80104ab0 <sys_fstat>:

int
sys_fstat(void)
{
80104ab0:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ab1:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104ab3:	89 e5                	mov    %esp,%ebp
80104ab5:	83 ec 28             	sub    $0x28,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104ab8:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104abb:	e8 20 fe ff ff       	call   801048e0 <argfd.constprop.0>
80104ac0:	85 c0                	test   %eax,%eax
80104ac2:	78 34                	js     80104af8 <sys_fstat+0x48>
80104ac4:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104ac7:	c7 44 24 08 14 00 00 	movl   $0x14,0x8(%esp)
80104ace:	00 
80104acf:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ad3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104ada:	e8 31 fb ff ff       	call   80104610 <argptr>
80104adf:	85 c0                	test   %eax,%eax
80104ae1:	78 15                	js     80104af8 <sys_fstat+0x48>
    return -1;
  return filestat(f, st);
80104ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104ae6:	89 44 24 04          	mov    %eax,0x4(%esp)
80104aea:	8b 45 f0             	mov    -0x10(%ebp),%eax
80104aed:	89 04 24             	mov    %eax,(%esp)
80104af0:	e8 fb c3 ff ff       	call   80100ef0 <filestat>
}
80104af5:	c9                   	leave  
80104af6:	c3                   	ret    
80104af7:	90                   	nop
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104af8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104afd:	c9                   	leave  
80104afe:	c3                   	ret    
80104aff:	90                   	nop

80104b00 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104b00:	55                   	push   %ebp
80104b01:	89 e5                	mov    %esp,%ebp
80104b03:	57                   	push   %edi
80104b04:	56                   	push   %esi
80104b05:	53                   	push   %ebx
80104b06:	83 ec 3c             	sub    $0x3c,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104b09:	8d 45 d4             	lea    -0x2c(%ebp),%eax
80104b0c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b10:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104b17:	e8 54 fb ff ff       	call   80104670 <argstr>
80104b1c:	85 c0                	test   %eax,%eax
80104b1e:	0f 88 e6 00 00 00    	js     80104c0a <sys_link+0x10a>
80104b24:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104b27:	89 44 24 04          	mov    %eax,0x4(%esp)
80104b2b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104b32:	e8 39 fb ff ff       	call   80104670 <argstr>
80104b37:	85 c0                	test   %eax,%eax
80104b39:	0f 88 cb 00 00 00    	js     80104c0a <sys_link+0x10a>
    return -1;

  begin_op();
80104b3f:	e8 dc df ff ff       	call   80102b20 <begin_op>
  if((ip = namei(old)) == 0){
80104b44:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80104b47:	89 04 24             	mov    %eax,(%esp)
80104b4a:	e8 c1 d3 ff ff       	call   80101f10 <namei>
80104b4f:	85 c0                	test   %eax,%eax
80104b51:	89 c3                	mov    %eax,%ebx
80104b53:	0f 84 ac 00 00 00    	je     80104c05 <sys_link+0x105>
    end_op();
    return -1;
  }

  ilock(ip);
80104b59:	89 04 24             	mov    %eax,(%esp)
80104b5c:	e8 5f cb ff ff       	call   801016c0 <ilock>
  if(ip->type == T_DIR){
80104b61:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104b66:	0f 84 91 00 00 00    	je     80104bfd <sys_link+0xfd>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104b6c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104b71:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104b74:	89 1c 24             	mov    %ebx,(%esp)
80104b77:	e8 84 ca ff ff       	call   80101600 <iupdate>
  iunlock(ip);
80104b7c:	89 1c 24             	mov    %ebx,(%esp)
80104b7f:	e8 1c cc ff ff       	call   801017a0 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104b84:	8b 45 d0             	mov    -0x30(%ebp),%eax
80104b87:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104b8b:	89 04 24             	mov    %eax,(%esp)
80104b8e:	e8 9d d3 ff ff       	call   80101f30 <nameiparent>
80104b93:	85 c0                	test   %eax,%eax
80104b95:	89 c6                	mov    %eax,%esi
80104b97:	74 4f                	je     80104be8 <sys_link+0xe8>
    goto bad;
  ilock(dp);
80104b99:	89 04 24             	mov    %eax,(%esp)
80104b9c:	e8 1f cb ff ff       	call   801016c0 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104ba1:	8b 03                	mov    (%ebx),%eax
80104ba3:	39 06                	cmp    %eax,(%esi)
80104ba5:	75 39                	jne    80104be0 <sys_link+0xe0>
80104ba7:	8b 43 04             	mov    0x4(%ebx),%eax
80104baa:	89 7c 24 04          	mov    %edi,0x4(%esp)
80104bae:	89 34 24             	mov    %esi,(%esp)
80104bb1:	89 44 24 08          	mov    %eax,0x8(%esp)
80104bb5:	e8 76 d2 ff ff       	call   80101e30 <dirlink>
80104bba:	85 c0                	test   %eax,%eax
80104bbc:	78 22                	js     80104be0 <sys_link+0xe0>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104bbe:	89 34 24             	mov    %esi,(%esp)
80104bc1:	e8 5a cd ff ff       	call   80101920 <iunlockput>
  iput(ip);
80104bc6:	89 1c 24             	mov    %ebx,(%esp)
80104bc9:	e8 12 cc ff ff       	call   801017e0 <iput>

  end_op();
80104bce:	e8 bd df ff ff       	call   80102b90 <end_op>
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104bd3:	83 c4 3c             	add    $0x3c,%esp
  iunlockput(dp);
  iput(ip);

  end_op();

  return 0;
80104bd6:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104bd8:	5b                   	pop    %ebx
80104bd9:	5e                   	pop    %esi
80104bda:	5f                   	pop    %edi
80104bdb:	5d                   	pop    %ebp
80104bdc:	c3                   	ret    
80104bdd:	8d 76 00             	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104be0:	89 34 24             	mov    %esi,(%esp)
80104be3:	e8 38 cd ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  ilock(ip);
80104be8:	89 1c 24             	mov    %ebx,(%esp)
80104beb:	e8 d0 ca ff ff       	call   801016c0 <ilock>
  ip->nlink--;
80104bf0:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104bf5:	89 1c 24             	mov    %ebx,(%esp)
80104bf8:	e8 03 ca ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104bfd:	89 1c 24             	mov    %ebx,(%esp)
80104c00:	e8 1b cd ff ff       	call   80101920 <iunlockput>
  end_op();
80104c05:	e8 86 df ff ff       	call   80102b90 <end_op>
  return -1;
}
80104c0a:	83 c4 3c             	add    $0x3c,%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104c0d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104c12:	5b                   	pop    %ebx
80104c13:	5e                   	pop    %esi
80104c14:	5f                   	pop    %edi
80104c15:	5d                   	pop    %ebp
80104c16:	c3                   	ret    
80104c17:	89 f6                	mov    %esi,%esi
80104c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c20 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104c20:	55                   	push   %ebp
80104c21:	89 e5                	mov    %esp,%ebp
80104c23:	57                   	push   %edi
80104c24:	56                   	push   %esi
80104c25:	53                   	push   %ebx
80104c26:	83 ec 5c             	sub    $0x5c,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104c29:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104c2c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104c30:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104c37:	e8 34 fa ff ff       	call   80104670 <argstr>
80104c3c:	85 c0                	test   %eax,%eax
80104c3e:	0f 88 76 01 00 00    	js     80104dba <sys_unlink+0x19a>
    return -1;

  begin_op();
80104c44:	e8 d7 de ff ff       	call   80102b20 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104c49:	8b 45 c0             	mov    -0x40(%ebp),%eax
80104c4c:	8d 5d ca             	lea    -0x36(%ebp),%ebx
80104c4f:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104c53:	89 04 24             	mov    %eax,(%esp)
80104c56:	e8 d5 d2 ff ff       	call   80101f30 <nameiparent>
80104c5b:	85 c0                	test   %eax,%eax
80104c5d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104c60:	0f 84 4f 01 00 00    	je     80104db5 <sys_unlink+0x195>
    end_op();
    return -1;
  }

  ilock(dp);
80104c66:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104c69:	89 34 24             	mov    %esi,(%esp)
80104c6c:	e8 4f ca ff ff       	call   801016c0 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104c71:	c7 44 24 04 c0 77 10 	movl   $0x801077c0,0x4(%esp)
80104c78:	80 
80104c79:	89 1c 24             	mov    %ebx,(%esp)
80104c7c:	e8 1f cf ff ff       	call   80101ba0 <namecmp>
80104c81:	85 c0                	test   %eax,%eax
80104c83:	0f 84 21 01 00 00    	je     80104daa <sys_unlink+0x18a>
80104c89:	c7 44 24 04 bf 77 10 	movl   $0x801077bf,0x4(%esp)
80104c90:	80 
80104c91:	89 1c 24             	mov    %ebx,(%esp)
80104c94:	e8 07 cf ff ff       	call   80101ba0 <namecmp>
80104c99:	85 c0                	test   %eax,%eax
80104c9b:	0f 84 09 01 00 00    	je     80104daa <sys_unlink+0x18a>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104ca1:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104ca4:	89 5c 24 04          	mov    %ebx,0x4(%esp)
80104ca8:	89 44 24 08          	mov    %eax,0x8(%esp)
80104cac:	89 34 24             	mov    %esi,(%esp)
80104caf:	e8 1c cf ff ff       	call   80101bd0 <dirlookup>
80104cb4:	85 c0                	test   %eax,%eax
80104cb6:	89 c3                	mov    %eax,%ebx
80104cb8:	0f 84 ec 00 00 00    	je     80104daa <sys_unlink+0x18a>
    goto bad;
  ilock(ip);
80104cbe:	89 04 24             	mov    %eax,(%esp)
80104cc1:	e8 fa c9 ff ff       	call   801016c0 <ilock>

  if(ip->nlink < 1)
80104cc6:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104ccb:	0f 8e 24 01 00 00    	jle    80104df5 <sys_unlink+0x1d5>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104cd1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104cd6:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104cd9:	74 7d                	je     80104d58 <sys_unlink+0x138>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104cdb:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
80104ce2:	00 
80104ce3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80104cea:	00 
80104ceb:	89 34 24             	mov    %esi,(%esp)
80104cee:	e8 fd f5 ff ff       	call   801042f0 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104cf3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80104cf6:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104cfd:	00 
80104cfe:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d02:	89 44 24 08          	mov    %eax,0x8(%esp)
80104d06:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d09:	89 04 24             	mov    %eax,(%esp)
80104d0c:	e8 5f cd ff ff       	call   80101a70 <writei>
80104d11:	83 f8 10             	cmp    $0x10,%eax
80104d14:	0f 85 cf 00 00 00    	jne    80104de9 <sys_unlink+0x1c9>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104d1a:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d1f:	0f 84 a3 00 00 00    	je     80104dc8 <sys_unlink+0x1a8>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104d25:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104d28:	89 04 24             	mov    %eax,(%esp)
80104d2b:	e8 f0 cb ff ff       	call   80101920 <iunlockput>

  ip->nlink--;
80104d30:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d35:	89 1c 24             	mov    %ebx,(%esp)
80104d38:	e8 c3 c8 ff ff       	call   80101600 <iupdate>
  iunlockput(ip);
80104d3d:	89 1c 24             	mov    %ebx,(%esp)
80104d40:	e8 db cb ff ff       	call   80101920 <iunlockput>

  end_op();
80104d45:	e8 46 de ff ff       	call   80102b90 <end_op>

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104d4a:	83 c4 5c             	add    $0x5c,%esp
  iupdate(ip);
  iunlockput(ip);

  end_op();

  return 0;
80104d4d:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104d4f:	5b                   	pop    %ebx
80104d50:	5e                   	pop    %esi
80104d51:	5f                   	pop    %edi
80104d52:	5d                   	pop    %ebp
80104d53:	c3                   	ret    
80104d54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104d58:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104d5c:	0f 86 79 ff ff ff    	jbe    80104cdb <sys_unlink+0xbb>
80104d62:	bf 20 00 00 00       	mov    $0x20,%edi
80104d67:	eb 15                	jmp    80104d7e <sys_unlink+0x15e>
80104d69:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104d70:	8d 57 10             	lea    0x10(%edi),%edx
80104d73:	3b 53 58             	cmp    0x58(%ebx),%edx
80104d76:	0f 83 5f ff ff ff    	jae    80104cdb <sys_unlink+0xbb>
80104d7c:	89 d7                	mov    %edx,%edi
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104d7e:	c7 44 24 0c 10 00 00 	movl   $0x10,0xc(%esp)
80104d85:	00 
80104d86:	89 7c 24 08          	mov    %edi,0x8(%esp)
80104d8a:	89 74 24 04          	mov    %esi,0x4(%esp)
80104d8e:	89 1c 24             	mov    %ebx,(%esp)
80104d91:	e8 da cb ff ff       	call   80101970 <readi>
80104d96:	83 f8 10             	cmp    $0x10,%eax
80104d99:	75 42                	jne    80104ddd <sys_unlink+0x1bd>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104d9b:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104da0:	74 ce                	je     80104d70 <sys_unlink+0x150>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104da2:	89 1c 24             	mov    %ebx,(%esp)
80104da5:	e8 76 cb ff ff       	call   80101920 <iunlockput>
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104daa:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dad:	89 04 24             	mov    %eax,(%esp)
80104db0:	e8 6b cb ff ff       	call   80101920 <iunlockput>
  end_op();
80104db5:	e8 d6 dd ff ff       	call   80102b90 <end_op>
  return -1;
}
80104dba:	83 c4 5c             	add    $0x5c,%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104dbd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dc2:	5b                   	pop    %ebx
80104dc3:	5e                   	pop    %esi
80104dc4:	5f                   	pop    %edi
80104dc5:	5d                   	pop    %ebp
80104dc6:	c3                   	ret    
80104dc7:	90                   	nop

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104dc8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
80104dcb:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104dd0:	89 04 24             	mov    %eax,(%esp)
80104dd3:	e8 28 c8 ff ff       	call   80101600 <iupdate>
80104dd8:	e9 48 ff ff ff       	jmp    80104d25 <sys_unlink+0x105>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104ddd:	c7 04 24 e4 77 10 80 	movl   $0x801077e4,(%esp)
80104de4:	e8 77 b5 ff ff       	call   80100360 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104de9:	c7 04 24 f6 77 10 80 	movl   $0x801077f6,(%esp)
80104df0:	e8 6b b5 ff ff       	call   80100360 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104df5:	c7 04 24 d2 77 10 80 	movl   $0x801077d2,(%esp)
80104dfc:	e8 5f b5 ff ff       	call   80100360 <panic>
80104e01:	eb 0d                	jmp    80104e10 <sys_open>
80104e03:	90                   	nop
80104e04:	90                   	nop
80104e05:	90                   	nop
80104e06:	90                   	nop
80104e07:	90                   	nop
80104e08:	90                   	nop
80104e09:	90                   	nop
80104e0a:	90                   	nop
80104e0b:	90                   	nop
80104e0c:	90                   	nop
80104e0d:	90                   	nop
80104e0e:	90                   	nop
80104e0f:	90                   	nop

80104e10 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
80104e16:	83 ec 2c             	sub    $0x2c,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80104e19:	8d 45 e0             	lea    -0x20(%ebp),%eax
80104e1c:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e20:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104e27:	e8 44 f8 ff ff       	call   80104670 <argstr>
80104e2c:	85 c0                	test   %eax,%eax
80104e2e:	0f 88 d1 00 00 00    	js     80104f05 <sys_open+0xf5>
80104e34:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80104e37:	89 44 24 04          	mov    %eax,0x4(%esp)
80104e3b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104e42:	e8 99 f7 ff ff       	call   801045e0 <argint>
80104e47:	85 c0                	test   %eax,%eax
80104e49:	0f 88 b6 00 00 00    	js     80104f05 <sys_open+0xf5>
    return -1;

  begin_op();
80104e4f:	e8 cc dc ff ff       	call   80102b20 <begin_op>

  if(omode & O_CREATE){
80104e54:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80104e58:	0f 85 82 00 00 00    	jne    80104ee0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80104e5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104e61:	89 04 24             	mov    %eax,(%esp)
80104e64:	e8 a7 d0 ff ff       	call   80101f10 <namei>
80104e69:	85 c0                	test   %eax,%eax
80104e6b:	89 c6                	mov    %eax,%esi
80104e6d:	0f 84 8d 00 00 00    	je     80104f00 <sys_open+0xf0>
      end_op();
      return -1;
    }
    ilock(ip);
80104e73:	89 04 24             	mov    %eax,(%esp)
80104e76:	e8 45 c8 ff ff       	call   801016c0 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80104e7b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80104e80:	0f 84 92 00 00 00    	je     80104f18 <sys_open+0x108>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80104e86:	e8 e5 be ff ff       	call   80100d70 <filealloc>
80104e8b:	85 c0                	test   %eax,%eax
80104e8d:	89 c3                	mov    %eax,%ebx
80104e8f:	0f 84 93 00 00 00    	je     80104f28 <sys_open+0x118>
80104e95:	e8 86 f8 ff ff       	call   80104720 <fdalloc>
80104e9a:	85 c0                	test   %eax,%eax
80104e9c:	89 c7                	mov    %eax,%edi
80104e9e:	0f 88 94 00 00 00    	js     80104f38 <sys_open+0x128>
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80104ea4:	89 34 24             	mov    %esi,(%esp)
80104ea7:	e8 f4 c8 ff ff       	call   801017a0 <iunlock>
  end_op();
80104eac:	e8 df dc ff ff       	call   80102b90 <end_op>

  f->type = FD_INODE;
80104eb1:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104eb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
80104eba:	89 73 10             	mov    %esi,0x10(%ebx)
  f->off = 0;
80104ebd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
  f->readable = !(omode & O_WRONLY);
80104ec4:	89 c2                	mov    %eax,%edx
80104ec6:	83 e2 01             	and    $0x1,%edx
80104ec9:	83 f2 01             	xor    $0x1,%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ecc:	a8 03                	test   $0x3,%al
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80104ece:	88 53 08             	mov    %dl,0x8(%ebx)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
80104ed1:	89 f8                	mov    %edi,%eax

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80104ed3:	0f 95 43 09          	setne  0x9(%ebx)
  return fd;
}
80104ed7:	83 c4 2c             	add    $0x2c,%esp
80104eda:	5b                   	pop    %ebx
80104edb:	5e                   	pop    %esi
80104edc:	5f                   	pop    %edi
80104edd:	5d                   	pop    %ebp
80104ede:	c3                   	ret    
80104edf:	90                   	nop
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ee0:	8b 45 e0             	mov    -0x20(%ebp),%eax
80104ee3:	31 c9                	xor    %ecx,%ecx
80104ee5:	ba 02 00 00 00       	mov    $0x2,%edx
80104eea:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104ef1:	e8 6a f8 ff ff       	call   80104760 <create>
    if(ip == 0){
80104ef6:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
80104ef8:	89 c6                	mov    %eax,%esi
    if(ip == 0){
80104efa:	75 8a                	jne    80104e86 <sys_open+0x76>
80104efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
80104f00:	e8 8b dc ff ff       	call   80102b90 <end_op>
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f05:	83 c4 2c             	add    $0x2c,%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
80104f08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
80104f0d:	5b                   	pop    %ebx
80104f0e:	5e                   	pop    %esi
80104f0f:	5f                   	pop    %edi
80104f10:	5d                   	pop    %ebp
80104f11:	c3                   	ret    
80104f12:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80104f18:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80104f1b:	85 c0                	test   %eax,%eax
80104f1d:	0f 84 63 ff ff ff    	je     80104e86 <sys_open+0x76>
80104f23:	90                   	nop
80104f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
80104f28:	89 34 24             	mov    %esi,(%esp)
80104f2b:	e8 f0 c9 ff ff       	call   80101920 <iunlockput>
80104f30:	eb ce                	jmp    80104f00 <sys_open+0xf0>
80104f32:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
80104f38:	89 1c 24             	mov    %ebx,(%esp)
80104f3b:	e8 f0 be ff ff       	call   80100e30 <fileclose>
80104f40:	eb e6                	jmp    80104f28 <sys_open+0x118>
80104f42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104f49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104f50 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80104f50:	55                   	push   %ebp
80104f51:	89 e5                	mov    %esp,%ebp
80104f53:	83 ec 28             	sub    $0x28,%esp
  char *path;
  struct inode *ip;

  begin_op();
80104f56:	e8 c5 db ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
80104f5b:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104f5e:	89 44 24 04          	mov    %eax,0x4(%esp)
80104f62:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f69:	e8 02 f7 ff ff       	call   80104670 <argstr>
80104f6e:	85 c0                	test   %eax,%eax
80104f70:	78 2e                	js     80104fa0 <sys_mkdir+0x50>
80104f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
80104f75:	31 c9                	xor    %ecx,%ecx
80104f77:	ba 01 00 00 00       	mov    $0x1,%edx
80104f7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104f83:	e8 d8 f7 ff ff       	call   80104760 <create>
80104f88:	85 c0                	test   %eax,%eax
80104f8a:	74 14                	je     80104fa0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
80104f8c:	89 04 24             	mov    %eax,(%esp)
80104f8f:	e8 8c c9 ff ff       	call   80101920 <iunlockput>
  end_op();
80104f94:	e8 f7 db ff ff       	call   80102b90 <end_op>
  return 0;
80104f99:	31 c0                	xor    %eax,%eax
}
80104f9b:	c9                   	leave  
80104f9c:	c3                   	ret    
80104f9d:	8d 76 00             	lea    0x0(%esi),%esi
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
80104fa0:	e8 eb db ff ff       	call   80102b90 <end_op>
    return -1;
80104fa5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
80104faa:	c9                   	leave  
80104fab:	c3                   	ret    
80104fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104fb0 <sys_mknod>:

int
sys_mknod(void)
{
80104fb0:	55                   	push   %ebp
80104fb1:	89 e5                	mov    %esp,%ebp
80104fb3:	83 ec 28             	sub    $0x28,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
80104fb6:	e8 65 db ff ff       	call   80102b20 <begin_op>
  if((argstr(0, &path)) < 0 ||
80104fbb:	8d 45 ec             	lea    -0x14(%ebp),%eax
80104fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fc2:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80104fc9:	e8 a2 f6 ff ff       	call   80104670 <argstr>
80104fce:	85 c0                	test   %eax,%eax
80104fd0:	78 5e                	js     80105030 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
80104fd2:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104fd5:	89 44 24 04          	mov    %eax,0x4(%esp)
80104fd9:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
80104fe0:	e8 fb f5 ff ff       	call   801045e0 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
80104fe5:	85 c0                	test   %eax,%eax
80104fe7:	78 47                	js     80105030 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80104fe9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104fec:	89 44 24 04          	mov    %eax,0x4(%esp)
80104ff0:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
80104ff7:	e8 e4 f5 ff ff       	call   801045e0 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80104ffc:	85 c0                	test   %eax,%eax
80104ffe:	78 30                	js     80105030 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
80105000:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105004:	ba 03 00 00 00       	mov    $0x3,%edx
     (ip = create(path, T_DEV, major, minor)) == 0){
80105009:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
8010500d:	89 04 24             	mov    %eax,(%esp)
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
80105010:	8b 45 ec             	mov    -0x14(%ebp),%eax
80105013:	e8 48 f7 ff ff       	call   80104760 <create>
80105018:	85 c0                	test   %eax,%eax
8010501a:	74 14                	je     80105030 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010501c:	89 04 24             	mov    %eax,(%esp)
8010501f:	e8 fc c8 ff ff       	call   80101920 <iunlockput>
  end_op();
80105024:	e8 67 db ff ff       	call   80102b90 <end_op>
  return 0;
80105029:	31 c0                	xor    %eax,%eax
}
8010502b:	c9                   	leave  
8010502c:	c3                   	ret    
8010502d:	8d 76 00             	lea    0x0(%esi),%esi
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105030:	e8 5b db ff ff       	call   80102b90 <end_op>
    return -1;
80105035:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010503a:	c9                   	leave  
8010503b:	c3                   	ret    
8010503c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105040 <sys_chdir>:

int
sys_chdir(void)
{
80105040:	55                   	push   %ebp
80105041:	89 e5                	mov    %esp,%ebp
80105043:	56                   	push   %esi
80105044:	53                   	push   %ebx
80105045:	83 ec 20             	sub    $0x20,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105048:	e8 63 e6 ff ff       	call   801036b0 <myproc>
8010504d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010504f:	e8 cc da ff ff       	call   80102b20 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105054:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105057:	89 44 24 04          	mov    %eax,0x4(%esp)
8010505b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105062:	e8 09 f6 ff ff       	call   80104670 <argstr>
80105067:	85 c0                	test   %eax,%eax
80105069:	78 4a                	js     801050b5 <sys_chdir+0x75>
8010506b:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010506e:	89 04 24             	mov    %eax,(%esp)
80105071:	e8 9a ce ff ff       	call   80101f10 <namei>
80105076:	85 c0                	test   %eax,%eax
80105078:	89 c3                	mov    %eax,%ebx
8010507a:	74 39                	je     801050b5 <sys_chdir+0x75>
    end_op();
    return -1;
  }
  ilock(ip);
8010507c:	89 04 24             	mov    %eax,(%esp)
8010507f:	e8 3c c6 ff ff       	call   801016c0 <ilock>
  if(ip->type != T_DIR){
80105084:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
    iunlockput(ip);
80105089:	89 1c 24             	mov    %ebx,(%esp)
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
8010508c:	75 22                	jne    801050b0 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
8010508e:	e8 0d c7 ff ff       	call   801017a0 <iunlock>
  iput(curproc->cwd);
80105093:	8b 46 68             	mov    0x68(%esi),%eax
80105096:	89 04 24             	mov    %eax,(%esp)
80105099:	e8 42 c7 ff ff       	call   801017e0 <iput>
  end_op();
8010509e:	e8 ed da ff ff       	call   80102b90 <end_op>
  curproc->cwd = ip;
  return 0;
801050a3:	31 c0                	xor    %eax,%eax
    return -1;
  }
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
801050a5:	89 5e 68             	mov    %ebx,0x68(%esi)
  return 0;
}
801050a8:	83 c4 20             	add    $0x20,%esp
801050ab:	5b                   	pop    %ebx
801050ac:	5e                   	pop    %esi
801050ad:	5d                   	pop    %ebp
801050ae:	c3                   	ret    
801050af:	90                   	nop
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801050b0:	e8 6b c8 ff ff       	call   80101920 <iunlockput>
    end_op();
801050b5:	e8 d6 da ff ff       	call   80102b90 <end_op>
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801050ba:	83 c4 20             	add    $0x20,%esp
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
    end_op();
    return -1;
801050bd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  iunlock(ip);
  iput(curproc->cwd);
  end_op();
  curproc->cwd = ip;
  return 0;
}
801050c2:	5b                   	pop    %ebx
801050c3:	5e                   	pop    %esi
801050c4:	5d                   	pop    %ebp
801050c5:	c3                   	ret    
801050c6:	8d 76 00             	lea    0x0(%esi),%esi
801050c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801050d0 <sys_exec>:

int
sys_exec(void)
{
801050d0:	55                   	push   %ebp
801050d1:	89 e5                	mov    %esp,%ebp
801050d3:	57                   	push   %edi
801050d4:	56                   	push   %esi
801050d5:	53                   	push   %ebx
801050d6:	81 ec ac 00 00 00    	sub    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
801050dc:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
801050e2:	89 44 24 04          	mov    %eax,0x4(%esp)
801050e6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801050ed:	e8 7e f5 ff ff       	call   80104670 <argstr>
801050f2:	85 c0                	test   %eax,%eax
801050f4:	0f 88 84 00 00 00    	js     8010517e <sys_exec+0xae>
801050fa:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105100:	89 44 24 04          	mov    %eax,0x4(%esp)
80105104:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
8010510b:	e8 d0 f4 ff ff       	call   801045e0 <argint>
80105110:	85 c0                	test   %eax,%eax
80105112:	78 6a                	js     8010517e <sys_exec+0xae>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105114:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
  for(i=0;; i++){
8010511a:	31 db                	xor    %ebx,%ebx
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
8010511c:	c7 44 24 08 80 00 00 	movl   $0x80,0x8(%esp)
80105123:	00 
80105124:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
8010512a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105131:	00 
80105132:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105138:	89 04 24             	mov    %eax,(%esp)
8010513b:	e8 b0 f1 ff ff       	call   801042f0 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105140:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105146:	89 7c 24 04          	mov    %edi,0x4(%esp)
8010514a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010514d:	89 04 24             	mov    %eax,(%esp)
80105150:	e8 eb f3 ff ff       	call   80104540 <fetchint>
80105155:	85 c0                	test   %eax,%eax
80105157:	78 25                	js     8010517e <sys_exec+0xae>
      return -1;
    if(uarg == 0){
80105159:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
8010515f:	85 c0                	test   %eax,%eax
80105161:	74 2d                	je     80105190 <sys_exec+0xc0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105163:	89 74 24 04          	mov    %esi,0x4(%esp)
80105167:	89 04 24             	mov    %eax,(%esp)
8010516a:	e8 11 f4 ff ff       	call   80104580 <fetchstr>
8010516f:	85 c0                	test   %eax,%eax
80105171:	78 0b                	js     8010517e <sys_exec+0xae>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105173:	83 c3 01             	add    $0x1,%ebx
80105176:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
80105179:	83 fb 20             	cmp    $0x20,%ebx
8010517c:	75 c2                	jne    80105140 <sys_exec+0x70>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
8010517e:	81 c4 ac 00 00 00    	add    $0xac,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
80105184:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
80105189:	5b                   	pop    %ebx
8010518a:	5e                   	pop    %esi
8010518b:	5f                   	pop    %edi
8010518c:	5d                   	pop    %ebp
8010518d:	c3                   	ret    
8010518e:	66 90                	xchg   %ax,%ax
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
80105190:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
80105196:	89 44 24 04          	mov    %eax,0x4(%esp)
8010519a:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801051a0:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801051a7:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801051ab:	89 04 24             	mov    %eax,(%esp)
801051ae:	e8 ed b7 ff ff       	call   801009a0 <exec>
}
801051b3:	81 c4 ac 00 00 00    	add    $0xac,%esp
801051b9:	5b                   	pop    %ebx
801051ba:	5e                   	pop    %esi
801051bb:	5f                   	pop    %edi
801051bc:	5d                   	pop    %ebp
801051bd:	c3                   	ret    
801051be:	66 90                	xchg   %ax,%ax

801051c0 <sys_pipe>:

int
sys_pipe(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	53                   	push   %ebx
801051c4:	83 ec 24             	sub    $0x24,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801051c7:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ca:	c7 44 24 08 08 00 00 	movl   $0x8,0x8(%esp)
801051d1:	00 
801051d2:	89 44 24 04          	mov    %eax,0x4(%esp)
801051d6:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801051dd:	e8 2e f4 ff ff       	call   80104610 <argptr>
801051e2:	85 c0                	test   %eax,%eax
801051e4:	78 6d                	js     80105253 <sys_pipe+0x93>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801051e6:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051e9:	89 44 24 04          	mov    %eax,0x4(%esp)
801051ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051f0:	89 04 24             	mov    %eax,(%esp)
801051f3:	e8 88 df ff ff       	call   80103180 <pipealloc>
801051f8:	85 c0                	test   %eax,%eax
801051fa:	78 57                	js     80105253 <sys_pipe+0x93>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
801051fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
801051ff:	e8 1c f5 ff ff       	call   80104720 <fdalloc>
80105204:	85 c0                	test   %eax,%eax
80105206:	89 c3                	mov    %eax,%ebx
80105208:	78 33                	js     8010523d <sys_pipe+0x7d>
8010520a:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010520d:	e8 0e f5 ff ff       	call   80104720 <fdalloc>
80105212:	85 c0                	test   %eax,%eax
80105214:	78 1a                	js     80105230 <sys_pipe+0x70>
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105216:	8b 55 ec             	mov    -0x14(%ebp),%edx
80105219:	89 1a                	mov    %ebx,(%edx)
  fd[1] = fd1;
8010521b:	8b 55 ec             	mov    -0x14(%ebp),%edx
8010521e:	89 42 04             	mov    %eax,0x4(%edx)
  return 0;
}
80105221:	83 c4 24             	add    $0x24,%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
80105224:	31 c0                	xor    %eax,%eax
}
80105226:	5b                   	pop    %ebx
80105227:	5d                   	pop    %ebp
80105228:	c3                   	ret    
80105229:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105230:	e8 7b e4 ff ff       	call   801036b0 <myproc>
80105235:	c7 44 98 28 00 00 00 	movl   $0x0,0x28(%eax,%ebx,4)
8010523c:	00 
    fileclose(rf);
8010523d:	8b 45 f0             	mov    -0x10(%ebp),%eax
80105240:	89 04 24             	mov    %eax,(%esp)
80105243:	e8 e8 bb ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
80105248:	8b 45 f4             	mov    -0xc(%ebp),%eax
8010524b:	89 04 24             	mov    %eax,(%esp)
8010524e:	e8 dd bb ff ff       	call   80100e30 <fileclose>
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105253:	83 c4 24             	add    $0x24,%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
80105256:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010525b:	5b                   	pop    %ebx
8010525c:	5d                   	pop    %ebp
8010525d:	c3                   	ret    
8010525e:	66 90                	xchg   %ax,%ax

80105260 <sys_fork>:
} ptable;

struct pstat pstat;

int sys_fork(void)
{
80105260:	55                   	push   %ebp
80105261:	89 e5                	mov    %esp,%ebp
  return fork();
}
80105263:	5d                   	pop    %ebp

struct pstat pstat;

int sys_fork(void)
{
  return fork();
80105264:	e9 f7 e5 ff ff       	jmp    80103860 <fork>
80105269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105270 <sys_exit>:
}

int sys_exit(void)
{
80105270:	55                   	push   %ebp
80105271:	89 e5                	mov    %esp,%ebp
80105273:	83 ec 08             	sub    $0x8,%esp
  exit();
80105276:	e8 45 e8 ff ff       	call   80103ac0 <exit>
  return 0; // not reached
}
8010527b:	31 c0                	xor    %eax,%eax
8010527d:	c9                   	leave  
8010527e:	c3                   	ret    
8010527f:	90                   	nop

80105280 <sys_wait>:

int sys_wait(void)
{
80105280:	55                   	push   %ebp
80105281:	89 e5                	mov    %esp,%ebp
  return wait();
}
80105283:	5d                   	pop    %ebp
  return 0; // not reached
}

int sys_wait(void)
{
  return wait();
80105284:	e9 57 ea ff ff       	jmp    80103ce0 <wait>
80105289:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105290 <sys_kill>:
}

int sys_kill(void)
{
80105290:	55                   	push   %ebp
80105291:	89 e5                	mov    %esp,%ebp
80105293:	83 ec 28             	sub    $0x28,%esp
  int pid;

  if (argint(0, &pid) < 0)
80105296:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105299:	89 44 24 04          	mov    %eax,0x4(%esp)
8010529d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052a4:	e8 37 f3 ff ff       	call   801045e0 <argint>
801052a9:	85 c0                	test   %eax,%eax
801052ab:	78 13                	js     801052c0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801052ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
801052b0:	89 04 24             	mov    %eax,(%esp)
801052b3:	e8 88 eb ff ff       	call   80103e40 <kill>
}
801052b8:	c9                   	leave  
801052b9:	c3                   	ret    
801052ba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
int sys_kill(void)
{
  int pid;

  if (argint(0, &pid) < 0)
    return -1;
801052c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801052c5:	c9                   	leave  
801052c6:	c3                   	ret    
801052c7:	89 f6                	mov    %esi,%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801052d0 <sys_getpid>:

int sys_getpid(void)
{
801052d0:	55                   	push   %ebp
801052d1:	89 e5                	mov    %esp,%ebp
801052d3:	83 ec 08             	sub    $0x8,%esp
  return myproc()->pid;
801052d6:	e8 d5 e3 ff ff       	call   801036b0 <myproc>
801052db:	8b 40 10             	mov    0x10(%eax),%eax
}
801052de:	c9                   	leave  
801052df:	c3                   	ret    

801052e0 <sys_sbrk>:

int sys_sbrk(void)
{
801052e0:	55                   	push   %ebp
801052e1:	89 e5                	mov    %esp,%ebp
801052e3:	53                   	push   %ebx
801052e4:	83 ec 24             	sub    $0x24,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
801052e7:	8d 45 f4             	lea    -0xc(%ebp),%eax
801052ea:	89 44 24 04          	mov    %eax,0x4(%esp)
801052ee:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
801052f5:	e8 e6 f2 ff ff       	call   801045e0 <argint>
801052fa:	85 c0                	test   %eax,%eax
801052fc:	78 22                	js     80105320 <sys_sbrk+0x40>
    return -1;
  addr = myproc()->sz;
801052fe:	e8 ad e3 ff ff       	call   801036b0 <myproc>
  if (growproc(n) < 0)
80105303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105306:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
80105308:	89 14 24             	mov    %edx,(%esp)
8010530b:	e8 e0 e4 ff ff       	call   801037f0 <growproc>
80105310:	85 c0                	test   %eax,%eax
80105312:	78 0c                	js     80105320 <sys_sbrk+0x40>
    return -1;
  return addr;
80105314:	89 d8                	mov    %ebx,%eax
}
80105316:	83 c4 24             	add    $0x24,%esp
80105319:	5b                   	pop    %ebx
8010531a:	5d                   	pop    %ebp
8010531b:	c3                   	ret    
8010531c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
80105320:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80105325:	eb ef                	jmp    80105316 <sys_sbrk+0x36>
80105327:	89 f6                	mov    %esi,%esi
80105329:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105330 <sys_sleep>:
    return -1;
  return addr;
}

int sys_sleep(void)
{
80105330:	55                   	push   %ebp
80105331:	89 e5                	mov    %esp,%ebp
80105333:	53                   	push   %ebx
80105334:	83 ec 24             	sub    $0x24,%esp
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
80105337:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010533a:	89 44 24 04          	mov    %eax,0x4(%esp)
8010533e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105345:	e8 96 f2 ff ff       	call   801045e0 <argint>
8010534a:	85 c0                	test   %eax,%eax
8010534c:	78 7e                	js     801053cc <sys_sleep+0x9c>
    return -1;
  acquire(&tickslock);
8010534e:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105355:	e8 d6 ee ff ff       	call   80104230 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n)
8010535a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
8010535d:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  while (ticks - ticks0 < n)
80105363:	85 d2                	test   %edx,%edx
80105365:	75 29                	jne    80105390 <sys_sleep+0x60>
80105367:	eb 4f                	jmp    801053b8 <sys_sleep+0x88>
80105369:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed)
    {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
80105370:	c7 44 24 04 60 53 11 	movl   $0x80115360,0x4(%esp)
80105377:	80 
80105378:	c7 04 24 a0 5b 11 80 	movl   $0x80115ba0,(%esp)
8010537f:	e8 ac e8 ff ff       	call   80103c30 <sleep>

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n)
80105384:	a1 a0 5b 11 80       	mov    0x80115ba0,%eax
80105389:	29 d8                	sub    %ebx,%eax
8010538b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
8010538e:	73 28                	jae    801053b8 <sys_sleep+0x88>
  {
    if (myproc()->killed)
80105390:	e8 1b e3 ff ff       	call   801036b0 <myproc>
80105395:	8b 40 24             	mov    0x24(%eax),%eax
80105398:	85 c0                	test   %eax,%eax
8010539a:	74 d4                	je     80105370 <sys_sleep+0x40>
    {
      release(&tickslock);
8010539c:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801053a3:	e8 f8 ee ff ff       	call   801042a0 <release>
      return -1;
801053a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801053ad:	83 c4 24             	add    $0x24,%esp
801053b0:	5b                   	pop    %ebx
801053b1:	5d                   	pop    %ebp
801053b2:	c3                   	ret    
801053b3:	90                   	nop
801053b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801053b8:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801053bf:	e8 dc ee ff ff       	call   801042a0 <release>
  return 0;
}
801053c4:	83 c4 24             	add    $0x24,%esp
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
801053c7:	31 c0                	xor    %eax,%eax
}
801053c9:	5b                   	pop    %ebx
801053ca:	5d                   	pop    %ebp
801053cb:	c3                   	ret    
{
  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
801053cc:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801053d1:	eb da                	jmp    801053ad <sys_sleep+0x7d>
801053d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801053d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801053e0 <sys_uptime>:
}

// return how many clock tick interrupts have occurred
// since start.
int sys_uptime(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	53                   	push   %ebx
801053e4:	83 ec 14             	sub    $0x14,%esp
  uint xticks;

  acquire(&tickslock);
801053e7:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801053ee:	e8 3d ee ff ff       	call   80104230 <acquire>
  xticks = ticks;
801053f3:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  release(&tickslock);
801053f9:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105400:	e8 9b ee ff ff       	call   801042a0 <release>
  return xticks;
}
80105405:	83 c4 14             	add    $0x14,%esp
80105408:	89 d8                	mov    %ebx,%eax
8010540a:	5b                   	pop    %ebx
8010540b:	5d                   	pop    %ebp
8010540c:	c3                   	ret    
8010540d:	8d 76 00             	lea    0x0(%esi),%esi

80105410 <sys_hello>:

//implemented by Harry
int sys_hello(void)
{
80105410:	55                   	push   %ebp
80105411:	89 e5                	mov    %esp,%ebp
80105413:	83 ec 28             	sub    $0x28,%esp
  int n;
  if (argint(0, &n) < 0)
80105416:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105419:	89 44 24 04          	mov    %eax,0x4(%esp)
8010541d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
80105424:	e8 b7 f1 ff ff       	call   801045e0 <argint>
80105429:	85 c0                	test   %eax,%eax
8010542b:	78 1b                	js     80105448 <sys_hello+0x38>
    return -1;
  cprintf("\nHello World %d\n", n);
8010542d:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105430:	c7 04 24 05 78 10 80 	movl   $0x80107805,(%esp)
80105437:	89 44 24 04          	mov    %eax,0x4(%esp)
8010543b:	e8 10 b2 ff ff       	call   80100650 <cprintf>
  return 0;
80105440:	31 c0                	xor    %eax,%eax
}
80105442:	c9                   	leave  
80105443:	c3                   	ret    
80105444:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
//implemented by Harry
int sys_hello(void)
{
  int n;
  if (argint(0, &n) < 0)
    return -1;
80105448:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  cprintf("\nHello World %d\n", n);
  return 0;
}
8010544d:	c9                   	leave  
8010544e:	c3                   	ret    
8010544f:	90                   	nop

80105450 <sys_halt>:

int sys_halt(void)
{
80105450:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105451:	ba f4 00 00 00       	mov    $0xf4,%edx
80105456:	89 e5                	mov    %esp,%ebp
80105458:	31 c0                	xor    %eax,%eax
8010545a:	ee                   	out    %al,(%dx)
  outb(0xf4, 0x00);
  return 0;
}
8010545b:	31 c0                	xor    %eax,%eax
8010545d:	5d                   	pop    %ebp
8010545e:	c3                   	ret    
8010545f:	90                   	nop

80105460 <sys_gettop>:

int sys_gettop(void)
{
80105460:	55                   	push   %ebp
80105461:	89 e5                	mov    %esp,%ebp
80105463:	57                   	push   %edi
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
80105464:	31 ff                	xor    %edi,%edi
  outb(0xf4, 0x00);
  return 0;
}

int sys_gettop(void)
{
80105466:	56                   	push   %esi
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
80105467:	31 f6                	xor    %esi,%esi
  outb(0xf4, 0x00);
  return 0;
}

int sys_gettop(void)
{
80105469:	53                   	push   %ebx
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
8010546a:	31 db                	xor    %ebx,%ebx
  outb(0xf4, 0x00);
  return 0;
}

int sys_gettop(void)
{
8010546c:	81 ec 8c 00 00 00    	sub    $0x8c,%esp
  cprintf("TOP COMMAND\n");
80105472:	c7 04 24 16 78 10 80 	movl   $0x80107816,(%esp)
80105479:	e8 d2 b1 ff ff       	call   80100650 <cprintf>
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
8010547e:	31 c9                	xor    %ecx,%ecx
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105480:	b8 54 2d 11 80       	mov    $0x80112d54,%eax
      [SLEEPING] "Sleeping ",
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
80105485:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
8010548c:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
80105493:	eb 12                	jmp    801054a7 <sys_gettop+0x47>
80105495:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == 0)
      unused++;
80105498:	83 c1 01             	add    $0x1,%ecx
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
8010549b:	05 84 00 00 00       	add    $0x84,%eax
801054a0:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801054a5:	74 3a                	je     801054e1 <sys_gettop+0x81>
  {
    if (p->state == 0)
801054a7:	8b 50 0c             	mov    0xc(%eax),%edx
801054aa:	85 d2                	test   %edx,%edx
801054ac:	74 ea                	je     80105498 <sys_gettop+0x38>
      unused++;
    else if (p->state == 1)
801054ae:	83 fa 01             	cmp    $0x1,%edx
801054b1:	0f 84 41 03 00 00    	je     801057f8 <sys_gettop+0x398>
      embryo++ ;
    else if (p->state == 2)
801054b7:	83 fa 02             	cmp    $0x2,%edx
801054ba:	0f 84 40 03 00 00    	je     80105800 <sys_gettop+0x3a0>
      sleeping++;
    else if (p->state == 3)
801054c0:	83 fa 03             	cmp    $0x3,%edx
801054c3:	0f 84 3f 03 00 00    	je     80105808 <sys_gettop+0x3a8>
      runnable++;
    else if (p->state == 4)
801054c9:	83 fa 04             	cmp    $0x4,%edx
801054cc:	0f 84 46 03 00 00    	je     80105818 <sys_gettop+0x3b8>
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801054d2:	05 84 00 00 00       	add    $0x84,%eax
    else if (p->state == 3)
      runnable++;
    else if (p->state == 4)
      running++;
    else
      zombie++;
801054d7:	83 c6 01             	add    $0x1,%esi
      [RUNNABLE] "Runnable",
      [RUNNING] "Running",
      [ZOMBIE] "Zombie"};
  // Count of processes in different states
  int unused = 0, embryo = 0, sleeping = 0, runnable = 0, running = 0, zombie = 0;
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801054da:	3d 54 4e 11 80       	cmp    $0x80114e54,%eax
801054df:	75 c6                	jne    801054a7 <sys_gettop+0x47>
      zombie++;
  }
  // getting the size of physical memory
  int mem = (int)PHYSTOP;
  // printing stats
  cprintf("\nUser : Root \nTasks: \nTotal: %d  Unused: %d  Embryo: %d  Sleeping: %d Runnable: %d  Running: %d  Zombie: %d",
801054e1:	8b 45 c0             	mov    -0x40(%ebp),%eax
801054e4:	89 4c 24 08          	mov    %ecx,0x8(%esp)
801054e8:	89 74 24 1c          	mov    %esi,0x1c(%esp)
801054ec:	be c0 2d 11 80       	mov    $0x80112dc0,%esi
801054f1:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
801054f5:	89 44 24 18          	mov    %eax,0x18(%esp)
801054f9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
801054fc:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105500:	c7 44 24 04 40 00 00 	movl   $0x40,0x4(%esp)
80105507:	00 
80105508:	c7 04 24 74 78 10 80 	movl   $0x80107874,(%esp)
8010550f:	89 44 24 14          	mov    %eax,0x14(%esp)
80105513:	e8 38 b1 ff ff       	call   80100650 <cprintf>
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
80105518:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
8010551f:	e8 0c ed ff ff       	call   80104230 <acquire>
  xticks = ticks;
80105524:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  release(&tickslock);
8010552a:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105531:	e8 6a ed ff ff       	call   801042a0 <release>
  // getting the size of physical memory
  int mem = (int)PHYSTOP;
  // printing stats
  cprintf("\nUser : Root \nTasks: \nTotal: %d  Unused: %d  Embryo: %d  Sleeping: %d Runnable: %d  Running: %d  Zombie: %d",
      NPROC,unused,embryo,sleeping,runnable,running,zombie);
  cprintf("\nCPU Size : %d \nTicks : %d\n",mem,sys_uptime());
80105536:	c7 44 24 04 00 00 00 	movl   $0xe000000,0x4(%esp)
8010553d:	0e 
8010553e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
80105542:	c7 04 24 23 78 10 80 	movl   $0x80107823,(%esp)
80105549:	e8 02 b1 ff ff       	call   80100650 <cprintf>
  cprintf("\nPID   USER   COMMAND   STATE        RES     TIME+      %%MEM    %%CPU");
8010554e:	c7 04 24 e0 78 10 80 	movl   $0x801078e0,(%esp)
80105555:	e8 f6 b0 ff ff       	call   80100650 <cprintf>
8010555a:	eb 16                	jmp    80105572 <sys_gettop+0x112>
8010555c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105560:	81 c6 84 00 00 00    	add    $0x84,%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80105566:	81 fe c0 4e 11 80    	cmp    $0x80114ec0,%esi
8010556c:	0f 84 76 02 00 00    	je     801057e8 <sys_gettop+0x388>
  {
     if (p->pid != 0)
80105572:	8b 46 a4             	mov    -0x5c(%esi),%eax
80105575:	85 c0                	test   %eax,%eax
80105577:	74 e7                	je     80105560 <sys_gettop+0x100>
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
80105579:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105580:	8d 7d d0             	lea    -0x30(%ebp),%edi
80105583:	e8 a8 ec ff ff       	call   80104230 <acquire>
  xticks = ticks;
80105588:	8b 1d a0 5b 11 80    	mov    0x80115ba0,%ebx
  release(&tickslock);
8010558e:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105595:	e8 06 ed ff ff       	call   801042a0 <release>

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
8010559a:	b8 1f 85 eb 51       	mov    $0x51eb851f,%eax
  {
     if (p->pid != 0)
     {

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
8010559f:	2b 5e 14             	sub    0x14(%esi),%ebx
801055a2:	89 7d bc             	mov    %edi,-0x44(%ebp)
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
      {
        rem = rem * 10;
        res[i] = rem / mem;
801055a5:	bf 93 24 49 92       	mov    $0x92492493,%edi
      int timedecimal = 0;
      int res[6];
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
801055aa:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
801055b1:	f7 eb                	imul   %ebx
801055b3:	89 d8                	mov    %ebx,%eax
801055b5:	c1 f8 1f             	sar    $0x1f,%eax
  {
     if (p->pid != 0)
     {

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
801055b8:	89 5e 10             	mov    %ebx,0x10(%esi)
      int timedecimal = 0;
      int res[6];
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
801055bb:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
801055c2:	89 d1                	mov    %edx,%ecx
      int minutes = seconds / 60;
801055c4:	ba 89 88 88 88       	mov    $0x88888889,%edx

      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
801055c9:	c1 f9 05             	sar    $0x5,%ecx
801055cc:	29 c1                	sub    %eax,%ecx
      int minutes = seconds / 60;
801055ce:	89 c8                	mov    %ecx,%eax
801055d0:	f7 ea                	imul   %edx
      int timedecimal = 0;
      int res[6];
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
801055d2:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
801055d9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801055e0:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
801055e7:	8d 04 0a             	lea    (%edx,%ecx,1),%eax
      no_ticks = no_ticks - (seconds * 100);
      seconds = seconds - (minutes * 60);
      int size = (int)p->sz;
      int rem = size % mem;
801055ea:	ba 93 24 49 92       	mov    $0x92492493,%edx
      // TIME+
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
801055ef:	89 45 c0             	mov    %eax,-0x40(%ebp)
801055f2:	89 c8                	mov    %ecx,%eax
801055f4:	c1 7d c0 05          	sarl   $0x5,-0x40(%ebp)
801055f8:	c1 f8 1f             	sar    $0x1f,%eax
801055fb:	29 45 c0             	sub    %eax,-0x40(%ebp)
      no_ticks = no_ticks - (seconds * 100);
801055fe:	6b c1 9c             	imul   $0xffffff9c,%ecx,%eax
      int timedecimal = 0;
      int res[6];
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
80105601:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
      no_ticks = no_ticks - (seconds * 100);
80105608:	01 d8                	add    %ebx,%eax
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
8010560a:	31 db                	xor    %ebx,%ebx
      p->calticks = sys_uptime() - p->myticks;
      no_ticks = (p->calticks);
      //division
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
      no_ticks = no_ticks - (seconds * 100);
8010560c:	89 45 ac             	mov    %eax,-0x54(%ebp)
      seconds = seconds - (minutes * 60);
8010560f:	6b 45 c0 c4          	imul   $0xffffffc4,-0x40(%ebp),%eax
80105613:	01 c8                	add    %ecx,%eax
80105615:	89 45 a8             	mov    %eax,-0x58(%ebp)
      int size = (int)p->sz;
80105618:	8b 46 94             	mov    -0x6c(%esi),%eax
8010561b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
      int rem = size % mem;
8010561e:	f7 ea                	imul   %edx
80105620:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105623:	01 c2                	add    %eax,%edx
80105625:	c1 fa 1b             	sar    $0x1b,%edx
80105628:	c1 f8 1f             	sar    $0x1f,%eax
8010562b:	89 d1                	mov    %edx,%ecx
8010562d:	29 c1                	sub    %eax,%ecx
      int timewhole = size / mem;
8010562f:	29 c2                	sub    %eax,%edx
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
80105631:	8b 45 c4             	mov    -0x3c(%ebp),%eax
      int seconds = no_ticks / 100;
      int minutes = seconds / 60;
      no_ticks = no_ticks - (seconds * 100);
      seconds = seconds - (minutes * 60);
      int size = (int)p->sz;
      int rem = size % mem;
80105634:	69 c9 00 00 00 0e    	imul   $0xe000000,%ecx,%ecx
      int timewhole = size / mem;
8010563a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
8010563d:	29 c8                	sub    %ecx,%eax
8010563f:	89 c1                	mov    %eax,%ecx
80105641:	74 3c                	je     8010567f <sys_gettop+0x21f>
80105643:	89 75 b8             	mov    %esi,-0x48(%ebp)
80105646:	8b 75 bc             	mov    -0x44(%ebp),%esi
80105649:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      {
        rem = rem * 10;
80105650:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
80105653:	01 c9                	add    %ecx,%ecx
        res[i] = rem / mem;
80105655:	89 c8                	mov    %ecx,%eax
80105657:	f7 ef                	imul   %edi
80105659:	89 c8                	mov    %ecx,%eax
8010565b:	c1 f8 1f             	sar    $0x1f,%eax
8010565e:	01 ca                	add    %ecx,%edx
80105660:	c1 fa 1b             	sar    $0x1b,%edx
80105663:	29 c2                	sub    %eax,%edx
80105665:	89 14 9e             	mov    %edx,(%esi,%ebx,4)
        rem = rem - (mem * res[i]);
80105668:	69 d2 00 00 00 0e    	imul   $0xe000000,%edx,%edx
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
8010566e:	83 c3 01             	add    $0x1,%ebx
      {
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
80105671:	29 d1                	sub    %edx,%ecx
      int i;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
80105673:	83 fb 05             	cmp    $0x5,%ebx
80105676:	7f 04                	jg     8010567c <sys_gettop+0x21c>
80105678:	85 c9                	test   %ecx,%ecx
8010567a:	75 d4                	jne    80105650 <sys_gettop+0x1f0>
8010567c:	8b 75 b8             	mov    -0x48(%ebp),%esi
      {
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
8010567f:	8b 45 d0             	mov    -0x30(%ebp),%eax
      no_ticks = no_ticks - (seconds * 100);
      seconds = seconds - (minutes * 60);
      int size = (int)p->sz;
      int rem = size % mem;
      int timewhole = size / mem;
      int timedecimal = 0;
80105682:	31 ff                	xor    %edi,%edi
      {
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
80105684:	6b 55 b4 64          	imul   $0x64,-0x4c(%ebp),%edx
80105688:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010568b:	8d 04 42             	lea    (%edx,%eax,2),%eax
8010568e:	89 45 b8             	mov    %eax,-0x48(%ebp)
80105691:	8b 45 d4             	mov    -0x2c(%ebp),%eax
80105694:	01 45 b8             	add    %eax,-0x48(%ebp)
80105697:	8d 45 d8             	lea    -0x28(%ebp),%eax
      for (i = 2; i < 6; i++)
      {
        timedecimal = (timedecimal * 10) + res[i];
8010569a:	8b 10                	mov    (%eax),%edx
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
8010569c:	8d 5d e8             	lea    -0x18(%ebp),%ebx
8010569f:	83 c0 04             	add    $0x4,%eax
      {
        timedecimal = (timedecimal * 10) + res[i];
801056a2:	8d 0c bf             	lea    (%edi,%edi,4),%ecx
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
801056a5:	39 d8                	cmp    %ebx,%eax
      {
        timedecimal = (timedecimal * 10) + res[i];
801056a7:	8d 3c 4a             	lea    (%edx,%ecx,2),%edi
        rem = rem * 10;
        res[i] = rem / mem;
        rem = rem - (mem * res[i]);
      }
      timewhole = (timewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
801056aa:	75 ee                	jne    8010569a <sys_gettop+0x23a>
// since start.
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
801056ac:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
801056b3:	e8 78 eb ff ff       	call   80104230 <acquire>
  xticks = ticks;
801056b8:	a1 a0 5b 11 80       	mov    0x80115ba0,%eax
  release(&tickslock);
801056bd:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
int sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
801056c4:	89 c3                	mov    %eax,%ebx
801056c6:	89 45 a0             	mov    %eax,-0x60(%ebp)
  release(&tickslock);
801056c9:	e8 d2 eb ff ff       	call   801042a0 <release>
        timedecimal = (timedecimal * 10) + res[i];
      }

      // %CPU
      int total_time = sys_uptime();
      int elapsed_time = p->calticks;
801056ce:	8b 46 10             	mov    0x10(%esi),%eax
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
801056d1:	31 c9                	xor    %ecx,%ecx
      rem = elapsed_time % total_time;
      usagewhole = elapsed_time / total_time;
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
801056d3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
801056da:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
801056e1:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
      // %CPU
      int total_time = sys_uptime();
      int elapsed_time = p->calticks;
      int usagewhole, usagedecimal;
      //division
      rem = elapsed_time % total_time;
801056e8:	99                   	cltd   
801056e9:	f7 fb                	idiv   %ebx
      usagewhole = elapsed_time / total_time;
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
801056eb:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
801056f2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
801056f9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
      // %CPU
      int total_time = sys_uptime();
      int elapsed_time = p->calticks;
      int usagewhole, usagedecimal;
      //division
      rem = elapsed_time % total_time;
80105700:	89 45 a4             	mov    %eax,-0x5c(%ebp)
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
80105703:	85 d2                	test   %edx,%edx
80105705:	8d 45 d0             	lea    -0x30(%ebp),%eax
80105708:	89 45 bc             	mov    %eax,-0x44(%ebp)
8010570b:	74 37                	je     80105744 <sys_gettop+0x2e4>
8010570d:	89 7d b4             	mov    %edi,-0x4c(%ebp)
80105710:	8b 7d bc             	mov    -0x44(%ebp),%edi
80105713:	89 d3                	mov    %edx,%ebx
80105715:	89 75 b0             	mov    %esi,-0x50(%ebp)
80105718:	8b 75 a0             	mov    -0x60(%ebp),%esi
8010571b:	90                   	nop
8010571c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      {
        rem = rem * 10;
80105720:	8d 1c 9b             	lea    (%ebx,%ebx,4),%ebx
80105723:	01 db                	add    %ebx,%ebx
        res[i] = rem / total_time;
80105725:	89 d8                	mov    %ebx,%eax
80105727:	99                   	cltd   
80105728:	f7 fe                	idiv   %esi
8010572a:	89 04 8f             	mov    %eax,(%edi,%ecx,4)
        rem = rem - (total_time * res[i]);
8010572d:	0f af c6             	imul   %esi,%eax
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
80105730:	83 c1 01             	add    $0x1,%ecx
      {
        rem = rem * 10;
        res[i] = rem / total_time;
        rem = rem - (total_time * res[i]);
80105733:	29 c3                	sub    %eax,%ebx
      usagedecimal = 0;
      for (i = 0; i < 6; i++)
      {
        res[i] = 0;
      }
      for (i = 0; i < 6 && rem != 0; i++)
80105735:	83 f9 05             	cmp    $0x5,%ecx
80105738:	7f 04                	jg     8010573e <sys_gettop+0x2de>
8010573a:	85 db                	test   %ebx,%ebx
8010573c:	75 e2                	jne    80105720 <sys_gettop+0x2c0>
8010573e:	8b 7d b4             	mov    -0x4c(%ebp),%edi
80105741:	8b 75 b0             	mov    -0x50(%ebp),%esi
      {
        rem = rem * 10;
        res[i] = rem / total_time;
        rem = rem - (total_time * res[i]);
      }
      usagewhole = (usagewhole * 100) + (res[0] * 10) + (res[1] * 1);
80105744:	8b 45 d0             	mov    -0x30(%ebp),%eax
80105747:	6b 55 a4 64          	imul   $0x64,-0x5c(%ebp),%edx
8010574b:	8d 04 80             	lea    (%eax,%eax,4),%eax
8010574e:	8d 1c 42             	lea    (%edx,%eax,2),%ebx
      int elapsed_time = p->calticks;
      int usagewhole, usagedecimal;
      //division
      rem = elapsed_time % total_time;
      usagewhole = elapsed_time / total_time;
      usagedecimal = 0;
80105751:	31 d2                	xor    %edx,%edx
      {
        rem = rem * 10;
        res[i] = rem / total_time;
        rem = rem - (total_time * res[i]);
      }
      usagewhole = (usagewhole * 100) + (res[0] * 10) + (res[1] * 1);
80105753:	03 5d d4             	add    -0x2c(%ebp),%ebx
80105756:	8d 45 d8             	lea    -0x28(%ebp),%eax
      for (i = 2; i < 6; i++)
      {
        usagedecimal = (usagedecimal * 10) + res[i];
80105759:	8d 0c 92             	lea    (%edx,%edx,4),%ecx
8010575c:	8b 10                	mov    (%eax),%edx
8010575e:	83 c0 04             	add    $0x4,%eax
80105761:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
        rem = rem * 10;
        res[i] = rem / total_time;
        rem = rem - (total_time * res[i]);
      }
      usagewhole = (usagewhole * 100) + (res[0] * 10) + (res[1] * 1);
      for (i = 2; i < 6; i++)
80105764:	8d 4d e8             	lea    -0x18(%ebp),%ecx
80105767:	39 c8                	cmp    %ecx,%eax
80105769:	75 ee                	jne    80105759 <sys_gettop+0x2f9>
      {
        usagedecimal = (usagedecimal * 10) + res[i];
      }

      //print
      cprintf("\n %d    %s    %s    %s   %d    %d:%d.%d     %d.%d    %d.%d",
8010576b:	8b 45 b8             	mov    -0x48(%ebp),%eax
8010576e:	89 54 24 30          	mov    %edx,0x30(%esp)
80105772:	89 5c 24 2c          	mov    %ebx,0x2c(%esp)
80105776:	89 7c 24 28          	mov    %edi,0x28(%esp)
8010577a:	89 44 24 24          	mov    %eax,0x24(%esp)
8010577e:	8b 45 ac             	mov    -0x54(%ebp),%eax
80105781:	89 44 24 20          	mov    %eax,0x20(%esp)
80105785:	8b 45 a8             	mov    -0x58(%ebp),%eax
80105788:	89 44 24 1c          	mov    %eax,0x1c(%esp)
8010578c:	8b 45 c0             	mov    -0x40(%ebp),%eax
8010578f:	89 44 24 18          	mov    %eax,0x18(%esp)
80105793:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80105796:	89 44 24 14          	mov    %eax,0x14(%esp)
8010579a:	8b 46 a0             	mov    -0x60(%esi),%eax
8010579d:	89 74 24 0c          	mov    %esi,0xc(%esp)
801057a1:	81 c6 84 00 00 00    	add    $0x84,%esi
801057a7:	c7 44 24 08 3f 78 10 	movl   $0x8010783f,0x8(%esp)
801057ae:	80 
801057af:	8b 04 85 64 79 10 80 	mov    -0x7fef869c(,%eax,4),%eax
801057b6:	89 44 24 10          	mov    %eax,0x10(%esp)
801057ba:	8b 86 20 ff ff ff    	mov    -0xe0(%esi),%eax
801057c0:	c7 04 24 28 79 10 80 	movl   $0x80107928,(%esp)
801057c7:	89 44 24 04          	mov    %eax,0x4(%esp)
801057cb:	e8 80 ae ff ff       	call   80100650 <cprintf>
              p->pid, "root", p->name, states[p->state], size,
              minutes, seconds, no_ticks, timewhole, timedecimal, usagewhole, usagedecimal);
      cprintf("\n");
801057d0:	c7 04 24 5b 7b 10 80 	movl   $0x80107b5b,(%esp)
801057d7:	e8 74 ae ff ff       	call   80100650 <cprintf>
  // printing stats
  cprintf("\nUser : Root \nTasks: \nTotal: %d  Unused: %d  Embryo: %d  Sleeping: %d Runnable: %d  Running: %d  Zombie: %d",
      NPROC,unused,embryo,sleeping,runnable,running,zombie);
  cprintf("\nCPU Size : %d \nTicks : %d\n",mem,sys_uptime());
  cprintf("\nPID   USER   COMMAND   STATE        RES     TIME+      %%MEM    %%CPU");
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801057dc:	81 fe c0 4e 11 80    	cmp    $0x80114ec0,%esi
801057e2:	0f 85 8a fd ff ff    	jne    80105572 <sys_gettop+0x112>
      cprintf("\n");
    }
  }

  return 0;
801057e8:	81 c4 8c 00 00 00    	add    $0x8c,%esp
801057ee:	31 c0                	xor    %eax,%eax
801057f0:	5b                   	pop    %ebx
801057f1:	5e                   	pop    %esi
801057f2:	5f                   	pop    %edi
801057f3:	5d                   	pop    %ebp
801057f4:	c3                   	ret    
801057f5:	8d 76 00             	lea    0x0(%esi),%esi
  for (p = ptable.proc; p < &ptable.proc[NPROC]; p++)
  {
    if (p->state == 0)
      unused++;
    else if (p->state == 1)
      embryo++ ;
801057f8:	83 c3 01             	add    $0x1,%ebx
801057fb:	e9 9b fc ff ff       	jmp    8010549b <sys_gettop+0x3b>
    else if (p->state == 2)
      sleeping++;
80105800:	83 c7 01             	add    $0x1,%edi
80105803:	e9 93 fc ff ff       	jmp    8010549b <sys_gettop+0x3b>
    else if (p->state == 3)
      runnable++;
80105808:	83 45 c4 01          	addl   $0x1,-0x3c(%ebp)
8010580c:	e9 8a fc ff ff       	jmp    8010549b <sys_gettop+0x3b>
80105811:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    else if (p->state == 4)
      running++;
80105818:	83 45 c0 01          	addl   $0x1,-0x40(%ebp)
8010581c:	e9 7a fc ff ff       	jmp    8010549b <sys_gettop+0x3b>

80105821 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
80105821:	1e                   	push   %ds
  pushl %es
80105822:	06                   	push   %es
  pushl %fs
80105823:	0f a0                	push   %fs
  pushl %gs
80105825:	0f a8                	push   %gs
  pushal
80105827:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
80105828:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
8010582c:	8e d8                	mov    %eax,%ds
  movw %ax, %es
8010582e:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
80105830:	54                   	push   %esp
  call trap
80105831:	e8 ea 00 00 00       	call   80105920 <trap>
  addl $4, %esp
80105836:	83 c4 04             	add    $0x4,%esp

80105839 <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
80105839:	61                   	popa   
  popl %gs
8010583a:	0f a9                	pop    %gs
  popl %fs
8010583c:	0f a1                	pop    %fs
  popl %es
8010583e:	07                   	pop    %es
  popl %ds
8010583f:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
80105840:	83 c4 08             	add    $0x8,%esp
  iret
80105843:	cf                   	iret   
80105844:	66 90                	xchg   %ax,%ax
80105846:	66 90                	xchg   %ax,%ax
80105848:	66 90                	xchg   %ax,%ax
8010584a:	66 90                	xchg   %ax,%ax
8010584c:	66 90                	xchg   %ax,%ax
8010584e:	66 90                	xchg   %ax,%ax

80105850 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
80105850:	31 c0                	xor    %eax,%eax
80105852:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
80105858:	8b 14 85 08 a0 10 80 	mov    -0x7fef5ff8(,%eax,4),%edx
8010585f:	b9 08 00 00 00       	mov    $0x8,%ecx
80105864:	66 89 0c c5 a2 53 11 	mov    %cx,-0x7feeac5e(,%eax,8)
8010586b:	80 
8010586c:	c6 04 c5 a4 53 11 80 	movb   $0x0,-0x7feeac5c(,%eax,8)
80105873:	00 
80105874:	c6 04 c5 a5 53 11 80 	movb   $0x8e,-0x7feeac5b(,%eax,8)
8010587b:	8e 
8010587c:	66 89 14 c5 a0 53 11 	mov    %dx,-0x7feeac60(,%eax,8)
80105883:	80 
80105884:	c1 ea 10             	shr    $0x10,%edx
80105887:	66 89 14 c5 a6 53 11 	mov    %dx,-0x7feeac5a(,%eax,8)
8010588e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010588f:	83 c0 01             	add    $0x1,%eax
80105892:	3d 00 01 00 00       	cmp    $0x100,%eax
80105897:	75 bf                	jne    80105858 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105899:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010589a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010589f:	89 e5                	mov    %esp,%ebp
801058a1:	83 ec 18             	sub    $0x18,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058a4:	a1 08 a1 10 80       	mov    0x8010a108,%eax

  initlock(&tickslock, "time");
801058a9:	c7 44 24 04 7c 79 10 	movl   $0x8010797c,0x4(%esp)
801058b0:	80 
801058b1:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
801058b8:	66 89 15 a2 55 11 80 	mov    %dx,0x801155a2
801058bf:	66 a3 a0 55 11 80    	mov    %ax,0x801155a0
801058c5:	c1 e8 10             	shr    $0x10,%eax
801058c8:	c6 05 a4 55 11 80 00 	movb   $0x0,0x801155a4
801058cf:	c6 05 a5 55 11 80 ef 	movb   $0xef,0x801155a5
801058d6:	66 a3 a6 55 11 80    	mov    %ax,0x801155a6

  initlock(&tickslock, "time");
801058dc:	e8 df e7 ff ff       	call   801040c0 <initlock>
}
801058e1:	c9                   	leave  
801058e2:	c3                   	ret    
801058e3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801058e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058f0 <idtinit>:

void
idtinit(void)
{
801058f0:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801058f1:	b8 ff 07 00 00       	mov    $0x7ff,%eax
801058f6:	89 e5                	mov    %esp,%ebp
801058f8:	83 ec 10             	sub    $0x10,%esp
801058fb:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
801058ff:	b8 a0 53 11 80       	mov    $0x801153a0,%eax
80105904:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105908:	c1 e8 10             	shr    $0x10,%eax
8010590b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010590f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105912:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105915:	c9                   	leave  
80105916:	c3                   	ret    
80105917:	89 f6                	mov    %esi,%esi
80105919:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105920 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
80105920:	55                   	push   %ebp
80105921:	89 e5                	mov    %esp,%ebp
80105923:	57                   	push   %edi
80105924:	56                   	push   %esi
80105925:	53                   	push   %ebx
80105926:	83 ec 3c             	sub    $0x3c,%esp
80105929:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(tf->trapno == T_SYSCALL){
8010592c:	8b 43 30             	mov    0x30(%ebx),%eax
8010592f:	83 f8 40             	cmp    $0x40,%eax
80105932:	0f 84 a0 01 00 00    	je     80105ad8 <trap+0x1b8>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
80105938:	83 e8 20             	sub    $0x20,%eax
8010593b:	83 f8 1f             	cmp    $0x1f,%eax
8010593e:	77 08                	ja     80105948 <trap+0x28>
80105940:	ff 24 85 24 7a 10 80 	jmp    *-0x7fef85dc(,%eax,4)
80105947:	90                   	nop
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
80105948:	e8 63 dd ff ff       	call   801036b0 <myproc>
8010594d:	85 c0                	test   %eax,%eax
8010594f:	90                   	nop
80105950:	0f 84 fa 01 00 00    	je     80105b50 <trap+0x230>
80105956:	f6 43 3c 03          	testb  $0x3,0x3c(%ebx)
8010595a:	0f 84 f0 01 00 00    	je     80105b50 <trap+0x230>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
80105960:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105963:	8b 53 38             	mov    0x38(%ebx),%edx
80105966:	89 4d d8             	mov    %ecx,-0x28(%ebp)
80105969:	89 55 dc             	mov    %edx,-0x24(%ebp)
8010596c:	e8 1f dd ff ff       	call   80103690 <cpuid>
80105971:	8b 73 30             	mov    0x30(%ebx),%esi
80105974:	89 c7                	mov    %eax,%edi
80105976:	8b 43 34             	mov    0x34(%ebx),%eax
80105979:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010597c:	e8 2f dd ff ff       	call   801036b0 <myproc>
80105981:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105984:	e8 27 dd ff ff       	call   801036b0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105989:	8b 55 dc             	mov    -0x24(%ebp),%edx
8010598c:	89 74 24 0c          	mov    %esi,0xc(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105990:	8b 75 e0             	mov    -0x20(%ebp),%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105993:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105996:	89 7c 24 14          	mov    %edi,0x14(%esp)
8010599a:	89 54 24 18          	mov    %edx,0x18(%esp)
8010599e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801059a1:	83 c6 6c             	add    $0x6c,%esi
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059a4:	89 4c 24 1c          	mov    %ecx,0x1c(%esp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
801059a8:	89 74 24 08          	mov    %esi,0x8(%esp)
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801059ac:	89 54 24 10          	mov    %edx,0x10(%esp)
801059b0:	8b 40 10             	mov    0x10(%eax),%eax
801059b3:	c7 04 24 e0 79 10 80 	movl   $0x801079e0,(%esp)
801059ba:	89 44 24 04          	mov    %eax,0x4(%esp)
801059be:	e8 8d ac ff ff       	call   80100650 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
801059c3:	e8 e8 dc ff ff       	call   801036b0 <myproc>
801059c8:	c7 40 24 01 00 00 00 	movl   $0x1,0x24(%eax)
801059cf:	90                   	nop
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059d0:	e8 db dc ff ff       	call   801036b0 <myproc>
801059d5:	85 c0                	test   %eax,%eax
801059d7:	74 0c                	je     801059e5 <trap+0xc5>
801059d9:	e8 d2 dc ff ff       	call   801036b0 <myproc>
801059de:	8b 50 24             	mov    0x24(%eax),%edx
801059e1:	85 d2                	test   %edx,%edx
801059e3:	75 4b                	jne    80105a30 <trap+0x110>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059e5:	e8 c6 dc ff ff       	call   801036b0 <myproc>
801059ea:	85 c0                	test   %eax,%eax
801059ec:	74 0d                	je     801059fb <trap+0xdb>
801059ee:	66 90                	xchg   %ax,%ax
801059f0:	e8 bb dc ff ff       	call   801036b0 <myproc>
801059f5:	83 78 0c 04          	cmpl   $0x4,0xc(%eax)
801059f9:	74 4d                	je     80105a48 <trap+0x128>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059fb:	e8 b0 dc ff ff       	call   801036b0 <myproc>
80105a00:	85 c0                	test   %eax,%eax
80105a02:	74 1d                	je     80105a21 <trap+0x101>
80105a04:	e8 a7 dc ff ff       	call   801036b0 <myproc>
80105a09:	8b 40 24             	mov    0x24(%eax),%eax
80105a0c:	85 c0                	test   %eax,%eax
80105a0e:	74 11                	je     80105a21 <trap+0x101>
80105a10:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a14:	83 e0 03             	and    $0x3,%eax
80105a17:	66 83 f8 03          	cmp    $0x3,%ax
80105a1b:	0f 84 e8 00 00 00    	je     80105b09 <trap+0x1e9>
    exit();
}
80105a21:	83 c4 3c             	add    $0x3c,%esp
80105a24:	5b                   	pop    %ebx
80105a25:	5e                   	pop    %esi
80105a26:	5f                   	pop    %edi
80105a27:	5d                   	pop    %ebp
80105a28:	c3                   	ret    
80105a29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105a30:	0f b7 43 3c          	movzwl 0x3c(%ebx),%eax
80105a34:	83 e0 03             	and    $0x3,%eax
80105a37:	66 83 f8 03          	cmp    $0x3,%ax
80105a3b:	75 a8                	jne    801059e5 <trap+0xc5>
    exit();
80105a3d:	e8 7e e0 ff ff       	call   80103ac0 <exit>
80105a42:	eb a1                	jmp    801059e5 <trap+0xc5>
80105a44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105a48:	83 7b 30 20          	cmpl   $0x20,0x30(%ebx)
80105a4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105a50:	75 a9                	jne    801059fb <trap+0xdb>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
80105a52:	e8 99 e1 ff ff       	call   80103bf0 <yield>
80105a57:	eb a2                	jmp    801059fb <trap+0xdb>
80105a59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
80105a60:	e8 2b dc ff ff       	call   80103690 <cpuid>
80105a65:	85 c0                	test   %eax,%eax
80105a67:	0f 84 b3 00 00 00    	je     80105b20 <trap+0x200>
80105a6d:	8d 76 00             	lea    0x0(%esi),%esi
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
80105a70:	e8 1b cd ff ff       	call   80102790 <lapiceoi>
    break;
80105a75:	e9 56 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a7a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
80105a80:	e8 5b cb ff ff       	call   801025e0 <kbdintr>
    lapiceoi();
80105a85:	e8 06 cd ff ff       	call   80102790 <lapiceoi>
    break;
80105a8a:	e9 41 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a8f:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
80105a90:	e8 1b 02 00 00       	call   80105cb0 <uartintr>
    lapiceoi();
80105a95:	e8 f6 cc ff ff       	call   80102790 <lapiceoi>
    break;
80105a9a:	e9 31 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105a9f:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105aa0:	8b 7b 38             	mov    0x38(%ebx),%edi
80105aa3:	0f b7 73 3c          	movzwl 0x3c(%ebx),%esi
80105aa7:	e8 e4 db ff ff       	call   80103690 <cpuid>
80105aac:	c7 04 24 88 79 10 80 	movl   $0x80107988,(%esp)
80105ab3:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80105ab7:	89 74 24 08          	mov    %esi,0x8(%esp)
80105abb:	89 44 24 04          	mov    %eax,0x4(%esp)
80105abf:	e8 8c ab ff ff       	call   80100650 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105ac4:	e8 c7 cc ff ff       	call   80102790 <lapiceoi>
    break;
80105ac9:	e9 02 ff ff ff       	jmp    801059d0 <trap+0xb0>
80105ace:	66 90                	xchg   %ax,%ax
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105ad0:	e8 bb c5 ff ff       	call   80102090 <ideintr>
80105ad5:	eb 96                	jmp    80105a6d <trap+0x14d>
80105ad7:	90                   	nop
80105ad8:	90                   	nop
80105ad9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105ae0:	e8 cb db ff ff       	call   801036b0 <myproc>
80105ae5:	8b 70 24             	mov    0x24(%eax),%esi
80105ae8:	85 f6                	test   %esi,%esi
80105aea:	75 2c                	jne    80105b18 <trap+0x1f8>
      exit();
    myproc()->tf = tf;
80105aec:	e8 bf db ff ff       	call   801036b0 <myproc>
80105af1:	89 58 18             	mov    %ebx,0x18(%eax)
    syscall();
80105af4:	e8 b7 eb ff ff       	call   801046b0 <syscall>
    if(myproc()->killed)
80105af9:	e8 b2 db ff ff       	call   801036b0 <myproc>
80105afe:	8b 48 24             	mov    0x24(%eax),%ecx
80105b01:	85 c9                	test   %ecx,%ecx
80105b03:	0f 84 18 ff ff ff    	je     80105a21 <trap+0x101>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105b09:	83 c4 3c             	add    $0x3c,%esp
80105b0c:	5b                   	pop    %ebx
80105b0d:	5e                   	pop    %esi
80105b0e:	5f                   	pop    %edi
80105b0f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105b10:	e9 ab df ff ff       	jmp    80103ac0 <exit>
80105b15:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105b18:	e8 a3 df ff ff       	call   80103ac0 <exit>
80105b1d:	eb cd                	jmp    80105aec <trap+0x1cc>
80105b1f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105b20:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105b27:	e8 04 e7 ff ff       	call   80104230 <acquire>
      ticks++;
      wakeup(&ticks);
80105b2c:	c7 04 24 a0 5b 11 80 	movl   $0x80115ba0,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105b33:	83 05 a0 5b 11 80 01 	addl   $0x1,0x80115ba0
      wakeup(&ticks);
80105b3a:	e8 91 e2 ff ff       	call   80103dd0 <wakeup>
      release(&tickslock);
80105b3f:	c7 04 24 60 53 11 80 	movl   $0x80115360,(%esp)
80105b46:	e8 55 e7 ff ff       	call   801042a0 <release>
80105b4b:	e9 1d ff ff ff       	jmp    80105a6d <trap+0x14d>
80105b50:	0f 20 d7             	mov    %cr2,%edi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105b53:	8b 73 38             	mov    0x38(%ebx),%esi
80105b56:	e8 35 db ff ff       	call   80103690 <cpuid>
80105b5b:	89 7c 24 10          	mov    %edi,0x10(%esp)
80105b5f:	89 74 24 0c          	mov    %esi,0xc(%esp)
80105b63:	89 44 24 08          	mov    %eax,0x8(%esp)
80105b67:	8b 43 30             	mov    0x30(%ebx),%eax
80105b6a:	c7 04 24 ac 79 10 80 	movl   $0x801079ac,(%esp)
80105b71:	89 44 24 04          	mov    %eax,0x4(%esp)
80105b75:	e8 d6 aa ff ff       	call   80100650 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105b7a:	c7 04 24 81 79 10 80 	movl   $0x80107981,(%esp)
80105b81:	e8 da a7 ff ff       	call   80100360 <panic>
80105b86:	66 90                	xchg   %ax,%ax
80105b88:	66 90                	xchg   %ax,%ax
80105b8a:	66 90                	xchg   %ax,%ax
80105b8c:	66 90                	xchg   %ax,%ax
80105b8e:	66 90                	xchg   %ax,%ax

80105b90 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105b90:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105b95:	55                   	push   %ebp
80105b96:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105b98:	85 c0                	test   %eax,%eax
80105b9a:	74 14                	je     80105bb0 <uartgetc+0x20>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105b9c:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105ba1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105ba2:	a8 01                	test   $0x1,%al
80105ba4:	74 0a                	je     80105bb0 <uartgetc+0x20>
80105ba6:	b2 f8                	mov    $0xf8,%dl
80105ba8:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105ba9:	0f b6 c0             	movzbl %al,%eax
}
80105bac:	5d                   	pop    %ebp
80105bad:	c3                   	ret    
80105bae:	66 90                	xchg   %ax,%ax

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105bb0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105bb5:	5d                   	pop    %ebp
80105bb6:	c3                   	ret    
80105bb7:	89 f6                	mov    %esi,%esi
80105bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105bc0 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bc0:	a1 bc a5 10 80       	mov    0x8010a5bc,%eax
80105bc5:	85 c0                	test   %eax,%eax
80105bc7:	74 3f                	je     80105c08 <uartputc+0x48>
    uartputc(*p);
}

void
uartputc(int c)
{
80105bc9:	55                   	push   %ebp
80105bca:	89 e5                	mov    %esp,%ebp
80105bcc:	56                   	push   %esi
80105bcd:	be fd 03 00 00       	mov    $0x3fd,%esi
80105bd2:	53                   	push   %ebx
  int i;

  if(!uart)
80105bd3:	bb 80 00 00 00       	mov    $0x80,%ebx
    uartputc(*p);
}

void
uartputc(int c)
{
80105bd8:	83 ec 10             	sub    $0x10,%esp
80105bdb:	eb 14                	jmp    80105bf1 <uartputc+0x31>
80105bdd:	8d 76 00             	lea    0x0(%esi),%esi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105be0:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
80105be7:	e8 c4 cb ff ff       	call   801027b0 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105bec:	83 eb 01             	sub    $0x1,%ebx
80105bef:	74 07                	je     80105bf8 <uartputc+0x38>
80105bf1:	89 f2                	mov    %esi,%edx
80105bf3:	ec                   	in     (%dx),%al
80105bf4:	a8 20                	test   $0x20,%al
80105bf6:	74 e8                	je     80105be0 <uartputc+0x20>
    microdelay(10);
  outb(COM1+0, c);
80105bf8:	0f b6 45 08          	movzbl 0x8(%ebp),%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105bfc:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105c01:	ee                   	out    %al,(%dx)
}
80105c02:	83 c4 10             	add    $0x10,%esp
80105c05:	5b                   	pop    %ebx
80105c06:	5e                   	pop    %esi
80105c07:	5d                   	pop    %ebp
80105c08:	f3 c3                	repz ret 
80105c0a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105c10 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105c10:	55                   	push   %ebp
80105c11:	31 c9                	xor    %ecx,%ecx
80105c13:	89 e5                	mov    %esp,%ebp
80105c15:	89 c8                	mov    %ecx,%eax
80105c17:	57                   	push   %edi
80105c18:	bf fa 03 00 00       	mov    $0x3fa,%edi
80105c1d:	56                   	push   %esi
80105c1e:	89 fa                	mov    %edi,%edx
80105c20:	53                   	push   %ebx
80105c21:	83 ec 1c             	sub    $0x1c,%esp
80105c24:	ee                   	out    %al,(%dx)
80105c25:	be fb 03 00 00       	mov    $0x3fb,%esi
80105c2a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105c2f:	89 f2                	mov    %esi,%edx
80105c31:	ee                   	out    %al,(%dx)
80105c32:	b8 0c 00 00 00       	mov    $0xc,%eax
80105c37:	b2 f8                	mov    $0xf8,%dl
80105c39:	ee                   	out    %al,(%dx)
80105c3a:	bb f9 03 00 00       	mov    $0x3f9,%ebx
80105c3f:	89 c8                	mov    %ecx,%eax
80105c41:	89 da                	mov    %ebx,%edx
80105c43:	ee                   	out    %al,(%dx)
80105c44:	b8 03 00 00 00       	mov    $0x3,%eax
80105c49:	89 f2                	mov    %esi,%edx
80105c4b:	ee                   	out    %al,(%dx)
80105c4c:	b2 fc                	mov    $0xfc,%dl
80105c4e:	89 c8                	mov    %ecx,%eax
80105c50:	ee                   	out    %al,(%dx)
80105c51:	b8 01 00 00 00       	mov    $0x1,%eax
80105c56:	89 da                	mov    %ebx,%edx
80105c58:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105c59:	b2 fd                	mov    $0xfd,%dl
80105c5b:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105c5c:	3c ff                	cmp    $0xff,%al
80105c5e:	74 42                	je     80105ca2 <uartinit+0x92>
    return;
  uart = 1;
80105c60:	c7 05 bc a5 10 80 01 	movl   $0x1,0x8010a5bc
80105c67:	00 00 00 
80105c6a:	89 fa                	mov    %edi,%edx
80105c6c:	ec                   	in     (%dx),%al
80105c6d:	b2 f8                	mov    $0xf8,%dl
80105c6f:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105c70:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80105c77:	00 

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c78:	bb a4 7a 10 80       	mov    $0x80107aa4,%ebx

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105c7d:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
80105c84:	e8 37 c6 ff ff       	call   801022c0 <ioapicenable>

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c89:	b8 78 00 00 00       	mov    $0x78,%eax
80105c8e:	66 90                	xchg   %ax,%ax
    uartputc(*p);
80105c90:	89 04 24             	mov    %eax,(%esp)
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c93:	83 c3 01             	add    $0x1,%ebx
    uartputc(*p);
80105c96:	e8 25 ff ff ff       	call   80105bc0 <uartputc>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c9b:	0f be 03             	movsbl (%ebx),%eax
80105c9e:	84 c0                	test   %al,%al
80105ca0:	75 ee                	jne    80105c90 <uartinit+0x80>
    uartputc(*p);
}
80105ca2:	83 c4 1c             	add    $0x1c,%esp
80105ca5:	5b                   	pop    %ebx
80105ca6:	5e                   	pop    %esi
80105ca7:	5f                   	pop    %edi
80105ca8:	5d                   	pop    %ebp
80105ca9:	c3                   	ret    
80105caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80105cb0 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105cb0:	55                   	push   %ebp
80105cb1:	89 e5                	mov    %esp,%ebp
80105cb3:	83 ec 18             	sub    $0x18,%esp
  consoleintr(uartgetc);
80105cb6:	c7 04 24 90 5b 10 80 	movl   $0x80105b90,(%esp)
80105cbd:	e8 ee aa ff ff       	call   801007b0 <consoleintr>
}
80105cc2:	c9                   	leave  
80105cc3:	c3                   	ret    

80105cc4 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105cc4:	6a 00                	push   $0x0
  pushl $0
80105cc6:	6a 00                	push   $0x0
  jmp alltraps
80105cc8:	e9 54 fb ff ff       	jmp    80105821 <alltraps>

80105ccd <vector1>:
.globl vector1
vector1:
  pushl $0
80105ccd:	6a 00                	push   $0x0
  pushl $1
80105ccf:	6a 01                	push   $0x1
  jmp alltraps
80105cd1:	e9 4b fb ff ff       	jmp    80105821 <alltraps>

80105cd6 <vector2>:
.globl vector2
vector2:
  pushl $0
80105cd6:	6a 00                	push   $0x0
  pushl $2
80105cd8:	6a 02                	push   $0x2
  jmp alltraps
80105cda:	e9 42 fb ff ff       	jmp    80105821 <alltraps>

80105cdf <vector3>:
.globl vector3
vector3:
  pushl $0
80105cdf:	6a 00                	push   $0x0
  pushl $3
80105ce1:	6a 03                	push   $0x3
  jmp alltraps
80105ce3:	e9 39 fb ff ff       	jmp    80105821 <alltraps>

80105ce8 <vector4>:
.globl vector4
vector4:
  pushl $0
80105ce8:	6a 00                	push   $0x0
  pushl $4
80105cea:	6a 04                	push   $0x4
  jmp alltraps
80105cec:	e9 30 fb ff ff       	jmp    80105821 <alltraps>

80105cf1 <vector5>:
.globl vector5
vector5:
  pushl $0
80105cf1:	6a 00                	push   $0x0
  pushl $5
80105cf3:	6a 05                	push   $0x5
  jmp alltraps
80105cf5:	e9 27 fb ff ff       	jmp    80105821 <alltraps>

80105cfa <vector6>:
.globl vector6
vector6:
  pushl $0
80105cfa:	6a 00                	push   $0x0
  pushl $6
80105cfc:	6a 06                	push   $0x6
  jmp alltraps
80105cfe:	e9 1e fb ff ff       	jmp    80105821 <alltraps>

80105d03 <vector7>:
.globl vector7
vector7:
  pushl $0
80105d03:	6a 00                	push   $0x0
  pushl $7
80105d05:	6a 07                	push   $0x7
  jmp alltraps
80105d07:	e9 15 fb ff ff       	jmp    80105821 <alltraps>

80105d0c <vector8>:
.globl vector8
vector8:
  pushl $8
80105d0c:	6a 08                	push   $0x8
  jmp alltraps
80105d0e:	e9 0e fb ff ff       	jmp    80105821 <alltraps>

80105d13 <vector9>:
.globl vector9
vector9:
  pushl $0
80105d13:	6a 00                	push   $0x0
  pushl $9
80105d15:	6a 09                	push   $0x9
  jmp alltraps
80105d17:	e9 05 fb ff ff       	jmp    80105821 <alltraps>

80105d1c <vector10>:
.globl vector10
vector10:
  pushl $10
80105d1c:	6a 0a                	push   $0xa
  jmp alltraps
80105d1e:	e9 fe fa ff ff       	jmp    80105821 <alltraps>

80105d23 <vector11>:
.globl vector11
vector11:
  pushl $11
80105d23:	6a 0b                	push   $0xb
  jmp alltraps
80105d25:	e9 f7 fa ff ff       	jmp    80105821 <alltraps>

80105d2a <vector12>:
.globl vector12
vector12:
  pushl $12
80105d2a:	6a 0c                	push   $0xc
  jmp alltraps
80105d2c:	e9 f0 fa ff ff       	jmp    80105821 <alltraps>

80105d31 <vector13>:
.globl vector13
vector13:
  pushl $13
80105d31:	6a 0d                	push   $0xd
  jmp alltraps
80105d33:	e9 e9 fa ff ff       	jmp    80105821 <alltraps>

80105d38 <vector14>:
.globl vector14
vector14:
  pushl $14
80105d38:	6a 0e                	push   $0xe
  jmp alltraps
80105d3a:	e9 e2 fa ff ff       	jmp    80105821 <alltraps>

80105d3f <vector15>:
.globl vector15
vector15:
  pushl $0
80105d3f:	6a 00                	push   $0x0
  pushl $15
80105d41:	6a 0f                	push   $0xf
  jmp alltraps
80105d43:	e9 d9 fa ff ff       	jmp    80105821 <alltraps>

80105d48 <vector16>:
.globl vector16
vector16:
  pushl $0
80105d48:	6a 00                	push   $0x0
  pushl $16
80105d4a:	6a 10                	push   $0x10
  jmp alltraps
80105d4c:	e9 d0 fa ff ff       	jmp    80105821 <alltraps>

80105d51 <vector17>:
.globl vector17
vector17:
  pushl $17
80105d51:	6a 11                	push   $0x11
  jmp alltraps
80105d53:	e9 c9 fa ff ff       	jmp    80105821 <alltraps>

80105d58 <vector18>:
.globl vector18
vector18:
  pushl $0
80105d58:	6a 00                	push   $0x0
  pushl $18
80105d5a:	6a 12                	push   $0x12
  jmp alltraps
80105d5c:	e9 c0 fa ff ff       	jmp    80105821 <alltraps>

80105d61 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d61:	6a 00                	push   $0x0
  pushl $19
80105d63:	6a 13                	push   $0x13
  jmp alltraps
80105d65:	e9 b7 fa ff ff       	jmp    80105821 <alltraps>

80105d6a <vector20>:
.globl vector20
vector20:
  pushl $0
80105d6a:	6a 00                	push   $0x0
  pushl $20
80105d6c:	6a 14                	push   $0x14
  jmp alltraps
80105d6e:	e9 ae fa ff ff       	jmp    80105821 <alltraps>

80105d73 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d73:	6a 00                	push   $0x0
  pushl $21
80105d75:	6a 15                	push   $0x15
  jmp alltraps
80105d77:	e9 a5 fa ff ff       	jmp    80105821 <alltraps>

80105d7c <vector22>:
.globl vector22
vector22:
  pushl $0
80105d7c:	6a 00                	push   $0x0
  pushl $22
80105d7e:	6a 16                	push   $0x16
  jmp alltraps
80105d80:	e9 9c fa ff ff       	jmp    80105821 <alltraps>

80105d85 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d85:	6a 00                	push   $0x0
  pushl $23
80105d87:	6a 17                	push   $0x17
  jmp alltraps
80105d89:	e9 93 fa ff ff       	jmp    80105821 <alltraps>

80105d8e <vector24>:
.globl vector24
vector24:
  pushl $0
80105d8e:	6a 00                	push   $0x0
  pushl $24
80105d90:	6a 18                	push   $0x18
  jmp alltraps
80105d92:	e9 8a fa ff ff       	jmp    80105821 <alltraps>

80105d97 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d97:	6a 00                	push   $0x0
  pushl $25
80105d99:	6a 19                	push   $0x19
  jmp alltraps
80105d9b:	e9 81 fa ff ff       	jmp    80105821 <alltraps>

80105da0 <vector26>:
.globl vector26
vector26:
  pushl $0
80105da0:	6a 00                	push   $0x0
  pushl $26
80105da2:	6a 1a                	push   $0x1a
  jmp alltraps
80105da4:	e9 78 fa ff ff       	jmp    80105821 <alltraps>

80105da9 <vector27>:
.globl vector27
vector27:
  pushl $0
80105da9:	6a 00                	push   $0x0
  pushl $27
80105dab:	6a 1b                	push   $0x1b
  jmp alltraps
80105dad:	e9 6f fa ff ff       	jmp    80105821 <alltraps>

80105db2 <vector28>:
.globl vector28
vector28:
  pushl $0
80105db2:	6a 00                	push   $0x0
  pushl $28
80105db4:	6a 1c                	push   $0x1c
  jmp alltraps
80105db6:	e9 66 fa ff ff       	jmp    80105821 <alltraps>

80105dbb <vector29>:
.globl vector29
vector29:
  pushl $0
80105dbb:	6a 00                	push   $0x0
  pushl $29
80105dbd:	6a 1d                	push   $0x1d
  jmp alltraps
80105dbf:	e9 5d fa ff ff       	jmp    80105821 <alltraps>

80105dc4 <vector30>:
.globl vector30
vector30:
  pushl $0
80105dc4:	6a 00                	push   $0x0
  pushl $30
80105dc6:	6a 1e                	push   $0x1e
  jmp alltraps
80105dc8:	e9 54 fa ff ff       	jmp    80105821 <alltraps>

80105dcd <vector31>:
.globl vector31
vector31:
  pushl $0
80105dcd:	6a 00                	push   $0x0
  pushl $31
80105dcf:	6a 1f                	push   $0x1f
  jmp alltraps
80105dd1:	e9 4b fa ff ff       	jmp    80105821 <alltraps>

80105dd6 <vector32>:
.globl vector32
vector32:
  pushl $0
80105dd6:	6a 00                	push   $0x0
  pushl $32
80105dd8:	6a 20                	push   $0x20
  jmp alltraps
80105dda:	e9 42 fa ff ff       	jmp    80105821 <alltraps>

80105ddf <vector33>:
.globl vector33
vector33:
  pushl $0
80105ddf:	6a 00                	push   $0x0
  pushl $33
80105de1:	6a 21                	push   $0x21
  jmp alltraps
80105de3:	e9 39 fa ff ff       	jmp    80105821 <alltraps>

80105de8 <vector34>:
.globl vector34
vector34:
  pushl $0
80105de8:	6a 00                	push   $0x0
  pushl $34
80105dea:	6a 22                	push   $0x22
  jmp alltraps
80105dec:	e9 30 fa ff ff       	jmp    80105821 <alltraps>

80105df1 <vector35>:
.globl vector35
vector35:
  pushl $0
80105df1:	6a 00                	push   $0x0
  pushl $35
80105df3:	6a 23                	push   $0x23
  jmp alltraps
80105df5:	e9 27 fa ff ff       	jmp    80105821 <alltraps>

80105dfa <vector36>:
.globl vector36
vector36:
  pushl $0
80105dfa:	6a 00                	push   $0x0
  pushl $36
80105dfc:	6a 24                	push   $0x24
  jmp alltraps
80105dfe:	e9 1e fa ff ff       	jmp    80105821 <alltraps>

80105e03 <vector37>:
.globl vector37
vector37:
  pushl $0
80105e03:	6a 00                	push   $0x0
  pushl $37
80105e05:	6a 25                	push   $0x25
  jmp alltraps
80105e07:	e9 15 fa ff ff       	jmp    80105821 <alltraps>

80105e0c <vector38>:
.globl vector38
vector38:
  pushl $0
80105e0c:	6a 00                	push   $0x0
  pushl $38
80105e0e:	6a 26                	push   $0x26
  jmp alltraps
80105e10:	e9 0c fa ff ff       	jmp    80105821 <alltraps>

80105e15 <vector39>:
.globl vector39
vector39:
  pushl $0
80105e15:	6a 00                	push   $0x0
  pushl $39
80105e17:	6a 27                	push   $0x27
  jmp alltraps
80105e19:	e9 03 fa ff ff       	jmp    80105821 <alltraps>

80105e1e <vector40>:
.globl vector40
vector40:
  pushl $0
80105e1e:	6a 00                	push   $0x0
  pushl $40
80105e20:	6a 28                	push   $0x28
  jmp alltraps
80105e22:	e9 fa f9 ff ff       	jmp    80105821 <alltraps>

80105e27 <vector41>:
.globl vector41
vector41:
  pushl $0
80105e27:	6a 00                	push   $0x0
  pushl $41
80105e29:	6a 29                	push   $0x29
  jmp alltraps
80105e2b:	e9 f1 f9 ff ff       	jmp    80105821 <alltraps>

80105e30 <vector42>:
.globl vector42
vector42:
  pushl $0
80105e30:	6a 00                	push   $0x0
  pushl $42
80105e32:	6a 2a                	push   $0x2a
  jmp alltraps
80105e34:	e9 e8 f9 ff ff       	jmp    80105821 <alltraps>

80105e39 <vector43>:
.globl vector43
vector43:
  pushl $0
80105e39:	6a 00                	push   $0x0
  pushl $43
80105e3b:	6a 2b                	push   $0x2b
  jmp alltraps
80105e3d:	e9 df f9 ff ff       	jmp    80105821 <alltraps>

80105e42 <vector44>:
.globl vector44
vector44:
  pushl $0
80105e42:	6a 00                	push   $0x0
  pushl $44
80105e44:	6a 2c                	push   $0x2c
  jmp alltraps
80105e46:	e9 d6 f9 ff ff       	jmp    80105821 <alltraps>

80105e4b <vector45>:
.globl vector45
vector45:
  pushl $0
80105e4b:	6a 00                	push   $0x0
  pushl $45
80105e4d:	6a 2d                	push   $0x2d
  jmp alltraps
80105e4f:	e9 cd f9 ff ff       	jmp    80105821 <alltraps>

80105e54 <vector46>:
.globl vector46
vector46:
  pushl $0
80105e54:	6a 00                	push   $0x0
  pushl $46
80105e56:	6a 2e                	push   $0x2e
  jmp alltraps
80105e58:	e9 c4 f9 ff ff       	jmp    80105821 <alltraps>

80105e5d <vector47>:
.globl vector47
vector47:
  pushl $0
80105e5d:	6a 00                	push   $0x0
  pushl $47
80105e5f:	6a 2f                	push   $0x2f
  jmp alltraps
80105e61:	e9 bb f9 ff ff       	jmp    80105821 <alltraps>

80105e66 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e66:	6a 00                	push   $0x0
  pushl $48
80105e68:	6a 30                	push   $0x30
  jmp alltraps
80105e6a:	e9 b2 f9 ff ff       	jmp    80105821 <alltraps>

80105e6f <vector49>:
.globl vector49
vector49:
  pushl $0
80105e6f:	6a 00                	push   $0x0
  pushl $49
80105e71:	6a 31                	push   $0x31
  jmp alltraps
80105e73:	e9 a9 f9 ff ff       	jmp    80105821 <alltraps>

80105e78 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e78:	6a 00                	push   $0x0
  pushl $50
80105e7a:	6a 32                	push   $0x32
  jmp alltraps
80105e7c:	e9 a0 f9 ff ff       	jmp    80105821 <alltraps>

80105e81 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e81:	6a 00                	push   $0x0
  pushl $51
80105e83:	6a 33                	push   $0x33
  jmp alltraps
80105e85:	e9 97 f9 ff ff       	jmp    80105821 <alltraps>

80105e8a <vector52>:
.globl vector52
vector52:
  pushl $0
80105e8a:	6a 00                	push   $0x0
  pushl $52
80105e8c:	6a 34                	push   $0x34
  jmp alltraps
80105e8e:	e9 8e f9 ff ff       	jmp    80105821 <alltraps>

80105e93 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e93:	6a 00                	push   $0x0
  pushl $53
80105e95:	6a 35                	push   $0x35
  jmp alltraps
80105e97:	e9 85 f9 ff ff       	jmp    80105821 <alltraps>

80105e9c <vector54>:
.globl vector54
vector54:
  pushl $0
80105e9c:	6a 00                	push   $0x0
  pushl $54
80105e9e:	6a 36                	push   $0x36
  jmp alltraps
80105ea0:	e9 7c f9 ff ff       	jmp    80105821 <alltraps>

80105ea5 <vector55>:
.globl vector55
vector55:
  pushl $0
80105ea5:	6a 00                	push   $0x0
  pushl $55
80105ea7:	6a 37                	push   $0x37
  jmp alltraps
80105ea9:	e9 73 f9 ff ff       	jmp    80105821 <alltraps>

80105eae <vector56>:
.globl vector56
vector56:
  pushl $0
80105eae:	6a 00                	push   $0x0
  pushl $56
80105eb0:	6a 38                	push   $0x38
  jmp alltraps
80105eb2:	e9 6a f9 ff ff       	jmp    80105821 <alltraps>

80105eb7 <vector57>:
.globl vector57
vector57:
  pushl $0
80105eb7:	6a 00                	push   $0x0
  pushl $57
80105eb9:	6a 39                	push   $0x39
  jmp alltraps
80105ebb:	e9 61 f9 ff ff       	jmp    80105821 <alltraps>

80105ec0 <vector58>:
.globl vector58
vector58:
  pushl $0
80105ec0:	6a 00                	push   $0x0
  pushl $58
80105ec2:	6a 3a                	push   $0x3a
  jmp alltraps
80105ec4:	e9 58 f9 ff ff       	jmp    80105821 <alltraps>

80105ec9 <vector59>:
.globl vector59
vector59:
  pushl $0
80105ec9:	6a 00                	push   $0x0
  pushl $59
80105ecb:	6a 3b                	push   $0x3b
  jmp alltraps
80105ecd:	e9 4f f9 ff ff       	jmp    80105821 <alltraps>

80105ed2 <vector60>:
.globl vector60
vector60:
  pushl $0
80105ed2:	6a 00                	push   $0x0
  pushl $60
80105ed4:	6a 3c                	push   $0x3c
  jmp alltraps
80105ed6:	e9 46 f9 ff ff       	jmp    80105821 <alltraps>

80105edb <vector61>:
.globl vector61
vector61:
  pushl $0
80105edb:	6a 00                	push   $0x0
  pushl $61
80105edd:	6a 3d                	push   $0x3d
  jmp alltraps
80105edf:	e9 3d f9 ff ff       	jmp    80105821 <alltraps>

80105ee4 <vector62>:
.globl vector62
vector62:
  pushl $0
80105ee4:	6a 00                	push   $0x0
  pushl $62
80105ee6:	6a 3e                	push   $0x3e
  jmp alltraps
80105ee8:	e9 34 f9 ff ff       	jmp    80105821 <alltraps>

80105eed <vector63>:
.globl vector63
vector63:
  pushl $0
80105eed:	6a 00                	push   $0x0
  pushl $63
80105eef:	6a 3f                	push   $0x3f
  jmp alltraps
80105ef1:	e9 2b f9 ff ff       	jmp    80105821 <alltraps>

80105ef6 <vector64>:
.globl vector64
vector64:
  pushl $0
80105ef6:	6a 00                	push   $0x0
  pushl $64
80105ef8:	6a 40                	push   $0x40
  jmp alltraps
80105efa:	e9 22 f9 ff ff       	jmp    80105821 <alltraps>

80105eff <vector65>:
.globl vector65
vector65:
  pushl $0
80105eff:	6a 00                	push   $0x0
  pushl $65
80105f01:	6a 41                	push   $0x41
  jmp alltraps
80105f03:	e9 19 f9 ff ff       	jmp    80105821 <alltraps>

80105f08 <vector66>:
.globl vector66
vector66:
  pushl $0
80105f08:	6a 00                	push   $0x0
  pushl $66
80105f0a:	6a 42                	push   $0x42
  jmp alltraps
80105f0c:	e9 10 f9 ff ff       	jmp    80105821 <alltraps>

80105f11 <vector67>:
.globl vector67
vector67:
  pushl $0
80105f11:	6a 00                	push   $0x0
  pushl $67
80105f13:	6a 43                	push   $0x43
  jmp alltraps
80105f15:	e9 07 f9 ff ff       	jmp    80105821 <alltraps>

80105f1a <vector68>:
.globl vector68
vector68:
  pushl $0
80105f1a:	6a 00                	push   $0x0
  pushl $68
80105f1c:	6a 44                	push   $0x44
  jmp alltraps
80105f1e:	e9 fe f8 ff ff       	jmp    80105821 <alltraps>

80105f23 <vector69>:
.globl vector69
vector69:
  pushl $0
80105f23:	6a 00                	push   $0x0
  pushl $69
80105f25:	6a 45                	push   $0x45
  jmp alltraps
80105f27:	e9 f5 f8 ff ff       	jmp    80105821 <alltraps>

80105f2c <vector70>:
.globl vector70
vector70:
  pushl $0
80105f2c:	6a 00                	push   $0x0
  pushl $70
80105f2e:	6a 46                	push   $0x46
  jmp alltraps
80105f30:	e9 ec f8 ff ff       	jmp    80105821 <alltraps>

80105f35 <vector71>:
.globl vector71
vector71:
  pushl $0
80105f35:	6a 00                	push   $0x0
  pushl $71
80105f37:	6a 47                	push   $0x47
  jmp alltraps
80105f39:	e9 e3 f8 ff ff       	jmp    80105821 <alltraps>

80105f3e <vector72>:
.globl vector72
vector72:
  pushl $0
80105f3e:	6a 00                	push   $0x0
  pushl $72
80105f40:	6a 48                	push   $0x48
  jmp alltraps
80105f42:	e9 da f8 ff ff       	jmp    80105821 <alltraps>

80105f47 <vector73>:
.globl vector73
vector73:
  pushl $0
80105f47:	6a 00                	push   $0x0
  pushl $73
80105f49:	6a 49                	push   $0x49
  jmp alltraps
80105f4b:	e9 d1 f8 ff ff       	jmp    80105821 <alltraps>

80105f50 <vector74>:
.globl vector74
vector74:
  pushl $0
80105f50:	6a 00                	push   $0x0
  pushl $74
80105f52:	6a 4a                	push   $0x4a
  jmp alltraps
80105f54:	e9 c8 f8 ff ff       	jmp    80105821 <alltraps>

80105f59 <vector75>:
.globl vector75
vector75:
  pushl $0
80105f59:	6a 00                	push   $0x0
  pushl $75
80105f5b:	6a 4b                	push   $0x4b
  jmp alltraps
80105f5d:	e9 bf f8 ff ff       	jmp    80105821 <alltraps>

80105f62 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f62:	6a 00                	push   $0x0
  pushl $76
80105f64:	6a 4c                	push   $0x4c
  jmp alltraps
80105f66:	e9 b6 f8 ff ff       	jmp    80105821 <alltraps>

80105f6b <vector77>:
.globl vector77
vector77:
  pushl $0
80105f6b:	6a 00                	push   $0x0
  pushl $77
80105f6d:	6a 4d                	push   $0x4d
  jmp alltraps
80105f6f:	e9 ad f8 ff ff       	jmp    80105821 <alltraps>

80105f74 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f74:	6a 00                	push   $0x0
  pushl $78
80105f76:	6a 4e                	push   $0x4e
  jmp alltraps
80105f78:	e9 a4 f8 ff ff       	jmp    80105821 <alltraps>

80105f7d <vector79>:
.globl vector79
vector79:
  pushl $0
80105f7d:	6a 00                	push   $0x0
  pushl $79
80105f7f:	6a 4f                	push   $0x4f
  jmp alltraps
80105f81:	e9 9b f8 ff ff       	jmp    80105821 <alltraps>

80105f86 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f86:	6a 00                	push   $0x0
  pushl $80
80105f88:	6a 50                	push   $0x50
  jmp alltraps
80105f8a:	e9 92 f8 ff ff       	jmp    80105821 <alltraps>

80105f8f <vector81>:
.globl vector81
vector81:
  pushl $0
80105f8f:	6a 00                	push   $0x0
  pushl $81
80105f91:	6a 51                	push   $0x51
  jmp alltraps
80105f93:	e9 89 f8 ff ff       	jmp    80105821 <alltraps>

80105f98 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f98:	6a 00                	push   $0x0
  pushl $82
80105f9a:	6a 52                	push   $0x52
  jmp alltraps
80105f9c:	e9 80 f8 ff ff       	jmp    80105821 <alltraps>

80105fa1 <vector83>:
.globl vector83
vector83:
  pushl $0
80105fa1:	6a 00                	push   $0x0
  pushl $83
80105fa3:	6a 53                	push   $0x53
  jmp alltraps
80105fa5:	e9 77 f8 ff ff       	jmp    80105821 <alltraps>

80105faa <vector84>:
.globl vector84
vector84:
  pushl $0
80105faa:	6a 00                	push   $0x0
  pushl $84
80105fac:	6a 54                	push   $0x54
  jmp alltraps
80105fae:	e9 6e f8 ff ff       	jmp    80105821 <alltraps>

80105fb3 <vector85>:
.globl vector85
vector85:
  pushl $0
80105fb3:	6a 00                	push   $0x0
  pushl $85
80105fb5:	6a 55                	push   $0x55
  jmp alltraps
80105fb7:	e9 65 f8 ff ff       	jmp    80105821 <alltraps>

80105fbc <vector86>:
.globl vector86
vector86:
  pushl $0
80105fbc:	6a 00                	push   $0x0
  pushl $86
80105fbe:	6a 56                	push   $0x56
  jmp alltraps
80105fc0:	e9 5c f8 ff ff       	jmp    80105821 <alltraps>

80105fc5 <vector87>:
.globl vector87
vector87:
  pushl $0
80105fc5:	6a 00                	push   $0x0
  pushl $87
80105fc7:	6a 57                	push   $0x57
  jmp alltraps
80105fc9:	e9 53 f8 ff ff       	jmp    80105821 <alltraps>

80105fce <vector88>:
.globl vector88
vector88:
  pushl $0
80105fce:	6a 00                	push   $0x0
  pushl $88
80105fd0:	6a 58                	push   $0x58
  jmp alltraps
80105fd2:	e9 4a f8 ff ff       	jmp    80105821 <alltraps>

80105fd7 <vector89>:
.globl vector89
vector89:
  pushl $0
80105fd7:	6a 00                	push   $0x0
  pushl $89
80105fd9:	6a 59                	push   $0x59
  jmp alltraps
80105fdb:	e9 41 f8 ff ff       	jmp    80105821 <alltraps>

80105fe0 <vector90>:
.globl vector90
vector90:
  pushl $0
80105fe0:	6a 00                	push   $0x0
  pushl $90
80105fe2:	6a 5a                	push   $0x5a
  jmp alltraps
80105fe4:	e9 38 f8 ff ff       	jmp    80105821 <alltraps>

80105fe9 <vector91>:
.globl vector91
vector91:
  pushl $0
80105fe9:	6a 00                	push   $0x0
  pushl $91
80105feb:	6a 5b                	push   $0x5b
  jmp alltraps
80105fed:	e9 2f f8 ff ff       	jmp    80105821 <alltraps>

80105ff2 <vector92>:
.globl vector92
vector92:
  pushl $0
80105ff2:	6a 00                	push   $0x0
  pushl $92
80105ff4:	6a 5c                	push   $0x5c
  jmp alltraps
80105ff6:	e9 26 f8 ff ff       	jmp    80105821 <alltraps>

80105ffb <vector93>:
.globl vector93
vector93:
  pushl $0
80105ffb:	6a 00                	push   $0x0
  pushl $93
80105ffd:	6a 5d                	push   $0x5d
  jmp alltraps
80105fff:	e9 1d f8 ff ff       	jmp    80105821 <alltraps>

80106004 <vector94>:
.globl vector94
vector94:
  pushl $0
80106004:	6a 00                	push   $0x0
  pushl $94
80106006:	6a 5e                	push   $0x5e
  jmp alltraps
80106008:	e9 14 f8 ff ff       	jmp    80105821 <alltraps>

8010600d <vector95>:
.globl vector95
vector95:
  pushl $0
8010600d:	6a 00                	push   $0x0
  pushl $95
8010600f:	6a 5f                	push   $0x5f
  jmp alltraps
80106011:	e9 0b f8 ff ff       	jmp    80105821 <alltraps>

80106016 <vector96>:
.globl vector96
vector96:
  pushl $0
80106016:	6a 00                	push   $0x0
  pushl $96
80106018:	6a 60                	push   $0x60
  jmp alltraps
8010601a:	e9 02 f8 ff ff       	jmp    80105821 <alltraps>

8010601f <vector97>:
.globl vector97
vector97:
  pushl $0
8010601f:	6a 00                	push   $0x0
  pushl $97
80106021:	6a 61                	push   $0x61
  jmp alltraps
80106023:	e9 f9 f7 ff ff       	jmp    80105821 <alltraps>

80106028 <vector98>:
.globl vector98
vector98:
  pushl $0
80106028:	6a 00                	push   $0x0
  pushl $98
8010602a:	6a 62                	push   $0x62
  jmp alltraps
8010602c:	e9 f0 f7 ff ff       	jmp    80105821 <alltraps>

80106031 <vector99>:
.globl vector99
vector99:
  pushl $0
80106031:	6a 00                	push   $0x0
  pushl $99
80106033:	6a 63                	push   $0x63
  jmp alltraps
80106035:	e9 e7 f7 ff ff       	jmp    80105821 <alltraps>

8010603a <vector100>:
.globl vector100
vector100:
  pushl $0
8010603a:	6a 00                	push   $0x0
  pushl $100
8010603c:	6a 64                	push   $0x64
  jmp alltraps
8010603e:	e9 de f7 ff ff       	jmp    80105821 <alltraps>

80106043 <vector101>:
.globl vector101
vector101:
  pushl $0
80106043:	6a 00                	push   $0x0
  pushl $101
80106045:	6a 65                	push   $0x65
  jmp alltraps
80106047:	e9 d5 f7 ff ff       	jmp    80105821 <alltraps>

8010604c <vector102>:
.globl vector102
vector102:
  pushl $0
8010604c:	6a 00                	push   $0x0
  pushl $102
8010604e:	6a 66                	push   $0x66
  jmp alltraps
80106050:	e9 cc f7 ff ff       	jmp    80105821 <alltraps>

80106055 <vector103>:
.globl vector103
vector103:
  pushl $0
80106055:	6a 00                	push   $0x0
  pushl $103
80106057:	6a 67                	push   $0x67
  jmp alltraps
80106059:	e9 c3 f7 ff ff       	jmp    80105821 <alltraps>

8010605e <vector104>:
.globl vector104
vector104:
  pushl $0
8010605e:	6a 00                	push   $0x0
  pushl $104
80106060:	6a 68                	push   $0x68
  jmp alltraps
80106062:	e9 ba f7 ff ff       	jmp    80105821 <alltraps>

80106067 <vector105>:
.globl vector105
vector105:
  pushl $0
80106067:	6a 00                	push   $0x0
  pushl $105
80106069:	6a 69                	push   $0x69
  jmp alltraps
8010606b:	e9 b1 f7 ff ff       	jmp    80105821 <alltraps>

80106070 <vector106>:
.globl vector106
vector106:
  pushl $0
80106070:	6a 00                	push   $0x0
  pushl $106
80106072:	6a 6a                	push   $0x6a
  jmp alltraps
80106074:	e9 a8 f7 ff ff       	jmp    80105821 <alltraps>

80106079 <vector107>:
.globl vector107
vector107:
  pushl $0
80106079:	6a 00                	push   $0x0
  pushl $107
8010607b:	6a 6b                	push   $0x6b
  jmp alltraps
8010607d:	e9 9f f7 ff ff       	jmp    80105821 <alltraps>

80106082 <vector108>:
.globl vector108
vector108:
  pushl $0
80106082:	6a 00                	push   $0x0
  pushl $108
80106084:	6a 6c                	push   $0x6c
  jmp alltraps
80106086:	e9 96 f7 ff ff       	jmp    80105821 <alltraps>

8010608b <vector109>:
.globl vector109
vector109:
  pushl $0
8010608b:	6a 00                	push   $0x0
  pushl $109
8010608d:	6a 6d                	push   $0x6d
  jmp alltraps
8010608f:	e9 8d f7 ff ff       	jmp    80105821 <alltraps>

80106094 <vector110>:
.globl vector110
vector110:
  pushl $0
80106094:	6a 00                	push   $0x0
  pushl $110
80106096:	6a 6e                	push   $0x6e
  jmp alltraps
80106098:	e9 84 f7 ff ff       	jmp    80105821 <alltraps>

8010609d <vector111>:
.globl vector111
vector111:
  pushl $0
8010609d:	6a 00                	push   $0x0
  pushl $111
8010609f:	6a 6f                	push   $0x6f
  jmp alltraps
801060a1:	e9 7b f7 ff ff       	jmp    80105821 <alltraps>

801060a6 <vector112>:
.globl vector112
vector112:
  pushl $0
801060a6:	6a 00                	push   $0x0
  pushl $112
801060a8:	6a 70                	push   $0x70
  jmp alltraps
801060aa:	e9 72 f7 ff ff       	jmp    80105821 <alltraps>

801060af <vector113>:
.globl vector113
vector113:
  pushl $0
801060af:	6a 00                	push   $0x0
  pushl $113
801060b1:	6a 71                	push   $0x71
  jmp alltraps
801060b3:	e9 69 f7 ff ff       	jmp    80105821 <alltraps>

801060b8 <vector114>:
.globl vector114
vector114:
  pushl $0
801060b8:	6a 00                	push   $0x0
  pushl $114
801060ba:	6a 72                	push   $0x72
  jmp alltraps
801060bc:	e9 60 f7 ff ff       	jmp    80105821 <alltraps>

801060c1 <vector115>:
.globl vector115
vector115:
  pushl $0
801060c1:	6a 00                	push   $0x0
  pushl $115
801060c3:	6a 73                	push   $0x73
  jmp alltraps
801060c5:	e9 57 f7 ff ff       	jmp    80105821 <alltraps>

801060ca <vector116>:
.globl vector116
vector116:
  pushl $0
801060ca:	6a 00                	push   $0x0
  pushl $116
801060cc:	6a 74                	push   $0x74
  jmp alltraps
801060ce:	e9 4e f7 ff ff       	jmp    80105821 <alltraps>

801060d3 <vector117>:
.globl vector117
vector117:
  pushl $0
801060d3:	6a 00                	push   $0x0
  pushl $117
801060d5:	6a 75                	push   $0x75
  jmp alltraps
801060d7:	e9 45 f7 ff ff       	jmp    80105821 <alltraps>

801060dc <vector118>:
.globl vector118
vector118:
  pushl $0
801060dc:	6a 00                	push   $0x0
  pushl $118
801060de:	6a 76                	push   $0x76
  jmp alltraps
801060e0:	e9 3c f7 ff ff       	jmp    80105821 <alltraps>

801060e5 <vector119>:
.globl vector119
vector119:
  pushl $0
801060e5:	6a 00                	push   $0x0
  pushl $119
801060e7:	6a 77                	push   $0x77
  jmp alltraps
801060e9:	e9 33 f7 ff ff       	jmp    80105821 <alltraps>

801060ee <vector120>:
.globl vector120
vector120:
  pushl $0
801060ee:	6a 00                	push   $0x0
  pushl $120
801060f0:	6a 78                	push   $0x78
  jmp alltraps
801060f2:	e9 2a f7 ff ff       	jmp    80105821 <alltraps>

801060f7 <vector121>:
.globl vector121
vector121:
  pushl $0
801060f7:	6a 00                	push   $0x0
  pushl $121
801060f9:	6a 79                	push   $0x79
  jmp alltraps
801060fb:	e9 21 f7 ff ff       	jmp    80105821 <alltraps>

80106100 <vector122>:
.globl vector122
vector122:
  pushl $0
80106100:	6a 00                	push   $0x0
  pushl $122
80106102:	6a 7a                	push   $0x7a
  jmp alltraps
80106104:	e9 18 f7 ff ff       	jmp    80105821 <alltraps>

80106109 <vector123>:
.globl vector123
vector123:
  pushl $0
80106109:	6a 00                	push   $0x0
  pushl $123
8010610b:	6a 7b                	push   $0x7b
  jmp alltraps
8010610d:	e9 0f f7 ff ff       	jmp    80105821 <alltraps>

80106112 <vector124>:
.globl vector124
vector124:
  pushl $0
80106112:	6a 00                	push   $0x0
  pushl $124
80106114:	6a 7c                	push   $0x7c
  jmp alltraps
80106116:	e9 06 f7 ff ff       	jmp    80105821 <alltraps>

8010611b <vector125>:
.globl vector125
vector125:
  pushl $0
8010611b:	6a 00                	push   $0x0
  pushl $125
8010611d:	6a 7d                	push   $0x7d
  jmp alltraps
8010611f:	e9 fd f6 ff ff       	jmp    80105821 <alltraps>

80106124 <vector126>:
.globl vector126
vector126:
  pushl $0
80106124:	6a 00                	push   $0x0
  pushl $126
80106126:	6a 7e                	push   $0x7e
  jmp alltraps
80106128:	e9 f4 f6 ff ff       	jmp    80105821 <alltraps>

8010612d <vector127>:
.globl vector127
vector127:
  pushl $0
8010612d:	6a 00                	push   $0x0
  pushl $127
8010612f:	6a 7f                	push   $0x7f
  jmp alltraps
80106131:	e9 eb f6 ff ff       	jmp    80105821 <alltraps>

80106136 <vector128>:
.globl vector128
vector128:
  pushl $0
80106136:	6a 00                	push   $0x0
  pushl $128
80106138:	68 80 00 00 00       	push   $0x80
  jmp alltraps
8010613d:	e9 df f6 ff ff       	jmp    80105821 <alltraps>

80106142 <vector129>:
.globl vector129
vector129:
  pushl $0
80106142:	6a 00                	push   $0x0
  pushl $129
80106144:	68 81 00 00 00       	push   $0x81
  jmp alltraps
80106149:	e9 d3 f6 ff ff       	jmp    80105821 <alltraps>

8010614e <vector130>:
.globl vector130
vector130:
  pushl $0
8010614e:	6a 00                	push   $0x0
  pushl $130
80106150:	68 82 00 00 00       	push   $0x82
  jmp alltraps
80106155:	e9 c7 f6 ff ff       	jmp    80105821 <alltraps>

8010615a <vector131>:
.globl vector131
vector131:
  pushl $0
8010615a:	6a 00                	push   $0x0
  pushl $131
8010615c:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106161:	e9 bb f6 ff ff       	jmp    80105821 <alltraps>

80106166 <vector132>:
.globl vector132
vector132:
  pushl $0
80106166:	6a 00                	push   $0x0
  pushl $132
80106168:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010616d:	e9 af f6 ff ff       	jmp    80105821 <alltraps>

80106172 <vector133>:
.globl vector133
vector133:
  pushl $0
80106172:	6a 00                	push   $0x0
  pushl $133
80106174:	68 85 00 00 00       	push   $0x85
  jmp alltraps
80106179:	e9 a3 f6 ff ff       	jmp    80105821 <alltraps>

8010617e <vector134>:
.globl vector134
vector134:
  pushl $0
8010617e:	6a 00                	push   $0x0
  pushl $134
80106180:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106185:	e9 97 f6 ff ff       	jmp    80105821 <alltraps>

8010618a <vector135>:
.globl vector135
vector135:
  pushl $0
8010618a:	6a 00                	push   $0x0
  pushl $135
8010618c:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106191:	e9 8b f6 ff ff       	jmp    80105821 <alltraps>

80106196 <vector136>:
.globl vector136
vector136:
  pushl $0
80106196:	6a 00                	push   $0x0
  pushl $136
80106198:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010619d:	e9 7f f6 ff ff       	jmp    80105821 <alltraps>

801061a2 <vector137>:
.globl vector137
vector137:
  pushl $0
801061a2:	6a 00                	push   $0x0
  pushl $137
801061a4:	68 89 00 00 00       	push   $0x89
  jmp alltraps
801061a9:	e9 73 f6 ff ff       	jmp    80105821 <alltraps>

801061ae <vector138>:
.globl vector138
vector138:
  pushl $0
801061ae:	6a 00                	push   $0x0
  pushl $138
801061b0:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
801061b5:	e9 67 f6 ff ff       	jmp    80105821 <alltraps>

801061ba <vector139>:
.globl vector139
vector139:
  pushl $0
801061ba:	6a 00                	push   $0x0
  pushl $139
801061bc:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
801061c1:	e9 5b f6 ff ff       	jmp    80105821 <alltraps>

801061c6 <vector140>:
.globl vector140
vector140:
  pushl $0
801061c6:	6a 00                	push   $0x0
  pushl $140
801061c8:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
801061cd:	e9 4f f6 ff ff       	jmp    80105821 <alltraps>

801061d2 <vector141>:
.globl vector141
vector141:
  pushl $0
801061d2:	6a 00                	push   $0x0
  pushl $141
801061d4:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
801061d9:	e9 43 f6 ff ff       	jmp    80105821 <alltraps>

801061de <vector142>:
.globl vector142
vector142:
  pushl $0
801061de:	6a 00                	push   $0x0
  pushl $142
801061e0:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
801061e5:	e9 37 f6 ff ff       	jmp    80105821 <alltraps>

801061ea <vector143>:
.globl vector143
vector143:
  pushl $0
801061ea:	6a 00                	push   $0x0
  pushl $143
801061ec:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
801061f1:	e9 2b f6 ff ff       	jmp    80105821 <alltraps>

801061f6 <vector144>:
.globl vector144
vector144:
  pushl $0
801061f6:	6a 00                	push   $0x0
  pushl $144
801061f8:	68 90 00 00 00       	push   $0x90
  jmp alltraps
801061fd:	e9 1f f6 ff ff       	jmp    80105821 <alltraps>

80106202 <vector145>:
.globl vector145
vector145:
  pushl $0
80106202:	6a 00                	push   $0x0
  pushl $145
80106204:	68 91 00 00 00       	push   $0x91
  jmp alltraps
80106209:	e9 13 f6 ff ff       	jmp    80105821 <alltraps>

8010620e <vector146>:
.globl vector146
vector146:
  pushl $0
8010620e:	6a 00                	push   $0x0
  pushl $146
80106210:	68 92 00 00 00       	push   $0x92
  jmp alltraps
80106215:	e9 07 f6 ff ff       	jmp    80105821 <alltraps>

8010621a <vector147>:
.globl vector147
vector147:
  pushl $0
8010621a:	6a 00                	push   $0x0
  pushl $147
8010621c:	68 93 00 00 00       	push   $0x93
  jmp alltraps
80106221:	e9 fb f5 ff ff       	jmp    80105821 <alltraps>

80106226 <vector148>:
.globl vector148
vector148:
  pushl $0
80106226:	6a 00                	push   $0x0
  pushl $148
80106228:	68 94 00 00 00       	push   $0x94
  jmp alltraps
8010622d:	e9 ef f5 ff ff       	jmp    80105821 <alltraps>

80106232 <vector149>:
.globl vector149
vector149:
  pushl $0
80106232:	6a 00                	push   $0x0
  pushl $149
80106234:	68 95 00 00 00       	push   $0x95
  jmp alltraps
80106239:	e9 e3 f5 ff ff       	jmp    80105821 <alltraps>

8010623e <vector150>:
.globl vector150
vector150:
  pushl $0
8010623e:	6a 00                	push   $0x0
  pushl $150
80106240:	68 96 00 00 00       	push   $0x96
  jmp alltraps
80106245:	e9 d7 f5 ff ff       	jmp    80105821 <alltraps>

8010624a <vector151>:
.globl vector151
vector151:
  pushl $0
8010624a:	6a 00                	push   $0x0
  pushl $151
8010624c:	68 97 00 00 00       	push   $0x97
  jmp alltraps
80106251:	e9 cb f5 ff ff       	jmp    80105821 <alltraps>

80106256 <vector152>:
.globl vector152
vector152:
  pushl $0
80106256:	6a 00                	push   $0x0
  pushl $152
80106258:	68 98 00 00 00       	push   $0x98
  jmp alltraps
8010625d:	e9 bf f5 ff ff       	jmp    80105821 <alltraps>

80106262 <vector153>:
.globl vector153
vector153:
  pushl $0
80106262:	6a 00                	push   $0x0
  pushl $153
80106264:	68 99 00 00 00       	push   $0x99
  jmp alltraps
80106269:	e9 b3 f5 ff ff       	jmp    80105821 <alltraps>

8010626e <vector154>:
.globl vector154
vector154:
  pushl $0
8010626e:	6a 00                	push   $0x0
  pushl $154
80106270:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106275:	e9 a7 f5 ff ff       	jmp    80105821 <alltraps>

8010627a <vector155>:
.globl vector155
vector155:
  pushl $0
8010627a:	6a 00                	push   $0x0
  pushl $155
8010627c:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106281:	e9 9b f5 ff ff       	jmp    80105821 <alltraps>

80106286 <vector156>:
.globl vector156
vector156:
  pushl $0
80106286:	6a 00                	push   $0x0
  pushl $156
80106288:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010628d:	e9 8f f5 ff ff       	jmp    80105821 <alltraps>

80106292 <vector157>:
.globl vector157
vector157:
  pushl $0
80106292:	6a 00                	push   $0x0
  pushl $157
80106294:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
80106299:	e9 83 f5 ff ff       	jmp    80105821 <alltraps>

8010629e <vector158>:
.globl vector158
vector158:
  pushl $0
8010629e:	6a 00                	push   $0x0
  pushl $158
801062a0:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
801062a5:	e9 77 f5 ff ff       	jmp    80105821 <alltraps>

801062aa <vector159>:
.globl vector159
vector159:
  pushl $0
801062aa:	6a 00                	push   $0x0
  pushl $159
801062ac:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
801062b1:	e9 6b f5 ff ff       	jmp    80105821 <alltraps>

801062b6 <vector160>:
.globl vector160
vector160:
  pushl $0
801062b6:	6a 00                	push   $0x0
  pushl $160
801062b8:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
801062bd:	e9 5f f5 ff ff       	jmp    80105821 <alltraps>

801062c2 <vector161>:
.globl vector161
vector161:
  pushl $0
801062c2:	6a 00                	push   $0x0
  pushl $161
801062c4:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
801062c9:	e9 53 f5 ff ff       	jmp    80105821 <alltraps>

801062ce <vector162>:
.globl vector162
vector162:
  pushl $0
801062ce:	6a 00                	push   $0x0
  pushl $162
801062d0:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
801062d5:	e9 47 f5 ff ff       	jmp    80105821 <alltraps>

801062da <vector163>:
.globl vector163
vector163:
  pushl $0
801062da:	6a 00                	push   $0x0
  pushl $163
801062dc:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
801062e1:	e9 3b f5 ff ff       	jmp    80105821 <alltraps>

801062e6 <vector164>:
.globl vector164
vector164:
  pushl $0
801062e6:	6a 00                	push   $0x0
  pushl $164
801062e8:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
801062ed:	e9 2f f5 ff ff       	jmp    80105821 <alltraps>

801062f2 <vector165>:
.globl vector165
vector165:
  pushl $0
801062f2:	6a 00                	push   $0x0
  pushl $165
801062f4:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
801062f9:	e9 23 f5 ff ff       	jmp    80105821 <alltraps>

801062fe <vector166>:
.globl vector166
vector166:
  pushl $0
801062fe:	6a 00                	push   $0x0
  pushl $166
80106300:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
80106305:	e9 17 f5 ff ff       	jmp    80105821 <alltraps>

8010630a <vector167>:
.globl vector167
vector167:
  pushl $0
8010630a:	6a 00                	push   $0x0
  pushl $167
8010630c:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
80106311:	e9 0b f5 ff ff       	jmp    80105821 <alltraps>

80106316 <vector168>:
.globl vector168
vector168:
  pushl $0
80106316:	6a 00                	push   $0x0
  pushl $168
80106318:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
8010631d:	e9 ff f4 ff ff       	jmp    80105821 <alltraps>

80106322 <vector169>:
.globl vector169
vector169:
  pushl $0
80106322:	6a 00                	push   $0x0
  pushl $169
80106324:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
80106329:	e9 f3 f4 ff ff       	jmp    80105821 <alltraps>

8010632e <vector170>:
.globl vector170
vector170:
  pushl $0
8010632e:	6a 00                	push   $0x0
  pushl $170
80106330:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
80106335:	e9 e7 f4 ff ff       	jmp    80105821 <alltraps>

8010633a <vector171>:
.globl vector171
vector171:
  pushl $0
8010633a:	6a 00                	push   $0x0
  pushl $171
8010633c:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
80106341:	e9 db f4 ff ff       	jmp    80105821 <alltraps>

80106346 <vector172>:
.globl vector172
vector172:
  pushl $0
80106346:	6a 00                	push   $0x0
  pushl $172
80106348:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
8010634d:	e9 cf f4 ff ff       	jmp    80105821 <alltraps>

80106352 <vector173>:
.globl vector173
vector173:
  pushl $0
80106352:	6a 00                	push   $0x0
  pushl $173
80106354:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
80106359:	e9 c3 f4 ff ff       	jmp    80105821 <alltraps>

8010635e <vector174>:
.globl vector174
vector174:
  pushl $0
8010635e:	6a 00                	push   $0x0
  pushl $174
80106360:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106365:	e9 b7 f4 ff ff       	jmp    80105821 <alltraps>

8010636a <vector175>:
.globl vector175
vector175:
  pushl $0
8010636a:	6a 00                	push   $0x0
  pushl $175
8010636c:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106371:	e9 ab f4 ff ff       	jmp    80105821 <alltraps>

80106376 <vector176>:
.globl vector176
vector176:
  pushl $0
80106376:	6a 00                	push   $0x0
  pushl $176
80106378:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010637d:	e9 9f f4 ff ff       	jmp    80105821 <alltraps>

80106382 <vector177>:
.globl vector177
vector177:
  pushl $0
80106382:	6a 00                	push   $0x0
  pushl $177
80106384:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
80106389:	e9 93 f4 ff ff       	jmp    80105821 <alltraps>

8010638e <vector178>:
.globl vector178
vector178:
  pushl $0
8010638e:	6a 00                	push   $0x0
  pushl $178
80106390:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106395:	e9 87 f4 ff ff       	jmp    80105821 <alltraps>

8010639a <vector179>:
.globl vector179
vector179:
  pushl $0
8010639a:	6a 00                	push   $0x0
  pushl $179
8010639c:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
801063a1:	e9 7b f4 ff ff       	jmp    80105821 <alltraps>

801063a6 <vector180>:
.globl vector180
vector180:
  pushl $0
801063a6:	6a 00                	push   $0x0
  pushl $180
801063a8:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
801063ad:	e9 6f f4 ff ff       	jmp    80105821 <alltraps>

801063b2 <vector181>:
.globl vector181
vector181:
  pushl $0
801063b2:	6a 00                	push   $0x0
  pushl $181
801063b4:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
801063b9:	e9 63 f4 ff ff       	jmp    80105821 <alltraps>

801063be <vector182>:
.globl vector182
vector182:
  pushl $0
801063be:	6a 00                	push   $0x0
  pushl $182
801063c0:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
801063c5:	e9 57 f4 ff ff       	jmp    80105821 <alltraps>

801063ca <vector183>:
.globl vector183
vector183:
  pushl $0
801063ca:	6a 00                	push   $0x0
  pushl $183
801063cc:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
801063d1:	e9 4b f4 ff ff       	jmp    80105821 <alltraps>

801063d6 <vector184>:
.globl vector184
vector184:
  pushl $0
801063d6:	6a 00                	push   $0x0
  pushl $184
801063d8:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
801063dd:	e9 3f f4 ff ff       	jmp    80105821 <alltraps>

801063e2 <vector185>:
.globl vector185
vector185:
  pushl $0
801063e2:	6a 00                	push   $0x0
  pushl $185
801063e4:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
801063e9:	e9 33 f4 ff ff       	jmp    80105821 <alltraps>

801063ee <vector186>:
.globl vector186
vector186:
  pushl $0
801063ee:	6a 00                	push   $0x0
  pushl $186
801063f0:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
801063f5:	e9 27 f4 ff ff       	jmp    80105821 <alltraps>

801063fa <vector187>:
.globl vector187
vector187:
  pushl $0
801063fa:	6a 00                	push   $0x0
  pushl $187
801063fc:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
80106401:	e9 1b f4 ff ff       	jmp    80105821 <alltraps>

80106406 <vector188>:
.globl vector188
vector188:
  pushl $0
80106406:	6a 00                	push   $0x0
  pushl $188
80106408:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
8010640d:	e9 0f f4 ff ff       	jmp    80105821 <alltraps>

80106412 <vector189>:
.globl vector189
vector189:
  pushl $0
80106412:	6a 00                	push   $0x0
  pushl $189
80106414:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
80106419:	e9 03 f4 ff ff       	jmp    80105821 <alltraps>

8010641e <vector190>:
.globl vector190
vector190:
  pushl $0
8010641e:	6a 00                	push   $0x0
  pushl $190
80106420:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
80106425:	e9 f7 f3 ff ff       	jmp    80105821 <alltraps>

8010642a <vector191>:
.globl vector191
vector191:
  pushl $0
8010642a:	6a 00                	push   $0x0
  pushl $191
8010642c:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
80106431:	e9 eb f3 ff ff       	jmp    80105821 <alltraps>

80106436 <vector192>:
.globl vector192
vector192:
  pushl $0
80106436:	6a 00                	push   $0x0
  pushl $192
80106438:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
8010643d:	e9 df f3 ff ff       	jmp    80105821 <alltraps>

80106442 <vector193>:
.globl vector193
vector193:
  pushl $0
80106442:	6a 00                	push   $0x0
  pushl $193
80106444:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
80106449:	e9 d3 f3 ff ff       	jmp    80105821 <alltraps>

8010644e <vector194>:
.globl vector194
vector194:
  pushl $0
8010644e:	6a 00                	push   $0x0
  pushl $194
80106450:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
80106455:	e9 c7 f3 ff ff       	jmp    80105821 <alltraps>

8010645a <vector195>:
.globl vector195
vector195:
  pushl $0
8010645a:	6a 00                	push   $0x0
  pushl $195
8010645c:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106461:	e9 bb f3 ff ff       	jmp    80105821 <alltraps>

80106466 <vector196>:
.globl vector196
vector196:
  pushl $0
80106466:	6a 00                	push   $0x0
  pushl $196
80106468:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010646d:	e9 af f3 ff ff       	jmp    80105821 <alltraps>

80106472 <vector197>:
.globl vector197
vector197:
  pushl $0
80106472:	6a 00                	push   $0x0
  pushl $197
80106474:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
80106479:	e9 a3 f3 ff ff       	jmp    80105821 <alltraps>

8010647e <vector198>:
.globl vector198
vector198:
  pushl $0
8010647e:	6a 00                	push   $0x0
  pushl $198
80106480:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106485:	e9 97 f3 ff ff       	jmp    80105821 <alltraps>

8010648a <vector199>:
.globl vector199
vector199:
  pushl $0
8010648a:	6a 00                	push   $0x0
  pushl $199
8010648c:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106491:	e9 8b f3 ff ff       	jmp    80105821 <alltraps>

80106496 <vector200>:
.globl vector200
vector200:
  pushl $0
80106496:	6a 00                	push   $0x0
  pushl $200
80106498:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010649d:	e9 7f f3 ff ff       	jmp    80105821 <alltraps>

801064a2 <vector201>:
.globl vector201
vector201:
  pushl $0
801064a2:	6a 00                	push   $0x0
  pushl $201
801064a4:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
801064a9:	e9 73 f3 ff ff       	jmp    80105821 <alltraps>

801064ae <vector202>:
.globl vector202
vector202:
  pushl $0
801064ae:	6a 00                	push   $0x0
  pushl $202
801064b0:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
801064b5:	e9 67 f3 ff ff       	jmp    80105821 <alltraps>

801064ba <vector203>:
.globl vector203
vector203:
  pushl $0
801064ba:	6a 00                	push   $0x0
  pushl $203
801064bc:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
801064c1:	e9 5b f3 ff ff       	jmp    80105821 <alltraps>

801064c6 <vector204>:
.globl vector204
vector204:
  pushl $0
801064c6:	6a 00                	push   $0x0
  pushl $204
801064c8:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
801064cd:	e9 4f f3 ff ff       	jmp    80105821 <alltraps>

801064d2 <vector205>:
.globl vector205
vector205:
  pushl $0
801064d2:	6a 00                	push   $0x0
  pushl $205
801064d4:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
801064d9:	e9 43 f3 ff ff       	jmp    80105821 <alltraps>

801064de <vector206>:
.globl vector206
vector206:
  pushl $0
801064de:	6a 00                	push   $0x0
  pushl $206
801064e0:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
801064e5:	e9 37 f3 ff ff       	jmp    80105821 <alltraps>

801064ea <vector207>:
.globl vector207
vector207:
  pushl $0
801064ea:	6a 00                	push   $0x0
  pushl $207
801064ec:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
801064f1:	e9 2b f3 ff ff       	jmp    80105821 <alltraps>

801064f6 <vector208>:
.globl vector208
vector208:
  pushl $0
801064f6:	6a 00                	push   $0x0
  pushl $208
801064f8:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
801064fd:	e9 1f f3 ff ff       	jmp    80105821 <alltraps>

80106502 <vector209>:
.globl vector209
vector209:
  pushl $0
80106502:	6a 00                	push   $0x0
  pushl $209
80106504:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
80106509:	e9 13 f3 ff ff       	jmp    80105821 <alltraps>

8010650e <vector210>:
.globl vector210
vector210:
  pushl $0
8010650e:	6a 00                	push   $0x0
  pushl $210
80106510:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
80106515:	e9 07 f3 ff ff       	jmp    80105821 <alltraps>

8010651a <vector211>:
.globl vector211
vector211:
  pushl $0
8010651a:	6a 00                	push   $0x0
  pushl $211
8010651c:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
80106521:	e9 fb f2 ff ff       	jmp    80105821 <alltraps>

80106526 <vector212>:
.globl vector212
vector212:
  pushl $0
80106526:	6a 00                	push   $0x0
  pushl $212
80106528:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
8010652d:	e9 ef f2 ff ff       	jmp    80105821 <alltraps>

80106532 <vector213>:
.globl vector213
vector213:
  pushl $0
80106532:	6a 00                	push   $0x0
  pushl $213
80106534:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
80106539:	e9 e3 f2 ff ff       	jmp    80105821 <alltraps>

8010653e <vector214>:
.globl vector214
vector214:
  pushl $0
8010653e:	6a 00                	push   $0x0
  pushl $214
80106540:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
80106545:	e9 d7 f2 ff ff       	jmp    80105821 <alltraps>

8010654a <vector215>:
.globl vector215
vector215:
  pushl $0
8010654a:	6a 00                	push   $0x0
  pushl $215
8010654c:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
80106551:	e9 cb f2 ff ff       	jmp    80105821 <alltraps>

80106556 <vector216>:
.globl vector216
vector216:
  pushl $0
80106556:	6a 00                	push   $0x0
  pushl $216
80106558:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
8010655d:	e9 bf f2 ff ff       	jmp    80105821 <alltraps>

80106562 <vector217>:
.globl vector217
vector217:
  pushl $0
80106562:	6a 00                	push   $0x0
  pushl $217
80106564:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
80106569:	e9 b3 f2 ff ff       	jmp    80105821 <alltraps>

8010656e <vector218>:
.globl vector218
vector218:
  pushl $0
8010656e:	6a 00                	push   $0x0
  pushl $218
80106570:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106575:	e9 a7 f2 ff ff       	jmp    80105821 <alltraps>

8010657a <vector219>:
.globl vector219
vector219:
  pushl $0
8010657a:	6a 00                	push   $0x0
  pushl $219
8010657c:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106581:	e9 9b f2 ff ff       	jmp    80105821 <alltraps>

80106586 <vector220>:
.globl vector220
vector220:
  pushl $0
80106586:	6a 00                	push   $0x0
  pushl $220
80106588:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010658d:	e9 8f f2 ff ff       	jmp    80105821 <alltraps>

80106592 <vector221>:
.globl vector221
vector221:
  pushl $0
80106592:	6a 00                	push   $0x0
  pushl $221
80106594:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
80106599:	e9 83 f2 ff ff       	jmp    80105821 <alltraps>

8010659e <vector222>:
.globl vector222
vector222:
  pushl $0
8010659e:	6a 00                	push   $0x0
  pushl $222
801065a0:	68 de 00 00 00       	push   $0xde
  jmp alltraps
801065a5:	e9 77 f2 ff ff       	jmp    80105821 <alltraps>

801065aa <vector223>:
.globl vector223
vector223:
  pushl $0
801065aa:	6a 00                	push   $0x0
  pushl $223
801065ac:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
801065b1:	e9 6b f2 ff ff       	jmp    80105821 <alltraps>

801065b6 <vector224>:
.globl vector224
vector224:
  pushl $0
801065b6:	6a 00                	push   $0x0
  pushl $224
801065b8:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
801065bd:	e9 5f f2 ff ff       	jmp    80105821 <alltraps>

801065c2 <vector225>:
.globl vector225
vector225:
  pushl $0
801065c2:	6a 00                	push   $0x0
  pushl $225
801065c4:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
801065c9:	e9 53 f2 ff ff       	jmp    80105821 <alltraps>

801065ce <vector226>:
.globl vector226
vector226:
  pushl $0
801065ce:	6a 00                	push   $0x0
  pushl $226
801065d0:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
801065d5:	e9 47 f2 ff ff       	jmp    80105821 <alltraps>

801065da <vector227>:
.globl vector227
vector227:
  pushl $0
801065da:	6a 00                	push   $0x0
  pushl $227
801065dc:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
801065e1:	e9 3b f2 ff ff       	jmp    80105821 <alltraps>

801065e6 <vector228>:
.globl vector228
vector228:
  pushl $0
801065e6:	6a 00                	push   $0x0
  pushl $228
801065e8:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
801065ed:	e9 2f f2 ff ff       	jmp    80105821 <alltraps>

801065f2 <vector229>:
.globl vector229
vector229:
  pushl $0
801065f2:	6a 00                	push   $0x0
  pushl $229
801065f4:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
801065f9:	e9 23 f2 ff ff       	jmp    80105821 <alltraps>

801065fe <vector230>:
.globl vector230
vector230:
  pushl $0
801065fe:	6a 00                	push   $0x0
  pushl $230
80106600:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
80106605:	e9 17 f2 ff ff       	jmp    80105821 <alltraps>

8010660a <vector231>:
.globl vector231
vector231:
  pushl $0
8010660a:	6a 00                	push   $0x0
  pushl $231
8010660c:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
80106611:	e9 0b f2 ff ff       	jmp    80105821 <alltraps>

80106616 <vector232>:
.globl vector232
vector232:
  pushl $0
80106616:	6a 00                	push   $0x0
  pushl $232
80106618:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
8010661d:	e9 ff f1 ff ff       	jmp    80105821 <alltraps>

80106622 <vector233>:
.globl vector233
vector233:
  pushl $0
80106622:	6a 00                	push   $0x0
  pushl $233
80106624:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
80106629:	e9 f3 f1 ff ff       	jmp    80105821 <alltraps>

8010662e <vector234>:
.globl vector234
vector234:
  pushl $0
8010662e:	6a 00                	push   $0x0
  pushl $234
80106630:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
80106635:	e9 e7 f1 ff ff       	jmp    80105821 <alltraps>

8010663a <vector235>:
.globl vector235
vector235:
  pushl $0
8010663a:	6a 00                	push   $0x0
  pushl $235
8010663c:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
80106641:	e9 db f1 ff ff       	jmp    80105821 <alltraps>

80106646 <vector236>:
.globl vector236
vector236:
  pushl $0
80106646:	6a 00                	push   $0x0
  pushl $236
80106648:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
8010664d:	e9 cf f1 ff ff       	jmp    80105821 <alltraps>

80106652 <vector237>:
.globl vector237
vector237:
  pushl $0
80106652:	6a 00                	push   $0x0
  pushl $237
80106654:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
80106659:	e9 c3 f1 ff ff       	jmp    80105821 <alltraps>

8010665e <vector238>:
.globl vector238
vector238:
  pushl $0
8010665e:	6a 00                	push   $0x0
  pushl $238
80106660:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106665:	e9 b7 f1 ff ff       	jmp    80105821 <alltraps>

8010666a <vector239>:
.globl vector239
vector239:
  pushl $0
8010666a:	6a 00                	push   $0x0
  pushl $239
8010666c:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106671:	e9 ab f1 ff ff       	jmp    80105821 <alltraps>

80106676 <vector240>:
.globl vector240
vector240:
  pushl $0
80106676:	6a 00                	push   $0x0
  pushl $240
80106678:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010667d:	e9 9f f1 ff ff       	jmp    80105821 <alltraps>

80106682 <vector241>:
.globl vector241
vector241:
  pushl $0
80106682:	6a 00                	push   $0x0
  pushl $241
80106684:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
80106689:	e9 93 f1 ff ff       	jmp    80105821 <alltraps>

8010668e <vector242>:
.globl vector242
vector242:
  pushl $0
8010668e:	6a 00                	push   $0x0
  pushl $242
80106690:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106695:	e9 87 f1 ff ff       	jmp    80105821 <alltraps>

8010669a <vector243>:
.globl vector243
vector243:
  pushl $0
8010669a:	6a 00                	push   $0x0
  pushl $243
8010669c:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
801066a1:	e9 7b f1 ff ff       	jmp    80105821 <alltraps>

801066a6 <vector244>:
.globl vector244
vector244:
  pushl $0
801066a6:	6a 00                	push   $0x0
  pushl $244
801066a8:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
801066ad:	e9 6f f1 ff ff       	jmp    80105821 <alltraps>

801066b2 <vector245>:
.globl vector245
vector245:
  pushl $0
801066b2:	6a 00                	push   $0x0
  pushl $245
801066b4:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
801066b9:	e9 63 f1 ff ff       	jmp    80105821 <alltraps>

801066be <vector246>:
.globl vector246
vector246:
  pushl $0
801066be:	6a 00                	push   $0x0
  pushl $246
801066c0:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
801066c5:	e9 57 f1 ff ff       	jmp    80105821 <alltraps>

801066ca <vector247>:
.globl vector247
vector247:
  pushl $0
801066ca:	6a 00                	push   $0x0
  pushl $247
801066cc:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
801066d1:	e9 4b f1 ff ff       	jmp    80105821 <alltraps>

801066d6 <vector248>:
.globl vector248
vector248:
  pushl $0
801066d6:	6a 00                	push   $0x0
  pushl $248
801066d8:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
801066dd:	e9 3f f1 ff ff       	jmp    80105821 <alltraps>

801066e2 <vector249>:
.globl vector249
vector249:
  pushl $0
801066e2:	6a 00                	push   $0x0
  pushl $249
801066e4:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
801066e9:	e9 33 f1 ff ff       	jmp    80105821 <alltraps>

801066ee <vector250>:
.globl vector250
vector250:
  pushl $0
801066ee:	6a 00                	push   $0x0
  pushl $250
801066f0:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
801066f5:	e9 27 f1 ff ff       	jmp    80105821 <alltraps>

801066fa <vector251>:
.globl vector251
vector251:
  pushl $0
801066fa:	6a 00                	push   $0x0
  pushl $251
801066fc:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
80106701:	e9 1b f1 ff ff       	jmp    80105821 <alltraps>

80106706 <vector252>:
.globl vector252
vector252:
  pushl $0
80106706:	6a 00                	push   $0x0
  pushl $252
80106708:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
8010670d:	e9 0f f1 ff ff       	jmp    80105821 <alltraps>

80106712 <vector253>:
.globl vector253
vector253:
  pushl $0
80106712:	6a 00                	push   $0x0
  pushl $253
80106714:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
80106719:	e9 03 f1 ff ff       	jmp    80105821 <alltraps>

8010671e <vector254>:
.globl vector254
vector254:
  pushl $0
8010671e:	6a 00                	push   $0x0
  pushl $254
80106720:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
80106725:	e9 f7 f0 ff ff       	jmp    80105821 <alltraps>

8010672a <vector255>:
.globl vector255
vector255:
  pushl $0
8010672a:	6a 00                	push   $0x0
  pushl $255
8010672c:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
80106731:	e9 eb f0 ff ff       	jmp    80105821 <alltraps>
80106736:	66 90                	xchg   %ax,%ax
80106738:	66 90                	xchg   %ax,%ax
8010673a:	66 90                	xchg   %ax,%ax
8010673c:	66 90                	xchg   %ax,%ax
8010673e:	66 90                	xchg   %ax,%ax

80106740 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
80106740:	55                   	push   %ebp
80106741:	89 e5                	mov    %esp,%ebp
80106743:	57                   	push   %edi
80106744:	56                   	push   %esi
80106745:	89 d6                	mov    %edx,%esi
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
80106747:	c1 ea 16             	shr    $0x16,%edx
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010674a:	53                   	push   %ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
8010674b:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
8010674e:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
80106751:	8b 1f                	mov    (%edi),%ebx
80106753:	f6 c3 01             	test   $0x1,%bl
80106756:	74 28                	je     80106780 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
80106758:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
8010675e:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106764:	c1 ee 0a             	shr    $0xa,%esi
}
80106767:	83 c4 1c             	add    $0x1c,%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
8010676a:	89 f2                	mov    %esi,%edx
8010676c:	81 e2 fc 0f 00 00    	and    $0xffc,%edx
80106772:	8d 04 13             	lea    (%ebx,%edx,1),%eax
}
80106775:	5b                   	pop    %ebx
80106776:	5e                   	pop    %esi
80106777:	5f                   	pop    %edi
80106778:	5d                   	pop    %ebp
80106779:	c3                   	ret    
8010677a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106780:	85 c9                	test   %ecx,%ecx
80106782:	74 34                	je     801067b8 <walkpgdir+0x78>
80106784:	e8 27 bd ff ff       	call   801024b0 <kalloc>
80106789:	85 c0                	test   %eax,%eax
8010678b:	89 c3                	mov    %eax,%ebx
8010678d:	74 29                	je     801067b8 <walkpgdir+0x78>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010678f:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106796:	00 
80106797:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
8010679e:	00 
8010679f:	89 04 24             	mov    %eax,(%esp)
801067a2:	e8 49 db ff ff       	call   801042f0 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
801067a7:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
801067ad:	83 c8 07             	or     $0x7,%eax
801067b0:	89 07                	mov    %eax,(%edi)
801067b2:	eb b0                	jmp    80106764 <walkpgdir+0x24>
801067b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }
  return &pgtab[PTX(va)];
}
801067b8:	83 c4 1c             	add    $0x1c,%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
801067bb:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
801067bd:	5b                   	pop    %ebx
801067be:	5e                   	pop    %esi
801067bf:	5f                   	pop    %edi
801067c0:	5d                   	pop    %ebp
801067c1:	c3                   	ret    
801067c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067d0 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067d0:	55                   	push   %ebp
801067d1:	89 e5                	mov    %esp,%ebp
801067d3:	57                   	push   %edi
801067d4:	56                   	push   %esi
801067d5:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067d6:	89 d3                	mov    %edx,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067d8:	83 ec 1c             	sub    $0x1c,%esp
801067db:	8b 7d 08             	mov    0x8(%ebp),%edi
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
801067de:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
801067e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067e7:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
801067eb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
801067ee:	83 4d 0c 01          	orl    $0x1,0xc(%ebp)
{
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
801067f2:	81 65 e4 00 f0 ff ff 	andl   $0xfffff000,-0x1c(%ebp)
801067f9:	29 df                	sub    %ebx,%edi
801067fb:	eb 18                	jmp    80106815 <mappages+0x45>
801067fd:	8d 76 00             	lea    0x0(%esi),%esi
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106800:	f6 00 01             	testb  $0x1,(%eax)
80106803:	75 3d                	jne    80106842 <mappages+0x72>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106805:	0b 75 0c             	or     0xc(%ebp),%esi
    if(a == last)
80106808:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010680b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010680d:	74 29                	je     80106838 <mappages+0x68>
      break;
    a += PGSIZE;
8010680f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
80106815:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106818:	b9 01 00 00 00       	mov    $0x1,%ecx
8010681d:	89 da                	mov    %ebx,%edx
8010681f:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
80106822:	e8 19 ff ff ff       	call   80106740 <walkpgdir>
80106827:	85 c0                	test   %eax,%eax
80106829:	75 d5                	jne    80106800 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
8010682b:	83 c4 1c             	add    $0x1c,%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
8010682e:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
80106833:	5b                   	pop    %ebx
80106834:	5e                   	pop    %esi
80106835:	5f                   	pop    %edi
80106836:	5d                   	pop    %ebp
80106837:	c3                   	ret    
80106838:	83 c4 1c             	add    $0x1c,%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
8010683b:	31 c0                	xor    %eax,%eax
}
8010683d:	5b                   	pop    %ebx
8010683e:	5e                   	pop    %esi
8010683f:	5f                   	pop    %edi
80106840:	5d                   	pop    %ebp
80106841:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
80106842:	c7 04 24 ac 7a 10 80 	movl   $0x80107aac,(%esp)
80106849:	e8 12 9b ff ff       	call   80100360 <panic>
8010684e:	66 90                	xchg   %ax,%ax

80106850 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106850:	55                   	push   %ebp
80106851:	89 e5                	mov    %esp,%ebp
80106853:	57                   	push   %edi
80106854:	89 c7                	mov    %eax,%edi
80106856:	56                   	push   %esi
80106857:	89 d6                	mov    %edx,%esi
80106859:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
8010685a:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106860:	83 ec 1c             	sub    $0x1c,%esp
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
80106863:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a  < oldsz; a += PGSIZE){
80106869:	39 d3                	cmp    %edx,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
8010686b:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010686e:	72 3b                	jb     801068ab <deallocuvm.part.0+0x5b>
80106870:	eb 5e                	jmp    801068d0 <deallocuvm.part.0+0x80>
80106872:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106878:	8b 10                	mov    (%eax),%edx
8010687a:	f6 c2 01             	test   $0x1,%dl
8010687d:	74 22                	je     801068a1 <deallocuvm.part.0+0x51>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010687f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106885:	74 54                	je     801068db <deallocuvm.part.0+0x8b>
        panic("kfree");
      char *v = P2V(pa);
80106887:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
8010688d:	89 14 24             	mov    %edx,(%esp)
80106890:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106893:	e8 68 ba ff ff       	call   80102300 <kfree>
      *pte = 0;
80106898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010689b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068a7:	39 f3                	cmp    %esi,%ebx
801068a9:	73 25                	jae    801068d0 <deallocuvm.part.0+0x80>
    pte = walkpgdir(pgdir, (char*)a, 0);
801068ab:	31 c9                	xor    %ecx,%ecx
801068ad:	89 da                	mov    %ebx,%edx
801068af:	89 f8                	mov    %edi,%eax
801068b1:	e8 8a fe ff ff       	call   80106740 <walkpgdir>
    if(!pte)
801068b6:	85 c0                	test   %eax,%eax
801068b8:	75 be                	jne    80106878 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
801068ba:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
801068c0:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
801068c6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801068cc:	39 f3                	cmp    %esi,%ebx
801068ce:	72 db                	jb     801068ab <deallocuvm.part.0+0x5b>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
801068d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
801068d3:	83 c4 1c             	add    $0x1c,%esp
801068d6:	5b                   	pop    %ebx
801068d7:	5e                   	pop    %esi
801068d8:	5f                   	pop    %edi
801068d9:	5d                   	pop    %ebp
801068da:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
801068db:	c7 04 24 c6 72 10 80 	movl   $0x801072c6,(%esp)
801068e2:	e8 79 9a ff ff       	call   80100360 <panic>
801068e7:	89 f6                	mov    %esi,%esi
801068e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801068f0 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
801068f0:	55                   	push   %ebp
801068f1:	89 e5                	mov    %esp,%ebp
801068f3:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
801068f6:	e8 95 cd ff ff       	call   80103690 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068fb:	31 c9                	xor    %ecx,%ecx
801068fd:	ba ff ff ff ff       	mov    $0xffffffff,%edx

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106902:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
80106908:	05 80 27 11 80       	add    $0x80112780,%eax
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010690d:	66 89 50 78          	mov    %dx,0x78(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106911:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
  lgdt(c->gdt, sizeof(c->gdt));
80106916:	83 c0 70             	add    $0x70,%eax
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106919:	66 89 48 0a          	mov    %cx,0xa(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010691d:	31 c9                	xor    %ecx,%ecx
8010691f:	66 89 50 10          	mov    %dx,0x10(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106923:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106928:	66 89 48 12          	mov    %cx,0x12(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010692c:	31 c9                	xor    %ecx,%ecx
8010692e:	66 89 50 18          	mov    %dx,0x18(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106932:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106937:	66 89 48 1a          	mov    %cx,0x1a(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010693b:	31 c9                	xor    %ecx,%ecx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010693d:	c6 40 0d 9a          	movb   $0x9a,0xd(%eax)
80106941:	c6 40 0e cf          	movb   $0xcf,0xe(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
80106945:	c6 40 15 92          	movb   $0x92,0x15(%eax)
80106949:	c6 40 16 cf          	movb   $0xcf,0x16(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010694d:	c6 40 1d fa          	movb   $0xfa,0x1d(%eax)
80106951:	c6 40 1e cf          	movb   $0xcf,0x1e(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106955:	c6 40 25 f2          	movb   $0xf2,0x25(%eax)
80106959:	c6 40 26 cf          	movb   $0xcf,0x26(%eax)
8010695d:	66 89 50 20          	mov    %dx,0x20(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80106961:	ba 2f 00 00 00       	mov    $0x2f,%edx
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
80106966:	c6 40 0c 00          	movb   $0x0,0xc(%eax)
8010696a:	c6 40 0f 00          	movb   $0x0,0xf(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010696e:	c6 40 14 00          	movb   $0x0,0x14(%eax)
80106972:	c6 40 17 00          	movb   $0x0,0x17(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
80106976:	c6 40 1c 00          	movb   $0x0,0x1c(%eax)
8010697a:	c6 40 1f 00          	movb   $0x0,0x1f(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
8010697e:	66 89 48 22          	mov    %cx,0x22(%eax)
80106982:	c6 40 24 00          	movb   $0x0,0x24(%eax)
80106986:	c6 40 27 00          	movb   $0x0,0x27(%eax)
8010698a:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
8010698e:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106992:	c1 e8 10             	shr    $0x10,%eax
80106995:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
80106999:	8d 45 f2             	lea    -0xe(%ebp),%eax
8010699c:	0f 01 10             	lgdtl  (%eax)
  lgdt(c->gdt, sizeof(c->gdt));
}
8010699f:	c9                   	leave  
801069a0:	c3                   	ret    
801069a1:	eb 0d                	jmp    801069b0 <switchkvm>
801069a3:	90                   	nop
801069a4:	90                   	nop
801069a5:	90                   	nop
801069a6:	90                   	nop
801069a7:	90                   	nop
801069a8:	90                   	nop
801069a9:	90                   	nop
801069aa:	90                   	nop
801069ab:	90                   	nop
801069ac:	90                   	nop
801069ad:	90                   	nop
801069ae:	90                   	nop
801069af:	90                   	nop

801069b0 <switchkvm>:
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069b0:	a1 a4 5b 11 80       	mov    0x80115ba4,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
801069b5:	55                   	push   %ebp
801069b6:	89 e5                	mov    %esp,%ebp
  lcr3(V2P(kpgdir));   // switch to the kernel page table
801069b8:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
801069bd:	0f 22 d8             	mov    %eax,%cr3
}
801069c0:	5d                   	pop    %ebp
801069c1:	c3                   	ret    
801069c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069d0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801069d0:	55                   	push   %ebp
801069d1:	89 e5                	mov    %esp,%ebp
801069d3:	57                   	push   %edi
801069d4:	56                   	push   %esi
801069d5:	53                   	push   %ebx
801069d6:	83 ec 1c             	sub    $0x1c,%esp
801069d9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069dc:	85 f6                	test   %esi,%esi
801069de:	0f 84 cd 00 00 00    	je     80106ab1 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801069e4:	8b 46 08             	mov    0x8(%esi),%eax
801069e7:	85 c0                	test   %eax,%eax
801069e9:	0f 84 da 00 00 00    	je     80106ac9 <switchuvm+0xf9>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801069ef:	8b 7e 04             	mov    0x4(%esi),%edi
801069f2:	85 ff                	test   %edi,%edi
801069f4:	0f 84 c3 00 00 00    	je     80106abd <switchuvm+0xed>
    panic("switchuvm: no pgdir");

  pushcli();
801069fa:	e8 41 d7 ff ff       	call   80104140 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069ff:	e8 0c cc ff ff       	call   80103610 <mycpu>
80106a04:	89 c3                	mov    %eax,%ebx
80106a06:	e8 05 cc ff ff       	call   80103610 <mycpu>
80106a0b:	89 c7                	mov    %eax,%edi
80106a0d:	e8 fe cb ff ff       	call   80103610 <mycpu>
80106a12:	83 c7 08             	add    $0x8,%edi
80106a15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106a18:	e8 f3 cb ff ff       	call   80103610 <mycpu>
80106a1d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a20:	ba 67 00 00 00       	mov    $0x67,%edx
80106a25:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a2c:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a33:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a3a:	83 c1 08             	add    $0x8,%ecx
80106a3d:	c1 e9 10             	shr    $0x10,%ecx
80106a40:	83 c0 08             	add    $0x8,%eax
80106a43:	c1 e8 18             	shr    $0x18,%eax
80106a46:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
80106a4c:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a53:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a59:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106a5e:	e8 ad cb ff ff       	call   80103610 <mycpu>
80106a63:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a6a:	e8 a1 cb ff ff       	call   80103610 <mycpu>
80106a6f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106a74:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a78:	e8 93 cb ff ff       	call   80103610 <mycpu>
80106a7d:	8b 56 08             	mov    0x8(%esi),%edx
80106a80:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106a86:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a89:	e8 82 cb ff ff       	call   80103610 <mycpu>
80106a8e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a92:	b8 28 00 00 00       	mov    $0x28,%eax
80106a97:	0f 00 d8             	ltr    %ax
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
80106a9a:	8b 46 04             	mov    0x4(%esi),%eax
80106a9d:	05 00 00 00 80       	add    $0x80000000,%eax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106aa2:	0f 22 d8             	mov    %eax,%cr3
  popcli();
}
80106aa5:	83 c4 1c             	add    $0x1c,%esp
80106aa8:	5b                   	pop    %ebx
80106aa9:	5e                   	pop    %esi
80106aaa:	5f                   	pop    %edi
80106aab:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106aac:	e9 cf d6 ff ff       	jmp    80104180 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106ab1:	c7 04 24 b2 7a 10 80 	movl   $0x80107ab2,(%esp)
80106ab8:	e8 a3 98 ff ff       	call   80100360 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106abd:	c7 04 24 dd 7a 10 80 	movl   $0x80107add,(%esp)
80106ac4:	e8 97 98 ff ff       	call   80100360 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106ac9:	c7 04 24 c8 7a 10 80 	movl   $0x80107ac8,(%esp)
80106ad0:	e8 8b 98 ff ff       	call   80100360 <panic>
80106ad5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106ad9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106ae0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ae0:	55                   	push   %ebp
80106ae1:	89 e5                	mov    %esp,%ebp
80106ae3:	57                   	push   %edi
80106ae4:	56                   	push   %esi
80106ae5:	53                   	push   %ebx
80106ae6:	83 ec 1c             	sub    $0x1c,%esp
80106ae9:	8b 75 10             	mov    0x10(%ebp),%esi
80106aec:	8b 45 08             	mov    0x8(%ebp),%eax
80106aef:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106af2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106af8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106afb:	77 54                	ja     80106b51 <inituvm+0x71>
    panic("inituvm: more than a page");
  mem = kalloc();
80106afd:	e8 ae b9 ff ff       	call   801024b0 <kalloc>
  memset(mem, 0, PGSIZE);
80106b02:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106b09:	00 
80106b0a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106b11:	00 
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106b12:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106b14:	89 04 24             	mov    %eax,(%esp)
80106b17:	e8 d4 d7 ff ff       	call   801042f0 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106b1c:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106b22:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b27:	89 04 24             	mov    %eax,(%esp)
80106b2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b2d:	31 d2                	xor    %edx,%edx
80106b2f:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106b36:	00 
80106b37:	e8 94 fc ff ff       	call   801067d0 <mappages>
  memmove(mem, init, sz);
80106b3c:	89 75 10             	mov    %esi,0x10(%ebp)
80106b3f:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b42:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b45:	83 c4 1c             	add    $0x1c,%esp
80106b48:	5b                   	pop    %ebx
80106b49:	5e                   	pop    %esi
80106b4a:	5f                   	pop    %edi
80106b4b:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b4c:	e9 3f d8 ff ff       	jmp    80104390 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b51:	c7 04 24 f1 7a 10 80 	movl   $0x80107af1,(%esp)
80106b58:	e8 03 98 ff ff       	call   80100360 <panic>
80106b5d:	8d 76 00             	lea    0x0(%esi),%esi

80106b60 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b60:	55                   	push   %ebp
80106b61:	89 e5                	mov    %esp,%ebp
80106b63:	57                   	push   %edi
80106b64:	56                   	push   %esi
80106b65:	53                   	push   %ebx
80106b66:	83 ec 1c             	sub    $0x1c,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b69:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b70:	0f 85 98 00 00 00    	jne    80106c0e <loaduvm+0xae>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b76:	8b 75 18             	mov    0x18(%ebp),%esi
80106b79:	31 db                	xor    %ebx,%ebx
80106b7b:	85 f6                	test   %esi,%esi
80106b7d:	75 1a                	jne    80106b99 <loaduvm+0x39>
80106b7f:	eb 77                	jmp    80106bf8 <loaduvm+0x98>
80106b81:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b88:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b8e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b94:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b97:	76 5f                	jbe    80106bf8 <loaduvm+0x98>
80106b99:	8b 55 0c             	mov    0xc(%ebp),%edx
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b9c:	31 c9                	xor    %ecx,%ecx
80106b9e:	8b 45 08             	mov    0x8(%ebp),%eax
80106ba1:	01 da                	add    %ebx,%edx
80106ba3:	e8 98 fb ff ff       	call   80106740 <walkpgdir>
80106ba8:	85 c0                	test   %eax,%eax
80106baa:	74 56                	je     80106c02 <loaduvm+0xa2>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106bac:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106bae:	bf 00 10 00 00       	mov    $0x1000,%edi
80106bb3:	8b 4d 14             	mov    0x14(%ebp),%ecx
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106bb6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
80106bbb:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
80106bc1:	0f 42 fe             	cmovb  %esi,%edi
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106bc4:	05 00 00 00 80       	add    $0x80000000,%eax
80106bc9:	89 44 24 04          	mov    %eax,0x4(%esp)
80106bcd:	8b 45 10             	mov    0x10(%ebp),%eax
80106bd0:	01 d9                	add    %ebx,%ecx
80106bd2:	89 7c 24 0c          	mov    %edi,0xc(%esp)
80106bd6:	89 4c 24 08          	mov    %ecx,0x8(%esp)
80106bda:	89 04 24             	mov    %eax,(%esp)
80106bdd:	e8 8e ad ff ff       	call   80101970 <readi>
80106be2:	39 f8                	cmp    %edi,%eax
80106be4:	74 a2                	je     80106b88 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106be6:	83 c4 1c             	add    $0x1c,%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106be9:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106bee:	5b                   	pop    %ebx
80106bef:	5e                   	pop    %esi
80106bf0:	5f                   	pop    %edi
80106bf1:	5d                   	pop    %ebp
80106bf2:	c3                   	ret    
80106bf3:	90                   	nop
80106bf4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106bf8:	83 c4 1c             	add    $0x1c,%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106bfb:	31 c0                	xor    %eax,%eax
}
80106bfd:	5b                   	pop    %ebx
80106bfe:	5e                   	pop    %esi
80106bff:	5f                   	pop    %edi
80106c00:	5d                   	pop    %ebp
80106c01:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106c02:	c7 04 24 0b 7b 10 80 	movl   $0x80107b0b,(%esp)
80106c09:	e8 52 97 ff ff       	call   80100360 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106c0e:	c7 04 24 ac 7b 10 80 	movl   $0x80107bac,(%esp)
80106c15:	e8 46 97 ff ff       	call   80100360 <panic>
80106c1a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106c20 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c20:	55                   	push   %ebp
80106c21:	89 e5                	mov    %esp,%ebp
80106c23:	57                   	push   %edi
80106c24:	56                   	push   %esi
80106c25:	53                   	push   %ebx
80106c26:	83 ec 1c             	sub    $0x1c,%esp
80106c29:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106c2c:	85 ff                	test   %edi,%edi
80106c2e:	0f 88 7e 00 00 00    	js     80106cb2 <allocuvm+0x92>
    return 0;
  if(newsz < oldsz)
80106c34:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c3a:	72 78                	jb     80106cb4 <allocuvm+0x94>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c3c:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c42:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c48:	39 df                	cmp    %ebx,%edi
80106c4a:	77 4a                	ja     80106c96 <allocuvm+0x76>
80106c4c:	eb 72                	jmp    80106cc0 <allocuvm+0xa0>
80106c4e:	66 90                	xchg   %ax,%ax
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c50:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106c57:	00 
80106c58:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106c5f:	00 
80106c60:	89 04 24             	mov    %eax,(%esp)
80106c63:	e8 88 d6 ff ff       	call   801042f0 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c68:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c6e:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c73:	89 04 24             	mov    %eax,(%esp)
80106c76:	8b 45 08             	mov    0x8(%ebp),%eax
80106c79:	89 da                	mov    %ebx,%edx
80106c7b:	c7 44 24 04 06 00 00 	movl   $0x6,0x4(%esp)
80106c82:	00 
80106c83:	e8 48 fb ff ff       	call   801067d0 <mappages>
80106c88:	85 c0                	test   %eax,%eax
80106c8a:	78 44                	js     80106cd0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c8c:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c92:	39 df                	cmp    %ebx,%edi
80106c94:	76 2a                	jbe    80106cc0 <allocuvm+0xa0>
    mem = kalloc();
80106c96:	e8 15 b8 ff ff       	call   801024b0 <kalloc>
    if(mem == 0){
80106c9b:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c9d:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c9f:	75 af                	jne    80106c50 <allocuvm+0x30>
      cprintf("allocuvm out of memory\n");
80106ca1:	c7 04 24 29 7b 10 80 	movl   $0x80107b29,(%esp)
80106ca8:	e8 a3 99 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cad:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cb0:	77 48                	ja     80106cfa <allocuvm+0xda>
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106cb2:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106cb4:	83 c4 1c             	add    $0x1c,%esp
80106cb7:	5b                   	pop    %ebx
80106cb8:	5e                   	pop    %esi
80106cb9:	5f                   	pop    %edi
80106cba:	5d                   	pop    %ebp
80106cbb:	c3                   	ret    
80106cbc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80106cc0:	83 c4 1c             	add    $0x1c,%esp
80106cc3:	89 f8                	mov    %edi,%eax
80106cc5:	5b                   	pop    %ebx
80106cc6:	5e                   	pop    %esi
80106cc7:	5f                   	pop    %edi
80106cc8:	5d                   	pop    %ebp
80106cc9:	c3                   	ret    
80106cca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106cd0:	c7 04 24 41 7b 10 80 	movl   $0x80107b41,(%esp)
80106cd7:	e8 74 99 ff ff       	call   80100650 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cdc:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cdf:	76 0d                	jbe    80106cee <allocuvm+0xce>
80106ce1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106ce4:	89 fa                	mov    %edi,%edx
80106ce6:	8b 45 08             	mov    0x8(%ebp),%eax
80106ce9:	e8 62 fb ff ff       	call   80106850 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106cee:	89 34 24             	mov    %esi,(%esp)
80106cf1:	e8 0a b6 ff ff       	call   80102300 <kfree>
      return 0;
80106cf6:	31 c0                	xor    %eax,%eax
80106cf8:	eb ba                	jmp    80106cb4 <allocuvm+0x94>
80106cfa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cfd:	89 fa                	mov    %edi,%edx
80106cff:	8b 45 08             	mov    0x8(%ebp),%eax
80106d02:	e8 49 fb ff ff       	call   80106850 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106d07:	31 c0                	xor    %eax,%eax
80106d09:	eb a9                	jmp    80106cb4 <allocuvm+0x94>
80106d0b:	90                   	nop
80106d0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d10 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d10:	55                   	push   %ebp
80106d11:	89 e5                	mov    %esp,%ebp
80106d13:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d16:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d19:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d1c:	39 d1                	cmp    %edx,%ecx
80106d1e:	73 08                	jae    80106d28 <deallocuvm+0x18>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d20:	5d                   	pop    %ebp
80106d21:	e9 2a fb ff ff       	jmp    80106850 <deallocuvm.part.0>
80106d26:	66 90                	xchg   %ax,%ax
80106d28:	89 d0                	mov    %edx,%eax
80106d2a:	5d                   	pop    %ebp
80106d2b:	c3                   	ret    
80106d2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106d30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	56                   	push   %esi
80106d34:	53                   	push   %ebx
80106d35:	83 ec 10             	sub    $0x10,%esp
80106d38:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d3b:	85 f6                	test   %esi,%esi
80106d3d:	74 59                	je     80106d98 <freevm+0x68>
80106d3f:	31 c9                	xor    %ecx,%ecx
80106d41:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d46:	89 f0                	mov    %esi,%eax
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d48:	31 db                	xor    %ebx,%ebx
80106d4a:	e8 01 fb ff ff       	call   80106850 <deallocuvm.part.0>
80106d4f:	eb 12                	jmp    80106d63 <freevm+0x33>
80106d51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d58:	83 c3 01             	add    $0x1,%ebx
80106d5b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106d61:	74 27                	je     80106d8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d63:	8b 14 9e             	mov    (%esi,%ebx,4),%edx
80106d66:	f6 c2 01             	test   $0x1,%dl
80106d69:	74 ed                	je     80106d58 <freevm+0x28>
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d6b:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d71:	83 c3 01             	add    $0x1,%ebx
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
80106d74:	81 c2 00 00 00 80    	add    $0x80000000,%edx
      kfree(v);
80106d7a:	89 14 24             	mov    %edx,(%esp)
80106d7d:	e8 7e b5 ff ff       	call   80102300 <kfree>
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d82:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
80106d88:	75 d9                	jne    80106d63 <freevm+0x33>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d8d:	83 c4 10             	add    $0x10,%esp
80106d90:	5b                   	pop    %ebx
80106d91:	5e                   	pop    %esi
80106d92:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d93:	e9 68 b5 ff ff       	jmp    80102300 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d98:	c7 04 24 5d 7b 10 80 	movl   $0x80107b5d,(%esp)
80106d9f:	e8 bc 95 ff ff       	call   80100360 <panic>
80106da4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106daa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106db0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	56                   	push   %esi
80106db4:	53                   	push   %ebx
80106db5:	83 ec 10             	sub    $0x10,%esp
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106db8:	e8 f3 b6 ff ff       	call   801024b0 <kalloc>
80106dbd:	85 c0                	test   %eax,%eax
80106dbf:	89 c6                	mov    %eax,%esi
80106dc1:	74 6d                	je     80106e30 <setupkvm+0x80>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106dc3:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106dca:	00 
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dcb:	bb 20 a4 10 80       	mov    $0x8010a420,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106dd0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
80106dd7:	00 
80106dd8:	89 04 24             	mov    %eax,(%esp)
80106ddb:	e8 10 d5 ff ff       	call   801042f0 <memset>
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106de0:	8b 53 0c             	mov    0xc(%ebx),%edx
80106de3:	8b 43 04             	mov    0x4(%ebx),%eax
80106de6:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106de9:	89 54 24 04          	mov    %edx,0x4(%esp)
80106ded:	8b 13                	mov    (%ebx),%edx
80106def:	89 04 24             	mov    %eax,(%esp)
80106df2:	29 c1                	sub    %eax,%ecx
80106df4:	89 f0                	mov    %esi,%eax
80106df6:	e8 d5 f9 ff ff       	call   801067d0 <mappages>
80106dfb:	85 c0                	test   %eax,%eax
80106dfd:	78 19                	js     80106e18 <setupkvm+0x68>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dff:	83 c3 10             	add    $0x10,%ebx
80106e02:	81 fb 60 a4 10 80    	cmp    $0x8010a460,%ebx
80106e08:	72 d6                	jb     80106de0 <setupkvm+0x30>
80106e0a:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106e0c:	83 c4 10             	add    $0x10,%esp
80106e0f:	5b                   	pop    %ebx
80106e10:	5e                   	pop    %esi
80106e11:	5d                   	pop    %ebp
80106e12:	c3                   	ret    
80106e13:	90                   	nop
80106e14:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e18:	89 34 24             	mov    %esi,(%esp)
80106e1b:	e8 10 ff ff ff       	call   80106d30 <freevm>
      return 0;
    }
  return pgdir;
}
80106e20:	83 c4 10             	add    $0x10,%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e23:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106e25:	5b                   	pop    %ebx
80106e26:	5e                   	pop    %esi
80106e27:	5d                   	pop    %ebp
80106e28:	c3                   	ret    
80106e29:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106e30:	31 c0                	xor    %eax,%eax
80106e32:	eb d8                	jmp    80106e0c <setupkvm+0x5c>
80106e34:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106e3a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106e40 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106e40:	55                   	push   %ebp
80106e41:	89 e5                	mov    %esp,%ebp
80106e43:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e46:	e8 65 ff ff ff       	call   80106db0 <setupkvm>
80106e4b:	a3 a4 5b 11 80       	mov    %eax,0x80115ba4
// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
  lcr3(V2P(kpgdir));   // switch to the kernel page table
80106e50:	05 00 00 00 80       	add    $0x80000000,%eax
80106e55:	0f 22 d8             	mov    %eax,%cr3
void
kvmalloc(void)
{
  kpgdir = setupkvm();
  switchkvm();
}
80106e58:	c9                   	leave  
80106e59:	c3                   	ret    
80106e5a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e60 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e60:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e61:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e63:	89 e5                	mov    %esp,%ebp
80106e65:	83 ec 18             	sub    $0x18,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e68:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e6b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e6e:	e8 cd f8 ff ff       	call   80106740 <walkpgdir>
  if(pte == 0)
80106e73:	85 c0                	test   %eax,%eax
80106e75:	74 05                	je     80106e7c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e77:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e7a:	c9                   	leave  
80106e7b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106e7c:	c7 04 24 6e 7b 10 80 	movl   $0x80107b6e,(%esp)
80106e83:	e8 d8 94 ff ff       	call   80100360 <panic>
80106e88:	90                   	nop
80106e89:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e90 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e90:	55                   	push   %ebp
80106e91:	89 e5                	mov    %esp,%ebp
80106e93:	57                   	push   %edi
80106e94:	56                   	push   %esi
80106e95:	53                   	push   %ebx
80106e96:	83 ec 2c             	sub    $0x2c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e99:	e8 12 ff ff ff       	call   80106db0 <setupkvm>
80106e9e:	85 c0                	test   %eax,%eax
80106ea0:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106ea3:	0f 84 b9 00 00 00    	je     80106f62 <copyuvm+0xd2>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ea9:	8b 45 0c             	mov    0xc(%ebp),%eax
80106eac:	85 c0                	test   %eax,%eax
80106eae:	0f 84 94 00 00 00    	je     80106f48 <copyuvm+0xb8>
80106eb4:	31 ff                	xor    %edi,%edi
80106eb6:	eb 48                	jmp    80106f00 <copyuvm+0x70>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106eb8:	81 c6 00 00 00 80    	add    $0x80000000,%esi
80106ebe:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
80106ec5:	00 
80106ec6:	89 74 24 04          	mov    %esi,0x4(%esp)
80106eca:	89 04 24             	mov    %eax,(%esp)
80106ecd:	e8 be d4 ff ff       	call   80104390 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ed2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106ed5:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106eda:	89 fa                	mov    %edi,%edx
80106edc:	89 44 24 04          	mov    %eax,0x4(%esp)
80106ee0:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106ee6:	89 04 24             	mov    %eax,(%esp)
80106ee9:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106eec:	e8 df f8 ff ff       	call   801067d0 <mappages>
80106ef1:	85 c0                	test   %eax,%eax
80106ef3:	78 63                	js     80106f58 <copyuvm+0xc8>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ef5:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106efb:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106efe:	76 48                	jbe    80106f48 <copyuvm+0xb8>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106f00:	8b 45 08             	mov    0x8(%ebp),%eax
80106f03:	31 c9                	xor    %ecx,%ecx
80106f05:	89 fa                	mov    %edi,%edx
80106f07:	e8 34 f8 ff ff       	call   80106740 <walkpgdir>
80106f0c:	85 c0                	test   %eax,%eax
80106f0e:	74 62                	je     80106f72 <copyuvm+0xe2>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106f10:	8b 00                	mov    (%eax),%eax
80106f12:	a8 01                	test   $0x1,%al
80106f14:	74 50                	je     80106f66 <copyuvm+0xd6>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f16:	89 c6                	mov    %eax,%esi
    flags = PTE_FLAGS(*pte);
80106f18:	25 ff 0f 00 00       	and    $0xfff,%eax
80106f1d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f20:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
80106f26:	e8 85 b5 ff ff       	call   801024b0 <kalloc>
80106f2b:	85 c0                	test   %eax,%eax
80106f2d:	89 c3                	mov    %eax,%ebx
80106f2f:	75 87                	jne    80106eb8 <copyuvm+0x28>
    }
  }
  return d;

bad:
  freevm(d);
80106f31:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f34:	89 04 24             	mov    %eax,(%esp)
80106f37:	e8 f4 fd ff ff       	call   80106d30 <freevm>
  return 0;
80106f3c:	31 c0                	xor    %eax,%eax
}
80106f3e:	83 c4 2c             	add    $0x2c,%esp
80106f41:	5b                   	pop    %ebx
80106f42:	5e                   	pop    %esi
80106f43:	5f                   	pop    %edi
80106f44:	5d                   	pop    %ebp
80106f45:	c3                   	ret    
80106f46:	66 90                	xchg   %ax,%ax
80106f48:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106f4b:	83 c4 2c             	add    $0x2c,%esp
80106f4e:	5b                   	pop    %ebx
80106f4f:	5e                   	pop    %esi
80106f50:	5f                   	pop    %edi
80106f51:	5d                   	pop    %ebp
80106f52:	c3                   	ret    
80106f53:	90                   	nop
80106f54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106f58:	89 1c 24             	mov    %ebx,(%esp)
80106f5b:	e8 a0 b3 ff ff       	call   80102300 <kfree>
      goto bad;
80106f60:	eb cf                	jmp    80106f31 <copyuvm+0xa1>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106f62:	31 c0                	xor    %eax,%eax
80106f64:	eb d8                	jmp    80106f3e <copyuvm+0xae>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106f66:	c7 04 24 92 7b 10 80 	movl   $0x80107b92,(%esp)
80106f6d:	e8 ee 93 ff ff       	call   80100360 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f72:	c7 04 24 78 7b 10 80 	movl   $0x80107b78,(%esp)
80106f79:	e8 e2 93 ff ff       	call   80100360 <panic>
80106f7e:	66 90                	xchg   %ax,%ax

80106f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f81:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f83:	89 e5                	mov    %esp,%ebp
80106f85:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8e:	e8 ad f7 ff ff       	call   80106740 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f93:	8b 00                	mov    (%eax),%eax
80106f95:	89 c2                	mov    %eax,%edx
80106f97:	83 e2 05             	and    $0x5,%edx
    return 0;
  if((*pte & PTE_U) == 0)
80106f9a:	83 fa 05             	cmp    $0x5,%edx
80106f9d:	75 11                	jne    80106fb0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106fa4:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106fa9:	c9                   	leave  
80106faa:	c3                   	ret    
80106fab:	90                   	nop
80106fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106fb0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fb2:	c9                   	leave  
80106fb3:	c3                   	ret    
80106fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fcc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fd2:	85 db                	test   %ebx,%ebx
80106fd4:	75 3a                	jne    80107010 <copyout+0x50>
80106fd6:	eb 68                	jmp    80107040 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fd8:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106fdb:	89 f2                	mov    %esi,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fdd:	89 7c 24 04          	mov    %edi,0x4(%esp)
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fe1:	29 ca                	sub    %ecx,%edx
80106fe3:	81 c2 00 10 00 00    	add    $0x1000,%edx
80106fe9:	39 da                	cmp    %ebx,%edx
80106feb:	0f 47 d3             	cmova  %ebx,%edx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106fee:	29 f1                	sub    %esi,%ecx
80106ff0:	01 c8                	add    %ecx,%eax
80106ff2:	89 54 24 08          	mov    %edx,0x8(%esp)
80106ff6:	89 04 24             	mov    %eax,(%esp)
80106ff9:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80106ffc:	e8 8f d3 ff ff       	call   80104390 <memmove>
    len -= n;
    buf += n;
80107001:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    va = va0 + PGSIZE;
80107004:	8d 8e 00 10 00 00    	lea    0x1000(%esi),%ecx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
8010700a:	01 d7                	add    %edx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
8010700c:	29 d3                	sub    %edx,%ebx
8010700e:	74 30                	je     80107040 <copyout+0x80>
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
80107010:	8b 45 08             	mov    0x8(%ebp),%eax
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
80107013:	89 ce                	mov    %ecx,%esi
80107015:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
8010701b:	89 74 24 04          	mov    %esi,0x4(%esp)
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010701f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
    pa0 = uva2ka(pgdir, (char*)va0);
80107022:	89 04 24             	mov    %eax,(%esp)
80107025:	e8 56 ff ff ff       	call   80106f80 <uva2ka>
    if(pa0 == 0)
8010702a:	85 c0                	test   %eax,%eax
8010702c:	75 aa                	jne    80106fd8 <copyout+0x18>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010702e:	83 c4 1c             	add    $0x1c,%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107031:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107036:	5b                   	pop    %ebx
80107037:	5e                   	pop    %esi
80107038:	5f                   	pop    %edi
80107039:	5d                   	pop    %ebp
8010703a:	c3                   	ret    
8010703b:	90                   	nop
8010703c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80107040:	83 c4 1c             	add    $0x1c,%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
80107043:	31 c0                	xor    %eax,%eax
}
80107045:	5b                   	pop    %ebx
80107046:	5e                   	pop    %esi
80107047:	5f                   	pop    %edi
80107048:	5d                   	pop    %ebp
80107049:	c3                   	ret    
