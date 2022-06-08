
_sysios:     file format elf32-i386


Disassembly of section .text:

00000000 <main>:
  int readcount;  // total number of times read() is invoked by the current running process (including failed calls)
  int writecount; // total number of times write() is invoked by the current running process (including failed calls)
};

int main(int argc, char **argv)
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
  15:	83 ec 24             	sub    $0x24,%esp
  18:	8b 59 04             	mov    0x4(%ecx),%ebx
  int reads = atoi(argv[1]);
  1b:	ff 73 04             	pushl  0x4(%ebx)
  1e:	e8 04 02 00 00       	call   227 <atoi>
  23:	89 c7                	mov    %eax,%edi
  int writes  = atoi(argv[2]);
  25:	83 c4 04             	add    $0x4,%esp
  28:	ff 73 08             	pushl  0x8(%ebx)
  2b:	e8 f7 01 00 00       	call   227 <atoi>
  30:	89 45 e4             	mov    %eax,-0x1c(%ebp)

  char* tmp = malloc(1);
  33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  3a:	e8 cc 05 00 00       	call   60b <malloc>
  3f:	89 c6                	mov    %eax,%esi
  struct iostat *i = malloc(2*sizeof(int));
  41:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  48:	e8 be 05 00 00       	call   60b <malloc>
  4d:	89 45 e0             	mov    %eax,-0x20(%ebp)

  i->readcount=0;
  50:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  i->writecount=0;
  56:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

  for (int j = 0; j < reads; j++) {
  5d:	83 c4 10             	add    $0x10,%esp
  60:	bb 00 00 00 00       	mov    $0x0,%ebx
  65:	39 fb                	cmp    %edi,%ebx
  67:	7d 15                	jge    7e <main+0x7e>
    read(-1,tmp,10);
  69:	83 ec 04             	sub    $0x4,%esp
  6c:	6a 0a                	push   $0xa
  6e:	56                   	push   %esi
  6f:	6a ff                	push   $0xffffffff
  71:	e8 33 02 00 00       	call   2a9 <read>
  for (int j = 0; j < reads; j++) {
  76:	83 c3 01             	add    $0x1,%ebx
  79:	83 c4 10             	add    $0x10,%esp
  7c:	eb e7                	jmp    65 <main+0x65>
  }
  for (int h = 0; h < writes; h++) {
  7e:	bb 00 00 00 00       	mov    $0x0,%ebx
  83:	eb 13                	jmp    98 <main+0x98>
    write(-1,tmp,10);
  85:	83 ec 04             	sub    $0x4,%esp
  88:	6a 0a                	push   $0xa
  8a:	56                   	push   %esi
  8b:	6a ff                	push   $0xffffffff
  8d:	e8 1f 02 00 00       	call   2b1 <write>
  for (int h = 0; h < writes; h++) {
  92:	83 c3 01             	add    $0x1,%ebx
  95:	83 c4 10             	add    $0x10,%esp
  98:	3b 5d e4             	cmp    -0x1c(%ebp),%ebx
  9b:	7c e8                	jl     85 <main+0x85>
  }

  int success = getiocounts(i);
  9d:	83 ec 0c             	sub    $0xc,%esp
  a0:	8b 7d e0             	mov    -0x20(%ebp),%edi
  a3:	57                   	push   %edi
  a4:	e8 88 02 00 00       	call   331 <getiocounts>

  printf(1,"%d %d %d\n", success, i->readcount, i->writecount);
  a9:	83 c4 04             	add    $0x4,%esp
  ac:	ff 77 04             	pushl  0x4(%edi)
  af:	ff 37                	pushl  (%edi)
  b1:	50                   	push   %eax
  b2:	68 98 06 00 00       	push   $0x698
  b7:	6a 01                	push   $0x1
  b9:	e8 1c 03 00 00       	call   3da <printf>

  free(i);
  be:	83 c4 14             	add    $0x14,%esp
  c1:	57                   	push   %edi
  c2:	e8 80 04 00 00       	call   547 <free>
  free(tmp);
  c7:	89 34 24             	mov    %esi,(%esp)
  ca:	e8 78 04 00 00       	call   547 <free>

  exit();
  cf:	e8 bd 01 00 00       	call   291 <exit>

000000d4 <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
  d4:	f3 0f 1e fb          	endbr32 
  d8:	55                   	push   %ebp
  d9:	89 e5                	mov    %esp,%ebp
  db:	56                   	push   %esi
  dc:	53                   	push   %ebx
  dd:	8b 75 08             	mov    0x8(%ebp),%esi
  e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e3:	89 f0                	mov    %esi,%eax
  e5:	89 d1                	mov    %edx,%ecx
  e7:	83 c2 01             	add    $0x1,%edx
  ea:	89 c3                	mov    %eax,%ebx
  ec:	83 c0 01             	add    $0x1,%eax
  ef:	0f b6 09             	movzbl (%ecx),%ecx
  f2:	88 0b                	mov    %cl,(%ebx)
  f4:	84 c9                	test   %cl,%cl
  f6:	75 ed                	jne    e5 <strcpy+0x11>
    ;
  return os;
}
  f8:	89 f0                	mov    %esi,%eax
  fa:	5b                   	pop    %ebx
  fb:	5e                   	pop    %esi
  fc:	5d                   	pop    %ebp
  fd:	c3                   	ret    

000000fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fe:	f3 0f 1e fb          	endbr32 
 102:	55                   	push   %ebp
 103:	89 e5                	mov    %esp,%ebp
 105:	8b 4d 08             	mov    0x8(%ebp),%ecx
 108:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 10b:	0f b6 01             	movzbl (%ecx),%eax
 10e:	84 c0                	test   %al,%al
 110:	74 0c                	je     11e <strcmp+0x20>
 112:	3a 02                	cmp    (%edx),%al
 114:	75 08                	jne    11e <strcmp+0x20>
    p++, q++;
 116:	83 c1 01             	add    $0x1,%ecx
 119:	83 c2 01             	add    $0x1,%edx
 11c:	eb ed                	jmp    10b <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 11e:	0f b6 c0             	movzbl %al,%eax
 121:	0f b6 12             	movzbl (%edx),%edx
 124:	29 d0                	sub    %edx,%eax
}
 126:	5d                   	pop    %ebp
 127:	c3                   	ret    

00000128 <strlen>:

int
strlen(const char *s)
{
 128:	f3 0f 1e fb          	endbr32 
 12c:	55                   	push   %ebp
 12d:	89 e5                	mov    %esp,%ebp
 12f:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 132:	b8 00 00 00 00       	mov    $0x0,%eax
 137:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 13b:	74 05                	je     142 <strlen+0x1a>
 13d:	83 c0 01             	add    $0x1,%eax
 140:	eb f5                	jmp    137 <strlen+0xf>
    ;
  return n;
}
 142:	5d                   	pop    %ebp
 143:	c3                   	ret    

00000144 <memset>:

void*
memset(void *dst, int c, int n)
{
 144:	f3 0f 1e fb          	endbr32 
 148:	55                   	push   %ebp
 149:	89 e5                	mov    %esp,%ebp
 14b:	57                   	push   %edi
 14c:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 14f:	89 d7                	mov    %edx,%edi
 151:	8b 4d 10             	mov    0x10(%ebp),%ecx
 154:	8b 45 0c             	mov    0xc(%ebp),%eax
 157:	fc                   	cld    
 158:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 15a:	89 d0                	mov    %edx,%eax
 15c:	5f                   	pop    %edi
 15d:	5d                   	pop    %ebp
 15e:	c3                   	ret    

0000015f <strchr>:

char*
strchr(const char *s, char c)
{
 15f:	f3 0f 1e fb          	endbr32 
 163:	55                   	push   %ebp
 164:	89 e5                	mov    %esp,%ebp
 166:	8b 45 08             	mov    0x8(%ebp),%eax
 169:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 16d:	0f b6 10             	movzbl (%eax),%edx
 170:	84 d2                	test   %dl,%dl
 172:	74 09                	je     17d <strchr+0x1e>
    if(*s == c)
 174:	38 ca                	cmp    %cl,%dl
 176:	74 0a                	je     182 <strchr+0x23>
  for(; *s; s++)
 178:	83 c0 01             	add    $0x1,%eax
 17b:	eb f0                	jmp    16d <strchr+0xe>
      return (char*)s;
  return 0;
 17d:	b8 00 00 00 00       	mov    $0x0,%eax
}
 182:	5d                   	pop    %ebp
 183:	c3                   	ret    

00000184 <gets>:

char*
gets(char *buf, int max)
{
 184:	f3 0f 1e fb          	endbr32 
 188:	55                   	push   %ebp
 189:	89 e5                	mov    %esp,%ebp
 18b:	57                   	push   %edi
 18c:	56                   	push   %esi
 18d:	53                   	push   %ebx
 18e:	83 ec 1c             	sub    $0x1c,%esp
 191:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 194:	bb 00 00 00 00       	mov    $0x0,%ebx
 199:	89 de                	mov    %ebx,%esi
 19b:	83 c3 01             	add    $0x1,%ebx
 19e:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1a1:	7d 2e                	jge    1d1 <gets+0x4d>
    cc = read(0, &c, 1);
 1a3:	83 ec 04             	sub    $0x4,%esp
 1a6:	6a 01                	push   $0x1
 1a8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1ab:	50                   	push   %eax
 1ac:	6a 00                	push   $0x0
 1ae:	e8 f6 00 00 00       	call   2a9 <read>
    if(cc < 1)
 1b3:	83 c4 10             	add    $0x10,%esp
 1b6:	85 c0                	test   %eax,%eax
 1b8:	7e 17                	jle    1d1 <gets+0x4d>
      break;
    buf[i++] = c;
 1ba:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 1be:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1c1:	3c 0a                	cmp    $0xa,%al
 1c3:	0f 94 c2             	sete   %dl
 1c6:	3c 0d                	cmp    $0xd,%al
 1c8:	0f 94 c0             	sete   %al
 1cb:	08 c2                	or     %al,%dl
 1cd:	74 ca                	je     199 <gets+0x15>
    buf[i++] = c;
 1cf:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 1d1:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 1d5:	89 f8                	mov    %edi,%eax
 1d7:	8d 65 f4             	lea    -0xc(%ebp),%esp
 1da:	5b                   	pop    %ebx
 1db:	5e                   	pop    %esi
 1dc:	5f                   	pop    %edi
 1dd:	5d                   	pop    %ebp
 1de:	c3                   	ret    

000001df <stat>:

int
stat(const char *n, struct stat *st)
{
 1df:	f3 0f 1e fb          	endbr32 
 1e3:	55                   	push   %ebp
 1e4:	89 e5                	mov    %esp,%ebp
 1e6:	56                   	push   %esi
 1e7:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	83 ec 08             	sub    $0x8,%esp
 1eb:	6a 00                	push   $0x0
 1ed:	ff 75 08             	pushl  0x8(%ebp)
 1f0:	e8 dc 00 00 00       	call   2d1 <open>
  if(fd < 0)
 1f5:	83 c4 10             	add    $0x10,%esp
 1f8:	85 c0                	test   %eax,%eax
 1fa:	78 24                	js     220 <stat+0x41>
 1fc:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 1fe:	83 ec 08             	sub    $0x8,%esp
 201:	ff 75 0c             	pushl  0xc(%ebp)
 204:	50                   	push   %eax
 205:	e8 df 00 00 00       	call   2e9 <fstat>
 20a:	89 c6                	mov    %eax,%esi
  close(fd);
 20c:	89 1c 24             	mov    %ebx,(%esp)
 20f:	e8 a5 00 00 00       	call   2b9 <close>
  return r;
 214:	83 c4 10             	add    $0x10,%esp
}
 217:	89 f0                	mov    %esi,%eax
 219:	8d 65 f8             	lea    -0x8(%ebp),%esp
 21c:	5b                   	pop    %ebx
 21d:	5e                   	pop    %esi
 21e:	5d                   	pop    %ebp
 21f:	c3                   	ret    
    return -1;
 220:	be ff ff ff ff       	mov    $0xffffffff,%esi
 225:	eb f0                	jmp    217 <stat+0x38>

00000227 <atoi>:

int
atoi(const char *s)
{
 227:	f3 0f 1e fb          	endbr32 
 22b:	55                   	push   %ebp
 22c:	89 e5                	mov    %esp,%ebp
 22e:	53                   	push   %ebx
 22f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 232:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 237:	0f b6 01             	movzbl (%ecx),%eax
 23a:	8d 58 d0             	lea    -0x30(%eax),%ebx
 23d:	80 fb 09             	cmp    $0x9,%bl
 240:	77 12                	ja     254 <atoi+0x2d>
    n = n*10 + *s++ - '0';
 242:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 245:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 248:	83 c1 01             	add    $0x1,%ecx
 24b:	0f be c0             	movsbl %al,%eax
 24e:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 252:	eb e3                	jmp    237 <atoi+0x10>
  return n;
}
 254:	89 d0                	mov    %edx,%eax
 256:	5b                   	pop    %ebx
 257:	5d                   	pop    %ebp
 258:	c3                   	ret    

00000259 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 259:	f3 0f 1e fb          	endbr32 
 25d:	55                   	push   %ebp
 25e:	89 e5                	mov    %esp,%ebp
 260:	56                   	push   %esi
 261:	53                   	push   %ebx
 262:	8b 75 08             	mov    0x8(%ebp),%esi
 265:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 268:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 26b:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 26d:	8d 58 ff             	lea    -0x1(%eax),%ebx
 270:	85 c0                	test   %eax,%eax
 272:	7e 0f                	jle    283 <memmove+0x2a>
    *dst++ = *src++;
 274:	0f b6 01             	movzbl (%ecx),%eax
 277:	88 02                	mov    %al,(%edx)
 279:	8d 49 01             	lea    0x1(%ecx),%ecx
 27c:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 27f:	89 d8                	mov    %ebx,%eax
 281:	eb ea                	jmp    26d <memmove+0x14>
  return vdst;
}
 283:	89 f0                	mov    %esi,%eax
 285:	5b                   	pop    %ebx
 286:	5e                   	pop    %esi
 287:	5d                   	pop    %ebp
 288:	c3                   	ret    

00000289 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 289:	b8 01 00 00 00       	mov    $0x1,%eax
 28e:	cd 40                	int    $0x40
 290:	c3                   	ret    

00000291 <exit>:
SYSCALL(exit)
 291:	b8 02 00 00 00       	mov    $0x2,%eax
 296:	cd 40                	int    $0x40
 298:	c3                   	ret    

00000299 <wait>:
SYSCALL(wait)
 299:	b8 03 00 00 00       	mov    $0x3,%eax
 29e:	cd 40                	int    $0x40
 2a0:	c3                   	ret    

000002a1 <pipe>:
SYSCALL(pipe)
 2a1:	b8 04 00 00 00       	mov    $0x4,%eax
 2a6:	cd 40                	int    $0x40
 2a8:	c3                   	ret    

000002a9 <read>:
SYSCALL(read)
 2a9:	b8 05 00 00 00       	mov    $0x5,%eax
 2ae:	cd 40                	int    $0x40
 2b0:	c3                   	ret    

000002b1 <write>:
SYSCALL(write)
 2b1:	b8 10 00 00 00       	mov    $0x10,%eax
 2b6:	cd 40                	int    $0x40
 2b8:	c3                   	ret    

000002b9 <close>:
SYSCALL(close)
 2b9:	b8 15 00 00 00       	mov    $0x15,%eax
 2be:	cd 40                	int    $0x40
 2c0:	c3                   	ret    

000002c1 <kill>:
SYSCALL(kill)
 2c1:	b8 06 00 00 00       	mov    $0x6,%eax
 2c6:	cd 40                	int    $0x40
 2c8:	c3                   	ret    

000002c9 <exec>:
SYSCALL(exec)
 2c9:	b8 07 00 00 00       	mov    $0x7,%eax
 2ce:	cd 40                	int    $0x40
 2d0:	c3                   	ret    

000002d1 <open>:
SYSCALL(open)
 2d1:	b8 0f 00 00 00       	mov    $0xf,%eax
 2d6:	cd 40                	int    $0x40
 2d8:	c3                   	ret    

000002d9 <mknod>:
SYSCALL(mknod)
 2d9:	b8 11 00 00 00       	mov    $0x11,%eax
 2de:	cd 40                	int    $0x40
 2e0:	c3                   	ret    

000002e1 <unlink>:
SYSCALL(unlink)
 2e1:	b8 12 00 00 00       	mov    $0x12,%eax
 2e6:	cd 40                	int    $0x40
 2e8:	c3                   	ret    

000002e9 <fstat>:
SYSCALL(fstat)
 2e9:	b8 08 00 00 00       	mov    $0x8,%eax
 2ee:	cd 40                	int    $0x40
 2f0:	c3                   	ret    

000002f1 <link>:
SYSCALL(link)
 2f1:	b8 13 00 00 00       	mov    $0x13,%eax
 2f6:	cd 40                	int    $0x40
 2f8:	c3                   	ret    

000002f9 <mkdir>:
SYSCALL(mkdir)
 2f9:	b8 14 00 00 00       	mov    $0x14,%eax
 2fe:	cd 40                	int    $0x40
 300:	c3                   	ret    

00000301 <chdir>:
SYSCALL(chdir)
 301:	b8 09 00 00 00       	mov    $0x9,%eax
 306:	cd 40                	int    $0x40
 308:	c3                   	ret    

00000309 <dup>:
SYSCALL(dup)
 309:	b8 0a 00 00 00       	mov    $0xa,%eax
 30e:	cd 40                	int    $0x40
 310:	c3                   	ret    

00000311 <getpid>:
SYSCALL(getpid)
 311:	b8 0b 00 00 00       	mov    $0xb,%eax
 316:	cd 40                	int    $0x40
 318:	c3                   	ret    

00000319 <sbrk>:
SYSCALL(sbrk)
 319:	b8 0c 00 00 00       	mov    $0xc,%eax
 31e:	cd 40                	int    $0x40
 320:	c3                   	ret    

00000321 <sleep>:
SYSCALL(sleep)
 321:	b8 0d 00 00 00       	mov    $0xd,%eax
 326:	cd 40                	int    $0x40
 328:	c3                   	ret    

00000329 <uptime>:
SYSCALL(uptime)
 329:	b8 0e 00 00 00       	mov    $0xe,%eax
 32e:	cd 40                	int    $0x40
 330:	c3                   	ret    

00000331 <getiocounts>:
SYSCALL(getiocounts)
 331:	b8 16 00 00 00       	mov    $0x16,%eax
 336:	cd 40                	int    $0x40
 338:	c3                   	ret    

00000339 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 339:	55                   	push   %ebp
 33a:	89 e5                	mov    %esp,%ebp
 33c:	83 ec 1c             	sub    $0x1c,%esp
 33f:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 342:	6a 01                	push   $0x1
 344:	8d 55 f4             	lea    -0xc(%ebp),%edx
 347:	52                   	push   %edx
 348:	50                   	push   %eax
 349:	e8 63 ff ff ff       	call   2b1 <write>
}
 34e:	83 c4 10             	add    $0x10,%esp
 351:	c9                   	leave  
 352:	c3                   	ret    

00000353 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 353:	55                   	push   %ebp
 354:	89 e5                	mov    %esp,%ebp
 356:	57                   	push   %edi
 357:	56                   	push   %esi
 358:	53                   	push   %ebx
 359:	83 ec 2c             	sub    $0x2c,%esp
 35c:	89 45 d0             	mov    %eax,-0x30(%ebp)
 35f:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 361:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 365:	0f 95 c2             	setne  %dl
 368:	89 f0                	mov    %esi,%eax
 36a:	c1 e8 1f             	shr    $0x1f,%eax
 36d:	84 c2                	test   %al,%dl
 36f:	74 42                	je     3b3 <printint+0x60>
    neg = 1;
    x = -xx;
 371:	f7 de                	neg    %esi
    neg = 1;
 373:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 37a:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 37f:	89 f0                	mov    %esi,%eax
 381:	ba 00 00 00 00       	mov    $0x0,%edx
 386:	f7 f1                	div    %ecx
 388:	89 df                	mov    %ebx,%edi
 38a:	83 c3 01             	add    $0x1,%ebx
 38d:	0f b6 92 ac 06 00 00 	movzbl 0x6ac(%edx),%edx
 394:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 398:	89 f2                	mov    %esi,%edx
 39a:	89 c6                	mov    %eax,%esi
 39c:	39 d1                	cmp    %edx,%ecx
 39e:	76 df                	jbe    37f <printint+0x2c>
  if(neg)
 3a0:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 3a4:	74 2f                	je     3d5 <printint+0x82>
    buf[i++] = '-';
 3a6:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3ab:	8d 5f 02             	lea    0x2(%edi),%ebx
 3ae:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3b1:	eb 15                	jmp    3c8 <printint+0x75>
  neg = 0;
 3b3:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 3ba:	eb be                	jmp    37a <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 3bc:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3c1:	89 f0                	mov    %esi,%eax
 3c3:	e8 71 ff ff ff       	call   339 <putc>
  while(--i >= 0)
 3c8:	83 eb 01             	sub    $0x1,%ebx
 3cb:	79 ef                	jns    3bc <printint+0x69>
}
 3cd:	83 c4 2c             	add    $0x2c,%esp
 3d0:	5b                   	pop    %ebx
 3d1:	5e                   	pop    %esi
 3d2:	5f                   	pop    %edi
 3d3:	5d                   	pop    %ebp
 3d4:	c3                   	ret    
 3d5:	8b 75 d0             	mov    -0x30(%ebp),%esi
 3d8:	eb ee                	jmp    3c8 <printint+0x75>

000003da <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3da:	f3 0f 1e fb          	endbr32 
 3de:	55                   	push   %ebp
 3df:	89 e5                	mov    %esp,%ebp
 3e1:	57                   	push   %edi
 3e2:	56                   	push   %esi
 3e3:	53                   	push   %ebx
 3e4:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3e7:	8d 45 10             	lea    0x10(%ebp),%eax
 3ea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3ed:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 3f2:	bb 00 00 00 00       	mov    $0x0,%ebx
 3f7:	eb 14                	jmp    40d <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 3f9:	89 fa                	mov    %edi,%edx
 3fb:	8b 45 08             	mov    0x8(%ebp),%eax
 3fe:	e8 36 ff ff ff       	call   339 <putc>
 403:	eb 05                	jmp    40a <printf+0x30>
      }
    } else if(state == '%'){
 405:	83 fe 25             	cmp    $0x25,%esi
 408:	74 25                	je     42f <printf+0x55>
  for(i = 0; fmt[i]; i++){
 40a:	83 c3 01             	add    $0x1,%ebx
 40d:	8b 45 0c             	mov    0xc(%ebp),%eax
 410:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 414:	84 c0                	test   %al,%al
 416:	0f 84 23 01 00 00    	je     53f <printf+0x165>
    c = fmt[i] & 0xff;
 41c:	0f be f8             	movsbl %al,%edi
 41f:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 422:	85 f6                	test   %esi,%esi
 424:	75 df                	jne    405 <printf+0x2b>
      if(c == '%'){
 426:	83 f8 25             	cmp    $0x25,%eax
 429:	75 ce                	jne    3f9 <printf+0x1f>
        state = '%';
 42b:	89 c6                	mov    %eax,%esi
 42d:	eb db                	jmp    40a <printf+0x30>
      if(c == 'd'){
 42f:	83 f8 64             	cmp    $0x64,%eax
 432:	74 49                	je     47d <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 434:	83 f8 78             	cmp    $0x78,%eax
 437:	0f 94 c1             	sete   %cl
 43a:	83 f8 70             	cmp    $0x70,%eax
 43d:	0f 94 c2             	sete   %dl
 440:	08 d1                	or     %dl,%cl
 442:	75 63                	jne    4a7 <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 444:	83 f8 73             	cmp    $0x73,%eax
 447:	0f 84 84 00 00 00    	je     4d1 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 44d:	83 f8 63             	cmp    $0x63,%eax
 450:	0f 84 b7 00 00 00    	je     50d <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 456:	83 f8 25             	cmp    $0x25,%eax
 459:	0f 84 cc 00 00 00    	je     52b <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 45f:	ba 25 00 00 00       	mov    $0x25,%edx
 464:	8b 45 08             	mov    0x8(%ebp),%eax
 467:	e8 cd fe ff ff       	call   339 <putc>
        putc(fd, c);
 46c:	89 fa                	mov    %edi,%edx
 46e:	8b 45 08             	mov    0x8(%ebp),%eax
 471:	e8 c3 fe ff ff       	call   339 <putc>
      }
      state = 0;
 476:	be 00 00 00 00       	mov    $0x0,%esi
 47b:	eb 8d                	jmp    40a <printf+0x30>
        printint(fd, *ap, 10, 1);
 47d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 480:	8b 17                	mov    (%edi),%edx
 482:	83 ec 0c             	sub    $0xc,%esp
 485:	6a 01                	push   $0x1
 487:	b9 0a 00 00 00       	mov    $0xa,%ecx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 bf fe ff ff       	call   353 <printint>
        ap++;
 494:	83 c7 04             	add    $0x4,%edi
 497:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 49a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 49d:	be 00 00 00 00       	mov    $0x0,%esi
 4a2:	e9 63 ff ff ff       	jmp    40a <printf+0x30>
        printint(fd, *ap, 16, 0);
 4a7:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4aa:	8b 17                	mov    (%edi),%edx
 4ac:	83 ec 0c             	sub    $0xc,%esp
 4af:	6a 00                	push   $0x0
 4b1:	b9 10 00 00 00       	mov    $0x10,%ecx
 4b6:	8b 45 08             	mov    0x8(%ebp),%eax
 4b9:	e8 95 fe ff ff       	call   353 <printint>
        ap++;
 4be:	83 c7 04             	add    $0x4,%edi
 4c1:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4c4:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c7:	be 00 00 00 00       	mov    $0x0,%esi
 4cc:	e9 39 ff ff ff       	jmp    40a <printf+0x30>
        s = (char*)*ap;
 4d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4d4:	8b 30                	mov    (%eax),%esi
        ap++;
 4d6:	83 c0 04             	add    $0x4,%eax
 4d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4dc:	85 f6                	test   %esi,%esi
 4de:	75 28                	jne    508 <printf+0x12e>
          s = "(null)";
 4e0:	be a2 06 00 00       	mov    $0x6a2,%esi
 4e5:	8b 7d 08             	mov    0x8(%ebp),%edi
 4e8:	eb 0d                	jmp    4f7 <printf+0x11d>
          putc(fd, *s);
 4ea:	0f be d2             	movsbl %dl,%edx
 4ed:	89 f8                	mov    %edi,%eax
 4ef:	e8 45 fe ff ff       	call   339 <putc>
          s++;
 4f4:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 4f7:	0f b6 16             	movzbl (%esi),%edx
 4fa:	84 d2                	test   %dl,%dl
 4fc:	75 ec                	jne    4ea <printf+0x110>
      state = 0;
 4fe:	be 00 00 00 00       	mov    $0x0,%esi
 503:	e9 02 ff ff ff       	jmp    40a <printf+0x30>
 508:	8b 7d 08             	mov    0x8(%ebp),%edi
 50b:	eb ea                	jmp    4f7 <printf+0x11d>
        putc(fd, *ap);
 50d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 510:	0f be 17             	movsbl (%edi),%edx
 513:	8b 45 08             	mov    0x8(%ebp),%eax
 516:	e8 1e fe ff ff       	call   339 <putc>
        ap++;
 51b:	83 c7 04             	add    $0x4,%edi
 51e:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 521:	be 00 00 00 00       	mov    $0x0,%esi
 526:	e9 df fe ff ff       	jmp    40a <printf+0x30>
        putc(fd, c);
 52b:	89 fa                	mov    %edi,%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 04 fe ff ff       	call   339 <putc>
      state = 0;
 535:	be 00 00 00 00       	mov    $0x0,%esi
 53a:	e9 cb fe ff ff       	jmp    40a <printf+0x30>
    }
  }
}
 53f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 542:	5b                   	pop    %ebx
 543:	5e                   	pop    %esi
 544:	5f                   	pop    %edi
 545:	5d                   	pop    %ebp
 546:	c3                   	ret    

00000547 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 547:	f3 0f 1e fb          	endbr32 
 54b:	55                   	push   %ebp
 54c:	89 e5                	mov    %esp,%ebp
 54e:	57                   	push   %edi
 54f:	56                   	push   %esi
 550:	53                   	push   %ebx
 551:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 554:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 557:	a1 58 09 00 00       	mov    0x958,%eax
 55c:	eb 02                	jmp    560 <free+0x19>
 55e:	89 d0                	mov    %edx,%eax
 560:	39 c8                	cmp    %ecx,%eax
 562:	73 04                	jae    568 <free+0x21>
 564:	39 08                	cmp    %ecx,(%eax)
 566:	77 12                	ja     57a <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 568:	8b 10                	mov    (%eax),%edx
 56a:	39 c2                	cmp    %eax,%edx
 56c:	77 f0                	ja     55e <free+0x17>
 56e:	39 c8                	cmp    %ecx,%eax
 570:	72 08                	jb     57a <free+0x33>
 572:	39 ca                	cmp    %ecx,%edx
 574:	77 04                	ja     57a <free+0x33>
 576:	89 d0                	mov    %edx,%eax
 578:	eb e6                	jmp    560 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 57a:	8b 73 fc             	mov    -0x4(%ebx),%esi
 57d:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 580:	8b 10                	mov    (%eax),%edx
 582:	39 d7                	cmp    %edx,%edi
 584:	74 19                	je     59f <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 586:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 589:	8b 50 04             	mov    0x4(%eax),%edx
 58c:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 58f:	39 ce                	cmp    %ecx,%esi
 591:	74 1b                	je     5ae <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 593:	89 08                	mov    %ecx,(%eax)
  freep = p;
 595:	a3 58 09 00 00       	mov    %eax,0x958
}
 59a:	5b                   	pop    %ebx
 59b:	5e                   	pop    %esi
 59c:	5f                   	pop    %edi
 59d:	5d                   	pop    %ebp
 59e:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 59f:	03 72 04             	add    0x4(%edx),%esi
 5a2:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 5a5:	8b 10                	mov    (%eax),%edx
 5a7:	8b 12                	mov    (%edx),%edx
 5a9:	89 53 f8             	mov    %edx,-0x8(%ebx)
 5ac:	eb db                	jmp    589 <free+0x42>
    p->s.size += bp->s.size;
 5ae:	03 53 fc             	add    -0x4(%ebx),%edx
 5b1:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 5b4:	8b 53 f8             	mov    -0x8(%ebx),%edx
 5b7:	89 10                	mov    %edx,(%eax)
 5b9:	eb da                	jmp    595 <free+0x4e>

000005bb <morecore>:

static Header*
morecore(uint nu)
{
 5bb:	55                   	push   %ebp
 5bc:	89 e5                	mov    %esp,%ebp
 5be:	53                   	push   %ebx
 5bf:	83 ec 04             	sub    $0x4,%esp
 5c2:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 5c4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 5c9:	77 05                	ja     5d0 <morecore+0x15>
    nu = 4096;
 5cb:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 5d0:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 5d7:	83 ec 0c             	sub    $0xc,%esp
 5da:	50                   	push   %eax
 5db:	e8 39 fd ff ff       	call   319 <sbrk>
  if(p == (char*)-1)
 5e0:	83 c4 10             	add    $0x10,%esp
 5e3:	83 f8 ff             	cmp    $0xffffffff,%eax
 5e6:	74 1c                	je     604 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 5e8:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 5eb:	83 c0 08             	add    $0x8,%eax
 5ee:	83 ec 0c             	sub    $0xc,%esp
 5f1:	50                   	push   %eax
 5f2:	e8 50 ff ff ff       	call   547 <free>
  return freep;
 5f7:	a1 58 09 00 00       	mov    0x958,%eax
 5fc:	83 c4 10             	add    $0x10,%esp
}
 5ff:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 602:	c9                   	leave  
 603:	c3                   	ret    
    return 0;
 604:	b8 00 00 00 00       	mov    $0x0,%eax
 609:	eb f4                	jmp    5ff <morecore+0x44>

0000060b <malloc>:

void*
malloc(int nbytes)
{
 60b:	f3 0f 1e fb          	endbr32 
 60f:	55                   	push   %ebp
 610:	89 e5                	mov    %esp,%ebp
 612:	53                   	push   %ebx
 613:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 616:	8b 45 08             	mov    0x8(%ebp),%eax
 619:	8d 58 07             	lea    0x7(%eax),%ebx
 61c:	c1 eb 03             	shr    $0x3,%ebx
 61f:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 622:	8b 0d 58 09 00 00    	mov    0x958,%ecx
 628:	85 c9                	test   %ecx,%ecx
 62a:	74 04                	je     630 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 62c:	8b 01                	mov    (%ecx),%eax
 62e:	eb 4b                	jmp    67b <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 630:	c7 05 58 09 00 00 5c 	movl   $0x95c,0x958
 637:	09 00 00 
 63a:	c7 05 5c 09 00 00 5c 	movl   $0x95c,0x95c
 641:	09 00 00 
    base.s.size = 0;
 644:	c7 05 60 09 00 00 00 	movl   $0x0,0x960
 64b:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 64e:	b9 5c 09 00 00       	mov    $0x95c,%ecx
 653:	eb d7                	jmp    62c <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 655:	74 1a                	je     671 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 657:	29 da                	sub    %ebx,%edx
 659:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 65c:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 65f:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 662:	89 0d 58 09 00 00    	mov    %ecx,0x958
      return (void*)(p + 1);
 668:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 66b:	83 c4 04             	add    $0x4,%esp
 66e:	5b                   	pop    %ebx
 66f:	5d                   	pop    %ebp
 670:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 671:	8b 10                	mov    (%eax),%edx
 673:	89 11                	mov    %edx,(%ecx)
 675:	eb eb                	jmp    662 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 677:	89 c1                	mov    %eax,%ecx
 679:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 67b:	8b 50 04             	mov    0x4(%eax),%edx
 67e:	39 da                	cmp    %ebx,%edx
 680:	73 d3                	jae    655 <malloc+0x4a>
    if(p == freep)
 682:	39 05 58 09 00 00    	cmp    %eax,0x958
 688:	75 ed                	jne    677 <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 68a:	89 d8                	mov    %ebx,%eax
 68c:	e8 2a ff ff ff       	call   5bb <morecore>
 691:	85 c0                	test   %eax,%eax
 693:	75 e2                	jne    677 <malloc+0x6c>
 695:	eb d4                	jmp    66b <malloc+0x60>
