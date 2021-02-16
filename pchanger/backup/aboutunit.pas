unit aboutunit;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, StdCtrls,
  ExtCtrls, XMLPropStorage;

type

  { TAboutForm }

  TAboutForm = class(TForm)
    Bevel1: TBevel;
    Button1: TButton;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
  private

  public

  end;

var
  AboutForm: TAboutForm;

implementation

uses unit1;

{$R *.lfm}

end.
