
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <getcmd>:
    }
    exit();
}

int getcmd(char *buf, int nbuf)
{
       0:	55                   	push   %ebp
       1:	89 e5                	mov    %esp,%ebp
       3:	56                   	push   %esi
       4:	53                   	push   %ebx
       5:	8b 5d 08             	mov    0x8(%ebp),%ebx
       8:	8b 75 0c             	mov    0xc(%ebp),%esi
    printf(2, "$ ");
       b:	83 ec 08             	sub    $0x8,%esp
       e:	68 70 12 00 00       	push   $0x1270
      13:	6a 02                	push   $0x2
      15:	e8 b0 0f 00 00       	call   fca <printf>
    memset(buf, 0, nbuf);
      1a:	83 c4 0c             	add    $0xc,%esp
      1d:	56                   	push   %esi
      1e:	6a 00                	push   $0x0
      20:	53                   	push   %ebx
      21:	e8 26 0d 00 00       	call   d4c <memset>
    gets(buf, nbuf);
      26:	83 c4 08             	add    $0x8,%esp
      29:	56                   	push   %esi
      2a:	53                   	push   %ebx
      2b:	e8 53 0d 00 00       	call   d83 <gets>
    if (buf[0] == 0) // EOF
      30:	83 c4 10             	add    $0x10,%esp
      33:	80 3b 00             	cmpb   $0x0,(%ebx)
      36:	74 0c                	je     44 <getcmd+0x44>
        return -1;
    return 0;
      38:	b8 00 00 00 00       	mov    $0x0,%eax
}
      3d:	8d 65 f8             	lea    -0x8(%ebp),%esp
      40:	5b                   	pop    %ebx
      41:	5e                   	pop    %esi
      42:	5d                   	pop    %ebp
      43:	c3                   	ret    
        return -1;
      44:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      49:	eb f2                	jmp    3d <getcmd+0x3d>

0000004b <panic>:
    }
    exit();
}

void panic(char *s)
{
      4b:	55                   	push   %ebp
      4c:	89 e5                	mov    %esp,%ebp
      4e:	83 ec 0c             	sub    $0xc,%esp
    printf(2, "%s\n", s);
      51:	ff 75 08             	pushl  0x8(%ebp)
      54:	68 0d 13 00 00       	push   $0x130d
      59:	6a 02                	push   $0x2
      5b:	e8 6a 0f 00 00       	call   fca <printf>
    exit();
      60:	e8 12 0e 00 00       	call   e77 <exit>

00000065 <fork1>:
}

int fork1(void)
{
      65:	55                   	push   %ebp
      66:	89 e5                	mov    %esp,%ebp
      68:	83 ec 08             	sub    $0x8,%esp
    int pid;

    pid = fork();
      6b:	e8 ff 0d 00 00       	call   e6f <fork>
    if (pid == -1)
      70:	83 f8 ff             	cmp    $0xffffffff,%eax
      73:	74 02                	je     77 <fork1+0x12>
        panic("fork");
    return pid;
}
      75:	c9                   	leave  
      76:	c3                   	ret    
        panic("fork");
      77:	83 ec 0c             	sub    $0xc,%esp
      7a:	68 73 12 00 00       	push   $0x1273
      7f:	e8 c7 ff ff ff       	call   4b <panic>

00000084 <runcmd>:
{
      84:	55                   	push   %ebp
      85:	89 e5                	mov    %esp,%ebp
      87:	53                   	push   %ebx
      88:	83 ec 14             	sub    $0x14,%esp
      8b:	8b 5d 08             	mov    0x8(%ebp),%ebx
    if (cmd == 0)
      8e:	85 db                	test   %ebx,%ebx
      90:	74 0e                	je     a0 <runcmd+0x1c>
    switch (cmd->type)
      92:	8b 03                	mov    (%ebx),%eax
      94:	83 f8 05             	cmp    $0x5,%eax
      97:	77 0c                	ja     a5 <runcmd+0x21>
      99:	ff 24 85 38 13 00 00 	jmp    *0x1338(,%eax,4)
        exit();
      a0:	e8 d2 0d 00 00       	call   e77 <exit>
        panic("runcmd");
      a5:	83 ec 0c             	sub    $0xc,%esp
      a8:	68 78 12 00 00       	push   $0x1278
      ad:	e8 99 ff ff ff       	call   4b <panic>
        if (ecmd->argv[0] == 0)
      b2:	8b 43 04             	mov    0x4(%ebx),%eax
      b5:	85 c0                	test   %eax,%eax
      b7:	74 27                	je     e0 <runcmd+0x5c>
        exec(ecmd->argv[0], ecmd->argv);
      b9:	8d 53 04             	lea    0x4(%ebx),%edx
      bc:	83 ec 08             	sub    $0x8,%esp
      bf:	52                   	push   %edx
      c0:	50                   	push   %eax
      c1:	e8 e9 0d 00 00       	call   eaf <exec>
        printf(2, "exec %s failed\n", ecmd->argv[0]);
      c6:	83 c4 0c             	add    $0xc,%esp
      c9:	ff 73 04             	pushl  0x4(%ebx)
      cc:	68 7f 12 00 00       	push   $0x127f
      d1:	6a 02                	push   $0x2
      d3:	e8 f2 0e 00 00       	call   fca <printf>
        break;
      d8:	83 c4 10             	add    $0x10,%esp
    exit();
      db:	e8 97 0d 00 00       	call   e77 <exit>
            exit();
      e0:	e8 92 0d 00 00       	call   e77 <exit>
        close(rcmd->fd);
      e5:	83 ec 0c             	sub    $0xc,%esp
      e8:	ff 73 14             	pushl  0x14(%ebx)
      eb:	e8 af 0d 00 00       	call   e9f <close>
        if (open(rcmd->file, rcmd->mode) < 0)
      f0:	83 c4 08             	add    $0x8,%esp
      f3:	ff 73 10             	pushl  0x10(%ebx)
      f6:	ff 73 08             	pushl  0x8(%ebx)
      f9:	e8 b9 0d 00 00       	call   eb7 <open>
      fe:	83 c4 10             	add    $0x10,%esp
     101:	85 c0                	test   %eax,%eax
     103:	78 0b                	js     110 <runcmd+0x8c>
        runcmd(rcmd->cmd);
     105:	83 ec 0c             	sub    $0xc,%esp
     108:	ff 73 04             	pushl  0x4(%ebx)
     10b:	e8 74 ff ff ff       	call   84 <runcmd>
            printf(2, "open %s failed\n", rcmd->file);
     110:	83 ec 04             	sub    $0x4,%esp
     113:	ff 73 08             	pushl  0x8(%ebx)
     116:	68 8f 12 00 00       	push   $0x128f
     11b:	6a 02                	push   $0x2
     11d:	e8 a8 0e 00 00       	call   fca <printf>
            exit();
     122:	e8 50 0d 00 00       	call   e77 <exit>
        if (fork1() == 0)
     127:	e8 39 ff ff ff       	call   65 <fork1>
     12c:	85 c0                	test   %eax,%eax
     12e:	74 10                	je     140 <runcmd+0xbc>
        wait();
     130:	e8 4a 0d 00 00       	call   e7f <wait>
        runcmd(lcmd->right);
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	ff 73 08             	pushl  0x8(%ebx)
     13b:	e8 44 ff ff ff       	call   84 <runcmd>
            runcmd(lcmd->left);
     140:	83 ec 0c             	sub    $0xc,%esp
     143:	ff 73 04             	pushl  0x4(%ebx)
     146:	e8 39 ff ff ff       	call   84 <runcmd>
        if (pipe(p) < 0)
     14b:	83 ec 0c             	sub    $0xc,%esp
     14e:	8d 45 f0             	lea    -0x10(%ebp),%eax
     151:	50                   	push   %eax
     152:	e8 30 0d 00 00       	call   e87 <pipe>
     157:	83 c4 10             	add    $0x10,%esp
     15a:	85 c0                	test   %eax,%eax
     15c:	78 3a                	js     198 <runcmd+0x114>
        if (fork1() == 0)
     15e:	e8 02 ff ff ff       	call   65 <fork1>
     163:	85 c0                	test   %eax,%eax
     165:	74 3e                	je     1a5 <runcmd+0x121>
        if (fork1() == 0)
     167:	e8 f9 fe ff ff       	call   65 <fork1>
     16c:	85 c0                	test   %eax,%eax
     16e:	74 6b                	je     1db <runcmd+0x157>
        close(p[0]);
     170:	83 ec 0c             	sub    $0xc,%esp
     173:	ff 75 f0             	pushl  -0x10(%ebp)
     176:	e8 24 0d 00 00       	call   e9f <close>
        close(p[1]);
     17b:	83 c4 04             	add    $0x4,%esp
     17e:	ff 75 f4             	pushl  -0xc(%ebp)
     181:	e8 19 0d 00 00       	call   e9f <close>
        wait();
     186:	e8 f4 0c 00 00       	call   e7f <wait>
        wait();
     18b:	e8 ef 0c 00 00       	call   e7f <wait>
        break;
     190:	83 c4 10             	add    $0x10,%esp
     193:	e9 43 ff ff ff       	jmp    db <runcmd+0x57>
            panic("pipe");
     198:	83 ec 0c             	sub    $0xc,%esp
     19b:	68 9f 12 00 00       	push   $0x129f
     1a0:	e8 a6 fe ff ff       	call   4b <panic>
            close(1);
     1a5:	83 ec 0c             	sub    $0xc,%esp
     1a8:	6a 01                	push   $0x1
     1aa:	e8 f0 0c 00 00       	call   e9f <close>
            dup(p[1]);
     1af:	83 c4 04             	add    $0x4,%esp
     1b2:	ff 75 f4             	pushl  -0xc(%ebp)
     1b5:	e8 35 0d 00 00       	call   eef <dup>
            close(p[0]);
     1ba:	83 c4 04             	add    $0x4,%esp
     1bd:	ff 75 f0             	pushl  -0x10(%ebp)
     1c0:	e8 da 0c 00 00       	call   e9f <close>
            close(p[1]);
     1c5:	83 c4 04             	add    $0x4,%esp
     1c8:	ff 75 f4             	pushl  -0xc(%ebp)
     1cb:	e8 cf 0c 00 00       	call   e9f <close>
            runcmd(pcmd->left);
     1d0:	83 c4 04             	add    $0x4,%esp
     1d3:	ff 73 04             	pushl  0x4(%ebx)
     1d6:	e8 a9 fe ff ff       	call   84 <runcmd>
            close(0);
     1db:	83 ec 0c             	sub    $0xc,%esp
     1de:	6a 00                	push   $0x0
     1e0:	e8 ba 0c 00 00       	call   e9f <close>
            dup(p[0]);
     1e5:	83 c4 04             	add    $0x4,%esp
     1e8:	ff 75 f0             	pushl  -0x10(%ebp)
     1eb:	e8 ff 0c 00 00       	call   eef <dup>
            close(p[0]);
     1f0:	83 c4 04             	add    $0x4,%esp
     1f3:	ff 75 f0             	pushl  -0x10(%ebp)
     1f6:	e8 a4 0c 00 00       	call   e9f <close>
            close(p[1]);
     1fb:	83 c4 04             	add    $0x4,%esp
     1fe:	ff 75 f4             	pushl  -0xc(%ebp)
     201:	e8 99 0c 00 00       	call   e9f <close>
            runcmd(pcmd->right);
     206:	83 c4 04             	add    $0x4,%esp
     209:	ff 73 08             	pushl  0x8(%ebx)
     20c:	e8 73 fe ff ff       	call   84 <runcmd>
        if (fork1() == 0)
     211:	e8 4f fe ff ff       	call   65 <fork1>
     216:	85 c0                	test   %eax,%eax
     218:	0f 85 bd fe ff ff    	jne    db <runcmd+0x57>
            runcmd(bcmd->cmd);
     21e:	83 ec 0c             	sub    $0xc,%esp
     221:	ff 73 04             	pushl  0x4(%ebx)
     224:	e8 5b fe ff ff       	call   84 <runcmd>

00000229 <execcmd>:
// PAGEBREAK!
//  Constructors

struct cmd *
execcmd(void)
{
     229:	55                   	push   %ebp
     22a:	89 e5                	mov    %esp,%ebp
     22c:	53                   	push   %ebx
     22d:	83 ec 10             	sub    $0x10,%esp
    struct execcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     230:	6a 54                	push   $0x54
     232:	e8 b3 0f 00 00       	call   11ea <malloc>
     237:	89 c3                	mov    %eax,%ebx
    memset(cmd, 0, sizeof(*cmd));
     239:	83 c4 0c             	add    $0xc,%esp
     23c:	6a 54                	push   $0x54
     23e:	6a 00                	push   $0x0
     240:	50                   	push   %eax
     241:	e8 06 0b 00 00       	call   d4c <memset>
    cmd->type = EXEC;
     246:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
    return (struct cmd *)cmd;
}
     24c:	89 d8                	mov    %ebx,%eax
     24e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     251:	c9                   	leave  
     252:	c3                   	ret    

00000253 <redircmd>:

struct cmd *
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     253:	55                   	push   %ebp
     254:	89 e5                	mov    %esp,%ebp
     256:	53                   	push   %ebx
     257:	83 ec 10             	sub    $0x10,%esp
    struct redircmd *cmd;

    cmd = malloc(sizeof(*cmd));
     25a:	6a 18                	push   $0x18
     25c:	e8 89 0f 00 00       	call   11ea <malloc>
     261:	89 c3                	mov    %eax,%ebx
    memset(cmd, 0, sizeof(*cmd));
     263:	83 c4 0c             	add    $0xc,%esp
     266:	6a 18                	push   $0x18
     268:	6a 00                	push   $0x0
     26a:	50                   	push   %eax
     26b:	e8 dc 0a 00 00       	call   d4c <memset>
    cmd->type = REDIR;
     270:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
    cmd->cmd = subcmd;
     276:	8b 45 08             	mov    0x8(%ebp),%eax
     279:	89 43 04             	mov    %eax,0x4(%ebx)
    cmd->file = file;
     27c:	8b 45 0c             	mov    0xc(%ebp),%eax
     27f:	89 43 08             	mov    %eax,0x8(%ebx)
    cmd->efile = efile;
     282:	8b 45 10             	mov    0x10(%ebp),%eax
     285:	89 43 0c             	mov    %eax,0xc(%ebx)
    cmd->mode = mode;
     288:	8b 45 14             	mov    0x14(%ebp),%eax
     28b:	89 43 10             	mov    %eax,0x10(%ebx)
    cmd->fd = fd;
     28e:	8b 45 18             	mov    0x18(%ebp),%eax
     291:	89 43 14             	mov    %eax,0x14(%ebx)
    return (struct cmd *)cmd;
}
     294:	89 d8                	mov    %ebx,%eax
     296:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     299:	c9                   	leave  
     29a:	c3                   	ret    

0000029b <pipecmd>:

struct cmd *
pipecmd(struct cmd *left, struct cmd *right)
{
     29b:	55                   	push   %ebp
     29c:	89 e5                	mov    %esp,%ebp
     29e:	53                   	push   %ebx
     29f:	83 ec 10             	sub    $0x10,%esp
    struct pipecmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2a2:	6a 0c                	push   $0xc
     2a4:	e8 41 0f 00 00       	call   11ea <malloc>
     2a9:	89 c3                	mov    %eax,%ebx
    memset(cmd, 0, sizeof(*cmd));
     2ab:	83 c4 0c             	add    $0xc,%esp
     2ae:	6a 0c                	push   $0xc
     2b0:	6a 00                	push   $0x0
     2b2:	50                   	push   %eax
     2b3:	e8 94 0a 00 00       	call   d4c <memset>
    cmd->type = PIPE;
     2b8:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
    cmd->left = left;
     2be:	8b 45 08             	mov    0x8(%ebp),%eax
     2c1:	89 43 04             	mov    %eax,0x4(%ebx)
    cmd->right = right;
     2c4:	8b 45 0c             	mov    0xc(%ebp),%eax
     2c7:	89 43 08             	mov    %eax,0x8(%ebx)
    return (struct cmd *)cmd;
}
     2ca:	89 d8                	mov    %ebx,%eax
     2cc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     2cf:	c9                   	leave  
     2d0:	c3                   	ret    

000002d1 <listcmd>:

struct cmd *
listcmd(struct cmd *left, struct cmd *right)
{
     2d1:	55                   	push   %ebp
     2d2:	89 e5                	mov    %esp,%ebp
     2d4:	53                   	push   %ebx
     2d5:	83 ec 10             	sub    $0x10,%esp
    struct listcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     2d8:	6a 0c                	push   $0xc
     2da:	e8 0b 0f 00 00       	call   11ea <malloc>
     2df:	89 c3                	mov    %eax,%ebx
    memset(cmd, 0, sizeof(*cmd));
     2e1:	83 c4 0c             	add    $0xc,%esp
     2e4:	6a 0c                	push   $0xc
     2e6:	6a 00                	push   $0x0
     2e8:	50                   	push   %eax
     2e9:	e8 5e 0a 00 00       	call   d4c <memset>
    cmd->type = LIST;
     2ee:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
    cmd->left = left;
     2f4:	8b 45 08             	mov    0x8(%ebp),%eax
     2f7:	89 43 04             	mov    %eax,0x4(%ebx)
    cmd->right = right;
     2fa:	8b 45 0c             	mov    0xc(%ebp),%eax
     2fd:	89 43 08             	mov    %eax,0x8(%ebx)
    return (struct cmd *)cmd;
}
     300:	89 d8                	mov    %ebx,%eax
     302:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     305:	c9                   	leave  
     306:	c3                   	ret    

00000307 <backcmd>:

struct cmd *
backcmd(struct cmd *subcmd)
{
     307:	55                   	push   %ebp
     308:	89 e5                	mov    %esp,%ebp
     30a:	53                   	push   %ebx
     30b:	83 ec 10             	sub    $0x10,%esp
    struct backcmd *cmd;

    cmd = malloc(sizeof(*cmd));
     30e:	6a 08                	push   $0x8
     310:	e8 d5 0e 00 00       	call   11ea <malloc>
     315:	89 c3                	mov    %eax,%ebx
    memset(cmd, 0, sizeof(*cmd));
     317:	83 c4 0c             	add    $0xc,%esp
     31a:	6a 08                	push   $0x8
     31c:	6a 00                	push   $0x0
     31e:	50                   	push   %eax
     31f:	e8 28 0a 00 00       	call   d4c <memset>
    cmd->type = BACK;
     324:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
    cmd->cmd = subcmd;
     32a:	8b 45 08             	mov    0x8(%ebp),%eax
     32d:	89 43 04             	mov    %eax,0x4(%ebx)
    return (struct cmd *)cmd;
}
     330:	89 d8                	mov    %ebx,%eax
     332:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     335:	c9                   	leave  
     336:	c3                   	ret    

00000337 <gettoken>:

char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int gettoken(char **ps, char *es, char **q, char **eq)
{
     337:	55                   	push   %ebp
     338:	89 e5                	mov    %esp,%ebp
     33a:	57                   	push   %edi
     33b:	56                   	push   %esi
     33c:	53                   	push   %ebx
     33d:	83 ec 0c             	sub    $0xc,%esp
     340:	8b 75 0c             	mov    0xc(%ebp),%esi
     343:	8b 7d 10             	mov    0x10(%ebp),%edi
    char *s;
    int ret;

    s = *ps;
     346:	8b 45 08             	mov    0x8(%ebp),%eax
     349:	8b 18                	mov    (%eax),%ebx
    while (s < es && strchr(whitespace, *s))
     34b:	eb 01                	jmp    34e <gettoken+0x17>
        s++;
     34d:	43                   	inc    %ebx
    while (s < es && strchr(whitespace, *s))
     34e:	39 f3                	cmp    %esi,%ebx
     350:	73 18                	jae    36a <gettoken+0x33>
     352:	83 ec 08             	sub    $0x8,%esp
     355:	0f be 03             	movsbl (%ebx),%eax
     358:	50                   	push   %eax
     359:	68 e4 13 00 00       	push   $0x13e4
     35e:	e8 01 0a 00 00       	call   d64 <strchr>
     363:	83 c4 10             	add    $0x10,%esp
     366:	85 c0                	test   %eax,%eax
     368:	75 e3                	jne    34d <gettoken+0x16>
    if (q)
     36a:	85 ff                	test   %edi,%edi
     36c:	74 02                	je     370 <gettoken+0x39>
        *q = s;
     36e:	89 1f                	mov    %ebx,(%edi)
    ret = *s;
     370:	8a 03                	mov    (%ebx),%al
     372:	0f be f8             	movsbl %al,%edi
    switch (*s)
     375:	3c 3c                	cmp    $0x3c,%al
     377:	7f 25                	jg     39e <gettoken+0x67>
     379:	3c 3b                	cmp    $0x3b,%al
     37b:	7d 13                	jge    390 <gettoken+0x59>
     37d:	84 c0                	test   %al,%al
     37f:	74 10                	je     391 <gettoken+0x5a>
     381:	78 3d                	js     3c0 <gettoken+0x89>
     383:	3c 26                	cmp    $0x26,%al
     385:	74 09                	je     390 <gettoken+0x59>
     387:	7c 37                	jl     3c0 <gettoken+0x89>
     389:	83 e8 28             	sub    $0x28,%eax
     38c:	3c 01                	cmp    $0x1,%al
     38e:	77 30                	ja     3c0 <gettoken+0x89>
    case '(':
    case ')':
    case ';':
    case '&':
    case '<':
        s++;
     390:	43                   	inc    %ebx
        ret = 'a';
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
            s++;
        break;
    }
    if (eq)
     391:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
     395:	74 73                	je     40a <gettoken+0xd3>
        *eq = s;
     397:	8b 45 14             	mov    0x14(%ebp),%eax
     39a:	89 18                	mov    %ebx,(%eax)
     39c:	eb 6c                	jmp    40a <gettoken+0xd3>
    switch (*s)
     39e:	3c 3e                	cmp    $0x3e,%al
     3a0:	75 0d                	jne    3af <gettoken+0x78>
        s++;
     3a2:	8d 43 01             	lea    0x1(%ebx),%eax
        if (*s == '>')
     3a5:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
     3a9:	74 0a                	je     3b5 <gettoken+0x7e>
        s++;
     3ab:	89 c3                	mov    %eax,%ebx
     3ad:	eb e2                	jmp    391 <gettoken+0x5a>
    switch (*s)
     3af:	3c 7c                	cmp    $0x7c,%al
     3b1:	75 0d                	jne    3c0 <gettoken+0x89>
     3b3:	eb db                	jmp    390 <gettoken+0x59>
            s++;
     3b5:	83 c3 02             	add    $0x2,%ebx
            ret = '+';
     3b8:	bf 2b 00 00 00       	mov    $0x2b,%edi
     3bd:	eb d2                	jmp    391 <gettoken+0x5a>
            s++;
     3bf:	43                   	inc    %ebx
        while (s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     3c0:	39 f3                	cmp    %esi,%ebx
     3c2:	73 37                	jae    3fb <gettoken+0xc4>
     3c4:	83 ec 08             	sub    $0x8,%esp
     3c7:	0f be 03             	movsbl (%ebx),%eax
     3ca:	50                   	push   %eax
     3cb:	68 e4 13 00 00       	push   $0x13e4
     3d0:	e8 8f 09 00 00       	call   d64 <strchr>
     3d5:	83 c4 10             	add    $0x10,%esp
     3d8:	85 c0                	test   %eax,%eax
     3da:	75 26                	jne    402 <gettoken+0xcb>
     3dc:	83 ec 08             	sub    $0x8,%esp
     3df:	0f be 03             	movsbl (%ebx),%eax
     3e2:	50                   	push   %eax
     3e3:	68 dc 13 00 00       	push   $0x13dc
     3e8:	e8 77 09 00 00       	call   d64 <strchr>
     3ed:	83 c4 10             	add    $0x10,%esp
     3f0:	85 c0                	test   %eax,%eax
     3f2:	74 cb                	je     3bf <gettoken+0x88>
        ret = 'a';
     3f4:	bf 61 00 00 00       	mov    $0x61,%edi
     3f9:	eb 96                	jmp    391 <gettoken+0x5a>
     3fb:	bf 61 00 00 00       	mov    $0x61,%edi
     400:	eb 8f                	jmp    391 <gettoken+0x5a>
     402:	bf 61 00 00 00       	mov    $0x61,%edi
     407:	eb 88                	jmp    391 <gettoken+0x5a>

    while (s < es && strchr(whitespace, *s))
        s++;
     409:	43                   	inc    %ebx
    while (s < es && strchr(whitespace, *s))
     40a:	39 f3                	cmp    %esi,%ebx
     40c:	73 18                	jae    426 <gettoken+0xef>
     40e:	83 ec 08             	sub    $0x8,%esp
     411:	0f be 03             	movsbl (%ebx),%eax
     414:	50                   	push   %eax
     415:	68 e4 13 00 00       	push   $0x13e4
     41a:	e8 45 09 00 00       	call   d64 <strchr>
     41f:	83 c4 10             	add    $0x10,%esp
     422:	85 c0                	test   %eax,%eax
     424:	75 e3                	jne    409 <gettoken+0xd2>
    *ps = s;
     426:	8b 45 08             	mov    0x8(%ebp),%eax
     429:	89 18                	mov    %ebx,(%eax)
    return ret;
}
     42b:	89 f8                	mov    %edi,%eax
     42d:	8d 65 f4             	lea    -0xc(%ebp),%esp
     430:	5b                   	pop    %ebx
     431:	5e                   	pop    %esi
     432:	5f                   	pop    %edi
     433:	5d                   	pop    %ebp
     434:	c3                   	ret    

00000435 <peek>:

int peek(char **ps, char *es, char *toks)
{
     435:	55                   	push   %ebp
     436:	89 e5                	mov    %esp,%ebp
     438:	57                   	push   %edi
     439:	56                   	push   %esi
     43a:	53                   	push   %ebx
     43b:	83 ec 0c             	sub    $0xc,%esp
     43e:	8b 7d 08             	mov    0x8(%ebp),%edi
     441:	8b 75 0c             	mov    0xc(%ebp),%esi
    char *s;

    s = *ps;
     444:	8b 1f                	mov    (%edi),%ebx
    while (s < es && strchr(whitespace, *s))
     446:	eb 01                	jmp    449 <peek+0x14>
        s++;
     448:	43                   	inc    %ebx
    while (s < es && strchr(whitespace, *s))
     449:	39 f3                	cmp    %esi,%ebx
     44b:	73 18                	jae    465 <peek+0x30>
     44d:	83 ec 08             	sub    $0x8,%esp
     450:	0f be 03             	movsbl (%ebx),%eax
     453:	50                   	push   %eax
     454:	68 e4 13 00 00       	push   $0x13e4
     459:	e8 06 09 00 00       	call   d64 <strchr>
     45e:	83 c4 10             	add    $0x10,%esp
     461:	85 c0                	test   %eax,%eax
     463:	75 e3                	jne    448 <peek+0x13>
    *ps = s;
     465:	89 1f                	mov    %ebx,(%edi)
    return *s && strchr(toks, *s);
     467:	8a 03                	mov    (%ebx),%al
     469:	84 c0                	test   %al,%al
     46b:	75 0d                	jne    47a <peek+0x45>
     46d:	b8 00 00 00 00       	mov    $0x0,%eax
}
     472:	8d 65 f4             	lea    -0xc(%ebp),%esp
     475:	5b                   	pop    %ebx
     476:	5e                   	pop    %esi
     477:	5f                   	pop    %edi
     478:	5d                   	pop    %ebp
     479:	c3                   	ret    
    return *s && strchr(toks, *s);
     47a:	83 ec 08             	sub    $0x8,%esp
     47d:	0f be c0             	movsbl %al,%eax
     480:	50                   	push   %eax
     481:	ff 75 10             	pushl  0x10(%ebp)
     484:	e8 db 08 00 00       	call   d64 <strchr>
     489:	83 c4 10             	add    $0x10,%esp
     48c:	85 c0                	test   %eax,%eax
     48e:	74 07                	je     497 <peek+0x62>
     490:	b8 01 00 00 00       	mov    $0x1,%eax
     495:	eb db                	jmp    472 <peek+0x3d>
     497:	b8 00 00 00 00       	mov    $0x0,%eax
     49c:	eb d4                	jmp    472 <peek+0x3d>

0000049e <parseredirs>:
    return cmd;
}

struct cmd *
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     49e:	55                   	push   %ebp
     49f:	89 e5                	mov    %esp,%ebp
     4a1:	57                   	push   %edi
     4a2:	56                   	push   %esi
     4a3:	53                   	push   %ebx
     4a4:	83 ec 1c             	sub    $0x1c,%esp
     4a7:	8b 7d 0c             	mov    0xc(%ebp),%edi
     4aa:	8b 75 10             	mov    0x10(%ebp),%esi
    int tok;
    char *q, *eq;

    while (peek(ps, es, "<>"))
     4ad:	eb 28                	jmp    4d7 <parseredirs+0x39>
    {
        tok = gettoken(ps, es, 0, 0);
        if (gettoken(ps, es, &q, &eq) != 'a')
            panic("missing file for redirection");
     4af:	83 ec 0c             	sub    $0xc,%esp
     4b2:	68 a4 12 00 00       	push   $0x12a4
     4b7:	e8 8f fb ff ff       	call   4b <panic>
        switch (tok)
        {
        case '<':
            cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     4bc:	83 ec 0c             	sub    $0xc,%esp
     4bf:	6a 00                	push   $0x0
     4c1:	6a 00                	push   $0x0
     4c3:	ff 75 e0             	pushl  -0x20(%ebp)
     4c6:	ff 75 e4             	pushl  -0x1c(%ebp)
     4c9:	ff 75 08             	pushl  0x8(%ebp)
     4cc:	e8 82 fd ff ff       	call   253 <redircmd>
     4d1:	89 45 08             	mov    %eax,0x8(%ebp)
            break;
     4d4:	83 c4 20             	add    $0x20,%esp
    while (peek(ps, es, "<>"))
     4d7:	83 ec 04             	sub    $0x4,%esp
     4da:	68 c1 12 00 00       	push   $0x12c1
     4df:	56                   	push   %esi
     4e0:	57                   	push   %edi
     4e1:	e8 4f ff ff ff       	call   435 <peek>
     4e6:	83 c4 10             	add    $0x10,%esp
     4e9:	85 c0                	test   %eax,%eax
     4eb:	74 76                	je     563 <parseredirs+0xc5>
        tok = gettoken(ps, es, 0, 0);
     4ed:	6a 00                	push   $0x0
     4ef:	6a 00                	push   $0x0
     4f1:	56                   	push   %esi
     4f2:	57                   	push   %edi
     4f3:	e8 3f fe ff ff       	call   337 <gettoken>
     4f8:	89 c3                	mov    %eax,%ebx
        if (gettoken(ps, es, &q, &eq) != 'a')
     4fa:	8d 45 e0             	lea    -0x20(%ebp),%eax
     4fd:	50                   	push   %eax
     4fe:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     501:	50                   	push   %eax
     502:	56                   	push   %esi
     503:	57                   	push   %edi
     504:	e8 2e fe ff ff       	call   337 <gettoken>
     509:	83 c4 20             	add    $0x20,%esp
     50c:	83 f8 61             	cmp    $0x61,%eax
     50f:	75 9e                	jne    4af <parseredirs+0x11>
        switch (tok)
     511:	83 fb 3c             	cmp    $0x3c,%ebx
     514:	74 a6                	je     4bc <parseredirs+0x1e>
     516:	83 fb 3e             	cmp    $0x3e,%ebx
     519:	74 25                	je     540 <parseredirs+0xa2>
     51b:	83 fb 2b             	cmp    $0x2b,%ebx
     51e:	75 b7                	jne    4d7 <parseredirs+0x39>
        case '>':
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
            break;
        case '+': // >>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     520:	83 ec 0c             	sub    $0xc,%esp
     523:	6a 01                	push   $0x1
     525:	68 01 02 00 00       	push   $0x201
     52a:	ff 75 e0             	pushl  -0x20(%ebp)
     52d:	ff 75 e4             	pushl  -0x1c(%ebp)
     530:	ff 75 08             	pushl  0x8(%ebp)
     533:	e8 1b fd ff ff       	call   253 <redircmd>
     538:	89 45 08             	mov    %eax,0x8(%ebp)
            break;
     53b:	83 c4 20             	add    $0x20,%esp
     53e:	eb 97                	jmp    4d7 <parseredirs+0x39>
            cmd = redircmd(cmd, q, eq, O_WRONLY | O_CREATE, 1);
     540:	83 ec 0c             	sub    $0xc,%esp
     543:	6a 01                	push   $0x1
     545:	68 01 02 00 00       	push   $0x201
     54a:	ff 75 e0             	pushl  -0x20(%ebp)
     54d:	ff 75 e4             	pushl  -0x1c(%ebp)
     550:	ff 75 08             	pushl  0x8(%ebp)
     553:	e8 fb fc ff ff       	call   253 <redircmd>
     558:	89 45 08             	mov    %eax,0x8(%ebp)
            break;
     55b:	83 c4 20             	add    $0x20,%esp
     55e:	e9 74 ff ff ff       	jmp    4d7 <parseredirs+0x39>
        }
    }
    return cmd;
}
     563:	8b 45 08             	mov    0x8(%ebp),%eax
     566:	8d 65 f4             	lea    -0xc(%ebp),%esp
     569:	5b                   	pop    %ebx
     56a:	5e                   	pop    %esi
     56b:	5f                   	pop    %edi
     56c:	5d                   	pop    %ebp
     56d:	c3                   	ret    

0000056e <parseexec>:
    return cmd;
}

struct cmd *
parseexec(char **ps, char *es)
{
     56e:	55                   	push   %ebp
     56f:	89 e5                	mov    %esp,%ebp
     571:	57                   	push   %edi
     572:	56                   	push   %esi
     573:	53                   	push   %ebx
     574:	83 ec 30             	sub    $0x30,%esp
     577:	8b 75 08             	mov    0x8(%ebp),%esi
     57a:	8b 7d 0c             	mov    0xc(%ebp),%edi
    char *q, *eq;
    int tok, argc;
    struct execcmd *cmd;
    struct cmd *ret;

    if (peek(ps, es, "("))
     57d:	68 c4 12 00 00       	push   $0x12c4
     582:	57                   	push   %edi
     583:	56                   	push   %esi
     584:	e8 ac fe ff ff       	call   435 <peek>
     589:	83 c4 10             	add    $0x10,%esp
     58c:	85 c0                	test   %eax,%eax
     58e:	75 1d                	jne    5ad <parseexec+0x3f>
     590:	89 c3                	mov    %eax,%ebx
        return parseblock(ps, es);

    ret = execcmd();
     592:	e8 92 fc ff ff       	call   229 <execcmd>
     597:	89 45 d0             	mov    %eax,-0x30(%ebp)
    cmd = (struct execcmd *)ret;

    argc = 0;
    ret = parseredirs(ret, ps, es);
     59a:	83 ec 04             	sub    $0x4,%esp
     59d:	57                   	push   %edi
     59e:	56                   	push   %esi
     59f:	50                   	push   %eax
     5a0:	e8 f9 fe ff ff       	call   49e <parseredirs>
     5a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while (!peek(ps, es, "|)&;"))
     5a8:	83 c4 10             	add    $0x10,%esp
     5ab:	eb 3b                	jmp    5e8 <parseexec+0x7a>
        return parseblock(ps, es);
     5ad:	83 ec 08             	sub    $0x8,%esp
     5b0:	57                   	push   %edi
     5b1:	56                   	push   %esi
     5b2:	e8 8d 01 00 00       	call   744 <parseblock>
     5b7:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     5ba:	83 c4 10             	add    $0x10,%esp
        ret = parseredirs(ret, ps, es);
    }
    cmd->argv[argc] = 0;
    cmd->eargv[argc] = 0;
    return ret;
}
     5bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     5c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
     5c3:	5b                   	pop    %ebx
     5c4:	5e                   	pop    %esi
     5c5:	5f                   	pop    %edi
     5c6:	5d                   	pop    %ebp
     5c7:	c3                   	ret    
            panic("syntax");
     5c8:	83 ec 0c             	sub    $0xc,%esp
     5cb:	68 c6 12 00 00       	push   $0x12c6
     5d0:	e8 76 fa ff ff       	call   4b <panic>
        ret = parseredirs(ret, ps, es);
     5d5:	83 ec 04             	sub    $0x4,%esp
     5d8:	57                   	push   %edi
     5d9:	56                   	push   %esi
     5da:	ff 75 d4             	pushl  -0x2c(%ebp)
     5dd:	e8 bc fe ff ff       	call   49e <parseredirs>
     5e2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     5e5:	83 c4 10             	add    $0x10,%esp
    while (!peek(ps, es, "|)&;"))
     5e8:	83 ec 04             	sub    $0x4,%esp
     5eb:	68 db 12 00 00       	push   $0x12db
     5f0:	57                   	push   %edi
     5f1:	56                   	push   %esi
     5f2:	e8 3e fe ff ff       	call   435 <peek>
     5f7:	83 c4 10             	add    $0x10,%esp
     5fa:	85 c0                	test   %eax,%eax
     5fc:	75 3f                	jne    63d <parseexec+0xcf>
        if ((tok = gettoken(ps, es, &q, &eq)) == 0)
     5fe:	8d 45 e0             	lea    -0x20(%ebp),%eax
     601:	50                   	push   %eax
     602:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     605:	50                   	push   %eax
     606:	57                   	push   %edi
     607:	56                   	push   %esi
     608:	e8 2a fd ff ff       	call   337 <gettoken>
     60d:	83 c4 10             	add    $0x10,%esp
     610:	85 c0                	test   %eax,%eax
     612:	74 29                	je     63d <parseexec+0xcf>
        if (tok != 'a')
     614:	83 f8 61             	cmp    $0x61,%eax
     617:	75 af                	jne    5c8 <parseexec+0x5a>
        cmd->argv[argc] = q;
     619:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     61c:	8b 55 d0             	mov    -0x30(%ebp),%edx
     61f:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
        cmd->eargv[argc] = eq;
     623:	8b 45 e0             	mov    -0x20(%ebp),%eax
     626:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
        argc++;
     62a:	43                   	inc    %ebx
        if (argc >= MAXARGS)
     62b:	83 fb 09             	cmp    $0x9,%ebx
     62e:	7e a5                	jle    5d5 <parseexec+0x67>
            panic("too many args");
     630:	83 ec 0c             	sub    $0xc,%esp
     633:	68 cd 12 00 00       	push   $0x12cd
     638:	e8 0e fa ff ff       	call   4b <panic>
    cmd->argv[argc] = 0;
     63d:	8b 45 d0             	mov    -0x30(%ebp),%eax
     640:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     647:	00 
    cmd->eargv[argc] = 0;
     648:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     64f:	00 
    return ret;
     650:	e9 68 ff ff ff       	jmp    5bd <parseexec+0x4f>

00000655 <parsepipe>:
{
     655:	55                   	push   %ebp
     656:	89 e5                	mov    %esp,%ebp
     658:	57                   	push   %edi
     659:	56                   	push   %esi
     65a:	53                   	push   %ebx
     65b:	83 ec 14             	sub    $0x14,%esp
     65e:	8b 75 08             	mov    0x8(%ebp),%esi
     661:	8b 7d 0c             	mov    0xc(%ebp),%edi
    cmd = parseexec(ps, es);
     664:	57                   	push   %edi
     665:	56                   	push   %esi
     666:	e8 03 ff ff ff       	call   56e <parseexec>
     66b:	89 c3                	mov    %eax,%ebx
    if (peek(ps, es, "|"))
     66d:	83 c4 0c             	add    $0xc,%esp
     670:	68 e0 12 00 00       	push   $0x12e0
     675:	57                   	push   %edi
     676:	56                   	push   %esi
     677:	e8 b9 fd ff ff       	call   435 <peek>
     67c:	83 c4 10             	add    $0x10,%esp
     67f:	85 c0                	test   %eax,%eax
     681:	75 0a                	jne    68d <parsepipe+0x38>
}
     683:	89 d8                	mov    %ebx,%eax
     685:	8d 65 f4             	lea    -0xc(%ebp),%esp
     688:	5b                   	pop    %ebx
     689:	5e                   	pop    %esi
     68a:	5f                   	pop    %edi
     68b:	5d                   	pop    %ebp
     68c:	c3                   	ret    
        gettoken(ps, es, 0, 0);
     68d:	6a 00                	push   $0x0
     68f:	6a 00                	push   $0x0
     691:	57                   	push   %edi
     692:	56                   	push   %esi
     693:	e8 9f fc ff ff       	call   337 <gettoken>
        cmd = pipecmd(cmd, parsepipe(ps, es));
     698:	83 c4 08             	add    $0x8,%esp
     69b:	57                   	push   %edi
     69c:	56                   	push   %esi
     69d:	e8 b3 ff ff ff       	call   655 <parsepipe>
     6a2:	83 c4 08             	add    $0x8,%esp
     6a5:	50                   	push   %eax
     6a6:	53                   	push   %ebx
     6a7:	e8 ef fb ff ff       	call   29b <pipecmd>
     6ac:	89 c3                	mov    %eax,%ebx
     6ae:	83 c4 10             	add    $0x10,%esp
    return cmd;
     6b1:	eb d0                	jmp    683 <parsepipe+0x2e>

000006b3 <parseline>:
{
     6b3:	55                   	push   %ebp
     6b4:	89 e5                	mov    %esp,%ebp
     6b6:	57                   	push   %edi
     6b7:	56                   	push   %esi
     6b8:	53                   	push   %ebx
     6b9:	83 ec 14             	sub    $0x14,%esp
     6bc:	8b 75 08             	mov    0x8(%ebp),%esi
     6bf:	8b 7d 0c             	mov    0xc(%ebp),%edi
    cmd = parsepipe(ps, es);
     6c2:	57                   	push   %edi
     6c3:	56                   	push   %esi
     6c4:	e8 8c ff ff ff       	call   655 <parsepipe>
     6c9:	89 c3                	mov    %eax,%ebx
    while (peek(ps, es, "&"))
     6cb:	83 c4 10             	add    $0x10,%esp
     6ce:	eb 18                	jmp    6e8 <parseline+0x35>
        gettoken(ps, es, 0, 0);
     6d0:	6a 00                	push   $0x0
     6d2:	6a 00                	push   $0x0
     6d4:	57                   	push   %edi
     6d5:	56                   	push   %esi
     6d6:	e8 5c fc ff ff       	call   337 <gettoken>
        cmd = backcmd(cmd);
     6db:	89 1c 24             	mov    %ebx,(%esp)
     6de:	e8 24 fc ff ff       	call   307 <backcmd>
     6e3:	89 c3                	mov    %eax,%ebx
     6e5:	83 c4 10             	add    $0x10,%esp
    while (peek(ps, es, "&"))
     6e8:	83 ec 04             	sub    $0x4,%esp
     6eb:	68 e2 12 00 00       	push   $0x12e2
     6f0:	57                   	push   %edi
     6f1:	56                   	push   %esi
     6f2:	e8 3e fd ff ff       	call   435 <peek>
     6f7:	83 c4 10             	add    $0x10,%esp
     6fa:	85 c0                	test   %eax,%eax
     6fc:	75 d2                	jne    6d0 <parseline+0x1d>
    if (peek(ps, es, ";"))
     6fe:	83 ec 04             	sub    $0x4,%esp
     701:	68 de 12 00 00       	push   $0x12de
     706:	57                   	push   %edi
     707:	56                   	push   %esi
     708:	e8 28 fd ff ff       	call   435 <peek>
     70d:	83 c4 10             	add    $0x10,%esp
     710:	85 c0                	test   %eax,%eax
     712:	75 0a                	jne    71e <parseline+0x6b>
}
     714:	89 d8                	mov    %ebx,%eax
     716:	8d 65 f4             	lea    -0xc(%ebp),%esp
     719:	5b                   	pop    %ebx
     71a:	5e                   	pop    %esi
     71b:	5f                   	pop    %edi
     71c:	5d                   	pop    %ebp
     71d:	c3                   	ret    
        gettoken(ps, es, 0, 0);
     71e:	6a 00                	push   $0x0
     720:	6a 00                	push   $0x0
     722:	57                   	push   %edi
     723:	56                   	push   %esi
     724:	e8 0e fc ff ff       	call   337 <gettoken>
        cmd = listcmd(cmd, parseline(ps, es));
     729:	83 c4 08             	add    $0x8,%esp
     72c:	57                   	push   %edi
     72d:	56                   	push   %esi
     72e:	e8 80 ff ff ff       	call   6b3 <parseline>
     733:	83 c4 08             	add    $0x8,%esp
     736:	50                   	push   %eax
     737:	53                   	push   %ebx
     738:	e8 94 fb ff ff       	call   2d1 <listcmd>
     73d:	89 c3                	mov    %eax,%ebx
     73f:	83 c4 10             	add    $0x10,%esp
    return cmd;
     742:	eb d0                	jmp    714 <parseline+0x61>

00000744 <parseblock>:
{
     744:	55                   	push   %ebp
     745:	89 e5                	mov    %esp,%ebp
     747:	57                   	push   %edi
     748:	56                   	push   %esi
     749:	53                   	push   %ebx
     74a:	83 ec 10             	sub    $0x10,%esp
     74d:	8b 5d 08             	mov    0x8(%ebp),%ebx
     750:	8b 75 0c             	mov    0xc(%ebp),%esi
    if (!peek(ps, es, "("))
     753:	68 c4 12 00 00       	push   $0x12c4
     758:	56                   	push   %esi
     759:	53                   	push   %ebx
     75a:	e8 d6 fc ff ff       	call   435 <peek>
     75f:	83 c4 10             	add    $0x10,%esp
     762:	85 c0                	test   %eax,%eax
     764:	74 4b                	je     7b1 <parseblock+0x6d>
    gettoken(ps, es, 0, 0);
     766:	6a 00                	push   $0x0
     768:	6a 00                	push   $0x0
     76a:	56                   	push   %esi
     76b:	53                   	push   %ebx
     76c:	e8 c6 fb ff ff       	call   337 <gettoken>
    cmd = parseline(ps, es);
     771:	83 c4 08             	add    $0x8,%esp
     774:	56                   	push   %esi
     775:	53                   	push   %ebx
     776:	e8 38 ff ff ff       	call   6b3 <parseline>
     77b:	89 c7                	mov    %eax,%edi
    if (!peek(ps, es, ")"))
     77d:	83 c4 0c             	add    $0xc,%esp
     780:	68 00 13 00 00       	push   $0x1300
     785:	56                   	push   %esi
     786:	53                   	push   %ebx
     787:	e8 a9 fc ff ff       	call   435 <peek>
     78c:	83 c4 10             	add    $0x10,%esp
     78f:	85 c0                	test   %eax,%eax
     791:	74 2b                	je     7be <parseblock+0x7a>
    gettoken(ps, es, 0, 0);
     793:	6a 00                	push   $0x0
     795:	6a 00                	push   $0x0
     797:	56                   	push   %esi
     798:	53                   	push   %ebx
     799:	e8 99 fb ff ff       	call   337 <gettoken>
    cmd = parseredirs(cmd, ps, es);
     79e:	83 c4 0c             	add    $0xc,%esp
     7a1:	56                   	push   %esi
     7a2:	53                   	push   %ebx
     7a3:	57                   	push   %edi
     7a4:	e8 f5 fc ff ff       	call   49e <parseredirs>
}
     7a9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     7ac:	5b                   	pop    %ebx
     7ad:	5e                   	pop    %esi
     7ae:	5f                   	pop    %edi
     7af:	5d                   	pop    %ebp
     7b0:	c3                   	ret    
        panic("parseblock");
     7b1:	83 ec 0c             	sub    $0xc,%esp
     7b4:	68 e4 12 00 00       	push   $0x12e4
     7b9:	e8 8d f8 ff ff       	call   4b <panic>
        panic("syntax - missing )");
     7be:	83 ec 0c             	sub    $0xc,%esp
     7c1:	68 ef 12 00 00       	push   $0x12ef
     7c6:	e8 80 f8 ff ff       	call   4b <panic>

000007cb <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd *
nulterminate(struct cmd *cmd)
{
     7cb:	55                   	push   %ebp
     7cc:	89 e5                	mov    %esp,%ebp
     7ce:	53                   	push   %ebx
     7cf:	83 ec 04             	sub    $0x4,%esp
     7d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
    struct execcmd *ecmd;
    struct listcmd *lcmd;
    struct pipecmd *pcmd;
    struct redircmd *rcmd;

    if (cmd == 0)
     7d5:	85 db                	test   %ebx,%ebx
     7d7:	74 1d                	je     7f6 <nulterminate+0x2b>
        return 0;

    switch (cmd->type)
     7d9:	8b 03                	mov    (%ebx),%eax
     7db:	83 f8 05             	cmp    $0x5,%eax
     7de:	77 16                	ja     7f6 <nulterminate+0x2b>
     7e0:	ff 24 85 50 13 00 00 	jmp    *0x1350(,%eax,4)
    {
    case EXEC:
        ecmd = (struct execcmd *)cmd;
        for (i = 0; ecmd->argv[i]; i++)
            *ecmd->eargv[i] = 0;
     7e7:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
     7eb:	c6 02 00             	movb   $0x0,(%edx)
        for (i = 0; ecmd->argv[i]; i++)
     7ee:	40                   	inc    %eax
     7ef:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
     7f4:	75 f1                	jne    7e7 <nulterminate+0x1c>
        bcmd = (struct backcmd *)cmd;
        nulterminate(bcmd->cmd);
        break;
    }
    return cmd;
}
     7f6:	89 d8                	mov    %ebx,%eax
     7f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     7fb:	c9                   	leave  
     7fc:	c3                   	ret    
    switch (cmd->type)
     7fd:	b8 00 00 00 00       	mov    $0x0,%eax
     802:	eb eb                	jmp    7ef <nulterminate+0x24>
        nulterminate(rcmd->cmd);
     804:	83 ec 0c             	sub    $0xc,%esp
     807:	ff 73 04             	pushl  0x4(%ebx)
     80a:	e8 bc ff ff ff       	call   7cb <nulterminate>
        *rcmd->efile = 0;
     80f:	8b 43 0c             	mov    0xc(%ebx),%eax
     812:	c6 00 00             	movb   $0x0,(%eax)
        break;
     815:	83 c4 10             	add    $0x10,%esp
     818:	eb dc                	jmp    7f6 <nulterminate+0x2b>
        nulterminate(pcmd->left);
     81a:	83 ec 0c             	sub    $0xc,%esp
     81d:	ff 73 04             	pushl  0x4(%ebx)
     820:	e8 a6 ff ff ff       	call   7cb <nulterminate>
        nulterminate(pcmd->right);
     825:	83 c4 04             	add    $0x4,%esp
     828:	ff 73 08             	pushl  0x8(%ebx)
     82b:	e8 9b ff ff ff       	call   7cb <nulterminate>
        break;
     830:	83 c4 10             	add    $0x10,%esp
     833:	eb c1                	jmp    7f6 <nulterminate+0x2b>
        nulterminate(lcmd->left);
     835:	83 ec 0c             	sub    $0xc,%esp
     838:	ff 73 04             	pushl  0x4(%ebx)
     83b:	e8 8b ff ff ff       	call   7cb <nulterminate>
        nulterminate(lcmd->right);
     840:	83 c4 04             	add    $0x4,%esp
     843:	ff 73 08             	pushl  0x8(%ebx)
     846:	e8 80 ff ff ff       	call   7cb <nulterminate>
        break;
     84b:	83 c4 10             	add    $0x10,%esp
     84e:	eb a6                	jmp    7f6 <nulterminate+0x2b>
        nulterminate(bcmd->cmd);
     850:	83 ec 0c             	sub    $0xc,%esp
     853:	ff 73 04             	pushl  0x4(%ebx)
     856:	e8 70 ff ff ff       	call   7cb <nulterminate>
        break;
     85b:	83 c4 10             	add    $0x10,%esp
     85e:	eb 96                	jmp    7f6 <nulterminate+0x2b>

00000860 <parsecmd>:
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	56                   	push   %esi
     864:	53                   	push   %ebx
    es = s + strlen(s);
     865:	8b 5d 08             	mov    0x8(%ebp),%ebx
     868:	83 ec 0c             	sub    $0xc,%esp
     86b:	53                   	push   %ebx
     86c:	e8 c5 04 00 00       	call   d36 <strlen>
     871:	01 c3                	add    %eax,%ebx
    cmd = parseline(&s, es);
     873:	83 c4 08             	add    $0x8,%esp
     876:	53                   	push   %ebx
     877:	8d 45 08             	lea    0x8(%ebp),%eax
     87a:	50                   	push   %eax
     87b:	e8 33 fe ff ff       	call   6b3 <parseline>
     880:	89 c6                	mov    %eax,%esi
    peek(&s, es, "");
     882:	83 c4 0c             	add    $0xc,%esp
     885:	68 8e 12 00 00       	push   $0x128e
     88a:	53                   	push   %ebx
     88b:	8d 45 08             	lea    0x8(%ebp),%eax
     88e:	50                   	push   %eax
     88f:	e8 a1 fb ff ff       	call   435 <peek>
    if (s != es)
     894:	8b 45 08             	mov    0x8(%ebp),%eax
     897:	83 c4 10             	add    $0x10,%esp
     89a:	39 d8                	cmp    %ebx,%eax
     89c:	75 12                	jne    8b0 <parsecmd+0x50>
    nulterminate(cmd);
     89e:	83 ec 0c             	sub    $0xc,%esp
     8a1:	56                   	push   %esi
     8a2:	e8 24 ff ff ff       	call   7cb <nulterminate>
}
     8a7:	89 f0                	mov    %esi,%eax
     8a9:	8d 65 f8             	lea    -0x8(%ebp),%esp
     8ac:	5b                   	pop    %ebx
     8ad:	5e                   	pop    %esi
     8ae:	5d                   	pop    %ebp
     8af:	c3                   	ret    
        printf(2, "leftovers: %s\n", s);
     8b0:	83 ec 04             	sub    $0x4,%esp
     8b3:	50                   	push   %eax
     8b4:	68 02 13 00 00       	push   $0x1302
     8b9:	6a 02                	push   $0x2
     8bb:	e8 0a 07 00 00       	call   fca <printf>
        panic("syntax");
     8c0:	c7 04 24 c6 12 00 00 	movl   $0x12c6,(%esp)
     8c7:	e8 7f f7 ff ff       	call   4b <panic>

000008cc <main>:
{
     8cc:	8d 4c 24 04          	lea    0x4(%esp),%ecx
     8d0:	83 e4 f0             	and    $0xfffffff0,%esp
     8d3:	ff 71 fc             	pushl  -0x4(%ecx)
     8d6:	55                   	push   %ebp
     8d7:	89 e5                	mov    %esp,%ebp
     8d9:	53                   	push   %ebx
     8da:	51                   	push   %ecx
    while ((fd = open("console", O_RDWR)) >= 0)
     8db:	83 ec 08             	sub    $0x8,%esp
     8de:	6a 02                	push   $0x2
     8e0:	68 11 13 00 00       	push   $0x1311
     8e5:	e8 cd 05 00 00       	call   eb7 <open>
     8ea:	83 c4 10             	add    $0x10,%esp
     8ed:	85 c0                	test   %eax,%eax
     8ef:	0f 88 5c 03 00 00    	js     c51 <main+0x385>
        if (fd >= 3)
     8f5:	83 f8 02             	cmp    $0x2,%eax
     8f8:	7e e1                	jle    8db <main+0xf>
            close(fd);
     8fa:	83 ec 0c             	sub    $0xc,%esp
     8fd:	50                   	push   %eax
     8fe:	e8 9c 05 00 00       	call   e9f <close>
            break;
     903:	83 c4 10             	add    $0x10,%esp
     906:	e9 46 03 00 00       	jmp    c51 <main+0x385>
        if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     90b:	80 3d 01 14 00 00 64 	cmpb   $0x64,0x1401
     912:	0f 85 60 03 00 00    	jne    c78 <main+0x3ac>
     918:	80 3d 02 14 00 00 20 	cmpb   $0x20,0x1402
     91f:	0f 85 53 03 00 00    	jne    c78 <main+0x3ac>
            buf[strlen(buf) - 1] = 0; // chop \n
     925:	83 ec 0c             	sub    $0xc,%esp
     928:	68 00 14 00 00       	push   $0x1400
     92d:	e8 04 04 00 00       	call   d36 <strlen>
     932:	c6 80 ff 13 00 00 00 	movb   $0x0,0x13ff(%eax)
            if (chdir(buf + 3) < 0)
     939:	c7 04 24 03 14 00 00 	movl   $0x1403,(%esp)
     940:	e8 a2 05 00 00       	call   ee7 <chdir>
     945:	83 c4 10             	add    $0x10,%esp
     948:	85 c0                	test   %eax,%eax
     94a:	0f 89 01 03 00 00    	jns    c51 <main+0x385>
                printf(2, "cannot cd %s\n", buf + 3);
     950:	83 ec 04             	sub    $0x4,%esp
     953:	68 03 14 00 00       	push   $0x1403
     958:	68 19 13 00 00       	push   $0x1319
     95d:	6a 02                	push   $0x2
     95f:	e8 66 06 00 00       	call   fca <printf>
     964:	83 c4 10             	add    $0x10,%esp
            continue;
     967:	e9 e5 02 00 00       	jmp    c51 <main+0x385>
        if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y')
     96c:	80 3d 01 14 00 00 69 	cmpb   $0x69,0x1401
     973:	0f 85 07 03 00 00    	jne    c80 <main+0x3b4>
     979:	80 3d 02 14 00 00 73 	cmpb   $0x73,0x1402
     980:	0f 85 fa 02 00 00    	jne    c80 <main+0x3b4>
     986:	80 3d 03 14 00 00 74 	cmpb   $0x74,0x1403
     98d:	0f 85 ed 02 00 00    	jne    c80 <main+0x3b4>
     993:	80 3d 04 14 00 00 6f 	cmpb   $0x6f,0x1404
     99a:	0f 85 e0 02 00 00    	jne    c80 <main+0x3b4>
     9a0:	80 3d 05 14 00 00 72 	cmpb   $0x72,0x1405
     9a7:	0f 85 d3 02 00 00    	jne    c80 <main+0x3b4>
     9ad:	80 3d 06 14 00 00 79 	cmpb   $0x79,0x1406
     9b4:	0f 85 c6 02 00 00    	jne    c80 <main+0x3b4>
            gethistory();
     9ba:	e8 58 05 00 00       	call   f17 <gethistory>
            continue;
     9bf:	e9 8d 02 00 00       	jmp    c51 <main+0x385>
        else if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k')
     9c4:	80 3d 01 14 00 00 6c 	cmpb   $0x6c,0x1401
     9cb:	0f 85 b7 02 00 00    	jne    c88 <main+0x3bc>
     9d1:	80 3d 02 14 00 00 6f 	cmpb   $0x6f,0x1402
     9d8:	0f 85 aa 02 00 00    	jne    c88 <main+0x3bc>
     9de:	80 3d 03 14 00 00 63 	cmpb   $0x63,0x1403
     9e5:	0f 85 9d 02 00 00    	jne    c88 <main+0x3bc>
     9eb:	80 3d 04 14 00 00 6b 	cmpb   $0x6b,0x1404
     9f2:	0f 85 90 02 00 00    	jne    c88 <main+0x3bc>
            if (buf[5] == ' ')
     9f8:	80 3d 05 14 00 00 20 	cmpb   $0x20,0x1405
     9ff:	74 5f                	je     a60 <main+0x194>
                printf(1, "Invalid command\n");
     a01:	83 ec 08             	sub    $0x8,%esp
     a04:	68 27 13 00 00       	push   $0x1327
     a09:	6a 01                	push   $0x1
     a0b:	e8 ba 05 00 00       	call   fca <printf>
     a10:	83 c4 10             	add    $0x10,%esp
            continue;
     a13:	e9 39 02 00 00       	jmp    c51 <main+0x385>
                for (int buf_i = 6; buf_i < sizeof(buf); buf_i++)
     a18:	42                   	inc    %edx
     a19:	eb 4a                	jmp    a65 <main+0x199>
                            int block_no_identifier = (buf_char - '0');
     a1b:	0f be c0             	movsbl %al,%eax
     a1e:	83 e8 30             	sub    $0x30,%eax
                            block(block_no_identifier);
     a21:	83 ec 0c             	sub    $0xc,%esp
     a24:	50                   	push   %eax
     a25:	e8 f5 04 00 00       	call   f1f <block>
                            break;
     a2a:	83 c4 10             	add    $0x10,%esp
     a2d:	e9 1f 02 00 00       	jmp    c51 <main+0x385>
                            printf(1, "Invalid command\n");
     a32:	83 ec 08             	sub    $0x8,%esp
     a35:	68 27 13 00 00       	push   $0x1327
     a3a:	6a 01                	push   $0x1
     a3c:	e8 89 05 00 00       	call   fca <printf>
                            break;
     a41:	83 c4 10             	add    $0x10,%esp
     a44:	e9 08 02 00 00       	jmp    c51 <main+0x385>
                        printf(1, "Invalid command\n");
     a49:	83 ec 08             	sub    $0x8,%esp
     a4c:	68 27 13 00 00       	push   $0x1327
     a51:	6a 01                	push   $0x1
     a53:	e8 72 05 00 00       	call   fca <printf>
                        break;
     a58:	83 c4 10             	add    $0x10,%esp
     a5b:	e9 f1 01 00 00       	jmp    c51 <main+0x385>
                for (int buf_i = 6; buf_i < sizeof(buf); buf_i++)
     a60:	ba 06 00 00 00       	mov    $0x6,%edx
     a65:	83 fa 63             	cmp    $0x63,%edx
     a68:	0f 87 e3 01 00 00    	ja     c51 <main+0x385>
                    char buf_char = buf[buf_i];
     a6e:	8a 82 00 14 00 00    	mov    0x1400(%edx),%al
                    if (buf_char == ' ')
     a74:	3c 20                	cmp    $0x20,%al
     a76:	74 a0                	je     a18 <main+0x14c>
                    else if (buf_char - '0' >= 0 && buf_char - '9' <= 0)
     a78:	8d 48 d0             	lea    -0x30(%eax),%ecx
     a7b:	80 f9 09             	cmp    $0x9,%cl
     a7e:	77 c9                	ja     a49 <main+0x17d>
                        char buf_char_nxt = buf[buf_i + 1];
     a80:	8a 92 01 14 00 00    	mov    0x1401(%edx),%dl
                        if (buf_char_nxt == '\n' || buf_char_nxt == ' ' || buf_char_nxt == '\r')
     a86:	80 fa 0a             	cmp    $0xa,%dl
     a89:	74 90                	je     a1b <main+0x14f>
     a8b:	80 fa 20             	cmp    $0x20,%dl
     a8e:	74 8b                	je     a1b <main+0x14f>
     a90:	80 fa 0d             	cmp    $0xd,%dl
     a93:	74 86                	je     a1b <main+0x14f>
                        if (buf_char_nxt - '0' >= 0 && buf_char_nxt - '9' <= 0)
     a95:	8d 4a d0             	lea    -0x30(%edx),%ecx
     a98:	80 f9 09             	cmp    $0x9,%cl
     a9b:	77 95                	ja     a32 <main+0x166>
                            int block_no_identifier = (10 * (buf_char - '0')) + (buf_char_nxt - '0');
     a9d:	0f be c0             	movsbl %al,%eax
     aa0:	83 e8 30             	sub    $0x30,%eax
     aa3:	6b c0 0a             	imul   $0xa,%eax,%eax
     aa6:	0f be d2             	movsbl %dl,%edx
     aa9:	8d 44 10 d0          	lea    -0x30(%eax,%edx,1),%eax
                            block(block_no_identifier);
     aad:	83 ec 0c             	sub    $0xc,%esp
     ab0:	50                   	push   %eax
     ab1:	e8 69 04 00 00       	call   f1f <block>
                            break;
     ab6:	83 c4 10             	add    $0x10,%esp
     ab9:	e9 93 01 00 00       	jmp    c51 <main+0x385>
        else if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k')
     abe:	80 3d 01 14 00 00 6e 	cmpb   $0x6e,0x1401
     ac5:	0f 85 c5 01 00 00    	jne    c90 <main+0x3c4>
     acb:	80 3d 02 14 00 00 62 	cmpb   $0x62,0x1402
     ad2:	0f 85 b8 01 00 00    	jne    c90 <main+0x3c4>
     ad8:	80 3d 03 14 00 00 6c 	cmpb   $0x6c,0x1403
     adf:	0f 85 ab 01 00 00    	jne    c90 <main+0x3c4>
     ae5:	80 3d 04 14 00 00 6f 	cmpb   $0x6f,0x1404
     aec:	0f 85 9e 01 00 00    	jne    c90 <main+0x3c4>
     af2:	80 3d 05 14 00 00 63 	cmpb   $0x63,0x1405
     af9:	0f 85 91 01 00 00    	jne    c90 <main+0x3c4>
     aff:	80 3d 06 14 00 00 6b 	cmpb   $0x6b,0x1406
     b06:	0f 85 84 01 00 00    	jne    c90 <main+0x3c4>
            if (buf[7] == ' ')
     b0c:	80 3d 07 14 00 00 20 	cmpb   $0x20,0x1407
     b13:	74 5f                	je     b74 <main+0x2a8>
                printf(1, "Invalid command\n");
     b15:	83 ec 08             	sub    $0x8,%esp
     b18:	68 27 13 00 00       	push   $0x1327
     b1d:	6a 01                	push   $0x1
     b1f:	e8 a6 04 00 00       	call   fca <printf>
     b24:	83 c4 10             	add    $0x10,%esp
            continue;
     b27:	e9 25 01 00 00       	jmp    c51 <main+0x385>
                for (int buf_i = 8; buf_i < sizeof(buf); buf_i++)
     b2c:	42                   	inc    %edx
     b2d:	eb 4a                	jmp    b79 <main+0x2ad>
                            int block_no_identifier = (buf_char - '0');
     b2f:	0f be c0             	movsbl %al,%eax
     b32:	83 e8 30             	sub    $0x30,%eax
                            unblock(block_no_identifier);
     b35:	83 ec 0c             	sub    $0xc,%esp
     b38:	50                   	push   %eax
     b39:	e8 e9 03 00 00       	call   f27 <unblock>
                            break;
     b3e:	83 c4 10             	add    $0x10,%esp
     b41:	e9 0b 01 00 00       	jmp    c51 <main+0x385>
                            printf(1, "Invalid command\n");
     b46:	83 ec 08             	sub    $0x8,%esp
     b49:	68 27 13 00 00       	push   $0x1327
     b4e:	6a 01                	push   $0x1
     b50:	e8 75 04 00 00       	call   fca <printf>
                            break;
     b55:	83 c4 10             	add    $0x10,%esp
     b58:	e9 f4 00 00 00       	jmp    c51 <main+0x385>
                        printf(1, "Invalid command\n");
     b5d:	83 ec 08             	sub    $0x8,%esp
     b60:	68 27 13 00 00       	push   $0x1327
     b65:	6a 01                	push   $0x1
     b67:	e8 5e 04 00 00       	call   fca <printf>
                        break;
     b6c:	83 c4 10             	add    $0x10,%esp
     b6f:	e9 dd 00 00 00       	jmp    c51 <main+0x385>
                for (int buf_i = 8; buf_i < sizeof(buf); buf_i++)
     b74:	ba 08 00 00 00       	mov    $0x8,%edx
     b79:	83 fa 63             	cmp    $0x63,%edx
     b7c:	0f 87 cf 00 00 00    	ja     c51 <main+0x385>
                    char buf_char = buf[buf_i];
     b82:	8a 82 00 14 00 00    	mov    0x1400(%edx),%al
                    if (buf_char == ' ')
     b88:	3c 20                	cmp    $0x20,%al
     b8a:	74 a0                	je     b2c <main+0x260>
                    else if (buf_char - '0' >= 0 && buf_char - '9' <= 0)
     b8c:	8d 48 d0             	lea    -0x30(%eax),%ecx
     b8f:	80 f9 09             	cmp    $0x9,%cl
     b92:	77 c9                	ja     b5d <main+0x291>
                        char buf_char_nxt = buf[buf_i + 1];
     b94:	8a 92 01 14 00 00    	mov    0x1401(%edx),%dl
                        if (buf_char_nxt == '\n' || buf_char_nxt == ' ' || buf_char_nxt == '\n')
     b9a:	80 fa 0a             	cmp    $0xa,%dl
     b9d:	74 90                	je     b2f <main+0x263>
     b9f:	80 fa 20             	cmp    $0x20,%dl
     ba2:	74 8b                	je     b2f <main+0x263>
                        if (buf_char_nxt - '0' >= 0 && buf_char_nxt - '9' <= 0)
     ba4:	8d 4a d0             	lea    -0x30(%edx),%ecx
     ba7:	80 f9 09             	cmp    $0x9,%cl
     baa:	77 9a                	ja     b46 <main+0x27a>
                            int block_no_identifier = (10 * (buf_char - '0')) + (buf_char_nxt - '0');
     bac:	0f be c0             	movsbl %al,%eax
     baf:	83 e8 30             	sub    $0x30,%eax
     bb2:	6b c0 0a             	imul   $0xa,%eax,%eax
     bb5:	0f be d2             	movsbl %dl,%edx
     bb8:	8d 44 10 d0          	lea    -0x30(%eax,%edx,1),%eax
                            unblock(block_no_identifier);
     bbc:	83 ec 0c             	sub    $0xc,%esp
     bbf:	50                   	push   %eax
     bc0:	e8 62 03 00 00       	call   f27 <unblock>
                            break;
     bc5:	83 c4 10             	add    $0x10,%esp
     bc8:	e9 84 00 00 00       	jmp    c51 <main+0x385>
                char *filename = (char *)malloc(100 * sizeof(char));
     bcd:	83 ec 0c             	sub    $0xc,%esp
     bd0:	6a 64                	push   $0x64
     bd2:	e8 13 06 00 00       	call   11ea <malloc>
     bd7:	89 c3                	mov    %eax,%ebx
                for (int buf_i = 6; buf_i < sizeof(buf); buf_i++)
     bd9:	83 c4 10             	add    $0x10,%esp
     bdc:	b8 06 00 00 00       	mov    $0x6,%eax
                int f_i = 0;
     be1:	ba 00 00 00 00       	mov    $0x0,%edx
                for (int buf_i = 6; buf_i < sizeof(buf); buf_i++)
     be6:	83 f8 63             	cmp    $0x63,%eax
     be9:	77 12                	ja     bfd <main+0x331>
                    char buf_char = buf[buf_i];
     beb:	8a 88 00 14 00 00    	mov    0x1400(%eax),%cl
                    if (buf_char == ' ')
     bf1:	80 f9 20             	cmp    $0x20,%cl
     bf4:	74 07                	je     bfd <main+0x331>
                        filename[f_i] = buf_char;
     bf6:	88 0c 13             	mov    %cl,(%ebx,%edx,1)
                        f_i = f_i + 1;
     bf9:	42                   	inc    %edx
                for (int buf_i = 6; buf_i < sizeof(buf); buf_i++)
     bfa:	40                   	inc    %eax
     bfb:	eb e9                	jmp    be6 <main+0x31a>
                filename[f_i] = '\0';
     bfd:	c6 04 13 00          	movb   $0x0,(%ebx,%edx,1)
                int mode = buf[f_i + 7] - '0';
     c01:	0f be 82 07 14 00 00 	movsbl 0x1407(%edx),%eax
     c08:	83 e8 30             	sub    $0x30,%eax
                if (mode == 0 || mode == 1 || mode == 2)
     c0b:	83 f8 02             	cmp    $0x2,%eax
     c0e:	77 1b                	ja     c2b <main+0x35f>
                    chmod(filename, mode);
     c10:	83 ec 08             	sub    $0x8,%esp
     c13:	50                   	push   %eax
     c14:	53                   	push   %ebx
     c15:	e8 15 03 00 00       	call   f2f <chmod>
     c1a:	83 c4 10             	add    $0x10,%esp
                free(filename);
     c1d:	83 ec 0c             	sub    $0xc,%esp
     c20:	53                   	push   %ebx
     c21:	e8 04 05 00 00       	call   112a <free>
     c26:	83 c4 10             	add    $0x10,%esp
     c29:	eb 26                	jmp    c51 <main+0x385>
                    printf(1, "Invalid command\n");
     c2b:	83 ec 08             	sub    $0x8,%esp
     c2e:	68 27 13 00 00       	push   $0x1327
     c33:	6a 01                	push   $0x1
     c35:	e8 90 03 00 00       	call   fca <printf>
     c3a:	83 c4 10             	add    $0x10,%esp
     c3d:	eb de                	jmp    c1d <main+0x351>
            if (fork1() == 0)
     c3f:	e8 21 f4 ff ff       	call   65 <fork1>
     c44:	85 c0                	test   %eax,%eax
     c46:	0f 84 90 00 00 00    	je     cdc <main+0x410>
        wait();
     c4c:	e8 2e 02 00 00       	call   e7f <wait>
    while (getcmd(buf, sizeof(buf)) >= 0)
     c51:	83 ec 08             	sub    $0x8,%esp
     c54:	6a 64                	push   $0x64
     c56:	68 00 14 00 00       	push   $0x1400
     c5b:	e8 a0 f3 ff ff       	call   0 <getcmd>
     c60:	83 c4 10             	add    $0x10,%esp
     c63:	85 c0                	test   %eax,%eax
     c65:	0f 88 86 00 00 00    	js     cf1 <main+0x425>
        if (buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' ')
     c6b:	a0 00 14 00 00       	mov    0x1400,%al
     c70:	3c 63                	cmp    $0x63,%al
     c72:	0f 84 93 fc ff ff    	je     90b <main+0x3f>
        if (buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y')
     c78:	3c 68                	cmp    $0x68,%al
     c7a:	0f 84 ec fc ff ff    	je     96c <main+0xa0>
        else if (buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k')
     c80:	3c 62                	cmp    $0x62,%al
     c82:	0f 84 3c fd ff ff    	je     9c4 <main+0xf8>
        else if (buf[0] == 'u' && buf[1] == 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k')
     c88:	3c 75                	cmp    $0x75,%al
     c8a:	0f 84 2e fe ff ff    	je     abe <main+0x1f2>
        else if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd')
     c90:	3c 63                	cmp    $0x63,%al
     c92:	75 ab                	jne    c3f <main+0x373>
     c94:	80 3d 01 14 00 00 68 	cmpb   $0x68,0x1401
     c9b:	75 a2                	jne    c3f <main+0x373>
     c9d:	80 3d 02 14 00 00 6d 	cmpb   $0x6d,0x1402
     ca4:	75 99                	jne    c3f <main+0x373>
     ca6:	80 3d 03 14 00 00 6f 	cmpb   $0x6f,0x1403
     cad:	75 90                	jne    c3f <main+0x373>
     caf:	80 3d 04 14 00 00 64 	cmpb   $0x64,0x1404
     cb6:	75 87                	jne    c3f <main+0x373>
            if (buf[5] == ' ')
     cb8:	80 3d 05 14 00 00 20 	cmpb   $0x20,0x1405
     cbf:	0f 84 08 ff ff ff    	je     bcd <main+0x301>
                printf(1, "Invalid command\n");
     cc5:	83 ec 08             	sub    $0x8,%esp
     cc8:	68 27 13 00 00       	push   $0x1327
     ccd:	6a 01                	push   $0x1
     ccf:	e8 f6 02 00 00       	call   fca <printf>
     cd4:	83 c4 10             	add    $0x10,%esp
            continue;
     cd7:	e9 75 ff ff ff       	jmp    c51 <main+0x385>
                runcmd(parsecmd(buf));
     cdc:	83 ec 0c             	sub    $0xc,%esp
     cdf:	68 00 14 00 00       	push   $0x1400
     ce4:	e8 77 fb ff ff       	call   860 <parsecmd>
     ce9:	89 04 24             	mov    %eax,(%esp)
     cec:	e8 93 f3 ff ff       	call   84 <runcmd>
    exit();
     cf1:	e8 81 01 00 00       	call   e77 <exit>

00000cf6 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     cf6:	55                   	push   %ebp
     cf7:	89 e5                	mov    %esp,%ebp
     cf9:	56                   	push   %esi
     cfa:	53                   	push   %ebx
     cfb:	8b 45 08             	mov    0x8(%ebp),%eax
     cfe:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     d01:	89 c2                	mov    %eax,%edx
     d03:	89 cb                	mov    %ecx,%ebx
     d05:	41                   	inc    %ecx
     d06:	89 d6                	mov    %edx,%esi
     d08:	42                   	inc    %edx
     d09:	8a 1b                	mov    (%ebx),%bl
     d0b:	88 1e                	mov    %bl,(%esi)
     d0d:	84 db                	test   %bl,%bl
     d0f:	75 f2                	jne    d03 <strcpy+0xd>
    ;
  return os;
}
     d11:	5b                   	pop    %ebx
     d12:	5e                   	pop    %esi
     d13:	5d                   	pop    %ebp
     d14:	c3                   	ret    

00000d15 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d15:	55                   	push   %ebp
     d16:	89 e5                	mov    %esp,%ebp
     d18:	8b 4d 08             	mov    0x8(%ebp),%ecx
     d1b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
     d1e:	eb 02                	jmp    d22 <strcmp+0xd>
    p++, q++;
     d20:	41                   	inc    %ecx
     d21:	42                   	inc    %edx
  while(*p && *p == *q)
     d22:	8a 01                	mov    (%ecx),%al
     d24:	84 c0                	test   %al,%al
     d26:	74 04                	je     d2c <strcmp+0x17>
     d28:	3a 02                	cmp    (%edx),%al
     d2a:	74 f4                	je     d20 <strcmp+0xb>
  return (uchar)*p - (uchar)*q;
     d2c:	0f b6 c0             	movzbl %al,%eax
     d2f:	0f b6 12             	movzbl (%edx),%edx
     d32:	29 d0                	sub    %edx,%eax
}
     d34:	5d                   	pop    %ebp
     d35:	c3                   	ret    

00000d36 <strlen>:

uint
strlen(const char *s)
{
     d36:	55                   	push   %ebp
     d37:	89 e5                	mov    %esp,%ebp
     d39:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     d3c:	b8 00 00 00 00       	mov    $0x0,%eax
     d41:	eb 01                	jmp    d44 <strlen+0xe>
     d43:	40                   	inc    %eax
     d44:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     d48:	75 f9                	jne    d43 <strlen+0xd>
    ;
  return n;
}
     d4a:	5d                   	pop    %ebp
     d4b:	c3                   	ret    

00000d4c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d4c:	55                   	push   %ebp
     d4d:	89 e5                	mov    %esp,%ebp
     d4f:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     d50:	8b 7d 08             	mov    0x8(%ebp),%edi
     d53:	8b 4d 10             	mov    0x10(%ebp),%ecx
     d56:	8b 45 0c             	mov    0xc(%ebp),%eax
     d59:	fc                   	cld    
     d5a:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     d5c:	8b 45 08             	mov    0x8(%ebp),%eax
     d5f:	8b 7d fc             	mov    -0x4(%ebp),%edi
     d62:	c9                   	leave  
     d63:	c3                   	ret    

00000d64 <strchr>:

char*
strchr(const char *s, char c)
{
     d64:	55                   	push   %ebp
     d65:	89 e5                	mov    %esp,%ebp
     d67:	8b 45 08             	mov    0x8(%ebp),%eax
     d6a:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
     d6d:	eb 01                	jmp    d70 <strchr+0xc>
     d6f:	40                   	inc    %eax
     d70:	8a 10                	mov    (%eax),%dl
     d72:	84 d2                	test   %dl,%dl
     d74:	74 06                	je     d7c <strchr+0x18>
    if(*s == c)
     d76:	38 ca                	cmp    %cl,%dl
     d78:	75 f5                	jne    d6f <strchr+0xb>
     d7a:	eb 05                	jmp    d81 <strchr+0x1d>
      return (char*)s;
  return 0;
     d7c:	b8 00 00 00 00       	mov    $0x0,%eax
}
     d81:	5d                   	pop    %ebp
     d82:	c3                   	ret    

00000d83 <gets>:

char*
gets(char *buf, int max)
{
     d83:	55                   	push   %ebp
     d84:	89 e5                	mov    %esp,%ebp
     d86:	57                   	push   %edi
     d87:	56                   	push   %esi
     d88:	53                   	push   %ebx
     d89:	83 ec 1c             	sub    $0x1c,%esp
     d8c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     d8f:	bb 00 00 00 00       	mov    $0x0,%ebx
     d94:	89 de                	mov    %ebx,%esi
     d96:	43                   	inc    %ebx
     d97:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     d9a:	7d 2b                	jge    dc7 <gets+0x44>
    cc = read(0, &c, 1);
     d9c:	83 ec 04             	sub    $0x4,%esp
     d9f:	6a 01                	push   $0x1
     da1:	8d 45 e7             	lea    -0x19(%ebp),%eax
     da4:	50                   	push   %eax
     da5:	6a 00                	push   $0x0
     da7:	e8 e3 00 00 00       	call   e8f <read>
    if(cc < 1)
     dac:	83 c4 10             	add    $0x10,%esp
     daf:	85 c0                	test   %eax,%eax
     db1:	7e 14                	jle    dc7 <gets+0x44>
      break;
    buf[i++] = c;
     db3:	8a 45 e7             	mov    -0x19(%ebp),%al
     db6:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
     db9:	3c 0a                	cmp    $0xa,%al
     dbb:	74 08                	je     dc5 <gets+0x42>
     dbd:	3c 0d                	cmp    $0xd,%al
     dbf:	75 d3                	jne    d94 <gets+0x11>
    buf[i++] = c;
     dc1:	89 de                	mov    %ebx,%esi
     dc3:	eb 02                	jmp    dc7 <gets+0x44>
     dc5:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
     dc7:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
     dcb:	89 f8                	mov    %edi,%eax
     dcd:	8d 65 f4             	lea    -0xc(%ebp),%esp
     dd0:	5b                   	pop    %ebx
     dd1:	5e                   	pop    %esi
     dd2:	5f                   	pop    %edi
     dd3:	5d                   	pop    %ebp
     dd4:	c3                   	ret    

00000dd5 <stat>:

int
stat(const char *n, struct stat *st)
{
     dd5:	55                   	push   %ebp
     dd6:	89 e5                	mov    %esp,%ebp
     dd8:	56                   	push   %esi
     dd9:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     dda:	83 ec 08             	sub    $0x8,%esp
     ddd:	6a 00                	push   $0x0
     ddf:	ff 75 08             	pushl  0x8(%ebp)
     de2:	e8 d0 00 00 00       	call   eb7 <open>
  if(fd < 0)
     de7:	83 c4 10             	add    $0x10,%esp
     dea:	85 c0                	test   %eax,%eax
     dec:	78 24                	js     e12 <stat+0x3d>
     dee:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
     df0:	83 ec 08             	sub    $0x8,%esp
     df3:	ff 75 0c             	pushl  0xc(%ebp)
     df6:	50                   	push   %eax
     df7:	e8 d3 00 00 00       	call   ecf <fstat>
     dfc:	89 c6                	mov    %eax,%esi
  close(fd);
     dfe:	89 1c 24             	mov    %ebx,(%esp)
     e01:	e8 99 00 00 00       	call   e9f <close>
  return r;
     e06:	83 c4 10             	add    $0x10,%esp
}
     e09:	89 f0                	mov    %esi,%eax
     e0b:	8d 65 f8             	lea    -0x8(%ebp),%esp
     e0e:	5b                   	pop    %ebx
     e0f:	5e                   	pop    %esi
     e10:	5d                   	pop    %ebp
     e11:	c3                   	ret    
    return -1;
     e12:	be ff ff ff ff       	mov    $0xffffffff,%esi
     e17:	eb f0                	jmp    e09 <stat+0x34>

00000e19 <atoi>:

int
atoi(const char *s)
{
     e19:	55                   	push   %ebp
     e1a:	89 e5                	mov    %esp,%ebp
     e1c:	53                   	push   %ebx
     e1d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
     e20:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
     e25:	eb 0e                	jmp    e35 <atoi+0x1c>
    n = n*10 + *s++ - '0';
     e27:	8d 14 92             	lea    (%edx,%edx,4),%edx
     e2a:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
     e2d:	41                   	inc    %ecx
     e2e:	0f be c0             	movsbl %al,%eax
     e31:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
  while('0' <= *s && *s <= '9')
     e35:	8a 01                	mov    (%ecx),%al
     e37:	8d 58 d0             	lea    -0x30(%eax),%ebx
     e3a:	80 fb 09             	cmp    $0x9,%bl
     e3d:	76 e8                	jbe    e27 <atoi+0xe>
  return n;
}
     e3f:	89 d0                	mov    %edx,%eax
     e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e44:	c9                   	leave  
     e45:	c3                   	ret    

00000e46 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     e46:	55                   	push   %ebp
     e47:	89 e5                	mov    %esp,%ebp
     e49:	56                   	push   %esi
     e4a:	53                   	push   %ebx
     e4b:	8b 45 08             	mov    0x8(%ebp),%eax
     e4e:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     e51:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
     e54:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
     e56:	eb 0c                	jmp    e64 <memmove+0x1e>
    *dst++ = *src++;
     e58:	8a 13                	mov    (%ebx),%dl
     e5a:	88 11                	mov    %dl,(%ecx)
     e5c:	8d 5b 01             	lea    0x1(%ebx),%ebx
     e5f:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
     e62:	89 f2                	mov    %esi,%edx
     e64:	8d 72 ff             	lea    -0x1(%edx),%esi
     e67:	85 d2                	test   %edx,%edx
     e69:	7f ed                	jg     e58 <memmove+0x12>
  return vdst;
}
     e6b:	5b                   	pop    %ebx
     e6c:	5e                   	pop    %esi
     e6d:	5d                   	pop    %ebp
     e6e:	c3                   	ret    

00000e6f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
     e6f:	b8 01 00 00 00       	mov    $0x1,%eax
     e74:	cd 40                	int    $0x40
     e76:	c3                   	ret    

00000e77 <exit>:
SYSCALL(exit)
     e77:	b8 02 00 00 00       	mov    $0x2,%eax
     e7c:	cd 40                	int    $0x40
     e7e:	c3                   	ret    

00000e7f <wait>:
SYSCALL(wait)
     e7f:	b8 03 00 00 00       	mov    $0x3,%eax
     e84:	cd 40                	int    $0x40
     e86:	c3                   	ret    

00000e87 <pipe>:
SYSCALL(pipe)
     e87:	b8 04 00 00 00       	mov    $0x4,%eax
     e8c:	cd 40                	int    $0x40
     e8e:	c3                   	ret    

00000e8f <read>:
SYSCALL(read)
     e8f:	b8 05 00 00 00       	mov    $0x5,%eax
     e94:	cd 40                	int    $0x40
     e96:	c3                   	ret    

00000e97 <write>:
SYSCALL(write)
     e97:	b8 10 00 00 00       	mov    $0x10,%eax
     e9c:	cd 40                	int    $0x40
     e9e:	c3                   	ret    

00000e9f <close>:
SYSCALL(close)
     e9f:	b8 15 00 00 00       	mov    $0x15,%eax
     ea4:	cd 40                	int    $0x40
     ea6:	c3                   	ret    

00000ea7 <kill>:
SYSCALL(kill)
     ea7:	b8 06 00 00 00       	mov    $0x6,%eax
     eac:	cd 40                	int    $0x40
     eae:	c3                   	ret    

00000eaf <exec>:
SYSCALL(exec)
     eaf:	b8 07 00 00 00       	mov    $0x7,%eax
     eb4:	cd 40                	int    $0x40
     eb6:	c3                   	ret    

00000eb7 <open>:
SYSCALL(open)
     eb7:	b8 0f 00 00 00       	mov    $0xf,%eax
     ebc:	cd 40                	int    $0x40
     ebe:	c3                   	ret    

00000ebf <mknod>:
SYSCALL(mknod)
     ebf:	b8 11 00 00 00       	mov    $0x11,%eax
     ec4:	cd 40                	int    $0x40
     ec6:	c3                   	ret    

00000ec7 <unlink>:
SYSCALL(unlink)
     ec7:	b8 12 00 00 00       	mov    $0x12,%eax
     ecc:	cd 40                	int    $0x40
     ece:	c3                   	ret    

00000ecf <fstat>:
SYSCALL(fstat)
     ecf:	b8 08 00 00 00       	mov    $0x8,%eax
     ed4:	cd 40                	int    $0x40
     ed6:	c3                   	ret    

00000ed7 <link>:
SYSCALL(link)
     ed7:	b8 13 00 00 00       	mov    $0x13,%eax
     edc:	cd 40                	int    $0x40
     ede:	c3                   	ret    

00000edf <mkdir>:
SYSCALL(mkdir)
     edf:	b8 14 00 00 00       	mov    $0x14,%eax
     ee4:	cd 40                	int    $0x40
     ee6:	c3                   	ret    

00000ee7 <chdir>:
SYSCALL(chdir)
     ee7:	b8 09 00 00 00       	mov    $0x9,%eax
     eec:	cd 40                	int    $0x40
     eee:	c3                   	ret    

00000eef <dup>:
SYSCALL(dup)
     eef:	b8 0a 00 00 00       	mov    $0xa,%eax
     ef4:	cd 40                	int    $0x40
     ef6:	c3                   	ret    

00000ef7 <getpid>:
SYSCALL(getpid)
     ef7:	b8 0b 00 00 00       	mov    $0xb,%eax
     efc:	cd 40                	int    $0x40
     efe:	c3                   	ret    

00000eff <sbrk>:
SYSCALL(sbrk)
     eff:	b8 0c 00 00 00       	mov    $0xc,%eax
     f04:	cd 40                	int    $0x40
     f06:	c3                   	ret    

00000f07 <sleep>:
SYSCALL(sleep)
     f07:	b8 0d 00 00 00       	mov    $0xd,%eax
     f0c:	cd 40                	int    $0x40
     f0e:	c3                   	ret    

00000f0f <uptime>:
SYSCALL(uptime)
     f0f:	b8 0e 00 00 00       	mov    $0xe,%eax
     f14:	cd 40                	int    $0x40
     f16:	c3                   	ret    

00000f17 <gethistory>:


# Defining assembly code for user calls
######################################################################################################
SYSCALL(gethistory)
     f17:	b8 16 00 00 00       	mov    $0x16,%eax
     f1c:	cd 40                	int    $0x40
     f1e:	c3                   	ret    

00000f1f <block>:
SYSCALL(block)
     f1f:	b8 17 00 00 00       	mov    $0x17,%eax
     f24:	cd 40                	int    $0x40
     f26:	c3                   	ret    

00000f27 <unblock>:
SYSCALL(unblock)
     f27:	b8 18 00 00 00       	mov    $0x18,%eax
     f2c:	cd 40                	int    $0x40
     f2e:	c3                   	ret    

00000f2f <chmod>:
SYSCALL(chmod)
     f2f:	b8 19 00 00 00       	mov    $0x19,%eax
     f34:	cd 40                	int    $0x40
     f36:	c3                   	ret    

00000f37 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
     f37:	55                   	push   %ebp
     f38:	89 e5                	mov    %esp,%ebp
     f3a:	83 ec 1c             	sub    $0x1c,%esp
     f3d:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
     f40:	6a 01                	push   $0x1
     f42:	8d 55 f4             	lea    -0xc(%ebp),%edx
     f45:	52                   	push   %edx
     f46:	50                   	push   %eax
     f47:	e8 4b ff ff ff       	call   e97 <write>
}
     f4c:	83 c4 10             	add    $0x10,%esp
     f4f:	c9                   	leave  
     f50:	c3                   	ret    

00000f51 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     f51:	55                   	push   %ebp
     f52:	89 e5                	mov    %esp,%ebp
     f54:	57                   	push   %edi
     f55:	56                   	push   %esi
     f56:	53                   	push   %ebx
     f57:	83 ec 2c             	sub    $0x2c,%esp
     f5a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     f5d:	89 ce                	mov    %ecx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     f5f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
     f63:	74 04                	je     f69 <printint+0x18>
     f65:	85 d2                	test   %edx,%edx
     f67:	78 3c                	js     fa5 <printint+0x54>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     f69:	89 d1                	mov    %edx,%ecx
  neg = 0;
     f6b:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  }

  i = 0;
     f72:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
     f77:	89 c8                	mov    %ecx,%eax
     f79:	ba 00 00 00 00       	mov    $0x0,%edx
     f7e:	f7 f6                	div    %esi
     f80:	89 df                	mov    %ebx,%edi
     f82:	43                   	inc    %ebx
     f83:	8a 92 c8 13 00 00    	mov    0x13c8(%edx),%dl
     f89:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
     f8d:	89 ca                	mov    %ecx,%edx
     f8f:	89 c1                	mov    %eax,%ecx
     f91:	39 f2                	cmp    %esi,%edx
     f93:	73 e2                	jae    f77 <printint+0x26>
  if(neg)
     f95:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
     f99:	74 24                	je     fbf <printint+0x6e>
    buf[i++] = '-';
     f9b:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
     fa0:	8d 5f 02             	lea    0x2(%edi),%ebx
     fa3:	eb 1a                	jmp    fbf <printint+0x6e>
    x = -xx;
     fa5:	89 d1                	mov    %edx,%ecx
     fa7:	f7 d9                	neg    %ecx
    neg = 1;
     fa9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
     fb0:	eb c0                	jmp    f72 <printint+0x21>

  while(--i >= 0)
    putc(fd, buf[i]);
     fb2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
     fb7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     fba:	e8 78 ff ff ff       	call   f37 <putc>
  while(--i >= 0)
     fbf:	4b                   	dec    %ebx
     fc0:	79 f0                	jns    fb2 <printint+0x61>
}
     fc2:	83 c4 2c             	add    $0x2c,%esp
     fc5:	5b                   	pop    %ebx
     fc6:	5e                   	pop    %esi
     fc7:	5f                   	pop    %edi
     fc8:	5d                   	pop    %ebp
     fc9:	c3                   	ret    

00000fca <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
     fca:	55                   	push   %ebp
     fcb:	89 e5                	mov    %esp,%ebp
     fcd:	57                   	push   %edi
     fce:	56                   	push   %esi
     fcf:	53                   	push   %ebx
     fd0:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
     fd3:	8d 45 10             	lea    0x10(%ebp),%eax
     fd6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
     fd9:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
     fde:	bb 00 00 00 00       	mov    $0x0,%ebx
     fe3:	eb 12                	jmp    ff7 <printf+0x2d>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
     fe5:	89 fa                	mov    %edi,%edx
     fe7:	8b 45 08             	mov    0x8(%ebp),%eax
     fea:	e8 48 ff ff ff       	call   f37 <putc>
     fef:	eb 05                	jmp    ff6 <printf+0x2c>
      }
    } else if(state == '%'){
     ff1:	83 fe 25             	cmp    $0x25,%esi
     ff4:	74 22                	je     1018 <printf+0x4e>
  for(i = 0; fmt[i]; i++){
     ff6:	43                   	inc    %ebx
     ff7:	8b 45 0c             	mov    0xc(%ebp),%eax
     ffa:	8a 04 18             	mov    (%eax,%ebx,1),%al
     ffd:	84 c0                	test   %al,%al
     fff:	0f 84 1d 01 00 00    	je     1122 <printf+0x158>
    c = fmt[i] & 0xff;
    1005:	0f be f8             	movsbl %al,%edi
    1008:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    100b:	85 f6                	test   %esi,%esi
    100d:	75 e2                	jne    ff1 <printf+0x27>
      if(c == '%'){
    100f:	83 f8 25             	cmp    $0x25,%eax
    1012:	75 d1                	jne    fe5 <printf+0x1b>
        state = '%';
    1014:	89 c6                	mov    %eax,%esi
    1016:	eb de                	jmp    ff6 <printf+0x2c>
      if(c == 'd'){
    1018:	83 f8 25             	cmp    $0x25,%eax
    101b:	0f 84 cc 00 00 00    	je     10ed <printf+0x123>
    1021:	0f 8c da 00 00 00    	jl     1101 <printf+0x137>
    1027:	83 f8 78             	cmp    $0x78,%eax
    102a:	0f 8f d1 00 00 00    	jg     1101 <printf+0x137>
    1030:	83 f8 63             	cmp    $0x63,%eax
    1033:	0f 8c c8 00 00 00    	jl     1101 <printf+0x137>
    1039:	83 e8 63             	sub    $0x63,%eax
    103c:	83 f8 15             	cmp    $0x15,%eax
    103f:	0f 87 bc 00 00 00    	ja     1101 <printf+0x137>
    1045:	ff 24 85 70 13 00 00 	jmp    *0x1370(,%eax,4)
        printint(fd, *ap, 10, 1);
    104c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    104f:	8b 17                	mov    (%edi),%edx
    1051:	83 ec 0c             	sub    $0xc,%esp
    1054:	6a 01                	push   $0x1
    1056:	b9 0a 00 00 00       	mov    $0xa,%ecx
    105b:	8b 45 08             	mov    0x8(%ebp),%eax
    105e:	e8 ee fe ff ff       	call   f51 <printint>
        ap++;
    1063:	83 c7 04             	add    $0x4,%edi
    1066:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    1069:	83 c4 10             	add    $0x10,%esp
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c);
      }
      state = 0;
    106c:	be 00 00 00 00       	mov    $0x0,%esi
    1071:	eb 83                	jmp    ff6 <printf+0x2c>
        printint(fd, *ap, 16, 0);
    1073:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    1076:	8b 17                	mov    (%edi),%edx
    1078:	83 ec 0c             	sub    $0xc,%esp
    107b:	6a 00                	push   $0x0
    107d:	b9 10 00 00 00       	mov    $0x10,%ecx
    1082:	8b 45 08             	mov    0x8(%ebp),%eax
    1085:	e8 c7 fe ff ff       	call   f51 <printint>
        ap++;
    108a:	83 c7 04             	add    $0x4,%edi
    108d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    1090:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1093:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
    1098:	e9 59 ff ff ff       	jmp    ff6 <printf+0x2c>
        s = (char*)*ap;
    109d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    10a0:	8b 30                	mov    (%eax),%esi
        ap++;
    10a2:	83 c0 04             	add    $0x4,%eax
    10a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    10a8:	85 f6                	test   %esi,%esi
    10aa:	75 13                	jne    10bf <printf+0xf5>
          s = "(null)";
    10ac:	be 68 13 00 00       	mov    $0x1368,%esi
    10b1:	eb 0c                	jmp    10bf <printf+0xf5>
          putc(fd, *s);
    10b3:	0f be d2             	movsbl %dl,%edx
    10b6:	8b 45 08             	mov    0x8(%ebp),%eax
    10b9:	e8 79 fe ff ff       	call   f37 <putc>
          s++;
    10be:	46                   	inc    %esi
        while(*s != 0){
    10bf:	8a 16                	mov    (%esi),%dl
    10c1:	84 d2                	test   %dl,%dl
    10c3:	75 ee                	jne    10b3 <printf+0xe9>
      state = 0;
    10c5:	be 00 00 00 00       	mov    $0x0,%esi
    10ca:	e9 27 ff ff ff       	jmp    ff6 <printf+0x2c>
        putc(fd, *ap);
    10cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    10d2:	0f be 17             	movsbl (%edi),%edx
    10d5:	8b 45 08             	mov    0x8(%ebp),%eax
    10d8:	e8 5a fe ff ff       	call   f37 <putc>
        ap++;
    10dd:	83 c7 04             	add    $0x4,%edi
    10e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    10e3:	be 00 00 00 00       	mov    $0x0,%esi
    10e8:	e9 09 ff ff ff       	jmp    ff6 <printf+0x2c>
        putc(fd, c);
    10ed:	89 fa                	mov    %edi,%edx
    10ef:	8b 45 08             	mov    0x8(%ebp),%eax
    10f2:	e8 40 fe ff ff       	call   f37 <putc>
      state = 0;
    10f7:	be 00 00 00 00       	mov    $0x0,%esi
    10fc:	e9 f5 fe ff ff       	jmp    ff6 <printf+0x2c>
        putc(fd, '%');
    1101:	ba 25 00 00 00       	mov    $0x25,%edx
    1106:	8b 45 08             	mov    0x8(%ebp),%eax
    1109:	e8 29 fe ff ff       	call   f37 <putc>
        putc(fd, c);
    110e:	89 fa                	mov    %edi,%edx
    1110:	8b 45 08             	mov    0x8(%ebp),%eax
    1113:	e8 1f fe ff ff       	call   f37 <putc>
      state = 0;
    1118:	be 00 00 00 00       	mov    $0x0,%esi
    111d:	e9 d4 fe ff ff       	jmp    ff6 <printf+0x2c>
    }
  }
}
    1122:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1125:	5b                   	pop    %ebx
    1126:	5e                   	pop    %esi
    1127:	5f                   	pop    %edi
    1128:	5d                   	pop    %ebp
    1129:	c3                   	ret    

0000112a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    112a:	55                   	push   %ebp
    112b:	89 e5                	mov    %esp,%ebp
    112d:	57                   	push   %edi
    112e:	56                   	push   %esi
    112f:	53                   	push   %ebx
    1130:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1133:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1136:	a1 64 14 00 00       	mov    0x1464,%eax
    113b:	eb 02                	jmp    113f <free+0x15>
    113d:	89 d0                	mov    %edx,%eax
    113f:	39 c8                	cmp    %ecx,%eax
    1141:	73 04                	jae    1147 <free+0x1d>
    1143:	3b 08                	cmp    (%eax),%ecx
    1145:	72 12                	jb     1159 <free+0x2f>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1147:	8b 10                	mov    (%eax),%edx
    1149:	39 d0                	cmp    %edx,%eax
    114b:	72 f0                	jb     113d <free+0x13>
    114d:	39 c8                	cmp    %ecx,%eax
    114f:	72 08                	jb     1159 <free+0x2f>
    1151:	39 d1                	cmp    %edx,%ecx
    1153:	72 04                	jb     1159 <free+0x2f>
    1155:	89 d0                	mov    %edx,%eax
    1157:	eb e6                	jmp    113f <free+0x15>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1159:	8b 73 fc             	mov    -0x4(%ebx),%esi
    115c:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    115f:	8b 10                	mov    (%eax),%edx
    1161:	39 d7                	cmp    %edx,%edi
    1163:	74 19                	je     117e <free+0x54>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    1165:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    1168:	8b 50 04             	mov    0x4(%eax),%edx
    116b:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    116e:	39 ce                	cmp    %ecx,%esi
    1170:	74 1b                	je     118d <free+0x63>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    1172:	89 08                	mov    %ecx,(%eax)
  freep = p;
    1174:	a3 64 14 00 00       	mov    %eax,0x1464
}
    1179:	5b                   	pop    %ebx
    117a:	5e                   	pop    %esi
    117b:	5f                   	pop    %edi
    117c:	5d                   	pop    %ebp
    117d:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    117e:	03 72 04             	add    0x4(%edx),%esi
    1181:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    1184:	8b 10                	mov    (%eax),%edx
    1186:	8b 12                	mov    (%edx),%edx
    1188:	89 53 f8             	mov    %edx,-0x8(%ebx)
    118b:	eb db                	jmp    1168 <free+0x3e>
    p->s.size += bp->s.size;
    118d:	03 53 fc             	add    -0x4(%ebx),%edx
    1190:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    1193:	8b 53 f8             	mov    -0x8(%ebx),%edx
    1196:	89 10                	mov    %edx,(%eax)
    1198:	eb da                	jmp    1174 <free+0x4a>

0000119a <morecore>:

static Header*
morecore(uint nu)
{
    119a:	55                   	push   %ebp
    119b:	89 e5                	mov    %esp,%ebp
    119d:	53                   	push   %ebx
    119e:	83 ec 04             	sub    $0x4,%esp
    11a1:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    11a3:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    11a8:	77 05                	ja     11af <morecore+0x15>
    nu = 4096;
    11aa:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    11af:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    11b6:	83 ec 0c             	sub    $0xc,%esp
    11b9:	50                   	push   %eax
    11ba:	e8 40 fd ff ff       	call   eff <sbrk>
  if(p == (char*)-1)
    11bf:	83 c4 10             	add    $0x10,%esp
    11c2:	83 f8 ff             	cmp    $0xffffffff,%eax
    11c5:	74 1c                	je     11e3 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    11c7:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    11ca:	83 c0 08             	add    $0x8,%eax
    11cd:	83 ec 0c             	sub    $0xc,%esp
    11d0:	50                   	push   %eax
    11d1:	e8 54 ff ff ff       	call   112a <free>
  return freep;
    11d6:	a1 64 14 00 00       	mov    0x1464,%eax
    11db:	83 c4 10             	add    $0x10,%esp
}
    11de:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    11e1:	c9                   	leave  
    11e2:	c3                   	ret    
    return 0;
    11e3:	b8 00 00 00 00       	mov    $0x0,%eax
    11e8:	eb f4                	jmp    11de <morecore+0x44>

000011ea <malloc>:

void*
malloc(uint nbytes)
{
    11ea:	55                   	push   %ebp
    11eb:	89 e5                	mov    %esp,%ebp
    11ed:	53                   	push   %ebx
    11ee:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    11f1:	8b 45 08             	mov    0x8(%ebp),%eax
    11f4:	8d 58 07             	lea    0x7(%eax),%ebx
    11f7:	c1 eb 03             	shr    $0x3,%ebx
    11fa:	43                   	inc    %ebx
  if((prevp = freep) == 0){
    11fb:	8b 0d 64 14 00 00    	mov    0x1464,%ecx
    1201:	85 c9                	test   %ecx,%ecx
    1203:	74 04                	je     1209 <malloc+0x1f>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1205:	8b 01                	mov    (%ecx),%eax
    1207:	eb 4a                	jmp    1253 <malloc+0x69>
    base.s.ptr = freep = prevp = &base;
    1209:	c7 05 64 14 00 00 68 	movl   $0x1468,0x1464
    1210:	14 00 00 
    1213:	c7 05 68 14 00 00 68 	movl   $0x1468,0x1468
    121a:	14 00 00 
    base.s.size = 0;
    121d:	c7 05 6c 14 00 00 00 	movl   $0x0,0x146c
    1224:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    1227:	b9 68 14 00 00       	mov    $0x1468,%ecx
    122c:	eb d7                	jmp    1205 <malloc+0x1b>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    122e:	74 19                	je     1249 <malloc+0x5f>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    1230:	29 da                	sub    %ebx,%edx
    1232:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    1235:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    1238:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    123b:	89 0d 64 14 00 00    	mov    %ecx,0x1464
      return (void*)(p + 1);
    1241:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    1244:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1247:	c9                   	leave  
    1248:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    1249:	8b 10                	mov    (%eax),%edx
    124b:	89 11                	mov    %edx,(%ecx)
    124d:	eb ec                	jmp    123b <malloc+0x51>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    124f:	89 c1                	mov    %eax,%ecx
    1251:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    1253:	8b 50 04             	mov    0x4(%eax),%edx
    1256:	39 da                	cmp    %ebx,%edx
    1258:	73 d4                	jae    122e <malloc+0x44>
    if(p == freep)
    125a:	39 05 64 14 00 00    	cmp    %eax,0x1464
    1260:	75 ed                	jne    124f <malloc+0x65>
      if((p = morecore(nunits)) == 0)
    1262:	89 d8                	mov    %ebx,%eax
    1264:	e8 31 ff ff ff       	call   119a <morecore>
    1269:	85 c0                	test   %eax,%eax
    126b:	75 e2                	jne    124f <malloc+0x65>
    126d:	eb d5                	jmp    1244 <malloc+0x5a>
