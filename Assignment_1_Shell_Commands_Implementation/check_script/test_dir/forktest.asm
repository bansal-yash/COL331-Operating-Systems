
_forktest:     file format elf32-i386


Disassembly of section .text:

00000000 <printf>:

#define N  1000

void
printf(int fd, const char *s, ...)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	53                   	push   %ebx
   4:	83 ec 10             	sub    $0x10,%esp
   7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  write(fd, s, strlen(s));
   a:	53                   	push   %ebx
   b:	e8 15 01 00 00       	call   125 <strlen>
  10:	83 c4 0c             	add    $0xc,%esp
  13:	50                   	push   %eax
  14:	53                   	push   %ebx
  15:	ff 75 08             	pushl  0x8(%ebp)
  18:	e8 69 02 00 00       	call   286 <write>
}
  1d:	83 c4 10             	add    $0x10,%esp
  20:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  23:	c9                   	leave  
  24:	c3                   	ret    

00000025 <forktest>:

void
forktest(void)
{
  25:	55                   	push   %ebp
  26:	89 e5                	mov    %esp,%ebp
  28:	53                   	push   %ebx
  29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
  2c:	68 28 03 00 00       	push   $0x328
  31:	6a 01                	push   $0x1
  33:	e8 c8 ff ff ff       	call   0 <printf>

  for(n=0; n<N; n++){
  38:	83 c4 10             	add    $0x10,%esp
  3b:	bb 00 00 00 00       	mov    $0x0,%ebx
  40:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
  46:	7f 13                	jg     5b <forktest+0x36>
    pid = fork();
  48:	e8 11 02 00 00       	call   25e <fork>
    if(pid < 0)
  4d:	85 c0                	test   %eax,%eax
  4f:	78 0a                	js     5b <forktest+0x36>
      break;
    if(pid == 0)
  51:	74 03                	je     56 <forktest+0x31>
  for(n=0; n<N; n++){
  53:	43                   	inc    %ebx
  54:	eb ea                	jmp    40 <forktest+0x1b>
      exit();
  56:	e8 0b 02 00 00       	call   266 <exit>
  }

  if(n == N){
  5b:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
  61:	74 10                	je     73 <forktest+0x4e>
    printf(1, "fork claimed to work N times!\n", N);
    exit();
  }

  for(; n > 0; n--){
  63:	85 db                	test   %ebx,%ebx
  65:	7e 39                	jle    a0 <forktest+0x7b>
    if(wait() < 0){
  67:	e8 02 02 00 00       	call   26e <wait>
  6c:	85 c0                	test   %eax,%eax
  6e:	78 1c                	js     8c <forktest+0x67>
  for(; n > 0; n--){
  70:	4b                   	dec    %ebx
  71:	eb f0                	jmp    63 <forktest+0x3e>
    printf(1, "fork claimed to work N times!\n", N);
  73:	83 ec 04             	sub    $0x4,%esp
  76:	68 e8 03 00 00       	push   $0x3e8
  7b:	68 68 03 00 00       	push   $0x368
  80:	6a 01                	push   $0x1
  82:	e8 79 ff ff ff       	call   0 <printf>
    exit();
  87:	e8 da 01 00 00       	call   266 <exit>
      printf(1, "wait stopped early\n");
  8c:	83 ec 08             	sub    $0x8,%esp
  8f:	68 33 03 00 00       	push   $0x333
  94:	6a 01                	push   $0x1
  96:	e8 65 ff ff ff       	call   0 <printf>
      exit();
  9b:	e8 c6 01 00 00       	call   266 <exit>
    }
  }

  if(wait() != -1){
  a0:	e8 c9 01 00 00       	call   26e <wait>
  a5:	83 f8 ff             	cmp    $0xffffffff,%eax
  a8:	75 17                	jne    c1 <forktest+0x9c>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
  aa:	83 ec 08             	sub    $0x8,%esp
  ad:	68 5a 03 00 00       	push   $0x35a
  b2:	6a 01                	push   $0x1
  b4:	e8 47 ff ff ff       	call   0 <printf>
}
  b9:	83 c4 10             	add    $0x10,%esp
  bc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  bf:	c9                   	leave  
  c0:	c3                   	ret    
    printf(1, "wait got too many\n");
  c1:	83 ec 08             	sub    $0x8,%esp
  c4:	68 47 03 00 00       	push   $0x347
  c9:	6a 01                	push   $0x1
  cb:	e8 30 ff ff ff       	call   0 <printf>
    exit();
  d0:	e8 91 01 00 00       	call   266 <exit>

000000d5 <main>:

int
main(void)
{
  d5:	55                   	push   %ebp
  d6:	89 e5                	mov    %esp,%ebp
  d8:	83 e4 f0             	and    $0xfffffff0,%esp
  forktest();
  db:	e8 45 ff ff ff       	call   25 <forktest>
  exit();
  e0:	e8 81 01 00 00       	call   266 <exit>

000000e5 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  e5:	55                   	push   %ebp
  e6:	89 e5                	mov    %esp,%ebp
  e8:	56                   	push   %esi
  e9:	53                   	push   %ebx
  ea:	8b 45 08             	mov    0x8(%ebp),%eax
  ed:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  f0:	89 c2                	mov    %eax,%edx
  f2:	89 cb                	mov    %ecx,%ebx
  f4:	41                   	inc    %ecx
  f5:	89 d6                	mov    %edx,%esi
  f7:	42                   	inc    %edx
  f8:	8a 1b                	mov    (%ebx),%bl
  fa:	88 1e                	mov    %bl,(%esi)
  fc:	84 db                	test   %bl,%bl
  fe:	75 f2                	jne    f2 <strcpy+0xd>
    ;
  return os;
}
 100:	5b                   	pop    %ebx
 101:	5e                   	pop    %esi
 102:	5d                   	pop    %ebp
 103:	c3                   	ret    

00000104 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 104:	55                   	push   %ebp
 105:	89 e5                	mov    %esp,%ebp
 107:	8b 4d 08             	mov    0x8(%ebp),%ecx
 10a:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10d:	eb 02                	jmp    111 <strcmp+0xd>
    p++, q++;
 10f:	41                   	inc    %ecx
 110:	42                   	inc    %edx
  while(*p && *p == *q)
 111:	8a 01                	mov    (%ecx),%al
 113:	84 c0                	test   %al,%al
 115:	74 04                	je     11b <strcmp+0x17>
 117:	3a 02                	cmp    (%edx),%al
 119:	74 f4                	je     10f <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 11b:	0f b6 c0             	movzbl %al,%eax
 11e:	0f b6 12             	movzbl (%edx),%edx
 121:	29 d0                	sub    %edx,%eax
}
 123:	5d                   	pop    %ebp
 124:	c3                   	ret    

00000125 <strlen>:

uint
strlen(const char *s)
{
 125:	55                   	push   %ebp
 126:	89 e5                	mov    %esp,%ebp
 128:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 12b:	b8 00 00 00 00       	mov    $0x0,%eax
 130:	eb 01                	jmp    133 <strlen+0xe>
 132:	40                   	inc    %eax
 133:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 137:	75 f9                	jne    132 <strlen+0xd>
    ;
  return n;
}
 139:	5d                   	pop    %ebp
 13a:	c3                   	ret    

0000013b <memset>:

void*
memset(void *dst, int c, uint n)
{
 13b:	55                   	push   %ebp
 13c:	89 e5                	mov    %esp,%ebp
 13e:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 13f:	8b 7d 08             	mov    0x8(%ebp),%edi
 142:	8b 4d 10             	mov    0x10(%ebp),%ecx
 145:	8b 45 0c             	mov    0xc(%ebp),%eax
 148:	fc                   	cld    
 149:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 14b:	8b 45 08             	mov    0x8(%ebp),%eax
 14e:	8b 7d fc             	mov    -0x4(%ebp),%edi
 151:	c9                   	leave  
 152:	c3                   	ret    

00000153 <strchr>:

char*
strchr(const char *s, char c)
{
 153:	55                   	push   %ebp
 154:	89 e5                	mov    %esp,%ebp
 156:	8b 45 08             	mov    0x8(%ebp),%eax
 159:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 15c:	eb 01                	jmp    15f <strchr+0xc>
 15e:	40                   	inc    %eax
 15f:	8a 10                	mov    (%eax),%dl
 161:	84 d2                	test   %dl,%dl
 163:	74 06                	je     16b <strchr+0x18>
    if(*s == c)
 165:	38 ca                	cmp    %cl,%dl
 167:	75 f5                	jne    15e <strchr+0xb>
 169:	eb 05                	jmp    170 <strchr+0x1d>
      return (char*)s;
  return 0;
 16b:	b8 00 00 00 00       	mov    $0x0,%eax
}
 170:	5d                   	pop    %ebp
 171:	c3                   	ret    

00000172 <gets>:

char*
gets(char *buf, int max)
{
 172:	55                   	push   %ebp
 173:	89 e5                	mov    %esp,%ebp
 175:	57                   	push   %edi
 176:	56                   	push   %esi
 177:	53                   	push   %ebx
 178:	83 ec 1c             	sub    $0x1c,%esp
 17b:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 17e:	bb 00 00 00 00       	mov    $0x0,%ebx
 183:	89 de                	mov    %ebx,%esi
 185:	43                   	inc    %ebx
 186:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 189:	7d 2b                	jge    1b6 <gets+0x44>
    cc = read(0, &c, 1);
 18b:	83 ec 04             	sub    $0x4,%esp
 18e:	6a 01                	push   $0x1
 190:	8d 45 e7             	lea    -0x19(%ebp),%eax
 193:	50                   	push   %eax
 194:	6a 00                	push   $0x0
 196:	e8 e3 00 00 00       	call   27e <read>
    if(cc < 1)
 19b:	83 c4 10             	add    $0x10,%esp
 19e:	85 c0                	test   %eax,%eax
 1a0:	7e 14                	jle    1b6 <gets+0x44>
      break;
    buf[i++] = c;
 1a2:	8a 45 e7             	mov    -0x19(%ebp),%al
 1a5:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1a8:	3c 0a                	cmp    $0xa,%al
 1aa:	74 08                	je     1b4 <gets+0x42>
 1ac:	3c 0d                	cmp    $0xd,%al
 1ae:	75 d3                	jne    183 <gets+0x11>
    buf[i++] = c;
 1b0:	89 de                	mov    %ebx,%esi
 1b2:	eb 02                	jmp    1b6 <gets+0x44>
 1b4:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1b6:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1ba:	89 f8                	mov    %edi,%eax
 1bc:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1bf:	5b                   	pop    %ebx
 1c0:	5e                   	pop    %esi
 1c1:	5f                   	pop    %edi
 1c2:	5d                   	pop    %ebp
 1c3:	c3                   	ret    

000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	55                   	push   %ebp
 1c5:	89 e5                	mov    %esp,%ebp
 1c7:	56                   	push   %esi
 1c8:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1c9:	83 ec 08             	sub    $0x8,%esp
 1cc:	6a 00                	push   $0x0
 1ce:	ff 75 08             	pushl  0x8(%ebp)
 1d1:	e8 d0 00 00 00       	call   2a6 <open>
  if(fd < 0)
 1d6:	83 c4 10             	add    $0x10,%esp
 1d9:	85 c0                	test   %eax,%eax
 1db:	78 24                	js     201 <stat+0x3d>
 1dd:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1df:	83 ec 08             	sub    $0x8,%esp
 1e2:	ff 75 0c             	pushl  0xc(%ebp)
 1e5:	50                   	push   %eax
 1e6:	e8 d3 00 00 00       	call   2be <fstat>
 1eb:	89 c6                	mov    %eax,%esi
  close(fd);
 1ed:	89 1c 24             	mov    %ebx,(%esp)
 1f0:	e8 99 00 00 00       	call   28e <close>
  return r;
 1f5:	83 c4 10             	add    $0x10,%esp
}
 1f8:	89 f0                	mov    %esi,%eax
 1fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1fd:	5b                   	pop    %ebx
 1fe:	5e                   	pop    %esi
 1ff:	5d                   	pop    %ebp
 200:	c3                   	ret    
    return -1;
 201:	be ff ff ff ff       	mov    $0xffffffff,%esi
 206:	eb f0                	jmp    1f8 <stat+0x34>

00000208 <atoi>:

int
atoi(const char *s)
{
 208:	55                   	push   %ebp
 209:	89 e5                	mov    %esp,%ebp
 20b:	53                   	push   %ebx
 20c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 20f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 214:	eb 0e                	jmp    224 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 216:	8d 14 92             	lea    (%edx,%edx,4),%edx
 219:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 21c:	41                   	inc    %ecx
 21d:	0f be c0             	movsbl %al,%eax
 220:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 224:	8a 01                	mov    (%ecx),%al
 226:	8d 58 d0             	lea    -0x30(%eax),%ebx
 229:	80 fb 09             	cmp    $0x9,%bl
 22c:	76 e8                	jbe    216 <atoi+0xe>
  return n;
}
 22e:	89 d0                	mov    %edx,%eax
 230:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 233:	c9                   	leave  
 234:	c3                   	ret    

00000235 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	56                   	push   %esi
 239:	53                   	push   %ebx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 240:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 243:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 245:	eb 0c                	jmp    253 <memmove+0x1e>
    *dst++ = *src++;
 247:	8a 13                	mov    (%ebx),%dl
 249:	88 11                	mov    %dl,(%ecx)
 24b:	8d 5b 01             	lea    0x1(%ebx),%ebx
 24e:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 251:	89 f2                	mov    %esi,%edx
 253:	8d 72 ff             	lea    -0x1(%edx),%esi
 256:	85 d2                	test   %edx,%edx
 258:	7f ed                	jg     247 <memmove+0x12>
  return vdst;
}
 25a:	5b                   	pop    %ebx
 25b:	5e                   	pop    %esi
 25c:	5d                   	pop    %ebp
 25d:	c3                   	ret    

0000025e <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 25e:	b8 01 00 00 00       	mov    $0x1,%eax
 263:	cd 40                	int    $0x40
 265:	c3                   	ret    

00000266 <exit>:
SYSCALL(exit)
 266:	b8 02 00 00 00       	mov    $0x2,%eax
 26b:	cd 40                	int    $0x40
 26d:	c3                   	ret    

0000026e <wait>:
SYSCALL(wait)
 26e:	b8 03 00 00 00       	mov    $0x3,%eax
 273:	cd 40                	int    $0x40
 275:	c3                   	ret    

00000276 <pipe>:
SYSCALL(pipe)
 276:	b8 04 00 00 00       	mov    $0x4,%eax
 27b:	cd 40                	int    $0x40
 27d:	c3                   	ret    

0000027e <read>:
SYSCALL(read)
 27e:	b8 05 00 00 00       	mov    $0x5,%eax
 283:	cd 40                	int    $0x40
 285:	c3                   	ret    

00000286 <write>:
SYSCALL(write)
 286:	b8 10 00 00 00       	mov    $0x10,%eax
 28b:	cd 40                	int    $0x40
 28d:	c3                   	ret    

0000028e <close>:
SYSCALL(close)
 28e:	b8 15 00 00 00       	mov    $0x15,%eax
 293:	cd 40                	int    $0x40
 295:	c3                   	ret    

00000296 <kill>:
SYSCALL(kill)
 296:	b8 06 00 00 00       	mov    $0x6,%eax
 29b:	cd 40                	int    $0x40
 29d:	c3                   	ret    

0000029e <exec>:
SYSCALL(exec)
 29e:	b8 07 00 00 00       	mov    $0x7,%eax
 2a3:	cd 40                	int    $0x40
 2a5:	c3                   	ret    

000002a6 <open>:
SYSCALL(open)
 2a6:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ab:	cd 40                	int    $0x40
 2ad:	c3                   	ret    

000002ae <mknod>:
SYSCALL(mknod)
 2ae:	b8 11 00 00 00       	mov    $0x11,%eax
 2b3:	cd 40                	int    $0x40
 2b5:	c3                   	ret    

000002b6 <unlink>:
SYSCALL(unlink)
 2b6:	b8 12 00 00 00       	mov    $0x12,%eax
 2bb:	cd 40                	int    $0x40
 2bd:	c3                   	ret    

000002be <fstat>:
SYSCALL(fstat)
 2be:	b8 08 00 00 00       	mov    $0x8,%eax
 2c3:	cd 40                	int    $0x40
 2c5:	c3                   	ret    

000002c6 <link>:
SYSCALL(link)
 2c6:	b8 13 00 00 00       	mov    $0x13,%eax
 2cb:	cd 40                	int    $0x40
 2cd:	c3                   	ret    

000002ce <mkdir>:
SYSCALL(mkdir)
 2ce:	b8 14 00 00 00       	mov    $0x14,%eax
 2d3:	cd 40                	int    $0x40
 2d5:	c3                   	ret    

000002d6 <chdir>:
SYSCALL(chdir)
 2d6:	b8 09 00 00 00       	mov    $0x9,%eax
 2db:	cd 40                	int    $0x40
 2dd:	c3                   	ret    

000002de <dup>:
SYSCALL(dup)
 2de:	b8 0a 00 00 00       	mov    $0xa,%eax
 2e3:	cd 40                	int    $0x40
 2e5:	c3                   	ret    

000002e6 <getpid>:
SYSCALL(getpid)
 2e6:	b8 0b 00 00 00       	mov    $0xb,%eax
 2eb:	cd 40                	int    $0x40
 2ed:	c3                   	ret    

000002ee <sbrk>:
SYSCALL(sbrk)
 2ee:	b8 0c 00 00 00       	mov    $0xc,%eax
 2f3:	cd 40                	int    $0x40
 2f5:	c3                   	ret    

000002f6 <sleep>:
SYSCALL(sleep)
 2f6:	b8 0d 00 00 00       	mov    $0xd,%eax
 2fb:	cd 40                	int    $0x40
 2fd:	c3                   	ret    

000002fe <uptime>:
SYSCALL(uptime)
 2fe:	b8 0e 00 00 00       	mov    $0xe,%eax
 303:	cd 40                	int    $0x40
 305:	c3                   	ret    

00000306 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 306:	b8 16 00 00 00       	mov    $0x16,%eax
 30b:	cd 40                	int    $0x40
 30d:	c3                   	ret    

0000030e <block>:
SYSCALL(block)
 30e:	b8 17 00 00 00       	mov    $0x17,%eax
 313:	cd 40                	int    $0x40
 315:	c3                   	ret    

00000316 <unblock>:
SYSCALL(unblock)
 316:	b8 18 00 00 00       	mov    $0x18,%eax
 31b:	cd 40                	int    $0x40
 31d:	c3                   	ret    

0000031e <chmod>:
SYSCALL(chmod)
 31e:	b8 19 00 00 00       	mov    $0x19,%eax
 323:	cd 40                	int    $0x40
 325:	c3                   	ret    
