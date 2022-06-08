
_first:     file format elf32-i386


Disassembly of section .text:

00000000 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 75 08             	mov    0x8(%ebp),%esi
   c:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
   f:	89 f0                	mov    %esi,%eax
  11:	89 d1                	mov    %edx,%ecx
  13:	83 c2 01             	add    $0x1,%edx
  16:	89 c3                	mov    %eax,%ebx
  18:	83 c0 01             	add    $0x1,%eax
  1b:	0f b6 09             	movzbl (%ecx),%ecx
  1e:	88 0b                	mov    %cl,(%ebx)
  20:	84 c9                	test   %cl,%cl
  22:	75 ed                	jne    11 <strcpy+0x11>
    ;
  return os;
}
  24:	89 f0                	mov    %esi,%eax
  26:	5b                   	pop    %ebx
  27:	5e                   	pop    %esi
  28:	5d                   	pop    %ebp
  29:	c3                   	ret    

0000002a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  2a:	f3 0f 1e fb          	endbr32 
  2e:	55                   	push   %ebp
  2f:	89 e5                	mov    %esp,%ebp
  31:	8b 4d 08             	mov    0x8(%ebp),%ecx
  34:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  37:	0f b6 01             	movzbl (%ecx),%eax
  3a:	84 c0                	test   %al,%al
  3c:	74 0c                	je     4a <strcmp+0x20>
  3e:	3a 02                	cmp    (%edx),%al
  40:	75 08                	jne    4a <strcmp+0x20>
    p++, q++;
  42:	83 c1 01             	add    $0x1,%ecx
  45:	83 c2 01             	add    $0x1,%edx
  48:	eb ed                	jmp    37 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  4a:	0f b6 c0             	movzbl %al,%eax
  4d:	0f b6 12             	movzbl (%edx),%edx
  50:	29 d0                	sub    %edx,%eax
}
  52:	5d                   	pop    %ebp
  53:	c3                   	ret    

00000054 <strlen>:

int
strlen(const char *s)
{
  54:	f3 0f 1e fb          	endbr32 
  58:	55                   	push   %ebp
  59:	89 e5                	mov    %esp,%ebp
  5b:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
  5e:	b8 00 00 00 00       	mov    $0x0,%eax
  63:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
  67:	74 05                	je     6e <strlen+0x1a>
  69:	83 c0 01             	add    $0x1,%eax
  6c:	eb f5                	jmp    63 <strlen+0xf>
    ;
  return n;
}
  6e:	5d                   	pop    %ebp
  6f:	c3                   	ret    

00000070 <memset>:

void*
memset(void *dst, int c, int n)
{
  70:	f3 0f 1e fb          	endbr32 
  74:	55                   	push   %ebp
  75:	89 e5                	mov    %esp,%ebp
  77:	57                   	push   %edi
  78:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  7b:	89 d7                	mov    %edx,%edi
  7d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80:	8b 45 0c             	mov    0xc(%ebp),%eax
  83:	fc                   	cld    
  84:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  86:	89 d0                	mov    %edx,%eax
  88:	5f                   	pop    %edi
  89:	5d                   	pop    %ebp
  8a:	c3                   	ret    

0000008b <strchr>:

char*
strchr(const char *s, char c)
{
  8b:	f3 0f 1e fb          	endbr32 
  8f:	55                   	push   %ebp
  90:	89 e5                	mov    %esp,%ebp
  92:	8b 45 08             	mov    0x8(%ebp),%eax
  95:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
  99:	0f b6 10             	movzbl (%eax),%edx
  9c:	84 d2                	test   %dl,%dl
  9e:	74 09                	je     a9 <strchr+0x1e>
    if(*s == c)
  a0:	38 ca                	cmp    %cl,%dl
  a2:	74 0a                	je     ae <strchr+0x23>
  for(; *s; s++)
  a4:	83 c0 01             	add    $0x1,%eax
  a7:	eb f0                	jmp    99 <strchr+0xe>
      return (char*)s;
  return 0;
  a9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  ae:	5d                   	pop    %ebp
  af:	c3                   	ret    

000000b0 <gets>:

char*
gets(char *buf, int max)
{
  b0:	f3 0f 1e fb          	endbr32 
  b4:	55                   	push   %ebp
  b5:	89 e5                	mov    %esp,%ebp
  b7:	57                   	push   %edi
  b8:	56                   	push   %esi
  b9:	53                   	push   %ebx
  ba:	83 ec 1c             	sub    $0x1c,%esp
  bd:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
  c0:	bb 00 00 00 00       	mov    $0x0,%ebx
  c5:	89 de                	mov    %ebx,%esi
  c7:	83 c3 01             	add    $0x1,%ebx
  ca:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
  cd:	7d 2e                	jge    fd <gets+0x4d>
    cc = read(0, &c, 1);
  cf:	83 ec 04             	sub    $0x4,%esp
  d2:	6a 01                	push   $0x1
  d4:	8d 45 e7             	lea    -0x19(%ebp),%eax
  d7:	50                   	push   %eax
  d8:	6a 00                	push   $0x0
  da:	e8 f6 00 00 00       	call   1d5 <read>
    if(cc < 1)
  df:	83 c4 10             	add    $0x10,%esp
  e2:	85 c0                	test   %eax,%eax
  e4:	7e 17                	jle    fd <gets+0x4d>
      break;
    buf[i++] = c;
  e6:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  ea:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
  ed:	3c 0a                	cmp    $0xa,%al
  ef:	0f 94 c2             	sete   %dl
  f2:	3c 0d                	cmp    $0xd,%al
  f4:	0f 94 c0             	sete   %al
  f7:	08 c2                	or     %al,%dl
  f9:	74 ca                	je     c5 <gets+0x15>
    buf[i++] = c;
  fb:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
  fd:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 101:	89 f8                	mov    %edi,%eax
 103:	8d 65 f4             	lea    -0xc(%ebp),%esp
 106:	5b                   	pop    %ebx
 107:	5e                   	pop    %esi
 108:	5f                   	pop    %edi
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <stat>:

int
stat(const char *n, struct stat *st)
{
 10b:	f3 0f 1e fb          	endbr32 
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	56                   	push   %esi
 113:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 114:	83 ec 08             	sub    $0x8,%esp
 117:	6a 00                	push   $0x0
 119:	ff 75 08             	pushl  0x8(%ebp)
 11c:	e8 dc 00 00 00       	call   1fd <open>
  if(fd < 0)
 121:	83 c4 10             	add    $0x10,%esp
 124:	85 c0                	test   %eax,%eax
 126:	78 24                	js     14c <stat+0x41>
 128:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 12a:	83 ec 08             	sub    $0x8,%esp
 12d:	ff 75 0c             	pushl  0xc(%ebp)
 130:	50                   	push   %eax
 131:	e8 df 00 00 00       	call   215 <fstat>
 136:	89 c6                	mov    %eax,%esi
  close(fd);
 138:	89 1c 24             	mov    %ebx,(%esp)
 13b:	e8 a5 00 00 00       	call   1e5 <close>
  return r;
 140:	83 c4 10             	add    $0x10,%esp
}
 143:	89 f0                	mov    %esi,%eax
 145:	8d 65 f8             	lea    -0x8(%ebp),%esp
 148:	5b                   	pop    %ebx
 149:	5e                   	pop    %esi
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    
    return -1;
 14c:	be ff ff ff ff       	mov    $0xffffffff,%esi
 151:	eb f0                	jmp    143 <stat+0x38>

00000153 <atoi>:

int
atoi(const char *s)
{
 153:	f3 0f 1e fb          	endbr32 
 157:	55                   	push   %ebp
 158:	89 e5                	mov    %esp,%ebp
 15a:	53                   	push   %ebx
 15b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 15e:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 163:	0f b6 01             	movzbl (%ecx),%eax
 166:	8d 58 d0             	lea    -0x30(%eax),%ebx
 169:	80 fb 09             	cmp    $0x9,%bl
 16c:	77 12                	ja     180 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 16e:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 171:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 174:	83 c1 01             	add    $0x1,%ecx
 177:	0f be c0             	movsbl %al,%eax
 17a:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 17e:	eb e3                	jmp    163 <atoi+0x10>
  return n;
}
 180:	89 d0                	mov    %edx,%eax
 182:	5b                   	pop    %ebx
 183:	5d                   	pop    %ebp
 184:	c3                   	ret    

00000185 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 185:	f3 0f 1e fb          	endbr32 
 189:	55                   	push   %ebp
 18a:	89 e5                	mov    %esp,%ebp
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
 18e:	8b 75 08             	mov    0x8(%ebp),%esi
 191:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 194:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 197:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 199:	8d 58 ff             	lea    -0x1(%eax),%ebx
 19c:	85 c0                	test   %eax,%eax
 19e:	7e 0f                	jle    1af <memmove+0x2a>
    *dst++ = *src++;
 1a0:	0f b6 01             	movzbl (%ecx),%eax
 1a3:	88 02                	mov    %al,(%edx)
 1a5:	8d 49 01             	lea    0x1(%ecx),%ecx
 1a8:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 1ab:	89 d8                	mov    %ebx,%eax
 1ad:	eb ea                	jmp    199 <memmove+0x14>
  return vdst;
}
 1af:	89 f0                	mov    %esi,%eax
 1b1:	5b                   	pop    %ebx
 1b2:	5e                   	pop    %esi
 1b3:	5d                   	pop    %ebp
 1b4:	c3                   	ret    

000001b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1b5:	b8 01 00 00 00       	mov    $0x1,%eax
 1ba:	cd 40                	int    $0x40
 1bc:	c3                   	ret    

000001bd <exit>:
SYSCALL(exit)
 1bd:	b8 02 00 00 00       	mov    $0x2,%eax
 1c2:	cd 40                	int    $0x40
 1c4:	c3                   	ret    

000001c5 <wait>:
SYSCALL(wait)
 1c5:	b8 03 00 00 00       	mov    $0x3,%eax
 1ca:	cd 40                	int    $0x40
 1cc:	c3                   	ret    

000001cd <pipe>:
SYSCALL(pipe)
 1cd:	b8 04 00 00 00       	mov    $0x4,%eax
 1d2:	cd 40                	int    $0x40
 1d4:	c3                   	ret    

000001d5 <read>:
SYSCALL(read)
 1d5:	b8 05 00 00 00       	mov    $0x5,%eax
 1da:	cd 40                	int    $0x40
 1dc:	c3                   	ret    

000001dd <write>:
SYSCALL(write)
 1dd:	b8 10 00 00 00       	mov    $0x10,%eax
 1e2:	cd 40                	int    $0x40
 1e4:	c3                   	ret    

000001e5 <close>:
SYSCALL(close)
 1e5:	b8 15 00 00 00       	mov    $0x15,%eax
 1ea:	cd 40                	int    $0x40
 1ec:	c3                   	ret    

000001ed <kill>:
SYSCALL(kill)
 1ed:	b8 06 00 00 00       	mov    $0x6,%eax
 1f2:	cd 40                	int    $0x40
 1f4:	c3                   	ret    

000001f5 <exec>:
SYSCALL(exec)
 1f5:	b8 07 00 00 00       	mov    $0x7,%eax
 1fa:	cd 40                	int    $0x40
 1fc:	c3                   	ret    

000001fd <open>:
SYSCALL(open)
 1fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 202:	cd 40                	int    $0x40
 204:	c3                   	ret    

00000205 <mknod>:
SYSCALL(mknod)
 205:	b8 11 00 00 00       	mov    $0x11,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <unlink>:
SYSCALL(unlink)
 20d:	b8 12 00 00 00       	mov    $0x12,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <fstat>:
SYSCALL(fstat)
 215:	b8 08 00 00 00       	mov    $0x8,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <link>:
SYSCALL(link)
 21d:	b8 13 00 00 00       	mov    $0x13,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <mkdir>:
SYSCALL(mkdir)
 225:	b8 14 00 00 00       	mov    $0x14,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <chdir>:
SYSCALL(chdir)
 22d:	b8 09 00 00 00       	mov    $0x9,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <dup>:
SYSCALL(dup)
 235:	b8 0a 00 00 00       	mov    $0xa,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <getpid>:
SYSCALL(getpid)
 23d:	b8 0b 00 00 00       	mov    $0xb,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <sbrk>:
SYSCALL(sbrk)
 245:	b8 0c 00 00 00       	mov    $0xc,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <sleep>:
SYSCALL(sleep)
 24d:	b8 0d 00 00 00       	mov    $0xd,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <uptime>:
SYSCALL(uptime)
 255:	b8 0e 00 00 00       	mov    $0xe,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <getiocounts>:
SYSCALL(getiocounts)
 25d:	b8 16 00 00 00       	mov    $0x16,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 265:	55                   	push   %ebp
 266:	89 e5                	mov    %esp,%ebp
 268:	83 ec 1c             	sub    $0x1c,%esp
 26b:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 26e:	6a 01                	push   $0x1
 270:	8d 55 f4             	lea    -0xc(%ebp),%edx
 273:	52                   	push   %edx
 274:	50                   	push   %eax
 275:	e8 63 ff ff ff       	call   1dd <write>
}
 27a:	83 c4 10             	add    $0x10,%esp
 27d:	c9                   	leave  
 27e:	c3                   	ret    

0000027f <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 27f:	55                   	push   %ebp
 280:	89 e5                	mov    %esp,%ebp
 282:	57                   	push   %edi
 283:	56                   	push   %esi
 284:	53                   	push   %ebx
 285:	83 ec 2c             	sub    $0x2c,%esp
 288:	89 45 d0             	mov    %eax,-0x30(%ebp)
 28b:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 28d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 291:	0f 95 c2             	setne  %dl
 294:	89 f0                	mov    %esi,%eax
 296:	c1 e8 1f             	shr    $0x1f,%eax
 299:	84 c2                	test   %al,%dl
 29b:	74 42                	je     2df <printint+0x60>
    neg = 1;
    x = -xx;
 29d:	f7 de                	neg    %esi
    neg = 1;
 29f:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 2a6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2ab:	89 f0                	mov    %esi,%eax
 2ad:	ba 00 00 00 00       	mov    $0x0,%edx
 2b2:	f7 f1                	div    %ecx
 2b4:	89 df                	mov    %ebx,%edi
 2b6:	83 c3 01             	add    $0x1,%ebx
 2b9:	0f b6 92 cc 05 00 00 	movzbl 0x5cc(%edx),%edx
 2c0:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2c4:	89 f2                	mov    %esi,%edx
 2c6:	89 c6                	mov    %eax,%esi
 2c8:	39 d1                	cmp    %edx,%ecx
 2ca:	76 df                	jbe    2ab <printint+0x2c>
  if(neg)
 2cc:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 2d0:	74 2f                	je     301 <printint+0x82>
    buf[i++] = '-';
 2d2:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2d7:	8d 5f 02             	lea    0x2(%edi),%ebx
 2da:	8b 75 d0             	mov    -0x30(%ebp),%esi
 2dd:	eb 15                	jmp    2f4 <printint+0x75>
  neg = 0;
 2df:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 2e6:	eb be                	jmp    2a6 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 2e8:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2ed:	89 f0                	mov    %esi,%eax
 2ef:	e8 71 ff ff ff       	call   265 <putc>
  while(--i >= 0)
 2f4:	83 eb 01             	sub    $0x1,%ebx
 2f7:	79 ef                	jns    2e8 <printint+0x69>
}
 2f9:	83 c4 2c             	add    $0x2c,%esp
 2fc:	5b                   	pop    %ebx
 2fd:	5e                   	pop    %esi
 2fe:	5f                   	pop    %edi
 2ff:	5d                   	pop    %ebp
 300:	c3                   	ret    
 301:	8b 75 d0             	mov    -0x30(%ebp),%esi
 304:	eb ee                	jmp    2f4 <printint+0x75>

00000306 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 306:	f3 0f 1e fb          	endbr32 
 30a:	55                   	push   %ebp
 30b:	89 e5                	mov    %esp,%ebp
 30d:	57                   	push   %edi
 30e:	56                   	push   %esi
 30f:	53                   	push   %ebx
 310:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 313:	8d 45 10             	lea    0x10(%ebp),%eax
 316:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 319:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 31e:	bb 00 00 00 00       	mov    $0x0,%ebx
 323:	eb 14                	jmp    339 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 325:	89 fa                	mov    %edi,%edx
 327:	8b 45 08             	mov    0x8(%ebp),%eax
 32a:	e8 36 ff ff ff       	call   265 <putc>
 32f:	eb 05                	jmp    336 <printf+0x30>
      }
    } else if(state == '%'){
 331:	83 fe 25             	cmp    $0x25,%esi
 334:	74 25                	je     35b <printf+0x55>
  for(i = 0; fmt[i]; i++){
 336:	83 c3 01             	add    $0x1,%ebx
 339:	8b 45 0c             	mov    0xc(%ebp),%eax
 33c:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 340:	84 c0                	test   %al,%al
 342:	0f 84 23 01 00 00    	je     46b <printf+0x165>
    c = fmt[i] & 0xff;
 348:	0f be f8             	movsbl %al,%edi
 34b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 34e:	85 f6                	test   %esi,%esi
 350:	75 df                	jne    331 <printf+0x2b>
      if(c == '%'){
 352:	83 f8 25             	cmp    $0x25,%eax
 355:	75 ce                	jne    325 <printf+0x1f>
        state = '%';
 357:	89 c6                	mov    %eax,%esi
 359:	eb db                	jmp    336 <printf+0x30>
      if(c == 'd'){
 35b:	83 f8 64             	cmp    $0x64,%eax
 35e:	74 49                	je     3a9 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 360:	83 f8 78             	cmp    $0x78,%eax
 363:	0f 94 c1             	sete   %cl
 366:	83 f8 70             	cmp    $0x70,%eax
 369:	0f 94 c2             	sete   %dl
 36c:	08 d1                	or     %dl,%cl
 36e:	75 63                	jne    3d3 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 370:	83 f8 73             	cmp    $0x73,%eax
 373:	0f 84 84 00 00 00    	je     3fd <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 379:	83 f8 63             	cmp    $0x63,%eax
 37c:	0f 84 b7 00 00 00    	je     439 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 382:	83 f8 25             	cmp    $0x25,%eax
 385:	0f 84 cc 00 00 00    	je     457 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 38b:	ba 25 00 00 00       	mov    $0x25,%edx
 390:	8b 45 08             	mov    0x8(%ebp),%eax
 393:	e8 cd fe ff ff       	call   265 <putc>
        putc(fd, c);
 398:	89 fa                	mov    %edi,%edx
 39a:	8b 45 08             	mov    0x8(%ebp),%eax
 39d:	e8 c3 fe ff ff       	call   265 <putc>
      }
      state = 0;
 3a2:	be 00 00 00 00       	mov    $0x0,%esi
 3a7:	eb 8d                	jmp    336 <printf+0x30>
        printint(fd, *ap, 10, 1);
 3a9:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3ac:	8b 17                	mov    (%edi),%edx
 3ae:	83 ec 0c             	sub    $0xc,%esp
 3b1:	6a 01                	push   $0x1
 3b3:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3b8:	8b 45 08             	mov    0x8(%ebp),%eax
 3bb:	e8 bf fe ff ff       	call   27f <printint>
        ap++;
 3c0:	83 c7 04             	add    $0x4,%edi
 3c3:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3c6:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3c9:	be 00 00 00 00       	mov    $0x0,%esi
 3ce:	e9 63 ff ff ff       	jmp    336 <printf+0x30>
        printint(fd, *ap, 16, 0);
 3d3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3d6:	8b 17                	mov    (%edi),%edx
 3d8:	83 ec 0c             	sub    $0xc,%esp
 3db:	6a 00                	push   $0x0
 3dd:	b9 10 00 00 00       	mov    $0x10,%ecx
 3e2:	8b 45 08             	mov    0x8(%ebp),%eax
 3e5:	e8 95 fe ff ff       	call   27f <printint>
        ap++;
 3ea:	83 c7 04             	add    $0x4,%edi
 3ed:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3f0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3f3:	be 00 00 00 00       	mov    $0x0,%esi
 3f8:	e9 39 ff ff ff       	jmp    336 <printf+0x30>
        s = (char*)*ap;
 3fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 400:	8b 30                	mov    (%eax),%esi
        ap++;
 402:	83 c0 04             	add    $0x4,%eax
 405:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 408:	85 f6                	test   %esi,%esi
 40a:	75 28                	jne    434 <printf+0x12e>
          s = "(null)";
 40c:	be c4 05 00 00       	mov    $0x5c4,%esi
 411:	8b 7d 08             	mov    0x8(%ebp),%edi
 414:	eb 0d                	jmp    423 <printf+0x11d>
          putc(fd, *s);
 416:	0f be d2             	movsbl %dl,%edx
 419:	89 f8                	mov    %edi,%eax
 41b:	e8 45 fe ff ff       	call   265 <putc>
          s++;
 420:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 423:	0f b6 16             	movzbl (%esi),%edx
 426:	84 d2                	test   %dl,%dl
 428:	75 ec                	jne    416 <printf+0x110>
      state = 0;
 42a:	be 00 00 00 00       	mov    $0x0,%esi
 42f:	e9 02 ff ff ff       	jmp    336 <printf+0x30>
 434:	8b 7d 08             	mov    0x8(%ebp),%edi
 437:	eb ea                	jmp    423 <printf+0x11d>
        putc(fd, *ap);
 439:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 43c:	0f be 17             	movsbl (%edi),%edx
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	e8 1e fe ff ff       	call   265 <putc>
        ap++;
 447:	83 c7 04             	add    $0x4,%edi
 44a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 44d:	be 00 00 00 00       	mov    $0x0,%esi
 452:	e9 df fe ff ff       	jmp    336 <printf+0x30>
        putc(fd, c);
 457:	89 fa                	mov    %edi,%edx
 459:	8b 45 08             	mov    0x8(%ebp),%eax
 45c:	e8 04 fe ff ff       	call   265 <putc>
      state = 0;
 461:	be 00 00 00 00       	mov    $0x0,%esi
 466:	e9 cb fe ff ff       	jmp    336 <printf+0x30>
    }
  }
}
 46b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 46e:	5b                   	pop    %ebx
 46f:	5e                   	pop    %esi
 470:	5f                   	pop    %edi
 471:	5d                   	pop    %ebp
 472:	c3                   	ret    

00000473 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 473:	f3 0f 1e fb          	endbr32 
 477:	55                   	push   %ebp
 478:	89 e5                	mov    %esp,%ebp
 47a:	57                   	push   %edi
 47b:	56                   	push   %esi
 47c:	53                   	push   %ebx
 47d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 480:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 483:	a1 48 08 00 00       	mov    0x848,%eax
 488:	eb 02                	jmp    48c <free+0x19>
 48a:	89 d0                	mov    %edx,%eax
 48c:	39 c8                	cmp    %ecx,%eax
 48e:	73 04                	jae    494 <free+0x21>
 490:	39 08                	cmp    %ecx,(%eax)
 492:	77 12                	ja     4a6 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 494:	8b 10                	mov    (%eax),%edx
 496:	39 c2                	cmp    %eax,%edx
 498:	77 f0                	ja     48a <free+0x17>
 49a:	39 c8                	cmp    %ecx,%eax
 49c:	72 08                	jb     4a6 <free+0x33>
 49e:	39 ca                	cmp    %ecx,%edx
 4a0:	77 04                	ja     4a6 <free+0x33>
 4a2:	89 d0                	mov    %edx,%eax
 4a4:	eb e6                	jmp    48c <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 4a6:	8b 73 fc             	mov    -0x4(%ebx),%esi
 4a9:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 4ac:	8b 10                	mov    (%eax),%edx
 4ae:	39 d7                	cmp    %edx,%edi
 4b0:	74 19                	je     4cb <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 4b2:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 4b5:	8b 50 04             	mov    0x4(%eax),%edx
 4b8:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 4bb:	39 ce                	cmp    %ecx,%esi
 4bd:	74 1b                	je     4da <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 4bf:	89 08                	mov    %ecx,(%eax)
  freep = p;
 4c1:	a3 48 08 00 00       	mov    %eax,0x848
}
 4c6:	5b                   	pop    %ebx
 4c7:	5e                   	pop    %esi
 4c8:	5f                   	pop    %edi
 4c9:	5d                   	pop    %ebp
 4ca:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 4cb:	03 72 04             	add    0x4(%edx),%esi
 4ce:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 4d1:	8b 10                	mov    (%eax),%edx
 4d3:	8b 12                	mov    (%edx),%edx
 4d5:	89 53 f8             	mov    %edx,-0x8(%ebx)
 4d8:	eb db                	jmp    4b5 <free+0x42>
    p->s.size += bp->s.size;
 4da:	03 53 fc             	add    -0x4(%ebx),%edx
 4dd:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 4e0:	8b 53 f8             	mov    -0x8(%ebx),%edx
 4e3:	89 10                	mov    %edx,(%eax)
 4e5:	eb da                	jmp    4c1 <free+0x4e>

000004e7 <morecore>:

static Header*
morecore(uint nu)
{
 4e7:	55                   	push   %ebp
 4e8:	89 e5                	mov    %esp,%ebp
 4ea:	53                   	push   %ebx
 4eb:	83 ec 04             	sub    $0x4,%esp
 4ee:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 4f0:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 4f5:	77 05                	ja     4fc <morecore+0x15>
    nu = 4096;
 4f7:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 4fc:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 503:	83 ec 0c             	sub    $0xc,%esp
 506:	50                   	push   %eax
 507:	e8 39 fd ff ff       	call   245 <sbrk>
  if(p == (char*)-1)
 50c:	83 c4 10             	add    $0x10,%esp
 50f:	83 f8 ff             	cmp    $0xffffffff,%eax
 512:	74 1c                	je     530 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 514:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 517:	83 c0 08             	add    $0x8,%eax
 51a:	83 ec 0c             	sub    $0xc,%esp
 51d:	50                   	push   %eax
 51e:	e8 50 ff ff ff       	call   473 <free>
  return freep;
 523:	a1 48 08 00 00       	mov    0x848,%eax
 528:	83 c4 10             	add    $0x10,%esp
}
 52b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 52e:	c9                   	leave  
 52f:	c3                   	ret    
    return 0;
 530:	b8 00 00 00 00       	mov    $0x0,%eax
 535:	eb f4                	jmp    52b <morecore+0x44>

00000537 <malloc>:

void*
malloc(int nbytes)
{
 537:	f3 0f 1e fb          	endbr32 
 53b:	55                   	push   %ebp
 53c:	89 e5                	mov    %esp,%ebp
 53e:	53                   	push   %ebx
 53f:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 542:	8b 45 08             	mov    0x8(%ebp),%eax
 545:	8d 58 07             	lea    0x7(%eax),%ebx
 548:	c1 eb 03             	shr    $0x3,%ebx
 54b:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 54e:	8b 0d 48 08 00 00    	mov    0x848,%ecx
 554:	85 c9                	test   %ecx,%ecx
 556:	74 04                	je     55c <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 558:	8b 01                	mov    (%ecx),%eax
 55a:	eb 4b                	jmp    5a7 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 55c:	c7 05 48 08 00 00 4c 	movl   $0x84c,0x848
 563:	08 00 00 
 566:	c7 05 4c 08 00 00 4c 	movl   $0x84c,0x84c
 56d:	08 00 00 
    base.s.size = 0;
 570:	c7 05 50 08 00 00 00 	movl   $0x0,0x850
 577:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 57a:	b9 4c 08 00 00       	mov    $0x84c,%ecx
 57f:	eb d7                	jmp    558 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 581:	74 1a                	je     59d <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 583:	29 da                	sub    %ebx,%edx
 585:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 588:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 58b:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 58e:	89 0d 48 08 00 00    	mov    %ecx,0x848
      return (void*)(p + 1);
 594:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 597:	83 c4 04             	add    $0x4,%esp
 59a:	5b                   	pop    %ebx
 59b:	5d                   	pop    %ebp
 59c:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 59d:	8b 10                	mov    (%eax),%edx
 59f:	89 11                	mov    %edx,(%ecx)
 5a1:	eb eb                	jmp    58e <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 5a3:	89 c1                	mov    %eax,%ecx
 5a5:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 5a7:	8b 50 04             	mov    0x4(%eax),%edx
 5aa:	39 da                	cmp    %ebx,%edx
 5ac:	73 d3                	jae    581 <malloc+0x4a>
    if(p == freep)
 5ae:	39 05 48 08 00 00    	cmp    %eax,0x848
 5b4:	75 ed                	jne    5a3 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 5b6:	89 d8                	mov    %ebx,%eax
 5b8:	e8 2a ff ff ff       	call   4e7 <morecore>
 5bd:	85 c0                	test   %eax,%eax
 5bf:	75 e2                	jne    5a3 <malloc+0x6c>
 5c1:	eb d4                	jmp    597 <malloc+0x60>
