program myPing;

uses
  Vcl.Forms,
  myPingMainForm in 'myPingMainForm.pas' {frmMyPing},
  pingLostDetail in 'pingLostDetail.pas' {pingLostDetailForm},
  uCiaXml in 'uCiaXml.pas',
  myServer in 'myServer.pas' {myServerForm},
  DelphiVault.Indy10.PingClient in 'lib\DelphiVault.Indy10.PingClient.pas';

{$R *.res}

begin
//  ReportMemoryLeaksOnShutdown := DebugHook <> 0;
  // 要先提升至系統權限才能查看其它進程的信息?
{ //following can be replace by .manifest setting.
  if not AdjustProcessPrivilege(GetCurrentProcess, 'SeDebugPrivilege') then
  begin
    MessageDlg('Please run this tool as Administrator', mtError, [mbOK], 0);
    //writeln('AdjustProcessPrivilege fail');
    exit;
  end;
  }
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrmMyPing, frmMyPing);
  Application.Run;

end.
