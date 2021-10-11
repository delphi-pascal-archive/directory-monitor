unit uMonThread;

interface

uses
  Classes, windows, SysUtils;

type

  TMonDirThread = class(TThread)
  private
    FPath: String;                    //����������� �������
  protected
    procedure Execute; override;
    procedure UpdateLog;              //���������� ������ � ������.
    procedure ThreadStart;            //����� ������
    procedure ThreadStop;             //���������� ������
  public
    constructor Create(aPath: String);
  end;

implementation
uses
  ufMain;

constructor TMonDirThread.Create(aPath: String);
begin
  inherited Create(True);     //��������� ����� ��������� � ���������������� ���������
  FreeOnTerminate := True;    //����� ��������� ������� ��� ��������� ������
  FPath := aPath;           	//����������� �������
  Self.Priority := tpHighest; //����� ������� ���������
  Resume;
end;

procedure TMonDirThread.ThreadStart;
begin
  fMonDirMain.sbMain.Panels[1].Text := '�������';
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': ������� �������');
end;

procedure TMonDirThread.ThreadStop;
begin
  fMonDirMain.sbMain.Panels[1].Text := '��������';
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': ������� ����������');
  fMonDirMain.mmStart.Enabled := True;    // ��������� ������ mmStart
  fMonDirMain.mmStop.Enabled := False;    // �������� ������ mmStop
end;

procedure TMonDirThread.UpdateLog;
begin
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': ���������!');
  if fMonDirMain.lbLog.Items.Count > 200 then //���������� ������ 200 �������
    fMonDirMain.lbLog.Items.Delete(0);
  fMonDirMain.lbLog.ItemIndex := fMonDirMain.lbLog.Items.Count-1;
end;

procedure TMonDirThread.Execute;
var
  HandleChange: THandle;  //Handle ������������ ������� ��� �������� �������
begin
//-- ������� ������ ��� �������� �������
  HandleChange :=
    FindFirstChangeNotification(
      PChar(FPath),                           //����������� �������
      False,                                  //����������� �� �����������
      FILE_NOTIFY_CHANGE_FILE_NAME +          //�������� ��������/��������/
      FILE_NOTIFY_CHANGE_ATTRIBUTES);         //��������������/��������� ������

//-- ��� ������ Win32Check ������� ��������� � ��������� Execute.
    Win32Check(HandleChange <> INVALID_HANDLE_VALUE);
      Synchronize(ThreadStart);               //��������� � ������ ������
  try
//-- ����, ���� ��� ������ �� ����� ������ ������� Terminate
    while not Terminated do
    begin
      case WaitForSingleObject(HandleChange,1000) of
        WAIT_FAILED: Terminate;                //������, ��������� �����
        WAIT_OBJECT_0: Synchronize(UpdateLog); //�������� �� ���������
      end;
      FindNextChangeNotification(HandleChange);
    end;
  finally
    FindCloseChangeNotification(HandleChange);
  end;
  Synchronize(ThreadStop);                     //�������� � ���������� ������
end;

end.
