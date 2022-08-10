unit uMain;
interface
  procedure PyInit_PyOPCDA3();
implementation
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
uses System.SysUtils, {$i include/#define_Python.h}, _tools_, uPyFunctions;
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
function OnModuleExecute(module: pPyObject): c_int; cdecl;
begin
  //---------------------------------------------------------
  try
    //---------------------------------------------------
    Py_Initializate(module);
    //---------------------------------------------------
    {$IFDEF DEBUG}
    MesBox('ok', 'Init Lib');
    {$ENDIF}
    result := 0;
  except
    on e: Exception do begin
      MesBox(e.Message, 'Error Init Lib');
      Result := -1;
    end;
  end;
end;
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------------------------
const
  ModuleMethods_MAX_COUNT = 15; //количество экспортируемых функций в PYTHON
var
  ModuleDef: PyModuleDef;
  ModuleMethods: array[ 0..ModuleMethods_MAX_COUNT ] of PyMethodDef;
  slot: array[0..1] of PyModuleDef_Slot;
procedure PyInit_PyOPCDA3();
begin
  //------------------------------------------------------------
  // Объявление методов для PYTHON3
  //------------------------------------------------------------
  with ModuleMethods[0] do begin
      ml_name := 'CoInitialize';
      ml_meth := @OPC_CoInitialize;
      ml_flags := METH_NOARGS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'CoInitialize()'#10+
        'Initializes the COM library on the current thread and identifies the concurrency model as '#10+
        'single-thread apartment (STA).)'
      ));
  end;
  with ModuleMethods[1] do begin
      ml_name := 'CoInitializeEx';
      ml_meth := @OPC_CoInitializeEx;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'CoInitializeEx( dwCoInit: DWORD )'#10+
        ' - dwCoInit : The concurrency model and initialization options for the thread. Values for this '#10+
        'parameter are taken from the COINIT enumeration. Any combination of values from COINIT can be '#10+
        'used, except that the COINIT_APARTMENTTHREADED and COINIT_MULTITHREADED flags cannot both be set. '#10+
        'The default is COINIT_MULTITHREADED.'#10+
        'Initializes the COM library for use by the calling thread, sets the thread`s concurrency model, and '#10+
        'creates a new apartment for the thread if one is required.'
      ))
  end;
  with ModuleMethods[2] do begin
      ml_name := 'CoInitializeSecurity';
      ml_meth := @OPC_CoInitializeSecurity;
      ml_flags := METH_NOARGS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'CoInitializeSecurity()'#10+
        'Registers security and sets the default security values for the process.'#10+
        '(This is for DCOM:'#10+
        'without this, callbacks from the server may get blocked, depending on DCOM configuration settings)'
      ))
  end;
  with ModuleMethods[3] do begin
      ml_name := 'CoUninitialize';
      ml_meth := @OPC_CoUninitialize;
      ml_flags := METH_NOARGS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'CoUninitialize()'#10+
        'Uninitializes the COM library '
      ))
  end;
  with ModuleMethods[4] do begin
      ml_name := 'ConnectToOPC';
      ml_meth := @OPC_Connect;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'ConnectToOPC( OPCServerName: str ): <PyCapsule "PyOPCDA3.DelphiInreface">'#10+
        ' - OPCServerName : Имя OPC сервера. (Например: "Matrikon.OPC.Simulation")'#10+
        ' > Возвращает PyCapsule, содержащий подключенный интефейс OPC сервера'#10+
        'We will use the custom OPC interfaces, and OPCProxy.dll will handle marshaling for us automatically '#10+
        '(if registered)'#10
      ))
  end;
  with ModuleMethods[5] do begin
      ml_name := 'ServerGetStatus';
      ml_meth := @OPC_ServerGetStatus;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'ServerGetStatus(Server: <PyCapsule "PyOPCDA3.DelphiInreface">)'#10+
        'Return:'#10+
        '   StartTime: datetime'#10+
        '   CurrentTime: datetime'#10+
        '   LastUpdateTime: datetime'#10+
        '   ServerState: int [DWORD]'#10+
        '   GroupCount: int [DWORD]'#10+
        '   BandWidth: int [DWORD]'#10+
        '   MajorVersion: int [WORD]'#10+
        '   MinorVersion: int [WORD]'#10+
        '   BuildNumber: int [WORD]'
      ))
  end;
  with ModuleMethods[6] do begin
      ml_name := 'ServerAddGroup';
      ml_meth := @OPC_ServerAddGroup;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'ServerAddGroup( Sever: <PyCapsule "PyOPCDA3.DelphiInreface">, GroupName: str, Active: bool )'#10+
        ' - Server : '#10+
        ' - GroupName : Name of the group. The name must be unique among the other groups created by this '#10+
        '     client. If no name is provided Name is pointer to a NUL string the server will generate a '#10+
        '     unique name.'#10+
        ' - Active : '#10+
        ' - UpdateRate : int [DWORD]'#10+
        ' - GroupID : int [DWORD]'#10+
        ' - DeadBand : float'#10+
        'Return:'#10+
        '   Group: <PyCapsule "PyOPCDA3.DelphiInreface">'#10+
        '   GroupeHandle: int [DWORD]'
      ))
  end;
  with ModuleMethods[7] do begin
      ml_name := 'GroupAddItem';
      ml_meth := @OPC_GroupAddItem;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'Add an item to the group'#10+
        'GroupAddItem( Group, Tag, TagID )'
      ))
  end;
  with ModuleMethods[8] do begin
      ml_name := 'SetCallBack';
      ml_meth := @OPC_SetCallBack;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        'Set up an IConnectionPointContainer data callback for the group'#10''
      ))
  end;
  with ModuleMethods[9] do begin
      ml_name := 'DelCallBack';
      ml_meth := @OPC_DelCallBack;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''#10''
      ))
  end;
  with ModuleMethods[10] do begin
      ml_name := 'SetCallBack2';
      ml_meth := @OPC_SetCallBack2;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''#10''
      ))
  end;
  with ModuleMethods[11] do begin
      ml_name := 'GroupItemRead';
      ml_meth := @OPC_GroupItemRead;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''#10''
      ))
  end;
  with ModuleMethods[12] do begin
      ml_name := 'GroupItemWrite';
      ml_meth := @OPC_GroupItemWrite;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''#10''
      ))
  end;
  with ModuleMethods[13] do begin
      ml_name := 'GroupRemove';
      ml_meth := @OPC_GroupRemove;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''#10''
      ))
  end;
  with ModuleMethods[14] do begin
      ml_name := 'GroupItemWrite2';
      ml_meth := @OPC_GroupItemWrite2;
      ml_flags := METH_VARARGS or METH_KEYWORDS;
      ml_doc := ((//c_charsUTF8(c_charsAsStrUTF8(
        ''
      ))
  end;
  //------------------------------------------------------------
  // последный всегда NULL
  ModuleMethods[ModuleMethods_MAX_COUNT] := PyMethodDef_NULL;
  //------------------------------------------------------------
  slot[0].slot  := Py_mod_exec;
  slot[0].value := @OnModuleExecute;
  // последный всегда NULL
  slot[1] := PyModuleDef_Slot_NULL;
  //------------------------------------------------------------
  // Декларация модуля [don`t edit]
  //------------------------------------------------------------
  ModuleDef.m_base     := PyModuleDef_HEAD_INIT;
  ModuleDef.m_name     := 'PyOPCDA3';
  ModuleDef.m_doc      := 'OPC DA3 interface for Python3';
  ModuleDef.m_size     := 0;
  ModuleDef.m_methods  := @ModuleMethods[0];
  ModuleDef.m_slots    := @slot[0];
  ModuleDef.m_traverse := nil;
  ModuleDef.m_clear    := nil;
  ModuleDef.m_free     := nil;
  //------------------------------------------------------------
  //MesBox('0','0');
  PyModuleDef_Init(@ModuleDef);
  //MesBox('1','1');
end;
//initialization
//finalization
end.
