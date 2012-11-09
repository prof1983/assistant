{**
@Abstract Assistant boot
@Author Prof1983 <prof1983@ya.ru>
@Created 19.07.2011
@LastMod 17.08.2012
}
unit AssistantBoot;

interface

uses
  AssistantApp;

procedure Assistant_Boot();

implementation

procedure Assistant_Boot();
begin
  AssistantApp_Init();
  AssistantApp_Run();
  AssistantApp_Fin();
end;

end.
