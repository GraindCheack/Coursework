object GameSetting: TGameSetting
  Left = 571
  Top = 339
  BorderStyle = bsNone
  Caption = 'GameSetting'
  ClientHeight = 469
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
    Left = 216
    Top = 192
    Width = 457
    Height = 63
    Caption = #1042#1099#1073#1077#1088#1080#1090#1077' '#1082#1072#1088#1090#1091' '
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -53
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
  object lbl2: TLabel
    Left = 280
    Top = 80
    Width = 315
    Height = 58
    Alignment = taCenter
    AutoSize = False
    Caption = #1057#1090#1072#1085#1076#1072#1088#1090#1085#1072#1103
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -48
    Font.Name = 'Century Gothic'
    Font.Style = []
    ParentColor = False
    ParentFont = False
  end
  object btn4: TSpeedButton
    Left = 200
    Top = 88
    Width = 41
    Height = 41
    OnClick = btn4Click
  end
  object btn5: TSpeedButton
    Left = 632
    Top = 88
    Width = 41
    Height = 41
    OnClick = btn5Click
  end
  object btn1: TSpeedButton
    Left = 184
    Top = 264
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
    Top = 264
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
    Top = 264
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
  object lbl3: TLabel
    Left = 296
    Top = 24
    Width = 274
    Height = 56
    Caption = #1057#1083#1086#1078#1085#1086#1089#1090#1100
    Color = clBlack
    Font.Charset = RUSSIAN_CHARSET
    Font.Color = clWhite
    Font.Height = -48
    Font.Name = 'Century Gothic'
    Font.Style = [fsBold]
    ParentColor = False
    ParentFont = False
  end
end
