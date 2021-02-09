unit uSesion;

interface

uses JSON, System.SysUtils;

function IniciarSesion(pAuthorization, pUser, pContrasena: String): Boolean;
function AsignarContrasena(pUser: String): String;

implementation

uses UFuncionesGenerales, uAutorizacion, uDBModulo, uMensajes;

function IniciarSesion(pAuthorization, pUser, pContrasena: String): Boolean;
begin
  Result := False;
  try
    if ValidarTokenGeneral(pAuthorization) then
    begin
      if DbModulo.Conexion then
      begin

        try
          DbModulo.sqlQuery.Close;
          DbModulo.sqlQuery.SQL.Clear;
          DbModulo.sqlQuery.SQL.Add
            ('Select count(*) as cantidad from usuario where login=:login and contrasena=:contrasena ');
          DbModulo.sqlQuery.ParamByName('login').AsString := pUser;
          DbModulo.sqlQuery.ParamByName('contrasena').AsString := pContrasena;
          DbModulo.sqlQuery.Open;

          if DbModulo.sqlQuery.FieldByName('cantidad').AsInteger > 0 then
          begin
            Result := True;
          end;

        except
          on E: Exception do
          begin
            raise Exception.Create
              ('Ha ocurrido un error, no es posible iniciar sesión, ingrese otras credenciales e intente nuevamente.');
          end;
        end;
      end;
    end;

  finally
    DbModulo.CerrarConexion;
  end;

end;

function AsignarContrasena(pUser: String): String;
var
  Token: String;
begin
  Token := '';
  try
    if DbModulo.Conexion then
    begin
      Token := GenerarToken(pUser);
      try
        DbModulo.sqlQuery.Close;
        DbModulo.sqlQuery.SQL.Clear;
        DbModulo.sqlQuery.SQL.Add
          ('update  usuario set token=:token  where login=:login ');
        DbModulo.sqlQuery.ParamByName('login').AsString := pUser;
        DbModulo.sqlQuery.ParamByName('token').AsString := Token;
        DbModulo.sqlQuery.ExecSQL;

        if DbModulo.sqlQuery.RowsAffected > 0 then
        begin
         Result := GenerarMensaje('token', Token);
        end
        else
         Result :=  GenerarMensaje(TKindError,
            'Ha ocurrido un error, no es posible asignar el token al usaurio, ingrese otras credenciales e intente nuevamente.');

      except
        on E: Exception do
        begin
          raise Exception.Create
            ('Ha ocurrido un error, no es posible iniciar sesión, ingrese otras credenciales e intente nuevamente.');
        end;
      end;
    end;

  finally
    DbModulo.CerrarConexion;
  end;

end;

end.
