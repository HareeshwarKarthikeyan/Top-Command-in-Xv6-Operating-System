
_helloworld:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "types.h"
#include "stat.h"
#include "user.h"

int main(void){
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	83 e4 f0             	and    $0xfffffff0,%esp
   6:	83 ec 10             	sub    $0x10,%esp
    hello(5);
   9:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  10:	e8 cd 02 00 00       	call   2e2 <hello>
    exit();
  15:	e8 28 02 00 00       	call   242 <exit>
  1a:	66 90                	xchg   %ax,%ax
  1c:	66 90                	xchg   %ax,%ax
  1e:	66 90                	xchg   %ax,%ax

00000020 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  20:	55                   	push   %ebp
  21:	89 e5                	mov    %esp,%ebp
  23:	8b 45 08             	mov    0x8(%ebp),%eax
  26:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  29:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  2a:	89 c2                	mov    %eax,%edx
  2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  30:	83 c1 01             	add    $0x1,%ecx
  33:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  37:	83 c2 01             	add    $0x1,%edx
  3a:	84 db                	test   %bl,%bl
  3c:	88 5a ff             	mov    %bl,-0x1(%edx)
  3f:	75 ef                	jne    30 <strcpy+0x10>
    ;
  return os;
}
  41:	5b                   	pop    %ebx
  42:	5d                   	pop    %ebp
  43:	c3                   	ret    
  44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000050 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  50:	55                   	push   %ebp
  51:	89 e5                	mov    %esp,%ebp
  53:	8b 55 08             	mov    0x8(%ebp),%edx
  56:	53                   	push   %ebx
  57:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
  5a:	0f b6 02             	movzbl (%edx),%eax
  5d:	84 c0                	test   %al,%al
  5f:	74 2d                	je     8e <strcmp+0x3e>
  61:	0f b6 19             	movzbl (%ecx),%ebx
  64:	38 d8                	cmp    %bl,%al
  66:	74 0e                	je     76 <strcmp+0x26>
  68:	eb 2b                	jmp    95 <strcmp+0x45>
  6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  70:	38 c8                	cmp    %cl,%al
  72:	75 15                	jne    89 <strcmp+0x39>
    p++, q++;
  74:	89 d9                	mov    %ebx,%ecx
  76:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  79:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
  7c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  7f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
  83:	84 c0                	test   %al,%al
  85:	75 e9                	jne    70 <strcmp+0x20>
  87:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
  89:	29 c8                	sub    %ecx,%eax
}
  8b:	5b                   	pop    %ebx
  8c:	5d                   	pop    %ebp
  8d:	c3                   	ret    
  8e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
  91:	31 c0                	xor    %eax,%eax
  93:	eb f4                	jmp    89 <strcmp+0x39>
  95:	0f b6 cb             	movzbl %bl,%ecx
  98:	eb ef                	jmp    89 <strcmp+0x39>
  9a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000000a0 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
  a0:	55                   	push   %ebp
  a1:	89 e5                	mov    %esp,%ebp
  a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  a6:	80 39 00             	cmpb   $0x0,(%ecx)
  a9:	74 12                	je     bd <strlen+0x1d>
  ab:	31 d2                	xor    %edx,%edx
  ad:	8d 76 00             	lea    0x0(%esi),%esi
  b0:	83 c2 01             	add    $0x1,%edx
  b3:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
  b7:	89 d0                	mov    %edx,%eax
  b9:	75 f5                	jne    b0 <strlen+0x10>
    ;
  return n;
}
  bb:	5d                   	pop    %ebp
  bc:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
  bd:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
  bf:	5d                   	pop    %ebp
  c0:	c3                   	ret    
  c1:	eb 0d                	jmp    d0 <memset>
  c3:	90                   	nop
  c4:	90                   	nop
  c5:	90                   	nop
  c6:	90                   	nop
  c7:	90                   	nop
  c8:	90                   	nop
  c9:	90                   	nop
  ca:	90                   	nop
  cb:	90                   	nop
  cc:	90                   	nop
  cd:	90                   	nop
  ce:	90                   	nop
  cf:	90                   	nop

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 55 08             	mov    0x8(%ebp),%edx
  d6:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  da:	8b 45 0c             	mov    0xc(%ebp),%eax
  dd:	89 d7                	mov    %edx,%edi
  df:	fc                   	cld    
  e0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e2:	89 d0                	mov    %edx,%eax
  e4:	5f                   	pop    %edi
  e5:	5d                   	pop    %ebp
  e6:	c3                   	ret    
  e7:	89 f6                	mov    %esi,%esi
  e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000000f0 <strchr>:

char*
strchr(const char *s, char c)
{
  f0:	55                   	push   %ebp
  f1:	89 e5                	mov    %esp,%ebp
  f3:	8b 45 08             	mov    0x8(%ebp),%eax
  f6:	53                   	push   %ebx
  f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
  fa:	0f b6 18             	movzbl (%eax),%ebx
  fd:	84 db                	test   %bl,%bl
  ff:	74 1d                	je     11e <strchr+0x2e>
    if(*s == c)
 101:	38 d3                	cmp    %dl,%bl
 103:	89 d1                	mov    %edx,%ecx
 105:	75 0d                	jne    114 <strchr+0x24>
 107:	eb 17                	jmp    120 <strchr+0x30>
 109:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 110:	38 ca                	cmp    %cl,%dl
 112:	74 0c                	je     120 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 114:	83 c0 01             	add    $0x1,%eax
 117:	0f b6 10             	movzbl (%eax),%edx
 11a:	84 d2                	test   %dl,%dl
 11c:	75 f2                	jne    110 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 11e:	31 c0                	xor    %eax,%eax
}
 120:	5b                   	pop    %ebx
 121:	5d                   	pop    %ebp
 122:	c3                   	ret    
 123:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 129:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

00000130 <gets>:

char*
gets(char *buf, int max)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	57                   	push   %edi
 134:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 135:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 137:	53                   	push   %ebx
 138:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 13b:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 13e:	eb 31                	jmp    171 <gets+0x41>
    cc = read(0, &c, 1);
 140:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 147:	00 
 148:	89 7c 24 04          	mov    %edi,0x4(%esp)
 14c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 153:	e8 02 01 00 00       	call   25a <read>
    if(cc < 1)
 158:	85 c0                	test   %eax,%eax
 15a:	7e 1d                	jle    179 <gets+0x49>
      break;
    buf[i++] = c;
 15c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 160:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 162:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 165:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 167:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 16b:	74 0c                	je     179 <gets+0x49>
 16d:	3c 0a                	cmp    $0xa,%al
 16f:	74 08                	je     179 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 171:	8d 5e 01             	lea    0x1(%esi),%ebx
 174:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 177:	7c c7                	jl     140 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 179:	8b 45 08             	mov    0x8(%ebp),%eax
 17c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 180:	83 c4 2c             	add    $0x2c,%esp
 183:	5b                   	pop    %ebx
 184:	5e                   	pop    %esi
 185:	5f                   	pop    %edi
 186:	5d                   	pop    %ebp
 187:	c3                   	ret    
 188:	90                   	nop
 189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000190 <stat>:

int
stat(const char *n, struct stat *st)
{
 190:	55                   	push   %ebp
 191:	89 e5                	mov    %esp,%ebp
 193:	56                   	push   %esi
 194:	53                   	push   %ebx
 195:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 198:	8b 45 08             	mov    0x8(%ebp),%eax
 19b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 1a2:	00 
 1a3:	89 04 24             	mov    %eax,(%esp)
 1a6:	e8 d7 00 00 00       	call   282 <open>
  if(fd < 0)
 1ab:	85 c0                	test   %eax,%eax
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1ad:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 1af:	78 27                	js     1d8 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 1b1:	8b 45 0c             	mov    0xc(%ebp),%eax
 1b4:	89 1c 24             	mov    %ebx,(%esp)
 1b7:	89 44 24 04          	mov    %eax,0x4(%esp)
 1bb:	e8 da 00 00 00       	call   29a <fstat>
  close(fd);
 1c0:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 1c3:	89 c6                	mov    %eax,%esi
  close(fd);
 1c5:	e8 a0 00 00 00       	call   26a <close>
  return r;
 1ca:	89 f0                	mov    %esi,%eax
}
 1cc:	83 c4 10             	add    $0x10,%esp
 1cf:	5b                   	pop    %ebx
 1d0:	5e                   	pop    %esi
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	90                   	nop
 1d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 1d8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 1dd:	eb ed                	jmp    1cc <stat+0x3c>
 1df:	90                   	nop

000001e0 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
 1e6:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e7:	0f be 11             	movsbl (%ecx),%edx
 1ea:	8d 42 d0             	lea    -0x30(%edx),%eax
 1ed:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 1ef:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 1f4:	77 17                	ja     20d <atoi+0x2d>
 1f6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 1f8:	83 c1 01             	add    $0x1,%ecx
 1fb:	8d 04 80             	lea    (%eax,%eax,4),%eax
 1fe:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 202:	0f be 11             	movsbl (%ecx),%edx
 205:	8d 5a d0             	lea    -0x30(%edx),%ebx
 208:	80 fb 09             	cmp    $0x9,%bl
 20b:	76 eb                	jbe    1f8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 20d:	5b                   	pop    %ebx
 20e:	5d                   	pop    %ebp
 20f:	c3                   	ret    

00000210 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 210:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 211:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 213:	89 e5                	mov    %esp,%ebp
 215:	56                   	push   %esi
 216:	8b 45 08             	mov    0x8(%ebp),%eax
 219:	53                   	push   %ebx
 21a:	8b 5d 10             	mov    0x10(%ebp),%ebx
 21d:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 220:	85 db                	test   %ebx,%ebx
 222:	7e 12                	jle    236 <memmove+0x26>
 224:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 228:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 22c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 22f:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 232:	39 da                	cmp    %ebx,%edx
 234:	75 f2                	jne    228 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 236:	5b                   	pop    %ebx
 237:	5e                   	pop    %esi
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    

0000023a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 23a:	b8 01 00 00 00       	mov    $0x1,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <exit>:
SYSCALL(exit)
 242:	b8 02 00 00 00       	mov    $0x2,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <wait>:
SYSCALL(wait)
 24a:	b8 03 00 00 00       	mov    $0x3,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <pipe>:
SYSCALL(pipe)
 252:	b8 04 00 00 00       	mov    $0x4,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <read>:
SYSCALL(read)
 25a:	b8 05 00 00 00       	mov    $0x5,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <write>:
SYSCALL(write)
 262:	b8 10 00 00 00       	mov    $0x10,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <close>:
SYSCALL(close)
 26a:	b8 15 00 00 00       	mov    $0x15,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <kill>:
SYSCALL(kill)
 272:	b8 06 00 00 00       	mov    $0x6,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <exec>:
SYSCALL(exec)
 27a:	b8 07 00 00 00       	mov    $0x7,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <open>:
SYSCALL(open)
 282:	b8 0f 00 00 00       	mov    $0xf,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <mknod>:
SYSCALL(mknod)
 28a:	b8 11 00 00 00       	mov    $0x11,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <unlink>:
SYSCALL(unlink)
 292:	b8 12 00 00 00       	mov    $0x12,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <fstat>:
SYSCALL(fstat)
 29a:	b8 08 00 00 00       	mov    $0x8,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <link>:
SYSCALL(link)
 2a2:	b8 13 00 00 00       	mov    $0x13,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <mkdir>:
SYSCALL(mkdir)
 2aa:	b8 14 00 00 00       	mov    $0x14,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <chdir>:
SYSCALL(chdir)
 2b2:	b8 09 00 00 00       	mov    $0x9,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <dup>:
SYSCALL(dup)
 2ba:	b8 0a 00 00 00       	mov    $0xa,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <getpid>:
SYSCALL(getpid)
 2c2:	b8 0b 00 00 00       	mov    $0xb,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <sbrk>:
SYSCALL(sbrk)
 2ca:	b8 0c 00 00 00       	mov    $0xc,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <sleep>:
SYSCALL(sleep)
 2d2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <uptime>:
SYSCALL(uptime)
 2da:	b8 0e 00 00 00       	mov    $0xe,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <hello>:
SYSCALL(hello)
 2e2:	b8 16 00 00 00       	mov    $0x16,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <halt>:
SYSCALL(halt)
 2ea:	b8 17 00 00 00       	mov    $0x17,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <gettop>:
SYSCALL(gettop)
 2f2:	b8 18 00 00 00       	mov    $0x18,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    
 2fa:	66 90                	xchg   %ax,%ax
 2fc:	66 90                	xchg   %ax,%ax
 2fe:	66 90                	xchg   %ax,%ax

00000300 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 300:	55                   	push   %ebp
 301:	89 e5                	mov    %esp,%ebp
 303:	57                   	push   %edi
 304:	56                   	push   %esi
 305:	89 c6                	mov    %eax,%esi
 307:	53                   	push   %ebx
 308:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 30b:	8b 5d 08             	mov    0x8(%ebp),%ebx
 30e:	85 db                	test   %ebx,%ebx
 310:	74 09                	je     31b <printint+0x1b>
 312:	89 d0                	mov    %edx,%eax
 314:	c1 e8 1f             	shr    $0x1f,%eax
 317:	84 c0                	test   %al,%al
 319:	75 75                	jne    390 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 31b:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 31d:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 324:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 327:	31 ff                	xor    %edi,%edi
 329:	89 ce                	mov    %ecx,%esi
 32b:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 32e:	eb 02                	jmp    332 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 330:	89 cf                	mov    %ecx,%edi
 332:	31 d2                	xor    %edx,%edx
 334:	f7 f6                	div    %esi
 336:	8d 4f 01             	lea    0x1(%edi),%ecx
 339:	0f b6 92 0d 07 00 00 	movzbl 0x70d(%edx),%edx
  }while((x /= base) != 0);
 340:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 342:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 345:	75 e9                	jne    330 <printint+0x30>
  if(neg)
 347:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 34a:	89 c8                	mov    %ecx,%eax
 34c:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 34f:	85 d2                	test   %edx,%edx
 351:	74 08                	je     35b <printint+0x5b>
    buf[i++] = '-';
 353:	8d 4f 02             	lea    0x2(%edi),%ecx
 356:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 35b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 35e:	66 90                	xchg   %ax,%ax
 360:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 365:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 368:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 36f:	00 
 370:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 374:	89 34 24             	mov    %esi,(%esp)
 377:	88 45 d7             	mov    %al,-0x29(%ebp)
 37a:	e8 e3 fe ff ff       	call   262 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 37f:	83 ff ff             	cmp    $0xffffffff,%edi
 382:	75 dc                	jne    360 <printint+0x60>
    putc(fd, buf[i]);
}
 384:	83 c4 4c             	add    $0x4c,%esp
 387:	5b                   	pop    %ebx
 388:	5e                   	pop    %esi
 389:	5f                   	pop    %edi
 38a:	5d                   	pop    %ebp
 38b:	c3                   	ret    
 38c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 390:	89 d0                	mov    %edx,%eax
 392:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 394:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 39b:	eb 87                	jmp    324 <printint+0x24>
 39d:	8d 76 00             	lea    0x0(%esi),%esi

000003a0 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a0:	55                   	push   %ebp
 3a1:	89 e5                	mov    %esp,%ebp
 3a3:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 3a4:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3a6:	56                   	push   %esi
 3a7:	53                   	push   %ebx
 3a8:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ab:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ae:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3b1:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3b4:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 3b7:	0f b6 13             	movzbl (%ebx),%edx
 3ba:	83 c3 01             	add    $0x1,%ebx
 3bd:	84 d2                	test   %dl,%dl
 3bf:	75 39                	jne    3fa <printf+0x5a>
 3c1:	e9 c2 00 00 00       	jmp    488 <printf+0xe8>
 3c6:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 3c8:	83 fa 25             	cmp    $0x25,%edx
 3cb:	0f 84 bf 00 00 00    	je     490 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3d1:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 3d4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 3db:	00 
 3dc:	89 44 24 04          	mov    %eax,0x4(%esp)
 3e0:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3e3:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 3e6:	e8 77 fe ff ff       	call   262 <write>
 3eb:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 3ee:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 3f2:	84 d2                	test   %dl,%dl
 3f4:	0f 84 8e 00 00 00    	je     488 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 3fa:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 3fc:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 3ff:	74 c7                	je     3c8 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 401:	83 ff 25             	cmp    $0x25,%edi
 404:	75 e5                	jne    3eb <printf+0x4b>
      if(c == 'd'){
 406:	83 fa 64             	cmp    $0x64,%edx
 409:	0f 84 31 01 00 00    	je     540 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 40f:	25 f7 00 00 00       	and    $0xf7,%eax
 414:	83 f8 70             	cmp    $0x70,%eax
 417:	0f 84 83 00 00 00    	je     4a0 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 41d:	83 fa 73             	cmp    $0x73,%edx
 420:	0f 84 a2 00 00 00    	je     4c8 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 426:	83 fa 63             	cmp    $0x63,%edx
 429:	0f 84 35 01 00 00    	je     564 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 42f:	83 fa 25             	cmp    $0x25,%edx
 432:	0f 84 e0 00 00 00    	je     518 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 438:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 43b:	83 c3 01             	add    $0x1,%ebx
 43e:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 445:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 446:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 448:	89 44 24 04          	mov    %eax,0x4(%esp)
 44c:	89 34 24             	mov    %esi,(%esp)
 44f:	89 55 d0             	mov    %edx,-0x30(%ebp)
 452:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 456:	e8 07 fe ff ff       	call   262 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 45b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 45e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 461:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 468:	00 
 469:	89 44 24 04          	mov    %eax,0x4(%esp)
 46d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 470:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 473:	e8 ea fd ff ff       	call   262 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 478:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 47c:	84 d2                	test   %dl,%dl
 47e:	0f 85 76 ff ff ff    	jne    3fa <printf+0x5a>
 484:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 488:	83 c4 3c             	add    $0x3c,%esp
 48b:	5b                   	pop    %ebx
 48c:	5e                   	pop    %esi
 48d:	5f                   	pop    %edi
 48e:	5d                   	pop    %ebp
 48f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 490:	bf 25 00 00 00       	mov    $0x25,%edi
 495:	e9 51 ff ff ff       	jmp    3eb <printf+0x4b>
 49a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4a0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4a3:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4a8:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 4aa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 4b1:	8b 10                	mov    (%eax),%edx
 4b3:	89 f0                	mov    %esi,%eax
 4b5:	e8 46 fe ff ff       	call   300 <printint>
        ap++;
 4ba:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 4be:	e9 28 ff ff ff       	jmp    3eb <printf+0x4b>
 4c3:	90                   	nop
 4c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 4c8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 4cb:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 4cf:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 4d1:	b8 06 07 00 00       	mov    $0x706,%eax
 4d6:	85 ff                	test   %edi,%edi
 4d8:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 4db:	0f b6 07             	movzbl (%edi),%eax
 4de:	84 c0                	test   %al,%al
 4e0:	74 2a                	je     50c <printf+0x16c>
 4e2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 4e8:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4eb:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 4ee:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f8:	00 
 4f9:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fd:	89 34 24             	mov    %esi,(%esp)
 500:	e8 5d fd ff ff       	call   262 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 505:	0f b6 07             	movzbl (%edi),%eax
 508:	84 c0                	test   %al,%al
 50a:	75 dc                	jne    4e8 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 50c:	31 ff                	xor    %edi,%edi
 50e:	e9 d8 fe ff ff       	jmp    3eb <printf+0x4b>
 513:	90                   	nop
 514:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 518:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 51b:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 51d:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 524:	00 
 525:	89 44 24 04          	mov    %eax,0x4(%esp)
 529:	89 34 24             	mov    %esi,(%esp)
 52c:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 530:	e8 2d fd ff ff       	call   262 <write>
 535:	e9 b1 fe ff ff       	jmp    3eb <printf+0x4b>
 53a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 540:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 543:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 548:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 54b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 552:	8b 10                	mov    (%eax),%edx
 554:	89 f0                	mov    %esi,%eax
 556:	e8 a5 fd ff ff       	call   300 <printint>
        ap++;
 55b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 55f:	e9 87 fe ff ff       	jmp    3eb <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 564:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 567:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 569:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 56b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 572:	00 
 573:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 576:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 579:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 57c:	89 44 24 04          	mov    %eax,0x4(%esp)
 580:	e8 dd fc ff ff       	call   262 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 585:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 589:	e9 5d fe ff ff       	jmp    3eb <printf+0x4b>
 58e:	66 90                	xchg   %ax,%ax

00000590 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 590:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 591:	a1 84 09 00 00       	mov    0x984,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 596:	89 e5                	mov    %esp,%ebp
 598:	57                   	push   %edi
 599:	56                   	push   %esi
 59a:	53                   	push   %ebx
 59b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 59e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a0:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a3:	39 d0                	cmp    %edx,%eax
 5a5:	72 11                	jb     5b8 <free+0x28>
 5a7:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5a8:	39 c8                	cmp    %ecx,%eax
 5aa:	72 04                	jb     5b0 <free+0x20>
 5ac:	39 ca                	cmp    %ecx,%edx
 5ae:	72 10                	jb     5c0 <free+0x30>
 5b0:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b2:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b4:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5b6:	73 f0                	jae    5a8 <free+0x18>
 5b8:	39 ca                	cmp    %ecx,%edx
 5ba:	72 04                	jb     5c0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5bc:	39 c8                	cmp    %ecx,%eax
 5be:	72 f0                	jb     5b0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5c0:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c3:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 5c6:	39 cf                	cmp    %ecx,%edi
 5c8:	74 1e                	je     5e8 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ca:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5cd:	8b 48 04             	mov    0x4(%eax),%ecx
 5d0:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5d3:	39 f2                	cmp    %esi,%edx
 5d5:	74 28                	je     5ff <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d7:	89 10                	mov    %edx,(%eax)
  freep = p;
 5d9:	a3 84 09 00 00       	mov    %eax,0x984
}
 5de:	5b                   	pop    %ebx
 5df:	5e                   	pop    %esi
 5e0:	5f                   	pop    %edi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
 5e3:	90                   	nop
 5e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 5e8:	03 71 04             	add    0x4(%ecx),%esi
 5eb:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5ee:	8b 08                	mov    (%eax),%ecx
 5f0:	8b 09                	mov    (%ecx),%ecx
 5f2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 5f5:	8b 48 04             	mov    0x4(%eax),%ecx
 5f8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 5fb:	39 f2                	cmp    %esi,%edx
 5fd:	75 d8                	jne    5d7 <free+0x47>
    p->s.size += bp->s.size;
 5ff:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 602:	a3 84 09 00 00       	mov    %eax,0x984
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 607:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 60a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 60d:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 60f:	5b                   	pop    %ebx
 610:	5e                   	pop    %esi
 611:	5f                   	pop    %edi
 612:	5d                   	pop    %ebp
 613:	c3                   	ret    
 614:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 61a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000620 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 620:	55                   	push   %ebp
 621:	89 e5                	mov    %esp,%ebp
 623:	57                   	push   %edi
 624:	56                   	push   %esi
 625:	53                   	push   %ebx
 626:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 629:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 62c:	8b 1d 84 09 00 00    	mov    0x984,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 632:	8d 48 07             	lea    0x7(%eax),%ecx
 635:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 638:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 63a:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 63d:	0f 84 9b 00 00 00    	je     6de <malloc+0xbe>
 643:	8b 13                	mov    (%ebx),%edx
 645:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 648:	39 fe                	cmp    %edi,%esi
 64a:	76 64                	jbe    6b0 <malloc+0x90>
 64c:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 653:	bb 00 80 00 00       	mov    $0x8000,%ebx
 658:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 65b:	eb 0e                	jmp    66b <malloc+0x4b>
 65d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 660:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 662:	8b 78 04             	mov    0x4(%eax),%edi
 665:	39 fe                	cmp    %edi,%esi
 667:	76 4f                	jbe    6b8 <malloc+0x98>
 669:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 66b:	3b 15 84 09 00 00    	cmp    0x984,%edx
 671:	75 ed                	jne    660 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 673:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 676:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 67c:	bf 00 10 00 00       	mov    $0x1000,%edi
 681:	0f 43 fe             	cmovae %esi,%edi
 684:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 687:	89 04 24             	mov    %eax,(%esp)
 68a:	e8 3b fc ff ff       	call   2ca <sbrk>
  if(p == (char*)-1)
 68f:	83 f8 ff             	cmp    $0xffffffff,%eax
 692:	74 18                	je     6ac <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 694:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 697:	83 c0 08             	add    $0x8,%eax
 69a:	89 04 24             	mov    %eax,(%esp)
 69d:	e8 ee fe ff ff       	call   590 <free>
  return freep;
 6a2:	8b 15 84 09 00 00    	mov    0x984,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 6a8:	85 d2                	test   %edx,%edx
 6aa:	75 b4                	jne    660 <malloc+0x40>
        return 0;
 6ac:	31 c0                	xor    %eax,%eax
 6ae:	eb 20                	jmp    6d0 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6b0:	89 d0                	mov    %edx,%eax
 6b2:	89 da                	mov    %ebx,%edx
 6b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 6b8:	39 fe                	cmp    %edi,%esi
 6ba:	74 1c                	je     6d8 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6bc:	29 f7                	sub    %esi,%edi
 6be:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 6c1:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 6c4:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 6c7:	89 15 84 09 00 00    	mov    %edx,0x984
      return (void*)(p + 1);
 6cd:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6d0:	83 c4 1c             	add    $0x1c,%esp
 6d3:	5b                   	pop    %ebx
 6d4:	5e                   	pop    %esi
 6d5:	5f                   	pop    %edi
 6d6:	5d                   	pop    %ebp
 6d7:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 6d8:	8b 08                	mov    (%eax),%ecx
 6da:	89 0a                	mov    %ecx,(%edx)
 6dc:	eb e9                	jmp    6c7 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6de:	c7 05 84 09 00 00 88 	movl   $0x988,0x984
 6e5:	09 00 00 
    base.s.size = 0;
 6e8:	ba 88 09 00 00       	mov    $0x988,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 6ed:	c7 05 88 09 00 00 88 	movl   $0x988,0x988
 6f4:	09 00 00 
    base.s.size = 0;
 6f7:	c7 05 8c 09 00 00 00 	movl   $0x0,0x98c
 6fe:	00 00 00 
 701:	e9 46 ff ff ff       	jmp    64c <malloc+0x2c>
