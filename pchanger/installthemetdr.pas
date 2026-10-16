unit InstallThemeTDR;

{$mode objfpc}{$H+}

interface

uses
  Classes, Process, SysUtils, Forms, Controls;

type
  TStartInstallTheme = class(TThread)
  private
    FThemeName: string;

  protected
    procedure Execute; override;
    procedure ShowProgress;
    procedure HideProgress;
  public
    constructor Create;
    destructor Destroy; override;

  end;

implementation

uses Unit1;

  { TRD }

constructor TStartInstallTheme.Create;
begin
  inherited Create(False); // запускаем поток сразу
  FreeOnTerminate := True; // освобождение автоматически
  FThemeName := MainForm.ListBox1.Items[MainForm.ListBox1.ItemIndex];
end;

destructor TStartInstallTheme.Destroy;
begin
  inherited Destroy;
end;

//Запуск установки
procedure TStartInstallTheme.Execute;
var
  ExProcess: TProcess;
begin
  try
    Synchronize(@ShowProgress);

    //Рабочий процесс
    ExProcess := TProcess.Create(nil);

    ExProcess.Executable := 'bash';
    ExProcess.Parameters.Add('-c');

    ExProcess.Options := [poWaitOnExit];

    //Команда
    ExProcess.Parameters.Add('plymouth-set-default-theme -R ' + FThemeName);

    Exprocess.Execute;

  finally
    Synchronize(@HideProgress);
    ExProcess.Free;
  end;
end;

//Запустить индикатор
procedure TStartInstallTheme.ShowProgress;
begin
  with MainForm do
  begin
    ListBox1.Visible := False;
    ScrollBox1.Enabled := False;
    Panel2.Enabled := False;
    Timer2.Enabled := True;
  end;
end;

//Остановить индикатор
procedure TStartInstallTheme.HideProgress;
begin
  with MainForm do
  begin
    Timer2.Enabled := False;
    ScrollBox1.Enabled := True;
    Panel2.Enabled := True;
    ListBox1.Visible := True;
  end;
end;

end.
