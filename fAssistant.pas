{**
@Abstract Главная форма Assistant
@Author Prof1983 <prof1983@ya.ru>
@Created 03.06.2007
@LastMod 14.11.2012

Главная форма программы Assistant.
Является MDI формой.
По умолчанию должна разворачиваться на полный экран.
В верхней части окна место для меню и основные кнопки быстрого вызова команд.
В верхней части окна есть поле для ввода команд вручную.
Рядом кнопка "..." для ввода многострочных и сложных команд.
Рядом кнопка "Run" для запуска выполнения команды.
В нижней части окна место для вывода кнопок открытых окон.
В нижней части окна также есть статусная строка для вывода информации.

Форме AssistantForm должен быть передан указатель на микроядро системы (AICore)
для вызова выполнения команд.

Проторип внешнего вида окна:
- 1С 7.7 (http://www.1c.ru/)
- SAS Base (http://www.sas.com/)
}
unit fAssistant;

interface

uses
  ActnCtrls, ActnList, ActnMan, ActnMenus, ActnPopup,
  Buttons, Classes, ComCtrls, Controls, Dialogs, ExtCtrls, Graphics, Forms,
  ImgList, Menus, Messages, StdActns, StdCtrls, SysUtils, ToolWin, Variants,
  Windows, XPStyleActnCtrls,
  ABase, ACommandComboBoxControl, AConsts2, ALogRichEdit,
  ARemind, ARemindEditForm, ARemindForm, ARemindLoader, ARemindSaver, ATaskObj,
  AUiBase, AUiDialogs, AUiWindows, ASystemData,
  AiBaseTypes, AiCoreImpl, AiCoreIntf, AiForm2007,
  AssistantDataSaver, AssistantProgram, AssistantSettings, AssistantSettingsLoader,
  {AssistantTasks,} AssistantTasksControl;

type //** Главная форма Assistant
  TAssistantForm = class(TForm)
    tcWindows: TTabControl;
    CommandPanel: TPanel;
    sbMain: TStatusBar;
    CommandComboBox: TComboBox;
    CommandButton: TButton;
    RunCommandSpeedButton: TSpeedButton;
    ActionManager: TActionManager;
    ActionMainMenuBar1: TActionMainMenuBar;
    ImageList: TImageList;
    OpenProjectAction: TAction;
    NewProjectAction: TAction;
    CloseProjectAction: TAction;
    FileOpenAction: TFileOpen;
    HelpContentsAction: THelpContents;
    FileSaveAsAction: TFileSaveAs;
    AboutAction: TAction;
    RemindTimer: TTimer;
    MainPageControl: TPageControl;
    RemindTabSheet: TTabSheet;
    RemindListBox: TListBox;
    ButtonRemindPanel: TPanel;
    NewRemindBitBtn: TBitBtn;
    DeleteRemindBitBtn: TBitBtn;
    CloseBitBtn: TBitBtn;
    TaskTabSheet: TTabSheet;
    TaskListBox: TListBox;
    TaskButtonPanel: TPanel;
    RemoteTaskBitBtn: TBitBtn;
    AddRemindAction: TAction;
    AddTaskAction: TAction;
    ExitAction: TAction;
    ManagerAction: TAction;
    CloseAction: TAction;
    RemoteRemindAction: TAction;
    RemoteTaskAction: TAction;
    LogRichEdit: TRichEdit;
    TaskTreeView: TTreeView;
    TaskSplitter: TSplitter;
    procedure RunCommandSpeedButtonClick(Sender: TObject);
    procedure AboutActionExecute(Sender: TObject);
    procedure AddRemindActionExecute(Sender: TObject);
    procedure CloseActionExecute(Sender: TObject);
    procedure CloseProjectActionExecute(Sender: TObject);
    procedure CommandButtonClick(Sender: TObject);
    procedure CommandComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure CommandComboBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure ExitActionExecute(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure FormPaint(Sender: TObject);
    procedure ManagerActionExecute(Sender: TObject);
    procedure NewProjectActionExecute(Sender: TObject);
    procedure OpenProjectActionExecute(Sender: TObject);
    procedure RemindListBoxDblClick(Sender: TObject);
    procedure RemindTimerTimer(Sender: TObject);
    procedure RemoteTaskActionExecute(Sender: TObject);
    procedure RemoteRemindActionExecute(Sender: TObject);
    procedure TaskListBoxDblClick(Sender: TObject);
    procedure tcWindowsChange(Sender: TObject);
    procedure tcWindowsMouseUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  private
    //** Контрол для ComboBox ввода команд
    FCommandComboBoxControl: TCommandComboBoxControl;
    //** Флаг, который указывает закрывать программу или сворачивать в трей.
    FIsClose: Boolean;
    {**
      Функция добавления лог-сообщения.
      Все лог-сообщения поступают в микроядро.
      Далеее рассылаются по объектам вывода, записи и обработки лог-сообщений.
    }
    FOnAddToLog: TAIProcMessage;
    //** Список напоминаний
    FReminds: TReminds;
    //** Настройки программы
    FSettings: TAssistantSettings;
  private // Reminder
    //** Флаг, который показывает, что это окно является главным окном сборки
    FIsMainWindow: Boolean;
    function AddRemind(Remind: TRemind): Integer;
    function NewRemind(Title: WideString; DateTime: TDateTime): TRemind;
    procedure RefreshRemindListBox();
    function RemoteRemindByIndex(Index: Integer): Boolean;
  protected
      // Микроядро системы
    FCore: TAICore;
    procedure SetCore(Value: TAICore);
  public
    //** Добавить лог-сообщение
    function AddToLog(Msg: WideString): Integer; virtual;
    function CloseWindow(form: TForm): Boolean; virtual;
    function DoCommand(Cmd: WideString): Boolean; virtual;
    //** Срабатывает при уничтожении
    procedure DoDestroy(); override;
  public
    //ExitMenuItem: TMenuItem;
    //AddRemindMenuItem: TMenuItem;
    //AddTaskMenuItem: TMenuItem;
    //DelimerMenuItem2: TMenuItem;
    //AboutMenuItem: TMenuItem;
    //TrayPopup: TPopupActionBar;
    //ManagerAction: TAction;
  public
    function AddPage(const Name, Caption: String): AControl;
    procedure Init;
    //** Инициализировать
    procedure Initialize();
    //** Обновить кнопки открытых окон
    procedure RefreshChildTabs();
    procedure Save();
  public
    //** Микроядро системы
    property Core: TAICore read FCore write SetCore;
  public // Reminder
    {**
    Флаг, который указывает закрывать программу или сворачивать в трей.
    Флаг устанавливается при выборе "Выход" в контекстном меню.
    }
    property IsClose: Boolean read FIsClose write FIsClose;
    //** Флаг, который показывает, что это окно является главным окном сборки
    property IsMainWindow: Boolean read FIsMainWindow write FIsMainWindow;
  end;

const
  // Несколько пользователей программы
  IsMultiUser = False;

implementation

const
  dtMin = 1 / 24 / 60;
  dtSec = dtMin / 60;

{$R *.dfm}

{ TAssistantForm }

procedure TAssistantForm.AboutActionExecute(Sender: TObject);
var
  W: AWindow;
begin
  W := AUi_NewAboutDialog();
  AUi_InitAboutDialog2(W);
  AUiWindow_ShowModal(W);
  AUiWindow_Free(W);
end;

procedure TAssistantForm.CloseProjectActionExecute(Sender: TObject);
begin
  // Закрыть все открытые окна
  // ...

  // Подадим команду микроядру
  // ...
end;

procedure TAssistantForm.NewProjectActionExecute(Sender: TObject);
begin
  // ...
end;

procedure TAssistantForm.OpenProjectActionExecute(Sender: TObject);
begin
  // Закроем проект
  CloseProjectActionExecute(Sender);

  // Выберем файл
  // ...

  // Подадим команду микроядру
  // ...
end;

function TAssistantForm.AddPage(const Name, Caption: String): AControl;
var
  Page: TTabSheet;
begin
  Page := TTabSheet.Create(MainPageControl);
  Page.PageControl := MainPageControl;
  Page.Caption := Caption;
  Page.Name := Name;
  Result := AControl(Page);
end;

function TAssistantForm.AddRemind(Remind: TRemind): Integer;
begin
  Result := Length(FReminds);
  SetLength(FReminds, Result + 1);
  FReminds[Result] := Remind;
end;

procedure TAssistantForm.AddRemindActionExecute(Sender: TObject);
var
  fmRemind: TRemindEditForm;
  task: WideString;
begin
  fmRemind := TRemindEditForm.Create(Self);
  try
    fmRemind.DateTime := Now + 10 * dtMin;
    if fmRemind.ShowModal() = mrOK then
    begin
      task := fmRemind.edTask.Text;
      if (task <> '') then
      begin
        NewRemind(task, fmRemind.DateTime);
        RefreshRemindListBox();
        Save();
      end;
    end;
  except
  end;
  fmRemind.Free();
end;

function TAssistantForm.AddToLog(Msg: WideString): Integer;
begin
  Result := 0;
  if Assigned(FOnAddToLog) then
  try
    Result := FOnAddToLog(Msg);
  except
  end;
end;

procedure TAssistantForm.CommandButtonClick(Sender: TObject);
begin
  // ...
end;

procedure TAssistantForm.CommandComboBoxKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    Self.RunCommandSpeedButtonClick(nil);
end;

procedure TAssistantForm.CommandComboBoxKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
begin
  if Key = 13 then
    CommandComboBox.Text := '';
end;

procedure TAssistantForm.CloseActionExecute(Sender: TObject);
begin
  Hide();
end;

function TAssistantForm.CloseWindow(form: TForm): Boolean;
begin
  Result := False;
  if Assigned(form) then
  begin
    // Проверяем флаг главного окна
    if (form.Tag and $01 <> $01) then
    begin
      form.Free();
      RefreshChildTabs();
      Result := True;
    end;
  end;

  {if tcWindows.TabIndex = FTabReasoner then
  begin
    if Assigned(FReasonerForm) then
    begin
      FReasonerForm.Free();
      FReasonerForm := nil;
      tcWindows.Tabs.Delete(FTabReasoner);
    end;
  end
  else if tcWindows.TabIndex = FTabRules then
  begin
    if Assigned(FRules) then
    begin
      FRules.Free();
      FRules := nil;
      tcWindows.Tabs.Delete(FTabRules);
    end;
  end
  else if tcWindows.TabIndex = FTabLog then
  begin
    if Assigned(FLog) then
    begin
      FLog.Free();
      FLog := nil;
      tcWindows.Tabs.Delete(FTabLog);
    end;
  end;}
end;

function TAssistantForm.DoCommand(Cmd: WideString): Boolean;
var
  form: TForm;
begin
  Result := False;
  begin
    // Передаем команду активному дочернему окну
    form := ActiveMDIChild;
    if (form is TAIForm) then
    begin
      Result := TAIForm(form).AddCommand(cmd);
    end;

    if not(Result) and Assigned(FCore) then
    begin
      // Передаем команду микроядру на выполнение
      FCore.AddCommand(cmd);
      // ...
      Result := True;
    end;
  end;
end;

procedure TAssistantForm.DoDestroy();
var
  i: Integer;
  form: TForm;
begin
  inherited;

  Save();

  // Закрываем все дочерние окна
  for i := MDIChildCount - 1 downto 0 do
  begin
    form := MDIChildren[i];
    if Assigned(form) then
      form.Free();
  end;
end;

procedure TAssistantForm.ExitActionExecute(Sender: TObject);
begin
  FIsClose := True;
  Application.MainForm.Close();
end;

procedure TAssistantForm.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  // Завершать работу программы если IsClose=True или если главное окно не видимо
  CanClose := FIsClose or not(Visible);
  if not(FIsClose) then
    Hide()
  else
  begin
    if (Self <> Application.MainForm) then
      Application.MainForm.Close();
  end;
end;

procedure TAssistantForm.FormPaint(Sender: TObject);
begin
  // ...
end;

procedure TAssistantForm.Init;
var
  RichEditLog: TRichEditLog;
  p: TAssistantProgram;
  TasksControl: TATasksControlRec;
begin
  // Инициализируем настройки программы
  FSettings := TAssistantSettings.Create();
  FSettings.Title := Caption;
  TAssistantSettingsLoader.Load(FSettings, ExtractFilePath(ParamStr(0)) + 'Assistant.' + FILE_EXT_INI);
  if FSettings.Title <> '' then
    Caption := FSettings.Title;

  TasksControl.Parent := TaskTabSheet;
  TasksControl.TaskButtonPanel := AControl(TaskButtonPanel);
  TasksControl.TaskListBox := TaskListBox;
  AssistantTasksControl_Init2(TasksControl);

  // Загружаем данные из XML файлов
  Reminder_Load(FReminds, ExtractFilePath(ParamStr(0)) + 'Reminder.' + FILE_EXT_XML);
  RefreshRemindListBox();

  // Инициализируем контрол для элемента ввода команд
  FCommandComboBoxControl := TCommandComboBoxControl.Create();
  FCommandComboBoxControl.Control := CommandComboBox;
  FCommandComboBoxControl.OnCommand := CommandButtonClick;

  p := TAssistantProgram.GetInstance();

  if (p.IsDebug) then
  begin
    RichEditLog := TRichEditLog.Create();
    RichEditLog.RichEdit := LogRichEdit;
    p.LogJournal := RichEditLog;

    // Выполнить скрипт
    p.RunScript('LogJournal.AddToLog("Проверка AIL");');
  end;
end;

procedure TAssistantForm.Initialize();
begin
  if not(TAssistantProgram.GetInstance().IsDebug) then
  begin
    CommandComboBox.Visible := False;
    CommandButton.Visible := False;
    RunCommandSpeedButton.Visible := False;
    LogRichEdit.Visible := False;
    tcWindows.Hide();
  end;

  //tcWindows.Tabs.Clear();

  {FReasonerForm := TfmReasoner.Create(Self);
  FReasonerForm.OnClose := ChildFormClose;

  FTabReasoner := tcWindows.Tabs.Add('Reasoner');

  InitRules();
  InitLog();
  AddMsg('Создаем Reasoner');
  FReasoner := TAIWSReasoner.Create();
  AddMsg('Reasoner создан успешно');}

  RefreshChildTabs();
end;

procedure TAssistantForm.ManagerActionExecute(Sender: TObject);
begin
  Show();
end;

function TAssistantForm.NewRemind(Title: WideString; DateTime: TDateTime): TRemind;
begin
  Result := TRemind.Create();
  Result.Title := Title;
  Result.DateTime := DateTime;
  AddRemind(Result);
end;

procedure TAssistantForm.RefreshChildTabs();
var
  i: Integer;
  ii: Integer;
  c: Integer;
  form: TForm;
begin
  tcWindows.Tabs.Clear();
  ii := -1;
  c := MDIChildCount;
  for i := 0 to c - 1 do
  begin
    form := MDIChildren[i];
    tcWindows.Tabs.Add(form.Caption);
    if ActiveMDIChild = form then
      ii := i;
  end;
  tcWindows.TabIndex := ii;
end;

procedure TAssistantForm.RefreshRemindListBox();
var
  i: Integer;
begin
  RemindListBox.Clear();
  for i := 0 to High(FReminds) do
    RemindListBox.Items.Add(FReminds[i].Title + '=' + DateTimeToStr(FReminds[i].DateTime));
end;

procedure TAssistantForm.RemindListBoxDblClick(Sender: TObject);
var
  fmTask: TRemindEditForm;
  task: TRemind;
  index: Integer;
begin
  index := RemindListBox.ItemIndex;
  if (index >= 0) and (index < Length(FReminds)) then
  try
    task := FReminds[index];
    if not(Assigned(task)) then Exit;

    fmTask := TRemindEditForm.Create(Self);
    try
      fmTask.Task := task;
      if fmTask.ShowModal() = mrOK then
      begin
        RefreshRemindListBox();
      end;
    except
    end;
    fmTask.Free();
  except
  end;
end;

procedure TAssistantForm.RemoteTaskActionExecute(Sender: TObject);
begin
  AssistantTasksControl_RemoveTaskByIndex(TaskListBox.ItemIndex);
  AssistantTasksControl_RefreshTaskListBox();
end;

procedure TAssistantForm.RemoteRemindActionExecute(Sender: TObject);
begin
  RemoteRemindByIndex(RemindListBox.ItemIndex);
  RefreshRemindListBox();
  Save();
end;

function TAssistantForm.RemoteRemindByIndex(Index: Integer): Boolean;
var
  i: Integer;
begin
  Result := False;
  if (Index >= 0) and (Index < Length(FReminds)) then
  begin
    FReminds[Index] := nil;
    for i := Index to High(FReminds) - 1 do
      FReminds[i] := FReminds[i + 1];
    SetLength(FReminds, High(FReminds));
    Result := True;
  end;
end;

procedure TAssistantForm.RunCommandSpeedButtonClick(Sender: TObject);
var
  cmd: WideString;
begin
  cmd := CommandComboBox.Text;
  if CommandComboBox.ItemIndex < 0 then
    CommandComboBox.Items.Add(cmd);
  CommandComboBox.Text := '';
  if cmd = '' then Exit;
  AddToLog('--> ' + cmd);

  DoCommand(cmd);
end;

procedure TAssistantForm.Save();
begin
  // Сохраним данные в XML файл
  Reminder_Save(FReminds, FDataPath + 'Reminder.' + FILE_EXT_XML);
  AssistantTasksControl_Save();
end;

procedure TAssistantForm.SetCore(Value: TAICore);
begin
  FCore := Value;
  FOnAddToLog := TAICore(Value).AddLogMessage;
end;

procedure TAssistantForm.TaskListBoxDblClick(Sender: TObject);
begin
  AssistantTasksControl_ShowTask(TaskListBox.ItemIndex);
end;

procedure TAssistantForm.tcWindowsChange(Sender: TObject);
var
  i: Integer;
  name: WideString;
begin
  if (tcWindows.TabIndex >= 0) and (tcWindows.TabIndex < Self.MDIChildCount) then
  begin
    name := tcWindows.Tabs.Strings[tcWindows.TabIndex];
    for i := 0 to Self.MDIChildCount - 1 do
      if Self.MDIChildren[i].Caption = name then
        Self.MDIChildren[i].Show();
  end;
end;

procedure TAssistantForm.tcWindowsMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  {if tcWindows.TabIndex = FTabReasoner then
  begin
    if Assigned(FReasoner) then
      FReasonerForm.Show();
  end
  else if tcWindows.TabIndex = FTabRules then
  begin
    if Assigned(FRules) then
      FRules.Show();
  end
  else if tcWindows.TabIndex = FTabLog then
  begin
    if Assigned(FLog) then
      FLog.Show();
  end;
  // ...}
end;

procedure TAssistantForm.RemindTimerTimer(Sender: TObject);
var
  i: Integer;
  dt: TDateTime;
  dtNow: TDateTime;
  fmRemind: TRemindForm;
begin
  for i := 0 to RemindListBox.Count - 1 do
  begin
    dt := FReminds[i].DateTime;
    dtNow := Now();
    if (dt <= dtNow) then
    begin
      RemindTimer.Enabled := False;

      fmRemind := TRemindForm.Create(Self);
      fmRemind.Remind := FReminds[i];
      if fmRemind.ShowModal() = mrOk then
      begin
        Self.RemoteRemindByIndex(i);
      end;
      RefreshRemindListBox();
      RemindTimer.Enabled := True;
      Exit;
    end;
  end;
end;

end.
