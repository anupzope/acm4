dnl Loci is a C++ library.

AC_DEFUN([CONFIGURE_LOCI], [
AC_PREREQ([2.69])

AC_ARG_VAR([LOCI_BASE],[Prefix of Loci installation.])
AC_ARG_VAR([LPP],[Path to Loci preprocessor.])
AC_ARG_VAR([LOCI_LIBS],[Loci libraries])
AC_ARG_VAR([LOCI_LDFLAGS],[Loci link flags])
AC_ARG_VAR([LOCI_CXXFLAGS],[Loci C++ compilation flags])
AC_ARG_VAR([LOCI_CPPFLAGS],[Loci preprocessor flags])

AC_ARG_WITH([loci],
[AS_HELP_STRING([--with-loci],
  [Option to enable Loci auto discovery, default: no.])],
[],
[with_loci=no])

AC_ARG_WITH([loci-dir],
[AS_HELP_STRING([--with-loci-dir=DIR],
  [Option to enable Loci discovery from a specified installation prefix.])],
[],
[with_loci_dir=""])

AC_ARG_WITH([loci-bin-dir],
[AS_HELP_STRING([--with-loci-bin-dir=DIR],
  [Option to specify binary directory of Loci installation.])],
[],
[with_loci_bin_dir=""])

AC_ARG_WITH([loci-include-dir],
[AS_HELP_STRING([--with-loci-include-dir=DIR],
  [Option to specify include directory of Loci installation.])],
[],
[with_loci_include_dir=""])

AC_ARG_WITH([loci-lib-dir],
[AS_HELP_STRING([--with-loci-lib-dir=DIR],
  [Option to specify library directory of Loci installation.])],
[],
[with_loci_lib_dir=""])

AC_ARG_WITH([loci-libs],
[AS_HELP_STRING([--with-loci-libs=STRING],
  [Option to specify link libraries for using Loci.])],
[],
[with_loci_libs=""])

AC_ARG_WITH([loci-pkg-config],
[AS_HELP_STRING([--with-loci-pkg-config=PC_SEARCH_STRING],
  [Option to enable Loci discovery using pkg-config.])],
[],
[with_loci_pkg_config=""])

AC_ARG_WITH([loci-additional-cppflags],
[AS_HELP_STRING([--with-loci-additional-cppflags=STRING],
  [Option to specify additional preprocessor flags for discovering Loci.])],
[],
[with_loci_additional_cppflags=""])

AC_ARG_WITH([loci-additional-cxxflags],
[AS_HELP_STRING([--with-loci-additional-cxxflags=STRING],
  [Option to specify additional compilation flags for discovering Loci.])],
[],
[with_loci_additional_cxxflags=""])

AC_ARG_WITH([loci-additional-ldflags],
[AS_HELP_STRING([--with-loci-additional-ldflags=STRING],
  [Option to specify additional linker flags for discovering Loci.])],
[],
[with_loci_additional_ldflags=""])

AC_ARG_WITH([loci-additional-libs],
[AS_HELP_STRING([--with-loci-additional-libs=STRING],
  [Option to specify additional link libraries for discovering Loci.])],
[],
[with_loci_additional_libs=""])

_loci_config_option="Option"

AS_IF([test "x$with_loci" != "xno"],
[_loci_config_option="Auto$_loci_config_option"])

AS_IF([test -n "$with_loci_dir"],
[_loci_config_option="Dir$_loci_config_option"])

AS_IF([test -n "$with_loci_bin_dir" || test -n "$with_loci_include_dir" || test -n "$with_loci_lib_dir" || test -n "$with_loci_libs"],
[_loci_config_option="ILDir$_loci_config_option"])

AS_IF([test -n "$with_loci_pkg_config"],
[_loci_config_option="PkgConfig$_loci_config_option"])

AS_IF([test -n "$LOCI_CPPFLAGS" || test -n "$LOCI_CXXFLAGS" || test -n "$LOCI_LDFLAGS" || test -n "$LOCI_LIBS"],
[_loci_config_option="Flags$_loci_config_option"])

AS_CASE(["$_loci_config_option"],
["Option"],
[
  AC_MSG_NOTICE([Loci not requested])
  have_loci=no
],
["AutoOption"],
[
  dnl AC_MSG_NOTICE([Loci will be auto-discovered])

  AS_IF([test -z "$LOCI_BASE"],
  [
    AC_PATH_PROGS([_loci_bin_path],
    [lpp extract vogmerge refmesh plot3d2vog ccm2vog cgns2vog msh2vog fluent2vog],
    [notfound])

    AS_IF([test "x$_loci_bin_path" != "xnotfound"],
    [
      LOCI_BASE=`AS_DIRNAME(["$_loci_bin_path"])`
      LOCI_BASE=`AS_DIRNAME(["$LOCI_BASE"])`
    ])
  ])

  AC_PATH_PROG([lpp],[lpp],[notfound],[$LOCI_BASE/bin:$PATH])
  AS_IF([test "x$ac_cv_path_lpp" == "xnotfound"],
  [AC_MSG_ERROR([lpp not found])],[LPP="$ac_cv_path_lpp"])

  AS_IF([test -d "$LOCI_BASE/include"],
  [
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/include exists])
    LOCI_CXXFLAGS="-I$LOCI_BASE/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/include does not exist])
  ])

  AS_IF([test -d "$LOCI_BASE/lib"],
  [
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/lib exists])
    LOCI_LDFLAGS="-L$LOCI_BASE/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/lib does not exist])
  ])

  AS_IF([test -d "$LOCI_BASE/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/lib64 exists])
    LOCI_LDFLAGS="-L$LOCI_BASE/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $LOCI_BASE/lib64 does not exist])
  ])

  LOCI_LIBS="-lLoci -lTools -lsprng"

  _try_compile_link_loci_sample=yes
],
["DirOption"],
[
  dnl AC_MSG_NOTICE([Loocing for Loci in directory $with_loci_dir])

  AC_PATH_PROGS([_loci_bin_path],
  [lpp extract vogmerge refmesh plot3d2vog ccm2vog cgns2vog msh2vog fluent2vog],
  [notfound],[$with_loci_dir:$with_loci_dir/bin])

  AC_PATH_PROG([lpp],[lpp],[notfound],[$with_loci_dir/bin:$PATH])
  AS_IF([test "x$ac_cv_path_lpp" == "xnotfound"],
  [AC_MSG_ERROR([lpp not found])],[LPP="$ac_cv_path_lpp"])

  AS_IF([test "x$_loci_bin_path" == "xnotfound"],
  [
    :
    AC_MSG_NOTICE([could not find Loci tools in $with_loci_dir])
  ])

  AS_IF([test -d "$with_loci_dir/include"],
  [
    dnl AC_MSG_NOTICE([directory $with_loci_dir/include exists])
    LOCI_CXXFLAGS="-I$with_loci_dir/include"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_loci_dir/include does not exist])
  ])

  AS_IF([test -d "$with_loci_dir/lib"],
  [
    dnl AC_MSG_NOTICE([directory $with_loci_dir/lib exists])
    LOCI_LDFLAGS="-L$with_loci_dir/lib"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_loci_dir/lib does not exist])
  ])

  AS_IF([test -d "$with_loci_dir/lib64"],
  [
    dnl AC_MSG_NOTICE([directory $with_loci_dir/lib64 exists])
    LOCI_LDFLAGS="-L$with_loci_dir/lib64"
  ],
  [
    :
    dnl AC_MSG_NOTICE([directory $with_loci_dir/lib64 does not exist])
  ])

  LOCI_LIBS="-lLoci -lTools -lsprng"

  _try_compile_link_loci_sample=yes
],
["ILDirOption"],
[
  dnl AC_MSG_NOTICE([Looking for Loci in directories $with_loci_include_dir $with_loci_lib_dir])

  AC_PATH_PROG([lpp],["lpp"],[notfound],[$with_loci_bin_dir:$PATH])
  AS_IF([test "x$ac_cv_path_lpp" == "xnotfound"],
  [AC_MSG_ERROR([lpp not found])],[LPP="$ac_cv_path_lpp"])

  AS_IF([test -d "$with_loci_include_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_loci_include_dir exists])
    LOCI_CXXFLAGS="-I$with_loci_include_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE(directory $with_loci_include_dir does not exist)
  ])

  AS_IF([test -d "$with_loci_lib_dir"],
  [
    dnl AC_MSG_NOTICE([directory $with_loci_lib_dir exists])
    LOCI_LDFLAGS="-L$with_loci_lib_dir"
  ],
  [
    :
    dnl AC_MSG_NOTICE(directory $with_loci_lib_dir does not exist)
  ])

  LOCI_LIBS="$with_loci_libs"

  _try_compile_link_loci_sample=yes
],
["PkgConfigOption"],
[
  dnl AC_MSG_NOTICE([Loci will be discovered via pkg-config])

  AC_PATH_PROG([lpp],["lpp"],[notfound])
  AS_IF([test "x$ac_cv_path_lpp" == "xnotfound"],
  [AC_MSG_ERROR([lpp not found])],[LPP="$ac_cv_path_lpp"])

  _loci_pkg_config_name="loci"
  AS_IF([test "x$with_loci_pkg_config" != "xyes"],[_loci_pkg_config_name="$with_loci_pkg_config"])

  PKG_CHECK_MODULES([LOCI],
  [$_loci_pkg_config_name],
  [
    LOCI_CXXFLAGS="$LOCI_CFLAGS"
    _try_compile_link_loci_sample=yes
  ],
  [AC_MSG_ERROR([pkg-config could not find $_loci_pg_config_name])])
],
["FlagsOption"],
[
  dnl AC_MSG_NOTICE([Loci will be discovered via environment variable flags])

  AC_PATH_PROG([lpp],["lpp"],[notfound])
  AS_IF([test "x$ac_cv_path_lpp" == "xnotfound"],
  [AC_MSG_ERROR([lpp not found])],[LPP="$ac_cv_path_lpp"])

  _try_compile_link_loci_sample=yes
],
[AC_MSG_ERROR([multiple configuration options for Loci: $_loci_config_option])]
)

AS_IF([test "x$_try_compile_link_loci_sample" == "xyes"],
[
  AC_LANG_PUSH([C++])

  save_CPPFLAGS="$CPPFLAGS"
  save_CXXFLAGS="$CXXFLAGS"
  save_LDFLAGS="$LDFLAGS"
  save_LIBS="$LIBS"

  AS_IF([test "x$have_xml2" == "xyes"],
  [
    CPPFLAGS="$XML2_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$XML2_CFLAGS $CXXFLAGS"
    LDFLAGS="$XML2_LDFLAGS $LDFLAGS"
    LIBS="$XML2_LIBS $LIBS"
  ])

  AS_IF([test "x$have_mpi" == "xyes"],
  [
    CPPFLAGS="$MPI_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$MPI_CFLAGS $CXXFLAGS"
    LDFLAGS="$MPI_LDFLAGS $LDFLAGS"
    LIBS="$MPI_LIBS $LIBS"
  ])

  AS_IF([test "x$have_hdf5" == "xyes"],
  [
    CPPFLAGS="$HDF5_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$HDF5_CFLAGS $CXXFLAGS"
    LDFLAGS="$HDF5_LDFLAGS $LDFLAGS"
    LIBS="$HDF5_LIBS $LIBS"
  ])

  AS_IF([test "x$have_cgns" == "xyes"],
  [
    CPPFLAGS="$CGNS_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$CGNS_CFLAGS $CXXFLAGS"
    LDFLAGS="$CGNS_LDFLAGS $LDFLAGS"
    LIBS="$CGNS_LIBS $LIBS"
  ])

  AS_IF([test "x$have_petsc" == "xyes"],
  [
    CPPFLAGS="$PETSC_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$PETSC_CFLAGS $CXXFLAGS"
    LDFLAGS="$PETSC_LDFLAGS $LDFLAGS"
    LIBS="$PETSC_LIBS $LIBS"
  ])

  AS_IF([test "x$have_metis" == "xyes"],
  [
    CPPFLAGS="$METIS_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$METIS_CFLAGS $CXXFLAGS"
    LDFLAGS="$METIS_LDFLAGS $LDFLAGS"
    LIBS="$METIS_LIBS $LIBS"
  ])

  AS_IF([test "x$have_parmetis" == "xyes"],
  [
    CPPFLAGS="$PARMETIS_CPPFLAGS $CPPFLAGS"
    CXXFLAGS="$PARMETIS_CFLAGS $CXXFLAGS"
    LDFLAGS="$PARMETIS_LDFLAGS $LDFLAGS"
    LIBS="$PARMETIS_LIBS $LIBS"
  ])

  CPPFLAGS="$LOCI_CPPFLAGS $with_loci_additional_cppflags $CPPFLAGS"
  CXXFLAGS="$LOCI_CXXFLAGS $with_loci_additional_cxxflags $CXXFLAGS"
  LDFLAGS="$LOCI_LDFLAGS $with_loci_additional_ldflags $LDFLAGS"
  LIBS="$LOCI_LIBS $with_loci_additional_libs $LIBS"

  AC_MSG_CHECKING([if loci is usable])
  AC_LINK_IFELSE([AC_LANG_SOURCE([[
  #include <Loci.h>
  int main(int argc, char * argv[]) {
    Loci::Init(&argc, &argv);
    Loci::Finalize();
    return 0;
  }
  ]])],
  [
    AC_MSG_RESULT([yes])
    have_loci=yes

    AC_SUBST([HAVE_LOCI],[1])
    AC_DEFINE([HAVE_LOCI],[1],[defined to 1 if loci is available])

    dnl AC_MSG_NOTICE([LOCI_CPPFLAGS=$LOCI_CPPFLAGS])
    dnl AC_MSG_NOTICE([LOCI_CXXFLAGS=$LOCI_CXXFLAGS])
    dnl AC_MSG_NOTICE([LOCI_LDFLAGS=$LOCI_LDFLAGS])
    dnl AC_MSG_NOTICE([LOCI_LIBS=$LOCI_LIBS])
  ],
  [
    AC_MSG_RESULT([no])

    AC_MSG_ERROR([[could not link with Loci using:
    LOCI_CPPFLAGS=$LOCI_CPPFLAGS
    LOCI_CXXFLAGS=$LOCI_CXXFLAGS
    LOCI_LDFLAGS=$LOCI_LDFLAGS
    LOCI_LIBS=$LOCI_LIBS]])
  ])

  CPPFLAGS="$save_CPPFLAGS"
  CXXFLAGS="$save_CXXFLAGS"
  LDFLAGS="$save_LDFLAGS"
  LIBS="$save_LIBS"

  AC_LANG_POP([C++])
])

AM_CONDITIONAL([HAVE_LOCI],[test "x$have_loci" == "xyes"])

dnl AC_ARG_WITH(
dnl [loci],
dnl [
dnl   AS_HELP_STRING(
dnl     [--with-loci=[auto/yes/no/PATH]],
dnl     [compile with Loci support. Default: auto]
dnl   )
dnl ],
dnl [],
dnl [with_loci=auto]
dnl )
dnl 
dnl AS_CASE($with_loci,
dnl   [no], [
dnl     _configure_loci_req=no
dnl     _configure_loci_path=no
dnl   ],
dnl   [yes], [
dnl     _configure_loci_req=yes
dnl     _configure_loci_path=auto
dnl   ],
dnl   [auto], [
dnl     _configure_loci_req=auto
dnl     _configure_loci_path=auto
dnl   ],
dnl   [/*], [
dnl     _configure_loci_req=yes
dnl     AS_IF(
dnl       [test -z "$with_loci"],
dnl       [_configure_loci_path=auto],
dnl       [_configure_loci_path=$with_loci]
dnl     )
dnl   ],
dnl   [
dnl     _configure_loci_req=no
dnl     _configure_loci_path=no
dnl   ]
dnl )
dnl 
dnl _configure_loci_library_found=no
dnl _configure_loci_header_found=no
dnl 
dnl AS_IF(
dnl   [test "x$_configure_loci_req" = "xyes" || test "x$_configure_loci_req" = "xauto"],
dnl   [
dnl     AS_IF(
dnl       [test "x$_configure_loci_path" = "xauto"],
dnl       [
dnl         AS_VAR_IF(
dnl           [LOCI_BASE],
dnl           [],
dnl           [
dnl             _configure_loci_full_path="notfound"
dnl             AC_MSG_ERROR([Environment variable LOCI_BASE not set])
dnl           ],
dnl           [
dnl             _configure_loci_full_path="$LOCI_BASE"
dnl           ]
dnl         )
dnl       ],
dnl       [_configure_loci_full_path="$_configure_loci_path"]
dnl     )
dnl 
dnl     _configure_loci_conf_file="$_configure_loci_full_path/Loci.conf"
dnl     AC_CHECK_FILE(
dnl       [$_configure_loci_conf_file],
dnl       [],
dnl       [
dnl         AC_MSG_ERROR([Loci installation not found at $_configure_loci_full_path])
dnl         _configure_loci_full_path="notfound"
dnl       ]
dnl     )
dnl 
dnl     cat > Loci-discovery-Makefile <<EOF
dnl include $_configure_loci_full_path/Loci.conf
dnl 
dnl print_COPT_FLAGS:
dnl 	@echo \$(C_OPT)
dnl 
dnl print_CXXOPT_FLAGS:
dnl 	@echo \$(COPT)
dnl 
dnl print_LOCI_INCLUDES:
dnl 	@echo \$(LOCI_INCLUDES)
dnl 
dnl print_INCLUDES:
dnl 	@echo \$(INCLUDES)
dnl 
dnl print_DEFINES:
dnl 	@echo \$(DEFINES)
dnl 
dnl print_LIBS:
dnl 	@echo \$(LIBS)
dnl 
dnl .PHONY: print_COPT_FLAGS print_CXXOPT_FLAGS print_LOCI_INCLUDES print_INCLUDES print_DEFINES print_LIBS
dnl EOF
dnl 
dnl     _LOCI_COPT_FLAGS=$(eval make -f Loci-discovery-Makefile print_COPT_FLAGS)
dnl     _LOCI_CXXOPT_FLAGS=$(eval make -f Loci-discovery-Makefile print_CXXOPT_FLAGS)
dnl     _LOCI_INCLUDES=$(eval make -f Loci-discovery-Makefile print_INCLUDES)
dnl     _LOCI_LOCI_INCLUDES=$(eval make -f Loci-discovery-Makefile print_LOCI_INCLUDES)
dnl     _LOCI_DEFINES=$(eval make -f Loci-discovery-Makefile print_DEFINES)
dnl     _LOCI_LIBS=$(eval make -f Loci-discovery-Makefile print_LIBS)
dnl     
dnl     AC_MSG_NOTICE([_LOCI_COPT_FLAGS=$_LOCI_COPT_FLAGS])
dnl     AC_MSG_NOTICE([_LOCI_CXXOPT_FLAGS=$_LOCI_CXXOPT_FLAGS])
dnl     AC_MSG_NOTICE([_LOCI_INCLUDES=$_LOCI_INCLUDES])
dnl     AC_MSG_NOTICE([_LOCI_LOCI_INCLUDES=$_LOCI_LOCI_INCLUDES])
dnl     AC_MSG_NOTICE([_LOCI_DEFINES=$_LOCI_DEFINES])
dnl     AC_MSG_NOTICE([_LOCI_LIBS=$_LOCI_LIBS])
dnl     
dnl     LOCI_LDFLAGS="$_LOCI_CXXOPT_FLAGS"
dnl     LOCI_LIBS="$_LOCI_LIBS"
dnl     LOCI_CXXFLAGS="$_LOCI_INCLUDES $_LOCI_LOCI_INCLUDES $_LOCI_CXXOPT_FLAGS"
dnl     LOCI_CPPFLAGS="$_LOCI_DEFINES"
dnl     
dnl     AC_MSG_NOTICE([LOCI_LDFLAGS=$LOCI_LDFLAGS])
dnl     AC_MSG_NOTICE([LOCI_LIBS=$LOCI_LIBS])
dnl     AC_MSG_NOTICE([LOCI_CXXFLAGS=$LOCI_CXXFLAGS])
dnl     AC_MSG_NOTICE([LOCI_CPPFLAGS=$LOCI_CPPFLAGS])
dnl     
dnl     AC_LANG_PUSH([C++])
dnl     
dnl     save_CC="$CC"
dnl     save_CXX="$CXX"
dnl     save_LIBS="$LIBS"
dnl     save_LDFLAGS="$LDFLAGS"
dnl     save_CFLAGS="$CFLAGS"
dnl     save_CXXFLAGS="$CXXFLAGS"
dnl     save_CPPFLAGS="$CPPFLAGS"
dnl     
dnl     CC="mpicc"
dnl     CXX="mpicxx"
dnl     LIBS="$LOCI_LIBS $save_LIBS"
dnl     LDFLAGS="$LOCI_LDFLAGS $save_LDFLAGS"
dnl     CFLAGS="$LOCI_CXXFLAGS $LOCI_DEFINES $CFLAGS"
dnl     CXXFLAGS="$LOCI_CXXFLAGS $LOCI_DEFINES $CXXFLAGS"
dnl     CPPFLAGS="$LOCI_CPPFLAGS $CPPFLAGS"
dnl     
dnl     AC_MSG_CHECKING([for Loci library usability])
dnl     AC_LINK_IFELSE(
dnl       [AC_LANG_PROGRAM([#include <Loci.h>],[Loci::Init(0, 0);])],
dnl       [
dnl         AC_MSG_RESULT([yes])
dnl         _configure_loci_library_found="yes"
dnl       ],
dnl       [
dnl         AC_MSG_RESULT([no])
dnl         _configure_loci_library_found="no"
dnl       ]
dnl     )
dnl     
dnl     AC_CHECK_HEADER(
dnl       [Loci.h],
dnl       [_configure_loci_header_found="yes"],
dnl       [_configure_loci_header_found="no"],
dnl       [AC_INCLUDES_DEFAULT]
dnl     )
dnl     
dnl     CC="$save_CC"
dnl     CXX="$save_CXX"
dnl     LIBS="$save_LIBS"
dnl     LDFLAGS="$save_LDFLAGS"
dnl     CFLAGS="$save_CFLAGS"
dnl     CXXFLAGS="$save_CXXFLAGS"
dnl     CPPFLAGS="$save_CPPFLAGS"
dnl     
dnl     AC_LANG_POP([C++])
dnl   ]
dnl )
dnl 
dnl dnl for automake use
dnl AM_CONDITIONAL([HAVE_LOCI],[test "x$_configure_loci_library_found" = "xyes" && test "x$_configure_loci_header_found" = "xyes"])
dnl 
dnl AS_IF(
dnl   [test "x$_configure_loci_library_found" = "xyes" && test "x$_configure_loci_header_found" = "xyes"],
dnl   [
dnl     dnl for configure use
dnl     use_loci="yes"
dnl     
dnl     dnl for C preprocessor
dnl     AC_DEFINE([HAVE_LOCI], [1], [Defined if Loci library is detected.])
dnl     
dnl     dnl set LPP variable for use in Makefiles
dnl     AC_SUBST([LPP], [$_configure_loci_full_path/bin/lpp])
dnl   ],
dnl   [
dnl     dnl for configure use
dnl     use_loci="no"
dnl     
dnl     dnl reset
dnl     LOCI_LIBS=""
dnl     LOCI_LDFLAGS=""
dnl     LOCI_CXXFLAGS=""
dnl     LOCI_CPPFLAGS=""
dnl   ]
dnl )
dnl 
dnl AS_IF(
dnl   [test "x$_configure_loci_req" = "xyes"],
dnl   [AS_IF([test "x$use_loci" = "xyes"],[],[AC_MSG_FAILURE([Loci requested, but not found])])],
dnl   [test "x$_configure_loci_req" = "xauto"],
dnl   [AS_IF([test "x$use_loci" = "xyes"],[],[AC_MSG_WARN([Loci not found, will not use Loci])])],
dnl   [test "x$_configure_loci_req" = "xno"],
dnl   [AC_MSG_NOTICE([Loci not requested])]
dnl )

])
