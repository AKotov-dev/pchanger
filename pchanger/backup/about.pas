unit about;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, XMLPropStorage, LCLTranslator, DefaultTranslator;

type

  { TMyAboutForm }

  TMyAboutForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    AboutXMLPropStorage1: TXMLPropStorage;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private

  public

  end;

var
  MyAboutForm: TMyAboutForm;

implementation

uses unit1;

{$R *.lfm}

{ TMyAboutForm }

procedure TMyAboutForm.Button1Click(Sender: TObject);
begin
  MyAboutForm.Close;
end;

procedure TMyAboutForm.FormCreate(Sender: TObject);
begin
  AboutXMLPropStorage1.FileName := MainForm.XMLPropStorage1.FileName;
end;

end.
