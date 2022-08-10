unit moduleobject_h;

interface
uses object_h, c_types;

type
  pPyModuleDef       = ^PyModuleDef;
  pPyModuleDef_Slot  = ^PyModuleDef_Slot;
  //pPyModuleDef_Slot  = ^TArr_PyModuleDef_Slot;

  //----------------------------------------------------------------------------
  PyModuleDef_Slot = {$IFNDEF CPUX64}packed{$ENDIF} record
    slot  : c_int;                           //    int slot;
    value : c_void;                          //    void *value;
  end;
  //TArr_PyModuleDef_Slot = array[0..$FFFF] of PyModuleDef_Slot;
  //----------------------------------------------------------------------------
  (**)
  PyModuleDef_Base = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base : PyObject;                      //  PyObject_HEAD //#define PyObject_HEAD                   PyObject ob_base;
    m_init  : function(): pPyObject; cdecl;  //  PyObject* (*m_init)(void);
    m_index : Py_ssize_t;                    //  Py_ssize_t m_index;
    m_copy  : pPyObject;                     //  PyObject* m_copy;
  end;

  //----------------------------------------------------------------------------
  PyModuleDef = {$IFNDEF CPUX64}packed{$ENDIF} record
    m_base     : PyModuleDef_Base;           //  PyModuleDef_Base m_base;
    m_name     : c_chars;                    //  const char* m_name;
    m_doc      : c_chars;                    //  const char* m_doc;
    m_size     : Py_ssize_t;                 //  Py_ssize_t m_size;
    m_methods  : pPyMethodDef;               //  PyMethodDef *m_methods;
    m_slots    : pPyModuleDef_Slot;          //  struct PyModuleDef_Slot* m_slots;
    m_traverse : _traverseproc;              //  traverseproc m_traverse;
    m_clear    : _inquiry;                   //  inquiry m_clear;
    m_free     : _freefunc;                  //  freefunc m_free;
  end;

  //----------------------------------------------------------------------------
const
  PyModuleDef_Slot_NULL : PyModuleDef_Slot = (slot: 0; value: nil);
  //----------------------------------------------------------------------------
  Py_mod_create = 1; //#define Py_mod_create 1
  Py_mod_exec   = 2; //#define Py_mod_exec 2
  //----------------------------------------------------------------------------
  PyModuleDef_HEAD_INIT: PyModuleDef_Base =
  (
    ob_base :
    (
      ob_refcnt : 1;
      ob_type   : nil;
    );
    m_init  : nil;
    m_index : 0;
    m_copy  : nil;
  );
  //----------------------------------------------------------------------------
implementation

end.
