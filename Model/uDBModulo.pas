unit uDBModulo;

interface

uses
  System.SysUtils, System.Classes, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Phys.OracleDef, FireDAC.Phys.PGDef, FireDAC.Phys.MySQLDef,
  FireDAC.Phys.MySQL, FireDAC.Phys.PG, FireDAC.Phys.Oracle, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, IniFiles;

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
  TDBModulo = class(TDataModule)
    sqlFBConexion: TFDConnection;
    sqlQuery: TFDQuery;
    FDPhysOracleDriverLink1: TFDPhysOracleDriverLink;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    FDPhysMySQLDriverLink1: TFDPhysMySQLDriverLink;
    procedure sqlFBConexionBeforeConnect(Sender: TObject);
    procedure DataModuleCreate(Sender: TObject);
  private

    procedure EstablecerVariablesConexion;
    procedure CargarVariablesIniciales;
  public
    function Conexion: Boolean;
    procedure CerrarConexion;
    procedure ConfirmarConexion;
    procedure CancelarConexion;
    { Public declarations }
  end;

var
  DBModulo: TDBModulo;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}
{$R *.dfm}

procedure TDBModulo.CancelarConexion;
begin
  try
    sqlFBConexion.Rollback;
  except
    on E: Exception do
      raise Exception.Create(E.Message);
  end;
end;

procedure TDBModulo.CargarVariablesIniciales;
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

procedure TDBModulo.CerrarConexion;
begin
  sqlFBConexion.Close;
end;

function TDBModulo.Conexion: Boolean;
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

procedure TDBModulo.ConfirmarConexion;
begin
  try
    sqlFBConexion.Commit;
  except
    on E: Exception do
      raise Exception.Create
        ('Ha ocurrido un error al confirmar la transacción.');
  end;
end;

procedure TDBModulo.DataModuleCreate(Sender: TObject);
begin
CargarVariablesIniciales;
end;

procedure TDBModulo.EstablecerVariablesConexion;
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

procedure TDBModulo.sqlFBConexionBeforeConnect(Sender: TObject);
begin
  EstablecerVariablesConexion;
end;

end.
