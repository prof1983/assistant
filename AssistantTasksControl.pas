{**
@Abstract Главное окно управления заданиями
@Author Prof1983 <prof1983@ya.ru>
@Created 04.06.2005
@LastMod 13.11.2012

Работает с фреймами заданий и вопросов типа XML.
Описание структуры данных фрейма задания:
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
</xsl:stylesheet>
}
unit AssistantTasksControl;

interface

uses
  Buttons, Controls, StdCtrls,
  ABase, AControlImpl, ATypes,
  AiTaskListImpl;

function AssistantTasksControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr): AError;

implementation

type
  TATasksControl = class(TAControl)
  private
    lbTasks: TListBox;
    //Panel1: TPanel;
//    sbNew: TSpeedButton;
//    sbDelete: TSpeedButton;
//    sbEdit: TSpeedButton;
//    sbOk: TSpeedButton;
//    sbHour: TSpeedButton;
//    sbDay: TSpeedButton;

//    mmMain: TMainMenu;
    //miCore: TMenuItem;
    //miCoreConnect: TMenuItem;
    //miCoreDisconnect: TMenuItem;
    //miLog: TMenuItem;
    //miLogConnect: TMenuItem;
    //miLogDisconnect: TMenuItem;
    //miKB: TMenuItem;
    //miKBConnect: TMenuItem;
    //miKBDisconnect: TMenuItem;
    //miSource: TMenuItem;
    //miSourceOpen: TMenuItem;
    //miSourceClose: TMenuItem;
//    miTask: TMenuItem;
//    miTaskNew: TMenuItem;
//    miTaskEdit: TMenuItem;
    //N1: TMenuItem;
//    miTaskRun: TMenuItem;
//    miTaskStop: TMenuItem;
//    miTaskResult: TMenuItem;
    //N2: TMenuItem;
//    miQuestion: TMenuItem;
//    miQuestionNew: TMenuItem;
//    miQuestionEdit: TMenuItem;
    //N3: TMenuItem;
//    miQuestionRun: TMenuItem;
//    miQuestionStop: TMenuItem;
    //N4: TMenuItem;
//    miQuestionResult: TMenuItem;
    //miHelp: TMenuItem;
    //miAbout: TMenuItem;
    //ActionList1: TActionList;
    //acTaskEdit: TAction;
    //miRegister: TMenuItem;
    //miUnregister: TMenuItem;
  private
    //** Список заданий
    FTaskList: TAITaskList3;
  protected
    //** Срабатывает при создании
    procedure DoCreate(); override;
    //** Срабатывает при уничтожении
    procedure DoDestroy(); override;
    //** Срабатывает при инициализации
    function DoInitialize(): TProfError; override; safecall;
  public
    //** Обновить список заданий
    procedure Refresh();
  public
    //** Список заданий
    property TaskList: TAITaskList3 read FTaskList write FTaskList;
  end;

var
  {** Контрол для заданий }
  FTasksControl: TATasksControl;

// --- Public ---

function AssistantTasksControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr): AError;
begin
  {// Контрол заданий
  tsTasks := TTabSheet(AddTabMessage(tmsgUncnown, 'Tasks'));
  FTasksControl := TAITasksControl.Create();
  FTasksControl.Control := tsTasks;
  FTasksControl.OnMessageAdd := DoTaskAdd;
  FTasksControl.OnAddToLog := AddToLog;
  FTasksControl.Initialize();}

  try
    FTasksControl := TATasksControl.Create();
    FTasksControl.Control := ts;
    FTasksControl.OnSendMessage := OnSendMessage;
    FTasksControl.Initialize();
  except
    FTasksControl := nil;
  end;
end;

{ TATasksControl }

procedure TATasksControl.DoCreate();
begin
  inherited DoCreate();
  //Caption := 'Управление заданиями';
  //miCore.Caption := 'Ядро';
  //miCoreConnect.Caption := 'Соединиться';
  //miCoreDisconnect.Caption := 'Разъединиться';
end;

procedure TATasksControl.DoDestroy();
begin
  if Assigned(FTaskList) then
  try
    FTaskList.Finalize();
    FTaskList.Free();
    FTaskList := nil;
  except
  end;

//  FProgram.Save();
//  //Save();
//
//  if Assigned(FProgram) then
//  try
//    FProgram.Free();
//  finally
//    FProgram := nil;
//  end;
  inherited DoDestroy();
end;

function TATasksControl.DoInitialize(): TProfError;
begin
  lbTasks := TListBox.Create(FControl);
  lbTasks.Parent := FControl;
  lbTasks.Align := alClient;

  if not(Assigned(FTaskList)) then
    FTaskList := TAITaskList3.Create();
  Refresh();
end;

procedure TATasksControl.Refresh();
var
  I: Int32;
  Index: Int32;
begin
  Index := lbTasks.ItemIndex;
  lbTasks.Clear();
  for I := 0 to FTaskList.TaskCount - 1 do
  begin
    lbTasks.Items.Add(FTaskList.TaskByIndex[I].Title);
  end;
  lbTasks.ItemIndex := Index;
end;

{procedure TfmTasks.sbDayClick(Sender: TObject);
var
  I: Int32;
begin
  I := ListBox1.ItemIndex;
  FTaskList.TaskByIndex[I].DateTimeEnd := FTaskList.TaskByIndex[I].DateTimeEnd + DateTimeDay;
  Refresh();
end;}

{procedure TfmTasks.sbDeleteClick(Sender: TObject);
var
  Index: Int32;
begin
  Index := ListBox1.ItemIndex;
  FTaskList.DeleteTask(Index);
  Refresh();
end;}

{procedure TfmTasks.sbEditClick(Sender: TObject);
begin
  acTaskEditExecute(Self);
end;}

{procedure TfmTasks.sbHourClick(Sender: TObject);
var
  I: Int32;
begin
  I := ListBox1.ItemIndex;
  FTaskList.TaskByIndex[I].DateTimeEnd := FTaskList.TaskByIndex[I].DateTimeEnd + DateTimeHour;
  Refresh();
end;}

{procedure TfmTasks.sbNewClick(Sender: TObject);
var
  fmTask: TfmTask;
  Task: TAITask;
begin
  fmTask := TfmTask.Create(Self);
  try
    fmTask.Clear();
    if fmTask.ShowModal = mrOk then
    begin
      Task := TAITask.Create();
      fmTask.SaveToTask(Task);
      FTaskList.AddTask(Task);
      Refresh();
    end;
  finally
    fmTask.Free();
  end;
end;}

end.
