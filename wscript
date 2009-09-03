#! /usr/bin/env python
# encoding: utf-8

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

VERSION='0.2'
APPNAME='gdbase'

srcdir = '.'
blddir = 'build'

def set_options(opt):
	opt.tool_options('python')
	opt.tool_options('compiler_cc')

def configure(conf):
	conf.check_tool('compiler_cc')
	conf.check_tool('python')
	conf.check_python_version((2,4,2))
	conf.check_cc(lib='tcl8.4')
	conf.check_cc(lib='sqlite3')
	conf.check_cc(lib='pq')
	try:
		conf.check_python_module('pgdb')
	except:
		print """
		Module pgdb (http://www.pygresql.org/) not found. 
		PostgreSQL database analysis will not function.
		"""

def build(bld):
	bld.new_task_gen(
		features = 'cc cprogram',
		source = 'src/opd.c src/gdbmi.c src/dblog.c src/vector.c',
		target = 'opd',
		includes = '. /usr/include ${PREFIX}/include',
		#ccflags = ['-O2', '-Wall'],
		lib = ['tcl8.4', 'sqlite3'],
		libpath = ['/usr/lib ${PREFIX}/lib'],
		linkflags = ['-g'])

	bld.new_task_gen(
		features = 'cc cprogram',
		source = 'src/dbmerge.c src/vector.c',
		target = 'dbmerge',
		includes = '. /usr/include ${PREFIX}/include',
		#ccflags = ['-O2', '-Wall'],
		lib = ['sqlite3', 'pq'],
		libpath = ['/usr/lib ${PREFIX}/lib'],
		linkflags = ['-g'])

	bld.add_post_fun(post)

	bld.install_files('${PREFIX}/bin', 'bin/gdbase', chmod=0755)
	bld.install_files('${PREFIX}/bin', 'bin/baseexec', chmod=0755)

	bld.install_files('${PREFIX}/share', 'share/single_step.tcl', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/single_step.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/allgather.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/allgather.tcl', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/deadlock.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/deadlock.tcl', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/endofrun.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/gdbase.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/mpi.script', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/nanreport.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/opd.tcl', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/segreport.py', chmod=0644)
	bld.install_files('${PREFIX}/share', 'share/moveup.sh', chmod=0755)
	bld.install_files('${PREFIX}/share', 'share/cleanup.sh', chmod=0755)

def post(bld):
	import Options, Utils
	cmd = "cp -f ./build/default/dbmerge ./bin/"
	Utils.exec_command(cmd)
	cmd = "cp -f ./build/default/opd ./bin/"
	Utils.exec_command(cmd)

