{**
@Abstract Assistant global consts and types
@Author Prof1983 <prof1983@ya.ru>
@Created 04.08.2007
@LastMod 16.03.2012
}
unit AssistantGlobals;

interface

const
  AgentsDefaultDir        = 'agents';
  ComponentsDefaultDir    = 'components';
  ConfigurationDefaultDir = 'configuration';
  DataDefaultDir          = 'data';
  DocumentstionDefaultDir = 'doc';
  ModulesDefaultDir       = 'modules';
  PluginsDefaultDir       = 'plugins';
  TempDefaultDir          = 'temp';
  UsersDefaultDir         = 'users';

const //** Имя модуля-загрузчика по умолчанию
  BootModuleDefaultFileName = 'org.aiassistant.boot.dll';

const //** Локальный идентификатор главного модуля (assistant.exe)
  MainModuleLoacalID = 1;

type
  TSystemProc = function(Sender, Receiver, Cmd, Param1, Param2: Integer): Integer; stdcall;

// -----------------------------------------------------------------------------
// PlatformAPI
// Описание API команд и функций платформы AIAssistant

{
Платформа AIAssistant представляет из себя простой механизм обмена сообщениями
между DLL модулями платформы.
Сообщения имеют следующий формат:
  Sender: Int32   - отправитель сообщения
  Reveiver: Int32 - получатель сообщения
  Cmd: Int32      - команда
  Param1: Int32   - параметр 1: Int32 (или указатель на область памяти)
  Param2: Int32   - параметр 2: Int32 (или указатель на область памяти)
}

// Команды assistant.exe (Receiver = MainModuleLoacalID = 1)

const
  GetModuleListCount = 3; // Param1 - указатель на переменную Int32
  GetModuleList = 4; // Param1 - указатель на область памяти array[0..count-1]; Param2 - count
  GetModuleInfo = 5; // Param1 - LocalID модуля, Param2 - PModuleInfo2
  AddModule = 6;
  RemoteModule = 7;

implementation

end.
