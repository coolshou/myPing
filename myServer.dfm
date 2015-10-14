object myServerForm: TmyServerForm
  Left = 0
  Top = 0
  Caption = 'myServerForm'
  ClientHeight = 367
  ClientWidth = 644
  Color = clBtnFace
  Constraints.MinHeight = 400
  Constraints.MinWidth = 660
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 644
    Height = 60
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    object lbReportInterval: TLabel
      Left = 480
      Top = 9
      Width = 91
      Height = 13
      Caption = 'Report Interval(s):'
    end
    object edServerIP: TEdit
      Left = 120
      Top = 6
      Width = 265
      Height = 21
      TabOrder = 0
    end
    object btnSendToServerTest: TButton
      Left = 391
      Top = 4
      Width = 75
      Height = 25
      Caption = 'Test'
      TabOrder = 1
      OnClick = btnSendToServerTestClick
    end
    object spReportInterval: TSpinEdit
      Left = 577
      Top = 6
      Width = 65
      Height = 22
      MaxValue = 0
      MinValue = 0
      TabOrder = 2
      Value = 300
    end
    object cbReportToServer: TCheckBox
      Left = 9
      Top = 8
      Width = 112
      Height = 17
      Caption = 'Report To Server:'
      TabOrder = 3
      OnClick = cbReportToServerClick
    end
    object cbRunAsServer: TCheckBox
      Left = 9
      Top = 33
      Width = 97
      Height = 17
      Caption = 'Run As Server:'
      TabOrder = 4
      OnClick = cbRunAsServerClick
    end
    object btnServer: TButton
      Left = 104
      Top = 29
      Width = 75
      Height = 25
      Caption = 'Start'
      TabOrder = 5
      OnClick = btnServerClick
    end
  end
  object plServer: TPanel
    Left = 0
    Top = 60
    Width = 644
    Height = 307
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 1
    object Splitter1: TSplitter
      Left = 385
      Top = 0
      Width = 6
      Height = 307
      ExplicitLeft = 156
    end
    object Panel4: TPanel
      Left = 391
      Top = 0
      Width = 253
      Height = 307
      Align = alClient
      BevelOuter = bvNone
      TabOrder = 0
      object memoLog: TMemo
        Left = 0
        Top = 0
        Width = 253
        Height = 307
        Align = alClient
        ScrollBars = ssBoth
        TabOrder = 0
      end
    end
    object VirtualStringTree1: TVirtualStringTree
      Left = 0
      Top = 0
      Width = 385
      Height = 307
      Align = alLeft
      Header.AutoSizeIndex = 0
      Header.Font.Charset = DEFAULT_CHARSET
      Header.Font.Color = clWindowText
      Header.Font.Height = -11
      Header.Font.Name = 'Tahoma'
      Header.Font.Style = []
      Header.Options = [hoColumnResize, hoDblClickResize, hoDrag, hoShowSortGlyphs, hoVisible]
      TabOrder = 1
      TreeOptions.PaintOptions = [toHotTrack, toShowButtons, toShowDropmark, toShowTreeLines, toThemeAware, toUseBlendedImages]
      Columns = <
        item
          Position = 0
          Width = 54
          WideText = 'Host'
        end
        item
          Position = 1
          Width = 59
          WideText = 'Target IP'
        end
        item
          Position = 2
          Width = 86
          WideText = 'Lost Rate(%)'
        end
        item
          Position = 3
          Width = 63
          WideText = 'Ping Lost'
        end
        item
          Position = 4
          Width = 77
          WideText = 'Report Time'
        end>
    end
  end
  object TimerSendMsg: TTimer
    Enabled = False
    OnTimer = TimerSendMsgTimer
    Left = 568
    Top = 40
  end
  object SysLogServer1: TSysLogServer
    Addr = '0.0.0.0'
    Port = '54514'
    RelaxedSyntax = True
    OnDataAvailable = SysLogServer1DataAvailable
    Left = 368
    Top = 32
  end
  object SysLogClient1: TSysLogClient
    Server = '127.0.0.1'
    Port = '54514'
    Facility = SYSLOG_FACILITY_USER
    Severity = SYSLOG_SEVERITY_NOTICE
    PID = -1
    RFC5424 = True
    Left = 436
    Top = 32
  end
end
