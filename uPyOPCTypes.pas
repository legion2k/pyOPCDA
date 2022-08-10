unit uPyOPCTypes;

interface
uses {$I 'include\#define_Python.h'};
type
  TInterface = record
    Intrfc : IUnknown;
  end;
  PInterface = ^TInterface;
  TObj = record
    Obj : TObject;
  end;
  PObj = ^TObj;
  TPointer = record
    void : Pointer;
  end;
  PPointer = ^TPointer;

function convert_IUnknownToPyobj(const obj: PInterface): pPyObject; cdecl;
function convert_ObjectToPyobj(const obj: TObject): pPyObject; cdecl;
function convert_PyobjToIUnknown(const obj: pPyObject; value: PInterface): c_int; cdecl;

implementation
uses
  System.SysUtils, _tools_;

type
  PointerType = (ptObject, ptPointer, ptInreface, ptOther);
const
  Capsule_Name         = 'PyOPCDA3.';
  CapsuleName_Object   : c_charsAsStr = Capsule_Name + 'DelphiObject';
  CapsuleName_Pointer  : c_charsAsStr = Capsule_Name + 'DelphiPointer';
  CapsuleName_Inreface : c_charsAsStr = Capsule_Name + 'DelphiInreface';
  CapsuleName_Other    : c_charsAsStr = Capsule_Name + 'DelphiOther';

//------------------------------------------------------------------------------
procedure delete_DelphiObject(Capsule: pPyObject); cdecl;
var
  Obj: TObject;
begin
  try
    Obj := TObject(PyCapsule_GetPointer(Capsule, c_chars(CapsuleName_Object))); // PyCapsule_GetName(Capsule)));
    if Obj = nil then
      Exit;
    Obj.Free;
    Obj := nil;
  except
    on e: Exception do
    begin
      SetPyError('delete_DelphiObjectTo', e);
    end;
  end;
end;
// ------------------------------------------------------------------------------
procedure delete_DelphiPointer(Capsule: pPyObject); cdecl;
var
  void: Pointer;
begin
  try
    void := PyCapsule_GetPointer(Capsule, c_chars(CapsuleName_Pointer)); // PyCapsule_GetName(Capsule)));
    if void = nil then
      Exit;
    Dispose(void);
    void := nil;
  except
    on e: Exception do
    begin
      SetPyError('delete_DelphiPointer', e);
    end;
  end;
end;

// ------------------------------------------------------------------------------
procedure delete_DelphiInterface(Capsule: pPyObject); cdecl;
var
  intfc: PInterface;
begin
  try
    intfc := PyCapsule_GetPointer(Capsule, c_chars(CapsuleName_Inreface));
    if intfc = nil then
      Exit;
    intfc.Intrfc := nil;
    Dispose(intfc);
    intfc := nil;
    // MessageBox(0,'Kill DelphiInterface','',0);
  except
    on e: Exception do
    begin
      SetPyError('delete_DelphiInterface', e);
    end;
  end;
end;
// ------------------------------------------------------------------------------
function convert_DelphiPointerToPyObject(const obj: Pointer; pt: PointerType): pPyObject;
var
  name: c_charsAsStr;
  func: PyCapsule_Destructor;
begin

  if obj=NULL then
  begin
    raise Exception.Create('Ошибка конвертации: Объект=NULL !');
  end;
  case pt of
    ptObject:
      begin
        name := CapsuleName_Object;
        func := delete_DelphiObject;
      end;
    ptPointer:
      begin
        name := CapsuleName_Pointer;
        func := delete_DelphiPointer;
      end;
    ptInreface:
      begin
        name := CapsuleName_Inreface;
        func := delete_DelphiInterface;
      end;
    ptOther:
      begin
        name := CapsuleName_Other;
        func := NULL;
      end;
  end;
  Result := PyCapsule_New(obj, c_chars(name), func);
end;
//------------------------------------------------------------------------------
function convert_IUnknownToPyobj;
var itf: PInterface;
begin
  New(itf);
  itf^ := obj^;
  Result := convert_DelphiPointerToPyObject(itf, ptInreface);
end;
//------------------------------------------------------------------------------
function convert_ObjectToPyobj;
begin
  Result := convert_DelphiPointerToPyObject(obj, ptObject);
end;
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
function convert_PyobjToIUnknown(const obj: pPyObject; value: PInterface): c_int;
var itfs: PInterface;
begin
  Result := 1; //Succees
  try
    if PyCapsule_IsValid(obj, c_chars(CapsuleName_Inreface)) = 0 then
      raise Exception.Create(Format('Не является объектом "%s"', [CapsuleName_Inreface]));
    itfs := PyCapsule_GetPointer(obj, c_chars(CapsuleName_Inreface));
    if itfs=NULL then
      raise Exception.Create(Format('Объект "%s" is NULL', [CapsuleName_Inreface]));
    value^ := itfs^;
    //Py_INCREF(obj);
  except
    on e: Exception do
    begin
      SetPyError('PyobjToIUnknown', e);
      Result := 0; //failed
      value := NULL;
    end;
  end;
end;



end.
