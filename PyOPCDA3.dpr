library PyOPCDA3;

{ Important note about DLL memory management: ShareMem must be the
  first unit in your library's USES clause AND your project's (select
  Project-View Source) USES clause if your DLL exports any procedures or
  functions that pass strings as parameters or function results. This
  applies to all strings passed to and from your DLL--even those that
  are nested in records and classes. ShareMem is the interface unit to
  the BORLNDMM.DLL shared memory manager, which must be deployed along
  with your DLL. To avoid using BORLNDMM.DLL, pass string information
  using PChar or ShortString parameters. }

uses
  System.SysUtils,
  System.Classes,
  c_types in 'include\c_types.pas',
  PythonLib in 'include\PythonLib.pas',
  _tools_ in 'include\_tools_.pas',
  uMain in 'uMain.pas',
  object_h in 'include\object_h.pas',
  moduleobject_h in 'include\moduleobject_h.pas',
  uPyFunctions in 'uPyFunctions.pas',
  methodobject_h in 'include\methodobject_h.pas',
  pythread_h in 'include\pythread_h.pas',
  datetime_h in 'include\datetime_h.pas',
  uOPCRealese in 'uOPCRealese.pas',
  OPC_AE in 'OPCDef\OPC_AE.pas',
  OPCCOMN in 'OPCDef\OPCCOMN.pas',
  OPCDA in 'OPCDef\OPCDA.pas',
  OPCerror in 'OPCDef\OPCerror.pas',
  OPCHDA in 'OPCDef\OPCHDA.pas',
  OPCSEC in 'OPCDef\OPCSEC.pas',
  OPCtypes in 'OPCDef\OPCtypes.pas',
  uPyOPCTypes in 'uPyOPCTypes.pas';

{$R *.res}
{$E pyd}
{$IFNDEF WIN32}
  Только для Win 32bit !!!
  т. к. OPC DA 32-х битный
{$IFEND}
exports
  PyInit_PyOPCDA3;
begin
end.

