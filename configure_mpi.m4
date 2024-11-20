AC_DEFUN([CONFIGURE_MPI], [
AC_PREREQ([2.69])

AC_ARG_VAR([MPI_DIR],[Prefix of mpi installation.])
AC_ARG_VAR([MPI_CPPFLAGS],[C/C++ preprocessor flags for mpi.])
AC_ARG_VAR([MPI_CFLAGS],[C compilation flags for mpi.])
AC_ARG_VAR([MPI_LDFLAGS],[Linker flags for mpi.])
AC_ARG_VAR([MPI_LIBS],[Link libraries for mpi.])

AC_ARG_WITH([mpi],
[AS_HELP_STRING([--with-mpi=yes/no],
  [Option to enable mpi auto discovery, default: no.])],
[],
[with_mpi="no"])

AC_ARG_WITH([mpi-dir],
[AS_HELP_STRING([--with-mpi-dir=DIR],
  [Option to enable mpi discovery from specific installation prefix.])],
[],
[with_mpi_dir=""])

AC_ARG_WITH([mpi-include-dir],
[AS_HELP_STRING([--with-mpi-include-dir=DIR],
  [Option to specify include directory of mpi installation.])],
[],
[with_mpi_include_dir=""])

AC_ARG_WITH([mpi-lib-dir],
[AS_HELP_STRING([--with-mpi-lib-dir=DIR],
  [Option to specify library directory of mpi installation.])],
[],
[with_mpi_lib_dir=""])

AC_ARG_WITH([mpi-libs],
[AS_HELP_STRING([--with-mpi-libs=STRING],
  [Option to specify link libraries for using mpi.])],
[],
[with_mpi_libs=""])

AC_ARG_WITH([mpi-pkg-config],
[AS_HELP_STRING([--with-mpi-pkg-config=PC_SEARCH_STRING],
  [Option to enable mpi discovery using pkg-config.])],
[],
[with_mpi_pkg_config=""])

AC_ARG_WITH([mpi-additional-cppflags],
[AS_HELP_STRING([--with-mpi-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering mpi.])],
[],
[with_mpi_additional_cppflags=""])

AC_ARG_WITH([mpi-additional-cflags],
[AS_HELP_STRING([--with-mpi-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering mpi.])],
[],
[with_mpi_additional_cflags=""])

AC_ARG_WITH([mpi-additional-ldflags],
[AS_HELP_STRING([--with-mpi-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering mpi.])],
[],
[with_mpi_additional_ldflags=""])

AC_ARG_WITH([mpi-additional-libs],
[AS_HELP_STRING([--with-mpi-additional-libs=STRING],
  [Option to specify additional link libraries for discovering mpi.])],
[],
[with_mpi_additional_libs=""])

_mpi_config_option="Option"

AS_IF([test "x$with_mpi" != "xno"],
[_mpi_config_option="Auto$_mpi_config_option"])

AS_IF([test -n "$with_mpi_dir"],
[_mpi_config_option="Dir$_mpi_config_option"])

AS_IF([test -n "$with_mpi_include_dir" || test -n "$with_mpi_lib_dir" || test -n "$with_mpi_libs"],
[_mpi_config_option="ILDir$_mpi_config_option"])

AS_IF([test -n "$with_mpi_pkg_config"],
[_mpi_config_option="PkgConfig$_mpi_config_option"])

AS_IF([test -n "$MPI_CPPFLAGS" || test -n "$MPI_CFLAGS" || test -n "$MPI_LDFLAGS" || test -n "$MPI_LIBS"],
[_mpi_config_option="Flags$_mpi_config_option"])

AS_CASE(["$_mpi_config_option"],
["Option"],
[
  AC_MSG_NOTICE([mpi is not requested])
  have_mpi=no
],
["AutoOption"],
[
  dnl AC_MSG_NOTICE([mpi will be auto-discovered])

  AS_IF([test -z "$MPI_DIR"],
  [
    AC_PATH_PROGS([_mpi_bin_path],
    [mpicc mpic++ mpicxx],
    [notfound])

    AS_IF([test "x$_mpi_bin_path" != "xnotfound"],
    [
      MPI_DIR=`AS_DIRNAME(["$_mpi_bin_path"])`
      MPI_DIR=`AS_DIRNAME(["$MPI_DIR"])`
    ])
  ])

  AS_IF([test -d "$MPI_DIR/include"],
  [
    dnl AC_MSG_NOTICE([directory $MPI_DIR/include exists])
    MPI_CFLAGS="-I$MPI_DIR/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $MPI_DIR/include does not exist])
  ])

  AS_IF([test -d "$MPI_DIR/lib"],
  [
    dnl AC_MSG_NOTICE([directory $MPI_DIR/lib exists])
    MPI_LDFLAGS="-L$MPI_DIR/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $MPI_DIR/lib does not exist])
  ])

  MPI_LIBS="-lmpi"

  _try_compile_link_mpi_sample=yes
],
["DirOption"],
[
  dnl AC_MSG_NOTICE([mpi will be discovered via specified installation prefix])

  AS_IF([test -d "$with_mpi_dir/include"],
  [
    dnl AC_MSG_NOTICE([directory $with_mpi_dir/include exists])
    MPI_CFLAGS="-I$with_mpi_dir/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_mpi_dir/include does not exist])
  ])

  AS_IF([test -d "$with_mpi_dir/lib"],
  [
    dnl AC_MSG_NOTICE([directory $with_mpi_dir/lib exists])
    MPI_LDFLAGS="-L$with_mpi_dir/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_mpi_dir/lib does not exist])
  ])

  MPI_LIBS="-lmpi"

  _try_compile_link_mpi_sample=yes
],
["ILDirOption"],
[
  dnl AC_MSG_NOTICE([mpi will be discovered via include and lib directories])

  AS_IF([test -d "$with_mpi_include_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_mpi_include_dir exists])
    MPI_CFLAGS="-I$with_mpi_include_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_mpi_include_dir does not exist])
  ])

  AS_IF([test -d "$with_mpi_lib_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_mpi_lib_dir exists])
    MPI_LDFLAGS="-L$with_mpi_lib_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_mpi_lib_dir does not exist])
  ])

  MPI_LIBS="$with_mpi_libs"

  _try_compile_link_mpi_sample=yes
],
["PkgConfigOption"],
[
  dnl AC_MSG_NOTICE([mpi will be discovered via pkg-config])

  _mpi_pkg_config_name="mpi"
  AS_IF([test "x$with_mpi_pkg_config" != "xyes"],[_mpi_pkg_config_name="$with_mpi_pkg_config"])

  PKG_CHECK_MODULES([MPI],
  [$_mpi_pkg_config_name],
  [_try_compile_link_mpi_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_mpi_pkg_config_name])])
],
["FlagsOption"],
[
  dnl AC_MSG_NOTICE([mpi will be discovered via environment variable flags])
  _try_compile_link_mpi_sample=yes
],
[AC_MSG_ERROR([multiple cinfiguration options for mpi: $_mpi_config_option])]
)

AS_IF([test "x$_try_compile_link_mpi_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$MPI_CPPFLAGS $with_mpi_additional_cppflags $CPPFLAGS"
  CFLAGS="$MPI_CFLAGS $with_mpi_additional_cflags $CFLAGS"
  LDFLAGS="$MPI_LDFLAGS $with_mpi_additional_ldflags $LDFLAGS"
  LIBS="$MPI_LIBS $with_mpi_additional_libs $LIBS"

  AC_MSG_CHECKING([if mpi is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <mpi.h>
  int main(int argc, char * argv[]) {
    MPI_Init(&argc, &argv);
    return MPI_Finalize();
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_mpi=yes
    AC_SUBST([HAVE_MPI],[1])

    AC_DEFINE([HAVE_MPI],[1],[defined to 1 if mpi is available])

    dnl AC_MSG_NOTICE([MPI_CPPFLAGS=$MPI_CPPFLAGS])
    dnl AC_MSG_NOTICE([MPI_CFLAGS=$MPI_CFLAGS])
    dnl AC_MSG_NOTICE([MPI_LDFLAGS=$MPI_LDFLAGS])
    dnl AC_MSG_NOTICE([MPI_LIBS=$MPI_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([[Could not link with mpi using:
    MPI_CPPFLAGS=$MPI_CPPFLAGS
    MPI_CFLAGS=$MPI_CFLAGS
    MPI_LDFLAGS=$MPI_LDFLAGS
    MPI_LIBS=$MPI_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_MPI],[test "x$have_mpi" == "xyes"])

])
