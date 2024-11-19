dnl CGNS is a C library. Hence, only C support is tested.

AC_DEFUN([CONFIGURE_CGNS], [
AC_PREREQ([2.69])

AC_ARG_VAR([CGNS_DIR],[Prefix of cgns installation.])
AC_ARG_VAR([CGNS_CPPFLAGS],[C/C++ preprocessor flags for cgns.])
AC_ARG_VAR([CGNS_CFLAGS],[C compilation flags for cgns.])
AC_ARG_VAR([CGNS_LDFLAGS],[Linker flags for cgns.])
AC_ARG_VAR([CGNS_LIBS],[Link libraries for cgns.])

AC_ARG_WITH([cgns],
[AS_HELP_STRING([--with-cgns=yes/no],
  [Option to enable cgns auto discovery, default: no.])],
[],
[with_cgns="no"])

AC_ARG_WITH([cgns-dir],
[AS_HELP_STRING([--with-cgns-dir=DIR],
  [Option to enable cgns discovery from specific installation prefix.])],
[],
[with_cgns_dir=""])

AC_ARG_WITH([cgns-include-dir],
[AS_HELP_STRING([--with-cgns-include-dir=DIR],
  [Option to specify include directory of cgns installation.])],
[],
[with_cgns_include_dir=""])

AC_ARG_WITH([cgns-lib-dir],
[AS_HELP_STRING([--with-cgns-lib-dir=DIR],
  [Option to specify library directory of cgns installation.])],
[],
[with_cgns_lib_dir=""])

AC_ARG_WITH([cgns-libs],
[AS_HELP_STRING([--with-cgns-libs=STRING],
  [Option to specify link libraries for using cgns.])],
[],
[with_cgns_libs=""])

AC_ARG_WITH([cgns-pkg-config],
[AS_HELP_STRING([--with-cgns-pkg-config=PC_SEARCH_STRING],
  [Option to enable cgns discovery using pkg-config.])],
[],
[with_cgns_pkg_config=""])

AC_ARG_WITH([cgns-additional-cppflags],
[AS_HELP_STRING([--with-cgns-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering cgns.])],
[],
[with_cgns_additional_cppflags=""])

AC_ARG_WITH([cgns-additional-cflags],
[AS_HELP_STRING([--with-cgns-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering cgns.])],
[],
[with_cgns_additional_cflags=""])

AC_ARG_WITH([cgns-additional-ldflags],
[AS_HELP_STRING([--with-cgns-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering cgns.])],
[],
[with_cgns_additional_ldflags=""])

AC_ARG_WITH([cgns-additional-libs],
[AS_HELP_STRING([--with-cgns-additional-libs=STRING],
  [Option to specify additional link libraries for discovering cgns.])],
[],
[with_cgns_additional_libs=""])

_cgns_config_option="Option"

AS_IF([test "x$with_cgns" != "xno"],
[_cgns_config_option="Auto$_cgns_config_option"])

AS_IF([test -n "$with_cgns_dir"],
[_cgns_config_option="Dir$_cgns_config_option"])

AS_IF([test -n "$with_cgns_include_dir" || test -n "$with_cgns_lib_dir" || test -n "$with_cgns_libs"],
[_cgns_config_option="ILDir$_cgns_config_option"])

AS_IF([test -n "$with_cgns_pkg_config"],
[_cgns_config_option="PkgConfig$_cgns_config_option"])

AS_IF([test -n "$CGNS_CPPFLAGS" || test -n "$CGNS_CFLAGS" || test -n "$CGNS_LDFLAGS" || test -n "$CGNS_LIBS"],
[_cgns_config_option="Flags$_cgns_config_option"])

AS_CASE(["$_cgns_config_option"],
["Option"],
[
  AC_MSG_NOTICE([cgns is not requested])
  have_cgns=no
],
["AutoOption"],
[
  AC_MSG_NOTICE([cgns will be auto-discovered])

  AS_IF([test -z "$CGNS_DIR"],
  [
    AC_PATH_PROGS([_cgns_bin_path],
    [cgnsdiff cgnslist cgnsnames cgnscheck],
    [notfound])

    AS_IF([test "x$_cgns_bin_path" != "xnotfound"],
    [
      CGNS_DIR=`AS_DIRNAME(["$_cgns_bin_path"])`
      CGNS_DIR=`AS_DIRNAME(["$CGNS_DIR"])`
    ])
  ])

  AS_IF([test -d "$CGNS_DIR/include"],
  [
    AC_MSG_NOTICE([directory $CGNS_DIR/include exists])
    CGNS_CFLAGS="-I$CGNS_DIR/include"
  ], [AC_MSG_NOTICE([directory $CGNS_DIR/include does not exist])])

  AS_IF([test -d "$CGNS_DIR/lib"],
  [
    AC_MSG_NOTICE([directory $CGNS_DIR/lib exists])
    CGNS_LDFLAGS="-L$CGNS_DIR/lib"
    CGNS_LIBS="-lcgns"
  ], [AC_MSG_NOTICE([directory $CGNS_DIR/lib does not exist])])

  AS_IF([test -d "$CGNS_DIR/lib64"],
  [
    AC_MSG_NOTICE([directory $CGNS_DIR/lib64 exists])
    CGNS_LDFLAGS="-L$CGNS_DIR/lib64"
  ], [AC_MSG_NOTICE([directory $CGNS_DIR/lib64 does not exist])])

  CGNS_LIBS="-lcgns"

  _try_compile_link_cgns_sample=yes
],
["DirOption"],
[
  AC_MSG_NOTICE([cgns will be discovered via specified installation prefix])

  AS_IF([test -d "$with_cgns_dir/include"],
  [
    AC_MSG_NOTICE([directory $with_cgns_dir/include exists])
    CGNS_CFLAGS="-I$with_cgns_dir/include"
  ], [AC_MSG_NOTICE([directory $with_cgns_dir/include does not exist])])

  AS_IF([test -d "$with_cgns_dir/lib"],
  [
    AC_MSG_NOTICE([directory $with_cgns_dir/lib exists])
    CGNS_LDFLAGS="-L$with_cgns_dir/lib"
  ], [AC_MSG_NOTICE([directory $with_cgns_dir/lib does not exist])])

  AS_IF([test -d "$with_cgns_dir/lib64"],
  [
    AC_MSG_NOTICE([directory $with_cgns_dir/lib64 exists])
    CGNS_LDFLAGS="-L$with_cgns_dir/lib64"
  ], [AC_MSG_NOTICE([directory $with_cgns_dir/lib64 does not exist])])

  CGNS_LIBS="-lcgns"

  _try_compile_link_cgns_sample=yes
],
["ILDirOption"],
[
  AC_MSG_NOTICE([cgns will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_cgns_include_dir"],
  [
    AC_MSG_NOTICE([directory $with_cgns_include_dir exists])
    CGNS_CFLAGS="-I$with_cgns_include_dir"
  ], [AC_MSG_NOTICE([directory $with_cgns_include_dir does not exist])])

  AS_IF([test -d "$with_cgns_lib_dir"],
  [
    AC_MSG_NOTICE([directory $with_cgns_lib_dir exists])
    CGNS_LDFLAGS="-L$with_cgns_lib_dir"
  ], [AC_MSG_NOTICE([directory $with_cgns_lib_dir does not exist])])

  CGNS_LIBS="$with_cgns_libs"

  _try_compile_link_cgns_sample=yes
],
["PkgConfigOption"],
[
  AC_MSG_NOTICE([cgns will be discovered via pkg-config])

  _cgns_pkg_config_name="libcgns"
  AS_IF([test "x$with_cgns_pkg_config" != "xyes"],[_cgns_pkg_config_name=$with_cgns_pkg_config])

  PKG_CHECK_MODULES([CGNS],
  [$_cgns_pkg_config_name],
  [_try_compile_link_cgns_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_cgns_pkg_config_name])])
],
["FlagsOption"],
[
  AC_MSG_NOTICE([cgns will be discovered via environment variable flags])
  _try_compile_link_cgns_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for cgns: $_cgns_config_option])]
)

AS_IF([test "x$_try_compile_link_cgns_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$CGNS_CPPFLAGS $with_cgns_additional_cppflags $CPPFLAGS"
  CFLAGS="$CGNS_CFLAGS $with_cgns_additional_cflags $CFLAGS"
  LDFLAGS="$CGNS_LDFLAGS $with_cgns_additional_ldflags $LDFLAGS"
  LIBS="$CGNS_LIBS $with_cgns_additional_libs $LIBS"

  AC_MSG_CHECKING([if cgns is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <cgnslib.h>
  int main(int argc, char * argv[]) {
    float version;
    int fn = 0;
    cg_version(fn, &version);
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_cgns=yes
    AC_SUBST([HAVE_CGNS],[1])

    AC_DEFINE([HAVE_CGNS],[1],[defined to 1 if cgns is available])

    AC_MSG_NOTICE([CGNS_CPPFLAGS=$CGNS_CPPFLAGS])
    AC_MSG_NOTICE([CGNS_CFLAGS=$CGNS_CFLAGS])
    AC_MSG_NOTICE([CGNS_LDFLAGS=$CGNS_LDFLAGS])
    AC_MSG_NOTICE([CGNS_LIBS=$CGNS_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_FAILURE([[Could not link with cgns using:
    CGNS_CPPFLAGS=$CGNS_CPPFLAGS
    CGNS_CFLAGS=$CGNS_CFLAGS
    CGNS_LDFLAGS=$CGNS_LDFLAGS
    CGNS_LIBS=$CGNS_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_CGNS],[test "x$have_cgns" == "xyes"])

])
