object fMonDirMain: TfMonDirMain
  Left = 239
  Top = 131
  BorderIcons = [biSystemMenu, biMinimize]
  BorderStyle = bsSingle
  Caption = #1052#1086#1085#1080#1090#1086#1088' '#1082#1072#1090#1072#1083#1086#1075#1086#1074
  ClientHeight = 349
  ClientWidth = 592
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -14
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = mm
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 120
  TextHeight = 16
  object sbMain: TStatusBar
    Left = 0
    Top = 330
    Width = 592
    Height = 19
    Panels = <
      item
        Width = 130
      end
      item
        Width = 150
      end
      item
        Width = 50
      end>
  end
  object lbLog: TListBox
    Left = 0
    Top = 0
    Width = 592
    Height = 330
    Align = alClient
    ItemHeight = 16
    TabOrder = 1
  end
  object mm: TMainMenu
    Left = 16
    Top = 24
    object N1: TMenuItem
      Caption = #1052#1086#1085#1080#1090#1086#1088
      object mmStart: TMenuItem
        Caption = #1057#1090#1072#1088#1090
        OnClick = mmStartClick
      end
      object mmStop: TMenuItem
        Caption = #1057#1090#1086#1087
        Enabled = False
        OnClick = mmStopClick
      end
      object N2: TMenuItem
        Caption = '-'
      end
      object N3: TMenuItem
        Caption = #1042#1099#1093#1086#1076
        OnClick = N3Click
      end
    end
  end
  object tmDate: TTimer
    OnTimer = tmDateTimer
    Left = 56
    Top = 24
  end
end
