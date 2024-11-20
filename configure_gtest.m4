dnl GTEST os a C++ library. Hence, only C++ support is tested.

AC_DEFUN([CONFIGURE_GTEST],[
AC_PREREQ(2.69)

AC_ARG_VAR([GTEST_DIR],[Prefix of gtest installation.])
AC_ARG_VAR([GTEST_CPPFLAGS],[C/C++ preprocessor flags for gtest.])
AC_ARG_VAR([GTEST_CXXFLAGS],[C++ compilation flags for gtest.])
AC_ARG_VAR([GTEST_LDFLAGS],[Linker flags for gtest.])
AC_ARG_VAR([GTEST_LIBS],[Link libraries for gtest.])

AC_ARG_WITH([gtest],
[AS_HELP_STRING([--with-gtest=yes/no],
  [Option to enable gtest auto discovery, default: no.])],
[],
[with_gtest=no])

AC_ARG_WITH([gtest-dir],
[AS_HELP_STRING([--with-gtest-dir=DIR],
  [Option to enable gtest discovery from specific installation prefix.])],
[],
[with_gtest_dir=""])

AC_ARG_WITH([gtest-include-dir],
[AS_HELP_STRING([--with-gtest-include-dir=DIR],
  [Option to specify include directory of gtest installation.])],
[],
[with_gtest_include_dir=""])

AC_ARG_WITH([gtest-lib-dir],
[AS_HELP_STRING([--with-gtest-lib-dir=DIR],
  [Option to specify library directory of gtest installation.])],
[],
[with_gtest_lib_dir=""])

AC_ARG_WITH([gtest-libs],
[AS_HELP_STRING([--with-gtest-libs=STRING],
  [Option to specify link libraries for using gtest.])],
[],
[with_gtest_libs=""])

AC_ARG_WITH([gtest-pkg-config],
[AS_HELP_STRING([--with-gtest-pkg-config=PC_SEARCH_STRING],
  [Option to enable gtest discovery using pkg-config.])],
[],
[with_gtest_pkg_config=""])

AC_ARG_WITH([gtest-additional-cppflags],
[AS_HELP_STRING([--with-gtest-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering gtest.])],
[],
[with_gtest_additional_cppflags=""])

AC_ARG_WITH([gtest-additional-cflags],
[AS_HELP_STRING([--with-gtest-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering gtest.])],
[],
[with_gtest_additional_cflags=""])

AC_ARG_WITH([gtest-additional-ldflags],
[AS_HELP_STRING([--with-gtest-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering gtest.])],
[],
[with_gtest_additional_ldflags=""])

AC_ARG_WITH([gtest-additional-libs],
[AS_HELP_STRING([--with-gtest-additional-libs=STRING],
  [Option to specify additional link libraries for discovering gtest.])],
[],
[with_gtest_additional_libs=""])

_gtest_config_option="Option"

AS_IF([test "x$with_gtest" != "xno"],
[_gtest_config_option="Auto$_gtest_config_option"])

AS_IF([test -n "$with_gtest_dir"],
[_gtest_config_option="Dir$_gtest_config_option"])

AS_IF([test -n "$with_gtest_include_dir" || test -n "$with_gtest_lib_dir" || test -n "$with_gtest_libs"],
[_gtest_config_option="ILDir$_gtest_config_option"])

AS_IF([test -n "$with_gtest_pkg_config"],
[_gtest_config_option="PkgConfig$_gtest_config_option"])

AS_IF([test -n "$GTEST_CPPFLAGS" || test -n "$GTEST_CXXFLAGS" || test -n "$GTEST_LDFLAGS" || test -n "$GTEST_LIBS"],
[_gtest_config_option="Flags$_gtest_config_option"])

AS_CASE(["$_gtest_config_option"],
["Option"],
[
  AC_MSG_NOTICE([gtest is not requested])
  have_gtest=no
],
["AutoOption"],
[
  dnl AC_MSG_NOTICE([gtest will be auto-discovered])

  AS_IF([test -d "$GTEST_DIR/include"],
  [
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/include exists])
    GTEST_CXXFLAGS="-I$GTEST_DIR/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/include does not exist])
  ])

  AS_IF([test -d "$GTEST_DIR/lib"],
  [
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/lib exists])
    GTEST_LDFLAGS="-L$GTEST_DIR/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/lib does not exist])
  ])

  AS_IF([test -d "$GTEST_DIR/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/lib64 exists])
    GTEST_LDFLAGS="-L$GTEST_DIR/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $GTEST_DIR/lib64 does not exist])
  ])

  GTEST_LIBS="-lgtest"

  _try_compile_link_gtest_sample=yes
],
["DirOption"],
[
  dnl AC_MSG_NOTICE([gtest will be discovered via specified installation prefix])

  AS_IF([test -d "$with_gtest_dir/include"],
  [
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/include exists])
    GTEST_CXXFLAGS="-I$with_gtest_dir/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/include does not exist])
  ])

  AS_IF([test -d "$with_gtest_dir/lib"],
  [
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/lib exists])
    GTEST_LDFLAGS="-L$with_gtest_dir/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/lib does not exist])
  ])

  AS_IF([test -d "$with_gtest_dir/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/lib64 exists])
    GTEST_LDFLAGS="-L$with_gtest_dir/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_gtest_dir/lib64 does not exist])
  ])

  GTEST_LIBS="-lgtest"

  _try_compile_link_gtest_sample=yes
],
["ILDirOption"],
[
  dnl AC_MSG_NOTICE([gtest will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_gtest_include_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_gtest_include_dir exists])
    GTEST_CXXFLAGS="-I$with_gtest_include_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_gtest_include_dir does not exist])
  ])

  AS_IF([test -d "$with_gtest_lib_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_gtest_lib_dir exists])
    GTEST_LDFLAGS="-I$with_gtest_lib_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_gtest_lib_dir does not exist])
  ])

  GTEST_LIBS="$with_gtest_libs"

  _try_compile_link_gtest_sample=yes
],
["PkgConfigOption"],
[
  dnl AC_MSG_NOTICE([gtest will be discovered via pkg-config])

  _gtest_pkg_config_name="gtest"
  AS_IF([test "$with_gtest_pkg_config" != "xyes"],[_gtest_pkg_config_name="$with_gtest_pkg_config"])

  PKG_CHECK_MODULES([GTEST],
  [$_gtest_pkg_config_name],
  [
    GTEST_CXXFLAGS="$GTEST_CFLAGS"
    _try_compile_link_gtest_sample=yes
  ], [AC_MSG_ERROR([pkg-config could not find $_gtest_pkg_config_name])])
],
["FlagsOption"],
[
  dnl AC_MSG_NOTICE([gtest will be discovered via environment variable flags])
  _try_compile_link_gtest_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for gtest: $_gtest_config_option])]
)

AS_IF([test "x$_try_compile_link_gtest_sample" == "xyes"],
[
  AC_LANG_PUSH([C++])

  save_CPPFLAGS="$CPPFLAGS"
  save_CXXFLAGS="$CXXFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$GTEST_CPPFLAGS $with_gtest_additional_cppflags $CPPFLAGS"
  CXXFLAGS="$GTEST_CXXFLAGS $with_gtest_additional_cxxflags $CXXFLAGS"
  LDFLAGS="$GTEST_LDFLAGS $with_gtest_additional_ldflags $LDFLAGS"
  LIBS="$GTEST_LIBS $with_gtest_additional_libs $LIBS"

  AC_MSG_CHECKING([if gtest is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <gtest/gtest.h>
  int main(int argc, char * argv[]) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_gtest=yes
    AC_SUBST([HAVE_GTEST],[1])

    AC_DEFINE([HAVE_GTEST],[1],[defined to 1 if gtest is available])

    dnl AC_MSG_NOTICE([GTEST_CPPFLAGS=$GTEST_CPPFLAGS])
    dnl AC_MSG_NOTICE([GTEST_CXXFLAGS=$GTEST_CXXFLAGS])
    dnl AC_MSG_NOTICE([GTEST_LDFLAGS=$GTEST_LDFLAGS])
    dnl AC_MSG_NOTICE([GTEST_LIBS=$GTEST_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_ERROR([[Could not link with gtest using:
    GTEST_CPPFLAGS=$GTEST_CPPFLAGS
    GTEST_CXXFLAGS=$GTEST_CXXFLAGS
    GTEST_LDFLAGS=$GTEST_LDFLAGS
    GTEST_LIBS=$GTEST_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CXXFLAGS="$save_CXXFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C++])
])

AM_CONDITIONAL([HAVE_GTEST],[test "x$have_gtest" = "xyes"])

])
