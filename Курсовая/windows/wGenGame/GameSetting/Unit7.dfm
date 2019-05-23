object GameSetting: TGameSetting
  Left = 571
  Top = 338
  BorderStyle = bsNone
  Caption = 'GameSetting'
  ClientHeight = 470
  ClientWidth = 900
  Color = clBlack
  TransparentColor = True
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsStayOnTop
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object lbl1: TLabel
    Left = 320
    Top = 128
    Width = 222
    Height = 33
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1088#1090#1091' '
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object Label1: TLabel
    Left = 352
    Top = 32
    Width = 150
    Height = 33
    Caption = #1057#1083#1086#1078#1085#1086#1089#1090#1100
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 344
    Top = 80
    Width = 174
    Height = 33
    Caption = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -27
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object btn4: TSpeedButton
    Left = 296
    Top = 80
    Width = 41
    Height = 41
    OnClick = btn4Click
  end
  object btn5: TSpeedButton
    Left = 520
    Top = 80
    Width = 41
    Height = 41
    OnClick = btn5Click
  end
  object btn1: TSpeedButton
    Left = 184
    Top = 208
    Width = 169
    Height = 161
    Caption = '5*5'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btn1Click
  end
  object btn2: TSpeedButton
    Left = 360
    Top = 208
    Width = 161
    Height = 161
    Caption = '7*7'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btn2Click
  end
  object btn3: TSpeedButton
    Left = 528
    Top = 208
    Width = 161
    Height = 161
    Caption = '9*9'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -53
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    OnClick = btn3Click
  end
end
