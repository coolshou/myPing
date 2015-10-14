object frmMyPing: TfrmMyPing
  Left = 0
  Top = 0
  Caption = 'Ping'
  ClientHeight = 354
  ClientWidth = 684
  Color = clBtnFace
  Constraints.MinHeight = 380
  Constraints.MinWidth = 700
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 684
    Height = 354
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object TabbedNotebook1: TTabbedNotebook
      Left = 0
      Top = 0
      Width = 684
      Height = 354
      Align = alClient
      PageIndex = 1
      TabFont.Charset = DEFAULT_CHARSET
      TabFont.Color = clBtnText
      TabFont.Height = -11
      TabFont.Name = 'Tahoma'
      TabFont.Style = []
      TabOrder = 0
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Hosts'
        object plHosts: TPanel
          Left = 0
          Top = 0
          Width = 676
          Height = 326
          Align = alClient
          BevelOuter = bvNone
          Caption = 'plHosts'
          TabOrder = 0
          object Panel6: TPanel
            Left = 0
            Top = 0
            Width = 676
            Height = 32
            Align = alTop
            BevelOuter = bvNone
            TabOrder = 0
            object edtHost: TLabeledEdit
              Left = 34
              Top = 5
              Width = 121
              Height = 21
              EditLabel.Width = 14
              EditLabel.Height = 13
              EditLabel.Caption = 'IP:'
              LabelPosition = lpLeft
              TabOrder = 0
              Text = '192.168.0.1'
            end
            object btnAdd: TButton
              Left = 162
              Top = 3
              Width = 48
              Height = 25
              Action = cmdAddHost
              TabOrder = 1
            end
            object butPING: TButton
              Left = 250
              Top = 4
              Width = 45
              Height = 25
              Cursor = crHandPoint
              Action = cmdStart
              ParentShowHint = False
              ShowHint = True
              TabOrder = 2
            end
          end
          object vstHosts: TVirtualStringTree
            Left = 187
            Top = 32
            Width = 489
            Height = 294
            Align = alClient
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            PopupMenu = PopMenuTargetIP
            TabOrder = 1
            TreeOptions.PaintOptions = [toShowButtons, toShowDropmark, toShowHorzGridLines, toThemeAware, toUseBlendedImages]
            OnFreeNode = vstHostsFreeNode
            OnGetText = vstHostsGetText
            Columns = <
              item
                Position = 0
                Width = 254
                WideText = 'Target IP'
              end>
          end
          object gbConfig: TGroupBox
            Left = 0
            Top = 32
            Width = 187
            Height = 294
            Align = alLeft
            TabOrder = 2
            object lbTimeoutTime: TLabel
              Left = 27
              Top = 37
              Width = 66
              Height = 13
              Caption = 'Timeout (ms):'
            end
            object lbInterval: TLabel
              Left = 15
              Top = 9
              Width = 78
              Height = 13
              Caption = 'Ping Interval(s):'
            end
            object lbPacketSize: TLabel
              Left = 38
              Top = 65
              Width = 55
              Height = 13
              Caption = 'PacketSize:'
            end
            object lbCriteria: TLabel
              Left = 16
              Top = 90
              Width = 156
              Height = 13
              Caption = 'Ping Lost Criteria:                    %'
            end
            object lbPingLostSerialNum: TLabel
              Left = 16
              Top = 118
              Width = 121
              Height = 13
              Hint = 
                'How many continious ping lost package will count as ping lost fa' +
                'il.'
              Caption = 'Continious Ping Lost limit:'
              ParentShowHint = False
              ShowHint = True
            end
            object spInterval: TSpinEdit
              Left = 99
              Top = 6
              Width = 56
              Height = 22
              Increment = 1000
              MaxValue = 60000
              MinValue = 1000
              TabOrder = 0
              Value = 1000
            end
            object spTimeoutTime: TSpinEdit
              Left = 99
              Top = 34
              Width = 56
              Height = 22
              Increment = 500
              MaxValue = 6000
              MinValue = 1000
              TabOrder = 1
              Value = 2000
            end
            object spPacketSize: TSpinEdit
              Left = 99
              Top = 62
              Width = 56
              Height = 22
              MaxValue = 1024
              MinValue = 24
              TabOrder = 2
              Value = 1024
            end
            object spCriteria: TSpinEdit
              Left = 115
              Top = 87
              Width = 40
              Height = 22
              MaxValue = 100
              MinValue = 1
              TabOrder = 3
              Value = 1
            end
            object spPingLostSerialNum: TSpinEdit
              Left = 142
              Top = 115
              Width = 40
              Height = 22
              MaxValue = 100
              MinValue = 1
              TabOrder = 4
              Value = 10
            end
          end
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Report'
        object plReport: TPanel
          Left = 0
          Top = 0
          Width = 676
          Height = 326
          Align = alClient
          Caption = 'plReport'
          TabOrder = 0
          object Memo1: TMemo
            Left = 448
            Top = 1
            Width = 227
            Height = 261
            Align = alRight
            DoubleBuffered = True
            ParentDoubleBuffered = False
            ScrollBars = ssBoth
            TabOrder = 0
            WordWrap = False
          end
          object Panel5: TPanel
            Left = 1
            Top = 262
            Width = 674
            Height = 63
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object gbEnableLog: TGroupBox
              Left = 0
              Top = 0
              Width = 674
              Height = 63
              Align = alClient
              Caption = 'Log'
              TabOrder = 0
              object btnLogFileSelect: TButton
                Left = 595
                Top = 11
                Width = 61
                Height = 25
                Caption = 'Browser'
                Enabled = False
                TabOrder = 0
              end
              object cbEnableSubffix: TCheckBox
                Left = 14
                Top = 40
                Width = 177
                Height = 17
                Caption = 'Add suffix at the end of filename'
                TabOrder = 1
                OnClick = cbEnableSubffixClick
              end
              object edLogfileName: TEdit
                Left = 115
                Top = 13
                Width = 470
                Height = 21
                Enabled = False
                TabOrder = 2
                Text = 'log.txt'
              end
              object edSubffixString: TEdit
                Left = 191
                Top = 39
                Width = 138
                Height = 21
                Color = clBtnFace
                ReadOnly = True
                TabOrder = 3
                Text = 'YYYY-MM-DD_hhmmss'
              end
              object cbEnableLogFile: TCheckBox
                Left = 14
                Top = 15
                Width = 97
                Height = 17
                Caption = 'Log to FileName'
                TabOrder = 4
                OnClick = cbEnableLogFileClick
              end
            end
          end
          object VirtualStringTree2: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 447
            Height = 261
            Align = alClient
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.MainColumn = -1
            ScrollBarOptions.AlwaysVisible = True
            TabOrder = 2
            Columns = <>
          end
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Chart'
        object plChart: TPanel
          Left = 0
          Top = 0
          Width = 676
          Height = 326
          Align = alClient
          BevelOuter = bvNone
          TabOrder = 0
          Visible = False
          object cbEnableChart: TCheckBox
            Left = 0
            Top = 0
            Width = 676
            Height = 17
            Align = alTop
            Caption = 'Enable Chart'
            TabOrder = 0
            OnClick = cbEnableChartClick
          end
          object Chart1: TChart
            Left = 0
            Top = 17
            Width = 676
            Height = 309
            AllowPanning = pmHorizontal
            Legend.Visible = False
            Title.Text.Strings = (
              'TChart')
            Title.Visible = False
            BottomAxis.ExactDateTime = False
            BottomAxis.GridCentered = True
            BottomAxis.LabelsFormat.Font.Shadow.Visible = False
            BottomAxis.MinorTickCount = 0
            BottomAxis.MinorTickLength = 1
            BottomAxis.RoundFirstLabel = False
            BottomAxis.Title.Caption = 'Duration (sec)'
            Chart3DPercent = 1
            LeftAxis.Title.Caption = 'ms'
            Panning.MouseWheel = pmwNone
            RightAxis.Visible = False
            TopAxis.Visible = False
            View3D = False
            View3DOptions.Orthogonal = False
            Zoom.Direction = tzdHorizontal
            Zoom.History = True
            Align = alClient
            BevelOuter = bvNone
            TabOrder = 1
            DefaultCanvas = 'TGDIPlusCanvas'
            PrintMargins = (
              15
              36
              15
              36)
            ColorPaletteIndex = 7
            object Series1: TBarSeries
              BarPen.Visible = False
              Marks.Emboss.Color = 8618883
              Marks.Shadow.Color = 8684676
              Marks.Shadow.Visible = False
              Marks.Visible = False
              Marks.Style = smsValue
              Marks.DrawEvery = 10
              SeriesColor = clGreen
              Shadow.HorizSize = 4
              Shadow.Visible = False
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Bar'
              YValues.Order = loNone
            end
            object Series2: TBubbleSeries
              ShowInEditor = False
              Legend.Visible = False
              ColorEachPoint = False
              Marks.Emboss.Color = 8487297
              Marks.Frame.Visible = False
              Marks.Shadow.Color = 8487297
              Marks.Shadow.Visible = False
              SeriesColor = clRed
              ShowInLegend = False
              ClickableLine = False
              Pointer.Brush.Gradient.EndColor = 6724095
              Pointer.Gradient.EndColor = 6724095
              Pointer.HorizSize = 40
              Pointer.InflateMargins = False
              Pointer.Pen.Visible = False
              Pointer.Style = psCircle
              Pointer.VertSize = 40
              XValues.Name = 'X'
              XValues.Order = loAscending
              YValues.Name = 'Y'
              YValues.Order = loNone
              RadiusValues.Name = 'Radius'
              RadiusValues.Order = loNone
            end
          end
        end
      end
      object TTabPage
        Left = 4
        Top = 24
        Caption = 'Statistics'
        object plStatistics: TPanel
          Left = 0
          Top = 0
          Width = 676
          Height = 326
          Align = alClient
          Caption = 'plStatistics'
          TabOrder = 0
          object VirtualStringTree1: TVirtualStringTree
            Left = 1
            Top = 1
            Width = 674
            Height = 244
            Align = alClient
            Header.AutoSizeIndex = 0
            Header.Font.Charset = DEFAULT_CHARSET
            Header.Font.Color = clWindowText
            Header.Font.Height = -11
            Header.Font.Name = 'Tahoma'
            Header.Font.Style = []
            Header.Height = 18
            Header.Options = [hoColumnResize, hoDrag, hoShowSortGlyphs, hoVisible]
            TabOrder = 0
            Columns = <
              item
                Position = 0
              end
              item
                Position = 1
                Width = 126
                WideText = 'Host'
              end
              item
                Position = 2
                WideText = 'Ping OK'
              end
              item
                Position = 3
                Width = 56
                WideText = 'Ping NG'
              end
              item
                Position = 4
                Width = 84
                WideText = 'Failure rate'
              end
              item
                Position = 5
                WideText = 'Min'
              end
              item
                Position = 6
                WideText = 'Max'
              end
              item
                Position = 7
                WideText = 'Avg'
              end>
          end
          object Panel2: TPanel
            Left = 1
            Top = 245
            Width = 674
            Height = 80
            Align = alBottom
            BevelOuter = bvNone
            TabOrder = 1
            object edPingOK: TLabeledEdit
              Left = 16
              Top = 24
              Width = 80
              Height = 21
              Color = clBtnFace
              DoubleBuffered = True
              EditLabel.Width = 41
              EditLabel.Height = 13
              EditLabel.Caption = 'Ping OK:'
              ParentDoubleBuffered = False
              ReadOnly = True
              TabOrder = 0
            end
            object edPingNG: TLabeledEdit
              Left = 100
              Top = 24
              Width = 80
              Height = 21
              Color = clBtnFace
              DoubleBuffered = True
              EditLabel.Width = 41
              EditLabel.Height = 13
              EditLabel.Caption = 'Ping NG:'
              ParentDoubleBuffered = False
              ReadOnly = True
              TabOrder = 1
            end
            object edPingLostRate: TLabeledEdit
              Left = 186
              Top = 24
              Width = 95
              Height = 21
              Color = clBtnFace
              DoubleBuffered = True
              EditLabel.Width = 92
              EditLabel.Height = 13
              EditLabel.Caption = 'Ping Lost Rate(%):'
              ParentDoubleBuffered = False
              ReadOnly = True
              TabOrder = 2
              OnChange = edPingLostRateChange
            end
            object btnClear: TButton
              Left = 287
              Top = 24
              Width = 41
              Height = 21
              Action = cmdClear
              TabOrder = 3
            end
            object edPingLostCount: TLabeledEdit
              Left = 100
              Top = 51
              Width = 80
              Height = 21
              Color = clBtnFace
              DoubleBuffered = True
              EditLabel.Width = 79
              EditLabel.Height = 13
              EditLabel.Caption = 'Ping Lost Count:'
              LabelPosition = lpLeft
              ParentDoubleBuffered = False
              ReadOnly = True
              TabOrder = 4
            end
            object btPingLostCountDetail: TButton
              Left = 186
              Top = 51
              Width = 47
              Height = 25
              Caption = 'Detail'
              TabOrder = 5
              OnClick = btPingLostCountDetailClick
            end
            object edMMax: TLabeledEdit
              Left = 408
              Top = 24
              Width = 49
              Height = 21
              Alignment = taCenter
              Color = clBtnFace
              EditLabel.Width = 20
              EditLabel.Height = 13
              EditLabel.Caption = 'Max'
              ReadOnly = True
              TabOrder = 6
            end
            object edMMin: TLabeledEdit
              Left = 463
              Top = 24
              Width = 50
              Height = 21
              Alignment = taCenter
              Color = clBtnFace
              EditLabel.Width = 16
              EditLabel.Height = 13
              EditLabel.Caption = 'Min'
              ReadOnly = True
              TabOrder = 7
            end
            object edMAve: TLabeledEdit
              Left = 519
              Top = 24
              Width = 50
              Height = 21
              Alignment = taCenter
              Color = clBtnFace
              EditLabel.Width = 19
              EditLabel.Height = 13
              EditLabel.Caption = 'Avg'
              ReadOnly = True
              TabOrder = 8
            end
          end
        end
      end
    end
  end
  object OpenTextFileDialog1: TOpenTextFileDialog
    Left = 568
    Top = 184
  end
  object MainMenu: TMainMenu
    Left = 352
    Top = 16
    object miFile: TMenuItem
      Caption = 'File'
      object miLoad: TMenuItem
        Action = ConfigLoad
      end
      object miSave: TMenuItem
        Action = ConfigSave
      end
    end
    object miCommand: TMenuItem
      Caption = 'Command'
      object Start1: TMenuItem
        Action = cmdStart
      end
      object Stop1: TMenuItem
        Action = cmdStop
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object Clear1: TMenuItem
        Action = cmdClear
      end
    end
    object miOption: TMenuItem
      Caption = 'Option'
      object miServer: TMenuItem
        Action = Server
      end
    end
  end
  object ActionList: TActionList
    Left = 400
    Top = 16
    object ConfigLoad: TFileOpen
      Category = 'File'
      Caption = '&Open...'
      Hint = 'Open|Opens an existing file'
      ImageIndex = 7
      ShortCut = 16463
      BeforeExecute = btPingLostCountDetailClick
      OnAccept = ConfigLoadAccept
    end
    object ConfigSave: TFileSaveAs
      Category = 'File'
      Caption = '&Save...'
      Hint = 'Save As|Saves the active file with a new name'
      ImageIndex = 30
      OnAccept = ConfigSaveAccept
    end
    object Server: TAction
      Category = 'Option'
      Caption = 'Server'
      OnExecute = ServerExecute
    end
    object cmdStart: TAction
      Category = 'command'
      Caption = 'Start'
      OnExecute = cmdStartExecute
    end
    object cmdStop: TAction
      Category = 'command'
      Caption = 'Stop'
      Enabled = False
      OnExecute = cmdStopExecute
    end
    object cmdClear: TAction
      Category = 'command'
      Caption = 'Clear'
      OnExecute = cmdClearExecute
    end
    object cmdAddHost: TAction
      Category = 'command'
      Caption = 'Add'
      OnExecute = cmdAddHostExecute
    end
    object cmdRemoveHost: TAction
      Category = 'command'
      Caption = 'Remove'
      OnExecute = cmdRemoveHostExecute
    end
    object Action2: TAction
      Caption = 'Action2'
    end
  end
  object Ping1: TPing
    SocketFamily = sfIPv4
    PingMsg = 'Pinging from Delphi code'
    Size = 56
    Timeout = 4000
    TTL = 64
    Flags = 0
    OnEchoRequest = Ping1EchoRequest
    OnEchoReply = Ping1EchoReply
    OnDnsLookupDone = Ping1DnsLookupDone
    Left = 280
    Top = 136
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 336
    Top = 136
  end
  object IdIcmpClient1: TIdIcmpClient
    ReceiveTimeout = 3000
    Protocol = 1
    ProtocolIPv6 = 58
    IPVersion = Id_IPv4
    PacketSize = 0
    OnReply = IdIcmpClient1Reply
    Left = 225
    Top = 124
  end
  object IdAntiFreeze1: TIdAntiFreeze
    Left = 225
    Top = 170
  end
  object PopMenuTargetIP: TPopupMenu
    Left = 477
    Top = 113
    object Remove1: TMenuItem
      Action = cmdRemoveHost
    end
  end
end
