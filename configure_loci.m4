AC_DEFUN([CONFIGURE_LOCI], [
AC_PREREQ([2.50])

AC_ARG_VAR([LOCI_INCLUDES],[Loci includes])
AC_ARG_VAR([LOCI_LIBS],[Loci libraries])
AC_ARG_VAR([LOCI_LDFLAGS],[Loci link flags])
AC_ARG_VAR([LOCI_CXXFLAGS],[Loci C++ compilation flags])
AC_ARG_VAR([LOCI_CPPFLAGS],[Loci preprocessor flags])

AC_ARG_WITH(
[loci],
[
  AS_HELP_STRING(
    [--with-loci=auto/yes/no/PATH],
    [compile with Loci support. Default: auto]
  )
],
[],
[with_loci=auto]
)

AS_CASE([$with_loci],
  [no],
  [
    _configure_loci_req=no
    _configure_loci_path=no
  ],
  [yes],
  [
    _configure_loci_req=yes
    _configure_loci_path=auto
  ],
  [auto],
  [
    _configure_loci_req=auto
    _configure_loci_path=auto
  ],
  [/*],
  [
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

_loci_found=no
_loci_usable=no
_loci_includes_found=no
_loci_cxxflags_found=no
_loci_cflags_found=no
_loci_cppflags_found=no
_loci_ldflags_found=no
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
          [_configure_loci_full_path="notfound"],
          [_configure_loci_full_path="$LOCI_BASE"]
        )
      ],
      [
        _configure_loci_full_path="$_configure_loci_path"
      ]
    )

    AS_IF(
      [test "x$_configure_loci_full_path" = "xnotfound"],
      [
        AS_IF(
          [test "x$_configure_loci_req" = "xyes"],
          [AC_MSG_ERROR([Loci installation not found])],
          [AC_MSG_WARN([Loci installation not found])]
        )
      ],
      [
        _configure_loci_path="$_configure_loci_full_path"
	cat > LociDiscoveryMakefile <<EOF
include $_configure_loci_path/Loci.conf

print:
	@echo "Valid targets 'print_includes' 'print_cflags' 'print_cxxflags' 'print_cppflags' 'print_ldflags'"

print_includes:
	@echo "\$(LOCI_INCLUDES) \$(INCLUDES)"

print_cflags:
	@echo "\$(C_OPT) \$(LOCI_INCLUDES) \$(INCLUDES)"

print_cppflags:
	@echo "\$(DEFINES)"

print_cxxflags:
	@echo "\$(COPT) \$(EXCEPTIONS) \$(LOCI_INCLUDES) \$(INCLUDES)"

print_ldflags:
	@echo "\$(LIBS)"

.PHONY: print print_includes print_cflags print_cppflags print_cxxflags print_ldflags
EOF

        AC_MSG_CHECKING([for Loci INCLUDES, path: $_configure_loci_path])
        AS_IF(
          [make -f LociDiscoveryMakefile print_includes > LociINCLUDES.out 2> LociINCLUDES.err],
          [
            AC_MSG_RESULT([found])
            LOCI_INCLUDES=`cat LociINCLUDES.out`
            AC_MSG_NOTICE([Loci INCLUDES=$LOCI_INCLUDES])
            _loci_includes_found=yes
          ],
          [
            AC_MSG_RESULT([not found])
          ]
        )
	
        AC_MSG_CHECKING([for Loci CXXFLAGS, path: $_configure_loci_path])
        AS_IF(
          [make -f LociDiscoveryMakefile print_cxxflags > LociCXXFLAGS.out 2> LociCXXFLAGS.err],
          [
            AC_MSG_RESULT([found])
            LOCI_CXXFLAGS=`cat LociCXXFLAGS.out`
            AC_MSG_NOTICE([Loci CXXFLAGS=$LOCI_CXXFLAGS])
            _loci_cxxflags_found=yes
          ],
          [
            AC_MSG_RESULT([not found])
          ]
        )
	
        AC_MSG_CHECKING([for Loci CFLAGS, path: $_configure_loci_path])
        AS_IF(
          [make -f LociDiscoveryMakefile print_cflags > LociCFLAGS.out 2> LociCFLAGS.err],
          [
            AC_MSG_RESULT([found])
            LOCI_CFLAGS=`cat LociCFLAGS.out`
            AC_MSG_NOTICE([Loci CFLAGS=$LOCI_CFLAGS])
            _loci_cflags_found=yes
          ],
          [
            AC_MSG_RESULT([not found])
          ]
        )
	
        AC_MSG_CHECKING([for Loci CPPFLAGS, path: $_configure_loci_path])
        AS_IF(
          [make -f LociDiscoveryMakefile print_cppflags > LociCPPFLAGS.out 2> LociCPPFLAGS.err],
          [
            AC_MSG_RESULT([found])
            LOCI_CPPFLAGS=`cat LociCPPFLAGS.out`
            AC_MSG_NOTICE([Loci CPPFLAGS=$LOCI_CPPFLAGS])
            _loci_cppflags_found=yes
          ],
          [
            AC_MSG_RESULT([not found])
          ]
        )
	
        AC_MSG_CHECKING([for Loci LDFLAGS, path: $_configure_loci_path])
        AS_IF(
          [make -f LociDiscoveryMakefile print_ldflags > LociLDFLAGS.out 2> LociLDFLAGS.err],
          [
            AC_MSG_RESULT([found])
            LOCI_LDFLAGS=`cat LociLDFLAGS.out`
            AC_MSG_NOTICE([Loci LDFLAGS=$LOCI_LDFLAGS])
            _loci_ldflags_found=yes
          ],
          [
            AC_MSG_RESULT([not found])
          ]
        )

        AS_IF(
          [test "x$_loci_includes_found" = "xyes" && test "x$_loci_cxxflags_found" = "xyes" && test "x$_loci_cflags_found" = "xyes" && test "x$_loci_cppflags_found" = "xyes" && test "x$_loci_ldflags_found" = "xyes"],
          [_loci_found=yes]
        )
      ]
    )
  ]
)

AS_IF(
  [test "x$_loci_found" = "xyes"],
  [
    AC_LANG_PUSH([C++])

    save_LDFLAGS="$LDFLAGS"
    save_CFLAGS="$CFLAGS"
    save_CXXFLAGS="$CXXFLAGS"
    save_CPPFLAGS="$CPPFLAGS"

    LDFLAGS="$LDFLAGS $LOCI_LDFLAGS"
    CFLAGS="$CFLAGS $LOCI_CFLAGS"
    CXXFLAGS="$CXXFLAGS $LOCI_CXXFLAGS"
    CPPFLAGS="$CPPFLAGS $LOCI_CPPFLAGS"
    
    AC_MSG_CHECKING([for Loci usability])
    AC_LINK_IFELSE(
      [AC_LANG_PROGRAM([#include <Loci.h>],[Loci::Init(0, 0);])],
      [
        AC_MSG_RESULT([yes])
        _loci_usable=yes
      ],
      [
        AC_MSG_RESULT([no])
      ]
    )

    LDFLAGS="$save_LDFLAGS"
    CFLAGS="$save_CFLAGS"
    CXXFLAGS="$save_CXXFLAGS"
    CPPFLAGS="$save_CPPFLAGS"

    AC_LANG_POP([C++])

    AC_SUBST([LPP], [$_configure_loci_path/bin/lpp])
  ]
)

AM_CONDITIONAL([HAVE_LOCI],[test "x$_loci_usable" = "xyes"])

])
