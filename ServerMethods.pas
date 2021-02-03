unit ServerMethods;

interface

uses System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth, Data.DBXFirebird, Data.DB, Data.SqlExpr,
  Data.FMTBcd, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Error,
  FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def, FireDAC.Stan.Pool,
  FireDAC.Stan.Async, FireDAC.Phys, FireDAC.Phys.FB, FireDAC.Phys.FBDef,
  FireDAC.VCLUI.Wait, FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf,
  FireDAC.DApt, FireDAC.Comp.DataSet, FireDAC.Comp.Client, System.IOUtils,
  IniFiles, FireDAC.Phys.PG, FireDAC.Phys.PGDef, FireDAC.Phys.Oracle,
  FireDAC.Phys.OracleDef, FireDAC.Phys.MySQLDef, FireDAC.Phys.MySQL,
  IdGlobal, IdHash, IdHashMessageDigest, System.Hash;

Var
  Archivo: String;
  IniFile: TIniFile;
  UserName: String;
  Password: String;
  BaseDato: String;
  DriverName: String;
  RutaBaseDato: String;
  Port: String;

type
{$METHODINFO ON}
  TMetodos = class(TDataModule)
    sqlFBConexion: TFDConnection;
    sqlQuery: TFDQuery;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure sqlFBConexionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private
    { Var privates }
    FUsuario: String;

    { Private declarations }
    function Conexion: Boolean;
    procedure CerrarConexion;
    procedure ConfirmarConexion;
    procedure CancelarConexion;
    procedure EstablecerVariablesConexion;
    procedure CargarVariablesIniciales;
    function GenerarToken(pValue: String): String;
    function ValidarToken(pAuthorization: String): Boolean;
    function GetTokenUsuario(pAuthorization: String): Boolean;
  public
    { Public declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    { Web Services }
    function Datos(pAuthorization, pValue, pParams: String): TJSONArray;
    function UpdateDatos(pAuthorization, pTable: String;
      LJsonObjet: TJSONObject): Boolean;
    function CancelDatos(pAuthorization, pValue: String): Boolean;
    function AcceptDatos(pAuthorization, pTable: String;
      LJsonObjet: TJSONObject): Boolean;

    { Web properties }
    property Usuario: String Read FUsuario Write FUsuario;

  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses System.StrUtils;

function TMetodos.AcceptDatos(pAuthorization, pTable: String;
  LJsonObjet: TJSONObject): Boolean;
var
  i: Integer;
  CadenaFields: String;
  CadenaValues: String;
begin
  Result := False;
  CadenaFields := '';
  CadenaValues := '';
  try
    try
      if GetTokenUsuario(pAuthorization) then
      begin
        if Conexion then
        begin

          if LJsonObjet.Count > 0 then
          begin
            for i := 0 to LJsonObjet.Count - 1 do
            begin

              CadenaFields := CadenaFields + LJsonObjet.Pairs[i]
                .JsonString.Value;

              CadenaValues := CadenaValues +
                QuotedStr(LJsonObjet.Pairs[i].JsonValue.Value);

              if i <> LJsonObjet.Count - 1 then
              begin
                CadenaFields := CadenaFields + ',';
                CadenaValues := CadenaValues + ',';
              end;
            end;

            sqlQuery.Close;
            sqlQuery.SQL.Clear;
            sqlQuery.SQL.Add('INSERT INTO ' + pTable + '(' + CadenaFields + ')'
              + 'values(' + CadenaValues + ')');
            sqlQuery.ExecSQL;
            ConfirmarConexion;

            if sqlQuery.RowsAffected > 0 then
              Result := True;
          end;
        end;
      end;
    except
      on E: Exception do
        CancelarConexion;
    end;

  finally
    CerrarConexion;

  end;

end;

procedure TMetodos.CancelarConexion;
begin

  try
    sqlFBConexion.Rollback;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

function TMetodos.CancelDatos(pAuthorization, pValue: String): Boolean;
begin
  Result := False;
  try
    if GetTokenUsuario(pAuthorization) then
    begin
      if Conexion then
      begin

        try

          sqlQuery.Close;
          sqlQuery.SQL.Clear;
          sqlQuery.SQL.Add(pValue);
          sqlQuery.ExecSQL;
          ConfirmarConexion;

          if sqlQuery.RowsAffected > 0 then
            Result := True;

        except
          on E: Exception do
            CancelarConexion;
        end;
      end;
    end;
  finally
    CerrarConexion;
  end;

end;

procedure TMetodos.CargarVariablesIniciales;
begin
  Archivo := GetCurrentDir + '\' + 'server.ini';
  IniFile := TIniFile.Create(Archivo);
  RutaBaseDato := IniFile.ReadString('PARAMETERS', 'PATH', '');
  BaseDato := IniFile.ReadString('PARAMETERS', 'NAME', '');
  UserName := IniFile.ReadString('PARAMETERS', 'USER', '');
  Password := IniFile.ReadString('PARAMETERS', 'PASS', '');
  DriverName := IniFile.ReadString('PARAMETERS', 'DRIVER', '');
  Port := IniFile.ReadString('PARAMETERS', 'PORT', '');

  try

  except
    on E: Exception do
      raise Exception.Create('No existe un archivo de configuración. ' +
        E.Message);
  end;

end;

procedure TMetodos.CerrarConexion;
begin
  sqlFBConexion.Close;
end;

function TMetodos.Conexion: Boolean;
begin
  Result := False;
  try
    if not sqlFBConexion.Connected then
      sqlFBConexion.Open;

    Result := True;
  except
    on E: Exception do
      raise Exception.Create
        ('Ha ocurrido un error durante la conexión en el servidor.');
  end;

end;

procedure TMetodos.ConfirmarConexion;
begin
  try
    sqlFBConexion.Commit;
  except
    on E: Exception do
      raise Exception.Create
        ('Ha ocurrido un error al confirmar la transacción.');
  end;
end;

procedure TMetodos.DataModuleCreate(Sender: TObject);
begin
  CargarVariablesIniciales;
end;

function TMetodos.Datos(pAuthorization, pValue, pParams: String): TJSONArray;
var
  i: Integer;
  FJsonObject: TJSONObject;
begin

  try
    if GetTokenUsuario(pAuthorization) then
    begin
      if Conexion then
      begin

        Result := TJSONArray.Create;

        try
          sqlQuery.Close;
          sqlQuery.SQL.Clear;
          sqlQuery.SQL.Add('Select * from ' + pValue + ' where 1=1 ' + pParams);
          sqlQuery.Open;

          sqlQuery.First;
          while not sqlQuery.Eof do
          begin
            FJsonObject := TJSONObject.Create;

            for i := 0 to sqlQuery.FieldCount - 1 do
            begin
              FJsonObject.AddPair(sqlQuery.Fields[i].FullName,
                sqlQuery.Fields[i].AsString);
            end;

            Result.AddElement(FJsonObject);
            sqlQuery.Next;
          end;

        except
          on E: Exception do
          begin
            Result.Add(E.Message);
          end;
        end;
      end;
    end;

  finally
    CerrarConexion;
  end;

end;

function TMetodos.EchoString(Value: string): string;
begin
  Result := GenerarToken(Value);
end;

procedure TMetodos.EstablecerVariablesConexion;
begin
  try
    sqlFBConexion.DriverName := DriverName;
    sqlFBConexion.Params.Values['Database'] := RutaBaseDato + BaseDato;
    sqlFBConexion.Params.Values['User_Name'] := UserName;
    sqlFBConexion.Params.Values['Password'] := Password;
    sqlFBConexion.Params.Values['Port'] := Port;
  except
    on E: Exception do
      raise Exception.Create
        ('No ha sido posible realizar la conexión con la base de datos ' +
        E.Message);
  end;

end;

function TMetodos.GenerarToken(pValue: String): String;
var
  Key: String;
begin
  try
    Key := DateTimeToStr(date) + pValue;
    Result := THashSHA2.GetHMAC(pValue, Key, SHA256);
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;

end;

function TMetodos.GetTokenUsuario(pAuthorization: String): Boolean;
begin
  Result := False;
  try
    if Conexion then
    begin

      try
        sqlQuery.Close;
        sqlQuery.SQL.Clear;
        sqlQuery.SQL.Add
          ('Select codigousuario from usuario where token=:token');
        sqlQuery.ParamByName('token').AsString := pAuthorization;
        sqlQuery.Open;

        if not sqlQuery.IsEmpty then
        begin
          Result := True;
          Usuario := sqlQuery.FieldByName('codigousuario').AsString;
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
    CerrarConexion;
  end;
end;

function TMetodos.ReverseString(Value: string): string;
begin
  Result := System.StrUtils.ReverseString(Value);
end;

procedure TMetodos.sqlFBConexionBeforeConnect(Sender: TObject);
begin
  EstablecerVariablesConexion;
end;

function TMetodos.UpdateDatos(pAuthorization, pTable: String;
  LJsonObjet: TJSONObject): Boolean;
var
  i: Integer;
  Cadena: String;
  Llave: String;
  Valor: String;
begin
  Result := False;
  Cadena := '';
  try
    try
      if GetTokenUsuario(pAuthorization) then
      begin
        if Conexion then
        begin

          if LJsonObjet.Count > 0 then
          begin
            for i := 0 to LJsonObjet.Count - 1 do
            begin

              if LJsonObjet.Pairs[i].JsonString.Value = 'key' then
                Llave := LJsonObjet.Pairs[i].JsonValue.Value
              else if LJsonObjet.Pairs[i].JsonString.Value = 'value' then
                Valor := LJsonObjet.Pairs[i].JsonValue.Value
              else
              begin
                Cadena := Cadena + LJsonObjet.Pairs[i].JsonString.Value + '=' +
                  LJsonObjet.Pairs[i].JsonValue.Value;
                if i <> LJsonObjet.Count - 1 then
                  Cadena := Cadena + ',';
              end;

            end;

            sqlQuery.Close;
            sqlQuery.SQL.Clear;
            sqlQuery.SQL.Add('UPDATE ' + pTable + ' SET ' + Cadena + ' WHERE  '
              + Llave + '=' + Valor);
            sqlQuery.ExecSQL;
            ConfirmarConexion;

            if sqlQuery.RowsAffected > 0 then
              Result := True;
          end;
        end;
      end;
    except
      on E: Exception do
        CancelarConexion;
    end;

  finally
    CerrarConexion;
  end;

end;

function TMetodos.ValidarToken(pAuthorization: String): Boolean;
var
  i: Integer;
  Id, Token: String;
  LJsonObjet: TJSONObject;
begin
  Result := False;
  try

    LJsonObjet := TJSONObject.ParseJSONValue(pAuthorization) as TJSONObject;

    if LJsonObjet.Count > 0 then
    begin
      for i := 0 to LJsonObjet.Count - 1 do
      begin

        if LJsonObjet.Pairs[i].JsonString.Value = 'id' then
          Id := LJsonObjet.Pairs[i].JsonValue.Value
        else if LJsonObjet.Pairs[i].JsonString.Value = 'token' then
          Token := LJsonObjet.Pairs[i].JsonValue.Value

      end;

      if GetTokenUsuario(pAuthorization) then
      begin
        Result := True;
      end
      else
        raise Exception.Create('No hay autorización para realizar la acción.');

    end
    else
      raise Exception.Create('No hay autorización para realizar la acción.');

  except
    on E: Exception do
      raise Exception.Create('No hay autorización para realizar la acción.');
  end;

end;

end.
