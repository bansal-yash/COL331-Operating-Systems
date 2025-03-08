
_ln:     file format elf32-i386


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
   d:	53                   	push   %ebx
   e:	51                   	push   %ecx
   f:	8b 59 04             	mov    0x4(%ecx),%ebx
  if(argc != 3){
  12:	83 39 03             	cmpl   $0x3,(%ecx)
  15:	74 14                	je     2b <main+0x2b>
    printf(2, "Usage: ln old new\n");
  17:	83 ec 08             	sub    $0x8,%esp
  1a:	68 d8 05 00 00       	push   $0x5d8
  1f:	6a 02                	push   $0x2
  21:	e8 0a 03 00 00       	call   330 <printf>
    exit();
  26:	e8 b2 01 00 00       	call   1dd <exit>
  }
  if(link(argv[1], argv[2]) < 0)
  2b:	83 ec 08             	sub    $0x8,%esp
  2e:	ff 73 08             	pushl  0x8(%ebx)
  31:	ff 73 04             	pushl  0x4(%ebx)
  34:	e8 04 02 00 00       	call   23d <link>
  39:	83 c4 10             	add    $0x10,%esp
  3c:	85 c0                	test   %eax,%eax
  3e:	78 05                	js     45 <main+0x45>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit();
  40:	e8 98 01 00 00       	call   1dd <exit>
    printf(2, "link %s %s: failed\n", argv[1], argv[2]);
  45:	ff 73 08             	pushl  0x8(%ebx)
  48:	ff 73 04             	pushl  0x4(%ebx)
  4b:	68 eb 05 00 00       	push   $0x5eb
  50:	6a 02                	push   $0x2
  52:	e8 d9 02 00 00       	call   330 <printf>
  57:	83 c4 10             	add    $0x10,%esp
  5a:	eb e4                	jmp    40 <main+0x40>

0000005c <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5c:	55                   	push   %ebp
  5d:	89 e5                	mov    %esp,%ebp
  5f:	56                   	push   %esi
  60:	53                   	push   %ebx
  61:	8b 45 08             	mov    0x8(%ebp),%eax
  64:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  67:	89 c2                	mov    %eax,%edx
  69:	89 cb                	mov    %ecx,%ebx
  6b:	41                   	inc    %ecx
  6c:	89 d6                	mov    %edx,%esi
  6e:	42                   	inc    %edx
  6f:	8a 1b                	mov    (%ebx),%bl
  71:	88 1e                	mov    %bl,(%esi)
  73:	84 db                	test   %bl,%bl
  75:	75 f2                	jne    69 <strcpy+0xd>
    ;
  return os;
}
  77:	5b                   	pop    %ebx
  78:	5e                   	pop    %esi
  79:	5d                   	pop    %ebp
  7a:	c3                   	ret    

0000007b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7b:	55                   	push   %ebp
  7c:	89 e5                	mov    %esp,%ebp
  7e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  81:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  84:	eb 02                	jmp    88 <strcmp+0xd>
    p++, q++;
  86:	41                   	inc    %ecx
  87:	42                   	inc    %edx
  while(*p && *p == *q)
  88:	8a 01                	mov    (%ecx),%al
  8a:	84 c0                	test   %al,%al
  8c:	74 04                	je     92 <strcmp+0x17>
  8e:	3a 02                	cmp    (%edx),%al
  90:	74 f4                	je     86 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  92:	0f b6 c0             	movzbl %al,%eax
  95:	0f b6 12             	movzbl (%edx),%edx
  98:	29 d0                	sub    %edx,%eax
}
  9a:	5d                   	pop    %ebp
  9b:	c3                   	ret    

0000009c <strlen>:

uint
strlen(const char *s)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  a2:	b8 00 00 00 00       	mov    $0x0,%eax
  a7:	eb 01                	jmp    aa <strlen+0xe>
  a9:	40                   	inc    %eax
  aa:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ae:	75 f9                	jne    a9 <strlen+0xd>
    ;
  return n;
}
  b0:	5d                   	pop    %ebp
  b1:	c3                   	ret    

000000b2 <memset>:

void*
memset(void *dst, int c, uint n)
{
  b2:	55                   	push   %ebp
  b3:	89 e5                	mov    %esp,%ebp
  b5:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b6:	8b 7d 08             	mov    0x8(%ebp),%edi
  b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  bf:	fc                   	cld    
  c0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  c2:	8b 45 08             	mov    0x8(%ebp),%eax
  c5:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c8:	c9                   	leave  
  c9:	c3                   	ret    

000000ca <strchr>:

char*
strchr(const char *s, char c)
{
  ca:	55                   	push   %ebp
  cb:	89 e5                	mov    %esp,%ebp
  cd:	8b 45 08             	mov    0x8(%ebp),%eax
  d0:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  d3:	eb 01                	jmp    d6 <strchr+0xc>
  d5:	40                   	inc    %eax
  d6:	8a 10                	mov    (%eax),%dl
  d8:	84 d2                	test   %dl,%dl
  da:	74 06                	je     e2 <strchr+0x18>
    if(*s == c)
  dc:	38 ca                	cmp    %cl,%dl
  de:	75 f5                	jne    d5 <strchr+0xb>
  e0:	eb 05                	jmp    e7 <strchr+0x1d>
      return (char*)s;
  return 0;
  e2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e7:	5d                   	pop    %ebp
  e8:	c3                   	ret    

000000e9 <gets>:

char*
gets(char *buf, int max)
{
  e9:	55                   	push   %ebp
  ea:	89 e5                	mov    %esp,%ebp
  ec:	57                   	push   %edi
  ed:	56                   	push   %esi
  ee:	53                   	push   %ebx
  ef:	83 ec 1c             	sub    $0x1c,%esp
  f2:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f5:	bb 00 00 00 00       	mov    $0x0,%ebx
  fa:	89 de                	mov    %ebx,%esi
  fc:	43                   	inc    %ebx
  fd:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 100:	7d 2b                	jge    12d <gets+0x44>
    cc = read(0, &c, 1);
 102:	83 ec 04             	sub    $0x4,%esp
 105:	6a 01                	push   $0x1
 107:	8d 45 e7             	lea    -0x19(%ebp),%eax
 10a:	50                   	push   %eax
 10b:	6a 00                	push   $0x0
 10d:	e8 e3 00 00 00       	call   1f5 <read>
    if(cc < 1)
 112:	83 c4 10             	add    $0x10,%esp
 115:	85 c0                	test   %eax,%eax
 117:	7e 14                	jle    12d <gets+0x44>
      break;
    buf[i++] = c;
 119:	8a 45 e7             	mov    -0x19(%ebp),%al
 11c:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11f:	3c 0a                	cmp    $0xa,%al
 121:	74 08                	je     12b <gets+0x42>
 123:	3c 0d                	cmp    $0xd,%al
 125:	75 d3                	jne    fa <gets+0x11>
    buf[i++] = c;
 127:	89 de                	mov    %ebx,%esi
 129:	eb 02                	jmp    12d <gets+0x44>
 12b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 131:	89 f8                	mov    %edi,%eax
 133:	8d 65 f4             	lea    -0xc(%ebp),%esp
 136:	5b                   	pop    %ebx
 137:	5e                   	pop    %esi
 138:	5f                   	pop    %edi
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <stat>:

int
stat(const char *n, struct stat *st)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 140:	83 ec 08             	sub    $0x8,%esp
 143:	6a 00                	push   $0x0
 145:	ff 75 08             	pushl  0x8(%ebp)
 148:	e8 d0 00 00 00       	call   21d <open>
  if(fd < 0)
 14d:	83 c4 10             	add    $0x10,%esp
 150:	85 c0                	test   %eax,%eax
 152:	78 24                	js     178 <stat+0x3d>
 154:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 156:	83 ec 08             	sub    $0x8,%esp
 159:	ff 75 0c             	pushl  0xc(%ebp)
 15c:	50                   	push   %eax
 15d:	e8 d3 00 00 00       	call   235 <fstat>
 162:	89 c6                	mov    %eax,%esi
  close(fd);
 164:	89 1c 24             	mov    %ebx,(%esp)
 167:	e8 99 00 00 00       	call   205 <close>
  return r;
 16c:	83 c4 10             	add    $0x10,%esp
}
 16f:	89 f0                	mov    %esi,%eax
 171:	8d 65 f8             	lea    -0x8(%ebp),%esp
 174:	5b                   	pop    %ebx
 175:	5e                   	pop    %esi
 176:	5d                   	pop    %ebp
 177:	c3                   	ret    
    return -1;
 178:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17d:	eb f0                	jmp    16f <stat+0x34>

0000017f <atoi>:

int
atoi(const char *s)
{
 17f:	55                   	push   %ebp
 180:	89 e5                	mov    %esp,%ebp
 182:	53                   	push   %ebx
 183:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 186:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 18b:	eb 0e                	jmp    19b <atoi+0x1c>
    n = n*10 + *s++ - '0';
 18d:	8d 14 92             	lea    (%edx,%edx,4),%edx
 190:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 193:	41                   	inc    %ecx
 194:	0f be c0             	movsbl %al,%eax
 197:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 19b:	8a 01                	mov    (%ecx),%al
 19d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1a0:	80 fb 09             	cmp    $0x9,%bl
 1a3:	76 e8                	jbe    18d <atoi+0xe>
  return n;
}
 1a5:	89 d0                	mov    %edx,%eax
 1a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1aa:	c9                   	leave  
 1ab:	c3                   	ret    

000001ac <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	56                   	push   %esi
 1b0:	53                   	push   %ebx
 1b1:	8b 45 08             	mov    0x8(%ebp),%eax
 1b4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1b7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1ba:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1bc:	eb 0c                	jmp    1ca <memmove+0x1e>
    *dst++ = *src++;
 1be:	8a 13                	mov    (%ebx),%dl
 1c0:	88 11                	mov    %dl,(%ecx)
 1c2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1c5:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1c8:	89 f2                	mov    %esi,%edx
 1ca:	8d 72 ff             	lea    -0x1(%edx),%esi
 1cd:	85 d2                	test   %edx,%edx
 1cf:	7f ed                	jg     1be <memmove+0x12>
  return vdst;
}
 1d1:	5b                   	pop    %ebx
 1d2:	5e                   	pop    %esi
 1d3:	5d                   	pop    %ebp
 1d4:	c3                   	ret    

000001d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1d5:	b8 01 00 00 00       	mov    $0x1,%eax
 1da:	cd 40                	int    $0x40
 1dc:	c3                   	ret    

000001dd <exit>:
SYSCALL(exit)
 1dd:	b8 02 00 00 00       	mov    $0x2,%eax
 1e2:	cd 40                	int    $0x40
 1e4:	c3                   	ret    

000001e5 <wait>:
SYSCALL(wait)
 1e5:	b8 03 00 00 00       	mov    $0x3,%eax
 1ea:	cd 40                	int    $0x40
 1ec:	c3                   	ret    

000001ed <pipe>:
SYSCALL(pipe)
 1ed:	b8 04 00 00 00       	mov    $0x4,%eax
 1f2:	cd 40                	int    $0x40
 1f4:	c3                   	ret    

000001f5 <read>:
SYSCALL(read)
 1f5:	b8 05 00 00 00       	mov    $0x5,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <write>:
SYSCALL(write)
 1fd:	b8 10 00 00 00       	mov    $0x10,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <close>:
SYSCALL(close)
 205:	b8 15 00 00 00       	mov    $0x15,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <kill>:
SYSCALL(kill)
 20d:	b8 06 00 00 00       	mov    $0x6,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <exec>:
SYSCALL(exec)
 215:	b8 07 00 00 00       	mov    $0x7,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <open>:
SYSCALL(open)
 21d:	b8 0f 00 00 00       	mov    $0xf,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <mknod>:
SYSCALL(mknod)
 225:	b8 11 00 00 00       	mov    $0x11,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <unlink>:
SYSCALL(unlink)
 22d:	b8 12 00 00 00       	mov    $0x12,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <fstat>:
SYSCALL(fstat)
 235:	b8 08 00 00 00       	mov    $0x8,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <link>:
SYSCALL(link)
 23d:	b8 13 00 00 00       	mov    $0x13,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <mkdir>:
SYSCALL(mkdir)
 245:	b8 14 00 00 00       	mov    $0x14,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <chdir>:
SYSCALL(chdir)
 24d:	b8 09 00 00 00       	mov    $0x9,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <dup>:
SYSCALL(dup)
 255:	b8 0a 00 00 00       	mov    $0xa,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <getpid>:
SYSCALL(getpid)
 25d:	b8 0b 00 00 00       	mov    $0xb,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <sbrk>:
SYSCALL(sbrk)
 265:	b8 0c 00 00 00       	mov    $0xc,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <sleep>:
SYSCALL(sleep)
 26d:	b8 0d 00 00 00       	mov    $0xd,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <uptime>:
SYSCALL(uptime)
 275:	b8 0e 00 00 00       	mov    $0xe,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 27d:	b8 16 00 00 00       	mov    $0x16,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <block>:
SYSCALL(block)
 285:	b8 17 00 00 00       	mov    $0x17,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <unblock>:
SYSCALL(unblock)
 28d:	b8 18 00 00 00       	mov    $0x18,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <chmod>:
SYSCALL(chmod)
 295:	b8 19 00 00 00       	mov    $0x19,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 29d:	55                   	push   %ebp
 29e:	89 e5                	mov    %esp,%ebp
 2a0:	83 ec 1c             	sub    $0x1c,%esp
 2a3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2a6:	6a 01                	push   $0x1
 2a8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2ab:	52                   	push   %edx
 2ac:	50                   	push   %eax
 2ad:	e8 4b ff ff ff       	call   1fd <write>
}
 2b2:	83 c4 10             	add    $0x10,%esp
 2b5:	c9                   	leave  
 2b6:	c3                   	ret    

000002b7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2b7:	55                   	push   %ebp
 2b8:	89 e5                	mov    %esp,%ebp
 2ba:	57                   	push   %edi
 2bb:	56                   	push   %esi
 2bc:	53                   	push   %ebx
 2bd:	83 ec 2c             	sub    $0x2c,%esp
 2c0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2c3:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2c5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2c9:	74 04                	je     2cf <printint+0x18>
 2cb:	85 d2                	test   %edx,%edx
 2cd:	78 3c                	js     30b <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2cf:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2d1:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 2d8:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2dd:	89 c8                	mov    %ecx,%eax
 2df:	ba 00 00 00 00       	mov    $0x0,%edx
 2e4:	f7 f6                	div    %esi
 2e6:	89 df                	mov    %ebx,%edi
 2e8:	43                   	inc    %ebx
 2e9:	8a 92 60 06 00 00    	mov    0x660(%edx),%dl
 2ef:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2f3:	89 ca                	mov    %ecx,%edx
 2f5:	89 c1                	mov    %eax,%ecx
 2f7:	39 f2                	cmp    %esi,%edx
 2f9:	73 e2                	jae    2dd <printint+0x26>
  if(neg)
 2fb:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2ff:	74 24                	je     325 <printint+0x6e>
    buf[i++] = '-';
 301:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 306:	8d 5f 02             	lea    0x2(%edi),%ebx
 309:	eb 1a                	jmp    325 <printint+0x6e>
    x = -xx;
 30b:	89 d1                	mov    %edx,%ecx
 30d:	f7 d9                	neg    %ecx
    neg = 1;
 30f:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 316:	eb c0                	jmp    2d8 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 318:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 31d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 320:	e8 78 ff ff ff       	call   29d <putc>
  while(--i >= 0)
 325:	4b                   	dec    %ebx
 326:	79 f0                	jns    318 <printint+0x61>
}
 328:	83 c4 2c             	add    $0x2c,%esp
 32b:	5b                   	pop    %ebx
 32c:	5e                   	pop    %esi
 32d:	5f                   	pop    %edi
 32e:	5d                   	pop    %ebp
 32f:	c3                   	ret    

00000330 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 330:	55                   	push   %ebp
 331:	89 e5                	mov    %esp,%ebp
 333:	57                   	push   %edi
 334:	56                   	push   %esi
 335:	53                   	push   %ebx
 336:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 339:	8d 45 10             	lea    0x10(%ebp),%eax
 33c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 33f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 344:	bb 00 00 00 00       	mov    $0x0,%ebx
 349:	eb 12                	jmp    35d <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 34b:	89 fa                	mov    %edi,%edx
 34d:	8b 45 08             	mov    0x8(%ebp),%eax
 350:	e8 48 ff ff ff       	call   29d <putc>
 355:	eb 05                	jmp    35c <printf+0x2c>
      }
    } else if(state == '%'){
 357:	83 fe 25             	cmp    $0x25,%esi
 35a:	74 22                	je     37e <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 35c:	43                   	inc    %ebx
 35d:	8b 45 0c             	mov    0xc(%ebp),%eax
 360:	8a 04 18             	mov    (%eax,%ebx,1),%al
 363:	84 c0                	test   %al,%al
 365:	0f 84 1d 01 00 00    	je     488 <printf+0x158>
    c = fmt[i] & 0xff;
 36b:	0f be f8             	movsbl %al,%edi
 36e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 371:	85 f6                	test   %esi,%esi
 373:	75 e2                	jne    357 <printf+0x27>
      if(c == '%'){
 375:	83 f8 25             	cmp    $0x25,%eax
 378:	75 d1                	jne    34b <printf+0x1b>
        state = '%';
 37a:	89 c6                	mov    %eax,%esi
 37c:	eb de                	jmp    35c <printf+0x2c>
      if(c == 'd'){
 37e:	83 f8 25             	cmp    $0x25,%eax
 381:	0f 84 cc 00 00 00    	je     453 <printf+0x123>
 387:	0f 8c da 00 00 00    	jl     467 <printf+0x137>
 38d:	83 f8 78             	cmp    $0x78,%eax
 390:	0f 8f d1 00 00 00    	jg     467 <printf+0x137>
 396:	83 f8 63             	cmp    $0x63,%eax
 399:	0f 8c c8 00 00 00    	jl     467 <printf+0x137>
 39f:	83 e8 63             	sub    $0x63,%eax
 3a2:	83 f8 15             	cmp    $0x15,%eax
 3a5:	0f 87 bc 00 00 00    	ja     467 <printf+0x137>
 3ab:	ff 24 85 08 06 00 00 	jmp    *0x608(,%eax,4)
        printint(fd, *ap, 10, 1);
 3b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3b5:	8b 17                	mov    (%edi),%edx
 3b7:	83 ec 0c             	sub    $0xc,%esp
 3ba:	6a 01                	push   $0x1
 3bc:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3c1:	8b 45 08             	mov    0x8(%ebp),%eax
 3c4:	e8 ee fe ff ff       	call   2b7 <printint>
        ap++;
 3c9:	83 c7 04             	add    $0x4,%edi
 3cc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3cf:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3d2:	be 00 00 00 00       	mov    $0x0,%esi
 3d7:	eb 83                	jmp    35c <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3d9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3dc:	8b 17                	mov    (%edi),%edx
 3de:	83 ec 0c             	sub    $0xc,%esp
 3e1:	6a 00                	push   $0x0
 3e3:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e8:	8b 45 08             	mov    0x8(%ebp),%eax
 3eb:	e8 c7 fe ff ff       	call   2b7 <printint>
        ap++;
 3f0:	83 c7 04             	add    $0x4,%edi
 3f3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f9:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 3fe:	e9 59 ff ff ff       	jmp    35c <printf+0x2c>
        s = (char*)*ap;
 403:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 406:	8b 30                	mov    (%eax),%esi
        ap++;
 408:	83 c0 04             	add    $0x4,%eax
 40b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 40e:	85 f6                	test   %esi,%esi
 410:	75 13                	jne    425 <printf+0xf5>
          s = "(null)";
 412:	be ff 05 00 00       	mov    $0x5ff,%esi
 417:	eb 0c                	jmp    425 <printf+0xf5>
          putc(fd, *s);
 419:	0f be d2             	movsbl %dl,%edx
 41c:	8b 45 08             	mov    0x8(%ebp),%eax
 41f:	e8 79 fe ff ff       	call   29d <putc>
          s++;
 424:	46                   	inc    %esi
        while(*s != 0){
 425:	8a 16                	mov    (%esi),%dl
 427:	84 d2                	test   %dl,%dl
 429:	75 ee                	jne    419 <printf+0xe9>
      state = 0;
 42b:	be 00 00 00 00       	mov    $0x0,%esi
 430:	e9 27 ff ff ff       	jmp    35c <printf+0x2c>
        putc(fd, *ap);
 435:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 438:	0f be 17             	movsbl (%edi),%edx
 43b:	8b 45 08             	mov    0x8(%ebp),%eax
 43e:	e8 5a fe ff ff       	call   29d <putc>
        ap++;
 443:	83 c7 04             	add    $0x4,%edi
 446:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 449:	be 00 00 00 00       	mov    $0x0,%esi
 44e:	e9 09 ff ff ff       	jmp    35c <printf+0x2c>
        putc(fd, c);
 453:	89 fa                	mov    %edi,%edx
 455:	8b 45 08             	mov    0x8(%ebp),%eax
 458:	e8 40 fe ff ff       	call   29d <putc>
      state = 0;
 45d:	be 00 00 00 00       	mov    $0x0,%esi
 462:	e9 f5 fe ff ff       	jmp    35c <printf+0x2c>
        putc(fd, '%');
 467:	ba 25 00 00 00       	mov    $0x25,%edx
 46c:	8b 45 08             	mov    0x8(%ebp),%eax
 46f:	e8 29 fe ff ff       	call   29d <putc>
        putc(fd, c);
 474:	89 fa                	mov    %edi,%edx
 476:	8b 45 08             	mov    0x8(%ebp),%eax
 479:	e8 1f fe ff ff       	call   29d <putc>
      state = 0;
 47e:	be 00 00 00 00       	mov    $0x0,%esi
 483:	e9 d4 fe ff ff       	jmp    35c <printf+0x2c>
    }
  }
}
 488:	8d 65 f4             	lea    -0xc(%ebp),%esp
 48b:	5b                   	pop    %ebx
 48c:	5e                   	pop    %esi
 48d:	5f                   	pop    %edi
 48e:	5d                   	pop    %ebp
 48f:	c3                   	ret    

00000490 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 490:	55                   	push   %ebp
 491:	89 e5                	mov    %esp,%ebp
 493:	57                   	push   %edi
 494:	56                   	push   %esi
 495:	53                   	push   %ebx
 496:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 499:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 49c:	a1 74 06 00 00       	mov    0x674,%eax
 4a1:	eb 02                	jmp    4a5 <free+0x15>
 4a3:	89 d0                	mov    %edx,%eax
 4a5:	39 c8                	cmp    %ecx,%eax
 4a7:	73 04                	jae    4ad <free+0x1d>
 4a9:	3b 08                	cmp    (%eax),%ecx
 4ab:	72 12                	jb     4bf <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4ad:	8b 10                	mov    (%eax),%edx
 4af:	39 d0                	cmp    %edx,%eax
 4b1:	72 f0                	jb     4a3 <free+0x13>
 4b3:	39 c8                	cmp    %ecx,%eax
 4b5:	72 08                	jb     4bf <free+0x2f>
 4b7:	39 d1                	cmp    %edx,%ecx
 4b9:	72 04                	jb     4bf <free+0x2f>
 4bb:	89 d0                	mov    %edx,%eax
 4bd:	eb e6                	jmp    4a5 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4bf:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4c2:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4c5:	8b 10                	mov    (%eax),%edx
 4c7:	39 d7                	cmp    %edx,%edi
 4c9:	74 19                	je     4e4 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4cb:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4ce:	8b 50 04             	mov    0x4(%eax),%edx
 4d1:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4d4:	39 ce                	cmp    %ecx,%esi
 4d6:	74 1b                	je     4f3 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4d8:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4da:	a3 74 06 00 00       	mov    %eax,0x674
}
 4df:	5b                   	pop    %ebx
 4e0:	5e                   	pop    %esi
 4e1:	5f                   	pop    %edi
 4e2:	5d                   	pop    %ebp
 4e3:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4e4:	03 72 04             	add    0x4(%edx),%esi
 4e7:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4ea:	8b 10                	mov    (%eax),%edx
 4ec:	8b 12                	mov    (%edx),%edx
 4ee:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4f1:	eb db                	jmp    4ce <free+0x3e>
    p->s.size += bp->s.size;
 4f3:	03 53 fc             	add    -0x4(%ebx),%edx
 4f6:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4f9:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4fc:	89 10                	mov    %edx,(%eax)
 4fe:	eb da                	jmp    4da <free+0x4a>

00000500 <morecore>:

static Header*
morecore(uint nu)
{
 500:	55                   	push   %ebp
 501:	89 e5                	mov    %esp,%ebp
 503:	53                   	push   %ebx
 504:	83 ec 04             	sub    $0x4,%esp
 507:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 509:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 50e:	77 05                	ja     515 <morecore+0x15>
    nu = 4096;
 510:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 515:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 51c:	83 ec 0c             	sub    $0xc,%esp
 51f:	50                   	push   %eax
 520:	e8 40 fd ff ff       	call   265 <sbrk>
  if(p == (char*)-1)
 525:	83 c4 10             	add    $0x10,%esp
 528:	83 f8 ff             	cmp    $0xffffffff,%eax
 52b:	74 1c                	je     549 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 52d:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 530:	83 c0 08             	add    $0x8,%eax
 533:	83 ec 0c             	sub    $0xc,%esp
 536:	50                   	push   %eax
 537:	e8 54 ff ff ff       	call   490 <free>
  return freep;
 53c:	a1 74 06 00 00       	mov    0x674,%eax
 541:	83 c4 10             	add    $0x10,%esp
}
 544:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 547:	c9                   	leave  
 548:	c3                   	ret    
    return 0;
 549:	b8 00 00 00 00       	mov    $0x0,%eax
 54e:	eb f4                	jmp    544 <morecore+0x44>

00000550 <malloc>:

void*
malloc(uint nbytes)
{
 550:	55                   	push   %ebp
 551:	89 e5                	mov    %esp,%ebp
 553:	53                   	push   %ebx
 554:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 557:	8b 45 08             	mov    0x8(%ebp),%eax
 55a:	8d 58 07             	lea    0x7(%eax),%ebx
 55d:	c1 eb 03             	shr    $0x3,%ebx
 560:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 561:	8b 0d 74 06 00 00    	mov    0x674,%ecx
 567:	85 c9                	test   %ecx,%ecx
 569:	74 04                	je     56f <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 56b:	8b 01                	mov    (%ecx),%eax
 56d:	eb 4a                	jmp    5b9 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 56f:	c7 05 74 06 00 00 78 	movl   $0x678,0x674
 576:	06 00 00 
 579:	c7 05 78 06 00 00 78 	movl   $0x678,0x678
 580:	06 00 00 
    base.s.size = 0;
 583:	c7 05 7c 06 00 00 00 	movl   $0x0,0x67c
 58a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 58d:	b9 78 06 00 00       	mov    $0x678,%ecx
 592:	eb d7                	jmp    56b <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 594:	74 19                	je     5af <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 596:	29 da                	sub    %ebx,%edx
 598:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 59b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 59e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5a1:	89 0d 74 06 00 00    	mov    %ecx,0x674
      return (void*)(p + 1);
 5a7:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5aa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5ad:	c9                   	leave  
 5ae:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5af:	8b 10                	mov    (%eax),%edx
 5b1:	89 11                	mov    %edx,(%ecx)
 5b3:	eb ec                	jmp    5a1 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b5:	89 c1                	mov    %eax,%ecx
 5b7:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5b9:	8b 50 04             	mov    0x4(%eax),%edx
 5bc:	39 da                	cmp    %ebx,%edx
 5be:	73 d4                	jae    594 <malloc+0x44>
    if(p == freep)
 5c0:	39 05 74 06 00 00    	cmp    %eax,0x674
 5c6:	75 ed                	jne    5b5 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 5c8:	89 d8                	mov    %ebx,%eax
 5ca:	e8 31 ff ff ff       	call   500 <morecore>
 5cf:	85 c0                	test   %eax,%eax
 5d1:	75 e2                	jne    5b5 <malloc+0x65>
 5d3:	eb d5                	jmp    5aa <malloc+0x5a>
