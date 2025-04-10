dnl METIS is a C library. Hence only C support is tested.

AC_DEFUN([CONFIGURE_METIS], [
AC_PREREQ([2.69])

AC_ARG_VAR([METIS_DIR],[Prefix of metis installation.])
AC_ARG_VAR([METIS_CPPFLAGS],[C/C++ preprocessor flags for metis.])
AC_ARG_VAR([METIS_CFLAGS],[C compilation flags for metis.])
AC_ARG_VAR([METIS_LDFLAGS],[Linker flags for metis.])
AC_ARG_VAR([METIS_LIBS],[Link libraries for metis.])

AC_ARG_WITH([metis],
[AS_HELP_STRING([--with-metis=yes/no],
  [Option to enable metis auto discovery, default: no.])],
[],
[with_metis="no"])

AC_ARG_WITH([metis-dir],
[AS_HELP_STRING([--with-metis-dir=DIR],
  [Option to enable metis discovery from specific installation prefix.])],
[],
[with_metis_dir=""])

AC_ARG_WITH([metis-include-dir],
[AS_HELP_STRING([--with-metis-include-dir=DIR],
  [Option to specify include directory of metis installation.])],
[],
[with_metis_include_dir=""])

AC_ARG_WITH([metis-lib-dir],
[AS_HELP_STRING([--with-metis-lib-dir=DIR],
  [Option to specify library directory of metis installation.])],
[],
[with_metis_lib_dir=""])

AC_ARG_WITH([metis-libs],
[AS_HELP_STRING([--with-metis-libs=STRING],
  [Option to specify link libraries for using metis.])],
[],
[with_metis_libs=""])

AC_ARG_WITH([metis-pkg-config],
[AS_HELP_STRING([--with-metis-pkg-config=PC_SEARCH_STRING],
  [Option to specify metis discovery using pkg-config.])],
[],
[with_metis_pkg_config=""])

AC_ARG_WITH([metis-additional-cppflags],
[AS_HELP_STRING([--with-metis-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering metis.])],
[],
[with_metis_additional_cppflags=""])

AC_ARG_WITH([metis-additional-cflags],
[AS_HELP_STRING([--with-metis-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering metis.])],
[],
[with_metis_additional_cflags=""])

AC_ARG_WITH([metis-additional-ldflags],
[AS_HELP_STRING([--with-metis-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering metis.])],
[],
[with_metis_additional_ldflags=""])

AC_ARG_WITH([metis-additional-libs],
[AS_HELP_STRING([--with-metis-additional-libs=STRING],
  [Option to specify additional link libraries for discovering metis.])],
[],
[with_metis_additional_libs=""])

_metis_config_option="Option"

AS_IF([test "x$with_metis" != "xno"],
[_metis_config_option="Auto$_metis_config_option"])

AS_IF([test -n "$with_metis_dir"],
[_metis_config_option="Dir$_metis_config_option"])

AS_IF([test -n "$with_metis_include_dir" || test -n "$with_metis_lib_dir" || test -n "$with_metis_libs"],
[_metis_config_option="ILDir$_metis_config_option"])

AS_IF([test -n "$with_metis_pkg_config"],
[_metis_config_option="PkgConfig$_metis_config_option"])

AS_IF([test -n "$METIS_CPPFLAGS" || test -n "$METIS_CFLAGS" || test -n "$METIS_LDFLAGS" || test -n "$METIS_LIBS"],
[_metis_config_option="Flags$_metis_config_option"])

AS_CASE(["$_metis_config_option"],
["Option"],
[
  AC_MSG_NOTICE([metis is not requested])
  have_metis="no"
],
["AutoOption"],
[
  dnl AC_MSG_NOTICE([metis will be auto-discovered])

  AS_IF([test -z "$METIS_DIR"],
  [
    AC_PATH_PROGS([_metis_bin_path],
    [gpmetis ndmetis mpmetis m2gmetis graphchk],
    [notfound])

    AS_IF([test "x$_metis_bin_path" != "xnotfound"],
    [
      METIS_DIR=`AS_DIRNAME([$_metis_bin_path])`
      METIS_DIR=`AS_DIRNAME([$METIS_DIR])`
    ])
  ])

  AS_IF([test -d "$METIS_DIR/include"],
  [
    dnl AC_MSG_NOTICE([directory $METIS_DIR/include exists])
    METIS_CFLAGS="-I$METIS_DIR/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $METIS_DIR/include does not exist])
  ])

  AS_IF([test -d "$METIS_DIR/lib"],
  [
    dnl AC_MSG_NOTICE([directory $METIS_DIR/lib exists])
    METIS_LDFLAGS="-L$METIS_DIR/lib"
    METIS_LIBS="-lmetis"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $METIS_DIR/lib does not exist])
  ])

  AS_IF([test -d "$METIS_DIR/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $METIS_DIR/lib64 exists])
    METIS_LDFLAGS="-L$METIS_DIR/lib64"
    METIS_LIBS="-lmetis"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $METIS_DIR/lib64 does not exist])
  ])

  _try_compile_link_metis_sample=yes
],
["DirOption"],
[
  dnl AC_MSG_NOTICE([metis will be discovered via specific installation prefix])

  AS_IF([test -d "$with_metis_dir/include"],
  [
    dnl AC_MSG_NOTICE([directory $with_metis_dir/include exists])
    METIS_CFLAGS="-I$with_metis_dir/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory with_metis_dir/include does not exist])
  ])

  AS_IF([test -d "$with_metis_dir/lib"],
  [
    dnl AC_MSG_NOTICE([directory $with_metis_dir/lib exists])
    METIS_LDFLAGS="-L$with_metis_dir/lib"
    METIS_LIBS="-lmetis"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_metis_dir/lib does not exist])
  ])

  AS_IF([test -d "$with_metis_dir/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $with_metis_dir/lib64 exists])
    METIS_LDFLAGS="-L$with_metis_dir/lib64"
    METIS_LIBS="-lmetis"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_metis_dir/lib64 does not exist])
  ])

  _try_compile_link_metis_sample=yes
],
["ILDirOption"],
[
  dnl AC_MSG_NOTICE([metis will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_metis_include_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_metis_include_dir exists])
    METIS_CFLAGS="-I$with_metis_include_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_metis_include_dir does not exist])
  ])

  AS_IF([test -d "$with_metis_lib_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_metis_lib_dir exists])
    METIS_LDFLAGS="-L$with_metis_lib_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_metis_lib_dir does not exist])
  ])

  METIS_LIBS="$with_metis_libs"

  _try_compile_link_metis_sample=yes
],
["PkgConfigOption"],
[
  dnl AC_MSG_NOTICE([metis will be discovered via pkg-config])

  _metis_pkg_config_name="metis"
  AS_IF([test "x$with_metis_pkg_config" != "xyes"],[_metis_pkg_config_name=$with_metis_pkg_config])

  PKG_CHECK_MODULES([METIS],
  [$_metis_pkg_config_name],
  [_try_compile_link_metis_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_metis_pkg_config_name])])
],
["FlagsOption"],
[
  dnl AC_MSG_NOTICE([metis will be discovered via environment variable flags])
  _try_compile_link_metis_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for metis: $_metis_config_option])])

AS_IF([test "x$_try_compile_link_metis_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$METIS_CPPFLAGS $with_metis_additional_cppflags $CPPFLAGS"
  CFLAGS="$METIS_CFLAGS $with_metis_additional_cflags $CFLAGS"
  LDFLAGS="$METIS_LDFLAGS $with_metis_additional_ldflags $LDFLAGS"
  LIBS="$METIS_LIBS $with_metis_additional_libs $LIBS"

  AC_MSG_CHECKING([if metis is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <metis.h>
  int main(int argc, char * argv[]) {
    idx_t nvtxs;
    idx_t ncon;
    idx_t *xadj;
    idx_t *adjncy;
    idx_t *vwgt;
    idx_t *vsize;
    idx_t *adjwgt;
    idx_t nparts;
    real_t *tpwgts;
    real_t ubvec;
    idx_t *options;
    idx_t *objval;
    idx_t *part;
    METIS_PartGraphKway(&nvtxs, &ncon, xadj, adjncy, vwgt, vsize, adjwgt, &nparts, tpwgts, &ubvec, options, objval, part);
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_metis=yes
    AC_SUBST([HAVE_METIS],[1])

    AC_DEFINE([HAVE_METIS],[1],[defined to 1 if metis is available])

    dnl AC_MSG_NOTICE([METIS_CPPFLAGS=$METIS_CPPFLAGS])
    dnl AC_MSG_NOTICE([METIS_CFLAGS=$METIS_CFLAGS])
    dnl AC_MSG_NOTICE([METIS_LDFLAGS=$METIS_LDFLAGS])
    dnl AC_MSG_NOTICE([METIS_LIBS=$METIS_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([[could not link with metis using:
    METIS_CPPFLAGS=$METIS_CPPFLAGS
    METIS_CFLAGS=$METIS_CFLAGS
    METIS_LDFLAGS=$METIS_LDFLAGS
    METIS_LIBS=$METIS_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_METIS],[test "x$have_metis" == "xyes"])

])
