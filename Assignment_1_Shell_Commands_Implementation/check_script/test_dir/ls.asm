
_ls:     file format elf32-i386


Disassembly of section .text:

00000000 <fmtname>:
#include "user.h"
#include "fs.h"

char*
fmtname(char *path)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	56                   	push   %esi
   4:	53                   	push   %ebx
   5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  static char buf[DIRSIZ+1];
  char *p;

  // Find first character after last slash.
  for(p=path+strlen(path); p >= path && *p != '/'; p--)
   8:	83 ec 0c             	sub    $0xc,%esp
   b:	53                   	push   %ebx
   c:	e8 0d 03 00 00       	call   31e <strlen>
  11:	01 d8                	add    %ebx,%eax
  13:	83 c4 10             	add    $0x10,%esp
  16:	eb 01                	jmp    19 <fmtname+0x19>
  18:	48                   	dec    %eax
  19:	39 d8                	cmp    %ebx,%eax
  1b:	72 05                	jb     22 <fmtname+0x22>
  1d:	80 38 2f             	cmpb   $0x2f,(%eax)
  20:	75 f6                	jne    18 <fmtname+0x18>
    ;
  p++;
  22:	8d 58 01             	lea    0x1(%eax),%ebx

  // Return blank-padded name.
  if(strlen(p) >= DIRSIZ)
  25:	83 ec 0c             	sub    $0xc,%esp
  28:	53                   	push   %ebx
  29:	e8 f0 02 00 00       	call   31e <strlen>
  2e:	83 c4 10             	add    $0x10,%esp
  31:	83 f8 0d             	cmp    $0xd,%eax
  34:	76 09                	jbe    3f <fmtname+0x3f>
    return p;
  memmove(buf, p, strlen(p));
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  return buf;
}
  36:	89 d8                	mov    %ebx,%eax
  38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  3b:	5b                   	pop    %ebx
  3c:	5e                   	pop    %esi
  3d:	5d                   	pop    %ebp
  3e:	c3                   	ret    
  memmove(buf, p, strlen(p));
  3f:	83 ec 0c             	sub    $0xc,%esp
  42:	53                   	push   %ebx
  43:	e8 d6 02 00 00       	call   31e <strlen>
  48:	83 c4 0c             	add    $0xc,%esp
  4b:	50                   	push   %eax
  4c:	53                   	push   %ebx
  4d:	68 18 09 00 00       	push   $0x918
  52:	e8 d7 03 00 00       	call   42e <memmove>
  memset(buf+strlen(p), ' ', DIRSIZ-strlen(p));
  57:	89 1c 24             	mov    %ebx,(%esp)
  5a:	e8 bf 02 00 00       	call   31e <strlen>
  5f:	89 c6                	mov    %eax,%esi
  61:	89 1c 24             	mov    %ebx,(%esp)
  64:	e8 b5 02 00 00       	call   31e <strlen>
  69:	83 c4 0c             	add    $0xc,%esp
  6c:	ba 0e 00 00 00       	mov    $0xe,%edx
  71:	29 f2                	sub    %esi,%edx
  73:	52                   	push   %edx
  74:	6a 20                	push   $0x20
  76:	05 18 09 00 00       	add    $0x918,%eax
  7b:	50                   	push   %eax
  7c:	e8 b3 02 00 00       	call   334 <memset>
  return buf;
  81:	83 c4 10             	add    $0x10,%esp
  84:	bb 18 09 00 00       	mov    $0x918,%ebx
  89:	eb ab                	jmp    36 <fmtname+0x36>

0000008b <ls>:

void
ls(char *path)
{
  8b:	55                   	push   %ebp
  8c:	89 e5                	mov    %esp,%ebp
  8e:	57                   	push   %edi
  8f:	56                   	push   %esi
  90:	53                   	push   %ebx
  91:	81 ec 54 02 00 00    	sub    $0x254,%esp
  97:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(path, 0)) < 0){
  9a:	6a 00                	push   $0x0
  9c:	53                   	push   %ebx
  9d:	e8 fd 03 00 00       	call   49f <open>
  a2:	83 c4 10             	add    $0x10,%esp
  a5:	85 c0                	test   %eax,%eax
  a7:	0f 88 8b 00 00 00    	js     138 <ls+0xad>
  ad:	89 c7                	mov    %eax,%edi
    printf(2, "ls: cannot open %s\n", path);
    return;
  }

  if(fstat(fd, &st) < 0){
  af:	83 ec 08             	sub    $0x8,%esp
  b2:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
  b8:	50                   	push   %eax
  b9:	57                   	push   %edi
  ba:	e8 f8 03 00 00       	call   4b7 <fstat>
  bf:	83 c4 10             	add    $0x10,%esp
  c2:	85 c0                	test   %eax,%eax
  c4:	0f 88 83 00 00 00    	js     14d <ls+0xc2>
    printf(2, "ls: cannot stat %s\n", path);
    close(fd);
    return;
  }

  switch(st.type){
  ca:	8b 85 c4 fd ff ff    	mov    -0x23c(%ebp),%eax
  d0:	0f bf f0             	movswl %ax,%esi
  d3:	66 83 f8 01          	cmp    $0x1,%ax
  d7:	0f 84 8d 00 00 00    	je     16a <ls+0xdf>
  dd:	66 83 f8 02          	cmp    $0x2,%ax
  e1:	75 41                	jne    124 <ls+0x99>
  case T_FILE:
    printf(1, "%s %d %d %d\n", fmtname(path), st.type, st.ino, st.size);
  e3:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
  e9:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
  ef:	8b 8d cc fd ff ff    	mov    -0x234(%ebp),%ecx
  f5:	89 8d b0 fd ff ff    	mov    %ecx,-0x250(%ebp)
  fb:	83 ec 0c             	sub    $0xc,%esp
  fe:	53                   	push   %ebx
  ff:	e8 fc fe ff ff       	call   0 <fmtname>
 104:	83 c4 08             	add    $0x8,%esp
 107:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 10d:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 113:	56                   	push   %esi
 114:	50                   	push   %eax
 115:	68 80 08 00 00       	push   $0x880
 11a:	6a 01                	push   $0x1
 11c:	e8 91 04 00 00       	call   5b2 <printf>
    break;
 121:	83 c4 20             	add    $0x20,%esp
      }
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
    }
    break;
  }
  close(fd);
 124:	83 ec 0c             	sub    $0xc,%esp
 127:	57                   	push   %edi
 128:	e8 5a 03 00 00       	call   487 <close>
 12d:	83 c4 10             	add    $0x10,%esp
}
 130:	8d 65 f4             	lea    -0xc(%ebp),%esp
 133:	5b                   	pop    %ebx
 134:	5e                   	pop    %esi
 135:	5f                   	pop    %edi
 136:	5d                   	pop    %ebp
 137:	c3                   	ret    
    printf(2, "ls: cannot open %s\n", path);
 138:	83 ec 04             	sub    $0x4,%esp
 13b:	53                   	push   %ebx
 13c:	68 58 08 00 00       	push   $0x858
 141:	6a 02                	push   $0x2
 143:	e8 6a 04 00 00       	call   5b2 <printf>
    return;
 148:	83 c4 10             	add    $0x10,%esp
 14b:	eb e3                	jmp    130 <ls+0xa5>
    printf(2, "ls: cannot stat %s\n", path);
 14d:	83 ec 04             	sub    $0x4,%esp
 150:	53                   	push   %ebx
 151:	68 6c 08 00 00       	push   $0x86c
 156:	6a 02                	push   $0x2
 158:	e8 55 04 00 00       	call   5b2 <printf>
    close(fd);
 15d:	89 3c 24             	mov    %edi,(%esp)
 160:	e8 22 03 00 00       	call   487 <close>
    return;
 165:	83 c4 10             	add    $0x10,%esp
 168:	eb c6                	jmp    130 <ls+0xa5>
    if(strlen(path) + 1 + DIRSIZ + 1 > sizeof buf){
 16a:	83 ec 0c             	sub    $0xc,%esp
 16d:	53                   	push   %ebx
 16e:	e8 ab 01 00 00       	call   31e <strlen>
 173:	83 c0 10             	add    $0x10,%eax
 176:	83 c4 10             	add    $0x10,%esp
 179:	3d 00 02 00 00       	cmp    $0x200,%eax
 17e:	76 14                	jbe    194 <ls+0x109>
      printf(1, "ls: path too long\n");
 180:	83 ec 08             	sub    $0x8,%esp
 183:	68 8d 08 00 00       	push   $0x88d
 188:	6a 01                	push   $0x1
 18a:	e8 23 04 00 00       	call   5b2 <printf>
      break;
 18f:	83 c4 10             	add    $0x10,%esp
 192:	eb 90                	jmp    124 <ls+0x99>
    strcpy(buf, path);
 194:	83 ec 08             	sub    $0x8,%esp
 197:	53                   	push   %ebx
 198:	8d 9d e8 fd ff ff    	lea    -0x218(%ebp),%ebx
 19e:	53                   	push   %ebx
 19f:	e8 3a 01 00 00       	call   2de <strcpy>
    p = buf+strlen(buf);
 1a4:	89 1c 24             	mov    %ebx,(%esp)
 1a7:	e8 72 01 00 00       	call   31e <strlen>
 1ac:	8d 34 03             	lea    (%ebx,%eax,1),%esi
    *p++ = '/';
 1af:	8d 44 03 01          	lea    0x1(%ebx,%eax,1),%eax
 1b3:	89 85 ac fd ff ff    	mov    %eax,-0x254(%ebp)
 1b9:	c6 06 2f             	movb   $0x2f,(%esi)
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1bc:	83 c4 10             	add    $0x10,%esp
 1bf:	eb 19                	jmp    1da <ls+0x14f>
        printf(1, "ls: cannot stat %s\n", buf);
 1c1:	83 ec 04             	sub    $0x4,%esp
 1c4:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 1ca:	50                   	push   %eax
 1cb:	68 6c 08 00 00       	push   $0x86c
 1d0:	6a 01                	push   $0x1
 1d2:	e8 db 03 00 00       	call   5b2 <printf>
        continue;
 1d7:	83 c4 10             	add    $0x10,%esp
    while(read(fd, &de, sizeof(de)) == sizeof(de)){
 1da:	83 ec 04             	sub    $0x4,%esp
 1dd:	6a 10                	push   $0x10
 1df:	8d 85 d8 fd ff ff    	lea    -0x228(%ebp),%eax
 1e5:	50                   	push   %eax
 1e6:	57                   	push   %edi
 1e7:	e8 8b 02 00 00       	call   477 <read>
 1ec:	83 c4 10             	add    $0x10,%esp
 1ef:	83 f8 10             	cmp    $0x10,%eax
 1f2:	0f 85 2c ff ff ff    	jne    124 <ls+0x99>
      if(de.inum == 0)
 1f8:	66 83 bd d8 fd ff ff 	cmpw   $0x0,-0x228(%ebp)
 1ff:	00 
 200:	74 d8                	je     1da <ls+0x14f>
      memmove(p, de.name, DIRSIZ);
 202:	83 ec 04             	sub    $0x4,%esp
 205:	6a 0e                	push   $0xe
 207:	8d 85 da fd ff ff    	lea    -0x226(%ebp),%eax
 20d:	50                   	push   %eax
 20e:	ff b5 ac fd ff ff    	pushl  -0x254(%ebp)
 214:	e8 15 02 00 00       	call   42e <memmove>
      p[DIRSIZ] = 0;
 219:	c6 46 0f 00          	movb   $0x0,0xf(%esi)
      if(stat(buf, &st) < 0){
 21d:	83 c4 08             	add    $0x8,%esp
 220:	8d 85 c4 fd ff ff    	lea    -0x23c(%ebp),%eax
 226:	50                   	push   %eax
 227:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 22d:	50                   	push   %eax
 22e:	e8 8a 01 00 00       	call   3bd <stat>
 233:	83 c4 10             	add    $0x10,%esp
 236:	85 c0                	test   %eax,%eax
 238:	78 87                	js     1c1 <ls+0x136>
      printf(1, "%s %d %d %d\n", fmtname(buf), st.type, st.ino, st.size);
 23a:	8b 85 d4 fd ff ff    	mov    -0x22c(%ebp),%eax
 240:	89 85 b4 fd ff ff    	mov    %eax,-0x24c(%ebp)
 246:	8b 95 cc fd ff ff    	mov    -0x234(%ebp),%edx
 24c:	89 95 b0 fd ff ff    	mov    %edx,-0x250(%ebp)
 252:	8b 9d c4 fd ff ff    	mov    -0x23c(%ebp),%ebx
 258:	83 ec 0c             	sub    $0xc,%esp
 25b:	8d 85 e8 fd ff ff    	lea    -0x218(%ebp),%eax
 261:	50                   	push   %eax
 262:	e8 99 fd ff ff       	call   0 <fmtname>
 267:	83 c4 08             	add    $0x8,%esp
 26a:	ff b5 b4 fd ff ff    	pushl  -0x24c(%ebp)
 270:	ff b5 b0 fd ff ff    	pushl  -0x250(%ebp)
 276:	0f bf db             	movswl %bx,%ebx
 279:	53                   	push   %ebx
 27a:	50                   	push   %eax
 27b:	68 80 08 00 00       	push   $0x880
 280:	6a 01                	push   $0x1
 282:	e8 2b 03 00 00       	call   5b2 <printf>
 287:	83 c4 20             	add    $0x20,%esp
 28a:	e9 4b ff ff ff       	jmp    1da <ls+0x14f>

0000028f <main>:

int
main(int argc, char *argv[])
{
 28f:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 293:	83 e4 f0             	and    $0xfffffff0,%esp
 296:	ff 71 fc             	pushl  -0x4(%ecx)
 299:	55                   	push   %ebp
 29a:	89 e5                	mov    %esp,%ebp
 29c:	57                   	push   %edi
 29d:	56                   	push   %esi
 29e:	53                   	push   %ebx
 29f:	51                   	push   %ecx
 2a0:	83 ec 08             	sub    $0x8,%esp
 2a3:	8b 31                	mov    (%ecx),%esi
 2a5:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
 2a8:	83 fe 01             	cmp    $0x1,%esi
 2ab:	7e 07                	jle    2b4 <main+0x25>
    ls(".");
    exit();
  }
  for(i=1; i<argc; i++)
 2ad:	bb 01 00 00 00       	mov    $0x1,%ebx
 2b2:	eb 21                	jmp    2d5 <main+0x46>
    ls(".");
 2b4:	83 ec 0c             	sub    $0xc,%esp
 2b7:	68 a0 08 00 00       	push   $0x8a0
 2bc:	e8 ca fd ff ff       	call   8b <ls>
    exit();
 2c1:	e8 99 01 00 00       	call   45f <exit>
    ls(argv[i]);
 2c6:	83 ec 0c             	sub    $0xc,%esp
 2c9:	ff 34 9f             	pushl  (%edi,%ebx,4)
 2cc:	e8 ba fd ff ff       	call   8b <ls>
  for(i=1; i<argc; i++)
 2d1:	43                   	inc    %ebx
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	39 f3                	cmp    %esi,%ebx
 2d7:	7c ed                	jl     2c6 <main+0x37>
  exit();
 2d9:	e8 81 01 00 00       	call   45f <exit>

000002de <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	56                   	push   %esi
 2e2:	53                   	push   %ebx
 2e3:	8b 45 08             	mov    0x8(%ebp),%eax
 2e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2e9:	89 c2                	mov    %eax,%edx
 2eb:	89 cb                	mov    %ecx,%ebx
 2ed:	41                   	inc    %ecx
 2ee:	89 d6                	mov    %edx,%esi
 2f0:	42                   	inc    %edx
 2f1:	8a 1b                	mov    (%ebx),%bl
 2f3:	88 1e                	mov    %bl,(%esi)
 2f5:	84 db                	test   %bl,%bl
 2f7:	75 f2                	jne    2eb <strcpy+0xd>
    ;
  return os;
}
 2f9:	5b                   	pop    %ebx
 2fa:	5e                   	pop    %esi
 2fb:	5d                   	pop    %ebp
 2fc:	c3                   	ret    

000002fd <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2fd:	55                   	push   %ebp
 2fe:	89 e5                	mov    %esp,%ebp
 300:	8b 4d 08             	mov    0x8(%ebp),%ecx
 303:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 306:	eb 02                	jmp    30a <strcmp+0xd>
    p++, q++;
 308:	41                   	inc    %ecx
 309:	42                   	inc    %edx
  while(*p && *p == *q)
 30a:	8a 01                	mov    (%ecx),%al
 30c:	84 c0                	test   %al,%al
 30e:	74 04                	je     314 <strcmp+0x17>
 310:	3a 02                	cmp    (%edx),%al
 312:	74 f4                	je     308 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 314:	0f b6 c0             	movzbl %al,%eax
 317:	0f b6 12             	movzbl (%edx),%edx
 31a:	29 d0                	sub    %edx,%eax
}
 31c:	5d                   	pop    %ebp
 31d:	c3                   	ret    

0000031e <strlen>:

uint
strlen(const char *s)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 324:	b8 00 00 00 00       	mov    $0x0,%eax
 329:	eb 01                	jmp    32c <strlen+0xe>
 32b:	40                   	inc    %eax
 32c:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 330:	75 f9                	jne    32b <strlen+0xd>
    ;
  return n;
}
 332:	5d                   	pop    %ebp
 333:	c3                   	ret    

00000334 <memset>:

void*
memset(void *dst, int c, uint n)
{
 334:	55                   	push   %ebp
 335:	89 e5                	mov    %esp,%ebp
 337:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 338:	8b 7d 08             	mov    0x8(%ebp),%edi
 33b:	8b 4d 10             	mov    0x10(%ebp),%ecx
 33e:	8b 45 0c             	mov    0xc(%ebp),%eax
 341:	fc                   	cld    
 342:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 344:	8b 45 08             	mov    0x8(%ebp),%eax
 347:	8b 7d fc             	mov    -0x4(%ebp),%edi
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <strchr>:

char*
strchr(const char *s, char c)
{
 34c:	55                   	push   %ebp
 34d:	89 e5                	mov    %esp,%ebp
 34f:	8b 45 08             	mov    0x8(%ebp),%eax
 352:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 355:	eb 01                	jmp    358 <strchr+0xc>
 357:	40                   	inc    %eax
 358:	8a 10                	mov    (%eax),%dl
 35a:	84 d2                	test   %dl,%dl
 35c:	74 06                	je     364 <strchr+0x18>
    if(*s == c)
 35e:	38 ca                	cmp    %cl,%dl
 360:	75 f5                	jne    357 <strchr+0xb>
 362:	eb 05                	jmp    369 <strchr+0x1d>
      return (char*)s;
  return 0;
 364:	b8 00 00 00 00       	mov    $0x0,%eax
}
 369:	5d                   	pop    %ebp
 36a:	c3                   	ret    

0000036b <gets>:

char*
gets(char *buf, int max)
{
 36b:	55                   	push   %ebp
 36c:	89 e5                	mov    %esp,%ebp
 36e:	57                   	push   %edi
 36f:	56                   	push   %esi
 370:	53                   	push   %ebx
 371:	83 ec 1c             	sub    $0x1c,%esp
 374:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 377:	bb 00 00 00 00       	mov    $0x0,%ebx
 37c:	89 de                	mov    %ebx,%esi
 37e:	43                   	inc    %ebx
 37f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 382:	7d 2b                	jge    3af <gets+0x44>
    cc = read(0, &c, 1);
 384:	83 ec 04             	sub    $0x4,%esp
 387:	6a 01                	push   $0x1
 389:	8d 45 e7             	lea    -0x19(%ebp),%eax
 38c:	50                   	push   %eax
 38d:	6a 00                	push   $0x0
 38f:	e8 e3 00 00 00       	call   477 <read>
    if(cc < 1)
 394:	83 c4 10             	add    $0x10,%esp
 397:	85 c0                	test   %eax,%eax
 399:	7e 14                	jle    3af <gets+0x44>
      break;
    buf[i++] = c;
 39b:	8a 45 e7             	mov    -0x19(%ebp),%al
 39e:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 3a1:	3c 0a                	cmp    $0xa,%al
 3a3:	74 08                	je     3ad <gets+0x42>
 3a5:	3c 0d                	cmp    $0xd,%al
 3a7:	75 d3                	jne    37c <gets+0x11>
    buf[i++] = c;
 3a9:	89 de                	mov    %ebx,%esi
 3ab:	eb 02                	jmp    3af <gets+0x44>
 3ad:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 3af:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 3b3:	89 f8                	mov    %edi,%eax
 3b5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 3b8:	5b                   	pop    %ebx
 3b9:	5e                   	pop    %esi
 3ba:	5f                   	pop    %edi
 3bb:	5d                   	pop    %ebp
 3bc:	c3                   	ret    

000003bd <stat>:

int
stat(const char *n, struct stat *st)
{
 3bd:	55                   	push   %ebp
 3be:	89 e5                	mov    %esp,%ebp
 3c0:	56                   	push   %esi
 3c1:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3c2:	83 ec 08             	sub    $0x8,%esp
 3c5:	6a 00                	push   $0x0
 3c7:	ff 75 08             	pushl  0x8(%ebp)
 3ca:	e8 d0 00 00 00       	call   49f <open>
  if(fd < 0)
 3cf:	83 c4 10             	add    $0x10,%esp
 3d2:	85 c0                	test   %eax,%eax
 3d4:	78 24                	js     3fa <stat+0x3d>
 3d6:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 3d8:	83 ec 08             	sub    $0x8,%esp
 3db:	ff 75 0c             	pushl  0xc(%ebp)
 3de:	50                   	push   %eax
 3df:	e8 d3 00 00 00       	call   4b7 <fstat>
 3e4:	89 c6                	mov    %eax,%esi
  close(fd);
 3e6:	89 1c 24             	mov    %ebx,(%esp)
 3e9:	e8 99 00 00 00       	call   487 <close>
  return r;
 3ee:	83 c4 10             	add    $0x10,%esp
}
 3f1:	89 f0                	mov    %esi,%eax
 3f3:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3f6:	5b                   	pop    %ebx
 3f7:	5e                   	pop    %esi
 3f8:	5d                   	pop    %ebp
 3f9:	c3                   	ret    
    return -1;
 3fa:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3ff:	eb f0                	jmp    3f1 <stat+0x34>

00000401 <atoi>:

int
atoi(const char *s)
{
 401:	55                   	push   %ebp
 402:	89 e5                	mov    %esp,%ebp
 404:	53                   	push   %ebx
 405:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 408:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 40d:	eb 0e                	jmp    41d <atoi+0x1c>
    n = n*10 + *s++ - '0';
 40f:	8d 14 92             	lea    (%edx,%edx,4),%edx
 412:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 415:	41                   	inc    %ecx
 416:	0f be c0             	movsbl %al,%eax
 419:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 41d:	8a 01                	mov    (%ecx),%al
 41f:	8d 58 d0             	lea    -0x30(%eax),%ebx
 422:	80 fb 09             	cmp    $0x9,%bl
 425:	76 e8                	jbe    40f <atoi+0xe>
  return n;
}
 427:	89 d0                	mov    %edx,%eax
 429:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 42c:	c9                   	leave  
 42d:	c3                   	ret    

0000042e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 42e:	55                   	push   %ebp
 42f:	89 e5                	mov    %esp,%ebp
 431:	56                   	push   %esi
 432:	53                   	push   %ebx
 433:	8b 45 08             	mov    0x8(%ebp),%eax
 436:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 439:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 43c:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 43e:	eb 0c                	jmp    44c <memmove+0x1e>
    *dst++ = *src++;
 440:	8a 13                	mov    (%ebx),%dl
 442:	88 11                	mov    %dl,(%ecx)
 444:	8d 5b 01             	lea    0x1(%ebx),%ebx
 447:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 44a:	89 f2                	mov    %esi,%edx
 44c:	8d 72 ff             	lea    -0x1(%edx),%esi
 44f:	85 d2                	test   %edx,%edx
 451:	7f ed                	jg     440 <memmove+0x12>
  return vdst;
}
 453:	5b                   	pop    %ebx
 454:	5e                   	pop    %esi
 455:	5d                   	pop    %ebp
 456:	c3                   	ret    

00000457 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 457:	b8 01 00 00 00       	mov    $0x1,%eax
 45c:	cd 40                	int    $0x40
 45e:	c3                   	ret    

0000045f <exit>:
SYSCALL(exit)
 45f:	b8 02 00 00 00       	mov    $0x2,%eax
 464:	cd 40                	int    $0x40
 466:	c3                   	ret    

00000467 <wait>:
SYSCALL(wait)
 467:	b8 03 00 00 00       	mov    $0x3,%eax
 46c:	cd 40                	int    $0x40
 46e:	c3                   	ret    

0000046f <pipe>:
SYSCALL(pipe)
 46f:	b8 04 00 00 00       	mov    $0x4,%eax
 474:	cd 40                	int    $0x40
 476:	c3                   	ret    

00000477 <read>:
SYSCALL(read)
 477:	b8 05 00 00 00       	mov    $0x5,%eax
 47c:	cd 40                	int    $0x40
 47e:	c3                   	ret    

0000047f <write>:
SYSCALL(write)
 47f:	b8 10 00 00 00       	mov    $0x10,%eax
 484:	cd 40                	int    $0x40
 486:	c3                   	ret    

00000487 <close>:
SYSCALL(close)
 487:	b8 15 00 00 00       	mov    $0x15,%eax
 48c:	cd 40                	int    $0x40
 48e:	c3                   	ret    

0000048f <kill>:
SYSCALL(kill)
 48f:	b8 06 00 00 00       	mov    $0x6,%eax
 494:	cd 40                	int    $0x40
 496:	c3                   	ret    

00000497 <exec>:
SYSCALL(exec)
 497:	b8 07 00 00 00       	mov    $0x7,%eax
 49c:	cd 40                	int    $0x40
 49e:	c3                   	ret    

0000049f <open>:
SYSCALL(open)
 49f:	b8 0f 00 00 00       	mov    $0xf,%eax
 4a4:	cd 40                	int    $0x40
 4a6:	c3                   	ret    

000004a7 <mknod>:
SYSCALL(mknod)
 4a7:	b8 11 00 00 00       	mov    $0x11,%eax
 4ac:	cd 40                	int    $0x40
 4ae:	c3                   	ret    

000004af <unlink>:
SYSCALL(unlink)
 4af:	b8 12 00 00 00       	mov    $0x12,%eax
 4b4:	cd 40                	int    $0x40
 4b6:	c3                   	ret    

000004b7 <fstat>:
SYSCALL(fstat)
 4b7:	b8 08 00 00 00       	mov    $0x8,%eax
 4bc:	cd 40                	int    $0x40
 4be:	c3                   	ret    

000004bf <link>:
SYSCALL(link)
 4bf:	b8 13 00 00 00       	mov    $0x13,%eax
 4c4:	cd 40                	int    $0x40
 4c6:	c3                   	ret    

000004c7 <mkdir>:
SYSCALL(mkdir)
 4c7:	b8 14 00 00 00       	mov    $0x14,%eax
 4cc:	cd 40                	int    $0x40
 4ce:	c3                   	ret    

000004cf <chdir>:
SYSCALL(chdir)
 4cf:	b8 09 00 00 00       	mov    $0x9,%eax
 4d4:	cd 40                	int    $0x40
 4d6:	c3                   	ret    

000004d7 <dup>:
SYSCALL(dup)
 4d7:	b8 0a 00 00 00       	mov    $0xa,%eax
 4dc:	cd 40                	int    $0x40
 4de:	c3                   	ret    

000004df <getpid>:
SYSCALL(getpid)
 4df:	b8 0b 00 00 00       	mov    $0xb,%eax
 4e4:	cd 40                	int    $0x40
 4e6:	c3                   	ret    

000004e7 <sbrk>:
SYSCALL(sbrk)
 4e7:	b8 0c 00 00 00       	mov    $0xc,%eax
 4ec:	cd 40                	int    $0x40
 4ee:	c3                   	ret    

000004ef <sleep>:
SYSCALL(sleep)
 4ef:	b8 0d 00 00 00       	mov    $0xd,%eax
 4f4:	cd 40                	int    $0x40
 4f6:	c3                   	ret    

000004f7 <uptime>:
SYSCALL(uptime)
 4f7:	b8 0e 00 00 00       	mov    $0xe,%eax
 4fc:	cd 40                	int    $0x40
 4fe:	c3                   	ret    

000004ff <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 4ff:	b8 16 00 00 00       	mov    $0x16,%eax
 504:	cd 40                	int    $0x40
 506:	c3                   	ret    

00000507 <block>:
SYSCALL(block)
 507:	b8 17 00 00 00       	mov    $0x17,%eax
 50c:	cd 40                	int    $0x40
 50e:	c3                   	ret    

0000050f <unblock>:
SYSCALL(unblock)
 50f:	b8 18 00 00 00       	mov    $0x18,%eax
 514:	cd 40                	int    $0x40
 516:	c3                   	ret    

00000517 <chmod>:
SYSCALL(chmod)
 517:	b8 19 00 00 00       	mov    $0x19,%eax
 51c:	cd 40                	int    $0x40
 51e:	c3                   	ret    

0000051f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 51f:	55                   	push   %ebp
 520:	89 e5                	mov    %esp,%ebp
 522:	83 ec 1c             	sub    $0x1c,%esp
 525:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 528:	6a 01                	push   $0x1
 52a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 52d:	52                   	push   %edx
 52e:	50                   	push   %eax
 52f:	e8 4b ff ff ff       	call   47f <write>
}
 534:	83 c4 10             	add    $0x10,%esp
 537:	c9                   	leave  
 538:	c3                   	ret    

00000539 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 539:	55                   	push   %ebp
 53a:	89 e5                	mov    %esp,%ebp
 53c:	57                   	push   %edi
 53d:	56                   	push   %esi
 53e:	53                   	push   %ebx
 53f:	83 ec 2c             	sub    $0x2c,%esp
 542:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 545:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 547:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 54b:	74 04                	je     551 <printint+0x18>
 54d:	85 d2                	test   %edx,%edx
 54f:	78 3c                	js     58d <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 551:	89 d1                	mov    %edx,%ecx
  neg = 0;
 553:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 55a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 55f:	89 c8                	mov    %ecx,%eax
 561:	ba 00 00 00 00       	mov    $0x0,%edx
 566:	f7 f6                	div    %esi
 568:	89 df                	mov    %ebx,%edi
 56a:	43                   	inc    %ebx
 56b:	8a 92 04 09 00 00    	mov    0x904(%edx),%dl
 571:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 575:	89 ca                	mov    %ecx,%edx
 577:	89 c1                	mov    %eax,%ecx
 579:	39 f2                	cmp    %esi,%edx
 57b:	73 e2                	jae    55f <printint+0x26>
  if(neg)
 57d:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 581:	74 24                	je     5a7 <printint+0x6e>
    buf[i++] = '-';
 583:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 588:	8d 5f 02             	lea    0x2(%edi),%ebx
 58b:	eb 1a                	jmp    5a7 <printint+0x6e>
    x = -xx;
 58d:	89 d1                	mov    %edx,%ecx
 58f:	f7 d9                	neg    %ecx
    neg = 1;
 591:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 598:	eb c0                	jmp    55a <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 59a:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 59f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5a2:	e8 78 ff ff ff       	call   51f <putc>
  while(--i >= 0)
 5a7:	4b                   	dec    %ebx
 5a8:	79 f0                	jns    59a <printint+0x61>
}
 5aa:	83 c4 2c             	add    $0x2c,%esp
 5ad:	5b                   	pop    %ebx
 5ae:	5e                   	pop    %esi
 5af:	5f                   	pop    %edi
 5b0:	5d                   	pop    %ebp
 5b1:	c3                   	ret    

000005b2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 5b2:	55                   	push   %ebp
 5b3:	89 e5                	mov    %esp,%ebp
 5b5:	57                   	push   %edi
 5b6:	56                   	push   %esi
 5b7:	53                   	push   %ebx
 5b8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 5bb:	8d 45 10             	lea    0x10(%ebp),%eax
 5be:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 5c1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 5c6:	bb 00 00 00 00       	mov    $0x0,%ebx
 5cb:	eb 12                	jmp    5df <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 5cd:	89 fa                	mov    %edi,%edx
 5cf:	8b 45 08             	mov    0x8(%ebp),%eax
 5d2:	e8 48 ff ff ff       	call   51f <putc>
 5d7:	eb 05                	jmp    5de <printf+0x2c>
      }
    } else if(state == '%'){
 5d9:	83 fe 25             	cmp    $0x25,%esi
 5dc:	74 22                	je     600 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 5de:	43                   	inc    %ebx
 5df:	8b 45 0c             	mov    0xc(%ebp),%eax
 5e2:	8a 04 18             	mov    (%eax,%ebx,1),%al
 5e5:	84 c0                	test   %al,%al
 5e7:	0f 84 1d 01 00 00    	je     70a <printf+0x158>
    c = fmt[i] & 0xff;
 5ed:	0f be f8             	movsbl %al,%edi
 5f0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5f3:	85 f6                	test   %esi,%esi
 5f5:	75 e2                	jne    5d9 <printf+0x27>
      if(c == '%'){
 5f7:	83 f8 25             	cmp    $0x25,%eax
 5fa:	75 d1                	jne    5cd <printf+0x1b>
        state = '%';
 5fc:	89 c6                	mov    %eax,%esi
 5fe:	eb de                	jmp    5de <printf+0x2c>
      if(c == 'd'){
 600:	83 f8 25             	cmp    $0x25,%eax
 603:	0f 84 cc 00 00 00    	je     6d5 <printf+0x123>
 609:	0f 8c da 00 00 00    	jl     6e9 <printf+0x137>
 60f:	83 f8 78             	cmp    $0x78,%eax
 612:	0f 8f d1 00 00 00    	jg     6e9 <printf+0x137>
 618:	83 f8 63             	cmp    $0x63,%eax
 61b:	0f 8c c8 00 00 00    	jl     6e9 <printf+0x137>
 621:	83 e8 63             	sub    $0x63,%eax
 624:	83 f8 15             	cmp    $0x15,%eax
 627:	0f 87 bc 00 00 00    	ja     6e9 <printf+0x137>
 62d:	ff 24 85 ac 08 00 00 	jmp    *0x8ac(,%eax,4)
        printint(fd, *ap, 10, 1);
 634:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 637:	8b 17                	mov    (%edi),%edx
 639:	83 ec 0c             	sub    $0xc,%esp
 63c:	6a 01                	push   $0x1
 63e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 643:	8b 45 08             	mov    0x8(%ebp),%eax
 646:	e8 ee fe ff ff       	call   539 <printint>
        ap++;
 64b:	83 c7 04             	add    $0x4,%edi
 64e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 651:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 654:	be 00 00 00 00       	mov    $0x0,%esi
 659:	eb 83                	jmp    5de <printf+0x2c>
        printint(fd, *ap, 16, 0);
 65b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 65e:	8b 17                	mov    (%edi),%edx
 660:	83 ec 0c             	sub    $0xc,%esp
 663:	6a 00                	push   $0x0
 665:	b9 10 00 00 00       	mov    $0x10,%ecx
 66a:	8b 45 08             	mov    0x8(%ebp),%eax
 66d:	e8 c7 fe ff ff       	call   539 <printint>
        ap++;
 672:	83 c7 04             	add    $0x4,%edi
 675:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 678:	83 c4 10             	add    $0x10,%esp
      state = 0;
 67b:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 680:	e9 59 ff ff ff       	jmp    5de <printf+0x2c>
        s = (char*)*ap;
 685:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 688:	8b 30                	mov    (%eax),%esi
        ap++;
 68a:	83 c0 04             	add    $0x4,%eax
 68d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 690:	85 f6                	test   %esi,%esi
 692:	75 13                	jne    6a7 <printf+0xf5>
          s = "(null)";
 694:	be a2 08 00 00       	mov    $0x8a2,%esi
 699:	eb 0c                	jmp    6a7 <printf+0xf5>
          putc(fd, *s);
 69b:	0f be d2             	movsbl %dl,%edx
 69e:	8b 45 08             	mov    0x8(%ebp),%eax
 6a1:	e8 79 fe ff ff       	call   51f <putc>
          s++;
 6a6:	46                   	inc    %esi
        while(*s != 0){
 6a7:	8a 16                	mov    (%esi),%dl
 6a9:	84 d2                	test   %dl,%dl
 6ab:	75 ee                	jne    69b <printf+0xe9>
      state = 0;
 6ad:	be 00 00 00 00       	mov    $0x0,%esi
 6b2:	e9 27 ff ff ff       	jmp    5de <printf+0x2c>
        putc(fd, *ap);
 6b7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 6ba:	0f be 17             	movsbl (%edi),%edx
 6bd:	8b 45 08             	mov    0x8(%ebp),%eax
 6c0:	e8 5a fe ff ff       	call   51f <putc>
        ap++;
 6c5:	83 c7 04             	add    $0x4,%edi
 6c8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 6cb:	be 00 00 00 00       	mov    $0x0,%esi
 6d0:	e9 09 ff ff ff       	jmp    5de <printf+0x2c>
        putc(fd, c);
 6d5:	89 fa                	mov    %edi,%edx
 6d7:	8b 45 08             	mov    0x8(%ebp),%eax
 6da:	e8 40 fe ff ff       	call   51f <putc>
      state = 0;
 6df:	be 00 00 00 00       	mov    $0x0,%esi
 6e4:	e9 f5 fe ff ff       	jmp    5de <printf+0x2c>
        putc(fd, '%');
 6e9:	ba 25 00 00 00       	mov    $0x25,%edx
 6ee:	8b 45 08             	mov    0x8(%ebp),%eax
 6f1:	e8 29 fe ff ff       	call   51f <putc>
        putc(fd, c);
 6f6:	89 fa                	mov    %edi,%edx
 6f8:	8b 45 08             	mov    0x8(%ebp),%eax
 6fb:	e8 1f fe ff ff       	call   51f <putc>
      state = 0;
 700:	be 00 00 00 00       	mov    $0x0,%esi
 705:	e9 d4 fe ff ff       	jmp    5de <printf+0x2c>
    }
  }
}
 70a:	8d 65 f4             	lea    -0xc(%ebp),%esp
 70d:	5b                   	pop    %ebx
 70e:	5e                   	pop    %esi
 70f:	5f                   	pop    %edi
 710:	5d                   	pop    %ebp
 711:	c3                   	ret    

00000712 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 712:	55                   	push   %ebp
 713:	89 e5                	mov    %esp,%ebp
 715:	57                   	push   %edi
 716:	56                   	push   %esi
 717:	53                   	push   %ebx
 718:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 71b:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 71e:	a1 28 09 00 00       	mov    0x928,%eax
 723:	eb 02                	jmp    727 <free+0x15>
 725:	89 d0                	mov    %edx,%eax
 727:	39 c8                	cmp    %ecx,%eax
 729:	73 04                	jae    72f <free+0x1d>
 72b:	3b 08                	cmp    (%eax),%ecx
 72d:	72 12                	jb     741 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 72f:	8b 10                	mov    (%eax),%edx
 731:	39 d0                	cmp    %edx,%eax
 733:	72 f0                	jb     725 <free+0x13>
 735:	39 c8                	cmp    %ecx,%eax
 737:	72 08                	jb     741 <free+0x2f>
 739:	39 d1                	cmp    %edx,%ecx
 73b:	72 04                	jb     741 <free+0x2f>
 73d:	89 d0                	mov    %edx,%eax
 73f:	eb e6                	jmp    727 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 741:	8b 73 fc             	mov    -0x4(%ebx),%esi
 744:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 747:	8b 10                	mov    (%eax),%edx
 749:	39 d7                	cmp    %edx,%edi
 74b:	74 19                	je     766 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 74d:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 750:	8b 50 04             	mov    0x4(%eax),%edx
 753:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 756:	39 ce                	cmp    %ecx,%esi
 758:	74 1b                	je     775 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 75a:	89 08                	mov    %ecx,(%eax)
  freep = p;
 75c:	a3 28 09 00 00       	mov    %eax,0x928
}
 761:	5b                   	pop    %ebx
 762:	5e                   	pop    %esi
 763:	5f                   	pop    %edi
 764:	5d                   	pop    %ebp
 765:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 766:	03 72 04             	add    0x4(%edx),%esi
 769:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 76c:	8b 10                	mov    (%eax),%edx
 76e:	8b 12                	mov    (%edx),%edx
 770:	89 53 f8             	mov    %edx,-0x8(%ebx)
 773:	eb db                	jmp    750 <free+0x3e>
    p->s.size += bp->s.size;
 775:	03 53 fc             	add    -0x4(%ebx),%edx
 778:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 77b:	8b 53 f8             	mov    -0x8(%ebx),%edx
 77e:	89 10                	mov    %edx,(%eax)
 780:	eb da                	jmp    75c <free+0x4a>

00000782 <morecore>:

static Header*
morecore(uint nu)
{
 782:	55                   	push   %ebp
 783:	89 e5                	mov    %esp,%ebp
 785:	53                   	push   %ebx
 786:	83 ec 04             	sub    $0x4,%esp
 789:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 78b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 790:	77 05                	ja     797 <morecore+0x15>
    nu = 4096;
 792:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 797:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 79e:	83 ec 0c             	sub    $0xc,%esp
 7a1:	50                   	push   %eax
 7a2:	e8 40 fd ff ff       	call   4e7 <sbrk>
  if(p == (char*)-1)
 7a7:	83 c4 10             	add    $0x10,%esp
 7aa:	83 f8 ff             	cmp    $0xffffffff,%eax
 7ad:	74 1c                	je     7cb <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 7af:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 7b2:	83 c0 08             	add    $0x8,%eax
 7b5:	83 ec 0c             	sub    $0xc,%esp
 7b8:	50                   	push   %eax
 7b9:	e8 54 ff ff ff       	call   712 <free>
  return freep;
 7be:	a1 28 09 00 00       	mov    0x928,%eax
 7c3:	83 c4 10             	add    $0x10,%esp
}
 7c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7c9:	c9                   	leave  
 7ca:	c3                   	ret    
    return 0;
 7cb:	b8 00 00 00 00       	mov    $0x0,%eax
 7d0:	eb f4                	jmp    7c6 <morecore+0x44>

000007d2 <malloc>:

void*
malloc(uint nbytes)
{
 7d2:	55                   	push   %ebp
 7d3:	89 e5                	mov    %esp,%ebp
 7d5:	53                   	push   %ebx
 7d6:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7d9:	8b 45 08             	mov    0x8(%ebp),%eax
 7dc:	8d 58 07             	lea    0x7(%eax),%ebx
 7df:	c1 eb 03             	shr    $0x3,%ebx
 7e2:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 7e3:	8b 0d 28 09 00 00    	mov    0x928,%ecx
 7e9:	85 c9                	test   %ecx,%ecx
 7eb:	74 04                	je     7f1 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	8b 01                	mov    (%ecx),%eax
 7ef:	eb 4a                	jmp    83b <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 7f1:	c7 05 28 09 00 00 2c 	movl   $0x92c,0x928
 7f8:	09 00 00 
 7fb:	c7 05 2c 09 00 00 2c 	movl   $0x92c,0x92c
 802:	09 00 00 
    base.s.size = 0;
 805:	c7 05 30 09 00 00 00 	movl   $0x0,0x930
 80c:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 80f:	b9 2c 09 00 00       	mov    $0x92c,%ecx
 814:	eb d7                	jmp    7ed <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 816:	74 19                	je     831 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 818:	29 da                	sub    %ebx,%edx
 81a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 81d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 820:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 823:	89 0d 28 09 00 00    	mov    %ecx,0x928
      return (void*)(p + 1);
 829:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 82c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 82f:	c9                   	leave  
 830:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 831:	8b 10                	mov    (%eax),%edx
 833:	89 11                	mov    %edx,(%ecx)
 835:	eb ec                	jmp    823 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 837:	89 c1                	mov    %eax,%ecx
 839:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 83b:	8b 50 04             	mov    0x4(%eax),%edx
 83e:	39 da                	cmp    %ebx,%edx
 840:	73 d4                	jae    816 <malloc+0x44>
    if(p == freep)
 842:	39 05 28 09 00 00    	cmp    %eax,0x928
 848:	75 ed                	jne    837 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 84a:	89 d8                	mov    %ebx,%eax
 84c:	e8 31 ff ff ff       	call   782 <morecore>
 851:	85 c0                	test   %eax,%eax
 853:	75 e2                	jne    837 <malloc+0x65>
 855:	eb d5                	jmp    82c <malloc+0x5a>
