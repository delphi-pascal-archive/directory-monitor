unit uMonThread;

interface

uses
  Classes, windows, SysUtils;

type

  TMonDirThread = class(TThread)
  private
    FPath: String;                    //Проверяемый каталог
  protected
    procedure Execute; override;
    procedure UpdateLog;              //Добавление записи в журнал.
    procedure ThreadStart;            //Старт потока
    procedure ThreadStop;             //Завершение потока
  public
    constructor Create(aPath: String);
  end;

implementation
uses
  ufMain;

constructor TMonDirThread.Create(aPath: String);
begin
  inherited Create(True);     //Созданный поток создается в приостановленном состоянии
  FreeOnTerminate := True;    //Поток освободит ресурсы при окончании работы
  FPath := aPath;           	//Проверяемый каталог
  Self.Priority := tpHighest; //Очень высокий приоритет
  Resume;
end;

procedure TMonDirThread.ThreadStart;
begin
  fMonDirMain.sbMain.Panels[1].Text := 'Активен';
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': монитор запущен');
end;

procedure TMonDirThread.ThreadStop;
begin
  fMonDirMain.sbMain.Panels[1].Text := 'Отключен';
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': монитор остановлен');
  fMonDirMain.mmStart.Enabled := True;    // Отключаем кнопку mmStart
  fMonDirMain.mmStop.Enabled := False;    // Включаем кнопку mmStop
end;

procedure TMonDirThread.UpdateLog;
begin
  fMonDirMain.lbLog.Items.Add(TimeToStr(time)+': изменение!');
  if fMonDirMain.lbLog.Items.Count > 200 then //Показываем только 200 записей
    fMonDirMain.lbLog.Items.Delete(0);
  fMonDirMain.lbLog.ItemIndex := fMonDirMain.lbLog.Items.Count-1;
end;

procedure TMonDirThread.Execute;
var
  HandleChange: THandle;  //Handle создаваемого объекта для ожидания события
begin
//-- Создаем объект для ожидания события
  HandleChange :=
    FindFirstChangeNotification(
      PChar(FPath),                           //Проверяемый каталог
      False,                                  //Подкаталоги не проверяются
      FILE_NOTIFY_CHANGE_FILE_NAME +          //Проверка создания/удаления/
      FILE_NOTIFY_CHANGE_ATTRIBUTES);         //переименования/изменения файлов

//-- При ошибке Win32Check выводит сообщение и прерывает Execute.
    Win32Check(HandleChange <> INVALID_HANDLE_VALUE);
      Synchronize(ThreadStart);               //Сообщение о старте потока
  try
//-- Цикл, пока для потока не будет выдана команда Terminate
    while not Terminated do
    begin
      case WaitForSingleObject(HandleChange,1000) of
        WAIT_FAILED: Terminate;                //Ошибка, завершаем поток
        WAIT_OBJECT_0: Synchronize(UpdateLog); //Сообщаем об изменении
      end;
      FindNextChangeNotification(HandleChange);
    end;
  finally
    FindCloseChangeNotification(HandleChange);
  end;
  Synchronize(ThreadStop);                     //Сообщаем о завершении потока
end;

end.
