unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  RegExpr, LCLIntf, SynEdit;

type

  { TrTestForm }

  TrTestForm = class(TForm)
    FlagsLabel: TLabel;
    DocumentationLabel: TLabel;
    ModI: TCheckBox;
    ModS: TCheckBox;
    ModG: TCheckBox;
    ModM: TCheckBox;
    MatchesCountLabel: TLabel;
    Legend2: TLabel;
    RegexInput: TEdit;
    ErrorLabel: TLabel;
    Legend: TLabel;
    MatchesLabel: TLabel;
    MatchBox: TListBox;
    RegexSourceText: TMemo;
    PanelSplitter: TSplitter;
    procedure DocumentationLabelClick(Sender: TObject);
    procedure ModHasChanged(Sender: TObject);
    procedure RegexInputChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure RegexSourceTextChange(Sender: TObject);
    procedure processRegex;
  private

  public

  end;

var
  rTestForm: TrTestForm;
  re: TRegExpr;

implementation

{$R *.lfm}

{ TrTestForm }

procedure TrTestForm.processRegex;
begin
  ErrorLabel.Caption := '';
  MatchBox.Clear;

  MatchesCountLabel.Caption := '0';

  try
    try
      re := TRegExpr.Create(trim(RegexInput.Caption));
      re.ModifierI := ModI.Checked;
      re.ModifierS := ModS.Checked;
      re.ModifierG := ModG.Checked;
      re.ModifierM := ModM.Checked;

      if re.Exec(trim(RegexSourceText.Text)) then begin
        // Add the first match
        MatchBox.AddItem(re.Match[1], nil);

        // Add subsequent matches
        while re.ExecNext do begin
          MatchBox.AddItem(re.Match[1], nil);
        end;
      end;
      MatchesCountLabel.Caption := IntToStr(MatchBox.Count);
    finally
      re.Free;
    end;
  except
    on E: Exception do
      ErrorLabel.Caption := E.Message;
  end;
end;

procedure TrTestForm.RegexInputChange(Sender: TObject);
begin
  processRegex;
end;

procedure TrTestForm.DocumentationLabelClick(Sender: TObject);
begin
  OpenURL('https://github.com/MFernstrom/rTest');
end;

procedure TrTestForm.ModHasChanged(Sender: TObject);
begin
  processRegex;
end;

procedure TrTestForm.FormCreate(Sender: TObject);
begin
  ErrorLabel.Caption := '';
  MatchesCountLabel.Caption := '0';
  processRegex;
end;

procedure TrTestForm.RegexSourceTextChange(Sender: TObject);
begin
  processRegex;
end;

end.

