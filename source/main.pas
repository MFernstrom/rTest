unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  RegExpr, LCLIntf;

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
    procedure MatchBoxSelectionChange(Sender: TObject; User: boolean);
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
  matchTrack: array of integer;

implementation

{$R *.lfm}

{ TrTestForm }

procedure TrTestForm.processRegex;
var
  counter: Integer;
begin
  ErrorLabel.Caption := '';
  MatchBox.Clear;

  MatchesCountLabel.Caption := '0';

  setLength(matchTrack, 1);

  try
    try
      re := TRegExpr.Create(trim(RegexInput.Caption));
      re.ModifierI := ModI.Checked;
      re.ModifierS := ModS.Checked;
      re.ModifierG := ModG.Checked;
      re.ModifierM := ModM.Checked;

      counter := 1;

      if re.Exec(trim(RegexSourceText.Text)) then begin
        // Add the first match
        if length(re.Match[1]) > 0 then begin
          MatchBox.AddItem(re.Match[1], nil);

          matchTrack[0] := re.MatchPos[1];

          // Add subsequent matchTrack
          while re.ExecNext do begin
            MatchBox.AddItem(re.Match[1], nil);
            setLength(matchTrack, counter+1);
            matchTrack[counter] := re.MatchPos[1];
            counter := counter + 1;
          end;
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

procedure TrTestForm.MatchBoxSelectionChange(Sender: TObject; User: boolean);
var
  chosenText: String;
begin
  if MatchBox.ItemIndex > -1 then begin
    chosenText := MatchBox.Items[MatchBox.ItemIndex];
    RegexSourceText.SelStart := matchTrack[MatchBox.ItemIndex] -1;
    RegexSourceText.SelLength := Length(chosenText);
    RegexSourceText.SetFocus;
  end;
end;

procedure TrTestForm.ModHasChanged(Sender: TObject);
begin
  processRegex;
end;

procedure TrTestForm.FormCreate(Sender: TObject);
begin
  ErrorLabel.Caption := '';
  MatchesCountLabel.Caption := '0';
  setlength(matchTrack,1);
  processRegex;
end;

procedure TrTestForm.RegexSourceTextChange(Sender: TObject);
begin
  processRegex;
end;

end.

