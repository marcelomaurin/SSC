unit setssc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, IniFiles;

type
  TSetSSC = class
  private
    FConfigPath: string;
    FPort: string;
    FBaudIndex: Integer;
    FDataBitsIndex: Integer;
    FParityIndex: Integer;
    FStopBitsIndex: Integer;
    FPosX: Integer;
    FPosY: Integer;
    FWidth: Integer;
    FHeight: Integer;
    procedure SetDefaults;
  public
    constructor Create;
    procedure Load;
    procedure Save;

    property COMPORT: string read FPort write FPort;
    property BAUDRATE: Integer read FBaudIndex write FBaudIndex;
    property DATABIT: Integer read FDataBitsIndex write FDataBitsIndex;
    property PARIDADE: Integer read FParityIndex write FParityIndex;
    property STOPBIT: Integer read FStopBitsIndex write FStopBitsIndex;
    property PosX: Integer read FPosX write FPosX;
    property PosY: Integer read FPosY write FPosY;
    property WindowWidth: Integer read FWidth write FWidth;
    property WindowHeight: Integer read FHeight write FHeight;
  end;

implementation

procedure TSetSSC.SetDefaults;
begin
  FPort := '';
  FBaudIndex := 5;      { 9600 }
  FDataBitsIndex := 0;  { 8 bits }
  FParityIndex := 0;    { none }
  FStopBitsIndex := 0;  { 1 stop bit }
  FPosX := -1;
  FPosY := -1;
  FWidth := 1100;
  FHeight := 700;
end;

constructor TSetSSC.Create;
var
  ConfigDir: string;
begin
  inherited Create;
  SetDefaults;

  ConfigDir := GetAppConfigDir(False);
  if not DirectoryExists(ConfigDir) then
    ForceDirectories(ConfigDir);

  FConfigPath := IncludeTrailingPathDelimiter(ConfigDir) + 'ssc3.ini';
  Load;
end;

procedure TSetSSC.Load;
var
  Ini: TIniFile;
begin
  if not FileExists(FConfigPath) then
    Exit;

  Ini := TIniFile.Create(FConfigPath);
  try
    FPort := Ini.ReadString('serial', 'port', FPort);
    FBaudIndex := Ini.ReadInteger('serial', 'baud_index', FBaudIndex);
    FDataBitsIndex := Ini.ReadInteger('serial', 'data_bits_index', FDataBitsIndex);
    FParityIndex := Ini.ReadInteger('serial', 'parity_index', FParityIndex);
    FStopBitsIndex := Ini.ReadInteger('serial', 'stop_bits_index', FStopBitsIndex);

    FPosX := Ini.ReadInteger('window', 'left', FPosX);
    FPosY := Ini.ReadInteger('window', 'top', FPosY);
    FWidth := Ini.ReadInteger('window', 'width', FWidth);
    FHeight := Ini.ReadInteger('window', 'height', FHeight);
  finally
    Ini.Free;
  end;

  if not (FBaudIndex in [0..12]) then FBaudIndex := 5;
  if not (FDataBitsIndex in [0..3]) then FDataBitsIndex := 0;
  if not (FParityIndex in [0..4]) then FParityIndex := 0;
  if not (FStopBitsIndex in [0..1]) then FStopBitsIndex := 0;
  if FWidth < 800 then FWidth := 1100;
  if FHeight < 500 then FHeight := 700;
end;

procedure TSetSSC.Save;
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FConfigPath);
  try
    Ini.WriteString('serial', 'port', FPort);
    Ini.WriteInteger('serial', 'baud_index', FBaudIndex);
    Ini.WriteInteger('serial', 'data_bits_index', FDataBitsIndex);
    Ini.WriteInteger('serial', 'parity_index', FParityIndex);
    Ini.WriteInteger('serial', 'stop_bits_index', FStopBitsIndex);

    Ini.WriteInteger('window', 'left', FPosX);
    Ini.WriteInteger('window', 'top', FPosY);
    Ini.WriteInteger('window', 'width', FWidth);
    Ini.WriteInteger('window', 'height', FHeight);
    Ini.UpdateFile;
  finally
    Ini.Free;
  end;
end;

end.
