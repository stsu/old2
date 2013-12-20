
# Makefile version 16.2
# Crafty v16.x makefile for Windows NT Intel
# Written by Jason Deines (jdeines@mindspring.com) April 1998
# Version modified by Gregor Overney (gregor_overney@hp.com) Nov 1998
# Version modified by Peter Karrer (pkarrer@active.ch) Dec 1998
#
# This makefile is designed to be used from the command line with 
# Microsoft's nmake.  Either rename this # file to "Makefile" or name it 
# explicitly when invoking nmake:
#     nmake -f Makefile.nt
#
# The makefile is set up for Microsoft Visual C++ 6.0 Intel.
#
# The default target produces a file called "wcrafty.exe".  This compiles
# all the .c files separately, producing individual .obj files, which are
# then linked to create the executable.  You can also specify a target
# called "wcraftyx".  This creates a file called "wcraftyx.exe" by combining
# all of the .c files into two large .c files before the compile step.
# The large files generally provides more optimization possibilities for
# the compiler, and usually results in slightly faster code.  To try it,
# type "nmake wcraftyx" instead of just "nmake".  The .c files x1.c and x2.c
# will be created if needed and built automatically.


# Build target is defined here.
TARGET   = NT_i386

# Command-line compiler and linker invocation commands:
CC       = cl
LD       = link

# Base compiler flags needed for build:
BFLAGS = /D_CONSOLE /DWIN64 /D_CRT_SECURE_NO_DEPRECATE /DNDEBUG /DUSE_POPCNT

# Compiler flags:
# /O2    optimize for speed
# /Oa    assume no aliasing (no good for VC 6)
# /Gr    fastcall calling convention
# /G5    target Pentium (but will run on all x86 architectures)
# /G6    target Pentium Pro (but will run on all x86 architectures)
# /Ob2   inline function calls if suitable
#
# For debugging use these flags instead:
# CFLAGS  = /Od /Zi
# LDFLAGS  = /DEBUG /DEBUGTYPE:CV
#

CFLAGS   = /Ox /Gr /Ob2 /W3 /GL /EHsc
#CFLAGS   =
#CFLAGS   = /Od

# Linker flags, normally not needed except for debug builds:
LDFLAGS  = /LTCG
#LDFLAGS  = /DEBUG /DEBUGTYPE:CV
 
# See the default crafty makefile for a description of the options below.
# With VC++, defines like COMPACT_ATTACKS, etc, makes the code slower, so 
# those # options are disabled by default.  FAST is normally not defined 
# so that hash statistics are reported -- for the fastest possible 
# executable, define FAST below.

#COPTS    = /DDEVELOP /MT /DSMP /DDEBUGSMP
COPTS    = /DDEVELOP /MT /DSMP /DCPUS=4

# For an SMP build use/add the following build options.
# NT_INTEREX is defined if you want to use the built-in InterlockedExchange()
# function for thread resource locking, instead of the inline asm routine.
# (This shouldn't be needed, at least on Intel.)
# /MT is a compiler flag needed for multithreaded builds.

#COPTS    = /MT /DSMP /DCPUS=4 /DNT_INTEREX

# If you are using any external assembler routines, put the name of the 
# object code file(s) here.  Any such files will need to be generated 
# separately -- there is no assembler step defined in the makefile.

asmobjs  =

# To enable assembly optimizations in x86.c and vcinline.h, use /DVC_INLINE_ASM.

#AOPTS    = /DVC_INLINE_ASM
AOPTS    = 

ALLOPTS  = $(COPTS) $(AOPTS) /D$(TARGET)

cobjs  = benchmark.obj bitbase.obj bitboard.obj book.obj endgame.obj evaluate.obj main.obj \
	material.obj misc.obj movegen.obj movepick.obj notation.obj pawns.obj position.obj \
	search.obj thread.obj timeman.obj tt.obj uci.obj ucioption.obj 
		  
xcobjs   = x3.obj

allobjs  = $(cobjs) 

xallobjs = $(xcobjs) $(asmobjs) egtb.obj

includes = bitboard.h bitcount.h book.h endgame.h evaluate.h material.h misc.h movegen.h movepick.h \
           notation.h pawns.h platform.h position.h psqtab.h rkiss.h search.h thread.h timeman.h tt.h types.h ucioption.h

Stockfish  : $(allobjs)
           $(LD) $(LDFLAGS) $(allobjs) /out:StockFish_dev.exe

g6 : $(xallobjs)
           $(LD) $(LDFLAGS) $(xallobjs) /out:g6.exe

$(cobjs) : $(includes)

.c.obj   :
	   $(CC) $(BFLAGS) $(CFLAGS) $(ALLOPTS) /c $*.c

.cpp.obj :
	   $(CC) $(BFLAGS) $(CFLAGS) $(ALLOPTS) /c $*.cpp

$(xcobjs): $(includes)


x3.c:     analyze.c edit.c main.c attacks.c boolean.c data.c draw.c drawn.c \
          enprise.c epd.c epdglue.c evaluate.c history.c init.c input.c \
          interupt.c iterate.c lookup.c make.c movgen.c next.c nextc.c nexte.c \
          option.c output.c phase.c ponder.c preeval.c quiesce.c repeat.c \
          resign.c root.c search.c store.c swap.c time.c \
          menu.c mmi.c unmake.c utility.c valid.c validate.c probe.c x86.c
		  copy /b analyze.c+edit.c+main.c+attacks.c+boolean.c+data.c+draw.c+drawn.c+\
          enprise.c+epd.c+epdglue.c+evaluate.c+history.c+init.c+input.c+\
          interupt.c+iterate.c+lookup.c+make.c+movgen.c+next.c+nextc.c+nexte.c+\
          option.c+output.c+phase.c+ponder.c+preeval.c+quiesce.c+repeat.c+\
          resign.c+root.c+search.c+setboard.c+store.c+swap.c+time.c+\
          menu.c+mmi.c+unmake.c+utility.c+valid.c+validate.c+probe.c+x86.c x3.c
		  

clean:
	   del /q $(cobjs)
	   del /q egtb.obj
	   del /q $(xcobjs)
	   del /q log.*
	   del /q game.**
	   del /q *.bak
	   del /q x1.c
	   del /q x2.c
