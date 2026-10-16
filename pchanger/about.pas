unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls;

type

  { TMyAboutForm }

  TMyAboutForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    procedure Button1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private

  public

  end;

var
  MyAboutForm: TMyAboutForm;

implementation

uses Unit1;


  {$R *.lfm}

  { TMyAboutForm }

procedure TMyAboutForm.Button1Click(Sender: TObject);
begin
  MyAboutForm.Close;
end;

procedure TMyAboutForm.FormShow(Sender: TObject);
begin
  Label1.Caption := Application.Title;

  Width := Label2.Left + Label2.Width + 40;
  Height := Button1.Top + Button1.Height + 10;

  //В центр MainForm
  Left := MainForm.Left + MainForm.Width div 2 - Width div 2;
  Top := MainForm.Top + MainForm.Height div 2 - Height div 2;
end;

end.
