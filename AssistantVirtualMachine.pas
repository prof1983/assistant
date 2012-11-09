{**
@Abstract Agent Virtual Mashine / Assistant Virtual Mashine (AVM)
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012

Agent Virtual Mashine / Assistant Virtual Mashine (AVM)
Виртуальная машина
}
unit AssistantVirtualMachine;

interface

uses
  AssistantEnviromentObj, AssistantRunner;

type //** Виртуальная машина реализующая работу подпроцессов
  TAssistantVirtualMachine = class
  private
      //** Окружающая среда для агентов
    FEnviroment: TAssistantEnviroment;
    {**
      Исполнители кода. Создается один исполнитель для каждого подпроцесса
      (в одном агенте существует как минимум один подпроцесс)
    }
    FRunners: array of TRunner;
  public
    function AddRunner(Runner: TRunner): Integer;
    procedure Start();
  public
      //** Окружающая среда для агентов
    property Enviroment: TAssistantEnviroment read FEnviroment write FEnviroment;
  end;

implementation

{ TAssistantVirtualMachine }

function TAssistantVirtualMachine.AddRunner(Runner: TRunner): Integer;
begin
  Result := Length(FRunners);
  SetLength(FRunners, Result + 1);
  FRunners[Result] := Runner;
end;

procedure TAssistantVirtualMachine.Start();
var
  i: Integer;
begin
  // Восстанавливаем состояние всех процессов
  for i := 0 to High(FRunners) do
    FRunners[i].Resume();
end;

end.
