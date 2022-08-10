unit pythread_h;

interface
uses object_h, c_types;
const
  // code.h
  CO_MAXBLOCKS = 20;
type
  uint64_t = UInt64;// typedef unsigned long long uint64_t;

  // ---------------------------------------------------------------------------------------------------------------------------------------
  PyGILState_STATE = (PyGILState_LOCKED, PyGILState_UNLOCKED);

  pPyInterpreterState = ^PyInterpreterState;
  pPyThreadState = ^PyThreadState;
  pPyFrameObject = ^PyFrameObject;//он же _frame
  pPyCodeObject = ^PyCodeObject;
  // ---------------------------------------------------------------------------------------------------------------------------------------
  _PyFrameEvalFunction = function(f: pPyFrameObject; i: c_int): pPyObject; cdecl;
  // -------------------------
  PyInterpreterState = {$IFNDEF CPUX64}packed{$ENDIF} record
    next           : pPyInterpreterState;
    tstate_head    : pPyThreadState;

    modules              : pPyObject;
    modules_by_index     : pPyObject;
    sysdict              : pPyObject;
    builtins             : pPyObject;
    importlib            : pPyObject;

    codec_search_path    : pPyObject;
    codec_search_cache   : pPyObject;
    codec_error_registry : pPyObject;

    codecs_initialized   : c_int;
    fscodec_initialized  : c_int;

    {#IFDEF HAVE_DLOPEN}
    dlopenflags          : c_int;
    {#ENDIF HAVE_DLOPEN}

    builtins_copy        : pPyObject;
    import_func          : pPyObject;

    eval_frame           : _PyFrameEvalFunction;
  end;
  // ---------------------------------------------------------------------------------------------------------------------------------------
  Py_tracefunc = function(obj1: pPyObject; f: pPyFrameObject; i: c_int; obj2: pPyObject): c_int; cdecl;
  // -------------------------
  //p_PyErr_StackItem = ^_PyErr_StackItem;
  _PyErr_StackItem = {$IFNDEF CPUX64}packed{$ENDIF} record
    exc_type, exc_value, exc_traceback: pPyObject;
    previous_item: ^_PyErr_StackItem;
  end;
  // -------------------------
  PyThreadState = {$IFNDEF CPUX64}packed{$ENDIF} record
    prev                 : pPyThreadState;
    next                 : pPyThreadState;
    interp               : pPyInterpreterState;

    frame                : pPyFrameObject;
    recursion_depth      : c_int;
    overflowed           : c_char;
    recursion_critical   : c_char;

    stackcheck_counter   : c_int;

    tracing              : c_int;
    use_tracing          : c_int;

    c_profilefunc        : Py_tracefunc;
    c_tracefunc          : Py_tracefunc;
    c_profileobj         : pPyObject;
    c_traceobj           : pPyObject;

    curexc_type          : pPyObject;
    curexc_value         : pPyObject;
    curexc_traceback     : pPyObject;

    exc_state            : _PyErr_StackItem;
    exc_info             : _PyErr_StackItem;

    dict                 : pPyObject;

    gilstate_counter     : c_int;

    async_exc            : pPyObject;
    thread_id            : c_unsigned_long;

    trash_delete_nesting : c_int;
    trash_delete_later   : pPyObject;

    on_delete            : procedure(v: c_void);
    on_delete_data       : c_void;

    coroutine_origin_tracking_depth : c_int;

    coroutine_wrapper    : pPyObject;
    in_coroutine_wrapper : c_int;

    async_gen_firstiter  : pPyObject;
    async_gen_finalizer  : pPyObject;

    context              : pPyObject;
    context_ver          : uint64_t;

    id: uint64_t;
  end;
  // ---------------------------------------------------------------------------------------------------------------------------------------
  // frameobject.h
  PPyTryBlock = ^PyTryBlock;
  PyTryBlock = {$IFNDEF CPUX64}packed{$ENDIF} record
    b_type    : c_int;       // what kind of block this is
    b_handler : c_int;       // where to jump to find handler
    b_level   : c_int;       // value stack level to pop to
  end;
  // -------------------------
  // frameobject.h он же _frame
  PyFrameObject = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base         : PyVarObject;        //PyObject_VAR_HEAD

    f_back          : pPyFrameObject;
    f_code          : pPyCodeObject;
    f_builtins      : pPyObject;
    f_globals       : pPyObject;
    f_locals        : pPyObject;
    f_valuestack    : ^pPyObject;

    f_stacktop      : ^pPyObject;
    f_trace         : pPyObject;
    f_trace_lines   : c_char;
    f_trace_opcodes : c_char;

    f_gen           : pPyObject;

    f_lasti         : c_int;

    f_lineno        : c_int;
    f_iblock        : c_int;
    f_executing     : c_char;
    f_blockstack    : array[0..CO_MAXBLOCKS] of PyTryBlock;
    f_localsplus    : array[0..0] of pPyObject;
  end;

  // -------------------------
  // code.h
  PyCodeObject = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base : PyObject;                  //PyObject_HEAD

    co_argcount       : c_int;           // #arguments, except *args
    co_kwonlyargcount : c_int;
    co_nlocals        : c_int;           // #local variables
    co_stacksize      : c_int;           // #entries needed for evaluation stack
    co_flags          : c_int;           // CO_..., see below
    co_firstlineno    : c_int;
    co_code           : pPyObject;       // instruction opcodes (it hides a PyStringObject)
    co_consts         : pPyObject;       // list (constants used)
    co_names          : pPyObject;       // list of strings (names used)
    co_varnames       : pPyObject;       // tuple of strings (local variable names)
    co_freevars       : pPyObject;	     // tuple of strings (free variable names)
    co_cellvars       : pPyObject;       // tuple of strings (cell variable names)

    co_cell2arg       : Py_ssize_t;
    co_filename       : pPyObject;       // string (where it was loaded from)
    co_name           : pPyObject;       // string (name, for reference)
    co_lnotab         : pPyObject;

    co_zombieframe    : c_void;
    co_weakreflist    : pPyObject;

    co_extra          : c_void;

  end;

implementation

end.
