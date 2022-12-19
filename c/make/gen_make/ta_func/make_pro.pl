#! /usr/bin/perl

# This file generates the "ta_func.pro" using the information
# provided by the "ta_func_list.txt"
#
# Reminder: ta_func.pro is then process by tmake for
#           generating the multi-platform makefiles.
#
# The output simply goes to stdout.

print "# Do not modify this file. It is automatically\n";
print "# generated by make_pro.pl\n";
print "\n";

print "TEMPLATE  = lib\n";
print "CONFIG   -= qt\n";
print "CONFIG   += staticlib\n";
print "\n";
print "# Identify the temp dir\n";
print "cmd:OBJECTS_DIR = ../../../../../temp/cmd\n";
print "cmr:OBJECTS_DIR = ../../../../../temp/cmr\n";
print "cmp:OBJECTS_DIR = ../../../../../temp/cmp\n";
print "csd:OBJECTS_DIR = ../../../../../temp/csd\n";
print "csr:OBJECTS_DIR = ../../../../../temp/csr\n";
print "csp:OBJECTS_DIR = ../../../../../temp/csp\n";
print "cdr:OBJECTS_DIR = ../../../../../temp/cdr\n";
print "cdd:OBJECTS_DIR = ../../../../../temp/cdd\n";
print "\n";
print "# Identify the target\n";
print "LIBTARGET = ta_func\n";
print "cmd:TARGET = ta_func_cmd\n";
print "cmr:TARGET = ta_func_cmr\n";
print "cmp:TARGET = ta_func_cmp\n";
print "csd:TARGET = ta_func_csd\n";
print "csr:TARGET = ta_func_csr\n";
print "csp:TARGET = ta_func_csp\n";
print "cdr:TARGET = ta_func_cdr\n";
print "cdd:TARGET = ta_func_cdd\n";
print "\n";
print "# Output info\n";
print "DESTDIR     = ../../../../../lib\n";
print "\n";
print "# Files to process\n";
print "SOURCES	= ../../../../../src/ta_func/ta_utility.c";

# Generate the list of functions.
open FUNCLIST_TXT, "<../../../../ta_func_list.txt" or die "Can't open ta_func_list.txt: $!";
@funclist = <FUNCLIST_TXT>;
foreach $z (@funclist) {
   if( length($z) > 2 )
   {
      @words = split( / /, $z );
      print " \\ \n";
      print "          ../../../../../src/ta_func/ta_",$words[0],".c";
   }
}
print " \n";

print "\n";
print "# Compiler Options\n";
print "INCLUDEPATH = ../../../../../src/ta_common \\n";
print "              ../../../../../include \n";
print "\n";
print "# debug/release dependent options.\n";
print "debug:DEFINES   *= TA_DEBUG\n";
print "debug:DEFINES   *= _DEBUG\n";
print "DEFINES        += TA_SINGLE_THREAD\n";
print "thread:DEFINES -= TA_SINGLE_THREAD\n";
print "\n";
print "\n";
print "# Platform dependent options.\n";
print "win32:DEFINES         *= WIN32\n";
print "win32-msvc:DEFINES    *= _MBCS _LIB\n";
print "freebsd-g++:LIBS      -= -ldl\n";
print "freebsd-g++:INCLUDEPATH += /usr/local/include\n";
print "\n";
print "cmd:TEMP_CLEAN_ALL = ../../../../../temp/cmd/*.pch\n";
print "cmr:TEMP_CLEAN_ALL = ../../../../../temp/cmr/*.pch\n";
print "cmp:TEMP_CLEAN_ALL = ../../../../../temp/cmp/*.pch\n";
print "csd:TEMP_CLEAN_ALL = ../../../../../temp/csd/*.pch\n";
print "csr:TEMP_CLEAN_ALL = ../../../../../temp/csr/*.pch\n";
print "csp:TEMP_CLEAN_ALL = ../../../../../temp/csp/*.pch\n";
print "cdr:TEMP_CLEAN_ALL = ../../../../../temp/cdr/*.pch\n";
print "cdd:TEMP_CLEAN_ALL = ../../../../../temp/cdd/*.pch\n";
print "\n";
print "cmd:TEMP_CLEAN_ALL2 = ../../../../../temp/cmd/*.idb\n";
print "cmr:TEMP_CLEAN_ALL2 = ../../../../../temp/cmr/*.idb\n";
print "cmp:TEMP_CLEAN_ALL2 = ../../../../../temp/cmp/*.idb\n";
print "csd:TEMP_CLEAN_ALL2 = ../../../../../temp/csd/*.idb\n";
print "csr:TEMP_CLEAN_ALL2 = ../../../../../temp/csr/*.idb\n";
print "csp:TEMP_CLEAN_ALL2 = ../../../../../temp/csp/*.idb\n";
print "cdr:TEMP_CLEAN_ALL2 = ../../../../../temp/cdr/*.idb\n";
print "cdd:TEMP_CLEAN_ALL2 = ../../../../../temp/cdd/*.idb\n";
print "\n";
print "cmd:TEMP_CLEAN_ALL3 = ../../../../../temp/cmd/\$\$LIBTARGET/*.pch\n";
print "cmr:TEMP_CLEAN_ALL3 = ../../../../../temp/cmr/\$\$LIBTARGET/*.pch\n";
print "cmp:TEMP_CLEAN_ALL3 = ../../../../../temp/cmp/\$\$LIBTARGET/*.pch\n";
print "csd:TEMP_CLEAN_ALL3 = ../../../../../temp/csd/\$\$LIBTARGET/*.pch\n";
print "csr:TEMP_CLEAN_ALL3 = ../../../../../temp/csr/\$\$LIBTARGET/*.pch\n";
print "csp:TEMP_CLEAN_ALL3 = ../../../../../temp/csp/\$\$LIBTARGET/*.pch\n";
print "cdr:TEMP_CLEAN_ALL3 = ../../../../../temp/cdr/\$\$LIBTARGET/*.pch\n";
print "cdd:TEMP_CLEAN_ALL3 = ../../../../../temp/cdd/\$\$LIBTARGET/*.pch\n";
print "\n";
print "cmd:TEMP_CLEAN_ALL4 = ../../../../../temp/cmd/\$\$LIBTARGET/*.idb\n";
print "cmr:TEMP_CLEAN_ALL4 = ../../../../../temp/cmr/\$\$LIBTARGET/*.idb\n";
print "cmp:TEMP_CLEAN_ALL4 = ../../../../../temp/cmp/\$\$LIBTARGET/*.idb\n";
print "csd:TEMP_CLEAN_ALL4 = ../../../../../temp/csd/\$\$LIBTARGET/*.idb\n";
print "csr:TEMP_CLEAN_ALL4 = ../../../../../temp/csr/\$\$LIBTARGET/*.idb\n";
print "csp:TEMP_CLEAN_ALL4 = ../../../../../temp/csp/\$\$LIBTARGET/*.idb\n";
print "cdr:TEMP_CLEAN_ALL4 = ../../../../../temp/cdr/\$\$LIBTARGET/*.idb\n";
print "cdd:TEMP_CLEAN_ALL4 = ../../../../../temp/cdd/\$\$LIBTARGET/*.idb\n";
print "\n";
print "cmd:TEMP_CLEAN_ALL5 = ../../../../../temp/cmd/\$\$LIBTARGET/*.obj\n";
print "cmr:TEMP_CLEAN_ALL5 = ../../../../../temp/cmr/\$\$LIBTARGET/*.obj\n";
print "cmp:TEMP_CLEAN_ALL5 = ../../../../../temp/cmp/\$\$LIBTARGET/*.obj\n";
print "csd:TEMP_CLEAN_ALL5 = ../../../../../temp/csd/\$\$LIBTARGET/*.obj\n";
print "csr:TEMP_CLEAN_ALL5 = ../../../../../temp/csr/\$\$LIBTARGET/*.obj\n";
print "csp:TEMP_CLEAN_ALL5 = ../../../../../temp/csp/\$\$LIBTARGET/*.obj\n";
print "cdr:TEMP_CLEAN_ALL5 = ../../../../../temp/cdr/\$\$LIBTARGET/*.obj\n";
print "cdd:TEMP_CLEAN_ALL5 = ../../../../../temp/cdd/\$\$LIBTARGET/*.obj\n";
print "\n";
print "win32:CLEAN_FILES = ../../../../../bin/*.map ../../../../../bin/*._xe ../../../../../bin/*.tds ../../../../../bin/*.pdb ../../../../../bin/*.pbo ../../../../../bin/*.pbi ../../../../../bin/*.pbt \$\$TEMP_CLEAN_ALL \$\$TEMP_CLEAN_ALL2 \$\$TEMP_CLEAN_ALL3 \$\$TEMP_CLEAN_ALL4 \$\$TEMP_CLEAN_ALL5\n";
