program MonDir;

uses
  Forms,
  ufMain in 'ufMain.pas' {fMonDirMain},
  uMonThread in 'uMonThread.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.Title := '������� ���������';
  Application.CreateForm(TfMonDirMain, fMonDirMain);
  Application.Run;
end.
