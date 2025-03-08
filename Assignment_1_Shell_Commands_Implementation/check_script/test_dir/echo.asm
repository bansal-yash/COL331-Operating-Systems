
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	57                   	push   %edi
   e:	56                   	push   %esi
   f:	53                   	push   %ebx
  10:	51                   	push   %ecx
  11:	83 ec 08             	sub    $0x8,%esp
  14:	8b 31                	mov    (%ecx),%esi
  16:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  for(i = 1; i < argc; i++)
  19:	b8 01 00 00 00       	mov    $0x1,%eax
  1e:	eb 1a                	jmp    3a <main+0x3a>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  20:	ba ce 05 00 00       	mov    $0x5ce,%edx
  25:	52                   	push   %edx
  26:	ff 34 87             	pushl  (%edi,%eax,4)
  29:	68 d0 05 00 00       	push   $0x5d0
  2e:	6a 01                	push   $0x1
  30:	e8 f0 02 00 00       	call   325 <printf>
  35:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  38:	89 d8                	mov    %ebx,%eax
  3a:	39 f0                	cmp    %esi,%eax
  3c:	7d 0e                	jge    4c <main+0x4c>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  3e:	8d 58 01             	lea    0x1(%eax),%ebx
  41:	39 f3                	cmp    %esi,%ebx
  43:	7d db                	jge    20 <main+0x20>
  45:	ba cc 05 00 00       	mov    $0x5cc,%edx
  4a:	eb d9                	jmp    25 <main+0x25>
  exit();
  4c:	e8 81 01 00 00       	call   1d2 <exit>

00000051 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  51:	55                   	push   %ebp
  52:	89 e5                	mov    %esp,%ebp
  54:	56                   	push   %esi
  55:	53                   	push   %ebx
  56:	8b 45 08             	mov    0x8(%ebp),%eax
  59:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  5c:	89 c2                	mov    %eax,%edx
  5e:	89 cb                	mov    %ecx,%ebx
  60:	41                   	inc    %ecx
  61:	89 d6                	mov    %edx,%esi
  63:	42                   	inc    %edx
  64:	8a 1b                	mov    (%ebx),%bl
  66:	88 1e                	mov    %bl,(%esi)
  68:	84 db                	test   %bl,%bl
  6a:	75 f2                	jne    5e <strcpy+0xd>
    ;
  return os;
}
  6c:	5b                   	pop    %ebx
  6d:	5e                   	pop    %esi
  6e:	5d                   	pop    %ebp
  6f:	c3                   	ret    

00000070 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  70:	55                   	push   %ebp
  71:	89 e5                	mov    %esp,%ebp
  73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  76:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  79:	eb 02                	jmp    7d <strcmp+0xd>
    p++, q++;
  7b:	41                   	inc    %ecx
  7c:	42                   	inc    %edx
  while(*p && *p == *q)
  7d:	8a 01                	mov    (%ecx),%al
  7f:	84 c0                	test   %al,%al
  81:	74 04                	je     87 <strcmp+0x17>
  83:	3a 02                	cmp    (%edx),%al
  85:	74 f4                	je     7b <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  87:	0f b6 c0             	movzbl %al,%eax
  8a:	0f b6 12             	movzbl (%edx),%edx
  8d:	29 d0                	sub    %edx,%eax
}
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strlen>:

uint
strlen(const char *s)
{
  91:	55                   	push   %ebp
  92:	89 e5                	mov    %esp,%ebp
  94:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  97:	b8 00 00 00 00       	mov    $0x0,%eax
  9c:	eb 01                	jmp    9f <strlen+0xe>
  9e:	40                   	inc    %eax
  9f:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  a3:	75 f9                	jne    9e <strlen+0xd>
    ;
  return n;
}
  a5:	5d                   	pop    %ebp
  a6:	c3                   	ret    

000000a7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  a7:	55                   	push   %ebp
  a8:	89 e5                	mov    %esp,%ebp
  aa:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  ab:	8b 7d 08             	mov    0x8(%ebp),%edi
  ae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  b4:	fc                   	cld    
  b5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  b7:	8b 45 08             	mov    0x8(%ebp),%eax
  ba:	8b 7d fc             	mov    -0x4(%ebp),%edi
  bd:	c9                   	leave  
  be:	c3                   	ret    

000000bf <strchr>:

char*
strchr(const char *s, char c)
{
  bf:	55                   	push   %ebp
  c0:	89 e5                	mov    %esp,%ebp
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  c8:	eb 01                	jmp    cb <strchr+0xc>
  ca:	40                   	inc    %eax
  cb:	8a 10                	mov    (%eax),%dl
  cd:	84 d2                	test   %dl,%dl
  cf:	74 06                	je     d7 <strchr+0x18>
    if(*s == c)
  d1:	38 ca                	cmp    %cl,%dl
  d3:	75 f5                	jne    ca <strchr+0xb>
  d5:	eb 05                	jmp    dc <strchr+0x1d>
      return (char*)s;
  return 0;
  d7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  dc:	5d                   	pop    %ebp
  dd:	c3                   	ret    

000000de <gets>:

char*
gets(char *buf, int max)
{
  de:	55                   	push   %ebp
  df:	89 e5                	mov    %esp,%ebp
  e1:	57                   	push   %edi
  e2:	56                   	push   %esi
  e3:	53                   	push   %ebx
  e4:	83 ec 1c             	sub    $0x1c,%esp
  e7:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  ea:	bb 00 00 00 00       	mov    $0x0,%ebx
  ef:	89 de                	mov    %ebx,%esi
  f1:	43                   	inc    %ebx
  f2:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  f5:	7d 2b                	jge    122 <gets+0x44>
    cc = read(0, &c, 1);
  f7:	83 ec 04             	sub    $0x4,%esp
  fa:	6a 01                	push   $0x1
  fc:	8d 45 e7             	lea    -0x19(%ebp),%eax
  ff:	50                   	push   %eax
 100:	6a 00                	push   $0x0
 102:	e8 e3 00 00 00       	call   1ea <read>
    if(cc < 1)
 107:	83 c4 10             	add    $0x10,%esp
 10a:	85 c0                	test   %eax,%eax
 10c:	7e 14                	jle    122 <gets+0x44>
      break;
    buf[i++] = c;
 10e:	8a 45 e7             	mov    -0x19(%ebp),%al
 111:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 114:	3c 0a                	cmp    $0xa,%al
 116:	74 08                	je     120 <gets+0x42>
 118:	3c 0d                	cmp    $0xd,%al
 11a:	75 d3                	jne    ef <gets+0x11>
    buf[i++] = c;
 11c:	89 de                	mov    %ebx,%esi
 11e:	eb 02                	jmp    122 <gets+0x44>
 120:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 122:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 126:	89 f8                	mov    %edi,%eax
 128:	8d 65 f4             	lea    -0xc(%ebp),%esp
 12b:	5b                   	pop    %ebx
 12c:	5e                   	pop    %esi
 12d:	5f                   	pop    %edi
 12e:	5d                   	pop    %ebp
 12f:	c3                   	ret    

00000130 <stat>:

int
stat(const char *n, struct stat *st)
{
 130:	55                   	push   %ebp
 131:	89 e5                	mov    %esp,%ebp
 133:	56                   	push   %esi
 134:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 135:	83 ec 08             	sub    $0x8,%esp
 138:	6a 00                	push   $0x0
 13a:	ff 75 08             	pushl  0x8(%ebp)
 13d:	e8 d0 00 00 00       	call   212 <open>
  if(fd < 0)
 142:	83 c4 10             	add    $0x10,%esp
 145:	85 c0                	test   %eax,%eax
 147:	78 24                	js     16d <stat+0x3d>
 149:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 14b:	83 ec 08             	sub    $0x8,%esp
 14e:	ff 75 0c             	pushl  0xc(%ebp)
 151:	50                   	push   %eax
 152:	e8 d3 00 00 00       	call   22a <fstat>
 157:	89 c6                	mov    %eax,%esi
  close(fd);
 159:	89 1c 24             	mov    %ebx,(%esp)
 15c:	e8 99 00 00 00       	call   1fa <close>
  return r;
 161:	83 c4 10             	add    $0x10,%esp
}
 164:	89 f0                	mov    %esi,%eax
 166:	8d 65 f8             	lea    -0x8(%ebp),%esp
 169:	5b                   	pop    %ebx
 16a:	5e                   	pop    %esi
 16b:	5d                   	pop    %ebp
 16c:	c3                   	ret    
    return -1;
 16d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 172:	eb f0                	jmp    164 <stat+0x34>

00000174 <atoi>:

int
atoi(const char *s)
{
 174:	55                   	push   %ebp
 175:	89 e5                	mov    %esp,%ebp
 177:	53                   	push   %ebx
 178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 17b:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 180:	eb 0e                	jmp    190 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 182:	8d 14 92             	lea    (%edx,%edx,4),%edx
 185:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 188:	41                   	inc    %ecx
 189:	0f be c0             	movsbl %al,%eax
 18c:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 190:	8a 01                	mov    (%ecx),%al
 192:	8d 58 d0             	lea    -0x30(%eax),%ebx
 195:	80 fb 09             	cmp    $0x9,%bl
 198:	76 e8                	jbe    182 <atoi+0xe>
  return n;
}
 19a:	89 d0                	mov    %edx,%eax
 19c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 19f:	c9                   	leave  
 1a0:	c3                   	ret    

000001a1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1a1:	55                   	push   %ebp
 1a2:	89 e5                	mov    %esp,%ebp
 1a4:	56                   	push   %esi
 1a5:	53                   	push   %ebx
 1a6:	8b 45 08             	mov    0x8(%ebp),%eax
 1a9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1ac:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1af:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1b1:	eb 0c                	jmp    1bf <memmove+0x1e>
    *dst++ = *src++;
 1b3:	8a 13                	mov    (%ebx),%dl
 1b5:	88 11                	mov    %dl,(%ecx)
 1b7:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1ba:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1bd:	89 f2                	mov    %esi,%edx
 1bf:	8d 72 ff             	lea    -0x1(%edx),%esi
 1c2:	85 d2                	test   %edx,%edx
 1c4:	7f ed                	jg     1b3 <memmove+0x12>
  return vdst;
}
 1c6:	5b                   	pop    %ebx
 1c7:	5e                   	pop    %esi
 1c8:	5d                   	pop    %ebp
 1c9:	c3                   	ret    

000001ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ca:	b8 01 00 00 00       	mov    $0x1,%eax
 1cf:	cd 40                	int    $0x40
 1d1:	c3                   	ret    

000001d2 <exit>:
SYSCALL(exit)
 1d2:	b8 02 00 00 00       	mov    $0x2,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <wait>:
SYSCALL(wait)
 1da:	b8 03 00 00 00       	mov    $0x3,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <pipe>:
SYSCALL(pipe)
 1e2:	b8 04 00 00 00       	mov    $0x4,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <read>:
SYSCALL(read)
 1ea:	b8 05 00 00 00       	mov    $0x5,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <write>:
SYSCALL(write)
 1f2:	b8 10 00 00 00       	mov    $0x10,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <close>:
SYSCALL(close)
 1fa:	b8 15 00 00 00       	mov    $0x15,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <kill>:
SYSCALL(kill)
 202:	b8 06 00 00 00       	mov    $0x6,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <exec>:
SYSCALL(exec)
 20a:	b8 07 00 00 00       	mov    $0x7,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <open>:
SYSCALL(open)
 212:	b8 0f 00 00 00       	mov    $0xf,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <mknod>:
SYSCALL(mknod)
 21a:	b8 11 00 00 00       	mov    $0x11,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <unlink>:
SYSCALL(unlink)
 222:	b8 12 00 00 00       	mov    $0x12,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <fstat>:
SYSCALL(fstat)
 22a:	b8 08 00 00 00       	mov    $0x8,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <link>:
SYSCALL(link)
 232:	b8 13 00 00 00       	mov    $0x13,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <mkdir>:
SYSCALL(mkdir)
 23a:	b8 14 00 00 00       	mov    $0x14,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <chdir>:
SYSCALL(chdir)
 242:	b8 09 00 00 00       	mov    $0x9,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <dup>:
SYSCALL(dup)
 24a:	b8 0a 00 00 00       	mov    $0xa,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <getpid>:
SYSCALL(getpid)
 252:	b8 0b 00 00 00       	mov    $0xb,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <sbrk>:
SYSCALL(sbrk)
 25a:	b8 0c 00 00 00       	mov    $0xc,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <sleep>:
SYSCALL(sleep)
 262:	b8 0d 00 00 00       	mov    $0xd,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <uptime>:
SYSCALL(uptime)
 26a:	b8 0e 00 00 00       	mov    $0xe,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 272:	b8 16 00 00 00       	mov    $0x16,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <block>:
SYSCALL(block)
 27a:	b8 17 00 00 00       	mov    $0x17,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <unblock>:
SYSCALL(unblock)
 282:	b8 18 00 00 00       	mov    $0x18,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <chmod>:
SYSCALL(chmod)
 28a:	b8 19 00 00 00       	mov    $0x19,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 292:	55                   	push   %ebp
 293:	89 e5                	mov    %esp,%ebp
 295:	83 ec 1c             	sub    $0x1c,%esp
 298:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 29b:	6a 01                	push   $0x1
 29d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2a0:	52                   	push   %edx
 2a1:	50                   	push   %eax
 2a2:	e8 4b ff ff ff       	call   1f2 <write>
}
 2a7:	83 c4 10             	add    $0x10,%esp
 2aa:	c9                   	leave  
 2ab:	c3                   	ret    

000002ac <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2ac:	55                   	push   %ebp
 2ad:	89 e5                	mov    %esp,%ebp
 2af:	57                   	push   %edi
 2b0:	56                   	push   %esi
 2b1:	53                   	push   %ebx
 2b2:	83 ec 2c             	sub    $0x2c,%esp
 2b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2b8:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2be:	74 04                	je     2c4 <printint+0x18>
 2c0:	85 d2                	test   %edx,%edx
 2c2:	78 3c                	js     300 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2c4:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2c6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 2cd:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2d2:	89 c8                	mov    %ecx,%eax
 2d4:	ba 00 00 00 00       	mov    $0x0,%edx
 2d9:	f7 f6                	div    %esi
 2db:	89 df                	mov    %ebx,%edi
 2dd:	43                   	inc    %ebx
 2de:	8a 92 34 06 00 00    	mov    0x634(%edx),%dl
 2e4:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2e8:	89 ca                	mov    %ecx,%edx
 2ea:	89 c1                	mov    %eax,%ecx
 2ec:	39 f2                	cmp    %esi,%edx
 2ee:	73 e2                	jae    2d2 <printint+0x26>
  if(neg)
 2f0:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2f4:	74 24                	je     31a <printint+0x6e>
    buf[i++] = '-';
 2f6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2fb:	8d 5f 02             	lea    0x2(%edi),%ebx
 2fe:	eb 1a                	jmp    31a <printint+0x6e>
    x = -xx;
 300:	89 d1                	mov    %edx,%ecx
 302:	f7 d9                	neg    %ecx
    neg = 1;
 304:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 30b:	eb c0                	jmp    2cd <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 30d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 312:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 315:	e8 78 ff ff ff       	call   292 <putc>
  while(--i >= 0)
 31a:	4b                   	dec    %ebx
 31b:	79 f0                	jns    30d <printint+0x61>
}
 31d:	83 c4 2c             	add    $0x2c,%esp
 320:	5b                   	pop    %ebx
 321:	5e                   	pop    %esi
 322:	5f                   	pop    %edi
 323:	5d                   	pop    %ebp
 324:	c3                   	ret    

00000325 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 325:	55                   	push   %ebp
 326:	89 e5                	mov    %esp,%ebp
 328:	57                   	push   %edi
 329:	56                   	push   %esi
 32a:	53                   	push   %ebx
 32b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 32e:	8d 45 10             	lea    0x10(%ebp),%eax
 331:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 334:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 339:	bb 00 00 00 00       	mov    $0x0,%ebx
 33e:	eb 12                	jmp    352 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 340:	89 fa                	mov    %edi,%edx
 342:	8b 45 08             	mov    0x8(%ebp),%eax
 345:	e8 48 ff ff ff       	call   292 <putc>
 34a:	eb 05                	jmp    351 <printf+0x2c>
      }
    } else if(state == '%'){
 34c:	83 fe 25             	cmp    $0x25,%esi
 34f:	74 22                	je     373 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 351:	43                   	inc    %ebx
 352:	8b 45 0c             	mov    0xc(%ebp),%eax
 355:	8a 04 18             	mov    (%eax,%ebx,1),%al
 358:	84 c0                	test   %al,%al
 35a:	0f 84 1d 01 00 00    	je     47d <printf+0x158>
    c = fmt[i] & 0xff;
 360:	0f be f8             	movsbl %al,%edi
 363:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 366:	85 f6                	test   %esi,%esi
 368:	75 e2                	jne    34c <printf+0x27>
      if(c == '%'){
 36a:	83 f8 25             	cmp    $0x25,%eax
 36d:	75 d1                	jne    340 <printf+0x1b>
        state = '%';
 36f:	89 c6                	mov    %eax,%esi
 371:	eb de                	jmp    351 <printf+0x2c>
      if(c == 'd'){
 373:	83 f8 25             	cmp    $0x25,%eax
 376:	0f 84 cc 00 00 00    	je     448 <printf+0x123>
 37c:	0f 8c da 00 00 00    	jl     45c <printf+0x137>
 382:	83 f8 78             	cmp    $0x78,%eax
 385:	0f 8f d1 00 00 00    	jg     45c <printf+0x137>
 38b:	83 f8 63             	cmp    $0x63,%eax
 38e:	0f 8c c8 00 00 00    	jl     45c <printf+0x137>
 394:	83 e8 63             	sub    $0x63,%eax
 397:	83 f8 15             	cmp    $0x15,%eax
 39a:	0f 87 bc 00 00 00    	ja     45c <printf+0x137>
 3a0:	ff 24 85 dc 05 00 00 	jmp    *0x5dc(,%eax,4)
        printint(fd, *ap, 10, 1);
 3a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3aa:	8b 17                	mov    (%edi),%edx
 3ac:	83 ec 0c             	sub    $0xc,%esp
 3af:	6a 01                	push   $0x1
 3b1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3b6:	8b 45 08             	mov    0x8(%ebp),%eax
 3b9:	e8 ee fe ff ff       	call   2ac <printint>
        ap++;
 3be:	83 c7 04             	add    $0x4,%edi
 3c1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3c4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3c7:	be 00 00 00 00       	mov    $0x0,%esi
 3cc:	eb 83                	jmp    351 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d1:	8b 17                	mov    (%edi),%edx
 3d3:	83 ec 0c             	sub    $0xc,%esp
 3d6:	6a 00                	push   $0x0
 3d8:	b9 10 00 00 00       	mov    $0x10,%ecx
 3dd:	8b 45 08             	mov    0x8(%ebp),%eax
 3e0:	e8 c7 fe ff ff       	call   2ac <printint>
        ap++;
 3e5:	83 c7 04             	add    $0x4,%edi
 3e8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3eb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3ee:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 3f3:	e9 59 ff ff ff       	jmp    351 <printf+0x2c>
        s = (char*)*ap;
 3f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3fb:	8b 30                	mov    (%eax),%esi
        ap++;
 3fd:	83 c0 04             	add    $0x4,%eax
 400:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 403:	85 f6                	test   %esi,%esi
 405:	75 13                	jne    41a <printf+0xf5>
          s = "(null)";
 407:	be d5 05 00 00       	mov    $0x5d5,%esi
 40c:	eb 0c                	jmp    41a <printf+0xf5>
          putc(fd, *s);
 40e:	0f be d2             	movsbl %dl,%edx
 411:	8b 45 08             	mov    0x8(%ebp),%eax
 414:	e8 79 fe ff ff       	call   292 <putc>
          s++;
 419:	46                   	inc    %esi
        while(*s != 0){
 41a:	8a 16                	mov    (%esi),%dl
 41c:	84 d2                	test   %dl,%dl
 41e:	75 ee                	jne    40e <printf+0xe9>
      state = 0;
 420:	be 00 00 00 00       	mov    $0x0,%esi
 425:	e9 27 ff ff ff       	jmp    351 <printf+0x2c>
        putc(fd, *ap);
 42a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42d:	0f be 17             	movsbl (%edi),%edx
 430:	8b 45 08             	mov    0x8(%ebp),%eax
 433:	e8 5a fe ff ff       	call   292 <putc>
        ap++;
 438:	83 c7 04             	add    $0x4,%edi
 43b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 43e:	be 00 00 00 00       	mov    $0x0,%esi
 443:	e9 09 ff ff ff       	jmp    351 <printf+0x2c>
        putc(fd, c);
 448:	89 fa                	mov    %edi,%edx
 44a:	8b 45 08             	mov    0x8(%ebp),%eax
 44d:	e8 40 fe ff ff       	call   292 <putc>
      state = 0;
 452:	be 00 00 00 00       	mov    $0x0,%esi
 457:	e9 f5 fe ff ff       	jmp    351 <printf+0x2c>
        putc(fd, '%');
 45c:	ba 25 00 00 00       	mov    $0x25,%edx
 461:	8b 45 08             	mov    0x8(%ebp),%eax
 464:	e8 29 fe ff ff       	call   292 <putc>
        putc(fd, c);
 469:	89 fa                	mov    %edi,%edx
 46b:	8b 45 08             	mov    0x8(%ebp),%eax
 46e:	e8 1f fe ff ff       	call   292 <putc>
      state = 0;
 473:	be 00 00 00 00       	mov    $0x0,%esi
 478:	e9 d4 fe ff ff       	jmp    351 <printf+0x2c>
    }
  }
}
 47d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 480:	5b                   	pop    %ebx
 481:	5e                   	pop    %esi
 482:	5f                   	pop    %edi
 483:	5d                   	pop    %ebp
 484:	c3                   	ret    

00000485 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 485:	55                   	push   %ebp
 486:	89 e5                	mov    %esp,%ebp
 488:	57                   	push   %edi
 489:	56                   	push   %esi
 48a:	53                   	push   %ebx
 48b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 48e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 491:	a1 48 06 00 00       	mov    0x648,%eax
 496:	eb 02                	jmp    49a <free+0x15>
 498:	89 d0                	mov    %edx,%eax
 49a:	39 c8                	cmp    %ecx,%eax
 49c:	73 04                	jae    4a2 <free+0x1d>
 49e:	3b 08                	cmp    (%eax),%ecx
 4a0:	72 12                	jb     4b4 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4a2:	8b 10                	mov    (%eax),%edx
 4a4:	39 d0                	cmp    %edx,%eax
 4a6:	72 f0                	jb     498 <free+0x13>
 4a8:	39 c8                	cmp    %ecx,%eax
 4aa:	72 08                	jb     4b4 <free+0x2f>
 4ac:	39 d1                	cmp    %edx,%ecx
 4ae:	72 04                	jb     4b4 <free+0x2f>
 4b0:	89 d0                	mov    %edx,%eax
 4b2:	eb e6                	jmp    49a <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4b4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4b7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ba:	8b 10                	mov    (%eax),%edx
 4bc:	39 d7                	cmp    %edx,%edi
 4be:	74 19                	je     4d9 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4c3:	8b 50 04             	mov    0x4(%eax),%edx
 4c6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4c9:	39 ce                	cmp    %ecx,%esi
 4cb:	74 1b                	je     4e8 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4cd:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4cf:	a3 48 06 00 00       	mov    %eax,0x648
}
 4d4:	5b                   	pop    %ebx
 4d5:	5e                   	pop    %esi
 4d6:	5f                   	pop    %edi
 4d7:	5d                   	pop    %ebp
 4d8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4d9:	03 72 04             	add    0x4(%edx),%esi
 4dc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4df:	8b 10                	mov    (%eax),%edx
 4e1:	8b 12                	mov    (%edx),%edx
 4e3:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4e6:	eb db                	jmp    4c3 <free+0x3e>
    p->s.size += bp->s.size;
 4e8:	03 53 fc             	add    -0x4(%ebx),%edx
 4eb:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4ee:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4f1:	89 10                	mov    %edx,(%eax)
 4f3:	eb da                	jmp    4cf <free+0x4a>

000004f5 <morecore>:

static Header*
morecore(uint nu)
{
 4f5:	55                   	push   %ebp
 4f6:	89 e5                	mov    %esp,%ebp
 4f8:	53                   	push   %ebx
 4f9:	83 ec 04             	sub    $0x4,%esp
 4fc:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 4fe:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 503:	77 05                	ja     50a <morecore+0x15>
    nu = 4096;
 505:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 50a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 511:	83 ec 0c             	sub    $0xc,%esp
 514:	50                   	push   %eax
 515:	e8 40 fd ff ff       	call   25a <sbrk>
  if(p == (char*)-1)
 51a:	83 c4 10             	add    $0x10,%esp
 51d:	83 f8 ff             	cmp    $0xffffffff,%eax
 520:	74 1c                	je     53e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 522:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 525:	83 c0 08             	add    $0x8,%eax
 528:	83 ec 0c             	sub    $0xc,%esp
 52b:	50                   	push   %eax
 52c:	e8 54 ff ff ff       	call   485 <free>
  return freep;
 531:	a1 48 06 00 00       	mov    0x648,%eax
 536:	83 c4 10             	add    $0x10,%esp
}
 539:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 53c:	c9                   	leave  
 53d:	c3                   	ret    
    return 0;
 53e:	b8 00 00 00 00       	mov    $0x0,%eax
 543:	eb f4                	jmp    539 <morecore+0x44>

00000545 <malloc>:

void*
malloc(uint nbytes)
{
 545:	55                   	push   %ebp
 546:	89 e5                	mov    %esp,%ebp
 548:	53                   	push   %ebx
 549:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	8d 58 07             	lea    0x7(%eax),%ebx
 552:	c1 eb 03             	shr    $0x3,%ebx
 555:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 556:	8b 0d 48 06 00 00    	mov    0x648,%ecx
 55c:	85 c9                	test   %ecx,%ecx
 55e:	74 04                	je     564 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 560:	8b 01                	mov    (%ecx),%eax
 562:	eb 4a                	jmp    5ae <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 564:	c7 05 48 06 00 00 4c 	movl   $0x64c,0x648
 56b:	06 00 00 
 56e:	c7 05 4c 06 00 00 4c 	movl   $0x64c,0x64c
 575:	06 00 00 
    base.s.size = 0;
 578:	c7 05 50 06 00 00 00 	movl   $0x0,0x650
 57f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 582:	b9 4c 06 00 00       	mov    $0x64c,%ecx
 587:	eb d7                	jmp    560 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 589:	74 19                	je     5a4 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 58b:	29 da                	sub    %ebx,%edx
 58d:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 590:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 593:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 596:	89 0d 48 06 00 00    	mov    %ecx,0x648
      return (void*)(p + 1);
 59c:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 59f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5a2:	c9                   	leave  
 5a3:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5a4:	8b 10                	mov    (%eax),%edx
 5a6:	89 11                	mov    %edx,(%ecx)
 5a8:	eb ec                	jmp    596 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5aa:	89 c1                	mov    %eax,%ecx
 5ac:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5ae:	8b 50 04             	mov    0x4(%eax),%edx
 5b1:	39 da                	cmp    %ebx,%edx
 5b3:	73 d4                	jae    589 <malloc+0x44>
    if(p == freep)
 5b5:	39 05 48 06 00 00    	cmp    %eax,0x648
 5bb:	75 ed                	jne    5aa <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 5bd:	89 d8                	mov    %ebx,%eax
 5bf:	e8 31 ff ff ff       	call   4f5 <morecore>
 5c4:	85 c0                	test   %eax,%eax
 5c6:	75 e2                	jne    5aa <malloc+0x65>
 5c8:	eb d5                	jmp    59f <malloc+0x5a>
