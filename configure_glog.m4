dnl GLOG is a C++ library. Hence only C++ support is tested.

AC_DEFUN([CONFIGURE_GLOG],[
AC_PREREQ([2.69])

AC_ARG_VAR([GLOG_DIR],[Prefix of glog installation.])
AC_ARG_VAR([GLOG_CPPFLAGS],[C/C++ preprocessor flags for glog.])
AC_ARG_VAR([GLOG_CXXFLAGS],[C++ compilation flags for glog.])
AC_ARG_VAR([GLOG_LDFLAGS],[Linker flags for glog.])
AC_ARG_VAR([GLOG_LIBS],[Link libraries for glog.])

AC_ARG_WITH(
[glog],	
[AS_HELP_STRING([--with-glog=yes/no],
  [Option to enable glog auto discovery, default: no.])],
[],
[with_glog="no"])

AC_ARG_WITH(
[glog-dir],
[AS_HELP_STRING([--with-glog-dir=DIR],
  [Option to enable glog discovery from specific installation prefix.])],
[],
[with_glog_dir=""])

AC_ARG_WITH(
[glog-include-dir],
[AS_HELP_STRING([--with-glog-include-dir=DIR],
  [Option to specify include directory of glog installation.])],
[],
[with_glog_include_dir=""])

AC_ARG_WITH(
[glog-lib-dir],
[AS_HELP_STRING([--with-glog-lib-dir=DIR],
  [Option to specify library directory of glog installation.])],
[],
[with_glog_lib_dir=""])

AC_ARG_WITH(
[glog-libs],
[AS_HELP_STRING([--with-glog-libs=STRING],
  [Option to specify link libraries for using glog.])],
[],
[with_glog_libs=""])

AC_ARG_WITH(
[glog-pkg-config],
[AS_HELP_STRING([--with-glog-pkg-config=PC_SEARCH_STRING],
  [Option to enable glog discovery using pkg-config.])],
[],
[with_glog_pkg_config=""])

AC_ARG_WITH(
[glog-additional-cppflags],
[AS_HELP_STRING([--with-glog-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering glog.])],
[],
[with_glog_additional_cppflags=""])

AC_ARG_WITH(
[glog-additional-cxxflags],
[AS_HELP_STRING([--with-glog-additional-cxxflags=STRING],
  [Option to specify additional compilation flags for discovering glog.])],
[],
[with_glog_additional_cxxflags=""])

AC_ARG_WITH(
[glog-additional-ldflags],
[AS_HELP_STRING([--with-glog-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering glog.])],
[],
[with_glog_additional_ldflags=""])

AC_ARG_WITH(
[glog-additional-libs],
[AS_HELP_STRING([--with-glog-additional-libs=STRING],
  [Option to specify additional link libraries for discovering glog.])],
[],
[with_glog_additional_libs=""])

_glog_config_option="Option"

AS_IF([test "x$with_glog" != "xno"],
[_glog_config_option="Auto$_glog_config_option"])

AS_IF([test -n "$with_glog_dir"],
[_glog_config_option="Dir$_glog_config_option"])

AS_IF([test -n "$with_glog_include_dir" || test -n "$with_glog_lib_dir" || test -n "$with_glog_libs"],
[_glog_config_option="ILDir$_glog_config_option"])

AS_IF([test -n "$with_glog_pkg_config"],
[_glog_config_option="PkgConfig$_glog_config_option"])

AS_IF([test -n "$GLOG_CPPFLAGS" || test -n "$GLOG_CXXFLAGS" || test -n "$GLOG_LDFLAGS" || test -n "$GLOG_LIBS"],
[_glog_config_option="Flags$_glog_config_option"])

AS_CASE(["$_glog_config_option"],
["Option"],
[
  AC_MSG_NOTICE([glog is not requested])
  have_glog="no"
],
["AutoOption"],
[
  AC_MSG_NOTICE([glog will be auto-discovered])

  AS_IF([test -d "$GLOG_DIR/include"],
  [
    AC_MSG_NOTICE([directory $GLOG_DIR/include exists])
    GLOG_CXXFLAGS="-I$GLOG_DIR/include"
  ], [AC_MSG_NOTICE([directory $GLOG_DIR/include does not exist])])

  AS_IF([test -d "$GLOG_DIR/lib"],
  [
    AC_MSG_NOTICE([directory $GLOG_DIR/lib exists])
    GLOG_LDFLAGS="-L$GLOG_DIR/lib"
  ],[AC_MSG_NOTICE([directory $GLOG_DIR/lib does not exist])])

  AS_IF([test -d "$GLOG_DIR/lib64"],
  [
    AC_MSG_NOTICE([directory $GLOG_DIR/lib64 exists])
    GLOG_LDFLAGS="-L$GLOG_DIR/lib64"
  ],[AC_MSG_NOTICE([directory $GLOG_DIR/lib64 does not exist])])

  GLOG_LIBS="-lglog"

  _try_compile_link_glog_sample=yes
],
["DirOption"],
[
  AC_MSG_NOTICE([glog will be discovered via specified installation prefix])

  AS_IF([test -d "$with_glog_dir/include"],
  [
    AC_MSG_NOTICE([directory $with_glog_dir/include exists])
    GLOG_CXXFLAGS="-I$with_glog_dir/include"
  ], [AC_MSG_NOTICE([directory $with_glog_dir/include does not exist])])

  AS_IF([test -d "$with_glog_dir/lib"],
  [
    AC_MSG_NOTICE([directory $with_glog_dir/lib exists])
    GLOG_LDFLAGS="-L$with_glog_dir/lib"
  ],[AC_MSG_NOTICE([directory $with_glog_dir/lib does not exist])])

  AS_IF([test -d "$with_glog_dir/lib64"],
  [
    AC_MSG_NOTICE([directory $with_glog_dir/lib64 exists])
    GLOG_LDFLAGS="-L$with_glog_dir/lib64"
  ],[AC_MSG_NOTICE([directory $with_glog_dir/lib64 does not exist])])

  GLOG_LIBS="-lglog"

  _try_compile_link_glog_sample=yes
],
["ILDirOption"],
[
  AC_MSG_NOTICE([glog will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_glog_include_dir"],
  [
    AC_MSG_NOTICE([directory $with_glog_include_dir exists])
    GLOG_CXXFLAGS="-I$with_glog_include_dir"
  ],
  [AC_MSG_NOTICE([directory $with_glog_include_dir does not exist])])

  AS_IF([test -d "$with_glog_lib_dir"],
  [
    AC_MSG_NOTICE([directory $with_glog_lib_dir exists])
    GLOG_LDFLAGS="-L$with_glog_lib_dir"
  ],
  [AC_MSG_NOTICE([directory $with_glog_lib_dir does not exist])])

  GLOG_LIBS="-lglog"

  _try_compile_link_glog_sample=yes
],
["PkgConfigOption"],
[
  AC_MSG_NOTICE([glog will be discovered via pkg-config])

  _glog_pkg_config_name="libglog"
  AS_IF([test "x$with_glog_pkg_config" != "xyes"],[_glog_pkg_config_name=$with_glog_pkg_config])

  PKG_CHECK_MODULES([GLOG],
  [$_glog_pkg_config_name],
  [
    _try_compile_link_glog_sample=yes
    GLOG_CXXFLAGS=$GLOG_CFLAGS
  ], [AC_MSG_ERROR([pkg-config could not find $_glog_pkg_config_name])])
],
["FlagsOption"],
[
  AC_MSG_NOTICE([glog will be discovered via environment variable flags])

  _try_compile_link_glog_sample=yes
]
[AC_MSG_ERROR([multiple configuration options for glog: $_glog_config_option])]
)

AS_IF([test "x$_try_compile_link_glog_sample" == "xyes"],
[
  AC_LANG_PUSH([C++])

  save_CPPFLAGS="$CPPFLAGS"
  save_CXXFLAGS="$CXXFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$GLOG_CPPFLAGS $with_glog_additional_cppflags $CPPFLAGS"
  CXXFLAGS="$GLOG_CXXFLAGS $with_glog_additional_cxxflags $CXXFLAGS"
  LDFLAGS="$GLOG_LDFLAGS $with_glog_additional_ldflags $with_glog_additional_libs $GLOG_LIBS $LDFLAGS"
  LIBS="$GLOG_LIBS $with_additional_glog_libs $LIBS"
  
  AC_MSG_CHECKING([if glog is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #define GLOG_USE_GLOG_EXPORT
  #include <glog/logging.h>
  int main(int argc, char * argv[]) {
    google::InitGoogleLogging(argv[0]);
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_glog=yes
    AC_SUBST([HAVE_GLOG],[1])

    AC_DEFINE([HAVE_GLOG],[1],[defined to 1 if glog is available])

    AC_MSG_NOTICE([GLOG_CPPFLAGS=$GLOG_CPPFLAGS])
    AC_MSG_NOTICE([GLOG_CXXFLAGS=$GLOG_CXXFLAGS])
    AC_MSG_NOTICE([GLOG_LDFLAGS=$GLOG_LDFLAGS])
    AC_MSG_NOTICE([GLOG_LIBS=$GLOG_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_FAILURE([[Could not link with glog using:
    GLOG_CPPFLAGS=$GLOG_CPPFLAGS
    GLOG_CXXFLAGS=$GLOG_CXXFLAGS
    GLOG_LDFLAGS=$GLOG_LDFLAGS
    GLOG_LIBS=$GLOG_LIBS]])
  ])

  CPPFLAGS=$save_CPPFLAGS
  CXXFLAGS=$save_CXXFLAGS
  LDFLAGS=$save_LDFLAGS
  LIBS=$save_LIBS

  AC_LANG_POP([C++])
])

AM_CONDITIONAL([HAVE_GLOG],[test "x$have_glog" == "xyes"])

])
