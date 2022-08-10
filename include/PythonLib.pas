unit PythonLib;

interface
uses c_types, object_h, moduleobject_h, pythread_h;
const
  PyLib = 'python39.dll';

var
  _Py_NoneStruct : pPyObject; //* Don't use this directly */
  //----------------------------------------------------------------------------------------------------------------------------------------
  PyArg_ParseTuple:               function (args: pPyObject; format: c_chars {;...}): c_int; cdecl varargs;                          // PyAPI_FUNC(int) PyArg_ParseTuple(PyObject *, const char *, ...);
  //PyArg_VaParse:                function (args: pPyObject; format: c_char; vargs: va_list): c_int; cdecl;                         // int PyArg_VaParse(PyObject *args, const char *format, va_list vargs)
  PyArg_ParseTupleAndKeywords:    function (args,kwrd: pPyObject; format: c_chars {;...}): c_int; cdecl varargs;                     // PyAPI_FUNC(int) PyArg_ParseTupleAndKeywords(PyObject *, PyObject *, const char *, char **, ...);
  Py_BuildValue:                  function (format: c_chars {;...}): pPyObject; cdecl varargs;                                       // PyAPI_FUNC(PyObject *) Py_BuildValue(const char *, ...);
  //----------------------------------------------------------------------------------------------------------------------------------------
  //PyModule_Create2:             function (def: pPyModuleDef; apiver: c_int): pPyObject; cdecl ;
  PyModule_AddObject:             function (module: pPyObject; name: c_chars; var value: pPyObject): c_int; cdecl ;                 // int PyModule_AddObject(PyObject *module, const char *name, PyObject *value)
  PyModuleDef_Init:               function (def: pPyModuleDef): pPyObject; cdecl;                                                   // PyObject * PyModuleDef_Init( PyModuleDef  * def )
  PyModule_AddFunctions:          function (module: pPyObject; functions: pPyMethodDef): c_int; cdecl;                              // PyAPI_FUNC(int) PyModule_AddFunctions(PyObject *module, PyMethodDef *functions);
  PyModule_AddStringConstant:     function (module: pPyObject; name: c_chars; value: c_chars): c_int; cdecl;                        // int PyModule_AddStringConstant(PyObject *module, const char *name, const char *value)
  PyModule_AddIntConstant:        function (module: pPyObject; name: c_chars; value: c_long): c_int; cdecl ;                        // int PyModule_AddIntConstant(PyObject *module, const char *name, long value)
  PyModule_FromDefAndSpec:        function (def: pPyModuleDef; spec: pPyObject): pPyObject;
  PyModule_FromDefAndSpec2:       function (def: pPyModuleDef; spec: pPyObject; module_api_version: c_int): pPyObject; cdecl;       // PyObject * PyModule_FromDefAndSpec2( PyModuleDef  * def , PyObject  * spec , int  module_api_version )

  //----------------------------------------------------------------------------------------------------------------------------------------
  PyErr_Clear:                    procedure();cdecl;                                                                                // void PyErr_Clear()
  PyErr_Print:                    procedure();cdecl;                                                                                // void PyErr_Print()
  PyErr_PrintEx:                  procedure(set_sys_last_vars: c_int);cdecl;                                                        // void PyErr_PrintEx( int  set_sys_last_vars )
  PyErr_SetString:                procedure(err_type: pPyObject; err_message: UTF8String);cdecl;                                    // void PyErr_SetString(PyObject *type, const char *message)
  PyErr_NewException:             function (const name: c_chars; base, dict: pPyObject): pPyObject; cdecl;                          // PyObject* PyErr_NewException(const char *name, PyObject *base, PyObject *dict)
  PyErr_NewExceptionWithDoc:      function (const name: c_chars; const doc: c_chars; base, dict: pPyObject): pPyObject; cdecl;      // PyObject * PyErr_NewExceptionWithDoc( const char  * name , const char  * doc , PyObject  * base , PyObject  * dict )
  PyErr_Occurred:                 function (): pPyObject; cdecl;                                                                    // PyObject * PyErr_Occurred( )
  PyErr_Fetch:                    procedure(ptype, pvalue, ptraceback: ppPyObject); cdecl;                                          // void PyErr_Fetch( PyObject  ** ptype , PyObject  ** pvalue , PyObject  ** ptraceback )
  //----------------------------------------------------------------------------------------------------------------------------------------
  PyBool_Type : pPyTypeObject; // также см PyObject_IsTrue
  PyBool_FromLong:                function (v: c_long): pPyObject; cdecl;                                                           // PyObject* PyBool_FromLong(long v)
  function  PyBool(b: Boolean): pPyObject;
  function  PyBool_Check(o: pPyObject): Boolean;

var
  //----------------------------------------------------------------------------------------------------------------------------------------
  Py_Initialize:                  procedure(); cdecl;
  Py_Finalize:                    procedure(); cdecl;
  //----------------------------------------------------------------------------------------------------------------------------------------
  // Type Objects
  // https://docs.python.org/3/c-api/type.html?highlight=pytype_issubtype#c.PyType_IsSubtype
  //------------------------------------------------------------------------------
  PyType_IsSubtype:               function(a, b: pPyTypeObject): c_int; cdecl;                                                          // int PyType_IsSubtype(PyTypeObject *a, PyTypeObject *b)
  //----------------------------------------------------------------------------------------------------------------------------------------
  // Importing Modules
  // https://docs.python.org/3/c-api/import.html?highlight=pyimport_importmodule#c.PyImport_ImportModule
  //------------------------------------------------------------------------------
  PyImport_ImportModule:          function (name: c_chars): pPyObject; cdecl;                                                           // PyImport_ImportModule(const char *name)

  //----------------------------------------------------------------------------------------------------------------------------------------
  // Object Protocol
  // https://docs.python.org/3/c-api/object.html?highlight=pyobject_typecheck
  //------------------------------------------------------------------------------
  PyObject_HasAttr:               function (o: pPyObject; const attr_name: c_chars): c_int; cdecl;                                      // int PyObject_HasAttr(PyObject *o, PyObject *attr_name)
  PyObject_HasAttrString:         function (o: pPyObject; const attr_name: c_chars): c_int; cdecl;                                      // int PyObject_HasAttrString(PyObject *o, const char *attr_name)
  PyObject_GetAttrString:         function (o: pPyObject; const attr_name: c_chars): pPyObject; cdecl;                                  // PyObject* PyObject_GetAttrString(PyObject *o, const char *attr_name)
  PyCallable_Check:               function (callable: pPyObject): c_int; cdecl;
  PyObject_CallObject:            function (callable: pPyObject; args: pPyObject): pPyObject; cdecl;                                    // PyObject* PyObject_CallObject(PyObject *callable, PyObject *args)
  PyObject_CallMethod:            function (o: pPyObject; const name: c_chars; const format: c_chars): pPyObject; cdecl varargs;        // PyObject* PyObject_CallMethod(PyObject *obj, const char *name, const char *format, ...)
  PyObject_IsTrue:                function (o: pPyObject): c_int; cdecl;                                                                //int PyObject_IsTrue(PyObject *o)                                                                                                                                    // int PyCallable_Check(PyObject *o)
  //----------------------------------------------------------------------------------------------------------------------------------------
  // Capsules (PyCapsule)
  // https://docs.python.org/3/c-api/capsule.html?highlight=pycapsule_new#c.PyCapsule_Destructor
  //------------------------------------------------------------------------------
type
  PyCapsule_Destructor = procedure(capsule: pPyObject);cdecl;
var
  PyCapsule_Type: pPyTypeObject;
  PyCapsule_New:                  function (pointr: c_void; const name: c_chars; destructor_: PyCapsule_Destructor): pPyObject; cdecl;  // PyObject* PyCapsule_New(void *pointer, const char *name, PyCapsule_Destructor destructor)
  PyCapsule_Import:               function (name: c_chars; no_block: c_int): c_void; cdecl;                                             // void* PyCapsule_Import(const char *name, int no_block)
  PyCapsule_GetPointer:           function (capsule: pPyObject; name: c_chars): c_void; cdecl;                                          // void* PyCapsule_GetPointer(PyObject *capsule, const char *name)
  PyCapsule_SetPointer:           function (capsule: pPyObject; pointr: c_void): c_int; cdecl;                                          // int PyCapsule_SetPointer(PyObject *capsule, void *pointer)
  PyCapsule_IsValid:              function (capsule: pPyObject; name: c_chars): c_int; cdecl;                                           // int PyCapsule_IsValid(PyObject *capsule, const char *name)
  //PyCapsule_CheckExact:         function (obj: pPyObject): Boolean;                                                                   // int PyCapsule_CheckExact(PyObject *p)
  PyCapsule_GetName:              function (capsule: pPyObject): c_chars; cdecl;                                                        // const char* PyCapsule_GetName(PyObject *capsule)
  function  PyCapsule_Check(o: pPyObject): Boolean;
var
  //----------------------------------------------------------------------------------------------------------------------------------------
  // List Objects (PyListObject)
  // https://docs.python.org/3/c-api/list.html?highlight=pylist#c.PyList_Append
  //------------------------------------------------------------------------------
  PyList_Type: pPyTypeObject;
  PyList_New:                     function (len: Py_ssize_t): pPyObject; cdecl;                                                     // PyObject* PyList_New(Py_ssize_t len))
  PyList_Size:                    function (list: pPyObject): Py_ssize_t; cdecl;                                                    // Py_ssize_t PyList_Size(PyObject *list)¶
  PyList_GetItem:                 function (list: pPyObject; index: Py_ssize_t): pPyObject; cdecl;                                  // PyObject* PyList_GetItem(PyObject *list, Py_ssize_t index)
  PyList_SetItem:                 function (list: pPyObject; index: Py_ssize_t; item: pPyObject): c_int; cdecl;                     // int PyList_SetItem(PyObject *list, Py_ssize_t index, PyObject *item)
  PyList_Insert:                  function (list: pPyObject; index: Py_ssize_t; item: pPyObject): c_int; cdecl;                     // int PyList_Insert(PyObject *list, Py_ssize_t index, PyObject *item)
  PyList_Append:                  function (list: pPyObject; item: pPyObject): c_int; cdecl;                                        // int PyList_Append(PyObject *list, PyObject *item)
  function  PyList_Check(o: pPyObject): Boolean;
var
  //----------------------------------------------------------------------------------------------------------------------------------------
  // THREADS
  //------------------------------------------------------------------------------
  PyEval_SaveThread:              function (): pPyThreadState; cdecl;                                                               // PyThreadState* PyEval_SaveThread()
  PyEval_RestoreThread:           procedure(tstate: pPyThreadState) cdecl;                                                          // void PyEval_RestoreThread(PyThreadState *tstate)
  PyThreadState_Get:              function (): pPyThreadState; cdecl;                                                               // PyThreadState * PyThreadState_Get( )
  PyThreadState_Swap:             function (tstate: pPyThreadState): pPyThreadState; cdecl;                                         // PyThreadState * PyThreadState_Swap( PyThreadState  * tstate )
  PyGILState_Ensure:              function (): PyGILstate_STATE; cdecl;                                                             // PyGILState_STATE PyGILState_Ensure()
  PyGILState_Release:             procedure(gilstate: PyGILstate_STATE) cdecl;                                                      // void PyGILState_Release(PyGILState_STATE)
  PyGILState_GetThisThreadState:  function (): pPyThreadState; cdecl;                                                               // PyThreadState * PyGILState_GetThisThreadState( )
  PyGILState_Check:               function (): c_int; cdecl;                                                                        // int PyGILState_Check( )
  PyInterpreterState_New:         function (): pPyInterpreterState; cdecl;                                                          // PyInterpreterState * PyInterpreterState_New( )
  PyInterpreterState_Clear:       procedure(interp: pPyInterpreterState); cdecl;                                                    // void PyInterpreterState_Clear( PyInterpreterState  * interp )
  PyInterpreterState_Delete:      procedure(interp: pPyInterpreterState); cdecl;                                                    // void PyInterpreterState_Delete( PyInterpreterState  * interp )
  PyThreadState_New:              function (interp: pPyInterpreterState): pPyThreadState; cdecl;                                    // PyThreadState * PyThreadState_New( PyInterpreterState  * interp )
  PyThreadState_Clear:            procedure(tstate: pPyThreadState); cdecl;                                                         // void PyThreadState_Clear( PyThreadState  * tstate )
  PyThreadState_Delete:           procedure(tstate: pPyThreadState); cdecl;                                                         // void PyThreadState_Clear( PyThreadState  * tstate )
  PyThreadState_SetAsyncExc:      function (id: c_unsigned_long; exc: pPyObject): c_int; cdecl;                                     // int PyThreadState_SetAsyncExc(unsigned long id, PyObject *exc)
  //PyEval_AcquireLock:           procedure(); cdecl;                                                                               // void PyEval_AcquireLock()
  //PyEval_ReleaseLock:           procedure(); cdecl;                                                                               // void PyEval_ReleaseLock()
  //----------------------------------------------------------------------------------------------------------------------------------------
  PyTuple_Type : pPyTypeObject;
  PyTuple_Size:                   function (p: pPyObject): Py_ssize_t; cdecl;                                                       // Py_ssize_t PyTuple_Size(PyObject *p)
  PyTuple_GetItem:                function (p: pPyObject; pos: Py_ssize_t): pPyObject; cdecl;                                      // PyObject* PyTuple_GetItem(PyObject *p, Py_ssize_t pos)
  function PyTuple_Check(o: pPyObject): Boolean;
  //----------------------------------------------------------------------------------------------------------------------------------------
var
  PyLong_Type : pPyTypeObject;
  PyLong_AsLong:                  function (pylong: pPyObject): c_long; cdecl;                                                      // long PyLong_AsLong(PyObject *obj)
  PyLong_AsLongLong:              function (pylong: pPyObject): c_long_long; cdecl;                                                 // long long PyLong_AsLongLong(PyObject *obj)
  PyLong_AsUnsignedLong:          function (pylong: pPyObject): c_unsigned_long; cdecl;                                             // unsigned long PyLong_AsUnsignedLong(PyObject *pylong)
  PyLong_AsUnsignedLongLong:      function (pylong: pPyObject): c_unsigned_long_long; cdecl;                                        // unsigned long long PyLong_AsUnsignedLongLong(PyObject *pylong)
  function PyLong_Check(o: pPyObject): Boolean;
  //----------------------------------------------------------------------------------------------------------------------------------------
var
  PyFloat_Type : pPyTypeObject;
  PyFloat_AsDouble:               function (pyfloat: pPyObject): c_double; cdecl;                                                   // double PyFloat_AsDouble(PyObject *pyfloat)
  function PyFloat_Check(o: pPyObject): Boolean;
  //----------------------------------------------------------------------------------------------------------------------------------------
var
  PyBytes_Type : pPyTypeObject;
  PyBytes_AsString:               function (o: pPyObject): c_chars; cdecl;                                                          // char* PyBytes_AsString(PyObject *o)
  function PyBytes_Check(o: pPyObject): Boolean;
  //----------------------------------------------------------------------------------------------------------------------------------------
var
  PyUnicode_Type : pPyTypeObject;
  PyUnicode_AsUTF8String:         function (unicode: pPyObject): pPyObject; cdecl;                                                  // PyObject* PyUnicode_AsUTF8String(PyObject *unicode)
  PyUnicode_AsUTF8:               function (unicode: pPyObject): c_chars; cdecl;                                                 // const char* PyUnicode_AsUTF8(PyObject *unicode)
  PyUnicode_AsUTF32String:        function (unicode: pPyObject): pPyObject; cdecl;                                                  // PyObject* PyUnicode_AsUTF32String(PyObject *unicode)
  function PyUnicode_Check(o: pPyObject): Boolean;

//------------------------------------------------------------------------------------------------------------------------------------------
function PyListOrTuple_Size(p: pPyObject): Py_ssize_t;
function PyListOrTuple_GetItem(p: pPyObject; pos: Py_ssize_t): pPyObject;
//------------------------------------------------------------------------------------------------------------------------------------------
function  PyObject_TypeCheck(obj: pPyObject; type_: pPyTypeObject): Boolean;
procedure Py_INCREF (const o: pPyObject);inline;
procedure Py_DECREF (const o: pPyObject);inline;
procedure Py_XINCREF(const o: pPyObject);inline;
procedure Py_XDECREF(const o: pPyObject);inline;
procedure Py_CLEAR  (var   o: pPyObject);inline;
function  Py_None   (): pPyObject       ;inline;

function PyNone_Check(o: pPyObject): Boolean;
//------------------------------------------------------------------------------
implementation
uses
  _tools_,
  {$IFDEF MSWINDOWS}Winapi.Windows,{$ENDIF}
  System.SysUtils;
//----------------------------------------------------------------------------------------------------------------------
function  PyBool(b: Boolean): pPyObject;
begin
  Result := PyBool_FromLong(c_int(b));
end;

function  PyBool_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyBool_Type);
end;
//-------------------------------------------------
function  PyCapsule_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyCapsule_Type);
end;

function  PyList_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyList_Type);
end;

function PyTuple_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyTuple_Type);
end;

function PyLong_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyLong_Type);
end;

function PyFloat_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyFloat_Type);
end;

function PyBytes_Check(o: pPyObject): Boolean;
begin
   Result := PyObject_TypeCheck(o, PyBytes_Type);
end;

function PyUnicode_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyUnicode_Type);
end;
//-------------------------------------------------
function PyListOrTuple_Size(p: pPyObject): Py_ssize_t;
begin
  if PyList_Check(p) then
    Result := PyList_Size(p)
  else
    Result := PyTuple_Size(p)
end;

function PyListOrTuple_GetItem(p: pPyObject; pos: Py_ssize_t): pPyObject;
begin
  if PyList_Check(p) then
    Result := PyList_GetItem(p, pos)
  else
    Result := PyTuple_GetItem(p, pos)
end;
//-------------------------------------------------
function PyObject_TypeCheck(obj: pPyObject; type_: pPyTypeObject): Boolean;
begin
  Result := Assigned(obj) and (obj.ob_type = type_);
  if not Result and Assigned(obj) and Assigned(type_) then
    Result := PyType_IsSubtype(obj.ob_type, type_) = 1;
end;
//-------------------------------------------------
procedure Py_INCREF;
begin
  Inc(o.ob_refcnt);
end;

procedure Py_DECREF;
begin
  if o.ob_refcnt > 0 then
    Dec(o.ob_refcnt);
  if o.ob_refcnt <= 0 then
  begin
    o.ob_type.tp_dealloc(o);
  end;
end;

procedure Py_XINCREF;
begin
  if o <> nil then Py_INCREF(o);
end;

procedure Py_XDECREF;
begin
  if o <> nil then Py_DECREF(o);
end;

procedure Py_CLEAR;
begin
  if o <> nil then
  begin
    Py_DECREF(o);
    o := nil;
  end;
end;


function Py_None;
begin
  //Result := Py_BuildValue('');
  Result := _Py_NoneStruct
end;
function PyNone_Check(o: pPyObject): Boolean;
begin
  Result := o = Py_None();
end;
//----------------------------------------------------------------------------------------------------------------------
var DllHandle: HMODULE;
function Import(FuncName: string): Pointer;
begin
  Result := GetProcAddress(DLLHandle, PChar(FuncName));
  if not Assigned(Result) then
  begin
    var err := GetLastError;
    raise Exception.CreateFmtHelp('Ошибка при загрузки функции "%s" (%d)', [FuncName, err], err);
  end;
end;
//----------------------------------------------------------------------------------------------------------------------
initialization
  DllHandle := SafeLoadLibrary(PyLib);
  try
    //------------------------------------------------------------------------------------------------------------------
    if DllHandle=0 then
    begin
      var err := GetLastError;
      raise Exception.CreateFmtHelp('При загрузки DLL "%s" возникла ошибка: %s (#%d)', [PyLib, SysErrorMessage(err), err], err);
    end;
    //------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------
    _Py_NoneStruct                  := Import('_Py_NoneStruct');
    //---------------------------
    PyArg_ParseTuple                := Import('PyArg_ParseTuple');
    //PyArg_VaParse                 := Import('PyArg_VaParse');
    PyArg_ParseTupleAndKeywords     := Import('PyArg_ParseTupleAndKeywords');
    Py_BuildValue                   := Import('Py_BuildValue');
    //---------------------------
    PyModule_AddObject              := Import('PyModule_AddObject');
    PyModuleDef_Init                := Import('PyModuleDef_Init');
    PyModule_AddFunctions           := Import('PyModule_AddFunctions');
    PyModule_AddStringConstant      := Import('PyModule_AddStringConstant');
    PyModule_AddIntConstant         := Import('PyModule_AddIntConstant');
    PyModule_FromDefAndSpec2        := Import('PyModule_FromDefAndSpec2');
    //---------------------------
    PyImport_ImportModule           := Import('PyImport_ImportModule');
    //---------------------------
    PyErr_Clear                     := Import('PyErr_Clear');
    PyErr_Print                     := Import('PyErr_Print');
    PyErr_PrintEx                   := Import('PyErr_PrintEx');
    PyErr_SetString                 := Import('PyErr_SetString');
    PyErr_NewException              := Import('PyErr_NewException');
    PyErr_NewExceptionWithDoc       := Import('PyErr_NewExceptionWithDoc');
    PyErr_Occurred                  := Import('PyErr_Occurred');
    PyErr_Fetch                     := Import('PyErr_Fetch');
    //---------------------------
    PyBool_Type                     := Import('PyBool_Type');
    PyBool_FromLong                 := Import('PyBool_FromLong');
    //---------------------------
    Py_Initialize                   := Import('Py_Initialize');
    Py_Finalize                     := Import('Py_Finalize');
    //---------------------------
    PyObject_HasAttr                := Import('PyObject_HasAttr');
    PyObject_HasAttrString          := Import('PyObject_HasAttrString');
    PyObject_GetAttrString          := Import('PyObject_GetAttrString');
    PyCallable_Check                := Import('PyCallable_Check');
    PyObject_CallObject             := Import('PyObject_CallObject');
    PyObject_CallMethod             := Import('PyObject_CallMethod');
    PyObject_IsTrue                 := Import('PyObject_IsTrue');
    //---------------------------
    PyType_IsSubtype                := Import('PyType_IsSubtype');
    //---------------------------
    PyCapsule_Type                  := Import('PyCapsule_Type');
    PyCapsule_New                   := Import('PyCapsule_New');
    PyCapsule_Import                := Import('PyCapsule_Import');
    PyCapsule_GetPointer            := Import('PyCapsule_GetPointer');
    PyCapsule_SetPointer            := Import('PyCapsule_SetPointer');
    PyCapsule_IsValid               := Import('PyCapsule_IsValid');
    PyCapsule_GetName               := Import('PyCapsule_GetName');
    //---------------------------
    PyList_Type                     := Import('PyList_Type');
    PyList_New                      := Import('PyList_New');
    PyList_Size                     := Import('PyList_Size');
    PyList_GetItem                  := Import('PyList_GetItem');
    PyList_SetItem                  := Import('PyList_SetItem');
    PyList_Insert                   := Import('PyList_Insert');
    PyList_Append                   := Import('PyList_Append');
    //---------------------------
    PyEval_SaveThread               := Import('PyEval_SaveThread');
    PyEval_RestoreThread            := Import('PyEval_RestoreThread');
    PyThreadState_Get               := Import('PyThreadState_Get');
    PyThreadState_Swap              := Import('PyThreadState_Swap');
    PyGILState_Ensure               := Import('PyGILState_Ensure');
    PyGILState_Release              := Import('PyGILState_Release');
    PyGILState_GetThisThreadState   := Import('PyGILState_GetThisThreadState');
    PyGILState_Check                := Import('PyGILState_Check');
    PyInterpreterState_New          := Import('PyInterpreterState_New');
    PyInterpreterState_Clear        := Import('PyInterpreterState_Clear');
    PyInterpreterState_Delete       := Import('PyInterpreterState_Delete');
    PyThreadState_New               := Import('PyThreadState_New');
    PyThreadState_Clear             := Import('PyThreadState_Clear');
    PyThreadState_Delete            := Import('PyThreadState_Delete');
    PyThreadState_SetAsyncExc       := Import('PyThreadState_SetAsyncExc');
    //PyEval_AcquireLock            := Import('PyEval_AcquireLock');//Deprecated
    //PyEval_ReleaseLock            := Import('PyEval_ReleaseLock');//Deprecated
    //---------------------------
    PyTuple_Type                    := Import('PyTuple_Type');
    PyTuple_Size                    := Import('PyTuple_Size');
    PyTuple_GetItem                 := Import('PyTuple_GetItem');
    //---------------------------
    PyLong_Type                     := Import('PyLong_Type');
    PyLong_AsLong                   := Import('PyLong_AsLong');
    PyLong_AsLongLong               := Import('PyLong_AsLongLong');
    PyLong_AsUnsignedLong           := Import('PyLong_AsUnsignedLong');
    PyLong_AsUnsignedLongLong       := Import('PyLong_AsUnsignedLongLong');
    //---------------------------
    PyFloat_Type                    := Import('PyFloat_Type');
    PyFloat_AsDouble                := Import('PyFloat_AsDouble');
    //---------------------------
    PyBytes_Type                    := Import('PyBytes_Type');
    PyBytes_AsString                := Import('PyBytes_AsString');
    //---------------------------
    PyUnicode_Type                  := Import('PyUnicode_Type');
    PyUnicode_AsUTF8String          := Import('PyUnicode_AsUTF8String');
    PyUnicode_AsUTF8                := Import('PyUnicode_AsUTF8');
    PyUnicode_AsUTF32String         := Import('PyUnicode_AsUTF32String');
    //------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------
    //------------------------------------------------------------------------------------------------------------------
    //Py_Initialize;
  except
    on e: Exception do begin
      MesBox(e.Message, Format('Ошибка загрузка DLL "%s"',[PyLib]) )
    end;
  end;
finalization
  //Py_Finalize;
  FreeLibrary(DllHandle);
end.
