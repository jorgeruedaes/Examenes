program Api_Examenes;
{$APPTYPE GUI}

{$R *.dres}

uses
  Vcl.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  usPrincipal in 'usPrincipal.pas' {fExamenes},
  ServerMethods in 'ServerMethods.pas' {Metodos: TDataModule},
  ServerContainer in 'ServerContainer.pas' {ServerContainer1: TDataModule},
  WebModule in 'WebModule.pas' {WebModule1: TWebModule},
  uSesion in 'Controls\uSesion.pas',
  uAutorizacion in 'Controls\uAutorizacion.pas',
  uDBModulo in 'Model\uDBModulo.pas' {DBModulo: TDataModule},
  uMensajes in 'Controls\uMensajes.pas',
  UFuncionesGenerales in 'Controls\UFuncionesGenerales.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfExamenes, fExamenes);
  Application.CreateForm(TDBModulo, DBModulo);
  Application.Run;
end.
