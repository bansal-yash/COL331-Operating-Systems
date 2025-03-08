
_rm:     file format elf32-i386


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
  11:	83 ec 18             	sub    $0x18,%esp
  14:	8b 39                	mov    (%ecx),%edi
  16:	8b 41 04             	mov    0x4(%ecx),%eax
  19:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int i;

  if(argc < 2){
  1c:	83 ff 01             	cmp    $0x1,%edi
  1f:	7e 07                	jle    28 <main+0x28>
    printf(2, "Usage: rm files...\n");
    exit();
  }

  for(i = 1; i < argc; i++){
  21:	bb 01 00 00 00       	mov    $0x1,%ebx
  26:	eb 15                	jmp    3d <main+0x3d>
    printf(2, "Usage: rm files...\n");
  28:	83 ec 08             	sub    $0x8,%esp
  2b:	68 ec 05 00 00       	push   $0x5ec
  30:	6a 02                	push   $0x2
  32:	e8 0e 03 00 00       	call   345 <printf>
    exit();
  37:	e8 b6 01 00 00       	call   1f2 <exit>
  for(i = 1; i < argc; i++){
  3c:	43                   	inc    %ebx
  3d:	39 fb                	cmp    %edi,%ebx
  3f:	7d 2b                	jge    6c <main+0x6c>
    if(unlink(argv[i]) < 0){
  41:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  44:	8d 34 98             	lea    (%eax,%ebx,4),%esi
  47:	83 ec 0c             	sub    $0xc,%esp
  4a:	ff 36                	pushl  (%esi)
  4c:	e8 f1 01 00 00       	call   242 <unlink>
  51:	83 c4 10             	add    $0x10,%esp
  54:	85 c0                	test   %eax,%eax
  56:	79 e4                	jns    3c <main+0x3c>
      printf(2, "rm: %s failed to delete\n", argv[i]);
  58:	83 ec 04             	sub    $0x4,%esp
  5b:	ff 36                	pushl  (%esi)
  5d:	68 00 06 00 00       	push   $0x600
  62:	6a 02                	push   $0x2
  64:	e8 dc 02 00 00       	call   345 <printf>
      break;
  69:	83 c4 10             	add    $0x10,%esp
    }
  }

  exit();
  6c:	e8 81 01 00 00       	call   1f2 <exit>

00000071 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	56                   	push   %esi
  75:	53                   	push   %ebx
  76:	8b 45 08             	mov    0x8(%ebp),%eax
  79:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7c:	89 c2                	mov    %eax,%edx
  7e:	89 cb                	mov    %ecx,%ebx
  80:	41                   	inc    %ecx
  81:	89 d6                	mov    %edx,%esi
  83:	42                   	inc    %edx
  84:	8a 1b                	mov    (%ebx),%bl
  86:	88 1e                	mov    %bl,(%esi)
  88:	84 db                	test   %bl,%bl
  8a:	75 f2                	jne    7e <strcpy+0xd>
    ;
  return os;
}
  8c:	5b                   	pop    %ebx
  8d:	5e                   	pop    %esi
  8e:	5d                   	pop    %ebp
  8f:	c3                   	ret    

00000090 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  90:	55                   	push   %ebp
  91:	89 e5                	mov    %esp,%ebp
  93:	8b 4d 08             	mov    0x8(%ebp),%ecx
  96:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  99:	eb 02                	jmp    9d <strcmp+0xd>
    p++, q++;
  9b:	41                   	inc    %ecx
  9c:	42                   	inc    %edx
  while(*p && *p == *q)
  9d:	8a 01                	mov    (%ecx),%al
  9f:	84 c0                	test   %al,%al
  a1:	74 04                	je     a7 <strcmp+0x17>
  a3:	3a 02                	cmp    (%edx),%al
  a5:	74 f4                	je     9b <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  a7:	0f b6 c0             	movzbl %al,%eax
  aa:	0f b6 12             	movzbl (%edx),%edx
  ad:	29 d0                	sub    %edx,%eax
}
  af:	5d                   	pop    %ebp
  b0:	c3                   	ret    

000000b1 <strlen>:

uint
strlen(const char *s)
{
  b1:	55                   	push   %ebp
  b2:	89 e5                	mov    %esp,%ebp
  b4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b7:	b8 00 00 00 00       	mov    $0x0,%eax
  bc:	eb 01                	jmp    bf <strlen+0xe>
  be:	40                   	inc    %eax
  bf:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c3:	75 f9                	jne    be <strlen+0xd>
    ;
  return n;
}
  c5:	5d                   	pop    %ebp
  c6:	c3                   	ret    

000000c7 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c7:	55                   	push   %ebp
  c8:	89 e5                	mov    %esp,%ebp
  ca:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  cb:	8b 7d 08             	mov    0x8(%ebp),%edi
  ce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  d4:	fc                   	cld    
  d5:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  d7:	8b 45 08             	mov    0x8(%ebp),%eax
  da:	8b 7d fc             	mov    -0x4(%ebp),%edi
  dd:	c9                   	leave  
  de:	c3                   	ret    

000000df <strchr>:

char*
strchr(const char *s, char c)
{
  df:	55                   	push   %ebp
  e0:	89 e5                	mov    %esp,%ebp
  e2:	8b 45 08             	mov    0x8(%ebp),%eax
  e5:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  e8:	eb 01                	jmp    eb <strchr+0xc>
  ea:	40                   	inc    %eax
  eb:	8a 10                	mov    (%eax),%dl
  ed:	84 d2                	test   %dl,%dl
  ef:	74 06                	je     f7 <strchr+0x18>
    if(*s == c)
  f1:	38 ca                	cmp    %cl,%dl
  f3:	75 f5                	jne    ea <strchr+0xb>
  f5:	eb 05                	jmp    fc <strchr+0x1d>
      return (char*)s;
  return 0;
  f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    

000000fe <gets>:

char*
gets(char *buf, int max)
{
  fe:	55                   	push   %ebp
  ff:	89 e5                	mov    %esp,%ebp
 101:	57                   	push   %edi
 102:	56                   	push   %esi
 103:	53                   	push   %ebx
 104:	83 ec 1c             	sub    $0x1c,%esp
 107:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 10a:	bb 00 00 00 00       	mov    $0x0,%ebx
 10f:	89 de                	mov    %ebx,%esi
 111:	43                   	inc    %ebx
 112:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 115:	7d 2b                	jge    142 <gets+0x44>
    cc = read(0, &c, 1);
 117:	83 ec 04             	sub    $0x4,%esp
 11a:	6a 01                	push   $0x1
 11c:	8d 45 e7             	lea    -0x19(%ebp),%eax
 11f:	50                   	push   %eax
 120:	6a 00                	push   $0x0
 122:	e8 e3 00 00 00       	call   20a <read>
    if(cc < 1)
 127:	83 c4 10             	add    $0x10,%esp
 12a:	85 c0                	test   %eax,%eax
 12c:	7e 14                	jle    142 <gets+0x44>
      break;
    buf[i++] = c;
 12e:	8a 45 e7             	mov    -0x19(%ebp),%al
 131:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 134:	3c 0a                	cmp    $0xa,%al
 136:	74 08                	je     140 <gets+0x42>
 138:	3c 0d                	cmp    $0xd,%al
 13a:	75 d3                	jne    10f <gets+0x11>
    buf[i++] = c;
 13c:	89 de                	mov    %ebx,%esi
 13e:	eb 02                	jmp    142 <gets+0x44>
 140:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 142:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 146:	89 f8                	mov    %edi,%eax
 148:	8d 65 f4             	lea    -0xc(%ebp),%esp
 14b:	5b                   	pop    %ebx
 14c:	5e                   	pop    %esi
 14d:	5f                   	pop    %edi
 14e:	5d                   	pop    %ebp
 14f:	c3                   	ret    

00000150 <stat>:

int
stat(const char *n, struct stat *st)
{
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	56                   	push   %esi
 154:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 155:	83 ec 08             	sub    $0x8,%esp
 158:	6a 00                	push   $0x0
 15a:	ff 75 08             	pushl  0x8(%ebp)
 15d:	e8 d0 00 00 00       	call   232 <open>
  if(fd < 0)
 162:	83 c4 10             	add    $0x10,%esp
 165:	85 c0                	test   %eax,%eax
 167:	78 24                	js     18d <stat+0x3d>
 169:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 16b:	83 ec 08             	sub    $0x8,%esp
 16e:	ff 75 0c             	pushl  0xc(%ebp)
 171:	50                   	push   %eax
 172:	e8 d3 00 00 00       	call   24a <fstat>
 177:	89 c6                	mov    %eax,%esi
  close(fd);
 179:	89 1c 24             	mov    %ebx,(%esp)
 17c:	e8 99 00 00 00       	call   21a <close>
  return r;
 181:	83 c4 10             	add    $0x10,%esp
}
 184:	89 f0                	mov    %esi,%eax
 186:	8d 65 f8             	lea    -0x8(%ebp),%esp
 189:	5b                   	pop    %ebx
 18a:	5e                   	pop    %esi
 18b:	5d                   	pop    %ebp
 18c:	c3                   	ret    
    return -1;
 18d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 192:	eb f0                	jmp    184 <stat+0x34>

00000194 <atoi>:

int
atoi(const char *s)
{
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	53                   	push   %ebx
 198:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 19b:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1a0:	eb 0e                	jmp    1b0 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 1a2:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1a5:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 1a8:	41                   	inc    %ecx
 1a9:	0f be c0             	movsbl %al,%eax
 1ac:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 1b0:	8a 01                	mov    (%ecx),%al
 1b2:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1b5:	80 fb 09             	cmp    $0x9,%bl
 1b8:	76 e8                	jbe    1a2 <atoi+0xe>
  return n;
}
 1ba:	89 d0                	mov    %edx,%eax
 1bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 1bf:	c9                   	leave  
 1c0:	c3                   	ret    

000001c1 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1c1:	55                   	push   %ebp
 1c2:	89 e5                	mov    %esp,%ebp
 1c4:	56                   	push   %esi
 1c5:	53                   	push   %ebx
 1c6:	8b 45 08             	mov    0x8(%ebp),%eax
 1c9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1cc:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1cf:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1d1:	eb 0c                	jmp    1df <memmove+0x1e>
    *dst++ = *src++;
 1d3:	8a 13                	mov    (%ebx),%dl
 1d5:	88 11                	mov    %dl,(%ecx)
 1d7:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1da:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1dd:	89 f2                	mov    %esi,%edx
 1df:	8d 72 ff             	lea    -0x1(%edx),%esi
 1e2:	85 d2                	test   %edx,%edx
 1e4:	7f ed                	jg     1d3 <memmove+0x12>
  return vdst;
}
 1e6:	5b                   	pop    %ebx
 1e7:	5e                   	pop    %esi
 1e8:	5d                   	pop    %ebp
 1e9:	c3                   	ret    

000001ea <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1ea:	b8 01 00 00 00       	mov    $0x1,%eax
 1ef:	cd 40                	int    $0x40
 1f1:	c3                   	ret    

000001f2 <exit>:
SYSCALL(exit)
 1f2:	b8 02 00 00 00       	mov    $0x2,%eax
 1f7:	cd 40                	int    $0x40
 1f9:	c3                   	ret    

000001fa <wait>:
SYSCALL(wait)
 1fa:	b8 03 00 00 00       	mov    $0x3,%eax
 1ff:	cd 40                	int    $0x40
 201:	c3                   	ret    

00000202 <pipe>:
SYSCALL(pipe)
 202:	b8 04 00 00 00       	mov    $0x4,%eax
 207:	cd 40                	int    $0x40
 209:	c3                   	ret    

0000020a <read>:
SYSCALL(read)
 20a:	b8 05 00 00 00       	mov    $0x5,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <write>:
SYSCALL(write)
 212:	b8 10 00 00 00       	mov    $0x10,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <close>:
SYSCALL(close)
 21a:	b8 15 00 00 00       	mov    $0x15,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <kill>:
SYSCALL(kill)
 222:	b8 06 00 00 00       	mov    $0x6,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <exec>:
SYSCALL(exec)
 22a:	b8 07 00 00 00       	mov    $0x7,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <open>:
SYSCALL(open)
 232:	b8 0f 00 00 00       	mov    $0xf,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <mknod>:
SYSCALL(mknod)
 23a:	b8 11 00 00 00       	mov    $0x11,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <unlink>:
SYSCALL(unlink)
 242:	b8 12 00 00 00       	mov    $0x12,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <fstat>:
SYSCALL(fstat)
 24a:	b8 08 00 00 00       	mov    $0x8,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <link>:
SYSCALL(link)
 252:	b8 13 00 00 00       	mov    $0x13,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mkdir>:
SYSCALL(mkdir)
 25a:	b8 14 00 00 00       	mov    $0x14,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <chdir>:
SYSCALL(chdir)
 262:	b8 09 00 00 00       	mov    $0x9,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <dup>:
SYSCALL(dup)
 26a:	b8 0a 00 00 00       	mov    $0xa,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <getpid>:
SYSCALL(getpid)
 272:	b8 0b 00 00 00       	mov    $0xb,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <sbrk>:
SYSCALL(sbrk)
 27a:	b8 0c 00 00 00       	mov    $0xc,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <sleep>:
SYSCALL(sleep)
 282:	b8 0d 00 00 00       	mov    $0xd,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <uptime>:
SYSCALL(uptime)
 28a:	b8 0e 00 00 00       	mov    $0xe,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 292:	b8 16 00 00 00       	mov    $0x16,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <block>:
SYSCALL(block)
 29a:	b8 17 00 00 00       	mov    $0x17,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <unblock>:
SYSCALL(unblock)
 2a2:	b8 18 00 00 00       	mov    $0x18,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <chmod>:
SYSCALL(chmod)
 2aa:	b8 19 00 00 00       	mov    $0x19,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2b2:	55                   	push   %ebp
 2b3:	89 e5                	mov    %esp,%ebp
 2b5:	83 ec 1c             	sub    $0x1c,%esp
 2b8:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2bb:	6a 01                	push   $0x1
 2bd:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c0:	52                   	push   %edx
 2c1:	50                   	push   %eax
 2c2:	e8 4b ff ff ff       	call   212 <write>
}
 2c7:	83 c4 10             	add    $0x10,%esp
 2ca:	c9                   	leave  
 2cb:	c3                   	ret    

000002cc <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2cc:	55                   	push   %ebp
 2cd:	89 e5                	mov    %esp,%ebp
 2cf:	57                   	push   %edi
 2d0:	56                   	push   %esi
 2d1:	53                   	push   %ebx
 2d2:	83 ec 2c             	sub    $0x2c,%esp
 2d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2d8:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2de:	74 04                	je     2e4 <printint+0x18>
 2e0:	85 d2                	test   %edx,%edx
 2e2:	78 3c                	js     320 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2e4:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2e6:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 2ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2f2:	89 c8                	mov    %ecx,%eax
 2f4:	ba 00 00 00 00       	mov    $0x0,%edx
 2f9:	f7 f6                	div    %esi
 2fb:	89 df                	mov    %ebx,%edi
 2fd:	43                   	inc    %ebx
 2fe:	8a 92 78 06 00 00    	mov    0x678(%edx),%dl
 304:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 308:	89 ca                	mov    %ecx,%edx
 30a:	89 c1                	mov    %eax,%ecx
 30c:	39 f2                	cmp    %esi,%edx
 30e:	73 e2                	jae    2f2 <printint+0x26>
  if(neg)
 310:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 314:	74 24                	je     33a <printint+0x6e>
    buf[i++] = '-';
 316:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 31b:	8d 5f 02             	lea    0x2(%edi),%ebx
 31e:	eb 1a                	jmp    33a <printint+0x6e>
    x = -xx;
 320:	89 d1                	mov    %edx,%ecx
 322:	f7 d9                	neg    %ecx
    neg = 1;
 324:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 32b:	eb c0                	jmp    2ed <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 32d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 332:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 335:	e8 78 ff ff ff       	call   2b2 <putc>
  while(--i >= 0)
 33a:	4b                   	dec    %ebx
 33b:	79 f0                	jns    32d <printint+0x61>
}
 33d:	83 c4 2c             	add    $0x2c,%esp
 340:	5b                   	pop    %ebx
 341:	5e                   	pop    %esi
 342:	5f                   	pop    %edi
 343:	5d                   	pop    %ebp
 344:	c3                   	ret    

00000345 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 345:	55                   	push   %ebp
 346:	89 e5                	mov    %esp,%ebp
 348:	57                   	push   %edi
 349:	56                   	push   %esi
 34a:	53                   	push   %ebx
 34b:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 34e:	8d 45 10             	lea    0x10(%ebp),%eax
 351:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 354:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 359:	bb 00 00 00 00       	mov    $0x0,%ebx
 35e:	eb 12                	jmp    372 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 360:	89 fa                	mov    %edi,%edx
 362:	8b 45 08             	mov    0x8(%ebp),%eax
 365:	e8 48 ff ff ff       	call   2b2 <putc>
 36a:	eb 05                	jmp    371 <printf+0x2c>
      }
    } else if(state == '%'){
 36c:	83 fe 25             	cmp    $0x25,%esi
 36f:	74 22                	je     393 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 371:	43                   	inc    %ebx
 372:	8b 45 0c             	mov    0xc(%ebp),%eax
 375:	8a 04 18             	mov    (%eax,%ebx,1),%al
 378:	84 c0                	test   %al,%al
 37a:	0f 84 1d 01 00 00    	je     49d <printf+0x158>
    c = fmt[i] & 0xff;
 380:	0f be f8             	movsbl %al,%edi
 383:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 386:	85 f6                	test   %esi,%esi
 388:	75 e2                	jne    36c <printf+0x27>
      if(c == '%'){
 38a:	83 f8 25             	cmp    $0x25,%eax
 38d:	75 d1                	jne    360 <printf+0x1b>
        state = '%';
 38f:	89 c6                	mov    %eax,%esi
 391:	eb de                	jmp    371 <printf+0x2c>
      if(c == 'd'){
 393:	83 f8 25             	cmp    $0x25,%eax
 396:	0f 84 cc 00 00 00    	je     468 <printf+0x123>
 39c:	0f 8c da 00 00 00    	jl     47c <printf+0x137>
 3a2:	83 f8 78             	cmp    $0x78,%eax
 3a5:	0f 8f d1 00 00 00    	jg     47c <printf+0x137>
 3ab:	83 f8 63             	cmp    $0x63,%eax
 3ae:	0f 8c c8 00 00 00    	jl     47c <printf+0x137>
 3b4:	83 e8 63             	sub    $0x63,%eax
 3b7:	83 f8 15             	cmp    $0x15,%eax
 3ba:	0f 87 bc 00 00 00    	ja     47c <printf+0x137>
 3c0:	ff 24 85 20 06 00 00 	jmp    *0x620(,%eax,4)
        printint(fd, *ap, 10, 1);
 3c7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ca:	8b 17                	mov    (%edi),%edx
 3cc:	83 ec 0c             	sub    $0xc,%esp
 3cf:	6a 01                	push   $0x1
 3d1:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3d6:	8b 45 08             	mov    0x8(%ebp),%eax
 3d9:	e8 ee fe ff ff       	call   2cc <printint>
        ap++;
 3de:	83 c7 04             	add    $0x4,%edi
 3e1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3e4:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3e7:	be 00 00 00 00       	mov    $0x0,%esi
 3ec:	eb 83                	jmp    371 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3ee:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3f1:	8b 17                	mov    (%edi),%edx
 3f3:	83 ec 0c             	sub    $0xc,%esp
 3f6:	6a 00                	push   $0x0
 3f8:	b9 10 00 00 00       	mov    $0x10,%ecx
 3fd:	8b 45 08             	mov    0x8(%ebp),%eax
 400:	e8 c7 fe ff ff       	call   2cc <printint>
        ap++;
 405:	83 c7 04             	add    $0x4,%edi
 408:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 40b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 40e:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 413:	e9 59 ff ff ff       	jmp    371 <printf+0x2c>
        s = (char*)*ap;
 418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 41b:	8b 30                	mov    (%eax),%esi
        ap++;
 41d:	83 c0 04             	add    $0x4,%eax
 420:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 423:	85 f6                	test   %esi,%esi
 425:	75 13                	jne    43a <printf+0xf5>
          s = "(null)";
 427:	be 19 06 00 00       	mov    $0x619,%esi
 42c:	eb 0c                	jmp    43a <printf+0xf5>
          putc(fd, *s);
 42e:	0f be d2             	movsbl %dl,%edx
 431:	8b 45 08             	mov    0x8(%ebp),%eax
 434:	e8 79 fe ff ff       	call   2b2 <putc>
          s++;
 439:	46                   	inc    %esi
        while(*s != 0){
 43a:	8a 16                	mov    (%esi),%dl
 43c:	84 d2                	test   %dl,%dl
 43e:	75 ee                	jne    42e <printf+0xe9>
      state = 0;
 440:	be 00 00 00 00       	mov    $0x0,%esi
 445:	e9 27 ff ff ff       	jmp    371 <printf+0x2c>
        putc(fd, *ap);
 44a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 44d:	0f be 17             	movsbl (%edi),%edx
 450:	8b 45 08             	mov    0x8(%ebp),%eax
 453:	e8 5a fe ff ff       	call   2b2 <putc>
        ap++;
 458:	83 c7 04             	add    $0x4,%edi
 45b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 45e:	be 00 00 00 00       	mov    $0x0,%esi
 463:	e9 09 ff ff ff       	jmp    371 <printf+0x2c>
        putc(fd, c);
 468:	89 fa                	mov    %edi,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	e8 40 fe ff ff       	call   2b2 <putc>
      state = 0;
 472:	be 00 00 00 00       	mov    $0x0,%esi
 477:	e9 f5 fe ff ff       	jmp    371 <printf+0x2c>
        putc(fd, '%');
 47c:	ba 25 00 00 00       	mov    $0x25,%edx
 481:	8b 45 08             	mov    0x8(%ebp),%eax
 484:	e8 29 fe ff ff       	call   2b2 <putc>
        putc(fd, c);
 489:	89 fa                	mov    %edi,%edx
 48b:	8b 45 08             	mov    0x8(%ebp),%eax
 48e:	e8 1f fe ff ff       	call   2b2 <putc>
      state = 0;
 493:	be 00 00 00 00       	mov    $0x0,%esi
 498:	e9 d4 fe ff ff       	jmp    371 <printf+0x2c>
    }
  }
}
 49d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a0:	5b                   	pop    %ebx
 4a1:	5e                   	pop    %esi
 4a2:	5f                   	pop    %edi
 4a3:	5d                   	pop    %ebp
 4a4:	c3                   	ret    

000004a5 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4a5:	55                   	push   %ebp
 4a6:	89 e5                	mov    %esp,%ebp
 4a8:	57                   	push   %edi
 4a9:	56                   	push   %esi
 4aa:	53                   	push   %ebx
 4ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4ae:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4b1:	a1 8c 06 00 00       	mov    0x68c,%eax
 4b6:	eb 02                	jmp    4ba <free+0x15>
 4b8:	89 d0                	mov    %edx,%eax
 4ba:	39 c8                	cmp    %ecx,%eax
 4bc:	73 04                	jae    4c2 <free+0x1d>
 4be:	3b 08                	cmp    (%eax),%ecx
 4c0:	72 12                	jb     4d4 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4c2:	8b 10                	mov    (%eax),%edx
 4c4:	39 d0                	cmp    %edx,%eax
 4c6:	72 f0                	jb     4b8 <free+0x13>
 4c8:	39 c8                	cmp    %ecx,%eax
 4ca:	72 08                	jb     4d4 <free+0x2f>
 4cc:	39 d1                	cmp    %edx,%ecx
 4ce:	72 04                	jb     4d4 <free+0x2f>
 4d0:	89 d0                	mov    %edx,%eax
 4d2:	eb e6                	jmp    4ba <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4d4:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4d7:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4da:	8b 10                	mov    (%eax),%edx
 4dc:	39 d7                	cmp    %edx,%edi
 4de:	74 19                	je     4f9 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4e0:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4e3:	8b 50 04             	mov    0x4(%eax),%edx
 4e6:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4e9:	39 ce                	cmp    %ecx,%esi
 4eb:	74 1b                	je     508 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4ed:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4ef:	a3 8c 06 00 00       	mov    %eax,0x68c
}
 4f4:	5b                   	pop    %ebx
 4f5:	5e                   	pop    %esi
 4f6:	5f                   	pop    %edi
 4f7:	5d                   	pop    %ebp
 4f8:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4f9:	03 72 04             	add    0x4(%edx),%esi
 4fc:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4ff:	8b 10                	mov    (%eax),%edx
 501:	8b 12                	mov    (%edx),%edx
 503:	89 53 f8             	mov    %edx,-0x8(%ebx)
 506:	eb db                	jmp    4e3 <free+0x3e>
    p->s.size += bp->s.size;
 508:	03 53 fc             	add    -0x4(%ebx),%edx
 50b:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 50e:	8b 53 f8             	mov    -0x8(%ebx),%edx
 511:	89 10                	mov    %edx,(%eax)
 513:	eb da                	jmp    4ef <free+0x4a>

00000515 <morecore>:

static Header*
morecore(uint nu)
{
 515:	55                   	push   %ebp
 516:	89 e5                	mov    %esp,%ebp
 518:	53                   	push   %ebx
 519:	83 ec 04             	sub    $0x4,%esp
 51c:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 51e:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 523:	77 05                	ja     52a <morecore+0x15>
    nu = 4096;
 525:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 52a:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 531:	83 ec 0c             	sub    $0xc,%esp
 534:	50                   	push   %eax
 535:	e8 40 fd ff ff       	call   27a <sbrk>
  if(p == (char*)-1)
 53a:	83 c4 10             	add    $0x10,%esp
 53d:	83 f8 ff             	cmp    $0xffffffff,%eax
 540:	74 1c                	je     55e <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 542:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 545:	83 c0 08             	add    $0x8,%eax
 548:	83 ec 0c             	sub    $0xc,%esp
 54b:	50                   	push   %eax
 54c:	e8 54 ff ff ff       	call   4a5 <free>
  return freep;
 551:	a1 8c 06 00 00       	mov    0x68c,%eax
 556:	83 c4 10             	add    $0x10,%esp
}
 559:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 55c:	c9                   	leave  
 55d:	c3                   	ret    
    return 0;
 55e:	b8 00 00 00 00       	mov    $0x0,%eax
 563:	eb f4                	jmp    559 <morecore+0x44>

00000565 <malloc>:

void*
malloc(uint nbytes)
{
 565:	55                   	push   %ebp
 566:	89 e5                	mov    %esp,%ebp
 568:	53                   	push   %ebx
 569:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 56c:	8b 45 08             	mov    0x8(%ebp),%eax
 56f:	8d 58 07             	lea    0x7(%eax),%ebx
 572:	c1 eb 03             	shr    $0x3,%ebx
 575:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 576:	8b 0d 8c 06 00 00    	mov    0x68c,%ecx
 57c:	85 c9                	test   %ecx,%ecx
 57e:	74 04                	je     584 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 580:	8b 01                	mov    (%ecx),%eax
 582:	eb 4a                	jmp    5ce <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 584:	c7 05 8c 06 00 00 90 	movl   $0x690,0x68c
 58b:	06 00 00 
 58e:	c7 05 90 06 00 00 90 	movl   $0x690,0x690
 595:	06 00 00 
    base.s.size = 0;
 598:	c7 05 94 06 00 00 00 	movl   $0x0,0x694
 59f:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5a2:	b9 90 06 00 00       	mov    $0x690,%ecx
 5a7:	eb d7                	jmp    580 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5a9:	74 19                	je     5c4 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5ab:	29 da                	sub    %ebx,%edx
 5ad:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5b0:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5b3:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5b6:	89 0d 8c 06 00 00    	mov    %ecx,0x68c
      return (void*)(p + 1);
 5bc:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5bf:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5c2:	c9                   	leave  
 5c3:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	89 11                	mov    %edx,(%ecx)
 5c8:	eb ec                	jmp    5b6 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ca:	89 c1                	mov    %eax,%ecx
 5cc:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5ce:	8b 50 04             	mov    0x4(%eax),%edx
 5d1:	39 da                	cmp    %ebx,%edx
 5d3:	73 d4                	jae    5a9 <malloc+0x44>
    if(p == freep)
 5d5:	39 05 8c 06 00 00    	cmp    %eax,0x68c
 5db:	75 ed                	jne    5ca <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 5dd:	89 d8                	mov    %ebx,%eax
 5df:	e8 31 ff ff ff       	call   515 <morecore>
 5e4:	85 c0                	test   %eax,%eax
 5e6:	75 e2                	jne    5ca <malloc+0x65>
 5e8:	eb d5                	jmp    5bf <malloc+0x5a>
