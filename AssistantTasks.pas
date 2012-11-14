{**
@Abstract Assistant tasks
@Author Prof1983 <prof1983@ya.ru>
@Created 05.05.2012
@LastMod 14.11.2012
}
unit AssistantTasks;

interface

uses
  ABase, ATaskObj;

function AssistantTasks_AddTask(Task: TATask): AInt;

function AssistantTasks_NewTask(const Title, Comment: APascalString): TATask;

// --- Private ---

var
  //** Список заданий
  FTasks: TATasks;

implementation

function AssistantTasks_AddTask(Task: TATask): AInt;
begin
  Result := Length(FTasks);
  SetLength(FTasks, Result + 1);
  FTasks[Result] := Task;
end;

function AssistantTasks_NewTask(const Title, Comment: APascalString): TATask;
begin
  Result := TATask.Create();
  Result.Title := Title;
  Result.Comment := Comment;
  AssistantTasks_AddTask(Result);
end;

end.
