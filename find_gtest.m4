dnl Version 1.0

AC_DEFUN([FIND_GTEST],[

dnl ######################
dnl Command line arguments
dnl ######################
AC_ARG_WITH([gtest],
[AS_HELP_STRING([--with-gtest],[find gtest])],
[],[with_gtest=yes])

dnl ##################
dnl Precious variables
dnl ##################
AC_ARG_VAR([GTEST_CPPFLAGS],[C++ preprocessor flags for gtest])
AC_ARG_VAR([GTEST_CXXFLAGS],[C++ compilation flags for gtest])
AC_ARG_VAR([GTEST_LDFLAGS],[Linker flags for gtest])
AC_ARG_VAR([GTEST_LIBS],[Link libraries for gtest])

AS_IF([test "x$with_gtest" = "xyes"],[
AC_LANG_PUSH([C++])

dnl ################
dnl Test compilation
dnl ################
_find_gtest_SAVE_CPPFLAGS="$CPPFLAGS"
CPPFLAGS="$GTEST_CPPFLAGS $CPPFLAGS"

_find_gtest_SAVE_CXXFLAGS="$CXXFLAGS"
CXXFLAGS="$GTEST_CXXFLAGS $CXXFLAGS"

AC_CHECK_HEADERS([gtest/gtest.h])

AS_IF([test "x$ac_cv_header_gtest_gtest_h" != "xyes"],
[CPPFLAGS="$_find_gtest_SAVE_CPPFLAGS"
CXXFLAGS="$_find_gtest_SAVE_CXXFLAGS"])

dnl ############
dnl Test linking
dnl ############
_find_gtest_SAVE_LDFLAGS="$LDFLAGS"
AS_IF([test -n "$GTEST_LDFLAGS"],
[LDFLAGS="$GTEST_LDFLAGS $LDFLAGS"])

_find_gtest_SAVE_LIBS="$LIBS"
AS_IF([test -n "$GTEST_LIBS"],
[LIBS="$GTEST_LIBS $LIBS"],
[GTEST_LIBS="-lgtest"
LIBS="$GTEST_LIBS $LIBS"])

AC_CACHE_CHECK([for testing::InitGoogleTest in $GTEST_LIBS],
[ac_cv_lib_gtest_testing_InitGoogleTest],
[AC_LINK_IFELSE([AC_LANG_SOURCE([
#ifdef HAVE_GTEST_GTEST_H
#include <gtest/gtest.h>
#endif
int main(int argc, char ** argv) {
  testing::InitGoogleTest(&argc, argv);
  return RUN_ALL_TESTS();
}
])],[ac_cv_lib_gtest_testing_InitGoogleTest=yes],
[ac_cv_lib_gtest_testing_InitGoogleTest=no])])

AS_IF([test "x$ac_cv_lib_gtest_testing_InitGoogleTest" = "xyes"],
[AC_DEFINE([HAVE_LIBGTEST],[1],[set to 1 if gtest library is found])],
[LDFLAGS="${_find_gtest_SAVE_LDFLAGS}"
LIBS="${_find_gtest_SAVE_LIBS}"])

dnl #############################################
dnl Consolidate result of compilation and linking
dnl #############################################
AS_IF([test "x$ac_cv_header_gtest_gtest_h" = "xyes" &&
test "x$ac_cv_lib_gtest_testing_InitGoogleTest" = "xyes"],
[have_gtest=yes])

AC_LANG_POP()
])

dnl ##################################
dnl Generate conditionals for automake
dnl ##################################
AM_CONDITIONAL([HAVE_GTEST],[test "x$have_gtest" = "xyes"])

])
