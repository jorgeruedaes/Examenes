unit uMensajes;

interface

uses uFuncionesGenerales, JSON;

function GenerarMensaje(pKind: TKindMessage; pMessage: String): String; overload;
function GenerarMensaje(pKey, pMessage: String): String; overload;

implementation

function GenerarMensaje(pKind: TKindMessage; pMessage: String): String;
var
  js: TJSONObject;
  sKey: String;
begin

  try
    js := TJSONObject.Create;

    if pKind = TKindError then
      sKey := 'Error'
    else if pKind = TKindWarning then
      sKey := 'Warning'
    else if pKind = TKindSuccesful then
      sKey := 'Succesful'
    else
      sKey := 'Question';

    js.AddPair(sKey, pMessage);
    Result := js.ToJSON;
  finally
    js.Free;
  end;
end;

function GenerarMensaje(pKey, pMessage: String): String; overload;
var
  js: TJSONObject;
begin

  try
    js := TJSONObject.Create;
    js.AddPair(pKey, pMessage);
    Result := js.ToJSON;
  finally
    js.Free;
  end;

end;

end.
