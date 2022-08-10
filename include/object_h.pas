unit object_h;

interface
uses c_types;

type
  //----------------------------------------------------------------------------
  Py_ssize_t = type NativeInt;
  Py_hash_t  = NativeInt;
  //----------------------------------------------------------------------------
  pPyObject          = ^PyObject;
  ppPyObject         = ^pPyObject;

  pPyTypeObject      = ^PyTypeObject;
  pPyAsyncMethods    = ^PyAsyncMethods;
  pPyNumberMethods   = ^PyNumberMethods;
  pPySequenceMethods = ^PySequenceMethods;
  pPyMappingMethods  = ^PyMappingMethods;
  pPy_buffer         = ^Py_buffer;
  pPyBufferProcs     = ^PyBufferProcs;
  pPyMethodDef       = ^PyMethodDef;
  pPyMemberDef       = ^PyMemberDef;
  pPyGetSetDef       = ^PyGetSetDef;


  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  PyObject = {$IFNDEF CPUX64}packed{$ENDIF} record
    //_PyObject_HEAD_EXTRA  //#define _PyObject_HEAD_EXTRA \ struct _object *_ob_next; \ struct _object *_ob_prev;
    //_ob_next  : pPyObject;
    //_ob_prev  : pPyObject;
    //_ob_next  : _int;
    //_ob_prev  : _int;
    ob_refcnt : Py_ssize_t;
    ob_type   : pPyTypeObject;
  end;
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------

  _unaryfunc = function(obj: pPyObject): pPyObject; cdecl; //typedef PyObject * (*unaryfunc)(PyObject *);

  PyAsyncMethods = {$IFNDEF CPUX64}packed{$ENDIF} record
    am_await : _unaryfunc; //    unaryfunc am_await;
    am_aiter : _unaryfunc; //    unaryfunc am_aiter;
    am_anext : _unaryfunc; //    unaryfunc am_anext;
  end;

  //----------------------------------------------------------------------------
  _binaryfunc  = function(obj1,obj2: pPyObject): pPyObject; cdecl;      //typedef PyObject * (*binaryfunc)(PyObject *, PyObject *);
  _ternaryfunc = function(obj1,obj2,obj3: pPyObject): pPyObject; cdecl; //typedef PyObject * (*ternaryfunc)(PyObject *, PyObject *, PyObject *);
  _inquiry     = function(obj: pPyObject): c_int; cdecl;                //typedef int (*inquiry)(PyObject *);

  PyNumberMethods = {$IFNDEF CPUX64}packed{$ENDIF} record
    nb_add                  : _binaryfunc;    //    binaryfunc nb_add;
    nb_subtract             : _binaryfunc;    //    binaryfunc nb_subtract;
    nb_multiply             : _binaryfunc;    //    binaryfunc nb_multiply;
    nb_remainder            : _binaryfunc;    //    binaryfunc nb_remainder;
    nb_divmod               : _binaryfunc;    //    binaryfunc nb_divmod;
    nb_power                : _ternaryfunc;   //    ternaryfunc nb_power;
    nb_negative             : _unaryfunc;     //    unaryfunc nb_negative;
    nb_positive             : _unaryfunc;     //    unaryfunc nb_positive;
    nb_absolute             : _unaryfunc;     //    unaryfunc nb_absolute;
    nb_bool                 : _inquiry;       //    inquiry nb_bool;
    nb_invert               : _unaryfunc;     //    unaryfunc nb_invert;
    nb_lshift               : _binaryfunc;    //    binaryfunc nb_lshift;
    nb_rshift               : _binaryfunc;    //    binaryfunc nb_rshift;
    nb_and                  : _binaryfunc;    //    binaryfunc nb_and;
    nb_xor                  : _binaryfunc;    //    binaryfunc nb_xor;
    nb_or                   : _binaryfunc;    //    binaryfunc nb_or;
    nb_int                  : _unaryfunc;     //    unaryfunc nb_int;
    nb_reserved             : c_void;         //    void *nb_reserved;  /* the slot formerly known as nb_long */
    nb_float                : _unaryfunc;     //    unaryfunc nb_float;

    nb_inplace_add          : _binaryfunc;    //    binaryfunc nb_inplace_add;
    nb_inplace_subtract     : _binaryfunc;    //    binaryfunc nb_inplace_subtract;
    nb_inplace_multiply     : _binaryfunc;    //    binaryfunc nb_inplace_multiply;
    nb_inplace_remainder    : _binaryfunc;    //    binaryfunc nb_inplace_remainder;
    nb_inplace_power        : _ternaryfunc;   //    ternaryfunc nb_inplace_power;
    nb_inplace_lshift       : _binaryfunc;    //    binaryfunc nb_inplace_lshift;
    nb_inplace_rshift       : _binaryfunc;    //    binaryfunc nb_inplace_rshift;
    nb_inplace_and          : _binaryfunc;    //    binaryfunc nb_inplace_and;
    nb_inplace_xor          : _binaryfunc;    //    binaryfunc nb_inplace_xor;
    nb_inplace_or           : _binaryfunc;    //    binaryfunc nb_inplace_or;

    nb_floor_divide         : _binaryfunc;    //    binaryfunc nb_floor_divide;
    nb_true_divide          : _binaryfunc;    //    binaryfunc nb_true_divide;
    nb_inplace_floor_divide : _binaryfunc;    //    binaryfunc nb_inplace_floor_divide;
    nb_inplace_true_divide  : _binaryfunc;    //    binaryfunc nb_inplace_true_divide;

    nb_index : _unaryfunc;                    //    unaryfunc nb_index;

    nb_matrix_multiply : _binaryfunc;         //    binaryfunc nb_matrix_multiply;
    nb_inplace_matrix_multiply : _binaryfunc; //    binaryfunc nb_inplace_matrix_multiply;
  end;

  //----------------------------------------------------------------------------
  _lenfunc         = function(obj: pPyObject): Py_ssize_t; cdecl;                            //typedef Py_ssize_t (*lenfunc)(PyObject *);
  _ssizeargfunc    = function(obj: pPyObject; i: Py_ssize_t): pPyObject; cdecl;              //typedef PyObject *(*ssizeargfunc)(PyObject *, Py_ssize_t);
  _ssizeobjargproc = function(obj1: pPyObject; i: Py_ssize_t; obj2: pPyObject): c_int; cdecl;//typedef int(*ssizeobjargproc)(PyObject *, Py_ssize_t, PyObject *);
  _objobjproc      = function(obj1,obj2: pPyObject): pPyObject; cdecl;                       //typedef int (*objobjproc)(PyObject *, PyObject *);

  PySequenceMethods = {$IFNDEF CPUX64}packed{$ENDIF} record
    sq_length         : _lenfunc;         //    lenfunc sq_length;
    sq_concat         : _binaryfunc;      //    binaryfunc sq_concat;
    sq_repeat         : _ssizeargfunc;    //    ssizeargfunc sq_repeat;
    sq_item           : _ssizeargfunc;    //    ssizeargfunc sq_item;
    was_sq_slice      : c_void ;          //    void *was_sq_slice;
    sq_ass_item       : _ssizeobjargproc; //    ssizeobjargproc sq_ass_item;
    was_sq_ass_slice  : c_void;           //    void *was_sq_ass_slice;
    sq_contains       : _objobjproc;      //    objobjproc sq_contains;

    sq_inplace_concat : _binaryfunc;      //    binaryfunc sq_inplace_concat;
    sq_inplace_repeat : _ssizeargfunc;    //    ssizeargfunc sq_inplace_repeat;
  end;

  //----------------------------------------------------------------------------
  _objobjargproc   = function(obj1,obj2,obj3: pPyObject): pPyObject; cdecl; //typedef int(*objobjargproc)(PyObject *, PyObject *, PyObject *);

  PyMappingMethods = {$IFNDEF CPUX64}packed{$ENDIF} record
    mp_length        : _lenfunc;       //    lenfunc mp_length;
    mp_subscript     : _binaryfunc;    //    binaryfunc mp_subscript;
    mp_ass_subscript : _objobjargproc; //    objobjargproc mp_ass_subscript;
  end;

  //----------------------------------------------------------------------------
  Py_buffer = {$IFNDEF CPUX64}packed{$ENDIF} record
    buf        : c_void;       //void *buf;
    odj        : pPyObject;    //PyObject *obj;        /* owned reference */
    len        : Py_ssize_t;   //Py_ssize_t len;
    itemsize   : Py_ssize_t;   //Py_ssize_t itemsize;  /* This is Py_ssize_t so it can be pointed to by strides in simple case.*/
    readonly   : c_int;        //int readonly;
    ndim       : c_int;        //int ndim;
    format     : c_chars;      //char *format;
    shape      : ^Py_ssize_t;  //Py_ssize_t *shape;
    strides    : ^Py_ssize_t;  //Py_ssize_t *strides;
    suboffsets : ^Py_ssize_t;  //Py_ssize_t *suboffsets;
    internal   : c_void;       //void *internal;
  end;

  //----------------------------------------------------------------------------
  _getbufferproc     = function(obj: pPyObject; buf: pPy_buffer; i: c_int): c_int; cdecl;  //typedef int (*getbufferproc)(PyObject *, Py_buffer *, int);
  _releasebufferproc = procedure(obj: pPyObject; buf: pPy_buffer); cdecl;                  //typedef void (*releasebufferproc)(PyObject *, Py_buffer *);

  PyBufferProcs = {$IFNDEF CPUX64}packed{$ENDIF} record
    bf_getbuffer     : _getbufferproc;     //     getbufferproc bf_getbuffer;
    bf_releasebuffer : _releasebufferproc; //     releasebufferproc bf_releasebuffer;
  end;

  //----------------------------------------------------------------------------
  // methodobject.h
  PyCFunction = function(self, args: pPyObject): PPyObject; cdecl; //typedef PyObject *(*PyCFunction)(PyObject *, PyObject *);

  PyMethodDef = {$IFNDEF CPUX64}packed{$ENDIF} record
    ml_name  :  c_chars;      //    const char  *ml_name;   /* The name of the built-in function/method */
    ml_meth  :  PyCFunction;  //    PyCFunction ml_meth;    /* The C function that implements it */
    ml_flags :  c_int;        //    int         ml_flags;   /* Combination of METH_xxx flags, which mostly  describe the args expected by the C func */
    //ml_doc  :  c_chars;      //    const char  *ml_doc;    /* The __doc__ attribute, or NULL */
    ml_doc  :  UTF8String;
    //ml_doc  :  c_charsUTF8;
  end;

  //----------------------------------------------------------------------------
  // structmember.h
  PyMemberDef = {$IFNDEF CPUX64}packed{$ENDIF} record
    name   : c_chars;     //    const char *name;
    type_  : c_int;       //    int type;
    offset : Py_ssize_t;  //    Py_ssize_t offset;
    flags  : c_int;       //    int flags;
    doc    : c_chars;     //    const char *doc;
  end;

  //----------------------------------------------------------------------------
  _getter = function(obj: pPyObject; context: c_void): pPyObject;          //typedef PyObject *(*getter)(PyObject *, void *);
  _setter = function(obj,value: pPyObject; context: c_void): c_int; cdecl; //typedef int (*setter)(PyObject *, PyObject *, void *);

  PyGetSetDef = {$IFNDEF CPUX64}packed{$ENDIF} record
    name    : c_chars;    //    const char *name;
    get     : _getter;    //    getter get;
    set_    : _setter;    //    setter set;
    doc     : c_chars;    //    const char *doc;
    closure : c_void;     //    void *closure;
  end;

  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  //----------------------------------------------------------------------------
  _destructor   = procedure(obj: pPyObject); cdecl;                                             //typedef void (*destructor)(PyObject *);
  _printfunc    = function (obj: pPyObject; var f: file; i: c_int): c_int; cdecl;               //typedef int (*printfunc)(PyObject *, FILE *, int);
  _getattrfunc  = function (obj: pPyObject; name: c_chars): pPyObject; cdecl;                    //typedef PyObject *(*getattrfunc)(PyObject *, char *);
  _setattrfunc  = function (obj1: pPyObject; name: c_chars; obj2: pPyObject): c_int; cdecl;      //typedef int (*setattrfunc)(PyObject *, char *, PyObject *);
  _reprfunc     = function (obj: pPyObject): pPyObject; cdecl;                                  //typedef PyObject *(*reprfunc)(PyObject *);
  _hashfunc     = function (obj: pPyObject): Py_hash_t; cdecl;                                  //typedef Py_hash_t (*hashfunc)(PyObject *);
  _getattrofunc = function (obj1,obj2: pPyObject): pPyObject; cdecl;                            //typedef PyObject *(*getattrofunc)(PyObject *, PyObject *);
  _setattrofunc = function (obj1,obj2,obj3: pPyObject): c_int; cdecl;                           //typedef int (*setattrofunc)(PyObject *, PyObject *, PyObject *);
  _visitproc    = function (obj1: pPyObject; p: c_void): c_int; cdecl;                          //typedef int (*visitproc)(PyObject *, void *);
  _traverseproc = function (obj: pPyObject; v: _visitproc; p: c_void): c_int; cdecl;            //typedef int (*traverseproc)(PyObject *, visitproc, void *);
  _richcmpfunc  = function (obj1,obj2: pPyObject; i: c_int): pPyObject; cdecl;                  //typedef PyObject *(*richcmpfunc) (PyObject *, PyObject *, int);
  _getiterfunc  = function (obj: pPyObject): pPyObject; cdecl;                                  //typedef PyObject *(*getiterfunc) (PyObject *);
  _iternextfunc = function (obj: pPyObject): pPyObject; cdecl;                                  //typedef PyObject *(*iternextfunc) (PyObject *);

  _descrgetfunc = function (obj1, obj2, obj3: pPyObject): pPyObject; cdecl;                     //typedef PyObject *(*descrgetfunc) (PyObject *, PyObject *, PyObject *);
  _descrsetfunc = function (obj1, obj2, obj3: pPyObject): c_int; cdecl;                         //typedef int (*descrsetfunc) (PyObject *, PyObject *, PyObject *);
  _initproc     = function (self, args, kwds: pPyObject): c_int; cdecl;                         //typedef int (*initproc)(PyObject *, PyObject *, PyObject *);
  _newfunc      = function (subtype: pPyTypeObject; args, kwds: pPyObject): pPyObject; cdecl;   //typedef PyObject *(*newfunc)(struct _typeobject *, PyObject *, PyObject *);
  _allocfunc    = function (self: pPyTypeObject; nitems: Py_ssize_t): pPyObject; cdecl;         //typedef PyObject *(*allocfunc)(struct _typeobject *, Py_ssize_t);
  _freefunc     = procedure(); cdecl;                                                           //typedef void (*freefunc)(void *);

  PyVarObject = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base : PyObject;              //PyObject ob_base;
    ob_size : Py_ssize_t;            //Py_ssize_t ob_size; /* Number of items in variable part */
  end;

  PyTypeObject = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base                   : PyVarObject;//    PyObject_VAR_HEAD // #define PyObject_VAR_HEAD      PyVarObject ob_base;

    tp_name                   : c_chars;          //    const char *tp_name; /* For printing, in format "<module>.<name>" */
    tp_basicsize, tp_itemsize : Py_ssize_t;      //    Py_ssize_t tp_basicsize, tp_itemsize; /* For allocation */

    //* Methods to implement standard operations */

    tp_dealloc        : _destructor;             //    destructor tp_dealloc;
    tp_print          : _printfunc;              //    printfunc tp_print;
    tp_getattr        : _getattrfunc;            //    getattrfunc tp_getattr;
    tp_setattr        : _setattrfunc;            //    setattrfunc tp_setattr;
    tp_as_async       : pPyAsyncMethods;         //    PyAsyncMethods *tp_as_async; /* formerly known as tp_compare (Python 2) or tp_reserved (Python 3) */
    tp_repr           : _reprfunc;               //    reprfunc tp_repr;

    //* Method suites for standard classes */

    tp_as_number      : pPyNumberMethods;        //    PyNumberMethods *tp_as_number;
    tp_as_sequence    : pPySequenceMethods;      //    PySequenceMethods *tp_as_sequence;
    tp_as_mapping     : PyMappingMethods;        //    PyMappingMethods *tp_as_mapping;

    //* More standard operations (here for binary compatibility) */

    tp_hash           : _hashfunc;               //    hashfunc tp_hash;
    tp_call           : _ternaryfunc;            //    ternaryfunc tp_call;
    tp_str            : _reprfunc;               //    reprfunc tp_str;
    tp_getattro       : _getattrofunc;           //    getattrofunc tp_getattro;
    tp_setattro       : _setattrofunc;           //    setattrofunc tp_setattro;

    //* Functions to access object as input/output buffer */
    tp_as_buffer      : pPyBufferProcs;          //    PyBufferProcs *tp_as_buffer;

    //* Flags to define presence of optional/expanded features */
    tp_flags          : c_unsigned_long;         //    unsigned long tp_flags;

    tp_doc            : c_chars;                  //    const char *tp_doc; /* Documentation string */

    //* Assigned meaning in release 2.0 */
    //* call function for all accessible objects */
    tp_traverse       : _traverseproc;           //    traverseproc tp_traverse;

    //* delete references to contained objects */
    tp_clear          : _inquiry;                //    inquiry tp_clear;

    //* Assigned meaning in release 2.1 */
    //* rich comparisons */
    tp_richcompare    : _richcmpfunc;            //    richcmpfunc tp_richcompare;

    //* weak reference enabler */
    tp_weaklistoffset : Py_ssize_t;              //    Py_ssize_t tp_weaklistoffset;

    //* Iterators */
    tp_iter           : _getiterfunc;            //    getiterfunc tp_iter;
    tp_iternext       : _iternextfunc;           //    iternextfunc tp_iternext;

    //* Attribute descriptor and subclassing stuff */
    tp_methods        : pPyMethodDef;            //    struct PyMethodDef *tp_methods;
    tp_members        : pPyMemberDef;            //    struct PyMemberDef *tp_members;
    tp_getset         : pPyGetSetDef;            //    struct PyGetSetDef *tp_getset;
    tp_base           : pPyTypeObject;           //    struct _typeobject *tp_base;
    tp_dict           : pPyObject;               //    PyObject *tp_dict;
    tp_descr_get      : _descrgetfunc;           //    descrgetfunc tp_descr_get;
    tp_descr_set      : _descrsetfunc;           //    descrsetfunc tp_descr_set;
    tp_dictoffset     : Py_ssize_t;              //    Py_ssize_t tp_dictoffset;
    tp_init           : _initproc;               //    initproc tp_init;
    tp_alloc          : _allocfunc;              //    allocfunc tp_alloc;
    tp_new            : _newfunc;                //    newfunc tp_new;
    tp_free           : _freefunc;               //    freefunc tp_free; /* Low-level free-memory routine */
    tp_is_gc          : _inquiry;                //    inquiry tp_is_gc; /* For PyObject_IS_GC */
    tp_bases          : pPyObject;               //    PyObject *tp_bases;
    tp_mro            : pPyObject;               //    PyObject *tp_mro; /* method resolution order */
    tp_cache          : pPyObject;               //    PyObject *tp_cache;
    tp_subclasses     : pPyObject;               //    PyObject *tp_subclasses;
    tp_weaklist       : pPyObject;               //    PyObject *tp_weaklist;
    tp_del            : _destructor;             //    destructor tp_del;

    //* Type attribute cache version tag. Added in version 2.6 */
    tp_version_tag    : c_unsigned_int;          //    unsigned int tp_version_tag;
    tp_finalize       : _destructor;             //    destructor tp_finalize;

//    {$IFDEF COUNT_ALLOCS}                        //#ifdef COUNT_ALLOCS
//       //* these must be last and never explicitly initialized */
//       tp_allocs      : Py_ssize_t;              //    Py_ssize_t tp_allocs;
//       tp_frees       : Py_ssize_t;              //    Py_ssize_t tp_frees;
//       tp_maxalloc    : Py_ssize_t;              //    Py_ssize_t tp_maxalloc;
//       tp_prev        : pPyTypeObject;           //    struct _typeobject *tp_prev;
//       tp_next        : pPyTypeObject;           //    struct _typeobject *tp_next;
//    {$ENDIF}                                     //#endif
  end;
//------------------------------------------------------------------------------
const
  PyMethodDef_NULL: PyMethodDef = (
    ml_name: nil;
    ml_meth: nil;
    ml_flags: 0;
    ml_doc: '';
    //ml_doc: nil;
  );
//------------------------------------------------------------------------------
implementation

end.
