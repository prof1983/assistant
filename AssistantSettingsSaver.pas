{**
@Abstract Класс для сохранения параметров в INI файл
@Author Prof1983 <prof1983@ya.ru>
@Created 29.06.2007
@LastMod 05.05.2012
}
unit AssistantSettingsSaver;

interface

uses
  IniFiles, SysUtils, Windows,
  AssistantSettings;

type //** @abstract(Класс для сохранения параметров в INI файл)
  TAssistantSettingsSaver = class
  public
    class function Save(Settings: TAssistantSettings; FileName: WideString): Boolean;
  end;

implementation

{ TAssistantSettingsSaver }

class function TAssistantSettingsSaver.Save(Settings: TAssistantSettings; FileName: WideString): Boolean;
var
  f: TIniFile;
begin
  Result := False;
  if not(Assigned(Settings)) then Exit;
  if (FileName = '') then Exit;

  SysUtils.DeleteFile(FileName);

  Result := False;
  try
    f := TIniFile.Create(FileName);
  except
    Exit;
  end;

  try
    f.WriteString('General', 'Title', Settings.Title);
    f.WriteInteger('General', 'TaskTypeID', Settings.TaskTypeID);
  except
  end;

  f.Free();
  Result := True;
end;

end.
