{**
@Abstract Assistant settings
@Author Prof1983 <prof1983@ya.ru>
@Created 29.06.2007
@LastMod 16.03.2012

Настройки программы Assistant
}
unit AssistantSettings;

interface

uses
  AiBase;

type //** @abstract(Настройки программы Asssitant)
  TAssistantSettings = class
  private
    //** Идентификатор для заданий. Применяется в Pool.
    FTaskTypeID: TAId;
    //** Заголовок окна
    FTitle: WideString;
  public // Секция "General"
    //** Идентификатор для заданий. Применяется в Pool.
    property TaskTypeID: TAIID read FTaskTypeID write FTaskTypeID;
    //** Заголовок окна
    property Title: WideString read FTitle write FTitle;
  end;

implementation

end.
