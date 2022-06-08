
_echo:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char *argv[])
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

  for(i = 1; i < argc; i++)
  1d:	b8 01 00 00 00       	mov    $0x1,%eax
  22:	eb 1a                	jmp    3e <main+0x3e>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  24:	ba 18 06 00 00       	mov    $0x618,%edx
  29:	52                   	push   %edx
  2a:	ff 34 87             	pushl  (%edi,%eax,4)
  2d:	68 1c 06 00 00       	push   $0x61c
  32:	6a 01                	push   $0x1
  34:	e8 22 03 00 00       	call   35b <printf>
  39:	83 c4 10             	add    $0x10,%esp
  for(i = 1; i < argc; i++)
  3c:	89 d8                	mov    %ebx,%eax
  3e:	39 f0                	cmp    %esi,%eax
  40:	7d 0e                	jge    50 <main+0x50>
    printf(1, "%s%s", argv[i], i+1 < argc ? " " : "\n");
  42:	8d 58 01             	lea    0x1(%eax),%ebx
  45:	39 f3                	cmp    %esi,%ebx
  47:	7d db                	jge    24 <main+0x24>
  49:	ba 1a 06 00 00       	mov    $0x61a,%edx
  4e:	eb d9                	jmp    29 <main+0x29>
  exit();
  50:	e8 bd 01 00 00       	call   212 <exit>

00000055 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  55:	f3 0f 1e fb          	endbr32 
  59:	55                   	push   %ebp
  5a:	89 e5                	mov    %esp,%ebp
  5c:	56                   	push   %esi
  5d:	53                   	push   %ebx
  5e:	8b 75 08             	mov    0x8(%ebp),%esi
  61:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  64:	89 f0                	mov    %esi,%eax
  66:	89 d1                	mov    %edx,%ecx
  68:	83 c2 01             	add    $0x1,%edx
  6b:	89 c3                	mov    %eax,%ebx
  6d:	83 c0 01             	add    $0x1,%eax
  70:	0f b6 09             	movzbl (%ecx),%ecx
  73:	88 0b                	mov    %cl,(%ebx)
  75:	84 c9                	test   %cl,%cl
  77:	75 ed                	jne    66 <strcpy+0x11>
    ;
  return os;
}
  79:	89 f0                	mov    %esi,%eax
  7b:	5b                   	pop    %ebx
  7c:	5e                   	pop    %esi
  7d:	5d                   	pop    %ebp
  7e:	c3                   	ret    

0000007f <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7f:	f3 0f 1e fb          	endbr32 
  83:	55                   	push   %ebp
  84:	89 e5                	mov    %esp,%ebp
  86:	8b 4d 08             	mov    0x8(%ebp),%ecx
  89:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  8c:	0f b6 01             	movzbl (%ecx),%eax
  8f:	84 c0                	test   %al,%al
  91:	74 0c                	je     9f <strcmp+0x20>
  93:	3a 02                	cmp    (%edx),%al
  95:	75 08                	jne    9f <strcmp+0x20>
    p++, q++;
  97:	83 c1 01             	add    $0x1,%ecx
  9a:	83 c2 01             	add    $0x1,%edx
  9d:	eb ed                	jmp    8c <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  9f:	0f b6 c0             	movzbl %al,%eax
  a2:	0f b6 12             	movzbl (%edx),%edx
  a5:	29 d0                	sub    %edx,%eax
}
  a7:	5d                   	pop    %ebp
  a8:	c3                   	ret    

000000a9 <strlen>:

int
strlen(const char *s)
{
  a9:	f3 0f 1e fb          	endbr32 
  ad:	55                   	push   %ebp
  ae:	89 e5                	mov    %esp,%ebp
  b0:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  b3:	b8 00 00 00 00       	mov    $0x0,%eax
  b8:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  bc:	74 05                	je     c3 <strlen+0x1a>
  be:	83 c0 01             	add    $0x1,%eax
  c1:	eb f5                	jmp    b8 <strlen+0xf>
    ;
  return n;
}
  c3:	5d                   	pop    %ebp
  c4:	c3                   	ret    

000000c5 <memset>:

void*
memset(void *dst, int c, int n)
{
  c5:	f3 0f 1e fb          	endbr32 
  c9:	55                   	push   %ebp
  ca:	89 e5                	mov    %esp,%ebp
  cc:	57                   	push   %edi
  cd:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d0:	89 d7                	mov    %edx,%edi
  d2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  d8:	fc                   	cld    
  d9:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  db:	89 d0                	mov    %edx,%eax
  dd:	5f                   	pop    %edi
  de:	5d                   	pop    %ebp
  df:	c3                   	ret    

000000e0 <strchr>:

char*
strchr(const char *s, char c)
{
  e0:	f3 0f 1e fb          	endbr32 
  e4:	55                   	push   %ebp
  e5:	89 e5                	mov    %esp,%ebp
  e7:	8b 45 08             	mov    0x8(%ebp),%eax
  ea:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  ee:	0f b6 10             	movzbl (%eax),%edx
  f1:	84 d2                	test   %dl,%dl
  f3:	74 09                	je     fe <strchr+0x1e>
    if(*s == c)
  f5:	38 ca                	cmp    %cl,%dl
  f7:	74 0a                	je     103 <strchr+0x23>
  for(; *s; s++)
  f9:	83 c0 01             	add    $0x1,%eax
  fc:	eb f0                	jmp    ee <strchr+0xe>
      return (char*)s;
  return 0;
  fe:	b8 00 00 00 00       	mov    $0x0,%eax
}
 103:	5d                   	pop    %ebp
 104:	c3                   	ret    

00000105 <gets>:

char*
gets(char *buf, int max)
{
 105:	f3 0f 1e fb          	endbr32 
 109:	55                   	push   %ebp
 10a:	89 e5                	mov    %esp,%ebp
 10c:	57                   	push   %edi
 10d:	56                   	push   %esi
 10e:	53                   	push   %ebx
 10f:	83 ec 1c             	sub    $0x1c,%esp
 112:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 115:	bb 00 00 00 00       	mov    $0x0,%ebx
 11a:	89 de                	mov    %ebx,%esi
 11c:	83 c3 01             	add    $0x1,%ebx
 11f:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 122:	7d 2e                	jge    152 <gets+0x4d>
    cc = read(0, &c, 1);
 124:	83 ec 04             	sub    $0x4,%esp
 127:	6a 01                	push   $0x1
 129:	8d 45 e7             	lea    -0x19(%ebp),%eax
 12c:	50                   	push   %eax
 12d:	6a 00                	push   $0x0
 12f:	e8 f6 00 00 00       	call   22a <read>
    if(cc < 1)
 134:	83 c4 10             	add    $0x10,%esp
 137:	85 c0                	test   %eax,%eax
 139:	7e 17                	jle    152 <gets+0x4d>
      break;
    buf[i++] = c;
 13b:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 13f:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 142:	3c 0a                	cmp    $0xa,%al
 144:	0f 94 c2             	sete   %dl
 147:	3c 0d                	cmp    $0xd,%al
 149:	0f 94 c0             	sete   %al
 14c:	08 c2                	or     %al,%dl
 14e:	74 ca                	je     11a <gets+0x15>
    buf[i++] = c;
 150:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 152:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 156:	89 f8                	mov    %edi,%eax
 158:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15b:	5b                   	pop    %ebx
 15c:	5e                   	pop    %esi
 15d:	5f                   	pop    %edi
 15e:	5d                   	pop    %ebp
 15f:	c3                   	ret    

00000160 <stat>:

int
stat(const char *n, struct stat *st)
{
 160:	f3 0f 1e fb          	endbr32 
 164:	55                   	push   %ebp
 165:	89 e5                	mov    %esp,%ebp
 167:	56                   	push   %esi
 168:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 169:	83 ec 08             	sub    $0x8,%esp
 16c:	6a 00                	push   $0x0
 16e:	ff 75 08             	pushl  0x8(%ebp)
 171:	e8 dc 00 00 00       	call   252 <open>
  if(fd < 0)
 176:	83 c4 10             	add    $0x10,%esp
 179:	85 c0                	test   %eax,%eax
 17b:	78 24                	js     1a1 <stat+0x41>
 17d:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 17f:	83 ec 08             	sub    $0x8,%esp
 182:	ff 75 0c             	pushl  0xc(%ebp)
 185:	50                   	push   %eax
 186:	e8 df 00 00 00       	call   26a <fstat>
 18b:	89 c6                	mov    %eax,%esi
  close(fd);
 18d:	89 1c 24             	mov    %ebx,(%esp)
 190:	e8 a5 00 00 00       	call   23a <close>
  return r;
 195:	83 c4 10             	add    $0x10,%esp
}
 198:	89 f0                	mov    %esi,%eax
 19a:	8d 65 f8             	lea    -0x8(%ebp),%esp
 19d:	5b                   	pop    %ebx
 19e:	5e                   	pop    %esi
 19f:	5d                   	pop    %ebp
 1a0:	c3                   	ret    
    return -1;
 1a1:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a6:	eb f0                	jmp    198 <stat+0x38>

000001a8 <atoi>:

int
atoi(const char *s)
{
 1a8:	f3 0f 1e fb          	endbr32 
 1ac:	55                   	push   %ebp
 1ad:	89 e5                	mov    %esp,%ebp
 1af:	53                   	push   %ebx
 1b0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b3:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1b8:	0f b6 01             	movzbl (%ecx),%eax
 1bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1be:	80 fb 09             	cmp    $0x9,%bl
 1c1:	77 12                	ja     1d5 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 1c3:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 1c6:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 1c9:	83 c1 01             	add    $0x1,%ecx
 1cc:	0f be c0             	movsbl %al,%eax
 1cf:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 1d3:	eb e3                	jmp    1b8 <atoi+0x10>
  return n;
}
 1d5:	89 d0                	mov    %edx,%eax
 1d7:	5b                   	pop    %ebx
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1da:	f3 0f 1e fb          	endbr32 
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	56                   	push   %esi
 1e2:	53                   	push   %ebx
 1e3:	8b 75 08             	mov    0x8(%ebp),%esi
 1e6:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 1e9:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 1ec:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 1ee:	8d 58 ff             	lea    -0x1(%eax),%ebx
 1f1:	85 c0                	test   %eax,%eax
 1f3:	7e 0f                	jle    204 <memmove+0x2a>
    *dst++ = *src++;
 1f5:	0f b6 01             	movzbl (%ecx),%eax
 1f8:	88 02                	mov    %al,(%edx)
 1fa:	8d 49 01             	lea    0x1(%ecx),%ecx
 1fd:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 200:	89 d8                	mov    %ebx,%eax
 202:	eb ea                	jmp    1ee <memmove+0x14>
  return vdst;
}
 204:	89 f0                	mov    %esi,%eax
 206:	5b                   	pop    %ebx
 207:	5e                   	pop    %esi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 20a:	b8 01 00 00 00       	mov    $0x1,%eax
 20f:	cd 40                	int    $0x40
 211:	c3                   	ret    

00000212 <exit>:
SYSCALL(exit)
 212:	b8 02 00 00 00       	mov    $0x2,%eax
 217:	cd 40                	int    $0x40
 219:	c3                   	ret    

0000021a <wait>:
SYSCALL(wait)
 21a:	b8 03 00 00 00       	mov    $0x3,%eax
 21f:	cd 40                	int    $0x40
 221:	c3                   	ret    

00000222 <pipe>:
SYSCALL(pipe)
 222:	b8 04 00 00 00       	mov    $0x4,%eax
 227:	cd 40                	int    $0x40
 229:	c3                   	ret    

0000022a <read>:
SYSCALL(read)
 22a:	b8 05 00 00 00       	mov    $0x5,%eax
 22f:	cd 40                	int    $0x40
 231:	c3                   	ret    

00000232 <write>:
SYSCALL(write)
 232:	b8 10 00 00 00       	mov    $0x10,%eax
 237:	cd 40                	int    $0x40
 239:	c3                   	ret    

0000023a <close>:
SYSCALL(close)
 23a:	b8 15 00 00 00       	mov    $0x15,%eax
 23f:	cd 40                	int    $0x40
 241:	c3                   	ret    

00000242 <kill>:
SYSCALL(kill)
 242:	b8 06 00 00 00       	mov    $0x6,%eax
 247:	cd 40                	int    $0x40
 249:	c3                   	ret    

0000024a <exec>:
SYSCALL(exec)
 24a:	b8 07 00 00 00       	mov    $0x7,%eax
 24f:	cd 40                	int    $0x40
 251:	c3                   	ret    

00000252 <open>:
SYSCALL(open)
 252:	b8 0f 00 00 00       	mov    $0xf,%eax
 257:	cd 40                	int    $0x40
 259:	c3                   	ret    

0000025a <mknod>:
SYSCALL(mknod)
 25a:	b8 11 00 00 00       	mov    $0x11,%eax
 25f:	cd 40                	int    $0x40
 261:	c3                   	ret    

00000262 <unlink>:
SYSCALL(unlink)
 262:	b8 12 00 00 00       	mov    $0x12,%eax
 267:	cd 40                	int    $0x40
 269:	c3                   	ret    

0000026a <fstat>:
SYSCALL(fstat)
 26a:	b8 08 00 00 00       	mov    $0x8,%eax
 26f:	cd 40                	int    $0x40
 271:	c3                   	ret    

00000272 <link>:
SYSCALL(link)
 272:	b8 13 00 00 00       	mov    $0x13,%eax
 277:	cd 40                	int    $0x40
 279:	c3                   	ret    

0000027a <mkdir>:
SYSCALL(mkdir)
 27a:	b8 14 00 00 00       	mov    $0x14,%eax
 27f:	cd 40                	int    $0x40
 281:	c3                   	ret    

00000282 <chdir>:
SYSCALL(chdir)
 282:	b8 09 00 00 00       	mov    $0x9,%eax
 287:	cd 40                	int    $0x40
 289:	c3                   	ret    

0000028a <dup>:
SYSCALL(dup)
 28a:	b8 0a 00 00 00       	mov    $0xa,%eax
 28f:	cd 40                	int    $0x40
 291:	c3                   	ret    

00000292 <getpid>:
SYSCALL(getpid)
 292:	b8 0b 00 00 00       	mov    $0xb,%eax
 297:	cd 40                	int    $0x40
 299:	c3                   	ret    

0000029a <sbrk>:
SYSCALL(sbrk)
 29a:	b8 0c 00 00 00       	mov    $0xc,%eax
 29f:	cd 40                	int    $0x40
 2a1:	c3                   	ret    

000002a2 <sleep>:
SYSCALL(sleep)
 2a2:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a7:	cd 40                	int    $0x40
 2a9:	c3                   	ret    

000002aa <uptime>:
SYSCALL(uptime)
 2aa:	b8 0e 00 00 00       	mov    $0xe,%eax
 2af:	cd 40                	int    $0x40
 2b1:	c3                   	ret    

000002b2 <getiocounts>:
SYSCALL(getiocounts)
 2b2:	b8 16 00 00 00       	mov    $0x16,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2ba:	55                   	push   %ebp
 2bb:	89 e5                	mov    %esp,%ebp
 2bd:	83 ec 1c             	sub    $0x1c,%esp
 2c0:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c3:	6a 01                	push   $0x1
 2c5:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2c8:	52                   	push   %edx
 2c9:	50                   	push   %eax
 2ca:	e8 63 ff ff ff       	call   232 <write>
}
 2cf:	83 c4 10             	add    $0x10,%esp
 2d2:	c9                   	leave  
 2d3:	c3                   	ret    

000002d4 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d4:	55                   	push   %ebp
 2d5:	89 e5                	mov    %esp,%ebp
 2d7:	57                   	push   %edi
 2d8:	56                   	push   %esi
 2d9:	53                   	push   %ebx
 2da:	83 ec 2c             	sub    $0x2c,%esp
 2dd:	89 45 d0             	mov    %eax,-0x30(%ebp)
 2e0:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e6:	0f 95 c2             	setne  %dl
 2e9:	89 f0                	mov    %esi,%eax
 2eb:	c1 e8 1f             	shr    $0x1f,%eax
 2ee:	84 c2                	test   %al,%dl
 2f0:	74 42                	je     334 <printint+0x60>
    neg = 1;
    x = -xx;
 2f2:	f7 de                	neg    %esi
    neg = 1;
 2f4:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2fb:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 300:	89 f0                	mov    %esi,%eax
 302:	ba 00 00 00 00       	mov    $0x0,%edx
 307:	f7 f1                	div    %ecx
 309:	89 df                	mov    %ebx,%edi
 30b:	83 c3 01             	add    $0x1,%ebx
 30e:	0f b6 92 28 06 00 00 	movzbl 0x628(%edx),%edx
 315:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 319:	89 f2                	mov    %esi,%edx
 31b:	89 c6                	mov    %eax,%esi
 31d:	39 d1                	cmp    %edx,%ecx
 31f:	76 df                	jbe    300 <printint+0x2c>
  if(neg)
 321:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 325:	74 2f                	je     356 <printint+0x82>
    buf[i++] = '-';
 327:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 32c:	8d 5f 02             	lea    0x2(%edi),%ebx
 32f:	8b 75 d0             	mov    -0x30(%ebp),%esi
 332:	eb 15                	jmp    349 <printint+0x75>
  neg = 0;
 334:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 33b:	eb be                	jmp    2fb <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 33d:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 342:	89 f0                	mov    %esi,%eax
 344:	e8 71 ff ff ff       	call   2ba <putc>
  while(--i >= 0)
 349:	83 eb 01             	sub    $0x1,%ebx
 34c:	79 ef                	jns    33d <printint+0x69>
}
 34e:	83 c4 2c             	add    $0x2c,%esp
 351:	5b                   	pop    %ebx
 352:	5e                   	pop    %esi
 353:	5f                   	pop    %edi
 354:	5d                   	pop    %ebp
 355:	c3                   	ret    
 356:	8b 75 d0             	mov    -0x30(%ebp),%esi
 359:	eb ee                	jmp    349 <printint+0x75>

0000035b <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 35b:	f3 0f 1e fb          	endbr32 
 35f:	55                   	push   %ebp
 360:	89 e5                	mov    %esp,%ebp
 362:	57                   	push   %edi
 363:	56                   	push   %esi
 364:	53                   	push   %ebx
 365:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 368:	8d 45 10             	lea    0x10(%ebp),%eax
 36b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 36e:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 373:	bb 00 00 00 00       	mov    $0x0,%ebx
 378:	eb 14                	jmp    38e <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 37a:	89 fa                	mov    %edi,%edx
 37c:	8b 45 08             	mov    0x8(%ebp),%eax
 37f:	e8 36 ff ff ff       	call   2ba <putc>
 384:	eb 05                	jmp    38b <printf+0x30>
      }
    } else if(state == '%'){
 386:	83 fe 25             	cmp    $0x25,%esi
 389:	74 25                	je     3b0 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 38b:	83 c3 01             	add    $0x1,%ebx
 38e:	8b 45 0c             	mov    0xc(%ebp),%eax
 391:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 395:	84 c0                	test   %al,%al
 397:	0f 84 23 01 00 00    	je     4c0 <printf+0x165>
    c = fmt[i] & 0xff;
 39d:	0f be f8             	movsbl %al,%edi
 3a0:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 3a3:	85 f6                	test   %esi,%esi
 3a5:	75 df                	jne    386 <printf+0x2b>
      if(c == '%'){
 3a7:	83 f8 25             	cmp    $0x25,%eax
 3aa:	75 ce                	jne    37a <printf+0x1f>
        state = '%';
 3ac:	89 c6                	mov    %eax,%esi
 3ae:	eb db                	jmp    38b <printf+0x30>
      if(c == 'd'){
 3b0:	83 f8 64             	cmp    $0x64,%eax
 3b3:	74 49                	je     3fe <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3b5:	83 f8 78             	cmp    $0x78,%eax
 3b8:	0f 94 c1             	sete   %cl
 3bb:	83 f8 70             	cmp    $0x70,%eax
 3be:	0f 94 c2             	sete   %dl
 3c1:	08 d1                	or     %dl,%cl
 3c3:	75 63                	jne    428 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3c5:	83 f8 73             	cmp    $0x73,%eax
 3c8:	0f 84 84 00 00 00    	je     452 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3ce:	83 f8 63             	cmp    $0x63,%eax
 3d1:	0f 84 b7 00 00 00    	je     48e <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3d7:	83 f8 25             	cmp    $0x25,%eax
 3da:	0f 84 cc 00 00 00    	je     4ac <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3e0:	ba 25 00 00 00       	mov    $0x25,%edx
 3e5:	8b 45 08             	mov    0x8(%ebp),%eax
 3e8:	e8 cd fe ff ff       	call   2ba <putc>
        putc(fd, c);
 3ed:	89 fa                	mov    %edi,%edx
 3ef:	8b 45 08             	mov    0x8(%ebp),%eax
 3f2:	e8 c3 fe ff ff       	call   2ba <putc>
      }
      state = 0;
 3f7:	be 00 00 00 00       	mov    $0x0,%esi
 3fc:	eb 8d                	jmp    38b <printf+0x30>
        printint(fd, *ap, 10, 1);
 3fe:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 401:	8b 17                	mov    (%edi),%edx
 403:	83 ec 0c             	sub    $0xc,%esp
 406:	6a 01                	push   $0x1
 408:	b9 0a 00 00 00       	mov    $0xa,%ecx
 40d:	8b 45 08             	mov    0x8(%ebp),%eax
 410:	e8 bf fe ff ff       	call   2d4 <printint>
        ap++;
 415:	83 c7 04             	add    $0x4,%edi
 418:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 41b:	83 c4 10             	add    $0x10,%esp
      state = 0;
 41e:	be 00 00 00 00       	mov    $0x0,%esi
 423:	e9 63 ff ff ff       	jmp    38b <printf+0x30>
        printint(fd, *ap, 16, 0);
 428:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 42b:	8b 17                	mov    (%edi),%edx
 42d:	83 ec 0c             	sub    $0xc,%esp
 430:	6a 00                	push   $0x0
 432:	b9 10 00 00 00       	mov    $0x10,%ecx
 437:	8b 45 08             	mov    0x8(%ebp),%eax
 43a:	e8 95 fe ff ff       	call   2d4 <printint>
        ap++;
 43f:	83 c7 04             	add    $0x4,%edi
 442:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 445:	83 c4 10             	add    $0x10,%esp
      state = 0;
 448:	be 00 00 00 00       	mov    $0x0,%esi
 44d:	e9 39 ff ff ff       	jmp    38b <printf+0x30>
        s = (char*)*ap;
 452:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 455:	8b 30                	mov    (%eax),%esi
        ap++;
 457:	83 c0 04             	add    $0x4,%eax
 45a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 45d:	85 f6                	test   %esi,%esi
 45f:	75 28                	jne    489 <printf+0x12e>
          s = "(null)";
 461:	be 21 06 00 00       	mov    $0x621,%esi
 466:	8b 7d 08             	mov    0x8(%ebp),%edi
 469:	eb 0d                	jmp    478 <printf+0x11d>
          putc(fd, *s);
 46b:	0f be d2             	movsbl %dl,%edx
 46e:	89 f8                	mov    %edi,%eax
 470:	e8 45 fe ff ff       	call   2ba <putc>
          s++;
 475:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 478:	0f b6 16             	movzbl (%esi),%edx
 47b:	84 d2                	test   %dl,%dl
 47d:	75 ec                	jne    46b <printf+0x110>
      state = 0;
 47f:	be 00 00 00 00       	mov    $0x0,%esi
 484:	e9 02 ff ff ff       	jmp    38b <printf+0x30>
 489:	8b 7d 08             	mov    0x8(%ebp),%edi
 48c:	eb ea                	jmp    478 <printf+0x11d>
        putc(fd, *ap);
 48e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 491:	0f be 17             	movsbl (%edi),%edx
 494:	8b 45 08             	mov    0x8(%ebp),%eax
 497:	e8 1e fe ff ff       	call   2ba <putc>
        ap++;
 49c:	83 c7 04             	add    $0x4,%edi
 49f:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 4a2:	be 00 00 00 00       	mov    $0x0,%esi
 4a7:	e9 df fe ff ff       	jmp    38b <printf+0x30>
        putc(fd, c);
 4ac:	89 fa                	mov    %edi,%edx
 4ae:	8b 45 08             	mov    0x8(%ebp),%eax
 4b1:	e8 04 fe ff ff       	call   2ba <putc>
      state = 0;
 4b6:	be 00 00 00 00       	mov    $0x0,%esi
 4bb:	e9 cb fe ff ff       	jmp    38b <printf+0x30>
    }
  }
}
 4c0:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4c3:	5b                   	pop    %ebx
 4c4:	5e                   	pop    %esi
 4c5:	5f                   	pop    %edi
 4c6:	5d                   	pop    %ebp
 4c7:	c3                   	ret    

000004c8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 4c8:	f3 0f 1e fb          	endbr32 
 4cc:	55                   	push   %ebp
 4cd:	89 e5                	mov    %esp,%ebp
 4cf:	57                   	push   %edi
 4d0:	56                   	push   %esi
 4d1:	53                   	push   %ebx
 4d2:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 4d5:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 4d8:	a1 d4 08 00 00       	mov    0x8d4,%eax
 4dd:	eb 02                	jmp    4e1 <free+0x19>
 4df:	89 d0                	mov    %edx,%eax
 4e1:	39 c8                	cmp    %ecx,%eax
 4e3:	73 04                	jae    4e9 <free+0x21>
 4e5:	39 08                	cmp    %ecx,(%eax)
 4e7:	77 12                	ja     4fb <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 4e9:	8b 10                	mov    (%eax),%edx
 4eb:	39 c2                	cmp    %eax,%edx
 4ed:	77 f0                	ja     4df <free+0x17>
 4ef:	39 c8                	cmp    %ecx,%eax
 4f1:	72 08                	jb     4fb <free+0x33>
 4f3:	39 ca                	cmp    %ecx,%edx
 4f5:	77 04                	ja     4fb <free+0x33>
 4f7:	89 d0                	mov    %edx,%eax
 4f9:	eb e6                	jmp    4e1 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4fb:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4fe:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 501:	8b 10                	mov    (%eax),%edx
 503:	39 d7                	cmp    %edx,%edi
 505:	74 19                	je     520 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 507:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 50a:	8b 50 04             	mov    0x4(%eax),%edx
 50d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 510:	39 ce                	cmp    %ecx,%esi
 512:	74 1b                	je     52f <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 514:	89 08                	mov    %ecx,(%eax)
  freep = p;
 516:	a3 d4 08 00 00       	mov    %eax,0x8d4
}
 51b:	5b                   	pop    %ebx
 51c:	5e                   	pop    %esi
 51d:	5f                   	pop    %edi
 51e:	5d                   	pop    %ebp
 51f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 520:	03 72 04             	add    0x4(%edx),%esi
 523:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 526:	8b 10                	mov    (%eax),%edx
 528:	8b 12                	mov    (%edx),%edx
 52a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 52d:	eb db                	jmp    50a <free+0x42>
    p->s.size += bp->s.size;
 52f:	03 53 fc             	add    -0x4(%ebx),%edx
 532:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 535:	8b 53 f8             	mov    -0x8(%ebx),%edx
 538:	89 10                	mov    %edx,(%eax)
 53a:	eb da                	jmp    516 <free+0x4e>

0000053c <morecore>:

static Header*
morecore(uint nu)
{
 53c:	55                   	push   %ebp
 53d:	89 e5                	mov    %esp,%ebp
 53f:	53                   	push   %ebx
 540:	83 ec 04             	sub    $0x4,%esp
 543:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 545:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 54a:	77 05                	ja     551 <morecore+0x15>
    nu = 4096;
 54c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 551:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 558:	83 ec 0c             	sub    $0xc,%esp
 55b:	50                   	push   %eax
 55c:	e8 39 fd ff ff       	call   29a <sbrk>
  if(p == (char*)-1)
 561:	83 c4 10             	add    $0x10,%esp
 564:	83 f8 ff             	cmp    $0xffffffff,%eax
 567:	74 1c                	je     585 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 569:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 56c:	83 c0 08             	add    $0x8,%eax
 56f:	83 ec 0c             	sub    $0xc,%esp
 572:	50                   	push   %eax
 573:	e8 50 ff ff ff       	call   4c8 <free>
  return freep;
 578:	a1 d4 08 00 00       	mov    0x8d4,%eax
 57d:	83 c4 10             	add    $0x10,%esp
}
 580:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 583:	c9                   	leave  
 584:	c3                   	ret    
    return 0;
 585:	b8 00 00 00 00       	mov    $0x0,%eax
 58a:	eb f4                	jmp    580 <morecore+0x44>

0000058c <malloc>:

void*
malloc(int nbytes)
{
 58c:	f3 0f 1e fb          	endbr32 
 590:	55                   	push   %ebp
 591:	89 e5                	mov    %esp,%ebp
 593:	53                   	push   %ebx
 594:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 597:	8b 45 08             	mov    0x8(%ebp),%eax
 59a:	8d 58 07             	lea    0x7(%eax),%ebx
 59d:	c1 eb 03             	shr    $0x3,%ebx
 5a0:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 5a3:	8b 0d d4 08 00 00    	mov    0x8d4,%ecx
 5a9:	85 c9                	test   %ecx,%ecx
 5ab:	74 04                	je     5b1 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5ad:	8b 01                	mov    (%ecx),%eax
 5af:	eb 4b                	jmp    5fc <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 5b1:	c7 05 d4 08 00 00 d8 	movl   $0x8d8,0x8d4
 5b8:	08 00 00 
 5bb:	c7 05 d8 08 00 00 d8 	movl   $0x8d8,0x8d8
 5c2:	08 00 00 
    base.s.size = 0;
 5c5:	c7 05 dc 08 00 00 00 	movl   $0x0,0x8dc
 5cc:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 5cf:	b9 d8 08 00 00       	mov    $0x8d8,%ecx
 5d4:	eb d7                	jmp    5ad <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 5d6:	74 1a                	je     5f2 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 5d8:	29 da                	sub    %ebx,%edx
 5da:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 5dd:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 5e0:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 5e3:	89 0d d4 08 00 00    	mov    %ecx,0x8d4
      return (void*)(p + 1);
 5e9:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 5ec:	83 c4 04             	add    $0x4,%esp
 5ef:	5b                   	pop    %ebx
 5f0:	5d                   	pop    %ebp
 5f1:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 5f2:	8b 10                	mov    (%eax),%edx
 5f4:	89 11                	mov    %edx,(%ecx)
 5f6:	eb eb                	jmp    5e3 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5f8:	89 c1                	mov    %eax,%ecx
 5fa:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5fc:	8b 50 04             	mov    0x4(%eax),%edx
 5ff:	39 da                	cmp    %ebx,%edx
 601:	73 d3                	jae    5d6 <malloc+0x4a>
    if(p == freep)
 603:	39 05 d4 08 00 00    	cmp    %eax,0x8d4
 609:	75 ed                	jne    5f8 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 60b:	89 d8                	mov    %ebx,%eax
 60d:	e8 2a ff ff ff       	call   53c <morecore>
 612:	85 c0                	test   %eax,%eax
 614:	75 e2                	jne    5f8 <malloc+0x6c>
 616:	eb d4                	jmp    5ec <malloc+0x60>
