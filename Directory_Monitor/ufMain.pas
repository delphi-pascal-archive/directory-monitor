unit ufMain;

interface

uses
  windows, SysUtils, Classes, Graphics, Forms,
  Controls, StdCtrls, ExtCtrls, ComCtrls, Menus,
  uMonThread;

type
  TfMonDirMain = class(TForm)
    mm: TMainMenu;
    sbMain: TStatusBar;
    tmDate: TTimer;
    lbLog: TListBox;
    N1: TMenuItem;
    mmStart: TMenuItem;
    mmStop: TMenuItem;
    N2: TMenuItem;
    N3: TMenuItem;
    procedure tmDateTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure mmStartClick(Sender: TObject);
    procedure mmStopClick(Sender: TObject);
    procedure N3Click(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  fMonDirMain: TfMonDirMain;

implementation

{$R *.DFM}

procedure TfMonDirMain.tmDateTimer(Sender: TObject);
begin
 sbMain.Panels[0].Text := FormatDateTime('dd.mm.yyyy hh.nn.ss',now);
end; 

procedure TfMonDirMain.FormCreate(Sender: TObject);
begin
   tmDateTimer(Self);
   sbMain.Panels[1].Text := '��������';
// ����� ������� ��������� ��� ������ ����������.
	Application.Title := '������� ���������';
//����� ��������� ����� � ���������� �� ������ ����� (TaskBar) ������ ����������.
//�� ����� ���� ��������� ���������� ����� ������� ����� ��� ���������� ����������.
//��� ����� �������� � ���� Delphi�Project�Options � �� �������� Application
//��������� ���� Title
end;

procedure TfMonDirMain.mmStartClick(Sender: TObject);
begin
  fMonDirMain.mmStart.Enabled := False; // ��������� ������ mmStart
  fMonDirMain.mmStop.Enabled := True;   // �������� ������ mmStop
  fMonDirMain.Tag := Integer(TMonDirThread.Create('c:\tmp'));
end;

procedure TfMonDirMain.mmStopClick(Sender: TObject);
begin
  if Assigned(TMonDirThread(fMonDirMain.Tag)) then TMonDirThread(fMonDirMain.Tag).Terminate;
  fMonDirMain.Tag := 0;
end;

procedure TfMonDirMain.N3Click(Sender: TObject);
begin
 Close;
end;

end.
