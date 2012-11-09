{**
@Abstract Класс для сохранения данных в XML файл
@Author Prof1983 <prof1983@ya.ru>
@Created 15.07.2007
@LastMod 05.05.2012
}
unit AssistantDataSaver;

interface

//uses
  //Classes, Dialogs,
  //cUnicodeCodecs, {LangUtils,} {WideStringUtils,} UriUtils, Xdom_4_1;

type //** @abstract(Класс для сохранения данных в XML файл)
  TAssistantDataSaver = class
  public
    class function Save(FileName: WideString): Boolean;
  end;

implementation

{ TAssistantDataSaver }

class function TAssistantDataSaver.Save(FileName: WideString): Boolean;
{var
  DomDocument: TDomDocument;
  DomImplementation: TDomImplementation;
  XmlDomBuilder: TXmlDomBuilder;
  MStream: TMemoryStream;
  XmlStandardDocReader: TXmlStandardDocReader;
  XmlInputSource: TXmlInputSource;
  S: string;
  XmlStandardDocReader1: TXmlStandardDocReader;
  XmlWFTestHandler1: TXmlWFTestHandler;
  XmlDistributor1: TXmlDistributor;
  XmlStandardDomReader1: TXmlStandardDomReader;
  XmlStandardHandler: TXmlStandardHandler;
  DomToXmlParser: TDomToXmlParser;
  ResResolver: TStandardResourceResolver;}
begin
(*
  XmlDistributor1 := TXmlDistributor.Create(nil);
  {
    NextHandlers = <
      item
        XmlHandler = XmlDomBuilder1
      end
      item
        XmlHandler = XmlStandardHandler1
      end>
    Left = 128
    Top = 128
    NextHandlers = <
      item
        XmlHandler = XmlDomBuilder1
      end
      item
        XmlHandler = XmlStandardHandler1
      end>
  }

  XmlWFTestHandler1 := TXmlWFTestHandler.Create(nil);
  XmlWFTestHandler1.NextHandler := XmlDistributor1;

  XmlStandardDocReader1 := TXmlStandardDocReader.Create(nil);
  XmlStandardDocReader1.DOMImpl := DomImplementation;
  //XmlStandardDocReader1.NextHandler := XmlWFTestHandler1;

  DomImplementation := TDomImplementation.Create(nil);
  DomImplementation.ResourceResolver := ResResolver;
//  DomImplementation.OnError := DomImplementationError;

  XmlStandardDomReader1 := TXmlStandardDomReader.Create(nil);
  XmlStandardDomReader1.DOMImpl := DomImplementation;
//  XmlStandardDomReader1.NextHandler := XmlNamespaceSignalGenerator1;
  XmlStandardDomReader1.IgnoreUnspecified := False;

  XmlStandardHandler := TXmlStandardHandler.Create(nil);
  //XmlStandardHandler.OnSignal = XmlStandardHandlerSignal;

  DomToXmlParser := TDomToXmlParser.Create(nil);
  DomToXmlParser.DOMImpl := DomImplementation;
  DomToXmlParser.IgnoreUnspecified := True;

  ResResolver := TStandardResourceResolver.Create(nil);

  XmlDomBuilder := TXmlDomBuilder.Create(nil);

  {object XmlDomBuilder2: TXmlDomBuilder
    Left = 456
    Top = 144
  end}

  {object XmlNamespaceSignalGenerator1: TXmlNamespaceSignalGenerator
    NextHandler = XmlDomBuilder2
    Left = 424
    Top = 144
  end}


  //DomImplementation := TDomImplementation.Create(nil);

  //DomToXmlParser := TDomToXmlParser.Create(nil);
  //DomToXmlParser.DOMImpl := DomImplementation;

  //DomDocument := TDomDocument.Create(DomImplementation);
  //DomDocument.XmlEncoding := 'Windows-1251';
  //DomDocument.XmlVersion := '1.0';

  //XmlDomBuilder := TXmlDomBuilder.Create(nil);
  //XmlDomBuilder.ReferenceNode := DomDocument;

  MStream := TMemoryStream.Create();
  MStream.LoadFromFile(FileName);

  XmlInputSource := TXmlInputSource.Create(MStream, '',
    FilenameToUriStr(FileName, []), 4096, TUnicodeCodecClass(nil),
    True, 0, 0, 0, 0, 1);

  XmlStandardDocReader := TXmlStandardDocReader.Create(nil);
  XmlStandardDocReader.DOMImpl := DomImplementation;
  Result := XmlStandardDocReader.Parse(XmlInputSource);

  DomImplementation1 := DomImplementation;

  //ShowMessage(DomDocument.TextContent);

  //DomToXmlParser.WriteToString(DomDocument, 'Latin1', S);
  //ShowMessage(S);
*)
  Result := False;
end;

end.
