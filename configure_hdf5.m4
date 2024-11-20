AC_DEFUN([CONFIGURE_HDF5],[
AC_PREREQ([2.69])

AC_ARG_VAR([HDF5_DIR],[Prefix of hdf5 installation.])
AC_ARG_VAR([HDF5_CPPFLAGS],[C/C++ preprocessor flags for hdf5 and hdf5_hl.])
AC_ARG_VAR([HDF5_CFLAGS],[C compilation flags for hdf5 and hdf5_hl.])
AC_ARG_VAR([HDF5_LDFLAGS],[Linker flags for hdf5 and hdf5_hl.])
AC_ARG_VAR([HDF5_LIBS],[Link libraries for hdf5.])
AC_ARG_VAR([HDF5_HL_LIBS],[Link libraries for hdf5_hl.])

AC_ARG_WITH([hdf5],
[AS_HELP_STRING([--with-hdf5=yes/no],
  [Option to enable hdf5 auto discovery, default: no.])],
[],
[with_hdf5=no])

AC_ARG_WITH([hdf5-dir],
[AS_HELP_STRING([--with-hdf5-dir=DIR],
  [Option to enable hdf5 discovery from a specified installation prefix.])],
[],
[with_hdf5_dir=""])

AC_ARG_WITH([hdf5-include-dir],
[AS_HELP_STRING([--with-hdf5-include-dir=DIR],
  [Option to specify include directory of hdf5 installation.])],
[],
[with_hdf5_include_dir=""])

AC_ARG_WITH([hdf5-lib-dir],
[AS_HELP_STRING([--with-hdf5-lib-dir=DIR],
  [Option to specify library directory of hdf5 installation.])],
[],
[with_hdf5_lib_dir=""])

AC_ARG_WITH([hdf5-libs],
[AS_HELP_STRING([--with-hdf5-libs=STRING],
  [Option to specify link libraries for using hdf5.])],
[],
[with_hdf5_libs=""])

AC_ARG_WITH([hdf5-hl-libs],
[AS_HELP_STRING([--with-hdf5-hl-libs=STRING],
  [Option to specify link libraries for using hdf5_hl.])],
[],
[with_hdf5_hl_libs=""])

AC_ARG_WITH([hdf5-pkg-config],
[AS_HELP_STRING([--with-hdf5-pkg-config=PC_SEARCH_STRING],
  [Option to enable hdf5 discovery using pkg-config.])],
[],
[with_hdf5_pkg_config=""])

AC_ARG_WITH([hdf5-additional-cppflags],
[AS_HELP_STRING([--with-hdf5-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering hdf5.])],
[],
[with_hdf5_additional_cppflags=""])

AC_ARG_WITH([hdf5-additional-cflags],
[AS_HELP_STRING([--with-hdf5-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering hdf5.])],
[],
[with_hdf5_additional_cflags=""])

AC_ARG_WITH([hdf5-additional-ldflags],
[AS_HELP_STRING([--with-hdf5-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering hdf5.])],
[],
[with_hdf5_additional_ldflags=""])

AC_ARG_WITH([hdf5-additional-libs],
[AS_HELP_STRING([--with-hdf5-additional-libs=STRING],
  [Option to specify additional link libraries for discovering hdf5.])],
[],
[with_hdf5_additional_libs=""])

_hdf5_config_option="Option"

AS_IF([test "x$with_hdf5" != "xno"],
[_hdf5_config_option="Auto$_hdf5_config_option"])

AS_IF([test -n "$with_hdf5_dir"],
[_hdf5_config_option="Dir$_hdf5_config_option"])

AS_IF([test -n "$with_hdf5_include_dir" || test -n "$with_hdf5_lib_dir" || test -n "$with_hdf5_libs"],
[_hdf5_config_option="ILDir$_hdf5_config_option"])

AS_IF([test -n "$with_hdf5_pkg_config"],
[_hdf5_config_option="PkgConfig$_hdf5_config_option"])

AS_IF([test -n "$HDF5_CPPFLAGS" || test -n "$HDF5_CFLAGS" || test -n "$HDF5_LDFLAGS" || test -n "$HDF5_LIBS"],
[_hdf5_config_option="Flags$_hdf5_config_option"])

AS_CASE(["$_hdf5_config_option"],
["Option"],
[
  AC_MSG_NOTICE([hdf5 not requested])
  have_hdf5=no
],
["AutoOption"],
[
  dnl AC_MSG_NOTICE([hdf5 will be auto-discovered])

  AS_IF([test -z "$HDF5_DIR"],
  [
    AC_PATH_PROGS([_hdf5_bin_path],
    [h5cc h5pcc h5dump h5diff h5import h5debug h5ls h5perf gif2h5 h52gif h5redeploy h5repack h5repart h5stat h5perf_serial h5mkgrp h5copy],
    [notfound])

    AS_IF([test "x$_hdf5_bin_path" != "xnotfound"],
    [
      HDF5_DIR=`AS_DIRNAME(["$_hdf5_bin_path"])`
      HDF5_DIR=`AS_DIRNAME(["$HDF5_DIR"])`
    ])
  ])

  AS_IF([test -d "$HDF5_DIR/include"],
  [
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/include exists])
    HDF5_CFLAGS="-I$HDF5_DIR/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/include does not exist])
 ])

  AS_IF([test -d "$HDF5_DIR/lib"],
  [
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/lib exists])
    HDF5_LDFLAGS="-L$HDF5_DIR/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/lib does not exist])
  ])

  AS_IF([test -d "$HDF5_DIR/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/lib64 exists])
    HDF5_LDFLAGS="-L$HDF5_DIR/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $HDF5_DIR/lib64 does not exist])
  ])

  HDF5_LIBS="-lhdf5"
  HDF5_HL_LIBS="-lhdf5_hl"

  _try_compile_link_hdf5_sample=yes
],
["DirOption"],
[
  dnl AC_MSG_NOTICE([Looking for hdf5 in directory $with_hdf5_dir])

  AC_PATH_PROGS([_hdf5_bin_path],
  [h5cc h5pcc h5dump h5diff h5import h5debug h5ls h5perf gif2h5 h52gif h5redeploy h5repack h5repart h5stat h5perf_serial h5mkgrp h5copy],
  [notfound],[$with_hdf5_dir:$with_hdf5_dir/bin])

  AS_IF([test "x$_hdf5_bin_path" == "xnotfound"],
  [
    :
    dnl AC_MSG_NOTICE([could not find hdf5 tools in $with_hdf5_dir])
  ])

  AS_IF([test -d "$with_hdf5_dir/include"],
  [
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/include exists])
    HDF5_CFLAGS="-I$with_hdf5_dir/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/include does not exist])
  ])

  AS_IF([test -d "$with_hdf5_dir/lib"],
  [
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/lib exists])
    HDF5_LDFLAGS="-I$with_hdf5_dir/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/lib does not exist])
  ])

  AS_IF([test -d "$with_hdf5_dir/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/lib64 exists])
    HDF5_LDFLAGS="-I$with_hdf5_dir/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_hdf5_dir/lib64 does not exist])
  ])

  HDF5_LIBS="-lhdf5"
  HDF5_HL_LIBS="-lhdf5_hl"

  _try_compile_link_hdf5_sample=yes
],
["ILDirOption"],
[
  dnl AC_MSG_NOTICE([Looking for hdf5 in directories $with_hdf5_include_dir $with_hdf5_lib_dir])

  AS_IF([test -d "$with_hdf5_include_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_hdf5_include_dir exists])
    HDF5_CFLAGS="-I$with_hdf5_include_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_hdf5_include_dir does not exist])
  ])

  AS_IF([test -d "$with_hdf5_lib_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_hdf5_lib_dir exists])
    HDF5_LDFLAGS="-I$with_hdf5_lib_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_hdf5_lib_dir does not exist])
  ])

  HDF5_LIBS="$with_hdf5_libs"
  HDF5_HL_LIBS="$with_hdf5_hl_libs"

  _try_compile_link_hdf5_sample=yes
],
["PkgConfigOption"],
[
  dnl AC_MSG_NOTICE([hdf5 will be discovered via pkg-config])

  _hdf5_pkg_config_name="hdf5"
  AS_IF([test "x$with_hdf5_pkg_config" != "xyes"],[_hdf5_pkg_config_name="$with_hdf5_pkg_config"])

  PKG_CHECK_MODULES([HDF5],
  [$_hdf5_pkg_config_name],
  [_try_compile_link_hdf5_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_hdf5_pkg_config_name])])

  HDF5_HL_LIBS=""
],
["FlagsOption"],
[
  dnl AC_MSG_NOTICE([hdf5 will be discovered via environment variable flags])
  _try_compile_link_hdf5_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for hdf5: $_hdf5_config_option])]
)

AS_IF([test "x$_try_compile_link_hdf5_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$HDF5_CPPFLAGS $with_hdf5_additional_cppflags $CPPFLAGS"
  CFLAGS="$HDF5_CFLAGS $with_hdf5_additional_cflags $CFLAGS"
  LDFLAGS="$HDF5_LDFLAGS $with_hdf5_additional_ldflags $LDFLAGS"
  LIBS="$HDF5_LIBS $with_hdf5_additional_libs $LIBS"

  AC_MSG_CHECKING([if hdf5 has parallel support])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <H5pubconf.h>
  #ifndef H5_HAVE_PARALLEL
  #error "No parallel support"
  #endif
  int main(int argc, char * argv[]) {
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])
    have_hdf5_parallel=yes

    AC_SUBST([HAVE_HDF5_PARALLEL],[1])
    AC_DEFINE([HAVE_HDF5_PARALLEL],[1],[defined to 1 if parallel hdf5 is available])
  ],
  [
    AC_MSG_RESULT([no])
    have_hdf5_parallel=no
  ])

  AS_IF([test "x$have_hdf5_parallel" == "xyes"],
  [
    AS_IF([test "x$have_mpi" == "xyes"],
    [
      CPPFLAGS="$CPPFLAGS $MPI_CPPFLAGS"
      CFLAGS="$CFLAGS $MPI_CFLAGS"
      LDFLAGS="$LDFLAGS $MPI_LDFLAGS"
      LIBS="$LIBS $MPI_LIBS"
    ],
    [
      AC_MSG_ERROR([hdf5 requires MPI])
    ])
  ])
  
  AC_MSG_CHECKING([if hdf5 is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <hdf5.h>
  int main(int argc, char * argv[]) {
    hid_t file;
    file = H5Fcreate(argv[1], H5F_ACC_TRUNC, H5P_DEFAULT, H5P_DEFAULT);
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])
    have_hdf5=yes

    AC_SUBST([HAVE_HDF5],[1])
    AC_DEFINE([HAVE_HDF5],[1],[defined to 1 if hdf5 is available])

    dnl AC_MSG_NOTICE([HDF5_CPPFLAGS=$HDF5_CPPFLAGS])
    dnl AC_MSG_NOTICE([HDF5_CFLAGS=$HDF5_CFLAGS])
    dnl AC_MSG_NOTICE([HDF5_LDFLAGS=$HDF5_LDFLAGS])
    dnl AC_MSG_NOTICE([HDF5_LIBS=$HDF5_LIBS])
  ],
  [
    AC_MSG_RESULT([no])

    AC_MSG_ERROR([[could not link with hdf5 using:
    HDF5_CPPFLAGS=$HDF5_CPPFLAGS
    HDF5_CFLAGS=$HDF5_CFLAGS
    HDF5_LDFLAGS=$HDF5_LDFLAGS
    HDF5_LIBS=$HDF5_LIBS]])
  ])

  LIBS="$HDF5_HL_LIBS $LIBS"
  AC_MSG_CHECKING([if hdf5 has hl support])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <hdf5_hl.h>
  int main(int argc, char * argv[]) {
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])
    have_hdf5_hl=yes
    AC_SUBST([HAVE_HDF5_HL],[1])
    AC_DEFINE([HAVE_HDF5_HL],[1],[defined to 1 if hdf5_hl is available])

    dnl AC_MSG_NOTICE([HDF5_HL_LIBS=$HDF5_HL_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    have_hdf5_hl=no
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_HDF5],[test "x$have_hdf5" == "xyes"])
AM_CONDITIONAL([HAVE_HDF5_PARALLEL],[test "x$have_hdf5_parallel" == "xyes"])
AM_CONDITIONAL([HAVE_HDF5_HL],[test "x$have_hdf5_hl" == "xyes"])

])
