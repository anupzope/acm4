AC_DEFUN([CONFIGURE_GLOG],[
AC_PREREQ(2.50)

AC_ARG_WITH(
  [glog],
  [AS_HELP_STRING([--with-glog],[build with glog for logging functionality])],
  [],
  [with_glog=no]
)

AS_CASE($with_glog,
  [yes],
  [PKG_CHECK_MODULES(
    [GLOG],
    [libglog >= 0.7.0],
    [
      use_glog=yes
      HAVE_GLOG=1
      AC_DEFINE([HAVE_GLOG],[1],[Defined to 1 if glog is available])
      AC_MSG_NOTICE([HAVE_GLOG=$HAVE_GLOG])
      AC_MSG_NOTICE([GLOG_CFLAGS=$GLOG_CFLAGS])
      AC_MSG_NOTICE([GLOG_LIBS=$GLOG_LIBS])
      AC_MSG_NOTICE([GLOG_LDFLAGS=$GLOG_LDFLAGS])
    ],
    [HAVE_GLOG=0]
  )
  ],
  [use_glog=no]
)

AM_CONDITIONAL([HAVE_GLOG],[test "x$use_glog" = "xyes"])

])
