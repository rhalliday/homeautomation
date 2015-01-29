# This Makefile is for the HomeAutomation extension to perl.
#
# It was generated automatically by MakeMaker version
# 7.04 (Revision: 70400) from the contents of
# Makefile.PL. Don't edit this file, edit Makefile.PL instead.
#
#       ANY CHANGES MADE HERE WILL BE LOST!
#
#   MakeMaker ARGV: ()
#

#   MakeMaker Parameters:

#     ABSTRACT => q[Catalyst based application for controlling devices in the home]
#     AUTHOR => [q[Rob Halliday]]
#     BUILD_REQUIRES => { ExtUtils::MakeMaker=>q[6.59], Test::Class::Moose=>q[0], Test::MockObject::Extends=>q[0], Test::More=>q[0.88], Test::WWW::Mechanize::Catalyst=>q[0] }
#     CONFIGURE_REQUIRES => {  }
#     DISTNAME => q[HomeAutomation]
#     EXE_FILES => [q[script/create_admin_user.pl], q[script/fake_mochad.pl], q[script/homeautomation_cgi.pl], q[script/homeautomation_create.pl], q[script/homeautomation_fastcgi.pl], q[script/homeautomation_server.pl], q[script/homeautomation_test.pl], q[script/run_scheduled_tasks.pl], q[script/schedule_tasks.pl], q[script/scheduled_tasks_server.pl]]
#     LICENSE => q[perl]
#     MIN_PERL_VERSION => q[5.014]
#     NAME => q[HomeAutomation]
#     NO_META => q[1]
#     PREREQ_PM => { Catalyst::Action::RenderView=>q[0], Catalyst::Authentication::Realm::SimpleDB=>q[0], Catalyst::Model::DBIC::Schema=>q[0], Catalyst::Plugin::Authentication=>q[0], Catalyst::Plugin::Authorization::Roles=>q[0], Catalyst::Plugin::ConfigLoader=>q[0], Catalyst::Plugin::Session=>q[0], Catalyst::Plugin::Session::State::Cookie=>q[0], Catalyst::Plugin::Session::Store::File=>q[0], Catalyst::Plugin::StackTrace=>q[0], Catalyst::Plugin::Static::Simple=>q[0], Catalyst::Plugin::StatusMessage=>q[0], Catalyst::Runtime=>q[5.90018], Catalyst::View::JSON=>q[0], Catalyst::View::TT=>q[0], Config::General=>q[0], DBIx::Class=>q[0], DBIx::Class::PassphraseColumn=>q[0], DBIx::Class::TimeStamp=>q[0], ExtUtils::MakeMaker=>q[6.59], HTML::FormHandler::Model::DBIC=>q[0], HTML::FormHandler::Widget::Theme::Bootstrap3=>q[0], Moose=>q[0], Perl6::Junction=>q[0], Test::Class::Moose=>q[0], Test::MockObject::Extends=>q[0], Test::More=>q[0.88], Test::WWW::Mechanize::Catalyst=>q[0], namespace::autoclean=>q[0] }
#     TEST_REQUIRES => {  }
#     VERSION => q[0.07]
#     VERSION_FROM => q[lib/HomeAutomation.pm]
#     dist => { PREOP=>q[$(PERL) -I. "-MModule::Install::Admin" -e "dist_preop(q($(DISTVNAME)))"] }
#     realclean => { FILES=>q[MYMETA.yml] }
#     test => { TESTS=>q[t/02pod.t t/03podcoverage.t t/mochad_initialise_everything.t t/mochad_initialization.t t/mochad_on_off_dim_bright.t t/model_DB.t t/tests.t t/view_HTML.t t/view_JSON.t] }

# --- MakeMaker post_initialize section:


# --- MakeMaker const_config section:

# These definitions are from config.sh (via /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux/Config.pm).
# They may have been overridden via Makefile.PL or on the command line.
AR = ar
CC = cc
CCCDLFLAGS = -fPIC
CCDLFLAGS = -Wl,-E
DLEXT = so
DLSRC = dl_dlopen.xs
EXE_EXT = 
FULL_AR = /usr/bin/ar
LD = cc
LDDLFLAGS = -shared -O2 -L/usr/local/lib -fstack-protector
LDFLAGS =  -fstack-protector -L/usr/local/lib
LIBC = libc-2.19.so
LIB_EXT = .a
OBJ_EXT = .o
OSNAME = linux
OSVERS = 3.16.0-29-generic
RANLIB = :
SITELIBEXP = /home/rob/.plenv/versions/5.20.0/lib/perl5/site_perl/5.20.0
SITEARCHEXP = /home/rob/.plenv/versions/5.20.0/lib/perl5/site_perl/5.20.0/x86_64-linux
SO = so
VENDORARCHEXP = 
VENDORLIBEXP = 


# --- MakeMaker constants section:
AR_STATIC_ARGS = cr
DIRFILESEP = /
DFSEP = $(DIRFILESEP)
NAME = HomeAutomation
NAME_SYM = HomeAutomation
VERSION = 0.07
VERSION_MACRO = VERSION
VERSION_SYM = 0_07
DEFINE_VERSION = -D$(VERSION_MACRO)=\"$(VERSION)\"
XS_VERSION = 0.07
XS_VERSION_MACRO = XS_VERSION
XS_DEFINE_VERSION = -D$(XS_VERSION_MACRO)=\"$(XS_VERSION)\"
INST_ARCHLIB = blib/arch
INST_SCRIPT = blib/script
INST_BIN = blib/bin
INST_LIB = blib/lib
INST_MAN1DIR = blib/man1
INST_MAN3DIR = blib/man3
MAN1EXT = 1
MAN3EXT = 3
INSTALLDIRS = site
DESTDIR = 
PREFIX = $(SITEPREFIX)
PERLPREFIX = /home/rob/.plenv/versions/5.20.0
SITEPREFIX = /home/rob/.plenv/versions/5.20.0
VENDORPREFIX = 
INSTALLPRIVLIB = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0
DESTINSTALLPRIVLIB = $(DESTDIR)$(INSTALLPRIVLIB)
INSTALLSITELIB = /home/rob/.plenv/versions/5.20.0/lib/perl5/site_perl/5.20.0
DESTINSTALLSITELIB = $(DESTDIR)$(INSTALLSITELIB)
INSTALLVENDORLIB = 
DESTINSTALLVENDORLIB = $(DESTDIR)$(INSTALLVENDORLIB)
INSTALLARCHLIB = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux
DESTINSTALLARCHLIB = $(DESTDIR)$(INSTALLARCHLIB)
INSTALLSITEARCH = /home/rob/.plenv/versions/5.20.0/lib/perl5/site_perl/5.20.0/x86_64-linux
DESTINSTALLSITEARCH = $(DESTDIR)$(INSTALLSITEARCH)
INSTALLVENDORARCH = 
DESTINSTALLVENDORARCH = $(DESTDIR)$(INSTALLVENDORARCH)
INSTALLBIN = /home/rob/.plenv/versions/5.20.0/bin
DESTINSTALLBIN = $(DESTDIR)$(INSTALLBIN)
INSTALLSITEBIN = /home/rob/.plenv/versions/5.20.0/bin
DESTINSTALLSITEBIN = $(DESTDIR)$(INSTALLSITEBIN)
INSTALLVENDORBIN = 
DESTINSTALLVENDORBIN = $(DESTDIR)$(INSTALLVENDORBIN)
INSTALLSCRIPT = /home/rob/.plenv/versions/5.20.0/bin
DESTINSTALLSCRIPT = $(DESTDIR)$(INSTALLSCRIPT)
INSTALLSITESCRIPT = /home/rob/.plenv/versions/5.20.0/bin
DESTINSTALLSITESCRIPT = $(DESTDIR)$(INSTALLSITESCRIPT)
INSTALLVENDORSCRIPT = 
DESTINSTALLVENDORSCRIPT = $(DESTDIR)$(INSTALLVENDORSCRIPT)
INSTALLMAN1DIR = /home/rob/.plenv/versions/5.20.0/man/man1
DESTINSTALLMAN1DIR = $(DESTDIR)$(INSTALLMAN1DIR)
INSTALLSITEMAN1DIR = /home/rob/.plenv/versions/5.20.0/man/man1
DESTINSTALLSITEMAN1DIR = $(DESTDIR)$(INSTALLSITEMAN1DIR)
INSTALLVENDORMAN1DIR = 
DESTINSTALLVENDORMAN1DIR = $(DESTDIR)$(INSTALLVENDORMAN1DIR)
INSTALLMAN3DIR = /home/rob/.plenv/versions/5.20.0/man/man3
DESTINSTALLMAN3DIR = $(DESTDIR)$(INSTALLMAN3DIR)
INSTALLSITEMAN3DIR = /home/rob/.plenv/versions/5.20.0/man/man3
DESTINSTALLSITEMAN3DIR = $(DESTDIR)$(INSTALLSITEMAN3DIR)
INSTALLVENDORMAN3DIR = 
DESTINSTALLVENDORMAN3DIR = $(DESTDIR)$(INSTALLVENDORMAN3DIR)
PERL_LIB =
PERL_ARCHLIB = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux
PERL_ARCHLIBDEP = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux
LIBPERL_A = libperl.a
FIRST_MAKEFILE = Makefile
MAKEFILE_OLD = Makefile.old
MAKE_APERL_FILE = Makefile.aperl
PERLMAINCC = $(CC)
PERL_INC = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux/CORE
PERL_INCDEP = /home/rob/.plenv/versions/5.20.0/lib/perl5/5.20.0/x86_64-linux/CORE
PERL = "/home/rob/.plenv/versions/5.20.0/bin/perl5.20.0" "-Iinc"
FULLPERL = "/home/rob/.plenv/versions/5.20.0/bin/perl5.20.0" "-Iinc"
ABSPERL = $(PERL)
PERLRUN = $(PERL)
FULLPERLRUN = $(FULLPERL)
ABSPERLRUN = $(ABSPERL)
PERLRUNINST = $(PERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
FULLPERLRUNINST = $(FULLPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
ABSPERLRUNINST = $(ABSPERLRUN) "-I$(INST_ARCHLIB)" "-Iinc" "-I$(INST_LIB)"
PERL_CORE = 0
PERM_DIR = 755
PERM_RW = 644
PERM_RWX = 755

MAKEMAKER   = /home/rob/catalyst/HomeAutomation/local/lib/perl5/ExtUtils/MakeMaker.pm
MM_VERSION  = 7.04
MM_REVISION = 70400

# FULLEXT = Pathname for extension directory (eg Foo/Bar/Oracle).
# BASEEXT = Basename part of FULLEXT. May be just equal FULLEXT. (eg Oracle)
# PARENT_NAME = NAME without BASEEXT and no trailing :: (eg Foo::Bar)
# DLBASE  = Basename part of dynamic library. May be just equal BASEEXT.
MAKE = make
FULLEXT = HomeAutomation
BASEEXT = HomeAutomation
PARENT_NAME = 
DLBASE = $(BASEEXT)
VERSION_FROM = lib/HomeAutomation.pm
OBJECT = 
LDFROM = $(OBJECT)
LINKTYPE = dynamic
BOOTDEP = 

# Handy lists of source code files:
XS_FILES = 
C_FILES  = 
O_FILES  = 
H_FILES  = 
MAN1PODS = script/homeautomation_cgi.pl \
	script/homeautomation_create.pl \
	script/homeautomation_fastcgi.pl \
	script/homeautomation_server.pl \
	script/homeautomation_test.pl
MAN3PODS = lib/HomeAutomation.pm \
	lib/HomeAutomation/Controller/Appliances.pm \
	lib/HomeAutomation/Controller/Login.pm \
	lib/HomeAutomation/Controller/Logout.pm \
	lib/HomeAutomation/Controller/Root.pm \
	lib/HomeAutomation/Controller/Schedules.pm \
	lib/HomeAutomation/Controller/UserManagement.pm \
	lib/HomeAutomation/Form/Appliance.pm \
	lib/HomeAutomation/Form/ChangePassword.pm \
	lib/HomeAutomation/Form/Schedule.pm \
	lib/HomeAutomation/Form/User.pm \
	lib/HomeAutomation/Model/DB.pm \
	lib/HomeAutomation/Schema.pm \
	lib/HomeAutomation/Schema/Base.pm \
	lib/HomeAutomation/Schema/Result/Appliance.pm \
	lib/HomeAutomation/Schema/Result/Day.pm \
	lib/HomeAutomation/Schema/Result/Recurrence.pm \
	lib/HomeAutomation/Schema/Result/Role.pm \
	lib/HomeAutomation/Schema/Result/Room.pm \
	lib/HomeAutomation/Schema/Result/Task.pm \
	lib/HomeAutomation/Schema/Result/TasksDay.pm \
	lib/HomeAutomation/Schema/Result/User.pm \
	lib/HomeAutomation/Schema/Result/UserRole.pm \
	lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	lib/HomeAutomation/Schema/ResultSet/Task.pm \
	lib/HomeAutomation/View/HTML.pm \
	lib/HomeAutomation/View/JSON.pm \
	lib/Mochad.pm

# Where is the Config information that we are using/depend on
CONFIGDEP = $(PERL_ARCHLIBDEP)$(DFSEP)Config.pm $(PERL_INCDEP)$(DFSEP)config.h

# Where to build things
INST_LIBDIR      = $(INST_LIB)
INST_ARCHLIBDIR  = $(INST_ARCHLIB)

INST_AUTODIR     = $(INST_LIB)/auto/$(FULLEXT)
INST_ARCHAUTODIR = $(INST_ARCHLIB)/auto/$(FULLEXT)

INST_STATIC      = 
INST_DYNAMIC     = 
INST_BOOT        = 

# Extra linker info
EXPORT_LIST        = 
PERL_ARCHIVE       = 
PERL_ARCHIVEDEP    = 
PERL_ARCHIVE_AFTER = 


TO_INST_PM = lib/HomeAutomation.pm \
	lib/HomeAutomation/Controller/Appliances.pm \
	lib/HomeAutomation/Controller/Login.pm \
	lib/HomeAutomation/Controller/Logout.pm \
	lib/HomeAutomation/Controller/Root.pm \
	lib/HomeAutomation/Controller/Schedules.pm \
	lib/HomeAutomation/Controller/UserManagement.pm \
	lib/HomeAutomation/Form/Appliance.pm \
	lib/HomeAutomation/Form/ChangePassword.pm \
	lib/HomeAutomation/Form/Schedule.pm \
	lib/HomeAutomation/Form/User.pm \
	lib/HomeAutomation/Model/DB.pm \
	lib/HomeAutomation/Schema.pm \
	lib/HomeAutomation/Schema/Base.pm \
	lib/HomeAutomation/Schema/Result/Appliance.pm \
	lib/HomeAutomation/Schema/Result/Day.pm \
	lib/HomeAutomation/Schema/Result/Recurrence.pm \
	lib/HomeAutomation/Schema/Result/Role.pm \
	lib/HomeAutomation/Schema/Result/Room.pm \
	lib/HomeAutomation/Schema/Result/Task.pm \
	lib/HomeAutomation/Schema/Result/TasksDay.pm \
	lib/HomeAutomation/Schema/Result/User.pm \
	lib/HomeAutomation/Schema/Result/UserRole.pm \
	lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	lib/HomeAutomation/Schema/ResultSet/Task.pm \
	lib/HomeAutomation/View/HTML.pm \
	lib/HomeAutomation/View/JSON.pm \
	lib/Mochad.pm

PM_TO_BLIB = lib/HomeAutomation.pm \
	blib/lib/HomeAutomation.pm \
	lib/HomeAutomation/Controller/Appliances.pm \
	blib/lib/HomeAutomation/Controller/Appliances.pm \
	lib/HomeAutomation/Controller/Login.pm \
	blib/lib/HomeAutomation/Controller/Login.pm \
	lib/HomeAutomation/Controller/Logout.pm \
	blib/lib/HomeAutomation/Controller/Logout.pm \
	lib/HomeAutomation/Controller/Root.pm \
	blib/lib/HomeAutomation/Controller/Root.pm \
	lib/HomeAutomation/Controller/Schedules.pm \
	blib/lib/HomeAutomation/Controller/Schedules.pm \
	lib/HomeAutomation/Controller/UserManagement.pm \
	blib/lib/HomeAutomation/Controller/UserManagement.pm \
	lib/HomeAutomation/Form/Appliance.pm \
	blib/lib/HomeAutomation/Form/Appliance.pm \
	lib/HomeAutomation/Form/ChangePassword.pm \
	blib/lib/HomeAutomation/Form/ChangePassword.pm \
	lib/HomeAutomation/Form/Schedule.pm \
	blib/lib/HomeAutomation/Form/Schedule.pm \
	lib/HomeAutomation/Form/User.pm \
	blib/lib/HomeAutomation/Form/User.pm \
	lib/HomeAutomation/Model/DB.pm \
	blib/lib/HomeAutomation/Model/DB.pm \
	lib/HomeAutomation/Schema.pm \
	blib/lib/HomeAutomation/Schema.pm \
	lib/HomeAutomation/Schema/Base.pm \
	blib/lib/HomeAutomation/Schema/Base.pm \
	lib/HomeAutomation/Schema/Result/Appliance.pm \
	blib/lib/HomeAutomation/Schema/Result/Appliance.pm \
	lib/HomeAutomation/Schema/Result/Day.pm \
	blib/lib/HomeAutomation/Schema/Result/Day.pm \
	lib/HomeAutomation/Schema/Result/Recurrence.pm \
	blib/lib/HomeAutomation/Schema/Result/Recurrence.pm \
	lib/HomeAutomation/Schema/Result/Role.pm \
	blib/lib/HomeAutomation/Schema/Result/Role.pm \
	lib/HomeAutomation/Schema/Result/Room.pm \
	blib/lib/HomeAutomation/Schema/Result/Room.pm \
	lib/HomeAutomation/Schema/Result/Task.pm \
	blib/lib/HomeAutomation/Schema/Result/Task.pm \
	lib/HomeAutomation/Schema/Result/TasksDay.pm \
	blib/lib/HomeAutomation/Schema/Result/TasksDay.pm \
	lib/HomeAutomation/Schema/Result/User.pm \
	blib/lib/HomeAutomation/Schema/Result/User.pm \
	lib/HomeAutomation/Schema/Result/UserRole.pm \
	blib/lib/HomeAutomation/Schema/Result/UserRole.pm \
	lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	blib/lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	lib/HomeAutomation/Schema/ResultSet/Task.pm \
	blib/lib/HomeAutomation/Schema/ResultSet/Task.pm \
	lib/HomeAutomation/View/HTML.pm \
	blib/lib/HomeAutomation/View/HTML.pm \
	lib/HomeAutomation/View/JSON.pm \
	blib/lib/HomeAutomation/View/JSON.pm \
	lib/Mochad.pm \
	blib/lib/Mochad.pm


# --- MakeMaker platform_constants section:
MM_Unix_VERSION = 7.04
PERL_MALLOC_DEF = -DPERL_EXTMALLOC_DEF -Dmalloc=Perl_malloc -Dfree=Perl_mfree -Drealloc=Perl_realloc -Dcalloc=Perl_calloc


# --- MakeMaker tool_autosplit section:
# Usage: $(AUTOSPLITFILE) FileToSplit AutoDirToSplitInto
AUTOSPLITFILE = $(ABSPERLRUN)  -e 'use AutoSplit;  autosplit($$$$ARGV[0], $$$$ARGV[1], 0, 1, 1)' --



# --- MakeMaker tool_xsubpp section:


# --- MakeMaker tools_other section:
SHELL = /bin/sh
CHMOD = chmod
CP = cp
MV = mv
NOOP = $(TRUE)
NOECHO = @
RM_F = rm -f
RM_RF = rm -rf
TEST_F = test -f
TOUCH = touch
UMASK_NULL = umask 0
DEV_NULL = > /dev/null 2>&1
MKPATH = $(ABSPERLRUN) -MExtUtils::Command -e 'mkpath' --
EQUALIZE_TIMESTAMP = $(ABSPERLRUN) -MExtUtils::Command -e 'eqtime' --
FALSE = false
TRUE = true
ECHO = echo
ECHO_N = echo -n
UNINST = 0
VERBINST = 0
MOD_INSTALL = $(ABSPERLRUN) -MExtUtils::Install -e 'install([ from_to => {@ARGV}, verbose => '\''$(VERBINST)'\'', uninstall_shadows => '\''$(UNINST)'\'', dir_mode => '\''$(PERM_DIR)'\'' ]);' --
DOC_INSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'perllocal_install' --
UNINSTALL = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'uninstall' --
WARN_IF_OLD_PACKLIST = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'warn_if_old_packlist' --
MACROSTART = 
MACROEND = 
USEMAKEFILE = -f
FIXIN = $(ABSPERLRUN) -MExtUtils::MY -e 'MY->fixin(shift)' --
CP_NONEMPTY = $(ABSPERLRUN) -MExtUtils::Command::MM -e 'cp_nonempty' --


# --- MakeMaker makemakerdflt section:
makemakerdflt : all
	$(NOECHO) $(NOOP)


# --- MakeMaker dist section:
TAR = tar
TARFLAGS = cvf
ZIP = zip
ZIPFLAGS = -r
COMPRESS = gzip --best
SUFFIX = .gz
SHAR = shar
PREOP = $(PERL) -I. "-MModule::Install::Admin" -e "dist_preop(q($(DISTVNAME)))"
POSTOP = $(NOECHO) $(NOOP)
TO_UNIX = $(NOECHO) $(NOOP)
CI = ci -u
RCS_LABEL = rcs -Nv$(VERSION_SYM): -q
DIST_CP = best
DIST_DEFAULT = tardist
DISTNAME = HomeAutomation
DISTVNAME = HomeAutomation-0.07


# --- MakeMaker macro section:


# --- MakeMaker depend section:


# --- MakeMaker cflags section:


# --- MakeMaker const_loadlibs section:


# --- MakeMaker const_cccmd section:


# --- MakeMaker post_constants section:


# --- MakeMaker pasthru section:

PASTHRU = LIBPERL_A="$(LIBPERL_A)"\
	LINKTYPE="$(LINKTYPE)"\
	PREFIX="$(PREFIX)"


# --- MakeMaker special_targets section:
.SUFFIXES : .xs .c .C .cpp .i .s .cxx .cc $(OBJ_EXT)

.PHONY: all config static dynamic test linkext manifest blibdirs clean realclean disttest distdir



# --- MakeMaker c_o section:


# --- MakeMaker xs_c section:


# --- MakeMaker xs_o section:


# --- MakeMaker top_targets section:
all :: pure_all manifypods
	$(NOECHO) $(NOOP)


pure_all :: config pm_to_blib subdirs linkext
	$(NOECHO) $(NOOP)

subdirs :: $(MYEXTLIB)
	$(NOECHO) $(NOOP)

config :: $(FIRST_MAKEFILE) blibdirs
	$(NOECHO) $(NOOP)

help :
	perldoc ExtUtils::MakeMaker


# --- MakeMaker blibdirs section:
blibdirs : $(INST_LIBDIR)$(DFSEP).exists $(INST_ARCHLIB)$(DFSEP).exists $(INST_AUTODIR)$(DFSEP).exists $(INST_ARCHAUTODIR)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists $(INST_SCRIPT)$(DFSEP).exists $(INST_MAN1DIR)$(DFSEP).exists $(INST_MAN3DIR)$(DFSEP).exists
	$(NOECHO) $(NOOP)

# Backwards compat with 6.18 through 6.25
blibdirs.ts : blibdirs
	$(NOECHO) $(NOOP)

$(INST_LIBDIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_LIBDIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_LIBDIR)
	$(NOECHO) $(TOUCH) $(INST_LIBDIR)$(DFSEP).exists

$(INST_ARCHLIB)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHLIB)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHLIB)
	$(NOECHO) $(TOUCH) $(INST_ARCHLIB)$(DFSEP).exists

$(INST_AUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_AUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_AUTODIR)
	$(NOECHO) $(TOUCH) $(INST_AUTODIR)$(DFSEP).exists

$(INST_ARCHAUTODIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_ARCHAUTODIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_ARCHAUTODIR)
	$(NOECHO) $(TOUCH) $(INST_ARCHAUTODIR)$(DFSEP).exists

$(INST_BIN)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_BIN)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_BIN)
	$(NOECHO) $(TOUCH) $(INST_BIN)$(DFSEP).exists

$(INST_SCRIPT)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_SCRIPT)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_SCRIPT)
	$(NOECHO) $(TOUCH) $(INST_SCRIPT)$(DFSEP).exists

$(INST_MAN1DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN1DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN1DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN1DIR)$(DFSEP).exists

$(INST_MAN3DIR)$(DFSEP).exists :: Makefile.PL
	$(NOECHO) $(MKPATH) $(INST_MAN3DIR)
	$(NOECHO) $(CHMOD) $(PERM_DIR) $(INST_MAN3DIR)
	$(NOECHO) $(TOUCH) $(INST_MAN3DIR)$(DFSEP).exists



# --- MakeMaker linkext section:

linkext :: $(LINKTYPE)
	$(NOECHO) $(NOOP)


# --- MakeMaker dlsyms section:


# --- MakeMaker dynamic_bs section:

BOOTSTRAP =


# --- MakeMaker dynamic section:

dynamic :: $(FIRST_MAKEFILE) $(BOOTSTRAP) $(INST_DYNAMIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker dynamic_lib section:


# --- MakeMaker static section:

## $(INST_PM) has been moved to the all: target.
## It remains here for awhile to allow for old usage: "make static"
static :: $(FIRST_MAKEFILE) $(INST_STATIC)
	$(NOECHO) $(NOOP)


# --- MakeMaker static_lib section:


# --- MakeMaker manifypods section:

POD2MAN_EXE = $(PERLRUN) "-MExtUtils::Command::MM" -e pod2man "--"
POD2MAN = $(POD2MAN_EXE)


manifypods : pure_all  \
	lib/HomeAutomation.pm \
	lib/HomeAutomation/Controller/Appliances.pm \
	lib/HomeAutomation/Controller/Login.pm \
	lib/HomeAutomation/Controller/Logout.pm \
	lib/HomeAutomation/Controller/Root.pm \
	lib/HomeAutomation/Controller/Schedules.pm \
	lib/HomeAutomation/Controller/UserManagement.pm \
	lib/HomeAutomation/Form/Appliance.pm \
	lib/HomeAutomation/Form/ChangePassword.pm \
	lib/HomeAutomation/Form/Schedule.pm \
	lib/HomeAutomation/Form/User.pm \
	lib/HomeAutomation/Model/DB.pm \
	lib/HomeAutomation/Schema.pm \
	lib/HomeAutomation/Schema/Base.pm \
	lib/HomeAutomation/Schema/Result/Appliance.pm \
	lib/HomeAutomation/Schema/Result/Day.pm \
	lib/HomeAutomation/Schema/Result/Recurrence.pm \
	lib/HomeAutomation/Schema/Result/Role.pm \
	lib/HomeAutomation/Schema/Result/Room.pm \
	lib/HomeAutomation/Schema/Result/Task.pm \
	lib/HomeAutomation/Schema/Result/TasksDay.pm \
	lib/HomeAutomation/Schema/Result/User.pm \
	lib/HomeAutomation/Schema/Result/UserRole.pm \
	lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	lib/HomeAutomation/Schema/ResultSet/Task.pm \
	lib/HomeAutomation/View/HTML.pm \
	lib/HomeAutomation/View/JSON.pm \
	lib/Mochad.pm \
	script/homeautomation_cgi.pl \
	script/homeautomation_create.pl \
	script/homeautomation_fastcgi.pl \
	script/homeautomation_server.pl \
	script/homeautomation_test.pl
	$(NOECHO) $(POD2MAN) --section=1 --perm_rw=$(PERM_RW) -u \
	  script/homeautomation_cgi.pl $(INST_MAN1DIR)/homeautomation_cgi.pl.$(MAN1EXT) \
	  script/homeautomation_create.pl $(INST_MAN1DIR)/homeautomation_create.pl.$(MAN1EXT) \
	  script/homeautomation_fastcgi.pl $(INST_MAN1DIR)/homeautomation_fastcgi.pl.$(MAN1EXT) \
	  script/homeautomation_server.pl $(INST_MAN1DIR)/homeautomation_server.pl.$(MAN1EXT) \
	  script/homeautomation_test.pl $(INST_MAN1DIR)/homeautomation_test.pl.$(MAN1EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) -u \
	  lib/HomeAutomation.pm $(INST_MAN3DIR)/HomeAutomation.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/Appliances.pm $(INST_MAN3DIR)/HomeAutomation::Controller::Appliances.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/Login.pm $(INST_MAN3DIR)/HomeAutomation::Controller::Login.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/Logout.pm $(INST_MAN3DIR)/HomeAutomation::Controller::Logout.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/Root.pm $(INST_MAN3DIR)/HomeAutomation::Controller::Root.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/Schedules.pm $(INST_MAN3DIR)/HomeAutomation::Controller::Schedules.$(MAN3EXT) \
	  lib/HomeAutomation/Controller/UserManagement.pm $(INST_MAN3DIR)/HomeAutomation::Controller::UserManagement.$(MAN3EXT) \
	  lib/HomeAutomation/Form/Appliance.pm $(INST_MAN3DIR)/HomeAutomation::Form::Appliance.$(MAN3EXT) \
	  lib/HomeAutomation/Form/ChangePassword.pm $(INST_MAN3DIR)/HomeAutomation::Form::ChangePassword.$(MAN3EXT) \
	  lib/HomeAutomation/Form/Schedule.pm $(INST_MAN3DIR)/HomeAutomation::Form::Schedule.$(MAN3EXT) \
	  lib/HomeAutomation/Form/User.pm $(INST_MAN3DIR)/HomeAutomation::Form::User.$(MAN3EXT) \
	  lib/HomeAutomation/Model/DB.pm $(INST_MAN3DIR)/HomeAutomation::Model::DB.$(MAN3EXT) \
	  lib/HomeAutomation/Schema.pm $(INST_MAN3DIR)/HomeAutomation::Schema.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Base.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Base.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Appliance.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Appliance.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Day.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Day.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Recurrence.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Recurrence.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Role.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Role.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Room.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Room.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/Task.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::Task.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/TasksDay.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::TasksDay.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/User.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::User.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/Result/UserRole.pm $(INST_MAN3DIR)/HomeAutomation::Schema::Result::UserRole.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/ResultSet/Appliance.pm $(INST_MAN3DIR)/HomeAutomation::Schema::ResultSet::Appliance.$(MAN3EXT) \
	  lib/HomeAutomation/Schema/ResultSet/Task.pm $(INST_MAN3DIR)/HomeAutomation::Schema::ResultSet::Task.$(MAN3EXT) \
	  lib/HomeAutomation/View/HTML.pm $(INST_MAN3DIR)/HomeAutomation::View::HTML.$(MAN3EXT) 
	$(NOECHO) $(POD2MAN) --section=3 --perm_rw=$(PERM_RW) -u \
	  lib/HomeAutomation/View/JSON.pm $(INST_MAN3DIR)/HomeAutomation::View::JSON.$(MAN3EXT) \
	  lib/Mochad.pm $(INST_MAN3DIR)/Mochad.$(MAN3EXT) 




# --- MakeMaker processPL section:


# --- MakeMaker installbin section:

EXE_FILES = script/create_admin_user.pl script/fake_mochad.pl script/homeautomation_cgi.pl script/homeautomation_create.pl script/homeautomation_fastcgi.pl script/homeautomation_server.pl script/homeautomation_test.pl script/run_scheduled_tasks.pl script/schedule_tasks.pl script/scheduled_tasks_server.pl

pure_all :: $(INST_SCRIPT)/fake_mochad.pl $(INST_SCRIPT)/homeautomation_server.pl $(INST_SCRIPT)/scheduled_tasks_server.pl $(INST_SCRIPT)/homeautomation_cgi.pl $(INST_SCRIPT)/create_admin_user.pl $(INST_SCRIPT)/homeautomation_test.pl $(INST_SCRIPT)/run_scheduled_tasks.pl $(INST_SCRIPT)/schedule_tasks.pl $(INST_SCRIPT)/homeautomation_fastcgi.pl $(INST_SCRIPT)/homeautomation_create.pl
	$(NOECHO) $(NOOP)

realclean ::
	$(RM_F) \
	  $(INST_SCRIPT)/fake_mochad.pl $(INST_SCRIPT)/homeautomation_server.pl \
	  $(INST_SCRIPT)/scheduled_tasks_server.pl $(INST_SCRIPT)/homeautomation_cgi.pl \
	  $(INST_SCRIPT)/create_admin_user.pl $(INST_SCRIPT)/homeautomation_test.pl \
	  $(INST_SCRIPT)/run_scheduled_tasks.pl $(INST_SCRIPT)/schedule_tasks.pl \
	  $(INST_SCRIPT)/homeautomation_fastcgi.pl $(INST_SCRIPT)/homeautomation_create.pl 

$(INST_SCRIPT)/fake_mochad.pl : script/fake_mochad.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/fake_mochad.pl
	$(CP) script/fake_mochad.pl $(INST_SCRIPT)/fake_mochad.pl
	$(FIXIN) $(INST_SCRIPT)/fake_mochad.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/fake_mochad.pl

$(INST_SCRIPT)/homeautomation_server.pl : script/homeautomation_server.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/homeautomation_server.pl
	$(CP) script/homeautomation_server.pl $(INST_SCRIPT)/homeautomation_server.pl
	$(FIXIN) $(INST_SCRIPT)/homeautomation_server.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/homeautomation_server.pl

$(INST_SCRIPT)/scheduled_tasks_server.pl : script/scheduled_tasks_server.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/scheduled_tasks_server.pl
	$(CP) script/scheduled_tasks_server.pl $(INST_SCRIPT)/scheduled_tasks_server.pl
	$(FIXIN) $(INST_SCRIPT)/scheduled_tasks_server.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/scheduled_tasks_server.pl

$(INST_SCRIPT)/homeautomation_cgi.pl : script/homeautomation_cgi.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/homeautomation_cgi.pl
	$(CP) script/homeautomation_cgi.pl $(INST_SCRIPT)/homeautomation_cgi.pl
	$(FIXIN) $(INST_SCRIPT)/homeautomation_cgi.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/homeautomation_cgi.pl

$(INST_SCRIPT)/create_admin_user.pl : script/create_admin_user.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/create_admin_user.pl
	$(CP) script/create_admin_user.pl $(INST_SCRIPT)/create_admin_user.pl
	$(FIXIN) $(INST_SCRIPT)/create_admin_user.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/create_admin_user.pl

$(INST_SCRIPT)/homeautomation_test.pl : script/homeautomation_test.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/homeautomation_test.pl
	$(CP) script/homeautomation_test.pl $(INST_SCRIPT)/homeautomation_test.pl
	$(FIXIN) $(INST_SCRIPT)/homeautomation_test.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/homeautomation_test.pl

$(INST_SCRIPT)/run_scheduled_tasks.pl : script/run_scheduled_tasks.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/run_scheduled_tasks.pl
	$(CP) script/run_scheduled_tasks.pl $(INST_SCRIPT)/run_scheduled_tasks.pl
	$(FIXIN) $(INST_SCRIPT)/run_scheduled_tasks.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/run_scheduled_tasks.pl

$(INST_SCRIPT)/schedule_tasks.pl : script/schedule_tasks.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/schedule_tasks.pl
	$(CP) script/schedule_tasks.pl $(INST_SCRIPT)/schedule_tasks.pl
	$(FIXIN) $(INST_SCRIPT)/schedule_tasks.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/schedule_tasks.pl

$(INST_SCRIPT)/homeautomation_fastcgi.pl : script/homeautomation_fastcgi.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/homeautomation_fastcgi.pl
	$(CP) script/homeautomation_fastcgi.pl $(INST_SCRIPT)/homeautomation_fastcgi.pl
	$(FIXIN) $(INST_SCRIPT)/homeautomation_fastcgi.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/homeautomation_fastcgi.pl

$(INST_SCRIPT)/homeautomation_create.pl : script/homeautomation_create.pl $(FIRST_MAKEFILE) $(INST_SCRIPT)$(DFSEP).exists $(INST_BIN)$(DFSEP).exists
	$(NOECHO) $(RM_F) $(INST_SCRIPT)/homeautomation_create.pl
	$(CP) script/homeautomation_create.pl $(INST_SCRIPT)/homeautomation_create.pl
	$(FIXIN) $(INST_SCRIPT)/homeautomation_create.pl
	-$(NOECHO) $(CHMOD) $(PERM_RWX) $(INST_SCRIPT)/homeautomation_create.pl



# --- MakeMaker subdirs section:

# none

# --- MakeMaker clean_subdirs section:
clean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker clean section:

# Delete temporary files but do not touch installed files. We don't delete
# the Makefile here so a later make realclean still has a makefile to use.

clean :: clean_subdirs
	- $(RM_F) \
	  $(BASEEXT).bso $(BASEEXT).def \
	  $(BASEEXT).exp $(BASEEXT).x \
	  $(BOOTSTRAP) $(INST_ARCHAUTODIR)/extralibs.all \
	  $(INST_ARCHAUTODIR)/extralibs.ld $(MAKE_APERL_FILE) \
	  *$(LIB_EXT) *$(OBJ_EXT) \
	  *perl.core MYMETA.json \
	  MYMETA.yml blibdirs.ts \
	  core core.*perl.*.? \
	  core.[0-9] core.[0-9][0-9] \
	  core.[0-9][0-9][0-9] core.[0-9][0-9][0-9][0-9] \
	  core.[0-9][0-9][0-9][0-9][0-9] lib$(BASEEXT).def \
	  mon.out perl \
	  perl$(EXE_EXT) perl.exe \
	  perlmain.c pm_to_blib \
	  pm_to_blib.ts so_locations \
	  tmon.out 
	- $(RM_RF) \
	  blib 
	  $(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	- $(MV) $(FIRST_MAKEFILE) $(MAKEFILE_OLD) $(DEV_NULL)


# --- MakeMaker realclean_subdirs section:
realclean_subdirs :
	$(NOECHO) $(NOOP)


# --- MakeMaker realclean section:
# Delete temporary files (via clean) and also delete dist files
realclean purge ::  clean realclean_subdirs
	- $(RM_F) \
	  $(FIRST_MAKEFILE) $(MAKEFILE_OLD) 
	- $(RM_RF) \
	  $(DISTVNAME) MYMETA.yml 


# --- MakeMaker metafile section:
metafile :
	$(NOECHO) $(NOOP)


# --- MakeMaker signature section:
signature :
	cpansign -s


# --- MakeMaker dist_basics section:
distclean :: realclean distcheck
	$(NOECHO) $(NOOP)

distcheck :
	$(PERLRUN) "-MExtUtils::Manifest=fullcheck" -e fullcheck

skipcheck :
	$(PERLRUN) "-MExtUtils::Manifest=skipcheck" -e skipcheck

manifest :
	$(PERLRUN) "-MExtUtils::Manifest=mkmanifest" -e mkmanifest

veryclean : realclean
	$(RM_F) *~ */*~ *.orig */*.orig *.bak */*.bak *.old */*.old



# --- MakeMaker dist_core section:

dist : $(DIST_DEFAULT) $(FIRST_MAKEFILE)
	$(NOECHO) $(ABSPERLRUN) -l -e 'print '\''Warning: Makefile possibly out of date with $(VERSION_FROM)'\''' \
	  -e '    if -e '\''$(VERSION_FROM)'\'' and -M '\''$(VERSION_FROM)'\'' < -M '\''$(FIRST_MAKEFILE)'\'';' --

tardist : $(DISTVNAME).tar$(SUFFIX)
	$(NOECHO) $(NOOP)

uutardist : $(DISTVNAME).tar$(SUFFIX)
	uuencode $(DISTVNAME).tar$(SUFFIX) $(DISTVNAME).tar$(SUFFIX) > $(DISTVNAME).tar$(SUFFIX)_uu
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)_uu'

$(DISTVNAME).tar$(SUFFIX) : distdir
	$(PREOP)
	$(TO_UNIX)
	$(TAR) $(TARFLAGS) $(DISTVNAME).tar $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(COMPRESS) $(DISTVNAME).tar
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).tar$(SUFFIX)'
	$(POSTOP)

zipdist : $(DISTVNAME).zip
	$(NOECHO) $(NOOP)

$(DISTVNAME).zip : distdir
	$(PREOP)
	$(ZIP) $(ZIPFLAGS) $(DISTVNAME).zip $(DISTVNAME)
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).zip'
	$(POSTOP)

shdist : distdir
	$(PREOP)
	$(SHAR) $(DISTVNAME) > $(DISTVNAME).shar
	$(RM_RF) $(DISTVNAME)
	$(NOECHO) $(ECHO) 'Created $(DISTVNAME).shar'
	$(POSTOP)


# --- MakeMaker distdir section:
create_distdir :
	$(RM_RF) $(DISTVNAME)
	$(PERLRUN) "-MExtUtils::Manifest=manicopy,maniread" \
		-e "manicopy(maniread(),'$(DISTVNAME)', '$(DIST_CP)');"

distdir : create_distdir  
	$(NOECHO) $(NOOP)



# --- MakeMaker dist_test section:
disttest : distdir
	cd $(DISTVNAME) && $(ABSPERLRUN) Makefile.PL 
	cd $(DISTVNAME) && $(MAKE) $(PASTHRU)
	cd $(DISTVNAME) && $(MAKE) test $(PASTHRU)



# --- MakeMaker dist_ci section:

ci :
	$(PERLRUN) "-MExtUtils::Manifest=maniread" \
	  -e "@all = keys %{ maniread() };" \
	  -e "print(qq{Executing $(CI) @all\n}); system(qq{$(CI) @all});" \
	  -e "print(qq{Executing $(RCS_LABEL) ...\n}); system(qq{$(RCS_LABEL) @all});"


# --- MakeMaker distmeta section:
distmeta : create_distdir metafile
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -e q{META.yml};' \
	  -e 'eval { maniadd({q{META.yml} => q{Module YAML meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.yml to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'exit unless -f q{META.json};' \
	  -e 'eval { maniadd({q{META.json} => q{Module JSON meta-data (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add META.json to MANIFEST: $$$${'\''@'\''}\n"' --



# --- MakeMaker distsignature section:
distsignature : create_distdir
	$(NOECHO) cd $(DISTVNAME) && $(ABSPERLRUN) -MExtUtils::Manifest=maniadd -e 'eval { maniadd({q{SIGNATURE} => q{Public-key signature (added by MakeMaker)}}) }' \
	  -e '    or print "Could not add SIGNATURE to MANIFEST: $$$${'\''@'\''}\n"' --
	$(NOECHO) cd $(DISTVNAME) && $(TOUCH) SIGNATURE
	cd $(DISTVNAME) && cpansign -s



# --- MakeMaker install section:

install :: pure_install doc_install
	$(NOECHO) $(NOOP)

install_perl :: pure_perl_install doc_perl_install
	$(NOECHO) $(NOOP)

install_site :: pure_site_install doc_site_install
	$(NOECHO) $(NOOP)

install_vendor :: pure_vendor_install doc_vendor_install
	$(NOECHO) $(NOOP)

pure_install :: pure_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

doc_install :: doc_$(INSTALLDIRS)_install
	$(NOECHO) $(NOOP)

pure__install : pure_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

doc__install : doc_site_install
	$(NOECHO) $(ECHO) INSTALLDIRS not defined, defaulting to INSTALLDIRS=site

pure_perl_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLARCHLIB)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLPRIVLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLARCHLIB)" \
		"$(INST_BIN)" "$(DESTINSTALLBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(SITEARCHEXP)/auto/$(FULLEXT)"


pure_site_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLSITEARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLSITELIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLSITEARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLSITEBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLSITESCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLSITEMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLSITEMAN3DIR)"
	$(NOECHO) $(WARN_IF_OLD_PACKLIST) \
		"$(PERL_ARCHLIB)/auto/$(FULLEXT)"

pure_vendor_install :: all
	$(NOECHO) $(MOD_INSTALL) \
		read "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist" \
		write "$(DESTINSTALLVENDORARCH)/auto/$(FULLEXT)/.packlist" \
		"$(INST_LIB)" "$(DESTINSTALLVENDORLIB)" \
		"$(INST_ARCHLIB)" "$(DESTINSTALLVENDORARCH)" \
		"$(INST_BIN)" "$(DESTINSTALLVENDORBIN)" \
		"$(INST_SCRIPT)" "$(DESTINSTALLVENDORSCRIPT)" \
		"$(INST_MAN1DIR)" "$(DESTINSTALLVENDORMAN1DIR)" \
		"$(INST_MAN3DIR)" "$(DESTINSTALLVENDORMAN3DIR)"


doc_perl_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" $(INSTALLPRIVLIB) \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_site_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" $(INSTALLSITELIB) \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"

doc_vendor_install :: all
	$(NOECHO) $(ECHO) Appending installation info to "$(DESTINSTALLARCHLIB)/perllocal.pod"
	-$(NOECHO) $(MKPATH) "$(DESTINSTALLARCHLIB)"
	-$(NOECHO) $(DOC_INSTALL) \
		"Module" "$(NAME)" \
		"installed into" $(INSTALLVENDORLIB) \
		LINKTYPE "$(LINKTYPE)" \
		VERSION "$(VERSION)" \
		EXE_FILES "$(EXE_FILES)" \
		>> "$(DESTINSTALLARCHLIB)/perllocal.pod"


uninstall :: uninstall_from_$(INSTALLDIRS)dirs
	$(NOECHO) $(NOOP)

uninstall_from_perldirs ::
	$(NOECHO) $(UNINSTALL) "$(PERL_ARCHLIB)/auto/$(FULLEXT)/.packlist"

uninstall_from_sitedirs ::
	$(NOECHO) $(UNINSTALL) "$(SITEARCHEXP)/auto/$(FULLEXT)/.packlist"

uninstall_from_vendordirs ::
	$(NOECHO) $(UNINSTALL) "$(VENDORARCHEXP)/auto/$(FULLEXT)/.packlist"


# --- MakeMaker force section:
# Phony target to force checking subdirectories.
FORCE :
	$(NOECHO) $(NOOP)


# --- MakeMaker perldepend section:


# --- MakeMaker makefile section:
# We take a very conservative approach here, but it's worth it.
# We move Makefile to Makefile.old here to avoid gnu make looping.
$(FIRST_MAKEFILE) : Makefile.PL $(CONFIGDEP)
	$(NOECHO) $(ECHO) "Makefile out-of-date with respect to $?"
	$(NOECHO) $(ECHO) "Cleaning current config before rebuilding Makefile..."
	-$(NOECHO) $(RM_F) $(MAKEFILE_OLD)
	-$(NOECHO) $(MV)   $(FIRST_MAKEFILE) $(MAKEFILE_OLD)
	- $(MAKE) $(USEMAKEFILE) $(MAKEFILE_OLD) clean $(DEV_NULL)
	$(PERLRUN) Makefile.PL 
	$(NOECHO) $(ECHO) "==> Your Makefile has been rebuilt. <=="
	$(NOECHO) $(ECHO) "==> Please rerun the $(MAKE) command.  <=="
	$(FALSE)



# --- MakeMaker staticmake section:

# --- MakeMaker makeaperl section ---
MAP_TARGET    = perl
FULLPERL      = "/home/rob/.plenv/versions/5.20.0/bin/perl5.20.0"

$(MAP_TARGET) :: static $(MAKE_APERL_FILE)
	$(MAKE) $(USEMAKEFILE) $(MAKE_APERL_FILE) $@

$(MAKE_APERL_FILE) : $(FIRST_MAKEFILE) pm_to_blib
	$(NOECHO) $(ECHO) Writing \"$(MAKE_APERL_FILE)\" for this $(MAP_TARGET)
	$(NOECHO) $(PERLRUNINST) \
		Makefile.PL DIR="" \
		MAKEFILE=$(MAKE_APERL_FILE) LINKTYPE=static \
		MAKEAPERL=1 NORECURS=1 CCCDLFLAGS=


# --- MakeMaker test section:

TEST_VERBOSE=0
TEST_TYPE=test_$(LINKTYPE)
TEST_FILE = test.pl
TEST_FILES = t/02pod.t t/03podcoverage.t t/mochad_initialise_everything.t t/mochad_initialization.t t/mochad_on_off_dim_bright.t t/model_DB.t t/tests.t t/view_HTML.t t/view_JSON.t
TESTDB_SW = -d

testdb :: testdb_$(LINKTYPE)

test :: $(TEST_TYPE) subdirs-test

subdirs-test ::
	$(NOECHO) $(NOOP)


test_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) "-MExtUtils::Command::MM" "-MTest::Harness" "-e" "undef *Test::Harness::Switches; test_harness($(TEST_VERBOSE), 'inc', '$(INST_LIB)', '$(INST_ARCHLIB)')" $(TEST_FILES)

testdb_dynamic :: pure_all
	PERL_DL_NONLAZY=1 $(FULLPERLRUN) $(TESTDB_SW) "-Iinc" "-I$(INST_LIB)" "-I$(INST_ARCHLIB)" $(TEST_FILE)

test_ : test_dynamic

test_static :: test_dynamic
testdb_static :: testdb_dynamic


# --- MakeMaker ppd section:
# Creates a PPD (Perl Package Description) for a binary distribution.
ppd :
	$(NOECHO) $(ECHO) '<SOFTPKG NAME="$(DISTNAME)" VERSION="$(VERSION)">' > $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <ABSTRACT>Catalyst based application for controlling devices in the home</ABSTRACT>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <AUTHOR>Rob Halliday</AUTHOR>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    <IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <PERLCORE VERSION="5,014,0,0" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Action::RenderView" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Authentication::Realm::SimpleDB" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Model::DBIC::Schema" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Authentication" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Authorization::Roles" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::ConfigLoader" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Session" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Session::State::Cookie" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Session::Store::File" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::StackTrace" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::Static::Simple" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Plugin::StatusMessage" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::Runtime" VERSION="5.90018" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::View::JSON" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Catalyst::View::TT" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Config::General" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::PassphraseColumn" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="DBIx::Class::TimeStamp" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::FormHandler::Model::DBIC" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="HTML::FormHandler::Widget::Theme::Bootstrap3" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Moose::" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="Perl6::Junction" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <REQUIRE NAME="namespace::autoclean" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <ARCHITECTURE NAME="x86_64-linux-5.20" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '        <CODEBASE HREF="" />' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '    </IMPLEMENTATION>' >> $(DISTNAME).ppd
	$(NOECHO) $(ECHO) '</SOFTPKG>' >> $(DISTNAME).ppd


# --- MakeMaker pm_to_blib section:

pm_to_blib : $(FIRST_MAKEFILE) $(TO_INST_PM)
	$(NOECHO) $(ABSPERLRUN) -MExtUtils::Install -e 'pm_to_blib({@ARGV}, '\''$(INST_LIB)/auto'\'', q[$(PM_FILTER)], '\''$(PERM_DIR)'\'')' -- \
	  lib/HomeAutomation.pm blib/lib/HomeAutomation.pm \
	  lib/HomeAutomation/Controller/Appliances.pm blib/lib/HomeAutomation/Controller/Appliances.pm \
	  lib/HomeAutomation/Controller/Login.pm blib/lib/HomeAutomation/Controller/Login.pm \
	  lib/HomeAutomation/Controller/Logout.pm blib/lib/HomeAutomation/Controller/Logout.pm \
	  lib/HomeAutomation/Controller/Root.pm blib/lib/HomeAutomation/Controller/Root.pm \
	  lib/HomeAutomation/Controller/Schedules.pm blib/lib/HomeAutomation/Controller/Schedules.pm \
	  lib/HomeAutomation/Controller/UserManagement.pm blib/lib/HomeAutomation/Controller/UserManagement.pm \
	  lib/HomeAutomation/Form/Appliance.pm blib/lib/HomeAutomation/Form/Appliance.pm \
	  lib/HomeAutomation/Form/ChangePassword.pm blib/lib/HomeAutomation/Form/ChangePassword.pm \
	  lib/HomeAutomation/Form/Schedule.pm blib/lib/HomeAutomation/Form/Schedule.pm \
	  lib/HomeAutomation/Form/User.pm blib/lib/HomeAutomation/Form/User.pm \
	  lib/HomeAutomation/Model/DB.pm blib/lib/HomeAutomation/Model/DB.pm \
	  lib/HomeAutomation/Schema.pm blib/lib/HomeAutomation/Schema.pm \
	  lib/HomeAutomation/Schema/Base.pm blib/lib/HomeAutomation/Schema/Base.pm \
	  lib/HomeAutomation/Schema/Result/Appliance.pm blib/lib/HomeAutomation/Schema/Result/Appliance.pm \
	  lib/HomeAutomation/Schema/Result/Day.pm blib/lib/HomeAutomation/Schema/Result/Day.pm \
	  lib/HomeAutomation/Schema/Result/Recurrence.pm blib/lib/HomeAutomation/Schema/Result/Recurrence.pm \
	  lib/HomeAutomation/Schema/Result/Role.pm blib/lib/HomeAutomation/Schema/Result/Role.pm \
	  lib/HomeAutomation/Schema/Result/Room.pm blib/lib/HomeAutomation/Schema/Result/Room.pm \
	  lib/HomeAutomation/Schema/Result/Task.pm blib/lib/HomeAutomation/Schema/Result/Task.pm \
	  lib/HomeAutomation/Schema/Result/TasksDay.pm blib/lib/HomeAutomation/Schema/Result/TasksDay.pm \
	  lib/HomeAutomation/Schema/Result/User.pm blib/lib/HomeAutomation/Schema/Result/User.pm \
	  lib/HomeAutomation/Schema/Result/UserRole.pm blib/lib/HomeAutomation/Schema/Result/UserRole.pm \
	  lib/HomeAutomation/Schema/ResultSet/Appliance.pm blib/lib/HomeAutomation/Schema/ResultSet/Appliance.pm \
	  lib/HomeAutomation/Schema/ResultSet/Task.pm blib/lib/HomeAutomation/Schema/ResultSet/Task.pm \
	  lib/HomeAutomation/View/HTML.pm blib/lib/HomeAutomation/View/HTML.pm \
	  lib/HomeAutomation/View/JSON.pm blib/lib/HomeAutomation/View/JSON.pm \
	  lib/Mochad.pm blib/lib/Mochad.pm 
	$(NOECHO) $(TOUCH) pm_to_blib


# --- MakeMaker selfdocument section:


# --- MakeMaker postamble section:


# End.
# Postamble by Module::Install 1.14
# --- Module::Install::Admin::Makefile section:

realclean purge ::
	$(RM_F) $(DISTVNAME).tar$(SUFFIX)
	$(RM_F) MANIFEST.bak _build
	$(PERL) "-Ilib" "-MModule::Install::Admin" -e "remove_meta()"
	$(RM_RF) inc

reset :: purge

upload :: test dist
	cpan-upload -verbose $(DISTVNAME).tar$(SUFFIX)

grok ::
	perldoc Module::Install

distsign ::
	cpansign -s

# --- Module::Install::AutoInstall section:

config :: installdeps
	$(NOECHO) $(NOOP)

checkdeps ::
	$(PERL) Makefile.PL --checkdeps

installdeps ::
	$(NOECHO) $(NOOP)

installdeps_notest ::
	$(NOECHO) $(NOOP)

upgradedeps ::
	$(PERL) Makefile.PL --config= --upgradedeps=Test::More,0.88,Test::Class::Moose,0,Test::MockObject::Extends,0,Test::WWW::Mechanize::Catalyst,0,Catalyst::Runtime,5.90018,Catalyst::Plugin::ConfigLoader,0,Catalyst::Plugin::Static::Simple,0,Catalyst::Action::RenderView,0,Catalyst::Plugin::StackTrace,0,Catalyst::Plugin::Authentication,0,Catalyst::Authentication::Realm::SimpleDB,0,Catalyst::Plugin::Authorization::Roles,0,Catalyst::Plugin::Session,0,Catalyst::Plugin::Session::Store::File,0,Catalyst::Plugin::Session::State::Cookie,0,Catalyst::Plugin::StatusMessage,0,Catalyst::View::JSON,0,Catalyst::View::TT,0,Catalyst::Model::DBIC::Schema,0,DBIx::Class,0,DBIx::Class::TimeStamp,0,DBIx::Class::PassphraseColumn,0,HTML::FormHandler::Model::DBIC,0,HTML::FormHandler::Widget::Theme::Bootstrap3,0,Perl6::Junction,0,Moose,0,namespace::autoclean,0,Config::General,0

upgradedeps_notest ::
	$(PERL) Makefile.PL --config=notest,1 --upgradedeps=Test::More,0.88,Test::Class::Moose,0,Test::MockObject::Extends,0,Test::WWW::Mechanize::Catalyst,0,Catalyst::Runtime,5.90018,Catalyst::Plugin::ConfigLoader,0,Catalyst::Plugin::Static::Simple,0,Catalyst::Action::RenderView,0,Catalyst::Plugin::StackTrace,0,Catalyst::Plugin::Authentication,0,Catalyst::Authentication::Realm::SimpleDB,0,Catalyst::Plugin::Authorization::Roles,0,Catalyst::Plugin::Session,0,Catalyst::Plugin::Session::Store::File,0,Catalyst::Plugin::Session::State::Cookie,0,Catalyst::Plugin::StatusMessage,0,Catalyst::View::JSON,0,Catalyst::View::TT,0,Catalyst::Model::DBIC::Schema,0,DBIx::Class,0,DBIx::Class::TimeStamp,0,DBIx::Class::PassphraseColumn,0,HTML::FormHandler::Model::DBIC,0,HTML::FormHandler::Widget::Theme::Bootstrap3,0,Perl6::Junction,0,Moose,0,namespace::autoclean,0,Config::General,0

listdeps ::
	@$(PERL) -le "print for @ARGV" 

listalldeps ::
	@$(PERL) -le "print for @ARGV" Test::More Test::Class::Moose Test::MockObject::Extends Test::WWW::Mechanize::Catalyst Catalyst::Runtime Catalyst::Plugin::ConfigLoader Catalyst::Plugin::Static::Simple Catalyst::Action::RenderView Catalyst::Plugin::StackTrace Catalyst::Plugin::Authentication Catalyst::Authentication::Realm::SimpleDB Catalyst::Plugin::Authorization::Roles Catalyst::Plugin::Session Catalyst::Plugin::Session::Store::File Catalyst::Plugin::Session::State::Cookie Catalyst::Plugin::StatusMessage Catalyst::View::JSON Catalyst::View::TT Catalyst::Model::DBIC::Schema DBIx::Class DBIx::Class::TimeStamp DBIx::Class::PassphraseColumn HTML::FormHandler::Model::DBIC HTML::FormHandler::Widget::Theme::Bootstrap3 Perl6::Junction Moose namespace::autoclean Config::General

