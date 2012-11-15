{**
@Abstract Assistant GUI
@Author Prof1983 <prof1983@ya.ru>
@Created 12.11.2012
@LastMod 15.11.2012
}
unit AssistantGui;

interface

uses
  Classes, ComCtrls, Controls, ExtCtrls, Forms, Menus, StdCtrls, SysUtils, ValEdit,
  ABase, ASplitterControl, AShablonForm, ASystem, ASystemUtils, ATypes, AUiDialogs,
  AssistantAgentControl, AssistantChatControl, AssistantCommandsControl, AssistantData,
  AssistantDeveloperControl, AssistantProgram, AssistantMemoControl, AssistantTasksControl,
  AiConsts;

type
  //** @abstract(Тип вкладки главной области)
  TabMainTypeEnum = Integer;

const
  tmNone    = $00000000;
  tmMemo    = $00000001;
  tmUncnown = $00008000;

type
  //** @abstract(Тип вкладки панели сообщений)
  TabMessageTypeEnum = Integer;

const
  tmsgNone     = $00000000;
  tmsgMessages = $00000001;
  tmsgLog      = $00000002;
  tmsgCommands = $00000004;
  tmsgTasks    = $00000008;
  tmsgUncnown  = $00008000;

// ----

type
  TProfItem = class
  private
    FTreeNode: TTreeNode;
  public
    property TreeNode: TTreeNode read FTreeNode write FTreeNode;
  end;

// ----

type //** Главная форма Assistant
  TAssistantForm = class(TfmShablon)
  private
    procedure CreateMenu();
  protected
    procedure miHelpAboutClick(Sender: TObject);
  public
    {** Срабатывает при выполнении действия Run }
    procedure DoActionRun(Sender: TObject); virtual;
    {** Срабатывает при закрытии окна }
    procedure DoClose(var Action: TCloseAction); override;
    {** Срабатывает при создании }
    procedure DoCreate(); override;
    procedure DoRefreshClick(Sender: TObject); virtual;
  public
    function AddMainTab(ATabType: TabMainTypeEnum; const ACaption: WideString): TWinControl;
    function AddMessage(const Msg: WideString): AInt;
    {** Добавляет вкладку в области сообщений }
    function AddTabMessage(ATabType: TabMessageTypeEnum; const ACaption: WideString): TWinControl;
    function AddToLog(LogGroup: TLogGroupMessage; LogType: TLogTypeMessage; const StrMsg: WideString): Integer;
    {** Загрузает конфигурации }
    function ConfigureLoad(Config: AConfig{IProfNode = nil}): AError;
    {** Сохраняет конфигурации }
    function ConfigureSave(Config: AConfig{IProfNode = nil}): AError;
    function GetTreeItemByNode(Node: TTreeNode): TProfItem;
    {** Инициализирует }
    function Initialize(): AError;
    {** Создать новый элемент дерева }
    //function NewTreeItem(Parent: TProfItem; const Caption: WideString): TProfItem;
  public
    {** Контрол для агента }
    //property AgentControl: TAgentControl read FAgentControl;
    //property OnExit: AProc read FOnExit write FOnExit;
  end;

implementation

var
  // -- TfmDeveloper3 --
  miHelp: TMenuItem;
  miHelpAbout: TMenuItem;
  miHelpHelp: TMenuItem;
  mmMain: TMainMenu;
  pbH1: TProgressBar;

  //pnButtons: TPanel;
  pnMain: TPanel;
  pnMessages: TPanel;
  pnObjects: TPanel;
  pnTool: TPanel;

  sbMain: TStatusBar;

  //spButtons: TSplitterControl;
  spMessages: TSplitterControl;
  spObjects: TSplitterControl;
  spTool: TSplitterControl;
  // -- TfmDeveloperA --
  spObjectsH: TSplitterControl;
  tvObjects: TTreeView;
  vleObjects: TValueListEditor;
  // -- TfmDeveloperB --
  pcMain: TPageControl;
  // -- TfmDeveloperC --
  miRun: TMenuItem;
  miRunRun: TMenuItem;
  miView: TMenuItem;
  miViewRefresh: TMenuItem;
  // -- TfmDeveloperD --
  pcMessages: TPageControl;
  tsCommands: TTabSheet;
  tsLogs: TTabSheet;
  tsMessages: TTabSheet;
  // -- TDeveloperFormI --
  FItems: array of TProfItem;
  // --- AssistantForm ---
  memMessages: TMemo;

{ TAssistantForm }

function TAssistantForm.AddMainTab(ATabType: TabMainTypeEnum; const ACaption: WideString): TWinControl;
begin
  Result := TTabSheet.Create(Self);
  TTabSheet(Result).PageControl := pcMain;
  TTabSheet(Result).Caption := ACaption;
end;

function TAssistantForm.AddMessage(const Msg: WideString): Integer;
begin
  Result := AssistantChatControl_AddMessageP(Msg);
end;

(*function TAssistantForm.AddMessageX(Msg: AMessage{IProfNode}): AInt;
// TODO: Возникает ошибка ( Msg.ChildNodes = error )
var
  content: IProfNode;
  i: Integer;
  module: IProfNode;
begin
  if not(Assigned(Msg)) then Exit;
  // Считаем что пришедшее сообщение ответ на команду Core.GetMessages
  Self.tvObjects.Items.Clear();
  content := Msg.ChildNodes.NodeByName[ACL_CONTENT];
  for i := 0 to content.ChildNodes.NodeCount - 1 do
  begin
    module := content.ChildNodes.NodeByIndex[i];
    Self.NewTreeItem(nil, module.Name);
  end;
end;*)

function TAssistantForm.AddTabMessage(ATabType: TabMessageTypeEnum; const ACaption: WideString): TWinControl;
begin
  Result := TTabSheet.Create(Self);
  TTabSheet(Result).PageControl := pcMessages;
  TTabSheet(Result).Caption := ACaption;
end;

function TAssistantForm.AddToLog(LogGroup: TLogGroupMessage; LogType: TLogTypeMessage; const StrMsg: WideString): Integer;
begin
  Result := AssistantAgentControl_AddToLog(LogGroup, LogType, StrMsg);
end;

function TAssistantForm.ConfigureLoad(Config: AConfig{IProfNode}): AError;
//var
  //i: Integer;
  //tmpConfig: IProfNode;
begin
  {if Assigned(AConfig) then
    tmpConfig := AConfig
  else
    tmpConfig := FConfig;}

  {if TProfXmlNode.ReadIntegerA(tmpConfig, 'ObjectsWidth', i) then
    if i > 0 then
      pnObjects.Width := i
    else
      pnObjects.Visible := False;
  if TProfXmlNode.ReadIntegerA(tmpConfig, 'ToolWidth', i) then
    if i > 0 then
      pnTool.Width := i
    else
      pnTool.Visible := False;
  if TProfXmlNode.ReadIntegerA(tmpConfig, 'ButtonsHeight', i) then
    if i > 0 then
      pnButtons.Height := i
    else
      pnButtons.Visible := False;
  if TProfXmlNode.ReadIntegerA(tmpConfig, 'MessagesHeight', i) then
    if i > 0 then
      pnMessages.Height := i
    else
      pnMessages.Visible := False;}

  {if TProfXmlNode.ReadIntegerA(tmpConfig, 'ObjectTreeViewHeight', i) then tvObjects.Height := i;
  if TProfXmlNode.ReadIntegerA(tmpConfig, 'ObjectPropertyCol0Width', i) then vleObjects.ColWidths[0] := i;}
  Result := 0;
end;

function TAssistantForm.ConfigureSave(Config: AConfig{IProfNode}): AError;
//var
  //tmpConfig: IProfNode;
begin
  {if Assigned(AConfig) then
    tmpConfig := AConfig
  else
    tmpConfig := FConfig;}

  {TProfXmlNode.WriteIntegerA(tmpConfig, 'ObjectsWidth', pnObjects.Width);
  TProfXmlNode.WriteIntegerA(tmpConfig, 'ToolWidth', pnTool.Width);
  TProfXmlNode.WriteIntegerA(tmpConfig, 'ButtonsHeight', pnButtons.Height);
  TProfXmlNode.WriteIntegerA(tmpConfig, 'MessagesHeight', pnMessages.Height);}

  {TProfXmlNode.WriteIntegerA(tmpConfig, 'ObjectTreeViewHeight', tvObjects.Height);
  TProfXmlNode.WriteIntegerA(tmpConfig, 'ObjectPropertyCol0Width', vleObjects.ColWidths[0]);}
  Result := 0;
end;

procedure TAssistantForm.CreateMenu();
begin
  // Создаем меню
  miView := TMenuItem.Create(Self);
  miView.Caption := 'Вид'; //'View';

  miViewRefresh := TMenuItem.Create(Self);
  miViewRefresh.Caption := 'Обновить'; //'Refresh';
  miViewRefresh.OnClick := DoRefreshClick;
  miView.Add(miViewRefresh);
  mmMain.Items.Insert(0, miView);

  miRun := TMenuItem.Create(Self);
  miRun.Caption := 'Выполнить'; //'Run';
  mmMain.Items.Insert(1, miRun);

  miRunRun := TMenuItem.Create(Self);
  miRunRun.Caption := 'Run';
  miRunRun.OnClick := DoActionRun;
  miRun.Add(miRunRun);

  miHelp := TMenuItem.Create(Self);
  miHelp.Caption := '?';
  mmMain.Items.Add(miHelp);

  miHelpHelp := TMenuItem.Create(Self);
  miHelpHelp.Caption := 'Помощь'; //'Help';
  miHelp.Add(miHelpHelp);

  miHelpAbout := TMenuItem.Create(Self);
  miHelpAbout.Caption := 'О программе...'; //'About';
  miHelp.Add(miHelpAbout);
  miHelpAbout.OnClick := miHelpAboutClick;
end;

procedure TAssistantForm.DoActionRun(Sender: TObject);
begin
  //AssistantJavaControl_RunAction();
end;

procedure TAssistantForm.DoClose(var Action: TCloseAction);
begin
  inherited;
  if Assigned(Assistant_OnExit) then
    Assistant_OnExit();
end;

procedure TAssistantForm.DoCreate();
begin
  Caption := 'Assistant';

  // ---
  Self.Left := 0;
  Self.Top := 0;
  Self.Height := 420;
  Self.Width := 640;

  mmMain := TMainMenu.Create(Self);
  Self.Menu := mmMain;

  CreateMenu();

  {pnButtons := TPanel.Create(Self);
  pnButtons.Parent := Self;
  pnButtons.Height := 30;
  pnButtons.Align := alTop;}

  {spButtons := TSplitterControl.Create(Self);
  spButtons.Control := pnButtons;
  spButtons.Parent := Self;
  spButtons.Align := alTop;}

  pnMessages := TPanel.Create(Self);
  pnMessages.Parent := Self;
  pnMessages.Height := 70;
  pnMessages.Align := alBottom;

  spMessages := TSplitterControl.Create(Self);
  spMessages.Control := pnMessages;
  spMessages.Parent := Self;
  spMessages.Align := alBottom;

  pnObjects := TPanel.Create(Self);
  pnObjects.Parent := Self;
  pnObjects.Width := 100;
  pnObjects.Align := alLeft;

  spObjects := TSplitterControl.Create(Self);
  spObjects.Control := pnObjects;
  spObjects.Parent := Self;
  spObjects.Left := pnObjects.Width + 10;
  spObjects.Align := alLeft;

  pnTool := TPanel.Create(Self);
  pnTool.Parent := Self;
  pnTool.Width := 100;
  pnTool.Align := alRight;

  spTool := TSplitterControl.Create(Self);
  spTool.Control := pnTool;
  spTool.Parent := Self;
  spTool.Align := alRight;

  pnMain := TPanel.Create(Self);
  pnMain.Parent := Self;
  pnMain.Align := alClient;

  pbH1 := TProgressBar.Create(pnMain);
  pbH1.Parent := pnMain;
  pbH1.Align := alBottom;
  pbH1.Height := 6;
  pbH1.Smooth := True;
  pbH1.Max := 255;

  sbMain := TStatusBar.Create(Self);
  sbMain.Top := 2000;
  sbMain.Align := alBottom;
  // ---

  tvObjects := TTreeView.Create(pnObjects);
  tvObjects.Parent := pnObjects;
  tvObjects.Height := pnObjects.Height div 2;
  tvObjects.Align := alTop;

  spObjectsH := TSplitterControl.Create(Self);
  spObjectsH.Parent := pnObjects;
  spObjectsH.Align := alTop;

  vleObjects := TValueListEditor.Create(pnObjects);
  vleObjects.Parent := pnObjects;
  vleObjects.Align := alClient;

  pcMain := TPageControl.Create(pnMain);
  pcMain.Parent := pnMain;
  pcMain.Align := alClient;

  pcMessages := TPageControl.Create(Self);
  pcMessages.Parent := pnMessages;
  pcMessages.Align := alClient;
  pcMessages.TabPosition := tpBottom;

  tsCommands := TTabSheet.Create(Self);
  tsCommands.PageControl := pcMessages;
  tsCommands.Caption := 'Команды'; //'Commands';

  tsMessages := TTabSheet.Create(Self);
  tsMessages.PageControl := pcMessages;
  tsMessages.Caption := 'Сообщения'; //'Messages';

  tsLogs := TTabSheet.Create(Self);
  tsLogs.PageControl := pcMessages;
  tsLogs.Caption := 'Логи'; //'Logs';
end;

function TAssistantForm.Initialize(): AError;
var
  pr: TAssistantProgram;
  ts: TWinControl;
  S: string;
  FExePath: APascalString;
begin
  pr := TAssistantProgram.GetInstance();

  vleObjects.ColWidths[0] := 50;
  pnMessages.Height := 100;
  pnObjects.Width := 150;

  //ts := AddMainTab(0, 'Work');
  //AssistantWorkControl_Init(ts);

  // Контрол чата
  ts := AddMainTab(0, 'Chat');
  AssistantChatControl_Init(ts, AddMessage, AddToLog);

  FExePath := ASystem.GetDirectoryPathP();

  ts := AddMainTab(0, 'Предложение');
  AssistantMemoControl_Init(ts, AddMessage);
  try
    S := NormalizePath2(FExePath + AiDataDir) + 'First.txt';
    S := SysUtils.ExpandFileName(S);
    if FileExists(S) then
      AssistantMemoControl_LoadFromFileP(S)
    else
    begin
      S := FExePath + 'First.txt';
      if FileExists(S) then
        AssistantMemoControl_LoadFromFileP(S);
    end;
  except
  end;

  ts := AddMainTab(0, 'Ассистент');
  AssistantAgentControl_Init(ts, AddMessage);

  ts := AddMainTab(0, 'Задания');
  AssistantTasksControl_Init(ts, AddMessage);

  ts := AddMainTab(0, 'Developer');
  AssistantDeveloperControl_Init(ts, AddMessage);

  {// Контрол фреймов
  ts := TTabSheet(AddMainTab(tmUncnown, 'Frames')); // Создаем вкладку
  FFramesControl := TAIFramesControl.Create();
  FFramesControl.Control := ts;
  FFramesControl.Initialize();}

  // Вывод сообщений
  memMessages := TMemo.Create(Self);
  memMessages.Parent := tsMessages;
  memMessages.Align := alClient;
  memMessages.Lines.Add('Рад видеть тебя здесь.');

  // Контрол команд
  AssistantCommandsControl_Init(tsCommands);

  {Refresh();

  ToolBar1 := TToolBar.Create(Self);
  ToolBar1.Parent := Self.pnButtons;

  tbFileNew := TToolButton.Create(ToolBar1);
  tbFileNew.Parent := ToolBar1;
  tbFileNew.Caption := 'New';
  tbFileNew.OnClick := DoFileCreate;

  tbFileOpen := TToolButton.Create(ToolBar1);
  tbFileOpen.Parent := ToolBar1;
  tbFileOpen.Caption := 'Open';
  tbFileOpen.OnClick := DoFileOpen;

  tbFileSave := TToolButton.Create(ToolBar1);
  tbFileSave.Parent := ToolBar1;
  tbFileSave.Caption := 'Save';
  tbFileSave.OnClick := DoFileSave;}


  // Устанавливаем Focus на memInput
//  memInput.SetFocus();

  AddToLog(lgNone, ltNone, '-');
  if Assigned(pr) then
    AddToLog(lgNone, ltNone, 'Assistant '+pr.ProgramVersionStr)
  else
    AddToLog(lgNone, ltNone, 'Assistant');
  AddToLog(lgNone, ltNone, '-');

  DoRefreshClick(Self);
  Result := 0;
end;

procedure TAssistantForm.DoRefreshClick(Sender: TObject);
begin
  {AddMessage(ARL_PREFIX + ARL + ' ' +
    ARL_ASSISTANT_FORM + ' ' +
    ARL_CORE + ' ' +
    ARL_CMD_CORE_GET_MODULES);}
end;

function TAssistantForm.GetTreeItemByNode(Node: TTreeNode): TProfItem;
var
  i: Integer;
begin
  Result := nil;
  for i := 0 to High(FItems) do
  begin
    if FItems[i].TreeNode = Node then
    begin
      Result := FItems[i];
      Exit;
    end;
  end;
end;

procedure TAssistantForm.miHelpAboutClick(Sender: TObject);
begin
  AUi_ExecuteAboutDialog();
end;

{function TAssistantForm.NewTreeItem(Parent: TProfItem; const Caption: WideString): TProfItem;
var
  ptn: TTreeNode;
  tn: TTreeNode;
  i: Integer;
begin
  if Assigned(Parent) then
    ptn := Parent.TreeNode
  else
    ptn := nil;
  //tn := tvObjects.Items.Add(ptn, Caption);
  tn := tvObjects.Items.AddChild(ptn, Caption);
  i := Length(FItems);
  SetLength(FItems, i + 1);
  FItems[i] := TProfItem.Create();
  FItems[i].TreeNode := tn;
  Result := FItems[i];
end;}

end.
