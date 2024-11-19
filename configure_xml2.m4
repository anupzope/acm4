AC_DEFUN([CONFIGURE_XML2], [
AC_PREREQ([2.69])

AC_ARG_VAR([XML2_DIR],[Prefix of libxml2 installation.])
AC_ARG_VAR([XML2_CPPFLAGS],[C/C++ preprocessor flags for libxml2.])
AC_ARG_VAR([XML2_CFLAGS],[C compilation flags for libxml2.])
AC_ARG_VAR([XML2_LDFLAGS],[Linker flags for libxml2.])
AC_ARG_VAR([XML2_LIBS],[Link libraries for libxml2.])

AC_ARG_WITH([xml2],
[AS_HELP_STRING([--with-xml2=yes/no],
  [Option to enable xml2 auto discovery, default: no.])],
[],
[with_xml2=no])

AC_ARG_WITH([xml2-dir],
[AS_HELP_STRING([--with-xml2-dir=DIR],
  [Option to enable xml2 discovery from specific installation prefix.])],
[],
[with_xml2_dir=""])

AC_ARG_WITH([xml2-include-dir],
[AS_HELP_STRING([--with-xml2-include-dir=DIR],
  [Option to specify include directory of xml2 installation.])],
[],
[with_xml2_include_dir=""])

AC_ARG_WITH([xml2-lib-dir],
[AS_HELP_STRING([--with-xml2-lib-dir=DIR],
  [Option to specify libraru directiry of xml2 installation.])],
[],
[with_xml2_lib_dir=""])

AC_ARG_WITH([xml2-libs],
[AS_HELP_STRING([--with-xml2-libs=STRING],
  [Option to specify link libraries for using xml2.])],
[],
[with_xml2_libs=""])

AC_ARG_WITH([xml2-pkg-config],
[AS_HELP_STRING([--with-xml2-pkg-config=PC_SEARCH_STRING],
  [Option to enable xml2 discovery using pkg-config.])],
[],
[with_xml2_pkg_config=""])

AC_ARG_WITH([xml2-additional-cppflags],
[AS_HELP_STRING([--with-xml2-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering xml2.])],
[],
[with_xml2_additional_cppflags=""])

AC_ARG_WITH([xml2-additional-cflags],
[AS_HELP_STRING([--with-xml2-additional-cflags=STRING],
  [Option to specify additional compilation flags for discovering xml2.])],
[],
[with_xml2_additional_cflags=""])

AC_ARG_WITH([xml2-additional-ldflags],
[AS_HELP_STRING([--with-xml2-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering xml2.])],
[],
[with_xml2_additional_ldflags=""])

AC_ARG_WITH([xml2-additional-libs],
[AS_HELP_STRING([--with-xml2-additional-libs=STRING],
  [Option to specify additional link libraries for discovering xml2.])],
[],
[with_xml2_additional_libs=""])

_xml2_config_option="Option"

AS_IF([test "x$with_xml2" != "xno"],
[_xml2_config_option="Auto$_xml2_config_option"])

AS_IF([test -n "$with_xml2_dir"],
[_xml2_config_option="Dir$_xml2_config_option"])

AS_IF([test -n "$with_xml2_include_dir" || test -n "$with_xml2_lib_dir" || test -n "$with_xml2_libs"],
[_xml2_config_option="ILDir$_xml2_config_option"])

AS_IF([test -n "$with_xml2_pkg_config"],
[_xml2_config_option="PkgConfig$_xml2_config_option"])

AS_IF([test -n "$XML2_CPPFLAGS" || test -n "$XML2_CFLAGS" || test -n "$XML2_LDFLAGS" || test -n "$XML2_LIBS"],
[_xml2_config_option="Flags$_xml2_config_option"])

AS_CASE(["$_xml2_config_option"],
["Option"],
[
  AC_MSG_NOTICE([xml2 is not requested])
  have_xml2=no
],
["AutoOption"],
[
  AC_MSG_NOTICE([xml2 will be auto-discovered])

  AS_IF([test -z "$XML2_DIR"],
  [
    AC_PATH_PROGS([_xml2_bin_path],
    [xmllint],
    [notfound])

    AS_IF([test "x$_xml2_bin_path" != "xnotfound"],
    [
      XML2_DIR=`AS_DIRNAME(["$_xml2_bin_path"])`
      XML2_DIR=`AS_DIRNAME(["$XML2_DIR"])`
    ])
  ])

  AS_IF([test -d "$XML2_DIR/include"],
  [
    AC_MSG_NOTICE([directory $XML2_DIR/include exists])
    XML2_CFLAGS="-I$XML2_DIR/include"
  ], [AC_MSG_NOTICE([directory $XML2_DIR/include does not exist])])

  AS_IF([test -d "$XML2_DIR/lib"],
  [
    AC_MSG_NOTICE([directory $XML2_DIR/lib exists])
    XML2_LDFLAGS="-L$XML2_DIR/lib"
  ], [AC_MSG_NOTICE([directory $XML2_DIR/lib does not exist])])

  AS_IF([test -d "$XML2_DIR/lib64"],
  [
    AC_MSG_NOTICE([directory $XML2_DIR/lib64 exists])
    XML2_LDFLAGS="-L$XML2_DIR/lib64"
  ], [AC_MSG_NOTICE([directory $XML2_DIR/lib64 does not exist])])

  XML2_LIBS="-lxml2"

  _try_compile_link_xml2_sample=yes
],
["DirOption"],
[
  AC_MSG_NOTICE([xml2 will be discovered via specified installation prefix])

  AS_IF([test -d "$with_xml2_dir/include"],
  [
    AC_MSG_NOTICE([directory $with_xml2_dir/include exists])
    XML2_CFLAGS="-I$with_xml2_dir/include"
  ], [AC_MSG_NOTICE([directory $with_xml2_dir/include does not exist])])

  AS_IF([test -d "$with_xml2_dir/lib"],
  [
    AC_MSG_NOTICE([directory $with_xml2_dir/lib exists])
    XML2_LDFLAGS="-L$with_xml2_dir/lib"
  ], [AC_MSG_NOTICE([directory $with_xml2_dir/lib does not exist])])

  AS_IF([test -d "$with_xml2_dir/lib64"],
  [
    AC_MSG_NOTICE([directory $with_xml2_dir/lib64 exists])
    XML2_LDFLAGS="-L$with_xml2_dir/lib64"
  ], [AC_MSG_NOTICE([directory $with_xml2_dir/lib64 does not exist])])

  XML2_LIBS="-lxml2"

  _try_compile_link_xml2_sample=yes
],
["ILDirOption"],
[
  AC_MSG_NOTICE([xml2 will be discovered via specified include and lib directories])

  AS_IF([test -d "$with_xml2_include_dir"],
  [
    AC_MSG_NOTICE([directory $with_xml2_include_dir exists])
    XML2_CFLAGS="-I$with_xml2_include_dir"
  ], [AC_MSG_NOTICE([directory $with_xml2_include_dir does not exist])])

  AS_IF([test -d "$with_xml2_lib_dir"],
  [
    AC_MSG_NOTICE([directory $with_xml2_lib_dir exists])
    XML2_LDFLAGS="-L$with_xml2_lib_dir"
  ], [AC_MSG_NOTICE([directory $with_xml2_lib_dir does not exist])])

  XML2_LIBS="$with_xml2_libs"

  _try_compile_link_xml2_sample=yes
],
["PkgConfigOption"],
[
  AC_MSG_NOTICE([xml2 will be discovered via pkg-config])

  _xml2_pkg_config_name="libxml-2.0"
  AS_IF([test "x$with_xml2_pkg_config" != "xyes"],[_xml2_pkg_config_name=$with_xml2_pkg_config])

  PKG_CHECK_MODULES([XML2],
  [$_xml2_pkg_config_name],
  [_try_compile_link_xml2_sample=yes],
  [AC_MSG_ERROR([pkg-config could not find $_xml2_pkg_config_name])])
],
["FlagsOption"],
[
  AC_MSG_NOTICE([xml2 will be discovered via environment variable flags])

  _try_compile_link_xml2_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for xml2: $_xml2_config_option])])

AS_IF([test "x$_try_compile_link_xml2_sample" == "xyes"],
[
  AC_LANG_PUSH([C])

  save_CPPFLAGS="$CPPFLAGS"
  save_CFLAGS="$CFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  CPPFLAGS="$XML2_CPPFLAGS $with_xml2_additional_cppflags $CPPFLAGS"
  CFLAGS="$XML2_CFLAGS $with_xml2_additional_cflags $CFLAGS"
  LDFLAGS="$XML2_LDFLAGS $with_xml2_additional_ldflags $LDFLAGS"
  LIBS="$XML2_LIBS $with_xml2_additional_libs $LIBS"

  AC_MSG_CHECKING([if xml2 is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <libxml/xmlversion.h>
  int main(int argc, char * argv[]) {
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])

    have_xml2=yes
    AC_SUBST([HAVE_XML2],[1])

    AC_DEFINE([HAVE_XML2],[1],[defined to 1 if xml2 is available])

    AC_MSG_NOTICE([XML2_CPPFLAGS=$XML2_CPPFLAGS])
    AC_MSG_NOTICE([XML2_CFLAGS=$XML2_CFLAGS])
    AC_MSG_NOTICE([XML2_LDFLAGS=$XML2_LDFLAGS])
    AC_MSG_NOTICE([XML2_LIBS=$XML2_LIBS])
  ],
  [
    AC_MSG_RESULT([no])
    AC_MSG_FAILURE([[Could not link xml2 with:
    XML2_CPPFLAGS=$XML2_CPPFLAGS
    XML2_CFLAGS=$XML2_CFLAGS
    XML2_LDFLAGS=$XML2_LDFLAGS
    XML2_LIBS=$XML2_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CFLAGS="$save_CFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C])
])

AM_CONDITIONAL([HAVE_XML2],[test "x$have_xml2" == "xyes"])

])
