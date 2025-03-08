
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

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
  11:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  17:	8d 7d de             	lea    -0x22(%ebp),%edi
  1a:	be af 06 00 00       	mov    $0x6af,%esi
  1f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  24:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  26:	68 8c 06 00 00       	push   $0x68c
  2b:	6a 01                	push   $0x1
  2d:	e8 b4 03 00 00       	call   3e6 <printf>
  memset(data, 'a', sizeof(data));
  32:	83 c4 0c             	add    $0xc,%esp
  35:	68 00 02 00 00       	push   $0x200
  3a:	6a 61                	push   $0x61
  3c:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  42:	50                   	push   %eax
  43:	e8 20 01 00 00       	call   168 <memset>

  for(i = 0; i < 4; i++)
  48:	83 c4 10             	add    $0x10,%esp
  4b:	bb 00 00 00 00       	mov    $0x0,%ebx
  50:	83 fb 03             	cmp    $0x3,%ebx
  53:	7f 0c                	jg     61 <main+0x61>
    if(fork() > 0)
  55:	e8 31 02 00 00       	call   28b <fork>
  5a:	85 c0                	test   %eax,%eax
  5c:	7f 03                	jg     61 <main+0x61>
  for(i = 0; i < 4; i++)
  5e:	43                   	inc    %ebx
  5f:	eb ef                	jmp    50 <main+0x50>
      break;

  printf(1, "write %d\n", i);
  61:	83 ec 04             	sub    $0x4,%esp
  64:	53                   	push   %ebx
  65:	68 9f 06 00 00       	push   $0x69f
  6a:	6a 01                	push   $0x1
  6c:	e8 75 03 00 00       	call   3e6 <printf>

  path[8] += i;
  71:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  74:	83 c4 08             	add    $0x8,%esp
  77:	68 02 02 00 00       	push   $0x202
  7c:	8d 45 de             	lea    -0x22(%ebp),%eax
  7f:	50                   	push   %eax
  80:	e8 4e 02 00 00       	call   2d3 <open>
  85:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  87:	83 c4 10             	add    $0x10,%esp
  8a:	bb 00 00 00 00       	mov    $0x0,%ebx
  8f:	eb 19                	jmp    aa <main+0xaa>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  91:	83 ec 04             	sub    $0x4,%esp
  94:	68 00 02 00 00       	push   $0x200
  99:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  9f:	50                   	push   %eax
  a0:	56                   	push   %esi
  a1:	e8 0d 02 00 00       	call   2b3 <write>
  for(i = 0; i < 20; i++)
  a6:	43                   	inc    %ebx
  a7:	83 c4 10             	add    $0x10,%esp
  aa:	83 fb 13             	cmp    $0x13,%ebx
  ad:	7e e2                	jle    91 <main+0x91>
  close(fd);
  af:	83 ec 0c             	sub    $0xc,%esp
  b2:	56                   	push   %esi
  b3:	e8 03 02 00 00       	call   2bb <close>

  printf(1, "read\n");
  b8:	83 c4 08             	add    $0x8,%esp
  bb:	68 a9 06 00 00       	push   $0x6a9
  c0:	6a 01                	push   $0x1
  c2:	e8 1f 03 00 00       	call   3e6 <printf>

  fd = open(path, O_RDONLY);
  c7:	83 c4 08             	add    $0x8,%esp
  ca:	6a 00                	push   $0x0
  cc:	8d 45 de             	lea    -0x22(%ebp),%eax
  cf:	50                   	push   %eax
  d0:	e8 fe 01 00 00       	call   2d3 <open>
  d5:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  d7:	83 c4 10             	add    $0x10,%esp
  da:	bb 00 00 00 00       	mov    $0x0,%ebx
  df:	eb 19                	jmp    fa <main+0xfa>
    read(fd, data, sizeof(data));
  e1:	83 ec 04             	sub    $0x4,%esp
  e4:	68 00 02 00 00       	push   $0x200
  e9:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  ef:	50                   	push   %eax
  f0:	56                   	push   %esi
  f1:	e8 b5 01 00 00       	call   2ab <read>
  for (i = 0; i < 20; i++)
  f6:	43                   	inc    %ebx
  f7:	83 c4 10             	add    $0x10,%esp
  fa:	83 fb 13             	cmp    $0x13,%ebx
  fd:	7e e2                	jle    e1 <main+0xe1>
  close(fd);
  ff:	83 ec 0c             	sub    $0xc,%esp
 102:	56                   	push   %esi
 103:	e8 b3 01 00 00       	call   2bb <close>

  wait();
 108:	e8 8e 01 00 00       	call   29b <wait>

  exit();
 10d:	e8 81 01 00 00       	call   293 <exit>

00000112 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 112:	55                   	push   %ebp
 113:	89 e5                	mov    %esp,%ebp
 115:	56                   	push   %esi
 116:	53                   	push   %ebx
 117:	8b 45 08             	mov    0x8(%ebp),%eax
 11a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11d:	89 c2                	mov    %eax,%edx
 11f:	89 cb                	mov    %ecx,%ebx
 121:	41                   	inc    %ecx
 122:	89 d6                	mov    %edx,%esi
 124:	42                   	inc    %edx
 125:	8a 1b                	mov    (%ebx),%bl
 127:	88 1e                	mov    %bl,(%esi)
 129:	84 db                	test   %bl,%bl
 12b:	75 f2                	jne    11f <strcpy+0xd>
    ;
  return os;
}
 12d:	5b                   	pop    %ebx
 12e:	5e                   	pop    %esi
 12f:	5d                   	pop    %ebp
 130:	c3                   	ret    

00000131 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 131:	55                   	push   %ebp
 132:	89 e5                	mov    %esp,%ebp
 134:	8b 4d 08             	mov    0x8(%ebp),%ecx
 137:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 13a:	eb 02                	jmp    13e <strcmp+0xd>
    p++, q++;
 13c:	41                   	inc    %ecx
 13d:	42                   	inc    %edx
  while(*p && *p == *q)
 13e:	8a 01                	mov    (%ecx),%al
 140:	84 c0                	test   %al,%al
 142:	74 04                	je     148 <strcmp+0x17>
 144:	3a 02                	cmp    (%edx),%al
 146:	74 f4                	je     13c <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 148:	0f b6 c0             	movzbl %al,%eax
 14b:	0f b6 12             	movzbl (%edx),%edx
 14e:	29 d0                	sub    %edx,%eax
}
 150:	5d                   	pop    %ebp
 151:	c3                   	ret    

00000152 <strlen>:

uint
strlen(const char *s)
{
 152:	55                   	push   %ebp
 153:	89 e5                	mov    %esp,%ebp
 155:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 158:	b8 00 00 00 00       	mov    $0x0,%eax
 15d:	eb 01                	jmp    160 <strlen+0xe>
 15f:	40                   	inc    %eax
 160:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 164:	75 f9                	jne    15f <strlen+0xd>
    ;
  return n;
}
 166:	5d                   	pop    %ebp
 167:	c3                   	ret    

00000168 <memset>:

void*
memset(void *dst, int c, uint n)
{
 168:	55                   	push   %ebp
 169:	89 e5                	mov    %esp,%ebp
 16b:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 16c:	8b 7d 08             	mov    0x8(%ebp),%edi
 16f:	8b 4d 10             	mov    0x10(%ebp),%ecx
 172:	8b 45 0c             	mov    0xc(%ebp),%eax
 175:	fc                   	cld    
 176:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 178:	8b 45 08             	mov    0x8(%ebp),%eax
 17b:	8b 7d fc             	mov    -0x4(%ebp),%edi
 17e:	c9                   	leave  
 17f:	c3                   	ret    

00000180 <strchr>:

char*
strchr(const char *s, char c)
{
 180:	55                   	push   %ebp
 181:	89 e5                	mov    %esp,%ebp
 183:	8b 45 08             	mov    0x8(%ebp),%eax
 186:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 189:	eb 01                	jmp    18c <strchr+0xc>
 18b:	40                   	inc    %eax
 18c:	8a 10                	mov    (%eax),%dl
 18e:	84 d2                	test   %dl,%dl
 190:	74 06                	je     198 <strchr+0x18>
    if(*s == c)
 192:	38 ca                	cmp    %cl,%dl
 194:	75 f5                	jne    18b <strchr+0xb>
 196:	eb 05                	jmp    19d <strchr+0x1d>
      return (char*)s;
  return 0;
 198:	b8 00 00 00 00       	mov    $0x0,%eax
}
 19d:	5d                   	pop    %ebp
 19e:	c3                   	ret    

0000019f <gets>:

char*
gets(char *buf, int max)
{
 19f:	55                   	push   %ebp
 1a0:	89 e5                	mov    %esp,%ebp
 1a2:	57                   	push   %edi
 1a3:	56                   	push   %esi
 1a4:	53                   	push   %ebx
 1a5:	83 ec 1c             	sub    $0x1c,%esp
 1a8:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1ab:	bb 00 00 00 00       	mov    $0x0,%ebx
 1b0:	89 de                	mov    %ebx,%esi
 1b2:	43                   	inc    %ebx
 1b3:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1b6:	7d 2b                	jge    1e3 <gets+0x44>
    cc = read(0, &c, 1);
 1b8:	83 ec 04             	sub    $0x4,%esp
 1bb:	6a 01                	push   $0x1
 1bd:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1c0:	50                   	push   %eax
 1c1:	6a 00                	push   $0x0
 1c3:	e8 e3 00 00 00       	call   2ab <read>
    if(cc < 1)
 1c8:	83 c4 10             	add    $0x10,%esp
 1cb:	85 c0                	test   %eax,%eax
 1cd:	7e 14                	jle    1e3 <gets+0x44>
      break;
    buf[i++] = c;
 1cf:	8a 45 e7             	mov    -0x19(%ebp),%al
 1d2:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1d5:	3c 0a                	cmp    $0xa,%al
 1d7:	74 08                	je     1e1 <gets+0x42>
 1d9:	3c 0d                	cmp    $0xd,%al
 1db:	75 d3                	jne    1b0 <gets+0x11>
    buf[i++] = c;
 1dd:	89 de                	mov    %ebx,%esi
 1df:	eb 02                	jmp    1e3 <gets+0x44>
 1e1:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1e3:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1e7:	89 f8                	mov    %edi,%eax
 1e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1ec:	5b                   	pop    %ebx
 1ed:	5e                   	pop    %esi
 1ee:	5f                   	pop    %edi
 1ef:	5d                   	pop    %ebp
 1f0:	c3                   	ret    

000001f1 <stat>:

int
stat(const char *n, struct stat *st)
{
 1f1:	55                   	push   %ebp
 1f2:	89 e5                	mov    %esp,%ebp
 1f4:	56                   	push   %esi
 1f5:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1f6:	83 ec 08             	sub    $0x8,%esp
 1f9:	6a 00                	push   $0x0
 1fb:	ff 75 08             	pushl  0x8(%ebp)
 1fe:	e8 d0 00 00 00       	call   2d3 <open>
  if(fd < 0)
 203:	83 c4 10             	add    $0x10,%esp
 206:	85 c0                	test   %eax,%eax
 208:	78 24                	js     22e <stat+0x3d>
 20a:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 20c:	83 ec 08             	sub    $0x8,%esp
 20f:	ff 75 0c             	pushl  0xc(%ebp)
 212:	50                   	push   %eax
 213:	e8 d3 00 00 00       	call   2eb <fstat>
 218:	89 c6                	mov    %eax,%esi
  close(fd);
 21a:	89 1c 24             	mov    %ebx,(%esp)
 21d:	e8 99 00 00 00       	call   2bb <close>
  return r;
 222:	83 c4 10             	add    $0x10,%esp
}
 225:	89 f0                	mov    %esi,%eax
 227:	8d 65 f8             	lea    -0x8(%ebp),%esp
 22a:	5b                   	pop    %ebx
 22b:	5e                   	pop    %esi
 22c:	5d                   	pop    %ebp
 22d:	c3                   	ret    
    return -1;
 22e:	be ff ff ff ff       	mov    $0xffffffff,%esi
 233:	eb f0                	jmp    225 <stat+0x34>

00000235 <atoi>:

int
atoi(const char *s)
{
 235:	55                   	push   %ebp
 236:	89 e5                	mov    %esp,%ebp
 238:	53                   	push   %ebx
 239:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 23c:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 241:	eb 0e                	jmp    251 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 243:	8d 14 92             	lea    (%edx,%edx,4),%edx
 246:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 249:	41                   	inc    %ecx
 24a:	0f be c0             	movsbl %al,%eax
 24d:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 251:	8a 01                	mov    (%ecx),%al
 253:	8d 58 d0             	lea    -0x30(%eax),%ebx
 256:	80 fb 09             	cmp    $0x9,%bl
 259:	76 e8                	jbe    243 <atoi+0xe>
  return n;
}
 25b:	89 d0                	mov    %edx,%eax
 25d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 260:	c9                   	leave  
 261:	c3                   	ret    

00000262 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 262:	55                   	push   %ebp
 263:	89 e5                	mov    %esp,%ebp
 265:	56                   	push   %esi
 266:	53                   	push   %ebx
 267:	8b 45 08             	mov    0x8(%ebp),%eax
 26a:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 26d:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 270:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 272:	eb 0c                	jmp    280 <memmove+0x1e>
    *dst++ = *src++;
 274:	8a 13                	mov    (%ebx),%dl
 276:	88 11                	mov    %dl,(%ecx)
 278:	8d 5b 01             	lea    0x1(%ebx),%ebx
 27b:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 27e:	89 f2                	mov    %esi,%edx
 280:	8d 72 ff             	lea    -0x1(%edx),%esi
 283:	85 d2                	test   %edx,%edx
 285:	7f ed                	jg     274 <memmove+0x12>
  return vdst;
}
 287:	5b                   	pop    %ebx
 288:	5e                   	pop    %esi
 289:	5d                   	pop    %ebp
 28a:	c3                   	ret    

0000028b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 28b:	b8 01 00 00 00       	mov    $0x1,%eax
 290:	cd 40                	int    $0x40
 292:	c3                   	ret    

00000293 <exit>:
SYSCALL(exit)
 293:	b8 02 00 00 00       	mov    $0x2,%eax
 298:	cd 40                	int    $0x40
 29a:	c3                   	ret    

0000029b <wait>:
SYSCALL(wait)
 29b:	b8 03 00 00 00       	mov    $0x3,%eax
 2a0:	cd 40                	int    $0x40
 2a2:	c3                   	ret    

000002a3 <pipe>:
SYSCALL(pipe)
 2a3:	b8 04 00 00 00       	mov    $0x4,%eax
 2a8:	cd 40                	int    $0x40
 2aa:	c3                   	ret    

000002ab <read>:
SYSCALL(read)
 2ab:	b8 05 00 00 00       	mov    $0x5,%eax
 2b0:	cd 40                	int    $0x40
 2b2:	c3                   	ret    

000002b3 <write>:
SYSCALL(write)
 2b3:	b8 10 00 00 00       	mov    $0x10,%eax
 2b8:	cd 40                	int    $0x40
 2ba:	c3                   	ret    

000002bb <close>:
SYSCALL(close)
 2bb:	b8 15 00 00 00       	mov    $0x15,%eax
 2c0:	cd 40                	int    $0x40
 2c2:	c3                   	ret    

000002c3 <kill>:
SYSCALL(kill)
 2c3:	b8 06 00 00 00       	mov    $0x6,%eax
 2c8:	cd 40                	int    $0x40
 2ca:	c3                   	ret    

000002cb <exec>:
SYSCALL(exec)
 2cb:	b8 07 00 00 00       	mov    $0x7,%eax
 2d0:	cd 40                	int    $0x40
 2d2:	c3                   	ret    

000002d3 <open>:
SYSCALL(open)
 2d3:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d8:	cd 40                	int    $0x40
 2da:	c3                   	ret    

000002db <mknod>:
SYSCALL(mknod)
 2db:	b8 11 00 00 00       	mov    $0x11,%eax
 2e0:	cd 40                	int    $0x40
 2e2:	c3                   	ret    

000002e3 <unlink>:
SYSCALL(unlink)
 2e3:	b8 12 00 00 00       	mov    $0x12,%eax
 2e8:	cd 40                	int    $0x40
 2ea:	c3                   	ret    

000002eb <fstat>:
SYSCALL(fstat)
 2eb:	b8 08 00 00 00       	mov    $0x8,%eax
 2f0:	cd 40                	int    $0x40
 2f2:	c3                   	ret    

000002f3 <link>:
SYSCALL(link)
 2f3:	b8 13 00 00 00       	mov    $0x13,%eax
 2f8:	cd 40                	int    $0x40
 2fa:	c3                   	ret    

000002fb <mkdir>:
SYSCALL(mkdir)
 2fb:	b8 14 00 00 00       	mov    $0x14,%eax
 300:	cd 40                	int    $0x40
 302:	c3                   	ret    

00000303 <chdir>:
SYSCALL(chdir)
 303:	b8 09 00 00 00       	mov    $0x9,%eax
 308:	cd 40                	int    $0x40
 30a:	c3                   	ret    

0000030b <dup>:
SYSCALL(dup)
 30b:	b8 0a 00 00 00       	mov    $0xa,%eax
 310:	cd 40                	int    $0x40
 312:	c3                   	ret    

00000313 <getpid>:
SYSCALL(getpid)
 313:	b8 0b 00 00 00       	mov    $0xb,%eax
 318:	cd 40                	int    $0x40
 31a:	c3                   	ret    

0000031b <sbrk>:
SYSCALL(sbrk)
 31b:	b8 0c 00 00 00       	mov    $0xc,%eax
 320:	cd 40                	int    $0x40
 322:	c3                   	ret    

00000323 <sleep>:
SYSCALL(sleep)
 323:	b8 0d 00 00 00       	mov    $0xd,%eax
 328:	cd 40                	int    $0x40
 32a:	c3                   	ret    

0000032b <uptime>:
SYSCALL(uptime)
 32b:	b8 0e 00 00 00       	mov    $0xe,%eax
 330:	cd 40                	int    $0x40
 332:	c3                   	ret    

00000333 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 333:	b8 16 00 00 00       	mov    $0x16,%eax
 338:	cd 40                	int    $0x40
 33a:	c3                   	ret    

0000033b <block>:
SYSCALL(block)
 33b:	b8 17 00 00 00       	mov    $0x17,%eax
 340:	cd 40                	int    $0x40
 342:	c3                   	ret    

00000343 <unblock>:
SYSCALL(unblock)
 343:	b8 18 00 00 00       	mov    $0x18,%eax
 348:	cd 40                	int    $0x40
 34a:	c3                   	ret    

0000034b <chmod>:
SYSCALL(chmod)
 34b:	b8 19 00 00 00       	mov    $0x19,%eax
 350:	cd 40                	int    $0x40
 352:	c3                   	ret    

00000353 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	83 ec 1c             	sub    $0x1c,%esp
 359:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 35c:	6a 01                	push   $0x1
 35e:	8d 55 f4             	lea    -0xc(%ebp),%edx
 361:	52                   	push   %edx
 362:	50                   	push   %eax
 363:	e8 4b ff ff ff       	call   2b3 <write>
}
 368:	83 c4 10             	add    $0x10,%esp
 36b:	c9                   	leave  
 36c:	c3                   	ret    

0000036d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 36d:	55                   	push   %ebp
 36e:	89 e5                	mov    %esp,%ebp
 370:	57                   	push   %edi
 371:	56                   	push   %esi
 372:	53                   	push   %ebx
 373:	83 ec 2c             	sub    $0x2c,%esp
 376:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 379:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 37b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 37f:	74 04                	je     385 <printint+0x18>
 381:	85 d2                	test   %edx,%edx
 383:	78 3c                	js     3c1 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 385:	89 d1                	mov    %edx,%ecx
  neg = 0;
 387:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 38e:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 393:	89 c8                	mov    %ecx,%eax
 395:	ba 00 00 00 00       	mov    $0x0,%edx
 39a:	f7 f6                	div    %esi
 39c:	89 df                	mov    %ebx,%edi
 39e:	43                   	inc    %ebx
 39f:	8a 92 18 07 00 00    	mov    0x718(%edx),%dl
 3a5:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3a9:	89 ca                	mov    %ecx,%edx
 3ab:	89 c1                	mov    %eax,%ecx
 3ad:	39 f2                	cmp    %esi,%edx
 3af:	73 e2                	jae    393 <printint+0x26>
  if(neg)
 3b1:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3b5:	74 24                	je     3db <printint+0x6e>
    buf[i++] = '-';
 3b7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3bc:	8d 5f 02             	lea    0x2(%edi),%ebx
 3bf:	eb 1a                	jmp    3db <printint+0x6e>
    x = -xx;
 3c1:	89 d1                	mov    %edx,%ecx
 3c3:	f7 d9                	neg    %ecx
    neg = 1;
 3c5:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3cc:	eb c0                	jmp    38e <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ce:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3d6:	e8 78 ff ff ff       	call   353 <putc>
  while(--i >= 0)
 3db:	4b                   	dec    %ebx
 3dc:	79 f0                	jns    3ce <printint+0x61>
}
 3de:	83 c4 2c             	add    $0x2c,%esp
 3e1:	5b                   	pop    %ebx
 3e2:	5e                   	pop    %esi
 3e3:	5f                   	pop    %edi
 3e4:	5d                   	pop    %ebp
 3e5:	c3                   	ret    

000003e6 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e6:	55                   	push   %ebp
 3e7:	89 e5                	mov    %esp,%ebp
 3e9:	57                   	push   %edi
 3ea:	56                   	push   %esi
 3eb:	53                   	push   %ebx
 3ec:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3ef:	8d 45 10             	lea    0x10(%ebp),%eax
 3f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3f5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3fa:	bb 00 00 00 00       	mov    $0x0,%ebx
 3ff:	eb 12                	jmp    413 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 401:	89 fa                	mov    %edi,%edx
 403:	8b 45 08             	mov    0x8(%ebp),%eax
 406:	e8 48 ff ff ff       	call   353 <putc>
 40b:	eb 05                	jmp    412 <printf+0x2c>
      }
    } else if(state == '%'){
 40d:	83 fe 25             	cmp    $0x25,%esi
 410:	74 22                	je     434 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 412:	43                   	inc    %ebx
 413:	8b 45 0c             	mov    0xc(%ebp),%eax
 416:	8a 04 18             	mov    (%eax,%ebx,1),%al
 419:	84 c0                	test   %al,%al
 41b:	0f 84 1d 01 00 00    	je     53e <printf+0x158>
    c = fmt[i] & 0xff;
 421:	0f be f8             	movsbl %al,%edi
 424:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 427:	85 f6                	test   %esi,%esi
 429:	75 e2                	jne    40d <printf+0x27>
      if(c == '%'){
 42b:	83 f8 25             	cmp    $0x25,%eax
 42e:	75 d1                	jne    401 <printf+0x1b>
        state = '%';
 430:	89 c6                	mov    %eax,%esi
 432:	eb de                	jmp    412 <printf+0x2c>
      if(c == 'd'){
 434:	83 f8 25             	cmp    $0x25,%eax
 437:	0f 84 cc 00 00 00    	je     509 <printf+0x123>
 43d:	0f 8c da 00 00 00    	jl     51d <printf+0x137>
 443:	83 f8 78             	cmp    $0x78,%eax
 446:	0f 8f d1 00 00 00    	jg     51d <printf+0x137>
 44c:	83 f8 63             	cmp    $0x63,%eax
 44f:	0f 8c c8 00 00 00    	jl     51d <printf+0x137>
 455:	83 e8 63             	sub    $0x63,%eax
 458:	83 f8 15             	cmp    $0x15,%eax
 45b:	0f 87 bc 00 00 00    	ja     51d <printf+0x137>
 461:	ff 24 85 c0 06 00 00 	jmp    *0x6c0(,%eax,4)
        printint(fd, *ap, 10, 1);
 468:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46b:	8b 17                	mov    (%edi),%edx
 46d:	83 ec 0c             	sub    $0xc,%esp
 470:	6a 01                	push   $0x1
 472:	b9 0a 00 00 00       	mov    $0xa,%ecx
 477:	8b 45 08             	mov    0x8(%ebp),%eax
 47a:	e8 ee fe ff ff       	call   36d <printint>
        ap++;
 47f:	83 c7 04             	add    $0x4,%edi
 482:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 485:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 488:	be 00 00 00 00       	mov    $0x0,%esi
 48d:	eb 83                	jmp    412 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 48f:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 492:	8b 17                	mov    (%edi),%edx
 494:	83 ec 0c             	sub    $0xc,%esp
 497:	6a 00                	push   $0x0
 499:	b9 10 00 00 00       	mov    $0x10,%ecx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 c7 fe ff ff       	call   36d <printint>
        ap++;
 4a6:	83 c7 04             	add    $0x4,%edi
 4a9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ac:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4af:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4b4:	e9 59 ff ff ff       	jmp    412 <printf+0x2c>
        s = (char*)*ap;
 4b9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4bc:	8b 30                	mov    (%eax),%esi
        ap++;
 4be:	83 c0 04             	add    $0x4,%eax
 4c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4c4:	85 f6                	test   %esi,%esi
 4c6:	75 13                	jne    4db <printf+0xf5>
          s = "(null)";
 4c8:	be b9 06 00 00       	mov    $0x6b9,%esi
 4cd:	eb 0c                	jmp    4db <printf+0xf5>
          putc(fd, *s);
 4cf:	0f be d2             	movsbl %dl,%edx
 4d2:	8b 45 08             	mov    0x8(%ebp),%eax
 4d5:	e8 79 fe ff ff       	call   353 <putc>
          s++;
 4da:	46                   	inc    %esi
        while(*s != 0){
 4db:	8a 16                	mov    (%esi),%dl
 4dd:	84 d2                	test   %dl,%dl
 4df:	75 ee                	jne    4cf <printf+0xe9>
      state = 0;
 4e1:	be 00 00 00 00       	mov    $0x0,%esi
 4e6:	e9 27 ff ff ff       	jmp    412 <printf+0x2c>
        putc(fd, *ap);
 4eb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ee:	0f be 17             	movsbl (%edi),%edx
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	e8 5a fe ff ff       	call   353 <putc>
        ap++;
 4f9:	83 c7 04             	add    $0x4,%edi
 4fc:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ff:	be 00 00 00 00       	mov    $0x0,%esi
 504:	e9 09 ff ff ff       	jmp    412 <printf+0x2c>
        putc(fd, c);
 509:	89 fa                	mov    %edi,%edx
 50b:	8b 45 08             	mov    0x8(%ebp),%eax
 50e:	e8 40 fe ff ff       	call   353 <putc>
      state = 0;
 513:	be 00 00 00 00       	mov    $0x0,%esi
 518:	e9 f5 fe ff ff       	jmp    412 <printf+0x2c>
        putc(fd, '%');
 51d:	ba 25 00 00 00       	mov    $0x25,%edx
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	e8 29 fe ff ff       	call   353 <putc>
        putc(fd, c);
 52a:	89 fa                	mov    %edi,%edx
 52c:	8b 45 08             	mov    0x8(%ebp),%eax
 52f:	e8 1f fe ff ff       	call   353 <putc>
      state = 0;
 534:	be 00 00 00 00       	mov    $0x0,%esi
 539:	e9 d4 fe ff ff       	jmp    412 <printf+0x2c>
    }
  }
}
 53e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 541:	5b                   	pop    %ebx
 542:	5e                   	pop    %esi
 543:	5f                   	pop    %edi
 544:	5d                   	pop    %ebp
 545:	c3                   	ret    

00000546 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	57                   	push   %edi
 54a:	56                   	push   %esi
 54b:	53                   	push   %ebx
 54c:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 54f:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 552:	a1 2c 07 00 00       	mov    0x72c,%eax
 557:	eb 02                	jmp    55b <free+0x15>
 559:	89 d0                	mov    %edx,%eax
 55b:	39 c8                	cmp    %ecx,%eax
 55d:	73 04                	jae    563 <free+0x1d>
 55f:	3b 08                	cmp    (%eax),%ecx
 561:	72 12                	jb     575 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 563:	8b 10                	mov    (%eax),%edx
 565:	39 d0                	cmp    %edx,%eax
 567:	72 f0                	jb     559 <free+0x13>
 569:	39 c8                	cmp    %ecx,%eax
 56b:	72 08                	jb     575 <free+0x2f>
 56d:	39 d1                	cmp    %edx,%ecx
 56f:	72 04                	jb     575 <free+0x2f>
 571:	89 d0                	mov    %edx,%eax
 573:	eb e6                	jmp    55b <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 575:	8b 73 fc             	mov    -0x4(%ebx),%esi
 578:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 57b:	8b 10                	mov    (%eax),%edx
 57d:	39 d7                	cmp    %edx,%edi
 57f:	74 19                	je     59a <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 581:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 584:	8b 50 04             	mov    0x4(%eax),%edx
 587:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58a:	39 ce                	cmp    %ecx,%esi
 58c:	74 1b                	je     5a9 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 58e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 590:	a3 2c 07 00 00       	mov    %eax,0x72c
}
 595:	5b                   	pop    %ebx
 596:	5e                   	pop    %esi
 597:	5f                   	pop    %edi
 598:	5d                   	pop    %ebp
 599:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59a:	03 72 04             	add    0x4(%edx),%esi
 59d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a0:	8b 10                	mov    (%eax),%edx
 5a2:	8b 12                	mov    (%edx),%edx
 5a4:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5a7:	eb db                	jmp    584 <free+0x3e>
    p->s.size += bp->s.size;
 5a9:	03 53 fc             	add    -0x4(%ebx),%edx
 5ac:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5af:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b2:	89 10                	mov    %edx,(%eax)
 5b4:	eb da                	jmp    590 <free+0x4a>

000005b6 <morecore>:

static Header*
morecore(uint nu)
{
 5b6:	55                   	push   %ebp
 5b7:	89 e5                	mov    %esp,%ebp
 5b9:	53                   	push   %ebx
 5ba:	83 ec 04             	sub    $0x4,%esp
 5bd:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5bf:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c4:	77 05                	ja     5cb <morecore+0x15>
    nu = 4096;
 5c6:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5cb:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d2:	83 ec 0c             	sub    $0xc,%esp
 5d5:	50                   	push   %eax
 5d6:	e8 40 fd ff ff       	call   31b <sbrk>
  if(p == (char*)-1)
 5db:	83 c4 10             	add    $0x10,%esp
 5de:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e1:	74 1c                	je     5ff <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e3:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5e6:	83 c0 08             	add    $0x8,%eax
 5e9:	83 ec 0c             	sub    $0xc,%esp
 5ec:	50                   	push   %eax
 5ed:	e8 54 ff ff ff       	call   546 <free>
  return freep;
 5f2:	a1 2c 07 00 00       	mov    0x72c,%eax
 5f7:	83 c4 10             	add    $0x10,%esp
}
 5fa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5fd:	c9                   	leave  
 5fe:	c3                   	ret    
    return 0;
 5ff:	b8 00 00 00 00       	mov    $0x0,%eax
 604:	eb f4                	jmp    5fa <morecore+0x44>

00000606 <malloc>:

void*
malloc(uint nbytes)
{
 606:	55                   	push   %ebp
 607:	89 e5                	mov    %esp,%ebp
 609:	53                   	push   %ebx
 60a:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 60d:	8b 45 08             	mov    0x8(%ebp),%eax
 610:	8d 58 07             	lea    0x7(%eax),%ebx
 613:	c1 eb 03             	shr    $0x3,%ebx
 616:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 617:	8b 0d 2c 07 00 00    	mov    0x72c,%ecx
 61d:	85 c9                	test   %ecx,%ecx
 61f:	74 04                	je     625 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 621:	8b 01                	mov    (%ecx),%eax
 623:	eb 4a                	jmp    66f <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 625:	c7 05 2c 07 00 00 30 	movl   $0x730,0x72c
 62c:	07 00 00 
 62f:	c7 05 30 07 00 00 30 	movl   $0x730,0x730
 636:	07 00 00 
    base.s.size = 0;
 639:	c7 05 34 07 00 00 00 	movl   $0x0,0x734
 640:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 643:	b9 30 07 00 00       	mov    $0x730,%ecx
 648:	eb d7                	jmp    621 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 64a:	74 19                	je     665 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 64c:	29 da                	sub    %ebx,%edx
 64e:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 651:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 654:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 657:	89 0d 2c 07 00 00    	mov    %ecx,0x72c
      return (void*)(p + 1);
 65d:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 660:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 663:	c9                   	leave  
 664:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 665:	8b 10                	mov    (%eax),%edx
 667:	89 11                	mov    %edx,(%ecx)
 669:	eb ec                	jmp    657 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66b:	89 c1                	mov    %eax,%ecx
 66d:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 66f:	8b 50 04             	mov    0x4(%eax),%edx
 672:	39 da                	cmp    %ebx,%edx
 674:	73 d4                	jae    64a <malloc+0x44>
    if(p == freep)
 676:	39 05 2c 07 00 00    	cmp    %eax,0x72c
 67c:	75 ed                	jne    66b <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 67e:	89 d8                	mov    %ebx,%eax
 680:	e8 31 ff ff ff       	call   5b6 <morecore>
 685:	85 c0                	test   %eax,%eax
 687:	75 e2                	jne    66b <malloc+0x65>
 689:	eb d5                	jmp    660 <malloc+0x5a>
