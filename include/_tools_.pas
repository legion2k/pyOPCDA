unit _tools_;

interface
uses System.SysUtils;

procedure MesBox(Text: string; Caption: string='');

//function  ErrorToStr(error: Exception; AdditionalString: string=''): String;
procedure SetPyError(ErName: string; error: Exception = nil; AdditionalString: string=''); //inline;


implementation
uses
  {$IFDEF MSWINDOWS}Winapi.Windows,{$ENDIF}
  c_types, PythonLib;

procedure MesBox(Text, Caption: string);
begin
  {$IFDEF MSWINDOWS}
  MessageBox(0, LPCWSTR(Text), LPCWSTR(Caption), 0);
  {$ENDIF}
end;

function  ErrorToStr(error: Exception; AdditionalString: string=''): String;
begin
  if AdditionalString='' then
    Result := error.Message
  else
    Result := Format('"%s" - %s',[AdditionalString, error.Message]);

  if error.HelpContext<>0 then
    Result := Format('%s [Код ощибки $%x]',[Result, error.HelpContext])
end;

procedure SetPyError;
begin
  try
    // -------------------------------
    if error = nil then
      PyErr_SetString(PyErr_NewException(c_chars(c_charsAsStr('PyOPCDA3.TEST')), nil, nil), UTF8Encode(ErName))
    else
    begin
      PyErr_SetString(PyErr_NewException(c_chars(c_charsAsStr(Format('PyOPCDA3.%s', [ErName]))), nil, nil),
        UTF8Encode(ErrorToStr(error, AdditionalString)));
      //MesBox(ErrorToStr(error, AdditionalString), Format('PyOPCDA3.%s', [ErName]));
    end;
    // -------------------------------
//    if PyGILState_Check()=1 then
//    begin
//      t := PyGILState_GetThisThreadState();
//      //PyThreadState_SetAsyncExc(t.thread_id, PyErr_NewException(c_chars(c_String(Format('PyOPCDA3.%s', [ErName]))),nil,nil));
//      //PyErr_PrintEx(0);
//    end;
  except
    on e: Exception do
    begin
      MesBox(e.Message, format('Сбой: %s',[ErName]))
    end;
  else
    MesBox('Неопознанная ошибка', format('Сбой: %s',[ErName]))
  end;
end;



end.
