
_init:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
/////////////////////////////////////////////

char *argv[] = {"sh", 0};

int main(void)
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
  11:	83 ec 30             	sub    $0x30,%esp
    int pid, wpid;

    if (open("console", O_RDWR) < 0)
  14:	6a 02                	push   $0x2
  16:	68 74 07 00 00       	push   $0x774
  1b:	e8 9c 03 00 00       	call   3bc <open>
  20:	83 c4 10             	add    $0x10,%esp
  23:	85 c0                	test   %eax,%eax
  25:	78 39                	js     60 <main+0x60>
    {
        mknod("console", 1, 1);
        open("console", O_RDWR);
    }
    dup(0); // stdout
  27:	83 ec 0c             	sub    $0xc,%esp
  2a:	6a 00                	push   $0x0
  2c:	e8 c3 03 00 00       	call   3f4 <dup>
    dup(0); // stderr
  31:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  38:	e8 b7 03 00 00       	call   3f4 <dup>

    int attempts = 0;
    int max_username_size = 100;
    int max_password_size = 100;

    char username[] = USERNAME;
  3d:	c7 45 e3 79 61 73 68 	movl   $0x68736179,-0x1d(%ebp)
  44:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
    char password[] = PASSWORD;
  48:	c7 45 dc 62 61 6e 73 	movl   $0x736e6162,-0x24(%ebp)
  4f:	c7 45 df 73 61 6c 00 	movl   $0x6c6173,-0x21(%ebp)
    int username_size = sizeof(username);
    int password_size = sizeof(password);

    int logged_in = 0;

    while (attempts < 3)
  56:	83 c4 10             	add    $0x10,%esp
    int attempts = 0;
  59:	bb 00 00 00 00       	mov    $0x0,%ebx
    while (attempts < 3)
  5e:	eb 44                	jmp    a4 <main+0xa4>
        mknod("console", 1, 1);
  60:	83 ec 04             	sub    $0x4,%esp
  63:	6a 01                	push   $0x1
  65:	6a 01                	push   $0x1
  67:	68 74 07 00 00       	push   $0x774
  6c:	e8 53 03 00 00       	call   3c4 <mknod>
        open("console", O_RDWR);
  71:	83 c4 08             	add    $0x8,%esp
  74:	6a 02                	push   $0x2
  76:	68 74 07 00 00       	push   $0x774
  7b:	e8 3c 03 00 00       	call   3bc <open>
  80:	83 c4 10             	add    $0x10,%esp
  83:	eb a2                	jmp    27 <main+0x27>
        printf(1, "Enter Username: ");

        char username_array[max_username_size];
        int input_username_size = read(0, username_array, max_username_size);

        int is_correct_username = 1;
  85:	be 01 00 00 00       	mov    $0x1,%esi
        else
        {
            is_correct_username = 0;
        }

        if (!is_correct_username)
  8a:	85 f6                	test   %esi,%esi
  8c:	75 69                	jne    f7 <main+0xf7>
        {
            printf(1, "Incorrect username. Enter details again\n");
  8e:	83 ec 08             	sub    $0x8,%esp
  91:	68 f8 07 00 00       	push   $0x7f8
  96:	6a 01                	push   $0x1
  98:	e8 32 04 00 00       	call   4cf <printf>
            attempts++;
  9d:	43                   	inc    %ebx
            continue;
  9e:	83 c4 10             	add    $0x10,%esp
  a1:	8b 65 d4             	mov    -0x2c(%ebp),%esp
    while (attempts < 3)
  a4:	83 fb 02             	cmp    $0x2,%ebx
  a7:	0f 8f 00 01 00 00    	jg     1ad <main+0x1ad>
    {
  ad:	89 65 d4             	mov    %esp,-0x2c(%ebp)
        printf(1, "Enter Username: ");
  b0:	83 ec 08             	sub    $0x8,%esp
  b3:	68 7c 07 00 00       	push   $0x77c
  b8:	6a 01                	push   $0x1
  ba:	e8 10 04 00 00       	call   4cf <printf>
        char username_array[max_username_size];
  bf:	83 ec 60             	sub    $0x60,%esp
  c2:	89 e0                	mov    %esp,%eax
  c4:	89 e6                	mov    %esp,%esi
        int input_username_size = read(0, username_array, max_username_size);
  c6:	83 ec 04             	sub    $0x4,%esp
  c9:	6a 64                	push   $0x64
  cb:	50                   	push   %eax
  cc:	6a 00                	push   $0x0
  ce:	e8 c1 02 00 00       	call   394 <read>
        if (username_size == input_username_size)
  d3:	89 f4                	mov    %esi,%esp
  d5:	83 f8 05             	cmp    $0x5,%eax
  d8:	75 b4                	jne    8e <main+0x8e>
            for (int i = 0; i < username_size - 1; i++)
  da:	b8 00 00 00 00       	mov    $0x0,%eax
  df:	83 f8 03             	cmp    $0x3,%eax
  e2:	7f a1                	jg     85 <main+0x85>
                if (username[i] != username_array[i])
  e4:	8a 14 06             	mov    (%esi,%eax,1),%dl
  e7:	38 54 05 e3          	cmp    %dl,-0x1d(%ebp,%eax,1)
  eb:	75 03                	jne    f0 <main+0xf0>
            for (int i = 0; i < username_size - 1; i++)
  ed:	40                   	inc    %eax
  ee:	eb ef                	jmp    df <main+0xdf>
                    is_correct_username = 0;
  f0:	be 00 00 00 00       	mov    $0x0,%esi
  f5:	eb 93                	jmp    8a <main+0x8a>
        }

        printf(1, "Enter Password: ");
  f7:	83 ec 08             	sub    $0x8,%esp
  fa:	68 8d 07 00 00       	push   $0x78d
  ff:	6a 01                	push   $0x1
 101:	e8 c9 03 00 00       	call   4cf <printf>

        char password_array[max_password_size];
 106:	83 ec 60             	sub    $0x60,%esp
 109:	89 e0                	mov    %esp,%eax
 10b:	89 e7                	mov    %esp,%edi
        int input_password_size = read(0, password_array, max_password_size);
 10d:	83 ec 04             	sub    $0x4,%esp
 110:	6a 64                	push   $0x64
 112:	50                   	push   %eax
 113:	6a 00                	push   $0x0
 115:	e8 7a 02 00 00       	call   394 <read>

        int is_correct_password = 1;
        if (password_size == input_password_size)
 11a:	89 fc                	mov    %edi,%esp
 11c:	83 f8 07             	cmp    $0x7,%eax
 11f:	74 18                	je     139 <main+0x139>
            is_correct_password = 0;
        }

        if (!is_correct_password)
        {
            printf(1, "Incorrect Password. Enter details again\n");
 121:	83 ec 08             	sub    $0x8,%esp
 124:	68 24 08 00 00       	push   $0x824
 129:	6a 01                	push   $0x1
 12b:	e8 9f 03 00 00       	call   4cf <printf>
            attempts++;
 130:	43                   	inc    %ebx
            continue;
 131:	83 c4 10             	add    $0x10,%esp
 134:	e9 68 ff ff ff       	jmp    a1 <main+0xa1>
            for (int i = 0; i < password_size - 1; i++)
 139:	b8 00 00 00 00       	mov    $0x0,%eax
 13e:	83 f8 05             	cmp    $0x5,%eax
 141:	7f 11                	jg     154 <main+0x154>
                if (password[i] != password_array[i])
 143:	8a 0c 07             	mov    (%edi,%eax,1),%cl
 146:	38 4c 05 dc          	cmp    %cl,-0x24(%ebp,%eax,1)
 14a:	75 03                	jne    14f <main+0x14f>
            for (int i = 0; i < password_size - 1; i++)
 14c:	40                   	inc    %eax
 14d:	eb ef                	jmp    13e <main+0x13e>
                    is_correct_password = 0;
 14f:	be 00 00 00 00       	mov    $0x0,%esi
        if (!is_correct_password)
 154:	85 f6                	test   %esi,%esi
 156:	74 c9                	je     121 <main+0x121>
        }

        logged_in = 1;
        break;
 158:	8b 65 d4             	mov    -0x2c(%ebp),%esp
    }

    if (logged_in)
    {
        printf(1, "Login successful\n");
 15b:	83 ec 08             	sub    $0x8,%esp
 15e:	68 9e 07 00 00       	push   $0x79e
 163:	6a 01                	push   $0x1
 165:	e8 65 03 00 00       	call   4cf <printf>
 16a:	83 c4 10             	add    $0x10,%esp

    ////////////////////////////////////////////////////////////////////////////////////

    for (;;)
    {
        printf(1, "init: starting sh\n");
 16d:	83 ec 08             	sub    $0x8,%esp
 170:	68 b0 07 00 00       	push   $0x7b0
 175:	6a 01                	push   $0x1
 177:	e8 53 03 00 00       	call   4cf <printf>
        pid = fork();
 17c:	e8 f3 01 00 00       	call   374 <fork>
 181:	89 c3                	mov    %eax,%ebx
        if (pid < 0)
 183:	83 c4 10             	add    $0x10,%esp
 186:	85 c0                	test   %eax,%eax
 188:	78 37                	js     1c1 <main+0x1c1>
        {
            printf(1, "init: fork failed\n");
            exit();
        }
        if (pid == 0)
 18a:	74 49                	je     1d5 <main+0x1d5>
        {
            exec("sh", argv);
            printf(1, "init: exec sh failed\n");
            exit();
        }
        while ((wpid = wait()) >= 0 && wpid != pid)
 18c:	e8 f3 01 00 00       	call   384 <wait>
 191:	85 c0                	test   %eax,%eax
 193:	78 d8                	js     16d <main+0x16d>
 195:	39 c3                	cmp    %eax,%ebx
 197:	74 d4                	je     16d <main+0x16d>
            printf(1, "zombie!\n");
 199:	83 ec 08             	sub    $0x8,%esp
 19c:	68 ef 07 00 00       	push   $0x7ef
 1a1:	6a 01                	push   $0x1
 1a3:	e8 27 03 00 00       	call   4cf <printf>
 1a8:	83 c4 10             	add    $0x10,%esp
 1ab:	eb df                	jmp    18c <main+0x18c>
        printf(1, "Login unsuccessful. Out of valid attempts\n");
 1ad:	83 ec 08             	sub    $0x8,%esp
 1b0:	68 50 08 00 00       	push   $0x850
 1b5:	6a 01                	push   $0x1
 1b7:	e8 13 03 00 00       	call   4cf <printf>
        exit();
 1bc:	e8 bb 01 00 00       	call   37c <exit>
            printf(1, "init: fork failed\n");
 1c1:	83 ec 08             	sub    $0x8,%esp
 1c4:	68 c3 07 00 00       	push   $0x7c3
 1c9:	6a 01                	push   $0x1
 1cb:	e8 ff 02 00 00       	call   4cf <printf>
            exit();
 1d0:	e8 a7 01 00 00       	call   37c <exit>
            exec("sh", argv);
 1d5:	83 ec 08             	sub    $0x8,%esp
 1d8:	68 f0 08 00 00       	push   $0x8f0
 1dd:	68 d6 07 00 00       	push   $0x7d6
 1e2:	e8 cd 01 00 00       	call   3b4 <exec>
            printf(1, "init: exec sh failed\n");
 1e7:	83 c4 08             	add    $0x8,%esp
 1ea:	68 d9 07 00 00       	push   $0x7d9
 1ef:	6a 01                	push   $0x1
 1f1:	e8 d9 02 00 00       	call   4cf <printf>
            exit();
 1f6:	e8 81 01 00 00       	call   37c <exit>

000001fb <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 1fb:	55                   	push   %ebp
 1fc:	89 e5                	mov    %esp,%ebp
 1fe:	56                   	push   %esi
 1ff:	53                   	push   %ebx
 200:	8b 45 08             	mov    0x8(%ebp),%eax
 203:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 206:	89 c2                	mov    %eax,%edx
 208:	89 cb                	mov    %ecx,%ebx
 20a:	41                   	inc    %ecx
 20b:	89 d6                	mov    %edx,%esi
 20d:	42                   	inc    %edx
 20e:	8a 1b                	mov    (%ebx),%bl
 210:	88 1e                	mov    %bl,(%esi)
 212:	84 db                	test   %bl,%bl
 214:	75 f2                	jne    208 <strcpy+0xd>
    ;
  return os;
}
 216:	5b                   	pop    %ebx
 217:	5e                   	pop    %esi
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 21a:	55                   	push   %ebp
 21b:	89 e5                	mov    %esp,%ebp
 21d:	8b 4d 08             	mov    0x8(%ebp),%ecx
 220:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 223:	eb 02                	jmp    227 <strcmp+0xd>
    p++, q++;
 225:	41                   	inc    %ecx
 226:	42                   	inc    %edx
  while(*p && *p == *q)
 227:	8a 01                	mov    (%ecx),%al
 229:	84 c0                	test   %al,%al
 22b:	74 04                	je     231 <strcmp+0x17>
 22d:	3a 02                	cmp    (%edx),%al
 22f:	74 f4                	je     225 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
 231:	0f b6 c0             	movzbl %al,%eax
 234:	0f b6 12             	movzbl (%edx),%edx
 237:	29 d0                	sub    %edx,%eax
}
 239:	5d                   	pop    %ebp
 23a:	c3                   	ret    

0000023b <strlen>:

uint
strlen(const char *s)
{
 23b:	55                   	push   %ebp
 23c:	89 e5                	mov    %esp,%ebp
 23e:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 241:	b8 00 00 00 00       	mov    $0x0,%eax
 246:	eb 01                	jmp    249 <strlen+0xe>
 248:	40                   	inc    %eax
 249:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 24d:	75 f9                	jne    248 <strlen+0xd>
    ;
  return n;
}
 24f:	5d                   	pop    %ebp
 250:	c3                   	ret    

00000251 <memset>:

void*
memset(void *dst, int c, uint n)
{
 251:	55                   	push   %ebp
 252:	89 e5                	mov    %esp,%ebp
 254:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 255:	8b 7d 08             	mov    0x8(%ebp),%edi
 258:	8b 4d 10             	mov    0x10(%ebp),%ecx
 25b:	8b 45 0c             	mov    0xc(%ebp),%eax
 25e:	fc                   	cld    
 25f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 261:	8b 45 08             	mov    0x8(%ebp),%eax
 264:	8b 7d fc             	mov    -0x4(%ebp),%edi
 267:	c9                   	leave  
 268:	c3                   	ret    

00000269 <strchr>:

char*
strchr(const char *s, char c)
{
 269:	55                   	push   %ebp
 26a:	89 e5                	mov    %esp,%ebp
 26c:	8b 45 08             	mov    0x8(%ebp),%eax
 26f:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 272:	eb 01                	jmp    275 <strchr+0xc>
 274:	40                   	inc    %eax
 275:	8a 10                	mov    (%eax),%dl
 277:	84 d2                	test   %dl,%dl
 279:	74 06                	je     281 <strchr+0x18>
    if(*s == c)
 27b:	38 ca                	cmp    %cl,%dl
 27d:	75 f5                	jne    274 <strchr+0xb>
 27f:	eb 05                	jmp    286 <strchr+0x1d>
      return (char*)s;
  return 0;
 281:	b8 00 00 00 00       	mov    $0x0,%eax
}
 286:	5d                   	pop    %ebp
 287:	c3                   	ret    

00000288 <gets>:

char*
gets(char *buf, int max)
{
 288:	55                   	push   %ebp
 289:	89 e5                	mov    %esp,%ebp
 28b:	57                   	push   %edi
 28c:	56                   	push   %esi
 28d:	53                   	push   %ebx
 28e:	83 ec 1c             	sub    $0x1c,%esp
 291:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 294:	bb 00 00 00 00       	mov    $0x0,%ebx
 299:	89 de                	mov    %ebx,%esi
 29b:	43                   	inc    %ebx
 29c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 29f:	7d 2b                	jge    2cc <gets+0x44>
    cc = read(0, &c, 1);
 2a1:	83 ec 04             	sub    $0x4,%esp
 2a4:	6a 01                	push   $0x1
 2a6:	8d 45 e7             	lea    -0x19(%ebp),%eax
 2a9:	50                   	push   %eax
 2aa:	6a 00                	push   $0x0
 2ac:	e8 e3 00 00 00       	call   394 <read>
    if(cc < 1)
 2b1:	83 c4 10             	add    $0x10,%esp
 2b4:	85 c0                	test   %eax,%eax
 2b6:	7e 14                	jle    2cc <gets+0x44>
      break;
    buf[i++] = c;
 2b8:	8a 45 e7             	mov    -0x19(%ebp),%al
 2bb:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 2be:	3c 0a                	cmp    $0xa,%al
 2c0:	74 08                	je     2ca <gets+0x42>
 2c2:	3c 0d                	cmp    $0xd,%al
 2c4:	75 d3                	jne    299 <gets+0x11>
    buf[i++] = c;
 2c6:	89 de                	mov    %ebx,%esi
 2c8:	eb 02                	jmp    2cc <gets+0x44>
 2ca:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 2cc:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 2d0:	89 f8                	mov    %edi,%eax
 2d2:	8d 65 f4             	lea    -0xc(%ebp),%esp
 2d5:	5b                   	pop    %ebx
 2d6:	5e                   	pop    %esi
 2d7:	5f                   	pop    %edi
 2d8:	5d                   	pop    %ebp
 2d9:	c3                   	ret    

000002da <stat>:

int
stat(const char *n, struct stat *st)
{
 2da:	55                   	push   %ebp
 2db:	89 e5                	mov    %esp,%ebp
 2dd:	56                   	push   %esi
 2de:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2df:	83 ec 08             	sub    $0x8,%esp
 2e2:	6a 00                	push   $0x0
 2e4:	ff 75 08             	pushl  0x8(%ebp)
 2e7:	e8 d0 00 00 00       	call   3bc <open>
  if(fd < 0)
 2ec:	83 c4 10             	add    $0x10,%esp
 2ef:	85 c0                	test   %eax,%eax
 2f1:	78 24                	js     317 <stat+0x3d>
 2f3:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 2f5:	83 ec 08             	sub    $0x8,%esp
 2f8:	ff 75 0c             	pushl  0xc(%ebp)
 2fb:	50                   	push   %eax
 2fc:	e8 d3 00 00 00       	call   3d4 <fstat>
 301:	89 c6                	mov    %eax,%esi
  close(fd);
 303:	89 1c 24             	mov    %ebx,(%esp)
 306:	e8 99 00 00 00       	call   3a4 <close>
  return r;
 30b:	83 c4 10             	add    $0x10,%esp
}
 30e:	89 f0                	mov    %esi,%eax
 310:	8d 65 f8             	lea    -0x8(%ebp),%esp
 313:	5b                   	pop    %ebx
 314:	5e                   	pop    %esi
 315:	5d                   	pop    %ebp
 316:	c3                   	ret    
    return -1;
 317:	be ff ff ff ff       	mov    $0xffffffff,%esi
 31c:	eb f0                	jmp    30e <stat+0x34>

0000031e <atoi>:

int
atoi(const char *s)
{
 31e:	55                   	push   %ebp
 31f:	89 e5                	mov    %esp,%ebp
 321:	53                   	push   %ebx
 322:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 325:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 32a:	eb 0e                	jmp    33a <atoi+0x1c>
    n = n*10 + *s++ - '0';
 32c:	8d 14 92             	lea    (%edx,%edx,4),%edx
 32f:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 332:	41                   	inc    %ecx
 333:	0f be c0             	movsbl %al,%eax
 336:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
 33a:	8a 01                	mov    (%ecx),%al
 33c:	8d 58 d0             	lea    -0x30(%eax),%ebx
 33f:	80 fb 09             	cmp    $0x9,%bl
 342:	76 e8                	jbe    32c <atoi+0xe>
  return n;
}
 344:	89 d0                	mov    %edx,%eax
 346:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 349:	c9                   	leave  
 34a:	c3                   	ret    

0000034b <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 34b:	55                   	push   %ebp
 34c:	89 e5                	mov    %esp,%ebp
 34e:	56                   	push   %esi
 34f:	53                   	push   %ebx
 350:	8b 45 08             	mov    0x8(%ebp),%eax
 353:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 356:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 359:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 35b:	eb 0c                	jmp    369 <memmove+0x1e>
    *dst++ = *src++;
 35d:	8a 13                	mov    (%ebx),%dl
 35f:	88 11                	mov    %dl,(%ecx)
 361:	8d 5b 01             	lea    0x1(%ebx),%ebx
 364:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 367:	89 f2                	mov    %esi,%edx
 369:	8d 72 ff             	lea    -0x1(%edx),%esi
 36c:	85 d2                	test   %edx,%edx
 36e:	7f ed                	jg     35d <memmove+0x12>
  return vdst;
}
 370:	5b                   	pop    %ebx
 371:	5e                   	pop    %esi
 372:	5d                   	pop    %ebp
 373:	c3                   	ret    

00000374 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 374:	b8 01 00 00 00       	mov    $0x1,%eax
 379:	cd 40                	int    $0x40
 37b:	c3                   	ret    

0000037c <exit>:
SYSCALL(exit)
 37c:	b8 02 00 00 00       	mov    $0x2,%eax
 381:	cd 40                	int    $0x40
 383:	c3                   	ret    

00000384 <wait>:
SYSCALL(wait)
 384:	b8 03 00 00 00       	mov    $0x3,%eax
 389:	cd 40                	int    $0x40
 38b:	c3                   	ret    

0000038c <pipe>:
SYSCALL(pipe)
 38c:	b8 04 00 00 00       	mov    $0x4,%eax
 391:	cd 40                	int    $0x40
 393:	c3                   	ret    

00000394 <read>:
SYSCALL(read)
 394:	b8 05 00 00 00       	mov    $0x5,%eax
 399:	cd 40                	int    $0x40
 39b:	c3                   	ret    

0000039c <write>:
SYSCALL(write)
 39c:	b8 10 00 00 00       	mov    $0x10,%eax
 3a1:	cd 40                	int    $0x40
 3a3:	c3                   	ret    

000003a4 <close>:
SYSCALL(close)
 3a4:	b8 15 00 00 00       	mov    $0x15,%eax
 3a9:	cd 40                	int    $0x40
 3ab:	c3                   	ret    

000003ac <kill>:
SYSCALL(kill)
 3ac:	b8 06 00 00 00       	mov    $0x6,%eax
 3b1:	cd 40                	int    $0x40
 3b3:	c3                   	ret    

000003b4 <exec>:
SYSCALL(exec)
 3b4:	b8 07 00 00 00       	mov    $0x7,%eax
 3b9:	cd 40                	int    $0x40
 3bb:	c3                   	ret    

000003bc <open>:
SYSCALL(open)
 3bc:	b8 0f 00 00 00       	mov    $0xf,%eax
 3c1:	cd 40                	int    $0x40
 3c3:	c3                   	ret    

000003c4 <mknod>:
SYSCALL(mknod)
 3c4:	b8 11 00 00 00       	mov    $0x11,%eax
 3c9:	cd 40                	int    $0x40
 3cb:	c3                   	ret    

000003cc <unlink>:
SYSCALL(unlink)
 3cc:	b8 12 00 00 00       	mov    $0x12,%eax
 3d1:	cd 40                	int    $0x40
 3d3:	c3                   	ret    

000003d4 <fstat>:
SYSCALL(fstat)
 3d4:	b8 08 00 00 00       	mov    $0x8,%eax
 3d9:	cd 40                	int    $0x40
 3db:	c3                   	ret    

000003dc <link>:
SYSCALL(link)
 3dc:	b8 13 00 00 00       	mov    $0x13,%eax
 3e1:	cd 40                	int    $0x40
 3e3:	c3                   	ret    

000003e4 <mkdir>:
SYSCALL(mkdir)
 3e4:	b8 14 00 00 00       	mov    $0x14,%eax
 3e9:	cd 40                	int    $0x40
 3eb:	c3                   	ret    

000003ec <chdir>:
SYSCALL(chdir)
 3ec:	b8 09 00 00 00       	mov    $0x9,%eax
 3f1:	cd 40                	int    $0x40
 3f3:	c3                   	ret    

000003f4 <dup>:
SYSCALL(dup)
 3f4:	b8 0a 00 00 00       	mov    $0xa,%eax
 3f9:	cd 40                	int    $0x40
 3fb:	c3                   	ret    

000003fc <getpid>:
SYSCALL(getpid)
 3fc:	b8 0b 00 00 00       	mov    $0xb,%eax
 401:	cd 40                	int    $0x40
 403:	c3                   	ret    

00000404 <sbrk>:
SYSCALL(sbrk)
 404:	b8 0c 00 00 00       	mov    $0xc,%eax
 409:	cd 40                	int    $0x40
 40b:	c3                   	ret    

0000040c <sleep>:
SYSCALL(sleep)
 40c:	b8 0d 00 00 00       	mov    $0xd,%eax
 411:	cd 40                	int    $0x40
 413:	c3                   	ret    

00000414 <uptime>:
SYSCALL(uptime)
 414:	b8 0e 00 00 00       	mov    $0xe,%eax
 419:	cd 40                	int    $0x40
 41b:	c3                   	ret    

0000041c <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
 41c:	b8 16 00 00 00       	mov    $0x16,%eax
 421:	cd 40                	int    $0x40
 423:	c3                   	ret    

00000424 <block>:
SYSCALL(block)
 424:	b8 17 00 00 00       	mov    $0x17,%eax
 429:	cd 40                	int    $0x40
 42b:	c3                   	ret    

0000042c <unblock>:
SYSCALL(unblock)
 42c:	b8 18 00 00 00       	mov    $0x18,%eax
 431:	cd 40                	int    $0x40
 433:	c3                   	ret    

00000434 <chmod>:
SYSCALL(chmod)
 434:	b8 19 00 00 00       	mov    $0x19,%eax
 439:	cd 40                	int    $0x40
 43b:	c3                   	ret    

0000043c <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 43c:	55                   	push   %ebp
 43d:	89 e5                	mov    %esp,%ebp
 43f:	83 ec 1c             	sub    $0x1c,%esp
 442:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 445:	6a 01                	push   $0x1
 447:	8d 55 f4             	lea    -0xc(%ebp),%edx
 44a:	52                   	push   %edx
 44b:	50                   	push   %eax
 44c:	e8 4b ff ff ff       	call   39c <write>
}
 451:	83 c4 10             	add    $0x10,%esp
 454:	c9                   	leave  
 455:	c3                   	ret    

00000456 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 456:	55                   	push   %ebp
 457:	89 e5                	mov    %esp,%ebp
 459:	57                   	push   %edi
 45a:	56                   	push   %esi
 45b:	53                   	push   %ebx
 45c:	83 ec 2c             	sub    $0x2c,%esp
 45f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 462:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 464:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 468:	74 04                	je     46e <printint+0x18>
 46a:	85 d2                	test   %edx,%edx
 46c:	78 3c                	js     4aa <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
 46e:	89 d1                	mov    %edx,%ecx
  neg = 0;
 470:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
 477:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 47c:	89 c8                	mov    %ecx,%eax
 47e:	ba 00 00 00 00       	mov    $0x0,%edx
 483:	f7 f6                	div    %esi
 485:	89 df                	mov    %ebx,%edi
 487:	43                   	inc    %ebx
 488:	8a 92 dc 08 00 00    	mov    0x8dc(%edx),%dl
 48e:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 492:	89 ca                	mov    %ecx,%edx
 494:	89 c1                	mov    %eax,%ecx
 496:	39 f2                	cmp    %esi,%edx
 498:	73 e2                	jae    47c <printint+0x26>
  if(neg)
 49a:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 49e:	74 24                	je     4c4 <printint+0x6e>
    buf[i++] = '-';
 4a0:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 4a5:	8d 5f 02             	lea    0x2(%edi),%ebx
 4a8:	eb 1a                	jmp    4c4 <printint+0x6e>
    x = -xx;
 4aa:	89 d1                	mov    %edx,%ecx
 4ac:	f7 d9                	neg    %ecx
    neg = 1;
 4ae:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 4b5:	eb c0                	jmp    477 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
 4b7:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 4bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 4bf:	e8 78 ff ff ff       	call   43c <putc>
  while(--i >= 0)
 4c4:	4b                   	dec    %ebx
 4c5:	79 f0                	jns    4b7 <printint+0x61>
}
 4c7:	83 c4 2c             	add    $0x2c,%esp
 4ca:	5b                   	pop    %ebx
 4cb:	5e                   	pop    %esi
 4cc:	5f                   	pop    %edi
 4cd:	5d                   	pop    %ebp
 4ce:	c3                   	ret    

000004cf <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 4cf:	55                   	push   %ebp
 4d0:	89 e5                	mov    %esp,%ebp
 4d2:	57                   	push   %edi
 4d3:	56                   	push   %esi
 4d4:	53                   	push   %ebx
 4d5:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 4d8:	8d 45 10             	lea    0x10(%ebp),%eax
 4db:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 4de:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 4e3:	bb 00 00 00 00       	mov    $0x0,%ebx
 4e8:	eb 12                	jmp    4fc <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 4ea:	89 fa                	mov    %edi,%edx
 4ec:	8b 45 08             	mov    0x8(%ebp),%eax
 4ef:	e8 48 ff ff ff       	call   43c <putc>
 4f4:	eb 05                	jmp    4fb <printf+0x2c>
      }
    } else if(state == '%'){
 4f6:	83 fe 25             	cmp    $0x25,%esi
 4f9:	74 22                	je     51d <printf+0x4e>
  for(i = 0; fmt[i]; i++){
 4fb:	43                   	inc    %ebx
 4fc:	8b 45 0c             	mov    0xc(%ebp),%eax
 4ff:	8a 04 18             	mov    (%eax,%ebx,1),%al
 502:	84 c0                	test   %al,%al
 504:	0f 84 1d 01 00 00    	je     627 <printf+0x158>
    c = fmt[i] & 0xff;
 50a:	0f be f8             	movsbl %al,%edi
 50d:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 510:	85 f6                	test   %esi,%esi
 512:	75 e2                	jne    4f6 <printf+0x27>
      if(c == '%'){
 514:	83 f8 25             	cmp    $0x25,%eax
 517:	75 d1                	jne    4ea <printf+0x1b>
        state = '%';
 519:	89 c6                	mov    %eax,%esi
 51b:	eb de                	jmp    4fb <printf+0x2c>
      if(c == 'd'){
 51d:	83 f8 25             	cmp    $0x25,%eax
 520:	0f 84 cc 00 00 00    	je     5f2 <printf+0x123>
 526:	0f 8c da 00 00 00    	jl     606 <printf+0x137>
 52c:	83 f8 78             	cmp    $0x78,%eax
 52f:	0f 8f d1 00 00 00    	jg     606 <printf+0x137>
 535:	83 f8 63             	cmp    $0x63,%eax
 538:	0f 8c c8 00 00 00    	jl     606 <printf+0x137>
 53e:	83 e8 63             	sub    $0x63,%eax
 541:	83 f8 15             	cmp    $0x15,%eax
 544:	0f 87 bc 00 00 00    	ja     606 <printf+0x137>
 54a:	ff 24 85 84 08 00 00 	jmp    *0x884(,%eax,4)
        printint(fd, *ap, 10, 1);
 551:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 554:	8b 17                	mov    (%edi),%edx
 556:	83 ec 0c             	sub    $0xc,%esp
 559:	6a 01                	push   $0x1
 55b:	b9 0a 00 00 00       	mov    $0xa,%ecx
 560:	8b 45 08             	mov    0x8(%ebp),%eax
 563:	e8 ee fe ff ff       	call   456 <printint>
        ap++;
 568:	83 c7 04             	add    $0x4,%edi
 56b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 56e:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
 571:	be 00 00 00 00       	mov    $0x0,%esi
 576:	eb 83                	jmp    4fb <printf+0x2c>
        printint(fd, *ap, 16, 0);
 578:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 57b:	8b 17                	mov    (%edi),%edx
 57d:	83 ec 0c             	sub    $0xc,%esp
 580:	6a 00                	push   $0x0
 582:	b9 10 00 00 00       	mov    $0x10,%ecx
 587:	8b 45 08             	mov    0x8(%ebp),%eax
 58a:	e8 c7 fe ff ff       	call   456 <printint>
        ap++;
 58f:	83 c7 04             	add    $0x4,%edi
 592:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 595:	83 c4 10             	add    $0x10,%esp
      state = 0;
 598:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 59d:	e9 59 ff ff ff       	jmp    4fb <printf+0x2c>
        s = (char*)*ap;
 5a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 5a5:	8b 30                	mov    (%eax),%esi
        ap++;
 5a7:	83 c0 04             	add    $0x4,%eax
 5aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 5ad:	85 f6                	test   %esi,%esi
 5af:	75 13                	jne    5c4 <printf+0xf5>
          s = "(null)";
 5b1:	be 7b 08 00 00       	mov    $0x87b,%esi
 5b6:	eb 0c                	jmp    5c4 <printf+0xf5>
          putc(fd, *s);
 5b8:	0f be d2             	movsbl %dl,%edx
 5bb:	8b 45 08             	mov    0x8(%ebp),%eax
 5be:	e8 79 fe ff ff       	call   43c <putc>
          s++;
 5c3:	46                   	inc    %esi
        while(*s != 0){
 5c4:	8a 16                	mov    (%esi),%dl
 5c6:	84 d2                	test   %dl,%dl
 5c8:	75 ee                	jne    5b8 <printf+0xe9>
      state = 0;
 5ca:	be 00 00 00 00       	mov    $0x0,%esi
 5cf:	e9 27 ff ff ff       	jmp    4fb <printf+0x2c>
        putc(fd, *ap);
 5d4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5d7:	0f be 17             	movsbl (%edi),%edx
 5da:	8b 45 08             	mov    0x8(%ebp),%eax
 5dd:	e8 5a fe ff ff       	call   43c <putc>
        ap++;
 5e2:	83 c7 04             	add    $0x4,%edi
 5e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5e8:	be 00 00 00 00       	mov    $0x0,%esi
 5ed:	e9 09 ff ff ff       	jmp    4fb <printf+0x2c>
        putc(fd, c);
 5f2:	89 fa                	mov    %edi,%edx
 5f4:	8b 45 08             	mov    0x8(%ebp),%eax
 5f7:	e8 40 fe ff ff       	call   43c <putc>
      state = 0;
 5fc:	be 00 00 00 00       	mov    $0x0,%esi
 601:	e9 f5 fe ff ff       	jmp    4fb <printf+0x2c>
        putc(fd, '%');
 606:	ba 25 00 00 00       	mov    $0x25,%edx
 60b:	8b 45 08             	mov    0x8(%ebp),%eax
 60e:	e8 29 fe ff ff       	call   43c <putc>
        putc(fd, c);
 613:	89 fa                	mov    %edi,%edx
 615:	8b 45 08             	mov    0x8(%ebp),%eax
 618:	e8 1f fe ff ff       	call   43c <putc>
      state = 0;
 61d:	be 00 00 00 00       	mov    $0x0,%esi
 622:	e9 d4 fe ff ff       	jmp    4fb <printf+0x2c>
    }
  }
}
 627:	8d 65 f4             	lea    -0xc(%ebp),%esp
 62a:	5b                   	pop    %ebx
 62b:	5e                   	pop    %esi
 62c:	5f                   	pop    %edi
 62d:	5d                   	pop    %ebp
 62e:	c3                   	ret    

0000062f <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 62f:	55                   	push   %ebp
 630:	89 e5                	mov    %esp,%ebp
 632:	57                   	push   %edi
 633:	56                   	push   %esi
 634:	53                   	push   %ebx
 635:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 638:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 63b:	a1 f8 08 00 00       	mov    0x8f8,%eax
 640:	eb 02                	jmp    644 <free+0x15>
 642:	89 d0                	mov    %edx,%eax
 644:	39 c8                	cmp    %ecx,%eax
 646:	73 04                	jae    64c <free+0x1d>
 648:	3b 08                	cmp    (%eax),%ecx
 64a:	72 12                	jb     65e <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 64c:	8b 10                	mov    (%eax),%edx
 64e:	39 d0                	cmp    %edx,%eax
 650:	72 f0                	jb     642 <free+0x13>
 652:	39 c8                	cmp    %ecx,%eax
 654:	72 08                	jb     65e <free+0x2f>
 656:	39 d1                	cmp    %edx,%ecx
 658:	72 04                	jb     65e <free+0x2f>
 65a:	89 d0                	mov    %edx,%eax
 65c:	eb e6                	jmp    644 <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
 65e:	8b 73 fc             	mov    -0x4(%ebx),%esi
 661:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 664:	8b 10                	mov    (%eax),%edx
 666:	39 d7                	cmp    %edx,%edi
 668:	74 19                	je     683 <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 66a:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 66d:	8b 50 04             	mov    0x4(%eax),%edx
 670:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 673:	39 ce                	cmp    %ecx,%esi
 675:	74 1b                	je     692 <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 677:	89 08                	mov    %ecx,(%eax)
  freep = p;
 679:	a3 f8 08 00 00       	mov    %eax,0x8f8
}
 67e:	5b                   	pop    %ebx
 67f:	5e                   	pop    %esi
 680:	5f                   	pop    %edi
 681:	5d                   	pop    %ebp
 682:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 683:	03 72 04             	add    0x4(%edx),%esi
 686:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 689:	8b 10                	mov    (%eax),%edx
 68b:	8b 12                	mov    (%edx),%edx
 68d:	89 53 f8             	mov    %edx,-0x8(%ebx)
 690:	eb db                	jmp    66d <free+0x3e>
    p->s.size += bp->s.size;
 692:	03 53 fc             	add    -0x4(%ebx),%edx
 695:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 698:	8b 53 f8             	mov    -0x8(%ebx),%edx
 69b:	89 10                	mov    %edx,(%eax)
 69d:	eb da                	jmp    679 <free+0x4a>

0000069f <morecore>:

static Header*
morecore(uint nu)
{
 69f:	55                   	push   %ebp
 6a0:	89 e5                	mov    %esp,%ebp
 6a2:	53                   	push   %ebx
 6a3:	83 ec 04             	sub    $0x4,%esp
 6a6:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 6a8:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 6ad:	77 05                	ja     6b4 <morecore+0x15>
    nu = 4096;
 6af:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 6b4:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 6bb:	83 ec 0c             	sub    $0xc,%esp
 6be:	50                   	push   %eax
 6bf:	e8 40 fd ff ff       	call   404 <sbrk>
  if(p == (char*)-1)
 6c4:	83 c4 10             	add    $0x10,%esp
 6c7:	83 f8 ff             	cmp    $0xffffffff,%eax
 6ca:	74 1c                	je     6e8 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 6cc:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 6cf:	83 c0 08             	add    $0x8,%eax
 6d2:	83 ec 0c             	sub    $0xc,%esp
 6d5:	50                   	push   %eax
 6d6:	e8 54 ff ff ff       	call   62f <free>
  return freep;
 6db:	a1 f8 08 00 00       	mov    0x8f8,%eax
 6e0:	83 c4 10             	add    $0x10,%esp
}
 6e3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 6e6:	c9                   	leave  
 6e7:	c3                   	ret    
    return 0;
 6e8:	b8 00 00 00 00       	mov    $0x0,%eax
 6ed:	eb f4                	jmp    6e3 <morecore+0x44>

000006ef <malloc>:

void*
malloc(uint nbytes)
{
 6ef:	55                   	push   %ebp
 6f0:	89 e5                	mov    %esp,%ebp
 6f2:	53                   	push   %ebx
 6f3:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6f6:	8b 45 08             	mov    0x8(%ebp),%eax
 6f9:	8d 58 07             	lea    0x7(%eax),%ebx
 6fc:	c1 eb 03             	shr    $0x3,%ebx
 6ff:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 700:	8b 0d f8 08 00 00    	mov    0x8f8,%ecx
 706:	85 c9                	test   %ecx,%ecx
 708:	74 04                	je     70e <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70a:	8b 01                	mov    (%ecx),%eax
 70c:	eb 4a                	jmp    758 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
 70e:	c7 05 f8 08 00 00 fc 	movl   $0x8fc,0x8f8
 715:	08 00 00 
 718:	c7 05 fc 08 00 00 fc 	movl   $0x8fc,0x8fc
 71f:	08 00 00 
    base.s.size = 0;
 722:	c7 05 00 09 00 00 00 	movl   $0x0,0x900
 729:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 72c:	b9 fc 08 00 00       	mov    $0x8fc,%ecx
 731:	eb d7                	jmp    70a <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 733:	74 19                	je     74e <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 735:	29 da                	sub    %ebx,%edx
 737:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 73a:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 73d:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 740:	89 0d f8 08 00 00    	mov    %ecx,0x8f8
      return (void*)(p + 1);
 746:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 749:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 74c:	c9                   	leave  
 74d:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 74e:	8b 10                	mov    (%eax),%edx
 750:	89 11                	mov    %edx,(%ecx)
 752:	eb ec                	jmp    740 <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 754:	89 c1                	mov    %eax,%ecx
 756:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 758:	8b 50 04             	mov    0x4(%eax),%edx
 75b:	39 da                	cmp    %ebx,%edx
 75d:	73 d4                	jae    733 <malloc+0x44>
    if(p == freep)
 75f:	39 05 f8 08 00 00    	cmp    %eax,0x8f8
 765:	75 ed                	jne    754 <malloc+0x65>
      if((p = morecore(nunits)) == 0)
 767:	89 d8                	mov    %ebx,%eax
 769:	e8 31 ff ff ff       	call   69f <morecore>
 76e:	85 c0                	test   %eax,%eax
 770:	75 e2                	jne    754 <malloc+0x65>
 772:	eb d5                	jmp    749 <malloc+0x5a>
