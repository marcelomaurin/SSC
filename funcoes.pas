unit funcoes;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils
  {$IFDEF UNIX},BaseUnix {$ENDIF}
  {$IFDEF WINDOWS},Windows, Registry {$ENDIF}
  ;

function GetSerialPorts: TStringList;
Function RetiraInfo(Value : string): string;
function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
function iif(condicao : boolean; verdade : variant; falso: variant):variant;

implementation

function GetSerialPorts: TStringList;
{$IFDEF UNIX}
var
  Info: TSearchRec;
{$ENDIF}
{$IFDEF WINDOWS}
var
  Reg: TRegistry;
  ValueNames: TStringList;
  ValueName: string;
  i: Integer;
{$ENDIF}
begin
  Result := TStringList.Create;
  {$IFDEF UNIX}
  if FindFirst('/dev/ttyS*', faAnyFile and not faDirectory, Info) = 0 then
  begin
    repeat
      Result.Add('/dev/' + Info.Name);
    until FindNext(Info) <> 0;
    FindClose(Info);
  end;
  {$ENDIF}
  {$IFDEF WINDOWS}
  Reg := TRegistry.Create;
  try
    Reg.RootKey := HKEY_LOCAL_MACHINE;
    if Reg.OpenKeyReadOnly('HARDWARE\DEVICEMAP\SERIALCOMM') then
    begin
      ValueNames := TStringList.Create;
      try
        Reg.GetValueNames(ValueNames);
        for i := 0 to ValueNames.Count - 1 do
        begin
          ValueName := ValueNames[i];
          Result.Add(Reg.ReadString(ValueName));
        end;
      finally
        ValueNames.Free;
      end;
      Reg.CloseKey;
    end;
  finally
    Reg.Free;
  end;
  {$ENDIF}
end;

function iif(condicao : boolean; verdade : variant; falso: variant):variant;
begin
     if condicao then
     begin
          result := verdade;
     end
     else
     begin
       result := falso
     end;
end;

//Retira o bloco de informação
Function RetiraInfo(Value : string): string;
var
  posicao : integer;
  resultado : string;
begin
     resultado := '';
     posicao := pos(':',value);
     if(posicao >-1) then
     begin
          resultado := copy(value,posicao+1,length(value));
     end;
     result := resultado;
end;

function BuscaChave( lista : TStringList; Ref: String; var posicao:integer): boolean;
var
  contador : integer;
  maximo : integer;
  item : string;
  indo : integer;
  resultado : boolean;
begin
     maximo := lista.Count-1;
     resultado := false;
     for contador := 0 to maximo do
     begin
       item := lista.Strings[contador];
       indo := pos(Ref,item);
       if (indo > 0) then
       begin
            posicao := contador;
            resultado := true;
            break;
       end;
     end;
     result := resultado;
end;

end.

