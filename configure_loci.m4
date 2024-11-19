dnl Loci is a C++ library.

AC_DEFUN([CONFIGURE_LOCI], [
AC_PREREQ([2.69])

AC_ARG_VAR([LOCI_LIBS],[Loci libraries])
AC_ARG_VAR([LOCI_LDFLAGS],[Loci link flags])
AC_ARG_VAR([LOCI_CXXFLAGS],[Loci C++ compilation flags])
AC_ARG_VAR([LOCI_CPPFLAGS],[Loci preprocessor flags])

AC_ARG_WITH(
[loci],
[
  AS_HELP_STRING(
    [--with-loci=[auto/yes/no/PATH]],
    [compile with Loci support. Default: auto]
  )
],
[],
[with_loci=auto]
)

AS_CASE($with_loci,
  [no], [
    _configure_loci_req=no
    _configure_loci_path=no
  ],
  [yes], [
    _configure_loci_req=yes
    _configure_loci_path=auto
  ],
  [auto], [
    _configure_loci_req=auto
    _configure_loci_path=auto
  ],
  [/*], [
    _configure_loci_req=yes
    AS_IF(
      [test -z "$with_loci"],
      [_configure_loci_path=auto],
      [_configure_loci_path=$with_loci]
    )
  ],
  [
    _configure_loci_req=no
    _configure_loci_path=no
  ]
)

_configure_loci_library_found=no
_configure_loci_header_found=no

AS_IF(
  [test "x$_configure_loci_req" = "xyes" || test "x$_configure_loci_req" = "xauto"],
  [
    AS_IF(
      [test "x$_configure_loci_path" = "xauto"],
      [
        AS_VAR_IF(
          [LOCI_BASE],
          [],
          [
            _configure_loci_full_path="notfound"
            AC_MSG_ERROR([Environment variable LOCI_BASE not set])
          ],
          [
            _configure_loci_full_path="$LOCI_BASE"
          ]
        )
      ],
      [_configure_loci_full_path="$_configure_loci_path"]
    )

    _configure_loci_conf_file="$_configure_loci_full_path/Loci.conf"
    AC_CHECK_FILE(
      [$_configure_loci_conf_file],
      [],
      [
        AC_MSG_ERROR([Loci installation not found at $_configure_loci_full_path])
        _configure_loci_full_path="notfound"
      ]
    )

    cat > Loci-discovery-Makefile <<EOF
include $_configure_loci_full_path/Loci.conf

print_COPT_FLAGS:
	@echo \$(C_OPT)

print_CXXOPT_FLAGS:
	@echo \$(COPT)

print_LOCI_INCLUDES:
	@echo \$(LOCI_INCLUDES)

print_INCLUDES:
	@echo \$(INCLUDES)

print_DEFINES:
	@echo \$(DEFINES)

print_LIBS:
	@echo \$(LIBS)

.PHONY: print_COPT_FLAGS print_CXXOPT_FLAGS print_LOCI_INCLUDES print_INCLUDES print_DEFINES print_LIBS
EOF

    _LOCI_COPT_FLAGS=$(eval make -f Loci-discovery-Makefile print_COPT_FLAGS)
    _LOCI_CXXOPT_FLAGS=$(eval make -f Loci-discovery-Makefile print_CXXOPT_FLAGS)
    _LOCI_INCLUDES=$(eval make -f Loci-discovery-Makefile print_INCLUDES)
    _LOCI_LOCI_INCLUDES=$(eval make -f Loci-discovery-Makefile print_LOCI_INCLUDES)
    _LOCI_DEFINES=$(eval make -f Loci-discovery-Makefile print_DEFINES)
    _LOCI_LIBS=$(eval make -f Loci-discovery-Makefile print_LIBS)
    
    AC_MSG_NOTICE([_LOCI_COPT_FLAGS=$_LOCI_COPT_FLAGS])
    AC_MSG_NOTICE([_LOCI_CXXOPT_FLAGS=$_LOCI_CXXOPT_FLAGS])
    AC_MSG_NOTICE([_LOCI_INCLUDES=$_LOCI_INCLUDES])
    AC_MSG_NOTICE([_LOCI_LOCI_INCLUDES=$_LOCI_LOCI_INCLUDES])
    AC_MSG_NOTICE([_LOCI_DEFINES=$_LOCI_DEFINES])
    AC_MSG_NOTICE([_LOCI_LIBS=$_LOCI_LIBS])
    
    LOCI_LDFLAGS="$_LOCI_CXXOPT_FLAGS"
    LOCI_LIBS="$_LOCI_LIBS"
    LOCI_CXXFLAGS="$_LOCI_INCLUDES $_LOCI_LOCI_INCLUDES $_LOCI_CXXOPT_FLAGS"
    LOCI_CPPFLAGS="$_LOCI_DEFINES"
    
    AC_MSG_NOTICE([LOCI_LDFLAGS=$LOCI_LDFLAGS])
    AC_MSG_NOTICE([LOCI_LIBS=$LOCI_LIBS])
    AC_MSG_NOTICE([LOCI_CXXFLAGS=$LOCI_CXXFLAGS])
    AC_MSG_NOTICE([LOCI_CPPFLAGS=$LOCI_CPPFLAGS])
    
    AC_LANG_PUSH([C++])
    
    save_CC="$CC"
    save_CXX="$CXX"
    save_LIBS="$LIBS"
    save_LDFLAGS="$LDFLAGS"
    save_CFLAGS="$CFLAGS"
    save_CXXFLAGS="$CXXFLAGS"
    save_CPPFLAGS="$CPPFLAGS"
    
    CC="mpicc"
    CXX="mpicxx"
    LIBS="$LOCI_LIBS $save_LIBS"
    LDFLAGS="$LOCI_LDFLAGS $save_LDFLAGS"
    CFLAGS="$LOCI_CXXFLAGS $LOCI_DEFINES $CFLAGS"
    CXXFLAGS="$LOCI_CXXFLAGS $LOCI_DEFINES $CXXFLAGS"
    CPPFLAGS="$LOCI_CPPFLAGS $CPPFLAGS"
    
    AC_MSG_CHECKING([for Loci library usability])
    AC_LINK_IFELSE(
      [AC_LANG_PROGRAM([#include <Loci.h>],[Loci::Init(0, 0);])],
      [
        AC_MSG_RESULT([yes])
        _configure_loci_library_found="yes"
      ],
      [
        AC_MSG_RESULT([no])
        _configure_loci_library_found="no"
      ]
    )
    
    AC_CHECK_HEADER(
      [Loci.h],
      [_configure_loci_header_found="yes"],
      [_configure_loci_header_found="no"],
      [AC_INCLUDES_DEFAULT]
    )
    
    CC="$save_CC"
    CXX="$save_CXX"
    LIBS="$save_LIBS"
    LDFLAGS="$save_LDFLAGS"
    CFLAGS="$save_CFLAGS"
    CXXFLAGS="$save_CXXFLAGS"
    CPPFLAGS="$save_CPPFLAGS"
    
    AC_LANG_POP([C++])
  ]
)

dnl for automake use
AM_CONDITIONAL([HAVE_LOCI],[test "x$_configure_loci_library_found" = "xyes" && test "x$_configure_loci_header_found" = "xyes"])

AS_IF(
  [test "x$_configure_loci_library_found" = "xyes" && test "x$_configure_loci_header_found" = "xyes"],
  [
    dnl for configure use
    use_loci="yes"
    
    dnl for C preprocessor
    AC_DEFINE([HAVE_LOCI], [1], [Defined if Loci library is detected.])
    
    dnl set LPP variable for use in Makefiles
    AC_SUBST([LPP], [$_configure_loci_full_path/bin/lpp])
  ],
  [
    dnl for configure use
    use_loci="no"
    
    dnl reset
    LOCI_LIBS=""
    LOCI_LDFLAGS=""
    LOCI_CXXFLAGS=""
    LOCI_CPPFLAGS=""
  ]
)

AS_IF(
  [test "x$_configure_loci_req" = "xyes"],
  [AS_IF([test "x$use_loci" = "xyes"],[],[AC_MSG_FAILURE([Loci requested, but not found])])],
  [test "x$_configure_loci_req" = "xauto"],
  [AS_IF([test "x$use_loci" = "xyes"],[],[AC_MSG_WARN([Loci not found, will not use Loci])])],
  [test "x$_configure_loci_req" = "xno"],
  [AC_MSG_NOTICE([Loci not requested])]
)

])
