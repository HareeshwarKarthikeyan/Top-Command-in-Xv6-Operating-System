
_top:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
    *(buffer) = buf;
    return buf[0];
}

int main(int argc, char *argv[])
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	83 ec 20             	sub    $0x20,%esp
   a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    //clear screen
    printf(1, "\033[2J\033[1;1H\n");
  10:	c7 44 24 04 b6 07 00 	movl   $0x7b6,0x4(%esp)
  17:	00 
  18:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1f:	e8 2c 04 00 00       	call   450 <printf>
    gettop();
  24:	e8 79 03 00 00       	call   3a2 <gettop>

    char *c;
    *c = getc(1, &c);
  29:	8d 44 24 1c          	lea    0x1c(%esp),%eax
  2d:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
  31:	e8 2a 00 00 00       	call   60 <getc.constprop.0>
  36:	88 03                	mov    %al,(%ebx)
    while (*c != 'q' && *c != 'Q')
  38:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  3c:	0f b6 00             	movzbl (%eax),%eax
  3f:	83 e0 df             	and    $0xffffffdf,%eax
  42:	3c 51                	cmp    $0x51,%al
  44:	75 ca                	jne    10 <main+0x10>
        //clear screen
        printf(1, "\033[2J\033[1;1H\n");
        gettop();
        *c = getc(1, &c);
    }
    printf(1, "\033[2J\033[1;1H\n");
  46:	c7 44 24 04 b6 07 00 	movl   $0x7b6,0x4(%esp)
  4d:	00 
  4e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  55:	e8 f6 03 00 00       	call   450 <printf>
    exit();
  5a:	e8 93 02 00 00       	call   2f2 <exit>
  5f:	90                   	nop

00000060 <getc.constprop.0>:
#include "types.h"
#include "user.h"
#include "stat.h"

static char
getc(int fd, char **buffer)
  60:	55                   	push   %ebp
  61:	89 e5                	mov    %esp,%ebp
  63:	57                   	push   %edi
  64:	89 c7                	mov    %eax,%edi
  66:	56                   	push   %esi
{
    int i = 0;
  67:	31 f6                	xor    %esi,%esi
#include "types.h"
#include "user.h"
#include "stat.h"

static char
getc(int fd, char **buffer)
  69:	53                   	push   %ebx
  6a:	81 ec 1c 01 00 00    	sub    $0x11c,%esp
  70:	8d 9d e8 fe ff ff    	lea    -0x118(%ebp),%ebx
  76:	eb 14                	jmp    8c <getc.constprop.0+0x2c>
{
    int i = 0;
    char buf[256]; // read input into buffer
    while (read(fd, &buf[i], 1))
    {
        if ((buf[i] == '\n' || buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\r' || buf[i] == '\v' || buf[i] == '\f'))
  78:	0f b6 03             	movzbl (%ebx),%eax
  7b:	3c 20                	cmp    $0x20,%al
  7d:	74 29                	je     a8 <getc.constprop.0+0x48>
  7f:	83 e8 09             	sub    $0x9,%eax
  82:	83 c3 01             	add    $0x1,%ebx
  85:	3c 04                	cmp    $0x4,%al
  87:	76 1f                	jbe    a8 <getc.constprop.0+0x48>
            break;
        else
            i++;
  89:	83 c6 01             	add    $0x1,%esi
static char
getc(int fd, char **buffer)
{
    int i = 0;
    char buf[256]; // read input into buffer
    while (read(fd, &buf[i], 1))
  8c:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  93:	00 
  94:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  98:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  9f:	e8 66 02 00 00       	call   30a <read>
  a4:	85 c0                	test   %eax,%eax
  a6:	75 d0                	jne    78 <getc.constprop.0+0x18>
            break;
        else
            i++;
    }
    buf[i] = '\0';
    *(buffer) = buf;
  a8:	8d 85 e8 fe ff ff    	lea    -0x118(%ebp),%eax
        if ((buf[i] == '\n' || buf[i] == ' ' || buf[i] == '\t' || buf[i] == '\r' || buf[i] == '\v' || buf[i] == '\f'))
            break;
        else
            i++;
    }
    buf[i] = '\0';
  ae:	c6 84 35 e8 fe ff ff 	movb   $0x0,-0x118(%ebp,%esi,1)
  b5:	00 
    *(buffer) = buf;
  b6:	89 07                	mov    %eax,(%edi)
    return buf[0];
  b8:	0f b6 85 e8 fe ff ff 	movzbl -0x118(%ebp),%eax
}
  bf:	81 c4 1c 01 00 00    	add    $0x11c,%esp
  c5:	5b                   	pop    %ebx
  c6:	5e                   	pop    %esi
  c7:	5f                   	pop    %edi
  c8:	5d                   	pop    %ebp
  c9:	c3                   	ret    
  ca:	66 90                	xchg   %ax,%ax
  cc:	66 90                	xchg   %ax,%ax
  ce:	66 90                	xchg   %ax,%ax

000000d0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d0:	55                   	push   %ebp
  d1:	89 e5                	mov    %esp,%ebp
  d3:	8b 45 08             	mov    0x8(%ebp),%eax
  d6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  d9:	53                   	push   %ebx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  da:	89 c2                	mov    %eax,%edx
  dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  e0:	83 c1 01             	add    $0x1,%ecx
  e3:	0f b6 59 ff          	movzbl -0x1(%ecx),%ebx
  e7:	83 c2 01             	add    $0x1,%edx
  ea:	84 db                	test   %bl,%bl
  ec:	88 5a ff             	mov    %bl,-0x1(%edx)
  ef:	75 ef                	jne    e0 <strcpy+0x10>
    ;
  return os;
}
  f1:	5b                   	pop    %ebx
  f2:	5d                   	pop    %ebp
  f3:	c3                   	ret    
  f4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  fa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

00000100 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 100:	55                   	push   %ebp
 101:	89 e5                	mov    %esp,%ebp
 103:	8b 55 08             	mov    0x8(%ebp),%edx
 106:	53                   	push   %ebx
 107:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
 10a:	0f b6 02             	movzbl (%edx),%eax
 10d:	84 c0                	test   %al,%al
 10f:	74 2d                	je     13e <strcmp+0x3e>
 111:	0f b6 19             	movzbl (%ecx),%ebx
 114:	38 d8                	cmp    %bl,%al
 116:	74 0e                	je     126 <strcmp+0x26>
 118:	eb 2b                	jmp    145 <strcmp+0x45>
 11a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 120:	38 c8                	cmp    %cl,%al
 122:	75 15                	jne    139 <strcmp+0x39>
    p++, q++;
 124:	89 d9                	mov    %ebx,%ecx
 126:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 129:	0f b6 02             	movzbl (%edx),%eax
    p++, q++;
 12c:	8d 59 01             	lea    0x1(%ecx),%ebx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 12f:	0f b6 49 01          	movzbl 0x1(%ecx),%ecx
 133:	84 c0                	test   %al,%al
 135:	75 e9                	jne    120 <strcmp+0x20>
 137:	31 c0                	xor    %eax,%eax
    p++, q++;
  return (uchar)*p - (uchar)*q;
 139:	29 c8                	sub    %ecx,%eax
}
 13b:	5b                   	pop    %ebx
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    
 13e:	0f b6 09             	movzbl (%ecx),%ecx
}

int
strcmp(const char *p, const char *q)
{
  while(*p && *p == *q)
 141:	31 c0                	xor    %eax,%eax
 143:	eb f4                	jmp    139 <strcmp+0x39>
 145:	0f b6 cb             	movzbl %bl,%ecx
 148:	eb ef                	jmp    139 <strcmp+0x39>
 14a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000150 <strlen>:
  return (uchar)*p - (uchar)*q;
}

uint
strlen(const char *s)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 156:	80 39 00             	cmpb   $0x0,(%ecx)
 159:	74 12                	je     16d <strlen+0x1d>
 15b:	31 d2                	xor    %edx,%edx
 15d:	8d 76 00             	lea    0x0(%esi),%esi
 160:	83 c2 01             	add    $0x1,%edx
 163:	80 3c 11 00          	cmpb   $0x0,(%ecx,%edx,1)
 167:	89 d0                	mov    %edx,%eax
 169:	75 f5                	jne    160 <strlen+0x10>
    ;
  return n;
}
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
uint
strlen(const char *s)
{
  int n;

  for(n = 0; s[n]; n++)
 16d:	31 c0                	xor    %eax,%eax
    ;
  return n;
}
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    
 171:	eb 0d                	jmp    180 <memset>
 173:	90                   	nop
 174:	90                   	nop
 175:	90                   	nop
 176:	90                   	nop
 177:	90                   	nop
 178:	90                   	nop
 179:	90                   	nop
 17a:	90                   	nop
 17b:	90                   	nop
 17c:	90                   	nop
 17d:	90                   	nop
 17e:	90                   	nop
 17f:	90                   	nop

00000180 <memset>:

void*
memset(void *dst, int c, uint n)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 55 08             	mov    0x8(%ebp),%edx
 186:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 187:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18a:	8b 45 0c             	mov    0xc(%ebp),%eax
 18d:	89 d7                	mov    %edx,%edi
 18f:	fc                   	cld    
 190:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 192:	89 d0                	mov    %edx,%eax
 194:	5f                   	pop    %edi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    
 197:	89 f6                	mov    %esi,%esi
 199:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001a0 <strchr>:

char*
strchr(const char *s, char c)
{
 1a0:	55                   	push   %ebp
 1a1:	89 e5                	mov    %esp,%ebp
 1a3:	8b 45 08             	mov    0x8(%ebp),%eax
 1a6:	53                   	push   %ebx
 1a7:	8b 55 0c             	mov    0xc(%ebp),%edx
  for(; *s; s++)
 1aa:	0f b6 18             	movzbl (%eax),%ebx
 1ad:	84 db                	test   %bl,%bl
 1af:	74 1d                	je     1ce <strchr+0x2e>
    if(*s == c)
 1b1:	38 d3                	cmp    %dl,%bl
 1b3:	89 d1                	mov    %edx,%ecx
 1b5:	75 0d                	jne    1c4 <strchr+0x24>
 1b7:	eb 17                	jmp    1d0 <strchr+0x30>
 1b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0c                	je     1d0 <strchr+0x30>
}

char*
strchr(const char *s, char c)
{
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	0f b6 10             	movzbl (%eax),%edx
 1ca:	84 d2                	test   %dl,%dl
 1cc:	75 f2                	jne    1c0 <strchr+0x20>
    if(*s == c)
      return (char*)s;
  return 0;
 1ce:	31 c0                	xor    %eax,%eax
}
 1d0:	5b                   	pop    %ebx
 1d1:	5d                   	pop    %ebp
 1d2:	c3                   	ret    
 1d3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 1d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

000001e0 <gets>:

char*
gets(char *buf, int max)
{
 1e0:	55                   	push   %ebp
 1e1:	89 e5                	mov    %esp,%ebp
 1e3:	57                   	push   %edi
 1e4:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e5:	31 f6                	xor    %esi,%esi
  return 0;
}

char*
gets(char *buf, int max)
{
 1e7:	53                   	push   %ebx
 1e8:	83 ec 2c             	sub    $0x2c,%esp
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
 1eb:	8d 7d e7             	lea    -0x19(%ebp),%edi
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ee:	eb 31                	jmp    221 <gets+0x41>
    cc = read(0, &c, 1);
 1f0:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 1f7:	00 
 1f8:	89 7c 24 04          	mov    %edi,0x4(%esp)
 1fc:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 203:	e8 02 01 00 00       	call   30a <read>
    if(cc < 1)
 208:	85 c0                	test   %eax,%eax
 20a:	7e 1d                	jle    229 <gets+0x49>
      break;
    buf[i++] = c;
 20c:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 210:	89 de                	mov    %ebx,%esi
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 212:	8b 55 08             	mov    0x8(%ebp),%edx
    if(c == '\n' || c == '\r')
 215:	3c 0d                	cmp    $0xd,%al

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
 217:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
 21b:	74 0c                	je     229 <gets+0x49>
 21d:	3c 0a                	cmp    $0xa,%al
 21f:	74 08                	je     229 <gets+0x49>
gets(char *buf, int max)
{
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 221:	8d 5e 01             	lea    0x1(%esi),%ebx
 224:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 227:	7c c7                	jl     1f0 <gets+0x10>
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
      break;
  }
  buf[i] = '\0';
 229:	8b 45 08             	mov    0x8(%ebp),%eax
 22c:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
 230:	83 c4 2c             	add    $0x2c,%esp
 233:	5b                   	pop    %ebx
 234:	5e                   	pop    %esi
 235:	5f                   	pop    %edi
 236:	5d                   	pop    %ebp
 237:	c3                   	ret    
 238:	90                   	nop
 239:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000240 <stat>:

int
stat(const char *n, struct stat *st)
{
 240:	55                   	push   %ebp
 241:	89 e5                	mov    %esp,%ebp
 243:	56                   	push   %esi
 244:	53                   	push   %ebx
 245:	83 ec 10             	sub    $0x10,%esp
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 248:	8b 45 08             	mov    0x8(%ebp),%eax
 24b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
 252:	00 
 253:	89 04 24             	mov    %eax,(%esp)
 256:	e8 d7 00 00 00       	call   332 <open>
  if(fd < 0)
 25b:	85 c0                	test   %eax,%eax
stat(const char *n, struct stat *st)
{
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25d:	89 c3                	mov    %eax,%ebx
  if(fd < 0)
 25f:	78 27                	js     288 <stat+0x48>
    return -1;
  r = fstat(fd, st);
 261:	8b 45 0c             	mov    0xc(%ebp),%eax
 264:	89 1c 24             	mov    %ebx,(%esp)
 267:	89 44 24 04          	mov    %eax,0x4(%esp)
 26b:	e8 da 00 00 00       	call   34a <fstat>
  close(fd);
 270:	89 1c 24             	mov    %ebx,(%esp)
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
  r = fstat(fd, st);
 273:	89 c6                	mov    %eax,%esi
  close(fd);
 275:	e8 a0 00 00 00       	call   31a <close>
  return r;
 27a:	89 f0                	mov    %esi,%eax
}
 27c:	83 c4 10             	add    $0x10,%esp
 27f:	5b                   	pop    %ebx
 280:	5e                   	pop    %esi
 281:	5d                   	pop    %ebp
 282:	c3                   	ret    
 283:	90                   	nop
 284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  int r;

  fd = open(n, O_RDONLY);
  if(fd < 0)
    return -1;
 288:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
 28d:	eb ed                	jmp    27c <stat+0x3c>
 28f:	90                   	nop

00000290 <atoi>:
  return r;
}

int
atoi(const char *s)
{
 290:	55                   	push   %ebp
 291:	89 e5                	mov    %esp,%ebp
 293:	8b 4d 08             	mov    0x8(%ebp),%ecx
 296:	53                   	push   %ebx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 297:	0f be 11             	movsbl (%ecx),%edx
 29a:	8d 42 d0             	lea    -0x30(%edx),%eax
 29d:	3c 09                	cmp    $0x9,%al
int
atoi(const char *s)
{
  int n;

  n = 0;
 29f:	b8 00 00 00 00       	mov    $0x0,%eax
  while('0' <= *s && *s <= '9')
 2a4:	77 17                	ja     2bd <atoi+0x2d>
 2a6:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
 2a8:	83 c1 01             	add    $0x1,%ecx
 2ab:	8d 04 80             	lea    (%eax,%eax,4),%eax
 2ae:	8d 44 42 d0          	lea    -0x30(%edx,%eax,2),%eax
atoi(const char *s)
{
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2b2:	0f be 11             	movsbl (%ecx),%edx
 2b5:	8d 5a d0             	lea    -0x30(%edx),%ebx
 2b8:	80 fb 09             	cmp    $0x9,%bl
 2bb:	76 eb                	jbe    2a8 <atoi+0x18>
    n = n*10 + *s++ - '0';
  return n;
}
 2bd:	5b                   	pop    %ebx
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	55                   	push   %ebp
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2c1:	31 d2                	xor    %edx,%edx
  return n;
}

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c3:	89 e5                	mov    %esp,%ebp
 2c5:	56                   	push   %esi
 2c6:	8b 45 08             	mov    0x8(%ebp),%eax
 2c9:	53                   	push   %ebx
 2ca:	8b 5d 10             	mov    0x10(%ebp),%ebx
 2cd:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2d0:	85 db                	test   %ebx,%ebx
 2d2:	7e 12                	jle    2e6 <memmove+0x26>
 2d4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    *dst++ = *src++;
 2d8:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
 2dc:	88 0c 10             	mov    %cl,(%eax,%edx,1)
 2df:	83 c2 01             	add    $0x1,%edx
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
 2e2:	39 da                	cmp    %ebx,%edx
 2e4:	75 f2                	jne    2d8 <memmove+0x18>
    *dst++ = *src++;
  return vdst;
}
 2e6:	5b                   	pop    %ebx
 2e7:	5e                   	pop    %esi
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2ea:	b8 01 00 00 00       	mov    $0x1,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exit>:
SYSCALL(exit)
 2f2:	b8 02 00 00 00       	mov    $0x2,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <wait>:
SYSCALL(wait)
 2fa:	b8 03 00 00 00       	mov    $0x3,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <pipe>:
SYSCALL(pipe)
 302:	b8 04 00 00 00       	mov    $0x4,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <read>:
SYSCALL(read)
 30a:	b8 05 00 00 00       	mov    $0x5,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <write>:
SYSCALL(write)
 312:	b8 10 00 00 00       	mov    $0x10,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <close>:
SYSCALL(close)
 31a:	b8 15 00 00 00       	mov    $0x15,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <kill>:
SYSCALL(kill)
 322:	b8 06 00 00 00       	mov    $0x6,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <exec>:
SYSCALL(exec)
 32a:	b8 07 00 00 00       	mov    $0x7,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <open>:
SYSCALL(open)
 332:	b8 0f 00 00 00       	mov    $0xf,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <mknod>:
SYSCALL(mknod)
 33a:	b8 11 00 00 00       	mov    $0x11,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <unlink>:
SYSCALL(unlink)
 342:	b8 12 00 00 00       	mov    $0x12,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <fstat>:
SYSCALL(fstat)
 34a:	b8 08 00 00 00       	mov    $0x8,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <link>:
SYSCALL(link)
 352:	b8 13 00 00 00       	mov    $0x13,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <mkdir>:
SYSCALL(mkdir)
 35a:	b8 14 00 00 00       	mov    $0x14,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <chdir>:
SYSCALL(chdir)
 362:	b8 09 00 00 00       	mov    $0x9,%eax
 367:	cd 40                	int    $0x40
 369:	c3                   	ret    

0000036a <dup>:
SYSCALL(dup)
 36a:	b8 0a 00 00 00       	mov    $0xa,%eax
 36f:	cd 40                	int    $0x40
 371:	c3                   	ret    

00000372 <getpid>:
SYSCALL(getpid)
 372:	b8 0b 00 00 00       	mov    $0xb,%eax
 377:	cd 40                	int    $0x40
 379:	c3                   	ret    

0000037a <sbrk>:
SYSCALL(sbrk)
 37a:	b8 0c 00 00 00       	mov    $0xc,%eax
 37f:	cd 40                	int    $0x40
 381:	c3                   	ret    

00000382 <sleep>:
SYSCALL(sleep)
 382:	b8 0d 00 00 00       	mov    $0xd,%eax
 387:	cd 40                	int    $0x40
 389:	c3                   	ret    

0000038a <uptime>:
SYSCALL(uptime)
 38a:	b8 0e 00 00 00       	mov    $0xe,%eax
 38f:	cd 40                	int    $0x40
 391:	c3                   	ret    

00000392 <hello>:
SYSCALL(hello)
 392:	b8 16 00 00 00       	mov    $0x16,%eax
 397:	cd 40                	int    $0x40
 399:	c3                   	ret    

0000039a <halt>:
SYSCALL(halt)
 39a:	b8 17 00 00 00       	mov    $0x17,%eax
 39f:	cd 40                	int    $0x40
 3a1:	c3                   	ret    

000003a2 <gettop>:
SYSCALL(gettop)
 3a2:	b8 18 00 00 00       	mov    $0x18,%eax
 3a7:	cd 40                	int    $0x40
 3a9:	c3                   	ret    
 3aa:	66 90                	xchg   %ax,%ax
 3ac:	66 90                	xchg   %ax,%ax
 3ae:	66 90                	xchg   %ax,%ax

000003b0 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
 3b0:	55                   	push   %ebp
 3b1:	89 e5                	mov    %esp,%ebp
 3b3:	57                   	push   %edi
 3b4:	56                   	push   %esi
 3b5:	89 c6                	mov    %eax,%esi
 3b7:	53                   	push   %ebx
 3b8:	83 ec 4c             	sub    $0x4c,%esp
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bb:	8b 5d 08             	mov    0x8(%ebp),%ebx
 3be:	85 db                	test   %ebx,%ebx
 3c0:	74 09                	je     3cb <printint+0x1b>
 3c2:	89 d0                	mov    %edx,%eax
 3c4:	c1 e8 1f             	shr    $0x1f,%eax
 3c7:	84 c0                	test   %al,%al
 3c9:	75 75                	jne    440 <printint+0x90>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3cb:	89 d0                	mov    %edx,%eax
  static char digits[] = "0123456789ABCDEF";
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
 3cd:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
 3d4:	89 75 c0             	mov    %esi,-0x40(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3d7:	31 ff                	xor    %edi,%edi
 3d9:	89 ce                	mov    %ecx,%esi
 3db:	8d 5d d7             	lea    -0x29(%ebp),%ebx
 3de:	eb 02                	jmp    3e2 <printint+0x32>
  do{
    buf[i++] = digits[x % base];
 3e0:	89 cf                	mov    %ecx,%edi
 3e2:	31 d2                	xor    %edx,%edx
 3e4:	f7 f6                	div    %esi
 3e6:	8d 4f 01             	lea    0x1(%edi),%ecx
 3e9:	0f b6 92 c9 07 00 00 	movzbl 0x7c9(%edx),%edx
  }while((x /= base) != 0);
 3f0:	85 c0                	test   %eax,%eax
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3f2:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
 3f5:	75 e9                	jne    3e0 <printint+0x30>
  if(neg)
 3f7:	8b 55 c4             	mov    -0x3c(%ebp),%edx
    x = xx;
  }

  i = 0;
  do{
    buf[i++] = digits[x % base];
 3fa:	89 c8                	mov    %ecx,%eax
 3fc:	8b 75 c0             	mov    -0x40(%ebp),%esi
  }while((x /= base) != 0);
  if(neg)
 3ff:	85 d2                	test   %edx,%edx
 401:	74 08                	je     40b <printint+0x5b>
    buf[i++] = '-';
 403:	8d 4f 02             	lea    0x2(%edi),%ecx
 406:	c6 44 05 d8 2d       	movb   $0x2d,-0x28(%ebp,%eax,1)

  while(--i >= 0)
 40b:	8d 79 ff             	lea    -0x1(%ecx),%edi
 40e:	66 90                	xchg   %ax,%ax
 410:	0f b6 44 3d d8       	movzbl -0x28(%ebp,%edi,1),%eax
 415:	83 ef 01             	sub    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 418:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 41f:	00 
 420:	89 5c 24 04          	mov    %ebx,0x4(%esp)
 424:	89 34 24             	mov    %esi,(%esp)
 427:	88 45 d7             	mov    %al,-0x29(%ebp)
 42a:	e8 e3 fe ff ff       	call   312 <write>
    buf[i++] = digits[x % base];
  }while((x /= base) != 0);
  if(neg)
    buf[i++] = '-';

  while(--i >= 0)
 42f:	83 ff ff             	cmp    $0xffffffff,%edi
 432:	75 dc                	jne    410 <printint+0x60>
    putc(fd, buf[i]);
}
 434:	83 c4 4c             	add    $0x4c,%esp
 437:	5b                   	pop    %ebx
 438:	5e                   	pop    %esi
 439:	5f                   	pop    %edi
 43a:	5d                   	pop    %ebp
 43b:	c3                   	ret    
 43c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
 440:	89 d0                	mov    %edx,%eax
 442:	f7 d8                	neg    %eax
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
 444:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
 44b:	eb 87                	jmp    3d4 <printint+0x24>
 44d:	8d 76 00             	lea    0x0(%esi),%esi

00000450 <printf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 450:	55                   	push   %ebp
 451:	89 e5                	mov    %esp,%ebp
 453:	57                   	push   %edi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
 454:	31 ff                	xor    %edi,%edi
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 456:	56                   	push   %esi
 457:	53                   	push   %ebx
 458:	83 ec 3c             	sub    $0x3c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 45b:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 45e:	8d 45 10             	lea    0x10(%ebp),%eax
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 461:	8b 75 08             	mov    0x8(%ebp),%esi
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 464:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  for(i = 0; fmt[i]; i++){
 467:	0f b6 13             	movzbl (%ebx),%edx
 46a:	83 c3 01             	add    $0x1,%ebx
 46d:	84 d2                	test   %dl,%dl
 46f:	75 39                	jne    4aa <printf+0x5a>
 471:	e9 c2 00 00 00       	jmp    538 <printf+0xe8>
 476:	66 90                	xchg   %ax,%ax
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
 478:	83 fa 25             	cmp    $0x25,%edx
 47b:	0f 84 bf 00 00 00    	je     540 <printf+0xf0>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 481:	8d 45 e2             	lea    -0x1e(%ebp),%eax
 484:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 48b:	00 
 48c:	89 44 24 04          	mov    %eax,0x4(%esp)
 490:	89 34 24             	mov    %esi,(%esp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 493:	88 55 e2             	mov    %dl,-0x1e(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 496:	e8 77 fe ff ff       	call   312 <write>
 49b:	83 c3 01             	add    $0x1,%ebx
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 49e:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 4a2:	84 d2                	test   %dl,%dl
 4a4:	0f 84 8e 00 00 00    	je     538 <printf+0xe8>
    c = fmt[i] & 0xff;
    if(state == 0){
 4aa:	85 ff                	test   %edi,%edi
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
 4ac:	0f be c2             	movsbl %dl,%eax
    if(state == 0){
 4af:	74 c7                	je     478 <printf+0x28>
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
 4b1:	83 ff 25             	cmp    $0x25,%edi
 4b4:	75 e5                	jne    49b <printf+0x4b>
      if(c == 'd'){
 4b6:	83 fa 64             	cmp    $0x64,%edx
 4b9:	0f 84 31 01 00 00    	je     5f0 <printf+0x1a0>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4bf:	25 f7 00 00 00       	and    $0xf7,%eax
 4c4:	83 f8 70             	cmp    $0x70,%eax
 4c7:	0f 84 83 00 00 00    	je     550 <printf+0x100>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4cd:	83 fa 73             	cmp    $0x73,%edx
 4d0:	0f 84 a2 00 00 00    	je     578 <printf+0x128>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4d6:	83 fa 63             	cmp    $0x63,%edx
 4d9:	0f 84 35 01 00 00    	je     614 <printf+0x1c4>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4df:	83 fa 25             	cmp    $0x25,%edx
 4e2:	0f 84 e0 00 00 00    	je     5c8 <printf+0x178>
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4e8:	8d 45 e6             	lea    -0x1a(%ebp),%eax
 4eb:	83 c3 01             	add    $0x1,%ebx
 4ee:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 4f5:	00 
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4f6:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 4f8:	89 44 24 04          	mov    %eax,0x4(%esp)
 4fc:	89 34 24             	mov    %esi,(%esp)
 4ff:	89 55 d0             	mov    %edx,-0x30(%ebp)
 502:	c6 45 e6 25          	movb   $0x25,-0x1a(%ebp)
 506:	e8 07 fe ff ff       	call   312 <write>
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 50b:	8b 55 d0             	mov    -0x30(%ebp),%edx
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 50e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 511:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 518:	00 
 519:	89 44 24 04          	mov    %eax,0x4(%esp)
 51d:	89 34 24             	mov    %esi,(%esp)
      } else if(c == '%'){
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
 520:	88 55 e7             	mov    %dl,-0x19(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 523:	e8 ea fd ff ff       	call   312 <write>
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
 528:	0f b6 53 ff          	movzbl -0x1(%ebx),%edx
 52c:	84 d2                	test   %dl,%dl
 52e:	0f 85 76 ff ff ff    	jne    4aa <printf+0x5a>
 534:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        putc(fd, c);
      }
      state = 0;
    }
  }
}
 538:	83 c4 3c             	add    $0x3c,%esp
 53b:	5b                   	pop    %ebx
 53c:	5e                   	pop    %esi
 53d:	5f                   	pop    %edi
 53e:	5d                   	pop    %ebp
 53f:	c3                   	ret    
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
 540:	bf 25 00 00 00       	mov    $0x25,%edi
 545:	e9 51 ff ff ff       	jmp    49b <printf+0x4b>
 54a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 550:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 553:	b9 10 00 00 00       	mov    $0x10,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 558:	31 ff                	xor    %edi,%edi
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
 55a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 561:	8b 10                	mov    (%eax),%edx
 563:	89 f0                	mov    %esi,%eax
 565:	e8 46 fe ff ff       	call   3b0 <printint>
        ap++;
 56a:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 56e:	e9 28 ff ff ff       	jmp    49b <printf+0x4b>
 573:	90                   	nop
 574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      } else if(c == 's'){
        s = (char*)*ap;
 578:	8b 45 d4             	mov    -0x2c(%ebp),%eax
        ap++;
 57b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
        ap++;
      } else if(c == 'x' || c == 'p'){
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
        s = (char*)*ap;
 57f:	8b 38                	mov    (%eax),%edi
        ap++;
        if(s == 0)
          s = "(null)";
 581:	b8 c2 07 00 00       	mov    $0x7c2,%eax
 586:	85 ff                	test   %edi,%edi
 588:	0f 44 f8             	cmove  %eax,%edi
        while(*s != 0){
 58b:	0f b6 07             	movzbl (%edi),%eax
 58e:	84 c0                	test   %al,%al
 590:	74 2a                	je     5bc <printf+0x16c>
 592:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 598:	88 45 e3             	mov    %al,-0x1d(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 59b:	8d 45 e3             	lea    -0x1d(%ebp),%eax
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
 59e:	83 c7 01             	add    $0x1,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5a1:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5a8:	00 
 5a9:	89 44 24 04          	mov    %eax,0x4(%esp)
 5ad:	89 34 24             	mov    %esi,(%esp)
 5b0:	e8 5d fd ff ff       	call   312 <write>
      } else if(c == 's'){
        s = (char*)*ap;
        ap++;
        if(s == 0)
          s = "(null)";
        while(*s != 0){
 5b5:	0f b6 07             	movzbl (%edi),%eax
 5b8:	84 c0                	test   %al,%al
 5ba:	75 dc                	jne    598 <printf+0x148>
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5bc:	31 ff                	xor    %edi,%edi
 5be:	e9 d8 fe ff ff       	jmp    49b <printf+0x4b>
 5c3:	90                   	nop
 5c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5c8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5cb:	31 ff                	xor    %edi,%edi
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 5cd:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 5d4:	00 
 5d5:	89 44 24 04          	mov    %eax,0x4(%esp)
 5d9:	89 34 24             	mov    %esi,(%esp)
 5dc:	c6 45 e5 25          	movb   $0x25,-0x1b(%ebp)
 5e0:	e8 2d fd ff ff       	call   312 <write>
 5e5:	e9 b1 fe ff ff       	jmp    49b <printf+0x4b>
 5ea:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 5f8:	66 31 ff             	xor    %di,%di
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
      if(c == 'd'){
        printint(fd, *ap, 10, 1);
 5fb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
 602:	8b 10                	mov    (%eax),%edx
 604:	89 f0                	mov    %esi,%eax
 606:	e8 a5 fd ff ff       	call   3b0 <printint>
        ap++;
 60b:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 60f:	e9 87 fe ff ff       	jmp    49b <printf+0x4b>
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 614:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 617:	31 ff                	xor    %edi,%edi
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 619:	8b 00                	mov    (%eax),%eax
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 61b:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
 622:	00 
 623:	89 34 24             	mov    %esi,(%esp)
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
 626:	88 45 e4             	mov    %al,-0x1c(%ebp)
#include "user.h"

static void
putc(int fd, char c)
{
  write(fd, &c, 1);
 629:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 62c:	89 44 24 04          	mov    %eax,0x4(%esp)
 630:	e8 dd fc ff ff       	call   312 <write>
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
        putc(fd, *ap);
        ap++;
 635:	83 45 d4 04          	addl   $0x4,-0x2c(%ebp)
 639:	e9 5d fe ff ff       	jmp    49b <printf+0x4b>
 63e:	66 90                	xchg   %ax,%ax

00000640 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 640:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 641:	a1 70 0a 00 00       	mov    0xa70,%eax
static Header base;
static Header *freep;

void
free(void *ap)
{
 646:	89 e5                	mov    %esp,%ebp
 648:	57                   	push   %edi
 649:	56                   	push   %esi
 64a:	53                   	push   %ebx
 64b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64e:	8b 08                	mov    (%eax),%ecx
void
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
 650:	8d 53 f8             	lea    -0x8(%ebx),%edx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 653:	39 d0                	cmp    %edx,%eax
 655:	72 11                	jb     668 <free+0x28>
 657:	90                   	nop
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 658:	39 c8                	cmp    %ecx,%eax
 65a:	72 04                	jb     660 <free+0x20>
 65c:	39 ca                	cmp    %ecx,%edx
 65e:	72 10                	jb     670 <free+0x30>
 660:	89 c8                	mov    %ecx,%eax
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 662:	39 d0                	cmp    %edx,%eax
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 664:	8b 08                	mov    (%eax),%ecx
free(void *ap)
{
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 666:	73 f0                	jae    658 <free+0x18>
 668:	39 ca                	cmp    %ecx,%edx
 66a:	72 04                	jb     670 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 66c:	39 c8                	cmp    %ecx,%eax
 66e:	72 f0                	jb     660 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 670:	8b 73 fc             	mov    -0x4(%ebx),%esi
 673:	8d 3c f2             	lea    (%edx,%esi,8),%edi
 676:	39 cf                	cmp    %ecx,%edi
 678:	74 1e                	je     698 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 67a:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  if(p + p->s.size == bp){
 67d:	8b 48 04             	mov    0x4(%eax),%ecx
 680:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 683:	39 f2                	cmp    %esi,%edx
 685:	74 28                	je     6af <free+0x6f>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 687:	89 10                	mov    %edx,(%eax)
  freep = p;
 689:	a3 70 0a 00 00       	mov    %eax,0xa70
}
 68e:	5b                   	pop    %ebx
 68f:	5e                   	pop    %esi
 690:	5f                   	pop    %edi
 691:	5d                   	pop    %ebp
 692:	c3                   	ret    
 693:	90                   	nop
 694:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
 698:	03 71 04             	add    0x4(%ecx),%esi
 69b:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 69e:	8b 08                	mov    (%eax),%ecx
 6a0:	8b 09                	mov    (%ecx),%ecx
 6a2:	89 4b f8             	mov    %ecx,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 6a5:	8b 48 04             	mov    0x4(%eax),%ecx
 6a8:	8d 34 c8             	lea    (%eax,%ecx,8),%esi
 6ab:	39 f2                	cmp    %esi,%edx
 6ad:	75 d8                	jne    687 <free+0x47>
    p->s.size += bp->s.size;
 6af:	03 4b fc             	add    -0x4(%ebx),%ecx
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
  freep = p;
 6b2:	a3 70 0a 00 00       	mov    %eax,0xa70
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
 6b7:	89 48 04             	mov    %ecx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 6ba:	8b 53 f8             	mov    -0x8(%ebx),%edx
 6bd:	89 10                	mov    %edx,(%eax)
  } else
    p->s.ptr = bp;
  freep = p;
}
 6bf:	5b                   	pop    %ebx
 6c0:	5e                   	pop    %esi
 6c1:	5f                   	pop    %edi
 6c2:	5d                   	pop    %ebp
 6c3:	c3                   	ret    
 6c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
 6ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

000006d0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 6d0:	55                   	push   %ebp
 6d1:	89 e5                	mov    %esp,%ebp
 6d3:	57                   	push   %edi
 6d4:	56                   	push   %esi
 6d5:	53                   	push   %ebx
 6d6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6d9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
 6dc:	8b 1d 70 0a 00 00    	mov    0xa70,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6e2:	8d 48 07             	lea    0x7(%eax),%ecx
 6e5:	c1 e9 03             	shr    $0x3,%ecx
  if((prevp = freep) == 0){
 6e8:	85 db                	test   %ebx,%ebx
malloc(uint nbytes)
{
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ea:	8d 71 01             	lea    0x1(%ecx),%esi
  if((prevp = freep) == 0){
 6ed:	0f 84 9b 00 00 00    	je     78e <malloc+0xbe>
 6f3:	8b 13                	mov    (%ebx),%edx
 6f5:	8b 7a 04             	mov    0x4(%edx),%edi
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 6f8:	39 fe                	cmp    %edi,%esi
 6fa:	76 64                	jbe    760 <malloc+0x90>
 6fc:	8d 04 f5 00 00 00 00 	lea    0x0(,%esi,8),%eax
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 703:	bb 00 80 00 00       	mov    $0x8000,%ebx
 708:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 70b:	eb 0e                	jmp    71b <malloc+0x4b>
 70d:	8d 76 00             	lea    0x0(%esi),%esi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 710:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
 712:	8b 78 04             	mov    0x4(%eax),%edi
 715:	39 fe                	cmp    %edi,%esi
 717:	76 4f                	jbe    768 <malloc+0x98>
 719:	89 c2                	mov    %eax,%edx
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 71b:	3b 15 70 0a 00 00    	cmp    0xa70,%edx
 721:	75 ed                	jne    710 <malloc+0x40>
morecore(uint nu)
{
  char *p;
  Header *hp;

  if(nu < 4096)
 723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 726:	81 fe 00 10 00 00    	cmp    $0x1000,%esi
 72c:	bf 00 10 00 00       	mov    $0x1000,%edi
 731:	0f 43 fe             	cmovae %esi,%edi
 734:	0f 42 c3             	cmovb  %ebx,%eax
    nu = 4096;
  p = sbrk(nu * sizeof(Header));
 737:	89 04 24             	mov    %eax,(%esp)
 73a:	e8 3b fc ff ff       	call   37a <sbrk>
  if(p == (char*)-1)
 73f:	83 f8 ff             	cmp    $0xffffffff,%eax
 742:	74 18                	je     75c <malloc+0x8c>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 744:	89 78 04             	mov    %edi,0x4(%eax)
  free((void*)(hp + 1));
 747:	83 c0 08             	add    $0x8,%eax
 74a:	89 04 24             	mov    %eax,(%esp)
 74d:	e8 ee fe ff ff       	call   640 <free>
  return freep;
 752:	8b 15 70 0a 00 00    	mov    0xa70,%edx
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
 758:	85 d2                	test   %edx,%edx
 75a:	75 b4                	jne    710 <malloc+0x40>
        return 0;
 75c:	31 c0                	xor    %eax,%eax
 75e:	eb 20                	jmp    780 <malloc+0xb0>
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
 760:	89 d0                	mov    %edx,%eax
 762:	89 da                	mov    %ebx,%edx
 764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      if(p->s.size == nunits)
 768:	39 fe                	cmp    %edi,%esi
 76a:	74 1c                	je     788 <malloc+0xb8>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 76c:	29 f7                	sub    %esi,%edi
 76e:	89 78 04             	mov    %edi,0x4(%eax)
        p += p->s.size;
 771:	8d 04 f8             	lea    (%eax,%edi,8),%eax
        p->s.size = nunits;
 774:	89 70 04             	mov    %esi,0x4(%eax)
      }
      freep = prevp;
 777:	89 15 70 0a 00 00    	mov    %edx,0xa70
      return (void*)(p + 1);
 77d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 780:	83 c4 1c             	add    $0x1c,%esp
 783:	5b                   	pop    %ebx
 784:	5e                   	pop    %esi
 785:	5f                   	pop    %edi
 786:	5d                   	pop    %ebp
 787:	c3                   	ret    
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
        prevp->s.ptr = p->s.ptr;
 788:	8b 08                	mov    (%eax),%ecx
 78a:	89 0a                	mov    %ecx,(%edx)
 78c:	eb e9                	jmp    777 <malloc+0xa7>
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 78e:	c7 05 70 0a 00 00 74 	movl   $0xa74,0xa70
 795:	0a 00 00 
    base.s.size = 0;
 798:	ba 74 0a 00 00       	mov    $0xa74,%edx
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
  if((prevp = freep) == 0){
    base.s.ptr = freep = prevp = &base;
 79d:	c7 05 74 0a 00 00 74 	movl   $0xa74,0xa74
 7a4:	0a 00 00 
    base.s.size = 0;
 7a7:	c7 05 78 0a 00 00 00 	movl   $0x0,0xa78
 7ae:	00 00 00 
 7b1:	e9 46 ff ff ff       	jmp    6fc <malloc+0x2c>
