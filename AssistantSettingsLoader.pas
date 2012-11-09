{**
@Abstract Класс для загрузки параметров из INI файла
@Author Prof1983 <prof1983@ya.ru>
@Created 29.06.2007
@LastMod 16.03.2012
}
unit AssistantSettingsLoader;

interface

uses
  IniFiles,
  AssistantSettings;

type //** @abstract(Класс для загрузки параметров из INI файла)
  TAssistantSettingsLoader = class
  public
    class function Load(Settings: TAssistantSettings; FileName: WideString): Boolean;
  end;

implementation

{ TAssistantSettingsLoader }

class function TAssistantSettingsLoader.Load(Settings: TAssistantSettings; FileName: WideString): Boolean;
var
  f: TIniFile;
  //i: Integer;
begin
  Result := False;
  if not(Assigned(Settings)) then Exit;
  if (FileName = '') then Exit;

  Result := False;
  try
    f := TIniFile.Create(FileName);
  except
    Exit;
  end;

  try
    Settings.Title := f.ReadString('General', 'Title', '');
    Settings.TaskTypeID := f.ReadInteger('General', 'TaskTypeID', 0);
  except
    f.Free();
    Exit;
  end;

  f.Free();
  Result := True;
end;

end.
