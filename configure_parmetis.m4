dnl PARMETIS is a C library. Hence only C support is tested.

AC_DEFUN([CONFIGURE_PARMETIS], [
AC_PREREQ([2.69])

AC_ARG_VAR([PARMETIS_DIR],[Prefix of parmetis installation.])
AC_ARG_VAR([PARMETIS_CPPFLAGS],[C/C++ preprocessor flags for parmetis.])
AC_ARG_VAR([PARMETIS_CFLAGS],[C compilation flags for parmetis.])
AC_ARG_VAR([PARMETIS_LDFLAGS],[Linker flags for parmetis.])
AC_ARG_VAR([PARMETIS_LIBS],[Link libraries for parmetis.])

AC_ARG_WITH([parmetis],
[AS_HELP_STRING([--with-parmetis=yes/no],
  [Option to enable parmetis auto discovery, default: no.])],
[],
[with_parmetis=auto])

AC_ARG_WITH([parmetis-dependencies],
[AS_HELP_STRING([--with-parmetis-dependencies=SS_STRING],
  [Option to specify dependencies of parmetis.])],
[],
[with_parmetis_dependencies=""])

AC_ARG_WITH([parmetis-dir],
[AS_HELP_STRING([--with-parmetis-dir=DIR],
  [Option to enable parmetis discovery from specific installation prefix.])]
[],
[with_parmetis_dir=""])

AC_ARG_WITH([parmetis-include-dir],
[AS_HELP_STRING([--with-parmetis-include-dir=DIR],
  [Option to specify include directory of parmetis installation.])],
[],
[with_parmetis_include_dir=""])

AC_ARG_WITH([parmetis-lib-dir],
[AS_HELP_STRING([--with-parmetis-lib-dir=DIR],
  [Option to specify library directory of parmetis installation.])],
[],
[with_parmetis_lib_dir=""])

AC_ARG_WITH([parmetis-libs],
[AS_HELP_STRING([--with-parmetis-libs=STRING],
  [Option to specify link libraries for using parmetis])],
[],
[with_parmetis_libs=""])

AC_ARG_WITH([parmetis-pkg-config],
[AS_HELP_STRING([--with-parmetis-pkg-config=PC_SEARCH_STRING],
  [Option to specify parmetis discovery using pkg-config.])],
[],
[with_parmetis_pkg_config=""])

AC_ARG_WITH([parmetis-additional-cppflags],
[AS_HELP_STRING([--with-parmetis-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering parmetis.])],
[],
[with_parmetis_additional_cppflags=""])

AC_ARG_WITH([parmetis-additional-cflags],
[AS_HELP_STRING([--with-parmetis-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering parmetis.])],
[],
[with_parmetis_additional_cflags=""])

AC_ARG_WITH([parmetis-additional-ldflags],
[AS_HELP_STRING([--with-parmetis-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering parmetis.])],
[],
[with_parmetis_additional_ldflags=""])

AC_ARG_WITH([parmetis-additional-libs],
[AS_HELP_STRING([--with-parmetis-additional-libs=STRING],
  [Option to specify additional link libraries for discovering parmetis.])],
[],
[with_parmetis_additional_libs=""])

_parmetis_config_option="Option"

AS_IF([test "x$with_parmetis" != "xno"],
[_parmetis_config_option="Auto$_parmetis_config_option"])

AS_IF([test -n "$with_parmetis_dir"],
[_parmetis_config_option="Dir$_parmetis_config_option"])

AS_IF([test -n "$with_parmetis_include_dir" || test -n "$with_parmetis_lib_dir" || test -n "$with_parmetis_libs"],
[_parmetis_config_option="ILDir$_parmetis_config_option"])

AS_IF([test -n "$with_parmetis_pkg_config"],
[_parmetis_config_option="PkgConfig$_parmetis_config_option"])

AS_IF([test -n "$PARMETIS_CPPFLAGS" || test -n "$PARMETIS_CFLAGS" || test -n "$PARMETIS_LDFLAGS" || test "$PARMETIS_LIBS"],
[_parmetis_config_option="Flags$_parmetis_config_option"])

AS_CASE(["$_parmetis_config_option"],
["Option"],
[
  AC_MSG_NOTICE([parmetis is not requested])
  have_parmetis="no"
],
["AutoOption"],
[
  AC_MSG_NOTICE([parmetis will be auto-discovered])

  AS_IF([test -z "$PARMETIS_DIR"],
  [
    AC_PATH_PROGS([_parmetis_bin_path],
    [parmetis pm_parmetis pometis pm_pometis],
    [notfound])

    AS_IF([test "x$_parmetis_bin_path" != "xnotfound"],
    [
      PARMETIS_DIR=`AS_DIRNAME([$_parmetis_bin_path])`
      PARMETIS_DIR=`AS_DIRNAME([$PARMETIS_DIR])`
    ])
  ])

  AS_IF([test -d "$PARMETIS_DIR/include"],
  [
    AC_MSG_NOTICE([directory $PARMETIS_DIR/include exists])
    PARMETIS_CFLAGS="-I$PARMETIS_DIR/include"
  ], [AC_MSG_NOTICE([directory $PARMETIS_DIR/include does not exist])])

  AS_IF([test -d "$PARMETIS_DIR/lib"],
  [
    AC_MSG_NOTICE([directory $PARMETIS_DIR/lib exists])
    PARMETIS_LDFLAGS="-L$PARMETIS_DIR/lib"
    PARMETIS_LIBS="-lparmetis"
  ], [AC_MSG_NOTICE([directory $PARMETIS_DIR/lib does not exist])])

  AS_IF([test -d "$PARMETIS_DIR/lib64"],
  [
    AC_MSG_NOTICE([directory $PARMETIS_DIR/lib64 exists])
    PARMETIS_LDFLAGS="-L$PARMETIS_DIR/lib64"
    PARMETIS_LIBS="-lparmetis"
  ], [AC_MSG_NOTICE([directory $PARMETIS_DIR/lib64 does not exist])])

  _try_compile_link_parmetis_sample=yes
],
["DirOption"],
[
  AC_MSG_NOTICE([parmetis will be discovered via specific installation prefix])

  AS_IF([test -d "$with_parmetis_dir/include"],
  [
    AC_MSG_NOTICE([directory $with_parmetis_dir/include exists])
    PARMETIS_CFLAGS="-I$with_parmetis_dir/include"
  ], [AC_MSG_NOTICE([directory $with_parmetis_dir/include does not exist])])

  AS_IF([test -d "$with_parmetis_dir/lib"],
  [
    AC_MSG_NOTICE([directory $with_parmetis_dir/lib exists])
    PARMETIS_LDFLAGS="-L$with_parmetis_dir/lib"
    PARMETIS_LIBS="-lparmetis"
  ], [AC_MSG_NOTICE([directory $with_parmetis_dir/lib does not exist])])

  AS_IF([test -d "$with_parmetis_dir/lib64"],
  [
    AC_MSG_NOTICE([directory $with_parmetis_dir/lib64 exists])
    PARMETIS_LDFLAGS="-L$with_parmetis_dir/lib64"
    PARMETIS_LIBS="-lparmetis"
  ], [AC_MSG_NOTICE([directory $with_parmetis_dir/lib64 does not exist])])

  _try_compile_link_parmetis_sample=yes
],
["ILDirOption"],
[
  AC_MSG_NOTICE([parmetis will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_parmetis_include_dir"],
  [
    AC_MSG_NOTICE([directory $with_parmetis_include_dir exists])
    PARMETS_CFLAGS="-I$with_parmetis_include_dir"
  ], [AC_MSG_NOTICE([directory $with_parmetis_include_dir does not exist])])

  AS_IF([test -d "$with_parmetis_lib_dir"],
  [
    AC_MSG_NOTICE([directory $with_parmetis_lib_dir exists])
    PARMETIS_LDFLAGS="-L$with_parmetis_lib_dir"
  ], [AC_MSG_NOTICE([directory $with_parmetis_lib_dir does not exist])])

  PARMETIS_LIBS="$with_parmetis_libs"

  _try_compile_link_parmetis_sample=yes
],
["PkgConfigOption"],
[
  AC_MSG_NOTICE([parmetis will be discovered via pkg-config])

  _parmetis_pkg_config_name="parmetis"
  AS_IF([test "x$with_parmetis_pkg_config" != xyes],[_parmetis_pkg_config_name=$with_parmetis_pkg_config])

  PKG_CHECK_MODULES([PARMETIS],
  [$_parmetis_pkg_config_name],
  [_try_compile_link_parmetis_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_parmetis_pkg_config_name])])
],
["FlagsOption"],
[
  AC_MSG_NOTICE([parmetis will be discovered via environment variable flags])
  _try_compile_link_parmetis_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for parmetis: $_parmetis_config_option])]
)

dnl m4_define([_parmetis_deps],m4_dquote(m4_split(["$with_parmetis_dependencies"])))

dnl _parmetis_dep_counter="1"
dnl m4_foreach_w([_parmetis_dep],[_parmetis_deps],[
dnl   AC_MSG_NOTICE([$_parmetis_dep_counter=_parmetis_dep])
dnl   _parmetis_dep_counter="1$_parmetis_dep_counter"
dnl ])

dnl _parmetis_deps=m4_split($with_parmetis_dependencies)
dnl AC_MSG_ERROR($with_parmetis_dependencies)
dnl m4_foreach(_parmetis_dep,_parmetis_deps,[
dnl   AC_MSG_NOTICE(_parmetis_dep)
dnl ])
dnl AC_MSG_ERROR([])

AS_IF([test "x$_try_compile_link_parmetis_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$PARMETIS_CPPFLAGS $with_parmetis_additional_cppflags $CPPFLAGS"
  CFLAGS="$PARMETIS_CFLAGS $with_parmetis_additional_cflags $CFLAGS"
  LDFLAGS="$PARMETIS_LDFLAGS $with_parmetis_additional_ldflags $LDFLAGS"
  LIBS="$PARMETIS_LIBS $with_parmetis_additional_libs $LIBS"

  AC_MSG_CHECKING([if parmetis is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <parmetis.h>
  int main(int argc, char * argv[]) {
    MPI_Comm comm = MPI_COMM_WORLD;
    idx_t *vtxdist;
    idx_t *xadj;
    idx_t *adjncy;
    idx_t *vwgt;
    idx_t *adjwgt;
    idx_t *wgtflag;
    idx_t *numflag;
    idx_t *ncon;
    idx_t *nparts;
    real_t *tpwgts;
    real_t *ubvec;
    idx_t *options;
    idx_t *edgecut;
    idx_t *part;

    ParMETIS_V3_PartKway(
      vtxdist, xadj, adjncy, vwgt, adjwgt, wgtflag, numflag, ncon,
      nparts, tpwgts, ubvec, options, edgecut, part, &comm
    );
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_parmetis=yes
    AC_SUBST([HAVE_PARMETIS],[1])

    AC_DEFINE([HAVE_PARMETIS],[1],[defined to 1 if parmetis is available])

    AC_MSG_NOTICE([PARMETIS_CPPFLAGS=$PARMETIS_CPPFLAGS])
    AC_MSG_NOTICE([PARMETIS_CFLAGS=$PARMETIS_CFLAGS])
    AC_MSG_NOTICE([PARMETIS_LDFLAGS=$PARMETIS_LDFLAGS])
    AC_MSG_NOTICE([PARMETIS_LIBS=$PARMETIS_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_FAILURE([[could not link with parmetis using:
    PARMETIS_CPPFLAGS=$PARMETIS_CPPFLAGS
    PARMETIS_CFLAGS=$PARMETIS_CFLAGS
    PARMETIS_LDFLAGS=$PARMETIS_LDFLAGS
    PARMETIS_LIBS=$PARMETIS_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_PARMETIS],[test "x$have_parmetis" == "xyes"])

])
