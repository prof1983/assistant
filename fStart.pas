{**
@Abstract Первая форма при запуске системы
@Author Prof1983 <prof1983@ya.ru>
@Created 04.08.2007
@LastMod 10.07.2012
}
unit fStart;

interface

uses
  Classes, ComCtrls, Controls, Dialogs, ExtCtrls, Graphics, Forms, IniFiles, {Jpeg,}
  StdCtrls, SysUtils, Vcl.Imaging.jpeg;

type
  TStartForm = class(TForm)
    LogRichEdit: TRichEdit;
    Panel1: TPanel;
    Image1: TImage;
    procedure FormPaint(Sender: TObject);
  private
    FIsPainted: Boolean;
    FTimer: TTimer;
    procedure DoTimer(Sender: TObject);
  public
    procedure DoCreate(); override;
    procedure DoDestroy(); override;
    class function AddToLog(Msg: WideString): Integer; 
  end;

implementation

{$R *.dfm}

uses
  AssistantProgram, fAssistant;

var
  StartForm: TStartForm;

{ TStartForm }

class function TStartForm.AddToLog(Msg: WideString): Integer;
begin
  Result := 0;
  if Assigned(StartForm) then
  try
    Result := StartForm.LogRichEdit.Lines.Add(Msg);
  except
  end;
  Application.ProcessMessages();
end;

procedure TStartForm.DoCreate();
begin
  StartForm := Self;

  Panel1.Top := 2;
  Panel1.Left := 2;
  Panel1.Width := Width - 4;

  LogRichEdit.Top := Panel1.Height + 4;
  LogRichEdit.Left := 2;
  LogRichEdit.Width := Width - 4;
  LogRichEdit.Height := Height - LogRichEdit.Top - 2;

  FTimer := TTimer.Create(Self);
  FTimer.Interval := 100;
  FTimer.OnTimer := DoTimer;
  FTimer.Enabled := True;
end;

procedure TStartForm.DoDestroy();
begin
  StartForm := nil;
  inherited;
end;

procedure TStartForm.DoTimer(Sender: TObject);
var
  FStartLoad: TDateTime;
begin
  if FIsPainted then
  begin
    FTimer.Enabled := False;
    FTimer.Free();
    FTimer := nil;

    FStartLoad := Now();
    while (Now() - FStartLoad < 1/24/60/60) do
    begin
      Application.ProcessMessages();
      Sleep(50);
    end;

    Hide();
  end;
end;

procedure TStartForm.FormPaint(Sender: TObject);
begin
  FIsPainted := True;
end;

end.
