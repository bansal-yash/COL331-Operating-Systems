
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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

  if(argc < 2){
  19:	83 fe 01             	cmp    $0x1,%esi
  1c:	7e 07                	jle    25 <main+0x25>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  1e:	bb 01 00 00 00       	mov    $0x1,%ebx
  23:	eb 2b                	jmp    50 <main+0x50>
    printf(2, "usage: kill pid...\n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 d4 05 00 00       	push   $0x5d4
  2d:	6a 02                	push   $0x2
  2f:	e8 f9 02 00 00       	call   32d <printf>
    exit();
  34:	e8 a1 01 00 00       	call   1da <exit>
    kill(atoi(argv[i]));
  39:	83 ec 0c             	sub    $0xc,%esp
  3c:	ff 34 9f             	pushl  (%edi,%ebx,4)
  3f:	e8 38 01 00 00       	call   17c <atoi>
  44:	89 04 24             	mov    %eax,(%esp)
  47:	e8 be 01 00 00       	call   20a <kill>
  for(i=1; i<argc; i++)
  4c:	43                   	inc    %ebx
  4d:	83 c4 10             	add    $0x10,%esp
  50:	39 f3                	cmp    %esi,%ebx
  52:	7c e5                	jl     39 <main+0x39>
  exit();
  54:	e8 81 01 00 00       	call   1da <exit>

00000059 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	56                   	push   %esi
  5d:	53                   	push   %ebx
  5e:	8b 45 08             	mov    0x8(%ebp),%eax
  61:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	89 c2                	mov    %eax,%edx
  66:	89 cb                	mov    %ecx,%ebx
  68:	41                   	inc    %ecx
  69:	89 d6                	mov    %edx,%esi
  6b:	42                   	inc    %edx
  6c:	8a 1b                	mov    (%ebx),%bl
  6e:	88 1e                	mov    %bl,(%esi)
  70:	84 db                	test   %bl,%bl
  72:	75 f2                	jne    66 <strcpy+0xd>
    ;
  return os;
}
  74:	5b                   	pop    %ebx
  75:	5e                   	pop    %esi
  76:	5d                   	pop    %ebp
  77:	c3                   	ret    

00000078 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  78:	55                   	push   %ebp
  79:	89 e5                	mov    %esp,%ebp
  7b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  81:	eb 02                	jmp    85 <strcmp+0xd>
    p++, q++;
  83:	41                   	inc    %ecx
  84:	42                   	inc    %edx
  while(*p && *p == *q)
  85:	8a 01                	mov    (%ecx),%al
  87:	84 c0                	test   %al,%al
  89:	74 04                	je     8f <strcmp+0x17>
  8b:	3a 02                	cmp    (%edx),%al
  8d:	74 f4                	je     83 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  8f:	0f b6 c0             	movzbl %al,%eax
  92:	0f b6 12             	movzbl (%edx),%edx
  95:	29 d0                	sub    %edx,%eax
}
  97:	5d                   	pop    %ebp
  98:	c3                   	ret    

00000099 <strlen>:

uint
strlen(const char *s)
{
  99:	55                   	push   %ebp
  9a:	89 e5                	mov    %esp,%ebp
  9c:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  9f:	b8 00 00 00 00       	mov    $0x0,%eax
  a4:	eb 01                	jmp    a7 <strlen+0xe>
  a6:	40                   	inc    %eax
  a7:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  ab:	75 f9                	jne    a6 <strlen+0xd>
    ;
  return n;
}
  ad:	5d                   	pop    %ebp
  ae:	c3                   	ret    

000000af <memset>:

void*
memset(void *dst, int c, uint n)
{
  af:	55                   	push   %ebp
  b0:	89 e5                	mov    %esp,%ebp
  b2:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  b3:	8b 7d 08             	mov    0x8(%ebp),%edi
  b6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  bc:	fc                   	cld    
  bd:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  bf:	8b 45 08             	mov    0x8(%ebp),%eax
  c2:	8b 7d fc             	mov    -0x4(%ebp),%edi
  c5:	c9                   	leave  
  c6:	c3                   	ret    

000000c7 <strchr>:

char*
strchr(const char *s, char c)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	8b 45 08             	mov    0x8(%ebp),%eax
  cd:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  d0:	eb 01                	jmp    d3 <strchr+0xc>
  d2:	40                   	inc    %eax
  d3:	8a 10                	mov    (%eax),%dl
  d5:	84 d2                	test   %dl,%dl
  d7:	74 06                	je     df <strchr+0x18>
    if(*s == c)
  d9:	38 ca                	cmp    %cl,%dl
  db:	75 f5                	jne    d2 <strchr+0xb>
  dd:	eb 05                	jmp    e4 <strchr+0x1d>
      return (char*)s;
  return 0;
  df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  e4:	5d                   	pop    %ebp
  e5:	c3                   	ret    

000000e6 <gets>:

char*
gets(char *buf, int max)
{
  e6:	55                   	push   %ebp
  e7:	89 e5                	mov    %esp,%ebp
  e9:	57                   	push   %edi
  ea:	56                   	push   %esi
  eb:	53                   	push   %ebx
  ec:	83 ec 1c             	sub    $0x1c,%esp
  ef:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  f2:	bb 00 00 00 00       	mov    $0x0,%ebx
  f7:	89 de                	mov    %ebx,%esi
  f9:	43                   	inc    %ebx
  fa:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  fd:	7d 2b                	jge    12a <gets+0x44>
    cc = read(0, &c, 1);
  ff:	83 ec 04             	sub    $0x4,%esp
 102:	6a 01                	push   $0x1
 104:	8d 45 e7             	lea    -0x19(%ebp),%eax
 107:	50                   	push   %eax
 108:	6a 00                	push   $0x0
 10a:	e8 e3 00 00 00       	call   1f2 <read>
    if(cc < 1)
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	7e 14                	jle    12a <gets+0x44>
      break;
    buf[i++] = c;
 116:	8a 45 e7             	mov    -0x19(%ebp),%al
 119:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 11c:	3c 0a                	cmp    $0xa,%al
 11e:	74 08                	je     128 <gets+0x42>
 120:	3c 0d                	cmp    $0xd,%al
 122:	75 d3                	jne    f7 <gets+0x11>
    buf[i++] = c;
 124:	89 de                	mov    %ebx,%esi
 126:	eb 02                	jmp    12a <gets+0x44>
 128:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 12a:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 12e:	89 f8                	mov    %edi,%eax
 130:	8d 65 f4             	lea    -0xc(%ebp),%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5f                   	pop    %edi
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    

00000138 <stat>:

int
stat(const char *n, struct stat *st)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	56                   	push   %esi
 13c:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 13d:	83 ec 08             	sub    $0x8,%esp
 140:	6a 00                	push   $0x0
 142:	ff 75 08             	pushl  0x8(%ebp)
 145:	e8 d0 00 00 00       	call   21a <open>
  if(fd < 0)
 14a:	83 c4 10             	add    $0x10,%esp
 14d:	85 c0                	test   %eax,%eax
 14f:	78 24                	js     175 <stat+0x3d>
 151:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 153:	83 ec 08             	sub    $0x8,%esp
 156:	ff 75 0c             	pushl  0xc(%ebp)
 159:	50                   	push   %eax
 15a:	e8 d3 00 00 00       	call   232 <fstat>
 15f:	89 c6                	mov    %eax,%esi
  close(fd);
 161:	89 1c 24             	mov    %ebx,(%esp)
 164:	e8 99 00 00 00       	call   202 <close>
  return r;
 169:	83 c4 10             	add    $0x10,%esp
}
 16c:	89 f0                	mov    %esi,%eax
 16e:	8d 65 f8             	lea    -0x8(%ebp),%esp
 171:	5b                   	pop    %ebx
 172:	5e                   	pop    %esi
 173:	5d                   	pop    %ebp
 174:	c3                   	ret    
    return -1;
 175:	be ff ff ff ff       	mov    $0xffffffff,%esi
 17a:	eb f0                	jmp    16c <stat+0x34>

0000017c <atoi>:

int
atoi(const char *s)
{
 17c:	55                   	push   %ebp
 17d:	89 e5                	mov    %esp,%ebp
 17f:	53                   	push   %ebx
 180:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 183:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 188:	eb 0e                	jmp    198 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 18a:	8d 14 92             	lea    (%edx,%edx,4),%edx
 18d:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 190:	41                   	inc    %ecx
 191:	0f be c0             	movsbl %al,%eax
 194:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 198:	8a 01                	mov    (%ecx),%al
 19a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 19d:	80 fb 09             	cmp    $0x9,%bl
 1a0:	76 e8                	jbe    18a <atoi+0xe>
  return n;
}
 1a2:	89 d0                	mov    %edx,%eax
 1a4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1a7:	c9                   	leave  
 1a8:	c3                   	ret    

000001a9 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	56                   	push   %esi
 1ad:	53                   	push   %ebx
 1ae:	8b 45 08             	mov    0x8(%ebp),%eax
 1b1:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1b4:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1b7:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1b9:	eb 0c                	jmp    1c7 <memmove+0x1e>
    *dst++ = *src++;
 1bb:	8a 13                	mov    (%ebx),%dl
 1bd:	88 11                	mov    %dl,(%ecx)
 1bf:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1c2:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1c5:	89 f2                	mov    %esi,%edx
 1c7:	8d 72 ff             	lea    -0x1(%edx),%esi
 1ca:	85 d2                	test   %edx,%edx
 1cc:	7f ed                	jg     1bb <memmove+0x12>
  return vdst;
}
 1ce:	5b                   	pop    %ebx
 1cf:	5e                   	pop    %esi
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    

000001d2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1d2:	b8 01 00 00 00       	mov    $0x1,%eax
 1d7:	cd 40                	int    $0x40
 1d9:	c3                   	ret    

000001da <exit>:
SYSCALL(exit)
 1da:	b8 02 00 00 00       	mov    $0x2,%eax
 1df:	cd 40                	int    $0x40
 1e1:	c3                   	ret    

000001e2 <wait>:
SYSCALL(wait)
 1e2:	b8 03 00 00 00       	mov    $0x3,%eax
 1e7:	cd 40                	int    $0x40
 1e9:	c3                   	ret    

000001ea <pipe>:
SYSCALL(pipe)
 1ea:	b8 04 00 00 00       	mov    $0x4,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <read>:
SYSCALL(read)
 1f2:	b8 05 00 00 00       	mov    $0x5,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <write>:
SYSCALL(write)
 1fa:	b8 10 00 00 00       	mov    $0x10,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <close>:
SYSCALL(close)
 202:	b8 15 00 00 00       	mov    $0x15,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <kill>:
SYSCALL(kill)
 20a:	b8 06 00 00 00       	mov    $0x6,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <exec>:
SYSCALL(exec)
 212:	b8 07 00 00 00       	mov    $0x7,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <open>:
SYSCALL(open)
 21a:	b8 0f 00 00 00       	mov    $0xf,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <mknod>:
SYSCALL(mknod)
 222:	b8 11 00 00 00       	mov    $0x11,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <unlink>:
SYSCALL(unlink)
 22a:	b8 12 00 00 00       	mov    $0x12,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <fstat>:
SYSCALL(fstat)
 232:	b8 08 00 00 00       	mov    $0x8,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <link>:
SYSCALL(link)
 23a:	b8 13 00 00 00       	mov    $0x13,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <mkdir>:
SYSCALL(mkdir)
 242:	b8 14 00 00 00       	mov    $0x14,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <chdir>:
SYSCALL(chdir)
 24a:	b8 09 00 00 00       	mov    $0x9,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <dup>:
SYSCALL(dup)
 252:	b8 0a 00 00 00       	mov    $0xa,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <getpid>:
SYSCALL(getpid)
 25a:	b8 0b 00 00 00       	mov    $0xb,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <sbrk>:
SYSCALL(sbrk)
 262:	b8 0c 00 00 00       	mov    $0xc,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <sleep>:
SYSCALL(sleep)
 26a:	b8 0d 00 00 00       	mov    $0xd,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <uptime>:
SYSCALL(uptime)
 272:	b8 0e 00 00 00       	mov    $0xe,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 27a:	b8 16 00 00 00       	mov    $0x16,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <block>:
SYSCALL(block)
 282:	b8 17 00 00 00       	mov    $0x17,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <unblock>:
SYSCALL(unblock)
 28a:	b8 18 00 00 00       	mov    $0x18,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <chmod>:
SYSCALL(chmod)
 292:	b8 19 00 00 00       	mov    $0x19,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 29a:	55                   	push   %ebp
 29b:	89 e5                	mov    %esp,%ebp
 29d:	83 ec 1c             	sub    $0x1c,%esp
 2a0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2a3:	6a 01                	push   $0x1
 2a5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2a8:	52                   	push   %edx
 2a9:	50                   	push   %eax
 2aa:	e8 4b ff ff ff       	call   1fa <write>
}
 2af:	83 c4 10             	add    $0x10,%esp
 2b2:	c9                   	leave  
 2b3:	c3                   	ret    

000002b4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2b4:	55                   	push   %ebp
 2b5:	89 e5                	mov    %esp,%ebp
 2b7:	57                   	push   %edi
 2b8:	56                   	push   %esi
 2b9:	53                   	push   %ebx
 2ba:	83 ec 2c             	sub    $0x2c,%esp
 2bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2c0:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2c2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2c6:	74 04                	je     2cc <printint+0x18>
 2c8:	85 d2                	test   %edx,%edx
 2ca:	78 3c                	js     308 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2cc:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2ce:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 2d5:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2da:	89 c8                	mov    %ecx,%eax
 2dc:	ba 00 00 00 00       	mov    $0x0,%edx
 2e1:	f7 f6                	div    %esi
 2e3:	89 df                	mov    %ebx,%edi
 2e5:	43                   	inc    %ebx
 2e6:	8a 92 48 06 00 00    	mov    0x648(%edx),%dl
 2ec:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2f0:	89 ca                	mov    %ecx,%edx
 2f2:	89 c1                	mov    %eax,%ecx
 2f4:	39 f2                	cmp    %esi,%edx
 2f6:	73 e2                	jae    2da <printint+0x26>
  if(neg)
 2f8:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2fc:	74 24                	je     322 <printint+0x6e>
    buf[i++] = '-';
 2fe:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 303:	8d 5f 02             	lea    0x2(%edi),%ebx
 306:	eb 1a                	jmp    322 <printint+0x6e>
    x = -xx;
 308:	89 d1                	mov    %edx,%ecx
 30a:	f7 d9                	neg    %ecx
    neg = 1;
 30c:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 313:	eb c0                	jmp    2d5 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 315:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 31a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 31d:	e8 78 ff ff ff       	call   29a <putc>
  while(--i >= 0)
 322:	4b                   	dec    %ebx
 323:	79 f0                	jns    315 <printint+0x61>
}
 325:	83 c4 2c             	add    $0x2c,%esp
 328:	5b                   	pop    %ebx
 329:	5e                   	pop    %esi
 32a:	5f                   	pop    %edi
 32b:	5d                   	pop    %ebp
 32c:	c3                   	ret    

0000032d <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 32d:	55                   	push   %ebp
 32e:	89 e5                	mov    %esp,%ebp
 330:	57                   	push   %edi
 331:	56                   	push   %esi
 332:	53                   	push   %ebx
 333:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 336:	8d 45 10             	lea    0x10(%ebp),%eax
 339:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 33c:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 341:	bb 00 00 00 00       	mov    $0x0,%ebx
 346:	eb 12                	jmp    35a <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 348:	89 fa                	mov    %edi,%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	e8 48 ff ff ff       	call   29a <putc>
 352:	eb 05                	jmp    359 <printf+0x2c>
      }
    } else if(state == '%'){
 354:	83 fe 25             	cmp    $0x25,%esi
 357:	74 22                	je     37b <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 359:	43                   	inc    %ebx
 35a:	8b 45 0c             	mov    0xc(%ebp),%eax
 35d:	8a 04 18             	mov    (%eax,%ebx,1),%al
 360:	84 c0                	test   %al,%al
 362:	0f 84 1d 01 00 00    	je     485 <printf+0x158>
    c = fmt[i] & 0xff;
 368:	0f be f8             	movsbl %al,%edi
 36b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 36e:	85 f6                	test   %esi,%esi
 370:	75 e2                	jne    354 <printf+0x27>
      if(c == '%'){
 372:	83 f8 25             	cmp    $0x25,%eax
 375:	75 d1                	jne    348 <printf+0x1b>
        state = '%';
 377:	89 c6                	mov    %eax,%esi
 379:	eb de                	jmp    359 <printf+0x2c>
      if(c == 'd'){
 37b:	83 f8 25             	cmp    $0x25,%eax
 37e:	0f 84 cc 00 00 00    	je     450 <printf+0x123>
 384:	0f 8c da 00 00 00    	jl     464 <printf+0x137>
 38a:	83 f8 78             	cmp    $0x78,%eax
 38d:	0f 8f d1 00 00 00    	jg     464 <printf+0x137>
 393:	83 f8 63             	cmp    $0x63,%eax
 396:	0f 8c c8 00 00 00    	jl     464 <printf+0x137>
 39c:	83 e8 63             	sub    $0x63,%eax
 39f:	83 f8 15             	cmp    $0x15,%eax
 3a2:	0f 87 bc 00 00 00    	ja     464 <printf+0x137>
 3a8:	ff 24 85 f0 05 00 00 	jmp    *0x5f0(,%eax,4)
        printint(fd, *ap, 10, 1);
 3af:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3b2:	8b 17                	mov    (%edi),%edx
 3b4:	83 ec 0c             	sub    $0xc,%esp
 3b7:	6a 01                	push   $0x1
 3b9:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3be:	8b 45 08             	mov    0x8(%ebp),%eax
 3c1:	e8 ee fe ff ff       	call   2b4 <printint>
        ap++;
 3c6:	83 c7 04             	add    $0x4,%edi
 3c9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3cc:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3cf:	be 00 00 00 00       	mov    $0x0,%esi
 3d4:	eb 83                	jmp    359 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3d6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d9:	8b 17                	mov    (%edi),%edx
 3db:	83 ec 0c             	sub    $0xc,%esp
 3de:	6a 00                	push   $0x0
 3e0:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	e8 c7 fe ff ff       	call   2b4 <printint>
        ap++;
 3ed:	83 c7 04             	add    $0x4,%edi
 3f0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f6:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 3fb:	e9 59 ff ff ff       	jmp    359 <printf+0x2c>
        s = (char*)*ap;
 400:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 403:	8b 30                	mov    (%eax),%esi
        ap++;
 405:	83 c0 04             	add    $0x4,%eax
 408:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 40b:	85 f6                	test   %esi,%esi
 40d:	75 13                	jne    422 <printf+0xf5>
          s = "(null)";
 40f:	be e8 05 00 00       	mov    $0x5e8,%esi
 414:	eb 0c                	jmp    422 <printf+0xf5>
          putc(fd, *s);
 416:	0f be d2             	movsbl %dl,%edx
 419:	8b 45 08             	mov    0x8(%ebp),%eax
 41c:	e8 79 fe ff ff       	call   29a <putc>
          s++;
 421:	46                   	inc    %esi
        while(*s != 0){
 422:	8a 16                	mov    (%esi),%dl
 424:	84 d2                	test   %dl,%dl
 426:	75 ee                	jne    416 <printf+0xe9>
      state = 0;
 428:	be 00 00 00 00       	mov    $0x0,%esi
 42d:	e9 27 ff ff ff       	jmp    359 <printf+0x2c>
        putc(fd, *ap);
 432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 435:	0f be 17             	movsbl (%edi),%edx
 438:	8b 45 08             	mov    0x8(%ebp),%eax
 43b:	e8 5a fe ff ff       	call   29a <putc>
        ap++;
 440:	83 c7 04             	add    $0x4,%edi
 443:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 446:	be 00 00 00 00       	mov    $0x0,%esi
 44b:	e9 09 ff ff ff       	jmp    359 <printf+0x2c>
        putc(fd, c);
 450:	89 fa                	mov    %edi,%edx
 452:	8b 45 08             	mov    0x8(%ebp),%eax
 455:	e8 40 fe ff ff       	call   29a <putc>
      state = 0;
 45a:	be 00 00 00 00       	mov    $0x0,%esi
 45f:	e9 f5 fe ff ff       	jmp    359 <printf+0x2c>
        putc(fd, '%');
 464:	ba 25 00 00 00       	mov    $0x25,%edx
 469:	8b 45 08             	mov    0x8(%ebp),%eax
 46c:	e8 29 fe ff ff       	call   29a <putc>
        putc(fd, c);
 471:	89 fa                	mov    %edi,%edx
 473:	8b 45 08             	mov    0x8(%ebp),%eax
 476:	e8 1f fe ff ff       	call   29a <putc>
      state = 0;
 47b:	be 00 00 00 00       	mov    $0x0,%esi
 480:	e9 d4 fe ff ff       	jmp    359 <printf+0x2c>
    }
  }
}
 485:	8d 65 f4             	lea    -0xc(%ebp),%esp
 488:	5b                   	pop    %ebx
 489:	5e                   	pop    %esi
 48a:	5f                   	pop    %edi
 48b:	5d                   	pop    %ebp
 48c:	c3                   	ret    

0000048d <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 48d:	55                   	push   %ebp
 48e:	89 e5                	mov    %esp,%ebp
 490:	57                   	push   %edi
 491:	56                   	push   %esi
 492:	53                   	push   %ebx
 493:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 496:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 499:	a1 5c 06 00 00       	mov    0x65c,%eax
 49e:	eb 02                	jmp    4a2 <free+0x15>
 4a0:	89 d0                	mov    %edx,%eax
 4a2:	39 c8                	cmp    %ecx,%eax
 4a4:	73 04                	jae    4aa <free+0x1d>
 4a6:	3b 08                	cmp    (%eax),%ecx
 4a8:	72 12                	jb     4bc <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4aa:	8b 10                	mov    (%eax),%edx
 4ac:	39 d0                	cmp    %edx,%eax
 4ae:	72 f0                	jb     4a0 <free+0x13>
 4b0:	39 c8                	cmp    %ecx,%eax
 4b2:	72 08                	jb     4bc <free+0x2f>
 4b4:	39 d1                	cmp    %edx,%ecx
 4b6:	72 04                	jb     4bc <free+0x2f>
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	eb e6                	jmp    4a2 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4bc:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4bf:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4c2:	8b 10                	mov    (%eax),%edx
 4c4:	39 d7                	cmp    %edx,%edi
 4c6:	74 19                	je     4e1 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4c8:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4cb:	8b 50 04             	mov    0x4(%eax),%edx
 4ce:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4d1:	39 ce                	cmp    %ecx,%esi
 4d3:	74 1b                	je     4f0 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4d5:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4d7:	a3 5c 06 00 00       	mov    %eax,0x65c
}
 4dc:	5b                   	pop    %ebx
 4dd:	5e                   	pop    %esi
 4de:	5f                   	pop    %edi
 4df:	5d                   	pop    %ebp
 4e0:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4e1:	03 72 04             	add    0x4(%edx),%esi
 4e4:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4e7:	8b 10                	mov    (%eax),%edx
 4e9:	8b 12                	mov    (%edx),%edx
 4eb:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4ee:	eb db                	jmp    4cb <free+0x3e>
    p->s.size += bp->s.size;
 4f0:	03 53 fc             	add    -0x4(%ebx),%edx
 4f3:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4f6:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4f9:	89 10                	mov    %edx,(%eax)
 4fb:	eb da                	jmp    4d7 <free+0x4a>

000004fd <morecore>:

static Header*
morecore(uint nu)
{
 4fd:	55                   	push   %ebp
 4fe:	89 e5                	mov    %esp,%ebp
 500:	53                   	push   %ebx
 501:	83 ec 04             	sub    $0x4,%esp
 504:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 506:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 50b:	77 05                	ja     512 <morecore+0x15>
    nu = 4096;
 50d:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 512:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 519:	83 ec 0c             	sub    $0xc,%esp
 51c:	50                   	push   %eax
 51d:	e8 40 fd ff ff       	call   262 <sbrk>
  if(p == (char*)-1)
 522:	83 c4 10             	add    $0x10,%esp
 525:	83 f8 ff             	cmp    $0xffffffff,%eax
 528:	74 1c                	je     546 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 52a:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 52d:	83 c0 08             	add    $0x8,%eax
 530:	83 ec 0c             	sub    $0xc,%esp
 533:	50                   	push   %eax
 534:	e8 54 ff ff ff       	call   48d <free>
  return freep;
 539:	a1 5c 06 00 00       	mov    0x65c,%eax
 53e:	83 c4 10             	add    $0x10,%esp
}
 541:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 544:	c9                   	leave  
 545:	c3                   	ret    
    return 0;
 546:	b8 00 00 00 00       	mov    $0x0,%eax
 54b:	eb f4                	jmp    541 <morecore+0x44>

0000054d <malloc>:

void*
malloc(uint nbytes)
{
 54d:	55                   	push   %ebp
 54e:	89 e5                	mov    %esp,%ebp
 550:	53                   	push   %ebx
 551:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	8d 58 07             	lea    0x7(%eax),%ebx
 55a:	c1 eb 03             	shr    $0x3,%ebx
 55d:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 55e:	8b 0d 5c 06 00 00    	mov    0x65c,%ecx
 564:	85 c9                	test   %ecx,%ecx
 566:	74 04                	je     56c <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 568:	8b 01                	mov    (%ecx),%eax
 56a:	eb 4a                	jmp    5b6 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 56c:	c7 05 5c 06 00 00 60 	movl   $0x660,0x65c
 573:	06 00 00 
 576:	c7 05 60 06 00 00 60 	movl   $0x660,0x660
 57d:	06 00 00 
    base.s.size = 0;
 580:	c7 05 64 06 00 00 00 	movl   $0x0,0x664
 587:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 58a:	b9 60 06 00 00       	mov    $0x660,%ecx
 58f:	eb d7                	jmp    568 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 591:	74 19                	je     5ac <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 593:	29 da                	sub    %ebx,%edx
 595:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 598:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 59b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 59e:	89 0d 5c 06 00 00    	mov    %ecx,0x65c
      return (void*)(p + 1);
 5a4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5a7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5aa:	c9                   	leave  
 5ab:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5ac:	8b 10                	mov    (%eax),%edx
 5ae:	89 11                	mov    %edx,(%ecx)
 5b0:	eb ec                	jmp    59e <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b2:	89 c1                	mov    %eax,%ecx
 5b4:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5b6:	8b 50 04             	mov    0x4(%eax),%edx
 5b9:	39 da                	cmp    %ebx,%edx
 5bb:	73 d4                	jae    591 <malloc+0x44>
    if(p == freep)
 5bd:	39 05 5c 06 00 00    	cmp    %eax,0x65c
 5c3:	75 ed                	jne    5b2 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 5c5:	89 d8                	mov    %ebx,%eax
 5c7:	e8 31 ff ff ff       	call   4fd <morecore>
 5cc:	85 c0                	test   %eax,%eax
 5ce:	75 e2                	jne    5b2 <malloc+0x65>
 5d0:	eb d5                	jmp    5a7 <malloc+0x5a>
