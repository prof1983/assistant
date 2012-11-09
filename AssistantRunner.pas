{**
@Abstract Assistant runner
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012
}
unit AssistantRunner;

interface

uses
  AssistantActionTree, AssistantEnviromentObj, AssistantReasoner, AssistantSheduler;

type //** Выполняет действия одного подпроцесса
  TRunner = class
  private
      //** Дерево последовательности действий (дерево решений)
    FActionTree: TActionTree;
    FEnviroment: TAssistantEnviroment;
      //** Машина логического вывода
    FReasoner: TReasoner;
      //** Планировщик действий (для построения дерева дейсивий)
    FSheduler: TSheduler;
    //FThread: TThread;
  public
      //** Восстановить последнее состояние которое было перед выполнением команды Suspend
    procedure Resume();
  public
      //** Дерево последовательности действий (дерево решений)
    property ActionTree: TActionTree read FActionTree write FActionTree;
    //property Code: TAilCode read FCode write FCode;
    property Enviroment: TAssistantEnviroment read FEnviroment write FEnviroment;
      //** Машина логического вывода
    property Reasoner: TReasoner read FReasoner write FReasoner;
      //** Планировщик действий (для построения дерева дейсивий)
    property Sheduler: TSheduler read FSheduler write FSheduler;
  end;

implementation

{ TRunner }

procedure TRunner.Resume();
begin
  // ...
end;

end.
