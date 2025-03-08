
_cat:     file format elf32-i386


Disassembly of section .text:

00000000 <cat>:

char buf[512];

void
cat(int fd)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 75 08             	mov    0x8(%ebp),%esi
  int n;

  while((n = read(fd, buf, sizeof(buf))) > 0) {
   8:	83 ec 04             	sub    $0x4,%esp
   b:	68 00 02 00 00       	push   $0x200
  10:	68 20 07 00 00       	push   $0x720
  15:	56                   	push   %esi
  16:	e8 76 02 00 00       	call   291 <read>
  1b:	89 c3                	mov    %eax,%ebx
  1d:	83 c4 10             	add    $0x10,%esp
  20:	85 c0                	test   %eax,%eax
  22:	7e 2b                	jle    4f <cat+0x4f>
    if (write(1, buf, n) != n) {
  24:	83 ec 04             	sub    $0x4,%esp
  27:	53                   	push   %ebx
  28:	68 20 07 00 00       	push   $0x720
  2d:	6a 01                	push   $0x1
  2f:	e8 65 02 00 00       	call   299 <write>
  34:	83 c4 10             	add    $0x10,%esp
  37:	39 d8                	cmp    %ebx,%eax
  39:	74 cd                	je     8 <cat+0x8>
      printf(1, "cat: write error\n");
  3b:	83 ec 08             	sub    $0x8,%esp
  3e:	68 74 06 00 00       	push   $0x674
  43:	6a 01                	push   $0x1
  45:	e8 82 03 00 00       	call   3cc <printf>
      exit();
  4a:	e8 2a 02 00 00       	call   279 <exit>
    }
  }
  if(n < 0){
  4f:	78 07                	js     58 <cat+0x58>
    printf(1, "cat: read error\n");
    exit();
  }
}
  51:	8d 65 f8             	lea    -0x8(%ebp),%esp
  54:	5b                   	pop    %ebx
  55:	5e                   	pop    %esi
  56:	5d                   	pop    %ebp
  57:	c3                   	ret    
    printf(1, "cat: read error\n");
  58:	83 ec 08             	sub    $0x8,%esp
  5b:	68 86 06 00 00       	push   $0x686
  60:	6a 01                	push   $0x1
  62:	e8 65 03 00 00       	call   3cc <printf>
    exit();
  67:	e8 0d 02 00 00       	call   279 <exit>

0000006c <main>:

int
main(int argc, char *argv[])
{
  6c:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  70:	83 e4 f0             	and    $0xfffffff0,%esp
  73:	ff 71 fc             	pushl  -0x4(%ecx)
  76:	55                   	push   %ebp
  77:	89 e5                	mov    %esp,%ebp
  79:	57                   	push   %edi
  7a:	56                   	push   %esi
  7b:	53                   	push   %ebx
  7c:	51                   	push   %ecx
  7d:	83 ec 18             	sub    $0x18,%esp
  80:	8b 01                	mov    (%ecx),%eax
  82:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  85:	8b 51 04             	mov    0x4(%ecx),%edx
  88:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  8b:	83 f8 01             	cmp    $0x1,%eax
  8e:	7e 07                	jle    97 <main+0x2b>
    cat(0);
    exit();
  }

  for(i = 1; i < argc; i++){
  90:	be 01 00 00 00       	mov    $0x1,%esi
  95:	eb 24                	jmp    bb <main+0x4f>
    cat(0);
  97:	83 ec 0c             	sub    $0xc,%esp
  9a:	6a 00                	push   $0x0
  9c:	e8 5f ff ff ff       	call   0 <cat>
    exit();
  a1:	e8 d3 01 00 00       	call   279 <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "cat: cannot open %s\n", argv[i]);
      exit();
    }
    cat(fd);
  a6:	83 ec 0c             	sub    $0xc,%esp
  a9:	50                   	push   %eax
  aa:	e8 51 ff ff ff       	call   0 <cat>
    close(fd);
  af:	89 1c 24             	mov    %ebx,(%esp)
  b2:	e8 ea 01 00 00       	call   2a1 <close>
  for(i = 1; i < argc; i++){
  b7:	46                   	inc    %esi
  b8:	83 c4 10             	add    $0x10,%esp
  bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  be:	39 c6                	cmp    %eax,%esi
  c0:	7d 31                	jge    f3 <main+0x87>
    if((fd = open(argv[i], 0)) < 0){
  c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  c5:	8d 3c b0             	lea    (%eax,%esi,4),%edi
  c8:	83 ec 08             	sub    $0x8,%esp
  cb:	6a 00                	push   $0x0
  cd:	ff 37                	pushl  (%edi)
  cf:	e8 e5 01 00 00       	call   2b9 <open>
  d4:	89 c3                	mov    %eax,%ebx
  d6:	83 c4 10             	add    $0x10,%esp
  d9:	85 c0                	test   %eax,%eax
  db:	79 c9                	jns    a6 <main+0x3a>
      printf(1, "cat: cannot open %s\n", argv[i]);
  dd:	83 ec 04             	sub    $0x4,%esp
  e0:	ff 37                	pushl  (%edi)
  e2:	68 97 06 00 00       	push   $0x697
  e7:	6a 01                	push   $0x1
  e9:	e8 de 02 00 00       	call   3cc <printf>
      exit();
  ee:	e8 86 01 00 00       	call   279 <exit>
  }
  exit();
  f3:	e8 81 01 00 00       	call   279 <exit>

000000f8 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  f8:	55                   	push   %ebp
  f9:	89 e5                	mov    %esp,%ebp
  fb:	56                   	push   %esi
  fc:	53                   	push   %ebx
  fd:	8b 45 08             	mov    0x8(%ebp),%eax
 100:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 103:	89 c2                	mov    %eax,%edx
 105:	89 cb                	mov    %ecx,%ebx
 107:	41                   	inc    %ecx
 108:	89 d6                	mov    %edx,%esi
 10a:	42                   	inc    %edx
 10b:	8a 1b                	mov    (%ebx),%bl
 10d:	88 1e                	mov    %bl,(%esi)
 10f:	84 db                	test   %bl,%bl
 111:	75 f2                	jne    105 <strcpy+0xd>
    ;
  return os;
}
 113:	5b                   	pop    %ebx
 114:	5e                   	pop    %esi
 115:	5d                   	pop    %ebp
 116:	c3                   	ret    

00000117 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 117:	55                   	push   %ebp
 118:	89 e5                	mov    %esp,%ebp
 11a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 11d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 120:	eb 02                	jmp    124 <strcmp+0xd>
    p++, q++;
 122:	41                   	inc    %ecx
 123:	42                   	inc    %edx
  while(*p && *p == *q)
 124:	8a 01                	mov    (%ecx),%al
 126:	84 c0                	test   %al,%al
 128:	74 04                	je     12e <strcmp+0x17>
 12a:	3a 02                	cmp    (%edx),%al
 12c:	74 f4                	je     122 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 12e:	0f b6 c0             	movzbl %al,%eax
 131:	0f b6 12             	movzbl (%edx),%edx
 134:	29 d0                	sub    %edx,%eax
}
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    

00000138 <strlen>:

uint
strlen(const char *s)
{
 138:	55                   	push   %ebp
 139:	89 e5                	mov    %esp,%ebp
 13b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 13e:	b8 00 00 00 00       	mov    $0x0,%eax
 143:	eb 01                	jmp    146 <strlen+0xe>
 145:	40                   	inc    %eax
 146:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 14a:	75 f9                	jne    145 <strlen+0xd>
    ;
  return n;
}
 14c:	5d                   	pop    %ebp
 14d:	c3                   	ret    

0000014e <memset>:

void*
memset(void *dst, int c, uint n)
{
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 152:	8b 7d 08             	mov    0x8(%ebp),%edi
 155:	8b 4d 10             	mov    0x10(%ebp),%ecx
 158:	8b 45 0c             	mov    0xc(%ebp),%eax
 15b:	fc                   	cld    
 15c:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 15e:	8b 45 08             	mov    0x8(%ebp),%eax
 161:	8b 7d fc             	mov    -0x4(%ebp),%edi
 164:	c9                   	leave  
 165:	c3                   	ret    

00000166 <strchr>:

char*
strchr(const char *s, char c)
{
 166:	55                   	push   %ebp
 167:	89 e5                	mov    %esp,%ebp
 169:	8b 45 08             	mov    0x8(%ebp),%eax
 16c:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 16f:	eb 01                	jmp    172 <strchr+0xc>
 171:	40                   	inc    %eax
 172:	8a 10                	mov    (%eax),%dl
 174:	84 d2                	test   %dl,%dl
 176:	74 06                	je     17e <strchr+0x18>
    if(*s == c)
 178:	38 ca                	cmp    %cl,%dl
 17a:	75 f5                	jne    171 <strchr+0xb>
 17c:	eb 05                	jmp    183 <strchr+0x1d>
      return (char*)s;
  return 0;
 17e:	b8 00 00 00 00       	mov    $0x0,%eax
}
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <gets>:

char*
gets(char *buf, int max)
{
 185:	55                   	push   %ebp
 186:	89 e5                	mov    %esp,%ebp
 188:	57                   	push   %edi
 189:	56                   	push   %esi
 18a:	53                   	push   %ebx
 18b:	83 ec 1c             	sub    $0x1c,%esp
 18e:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 191:	bb 00 00 00 00       	mov    $0x0,%ebx
 196:	89 de                	mov    %ebx,%esi
 198:	43                   	inc    %ebx
 199:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 19c:	7d 2b                	jge    1c9 <gets+0x44>
    cc = read(0, &c, 1);
 19e:	83 ec 04             	sub    $0x4,%esp
 1a1:	6a 01                	push   $0x1
 1a3:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1a6:	50                   	push   %eax
 1a7:	6a 00                	push   $0x0
 1a9:	e8 e3 00 00 00       	call   291 <read>
    if(cc < 1)
 1ae:	83 c4 10             	add    $0x10,%esp
 1b1:	85 c0                	test   %eax,%eax
 1b3:	7e 14                	jle    1c9 <gets+0x44>
      break;
    buf[i++] = c;
 1b5:	8a 45 e7             	mov    -0x19(%ebp),%al
 1b8:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1bb:	3c 0a                	cmp    $0xa,%al
 1bd:	74 08                	je     1c7 <gets+0x42>
 1bf:	3c 0d                	cmp    $0xd,%al
 1c1:	75 d3                	jne    196 <gets+0x11>
    buf[i++] = c;
 1c3:	89 de                	mov    %ebx,%esi
 1c5:	eb 02                	jmp    1c9 <gets+0x44>
 1c7:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1c9:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1cd:	89 f8                	mov    %edi,%eax
 1cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1d2:	5b                   	pop    %ebx
 1d3:	5e                   	pop    %esi
 1d4:	5f                   	pop    %edi
 1d5:	5d                   	pop    %ebp
 1d6:	c3                   	ret    

000001d7 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d7:	55                   	push   %ebp
 1d8:	89 e5                	mov    %esp,%ebp
 1da:	56                   	push   %esi
 1db:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1dc:	83 ec 08             	sub    $0x8,%esp
 1df:	6a 00                	push   $0x0
 1e1:	ff 75 08             	pushl  0x8(%ebp)
 1e4:	e8 d0 00 00 00       	call   2b9 <open>
  if(fd < 0)
 1e9:	83 c4 10             	add    $0x10,%esp
 1ec:	85 c0                	test   %eax,%eax
 1ee:	78 24                	js     214 <stat+0x3d>
 1f0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1f2:	83 ec 08             	sub    $0x8,%esp
 1f5:	ff 75 0c             	pushl  0xc(%ebp)
 1f8:	50                   	push   %eax
 1f9:	e8 d3 00 00 00       	call   2d1 <fstat>
 1fe:	89 c6                	mov    %eax,%esi
  close(fd);
 200:	89 1c 24             	mov    %ebx,(%esp)
 203:	e8 99 00 00 00       	call   2a1 <close>
  return r;
 208:	83 c4 10             	add    $0x10,%esp
}
 20b:	89 f0                	mov    %esi,%eax
 20d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    
    return -1;
 214:	be ff ff ff ff       	mov    $0xffffffff,%esi
 219:	eb f0                	jmp    20b <stat+0x34>

0000021b <atoi>:

int
atoi(const char *s)
{
 21b:	55                   	push   %ebp
 21c:	89 e5                	mov    %esp,%ebp
 21e:	53                   	push   %ebx
 21f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 222:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 227:	eb 0e                	jmp    237 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 229:	8d 14 92             	lea    (%edx,%edx,4),%edx
 22c:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 22f:	41                   	inc    %ecx
 230:	0f be c0             	movsbl %al,%eax
 233:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 237:	8a 01                	mov    (%ecx),%al
 239:	8d 58 d0             	lea    -0x30(%eax),%ebx
 23c:	80 fb 09             	cmp    $0x9,%bl
 23f:	76 e8                	jbe    229 <atoi+0xe>
  return n;
}
 241:	89 d0                	mov    %edx,%eax
 243:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 246:	c9                   	leave  
 247:	c3                   	ret    

00000248 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 248:	55                   	push   %ebp
 249:	89 e5                	mov    %esp,%ebp
 24b:	56                   	push   %esi
 24c:	53                   	push   %ebx
 24d:	8b 45 08             	mov    0x8(%ebp),%eax
 250:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 253:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 256:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 258:	eb 0c                	jmp    266 <memmove+0x1e>
    *dst++ = *src++;
 25a:	8a 13                	mov    (%ebx),%dl
 25c:	88 11                	mov    %dl,(%ecx)
 25e:	8d 5b 01             	lea    0x1(%ebx),%ebx
 261:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 264:	89 f2                	mov    %esi,%edx
 266:	8d 72 ff             	lea    -0x1(%edx),%esi
 269:	85 d2                	test   %edx,%edx
 26b:	7f ed                	jg     25a <memmove+0x12>
  return vdst;
}
 26d:	5b                   	pop    %ebx
 26e:	5e                   	pop    %esi
 26f:	5d                   	pop    %ebp
 270:	c3                   	ret    

00000271 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 271:	b8 01 00 00 00       	mov    $0x1,%eax
 276:	cd 40                	int    $0x40
 278:	c3                   	ret    

00000279 <exit>:
SYSCALL(exit)
 279:	b8 02 00 00 00       	mov    $0x2,%eax
 27e:	cd 40                	int    $0x40
 280:	c3                   	ret    

00000281 <wait>:
SYSCALL(wait)
 281:	b8 03 00 00 00       	mov    $0x3,%eax
 286:	cd 40                	int    $0x40
 288:	c3                   	ret    

00000289 <pipe>:
SYSCALL(pipe)
 289:	b8 04 00 00 00       	mov    $0x4,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <read>:
SYSCALL(read)
 291:	b8 05 00 00 00       	mov    $0x5,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <write>:
SYSCALL(write)
 299:	b8 10 00 00 00       	mov    $0x10,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <close>:
SYSCALL(close)
 2a1:	b8 15 00 00 00       	mov    $0x15,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <kill>:
SYSCALL(kill)
 2a9:	b8 06 00 00 00       	mov    $0x6,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <exec>:
SYSCALL(exec)
 2b1:	b8 07 00 00 00       	mov    $0x7,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <open>:
SYSCALL(open)
 2b9:	b8 0f 00 00 00       	mov    $0xf,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <mknod>:
SYSCALL(mknod)
 2c1:	b8 11 00 00 00       	mov    $0x11,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <unlink>:
SYSCALL(unlink)
 2c9:	b8 12 00 00 00       	mov    $0x12,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <fstat>:
SYSCALL(fstat)
 2d1:	b8 08 00 00 00       	mov    $0x8,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <link>:
SYSCALL(link)
 2d9:	b8 13 00 00 00       	mov    $0x13,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <mkdir>:
SYSCALL(mkdir)
 2e1:	b8 14 00 00 00       	mov    $0x14,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <chdir>:
SYSCALL(chdir)
 2e9:	b8 09 00 00 00       	mov    $0x9,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <dup>:
SYSCALL(dup)
 2f1:	b8 0a 00 00 00       	mov    $0xa,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <getpid>:
SYSCALL(getpid)
 2f9:	b8 0b 00 00 00       	mov    $0xb,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <sbrk>:
SYSCALL(sbrk)
 301:	b8 0c 00 00 00       	mov    $0xc,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <sleep>:
SYSCALL(sleep)
 309:	b8 0d 00 00 00       	mov    $0xd,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <uptime>:
SYSCALL(uptime)
 311:	b8 0e 00 00 00       	mov    $0xe,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 319:	b8 16 00 00 00       	mov    $0x16,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <block>:
SYSCALL(block)
 321:	b8 17 00 00 00       	mov    $0x17,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <unblock>:
SYSCALL(unblock)
 329:	b8 18 00 00 00       	mov    $0x18,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <chmod>:
SYSCALL(chmod)
 331:	b8 19 00 00 00       	mov    $0x19,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 339:	55                   	push   %ebp
 33a:	89 e5                	mov    %esp,%ebp
 33c:	83 ec 1c             	sub    $0x1c,%esp
 33f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 342:	6a 01                	push   $0x1
 344:	8d 55 f4             	lea    -0xc(%ebp),%edx
 347:	52                   	push   %edx
 348:	50                   	push   %eax
 349:	e8 4b ff ff ff       	call   299 <write>
}
 34e:	83 c4 10             	add    $0x10,%esp
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	57                   	push   %edi
 357:	56                   	push   %esi
 358:	53                   	push   %ebx
 359:	83 ec 2c             	sub    $0x2c,%esp
 35c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 35f:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 365:	74 04                	je     36b <printint+0x18>
 367:	85 d2                	test   %edx,%edx
 369:	78 3c                	js     3a7 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 36b:	89 d1                	mov    %edx,%ecx
  neg = 0;
 36d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 374:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 379:	89 c8                	mov    %ecx,%eax
 37b:	ba 00 00 00 00       	mov    $0x0,%edx
 380:	f7 f6                	div    %esi
 382:	89 df                	mov    %ebx,%edi
 384:	43                   	inc    %ebx
 385:	8a 92 0c 07 00 00    	mov    0x70c(%edx),%dl
 38b:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 38f:	89 ca                	mov    %ecx,%edx
 391:	89 c1                	mov    %eax,%ecx
 393:	39 f2                	cmp    %esi,%edx
 395:	73 e2                	jae    379 <printint+0x26>
  if(neg)
 397:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 39b:	74 24                	je     3c1 <printint+0x6e>
    buf[i++] = '-';
 39d:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3a2:	8d 5f 02             	lea    0x2(%edi),%ebx
 3a5:	eb 1a                	jmp    3c1 <printint+0x6e>
    x = -xx;
 3a7:	89 d1                	mov    %edx,%ecx
 3a9:	f7 d9                	neg    %ecx
    neg = 1;
 3ab:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3b2:	eb c0                	jmp    374 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 3b4:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3b9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3bc:	e8 78 ff ff ff       	call   339 <putc>
  while(--i >= 0)
 3c1:	4b                   	dec    %ebx
 3c2:	79 f0                	jns    3b4 <printint+0x61>
}
 3c4:	83 c4 2c             	add    $0x2c,%esp
 3c7:	5b                   	pop    %ebx
 3c8:	5e                   	pop    %esi
 3c9:	5f                   	pop    %edi
 3ca:	5d                   	pop    %ebp
 3cb:	c3                   	ret    

000003cc <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3cc:	55                   	push   %ebp
 3cd:	89 e5                	mov    %esp,%ebp
 3cf:	57                   	push   %edi
 3d0:	56                   	push   %esi
 3d1:	53                   	push   %ebx
 3d2:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3d5:	8d 45 10             	lea    0x10(%ebp),%eax
 3d8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3db:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3e0:	bb 00 00 00 00       	mov    $0x0,%ebx
 3e5:	eb 12                	jmp    3f9 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3e7:	89 fa                	mov    %edi,%edx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	e8 48 ff ff ff       	call   339 <putc>
 3f1:	eb 05                	jmp    3f8 <printf+0x2c>
      }
    } else if(state == '%'){
 3f3:	83 fe 25             	cmp    $0x25,%esi
 3f6:	74 22                	je     41a <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 3f8:	43                   	inc    %ebx
 3f9:	8b 45 0c             	mov    0xc(%ebp),%eax
 3fc:	8a 04 18             	mov    (%eax,%ebx,1),%al
 3ff:	84 c0                	test   %al,%al
 401:	0f 84 1d 01 00 00    	je     524 <printf+0x158>
    c = fmt[i] & 0xff;
 407:	0f be f8             	movsbl %al,%edi
 40a:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 40d:	85 f6                	test   %esi,%esi
 40f:	75 e2                	jne    3f3 <printf+0x27>
      if(c == '%'){
 411:	83 f8 25             	cmp    $0x25,%eax
 414:	75 d1                	jne    3e7 <printf+0x1b>
        state = '%';
 416:	89 c6                	mov    %eax,%esi
 418:	eb de                	jmp    3f8 <printf+0x2c>
      if(c == 'd'){
 41a:	83 f8 25             	cmp    $0x25,%eax
 41d:	0f 84 cc 00 00 00    	je     4ef <printf+0x123>
 423:	0f 8c da 00 00 00    	jl     503 <printf+0x137>
 429:	83 f8 78             	cmp    $0x78,%eax
 42c:	0f 8f d1 00 00 00    	jg     503 <printf+0x137>
 432:	83 f8 63             	cmp    $0x63,%eax
 435:	0f 8c c8 00 00 00    	jl     503 <printf+0x137>
 43b:	83 e8 63             	sub    $0x63,%eax
 43e:	83 f8 15             	cmp    $0x15,%eax
 441:	0f 87 bc 00 00 00    	ja     503 <printf+0x137>
 447:	ff 24 85 b4 06 00 00 	jmp    *0x6b4(,%eax,4)
        printint(fd, *ap, 10, 1);
 44e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 451:	8b 17                	mov    (%edi),%edx
 453:	83 ec 0c             	sub    $0xc,%esp
 456:	6a 01                	push   $0x1
 458:	b9 0a 00 00 00       	mov    $0xa,%ecx
 45d:	8b 45 08             	mov    0x8(%ebp),%eax
 460:	e8 ee fe ff ff       	call   353 <printint>
        ap++;
 465:	83 c7 04             	add    $0x4,%edi
 468:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 46b:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 46e:	be 00 00 00 00       	mov    $0x0,%esi
 473:	eb 83                	jmp    3f8 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 475:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 478:	8b 17                	mov    (%edi),%edx
 47a:	83 ec 0c             	sub    $0xc,%esp
 47d:	6a 00                	push   $0x0
 47f:	b9 10 00 00 00       	mov    $0x10,%ecx
 484:	8b 45 08             	mov    0x8(%ebp),%eax
 487:	e8 c7 fe ff ff       	call   353 <printint>
        ap++;
 48c:	83 c7 04             	add    $0x4,%edi
 48f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 492:	83 c4 10             	add    $0x10,%esp
      state = 0;
 495:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 49a:	e9 59 ff ff ff       	jmp    3f8 <printf+0x2c>
        s = (char*)*ap;
 49f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4a2:	8b 30                	mov    (%eax),%esi
        ap++;
 4a4:	83 c0 04             	add    $0x4,%eax
 4a7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4aa:	85 f6                	test   %esi,%esi
 4ac:	75 13                	jne    4c1 <printf+0xf5>
          s = "(null)";
 4ae:	be ac 06 00 00       	mov    $0x6ac,%esi
 4b3:	eb 0c                	jmp    4c1 <printf+0xf5>
          putc(fd, *s);
 4b5:	0f be d2             	movsbl %dl,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	e8 79 fe ff ff       	call   339 <putc>
          s++;
 4c0:	46                   	inc    %esi
        while(*s != 0){
 4c1:	8a 16                	mov    (%esi),%dl
 4c3:	84 d2                	test   %dl,%dl
 4c5:	75 ee                	jne    4b5 <printf+0xe9>
      state = 0;
 4c7:	be 00 00 00 00       	mov    $0x0,%esi
 4cc:	e9 27 ff ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, *ap);
 4d1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4d4:	0f be 17             	movsbl (%edi),%edx
 4d7:	8b 45 08             	mov    0x8(%ebp),%eax
 4da:	e8 5a fe ff ff       	call   339 <putc>
        ap++;
 4df:	83 c7 04             	add    $0x4,%edi
 4e2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4e5:	be 00 00 00 00       	mov    $0x0,%esi
 4ea:	e9 09 ff ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, c);
 4ef:	89 fa                	mov    %edi,%edx
 4f1:	8b 45 08             	mov    0x8(%ebp),%eax
 4f4:	e8 40 fe ff ff       	call   339 <putc>
      state = 0;
 4f9:	be 00 00 00 00       	mov    $0x0,%esi
 4fe:	e9 f5 fe ff ff       	jmp    3f8 <printf+0x2c>
        putc(fd, '%');
 503:	ba 25 00 00 00       	mov    $0x25,%edx
 508:	8b 45 08             	mov    0x8(%ebp),%eax
 50b:	e8 29 fe ff ff       	call   339 <putc>
        putc(fd, c);
 510:	89 fa                	mov    %edi,%edx
 512:	8b 45 08             	mov    0x8(%ebp),%eax
 515:	e8 1f fe ff ff       	call   339 <putc>
      state = 0;
 51a:	be 00 00 00 00       	mov    $0x0,%esi
 51f:	e9 d4 fe ff ff       	jmp    3f8 <printf+0x2c>
    }
  }
}
 524:	8d 65 f4             	lea    -0xc(%ebp),%esp
 527:	5b                   	pop    %ebx
 528:	5e                   	pop    %esi
 529:	5f                   	pop    %edi
 52a:	5d                   	pop    %ebp
 52b:	c3                   	ret    

0000052c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 52c:	55                   	push   %ebp
 52d:	89 e5                	mov    %esp,%ebp
 52f:	57                   	push   %edi
 530:	56                   	push   %esi
 531:	53                   	push   %ebx
 532:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 535:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 538:	a1 20 09 00 00       	mov    0x920,%eax
 53d:	eb 02                	jmp    541 <free+0x15>
 53f:	89 d0                	mov    %edx,%eax
 541:	39 c8                	cmp    %ecx,%eax
 543:	73 04                	jae    549 <free+0x1d>
 545:	3b 08                	cmp    (%eax),%ecx
 547:	72 12                	jb     55b <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 549:	8b 10                	mov    (%eax),%edx
 54b:	39 d0                	cmp    %edx,%eax
 54d:	72 f0                	jb     53f <free+0x13>
 54f:	39 c8                	cmp    %ecx,%eax
 551:	72 08                	jb     55b <free+0x2f>
 553:	39 d1                	cmp    %edx,%ecx
 555:	72 04                	jb     55b <free+0x2f>
 557:	89 d0                	mov    %edx,%eax
 559:	eb e6                	jmp    541 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 55b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 55e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 561:	8b 10                	mov    (%eax),%edx
 563:	39 d7                	cmp    %edx,%edi
 565:	74 19                	je     580 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 567:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 56a:	8b 50 04             	mov    0x4(%eax),%edx
 56d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 570:	39 ce                	cmp    %ecx,%esi
 572:	74 1b                	je     58f <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 574:	89 08                	mov    %ecx,(%eax)
  freep = p;
 576:	a3 20 09 00 00       	mov    %eax,0x920
}
 57b:	5b                   	pop    %ebx
 57c:	5e                   	pop    %esi
 57d:	5f                   	pop    %edi
 57e:	5d                   	pop    %ebp
 57f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 580:	03 72 04             	add    0x4(%edx),%esi
 583:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 586:	8b 10                	mov    (%eax),%edx
 588:	8b 12                	mov    (%edx),%edx
 58a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 58d:	eb db                	jmp    56a <free+0x3e>
    p->s.size += bp->s.size;
 58f:	03 53 fc             	add    -0x4(%ebx),%edx
 592:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 595:	8b 53 f8             	mov    -0x8(%ebx),%edx
 598:	89 10                	mov    %edx,(%eax)
 59a:	eb da                	jmp    576 <free+0x4a>

0000059c <morecore>:

static Header*
morecore(uint nu)
{
 59c:	55                   	push   %ebp
 59d:	89 e5                	mov    %esp,%ebp
 59f:	53                   	push   %ebx
 5a0:	83 ec 04             	sub    $0x4,%esp
 5a3:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5a5:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5aa:	77 05                	ja     5b1 <morecore+0x15>
    nu = 4096;
 5ac:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5b1:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5b8:	83 ec 0c             	sub    $0xc,%esp
 5bb:	50                   	push   %eax
 5bc:	e8 40 fd ff ff       	call   301 <sbrk>
  if(p == (char*)-1)
 5c1:	83 c4 10             	add    $0x10,%esp
 5c4:	83 f8 ff             	cmp    $0xffffffff,%eax
 5c7:	74 1c                	je     5e5 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5c9:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5cc:	83 c0 08             	add    $0x8,%eax
 5cf:	83 ec 0c             	sub    $0xc,%esp
 5d2:	50                   	push   %eax
 5d3:	e8 54 ff ff ff       	call   52c <free>
  return freep;
 5d8:	a1 20 09 00 00       	mov    0x920,%eax
 5dd:	83 c4 10             	add    $0x10,%esp
}
 5e0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 5e3:	c9                   	leave  
 5e4:	c3                   	ret    
    return 0;
 5e5:	b8 00 00 00 00       	mov    $0x0,%eax
 5ea:	eb f4                	jmp    5e0 <morecore+0x44>

000005ec <malloc>:

void*
malloc(uint nbytes)
{
 5ec:	55                   	push   %ebp
 5ed:	89 e5                	mov    %esp,%ebp
 5ef:	53                   	push   %ebx
 5f0:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5f3:	8b 45 08             	mov    0x8(%ebp),%eax
 5f6:	8d 58 07             	lea    0x7(%eax),%ebx
 5f9:	c1 eb 03             	shr    $0x3,%ebx
 5fc:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 5fd:	8b 0d 20 09 00 00    	mov    0x920,%ecx
 603:	85 c9                	test   %ecx,%ecx
 605:	74 04                	je     60b <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 607:	8b 01                	mov    (%ecx),%eax
 609:	eb 4a                	jmp    655 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 60b:	c7 05 20 09 00 00 24 	movl   $0x924,0x920
 612:	09 00 00 
 615:	c7 05 24 09 00 00 24 	movl   $0x924,0x924
 61c:	09 00 00 
    base.s.size = 0;
 61f:	c7 05 28 09 00 00 00 	movl   $0x0,0x928
 626:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 629:	b9 24 09 00 00       	mov    $0x924,%ecx
 62e:	eb d7                	jmp    607 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 630:	74 19                	je     64b <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 632:	29 da                	sub    %ebx,%edx
 634:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 637:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 63a:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 63d:	89 0d 20 09 00 00    	mov    %ecx,0x920
      return (void*)(p + 1);
 643:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 646:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 649:	c9                   	leave  
 64a:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 64b:	8b 10                	mov    (%eax),%edx
 64d:	89 11                	mov    %edx,(%ecx)
 64f:	eb ec                	jmp    63d <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 651:	89 c1                	mov    %eax,%ecx
 653:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 655:	8b 50 04             	mov    0x4(%eax),%edx
 658:	39 da                	cmp    %ebx,%edx
 65a:	73 d4                	jae    630 <malloc+0x44>
    if(p == freep)
 65c:	39 05 20 09 00 00    	cmp    %eax,0x920
 662:	75 ed                	jne    651 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 664:	89 d8                	mov    %ebx,%eax
 666:	e8 31 ff ff ff       	call   59c <morecore>
 66b:	85 c0                	test   %eax,%eax
 66d:	75 e2                	jne    651 <malloc+0x65>
 66f:	eb d5                	jmp    646 <malloc+0x5a>
