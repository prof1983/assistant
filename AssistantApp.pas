{**
@Abstract Assistant app
@Author Prof1983 <prof1983@ya.ru>
@Created 05.04.2007
@LastMod 12.11.2012
}
unit AssistantApp;

{define ArAssistant}

interface

uses
  AUiButtons, AUiComboBox, AUiControls, AUiBase, AUiBox, AUiTextView,
  AFormImpl,

  {$ifdef ArAssistant}ActiveX,{$endif}
  Forms,
  ABase, AOpenGlForm,
  {$ifdef ArAssistant}ArBuilderForm, ArTasksForm,{$endif}
  {$ifdef ArAssistant}ArKernelObj,{$endif}
  AssistantProgram,
  {$ifdef ArAssistant}ArAssistantForm,{$endif}
  fAssistant,
  fStart;

procedure AssistantApp_Fin();
procedure AssistantApp_Init();
procedure AssistantApp_Run();

implementation

var
  //** Главный объект программы
  AssistantProgram: TAssistantProgram;
  StartForm: TStartForm;
  //** Главное окно программы. Это окно является контейнером для создания вложенных окон.
  AssistantForm: TAssistantForm;
  //FAssistantForm: TAssistantForm; - ArAssistant
  {** Окно отрисовки графического отображения }
  FFaceForm: TfmOpenGL;
  {$ifdef ArAssistant}
  {** Kernel }
  Kernel: TArKernel;
  //** Путь расположения файлов базы знаний
  FKnowlegeBasePath: WideString;
  {$endif}
  //TrayIcon: TAUITrayIcon;

// --- Private ---

function InitConsolePage(): AError;
var
  Page: AControl;
  ConsolePanel: AControl;
  ConsoleRichEdit: AControl;
  ComboBox1: AControl;
  Button: AControl;
  W: AInt;
begin
  Page := AssistantForm.AddPage('ConsolePage', 'Console');
  if (Page = 0) then
  begin
    Result := -2;
    Exit;
  end;

  ConsolePanel := AUiBox_New(Page, 0);
  if (Result = 0) then
  begin
    Result := -3;
    Exit;
  end;
  AUiControl_SetHeight(ConsolePanel, 26);
  AUiControl_SetAlign(ConsolePanel, uiAlignBottom);
  W := AUiControl_GetWidth(ConsolePanel);

  ComboBox1 := AUiComboBox_New(ConsolePanel);
  if (ComboBox1 = 0) then
  begin
    Result := -4;
    Exit;
  end;
  AUiControl_SetPosition(ComboBox1, 2, 2);
  AUiControl_SetWidth(ComboBox1, W-30);
  AUiControl_SetAnchors(ComboBox1, uiakLeft + uiakTop + uiakRight);

  // -- ConsoleCommandButton --
  //Button := AUiButton_New(xxx);

  //xxx

  ConsoleRichEdit := AUiTextView_New(Page, 1);
  if (ConsoleRichEdit = 0) then
  begin
    Result := -10;
    Exit;
  end;
  AUiControl_SetAlign(ConsoleRichEdit, uiAlignClient);

  Result := 0;
end;

// --- Events ---

{$ifdef ArAssistant}
function DoExit(): AInt; stdcall;
begin
  if Assigned(FFaceForm) then
  try
    FFaceForm.Close();
  except
  end;
  Result := 0;
end;
{$endif}

procedure AssistantApp_Fin();
begin
  if Assigned(AssistantProgram) then
  try
    try
      AssistantProgram.Stop();
      AssistantProgram.Finalize();
      AssistantProgram.Free();
    finally
      AssistantProgram := nil;
    end;
  except
  end;

  {$ifdef ArAssistant}
  if Assigned(Kernel) then
  try
    try
      Kernel.Free();
    finally
      Kernel := nil;
    end;
  except
  end;
  {$endif}
end;

procedure AssistantApp_Init();
begin
  Application.Initialize;
  Application.Title := 'Assistant';

  // --- Boot ---
  {$ifdef ArAssistant}
  // Создаем и инициализируем ядро программы (Kernel)
  Kernel := TArKernel.Create();
  Kernel.Initialize();
  {$endif}

  // --- Init ---

  {$ifdef ArAssistant}
  CoInitialize(nil);
  {$endif}

  // Стартовая форма
  Application.CreateForm(TStartForm, StartForm);
  Application.ProcessMessages();

  // Создаем главный объект программы
  AssistantProgram := TAssistantProgram.Create();
  Application.ProcessMessages();

  {ifdef ArAssistant}
  // Присоединяемся к получению сообщений
  //AssistantProgram.SendMessageEvent.Connect(FAssistantForm.AddMessage);
  //AssistantProgram.OnAddToLog := FAssistantForm.AddToLog;
  {endif}

  AssistantProgram_Initialize();
  Application.ProcessMessages();

  Application.CreateForm(TfmOpenGL, FFaceForm);
  // Создаем главное окно программы
  AssistantForm := TAssistantForm.Create(FFaceForm);
  InitConsolePage();

  try
    FFaceForm.IsStar := True;
    FFaceForm.Top := 600;
    FFaceForm.Left := 0;
    FFaceForm.Height := 200;
    FFaceForm.Width := 200;
    FFaceForm.Initialize();
    FFaceForm.Show();
  except
  end;

  try
    AssistantForm.Top := 0;
    AssistantForm.Left := 0;
    AssistantForm.Height := 600;
    AssistantForm.Width := 800;
    //AssistantForm.OnMessage := AssistantProgram.OnSendMessage;
    //AssistantForm.OnExit := DoExit;
    // Выходить из программы, а не сворачивать в трей.
    AssistantForm.IsClose := True;
    AssistantForm.Init();
    AssistantForm.Core := AssistantProgram_GetCore();
    AssistantForm.Initialize();
    AssistantForm.Show();
  except
  end;

  // --- TrayIcon ---
  {
  TrayIcon := TAUITrayIcon.Create();
  TrayIcon.IsActive := True;
  //TrayIcon.Icon := Application.Icon;
  }
end;

procedure AssistantApp_Run();
begin
  AssistantProgram.Start();
  Application.Run();
end;

end.
