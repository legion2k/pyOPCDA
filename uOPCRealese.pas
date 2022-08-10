unit uOPCRealese;

interface

uses
  {$I include/#define_Python.h},
  OPCDA, OPCtypes,
  System.Classes, System.SyncObjs,
  Winapi.Windows, Winapi.ActiveX, System.SysUtils;

const
  CallBackProcedureName = 'doOnDataChange';

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
function DateTimeToFileTime(DateTime: TDateTime): TFileTime;
function VariantToPyobj(const val: Variant): pPyObject;
function PyobjToVariant(const val: pPyObject; const VType: TVarType): Variant;

type
  // class to receive IConnectionPointContainer data change callbacks
  TOPCDataCallback = class(TInterfacedObject, IOPCDataCallback)
  private
    CallBackFunc: pPyObject;
    LastThread: TThread;
  public
    function OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray; pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;
      pErrors: PResultList): HResult; stdcall;
    function OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE; hrMasterquality: HResult; hrMastererror: HResult; dwCount: DWORD;
      phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray; pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;
      pErrors: PResultList): HResult; stdcall;
    function OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE; hrMastererr: HResult; dwCount: DWORD; pClienthandles: POPCHANDLEARRAY;
      pErrors: PResultList): HResult; stdcall;
    function OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE): HResult; stdcall;
    constructor Create(CallBack_OnDataChange: pPyObject);
    destructor Destroy; override;
  end;
  // ---------------------------------------------------------------------------------------------------------------------------------------
  TOPCData = record
    Value: Variant;
    DateTime: TDateTime;
    itemID: DWORD;
    ValType: TVarType;
    Quality: Word;
  end;
  TDataArray = TArray<TOPCData>;

  TDataSender = class(TThread)
  private
    data: TDataArray;
    time : TDateTime;
    prev : TThread;
    CallBack : pPyObject;
  public
    constructor Create(const PrevThread: TThread; const CallBackFunc: pPyObject; const DateTime: TDateTime; const ArrData: TDataArray);
    destructor Destroy; override;
  protected
    procedure Execute; override;
  end;
  // ---------------------------------------------------------------------------------------------------------------------------------------

implementation

uses System.Variants, _tools_;

function FileTimeToDateTime(FileTime: TFileTime): TDateTime;
var
  SystemTime: TSystemTime;
begin
  Result := 0;
  try
    if (FileTime.dwLowDateTime = 0) and (FileTime.dwHighDateTime = 0) then
      raise Exception.Create('Error time');
    //FileTimeToLocalFileTime(FileTime, ModifiedTime);
    FileTimeToSystemTime(FileTime{ModifiedTime}, SystemTime);
    Result := SystemTimeToDateTime(SystemTime);
  except
    Result := Now; // Something to return in case of error
  end;
end;
function DateTimeToFileTime(DateTime: TDateTime): TFileTime;
var
  SystemTime: TSystemTime;
begin
  //MesBox(DateTimeToStr(DateTime));
  DateTimeToSystemTime(DateTime, SystemTime);
  SystemTimeToFileTime(SystemTime, Result);
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
{ TDataSender }
constructor TDataSender.Create;
begin  
  data := ArrData;
  time := DateTime;
  prev := PrevThread;
  CallBack := CallBackFunc;
  Py_XINCREF(CallBack);
  inherited Create(False);
end;

destructor TDataSender.Destroy;
begin
  SetLength(data,0);
  Py_XDECREF(CallBack);
  CallBack := nil;
  inherited;
end;

procedure TDataSender.Execute;
var
  i, c: Integer;
  PyGILState: PyGILState_STATE;
  ArgList: pPyObject;
begin
  FreeOnTerminate := not True;
  c := Length(data) - 1;
  if Assigned(prev) then
  begin
    prev.WaitFor;
    prev.Free;
    prev := nil;
  end;
  try
    for i := 0 to c do
    begin
      if Terminated then
        Exit;
      PyGILState := PyGILState_Ensure();

      try
        with data[i] do
          ArgList := Py_BuildValue('OOOkHH', VariantToPyobj(Value), PyDateTime_FromTDateTime(DateTime), PyDateTime_FromTDateTime(time), itemID, ValType, Quality);
        if PyObject_CallObject(CallBack, ArgList)= nil then
        begin
          PyErr_PrintEx(1000000);
        end;
        Py_DECREF(ArgList);
        //raise Exception.Create('Error Message');
      finally
        PyGILState_Release(PyGILState);
      end;
    end;
  except
    on e: Exception do
    begin
      PyGILState := PyGILState_Ensure();
      SetPyError('Thread.OnDataChange', e);
      PyErr_PrintEx(0);
      PyGILState_Release(PyGILState);
    end;
  end;
  ReturnValue := 1;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------

{ TOPCDataCallback }

function TOPCDataCallback.OnDataChange(dwTransid: DWORD; hGroup: OPCHANDLE; hrMasterquality, hrMastererror: HResult; dwCount: DWORD;
  phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray; pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;
  pErrors: PResultList): HResult;
var
  i: Integer;
  Data: TDataArray;
begin
  Result := S_OK;
  SetLength(Data, dwCount);
  //var gil := PyGILState_Ensure;
  try
    for i := 0 to dwCount - 1 do
      with Data[i] do
      begin
        Value    := pvValues[i];
        itemID   := phClientItems[i];
        ValType  := VarType(pvValues[i]);
        DateTime := FileTimeToDateTime(pftTimeStamps[i]);
        Quality  := pwQualities[i];
      end;
      LastThread := TDataSender.Create(LastThread, CallBackFunc, Now(), Data);
  except
    on e: Exception do
    begin
      var PyGILState := PyGILState_Ensure();
      SetPyError('OnDataChange', e);
      PyErr_PrintEx(0);
      PyGILState_Release(PyGILState);
    end;
  end;
  //PyGILState_Release(gil);
end;

function TOPCDataCallback.OnReadComplete(dwTransid: DWORD; hGroup: OPCHANDLE; hrMasterquality, hrMastererror: HResult; dwCount: DWORD;
  phClientItems: POPCHANDLEARRAY; pvValues: POleVariantArray; pwQualities: PWordArray; pftTimeStamps: PFileTimeArray;
  pErrors: PResultList): HResult;
begin
  Result := Self.OnDataChange(dwTransid, hGroup, hrMasterquality, hrMastererror, dwCount, phClientItems, pvValues, pwQualities,
    pftTimeStamps, pErrors);
//  Result := S_OK;
end;

function TOPCDataCallback.OnWriteComplete(dwTransid: DWORD; hGroup: OPCHANDLE; hrMastererr: HResult; dwCount: DWORD;
  pClienthandles: POPCHANDLEARRAY; pErrors: PResultList): HResult;
begin
  // we don't use this facility
  Result := S_OK;
end;

function TOPCDataCallback.OnCancelComplete(dwTransid: DWORD; hGroup: OPCHANDLE): HResult;
begin
  // we don't use this facility
  Result := S_OK;
end;

constructor TOPCDataCallback.Create;
begin
  inherited Create;
  CallBackFunc := CallBack_OnDataChange;
  Py_INCREF(CallBackFunc);
  LastThread := nil;
end;

destructor TOPCDataCallback.Destroy;
begin
  Py_DECREF(CallBackFunc);
  //MessageBox(0,'TOPCDataCallback.Destroy','',0);
  if Assigned(LastThread) then
  begin
    LastThread.WaitFor;
    LastThread.Free;
  end;
  inherited;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------------
function VariantToPyobj(const val: Variant): pPyObject;
var
  vt, basicType: TVarType;
begin
  try
    vt := VarType(val);
    basicType := vt and varTypeMask {=VT_TYPEMASK};
    if basicType <> vt then
    begin
      if (vt and varArray{=VT_ARRAY} )=0 then// if not array
        Result := Py_BuildValue('')
      else// if array
      begin
        Result := PyList_New(0);
        for var i := VarArrayLowBound(val, 1) to VarArrayHighBound(val, 1) do
        begin
          //var z: variant := val[i];
          PyList_Append(Result, VariantToPyobj(val[i]));
        end;
      end
    end
    else
    begin
      case basicType of
        VT_EMPTY,// varEmpty	Переменная не имеет никакого значения
        VT_NULL: // varNull		Переменная имеет пустое значение
          Result := Py_BuildValue('');
        VT_INT,
        VT_I1,// varShortInt			Однобайтное целое со знаком
        VT_I2,// varSmallInt	Двухбайтное целое со знаком
        VT_I4:// varInteger		Четырёхбайтное целое со знаком
          begin
            var v: Int32 := val;
            Result := Py_BuildValue('l',v)
          end;
        VT_I8:// varInt64					Восьмибайтное целое со знаком
          begin
            var v: Int64 := val;
            Result := Py_BuildValue('L',v)
          end;
        VT_UINT,
        VT_UI1,// varByte					Однобайтное беззнаковое целое
        VT_UI2,// varWord					Двухбайтное беззнаковое целое
        VT_UI4://	varLongWord			Четырёхбайтное беззнаковое целое
          begin
            var v: UInt32 := val;
            Result := Py_BuildValue('k',v)
          end;
        VT_UI8:
          begin
            var v: UInt64 := val;
            Result := Py_BuildValue('K',v)
          end;
        VT_R4:// varSingle		Четырёхбайтное вещественное
          begin
            var v: Float32 := val;
            Result := Py_BuildValue('f',v)
          end;
        VT_R8:// varDouble		Восьмибайтное вещественное
          begin
            var v: Float64 := val;
            Result := Py_BuildValue('d',v)
          end;
        //VT_CY:// varCurrency	Тип Currency (валюта)
        //  begin
        //    var v: Currency := val;
        //    Result := Py_BuildValue('d',v)
        //  end;
        VT_DATE://varDate			Дата-время в формате TVarDate (вещественное число, целая часть которого показывает число полных дней, прошедших с 30.12.1899, дробная часть — долю прошедшего неполного дня)
          begin
            Result := PyDateTime_FromTDateTime(VarToDateTime(val))
          end;

        //идет в else VT_BSTR://varOleStr		Строка типа BSTR

        //VT_DISPATCH	varDispatch	Указатель на интерфейс IDispatch (этот интерфейс будет рассмотрен позже, в главе про автоматизацию)
        //VT_ERROR	varError	Значение типа SCODE (устаревший тип для кодирования ошибок, применявшийся до введения HRESULT)
        VT_BOOL:// varBoolean	Двухбайтный логический тип. Значение 0 соответствует False, -1 ($FFFF) — True. Остальные значения не определены. В системе определены константы VARIANT_TRUE и VARIANT_FALSE, кодирующие эти значения. В Delphi для этого типа никакие специальные константы не определены, можно использовать True и False.
          begin
            var v: Boolean := val;
            Result := PyBool(v);
          end;
        //VT_VARIANT	varVariant	Вариантный тип. Может применяться только с VT_BYREF, т.е. в структуре хранится ссылка на другрую такую же структуру.
        //VT_UNKNOWN	varUnknown	Указатель на IUnknown
        //VT_RECORD	—	Структура. О способах хранения структур в вариантных типах мы поговорим на другом уроке.
      else
        begin
          var s: UTF8String := UTF8Encode(VarToStr(val));
          Result := Py_BuildValue('s', s);
        end;
      end;
    end;
  except
    on e: Exception do
    begin
      // MessageBox(0,PWideChar(e.Message),'',0);
      Result := Py_BuildValue('s', c_chars(UTF8Encode(Format('Ошибка преобразования данных %s',[e.Message]))));;
    end;
  end;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------------
// -----------------------------------------------------------------------------------------------------------------------------------------
function PyobjToVariant(const val: pPyObject; const VType: TVarType): Variant;
begin
  if PyFloat_Check(val) then
  begin
    //VType  := varDouble;
    Result := PyFloat_AsDouble(val)
  end


  else if PyLong_Check(val) then
  begin
    //VType  := varInt64;
    var v := PyLong_AsLongLong(val);
    if(v=-1)and(PyErr_Occurred<>nil)then
    begin
      //var ptype, pvalue, ptraceback: pPyObject;
      //VType  := varUInt64;
      //PyErr_Fetch(@ptype, @pvalue, @ptraceback);
      PyErr_Clear();
      //Py_XDECREF(ptype); Py_XDECREF(pvalue); Py_XDECREF(ptraceback);
      var vv := PyLong_AsUnsignedLongLong(val);
      if(vv=c_unsigned_long_long(-1))and(PyErr_Occurred<>nil)then
      begin
        //PyErr_Fetch(@ptype, @pvalue, @ptraceback);
        PyErr_Clear();
        //Py_XDECREF(ptype); Py_XDECREF(pvalue); Py_XDECREF(ptraceback);
      end
      else
        Result := vv;
    end
    else
      Result := v;
  end


  else if PyBool_Check(val) then
  begin
    //VType  := varBoolean;
    Result := PyObject_IsTrue(val)=1
  end


  else if PyDateTime_Check(val) then
  begin
    //VType  := varDate;
    var dt := TDateTime_FromPyDateTime(val);
    Result := VarFromDateTime(dt);
  end


  else if PyUnicode_Check(val) then
  begin
    //MesBox('PyUnicode_Check');
    //VType  := varOleStr;
    Result := UTF8ToString(PyUnicode_AsUTF8(val));
    //MesBox(Result);
  end


  else if PyBytes_Check(val) then //String
  begin
    //MesBox('PyBytes_Check');
    //VType  := varOleStr;
    Result := c_charsAsStr(PyBytes_AsString(val));
    //MesBox(Result);
  end


  else if PyList_Check(val)or PyTuple_Check(val) then
  begin
    var i := PyListOrTuple_Size(val);
    Result := VarArrayCreate([0, i-1], VType);
    while i>0 do
    begin
      Dec(i);
      Result[i] := PyobjToVariant(PyListOrTuple_GetItem(val, i), VType);
    end;
  end

  else
    Result := System.Variants.Null;


  //exit
  begin
    var vt := VarType(Result);
    if(vt<>VType)and((vt and VT_ARRAY)=0)then
      case VType of
      VT_INT:
        Result := NativeInt(Result);
      VT_UINT:
        Result := NativeUInt(Result);

      VT_I1:
        Result := Int8(Result);
      VT_I2:
        Result := Int16(Result);
      VT_I4:
        Result := Int32(Result);
      VT_I8:
        Result := Int64(Result);

      VT_UI1:
        Result := UInt8(Result);
      VT_UI2:
        Result := UInt16(Result);
      VT_UI4:
        Result := UInt32(Result);

      VT_BSTR:
        Result := String(Result);

      VT_CY:
        Result := Currency(Result);
      VT_R4:
        Result := Single(Result);
      VT_R8:
        Result := Double(Result);

      VT_BOOL:
        Result := Boolean(Result);
      end;
    //MesBox(IntToStr(vt) +'=>'+ IntToStr(VarType(Result)), IntToStr(VType));
  end;
end;

end.
