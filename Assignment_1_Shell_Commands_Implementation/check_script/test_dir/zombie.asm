
_zombie:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(void)
{
   0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   4:	83 e4 f0             	and    $0xfffffff0,%esp
   7:	ff 71 fc             	pushl  -0x4(%ecx)
   a:	55                   	push   %ebp
   b:	89 e5                	mov    %esp,%ebp
   d:	51                   	push   %ecx
   e:	83 ec 04             	sub    $0x4,%esp
  if(fork() > 0)
  11:	e8 91 01 00 00       	call   1a7 <fork>
  16:	85 c0                	test   %eax,%eax
  18:	7f 05                	jg     1f <main+0x1f>
    sleep(5);  // Let child exit before parent.
  exit();
  1a:	e8 90 01 00 00       	call   1af <exit>
    sleep(5);  // Let child exit before parent.
  1f:	83 ec 0c             	sub    $0xc,%esp
  22:	6a 05                	push   $0x5
  24:	e8 16 02 00 00       	call   23f <sleep>
  29:	83 c4 10             	add    $0x10,%esp
  2c:	eb ec                	jmp    1a <main+0x1a>

0000002e <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	56                   	push   %esi
  32:	53                   	push   %ebx
  33:	8b 45 08             	mov    0x8(%ebp),%eax
  36:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  39:	89 c2                	mov    %eax,%edx
  3b:	89 cb                	mov    %ecx,%ebx
  3d:	41                   	inc    %ecx
  3e:	89 d6                	mov    %edx,%esi
  40:	42                   	inc    %edx
  41:	8a 1b                	mov    (%ebx),%bl
  43:	88 1e                	mov    %bl,(%esi)
  45:	84 db                	test   %bl,%bl
  47:	75 f2                	jne    3b <strcpy+0xd>
    ;
  return os;
}
  49:	5b                   	pop    %ebx
  4a:	5e                   	pop    %esi
  4b:	5d                   	pop    %ebp
  4c:	c3                   	ret    

0000004d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4d:	55                   	push   %ebp
  4e:	89 e5                	mov    %esp,%ebp
  50:	8b 4d 08             	mov    0x8(%ebp),%ecx
  53:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  56:	eb 02                	jmp    5a <strcmp+0xd>
    p++, q++;
  58:	41                   	inc    %ecx
  59:	42                   	inc    %edx
  while(*p && *p == *q)
  5a:	8a 01                	mov    (%ecx),%al
  5c:	84 c0                	test   %al,%al
  5e:	74 04                	je     64 <strcmp+0x17>
  60:	3a 02                	cmp    (%edx),%al
  62:	74 f4                	je     58 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
  64:	0f b6 c0             	movzbl %al,%eax
  67:	0f b6 12             	movzbl (%edx),%edx
  6a:	29 d0                	sub    %edx,%eax
}
  6c:	5d                   	pop    %ebp
  6d:	c3                   	ret    

0000006e <strlen>:

uint
strlen(const char *s)
{
  6e:	55                   	push   %ebp
  6f:	89 e5                	mov    %esp,%ebp
  71:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  74:	b8 00 00 00 00       	mov    $0x0,%eax
  79:	eb 01                	jmp    7c <strlen+0xe>
  7b:	40                   	inc    %eax
  7c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  80:	75 f9                	jne    7b <strlen+0xd>
    ;
  return n;
}
  82:	5d                   	pop    %ebp
  83:	c3                   	ret    

00000084 <memset>:

void*
memset(void *dst, int c, uint n)
{
  84:	55                   	push   %ebp
  85:	89 e5                	mov    %esp,%ebp
  87:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  88:	8b 7d 08             	mov    0x8(%ebp),%edi
  8b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  91:	fc                   	cld    
  92:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  94:	8b 45 08             	mov    0x8(%ebp),%eax
  97:	8b 7d fc             	mov    -0x4(%ebp),%edi
  9a:	c9                   	leave  
  9b:	c3                   	ret    

0000009c <strchr>:

char*
strchr(const char *s, char c)
{
  9c:	55                   	push   %ebp
  9d:	89 e5                	mov    %esp,%ebp
  9f:	8b 45 08             	mov    0x8(%ebp),%eax
  a2:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  a5:	eb 01                	jmp    a8 <strchr+0xc>
  a7:	40                   	inc    %eax
  a8:	8a 10                	mov    (%eax),%dl
  aa:	84 d2                	test   %dl,%dl
  ac:	74 06                	je     b4 <strchr+0x18>
    if(*s == c)
  ae:	38 ca                	cmp    %cl,%dl
  b0:	75 f5                	jne    a7 <strchr+0xb>
  b2:	eb 05                	jmp    b9 <strchr+0x1d>
      return (char*)s;
  return 0;
  b4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  b9:	5d                   	pop    %ebp
  ba:	c3                   	ret    

000000bb <gets>:

char*
gets(char *buf, int max)
{
  bb:	55                   	push   %ebp
  bc:	89 e5                	mov    %esp,%ebp
  be:	57                   	push   %edi
  bf:	56                   	push   %esi
  c0:	53                   	push   %ebx
  c1:	83 ec 1c             	sub    $0x1c,%esp
  c4:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  cc:	89 de                	mov    %ebx,%esi
  ce:	43                   	inc    %ebx
  cf:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  d2:	7d 2b                	jge    ff <gets+0x44>
    cc = read(0, &c, 1);
  d4:	83 ec 04             	sub    $0x4,%esp
  d7:	6a 01                	push   $0x1
  d9:	8d 45 e7             	lea    -0x19(%ebp),%eax
  dc:	50                   	push   %eax
  dd:	6a 00                	push   $0x0
  df:	e8 e3 00 00 00       	call   1c7 <read>
    if(cc < 1)
  e4:	83 c4 10             	add    $0x10,%esp
  e7:	85 c0                	test   %eax,%eax
  e9:	7e 14                	jle    ff <gets+0x44>
      break;
    buf[i++] = c;
  eb:	8a 45 e7             	mov    -0x19(%ebp),%al
  ee:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
  f1:	3c 0a                	cmp    $0xa,%al
  f3:	74 08                	je     fd <gets+0x42>
  f5:	3c 0d                	cmp    $0xd,%al
  f7:	75 d3                	jne    cc <gets+0x11>
    buf[i++] = c;
  f9:	89 de                	mov    %ebx,%esi
  fb:	eb 02                	jmp    ff <gets+0x44>
  fd:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
  ff:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 103:	89 f8                	mov    %edi,%eax
 105:	8d 65 f4             	lea    -0xc(%ebp),%esp
 108:	5b                   	pop    %ebx
 109:	5e                   	pop    %esi
 10a:	5f                   	pop    %edi
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <stat>:

int
stat(const char *n, struct stat *st)
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	56                   	push   %esi
 111:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 112:	83 ec 08             	sub    $0x8,%esp
 115:	6a 00                	push   $0x0
 117:	ff 75 08             	pushl  0x8(%ebp)
 11a:	e8 d0 00 00 00       	call   1ef <open>
  if(fd < 0)
 11f:	83 c4 10             	add    $0x10,%esp
 122:	85 c0                	test   %eax,%eax
 124:	78 24                	js     14a <stat+0x3d>
 126:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 128:	83 ec 08             	sub    $0x8,%esp
 12b:	ff 75 0c             	pushl  0xc(%ebp)
 12e:	50                   	push   %eax
 12f:	e8 d3 00 00 00       	call   207 <fstat>
 134:	89 c6                	mov    %eax,%esi
  close(fd);
 136:	89 1c 24             	mov    %ebx,(%esp)
 139:	e8 99 00 00 00       	call   1d7 <close>
  return r;
 13e:	83 c4 10             	add    $0x10,%esp
}
 141:	89 f0                	mov    %esi,%eax
 143:	8d 65 f8             	lea    -0x8(%ebp),%esp
 146:	5b                   	pop    %ebx
 147:	5e                   	pop    %esi
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    
    return -1;
 14a:	be ff ff ff ff       	mov    $0xffffffff,%esi
 14f:	eb f0                	jmp    141 <stat+0x34>

00000151 <atoi>:

int
atoi(const char *s)
{
 151:	55                   	push   %ebp
 152:	89 e5                	mov    %esp,%ebp
 154:	53                   	push   %ebx
 155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 158:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 15d:	eb 0e                	jmp    16d <atoi+0x1c>
    n = n*10 + *s++ - '0';
 15f:	8d 14 92             	lea    (%edx,%edx,4),%edx
 162:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 165:	41                   	inc    %ecx
 166:	0f be c0             	movsbl %al,%eax
 169:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 16d:	8a 01                	mov    (%ecx),%al
 16f:	8d 58 d0             	lea    -0x30(%eax),%ebx
 172:	80 fb 09             	cmp    $0x9,%bl
 175:	76 e8                	jbe    15f <atoi+0xe>
  return n;
}
 177:	89 d0                	mov    %edx,%eax
 179:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 17c:	c9                   	leave  
 17d:	c3                   	ret    

0000017e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 17e:	55                   	push   %ebp
 17f:	89 e5                	mov    %esp,%ebp
 181:	56                   	push   %esi
 182:	53                   	push   %ebx
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 189:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 18c:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 18e:	eb 0c                	jmp    19c <memmove+0x1e>
    *dst++ = *src++;
 190:	8a 13                	mov    (%ebx),%dl
 192:	88 11                	mov    %dl,(%ecx)
 194:	8d 5b 01             	lea    0x1(%ebx),%ebx
 197:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 19a:	89 f2                	mov    %esi,%edx
 19c:	8d 72 ff             	lea    -0x1(%edx),%esi
 19f:	85 d2                	test   %edx,%edx
 1a1:	7f ed                	jg     190 <memmove+0x12>
  return vdst;
}
 1a3:	5b                   	pop    %ebx
 1a4:	5e                   	pop    %esi
 1a5:	5d                   	pop    %ebp
 1a6:	c3                   	ret    

000001a7 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1a7:	b8 01 00 00 00       	mov    $0x1,%eax
 1ac:	cd 40                	int    $0x40
 1ae:	c3                   	ret    

000001af <exit>:
SYSCALL(exit)
 1af:	b8 02 00 00 00       	mov    $0x2,%eax
 1b4:	cd 40                	int    $0x40
 1b6:	c3                   	ret    

000001b7 <wait>:
SYSCALL(wait)
 1b7:	b8 03 00 00 00       	mov    $0x3,%eax
 1bc:	cd 40                	int    $0x40
 1be:	c3                   	ret    

000001bf <pipe>:
SYSCALL(pipe)
 1bf:	b8 04 00 00 00       	mov    $0x4,%eax
 1c4:	cd 40                	int    $0x40
 1c6:	c3                   	ret    

000001c7 <read>:
SYSCALL(read)
 1c7:	b8 05 00 00 00       	mov    $0x5,%eax
 1cc:	cd 40                	int    $0x40
 1ce:	c3                   	ret    

000001cf <write>:
SYSCALL(write)
 1cf:	b8 10 00 00 00       	mov    $0x10,%eax
 1d4:	cd 40                	int    $0x40
 1d6:	c3                   	ret    

000001d7 <close>:
SYSCALL(close)
 1d7:	b8 15 00 00 00       	mov    $0x15,%eax
 1dc:	cd 40                	int    $0x40
 1de:	c3                   	ret    

000001df <kill>:
SYSCALL(kill)
 1df:	b8 06 00 00 00       	mov    $0x6,%eax
 1e4:	cd 40                	int    $0x40
 1e6:	c3                   	ret    

000001e7 <exec>:
SYSCALL(exec)
 1e7:	b8 07 00 00 00       	mov    $0x7,%eax
 1ec:	cd 40                	int    $0x40
 1ee:	c3                   	ret    

000001ef <open>:
SYSCALL(open)
 1ef:	b8 0f 00 00 00       	mov    $0xf,%eax
 1f4:	cd 40                	int    $0x40
 1f6:	c3                   	ret    

000001f7 <mknod>:
SYSCALL(mknod)
 1f7:	b8 11 00 00 00       	mov    $0x11,%eax
 1fc:	cd 40                	int    $0x40
 1fe:	c3                   	ret    

000001ff <unlink>:
SYSCALL(unlink)
 1ff:	b8 12 00 00 00       	mov    $0x12,%eax
 204:	cd 40                	int    $0x40
 206:	c3                   	ret    

00000207 <fstat>:
SYSCALL(fstat)
 207:	b8 08 00 00 00       	mov    $0x8,%eax
 20c:	cd 40                	int    $0x40
 20e:	c3                   	ret    

0000020f <link>:
SYSCALL(link)
 20f:	b8 13 00 00 00       	mov    $0x13,%eax
 214:	cd 40                	int    $0x40
 216:	c3                   	ret    

00000217 <mkdir>:
SYSCALL(mkdir)
 217:	b8 14 00 00 00       	mov    $0x14,%eax
 21c:	cd 40                	int    $0x40
 21e:	c3                   	ret    

0000021f <chdir>:
SYSCALL(chdir)
 21f:	b8 09 00 00 00       	mov    $0x9,%eax
 224:	cd 40                	int    $0x40
 226:	c3                   	ret    

00000227 <dup>:
SYSCALL(dup)
 227:	b8 0a 00 00 00       	mov    $0xa,%eax
 22c:	cd 40                	int    $0x40
 22e:	c3                   	ret    

0000022f <getpid>:
SYSCALL(getpid)
 22f:	b8 0b 00 00 00       	mov    $0xb,%eax
 234:	cd 40                	int    $0x40
 236:	c3                   	ret    

00000237 <sbrk>:
SYSCALL(sbrk)
 237:	b8 0c 00 00 00       	mov    $0xc,%eax
 23c:	cd 40                	int    $0x40
 23e:	c3                   	ret    

0000023f <sleep>:
SYSCALL(sleep)
 23f:	b8 0d 00 00 00       	mov    $0xd,%eax
 244:	cd 40                	int    $0x40
 246:	c3                   	ret    

00000247 <uptime>:
SYSCALL(uptime)
 247:	b8 0e 00 00 00       	mov    $0xe,%eax
 24c:	cd 40                	int    $0x40
 24e:	c3                   	ret    

0000024f <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 24f:	b8 16 00 00 00       	mov    $0x16,%eax
 254:	cd 40                	int    $0x40
 256:	c3                   	ret    

00000257 <block>:
SYSCALL(block)
 257:	b8 17 00 00 00       	mov    $0x17,%eax
 25c:	cd 40                	int    $0x40
 25e:	c3                   	ret    

0000025f <unblock>:
SYSCALL(unblock)
 25f:	b8 18 00 00 00       	mov    $0x18,%eax
 264:	cd 40                	int    $0x40
 266:	c3                   	ret    

00000267 <chmod>:
SYSCALL(chmod)
 267:	b8 19 00 00 00       	mov    $0x19,%eax
 26c:	cd 40                	int    $0x40
 26e:	c3                   	ret    

0000026f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 26f:	55                   	push   %ebp
 270:	89 e5                	mov    %esp,%ebp
 272:	83 ec 1c             	sub    $0x1c,%esp
 275:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 278:	6a 01                	push   $0x1
 27a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 27d:	52                   	push   %edx
 27e:	50                   	push   %eax
 27f:	e8 4b ff ff ff       	call   1cf <write>
}
 284:	83 c4 10             	add    $0x10,%esp
 287:	c9                   	leave  
 288:	c3                   	ret    

00000289 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	57                   	push   %edi
 28d:	56                   	push   %esi
 28e:	53                   	push   %ebx
 28f:	83 ec 2c             	sub    $0x2c,%esp
 292:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 295:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 297:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 29b:	74 04                	je     2a1 <printint+0x18>
 29d:	85 d2                	test   %edx,%edx
 29f:	78 3c                	js     2dd <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 2a1:	89 d1                	mov    %edx,%ecx
  neg = 0;
 2a3:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 2aa:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2af:	89 c8                	mov    %ecx,%eax
 2b1:	ba 00 00 00 00       	mov    $0x0,%edx
 2b6:	f7 f6                	div    %esi
 2b8:	89 df                	mov    %ebx,%edi
 2ba:	43                   	inc    %ebx
 2bb:	8a 92 08 06 00 00    	mov    0x608(%edx),%dl
 2c1:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2c5:	89 ca                	mov    %ecx,%edx
 2c7:	89 c1                	mov    %eax,%ecx
 2c9:	39 f2                	cmp    %esi,%edx
 2cb:	73 e2                	jae    2af <printint+0x26>
  if(neg)
 2cd:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2d1:	74 24                	je     2f7 <printint+0x6e>
    buf[i++] = '-';
 2d3:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2d8:	8d 5f 02             	lea    0x2(%edi),%ebx
 2db:	eb 1a                	jmp    2f7 <printint+0x6e>
    x = -xx;
 2dd:	89 d1                	mov    %edx,%ecx
 2df:	f7 d9                	neg    %ecx
    neg = 1;
 2e1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 2e8:	eb c0                	jmp    2aa <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 2ea:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2ef:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2f2:	e8 78 ff ff ff       	call   26f <putc>
  while(--i >= 0)
 2f7:	4b                   	dec    %ebx
 2f8:	79 f0                	jns    2ea <printint+0x61>
}
 2fa:	83 c4 2c             	add    $0x2c,%esp
 2fd:	5b                   	pop    %ebx
 2fe:	5e                   	pop    %esi
 2ff:	5f                   	pop    %edi
 300:	5d                   	pop    %ebp
 301:	c3                   	ret    

00000302 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	57                   	push   %edi
 306:	56                   	push   %esi
 307:	53                   	push   %ebx
 308:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 30b:	8d 45 10             	lea    0x10(%ebp),%eax
 30e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 311:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 316:	bb 00 00 00 00       	mov    $0x0,%ebx
 31b:	eb 12                	jmp    32f <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 31d:	89 fa                	mov    %edi,%edx
 31f:	8b 45 08             	mov    0x8(%ebp),%eax
 322:	e8 48 ff ff ff       	call   26f <putc>
 327:	eb 05                	jmp    32e <printf+0x2c>
      }
    } else if(state == '%'){
 329:	83 fe 25             	cmp    $0x25,%esi
 32c:	74 22                	je     350 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 32e:	43                   	inc    %ebx
 32f:	8b 45 0c             	mov    0xc(%ebp),%eax
 332:	8a 04 18             	mov    (%eax,%ebx,1),%al
 335:	84 c0                	test   %al,%al
 337:	0f 84 1d 01 00 00    	je     45a <printf+0x158>
    c = fmt[i] & 0xff;
 33d:	0f be f8             	movsbl %al,%edi
 340:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 343:	85 f6                	test   %esi,%esi
 345:	75 e2                	jne    329 <printf+0x27>
      if(c == '%'){
 347:	83 f8 25             	cmp    $0x25,%eax
 34a:	75 d1                	jne    31d <printf+0x1b>
        state = '%';
 34c:	89 c6                	mov    %eax,%esi
 34e:	eb de                	jmp    32e <printf+0x2c>
      if(c == 'd'){
 350:	83 f8 25             	cmp    $0x25,%eax
 353:	0f 84 cc 00 00 00    	je     425 <printf+0x123>
 359:	0f 8c da 00 00 00    	jl     439 <printf+0x137>
 35f:	83 f8 78             	cmp    $0x78,%eax
 362:	0f 8f d1 00 00 00    	jg     439 <printf+0x137>
 368:	83 f8 63             	cmp    $0x63,%eax
 36b:	0f 8c c8 00 00 00    	jl     439 <printf+0x137>
 371:	83 e8 63             	sub    $0x63,%eax
 374:	83 f8 15             	cmp    $0x15,%eax
 377:	0f 87 bc 00 00 00    	ja     439 <printf+0x137>
 37d:	ff 24 85 b0 05 00 00 	jmp    *0x5b0(,%eax,4)
        printint(fd, *ap, 10, 1);
 384:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 387:	8b 17                	mov    (%edi),%edx
 389:	83 ec 0c             	sub    $0xc,%esp
 38c:	6a 01                	push   $0x1
 38e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 393:	8b 45 08             	mov    0x8(%ebp),%eax
 396:	e8 ee fe ff ff       	call   289 <printint>
        ap++;
 39b:	83 c7 04             	add    $0x4,%edi
 39e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3a1:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 3a4:	be 00 00 00 00       	mov    $0x0,%esi
 3a9:	eb 83                	jmp    32e <printf+0x2c>
        printint(fd, *ap, 16, 0);
 3ab:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ae:	8b 17                	mov    (%edi),%edx
 3b0:	83 ec 0c             	sub    $0xc,%esp
 3b3:	6a 00                	push   $0x0
 3b5:	b9 10 00 00 00       	mov    $0x10,%ecx
 3ba:	8b 45 08             	mov    0x8(%ebp),%eax
 3bd:	e8 c7 fe ff ff       	call   289 <printint>
        ap++;
 3c2:	83 c7 04             	add    $0x4,%edi
 3c5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3c8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3cb:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 3d0:	e9 59 ff ff ff       	jmp    32e <printf+0x2c>
        s = (char*)*ap;
 3d5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3d8:	8b 30                	mov    (%eax),%esi
        ap++;
 3da:	83 c0 04             	add    $0x4,%eax
 3dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3e0:	85 f6                	test   %esi,%esi
 3e2:	75 13                	jne    3f7 <printf+0xf5>
          s = "(null)";
 3e4:	be a8 05 00 00       	mov    $0x5a8,%esi
 3e9:	eb 0c                	jmp    3f7 <printf+0xf5>
          putc(fd, *s);
 3eb:	0f be d2             	movsbl %dl,%edx
 3ee:	8b 45 08             	mov    0x8(%ebp),%eax
 3f1:	e8 79 fe ff ff       	call   26f <putc>
          s++;
 3f6:	46                   	inc    %esi
        while(*s != 0){
 3f7:	8a 16                	mov    (%esi),%dl
 3f9:	84 d2                	test   %dl,%dl
 3fb:	75 ee                	jne    3eb <printf+0xe9>
      state = 0;
 3fd:	be 00 00 00 00       	mov    $0x0,%esi
 402:	e9 27 ff ff ff       	jmp    32e <printf+0x2c>
        putc(fd, *ap);
 407:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40a:	0f be 17             	movsbl (%edi),%edx
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	e8 5a fe ff ff       	call   26f <putc>
        ap++;
 415:	83 c7 04             	add    $0x4,%edi
 418:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 41b:	be 00 00 00 00       	mov    $0x0,%esi
 420:	e9 09 ff ff ff       	jmp    32e <printf+0x2c>
        putc(fd, c);
 425:	89 fa                	mov    %edi,%edx
 427:	8b 45 08             	mov    0x8(%ebp),%eax
 42a:	e8 40 fe ff ff       	call   26f <putc>
      state = 0;
 42f:	be 00 00 00 00       	mov    $0x0,%esi
 434:	e9 f5 fe ff ff       	jmp    32e <printf+0x2c>
        putc(fd, '%');
 439:	ba 25 00 00 00       	mov    $0x25,%edx
 43e:	8b 45 08             	mov    0x8(%ebp),%eax
 441:	e8 29 fe ff ff       	call   26f <putc>
        putc(fd, c);
 446:	89 fa                	mov    %edi,%edx
 448:	8b 45 08             	mov    0x8(%ebp),%eax
 44b:	e8 1f fe ff ff       	call   26f <putc>
      state = 0;
 450:	be 00 00 00 00       	mov    $0x0,%esi
 455:	e9 d4 fe ff ff       	jmp    32e <printf+0x2c>
    }
  }
}
 45a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 45d:	5b                   	pop    %ebx
 45e:	5e                   	pop    %esi
 45f:	5f                   	pop    %edi
 460:	5d                   	pop    %ebp
 461:	c3                   	ret    

00000462 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 462:	55                   	push   %ebp
 463:	89 e5                	mov    %esp,%ebp
 465:	57                   	push   %edi
 466:	56                   	push   %esi
 467:	53                   	push   %ebx
 468:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 46b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 46e:	a1 1c 06 00 00       	mov    0x61c,%eax
 473:	eb 02                	jmp    477 <free+0x15>
 475:	89 d0                	mov    %edx,%eax
 477:	39 c8                	cmp    %ecx,%eax
 479:	73 04                	jae    47f <free+0x1d>
 47b:	3b 08                	cmp    (%eax),%ecx
 47d:	72 12                	jb     491 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 47f:	8b 10                	mov    (%eax),%edx
 481:	39 d0                	cmp    %edx,%eax
 483:	72 f0                	jb     475 <free+0x13>
 485:	39 c8                	cmp    %ecx,%eax
 487:	72 08                	jb     491 <free+0x2f>
 489:	39 d1                	cmp    %edx,%ecx
 48b:	72 04                	jb     491 <free+0x2f>
 48d:	89 d0                	mov    %edx,%eax
 48f:	eb e6                	jmp    477 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 491:	8b 73 fc             	mov    -0x4(%ebx),%esi
 494:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 497:	8b 10                	mov    (%eax),%edx
 499:	39 d7                	cmp    %edx,%edi
 49b:	74 19                	je     4b6 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 49d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4a0:	8b 50 04             	mov    0x4(%eax),%edx
 4a3:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4a6:	39 ce                	cmp    %ecx,%esi
 4a8:	74 1b                	je     4c5 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4aa:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4ac:	a3 1c 06 00 00       	mov    %eax,0x61c
}
 4b1:	5b                   	pop    %ebx
 4b2:	5e                   	pop    %esi
 4b3:	5f                   	pop    %edi
 4b4:	5d                   	pop    %ebp
 4b5:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4b6:	03 72 04             	add    0x4(%edx),%esi
 4b9:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4bc:	8b 10                	mov    (%eax),%edx
 4be:	8b 12                	mov    (%edx),%edx
 4c0:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4c3:	eb db                	jmp    4a0 <free+0x3e>
    p->s.size += bp->s.size;
 4c5:	03 53 fc             	add    -0x4(%ebx),%edx
 4c8:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4cb:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4ce:	89 10                	mov    %edx,(%eax)
 4d0:	eb da                	jmp    4ac <free+0x4a>

000004d2 <morecore>:

static Header*
morecore(uint nu)
{
 4d2:	55                   	push   %ebp
 4d3:	89 e5                	mov    %esp,%ebp
 4d5:	53                   	push   %ebx
 4d6:	83 ec 04             	sub    $0x4,%esp
 4d9:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 4db:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 4e0:	77 05                	ja     4e7 <morecore+0x15>
    nu = 4096;
 4e2:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 4e7:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 4ee:	83 ec 0c             	sub    $0xc,%esp
 4f1:	50                   	push   %eax
 4f2:	e8 40 fd ff ff       	call   237 <sbrk>
  if(p == (char*)-1)
 4f7:	83 c4 10             	add    $0x10,%esp
 4fa:	83 f8 ff             	cmp    $0xffffffff,%eax
 4fd:	74 1c                	je     51b <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 4ff:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 502:	83 c0 08             	add    $0x8,%eax
 505:	83 ec 0c             	sub    $0xc,%esp
 508:	50                   	push   %eax
 509:	e8 54 ff ff ff       	call   462 <free>
  return freep;
 50e:	a1 1c 06 00 00       	mov    0x61c,%eax
 513:	83 c4 10             	add    $0x10,%esp
}
 516:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 519:	c9                   	leave  
 51a:	c3                   	ret    
    return 0;
 51b:	b8 00 00 00 00       	mov    $0x0,%eax
 520:	eb f4                	jmp    516 <morecore+0x44>

00000522 <malloc>:

void*
malloc(uint nbytes)
{
 522:	55                   	push   %ebp
 523:	89 e5                	mov    %esp,%ebp
 525:	53                   	push   %ebx
 526:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	8d 58 07             	lea    0x7(%eax),%ebx
 52f:	c1 eb 03             	shr    $0x3,%ebx
 532:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 533:	8b 0d 1c 06 00 00    	mov    0x61c,%ecx
 539:	85 c9                	test   %ecx,%ecx
 53b:	74 04                	je     541 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 53d:	8b 01                	mov    (%ecx),%eax
 53f:	eb 4a                	jmp    58b <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 541:	c7 05 1c 06 00 00 20 	movl   $0x620,0x61c
 548:	06 00 00 
 54b:	c7 05 20 06 00 00 20 	movl   $0x620,0x620
 552:	06 00 00 
    base.s.size = 0;
 555:	c7 05 24 06 00 00 00 	movl   $0x0,0x624
 55c:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 55f:	b9 20 06 00 00       	mov    $0x620,%ecx
 564:	eb d7                	jmp    53d <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 566:	74 19                	je     581 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 568:	29 da                	sub    %ebx,%edx
 56a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 56d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 570:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 573:	89 0d 1c 06 00 00    	mov    %ecx,0x61c
      return (void*)(p + 1);
 579:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 57c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 57f:	c9                   	leave  
 580:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 581:	8b 10                	mov    (%eax),%edx
 583:	89 11                	mov    %edx,(%ecx)
 585:	eb ec                	jmp    573 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 587:	89 c1                	mov    %eax,%ecx
 589:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 58b:	8b 50 04             	mov    0x4(%eax),%edx
 58e:	39 da                	cmp    %ebx,%edx
 590:	73 d4                	jae    566 <malloc+0x44>
    if(p == freep)
 592:	39 05 1c 06 00 00    	cmp    %eax,0x61c
 598:	75 ed                	jne    587 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 59a:	89 d8                	mov    %ebx,%eax
 59c:	e8 31 ff ff ff       	call   4d2 <morecore>
 5a1:	85 c0                	test   %eax,%eax
 5a3:	75 e2                	jne    587 <malloc+0x65>
 5a5:	eb d5                	jmp    57c <malloc+0x5a>
