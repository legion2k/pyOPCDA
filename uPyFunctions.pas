unit uPyFunctions;

interface

uses {$I 'include\#define_Python.h'};

procedure Py_Initializate(module: pPyObject);
//------------------------------------
function OPC_CoInitialize(self: pPyObject): pPyObject; cdecl;
function OPC_CoInitializeEx(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_CoInitializeSecurity(self: pPyObject): pPyObject; cdecl;
function OPC_CoUninitialize(self: pPyObject): pPyObject; cdecl;
//
function OPC_Connect(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_ServerGetStatus(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_ServerAddGroup(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_GroupAddItem(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_SetCallBack(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_DelCallBack(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;

function OPC_SetCallBack2(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;

function OPC_GroupItemRead(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_GroupItemWrite(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
function OPC_GroupRemove(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;

function OPC_GroupItemWrite2(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;

//------------------------------------
//procedure PyTest();
//------------------------------------
implementation
uses
  _tools_,
  OPCDA, OPCtypes, uOPCRealese, uPyOPCTypes,
  Winapi.Windows, Winapi.ActiveX, System.Win.ComObj, System.Variants, System.SysUtils;

//procedure PyTest();
//begin
//  MesBox('ok', 'test');
//end;

procedure Py_Initializate(module: pPyObject);
begin
  //------------------------------------
  //PyImport_ImportModule();
  ImportDateTimeModule;
  //------------------------------------
  PyModule_AddIntConstant(module, 'COINIT_MULTITHREADED', 0);
  PyModule_AddIntConstant(module, 'COINIT_APARTMENTTHREADED', 2);
  PyModule_AddIntConstant(module, 'COINIT_DISABLE_OLE1DDE', 4);
  PyModule_AddIntConstant(module, 'COINIT_SPEED_OVER_MEMORY', 8);

  //-----------------------
  //WinApi.Windows
  PyModule_AddIntConstant(module, 'S_OK', $00000000);
  PyModule_AddIntConstant(module, 'S_FALSE', $00000001);

  //-----------------------

  PyModule_AddIntConstant(module, 'VT_EMPTY', 0); { [V]   [P]  nothing }
  //PyModule_AddIntConstant(module, 'VT_NULL',              1);   { [V]        SQL style Null              }
  PyModule_AddIntConstant(module, 'VT_I2', 2); { [V][T][P]  2 byte signed int }
  PyModule_AddIntConstant(module, 'VT_I4', 3); { [V][T][P]  4 byte signed int }
  PyModule_AddIntConstant(module, 'VT_R4', 4); { [V][T][P]  4 byte real }
  PyModule_AddIntConstant(module, 'VT_R8', 5); { [V][T][P]  8 byte real }
  PyModule_AddIntConstant(module, 'VT_CY', 6); { [V][T][P]  currency }
  PyModule_AddIntConstant(module, 'VT_DATE', 7); { [V][T][P]  date }
  PyModule_AddIntConstant(module, 'VT_BSTR', 8); { [V][T][P]  binary string }
  //PyModule_AddIntConstant(module, 'VT_DISPATCH',          9);   { [V][T]     IDispatch FAR*              }
  //PyModule_AddIntConstant(module, 'VT_ERROR',             10);  { [V][T]     SCODE                       }
  PyModule_AddIntConstant(module, 'VT_BOOL', 11); { [V][T][P]  True -1, False 0 }
  //PyModule_AddIntConstant(module, 'VT_VARIANT',           12);  { [V][T][P]  VARIANT FAR*                }
  //PyModule_AddIntConstant(module, 'VT_UNKNOWN',           13);  { [V][T]     IUnknown FAR*               }
  //PyModule_AddIntConstant(module, 'VT_DECIMAL',           14);  { [V][T]   [S]  16 byte fixed point      }

  PyModule_AddIntConstant(module, 'VT_I1', 16); { [T]     signed char }
  PyModule_AddIntConstant(module, 'VT_UI1', 17); { [T]     unsigned char }
  PyModule_AddIntConstant(module, 'VT_UI2', 18); { [T]     unsigned short }
  PyModule_AddIntConstant(module, 'VT_UI4', 19); { [T]     unsigned long }
  PyModule_AddIntConstant(module, 'VT_I8', 20); { [T][P]  signed 64-bit int }
  PyModule_AddIntConstant(module, 'VT_UI8', 21); { [T]     unsigned 64-bit int }
  PyModule_AddIntConstant(module, 'VT_INT', 22); { [T]     signed machine int }
  PyModule_AddIntConstant(module, 'VT_UINT', 23); { [T]     unsigned machine int }
  //PyModule_AddIntConstant(module, 'VT_VOID',              24);  {    [T]     C style void                }
  //PyModule_AddIntConstant(module, 'VT_HRESULT',           25);  {    [T]                                 }
  //PyModule_AddIntConstant(module, 'VT_PTR',               26);  {    [T]     pointer type                }
  //PyModule_AddIntConstant(module, 'VT_SAFEARRAY',         27);  {    [T]     (use VT_ARRAY in VARIANT)   }
  //PyModule_AddIntConstant(module, 'VT_CARRAY',            28);  {    [T]     C style array               }
  //PyModule_AddIntConstant(module, 'VT_USERDEFINED',       29);  {    [T]     user defined type          }
  //PyModule_AddIntConstant(module, 'VT_LPSTR',             30);  {    [T][P]  null terminated string      }
  //PyModule_AddIntConstant(module, 'VT_LPWSTR',            31);  {    [T][P]  wide null terminated string }
  //PyModule_AddIntConstant(module, 'VT_RECORD',            36);  { [V]   [P][S]  user defined type        }
  //PyModule_AddIntConstant(module, 'VT_INT_PTR',           37);  {    [T]     signed machine register size width }
  //PyModule_AddIntConstant(module, 'VT_UINT_PTR',          38);  {    [T]     unsigned machine register size width }

  //PyModule_AddIntConstant(module, 'VT_FILETIME',          64);  {       [P]  FILETIME                    }
  //PyModule_AddIntConstant(module, 'VT_BLOB',              65);  {       [P]  Length prefixed bytes       }
  //PyModule_AddIntConstant(module, 'VT_STREAM',            66);  {       [P]  Name of the stream follows  }
  //PyModule_AddIntConstant(module, 'VT_STORAGE',           67);  {       [P]  Name of the storage follows }
  //PyModule_AddIntConstant(module, 'VT_STREAMED_OBJECT',   68);  {       [P]  Stream contains an object   }
  //PyModule_AddIntConstant(module, 'VT_STORED_OBJECT',     69);  {       [P]  Storage contains an object  }
  //PyModule_AddIntConstant(module, 'VT_BLOB_OBJECT',       70);  {       [P]  Blob contains an object     }
  //PyModule_AddIntConstant(module, 'VT_CF',                71);  {       [P]  Clipboard format            }
  //PyModule_AddIntConstant(module, 'VT_CLSID',             72);  {       [P]  A Class ID                  }
  //PyModule_AddIntConstant(module, 'VT_VERSIONED_STREAM',  73);  {       [P]  Stream with a GUID version  }

  //PyModule_AddIntConstant(module, 'VT_VECTOR',          $1000); {       [P]  simple counted array        }
  PyModule_AddIntConstant(module, 'VT_ARRAY', $2000); { [V]        SAFEARRAY* }
  //PyModule_AddIntConstant(module, 'VT_BYREF',           $4000); { [V]                                    }
  //PyModule_AddIntConstant(module, 'VT_RESERVED',        $8000);
  //PyModule_AddIntConstant(module, 'VT_ILLEGAL',         $ffff);
  //PyModule_AddIntConstant(module, 'VT_ILLEGALMASKED',   $0fff);
  PyModule_AddIntConstant(module, 'VT_TYPEMASK', $0FFF);

  //-----------------------
  //OPCDA
  //PyModule_AddIntConstant(module, 'OPC_DS_CACHE',   1);
  //PyModule_AddIntConstant(module, 'OPC_DS_DEVICE',  2);
  //
  //PyModule_AddIntConstant(module, 'OPC_BRANCH',  1);
  //PyModule_AddIntConstant(module, 'OPC_LEAF',    2);
  //PyModule_AddIntConstant(module, 'OPC_FLAT',    3);
  //
  //PyModule_AddIntConstant(module, 'OPC_NS_HIERARCHIAL',  1);
  //PyModule_AddIntConstant(module, 'OPC_NS_FLAT',         2);
  //
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_UP',    1);
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_DOWN',  2);
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_TO',    3);
  //
  //PyModule_AddIntConstant(module, 'OPC_NOENUM',      0);
  //PyModule_AddIntConstant(module, 'OPC_ANALOG',      1);
  //PyModule_AddIntConstant(module, 'OPC_ENUMERATED',  2);
  //
  PyModule_AddIntConstant(module, 'OPC_STATUS_RUNNING', 1);
  PyModule_AddIntConstant(module, 'OPC_STATUS_FAILED', 2);
  PyModule_AddIntConstant(module, 'OPC_STATUS_NOCONFIG', 3);
  PyModule_AddIntConstant(module, 'OPC_STATUS_SUSPENDED', 4);
  PyModule_AddIntConstant(module, 'OPC_STATUS_TEST', 5);
  PyModule_AddIntConstant(module, 'OPC_STATUS_COMM_FAULT', 6);
  //
  //PyModule_AddIntConstant(module, 'OPC_ENUM_PRIVATE_CONNECTIONS',  1);
  //PyModule_AddIntConstant(module, 'OPC_ENUM_PUBLIC_CONNECTIONS',   2);
  //PyModule_AddIntConstant(module, 'OPC_ENUM_ALL_CONNECTIONS',      3);
  //PyModule_AddIntConstant(module, 'OPC_ENUM_PRIVATE',              4);
  //PyModule_AddIntConstant(module, 'OPC_ENUM_PUBLIC',               5);
  //PyModule_AddIntConstant(module, 'OPC_ENUM_ALL',                  6);
  //
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_FILTER_ALL',         1);
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_FILTER_BRANCHES',    2);
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_FILTER_ITEMS',       3);
  //
  //PyModule_AddIntConstant(module, 'OPC_READABLE',                  $01);
  //PyModule_AddIntConstant(module, 'OPC_WRITEABLE',                 $02);
  //
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_HASCHILDREN',        $01);
  //PyModule_AddIntConstant(module, 'OPC_BROWSE_ISITEM',             $02);

  PyModule_AddIntConstant(module, 'OPC_QUALITY_MASK', $C0);
  PyModule_AddIntConstant(module, 'OPC_STATUS_MASK', $FC);
  //PyModule_AddIntConstant(module, 'OPC_LIMIT_MASK',                $03);

  PyModule_AddIntConstant(module, 'OPC_QUALITY_BAD', $00);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_UNCERTAIN', $40);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_GOOD', $C0);

  PyModule_AddIntConstant(module, 'OPC_QUALITY_CONFIG_ERROR', $04);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_NOT_CONNECTED', $08);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_DEVICE_FAILURE', $0C);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_SENSOR_FAILURE', $10);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_LAST_KNOWN', $14);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_COMM_FAILURE', $18);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_OUT_OF_SERVICE', $1C);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_WAITING_FOR_INITIAL_DATA', $20);

  PyModule_AddIntConstant(module, 'OPC_QUALITY_LAST_USABLE', $44);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_SENSOR_CAL', $50);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_EGU_EXCEEDED', $54);
  PyModule_AddIntConstant(module, 'OPC_QUALITY_SUB_NORMAL', $58);

  PyModule_AddIntConstant(module, 'OPC_QUALITY_LOCAL_OVERRIDE', $D8);

  //PyModule_AddIntConstant(module, 'OPC_LIMIT_OK',     $00);
  //PyModule_AddIntConstant(module, 'OPC_LIMIT_LOW',    $01);
  //PyModule_AddIntConstant(module, 'OPC_LIMIT_HIGH',   $02);
  //PyModule_AddIntConstant(module, 'OPC_LIMIT_CONST',  $03);
  //
  //PyModule_AddIntConstant(module, 'OPC_PROP_CDT',             1);
  //PyModule_AddIntConstant(module, 'OPC_PROP_VALUE',           2);
  //PyModule_AddIntConstant(module, 'OPC_PROP_QUALITY',         3);
  //PyModule_AddIntConstant(module, 'OPC_PROP_TIME',            4);
  //PyModule_AddIntConstant(module, 'OPC_PROP_RIGHTS',          5);
  //PyModule_AddIntConstant(module, 'OPC_PROP_SCANRATE',        6);
  //
  //PyModule_AddIntConstant(module, 'OPC_PROP_UNIT',            100);
  //PyModule_AddIntConstant(module, 'OPC_PROP_DESC',            101);
  //PyModule_AddIntConstant(module, 'OPC_PROP_HIEU',            102);
  //PyModule_AddIntConstant(module, 'OPC_PROP_LOEU',            103);
  //PyModule_AddIntConstant(module, 'OPC_PROP_HIRANGE',         104);
  //PyModule_AddIntConstant(module, 'OPC_PROP_LORANGE',         105);
  //PyModule_AddIntConstant(module, 'OPC_PROP_CLOSE',           106);
  //PyModule_AddIntConstant(module, 'OPC_PROP_OPEN',            107);
  //PyModule_AddIntConstant(module, 'OPC_PROP_TIMEZONE',        108);
  //
  //PyModule_AddIntConstant(module, 'OPC_PROP_DSP',             200);
  //PyModule_AddIntConstant(module, 'OPC_PROP_FGC',             201);
  //PyModule_AddIntConstant(module, 'OPC_PROP_BGC',             202);
  //PyModule_AddIntConstant(module, 'OPC_PROP_BLINK',           203);
  //PyModule_AddIntConstant(module, 'OPC_PROP_BMP',             204);
  //PyModule_AddIntConstant(module, 'OPC_PROP_SND',             205);
  //PyModule_AddIntConstant(module, 'OPC_PROP_HTML',            206);
  //PyModule_AddIntConstant(module, 'OPC_PROP_AVI',             207);
  //
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMSTAT',         300);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMHELP',         301);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMAREAS',        302);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMPRIMARYAREA',  303);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMCONDITION',    304);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMLIMIT',        305);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMDB',           306);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMHH',           307);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMH',            308);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALML',            309);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMLL',           310);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMROC',          311);
  //PyModule_AddIntConstant(module, 'OPC_PROP_ALMDEV',          312);

  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_DATATYPE',            1);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_VALUE',               2);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_QUALITY',             3);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_TIMESTAMP',           4);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_ACCESS_RIGHTS',       5);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_SCAN_RATE',           6);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_EU_TYPE',             7);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_EU_INFO',             8);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_EU_UNITS',            100);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_DESCRIPTION',         101);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_HIGH_EU',             102);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_LOW_EU',              103);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_HIGH_IR',             104);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_LOW_IR',              105);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_CLOSE_LABEL',         106);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_OPEN_LABEL',          107);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_TIMEZONE',            108);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_CONDITION_STATUS',    300);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_ALARM_QUICK_HELP',    301);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_ALARM_AREA_LIST',     302);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_PRIMARY_ALARM_AREA',  303);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_CONDITION_LOGIC',     304);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_LIMIT_EXCEEDED',      305);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_DEADBAND',            306);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_HIHI_LIMIT',          307);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_HI_LIMIT',            308);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_LO_LIMIT',            309);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_LOLO_LIMIT',          310);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_CHANGE_RATE_LIMIT',   311);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_DEVIATION_LIMIT',     312);
  //PyModule_AddIntConstant(module, 'OPC_PROPERTY_SOUND_FILE',          313);

  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_DATATYPE',            'Item Canonical Data Type');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_VALUE',               'Item Value');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_QUALITY',             'Item Quality');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_TIMESTAMP',           'Item Timestamp');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_ACCESS_RIGHTS',       'Item Access Rights');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_SCAN_RATE',           'Server Scan Rate');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_EU_TYPE',             'Item EU Type');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_EU_INFO',             'Item EU Info');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_EU_UNITS',            'EU Units');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_DESCRIPTION',         'Item Description');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_HIGH_EU',             'High EU');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_LOW_EU',              'Low EU');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_HIGH_IR',             'High Instrument Range');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_LOW_IR',              'Low Instrument Range');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_CLOSE_LABEL',         'Contact Close Label');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_OPEN_LABEL',          'Contact Open Label');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_TIMEZONE',            'Item Timezone');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_CONDITION_STATUS',    'Condition Status');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_ALARM_QUICK_HELP',    'Alarm Quick Help');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_ALARM_AREA_LIST',     'Alarm Area List');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_PRIMARY_ALARM_AREA',  'Primary Alarm Area');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_CONDITION_LOGIC',     'Condition Logic');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_LIMIT_EXCEEDED',      'Limit Exceeded');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_DEADBAND',            'Deadband');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_HIHI_LIMIT',          'HiHi Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_HI_LIMIT',            'Hi Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_LO_LIMIT',            'Lo Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_LOLO_LIMIT',          'LoLo Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_CHANGE_RATE_LIMIT',   'Rate of Change Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_DEVIATION_LIMIT',     'Deviation Limit');
  //PyModule_AddStringConstant(module, 'OPC_PROPERTY_DESC_SOUND_FILE',          'Sound File');
  //-----------------------
end;

//------------------------------------------------------------------------------------------------------------------------------------------
//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_CoInitialize;
var  HR: HRESULT;
begin
  Result := nil;
  try
    HR := CoInitialize(nil);
  except
    on e: Exception do
    begin
      SetPyError('CoInitialize', e);
      Exit;
    end;
  end;
  Result := Py_BuildValue('i', HR);
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_CoInitializeEx;
var
  HR: HRESULT;
  dwCoInit: Longint;
  keys: array [0 .. 1] of c_chars;
begin
  Result := nil;
  keys[0] := 'dwCoInit';
  keys[1] := nil;
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'i', keys, @dwCoInit) = 0 then // COINIT_MULTITHREADED
  begin
    Result := nil;
    Exit
  end;
  try
    HR := CoInitializeEx(nil, dwCoInit);
  except
    on e: Exception do
    begin
      SetPyError('CoInitializeEx', e);
      Exit;
    end;
  end;
  Result := Py_BuildValue('i', HR);
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_CoInitializeSecurity;
const
  RPC_C_AUTHN_LEVEL_NONE = 1;
  RPC_C_IMP_LEVEL_IMPERSONATE = 3;
  EOAC_NONE = 0;
var
  HR: HRESULT;
begin
  Result := nil;
  try
    HR := CoInitializeSecurity(
      nil,                    // points to security descriptor
      -1,                     // count of entries in asAuthSvc
      nil,                    // array of names to register
      nil,                    // reserved for future use
      RPC_C_AUTHN_LEVEL_NONE, // the default authentication level for proxies
      RPC_C_IMP_LEVEL_IMPERSONATE,// the default impersonation level for proxies
      nil,                    // used only on Windows 2000
      EOAC_NONE,              // additional client or server-side capabilities
      nil                     // reserved for future use
      );
  except
   on e: Exception do
   begin
     SetPyError('CoInitializeSecurity', e);
     Exit;
   end;
  end;
  Result := Py_BuildValue('i', HR);
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_CoUninitialize(self: pPyObject): pPyObject; cdecl;
begin
  Result := nil;
  try
    CoUninitialize();
  except
    on e: Exception do
    begin
      SetPyError('CoUninitialize', e);
      Exit;
    end;
  end;
  Result := Py_BuildValue('O', Py_None());
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_Connect;
var
  name, host, clsid: c_chars;
  ServerIf: TInterface;
  sName,sGUID,rHost: string;
  guid: TGUID;
  keys: array [0 .. 3] of c_chars;
begin
  ServerIf.Intrfc := nil;
  Result := nil;
  keys[0] := 'Host';
  keys[1] := 'ServerName';
  keys[2] := 'ServerCLSID';
  keys[3] := nil;
  host := '';
  name := '';
  clsid := '';
  if PyArg_ParseTupleAndKeywords(args, kwargs, '|sss', keys, @host, @name, @clsid) = 0 then
    Exit;
  rHost := UTF8ToString(host);
  sName := UTF8ToString(name);
  sGUID := UTF8ToString(clsid);
  if (sName = '') and (sGUID = '') then
    raise Exception.Create(format('Необходимо указать один из параметров "%s" или "%s"', [c_charsAsStr(keys[1]), c_charsAsStr(keys[2])]));
  try
    if sGUID = '' then
      guid := ProgIDToClassID(sName)
    else
      try
        guid := StringToGUID(sGUID);
        sName := sGUID;
      except
        on e: Exception do
        begin
          SetPyError('ConnectedToOPC', e, sGUID);
          Exit;
        end;
      end;
    if rHost = '' then
      ServerIf.Intrfc := CreateComObject(guid) as IOPCServer
    else
      ServerIf.Intrfc := CreateRemoteComObject(rHost, guid) as IOPCServer;
    Result := Py_BuildValue('N&', @convert_IUnknownToPyObj, @ServerIf);
  except
    on e: Exception do
    begin
      SetPyError('ConnectedToOPC', e, sName);
      ServerIf.Intrfc := nil;
      Exit;
    end;
  end;
  ServerIf.Intrfc := nil;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_ServerGetStatus(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
var
  keys: array[0..1] of c_chars;

  ServerIf: TInterface;
  Status: POPCSERVERSTATUS;
  s: string;

  ret: HRESULT;
begin
  Result := nil;
  keys[0] := 'Server';
  keys[1] := nil;
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&', keys, @convert_PyobjToIUnknown, @ServerIf ) = 0 then
    Exit;
  try
    ret := (ServerIf.Intrfc as IOPCServer).GetStatus(Status);
    if Succeeded(ret) then
    begin
      try
      //s := OleStrToString(Status.szVendorInfo);
      s := WideCharToString(Status.szVendorInfo);
      Result := Py_BuildValue('OOO kkk HHH s',
               PyDateTime_FromTDateTime(FileTimeToDateTime(Status.ftStartTime)),
               PyDateTime_FromTDateTime(FileTimeToDateTime(Status.ftCurrentTime)),
               PyDateTime_FromTDateTime(FileTimeToDateTime(Status.ftLastUpdateTime)),

               Status.dwServerState,
               Status.dwGroupCount,
               Status.dwBandWidth,

               Status.wMajorVersion,
               Status.wMinorVersion,
               Status.wBuildNumber,

               UTF8Encode(s));
               //OleStrToString(Status.szVendorInfo))
      except
        on e: Exception do
        begin
          SetPyError('ServerGetStatus', e);

        end;
      end;

      //MesBox(OleStrToString(Status.szVendorInfo));
      CoTaskMemFree(Status.szVendorInfo);
      CoTaskMemFree(Status);
    end
    else
      raise Exception.CreateHelp('Ошибка получения статуса сервера', ret);
  except
    on e: Exception do
    begin
      SetPyError('ServerGetStatus', e);
    end;
  end;
  ServerIf.Intrfc := nil;
end;

// ------------------------------------------------------------------------------------------------------------------------------------------
function OPC_ServerAddGroup;
var
  ServerIf: TInterface;

  Name: PWideChar;
  GrpName: c_chars;
  Active: c_int;//Boolean;
  UpdateRate: DWORD;
  GroupID: OPCHANDLE;

  PercentDeadBand: Single;
  RevisedUpdateRate: DWORD;

  GroupIf: TInterface;
  GroupeHandle: OPCHANDLE;

  ret: HRESULT;

  keys: array[0..6] of c_chars;
begin
  Result := nil;
  keys[0] := 'Server';
  keys[1] := 'GroupName';
  keys[2] := 'Active';
  keys[3] := 'UpdateRate';
  keys[4] := 'GroupID';
  keys[5] := 'DeadBand';
  keys[6] := nil;
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&spkkf', keys, @convert_PyobjToIUnknown, @ServerIf, @GrpName, @Active, @UpdateRate, @GroupID, @PercentDeadBand ) = 0 then
    Exit;
  try
    Name := PWideChar(UTF8ToString(GrpName));
    //---------------------
    ret := (ServerIf.Intrfc as IOPCServer).AddGroup(Name, Active<>0, UpdateRate, GroupID, nil, @PercentDeadBand, 0,
            GroupeHandle, RevisedUpdateRate, IOPCItemMgt, IUnknown(GroupIf.Intrfc));
    if Failed(ret) then
      raise Exception.CreateHelp('Невозможно добавить группу на сервер', ret);
    //---------------------
    Result := Py_BuildValue('N&k', @convert_IUnknownToPyObj, @GroupIf, GroupeHandle);
  except
    on e: Exception do
    begin
      SetPyError('ServerAddGroup', e);
    end;
  end;
  ServerIf.Intrfc := nil;
  GroupIf.Intrfc := nil;
end;

//------------------------------------------------------------------------------------------------------------------------------------------
function OPC_GroupAddItem;
var
  GroupIf: TInterface;
  tag: c_chars;
  tagID: OPCHANDLE;

  ItemHandle: OPCHANDLE;
  VlType: TVarType;

  ItemDef: OPCITEMDEF;
  res: POPCITEMRESULTARRAY;
  Errors: PResultList;
  ret: HRESULT;

  keys: array[0..3] of c_chars;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'Tag';
  keys[2] := 'TagID';
  //keywords[3] := 'DataType';
  keys[3] := nil;
  if PyArg_ParseTupleAndKeywords(args,kwargs, 'O&sk', keys, @convert_PyobjToIUnknown, @GroupIf, @tag, @tagID) = 0 then
    Exit;
  try
    //---------------------
    if GroupIf.Intrfc=nil then
      raise Exception.Create('"Group" is NULL');
    ItemDef.szAccessPath := '';
    ItemDef.szItemID := PWideChar(WideString(tag));
    ItemDef.bActive := True;
    ItemDef.hClient := tagID;
    ItemDef.dwBlobSize := 0;
    ItemDef.pBlob := nil;
    ItemDef.vtRequestedDataType := VT_EMPTY; //DataType := VT_EMPTY;

    ret := (GroupIf.Intrfc as IOPCItemMgt).AddItems(1, @ItemDef, res, Errors);

    if Failed(ret) then
      raise Exception.CreateHelp(Format('Невозможно добавить объект <%s> (%d) в группу',[tag, tagID]), ret)
    else
    begin
      try
        ItemHandle := res[0].hServer;
        VlType     := res[0].vtCanonicalDataType;
      finally
        CoTaskMemFree(res[0].pBlob);
        CoTaskMemFree(res);
        CoTaskMemFree(Errors);
      end;
    end;
    //---------------------
    Result := Py_BuildValue('kH', ItemHandle, VlType);
  except
    on e: Exception do
    begin
      SetPyError('GroupAddItem', e);
    end;
  end;
  GroupIf.Intrfc := nil;
end;
// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_SetCallBack;
var
  ConnectionPointContainer: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;
  AsyncConnection: LongInt;
  ret: HRESULT;
var
  GroupIf: TInterface;
  PyCallback: pPyObject;
  OPCCallback: TInterface;

  keys: array[0..2] of c_chars;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'CallBackFunction';
  keys[2] := nil;
  //if PyArg_ParseTuple(args, 'O&O', @convert_PyobjToIUnknown, @GroupIf, @PyCallback) = 0 then
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&O', keys, @convert_PyobjToIUnknown, @GroupIf, @PyCallback) = 0 then
    Exit;
  OPCCallback.Intrfc := nil;
  try
    if PyCallable_Check(PyCallback)=0 then
      raise Exception.Create('Объект на является callback`ом');
    ret := E_FAIL;
    ConnectionPointContainer := GroupIf.Intrfc as IConnectionPointContainer;
    ret := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback, ConnectionPoint);
    if Succeeded(ret) and (ConnectionPoint <> nil) then
    begin
      OPCCallback.Intrfc := TOPCDataCallback.Create(PyCallback);
      ret := ConnectionPoint.Advise(OPCCallback.Intrfc as IUnknown, AsyncConnection);
     end;
    if Failed(ret) then
      raise Exception.CreateHelp('Ошибка установки функции обратного вызова', ret);
    Result := Py_BuildValue('N&l', @convert_IUnknownToPyobj, @OPCCallback, AsyncConnection);
  except
    on e: Exception do
    begin
      SetPyError('SetCallBack', e);
    end;
  end;
  GroupIf.Intrfc := nil;
  OPCCallback.Intrfc := nil;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_DelCallBack;
var
  GroupIf: TInterface;
  AsyncConnection: LongInt;
  ret: HRESULT;

  ConnectionPointContainer: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;

  keys: array[0..2] of c_chars;
begin
  //PyGILState := PyGILState_Ensure();
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'AsyncConnection';
  keys[2] := nil;
  //if PyArg_ParseTuple(args, 'O&l', @convert_PyobjToIUnknown, @GroupIf, @AsyncConnection) = 0 then
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&l', keys, @convert_PyobjToIUnknown, @GroupIf, @AsyncConnection) = 0 then
    Exit;
  try
    ret := E_FAIL;
    ConnectionPointContainer := GroupIf.Intrfc as IConnectionPointContainer;
    if ConnectionPointContainer <> nil then
    begin
      ret := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback, ConnectionPoint);
      if Succeeded(ret) and (ConnectionPoint <> nil) then
      begin
        ret := ConnectionPoint.Unadvise(AsyncConnection);
      end;
    end;
    if Failed(ret) then
      raise Exception.CreateHelp('Ошибка удаления функции обратного вызова', ret);
    Result := Py_BuildValue('');
  except
    on e: Exception do
    begin
      SetPyError('DelCallBack', e);
    end;
  end;
  ConnectionPointContainer := nil;
  GroupIf.Intrfc := nil;
  //PyGILState_Release(PyGILState);
end;


// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_SetCallBack2;
var
  ConnectionPointContainer: IConnectionPointContainer;
  ConnectionPoint: IConnectionPoint;
  AsyncConnection: Int32;
  ret: HRESULT;
var
  GroupIf: TInterface;
  PyCallback, PyCallbackObj: pPyObject;
  OPCCallback: TInterface;
  keys: array[0..2] of c_chars;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'CallBackObject';
  keys[2] := nil;
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&O', keys, @convert_PyobjToIUnknown, @GroupIf, @PyCallbackObj) = 0 then
  //if PyArg_ParseTuple(args, 'O&O', @convert_PyobjToIUnknown, @GroupIf, @PyCallbackObj) = 0 then
    Exit;
  OPCCallback.Intrfc := nil;
  try
    if PyObject_HasAttrString(PyCallbackObj, c_chars(c_charsAsStr(CallBackProcedureName)))=0 then
      raise Exception.Create(format('Объект на не содержит функции <%s>',[CallBackProcedureName]) );
    PyCallback := PyObject_GetAttrString(PyCallbackObj, c_chars(c_charsAsStr(CallBackProcedureName)))  ;
    if PyCallable_Check(PyCallback)=0 then
      raise Exception.Create('Объект на является callback`ом');
    //PyCallback.
    ret := E_FAIL;
    ConnectionPointContainer := GroupIf.Intrfc as IConnectionPointContainer;
    //MessageBox(0,PWideChar(IntToStr(Integer(GroupIf.Intrfc))),'',0);
    ret := ConnectionPointContainer.FindConnectionPoint(IID_IOPCDataCallback, ConnectionPoint);
    if Succeeded(ret) and (ConnectionPoint <> nil) then
    begin
      OPCCallback.Intrfc := TOPCDataCallback.Create(PyCallback);
      ret := ConnectionPoint.Advise(OPCCallback.Intrfc as IUnknown, AsyncConnection);
     end;
    if Failed(ret) then
      raise Exception.CreateHelp('Ошибка установки функции обратного вызова', ret);
    Result := Py_BuildValue('N&l', @convert_IUnknownToPyobj, @OPCCallback, AsyncConnection);
    //MessageBox(0,'2','',0);
  except
    on e: Exception do
    begin
      SetPyError('SetCallBack', e);
    end;
  end;
  GroupIf.Intrfc := nil;
  OPCCallback.Intrfc := nil;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_GroupItemRead(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
var
  keys: array[0..2] of c_chars;

  GroupIf: TInterface;
  ItemHandle: OPCHANDLE;

  SyncIOIf: IOPCSyncIO;
  ItemValues: POPCITEMSTATEARRAY;
  Errors: PResultList;

  data: TOPCData;

  ret: HRESULT;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'ItemHandle';
  keys[2] := nil;

  if PyArg_ParseTupleAndKeywords(args,kwargs, 'O&k', keys, @convert_PyobjToIUnknown, @GroupIf, @ItemHandle) = 0 then
    Exit;
  try
    ret := E_FAIL;
    SyncIOIf := GroupIf.Intrfc as IOPCSyncIO;
    if SyncIOIf <> nil then
    begin
      ret := SyncIOIf.Read(OPC_DS_CACHE, 1, @ItemHandle, ItemValues, Errors);
      if Succeeded(ret) then
      begin
        ret := Errors[0];
        if Succeeded(ret) then
          with data do
          begin
            CoTaskMemFree(Errors);
            Value    := ItemValues[0].vDataValue;
            DateTime := FileTimeToDateTime(ItemValues[0].ftTimeStamp);
            Quality  := ItemValues[0].wQuality;
            ValType  := VarType(Value);
            VariantClear(ItemValues[0].vDataValue);
            CoTaskMemFree(ItemValues);
          end;
      end;
      if Failed(ret) then
        raise Exception.CreateHelp(Format('Ошибка чтения значения. (Дискриптор %d)', [ItemHandle]), ret);
      Result := Py_BuildValue('OOHH', VariantToPyobj(data.Value), PyDateTime_FromTDateTime(data.DateTime), data.ValType, data.Quality);
    end;
  except
    on e: Exception do
    begin
      SetPyError('GroupItemRead', e);
    end;
  end;
  GroupIf.Intrfc := nil;
  SyncIOIf := nil;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_GroupItemWrite(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
var
  keys: array[0..4] of c_chars;

  GroupIf: TInterface;
  ItemHandle: OPCHANDLE;
  VType: TVarType;
  pyValue: pPyObject;

  SyncIOIf: IOPCSyncIO;
  ItemValues: OleVariant;
  Errors: PResultList;

  ret: HRESULT;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'ItemHandle';
  keys[2] := 'VariantType';
  keys[3] := 'Value';
  keys[4] := nil;
  if PyArg_ParseTupleAndKeywords(args,kwargs, 'O&kHO', keys, @convert_PyobjToIUnknown, @GroupIf, @ItemHandle, @VType, @pyValue) = 0 then
    Exit;
  try
    SyncIOIf := GroupIf.Intrfc as IOPCSyncIO;
    if SyncIOIf <> nil then
    begin
      ItemValues := PyobjToVariant(pyValue, VType);
      ret := SyncIOIf.Write(1, @ItemHandle, @ItemValues, Errors);
      if Succeeded(ret) then
      begin
        ret := Errors[0];
        CoTaskMemFree(Errors);
      end;
    end;
    if Failed(ret) then
      raise Exception.CreateHelp(Format('Ошибка записи значения. (Дискриптор %d)', [ItemHandle]), ret);
    Result := Py_BuildValue('');
  except
    on e: Exception do
    begin
      SetPyError('GroupItemWrite', e);
      //MesBox('171');
    end;
  end;
  //MesBox('18');
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_GroupItemWrite2(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
var
  keys: array[0..6] of c_chars;

  GroupIf: TInterface;
  ItemHandle: OPCHANDLE;
  VType: TVarType;
  pyValue: pPyObject;
  pyQuality: pPyObject;
  pyTime: pPyObject;


  SyncIO2If: IOPCSyncIO2;
  ItemValues: OPCITEMVQT;
  Errors: PResultList;

  ret: HRESULT;
begin
  Result := nil;
  keys[0] := 'Group';
  keys[1] := 'ItemHandle';
  keys[2] := 'VariantType';
  keys[3] := 'Value';
  keys[4] := 'Quality';
  keys[5] := 'TimeStamp';
  keys[6] := nil;
  pyQuality := Py_None();
  pyTime    := Py_None();
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&kHO|OO', keys, @convert_PyobjToIUnknown, @GroupIf,
        @ItemHandle, @VType, @pyValue, @pyQuality, @pyTime) = 0 then
    Exit;
  try
    SyncIO2If := GroupIf.Intrfc as IOPCSyncIO2;
    if SyncIO2If <> nil then
    begin
      with ItemValues do begin
        vDataValue := PyobjToVariant(pyValue, VType);
        bQualitySpecified := PyLong_Check(pyQuality);
        if bQualitySpecified then
          wQuality := PyLong_AsLongLong(pyQuality);
        wReserved := 0;
        dwReserved := 0;
        bTimeStampSpecified := False;
        bTimeStampSpecified := PyDateTime_Check(pyTime);
        if bTimeStampSpecified then
          ftTimeStamp := DateTimeToFileTime( TDateTime_FromPyDateTime(pyTime) );
      end;
      ret := SyncIO2If.WriteVQT(1, @ItemHandle, @ItemValues, Errors);
      if Succeeded(ret) then
      begin
        ret := Errors[0];
        CoTaskMemFree(Errors);
      end;
    end;
    if Failed(ret) then
      raise Exception.CreateHelp(Format('Ошибка записи значения. (Дискриптор %d)', [ItemHandle]), ret);
    Result := Py_BuildValue('');
  except
    on e: Exception do
    begin
      SetPyError('GroupItemWrite2', e);
    end;
  end;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------
function OPC_GroupRemove(self: pPyObject; args, kwargs: pPyObject): pPyObject; cdecl;
var
  keys: array[0..3] of c_chars;

  ServerIf: TInterface;
  srv: IOPCServer;
  GroupHandle: OPCHANDLE;
  //Force: pPyObject;//Boolean;
  Force: c_int;//Boolean;

  ret: HRESULT;
begin
  Result := nil;
  keys[0] := 'Server';
  keys[1] := 'GroupHandel';
  keys[2] := 'Force';
  //keys[3] := 'reserved';
  keys[3] := nil;
  Force := 0;
  if PyArg_ParseTupleAndKeywords(args, kwargs, 'O&kp', keys, @convert_PyobjToIUnknown, @ServerIf, @GroupHandle, @Force ) = 0 then
    Exit;
  try
    srv := (ServerIf.Intrfc as IOPCServer);
    ret := srv.RemoveGroup(GroupHandle, Force<>0);
    if Failed(ret) then
      raise Exception.CreateHelp('Ошибка уделения группы', ret);
    Result := Py_BuildValue('');
  except
    on e: Exception do
    begin
      SetPyError('GroupRemove', e);
    end;
  end;
  ServerIf.Intrfc := nil;
end;

// -----------------------------------------------------------------------------------------------------------------------------------------

end.
