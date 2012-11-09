{**
@Abstract Главный класс программы Assistant
@Author Prof1983 <prof1983@ya.ru>
@Created 05.07.2007
@LastMod 16.03.2012
}
unit AssistantModule;

interface

uses
  Windows,
  AssistantGlobals, ModuleInfoRec;

type
  TGetModuleInfoProc = function(ModuleInfo: PModuleInfoRec): Integer; stdcall;
  TInitializeModuleProc = function(LacalID: Integer; SystemProc: TSystemProc): Integer; stdcall;
  TFinalizeModuleProc = function(): Integer; stdcall;
  TRunModuleProc = function(): Integer; stdcall;
  TTerminateModuleProc = function(): Integer; stdcall;

type
  TAssistantModule = class
  private
    FHandle: Integer;
    FFileName: WideString;
    FModuleInfo: TModuleInfo;
  private
    FGetModuleInfoProc: TGetModuleInfoProc;
    FFinalizeModuleProc: TFinalizeModuleProc;
    FInitializeModuleProc: TInitializeModuleProc;
    FRunModuleProc: TRunModuleProc;
    FTerminateModuleProc: TTerminateModuleProc;
  public
    function FinalizeModule(): Integer;
    function InitializeModule(LocalID: Integer; SystemProc: TSystemProc): Integer;
    function RunModule(): Integer;
    function TerminateModule(): Integer;
  public
    constructor Create(FileName: WideString); overload;
    constructor Create(Handle: Integer; FileName: WideString); overload;
    class function CheckModule(FileName: WideString; var ModuleInfo: TModuleInfo): Integer;
    class procedure ModuleInfoFromRec(ModuleInfoRec: TModuleInfoRec; var ModuleInfo: TModuleInfo);
    procedure ToModuleInfo2(var ModuleInfo: TModuleInfo2);
  public
    property Handle: Integer read FHandle;
    property FileName: WideString read FFileName write FFileName;
  end;

implementation

{ TModule }

class function TAssistantModule.CheckModule(FileName: WideString; var ModuleInfo: TModuleInfo): Integer;
var
  GetModuleInfoProc: TGetModuleInfoProc;
  FinalizeModuleProc: TFinalizeModuleProc;
  InitializeModuleProc: TInitializeModuleProc;
  RunModuleProc: TRunModuleProc;
  TerminateModuleProc: TTerminateModuleProc;
  ModuleInfo2: TModuleInfoRec;
  hModule: Integer;
begin
  Result := -1;
  hModule := LoadLibrary(PChar(string(FileName)));
  if hModule <= 0 then Exit;

  GetModuleInfoProc := GetProcAddress(hModule, 'GetModuleInfo');
  FinalizeModuleProc := GetProcAddress(hModule, 'FinalizeModule');
  InitializeModuleProc := GetProcAddress(hModule, 'InitializeModule');
  RunModuleProc := GetProcAddress(hModule, 'LoadModule');
  TerminateModuleProc := GetProcAddress(hModule, 'UnLoadModule');

  if not(Assigned(GetModuleInfoProc)) or not(Assigned(FinalizeModuleProc)) or
     not(Assigned(InitializeModuleProc)) or not(Assigned(RunModuleProc)) or
     not(Assigned(TerminateModuleProc)) then
  begin
    Result := -2;
    FreeLibrary(hModule);
    Exit;
  end;

  try
    if GetModuleInfoProc(@ModuleInfo2) <> 0 then
    begin
      Result := -4;
      FreeLibrary(hModule);
      Exit;
    end;

    ModuleInfoFromRec(ModuleInfo2, ModuleInfo);

    {
    AddToLog('  ModuleID: ' + GuidToString(ModuleInfo.ModuleID));
    AddToLog('  ModuleVersion: ' + IntToStr(ModuleInfo.ModuleVersion));
    AddToLog('  ModuleShortName: ' + string(WideString(ModuleInfo.ModuleShortName^)));
    AddToLog('  ModuleFullName: ' + string(WideString(ModuleInfo.ModuleFullName^)));
    AddToLog('  ModuleTitle: ' + string(WideString(ModuleInfo.ModuleTitle^)));
    AddToLog('  ModuleDescription: ' + string(WideString(ModuleInfo.ModuleDescription^)));
    AddToLog('  Author: ' + string(WideString(ModuleInfo.Author^)));
    AddToLog('  Copyright: ' + string(WideString(ModuleInfo.Copyright^)));
    AddToLog('  OtherInfo: ' + string(WideString(ModuleInfo.OtherInfo^)));
    }

    Result := 0;
  except
    Result := -3;
    FreeLibrary(hModule);
    Exit;
  end;

  FreeLibrary(hModule);
end;

constructor TAssistantModule.Create(FileName: WideString);
begin
  FHandle := LoadLibrary(PChar(string(FileName)));
  Create(FHandle, FileName);

  {FFileName := FileName;

  FGetModuleInfoProc := GetProcAddress(FHandle, 'GetModuleInfo');
  FFinalizeModuleProc := GetProcAddress(FHandle, 'FinalizeModule');
  FInitializeModuleProc := GetProcAddress(FHandle, 'InitializeModule');
  FRunModuleProc := GetProcAddress(FHandle, 'LoadModule');
  FTerminateModuleProc := GetProcAddress(FHandle, 'UnLoadModule');

  FGetModuleInfoProc(@FModuleInfo);}
end;

constructor TAssistantModule.Create(Handle: Integer; FileName: WideString);
var
  mi: TModuleInfoRec;
begin
  FHandle := Handle;
  FFileName := FileName;

  FGetModuleInfoProc := GetProcAddress(FHandle, 'GetModuleInfo');
  FFinalizeModuleProc := GetProcAddress(FHandle, 'FinalizeModule');
  FInitializeModuleProc := GetProcAddress(FHandle, 'InitializeModule');
  FRunModuleProc := GetProcAddress(FHandle, 'LoadModule');
  FTerminateModuleProc := GetProcAddress(FHandle, 'UnLoadModule');

  FGetModuleInfoProc(@mi);
  ModuleInfoFromRec(mi, FModuleInfo);
end;

function TAssistantModule.FinalizeModule(): Integer;
begin
  Result := -1;
  try
    Result := FFinalizeModuleProc();
  except
  end;
end;

function TAssistantModule.InitializeModule(LocalID: Integer; SystemProc: TSystemProc): Integer;
begin
  Result := -1;
  try
    Result := FInitializeModuleProc(LocalID, SystemProc);
  except
  end;
end;

class procedure TAssistantModule.ModuleInfoFromRec(ModuleInfoRec: TModuleInfoRec; var ModuleInfo: TModuleInfo);
begin
  ModuleInfo.ModuleID := ModuleInfoRec.ModuleID;
  ModuleInfo.ModuleVersion := ModuleInfoRec.ModuleVersion;
  ModuleInfo.ModuleShortName := ModuleInfoRec.ModuleShortName^;
  ModuleInfo.ModuleFullName := ModuleInfoRec.ModuleFullName^;
  ModuleInfo.ModuleTitle := ModuleInfoRec.ModuleTitle^;
  ModuleInfo.ModuleDescription := ModuleInfoRec.ModuleDescription^;
  ModuleInfo.Author := ModuleInfoRec.Author^;
  ModuleInfo.Copyright := ModuleInfoRec.Copyright^;
  ModuleInfo.OtherInfo := ModuleInfoRec.OtherInfo^;
end;

function TAssistantModule.RunModule(): Integer;
begin
  Result := -1;
  try
    Result := FRunModuleProc();
  except
  end;
end;

function TAssistantModule.TerminateModule(): Integer;
begin
  Result := -1;
  try
    Result := FTerminateModuleProc();
  except
  end;
end;

procedure TAssistantModule.ToModuleInfo2(var ModuleInfo: TModuleInfo2);
begin
  ModuleInfo.ModuleID := FModuleInfo.ModuleID;
  ModuleInfo.ModuleVersion := FModuleInfo.ModuleVersion;
  ModuleInfo.ModuleShortName := FModuleInfo.ModuleShortName;
  ModuleInfo.ModuleFullName := FModuleInfo.ModuleFullName;
  ModuleInfo.ModuleTitle := FModuleInfo.ModuleTitle;
  ModuleInfo.ModuleDescription := FModuleInfo.ModuleDescription;
  ModuleInfo.Author := FModuleInfo.Author;
  ModuleInfo.Copyright := FModuleInfo.Copyright;
  ModuleInfo.OtherInfo := FModuleInfo.OtherInfo;
end;

end.
