
_stressfs:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	81 ec 24 02 00 00    	sub    $0x224,%esp
  int fd, i;
  char path[] = "stressfs0";
  1a:	c7 45 de 73 74 72 65 	movl   $0x65727473,-0x22(%ebp)
  21:	c7 45 e2 73 73 66 73 	movl   $0x73667373,-0x1e(%ebp)
  28:	66 c7 45 e6 30 00    	movw   $0x30,-0x1a(%ebp)
  char data[512];

  printf(1, "stressfs starting\n");
  2e:	68 e4 06 00 00       	push   $0x6e4
  33:	6a 01                	push   $0x1
  35:	e8 ec 03 00 00       	call   426 <printf>
  memset(data, 'a', sizeof(data));
  3a:	83 c4 0c             	add    $0xc,%esp
  3d:	68 00 02 00 00       	push   $0x200
  42:	6a 61                	push   $0x61
  44:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  4a:	50                   	push   %eax
  4b:	e8 40 01 00 00       	call   190 <memset>

  for(i = 0; i < 4; i++)
  50:	83 c4 10             	add    $0x10,%esp
  53:	bb 00 00 00 00       	mov    $0x0,%ebx
  58:	83 fb 03             	cmp    $0x3,%ebx
  5b:	7f 0e                	jg     6b <main+0x6b>
    if(fork() > 0)
  5d:	e8 73 02 00 00       	call   2d5 <fork>
  62:	85 c0                	test   %eax,%eax
  64:	7f 05                	jg     6b <main+0x6b>
  for(i = 0; i < 4; i++)
  66:	83 c3 01             	add    $0x1,%ebx
  69:	eb ed                	jmp    58 <main+0x58>
      break;

  printf(1, "write %d\n", i);
  6b:	83 ec 04             	sub    $0x4,%esp
  6e:	53                   	push   %ebx
  6f:	68 f7 06 00 00       	push   $0x6f7
  74:	6a 01                	push   $0x1
  76:	e8 ab 03 00 00       	call   426 <printf>

  path[8] += i;
  7b:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  7e:	83 c4 08             	add    $0x8,%esp
  81:	68 02 02 00 00       	push   $0x202
  86:	8d 45 de             	lea    -0x22(%ebp),%eax
  89:	50                   	push   %eax
  8a:	e8 8e 02 00 00       	call   31d <open>
  8f:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  91:	83 c4 10             	add    $0x10,%esp
  94:	bb 00 00 00 00       	mov    $0x0,%ebx
  99:	eb 1b                	jmp    b6 <main+0xb6>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  9b:	83 ec 04             	sub    $0x4,%esp
  9e:	68 00 02 00 00       	push   $0x200
  a3:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a9:	50                   	push   %eax
  aa:	56                   	push   %esi
  ab:	e8 4d 02 00 00       	call   2fd <write>
  for(i = 0; i < 20; i++)
  b0:	83 c3 01             	add    $0x1,%ebx
  b3:	83 c4 10             	add    $0x10,%esp
  b6:	83 fb 13             	cmp    $0x13,%ebx
  b9:	7e e0                	jle    9b <main+0x9b>
  close(fd);
  bb:	83 ec 0c             	sub    $0xc,%esp
  be:	56                   	push   %esi
  bf:	e8 41 02 00 00       	call   305 <close>

  printf(1, "read\n");
  c4:	83 c4 08             	add    $0x8,%esp
  c7:	68 01 07 00 00       	push   $0x701
  cc:	6a 01                	push   $0x1
  ce:	e8 53 03 00 00       	call   426 <printf>

  fd = open(path, O_RDONLY);
  d3:	83 c4 08             	add    $0x8,%esp
  d6:	6a 00                	push   $0x0
  d8:	8d 45 de             	lea    -0x22(%ebp),%eax
  db:	50                   	push   %eax
  dc:	e8 3c 02 00 00       	call   31d <open>
  e1:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  e3:	83 c4 10             	add    $0x10,%esp
  e6:	bb 00 00 00 00       	mov    $0x0,%ebx
  eb:	eb 1b                	jmp    108 <main+0x108>
    read(fd, data, sizeof(data));
  ed:	83 ec 04             	sub    $0x4,%esp
  f0:	68 00 02 00 00       	push   $0x200
  f5:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  fb:	50                   	push   %eax
  fc:	56                   	push   %esi
  fd:	e8 f3 01 00 00       	call   2f5 <read>
  for (i = 0; i < 20; i++)
 102:	83 c3 01             	add    $0x1,%ebx
 105:	83 c4 10             	add    $0x10,%esp
 108:	83 fb 13             	cmp    $0x13,%ebx
 10b:	7e e0                	jle    ed <main+0xed>
  close(fd);
 10d:	83 ec 0c             	sub    $0xc,%esp
 110:	56                   	push   %esi
 111:	e8 ef 01 00 00       	call   305 <close>

  wait();
 116:	e8 ca 01 00 00       	call   2e5 <wait>

  exit();
 11b:	e8 bd 01 00 00       	call   2dd <exit>

00000120 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 120:	f3 0f 1e fb          	endbr32 
 124:	55                   	push   %ebp
 125:	89 e5                	mov    %esp,%ebp
 127:	56                   	push   %esi
 128:	53                   	push   %ebx
 129:	8b 75 08             	mov    0x8(%ebp),%esi
 12c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12f:	89 f0                	mov    %esi,%eax
 131:	89 d1                	mov    %edx,%ecx
 133:	83 c2 01             	add    $0x1,%edx
 136:	89 c3                	mov    %eax,%ebx
 138:	83 c0 01             	add    $0x1,%eax
 13b:	0f b6 09             	movzbl (%ecx),%ecx
 13e:	88 0b                	mov    %cl,(%ebx)
 140:	84 c9                	test   %cl,%cl
 142:	75 ed                	jne    131 <strcpy+0x11>
    ;
  return os;
}
 144:	89 f0                	mov    %esi,%eax
 146:	5b                   	pop    %ebx
 147:	5e                   	pop    %esi
 148:	5d                   	pop    %ebp
 149:	c3                   	ret    

0000014a <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14a:	f3 0f 1e fb          	endbr32 
 14e:	55                   	push   %ebp
 14f:	89 e5                	mov    %esp,%ebp
 151:	8b 4d 08             	mov    0x8(%ebp),%ecx
 154:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 157:	0f b6 01             	movzbl (%ecx),%eax
 15a:	84 c0                	test   %al,%al
 15c:	74 0c                	je     16a <strcmp+0x20>
 15e:	3a 02                	cmp    (%edx),%al
 160:	75 08                	jne    16a <strcmp+0x20>
    p++, q++;
 162:	83 c1 01             	add    $0x1,%ecx
 165:	83 c2 01             	add    $0x1,%edx
 168:	eb ed                	jmp    157 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 16a:	0f b6 c0             	movzbl %al,%eax
 16d:	0f b6 12             	movzbl (%edx),%edx
 170:	29 d0                	sub    %edx,%eax
}
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    

00000174 <strlen>:

int
strlen(const char *s)
{
 174:	f3 0f 1e fb          	endbr32 
 178:	55                   	push   %ebp
 179:	89 e5                	mov    %esp,%ebp
 17b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 17e:	b8 00 00 00 00       	mov    $0x0,%eax
 183:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 187:	74 05                	je     18e <strlen+0x1a>
 189:	83 c0 01             	add    $0x1,%eax
 18c:	eb f5                	jmp    183 <strlen+0xf>
    ;
  return n;
}
 18e:	5d                   	pop    %ebp
 18f:	c3                   	ret    

00000190 <memset>:

void*
memset(void *dst, int c, int n)
{
 190:	f3 0f 1e fb          	endbr32 
 194:	55                   	push   %ebp
 195:	89 e5                	mov    %esp,%ebp
 197:	57                   	push   %edi
 198:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 19b:	89 d7                	mov    %edx,%edi
 19d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1a0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1a3:	fc                   	cld    
 1a4:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1a6:	89 d0                	mov    %edx,%eax
 1a8:	5f                   	pop    %edi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    

000001ab <strchr>:

char*
strchr(const char *s, char c)
{
 1ab:	f3 0f 1e fb          	endbr32 
 1af:	55                   	push   %ebp
 1b0:	89 e5                	mov    %esp,%ebp
 1b2:	8b 45 08             	mov    0x8(%ebp),%eax
 1b5:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 1b9:	0f b6 10             	movzbl (%eax),%edx
 1bc:	84 d2                	test   %dl,%dl
 1be:	74 09                	je     1c9 <strchr+0x1e>
    if(*s == c)
 1c0:	38 ca                	cmp    %cl,%dl
 1c2:	74 0a                	je     1ce <strchr+0x23>
  for(; *s; s++)
 1c4:	83 c0 01             	add    $0x1,%eax
 1c7:	eb f0                	jmp    1b9 <strchr+0xe>
      return (char*)s;
  return 0;
 1c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1ce:	5d                   	pop    %ebp
 1cf:	c3                   	ret    

000001d0 <gets>:

char*
gets(char *buf, int max)
{
 1d0:	f3 0f 1e fb          	endbr32 
 1d4:	55                   	push   %ebp
 1d5:	89 e5                	mov    %esp,%ebp
 1d7:	57                   	push   %edi
 1d8:	56                   	push   %esi
 1d9:	53                   	push   %ebx
 1da:	83 ec 1c             	sub    $0x1c,%esp
 1dd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1e0:	bb 00 00 00 00       	mov    $0x0,%ebx
 1e5:	89 de                	mov    %ebx,%esi
 1e7:	83 c3 01             	add    $0x1,%ebx
 1ea:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1ed:	7d 2e                	jge    21d <gets+0x4d>
    cc = read(0, &c, 1);
 1ef:	83 ec 04             	sub    $0x4,%esp
 1f2:	6a 01                	push   $0x1
 1f4:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1f7:	50                   	push   %eax
 1f8:	6a 00                	push   $0x0
 1fa:	e8 f6 00 00 00       	call   2f5 <read>
    if(cc < 1)
 1ff:	83 c4 10             	add    $0x10,%esp
 202:	85 c0                	test   %eax,%eax
 204:	7e 17                	jle    21d <gets+0x4d>
      break;
    buf[i++] = c;
 206:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 20a:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 20d:	3c 0a                	cmp    $0xa,%al
 20f:	0f 94 c2             	sete   %dl
 212:	3c 0d                	cmp    $0xd,%al
 214:	0f 94 c0             	sete   %al
 217:	08 c2                	or     %al,%dl
 219:	74 ca                	je     1e5 <gets+0x15>
    buf[i++] = c;
 21b:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 21d:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 221:	89 f8                	mov    %edi,%eax
 223:	8d 65 f4             	lea    -0xc(%ebp),%esp
 226:	5b                   	pop    %ebx
 227:	5e                   	pop    %esi
 228:	5f                   	pop    %edi
 229:	5d                   	pop    %ebp
 22a:	c3                   	ret    

0000022b <stat>:

int
stat(const char *n, struct stat *st)
{
 22b:	f3 0f 1e fb          	endbr32 
 22f:	55                   	push   %ebp
 230:	89 e5                	mov    %esp,%ebp
 232:	56                   	push   %esi
 233:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 234:	83 ec 08             	sub    $0x8,%esp
 237:	6a 00                	push   $0x0
 239:	ff 75 08             	pushl  0x8(%ebp)
 23c:	e8 dc 00 00 00       	call   31d <open>
  if(fd < 0)
 241:	83 c4 10             	add    $0x10,%esp
 244:	85 c0                	test   %eax,%eax
 246:	78 24                	js     26c <stat+0x41>
 248:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 24a:	83 ec 08             	sub    $0x8,%esp
 24d:	ff 75 0c             	pushl  0xc(%ebp)
 250:	50                   	push   %eax
 251:	e8 df 00 00 00       	call   335 <fstat>
 256:	89 c6                	mov    %eax,%esi
  close(fd);
 258:	89 1c 24             	mov    %ebx,(%esp)
 25b:	e8 a5 00 00 00       	call   305 <close>
  return r;
 260:	83 c4 10             	add    $0x10,%esp
}
 263:	89 f0                	mov    %esi,%eax
 265:	8d 65 f8             	lea    -0x8(%ebp),%esp
 268:	5b                   	pop    %ebx
 269:	5e                   	pop    %esi
 26a:	5d                   	pop    %ebp
 26b:	c3                   	ret    
    return -1;
 26c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 271:	eb f0                	jmp    263 <stat+0x38>

00000273 <atoi>:

int
atoi(const char *s)
{
 273:	f3 0f 1e fb          	endbr32 
 277:	55                   	push   %ebp
 278:	89 e5                	mov    %esp,%ebp
 27a:	53                   	push   %ebx
 27b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 27e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 283:	0f b6 01             	movzbl (%ecx),%eax
 286:	8d 58 d0             	lea    -0x30(%eax),%ebx
 289:	80 fb 09             	cmp    $0x9,%bl
 28c:	77 12                	ja     2a0 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 28e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 291:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 294:	83 c1 01             	add    $0x1,%ecx
 297:	0f be c0             	movsbl %al,%eax
 29a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 29e:	eb e3                	jmp    283 <atoi+0x10>
  return n;
}
 2a0:	89 d0                	mov    %edx,%eax
 2a2:	5b                   	pop    %ebx
 2a3:	5d                   	pop    %ebp
 2a4:	c3                   	ret    

000002a5 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a5:	f3 0f 1e fb          	endbr32 
 2a9:	55                   	push   %ebp
 2aa:	89 e5                	mov    %esp,%ebp
 2ac:	56                   	push   %esi
 2ad:	53                   	push   %ebx
 2ae:	8b 75 08             	mov    0x8(%ebp),%esi
 2b1:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2b4:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 2b7:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 2b9:	8d 58 ff             	lea    -0x1(%eax),%ebx
 2bc:	85 c0                	test   %eax,%eax
 2be:	7e 0f                	jle    2cf <memmove+0x2a>
    *dst++ = *src++;
 2c0:	0f b6 01             	movzbl (%ecx),%eax
 2c3:	88 02                	mov    %al,(%edx)
 2c5:	8d 49 01             	lea    0x1(%ecx),%ecx
 2c8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 2cb:	89 d8                	mov    %ebx,%eax
 2cd:	eb ea                	jmp    2b9 <memmove+0x14>
  return vdst;
}
 2cf:	89 f0                	mov    %esi,%eax
 2d1:	5b                   	pop    %ebx
 2d2:	5e                   	pop    %esi
 2d3:	5d                   	pop    %ebp
 2d4:	c3                   	ret    

000002d5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2d5:	b8 01 00 00 00       	mov    $0x1,%eax
 2da:	cd 40                	int    $0x40
 2dc:	c3                   	ret    

000002dd <exit>:
SYSCALL(exit)
 2dd:	b8 02 00 00 00       	mov    $0x2,%eax
 2e2:	cd 40                	int    $0x40
 2e4:	c3                   	ret    

000002e5 <wait>:
SYSCALL(wait)
 2e5:	b8 03 00 00 00       	mov    $0x3,%eax
 2ea:	cd 40                	int    $0x40
 2ec:	c3                   	ret    

000002ed <pipe>:
SYSCALL(pipe)
 2ed:	b8 04 00 00 00       	mov    $0x4,%eax
 2f2:	cd 40                	int    $0x40
 2f4:	c3                   	ret    

000002f5 <read>:
SYSCALL(read)
 2f5:	b8 05 00 00 00       	mov    $0x5,%eax
 2fa:	cd 40                	int    $0x40
 2fc:	c3                   	ret    

000002fd <write>:
SYSCALL(write)
 2fd:	b8 10 00 00 00       	mov    $0x10,%eax
 302:	cd 40                	int    $0x40
 304:	c3                   	ret    

00000305 <close>:
SYSCALL(close)
 305:	b8 15 00 00 00       	mov    $0x15,%eax
 30a:	cd 40                	int    $0x40
 30c:	c3                   	ret    

0000030d <kill>:
SYSCALL(kill)
 30d:	b8 06 00 00 00       	mov    $0x6,%eax
 312:	cd 40                	int    $0x40
 314:	c3                   	ret    

00000315 <exec>:
SYSCALL(exec)
 315:	b8 07 00 00 00       	mov    $0x7,%eax
 31a:	cd 40                	int    $0x40
 31c:	c3                   	ret    

0000031d <open>:
SYSCALL(open)
 31d:	b8 0f 00 00 00       	mov    $0xf,%eax
 322:	cd 40                	int    $0x40
 324:	c3                   	ret    

00000325 <mknod>:
SYSCALL(mknod)
 325:	b8 11 00 00 00       	mov    $0x11,%eax
 32a:	cd 40                	int    $0x40
 32c:	c3                   	ret    

0000032d <unlink>:
SYSCALL(unlink)
 32d:	b8 12 00 00 00       	mov    $0x12,%eax
 332:	cd 40                	int    $0x40
 334:	c3                   	ret    

00000335 <fstat>:
SYSCALL(fstat)
 335:	b8 08 00 00 00       	mov    $0x8,%eax
 33a:	cd 40                	int    $0x40
 33c:	c3                   	ret    

0000033d <link>:
SYSCALL(link)
 33d:	b8 13 00 00 00       	mov    $0x13,%eax
 342:	cd 40                	int    $0x40
 344:	c3                   	ret    

00000345 <mkdir>:
SYSCALL(mkdir)
 345:	b8 14 00 00 00       	mov    $0x14,%eax
 34a:	cd 40                	int    $0x40
 34c:	c3                   	ret    

0000034d <chdir>:
SYSCALL(chdir)
 34d:	b8 09 00 00 00       	mov    $0x9,%eax
 352:	cd 40                	int    $0x40
 354:	c3                   	ret    

00000355 <dup>:
SYSCALL(dup)
 355:	b8 0a 00 00 00       	mov    $0xa,%eax
 35a:	cd 40                	int    $0x40
 35c:	c3                   	ret    

0000035d <getpid>:
SYSCALL(getpid)
 35d:	b8 0b 00 00 00       	mov    $0xb,%eax
 362:	cd 40                	int    $0x40
 364:	c3                   	ret    

00000365 <sbrk>:
SYSCALL(sbrk)
 365:	b8 0c 00 00 00       	mov    $0xc,%eax
 36a:	cd 40                	int    $0x40
 36c:	c3                   	ret    

0000036d <sleep>:
SYSCALL(sleep)
 36d:	b8 0d 00 00 00       	mov    $0xd,%eax
 372:	cd 40                	int    $0x40
 374:	c3                   	ret    

00000375 <uptime>:
SYSCALL(uptime)
 375:	b8 0e 00 00 00       	mov    $0xe,%eax
 37a:	cd 40                	int    $0x40
 37c:	c3                   	ret    

0000037d <getiocounts>:
SYSCALL(getiocounts)
 37d:	b8 16 00 00 00       	mov    $0x16,%eax
 382:	cd 40                	int    $0x40
 384:	c3                   	ret    

00000385 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 385:	55                   	push   %ebp
 386:	89 e5                	mov    %esp,%ebp
 388:	83 ec 1c             	sub    $0x1c,%esp
 38b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 38e:	6a 01                	push   $0x1
 390:	8d 55 f4             	lea    -0xc(%ebp),%edx
 393:	52                   	push   %edx
 394:	50                   	push   %eax
 395:	e8 63 ff ff ff       	call   2fd <write>
}
 39a:	83 c4 10             	add    $0x10,%esp
 39d:	c9                   	leave  
 39e:	c3                   	ret    

0000039f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 39f:	55                   	push   %ebp
 3a0:	89 e5                	mov    %esp,%ebp
 3a2:	57                   	push   %edi
 3a3:	56                   	push   %esi
 3a4:	53                   	push   %ebx
 3a5:	83 ec 2c             	sub    $0x2c,%esp
 3a8:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3ab:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3b1:	0f 95 c2             	setne  %dl
 3b4:	89 f0                	mov    %esi,%eax
 3b6:	c1 e8 1f             	shr    $0x1f,%eax
 3b9:	84 c2                	test   %al,%dl
 3bb:	74 42                	je     3ff <printint+0x60>
    neg = 1;
    x = -xx;
 3bd:	f7 de                	neg    %esi
    neg = 1;
 3bf:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 3c6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3cb:	89 f0                	mov    %esi,%eax
 3cd:	ba 00 00 00 00       	mov    $0x0,%edx
 3d2:	f7 f1                	div    %ecx
 3d4:	89 df                	mov    %ebx,%edi
 3d6:	83 c3 01             	add    $0x1,%ebx
 3d9:	0f b6 92 10 07 00 00 	movzbl 0x710(%edx),%edx
 3e0:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3e4:	89 f2                	mov    %esi,%edx
 3e6:	89 c6                	mov    %eax,%esi
 3e8:	39 d1                	cmp    %edx,%ecx
 3ea:	76 df                	jbe    3cb <printint+0x2c>
  if(neg)
 3ec:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3f0:	74 2f                	je     421 <printint+0x82>
    buf[i++] = '-';
 3f2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3f7:	8d 5f 02             	lea    0x2(%edi),%ebx
 3fa:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3fd:	eb 15                	jmp    414 <printint+0x75>
  neg = 0;
 3ff:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 406:	eb be                	jmp    3c6 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 408:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 40d:	89 f0                	mov    %esi,%eax
 40f:	e8 71 ff ff ff       	call   385 <putc>
  while(--i >= 0)
 414:	83 eb 01             	sub    $0x1,%ebx
 417:	79 ef                	jns    408 <printint+0x69>
}
 419:	83 c4 2c             	add    $0x2c,%esp
 41c:	5b                   	pop    %ebx
 41d:	5e                   	pop    %esi
 41e:	5f                   	pop    %edi
 41f:	5d                   	pop    %ebp
 420:	c3                   	ret    
 421:	8b 75 d0             	mov    -0x30(%ebp),%esi
 424:	eb ee                	jmp    414 <printint+0x75>

00000426 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 426:	f3 0f 1e fb          	endbr32 
 42a:	55                   	push   %ebp
 42b:	89 e5                	mov    %esp,%ebp
 42d:	57                   	push   %edi
 42e:	56                   	push   %esi
 42f:	53                   	push   %ebx
 430:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 433:	8d 45 10             	lea    0x10(%ebp),%eax
 436:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 439:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 43e:	bb 00 00 00 00       	mov    $0x0,%ebx
 443:	eb 14                	jmp    459 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 445:	89 fa                	mov    %edi,%edx
 447:	8b 45 08             	mov    0x8(%ebp),%eax
 44a:	e8 36 ff ff ff       	call   385 <putc>
 44f:	eb 05                	jmp    456 <printf+0x30>
      }
    } else if(state == '%'){
 451:	83 fe 25             	cmp    $0x25,%esi
 454:	74 25                	je     47b <printf+0x55>
  for(i = 0; fmt[i]; i++){
 456:	83 c3 01             	add    $0x1,%ebx
 459:	8b 45 0c             	mov    0xc(%ebp),%eax
 45c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 460:	84 c0                	test   %al,%al
 462:	0f 84 23 01 00 00    	je     58b <printf+0x165>
    c = fmt[i] & 0xff;
 468:	0f be f8             	movsbl %al,%edi
 46b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 46e:	85 f6                	test   %esi,%esi
 470:	75 df                	jne    451 <printf+0x2b>
      if(c == '%'){
 472:	83 f8 25             	cmp    $0x25,%eax
 475:	75 ce                	jne    445 <printf+0x1f>
        state = '%';
 477:	89 c6                	mov    %eax,%esi
 479:	eb db                	jmp    456 <printf+0x30>
      if(c == 'd'){
 47b:	83 f8 64             	cmp    $0x64,%eax
 47e:	74 49                	je     4c9 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 480:	83 f8 78             	cmp    $0x78,%eax
 483:	0f 94 c1             	sete   %cl
 486:	83 f8 70             	cmp    $0x70,%eax
 489:	0f 94 c2             	sete   %dl
 48c:	08 d1                	or     %dl,%cl
 48e:	75 63                	jne    4f3 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 490:	83 f8 73             	cmp    $0x73,%eax
 493:	0f 84 84 00 00 00    	je     51d <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 499:	83 f8 63             	cmp    $0x63,%eax
 49c:	0f 84 b7 00 00 00    	je     559 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4a2:	83 f8 25             	cmp    $0x25,%eax
 4a5:	0f 84 cc 00 00 00    	je     577 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4ab:	ba 25 00 00 00       	mov    $0x25,%edx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 cd fe ff ff       	call   385 <putc>
        putc(fd, c);
 4b8:	89 fa                	mov    %edi,%edx
 4ba:	8b 45 08             	mov    0x8(%ebp),%eax
 4bd:	e8 c3 fe ff ff       	call   385 <putc>
      }
      state = 0;
 4c2:	be 00 00 00 00       	mov    $0x0,%esi
 4c7:	eb 8d                	jmp    456 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4c9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4cc:	8b 17                	mov    (%edi),%edx
 4ce:	83 ec 0c             	sub    $0xc,%esp
 4d1:	6a 01                	push   $0x1
 4d3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4d8:	8b 45 08             	mov    0x8(%ebp),%eax
 4db:	e8 bf fe ff ff       	call   39f <printint>
        ap++;
 4e0:	83 c7 04             	add    $0x4,%edi
 4e3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4e9:	be 00 00 00 00       	mov    $0x0,%esi
 4ee:	e9 63 ff ff ff       	jmp    456 <printf+0x30>
        printint(fd, *ap, 16, 0);
 4f3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4f6:	8b 17                	mov    (%edi),%edx
 4f8:	83 ec 0c             	sub    $0xc,%esp
 4fb:	6a 00                	push   $0x0
 4fd:	b9 10 00 00 00       	mov    $0x10,%ecx
 502:	8b 45 08             	mov    0x8(%ebp),%eax
 505:	e8 95 fe ff ff       	call   39f <printint>
        ap++;
 50a:	83 c7 04             	add    $0x4,%edi
 50d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 510:	83 c4 10             	add    $0x10,%esp
      state = 0;
 513:	be 00 00 00 00       	mov    $0x0,%esi
 518:	e9 39 ff ff ff       	jmp    456 <printf+0x30>
        s = (char*)*ap;
 51d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 520:	8b 30                	mov    (%eax),%esi
        ap++;
 522:	83 c0 04             	add    $0x4,%eax
 525:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 528:	85 f6                	test   %esi,%esi
 52a:	75 28                	jne    554 <printf+0x12e>
          s = "(null)";
 52c:	be 07 07 00 00       	mov    $0x707,%esi
 531:	8b 7d 08             	mov    0x8(%ebp),%edi
 534:	eb 0d                	jmp    543 <printf+0x11d>
          putc(fd, *s);
 536:	0f be d2             	movsbl %dl,%edx
 539:	89 f8                	mov    %edi,%eax
 53b:	e8 45 fe ff ff       	call   385 <putc>
          s++;
 540:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 543:	0f b6 16             	movzbl (%esi),%edx
 546:	84 d2                	test   %dl,%dl
 548:	75 ec                	jne    536 <printf+0x110>
      state = 0;
 54a:	be 00 00 00 00       	mov    $0x0,%esi
 54f:	e9 02 ff ff ff       	jmp    456 <printf+0x30>
 554:	8b 7d 08             	mov    0x8(%ebp),%edi
 557:	eb ea                	jmp    543 <printf+0x11d>
        putc(fd, *ap);
 559:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 55c:	0f be 17             	movsbl (%edi),%edx
 55f:	8b 45 08             	mov    0x8(%ebp),%eax
 562:	e8 1e fe ff ff       	call   385 <putc>
        ap++;
 567:	83 c7 04             	add    $0x4,%edi
 56a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 56d:	be 00 00 00 00       	mov    $0x0,%esi
 572:	e9 df fe ff ff       	jmp    456 <printf+0x30>
        putc(fd, c);
 577:	89 fa                	mov    %edi,%edx
 579:	8b 45 08             	mov    0x8(%ebp),%eax
 57c:	e8 04 fe ff ff       	call   385 <putc>
      state = 0;
 581:	be 00 00 00 00       	mov    $0x0,%esi
 586:	e9 cb fe ff ff       	jmp    456 <printf+0x30>
    }
  }
}
 58b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58e:	5b                   	pop    %ebx
 58f:	5e                   	pop    %esi
 590:	5f                   	pop    %edi
 591:	5d                   	pop    %ebp
 592:	c3                   	ret    

00000593 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 593:	f3 0f 1e fb          	endbr32 
 597:	55                   	push   %ebp
 598:	89 e5                	mov    %esp,%ebp
 59a:	57                   	push   %edi
 59b:	56                   	push   %esi
 59c:	53                   	push   %ebx
 59d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5a0:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5a3:	a1 b8 09 00 00       	mov    0x9b8,%eax
 5a8:	eb 02                	jmp    5ac <free+0x19>
 5aa:	89 d0                	mov    %edx,%eax
 5ac:	39 c8                	cmp    %ecx,%eax
 5ae:	73 04                	jae    5b4 <free+0x21>
 5b0:	39 08                	cmp    %ecx,(%eax)
 5b2:	77 12                	ja     5c6 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5b4:	8b 10                	mov    (%eax),%edx
 5b6:	39 c2                	cmp    %eax,%edx
 5b8:	77 f0                	ja     5aa <free+0x17>
 5ba:	39 c8                	cmp    %ecx,%eax
 5bc:	72 08                	jb     5c6 <free+0x33>
 5be:	39 ca                	cmp    %ecx,%edx
 5c0:	77 04                	ja     5c6 <free+0x33>
 5c2:	89 d0                	mov    %edx,%eax
 5c4:	eb e6                	jmp    5ac <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 5c6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 5c9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 5cc:	8b 10                	mov    (%eax),%edx
 5ce:	39 d7                	cmp    %edx,%edi
 5d0:	74 19                	je     5eb <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 5d2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 5d5:	8b 50 04             	mov    0x4(%eax),%edx
 5d8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 5db:	39 ce                	cmp    %ecx,%esi
 5dd:	74 1b                	je     5fa <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 5df:	89 08                	mov    %ecx,(%eax)
  freep = p;
 5e1:	a3 b8 09 00 00       	mov    %eax,0x9b8
}
 5e6:	5b                   	pop    %ebx
 5e7:	5e                   	pop    %esi
 5e8:	5f                   	pop    %edi
 5e9:	5d                   	pop    %ebp
 5ea:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 5eb:	03 72 04             	add    0x4(%edx),%esi
 5ee:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5f1:	8b 10                	mov    (%eax),%edx
 5f3:	8b 12                	mov    (%edx),%edx
 5f5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5f8:	eb db                	jmp    5d5 <free+0x42>
    p->s.size += bp->s.size;
 5fa:	03 53 fc             	add    -0x4(%ebx),%edx
 5fd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 600:	8b 53 f8             	mov    -0x8(%ebx),%edx
 603:	89 10                	mov    %edx,(%eax)
 605:	eb da                	jmp    5e1 <free+0x4e>

00000607 <morecore>:

static Header*
morecore(uint nu)
{
 607:	55                   	push   %ebp
 608:	89 e5                	mov    %esp,%ebp
 60a:	53                   	push   %ebx
 60b:	83 ec 04             	sub    $0x4,%esp
 60e:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 610:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 615:	77 05                	ja     61c <morecore+0x15>
    nu = 4096;
 617:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 61c:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 623:	83 ec 0c             	sub    $0xc,%esp
 626:	50                   	push   %eax
 627:	e8 39 fd ff ff       	call   365 <sbrk>
  if(p == (char*)-1)
 62c:	83 c4 10             	add    $0x10,%esp
 62f:	83 f8 ff             	cmp    $0xffffffff,%eax
 632:	74 1c                	je     650 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 634:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 637:	83 c0 08             	add    $0x8,%eax
 63a:	83 ec 0c             	sub    $0xc,%esp
 63d:	50                   	push   %eax
 63e:	e8 50 ff ff ff       	call   593 <free>
  return freep;
 643:	a1 b8 09 00 00       	mov    0x9b8,%eax
 648:	83 c4 10             	add    $0x10,%esp
}
 64b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 64e:	c9                   	leave  
 64f:	c3                   	ret    
    return 0;
 650:	b8 00 00 00 00       	mov    $0x0,%eax
 655:	eb f4                	jmp    64b <morecore+0x44>

00000657 <malloc>:

void*
malloc(int nbytes)
{
 657:	f3 0f 1e fb          	endbr32 
 65b:	55                   	push   %ebp
 65c:	89 e5                	mov    %esp,%ebp
 65e:	53                   	push   %ebx
 65f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 662:	8b 45 08             	mov    0x8(%ebp),%eax
 665:	8d 58 07             	lea    0x7(%eax),%ebx
 668:	c1 eb 03             	shr    $0x3,%ebx
 66b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 66e:	8b 0d b8 09 00 00    	mov    0x9b8,%ecx
 674:	85 c9                	test   %ecx,%ecx
 676:	74 04                	je     67c <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 678:	8b 01                	mov    (%ecx),%eax
 67a:	eb 4b                	jmp    6c7 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 67c:	c7 05 b8 09 00 00 bc 	movl   $0x9bc,0x9b8
 683:	09 00 00 
 686:	c7 05 bc 09 00 00 bc 	movl   $0x9bc,0x9bc
 68d:	09 00 00 
    base.s.size = 0;
 690:	c7 05 c0 09 00 00 00 	movl   $0x0,0x9c0
 697:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 69a:	b9 bc 09 00 00       	mov    $0x9bc,%ecx
 69f:	eb d7                	jmp    678 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6a1:	74 1a                	je     6bd <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6a3:	29 da                	sub    %ebx,%edx
 6a5:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6a8:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6ab:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6ae:	89 0d b8 09 00 00    	mov    %ecx,0x9b8
      return (void*)(p + 1);
 6b4:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 6b7:	83 c4 04             	add    $0x4,%esp
 6ba:	5b                   	pop    %ebx
 6bb:	5d                   	pop    %ebp
 6bc:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 6bd:	8b 10                	mov    (%eax),%edx
 6bf:	89 11                	mov    %edx,(%ecx)
 6c1:	eb eb                	jmp    6ae <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c3:	89 c1                	mov    %eax,%ecx
 6c5:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 6c7:	8b 50 04             	mov    0x4(%eax),%edx
 6ca:	39 da                	cmp    %ebx,%edx
 6cc:	73 d3                	jae    6a1 <malloc+0x4a>
    if(p == freep)
 6ce:	39 05 b8 09 00 00    	cmp    %eax,0x9b8
 6d4:	75 ed                	jne    6c3 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 6d6:	89 d8                	mov    %ebx,%eax
 6d8:	e8 2a ff ff ff       	call   607 <morecore>
 6dd:	85 c0                	test   %eax,%eax
 6df:	75 e2                	jne    6c3 <malloc+0x6c>
 6e1:	eb d4                	jmp    6b7 <malloc+0x60>
