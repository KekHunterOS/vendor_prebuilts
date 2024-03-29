# This file is part of Autoconf.			-*- Autoconf -*-
# Programming languages support.
# Copyright (C) 2001-2017, 2020 Free Software Foundation, Inc.

# This file is part of Autoconf.  This program is free
# software; you can redistribute it and/or modify it under the
# terms of the GNU General Public License as published by the
# Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# Under Section 7 of GPL version 3, you are granted additional
# permissions described in the Autoconf Configure Script Exception,
# version 3.0, as published by the Free Software Foundation.
#
# You should have received a copy of the GNU General Public License
# and a copy of the Autoconf Configure Script Exception along with
# this program; see the files COPYINGv3 and COPYING.EXCEPTION
# respectively.  If not, see <https://www.gnu.org/licenses/>.

# Written by David MacKenzie, with help from
# Akim Demaille, Paul Eggert,
# Franc,ois Pinard, Karl Berry, Richard Pixley, Ian Lance Taylor,
# Roland McGrath, Noah Friedman, david d zuhn, and many others.


# Table of Contents:
#
# 1. Language selection
# 2. and routines to produce programs in a given language.
#      1a. C   2a. C
#      1b. C++
#      1c. Objective C
#      1d. Objective C++
#
# 3. Looking for a compiler
#    And possibly the associated preprocessor.
#      3a. C   3b. C++   3c. Objective C   3d. Objective C++
#
# 4. Compilers' characteristics.
#      4a. C



## ----------------------- ##
## 1a/2a. The C language.  ##
## ----------------------- ##


# ------------------------ #
# 1a. Language selection.  #
# ------------------------ #

# AC_LANG(C)
# ----------
# CFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
AC_LANG_DEFINE([C], [c], [C], [CC], [],
[ac_ext=c
ac_cpp='$CPP $CPPFLAGS'
ac_compile='$CC -c $CFLAGS $CPPFLAGS conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='$CC -o conftest$ac_exeext $CFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AS_MESSAGE_LOG_FD'
ac_compiler_gnu=$ac_cv_c_compiler_gnu
])


# AC_LANG_C
# ---------
AU_DEFUN([AC_LANG_C], [AC_LANG(C)])


# ------------------------ #
# 2a. Producing programs.  #
# ------------------------ #


# AC_LANG_CONFTEST(C)(BODY)
# -------------------------
# We can't use '#line $LINENO "configure"' here, since
# Sun c89 (Sun WorkShop 6 update 2 C 5.3 Patch 111679-08 2002/05/09)
# rejects $LINENO greater than 32767, and some configure scripts
# are longer than 32767 lines.
m4_define([AC_LANG_CONFTEST(C)],
[cat confdefs.h - <<_ACEOF >conftest.$ac_ext
/* end confdefs.h.  */
$1
_ACEOF])


# AC_LANG_PROGRAM(C)([PROLOGUE], [BODY])
# --------------------------------------
m4_define([AC_LANG_PROGRAM(C)],
[$1
m4_ifdef([_AC_LANG_PROGRAM_C_F77_HOOKS], [_AC_LANG_PROGRAM_C_F77_HOOKS])[]dnl
m4_ifdef([_AC_LANG_PROGRAM_C_FC_HOOKS], [_AC_LANG_PROGRAM_C_FC_HOOKS])[]dnl
int
main (void)
{
dnl Do *not* indent the following line: there may be CPP directives.
dnl Don't move the `;' right after for the same reason.
$2
  ;
  return 0;
}])


# _AC_LANG_IO_PROGRAM(C)
# ----------------------
# Produce source that performs I/O, necessary for proper
# cross-compiler detection.
m4_define([_AC_LANG_IO_PROGRAM(C)],
[AC_LANG_PROGRAM([@%:@include <stdio.h>],
[FILE *f = fopen ("conftest.out", "w");
 return ferror (f) || fclose (f) != 0;
])])


# AC_LANG_CALL(C)(PROLOGUE, FUNCTION)
# -----------------------------------
# Avoid conflicting decl of main.
m4_define([AC_LANG_CALL(C)],
[AC_LANG_PROGRAM([$1
m4_if([$2], [main], ,
[/* Override any GCC internal prototype to avoid an error.
   Use char because int might match the return type of a GCC
   builtin and then its argument prototype would still apply.  */
#ifdef __cplusplus
extern "C"
#endif
char $2 ();])], [return $2 ();])])


# AC_LANG_FUNC_LINK_TRY(C)(FUNCTION)
# ----------------------------------
# Don't include <ctype.h> because on OSF/1 3.0 it includes
# <sys/types.h> which includes <sys/select.h> which contains a
# prototype for select.  Similarly for bzero.
#
# This test used to merely assign f=$1 in main(), but that was
# optimized away by HP unbundled cc A.05.36 for ia64 under +O3,
# presumably on the basis that there's no need to do that store if the
# program is about to exit.  Conversely, the AIX linker optimizes an
# unused external declaration that initializes f=$1.  So this test
# program has both an external initialization of f, and a use of f in
# main that affects the exit status.
#
m4_define([AC_LANG_FUNC_LINK_TRY(C)],
[AC_LANG_PROGRAM(
[/* Define $1 to an innocuous variant, in case <limits.h> declares $1.
   For example, HP-UX 11i <limits.h> declares gettimeofday.  */
#define $1 innocuous_$1

/* System header to define __stub macros and hopefully few prototypes,
   which can conflict with char $1 (); below.  */

#include <limits.h>
#undef $1

/* Override any GCC internal prototype to avoid an error.
   Use char because int might match the return type of a GCC
   builtin and then its argument prototype would still apply.  */
#ifdef __cplusplus
extern "C"
#endif
char $1 ();
/* The GNU C library defines this for functions which it implements
    to always fail with ENOSYS.  Some functions are actually named
    something starting with __ and the normal name is an alias.  */
#if defined __stub_$1 || defined __stub___$1
choke me
#endif
], [return $1 ();])])


# AC_LANG_BOOL_COMPILE_TRY(C)(PROLOGUE, EXPRESSION)
# -------------------------------------------------
# Return a program that is valid if EXPRESSION is nonzero.
# EXPRESSION must be an integer constant expression.
# Be sure to use this array to avoid `unused' warnings, which are even
# errors with `-W error'.
m4_define([AC_LANG_BOOL_COMPILE_TRY(C)],
[AC_LANG_PROGRAM([$1], [static int test_array @<:@1 - 2 * !($2)@:>@;
test_array @<:@0@:>@ = 0;
return test_array @<:@0@:>@;
])])


# AC_LANG_INT_SAVE(C)(PROLOGUE, EXPRESSION)
# -----------------------------------------
# We need `stdio.h' to open a `FILE' and `stdlib.h' for `exit'.
# But we include them only after the EXPRESSION has been evaluated.
m4_define([AC_LANG_INT_SAVE(C)],
[AC_LANG_PROGRAM([$1
static long int longval (void) { return $2; }
static unsigned long int ulongval (void) { return $2; }
@%:@include <stdio.h>
@%:@include <stdlib.h>],
[
  FILE *f = fopen ("conftest.val", "w");
  if (! f)
    return 1;
  if (($2) < 0)
    {
      long int i = longval ();
      if (i != ($2))
	return 1;
      fprintf (f, "%ld", i);
    }
  else
    {
      unsigned long int i = ulongval ();
      if (i != ($2))
	return 1;
      fprintf (f, "%lu", i);
    }
  /* Do not output a trailing newline, as this causes \r\n confusion
     on some platforms.  */
  return ferror (f) || fclose (f) != 0;
])])



## ---------------------- ##
## 1b. The C++ language.  ##
## ---------------------- ##


# AC_LANG(C++)
# ------------
# CXXFLAGS is not in ac_cpp because -g, -O, etc. are not valid cpp options.
AC_LANG_DEFINE([C++], [cxx], [CXX], [CXX], [C],
[ac_ext=cpp
ac_cpp='$CXXCPP $CPPFLAGS'
ac_compile='$CXX -c $CXXFLAGS $CPPFLAGS conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='$CXX -o conftest$ac_exeext $CXXFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AS_MESSAGE_LOG_FD'
ac_compiler_gnu=$ac_cv_cxx_compiler_gnu
])


# AC_LANG_CPLUSPLUS
# -----------------
AU_DEFUN([AC_LANG_CPLUSPLUS], [AC_LANG(C++)])



## ------------------------------ ##
## 1c. The Objective C language.  ##
## ------------------------------ ##


# AC_LANG(Objective C)
# --------------------
AC_LANG_DEFINE([Objective C], [objc], [OBJC], [OBJC], [C],
[ac_ext=m
ac_cpp='$OBJCPP $CPPFLAGS'
ac_compile='$OBJC -c $OBJCFLAGS $CPPFLAGS conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='$OBJC -o conftest$ac_exeext $OBJCFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AS_MESSAGE_LOG_FD'
ac_compiler_gnu=$ac_cv_objc_compiler_gnu
])


# AC_LANG_OBJC
# ------------
AU_DEFUN([AC_LANG_OBJC], [AC_LANG(Objective C)])



## -------------------------------- ##
## 1d. The Objective C++ language.  ##
## -------------------------------- ##


# AC_LANG(Objective C++)
# ----------------------
AC_LANG_DEFINE([Objective C++], [objcxx], [OBJCXX], [OBJCXX], [C++],
[ac_ext=mm
ac_cpp='$OBJCXXCPP $CPPFLAGS'
ac_compile='$OBJCXX -c $OBJCXXFLAGS $CPPFLAGS conftest.$ac_ext >&AS_MESSAGE_LOG_FD'
ac_link='$OBJCXX -o conftest$ac_exeext $OBJCXXFLAGS $CPPFLAGS $LDFLAGS conftest.$ac_ext $LIBS >&AS_MESSAGE_LOG_FD'
ac_compiler_gnu=$ac_cv_objcxx_compiler_gnu
])



## -------------------------------------------- ##
## 3. Looking for Compilers and Preprocessors.  ##
## -------------------------------------------- ##

# -------------------- #
# 3a. The C compiler.  #
# -------------------- #


# _AC_ARG_VAR_CPPFLAGS
# --------------------
# Document and register CPPFLAGS, which is used by
# AC_PROG_{CC, CPP, CXX, CXXCPP, OBJC, OBJCPP, OBJCXX, OBJCXXCPP}.
AC_DEFUN([_AC_ARG_VAR_CPPFLAGS],
[AC_ARG_VAR([CPPFLAGS],
	    [(Objective) C/C++ preprocessor flags, e.g. -I<include dir>
	     if you have headers in a nonstandard directory <include dir>])])


# _AC_ARG_VAR_LDFLAGS
# -------------------
# Document and register LDFLAGS, which is used by
# AC_PROG_{CC, CXX, F77, FC, OBJC, OBJCXX}.
AC_DEFUN([_AC_ARG_VAR_LDFLAGS],
[AC_ARG_VAR([LDFLAGS],
	    [linker flags, e.g. -L<lib dir> if you have libraries in a
	     nonstandard directory <lib dir>])])


# _AC_ARG_VAR_LIBS
# ----------------
# Document and register LIBS, which is used by
# AC_PROG_{CC, CXX, F77, FC, OBJC, OBJCXX}.
AC_DEFUN([_AC_ARG_VAR_LIBS],
[AC_ARG_VAR([LIBS],
	    [libraries to pass to the linker, e.g. -l<library>])])


# AC_LANG_PREPROC(C)
# ------------------
# Find the C preprocessor.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_PREPROC(C)],
[AC_REQUIRE([AC_PROG_CPP])])


# _AC_PROG_PREPROC_WORKS_IFELSE(IF-WORKS, IF-NOT)
# -----------------------------------------------
# Check if $ac_cpp is a working preprocessor that can flag absent
# includes either by the exit status or by warnings.
# This macro is for all languages, not only C.
AC_DEFUN([_AC_PROG_PREPROC_WORKS_IFELSE],
[ac_preproc_ok=false
for ac_[]_AC_LANG_ABBREV[]_preproc_warn_flag in '' yes
do
  # Use a header file that comes with gcc, so configuring glibc
  # with a fresh cross-compiler works.
  # On the NeXT, cc -E runs the code through the compiler's parser,
  # not just through cpp. "Syntax error" is here to catch this case.
  _AC_PREPROC_IFELSE([AC_LANG_SOURCE([[@%:@include <limits.h>
		     Syntax error]])],
		     [],
		     [# Broken: fails on valid input.
continue])

  # OK, works on sane cases.  Now check whether nonexistent headers
  # can be detected and how.
  _AC_PREPROC_IFELSE([AC_LANG_SOURCE([[@%:@include <ac_nonexistent.h>]])],
		     [# Broken: success on invalid input.
continue],
		     [# Passes both tests.
ac_preproc_ok=:
break])

done
# Because of `break', _AC_PREPROC_IFELSE's cleaning code was skipped.
rm -f conftest.i conftest.err conftest.$ac_ext
AS_IF([$ac_preproc_ok], [$1], [$2])
])# _AC_PROG_PREPROC_WORKS_IFELSE


# AC_PROG_CPP
# -----------
# Find a working C preprocessor.
# We shouldn't have to require AC_PROG_CC, but this is due to the concurrency
# between the AC_LANG_COMPILER_REQUIRE family and that of AC_PROG_CC.
AN_MAKEVAR([CPP], [AC_PROG_CPP])
AN_PROGRAM([cpp], [AC_PROG_CPP])
AC_DEFUN([AC_PROG_CPP],
[AC_REQUIRE([AC_PROG_CC])dnl
AC_ARG_VAR([CPP],      [C preprocessor])dnl
_AC_ARG_VAR_CPPFLAGS()dnl
AC_LANG_PUSH(C)dnl
AC_MSG_CHECKING([how to run the C preprocessor])
# On Suns, sometimes $CPP names a directory.
if test -n "$CPP" && test -d "$CPP"; then
  CPP=
fi
if test -z "$CPP"; then
  AC_CACHE_VAL([ac_cv_prog_CPP],
  [dnl
    # Double quotes because $CC needs to be expanded
    for CPP in "$CC -E" "$CC -E -traditional-cpp" cpp /lib/cpp
    do
      _AC_PROG_PREPROC_WORKS_IFELSE([break])
    done
    ac_cv_prog_CPP=$CPP
  ])dnl
  CPP=$ac_cv_prog_CPP
else
  ac_cv_prog_CPP=$CPP
fi
AC_MSG_RESULT([$CPP])
_AC_PROG_PREPROC_WORKS_IFELSE([],
		[AC_MSG_FAILURE([C preprocessor "$CPP" fails sanity check])])
AC_SUBST(CPP)dnl
AC_LANG_POP(C)dnl
])# AC_PROG_CPP

# AC_PROG_CPP_WERROR
# ------------------
# Treat warnings from the preprocessor as errors.
AC_DEFUN([AC_PROG_CPP_WERROR],
[AC_REQUIRE([AC_PROG_CPP])dnl
ac_c_preproc_warn_flag=yes])# AC_PROG_CPP_WERROR

# AC_LANG_COMPILER(C)
# -------------------
# Find the C compiler.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_COMPILER(C)],
[AC_REQUIRE([AC_PROG_CC])])


# ac_cv_prog_gcc
# --------------
# We used to name the cache variable this way.
AU_DEFUN([ac_cv_prog_gcc],
[ac_cv_c_compiler_gnu])


# AC_PROG_CC([COMPILER ...])
# --------------------------
# COMPILER ... is a space separated list of C compilers to search for.
# This just gives the user an opportunity to specify an alternative
# search list for the C compiler.
AN_MAKEVAR([CC],  [AC_PROG_CC])
AN_PROGRAM([cc],  [AC_PROG_CC])
AN_PROGRAM([gcc], [AC_PROG_CC])
AC_DEFUN_ONCE([AC_PROG_CC],
[AC_LANG_PUSH(C)dnl
AC_ARG_VAR([CC],     [C compiler command])dnl
AC_ARG_VAR([CFLAGS], [C compiler flags])dnl
_AC_ARG_VAR_LDFLAGS()dnl
_AC_ARG_VAR_LIBS()dnl
_AC_ARG_VAR_CPPFLAGS()dnl
m4_ifval([$1],
      [AC_CHECK_TOOLS(CC, [$1])],
[AC_CHECK_TOOL(CC, gcc)
if test -z "$CC"; then
  dnl Here we want:
  dnl	AC_CHECK_TOOL(CC, cc)
  dnl but without the check for a tool without the prefix.
  dnl Until the check is removed from there, copy the code:
  if test -n "$ac_tool_prefix"; then
    AC_CHECK_PROG(CC, [${ac_tool_prefix}cc], [${ac_tool_prefix}cc])
  fi
fi
if test -z "$CC"; then
  AC_CHECK_PROG(CC, cc, cc, , , /usr/ucb/cc)
fi
if test -z "$CC"; then
  AC_CHECK_TOOLS(CC, cl.exe)
fi
if test -z "$CC"; then
  AC_CHECK_TOOL(CC, clang)
fi
])

test -z "$CC" && AC_MSG_FAILURE([no acceptable C compiler found in \$PATH])

# Provide some information about the compiler.
_AS_ECHO_LOG([checking for _AC_LANG compiler version])
set X $ac_compile
ac_compiler=$[2]
for ac_option in --version -v -V -qversion -version; do
  _AC_DO_LIMIT([$ac_compiler $ac_option >&AS_MESSAGE_LOG_FD])
done

m4_expand_once([_AC_COMPILER_EXEEXT])[]dnl
m4_expand_once([_AC_COMPILER_OBJEXT])[]dnl
_AC_LANG_COMPILER_GNU
if test $ac_compiler_gnu = yes; then
  GCC=yes
else
  GCC=
fi
_AC_PROG_CC_G
dnl
dnl Set ac_prog_cc_stdc to the supported C version.
dnl Also set the documented variable ac_cv_prog_cc_stdc;
dnl its name was chosen when it was cached, but it is no longer cached.
_AC_PROG_CC_C11([ac_prog_cc_stdc=c11
		 ac_cv_prog_cc_stdc=$ac_cv_prog_cc_c11],
  [_AC_PROG_CC_C99([ac_prog_cc_stdc=c99
		    ac_cv_prog_cc_stdc=$ac_cv_prog_cc_c99],
     [_AC_PROG_CC_C89([ac_prog_cc_stdc=c89
		       ac_cv_prog_cc_stdc=$ac_cv_prog_cc_c89],
		      [ac_prog_cc_stdc=no
		       ac_cv_prog_cc_stdc=no])])])
dnl
AC_LANG_POP(C)dnl
])# AC_PROG_CC


# _AC_PROG_CC_G
# -------------
# Check whether -g works, even if CFLAGS is set, in case the package
# plays around with CFLAGS (such as to build both debugging and normal
# versions of a library), tasteless as that idea is.
# Don't consider -g to work if it generates warnings when plain compiles don't.
m4_define([_AC_PROG_CC_G],
[ac_test_CFLAGS=${CFLAGS+y}
ac_save_CFLAGS=$CFLAGS
AC_CACHE_CHECK(whether $CC accepts -g, ac_cv_prog_cc_g,
  [ac_save_c_werror_flag=$ac_c_werror_flag
   ac_c_werror_flag=yes
   ac_cv_prog_cc_g=no
   CFLAGS="-g"
   _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
     [ac_cv_prog_cc_g=yes],
     [CFLAGS=""
      _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	[],
	[ac_c_werror_flag=$ac_save_c_werror_flag
	 CFLAGS="-g"
	 _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	   [ac_cv_prog_cc_g=yes])])])
   ac_c_werror_flag=$ac_save_c_werror_flag])
if test $ac_test_CFLAGS; then
  CFLAGS=$ac_save_CFLAGS
elif test $ac_cv_prog_cc_g = yes; then
  if test "$GCC" = yes; then
    CFLAGS="-g -O2"
  else
    CFLAGS="-g"
  fi
else
  if test "$GCC" = yes; then
    CFLAGS="-O2"
  else
    CFLAGS=
  fi
fi[]dnl
])# _AC_PROG_CC_G


# AC_PROG_GCC_TRADITIONAL
# -----------------------
AC_DEFUN([AC_PROG_GCC_TRADITIONAL],
[AC_REQUIRE([AC_PROG_CC])dnl
if test $ac_cv_c_compiler_gnu = yes; then
    AC_CACHE_CHECK(whether $CC needs -traditional,
      ac_cv_prog_gcc_traditional,
[  ac_pattern="Autoconf.*'x'"
  AC_EGREP_CPP($ac_pattern, [#include <sgtty.h>
Autoconf TIOCGETP],
  ac_cv_prog_gcc_traditional=yes, ac_cv_prog_gcc_traditional=no)

  if test $ac_cv_prog_gcc_traditional = no; then
    AC_EGREP_CPP($ac_pattern, [#include <termio.h>
Autoconf TCGETA],
    ac_cv_prog_gcc_traditional=yes)
  fi])
  if test $ac_cv_prog_gcc_traditional = yes; then
    CC="$CC -traditional"
  fi
fi
])# AC_PROG_GCC_TRADITIONAL


# AC_PROG_CC_C_O
# --------------
AC_DEFUN([AC_PROG_CC_C_O],
[AC_REQUIRE([AC_PROG_CC])dnl
if test "x$CC" != xcc; then
  AC_MSG_CHECKING([whether $CC and cc understand -c and -o together])
else
  AC_MSG_CHECKING([whether cc understands -c and -o together])
fi
set dummy $CC; ac_cc=`AS_ECHO(["$[2]"]) |
		      sed 's/[[^a-zA-Z0-9_]]/_/g;s/^[[0-9]]/_/'`
AC_CACHE_VAL(ac_cv_prog_cc_${ac_cc}_c_o,
[AC_LANG_CONFTEST([AC_LANG_PROGRAM([])])
# Make sure it works both with $CC and with simple cc.
# We do the test twice because some compilers refuse to overwrite an
# existing .o file with -o, though they will create one.
ac_try='$CC -c conftest.$ac_ext -o conftest2.$ac_objext >&AS_MESSAGE_LOG_FD'
rm -f conftest2.*
if _AC_DO_VAR(ac_try) &&
   test -f conftest2.$ac_objext && _AC_DO_VAR(ac_try);
then
  eval ac_cv_prog_cc_${ac_cc}_c_o=yes
  if test "x$CC" != xcc; then
    # Test first that cc exists at all.
    if _AC_DO_TOKENS(cc -c conftest.$ac_ext >&AS_MESSAGE_LOG_FD); then
      ac_try='cc -c conftest.$ac_ext -o conftest2.$ac_objext >&AS_MESSAGE_LOG_FD'
      rm -f conftest2.*
      if _AC_DO_VAR(ac_try) &&
	 test -f conftest2.$ac_objext && _AC_DO_VAR(ac_try);
      then
	# cc works too.
	:
      else
	# cc exists but doesn't like -o.
	eval ac_cv_prog_cc_${ac_cc}_c_o=no
      fi
    fi
  fi
else
  eval ac_cv_prog_cc_${ac_cc}_c_o=no
fi
rm -rf core conftest*
])dnl
if eval test \$ac_cv_prog_cc_${ac_cc}_c_o = yes; then
  AC_MSG_RESULT([yes])
else
  AC_MSG_RESULT([no])
  AC_DEFINE(NO_MINUS_C_MINUS_O, 1,
	   [Define to 1 if your C compiler doesn't accept -c and -o together.])
fi
])# AC_PROG_CC_C_O



# ---------------------- #
# 3b. The C++ compiler.  #
# ---------------------- #


# AC_LANG_PREPROC(C++)
# --------------------
# Find the C++ preprocessor.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_PREPROC(C++)],
[AC_REQUIRE([AC_PROG_CXXCPP])])


# AC_PROG_CXXCPP
# --------------
# Find a working C++ preprocessor.
# We shouldn't have to require AC_PROG_CC, but this is due to the concurrency
# between the AC_LANG_COMPILER_REQUIRE family and that of AC_PROG_CXX.
AC_DEFUN([AC_PROG_CXXCPP],
[AC_REQUIRE([AC_PROG_CXX])dnl
AC_ARG_VAR([CXXCPP],   [C++ preprocessor])dnl
_AC_ARG_VAR_CPPFLAGS()dnl
AC_LANG_PUSH(C++)dnl
AC_MSG_CHECKING([how to run the C++ preprocessor])
if test -z "$CXXCPP"; then
  AC_CACHE_VAL(ac_cv_prog_CXXCPP,
  [dnl
    # Double quotes because $CXX needs to be expanded
    for CXXCPP in "$CXX -E" cpp /lib/cpp
    do
      _AC_PROG_PREPROC_WORKS_IFELSE([break])
    done
    ac_cv_prog_CXXCPP=$CXXCPP
  ])dnl
  CXXCPP=$ac_cv_prog_CXXCPP
else
  ac_cv_prog_CXXCPP=$CXXCPP
fi
AC_MSG_RESULT([$CXXCPP])
_AC_PROG_PREPROC_WORKS_IFELSE([],
	  [AC_MSG_FAILURE([C++ preprocessor "$CXXCPP" fails sanity check])])
AC_SUBST(CXXCPP)dnl
AC_LANG_POP(C++)dnl
])# AC_PROG_CXXCPP


# AC_LANG_COMPILER(C++)
# ---------------------
# Find the C++ compiler.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_COMPILER(C++)],
[AC_REQUIRE([AC_PROG_CXX])])


# ac_cv_prog_gxx
# --------------
# We used to name the cache variable this way.
AU_DEFUN([ac_cv_prog_gxx],
[ac_cv_cxx_compiler_gnu])


# AC_PROG_CXX([LIST-OF-COMPILERS])
# --------------------------------
# LIST-OF-COMPILERS is a space separated list of C++ compilers to search
# for (if not specified, a default list is used).  This just gives the
# user an opportunity to specify an alternative search list for the C++
# compiler.
# aCC	HP-UX C++ compiler much better than `CC', so test before.
# FCC   Fujitsu C++ compiler
# KCC	KAI C++ compiler
# RCC	Rational C++
# xlC_r	IBM XL C++ for AIX (with support for reentrant code)
# xlC	IBM XL C++ for AIX
AN_MAKEVAR([CXX],  [AC_PROG_CXX])
AN_PROGRAM([CC],   [AC_PROG_CXX])
AN_PROGRAM([c++],  [AC_PROG_CXX])
AN_PROGRAM([g++],  [AC_PROG_CXX])
AC_DEFUN([AC_PROG_CXX],
[AC_LANG_PUSH(C++)dnl
AC_ARG_VAR([CXX],      [C++ compiler command])dnl
AC_ARG_VAR([CXXFLAGS], [C++ compiler flags])dnl
_AC_ARG_VAR_LDFLAGS()dnl
_AC_ARG_VAR_LIBS()dnl
_AC_ARG_VAR_CPPFLAGS()dnl
_AC_ARG_VAR_PRECIOUS([CCC])dnl
if test -z "$CXX"; then
  if test -n "$CCC"; then
    CXX=$CCC
  else
    AC_CHECK_TOOLS(CXX,
		   [m4_default([$1],
			       [g++ c++ gpp aCC CC cxx cc++ cl.exe FCC KCC RCC xlC_r xlC clang++])],
		   g++)
  fi
fi
# Provide some information about the compiler.
_AS_ECHO_LOG([checking for _AC_LANG compiler version])
set X $ac_compile
ac_compiler=$[2]
for ac_option in --version -v -V -qversion; do
  _AC_DO_LIMIT([$ac_compiler $ac_option >&AS_MESSAGE_LOG_FD])
done

m4_expand_once([_AC_COMPILER_EXEEXT])[]dnl
m4_expand_once([_AC_COMPILER_OBJEXT])[]dnl
_AC_LANG_COMPILER_GNU
if test $ac_compiler_gnu = yes; then
  GXX=yes
else
  GXX=
fi
_AC_PROG_CXX_G
_AC_PROG_CXX_CXX11([ac_prog_cxx_stdcxx=cxx11
		    ac_cv_prog_cxx_stdcxx=$ac_cv_prog_cxx_cxx11
		    ac_cv_prog_cxx_cxx98=$ac_cv_prog_cxx_cxx11],
   [_AC_PROG_CXX_CXX98([ac_prog_cxx_stdcxx=cxx98
		        ac_cv_prog_cxx_stdcxx=$ac_cv_prog_cxx_cxx98],
		       [ac_prog_cxx_stdcxx=no
		        ac_cv_prog_cxx_stdcxx=no])])
AC_LANG_POP(C++)dnl
])# AC_PROG_CXX


# _AC_PROG_CXX_G
# --------------
# Check whether -g works, even if CXXFLAGS is set, in case the package
# plays around with CXXFLAGS (such as to build both debugging and
# normal versions of a library), tasteless as that idea is.
# Don't consider -g to work if it generates warnings when plain compiles don't.
m4_define([_AC_PROG_CXX_G],
[ac_test_CXXFLAGS=${CXXFLAGS+y}
ac_save_CXXFLAGS=$CXXFLAGS
AC_CACHE_CHECK(whether $CXX accepts -g, ac_cv_prog_cxx_g,
  [ac_save_cxx_werror_flag=$ac_cxx_werror_flag
   ac_cxx_werror_flag=yes
   ac_cv_prog_cxx_g=no
   CXXFLAGS="-g"
   _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
     [ac_cv_prog_cxx_g=yes],
     [CXXFLAGS=""
      _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	[],
	[ac_cxx_werror_flag=$ac_save_cxx_werror_flag
	 CXXFLAGS="-g"
	 _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	   [ac_cv_prog_cxx_g=yes])])])
   ac_cxx_werror_flag=$ac_save_cxx_werror_flag])
if test $ac_test_CXXFLAGS; then
  CXXFLAGS=$ac_save_CXXFLAGS
elif test $ac_cv_prog_cxx_g = yes; then
  if test "$GXX" = yes; then
    CXXFLAGS="-g -O2"
  else
    CXXFLAGS="-g"
  fi
else
  if test "$GXX" = yes; then
    CXXFLAGS="-O2"
  else
    CXXFLAGS=
  fi
fi[]dnl
])# _AC_PROG_CXX_G


# AC_PROG_CXX_C_O
# ---------------
# Test if the C++ compiler accepts the options `-c' and `-o'
# simultaneously, and define `CXX_NO_MINUS_C_MINUS_O' if it does not.
AC_DEFUN([AC_PROG_CXX_C_O],
[AC_REQUIRE([AC_PROG_CXX])dnl
AC_LANG_PUSH([C++])dnl
AC_CACHE_CHECK([whether $CXX understands -c and -o together],
	       [ac_cv_prog_cxx_c_o],
[AC_LANG_CONFTEST([AC_LANG_PROGRAM([])])
# We test twice because some compilers refuse to overwrite an existing
# `.o' file with `-o', although they will create one.
ac_try='$CXX $CXXFLAGS -c conftest.$ac_ext -o conftest2.$ac_objext >&AS_MESSAGE_LOG_FD'
rm -f conftest2.*
if _AC_DO_VAR(ac_try) &&
     test -f conftest2.$ac_objext &&
     _AC_DO_VAR(ac_try); then
  ac_cv_prog_cxx_c_o=yes
else
  ac_cv_prog_cxx_c_o=no
fi
rm -rf conftest*])
if test $ac_cv_prog_cxx_c_o = no; then
  AC_DEFINE(CXX_NO_MINUS_C_MINUS_O, 1,
	    [Define to 1 if your C++ compiler doesn't accept
	     -c and -o together.])
fi
AC_LANG_POP([C++])dnl
])# AC_PROG_CXX_C_O



# ------------------------------ #
# 3c. The Objective C compiler.  #
# ------------------------------ #


# AC_LANG_PREPROC(Objective C)
# ----------------------------
# Find the Objective C preprocessor.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_PREPROC(Objective C)],
[AC_REQUIRE([AC_PROG_OBJCPP])])


# AC_PROG_OBJCPP
# --------------
# Find a working Objective C preprocessor.
AC_DEFUN([AC_PROG_OBJCPP],
[AC_REQUIRE([AC_PROG_OBJC])dnl
AC_ARG_VAR([OBJCPP],   [Objective C preprocessor])dnl
_AC_ARG_VAR_CPPFLAGS()dnl
AC_LANG_PUSH(Objective C)dnl
AC_MSG_CHECKING([how to run the Objective C preprocessor])
if test -z "$OBJCPP"; then
  AC_CACHE_VAL(ac_cv_prog_OBJCPP,
  [dnl
    # Double quotes because $OBJC needs to be expanded
    for OBJCPP in "$OBJC -E" cpp /lib/cpp
    do
      _AC_PROG_PREPROC_WORKS_IFELSE([break])
    done
    ac_cv_prog_OBJCPP=$OBJCPP
  ])dnl
  OBJCPP=$ac_cv_prog_OBJCPP
else
  ac_cv_prog_OBJCPP=$OBJCPP
fi
AC_MSG_RESULT([$OBJCPP])
_AC_PROG_PREPROC_WORKS_IFELSE([],
	  [AC_MSG_FAILURE([Objective C preprocessor "$OBJCPP" fails sanity check])])
AC_SUBST(OBJCPP)dnl
AC_LANG_POP(Objective C)dnl
])# AC_PROG_OBJCPP


# AC_LANG_COMPILER(Objective C)
# -----------------------------
# Find the Objective C compiler.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_COMPILER(Objective C)],
[AC_REQUIRE([AC_PROG_OBJC])])



# AC_PROG_OBJC([LIST-OF-COMPILERS])
# ---------------------------------
# LIST-OF-COMPILERS is a space separated list of Objective C compilers to
# search for (if not specified, a default list is used).  This just gives
# the user an opportunity to specify an alternative search list for the
# Objective C compiler.
# objcc StepStone Objective-C compiler (also "standard" name for OBJC)
# objc  David Stes' POC.  If you installed this, you likely want it.
# cc    Native C compiler (for instance, Apple).
# CC    You never know.
AN_MAKEVAR([OBJC],  [AC_PROG_OBJC])
AN_PROGRAM([objcc],  [AC_PROG_OBJC])
AN_PROGRAM([objc],  [AC_PROG_OBJC])
AC_DEFUN([AC_PROG_OBJC],
[AC_LANG_PUSH(Objective C)dnl
AC_ARG_VAR([OBJC],      [Objective C compiler command])dnl
AC_ARG_VAR([OBJCFLAGS], [Objective C compiler flags])dnl
_AC_ARG_VAR_LDFLAGS()dnl
_AC_ARG_VAR_LIBS()dnl
_AC_ARG_VAR_CPPFLAGS()dnl
_AC_ARG_VAR_PRECIOUS([OBJC])dnl
AC_CHECK_TOOLS(OBJC,
	       [m4_default([$1], [gcc objcc objc cc CC clang])],
	       gcc)
# Provide some information about the compiler.
_AS_ECHO_LOG([checking for _AC_LANG compiler version])
set X $ac_compile
ac_compiler=$[2]
for ac_option in --version -v -V -qversion; do
  _AC_DO_LIMIT([$ac_compiler $ac_option >&AS_MESSAGE_LOG_FD])
done

m4_expand_once([_AC_COMPILER_EXEEXT])[]dnl
m4_expand_once([_AC_COMPILER_OBJEXT])[]dnl
_AC_LANG_COMPILER_GNU
if test $ac_compiler_gnu = yes; then
  GOBJC=yes
else
  GOBJC=
fi
_AC_PROG_OBJC_G
AC_LANG_POP(Objective C)dnl
])# AC_PROG_OBJC


# _AC_PROG_OBJC_G
# ---------------
# Check whether -g works, even if OBJCFLAGS is set, in case the package
# plays around with OBJCFLAGS (such as to build both debugging and
# normal versions of a library), tasteless as that idea is.
# Don't consider -g to work if it generates warnings when plain compiles don't.
m4_define([_AC_PROG_OBJC_G],
[ac_test_OBJCFLAGS=${OBJCFLAGS+y}
ac_save_OBJCFLAGS=$OBJCFLAGS
AC_CACHE_CHECK(whether $OBJC accepts -g, ac_cv_prog_objc_g,
  [ac_save_objc_werror_flag=$ac_objc_werror_flag
   ac_objc_werror_flag=yes
   ac_cv_prog_objc_g=no
   OBJCFLAGS="-g"
   _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
     [ac_cv_prog_objc_g=yes],
     [OBJCFLAGS=""
      _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	[],
	[ac_objc_werror_flag=$ac_save_objc_werror_flag
	 OBJCFLAGS="-g"
	 _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	   [ac_cv_prog_objc_g=yes])])])
   ac_objc_werror_flag=$ac_save_objc_werror_flag])
if test $ac_test_OBJCFLAGS; then
  OBJCFLAGS=$ac_save_OBJCFLAGS
elif test $ac_cv_prog_objc_g = yes; then
  if test "$GOBJC" = yes; then
    OBJCFLAGS="-g -O2"
  else
    OBJCFLAGS="-g"
  fi
else
  if test "$GOBJC" = yes; then
    OBJCFLAGS="-O2"
  else
    OBJCFLAGS=
  fi
fi[]dnl
])# _AC_PROG_OBJC_G



# -------------------------------- #
# 3d. The Objective C++ compiler.  #
# -------------------------------- #


# AC_LANG_PREPROC(Objective C++)
# ------------------------------
# Find the Objective C++ preprocessor.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_PREPROC(Objective C++)],
[AC_REQUIRE([AC_PROG_OBJCXXCPP])])


# AC_PROG_OBJCXXCPP
# -----------------
# Find a working Objective C++ preprocessor.
AC_DEFUN([AC_PROG_OBJCXXCPP],
[AC_REQUIRE([AC_PROG_OBJCXX])dnl
AC_ARG_VAR([OBJCXXCPP],   [Objective C++ preprocessor])dnl
_AC_ARG_VAR_CPPFLAGS()dnl
AC_LANG_PUSH(Objective C++)dnl
AC_MSG_CHECKING([how to run the Objective C++ preprocessor])
if test -z "$OBJCXXCPP"; then
  AC_CACHE_VAL(ac_cv_prog_OBJCXXCPP,
  [dnl
    # Double quotes because $OBJCXX needs to be expanded
    for OBJCXXCPP in "$OBJCXX -E" cpp /lib/cpp
    do
      _AC_PROG_PREPROC_WORKS_IFELSE([break])
    done
    ac_cv_prog_OBJCXXCPP=$OBJCXXCPP
  ])dnl
  OBJCXXCPP=$ac_cv_prog_OBJCXXCPP
else
  ac_cv_prog_OBJCXXCPP=$OBJCXXCPP
fi
AC_MSG_RESULT([$OBJCXXCPP])
_AC_PROG_PREPROC_WORKS_IFELSE([],
	  [AC_MSG_FAILURE([Objective C++ preprocessor "$OBJCXXCPP" fails sanity check])])
AC_SUBST(OBJCXXCPP)dnl
AC_LANG_POP(Objective C++)dnl
])# AC_PROG_OBJCXXCPP


# AC_LANG_COMPILER(Objective C++)
# -------------------------------
# Find the Objective C++ compiler.  Must be AC_DEFUN'd to be AC_REQUIRE'able.
AC_DEFUN([AC_LANG_COMPILER(Objective C++)],
[AC_REQUIRE([AC_PROG_OBJCXX])])



# AC_PROG_OBJCXX([LIST-OF-COMPILERS])
# -----------------------------------
# LIST-OF-COMPILERS is a space separated list of Objective C++ compilers to
# search for (if not specified, a default list is used).  This just gives
# the user an opportunity to specify an alternative search list for the
# Objective C++ compiler.
# FIXME: this list is pure guesswork
# objc++ StepStone Objective-C++ compiler (also "standard" name for OBJCXX)
# objcxx David Stes' POC.  If you installed this, you likely want it.
# c++    Native C++ compiler (for instance, Apple).
# CXX    You never know.
AN_MAKEVAR([OBJCXX],  [AC_PROG_OBJCXX])
AN_PROGRAM([objcxx],  [AC_PROG_OBJCXX])
AC_DEFUN([AC_PROG_OBJCXX],
[AC_LANG_PUSH(Objective C++)dnl
AC_ARG_VAR([OBJCXX],      [Objective C++ compiler command])dnl
AC_ARG_VAR([OBJCXXFLAGS], [Objective C++ compiler flags])dnl
_AC_ARG_VAR_LDFLAGS()dnl
_AC_ARG_VAR_LIBS()dnl
_AC_ARG_VAR_CPPFLAGS()dnl
_AC_ARG_VAR_PRECIOUS([OBJCXX])dnl
AC_CHECK_TOOLS(OBJCXX,
	       [m4_default([$1], [g++ objc++ objcxx c++ CXX])],
	       g++)
# Provide some information about the compiler.
_AS_ECHO_LOG([checking for _AC_LANG compiler version])
set X $ac_compile
ac_compiler=$[2]
for ac_option in --version -v -V -qversion; do
  _AC_DO_LIMIT([$ac_compiler $ac_option >&AS_MESSAGE_LOG_FD])
done

m4_expand_once([_AC_COMPILER_EXEEXT])[]dnl
m4_expand_once([_AC_COMPILER_OBJEXT])[]dnl
_AC_LANG_COMPILER_GNU
if test $ac_compiler_gnu = yes; then
  GOBJCXX=yes
else
  GOBJCXX=
fi
_AC_PROG_OBJCXX_G
AC_LANG_POP(Objective C++)dnl
])# AC_PROG_OBJCXX


# _AC_PROG_OBJCXX_G
# -----------------
# Check whether -g works, even if OBJCFLAGS is set, in case the package
# plays around with OBJCFLAGS (such as to build both debugging and
# normal versions of a library), tasteless as that idea is.
# Don't consider -g to work if it generates warnings when plain compiles don't.
m4_define([_AC_PROG_OBJCXX_G],
[ac_test_OBJCXXFLAGS=${OBJCXXFLAGS+y}
ac_save_OBJCXXFLAGS=$OBJCXXFLAGS
AC_CACHE_CHECK(whether $OBJCXX accepts -g, ac_cv_prog_objcxx_g,
  [ac_save_objcxx_werror_flag=$ac_objcxx_werror_flag
   ac_objcxx_werror_flag=yes
   ac_cv_prog_objcxx_g=no
   OBJCXXFLAGS="-g"
   _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
     [ac_cv_prog_objcxx_g=yes],
     [OBJCXXFLAGS=""
      _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	[],
	[ac_objcxx_werror_flag=$ac_save_objcxx_werror_flag
	 OBJCXXFLAGS="-g"
	 _AC_COMPILE_IFELSE([AC_LANG_PROGRAM()],
	   [ac_cv_prog_objcxx_g=yes])])])
   ac_objcxx_werror_flag=$ac_save_objcx_werror_flag])
if test $ac_test_OBJCXXFLAGS; then
  OBJCXXFLAGS=$ac_save_OBJCXXFLAGS
elif test $ac_cv_prog_objcxx_g = yes; then
  if test "$GOBJCXX" = yes; then
    OBJCXXFLAGS="-g -O2"
  else
    OBJCXXFLAGS="-g"
  fi
else
  if test "$GOBJCXX" = yes; then
    OBJCXXFLAGS="-O2"
  else
    OBJCXXFLAGS=
  fi
fi[]dnl
])# _AC_PROG_OBJCXX_G



## ------------------------------- ##
## 4. Compilers' characteristics.  ##
## ------------------------------- ##

# -------------------------------- #
# 4a. C compiler characteristics.  #
# -------------------------------- #


# _AC_PROG_CC_C89 ([ACTION-IF-AVAILABLE], [ACTION-IF-UNAVAILABLE])
# ----------------------------------------------------------------
# If the C compiler is not in ANSI C89 (ISO C90) mode by default, try
# to add an option to output variable CC to make it so.  This macro
# tries various options that select ANSI C89 on some system or
# another.  It considers the compiler to be in ANSI C89 mode if it
# handles function prototypes correctly.
AC_DEFUN([_AC_PROG_CC_C89],
[_AC_C_STD_TRY([c89],
[[#include <stdarg.h>
#include <stdio.h>
struct stat;
/* Most of the following tests are stolen from RCS 5.7's src/conf.sh.  */
struct buf { int x; };
FILE * (*rcsopen) (struct buf *, struct stat *, int);
static char *e (p, i)
     char **p;
     int i;
{
  return p[i];
}
static char *f (char * (*g) (char **, int), char **p, ...)
{
  char *s;
  va_list v;
  va_start (v,p);
  s = g (p, va_arg (v,int));
  va_end (v);
  return s;
}

/* OSF 4.0 Compaq cc is some sort of almost-ANSI by default.  It has
   function prototypes and stuff, but not '\xHH' hex character constants.
   These don't provoke an error unfortunately, instead are silently treated
   as 'x'.  The following induces an error, until -std is added to get
   proper ANSI mode.  Curiously '\x00'!='x' always comes out true, for an
   array size at least.  It's necessary to write '\x00'==0 to get something
   that's true only with -std.  */
int osf4_cc_array ['\x00' == 0 ? 1 : -1];

/* IBM C 6 for AIX is almost-ANSI by default, but it replaces macro parameters
   inside strings and character constants.  */
#define FOO(x) 'x'
int xlc6_cc_array[FOO(a) == 'x' ? 1 : -1];

int test (int i, double x);
struct s1 {int (*f) (int a);};
struct s2 {int (*f) (double a);};
int pairnames (int, char **, FILE *(*)(struct buf *, struct stat *, int), int, int);
int argc;
char **argv;]],
[[return f (e, argv, 0) != argv[0]  ||  f (e, argv, 1) != argv[1];]],
dnl Don't try gcc -ansi; that turns off useful extensions and
dnl breaks some systems' header files.
dnl AIX circa 2003	-qlanglvl=extc89
dnl old AIX		-qlanglvl=ansi
dnl Ultrix, OSF/1, Tru64	-std
dnl HP-UX 10.20 and later	-Ae
dnl HP-UX older versions	-Aa -D_HPUX_SOURCE
dnl SVR4			-Xc -D__EXTENSIONS__
[-qlanglvl=extc89 -qlanglvl=ansi -std \
	-Ae "-Aa -D_HPUX_SOURCE" "-Xc -D__EXTENSIONS__"], [$1], [$2])[]dnl
])# _AC_PROG_CC_C89


# _AC_C_STD_TRY(STANDARD, TEST-PROLOGUE, TEST-BODY, OPTION-LIST,
#		ACTION-IF-AVAILABLE, ACTION-IF-UNAVAILABLE)
# --------------------------------------------------------------
# Check whether the C compiler accepts features of STANDARD (e.g `c89', `c99')
# by trying to compile a program of TEST-PROLOGUE and TEST-BODY.  If this fails,
# try again with each compiler option in the space-separated OPTION-LIST; if one
# helps, append it to CC.  If eventually successful, run ACTION-IF-AVAILABLE,
# else ACTION-IF-UNAVAILABLE.
AC_DEFUN([_AC_C_STD_TRY],
[AC_MSG_CHECKING([for $CC option to enable ]m4_translit($1, [c], [C])[ features])
AC_CACHE_VAL(ac_cv_prog_cc_$1,
[ac_cv_prog_cc_$1=no
ac_save_CC=$CC
AC_LANG_CONFTEST([AC_LANG_PROGRAM([$2], [$3])])
for ac_arg in '' $4
do
  CC="$ac_save_CC $ac_arg"
  _AC_COMPILE_IFELSE([], [ac_cv_prog_cc_$1=$ac_arg])
  test "x$ac_cv_prog_cc_$1" != "xno" && break
done
rm -f conftest.$ac_ext
CC=$ac_save_CC
])# AC_CACHE_VAL
ac_prog_cc_stdc_options=
case "x$ac_cv_prog_cc_$1" in
  x)
    AC_MSG_RESULT([none needed]) ;;
  xno)
    AC_MSG_RESULT([unsupported]) ;;
  *)
    ac_prog_cc_stdc_options=" $ac_cv_prog_cc_$1"
    CC=$CC$ac_prog_cc_stdc_options
    AC_MSG_RESULT([$ac_cv_prog_cc_$1]) ;;
esac
AS_IF([test "x$ac_cv_prog_cc_$1" != xno], [$5], [$6])
])# _AC_C_STD_TRY

# _AC_C_C99_TEST_HEADER
# ---------------------
# A C header suitable for testing for C99.
AC_DEFUN([_AC_C_C99_TEST_HEADER],
[[#include <stdarg.h>
#include <stdbool.h>
#include <stddef.h>
#include <stdlib.h>
#include <wchar.h>
#include <stdio.h>

// Check varargs macros.  These examples are taken from C99 6.10.3.5.
#define debug(...) fprintf (stderr, __VA_ARGS__)
#define showlist(...) puts (#__VA_ARGS__)
#define report(test,...) ((test) ? puts (#test) : printf (__VA_ARGS__))
static void
test_varargs_macros (void)
{
  int x = 1234;
  int y = 5678;
  debug ("Flag");
  debug ("X = %d\n", x);
  showlist (The first, second, and third items.);
  report (x>y, "x is %d but y is %d", x, y);
}

// Check long long types.
#define BIG64 18446744073709551615ull
#define BIG32 4294967295ul
#define BIG_OK (BIG64 / BIG32 == 4294967297ull && BIG64 % BIG32 == 0)
#if !BIG_OK
  your preprocessor is broken;
#endif
#if BIG_OK
#else
  your preprocessor is broken;
#endif
static long long int bignum = -9223372036854775807LL;
static unsigned long long int ubignum = BIG64;

struct incomplete_array
{
  int datasize;
  double data[];
};

struct named_init {
  int number;
  const wchar_t *name;
  double average;
};

typedef const char *ccp;

static inline int
test_restrict (ccp restrict text)
{
  // See if C++-style comments work.
  // Iterate through items via the restricted pointer.
  // Also check for declarations in for loops.
  for (unsigned int i = 0; *(text+i) != '\0'; ++i)
    continue;
  return 0;
}

// Check varargs and va_copy.
static bool
test_varargs (const char *format, ...)
{
  va_list args;
  va_start (args, format);
  va_list args_copy;
  va_copy (args_copy, args);

  const char *str = "";
  int number = 0;
  float fnumber = 0;

  while (*format)
    {
      switch (*format++)
	{
	case 's': // string
	  str = va_arg (args_copy, const char *);
	  break;
	case 'd': // int
	  number = va_arg (args_copy, int);
	  break;
	case 'f': // float
	  fnumber = va_arg (args_copy, double);
	  break;
	default:
	  break;
	}
    }
  va_end (args_copy);
  va_end (args);

  return *str && number && fnumber;
}]])# _AC_C_C99_TEST_HEADER

# _AC_C_C99_TEST_BODY
# -------------------
# A C body suitable for testing for C99, assuming the corresponding header.
AC_DEFUN([_AC_C_C99_TEST_BODY],
[[
  // Check bool.
  _Bool success = false;

  // Check restrict.
  if (test_restrict ("String literal") == 0)
    success = true;
  char *restrict newvar = "Another string";

  // Check varargs.
  success &= test_varargs ("s, d' f .", "string", 65, 34.234);
  test_varargs_macros ();

  // Check flexible array members.
  struct incomplete_array *ia =
    malloc (sizeof (struct incomplete_array) + (sizeof (double) * 10));
  ia->datasize = 10;
  for (int i = 0; i < ia->datasize; ++i)
    ia->data[i] = i * 1.234;

  // Check named initializers.
  struct named_init ni = {
    .number = 34,
    .name = L"Test wide string",
    .average = 543.34343,
  };

  ni.number = 58;

  int dynamic_array[ni.number];
  dynamic_array[ni.number - 1] = 543;

  // work around unused variable warnings
  return (!success || bignum == 0LL || ubignum == 0uLL || newvar[0] == 'x'
	  || dynamic_array[ni.number - 1] != 543);
]])

# _AC_PROG_CC_C99 ([ACTION-IF-AVAILABLE], [ACTION-IF-UNAVAILABLE])
# ----------------------------------------------------------------
# If the C compiler is not in ISO C99 mode by default, try to add an
# option to output variable CC to make it so.  This macro tries
# various options that select ISO C99 on some system or another.  It
# considers the compiler to be in ISO C99 mode if it handles _Bool,
# // comments, flexible array members, inline, long long int, mixed
# code and declarations, named initialization of structs, restrict,
# va_copy, varargs macros, variable declarations in for loops and
# variable length arrays.
AC_DEFUN([_AC_PROG_CC_C99],
[_AC_C_STD_TRY([c99],
[_AC_C_C99_TEST_HEADER],
[_AC_C_C99_TEST_BODY],
dnl Try
dnl GCC		-std=gnu99 (unused restrictive modes: -std=c99 -std=iso9899:1999)
dnl IBM XL C	-qlanglvl=extc1x (V12.1; does not pass C11 test)
dnl IBM XL C	-qlanglvl=extc99
dnl		(pre-V12.1; unused restrictive mode: -qlanglvl=stdc99)
dnl HP cc	-AC99
dnl Intel ICC	-std=c99, -c99 (deprecated)
dnl IRIX	-c99
dnl Solaris	-D_STDC_C99=
dnl		cc's -xc99 option uses linker magic to define the external
dnl		symbol __xpg4 as if by "int __xpg4 = 1;", which enables C99
dnl		behavior for C library functions.  This is not wanted here,
dnl		because it means that a single module compiled with -xc99
dnl		alters C runtime behavior for the entire program, not for
dnl		just the module.  Instead, define the (private) symbol
dnl		_STDC_C99, which suppresses a bogus failure in <stdbool.h>.
dnl		The resulting compiler passes the test case here, and that's
dnl		good enough.  For more, please see the thread starting at:
dnl           https://lists.gnu.org/archive/html/autoconf/2010-12/msg00059.html
dnl Tru64	-c99
dnl with extended modes being tried first.
[[-std=gnu99 -std=c99 -c99 -AC99 -D_STDC_C99= -qlanglvl=extc1x -qlanglvl=extc99]], [$1], [$2])[]dnl
])# _AC_PROG_CC_C99


# _AC_PROG_CC_C11 ([ACTION-IF-AVAILABLE], [ACTION-IF-UNAVAILABLE])
# ----------------------------------------------------------------
# If the C compiler is not in ISO C11 mode by default, try to add an
# option to output variable CC to make it so.  This macro tries
# various options that select ISO C11 on some system or another.  It
# considers the compiler to be in ISO C11 mode if it handles _Alignas,
# _Alignof, _Noreturn, _Static_assert, UTF-8 string literals,
# duplicate typedefs, and anonymous structures and unions.
AC_DEFUN([_AC_PROG_CC_C11],
[_AC_C_STD_TRY([c11],
[_AC_C_C99_TEST_HEADER[
// Check _Alignas.
char _Alignas (double) aligned_as_double;
char _Alignas (0) no_special_alignment;
extern char aligned_as_int;
char _Alignas (0) _Alignas (int) aligned_as_int;

// Check _Alignof.
enum
{
  int_alignment = _Alignof (int),
  int_array_alignment = _Alignof (int[100]),
  char_alignment = _Alignof (char)
};
_Static_assert (0 < -_Alignof (int), "_Alignof is signed");

// Check _Noreturn.
int _Noreturn does_not_return (void) { for (;;) continue; }

// Check _Static_assert.
struct test_static_assert
{
  int x;
  _Static_assert (sizeof (int) <= sizeof (long int),
                  "_Static_assert does not work in struct");
  long int y;
};

// Check UTF-8 literals.
#define u8 syntax error!
char const utf8_literal[] = u8"happens to be ASCII" "another string";

// Check duplicate typedefs.
typedef long *long_ptr;
typedef long int *long_ptr;
typedef long_ptr long_ptr;

// Anonymous structures and unions -- taken from C11 6.7.2.1 Example 1.
struct anonymous
{
  union {
    struct { int i; int j; };
    struct { int k; long int l; } w;
  };
  int m;
} v1;
]],
[_AC_C_C99_TEST_BODY[
  v1.i = 2;
  v1.w.k = 5;
  _Static_assert ((offsetof (struct anonymous, i)
		   == offsetof (struct anonymous, w.k)),
		  "Anonymous union alignment botch");
]],
dnl Try
dnl GCC		-std=gnu11 (unused restrictive mode: -std=c11)
dnl with extended modes being tried first.
dnl
dnl For IBM XL C for AIX V16.1 or later, '-std=gnu11' should work if
dnl the user configured with CC='xlclang'.  Otherwise, do not try
dnl -qlanglvl=extc1x as xlc with IBM XL C V16.1 (the latest version as
dnl of August 2020) does not pass the C11 test.  Instead, try extc1x when
dnl compiling the C99 test instead, since it enables _Static_assert and
dnl _Noreturn, which is a win.
[[-std=gnu11]], [$1], [$2])[]dnl
])# _AC_PROG_CC_C11


# AC_PROG_CC_C89
# --------------
# Do not use AU_ALIAS here and in AC_PROG_CC_C99 and AC_PROG_CC_STDC,
# as that'd be incompatible with how Automake redefines AC_PROG_CC.  See
# <https://lists.gnu.org/archive/html/autoconf/2012-10/msg00048.html>.
AU_DEFUN([AC_PROG_CC_C89],
  [AC_REQUIRE([AC_PROG_CC])],
  [$0 is obsolete; use AC_PROG_CC]
)

# AC_PROG_CC_C99
# --------------
AU_DEFUN([AC_PROG_CC_C99],
  [AC_REQUIRE([AC_PROG_CC])],
  [$0 is obsolete; use AC_PROG_CC]
)

# AC_PROG_CC_STDC
# ---------------
AU_DEFUN([AC_PROG_CC_STDC],
  [AC_REQUIRE([AC_PROG_CC])],
  [$0 is obsolete; use AC_PROG_CC]
)


# AC_C_BACKSLASH_A
# ----------------
AC_DEFUN([AC_C_BACKSLASH_A],
[
  AC_CACHE_CHECK([whether backslash-a works in strings], ac_cv_c_backslash_a,
   [AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],
     [[
#if '\a' == 'a'
      syntax error;
#endif
      char buf['\a' == 'a' ? -1 : 1];
      buf[0] = '\a';
      return buf[0] != "\a"[0];
     ]])],
     [ac_cv_c_backslash_a=yes],
     [ac_cv_c_backslash_a=no])])
  if test $ac_cv_c_backslash_a = yes; then
    AC_DEFINE(HAVE_C_BACKSLASH_A, 1,
      [Define if backslash-a works in C strings.])
  fi
])


# AC_C_CROSS
# ----------
# Has been merged into AC_PROG_CC.
AU_DEFUN([AC_C_CROSS], [])


# AC_C_CHAR_UNSIGNED
# ------------------
AC_DEFUN([AC_C_CHAR_UNSIGNED],
[AH_VERBATIM([__CHAR_UNSIGNED__],
[/* Define to 1 if type `char' is unsigned and you are not using gcc.  */
#ifndef __CHAR_UNSIGNED__
# undef __CHAR_UNSIGNED__
#endif])dnl
AC_CACHE_CHECK(whether char is unsigned, ac_cv_c_char_unsigned,
[AC_COMPILE_IFELSE([AC_LANG_BOOL_COMPILE_TRY([AC_INCLUDES_DEFAULT([])],
					     [((char) -1) < 0])],
		   ac_cv_c_char_unsigned=no, ac_cv_c_char_unsigned=yes)])
if test $ac_cv_c_char_unsigned = yes && test "$GCC" != yes; then
  AC_DEFINE(__CHAR_UNSIGNED__)
fi
])# AC_C_CHAR_UNSIGNED


# AC_C_BIGENDIAN ([ACTION-IF-TRUE], [ACTION-IF-FALSE], [ACTION-IF-UNKNOWN],
#                 [ACTION-IF-UNIVERSAL])
# -------------------------------------------------------------------------
AC_DEFUN([AC_C_BIGENDIAN],
[AH_VERBATIM([WORDS_BIGENDIAN],
[/* Define WORDS_BIGENDIAN to 1 if your processor stores words with the most
   significant byte first (like Motorola and SPARC, unlike Intel). */
#if defined AC_APPLE_UNIVERSAL_BUILD
# if defined __BIG_ENDIAN__
#  define WORDS_BIGENDIAN 1
# endif
#else
# ifndef WORDS_BIGENDIAN
#  undef WORDS_BIGENDIAN
# endif
#endif])dnl
 AC_CACHE_CHECK([whether byte ordering is bigendian], [ac_cv_c_bigendian],
   [ac_cv_c_bigendian=unknown
    # See if we're dealing with a universal compiler.
    AC_COMPILE_IFELSE(
	 [AC_LANG_SOURCE(
	    [[#ifndef __APPLE_CC__
	       not a universal capable compiler
	     #endif
	     typedef int dummy;
	    ]])],
	 [
	# Check for potential -arch flags.  It is not universal unless
	# there are at least two -arch flags with different values.
	ac_arch=
	ac_prev=
	for ac_word in $CC $CFLAGS $CPPFLAGS $LDFLAGS; do
	 if test -n "$ac_prev"; then
	   case $ac_word in
	     i?86 | x86_64 | ppc | ppc64)
	       if test -z "$ac_arch" || test "$ac_arch" = "$ac_word"; then
		 ac_arch=$ac_word
	       else
		 ac_cv_c_bigendian=universal
		 break
	       fi
	       ;;
	   esac
	   ac_prev=
	 elif test "x$ac_word" = "x-arch"; then
	   ac_prev=arch
	 fi
       done])
    if test $ac_cv_c_bigendian = unknown; then
      # See if sys/param.h defines the BYTE_ORDER macro.
      AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM(
	   [[#include <sys/types.h>
	     #include <sys/param.h>
	   ]],
	   [[#if ! (defined BYTE_ORDER && defined BIG_ENDIAN \
		     && defined LITTLE_ENDIAN && BYTE_ORDER && BIG_ENDIAN \
		     && LITTLE_ENDIAN)
	      bogus endian macros
	     #endif
	   ]])],
	[# It does; now see whether it defined to BIG_ENDIAN or not.
	 AC_COMPILE_IFELSE(
	   [AC_LANG_PROGRAM(
	      [[#include <sys/types.h>
		#include <sys/param.h>
	      ]],
	      [[#if BYTE_ORDER != BIG_ENDIAN
		 not big endian
		#endif
	      ]])],
	   [ac_cv_c_bigendian=yes],
	   [ac_cv_c_bigendian=no])])
    fi
    if test $ac_cv_c_bigendian = unknown; then
      # See if <limits.h> defines _LITTLE_ENDIAN or _BIG_ENDIAN (e.g., Solaris).
      AC_COMPILE_IFELSE(
	[AC_LANG_PROGRAM(
	   [[#include <limits.h>
	   ]],
	   [[#if ! (defined _LITTLE_ENDIAN || defined _BIG_ENDIAN)
	      bogus endian macros
	     #endif
	   ]])],
	[# It does; now see whether it defined to _BIG_ENDIAN or not.
	 AC_COMPILE_IFELSE(
	   [AC_LANG_PROGRAM(
	      [[#include <limits.h>
	      ]],
	      [[#ifndef _BIG_ENDIAN
		 not big endian
		#endif
	      ]])],
	   [ac_cv_c_bigendian=yes],
	   [ac_cv_c_bigendian=no])])
    fi
    if test $ac_cv_c_bigendian = unknown; then
      # Compile a test program.
      AC_RUN_IFELSE(
	[AC_LANG_PROGRAM([AC_INCLUDES_DEFAULT],
	   [[
	     /* Are we little or big endian?  From Harbison&Steele.  */
	     union
	     {
	       long int l;
	       char c[sizeof (long int)];
	     } u;
	     u.l = 1;
	     return u.c[sizeof (long int) - 1] == 1;
	   ]])],
	[ac_cv_c_bigendian=no],
	[ac_cv_c_bigendian=yes],
	[# Try to guess by grepping values from an object file.
	 AC_COMPILE_IFELSE(
	   [AC_LANG_PROGRAM(
	      [[unsigned short int ascii_mm[] =
		  { 0x4249, 0x4765, 0x6E44, 0x6961, 0x6E53, 0x7953, 0 };
		unsigned short int ascii_ii[] =
		  { 0x694C, 0x5454, 0x656C, 0x6E45, 0x6944, 0x6E61, 0 };
		int use_ascii (int i) {
		  return ascii_mm[i] + ascii_ii[i];
		}
		unsigned short int ebcdic_ii[] =
		  { 0x89D3, 0xE3E3, 0x8593, 0x95C5, 0x89C4, 0x9581, 0 };
		unsigned short int ebcdic_mm[] =
		  { 0xC2C9, 0xC785, 0x95C4, 0x8981, 0x95E2, 0xA8E2, 0 };
		int use_ebcdic (int i) {
		  return ebcdic_mm[i] + ebcdic_ii[i];
		}
		extern int foo;
	      ]],
	      [[return use_ascii (foo) == use_ebcdic (foo);]])],
	   [if grep BIGenDianSyS conftest.$ac_objext >/dev/null; then
	      ac_cv_c_bigendian=yes
	    fi
	    if grep LiTTleEnDian conftest.$ac_objext >/dev/null ; then
	      if test "$ac_cv_c_bigendian" = unknown; then
		ac_cv_c_bigendian=no
	      else
		# finding both strings is unlikely to happen, but who knows?
		ac_cv_c_bigendian=unknown
	      fi
	    fi])])
    fi])
 case $ac_cv_c_bigendian in #(
   yes)
     m4_default([$1],
       [AC_DEFINE([WORDS_BIGENDIAN], 1)]);; #(
   no)
     $2 ;; #(
   universal)
dnl Note that AC_APPLE_UNIVERSAL_BUILD sorts less than WORDS_BIGENDIAN;
dnl this is a necessity for proper config header operation.  Warn if
dnl the user did not specify a config header but is relying on the
dnl default behavior for universal builds.
     m4_default([$4],
       [AC_CONFIG_COMMANDS_PRE([m4_ifset([AH_HEADER], [],
	 [m4_warn([obsolete],
	   [AC_C_BIGENDIAN should be used with AC_CONFIG_HEADERS])])])dnl
	AC_DEFINE([AC_APPLE_UNIVERSAL_BUILD],1,
	  [Define if building universal (internal helper macro)])])
     ;; #(
   *)
     m4_default([$3],
       [AC_MSG_ERROR([unknown endianness
 presetting ac_cv_c_bigendian=no (or yes) will help])]) ;;
 esac
])# AC_C_BIGENDIAN


# AC_C__GENERIC
# -------------
# Define HAVE_C__GENERIC if _Generic works, a la C11.
AN_IDENTIFIER([_Generic], [AC_C__GENERIC])
AC_DEFUN([AC_C__GENERIC],
[AC_CACHE_CHECK([for _Generic], ac_cv_c__Generic,
[AC_COMPILE_IFELSE(
   [AC_LANG_SOURCE(
      [[int
	 main (int argc, char **argv)
	 {
	   int a = _Generic (argc, int: argc = 1);
	   int *b = &_Generic (argc, default: argc);
	   char ***c = _Generic (argv, int: argc, default: argv ? &argv : 0);
	   _Generic (1 ? 0 : b, int: a, default: b) = &argc;
	   _Generic (a = 1, default: a) = 3;
	   return a + !b + !c;
	 }
      ]])],
   [ac_cv_c__Generic=yes],
   [ac_cv_c__Generic=no])])
if test $ac_cv_c__Generic = yes; then
  AC_DEFINE([HAVE_C__GENERIC], 1,
	    [Define to 1 if C11-style _Generic works.])
fi
])# AC_C__GENERIC

# AC_C_INLINE
# -----------
# Do nothing if the compiler accepts the inline keyword.
# Otherwise define inline to __inline__ or __inline if one of those work,
# otherwise define inline to be empty.
#
# HP C version B.11.11.04 doesn't allow a typedef as the return value for an
# inline function, only builtin types.
#
AN_IDENTIFIER([inline], [AC_C_INLINE])
AC_DEFUN([AC_C_INLINE],
[AC_CACHE_CHECK([for inline], ac_cv_c_inline,
[ac_cv_c_inline=no
for ac_kw in inline __inline__ __inline; do
  AC_COMPILE_IFELSE([AC_LANG_SOURCE(
[#ifndef __cplusplus
typedef int foo_t;
static $ac_kw foo_t static_foo (void) {return 0; }
$ac_kw foo_t foo (void) {return 0; }
#endif
])],
		    [ac_cv_c_inline=$ac_kw])
  test "$ac_cv_c_inline" != no && break
done
])
AH_VERBATIM([inline],
[/* Define to `__inline__' or `__inline' if that's what the C compiler
   calls it, or to nothing if 'inline' is not supported under any name.  */
#ifndef __cplusplus
#undef inline
#endif])
case $ac_cv_c_inline in
  inline | yes) ;;
  *)
    case $ac_cv_c_inline in
      no) ac_val=;;
      *) ac_val=$ac_cv_c_inline;;
    esac
    cat >>confdefs.h <<_ACEOF
#ifndef __cplusplus
#define inline $ac_val
#endif
_ACEOF
    ;;
esac
])# AC_C_INLINE


# AC_C_CONST
# ----------
AC_DEFUN([AC_C_CONST],
[AC_CACHE_CHECK([for an ANSI C-conforming const], ac_cv_c_const,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],
[[
#ifndef __cplusplus
  /* Ultrix mips cc rejects this sort of thing.  */
  typedef int charset[2];
  const charset cs = { 0, 0 };
  /* SunOS 4.1.1 cc rejects this.  */
  char const *const *pcpcc;
  char **ppc;
  /* NEC SVR4.0.2 mips cc rejects this.  */
  struct point {int x, y;};
  static struct point const zero = {0,0};
  /* IBM XL C 1.02.0.0 rejects this.
     It does not let you subtract one const X* pointer from another in
     an arm of an if-expression whose if-part is not a constant
     expression */
  const char *g = "string";
  pcpcc = &g + (g ? g-g : 0);
  /* HPUX 7.0 cc rejects these. */
  ++pcpcc;
  ppc = (char**) pcpcc;
  pcpcc = (char const *const *) ppc;
  { /* SCO 3.2v4 cc rejects this sort of thing.  */
    char tx;
    char *t = &tx;
    char const *s = 0 ? (char *) 0 : (char const *) 0;

    *t++ = 0;
    if (s) return 0;
  }
  { /* Someone thinks the Sun supposedly-ANSI compiler will reject this.  */
    int x[] = {25, 17};
    const int *foo = &x[0];
    ++foo;
  }
  { /* Sun SC1.0 ANSI compiler rejects this -- but not the above. */
    typedef const int *iptr;
    iptr p = 0;
    ++p;
  }
  { /* IBM XL C 1.02.0.0 rejects this sort of thing, saying
       "k.c", line 2.27: 1506-025 (S) Operand must be a modifiable lvalue. */
    struct s { int j; const int *ap[3]; } bx;
    struct s *b = &bx; b->j = 5;
  }
  { /* ULTRIX-32 V3.1 (Rev 9) vcc rejects this */
    const int foo = 10;
    if (!foo) return 0;
  }
  return !cs[0] && !zero.x;
#endif
]])],
		   [ac_cv_c_const=yes],
		   [ac_cv_c_const=no])])
if test $ac_cv_c_const = no; then
  AC_DEFINE(const,,
	    [Define to empty if `const' does not conform to ANSI C.])
fi
])# AC_C_CONST


# AC_C_RESTRICT
# -------------
# based on acx_restrict.m4, from the GNU Autoconf Macro Archive
#
# Determine whether the C/C++ compiler supports the "restrict" keyword
# introduced in ANSI C99, or an equivalent.  Define "restrict" to the alternate
# spelling, if any; these are more likely to work in both C and C++ compilers of
# the same family, and in the presence of varying compiler options.  If only
# plain "restrict" works, do nothing.  Here are some variants:
# - GCC supports both __restrict and __restrict__
# - older DEC Alpha C compilers support only __restrict
# - _Restrict is the only spelling accepted by Sun WorkShop 6 update 2 C
# Otherwise, define "restrict" to be empty.
AN_IDENTIFIER([restrict], [AC_C_RESTRICT])
AC_DEFUN([AC_C_RESTRICT],
[AC_CACHE_CHECK([for C/C++ restrict keyword], [ac_cv_c_restrict],
  [ac_cv_c_restrict=no
   # Put '__restrict__' first, to avoid problems with glibc and non-GCC; see:
   # https://lists.gnu.org/archive/html/bug-autoconf/2016-02/msg00006.html
   # Put 'restrict' last, because C++ lacks it.
   for ac_kw in __restrict__ __restrict _Restrict restrict; do
     AC_COMPILE_IFELSE(
      [AC_LANG_PROGRAM(
	 [[typedef int *int_ptr;
	   int foo (int_ptr $ac_kw ip) { return ip[0]; }
	   int bar (int [$ac_kw]); /* Catch GCC bug 14050.  */
	   int bar (int ip[$ac_kw]) { return ip[0]; }
	 ]],
	 [[int s[1];
	   int *$ac_kw t = s;
	   t[0] = 0;
	   return foo (t) + bar (t);
	 ]])],
      [ac_cv_c_restrict=$ac_kw])
     test "$ac_cv_c_restrict" != no && break
   done
  ])
 AH_VERBATIM([restrict],
[/* Define to the equivalent of the C99 'restrict' keyword, or to
   nothing if this is not supported.  Do not define if restrict is
   supported only directly.  */
#undef restrict
/* Work around a bug in Sun C++ 5.13: it does not support _Restrict or
   __restrict__, even though the corresponding Sun C compiler ends up with
   "#define restrict _Restrict" or "#define restrict __restrict__".
   Perhaps some future version of Sun C++ will work with restrict;
   if so, hopefully it defines __RESTRICT like Sun C does.  */
#if defined __SUNPRO_CC && !defined __RESTRICT
# define _Restrict
# define __restrict__
#endif])
 case $ac_cv_c_restrict in
   restrict) ;;
   no) AC_DEFINE([restrict], []) ;;
   *)  AC_DEFINE_UNQUOTED([restrict], [$ac_cv_c_restrict]) ;;
 esac
])# AC_C_RESTRICT


# AC_C_VOLATILE
# -------------
# Note that, unlike const, #defining volatile to be the empty string can
# actually turn a correct program into an incorrect one, since removing
# uses of volatile actually grants the compiler permission to perform
# optimizations that could break the user's code.  So, do not #define
# volatile away unless it is really necessary to allow the user's code
# to compile cleanly.  Benign compiler failures should be tolerated.
AC_DEFUN([AC_C_VOLATILE],
[AC_CACHE_CHECK([for working volatile], ac_cv_c_volatile,
[AC_COMPILE_IFELSE([AC_LANG_PROGRAM([], [
volatile int x;
int * volatile y = (int *) 0;
return !x && !y;])],
		   [ac_cv_c_volatile=yes],
		   [ac_cv_c_volatile=no])])
if test $ac_cv_c_volatile = no; then
  AC_DEFINE(volatile,,
	    [Define to empty if the keyword `volatile' does not work.
	     Warning: valid code using `volatile' can become incorrect
	     without.  Disable with care.])
fi
])# AC_C_VOLATILE


# AC_C_STRINGIZE
# --------------
# Checks if `#' can be used to glue strings together at the CPP level.
# Defines HAVE_STRINGIZE if positive.
AC_DEFUN([AC_C_STRINGIZE],
[AC_CACHE_CHECK([for preprocessor stringizing operator],
		[ac_cv_c_stringize],
[AC_EGREP_CPP([@%:@teststring],
	      [@%:@define x(y) #y

char *s = x(teststring);],
	      [ac_cv_c_stringize=no],
	      [ac_cv_c_stringize=yes])])
if test $ac_cv_c_stringize = yes; then
  AC_DEFINE(HAVE_STRINGIZE, 1,
	    [Define to 1 if cpp supports the ANSI @%:@ stringizing operator.])
fi
])# AC_C_STRINGIZE


# AC_C_PROTOTYPES
# ---------------
# Check if the C compiler supports prototypes, included if it needs
# options.
AC_DEFUN([AC_C_PROTOTYPES],
[AC_REQUIRE([AC_PROG_CC])dnl
if test "$ac_prog_cc_stdc" != no; then
  AC_DEFINE(PROTOTYPES, 1,
	    [Define to 1 if the C compiler supports function prototypes.])
  AC_DEFINE(__PROTOTYPES, 1,
	    [Define like PROTOTYPES; this can be used by system headers.])
fi
])# AC_C_PROTOTYPES


# AC_C_FLEXIBLE_ARRAY_MEMBER
# --------------------------
# Check whether the C compiler supports flexible array members.
AC_DEFUN([AC_C_FLEXIBLE_ARRAY_MEMBER],
[
  AC_CACHE_CHECK([for flexible array members],
    ac_cv_c_flexmember,
    [AC_COMPILE_IFELSE(
       [AC_LANG_PROGRAM(
	  [[#include <stdlib.h>
	    #include <stdio.h>
	    #include <stddef.h>
	    struct s { int n; double d[]; };]],
	  [[int m = getchar ();
	    struct s *p = malloc (offsetof (struct s, d)
				  + m * sizeof (double));
	    p->d[0] = 0.0;
	    return p->d != (double *) NULL;]])],
       [ac_cv_c_flexmember=yes],
       [ac_cv_c_flexmember=no])])
  if test $ac_cv_c_flexmember = yes; then
    AC_DEFINE([FLEXIBLE_ARRAY_MEMBER], [],
      [Define to nothing if C supports flexible array members, and to
       1 if it does not.  That way, with a declaration like `struct s
       { int n; double d@<:@FLEXIBLE_ARRAY_MEMBER@:>@; };', the struct hack
       can be used with pre-C99 compilers.
       When computing the size of such an object, don't use 'sizeof (struct s)'
       as it overestimates the size.  Use 'offsetof (struct s, d)' instead.
       Don't use 'offsetof (struct s, d@<:@0@:>@)', as this doesn't work with
       MSVC and with C++ compilers.])
  else
    AC_DEFINE([FLEXIBLE_ARRAY_MEMBER], 1)
  fi
])


# AC_C_VARARRAYS
# --------------
# Check whether the C compiler supports variable-length arrays.
AC_DEFUN([AC_C_VARARRAYS],
[
  AC_CACHE_CHECK([for variable-length arrays],
    ac_cv_c_vararrays,
    [AC_EGREP_CPP([defined],
       [#ifdef __STDC_NO_VLA__
	defined
	#endif
       ],
       [ac_cv_c_vararrays='no: __STDC_NO_VLA__ is defined'],
       [AC_COMPILE_IFELSE(
	  [AC_LANG_PROGRAM(
	     [[/* Test for VLA support.  This test is partly inspired
		  from examples in the C standard.  Use at least two VLA
		  functions to detect the GCC 3.4.3 bug described in:
		  https://lists.gnu.org/archive/html/bug-gnulib/2014-08/msg00014.html
		  */
	       #ifdef __STDC_NO_VLA__
		syntax error;
	       #else
		 extern int n;
		 int B[100];
		 int fvla (int m, int C[m][m]);

		 int
		 simple (int count, int all[static count])
		 {
		   return all[count - 1];
		 }

		 int
		 fvla (int m, int C[m][m])
		 {
		   typedef int VLA[m][m];
		   VLA x;
		   int D[m];
		   static int (*q)[m] = &B;
		   int (*s)[n] = q;
		   return C && &x[0][0] == &D[0] && &D[0] == s[0];
		 }
	       #endif
	       ]])],
	  [ac_cv_c_vararrays=yes],
	  [ac_cv_c_vararrays=no])])])
  if test "$ac_cv_c_vararrays" = yes; then
    dnl This is for compatibility with Autoconf 2.61-2.69.
    AC_DEFINE([HAVE_C_VARARRAYS], 1,
      [Define to 1 if C supports variable-length arrays.])
  elif test "$ac_cv_c_vararrays" = no; then
    AC_DEFINE([__STDC_NO_VLA__], 1,
      [Define to 1 if C does not support variable-length arrays, and
       if the compiler does not already define this.])
  fi
])


# AC_C_TYPEOF
# -----------
# Check if the C compiler supports GCC's typeof syntax.
# The test case provokes incompatibilities in the Sun C compilers
# (both Solaris 8 and Solaris 10).
AC_DEFUN([AC_C_TYPEOF],
[
  AC_CACHE_CHECK([for typeof syntax and keyword spelling], ac_cv_c_typeof,
    [ac_cv_c_typeof=no
     for ac_kw in typeof __typeof__ no; do
       test $ac_kw = no && break
       AC_COMPILE_IFELSE([AC_LANG_PROGRAM([],
	 [[
	   int value;
	   typedef struct {
		   char a [1
			   + ! (($ac_kw (value))
				(($ac_kw (value)) 0 < ($ac_kw (value)) -1
				 ? ($ac_kw (value)) - 1
				 : ~ (~ ($ac_kw (value)) 0
				      << sizeof ($ac_kw (value)))))]; }
	      ac__typeof_type_;
	   return
	     (! ((void) ((ac__typeof_type_ *) 0), 0));
	 ]])],
	 [ac_cv_c_typeof=$ac_kw])
       test $ac_cv_c_typeof != no && break
     done])
  if test $ac_cv_c_typeof != no; then
    AC_DEFINE([HAVE_TYPEOF], 1,
      [Define to 1 if typeof works with your compiler.])
    if test $ac_cv_c_typeof != typeof; then
      AC_DEFINE_UNQUOTED([typeof], [$ac_cv_c_typeof],
	[Define to __typeof__ if your compiler spells it that way.])
    fi
  fi
])


# _AC_LANG_OPENMP
# ---------------
# Expands to some language dependent source code for testing the presence of
# OpenMP.
AC_DEFUN([_AC_LANG_OPENMP],
[AC_LANG_SOURCE([_AC_LANG_DISPATCH([$0], _AC_LANG, $@)])])

# _AC_LANG_OPENMP(C)
# ------------------
m4_define([_AC_LANG_OPENMP(C)],
[
#ifndef _OPENMP
 choke me
#endif
#include <omp.h>
int main (void) { return omp_get_num_threads (); }
])

# _AC_LANG_OPENMP(C++)
# --------------------
m4_copy([_AC_LANG_OPENMP(C)], [_AC_LANG_OPENMP(C++)])

# _AC_LANG_OPENMP(Fortran 77)
# ---------------------------
m4_define([_AC_LANG_OPENMP(Fortran 77)],
[
      program main
      implicit none
!$    integer tid
      tid = 42
      call omp_set_num_threads(2)
      end
])

# _AC_LANG_OPENMP(Fortran)
# ------------------------
m4_copy([_AC_LANG_OPENMP(Fortran 77)], [_AC_LANG_OPENMP(Fortran)])

# AC_OPENMP
# ---------
# Check which options need to be passed to the C compiler to support OpenMP.
# Set the OPENMP_CFLAGS / OPENMP_CXXFLAGS / OPENMP_FFLAGS variable to these
# options.
# The options are necessary at compile time (so the #pragmas are understood)
# and at link time (so the appropriate library is linked with).
# This macro takes care to not produce redundant options if $CC $CFLAGS already
# supports OpenMP. It also is careful to not pass options to compilers that
# misinterpret them; for example, most compilers accept "-openmp" and create
# an output file called 'penmp' rather than activating OpenMP support.
AC_DEFUN([AC_OPENMP],
[
  OPENMP_[]_AC_LANG_PREFIX[]FLAGS=
  AC_ARG_ENABLE([openmp],
    [AS_HELP_STRING([--disable-openmp], [do not use OpenMP])])
  if test "$enable_openmp" != no; then
    AC_CACHE_CHECK([for $[]_AC_CC[] option to support OpenMP],
      [ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp],
      [AC_LINK_IFELSE([_AC_LANG_OPENMP],
	 [ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp='none needed'],
	 [ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp='unsupported'
	  dnl Try these flags:
	  dnl   GCC >= 4.2           -fopenmp
	  dnl   SunPRO C             -xopenmp
	  dnl   Intel C              -openmp
	  dnl   SGI C, PGI C         -mp
	  dnl   Tru64 Compaq C       -omp
	  dnl   IBM XL C (AIX, Linux) -qsmp=omp
          dnl   Cray CCE             -homp
          dnl   NEC SX               -Popenmp
          dnl   Lahey Fortran (Linux)  --openmp
	  dnl If in this loop a compiler is passed an option that it doesn't
	  dnl understand or that it misinterprets, the AC_LINK_IFELSE test
	  dnl will fail (since we know that it failed without the option),
	  dnl therefore the loop will continue searching for an option, and
	  dnl no output file called 'penmp' or 'mp' is created.
	  for ac_option in -fopenmp -xopenmp -openmp -mp -omp -qsmp=omp -homp \
                           -Popenmp --openmp; do
	    ac_save_[]_AC_LANG_PREFIX[]FLAGS=$[]_AC_LANG_PREFIX[]FLAGS
	    _AC_LANG_PREFIX[]FLAGS="$[]_AC_LANG_PREFIX[]FLAGS $ac_option"
	    AC_LINK_IFELSE([_AC_LANG_OPENMP],
	      [ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp=$ac_option])
	    _AC_LANG_PREFIX[]FLAGS=$ac_save_[]_AC_LANG_PREFIX[]FLAGS
	    if test "$ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp" != unsupported; then
	      break
	    fi
	  done])])
    case $ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp in #(
      "none needed" | unsupported)
	;; #(
      *)
	OPENMP_[]_AC_LANG_PREFIX[]FLAGS=$ac_cv_prog_[]_AC_LANG_ABBREV[]_openmp ;;
    esac
  fi
  AC_SUBST([OPENMP_]_AC_LANG_PREFIX[FLAGS])
])

# _AC_CXX_STD_TRY(STANDARD, TEST-PROLOGUE, TEST-BODY, OPTION-LIST,
#		  ACTION-IF-AVAILABLE, ACTION-IF-UNAVAILABLE)
# ----------------------------------------------------------------
# Check whether the C++ compiler accepts features of STANDARD (e.g
# `cxx98', `cxx11') by trying to compile a program of TEST-PROLOGUE
# and TEST-BODY.  If this fails, try again with each compiler option
# in the space-separated OPTION-LIST; if one helps, append it to CXX.
# If eventually successful, run ACTION-IF-AVAILABLE, else
# ACTION-IF-UNAVAILABLE.
AC_DEFUN([_AC_CXX_STD_TRY],
[AC_MSG_CHECKING([for $CXX option to enable ]m4_translit(m4_translit($1, [x], [+]), [a-z], [A-Z])[ features])
AC_LANG_PUSH(C++)dnl
AC_CACHE_VAL(ac_cv_prog_cxx_$1,
[ac_cv_prog_cxx_$1=no
ac_save_CXX=$CXX
AC_LANG_CONFTEST([AC_LANG_PROGRAM([$2], [$3])])
for ac_arg in '' $4
do
  CXX="$ac_save_CXX $ac_arg"
  _AC_COMPILE_IFELSE([], [ac_cv_prog_cxx_$1=$ac_arg])
  test "x$ac_cv_prog_cxx_$1" != "xno" && break
done
rm -f conftest.$ac_ext
CXX=$ac_save_CXX
])# AC_CACHE_VAL
ac_prog_cxx_stdcxx_options=
case "x$ac_cv_prog_cxx_$1" in
  x)
    AC_MSG_RESULT([none needed]) ;;
  xno)
    AC_MSG_RESULT([unsupported]) ;;
  *)
    ac_prog_cxx_stdcxx_options=" $ac_cv_prog_cxx_$1"
    CXX=$CXX$ac_prog_cxx_stdcxx_options
    AC_MSG_RESULT([$ac_cv_prog_cxx_$1]) ;;
esac
AC_LANG_POP(C++)dnl
AS_IF([test "x$ac_cv_prog_cxx_$1" != xno], [$5], [$6])
])# _AC_CXX_STD_TRY

# _AC_CXX_CXX98_TEST_HEADER
# -------------------------
# A C++ header suitable for testing for CXX98.
# We only test *language* features that were new in the 1998 C++ standard,
# because testing for library features is too slow.
AC_DEFUN([_AC_CXX_CXX98_TEST_HEADER],
[[// Does the compiler advertise C++98 conformance?
#if !defined __cplusplus || __cplusplus < 199711L
# error "Compiler does not advertise C++98 conformance"
#endif

// These inclusions are cheap compared to including any STL header, but will
// reliably reject old compilers that lack the unsuffixed header files.
#undef NDEBUG
#include <cassert>
#include <cstring>
#include <iostream>

// Namespaces, exceptions, and templates were all added after "C++ 2.0".
using std::cout;
using std::strcmp;

namespace {

void test_exception_syntax()
{
  try {
    throw "test";
  } catch (const char *s) {
    // Extra parentheses suppress a warning when building autoconf itself,
    // due to lint rules shared with more typical C programs.
    assert (!(strcmp) (s, "test"));
  }
}

template <typename T> struct test_template
{
  T const val;
  explicit test_template(T t) : val(t) {}
  template <typename U> T add(U u) { return static_cast<T>(u) + val; }
};

} // anonymous namespace
]])# _AC_CXX_CXX98_TEST_HEADER

# _AC_CXX_CXX98_TEST_BODY
# -----------------------
# A C++ body suitable for testing for CXX98, assuming the corresponding header.
AC_DEFUN([_AC_CXX_CXX98_TEST_BODY],
[[
{
  test_exception_syntax ();
  test_template<double> tt (2.0);
  assert (tt.add (4) == 6.0);
  assert (true && !false);
  cout << "ok\n";
}
]])

# _AC_CXX_CXX11_TEST_HEADER
# -------------------------
# A C++ header suitable for testing for CXX11.
# As above, we test only new *language* features, not new STL features,
# for speed's sake.
AC_DEFUN([_AC_CXX_CXX11_TEST_HEADER],
[[
// Does the compiler advertise C++ 2011 conformance?
#if !defined __cplusplus || __cplusplus < 201103L
# error "Compiler does not advertise C++11 conformance"
#endif

namespace cxx11test
{
  constexpr int get_val() { return 20; }

  struct testinit
  {
    int i;
    double d;
  };

  class delegate
  {
  public:
    delegate(int n) : n(n) {}
    delegate(): delegate(2354) {}

    virtual int getval() { return this->n; };
  protected:
    int n;
  };

  class overridden : public delegate
  {
  public:
    overridden(int n): delegate(n) {}
    virtual int getval() override final { return this->n * 2; }
  };

  class nocopy
  {
  public:
    nocopy(int i): i(i) {}
    nocopy() = default;
    nocopy(const nocopy&) = delete;
    nocopy & operator=(const nocopy&) = delete;
  private:
    int i;
  };

  // for testing lambda expressions
  template <typename Ret, typename Fn> Ret eval(Fn f, Ret v)
  {
    return f(v);
  }

  // for testing variadic templates and trailing return types
  template <typename V> auto sum(V first) -> V
  {
    return first;
  }
  template <typename V, typename... Args> auto sum(V first, Args... rest) -> V
  {
    return first + sum(rest...);
  }
}
]])# _AC_CXX_CXX11_TEST_HEADER

# _AC_CXX_CXX11_TEST_BODY
# -----------------------
# A C++ body suitable for testing for CXX11, assuming the corresponding header.
AC_DEFUN([_AC_CXX_CXX11_TEST_BODY],
[[
{
  // Test auto and decltype
  auto a1 = 6538;
  auto a2 = 48573953.4;
  auto a3 = "String literal";

  int total = 0;
  for (auto i = a3; *i; ++i) { total += *i; }

  decltype(a2) a4 = 34895.034;
}
{
  // Test constexpr
  short sa[cxx11test::get_val()] = { 0 };
}
{
  // Test initializer lists
  cxx11test::testinit il = { 4323, 435234.23544 };
}
{
  // Test range-based for
  int array[] = {9, 7, 13, 15, 4, 18, 12, 10, 5, 3,
                 14, 19, 17, 8, 6, 20, 16, 2, 11, 1};
  for (auto &x : array) { x += 23; }
}
{
  // Test lambda expressions
  using cxx11test::eval;
  assert (eval ([](int x) { return x*2; }, 21) == 42);
  double d = 2.0;
  assert (eval ([&](double x) { return d += x; }, 3.0) == 5.0);
  assert (d == 5.0);
  assert (eval ([=](double x) mutable { return d += x; }, 4.0) == 9.0);
  assert (d == 5.0);
}
{
  // Test use of variadic templates
  using cxx11test::sum;
  auto a = sum(1);
  auto b = sum(1, 2);
  auto c = sum(1.0, 2.0, 3.0);
}
{
  // Test constructor delegation
  cxx11test::delegate d1;
  cxx11test::delegate d2();
  cxx11test::delegate d3(45);
}
{
  // Test override and final
  cxx11test::overridden o1(55464);
}
{
  // Test nullptr
  char *c = nullptr;
}
{
  // Test template brackets
  test_template<::test_template<int>> v(test_template<int>(12));
}
{
  // Unicode literals
  char const *utf8 = u8"UTF-8 string \u2500";
  char16_t const *utf16 = u"UTF-8 string \u2500";
  char32_t const *utf32 = U"UTF-32 string \u2500";
}
]])

# _AC_PROG_CXX_CXX98 ([ACTION-IF-AVAILABLE], [ACTION-IF-UNAVAILABLE])
# -------------------------------------------------------------------
# If the C++ compiler is not in ISO C++98 mode by default, try to add
# an option to output variable CXX to make it so.  This macro tries
# various options that select ISO C++98 on some system or another.
# It considers the compiler to be in ISO C++98 mode if it defines
# the __cplusplus macro appropriately and it supports language
# features that were added since "C++ 2.0" (namespaces, exceptions,
# and templates).  It does not check for the presence of any STL
# headers, as this was found to make AC_PROG_CXX unacceptably slow.
# Use AC_CHECK_HEADER if you need that.
AC_DEFUN([_AC_PROG_CXX_CXX98],
[_AC_CXX_STD_TRY([cxx98],
[_AC_CXX_CXX98_TEST_HEADER],
[_AC_CXX_CXX98_TEST_BODY],
dnl Try
dnl GCC		-std=gnu++98 (unused restrictive mode: -std=c++98)
dnl IBM XL C	-qlanglvl=extended
dnl HP aC++	-AA
dnl Intel ICC	-std=gnu++98
dnl Solaris	N/A (default)
dnl Tru64	N/A (default, but -std gnu could be used)
dnl with extended modes being tried first.
[[-std=gnu++98 -std=c++98 -qlanglvl=extended -AA]], [$1], [$2])[]dnl
])# _AC_PROG_CXX_CXX98

# _AC_PROG_CXX_CXX11 ([ACTION-IF-AVAILABLE], [ACTION-IF-UNAVAILABLE])
# -------------------------------------------------------------------
# If the C++ compiler is not in ISO CXX11 mode by default, try to add
# an option to output variable CXX to make it so.  This macro tries
# various options that select ISO C++11 on some system or another.
# It considers the compiler to be in ISO C++11 mode if it defines the
# __cplusplus macro appropriately, can compile all of the code from
# the C++98 test, and can also handle many of the new language
# features in C++11 (auto, constexpr, decltype, default/deleted
# constructors, delegate constructors, final, initializer lists,
# lambda functions, nullptr, override, range-based for loops, template
# brackets without spaces, variadic templates, trailing return types,
# unicode literals).  It does not check for the presence of the new
# library headers; again, this was found to make AC_PROG_CXX
# unacceptably slow.  Use AC_CHECK_HEADER if you need that.
AC_DEFUN([_AC_PROG_CXX_CXX11],
[_AC_CXX_STD_TRY([cxx11],
[_AC_CXX_CXX11_TEST_HEADER
_AC_CXX_CXX98_TEST_HEADER],
[_AC_CXX_CXX11_TEST_BODY
_AC_CXX_CXX98_TEST_BODY],
dnl Try
dnl GCC		-std=gnu++11 (unused restrictive mode: -std=c++11) [and 0x variants]
dnl IBM XL C	-qlanglvl=extended0x
dnl		(pre-V12.1; unused restrictive mode: -qlanglvl=stdcxx11)
dnl HP aC++	-AA
dnl Intel ICC	-std=c++11 -std=c++0x
dnl Solaris	N/A (no support)
dnl Tru64	N/A (no support)
dnl with extended modes being tried first.
[[-std=gnu++11 -std=c++11 -std=gnu++0x -std=c++0x -qlanglvl=extended0x -AA]], [$1], [$2])[]dnl
])# _AC_PROG_CXX_CXX11
