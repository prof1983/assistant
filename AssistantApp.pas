{**
@Abstract Assistant app
@Author Prof1983 <prof1983@ya.ru>
@Created 17.08.2012
@LastMod 17.08.2012
}
unit AssistantApp;

interface

uses
  Forms,
  AssistantProgram, fAssistant, fStart;

procedure AssistantApp_Fin();
procedure AssistantApp_Init();
procedure AssistantApp_Run();

implementation

var
  {**
  Объкт управления главным окном.
  Реакции на события, возникающие в главном окне вынесены отдельно для того,
  чтобы AssistantForm можно было использовать не только в этом, но и в других проектах.
  }
  //AssistantFormControl: TAssistantFormControl;
  //** Главный объект программы
  AssistantProgram: TAssistantProgram;
  StartForm: TStartForm;
  //** Главное окно программы. Это окно является контейнером для создания вложенных окон.
  AssistantForm: TAssistantForm;
  //TrayIcon: TAUITrayIcon;

procedure AssistantApp_Fin();
begin
end;

procedure AssistantApp_Init();
begin
  Application.Initialize;
  Application.Title := 'Assistant';

  // Стартовая форма
  Application.CreateForm(TStartForm, StartForm);
  Application.ProcessMessages();
  // Создаем главный объект программы
  AssistantProgram := TAssistantProgram.Create();
  Application.ProcessMessages();
  AssistantProgram.Initialize();
  Application.ProcessMessages();

  // Создаем главное окно программы
  Application.CreateForm(TAssistantForm, AssistantForm);
  // Выходить из программы, а не сворачивать в трей.
  AssistantForm.IsClose := True;
  AssistantForm.Init();
  AssistantForm.Core := AssistantProgram.Core;
  AssistantForm.Initialize();

  // --- TrayIcon ---
  {
  TrayIcon := TAUITrayIcon.Create();
  TrayIcon.IsActive := True;
  //TrayIcon.Icon := Application.Icon;
  }

  // Создаем объект управления гавным окном
  //AssistantFormControl := TAssistantFormControl.Create();
  //AssistantFormControl.AssistantForm := AssistantForm;
end;

procedure AssistantApp_Run();
begin
  Application.Run();
end;

end.
