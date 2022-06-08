
_wc:     file format elf32-i386


Disassembly of section .text:

00000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 1c             	sub    $0x1c,%esp
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
   d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  l = w = c = 0;
  14:	be 00 00 00 00       	mov    $0x0,%esi
  19:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  while((n = read(fd, buf, sizeof(buf))) > 0){
  27:	83 ec 04             	sub    $0x4,%esp
  2a:	68 00 02 00 00       	push   $0x200
  2f:	68 80 0a 00 00       	push   $0xa80
  34:	ff 75 08             	pushl  0x8(%ebp)
  37:	e8 03 03 00 00       	call   33f <read>
  3c:	89 c7                	mov    %eax,%edi
  3e:	83 c4 10             	add    $0x10,%esp
  41:	85 c0                	test   %eax,%eax
  43:	7e 54                	jle    99 <wc+0x99>
    for(i=0; i<n; i++){
  45:	bb 00 00 00 00       	mov    $0x0,%ebx
  4a:	eb 22                	jmp    6e <wc+0x6e>
      c++;
      if(buf[i] == '\n')
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  4c:	83 ec 08             	sub    $0x8,%esp
  4f:	0f be c0             	movsbl %al,%eax
  52:	50                   	push   %eax
  53:	68 30 07 00 00       	push   $0x730
  58:	e8 98 01 00 00       	call   1f5 <strchr>
  5d:	83 c4 10             	add    $0x10,%esp
  60:	85 c0                	test   %eax,%eax
  62:	74 22                	je     86 <wc+0x86>
        inword = 0;
  64:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for(i=0; i<n; i++){
  6b:	83 c3 01             	add    $0x1,%ebx
  6e:	39 fb                	cmp    %edi,%ebx
  70:	7d b5                	jge    27 <wc+0x27>
      c++;
  72:	83 c6 01             	add    $0x1,%esi
      if(buf[i] == '\n')
  75:	0f b6 83 80 0a 00 00 	movzbl 0xa80(%ebx),%eax
  7c:	3c 0a                	cmp    $0xa,%al
  7e:	75 cc                	jne    4c <wc+0x4c>
        l++;
  80:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
  84:	eb c6                	jmp    4c <wc+0x4c>
      else if(!inword){
  86:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8a:	75 df                	jne    6b <wc+0x6b>
        w++;
  8c:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
        inword = 1;
  90:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
  97:	eb d2                	jmp    6b <wc+0x6b>
      }
    }
  }
  if(n < 0){
  99:	78 24                	js     bf <wc+0xbf>
    printf(1, "wc: read error\n");
    exit();
  }
  printf(1, "%d %d %d %s\n", l, w, c, name);
  9b:	83 ec 08             	sub    $0x8,%esp
  9e:	ff 75 0c             	pushl  0xc(%ebp)
  a1:	56                   	push   %esi
  a2:	ff 75 dc             	pushl  -0x24(%ebp)
  a5:	ff 75 e0             	pushl  -0x20(%ebp)
  a8:	68 46 07 00 00       	push   $0x746
  ad:	6a 01                	push   $0x1
  af:	e8 bc 03 00 00       	call   470 <printf>
}
  b4:	83 c4 20             	add    $0x20,%esp
  b7:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ba:	5b                   	pop    %ebx
  bb:	5e                   	pop    %esi
  bc:	5f                   	pop    %edi
  bd:	5d                   	pop    %ebp
  be:	c3                   	ret    
    printf(1, "wc: read error\n");
  bf:	83 ec 08             	sub    $0x8,%esp
  c2:	68 36 07 00 00       	push   $0x736
  c7:	6a 01                	push   $0x1
  c9:	e8 a2 03 00 00       	call   470 <printf>
    exit();
  ce:	e8 54 02 00 00       	call   327 <exit>

000000d3 <main>:

int
main(int argc, char *argv[])
{
  d3:	f3 0f 1e fb          	endbr32 
  d7:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  db:	83 e4 f0             	and    $0xfffffff0,%esp
  de:	ff 71 fc             	pushl  -0x4(%ecx)
  e1:	55                   	push   %ebp
  e2:	89 e5                	mov    %esp,%ebp
  e4:	57                   	push   %edi
  e5:	56                   	push   %esi
  e6:	53                   	push   %ebx
  e7:	51                   	push   %ecx
  e8:	83 ec 18             	sub    $0x18,%esp
  eb:	8b 01                	mov    (%ecx),%eax
  ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  f0:	8b 51 04             	mov    0x4(%ecx),%edx
  f3:	89 55 e0             	mov    %edx,-0x20(%ebp)
  int fd, i;

  if(argc <= 1){
  f6:	83 f8 01             	cmp    $0x1,%eax
  f9:	7e 40                	jle    13b <main+0x68>
    wc(0, "");
    exit();
  }

  for(i = 1; i < argc; i++){
  fb:	be 01 00 00 00       	mov    $0x1,%esi
 100:	3b 75 e4             	cmp    -0x1c(%ebp),%esi
 103:	7d 60                	jge    165 <main+0x92>
    if((fd = open(argv[i], 0)) < 0){
 105:	8b 45 e0             	mov    -0x20(%ebp),%eax
 108:	8d 3c b0             	lea    (%eax,%esi,4),%edi
 10b:	83 ec 08             	sub    $0x8,%esp
 10e:	6a 00                	push   $0x0
 110:	ff 37                	pushl  (%edi)
 112:	e8 50 02 00 00       	call   367 <open>
 117:	89 c3                	mov    %eax,%ebx
 119:	83 c4 10             	add    $0x10,%esp
 11c:	85 c0                	test   %eax,%eax
 11e:	78 2f                	js     14f <main+0x7c>
      printf(1, "wc: cannot open %s\n", argv[i]);
      exit();
    }
    wc(fd, argv[i]);
 120:	83 ec 08             	sub    $0x8,%esp
 123:	ff 37                	pushl  (%edi)
 125:	50                   	push   %eax
 126:	e8 d5 fe ff ff       	call   0 <wc>
    close(fd);
 12b:	89 1c 24             	mov    %ebx,(%esp)
 12e:	e8 1c 02 00 00       	call   34f <close>
  for(i = 1; i < argc; i++){
 133:	83 c6 01             	add    $0x1,%esi
 136:	83 c4 10             	add    $0x10,%esp
 139:	eb c5                	jmp    100 <main+0x2d>
    wc(0, "");
 13b:	83 ec 08             	sub    $0x8,%esp
 13e:	68 45 07 00 00       	push   $0x745
 143:	6a 00                	push   $0x0
 145:	e8 b6 fe ff ff       	call   0 <wc>
    exit();
 14a:	e8 d8 01 00 00       	call   327 <exit>
      printf(1, "wc: cannot open %s\n", argv[i]);
 14f:	83 ec 04             	sub    $0x4,%esp
 152:	ff 37                	pushl  (%edi)
 154:	68 53 07 00 00       	push   $0x753
 159:	6a 01                	push   $0x1
 15b:	e8 10 03 00 00       	call   470 <printf>
      exit();
 160:	e8 c2 01 00 00       	call   327 <exit>
  }
  exit();
 165:	e8 bd 01 00 00       	call   327 <exit>

0000016a <strcpy>:
#include "user.h"
#include "x86.h"

char*
strcpy(char *s, const char *t)
{
 16a:	f3 0f 1e fb          	endbr32 
 16e:	55                   	push   %ebp
 16f:	89 e5                	mov    %esp,%ebp
 171:	56                   	push   %esi
 172:	53                   	push   %ebx
 173:	8b 75 08             	mov    0x8(%ebp),%esi
 176:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 179:	89 f0                	mov    %esi,%eax
 17b:	89 d1                	mov    %edx,%ecx
 17d:	83 c2 01             	add    $0x1,%edx
 180:	89 c3                	mov    %eax,%ebx
 182:	83 c0 01             	add    $0x1,%eax
 185:	0f b6 09             	movzbl (%ecx),%ecx
 188:	88 0b                	mov    %cl,(%ebx)
 18a:	84 c9                	test   %cl,%cl
 18c:	75 ed                	jne    17b <strcpy+0x11>
    ;
  return os;
}
 18e:	89 f0                	mov    %esi,%eax
 190:	5b                   	pop    %ebx
 191:	5e                   	pop    %esi
 192:	5d                   	pop    %ebp
 193:	c3                   	ret    

00000194 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 194:	f3 0f 1e fb          	endbr32 
 198:	55                   	push   %ebp
 199:	89 e5                	mov    %esp,%ebp
 19b:	8b 4d 08             	mov    0x8(%ebp),%ecx
 19e:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 1a1:	0f b6 01             	movzbl (%ecx),%eax
 1a4:	84 c0                	test   %al,%al
 1a6:	74 0c                	je     1b4 <strcmp+0x20>
 1a8:	3a 02                	cmp    (%edx),%al
 1aa:	75 08                	jne    1b4 <strcmp+0x20>
    p++, q++;
 1ac:	83 c1 01             	add    $0x1,%ecx
 1af:	83 c2 01             	add    $0x1,%edx
 1b2:	eb ed                	jmp    1a1 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 1b4:	0f b6 c0             	movzbl %al,%eax
 1b7:	0f b6 12             	movzbl (%edx),%edx
 1ba:	29 d0                	sub    %edx,%eax
}
 1bc:	5d                   	pop    %ebp
 1bd:	c3                   	ret    

000001be <strlen>:

int
strlen(const char *s)
{
 1be:	f3 0f 1e fb          	endbr32 
 1c2:	55                   	push   %ebp
 1c3:	89 e5                	mov    %esp,%ebp
 1c5:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
 1c8:	b8 00 00 00 00       	mov    $0x0,%eax
 1cd:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
 1d1:	74 05                	je     1d8 <strlen+0x1a>
 1d3:	83 c0 01             	add    $0x1,%eax
 1d6:	eb f5                	jmp    1cd <strlen+0xf>
    ;
  return n;
}
 1d8:	5d                   	pop    %ebp
 1d9:	c3                   	ret    

000001da <memset>:

void*
memset(void *dst, int c, int n)
{
 1da:	f3 0f 1e fb          	endbr32 
 1de:	55                   	push   %ebp
 1df:	89 e5                	mov    %esp,%ebp
 1e1:	57                   	push   %edi
 1e2:	8b 55 08             	mov    0x8(%ebp),%edx
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 1e5:	89 d7                	mov    %edx,%edi
 1e7:	8b 4d 10             	mov    0x10(%ebp),%ecx
 1ea:	8b 45 0c             	mov    0xc(%ebp),%eax
 1ed:	fc                   	cld    
 1ee:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 1f0:	89 d0                	mov    %edx,%eax
 1f2:	5f                   	pop    %edi
 1f3:	5d                   	pop    %ebp
 1f4:	c3                   	ret    

000001f5 <strchr>:

char*
strchr(const char *s, char c)
{
 1f5:	f3 0f 1e fb          	endbr32 
 1f9:	55                   	push   %ebp
 1fa:	89 e5                	mov    %esp,%ebp
 1fc:	8b 45 08             	mov    0x8(%ebp),%eax
 1ff:	0f b6 4d 0c          	movzbl 0xc(%ebp),%ecx
  for(; *s; s++)
 203:	0f b6 10             	movzbl (%eax),%edx
 206:	84 d2                	test   %dl,%dl
 208:	74 09                	je     213 <strchr+0x1e>
    if(*s == c)
 20a:	38 ca                	cmp    %cl,%dl
 20c:	74 0a                	je     218 <strchr+0x23>
  for(; *s; s++)
 20e:	83 c0 01             	add    $0x1,%eax
 211:	eb f0                	jmp    203 <strchr+0xe>
      return (char*)s;
  return 0;
 213:	b8 00 00 00 00       	mov    $0x0,%eax
}
 218:	5d                   	pop    %ebp
 219:	c3                   	ret    

0000021a <gets>:

char*
gets(char *buf, int max)
{
 21a:	f3 0f 1e fb          	endbr32 
 21e:	55                   	push   %ebp
 21f:	89 e5                	mov    %esp,%ebp
 221:	57                   	push   %edi
 222:	56                   	push   %esi
 223:	53                   	push   %ebx
 224:	83 ec 1c             	sub    $0x1c,%esp
 227:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 22a:	bb 00 00 00 00       	mov    $0x0,%ebx
 22f:	89 de                	mov    %ebx,%esi
 231:	83 c3 01             	add    $0x1,%ebx
 234:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 237:	7d 2e                	jge    267 <gets+0x4d>
    cc = read(0, &c, 1);
 239:	83 ec 04             	sub    $0x4,%esp
 23c:	6a 01                	push   $0x1
 23e:	8d 45 e7             	lea    -0x19(%ebp),%eax
 241:	50                   	push   %eax
 242:	6a 00                	push   $0x0
 244:	e8 f6 00 00 00       	call   33f <read>
    if(cc < 1)
 249:	83 c4 10             	add    $0x10,%esp
 24c:	85 c0                	test   %eax,%eax
 24e:	7e 17                	jle    267 <gets+0x4d>
      break;
    buf[i++] = c;
 250:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
 254:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 257:	3c 0a                	cmp    $0xa,%al
 259:	0f 94 c2             	sete   %dl
 25c:	3c 0d                	cmp    $0xd,%al
 25e:	0f 94 c0             	sete   %al
 261:	08 c2                	or     %al,%dl
 263:	74 ca                	je     22f <gets+0x15>
    buf[i++] = c;
 265:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 267:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 26b:	89 f8                	mov    %edi,%eax
 26d:	8d 65 f4             	lea    -0xc(%ebp),%esp
 270:	5b                   	pop    %ebx
 271:	5e                   	pop    %esi
 272:	5f                   	pop    %edi
 273:	5d                   	pop    %ebp
 274:	c3                   	ret    

00000275 <stat>:

int
stat(const char *n, struct stat *st)
{
 275:	f3 0f 1e fb          	endbr32 
 279:	55                   	push   %ebp
 27a:	89 e5                	mov    %esp,%ebp
 27c:	56                   	push   %esi
 27d:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 27e:	83 ec 08             	sub    $0x8,%esp
 281:	6a 00                	push   $0x0
 283:	ff 75 08             	pushl  0x8(%ebp)
 286:	e8 dc 00 00 00       	call   367 <open>
  if(fd < 0)
 28b:	83 c4 10             	add    $0x10,%esp
 28e:	85 c0                	test   %eax,%eax
 290:	78 24                	js     2b6 <stat+0x41>
 292:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 294:	83 ec 08             	sub    $0x8,%esp
 297:	ff 75 0c             	pushl  0xc(%ebp)
 29a:	50                   	push   %eax
 29b:	e8 df 00 00 00       	call   37f <fstat>
 2a0:	89 c6                	mov    %eax,%esi
  close(fd);
 2a2:	89 1c 24             	mov    %ebx,(%esp)
 2a5:	e8 a5 00 00 00       	call   34f <close>
  return r;
 2aa:	83 c4 10             	add    $0x10,%esp
}
 2ad:	89 f0                	mov    %esi,%eax
 2af:	8d 65 f8             	lea    -0x8(%ebp),%esp
 2b2:	5b                   	pop    %ebx
 2b3:	5e                   	pop    %esi
 2b4:	5d                   	pop    %ebp
 2b5:	c3                   	ret    
    return -1;
 2b6:	be ff ff ff ff       	mov    $0xffffffff,%esi
 2bb:	eb f0                	jmp    2ad <stat+0x38>

000002bd <atoi>:

int
atoi(const char *s)
{
 2bd:	f3 0f 1e fb          	endbr32 
 2c1:	55                   	push   %ebp
 2c2:	89 e5                	mov    %esp,%ebp
 2c4:	53                   	push   %ebx
 2c5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 2c8:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 2cd:	0f b6 01             	movzbl (%ecx),%eax
 2d0:	8d 58 d0             	lea    -0x30(%eax),%ebx
 2d3:	80 fb 09             	cmp    $0x9,%bl
 2d6:	77 12                	ja     2ea <atoi+0x2d>
    n = n*10 + *s++ - '0';
 2d8:	8d 1c 92             	lea    (%edx,%edx,4),%ebx
 2db:	8d 14 1b             	lea    (%ebx,%ebx,1),%edx
 2de:	83 c1 01             	add    $0x1,%ecx
 2e1:	0f be c0             	movsbl %al,%eax
 2e4:	8d 54 10 d0          	lea    -0x30(%eax,%edx,1),%edx
 2e8:	eb e3                	jmp    2cd <atoi+0x10>
  return n;
}
 2ea:	89 d0                	mov    %edx,%eax
 2ec:	5b                   	pop    %ebx
 2ed:	5d                   	pop    %ebp
 2ee:	c3                   	ret    

000002ef <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2ef:	f3 0f 1e fb          	endbr32 
 2f3:	55                   	push   %ebp
 2f4:	89 e5                	mov    %esp,%ebp
 2f6:	56                   	push   %esi
 2f7:	53                   	push   %ebx
 2f8:	8b 75 08             	mov    0x8(%ebp),%esi
 2fb:	8b 4d 0c             	mov    0xc(%ebp),%ecx
 2fe:	8b 45 10             	mov    0x10(%ebp),%eax
  char *dst;
  const char *src;

  dst = vdst;
 301:	89 f2                	mov    %esi,%edx
  src = vsrc;
  while(n-- > 0)
 303:	8d 58 ff             	lea    -0x1(%eax),%ebx
 306:	85 c0                	test   %eax,%eax
 308:	7e 0f                	jle    319 <memmove+0x2a>
    *dst++ = *src++;
 30a:	0f b6 01             	movzbl (%ecx),%eax
 30d:	88 02                	mov    %al,(%edx)
 30f:	8d 49 01             	lea    0x1(%ecx),%ecx
 312:	8d 52 01             	lea    0x1(%edx),%edx
  while(n-- > 0)
 315:	89 d8                	mov    %ebx,%eax
 317:	eb ea                	jmp    303 <memmove+0x14>
  return vdst;
}
 319:	89 f0                	mov    %esi,%eax
 31b:	5b                   	pop    %ebx
 31c:	5e                   	pop    %esi
 31d:	5d                   	pop    %ebp
 31e:	c3                   	ret    

0000031f <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 31f:	b8 01 00 00 00       	mov    $0x1,%eax
 324:	cd 40                	int    $0x40
 326:	c3                   	ret    

00000327 <exit>:
SYSCALL(exit)
 327:	b8 02 00 00 00       	mov    $0x2,%eax
 32c:	cd 40                	int    $0x40
 32e:	c3                   	ret    

0000032f <wait>:
SYSCALL(wait)
 32f:	b8 03 00 00 00       	mov    $0x3,%eax
 334:	cd 40                	int    $0x40
 336:	c3                   	ret    

00000337 <pipe>:
SYSCALL(pipe)
 337:	b8 04 00 00 00       	mov    $0x4,%eax
 33c:	cd 40                	int    $0x40
 33e:	c3                   	ret    

0000033f <read>:
SYSCALL(read)
 33f:	b8 05 00 00 00       	mov    $0x5,%eax
 344:	cd 40                	int    $0x40
 346:	c3                   	ret    

00000347 <write>:
SYSCALL(write)
 347:	b8 10 00 00 00       	mov    $0x10,%eax
 34c:	cd 40                	int    $0x40
 34e:	c3                   	ret    

0000034f <close>:
SYSCALL(close)
 34f:	b8 15 00 00 00       	mov    $0x15,%eax
 354:	cd 40                	int    $0x40
 356:	c3                   	ret    

00000357 <kill>:
SYSCALL(kill)
 357:	b8 06 00 00 00       	mov    $0x6,%eax
 35c:	cd 40                	int    $0x40
 35e:	c3                   	ret    

0000035f <exec>:
SYSCALL(exec)
 35f:	b8 07 00 00 00       	mov    $0x7,%eax
 364:	cd 40                	int    $0x40
 366:	c3                   	ret    

00000367 <open>:
SYSCALL(open)
 367:	b8 0f 00 00 00       	mov    $0xf,%eax
 36c:	cd 40                	int    $0x40
 36e:	c3                   	ret    

0000036f <mknod>:
SYSCALL(mknod)
 36f:	b8 11 00 00 00       	mov    $0x11,%eax
 374:	cd 40                	int    $0x40
 376:	c3                   	ret    

00000377 <unlink>:
SYSCALL(unlink)
 377:	b8 12 00 00 00       	mov    $0x12,%eax
 37c:	cd 40                	int    $0x40
 37e:	c3                   	ret    

0000037f <fstat>:
SYSCALL(fstat)
 37f:	b8 08 00 00 00       	mov    $0x8,%eax
 384:	cd 40                	int    $0x40
 386:	c3                   	ret    

00000387 <link>:
SYSCALL(link)
 387:	b8 13 00 00 00       	mov    $0x13,%eax
 38c:	cd 40                	int    $0x40
 38e:	c3                   	ret    

0000038f <mkdir>:
SYSCALL(mkdir)
 38f:	b8 14 00 00 00       	mov    $0x14,%eax
 394:	cd 40                	int    $0x40
 396:	c3                   	ret    

00000397 <chdir>:
SYSCALL(chdir)
 397:	b8 09 00 00 00       	mov    $0x9,%eax
 39c:	cd 40                	int    $0x40
 39e:	c3                   	ret    

0000039f <dup>:
SYSCALL(dup)
 39f:	b8 0a 00 00 00       	mov    $0xa,%eax
 3a4:	cd 40                	int    $0x40
 3a6:	c3                   	ret    

000003a7 <getpid>:
SYSCALL(getpid)
 3a7:	b8 0b 00 00 00       	mov    $0xb,%eax
 3ac:	cd 40                	int    $0x40
 3ae:	c3                   	ret    

000003af <sbrk>:
SYSCALL(sbrk)
 3af:	b8 0c 00 00 00       	mov    $0xc,%eax
 3b4:	cd 40                	int    $0x40
 3b6:	c3                   	ret    

000003b7 <sleep>:
SYSCALL(sleep)
 3b7:	b8 0d 00 00 00       	mov    $0xd,%eax
 3bc:	cd 40                	int    $0x40
 3be:	c3                   	ret    

000003bf <uptime>:
SYSCALL(uptime)
 3bf:	b8 0e 00 00 00       	mov    $0xe,%eax
 3c4:	cd 40                	int    $0x40
 3c6:	c3                   	ret    

000003c7 <getiocounts>:
SYSCALL(getiocounts)
 3c7:	b8 16 00 00 00       	mov    $0x16,%eax
 3cc:	cd 40                	int    $0x40
 3ce:	c3                   	ret    

000003cf <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 3cf:	55                   	push   %ebp
 3d0:	89 e5                	mov    %esp,%ebp
 3d2:	83 ec 1c             	sub    $0x1c,%esp
 3d5:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 3d8:	6a 01                	push   $0x1
 3da:	8d 55 f4             	lea    -0xc(%ebp),%edx
 3dd:	52                   	push   %edx
 3de:	50                   	push   %eax
 3df:	e8 63 ff ff ff       	call   347 <write>
}
 3e4:	83 c4 10             	add    $0x10,%esp
 3e7:	c9                   	leave  
 3e8:	c3                   	ret    

000003e9 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 3e9:	55                   	push   %ebp
 3ea:	89 e5                	mov    %esp,%ebp
 3ec:	57                   	push   %edi
 3ed:	56                   	push   %esi
 3ee:	53                   	push   %ebx
 3ef:	83 ec 2c             	sub    $0x2c,%esp
 3f2:	89 45 d0             	mov    %eax,-0x30(%ebp)
 3f5:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3fb:	0f 95 c2             	setne  %dl
 3fe:	89 f0                	mov    %esi,%eax
 400:	c1 e8 1f             	shr    $0x1f,%eax
 403:	84 c2                	test   %al,%dl
 405:	74 42                	je     449 <printint+0x60>
    neg = 1;
    x = -xx;
 407:	f7 de                	neg    %esi
    neg = 1;
 409:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
  } else {
    x = xx;
  }

  i = 0;
 410:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 415:	89 f0                	mov    %esi,%eax
 417:	ba 00 00 00 00       	mov    $0x0,%edx
 41c:	f7 f1                	div    %ecx
 41e:	89 df                	mov    %ebx,%edi
 420:	83 c3 01             	add    $0x1,%ebx
 423:	0f b6 92 70 07 00 00 	movzbl 0x770(%edx),%edx
 42a:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 42e:	89 f2                	mov    %esi,%edx
 430:	89 c6                	mov    %eax,%esi
 432:	39 d1                	cmp    %edx,%ecx
 434:	76 df                	jbe    415 <printint+0x2c>
  if(neg)
 436:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
 43a:	74 2f                	je     46b <printint+0x82>
    buf[i++] = '-';
 43c:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 441:	8d 5f 02             	lea    0x2(%edi),%ebx
 444:	8b 75 d0             	mov    -0x30(%ebp),%esi
 447:	eb 15                	jmp    45e <printint+0x75>
  neg = 0;
 449:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
 450:	eb be                	jmp    410 <printint+0x27>

  while(--i >= 0)
    putc(fd, buf[i]);
 452:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 457:	89 f0                	mov    %esi,%eax
 459:	e8 71 ff ff ff       	call   3cf <putc>
  while(--i >= 0)
 45e:	83 eb 01             	sub    $0x1,%ebx
 461:	79 ef                	jns    452 <printint+0x69>
}
 463:	83 c4 2c             	add    $0x2c,%esp
 466:	5b                   	pop    %ebx
 467:	5e                   	pop    %esi
 468:	5f                   	pop    %edi
 469:	5d                   	pop    %ebp
 46a:	c3                   	ret    
 46b:	8b 75 d0             	mov    -0x30(%ebp),%esi
 46e:	eb ee                	jmp    45e <printint+0x75>

00000470 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 470:	f3 0f 1e fb          	endbr32 
 474:	55                   	push   %ebp
 475:	89 e5                	mov    %esp,%ebp
 477:	57                   	push   %edi
 478:	56                   	push   %esi
 479:	53                   	push   %ebx
 47a:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 47d:	8d 45 10             	lea    0x10(%ebp),%eax
 480:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 483:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 488:	bb 00 00 00 00       	mov    $0x0,%ebx
 48d:	eb 14                	jmp    4a3 <printf+0x33>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 48f:	89 fa                	mov    %edi,%edx
 491:	8b 45 08             	mov    0x8(%ebp),%eax
 494:	e8 36 ff ff ff       	call   3cf <putc>
 499:	eb 05                	jmp    4a0 <printf+0x30>
      }
    } else if(state == '%'){
 49b:	83 fe 25             	cmp    $0x25,%esi
 49e:	74 25                	je     4c5 <printf+0x55>
  for(i = 0; fmt[i]; i++){
 4a0:	83 c3 01             	add    $0x1,%ebx
 4a3:	8b 45 0c             	mov    0xc(%ebp),%eax
 4a6:	0f b6 04 18          	movzbl (%eax,%ebx,1),%eax
 4aa:	84 c0                	test   %al,%al
 4ac:	0f 84 23 01 00 00    	je     5d5 <printf+0x165>
    c = fmt[i] & 0xff;
 4b2:	0f be f8             	movsbl %al,%edi
 4b5:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 4b8:	85 f6                	test   %esi,%esi
 4ba:	75 df                	jne    49b <printf+0x2b>
      if(c == '%'){
 4bc:	83 f8 25             	cmp    $0x25,%eax
 4bf:	75 ce                	jne    48f <printf+0x1f>
        state = '%';
 4c1:	89 c6                	mov    %eax,%esi
 4c3:	eb db                	jmp    4a0 <printf+0x30>
      if(c == 'd'){
 4c5:	83 f8 64             	cmp    $0x64,%eax
 4c8:	74 49                	je     513 <printf+0xa3>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 4ca:	83 f8 78             	cmp    $0x78,%eax
 4cd:	0f 94 c1             	sete   %cl
 4d0:	83 f8 70             	cmp    $0x70,%eax
 4d3:	0f 94 c2             	sete   %dl
 4d6:	08 d1                	or     %dl,%cl
 4d8:	75 63                	jne    53d <printf+0xcd>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 4da:	83 f8 73             	cmp    $0x73,%eax
 4dd:	0f 84 84 00 00 00    	je     567 <printf+0xf7>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 4e3:	83 f8 63             	cmp    $0x63,%eax
 4e6:	0f 84 b7 00 00 00    	je     5a3 <printf+0x133>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 4ec:	83 f8 25             	cmp    $0x25,%eax
 4ef:	0f 84 cc 00 00 00    	je     5c1 <printf+0x151>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 4f5:	ba 25 00 00 00       	mov    $0x25,%edx
 4fa:	8b 45 08             	mov    0x8(%ebp),%eax
 4fd:	e8 cd fe ff ff       	call   3cf <putc>
        putc(fd, c);
 502:	89 fa                	mov    %edi,%edx
 504:	8b 45 08             	mov    0x8(%ebp),%eax
 507:	e8 c3 fe ff ff       	call   3cf <putc>
      }
      state = 0;
 50c:	be 00 00 00 00       	mov    $0x0,%esi
 511:	eb 8d                	jmp    4a0 <printf+0x30>
        printint(fd, *ap, 10, 1);
 513:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 516:	8b 17                	mov    (%edi),%edx
 518:	83 ec 0c             	sub    $0xc,%esp
 51b:	6a 01                	push   $0x1
 51d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 522:	8b 45 08             	mov    0x8(%ebp),%eax
 525:	e8 bf fe ff ff       	call   3e9 <printint>
        ap++;
 52a:	83 c7 04             	add    $0x4,%edi
 52d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 530:	83 c4 10             	add    $0x10,%esp
      state = 0;
 533:	be 00 00 00 00       	mov    $0x0,%esi
 538:	e9 63 ff ff ff       	jmp    4a0 <printf+0x30>
        printint(fd, *ap, 16, 0);
 53d:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 540:	8b 17                	mov    (%edi),%edx
 542:	83 ec 0c             	sub    $0xc,%esp
 545:	6a 00                	push   $0x0
 547:	b9 10 00 00 00       	mov    $0x10,%ecx
 54c:	8b 45 08             	mov    0x8(%ebp),%eax
 54f:	e8 95 fe ff ff       	call   3e9 <printint>
        ap++;
 554:	83 c7 04             	add    $0x4,%edi
 557:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 55a:	83 c4 10             	add    $0x10,%esp
      state = 0;
 55d:	be 00 00 00 00       	mov    $0x0,%esi
 562:	e9 39 ff ff ff       	jmp    4a0 <printf+0x30>
        s = (char*)*ap;
 567:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 56a:	8b 30                	mov    (%eax),%esi
        ap++;
 56c:	83 c0 04             	add    $0x4,%eax
 56f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 572:	85 f6                	test   %esi,%esi
 574:	75 28                	jne    59e <printf+0x12e>
          s = "(null)";
 576:	be 67 07 00 00       	mov    $0x767,%esi
 57b:	8b 7d 08             	mov    0x8(%ebp),%edi
 57e:	eb 0d                	jmp    58d <printf+0x11d>
          putc(fd, *s);
 580:	0f be d2             	movsbl %dl,%edx
 583:	89 f8                	mov    %edi,%eax
 585:	e8 45 fe ff ff       	call   3cf <putc>
          s++;
 58a:	83 c6 01             	add    $0x1,%esi
        while(*s != 0){
 58d:	0f b6 16             	movzbl (%esi),%edx
 590:	84 d2                	test   %dl,%dl
 592:	75 ec                	jne    580 <printf+0x110>
      state = 0;
 594:	be 00 00 00 00       	mov    $0x0,%esi
 599:	e9 02 ff ff ff       	jmp    4a0 <printf+0x30>
 59e:	8b 7d 08             	mov    0x8(%ebp),%edi
 5a1:	eb ea                	jmp    58d <printf+0x11d>
        putc(fd, *ap);
 5a3:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 5a6:	0f be 17             	movsbl (%edi),%edx
 5a9:	8b 45 08             	mov    0x8(%ebp),%eax
 5ac:	e8 1e fe ff ff       	call   3cf <putc>
        ap++;
 5b1:	83 c7 04             	add    $0x4,%edi
 5b4:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 5b7:	be 00 00 00 00       	mov    $0x0,%esi
 5bc:	e9 df fe ff ff       	jmp    4a0 <printf+0x30>
        putc(fd, c);
 5c1:	89 fa                	mov    %edi,%edx
 5c3:	8b 45 08             	mov    0x8(%ebp),%eax
 5c6:	e8 04 fe ff ff       	call   3cf <putc>
      state = 0;
 5cb:	be 00 00 00 00       	mov    $0x0,%esi
 5d0:	e9 cb fe ff ff       	jmp    4a0 <printf+0x30>
    }
  }
}
 5d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5d8:	5b                   	pop    %ebx
 5d9:	5e                   	pop    %esi
 5da:	5f                   	pop    %edi
 5db:	5d                   	pop    %ebp
 5dc:	c3                   	ret    

000005dd <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 5dd:	f3 0f 1e fb          	endbr32 
 5e1:	55                   	push   %ebp
 5e2:	89 e5                	mov    %esp,%ebp
 5e4:	57                   	push   %edi
 5e5:	56                   	push   %esi
 5e6:	53                   	push   %ebx
 5e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 5ea:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 5ed:	a1 60 0a 00 00       	mov    0xa60,%eax
 5f2:	eb 02                	jmp    5f6 <free+0x19>
 5f4:	89 d0                	mov    %edx,%eax
 5f6:	39 c8                	cmp    %ecx,%eax
 5f8:	73 04                	jae    5fe <free+0x21>
 5fa:	39 08                	cmp    %ecx,(%eax)
 5fc:	77 12                	ja     610 <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 5fe:	8b 10                	mov    (%eax),%edx
 600:	39 c2                	cmp    %eax,%edx
 602:	77 f0                	ja     5f4 <free+0x17>
 604:	39 c8                	cmp    %ecx,%eax
 606:	72 08                	jb     610 <free+0x33>
 608:	39 ca                	cmp    %ecx,%edx
 60a:	77 04                	ja     610 <free+0x33>
 60c:	89 d0                	mov    %edx,%eax
 60e:	eb e6                	jmp    5f6 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 610:	8b 73 fc             	mov    -0x4(%ebx),%esi
 613:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 616:	8b 10                	mov    (%eax),%edx
 618:	39 d7                	cmp    %edx,%edi
 61a:	74 19                	je     635 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 61c:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 61f:	8b 50 04             	mov    0x4(%eax),%edx
 622:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 625:	39 ce                	cmp    %ecx,%esi
 627:	74 1b                	je     644 <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 629:	89 08                	mov    %ecx,(%eax)
  freep = p;
 62b:	a3 60 0a 00 00       	mov    %eax,0xa60
}
 630:	5b                   	pop    %ebx
 631:	5e                   	pop    %esi
 632:	5f                   	pop    %edi
 633:	5d                   	pop    %ebp
 634:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 635:	03 72 04             	add    0x4(%edx),%esi
 638:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 63b:	8b 10                	mov    (%eax),%edx
 63d:	8b 12                	mov    (%edx),%edx
 63f:	89 53 f8             	mov    %edx,-0x8(%ebx)
 642:	eb db                	jmp    61f <free+0x42>
    p->s.size += bp->s.size;
 644:	03 53 fc             	add    -0x4(%ebx),%edx
 647:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 64a:	8b 53 f8             	mov    -0x8(%ebx),%edx
 64d:	89 10                	mov    %edx,(%eax)
 64f:	eb da                	jmp    62b <free+0x4e>

00000651 <morecore>:

static Header*
morecore(uint nu)
{
 651:	55                   	push   %ebp
 652:	89 e5                	mov    %esp,%ebp
 654:	53                   	push   %ebx
 655:	83 ec 04             	sub    $0x4,%esp
 658:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 65a:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 65f:	77 05                	ja     666 <morecore+0x15>
    nu = 4096;
 661:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 666:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 66d:	83 ec 0c             	sub    $0xc,%esp
 670:	50                   	push   %eax
 671:	e8 39 fd ff ff       	call   3af <sbrk>
  if(p == (char*)-1)
 676:	83 c4 10             	add    $0x10,%esp
 679:	83 f8 ff             	cmp    $0xffffffff,%eax
 67c:	74 1c                	je     69a <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 67e:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 681:	83 c0 08             	add    $0x8,%eax
 684:	83 ec 0c             	sub    $0xc,%esp
 687:	50                   	push   %eax
 688:	e8 50 ff ff ff       	call   5dd <free>
  return freep;
 68d:	a1 60 0a 00 00       	mov    0xa60,%eax
 692:	83 c4 10             	add    $0x10,%esp
}
 695:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 698:	c9                   	leave  
 699:	c3                   	ret    
    return 0;
 69a:	b8 00 00 00 00       	mov    $0x0,%eax
 69f:	eb f4                	jmp    695 <morecore+0x44>

000006a1 <malloc>:

void*
malloc(int nbytes)
{
 6a1:	f3 0f 1e fb          	endbr32 
 6a5:	55                   	push   %ebp
 6a6:	89 e5                	mov    %esp,%ebp
 6a8:	53                   	push   %ebx
 6a9:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 6ac:	8b 45 08             	mov    0x8(%ebp),%eax
 6af:	8d 58 07             	lea    0x7(%eax),%ebx
 6b2:	c1 eb 03             	shr    $0x3,%ebx
 6b5:	83 c3 01             	add    $0x1,%ebx
  if((prevp = freep) == 0){
 6b8:	8b 0d 60 0a 00 00    	mov    0xa60,%ecx
 6be:	85 c9                	test   %ecx,%ecx
 6c0:	74 04                	je     6c6 <malloc+0x25>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 6c2:	8b 01                	mov    (%ecx),%eax
 6c4:	eb 4b                	jmp    711 <malloc+0x70>
    base.s.ptr = freep = prevp = &base;
 6c6:	c7 05 60 0a 00 00 64 	movl   $0xa64,0xa60
 6cd:	0a 00 00 
 6d0:	c7 05 64 0a 00 00 64 	movl   $0xa64,0xa64
 6d7:	0a 00 00 
    base.s.size = 0;
 6da:	c7 05 68 0a 00 00 00 	movl   $0x0,0xa68
 6e1:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 6e4:	b9 64 0a 00 00       	mov    $0xa64,%ecx
 6e9:	eb d7                	jmp    6c2 <malloc+0x21>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 6eb:	74 1a                	je     707 <malloc+0x66>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 6ed:	29 da                	sub    %ebx,%edx
 6ef:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 6f2:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 6f5:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 6f8:	89 0d 60 0a 00 00    	mov    %ecx,0xa60
      return (void*)(p + 1);
 6fe:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 701:	83 c4 04             	add    $0x4,%esp
 704:	5b                   	pop    %ebx
 705:	5d                   	pop    %ebp
 706:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 707:	8b 10                	mov    (%eax),%edx
 709:	89 11                	mov    %edx,(%ecx)
 70b:	eb eb                	jmp    6f8 <malloc+0x57>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 70d:	89 c1                	mov    %eax,%ecx
 70f:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 711:	8b 50 04             	mov    0x4(%eax),%edx
 714:	39 da                	cmp    %ebx,%edx
 716:	73 d3                	jae    6eb <malloc+0x4a>
    if(p == freep)
 718:	39 05 60 0a 00 00    	cmp    %eax,0xa60
 71e:	75 ed                	jne    70d <malloc+0x6c>
      if((p = morecore(nunits)) == 0)
 720:	89 d8                	mov    %ebx,%eax
 722:	e8 2a ff ff ff       	call   651 <morecore>
 727:	85 c0                	test   %eax,%eax
 729:	75 e2                	jne    70d <malloc+0x6c>
 72b:	eb d4                	jmp    701 <malloc+0x60>
