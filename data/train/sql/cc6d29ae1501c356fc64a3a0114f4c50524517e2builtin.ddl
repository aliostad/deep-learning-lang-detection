
dml 0.9;

template read {
    // obsolete - read has default in hardwire.ddl
}

template write {
    // obsolete - write has default in hardwire.ddl
}

template read-write {
    // obsolete - read/write have defaults in hardwire.ddl
    is read;
    is write;
}

template read-only {
    is read;  // obsolete - read has default in hardwire.ddl
    method write(value) {
        log spec-violation 2 (Register_Write)
            "Write to read-only register %s", $qname;
    }
}

template write-only {
    method read() -> (value) {
        log spec-violation 2 (Register_Read)
            "Read from write-only register %s", $qname;
        fail;
    }
    is write;  // obsolete - write has default in hardwire.ddl
}

template ignore-write {
    method write(value) {
        // ignored
    }
}

template write-1-clears {
    method write(value) {
        $this = $this & ~value;
    }
}

template clear-on-read {
    method read() -> (value) {
        value = $this;
        $this = 0;
    }
}

template read-constant {
    method read -> (value) {
        value = $value;
    }
}

template read-zero {
    method read -> (value) {
        value = 0;
    }
}

template constant {
    parameter allocate = false;
    parameter value;
    method get -> (value) {
        value = $value;
    }
    method set(value) {
        if (value != $value) {
            log error (0) "Can't set %s; was %#x, expected %#x",
                $qname, value, $value;
            fail;
        }
    }
    is read-constant;
    method write(value) {
        if (value != $value) {
            log error (Register_Write) "Write to constant register %s with wrong value", $qname;
            fail;
        }
    }
}

template silent-constant {
    parameter allocate = false;
    parameter value;
    method get -> (value) {
        value = $value;
    }
    method set(value) {
        if (value != $value) {
            local int val;
            val = value;
            log error (0) "Can't set %s; was %#x, expected %#x",
                $qname, val, $value;
            fail;
        }
    }
    is read-constant;
    is ignore-write;
}

template zeros {
    parameter allocate = false;
    method get -> (value) {
        value = 0;
    }
    method set(value) {
        if (value != 0) {
            log error (0) "Can't set %s; was %#x, expected 0",
                $qname, value;
            fail;
        }
    }
    is read-zero;
    method write(value) {
        if (value != 0) {
            log spec-violation 1 (Register_Write)
                "Non-zero write to register %s", $qname;
            fail;
        }
    }
}

template ones {
    parameter allocate = false;
    parameter signed = true;
    method read() -> (value) {
        value = -1;
    }
    method write(value) {
        if (value != -1) {
            log spec-violation 1 (Register_Write)
                "Illegal write to register %s", $qname;
            fail;
        }
    }
}

template ignore {
    parameter allocate = false;
    method get() -> (value) {
        value = 0;
    }
    method set(value) {
        // ignored
    }
    is read-zero;
    is ignore-write;
}

template unimplemented {
    // This will store values on write and return them on read, but
    // emit a warning on every access.
    method read() -> (value)  {
        log unimplemented 1 (Register_Read)
            "Unimplemented read from %s%s",
            $qname,
            defined $desc ? " (" + $desc + ")" : "";
        value = $this;
    }
    method write(value) {
        log unimplemented 1 (Register_Write)
            "Unimplemented write to %s%s",
            $qname,
            defined $desc ? " (" + $desc + ")" : "";
        $this = value;
    }
}

template unimplemented1 {
    // This will store values on write and return them on read, but
    // emit a warning on the first access.
    method read() -> (value)  {
	static uint1 level = 1;
	if (level == 1) {
	    log unimplemented level (Register_Read)
		"read from %s%s, treated as simple read-write register (raising log level)",
		$qname,
		defined $desc ? " (" + $desc + ")" : "";
	    level = 2;
	} else {
	    log unimplemented 2 (Register_Read)
		"read from %s%s, treated as simple read-write register",
		$qname,
		defined $desc ? " (" + $desc + ")" : "";
	}
	value = $this;
    }
    method write(value) {
	static uint1 level = 1;
	if (level == 1) {
	    log unimplemented 1 (Register_Write)
		"write to %s%s, treated as simple read-write register (raising log level)",
		$qname,
		defined $desc ? " (" + $desc + ")" : "";
	    level = 2;
	} else {
	    log unimplemented 2 (Register_Write)
		"write to %s%s, treated as simple read-write register",
		$qname,
		defined $desc ? " (" + $desc + ")" : "";
	    level = 2;
	}
	$this = value;
    }
}

template reserved {
    // This will store values on write and return them on read, but
    // emit a warning on every access.
    method read() -> (value)  {
        log spec-violation 1 (Register_Read) "read from reserved address %s%s",
	    $qname,
	    defined $desc ? " (" + $desc + ")" : "";
        value = $this;
    }
    method write(value) {
        log spec-violation 1 (Register_Write)
            "write to reserved address %s%s",
	    $qname,
	    defined $desc ? " (" + $desc + ")" : "";
        $this = value;
    }
}

template signed {
    parameter signed = true;
}

template noalloc {
    parameter allocate = false;
}


// SIM API functions and stuff

verbatim SIM_break_simulation;
verbatim SIM_clear_exception;
verbatim SIM_get_attribute;
verbatim SIM_get_object;
verbatim SIM_hap_add_callback;
verbatim SIM_hap_add_callback_obj;
verbatim SIM_initial_configuration_ok;
verbatim SIM_last_error;
verbatim SIM_number_processors;
verbatim SIM_set_attribute;
verbatim SIM_time;

verbatim SimExc_No_Exception;

verbatim Sim_Hap_Simulation;

verbatim LOAD_BE16;
verbatim LOAD_BE32;
verbatim LOAD_BE64;
verbatim LOAD_LE16;
verbatim LOAD_LE32;
verbatim LOAD_LE64;
verbatim STORE_BE16;
verbatim STORE_BE32;
verbatim STORE_BE64;
verbatim STORE_LE16;
verbatim STORE_LE32;
verbatim STORE_LE64;

verbatim strlen;
verbatim memcpy;
verbatim memmove;
verbatim memset;

verbatim VSET;
verbatim VLEN;
verbatim VDROPLAST;
verbatim VRESIZE;
verbatim VCLEAR;
verbatim VFREE;
verbatim VGROW;
verbatim VVEC;
verbatim VNULL;
verbatim VREMOVE;

typedef uint32 size_t;

typedef integer_t simtime_t;
typedef simtime_t cycles_t;
typedef simtime_t pc_step_t;

typedef struct {} i2c_bus_interface_t;
typedef struct {} i2c_device_interface_t;
typedef struct {} simple_interrupt_interface_t;

typedef struct {} dbuffer_t;
