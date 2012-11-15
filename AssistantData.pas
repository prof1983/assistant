{**
@Abstract Assistant data
@Author Prof1983 <prof1983@ya.ru>
@Created 15.11.2012
@LastMod 15.11.2012
}
unit AssistantData;

interface

uses
  ABase;

var
  {** Флаг, который указывает закрывать программу или сворачивать в трей
      Флаг устанавливается при выборе "Выход" в контекстном меню. }
  Assistant_IsClose: ABoolean;
  Assistant_OnExit: AProc;

implementation

end.
