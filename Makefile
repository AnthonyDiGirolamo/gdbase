#!/usr/bin/make
# This file is part of GDBase.
#
# GDBase is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# GDBase is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with GDBase.  If not, see <http://www.gnu.org/licenses/>.
#
# Copyright 2009 Anthony DiGirolamo, Dan Stanzione, Karl Lindekugel

SRC=src
CC=gcc
INSTALL=install -D

INSTALLDIR=$(DESTDIR)$(GDBASE_PREFIX)
BINARY=/bin
SHARES=/share/gdbase

INCLUDES=-I$(GDBASE_PREFIX)/include
LIBS=-L$(GDBASE_PREFIX)/lib

CFLAGS=-g -O0 $(INCLUDES)
LDFLAGS=$(LIBS) -ltcl8.4 -lsqlite3

all: opd dbmerge

opd: $(SRC)/opd.o $(SRC)/gdbmi.o $(SRC)/dblog.o $(SRC)/vector.o $(SRC)/parser.o
	$(CC) $(CFLAGS) $? $(LDFLAGS) -o bin/$@

opd.o: $(SRC)/opd.c
gdbmi.o: $(SRC)/gdbmi.c $(SRC)/gdbmi.h
dblog.o: $(SRC)/dblog.c $(SRC)/dblog.h
parser.o: $(SRC)/parser.c $(SRC)/parser.h
vector.o: $(SRC)/vector.c $(SRC)/vector.h

dbmerge: $(SRC)/dbmerge.c $(SRC)/parser.c $(SRC)/vector.c
	$(CC) $(CFLAGS) $? $(LDFLAGS) -lpq -o bin/$@

install:
	$(INSTALL) -m 644 share/single_step.tcl  $(INSTALLDIR)$(SHARES)/single_step.tcl
	$(INSTALL) -m 644 share/single_step.py  $(INSTALLDIR)$(SHARES)/single_step.py
	$(INSTALL) -m 644 share/allgather.py  $(INSTALLDIR)$(SHARES)/allgather.py
	$(INSTALL) -m 644 share/allgather.tcl $(INSTALLDIR)$(SHARES)/allgather.tcl
	$(INSTALL) -m 644 share/deadlock.py   $(INSTALLDIR)$(SHARES)/deadlock.py
	$(INSTALL) -m 644 share/deadlock.tcl  $(INSTALLDIR)$(SHARES)/deadlock.tcl
	$(INSTALL) -m 644 share/endofrun.py   $(INSTALLDIR)$(SHARES)/endofrun.py
	$(INSTALL) -m 644 share/gdbase.py     $(INSTALLDIR)$(SHARES)/gdbase.py
	$(INSTALL) -m 644 share/mpi.script    $(INSTALLDIR)$(SHARES)/mpi.script
	$(INSTALL) -m 644 share/nanreport.py  $(INSTALLDIR)$(SHARES)/nanreport.py
	$(INSTALL) -m 644 share/opd.tcl       $(INSTALLDIR)$(SHARES)/opd.tcl
	$(INSTALL) -m 644 share/segreport.py  $(INSTALLDIR)$(SHARES)/segreport.py
	$(INSTALL) -m 755 share/moveup.sh     $(INSTALLDIR)$(BINARY)/moveup.sh
	$(INSTALL) -m 755 share/cleanup.sh    $(INSTALLDIR)$(BINARY)/cleanup.sh
	$(INSTALL) -m 755 bin/baseexec      $(INSTALLDIR)$(BINARY)/baseexec
	$(INSTALL) -m 755 bin/dbmerge       $(INSTALLDIR)$(BINARY)/dbmerge
	$(INSTALL) -m 755 bin/gdbase        $(INSTALLDIR)$(BINARY)/gdbase
	$(INSTALL) -m 755 bin/opd           $(INSTALLDIR)$(BINARY)/opd

clean:
	-rm -f bin/opd bin/dbmerge bin/*.pyc src/*.o

