{**
@Abstract  онтрол дл€ получени€ новостей о работе
@Author Prof1983 <prof1983@ya.ru>
@Created 12.04.2007
@LastMod 13.11.2012
}
unit AssistantWorkControl;

interface

uses
  Controls,
  ABase, AWorkControl;

function AssistantWorkControl_Init(ts: TWinControl): AError;

implementation

var
  {**  онтрол получени€ заданий и управлени€ задани€ми }
  FWorkControl: TWorkControl;

function AssistantWorkControl_Init(ts: TWinControl): AError;
begin
  try
    FWorkControl := TWorkControl.Create();
    FWorkControl.Control := ts;
    FWorkControl.Initialize();
    Result := 0;
  except
    Result := -1;
  end;
end;

end.
