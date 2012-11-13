{**
@Abstract Контрол команд
@Author Prof1983 <prof1983@ya.ru>
@Created 28.10.2006
@LastMod 13.11.2012
}
unit AssistantCommandsControl;

interface

uses
  ComCtrls,
  ABase, AMemoControl;

function AssistantCommandsControl_Init(tsCommands: TTabSheet): AError;

implementation

type // Контрол команд
  TACommandsControl = TAMemoControl;

var
  FCommandsControl: TACommandsControl;

function AssistantCommandsControl_Init(tsCommands: TTabSheet): AError;
begin
  FCommandsControl := TACommandsControl.Create();
  FCommandsControl.Control := tsCommands;
  FCommandsControl.Initialize();
end;

end.
