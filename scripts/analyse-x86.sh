#!/bin/sh
#
# Tavis Ormandy <taviso@gentoo.org> 2003
# Improvments by Will Woods <wwoods@gentoo.org>
# More Improvements by Brett Coady <bc1968au@yahoo.com.au> 2008
# Identify instruction set used in binary.
#
##################

# ksh massively out performs bash.
if test -x /bin/ksh -a "$BASH_VERSION"; then
	exec /bin/ksh "$0" "$@"
fi

# initialize everything to zero.
eval {i486,i586,ppro,mmx,sse,sse2,sse3,ssse3,sse41,sse42,sse4a,amd,amd2,cpuid}=0

# unfortunately there are mnemonic collissions between vendor sets
# so check vendor_id string, and enable relevant sets.
printf "Checking vendor_id string..."
if ! test "${1%=*}" == "--vendor"; then
	case "`grep -Em1 '^vendor_id.*: ' /proc/cpuinfo | cut -d\" \" -f2`" in
		*GenuineIntel*) vendor=intel; printf "GenuineIntel\n";;
		*AuthenticAMD*) vendor=amd; printf "AuthenticAMD\n";;
		*CyrixInstead*) vendor=cyrix; printf "CyrixInstead\n";;
		*GenuineTMx86*) vendor=transmeta; printf "GenuineTMx86\n";;
		*) vendor=other; printf "other\n";;
	esac
else
	# allow vendor to be overridden
	vendor=${1#*=}; shift
	printf "%s\n" $vendor
fi

# quick sanity tests.
if ! test "$1"; then
	printf "usage: %s [--vendor=intel|amd|cyrix|transmeta] /path/to/binary\n" $0 1>&2
	exit 1
elif ! test -e "$1"; then 
	printf "error: %s does not exist.\n" "$1" 1>&2
	exit 1
elif ! test -r "$1"; then
	printf "error: cant read %s.\n" "$1" 1>&2
	exit 1
fi

printf "Disassembling %s, please wait...\n" $1

# initialize screen output
case "$vendor" in
	*intel*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u sse2: %4u sse3: %4u ssse3: %4u sse4.1: %4u sse4.2: %4u\r" \
		$i486 $i586 $ppro $mmx $sse $sse2 $sse3 $ssse3 $sse41 $sse42;;
	*amd*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u 3dnow: %4u sse2: %4u sse3: %4u sse4a: %4u\r" \
		$i486 $i586 $ppro $mmx $sse $(($amd+$amd2))  $sse2 $sse3 $sse4a;;
	*cyrix*) printf "i486: %4u i586: %4u mmx: %4u\r" \
		$i486 $i586 $mmx;;
	*transmeta*) printf "i486: %4u i586: %4u mmx: %4u\r" \
		$i486 $i586 $mmx;;
	*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u sse2: %4u\r" \
		$i486 $i586 $ppro $mmx $sse $sse2;;
esac

# do the disassembling.

# %cr{0,2,3,4} version
# objdump -d $1 | cut -f3 |
objdump -d $1 | cut -f3 | cut -d" " -f1 | (
# %cr{0,2,3,4} version
# 	while read instruction operands; do
	while read instruction; do
 		case "$instruction" in
			"cmpxchg"|"xadd"|"bswap"|"invd"|"wbinvd"|"invlpg") let ++i486; print=1;;
			"rdmsr"|"wrmsr"|"rdtsc"|"cmpxch8B"|"rsm") let ++i586; print=1;;
			"cmovcc"|"fcmovcc"|"fcomi"|"fcomip"|"fucomi"|"fucomip"|"rdpmc"|"ud2") let ++ppro; print=1;;
			"emms"|"movd"|"movq"|"packsswb"|"packssdw"|"packuswb"|"paddb"|"paddw"|"paddd"|"paddsb"|"paddsw"|"paddusb"|"paddusw"|"pand"|"pandn"|"pcmpeqb"|"pcmpeqw"|"pcmpeqd"|"pcmpgtb"|"pcmpgtw"|"pcmpgtd"|"pmaddwd"|"pmulhw"|"pmullw"|"por"|"psllw"|"pslld"|"psllq"|"psraw"|"psrad"|"psrlw"|"psrld"|"psrlq"|"psubb"|"psubw"|"psubd"|"psubsb"|"psubsw"|"psubusb"|"psubusw"|"punpckhbw"|"punpckhwd"|"punpckhdq"|"punpcklbw"|"punpcklwd"|"punpckldq"|"pxor") let ++mmx; print=1;;
			"addps"|"addss"|"andnps"|"andps"|"cmpps"|"cmpss"|"comiss"|"cvtpi2ps"|"cvtps2pi"|"cvtsi2ss"|"cvtss2si"|"cvttps2pi"|"cvttss2si"|"divps"|"divss"|"fxrstor"|"fxsave"|"ldmxcsr"|"maxps"|"maxss"|"minps"|"minss"|"movaps"|"movhlps"|"movhps"|"movlhps"|"movlps"|"movmskps"|"movss"|"movups"|"mulps"|"mulss"|"orps"|"pavgb"|"pavgw"|"psadbw"|"rcpps"|"rcpss"|"rsqrtps"|"rsqrtss"|"shufps"|"sqrtps"|"sqrtss"|"stmxcsr"|"subps"|"subss"|"ucomiss"|"unpckhps"|"unpcklps"|"xorps"|"pextrw"|"pinsrw"|"pmaxsw"|"pmaxub"|"pminsw"|"pminub"|"pmovmskb"|"pmulhuw"|"pshufw"|"maskmovq"|"movntps"|"movntq"|"prefetch"|"sfence") let ++sse; print=1;;
			"addpd"|"addsd"|"andnpd"|"andpd"|"clflush"|"cmppd"|"cmpsd"|"comisd"|"cvtdq2pd"|"cvtdq2ps"|"cvtpd2pi"|"cvtpd2pq"|"cvtpd2ps"|"cvtpi2pd"|"cvtps2dq"|"cvtps2pd"|"cvtsd2si"|"cvtsd2ss"|"cvtsi2sd"|"cvtss2sd"|"cvttpd2pi"|"cvttpd2dq"|"cvttps2dq"|"cvttsd2si"|"divpd"|"divsd"|"lfence"|"maskmovdqu"|"maxpd"|"maxsd"|"mfence"|"minpd"|"minsd"|"movapd"|"movd"|"movdq2q"|"movdqa"|"movdqu"|"movhpd"|"movlpd"|"movmskpd"|"movntdq"|"movnti"|"movntpd"|"movq"|"movq2dq"|"movsd"|"movupd"|"mulpd"|"mulsd"|"orpd"|"packsswb"|"packssdw"|"packuswb"|"paddb"|"paddw"|"paddd"|"paddq"|"paddq"|"paddsb"|"paddsw"|"paddusb"|"paddusw"|"pand"|"pandn"|"pause"|"pavgb"|"pavgw"|"pcmpeqb"|"pcmpeqw"|"pcmpeqd"|"pcmpgtb"|"pcmpgtw"|"pcmpgtd"|"pextrw"|"pinsrw"|"pmaddwd"|"pmaxsw"|"pmaxub"|"pminsw"|"pminub"|"pmovmskb"|"pmulhw"|"pmulhuw"|"pmullw"|"pmuludq"|"pmuludq"|"por"|"psadbw"|"pshufd"|"pshufhw"|"pshuflw"|"pslldq"|"psllw"|"pslld"|"psllq"|"psraw"|"psrad"|"psrldq"|"psrlw"|"psrld"|"psrlq"|"psubb"|"psubw"|"psubd"|"psubq"|"psubq"|"psubsb"|"psubsw"|"psubusb"|"psubusw"|"psubsb"|"punpckhbw"|"punpckhwd"|"punpckhdq"|"punpckhqdq"|"punpcklbw"|"punpcklwd"|"punpckldq"|"punpcklqdq"|"pxor"|"shufpd"|"sqrtpd"|"sqrtsd"|"subpd"|"subsd"|"ucomisd"|"unpckhpd"|"unpcklpd"|"xorpd") let ++sse2; print=1;;
			"addsubpd"|"addsubps"|"haddpd"|"haddps"|"hsubpd"|"hsubps"|"lddqu"|"movddup"|"movshdup"|"movsldup"|"fisttp"|"monitor"|"mwait") let ++sse3; print=1;;
			"psignb"|"psignw"|"psignd"|"pabsb"|"pabsw"|"pabsd"|"palignr"|"pshufb"|"pmulhrsw"|"pmaddubsw"|"phsubw"|"phsubd"|"phsubsw"|"phaddw"|"phaddd"|"phaddsw") let ++ssse3; print=1;;
			"mpsadbw"|"phminposuw"|"pmuldq"|"pmulld"|"dpps"|"dppd"|"blendps"|"blendpd"|"blendvps"|"blendvpd"|"pblendvb"|"pblendw"|"pminsb"|"pmaxsb"|"pminuw"|"pmaxuw"|"pminud"|"pmaxud"|"pminsd"|"pmaxsd"|"roundps"|"roundss"|"roundpd"|"roundsd"|"insertps"|"pinsrb"|"pinsrd"|"pinsrq"|"extractps"|"pextrb"|"pextrw"|"pextrd"|"pextrq"|"pmovsxbw"|"pmovzxbw"|"pmovsxbd"|"pmovzxbd"|"pmovsxbq"|"pmovzxbq"|"pmovsxwd"|"pmovzxwd"|"pmovsxwq"|"pmovzxwq"|"pmovsxdq"|"pmovzxdq"|"ptest"|"pcmpeqq"|"packusdw"|"movntdqa") let ++sse4.1; print=1;;
			"crc32"|"pcmpestri"|"pcmpestrm"|"pcmpistri"|"pcmpistrm"|"pcmpgtq"|"popcnt") let ++sse4.2; print=1;;
			"lzcnt"|"popcnt"|"extrq"|"insertq"|"movntsd"|"movntss") let ++sse4a; print=1;;
			"pavgusb"|"pfadd"|"pfsub"|"pfsubr"|"pfacc"|"pfcmpge"|"pfcmpgt"|"pfcmpeq"|"pfmin"|"pfmax"|"pi2fw"|"pi2fd"|"pf2iw"|"pf2id"|"pfrcp"|"pfrsqrt"|"pfmul"|"pfrcpit1"|"pfrsqit1"|"pfrcpit2"|"pmulhrw"|"pswapw"|"femms"|"prefetch") let ++amd; print=1;;
			"pf2iw"|"pfnacc"|"pfpnacc"|"pi2fw"|"pswapd"|"maskmovq"|"movntq"|"pavgb"|"pavgw"|"pextrw"|"pinsrw"|"pmaxsw"|"pmaxub"|"pminsw"|"pminub"|"pmovmskb"|"pmulhuw"|"prefetchnta"|"prefetcht0"|"prefetcht1"|"prefetcht2"|"psadbw"|"pshufw"|"sfence") let ++amd2; print=1;;
			"cpuid") let ++cpuid ++i586; print=1;;
# %cr{0,2,3,4} version
#			"mov") [[ "$operands" == *%cr[0234]* ]] && let ++i586; print=1;;
		esac
	# check if screen needs updating.
	if test "$print"; then
		case "$vendor" in
			*intel*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u sse2: %4u sse3: %4u ssse3: %4u sse4.1: %4u sse4.2: %4u\r" \
				$i486 $i586 $ppro $mmx $sse $sse2 $sse3 $ssse3 $sse41 $sse42;;
			*amd*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u 3dnow: %4u sse2: %4u sse3: %4u sse4a: %4u\r" \
				$i486 $i586 $ppro $mmx $sse $(($amd+$amd2)) $sse2 $sse3 $sse4a;;
			*cyrix*) printf "i486: %4u i586: %4u mmx: %4u\r" \
				$i486 $i586 $mmx;;
			*transmeta*) printf "i486: %4u i586: %4u mmx: %4u\r" \
				$i486 $i586 $mmx;;
			*) printf "i486: %4u i586: %4u ppro: %4u mmx: %4u sse: %4u sse2: %4u\r" \
				$i486 $i586 $ppro $mmx $sse $sse2;;
		esac	
		unset print
	fi
	done 

# print a newline
echo

# cpuid instruction could mean the application checks to see
# if an instruction is supported before executing it. This might 
# mean it will work on anything over a pentium.
if test $cpuid -gt 0; then
	printf "\nThis binary was found to contain the cpuid instruction.\n"
	printf "It may be able to conditionally execute instructions if\n"
	printf "they are supported on the host (i586+).\n\n"
fi

# print minimum required processor, if there are collissions
# use the vendor to decide what to print.
if test $sse42 -gt 0; then 
	subarch="Pentium Nehalem (nehalem)"
elif test $sse41 -gt 0; then 
	subarch="Pentium x8000+ (penryn)"
elif test $ssse3 -gt 0; then 
	subarch="Pentium Core (core)"
elif test $sse3 -gt 0; then 
	subarch="Pentium IV (prescott)"
elif test $sse2 -gt 0; then 
	subarch="Pentium IV (pentium4)"
elif test $sse -gt 0; then 
	if test "$vendor" == "intel"; then
		subarch="Pentium III (pentium3)"
	elif test "$vendor" == "amd"; then
		subarch="AMD Athlon 4 (athlon-4)"
	else
		subarch="Pentium III (pentium3)"
	fi
elif test "$vendor" == "amd" -a $amd2 -gt 0; then
	subarch="AMD Athlon (athlon)"
elif test "$vendor" == "amd" -a $amd -gt 0; then
	subarch="AMD K6 III (k6-3)"
elif test $mmx -gt 0; then 
	if test "$vendor" == "intel"; then
		if test $ppro -gt 0; then
			subarch="Pentium II (pentium2)"
		else
			subarch="Intel Pentium MMX [P55C] (pentium-mmx)"
		fi
	elif test "$vendor" == "amd"; then
		subarch="AMD K6 (k6)"
	elif test "$vendor" == "cyrix"; then
		subarch="Cyrix 6x86MX / MII (pentium-mmx)"
	else
		subarch="Intel Pentium MMX [P55C] (pentium-mmx)"
	fi
elif test $ppro -gt 0; then
	subarch="Pentium Pro (i686 or pentiumpro)"
elif test $i586 -gt 0; then
	subarch="Pentium or compatible (i586) (i586 or pentium)"
elif test $i486 -gt 0; then
	subarch="80486 or comaptible (i486)"
else
	subarch="80386 or compatible (i386)"
fi

# print message and exit.
printf "%s will run on %s or higher processor.\n" "$1" "$subarch"; )
