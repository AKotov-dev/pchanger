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
    Image29: TImage;
    Image3: TImage;
    Image30: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    ImageList1: TImageList;
    Label1: TLabel;
    ListBox1: TListBox;
    Panel2: TPanel;
    ScrollBox1: TScrollBox;
    RefreshBtn: TSpeedButton;
    AboutBtn: TSpeedButton;
    Timer2: TTimer;
    ViewBtn: TSpeedButton;
    InstallBtn: TSpeedButton;
    Timer1: TTimer;
    XMLPropStorage1: TXMLPropStorage;
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure Image14Click(Sender: TObject);
    procedure ListBox1DblClick(Sender: TObject);
    procedure RefreshBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure Timer2Timer(Sender: TObject);
    procedure ViewBtnClick(Sender: TObject);
    procedure StartProcess(command: string);
    procedure PreviewPlymouthTheme(ThemeName: string);
    procedure Timer1Timer(Sender: TObject);
    procedure XMLPropStorage1RestoreProperties(Sender: TObject);
    procedure XMLPropStorage1SaveProperties(Sender: TObject);


  private

  public
  var
    a: boolean;  //Показ сообщения перед просмотром
    b: integer; //Счётчик индекса картинок индикатора

  end;

  //Ресурсы перевода
resourcestring
  SChangePlymouthQuery = 'Do you really want to change the Plymouth theme?';
  SViewPlymouthTheme =
    'After displaying the theme, move the mouse to emulate the display progress. Viewing time is 10 seconds.';
  SInstallThemeWarning =
    'Dracut is running!' + LineEnding +
    'The theme installation cannot be interrupted!' + LineEnding +
    LineEnding + 'Please wait for the process to finish!';

var
  MainForm: TMainForm;

implementation

uses about, InstallThemeTDR;

  {$R *.lfm}

  { TMainForm }


procedure TMainForm.PreviewPlymouthTheme(ThemeName: string);
var
  AProcess: TProcess;
begin
  AProcess := TProcess.Create(nil);
  try
    AProcess.Executable := 'bash';
    AProcess.Parameters.Add('-c');
    // Формируем строку скрипта для bash
    AProcess.Parameters.Add(
      'CURRENT_THEME=$(plymouth-set-default-theme); ' +
      'plymouth-set-default-theme ' + ThemeName + '; ' +
      'plymouthd --debug; ' + 'plymouth --show-splash; ' +
      'for ((I=0; I<10; I++)); do sudo plymouth --update=test$I; sleep 1; done; ' +
      'plymouth --quit; plymouth-set-default-theme "$CURRENT_THEME"');

    // Настройки для фонового выполнения, чтобы графический интерфейс Lazarus не зависал
    AProcess.Options := [poNoConsole];
    AProcess.Execute;

  finally
    AProcess.Free;
  end;
end;

//Запуск команд
procedure TMainForm.StartProcess(command: string);
var
  ExProcess: TProcess;
begin
  Application.ProcessMessages;
  ExProcess := TProcess.Create(nil);
  try
    ExProcess.Executable := 'bash';

    ExProcess.Parameters.Add('-c');
    ExProcess.Parameters.Add(command);
    ExProcess.Options := ExProcess.Options + [poWaitOnExit, poUsePipes];
    ExProcess.Execute;

    //Обнвление списка тем
    ListBox1.Items.LoadFromStream(ExProcess.Output);
    ListBox1.Update;
    if ListBox1.Count > 0 then
      ListBox1.ItemIndex := 0;

  finally
    ExProcess.Free;
  end;
end;

//Для открытия формы - перечитываем список тем с задержкой
procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  RefreshBtn.Click;
  Timer1.Enabled := False;
  Screen.Cursor := crDefault;
end;

//Предупреждение о просмотре показывается 1 раз
procedure TMainForm.XMLPropStorage1RestoreProperties(Sender: TObject);
begin
  a := XMLPropStorage1.ReadBoolean('ShowPlymouthMsg', True);
end;

//Предупреждение о просмотре показывается 1 раз
procedure TMainForm.XMLPropStorage1SaveProperties(Sender: TObject);
begin
  XMLPropStorage1.WriteBoolean('ShowPlymouthMsg', a);
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  XMLPropStorage1.Restore;
  MainForm.Caption := Application.Title;
  ScrollBox1.Width := Image8.Left + Image8.Width + 30;
end;

//Поиск в списке по клику на картинке
procedure TMainForm.Image14Click(Sender: TObject);
begin
  ListBox1.ItemIndex := (ListBox1.Items.IndexOf((Sender as TImage).Hint));
end;

//Установка темы двойным щелчком в списке
procedure TMainForm.ListBox1DblClick(Sender: TObject);
begin
  if ListBox1.SelCount <> 0 then
    if MessageDlg(SChangePlymouthQuery, mtConfirmation, [mbYes, mbNo], 0) = mrYes then
      TStartInstallTheme.Create;
end;

//Обновить список тем
procedure TMainForm.RefreshBtnClick(Sender: TObject);
begin
  StartProcess('plymouth-set-default-theme -l');
end;

procedure TMainForm.AboutBtnClick(Sender: TObject);
begin
  MyAboutForm.Show;
end;

//Запуск индикатора
procedure TMainForm.Timer2Timer(Sender: TObject);
var
  Bmp: TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    ImageList1.GetBitmap(b, Bmp);
    Image29.Picture.Assign(Bmp);
    Inc(b);
    if b = ImageList1.Count then b := 0;
  finally
    Bmp.Free;
  end;
end;

//Просмотр темы в реальном времени
procedure TMainForm.ViewBtnClick(Sender: TObject);
begin
  if a then
  begin
    a := False;
    MessageDlg(SViewPlymouthTheme, mtInformation, [mbOK], 0);
  end;

  PreviewPlymouthTheme(ListBox1.Items[ListBox1.ItemIndex]);
end;

procedure TMainForm.FormCreate(Sender: TObject);
var
  bmp: TBitmap;
  WorkDir: string;
begin
  // Устраняем баг иконки приложения
  bmp := TBitmap.Create;
  try
    bmp.PixelFormat := pf32bit;
    bmp.Assign(Image30.Picture.Graphic);
    Application.Icon.Assign(bmp);
  finally
    bmp.Free;
  end;

  //Рабочая директория в профиле
  WorkDir := GetUserDir + '.config/pchanger';

  if not DirectoryExists(WorkDir) then
    ForceDirectories(WorkDir);

  XMLPropStorage1.FileName := WorkDir + '/settings.xml';
end;

//Защита от случайного закрытия формы при работе dracut / установке темы
procedure TMainForm.FormCloseQuery(Sender: TObject; var CanClose: boolean);
var
  S: string;
begin
  RunCommand('pgrep', ['dracut'], S);

  if Trim(S) <> '' then
  begin
    MessageDlg(SInstallThemeWarning, mtWarning, [mbOK], 0);
    CanClose := False;
  end;
end;

end.
