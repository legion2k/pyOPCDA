unit datetime_h;

interface
uses
  object_h, c_types;
// -----------------------------------------------------------------------------------------------------------------------------------------
procedure ImportDateTimeModule();
// -----------------------------------------------------------------------------------------------------------------------------------------
function PyDateTime_Check(o: pPyObject): Boolean;

function PyDateTime_FromTDateTime(DateTime: TDateTime): pPyObject;
function TDateTime_FromPyDateTime(DateTime: pPyObject): TDateTime;

function PyDate_FromTDate(date: TDate): pPyObject;
// --------------------------------------------------------------
function PyDateTime_GET_YEAR               (o: pPyObject): c_int;
function PyDateTime_GET_MONTH              (o: pPyObject): c_int;
function PyDateTime_GET_DAY                (o: pPyObject): c_int;

function PyDateTime_DATE_GET_HOUR          (o: pPyObject): c_int;
function PyDateTime_DATE_GET_MINUTE        (o: pPyObject): c_int;
function PyDateTime_DATE_GET_SECOND        (o: pPyObject): c_int;
function PyDateTime_DATE_GET_MICROSECOND   (o: pPyObject): c_int;
function PyDateTime_DATE_GET_FOLD          (o: pPyObject): c_int;

function PyDateTime_TIME_GET_HOUR          (o: pPyObject): c_int;
function PyDateTime_TIME_GET_MINUTE        (o: pPyObject): c_int;
function PyDateTime_TIME_GET_SECOND        (o: pPyObject): c_int;
function PyDateTime_TIME_GET_MICROSECOND   (o: pPyObject): c_int;
function PyDateTime_TIME_GET_FOLD          (o: pPyObject): c_int;

function PyDateTime_DELTA_GET_DAYS         (o: pPyObject): c_int;
function PyDateTime_DELTA_GET_SECONDS      (o: pPyObject): c_int;
function PyDateTime_DELTA_GET_MICROSECONDS (o: pPyObject): c_int;

// -----------------------------------------------------------------------------------------------------------------------------------------

implementation
uses PythonLib, System.DateUtils, System.SysUtils, _tools_;

// -----------------------------------------------------------------------------------------------------------------------------------------
type
  pPyDateTime_CAPI = ^PyDateTime_CAPI;
  PyDateTime_CAPI = {$IFNDEF CPUX64}packed{$ENDIF} record
    //* type objects */
    DateType                        : pPyTypeObject;
    DateTimeType                    : pPyTypeObject;
    TimeType                        : pPyTypeObject;
    DeltaType                       : pPyTypeObject;
    TZInfoType                      : pPyTypeObject;

    //* singletons */
    TimeZone_UTC                    : pPyObject;

    //* constructors */
    Date_FromDate                   : function(year, month, day: c_int; t: pPyTypeObject): pPyObject; cdecl;
    DateTime_FromDateAndTime        : function(year, month, day, hour, min, sec, usec: c_int; o: pPyObject; t: pPyTypeObject): pPyObject; cdecl;
    Time_FromTime                   : function(hour, min, sec, usec: c_int; o: pPyObject; t: pPyTypeObject): pPyObject; cdecl;
    Delta_FromDelta                 : function(days, seconds, usecond: c_int; equal_1: c_int; t: pPyTypeObject): pPyObject; cdecl;
    TimeZone_FromTimeZone           : function(offset, name: ppPyObject): pPyObject; cdecl;

    //* constructors for the DB API */
    DateTime_FromTimestamp          : function(o1, o2, o3: pPyObject): pPyObject; cdecl;
    Date_FromTimestamp              : function(o1, o2: pPyObject): pPyObject; cdecl;

    //* PEP 495 constructors */
    DateTime_FromDateAndTimeAndFold : function(year, month, day, hour, min, sec, usec: c_int; o: pPyObject; fold: c_int; t: pPyTypeObject): pPyObject; cdecl;
    Time_FromTimeAndFold            : function(hour, min, sec, usec: c_int; o: pPyObject; fold: c_int; t: pPyTypeObject): pPyObject; cdecl;
  end;
// -----------------------------------------------------------------------------------------------------------------------------------------
var
  PyDateTimeAPI: pPyDateTime_CAPI = NULL;
// -----------------------------------------------------------------------------------------------------------------------------------------
const
  _PyDateTime_DATE_DATASIZE      = 4;
  _PyDateTime_TIME_DATASIZE      = 6;
  _PyDateTime_DATETIME_DATASIZE  = 10;
type
  pPyDateTime_Date     = ^PyDateTime_Date;
  pPyDateTime_DateTime = ^PyDateTime_DateTime;
  pPyDateTime_Time     = ^PyDateTime_Time;
  pPyDateTime_Delta    = ^PyDateTime_Delta;
  // -----------------------------------------------------
  PyDateTime_Date = {$IFNDEF CPUX64}packed{$ENDIF} record
    //_PyTZINFO_HEAD   :   PyObject_HEAD  /  Py_hash_t hashcode;  /  char hastzinfo;/* boolean flag */
    ob_base     : PyObject;
    hashcode    : Py_hash_t;
    hastzinfo   : c_char;
    // unsigned char data[_PyDateTime_DATE_DATASIZE];
    data        : array[0..Pred(_PyDateTime_DATE_DATASIZE)] of c_unsigned_char;
  end;
  // -----------------------------------------------------
  PyDateTime_DateTime = {$IFNDEF CPUX64}packed{$ENDIF} record
    //_PyDateTime_DATETIMEHEAD   :   _PyTZINFO_HEAD  \  unsigned char data[_PyDateTime_DATETIME_DATASIZE];
    ob_base   : PyObject;
    hashcode  : Py_hash_t;
    hastzinfo : c_char;
    data      : array[0..Pred(_PyDateTime_DATETIME_DATASIZE)] of c_unsigned_char;
    //unsigned char fold;
    fold      : c_unsigned_char;
    //PyObject *tzinfo;
    tzinfo    : pPyObject;
  end;
  // -----------------------------------------------------
  PyDateTime_Time = {$IFNDEF CPUX64}packed{$ENDIF} record
    //_PyDateTime_TIMEHEAD   :   _PyTZINFO_HEAD  \  unsigned char data[_PyDateTime_TIME_DATASIZE];
    ob_base     : PyObject;
    hashcode    : Py_hash_t;
    hastzinfo   : c_char;
    data        : array[0..Pred(_PyDateTime_TIME_DATASIZE)] of c_unsigned_char;
    //unsigned char fold;
    fold        : c_unsigned_char;
    //PyObject *tzinfo;
    tzinfo      : pPyObject;
  end;
  // -----------------------------------------------------
  PyDateTime_Delta = {$IFNDEF CPUX64}packed{$ENDIF} record
    ob_base      : PyObject;  //PyObject_HEAD
    hashcode     : Py_hash_t; //Py_hash_t hashcode;         /* -1 when unknown */
    days         : c_int;     //int days;                   /* -MAX_DELTA_DAYS <= days <= MAX_DELTA_DAYS */
    seconds      : c_int;     //int seconds;                /* 0 <= seconds < 24*3600 is invariant */
    microseconds : c_int;     //int microseconds;           /* 0 <= microseconds < 1000000 is invariant */
  end;
// -----------------------------------------------------------------------------------------------------------------------------------------
function PyDateTime_Check(o: pPyObject): Boolean;
begin
  Result := PyObject_TypeCheck(o, PyDateTimeAPI.DateType);
end;

// -----------------------------------------------------------------
function PyDateTime_FromTDateTime(DateTime: TDateTime): pPyObject;
//var ArgList: pPyObject;
// year, mount, day, hour, min, sec, usec: Word;
//begin
//  if Assigned(_pyObj_DateTimeType) then
//  begin
//    DecodeDateTime(DateTime, year, month, day, hour, min, sec, usec);
//    ArgList :=  Py_BuildValue('HHHHHHH',year, month, day, hour, min, sec, usec*1000);
//    Result := PyObject_CallObject(_pyObj_DateTimeType, ArgList);
//    Py_DECREF(ArgList);
//  end
//  else
//    Result := NULL;
var year, month, day, hour, min, sec, usec: word;
begin
  DecodeDateTime(DateTime, year, month, day, hour, min, sec, usec);
  Result := PyDateTimeAPI.DateTime_FromDateAndTime(year, month, day, hour, min, sec, usec*1000, Py_None, PyDateTimeAPI.DateTimeType);
end;

// -----------------------------------------------------------------
function TDateTime_FromPyDateTime(DateTime: pPyObject): TDateTime;
var year, month, day, hour, min, sec: Word;
    usec: c_int;
begin
  year   := PyDateTime_GET_YEAR(DateTime);
  month  := PyDateTime_GET_MONTH(DateTime);
  day    := PyDateTime_GET_DAY(DateTime);
  hour   := PyDateTime_DATE_GET_HOUR(DateTime);
  min    := PyDateTime_DATE_GET_MINUTE(DateTime);
  sec    := PyDateTime_DATE_GET_SECOND(DateTime);
  usec   := PyDateTime_DATE_GET_MICROSECOND(DateTime);
  Result := EncodeDateTime(year, month, day, hour, min, sec, usec div 1000);
end;

// -----------------------------------------------------------------
function PyDate_FromTDate(date: TDate): pPyObject;
var year, month, day: Word;
begin
  DecodeDate(date, year, month, day);
  Result := PyDateTimeAPI.Date_FromDate((year), month, day, PyDateTimeAPI.DateType);
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function PyDateTime_GET_YEAR(o: pPyObject): c_int;
begin
  Result := (pPyDateTime_Date(o).data[0] shl 8) or (pPyDateTime_Date(o).data[1]);
end;
function PyDateTime_GET_MONTH(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Date(o).data[2]
end;
function PyDateTime_GET_DAY(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Date(o).data[3]
end;
// -----------------------------------------------------------------
function PyDateTime_DATE_GET_HOUR(o: pPyObject): c_int;
begin
  Result := pPyDateTime_DateTime(o).data[4]
end;
function PyDateTime_DATE_GET_MINUTE(o: pPyObject): c_int;
begin
  Result := pPyDateTime_DateTime(o).data[5]
end;
function PyDateTime_DATE_GET_SECOND(o: pPyObject): c_int;
begin
  Result := pPyDateTime_DateTime(o).data[6]
end;
function PyDateTime_DATE_GET_MICROSECOND(o: pPyObject): c_int;
begin
  Result := (pPyDateTime_DateTime(o).data[7] shl 16) or (pPyDateTime_DateTime(o).data[8] shl 8) or (pPyDateTime_DateTime(o).data[9])
end;
function PyDateTime_DATE_GET_FOLD(o: pPyObject): c_int;
begin
  Result := pPyDateTime_DateTime(o).fold
end;
// -----------------------------------------------------------------
function PyDateTime_TIME_GET_HOUR(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Time(o).data[0]
end;
function PyDateTime_TIME_GET_MINUTE(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Time(o).data[1]
end;
function PyDateTime_TIME_GET_SECOND(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Time(o).data[2]
end;
function PyDateTime_TIME_GET_MICROSECOND (o: pPyObject): c_int;
begin
  Result := (pPyDateTime_Time(o).data[3] shl 16) or (pPyDateTime_Time(o).data[4] shl 8) or (pPyDateTime_Time(o).data[5])
end;
function PyDateTime_TIME_GET_FOLD(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Time(o).fold
end;
// -----------------------------------------------------------------
function PyDateTime_DELTA_GET_DAYS(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Delta(o).days
end;
function PyDateTime_DELTA_GET_SECONDS(o: pPyObject): c_int;
begin
  Result := pPyDateTime_Delta(o).seconds
end;
function PyDateTime_DELTA_GET_MICROSECONDS (o: pPyObject): c_int;
begin
  Result := pPyDateTime_Delta(o).microseconds
end;
// -----------------------------------------------------------------------------------------------------------------------------------------
//function GetAttr(Obj: pPyObject; AVarName: AnsiString) : pPyObject;
//begin
//  Result := PyObject_GetAttrString(Obj, c_chars(AVarName));
//  Py_XDECREF(Result);
//end;

procedure ImportDateTimeModule();
begin
  if not Assigned(PyDateTimeAPI) then
    PyDateTimeAPI :=  PyCapsule_Import('datetime.datetime_CAPI',0);
end;

initialization
// код ниже выдает ошибку, поэтому ImportDateTimeModule выполняйте в функции определенной в ModuleDef.m_slots[0].value
//  try
//    //PyDateTimeAPI :=  PyCapsule_Import('datetime.datetime_CAPI',0);
//    ImportModule();
//  except
//    on e: Exception do begin
//      MesBox(e.Message, Format('Ошибка загрузка DLL "%s"',[PyLib]) )
//    end;
//  end;
finalization
  if Assigned(PyDateTimeAPI) then
    PyDateTimeAPI := NULL;
end.
