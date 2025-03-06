
_sh:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  return 0;
}

int
main(void)
{
       0:	8d 4c 24 04          	lea    0x4(%esp),%ecx
       4:	83 e4 f0             	and    $0xfffffff0,%esp
       7:	ff 71 fc             	push   -0x4(%ecx)
       a:	55                   	push   %ebp
       b:	89 e5                	mov    %esp,%ebp
       d:	51                   	push   %ecx
       e:	83 ec 04             	sub    $0x4,%esp
  static char buf[100];
  int fd;

  // Ensure that three file descriptors are open.
  while((fd = open("console", O_RDWR)) >= 0){
      11:	eb 0e                	jmp    21 <main+0x21>
      13:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      17:	90                   	nop
    if(fd >= 3){
      18:	83 f8 02             	cmp    $0x2,%eax
      1b:	0f 8f a2 02 00 00    	jg     2c3 <main+0x2c3>
  while((fd = open("console", O_RDWR)) >= 0){
      21:	83 ec 08             	sub    $0x8,%esp
      24:	6a 02                	push   $0x2
      26:	68 79 15 00 00       	push   $0x1579
      2b:	e8 43 10 00 00       	call   1073 <open>
      30:	83 c4 10             	add    $0x10,%esp
      33:	85 c0                	test   %eax,%eax
      35:	79 e1                	jns    18 <main+0x18>
      37:	eb 3a                	jmp    73 <main+0x73>
      39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        printf(2, "cannot cd %s\n", buf+3);
      continue;
    }

    // Handle the 'history' command
    if(buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y' ){
      40:	3c 68                	cmp    $0x68,%al
      42:	0f 85 e8 00 00 00    	jne    130 <main+0x130>
      48:	80 3d 61 1c 00 00 69 	cmpb   $0x69,0x1c61
      4f:	0f 84 23 02 00 00    	je     278 <main+0x278>
      55:	8d 76 00             	lea    0x0(%esi),%esi
int
fork1(void)
{
  int pid;

  pid = fork();
      58:	e8 ce 0f 00 00       	call   102b <fork>
  if(pid == -1)
      5d:	83 f8 ff             	cmp    $0xffffffff,%eax
      60:	0f 84 c9 02 00 00    	je     32f <main+0x32f>
    if(fork1() == 0)
      66:	85 c0                	test   %eax,%eax
      68:	0f 84 66 02 00 00    	je     2d4 <main+0x2d4>
    wait();
      6e:	e8 c8 0f 00 00       	call   103b <wait>
  printf(2, "$ ");
      73:	83 ec 08             	sub    $0x8,%esp
      76:	68 d8 14 00 00       	push   $0x14d8
      7b:	6a 02                	push   $0x2
      7d:	e8 2e 11 00 00       	call   11b0 <printf>
  memset(buf, 0, nbuf);
      82:	83 c4 0c             	add    $0xc,%esp
      85:	6a 64                	push   $0x64
      87:	6a 00                	push   $0x0
      89:	68 60 1c 00 00       	push   $0x1c60
      8e:	e8 0d 0e 00 00       	call   ea0 <memset>
  gets(buf, nbuf);
      93:	58                   	pop    %eax
      94:	5a                   	pop    %edx
      95:	6a 64                	push   $0x64
      97:	68 60 1c 00 00       	push   $0x1c60
      9c:	e8 5f 0e 00 00       	call   f00 <gets>
  if(buf[0] == 0) // EOF
      a1:	0f b6 05 60 1c 00 00 	movzbl 0x1c60,%eax
      a8:	83 c4 10             	add    $0x10,%esp
      ab:	84 c0                	test   %al,%al
      ad:	0f 84 36 02 00 00    	je     2e9 <main+0x2e9>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
      b3:	3c 63                	cmp    $0x63,%al
      b5:	75 89                	jne    40 <main+0x40>
      b7:	0f b6 05 61 1c 00 00 	movzbl 0x1c61,%eax
      be:	3c 64                	cmp    $0x64,%al
      c0:	0f 84 5a 01 00 00    	je     220 <main+0x220>
    if (buf[0] == 'c' && buf[1] == 'h' && buf[2] == 'm' && buf[3] == 'o' && buf[4] == 'd' && buf[5] == ' ') {
      c6:	3c 68                	cmp    $0x68,%al
      c8:	75 8e                	jne    58 <main+0x58>
      ca:	80 3d 62 1c 00 00 6d 	cmpb   $0x6d,0x1c62
      d1:	75 85                	jne    58 <main+0x58>
      d3:	80 3d 63 1c 00 00 6f 	cmpb   $0x6f,0x1c63
      da:	0f 85 78 ff ff ff    	jne    58 <main+0x58>
      e0:	80 3d 64 1c 00 00 64 	cmpb   $0x64,0x1c64
      e7:	0f 85 6b ff ff ff    	jne    58 <main+0x58>
      ed:	80 3d 65 1c 00 00 20 	cmpb   $0x20,0x1c65
      f4:	0f 85 5e ff ff ff    	jne    58 <main+0x58>
      char *temp = buf + 6; // Skip "chmod "
      fa:	b8 66 1c 00 00       	mov    $0x1c66,%eax
      ff:	eb 03                	jmp    104 <main+0x104>
        temp++;
     101:	83 c0 01             	add    $0x1,%eax
      while (*temp != ' ' && *temp != '\0') {
     104:	0f b6 10             	movzbl (%eax),%edx
     107:	f6 c2 df             	test   $0xdf,%dl
     10a:	75 f5                	jne    101 <main+0x101>
      if (*temp == '\0') {
     10c:	84 d2                	test   %dl,%dl
     10e:	0f 85 da 01 00 00    	jne    2ee <main+0x2ee>
        printf(2, "chmod: missing mode\n");
     114:	50                   	push   %eax
     115:	50                   	push   %eax
     116:	68 8f 15 00 00       	push   $0x158f
     11b:	6a 02                	push   $0x2
     11d:	e8 8e 10 00 00       	call   11b0 <printf>
        continue;
     122:	83 c4 10             	add    $0x10,%esp
     125:	e9 49 ff ff ff       	jmp    73 <main+0x73>
     12a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(buf[0] == 'b' && buf[1] == 'l' && buf[2] == 'o' && buf[3] == 'c' && buf[4] == 'k' && buf[5] == ' '){
     130:	3c 62                	cmp    $0x62,%al
     132:	75 64                	jne    198 <main+0x198>
     134:	80 3d 61 1c 00 00 6c 	cmpb   $0x6c,0x1c61
     13b:	0f 85 17 ff ff ff    	jne    58 <main+0x58>
     141:	80 3d 62 1c 00 00 6f 	cmpb   $0x6f,0x1c62
     148:	0f 85 0a ff ff ff    	jne    58 <main+0x58>
     14e:	80 3d 63 1c 00 00 63 	cmpb   $0x63,0x1c63
     155:	0f 85 fd fe ff ff    	jne    58 <main+0x58>
     15b:	80 3d 64 1c 00 00 6b 	cmpb   $0x6b,0x1c64
     162:	0f 85 f0 fe ff ff    	jne    58 <main+0x58>
     168:	80 3d 65 1c 00 00 20 	cmpb   $0x20,0x1c65
     16f:	0f 85 e3 fe ff ff    	jne    58 <main+0x58>
      int id = atoi(temp);
     175:	83 ec 0c             	sub    $0xc,%esp
     178:	68 66 1c 00 00       	push   $0x1c66
     17d:	e8 3e 0e 00 00       	call   fc0 <atoi>
      block(id);
     182:	89 04 24             	mov    %eax,(%esp)
     185:	e8 51 0f 00 00       	call   10db <block>
      continue;
     18a:	83 c4 10             	add    $0x10,%esp
     18d:	e9 e1 fe ff ff       	jmp    73 <main+0x73>
     192:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(buf[0] == 'u' && buf[1]== 'n' && buf[2] == 'b' && buf[3] == 'l' && buf[4] == 'o' && buf[5] == 'c' && buf[6] == 'k' && buf[7] == ' '){
     198:	3c 75                	cmp    $0x75,%al
     19a:	0f 85 b8 fe ff ff    	jne    58 <main+0x58>
     1a0:	80 3d 61 1c 00 00 6e 	cmpb   $0x6e,0x1c61
     1a7:	0f 85 ab fe ff ff    	jne    58 <main+0x58>
     1ad:	80 3d 62 1c 00 00 62 	cmpb   $0x62,0x1c62
     1b4:	0f 85 9e fe ff ff    	jne    58 <main+0x58>
     1ba:	80 3d 63 1c 00 00 6c 	cmpb   $0x6c,0x1c63
     1c1:	0f 85 91 fe ff ff    	jne    58 <main+0x58>
     1c7:	80 3d 64 1c 00 00 6f 	cmpb   $0x6f,0x1c64
     1ce:	0f 85 84 fe ff ff    	jne    58 <main+0x58>
     1d4:	80 3d 65 1c 00 00 63 	cmpb   $0x63,0x1c65
     1db:	0f 85 77 fe ff ff    	jne    58 <main+0x58>
     1e1:	80 3d 66 1c 00 00 6b 	cmpb   $0x6b,0x1c66
     1e8:	0f 85 6a fe ff ff    	jne    58 <main+0x58>
     1ee:	80 3d 67 1c 00 00 20 	cmpb   $0x20,0x1c67
     1f5:	0f 85 5d fe ff ff    	jne    58 <main+0x58>
      int id = atoi(temp);
     1fb:	83 ec 0c             	sub    $0xc,%esp
     1fe:	68 68 1c 00 00       	push   $0x1c68
     203:	e8 b8 0d 00 00       	call   fc0 <atoi>
      unblock(id);
     208:	89 04 24             	mov    %eax,(%esp)
     20b:	e8 d3 0e 00 00       	call   10e3 <unblock>
      continue;
     210:	83 c4 10             	add    $0x10,%esp
     213:	e9 5b fe ff ff       	jmp    73 <main+0x73>
     218:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     21f:	90                   	nop
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
     220:	80 3d 62 1c 00 00 20 	cmpb   $0x20,0x1c62
     227:	0f 85 2b fe ff ff    	jne    58 <main+0x58>
      buf[strlen(buf)-1] = 0;  // chop \n
     22d:	83 ec 0c             	sub    $0xc,%esp
     230:	68 60 1c 00 00       	push   $0x1c60
     235:	e8 36 0c 00 00       	call   e70 <strlen>
      if(chdir(buf+3) < 0)
     23a:	c7 04 24 63 1c 00 00 	movl   $0x1c63,(%esp)
      buf[strlen(buf)-1] = 0;  // chop \n
     241:	c6 80 5f 1c 00 00 00 	movb   $0x0,0x1c5f(%eax)
      if(chdir(buf+3) < 0)
     248:	e8 56 0e 00 00       	call   10a3 <chdir>
     24d:	83 c4 10             	add    $0x10,%esp
     250:	85 c0                	test   %eax,%eax
     252:	0f 89 1b fe ff ff    	jns    73 <main+0x73>
        printf(2, "cannot cd %s\n", buf+3);
     258:	50                   	push   %eax
     259:	68 63 1c 00 00       	push   $0x1c63
     25e:	68 81 15 00 00       	push   $0x1581
     263:	6a 02                	push   $0x2
     265:	e8 46 0f 00 00       	call   11b0 <printf>
     26a:	83 c4 10             	add    $0x10,%esp
     26d:	e9 01 fe ff ff       	jmp    73 <main+0x73>
     272:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    if(buf[0] == 'h' && buf[1] == 'i' && buf[2] == 's' && buf[3] == 't' && buf[4] == 'o' && buf[5] == 'r' && buf[6] == 'y' ){
     278:	80 3d 62 1c 00 00 73 	cmpb   $0x73,0x1c62
     27f:	0f 85 d3 fd ff ff    	jne    58 <main+0x58>
     285:	80 3d 63 1c 00 00 74 	cmpb   $0x74,0x1c63
     28c:	0f 85 c6 fd ff ff    	jne    58 <main+0x58>
     292:	80 3d 64 1c 00 00 6f 	cmpb   $0x6f,0x1c64
     299:	0f 85 b9 fd ff ff    	jne    58 <main+0x58>
     29f:	80 3d 65 1c 00 00 72 	cmpb   $0x72,0x1c65
     2a6:	0f 85 ac fd ff ff    	jne    58 <main+0x58>
     2ac:	80 3d 66 1c 00 00 79 	cmpb   $0x79,0x1c66
     2b3:	0f 85 9f fd ff ff    	jne    58 <main+0x58>
      gethistory();
     2b9:	e8 15 0e 00 00       	call   10d3 <gethistory>
      continue;
     2be:	e9 b0 fd ff ff       	jmp    73 <main+0x73>
      close(fd);
     2c3:	83 ec 0c             	sub    $0xc,%esp
     2c6:	50                   	push   %eax
     2c7:	e8 8f 0d 00 00       	call   105b <close>
      break;
     2cc:	83 c4 10             	add    $0x10,%esp
     2cf:	e9 9f fd ff ff       	jmp    73 <main+0x73>
      runcmd(parsecmd(buf));
     2d4:	83 ec 0c             	sub    $0xc,%esp
     2d7:	68 60 1c 00 00       	push   $0x1c60
     2dc:	e8 8f 0a 00 00       	call   d70 <parsecmd>
     2e1:	89 04 24             	mov    %eax,(%esp)
     2e4:	e8 d7 00 00 00       	call   3c0 <runcmd>
  exit();
     2e9:	e8 45 0d 00 00       	call   1033 <exit>
      int mode = atoi(temp);
     2ee:	83 ec 0c             	sub    $0xc,%esp
      *temp = '\0'; // Null-terminate the filename
     2f1:	c6 00 00             	movb   $0x0,(%eax)
      temp++; // Move to the mode
     2f4:	83 c0 01             	add    $0x1,%eax
      int mode = atoi(temp);
     2f7:	50                   	push   %eax
     2f8:	e8 c3 0c 00 00       	call   fc0 <atoi>
      if (chmod(filename, mode) < 0) {
     2fd:	5a                   	pop    %edx
     2fe:	59                   	pop    %ecx
     2ff:	50                   	push   %eax
     300:	68 66 1c 00 00       	push   $0x1c66
     305:	e8 e1 0d 00 00       	call   10eb <chmod>
     30a:	83 c4 10             	add    $0x10,%esp
     30d:	85 c0                	test   %eax,%eax
     30f:	0f 89 5e fd ff ff    	jns    73 <main+0x73>
        printf(2, "chmod: failed to change permissions for %s\n", filename);
     315:	51                   	push   %ecx
     316:	68 66 1c 00 00       	push   $0x1c66
     31b:	68 d4 15 00 00       	push   $0x15d4
     320:	6a 02                	push   $0x2
     322:	e8 89 0e 00 00       	call   11b0 <printf>
     327:	83 c4 10             	add    $0x10,%esp
     32a:	e9 44 fd ff ff       	jmp    73 <main+0x73>
    panic("fork");
     32f:	83 ec 0c             	sub    $0xc,%esp
     332:	68 db 14 00 00       	push   $0x14db
     337:	e8 44 00 00 00       	call   380 <panic>
     33c:	66 90                	xchg   %ax,%ax
     33e:	66 90                	xchg   %ax,%ax

00000340 <getcmd>:
{
     340:	55                   	push   %ebp
     341:	89 e5                	mov    %esp,%ebp
     343:	56                   	push   %esi
     344:	53                   	push   %ebx
     345:	8b 75 0c             	mov    0xc(%ebp),%esi
     348:	8b 5d 08             	mov    0x8(%ebp),%ebx
  printf(2, "$ ");
     34b:	83 ec 08             	sub    $0x8,%esp
     34e:	68 d8 14 00 00       	push   $0x14d8
     353:	6a 02                	push   $0x2
     355:	e8 56 0e 00 00       	call   11b0 <printf>
  memset(buf, 0, nbuf);
     35a:	83 c4 0c             	add    $0xc,%esp
     35d:	56                   	push   %esi
     35e:	6a 00                	push   $0x0
     360:	53                   	push   %ebx
     361:	e8 3a 0b 00 00       	call   ea0 <memset>
  gets(buf, nbuf);
     366:	58                   	pop    %eax
     367:	5a                   	pop    %edx
     368:	56                   	push   %esi
     369:	53                   	push   %ebx
     36a:	e8 91 0b 00 00       	call   f00 <gets>
  if(buf[0] == 0) // EOF
     36f:	83 c4 10             	add    $0x10,%esp
     372:	80 3b 01             	cmpb   $0x1,(%ebx)
     375:	19 c0                	sbb    %eax,%eax
}
     377:	8d 65 f8             	lea    -0x8(%ebp),%esp
     37a:	5b                   	pop    %ebx
     37b:	5e                   	pop    %esi
     37c:	5d                   	pop    %ebp
     37d:	c3                   	ret    
     37e:	66 90                	xchg   %ax,%ax

00000380 <panic>:
{
     380:	55                   	push   %ebp
     381:	89 e5                	mov    %esp,%ebp
     383:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
     386:	ff 75 08             	push   0x8(%ebp)
     389:	68 75 15 00 00       	push   $0x1575
     38e:	6a 02                	push   $0x2
     390:	e8 1b 0e 00 00       	call   11b0 <printf>
  exit();
     395:	e8 99 0c 00 00       	call   1033 <exit>
     39a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

000003a0 <fork1>:
{
     3a0:	55                   	push   %ebp
     3a1:	89 e5                	mov    %esp,%ebp
     3a3:	83 ec 08             	sub    $0x8,%esp
  pid = fork();
     3a6:	e8 80 0c 00 00       	call   102b <fork>
  if(pid == -1)
     3ab:	83 f8 ff             	cmp    $0xffffffff,%eax
     3ae:	74 02                	je     3b2 <fork1+0x12>
  return pid;
}
     3b0:	c9                   	leave  
     3b1:	c3                   	ret    
    panic("fork");
     3b2:	83 ec 0c             	sub    $0xc,%esp
     3b5:	68 db 14 00 00       	push   $0x14db
     3ba:	e8 c1 ff ff ff       	call   380 <panic>
     3bf:	90                   	nop

000003c0 <runcmd>:
{
     3c0:	55                   	push   %ebp
     3c1:	89 e5                	mov    %esp,%ebp
     3c3:	53                   	push   %ebx
     3c4:	83 ec 14             	sub    $0x14,%esp
     3c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
     3ca:	85 db                	test   %ebx,%ebx
     3cc:	74 42                	je     410 <runcmd+0x50>
  switch(cmd->type){
     3ce:	83 3b 05             	cmpl   $0x5,(%ebx)
     3d1:	0f 87 e3 00 00 00    	ja     4ba <runcmd+0xfa>
     3d7:	8b 03                	mov    (%ebx),%eax
     3d9:	ff 24 85 a4 15 00 00 	jmp    *0x15a4(,%eax,4)
    if(ecmd->argv[0] == 0)
     3e0:	8b 43 04             	mov    0x4(%ebx),%eax
     3e3:	85 c0                	test   %eax,%eax
     3e5:	74 29                	je     410 <runcmd+0x50>
    exec(ecmd->argv[0], ecmd->argv);
     3e7:	8d 53 04             	lea    0x4(%ebx),%edx
     3ea:	51                   	push   %ecx
     3eb:	51                   	push   %ecx
     3ec:	52                   	push   %edx
     3ed:	50                   	push   %eax
     3ee:	e8 78 0c 00 00       	call   106b <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
     3f3:	83 c4 0c             	add    $0xc,%esp
     3f6:	ff 73 04             	push   0x4(%ebx)
     3f9:	68 e7 14 00 00       	push   $0x14e7
     3fe:	6a 02                	push   $0x2
     400:	e8 ab 0d 00 00       	call   11b0 <printf>
    break;
     405:	83 c4 10             	add    $0x10,%esp
     408:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     40f:	90                   	nop
    exit();
     410:	e8 1e 0c 00 00       	call   1033 <exit>
    if(fork1() == 0)
     415:	e8 86 ff ff ff       	call   3a0 <fork1>
     41a:	85 c0                	test   %eax,%eax
     41c:	75 f2                	jne    410 <runcmd+0x50>
     41e:	e9 8c 00 00 00       	jmp    4af <runcmd+0xef>
    if(pipe(p) < 0)
     423:	83 ec 0c             	sub    $0xc,%esp
     426:	8d 45 f0             	lea    -0x10(%ebp),%eax
     429:	50                   	push   %eax
     42a:	e8 14 0c 00 00       	call   1043 <pipe>
     42f:	83 c4 10             	add    $0x10,%esp
     432:	85 c0                	test   %eax,%eax
     434:	0f 88 a2 00 00 00    	js     4dc <runcmd+0x11c>
    if(fork1() == 0){
     43a:	e8 61 ff ff ff       	call   3a0 <fork1>
     43f:	85 c0                	test   %eax,%eax
     441:	0f 84 a2 00 00 00    	je     4e9 <runcmd+0x129>
    if(fork1() == 0){
     447:	e8 54 ff ff ff       	call   3a0 <fork1>
     44c:	85 c0                	test   %eax,%eax
     44e:	0f 84 c3 00 00 00    	je     517 <runcmd+0x157>
    close(p[0]);
     454:	83 ec 0c             	sub    $0xc,%esp
     457:	ff 75 f0             	push   -0x10(%ebp)
     45a:	e8 fc 0b 00 00       	call   105b <close>
    close(p[1]);
     45f:	58                   	pop    %eax
     460:	ff 75 f4             	push   -0xc(%ebp)
     463:	e8 f3 0b 00 00       	call   105b <close>
    wait();
     468:	e8 ce 0b 00 00       	call   103b <wait>
    wait();
     46d:	e8 c9 0b 00 00       	call   103b <wait>
    break;
     472:	83 c4 10             	add    $0x10,%esp
     475:	eb 99                	jmp    410 <runcmd+0x50>
    if(fork1() == 0)
     477:	e8 24 ff ff ff       	call   3a0 <fork1>
     47c:	85 c0                	test   %eax,%eax
     47e:	74 2f                	je     4af <runcmd+0xef>
    wait();
     480:	e8 b6 0b 00 00       	call   103b <wait>
    runcmd(lcmd->right);
     485:	83 ec 0c             	sub    $0xc,%esp
     488:	ff 73 08             	push   0x8(%ebx)
     48b:	e8 30 ff ff ff       	call   3c0 <runcmd>
    close(rcmd->fd);
     490:	83 ec 0c             	sub    $0xc,%esp
     493:	ff 73 14             	push   0x14(%ebx)
     496:	e8 c0 0b 00 00       	call   105b <close>
    if(open(rcmd->file, rcmd->mode) < 0){
     49b:	58                   	pop    %eax
     49c:	5a                   	pop    %edx
     49d:	ff 73 10             	push   0x10(%ebx)
     4a0:	ff 73 08             	push   0x8(%ebx)
     4a3:	e8 cb 0b 00 00       	call   1073 <open>
     4a8:	83 c4 10             	add    $0x10,%esp
     4ab:	85 c0                	test   %eax,%eax
     4ad:	78 18                	js     4c7 <runcmd+0x107>
      runcmd(bcmd->cmd);
     4af:	83 ec 0c             	sub    $0xc,%esp
     4b2:	ff 73 04             	push   0x4(%ebx)
     4b5:	e8 06 ff ff ff       	call   3c0 <runcmd>
    panic("runcmd");
     4ba:	83 ec 0c             	sub    $0xc,%esp
     4bd:	68 e0 14 00 00       	push   $0x14e0
     4c2:	e8 b9 fe ff ff       	call   380 <panic>
      printf(2, "open %s failed\n", rcmd->file);
     4c7:	51                   	push   %ecx
     4c8:	ff 73 08             	push   0x8(%ebx)
     4cb:	68 f7 14 00 00       	push   $0x14f7
     4d0:	6a 02                	push   $0x2
     4d2:	e8 d9 0c 00 00       	call   11b0 <printf>
      exit();
     4d7:	e8 57 0b 00 00       	call   1033 <exit>
      panic("pipe");
     4dc:	83 ec 0c             	sub    $0xc,%esp
     4df:	68 07 15 00 00       	push   $0x1507
     4e4:	e8 97 fe ff ff       	call   380 <panic>
      close(1);
     4e9:	83 ec 0c             	sub    $0xc,%esp
     4ec:	6a 01                	push   $0x1
     4ee:	e8 68 0b 00 00       	call   105b <close>
      dup(p[1]);
     4f3:	58                   	pop    %eax
     4f4:	ff 75 f4             	push   -0xc(%ebp)
     4f7:	e8 af 0b 00 00       	call   10ab <dup>
      close(p[0]);
     4fc:	58                   	pop    %eax
     4fd:	ff 75 f0             	push   -0x10(%ebp)
     500:	e8 56 0b 00 00       	call   105b <close>
      close(p[1]);
     505:	58                   	pop    %eax
     506:	ff 75 f4             	push   -0xc(%ebp)
     509:	e8 4d 0b 00 00       	call   105b <close>
      runcmd(pcmd->left);
     50e:	5a                   	pop    %edx
     50f:	ff 73 04             	push   0x4(%ebx)
     512:	e8 a9 fe ff ff       	call   3c0 <runcmd>
      close(0);
     517:	83 ec 0c             	sub    $0xc,%esp
     51a:	6a 00                	push   $0x0
     51c:	e8 3a 0b 00 00       	call   105b <close>
      dup(p[0]);
     521:	5a                   	pop    %edx
     522:	ff 75 f0             	push   -0x10(%ebp)
     525:	e8 81 0b 00 00       	call   10ab <dup>
      close(p[0]);
     52a:	59                   	pop    %ecx
     52b:	ff 75 f0             	push   -0x10(%ebp)
     52e:	e8 28 0b 00 00       	call   105b <close>
      close(p[1]);
     533:	58                   	pop    %eax
     534:	ff 75 f4             	push   -0xc(%ebp)
     537:	e8 1f 0b 00 00       	call   105b <close>
      runcmd(pcmd->right);
     53c:	58                   	pop    %eax
     53d:	ff 73 08             	push   0x8(%ebx)
     540:	e8 7b fe ff ff       	call   3c0 <runcmd>
     545:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     54c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000550 <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
     550:	55                   	push   %ebp
     551:	89 e5                	mov    %esp,%ebp
     553:	53                   	push   %ebx
     554:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     557:	6a 54                	push   $0x54
     559:	e8 82 0e 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     55e:	83 c4 0c             	add    $0xc,%esp
     561:	6a 54                	push   $0x54
  cmd = malloc(sizeof(*cmd));
     563:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     565:	6a 00                	push   $0x0
     567:	50                   	push   %eax
     568:	e8 33 09 00 00       	call   ea0 <memset>
  cmd->type = EXEC;
     56d:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
     573:	89 d8                	mov    %ebx,%eax
     575:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     578:	c9                   	leave  
     579:	c3                   	ret    
     57a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000580 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
     580:	55                   	push   %ebp
     581:	89 e5                	mov    %esp,%ebp
     583:	53                   	push   %ebx
     584:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
     587:	6a 18                	push   $0x18
     589:	e8 52 0e 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     58e:	83 c4 0c             	add    $0xc,%esp
     591:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     593:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     595:	6a 00                	push   $0x0
     597:	50                   	push   %eax
     598:	e8 03 09 00 00       	call   ea0 <memset>
  cmd->type = REDIR;
  cmd->cmd = subcmd;
     59d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = REDIR;
     5a0:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
     5a6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
     5a9:	8b 45 0c             	mov    0xc(%ebp),%eax
     5ac:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
     5af:	8b 45 10             	mov    0x10(%ebp),%eax
     5b2:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
     5b5:	8b 45 14             	mov    0x14(%ebp),%eax
     5b8:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
     5bb:	8b 45 18             	mov    0x18(%ebp),%eax
     5be:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
     5c1:	89 d8                	mov    %ebx,%eax
     5c3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     5c6:	c9                   	leave  
     5c7:	c3                   	ret    
     5c8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     5cf:	90                   	nop

000005d0 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
     5d0:	55                   	push   %ebp
     5d1:	89 e5                	mov    %esp,%ebp
     5d3:	53                   	push   %ebx
     5d4:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
     5d7:	6a 0c                	push   $0xc
     5d9:	e8 02 0e 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     5de:	83 c4 0c             	add    $0xc,%esp
     5e1:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     5e3:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     5e5:	6a 00                	push   $0x0
     5e7:	50                   	push   %eax
     5e8:	e8 b3 08 00 00       	call   ea0 <memset>
  cmd->type = PIPE;
  cmd->left = left;
     5ed:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = PIPE;
     5f0:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
     5f6:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     5f9:	8b 45 0c             	mov    0xc(%ebp),%eax
     5fc:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     5ff:	89 d8                	mov    %ebx,%eax
     601:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     604:	c9                   	leave  
     605:	c3                   	ret    
     606:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     60d:	8d 76 00             	lea    0x0(%esi),%esi

00000610 <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
     610:	55                   	push   %ebp
     611:	89 e5                	mov    %esp,%ebp
     613:	53                   	push   %ebx
     614:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     617:	6a 0c                	push   $0xc
     619:	e8 c2 0d 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     61e:	83 c4 0c             	add    $0xc,%esp
     621:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     623:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     625:	6a 00                	push   $0x0
     627:	50                   	push   %eax
     628:	e8 73 08 00 00       	call   ea0 <memset>
  cmd->type = LIST;
  cmd->left = left;
     62d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = LIST;
     630:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
     636:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
     639:	8b 45 0c             	mov    0xc(%ebp),%eax
     63c:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
     63f:	89 d8                	mov    %ebx,%eax
     641:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     644:	c9                   	leave  
     645:	c3                   	ret    
     646:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     64d:	8d 76 00             	lea    0x0(%esi),%esi

00000650 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
     650:	55                   	push   %ebp
     651:	89 e5                	mov    %esp,%ebp
     653:	53                   	push   %ebx
     654:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
     657:	6a 08                	push   $0x8
     659:	e8 82 0d 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     65e:	83 c4 0c             	add    $0xc,%esp
     661:	6a 08                	push   $0x8
  cmd = malloc(sizeof(*cmd));
     663:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
     665:	6a 00                	push   $0x0
     667:	50                   	push   %eax
     668:	e8 33 08 00 00       	call   ea0 <memset>
  cmd->type = BACK;
  cmd->cmd = subcmd;
     66d:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->type = BACK;
     670:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
     676:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
     679:	89 d8                	mov    %ebx,%eax
     67b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     67e:	c9                   	leave  
     67f:	c3                   	ret    

00000680 <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
     680:	55                   	push   %ebp
     681:	89 e5                	mov    %esp,%ebp
     683:	57                   	push   %edi
     684:	56                   	push   %esi
     685:	53                   	push   %ebx
     686:	83 ec 0c             	sub    $0xc,%esp
  char *s;
  int ret;

  s = *ps;
     689:	8b 45 08             	mov    0x8(%ebp),%eax
{
     68c:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     68f:	8b 75 10             	mov    0x10(%ebp),%esi
  s = *ps;
     692:	8b 38                	mov    (%eax),%edi
  while(s < es && strchr(whitespace, *s))
     694:	39 df                	cmp    %ebx,%edi
     696:	72 0f                	jb     6a7 <gettoken+0x27>
     698:	eb 25                	jmp    6bf <gettoken+0x3f>
     69a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    s++;
     6a0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     6a3:	39 fb                	cmp    %edi,%ebx
     6a5:	74 18                	je     6bf <gettoken+0x3f>
     6a7:	0f be 07             	movsbl (%edi),%eax
     6aa:	83 ec 08             	sub    $0x8,%esp
     6ad:	50                   	push   %eax
     6ae:	68 3c 1c 00 00       	push   $0x1c3c
     6b3:	e8 08 08 00 00       	call   ec0 <strchr>
     6b8:	83 c4 10             	add    $0x10,%esp
     6bb:	85 c0                	test   %eax,%eax
     6bd:	75 e1                	jne    6a0 <gettoken+0x20>
  if(q)
     6bf:	85 f6                	test   %esi,%esi
     6c1:	74 02                	je     6c5 <gettoken+0x45>
    *q = s;
     6c3:	89 3e                	mov    %edi,(%esi)
  ret = *s;
     6c5:	0f b6 07             	movzbl (%edi),%eax
  switch(*s){
     6c8:	3c 3c                	cmp    $0x3c,%al
     6ca:	0f 8f d0 00 00 00    	jg     7a0 <gettoken+0x120>
     6d0:	3c 3a                	cmp    $0x3a,%al
     6d2:	0f 8f b4 00 00 00    	jg     78c <gettoken+0x10c>
     6d8:	84 c0                	test   %al,%al
     6da:	75 44                	jne    720 <gettoken+0xa0>
     6dc:	31 f6                	xor    %esi,%esi
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
     6de:	8b 55 14             	mov    0x14(%ebp),%edx
     6e1:	85 d2                	test   %edx,%edx
     6e3:	74 05                	je     6ea <gettoken+0x6a>
    *eq = s;
     6e5:	8b 45 14             	mov    0x14(%ebp),%eax
     6e8:	89 38                	mov    %edi,(%eax)

  while(s < es && strchr(whitespace, *s))
     6ea:	39 df                	cmp    %ebx,%edi
     6ec:	72 09                	jb     6f7 <gettoken+0x77>
     6ee:	eb 1f                	jmp    70f <gettoken+0x8f>
    s++;
     6f0:	83 c7 01             	add    $0x1,%edi
  while(s < es && strchr(whitespace, *s))
     6f3:	39 fb                	cmp    %edi,%ebx
     6f5:	74 18                	je     70f <gettoken+0x8f>
     6f7:	0f be 07             	movsbl (%edi),%eax
     6fa:	83 ec 08             	sub    $0x8,%esp
     6fd:	50                   	push   %eax
     6fe:	68 3c 1c 00 00       	push   $0x1c3c
     703:	e8 b8 07 00 00       	call   ec0 <strchr>
     708:	83 c4 10             	add    $0x10,%esp
     70b:	85 c0                	test   %eax,%eax
     70d:	75 e1                	jne    6f0 <gettoken+0x70>
  *ps = s;
     70f:	8b 45 08             	mov    0x8(%ebp),%eax
     712:	89 38                	mov    %edi,(%eax)
  return ret;
}
     714:	8d 65 f4             	lea    -0xc(%ebp),%esp
     717:	89 f0                	mov    %esi,%eax
     719:	5b                   	pop    %ebx
     71a:	5e                   	pop    %esi
     71b:	5f                   	pop    %edi
     71c:	5d                   	pop    %ebp
     71d:	c3                   	ret    
     71e:	66 90                	xchg   %ax,%ax
  switch(*s){
     720:	79 5e                	jns    780 <gettoken+0x100>
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     722:	39 fb                	cmp    %edi,%ebx
     724:	77 34                	ja     75a <gettoken+0xda>
  if(eq)
     726:	8b 45 14             	mov    0x14(%ebp),%eax
     729:	be 61 00 00 00       	mov    $0x61,%esi
     72e:	85 c0                	test   %eax,%eax
     730:	75 b3                	jne    6e5 <gettoken+0x65>
     732:	eb db                	jmp    70f <gettoken+0x8f>
     734:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     738:	0f be 07             	movsbl (%edi),%eax
     73b:	83 ec 08             	sub    $0x8,%esp
     73e:	50                   	push   %eax
     73f:	68 34 1c 00 00       	push   $0x1c34
     744:	e8 77 07 00 00       	call   ec0 <strchr>
     749:	83 c4 10             	add    $0x10,%esp
     74c:	85 c0                	test   %eax,%eax
     74e:	75 22                	jne    772 <gettoken+0xf2>
      s++;
     750:	83 c7 01             	add    $0x1,%edi
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
     753:	39 fb                	cmp    %edi,%ebx
     755:	74 cf                	je     726 <gettoken+0xa6>
     757:	0f b6 07             	movzbl (%edi),%eax
     75a:	83 ec 08             	sub    $0x8,%esp
     75d:	0f be f0             	movsbl %al,%esi
     760:	56                   	push   %esi
     761:	68 3c 1c 00 00       	push   $0x1c3c
     766:	e8 55 07 00 00       	call   ec0 <strchr>
     76b:	83 c4 10             	add    $0x10,%esp
     76e:	85 c0                	test   %eax,%eax
     770:	74 c6                	je     738 <gettoken+0xb8>
    ret = 'a';
     772:	be 61 00 00 00       	mov    $0x61,%esi
     777:	e9 62 ff ff ff       	jmp    6de <gettoken+0x5e>
     77c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     780:	3c 26                	cmp    $0x26,%al
     782:	74 08                	je     78c <gettoken+0x10c>
     784:	8d 48 d8             	lea    -0x28(%eax),%ecx
     787:	80 f9 01             	cmp    $0x1,%cl
     78a:	77 96                	ja     722 <gettoken+0xa2>
  ret = *s;
     78c:	0f be f0             	movsbl %al,%esi
    s++;
     78f:	83 c7 01             	add    $0x1,%edi
    break;
     792:	e9 47 ff ff ff       	jmp    6de <gettoken+0x5e>
     797:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     79e:	66 90                	xchg   %ax,%ax
  switch(*s){
     7a0:	3c 3e                	cmp    $0x3e,%al
     7a2:	75 1c                	jne    7c0 <gettoken+0x140>
    if(*s == '>'){
     7a4:	80 7f 01 3e          	cmpb   $0x3e,0x1(%edi)
    s++;
     7a8:	8d 47 01             	lea    0x1(%edi),%eax
    if(*s == '>'){
     7ab:	74 1c                	je     7c9 <gettoken+0x149>
    s++;
     7ad:	89 c7                	mov    %eax,%edi
     7af:	be 3e 00 00 00       	mov    $0x3e,%esi
     7b4:	e9 25 ff ff ff       	jmp    6de <gettoken+0x5e>
     7b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  switch(*s){
     7c0:	3c 7c                	cmp    $0x7c,%al
     7c2:	74 c8                	je     78c <gettoken+0x10c>
     7c4:	e9 59 ff ff ff       	jmp    722 <gettoken+0xa2>
      s++;
     7c9:	83 c7 02             	add    $0x2,%edi
      ret = '+';
     7cc:	be 2b 00 00 00       	mov    $0x2b,%esi
     7d1:	e9 08 ff ff ff       	jmp    6de <gettoken+0x5e>
     7d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7dd:	8d 76 00             	lea    0x0(%esi),%esi

000007e0 <peek>:

int
peek(char **ps, char *es, char *toks)
{
     7e0:	55                   	push   %ebp
     7e1:	89 e5                	mov    %esp,%ebp
     7e3:	57                   	push   %edi
     7e4:	56                   	push   %esi
     7e5:	53                   	push   %ebx
     7e6:	83 ec 0c             	sub    $0xc,%esp
     7e9:	8b 7d 08             	mov    0x8(%ebp),%edi
     7ec:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
     7ef:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
     7f1:	39 f3                	cmp    %esi,%ebx
     7f3:	72 12                	jb     807 <peek+0x27>
     7f5:	eb 28                	jmp    81f <peek+0x3f>
     7f7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     7fe:	66 90                	xchg   %ax,%ax
    s++;
     800:	83 c3 01             	add    $0x1,%ebx
  while(s < es && strchr(whitespace, *s))
     803:	39 de                	cmp    %ebx,%esi
     805:	74 18                	je     81f <peek+0x3f>
     807:	0f be 03             	movsbl (%ebx),%eax
     80a:	83 ec 08             	sub    $0x8,%esp
     80d:	50                   	push   %eax
     80e:	68 3c 1c 00 00       	push   $0x1c3c
     813:	e8 a8 06 00 00       	call   ec0 <strchr>
     818:	83 c4 10             	add    $0x10,%esp
     81b:	85 c0                	test   %eax,%eax
     81d:	75 e1                	jne    800 <peek+0x20>
  *ps = s;
     81f:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
     821:	0f be 03             	movsbl (%ebx),%eax
     824:	31 d2                	xor    %edx,%edx
     826:	84 c0                	test   %al,%al
     828:	75 0e                	jne    838 <peek+0x58>
}
     82a:	8d 65 f4             	lea    -0xc(%ebp),%esp
     82d:	89 d0                	mov    %edx,%eax
     82f:	5b                   	pop    %ebx
     830:	5e                   	pop    %esi
     831:	5f                   	pop    %edi
     832:	5d                   	pop    %ebp
     833:	c3                   	ret    
     834:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  return *s && strchr(toks, *s);
     838:	83 ec 08             	sub    $0x8,%esp
     83b:	50                   	push   %eax
     83c:	ff 75 10             	push   0x10(%ebp)
     83f:	e8 7c 06 00 00       	call   ec0 <strchr>
     844:	83 c4 10             	add    $0x10,%esp
     847:	31 d2                	xor    %edx,%edx
     849:	85 c0                	test   %eax,%eax
     84b:	0f 95 c2             	setne  %dl
}
     84e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     851:	5b                   	pop    %ebx
     852:	89 d0                	mov    %edx,%eax
     854:	5e                   	pop    %esi
     855:	5f                   	pop    %edi
     856:	5d                   	pop    %ebp
     857:	c3                   	ret    
     858:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     85f:	90                   	nop

00000860 <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
     860:	55                   	push   %ebp
     861:	89 e5                	mov    %esp,%ebp
     863:	57                   	push   %edi
     864:	56                   	push   %esi
     865:	53                   	push   %ebx
     866:	83 ec 2c             	sub    $0x2c,%esp
     869:	8b 75 0c             	mov    0xc(%ebp),%esi
     86c:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
     86f:	90                   	nop
     870:	83 ec 04             	sub    $0x4,%esp
     873:	68 29 15 00 00       	push   $0x1529
     878:	53                   	push   %ebx
     879:	56                   	push   %esi
     87a:	e8 61 ff ff ff       	call   7e0 <peek>
     87f:	83 c4 10             	add    $0x10,%esp
     882:	85 c0                	test   %eax,%eax
     884:	0f 84 f6 00 00 00    	je     980 <parseredirs+0x120>
    tok = gettoken(ps, es, 0, 0);
     88a:	6a 00                	push   $0x0
     88c:	6a 00                	push   $0x0
     88e:	53                   	push   %ebx
     88f:	56                   	push   %esi
     890:	e8 eb fd ff ff       	call   680 <gettoken>
     895:	89 c7                	mov    %eax,%edi
    if(gettoken(ps, es, &q, &eq) != 'a')
     897:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     89a:	50                   	push   %eax
     89b:	8d 45 e0             	lea    -0x20(%ebp),%eax
     89e:	50                   	push   %eax
     89f:	53                   	push   %ebx
     8a0:	56                   	push   %esi
     8a1:	e8 da fd ff ff       	call   680 <gettoken>
     8a6:	83 c4 20             	add    $0x20,%esp
     8a9:	83 f8 61             	cmp    $0x61,%eax
     8ac:	0f 85 d9 00 00 00    	jne    98b <parseredirs+0x12b>
      panic("missing file for redirection");
    switch(tok){
     8b2:	83 ff 3c             	cmp    $0x3c,%edi
     8b5:	74 69                	je     920 <parseredirs+0xc0>
     8b7:	83 ff 3e             	cmp    $0x3e,%edi
     8ba:	74 05                	je     8c1 <parseredirs+0x61>
     8bc:	83 ff 2b             	cmp    $0x2b,%edi
     8bf:	75 af                	jne    870 <parseredirs+0x10>
  cmd = malloc(sizeof(*cmd));
     8c1:	83 ec 0c             	sub    $0xc,%esp
      break;
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     8c4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     8c7:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     8ca:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
     8cc:	89 55 d0             	mov    %edx,-0x30(%ebp)
     8cf:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     8d2:	e8 09 0b 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     8d7:	83 c4 0c             	add    $0xc,%esp
     8da:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     8dc:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     8de:	6a 00                	push   $0x0
     8e0:	50                   	push   %eax
     8e1:	e8 ba 05 00 00       	call   ea0 <memset>
  cmd->type = REDIR;
     8e6:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  cmd->cmd = subcmd;
     8ec:	8b 45 08             	mov    0x8(%ebp),%eax
      break;
     8ef:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     8f2:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     8f5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
     8f8:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     8fb:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->mode = mode;
     8fe:	c7 47 10 01 02 00 00 	movl   $0x201,0x10(%edi)
  cmd->efile = efile;
     905:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->fd = fd;
     908:	c7 47 14 01 00 00 00 	movl   $0x1,0x14(%edi)
      break;
     90f:	89 7d 08             	mov    %edi,0x8(%ebp)
     912:	e9 59 ff ff ff       	jmp    870 <parseredirs+0x10>
     917:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     91e:	66 90                	xchg   %ax,%ax
  cmd = malloc(sizeof(*cmd));
     920:	83 ec 0c             	sub    $0xc,%esp
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     923:	8b 55 e4             	mov    -0x1c(%ebp),%edx
     926:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  cmd = malloc(sizeof(*cmd));
     929:	6a 18                	push   $0x18
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
     92b:	89 55 d0             	mov    %edx,-0x30(%ebp)
     92e:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  cmd = malloc(sizeof(*cmd));
     931:	e8 aa 0a 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     936:	83 c4 0c             	add    $0xc,%esp
     939:	6a 18                	push   $0x18
  cmd = malloc(sizeof(*cmd));
     93b:	89 c7                	mov    %eax,%edi
  memset(cmd, 0, sizeof(*cmd));
     93d:	6a 00                	push   $0x0
     93f:	50                   	push   %eax
     940:	e8 5b 05 00 00       	call   ea0 <memset>
  cmd->cmd = subcmd;
     945:	8b 45 08             	mov    0x8(%ebp),%eax
  cmd->file = file;
     948:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      break;
     94b:	89 7d 08             	mov    %edi,0x8(%ebp)
  cmd->efile = efile;
     94e:	8b 55 d0             	mov    -0x30(%ebp),%edx
  cmd->type = REDIR;
     951:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
      break;
     957:	83 c4 10             	add    $0x10,%esp
  cmd->cmd = subcmd;
     95a:	89 47 04             	mov    %eax,0x4(%edi)
  cmd->file = file;
     95d:	89 4f 08             	mov    %ecx,0x8(%edi)
  cmd->efile = efile;
     960:	89 57 0c             	mov    %edx,0xc(%edi)
  cmd->mode = mode;
     963:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
  cmd->fd = fd;
     96a:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
      break;
     971:	e9 fa fe ff ff       	jmp    870 <parseredirs+0x10>
     976:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     97d:	8d 76 00             	lea    0x0(%esi),%esi
    }
  }
  return cmd;
}
     980:	8b 45 08             	mov    0x8(%ebp),%eax
     983:	8d 65 f4             	lea    -0xc(%ebp),%esp
     986:	5b                   	pop    %ebx
     987:	5e                   	pop    %esi
     988:	5f                   	pop    %edi
     989:	5d                   	pop    %ebp
     98a:	c3                   	ret    
      panic("missing file for redirection");
     98b:	83 ec 0c             	sub    $0xc,%esp
     98e:	68 0c 15 00 00       	push   $0x150c
     993:	e8 e8 f9 ff ff       	call   380 <panic>
     998:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     99f:	90                   	nop

000009a0 <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
     9a0:	55                   	push   %ebp
     9a1:	89 e5                	mov    %esp,%ebp
     9a3:	57                   	push   %edi
     9a4:	56                   	push   %esi
     9a5:	53                   	push   %ebx
     9a6:	83 ec 30             	sub    $0x30,%esp
     9a9:	8b 75 08             	mov    0x8(%ebp),%esi
     9ac:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
     9af:	68 2c 15 00 00       	push   $0x152c
     9b4:	57                   	push   %edi
     9b5:	56                   	push   %esi
     9b6:	e8 25 fe ff ff       	call   7e0 <peek>
     9bb:	83 c4 10             	add    $0x10,%esp
     9be:	85 c0                	test   %eax,%eax
     9c0:	0f 85 aa 00 00 00    	jne    a70 <parseexec+0xd0>
  cmd = malloc(sizeof(*cmd));
     9c6:	83 ec 0c             	sub    $0xc,%esp
     9c9:	89 c3                	mov    %eax,%ebx
     9cb:	6a 54                	push   $0x54
     9cd:	e8 0e 0a 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     9d2:	83 c4 0c             	add    $0xc,%esp
     9d5:	6a 54                	push   $0x54
     9d7:	6a 00                	push   $0x0
     9d9:	50                   	push   %eax
     9da:	89 45 d0             	mov    %eax,-0x30(%ebp)
     9dd:	e8 be 04 00 00       	call   ea0 <memset>
  cmd->type = EXEC;
     9e2:	8b 45 d0             	mov    -0x30(%ebp),%eax

  ret = execcmd();
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
     9e5:	83 c4 0c             	add    $0xc,%esp
  cmd->type = EXEC;
     9e8:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  ret = parseredirs(ret, ps, es);
     9ee:	57                   	push   %edi
     9ef:	56                   	push   %esi
     9f0:	50                   	push   %eax
     9f1:	e8 6a fe ff ff       	call   860 <parseredirs>
  while(!peek(ps, es, "|)&;")){
     9f6:	83 c4 10             	add    $0x10,%esp
  ret = parseredirs(ret, ps, es);
     9f9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     9fc:	eb 15                	jmp    a13 <parseexec+0x73>
     9fe:	66 90                	xchg   %ax,%ax
    cmd->argv[argc] = q;
    cmd->eargv[argc] = eq;
    argc++;
    if(argc >= MAXARGS)
      panic("too many args");
    ret = parseredirs(ret, ps, es);
     a00:	83 ec 04             	sub    $0x4,%esp
     a03:	57                   	push   %edi
     a04:	56                   	push   %esi
     a05:	ff 75 d4             	push   -0x2c(%ebp)
     a08:	e8 53 fe ff ff       	call   860 <parseredirs>
     a0d:	83 c4 10             	add    $0x10,%esp
     a10:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
     a13:	83 ec 04             	sub    $0x4,%esp
     a16:	68 43 15 00 00       	push   $0x1543
     a1b:	57                   	push   %edi
     a1c:	56                   	push   %esi
     a1d:	e8 be fd ff ff       	call   7e0 <peek>
     a22:	83 c4 10             	add    $0x10,%esp
     a25:	85 c0                	test   %eax,%eax
     a27:	75 5f                	jne    a88 <parseexec+0xe8>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
     a29:	8d 45 e4             	lea    -0x1c(%ebp),%eax
     a2c:	50                   	push   %eax
     a2d:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a30:	50                   	push   %eax
     a31:	57                   	push   %edi
     a32:	56                   	push   %esi
     a33:	e8 48 fc ff ff       	call   680 <gettoken>
     a38:	83 c4 10             	add    $0x10,%esp
     a3b:	85 c0                	test   %eax,%eax
     a3d:	74 49                	je     a88 <parseexec+0xe8>
    if(tok != 'a')
     a3f:	83 f8 61             	cmp    $0x61,%eax
     a42:	75 62                	jne    aa6 <parseexec+0x106>
    cmd->argv[argc] = q;
     a44:	8b 45 e0             	mov    -0x20(%ebp),%eax
     a47:	8b 55 d0             	mov    -0x30(%ebp),%edx
     a4a:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
     a4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
     a51:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
     a55:	83 c3 01             	add    $0x1,%ebx
    if(argc >= MAXARGS)
     a58:	83 fb 0a             	cmp    $0xa,%ebx
     a5b:	75 a3                	jne    a00 <parseexec+0x60>
      panic("too many args");
     a5d:	83 ec 0c             	sub    $0xc,%esp
     a60:	68 35 15 00 00       	push   $0x1535
     a65:	e8 16 f9 ff ff       	call   380 <panic>
     a6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return parseblock(ps, es);
     a70:	89 7d 0c             	mov    %edi,0xc(%ebp)
     a73:	89 75 08             	mov    %esi,0x8(%ebp)
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
     a76:	8d 65 f4             	lea    -0xc(%ebp),%esp
     a79:	5b                   	pop    %ebx
     a7a:	5e                   	pop    %esi
     a7b:	5f                   	pop    %edi
     a7c:	5d                   	pop    %ebp
    return parseblock(ps, es);
     a7d:	e9 ae 01 00 00       	jmp    c30 <parseblock>
     a82:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  cmd->argv[argc] = 0;
     a88:	8b 45 d0             	mov    -0x30(%ebp),%eax
     a8b:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
     a92:	00 
  cmd->eargv[argc] = 0;
     a93:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
     a9a:	00 
}
     a9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
     a9e:	8d 65 f4             	lea    -0xc(%ebp),%esp
     aa1:	5b                   	pop    %ebx
     aa2:	5e                   	pop    %esi
     aa3:	5f                   	pop    %edi
     aa4:	5d                   	pop    %ebp
     aa5:	c3                   	ret    
      panic("syntax");
     aa6:	83 ec 0c             	sub    $0xc,%esp
     aa9:	68 2e 15 00 00       	push   $0x152e
     aae:	e8 cd f8 ff ff       	call   380 <panic>
     ab3:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     aba:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

00000ac0 <parsepipe>:
{
     ac0:	55                   	push   %ebp
     ac1:	89 e5                	mov    %esp,%ebp
     ac3:	57                   	push   %edi
     ac4:	56                   	push   %esi
     ac5:	53                   	push   %ebx
     ac6:	83 ec 14             	sub    $0x14,%esp
     ac9:	8b 75 08             	mov    0x8(%ebp),%esi
     acc:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
     acf:	57                   	push   %edi
     ad0:	56                   	push   %esi
     ad1:	e8 ca fe ff ff       	call   9a0 <parseexec>
  if(peek(ps, es, "|")){
     ad6:	83 c4 0c             	add    $0xc,%esp
     ad9:	68 48 15 00 00       	push   $0x1548
  cmd = parseexec(ps, es);
     ade:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
     ae0:	57                   	push   %edi
     ae1:	56                   	push   %esi
     ae2:	e8 f9 fc ff ff       	call   7e0 <peek>
     ae7:	83 c4 10             	add    $0x10,%esp
     aea:	85 c0                	test   %eax,%eax
     aec:	75 12                	jne    b00 <parsepipe+0x40>
}
     aee:	8d 65 f4             	lea    -0xc(%ebp),%esp
     af1:	89 d8                	mov    %ebx,%eax
     af3:	5b                   	pop    %ebx
     af4:	5e                   	pop    %esi
     af5:	5f                   	pop    %edi
     af6:	5d                   	pop    %ebp
     af7:	c3                   	ret    
     af8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     aff:	90                   	nop
    gettoken(ps, es, 0, 0);
     b00:	6a 00                	push   $0x0
     b02:	6a 00                	push   $0x0
     b04:	57                   	push   %edi
     b05:	56                   	push   %esi
     b06:	e8 75 fb ff ff       	call   680 <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b0b:	58                   	pop    %eax
     b0c:	5a                   	pop    %edx
     b0d:	57                   	push   %edi
     b0e:	56                   	push   %esi
     b0f:	e8 ac ff ff ff       	call   ac0 <parsepipe>
  cmd = malloc(sizeof(*cmd));
     b14:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = pipecmd(cmd, parsepipe(ps, es));
     b1b:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     b1d:	e8 be 08 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b22:	83 c4 0c             	add    $0xc,%esp
     b25:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     b27:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     b29:	6a 00                	push   $0x0
     b2b:	50                   	push   %eax
     b2c:	e8 6f 03 00 00       	call   ea0 <memset>
  cmd->left = left;
     b31:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     b34:	83 c4 10             	add    $0x10,%esp
     b37:	89 f3                	mov    %esi,%ebx
  cmd->type = PIPE;
     b39:	c7 06 03 00 00 00    	movl   $0x3,(%esi)
}
     b3f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     b41:	89 7e 08             	mov    %edi,0x8(%esi)
}
     b44:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b47:	5b                   	pop    %ebx
     b48:	5e                   	pop    %esi
     b49:	5f                   	pop    %edi
     b4a:	5d                   	pop    %ebp
     b4b:	c3                   	ret    
     b4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000b50 <parseline>:
{
     b50:	55                   	push   %ebp
     b51:	89 e5                	mov    %esp,%ebp
     b53:	57                   	push   %edi
     b54:	56                   	push   %esi
     b55:	53                   	push   %ebx
     b56:	83 ec 24             	sub    $0x24,%esp
     b59:	8b 75 08             	mov    0x8(%ebp),%esi
     b5c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
     b5f:	57                   	push   %edi
     b60:	56                   	push   %esi
     b61:	e8 5a ff ff ff       	call   ac0 <parsepipe>
  while(peek(ps, es, "&")){
     b66:	83 c4 10             	add    $0x10,%esp
  cmd = parsepipe(ps, es);
     b69:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
     b6b:	eb 3b                	jmp    ba8 <parseline+0x58>
     b6d:	8d 76 00             	lea    0x0(%esi),%esi
    gettoken(ps, es, 0, 0);
     b70:	6a 00                	push   $0x0
     b72:	6a 00                	push   $0x0
     b74:	57                   	push   %edi
     b75:	56                   	push   %esi
     b76:	e8 05 fb ff ff       	call   680 <gettoken>
  cmd = malloc(sizeof(*cmd));
     b7b:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
     b82:	e8 59 08 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     b87:	83 c4 0c             	add    $0xc,%esp
     b8a:	6a 08                	push   $0x8
     b8c:	6a 00                	push   $0x0
     b8e:	50                   	push   %eax
     b8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
     b92:	e8 09 03 00 00       	call   ea0 <memset>
  cmd->type = BACK;
     b97:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  cmd->cmd = subcmd;
     b9a:	83 c4 10             	add    $0x10,%esp
  cmd->type = BACK;
     b9d:	c7 02 05 00 00 00    	movl   $0x5,(%edx)
  cmd->cmd = subcmd;
     ba3:	89 5a 04             	mov    %ebx,0x4(%edx)
     ba6:	89 d3                	mov    %edx,%ebx
  while(peek(ps, es, "&")){
     ba8:	83 ec 04             	sub    $0x4,%esp
     bab:	68 4a 15 00 00       	push   $0x154a
     bb0:	57                   	push   %edi
     bb1:	56                   	push   %esi
     bb2:	e8 29 fc ff ff       	call   7e0 <peek>
     bb7:	83 c4 10             	add    $0x10,%esp
     bba:	85 c0                	test   %eax,%eax
     bbc:	75 b2                	jne    b70 <parseline+0x20>
  if(peek(ps, es, ";")){
     bbe:	83 ec 04             	sub    $0x4,%esp
     bc1:	68 46 15 00 00       	push   $0x1546
     bc6:	57                   	push   %edi
     bc7:	56                   	push   %esi
     bc8:	e8 13 fc ff ff       	call   7e0 <peek>
     bcd:	83 c4 10             	add    $0x10,%esp
     bd0:	85 c0                	test   %eax,%eax
     bd2:	75 0c                	jne    be0 <parseline+0x90>
}
     bd4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     bd7:	89 d8                	mov    %ebx,%eax
     bd9:	5b                   	pop    %ebx
     bda:	5e                   	pop    %esi
     bdb:	5f                   	pop    %edi
     bdc:	5d                   	pop    %ebp
     bdd:	c3                   	ret    
     bde:	66 90                	xchg   %ax,%ax
    gettoken(ps, es, 0, 0);
     be0:	6a 00                	push   $0x0
     be2:	6a 00                	push   $0x0
     be4:	57                   	push   %edi
     be5:	56                   	push   %esi
     be6:	e8 95 fa ff ff       	call   680 <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
     beb:	58                   	pop    %eax
     bec:	5a                   	pop    %edx
     bed:	57                   	push   %edi
     bee:	56                   	push   %esi
     bef:	e8 5c ff ff ff       	call   b50 <parseline>
  cmd = malloc(sizeof(*cmd));
     bf4:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
    cmd = listcmd(cmd, parseline(ps, es));
     bfb:	89 c7                	mov    %eax,%edi
  cmd = malloc(sizeof(*cmd));
     bfd:	e8 de 07 00 00       	call   13e0 <malloc>
  memset(cmd, 0, sizeof(*cmd));
     c02:	83 c4 0c             	add    $0xc,%esp
     c05:	6a 0c                	push   $0xc
  cmd = malloc(sizeof(*cmd));
     c07:	89 c6                	mov    %eax,%esi
  memset(cmd, 0, sizeof(*cmd));
     c09:	6a 00                	push   $0x0
     c0b:	50                   	push   %eax
     c0c:	e8 8f 02 00 00       	call   ea0 <memset>
  cmd->left = left;
     c11:	89 5e 04             	mov    %ebx,0x4(%esi)
  cmd->right = right;
     c14:	83 c4 10             	add    $0x10,%esp
     c17:	89 f3                	mov    %esi,%ebx
  cmd->type = LIST;
     c19:	c7 06 04 00 00 00    	movl   $0x4,(%esi)
}
     c1f:	89 d8                	mov    %ebx,%eax
  cmd->right = right;
     c21:	89 7e 08             	mov    %edi,0x8(%esi)
}
     c24:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c27:	5b                   	pop    %ebx
     c28:	5e                   	pop    %esi
     c29:	5f                   	pop    %edi
     c2a:	5d                   	pop    %ebp
     c2b:	c3                   	ret    
     c2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000c30 <parseblock>:
{
     c30:	55                   	push   %ebp
     c31:	89 e5                	mov    %esp,%ebp
     c33:	57                   	push   %edi
     c34:	56                   	push   %esi
     c35:	53                   	push   %ebx
     c36:	83 ec 10             	sub    $0x10,%esp
     c39:	8b 5d 08             	mov    0x8(%ebp),%ebx
     c3c:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
     c3f:	68 2c 15 00 00       	push   $0x152c
     c44:	56                   	push   %esi
     c45:	53                   	push   %ebx
     c46:	e8 95 fb ff ff       	call   7e0 <peek>
     c4b:	83 c4 10             	add    $0x10,%esp
     c4e:	85 c0                	test   %eax,%eax
     c50:	74 4a                	je     c9c <parseblock+0x6c>
  gettoken(ps, es, 0, 0);
     c52:	6a 00                	push   $0x0
     c54:	6a 00                	push   $0x0
     c56:	56                   	push   %esi
     c57:	53                   	push   %ebx
     c58:	e8 23 fa ff ff       	call   680 <gettoken>
  cmd = parseline(ps, es);
     c5d:	58                   	pop    %eax
     c5e:	5a                   	pop    %edx
     c5f:	56                   	push   %esi
     c60:	53                   	push   %ebx
     c61:	e8 ea fe ff ff       	call   b50 <parseline>
  if(!peek(ps, es, ")"))
     c66:	83 c4 0c             	add    $0xc,%esp
     c69:	68 68 15 00 00       	push   $0x1568
  cmd = parseline(ps, es);
     c6e:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
     c70:	56                   	push   %esi
     c71:	53                   	push   %ebx
     c72:	e8 69 fb ff ff       	call   7e0 <peek>
     c77:	83 c4 10             	add    $0x10,%esp
     c7a:	85 c0                	test   %eax,%eax
     c7c:	74 2b                	je     ca9 <parseblock+0x79>
  gettoken(ps, es, 0, 0);
     c7e:	6a 00                	push   $0x0
     c80:	6a 00                	push   $0x0
     c82:	56                   	push   %esi
     c83:	53                   	push   %ebx
     c84:	e8 f7 f9 ff ff       	call   680 <gettoken>
  cmd = parseredirs(cmd, ps, es);
     c89:	83 c4 0c             	add    $0xc,%esp
     c8c:	56                   	push   %esi
     c8d:	53                   	push   %ebx
     c8e:	57                   	push   %edi
     c8f:	e8 cc fb ff ff       	call   860 <parseredirs>
}
     c94:	8d 65 f4             	lea    -0xc(%ebp),%esp
     c97:	5b                   	pop    %ebx
     c98:	5e                   	pop    %esi
     c99:	5f                   	pop    %edi
     c9a:	5d                   	pop    %ebp
     c9b:	c3                   	ret    
    panic("parseblock");
     c9c:	83 ec 0c             	sub    $0xc,%esp
     c9f:	68 4c 15 00 00       	push   $0x154c
     ca4:	e8 d7 f6 ff ff       	call   380 <panic>
    panic("syntax - missing )");
     ca9:	83 ec 0c             	sub    $0xc,%esp
     cac:	68 57 15 00 00       	push   $0x1557
     cb1:	e8 ca f6 ff ff       	call   380 <panic>
     cb6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     cbd:	8d 76 00             	lea    0x0(%esi),%esi

00000cc0 <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
     cc0:	55                   	push   %ebp
     cc1:	89 e5                	mov    %esp,%ebp
     cc3:	53                   	push   %ebx
     cc4:	83 ec 04             	sub    $0x4,%esp
     cc7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
     cca:	85 db                	test   %ebx,%ebx
     ccc:	0f 84 8e 00 00 00    	je     d60 <nulterminate+0xa0>
    return 0;

  switch(cmd->type){
     cd2:	83 3b 05             	cmpl   $0x5,(%ebx)
     cd5:	77 61                	ja     d38 <nulterminate+0x78>
     cd7:	8b 03                	mov    (%ebx),%eax
     cd9:	ff 24 85 bc 15 00 00 	jmp    *0x15bc(,%eax,4)
    nulterminate(pcmd->right);
    break;

  case LIST:
    lcmd = (struct listcmd*)cmd;
    nulterminate(lcmd->left);
     ce0:	83 ec 0c             	sub    $0xc,%esp
     ce3:	ff 73 04             	push   0x4(%ebx)
     ce6:	e8 d5 ff ff ff       	call   cc0 <nulterminate>
    nulterminate(lcmd->right);
     ceb:	58                   	pop    %eax
     cec:	ff 73 08             	push   0x8(%ebx)
     cef:	e8 cc ff ff ff       	call   cc0 <nulterminate>
    break;
     cf4:	83 c4 10             	add    $0x10,%esp
     cf7:	89 d8                	mov    %ebx,%eax
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
     cf9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     cfc:	c9                   	leave  
     cfd:	c3                   	ret    
     cfe:	66 90                	xchg   %ax,%ax
    nulterminate(bcmd->cmd);
     d00:	83 ec 0c             	sub    $0xc,%esp
     d03:	ff 73 04             	push   0x4(%ebx)
     d06:	e8 b5 ff ff ff       	call   cc0 <nulterminate>
    break;
     d0b:	89 d8                	mov    %ebx,%eax
     d0d:	83 c4 10             	add    $0x10,%esp
}
     d10:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d13:	c9                   	leave  
     d14:	c3                   	ret    
     d15:	8d 76 00             	lea    0x0(%esi),%esi
    for(i=0; ecmd->argv[i]; i++)
     d18:	8b 4b 04             	mov    0x4(%ebx),%ecx
     d1b:	8d 43 08             	lea    0x8(%ebx),%eax
     d1e:	85 c9                	test   %ecx,%ecx
     d20:	74 16                	je     d38 <nulterminate+0x78>
     d22:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      *ecmd->eargv[i] = 0;
     d28:	8b 50 24             	mov    0x24(%eax),%edx
    for(i=0; ecmd->argv[i]; i++)
     d2b:	83 c0 04             	add    $0x4,%eax
      *ecmd->eargv[i] = 0;
     d2e:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
     d31:	8b 50 fc             	mov    -0x4(%eax),%edx
     d34:	85 d2                	test   %edx,%edx
     d36:	75 f0                	jne    d28 <nulterminate+0x68>
  switch(cmd->type){
     d38:	89 d8                	mov    %ebx,%eax
}
     d3a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d3d:	c9                   	leave  
     d3e:	c3                   	ret    
     d3f:	90                   	nop
    nulterminate(rcmd->cmd);
     d40:	83 ec 0c             	sub    $0xc,%esp
     d43:	ff 73 04             	push   0x4(%ebx)
     d46:	e8 75 ff ff ff       	call   cc0 <nulterminate>
    *rcmd->efile = 0;
     d4b:	8b 43 0c             	mov    0xc(%ebx),%eax
    break;
     d4e:	83 c4 10             	add    $0x10,%esp
    *rcmd->efile = 0;
     d51:	c6 00 00             	movb   $0x0,(%eax)
    break;
     d54:	89 d8                	mov    %ebx,%eax
}
     d56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     d59:	c9                   	leave  
     d5a:	c3                   	ret    
     d5b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d5f:	90                   	nop
    return 0;
     d60:	31 c0                	xor    %eax,%eax
     d62:	eb 95                	jmp    cf9 <nulterminate+0x39>
     d64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     d6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     d6f:	90                   	nop

00000d70 <parsecmd>:
{
     d70:	55                   	push   %ebp
     d71:	89 e5                	mov    %esp,%ebp
     d73:	57                   	push   %edi
     d74:	56                   	push   %esi
  cmd = parseline(&s, es);
     d75:	8d 7d 08             	lea    0x8(%ebp),%edi
{
     d78:	53                   	push   %ebx
     d79:	83 ec 18             	sub    $0x18,%esp
  es = s + strlen(s);
     d7c:	8b 5d 08             	mov    0x8(%ebp),%ebx
     d7f:	53                   	push   %ebx
     d80:	e8 eb 00 00 00       	call   e70 <strlen>
  cmd = parseline(&s, es);
     d85:	59                   	pop    %ecx
     d86:	5e                   	pop    %esi
  es = s + strlen(s);
     d87:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
     d89:	53                   	push   %ebx
     d8a:	57                   	push   %edi
     d8b:	e8 c0 fd ff ff       	call   b50 <parseline>
  peek(&s, es, "");
     d90:	83 c4 0c             	add    $0xc,%esp
     d93:	68 f6 14 00 00       	push   $0x14f6
  cmd = parseline(&s, es);
     d98:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
     d9a:	53                   	push   %ebx
     d9b:	57                   	push   %edi
     d9c:	e8 3f fa ff ff       	call   7e0 <peek>
  if(s != es){
     da1:	8b 45 08             	mov    0x8(%ebp),%eax
     da4:	83 c4 10             	add    $0x10,%esp
     da7:	39 d8                	cmp    %ebx,%eax
     da9:	75 13                	jne    dbe <parsecmd+0x4e>
  nulterminate(cmd);
     dab:	83 ec 0c             	sub    $0xc,%esp
     dae:	56                   	push   %esi
     daf:	e8 0c ff ff ff       	call   cc0 <nulterminate>
}
     db4:	8d 65 f4             	lea    -0xc(%ebp),%esp
     db7:	89 f0                	mov    %esi,%eax
     db9:	5b                   	pop    %ebx
     dba:	5e                   	pop    %esi
     dbb:	5f                   	pop    %edi
     dbc:	5d                   	pop    %ebp
     dbd:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
     dbe:	52                   	push   %edx
     dbf:	50                   	push   %eax
     dc0:	68 6a 15 00 00       	push   $0x156a
     dc5:	6a 02                	push   $0x2
     dc7:	e8 e4 03 00 00       	call   11b0 <printf>
    panic("syntax");
     dcc:	c7 04 24 2e 15 00 00 	movl   $0x152e,(%esp)
     dd3:	e8 a8 f5 ff ff       	call   380 <panic>
     dd8:	66 90                	xchg   %ax,%ax
     dda:	66 90                	xchg   %ax,%ax
     ddc:	66 90                	xchg   %ax,%ax
     dde:	66 90                	xchg   %ax,%ax

00000de0 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
     de0:	55                   	push   %ebp
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     de1:	31 c0                	xor    %eax,%eax
{
     de3:	89 e5                	mov    %esp,%ebp
     de5:	53                   	push   %ebx
     de6:	8b 4d 08             	mov    0x8(%ebp),%ecx
     de9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
     dec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  while((*s++ = *t++) != 0)
     df0:	0f b6 14 03          	movzbl (%ebx,%eax,1),%edx
     df4:	88 14 01             	mov    %dl,(%ecx,%eax,1)
     df7:	83 c0 01             	add    $0x1,%eax
     dfa:	84 d2                	test   %dl,%dl
     dfc:	75 f2                	jne    df0 <strcpy+0x10>
    ;
  return os;
}
     dfe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e01:	89 c8                	mov    %ecx,%eax
     e03:	c9                   	leave  
     e04:	c3                   	ret    
     e05:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00000e10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     e10:	55                   	push   %ebp
     e11:	89 e5                	mov    %esp,%ebp
     e13:	53                   	push   %ebx
     e14:	8b 55 08             	mov    0x8(%ebp),%edx
     e17:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  while(*p && *p == *q)
     e1a:	0f b6 02             	movzbl (%edx),%eax
     e1d:	84 c0                	test   %al,%al
     e1f:	75 17                	jne    e38 <strcmp+0x28>
     e21:	eb 3a                	jmp    e5d <strcmp+0x4d>
     e23:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e27:	90                   	nop
     e28:	0f b6 42 01          	movzbl 0x1(%edx),%eax
    p++, q++;
     e2c:	83 c2 01             	add    $0x1,%edx
     e2f:	8d 59 01             	lea    0x1(%ecx),%ebx
  while(*p && *p == *q)
     e32:	84 c0                	test   %al,%al
     e34:	74 1a                	je     e50 <strcmp+0x40>
    p++, q++;
     e36:	89 d9                	mov    %ebx,%ecx
  while(*p && *p == *q)
     e38:	0f b6 19             	movzbl (%ecx),%ebx
     e3b:	38 c3                	cmp    %al,%bl
     e3d:	74 e9                	je     e28 <strcmp+0x18>
  return (uchar)*p - (uchar)*q;
     e3f:	29 d8                	sub    %ebx,%eax
}
     e41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e44:	c9                   	leave  
     e45:	c3                   	ret    
     e46:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e4d:	8d 76 00             	lea    0x0(%esi),%esi
  return (uchar)*p - (uchar)*q;
     e50:	0f b6 59 01          	movzbl 0x1(%ecx),%ebx
     e54:	31 c0                	xor    %eax,%eax
     e56:	29 d8                	sub    %ebx,%eax
}
     e58:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     e5b:	c9                   	leave  
     e5c:	c3                   	ret    
  return (uchar)*p - (uchar)*q;
     e5d:	0f b6 19             	movzbl (%ecx),%ebx
     e60:	31 c0                	xor    %eax,%eax
     e62:	eb db                	jmp    e3f <strcmp+0x2f>
     e64:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e6b:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     e6f:	90                   	nop

00000e70 <strlen>:

uint
strlen(const char *s)
{
     e70:	55                   	push   %ebp
     e71:	89 e5                	mov    %esp,%ebp
     e73:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
     e76:	80 3a 00             	cmpb   $0x0,(%edx)
     e79:	74 15                	je     e90 <strlen+0x20>
     e7b:	31 c0                	xor    %eax,%eax
     e7d:	8d 76 00             	lea    0x0(%esi),%esi
     e80:	83 c0 01             	add    $0x1,%eax
     e83:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
     e87:	89 c1                	mov    %eax,%ecx
     e89:	75 f5                	jne    e80 <strlen+0x10>
    ;
  return n;
}
     e8b:	89 c8                	mov    %ecx,%eax
     e8d:	5d                   	pop    %ebp
     e8e:	c3                   	ret    
     e8f:	90                   	nop
  for(n = 0; s[n]; n++)
     e90:	31 c9                	xor    %ecx,%ecx
}
     e92:	5d                   	pop    %ebp
     e93:	89 c8                	mov    %ecx,%eax
     e95:	c3                   	ret    
     e96:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     e9d:	8d 76 00             	lea    0x0(%esi),%esi

00000ea0 <memset>:

void*
memset(void *dst, int c, uint n)
{
     ea0:	55                   	push   %ebp
     ea1:	89 e5                	mov    %esp,%ebp
     ea3:	57                   	push   %edi
     ea4:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
     ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
     eaa:	8b 45 0c             	mov    0xc(%ebp),%eax
     ead:	89 d7                	mov    %edx,%edi
     eaf:	fc                   	cld    
     eb0:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
     eb2:	8b 7d fc             	mov    -0x4(%ebp),%edi
     eb5:	89 d0                	mov    %edx,%eax
     eb7:	c9                   	leave  
     eb8:	c3                   	ret    
     eb9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

00000ec0 <strchr>:

char*
strchr(const char *s, char c)
{
     ec0:	55                   	push   %ebp
     ec1:	89 e5                	mov    %esp,%ebp
     ec3:	8b 45 08             	mov    0x8(%ebp),%eax
     ec6:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
     eca:	0f b6 10             	movzbl (%eax),%edx
     ecd:	84 d2                	test   %dl,%dl
     ecf:	75 12                	jne    ee3 <strchr+0x23>
     ed1:	eb 1d                	jmp    ef0 <strchr+0x30>
     ed3:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     ed7:	90                   	nop
     ed8:	0f b6 50 01          	movzbl 0x1(%eax),%edx
     edc:	83 c0 01             	add    $0x1,%eax
     edf:	84 d2                	test   %dl,%dl
     ee1:	74 0d                	je     ef0 <strchr+0x30>
    if(*s == c)
     ee3:	38 d1                	cmp    %dl,%cl
     ee5:	75 f1                	jne    ed8 <strchr+0x18>
      return (char*)s;
  return 0;
}
     ee7:	5d                   	pop    %ebp
     ee8:	c3                   	ret    
     ee9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  return 0;
     ef0:	31 c0                	xor    %eax,%eax
}
     ef2:	5d                   	pop    %ebp
     ef3:	c3                   	ret    
     ef4:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     efb:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
     eff:	90                   	nop

00000f00 <gets>:

char*
gets(char *buf, int max)
{
     f00:	55                   	push   %ebp
     f01:	89 e5                	mov    %esp,%ebp
     f03:	57                   	push   %edi
     f04:	56                   	push   %esi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    cc = read(0, &c, 1);
     f05:	8d 7d e7             	lea    -0x19(%ebp),%edi
{
     f08:	53                   	push   %ebx
  for(i=0; i+1 < max; ){
     f09:	31 db                	xor    %ebx,%ebx
{
     f0b:	83 ec 1c             	sub    $0x1c,%esp
  for(i=0; i+1 < max; ){
     f0e:	eb 27                	jmp    f37 <gets+0x37>
    cc = read(0, &c, 1);
     f10:	83 ec 04             	sub    $0x4,%esp
     f13:	6a 01                	push   $0x1
     f15:	57                   	push   %edi
     f16:	6a 00                	push   $0x0
     f18:	e8 2e 01 00 00       	call   104b <read>
    if(cc < 1)
     f1d:	83 c4 10             	add    $0x10,%esp
     f20:	85 c0                	test   %eax,%eax
     f22:	7e 1d                	jle    f41 <gets+0x41>
      break;
    buf[i++] = c;
     f24:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
     f28:	8b 55 08             	mov    0x8(%ebp),%edx
     f2b:	88 44 1a ff          	mov    %al,-0x1(%edx,%ebx,1)
    if(c == '\n' || c == '\r')
     f2f:	3c 0a                	cmp    $0xa,%al
     f31:	74 1d                	je     f50 <gets+0x50>
     f33:	3c 0d                	cmp    $0xd,%al
     f35:	74 19                	je     f50 <gets+0x50>
  for(i=0; i+1 < max; ){
     f37:	89 de                	mov    %ebx,%esi
     f39:	83 c3 01             	add    $0x1,%ebx
     f3c:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
     f3f:	7c cf                	jl     f10 <gets+0x10>
      break;
  }
  buf[i] = '\0';
     f41:	8b 45 08             	mov    0x8(%ebp),%eax
     f44:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
  return buf;
}
     f48:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f4b:	5b                   	pop    %ebx
     f4c:	5e                   	pop    %esi
     f4d:	5f                   	pop    %edi
     f4e:	5d                   	pop    %ebp
     f4f:	c3                   	ret    
  buf[i] = '\0';
     f50:	8b 45 08             	mov    0x8(%ebp),%eax
     f53:	89 de                	mov    %ebx,%esi
     f55:	c6 04 30 00          	movb   $0x0,(%eax,%esi,1)
}
     f59:	8d 65 f4             	lea    -0xc(%ebp),%esp
     f5c:	5b                   	pop    %ebx
     f5d:	5e                   	pop    %esi
     f5e:	5f                   	pop    %edi
     f5f:	5d                   	pop    %ebp
     f60:	c3                   	ret    
     f61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f68:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     f6f:	90                   	nop

00000f70 <stat>:

int
stat(const char *n, struct stat *st)
{
     f70:	55                   	push   %ebp
     f71:	89 e5                	mov    %esp,%ebp
     f73:	56                   	push   %esi
     f74:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     f75:	83 ec 08             	sub    $0x8,%esp
     f78:	6a 00                	push   $0x0
     f7a:	ff 75 08             	push   0x8(%ebp)
     f7d:	e8 f1 00 00 00       	call   1073 <open>
  if(fd < 0)
     f82:	83 c4 10             	add    $0x10,%esp
     f85:	85 c0                	test   %eax,%eax
     f87:	78 27                	js     fb0 <stat+0x40>
    return -1;
  r = fstat(fd, st);
     f89:	83 ec 08             	sub    $0x8,%esp
     f8c:	ff 75 0c             	push   0xc(%ebp)
     f8f:	89 c3                	mov    %eax,%ebx
     f91:	50                   	push   %eax
     f92:	e8 f4 00 00 00       	call   108b <fstat>
  close(fd);
     f97:	89 1c 24             	mov    %ebx,(%esp)
  r = fstat(fd, st);
     f9a:	89 c6                	mov    %eax,%esi
  close(fd);
     f9c:	e8 ba 00 00 00       	call   105b <close>
  return r;
     fa1:	83 c4 10             	add    $0x10,%esp
}
     fa4:	8d 65 f8             	lea    -0x8(%ebp),%esp
     fa7:	89 f0                	mov    %esi,%eax
     fa9:	5b                   	pop    %ebx
     faa:	5e                   	pop    %esi
     fab:	5d                   	pop    %ebp
     fac:	c3                   	ret    
     fad:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
     fb0:	be ff ff ff ff       	mov    $0xffffffff,%esi
     fb5:	eb ed                	jmp    fa4 <stat+0x34>
     fb7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fbe:	66 90                	xchg   %ax,%ax

00000fc0 <atoi>:

int
atoi(const char *s)
{
     fc0:	55                   	push   %ebp
     fc1:	89 e5                	mov    %esp,%ebp
     fc3:	53                   	push   %ebx
     fc4:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     fc7:	0f be 02             	movsbl (%edx),%eax
     fca:	8d 48 d0             	lea    -0x30(%eax),%ecx
     fcd:	80 f9 09             	cmp    $0x9,%cl
  n = 0;
     fd0:	b9 00 00 00 00       	mov    $0x0,%ecx
  while('0' <= *s && *s <= '9')
     fd5:	77 1e                	ja     ff5 <atoi+0x35>
     fd7:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
     fde:	66 90                	xchg   %ax,%ax
    n = n*10 + *s++ - '0';
     fe0:	83 c2 01             	add    $0x1,%edx
     fe3:	8d 0c 89             	lea    (%ecx,%ecx,4),%ecx
     fe6:	8d 4c 48 d0          	lea    -0x30(%eax,%ecx,2),%ecx
  while('0' <= *s && *s <= '9')
     fea:	0f be 02             	movsbl (%edx),%eax
     fed:	8d 58 d0             	lea    -0x30(%eax),%ebx
     ff0:	80 fb 09             	cmp    $0x9,%bl
     ff3:	76 eb                	jbe    fe0 <atoi+0x20>
  return n;
}
     ff5:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     ff8:	89 c8                	mov    %ecx,%eax
     ffa:	c9                   	leave  
     ffb:	c3                   	ret    
     ffc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

00001000 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1000:	55                   	push   %ebp
    1001:	89 e5                	mov    %esp,%ebp
    1003:	57                   	push   %edi
    1004:	8b 45 10             	mov    0x10(%ebp),%eax
    1007:	8b 55 08             	mov    0x8(%ebp),%edx
    100a:	56                   	push   %esi
    100b:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  while(n-- > 0)
    100e:	85 c0                	test   %eax,%eax
    1010:	7e 13                	jle    1025 <memmove+0x25>
    1012:	01 d0                	add    %edx,%eax
  dst = vdst;
    1014:	89 d7                	mov    %edx,%edi
    1016:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    101d:	8d 76 00             	lea    0x0(%esi),%esi
    *dst++ = *src++;
    1020:	a4                   	movsb  %ds:(%esi),%es:(%edi)
  while(n-- > 0)
    1021:	39 f8                	cmp    %edi,%eax
    1023:	75 fb                	jne    1020 <memmove+0x20>
  return vdst;
}
    1025:	5e                   	pop    %esi
    1026:	89 d0                	mov    %edx,%eax
    1028:	5f                   	pop    %edi
    1029:	5d                   	pop    %ebp
    102a:	c3                   	ret    

0000102b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    102b:	b8 01 00 00 00       	mov    $0x1,%eax
    1030:	cd 40                	int    $0x40
    1032:	c3                   	ret    

00001033 <exit>:
SYSCALL(exit)
    1033:	b8 02 00 00 00       	mov    $0x2,%eax
    1038:	cd 40                	int    $0x40
    103a:	c3                   	ret    

0000103b <wait>:
SYSCALL(wait)
    103b:	b8 03 00 00 00       	mov    $0x3,%eax
    1040:	cd 40                	int    $0x40
    1042:	c3                   	ret    

00001043 <pipe>:
SYSCALL(pipe)
    1043:	b8 04 00 00 00       	mov    $0x4,%eax
    1048:	cd 40                	int    $0x40
    104a:	c3                   	ret    

0000104b <read>:
SYSCALL(read)
    104b:	b8 05 00 00 00       	mov    $0x5,%eax
    1050:	cd 40                	int    $0x40
    1052:	c3                   	ret    

00001053 <write>:
SYSCALL(write)
    1053:	b8 10 00 00 00       	mov    $0x10,%eax
    1058:	cd 40                	int    $0x40
    105a:	c3                   	ret    

0000105b <close>:
SYSCALL(close)
    105b:	b8 15 00 00 00       	mov    $0x15,%eax
    1060:	cd 40                	int    $0x40
    1062:	c3                   	ret    

00001063 <kill>:
SYSCALL(kill)
    1063:	b8 06 00 00 00       	mov    $0x6,%eax
    1068:	cd 40                	int    $0x40
    106a:	c3                   	ret    

0000106b <exec>:
SYSCALL(exec)
    106b:	b8 07 00 00 00       	mov    $0x7,%eax
    1070:	cd 40                	int    $0x40
    1072:	c3                   	ret    

00001073 <open>:
SYSCALL(open)
    1073:	b8 0f 00 00 00       	mov    $0xf,%eax
    1078:	cd 40                	int    $0x40
    107a:	c3                   	ret    

0000107b <mknod>:
SYSCALL(mknod)
    107b:	b8 11 00 00 00       	mov    $0x11,%eax
    1080:	cd 40                	int    $0x40
    1082:	c3                   	ret    

00001083 <unlink>:
SYSCALL(unlink)
    1083:	b8 12 00 00 00       	mov    $0x12,%eax
    1088:	cd 40                	int    $0x40
    108a:	c3                   	ret    

0000108b <fstat>:
SYSCALL(fstat)
    108b:	b8 08 00 00 00       	mov    $0x8,%eax
    1090:	cd 40                	int    $0x40
    1092:	c3                   	ret    

00001093 <link>:
SYSCALL(link)
    1093:	b8 13 00 00 00       	mov    $0x13,%eax
    1098:	cd 40                	int    $0x40
    109a:	c3                   	ret    

0000109b <mkdir>:
SYSCALL(mkdir)
    109b:	b8 14 00 00 00       	mov    $0x14,%eax
    10a0:	cd 40                	int    $0x40
    10a2:	c3                   	ret    

000010a3 <chdir>:
SYSCALL(chdir)
    10a3:	b8 09 00 00 00       	mov    $0x9,%eax
    10a8:	cd 40                	int    $0x40
    10aa:	c3                   	ret    

000010ab <dup>:
SYSCALL(dup)
    10ab:	b8 0a 00 00 00       	mov    $0xa,%eax
    10b0:	cd 40                	int    $0x40
    10b2:	c3                   	ret    

000010b3 <getpid>:
SYSCALL(getpid)
    10b3:	b8 0b 00 00 00       	mov    $0xb,%eax
    10b8:	cd 40                	int    $0x40
    10ba:	c3                   	ret    

000010bb <sbrk>:
SYSCALL(sbrk)
    10bb:	b8 0c 00 00 00       	mov    $0xc,%eax
    10c0:	cd 40                	int    $0x40
    10c2:	c3                   	ret    

000010c3 <sleep>:
SYSCALL(sleep)
    10c3:	b8 0d 00 00 00       	mov    $0xd,%eax
    10c8:	cd 40                	int    $0x40
    10ca:	c3                   	ret    

000010cb <uptime>:
SYSCALL(uptime)
    10cb:	b8 0e 00 00 00       	mov    $0xe,%eax
    10d0:	cd 40                	int    $0x40
    10d2:	c3                   	ret    

000010d3 <gethistory>:
SYSCALL(gethistory)
    10d3:	b8 16 00 00 00       	mov    $0x16,%eax
    10d8:	cd 40                	int    $0x40
    10da:	c3                   	ret    

000010db <block>:
SYSCALL(block)
    10db:	b8 17 00 00 00       	mov    $0x17,%eax
    10e0:	cd 40                	int    $0x40
    10e2:	c3                   	ret    

000010e3 <unblock>:
SYSCALL(unblock)
    10e3:	b8 18 00 00 00       	mov    $0x18,%eax
    10e8:	cd 40                	int    $0x40
    10ea:	c3                   	ret    

000010eb <chmod>:
SYSCALL(chmod)
    10eb:	b8 19 00 00 00       	mov    $0x19,%eax
    10f0:	cd 40                	int    $0x40
    10f2:	c3                   	ret    
    10f3:	66 90                	xchg   %ax,%ax
    10f5:	66 90                	xchg   %ax,%ax
    10f7:	66 90                	xchg   %ax,%ax
    10f9:	66 90                	xchg   %ax,%ax
    10fb:	66 90                	xchg   %ax,%ax
    10fd:	66 90                	xchg   %ax,%ax
    10ff:	90                   	nop

00001100 <printint>:
  write(fd, &c, 1);
}

static void
printint(int fd, int xx, int base, int sgn)
{
    1100:	55                   	push   %ebp
    1101:	89 e5                	mov    %esp,%ebp
    1103:	57                   	push   %edi
    1104:	56                   	push   %esi
    1105:	53                   	push   %ebx
    1106:	83 ec 3c             	sub    $0x3c,%esp
    1109:	89 4d c4             	mov    %ecx,-0x3c(%ebp)
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    neg = 1;
    x = -xx;
    110c:	89 d1                	mov    %edx,%ecx
{
    110e:	89 45 b8             	mov    %eax,-0x48(%ebp)
  if(sgn && xx < 0){
    1111:	85 d2                	test   %edx,%edx
    1113:	0f 89 7f 00 00 00    	jns    1198 <printint+0x98>
    1119:	f6 45 08 01          	testb  $0x1,0x8(%ebp)
    111d:	74 79                	je     1198 <printint+0x98>
    neg = 1;
    111f:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
    x = -xx;
    1126:	f7 d9                	neg    %ecx
  } else {
    x = xx;
  }

  i = 0;
    1128:	31 db                	xor    %ebx,%ebx
    112a:	8d 75 d7             	lea    -0x29(%ebp),%esi
    112d:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
    1130:	89 c8                	mov    %ecx,%eax
    1132:	31 d2                	xor    %edx,%edx
    1134:	89 cf                	mov    %ecx,%edi
    1136:	f7 75 c4             	divl   -0x3c(%ebp)
    1139:	0f b6 92 60 16 00 00 	movzbl 0x1660(%edx),%edx
    1140:	89 45 c0             	mov    %eax,-0x40(%ebp)
    1143:	89 d8                	mov    %ebx,%eax
    1145:	8d 5b 01             	lea    0x1(%ebx),%ebx
  }while((x /= base) != 0);
    1148:	8b 4d c0             	mov    -0x40(%ebp),%ecx
    buf[i++] = digits[x % base];
    114b:	88 14 1e             	mov    %dl,(%esi,%ebx,1)
  }while((x /= base) != 0);
    114e:	39 7d c4             	cmp    %edi,-0x3c(%ebp)
    1151:	76 dd                	jbe    1130 <printint+0x30>
  if(neg)
    1153:	8b 4d bc             	mov    -0x44(%ebp),%ecx
    1156:	85 c9                	test   %ecx,%ecx
    1158:	74 0c                	je     1166 <printint+0x66>
    buf[i++] = '-';
    115a:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    buf[i++] = digits[x % base];
    115f:	89 d8                	mov    %ebx,%eax
    buf[i++] = '-';
    1161:	ba 2d 00 00 00       	mov    $0x2d,%edx

  while(--i >= 0)
    1166:	8b 7d b8             	mov    -0x48(%ebp),%edi
    1169:	8d 5c 05 d7          	lea    -0x29(%ebp,%eax,1),%ebx
    116d:	eb 07                	jmp    1176 <printint+0x76>
    116f:	90                   	nop
    putc(fd, buf[i]);
    1170:	0f b6 13             	movzbl (%ebx),%edx
    1173:	83 eb 01             	sub    $0x1,%ebx
  write(fd, &c, 1);
    1176:	83 ec 04             	sub    $0x4,%esp
    1179:	88 55 d7             	mov    %dl,-0x29(%ebp)
    117c:	6a 01                	push   $0x1
    117e:	56                   	push   %esi
    117f:	57                   	push   %edi
    1180:	e8 ce fe ff ff       	call   1053 <write>
  while(--i >= 0)
    1185:	83 c4 10             	add    $0x10,%esp
    1188:	39 de                	cmp    %ebx,%esi
    118a:	75 e4                	jne    1170 <printint+0x70>
}
    118c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    118f:	5b                   	pop    %ebx
    1190:	5e                   	pop    %esi
    1191:	5f                   	pop    %edi
    1192:	5d                   	pop    %ebp
    1193:	c3                   	ret    
    1194:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  neg = 0;
    1198:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
    119f:	eb 87                	jmp    1128 <printint+0x28>
    11a1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11a8:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11af:	90                   	nop

000011b0 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    11b0:	55                   	push   %ebp
    11b1:	89 e5                	mov    %esp,%ebp
    11b3:	57                   	push   %edi
    11b4:	56                   	push   %esi
    11b5:	53                   	push   %ebx
    11b6:	83 ec 2c             	sub    $0x2c,%esp
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
  for(i = 0; fmt[i]; i++){
    11b9:	8b 5d 0c             	mov    0xc(%ebp),%ebx
{
    11bc:	8b 75 08             	mov    0x8(%ebp),%esi
  for(i = 0; fmt[i]; i++){
    11bf:	0f b6 13             	movzbl (%ebx),%edx
    11c2:	84 d2                	test   %dl,%dl
    11c4:	74 6a                	je     1230 <printf+0x80>
  ap = (uint*)(void*)&fmt + 1;
    11c6:	8d 45 10             	lea    0x10(%ebp),%eax
    11c9:	83 c3 01             	add    $0x1,%ebx
  write(fd, &c, 1);
    11cc:	8d 7d e7             	lea    -0x19(%ebp),%edi
  state = 0;
    11cf:	31 c9                	xor    %ecx,%ecx
  ap = (uint*)(void*)&fmt + 1;
    11d1:	89 45 d0             	mov    %eax,-0x30(%ebp)
    11d4:	eb 36                	jmp    120c <printf+0x5c>
    11d6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    11dd:	8d 76 00             	lea    0x0(%esi),%esi
    11e0:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
    11e3:	b9 25 00 00 00       	mov    $0x25,%ecx
      if(c == '%'){
    11e8:	83 f8 25             	cmp    $0x25,%eax
    11eb:	74 15                	je     1202 <printf+0x52>
  write(fd, &c, 1);
    11ed:	83 ec 04             	sub    $0x4,%esp
    11f0:	88 55 e7             	mov    %dl,-0x19(%ebp)
    11f3:	6a 01                	push   $0x1
    11f5:	57                   	push   %edi
    11f6:	56                   	push   %esi
    11f7:	e8 57 fe ff ff       	call   1053 <write>
    11fc:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
      } else {
        putc(fd, c);
    11ff:	83 c4 10             	add    $0x10,%esp
  for(i = 0; fmt[i]; i++){
    1202:	0f b6 13             	movzbl (%ebx),%edx
    1205:	83 c3 01             	add    $0x1,%ebx
    1208:	84 d2                	test   %dl,%dl
    120a:	74 24                	je     1230 <printf+0x80>
    c = fmt[i] & 0xff;
    120c:	0f b6 c2             	movzbl %dl,%eax
    if(state == 0){
    120f:	85 c9                	test   %ecx,%ecx
    1211:	74 cd                	je     11e0 <printf+0x30>
      }
    } else if(state == '%'){
    1213:	83 f9 25             	cmp    $0x25,%ecx
    1216:	75 ea                	jne    1202 <printf+0x52>
      if(c == 'd'){
    1218:	83 f8 25             	cmp    $0x25,%eax
    121b:	0f 84 07 01 00 00    	je     1328 <printf+0x178>
    1221:	83 e8 63             	sub    $0x63,%eax
    1224:	83 f8 15             	cmp    $0x15,%eax
    1227:	77 17                	ja     1240 <printf+0x90>
    1229:	ff 24 85 08 16 00 00 	jmp    *0x1608(,%eax,4)
        putc(fd, c);
      }
      state = 0;
    }
  }
}
    1230:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1233:	5b                   	pop    %ebx
    1234:	5e                   	pop    %esi
    1235:	5f                   	pop    %edi
    1236:	5d                   	pop    %ebp
    1237:	c3                   	ret    
    1238:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    123f:	90                   	nop
  write(fd, &c, 1);
    1240:	83 ec 04             	sub    $0x4,%esp
    1243:	88 55 d4             	mov    %dl,-0x2c(%ebp)
    1246:	6a 01                	push   $0x1
    1248:	57                   	push   %edi
    1249:	56                   	push   %esi
    124a:	c6 45 e7 25          	movb   $0x25,-0x19(%ebp)
    124e:	e8 00 fe ff ff       	call   1053 <write>
        putc(fd, c);
    1253:	0f b6 55 d4          	movzbl -0x2c(%ebp),%edx
  write(fd, &c, 1);
    1257:	83 c4 0c             	add    $0xc,%esp
    125a:	88 55 e7             	mov    %dl,-0x19(%ebp)
    125d:	6a 01                	push   $0x1
    125f:	57                   	push   %edi
    1260:	56                   	push   %esi
    1261:	e8 ed fd ff ff       	call   1053 <write>
        putc(fd, c);
    1266:	83 c4 10             	add    $0x10,%esp
      state = 0;
    1269:	31 c9                	xor    %ecx,%ecx
    126b:	eb 95                	jmp    1202 <printf+0x52>
    126d:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 16, 0);
    1270:	83 ec 0c             	sub    $0xc,%esp
    1273:	b9 10 00 00 00       	mov    $0x10,%ecx
    1278:	6a 00                	push   $0x0
    127a:	8b 45 d0             	mov    -0x30(%ebp),%eax
    127d:	8b 10                	mov    (%eax),%edx
    127f:	89 f0                	mov    %esi,%eax
    1281:	e8 7a fe ff ff       	call   1100 <printint>
        ap++;
    1286:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    128a:	83 c4 10             	add    $0x10,%esp
      state = 0;
    128d:	31 c9                	xor    %ecx,%ecx
    128f:	e9 6e ff ff ff       	jmp    1202 <printf+0x52>
    1294:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = (char*)*ap;
    1298:	8b 45 d0             	mov    -0x30(%ebp),%eax
    129b:	8b 10                	mov    (%eax),%edx
        ap++;
    129d:	83 c0 04             	add    $0x4,%eax
    12a0:	89 45 d0             	mov    %eax,-0x30(%ebp)
        if(s == 0)
    12a3:	85 d2                	test   %edx,%edx
    12a5:	0f 84 8d 00 00 00    	je     1338 <printf+0x188>
        while(*s != 0){
    12ab:	0f b6 02             	movzbl (%edx),%eax
      state = 0;
    12ae:	31 c9                	xor    %ecx,%ecx
        while(*s != 0){
    12b0:	84 c0                	test   %al,%al
    12b2:	0f 84 4a ff ff ff    	je     1202 <printf+0x52>
    12b8:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    12bb:	89 d3                	mov    %edx,%ebx
    12bd:	8d 76 00             	lea    0x0(%esi),%esi
  write(fd, &c, 1);
    12c0:	83 ec 04             	sub    $0x4,%esp
          s++;
    12c3:	83 c3 01             	add    $0x1,%ebx
    12c6:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    12c9:	6a 01                	push   $0x1
    12cb:	57                   	push   %edi
    12cc:	56                   	push   %esi
    12cd:	e8 81 fd ff ff       	call   1053 <write>
        while(*s != 0){
    12d2:	0f b6 03             	movzbl (%ebx),%eax
    12d5:	83 c4 10             	add    $0x10,%esp
    12d8:	84 c0                	test   %al,%al
    12da:	75 e4                	jne    12c0 <printf+0x110>
      state = 0;
    12dc:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
    12df:	31 c9                	xor    %ecx,%ecx
    12e1:	e9 1c ff ff ff       	jmp    1202 <printf+0x52>
    12e6:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    12ed:	8d 76 00             	lea    0x0(%esi),%esi
        printint(fd, *ap, 10, 1);
    12f0:	83 ec 0c             	sub    $0xc,%esp
    12f3:	b9 0a 00 00 00       	mov    $0xa,%ecx
    12f8:	6a 01                	push   $0x1
    12fa:	e9 7b ff ff ff       	jmp    127a <printf+0xca>
    12ff:	90                   	nop
        putc(fd, *ap);
    1300:	8b 45 d0             	mov    -0x30(%ebp),%eax
  write(fd, &c, 1);
    1303:	83 ec 04             	sub    $0x4,%esp
        putc(fd, *ap);
    1306:	8b 00                	mov    (%eax),%eax
  write(fd, &c, 1);
    1308:	6a 01                	push   $0x1
    130a:	57                   	push   %edi
    130b:	56                   	push   %esi
        putc(fd, *ap);
    130c:	88 45 e7             	mov    %al,-0x19(%ebp)
  write(fd, &c, 1);
    130f:	e8 3f fd ff ff       	call   1053 <write>
        ap++;
    1314:	83 45 d0 04          	addl   $0x4,-0x30(%ebp)
    1318:	83 c4 10             	add    $0x10,%esp
      state = 0;
    131b:	31 c9                	xor    %ecx,%ecx
    131d:	e9 e0 fe ff ff       	jmp    1202 <printf+0x52>
    1322:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        putc(fd, c);
    1328:	88 55 e7             	mov    %dl,-0x19(%ebp)
  write(fd, &c, 1);
    132b:	83 ec 04             	sub    $0x4,%esp
    132e:	e9 2a ff ff ff       	jmp    125d <printf+0xad>
    1333:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    1337:	90                   	nop
          s = "(null)";
    1338:	ba 00 16 00 00       	mov    $0x1600,%edx
        while(*s != 0){
    133d:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
    1340:	b8 28 00 00 00       	mov    $0x28,%eax
    1345:	89 d3                	mov    %edx,%ebx
    1347:	e9 74 ff ff ff       	jmp    12c0 <printf+0x110>
    134c:	66 90                	xchg   %ax,%ax
    134e:	66 90                	xchg   %ax,%ax

00001350 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1350:	55                   	push   %ebp
  Header *bp, *p;

  bp = (Header*)ap - 1;
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1351:	a1 c4 1c 00 00       	mov    0x1cc4,%eax
{
    1356:	89 e5                	mov    %esp,%ebp
    1358:	57                   	push   %edi
    1359:	56                   	push   %esi
    135a:	53                   	push   %ebx
    135b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  bp = (Header*)ap - 1;
    135e:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1361:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    1368:	89 c2                	mov    %eax,%edx
    136a:	8b 00                	mov    (%eax),%eax
    136c:	39 ca                	cmp    %ecx,%edx
    136e:	73 30                	jae    13a0 <free+0x50>
    1370:	39 c1                	cmp    %eax,%ecx
    1372:	72 04                	jb     1378 <free+0x28>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1374:	39 c2                	cmp    %eax,%edx
    1376:	72 f0                	jb     1368 <free+0x18>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1378:	8b 73 fc             	mov    -0x4(%ebx),%esi
    137b:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    137e:	39 f8                	cmp    %edi,%eax
    1380:	74 30                	je     13b2 <free+0x62>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1382:	89 43 f8             	mov    %eax,-0x8(%ebx)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1385:	8b 42 04             	mov    0x4(%edx),%eax
    1388:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    138b:	39 f1                	cmp    %esi,%ecx
    138d:	74 3a                	je     13c9 <free+0x79>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    138f:	89 0a                	mov    %ecx,(%edx)
  } else
    p->s.ptr = bp;
  freep = p;
}
    1391:	5b                   	pop    %ebx
  freep = p;
    1392:	89 15 c4 1c 00 00    	mov    %edx,0x1cc4
}
    1398:	5e                   	pop    %esi
    1399:	5f                   	pop    %edi
    139a:	5d                   	pop    %ebp
    139b:	c3                   	ret    
    139c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    13a0:	39 c2                	cmp    %eax,%edx
    13a2:	72 c4                	jb     1368 <free+0x18>
    13a4:	39 c1                	cmp    %eax,%ecx
    13a6:	73 c0                	jae    1368 <free+0x18>
  if(bp + bp->s.size == p->s.ptr){
    13a8:	8b 73 fc             	mov    -0x4(%ebx),%esi
    13ab:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    13ae:	39 f8                	cmp    %edi,%eax
    13b0:	75 d0                	jne    1382 <free+0x32>
    bp->s.size += p->s.ptr->s.size;
    13b2:	03 70 04             	add    0x4(%eax),%esi
    13b5:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    13b8:	8b 02                	mov    (%edx),%eax
    13ba:	8b 00                	mov    (%eax),%eax
    13bc:	89 43 f8             	mov    %eax,-0x8(%ebx)
  if(p + p->s.size == bp){
    13bf:	8b 42 04             	mov    0x4(%edx),%eax
    13c2:	8d 34 c2             	lea    (%edx,%eax,8),%esi
    13c5:	39 f1                	cmp    %esi,%ecx
    13c7:	75 c6                	jne    138f <free+0x3f>
    p->s.size += bp->s.size;
    13c9:	03 43 fc             	add    -0x4(%ebx),%eax
  freep = p;
    13cc:	89 15 c4 1c 00 00    	mov    %edx,0x1cc4
    p->s.size += bp->s.size;
    13d2:	89 42 04             	mov    %eax,0x4(%edx)
    p->s.ptr = bp->s.ptr;
    13d5:	8b 4b f8             	mov    -0x8(%ebx),%ecx
    13d8:	89 0a                	mov    %ecx,(%edx)
}
    13da:	5b                   	pop    %ebx
    13db:	5e                   	pop    %esi
    13dc:	5f                   	pop    %edi
    13dd:	5d                   	pop    %ebp
    13de:	c3                   	ret    
    13df:	90                   	nop

000013e0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    13e0:	55                   	push   %ebp
    13e1:	89 e5                	mov    %esp,%ebp
    13e3:	57                   	push   %edi
    13e4:	56                   	push   %esi
    13e5:	53                   	push   %ebx
    13e6:	83 ec 1c             	sub    $0x1c,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13e9:	8b 45 08             	mov    0x8(%ebp),%eax
  if((prevp = freep) == 0){
    13ec:	8b 3d c4 1c 00 00    	mov    0x1cc4,%edi
  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    13f2:	8d 70 07             	lea    0x7(%eax),%esi
    13f5:	c1 ee 03             	shr    $0x3,%esi
    13f8:	83 c6 01             	add    $0x1,%esi
  if((prevp = freep) == 0){
    13fb:	85 ff                	test   %edi,%edi
    13fd:	0f 84 9d 00 00 00    	je     14a0 <malloc+0xc0>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1403:	8b 17                	mov    (%edi),%edx
    if(p->s.size >= nunits){
    1405:	8b 4a 04             	mov    0x4(%edx),%ecx
    1408:	39 f1                	cmp    %esi,%ecx
    140a:	73 6a                	jae    1476 <malloc+0x96>
    140c:	bb 00 10 00 00       	mov    $0x1000,%ebx
    1411:	39 de                	cmp    %ebx,%esi
    1413:	0f 43 de             	cmovae %esi,%ebx
  p = sbrk(nu * sizeof(Header));
    1416:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    141d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    1420:	eb 17                	jmp    1439 <malloc+0x59>
    1422:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1428:	8b 02                	mov    (%edx),%eax
    if(p->s.size >= nunits){
    142a:	8b 48 04             	mov    0x4(%eax),%ecx
    142d:	39 f1                	cmp    %esi,%ecx
    142f:	73 4f                	jae    1480 <malloc+0xa0>
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1431:	8b 3d c4 1c 00 00    	mov    0x1cc4,%edi
    1437:	89 c2                	mov    %eax,%edx
    1439:	39 d7                	cmp    %edx,%edi
    143b:	75 eb                	jne    1428 <malloc+0x48>
  p = sbrk(nu * sizeof(Header));
    143d:	83 ec 0c             	sub    $0xc,%esp
    1440:	ff 75 e4             	push   -0x1c(%ebp)
    1443:	e8 73 fc ff ff       	call   10bb <sbrk>
  if(p == (char*)-1)
    1448:	83 c4 10             	add    $0x10,%esp
    144b:	83 f8 ff             	cmp    $0xffffffff,%eax
    144e:	74 1c                	je     146c <malloc+0x8c>
  hp->s.size = nu;
    1450:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    1453:	83 ec 0c             	sub    $0xc,%esp
    1456:	83 c0 08             	add    $0x8,%eax
    1459:	50                   	push   %eax
    145a:	e8 f1 fe ff ff       	call   1350 <free>
  return freep;
    145f:	8b 15 c4 1c 00 00    	mov    0x1cc4,%edx
      if((p = morecore(nunits)) == 0)
    1465:	83 c4 10             	add    $0x10,%esp
    1468:	85 d2                	test   %edx,%edx
    146a:	75 bc                	jne    1428 <malloc+0x48>
        return 0;
  }
}
    146c:	8d 65 f4             	lea    -0xc(%ebp),%esp
        return 0;
    146f:	31 c0                	xor    %eax,%eax
}
    1471:	5b                   	pop    %ebx
    1472:	5e                   	pop    %esi
    1473:	5f                   	pop    %edi
    1474:	5d                   	pop    %ebp
    1475:	c3                   	ret    
    if(p->s.size >= nunits){
    1476:	89 d0                	mov    %edx,%eax
    1478:	89 fa                	mov    %edi,%edx
    147a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      if(p->s.size == nunits)
    1480:	39 ce                	cmp    %ecx,%esi
    1482:	74 4c                	je     14d0 <malloc+0xf0>
        p->s.size -= nunits;
    1484:	29 f1                	sub    %esi,%ecx
    1486:	89 48 04             	mov    %ecx,0x4(%eax)
        p += p->s.size;
    1489:	8d 04 c8             	lea    (%eax,%ecx,8),%eax
        p->s.size = nunits;
    148c:	89 70 04             	mov    %esi,0x4(%eax)
      freep = prevp;
    148f:	89 15 c4 1c 00 00    	mov    %edx,0x1cc4
}
    1495:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return (void*)(p + 1);
    1498:	83 c0 08             	add    $0x8,%eax
}
    149b:	5b                   	pop    %ebx
    149c:	5e                   	pop    %esi
    149d:	5f                   	pop    %edi
    149e:	5d                   	pop    %ebp
    149f:	c3                   	ret    
    base.s.ptr = freep = prevp = &base;
    14a0:	c7 05 c4 1c 00 00 c8 	movl   $0x1cc8,0x1cc4
    14a7:	1c 00 00 
    base.s.size = 0;
    14aa:	bf c8 1c 00 00       	mov    $0x1cc8,%edi
    base.s.ptr = freep = prevp = &base;
    14af:	c7 05 c8 1c 00 00 c8 	movl   $0x1cc8,0x1cc8
    14b6:	1c 00 00 
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14b9:	89 fa                	mov    %edi,%edx
    base.s.size = 0;
    14bb:	c7 05 cc 1c 00 00 00 	movl   $0x0,0x1ccc
    14c2:	00 00 00 
    if(p->s.size >= nunits){
    14c5:	e9 42 ff ff ff       	jmp    140c <malloc+0x2c>
    14ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
        prevp->s.ptr = p->s.ptr;
    14d0:	8b 08                	mov    (%eax),%ecx
    14d2:	89 0a                	mov    %ecx,(%edx)
    14d4:	eb b9                	jmp    148f <malloc+0xaf>
