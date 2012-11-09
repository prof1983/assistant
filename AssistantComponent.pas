{**
@Abstract Assistant component
@Author Prof1983 <prof1983@ya.ru>
@Created 11.08.2007
@LastMod 05.05.2012
}
unit AssistantComponent;

interface

uses
  AssistantOntology;

type
  TAssistantComponent = class
  public
    Name: WideString;
    Ontology: TAssistantOntology;
  end;

implementation

end.
