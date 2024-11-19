dnl PETSc is a C library. Hence, only C support is tested.
dnl TODO:
dnl 1. Detect various features that petsc is compiled with

AC_DEFUN([CONFIGURE_PETSC], [
AC_PREREQ([2.69])

AC_ARG_VAR([PETSC_DIR],[Prefix of petsc installation.])
AC_ARG_VAR([PETSC_CPPFLAGS],[C/C++ preprocessor flags for petsc.])
AC_ARG_VAR([PETSC_CFLAGS],[C compilation flags for petsc.])
AC_ARG_VAR([PETSC_LDFLAGS],[Linker flags for petsc.])
AC_ARG_VAR([PETSC_LIBS],[Link libraries for petsc.])

AC_ARG_WITH([petsc],
[AS_HELP_STRING([--with-petsc=yes/no],
  [Option to enable petsc auto discovery, default: no.])],
[],
[with_petsc=no])

AC_ARG_WITH([petsc-dir],
[AS_HELP_STRING([--with-petsc-dir=DIR],
  [Option to enable petsc discovery from specific installation prefix.])],
[],
[with_petsc_dir=""])

AC_ARG_WITH([petsc-include-dir],
[AS_HELP_STRING([--with-petsc-include-dir=DIR],
  [Option to specify include directory of petsc installation.])],
[],
[with_petsc_include_dir=""])

AC_ARG_WITH([petsc-lib-dir],
[AS_HELP_STRING([--with-petsc-lib-dir=DIR],
  [Option to specify library directory of petsc installation.])],
[],
[with_petsc_lib_dir=""])

AC_ARG_WITH([petsc-libs],
[AS_HELP_STRING([--with-petsc-libs=STRING],
  [Option to specify link libraries for using petsc.])],
[],
[with_petsc_libs=""])

AC_ARG_WITH([petsc-pkg-config],
[AS_HELP_STRING([--with-petsc-pkg-config=PC_SEARCH_STRING],
  [Option to enable petsc discovery using pkg-config.])],
[],
[with_petsc_pkg_config=""])

AC_ARG_WITH([petsc-additional-cppflags],
[AS_HELP_STRING([--with-petsc-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering petsc.])],
[],
[with_petsc_additional_cppflags=""])

AC_ARG_WITH([petsc-additional-cflags],
[AS_HELP_STRING([--with-petsc-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering petsc.])],
[],
[with_petsc_additional_cflags=""])

AC_ARG_WITH([petsc-additional-ldflags],
[AS_HELP_STRING([--with-petsc-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering petsc.])],
[],
[with_petsc_additional_ldflags=""])

AC_ARG_WITH([petsc-additional-libs],
[AS_HELP_STRING([--with-petsc-additional-libs=STRING],
  [Option to specify additional link libraries for discovering petsc.])],
[],
[with_petsc_additional_libs=""])

_petsc_config_option="Option"

AS_IF([test "x$with_petsc" != "xno"],
[_petsc_config_option="Auto$_petsc_config_option"])

AS_IF([test -n "$with_petsc_dir"],
[_petsc_config_option="Dir$_petsc_config_option"])

AS_IF([test -n "$with_petsc_include_dir" || test -n "$with_petsc_lib_dir" || test -n "$with_petsc_libs"],
[_petsc_config_option="ILDir$_petsc_config_option"])

AS_IF([test -n "$with_petsc_pkg_config"],
[_petsc_config_option="PkgConfig$_petsc_config_option"])

AS_IF([test -n "$PETSC_CPPFLAGS" || test -n "$PETSC_CFLAGS" || test -n "$PETSC_LDFLAGS" || test -n "$PETSC_LIBS"],
[_petsc_config_option="Flags$_petsc_config_option"])

AS_CASE(["$_petsc_config_option"],
["Option"],
[
  AC_MSG_NOTICE([petsc is not requested])
  have_petsc=no
],
["AutoOption"],
[
  AC_MSG_NOTICE([petsc will be auto-discovered])

  AS_IF([test -d "$PETSC_DIR/include"],
  [
    AC_MSG_NOTICE([directory $PETSC_DIR/include exists])
    PETSC_CFLAGS="-I$PETSC_DIR/include"
  ], [AC_MSG_NOTICE([directory $PETSC_DIR/include does not exist])])

  AS_IF([test -d "$PETSC_DIR/lib"],
  [
    AC_MSG_NOTICE([directory $PETSC_DIR/lib exists])
    PETSC_LDFLAGS="-L$PETSC_DIR/lib"
  ], [AC_MSG_NOTICE([directory $PETSC_DIR/lib does not exist])])

  AS_IF([test -d "$PETSC_DIR/lib64"],
  [
    AC_MSG_NOTICE([directory $PETSC_DIR/lib64 exists])
    PETSC_LDFLAGS="-L$PETSC_DIR/lib64"
  ], [AC_MSG_NOTICE([directory $PETSC_DIR/lib64 does not exist])])

  PETSC_LIBS="-lpetsc"

  _try_compile_link_petsc_sample=yes
],
["DirOption"],
[
  AC_MSG_NOTICE([petsc will be discovered via specified installation prefix])

  AS_IF([test -d "$with_petsc_dir/include"],
  [
    AC_MSG_NOTICE([directory $with_petsc_dir/include exists])
    PETSC_CFLAGS="-I$with_petsc_dir/include"
  ], [AC_MSG_NOTICE([directory $with_petsc_dir/include does not exist])])

  AS_IF([test -d "$with_petsc_dir/lib"],
  [
    AC_MSG_NOTICE([directory $with_petsc_dir/lib exists])
    PETSC_LDFLAGS="-L$with_petsc_dir/lib"
  ], [AC_MSG_NOTICE([directory $with_petsc_dir/lib does not exist])])

  AS_IF([test -d "$with_petsc_dir/lib64"],
  [
    AC_MSG_NOTICE([directory $with_petsc_dir/lib64 exists])
    PETSC_LDFLAGS="-L$with_petsc_dir/lib64"
  ], [AC_MSG_NOTICE([directory $with_petsc_dir/lib64 does not exist])])

  PETSC_LIBS="-lpetsc"

  _try_compile_link_petsc_sample=yes
],
["ILDirOption"],
[
  AC_MSG_NOTICE([petsc will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_petsc_include_dir"],
  [
    AC_MSG_NOTICE([directory $with_petsc_include_dir exists])
    PETSC_CFLAGS="-I$with_petsc_include_dir"
  ], [AC_MSG_NOTICE([directory $with_petsc_include_dir does not exist])])

  AS_IF([test -d "$with_petsc_lib_dir"],
  [
    AC_MSG_NOTICE([directory $with_petsc_lib_dir exists])
    PETSC_LDFLAGS="-L$with_petsc_lib_dir"
  ], [AC_MSG_NOTICE([directory $with_petsc_lib_dir does not exist])])

  PETSC_LIBS="$with_petsc_libs"

  _try_compile_link_petsc_sample=yes
],
["PkgConfigOption"],
[
  AC_MSG_NOTICE([petsc will be discovered via pkg-config])

  _petsc_pkg_config_name="petsc"
  AS_IF([test "x$with_petsc_pkg_config" != "xyes"],[_petsc_pkg_config_name="$with_petsc_pkg_config"])

  PKG_CHECK_MODULES([PETSC],
  [$_petsc_pkg_config_name],
  [_try_compile_link_petsc_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_petsc_pkg_config_name])])
],
["FlagsOption"],
[
  AC_MSG_NOTICE([petsc will be discovered via environment variable flags])
  _try_compile_link_petsc_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for petsc: $_petsc_config_option])])

AS_IF([test "x$_try_compile_link_petsc_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$PETSC_CPPFLAGS $with_petsc_additional_cppflags $CPPFLAGS"
  CFLAGS="$PETSC_CFLAGS $with_petsc_additional_cflags $CFLAGS"
  LDFLAGS="$PETSC_LDFLAGS $with_petsc_additional_ldflags $LDFLAGS"
  LIBS="$PETSC_LIBS $with_petsc_additional_libs $LIBS"

  AC_MSG_CHECKING([if petsc is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <petsc.h>
  int main(int argc, char * argv[]) {
    PetscCall(PetscInitialize(&argc, &argv, NULL, ""));
    PetscCall(PetscFinalize());
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_petsc=yes
    AC_SUBST([HAVE_PETSC],[1])

    AC_DEFINE([HAVE_PETSC],[1],[defined to 1 if petsc is available])

    AC_MSG_NOTICE([PETSC_CPPFLAGS=$PETSC_CPPFLAGS])
    AC_MSG_NOTICE([PETSC_CFLAGS=$PETSC_CFLAGS])
    AC_MSG_NOTICE([PETSC_LDFLAGS=$PETSC_LDFLAGS])
    AC_MSG_NOTICE([PETSC_LIBS=$PETSC_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_FAILURE([[Could not link with petsc using:
    PETSC_CPPFLAGS=$PETSC_CPPFLAGS
    PETSC_CFLAGS=$PETSC_CFLAGS
    PETSC_LDFLAGS=$PETSC_LDFLAGS
    PETSC_LIBS=$PETSC_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_PETSC],[test "x$have_petsc" == "xyes"])

])
