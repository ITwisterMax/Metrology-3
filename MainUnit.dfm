object Analizator: TAnalizator
  Left = 0
  Top = 0
  BorderIcons = []
  BorderStyle = bsSingle
  Caption = #1040#1085#1072#1083#1080#1079#1072#1090#1086#1088
  ClientHeight = 800
  ClientWidth = 1238
  Color = clBtnFace
  DoubleBuffered = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -13
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object Label1: TLabel
    Left = 560
    Top = 19
    Width = 60
    Height = 31
    Caption = #1057#1087#1077#1085
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label2: TLabel
    Left = 824
    Top = 19
    Width = 304
    Height = 31
    Caption = #1055#1086#1083#1085#1072#1103' '#1084#1077#1090#1088#1080#1082#1072' '#1063#1077#1087#1080#1085#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Label3: TLabel
    Left = 792
    Top = 351
    Width = 375
    Height = 31
    Caption = #1052#1077#1090#1088#1080#1082#1072' '#1063#1077#1087#1080#1085#1072' '#1074#1074#1086#1076#1072'/'#1074#1099#1074#1086#1076#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
  end
  object Load_: TButton
    Left = 463
    Top = 662
    Width = 762
    Height = 49
    Caption = #1047#1072#1075#1088#1091#1079#1080#1090#1100' '#1082#1086#1076' '#1080#1079' '#1092#1072#1081#1083#1072
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 2
    OnClick = Load_Click
  end
  object StartWork_: TButton
    Left = 463
    Top = 734
    Width = 324
    Height = 49
    Caption = #1040#1085#1072#1083#1080#1079
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 3
    OnClick = StartWork_Click
  end
  object Exit_: TButton
    Left = 901
    Top = 734
    Width = 324
    Height = 49
    Caption = #1042#1099#1093#1086#1076
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -37
    Font.Name = 'Times New Roman'
    Font.Style = [fsBold, fsItalic]
    ParentFont = False
    TabOrder = 4
    OnClick = Exit_Click
  end
  object TableSpen_: TStringGrid
    Left = 463
    Top = 56
    Width = 266
    Height = 582
    ColCount = 2
    DefaultColWidth = 128
    FixedCols = 0
    RowCount = 101
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Lucida Console'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goColMoving, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 1
    RowHeights = (
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24
      24)
  end
  object ProgramText_: TRichEdit
    Left = 8
    Top = 8
    Width = 449
    Height = 630
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Lucida Console'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WantTabs = True
    Zoom = 100
  end
  object ResultText_: TRichEdit
    Left = 8
    Top = 662
    Width = 449
    Height = 121
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWindowText
    Font.Height = -15
    Font.Name = 'Lucida Console'
    Font.Style = []
    Lines.Strings = (
      ''
      ''
      ''
      ''
      '')
    ParentFont = False
    ReadOnly = True
    TabOrder = 5
    Zoom = 100
  end
  object TableChapinFull_: TStringGrid
    Left = 735
    Top = 56
    Width = 490
    Height = 250
    DefaultColWidth = 96
    FixedCols = 0
    RowCount = 101
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 6
  end
  object TableChapinIO_: TStringGrid
    Left = 735
    Top = 388
    Width = 490
    Height = 250
    DefaultColWidth = 96
    FixedCols = 0
    RowCount = 101
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Tahoma'
    Font.Style = []
    Options = [goFixedVertLine, goFixedHorzLine, goVertLine, goHorzLine, goRangeSelect, goRowSelect]
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 7
  end
  object DlgOpen_: TOpenDialog
    Title = #1042#1099#1073#1077#1088#1080#1090#1077' '#1092#1072#1081#1083
    Left = 24
    Top = 736
  end
end
