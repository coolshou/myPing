// simple continious ping tool

unit myPingMainForm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, System.UITypes,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls,
  Vcl.Samples.Spin, Vcl.ExtDlgs,
  Vcl.Menus, Vcl.StdActns, System.Actions, Vcl.ActnList, uCiaXml,
  OverbyteIcsPing, Vcl.ComCtrls, Vcl.TabNotBk, VCLTee.TeEngine, VCLTee.TeeProcs,
  VCLTee.Chart, VCLTee.Series, VCLTee.BubbleCh, OverbyteIcsWndControl,
  myServer, VCLTee.TeeGDIPlus, IdBaseComponent, IdComponent, IdRawBase,
  IdRawClient, IdIcmpClient, IdAntiFreezeBase, Vcl.IdAntiFreeze, System.TypInfo,
  JvComponentBase, VirtualTrees;

type
  // Declare a ping result record
  TPingResult = class(TObject)
    sHostIP: string;
    iPingOK: integer;
    iPingNG: integer;
    bPreviousNG: boolean;
    iPreviousNG: integer;
    iPingLostCriteria: integer;
    // % config how many serial NG will count as Ping lost
    iPingLostSerialNum: integer;
    // how many serial ping lose will take a ping lost record
    iPingLostTimes: integer;
    iPingLostTimesList: TStringlist;
  public
    constructor create();
    destructor Destroy(); override;
  end;

type
  TfrmMyPing = class(TForm)
    butPING: TButton;
    Memo1: TMemo;
    Panel1: TPanel;
    Panel2: TPanel;
    edtHost: TLabeledEdit;
    spInterval: TSpinEdit;
    lbInterval: TLabel;
    lbTimeoutTime: TLabel;
    spTimeoutTime: TSpinEdit;
    gbConfig: TGroupBox;
    lbPacketSize: TLabel;
    spPacketSize: TSpinEdit;
    edPingOK: TLabeledEdit;
    edPingNG: TLabeledEdit;
    edPingLostRate: TLabeledEdit;
    btnClear: TButton;
    spCriteria: TSpinEdit;
    lbCriteria: TLabel;
    lbPingLostSerialNum: TLabel;
    spPingLostSerialNum: TSpinEdit;
    Panel5: TPanel;
    edPingLostCount: TLabeledEdit;
    btPingLostCountDetail: TButton;
    edLogfileName: TEdit;
    btnLogFileSelect: TButton;
    OpenTextFileDialog1: TOpenTextFileDialog;
    cbEnableSubffix: TCheckBox;
    edSubffixString: TEdit;
    MainMenu: TMainMenu;
    miFile: TMenuItem;
    miLoad: TMenuItem;
    miSave: TMenuItem;
    ActionList: TActionList;
    ConfigLoad: TFileOpen;
    ConfigSave: TFileSaveAs;
    Server: TAction;
    miOption: TMenuItem;
    miServer: TMenuItem;
    TabbedNotebook1: TTabbedNotebook;
    plReport: TPanel;
    gbEnableLog: TGroupBox;
    cbEnableLogFile: TCheckBox;
    Chart1: TChart;
    cbEnableChart: TCheckBox;
    plChart: TPanel;
    Series1: TBarSeries;
    Series2: TBubbleSeries;
    edMMax: TLabeledEdit;
    edMMin: TLabeledEdit;
    edMAve: TLabeledEdit;
    Ping1: TPing;
    Timer1: TTimer;
    IdIcmpClient1: TIdIcmpClient;
    IdAntiFreeze1: TIdAntiFreeze;
    plStatistics: TPanel;
    cmdStart: TAction;
    cmdStop: TAction;
    cmdClear: TAction;
    miCommand: TMenuItem;
    Start1: TMenuItem;
    Stop1: TMenuItem;
    N2: TMenuItem;
    Clear1: TMenuItem;
    plHosts: TPanel;
    Panel6: TPanel;
    vstHosts: TVirtualStringTree;
    btnAdd: TButton;
    VirtualStringTree1: TVirtualStringTree;
    cmdAddHost: TAction;
    PopMenuTargetIP: TPopupMenu;
    Remove1: TMenuItem;
    cmdRemoveHost: TAction;
    Action2: TAction;
    VirtualStringTree2: TVirtualStringTree;
    procedure FormCreate(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure edPingLostRateChange(Sender: TObject);
    procedure btPingLostCountDetailClick(Sender: TObject);
    procedure cbEnableSubffixClick(Sender: TObject);
    procedure ConfigSaveAccept(Sender: TObject);
    procedure ConfigLoadAccept(Sender: TObject);
    procedure ServerExecute(Sender: TObject);
    procedure Series1AfterAdd(Sender: TChartSeries; ValueIndex: integer);
    procedure cbEnableLogFileClick(Sender: TObject);
    procedure Ping1EchoReply(Sender, Icmp: TObject; Status: integer);
    procedure Ping1DnsLookupDone(Sender: TObject; Error: Word);
    procedure Ping1EchoRequest(Sender, Icmp: TObject);
    procedure cbEnableChartClick(Sender: TObject);
    procedure IdIcmpClient1Reply(ASender: TComponent;
      const AReplyStatus: TReplyStatus);
    procedure cmdStartExecute(Sender: TObject);
    procedure cmdStopExecute(Sender: TObject);
    procedure cmdClearExecute(Sender: TObject);
    procedure cmdAddHostExecute(Sender: TObject);
    procedure vstHostsFreeNode(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure vstHostsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure FormShow(Sender: TObject);
    procedure cmdRemoveHostExecute(Sender: TObject);
  private
//    RootNote: PVirtualNode;
    procedure WriteToLog(msg: string);
    procedure CreateLogfile;
    procedure PingThreadTermPing(Sender: TObject);
  public
    procedure updateResult();
    function getIndyReplyMsg(reply: TReplyStatusTypes): string;
    function findHost(Host: string): boolean;
    function getHosts(): string;
    procedure setHosts(s:string);
    procedure addHost(Host: string);
  end;

  // function GetEnumValue(TypeInfo: PTypeInfo; const Name: string): integer;

var
  frmMyPing: TfrmMyPing;
  pingResult: TPingResult;
  iPingLostRate: Extended = 0.0;
  Logfilename: string;
  LogFile: TextFile;
  // Timer seems not very actulate, run faster after each time
  // msTimer: TConsoleTimer;
  configFile: TXMLConfig;
  LoopCount: integer = 0;
  stopPing: boolean = true;
  //
  MMax, MMin, MAve, MSecsAve: Cardinal;
  myServer: TmyServerForm;

  // debug
  // prvTime: TDatetime;
const
  pingResponseNG = 'seq %d: %s: %s [%d]';
  pingResponseOK = 'seq %d: Reply from %s: bytes=%d TTL=%d [%d]';

type
  PMyHostRec = ^TMyHostRec;

  TMyHostRec = record
    TargetIP: String;
  end;

implementation

{$R *.dfm}

uses pingLostDetail;

procedure Split(Delimiter: Char; Str: string; ListOfStrings: TStrings) ;
begin
   ListOfStrings.Clear;
   ListOfStrings.Delimiter     := Delimiter;
   ListOfStrings.DelimitedText := Str;
end;

// ===TPingResult
constructor TPingResult.create();
begin
  sHostIP := '127.0.0.1';
  iPingLostCriteria := 1;
  iPingLostSerialNum := 10;
  iPingLostTimesList := TStringlist.create(false);
end;

destructor TPingResult.Destroy();
begin
  iPingLostTimesList.Free;
  // Call the parent class destructor
  inherited;
end;

// ===TfrmMyPing
procedure TfrmMyPing.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  // save config
  ConfigSaveAccept(self);

  // msTimer.Enabled := false;
  // msTimer.Destroy;
  pingResult.Destroy;
  configFile.Free;
  myServer.Destroy;
end;

procedure TfrmMyPing.FormCreate(Sender: TObject);
begin
  myServer := TmyServerForm.create(self);
  // ReportMemoryLeaksOnShutdown := True;
  configFile := TXMLConfig.create;

  pingResult := TPingResult.create;
  vstHosts.NodeDataSize := SizeOf(TMyHostRec);
  vstHosts.RootNodeCount := 0;
//  RootNote := vstHosts.AddChild(nil);
//  vstHosts.Expanded[RootNote] := true;
  // msTimer := TConsoleTimer.create;
  // msTimer.Enabled := false;
  // load config
  ConfigLoadAccept(self);
  updateResult;
  TabbedNotebook1.PageIndex := 0;
  if cbEnableChart.Checked then
  begin
    // plChart.Visible := false;
    Chart1.Visible := false;
  end;

  Series1.Clear;
  Series2.Clear;
end;

procedure TfrmMyPing.FormShow(Sender: TObject);
begin
  if assigned(myServer) then
  begin
    if myServer.Visible then
      myServer.Show
  end;
end;

// TODO: while  IdIcmpClient is ping UI will hang for a while
// TODO: each host have it's result
procedure TfrmMyPing.IdIcmpClient1Reply(ASender: TComponent;
  const AReplyStatus: TReplyStatus);
var
  curTime: TDatetime;
  sMsg: string;
  curPingID: string;
  MSecs: Cardinal;
  MColor: Tcolor;

begin
  curTime := now;
  curPingID := intTostr(LoopCount);
  sMsg := formatdatetime('YYYYMMDD_hh:mm:ss.zzz # ', curTime);
  if (AReplyStatus.ReplyStatusType = rsEcho) then
  begin
    // success
    sMsg := sMsg + Format(pingResponseOK,
      [LoopCount, IdIcmpClient1.ReplyStatus.FromIpAddress,
      IdIcmpClient1.ReplyStatus.BytesReceived,
      IdIcmpClient1.ReplyStatus.TimeToLive,
      Ord(IdIcmpClient1.ReplyStatus.ReplyStatusType)]);
    // count OK
    pingResult.iPingOK := pingResult.iPingOK + 1;
    pingResult.bPreviousNG := false;
    MSecs := Ping1.ReplyRTT;
    if cbEnableChart.Checked then
    begin
      // chart  Series1
      MColor := clGreen;
      Series1.Add(MSecs, curPingID, MColor);
    end;
  end
  else
  begin
    // fail
    sMsg := sMsg + Format(pingResponseNG,
      [LoopCount, getIndyReplyMsg(IdIcmpClient1.ReplyStatus.ReplyStatusType),
      Ord(IdIcmpClient1.ReplyStatus.ReplyStatusType)]);
    // GetEnumName(TypeInfo(TReplyStatusTypes),
    // Ord(IdIcmpClient1.ReplyStatus.ReplyStatusType))]);
    // count NG
    pingResult.iPingNG := pingResult.iPingNG + 1;
    if pingResult.bPreviousNG then
    begin
      pingResult.iPreviousNG := pingResult.iPreviousNG + 1;
      if pingResult.iPreviousNG >= pingResult.iPingLostSerialNum then
      begin
        pingResult.iPingLostTimes := pingResult.iPingLostTimes + 1;
        pingResult.iPingLostTimesList.Add(formatdatetime('YYYYMMDD_hh:mm:ss # ',
          curTime) + ' Ping lost over ' +
          intTostr(pingResult.iPingLostSerialNum) + ' packets');
        pingResult.iPreviousNG := 0;
      end;
    end;
    pingResult.bPreviousNG := true;
    MSecs := 0;
    if cbEnableChart.Checked then
    begin
      // chart  Series2
      MColor := clRed;
      Series2.Add(MSecs, curPingID, MColor);
    end;
  end;
  WriteToLog(sMsg);

  if MSecs > MMax then
    MMax := MSecs;
  if MSecs < MMin then
    MMin := MSecs;
  MAve := MAve + MSecs;
  if LoopCount > 0 then
  begin
    MSecsAve := Round(MAve / LoopCount);
  end;
  updateResult;
  // arrange next ping
  if not stopPing then
  begin
    Timer1.Enabled := true;
    // msTimer.Enabled := true;
  end;

end;

procedure TfrmMyPing.Series1AfterAdd(Sender: TChartSeries; ValueIndex: integer);
begin
  // TODO: this will keep update minimum and maximum after data add.
  // any better way or only when the maximum is not enough to show?
  With Sender.GetHorizAxis do
  begin
    Automatic := false;
    if LoopCount > 3600 then
    begin
      Maximum := LoopCount;
      Minimum := Maximum - 3600;
    end
    else
    begin
      Minimum := 0;
      Maximum := 3600;
    end;
  end;
end;

procedure TfrmMyPing.ServerExecute(Sender: TObject);
begin
    myServer.Show;
end;

procedure TfrmMyPing.updateResult();
var
  iTotal: integer;
begin
  edPingOK.Text := intTostr(pingResult.iPingOK);
  edPingNG.Text := intTostr(pingResult.iPingNG);
  iTotal := pingResult.iPingOK + pingResult.iPingNG;
  if iTotal > 0 then
  begin
    iPingLostRate := (pingResult.iPingNG / iTotal) * 100;
  end;
  edPingLostRate.Text := FloatToStrF(iPingLostRate, ffNumber, 4, 2);
  edPingLostCount.Text := intTostr(pingResult.iPingLostTimes);
  edMMax.Text := intTostr(MMax);
  edMMin.Text := intTostr(MMin);
  edMAve.Text := intTostr(MSecsAve);

end;

procedure TfrmMyPing.vstHostsFreeNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode);
var
  Data: PMyHostRec;
begin
  Data := Sender.GetNodeData(Node);
  // Explicitely free the string, the VCL cannot know that there is one but needs to free
  // it nonetheless. For more fields in such a record which must be freed use Finalize(Data^) instead touching
  // every member individually.
  Finalize(Data^);
end;

procedure TfrmMyPing.vstHostsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
var
  Data: PMyHostRec;
begin
  // A handler for the OnGetText event is always needed as it provides the tree with the string data to display.
  // Note that we are always using WideString.
  Data := Sender.GetNodeData(Node);
  case Column of
    0:
      begin
        if assigned(Data) then
          CellText := Data.TargetIP;
      end;
  end;
end;

function TfrmMyPing.getIndyReplyMsg(reply: TReplyStatusTypes): string;
var
  ErrorText: string;
begin
  case reply of
    rsEcho:
      ErrorText := 'An Echo was received.';
    rsError:
      ErrorText := 'An error has occurred.';
    rsTimeOut:
      ErrorText := 'Timeout occurred before a response was received.';
    rsErrorUnreachable:
      ErrorText := 'The address for the ICMP message is not available.';
    rsErrorTTLExceeded:
      ErrorText := 'Time-To-Live exceeded for an ICMP response.';
    rsErrorPacketTooBig:
      ErrorText := 'Packet Too Big';
    rsErrorParameter:
      ErrorText := 'Error Parameter';
    rsErrorDatagramConversion:
      ErrorText := 'Error Datagram Conversion';
    rsErrorSecurityFailure:
      ErrorText := 'Error Security Failure';
    rsSourceQuench:
      ErrorText := 'Source Quench';
    rsRedirect:
      ErrorText := 'Redirect';
    rsTimeStamp:
      ErrorText := 'TimeStamp';
    rsInfoRequest:
      ErrorText := 'InfoRequest';
    rsAddressMaskRequest:
      ErrorText := 'AddressMaskRequest';
    rsTraceRoute:
      ErrorText := 'TraceRoute';
    rsMobileHostReg:
      ErrorText := 'MobileHostReg';
    rsMobileHostRedir:
      ErrorText := 'MobileHostRedir';
    rsIPv6WhereAreYou:
      ErrorText := 'IPv6 Where Are You';
    rsIPv6IAmHere:
      ErrorText := 'IPv6 I Am Here';
    rsSKIP:
      ErrorText := 'Skip';
  else
    ErrorText := 'Unknown Error';
  end;
  result := ErrorText;
end;

procedure TfrmMyPing.btPingLostCountDetailClick(Sender: TObject);
var
  pingLostDetailForm: TpingLostDetailForm;
begin
  try
    pingLostDetailForm := TpingLostDetailForm.create(self);
    pingLostDetailForm.Memo1.Lines := pingResult.iPingLostTimesList;
    pingLostDetailForm.ShowModal;

  finally
    FreeAndNil(pingLostDetailForm);
  end;
end;

procedure TfrmMyPing.ConfigLoadAccept(Sender: TObject);
begin
  // ping
  edtHost.Text := configFile.ReadString('PING', 'host', '192.168.0.1');
  setHosts(configFile.ReadString('PING', 'hosts', '192.168.0.1'));
  spInterval.Value := configFile.ReadInteger('PING', 'Interval', 1);
  spTimeoutTime.Value := configFile.ReadInteger('PING', 'TimeoutTime', 2000);
  spPacketSize.Value := configFile.ReadInteger('PING', 'PacketSize', 1024);
  spCriteria.Value := configFile.ReadInteger('PING', 'PingCriteria', 1);
  spPingLostSerialNum.Value := configFile.ReadInteger('PING',
    'PingLostSerialNum', 10);
  // log
  cbEnableLogFile.Checked := configFile.ReadBoolean('LOG', 'enableLog', true);
  edLogfileName.Text := configFile.ReadString('LOG', 'LogfileName', 'test.log');
  cbEnableSubffix.Checked := configFile.ReadBoolean('LOG',
    'enableSubffix', false);
  edSubffixString.Text := configFile.ReadString('LOG', 'SubffixString',
    'YYYY-MM-DD_hhmmss');
  // chart
  cbEnableChart.Checked := configFile.ReadBoolean('Chart',
    'EnableChart', false);
  // report
  myServer.cbRunAsServer.Checked := configFile.ReadBoolean('REPORT',
    'RunAsServer', false);
  myServer.cbReportToServer.Checked := configFile.ReadBoolean('REPORT',
    'ReportToServer', false);
  myServer.edServerIP.Text := configFile.ReadString('REPORT', 'ServerIP',
    '192.168.0.1');
  myServer.spReportInterval.Value := configFile.ReadInteger('REPORT',
    'ReportInterval', 300);

end;

procedure TfrmMyPing.ConfigSaveAccept(Sender: TObject);
begin
  // ping
  configFile.WriteString('PING', 'host', edtHost.Text);
  configFile.WriteString('PING', 'hosts', getHosts);
  configFile.WriteInteger('PING', 'Interval', spInterval.Value);
  configFile.WriteInteger('PING', 'TimeoutTime', spTimeoutTime.Value);
  configFile.WriteInteger('PING', 'PacketSize', spPacketSize.Value);
  configFile.WriteInteger('PING', 'PingCriteria', spCriteria.Value);
  configFile.WriteInteger('PING', 'PingLostSerialNum',
    spPingLostSerialNum.Value);
  // log
  configFile.WriteBoolean('LOG', 'enableLog', cbEnableLogFile.Checked);
  configFile.WriteString('LOG', 'LogfileName', edLogfileName.Text);
  configFile.WriteBoolean('LOG', 'enableSubffix', cbEnableSubffix.Checked);
  configFile.WriteString('LOG', 'SubffixString', edSubffixString.Text);
  // chart
  configFile.WriteBoolean('Chart', 'EnableChart', cbEnableChart.Checked);
  // report
  configFile.WriteBoolean('REPORT', 'RunAsServer',
    myServer.cbRunAsServer.Checked);
  configFile.WriteBoolean('REPORT', 'ReportToServer',
    myServer.cbReportToServer.Checked);
  configFile.WriteString('REPORT', 'ServerIP', myServer.edServerIP.Text);
  configFile.WriteInteger('REPORT', 'ReportInterval',
    myServer.spReportInterval.Value);

  configFile.Save;
end;

procedure TfrmMyPing.CreateLogfile;
var
  fstr: string;
begin
  try
    Logfilename := edLogfileName.Text;
    if (cbEnableSubffix.Checked) then
    begin
      fstr := formatdatetime(edSubffixString.Text, now());
      Logfilename := ChangeFileExt(Logfilename, fstr + '.log');
      // TODO: check invalue character.

    end;
    AssignFile(LogFile, Logfilename);
    // Rewrites the file LogFile
    Rewrite(LogFile);
    // Open file for appending
    Append(LogFile);
    // Write text to Textfile LogFile
    // finally close the file
    CloseFile(LogFile);
  finally
    // freeandnil(fstr);
  end;
end;

procedure TfrmMyPing.WriteToLog(msg: string);
begin
  Memo1.Lines.Add(msg);
  if (not FileExists(Logfilename)) then
  begin
    // if file is not available then create a new file
    CreateLogfile;
  end;
  // Assigns Filename to variable LogFile
  AssignFile(LogFile, Logfilename);
  // start appending text
  Append(LogFile);
  // Write a new line with current date and message to the file
  WriteLn(LogFile, msg);
  // Close file
  CloseFile(LogFile)
end;

//TODO: each Host have it's own timer?
//or one timer send ping at the same time for each Host
procedure TfrmMyPing.Timer1Timer(Sender: TObject);
var
  target:string;
  Node: PVirtualNode;
  Data: PMyHostRec;

begin
  // sync ping: => TODO: ping timeout will cause UI stop response??
  // ping setup

  { first do async DNS lookup, sync ping from event handler }
  // DisplayMemo.Lines.Add('Resolving host ''' + HostNames.Items
  // [HostNames.ItemIndex] + '''');
  // Ping1.SocketFamily := TSocketFamily(SockFamily.ItemIndex);
  Timer1.Enabled := false;
  // msTimer.Enabled := false;
  // ICS
  // Ping1.DnsLookup(edtHost.Text);
  // indy icmp
  {
    IdIcmpClient1.Host := edtHost.Text;
    IdIcmpClient1.ReceiveTimeout := spTimeoutTime.Value;
    IdIcmpClient1.PacketSize := spPacketSize.Value;
    IdIcmpClient1.Ping();
  }
  //multi target to ping
  Node:=vstHosts.GetFirstChild(nil);
  while Assigned(Node) do
  begin
     Data := vstHosts.GetNodeData(Node);
      // indy thread ping
      with TPingThread.create(true) do // create suspended
      begin
        // PingAddThread (ThreadId) ;      // keep threadid so it's freed
        FreeOnTerminate := true;
        // PingId := succ(i); // keep track of the results
        PingId := LoopCount;
        OnTerminate := PingThreadTermPing; // where we get the response
        PingSrcAddress := '';
        // optionally specifiy source address for interface to ping from, or leave blank
        // if SrcIpV4.ItemIndex > 0 then
        // PingSrcAddress := SrcIpV4.Items[SrcIpV4.ItemIndex];
        PingSrcAddress6 := '';
        // if SrcIpV6.ItemIndex > 0 then
        // PingSrcAddress6 := SrcIpV6.Items[SrcIpV6.ItemIndex];
        // PingSocketFamily := TSocketFamily(SockFamily.ItemIndex);
        PingHostName := Data.TargetIP;       // host name or IP address to ping
        PingTimeout := spTimeoutTime.Value; // ms
        // TODO: why must  PacketSize <= 996 ??
        PingSize := spPacketSize.Value;
        PingTTL := 32; // hops
        PingLookupReply := false; // don't need response host name lookup
    {$IF CompilerVersion < 21}
        Resume; // start it now
    {$ELSE}
        Start;
    {$ENDIF}
      end;
     Node:=vstHosts.GetNext(Node);
  end;

  inc(LoopCount);
end;

procedure TfrmMyPing.cbEnableChartClick(Sender: TObject);
begin
  if cbEnableChart.Checked then
  begin
    Chart1.Visible := true;
  end
  else
  begin
    Chart1.Visible := false;
  end;

end;

procedure TfrmMyPing.cbEnableLogFileClick(Sender: TObject);
begin
  if cbEnableLogFile.Checked then
  begin
    edLogfileName.Enabled := true;
    btnLogFileSelect.Enabled := true;
    edSubffixString.ReadOnly := false;
    edSubffixString.Color := clWindow;
  end
  else
  begin
    edLogfileName.Enabled := false;
    btnLogFileSelect.Enabled := false;
    edSubffixString.ReadOnly := true;
    edSubffixString.Color := clBtnFace;
  end;
end;

procedure TfrmMyPing.cbEnableSubffixClick(Sender: TObject);
begin
  if cbEnableSubffix.Checked then
  begin
    edSubffixString.ReadOnly := false;
    edSubffixString.Color := clWindow;
  end
  else
  begin
    edSubffixString.ReadOnly := true;
    edSubffixString.Color := clBtnFace;
  end;

end;

function TfrmMyPing.findHost(Host: string): boolean;
var
//  iChildNode: integer;
//  I: integer;
  Node: PVirtualNode;
  Data: PMyHostRec;
begin
  result := false;
  Node:=vstHosts.GetFirstChild(nil);
  while Assigned(Node) do
  begin
     Data := vstHosts.GetNodeData(Node);
     if (Data.TargetIP = Host) then
     begin
        result := true;
        break;
     end;
     Node:=vstHosts.GetNext(Node);
  end;
end;

function TfrmMyPing.getHosts(): string;
var
  Node: PVirtualNode;
  Data: PMyHostRec;
  rs:string;
begin
  rs:='';
  Node:=vstHosts.GetFirstChild(nil);
  while Assigned(Node) do
  begin
     Data := vstHosts.GetNodeData(Node);
     rs := rs + ' '+ Data.TargetIP;
     Node:=vstHosts.GetNext(Node);
  end;
  result:=rs;
end;
//set virtualtree Hosts
procedure TfrmMyPing.setHosts(s:string);
var
   OutPutList: TStringList;
   I:integer;
begin
  //TODO:
   OutPutList := TStringList.Create;
   try
     Split(' ', s, OutPutList) ;
     for I := 0 to OutPutList.Count - 1 do
     begin
      addHost(OutPutList.Strings[I]);
     end;
   finally
     OutPutList.Free;
   end;
end;

procedure TfrmMyPing.addHost(Host: string);
var
  Data: PMyHostRec;
  Node: PVirtualNode;
begin
  // check node exists
  if not findHost(Host) then
  begin
    // add host
    Node := vstHosts.AddChild(nil);
    Data := vstHosts.GetNodeData(Node);
    Data.TargetIP := Host;
  end;
end;

procedure TfrmMyPing.cmdAddHostExecute(Sender: TObject);
begin
  addHost(edtHost.Text);
end;

procedure TfrmMyPing.cmdClearExecute(Sender: TObject);
begin
  pingResult.iPingOK := 0;
  pingResult.iPingNG := 0;
  iPingLostRate := 0.0;

  updateResult;
end;

procedure TfrmMyPing.cmdRemoveHostExecute(Sender: TObject);
begin
  //TODO: RemoveHost
  if (vstHosts.SelectedCount > 0)then
  begin
//     vstHosts.SelectedNodes();
     vstHosts.DeleteSelectedNodes;
  end;
end;

procedure TfrmMyPing.cmdStartExecute(Sender: TObject);
begin
  if cbEnableLogFile.Checked then
  begin
    if (edLogfileName.Text = '') then
    begin
      MessageDlg('You must select log file name!', mtWarning, [mbOK], 0);
      edLogfileName.SetFocus;
      exit;
    end;
    CreateLogfile;
  end;

  MMax := 0;
  MMin := 99999;
  MAve := 0;

  // Timer1
  Timer1.Interval := spInterval.Value;
//  Timer1.OnTimer := Timer1Timer;
  // Example1: Ping with a given CallBack procedure.
  // msTimer.Interval := spInterval.Value; // * 1000;
  // msTimer.OnTimerEvent := Timer1Timer;

  // butPING.Caption := cmdStop.Caption;// .'Stop';
  // butPING.OnClick := cmdStopExecute;
  cmdStart.Enabled := false;
  cmdStop.Enabled := true;
  butPING.Action := cmdStop;
  // config
  pingResult.iPingLostCriteria := spCriteria.Value;
  pingResult.iPingLostSerialNum := spPingLostSerialNum.Value;
  // TPingClient.Ping(edtHost.Text, MyPingCallback);
  // TMyPingThread.create(edtHost.Text,spTimeoutTime.value,spPacketSize.value);
  Application.Title := 'Ping... ';
  gbConfig.Enabled := false;

  { *
    if msTimer.IsHighResolution then
    begin
    Memo1.Lines.Add('msTimer IsHighResolution');
    end;
    * }
  Series1.Clear;
  Series2.Clear;
  //
  Timer1.Enabled := true;
  // msTimer.Enabled := true;
  stopPing := false;
end;

procedure TfrmMyPing.cmdStopExecute(Sender: TObject);
begin
  stopPing := true;
  Timer1.Enabled := false;
  // msTimer.Enabled := false;
  // butPING.Caption := 'Start';
  // butPING.OnClick := cmdStartExecute;
  cmdStart.Enabled := true;
  cmdStop.Enabled := false;
  butPING.Action := cmdStart;
  Application.Title := 'Ping';
  gbConfig.Enabled := true;

end;

procedure TfrmMyPing.edPingLostRateChange(Sender: TObject);
begin
  if (strTofloat(edPingLostRate.Text) > pingResult.iPingLostCriteria) then
  begin
    edPingLostRate.Font.Color := clRed;
  end
  else
  begin
    edPingLostRate.Font.Color := clGreen;
  end;
end;

{ * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * }
procedure TfrmMyPing.Ping1DnsLookupDone(Sender: TObject; Error: Word);
var
  // retvalue: integer;
  sMsg: string;
begin
  if Error <> 0 then
  begin
    sMsg := Format('DNS lookup error - %s', [SysErrorMessage(Error)]);
    WriteToLog(sMsg);
    // SetButtons(True);
    exit;
  end;

  // DisplayMemo.Lines.Add('Host ''' + HostNames.Items[HostNames.ItemIndex] +
  // ''' is ' + Ping1.DnsResult);
  // sMsg := Format('Host ''%s'' is %s', [edtHost.Text, Ping1.DnsResult]);
  // WriteToLog(sMsg);
  Ping1.Address := Ping1.DnsResult;
  // packet size
  Ping1.Ping;
  // retvalue := Ping1.Ping;
  {
    if retvalue = 0 then
    begin
    // DisplayMemo.Lines.Add('Ping failed: ' + Ping1.LastErrStr)
    WriteToLog('Ping failed: ' + Ping1.LastErrStr);
    end
    else
    begin
    // DisplayMemo.Lines.Add('Total ping responses: ' + intTostr(retvalue));
    WriteToLog('Total ping responses: ' + intTostr(retvalue));
    end;
  }
  if not stopPing then
  begin
    Timer1.Enabled := true;
    // msTimer.Enabled := true;
  end;
  // DisplayMemo.Lines.Add('');
  // SetButtons(True);
end;

// ics echo reply
procedure TfrmMyPing.Ping1EchoReply(Sender, Icmp: TObject; Status: integer);
var
  curTime: TDatetime;
  sMsg: string;
  MSecs: Cardinal;
  MColor: Tcolor;
  curPingID: string;
begin
  curTime := now;
  curPingID := intTostr(LoopCount);
  sMsg := formatdatetime('YYYYMMDD_hh:mm:ss.zzz # ', curTime);
  // TODO: why return ok but ReplySize=0??
  // if ((Status <> 0) and (Ping1.ReplySize <> 0)) then
  if (Status <> 0) then
  begin
    // success
    sMsg := sMsg + Format(pingResponseOK, [LoopCount, Ping1.ReplyIP,
      Ping1.ReplySize, Ping1.ReplyRTT, Ping1.ReplyStatus]);
    // TODO: should we consider ReplySize=0 is ping fail?
    // count OK
    pingResult.iPingOK := pingResult.iPingOK + 1;
    pingResult.bPreviousNG := false;
    MSecs := Ping1.ReplyRTT;
    if cbEnableChart.Checked then
    begin
      // chart  Series1
      MColor := clGreen;
      Series1.Add(MSecs, curPingID, MColor);
    end;
  end
  else
  begin
    //Failure
    sMsg := sMsg + Format(pingResponseNG, [LoopCount, Ping1.LastErrStr,
      Ping1.ReplyStatus]);
    // count NG
    pingResult.iPingNG := pingResult.iPingNG + 1;
    if pingResult.bPreviousNG then
    begin
      pingResult.iPreviousNG := pingResult.iPreviousNG + 1;
      if pingResult.iPreviousNG >= pingResult.iPingLostSerialNum then
      begin
        pingResult.iPingLostTimes := pingResult.iPingLostTimes + 1;
        pingResult.iPingLostTimesList.Add(formatdatetime('YYYYMMDD_hh:mm:ss # ',
          curTime) + ' Ping lost over ' +
          intTostr(pingResult.iPingLostSerialNum) + ' packets');
        pingResult.iPreviousNG := 0;
      end;
    end;
    pingResult.bPreviousNG := true;
    MSecs := 0;
    if cbEnableChart.Checked then
    begin
      // chart  Series2
      MColor := clRed;
      Series2.Add(MSecs, curPingID, MColor);
    end;
  end;
  WriteToLog(sMsg);

  if MSecs > MMax then
    MMax := MSecs;
  if MSecs < MMin then
    MMin := MSecs;
  MAve := MAve + MSecs;
  if LoopCount > 0 then
  begin
    MSecsAve := Round(MAve / LoopCount);
  end;

  updateResult;
end;

procedure TfrmMyPing.Ping1EchoRequest(Sender, Icmp: TObject);
begin
  // TODO: IPv6 or IPv6
  // WriteToLog('Sending ' + IntToStr(Ping1.Size) + ' bytes to ' +
  // Ping1.HostName + ' (' + Ping1.HostIP + ')');
  Ping1.SrcAddress := '';
  // if SrcIpV4.ItemIndex > 0 then
  // Ping1.SrcAddress := SrcIpV4.Items[SrcIpV4.ItemIndex];
  Ping1.SrcAddress6 := '';
  // if SrcIpV6.ItemIndex > 0 then
  // Ping1.SrcAddress6 := SrcIpV6.Items[SrcIpV6.ItemIndex];

  Ping1.Timeout := spTimeoutTime.Value;
  Ping1.Size := spPacketSize.Value;
end;

procedure TfrmMyPing.PingThreadTermPing(Sender: TObject);
// const
// response1 = 'Ping seq %d for %s, %s [%d]';
// response2 = 'Ping seq %d for %s, received %d bytes from %s in %dms';
var
  curTime: TDatetime;
  sMsg: string;
  MSecs: Cardinal;
  curPingID: string;
  MColor: Tcolor;
begin
  MSecs := 0;
  MColor := clGreen;

  if Application.Terminated then
    exit;
  curTime := now;
  sMsg := formatdatetime('YYYYMMDD_hh:mm:ss.zzz # ', curTime);
  // this event is thread safe, all publics from the thread are available here
  with Sender as TPingThread do
  begin
    curPingID := intTostr(PingId);
    // fix: avoid ping not exist IP but when PingId=2 and ReplyDataSize=0 will have ReplyTotal=1
    if ((ReplyTotal <> 0) and (ReplyDataSize <> 0)) then
    begin
      // success
      sMsg := sMsg + Format(pingResponseOK, [PingId, ReplyIPAddr, ReplyDataSize,
        ReplyRTT, ErrCode]);
      // count OK
      pingResult.iPingOK := pingResult.iPingOK + 1;
      pingResult.bPreviousNG := false;
      if cbEnableChart.Checked then
      begin
        // chart
        MSecs := ReplyRTT;
        // MColor := clBlue;
        Series1.Add(MSecs, curPingID, MColor); // chart
      end;
    end
    else
    begin
      // error
      sMsg := sMsg + Format(pingResponseNG, [PingId, PingHostName, ErrString, ErrCode]);
      // count NG
      pingResult.iPingNG := pingResult.iPingNG + 1;
      if pingResult.bPreviousNG then
      begin
        pingResult.iPreviousNG := pingResult.iPreviousNG + 1;
        if pingResult.iPreviousNG >= pingResult.iPingLostSerialNum then
        begin
          pingResult.iPingLostTimes := pingResult.iPingLostTimes + 1;
          pingResult.iPingLostTimesList.Add
            (formatdatetime('YYYY-MM-DD_hh:mm:ss # ', curTime) +
            ' Ping lost over ' + intTostr(pingResult.iPingLostSerialNum) +
            ' packets');
          pingResult.iPreviousNG := 0;
        end;
      end;
      pingResult.bPreviousNG := true;
      if cbEnableChart.Checked then
      begin
        MSecs := 0;
        MColor := clRed;
        Series2.Add(MSecs, curPingID, MColor); // chart
      end;
    end;
  end;
  WriteToLog(sMsg);

  if MSecs > MMax then
    MMax := MSecs;
  if MSecs < MMin then
    MMin := MSecs;
  MAve := MAve + MSecs;
  if LoopCount > 0 then
  begin
    MSecsAve := Round(MAve / LoopCount);
    // Series2.Add(MSecsAve, 'Average', clTeeColor);
  end;

  updateResult;
  if not stopPing then
  begin
    Timer1.Enabled := true;
  end;

end;

end.
