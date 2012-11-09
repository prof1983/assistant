{**
@Abstract Module info
@Author Prof1983 <prof1983@ya.ru>
@Created 04.08.2007
@LastMod 05.05.2012
}
unit ModuleInfoRec;

interface

type
  TModuleInfo = record
    ModuleID: TGuid;
    ModuleVersion: Integer;
    ModuleShortName: WideString;
    ModuleFullName: WideString;
    ModuleTitle: WideString;
    ModuleDescription: WideString;
    Author: WideString;
    Copyright: WideString;
    OtherInfo: WideString;
  end;

type
  TModuleInfo2 = packed record
    ModuleID: TGuid;
    ModuleVersion: Integer;
    ModuleShortName: WideString;
    ModuleFullName: WideString;
    ModuleTitle: WideString;
    ModuleDescription: WideString;
    Author: WideString;
    Copyright: WideString;
    OtherInfo: WideString;
  end;

type
  PModuleInfoRec = ^TModuleInfoRec;
  TModuleInfoRec = packed record
    ModuleID: TGuid;               // ['{67B2882A-B25C-4823-84B0-0562728F32D6}']
    ModuleVersion: Integer;        // 13
    ModuleShortName: PWideString;  // Core
    ModuleFullName: PWideString;   // org.aikernel
    ModuleTitle: PWideString;      // Assistant
    ModuleDescription: PWideString;// This is micro core of the AReason system.
    Author: PWideString;           // Prof1983 <prof1983@ya.ru>
    Copyright: PWideString;        // (c) AiKernel.org 2010-2012
    OtherInfo: PWideString;
      // <?xml version="1.0"?>
      // <ModuleInfo>
      //   <Requests>
      //     <Module ID="XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX" MinVersion="0.0" MaxVersion="0.1"/>
      //   </Requests>
      // </ModuleInfo>
  end;

implementation

end.
