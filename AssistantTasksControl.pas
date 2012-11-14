{**
@Abstract Главное окно управления заданиями
@Author Prof1983 <prof1983@ya.ru>
@Created 04.06.2005
@LastMod 14.11.2012

Работает с фреймами заданий и вопросов типа XML.
Описание структуры данных фрейма задания:
<?xml version="1.0"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
</xsl:stylesheet>
}
unit AssistantTasksControl;

interface

uses
  Buttons, Controls, {ExtCtrls,} StdCtrls,
  ABase, AConsts2, AControlImpl, AUtils, ASystem, ATaskForm, ATypes,
  AUiBase, AUiButtons, AUiControls,
  AiTaskListImpl, AiTaskLoader, AiTaskSaver,
  AssistantTasks;

type
  TATasksControlRec = record
    Parent: TWinControl;
    TaskButtonPanel: AControl{TPanel};
    AddTaskButton: AControl{TBitBtn};
    TaskListBox: TListBox;
  end;

function AssistantTasksControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr): AError;

function AssistantTasksControl_Init2(var TasksControl: TATasksControlRec): AError;

function AssistantTasksControl_RefreshTaskListBox(): AError;

function AssistantTasksControl_RemoveTaskByIndex(Index: AInt): AError;

function AssistantTasksControl_Save(): AError;

function AssistantTasksControl_ShowTask(Index: AInt): AError;

implementation

type
  TATasksControl = class(TAControl)
  private
    lbTasks: TListBox;
//    sbNew: TSpeedButton;
//    sbDelete: TSpeedButton;
//    sbEdit: TSpeedButton;
//    sbOk: TSpeedButton;
//    sbHour: TSpeedButton;
//    sbDay: TSpeedButton;
//    miTask: TMenuItem;
//    miTaskNew: TMenuItem;
//    miTaskEdit: TMenuItem;
//    miTaskRun: TMenuItem;
//    miTaskStop: TMenuItem;
//    miTaskResult: TMenuItem;
//    miQuestion: TMenuItem;
//    miQuestionNew: TMenuItem;
//    miQuestionEdit: TMenuItem;
//    miQuestionRun: TMenuItem;
//    miQuestionStop: TMenuItem;
//    miQuestionResult: TMenuItem;
  private
    //** Список заданий
    FTaskList: TAiTaskList3;
  protected
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
  FTasksControlRec: TATasksControlRec;

// --- Events ---

function AddTaskButtonClick(Obj, Data: AInt): AError; stdcall;
var
  TaskForm: TTaskForm;
begin
  try
    TaskForm := TTaskForm.Create(nil);
    if (TaskForm.ShowModal() = mrOK) then
    begin
      AssistantTasks_NewTask(TaskForm.TitleEdit.Text, TaskForm.CommentMemo.Text);
      Result := 0;
      AssistantTasksControl_RefreshTaskListBox();
    end
    else
      Result := 1;
    TaskForm.Free();
  except
    Result := -1;
  end;
end;

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
  Result := 0;
end;

function AssistantTasksControl_Init2(var TasksControl: TATasksControlRec): AError;
begin
  TasksControl.AddTaskButton := AUiButton_New(TasksControl.TaskButtonPanel);
  AUiControl_SetTextP(TasksControl.AddTaskButton, 'Добавить');
  AUiButton_LoadGlyphP(TasksControl.AddTaskButton, AUtils.ExpandFileNameP('..\Resources\Plus.bmp'));
  AUiControl_SetOnClick(TasksControl.AddTaskButton, AddTaskButtonClick);
  AUiControl_SetSize(TasksControl.AddTaskButton, 76, 24);
  AUiControl_SetPosition(TasksControl.AddTaskButton, 6, 8);

  FTasksControlRec := TasksControl;

  TTaskLoader.Load(FTasks, ASystem.GetDataDirectoryPathWS() + 'Tasks.' + FILE_EXT_XML);

  AssistantTasksControl_RefreshTaskListBox();

  Result := 0;
end;

function AssistantTasksControl_RefreshTaskListBox(): AError;
var
  I: Integer;
begin
  try
    FTasksControlRec.TaskListBox.Clear();
    for i := 0 to High(FTasks) do
      FTasksControlRec.TaskListBox.Items.Add(FTasks[i].Title + ' - ' + FTasks[i].Comment);
    Result := 0;
  except
    Result := -1;
  end;
end;

function AssistantTasksControl_RemoveTaskByIndex(Index: AInt): AError;
var
  I: Integer;
begin
  Result := -1;
  if (Index >= 0) and (Index < Length(FTasks)) then
  begin
    FTasks[Index] := nil;
    for i := Index to High(FTasks) - 1 do
      FTasks[i] := FTasks[i + 1];
    SetLength(FTasks, High(FTasks));
    Result := 0;
  end;
end;

function AssistantTasksControl_Save(): AError;
begin
  TTaskSaver.Save(FTasks, ASystem.GetDataDirectoryPathWS() + 'Tasks.' + FILE_EXT_XML);
  Result := 0;
end;

function AssistantTasksControl_ShowTask(Index: AInt): AError;
var
  TaskForm: TTaskForm;
begin
  if (Index >= 0) and (Index < Length(FTasks)) then
  try
    TaskForm := TTaskForm.Create(nil);
    TaskForm.Task := FTasks[Index];
    if (TaskForm.ShowModal() = mrOK) then
    begin
      AssistantTasksControl_RefreshTaskListBox();
      Result := 0;
    end
    else
      Result := 1;
    TaskForm.Free();
  except
    Result := -1;
  end;
end;

{ TATasksControl }

procedure TATasksControl.DoDestroy();
begin
  if Assigned(FTaskList) then
  try
    FTaskList.Finalize();
    FTaskList.Free();
    FTaskList := nil;
  except
  end;
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
