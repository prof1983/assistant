{**
@Abstract Assistant action tree
@Author Prof1983 <prof1983@ya.ru>
@Created 14.08.2007
@LastMod 16.03.2012
}
unit AssistantActionTree;

interface

uses
  AilCode;

type //** Действие
  TAction = class
  private
      //** Выполняемый код
    FCode: TAilCode;
  public
      //** Выполняемый код
    property Code: TAilCode read FCode write FCode;
  end;

type //** Узел действия
  TActionNode = class
  private
    // Список изменения параметров которые произойдут, если выполнить это действие
    //FChanges:
    // Возможные варианты дальнейших действий
    //FChildActions:
    // Необходимые условия для выполнения этого действия
    //FConditions:
    // Другие параметры (например время выполнения)
    // ...
    // Само действие
    //FAction
  end;

type //** Дерево последовательности действий (дерево решений)
  TActionTree = class
  private
    FRoot: TActionNode;
  public
    property Root: TActionNode read FRoot;
  end;

implementation

end.
