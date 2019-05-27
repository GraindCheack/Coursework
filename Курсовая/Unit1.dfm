object Game: TGame
  Left = 337
  Top = 199
  BorderStyle = bsSingle
  Caption = 'Game'
  ClientHeight = 673
  ClientWidth = 1179
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnActivate = FormActivate
  OnHide = FormHide
  PixelsPerInch = 96
  TextHeight = 13
  object img1: TImage
    Left = -8
    Top = 0
    Width = 1188
    Height = 678
    AutoSize = True
  end
  object tmr1: TTimer
    Interval = 30
    OnTimer = tmr1Timer
    Left = 48
    Top = 40
  end
end
