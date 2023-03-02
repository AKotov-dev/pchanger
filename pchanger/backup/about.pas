unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, LCLTranslator, DefaultTranslator;

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

{$R *.lfm}

{ TMyAboutForm }

procedure TMyAboutForm.Button1Click(Sender: TObject);
begin
  MyAboutForm.Close;
end;

procedure TMyAboutForm.FormShow(Sender: TObject);
begin
  MyAboutForm.Width := Label2.Left + Label2.Width + 40;
  MyAboutForm.Height := Button1.Top + Button1.Height + 10;
end;

end.
