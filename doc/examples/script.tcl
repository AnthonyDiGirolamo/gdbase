
proc user_setup {} {
	gdb_setBreakpoint "main" "myMethod"
	db_logMessage "user.break" [gdb_lastOutput]
}

proc myMethod {} {
	gdb_getStackFrames
	db_logMessage "stack" [gdb_lastOutput]

	gdb_listLocals
	db_logMessage "locals" [gdb_lastOutput]

	set $result [gdb_evalExpr "rank % 2"]
	if { $result == "0" } {
		db_logMessage "rank" "is even"
	}

	gdb_continue
}

