unit uAutorizacion;

interface

uses System.SysUtils, System.Classes, System.Hash;

var
  CodigoUsuario: String;

function GenerarToken: String; overload;
function GenerarToken(pValue: String): String; overload;

function ValidarTokenUsuario(pAuthorization: String): Boolean;
function ValidarTokenGeneral(pAuthorization: String): Boolean;

function EncriptarContrasena (pPassword : String ) : String;


implementation

uses uDBModulo;

function GenerarToken: String;
var
  sKey: String;
begin
  try
    sKey := DateTimeToStr(date) + 'Examanes';
    Result := THashSHA2.GetHMAC(DateTimeToStr(date), sKey, SHA256);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;

end;

function GenerarToken(pValue: String): String;
var
  sKey: String;
begin
  try
    sKey := DateTimeToStr(date) + pValue;
    Result := THashSHA2.GetHMAC(pValue, sKey, SHA256);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;

end;

function ValidarTokenUsuario(pAuthorization: String): Boolean;
begin
  Result := False;
  try
    if DBModulo.Conexion then
    begin

      try
        DBModulo.sqlQuery.Close;
        DBModulo.sqlQuery.SQL.Clear;
        DBModulo.sqlQuery.SQL.Add
          ('Select codigousuario from usuario where token=:token');
        DBModulo.sqlQuery.ParamByName('token').AsString := pAuthorization;
        DBModulo.sqlQuery.Open;

        if not DBModulo.sqlQuery.IsEmpty then
        begin
          Result := True;
          CodigoUsuario := DBModulo.sqlQuery.FieldByName
            ('codigousuario').AsString;
        end;
      except
        on E: Exception do
        begin
          Result := False;
          raise Exception.Create
            ('No hay autorización para realizar la acción.');
        end;
      end;
    end;

  finally
    DBModulo.cerrarConexion;
  end;
end;

function ValidarTokenGeneral(pAuthorization: String): Boolean;
begin
  Result := False;

  if GenerarToken = pAuthorization then
    Result := True;

end;

function EncriptarContrasena (pPassword : String ) : String;
begin
 Result := GenerarToken(pPassword);
end;


end.
