{**
@Abstract Personal assistant
@Author Prof1983 <prof1983@ya.ru>
@Created 03.07.2007
@LastMod 12.11.2012
}
program Assistant;

uses
  AssistantBoot in '..\AssistantBoot.pas',
  ArMessages in '..\..\Ar\Common\ArMessages.pas';

{$R *.res}

begin
  Assistant_Boot();
end.
