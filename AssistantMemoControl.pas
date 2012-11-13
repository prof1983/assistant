{**
@Abstract Assistant memo control
@Author Prof1983 <prof1983@ya.ru>
@Created 13.11.2012
@LastMod 13.11.2012
}
unit AssistantMemoControl;

interface

uses
  Controls,
  ABase, AMemoControl, ATypes;

function AssistantMemoControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr): AError;

function AssistantMemoControl_LoadFromFileP(const FileName: APascalString): AError;

implementation

var
  FMemoControl: TAMemoControl;

function AssistantMemoControl_Init(ts: TWinControl; OnSendMessage: TProcMessageStr): AError;
begin
  try
    FMemoControl := TAMemoControl.Create();
    FMemoControl.Control := ts;
    FMemoControl.OnSendMessage := OnSendMessage;
    FMemoControl.Initialize();
    Result := 0;
  except
    Result := -1;
  end;
end;

function AssistantMemoControl_LoadFromFileP(const FileName: APascalString): AError;
begin
  try
    FMemoControl.LoadFromFile(FileName);
    Result := 0;
  except
    Result := -1;
  end;
end;

end.
