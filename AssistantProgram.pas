{**
@Abstract Assistant main class
@Author Prof1983 <prof1983@ya.ru>
@Created 14.07.2007
@LastMod 17.08.2012
}
unit AssistantProgram;

interface

uses
  IniFiles, SysUtils,
  AProgramImpl, ASystemData, ATypes,
  AiConsts, AiCoreImpl, AilTokenizer,
  AssistantEngine, AssistantEnviromentObj, AssistantGlobals, AssistantModule, AssistantReason,
  AssistantSystem, ModuleInfoRec;

type //** Главный класс программы Assistant
  TAssistantProgram = class(TAProgram)
  private
      //** Микроядро системы
    FCore: TAICore;
      //** Движок AIAssitant
    FEngine: TAssistantEngine;
      //** DLL модули системы
    FModules: array of TAssistantModule;
      //** Главный агент
    FReason: TReason;
      //** Assistant system
    FSystem: TAssistantSystem;
  private
    function GetModuleByIndex(Index: Integer): TAssistantModule;
    function GetModuleByLocalID(LocalID: Integer): TAssistantModule;
    function GetModuleCount(): Integer;
  protected
    //** Добавить DLL модуль
    function AddModule(Module: TAssistantModule): Integer;
    function NewModule(FileName: WideString): TAssistantModule;
  public
    class function GetInstance(): TAssistantProgram;
    //** Инициализировать
    function Initialize(): TProfError; override;
    //** Загрузить DLL модули
    procedure LoadModules();
    //** Выполнить файл
    function RunFile(FileName: WideString): Boolean;
    //** Выполнить скрипт
    function RunScript(Code: WideString): Boolean;
    //** Выполнить системный метод
    function RunSystemMethod(ClassName, MethodName, Param: WideString): Boolean;
  public
    constructor Create(); override;
  public
    //** Микроядро системы
    property Core: TAICore read FCore;
  public
    //** Колличество DLL модулей
    property ModuleCount: Integer read GetModuleCount;
    //** DLL модули по индексу
    property ModuleByIndex[Index: Integer]: TAssistantModule read GetModuleByIndex;
    //** DLL модули по ID
    property ModuleByLocalID[LocalID: Integer]: TAssistantModule read GetModuleByLocalID;
  end;

resourcestring
  NoModulesMessage = 'Не найдено ни одного модуля.'#13#10+
        'Проверьте настройки программы, проверьте наличие DLL модулей '+
        '(обычно DLL модули располагаются в папке modules).'#13#10+
        'Дополнительную информацию смотрите в документации и на сайте aikernel.org';
  IniFileDefault =
    '; Файл настроек assistant.ini для системы Assistant'#13#10+
    '; Prof1983 <prof1983@ya.ru>'#13#10+
    #13#10+
    '; Секция с основными настройками'#13#10+
    '[General]'#13#10+
    '; Имя файла модуля-загрузчика'#13#10+
    'BootModule = ' + BootModuleDefaultFileName + #13#10 +
    #13#10;

implementation

uses
  fStart;

function SystemProc(Sender, Receiver, Cmd, Param1, Param2: Integer): Integer; stdcall;
var
  i: Integer;
  i2: Integer;
  p: TAssistantProgram;
begin
  p := TAssistantProgram.GetInstance();

  //MainForm.LogRichEdit.Lines.Add(IntToStr(Sender)+' '+IntToStr(Receiver)+' '+
  //  IntToStr(Cmd)+' '+IntToStr(Param1)+' '+IntToStr(Param2));

  if (Receiver = AssistantGlobals.MainModuleLoacalID) then
    case Cmd of
      AssistantGlobals.GetModuleListCount: // Param1 - указатель на переменную Int32
        begin
          Integer(Pointer(Param1)^) := p.ModuleCount;
        end;
      AssistantGlobals.GetModuleList: // Param1 - указатель на область памяти array[0..count-1]; Param2 - count
        begin
          if p.ModuleCount > Param2 then
            i2 := Param2
          else
            i2 := p.ModuleCount;
          for i := 0 to i2 - 1 do
            Integer(Pointer(Param1 + i * 4)^) := p.ModuleByIndex[i].Handle;
        end;
      AssistantGlobals.GetModuleInfo: // Param1 - LocalID модуля, Param2 - PModuleInfo2
        begin
          p.ModuleByLocalID[Param1].ToModuleInfo2(TModuleInfo2(Pointer(Param2)^));
          // ...
        end;
    end;

  Result := 0;
end;

{ TAssistantProgram }

function TAssistantProgram.AddModule(Module: TAssistantModule): Integer;
begin
  Result := Length(FModules);
  SetLength(FModules, Result + 1);
  FModules[Result] := Module;
end;

constructor TAssistantProgram.Create();
begin
  // -- Default settings --
  Self.FConfigDir := AiConfigDir;
  Self.FDataDir := AiDataDir;
  Self.FProgramDescription := 'Personal assistant';
  Self.FProgramName := 'Assistant';
  Self.FProgramNameDisplay := 'Assistant';
  Self.FProgramVersionStr := '0.0';
  Self.FSystemName := 'AReason';

  inherited Create();
end;

class function TAssistantProgram.GetInstance(): TAssistantProgram;
begin
  Result := TAssistantProgram(inherited GetInstance());
end;

function TAssistantProgram.GetModuleByIndex(Index: Integer): TAssistantModule;
begin
  if (Index >= 0) and (Index < Length(FModules)) then
    Result := FModules[Index]
  else
    Result := nil;
end;

function TAssistantProgram.GetModuleByLocalID(LocalID: Integer): TAssistantModule;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(FModules) do
    if FModules[i].Handle = LocalID then
    begin
      Result := FModules[i];
      Exit;
    end;
end;

function TAssistantProgram.GetModuleCount(): Integer;
begin
  Result := Length(FModules);
end;

function TAssistantProgram.Initialize(): TProfError;
var
  iniFile: TIniFile;
  s: string;
  FileName: string;
begin
  inherited Initialize();

  TStartForm.AddToLog('Инициализация...');
  FCore := TAICore.Create();

  FSystem := TAssistantSystem.Create();
  // Задаем параметры по умолчанию
  FSystem.BootModuleFileName := AssistantGlobals.BootModuleDefaultFileName;
  FSystem.ConfigurationDir := AssistantGlobals.ConfigurationDefaultDir; //'configuration';
  FSystem.ModulesDir := ModulesDefaultDir;

  s := ParamStr(1);
  if s <> '' then
  begin
    FileName := s;
    s := ExtractFilePath(s);
    if s = '' then
      FileName := FExePath + FileName;
  end;

  if (FileName = '') then
  begin
    FileName := FExePath + 'Assistant.ini';
    if not(FileExists(FileName)) then
      FileName := FConfigPath + 'Assistant.ini';
  end;

  if FileExists(FileName) then
  begin
    iniFile := TIniFile.Create(FileName);
    // модуль загрузчик
    FSystem.BootModuleFileName := iniFile.ReadString('General', 'BootModule', FSystem.BootModuleFileName);
    // Директория конфигурации
    FSystem.ConfigurationDir  := iniFile.ReadString('General', 'Configuration', FSystem.ConfigurationDir);
    iniFile.Free();
  end;

  TStartForm.AddToLog('Загрузка DLL модулей...');
  // Загрузить DLL модули
  LoadModules();

  TStartForm.AddToLog('Инициализация движка (Engine)');
  FEngine := TAssistantEngine.Create();
  FEngine.Initialize();

  TStartForm.AddToLog('Инициализация главного агента');
  FReason := TReason.Create();
  FEngine.Enviroment.AddComponent(FReason);

  // Нужно раскоментировать, если обязательно требуется запуск модулей.
  {if Length(FModules) = 0 then
  begin
    ShowMessage(NoModulesMessage);
    Halt(1);
  end;}
  Result := 0;
end;

procedure TAssistantProgram.LoadModules();
var
  sr: TSearchRec;
  i: Integer;
  path: string;
  ModuleInfo: TModuleInfo;
begin
  try
    path := FExePath;
    i := FindFirst(path + FSystem.ModulesDir + '\*.dll', faAnyFile, sr);
    while (i = 0) do
    begin
      //LogRichEdit.Lines.Add('Найден файл ' + sr.Name);

      try
        if (TAssistantModule.CheckModule(path + FSystem.ModulesDir + '\' + sr.Name, ModuleInfo) = 0) then
        begin
          //LogRichEdit.Lines.Add('Найден модуль ' + ModuleInfo.ModuleFullName);
          NewModule(path + FSystem.ModulesDir + '\' + sr.Name);
        end;
      except
        //LogRichEdit.Lines.Add('Ошибка при загрузке DLL модуля ' + sr.Name);
      end;

      i := FindNext(sr);
    end;
    SysUtils.FindClose(sr);

    // Инициализация всех модулей
    for i := 0 to High(FModules) do
      FModules[i].InitializeModule(FModules[i].Handle, SystemProc);

    // Запуск всех модулей
    for i := 0 to High(FModules) do
      FModules[i].RunModule();
  except
    //LogRichEdit.Lines.Add('Ошибка при загрузке DLL модулей');
  end;
end;

function TAssistantProgram.NewModule(FileName: WideString): TAssistantModule;
begin
  Result := TAssistantModule.Create(FileName);
  AddModule(Result);
end;

function TAssistantProgram.RunFile(FileName: WideString): Boolean;
begin
  Result := False;
end;

function TAssistantProgram.RunScript(Code: WideString): Boolean;
var
  Tokenizer: TTokenizer;
  Token: WideChar;
  FPath: WideString;
  FMethodName: WideString;
  FParam: WideString;
begin
  Result := False;

  Tokenizer := TTokenizer.Create();
  Tokenizer.InputString := Code;
  //Tokenizer.Parse(Code);

  //FType := 0;
  FPath := '';
  FMethodName := '';
  FParam := '';
  while not(Tokenizer.Eof()) do
  begin
    Token := Tokenizer.NextChar();
    case Tokenizer.TokenType of
      CLASS_NAME_TOKEN_TYPE: // Класс
        begin
          if Token = POINT_TOKEN then
          begin
            Tokenizer.AheadTokenType(METHOD_NAME_TOKEN_TYPE);
          end
          else
            FPath := FPath + Token;
        end;
      METHOD_NAME_TOKEN_TYPE: // Метод
        begin
          if Token = '(' then
          begin
            Tokenizer.AheadTokenType(PARAM_TOKEN_TYPE);
          end
          else
            FMethodName := FMethodName + Token;
        end;
      PARAM_TOKEN_TYPE: // область параметров метода
        begin
          if Token = '"' then
          begin
            Tokenizer.AheadTokenType(STRING_PARAM_TOKEN_TYPE);
          end
          else if Token = ')' then
          begin
            if (Tokenizer.NextChar() = ';') then
              Result := RunSystemMethod(FPath, FMethodName, FParam);
            //Tokenizer.BackTokenType();
          end;     
        end;
      STRING_PARAM_TOKEN_TYPE:
        begin
          if Token = '"' then
          begin
            Tokenizer.BackTokenType();
          end
          else
            FParam := FParam + Token;
        end;
    end;
  end;

  Tokenizer.Free();
end;

function TAssistantProgram.RunSystemMethod(ClassName, MethodName, Param: WideString): Boolean;
begin
  Result := False;

  if (ClassName = 'LogJournal') then
  begin
    if (MethodName = 'AddToLog') then
    begin
      if Assigned(LogJournal) then
        LogJournal.AddToLog(Param);
      Result := True;
    end;
  end;
end;

end.
