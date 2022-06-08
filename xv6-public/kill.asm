
_kill:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 07                	jle    29 <main+0x29>
    printf(2, "usage: kill pid...\n");
    exit();
  }
  for(i=1; i<argc; i++)
  22:	bb 01 00 00 00       	mov    $0x1,%ebx
  27:	eb 2d                	jmp    56 <main+0x56>
    printf(2, "usage: kill pid...\n");
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	68 24 06 00 00       	push   $0x624
  31:	6a 02                	push   $0x2
  33:	e8 2d 03 00 00       	call   365 <printf>
    exit();
  38:	e8 df 01 00 00       	call   21c <exit>
    kill(atoi(argv[i]));
  3d:	83 ec 0c             	sub    $0xc,%esp
  40:	ff 34 9f             	pushl  (%edi,%ebx,4)
  43:	e8 6a 01 00 00       	call   1b2 <atoi>
  48:	89 04 24             	mov    %eax,(%esp)
  4b:	e8 fc 01 00 00       	call   24c <kill>
  for(i=1; i<argc; i++)
  50:	83 c3 01             	add    $0x1,%ebx
  53:	83 c4 10             	add    $0x10,%esp
  56:	39 f3                	cmp    %esi,%ebx
  58:	7c e3                	jl     3d <main+0x3d>
  exit();
  5a:	e8 bd 01 00 00       	call   21c <exit>

0000005f <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  5f:	f3 0f 1e fb          	endbr32 
  63:	55                   	push   %ebp
  64:	89 e5                	mov    %esp,%ebp
  66:	56                   	push   %esi
  67:	53                   	push   %ebx
  68:	8b 75 08             	mov    0x8(%ebp),%esi
  6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  6e:	89 f0                	mov    %esi,%eax
  70:	89 d1                	mov    %edx,%ecx
  72:	83 c2 01             	add    $0x1,%edx
  75:	89 c3                	mov    %eax,%ebx
  77:	83 c0 01             	add    $0x1,%eax
  7a:	0f b6 09             	movzbl (%ecx),%ecx
  7d:	88 0b                	mov    %cl,(%ebx)
  7f:	84 c9                	test   %cl,%cl
  81:	75 ed                	jne    70 <strcpy+0x11>
    ;
  return os;
}
  83:	89 f0                	mov    %esi,%eax
  85:	5b                   	pop    %ebx
  86:	5e                   	pop    %esi
  87:	5d                   	pop    %ebp
  88:	c3                   	ret    

00000089 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  89:	f3 0f 1e fb          	endbr32 
  8d:	55                   	push   %ebp
  8e:	89 e5                	mov    %esp,%ebp
  90:	8b 4d 08             	mov    0x8(%ebp),%ecx
  93:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  96:	0f b6 01             	movzbl (%ecx),%eax
  99:	84 c0                	test   %al,%al
  9b:	74 0c                	je     a9 <strcmp+0x20>
  9d:	3a 02                	cmp    (%edx),%al
  9f:	75 08                	jne    a9 <strcmp+0x20>
    p++, q++;
  a1:	83 c1 01             	add    $0x1,%ecx
  a4:	83 c2 01             	add    $0x1,%edx
  a7:	eb ed                	jmp    96 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  a9:	0f b6 c0             	movzbl %al,%eax
  ac:	0f b6 12             	movzbl (%edx),%edx
  af:	29 d0                	sub    %edx,%eax
}
  b1:	5d                   	pop    %ebp
  b2:	c3                   	ret    

000000b3 <strlen>:

int
strlen(const char *s)
{
  b3:	f3 0f 1e fb          	endbr32 
  b7:	55                   	push   %ebp
  b8:	89 e5                	mov    %esp,%ebp
  ba:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  bd:	b8 00 00 00 00       	mov    $0x0,%eax
  c2:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  c6:	74 05                	je     cd <strlen+0x1a>
  c8:	83 c0 01             	add    $0x1,%eax
  cb:	eb f5                	jmp    c2 <strlen+0xf>
    ;
  return n;
}
  cd:	5d                   	pop    %ebp
  ce:	c3                   	ret    

000000cf <memset>:

void*
memset(void *dst, int c, int n)
{
  cf:	f3 0f 1e fb          	endbr32 
  d3:	55                   	push   %ebp
  d4:	89 e5                	mov    %esp,%ebp
  d6:	57                   	push   %edi
  d7:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  da:	89 d7                	mov    %edx,%edi
  dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  df:	8b 45 0c             	mov    0xc(%ebp),%eax
  e2:	fc                   	cld    
  e3:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e5:	89 d0                	mov    %edx,%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  f8:	0f b6 10             	movzbl (%eax),%edx
  fb:	84 d2                	test   %dl,%dl
  fd:	74 09                	je     108 <strchr+0x1e>
    if(*s == c)
  ff:	38 ca                	cmp    %cl,%dl
 101:	74 0a                	je     10d <strchr+0x23>
  for(; *s; s++)
 103:	83 c0 01             	add    $0x1,%eax
 106:	eb f0                	jmp    f8 <strchr+0xe>
      return (char*)s;
  return 0;
 108:	b8 00 00 00 00       	mov    $0x0,%eax
}
 10d:	5d                   	pop    %ebp
 10e:	c3                   	ret    

0000010f <gets>:

char*
gets(char *buf, int max)
{
 10f:	f3 0f 1e fb          	endbr32 
 113:	55                   	push   %ebp
 114:	89 e5                	mov    %esp,%ebp
 116:	57                   	push   %edi
 117:	56                   	push   %esi
 118:	53                   	push   %ebx
 119:	83 ec 1c             	sub    $0x1c,%esp
 11c:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11f:	bb 00 00 00 00       	mov    $0x0,%ebx
 124:	89 de                	mov    %ebx,%esi
 126:	83 c3 01             	add    $0x1,%ebx
 129:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 12c:	7d 2e                	jge    15c <gets+0x4d>
    cc = read(0, &c, 1);
 12e:	83 ec 04             	sub    $0x4,%esp
 131:	6a 01                	push   $0x1
 133:	8d 45 e7             	lea    -0x19(%ebp),%eax
 136:	50                   	push   %eax
 137:	6a 00                	push   $0x0
 139:	e8 f6 00 00 00       	call   234 <read>
    if(cc < 1)
 13e:	83 c4 10             	add    $0x10,%esp
 141:	85 c0                	test   %eax,%eax
 143:	7e 17                	jle    15c <gets+0x4d>
      break;
    buf[i++] = c;
 145:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 149:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 14c:	3c 0a                	cmp    $0xa,%al
 14e:	0f 94 c2             	sete   %dl
 151:	3c 0d                	cmp    $0xd,%al
 153:	0f 94 c0             	sete   %al
 156:	08 c2                	or     %al,%dl
 158:	74 ca                	je     124 <gets+0x15>
    buf[i++] = c;
 15a:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 15c:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 160:	89 f8                	mov    %edi,%eax
 162:	8d 65 f4             	lea    -0xc(%ebp),%esp
 165:	5b                   	pop    %ebx
 166:	5e                   	pop    %esi
 167:	5f                   	pop    %edi
 168:	5d                   	pop    %ebp
 169:	c3                   	ret    

0000016a <stat>:

int
stat(const char *n, struct stat *st)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 173:	83 ec 08             	sub    $0x8,%esp
 176:	6a 00                	push   $0x0
 178:	ff 75 08             	pushl  0x8(%ebp)
 17b:	e8 dc 00 00 00       	call   25c <open>
  if(fd < 0)
 180:	83 c4 10             	add    $0x10,%esp
 183:	85 c0                	test   %eax,%eax
 185:	78 24                	js     1ab <stat+0x41>
 187:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 189:	83 ec 08             	sub    $0x8,%esp
 18c:	ff 75 0c             	pushl  0xc(%ebp)
 18f:	50                   	push   %eax
 190:	e8 df 00 00 00       	call   274 <fstat>
 195:	89 c6                	mov    %eax,%esi
  close(fd);
 197:	89 1c 24             	mov    %ebx,(%esp)
 19a:	e8 a5 00 00 00       	call   244 <close>
  return r;
 19f:	83 c4 10             	add    $0x10,%esp
}
 1a2:	89 f0                	mov    %esi,%eax
 1a4:	8d 65 f8             	lea    -0x8(%ebp),%esp
 1a7:	5b                   	pop    %ebx
 1a8:	5e                   	pop    %esi
 1a9:	5d                   	pop    %ebp
 1aa:	c3                   	ret    
    return -1;
 1ab:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1b0:	eb f0                	jmp    1a2 <stat+0x38>

000001b2 <atoi>:

int
atoi(const char *s)
{
 1b2:	f3 0f 1e fb          	endbr32 
 1b6:	55                   	push   %ebp
 1b7:	89 e5                	mov    %esp,%ebp
 1b9:	53                   	push   %ebx
 1ba:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1bd:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1c2:	0f b6 01             	movzbl (%ecx),%eax
 1c5:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1c8:	80 fb 09             	cmp    $0x9,%bl
 1cb:	77 12                	ja     1df <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1cd:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1d0:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1d3:	83 c1 01             	add    $0x1,%ecx
 1d6:	0f be c0             	movsbl %al,%eax
 1d9:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1dd:	eb e3                	jmp    1c2 <atoi+0x10>
  return n;
}
 1df:	89 d0                	mov    %edx,%eax
 1e1:	5b                   	pop    %ebx
 1e2:	5d                   	pop    %ebp
 1e3:	c3                   	ret    

000001e4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e4:	f3 0f 1e fb          	endbr32 
 1e8:	55                   	push   %ebp
 1e9:	89 e5                	mov    %esp,%ebp
 1eb:	56                   	push   %esi
 1ec:	53                   	push   %ebx
 1ed:	8b 75 08             	mov    0x8(%ebp),%esi
 1f0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1f3:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1f6:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1f8:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1fb:	85 c0                	test   %eax,%eax
 1fd:	7e 0f                	jle    20e <memmove+0x2a>
    *dst++ = *src++;
 1ff:	0f b6 01             	movzbl (%ecx),%eax
 202:	88 02                	mov    %al,(%edx)
 204:	8d 49 01             	lea    0x1(%ecx),%ecx
 207:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 20a:	89 d8                	mov    %ebx,%eax
 20c:	eb ea                	jmp    1f8 <memmove+0x14>
  return vdst;
}
 20e:	89 f0                	mov    %esi,%eax
 210:	5b                   	pop    %ebx
 211:	5e                   	pop    %esi
 212:	5d                   	pop    %ebp
 213:	c3                   	ret    

00000214 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 214:	b8 01 00 00 00       	mov    $0x1,%eax
 219:	cd 40                	int    $0x40
 21b:	c3                   	ret    

0000021c <exit>:
SYSCALL(exit)
 21c:	b8 02 00 00 00       	mov    $0x2,%eax
 221:	cd 40                	int    $0x40
 223:	c3                   	ret    

00000224 <wait>:
SYSCALL(wait)
 224:	b8 03 00 00 00       	mov    $0x3,%eax
 229:	cd 40                	int    $0x40
 22b:	c3                   	ret    

0000022c <pipe>:
SYSCALL(pipe)
 22c:	b8 04 00 00 00       	mov    $0x4,%eax
 231:	cd 40                	int    $0x40
 233:	c3                   	ret    

00000234 <read>:
SYSCALL(read)
 234:	b8 05 00 00 00       	mov    $0x5,%eax
 239:	cd 40                	int    $0x40
 23b:	c3                   	ret    

0000023c <write>:
SYSCALL(write)
 23c:	b8 10 00 00 00       	mov    $0x10,%eax
 241:	cd 40                	int    $0x40
 243:	c3                   	ret    

00000244 <close>:
SYSCALL(close)
 244:	b8 15 00 00 00       	mov    $0x15,%eax
 249:	cd 40                	int    $0x40
 24b:	c3                   	ret    

0000024c <kill>:
SYSCALL(kill)
 24c:	b8 06 00 00 00       	mov    $0x6,%eax
 251:	cd 40                	int    $0x40
 253:	c3                   	ret    

00000254 <exec>:
SYSCALL(exec)
 254:	b8 07 00 00 00       	mov    $0x7,%eax
 259:	cd 40                	int    $0x40
 25b:	c3                   	ret    

0000025c <open>:
SYSCALL(open)
 25c:	b8 0f 00 00 00       	mov    $0xf,%eax
 261:	cd 40                	int    $0x40
 263:	c3                   	ret    

00000264 <mknod>:
SYSCALL(mknod)
 264:	b8 11 00 00 00       	mov    $0x11,%eax
 269:	cd 40                	int    $0x40
 26b:	c3                   	ret    

0000026c <unlink>:
SYSCALL(unlink)
 26c:	b8 12 00 00 00       	mov    $0x12,%eax
 271:	cd 40                	int    $0x40
 273:	c3                   	ret    

00000274 <fstat>:
SYSCALL(fstat)
 274:	b8 08 00 00 00       	mov    $0x8,%eax
 279:	cd 40                	int    $0x40
 27b:	c3                   	ret    

0000027c <link>:
SYSCALL(link)
 27c:	b8 13 00 00 00       	mov    $0x13,%eax
 281:	cd 40                	int    $0x40
 283:	c3                   	ret    

00000284 <mkdir>:
SYSCALL(mkdir)
 284:	b8 14 00 00 00       	mov    $0x14,%eax
 289:	cd 40                	int    $0x40
 28b:	c3                   	ret    

0000028c <chdir>:
SYSCALL(chdir)
 28c:	b8 09 00 00 00       	mov    $0x9,%eax
 291:	cd 40                	int    $0x40
 293:	c3                   	ret    

00000294 <dup>:
SYSCALL(dup)
 294:	b8 0a 00 00 00       	mov    $0xa,%eax
 299:	cd 40                	int    $0x40
 29b:	c3                   	ret    

0000029c <getpid>:
SYSCALL(getpid)
 29c:	b8 0b 00 00 00       	mov    $0xb,%eax
 2a1:	cd 40                	int    $0x40
 2a3:	c3                   	ret    

000002a4 <sbrk>:
SYSCALL(sbrk)
 2a4:	b8 0c 00 00 00       	mov    $0xc,%eax
 2a9:	cd 40                	int    $0x40
 2ab:	c3                   	ret    

000002ac <sleep>:
SYSCALL(sleep)
 2ac:	b8 0d 00 00 00       	mov    $0xd,%eax
 2b1:	cd 40                	int    $0x40
 2b3:	c3                   	ret    

000002b4 <uptime>:
SYSCALL(uptime)
 2b4:	b8 0e 00 00 00       	mov    $0xe,%eax
 2b9:	cd 40                	int    $0x40
 2bb:	c3                   	ret    

000002bc <getiocounts>:
SYSCALL(getiocounts)
 2bc:	b8 16 00 00 00       	mov    $0x16,%eax
 2c1:	cd 40                	int    $0x40
 2c3:	c3                   	ret    

000002c4 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2c4:	55                   	push   %ebp
 2c5:	89 e5                	mov    %esp,%ebp
 2c7:	83 ec 1c             	sub    $0x1c,%esp
 2ca:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2cd:	6a 01                	push   $0x1
 2cf:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2d2:	52                   	push   %edx
 2d3:	50                   	push   %eax
 2d4:	e8 63 ff ff ff       	call   23c <write>
}
 2d9:	83 c4 10             	add    $0x10,%esp
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2de:	55                   	push   %ebp
 2df:	89 e5                	mov    %esp,%ebp
 2e1:	57                   	push   %edi
 2e2:	56                   	push   %esi
 2e3:	53                   	push   %ebx
 2e4:	83 ec 2c             	sub    $0x2c,%esp
 2e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2ea:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2f0:	0f 95 c2             	setne  %dl
 2f3:	89 f0                	mov    %esi,%eax
 2f5:	c1 e8 1f             	shr    $0x1f,%eax
 2f8:	84 c2                	test   %al,%dl
 2fa:	74 42                	je     33e <printint+0x60>
    neg = 1;
    x = -xx;
 2fc:	f7 de                	neg    %esi
    neg = 1;
 2fe:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 305:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 30a:	89 f0                	mov    %esi,%eax
 30c:	ba 00 00 00 00       	mov    $0x0,%edx
 311:	f7 f1                	div    %ecx
 313:	89 df                	mov    %ebx,%edi
 315:	83 c3 01             	add    $0x1,%ebx
 318:	0f b6 92 40 06 00 00 	movzbl 0x640(%edx),%edx
 31f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 323:	89 f2                	mov    %esi,%edx
 325:	89 c6                	mov    %eax,%esi
 327:	39 d1                	cmp    %edx,%ecx
 329:	76 df                	jbe    30a <printint+0x2c>
  if(neg)
 32b:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 32f:	74 2f                	je     360 <printint+0x82>
    buf[i++] = '-';
 331:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 336:	8d 5f 02             	lea    0x2(%edi),%ebx
 339:	8b 75 d0             	mov    -0x30(%ebp),%esi
 33c:	eb 15                	jmp    353 <printint+0x75>
  neg = 0;
 33e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 345:	eb be                	jmp    305 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 347:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 34c:	89 f0                	mov    %esi,%eax
 34e:	e8 71 ff ff ff       	call   2c4 <putc>
  while(--i >= 0)
 353:	83 eb 01             	sub    $0x1,%ebx
 356:	79 ef                	jns    347 <printint+0x69>
}
 358:	83 c4 2c             	add    $0x2c,%esp
 35b:	5b                   	pop    %ebx
 35c:	5e                   	pop    %esi
 35d:	5f                   	pop    %edi
 35e:	5d                   	pop    %ebp
 35f:	c3                   	ret    
 360:	8b 75 d0             	mov    -0x30(%ebp),%esi
 363:	eb ee                	jmp    353 <printint+0x75>

00000365 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 365:	f3 0f 1e fb          	endbr32 
 369:	55                   	push   %ebp
 36a:	89 e5                	mov    %esp,%ebp
 36c:	57                   	push   %edi
 36d:	56                   	push   %esi
 36e:	53                   	push   %ebx
 36f:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 372:	8d 45 10             	lea    0x10(%ebp),%eax
 375:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 378:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 37d:	bb 00 00 00 00       	mov    $0x0,%ebx
 382:	eb 14                	jmp    398 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 384:	89 fa                	mov    %edi,%edx
 386:	8b 45 08             	mov    0x8(%ebp),%eax
 389:	e8 36 ff ff ff       	call   2c4 <putc>
 38e:	eb 05                	jmp    395 <printf+0x30>
      }
    } else if(state == '%'){
 390:	83 fe 25             	cmp    $0x25,%esi
 393:	74 25                	je     3ba <printf+0x55>
  for(i = 0; fmt[i]; i++){
 395:	83 c3 01             	add    $0x1,%ebx
 398:	8b 45 0c             	mov    0xc(%ebp),%eax
 39b:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 39f:	84 c0                	test   %al,%al
 3a1:	0f 84 23 01 00 00    	je     4ca <printf+0x165>
    c = fmt[i] & 0xff;
 3a7:	0f be f8             	movsbl %al,%edi
 3aa:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3ad:	85 f6                	test   %esi,%esi
 3af:	75 df                	jne    390 <printf+0x2b>
      if(c == '%'){
 3b1:	83 f8 25             	cmp    $0x25,%eax
 3b4:	75 ce                	jne    384 <printf+0x1f>
        state = '%';
 3b6:	89 c6                	mov    %eax,%esi
 3b8:	eb db                	jmp    395 <printf+0x30>
      if(c == 'd'){
 3ba:	83 f8 64             	cmp    $0x64,%eax
 3bd:	74 49                	je     408 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3bf:	83 f8 78             	cmp    $0x78,%eax
 3c2:	0f 94 c1             	sete   %cl
 3c5:	83 f8 70             	cmp    $0x70,%eax
 3c8:	0f 94 c2             	sete   %dl
 3cb:	08 d1                	or     %dl,%cl
 3cd:	75 63                	jne    432 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3cf:	83 f8 73             	cmp    $0x73,%eax
 3d2:	0f 84 84 00 00 00    	je     45c <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3d8:	83 f8 63             	cmp    $0x63,%eax
 3db:	0f 84 b7 00 00 00    	je     498 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3e1:	83 f8 25             	cmp    $0x25,%eax
 3e4:	0f 84 cc 00 00 00    	je     4b6 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3ea:	ba 25 00 00 00       	mov    $0x25,%edx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	e8 cd fe ff ff       	call   2c4 <putc>
        putc(fd, c);
 3f7:	89 fa                	mov    %edi,%edx
 3f9:	8b 45 08             	mov    0x8(%ebp),%eax
 3fc:	e8 c3 fe ff ff       	call   2c4 <putc>
      }
      state = 0;
 401:	be 00 00 00 00       	mov    $0x0,%esi
 406:	eb 8d                	jmp    395 <printf+0x30>
        printint(fd, *ap, 10, 1);
 408:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 40b:	8b 17                	mov    (%edi),%edx
 40d:	83 ec 0c             	sub    $0xc,%esp
 410:	6a 01                	push   $0x1
 412:	b9 0a 00 00 00       	mov    $0xa,%ecx
 417:	8b 45 08             	mov    0x8(%ebp),%eax
 41a:	e8 bf fe ff ff       	call   2de <printint>
        ap++;
 41f:	83 c7 04             	add    $0x4,%edi
 422:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 425:	83 c4 10             	add    $0x10,%esp
      state = 0;
 428:	be 00 00 00 00       	mov    $0x0,%esi
 42d:	e9 63 ff ff ff       	jmp    395 <printf+0x30>
        printint(fd, *ap, 16, 0);
 432:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 435:	8b 17                	mov    (%edi),%edx
 437:	83 ec 0c             	sub    $0xc,%esp
 43a:	6a 00                	push   $0x0
 43c:	b9 10 00 00 00       	mov    $0x10,%ecx
 441:	8b 45 08             	mov    0x8(%ebp),%eax
 444:	e8 95 fe ff ff       	call   2de <printint>
        ap++;
 449:	83 c7 04             	add    $0x4,%edi
 44c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 44f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 452:	be 00 00 00 00       	mov    $0x0,%esi
 457:	e9 39 ff ff ff       	jmp    395 <printf+0x30>
        s = (char*)*ap;
 45c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 45f:	8b 30                	mov    (%eax),%esi
        ap++;
 461:	83 c0 04             	add    $0x4,%eax
 464:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 467:	85 f6                	test   %esi,%esi
 469:	75 28                	jne    493 <printf+0x12e>
          s = "(null)";
 46b:	be 38 06 00 00       	mov    $0x638,%esi
 470:	8b 7d 08             	mov    0x8(%ebp),%edi
 473:	eb 0d                	jmp    482 <printf+0x11d>
          putc(fd, *s);
 475:	0f be d2             	movsbl %dl,%edx
 478:	89 f8                	mov    %edi,%eax
 47a:	e8 45 fe ff ff       	call   2c4 <putc>
          s++;
 47f:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 482:	0f b6 16             	movzbl (%esi),%edx
 485:	84 d2                	test   %dl,%dl
 487:	75 ec                	jne    475 <printf+0x110>
      state = 0;
 489:	be 00 00 00 00       	mov    $0x0,%esi
 48e:	e9 02 ff ff ff       	jmp    395 <printf+0x30>
 493:	8b 7d 08             	mov    0x8(%ebp),%edi
 496:	eb ea                	jmp    482 <printf+0x11d>
        putc(fd, *ap);
 498:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 49b:	0f be 17             	movsbl (%edi),%edx
 49e:	8b 45 08             	mov    0x8(%ebp),%eax
 4a1:	e8 1e fe ff ff       	call   2c4 <putc>
        ap++;
 4a6:	83 c7 04             	add    $0x4,%edi
 4a9:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4ac:	be 00 00 00 00       	mov    $0x0,%esi
 4b1:	e9 df fe ff ff       	jmp    395 <printf+0x30>
        putc(fd, c);
 4b6:	89 fa                	mov    %edi,%edx
 4b8:	8b 45 08             	mov    0x8(%ebp),%eax
 4bb:	e8 04 fe ff ff       	call   2c4 <putc>
      state = 0;
 4c0:	be 00 00 00 00       	mov    $0x0,%esi
 4c5:	e9 cb fe ff ff       	jmp    395 <printf+0x30>
    }
  }
}
 4ca:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4cd:	5b                   	pop    %ebx
 4ce:	5e                   	pop    %esi
 4cf:	5f                   	pop    %edi
 4d0:	5d                   	pop    %ebp
 4d1:	c3                   	ret    

000004d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4d2:	f3 0f 1e fb          	endbr32 
 4d6:	55                   	push   %ebp
 4d7:	89 e5                	mov    %esp,%ebp
 4d9:	57                   	push   %edi
 4da:	56                   	push   %esi
 4db:	53                   	push   %ebx
 4dc:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4df:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4e2:	a1 ec 08 00 00       	mov    0x8ec,%eax
 4e7:	eb 02                	jmp    4eb <free+0x19>
 4e9:	89 d0                	mov    %edx,%eax
 4eb:	39 c8                	cmp    %ecx,%eax
 4ed:	73 04                	jae    4f3 <free+0x21>
 4ef:	39 08                	cmp    %ecx,(%eax)
 4f1:	77 12                	ja     505 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4f3:	8b 10                	mov    (%eax),%edx
 4f5:	39 c2                	cmp    %eax,%edx
 4f7:	77 f0                	ja     4e9 <free+0x17>
 4f9:	39 c8                	cmp    %ecx,%eax
 4fb:	72 08                	jb     505 <free+0x33>
 4fd:	39 ca                	cmp    %ecx,%edx
 4ff:	77 04                	ja     505 <free+0x33>
 501:	89 d0                	mov    %edx,%eax
 503:	eb e6                	jmp    4eb <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 505:	8b 73 fc             	mov    -0x4(%ebx),%esi
 508:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 50b:	8b 10                	mov    (%eax),%edx
 50d:	39 d7                	cmp    %edx,%edi
 50f:	74 19                	je     52a <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 511:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 514:	8b 50 04             	mov    0x4(%eax),%edx
 517:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 51a:	39 ce                	cmp    %ecx,%esi
 51c:	74 1b                	je     539 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 51e:	89 08                	mov    %ecx,(%eax)
  freep = p;
 520:	a3 ec 08 00 00       	mov    %eax,0x8ec
}
 525:	5b                   	pop    %ebx
 526:	5e                   	pop    %esi
 527:	5f                   	pop    %edi
 528:	5d                   	pop    %ebp
 529:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 52a:	03 72 04             	add    0x4(%edx),%esi
 52d:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 530:	8b 10                	mov    (%eax),%edx
 532:	8b 12                	mov    (%edx),%edx
 534:	89 53 f8             	mov    %edx,-0x8(%ebx)
 537:	eb db                	jmp    514 <free+0x42>
    p->s.size += bp->s.size;
 539:	03 53 fc             	add    -0x4(%ebx),%edx
 53c:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 53f:	8b 53 f8             	mov    -0x8(%ebx),%edx
 542:	89 10                	mov    %edx,(%eax)
 544:	eb da                	jmp    520 <free+0x4e>

00000546 <morecore>:

static Header*
morecore(uint nu)
{
 546:	55                   	push   %ebp
 547:	89 e5                	mov    %esp,%ebp
 549:	53                   	push   %ebx
 54a:	83 ec 04             	sub    $0x4,%esp
 54d:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 54f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 554:	77 05                	ja     55b <morecore+0x15>
    nu = 4096;
 556:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 55b:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 562:	83 ec 0c             	sub    $0xc,%esp
 565:	50                   	push   %eax
 566:	e8 39 fd ff ff       	call   2a4 <sbrk>
  if(p == (char*)-1)
 56b:	83 c4 10             	add    $0x10,%esp
 56e:	83 f8 ff             	cmp    $0xffffffff,%eax
 571:	74 1c                	je     58f <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 573:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 576:	83 c0 08             	add    $0x8,%eax
 579:	83 ec 0c             	sub    $0xc,%esp
 57c:	50                   	push   %eax
 57d:	e8 50 ff ff ff       	call   4d2 <free>
  return freep;
 582:	a1 ec 08 00 00       	mov    0x8ec,%eax
 587:	83 c4 10             	add    $0x10,%esp
}
 58a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 58d:	c9                   	leave  
 58e:	c3                   	ret    
    return 0;
 58f:	b8 00 00 00 00       	mov    $0x0,%eax
 594:	eb f4                	jmp    58a <morecore+0x44>

00000596 <malloc>:

void*
malloc(int nbytes)
{
 596:	f3 0f 1e fb          	endbr32 
 59a:	55                   	push   %ebp
 59b:	89 e5                	mov    %esp,%ebp
 59d:	53                   	push   %ebx
 59e:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 5a1:	8b 45 08             	mov    0x8(%ebp),%eax
 5a4:	8d 58 07             	lea    0x7(%eax),%ebx
 5a7:	c1 eb 03             	shr    $0x3,%ebx
 5aa:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5ad:	8b 0d ec 08 00 00    	mov    0x8ec,%ecx
 5b3:	85 c9                	test   %ecx,%ecx
 5b5:	74 04                	je     5bb <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5b7:	8b 01                	mov    (%ecx),%eax
 5b9:	eb 4b                	jmp    606 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5bb:	c7 05 ec 08 00 00 f0 	movl   $0x8f0,0x8ec
 5c2:	08 00 00 
 5c5:	c7 05 f0 08 00 00 f0 	movl   $0x8f0,0x8f0
 5cc:	08 00 00 
    base.s.size = 0;
 5cf:	c7 05 f4 08 00 00 00 	movl   $0x0,0x8f4
 5d6:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5d9:	b9 f0 08 00 00       	mov    $0x8f0,%ecx
 5de:	eb d7                	jmp    5b7 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5e0:	74 1a                	je     5fc <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5e2:	29 da                	sub    %ebx,%edx
 5e4:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5e7:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5ea:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5ed:	89 0d ec 08 00 00    	mov    %ecx,0x8ec
      return (void*)(p + 1);
 5f3:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5f6:	83 c4 04             	add    $0x4,%esp
 5f9:	5b                   	pop    %ebx
 5fa:	5d                   	pop    %ebp
 5fb:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5fc:	8b 10                	mov    (%eax),%edx
 5fe:	89 11                	mov    %edx,(%ecx)
 600:	eb eb                	jmp    5ed <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 602:	89 c1                	mov    %eax,%ecx
 604:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 606:	8b 50 04             	mov    0x4(%eax),%edx
 609:	39 da                	cmp    %ebx,%edx
 60b:	73 d3                	jae    5e0 <malloc+0x4a>
    if(p == freep)
 60d:	39 05 ec 08 00 00    	cmp    %eax,0x8ec
 613:	75 ed                	jne    602 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 615:	89 d8                	mov    %ebx,%eax
 617:	e8 2a ff ff ff       	call   546 <morecore>
 61c:	85 c0                	test   %eax,%eax
 61e:	75 e2                	jne    602 <malloc+0x6c>
 620:	eb d4                	jmp    5f6 <malloc+0x60>
