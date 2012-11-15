{**
@Abstract Assistant console page
@Author Prof1983 <prof1983@ya.ru>
@Created 13.11.2012
@LastMod 15.11.2012
}
unit AssistantConsolePage;

interface

uses
  ABase, AFormImpl, AUtils,
  AUiButtons, AUiComboBox, AUiControls, AUiBase, AUiBox, AUiTextView,
  AssistantProgram, fAssistant;

function AssistantConsolePage_Init(AssistantForm: TAssistantForm): AError;

implementation

var
  ConsoleRichEdit: AControl;
  ConsoleComboBox: AControl;
  FAssistantForm: TAssistantForm;
var
  CommandList: array of APascalString;

// --- Private ---

function Print(const Text: APascalString): AInt;
begin
  Result := AUiTextView_AddLineP(ConsoleRichEdit, Text);
end;

procedure PrintInfo();
var
  P: TAssistantProgram;
begin
  P := TAssistantProgram.GetInstance();
  Print(P.ProgramName + ' (' + AUtils.IntToStrP(P.ProgramId) + ') ' + P.ProgramVersion);
  if (P.ProgramNameDisplay <> '') and (P.ProgramName <> P.ProgramNameDisplay) then
    Print(P.ProgramNameDisplay);
  if (P.ProgramDescription <> '') then
    Print(P.ProgramDescription);
end;

// --- Events ---

function CommandButtonClick(Obj, Data: AInteger): AError; stdcall;
begin
  Result := 0;
end;

function RunCommandButtonClick(Obj, Data: AInteger): AError; stdcall;
var
  Cmd: APascalString;
  I: AInt;
begin
  Cmd := AUiControl_GetTextP(ConsoleComboBox);

  if (Cmd = '') then
  begin
    Result := 0;
    Exit;
  end;

  I := AUiComboBox_GetItemIndex(ConsoleComboBox);
  if (I < 0) then
    AUiComboBox_AddP(ConsoleComboBox, Cmd);
  AUiControl_SetTextP(ConsoleComboBox, '');

  Print('--> ' + Cmd);

  if (Cmd = 'HELP') then
  begin
    Print('--------------------------------');
    Print('Программа: Assistant');
    Print('Версия: 0.0.7');
    Print('--------------------------------');
    Print('Краткая справка по командам программы');
    Print('HELP - вывести справку');
    Print('RULES - вывести список правил');
    Print('FACTS - вывести список фактов');
    Print('LOG - показат окно логирования');
    Print('--------------------------------');
  end
  else if (Cmd = 'FACTS') then
  begin
    Print('--------------------------------');
    Print('Список фактов');
    Print('Список фактов пуст');
    // ...
    Print('--------------------------------');
  end
  else
    FAssistantForm.DoCommand(Cmd);

  Result := 0;
end;

// --- Public ---

function AssistantConsolePage_Init(AssistantForm: TAssistantForm): AError;
var
  Page: AControl;
  ConsolePanel: AControl;
  Button: AControl;
  W: AInt;
begin
  FAssistantForm := AssistantForm;
  Page := AssistantForm.AddPage('ConsolePage', 'Console');
  if (Page = 0) then
  begin
    Result := -2;
    Exit;
  end;

  ConsolePanel := AUiBox_New(Page, 0);
  if (ConsolePanel = 0) then
  begin
    Result := -3;
    Exit;
  end;
  AUiControl_SetHeight(ConsolePanel, 26);
  AUiControl_SetAlign(ConsolePanel, uiAlignBottom);
  W := AUiControl_GetWidth(ConsolePanel);

  ConsoleComboBox := AUiComboBox_New(ConsolePanel);
  if (ConsoleComboBox = 0) then
  begin
    Result := -4;
    Exit;
  end;
  AUiControl_SetPosition(ConsoleComboBox, 2, 2);
  AUiControl_SetWidth(ConsoleComboBox, W-50);
  AUiControl_SetAnchors(ConsoleComboBox, uiakLeft + uiakTop + uiakRight);

  // -- ConsoleCommandButton --
  Button := AUiButton_New(ConsolePanel);
  if (Button = 0) then
  begin
    Result := -5;
    Exit;
  end;
  AUiControl_SetSize(Button, 22, 22);
  AUiControl_SetPosition(Button, W-50+2, 2);
  AUiControl_SetTextP(Button, '...');
  AUiControl_SetOnClick(Button, CommandButtonClick);
  AUiControl_SetAnchors(Button, uiakTop + uiakRight);

  // -- RunCommandButton --
  Button := AUiButton_New(ConsolePanel);
  if (Button = 0) then
  begin
    Result := -6;
    Exit;
  end;
  AUiControl_SetSize(Button, 22, 22);
  AUiControl_SetPosition(Button, W-50+24, 2);
  AUiControl_SetTextP(Button, 'Run');
  AUiControl_SetOnClick(Button, RunCommandButtonClick);
  AUiControl_SetAnchors(Button, uiakTop + uiakRight);

  // --- ConsoleRichEdit ---

  ConsoleRichEdit := AUiTextView_New(Page, 1);
  if (ConsoleRichEdit = 0) then
  begin
    Result := -10;
    Exit;
  end;
  AUiControl_SetAlign(ConsoleRichEdit, uiAlignClient);

  PrintInfo();

  Result := 0;
end;

end.
