{**
@Abstract Agent Enviroment
@Author Prof1983 <prof1983@ya.ru>
@Created 11.08.2007
@LastMod 16.03.2012

Agent Enviroment / Assistant Enviroment (AE)
Оркужение / окружающая среда
Окружающая среда для функционирования агентов
}
unit AssistantEnviromentObj;

interface

uses
  AssistantComponent;

type
  TAssistantEnviroment = class
  private
    FComponents: array of TAssistantComponent;
    FName: WideString;
    function GetComponentByIndex(Index: Integer): TAssistantComponent;
    function GetComponentByName(Name: WideString): TAssistantComponent;
  public
    function AddComponent(Component: TAssistantComponent): Integer;
  public
    property ComponentByIndex[Index: Integer]: TAssistantComponent read GetComponentByIndex;
    property ComponentByName[Name: WideString]: TAssistantComponent read GetComponentByName;
    property Name: WideString read FName write FName;
  end;

implementation

{ TAssistantEnviroment }

function TAssistantEnviroment.AddComponent(Component: TAssistantComponent): Integer;
begin
  Result := Length(FComponents);
  SetLength(FComponents, Result + 1);
  FComponents[Result] := Component;
end;

function TAssistantEnviroment.GetComponentByIndex(Index: Integer): TAssistantComponent;
begin
  if (Index >= 0) and (Index < Length(FComponents)) then
    Result := FComponents[Index]
  else
    Result := nil;
end;

function TAssistantEnviroment.GetComponentByName(Name: WideString): TAssistantComponent;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(FComponents) do
    if (FComponents[i].Name = Name) then
    begin
      Result := FComponents[i];
      Exit;
    end;
end;

end.
