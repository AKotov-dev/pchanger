unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, XMLPropStorage, ExtCtrls, Buttons, Process,
  DefaultTranslator, PropertyStorage;

type

  { TMainForm }

  TMainForm = class(TForm)
    Image1: TImage;
    Image10: TImage;
    Image11: TImage;
    Image12: TImage;
    Image13: TImage;
    Image14: TImage;
    Image15: TImage;
    Image16: TImage;
    Image17: TImage;
    Image18: TImage;
    Image19: TImage;
    Image2: TImage;
    Image20: TImage;
    Image21: TImage;
    Image22: TImage;
    Image23: TImage;
    Image24: TImage;
    Image25: TImage;
    Image26: TImage;
    Image27: TImage;
    Image28: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Label1: TLabel;
    ListBox1: TListBox;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    SpeedButton1: TSpeedButton;
    SpeedButton2: TSpeedButton;
    SpeedButton3: TSpeedButton;
    SpeedButton4: TSpeedButton;
    Splitter1: TSplitter;
    Timer1: TTimer;
    XMLPropStorage1: TXMLPropStorage;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure SpeedButton2Click(Sender: TObject);
    procedure SpeedButton3Click(Sender: TObject);
    procedure StartProcess(command, terminal: string);
    procedure Timer1Timer(Sender: TObject);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);
  private

  public
  var
    a: boolean;  //Показ сообщения перед просмотром

  end;

//Ресурсы перевода
resourcestring
  SChangePlymouthQuery = 'Do you really want to change the Plymouth theme?';
  SViewPlymouthTheme =
    'After displaying the theme, move the mouse to emulate the display progress. Viewing time is 10 seconds.';

var
  MainForm: TMainForm;

implementation

uses about;

{$R *.lfm}

{ TMainForm }

procedure TMainForm.StartProcess(command, terminal: string);
var
  ExProcess: TProcess;
begin
  Screen.Cursor := crHourGlass;
  ExProcess := TProcess.Create(nil);
  try
    ExProcess.Executable := terminal;  //sh или xterm
    if terminal <> 'sh' then
    begin
      ExProcess.Parameters.Add('-g');
      ExProcess.Parameters.Add('110x45');
      ExProcess.Parameters.Add('-e');
      //   ExProcess.Options := ExProcess.Options + [poWaitOnExit];
      ExProcess.Parameters.Add(command);
      ExProcess.Execute;
    end
    else
    begin
      ExProcess.Parameters.Add('-c');
      ExProcess.Parameters.Add(command);
      ExProcess.Options := ExProcess.Options + [poWaitOnExit, poUsePipes, poNoConsole];
      ExProcess.Execute;

      ListBox1.Items.LoadFromStream(ExProcess.Output);
    end;

  finally
    ExProcess.Free;
    Screen.Cursor := crDefault;
  end;
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  SpeedButton1.Click;
  Timer1.Enabled := False;
  Screen.Cursor := crDefault;
end;

procedure TMainForm.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  a := XMLPropStorage1.ReadBoolean('ShowPlymouthMsg', True);
end;

procedure TMainForm.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.WriteBoolean('ShowPlymouthMsg', a);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  MainForm.Caption := Application.Title;
end;

procedure TMainForm.Image14Click(Sender: TObject);
begin
  ListBox1.ItemIndex := (ListBox1.Items.IndexOf((Sender as TImage).Hint));
end;

procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
  if MessageDlg(SChangePlymouthQuery, mtConfirmation, [mbYes, mbNo], 0) = mrYes then

    StartProcess('plymouth-set-default-theme -R ' +
      ListBox1.Items[ListBox1.ItemIndex], 'xterm');
end;

procedure TMainForm.SpeedButton1Click(Sender: TObject);
begin
  StartProcess('plymouth-set-default-theme -l', 'sh');
  if ListBox1.Count > 0 then
    ListBox1.ItemIndex := 0;
end;

procedure TMainForm.SpeedButton2Click(Sender: TObject);
begin
  MyAboutForm.Show;
end;

procedure TMainForm.SpeedButton3Click(Sender: TObject);
begin
  if a then
  begin
    a := False;
    MessageDlg(SViewPlymouthTheme, mtInformation, [mbOK], 0);
  end;

  StartProcess('sh -c "echo ' + '''' + 'Preparing Plymouth theme...' +
    '''' + '; plymouth-set-default-theme ' + ListBox1.Items[ListBox1.ItemIndex] +
    '; plymouthd; plymouth --show-splash; for ((I=0; I<10; I++)); do plymouth --update=test$I; '
    + 'sleep 1; done; plymouth quit"', 'xterm');
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  WorkDir: string;
begin
  //Рабочая директория в профиле
  WorkDir := GetEnvironmentVariable('HOME') + '/.config/pchanger';

  if not DirectoryExists(WorkDir) then
    StartProcess('mkdir -p ' + WorkDir, 'sh');

  XMLPropStorage1.FileName := WorkDir + '/settings.xml';
end;


end.
