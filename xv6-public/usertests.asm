
_usertests:     file format elf32-i386


Disassembly of section .text:

00000000 <iputtest>:
int stdout = 1;

// does chdir() call iput(p->cwd) in a transaction?
void
iputtest(void)
{
       0:	f3 0f 1e fb          	endbr32 
       4:	55                   	push   %ebp
       5:	89 e5                	mov    %esp,%ebp
       7:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "iput test\n");
       a:	68 6c 3c 00 00       	push   $0x3c6c
       f:	ff 35 08 5c 00 00    	pushl  0x5c08
      15:	e8 01 39 00 00       	call   391b <printf>

  if(mkdir("iputdir") < 0){
      1a:	c7 04 24 ff 3b 00 00 	movl   $0x3bff,(%esp)
      21:	e8 14 38 00 00       	call   383a <mkdir>
      26:	83 c4 10             	add    $0x10,%esp
      29:	85 c0                	test   %eax,%eax
      2b:	78 54                	js     81 <iputtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit();
  }
  if(chdir("iputdir") < 0){
      2d:	83 ec 0c             	sub    $0xc,%esp
      30:	68 ff 3b 00 00       	push   $0x3bff
      35:	e8 08 38 00 00       	call   3842 <chdir>
      3a:	83 c4 10             	add    $0x10,%esp
      3d:	85 c0                	test   %eax,%eax
      3f:	78 58                	js     99 <iputtest+0x99>
    printf(stdout, "chdir iputdir failed\n");
    exit();
  }
  if(unlink("../iputdir") < 0){
      41:	83 ec 0c             	sub    $0xc,%esp
      44:	68 fc 3b 00 00       	push   $0x3bfc
      49:	e8 d4 37 00 00       	call   3822 <unlink>
      4e:	83 c4 10             	add    $0x10,%esp
      51:	85 c0                	test   %eax,%eax
      53:	78 5c                	js     b1 <iputtest+0xb1>
    printf(stdout, "unlink ../iputdir failed\n");
    exit();
  }
  if(chdir("/") < 0){
      55:	83 ec 0c             	sub    $0xc,%esp
      58:	68 21 3c 00 00       	push   $0x3c21
      5d:	e8 e0 37 00 00       	call   3842 <chdir>
      62:	83 c4 10             	add    $0x10,%esp
      65:	85 c0                	test   %eax,%eax
      67:	78 60                	js     c9 <iputtest+0xc9>
    printf(stdout, "chdir / failed\n");
    exit();
  }
  printf(stdout, "iput test ok\n");
      69:	83 ec 08             	sub    $0x8,%esp
      6c:	68 a4 3c 00 00       	push   $0x3ca4
      71:	ff 35 08 5c 00 00    	pushl  0x5c08
      77:	e8 9f 38 00 00       	call   391b <printf>
}
      7c:	83 c4 10             	add    $0x10,%esp
      7f:	c9                   	leave  
      80:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
      81:	83 ec 08             	sub    $0x8,%esp
      84:	68 d8 3b 00 00       	push   $0x3bd8
      89:	ff 35 08 5c 00 00    	pushl  0x5c08
      8f:	e8 87 38 00 00       	call   391b <printf>
    exit();
      94:	e8 39 37 00 00       	call   37d2 <exit>
    printf(stdout, "chdir iputdir failed\n");
      99:	83 ec 08             	sub    $0x8,%esp
      9c:	68 e6 3b 00 00       	push   $0x3be6
      a1:	ff 35 08 5c 00 00    	pushl  0x5c08
      a7:	e8 6f 38 00 00       	call   391b <printf>
    exit();
      ac:	e8 21 37 00 00       	call   37d2 <exit>
    printf(stdout, "unlink ../iputdir failed\n");
      b1:	83 ec 08             	sub    $0x8,%esp
      b4:	68 07 3c 00 00       	push   $0x3c07
      b9:	ff 35 08 5c 00 00    	pushl  0x5c08
      bf:	e8 57 38 00 00       	call   391b <printf>
    exit();
      c4:	e8 09 37 00 00       	call   37d2 <exit>
    printf(stdout, "chdir / failed\n");
      c9:	83 ec 08             	sub    $0x8,%esp
      cc:	68 23 3c 00 00       	push   $0x3c23
      d1:	ff 35 08 5c 00 00    	pushl  0x5c08
      d7:	e8 3f 38 00 00       	call   391b <printf>
    exit();
      dc:	e8 f1 36 00 00       	call   37d2 <exit>

000000e1 <exitiputtest>:

// does exit() call iput(p->cwd) in a transaction?
void
exitiputtest(void)
{
      e1:	f3 0f 1e fb          	endbr32 
      e5:	55                   	push   %ebp
      e6:	89 e5                	mov    %esp,%ebp
      e8:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "exitiput test\n");
      eb:	68 33 3c 00 00       	push   $0x3c33
      f0:	ff 35 08 5c 00 00    	pushl  0x5c08
      f6:	e8 20 38 00 00       	call   391b <printf>

  pid = fork();
      fb:	e8 ca 36 00 00       	call   37ca <fork>
  if(pid < 0){
     100:	83 c4 10             	add    $0x10,%esp
     103:	85 c0                	test   %eax,%eax
     105:	78 47                	js     14e <exitiputtest+0x6d>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     107:	0f 85 a1 00 00 00    	jne    1ae <exitiputtest+0xcd>
    if(mkdir("iputdir") < 0){
     10d:	83 ec 0c             	sub    $0xc,%esp
     110:	68 ff 3b 00 00       	push   $0x3bff
     115:	e8 20 37 00 00       	call   383a <mkdir>
     11a:	83 c4 10             	add    $0x10,%esp
     11d:	85 c0                	test   %eax,%eax
     11f:	78 45                	js     166 <exitiputtest+0x85>
      printf(stdout, "mkdir failed\n");
      exit();
    }
    if(chdir("iputdir") < 0){
     121:	83 ec 0c             	sub    $0xc,%esp
     124:	68 ff 3b 00 00       	push   $0x3bff
     129:	e8 14 37 00 00       	call   3842 <chdir>
     12e:	83 c4 10             	add    $0x10,%esp
     131:	85 c0                	test   %eax,%eax
     133:	78 49                	js     17e <exitiputtest+0x9d>
      printf(stdout, "child chdir failed\n");
      exit();
    }
    if(unlink("../iputdir") < 0){
     135:	83 ec 0c             	sub    $0xc,%esp
     138:	68 fc 3b 00 00       	push   $0x3bfc
     13d:	e8 e0 36 00 00       	call   3822 <unlink>
     142:	83 c4 10             	add    $0x10,%esp
     145:	85 c0                	test   %eax,%eax
     147:	78 4d                	js     196 <exitiputtest+0xb5>
      printf(stdout, "unlink ../iputdir failed\n");
      exit();
    }
    exit();
     149:	e8 84 36 00 00       	call   37d2 <exit>
    printf(stdout, "fork failed\n");
     14e:	83 ec 08             	sub    $0x8,%esp
     151:	68 19 4b 00 00       	push   $0x4b19
     156:	ff 35 08 5c 00 00    	pushl  0x5c08
     15c:	e8 ba 37 00 00       	call   391b <printf>
    exit();
     161:	e8 6c 36 00 00       	call   37d2 <exit>
      printf(stdout, "mkdir failed\n");
     166:	83 ec 08             	sub    $0x8,%esp
     169:	68 d8 3b 00 00       	push   $0x3bd8
     16e:	ff 35 08 5c 00 00    	pushl  0x5c08
     174:	e8 a2 37 00 00       	call   391b <printf>
      exit();
     179:	e8 54 36 00 00       	call   37d2 <exit>
      printf(stdout, "child chdir failed\n");
     17e:	83 ec 08             	sub    $0x8,%esp
     181:	68 42 3c 00 00       	push   $0x3c42
     186:	ff 35 08 5c 00 00    	pushl  0x5c08
     18c:	e8 8a 37 00 00       	call   391b <printf>
      exit();
     191:	e8 3c 36 00 00       	call   37d2 <exit>
      printf(stdout, "unlink ../iputdir failed\n");
     196:	83 ec 08             	sub    $0x8,%esp
     199:	68 07 3c 00 00       	push   $0x3c07
     19e:	ff 35 08 5c 00 00    	pushl  0x5c08
     1a4:	e8 72 37 00 00       	call   391b <printf>
      exit();
     1a9:	e8 24 36 00 00       	call   37d2 <exit>
  }
  wait();
     1ae:	e8 27 36 00 00       	call   37da <wait>
  printf(stdout, "exitiput test ok\n");
     1b3:	83 ec 08             	sub    $0x8,%esp
     1b6:	68 56 3c 00 00       	push   $0x3c56
     1bb:	ff 35 08 5c 00 00    	pushl  0x5c08
     1c1:	e8 55 37 00 00       	call   391b <printf>
}
     1c6:	83 c4 10             	add    $0x10,%esp
     1c9:	c9                   	leave  
     1ca:	c3                   	ret    

000001cb <openiputtest>:
//      for(i = 0; i < 10000; i++)
//        yield();
//    }
void
openiputtest(void)
{
     1cb:	f3 0f 1e fb          	endbr32 
     1cf:	55                   	push   %ebp
     1d0:	89 e5                	mov    %esp,%ebp
     1d2:	83 ec 10             	sub    $0x10,%esp
  int pid;

  printf(stdout, "openiput test\n");
     1d5:	68 68 3c 00 00       	push   $0x3c68
     1da:	ff 35 08 5c 00 00    	pushl  0x5c08
     1e0:	e8 36 37 00 00       	call   391b <printf>
  if(mkdir("oidir") < 0){
     1e5:	c7 04 24 77 3c 00 00 	movl   $0x3c77,(%esp)
     1ec:	e8 49 36 00 00       	call   383a <mkdir>
     1f1:	83 c4 10             	add    $0x10,%esp
     1f4:	85 c0                	test   %eax,%eax
     1f6:	78 39                	js     231 <openiputtest+0x66>
    printf(stdout, "mkdir oidir failed\n");
    exit();
  }
  pid = fork();
     1f8:	e8 cd 35 00 00       	call   37ca <fork>
  if(pid < 0){
     1fd:	85 c0                	test   %eax,%eax
     1ff:	78 48                	js     249 <openiputtest+0x7e>
    printf(stdout, "fork failed\n");
    exit();
  }
  if(pid == 0){
     201:	75 63                	jne    266 <openiputtest+0x9b>
    int fd = open("oidir", O_RDWR);
     203:	83 ec 08             	sub    $0x8,%esp
     206:	6a 02                	push   $0x2
     208:	68 77 3c 00 00       	push   $0x3c77
     20d:	e8 00 36 00 00       	call   3812 <open>
    if(fd >= 0){
     212:	83 c4 10             	add    $0x10,%esp
     215:	85 c0                	test   %eax,%eax
     217:	78 48                	js     261 <openiputtest+0x96>
      printf(stdout, "open directory for write succeeded\n");
     219:	83 ec 08             	sub    $0x8,%esp
     21c:	68 fc 4b 00 00       	push   $0x4bfc
     221:	ff 35 08 5c 00 00    	pushl  0x5c08
     227:	e8 ef 36 00 00       	call   391b <printf>
      exit();
     22c:	e8 a1 35 00 00       	call   37d2 <exit>
    printf(stdout, "mkdir oidir failed\n");
     231:	83 ec 08             	sub    $0x8,%esp
     234:	68 7d 3c 00 00       	push   $0x3c7d
     239:	ff 35 08 5c 00 00    	pushl  0x5c08
     23f:	e8 d7 36 00 00       	call   391b <printf>
    exit();
     244:	e8 89 35 00 00       	call   37d2 <exit>
    printf(stdout, "fork failed\n");
     249:	83 ec 08             	sub    $0x8,%esp
     24c:	68 19 4b 00 00       	push   $0x4b19
     251:	ff 35 08 5c 00 00    	pushl  0x5c08
     257:	e8 bf 36 00 00       	call   391b <printf>
    exit();
     25c:	e8 71 35 00 00       	call   37d2 <exit>
    }
    exit();
     261:	e8 6c 35 00 00       	call   37d2 <exit>
  }
  sleep(1);
     266:	83 ec 0c             	sub    $0xc,%esp
     269:	6a 01                	push   $0x1
     26b:	e8 f2 35 00 00       	call   3862 <sleep>
  if(unlink("oidir") != 0){
     270:	c7 04 24 77 3c 00 00 	movl   $0x3c77,(%esp)
     277:	e8 a6 35 00 00       	call   3822 <unlink>
     27c:	83 c4 10             	add    $0x10,%esp
     27f:	85 c0                	test   %eax,%eax
     281:	75 1d                	jne    2a0 <openiputtest+0xd5>
    printf(stdout, "unlink failed\n");
    exit();
  }
  wait();
     283:	e8 52 35 00 00       	call   37da <wait>
  printf(stdout, "openiput test ok\n");
     288:	83 ec 08             	sub    $0x8,%esp
     28b:	68 a0 3c 00 00       	push   $0x3ca0
     290:	ff 35 08 5c 00 00    	pushl  0x5c08
     296:	e8 80 36 00 00       	call   391b <printf>
}
     29b:	83 c4 10             	add    $0x10,%esp
     29e:	c9                   	leave  
     29f:	c3                   	ret    
    printf(stdout, "unlink failed\n");
     2a0:	83 ec 08             	sub    $0x8,%esp
     2a3:	68 91 3c 00 00       	push   $0x3c91
     2a8:	ff 35 08 5c 00 00    	pushl  0x5c08
     2ae:	e8 68 36 00 00       	call   391b <printf>
    exit();
     2b3:	e8 1a 35 00 00       	call   37d2 <exit>

000002b8 <opentest>:

// simple file system tests

void
opentest(void)
{
     2b8:	f3 0f 1e fb          	endbr32 
     2bc:	55                   	push   %ebp
     2bd:	89 e5                	mov    %esp,%ebp
     2bf:	83 ec 10             	sub    $0x10,%esp
  int fd;

  printf(stdout, "open test\n");
     2c2:	68 b2 3c 00 00       	push   $0x3cb2
     2c7:	ff 35 08 5c 00 00    	pushl  0x5c08
     2cd:	e8 49 36 00 00       	call   391b <printf>
  fd = open("echo", 0);
     2d2:	83 c4 08             	add    $0x8,%esp
     2d5:	6a 00                	push   $0x0
     2d7:	68 bd 3c 00 00       	push   $0x3cbd
     2dc:	e8 31 35 00 00       	call   3812 <open>
  if(fd < 0){
     2e1:	83 c4 10             	add    $0x10,%esp
     2e4:	85 c0                	test   %eax,%eax
     2e6:	78 37                	js     31f <opentest+0x67>
    printf(stdout, "open echo failed!\n");
    exit();
  }
  close(fd);
     2e8:	83 ec 0c             	sub    $0xc,%esp
     2eb:	50                   	push   %eax
     2ec:	e8 09 35 00 00       	call   37fa <close>
  fd = open("doesnotexist", 0);
     2f1:	83 c4 08             	add    $0x8,%esp
     2f4:	6a 00                	push   $0x0
     2f6:	68 d5 3c 00 00       	push   $0x3cd5
     2fb:	e8 12 35 00 00       	call   3812 <open>
  if(fd >= 0){
     300:	83 c4 10             	add    $0x10,%esp
     303:	85 c0                	test   %eax,%eax
     305:	79 30                	jns    337 <opentest+0x7f>
    printf(stdout, "open doesnotexist succeeded!\n");
    exit();
  }
  printf(stdout, "open test ok\n");
     307:	83 ec 08             	sub    $0x8,%esp
     30a:	68 00 3d 00 00       	push   $0x3d00
     30f:	ff 35 08 5c 00 00    	pushl  0x5c08
     315:	e8 01 36 00 00       	call   391b <printf>
}
     31a:	83 c4 10             	add    $0x10,%esp
     31d:	c9                   	leave  
     31e:	c3                   	ret    
    printf(stdout, "open echo failed!\n");
     31f:	83 ec 08             	sub    $0x8,%esp
     322:	68 c2 3c 00 00       	push   $0x3cc2
     327:	ff 35 08 5c 00 00    	pushl  0x5c08
     32d:	e8 e9 35 00 00       	call   391b <printf>
    exit();
     332:	e8 9b 34 00 00       	call   37d2 <exit>
    printf(stdout, "open doesnotexist succeeded!\n");
     337:	83 ec 08             	sub    $0x8,%esp
     33a:	68 e2 3c 00 00       	push   $0x3ce2
     33f:	ff 35 08 5c 00 00    	pushl  0x5c08
     345:	e8 d1 35 00 00       	call   391b <printf>
    exit();
     34a:	e8 83 34 00 00       	call   37d2 <exit>

0000034f <writetest>:

void
writetest(void)
{
     34f:	f3 0f 1e fb          	endbr32 
     353:	55                   	push   %ebp
     354:	89 e5                	mov    %esp,%ebp
     356:	56                   	push   %esi
     357:	53                   	push   %ebx
  int fd;
  int i;

  printf(stdout, "small file test\n");
     358:	83 ec 08             	sub    $0x8,%esp
     35b:	68 0e 3d 00 00       	push   $0x3d0e
     360:	ff 35 08 5c 00 00    	pushl  0x5c08
     366:	e8 b0 35 00 00       	call   391b <printf>
  fd = open("small", O_CREATE|O_RDWR);
     36b:	83 c4 08             	add    $0x8,%esp
     36e:	68 02 02 00 00       	push   $0x202
     373:	68 1f 3d 00 00       	push   $0x3d1f
     378:	e8 95 34 00 00       	call   3812 <open>
  if(fd >= 0){
     37d:	83 c4 10             	add    $0x10,%esp
     380:	85 c0                	test   %eax,%eax
     382:	78 57                	js     3db <writetest+0x8c>
     384:	89 c6                	mov    %eax,%esi
    printf(stdout, "creat small succeeded; ok\n");
     386:	83 ec 08             	sub    $0x8,%esp
     389:	68 25 3d 00 00       	push   $0x3d25
     38e:	ff 35 08 5c 00 00    	pushl  0x5c08
     394:	e8 82 35 00 00       	call   391b <printf>
  } else {
    printf(stdout, "error: creat small failed!\n");
    exit();
  }
  for(i = 0; i < 100; i++){
     399:	83 c4 10             	add    $0x10,%esp
     39c:	bb 00 00 00 00       	mov    $0x0,%ebx
     3a1:	83 fb 63             	cmp    $0x63,%ebx
     3a4:	7f 7f                	jg     425 <writetest+0xd6>
    if(write(fd, "aaaaaaaaaa", 10) != 10){
     3a6:	83 ec 04             	sub    $0x4,%esp
     3a9:	6a 0a                	push   $0xa
     3ab:	68 5c 3d 00 00       	push   $0x3d5c
     3b0:	56                   	push   %esi
     3b1:	e8 3c 34 00 00       	call   37f2 <write>
     3b6:	83 c4 10             	add    $0x10,%esp
     3b9:	83 f8 0a             	cmp    $0xa,%eax
     3bc:	75 35                	jne    3f3 <writetest+0xa4>
      printf(stdout, "error: write aa %d new file failed\n", i);
      exit();
    }
    if(write(fd, "bbbbbbbbbb", 10) != 10){
     3be:	83 ec 04             	sub    $0x4,%esp
     3c1:	6a 0a                	push   $0xa
     3c3:	68 67 3d 00 00       	push   $0x3d67
     3c8:	56                   	push   %esi
     3c9:	e8 24 34 00 00       	call   37f2 <write>
     3ce:	83 c4 10             	add    $0x10,%esp
     3d1:	83 f8 0a             	cmp    $0xa,%eax
     3d4:	75 36                	jne    40c <writetest+0xbd>
  for(i = 0; i < 100; i++){
     3d6:	83 c3 01             	add    $0x1,%ebx
     3d9:	eb c6                	jmp    3a1 <writetest+0x52>
    printf(stdout, "error: creat small failed!\n");
     3db:	83 ec 08             	sub    $0x8,%esp
     3de:	68 40 3d 00 00       	push   $0x3d40
     3e3:	ff 35 08 5c 00 00    	pushl  0x5c08
     3e9:	e8 2d 35 00 00       	call   391b <printf>
    exit();
     3ee:	e8 df 33 00 00       	call   37d2 <exit>
      printf(stdout, "error: write aa %d new file failed\n", i);
     3f3:	83 ec 04             	sub    $0x4,%esp
     3f6:	53                   	push   %ebx
     3f7:	68 20 4c 00 00       	push   $0x4c20
     3fc:	ff 35 08 5c 00 00    	pushl  0x5c08
     402:	e8 14 35 00 00       	call   391b <printf>
      exit();
     407:	e8 c6 33 00 00       	call   37d2 <exit>
      printf(stdout, "error: write bb %d new file failed\n", i);
     40c:	83 ec 04             	sub    $0x4,%esp
     40f:	53                   	push   %ebx
     410:	68 44 4c 00 00       	push   $0x4c44
     415:	ff 35 08 5c 00 00    	pushl  0x5c08
     41b:	e8 fb 34 00 00       	call   391b <printf>
      exit();
     420:	e8 ad 33 00 00       	call   37d2 <exit>
    }
  }
  printf(stdout, "writes ok\n");
     425:	83 ec 08             	sub    $0x8,%esp
     428:	68 72 3d 00 00       	push   $0x3d72
     42d:	ff 35 08 5c 00 00    	pushl  0x5c08
     433:	e8 e3 34 00 00       	call   391b <printf>
  close(fd);
     438:	89 34 24             	mov    %esi,(%esp)
     43b:	e8 ba 33 00 00       	call   37fa <close>
  fd = open("small", O_RDONLY);
     440:	83 c4 08             	add    $0x8,%esp
     443:	6a 00                	push   $0x0
     445:	68 1f 3d 00 00       	push   $0x3d1f
     44a:	e8 c3 33 00 00       	call   3812 <open>
     44f:	89 c3                	mov    %eax,%ebx
  if(fd >= 0){
     451:	83 c4 10             	add    $0x10,%esp
     454:	85 c0                	test   %eax,%eax
     456:	78 7b                	js     4d3 <writetest+0x184>
    printf(stdout, "open small succeeded ok\n");
     458:	83 ec 08             	sub    $0x8,%esp
     45b:	68 7d 3d 00 00       	push   $0x3d7d
     460:	ff 35 08 5c 00 00    	pushl  0x5c08
     466:	e8 b0 34 00 00       	call   391b <printf>
  } else {
    printf(stdout, "error: open small failed!\n");
    exit();
  }
  i = read(fd, buf, 2000);
     46b:	83 c4 0c             	add    $0xc,%esp
     46e:	68 d0 07 00 00       	push   $0x7d0
     473:	68 e0 83 00 00       	push   $0x83e0
     478:	53                   	push   %ebx
     479:	e8 6c 33 00 00       	call   37ea <read>
  if(i == 2000){
     47e:	83 c4 10             	add    $0x10,%esp
     481:	3d d0 07 00 00       	cmp    $0x7d0,%eax
     486:	75 63                	jne    4eb <writetest+0x19c>
    printf(stdout, "read succeeded ok\n");
     488:	83 ec 08             	sub    $0x8,%esp
     48b:	68 b1 3d 00 00       	push   $0x3db1
     490:	ff 35 08 5c 00 00    	pushl  0x5c08
     496:	e8 80 34 00 00       	call   391b <printf>
  } else {
    printf(stdout, "read failed\n");
    exit();
  }
  close(fd);
     49b:	89 1c 24             	mov    %ebx,(%esp)
     49e:	e8 57 33 00 00       	call   37fa <close>

  if(unlink("small") < 0){
     4a3:	c7 04 24 1f 3d 00 00 	movl   $0x3d1f,(%esp)
     4aa:	e8 73 33 00 00       	call   3822 <unlink>
     4af:	83 c4 10             	add    $0x10,%esp
     4b2:	85 c0                	test   %eax,%eax
     4b4:	78 4d                	js     503 <writetest+0x1b4>
    printf(stdout, "unlink small failed\n");
    exit();
  }
  printf(stdout, "small file test ok\n");
     4b6:	83 ec 08             	sub    $0x8,%esp
     4b9:	68 d9 3d 00 00       	push   $0x3dd9
     4be:	ff 35 08 5c 00 00    	pushl  0x5c08
     4c4:	e8 52 34 00 00       	call   391b <printf>
}
     4c9:	83 c4 10             	add    $0x10,%esp
     4cc:	8d 65 f8             	lea    -0x8(%ebp),%esp
     4cf:	5b                   	pop    %ebx
     4d0:	5e                   	pop    %esi
     4d1:	5d                   	pop    %ebp
     4d2:	c3                   	ret    
    printf(stdout, "error: open small failed!\n");
     4d3:	83 ec 08             	sub    $0x8,%esp
     4d6:	68 96 3d 00 00       	push   $0x3d96
     4db:	ff 35 08 5c 00 00    	pushl  0x5c08
     4e1:	e8 35 34 00 00       	call   391b <printf>
    exit();
     4e6:	e8 e7 32 00 00       	call   37d2 <exit>
    printf(stdout, "read failed\n");
     4eb:	83 ec 08             	sub    $0x8,%esp
     4ee:	68 dd 40 00 00       	push   $0x40dd
     4f3:	ff 35 08 5c 00 00    	pushl  0x5c08
     4f9:	e8 1d 34 00 00       	call   391b <printf>
    exit();
     4fe:	e8 cf 32 00 00       	call   37d2 <exit>
    printf(stdout, "unlink small failed\n");
     503:	83 ec 08             	sub    $0x8,%esp
     506:	68 c4 3d 00 00       	push   $0x3dc4
     50b:	ff 35 08 5c 00 00    	pushl  0x5c08
     511:	e8 05 34 00 00       	call   391b <printf>
    exit();
     516:	e8 b7 32 00 00       	call   37d2 <exit>

0000051b <writetest1>:

void
writetest1(void)
{
     51b:	f3 0f 1e fb          	endbr32 
     51f:	55                   	push   %ebp
     520:	89 e5                	mov    %esp,%ebp
     522:	56                   	push   %esi
     523:	53                   	push   %ebx
  int i, fd, n;

  printf(stdout, "big files test\n");
     524:	83 ec 08             	sub    $0x8,%esp
     527:	68 ed 3d 00 00       	push   $0x3ded
     52c:	ff 35 08 5c 00 00    	pushl  0x5c08
     532:	e8 e4 33 00 00       	call   391b <printf>

  fd = open("big", O_CREATE|O_RDWR);
     537:	83 c4 08             	add    $0x8,%esp
     53a:	68 02 02 00 00       	push   $0x202
     53f:	68 67 3e 00 00       	push   $0x3e67
     544:	e8 c9 32 00 00       	call   3812 <open>
  if(fd < 0){
     549:	83 c4 10             	add    $0x10,%esp
     54c:	85 c0                	test   %eax,%eax
     54e:	78 37                	js     587 <writetest1+0x6c>
     550:	89 c6                	mov    %eax,%esi
    printf(stdout, "error: creat big failed!\n");
    exit();
  }

  for(i = 0; i < MAXFILE; i++){
     552:	bb 00 00 00 00       	mov    $0x0,%ebx
     557:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     55d:	77 59                	ja     5b8 <writetest1+0x9d>
    ((int*)buf)[0] = i;
     55f:	89 1d e0 83 00 00    	mov    %ebx,0x83e0
    if(write(fd, buf, 512) != 512){
     565:	83 ec 04             	sub    $0x4,%esp
     568:	68 00 02 00 00       	push   $0x200
     56d:	68 e0 83 00 00       	push   $0x83e0
     572:	56                   	push   %esi
     573:	e8 7a 32 00 00       	call   37f2 <write>
     578:	83 c4 10             	add    $0x10,%esp
     57b:	3d 00 02 00 00       	cmp    $0x200,%eax
     580:	75 1d                	jne    59f <writetest1+0x84>
  for(i = 0; i < MAXFILE; i++){
     582:	83 c3 01             	add    $0x1,%ebx
     585:	eb d0                	jmp    557 <writetest1+0x3c>
    printf(stdout, "error: creat big failed!\n");
     587:	83 ec 08             	sub    $0x8,%esp
     58a:	68 fd 3d 00 00       	push   $0x3dfd
     58f:	ff 35 08 5c 00 00    	pushl  0x5c08
     595:	e8 81 33 00 00       	call   391b <printf>
    exit();
     59a:	e8 33 32 00 00       	call   37d2 <exit>
      printf(stdout, "error: write big file failed\n", i);
     59f:	83 ec 04             	sub    $0x4,%esp
     5a2:	53                   	push   %ebx
     5a3:	68 17 3e 00 00       	push   $0x3e17
     5a8:	ff 35 08 5c 00 00    	pushl  0x5c08
     5ae:	e8 68 33 00 00       	call   391b <printf>
      exit();
     5b3:	e8 1a 32 00 00       	call   37d2 <exit>
    }
  }

  close(fd);
     5b8:	83 ec 0c             	sub    $0xc,%esp
     5bb:	56                   	push   %esi
     5bc:	e8 39 32 00 00       	call   37fa <close>

  fd = open("big", O_RDONLY);
     5c1:	83 c4 08             	add    $0x8,%esp
     5c4:	6a 00                	push   $0x0
     5c6:	68 67 3e 00 00       	push   $0x3e67
     5cb:	e8 42 32 00 00       	call   3812 <open>
     5d0:	89 c6                	mov    %eax,%esi
  if(fd < 0){
     5d2:	83 c4 10             	add    $0x10,%esp
     5d5:	85 c0                	test   %eax,%eax
     5d7:	78 3c                	js     615 <writetest1+0xfa>
    printf(stdout, "error: open big failed!\n");
    exit();
  }

  n = 0;
     5d9:	bb 00 00 00 00       	mov    $0x0,%ebx
  for(;;){
    i = read(fd, buf, 512);
     5de:	83 ec 04             	sub    $0x4,%esp
     5e1:	68 00 02 00 00       	push   $0x200
     5e6:	68 e0 83 00 00       	push   $0x83e0
     5eb:	56                   	push   %esi
     5ec:	e8 f9 31 00 00       	call   37ea <read>
    if(i == 0){
     5f1:	83 c4 10             	add    $0x10,%esp
     5f4:	85 c0                	test   %eax,%eax
     5f6:	74 35                	je     62d <writetest1+0x112>
      if(n == MAXFILE - 1){
        printf(stdout, "read only %d blocks from big", n);
        exit();
      }
      break;
    } else if(i != 512){
     5f8:	3d 00 02 00 00       	cmp    $0x200,%eax
     5fd:	0f 85 84 00 00 00    	jne    687 <writetest1+0x16c>
      printf(stdout, "read failed %d\n", i);
      exit();
    }
    if(((int*)buf)[0] != n){
     603:	a1 e0 83 00 00       	mov    0x83e0,%eax
     608:	39 d8                	cmp    %ebx,%eax
     60a:	0f 85 90 00 00 00    	jne    6a0 <writetest1+0x185>
      printf(stdout, "read content of block %d is %d\n",
             n, ((int*)buf)[0]);
      exit();
    }
    n++;
     610:	83 c3 01             	add    $0x1,%ebx
    i = read(fd, buf, 512);
     613:	eb c9                	jmp    5de <writetest1+0xc3>
    printf(stdout, "error: open big failed!\n");
     615:	83 ec 08             	sub    $0x8,%esp
     618:	68 35 3e 00 00       	push   $0x3e35
     61d:	ff 35 08 5c 00 00    	pushl  0x5c08
     623:	e8 f3 32 00 00       	call   391b <printf>
    exit();
     628:	e8 a5 31 00 00       	call   37d2 <exit>
      if(n == MAXFILE - 1){
     62d:	81 fb 8b 00 00 00    	cmp    $0x8b,%ebx
     633:	74 39                	je     66e <writetest1+0x153>
  }
  close(fd);
     635:	83 ec 0c             	sub    $0xc,%esp
     638:	56                   	push   %esi
     639:	e8 bc 31 00 00       	call   37fa <close>
  if(unlink("big") < 0){
     63e:	c7 04 24 67 3e 00 00 	movl   $0x3e67,(%esp)
     645:	e8 d8 31 00 00       	call   3822 <unlink>
     64a:	83 c4 10             	add    $0x10,%esp
     64d:	85 c0                	test   %eax,%eax
     64f:	78 66                	js     6b7 <writetest1+0x19c>
    printf(stdout, "unlink big failed\n");
    exit();
  }
  printf(stdout, "big files ok\n");
     651:	83 ec 08             	sub    $0x8,%esp
     654:	68 8e 3e 00 00       	push   $0x3e8e
     659:	ff 35 08 5c 00 00    	pushl  0x5c08
     65f:	e8 b7 32 00 00       	call   391b <printf>
}
     664:	83 c4 10             	add    $0x10,%esp
     667:	8d 65 f8             	lea    -0x8(%ebp),%esp
     66a:	5b                   	pop    %ebx
     66b:	5e                   	pop    %esi
     66c:	5d                   	pop    %ebp
     66d:	c3                   	ret    
        printf(stdout, "read only %d blocks from big", n);
     66e:	83 ec 04             	sub    $0x4,%esp
     671:	53                   	push   %ebx
     672:	68 4e 3e 00 00       	push   $0x3e4e
     677:	ff 35 08 5c 00 00    	pushl  0x5c08
     67d:	e8 99 32 00 00       	call   391b <printf>
        exit();
     682:	e8 4b 31 00 00       	call   37d2 <exit>
      printf(stdout, "read failed %d\n", i);
     687:	83 ec 04             	sub    $0x4,%esp
     68a:	50                   	push   %eax
     68b:	68 6b 3e 00 00       	push   $0x3e6b
     690:	ff 35 08 5c 00 00    	pushl  0x5c08
     696:	e8 80 32 00 00       	call   391b <printf>
      exit();
     69b:	e8 32 31 00 00       	call   37d2 <exit>
      printf(stdout, "read content of block %d is %d\n",
     6a0:	50                   	push   %eax
     6a1:	53                   	push   %ebx
     6a2:	68 68 4c 00 00       	push   $0x4c68
     6a7:	ff 35 08 5c 00 00    	pushl  0x5c08
     6ad:	e8 69 32 00 00       	call   391b <printf>
      exit();
     6b2:	e8 1b 31 00 00       	call   37d2 <exit>
    printf(stdout, "unlink big failed\n");
     6b7:	83 ec 08             	sub    $0x8,%esp
     6ba:	68 7b 3e 00 00       	push   $0x3e7b
     6bf:	ff 35 08 5c 00 00    	pushl  0x5c08
     6c5:	e8 51 32 00 00       	call   391b <printf>
    exit();
     6ca:	e8 03 31 00 00       	call   37d2 <exit>

000006cf <createtest>:

void
createtest(void)
{
     6cf:	f3 0f 1e fb          	endbr32 
     6d3:	55                   	push   %ebp
     6d4:	89 e5                	mov    %esp,%ebp
     6d6:	53                   	push   %ebx
     6d7:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(stdout, "many creates, followed by unlink test\n");
     6da:	68 88 4c 00 00       	push   $0x4c88
     6df:	ff 35 08 5c 00 00    	pushl  0x5c08
     6e5:	e8 31 32 00 00       	call   391b <printf>

  name[0] = 'a';
     6ea:	c6 05 e0 a3 00 00 61 	movb   $0x61,0xa3e0
  name[2] = '\0';
     6f1:	c6 05 e2 a3 00 00 00 	movb   $0x0,0xa3e2
  for(i = 0; i < 52; i++){
     6f8:	83 c4 10             	add    $0x10,%esp
     6fb:	bb 00 00 00 00       	mov    $0x0,%ebx
     700:	eb 28                	jmp    72a <createtest+0x5b>
    name[1] = '0' + i;
     702:	8d 43 30             	lea    0x30(%ebx),%eax
     705:	a2 e1 a3 00 00       	mov    %al,0xa3e1
    fd = open(name, O_CREATE|O_RDWR);
     70a:	83 ec 08             	sub    $0x8,%esp
     70d:	68 02 02 00 00       	push   $0x202
     712:	68 e0 a3 00 00       	push   $0xa3e0
     717:	e8 f6 30 00 00       	call   3812 <open>
    close(fd);
     71c:	89 04 24             	mov    %eax,(%esp)
     71f:	e8 d6 30 00 00       	call   37fa <close>
  for(i = 0; i < 52; i++){
     724:	83 c3 01             	add    $0x1,%ebx
     727:	83 c4 10             	add    $0x10,%esp
     72a:	83 fb 33             	cmp    $0x33,%ebx
     72d:	7e d3                	jle    702 <createtest+0x33>
  }
  name[0] = 'a';
     72f:	c6 05 e0 a3 00 00 61 	movb   $0x61,0xa3e0
  name[2] = '\0';
     736:	c6 05 e2 a3 00 00 00 	movb   $0x0,0xa3e2
  for(i = 0; i < 52; i++){
     73d:	bb 00 00 00 00       	mov    $0x0,%ebx
     742:	eb 1b                	jmp    75f <createtest+0x90>
    name[1] = '0' + i;
     744:	8d 43 30             	lea    0x30(%ebx),%eax
     747:	a2 e1 a3 00 00       	mov    %al,0xa3e1
    unlink(name);
     74c:	83 ec 0c             	sub    $0xc,%esp
     74f:	68 e0 a3 00 00       	push   $0xa3e0
     754:	e8 c9 30 00 00       	call   3822 <unlink>
  for(i = 0; i < 52; i++){
     759:	83 c3 01             	add    $0x1,%ebx
     75c:	83 c4 10             	add    $0x10,%esp
     75f:	83 fb 33             	cmp    $0x33,%ebx
     762:	7e e0                	jle    744 <createtest+0x75>
  }
  printf(stdout, "many creates, followed by unlink; ok\n");
     764:	83 ec 08             	sub    $0x8,%esp
     767:	68 b0 4c 00 00       	push   $0x4cb0
     76c:	ff 35 08 5c 00 00    	pushl  0x5c08
     772:	e8 a4 31 00 00       	call   391b <printf>
}
     777:	83 c4 10             	add    $0x10,%esp
     77a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
     77d:	c9                   	leave  
     77e:	c3                   	ret    

0000077f <dirtest>:

void dirtest(void)
{
     77f:	f3 0f 1e fb          	endbr32 
     783:	55                   	push   %ebp
     784:	89 e5                	mov    %esp,%ebp
     786:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "mkdir test\n");
     789:	68 9c 3e 00 00       	push   $0x3e9c
     78e:	ff 35 08 5c 00 00    	pushl  0x5c08
     794:	e8 82 31 00 00       	call   391b <printf>

  if(mkdir("dir0") < 0){
     799:	c7 04 24 a8 3e 00 00 	movl   $0x3ea8,(%esp)
     7a0:	e8 95 30 00 00       	call   383a <mkdir>
     7a5:	83 c4 10             	add    $0x10,%esp
     7a8:	85 c0                	test   %eax,%eax
     7aa:	78 54                	js     800 <dirtest+0x81>
    printf(stdout, "mkdir failed\n");
    exit();
  }

  if(chdir("dir0") < 0){
     7ac:	83 ec 0c             	sub    $0xc,%esp
     7af:	68 a8 3e 00 00       	push   $0x3ea8
     7b4:	e8 89 30 00 00       	call   3842 <chdir>
     7b9:	83 c4 10             	add    $0x10,%esp
     7bc:	85 c0                	test   %eax,%eax
     7be:	78 58                	js     818 <dirtest+0x99>
    printf(stdout, "chdir dir0 failed\n");
    exit();
  }

  if(chdir("..") < 0){
     7c0:	83 ec 0c             	sub    $0xc,%esp
     7c3:	68 4d 44 00 00       	push   $0x444d
     7c8:	e8 75 30 00 00       	call   3842 <chdir>
     7cd:	83 c4 10             	add    $0x10,%esp
     7d0:	85 c0                	test   %eax,%eax
     7d2:	78 5c                	js     830 <dirtest+0xb1>
    printf(stdout, "chdir .. failed\n");
    exit();
  }

  if(unlink("dir0") < 0){
     7d4:	83 ec 0c             	sub    $0xc,%esp
     7d7:	68 a8 3e 00 00       	push   $0x3ea8
     7dc:	e8 41 30 00 00       	call   3822 <unlink>
     7e1:	83 c4 10             	add    $0x10,%esp
     7e4:	85 c0                	test   %eax,%eax
     7e6:	78 60                	js     848 <dirtest+0xc9>
    printf(stdout, "unlink dir0 failed\n");
    exit();
  }
  printf(stdout, "mkdir test ok\n");
     7e8:	83 ec 08             	sub    $0x8,%esp
     7eb:	68 e5 3e 00 00       	push   $0x3ee5
     7f0:	ff 35 08 5c 00 00    	pushl  0x5c08
     7f6:	e8 20 31 00 00       	call   391b <printf>
}
     7fb:	83 c4 10             	add    $0x10,%esp
     7fe:	c9                   	leave  
     7ff:	c3                   	ret    
    printf(stdout, "mkdir failed\n");
     800:	83 ec 08             	sub    $0x8,%esp
     803:	68 d8 3b 00 00       	push   $0x3bd8
     808:	ff 35 08 5c 00 00    	pushl  0x5c08
     80e:	e8 08 31 00 00       	call   391b <printf>
    exit();
     813:	e8 ba 2f 00 00       	call   37d2 <exit>
    printf(stdout, "chdir dir0 failed\n");
     818:	83 ec 08             	sub    $0x8,%esp
     81b:	68 ad 3e 00 00       	push   $0x3ead
     820:	ff 35 08 5c 00 00    	pushl  0x5c08
     826:	e8 f0 30 00 00       	call   391b <printf>
    exit();
     82b:	e8 a2 2f 00 00       	call   37d2 <exit>
    printf(stdout, "chdir .. failed\n");
     830:	83 ec 08             	sub    $0x8,%esp
     833:	68 c0 3e 00 00       	push   $0x3ec0
     838:	ff 35 08 5c 00 00    	pushl  0x5c08
     83e:	e8 d8 30 00 00       	call   391b <printf>
    exit();
     843:	e8 8a 2f 00 00       	call   37d2 <exit>
    printf(stdout, "unlink dir0 failed\n");
     848:	83 ec 08             	sub    $0x8,%esp
     84b:	68 d1 3e 00 00       	push   $0x3ed1
     850:	ff 35 08 5c 00 00    	pushl  0x5c08
     856:	e8 c0 30 00 00       	call   391b <printf>
    exit();
     85b:	e8 72 2f 00 00       	call   37d2 <exit>

00000860 <exectest>:

void
exectest(void)
{
     860:	f3 0f 1e fb          	endbr32 
     864:	55                   	push   %ebp
     865:	89 e5                	mov    %esp,%ebp
     867:	83 ec 10             	sub    $0x10,%esp
  printf(stdout, "exec test\n");
     86a:	68 f4 3e 00 00       	push   $0x3ef4
     86f:	ff 35 08 5c 00 00    	pushl  0x5c08
     875:	e8 a1 30 00 00       	call   391b <printf>
  if(exec("echo", echoargv) < 0){
     87a:	83 c4 08             	add    $0x8,%esp
     87d:	68 0c 5c 00 00       	push   $0x5c0c
     882:	68 bd 3c 00 00       	push   $0x3cbd
     887:	e8 7e 2f 00 00       	call   380a <exec>
     88c:	83 c4 10             	add    $0x10,%esp
     88f:	85 c0                	test   %eax,%eax
     891:	78 02                	js     895 <exectest+0x35>
    printf(stdout, "exec echo failed\n");
    exit();
  }
}
     893:	c9                   	leave  
     894:	c3                   	ret    
    printf(stdout, "exec echo failed\n");
     895:	83 ec 08             	sub    $0x8,%esp
     898:	68 ff 3e 00 00       	push   $0x3eff
     89d:	ff 35 08 5c 00 00    	pushl  0x5c08
     8a3:	e8 73 30 00 00       	call   391b <printf>
    exit();
     8a8:	e8 25 2f 00 00       	call   37d2 <exit>

000008ad <pipe1>:

// simple fork and pipe read/write

void
pipe1(void)
{
     8ad:	f3 0f 1e fb          	endbr32 
     8b1:	55                   	push   %ebp
     8b2:	89 e5                	mov    %esp,%ebp
     8b4:	57                   	push   %edi
     8b5:	56                   	push   %esi
     8b6:	53                   	push   %ebx
     8b7:	83 ec 38             	sub    $0x38,%esp
  int fds[2], pid;
  int seq, i, n, cc, total;

  if(pipe(fds) != 0){
     8ba:	8d 45 e0             	lea    -0x20(%ebp),%eax
     8bd:	50                   	push   %eax
     8be:	e8 1f 2f 00 00       	call   37e2 <pipe>
     8c3:	83 c4 10             	add    $0x10,%esp
     8c6:	85 c0                	test   %eax,%eax
     8c8:	75 74                	jne    93e <pipe1+0x91>
     8ca:	89 c6                	mov    %eax,%esi
    printf(1, "pipe() failed\n");
    exit();
  }
  pid = fork();
     8cc:	e8 f9 2e 00 00       	call   37ca <fork>
     8d1:	89 c7                	mov    %eax,%edi
  seq = 0;
  if(pid == 0){
     8d3:	85 c0                	test   %eax,%eax
     8d5:	74 7b                	je     952 <pipe1+0xa5>
        printf(1, "pipe1 oops 1\n");
        exit();
      }
    }
    exit();
  } else if(pid > 0){
     8d7:	0f 8e 60 01 00 00    	jle    a3d <pipe1+0x190>
    close(fds[1]);
     8dd:	83 ec 0c             	sub    $0xc,%esp
     8e0:	ff 75 e4             	pushl  -0x1c(%ebp)
     8e3:	e8 12 2f 00 00       	call   37fa <close>
    total = 0;
    cc = 1;
    while((n = read(fds[0], buf, cc)) > 0){
     8e8:	83 c4 10             	add    $0x10,%esp
    total = 0;
     8eb:	89 75 d0             	mov    %esi,-0x30(%ebp)
  seq = 0;
     8ee:	89 f3                	mov    %esi,%ebx
    cc = 1;
     8f0:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
    while((n = read(fds[0], buf, cc)) > 0){
     8f7:	83 ec 04             	sub    $0x4,%esp
     8fa:	ff 75 d4             	pushl  -0x2c(%ebp)
     8fd:	68 e0 83 00 00       	push   $0x83e0
     902:	ff 75 e0             	pushl  -0x20(%ebp)
     905:	e8 e0 2e 00 00       	call   37ea <read>
     90a:	89 c7                	mov    %eax,%edi
     90c:	83 c4 10             	add    $0x10,%esp
     90f:	85 c0                	test   %eax,%eax
     911:	0f 8e e2 00 00 00    	jle    9f9 <pipe1+0x14c>
      for(i = 0; i < n; i++){
     917:	89 f0                	mov    %esi,%eax
     919:	89 d9                	mov    %ebx,%ecx
     91b:	39 f8                	cmp    %edi,%eax
     91d:	0f 8d b4 00 00 00    	jge    9d7 <pipe1+0x12a>
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     923:	0f be 98 e0 83 00 00 	movsbl 0x83e0(%eax),%ebx
     92a:	8d 51 01             	lea    0x1(%ecx),%edx
     92d:	31 cb                	xor    %ecx,%ebx
     92f:	84 db                	test   %bl,%bl
     931:	0f 85 86 00 00 00    	jne    9bd <pipe1+0x110>
      for(i = 0; i < n; i++){
     937:	83 c0 01             	add    $0x1,%eax
        if((buf[i] & 0xff) != (seq++ & 0xff)){
     93a:	89 d1                	mov    %edx,%ecx
     93c:	eb dd                	jmp    91b <pipe1+0x6e>
    printf(1, "pipe() failed\n");
     93e:	83 ec 08             	sub    $0x8,%esp
     941:	68 11 3f 00 00       	push   $0x3f11
     946:	6a 01                	push   $0x1
     948:	e8 ce 2f 00 00       	call   391b <printf>
    exit();
     94d:	e8 80 2e 00 00       	call   37d2 <exit>
    close(fds[0]);
     952:	83 ec 0c             	sub    $0xc,%esp
     955:	ff 75 e0             	pushl  -0x20(%ebp)
     958:	e8 9d 2e 00 00       	call   37fa <close>
    for(n = 0; n < 5; n++){
     95d:	83 c4 10             	add    $0x10,%esp
     960:	89 fe                	mov    %edi,%esi
  seq = 0;
     962:	89 fb                	mov    %edi,%ebx
    for(n = 0; n < 5; n++){
     964:	eb 22                	jmp    988 <pipe1+0xdb>
      if(write(fds[1], buf, 1033) != 1033){
     966:	83 ec 04             	sub    $0x4,%esp
     969:	68 09 04 00 00       	push   $0x409
     96e:	68 e0 83 00 00       	push   $0x83e0
     973:	ff 75 e4             	pushl  -0x1c(%ebp)
     976:	e8 77 2e 00 00       	call   37f2 <write>
     97b:	83 c4 10             	add    $0x10,%esp
     97e:	3d 09 04 00 00       	cmp    $0x409,%eax
     983:	75 1f                	jne    9a4 <pipe1+0xf7>
    for(n = 0; n < 5; n++){
     985:	83 c6 01             	add    $0x1,%esi
     988:	83 fe 04             	cmp    $0x4,%esi
     98b:	7f 2b                	jg     9b8 <pipe1+0x10b>
      for(i = 0; i < 1033; i++)
     98d:	89 f8                	mov    %edi,%eax
     98f:	3d 08 04 00 00       	cmp    $0x408,%eax
     994:	7f d0                	jg     966 <pipe1+0xb9>
        buf[i] = seq++;
     996:	88 98 e0 83 00 00    	mov    %bl,0x83e0(%eax)
      for(i = 0; i < 1033; i++)
     99c:	83 c0 01             	add    $0x1,%eax
        buf[i] = seq++;
     99f:	8d 5b 01             	lea    0x1(%ebx),%ebx
     9a2:	eb eb                	jmp    98f <pipe1+0xe2>
        printf(1, "pipe1 oops 1\n");
     9a4:	83 ec 08             	sub    $0x8,%esp
     9a7:	68 20 3f 00 00       	push   $0x3f20
     9ac:	6a 01                	push   $0x1
     9ae:	e8 68 2f 00 00       	call   391b <printf>
        exit();
     9b3:	e8 1a 2e 00 00       	call   37d2 <exit>
    exit();
     9b8:	e8 15 2e 00 00       	call   37d2 <exit>
          printf(1, "pipe1 oops 2\n");
     9bd:	83 ec 08             	sub    $0x8,%esp
     9c0:	68 2e 3f 00 00       	push   $0x3f2e
     9c5:	6a 01                	push   $0x1
     9c7:	e8 4f 2f 00 00       	call   391b <printf>
          return;
     9cc:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "fork() failed\n");
    exit();
  }
  printf(1, "pipe1 ok\n");
}
     9cf:	8d 65 f4             	lea    -0xc(%ebp),%esp
     9d2:	5b                   	pop    %ebx
     9d3:	5e                   	pop    %esi
     9d4:	5f                   	pop    %edi
     9d5:	5d                   	pop    %ebp
     9d6:	c3                   	ret    
     9d7:	89 cb                	mov    %ecx,%ebx
      total += n;
     9d9:	01 7d d0             	add    %edi,-0x30(%ebp)
      cc = cc * 2;
     9dc:	d1 65 d4             	shll   -0x2c(%ebp)
     9df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
      if(cc > sizeof(buf))
     9e2:	3d 00 20 00 00       	cmp    $0x2000,%eax
     9e7:	0f 86 0a ff ff ff    	jbe    8f7 <pipe1+0x4a>
        cc = sizeof(buf);
     9ed:	c7 45 d4 00 20 00 00 	movl   $0x2000,-0x2c(%ebp)
     9f4:	e9 fe fe ff ff       	jmp    8f7 <pipe1+0x4a>
    if(total != 5 * 1033){
     9f9:	81 7d d0 2d 14 00 00 	cmpl   $0x142d,-0x30(%ebp)
     a00:	75 24                	jne    a26 <pipe1+0x179>
    close(fds[0]);
     a02:	83 ec 0c             	sub    $0xc,%esp
     a05:	ff 75 e0             	pushl  -0x20(%ebp)
     a08:	e8 ed 2d 00 00       	call   37fa <close>
    wait();
     a0d:	e8 c8 2d 00 00       	call   37da <wait>
  printf(1, "pipe1 ok\n");
     a12:	83 c4 08             	add    $0x8,%esp
     a15:	68 53 3f 00 00       	push   $0x3f53
     a1a:	6a 01                	push   $0x1
     a1c:	e8 fa 2e 00 00       	call   391b <printf>
     a21:	83 c4 10             	add    $0x10,%esp
     a24:	eb a9                	jmp    9cf <pipe1+0x122>
      printf(1, "pipe1 oops 3 total %d\n", total);
     a26:	83 ec 04             	sub    $0x4,%esp
     a29:	ff 75 d0             	pushl  -0x30(%ebp)
     a2c:	68 3c 3f 00 00       	push   $0x3f3c
     a31:	6a 01                	push   $0x1
     a33:	e8 e3 2e 00 00       	call   391b <printf>
      exit();
     a38:	e8 95 2d 00 00       	call   37d2 <exit>
    printf(1, "fork() failed\n");
     a3d:	83 ec 08             	sub    $0x8,%esp
     a40:	68 5d 3f 00 00       	push   $0x3f5d
     a45:	6a 01                	push   $0x1
     a47:	e8 cf 2e 00 00       	call   391b <printf>
    exit();
     a4c:	e8 81 2d 00 00       	call   37d2 <exit>

00000a51 <preempt>:

// meant to be run w/ at most two CPUs
void
preempt(void)
{
     a51:	f3 0f 1e fb          	endbr32 
     a55:	55                   	push   %ebp
     a56:	89 e5                	mov    %esp,%ebp
     a58:	57                   	push   %edi
     a59:	56                   	push   %esi
     a5a:	53                   	push   %ebx
     a5b:	83 ec 24             	sub    $0x24,%esp
  int pid1, pid2, pid3;
  int pfds[2];

  printf(1, "preempt: ");
     a5e:	68 6c 3f 00 00       	push   $0x3f6c
     a63:	6a 01                	push   $0x1
     a65:	e8 b1 2e 00 00       	call   391b <printf>
  pid1 = fork();
     a6a:	e8 5b 2d 00 00       	call   37ca <fork>
  if(pid1 == 0)
     a6f:	83 c4 10             	add    $0x10,%esp
     a72:	85 c0                	test   %eax,%eax
     a74:	75 02                	jne    a78 <preempt+0x27>
    for(;;)
     a76:	eb fe                	jmp    a76 <preempt+0x25>
     a78:	89 c7                	mov    %eax,%edi
      ;

  pid2 = fork();
     a7a:	e8 4b 2d 00 00       	call   37ca <fork>
     a7f:	89 c6                	mov    %eax,%esi
  if(pid2 == 0)
     a81:	85 c0                	test   %eax,%eax
     a83:	75 02                	jne    a87 <preempt+0x36>
    for(;;)
     a85:	eb fe                	jmp    a85 <preempt+0x34>
      ;

  pipe(pfds);
     a87:	83 ec 0c             	sub    $0xc,%esp
     a8a:	8d 45 e0             	lea    -0x20(%ebp),%eax
     a8d:	50                   	push   %eax
     a8e:	e8 4f 2d 00 00       	call   37e2 <pipe>
  pid3 = fork();
     a93:	e8 32 2d 00 00       	call   37ca <fork>
     a98:	89 c3                	mov    %eax,%ebx
  if(pid3 == 0){
     a9a:	83 c4 10             	add    $0x10,%esp
     a9d:	85 c0                	test   %eax,%eax
     a9f:	75 49                	jne    aea <preempt+0x99>
    close(pfds[0]);
     aa1:	83 ec 0c             	sub    $0xc,%esp
     aa4:	ff 75 e0             	pushl  -0x20(%ebp)
     aa7:	e8 4e 2d 00 00       	call   37fa <close>
    if(write(pfds[1], "x", 1) != 1)
     aac:	83 c4 0c             	add    $0xc,%esp
     aaf:	6a 01                	push   $0x1
     ab1:	68 31 45 00 00       	push   $0x4531
     ab6:	ff 75 e4             	pushl  -0x1c(%ebp)
     ab9:	e8 34 2d 00 00       	call   37f2 <write>
     abe:	83 c4 10             	add    $0x10,%esp
     ac1:	83 f8 01             	cmp    $0x1,%eax
     ac4:	75 10                	jne    ad6 <preempt+0x85>
      printf(1, "preempt write error");
    close(pfds[1]);
     ac6:	83 ec 0c             	sub    $0xc,%esp
     ac9:	ff 75 e4             	pushl  -0x1c(%ebp)
     acc:	e8 29 2d 00 00       	call   37fa <close>
     ad1:	83 c4 10             	add    $0x10,%esp
    for(;;)
     ad4:	eb fe                	jmp    ad4 <preempt+0x83>
      printf(1, "preempt write error");
     ad6:	83 ec 08             	sub    $0x8,%esp
     ad9:	68 76 3f 00 00       	push   $0x3f76
     ade:	6a 01                	push   $0x1
     ae0:	e8 36 2e 00 00       	call   391b <printf>
     ae5:	83 c4 10             	add    $0x10,%esp
     ae8:	eb dc                	jmp    ac6 <preempt+0x75>
      ;
  }

  close(pfds[1]);
     aea:	83 ec 0c             	sub    $0xc,%esp
     aed:	ff 75 e4             	pushl  -0x1c(%ebp)
     af0:	e8 05 2d 00 00       	call   37fa <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
     af5:	83 c4 0c             	add    $0xc,%esp
     af8:	68 00 20 00 00       	push   $0x2000
     afd:	68 e0 83 00 00       	push   $0x83e0
     b02:	ff 75 e0             	pushl  -0x20(%ebp)
     b05:	e8 e0 2c 00 00       	call   37ea <read>
     b0a:	83 c4 10             	add    $0x10,%esp
     b0d:	83 f8 01             	cmp    $0x1,%eax
     b10:	74 1a                	je     b2c <preempt+0xdb>
    printf(1, "preempt read error");
     b12:	83 ec 08             	sub    $0x8,%esp
     b15:	68 8a 3f 00 00       	push   $0x3f8a
     b1a:	6a 01                	push   $0x1
     b1c:	e8 fa 2d 00 00       	call   391b <printf>
    return;
     b21:	83 c4 10             	add    $0x10,%esp
  printf(1, "wait... ");
  wait();
  wait();
  wait();
  printf(1, "preempt ok\n");
}
     b24:	8d 65 f4             	lea    -0xc(%ebp),%esp
     b27:	5b                   	pop    %ebx
     b28:	5e                   	pop    %esi
     b29:	5f                   	pop    %edi
     b2a:	5d                   	pop    %ebp
     b2b:	c3                   	ret    
  close(pfds[0]);
     b2c:	83 ec 0c             	sub    $0xc,%esp
     b2f:	ff 75 e0             	pushl  -0x20(%ebp)
     b32:	e8 c3 2c 00 00       	call   37fa <close>
  printf(1, "kill... ");
     b37:	83 c4 08             	add    $0x8,%esp
     b3a:	68 9d 3f 00 00       	push   $0x3f9d
     b3f:	6a 01                	push   $0x1
     b41:	e8 d5 2d 00 00       	call   391b <printf>
  kill(pid1);
     b46:	89 3c 24             	mov    %edi,(%esp)
     b49:	e8 b4 2c 00 00       	call   3802 <kill>
  kill(pid2);
     b4e:	89 34 24             	mov    %esi,(%esp)
     b51:	e8 ac 2c 00 00       	call   3802 <kill>
  kill(pid3);
     b56:	89 1c 24             	mov    %ebx,(%esp)
     b59:	e8 a4 2c 00 00       	call   3802 <kill>
  printf(1, "wait... ");
     b5e:	83 c4 08             	add    $0x8,%esp
     b61:	68 a6 3f 00 00       	push   $0x3fa6
     b66:	6a 01                	push   $0x1
     b68:	e8 ae 2d 00 00       	call   391b <printf>
  wait();
     b6d:	e8 68 2c 00 00       	call   37da <wait>
  wait();
     b72:	e8 63 2c 00 00       	call   37da <wait>
  wait();
     b77:	e8 5e 2c 00 00       	call   37da <wait>
  printf(1, "preempt ok\n");
     b7c:	83 c4 08             	add    $0x8,%esp
     b7f:	68 af 3f 00 00       	push   $0x3faf
     b84:	6a 01                	push   $0x1
     b86:	e8 90 2d 00 00       	call   391b <printf>
     b8b:	83 c4 10             	add    $0x10,%esp
     b8e:	eb 94                	jmp    b24 <preempt+0xd3>

00000b90 <exitwait>:

// try to find any races between exit and wait
void
exitwait(void)
{
     b90:	f3 0f 1e fb          	endbr32 
     b94:	55                   	push   %ebp
     b95:	89 e5                	mov    %esp,%ebp
     b97:	56                   	push   %esi
     b98:	53                   	push   %ebx
  int i, pid;

  for(i = 0; i < 100; i++){
     b99:	be 00 00 00 00       	mov    $0x0,%esi
     b9e:	eb 21                	jmp    bc1 <exitwait+0x31>
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
     ba0:	83 ec 08             	sub    $0x8,%esp
     ba3:	68 19 4b 00 00       	push   $0x4b19
     ba8:	6a 01                	push   $0x1
     baa:	e8 6c 2d 00 00       	call   391b <printf>
      return;
     baf:	83 c4 10             	add    $0x10,%esp
    } else {
      exit();
    }
  }
  printf(1, "exitwait ok\n");
}
     bb2:	8d 65 f8             	lea    -0x8(%ebp),%esp
     bb5:	5b                   	pop    %ebx
     bb6:	5e                   	pop    %esi
     bb7:	5d                   	pop    %ebp
     bb8:	c3                   	ret    
      exit();
     bb9:	e8 14 2c 00 00       	call   37d2 <exit>
  for(i = 0; i < 100; i++){
     bbe:	83 c6 01             	add    $0x1,%esi
     bc1:	83 fe 63             	cmp    $0x63,%esi
     bc4:	7f 2a                	jg     bf0 <exitwait+0x60>
    pid = fork();
     bc6:	e8 ff 2b 00 00       	call   37ca <fork>
     bcb:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
     bcd:	85 c0                	test   %eax,%eax
     bcf:	78 cf                	js     ba0 <exitwait+0x10>
    if(pid){
     bd1:	74 e6                	je     bb9 <exitwait+0x29>
      if(wait() != pid){
     bd3:	e8 02 2c 00 00       	call   37da <wait>
     bd8:	39 d8                	cmp    %ebx,%eax
     bda:	74 e2                	je     bbe <exitwait+0x2e>
        printf(1, "wait wrong pid\n");
     bdc:	83 ec 08             	sub    $0x8,%esp
     bdf:	68 bb 3f 00 00       	push   $0x3fbb
     be4:	6a 01                	push   $0x1
     be6:	e8 30 2d 00 00       	call   391b <printf>
        return;
     beb:	83 c4 10             	add    $0x10,%esp
     bee:	eb c2                	jmp    bb2 <exitwait+0x22>
  printf(1, "exitwait ok\n");
     bf0:	83 ec 08             	sub    $0x8,%esp
     bf3:	68 cb 3f 00 00       	push   $0x3fcb
     bf8:	6a 01                	push   $0x1
     bfa:	e8 1c 2d 00 00       	call   391b <printf>
     bff:	83 c4 10             	add    $0x10,%esp
     c02:	eb ae                	jmp    bb2 <exitwait+0x22>

00000c04 <mem>:

void
mem(void)
{
     c04:	f3 0f 1e fb          	endbr32 
     c08:	55                   	push   %ebp
     c09:	89 e5                	mov    %esp,%ebp
     c0b:	57                   	push   %edi
     c0c:	56                   	push   %esi
     c0d:	53                   	push   %ebx
     c0e:	83 ec 14             	sub    $0x14,%esp
  void *m1, *m2;
  int pid, ppid;

  printf(1, "mem test\n");
     c11:	68 d8 3f 00 00       	push   $0x3fd8
     c16:	6a 01                	push   $0x1
     c18:	e8 fe 2c 00 00       	call   391b <printf>
  ppid = getpid();
     c1d:	e8 30 2c 00 00       	call   3852 <getpid>
     c22:	89 c6                	mov    %eax,%esi
  if((pid = fork()) == 0){
     c24:	e8 a1 2b 00 00       	call   37ca <fork>
     c29:	83 c4 10             	add    $0x10,%esp
     c2c:	85 c0                	test   %eax,%eax
     c2e:	0f 85 80 00 00 00    	jne    cb4 <mem+0xb0>
    m1 = 0;
     c34:	bb 00 00 00 00       	mov    $0x0,%ebx
    while((m2 = malloc(10001)) != 0){
     c39:	83 ec 0c             	sub    $0xc,%esp
     c3c:	68 11 27 00 00       	push   $0x2711
     c41:	e8 06 2f 00 00       	call   3b4c <malloc>
     c46:	83 c4 10             	add    $0x10,%esp
     c49:	85 c0                	test   %eax,%eax
     c4b:	74 16                	je     c63 <mem+0x5f>
      *(char**)m2 = m1;
     c4d:	89 18                	mov    %ebx,(%eax)
      m1 = m2;
     c4f:	89 c3                	mov    %eax,%ebx
     c51:	eb e6                	jmp    c39 <mem+0x35>
    }
    while(m1){
      m2 = *(char**)m1;
     c53:	8b 3b                	mov    (%ebx),%edi
      free(m1);
     c55:	83 ec 0c             	sub    $0xc,%esp
     c58:	53                   	push   %ebx
     c59:	e8 2a 2e 00 00       	call   3a88 <free>
     c5e:	83 c4 10             	add    $0x10,%esp
      m1 = m2;
     c61:	89 fb                	mov    %edi,%ebx
    while(m1){
     c63:	85 db                	test   %ebx,%ebx
     c65:	75 ec                	jne    c53 <mem+0x4f>
    }
    m1 = malloc(1024*20);
     c67:	83 ec 0c             	sub    $0xc,%esp
     c6a:	68 00 50 00 00       	push   $0x5000
     c6f:	e8 d8 2e 00 00       	call   3b4c <malloc>
    if(m1 == 0){
     c74:	83 c4 10             	add    $0x10,%esp
     c77:	85 c0                	test   %eax,%eax
     c79:	74 1d                	je     c98 <mem+0x94>
      printf(1, "couldn't allocate mem?!!\n");
      kill(ppid);
      exit();
    }
    free(m1);
     c7b:	83 ec 0c             	sub    $0xc,%esp
     c7e:	50                   	push   %eax
     c7f:	e8 04 2e 00 00       	call   3a88 <free>
    printf(1, "mem ok\n");
     c84:	83 c4 08             	add    $0x8,%esp
     c87:	68 fc 3f 00 00       	push   $0x3ffc
     c8c:	6a 01                	push   $0x1
     c8e:	e8 88 2c 00 00       	call   391b <printf>
    exit();
     c93:	e8 3a 2b 00 00       	call   37d2 <exit>
      printf(1, "couldn't allocate mem?!!\n");
     c98:	83 ec 08             	sub    $0x8,%esp
     c9b:	68 e2 3f 00 00       	push   $0x3fe2
     ca0:	6a 01                	push   $0x1
     ca2:	e8 74 2c 00 00       	call   391b <printf>
      kill(ppid);
     ca7:	89 34 24             	mov    %esi,(%esp)
     caa:	e8 53 2b 00 00       	call   3802 <kill>
      exit();
     caf:	e8 1e 2b 00 00       	call   37d2 <exit>
  } else {
    wait();
     cb4:	e8 21 2b 00 00       	call   37da <wait>
  }
}
     cb9:	8d 65 f4             	lea    -0xc(%ebp),%esp
     cbc:	5b                   	pop    %ebx
     cbd:	5e                   	pop    %esi
     cbe:	5f                   	pop    %edi
     cbf:	5d                   	pop    %ebp
     cc0:	c3                   	ret    

00000cc1 <sharedfd>:

// two processes write to the same file descriptor
// is the offset shared? does inode locking work?
void
sharedfd(void)
{
     cc1:	f3 0f 1e fb          	endbr32 
     cc5:	55                   	push   %ebp
     cc6:	89 e5                	mov    %esp,%ebp
     cc8:	57                   	push   %edi
     cc9:	56                   	push   %esi
     cca:	53                   	push   %ebx
     ccb:	83 ec 24             	sub    $0x24,%esp
  int fd, pid, i, n, nc, np;
  char buf[10];

  printf(1, "sharedfd test\n");
     cce:	68 04 40 00 00       	push   $0x4004
     cd3:	6a 01                	push   $0x1
     cd5:	e8 41 2c 00 00       	call   391b <printf>

  unlink("sharedfd");
     cda:	c7 04 24 13 40 00 00 	movl   $0x4013,(%esp)
     ce1:	e8 3c 2b 00 00       	call   3822 <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
     ce6:	83 c4 08             	add    $0x8,%esp
     ce9:	68 02 02 00 00       	push   $0x202
     cee:	68 13 40 00 00       	push   $0x4013
     cf3:	e8 1a 2b 00 00       	call   3812 <open>
  if(fd < 0){
     cf8:	83 c4 10             	add    $0x10,%esp
     cfb:	85 c0                	test   %eax,%eax
     cfd:	78 4d                	js     d4c <sharedfd+0x8b>
     cff:	89 c6                	mov    %eax,%esi
    printf(1, "fstests: cannot open sharedfd for writing");
    return;
  }
  pid = fork();
     d01:	e8 c4 2a 00 00       	call   37ca <fork>
     d06:	89 c7                	mov    %eax,%edi
  memset(buf, pid==0?'c':'p', sizeof(buf));
     d08:	85 c0                	test   %eax,%eax
     d0a:	75 57                	jne    d63 <sharedfd+0xa2>
     d0c:	b8 63 00 00 00       	mov    $0x63,%eax
     d11:	83 ec 04             	sub    $0x4,%esp
     d14:	6a 0a                	push   $0xa
     d16:	50                   	push   %eax
     d17:	8d 45 de             	lea    -0x22(%ebp),%eax
     d1a:	50                   	push   %eax
     d1b:	e8 65 29 00 00       	call   3685 <memset>
  for(i = 0; i < 1000; i++){
     d20:	83 c4 10             	add    $0x10,%esp
     d23:	bb 00 00 00 00       	mov    $0x0,%ebx
     d28:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
     d2e:	7f 4c                	jg     d7c <sharedfd+0xbb>
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
     d30:	83 ec 04             	sub    $0x4,%esp
     d33:	6a 0a                	push   $0xa
     d35:	8d 45 de             	lea    -0x22(%ebp),%eax
     d38:	50                   	push   %eax
     d39:	56                   	push   %esi
     d3a:	e8 b3 2a 00 00       	call   37f2 <write>
     d3f:	83 c4 10             	add    $0x10,%esp
     d42:	83 f8 0a             	cmp    $0xa,%eax
     d45:	75 23                	jne    d6a <sharedfd+0xa9>
  for(i = 0; i < 1000; i++){
     d47:	83 c3 01             	add    $0x1,%ebx
     d4a:	eb dc                	jmp    d28 <sharedfd+0x67>
    printf(1, "fstests: cannot open sharedfd for writing");
     d4c:	83 ec 08             	sub    $0x8,%esp
     d4f:	68 d8 4c 00 00       	push   $0x4cd8
     d54:	6a 01                	push   $0x1
     d56:	e8 c0 2b 00 00       	call   391b <printf>
    return;
     d5b:	83 c4 10             	add    $0x10,%esp
     d5e:	e9 e4 00 00 00       	jmp    e47 <sharedfd+0x186>
  memset(buf, pid==0?'c':'p', sizeof(buf));
     d63:	b8 70 00 00 00       	mov    $0x70,%eax
     d68:	eb a7                	jmp    d11 <sharedfd+0x50>
      printf(1, "fstests: write sharedfd failed\n");
     d6a:	83 ec 08             	sub    $0x8,%esp
     d6d:	68 04 4d 00 00       	push   $0x4d04
     d72:	6a 01                	push   $0x1
     d74:	e8 a2 2b 00 00       	call   391b <printf>
      break;
     d79:	83 c4 10             	add    $0x10,%esp
    }
  }
  if(pid == 0)
     d7c:	85 ff                	test   %edi,%edi
     d7e:	74 4d                	je     dcd <sharedfd+0x10c>
    exit();
  else
    wait();
     d80:	e8 55 2a 00 00       	call   37da <wait>
  close(fd);
     d85:	83 ec 0c             	sub    $0xc,%esp
     d88:	56                   	push   %esi
     d89:	e8 6c 2a 00 00       	call   37fa <close>
  fd = open("sharedfd", 0);
     d8e:	83 c4 08             	add    $0x8,%esp
     d91:	6a 00                	push   $0x0
     d93:	68 13 40 00 00       	push   $0x4013
     d98:	e8 75 2a 00 00       	call   3812 <open>
     d9d:	89 c7                	mov    %eax,%edi
  if(fd < 0){
     d9f:	83 c4 10             	add    $0x10,%esp
     da2:	85 c0                	test   %eax,%eax
     da4:	78 2c                	js     dd2 <sharedfd+0x111>
    printf(1, "fstests: cannot open sharedfd for reading\n");
    return;
  }
  nc = np = 0;
     da6:	be 00 00 00 00       	mov    $0x0,%esi
     dab:	bb 00 00 00 00       	mov    $0x0,%ebx
  while((n = read(fd, buf, sizeof(buf))) > 0){
     db0:	83 ec 04             	sub    $0x4,%esp
     db3:	6a 0a                	push   $0xa
     db5:	8d 45 de             	lea    -0x22(%ebp),%eax
     db8:	50                   	push   %eax
     db9:	57                   	push   %edi
     dba:	e8 2b 2a 00 00       	call   37ea <read>
     dbf:	83 c4 10             	add    $0x10,%esp
     dc2:	85 c0                	test   %eax,%eax
     dc4:	7e 41                	jle    e07 <sharedfd+0x146>
    for(i = 0; i < sizeof(buf); i++){
     dc6:	b8 00 00 00 00       	mov    $0x0,%eax
     dcb:	eb 21                	jmp    dee <sharedfd+0x12d>
    exit();
     dcd:	e8 00 2a 00 00       	call   37d2 <exit>
    printf(1, "fstests: cannot open sharedfd for reading\n");
     dd2:	83 ec 08             	sub    $0x8,%esp
     dd5:	68 24 4d 00 00       	push   $0x4d24
     dda:	6a 01                	push   $0x1
     ddc:	e8 3a 2b 00 00       	call   391b <printf>
    return;
     de1:	83 c4 10             	add    $0x10,%esp
     de4:	eb 61                	jmp    e47 <sharedfd+0x186>
      if(buf[i] == 'c')
        nc++;
     de6:	83 c3 01             	add    $0x1,%ebx
     de9:	eb 12                	jmp    dfd <sharedfd+0x13c>
    for(i = 0; i < sizeof(buf); i++){
     deb:	83 c0 01             	add    $0x1,%eax
     dee:	83 f8 09             	cmp    $0x9,%eax
     df1:	77 bd                	ja     db0 <sharedfd+0xef>
      if(buf[i] == 'c')
     df3:	0f b6 54 05 de       	movzbl -0x22(%ebp,%eax,1),%edx
     df8:	80 fa 63             	cmp    $0x63,%dl
     dfb:	74 e9                	je     de6 <sharedfd+0x125>
      if(buf[i] == 'p')
     dfd:	80 fa 70             	cmp    $0x70,%dl
     e00:	75 e9                	jne    deb <sharedfd+0x12a>
        np++;
     e02:	83 c6 01             	add    $0x1,%esi
     e05:	eb e4                	jmp    deb <sharedfd+0x12a>
    }
  }
  close(fd);
     e07:	83 ec 0c             	sub    $0xc,%esp
     e0a:	57                   	push   %edi
     e0b:	e8 ea 29 00 00       	call   37fa <close>
  unlink("sharedfd");
     e10:	c7 04 24 13 40 00 00 	movl   $0x4013,(%esp)
     e17:	e8 06 2a 00 00       	call   3822 <unlink>
  if(nc == 10000 && np == 10000){
     e1c:	83 c4 10             	add    $0x10,%esp
     e1f:	81 fb 10 27 00 00    	cmp    $0x2710,%ebx
     e25:	0f 94 c2             	sete   %dl
     e28:	81 fe 10 27 00 00    	cmp    $0x2710,%esi
     e2e:	0f 94 c0             	sete   %al
     e31:	84 c2                	test   %al,%dl
     e33:	74 1a                	je     e4f <sharedfd+0x18e>
    printf(1, "sharedfd ok\n");
     e35:	83 ec 08             	sub    $0x8,%esp
     e38:	68 1c 40 00 00       	push   $0x401c
     e3d:	6a 01                	push   $0x1
     e3f:	e8 d7 2a 00 00       	call   391b <printf>
     e44:	83 c4 10             	add    $0x10,%esp
  } else {
    printf(1, "sharedfd oops %d %d\n", nc, np);
    exit();
  }
}
     e47:	8d 65 f4             	lea    -0xc(%ebp),%esp
     e4a:	5b                   	pop    %ebx
     e4b:	5e                   	pop    %esi
     e4c:	5f                   	pop    %edi
     e4d:	5d                   	pop    %ebp
     e4e:	c3                   	ret    
    printf(1, "sharedfd oops %d %d\n", nc, np);
     e4f:	56                   	push   %esi
     e50:	53                   	push   %ebx
     e51:	68 29 40 00 00       	push   $0x4029
     e56:	6a 01                	push   $0x1
     e58:	e8 be 2a 00 00       	call   391b <printf>
    exit();
     e5d:	e8 70 29 00 00       	call   37d2 <exit>

00000e62 <fourfiles>:

// four processes write different files at the same
// time, to test block allocation.
void
fourfiles(void)
{
     e62:	f3 0f 1e fb          	endbr32 
     e66:	55                   	push   %ebp
     e67:	89 e5                	mov    %esp,%ebp
     e69:	57                   	push   %edi
     e6a:	56                   	push   %esi
     e6b:	53                   	push   %ebx
     e6c:	83 ec 34             	sub    $0x34,%esp
  int fd, pid, i, j, n, total, pi;
  char *names[] = { "f0", "f1", "f2", "f3" };
     e6f:	c7 45 d8 3e 40 00 00 	movl   $0x403e,-0x28(%ebp)
     e76:	c7 45 dc 87 41 00 00 	movl   $0x4187,-0x24(%ebp)
     e7d:	c7 45 e0 8b 41 00 00 	movl   $0x418b,-0x20(%ebp)
     e84:	c7 45 e4 41 40 00 00 	movl   $0x4041,-0x1c(%ebp)
  char *fname;

  printf(1, "fourfiles test\n");
     e8b:	68 44 40 00 00       	push   $0x4044
     e90:	6a 01                	push   $0x1
     e92:	e8 84 2a 00 00       	call   391b <printf>

  for(pi = 0; pi < 4; pi++){
     e97:	83 c4 10             	add    $0x10,%esp
     e9a:	be 00 00 00 00       	mov    $0x0,%esi
     e9f:	83 fe 03             	cmp    $0x3,%esi
     ea2:	0f 8f bb 00 00 00    	jg     f63 <fourfiles+0x101>
    fname = names[pi];
     ea8:	8b 7c b5 d8          	mov    -0x28(%ebp,%esi,4),%edi
    unlink(fname);
     eac:	83 ec 0c             	sub    $0xc,%esp
     eaf:	57                   	push   %edi
     eb0:	e8 6d 29 00 00       	call   3822 <unlink>

    pid = fork();
     eb5:	e8 10 29 00 00       	call   37ca <fork>
    if(pid < 0){
     eba:	83 c4 10             	add    $0x10,%esp
     ebd:	85 c0                	test   %eax,%eax
     ebf:	78 07                	js     ec8 <fourfiles+0x66>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
     ec1:	74 19                	je     edc <fourfiles+0x7a>
  for(pi = 0; pi < 4; pi++){
     ec3:	83 c6 01             	add    $0x1,%esi
     ec6:	eb d7                	jmp    e9f <fourfiles+0x3d>
      printf(1, "fork failed\n");
     ec8:	83 ec 08             	sub    $0x8,%esp
     ecb:	68 19 4b 00 00       	push   $0x4b19
     ed0:	6a 01                	push   $0x1
     ed2:	e8 44 2a 00 00       	call   391b <printf>
      exit();
     ed7:	e8 f6 28 00 00       	call   37d2 <exit>
     edc:	89 c3                	mov    %eax,%ebx
      fd = open(fname, O_CREATE | O_RDWR);
     ede:	83 ec 08             	sub    $0x8,%esp
     ee1:	68 02 02 00 00       	push   $0x202
     ee6:	57                   	push   %edi
     ee7:	e8 26 29 00 00       	call   3812 <open>
     eec:	89 c7                	mov    %eax,%edi
      if(fd < 0){
     eee:	83 c4 10             	add    $0x10,%esp
     ef1:	85 c0                	test   %eax,%eax
     ef3:	78 40                	js     f35 <fourfiles+0xd3>
        printf(1, "create failed\n");
        exit();
      }

      memset(buf, '0'+pi, 512);
     ef5:	83 ec 04             	sub    $0x4,%esp
     ef8:	68 00 02 00 00       	push   $0x200
     efd:	83 c6 30             	add    $0x30,%esi
     f00:	56                   	push   %esi
     f01:	68 e0 83 00 00       	push   $0x83e0
     f06:	e8 7a 27 00 00       	call   3685 <memset>
      for(i = 0; i < 12; i++){
     f0b:	83 c4 10             	add    $0x10,%esp
     f0e:	83 fb 0b             	cmp    $0xb,%ebx
     f11:	7f 4b                	jg     f5e <fourfiles+0xfc>
        if((n = write(fd, buf, 500)) != 500){
     f13:	83 ec 04             	sub    $0x4,%esp
     f16:	68 f4 01 00 00       	push   $0x1f4
     f1b:	68 e0 83 00 00       	push   $0x83e0
     f20:	57                   	push   %edi
     f21:	e8 cc 28 00 00       	call   37f2 <write>
     f26:	83 c4 10             	add    $0x10,%esp
     f29:	3d f4 01 00 00       	cmp    $0x1f4,%eax
     f2e:	75 19                	jne    f49 <fourfiles+0xe7>
      for(i = 0; i < 12; i++){
     f30:	83 c3 01             	add    $0x1,%ebx
     f33:	eb d9                	jmp    f0e <fourfiles+0xac>
        printf(1, "create failed\n");
     f35:	83 ec 08             	sub    $0x8,%esp
     f38:	68 df 42 00 00       	push   $0x42df
     f3d:	6a 01                	push   $0x1
     f3f:	e8 d7 29 00 00       	call   391b <printf>
        exit();
     f44:	e8 89 28 00 00       	call   37d2 <exit>
          printf(1, "write failed %d\n", n);
     f49:	83 ec 04             	sub    $0x4,%esp
     f4c:	50                   	push   %eax
     f4d:	68 54 40 00 00       	push   $0x4054
     f52:	6a 01                	push   $0x1
     f54:	e8 c2 29 00 00       	call   391b <printf>
          exit();
     f59:	e8 74 28 00 00       	call   37d2 <exit>
        }
      }
      exit();
     f5e:	e8 6f 28 00 00       	call   37d2 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
     f63:	bb 00 00 00 00       	mov    $0x0,%ebx
     f68:	eb 08                	jmp    f72 <fourfiles+0x110>
    wait();
     f6a:	e8 6b 28 00 00       	call   37da <wait>
  for(pi = 0; pi < 4; pi++){
     f6f:	83 c3 01             	add    $0x1,%ebx
     f72:	83 fb 03             	cmp    $0x3,%ebx
     f75:	7e f3                	jle    f6a <fourfiles+0x108>
  }

  for(i = 0; i < 2; i++){
     f77:	bb 00 00 00 00       	mov    $0x0,%ebx
     f7c:	eb 75                	jmp    ff3 <fourfiles+0x191>
    fd = open(fname, 0);
    total = 0;
    while((n = read(fd, buf, sizeof(buf))) > 0){
      for(j = 0; j < n; j++){
        if(buf[j] != '0'+i){
          printf(1, "wrong char\n");
     f7e:	83 ec 08             	sub    $0x8,%esp
     f81:	68 65 40 00 00       	push   $0x4065
     f86:	6a 01                	push   $0x1
     f88:	e8 8e 29 00 00       	call   391b <printf>
          exit();
     f8d:	e8 40 28 00 00       	call   37d2 <exit>
        }
      }
      total += n;
     f92:	01 c6                	add    %eax,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
     f94:	83 ec 04             	sub    $0x4,%esp
     f97:	68 00 20 00 00       	push   $0x2000
     f9c:	68 e0 83 00 00       	push   $0x83e0
     fa1:	ff 75 d4             	pushl  -0x2c(%ebp)
     fa4:	e8 41 28 00 00       	call   37ea <read>
     fa9:	83 c4 10             	add    $0x10,%esp
     fac:	85 c0                	test   %eax,%eax
     fae:	7e 1c                	jle    fcc <fourfiles+0x16a>
      for(j = 0; j < n; j++){
     fb0:	ba 00 00 00 00       	mov    $0x0,%edx
     fb5:	39 c2                	cmp    %eax,%edx
     fb7:	7d d9                	jge    f92 <fourfiles+0x130>
        if(buf[j] != '0'+i){
     fb9:	0f be ba e0 83 00 00 	movsbl 0x83e0(%edx),%edi
     fc0:	8d 4b 30             	lea    0x30(%ebx),%ecx
     fc3:	39 cf                	cmp    %ecx,%edi
     fc5:	75 b7                	jne    f7e <fourfiles+0x11c>
      for(j = 0; j < n; j++){
     fc7:	83 c2 01             	add    $0x1,%edx
     fca:	eb e9                	jmp    fb5 <fourfiles+0x153>
    }
    close(fd);
     fcc:	83 ec 0c             	sub    $0xc,%esp
     fcf:	ff 75 d4             	pushl  -0x2c(%ebp)
     fd2:	e8 23 28 00 00       	call   37fa <close>
    if(total != 12*500){
     fd7:	83 c4 10             	add    $0x10,%esp
     fda:	81 fe 70 17 00 00    	cmp    $0x1770,%esi
     fe0:	75 38                	jne    101a <fourfiles+0x1b8>
      printf(1, "wrong length %d\n", total);
      exit();
    }
    unlink(fname);
     fe2:	83 ec 0c             	sub    $0xc,%esp
     fe5:	ff 75 d0             	pushl  -0x30(%ebp)
     fe8:	e8 35 28 00 00       	call   3822 <unlink>
  for(i = 0; i < 2; i++){
     fed:	83 c3 01             	add    $0x1,%ebx
     ff0:	83 c4 10             	add    $0x10,%esp
     ff3:	83 fb 01             	cmp    $0x1,%ebx
     ff6:	7f 37                	jg     102f <fourfiles+0x1cd>
    fname = names[i];
     ff8:	8b 44 9d d8          	mov    -0x28(%ebp,%ebx,4),%eax
     ffc:	89 45 d0             	mov    %eax,-0x30(%ebp)
    fd = open(fname, 0);
     fff:	83 ec 08             	sub    $0x8,%esp
    1002:	6a 00                	push   $0x0
    1004:	50                   	push   %eax
    1005:	e8 08 28 00 00       	call   3812 <open>
    100a:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    while((n = read(fd, buf, sizeof(buf))) > 0){
    100d:	83 c4 10             	add    $0x10,%esp
    total = 0;
    1010:	be 00 00 00 00       	mov    $0x0,%esi
    while((n = read(fd, buf, sizeof(buf))) > 0){
    1015:	e9 7a ff ff ff       	jmp    f94 <fourfiles+0x132>
      printf(1, "wrong length %d\n", total);
    101a:	83 ec 04             	sub    $0x4,%esp
    101d:	56                   	push   %esi
    101e:	68 71 40 00 00       	push   $0x4071
    1023:	6a 01                	push   $0x1
    1025:	e8 f1 28 00 00       	call   391b <printf>
      exit();
    102a:	e8 a3 27 00 00       	call   37d2 <exit>
  }

  printf(1, "fourfiles ok\n");
    102f:	83 ec 08             	sub    $0x8,%esp
    1032:	68 82 40 00 00       	push   $0x4082
    1037:	6a 01                	push   $0x1
    1039:	e8 dd 28 00 00       	call   391b <printf>
}
    103e:	83 c4 10             	add    $0x10,%esp
    1041:	8d 65 f4             	lea    -0xc(%ebp),%esp
    1044:	5b                   	pop    %ebx
    1045:	5e                   	pop    %esi
    1046:	5f                   	pop    %edi
    1047:	5d                   	pop    %ebp
    1048:	c3                   	ret    

00001049 <createdelete>:

// four processes create and delete different files in same directory
void
createdelete(void)
{
    1049:	f3 0f 1e fb          	endbr32 
    104d:	55                   	push   %ebp
    104e:	89 e5                	mov    %esp,%ebp
    1050:	56                   	push   %esi
    1051:	53                   	push   %ebx
    1052:	83 ec 28             	sub    $0x28,%esp
  enum { N = 20 };
  int pid, i, fd, pi;
  char name[32];

  printf(1, "createdelete test\n");
    1055:	68 90 40 00 00       	push   $0x4090
    105a:	6a 01                	push   $0x1
    105c:	e8 ba 28 00 00       	call   391b <printf>

  for(pi = 0; pi < 4; pi++){
    1061:	83 c4 10             	add    $0x10,%esp
    1064:	be 00 00 00 00       	mov    $0x0,%esi
    1069:	83 fe 03             	cmp    $0x3,%esi
    106c:	0f 8f bc 00 00 00    	jg     112e <createdelete+0xe5>
    pid = fork();
    1072:	e8 53 27 00 00       	call   37ca <fork>
    1077:	89 c3                	mov    %eax,%ebx
    if(pid < 0){
    1079:	85 c0                	test   %eax,%eax
    107b:	78 07                	js     1084 <createdelete+0x3b>
      printf(1, "fork failed\n");
      exit();
    }

    if(pid == 0){
    107d:	74 19                	je     1098 <createdelete+0x4f>
  for(pi = 0; pi < 4; pi++){
    107f:	83 c6 01             	add    $0x1,%esi
    1082:	eb e5                	jmp    1069 <createdelete+0x20>
      printf(1, "fork failed\n");
    1084:	83 ec 08             	sub    $0x8,%esp
    1087:	68 19 4b 00 00       	push   $0x4b19
    108c:	6a 01                	push   $0x1
    108e:	e8 88 28 00 00       	call   391b <printf>
      exit();
    1093:	e8 3a 27 00 00       	call   37d2 <exit>
      name[0] = 'p' + pi;
    1098:	8d 46 70             	lea    0x70(%esi),%eax
    109b:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[2] = '\0';
    109e:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
      for(i = 0; i < N; i++){
    10a2:	eb 17                	jmp    10bb <createdelete+0x72>
        name[1] = '0' + i;
        fd = open(name, O_CREATE | O_RDWR);
        if(fd < 0){
          printf(1, "create failed\n");
    10a4:	83 ec 08             	sub    $0x8,%esp
    10a7:	68 df 42 00 00       	push   $0x42df
    10ac:	6a 01                	push   $0x1
    10ae:	e8 68 28 00 00       	call   391b <printf>
          exit();
    10b3:	e8 1a 27 00 00       	call   37d2 <exit>
      for(i = 0; i < N; i++){
    10b8:	83 c3 01             	add    $0x1,%ebx
    10bb:	83 fb 13             	cmp    $0x13,%ebx
    10be:	7f 69                	jg     1129 <createdelete+0xe0>
        name[1] = '0' + i;
    10c0:	8d 43 30             	lea    0x30(%ebx),%eax
    10c3:	88 45 d9             	mov    %al,-0x27(%ebp)
        fd = open(name, O_CREATE | O_RDWR);
    10c6:	83 ec 08             	sub    $0x8,%esp
    10c9:	68 02 02 00 00       	push   $0x202
    10ce:	8d 45 d8             	lea    -0x28(%ebp),%eax
    10d1:	50                   	push   %eax
    10d2:	e8 3b 27 00 00       	call   3812 <open>
        if(fd < 0){
    10d7:	83 c4 10             	add    $0x10,%esp
    10da:	85 c0                	test   %eax,%eax
    10dc:	78 c6                	js     10a4 <createdelete+0x5b>
        }
        close(fd);
    10de:	83 ec 0c             	sub    $0xc,%esp
    10e1:	50                   	push   %eax
    10e2:	e8 13 27 00 00       	call   37fa <close>
        if(i > 0 && (i % 2 ) == 0){
    10e7:	83 c4 10             	add    $0x10,%esp
    10ea:	85 db                	test   %ebx,%ebx
    10ec:	7e ca                	jle    10b8 <createdelete+0x6f>
    10ee:	f6 c3 01             	test   $0x1,%bl
    10f1:	75 c5                	jne    10b8 <createdelete+0x6f>
          name[1] = '0' + (i / 2);
    10f3:	89 d8                	mov    %ebx,%eax
    10f5:	c1 e8 1f             	shr    $0x1f,%eax
    10f8:	01 d8                	add    %ebx,%eax
    10fa:	d1 f8                	sar    %eax
    10fc:	83 c0 30             	add    $0x30,%eax
    10ff:	88 45 d9             	mov    %al,-0x27(%ebp)
          if(unlink(name) < 0){
    1102:	83 ec 0c             	sub    $0xc,%esp
    1105:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1108:	50                   	push   %eax
    1109:	e8 14 27 00 00       	call   3822 <unlink>
    110e:	83 c4 10             	add    $0x10,%esp
    1111:	85 c0                	test   %eax,%eax
    1113:	79 a3                	jns    10b8 <createdelete+0x6f>
            printf(1, "unlink failed\n");
    1115:	83 ec 08             	sub    $0x8,%esp
    1118:	68 91 3c 00 00       	push   $0x3c91
    111d:	6a 01                	push   $0x1
    111f:	e8 f7 27 00 00       	call   391b <printf>
            exit();
    1124:	e8 a9 26 00 00       	call   37d2 <exit>
          }
        }
      }
      exit();
    1129:	e8 a4 26 00 00       	call   37d2 <exit>
    }
  }

  for(pi = 0; pi < 4; pi++){
    112e:	bb 00 00 00 00       	mov    $0x0,%ebx
    1133:	eb 08                	jmp    113d <createdelete+0xf4>
    wait();
    1135:	e8 a0 26 00 00       	call   37da <wait>
  for(pi = 0; pi < 4; pi++){
    113a:	83 c3 01             	add    $0x1,%ebx
    113d:	83 fb 03             	cmp    $0x3,%ebx
    1140:	7e f3                	jle    1135 <createdelete+0xec>
  }

  name[0] = name[1] = name[2] = 0;
    1142:	c6 45 da 00          	movb   $0x0,-0x26(%ebp)
    1146:	c6 45 d9 00          	movb   $0x0,-0x27(%ebp)
    114a:	c6 45 d8 00          	movb   $0x0,-0x28(%ebp)
  for(i = 0; i < N; i++){
    114e:	bb 00 00 00 00       	mov    $0x0,%ebx
    1153:	e9 89 00 00 00       	jmp    11e1 <createdelete+0x198>
      name[1] = '0' + i;
      fd = open(name, 0);
      if((i == 0 || i >= N/2) && fd < 0){
        printf(1, "oops createdelete %s didn't exist\n", name);
        exit();
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1158:	8d 53 ff             	lea    -0x1(%ebx),%edx
    115b:	83 fa 08             	cmp    $0x8,%edx
    115e:	76 54                	jbe    11b4 <createdelete+0x16b>
        printf(1, "oops createdelete %s did exist\n", name);
        exit();
      }
      if(fd >= 0)
    1160:	85 c0                	test   %eax,%eax
    1162:	79 6c                	jns    11d0 <createdelete+0x187>
    for(pi = 0; pi < 4; pi++){
    1164:	83 c6 01             	add    $0x1,%esi
    1167:	83 fe 03             	cmp    $0x3,%esi
    116a:	7f 72                	jg     11de <createdelete+0x195>
      name[0] = 'p' + pi;
    116c:	8d 46 70             	lea    0x70(%esi),%eax
    116f:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    1172:	8d 43 30             	lea    0x30(%ebx),%eax
    1175:	88 45 d9             	mov    %al,-0x27(%ebp)
      fd = open(name, 0);
    1178:	83 ec 08             	sub    $0x8,%esp
    117b:	6a 00                	push   $0x0
    117d:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1180:	50                   	push   %eax
    1181:	e8 8c 26 00 00       	call   3812 <open>
      if((i == 0 || i >= N/2) && fd < 0){
    1186:	83 c4 10             	add    $0x10,%esp
    1189:	85 db                	test   %ebx,%ebx
    118b:	0f 94 c1             	sete   %cl
    118e:	83 fb 09             	cmp    $0x9,%ebx
    1191:	0f 9f c2             	setg   %dl
    1194:	08 d1                	or     %dl,%cl
    1196:	74 c0                	je     1158 <createdelete+0x10f>
    1198:	85 c0                	test   %eax,%eax
    119a:	79 bc                	jns    1158 <createdelete+0x10f>
        printf(1, "oops createdelete %s didn't exist\n", name);
    119c:	83 ec 04             	sub    $0x4,%esp
    119f:	8d 45 d8             	lea    -0x28(%ebp),%eax
    11a2:	50                   	push   %eax
    11a3:	68 50 4d 00 00       	push   $0x4d50
    11a8:	6a 01                	push   $0x1
    11aa:	e8 6c 27 00 00       	call   391b <printf>
        exit();
    11af:	e8 1e 26 00 00       	call   37d2 <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    11b4:	85 c0                	test   %eax,%eax
    11b6:	78 a8                	js     1160 <createdelete+0x117>
        printf(1, "oops createdelete %s did exist\n", name);
    11b8:	83 ec 04             	sub    $0x4,%esp
    11bb:	8d 45 d8             	lea    -0x28(%ebp),%eax
    11be:	50                   	push   %eax
    11bf:	68 74 4d 00 00       	push   $0x4d74
    11c4:	6a 01                	push   $0x1
    11c6:	e8 50 27 00 00       	call   391b <printf>
        exit();
    11cb:	e8 02 26 00 00       	call   37d2 <exit>
        close(fd);
    11d0:	83 ec 0c             	sub    $0xc,%esp
    11d3:	50                   	push   %eax
    11d4:	e8 21 26 00 00       	call   37fa <close>
    11d9:	83 c4 10             	add    $0x10,%esp
    11dc:	eb 86                	jmp    1164 <createdelete+0x11b>
  for(i = 0; i < N; i++){
    11de:	83 c3 01             	add    $0x1,%ebx
    11e1:	83 fb 13             	cmp    $0x13,%ebx
    11e4:	7f 0a                	jg     11f0 <createdelete+0x1a7>
    for(pi = 0; pi < 4; pi++){
    11e6:	be 00 00 00 00       	mov    $0x0,%esi
    11eb:	e9 77 ff ff ff       	jmp    1167 <createdelete+0x11e>
    }
  }

  for(i = 0; i < N; i++){
    11f0:	be 00 00 00 00       	mov    $0x0,%esi
    11f5:	eb 26                	jmp    121d <createdelete+0x1d4>
    for(pi = 0; pi < 4; pi++){
      name[0] = 'p' + i;
    11f7:	8d 46 70             	lea    0x70(%esi),%eax
    11fa:	88 45 d8             	mov    %al,-0x28(%ebp)
      name[1] = '0' + i;
    11fd:	8d 46 30             	lea    0x30(%esi),%eax
    1200:	88 45 d9             	mov    %al,-0x27(%ebp)
      unlink(name);
    1203:	83 ec 0c             	sub    $0xc,%esp
    1206:	8d 45 d8             	lea    -0x28(%ebp),%eax
    1209:	50                   	push   %eax
    120a:	e8 13 26 00 00       	call   3822 <unlink>
    for(pi = 0; pi < 4; pi++){
    120f:	83 c3 01             	add    $0x1,%ebx
    1212:	83 c4 10             	add    $0x10,%esp
    1215:	83 fb 03             	cmp    $0x3,%ebx
    1218:	7e dd                	jle    11f7 <createdelete+0x1ae>
  for(i = 0; i < N; i++){
    121a:	83 c6 01             	add    $0x1,%esi
    121d:	83 fe 13             	cmp    $0x13,%esi
    1220:	7f 07                	jg     1229 <createdelete+0x1e0>
    for(pi = 0; pi < 4; pi++){
    1222:	bb 00 00 00 00       	mov    $0x0,%ebx
    1227:	eb ec                	jmp    1215 <createdelete+0x1cc>
    }
  }

  printf(1, "createdelete ok\n");
    1229:	83 ec 08             	sub    $0x8,%esp
    122c:	68 a3 40 00 00       	push   $0x40a3
    1231:	6a 01                	push   $0x1
    1233:	e8 e3 26 00 00       	call   391b <printf>
}
    1238:	83 c4 10             	add    $0x10,%esp
    123b:	8d 65 f8             	lea    -0x8(%ebp),%esp
    123e:	5b                   	pop    %ebx
    123f:	5e                   	pop    %esi
    1240:	5d                   	pop    %ebp
    1241:	c3                   	ret    

00001242 <unlinkread>:

// can I unlink a file and still read it?
void
unlinkread(void)
{
    1242:	f3 0f 1e fb          	endbr32 
    1246:	55                   	push   %ebp
    1247:	89 e5                	mov    %esp,%ebp
    1249:	56                   	push   %esi
    124a:	53                   	push   %ebx
  int fd, fd1;

  printf(1, "unlinkread test\n");
    124b:	83 ec 08             	sub    $0x8,%esp
    124e:	68 b4 40 00 00       	push   $0x40b4
    1253:	6a 01                	push   $0x1
    1255:	e8 c1 26 00 00       	call   391b <printf>
  fd = open("unlinkread", O_CREATE | O_RDWR);
    125a:	83 c4 08             	add    $0x8,%esp
    125d:	68 02 02 00 00       	push   $0x202
    1262:	68 c5 40 00 00       	push   $0x40c5
    1267:	e8 a6 25 00 00       	call   3812 <open>
  if(fd < 0){
    126c:	83 c4 10             	add    $0x10,%esp
    126f:	85 c0                	test   %eax,%eax
    1271:	0f 88 f0 00 00 00    	js     1367 <unlinkread+0x125>
    1277:	89 c3                	mov    %eax,%ebx
    printf(1, "create unlinkread failed\n");
    exit();
  }
  write(fd, "hello", 5);
    1279:	83 ec 04             	sub    $0x4,%esp
    127c:	6a 05                	push   $0x5
    127e:	68 ea 40 00 00       	push   $0x40ea
    1283:	50                   	push   %eax
    1284:	e8 69 25 00 00       	call   37f2 <write>
  close(fd);
    1289:	89 1c 24             	mov    %ebx,(%esp)
    128c:	e8 69 25 00 00       	call   37fa <close>

  fd = open("unlinkread", O_RDWR);
    1291:	83 c4 08             	add    $0x8,%esp
    1294:	6a 02                	push   $0x2
    1296:	68 c5 40 00 00       	push   $0x40c5
    129b:	e8 72 25 00 00       	call   3812 <open>
    12a0:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    12a2:	83 c4 10             	add    $0x10,%esp
    12a5:	85 c0                	test   %eax,%eax
    12a7:	0f 88 ce 00 00 00    	js     137b <unlinkread+0x139>
    printf(1, "open unlinkread failed\n");
    exit();
  }
  if(unlink("unlinkread") != 0){
    12ad:	83 ec 0c             	sub    $0xc,%esp
    12b0:	68 c5 40 00 00       	push   $0x40c5
    12b5:	e8 68 25 00 00       	call   3822 <unlink>
    12ba:	83 c4 10             	add    $0x10,%esp
    12bd:	85 c0                	test   %eax,%eax
    12bf:	0f 85 ca 00 00 00    	jne    138f <unlinkread+0x14d>
    printf(1, "unlink unlinkread failed\n");
    exit();
  }

  fd1 = open("unlinkread", O_CREATE | O_RDWR);
    12c5:	83 ec 08             	sub    $0x8,%esp
    12c8:	68 02 02 00 00       	push   $0x202
    12cd:	68 c5 40 00 00       	push   $0x40c5
    12d2:	e8 3b 25 00 00       	call   3812 <open>
    12d7:	89 c6                	mov    %eax,%esi
  write(fd1, "yyy", 3);
    12d9:	83 c4 0c             	add    $0xc,%esp
    12dc:	6a 03                	push   $0x3
    12de:	68 22 41 00 00       	push   $0x4122
    12e3:	50                   	push   %eax
    12e4:	e8 09 25 00 00       	call   37f2 <write>
  close(fd1);
    12e9:	89 34 24             	mov    %esi,(%esp)
    12ec:	e8 09 25 00 00       	call   37fa <close>

  if(read(fd, buf, sizeof(buf)) != 5){
    12f1:	83 c4 0c             	add    $0xc,%esp
    12f4:	68 00 20 00 00       	push   $0x2000
    12f9:	68 e0 83 00 00       	push   $0x83e0
    12fe:	53                   	push   %ebx
    12ff:	e8 e6 24 00 00       	call   37ea <read>
    1304:	83 c4 10             	add    $0x10,%esp
    1307:	83 f8 05             	cmp    $0x5,%eax
    130a:	0f 85 93 00 00 00    	jne    13a3 <unlinkread+0x161>
    printf(1, "unlinkread read failed");
    exit();
  }
  if(buf[0] != 'h'){
    1310:	80 3d e0 83 00 00 68 	cmpb   $0x68,0x83e0
    1317:	0f 85 9a 00 00 00    	jne    13b7 <unlinkread+0x175>
    printf(1, "unlinkread wrong data\n");
    exit();
  }
  if(write(fd, buf, 10) != 10){
    131d:	83 ec 04             	sub    $0x4,%esp
    1320:	6a 0a                	push   $0xa
    1322:	68 e0 83 00 00       	push   $0x83e0
    1327:	53                   	push   %ebx
    1328:	e8 c5 24 00 00       	call   37f2 <write>
    132d:	83 c4 10             	add    $0x10,%esp
    1330:	83 f8 0a             	cmp    $0xa,%eax
    1333:	0f 85 92 00 00 00    	jne    13cb <unlinkread+0x189>
    printf(1, "unlinkread write failed\n");
    exit();
  }
  close(fd);
    1339:	83 ec 0c             	sub    $0xc,%esp
    133c:	53                   	push   %ebx
    133d:	e8 b8 24 00 00       	call   37fa <close>
  unlink("unlinkread");
    1342:	c7 04 24 c5 40 00 00 	movl   $0x40c5,(%esp)
    1349:	e8 d4 24 00 00       	call   3822 <unlink>
  printf(1, "unlinkread ok\n");
    134e:	83 c4 08             	add    $0x8,%esp
    1351:	68 6d 41 00 00       	push   $0x416d
    1356:	6a 01                	push   $0x1
    1358:	e8 be 25 00 00       	call   391b <printf>
}
    135d:	83 c4 10             	add    $0x10,%esp
    1360:	8d 65 f8             	lea    -0x8(%ebp),%esp
    1363:	5b                   	pop    %ebx
    1364:	5e                   	pop    %esi
    1365:	5d                   	pop    %ebp
    1366:	c3                   	ret    
    printf(1, "create unlinkread failed\n");
    1367:	83 ec 08             	sub    $0x8,%esp
    136a:	68 d0 40 00 00       	push   $0x40d0
    136f:	6a 01                	push   $0x1
    1371:	e8 a5 25 00 00       	call   391b <printf>
    exit();
    1376:	e8 57 24 00 00       	call   37d2 <exit>
    printf(1, "open unlinkread failed\n");
    137b:	83 ec 08             	sub    $0x8,%esp
    137e:	68 f0 40 00 00       	push   $0x40f0
    1383:	6a 01                	push   $0x1
    1385:	e8 91 25 00 00       	call   391b <printf>
    exit();
    138a:	e8 43 24 00 00       	call   37d2 <exit>
    printf(1, "unlink unlinkread failed\n");
    138f:	83 ec 08             	sub    $0x8,%esp
    1392:	68 08 41 00 00       	push   $0x4108
    1397:	6a 01                	push   $0x1
    1399:	e8 7d 25 00 00       	call   391b <printf>
    exit();
    139e:	e8 2f 24 00 00       	call   37d2 <exit>
    printf(1, "unlinkread read failed");
    13a3:	83 ec 08             	sub    $0x8,%esp
    13a6:	68 26 41 00 00       	push   $0x4126
    13ab:	6a 01                	push   $0x1
    13ad:	e8 69 25 00 00       	call   391b <printf>
    exit();
    13b2:	e8 1b 24 00 00       	call   37d2 <exit>
    printf(1, "unlinkread wrong data\n");
    13b7:	83 ec 08             	sub    $0x8,%esp
    13ba:	68 3d 41 00 00       	push   $0x413d
    13bf:	6a 01                	push   $0x1
    13c1:	e8 55 25 00 00       	call   391b <printf>
    exit();
    13c6:	e8 07 24 00 00       	call   37d2 <exit>
    printf(1, "unlinkread write failed\n");
    13cb:	83 ec 08             	sub    $0x8,%esp
    13ce:	68 54 41 00 00       	push   $0x4154
    13d3:	6a 01                	push   $0x1
    13d5:	e8 41 25 00 00       	call   391b <printf>
    exit();
    13da:	e8 f3 23 00 00       	call   37d2 <exit>

000013df <linktest>:

void
linktest(void)
{
    13df:	f3 0f 1e fb          	endbr32 
    13e3:	55                   	push   %ebp
    13e4:	89 e5                	mov    %esp,%ebp
    13e6:	53                   	push   %ebx
    13e7:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "linktest\n");
    13ea:	68 7c 41 00 00       	push   $0x417c
    13ef:	6a 01                	push   $0x1
    13f1:	e8 25 25 00 00       	call   391b <printf>

  unlink("lf1");
    13f6:	c7 04 24 86 41 00 00 	movl   $0x4186,(%esp)
    13fd:	e8 20 24 00 00       	call   3822 <unlink>
  unlink("lf2");
    1402:	c7 04 24 8a 41 00 00 	movl   $0x418a,(%esp)
    1409:	e8 14 24 00 00       	call   3822 <unlink>

  fd = open("lf1", O_CREATE|O_RDWR);
    140e:	83 c4 08             	add    $0x8,%esp
    1411:	68 02 02 00 00       	push   $0x202
    1416:	68 86 41 00 00       	push   $0x4186
    141b:	e8 f2 23 00 00       	call   3812 <open>
  if(fd < 0){
    1420:	83 c4 10             	add    $0x10,%esp
    1423:	85 c0                	test   %eax,%eax
    1425:	0f 88 2a 01 00 00    	js     1555 <linktest+0x176>
    142b:	89 c3                	mov    %eax,%ebx
    printf(1, "create lf1 failed\n");
    exit();
  }
  if(write(fd, "hello", 5) != 5){
    142d:	83 ec 04             	sub    $0x4,%esp
    1430:	6a 05                	push   $0x5
    1432:	68 ea 40 00 00       	push   $0x40ea
    1437:	50                   	push   %eax
    1438:	e8 b5 23 00 00       	call   37f2 <write>
    143d:	83 c4 10             	add    $0x10,%esp
    1440:	83 f8 05             	cmp    $0x5,%eax
    1443:	0f 85 20 01 00 00    	jne    1569 <linktest+0x18a>
    printf(1, "write lf1 failed\n");
    exit();
  }
  close(fd);
    1449:	83 ec 0c             	sub    $0xc,%esp
    144c:	53                   	push   %ebx
    144d:	e8 a8 23 00 00       	call   37fa <close>

  if(link("lf1", "lf2") < 0){
    1452:	83 c4 08             	add    $0x8,%esp
    1455:	68 8a 41 00 00       	push   $0x418a
    145a:	68 86 41 00 00       	push   $0x4186
    145f:	e8 ce 23 00 00       	call   3832 <link>
    1464:	83 c4 10             	add    $0x10,%esp
    1467:	85 c0                	test   %eax,%eax
    1469:	0f 88 0e 01 00 00    	js     157d <linktest+0x19e>
    printf(1, "link lf1 lf2 failed\n");
    exit();
  }
  unlink("lf1");
    146f:	83 ec 0c             	sub    $0xc,%esp
    1472:	68 86 41 00 00       	push   $0x4186
    1477:	e8 a6 23 00 00       	call   3822 <unlink>

  if(open("lf1", 0) >= 0){
    147c:	83 c4 08             	add    $0x8,%esp
    147f:	6a 00                	push   $0x0
    1481:	68 86 41 00 00       	push   $0x4186
    1486:	e8 87 23 00 00       	call   3812 <open>
    148b:	83 c4 10             	add    $0x10,%esp
    148e:	85 c0                	test   %eax,%eax
    1490:	0f 89 fb 00 00 00    	jns    1591 <linktest+0x1b2>
    printf(1, "unlinked lf1 but it is still there!\n");
    exit();
  }

  fd = open("lf2", 0);
    1496:	83 ec 08             	sub    $0x8,%esp
    1499:	6a 00                	push   $0x0
    149b:	68 8a 41 00 00       	push   $0x418a
    14a0:	e8 6d 23 00 00       	call   3812 <open>
    14a5:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    14a7:	83 c4 10             	add    $0x10,%esp
    14aa:	85 c0                	test   %eax,%eax
    14ac:	0f 88 f3 00 00 00    	js     15a5 <linktest+0x1c6>
    printf(1, "open lf2 failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 5){
    14b2:	83 ec 04             	sub    $0x4,%esp
    14b5:	68 00 20 00 00       	push   $0x2000
    14ba:	68 e0 83 00 00       	push   $0x83e0
    14bf:	50                   	push   %eax
    14c0:	e8 25 23 00 00       	call   37ea <read>
    14c5:	83 c4 10             	add    $0x10,%esp
    14c8:	83 f8 05             	cmp    $0x5,%eax
    14cb:	0f 85 e8 00 00 00    	jne    15b9 <linktest+0x1da>
    printf(1, "read lf2 failed\n");
    exit();
  }
  close(fd);
    14d1:	83 ec 0c             	sub    $0xc,%esp
    14d4:	53                   	push   %ebx
    14d5:	e8 20 23 00 00       	call   37fa <close>

  if(link("lf2", "lf2") >= 0){
    14da:	83 c4 08             	add    $0x8,%esp
    14dd:	68 8a 41 00 00       	push   $0x418a
    14e2:	68 8a 41 00 00       	push   $0x418a
    14e7:	e8 46 23 00 00       	call   3832 <link>
    14ec:	83 c4 10             	add    $0x10,%esp
    14ef:	85 c0                	test   %eax,%eax
    14f1:	0f 89 d6 00 00 00    	jns    15cd <linktest+0x1ee>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    exit();
  }

  unlink("lf2");
    14f7:	83 ec 0c             	sub    $0xc,%esp
    14fa:	68 8a 41 00 00       	push   $0x418a
    14ff:	e8 1e 23 00 00       	call   3822 <unlink>
  if(link("lf2", "lf1") >= 0){
    1504:	83 c4 08             	add    $0x8,%esp
    1507:	68 86 41 00 00       	push   $0x4186
    150c:	68 8a 41 00 00       	push   $0x418a
    1511:	e8 1c 23 00 00       	call   3832 <link>
    1516:	83 c4 10             	add    $0x10,%esp
    1519:	85 c0                	test   %eax,%eax
    151b:	0f 89 c0 00 00 00    	jns    15e1 <linktest+0x202>
    printf(1, "link non-existant succeeded! oops\n");
    exit();
  }

  if(link(".", "lf1") >= 0){
    1521:	83 ec 08             	sub    $0x8,%esp
    1524:	68 86 41 00 00       	push   $0x4186
    1529:	68 4e 44 00 00       	push   $0x444e
    152e:	e8 ff 22 00 00       	call   3832 <link>
    1533:	83 c4 10             	add    $0x10,%esp
    1536:	85 c0                	test   %eax,%eax
    1538:	0f 89 b7 00 00 00    	jns    15f5 <linktest+0x216>
    printf(1, "link . lf1 succeeded! oops\n");
    exit();
  }

  printf(1, "linktest ok\n");
    153e:	83 ec 08             	sub    $0x8,%esp
    1541:	68 24 42 00 00       	push   $0x4224
    1546:	6a 01                	push   $0x1
    1548:	e8 ce 23 00 00       	call   391b <printf>
}
    154d:	83 c4 10             	add    $0x10,%esp
    1550:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1553:	c9                   	leave  
    1554:	c3                   	ret    
    printf(1, "create lf1 failed\n");
    1555:	83 ec 08             	sub    $0x8,%esp
    1558:	68 8e 41 00 00       	push   $0x418e
    155d:	6a 01                	push   $0x1
    155f:	e8 b7 23 00 00       	call   391b <printf>
    exit();
    1564:	e8 69 22 00 00       	call   37d2 <exit>
    printf(1, "write lf1 failed\n");
    1569:	83 ec 08             	sub    $0x8,%esp
    156c:	68 a1 41 00 00       	push   $0x41a1
    1571:	6a 01                	push   $0x1
    1573:	e8 a3 23 00 00       	call   391b <printf>
    exit();
    1578:	e8 55 22 00 00       	call   37d2 <exit>
    printf(1, "link lf1 lf2 failed\n");
    157d:	83 ec 08             	sub    $0x8,%esp
    1580:	68 b3 41 00 00       	push   $0x41b3
    1585:	6a 01                	push   $0x1
    1587:	e8 8f 23 00 00       	call   391b <printf>
    exit();
    158c:	e8 41 22 00 00       	call   37d2 <exit>
    printf(1, "unlinked lf1 but it is still there!\n");
    1591:	83 ec 08             	sub    $0x8,%esp
    1594:	68 94 4d 00 00       	push   $0x4d94
    1599:	6a 01                	push   $0x1
    159b:	e8 7b 23 00 00       	call   391b <printf>
    exit();
    15a0:	e8 2d 22 00 00       	call   37d2 <exit>
    printf(1, "open lf2 failed\n");
    15a5:	83 ec 08             	sub    $0x8,%esp
    15a8:	68 c8 41 00 00       	push   $0x41c8
    15ad:	6a 01                	push   $0x1
    15af:	e8 67 23 00 00       	call   391b <printf>
    exit();
    15b4:	e8 19 22 00 00       	call   37d2 <exit>
    printf(1, "read lf2 failed\n");
    15b9:	83 ec 08             	sub    $0x8,%esp
    15bc:	68 d9 41 00 00       	push   $0x41d9
    15c1:	6a 01                	push   $0x1
    15c3:	e8 53 23 00 00       	call   391b <printf>
    exit();
    15c8:	e8 05 22 00 00       	call   37d2 <exit>
    printf(1, "link lf2 lf2 succeeded! oops\n");
    15cd:	83 ec 08             	sub    $0x8,%esp
    15d0:	68 ea 41 00 00       	push   $0x41ea
    15d5:	6a 01                	push   $0x1
    15d7:	e8 3f 23 00 00       	call   391b <printf>
    exit();
    15dc:	e8 f1 21 00 00       	call   37d2 <exit>
    printf(1, "link non-existant succeeded! oops\n");
    15e1:	83 ec 08             	sub    $0x8,%esp
    15e4:	68 bc 4d 00 00       	push   $0x4dbc
    15e9:	6a 01                	push   $0x1
    15eb:	e8 2b 23 00 00       	call   391b <printf>
    exit();
    15f0:	e8 dd 21 00 00       	call   37d2 <exit>
    printf(1, "link . lf1 succeeded! oops\n");
    15f5:	83 ec 08             	sub    $0x8,%esp
    15f8:	68 08 42 00 00       	push   $0x4208
    15fd:	6a 01                	push   $0x1
    15ff:	e8 17 23 00 00       	call   391b <printf>
    exit();
    1604:	e8 c9 21 00 00       	call   37d2 <exit>

00001609 <concreate>:

// test concurrent create/link/unlink of the same file
void
concreate(void)
{
    1609:	f3 0f 1e fb          	endbr32 
    160d:	55                   	push   %ebp
    160e:	89 e5                	mov    %esp,%ebp
    1610:	57                   	push   %edi
    1611:	56                   	push   %esi
    1612:	53                   	push   %ebx
    1613:	83 ec 54             	sub    $0x54,%esp
  struct {
    ushort inum;
    char name[14];
  } de;

  printf(1, "concreate test\n");
    1616:	68 31 42 00 00       	push   $0x4231
    161b:	6a 01                	push   $0x1
    161d:	e8 f9 22 00 00       	call   391b <printf>
  file[0] = 'C';
    1622:	c6 45 e5 43          	movb   $0x43,-0x1b(%ebp)
  file[2] = '\0';
    1626:	c6 45 e7 00          	movb   $0x0,-0x19(%ebp)
  for(i = 0; i < 40; i++){
    162a:	83 c4 10             	add    $0x10,%esp
    162d:	bb 00 00 00 00       	mov    $0x0,%ebx
    1632:	eb 5e                	jmp    1692 <concreate+0x89>
    file[1] = '0' + i;
    unlink(file);
    pid = fork();
    if(pid && (i % 3) == 1){
      link("C0", file);
    } else if(pid == 0 && (i % 5) == 1){
    1634:	85 f6                	test   %esi,%esi
    1636:	75 22                	jne    165a <concreate+0x51>
    1638:	ba 67 66 66 66       	mov    $0x66666667,%edx
    163d:	89 d8                	mov    %ebx,%eax
    163f:	f7 ea                	imul   %edx
    1641:	d1 fa                	sar    %edx
    1643:	89 d8                	mov    %ebx,%eax
    1645:	c1 f8 1f             	sar    $0x1f,%eax
    1648:	29 c2                	sub    %eax,%edx
    164a:	8d 04 92             	lea    (%edx,%edx,4),%eax
    164d:	89 da                	mov    %ebx,%edx
    164f:	29 c2                	sub    %eax,%edx
    1651:	83 fa 01             	cmp    $0x1,%edx
    1654:	0f 84 9b 00 00 00    	je     16f5 <concreate+0xec>
      link("C0", file);
    } else {
      fd = open(file, O_CREATE | O_RDWR);
    165a:	83 ec 08             	sub    $0x8,%esp
    165d:	68 02 02 00 00       	push   $0x202
    1662:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1665:	50                   	push   %eax
    1666:	e8 a7 21 00 00       	call   3812 <open>
      if(fd < 0){
    166b:	83 c4 10             	add    $0x10,%esp
    166e:	85 c0                	test   %eax,%eax
    1670:	0f 88 98 00 00 00    	js     170e <concreate+0x105>
        printf(1, "concreate create %s failed\n", file);
        exit();
      }
      close(fd);
    1676:	83 ec 0c             	sub    $0xc,%esp
    1679:	50                   	push   %eax
    167a:	e8 7b 21 00 00       	call   37fa <close>
    167f:	83 c4 10             	add    $0x10,%esp
    }
    if(pid == 0)
    1682:	85 f6                	test   %esi,%esi
    1684:	0f 84 9c 00 00 00    	je     1726 <concreate+0x11d>
      exit();
    else
      wait();
    168a:	e8 4b 21 00 00       	call   37da <wait>
  for(i = 0; i < 40; i++){
    168f:	83 c3 01             	add    $0x1,%ebx
    1692:	83 fb 27             	cmp    $0x27,%ebx
    1695:	0f 8f 90 00 00 00    	jg     172b <concreate+0x122>
    file[1] = '0' + i;
    169b:	8d 43 30             	lea    0x30(%ebx),%eax
    169e:	88 45 e6             	mov    %al,-0x1a(%ebp)
    unlink(file);
    16a1:	83 ec 0c             	sub    $0xc,%esp
    16a4:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16a7:	50                   	push   %eax
    16a8:	e8 75 21 00 00       	call   3822 <unlink>
    pid = fork();
    16ad:	e8 18 21 00 00       	call   37ca <fork>
    16b2:	89 c6                	mov    %eax,%esi
    if(pid && (i % 3) == 1){
    16b4:	83 c4 10             	add    $0x10,%esp
    16b7:	85 c0                	test   %eax,%eax
    16b9:	0f 84 75 ff ff ff    	je     1634 <concreate+0x2b>
    16bf:	ba 56 55 55 55       	mov    $0x55555556,%edx
    16c4:	89 d8                	mov    %ebx,%eax
    16c6:	f7 ea                	imul   %edx
    16c8:	89 d8                	mov    %ebx,%eax
    16ca:	c1 f8 1f             	sar    $0x1f,%eax
    16cd:	29 c2                	sub    %eax,%edx
    16cf:	8d 04 52             	lea    (%edx,%edx,2),%eax
    16d2:	89 da                	mov    %ebx,%edx
    16d4:	29 c2                	sub    %eax,%edx
    16d6:	83 fa 01             	cmp    $0x1,%edx
    16d9:	0f 85 55 ff ff ff    	jne    1634 <concreate+0x2b>
      link("C0", file);
    16df:	83 ec 08             	sub    $0x8,%esp
    16e2:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16e5:	50                   	push   %eax
    16e6:	68 41 42 00 00       	push   $0x4241
    16eb:	e8 42 21 00 00       	call   3832 <link>
    16f0:	83 c4 10             	add    $0x10,%esp
    16f3:	eb 8d                	jmp    1682 <concreate+0x79>
      link("C0", file);
    16f5:	83 ec 08             	sub    $0x8,%esp
    16f8:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    16fb:	50                   	push   %eax
    16fc:	68 41 42 00 00       	push   $0x4241
    1701:	e8 2c 21 00 00       	call   3832 <link>
    1706:	83 c4 10             	add    $0x10,%esp
    1709:	e9 74 ff ff ff       	jmp    1682 <concreate+0x79>
        printf(1, "concreate create %s failed\n", file);
    170e:	83 ec 04             	sub    $0x4,%esp
    1711:	8d 45 e5             	lea    -0x1b(%ebp),%eax
    1714:	50                   	push   %eax
    1715:	68 44 42 00 00       	push   $0x4244
    171a:	6a 01                	push   $0x1
    171c:	e8 fa 21 00 00       	call   391b <printf>
        exit();
    1721:	e8 ac 20 00 00       	call   37d2 <exit>
      exit();
    1726:	e8 a7 20 00 00       	call   37d2 <exit>
  }

  memset(fa, 0, sizeof(fa));
    172b:	83 ec 04             	sub    $0x4,%esp
    172e:	6a 28                	push   $0x28
    1730:	6a 00                	push   $0x0
    1732:	8d 45 bd             	lea    -0x43(%ebp),%eax
    1735:	50                   	push   %eax
    1736:	e8 4a 1f 00 00       	call   3685 <memset>
  fd = open(".", 0);
    173b:	83 c4 08             	add    $0x8,%esp
    173e:	6a 00                	push   $0x0
    1740:	68 4e 44 00 00       	push   $0x444e
    1745:	e8 c8 20 00 00       	call   3812 <open>
    174a:	89 c3                	mov    %eax,%ebx
  n = 0;
  while(read(fd, &de, sizeof(de)) > 0){
    174c:	83 c4 10             	add    $0x10,%esp
  n = 0;
    174f:	be 00 00 00 00       	mov    $0x0,%esi
  while(read(fd, &de, sizeof(de)) > 0){
    1754:	83 ec 04             	sub    $0x4,%esp
    1757:	6a 10                	push   $0x10
    1759:	8d 45 ac             	lea    -0x54(%ebp),%eax
    175c:	50                   	push   %eax
    175d:	53                   	push   %ebx
    175e:	e8 87 20 00 00       	call   37ea <read>
    1763:	83 c4 10             	add    $0x10,%esp
    1766:	85 c0                	test   %eax,%eax
    1768:	7e 60                	jle    17ca <concreate+0x1c1>
    if(de.inum == 0)
    176a:	66 83 7d ac 00       	cmpw   $0x0,-0x54(%ebp)
    176f:	74 e3                	je     1754 <concreate+0x14b>
      continue;
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    1771:	80 7d ae 43          	cmpb   $0x43,-0x52(%ebp)
    1775:	75 dd                	jne    1754 <concreate+0x14b>
    1777:	80 7d b0 00          	cmpb   $0x0,-0x50(%ebp)
    177b:	75 d7                	jne    1754 <concreate+0x14b>
      i = de.name[1] - '0';
    177d:	0f be 45 af          	movsbl -0x51(%ebp),%eax
    1781:	83 e8 30             	sub    $0x30,%eax
      if(i < 0 || i >= sizeof(fa)){
    1784:	83 f8 27             	cmp    $0x27,%eax
    1787:	77 11                	ja     179a <concreate+0x191>
        printf(1, "concreate weird file %s\n", de.name);
        exit();
      }
      if(fa[i]){
    1789:	80 7c 05 bd 00       	cmpb   $0x0,-0x43(%ebp,%eax,1)
    178e:	75 22                	jne    17b2 <concreate+0x1a9>
        printf(1, "concreate duplicate file %s\n", de.name);
        exit();
      }
      fa[i] = 1;
    1790:	c6 44 05 bd 01       	movb   $0x1,-0x43(%ebp,%eax,1)
      n++;
    1795:	83 c6 01             	add    $0x1,%esi
    1798:	eb ba                	jmp    1754 <concreate+0x14b>
        printf(1, "concreate weird file %s\n", de.name);
    179a:	83 ec 04             	sub    $0x4,%esp
    179d:	8d 45 ae             	lea    -0x52(%ebp),%eax
    17a0:	50                   	push   %eax
    17a1:	68 60 42 00 00       	push   $0x4260
    17a6:	6a 01                	push   $0x1
    17a8:	e8 6e 21 00 00       	call   391b <printf>
        exit();
    17ad:	e8 20 20 00 00       	call   37d2 <exit>
        printf(1, "concreate duplicate file %s\n", de.name);
    17b2:	83 ec 04             	sub    $0x4,%esp
    17b5:	8d 45 ae             	lea    -0x52(%ebp),%eax
    17b8:	50                   	push   %eax
    17b9:	68 79 42 00 00       	push   $0x4279
    17be:	6a 01                	push   $0x1
    17c0:	e8 56 21 00 00       	call   391b <printf>
        exit();
    17c5:	e8 08 20 00 00       	call   37d2 <exit>
    }
  }
  close(fd);
    17ca:	83 ec 0c             	sub    $0xc,%esp
    17cd:	53                   	push   %ebx
    17ce:	e8 27 20 00 00       	call   37fa <close>

  if(n != 40){
    17d3:	83 c4 10             	add    $0x10,%esp
    17d6:	83 fe 28             	cmp    $0x28,%esi
    17d9:	75 0a                	jne    17e5 <concreate+0x1dc>
    printf(1, "concreate not enough files in directory listing\n");
    exit();
  }

  for(i = 0; i < 40; i++){
    17db:	bb 00 00 00 00       	mov    $0x0,%ebx
    17e0:	e9 86 00 00 00       	jmp    186b <concreate+0x262>
    printf(1, "concreate not enough files in directory listing\n");
    17e5:	83 ec 08             	sub    $0x8,%esp
    17e8:	68 e0 4d 00 00       	push   $0x4de0
    17ed:	6a 01                	push   $0x1
    17ef:	e8 27 21 00 00       	call   391b <printf>
    exit();
    17f4:	e8 d9 1f 00 00       	call   37d2 <exit>
    file[1] = '0' + i;
    pid = fork();
    if(pid < 0){
      printf(1, "fork failed\n");
    17f9:	83 ec 08             	sub    $0x8,%esp
    17fc:	68 19 4b 00 00       	push   $0x4b19
    1801:	6a 01                	push   $0x1
    1803:	e8 13 21 00 00       	call   391b <printf>
      exit();
    1808:	e8 c5 1f 00 00       	call   37d2 <exit>
    }
    if(((i % 3) == 0 && pid == 0) ||
       ((i % 3) == 1 && pid != 0)){
      close(open(file, 0));
    180d:	83 ec 08             	sub    $0x8,%esp
    1810:	6a 00                	push   $0x0
    1812:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    1815:	57                   	push   %edi
    1816:	e8 f7 1f 00 00       	call   3812 <open>
    181b:	89 04 24             	mov    %eax,(%esp)
    181e:	e8 d7 1f 00 00       	call   37fa <close>
      close(open(file, 0));
    1823:	83 c4 08             	add    $0x8,%esp
    1826:	6a 00                	push   $0x0
    1828:	57                   	push   %edi
    1829:	e8 e4 1f 00 00       	call   3812 <open>
    182e:	89 04 24             	mov    %eax,(%esp)
    1831:	e8 c4 1f 00 00       	call   37fa <close>
      close(open(file, 0));
    1836:	83 c4 08             	add    $0x8,%esp
    1839:	6a 00                	push   $0x0
    183b:	57                   	push   %edi
    183c:	e8 d1 1f 00 00       	call   3812 <open>
    1841:	89 04 24             	mov    %eax,(%esp)
    1844:	e8 b1 1f 00 00       	call   37fa <close>
      close(open(file, 0));
    1849:	83 c4 08             	add    $0x8,%esp
    184c:	6a 00                	push   $0x0
    184e:	57                   	push   %edi
    184f:	e8 be 1f 00 00       	call   3812 <open>
    1854:	89 04 24             	mov    %eax,(%esp)
    1857:	e8 9e 1f 00 00       	call   37fa <close>
    185c:	83 c4 10             	add    $0x10,%esp
      unlink(file);
      unlink(file);
      unlink(file);
      unlink(file);
    }
    if(pid == 0)
    185f:	85 f6                	test   %esi,%esi
    1861:	74 79                	je     18dc <concreate+0x2d3>
      exit();
    else
      wait();
    1863:	e8 72 1f 00 00       	call   37da <wait>
  for(i = 0; i < 40; i++){
    1868:	83 c3 01             	add    $0x1,%ebx
    186b:	83 fb 27             	cmp    $0x27,%ebx
    186e:	7f 71                	jg     18e1 <concreate+0x2d8>
    file[1] = '0' + i;
    1870:	8d 43 30             	lea    0x30(%ebx),%eax
    1873:	88 45 e6             	mov    %al,-0x1a(%ebp)
    pid = fork();
    1876:	e8 4f 1f 00 00       	call   37ca <fork>
    187b:	89 c6                	mov    %eax,%esi
    if(pid < 0){
    187d:	85 c0                	test   %eax,%eax
    187f:	0f 88 74 ff ff ff    	js     17f9 <concreate+0x1f0>
    if(((i % 3) == 0 && pid == 0) ||
    1885:	ba 56 55 55 55       	mov    $0x55555556,%edx
    188a:	89 d8                	mov    %ebx,%eax
    188c:	f7 ea                	imul   %edx
    188e:	89 d8                	mov    %ebx,%eax
    1890:	c1 f8 1f             	sar    $0x1f,%eax
    1893:	29 c2                	sub    %eax,%edx
    1895:	8d 04 52             	lea    (%edx,%edx,2),%eax
    1898:	89 da                	mov    %ebx,%edx
    189a:	29 c2                	sub    %eax,%edx
    189c:	89 d0                	mov    %edx,%eax
    189e:	09 f0                	or     %esi,%eax
    18a0:	0f 84 67 ff ff ff    	je     180d <concreate+0x204>
    18a6:	83 fa 01             	cmp    $0x1,%edx
    18a9:	75 08                	jne    18b3 <concreate+0x2aa>
       ((i % 3) == 1 && pid != 0)){
    18ab:	85 f6                	test   %esi,%esi
    18ad:	0f 85 5a ff ff ff    	jne    180d <concreate+0x204>
      unlink(file);
    18b3:	83 ec 0c             	sub    $0xc,%esp
    18b6:	8d 7d e5             	lea    -0x1b(%ebp),%edi
    18b9:	57                   	push   %edi
    18ba:	e8 63 1f 00 00       	call   3822 <unlink>
      unlink(file);
    18bf:	89 3c 24             	mov    %edi,(%esp)
    18c2:	e8 5b 1f 00 00       	call   3822 <unlink>
      unlink(file);
    18c7:	89 3c 24             	mov    %edi,(%esp)
    18ca:	e8 53 1f 00 00       	call   3822 <unlink>
      unlink(file);
    18cf:	89 3c 24             	mov    %edi,(%esp)
    18d2:	e8 4b 1f 00 00       	call   3822 <unlink>
    18d7:	83 c4 10             	add    $0x10,%esp
    18da:	eb 83                	jmp    185f <concreate+0x256>
      exit();
    18dc:	e8 f1 1e 00 00       	call   37d2 <exit>
  }

  printf(1, "concreate ok\n");
    18e1:	83 ec 08             	sub    $0x8,%esp
    18e4:	68 96 42 00 00       	push   $0x4296
    18e9:	6a 01                	push   $0x1
    18eb:	e8 2b 20 00 00       	call   391b <printf>
}
    18f0:	83 c4 10             	add    $0x10,%esp
    18f3:	8d 65 f4             	lea    -0xc(%ebp),%esp
    18f6:	5b                   	pop    %ebx
    18f7:	5e                   	pop    %esi
    18f8:	5f                   	pop    %edi
    18f9:	5d                   	pop    %ebp
    18fa:	c3                   	ret    

000018fb <linkunlink>:

// another concurrent link/unlink/create test,
// to look for deadlocks.
void
linkunlink()
{
    18fb:	f3 0f 1e fb          	endbr32 
    18ff:	55                   	push   %ebp
    1900:	89 e5                	mov    %esp,%ebp
    1902:	57                   	push   %edi
    1903:	56                   	push   %esi
    1904:	53                   	push   %ebx
    1905:	83 ec 14             	sub    $0x14,%esp
  int pid, i;

  printf(1, "linkunlink test\n");
    1908:	68 a4 42 00 00       	push   $0x42a4
    190d:	6a 01                	push   $0x1
    190f:	e8 07 20 00 00       	call   391b <printf>

  unlink("x");
    1914:	c7 04 24 31 45 00 00 	movl   $0x4531,(%esp)
    191b:	e8 02 1f 00 00       	call   3822 <unlink>
  pid = fork();
    1920:	e8 a5 1e 00 00       	call   37ca <fork>
  if(pid < 0){
    1925:	83 c4 10             	add    $0x10,%esp
    1928:	85 c0                	test   %eax,%eax
    192a:	78 10                	js     193c <linkunlink+0x41>
    192c:	89 c7                	mov    %eax,%edi
    printf(1, "fork failed\n");
    exit();
  }

  unsigned int x = (pid ? 1 : 97);
    192e:	74 20                	je     1950 <linkunlink+0x55>
    1930:	bb 01 00 00 00       	mov    $0x1,%ebx
    1935:	be 00 00 00 00       	mov    $0x0,%esi
    193a:	eb 4d                	jmp    1989 <linkunlink+0x8e>
    printf(1, "fork failed\n");
    193c:	83 ec 08             	sub    $0x8,%esp
    193f:	68 19 4b 00 00       	push   $0x4b19
    1944:	6a 01                	push   $0x1
    1946:	e8 d0 1f 00 00       	call   391b <printf>
    exit();
    194b:	e8 82 1e 00 00       	call   37d2 <exit>
  unsigned int x = (pid ? 1 : 97);
    1950:	bb 61 00 00 00       	mov    $0x61,%ebx
    1955:	eb de                	jmp    1935 <linkunlink+0x3a>
  for(i = 0; i < 100; i++){
    x = x * 1103515245 + 12345;
    if((x % 3) == 0){
      close(open("x", O_RDWR | O_CREATE));
    1957:	83 ec 08             	sub    $0x8,%esp
    195a:	68 02 02 00 00       	push   $0x202
    195f:	68 31 45 00 00       	push   $0x4531
    1964:	e8 a9 1e 00 00       	call   3812 <open>
    1969:	89 04 24             	mov    %eax,(%esp)
    196c:	e8 89 1e 00 00       	call   37fa <close>
    1971:	83 c4 10             	add    $0x10,%esp
    1974:	eb 10                	jmp    1986 <linkunlink+0x8b>
    } else if((x % 3) == 1){
      link("cat", "x");
    } else {
      unlink("x");
    1976:	83 ec 0c             	sub    $0xc,%esp
    1979:	68 31 45 00 00       	push   $0x4531
    197e:	e8 9f 1e 00 00       	call   3822 <unlink>
    1983:	83 c4 10             	add    $0x10,%esp
  for(i = 0; i < 100; i++){
    1986:	83 c6 01             	add    $0x1,%esi
    1989:	83 fe 63             	cmp    $0x63,%esi
    198c:	7f 40                	jg     19ce <linkunlink+0xd3>
    x = x * 1103515245 + 12345;
    198e:	69 db 6d 4e c6 41    	imul   $0x41c64e6d,%ebx,%ebx
    1994:	81 c3 39 30 00 00    	add    $0x3039,%ebx
    if((x % 3) == 0){
    199a:	ba ab aa aa aa       	mov    $0xaaaaaaab,%edx
    199f:	89 d8                	mov    %ebx,%eax
    19a1:	f7 e2                	mul    %edx
    19a3:	89 d0                	mov    %edx,%eax
    19a5:	d1 e8                	shr    %eax
    19a7:	83 e2 fe             	and    $0xfffffffe,%edx
    19aa:	01 c2                	add    %eax,%edx
    19ac:	89 d8                	mov    %ebx,%eax
    19ae:	29 d0                	sub    %edx,%eax
    19b0:	74 a5                	je     1957 <linkunlink+0x5c>
    } else if((x % 3) == 1){
    19b2:	83 f8 01             	cmp    $0x1,%eax
    19b5:	75 bf                	jne    1976 <linkunlink+0x7b>
      link("cat", "x");
    19b7:	83 ec 08             	sub    $0x8,%esp
    19ba:	68 31 45 00 00       	push   $0x4531
    19bf:	68 b5 42 00 00       	push   $0x42b5
    19c4:	e8 69 1e 00 00       	call   3832 <link>
    19c9:	83 c4 10             	add    $0x10,%esp
    19cc:	eb b8                	jmp    1986 <linkunlink+0x8b>
    }
  }

  if(pid)
    19ce:	85 ff                	test   %edi,%edi
    19d0:	74 1c                	je     19ee <linkunlink+0xf3>
    wait();
    19d2:	e8 03 1e 00 00       	call   37da <wait>
  else
    exit();

  printf(1, "linkunlink ok\n");
    19d7:	83 ec 08             	sub    $0x8,%esp
    19da:	68 b9 42 00 00       	push   $0x42b9
    19df:	6a 01                	push   $0x1
    19e1:	e8 35 1f 00 00       	call   391b <printf>
}
    19e6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    19e9:	5b                   	pop    %ebx
    19ea:	5e                   	pop    %esi
    19eb:	5f                   	pop    %edi
    19ec:	5d                   	pop    %ebp
    19ed:	c3                   	ret    
    exit();
    19ee:	e8 df 1d 00 00       	call   37d2 <exit>

000019f3 <bigdir>:

// directory that uses indirect blocks
void
bigdir(void)
{
    19f3:	f3 0f 1e fb          	endbr32 
    19f7:	55                   	push   %ebp
    19f8:	89 e5                	mov    %esp,%ebp
    19fa:	53                   	push   %ebx
    19fb:	83 ec 1c             	sub    $0x1c,%esp
  int i, fd;
  char name[10];

  printf(1, "bigdir test\n");
    19fe:	68 c8 42 00 00       	push   $0x42c8
    1a03:	6a 01                	push   $0x1
    1a05:	e8 11 1f 00 00       	call   391b <printf>
  unlink("bd");
    1a0a:	c7 04 24 d5 42 00 00 	movl   $0x42d5,(%esp)
    1a11:	e8 0c 1e 00 00       	call   3822 <unlink>

  fd = open("bd", O_CREATE);
    1a16:	83 c4 08             	add    $0x8,%esp
    1a19:	68 00 02 00 00       	push   $0x200
    1a1e:	68 d5 42 00 00       	push   $0x42d5
    1a23:	e8 ea 1d 00 00       	call   3812 <open>
  if(fd < 0){
    1a28:	83 c4 10             	add    $0x10,%esp
    1a2b:	85 c0                	test   %eax,%eax
    1a2d:	78 65                	js     1a94 <bigdir+0xa1>
    printf(1, "bigdir create failed\n");
    exit();
  }
  close(fd);
    1a2f:	83 ec 0c             	sub    $0xc,%esp
    1a32:	50                   	push   %eax
    1a33:	e8 c2 1d 00 00       	call   37fa <close>

  for(i = 0; i < 500; i++){
    1a38:	83 c4 10             	add    $0x10,%esp
    1a3b:	bb 00 00 00 00       	mov    $0x0,%ebx
    1a40:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1a46:	7f 74                	jg     1abc <bigdir+0xc9>
    name[0] = 'x';
    1a48:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1a4c:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1a4f:	85 db                	test   %ebx,%ebx
    1a51:	0f 49 c3             	cmovns %ebx,%eax
    1a54:	c1 f8 06             	sar    $0x6,%eax
    1a57:	83 c0 30             	add    $0x30,%eax
    1a5a:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1a5d:	89 da                	mov    %ebx,%edx
    1a5f:	c1 fa 1f             	sar    $0x1f,%edx
    1a62:	c1 ea 1a             	shr    $0x1a,%edx
    1a65:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1a68:	83 e0 3f             	and    $0x3f,%eax
    1a6b:	29 d0                	sub    %edx,%eax
    1a6d:	83 c0 30             	add    $0x30,%eax
    1a70:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1a73:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(link("bd", name) != 0){
    1a77:	83 ec 08             	sub    $0x8,%esp
    1a7a:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1a7d:	50                   	push   %eax
    1a7e:	68 d5 42 00 00       	push   $0x42d5
    1a83:	e8 aa 1d 00 00       	call   3832 <link>
    1a88:	83 c4 10             	add    $0x10,%esp
    1a8b:	85 c0                	test   %eax,%eax
    1a8d:	75 19                	jne    1aa8 <bigdir+0xb5>
  for(i = 0; i < 500; i++){
    1a8f:	83 c3 01             	add    $0x1,%ebx
    1a92:	eb ac                	jmp    1a40 <bigdir+0x4d>
    printf(1, "bigdir create failed\n");
    1a94:	83 ec 08             	sub    $0x8,%esp
    1a97:	68 d8 42 00 00       	push   $0x42d8
    1a9c:	6a 01                	push   $0x1
    1a9e:	e8 78 1e 00 00       	call   391b <printf>
    exit();
    1aa3:	e8 2a 1d 00 00       	call   37d2 <exit>
      printf(1, "bigdir link failed\n");
    1aa8:	83 ec 08             	sub    $0x8,%esp
    1aab:	68 ee 42 00 00       	push   $0x42ee
    1ab0:	6a 01                	push   $0x1
    1ab2:	e8 64 1e 00 00       	call   391b <printf>
      exit();
    1ab7:	e8 16 1d 00 00       	call   37d2 <exit>
    }
  }

  unlink("bd");
    1abc:	83 ec 0c             	sub    $0xc,%esp
    1abf:	68 d5 42 00 00       	push   $0x42d5
    1ac4:	e8 59 1d 00 00       	call   3822 <unlink>
  for(i = 0; i < 500; i++){
    1ac9:	83 c4 10             	add    $0x10,%esp
    1acc:	bb 00 00 00 00       	mov    $0x0,%ebx
    1ad1:	81 fb f3 01 00 00    	cmp    $0x1f3,%ebx
    1ad7:	7f 5b                	jg     1b34 <bigdir+0x141>
    name[0] = 'x';
    1ad9:	c6 45 ee 78          	movb   $0x78,-0x12(%ebp)
    name[1] = '0' + (i / 64);
    1add:	8d 43 3f             	lea    0x3f(%ebx),%eax
    1ae0:	85 db                	test   %ebx,%ebx
    1ae2:	0f 49 c3             	cmovns %ebx,%eax
    1ae5:	c1 f8 06             	sar    $0x6,%eax
    1ae8:	83 c0 30             	add    $0x30,%eax
    1aeb:	88 45 ef             	mov    %al,-0x11(%ebp)
    name[2] = '0' + (i % 64);
    1aee:	89 da                	mov    %ebx,%edx
    1af0:	c1 fa 1f             	sar    $0x1f,%edx
    1af3:	c1 ea 1a             	shr    $0x1a,%edx
    1af6:	8d 04 13             	lea    (%ebx,%edx,1),%eax
    1af9:	83 e0 3f             	and    $0x3f,%eax
    1afc:	29 d0                	sub    %edx,%eax
    1afe:	83 c0 30             	add    $0x30,%eax
    1b01:	88 45 f0             	mov    %al,-0x10(%ebp)
    name[3] = '\0';
    1b04:	c6 45 f1 00          	movb   $0x0,-0xf(%ebp)
    if(unlink(name) != 0){
    1b08:	83 ec 0c             	sub    $0xc,%esp
    1b0b:	8d 45 ee             	lea    -0x12(%ebp),%eax
    1b0e:	50                   	push   %eax
    1b0f:	e8 0e 1d 00 00       	call   3822 <unlink>
    1b14:	83 c4 10             	add    $0x10,%esp
    1b17:	85 c0                	test   %eax,%eax
    1b19:	75 05                	jne    1b20 <bigdir+0x12d>
  for(i = 0; i < 500; i++){
    1b1b:	83 c3 01             	add    $0x1,%ebx
    1b1e:	eb b1                	jmp    1ad1 <bigdir+0xde>
      printf(1, "bigdir unlink failed");
    1b20:	83 ec 08             	sub    $0x8,%esp
    1b23:	68 02 43 00 00       	push   $0x4302
    1b28:	6a 01                	push   $0x1
    1b2a:	e8 ec 1d 00 00       	call   391b <printf>
      exit();
    1b2f:	e8 9e 1c 00 00       	call   37d2 <exit>
    }
  }

  printf(1, "bigdir ok\n");
    1b34:	83 ec 08             	sub    $0x8,%esp
    1b37:	68 17 43 00 00       	push   $0x4317
    1b3c:	6a 01                	push   $0x1
    1b3e:	e8 d8 1d 00 00       	call   391b <printf>
}
    1b43:	83 c4 10             	add    $0x10,%esp
    1b46:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1b49:	c9                   	leave  
    1b4a:	c3                   	ret    

00001b4b <subdir>:

void
subdir(void)
{
    1b4b:	f3 0f 1e fb          	endbr32 
    1b4f:	55                   	push   %ebp
    1b50:	89 e5                	mov    %esp,%ebp
    1b52:	53                   	push   %ebx
    1b53:	83 ec 0c             	sub    $0xc,%esp
  int fd, cc;

  printf(1, "subdir test\n");
    1b56:	68 22 43 00 00       	push   $0x4322
    1b5b:	6a 01                	push   $0x1
    1b5d:	e8 b9 1d 00 00       	call   391b <printf>

  unlink("ff");
    1b62:	c7 04 24 ab 43 00 00 	movl   $0x43ab,(%esp)
    1b69:	e8 b4 1c 00 00       	call   3822 <unlink>
  if(mkdir("dd") != 0){
    1b6e:	c7 04 24 48 44 00 00 	movl   $0x4448,(%esp)
    1b75:	e8 c0 1c 00 00       	call   383a <mkdir>
    1b7a:	83 c4 10             	add    $0x10,%esp
    1b7d:	85 c0                	test   %eax,%eax
    1b7f:	0f 85 14 04 00 00    	jne    1f99 <subdir+0x44e>
    printf(1, "subdir mkdir dd failed\n");
    exit();
  }

  fd = open("dd/ff", O_CREATE | O_RDWR);
    1b85:	83 ec 08             	sub    $0x8,%esp
    1b88:	68 02 02 00 00       	push   $0x202
    1b8d:	68 81 43 00 00       	push   $0x4381
    1b92:	e8 7b 1c 00 00       	call   3812 <open>
    1b97:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1b99:	83 c4 10             	add    $0x10,%esp
    1b9c:	85 c0                	test   %eax,%eax
    1b9e:	0f 88 09 04 00 00    	js     1fad <subdir+0x462>
    printf(1, "create dd/ff failed\n");
    exit();
  }
  write(fd, "ff", 2);
    1ba4:	83 ec 04             	sub    $0x4,%esp
    1ba7:	6a 02                	push   $0x2
    1ba9:	68 ab 43 00 00       	push   $0x43ab
    1bae:	50                   	push   %eax
    1baf:	e8 3e 1c 00 00       	call   37f2 <write>
  close(fd);
    1bb4:	89 1c 24             	mov    %ebx,(%esp)
    1bb7:	e8 3e 1c 00 00       	call   37fa <close>

  if(unlink("dd") >= 0){
    1bbc:	c7 04 24 48 44 00 00 	movl   $0x4448,(%esp)
    1bc3:	e8 5a 1c 00 00       	call   3822 <unlink>
    1bc8:	83 c4 10             	add    $0x10,%esp
    1bcb:	85 c0                	test   %eax,%eax
    1bcd:	0f 89 ee 03 00 00    	jns    1fc1 <subdir+0x476>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    exit();
  }

  if(mkdir("/dd/dd") != 0){
    1bd3:	83 ec 0c             	sub    $0xc,%esp
    1bd6:	68 5c 43 00 00       	push   $0x435c
    1bdb:	e8 5a 1c 00 00       	call   383a <mkdir>
    1be0:	83 c4 10             	add    $0x10,%esp
    1be3:	85 c0                	test   %eax,%eax
    1be5:	0f 85 ea 03 00 00    	jne    1fd5 <subdir+0x48a>
    printf(1, "subdir mkdir dd/dd failed\n");
    exit();
  }

  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    1beb:	83 ec 08             	sub    $0x8,%esp
    1bee:	68 02 02 00 00       	push   $0x202
    1bf3:	68 7e 43 00 00       	push   $0x437e
    1bf8:	e8 15 1c 00 00       	call   3812 <open>
    1bfd:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1bff:	83 c4 10             	add    $0x10,%esp
    1c02:	85 c0                	test   %eax,%eax
    1c04:	0f 88 df 03 00 00    	js     1fe9 <subdir+0x49e>
    printf(1, "create dd/dd/ff failed\n");
    exit();
  }
  write(fd, "FF", 2);
    1c0a:	83 ec 04             	sub    $0x4,%esp
    1c0d:	6a 02                	push   $0x2
    1c0f:	68 9f 43 00 00       	push   $0x439f
    1c14:	50                   	push   %eax
    1c15:	e8 d8 1b 00 00       	call   37f2 <write>
  close(fd);
    1c1a:	89 1c 24             	mov    %ebx,(%esp)
    1c1d:	e8 d8 1b 00 00       	call   37fa <close>

  fd = open("dd/dd/../ff", 0);
    1c22:	83 c4 08             	add    $0x8,%esp
    1c25:	6a 00                	push   $0x0
    1c27:	68 a2 43 00 00       	push   $0x43a2
    1c2c:	e8 e1 1b 00 00       	call   3812 <open>
    1c31:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1c33:	83 c4 10             	add    $0x10,%esp
    1c36:	85 c0                	test   %eax,%eax
    1c38:	0f 88 bf 03 00 00    	js     1ffd <subdir+0x4b2>
    printf(1, "open dd/dd/../ff failed\n");
    exit();
  }
  cc = read(fd, buf, sizeof(buf));
    1c3e:	83 ec 04             	sub    $0x4,%esp
    1c41:	68 00 20 00 00       	push   $0x2000
    1c46:	68 e0 83 00 00       	push   $0x83e0
    1c4b:	50                   	push   %eax
    1c4c:	e8 99 1b 00 00       	call   37ea <read>
  if(cc != 2 || buf[0] != 'f'){
    1c51:	83 c4 10             	add    $0x10,%esp
    1c54:	83 f8 02             	cmp    $0x2,%eax
    1c57:	0f 85 b4 03 00 00    	jne    2011 <subdir+0x4c6>
    1c5d:	80 3d e0 83 00 00 66 	cmpb   $0x66,0x83e0
    1c64:	0f 85 a7 03 00 00    	jne    2011 <subdir+0x4c6>
    printf(1, "dd/dd/../ff wrong content\n");
    exit();
  }
  close(fd);
    1c6a:	83 ec 0c             	sub    $0xc,%esp
    1c6d:	53                   	push   %ebx
    1c6e:	e8 87 1b 00 00       	call   37fa <close>

  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    1c73:	83 c4 08             	add    $0x8,%esp
    1c76:	68 e2 43 00 00       	push   $0x43e2
    1c7b:	68 7e 43 00 00       	push   $0x437e
    1c80:	e8 ad 1b 00 00       	call   3832 <link>
    1c85:	83 c4 10             	add    $0x10,%esp
    1c88:	85 c0                	test   %eax,%eax
    1c8a:	0f 85 95 03 00 00    	jne    2025 <subdir+0x4da>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    exit();
  }

  if(unlink("dd/dd/ff") != 0){
    1c90:	83 ec 0c             	sub    $0xc,%esp
    1c93:	68 7e 43 00 00       	push   $0x437e
    1c98:	e8 85 1b 00 00       	call   3822 <unlink>
    1c9d:	83 c4 10             	add    $0x10,%esp
    1ca0:	85 c0                	test   %eax,%eax
    1ca2:	0f 85 91 03 00 00    	jne    2039 <subdir+0x4ee>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1ca8:	83 ec 08             	sub    $0x8,%esp
    1cab:	6a 00                	push   $0x0
    1cad:	68 7e 43 00 00       	push   $0x437e
    1cb2:	e8 5b 1b 00 00       	call   3812 <open>
    1cb7:	83 c4 10             	add    $0x10,%esp
    1cba:	85 c0                	test   %eax,%eax
    1cbc:	0f 89 8b 03 00 00    	jns    204d <subdir+0x502>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    exit();
  }

  if(chdir("dd") != 0){
    1cc2:	83 ec 0c             	sub    $0xc,%esp
    1cc5:	68 48 44 00 00       	push   $0x4448
    1cca:	e8 73 1b 00 00       	call   3842 <chdir>
    1ccf:	83 c4 10             	add    $0x10,%esp
    1cd2:	85 c0                	test   %eax,%eax
    1cd4:	0f 85 87 03 00 00    	jne    2061 <subdir+0x516>
    printf(1, "chdir dd failed\n");
    exit();
  }
  if(chdir("dd/../../dd") != 0){
    1cda:	83 ec 0c             	sub    $0xc,%esp
    1cdd:	68 16 44 00 00       	push   $0x4416
    1ce2:	e8 5b 1b 00 00       	call   3842 <chdir>
    1ce7:	83 c4 10             	add    $0x10,%esp
    1cea:	85 c0                	test   %eax,%eax
    1cec:	0f 85 83 03 00 00    	jne    2075 <subdir+0x52a>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("dd/../../../dd") != 0){
    1cf2:	83 ec 0c             	sub    $0xc,%esp
    1cf5:	68 3c 44 00 00       	push   $0x443c
    1cfa:	e8 43 1b 00 00       	call   3842 <chdir>
    1cff:	83 c4 10             	add    $0x10,%esp
    1d02:	85 c0                	test   %eax,%eax
    1d04:	0f 85 7f 03 00 00    	jne    2089 <subdir+0x53e>
    printf(1, "chdir dd/../../dd failed\n");
    exit();
  }
  if(chdir("./..") != 0){
    1d0a:	83 ec 0c             	sub    $0xc,%esp
    1d0d:	68 4b 44 00 00       	push   $0x444b
    1d12:	e8 2b 1b 00 00       	call   3842 <chdir>
    1d17:	83 c4 10             	add    $0x10,%esp
    1d1a:	85 c0                	test   %eax,%eax
    1d1c:	0f 85 7b 03 00 00    	jne    209d <subdir+0x552>
    printf(1, "chdir ./.. failed\n");
    exit();
  }

  fd = open("dd/dd/ffff", 0);
    1d22:	83 ec 08             	sub    $0x8,%esp
    1d25:	6a 00                	push   $0x0
    1d27:	68 e2 43 00 00       	push   $0x43e2
    1d2c:	e8 e1 1a 00 00       	call   3812 <open>
    1d31:	89 c3                	mov    %eax,%ebx
  if(fd < 0){
    1d33:	83 c4 10             	add    $0x10,%esp
    1d36:	85 c0                	test   %eax,%eax
    1d38:	0f 88 73 03 00 00    	js     20b1 <subdir+0x566>
    printf(1, "open dd/dd/ffff failed\n");
    exit();
  }
  if(read(fd, buf, sizeof(buf)) != 2){
    1d3e:	83 ec 04             	sub    $0x4,%esp
    1d41:	68 00 20 00 00       	push   $0x2000
    1d46:	68 e0 83 00 00       	push   $0x83e0
    1d4b:	50                   	push   %eax
    1d4c:	e8 99 1a 00 00       	call   37ea <read>
    1d51:	83 c4 10             	add    $0x10,%esp
    1d54:	83 f8 02             	cmp    $0x2,%eax
    1d57:	0f 85 68 03 00 00    	jne    20c5 <subdir+0x57a>
    printf(1, "read dd/dd/ffff wrong len\n");
    exit();
  }
  close(fd);
    1d5d:	83 ec 0c             	sub    $0xc,%esp
    1d60:	53                   	push   %ebx
    1d61:	e8 94 1a 00 00       	call   37fa <close>

  if(open("dd/dd/ff", O_RDONLY) >= 0){
    1d66:	83 c4 08             	add    $0x8,%esp
    1d69:	6a 00                	push   $0x0
    1d6b:	68 7e 43 00 00       	push   $0x437e
    1d70:	e8 9d 1a 00 00       	call   3812 <open>
    1d75:	83 c4 10             	add    $0x10,%esp
    1d78:	85 c0                	test   %eax,%eax
    1d7a:	0f 89 59 03 00 00    	jns    20d9 <subdir+0x58e>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    exit();
  }

  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    1d80:	83 ec 08             	sub    $0x8,%esp
    1d83:	68 02 02 00 00       	push   $0x202
    1d88:	68 96 44 00 00       	push   $0x4496
    1d8d:	e8 80 1a 00 00       	call   3812 <open>
    1d92:	83 c4 10             	add    $0x10,%esp
    1d95:	85 c0                	test   %eax,%eax
    1d97:	0f 89 50 03 00 00    	jns    20ed <subdir+0x5a2>
    printf(1, "create dd/ff/ff succeeded!\n");
    exit();
  }
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    1d9d:	83 ec 08             	sub    $0x8,%esp
    1da0:	68 02 02 00 00       	push   $0x202
    1da5:	68 bb 44 00 00       	push   $0x44bb
    1daa:	e8 63 1a 00 00       	call   3812 <open>
    1daf:	83 c4 10             	add    $0x10,%esp
    1db2:	85 c0                	test   %eax,%eax
    1db4:	0f 89 47 03 00 00    	jns    2101 <subdir+0x5b6>
    printf(1, "create dd/xx/ff succeeded!\n");
    exit();
  }
  if(open("dd", O_CREATE) >= 0){
    1dba:	83 ec 08             	sub    $0x8,%esp
    1dbd:	68 00 02 00 00       	push   $0x200
    1dc2:	68 48 44 00 00       	push   $0x4448
    1dc7:	e8 46 1a 00 00       	call   3812 <open>
    1dcc:	83 c4 10             	add    $0x10,%esp
    1dcf:	85 c0                	test   %eax,%eax
    1dd1:	0f 89 3e 03 00 00    	jns    2115 <subdir+0x5ca>
    printf(1, "create dd succeeded!\n");
    exit();
  }
  if(open("dd", O_RDWR) >= 0){
    1dd7:	83 ec 08             	sub    $0x8,%esp
    1dda:	6a 02                	push   $0x2
    1ddc:	68 48 44 00 00       	push   $0x4448
    1de1:	e8 2c 1a 00 00       	call   3812 <open>
    1de6:	83 c4 10             	add    $0x10,%esp
    1de9:	85 c0                	test   %eax,%eax
    1deb:	0f 89 38 03 00 00    	jns    2129 <subdir+0x5de>
    printf(1, "open dd rdwr succeeded!\n");
    exit();
  }
  if(open("dd", O_WRONLY) >= 0){
    1df1:	83 ec 08             	sub    $0x8,%esp
    1df4:	6a 01                	push   $0x1
    1df6:	68 48 44 00 00       	push   $0x4448
    1dfb:	e8 12 1a 00 00       	call   3812 <open>
    1e00:	83 c4 10             	add    $0x10,%esp
    1e03:	85 c0                	test   %eax,%eax
    1e05:	0f 89 32 03 00 00    	jns    213d <subdir+0x5f2>
    printf(1, "open dd wronly succeeded!\n");
    exit();
  }
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    1e0b:	83 ec 08             	sub    $0x8,%esp
    1e0e:	68 2a 45 00 00       	push   $0x452a
    1e13:	68 96 44 00 00       	push   $0x4496
    1e18:	e8 15 1a 00 00       	call   3832 <link>
    1e1d:	83 c4 10             	add    $0x10,%esp
    1e20:	85 c0                	test   %eax,%eax
    1e22:	0f 84 29 03 00 00    	je     2151 <subdir+0x606>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    1e28:	83 ec 08             	sub    $0x8,%esp
    1e2b:	68 2a 45 00 00       	push   $0x452a
    1e30:	68 bb 44 00 00       	push   $0x44bb
    1e35:	e8 f8 19 00 00       	call   3832 <link>
    1e3a:	83 c4 10             	add    $0x10,%esp
    1e3d:	85 c0                	test   %eax,%eax
    1e3f:	0f 84 20 03 00 00    	je     2165 <subdir+0x61a>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    exit();
  }
  if(link("dd/ff", "dd/dd/ffff") == 0){
    1e45:	83 ec 08             	sub    $0x8,%esp
    1e48:	68 e2 43 00 00       	push   $0x43e2
    1e4d:	68 81 43 00 00       	push   $0x4381
    1e52:	e8 db 19 00 00       	call   3832 <link>
    1e57:	83 c4 10             	add    $0x10,%esp
    1e5a:	85 c0                	test   %eax,%eax
    1e5c:	0f 84 17 03 00 00    	je     2179 <subdir+0x62e>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    exit();
  }
  if(mkdir("dd/ff/ff") == 0){
    1e62:	83 ec 0c             	sub    $0xc,%esp
    1e65:	68 96 44 00 00       	push   $0x4496
    1e6a:	e8 cb 19 00 00       	call   383a <mkdir>
    1e6f:	83 c4 10             	add    $0x10,%esp
    1e72:	85 c0                	test   %eax,%eax
    1e74:	0f 84 13 03 00 00    	je     218d <subdir+0x642>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/xx/ff") == 0){
    1e7a:	83 ec 0c             	sub    $0xc,%esp
    1e7d:	68 bb 44 00 00       	push   $0x44bb
    1e82:	e8 b3 19 00 00       	call   383a <mkdir>
    1e87:	83 c4 10             	add    $0x10,%esp
    1e8a:	85 c0                	test   %eax,%eax
    1e8c:	0f 84 0f 03 00 00    	je     21a1 <subdir+0x656>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    exit();
  }
  if(mkdir("dd/dd/ffff") == 0){
    1e92:	83 ec 0c             	sub    $0xc,%esp
    1e95:	68 e2 43 00 00       	push   $0x43e2
    1e9a:	e8 9b 19 00 00       	call   383a <mkdir>
    1e9f:	83 c4 10             	add    $0x10,%esp
    1ea2:	85 c0                	test   %eax,%eax
    1ea4:	0f 84 0b 03 00 00    	je     21b5 <subdir+0x66a>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    exit();
  }
  if(unlink("dd/xx/ff") == 0){
    1eaa:	83 ec 0c             	sub    $0xc,%esp
    1ead:	68 bb 44 00 00       	push   $0x44bb
    1eb2:	e8 6b 19 00 00       	call   3822 <unlink>
    1eb7:	83 c4 10             	add    $0x10,%esp
    1eba:	85 c0                	test   %eax,%eax
    1ebc:	0f 84 07 03 00 00    	je     21c9 <subdir+0x67e>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    exit();
  }
  if(unlink("dd/ff/ff") == 0){
    1ec2:	83 ec 0c             	sub    $0xc,%esp
    1ec5:	68 96 44 00 00       	push   $0x4496
    1eca:	e8 53 19 00 00       	call   3822 <unlink>
    1ecf:	83 c4 10             	add    $0x10,%esp
    1ed2:	85 c0                	test   %eax,%eax
    1ed4:	0f 84 03 03 00 00    	je     21dd <subdir+0x692>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/ff") == 0){
    1eda:	83 ec 0c             	sub    $0xc,%esp
    1edd:	68 81 43 00 00       	push   $0x4381
    1ee2:	e8 5b 19 00 00       	call   3842 <chdir>
    1ee7:	83 c4 10             	add    $0x10,%esp
    1eea:	85 c0                	test   %eax,%eax
    1eec:	0f 84 ff 02 00 00    	je     21f1 <subdir+0x6a6>
    printf(1, "chdir dd/ff succeeded!\n");
    exit();
  }
  if(chdir("dd/xx") == 0){
    1ef2:	83 ec 0c             	sub    $0xc,%esp
    1ef5:	68 2d 45 00 00       	push   $0x452d
    1efa:	e8 43 19 00 00       	call   3842 <chdir>
    1eff:	83 c4 10             	add    $0x10,%esp
    1f02:	85 c0                	test   %eax,%eax
    1f04:	0f 84 fb 02 00 00    	je     2205 <subdir+0x6ba>
    printf(1, "chdir dd/xx succeeded!\n");
    exit();
  }

  if(unlink("dd/dd/ffff") != 0){
    1f0a:	83 ec 0c             	sub    $0xc,%esp
    1f0d:	68 e2 43 00 00       	push   $0x43e2
    1f12:	e8 0b 19 00 00       	call   3822 <unlink>
    1f17:	83 c4 10             	add    $0x10,%esp
    1f1a:	85 c0                	test   %eax,%eax
    1f1c:	0f 85 f7 02 00 00    	jne    2219 <subdir+0x6ce>
    printf(1, "unlink dd/dd/ff failed\n");
    exit();
  }
  if(unlink("dd/ff") != 0){
    1f22:	83 ec 0c             	sub    $0xc,%esp
    1f25:	68 81 43 00 00       	push   $0x4381
    1f2a:	e8 f3 18 00 00       	call   3822 <unlink>
    1f2f:	83 c4 10             	add    $0x10,%esp
    1f32:	85 c0                	test   %eax,%eax
    1f34:	0f 85 f3 02 00 00    	jne    222d <subdir+0x6e2>
    printf(1, "unlink dd/ff failed\n");
    exit();
  }
  if(unlink("dd") == 0){
    1f3a:	83 ec 0c             	sub    $0xc,%esp
    1f3d:	68 48 44 00 00       	push   $0x4448
    1f42:	e8 db 18 00 00       	call   3822 <unlink>
    1f47:	83 c4 10             	add    $0x10,%esp
    1f4a:	85 c0                	test   %eax,%eax
    1f4c:	0f 84 ef 02 00 00    	je     2241 <subdir+0x6f6>
    printf(1, "unlink non-empty dd succeeded!\n");
    exit();
  }
  if(unlink("dd/dd") < 0){
    1f52:	83 ec 0c             	sub    $0xc,%esp
    1f55:	68 5d 43 00 00       	push   $0x435d
    1f5a:	e8 c3 18 00 00       	call   3822 <unlink>
    1f5f:	83 c4 10             	add    $0x10,%esp
    1f62:	85 c0                	test   %eax,%eax
    1f64:	0f 88 eb 02 00 00    	js     2255 <subdir+0x70a>
    printf(1, "unlink dd/dd failed\n");
    exit();
  }
  if(unlink("dd") < 0){
    1f6a:	83 ec 0c             	sub    $0xc,%esp
    1f6d:	68 48 44 00 00       	push   $0x4448
    1f72:	e8 ab 18 00 00       	call   3822 <unlink>
    1f77:	83 c4 10             	add    $0x10,%esp
    1f7a:	85 c0                	test   %eax,%eax
    1f7c:	0f 88 e7 02 00 00    	js     2269 <subdir+0x71e>
    printf(1, "unlink dd failed\n");
    exit();
  }

  printf(1, "subdir ok\n");
    1f82:	83 ec 08             	sub    $0x8,%esp
    1f85:	68 2a 46 00 00       	push   $0x462a
    1f8a:	6a 01                	push   $0x1
    1f8c:	e8 8a 19 00 00       	call   391b <printf>
}
    1f91:	83 c4 10             	add    $0x10,%esp
    1f94:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    1f97:	c9                   	leave  
    1f98:	c3                   	ret    
    printf(1, "subdir mkdir dd failed\n");
    1f99:	83 ec 08             	sub    $0x8,%esp
    1f9c:	68 2f 43 00 00       	push   $0x432f
    1fa1:	6a 01                	push   $0x1
    1fa3:	e8 73 19 00 00       	call   391b <printf>
    exit();
    1fa8:	e8 25 18 00 00       	call   37d2 <exit>
    printf(1, "create dd/ff failed\n");
    1fad:	83 ec 08             	sub    $0x8,%esp
    1fb0:	68 47 43 00 00       	push   $0x4347
    1fb5:	6a 01                	push   $0x1
    1fb7:	e8 5f 19 00 00       	call   391b <printf>
    exit();
    1fbc:	e8 11 18 00 00       	call   37d2 <exit>
    printf(1, "unlink dd (non-empty dir) succeeded!\n");
    1fc1:	83 ec 08             	sub    $0x8,%esp
    1fc4:	68 14 4e 00 00       	push   $0x4e14
    1fc9:	6a 01                	push   $0x1
    1fcb:	e8 4b 19 00 00       	call   391b <printf>
    exit();
    1fd0:	e8 fd 17 00 00       	call   37d2 <exit>
    printf(1, "subdir mkdir dd/dd failed\n");
    1fd5:	83 ec 08             	sub    $0x8,%esp
    1fd8:	68 63 43 00 00       	push   $0x4363
    1fdd:	6a 01                	push   $0x1
    1fdf:	e8 37 19 00 00       	call   391b <printf>
    exit();
    1fe4:	e8 e9 17 00 00       	call   37d2 <exit>
    printf(1, "create dd/dd/ff failed\n");
    1fe9:	83 ec 08             	sub    $0x8,%esp
    1fec:	68 87 43 00 00       	push   $0x4387
    1ff1:	6a 01                	push   $0x1
    1ff3:	e8 23 19 00 00       	call   391b <printf>
    exit();
    1ff8:	e8 d5 17 00 00       	call   37d2 <exit>
    printf(1, "open dd/dd/../ff failed\n");
    1ffd:	83 ec 08             	sub    $0x8,%esp
    2000:	68 ae 43 00 00       	push   $0x43ae
    2005:	6a 01                	push   $0x1
    2007:	e8 0f 19 00 00       	call   391b <printf>
    exit();
    200c:	e8 c1 17 00 00       	call   37d2 <exit>
    printf(1, "dd/dd/../ff wrong content\n");
    2011:	83 ec 08             	sub    $0x8,%esp
    2014:	68 c7 43 00 00       	push   $0x43c7
    2019:	6a 01                	push   $0x1
    201b:	e8 fb 18 00 00       	call   391b <printf>
    exit();
    2020:	e8 ad 17 00 00       	call   37d2 <exit>
    printf(1, "link dd/dd/ff dd/dd/ffff failed\n");
    2025:	83 ec 08             	sub    $0x8,%esp
    2028:	68 3c 4e 00 00       	push   $0x4e3c
    202d:	6a 01                	push   $0x1
    202f:	e8 e7 18 00 00       	call   391b <printf>
    exit();
    2034:	e8 99 17 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2039:	83 ec 08             	sub    $0x8,%esp
    203c:	68 ed 43 00 00       	push   $0x43ed
    2041:	6a 01                	push   $0x1
    2043:	e8 d3 18 00 00       	call   391b <printf>
    exit();
    2048:	e8 85 17 00 00       	call   37d2 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded\n");
    204d:	83 ec 08             	sub    $0x8,%esp
    2050:	68 60 4e 00 00       	push   $0x4e60
    2055:	6a 01                	push   $0x1
    2057:	e8 bf 18 00 00       	call   391b <printf>
    exit();
    205c:	e8 71 17 00 00       	call   37d2 <exit>
    printf(1, "chdir dd failed\n");
    2061:	83 ec 08             	sub    $0x8,%esp
    2064:	68 05 44 00 00       	push   $0x4405
    2069:	6a 01                	push   $0x1
    206b:	e8 ab 18 00 00       	call   391b <printf>
    exit();
    2070:	e8 5d 17 00 00       	call   37d2 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2075:	83 ec 08             	sub    $0x8,%esp
    2078:	68 22 44 00 00       	push   $0x4422
    207d:	6a 01                	push   $0x1
    207f:	e8 97 18 00 00       	call   391b <printf>
    exit();
    2084:	e8 49 17 00 00       	call   37d2 <exit>
    printf(1, "chdir dd/../../dd failed\n");
    2089:	83 ec 08             	sub    $0x8,%esp
    208c:	68 22 44 00 00       	push   $0x4422
    2091:	6a 01                	push   $0x1
    2093:	e8 83 18 00 00       	call   391b <printf>
    exit();
    2098:	e8 35 17 00 00       	call   37d2 <exit>
    printf(1, "chdir ./.. failed\n");
    209d:	83 ec 08             	sub    $0x8,%esp
    20a0:	68 50 44 00 00       	push   $0x4450
    20a5:	6a 01                	push   $0x1
    20a7:	e8 6f 18 00 00       	call   391b <printf>
    exit();
    20ac:	e8 21 17 00 00       	call   37d2 <exit>
    printf(1, "open dd/dd/ffff failed\n");
    20b1:	83 ec 08             	sub    $0x8,%esp
    20b4:	68 63 44 00 00       	push   $0x4463
    20b9:	6a 01                	push   $0x1
    20bb:	e8 5b 18 00 00       	call   391b <printf>
    exit();
    20c0:	e8 0d 17 00 00       	call   37d2 <exit>
    printf(1, "read dd/dd/ffff wrong len\n");
    20c5:	83 ec 08             	sub    $0x8,%esp
    20c8:	68 7b 44 00 00       	push   $0x447b
    20cd:	6a 01                	push   $0x1
    20cf:	e8 47 18 00 00       	call   391b <printf>
    exit();
    20d4:	e8 f9 16 00 00       	call   37d2 <exit>
    printf(1, "open (unlinked) dd/dd/ff succeeded!\n");
    20d9:	83 ec 08             	sub    $0x8,%esp
    20dc:	68 84 4e 00 00       	push   $0x4e84
    20e1:	6a 01                	push   $0x1
    20e3:	e8 33 18 00 00       	call   391b <printf>
    exit();
    20e8:	e8 e5 16 00 00       	call   37d2 <exit>
    printf(1, "create dd/ff/ff succeeded!\n");
    20ed:	83 ec 08             	sub    $0x8,%esp
    20f0:	68 9f 44 00 00       	push   $0x449f
    20f5:	6a 01                	push   $0x1
    20f7:	e8 1f 18 00 00       	call   391b <printf>
    exit();
    20fc:	e8 d1 16 00 00       	call   37d2 <exit>
    printf(1, "create dd/xx/ff succeeded!\n");
    2101:	83 ec 08             	sub    $0x8,%esp
    2104:	68 c4 44 00 00       	push   $0x44c4
    2109:	6a 01                	push   $0x1
    210b:	e8 0b 18 00 00       	call   391b <printf>
    exit();
    2110:	e8 bd 16 00 00       	call   37d2 <exit>
    printf(1, "create dd succeeded!\n");
    2115:	83 ec 08             	sub    $0x8,%esp
    2118:	68 e0 44 00 00       	push   $0x44e0
    211d:	6a 01                	push   $0x1
    211f:	e8 f7 17 00 00       	call   391b <printf>
    exit();
    2124:	e8 a9 16 00 00       	call   37d2 <exit>
    printf(1, "open dd rdwr succeeded!\n");
    2129:	83 ec 08             	sub    $0x8,%esp
    212c:	68 f6 44 00 00       	push   $0x44f6
    2131:	6a 01                	push   $0x1
    2133:	e8 e3 17 00 00       	call   391b <printf>
    exit();
    2138:	e8 95 16 00 00       	call   37d2 <exit>
    printf(1, "open dd wronly succeeded!\n");
    213d:	83 ec 08             	sub    $0x8,%esp
    2140:	68 0f 45 00 00       	push   $0x450f
    2145:	6a 01                	push   $0x1
    2147:	e8 cf 17 00 00       	call   391b <printf>
    exit();
    214c:	e8 81 16 00 00       	call   37d2 <exit>
    printf(1, "link dd/ff/ff dd/dd/xx succeeded!\n");
    2151:	83 ec 08             	sub    $0x8,%esp
    2154:	68 ac 4e 00 00       	push   $0x4eac
    2159:	6a 01                	push   $0x1
    215b:	e8 bb 17 00 00       	call   391b <printf>
    exit();
    2160:	e8 6d 16 00 00       	call   37d2 <exit>
    printf(1, "link dd/xx/ff dd/dd/xx succeeded!\n");
    2165:	83 ec 08             	sub    $0x8,%esp
    2168:	68 d0 4e 00 00       	push   $0x4ed0
    216d:	6a 01                	push   $0x1
    216f:	e8 a7 17 00 00       	call   391b <printf>
    exit();
    2174:	e8 59 16 00 00       	call   37d2 <exit>
    printf(1, "link dd/ff dd/dd/ffff succeeded!\n");
    2179:	83 ec 08             	sub    $0x8,%esp
    217c:	68 f4 4e 00 00       	push   $0x4ef4
    2181:	6a 01                	push   $0x1
    2183:	e8 93 17 00 00       	call   391b <printf>
    exit();
    2188:	e8 45 16 00 00       	call   37d2 <exit>
    printf(1, "mkdir dd/ff/ff succeeded!\n");
    218d:	83 ec 08             	sub    $0x8,%esp
    2190:	68 33 45 00 00       	push   $0x4533
    2195:	6a 01                	push   $0x1
    2197:	e8 7f 17 00 00       	call   391b <printf>
    exit();
    219c:	e8 31 16 00 00       	call   37d2 <exit>
    printf(1, "mkdir dd/xx/ff succeeded!\n");
    21a1:	83 ec 08             	sub    $0x8,%esp
    21a4:	68 4e 45 00 00       	push   $0x454e
    21a9:	6a 01                	push   $0x1
    21ab:	e8 6b 17 00 00       	call   391b <printf>
    exit();
    21b0:	e8 1d 16 00 00       	call   37d2 <exit>
    printf(1, "mkdir dd/dd/ffff succeeded!\n");
    21b5:	83 ec 08             	sub    $0x8,%esp
    21b8:	68 69 45 00 00       	push   $0x4569
    21bd:	6a 01                	push   $0x1
    21bf:	e8 57 17 00 00       	call   391b <printf>
    exit();
    21c4:	e8 09 16 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/xx/ff succeeded!\n");
    21c9:	83 ec 08             	sub    $0x8,%esp
    21cc:	68 86 45 00 00       	push   $0x4586
    21d1:	6a 01                	push   $0x1
    21d3:	e8 43 17 00 00       	call   391b <printf>
    exit();
    21d8:	e8 f5 15 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/ff/ff succeeded!\n");
    21dd:	83 ec 08             	sub    $0x8,%esp
    21e0:	68 a2 45 00 00       	push   $0x45a2
    21e5:	6a 01                	push   $0x1
    21e7:	e8 2f 17 00 00       	call   391b <printf>
    exit();
    21ec:	e8 e1 15 00 00       	call   37d2 <exit>
    printf(1, "chdir dd/ff succeeded!\n");
    21f1:	83 ec 08             	sub    $0x8,%esp
    21f4:	68 be 45 00 00       	push   $0x45be
    21f9:	6a 01                	push   $0x1
    21fb:	e8 1b 17 00 00       	call   391b <printf>
    exit();
    2200:	e8 cd 15 00 00       	call   37d2 <exit>
    printf(1, "chdir dd/xx succeeded!\n");
    2205:	83 ec 08             	sub    $0x8,%esp
    2208:	68 d6 45 00 00       	push   $0x45d6
    220d:	6a 01                	push   $0x1
    220f:	e8 07 17 00 00       	call   391b <printf>
    exit();
    2214:	e8 b9 15 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/dd/ff failed\n");
    2219:	83 ec 08             	sub    $0x8,%esp
    221c:	68 ed 43 00 00       	push   $0x43ed
    2221:	6a 01                	push   $0x1
    2223:	e8 f3 16 00 00       	call   391b <printf>
    exit();
    2228:	e8 a5 15 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/ff failed\n");
    222d:	83 ec 08             	sub    $0x8,%esp
    2230:	68 ee 45 00 00       	push   $0x45ee
    2235:	6a 01                	push   $0x1
    2237:	e8 df 16 00 00       	call   391b <printf>
    exit();
    223c:	e8 91 15 00 00       	call   37d2 <exit>
    printf(1, "unlink non-empty dd succeeded!\n");
    2241:	83 ec 08             	sub    $0x8,%esp
    2244:	68 18 4f 00 00       	push   $0x4f18
    2249:	6a 01                	push   $0x1
    224b:	e8 cb 16 00 00       	call   391b <printf>
    exit();
    2250:	e8 7d 15 00 00       	call   37d2 <exit>
    printf(1, "unlink dd/dd failed\n");
    2255:	83 ec 08             	sub    $0x8,%esp
    2258:	68 03 46 00 00       	push   $0x4603
    225d:	6a 01                	push   $0x1
    225f:	e8 b7 16 00 00       	call   391b <printf>
    exit();
    2264:	e8 69 15 00 00       	call   37d2 <exit>
    printf(1, "unlink dd failed\n");
    2269:	83 ec 08             	sub    $0x8,%esp
    226c:	68 18 46 00 00       	push   $0x4618
    2271:	6a 01                	push   $0x1
    2273:	e8 a3 16 00 00       	call   391b <printf>
    exit();
    2278:	e8 55 15 00 00       	call   37d2 <exit>

0000227d <bigwrite>:

// test writes that are larger than the log.
void
bigwrite(void)
{
    227d:	f3 0f 1e fb          	endbr32 
    2281:	55                   	push   %ebp
    2282:	89 e5                	mov    %esp,%ebp
    2284:	57                   	push   %edi
    2285:	56                   	push   %esi
    2286:	53                   	push   %ebx
    2287:	83 ec 14             	sub    $0x14,%esp
  int fd, sz;

  printf(1, "bigwrite test\n");
    228a:	68 35 46 00 00       	push   $0x4635
    228f:	6a 01                	push   $0x1
    2291:	e8 85 16 00 00       	call   391b <printf>

  unlink("bigwrite");
    2296:	c7 04 24 44 46 00 00 	movl   $0x4644,(%esp)
    229d:	e8 80 15 00 00       	call   3822 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    22a2:	83 c4 10             	add    $0x10,%esp
    22a5:	be f3 01 00 00       	mov    $0x1f3,%esi
    22aa:	eb 45                	jmp    22f1 <bigwrite+0x74>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    if(fd < 0){
      printf(1, "cannot create bigwrite\n");
    22ac:	83 ec 08             	sub    $0x8,%esp
    22af:	68 4d 46 00 00       	push   $0x464d
    22b4:	6a 01                	push   $0x1
    22b6:	e8 60 16 00 00       	call   391b <printf>
      exit();
    22bb:	e8 12 15 00 00       	call   37d2 <exit>
    }
    int i;
    for(i = 0; i < 2; i++){
      int cc = write(fd, buf, sz);
      if(cc != sz){
        printf(1, "write(%d) ret %d\n", sz, cc);
    22c0:	50                   	push   %eax
    22c1:	56                   	push   %esi
    22c2:	68 65 46 00 00       	push   $0x4665
    22c7:	6a 01                	push   $0x1
    22c9:	e8 4d 16 00 00       	call   391b <printf>
        exit();
    22ce:	e8 ff 14 00 00       	call   37d2 <exit>
      }
    }
    close(fd);
    22d3:	83 ec 0c             	sub    $0xc,%esp
    22d6:	57                   	push   %edi
    22d7:	e8 1e 15 00 00       	call   37fa <close>
    unlink("bigwrite");
    22dc:	c7 04 24 44 46 00 00 	movl   $0x4644,(%esp)
    22e3:	e8 3a 15 00 00       	call   3822 <unlink>
  for(sz = 499; sz < 12*512; sz += 471){
    22e8:	81 c6 d7 01 00 00    	add    $0x1d7,%esi
    22ee:	83 c4 10             	add    $0x10,%esp
    22f1:	81 fe ff 17 00 00    	cmp    $0x17ff,%esi
    22f7:	7f 40                	jg     2339 <bigwrite+0xbc>
    fd = open("bigwrite", O_CREATE | O_RDWR);
    22f9:	83 ec 08             	sub    $0x8,%esp
    22fc:	68 02 02 00 00       	push   $0x202
    2301:	68 44 46 00 00       	push   $0x4644
    2306:	e8 07 15 00 00       	call   3812 <open>
    230b:	89 c7                	mov    %eax,%edi
    if(fd < 0){
    230d:	83 c4 10             	add    $0x10,%esp
    2310:	85 c0                	test   %eax,%eax
    2312:	78 98                	js     22ac <bigwrite+0x2f>
    for(i = 0; i < 2; i++){
    2314:	bb 00 00 00 00       	mov    $0x0,%ebx
    2319:	83 fb 01             	cmp    $0x1,%ebx
    231c:	7f b5                	jg     22d3 <bigwrite+0x56>
      int cc = write(fd, buf, sz);
    231e:	83 ec 04             	sub    $0x4,%esp
    2321:	56                   	push   %esi
    2322:	68 e0 83 00 00       	push   $0x83e0
    2327:	57                   	push   %edi
    2328:	e8 c5 14 00 00       	call   37f2 <write>
      if(cc != sz){
    232d:	83 c4 10             	add    $0x10,%esp
    2330:	39 c6                	cmp    %eax,%esi
    2332:	75 8c                	jne    22c0 <bigwrite+0x43>
    for(i = 0; i < 2; i++){
    2334:	83 c3 01             	add    $0x1,%ebx
    2337:	eb e0                	jmp    2319 <bigwrite+0x9c>
  }

  printf(1, "bigwrite ok\n");
    2339:	83 ec 08             	sub    $0x8,%esp
    233c:	68 77 46 00 00       	push   $0x4677
    2341:	6a 01                	push   $0x1
    2343:	e8 d3 15 00 00       	call   391b <printf>
}
    2348:	83 c4 10             	add    $0x10,%esp
    234b:	8d 65 f4             	lea    -0xc(%ebp),%esp
    234e:	5b                   	pop    %ebx
    234f:	5e                   	pop    %esi
    2350:	5f                   	pop    %edi
    2351:	5d                   	pop    %ebp
    2352:	c3                   	ret    

00002353 <bigfile>:

void
bigfile(void)
{
    2353:	f3 0f 1e fb          	endbr32 
    2357:	55                   	push   %ebp
    2358:	89 e5                	mov    %esp,%ebp
    235a:	57                   	push   %edi
    235b:	56                   	push   %esi
    235c:	53                   	push   %ebx
    235d:	83 ec 14             	sub    $0x14,%esp
  int fd, i, total, cc;

  printf(1, "bigfile test\n");
    2360:	68 84 46 00 00       	push   $0x4684
    2365:	6a 01                	push   $0x1
    2367:	e8 af 15 00 00       	call   391b <printf>

  unlink("bigfile");
    236c:	c7 04 24 a0 46 00 00 	movl   $0x46a0,(%esp)
    2373:	e8 aa 14 00 00       	call   3822 <unlink>
  fd = open("bigfile", O_CREATE | O_RDWR);
    2378:	83 c4 08             	add    $0x8,%esp
    237b:	68 02 02 00 00       	push   $0x202
    2380:	68 a0 46 00 00       	push   $0x46a0
    2385:	e8 88 14 00 00       	call   3812 <open>
  if(fd < 0){
    238a:	83 c4 10             	add    $0x10,%esp
    238d:	85 c0                	test   %eax,%eax
    238f:	78 41                	js     23d2 <bigfile+0x7f>
    2391:	89 c6                	mov    %eax,%esi
    printf(1, "cannot create bigfile");
    exit();
  }
  for(i = 0; i < 20; i++){
    2393:	bb 00 00 00 00       	mov    $0x0,%ebx
    2398:	83 fb 13             	cmp    $0x13,%ebx
    239b:	7f 5d                	jg     23fa <bigfile+0xa7>
    memset(buf, i, 600);
    239d:	83 ec 04             	sub    $0x4,%esp
    23a0:	68 58 02 00 00       	push   $0x258
    23a5:	53                   	push   %ebx
    23a6:	68 e0 83 00 00       	push   $0x83e0
    23ab:	e8 d5 12 00 00       	call   3685 <memset>
    if(write(fd, buf, 600) != 600){
    23b0:	83 c4 0c             	add    $0xc,%esp
    23b3:	68 58 02 00 00       	push   $0x258
    23b8:	68 e0 83 00 00       	push   $0x83e0
    23bd:	56                   	push   %esi
    23be:	e8 2f 14 00 00       	call   37f2 <write>
    23c3:	83 c4 10             	add    $0x10,%esp
    23c6:	3d 58 02 00 00       	cmp    $0x258,%eax
    23cb:	75 19                	jne    23e6 <bigfile+0x93>
  for(i = 0; i < 20; i++){
    23cd:	83 c3 01             	add    $0x1,%ebx
    23d0:	eb c6                	jmp    2398 <bigfile+0x45>
    printf(1, "cannot create bigfile");
    23d2:	83 ec 08             	sub    $0x8,%esp
    23d5:	68 92 46 00 00       	push   $0x4692
    23da:	6a 01                	push   $0x1
    23dc:	e8 3a 15 00 00       	call   391b <printf>
    exit();
    23e1:	e8 ec 13 00 00       	call   37d2 <exit>
      printf(1, "write bigfile failed\n");
    23e6:	83 ec 08             	sub    $0x8,%esp
    23e9:	68 a8 46 00 00       	push   $0x46a8
    23ee:	6a 01                	push   $0x1
    23f0:	e8 26 15 00 00       	call   391b <printf>
      exit();
    23f5:	e8 d8 13 00 00       	call   37d2 <exit>
    }
  }
  close(fd);
    23fa:	83 ec 0c             	sub    $0xc,%esp
    23fd:	56                   	push   %esi
    23fe:	e8 f7 13 00 00       	call   37fa <close>

  fd = open("bigfile", 0);
    2403:	83 c4 08             	add    $0x8,%esp
    2406:	6a 00                	push   $0x0
    2408:	68 a0 46 00 00       	push   $0x46a0
    240d:	e8 00 14 00 00       	call   3812 <open>
    2412:	89 c7                	mov    %eax,%edi
  if(fd < 0){
    2414:	83 c4 10             	add    $0x10,%esp
    2417:	85 c0                	test   %eax,%eax
    2419:	78 53                	js     246e <bigfile+0x11b>
    printf(1, "cannot open bigfile\n");
    exit();
  }
  total = 0;
    241b:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; ; i++){
    2420:	bb 00 00 00 00       	mov    $0x0,%ebx
    cc = read(fd, buf, 300);
    2425:	83 ec 04             	sub    $0x4,%esp
    2428:	68 2c 01 00 00       	push   $0x12c
    242d:	68 e0 83 00 00       	push   $0x83e0
    2432:	57                   	push   %edi
    2433:	e8 b2 13 00 00       	call   37ea <read>
    if(cc < 0){
    2438:	83 c4 10             	add    $0x10,%esp
    243b:	85 c0                	test   %eax,%eax
    243d:	78 43                	js     2482 <bigfile+0x12f>
      printf(1, "read bigfile failed\n");
      exit();
    }
    if(cc == 0)
    243f:	74 7d                	je     24be <bigfile+0x16b>
      break;
    if(cc != 300){
    2441:	3d 2c 01 00 00       	cmp    $0x12c,%eax
    2446:	75 4e                	jne    2496 <bigfile+0x143>
      printf(1, "short read bigfile\n");
      exit();
    }
    if(buf[0] != i/2 || buf[299] != i/2){
    2448:	0f be 0d e0 83 00 00 	movsbl 0x83e0,%ecx
    244f:	89 da                	mov    %ebx,%edx
    2451:	c1 ea 1f             	shr    $0x1f,%edx
    2454:	01 da                	add    %ebx,%edx
    2456:	d1 fa                	sar    %edx
    2458:	39 d1                	cmp    %edx,%ecx
    245a:	75 4e                	jne    24aa <bigfile+0x157>
    245c:	0f be 0d 0b 85 00 00 	movsbl 0x850b,%ecx
    2463:	39 ca                	cmp    %ecx,%edx
    2465:	75 43                	jne    24aa <bigfile+0x157>
      printf(1, "read bigfile wrong data\n");
      exit();
    }
    total += cc;
    2467:	01 c6                	add    %eax,%esi
  for(i = 0; ; i++){
    2469:	83 c3 01             	add    $0x1,%ebx
    cc = read(fd, buf, 300);
    246c:	eb b7                	jmp    2425 <bigfile+0xd2>
    printf(1, "cannot open bigfile\n");
    246e:	83 ec 08             	sub    $0x8,%esp
    2471:	68 be 46 00 00       	push   $0x46be
    2476:	6a 01                	push   $0x1
    2478:	e8 9e 14 00 00       	call   391b <printf>
    exit();
    247d:	e8 50 13 00 00       	call   37d2 <exit>
      printf(1, "read bigfile failed\n");
    2482:	83 ec 08             	sub    $0x8,%esp
    2485:	68 d3 46 00 00       	push   $0x46d3
    248a:	6a 01                	push   $0x1
    248c:	e8 8a 14 00 00       	call   391b <printf>
      exit();
    2491:	e8 3c 13 00 00       	call   37d2 <exit>
      printf(1, "short read bigfile\n");
    2496:	83 ec 08             	sub    $0x8,%esp
    2499:	68 e8 46 00 00       	push   $0x46e8
    249e:	6a 01                	push   $0x1
    24a0:	e8 76 14 00 00       	call   391b <printf>
      exit();
    24a5:	e8 28 13 00 00       	call   37d2 <exit>
      printf(1, "read bigfile wrong data\n");
    24aa:	83 ec 08             	sub    $0x8,%esp
    24ad:	68 fc 46 00 00       	push   $0x46fc
    24b2:	6a 01                	push   $0x1
    24b4:	e8 62 14 00 00       	call   391b <printf>
      exit();
    24b9:	e8 14 13 00 00       	call   37d2 <exit>
  }
  close(fd);
    24be:	83 ec 0c             	sub    $0xc,%esp
    24c1:	57                   	push   %edi
    24c2:	e8 33 13 00 00       	call   37fa <close>
  if(total != 20*600){
    24c7:	83 c4 10             	add    $0x10,%esp
    24ca:	81 fe e0 2e 00 00    	cmp    $0x2ee0,%esi
    24d0:	75 27                	jne    24f9 <bigfile+0x1a6>
    printf(1, "read bigfile wrong total\n");
    exit();
  }
  unlink("bigfile");
    24d2:	83 ec 0c             	sub    $0xc,%esp
    24d5:	68 a0 46 00 00       	push   $0x46a0
    24da:	e8 43 13 00 00       	call   3822 <unlink>

  printf(1, "bigfile test ok\n");
    24df:	83 c4 08             	add    $0x8,%esp
    24e2:	68 2f 47 00 00       	push   $0x472f
    24e7:	6a 01                	push   $0x1
    24e9:	e8 2d 14 00 00       	call   391b <printf>
}
    24ee:	83 c4 10             	add    $0x10,%esp
    24f1:	8d 65 f4             	lea    -0xc(%ebp),%esp
    24f4:	5b                   	pop    %ebx
    24f5:	5e                   	pop    %esi
    24f6:	5f                   	pop    %edi
    24f7:	5d                   	pop    %ebp
    24f8:	c3                   	ret    
    printf(1, "read bigfile wrong total\n");
    24f9:	83 ec 08             	sub    $0x8,%esp
    24fc:	68 15 47 00 00       	push   $0x4715
    2501:	6a 01                	push   $0x1
    2503:	e8 13 14 00 00       	call   391b <printf>
    exit();
    2508:	e8 c5 12 00 00       	call   37d2 <exit>

0000250d <fourteen>:

void
fourteen(void)
{
    250d:	f3 0f 1e fb          	endbr32 
    2511:	55                   	push   %ebp
    2512:	89 e5                	mov    %esp,%ebp
    2514:	83 ec 10             	sub    $0x10,%esp
  int fd;

  // DIRSIZ is 14.
  printf(1, "fourteen test\n");
    2517:	68 40 47 00 00       	push   $0x4740
    251c:	6a 01                	push   $0x1
    251e:	e8 f8 13 00 00       	call   391b <printf>

  if(mkdir("12345678901234") != 0){
    2523:	c7 04 24 7b 47 00 00 	movl   $0x477b,(%esp)
    252a:	e8 0b 13 00 00       	call   383a <mkdir>
    252f:	83 c4 10             	add    $0x10,%esp
    2532:	85 c0                	test   %eax,%eax
    2534:	0f 85 9c 00 00 00    	jne    25d6 <fourteen+0xc9>
    printf(1, "mkdir 12345678901234 failed\n");
    exit();
  }
  if(mkdir("12345678901234/123456789012345") != 0){
    253a:	83 ec 0c             	sub    $0xc,%esp
    253d:	68 38 4f 00 00       	push   $0x4f38
    2542:	e8 f3 12 00 00       	call   383a <mkdir>
    2547:	83 c4 10             	add    $0x10,%esp
    254a:	85 c0                	test   %eax,%eax
    254c:	0f 85 98 00 00 00    	jne    25ea <fourteen+0xdd>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    exit();
  }
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    2552:	83 ec 08             	sub    $0x8,%esp
    2555:	68 00 02 00 00       	push   $0x200
    255a:	68 88 4f 00 00       	push   $0x4f88
    255f:	e8 ae 12 00 00       	call   3812 <open>
  if(fd < 0){
    2564:	83 c4 10             	add    $0x10,%esp
    2567:	85 c0                	test   %eax,%eax
    2569:	0f 88 8f 00 00 00    	js     25fe <fourteen+0xf1>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    exit();
  }
  close(fd);
    256f:	83 ec 0c             	sub    $0xc,%esp
    2572:	50                   	push   %eax
    2573:	e8 82 12 00 00       	call   37fa <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    2578:	83 c4 08             	add    $0x8,%esp
    257b:	6a 00                	push   $0x0
    257d:	68 f8 4f 00 00       	push   $0x4ff8
    2582:	e8 8b 12 00 00       	call   3812 <open>
  if(fd < 0){
    2587:	83 c4 10             	add    $0x10,%esp
    258a:	85 c0                	test   %eax,%eax
    258c:	0f 88 80 00 00 00    	js     2612 <fourteen+0x105>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    exit();
  }
  close(fd);
    2592:	83 ec 0c             	sub    $0xc,%esp
    2595:	50                   	push   %eax
    2596:	e8 5f 12 00 00       	call   37fa <close>

  if(mkdir("12345678901234/12345678901234") == 0){
    259b:	c7 04 24 6c 47 00 00 	movl   $0x476c,(%esp)
    25a2:	e8 93 12 00 00       	call   383a <mkdir>
    25a7:	83 c4 10             	add    $0x10,%esp
    25aa:	85 c0                	test   %eax,%eax
    25ac:	74 78                	je     2626 <fourteen+0x119>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    exit();
  }
  if(mkdir("123456789012345/12345678901234") == 0){
    25ae:	83 ec 0c             	sub    $0xc,%esp
    25b1:	68 94 50 00 00       	push   $0x5094
    25b6:	e8 7f 12 00 00       	call   383a <mkdir>
    25bb:	83 c4 10             	add    $0x10,%esp
    25be:	85 c0                	test   %eax,%eax
    25c0:	74 78                	je     263a <fourteen+0x12d>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    exit();
  }

  printf(1, "fourteen ok\n");
    25c2:	83 ec 08             	sub    $0x8,%esp
    25c5:	68 8a 47 00 00       	push   $0x478a
    25ca:	6a 01                	push   $0x1
    25cc:	e8 4a 13 00 00       	call   391b <printf>
}
    25d1:	83 c4 10             	add    $0x10,%esp
    25d4:	c9                   	leave  
    25d5:	c3                   	ret    
    printf(1, "mkdir 12345678901234 failed\n");
    25d6:	83 ec 08             	sub    $0x8,%esp
    25d9:	68 4f 47 00 00       	push   $0x474f
    25de:	6a 01                	push   $0x1
    25e0:	e8 36 13 00 00       	call   391b <printf>
    exit();
    25e5:	e8 e8 11 00 00       	call   37d2 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 failed\n");
    25ea:	83 ec 08             	sub    $0x8,%esp
    25ed:	68 58 4f 00 00       	push   $0x4f58
    25f2:	6a 01                	push   $0x1
    25f4:	e8 22 13 00 00       	call   391b <printf>
    exit();
    25f9:	e8 d4 11 00 00       	call   37d2 <exit>
    printf(1, "create 123456789012345/123456789012345/123456789012345 failed\n");
    25fe:	83 ec 08             	sub    $0x8,%esp
    2601:	68 b8 4f 00 00       	push   $0x4fb8
    2606:	6a 01                	push   $0x1
    2608:	e8 0e 13 00 00       	call   391b <printf>
    exit();
    260d:	e8 c0 11 00 00       	call   37d2 <exit>
    printf(1, "open 12345678901234/12345678901234/12345678901234 failed\n");
    2612:	83 ec 08             	sub    $0x8,%esp
    2615:	68 28 50 00 00       	push   $0x5028
    261a:	6a 01                	push   $0x1
    261c:	e8 fa 12 00 00       	call   391b <printf>
    exit();
    2621:	e8 ac 11 00 00       	call   37d2 <exit>
    printf(1, "mkdir 12345678901234/12345678901234 succeeded!\n");
    2626:	83 ec 08             	sub    $0x8,%esp
    2629:	68 64 50 00 00       	push   $0x5064
    262e:	6a 01                	push   $0x1
    2630:	e8 e6 12 00 00       	call   391b <printf>
    exit();
    2635:	e8 98 11 00 00       	call   37d2 <exit>
    printf(1, "mkdir 12345678901234/123456789012345 succeeded!\n");
    263a:	83 ec 08             	sub    $0x8,%esp
    263d:	68 b4 50 00 00       	push   $0x50b4
    2642:	6a 01                	push   $0x1
    2644:	e8 d2 12 00 00       	call   391b <printf>
    exit();
    2649:	e8 84 11 00 00       	call   37d2 <exit>

0000264e <rmdot>:

void
rmdot(void)
{
    264e:	f3 0f 1e fb          	endbr32 
    2652:	55                   	push   %ebp
    2653:	89 e5                	mov    %esp,%ebp
    2655:	83 ec 10             	sub    $0x10,%esp
  printf(1, "rmdot test\n");
    2658:	68 97 47 00 00       	push   $0x4797
    265d:	6a 01                	push   $0x1
    265f:	e8 b7 12 00 00       	call   391b <printf>
  if(mkdir("dots") != 0){
    2664:	c7 04 24 a3 47 00 00 	movl   $0x47a3,(%esp)
    266b:	e8 ca 11 00 00       	call   383a <mkdir>
    2670:	83 c4 10             	add    $0x10,%esp
    2673:	85 c0                	test   %eax,%eax
    2675:	0f 85 bc 00 00 00    	jne    2737 <rmdot+0xe9>
    printf(1, "mkdir dots failed\n");
    exit();
  }
  if(chdir("dots") != 0){
    267b:	83 ec 0c             	sub    $0xc,%esp
    267e:	68 a3 47 00 00       	push   $0x47a3
    2683:	e8 ba 11 00 00       	call   3842 <chdir>
    2688:	83 c4 10             	add    $0x10,%esp
    268b:	85 c0                	test   %eax,%eax
    268d:	0f 85 b8 00 00 00    	jne    274b <rmdot+0xfd>
    printf(1, "chdir dots failed\n");
    exit();
  }
  if(unlink(".") == 0){
    2693:	83 ec 0c             	sub    $0xc,%esp
    2696:	68 4e 44 00 00       	push   $0x444e
    269b:	e8 82 11 00 00       	call   3822 <unlink>
    26a0:	83 c4 10             	add    $0x10,%esp
    26a3:	85 c0                	test   %eax,%eax
    26a5:	0f 84 b4 00 00 00    	je     275f <rmdot+0x111>
    printf(1, "rm . worked!\n");
    exit();
  }
  if(unlink("..") == 0){
    26ab:	83 ec 0c             	sub    $0xc,%esp
    26ae:	68 4d 44 00 00       	push   $0x444d
    26b3:	e8 6a 11 00 00       	call   3822 <unlink>
    26b8:	83 c4 10             	add    $0x10,%esp
    26bb:	85 c0                	test   %eax,%eax
    26bd:	0f 84 b0 00 00 00    	je     2773 <rmdot+0x125>
    printf(1, "rm .. worked!\n");
    exit();
  }
  if(chdir("/") != 0){
    26c3:	83 ec 0c             	sub    $0xc,%esp
    26c6:	68 21 3c 00 00       	push   $0x3c21
    26cb:	e8 72 11 00 00       	call   3842 <chdir>
    26d0:	83 c4 10             	add    $0x10,%esp
    26d3:	85 c0                	test   %eax,%eax
    26d5:	0f 85 ac 00 00 00    	jne    2787 <rmdot+0x139>
    printf(1, "chdir / failed\n");
    exit();
  }
  if(unlink("dots/.") == 0){
    26db:	83 ec 0c             	sub    $0xc,%esp
    26de:	68 eb 47 00 00       	push   $0x47eb
    26e3:	e8 3a 11 00 00       	call   3822 <unlink>
    26e8:	83 c4 10             	add    $0x10,%esp
    26eb:	85 c0                	test   %eax,%eax
    26ed:	0f 84 a8 00 00 00    	je     279b <rmdot+0x14d>
    printf(1, "unlink dots/. worked!\n");
    exit();
  }
  if(unlink("dots/..") == 0){
    26f3:	83 ec 0c             	sub    $0xc,%esp
    26f6:	68 09 48 00 00       	push   $0x4809
    26fb:	e8 22 11 00 00       	call   3822 <unlink>
    2700:	83 c4 10             	add    $0x10,%esp
    2703:	85 c0                	test   %eax,%eax
    2705:	0f 84 a4 00 00 00    	je     27af <rmdot+0x161>
    printf(1, "unlink dots/.. worked!\n");
    exit();
  }
  if(unlink("dots") != 0){
    270b:	83 ec 0c             	sub    $0xc,%esp
    270e:	68 a3 47 00 00       	push   $0x47a3
    2713:	e8 0a 11 00 00       	call   3822 <unlink>
    2718:	83 c4 10             	add    $0x10,%esp
    271b:	85 c0                	test   %eax,%eax
    271d:	0f 85 a0 00 00 00    	jne    27c3 <rmdot+0x175>
    printf(1, "unlink dots failed!\n");
    exit();
  }
  printf(1, "rmdot ok\n");
    2723:	83 ec 08             	sub    $0x8,%esp
    2726:	68 3e 48 00 00       	push   $0x483e
    272b:	6a 01                	push   $0x1
    272d:	e8 e9 11 00 00       	call   391b <printf>
}
    2732:	83 c4 10             	add    $0x10,%esp
    2735:	c9                   	leave  
    2736:	c3                   	ret    
    printf(1, "mkdir dots failed\n");
    2737:	83 ec 08             	sub    $0x8,%esp
    273a:	68 a8 47 00 00       	push   $0x47a8
    273f:	6a 01                	push   $0x1
    2741:	e8 d5 11 00 00       	call   391b <printf>
    exit();
    2746:	e8 87 10 00 00       	call   37d2 <exit>
    printf(1, "chdir dots failed\n");
    274b:	83 ec 08             	sub    $0x8,%esp
    274e:	68 bb 47 00 00       	push   $0x47bb
    2753:	6a 01                	push   $0x1
    2755:	e8 c1 11 00 00       	call   391b <printf>
    exit();
    275a:	e8 73 10 00 00       	call   37d2 <exit>
    printf(1, "rm . worked!\n");
    275f:	83 ec 08             	sub    $0x8,%esp
    2762:	68 ce 47 00 00       	push   $0x47ce
    2767:	6a 01                	push   $0x1
    2769:	e8 ad 11 00 00       	call   391b <printf>
    exit();
    276e:	e8 5f 10 00 00       	call   37d2 <exit>
    printf(1, "rm .. worked!\n");
    2773:	83 ec 08             	sub    $0x8,%esp
    2776:	68 dc 47 00 00       	push   $0x47dc
    277b:	6a 01                	push   $0x1
    277d:	e8 99 11 00 00       	call   391b <printf>
    exit();
    2782:	e8 4b 10 00 00       	call   37d2 <exit>
    printf(1, "chdir / failed\n");
    2787:	83 ec 08             	sub    $0x8,%esp
    278a:	68 23 3c 00 00       	push   $0x3c23
    278f:	6a 01                	push   $0x1
    2791:	e8 85 11 00 00       	call   391b <printf>
    exit();
    2796:	e8 37 10 00 00       	call   37d2 <exit>
    printf(1, "unlink dots/. worked!\n");
    279b:	83 ec 08             	sub    $0x8,%esp
    279e:	68 f2 47 00 00       	push   $0x47f2
    27a3:	6a 01                	push   $0x1
    27a5:	e8 71 11 00 00       	call   391b <printf>
    exit();
    27aa:	e8 23 10 00 00       	call   37d2 <exit>
    printf(1, "unlink dots/.. worked!\n");
    27af:	83 ec 08             	sub    $0x8,%esp
    27b2:	68 11 48 00 00       	push   $0x4811
    27b7:	6a 01                	push   $0x1
    27b9:	e8 5d 11 00 00       	call   391b <printf>
    exit();
    27be:	e8 0f 10 00 00       	call   37d2 <exit>
    printf(1, "unlink dots failed!\n");
    27c3:	83 ec 08             	sub    $0x8,%esp
    27c6:	68 29 48 00 00       	push   $0x4829
    27cb:	6a 01                	push   $0x1
    27cd:	e8 49 11 00 00       	call   391b <printf>
    exit();
    27d2:	e8 fb 0f 00 00       	call   37d2 <exit>

000027d7 <dirfile>:

void
dirfile(void)
{
    27d7:	f3 0f 1e fb          	endbr32 
    27db:	55                   	push   %ebp
    27dc:	89 e5                	mov    %esp,%ebp
    27de:	53                   	push   %ebx
    27df:	83 ec 0c             	sub    $0xc,%esp
  int fd;

  printf(1, "dir vs file\n");
    27e2:	68 48 48 00 00       	push   $0x4848
    27e7:	6a 01                	push   $0x1
    27e9:	e8 2d 11 00 00       	call   391b <printf>

  fd = open("dirfile", O_CREATE);
    27ee:	83 c4 08             	add    $0x8,%esp
    27f1:	68 00 02 00 00       	push   $0x200
    27f6:	68 55 48 00 00       	push   $0x4855
    27fb:	e8 12 10 00 00       	call   3812 <open>
  if(fd < 0){
    2800:	83 c4 10             	add    $0x10,%esp
    2803:	85 c0                	test   %eax,%eax
    2805:	0f 88 22 01 00 00    	js     292d <dirfile+0x156>
    printf(1, "create dirfile failed\n");
    exit();
  }
  close(fd);
    280b:	83 ec 0c             	sub    $0xc,%esp
    280e:	50                   	push   %eax
    280f:	e8 e6 0f 00 00       	call   37fa <close>
  if(chdir("dirfile") == 0){
    2814:	c7 04 24 55 48 00 00 	movl   $0x4855,(%esp)
    281b:	e8 22 10 00 00       	call   3842 <chdir>
    2820:	83 c4 10             	add    $0x10,%esp
    2823:	85 c0                	test   %eax,%eax
    2825:	0f 84 16 01 00 00    	je     2941 <dirfile+0x16a>
    printf(1, "chdir dirfile succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", 0);
    282b:	83 ec 08             	sub    $0x8,%esp
    282e:	6a 00                	push   $0x0
    2830:	68 8e 48 00 00       	push   $0x488e
    2835:	e8 d8 0f 00 00       	call   3812 <open>
  if(fd >= 0){
    283a:	83 c4 10             	add    $0x10,%esp
    283d:	85 c0                	test   %eax,%eax
    283f:	0f 89 10 01 00 00    	jns    2955 <dirfile+0x17e>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  fd = open("dirfile/xx", O_CREATE);
    2845:	83 ec 08             	sub    $0x8,%esp
    2848:	68 00 02 00 00       	push   $0x200
    284d:	68 8e 48 00 00       	push   $0x488e
    2852:	e8 bb 0f 00 00       	call   3812 <open>
  if(fd >= 0){
    2857:	83 c4 10             	add    $0x10,%esp
    285a:	85 c0                	test   %eax,%eax
    285c:	0f 89 07 01 00 00    	jns    2969 <dirfile+0x192>
    printf(1, "create dirfile/xx succeeded!\n");
    exit();
  }
  if(mkdir("dirfile/xx") == 0){
    2862:	83 ec 0c             	sub    $0xc,%esp
    2865:	68 8e 48 00 00       	push   $0x488e
    286a:	e8 cb 0f 00 00       	call   383a <mkdir>
    286f:	83 c4 10             	add    $0x10,%esp
    2872:	85 c0                	test   %eax,%eax
    2874:	0f 84 03 01 00 00    	je     297d <dirfile+0x1a6>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile/xx") == 0){
    287a:	83 ec 0c             	sub    $0xc,%esp
    287d:	68 8e 48 00 00       	push   $0x488e
    2882:	e8 9b 0f 00 00       	call   3822 <unlink>
    2887:	83 c4 10             	add    $0x10,%esp
    288a:	85 c0                	test   %eax,%eax
    288c:	0f 84 ff 00 00 00    	je     2991 <dirfile+0x1ba>
    printf(1, "unlink dirfile/xx succeeded!\n");
    exit();
  }
  if(link("README", "dirfile/xx") == 0){
    2892:	83 ec 08             	sub    $0x8,%esp
    2895:	68 8e 48 00 00       	push   $0x488e
    289a:	68 f2 48 00 00       	push   $0x48f2
    289f:	e8 8e 0f 00 00       	call   3832 <link>
    28a4:	83 c4 10             	add    $0x10,%esp
    28a7:	85 c0                	test   %eax,%eax
    28a9:	0f 84 f6 00 00 00    	je     29a5 <dirfile+0x1ce>
    printf(1, "link to dirfile/xx succeeded!\n");
    exit();
  }
  if(unlink("dirfile") != 0){
    28af:	83 ec 0c             	sub    $0xc,%esp
    28b2:	68 55 48 00 00       	push   $0x4855
    28b7:	e8 66 0f 00 00       	call   3822 <unlink>
    28bc:	83 c4 10             	add    $0x10,%esp
    28bf:	85 c0                	test   %eax,%eax
    28c1:	0f 85 f2 00 00 00    	jne    29b9 <dirfile+0x1e2>
    printf(1, "unlink dirfile failed!\n");
    exit();
  }

  fd = open(".", O_RDWR);
    28c7:	83 ec 08             	sub    $0x8,%esp
    28ca:	6a 02                	push   $0x2
    28cc:	68 4e 44 00 00       	push   $0x444e
    28d1:	e8 3c 0f 00 00       	call   3812 <open>
  if(fd >= 0){
    28d6:	83 c4 10             	add    $0x10,%esp
    28d9:	85 c0                	test   %eax,%eax
    28db:	0f 89 ec 00 00 00    	jns    29cd <dirfile+0x1f6>
    printf(1, "open . for writing succeeded!\n");
    exit();
  }
  fd = open(".", 0);
    28e1:	83 ec 08             	sub    $0x8,%esp
    28e4:	6a 00                	push   $0x0
    28e6:	68 4e 44 00 00       	push   $0x444e
    28eb:	e8 22 0f 00 00       	call   3812 <open>
    28f0:	89 c3                	mov    %eax,%ebx
  if(write(fd, "x", 1) > 0){
    28f2:	83 c4 0c             	add    $0xc,%esp
    28f5:	6a 01                	push   $0x1
    28f7:	68 31 45 00 00       	push   $0x4531
    28fc:	50                   	push   %eax
    28fd:	e8 f0 0e 00 00       	call   37f2 <write>
    2902:	83 c4 10             	add    $0x10,%esp
    2905:	85 c0                	test   %eax,%eax
    2907:	0f 8f d4 00 00 00    	jg     29e1 <dirfile+0x20a>
    printf(1, "write . succeeded!\n");
    exit();
  }
  close(fd);
    290d:	83 ec 0c             	sub    $0xc,%esp
    2910:	53                   	push   %ebx
    2911:	e8 e4 0e 00 00       	call   37fa <close>

  printf(1, "dir vs file OK\n");
    2916:	83 c4 08             	add    $0x8,%esp
    2919:	68 25 49 00 00       	push   $0x4925
    291e:	6a 01                	push   $0x1
    2920:	e8 f6 0f 00 00       	call   391b <printf>
}
    2925:	83 c4 10             	add    $0x10,%esp
    2928:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    292b:	c9                   	leave  
    292c:	c3                   	ret    
    printf(1, "create dirfile failed\n");
    292d:	83 ec 08             	sub    $0x8,%esp
    2930:	68 5d 48 00 00       	push   $0x485d
    2935:	6a 01                	push   $0x1
    2937:	e8 df 0f 00 00       	call   391b <printf>
    exit();
    293c:	e8 91 0e 00 00       	call   37d2 <exit>
    printf(1, "chdir dirfile succeeded!\n");
    2941:	83 ec 08             	sub    $0x8,%esp
    2944:	68 74 48 00 00       	push   $0x4874
    2949:	6a 01                	push   $0x1
    294b:	e8 cb 0f 00 00       	call   391b <printf>
    exit();
    2950:	e8 7d 0e 00 00       	call   37d2 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2955:	83 ec 08             	sub    $0x8,%esp
    2958:	68 99 48 00 00       	push   $0x4899
    295d:	6a 01                	push   $0x1
    295f:	e8 b7 0f 00 00       	call   391b <printf>
    exit();
    2964:	e8 69 0e 00 00       	call   37d2 <exit>
    printf(1, "create dirfile/xx succeeded!\n");
    2969:	83 ec 08             	sub    $0x8,%esp
    296c:	68 99 48 00 00       	push   $0x4899
    2971:	6a 01                	push   $0x1
    2973:	e8 a3 0f 00 00       	call   391b <printf>
    exit();
    2978:	e8 55 0e 00 00       	call   37d2 <exit>
    printf(1, "mkdir dirfile/xx succeeded!\n");
    297d:	83 ec 08             	sub    $0x8,%esp
    2980:	68 b7 48 00 00       	push   $0x48b7
    2985:	6a 01                	push   $0x1
    2987:	e8 8f 0f 00 00       	call   391b <printf>
    exit();
    298c:	e8 41 0e 00 00       	call   37d2 <exit>
    printf(1, "unlink dirfile/xx succeeded!\n");
    2991:	83 ec 08             	sub    $0x8,%esp
    2994:	68 d4 48 00 00       	push   $0x48d4
    2999:	6a 01                	push   $0x1
    299b:	e8 7b 0f 00 00       	call   391b <printf>
    exit();
    29a0:	e8 2d 0e 00 00       	call   37d2 <exit>
    printf(1, "link to dirfile/xx succeeded!\n");
    29a5:	83 ec 08             	sub    $0x8,%esp
    29a8:	68 e8 50 00 00       	push   $0x50e8
    29ad:	6a 01                	push   $0x1
    29af:	e8 67 0f 00 00       	call   391b <printf>
    exit();
    29b4:	e8 19 0e 00 00       	call   37d2 <exit>
    printf(1, "unlink dirfile failed!\n");
    29b9:	83 ec 08             	sub    $0x8,%esp
    29bc:	68 f9 48 00 00       	push   $0x48f9
    29c1:	6a 01                	push   $0x1
    29c3:	e8 53 0f 00 00       	call   391b <printf>
    exit();
    29c8:	e8 05 0e 00 00       	call   37d2 <exit>
    printf(1, "open . for writing succeeded!\n");
    29cd:	83 ec 08             	sub    $0x8,%esp
    29d0:	68 08 51 00 00       	push   $0x5108
    29d5:	6a 01                	push   $0x1
    29d7:	e8 3f 0f 00 00       	call   391b <printf>
    exit();
    29dc:	e8 f1 0d 00 00       	call   37d2 <exit>
    printf(1, "write . succeeded!\n");
    29e1:	83 ec 08             	sub    $0x8,%esp
    29e4:	68 11 49 00 00       	push   $0x4911
    29e9:	6a 01                	push   $0x1
    29eb:	e8 2b 0f 00 00       	call   391b <printf>
    exit();
    29f0:	e8 dd 0d 00 00       	call   37d2 <exit>

000029f5 <iref>:

// test that iput() is called at the end of _namei()
void
iref(void)
{
    29f5:	f3 0f 1e fb          	endbr32 
    29f9:	55                   	push   %ebp
    29fa:	89 e5                	mov    %esp,%ebp
    29fc:	53                   	push   %ebx
    29fd:	83 ec 0c             	sub    $0xc,%esp
  int i, fd;

  printf(1, "empty file name\n");
    2a00:	68 35 49 00 00       	push   $0x4935
    2a05:	6a 01                	push   $0x1
    2a07:	e8 0f 0f 00 00       	call   391b <printf>

  // the 50 is NINODE
  for(i = 0; i < 50 + 1; i++){
    2a0c:	83 c4 10             	add    $0x10,%esp
    2a0f:	bb 00 00 00 00       	mov    $0x0,%ebx
    2a14:	eb 4c                	jmp    2a62 <iref+0x6d>
    if(mkdir("irefd") != 0){
      printf(1, "mkdir irefd failed\n");
    2a16:	83 ec 08             	sub    $0x8,%esp
    2a19:	68 4c 49 00 00       	push   $0x494c
    2a1e:	6a 01                	push   $0x1
    2a20:	e8 f6 0e 00 00       	call   391b <printf>
      exit();
    2a25:	e8 a8 0d 00 00       	call   37d2 <exit>
    }
    if(chdir("irefd") != 0){
      printf(1, "chdir irefd failed\n");
    2a2a:	83 ec 08             	sub    $0x8,%esp
    2a2d:	68 60 49 00 00       	push   $0x4960
    2a32:	6a 01                	push   $0x1
    2a34:	e8 e2 0e 00 00       	call   391b <printf>
      exit();
    2a39:	e8 94 0d 00 00       	call   37d2 <exit>

    mkdir("");
    link("README", "");
    fd = open("", O_CREATE);
    if(fd >= 0)
      close(fd);
    2a3e:	83 ec 0c             	sub    $0xc,%esp
    2a41:	50                   	push   %eax
    2a42:	e8 b3 0d 00 00       	call   37fa <close>
    2a47:	83 c4 10             	add    $0x10,%esp
    2a4a:	e9 80 00 00 00       	jmp    2acf <iref+0xda>
    fd = open("xx", O_CREATE);
    if(fd >= 0)
      close(fd);
    unlink("xx");
    2a4f:	83 ec 0c             	sub    $0xc,%esp
    2a52:	68 30 45 00 00       	push   $0x4530
    2a57:	e8 c6 0d 00 00       	call   3822 <unlink>
  for(i = 0; i < 50 + 1; i++){
    2a5c:	83 c3 01             	add    $0x1,%ebx
    2a5f:	83 c4 10             	add    $0x10,%esp
    2a62:	83 fb 32             	cmp    $0x32,%ebx
    2a65:	0f 8f 92 00 00 00    	jg     2afd <iref+0x108>
    if(mkdir("irefd") != 0){
    2a6b:	83 ec 0c             	sub    $0xc,%esp
    2a6e:	68 46 49 00 00       	push   $0x4946
    2a73:	e8 c2 0d 00 00       	call   383a <mkdir>
    2a78:	83 c4 10             	add    $0x10,%esp
    2a7b:	85 c0                	test   %eax,%eax
    2a7d:	75 97                	jne    2a16 <iref+0x21>
    if(chdir("irefd") != 0){
    2a7f:	83 ec 0c             	sub    $0xc,%esp
    2a82:	68 46 49 00 00       	push   $0x4946
    2a87:	e8 b6 0d 00 00       	call   3842 <chdir>
    2a8c:	83 c4 10             	add    $0x10,%esp
    2a8f:	85 c0                	test   %eax,%eax
    2a91:	75 97                	jne    2a2a <iref+0x35>
    mkdir("");
    2a93:	83 ec 0c             	sub    $0xc,%esp
    2a96:	68 fb 3f 00 00       	push   $0x3ffb
    2a9b:	e8 9a 0d 00 00       	call   383a <mkdir>
    link("README", "");
    2aa0:	83 c4 08             	add    $0x8,%esp
    2aa3:	68 fb 3f 00 00       	push   $0x3ffb
    2aa8:	68 f2 48 00 00       	push   $0x48f2
    2aad:	e8 80 0d 00 00       	call   3832 <link>
    fd = open("", O_CREATE);
    2ab2:	83 c4 08             	add    $0x8,%esp
    2ab5:	68 00 02 00 00       	push   $0x200
    2aba:	68 fb 3f 00 00       	push   $0x3ffb
    2abf:	e8 4e 0d 00 00       	call   3812 <open>
    if(fd >= 0)
    2ac4:	83 c4 10             	add    $0x10,%esp
    2ac7:	85 c0                	test   %eax,%eax
    2ac9:	0f 89 6f ff ff ff    	jns    2a3e <iref+0x49>
    fd = open("xx", O_CREATE);
    2acf:	83 ec 08             	sub    $0x8,%esp
    2ad2:	68 00 02 00 00       	push   $0x200
    2ad7:	68 30 45 00 00       	push   $0x4530
    2adc:	e8 31 0d 00 00       	call   3812 <open>
    if(fd >= 0)
    2ae1:	83 c4 10             	add    $0x10,%esp
    2ae4:	85 c0                	test   %eax,%eax
    2ae6:	0f 88 63 ff ff ff    	js     2a4f <iref+0x5a>
      close(fd);
    2aec:	83 ec 0c             	sub    $0xc,%esp
    2aef:	50                   	push   %eax
    2af0:	e8 05 0d 00 00       	call   37fa <close>
    2af5:	83 c4 10             	add    $0x10,%esp
    2af8:	e9 52 ff ff ff       	jmp    2a4f <iref+0x5a>
  }

  chdir("/");
    2afd:	83 ec 0c             	sub    $0xc,%esp
    2b00:	68 21 3c 00 00       	push   $0x3c21
    2b05:	e8 38 0d 00 00       	call   3842 <chdir>
  printf(1, "empty file name OK\n");
    2b0a:	83 c4 08             	add    $0x8,%esp
    2b0d:	68 74 49 00 00       	push   $0x4974
    2b12:	6a 01                	push   $0x1
    2b14:	e8 02 0e 00 00       	call   391b <printf>
}
    2b19:	83 c4 10             	add    $0x10,%esp
    2b1c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2b1f:	c9                   	leave  
    2b20:	c3                   	ret    

00002b21 <forktest>:
// test that fork fails gracefully
// the forktest binary also does this, but it runs out of proc entries first.
// inside the bigger usertests binary, we run out of memory first.
void
forktest(void)
{
    2b21:	f3 0f 1e fb          	endbr32 
    2b25:	55                   	push   %ebp
    2b26:	89 e5                	mov    %esp,%ebp
    2b28:	53                   	push   %ebx
    2b29:	83 ec 0c             	sub    $0xc,%esp
  int n, pid;

  printf(1, "fork test\n");
    2b2c:	68 88 49 00 00       	push   $0x4988
    2b31:	6a 01                	push   $0x1
    2b33:	e8 e3 0d 00 00       	call   391b <printf>

  for(n=0; n<1000; n++){
    2b38:	83 c4 10             	add    $0x10,%esp
    2b3b:	bb 00 00 00 00       	mov    $0x0,%ebx
    2b40:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
    2b46:	7f 15                	jg     2b5d <forktest+0x3c>
    pid = fork();
    2b48:	e8 7d 0c 00 00       	call   37ca <fork>
    if(pid < 0)
    2b4d:	85 c0                	test   %eax,%eax
    2b4f:	78 0c                	js     2b5d <forktest+0x3c>
      break;
    if(pid == 0)
    2b51:	74 05                	je     2b58 <forktest+0x37>
  for(n=0; n<1000; n++){
    2b53:	83 c3 01             	add    $0x1,%ebx
    2b56:	eb e8                	jmp    2b40 <forktest+0x1f>
      exit();
    2b58:	e8 75 0c 00 00       	call   37d2 <exit>
  }

  if(n == 1000){
    2b5d:	81 fb e8 03 00 00    	cmp    $0x3e8,%ebx
    2b63:	74 12                	je     2b77 <forktest+0x56>
    printf(1, "fork claimed to work 1000 times!\n");
    exit();
  }

  for(; n > 0; n--){
    2b65:	85 db                	test   %ebx,%ebx
    2b67:	7e 36                	jle    2b9f <forktest+0x7e>
    if(wait() < 0){
    2b69:	e8 6c 0c 00 00       	call   37da <wait>
    2b6e:	85 c0                	test   %eax,%eax
    2b70:	78 19                	js     2b8b <forktest+0x6a>
  for(; n > 0; n--){
    2b72:	83 eb 01             	sub    $0x1,%ebx
    2b75:	eb ee                	jmp    2b65 <forktest+0x44>
    printf(1, "fork claimed to work 1000 times!\n");
    2b77:	83 ec 08             	sub    $0x8,%esp
    2b7a:	68 28 51 00 00       	push   $0x5128
    2b7f:	6a 01                	push   $0x1
    2b81:	e8 95 0d 00 00       	call   391b <printf>
    exit();
    2b86:	e8 47 0c 00 00       	call   37d2 <exit>
      printf(1, "wait stopped early\n");
    2b8b:	83 ec 08             	sub    $0x8,%esp
    2b8e:	68 93 49 00 00       	push   $0x4993
    2b93:	6a 01                	push   $0x1
    2b95:	e8 81 0d 00 00       	call   391b <printf>
      exit();
    2b9a:	e8 33 0c 00 00       	call   37d2 <exit>
    }
  }

  if(wait() != -1){
    2b9f:	e8 36 0c 00 00       	call   37da <wait>
    2ba4:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ba7:	75 17                	jne    2bc0 <forktest+0x9f>
    printf(1, "wait got too many\n");
    exit();
  }

  printf(1, "fork test OK\n");
    2ba9:	83 ec 08             	sub    $0x8,%esp
    2bac:	68 ba 49 00 00       	push   $0x49ba
    2bb1:	6a 01                	push   $0x1
    2bb3:	e8 63 0d 00 00       	call   391b <printf>
}
    2bb8:	83 c4 10             	add    $0x10,%esp
    2bbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    2bbe:	c9                   	leave  
    2bbf:	c3                   	ret    
    printf(1, "wait got too many\n");
    2bc0:	83 ec 08             	sub    $0x8,%esp
    2bc3:	68 a7 49 00 00       	push   $0x49a7
    2bc8:	6a 01                	push   $0x1
    2bca:	e8 4c 0d 00 00       	call   391b <printf>
    exit();
    2bcf:	e8 fe 0b 00 00       	call   37d2 <exit>

00002bd4 <sbrktest>:

void
sbrktest(void)
{
    2bd4:	f3 0f 1e fb          	endbr32 
    2bd8:	55                   	push   %ebp
    2bd9:	89 e5                	mov    %esp,%ebp
    2bdb:	57                   	push   %edi
    2bdc:	56                   	push   %esi
    2bdd:	53                   	push   %ebx
    2bde:	83 ec 54             	sub    $0x54,%esp
  int fds[2], pid, pids[10], ppid;
  char *a, *b, *c, *lastaddr, *oldbrk, *p, scratch;
  uint amt;

  printf(stdout, "sbrk test\n");
    2be1:	68 c8 49 00 00       	push   $0x49c8
    2be6:	ff 35 08 5c 00 00    	pushl  0x5c08
    2bec:	e8 2a 0d 00 00       	call   391b <printf>
  oldbrk = sbrk(0);
    2bf1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2bf8:	e8 5d 0c 00 00       	call   385a <sbrk>
    2bfd:	89 c7                	mov    %eax,%edi

  // can one sbrk() less than a page?
  a = sbrk(0);
    2bff:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2c06:	e8 4f 0c 00 00       	call   385a <sbrk>
    2c0b:	89 c6                	mov    %eax,%esi
  int i;
  for(i = 0; i < 5000; i++){
    2c0d:	83 c4 10             	add    $0x10,%esp
    2c10:	bb 00 00 00 00       	mov    $0x0,%ebx
    2c15:	81 fb 87 13 00 00    	cmp    $0x1387,%ebx
    2c1b:	7f 3a                	jg     2c57 <sbrktest+0x83>
    b = sbrk(1);
    2c1d:	83 ec 0c             	sub    $0xc,%esp
    2c20:	6a 01                	push   $0x1
    2c22:	e8 33 0c 00 00       	call   385a <sbrk>
    if(b != a){
    2c27:	83 c4 10             	add    $0x10,%esp
    2c2a:	39 c6                	cmp    %eax,%esi
    2c2c:	75 0b                	jne    2c39 <sbrktest+0x65>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
      exit();
    }
    *b = 1;
    2c2e:	c6 00 01             	movb   $0x1,(%eax)
    a = b + 1;
    2c31:	8d 70 01             	lea    0x1(%eax),%esi
  for(i = 0; i < 5000; i++){
    2c34:	83 c3 01             	add    $0x1,%ebx
    2c37:	eb dc                	jmp    2c15 <sbrktest+0x41>
      printf(stdout, "sbrk test failed %d %x %x\n", i, a, b);
    2c39:	83 ec 0c             	sub    $0xc,%esp
    2c3c:	50                   	push   %eax
    2c3d:	56                   	push   %esi
    2c3e:	53                   	push   %ebx
    2c3f:	68 d3 49 00 00       	push   $0x49d3
    2c44:	ff 35 08 5c 00 00    	pushl  0x5c08
    2c4a:	e8 cc 0c 00 00       	call   391b <printf>
      exit();
    2c4f:	83 c4 20             	add    $0x20,%esp
    2c52:	e8 7b 0b 00 00       	call   37d2 <exit>
  }
  pid = fork();
    2c57:	e8 6e 0b 00 00       	call   37ca <fork>
    2c5c:	89 c3                	mov    %eax,%ebx
  if(pid < 0){
    2c5e:	85 c0                	test   %eax,%eax
    2c60:	0f 88 51 01 00 00    	js     2db7 <sbrktest+0x1e3>
    printf(stdout, "sbrk test fork failed\n");
    exit();
  }
  c = sbrk(1);
    2c66:	83 ec 0c             	sub    $0xc,%esp
    2c69:	6a 01                	push   $0x1
    2c6b:	e8 ea 0b 00 00       	call   385a <sbrk>
  c = sbrk(1);
    2c70:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
    2c77:	e8 de 0b 00 00       	call   385a <sbrk>
  if(c != a + 1){
    2c7c:	83 c6 01             	add    $0x1,%esi
    2c7f:	83 c4 10             	add    $0x10,%esp
    2c82:	39 c6                	cmp    %eax,%esi
    2c84:	0f 85 45 01 00 00    	jne    2dcf <sbrktest+0x1fb>
    printf(stdout, "sbrk test failed post-fork\n");
    exit();
  }
  if(pid == 0)
    2c8a:	85 db                	test   %ebx,%ebx
    2c8c:	0f 84 55 01 00 00    	je     2de7 <sbrktest+0x213>
    exit();
  wait();
    2c92:	e8 43 0b 00 00       	call   37da <wait>

  // can one grow address space to something big?
#define BIG (100*1024*1024)
  a = sbrk(0);
    2c97:	83 ec 0c             	sub    $0xc,%esp
    2c9a:	6a 00                	push   $0x0
    2c9c:	e8 b9 0b 00 00       	call   385a <sbrk>
    2ca1:	89 c3                	mov    %eax,%ebx
  amt = (BIG) - (uint)a;
    2ca3:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2ca8:	29 d8                	sub    %ebx,%eax
  p = sbrk(amt);
    2caa:	89 04 24             	mov    %eax,(%esp)
    2cad:	e8 a8 0b 00 00       	call   385a <sbrk>
  if (p != a) {
    2cb2:	83 c4 10             	add    $0x10,%esp
    2cb5:	39 c3                	cmp    %eax,%ebx
    2cb7:	0f 85 2f 01 00 00    	jne    2dec <sbrktest+0x218>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    exit();
  }
  lastaddr = (char*) (BIG-1);
  *lastaddr = 99;
    2cbd:	c6 05 ff ff 3f 06 63 	movb   $0x63,0x63fffff

  // can one de-allocate?
  a = sbrk(0);
    2cc4:	83 ec 0c             	sub    $0xc,%esp
    2cc7:	6a 00                	push   $0x0
    2cc9:	e8 8c 0b 00 00       	call   385a <sbrk>
    2cce:	89 c3                	mov    %eax,%ebx
  c = sbrk(-4096);
    2cd0:	c7 04 24 00 f0 ff ff 	movl   $0xfffff000,(%esp)
    2cd7:	e8 7e 0b 00 00       	call   385a <sbrk>
  if(c == (char*)0xffffffff){
    2cdc:	83 c4 10             	add    $0x10,%esp
    2cdf:	83 f8 ff             	cmp    $0xffffffff,%eax
    2ce2:	0f 84 1c 01 00 00    	je     2e04 <sbrktest+0x230>
    printf(stdout, "sbrk could not deallocate\n");
    exit();
  }
  c = sbrk(0);
    2ce8:	83 ec 0c             	sub    $0xc,%esp
    2ceb:	6a 00                	push   $0x0
    2ced:	e8 68 0b 00 00       	call   385a <sbrk>
  if(c != a - 4096){
    2cf2:	8d 93 00 f0 ff ff    	lea    -0x1000(%ebx),%edx
    2cf8:	83 c4 10             	add    $0x10,%esp
    2cfb:	39 c2                	cmp    %eax,%edx
    2cfd:	0f 85 19 01 00 00    	jne    2e1c <sbrktest+0x248>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    exit();
  }

  // can one re-allocate that page?
  a = sbrk(0);
    2d03:	83 ec 0c             	sub    $0xc,%esp
    2d06:	6a 00                	push   $0x0
    2d08:	e8 4d 0b 00 00       	call   385a <sbrk>
    2d0d:	89 c3                	mov    %eax,%ebx
  c = sbrk(4096);
    2d0f:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
    2d16:	e8 3f 0b 00 00       	call   385a <sbrk>
    2d1b:	89 c6                	mov    %eax,%esi
  if(c != a || sbrk(0) != a + 4096){
    2d1d:	83 c4 10             	add    $0x10,%esp
    2d20:	39 c3                	cmp    %eax,%ebx
    2d22:	0f 85 0b 01 00 00    	jne    2e33 <sbrktest+0x25f>
    2d28:	83 ec 0c             	sub    $0xc,%esp
    2d2b:	6a 00                	push   $0x0
    2d2d:	e8 28 0b 00 00       	call   385a <sbrk>
    2d32:	8d 93 00 10 00 00    	lea    0x1000(%ebx),%edx
    2d38:	83 c4 10             	add    $0x10,%esp
    2d3b:	39 c2                	cmp    %eax,%edx
    2d3d:	0f 85 f0 00 00 00    	jne    2e33 <sbrktest+0x25f>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    exit();
  }
  if(*lastaddr == 99){
    2d43:	80 3d ff ff 3f 06 63 	cmpb   $0x63,0x63fffff
    2d4a:	0f 84 fa 00 00 00    	je     2e4a <sbrktest+0x276>
    // should be zero
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    exit();
  }

  a = sbrk(0);
    2d50:	83 ec 0c             	sub    $0xc,%esp
    2d53:	6a 00                	push   $0x0
    2d55:	e8 00 0b 00 00       	call   385a <sbrk>
    2d5a:	89 c3                	mov    %eax,%ebx
  c = sbrk(-(sbrk(0) - oldbrk));
    2d5c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    2d63:	e8 f2 0a 00 00       	call   385a <sbrk>
    2d68:	89 f9                	mov    %edi,%ecx
    2d6a:	29 c1                	sub    %eax,%ecx
    2d6c:	89 0c 24             	mov    %ecx,(%esp)
    2d6f:	e8 e6 0a 00 00       	call   385a <sbrk>
  if(c != a){
    2d74:	83 c4 10             	add    $0x10,%esp
    2d77:	39 c3                	cmp    %eax,%ebx
    2d79:	0f 85 e3 00 00 00    	jne    2e62 <sbrktest+0x28e>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    exit();
  }

  // can we read the kernel's memory?
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2d7f:	bb 00 00 00 80       	mov    $0x80000000,%ebx
    2d84:	81 fb 7f 84 1e 80    	cmp    $0x801e847f,%ebx
    2d8a:	0f 87 23 01 00 00    	ja     2eb3 <sbrktest+0x2df>
    ppid = getpid();
    2d90:	e8 bd 0a 00 00       	call   3852 <getpid>
    2d95:	89 c6                	mov    %eax,%esi
    pid = fork();
    2d97:	e8 2e 0a 00 00       	call   37ca <fork>
    if(pid < 0){
    2d9c:	85 c0                	test   %eax,%eax
    2d9e:	0f 88 d5 00 00 00    	js     2e79 <sbrktest+0x2a5>
      printf(stdout, "fork failed\n");
      exit();
    }
    if(pid == 0){
    2da4:	0f 84 e7 00 00 00    	je     2e91 <sbrktest+0x2bd>
      printf(stdout, "oops could read %x = %x\n", a, *a);
      kill(ppid);
      exit();
    }
    wait();
    2daa:	e8 2b 0a 00 00       	call   37da <wait>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    2daf:	81 c3 50 c3 00 00    	add    $0xc350,%ebx
    2db5:	eb cd                	jmp    2d84 <sbrktest+0x1b0>
    printf(stdout, "sbrk test fork failed\n");
    2db7:	83 ec 08             	sub    $0x8,%esp
    2dba:	68 ee 49 00 00       	push   $0x49ee
    2dbf:	ff 35 08 5c 00 00    	pushl  0x5c08
    2dc5:	e8 51 0b 00 00       	call   391b <printf>
    exit();
    2dca:	e8 03 0a 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk test failed post-fork\n");
    2dcf:	83 ec 08             	sub    $0x8,%esp
    2dd2:	68 05 4a 00 00       	push   $0x4a05
    2dd7:	ff 35 08 5c 00 00    	pushl  0x5c08
    2ddd:	e8 39 0b 00 00       	call   391b <printf>
    exit();
    2de2:	e8 eb 09 00 00       	call   37d2 <exit>
    exit();
    2de7:	e8 e6 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk test failed to grow big address space; enough phys mem?\n");
    2dec:	83 ec 08             	sub    $0x8,%esp
    2def:	68 4c 51 00 00       	push   $0x514c
    2df4:	ff 35 08 5c 00 00    	pushl  0x5c08
    2dfa:	e8 1c 0b 00 00       	call   391b <printf>
    exit();
    2dff:	e8 ce 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk could not deallocate\n");
    2e04:	83 ec 08             	sub    $0x8,%esp
    2e07:	68 21 4a 00 00       	push   $0x4a21
    2e0c:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e12:	e8 04 0b 00 00       	call   391b <printf>
    exit();
    2e17:	e8 b6 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk deallocation produced wrong address, a %x c %x\n", a, c);
    2e1c:	50                   	push   %eax
    2e1d:	53                   	push   %ebx
    2e1e:	68 8c 51 00 00       	push   $0x518c
    2e23:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e29:	e8 ed 0a 00 00       	call   391b <printf>
    exit();
    2e2e:	e8 9f 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk re-allocation failed, a %x c %x\n", a, c);
    2e33:	56                   	push   %esi
    2e34:	53                   	push   %ebx
    2e35:	68 c4 51 00 00       	push   $0x51c4
    2e3a:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e40:	e8 d6 0a 00 00       	call   391b <printf>
    exit();
    2e45:	e8 88 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk de-allocation didn't really deallocate\n");
    2e4a:	83 ec 08             	sub    $0x8,%esp
    2e4d:	68 ec 51 00 00       	push   $0x51ec
    2e52:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e58:	e8 be 0a 00 00       	call   391b <printf>
    exit();
    2e5d:	e8 70 09 00 00       	call   37d2 <exit>
    printf(stdout, "sbrk downsize failed, a %x c %x\n", a, c);
    2e62:	50                   	push   %eax
    2e63:	53                   	push   %ebx
    2e64:	68 1c 52 00 00       	push   $0x521c
    2e69:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e6f:	e8 a7 0a 00 00       	call   391b <printf>
    exit();
    2e74:	e8 59 09 00 00       	call   37d2 <exit>
      printf(stdout, "fork failed\n");
    2e79:	83 ec 08             	sub    $0x8,%esp
    2e7c:	68 19 4b 00 00       	push   $0x4b19
    2e81:	ff 35 08 5c 00 00    	pushl  0x5c08
    2e87:	e8 8f 0a 00 00       	call   391b <printf>
      exit();
    2e8c:	e8 41 09 00 00       	call   37d2 <exit>
      printf(stdout, "oops could read %x = %x\n", a, *a);
    2e91:	0f be 03             	movsbl (%ebx),%eax
    2e94:	50                   	push   %eax
    2e95:	53                   	push   %ebx
    2e96:	68 3c 4a 00 00       	push   $0x4a3c
    2e9b:	ff 35 08 5c 00 00    	pushl  0x5c08
    2ea1:	e8 75 0a 00 00       	call   391b <printf>
      kill(ppid);
    2ea6:	89 34 24             	mov    %esi,(%esp)
    2ea9:	e8 54 09 00 00       	call   3802 <kill>
      exit();
    2eae:	e8 1f 09 00 00       	call   37d2 <exit>
  }

  // if we run the system out of memory, does it clean up the last
  // failed allocation?
  if(pipe(fds) != 0){
    2eb3:	83 ec 0c             	sub    $0xc,%esp
    2eb6:	8d 45 e0             	lea    -0x20(%ebp),%eax
    2eb9:	50                   	push   %eax
    2eba:	e8 23 09 00 00       	call   37e2 <pipe>
    2ebf:	89 c3                	mov    %eax,%ebx
    2ec1:	83 c4 10             	add    $0x10,%esp
    2ec4:	85 c0                	test   %eax,%eax
    2ec6:	75 04                	jne    2ecc <sbrktest+0x2f8>
    printf(1, "pipe() failed\n");
    exit();
  }
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2ec8:	89 c6                	mov    %eax,%esi
    2eca:	eb 59                	jmp    2f25 <sbrktest+0x351>
    printf(1, "pipe() failed\n");
    2ecc:	83 ec 08             	sub    $0x8,%esp
    2ecf:	68 11 3f 00 00       	push   $0x3f11
    2ed4:	6a 01                	push   $0x1
    2ed6:	e8 40 0a 00 00       	call   391b <printf>
    exit();
    2edb:	e8 f2 08 00 00       	call   37d2 <exit>
    if((pids[i] = fork()) == 0){
      // allocate a lot of memory
      sbrk(BIG - (uint)sbrk(0));
    2ee0:	83 ec 0c             	sub    $0xc,%esp
    2ee3:	6a 00                	push   $0x0
    2ee5:	e8 70 09 00 00       	call   385a <sbrk>
    2eea:	89 c2                	mov    %eax,%edx
    2eec:	b8 00 00 40 06       	mov    $0x6400000,%eax
    2ef1:	29 d0                	sub    %edx,%eax
    2ef3:	89 04 24             	mov    %eax,(%esp)
    2ef6:	e8 5f 09 00 00       	call   385a <sbrk>
      write(fds[1], "x", 1);
    2efb:	83 c4 0c             	add    $0xc,%esp
    2efe:	6a 01                	push   $0x1
    2f00:	68 31 45 00 00       	push   $0x4531
    2f05:	ff 75 e4             	pushl  -0x1c(%ebp)
    2f08:	e8 e5 08 00 00       	call   37f2 <write>
    2f0d:	83 c4 10             	add    $0x10,%esp
      // sit around until killed
      for(;;) sleep(1000);
    2f10:	83 ec 0c             	sub    $0xc,%esp
    2f13:	68 e8 03 00 00       	push   $0x3e8
    2f18:	e8 45 09 00 00       	call   3862 <sleep>
    2f1d:	83 c4 10             	add    $0x10,%esp
    2f20:	eb ee                	jmp    2f10 <sbrktest+0x33c>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f22:	83 c6 01             	add    $0x1,%esi
    2f25:	83 fe 09             	cmp    $0x9,%esi
    2f28:	77 28                	ja     2f52 <sbrktest+0x37e>
    if((pids[i] = fork()) == 0){
    2f2a:	e8 9b 08 00 00       	call   37ca <fork>
    2f2f:	89 44 b5 b8          	mov    %eax,-0x48(%ebp,%esi,4)
    2f33:	85 c0                	test   %eax,%eax
    2f35:	74 a9                	je     2ee0 <sbrktest+0x30c>
    }
    if(pids[i] != -1)
    2f37:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f3a:	74 e6                	je     2f22 <sbrktest+0x34e>
      read(fds[0], &scratch, 1);
    2f3c:	83 ec 04             	sub    $0x4,%esp
    2f3f:	6a 01                	push   $0x1
    2f41:	8d 45 b7             	lea    -0x49(%ebp),%eax
    2f44:	50                   	push   %eax
    2f45:	ff 75 e0             	pushl  -0x20(%ebp)
    2f48:	e8 9d 08 00 00       	call   37ea <read>
    2f4d:	83 c4 10             	add    $0x10,%esp
    2f50:	eb d0                	jmp    2f22 <sbrktest+0x34e>
  }
  // if those failed allocations freed up the pages they did allocate,
  // we'll be able to allocate here
  c = sbrk(4096);
    2f52:	83 ec 0c             	sub    $0xc,%esp
    2f55:	68 00 10 00 00       	push   $0x1000
    2f5a:	e8 fb 08 00 00       	call   385a <sbrk>
    2f5f:	89 c6                	mov    %eax,%esi
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    2f61:	83 c4 10             	add    $0x10,%esp
    2f64:	eb 03                	jmp    2f69 <sbrktest+0x395>
    2f66:	83 c3 01             	add    $0x1,%ebx
    2f69:	83 fb 09             	cmp    $0x9,%ebx
    2f6c:	77 1c                	ja     2f8a <sbrktest+0x3b6>
    if(pids[i] == -1)
    2f6e:	8b 44 9d b8          	mov    -0x48(%ebp,%ebx,4),%eax
    2f72:	83 f8 ff             	cmp    $0xffffffff,%eax
    2f75:	74 ef                	je     2f66 <sbrktest+0x392>
      continue;
    kill(pids[i]);
    2f77:	83 ec 0c             	sub    $0xc,%esp
    2f7a:	50                   	push   %eax
    2f7b:	e8 82 08 00 00       	call   3802 <kill>
    wait();
    2f80:	e8 55 08 00 00       	call   37da <wait>
    2f85:	83 c4 10             	add    $0x10,%esp
    2f88:	eb dc                	jmp    2f66 <sbrktest+0x392>
  }
  if(c == (char*)0xffffffff){
    2f8a:	83 fe ff             	cmp    $0xffffffff,%esi
    2f8d:	74 2f                	je     2fbe <sbrktest+0x3ea>
    printf(stdout, "failed sbrk leaked memory\n");
    exit();
  }

  if(sbrk(0) > oldbrk)
    2f8f:	83 ec 0c             	sub    $0xc,%esp
    2f92:	6a 00                	push   $0x0
    2f94:	e8 c1 08 00 00       	call   385a <sbrk>
    2f99:	83 c4 10             	add    $0x10,%esp
    2f9c:	39 c7                	cmp    %eax,%edi
    2f9e:	72 36                	jb     2fd6 <sbrktest+0x402>
    sbrk(-(sbrk(0) - oldbrk));

  printf(stdout, "sbrk test OK\n");
    2fa0:	83 ec 08             	sub    $0x8,%esp
    2fa3:	68 70 4a 00 00       	push   $0x4a70
    2fa8:	ff 35 08 5c 00 00    	pushl  0x5c08
    2fae:	e8 68 09 00 00       	call   391b <printf>
}
    2fb3:	83 c4 10             	add    $0x10,%esp
    2fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
    2fb9:	5b                   	pop    %ebx
    2fba:	5e                   	pop    %esi
    2fbb:	5f                   	pop    %edi
    2fbc:	5d                   	pop    %ebp
    2fbd:	c3                   	ret    
    printf(stdout, "failed sbrk leaked memory\n");
    2fbe:	83 ec 08             	sub    $0x8,%esp
    2fc1:	68 55 4a 00 00       	push   $0x4a55
    2fc6:	ff 35 08 5c 00 00    	pushl  0x5c08
    2fcc:	e8 4a 09 00 00       	call   391b <printf>
    exit();
    2fd1:	e8 fc 07 00 00       	call   37d2 <exit>
    sbrk(-(sbrk(0) - oldbrk));
    2fd6:	83 ec 0c             	sub    $0xc,%esp
    2fd9:	6a 00                	push   $0x0
    2fdb:	e8 7a 08 00 00       	call   385a <sbrk>
    2fe0:	29 c7                	sub    %eax,%edi
    2fe2:	89 3c 24             	mov    %edi,(%esp)
    2fe5:	e8 70 08 00 00       	call   385a <sbrk>
    2fea:	83 c4 10             	add    $0x10,%esp
    2fed:	eb b1                	jmp    2fa0 <sbrktest+0x3cc>

00002fef <validateint>:

void
validateint(int *p)
{
    2fef:	f3 0f 1e fb          	endbr32 
      "int %2\n\t"
      "mov %%ebx, %%esp" :
      "=a" (res) :
      "a" (SYS_sleep), "n" (T_SYSCALL), "c" (p) :
      "ebx");
}
    2ff3:	c3                   	ret    

00002ff4 <validatetest>:

void
validatetest(void)
{
    2ff4:	f3 0f 1e fb          	endbr32 
    2ff8:	55                   	push   %ebp
    2ff9:	89 e5                	mov    %esp,%ebp
    2ffb:	56                   	push   %esi
    2ffc:	53                   	push   %ebx
  int hi, pid;
  uint p;

  printf(stdout, "validate test\n");
    2ffd:	83 ec 08             	sub    $0x8,%esp
    3000:	68 7e 4a 00 00       	push   $0x4a7e
    3005:	ff 35 08 5c 00 00    	pushl  0x5c08
    300b:	e8 0b 09 00 00       	call   391b <printf>
  hi = 1100*1024;

  for(p = 0; p <= (uint)hi; p += 4096){
    3010:	83 c4 10             	add    $0x10,%esp
    3013:	be 00 00 00 00       	mov    $0x0,%esi
    3018:	eb 0b                	jmp    3025 <validatetest+0x31>
    if((pid = fork()) == 0){
      // try to crash the kernel by passing in a badly placed integer
      validateint((int*)p);
      exit();
    301a:	e8 b3 07 00 00       	call   37d2 <exit>
  for(p = 0; p <= (uint)hi; p += 4096){
    301f:	81 c6 00 10 00 00    	add    $0x1000,%esi
    3025:	81 fe 00 30 11 00    	cmp    $0x113000,%esi
    302b:	77 5c                	ja     3089 <validatetest+0x95>
    if((pid = fork()) == 0){
    302d:	e8 98 07 00 00       	call   37ca <fork>
    3032:	89 c3                	mov    %eax,%ebx
    3034:	85 c0                	test   %eax,%eax
    3036:	74 e2                	je     301a <validatetest+0x26>
    }
    sleep(0);
    3038:	83 ec 0c             	sub    $0xc,%esp
    303b:	6a 00                	push   $0x0
    303d:	e8 20 08 00 00       	call   3862 <sleep>
    sleep(0);
    3042:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
    3049:	e8 14 08 00 00       	call   3862 <sleep>
    kill(pid);
    304e:	89 1c 24             	mov    %ebx,(%esp)
    3051:	e8 ac 07 00 00       	call   3802 <kill>
    wait();
    3056:	e8 7f 07 00 00       	call   37da <wait>

    // try to crash the kernel by passing in a bad string pointer
    if(link("nosuchfile", (char*)p) != -1){
    305b:	83 c4 08             	add    $0x8,%esp
    305e:	56                   	push   %esi
    305f:	68 8d 4a 00 00       	push   $0x4a8d
    3064:	e8 c9 07 00 00       	call   3832 <link>
    3069:	83 c4 10             	add    $0x10,%esp
    306c:	83 f8 ff             	cmp    $0xffffffff,%eax
    306f:	74 ae                	je     301f <validatetest+0x2b>
      printf(stdout, "link should not succeed\n");
    3071:	83 ec 08             	sub    $0x8,%esp
    3074:	68 98 4a 00 00       	push   $0x4a98
    3079:	ff 35 08 5c 00 00    	pushl  0x5c08
    307f:	e8 97 08 00 00       	call   391b <printf>
      exit();
    3084:	e8 49 07 00 00       	call   37d2 <exit>
    }
  }

  printf(stdout, "validate ok\n");
    3089:	83 ec 08             	sub    $0x8,%esp
    308c:	68 b1 4a 00 00       	push   $0x4ab1
    3091:	ff 35 08 5c 00 00    	pushl  0x5c08
    3097:	e8 7f 08 00 00       	call   391b <printf>
}
    309c:	83 c4 10             	add    $0x10,%esp
    309f:	8d 65 f8             	lea    -0x8(%ebp),%esp
    30a2:	5b                   	pop    %ebx
    30a3:	5e                   	pop    %esi
    30a4:	5d                   	pop    %ebp
    30a5:	c3                   	ret    

000030a6 <bsstest>:

// does unintialized data start out zero?
char uninit[10000];
void
bsstest(void)
{
    30a6:	f3 0f 1e fb          	endbr32 
    30aa:	55                   	push   %ebp
    30ab:	89 e5                	mov    %esp,%ebp
    30ad:	83 ec 10             	sub    $0x10,%esp
  int i;

  printf(stdout, "bss test\n");
    30b0:	68 be 4a 00 00       	push   $0x4abe
    30b5:	ff 35 08 5c 00 00    	pushl  0x5c08
    30bb:	e8 5b 08 00 00       	call   391b <printf>
  for(i = 0; i < sizeof(uninit); i++){
    30c0:	83 c4 10             	add    $0x10,%esp
    30c3:	b8 00 00 00 00       	mov    $0x0,%eax
    30c8:	3d 0f 27 00 00       	cmp    $0x270f,%eax
    30cd:	77 26                	ja     30f5 <bsstest+0x4f>
    if(uninit[i] != '\0'){
    30cf:	80 b8 c0 5c 00 00 00 	cmpb   $0x0,0x5cc0(%eax)
    30d6:	75 05                	jne    30dd <bsstest+0x37>
  for(i = 0; i < sizeof(uninit); i++){
    30d8:	83 c0 01             	add    $0x1,%eax
    30db:	eb eb                	jmp    30c8 <bsstest+0x22>
      printf(stdout, "bss test failed\n");
    30dd:	83 ec 08             	sub    $0x8,%esp
    30e0:	68 c8 4a 00 00       	push   $0x4ac8
    30e5:	ff 35 08 5c 00 00    	pushl  0x5c08
    30eb:	e8 2b 08 00 00       	call   391b <printf>
      exit();
    30f0:	e8 dd 06 00 00       	call   37d2 <exit>
    }
  }
  printf(stdout, "bss test ok\n");
    30f5:	83 ec 08             	sub    $0x8,%esp
    30f8:	68 d9 4a 00 00       	push   $0x4ad9
    30fd:	ff 35 08 5c 00 00    	pushl  0x5c08
    3103:	e8 13 08 00 00       	call   391b <printf>
}
    3108:	83 c4 10             	add    $0x10,%esp
    310b:	c9                   	leave  
    310c:	c3                   	ret    

0000310d <bigargtest>:
// does exec return an error if the arguments
// are larger than a page? or does it write
// below the stack and wreck the instructions/data?
void
bigargtest(void)
{
    310d:	f3 0f 1e fb          	endbr32 
    3111:	55                   	push   %ebp
    3112:	89 e5                	mov    %esp,%ebp
    3114:	83 ec 14             	sub    $0x14,%esp
  int pid, fd;

  unlink("bigarg-ok");
    3117:	68 e6 4a 00 00       	push   $0x4ae6
    311c:	e8 01 07 00 00       	call   3822 <unlink>
  pid = fork();
    3121:	e8 a4 06 00 00       	call   37ca <fork>
  if(pid == 0){
    3126:	83 c4 10             	add    $0x10,%esp
    3129:	85 c0                	test   %eax,%eax
    312b:	74 4d                	je     317a <bigargtest+0x6d>
    exec("echo", args);
    printf(stdout, "bigarg test ok\n");
    fd = open("bigarg-ok", O_CREATE);
    close(fd);
    exit();
  } else if(pid < 0){
    312d:	0f 88 ad 00 00 00    	js     31e0 <bigargtest+0xd3>
    printf(stdout, "bigargtest: fork failed\n");
    exit();
  }
  wait();
    3133:	e8 a2 06 00 00       	call   37da <wait>
  fd = open("bigarg-ok", 0);
    3138:	83 ec 08             	sub    $0x8,%esp
    313b:	6a 00                	push   $0x0
    313d:	68 e6 4a 00 00       	push   $0x4ae6
    3142:	e8 cb 06 00 00       	call   3812 <open>
  if(fd < 0){
    3147:	83 c4 10             	add    $0x10,%esp
    314a:	85 c0                	test   %eax,%eax
    314c:	0f 88 a6 00 00 00    	js     31f8 <bigargtest+0xeb>
    printf(stdout, "bigarg test failed!\n");
    exit();
  }
  close(fd);
    3152:	83 ec 0c             	sub    $0xc,%esp
    3155:	50                   	push   %eax
    3156:	e8 9f 06 00 00       	call   37fa <close>
  unlink("bigarg-ok");
    315b:	c7 04 24 e6 4a 00 00 	movl   $0x4ae6,(%esp)
    3162:	e8 bb 06 00 00       	call   3822 <unlink>
}
    3167:	83 c4 10             	add    $0x10,%esp
    316a:	c9                   	leave  
    316b:	c3                   	ret    
      args[i] = "bigargs test: failed\n                                                                                                                                                                                                       ";
    316c:	c7 04 85 20 5c 00 00 	movl   $0x5240,0x5c20(,%eax,4)
    3173:	40 52 00 00 
    for(i = 0; i < MAXARG-1; i++)
    3177:	83 c0 01             	add    $0x1,%eax
    317a:	83 f8 1e             	cmp    $0x1e,%eax
    317d:	7e ed                	jle    316c <bigargtest+0x5f>
    args[MAXARG-1] = 0;
    317f:	c7 05 9c 5c 00 00 00 	movl   $0x0,0x5c9c
    3186:	00 00 00 
    printf(stdout, "bigarg test\n");
    3189:	83 ec 08             	sub    $0x8,%esp
    318c:	68 f0 4a 00 00       	push   $0x4af0
    3191:	ff 35 08 5c 00 00    	pushl  0x5c08
    3197:	e8 7f 07 00 00       	call   391b <printf>
    exec("echo", args);
    319c:	83 c4 08             	add    $0x8,%esp
    319f:	68 20 5c 00 00       	push   $0x5c20
    31a4:	68 bd 3c 00 00       	push   $0x3cbd
    31a9:	e8 5c 06 00 00       	call   380a <exec>
    printf(stdout, "bigarg test ok\n");
    31ae:	83 c4 08             	add    $0x8,%esp
    31b1:	68 fd 4a 00 00       	push   $0x4afd
    31b6:	ff 35 08 5c 00 00    	pushl  0x5c08
    31bc:	e8 5a 07 00 00       	call   391b <printf>
    fd = open("bigarg-ok", O_CREATE);
    31c1:	83 c4 08             	add    $0x8,%esp
    31c4:	68 00 02 00 00       	push   $0x200
    31c9:	68 e6 4a 00 00       	push   $0x4ae6
    31ce:	e8 3f 06 00 00       	call   3812 <open>
    close(fd);
    31d3:	89 04 24             	mov    %eax,(%esp)
    31d6:	e8 1f 06 00 00       	call   37fa <close>
    exit();
    31db:	e8 f2 05 00 00       	call   37d2 <exit>
    printf(stdout, "bigargtest: fork failed\n");
    31e0:	83 ec 08             	sub    $0x8,%esp
    31e3:	68 0d 4b 00 00       	push   $0x4b0d
    31e8:	ff 35 08 5c 00 00    	pushl  0x5c08
    31ee:	e8 28 07 00 00       	call   391b <printf>
    exit();
    31f3:	e8 da 05 00 00       	call   37d2 <exit>
    printf(stdout, "bigarg test failed!\n");
    31f8:	83 ec 08             	sub    $0x8,%esp
    31fb:	68 26 4b 00 00       	push   $0x4b26
    3200:	ff 35 08 5c 00 00    	pushl  0x5c08
    3206:	e8 10 07 00 00       	call   391b <printf>
    exit();
    320b:	e8 c2 05 00 00       	call   37d2 <exit>

00003210 <fsfull>:

// what happens when the file system runs out of blocks?
// answer: balloc panics, so this test is not useful.
void
fsfull()
{
    3210:	f3 0f 1e fb          	endbr32 
    3214:	55                   	push   %ebp
    3215:	89 e5                	mov    %esp,%ebp
    3217:	57                   	push   %edi
    3218:	56                   	push   %esi
    3219:	53                   	push   %ebx
    321a:	83 ec 54             	sub    $0x54,%esp
  int nfiles;
  int fsblocks = 0;

  printf(1, "fsfull test\n");
    321d:	68 3b 4b 00 00       	push   $0x4b3b
    3222:	6a 01                	push   $0x1
    3224:	e8 f2 06 00 00       	call   391b <printf>
    3229:	83 c4 10             	add    $0x10,%esp

  for(nfiles = 0; ; nfiles++){
    322c:	bb 00 00 00 00       	mov    $0x0,%ebx
    char name[64];
    name[0] = 'f';
    3231:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    3235:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    323a:	89 d8                	mov    %ebx,%eax
    323c:	f7 ea                	imul   %edx
    323e:	c1 fa 06             	sar    $0x6,%edx
    3241:	89 df                	mov    %ebx,%edi
    3243:	c1 ff 1f             	sar    $0x1f,%edi
    3246:	29 fa                	sub    %edi,%edx
    3248:	8d 42 30             	lea    0x30(%edx),%eax
    324b:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    324e:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    3254:	89 de                	mov    %ebx,%esi
    3256:	29 d6                	sub    %edx,%esi
    3258:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    325d:	89 f0                	mov    %esi,%eax
    325f:	f7 e9                	imul   %ecx
    3261:	c1 fa 05             	sar    $0x5,%edx
    3264:	c1 fe 1f             	sar    $0x1f,%esi
    3267:	29 f2                	sub    %esi,%edx
    3269:	83 c2 30             	add    $0x30,%edx
    326c:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    326f:	89 d8                	mov    %ebx,%eax
    3271:	f7 e9                	imul   %ecx
    3273:	89 d1                	mov    %edx,%ecx
    3275:	c1 f9 05             	sar    $0x5,%ecx
    3278:	29 f9                	sub    %edi,%ecx
    327a:	6b c9 64             	imul   $0x64,%ecx,%ecx
    327d:	89 d8                	mov    %ebx,%eax
    327f:	29 c8                	sub    %ecx,%eax
    3281:	89 c1                	mov    %eax,%ecx
    3283:	be 67 66 66 66       	mov    $0x66666667,%esi
    3288:	f7 ee                	imul   %esi
    328a:	c1 fa 02             	sar    $0x2,%edx
    328d:	c1 f9 1f             	sar    $0x1f,%ecx
    3290:	29 ca                	sub    %ecx,%edx
    3292:	83 c2 30             	add    $0x30,%edx
    3295:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    3298:	89 d8                	mov    %ebx,%eax
    329a:	f7 ee                	imul   %esi
    329c:	c1 fa 02             	sar    $0x2,%edx
    329f:	29 fa                	sub    %edi,%edx
    32a1:	8d 04 92             	lea    (%edx,%edx,4),%eax
    32a4:	01 c0                	add    %eax,%eax
    32a6:	89 da                	mov    %ebx,%edx
    32a8:	29 c2                	sub    %eax,%edx
    32aa:	83 c2 30             	add    $0x30,%edx
    32ad:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    32b0:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    printf(1, "writing %s\n", name);
    32b4:	83 ec 04             	sub    $0x4,%esp
    32b7:	8d 75 a8             	lea    -0x58(%ebp),%esi
    32ba:	56                   	push   %esi
    32bb:	68 48 4b 00 00       	push   $0x4b48
    32c0:	6a 01                	push   $0x1
    32c2:	e8 54 06 00 00       	call   391b <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    32c7:	83 c4 08             	add    $0x8,%esp
    32ca:	68 02 02 00 00       	push   $0x202
    32cf:	56                   	push   %esi
    32d0:	e8 3d 05 00 00       	call   3812 <open>
    32d5:	89 c6                	mov    %eax,%esi
    if(fd < 0){
    32d7:	83 c4 10             	add    $0x10,%esp
    32da:	85 c0                	test   %eax,%eax
    32dc:	79 1b                	jns    32f9 <fsfull+0xe9>
      printf(1, "open %s failed\n", name);
    32de:	83 ec 04             	sub    $0x4,%esp
    32e1:	8d 45 a8             	lea    -0x58(%ebp),%eax
    32e4:	50                   	push   %eax
    32e5:	68 54 4b 00 00       	push   $0x4b54
    32ea:	6a 01                	push   $0x1
    32ec:	e8 2a 06 00 00       	call   391b <printf>
      break;
    32f1:	83 c4 10             	add    $0x10,%esp
    32f4:	e9 e6 00 00 00       	jmp    33df <fsfull+0x1cf>
    }
    int total = 0;
    32f9:	bf 00 00 00 00       	mov    $0x0,%edi
    while(1){
      int cc = write(fd, buf, 512);
    32fe:	83 ec 04             	sub    $0x4,%esp
    3301:	68 00 02 00 00       	push   $0x200
    3306:	68 e0 83 00 00       	push   $0x83e0
    330b:	56                   	push   %esi
    330c:	e8 e1 04 00 00       	call   37f2 <write>
      if(cc < 512)
    3311:	83 c4 10             	add    $0x10,%esp
    3314:	3d ff 01 00 00       	cmp    $0x1ff,%eax
    3319:	7e 04                	jle    331f <fsfull+0x10f>
        break;
      total += cc;
    331b:	01 c7                	add    %eax,%edi
    while(1){
    331d:	eb df                	jmp    32fe <fsfull+0xee>
      fsblocks++;
    }
    printf(1, "wrote %d bytes\n", total);
    331f:	83 ec 04             	sub    $0x4,%esp
    3322:	57                   	push   %edi
    3323:	68 64 4b 00 00       	push   $0x4b64
    3328:	6a 01                	push   $0x1
    332a:	e8 ec 05 00 00       	call   391b <printf>
    close(fd);
    332f:	89 34 24             	mov    %esi,(%esp)
    3332:	e8 c3 04 00 00       	call   37fa <close>
    if(total == 0)
    3337:	83 c4 10             	add    $0x10,%esp
    333a:	85 ff                	test   %edi,%edi
    333c:	0f 84 9d 00 00 00    	je     33df <fsfull+0x1cf>
  for(nfiles = 0; ; nfiles++){
    3342:	83 c3 01             	add    $0x1,%ebx
    3345:	e9 e7 fe ff ff       	jmp    3231 <fsfull+0x21>
      break;
  }

  while(nfiles >= 0){
    char name[64];
    name[0] = 'f';
    334a:	c6 45 a8 66          	movb   $0x66,-0x58(%ebp)
    name[1] = '0' + nfiles / 1000;
    334e:	ba d3 4d 62 10       	mov    $0x10624dd3,%edx
    3353:	89 d8                	mov    %ebx,%eax
    3355:	f7 ea                	imul   %edx
    3357:	c1 fa 06             	sar    $0x6,%edx
    335a:	89 df                	mov    %ebx,%edi
    335c:	c1 ff 1f             	sar    $0x1f,%edi
    335f:	29 fa                	sub    %edi,%edx
    3361:	8d 42 30             	lea    0x30(%edx),%eax
    3364:	88 45 a9             	mov    %al,-0x57(%ebp)
    name[2] = '0' + (nfiles % 1000) / 100;
    3367:	69 d2 e8 03 00 00    	imul   $0x3e8,%edx,%edx
    336d:	89 de                	mov    %ebx,%esi
    336f:	29 d6                	sub    %edx,%esi
    3371:	b9 1f 85 eb 51       	mov    $0x51eb851f,%ecx
    3376:	89 f0                	mov    %esi,%eax
    3378:	f7 e9                	imul   %ecx
    337a:	c1 fa 05             	sar    $0x5,%edx
    337d:	c1 fe 1f             	sar    $0x1f,%esi
    3380:	29 f2                	sub    %esi,%edx
    3382:	83 c2 30             	add    $0x30,%edx
    3385:	88 55 aa             	mov    %dl,-0x56(%ebp)
    name[3] = '0' + (nfiles % 100) / 10;
    3388:	89 d8                	mov    %ebx,%eax
    338a:	f7 e9                	imul   %ecx
    338c:	89 d1                	mov    %edx,%ecx
    338e:	c1 f9 05             	sar    $0x5,%ecx
    3391:	29 f9                	sub    %edi,%ecx
    3393:	6b c9 64             	imul   $0x64,%ecx,%ecx
    3396:	89 d8                	mov    %ebx,%eax
    3398:	29 c8                	sub    %ecx,%eax
    339a:	89 c1                	mov    %eax,%ecx
    339c:	be 67 66 66 66       	mov    $0x66666667,%esi
    33a1:	f7 ee                	imul   %esi
    33a3:	c1 fa 02             	sar    $0x2,%edx
    33a6:	c1 f9 1f             	sar    $0x1f,%ecx
    33a9:	29 ca                	sub    %ecx,%edx
    33ab:	83 c2 30             	add    $0x30,%edx
    33ae:	88 55 ab             	mov    %dl,-0x55(%ebp)
    name[4] = '0' + (nfiles % 10);
    33b1:	89 d8                	mov    %ebx,%eax
    33b3:	f7 ee                	imul   %esi
    33b5:	c1 fa 02             	sar    $0x2,%edx
    33b8:	29 fa                	sub    %edi,%edx
    33ba:	8d 04 92             	lea    (%edx,%edx,4),%eax
    33bd:	01 c0                	add    %eax,%eax
    33bf:	89 da                	mov    %ebx,%edx
    33c1:	29 c2                	sub    %eax,%edx
    33c3:	83 c2 30             	add    $0x30,%edx
    33c6:	88 55 ac             	mov    %dl,-0x54(%ebp)
    name[5] = '\0';
    33c9:	c6 45 ad 00          	movb   $0x0,-0x53(%ebp)
    unlink(name);
    33cd:	83 ec 0c             	sub    $0xc,%esp
    33d0:	8d 45 a8             	lea    -0x58(%ebp),%eax
    33d3:	50                   	push   %eax
    33d4:	e8 49 04 00 00       	call   3822 <unlink>
    nfiles--;
    33d9:	83 eb 01             	sub    $0x1,%ebx
    33dc:	83 c4 10             	add    $0x10,%esp
  while(nfiles >= 0){
    33df:	85 db                	test   %ebx,%ebx
    33e1:	0f 89 63 ff ff ff    	jns    334a <fsfull+0x13a>
  }

  printf(1, "fsfull test finished\n");
    33e7:	83 ec 08             	sub    $0x8,%esp
    33ea:	68 74 4b 00 00       	push   $0x4b74
    33ef:	6a 01                	push   $0x1
    33f1:	e8 25 05 00 00       	call   391b <printf>
}
    33f6:	83 c4 10             	add    $0x10,%esp
    33f9:	8d 65 f4             	lea    -0xc(%ebp),%esp
    33fc:	5b                   	pop    %ebx
    33fd:	5e                   	pop    %esi
    33fe:	5f                   	pop    %edi
    33ff:	5d                   	pop    %ebp
    3400:	c3                   	ret    

00003401 <uio>:

void
uio()
{
    3401:	f3 0f 1e fb          	endbr32 
    3405:	55                   	push   %ebp
    3406:	89 e5                	mov    %esp,%ebp
    3408:	83 ec 10             	sub    $0x10,%esp

  ushort port = 0;
  uchar val = 0;
  int pid;

  printf(1, "uio test\n");
    340b:	68 8a 4b 00 00       	push   $0x4b8a
    3410:	6a 01                	push   $0x1
    3412:	e8 04 05 00 00       	call   391b <printf>
  pid = fork();
    3417:	e8 ae 03 00 00       	call   37ca <fork>
  if(pid == 0){
    341c:	83 c4 10             	add    $0x10,%esp
    341f:	85 c0                	test   %eax,%eax
    3421:	74 1b                	je     343e <uio+0x3d>
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    port = RTC_DATA;
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    printf(1, "uio: uio succeeded; test FAILED\n");
    exit();
  } else if(pid < 0){
    3423:	78 3e                	js     3463 <uio+0x62>
    printf (1, "fork failed\n");
    exit();
  }
  wait();
    3425:	e8 b0 03 00 00       	call   37da <wait>
  printf(1, "uio test done\n");
    342a:	83 ec 08             	sub    $0x8,%esp
    342d:	68 94 4b 00 00       	push   $0x4b94
    3432:	6a 01                	push   $0x1
    3434:	e8 e2 04 00 00       	call   391b <printf>
}
    3439:	83 c4 10             	add    $0x10,%esp
    343c:	c9                   	leave  
    343d:	c3                   	ret    
    asm volatile("outb %0,%1"::"a"(val), "d" (port));
    343e:	b8 09 00 00 00       	mov    $0x9,%eax
    3443:	ba 70 00 00 00       	mov    $0x70,%edx
    3448:	ee                   	out    %al,(%dx)
    asm volatile("inb %1,%0" : "=a" (val) : "d" (port));
    3449:	ba 71 00 00 00       	mov    $0x71,%edx
    344e:	ec                   	in     (%dx),%al
    printf(1, "uio: uio succeeded; test FAILED\n");
    344f:	83 ec 08             	sub    $0x8,%esp
    3452:	68 20 53 00 00       	push   $0x5320
    3457:	6a 01                	push   $0x1
    3459:	e8 bd 04 00 00       	call   391b <printf>
    exit();
    345e:	e8 6f 03 00 00       	call   37d2 <exit>
    printf (1, "fork failed\n");
    3463:	83 ec 08             	sub    $0x8,%esp
    3466:	68 19 4b 00 00       	push   $0x4b19
    346b:	6a 01                	push   $0x1
    346d:	e8 a9 04 00 00       	call   391b <printf>
    exit();
    3472:	e8 5b 03 00 00       	call   37d2 <exit>

00003477 <argptest>:

void argptest()
{
    3477:	f3 0f 1e fb          	endbr32 
    347b:	55                   	push   %ebp
    347c:	89 e5                	mov    %esp,%ebp
    347e:	53                   	push   %ebx
    347f:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  fd = open("init", O_RDONLY);
    3482:	6a 00                	push   $0x0
    3484:	68 a3 4b 00 00       	push   $0x4ba3
    3489:	e8 84 03 00 00       	call   3812 <open>
  if (fd < 0) {
    348e:	83 c4 10             	add    $0x10,%esp
    3491:	85 c0                	test   %eax,%eax
    3493:	78 3a                	js     34cf <argptest+0x58>
    3495:	89 c3                	mov    %eax,%ebx
    printf(2, "open failed\n");
    exit();
  }
  read(fd, sbrk(0) - 1, -1);
    3497:	83 ec 0c             	sub    $0xc,%esp
    349a:	6a 00                	push   $0x0
    349c:	e8 b9 03 00 00       	call   385a <sbrk>
    34a1:	83 e8 01             	sub    $0x1,%eax
    34a4:	83 c4 0c             	add    $0xc,%esp
    34a7:	6a ff                	push   $0xffffffff
    34a9:	50                   	push   %eax
    34aa:	53                   	push   %ebx
    34ab:	e8 3a 03 00 00       	call   37ea <read>
  close(fd);
    34b0:	89 1c 24             	mov    %ebx,(%esp)
    34b3:	e8 42 03 00 00       	call   37fa <close>
  printf(1, "arg test passed\n");
    34b8:	83 c4 08             	add    $0x8,%esp
    34bb:	68 b5 4b 00 00       	push   $0x4bb5
    34c0:	6a 01                	push   $0x1
    34c2:	e8 54 04 00 00       	call   391b <printf>
}
    34c7:	83 c4 10             	add    $0x10,%esp
    34ca:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    34cd:	c9                   	leave  
    34ce:	c3                   	ret    
    printf(2, "open failed\n");
    34cf:	83 ec 08             	sub    $0x8,%esp
    34d2:	68 a8 4b 00 00       	push   $0x4ba8
    34d7:	6a 02                	push   $0x2
    34d9:	e8 3d 04 00 00       	call   391b <printf>
    exit();
    34de:	e8 ef 02 00 00       	call   37d2 <exit>

000034e3 <rand>:

unsigned long randstate = 1;
unsigned int
rand()
{
    34e3:	f3 0f 1e fb          	endbr32 
  randstate = randstate * 1664525 + 1013904223;
    34e7:	69 05 04 5c 00 00 0d 	imul   $0x19660d,0x5c04,%eax
    34ee:	66 19 00 
    34f1:	05 5f f3 6e 3c       	add    $0x3c6ef35f,%eax
    34f6:	a3 04 5c 00 00       	mov    %eax,0x5c04
  return randstate;
}
    34fb:	c3                   	ret    

000034fc <main>:

int
main(int argc, char *argv[])
{
    34fc:	f3 0f 1e fb          	endbr32 
    3500:	8d 4c 24 04          	lea    0x4(%esp),%ecx
    3504:	83 e4 f0             	and    $0xfffffff0,%esp
    3507:	ff 71 fc             	pushl  -0x4(%ecx)
    350a:	55                   	push   %ebp
    350b:	89 e5                	mov    %esp,%ebp
    350d:	51                   	push   %ecx
    350e:	83 ec 0c             	sub    $0xc,%esp
  printf(1, "usertests starting\n");
    3511:	68 c6 4b 00 00       	push   $0x4bc6
    3516:	6a 01                	push   $0x1
    3518:	e8 fe 03 00 00       	call   391b <printf>

  if(open("usertests.ran", 0) >= 0){
    351d:	83 c4 08             	add    $0x8,%esp
    3520:	6a 00                	push   $0x0
    3522:	68 da 4b 00 00       	push   $0x4bda
    3527:	e8 e6 02 00 00       	call   3812 <open>
    352c:	83 c4 10             	add    $0x10,%esp
    352f:	85 c0                	test   %eax,%eax
    3531:	78 14                	js     3547 <main+0x4b>
    printf(1, "already ran user tests -- rebuild fs.img\n");
    3533:	83 ec 08             	sub    $0x8,%esp
    3536:	68 44 53 00 00       	push   $0x5344
    353b:	6a 01                	push   $0x1
    353d:	e8 d9 03 00 00       	call   391b <printf>
    exit();
    3542:	e8 8b 02 00 00       	call   37d2 <exit>
  }
  close(open("usertests.ran", O_CREATE));
    3547:	83 ec 08             	sub    $0x8,%esp
    354a:	68 00 02 00 00       	push   $0x200
    354f:	68 da 4b 00 00       	push   $0x4bda
    3554:	e8 b9 02 00 00       	call   3812 <open>
    3559:	89 04 24             	mov    %eax,(%esp)
    355c:	e8 99 02 00 00       	call   37fa <close>

  argptest();
    3561:	e8 11 ff ff ff       	call   3477 <argptest>
  createdelete();
    3566:	e8 de da ff ff       	call   1049 <createdelete>
  linkunlink();
    356b:	e8 8b e3 ff ff       	call   18fb <linkunlink>
  concreate();
    3570:	e8 94 e0 ff ff       	call   1609 <concreate>
  fourfiles();
    3575:	e8 e8 d8 ff ff       	call   e62 <fourfiles>
  sharedfd();
    357a:	e8 42 d7 ff ff       	call   cc1 <sharedfd>

  bigargtest();
    357f:	e8 89 fb ff ff       	call   310d <bigargtest>
  bigwrite();
    3584:	e8 f4 ec ff ff       	call   227d <bigwrite>
  bigargtest();
    3589:	e8 7f fb ff ff       	call   310d <bigargtest>
  bsstest();
    358e:	e8 13 fb ff ff       	call   30a6 <bsstest>
  sbrktest();
    3593:	e8 3c f6 ff ff       	call   2bd4 <sbrktest>
  validatetest();
    3598:	e8 57 fa ff ff       	call   2ff4 <validatetest>

  opentest();
    359d:	e8 16 cd ff ff       	call   2b8 <opentest>
  writetest();
    35a2:	e8 a8 cd ff ff       	call   34f <writetest>
  writetest1();
    35a7:	e8 6f cf ff ff       	call   51b <writetest1>
  createtest();
    35ac:	e8 1e d1 ff ff       	call   6cf <createtest>

  openiputtest();
    35b1:	e8 15 cc ff ff       	call   1cb <openiputtest>
  exitiputtest();
    35b6:	e8 26 cb ff ff       	call   e1 <exitiputtest>
  iputtest();
    35bb:	e8 40 ca ff ff       	call   0 <iputtest>

  mem();
    35c0:	e8 3f d6 ff ff       	call   c04 <mem>
  pipe1();
    35c5:	e8 e3 d2 ff ff       	call   8ad <pipe1>
  preempt();
    35ca:	e8 82 d4 ff ff       	call   a51 <preempt>
  exitwait();
    35cf:	e8 bc d5 ff ff       	call   b90 <exitwait>

  rmdot();
    35d4:	e8 75 f0 ff ff       	call   264e <rmdot>
  fourteen();
    35d9:	e8 2f ef ff ff       	call   250d <fourteen>
  bigfile();
    35de:	e8 70 ed ff ff       	call   2353 <bigfile>
  subdir();
    35e3:	e8 63 e5 ff ff       	call   1b4b <subdir>
  linktest();
    35e8:	e8 f2 dd ff ff       	call   13df <linktest>
  unlinkread();
    35ed:	e8 50 dc ff ff       	call   1242 <unlinkread>
  dirfile();
    35f2:	e8 e0 f1 ff ff       	call   27d7 <dirfile>
  iref();
    35f7:	e8 f9 f3 ff ff       	call   29f5 <iref>
  forktest();
    35fc:	e8 20 f5 ff ff       	call   2b21 <forktest>
  bigdir(); // slow
    3601:	e8 ed e3 ff ff       	call   19f3 <bigdir>

  uio();
    3606:	e8 f6 fd ff ff       	call   3401 <uio>

  exectest();
    360b:	e8 50 d2 ff ff       	call   860 <exectest>

  exit();
    3610:	e8 bd 01 00 00       	call   37d2 <exit>

00003615 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
    3615:	f3 0f 1e fb          	endbr32 
    3619:	55                   	push   %ebp
    361a:	89 e5                	mov    %esp,%ebp
    361c:	56                   	push   %esi
    361d:	53                   	push   %ebx
    361e:	8b 75 08             	mov    0x8(%ebp),%esi
    3621:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    3624:	89 f0                	mov    %esi,%eax
    3626:	89 d1                	mov    %edx,%ecx
    3628:	83 c2 01             	add    $0x1,%edx
    362b:	89 c3                	mov    %eax,%ebx
    362d:	83 c0 01             	add    $0x1,%eax
    3630:	0f b6 09             	movzbl (%ecx),%ecx
    3633:	88 0b                	mov    %cl,(%ebx)
    3635:	84 c9                	test   %cl,%cl
    3637:	75 ed                	jne    3626 <strcpy+0x11>
    ;
  return os;
}
    3639:	89 f0                	mov    %esi,%eax
    363b:	5b                   	pop    %ebx
    363c:	5e                   	pop    %esi
    363d:	5d                   	pop    %ebp
    363e:	c3                   	ret    

0000363f <strcmp>:

int
strcmp(const char *p, const char *q)
{
    363f:	f3 0f 1e fb          	endbr32 
    3643:	55                   	push   %ebp
    3644:	89 e5                	mov    %esp,%ebp
    3646:	8b 4d 08             	mov    0x8(%ebp),%ecx
    3649:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
    364c:	0f b6 01             	movzbl (%ecx),%eax
    364f:	84 c0                	test   %al,%al
    3651:	74 0c                	je     365f <strcmp+0x20>
    3653:	3a 02                	cmp    (%edx),%al
    3655:	75 08                	jne    365f <strcmp+0x20>
    p++, q++;
    3657:	83 c1 01             	add    $0x1,%ecx
    365a:	83 c2 01             	add    $0x1,%edx
    365d:	eb ed                	jmp    364c <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
    365f:	0f b6 c0             	movzbl %al,%eax
    3662:	0f b6 12             	movzbl (%edx),%edx
    3665:	29 d0                	sub    %edx,%eax
}
    3667:	5d                   	pop    %ebp
    3668:	c3                   	ret    

00003669 <strlen>:

int
strlen(const char *s)
{
    3669:	f3 0f 1e fb          	endbr32 
    366d:	55                   	push   %ebp
    366e:	89 e5                	mov    %esp,%ebp
    3670:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
    3673:	b8 00 00 00 00       	mov    $0x0,%eax
    3678:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
    367c:	74 05                	je     3683 <strlen+0x1a>
    367e:	83 c0 01             	add    $0x1,%eax
    3681:	eb f5                	jmp    3678 <strlen+0xf>
    ;
  return n;
}
    3683:	5d                   	pop    %ebp
    3684:	c3                   	ret    

00003685 <memset>:

void*
memset(void *dst, int c, int n)
{
    3685:	f3 0f 1e fb          	endbr32 
    3689:	55                   	push   %ebp
    368a:	89 e5                	mov    %esp,%ebp
    368c:	57                   	push   %edi
    368d:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
    3690:	89 d7                	mov    %edx,%edi
    3692:	8b 4d 10             	mov    0x10(%ebp),%ecx
    3695:	8b 45 0c             	mov    0xc(%ebp),%eax
    3698:	fc                   	cld    
    3699:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
    369b:	89 d0                	mov    %edx,%eax
    369d:	5f                   	pop    %edi
    369e:	5d                   	pop    %ebp
    369f:	c3                   	ret    

000036a0 <strchr>:

char*
strchr(const char *s, char c)
{
    36a0:	f3 0f 1e fb          	endbr32 
    36a4:	55                   	push   %ebp
    36a5:	89 e5                	mov    %esp,%ebp
    36a7:	8b 45 08             	mov    0x8(%ebp),%eax
    36aa:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
    36ae:	0f b6 10             	movzbl (%eax),%edx
    36b1:	84 d2                	test   %dl,%dl
    36b3:	74 09                	je     36be <strchr+0x1e>
    if(*s == c)
    36b5:	38 ca                	cmp    %cl,%dl
    36b7:	74 0a                	je     36c3 <strchr+0x23>
  for(; *s; s++)
    36b9:	83 c0 01             	add    $0x1,%eax
    36bc:	eb f0                	jmp    36ae <strchr+0xe>
      return (char*)s;
  return 0;
    36be:	b8 00 00 00 00       	mov    $0x0,%eax
}
    36c3:	5d                   	pop    %ebp
    36c4:	c3                   	ret    

000036c5 <gets>:

char*
gets(char *buf, int max)
{
    36c5:	f3 0f 1e fb          	endbr32 
    36c9:	55                   	push   %ebp
    36ca:	89 e5                	mov    %esp,%ebp
    36cc:	57                   	push   %edi
    36cd:	56                   	push   %esi
    36ce:	53                   	push   %ebx
    36cf:	83 ec 1c             	sub    $0x1c,%esp
    36d2:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    36d5:	bb 00 00 00 00       	mov    $0x0,%ebx
    36da:	89 de                	mov    %ebx,%esi
    36dc:	83 c3 01             	add    $0x1,%ebx
    36df:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
    36e2:	7d 2e                	jge    3712 <gets+0x4d>
    cc = read(0, &c, 1);
    36e4:	83 ec 04             	sub    $0x4,%esp
    36e7:	6a 01                	push   $0x1
    36e9:	8d 45 e7             	lea    -0x19(%ebp),%eax
    36ec:	50                   	push   %eax
    36ed:	6a 00                	push   $0x0
    36ef:	e8 f6 00 00 00       	call   37ea <read>
    if(cc < 1)
    36f4:	83 c4 10             	add    $0x10,%esp
    36f7:	85 c0                	test   %eax,%eax
    36f9:	7e 17                	jle    3712 <gets+0x4d>
      break;
    buf[i++] = c;
    36fb:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
    36ff:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
    3702:	3c 0a                	cmp    $0xa,%al
    3704:	0f 94 c2             	sete   %dl
    3707:	3c 0d                	cmp    $0xd,%al
    3709:	0f 94 c0             	sete   %al
    370c:	08 c2                	or     %al,%dl
    370e:	74 ca                	je     36da <gets+0x15>
    buf[i++] = c;
    3710:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
    3712:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
    3716:	89 f8                	mov    %edi,%eax
    3718:	8d 65 f4             	lea    -0xc(%ebp),%esp
    371b:	5b                   	pop    %ebx
    371c:	5e                   	pop    %esi
    371d:	5f                   	pop    %edi
    371e:	5d                   	pop    %ebp
    371f:	c3                   	ret    

00003720 <stat>:

int
stat(const char *n, struct stat *st)
{
    3720:	f3 0f 1e fb          	endbr32 
    3724:	55                   	push   %ebp
    3725:	89 e5                	mov    %esp,%ebp
    3727:	56                   	push   %esi
    3728:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    3729:	83 ec 08             	sub    $0x8,%esp
    372c:	6a 00                	push   $0x0
    372e:	ff 75 08             	pushl  0x8(%ebp)
    3731:	e8 dc 00 00 00       	call   3812 <open>
  if(fd < 0)
    3736:	83 c4 10             	add    $0x10,%esp
    3739:	85 c0                	test   %eax,%eax
    373b:	78 24                	js     3761 <stat+0x41>
    373d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
    373f:	83 ec 08             	sub    $0x8,%esp
    3742:	ff 75 0c             	pushl  0xc(%ebp)
    3745:	50                   	push   %eax
    3746:	e8 df 00 00 00       	call   382a <fstat>
    374b:	89 c6                	mov    %eax,%esi
  close(fd);
    374d:	89 1c 24             	mov    %ebx,(%esp)
    3750:	e8 a5 00 00 00       	call   37fa <close>
  return r;
    3755:	83 c4 10             	add    $0x10,%esp
}
    3758:	89 f0                	mov    %esi,%eax
    375a:	8d 65 f8             	lea    -0x8(%ebp),%esp
    375d:	5b                   	pop    %ebx
    375e:	5e                   	pop    %esi
    375f:	5d                   	pop    %ebp
    3760:	c3                   	ret    
    return -1;
    3761:	be ff ff ff ff       	mov    $0xffffffff,%esi
    3766:	eb f0                	jmp    3758 <stat+0x38>

00003768 <atoi>:

int
atoi(const char *s)
{
    3768:	f3 0f 1e fb          	endbr32 
    376c:	55                   	push   %ebp
    376d:	89 e5                	mov    %esp,%ebp
    376f:	53                   	push   %ebx
    3770:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
    3773:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
    3778:	0f b6 01             	movzbl (%ecx),%eax
    377b:	8d 58 d0             	lea    -0x30(%eax),%ebx
    377e:	80 fb 09             	cmp    $0x9,%bl
    3781:	77 12                	ja     3795 <atoi+0x2d>
    n = n*10 + *s++ - '0';
    3783:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
    3786:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
    3789:	83 c1 01             	add    $0x1,%ecx
    378c:	0f be c0             	movsbl %al,%eax
    378f:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
    3793:	eb e3                	jmp    3778 <atoi+0x10>
  return n;
}
    3795:	89 d0                	mov    %edx,%eax
    3797:	5b                   	pop    %ebx
    3798:	5d                   	pop    %ebp
    3799:	c3                   	ret    

0000379a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    379a:	f3 0f 1e fb          	endbr32 
    379e:	55                   	push   %ebp
    379f:	89 e5                	mov    %esp,%ebp
    37a1:	56                   	push   %esi
    37a2:	53                   	push   %ebx
    37a3:	8b 75 08             	mov    0x8(%ebp),%esi
    37a6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
    37a9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
    37ac:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
    37ae:	8d 58 ff             	lea    -0x1(%eax),%ebx
    37b1:	85 c0                	test   %eax,%eax
    37b3:	7e 0f                	jle    37c4 <memmove+0x2a>
    *dst++ = *src++;
    37b5:	0f b6 01             	movzbl (%ecx),%eax
    37b8:	88 02                	mov    %al,(%edx)
    37ba:	8d 49 01             	lea    0x1(%ecx),%ecx
    37bd:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
    37c0:	89 d8                	mov    %ebx,%eax
    37c2:	eb ea                	jmp    37ae <memmove+0x14>
  return vdst;
}
    37c4:	89 f0                	mov    %esi,%eax
    37c6:	5b                   	pop    %ebx
    37c7:	5e                   	pop    %esi
    37c8:	5d                   	pop    %ebp
    37c9:	c3                   	ret    

000037ca <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
    37ca:	b8 01 00 00 00       	mov    $0x1,%eax
    37cf:	cd 40                	int    $0x40
    37d1:	c3                   	ret    

000037d2 <exit>:
SYSCALL(exit)
    37d2:	b8 02 00 00 00       	mov    $0x2,%eax
    37d7:	cd 40                	int    $0x40
    37d9:	c3                   	ret    

000037da <wait>:
SYSCALL(wait)
    37da:	b8 03 00 00 00       	mov    $0x3,%eax
    37df:	cd 40                	int    $0x40
    37e1:	c3                   	ret    

000037e2 <pipe>:
SYSCALL(pipe)
    37e2:	b8 04 00 00 00       	mov    $0x4,%eax
    37e7:	cd 40                	int    $0x40
    37e9:	c3                   	ret    

000037ea <read>:
SYSCALL(read)
    37ea:	b8 05 00 00 00       	mov    $0x5,%eax
    37ef:	cd 40                	int    $0x40
    37f1:	c3                   	ret    

000037f2 <write>:
SYSCALL(write)
    37f2:	b8 10 00 00 00       	mov    $0x10,%eax
    37f7:	cd 40                	int    $0x40
    37f9:	c3                   	ret    

000037fa <close>:
SYSCALL(close)
    37fa:	b8 15 00 00 00       	mov    $0x15,%eax
    37ff:	cd 40                	int    $0x40
    3801:	c3                   	ret    

00003802 <kill>:
SYSCALL(kill)
    3802:	b8 06 00 00 00       	mov    $0x6,%eax
    3807:	cd 40                	int    $0x40
    3809:	c3                   	ret    

0000380a <exec>:
SYSCALL(exec)
    380a:	b8 07 00 00 00       	mov    $0x7,%eax
    380f:	cd 40                	int    $0x40
    3811:	c3                   	ret    

00003812 <open>:
SYSCALL(open)
    3812:	b8 0f 00 00 00       	mov    $0xf,%eax
    3817:	cd 40                	int    $0x40
    3819:	c3                   	ret    

0000381a <mknod>:
SYSCALL(mknod)
    381a:	b8 11 00 00 00       	mov    $0x11,%eax
    381f:	cd 40                	int    $0x40
    3821:	c3                   	ret    

00003822 <unlink>:
SYSCALL(unlink)
    3822:	b8 12 00 00 00       	mov    $0x12,%eax
    3827:	cd 40                	int    $0x40
    3829:	c3                   	ret    

0000382a <fstat>:
SYSCALL(fstat)
    382a:	b8 08 00 00 00       	mov    $0x8,%eax
    382f:	cd 40                	int    $0x40
    3831:	c3                   	ret    

00003832 <link>:
SYSCALL(link)
    3832:	b8 13 00 00 00       	mov    $0x13,%eax
    3837:	cd 40                	int    $0x40
    3839:	c3                   	ret    

0000383a <mkdir>:
SYSCALL(mkdir)
    383a:	b8 14 00 00 00       	mov    $0x14,%eax
    383f:	cd 40                	int    $0x40
    3841:	c3                   	ret    

00003842 <chdir>:
SYSCALL(chdir)
    3842:	b8 09 00 00 00       	mov    $0x9,%eax
    3847:	cd 40                	int    $0x40
    3849:	c3                   	ret    

0000384a <dup>:
SYSCALL(dup)
    384a:	b8 0a 00 00 00       	mov    $0xa,%eax
    384f:	cd 40                	int    $0x40
    3851:	c3                   	ret    

00003852 <getpid>:
SYSCALL(getpid)
    3852:	b8 0b 00 00 00       	mov    $0xb,%eax
    3857:	cd 40                	int    $0x40
    3859:	c3                   	ret    

0000385a <sbrk>:
SYSCALL(sbrk)
    385a:	b8 0c 00 00 00       	mov    $0xc,%eax
    385f:	cd 40                	int    $0x40
    3861:	c3                   	ret    

00003862 <sleep>:
SYSCALL(sleep)
    3862:	b8 0d 00 00 00       	mov    $0xd,%eax
    3867:	cd 40                	int    $0x40
    3869:	c3                   	ret    

0000386a <uptime>:
SYSCALL(uptime)
    386a:	b8 0e 00 00 00       	mov    $0xe,%eax
    386f:	cd 40                	int    $0x40
    3871:	c3                   	ret    

00003872 <getiocounts>:
SYSCALL(getiocounts)
    3872:	b8 16 00 00 00       	mov    $0x16,%eax
    3877:	cd 40                	int    $0x40
    3879:	c3                   	ret    

0000387a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
    387a:	55                   	push   %ebp
    387b:	89 e5                	mov    %esp,%ebp
    387d:	83 ec 1c             	sub    $0x1c,%esp
    3880:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
    3883:	6a 01                	push   $0x1
    3885:	8d 55 f4             	lea    -0xc(%ebp),%edx
    3888:	52                   	push   %edx
    3889:	50                   	push   %eax
    388a:	e8 63 ff ff ff       	call   37f2 <write>
}
    388f:	83 c4 10             	add    $0x10,%esp
    3892:	c9                   	leave  
    3893:	c3                   	ret    

00003894 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
    3894:	55                   	push   %ebp
    3895:	89 e5                	mov    %esp,%ebp
    3897:	57                   	push   %edi
    3898:	56                   	push   %esi
    3899:	53                   	push   %ebx
    389a:	83 ec 2c             	sub    $0x2c,%esp
    389d:	89 45 d0             	mov    %eax,-0x30(%ebp)
    38a0:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
    38a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
    38a6:	0f 95 c2             	setne  %dl
    38a9:	89 f0                	mov    %esi,%eax
    38ab:	c1 e8 1f             	shr    $0x1f,%eax
    38ae:	84 c2                	test   %al,%dl
    38b0:	74 42                	je     38f4 <printint+0x60>
    neg = 1;
    x = -xx;
    38b2:	f7 de                	neg    %esi
    neg = 1;
    38b4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
    38bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
    38c0:	89 f0                	mov    %esi,%eax
    38c2:	ba 00 00 00 00       	mov    $0x0,%edx
    38c7:	f7 f1                	div    %ecx
    38c9:	89 df                	mov    %ebx,%edi
    38cb:	83 c3 01             	add    $0x1,%ebx
    38ce:	0f b6 92 78 53 00 00 	movzbl 0x5378(%edx),%edx
    38d5:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
    38d9:	89 f2                	mov    %esi,%edx
    38db:	89 c6                	mov    %eax,%esi
    38dd:	39 d1                	cmp    %edx,%ecx
    38df:	76 df                	jbe    38c0 <printint+0x2c>
  if(neg)
    38e1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
    38e5:	74 2f                	je     3916 <printint+0x82>
    buf[i++] = '-';
    38e7:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
    38ec:	8d 5f 02             	lea    0x2(%edi),%ebx
    38ef:	8b 75 d0             	mov    -0x30(%ebp),%esi
    38f2:	eb 15                	jmp    3909 <printint+0x75>
  neg = 0;
    38f4:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
    38fb:	eb be                	jmp    38bb <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
    38fd:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
    3902:	89 f0                	mov    %esi,%eax
    3904:	e8 71 ff ff ff       	call   387a <putc>
  while(--i >= 0)
    3909:	83 eb 01             	sub    $0x1,%ebx
    390c:	79 ef                	jns    38fd <printint+0x69>
}
    390e:	83 c4 2c             	add    $0x2c,%esp
    3911:	5b                   	pop    %ebx
    3912:	5e                   	pop    %esi
    3913:	5f                   	pop    %edi
    3914:	5d                   	pop    %ebp
    3915:	c3                   	ret    
    3916:	8b 75 d0             	mov    -0x30(%ebp),%esi
    3919:	eb ee                	jmp    3909 <printint+0x75>

0000391b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
    391b:	f3 0f 1e fb          	endbr32 
    391f:	55                   	push   %ebp
    3920:	89 e5                	mov    %esp,%ebp
    3922:	57                   	push   %edi
    3923:	56                   	push   %esi
    3924:	53                   	push   %ebx
    3925:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
    3928:	8d 45 10             	lea    0x10(%ebp),%eax
    392b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
    392e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
    3933:	bb 00 00 00 00       	mov    $0x0,%ebx
    3938:	eb 14                	jmp    394e <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
    393a:	89 fa                	mov    %edi,%edx
    393c:	8b 45 08             	mov    0x8(%ebp),%eax
    393f:	e8 36 ff ff ff       	call   387a <putc>
    3944:	eb 05                	jmp    394b <printf+0x30>
      }
    } else if(state == '%'){
    3946:	83 fe 25             	cmp    $0x25,%esi
    3949:	74 25                	je     3970 <printf+0x55>
  for(i = 0; fmt[i]; i++){
    394b:	83 c3 01             	add    $0x1,%ebx
    394e:	8b 45 0c             	mov    0xc(%ebp),%eax
    3951:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
    3955:	84 c0                	test   %al,%al
    3957:	0f 84 23 01 00 00    	je     3a80 <printf+0x165>
    c = fmt[i] & 0xff;
    395d:	0f be f8             	movsbl %al,%edi
    3960:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
    3963:	85 f6                	test   %esi,%esi
    3965:	75 df                	jne    3946 <printf+0x2b>
      if(c == '%'){
    3967:	83 f8 25             	cmp    $0x25,%eax
    396a:	75 ce                	jne    393a <printf+0x1f>
        state = '%';
    396c:	89 c6                	mov    %eax,%esi
    396e:	eb db                	jmp    394b <printf+0x30>
      if(c == 'd'){
    3970:	83 f8 64             	cmp    $0x64,%eax
    3973:	74 49                	je     39be <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
    3975:	83 f8 78             	cmp    $0x78,%eax
    3978:	0f 94 c1             	sete   %cl
    397b:	83 f8 70             	cmp    $0x70,%eax
    397e:	0f 94 c2             	sete   %dl
    3981:	08 d1                	or     %dl,%cl
    3983:	75 63                	jne    39e8 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
    3985:	83 f8 73             	cmp    $0x73,%eax
    3988:	0f 84 84 00 00 00    	je     3a12 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
    398e:	83 f8 63             	cmp    $0x63,%eax
    3991:	0f 84 b7 00 00 00    	je     3a4e <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
    3997:	83 f8 25             	cmp    $0x25,%eax
    399a:	0f 84 cc 00 00 00    	je     3a6c <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
    39a0:	ba 25 00 00 00       	mov    $0x25,%edx
    39a5:	8b 45 08             	mov    0x8(%ebp),%eax
    39a8:	e8 cd fe ff ff       	call   387a <putc>
        putc(fd, c);
    39ad:	89 fa                	mov    %edi,%edx
    39af:	8b 45 08             	mov    0x8(%ebp),%eax
    39b2:	e8 c3 fe ff ff       	call   387a <putc>
      }
      state = 0;
    39b7:	be 00 00 00 00       	mov    $0x0,%esi
    39bc:	eb 8d                	jmp    394b <printf+0x30>
        printint(fd, *ap, 10, 1);
    39be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    39c1:	8b 17                	mov    (%edi),%edx
    39c3:	83 ec 0c             	sub    $0xc,%esp
    39c6:	6a 01                	push   $0x1
    39c8:	b9 0a 00 00 00       	mov    $0xa,%ecx
    39cd:	8b 45 08             	mov    0x8(%ebp),%eax
    39d0:	e8 bf fe ff ff       	call   3894 <printint>
        ap++;
    39d5:	83 c7 04             	add    $0x4,%edi
    39d8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    39db:	83 c4 10             	add    $0x10,%esp
      state = 0;
    39de:	be 00 00 00 00       	mov    $0x0,%esi
    39e3:	e9 63 ff ff ff       	jmp    394b <printf+0x30>
        printint(fd, *ap, 16, 0);
    39e8:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    39eb:	8b 17                	mov    (%edi),%edx
    39ed:	83 ec 0c             	sub    $0xc,%esp
    39f0:	6a 00                	push   $0x0
    39f2:	b9 10 00 00 00       	mov    $0x10,%ecx
    39f7:	8b 45 08             	mov    0x8(%ebp),%eax
    39fa:	e8 95 fe ff ff       	call   3894 <printint>
        ap++;
    39ff:	83 c7 04             	add    $0x4,%edi
    3a02:	89 7d e4             	mov    %edi,-0x1c(%ebp)
    3a05:	83 c4 10             	add    $0x10,%esp
      state = 0;
    3a08:	be 00 00 00 00       	mov    $0x0,%esi
    3a0d:	e9 39 ff ff ff       	jmp    394b <printf+0x30>
        s = (char*)*ap;
    3a12:	8b 45 e4             	mov    -0x1c(%ebp),%eax
    3a15:	8b 30                	mov    (%eax),%esi
        ap++;
    3a17:	83 c0 04             	add    $0x4,%eax
    3a1a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
    3a1d:	85 f6                	test   %esi,%esi
    3a1f:	75 28                	jne    3a49 <printf+0x12e>
          s = "(null)";
    3a21:	be 6e 53 00 00       	mov    $0x536e,%esi
    3a26:	8b 7d 08             	mov    0x8(%ebp),%edi
    3a29:	eb 0d                	jmp    3a38 <printf+0x11d>
          putc(fd, *s);
    3a2b:	0f be d2             	movsbl %dl,%edx
    3a2e:	89 f8                	mov    %edi,%eax
    3a30:	e8 45 fe ff ff       	call   387a <putc>
          s++;
    3a35:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
    3a38:	0f b6 16             	movzbl (%esi),%edx
    3a3b:	84 d2                	test   %dl,%dl
    3a3d:	75 ec                	jne    3a2b <printf+0x110>
      state = 0;
    3a3f:	be 00 00 00 00       	mov    $0x0,%esi
    3a44:	e9 02 ff ff ff       	jmp    394b <printf+0x30>
    3a49:	8b 7d 08             	mov    0x8(%ebp),%edi
    3a4c:	eb ea                	jmp    3a38 <printf+0x11d>
        putc(fd, *ap);
    3a4e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
    3a51:	0f be 17             	movsbl (%edi),%edx
    3a54:	8b 45 08             	mov    0x8(%ebp),%eax
    3a57:	e8 1e fe ff ff       	call   387a <putc>
        ap++;
    3a5c:	83 c7 04             	add    $0x4,%edi
    3a5f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
    3a62:	be 00 00 00 00       	mov    $0x0,%esi
    3a67:	e9 df fe ff ff       	jmp    394b <printf+0x30>
        putc(fd, c);
    3a6c:	89 fa                	mov    %edi,%edx
    3a6e:	8b 45 08             	mov    0x8(%ebp),%eax
    3a71:	e8 04 fe ff ff       	call   387a <putc>
      state = 0;
    3a76:	be 00 00 00 00       	mov    $0x0,%esi
    3a7b:	e9 cb fe ff ff       	jmp    394b <printf+0x30>
    }
  }
}
    3a80:	8d 65 f4             	lea    -0xc(%ebp),%esp
    3a83:	5b                   	pop    %ebx
    3a84:	5e                   	pop    %esi
    3a85:	5f                   	pop    %edi
    3a86:	5d                   	pop    %ebp
    3a87:	c3                   	ret    

00003a88 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    3a88:	f3 0f 1e fb          	endbr32 
    3a8c:	55                   	push   %ebp
    3a8d:	89 e5                	mov    %esp,%ebp
    3a8f:	57                   	push   %edi
    3a90:	56                   	push   %esi
    3a91:	53                   	push   %ebx
    3a92:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
    3a95:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    3a98:	a1 a0 5c 00 00       	mov    0x5ca0,%eax
    3a9d:	eb 02                	jmp    3aa1 <free+0x19>
    3a9f:	89 d0                	mov    %edx,%eax
    3aa1:	39 c8                	cmp    %ecx,%eax
    3aa3:	73 04                	jae    3aa9 <free+0x21>
    3aa5:	39 08                	cmp    %ecx,(%eax)
    3aa7:	77 12                	ja     3abb <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    3aa9:	8b 10                	mov    (%eax),%edx
    3aab:	39 c2                	cmp    %eax,%edx
    3aad:	77 f0                	ja     3a9f <free+0x17>
    3aaf:	39 c8                	cmp    %ecx,%eax
    3ab1:	72 08                	jb     3abb <free+0x33>
    3ab3:	39 ca                	cmp    %ecx,%edx
    3ab5:	77 04                	ja     3abb <free+0x33>
    3ab7:	89 d0                	mov    %edx,%eax
    3ab9:	eb e6                	jmp    3aa1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
    3abb:	8b 73 fc             	mov    -0x4(%ebx),%esi
    3abe:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
    3ac1:	8b 10                	mov    (%eax),%edx
    3ac3:	39 d7                	cmp    %edx,%edi
    3ac5:	74 19                	je     3ae0 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
    3ac7:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
    3aca:	8b 50 04             	mov    0x4(%eax),%edx
    3acd:	8d 34 d0             	lea    (%eax,%edx,8),%esi
    3ad0:	39 ce                	cmp    %ecx,%esi
    3ad2:	74 1b                	je     3aef <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
    3ad4:	89 08                	mov    %ecx,(%eax)
  freep = p;
    3ad6:	a3 a0 5c 00 00       	mov    %eax,0x5ca0
}
    3adb:	5b                   	pop    %ebx
    3adc:	5e                   	pop    %esi
    3add:	5f                   	pop    %edi
    3ade:	5d                   	pop    %ebp
    3adf:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
    3ae0:	03 72 04             	add    0x4(%edx),%esi
    3ae3:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
    3ae6:	8b 10                	mov    (%eax),%edx
    3ae8:	8b 12                	mov    (%edx),%edx
    3aea:	89 53 f8             	mov    %edx,-0x8(%ebx)
    3aed:	eb db                	jmp    3aca <free+0x42>
    p->s.size += bp->s.size;
    3aef:	03 53 fc             	add    -0x4(%ebx),%edx
    3af2:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
    3af5:	8b 53 f8             	mov    -0x8(%ebx),%edx
    3af8:	89 10                	mov    %edx,(%eax)
    3afa:	eb da                	jmp    3ad6 <free+0x4e>

00003afc <morecore>:

static Header*
morecore(uint nu)
{
    3afc:	55                   	push   %ebp
    3afd:	89 e5                	mov    %esp,%ebp
    3aff:	53                   	push   %ebx
    3b00:	83 ec 04             	sub    $0x4,%esp
    3b03:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
    3b05:	3d ff 0f 00 00       	cmp    $0xfff,%eax
    3b0a:	77 05                	ja     3b11 <morecore+0x15>
    nu = 4096;
    3b0c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
    3b11:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
    3b18:	83 ec 0c             	sub    $0xc,%esp
    3b1b:	50                   	push   %eax
    3b1c:	e8 39 fd ff ff       	call   385a <sbrk>
  if(p == (char*)-1)
    3b21:	83 c4 10             	add    $0x10,%esp
    3b24:	83 f8 ff             	cmp    $0xffffffff,%eax
    3b27:	74 1c                	je     3b45 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
    3b29:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
    3b2c:	83 c0 08             	add    $0x8,%eax
    3b2f:	83 ec 0c             	sub    $0xc,%esp
    3b32:	50                   	push   %eax
    3b33:	e8 50 ff ff ff       	call   3a88 <free>
  return freep;
    3b38:	a1 a0 5c 00 00       	mov    0x5ca0,%eax
    3b3d:	83 c4 10             	add    $0x10,%esp
}
    3b40:	8b 5d fc             	mov    -0x4(%ebp),%ebx
    3b43:	c9                   	leave  
    3b44:	c3                   	ret    
    return 0;
    3b45:	b8 00 00 00 00       	mov    $0x0,%eax
    3b4a:	eb f4                	jmp    3b40 <morecore+0x44>

00003b4c <malloc>:

void*
malloc(int nbytes)
{
    3b4c:	f3 0f 1e fb          	endbr32 
    3b50:	55                   	push   %ebp
    3b51:	89 e5                	mov    %esp,%ebp
    3b53:	53                   	push   %ebx
    3b54:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    3b57:	8b 45 08             	mov    0x8(%ebp),%eax
    3b5a:	8d 58 07             	lea    0x7(%eax),%ebx
    3b5d:	c1 eb 03             	shr    $0x3,%ebx
    3b60:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
    3b63:	8b 0d a0 5c 00 00    	mov    0x5ca0,%ecx
    3b69:	85 c9                	test   %ecx,%ecx
    3b6b:	74 04                	je     3b71 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3b6d:	8b 01                	mov    (%ecx),%eax
    3b6f:	eb 4b                	jmp    3bbc <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
    3b71:	c7 05 a0 5c 00 00 a4 	movl   $0x5ca4,0x5ca0
    3b78:	5c 00 00 
    3b7b:	c7 05 a4 5c 00 00 a4 	movl   $0x5ca4,0x5ca4
    3b82:	5c 00 00 
    base.s.size = 0;
    3b85:	c7 05 a8 5c 00 00 00 	movl   $0x0,0x5ca8
    3b8c:	00 00 00 
    base.s.ptr = freep = prevp = &base;
    3b8f:	b9 a4 5c 00 00       	mov    $0x5ca4,%ecx
    3b94:	eb d7                	jmp    3b6d <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
    3b96:	74 1a                	je     3bb2 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
    3b98:	29 da                	sub    %ebx,%edx
    3b9a:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
    3b9d:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
    3ba0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
    3ba3:	89 0d a0 5c 00 00    	mov    %ecx,0x5ca0
      return (void*)(p + 1);
    3ba9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    3bac:	83 c4 04             	add    $0x4,%esp
    3baf:	5b                   	pop    %ebx
    3bb0:	5d                   	pop    %ebp
    3bb1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
    3bb2:	8b 10                	mov    (%eax),%edx
    3bb4:	89 11                	mov    %edx,(%ecx)
    3bb6:	eb eb                	jmp    3ba3 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    3bb8:	89 c1                	mov    %eax,%ecx
    3bba:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
    3bbc:	8b 50 04             	mov    0x4(%eax),%edx
    3bbf:	39 da                	cmp    %ebx,%edx
    3bc1:	73 d3                	jae    3b96 <malloc+0x4a>
    if(p == freep)
    3bc3:	39 05 a0 5c 00 00    	cmp    %eax,0x5ca0
    3bc9:	75 ed                	jne    3bb8 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
    3bcb:	89 d8                	mov    %ebx,%eax
    3bcd:	e8 2a ff ff ff       	call   3afc <morecore>
    3bd2:	85 c0                	test   %eax,%eax
    3bd4:	75 e2                	jne    3bb8 <malloc+0x6c>
    3bd6:	eb d4                	jmp    3bac <malloc+0x60>
