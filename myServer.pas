unit myServer;

// syslog server & client
// port: 54154
//
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.ComCtrls,
  Vcl.Samples.Spin, OverbyteIcsSysLogClient, OverbyteIcsSysLogServer,
  VirtualTrees;

type
  TmyServerForm = class(TForm)
    Panel1: TPanel;
    plServer: TPanel;
    edServerIP: TEdit;
    Splitter1: TSplitter;
    Panel4: TPanel;
    btnSendToServerTest: TButton;
    spReportInterval: TSpinEdit;
    lbReportInterval: TLabel;
    TimerSendMsg: TTimer;
    SysLogServer1: TSysLogServer;
    SysLogClient1: TSysLogClient;
    memoLog: TMemo;
    cbReportToServer: TCheckBox;
    cbRunAsServer: TCheckBox;
    btnServer: TButton;
    VirtualStringTree1: TVirtualStringTree;
    procedure btnSendToServerTestClick(Sender: TObject);
    procedure TimerSendMsgTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Display(Msg: String);
    procedure SysLogServer1DataAvailable(Sender: TObject;
      const SrcIP, SrcPort, RawMessage: AnsiString);
    procedure FormDestroy(Sender: TObject);
    procedure btnServerClick(Sender: TObject);
    procedure cbReportToServerClick(Sender: TObject);
    procedure cbRunAsServerClick(Sender: TObject);
  private
    { Private declarations }
    procedure setServerTag(tag: boolean);
    procedure setReportTag(tag: boolean);
    function serverStartStop(mode: boolean):integer; //1: start/stop fail, 0:ok
  public
    { Public declarations }
  end;

const
  serverSTOP='Stop';
  serverSTART='Start';

var
  myServerForm: TmyServerForm;
  serverRunning: boolean;

implementation

{$R *.dfm}

procedure TmyServerForm.btnSendToServerTestClick(Sender: TObject);
begin
  // TODO: test send to server
  if (edServerIP.Text <> '') then
  begin
    SysLogClient1.Server := edServerIP.Text;
    // SysLogClient1.HostName:='12345';
    SysLogClient1.Text := 'This is test message';
    SysLogClient1.Send;
    SysLogClient1.Close;
    memoLog.Lines.Add(SysLogClient1.RawMessage);
  end;
end;

procedure TmyServerForm.btnServerClick(Sender: TObject);
begin
    serverStartStop(not serverRunning);
end;

procedure TmyServerForm.cbReportToServerClick(Sender: TObject);
begin
  setReportTag(cbReportToServer.Checked);
end;

procedure TmyServerForm.cbRunAsServerClick(Sender: TObject);
begin
  setServerTag(cbRunAsServer.Checked);
end;

procedure TmyServerForm.setReportTag(tag: boolean);
begin
  edServerIP.Enabled := tag;
  btnSendToServerTest.Enabled := tag;
  lbReportInterval.Enabled:=tag;
  spReportInterval.Enabled := tag;

end;

procedure TmyServerForm.setServerTag(tag: boolean);
begin
  btnServer.Enabled := tag;
  plServer.Enabled := tag;
end;

function TmyServerForm.serverStartStop(mode: boolean):integer;
var
  s:string;
begin
  try
    if mode then
    begin
      SysLogServer1.Listen;
    end
    else
    begin
      SysLogServer1.Close;
    end;
  except
    result:=1;
  end;

  serverRunning:= mode;
  cbRunAsServer.Enabled:=not serverRunning;
  if mode then
  begin
    btnServer.Caption := serverSTOP;
    s:= 'Server: '+ serverSTART;
  end
  else
  begin
    btnServer.Caption := serverSTART;
    s:= 'Server: '+ serverSTOP;
  end;
  Display(s);
  result:= 0;
end;

procedure TmyServerForm.Display(Msg: String);
begin
  memoLog.Lines.BeginUpdate;
  try
    //TODO: show receive message in memo
    memoLog.Lines.Add(Msg);
  finally
    memoLog.Lines.EndUpdate;
    SendMessage(memoLog.Handle, EM_SCROLLCARET, 0, 0);
  end;
end;

procedure TmyServerForm.SysLogServer1DataAvailable(Sender: TObject;
  const SrcIP, SrcPort, RawMessage: AnsiString);
var
  Decoded: TSysLogData;
begin
  try
    SysLogServer1.ParseRawMessage(RawMessage, Decoded);
  except
    on E: Exception do
    begin
      Display(E.Message);
      exit;
    end;
  end;
  // TODO: classfly receive message
  Display('Received from ' + String(SrcIP) + ':' + String(SrcPort));
  Display('   RawMessage       = ' + String(RawMessage));
  Display('   PRI              = ' + IntToStr(Decoded.Pri));
  Display('   TimeStamp        = ' + Decoded.TimeString);
  Display('   DateTime         = ' +
    Format('%04.4d-%02.2d-%02.2d %02.2d:%02.2d:%02.2d.%03.3d',
    [Decoded.Year, Decoded.Month, Decoded.Day, Decoded.Hour, Decoded.Minute,
    Decoded.Second, Decoded.MilliSec]));
  Display('   Facility         = ' + IntToStr(Ord(Decoded.Facility)));
  Display('   Severity         = ' + IntToStr(Ord(Decoded.Severity)));
  Display('   HostName         = ' + Decoded.Hostname);
  Display('   Process          = ' + Decoded.Process);
  Display('   PID              = ' + IntToStr(Decoded.PID));
  Display('   Text             = ' + String(Decoded.Text));
  Display('   RFC5424          = ' + IntToStr(Ord(Decoded.RFC5424)));
  if Decoded.RFC5424 then
  begin
    Display('   MsgVer           = ' + IntToStr(Decoded.MsgVer));
    Display('   MsgID            = ' + String(Decoded.MsgID));
    Display('   StructData       = ' + String(Decoded.StructData));
  end;
end;

procedure TmyServerForm.TimerSendMsgTimer(Sender: TObject);
begin
  // send message to server
end;

procedure TmyServerForm.FormCreate(Sender: TObject);
begin
  setReportTag(cbReportToServer.Checked);
  TimerSendMsg.Interval := spReportInterval.Value * 1000;
  if cbReportToServer.Checked then
  begin
    TimerSendMsg.Enabled := true;
  end;

  setServerTag(cbRunAsServer.Checked);
end;

procedure TmyServerForm.FormDestroy(Sender: TObject);
begin
  TimerSendMsg.Enabled := false;
  setServerTag(false);
  // SysLogServer1.Close;
end;

end.
