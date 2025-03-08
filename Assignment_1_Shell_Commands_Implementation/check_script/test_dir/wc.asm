
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  10:	be 00 00 00 00       	mov    $0x0,%esi
  15:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  23:	83 ec 04             	sub    $0x4,%esp
  26:	68 00 02 00 00       	push   $0x200
  2b:	68 80 07 00 00       	push   $0x780
  30:	ff 75 08             	pushl  0x8(%ebp)
  33:	e8 bc 02 00 00       	call   2f4 <read>
  38:	89 c7                	mov    %eax,%edi
  3a:	83 c4 10             	add    $0x10,%esp
  3d:	85 c0                	test   %eax,%eax
  3f:	7e 4d                	jle    8e <wc+0x8e>
    for(i=0; i<n; i++){
  41:	bb 00 00 00 00       	mov    $0x0,%ebx
  46:	eb 20                	jmp    68 <wc+0x68>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	0f be c0             	movsbl %al,%eax
  4e:	50                   	push   %eax
  4f:	68 d4 06 00 00       	push   $0x6d4
  54:	e8 70 01 00 00       	call   1c9 <strchr>
  59:	83 c4 10             	add    $0x10,%esp
  5c:	85 c0                	test   %eax,%eax
  5e:	74 1c                	je     7c <wc+0x7c>
        inword = 0;
  60:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  67:	43                   	inc    %ebx
  68:	39 fb                	cmp    %edi,%ebx
  6a:	7d b7                	jge    23 <wc+0x23>
      c++;
  6c:	46                   	inc    %esi
      if(buf[i] == '\n')
  6d:	8a 83 80 07 00 00    	mov    0x780(%ebx),%al
  73:	3c 0a                	cmp    $0xa,%al
  75:	75 d1                	jne    48 <wc+0x48>
        l++;
  77:	ff 45 e0             	incl   -0x20(%ebp)
  7a:	eb cc                	jmp    48 <wc+0x48>
      else if(!inword){
  7c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80:	75 e5                	jne    67 <wc+0x67>
        w++;
  82:	ff 45 dc             	incl   -0x24(%ebp)
        inword = 1;
  85:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  8c:	eb d9                	jmp    67 <wc+0x67>
      }
    }
  }
  if(n < 0){
  8e:	78 24                	js     b4 <wc+0xb4>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  90:	83 ec 08             	sub    $0x8,%esp
  93:	ff 75 0c             	pushl  0xc(%ebp)
  96:	56                   	push   %esi
  97:	ff 75 dc             	pushl  -0x24(%ebp)
  9a:	ff 75 e0             	pushl  -0x20(%ebp)
  9d:	68 ea 06 00 00       	push   $0x6ea
  a2:	6a 01                	push   $0x1
  a4:	e8 86 03 00 00       	call   42f <printf>
}
  a9:	83 c4 20             	add    $0x20,%esp
  ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
  af:	5b                   	pop    %ebx
  b0:	5e                   	pop    %esi
  b1:	5f                   	pop    %edi
  b2:	5d                   	pop    %ebp
  b3:	c3                   	ret    
    printf(1, "wc: read error\n");
  b4:	83 ec 08             	sub    $0x8,%esp
  b7:	68 da 06 00 00       	push   $0x6da
  bc:	6a 01                	push   $0x1
  be:	e8 6c 03 00 00       	call   42f <printf>
    exit();
  c3:	e8 14 02 00 00       	call   2dc <exit>

000000c8 <main>:

int
main(int argc, char *argv[])
{
  c8:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  cc:	83 e4 f0             	and    $0xfffffff0,%esp
  cf:	ff 71 fc             	pushl  -0x4(%ecx)
  d2:	55                   	push   %ebp
  d3:	89 e5                	mov    %esp,%ebp
  d5:	57                   	push   %edi
  d6:	56                   	push   %esi
  d7:	53                   	push   %ebx
  d8:	51                   	push   %ecx
  d9:	83 ec 18             	sub    $0x18,%esp
  dc:	8b 01                	mov    (%ecx),%eax
  de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  e1:	8b 51 04             	mov    0x4(%ecx),%edx
  e4:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  e7:	83 f8 01             	cmp    $0x1,%eax
  ea:	7e 07                	jle    f3 <main+0x2b>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  ec:	be 01 00 00 00       	mov    $0x1,%esi
  f1:	eb 2b                	jmp    11e <main+0x56>
    wc(0, "");
  f3:	83 ec 08             	sub    $0x8,%esp
  f6:	68 e9 06 00 00       	push   $0x6e9
  fb:	6a 00                	push   $0x0
  fd:	e8 fe fe ff ff       	call   0 <wc>
    exit();
 102:	e8 d5 01 00 00       	call   2dc <exit>
    if((fd = open(argv[i], 0)) < 0){
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 107:	83 ec 08             	sub    $0x8,%esp
 10a:	ff 37                	pushl  (%edi)
 10c:	50                   	push   %eax
 10d:	e8 ee fe ff ff       	call   0 <wc>
    close(fd);
 112:	89 1c 24             	mov    %ebx,(%esp)
 115:	e8 ea 01 00 00       	call   304 <close>
  for(i = 1; i < argc; i++){
 11a:	46                   	inc    %esi
 11b:	83 c4 10             	add    $0x10,%esp
 11e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 121:	39 c6                	cmp    %eax,%esi
 123:	7d 31                	jge    156 <main+0x8e>
    if((fd = open(argv[i], 0)) < 0){
 125:	8b 45 e0             	mov    -0x20(%ebp),%eax
 128:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 12b:	83 ec 08             	sub    $0x8,%esp
 12e:	6a 00                	push   $0x0
 130:	ff 37                	pushl  (%edi)
 132:	e8 e5 01 00 00       	call   31c <open>
 137:	89 c3                	mov    %eax,%ebx
 139:	83 c4 10             	add    $0x10,%esp
 13c:	85 c0                	test   %eax,%eax
 13e:	79 c7                	jns    107 <main+0x3f>
      printf(1, "wc: cannot open %s\n", argv[i]);
 140:	83 ec 04             	sub    $0x4,%esp
 143:	ff 37                	pushl  (%edi)
 145:	68 f7 06 00 00       	push   $0x6f7
 14a:	6a 01                	push   $0x1
 14c:	e8 de 02 00 00       	call   42f <printf>
      exit();
 151:	e8 86 01 00 00       	call   2dc <exit>
  }
  exit();
 156:	e8 81 01 00 00       	call   2dc <exit>

0000015b <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 15b:	55                   	push   %ebp
 15c:	89 e5                	mov    %esp,%ebp
 15e:	56                   	push   %esi
 15f:	53                   	push   %ebx
 160:	8b 45 08             	mov    0x8(%ebp),%eax
 163:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 166:	89 c2                	mov    %eax,%edx
 168:	89 cb                	mov    %ecx,%ebx
 16a:	41                   	inc    %ecx
 16b:	89 d6                	mov    %edx,%esi
 16d:	42                   	inc    %edx
 16e:	8a 1b                	mov    (%ebx),%bl
 170:	88 1e                	mov    %bl,(%esi)
 172:	84 db                	test   %bl,%bl
 174:	75 f2                	jne    168 <strcpy+0xd>
    ;
  return os;
}
 176:	5b                   	pop    %ebx
 177:	5e                   	pop    %esi
 178:	5d                   	pop    %ebp
 179:	c3                   	ret    

0000017a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 17a:	55                   	push   %ebp
 17b:	89 e5                	mov    %esp,%ebp
 17d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 180:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 183:	eb 02                	jmp    187 <strcmp+0xd>
    p++, q++;
 185:	41                   	inc    %ecx
 186:	42                   	inc    %edx
  while(*p && *p == *q)
 187:	8a 01                	mov    (%ecx),%al
 189:	84 c0                	test   %al,%al
 18b:	74 04                	je     191 <strcmp+0x17>
 18d:	3a 02                	cmp    (%edx),%al
 18f:	74 f4                	je     185 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 191:	0f b6 c0             	movzbl %al,%eax
 194:	0f b6 12             	movzbl (%edx),%edx
 197:	29 d0                	sub    %edx,%eax
}
 199:	5d                   	pop    %ebp
 19a:	c3                   	ret    

0000019b <strlen>:

uint
strlen(const char *s)
{
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1a1:	b8 00 00 00 00       	mov    $0x0,%eax
 1a6:	eb 01                	jmp    1a9 <strlen+0xe>
 1a8:	40                   	inc    %eax
 1a9:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1ad:	75 f9                	jne    1a8 <strlen+0xd>
    ;
  return n;
}
 1af:	5d                   	pop    %ebp
 1b0:	c3                   	ret    

000001b1 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1b1:	55                   	push   %ebp
 1b2:	89 e5                	mov    %esp,%ebp
 1b4:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1b5:	8b 7d 08             	mov    0x8(%ebp),%edi
 1b8:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1bb:	8b 45 0c             	mov    0xc(%ebp),%eax
 1be:	fc                   	cld    
 1bf:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1c1:	8b 45 08             	mov    0x8(%ebp),%eax
 1c4:	8b 7d fc             	mov    -0x4(%ebp),%edi
 1c7:	c9                   	leave  
 1c8:	c3                   	ret    

000001c9 <strchr>:

char*
strchr(const char *s, char c)
{
 1c9:	55                   	push   %ebp
 1ca:	89 e5                	mov    %esp,%ebp
 1cc:	8b 45 08             	mov    0x8(%ebp),%eax
 1cf:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1d2:	eb 01                	jmp    1d5 <strchr+0xc>
 1d4:	40                   	inc    %eax
 1d5:	8a 10                	mov    (%eax),%dl
 1d7:	84 d2                	test   %dl,%dl
 1d9:	74 06                	je     1e1 <strchr+0x18>
    if(*s == c)
 1db:	38 ca                	cmp    %cl,%dl
 1dd:	75 f5                	jne    1d4 <strchr+0xb>
 1df:	eb 05                	jmp    1e6 <strchr+0x1d>
      return (char*)s;
  return 0;
 1e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1e6:	5d                   	pop    %ebp
 1e7:	c3                   	ret    

000001e8 <gets>:

char*
gets(char *buf, int max)
{
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	57                   	push   %edi
 1ec:	56                   	push   %esi
 1ed:	53                   	push   %ebx
 1ee:	83 ec 1c             	sub    $0x1c,%esp
 1f1:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f4:	bb 00 00 00 00       	mov    $0x0,%ebx
 1f9:	89 de                	mov    %ebx,%esi
 1fb:	43                   	inc    %ebx
 1fc:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ff:	7d 2b                	jge    22c <gets+0x44>
    cc = read(0, &c, 1);
 201:	83 ec 04             	sub    $0x4,%esp
 204:	6a 01                	push   $0x1
 206:	8d 45 e7             	lea    -0x19(%ebp),%eax
 209:	50                   	push   %eax
 20a:	6a 00                	push   $0x0
 20c:	e8 e3 00 00 00       	call   2f4 <read>
    if(cc < 1)
 211:	83 c4 10             	add    $0x10,%esp
 214:	85 c0                	test   %eax,%eax
 216:	7e 14                	jle    22c <gets+0x44>
      break;
    buf[i++] = c;
 218:	8a 45 e7             	mov    -0x19(%ebp),%al
 21b:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 21e:	3c 0a                	cmp    $0xa,%al
 220:	74 08                	je     22a <gets+0x42>
 222:	3c 0d                	cmp    $0xd,%al
 224:	75 d3                	jne    1f9 <gets+0x11>
    buf[i++] = c;
 226:	89 de                	mov    %ebx,%esi
 228:	eb 02                	jmp    22c <gets+0x44>
 22a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 22c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 230:	89 f8                	mov    %edi,%eax
 232:	8d 65 f4             	lea    -0xc(%ebp),%esp
 235:	5b                   	pop    %ebx
 236:	5e                   	pop    %esi
 237:	5f                   	pop    %edi
 238:	5d                   	pop    %ebp
 239:	c3                   	ret    

0000023a <stat>:

int
stat(const char *n, struct stat *st)
{
 23a:	55                   	push   %ebp
 23b:	89 e5                	mov    %esp,%ebp
 23d:	56                   	push   %esi
 23e:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 23f:	83 ec 08             	sub    $0x8,%esp
 242:	6a 00                	push   $0x0
 244:	ff 75 08             	pushl  0x8(%ebp)
 247:	e8 d0 00 00 00       	call   31c <open>
  if(fd < 0)
 24c:	83 c4 10             	add    $0x10,%esp
 24f:	85 c0                	test   %eax,%eax
 251:	78 24                	js     277 <stat+0x3d>
 253:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 255:	83 ec 08             	sub    $0x8,%esp
 258:	ff 75 0c             	pushl  0xc(%ebp)
 25b:	50                   	push   %eax
 25c:	e8 d3 00 00 00       	call   334 <fstat>
 261:	89 c6                	mov    %eax,%esi
  close(fd);
 263:	89 1c 24             	mov    %ebx,(%esp)
 266:	e8 99 00 00 00       	call   304 <close>
  return r;
 26b:	83 c4 10             	add    $0x10,%esp
}
 26e:	89 f0                	mov    %esi,%eax
 270:	8d 65 f8             	lea    -0x8(%ebp),%esp
 273:	5b                   	pop    %ebx
 274:	5e                   	pop    %esi
 275:	5d                   	pop    %ebp
 276:	c3                   	ret    
    return -1;
 277:	be ff ff ff ff       	mov    $0xffffffff,%esi
 27c:	eb f0                	jmp    26e <stat+0x34>

0000027e <atoi>:

int
atoi(const char *s)
{
 27e:	55                   	push   %ebp
 27f:	89 e5                	mov    %esp,%ebp
 281:	53                   	push   %ebx
 282:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 285:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 28a:	eb 0e                	jmp    29a <atoi+0x1c>
    n = n*10 + *s++ - '0';
 28c:	8d 14 92             	lea    (%edx,%edx,4),%edx
 28f:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 292:	41                   	inc    %ecx
 293:	0f be c0             	movsbl %al,%eax
 296:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 29a:	8a 01                	mov    (%ecx),%al
 29c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 29f:	80 fb 09             	cmp    $0x9,%bl
 2a2:	76 e8                	jbe    28c <atoi+0xe>
  return n;
}
 2a4:	89 d0                	mov    %edx,%eax
 2a6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a9:	c9                   	leave  
 2aa:	c3                   	ret    

000002ab <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ab:	55                   	push   %ebp
 2ac:	89 e5                	mov    %esp,%ebp
 2ae:	56                   	push   %esi
 2af:	53                   	push   %ebx
 2b0:	8b 45 08             	mov    0x8(%ebp),%eax
 2b3:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2b6:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2b9:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2bb:	eb 0c                	jmp    2c9 <memmove+0x1e>
    *dst++ = *src++;
 2bd:	8a 13                	mov    (%ebx),%dl
 2bf:	88 11                	mov    %dl,(%ecx)
 2c1:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2c4:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2c7:	89 f2                	mov    %esi,%edx
 2c9:	8d 72 ff             	lea    -0x1(%edx),%esi
 2cc:	85 d2                	test   %edx,%edx
 2ce:	7f ed                	jg     2bd <memmove+0x12>
  return vdst;
}
 2d0:	5b                   	pop    %ebx
 2d1:	5e                   	pop    %esi
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    

000002d4 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d4:	b8 01 00 00 00       	mov    $0x1,%eax
 2d9:	cd 40                	int    $0x40
 2db:	c3                   	ret    

000002dc <exit>:
SYSCALL(exit)
 2dc:	b8 02 00 00 00       	mov    $0x2,%eax
 2e1:	cd 40                	int    $0x40
 2e3:	c3                   	ret    

000002e4 <wait>:
SYSCALL(wait)
 2e4:	b8 03 00 00 00       	mov    $0x3,%eax
 2e9:	cd 40                	int    $0x40
 2eb:	c3                   	ret    

000002ec <pipe>:
SYSCALL(pipe)
 2ec:	b8 04 00 00 00       	mov    $0x4,%eax
 2f1:	cd 40                	int    $0x40
 2f3:	c3                   	ret    

000002f4 <read>:
SYSCALL(read)
 2f4:	b8 05 00 00 00       	mov    $0x5,%eax
 2f9:	cd 40                	int    $0x40
 2fb:	c3                   	ret    

000002fc <write>:
SYSCALL(write)
 2fc:	b8 10 00 00 00       	mov    $0x10,%eax
 301:	cd 40                	int    $0x40
 303:	c3                   	ret    

00000304 <close>:
SYSCALL(close)
 304:	b8 15 00 00 00       	mov    $0x15,%eax
 309:	cd 40                	int    $0x40
 30b:	c3                   	ret    

0000030c <kill>:
SYSCALL(kill)
 30c:	b8 06 00 00 00       	mov    $0x6,%eax
 311:	cd 40                	int    $0x40
 313:	c3                   	ret    

00000314 <exec>:
SYSCALL(exec)
 314:	b8 07 00 00 00       	mov    $0x7,%eax
 319:	cd 40                	int    $0x40
 31b:	c3                   	ret    

0000031c <open>:
SYSCALL(open)
 31c:	b8 0f 00 00 00       	mov    $0xf,%eax
 321:	cd 40                	int    $0x40
 323:	c3                   	ret    

00000324 <mknod>:
SYSCALL(mknod)
 324:	b8 11 00 00 00       	mov    $0x11,%eax
 329:	cd 40                	int    $0x40
 32b:	c3                   	ret    

0000032c <unlink>:
SYSCALL(unlink)
 32c:	b8 12 00 00 00       	mov    $0x12,%eax
 331:	cd 40                	int    $0x40
 333:	c3                   	ret    

00000334 <fstat>:
SYSCALL(fstat)
 334:	b8 08 00 00 00       	mov    $0x8,%eax
 339:	cd 40                	int    $0x40
 33b:	c3                   	ret    

0000033c <link>:
SYSCALL(link)
 33c:	b8 13 00 00 00       	mov    $0x13,%eax
 341:	cd 40                	int    $0x40
 343:	c3                   	ret    

00000344 <mkdir>:
SYSCALL(mkdir)
 344:	b8 14 00 00 00       	mov    $0x14,%eax
 349:	cd 40                	int    $0x40
 34b:	c3                   	ret    

0000034c <chdir>:
SYSCALL(chdir)
 34c:	b8 09 00 00 00       	mov    $0x9,%eax
 351:	cd 40                	int    $0x40
 353:	c3                   	ret    

00000354 <dup>:
SYSCALL(dup)
 354:	b8 0a 00 00 00       	mov    $0xa,%eax
 359:	cd 40                	int    $0x40
 35b:	c3                   	ret    

0000035c <getpid>:
SYSCALL(getpid)
 35c:	b8 0b 00 00 00       	mov    $0xb,%eax
 361:	cd 40                	int    $0x40
 363:	c3                   	ret    

00000364 <sbrk>:
SYSCALL(sbrk)
 364:	b8 0c 00 00 00       	mov    $0xc,%eax
 369:	cd 40                	int    $0x40
 36b:	c3                   	ret    

0000036c <sleep>:
SYSCALL(sleep)
 36c:	b8 0d 00 00 00       	mov    $0xd,%eax
 371:	cd 40                	int    $0x40
 373:	c3                   	ret    

00000374 <uptime>:
SYSCALL(uptime)
 374:	b8 0e 00 00 00       	mov    $0xe,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 37c:	b8 16 00 00 00       	mov    $0x16,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <block>:
SYSCALL(block)
 384:	b8 17 00 00 00       	mov    $0x17,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <unblock>:
SYSCALL(unblock)
 38c:	b8 18 00 00 00       	mov    $0x18,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <chmod>:
SYSCALL(chmod)
 394:	b8 19 00 00 00       	mov    $0x19,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 39c:	55                   	push   %ebp
 39d:	89 e5                	mov    %esp,%ebp
 39f:	83 ec 1c             	sub    $0x1c,%esp
 3a2:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3a5:	6a 01                	push   $0x1
 3a7:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3aa:	52                   	push   %edx
 3ab:	50                   	push   %eax
 3ac:	e8 4b ff ff ff       	call   2fc <write>
}
 3b1:	83 c4 10             	add    $0x10,%esp
 3b4:	c9                   	leave  
 3b5:	c3                   	ret    

000003b6 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3b6:	55                   	push   %ebp
 3b7:	89 e5                	mov    %esp,%ebp
 3b9:	57                   	push   %edi
 3ba:	56                   	push   %esi
 3bb:	53                   	push   %ebx
 3bc:	83 ec 2c             	sub    $0x2c,%esp
 3bf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 3c2:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3c4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3c8:	74 04                	je     3ce <printint+0x18>
 3ca:	85 d2                	test   %edx,%edx
 3cc:	78 3c                	js     40a <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 3ce:	89 d1                	mov    %edx,%ecx
  neg = 0;
 3d0:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 3d7:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3dc:	89 c8                	mov    %ecx,%eax
 3de:	ba 00 00 00 00       	mov    $0x0,%edx
 3e3:	f7 f6                	div    %esi
 3e5:	89 df                	mov    %ebx,%edi
 3e7:	43                   	inc    %ebx
 3e8:	8a 92 6c 07 00 00    	mov    0x76c(%edx),%dl
 3ee:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3f2:	89 ca                	mov    %ecx,%edx
 3f4:	89 c1                	mov    %eax,%ecx
 3f6:	39 f2                	cmp    %esi,%edx
 3f8:	73 e2                	jae    3dc <printint+0x26>
  if(neg)
 3fa:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3fe:	74 24                	je     424 <printint+0x6e>
    buf[i++] = '-';
 400:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 405:	8d 5f 02             	lea    0x2(%edi),%ebx
 408:	eb 1a                	jmp    424 <printint+0x6e>
    x = -xx;
 40a:	89 d1                	mov    %edx,%ecx
 40c:	f7 d9                	neg    %ecx
    neg = 1;
 40e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 415:	eb c0                	jmp    3d7 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 417:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 41c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 41f:	e8 78 ff ff ff       	call   39c <putc>
  while(--i >= 0)
 424:	4b                   	dec    %ebx
 425:	79 f0                	jns    417 <printint+0x61>
}
 427:	83 c4 2c             	add    $0x2c,%esp
 42a:	5b                   	pop    %ebx
 42b:	5e                   	pop    %esi
 42c:	5f                   	pop    %edi
 42d:	5d                   	pop    %ebp
 42e:	c3                   	ret    

0000042f <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 42f:	55                   	push   %ebp
 430:	89 e5                	mov    %esp,%ebp
 432:	57                   	push   %edi
 433:	56                   	push   %esi
 434:	53                   	push   %ebx
 435:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 438:	8d 45 10             	lea    0x10(%ebp),%eax
 43b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 43e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 443:	bb 00 00 00 00       	mov    $0x0,%ebx
 448:	eb 12                	jmp    45c <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 44a:	89 fa                	mov    %edi,%edx
 44c:	8b 45 08             	mov    0x8(%ebp),%eax
 44f:	e8 48 ff ff ff       	call   39c <putc>
 454:	eb 05                	jmp    45b <printf+0x2c>
      }
    } else if(state == '%'){
 456:	83 fe 25             	cmp    $0x25,%esi
 459:	74 22                	je     47d <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 45b:	43                   	inc    %ebx
 45c:	8b 45 0c             	mov    0xc(%ebp),%eax
 45f:	8a 04 18             	mov    (%eax,%ebx,1),%al
 462:	84 c0                	test   %al,%al
 464:	0f 84 1d 01 00 00    	je     587 <printf+0x158>
    c = fmt[i] & 0xff;
 46a:	0f be f8             	movsbl %al,%edi
 46d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 470:	85 f6                	test   %esi,%esi
 472:	75 e2                	jne    456 <printf+0x27>
      if(c == '%'){
 474:	83 f8 25             	cmp    $0x25,%eax
 477:	75 d1                	jne    44a <printf+0x1b>
        state = '%';
 479:	89 c6                	mov    %eax,%esi
 47b:	eb de                	jmp    45b <printf+0x2c>
      if(c == 'd'){
 47d:	83 f8 25             	cmp    $0x25,%eax
 480:	0f 84 cc 00 00 00    	je     552 <printf+0x123>
 486:	0f 8c da 00 00 00    	jl     566 <printf+0x137>
 48c:	83 f8 78             	cmp    $0x78,%eax
 48f:	0f 8f d1 00 00 00    	jg     566 <printf+0x137>
 495:	83 f8 63             	cmp    $0x63,%eax
 498:	0f 8c c8 00 00 00    	jl     566 <printf+0x137>
 49e:	83 e8 63             	sub    $0x63,%eax
 4a1:	83 f8 15             	cmp    $0x15,%eax
 4a4:	0f 87 bc 00 00 00    	ja     566 <printf+0x137>
 4aa:	ff 24 85 14 07 00 00 	jmp    *0x714(,%eax,4)
        printint(fd, *ap, 10, 1);
 4b1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b4:	8b 17                	mov    (%edi),%edx
 4b6:	83 ec 0c             	sub    $0xc,%esp
 4b9:	6a 01                	push   $0x1
 4bb:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4c0:	8b 45 08             	mov    0x8(%ebp),%eax
 4c3:	e8 ee fe ff ff       	call   3b6 <printint>
        ap++;
 4c8:	83 c7 04             	add    $0x4,%edi
 4cb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ce:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 4d1:	be 00 00 00 00       	mov    $0x0,%esi
 4d6:	eb 83                	jmp    45b <printf+0x2c>
        printint(fd, *ap, 16, 0);
 4d8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4db:	8b 17                	mov    (%edi),%edx
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	6a 00                	push   $0x0
 4e2:	b9 10 00 00 00       	mov    $0x10,%ecx
 4e7:	8b 45 08             	mov    0x8(%ebp),%eax
 4ea:	e8 c7 fe ff ff       	call   3b6 <printint>
        ap++;
 4ef:	83 c7 04             	add    $0x4,%edi
 4f2:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4f5:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4f8:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4fd:	e9 59 ff ff ff       	jmp    45b <printf+0x2c>
        s = (char*)*ap;
 502:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 505:	8b 30                	mov    (%eax),%esi
        ap++;
 507:	83 c0 04             	add    $0x4,%eax
 50a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 50d:	85 f6                	test   %esi,%esi
 50f:	75 13                	jne    524 <printf+0xf5>
          s = "(null)";
 511:	be 0b 07 00 00       	mov    $0x70b,%esi
 516:	eb 0c                	jmp    524 <printf+0xf5>
          putc(fd, *s);
 518:	0f be d2             	movsbl %dl,%edx
 51b:	8b 45 08             	mov    0x8(%ebp),%eax
 51e:	e8 79 fe ff ff       	call   39c <putc>
          s++;
 523:	46                   	inc    %esi
        while(*s != 0){
 524:	8a 16                	mov    (%esi),%dl
 526:	84 d2                	test   %dl,%dl
 528:	75 ee                	jne    518 <printf+0xe9>
      state = 0;
 52a:	be 00 00 00 00       	mov    $0x0,%esi
 52f:	e9 27 ff ff ff       	jmp    45b <printf+0x2c>
        putc(fd, *ap);
 534:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 537:	0f be 17             	movsbl (%edi),%edx
 53a:	8b 45 08             	mov    0x8(%ebp),%eax
 53d:	e8 5a fe ff ff       	call   39c <putc>
        ap++;
 542:	83 c7 04             	add    $0x4,%edi
 545:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 548:	be 00 00 00 00       	mov    $0x0,%esi
 54d:	e9 09 ff ff ff       	jmp    45b <printf+0x2c>
        putc(fd, c);
 552:	89 fa                	mov    %edi,%edx
 554:	8b 45 08             	mov    0x8(%ebp),%eax
 557:	e8 40 fe ff ff       	call   39c <putc>
      state = 0;
 55c:	be 00 00 00 00       	mov    $0x0,%esi
 561:	e9 f5 fe ff ff       	jmp    45b <printf+0x2c>
        putc(fd, '%');
 566:	ba 25 00 00 00       	mov    $0x25,%edx
 56b:	8b 45 08             	mov    0x8(%ebp),%eax
 56e:	e8 29 fe ff ff       	call   39c <putc>
        putc(fd, c);
 573:	89 fa                	mov    %edi,%edx
 575:	8b 45 08             	mov    0x8(%ebp),%eax
 578:	e8 1f fe ff ff       	call   39c <putc>
      state = 0;
 57d:	be 00 00 00 00       	mov    $0x0,%esi
 582:	e9 d4 fe ff ff       	jmp    45b <printf+0x2c>
    }
  }
}
 587:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58a:	5b                   	pop    %ebx
 58b:	5e                   	pop    %esi
 58c:	5f                   	pop    %edi
 58d:	5d                   	pop    %ebp
 58e:	c3                   	ret    

0000058f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 58f:	55                   	push   %ebp
 590:	89 e5                	mov    %esp,%ebp
 592:	57                   	push   %edi
 593:	56                   	push   %esi
 594:	53                   	push   %ebx
 595:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 598:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 59b:	a1 80 09 00 00       	mov    0x980,%eax
 5a0:	eb 02                	jmp    5a4 <free+0x15>
 5a2:	89 d0                	mov    %edx,%eax
 5a4:	39 c8                	cmp    %ecx,%eax
 5a6:	73 04                	jae    5ac <free+0x1d>
 5a8:	3b 08                	cmp    (%eax),%ecx
 5aa:	72 12                	jb     5be <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5ac:	8b 10                	mov    (%eax),%edx
 5ae:	39 d0                	cmp    %edx,%eax
 5b0:	72 f0                	jb     5a2 <free+0x13>
 5b2:	39 c8                	cmp    %ecx,%eax
 5b4:	72 08                	jb     5be <free+0x2f>
 5b6:	39 d1                	cmp    %edx,%ecx
 5b8:	72 04                	jb     5be <free+0x2f>
 5ba:	89 d0                	mov    %edx,%eax
 5bc:	eb e6                	jmp    5a4 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5be:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c1:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5c4:	8b 10                	mov    (%eax),%edx
 5c6:	39 d7                	cmp    %edx,%edi
 5c8:	74 19                	je     5e3 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5ca:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5cd:	8b 50 04             	mov    0x4(%eax),%edx
 5d0:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5d3:	39 ce                	cmp    %ecx,%esi
 5d5:	74 1b                	je     5f2 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5d7:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5d9:	a3 80 09 00 00       	mov    %eax,0x980
}
 5de:	5b                   	pop    %ebx
 5df:	5e                   	pop    %esi
 5e0:	5f                   	pop    %edi
 5e1:	5d                   	pop    %ebp
 5e2:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5e3:	03 72 04             	add    0x4(%edx),%esi
 5e6:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5e9:	8b 10                	mov    (%eax),%edx
 5eb:	8b 12                	mov    (%edx),%edx
 5ed:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5f0:	eb db                	jmp    5cd <free+0x3e>
    p->s.size += bp->s.size;
 5f2:	03 53 fc             	add    -0x4(%ebx),%edx
 5f5:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5f8:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5fb:	89 10                	mov    %edx,(%eax)
 5fd:	eb da                	jmp    5d9 <free+0x4a>

000005ff <morecore>:

static Header*
morecore(uint nu)
{
 5ff:	55                   	push   %ebp
 600:	89 e5                	mov    %esp,%ebp
 602:	53                   	push   %ebx
 603:	83 ec 04             	sub    $0x4,%esp
 606:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 608:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 60d:	77 05                	ja     614 <morecore+0x15>
    nu = 4096;
 60f:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 614:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 61b:	83 ec 0c             	sub    $0xc,%esp
 61e:	50                   	push   %eax
 61f:	e8 40 fd ff ff       	call   364 <sbrk>
  if(p == (char*)-1)
 624:	83 c4 10             	add    $0x10,%esp
 627:	83 f8 ff             	cmp    $0xffffffff,%eax
 62a:	74 1c                	je     648 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 62c:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 62f:	83 c0 08             	add    $0x8,%eax
 632:	83 ec 0c             	sub    $0xc,%esp
 635:	50                   	push   %eax
 636:	e8 54 ff ff ff       	call   58f <free>
  return freep;
 63b:	a1 80 09 00 00       	mov    0x980,%eax
 640:	83 c4 10             	add    $0x10,%esp
}
 643:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 646:	c9                   	leave  
 647:	c3                   	ret    
    return 0;
 648:	b8 00 00 00 00       	mov    $0x0,%eax
 64d:	eb f4                	jmp    643 <morecore+0x44>

0000064f <malloc>:

void*
malloc(uint nbytes)
{
 64f:	55                   	push   %ebp
 650:	89 e5                	mov    %esp,%ebp
 652:	53                   	push   %ebx
 653:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 656:	8b 45 08             	mov    0x8(%ebp),%eax
 659:	8d 58 07             	lea    0x7(%eax),%ebx
 65c:	c1 eb 03             	shr    $0x3,%ebx
 65f:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 660:	8b 0d 80 09 00 00    	mov    0x980,%ecx
 666:	85 c9                	test   %ecx,%ecx
 668:	74 04                	je     66e <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 66a:	8b 01                	mov    (%ecx),%eax
 66c:	eb 4a                	jmp    6b8 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 66e:	c7 05 80 09 00 00 84 	movl   $0x984,0x980
 675:	09 00 00 
 678:	c7 05 84 09 00 00 84 	movl   $0x984,0x984
 67f:	09 00 00 
    base.s.size = 0;
 682:	c7 05 88 09 00 00 00 	movl   $0x0,0x988
 689:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 68c:	b9 84 09 00 00       	mov    $0x984,%ecx
 691:	eb d7                	jmp    66a <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 693:	74 19                	je     6ae <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 695:	29 da                	sub    %ebx,%edx
 697:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 69a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 69d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6a0:	89 0d 80 09 00 00    	mov    %ecx,0x980
      return (void*)(p + 1);
 6a6:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6a9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6ac:	c9                   	leave  
 6ad:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6ae:	8b 10                	mov    (%eax),%edx
 6b0:	89 11                	mov    %edx,(%ecx)
 6b2:	eb ec                	jmp    6a0 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6b4:	89 c1                	mov    %eax,%ecx
 6b6:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6b8:	8b 50 04             	mov    0x4(%eax),%edx
 6bb:	39 da                	cmp    %ebx,%edx
 6bd:	73 d4                	jae    693 <malloc+0x44>
    if(p == freep)
 6bf:	39 05 80 09 00 00    	cmp    %eax,0x980
 6c5:	75 ed                	jne    6b4 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 6c7:	89 d8                	mov    %ebx,%eax
 6c9:	e8 31 ff ff ff       	call   5ff <morecore>
 6ce:	85 c0                	test   %eax,%eax
 6d0:	75 e2                	jne    6b4 <malloc+0x65>
 6d2:	eb d5                	jmp    6a9 <malloc+0x5a>
