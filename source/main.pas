unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  RegExpr, LCLIntf;

type

  { TForm1 }

  TForm1 = class(TForm)
    GithubButton: TButton;
    Legend2: TLabel;
    RegexInput: TEdit;
    ErrorLabel: TLabel;
    Legend: TLabel;
    MatchesLabel: TLabel;
    MatchBox: TListBox;
    RegexSourceText: TMemo;
    PanelSplitter: TSplitter;
    procedure GithubButtonClick(Sender: TObject);
    procedure RegexInputChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RegexSourceTextChange(Sender: TObject);
    procedure processRegex;
  private

  public

  end;

var
  Form1: TForm1;
  re: TRegExpr;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.processRegex;
begin
  ErrorLabel.Caption := '';
  MatchBox.Clear;

  try
    try
      re := TRegExpr.Create(trim(RegexInput.Caption));
      if re.Exec(trim(RegexSourceText.Text)) then begin
        // Add the first match
        MatchBox.AddItem(re.Match[1], nil);

        // Add subsequent matches
        while re.ExecNext do
          MatchBox.AddItem(re.Match[1], nil);

      end;
    finally
      re.Free;
    end;
  except
    on E: Exception do
      ErrorLabel.Caption := E.Message;
  end;
end;

procedure TForm1.RegexInputChange(Sender: TObject);
begin
  processRegex;
end;

procedure TForm1.GithubButtonClick(Sender: TObject);
begin
  OpenURL('https://github.com/MFernstrom/rTest');
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  ErrorLabel.Caption := '';
  processRegex;
end;

procedure TForm1.RegexSourceTextChange(Sender: TObject);
begin
  processRegex;
end;

end.

