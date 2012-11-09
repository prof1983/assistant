{**
@Abstract Assistant engine
@Author Prof1983 <prof1983@ya.ru>
@Created 15.08.2007
@LastMod 16.03.2012
}
unit AssistantEngine;

interface

uses
  AssistantEnviromentObj, AssistantVirtualMachine;

type
  TAssistantEngine = class
  private
      //** Среда обитания агентов
    FEnviroment: TAssistantEnviroment;
      //** Виртуальная машина функционирования среды для агентов
    FVirtualMachine: TAssistantVirtualMachine;
  public
    procedure Initialize();
  public
      //** Среда обитания агентов
    property Enviroment: TAssistantEnviroment read FEnviroment;
      //** Виртуальная машина функционирования среды для агентов
    property VirtualMachine: TAssistantVirtualMachine read FVirtualMachine;
  end;

implementation

{ TAssistantEngine }

procedure TAssistantEngine.Initialize();
begin
  //TStartForm.AddToLog('Инициализация виртуальной машины (VirtualMachine)');
  // Создать виртуальную машину
  FVirtualMachine := TAssistantVirtualMachine.Create();

  //TStartForm.AddToLog('Инициализация виртуальной среды (Enviroment)');
  FEnviroment := TAssistantEnviroment.Create();
  FVirtualMachine.Enviroment := FEnviroment;
end;

end.
