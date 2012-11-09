{**
@Abstract Assistant Ontology
@Author Prof1983 <prof1983@ya.ru>
@Created 11.08.2007
@LastMod 05.05.2012
}
unit AssistantOntology;

interface

uses
  AilNamespace;

type
  TAssistantOntology = class
  public
    Description: WideString; // Comment
    Name: WideString;
    Namespace: TAilNamespace;
    //PriorVersion: WideString;
    Title: WideString; // Label
  end;

implementation

end.
