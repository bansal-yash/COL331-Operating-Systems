
_grep:     file format elf32-i386


Disassembly of section .text:

00000000 <matchstar>:
  return 0;
}

// matchstar: search for c*re at beginning of text
int matchstar(int c, char *re, char *text)
{
   0:	55                   	push   %ebp
   1:	89 e5                	mov    %esp,%ebp
   3:	57                   	push   %edi
   4:	56                   	push   %esi
   5:	53                   	push   %ebx
   6:	83 ec 0c             	sub    $0xc,%esp
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 7d 0c             	mov    0xc(%ebp),%edi
   f:	8b 5d 10             	mov    0x10(%ebp),%ebx
  do{  // a * matches zero or more instances
    if(matchhere(re, text))
  12:	83 ec 08             	sub    $0x8,%esp
  15:	53                   	push   %ebx
  16:	57                   	push   %edi
  17:	e8 29 00 00 00       	call   45 <matchhere>
  1c:	83 c4 10             	add    $0x10,%esp
  1f:	85 c0                	test   %eax,%eax
  21:	75 15                	jne    38 <matchstar+0x38>
      return 1;
  }while(*text!='\0' && (*text++==c || c=='.'));
  23:	8a 13                	mov    (%ebx),%dl
  25:	84 d2                	test   %dl,%dl
  27:	74 14                	je     3d <matchstar+0x3d>
  29:	43                   	inc    %ebx
  2a:	0f be d2             	movsbl %dl,%edx
  2d:	39 f2                	cmp    %esi,%edx
  2f:	74 e1                	je     12 <matchstar+0x12>
  31:	83 fe 2e             	cmp    $0x2e,%esi
  34:	74 dc                	je     12 <matchstar+0x12>
  36:	eb 05                	jmp    3d <matchstar+0x3d>
      return 1;
  38:	b8 01 00 00 00       	mov    $0x1,%eax
  return 0;
}
  3d:	8d 65 f4             	lea    -0xc(%ebp),%esp
  40:	5b                   	pop    %ebx
  41:	5e                   	pop    %esi
  42:	5f                   	pop    %edi
  43:	5d                   	pop    %ebp
  44:	c3                   	ret    

00000045 <matchhere>:
{
  45:	55                   	push   %ebp
  46:	89 e5                	mov    %esp,%ebp
  48:	83 ec 08             	sub    $0x8,%esp
  4b:	8b 55 08             	mov    0x8(%ebp),%edx
  if(re[0] == '\0')
  4e:	8a 02                	mov    (%edx),%al
  50:	84 c0                	test   %al,%al
  52:	74 62                	je     b6 <matchhere+0x71>
  if(re[1] == '*')
  54:	8a 4a 01             	mov    0x1(%edx),%cl
  57:	80 f9 2a             	cmp    $0x2a,%cl
  5a:	74 1c                	je     78 <matchhere+0x33>
  if(re[0] == '$' && re[1] == '\0')
  5c:	3c 24                	cmp    $0x24,%al
  5e:	74 30                	je     90 <matchhere+0x4b>
  if(*text!='\0' && (re[0]=='.' || re[0]==*text))
  60:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  63:	8a 09                	mov    (%ecx),%cl
  65:	84 c9                	test   %cl,%cl
  67:	74 54                	je     bd <matchhere+0x78>
  69:	3c 2e                	cmp    $0x2e,%al
  6b:	74 35                	je     a2 <matchhere+0x5d>
  6d:	38 c8                	cmp    %cl,%al
  6f:	74 31                	je     a2 <matchhere+0x5d>
  return 0;
  71:	b8 00 00 00 00       	mov    $0x0,%eax
  76:	eb 43                	jmp    bb <matchhere+0x76>
    return matchstar(re[0], re+2, text);
  78:	83 ec 04             	sub    $0x4,%esp
  7b:	ff 75 0c             	pushl  0xc(%ebp)
  7e:	83 c2 02             	add    $0x2,%edx
  81:	52                   	push   %edx
  82:	0f be c0             	movsbl %al,%eax
  85:	50                   	push   %eax
  86:	e8 75 ff ff ff       	call   0 <matchstar>
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	eb 2b                	jmp    bb <matchhere+0x76>
  if(re[0] == '$' && re[1] == '\0')
  90:	84 c9                	test   %cl,%cl
  92:	75 cc                	jne    60 <matchhere+0x1b>
    return *text == '\0';
  94:	8b 45 0c             	mov    0xc(%ebp),%eax
  97:	80 38 00             	cmpb   $0x0,(%eax)
  9a:	0f 94 c0             	sete   %al
  9d:	0f b6 c0             	movzbl %al,%eax
  a0:	eb 19                	jmp    bb <matchhere+0x76>
    return matchhere(re+1, text+1);
  a2:	83 ec 08             	sub    $0x8,%esp
  a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  a8:	40                   	inc    %eax
  a9:	50                   	push   %eax
  aa:	42                   	inc    %edx
  ab:	52                   	push   %edx
  ac:	e8 94 ff ff ff       	call   45 <matchhere>
  b1:	83 c4 10             	add    $0x10,%esp
  b4:	eb 05                	jmp    bb <matchhere+0x76>
    return 1;
  b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  bb:	c9                   	leave  
  bc:	c3                   	ret    
  return 0;
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	eb f7                	jmp    bb <matchhere+0x76>

000000c4 <match>:
{
  c4:	55                   	push   %ebp
  c5:	89 e5                	mov    %esp,%ebp
  c7:	56                   	push   %esi
  c8:	53                   	push   %ebx
  c9:	8b 75 08             	mov    0x8(%ebp),%esi
  cc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  if(re[0] == '^')
  cf:	80 3e 5e             	cmpb   $0x5e,(%esi)
  d2:	75 12                	jne    e6 <match+0x22>
    return matchhere(re+1, text);
  d4:	83 ec 08             	sub    $0x8,%esp
  d7:	53                   	push   %ebx
  d8:	46                   	inc    %esi
  d9:	56                   	push   %esi
  da:	e8 66 ff ff ff       	call   45 <matchhere>
  df:	83 c4 10             	add    $0x10,%esp
  e2:	eb 22                	jmp    106 <match+0x42>
  }while(*text++ != '\0');
  e4:	89 d3                	mov    %edx,%ebx
    if(matchhere(re, text))
  e6:	83 ec 08             	sub    $0x8,%esp
  e9:	53                   	push   %ebx
  ea:	56                   	push   %esi
  eb:	e8 55 ff ff ff       	call   45 <matchhere>
  f0:	83 c4 10             	add    $0x10,%esp
  f3:	85 c0                	test   %eax,%eax
  f5:	75 0a                	jne    101 <match+0x3d>
  }while(*text++ != '\0');
  f7:	8d 53 01             	lea    0x1(%ebx),%edx
  fa:	80 3b 00             	cmpb   $0x0,(%ebx)
  fd:	75 e5                	jne    e4 <match+0x20>
  ff:	eb 05                	jmp    106 <match+0x42>
      return 1;
 101:	b8 01 00 00 00       	mov    $0x1,%eax
}
 106:	8d 65 f8             	lea    -0x8(%ebp),%esp
 109:	5b                   	pop    %ebx
 10a:	5e                   	pop    %esi
 10b:	5d                   	pop    %ebp
 10c:	c3                   	ret    

0000010d <grep>:
{
 10d:	55                   	push   %ebp
 10e:	89 e5                	mov    %esp,%ebp
 110:	57                   	push   %edi
 111:	56                   	push   %esi
 112:	53                   	push   %ebx
 113:	83 ec 1c             	sub    $0x1c,%esp
 116:	8b 7d 08             	mov    0x8(%ebp),%edi
  m = 0;
 119:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 120:	eb 52                	jmp    174 <grep+0x67>
      p = q+1;
 122:	8d 73 01             	lea    0x1(%ebx),%esi
    while((q = strchr(p, '\n')) != 0){
 125:	83 ec 08             	sub    $0x8,%esp
 128:	6a 0a                	push   $0xa
 12a:	56                   	push   %esi
 12b:	e8 d2 01 00 00       	call   302 <strchr>
 130:	89 c3                	mov    %eax,%ebx
 132:	83 c4 10             	add    $0x10,%esp
 135:	85 c0                	test   %eax,%eax
 137:	74 2d                	je     166 <grep+0x59>
      *q = 0;
 139:	c6 03 00             	movb   $0x0,(%ebx)
      if(match(pattern, p)){
 13c:	83 ec 08             	sub    $0x8,%esp
 13f:	56                   	push   %esi
 140:	57                   	push   %edi
 141:	e8 7e ff ff ff       	call   c4 <match>
 146:	83 c4 10             	add    $0x10,%esp
 149:	85 c0                	test   %eax,%eax
 14b:	74 d5                	je     122 <grep+0x15>
        *q = '\n';
 14d:	c6 03 0a             	movb   $0xa,(%ebx)
        write(1, p, q+1 - p);
 150:	8d 43 01             	lea    0x1(%ebx),%eax
 153:	29 f0                	sub    %esi,%eax
 155:	83 ec 04             	sub    $0x4,%esp
 158:	50                   	push   %eax
 159:	56                   	push   %esi
 15a:	6a 01                	push   $0x1
 15c:	e8 d4 02 00 00       	call   435 <write>
 161:	83 c4 10             	add    $0x10,%esp
 164:	eb bc                	jmp    122 <grep+0x15>
    if(p == buf)
 166:	81 fe c0 08 00 00    	cmp    $0x8c0,%esi
 16c:	74 41                	je     1af <grep+0xa2>
    if(m > 0){
 16e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
 172:	7f 44                	jg     1b8 <grep+0xab>
  while((n = read(fd, buf+m, sizeof(buf)-m-1)) > 0){
 174:	b8 ff 03 00 00       	mov    $0x3ff,%eax
 179:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
 17c:	29 c8                	sub    %ecx,%eax
 17e:	83 ec 04             	sub    $0x4,%esp
 181:	50                   	push   %eax
 182:	8d 81 c0 08 00 00    	lea    0x8c0(%ecx),%eax
 188:	50                   	push   %eax
 189:	ff 75 0c             	pushl  0xc(%ebp)
 18c:	e8 9c 02 00 00       	call   42d <read>
 191:	83 c4 10             	add    $0x10,%esp
 194:	85 c0                	test   %eax,%eax
 196:	7e 41                	jle    1d9 <grep+0xcc>
    m += n;
 198:	01 45 e4             	add    %eax,-0x1c(%ebp)
 19b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
    buf[m] = '\0';
 19e:	c6 82 c0 08 00 00 00 	movb   $0x0,0x8c0(%edx)
    p = buf;
 1a5:	be c0 08 00 00       	mov    $0x8c0,%esi
    while((q = strchr(p, '\n')) != 0){
 1aa:	e9 76 ff ff ff       	jmp    125 <grep+0x18>
      m = 0;
 1af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
 1b6:	eb b6                	jmp    16e <grep+0x61>
      m -= p - buf;
 1b8:	89 f0                	mov    %esi,%eax
 1ba:	2d c0 08 00 00       	sub    $0x8c0,%eax
 1bf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
 1c2:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
      memmove(buf, p, m);
 1c5:	83 ec 04             	sub    $0x4,%esp
 1c8:	51                   	push   %ecx
 1c9:	56                   	push   %esi
 1ca:	68 c0 08 00 00       	push   $0x8c0
 1cf:	e8 10 02 00 00       	call   3e4 <memmove>
 1d4:	83 c4 10             	add    $0x10,%esp
 1d7:	eb 9b                	jmp    174 <grep+0x67>
}
 1d9:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1dc:	5b                   	pop    %ebx
 1dd:	5e                   	pop    %esi
 1de:	5f                   	pop    %edi
 1df:	5d                   	pop    %ebp
 1e0:	c3                   	ret    

000001e1 <main>:
{
 1e1:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 1e5:	83 e4 f0             	and    $0xfffffff0,%esp
 1e8:	ff 71 fc             	pushl  -0x4(%ecx)
 1eb:	55                   	push   %ebp
 1ec:	89 e5                	mov    %esp,%ebp
 1ee:	57                   	push   %edi
 1ef:	56                   	push   %esi
 1f0:	53                   	push   %ebx
 1f1:	51                   	push   %ecx
 1f2:	83 ec 18             	sub    $0x18,%esp
 1f5:	8b 01                	mov    (%ecx),%eax
 1f7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 1fa:	8b 51 04             	mov    0x4(%ecx),%edx
 1fd:	89 55 e0             	mov    %edx,-0x20(%ebp)
  if(argc <= 1){
 200:	83 f8 01             	cmp    $0x1,%eax
 203:	7e 50                	jle    255 <main+0x74>
  pattern = argv[1];
 205:	8b 45 e0             	mov    -0x20(%ebp),%eax
 208:	8b 40 04             	mov    0x4(%eax),%eax
 20b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  if(argc <= 2){
 20e:	83 7d e4 02          	cmpl   $0x2,-0x1c(%ebp)
 212:	7e 55                	jle    269 <main+0x88>
  for(i = 2; i < argc; i++){
 214:	be 02 00 00 00       	mov    $0x2,%esi
 219:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 21c:	39 c6                	cmp    %eax,%esi
 21e:	7d 6f                	jge    28f <main+0xae>
    if((fd = open(argv[i], 0)) < 0){
 220:	8b 45 e0             	mov    -0x20(%ebp),%eax
 223:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 226:	83 ec 08             	sub    $0x8,%esp
 229:	6a 00                	push   $0x0
 22b:	ff 37                	pushl  (%edi)
 22d:	e8 23 02 00 00       	call   455 <open>
 232:	89 c3                	mov    %eax,%ebx
 234:	83 c4 10             	add    $0x10,%esp
 237:	85 c0                	test   %eax,%eax
 239:	78 3e                	js     279 <main+0x98>
    grep(pattern, fd);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	50                   	push   %eax
 23f:	ff 75 dc             	pushl  -0x24(%ebp)
 242:	e8 c6 fe ff ff       	call   10d <grep>
    close(fd);
 247:	89 1c 24             	mov    %ebx,(%esp)
 24a:	e8 ee 01 00 00       	call   43d <close>
  for(i = 2; i < argc; i++){
 24f:	46                   	inc    %esi
 250:	83 c4 10             	add    $0x10,%esp
 253:	eb c4                	jmp    219 <main+0x38>
    printf(2, "usage: grep pattern [file ...]\n");
 255:	83 ec 08             	sub    $0x8,%esp
 258:	68 10 08 00 00       	push   $0x810
 25d:	6a 02                	push   $0x2
 25f:	e8 04 03 00 00       	call   568 <printf>
    exit();
 264:	e8 ac 01 00 00       	call   415 <exit>
    grep(pattern, 0);
 269:	83 ec 08             	sub    $0x8,%esp
 26c:	6a 00                	push   $0x0
 26e:	50                   	push   %eax
 26f:	e8 99 fe ff ff       	call   10d <grep>
    exit();
 274:	e8 9c 01 00 00       	call   415 <exit>
      printf(1, "grep: cannot open %s\n", argv[i]);
 279:	83 ec 04             	sub    $0x4,%esp
 27c:	ff 37                	pushl  (%edi)
 27e:	68 30 08 00 00       	push   $0x830
 283:	6a 01                	push   $0x1
 285:	e8 de 02 00 00       	call   568 <printf>
      exit();
 28a:	e8 86 01 00 00       	call   415 <exit>
  exit();
 28f:	e8 81 01 00 00       	call   415 <exit>

00000294 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 294:	55                   	push   %ebp
 295:	89 e5                	mov    %esp,%ebp
 297:	56                   	push   %esi
 298:	53                   	push   %ebx
 299:	8b 45 08             	mov    0x8(%ebp),%eax
 29c:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 29f:	89 c2                	mov    %eax,%edx
 2a1:	89 cb                	mov    %ecx,%ebx
 2a3:	41                   	inc    %ecx
 2a4:	89 d6                	mov    %edx,%esi
 2a6:	42                   	inc    %edx
 2a7:	8a 1b                	mov    (%ebx),%bl
 2a9:	88 1e                	mov    %bl,(%esi)
 2ab:	84 db                	test   %bl,%bl
 2ad:	75 f2                	jne    2a1 <strcpy+0xd>
    ;
  return os;
}
 2af:	5b                   	pop    %ebx
 2b0:	5e                   	pop    %esi
 2b1:	5d                   	pop    %ebp
 2b2:	c3                   	ret    

000002b3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2b3:	55                   	push   %ebp
 2b4:	89 e5                	mov    %esp,%ebp
 2b6:	8b 4d 08             	mov    0x8(%ebp),%ecx
 2b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 2bc:	eb 02                	jmp    2c0 <strcmp+0xd>
    p++, q++;
 2be:	41                   	inc    %ecx
 2bf:	42                   	inc    %edx
  while(*p && *p == *q)
 2c0:	8a 01                	mov    (%ecx),%al
 2c2:	84 c0                	test   %al,%al
 2c4:	74 04                	je     2ca <strcmp+0x17>
 2c6:	3a 02                	cmp    (%edx),%al
 2c8:	74 f4                	je     2be <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 2ca:	0f b6 c0             	movzbl %al,%eax
 2cd:	0f b6 12             	movzbl (%edx),%edx
 2d0:	29 d0                	sub    %edx,%eax
}
 2d2:	5d                   	pop    %ebp
 2d3:	c3                   	ret    

000002d4 <strlen>:

uint
strlen(const char *s)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 2da:	b8 00 00 00 00       	mov    $0x0,%eax
 2df:	eb 01                	jmp    2e2 <strlen+0xe>
 2e1:	40                   	inc    %eax
 2e2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 2e6:	75 f9                	jne    2e1 <strlen+0xd>
    ;
  return n;
}
 2e8:	5d                   	pop    %ebp
 2e9:	c3                   	ret    

000002ea <memset>:

void*
memset(void *dst, int c, uint n)
{
 2ea:	55                   	push   %ebp
 2eb:	89 e5                	mov    %esp,%ebp
 2ed:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 2ee:	8b 7d 08             	mov    0x8(%ebp),%edi
 2f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
 2f4:	8b 45 0c             	mov    0xc(%ebp),%eax
 2f7:	fc                   	cld    
 2f8:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 2fa:	8b 45 08             	mov    0x8(%ebp),%eax
 2fd:	8b 7d fc             	mov    -0x4(%ebp),%edi
 300:	c9                   	leave  
 301:	c3                   	ret    

00000302 <strchr>:

char*
strchr(const char *s, char c)
{
 302:	55                   	push   %ebp
 303:	89 e5                	mov    %esp,%ebp
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 30b:	eb 01                	jmp    30e <strchr+0xc>
 30d:	40                   	inc    %eax
 30e:	8a 10                	mov    (%eax),%dl
 310:	84 d2                	test   %dl,%dl
 312:	74 06                	je     31a <strchr+0x18>
    if(*s == c)
 314:	38 ca                	cmp    %cl,%dl
 316:	75 f5                	jne    30d <strchr+0xb>
 318:	eb 05                	jmp    31f <strchr+0x1d>
      return (char*)s;
  return 0;
 31a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 31f:	5d                   	pop    %ebp
 320:	c3                   	ret    

00000321 <gets>:

char*
gets(char *buf, int max)
{
 321:	55                   	push   %ebp
 322:	89 e5                	mov    %esp,%ebp
 324:	57                   	push   %edi
 325:	56                   	push   %esi
 326:	53                   	push   %ebx
 327:	83 ec 1c             	sub    $0x1c,%esp
 32a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 32d:	bb 00 00 00 00       	mov    $0x0,%ebx
 332:	89 de                	mov    %ebx,%esi
 334:	43                   	inc    %ebx
 335:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 338:	7d 2b                	jge    365 <gets+0x44>
    cc = read(0, &c, 1);
 33a:	83 ec 04             	sub    $0x4,%esp
 33d:	6a 01                	push   $0x1
 33f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 342:	50                   	push   %eax
 343:	6a 00                	push   $0x0
 345:	e8 e3 00 00 00       	call   42d <read>
    if(cc < 1)
 34a:	83 c4 10             	add    $0x10,%esp
 34d:	85 c0                	test   %eax,%eax
 34f:	7e 14                	jle    365 <gets+0x44>
      break;
    buf[i++] = c;
 351:	8a 45 e7             	mov    -0x19(%ebp),%al
 354:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 357:	3c 0a                	cmp    $0xa,%al
 359:	74 08                	je     363 <gets+0x42>
 35b:	3c 0d                	cmp    $0xd,%al
 35d:	75 d3                	jne    332 <gets+0x11>
    buf[i++] = c;
 35f:	89 de                	mov    %ebx,%esi
 361:	eb 02                	jmp    365 <gets+0x44>
 363:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 365:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 369:	89 f8                	mov    %edi,%eax
 36b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 36e:	5b                   	pop    %ebx
 36f:	5e                   	pop    %esi
 370:	5f                   	pop    %edi
 371:	5d                   	pop    %ebp
 372:	c3                   	ret    

00000373 <stat>:

int
stat(const char *n, struct stat *st)
{
 373:	55                   	push   %ebp
 374:	89 e5                	mov    %esp,%ebp
 376:	56                   	push   %esi
 377:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 378:	83 ec 08             	sub    $0x8,%esp
 37b:	6a 00                	push   $0x0
 37d:	ff 75 08             	pushl  0x8(%ebp)
 380:	e8 d0 00 00 00       	call   455 <open>
  if(fd < 0)
 385:	83 c4 10             	add    $0x10,%esp
 388:	85 c0                	test   %eax,%eax
 38a:	78 24                	js     3b0 <stat+0x3d>
 38c:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 38e:	83 ec 08             	sub    $0x8,%esp
 391:	ff 75 0c             	pushl  0xc(%ebp)
 394:	50                   	push   %eax
 395:	e8 d3 00 00 00       	call   46d <fstat>
 39a:	89 c6                	mov    %eax,%esi
  close(fd);
 39c:	89 1c 24             	mov    %ebx,(%esp)
 39f:	e8 99 00 00 00       	call   43d <close>
  return r;
 3a4:	83 c4 10             	add    $0x10,%esp
}
 3a7:	89 f0                	mov    %esi,%eax
 3a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
 3ac:	5b                   	pop    %ebx
 3ad:	5e                   	pop    %esi
 3ae:	5d                   	pop    %ebp
 3af:	c3                   	ret    
    return -1;
 3b0:	be ff ff ff ff       	mov    $0xffffffff,%esi
 3b5:	eb f0                	jmp    3a7 <stat+0x34>

000003b7 <atoi>:

int
atoi(const char *s)
{
 3b7:	55                   	push   %ebp
 3b8:	89 e5                	mov    %esp,%ebp
 3ba:	53                   	push   %ebx
 3bb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 3be:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 3c3:	eb 0e                	jmp    3d3 <atoi+0x1c>
    n = n*10 + *s++ - '0';
 3c5:	8d 14 92             	lea    (%edx,%edx,4),%edx
 3c8:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 3cb:	41                   	inc    %ecx
 3cc:	0f be c0             	movsbl %al,%eax
 3cf:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 3d3:	8a 01                	mov    (%ecx),%al
 3d5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 3d8:	80 fb 09             	cmp    $0x9,%bl
 3db:	76 e8                	jbe    3c5 <atoi+0xe>
  return n;
}
 3dd:	89 d0                	mov    %edx,%eax
 3df:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 3e2:	c9                   	leave  
 3e3:	c3                   	ret    

000003e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3e4:	55                   	push   %ebp
 3e5:	89 e5                	mov    %esp,%ebp
 3e7:	56                   	push   %esi
 3e8:	53                   	push   %ebx
 3e9:	8b 45 08             	mov    0x8(%ebp),%eax
 3ec:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 3ef:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 3f2:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 3f4:	eb 0c                	jmp    402 <memmove+0x1e>
    *dst++ = *src++;
 3f6:	8a 13                	mov    (%ebx),%dl
 3f8:	88 11                	mov    %dl,(%ecx)
 3fa:	8d 5b 01             	lea    0x1(%ebx),%ebx
 3fd:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 400:	89 f2                	mov    %esi,%edx
 402:	8d 72 ff             	lea    -0x1(%edx),%esi
 405:	85 d2                	test   %edx,%edx
 407:	7f ed                	jg     3f6 <memmove+0x12>
  return vdst;
}
 409:	5b                   	pop    %ebx
 40a:	5e                   	pop    %esi
 40b:	5d                   	pop    %ebp
 40c:	c3                   	ret    

0000040d <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 40d:	b8 01 00 00 00       	mov    $0x1,%eax
 412:	cd 40                	int    $0x40
 414:	c3                   	ret    

00000415 <exit>:
SYSCALL(exit)
 415:	b8 02 00 00 00       	mov    $0x2,%eax
 41a:	cd 40                	int    $0x40
 41c:	c3                   	ret    

0000041d <wait>:
SYSCALL(wait)
 41d:	b8 03 00 00 00       	mov    $0x3,%eax
 422:	cd 40                	int    $0x40
 424:	c3                   	ret    

00000425 <pipe>:
SYSCALL(pipe)
 425:	b8 04 00 00 00       	mov    $0x4,%eax
 42a:	cd 40                	int    $0x40
 42c:	c3                   	ret    

0000042d <read>:
SYSCALL(read)
 42d:	b8 05 00 00 00       	mov    $0x5,%eax
 432:	cd 40                	int    $0x40
 434:	c3                   	ret    

00000435 <write>:
SYSCALL(write)
 435:	b8 10 00 00 00       	mov    $0x10,%eax
 43a:	cd 40                	int    $0x40
 43c:	c3                   	ret    

0000043d <close>:
SYSCALL(close)
 43d:	b8 15 00 00 00       	mov    $0x15,%eax
 442:	cd 40                	int    $0x40
 444:	c3                   	ret    

00000445 <kill>:
SYSCALL(kill)
 445:	b8 06 00 00 00       	mov    $0x6,%eax
 44a:	cd 40                	int    $0x40
 44c:	c3                   	ret    

0000044d <exec>:
SYSCALL(exec)
 44d:	b8 07 00 00 00       	mov    $0x7,%eax
 452:	cd 40                	int    $0x40
 454:	c3                   	ret    

00000455 <open>:
SYSCALL(open)
 455:	b8 0f 00 00 00       	mov    $0xf,%eax
 45a:	cd 40                	int    $0x40
 45c:	c3                   	ret    

0000045d <mknod>:
SYSCALL(mknod)
 45d:	b8 11 00 00 00       	mov    $0x11,%eax
 462:	cd 40                	int    $0x40
 464:	c3                   	ret    

00000465 <unlink>:
SYSCALL(unlink)
 465:	b8 12 00 00 00       	mov    $0x12,%eax
 46a:	cd 40                	int    $0x40
 46c:	c3                   	ret    

0000046d <fstat>:
SYSCALL(fstat)
 46d:	b8 08 00 00 00       	mov    $0x8,%eax
 472:	cd 40                	int    $0x40
 474:	c3                   	ret    

00000475 <link>:
SYSCALL(link)
 475:	b8 13 00 00 00       	mov    $0x13,%eax
 47a:	cd 40                	int    $0x40
 47c:	c3                   	ret    

0000047d <mkdir>:
SYSCALL(mkdir)
 47d:	b8 14 00 00 00       	mov    $0x14,%eax
 482:	cd 40                	int    $0x40
 484:	c3                   	ret    

00000485 <chdir>:
SYSCALL(chdir)
 485:	b8 09 00 00 00       	mov    $0x9,%eax
 48a:	cd 40                	int    $0x40
 48c:	c3                   	ret    

0000048d <dup>:
SYSCALL(dup)
 48d:	b8 0a 00 00 00       	mov    $0xa,%eax
 492:	cd 40                	int    $0x40
 494:	c3                   	ret    

00000495 <getpid>:
SYSCALL(getpid)
 495:	b8 0b 00 00 00       	mov    $0xb,%eax
 49a:	cd 40                	int    $0x40
 49c:	c3                   	ret    

0000049d <sbrk>:
SYSCALL(sbrk)
 49d:	b8 0c 00 00 00       	mov    $0xc,%eax
 4a2:	cd 40                	int    $0x40
 4a4:	c3                   	ret    

000004a5 <sleep>:
SYSCALL(sleep)
 4a5:	b8 0d 00 00 00       	mov    $0xd,%eax
 4aa:	cd 40                	int    $0x40
 4ac:	c3                   	ret    

000004ad <uptime>:
SYSCALL(uptime)
 4ad:	b8 0e 00 00 00       	mov    $0xe,%eax
 4b2:	cd 40                	int    $0x40
 4b4:	c3                   	ret    

000004b5 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 4b5:	b8 16 00 00 00       	mov    $0x16,%eax
 4ba:	cd 40                	int    $0x40
 4bc:	c3                   	ret    

000004bd <block>:
SYSCALL(block)
 4bd:	b8 17 00 00 00       	mov    $0x17,%eax
 4c2:	cd 40                	int    $0x40
 4c4:	c3                   	ret    

000004c5 <unblock>:
SYSCALL(unblock)
 4c5:	b8 18 00 00 00       	mov    $0x18,%eax
 4ca:	cd 40                	int    $0x40
 4cc:	c3                   	ret    

000004cd <chmod>:
SYSCALL(chmod)
 4cd:	b8 19 00 00 00       	mov    $0x19,%eax
 4d2:	cd 40                	int    $0x40
 4d4:	c3                   	ret    

000004d5 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 4d5:	55                   	push   %ebp
 4d6:	89 e5                	mov    %esp,%ebp
 4d8:	83 ec 1c             	sub    $0x1c,%esp
 4db:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 4de:	6a 01                	push   $0x1
 4e0:	8d 55 f4             	lea    -0xc(%ebp),%edx
 4e3:	52                   	push   %edx
 4e4:	50                   	push   %eax
 4e5:	e8 4b ff ff ff       	call   435 <write>
}
 4ea:	83 c4 10             	add    $0x10,%esp
 4ed:	c9                   	leave  
 4ee:	c3                   	ret    

000004ef <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 4ef:	55                   	push   %ebp
 4f0:	89 e5                	mov    %esp,%ebp
 4f2:	57                   	push   %edi
 4f3:	56                   	push   %esi
 4f4:	53                   	push   %ebx
 4f5:	83 ec 2c             	sub    $0x2c,%esp
 4f8:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 4fb:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 4fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 501:	74 04                	je     507 <printint+0x18>
 503:	85 d2                	test   %edx,%edx
 505:	78 3c                	js     543 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 507:	89 d1                	mov    %edx,%ecx
  neg = 0;
 509:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 510:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 515:	89 c8                	mov    %ecx,%eax
 517:	ba 00 00 00 00       	mov    $0x0,%edx
 51c:	f7 f6                	div    %esi
 51e:	89 df                	mov    %ebx,%edi
 520:	43                   	inc    %ebx
 521:	8a 92 a8 08 00 00    	mov    0x8a8(%edx),%dl
 527:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 52b:	89 ca                	mov    %ecx,%edx
 52d:	89 c1                	mov    %eax,%ecx
 52f:	39 f2                	cmp    %esi,%edx
 531:	73 e2                	jae    515 <printint+0x26>
  if(neg)
 533:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 537:	74 24                	je     55d <printint+0x6e>
    buf[i++] = '-';
 539:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 53e:	8d 5f 02             	lea    0x2(%edi),%ebx
 541:	eb 1a                	jmp    55d <printint+0x6e>
    x = -xx;
 543:	89 d1                	mov    %edx,%ecx
 545:	f7 d9                	neg    %ecx
    neg = 1;
 547:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 54e:	eb c0                	jmp    510 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 550:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 555:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 558:	e8 78 ff ff ff       	call   4d5 <putc>
  while(--i >= 0)
 55d:	4b                   	dec    %ebx
 55e:	79 f0                	jns    550 <printint+0x61>
}
 560:	83 c4 2c             	add    $0x2c,%esp
 563:	5b                   	pop    %ebx
 564:	5e                   	pop    %esi
 565:	5f                   	pop    %edi
 566:	5d                   	pop    %ebp
 567:	c3                   	ret    

00000568 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 568:	55                   	push   %ebp
 569:	89 e5                	mov    %esp,%ebp
 56b:	57                   	push   %edi
 56c:	56                   	push   %esi
 56d:	53                   	push   %ebx
 56e:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 571:	8d 45 10             	lea    0x10(%ebp),%eax
 574:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 577:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 57c:	bb 00 00 00 00       	mov    $0x0,%ebx
 581:	eb 12                	jmp    595 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 583:	89 fa                	mov    %edi,%edx
 585:	8b 45 08             	mov    0x8(%ebp),%eax
 588:	e8 48 ff ff ff       	call   4d5 <putc>
 58d:	eb 05                	jmp    594 <printf+0x2c>
      }
    } else if(state == '%'){
 58f:	83 fe 25             	cmp    $0x25,%esi
 592:	74 22                	je     5b6 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 594:	43                   	inc    %ebx
 595:	8b 45 0c             	mov    0xc(%ebp),%eax
 598:	8a 04 18             	mov    (%eax,%ebx,1),%al
 59b:	84 c0                	test   %al,%al
 59d:	0f 84 1d 01 00 00    	je     6c0 <printf+0x158>
    c = fmt[i] & 0xff;
 5a3:	0f be f8             	movsbl %al,%edi
 5a6:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 5a9:	85 f6                	test   %esi,%esi
 5ab:	75 e2                	jne    58f <printf+0x27>
      if(c == '%'){
 5ad:	83 f8 25             	cmp    $0x25,%eax
 5b0:	75 d1                	jne    583 <printf+0x1b>
        state = '%';
 5b2:	89 c6                	mov    %eax,%esi
 5b4:	eb de                	jmp    594 <printf+0x2c>
      if(c == 'd'){
 5b6:	83 f8 25             	cmp    $0x25,%eax
 5b9:	0f 84 cc 00 00 00    	je     68b <printf+0x123>
 5bf:	0f 8c da 00 00 00    	jl     69f <printf+0x137>
 5c5:	83 f8 78             	cmp    $0x78,%eax
 5c8:	0f 8f d1 00 00 00    	jg     69f <printf+0x137>
 5ce:	83 f8 63             	cmp    $0x63,%eax
 5d1:	0f 8c c8 00 00 00    	jl     69f <printf+0x137>
 5d7:	83 e8 63             	sub    $0x63,%eax
 5da:	83 f8 15             	cmp    $0x15,%eax
 5dd:	0f 87 bc 00 00 00    	ja     69f <printf+0x137>
 5e3:	ff 24 85 50 08 00 00 	jmp    *0x850(,%eax,4)
        printint(fd, *ap, 10, 1);
 5ea:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5ed:	8b 17                	mov    (%edi),%edx
 5ef:	83 ec 0c             	sub    $0xc,%esp
 5f2:	6a 01                	push   $0x1
 5f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
 5f9:	8b 45 08             	mov    0x8(%ebp),%eax
 5fc:	e8 ee fe ff ff       	call   4ef <printint>
        ap++;
 601:	83 c7 04             	add    $0x4,%edi
 604:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 607:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 60a:	be 00 00 00 00       	mov    $0x0,%esi
 60f:	eb 83                	jmp    594 <printf+0x2c>
        printint(fd, *ap, 16, 0);
 611:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 614:	8b 17                	mov    (%edi),%edx
 616:	83 ec 0c             	sub    $0xc,%esp
 619:	6a 00                	push   $0x0
 61b:	b9 10 00 00 00       	mov    $0x10,%ecx
 620:	8b 45 08             	mov    0x8(%ebp),%eax
 623:	e8 c7 fe ff ff       	call   4ef <printint>
        ap++;
 628:	83 c7 04             	add    $0x4,%edi
 62b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 62e:	83 c4 10             	add    $0x10,%esp
      state = 0;
 631:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 636:	e9 59 ff ff ff       	jmp    594 <printf+0x2c>
        s = (char*)*ap;
 63b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 63e:	8b 30                	mov    (%eax),%esi
        ap++;
 640:	83 c0 04             	add    $0x4,%eax
 643:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 646:	85 f6                	test   %esi,%esi
 648:	75 13                	jne    65d <printf+0xf5>
          s = "(null)";
 64a:	be 46 08 00 00       	mov    $0x846,%esi
 64f:	eb 0c                	jmp    65d <printf+0xf5>
          putc(fd, *s);
 651:	0f be d2             	movsbl %dl,%edx
 654:	8b 45 08             	mov    0x8(%ebp),%eax
 657:	e8 79 fe ff ff       	call   4d5 <putc>
          s++;
 65c:	46                   	inc    %esi
        while(*s != 0){
 65d:	8a 16                	mov    (%esi),%dl
 65f:	84 d2                	test   %dl,%dl
 661:	75 ee                	jne    651 <printf+0xe9>
      state = 0;
 663:	be 00 00 00 00       	mov    $0x0,%esi
 668:	e9 27 ff ff ff       	jmp    594 <printf+0x2c>
        putc(fd, *ap);
 66d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 670:	0f be 17             	movsbl (%edi),%edx
 673:	8b 45 08             	mov    0x8(%ebp),%eax
 676:	e8 5a fe ff ff       	call   4d5 <putc>
        ap++;
 67b:	83 c7 04             	add    $0x4,%edi
 67e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 681:	be 00 00 00 00       	mov    $0x0,%esi
 686:	e9 09 ff ff ff       	jmp    594 <printf+0x2c>
        putc(fd, c);
 68b:	89 fa                	mov    %edi,%edx
 68d:	8b 45 08             	mov    0x8(%ebp),%eax
 690:	e8 40 fe ff ff       	call   4d5 <putc>
      state = 0;
 695:	be 00 00 00 00       	mov    $0x0,%esi
 69a:	e9 f5 fe ff ff       	jmp    594 <printf+0x2c>
        putc(fd, '%');
 69f:	ba 25 00 00 00       	mov    $0x25,%edx
 6a4:	8b 45 08             	mov    0x8(%ebp),%eax
 6a7:	e8 29 fe ff ff       	call   4d5 <putc>
        putc(fd, c);
 6ac:	89 fa                	mov    %edi,%edx
 6ae:	8b 45 08             	mov    0x8(%ebp),%eax
 6b1:	e8 1f fe ff ff       	call   4d5 <putc>
      state = 0;
 6b6:	be 00 00 00 00       	mov    $0x0,%esi
 6bb:	e9 d4 fe ff ff       	jmp    594 <printf+0x2c>
    }
  }
}
 6c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6c3:	5b                   	pop    %ebx
 6c4:	5e                   	pop    %esi
 6c5:	5f                   	pop    %edi
 6c6:	5d                   	pop    %ebp
 6c7:	c3                   	ret    

000006c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 6c8:	55                   	push   %ebp
 6c9:	89 e5                	mov    %esp,%ebp
 6cb:	57                   	push   %edi
 6cc:	56                   	push   %esi
 6cd:	53                   	push   %ebx
 6ce:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 6d1:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 6d4:	a1 c0 0c 00 00       	mov    0xcc0,%eax
 6d9:	eb 02                	jmp    6dd <free+0x15>
 6db:	89 d0                	mov    %edx,%eax
 6dd:	39 c8                	cmp    %ecx,%eax
 6df:	73 04                	jae    6e5 <free+0x1d>
 6e1:	3b 08                	cmp    (%eax),%ecx
 6e3:	72 12                	jb     6f7 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 6e5:	8b 10                	mov    (%eax),%edx
 6e7:	39 d0                	cmp    %edx,%eax
 6e9:	72 f0                	jb     6db <free+0x13>
 6eb:	39 c8                	cmp    %ecx,%eax
 6ed:	72 08                	jb     6f7 <free+0x2f>
 6ef:	39 d1                	cmp    %edx,%ecx
 6f1:	72 04                	jb     6f7 <free+0x2f>
 6f3:	89 d0                	mov    %edx,%eax
 6f5:	eb e6                	jmp    6dd <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 6f7:	8b 73 fc             	mov    -0x4(%ebx),%esi
 6fa:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 6fd:	8b 10                	mov    (%eax),%edx
 6ff:	39 d7                	cmp    %edx,%edi
 701:	74 19                	je     71c <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 703:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 706:	8b 50 04             	mov    0x4(%eax),%edx
 709:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 70c:	39 ce                	cmp    %ecx,%esi
 70e:	74 1b                	je     72b <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 710:	89 08                	mov    %ecx,(%eax)
  freep = p;
 712:	a3 c0 0c 00 00       	mov    %eax,0xcc0
}
 717:	5b                   	pop    %ebx
 718:	5e                   	pop    %esi
 719:	5f                   	pop    %edi
 71a:	5d                   	pop    %ebp
 71b:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 71c:	03 72 04             	add    0x4(%edx),%esi
 71f:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 722:	8b 10                	mov    (%eax),%edx
 724:	8b 12                	mov    (%edx),%edx
 726:	89 53 f8             	mov    %edx,-0x8(%ebx)
 729:	eb db                	jmp    706 <free+0x3e>
    p->s.size += bp->s.size;
 72b:	03 53 fc             	add    -0x4(%ebx),%edx
 72e:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 731:	8b 53 f8             	mov    -0x8(%ebx),%edx
 734:	89 10                	mov    %edx,(%eax)
 736:	eb da                	jmp    712 <free+0x4a>

00000738 <morecore>:

static Header*
morecore(uint nu)
{
 738:	55                   	push   %ebp
 739:	89 e5                	mov    %esp,%ebp
 73b:	53                   	push   %ebx
 73c:	83 ec 04             	sub    $0x4,%esp
 73f:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 741:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 746:	77 05                	ja     74d <morecore+0x15>
    nu = 4096;
 748:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 74d:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 754:	83 ec 0c             	sub    $0xc,%esp
 757:	50                   	push   %eax
 758:	e8 40 fd ff ff       	call   49d <sbrk>
  if(p == (char*)-1)
 75d:	83 c4 10             	add    $0x10,%esp
 760:	83 f8 ff             	cmp    $0xffffffff,%eax
 763:	74 1c                	je     781 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 765:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 768:	83 c0 08             	add    $0x8,%eax
 76b:	83 ec 0c             	sub    $0xc,%esp
 76e:	50                   	push   %eax
 76f:	e8 54 ff ff ff       	call   6c8 <free>
  return freep;
 774:	a1 c0 0c 00 00       	mov    0xcc0,%eax
 779:	83 c4 10             	add    $0x10,%esp
}
 77c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 77f:	c9                   	leave  
 780:	c3                   	ret    
    return 0;
 781:	b8 00 00 00 00       	mov    $0x0,%eax
 786:	eb f4                	jmp    77c <morecore+0x44>

00000788 <malloc>:

void*
malloc(uint nbytes)
{
 788:	55                   	push   %ebp
 789:	89 e5                	mov    %esp,%ebp
 78b:	53                   	push   %ebx
 78c:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 78f:	8b 45 08             	mov    0x8(%ebp),%eax
 792:	8d 58 07             	lea    0x7(%eax),%ebx
 795:	c1 eb 03             	shr    $0x3,%ebx
 798:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 799:	8b 0d c0 0c 00 00    	mov    0xcc0,%ecx
 79f:	85 c9                	test   %ecx,%ecx
 7a1:	74 04                	je     7a7 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7a3:	8b 01                	mov    (%ecx),%eax
 7a5:	eb 4a                	jmp    7f1 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 7a7:	c7 05 c0 0c 00 00 c4 	movl   $0xcc4,0xcc0
 7ae:	0c 00 00 
 7b1:	c7 05 c4 0c 00 00 c4 	movl   $0xcc4,0xcc4
 7b8:	0c 00 00 
    base.s.size = 0;
 7bb:	c7 05 c8 0c 00 00 00 	movl   $0x0,0xcc8
 7c2:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 7c5:	b9 c4 0c 00 00       	mov    $0xcc4,%ecx
 7ca:	eb d7                	jmp    7a3 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 7cc:	74 19                	je     7e7 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 7ce:	29 da                	sub    %ebx,%edx
 7d0:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 7d3:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 7d6:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 7d9:	89 0d c0 0c 00 00    	mov    %ecx,0xcc0
      return (void*)(p + 1);
 7df:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 7e2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 7e5:	c9                   	leave  
 7e6:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 7e7:	8b 10                	mov    (%eax),%edx
 7e9:	89 11                	mov    %edx,(%ecx)
 7eb:	eb ec                	jmp    7d9 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7ed:	89 c1                	mov    %eax,%ecx
 7ef:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 7f1:	8b 50 04             	mov    0x4(%eax),%edx
 7f4:	39 da                	cmp    %ebx,%edx
 7f6:	73 d4                	jae    7cc <malloc+0x44>
    if(p == freep)
 7f8:	39 05 c0 0c 00 00    	cmp    %eax,0xcc0
 7fe:	75 ed                	jne    7ed <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 800:	89 d8                	mov    %ebx,%eax
 802:	e8 31 ff ff ff       	call   738 <morecore>
 807:	85 c0                	test   %eax,%eax
 809:	75 e2                	jne    7ed <malloc+0x65>
 80b:	eb d5                	jmp    7e2 <malloc+0x5a>
