unit funcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils
  {$IFDEF UNIX}, BaseUnix {$ENDIF}
  {$IFDEF WINDOWS}, Windows {$ENDIF};

function GetSerialPorts: TStringList;
function NormalizeSerialPort(const APort: string): string;

implementation

function NormalizeSerialPort(const APort: string): string;
begin
  Result := Trim(APort);
  {$IFDEF WINDOWS}
  Result := UpperCase(Result);
  {$ENDIF}
end;

procedure AddPort(AList: TStringList; const APort: string);
var
  P: string;
begin
  P := NormalizeSerialPort(APort);
  if (P <> '') and (AList.IndexOf(P) < 0) then
    AList.Add(P);
end;

{$IFDEF UNIX}
procedure AddUnixPattern(AList: TStringList; const APattern: string;
  ARequireSysDevice: Boolean);
var
  SR: TSearchRec;
  BasePath, FullPath, SysDevice: string;
begin
  BasePath := ExtractFilePath(APattern);
  if FindFirst(APattern, faAnyFile, SR) = 0 then
  try
    repeat
      if (SR.Name = '.') or (SR.Name = '..') then
        Continue;

      FullPath := BasePath + SR.Name;

      { ttyS* pode conter dezenas de portas lógicas inexistentes.
        Para estas portas exigimos um dispositivo real exposto pelo sysfs. }
      if ARequireSysDevice then
      begin
        SysDevice := '/sys/class/tty/' + SR.Name + '/device';
        if not DirectoryExists(SysDevice) then
          Continue;
      end;

      AddPort(AList, FullPath);
    until FindNext(SR) <> 0;
  finally
    FindClose(SR);
  end;
end;
{$ENDIF}

function GetSerialPorts: TStringList;
{$IFDEF WINDOWS}
var
  I: Integer;
  PortName: string;
  Target: array[0..1023] of Char;
{$ENDIF}
begin
  Result := TStringList.Create;
  Result.CaseSensitive := False;
  Result.Duplicates := dupIgnore;

  {$IFDEF WINDOWS}
  { QueryDosDevice consulta as portas realmente registradas no Windows
    naquele momento. Assim não precisamos preencher COM1..COM256 no ComboBox. }
  for I := 1 to 256 do
  begin
    PortName := 'COM' + IntToStr(I);
    FillChar(Target, SizeOf(Target), 0);
    if QueryDosDevice(PChar(PortName), PChar(@Target[0]), Length(Target)) <> 0 then
      AddPort(Result, PortName);
  end;
  {$ENDIF}

  {$IFDEF UNIX}
  { USB/CDC são os casos mais comuns para Arduino, ESP32 e conversores USB/serial. }
  AddUnixPattern(Result, '/dev/ttyUSB*', False);
  AddUnixPattern(Result, '/dev/ttyACM*', False);

  { Seriais nativas comuns em Raspberry Pi e outros SBCs. }
  AddUnixPattern(Result, '/dev/ttyAMA*', False);
  AddUnixPattern(Result, '/dev/ttyS*', True);

  { Bluetooth serial, quando presente. }
  AddUnixPattern(Result, '/dev/rfcomm*', False);

  Result.Sort;
  {$ENDIF}
end;

end.
