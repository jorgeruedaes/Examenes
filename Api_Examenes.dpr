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
  WebModule in 'WebModule.pas' {WebModule1: TWebModule};

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TfExamenes, fExamenes);
  Application.Run;
end.
