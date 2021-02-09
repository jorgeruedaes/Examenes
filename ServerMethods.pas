unit ServerMethods;

interface

uses System.SysUtils, System.Classes, System.Json,
  Datasnap.DSServer, Datasnap.DSAuth, System.IOUtils, System.Hash;

type
{$METHODINFO ON}
  TMetodos = class(TDataModule)
  private
    { Var privates }

  public
    { Public example declarations }
    function EchoString(Value: string): string;
    function ReverseString(Value: string): string;

    { }
    function sIniciarSesion(pAuthorization, pUser, pContrasena: String): String;

    { Examples }
    function Datos(pAuthorization, pValue, pParams: String): TJSONArray;
    function UpdateDatos(pAuthorization, pTable: String;
      LJsonObjet: TJSONObject): Boolean;
    function CancelDatos(pAuthorization, pValue: String): Boolean;
    function AcceptDatos(pAuthorization, pTable: String;
      LJsonObjet: TJSONObject): Boolean;

    { Web properties }

  end;
{$METHODINFO OFF}

implementation

{$R *.dfm}

uses System.StrUtils, uAutorizacion, USesion;

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
      if true then
      begin
        if true then
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

            { sqlQuery.Close;
              sqlQuery.SQL.Clear;
              sqlQuery.SQL.Add('INSERT INTO ' + pTable + '(' + CadenaFields + ')'
              + 'values(' + CadenaValues + ')');
              sqlQuery.ExecSQL;
              ConfirmarConexion;

              if sqlQuery.RowsAffected > 0 then
              Result := True; }

          end;
        end;
      end;
    except
      on E: Exception do

    end;

  finally

  end;

end;

function TMetodos.CancelDatos(pAuthorization, pValue: String): Boolean;
begin
  Result := False;
  try
    if true then
    begin
      if true then
      begin

        try

          { sqlQuery.Close;
            sqlQuery.SQL.Clear;
            sqlQuery.SQL.Add(pValue);
            sqlQuery.ExecSQL;
            ConfirmarConexion;

            if sqlQuery.RowsAffected > 0 then
            Result := True; }

        except
          on E: Exception do

        end;
      end;
    end;
  finally

  end;

end;

function TMetodos.Datos(pAuthorization, pValue, pParams: String): TJSONArray;
var
  i: Integer;
  FJsonObject: TJSONObject;
begin

  try
    if true then
    begin
      if true then
      begin

        Result := TJSONArray.Create;

        try
          { sqlQuery.Close;
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
            end; }

        except
          on E: Exception do
          begin
            Result.Add(E.Message);
          end;
        end;
      end;
    end;

  finally

  end;

end;

function TMetodos.EchoString(Value: string): string;
begin
 Result :=  GenerarToken;
end;

function TMetodos.sIniciarSesion(pAuthorization, pUser,
  pContrasena: String): String;
begin
  if IniciarSesion(pAuthorization, pUser, pContrasena) then
  begin
  Result := AsignarContrasena(pUser);
  end;

end;

function TMetodos.ReverseString(Value: string): string;
begin
  Result := EncriptarContrasena(Value);
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
      if true then
      begin
        if true then
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

            { sqlQuery.Close;
              sqlQuery.SQL.Clear;
              sqlQuery.SQL.Add('UPDATE ' + pTable + ' SET ' + Cadena + ' WHERE  '
              + Llave + '=' + Valor);
              sqlQuery.ExecSQL;
              ConfirmarConexion;

              if sqlQuery.RowsAffected > 0 then
              Result := True; }
          end;
        end;
      end;
    except
      on E: Exception do

    end;

  finally

  end;

end;

end.
