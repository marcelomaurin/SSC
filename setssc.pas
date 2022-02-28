//Objetivo construir os parametros de setup da classe principal
//Criado por Marcelo Maurin Martins
//Data:18/08/2019

unit setssc;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, funcoes;

const filename = 'ssc.cfg';


type
  { TfrmMenu }

  { TSetssc }

  TSetssc = class(TObject)
    constructor create();
    destructor destroy();
  private
        arquivo :Tstringlist;
        ckdevice : boolean;
        FPosX : integer;
        FPosY : integer;
        FHide : boolean;
        FEXEC : boolean;
        FCOM  : string;
        FBAUD : integer;

        procedure Default();
        procedure SetPOSX(value : integer);
        procedure SetPOSY(value : integer);
        procedure SetDevice(const Value : Boolean);
        procedure SetHide(value : boolean);
        procedure SetEXEC(value : boolean);
        procedure SetCOM(value : string);
        procedure SetBAUD(value : integer);

  public
        procedure SalvaContexto();
        Procedure CarregaContexto();
        property device : boolean read ckdevice write SetDevice;
        property posx : integer read FPosX write SetPOSX;
        property posy : integer read FPosY write SetPOSY;
        property Hide : boolean read FHide write SetHide;
        property EXEC : boolean read FEXEC write SetEXEC;
        property COMPORT : string read FCOM write SetCOM;
        property BAUDRATE :integer read FBAUD write SetBAUD;
  end;

  var
    FSetssc : TSetssc;

implementation

procedure TSetssc.SetPOSX(value : integer);
begin
    Fposx := value;
end;

procedure TSetssc.SetPOSY(value : integer);
begin
    FposY := value;
end;


procedure TSetssc.SetDevice(const Value : Boolean);
begin
  ckdevice := Value;
end;

procedure TSetssc.SetHide(value : boolean);
begin
    FHide := value;
end;

procedure TSetssc.SetEXEC(value : boolean);
begin
    FEXEC := value;
end;

procedure TSetssc.SetCOM(value: string);
begin
  FCOM := value;
end;

procedure TSetssc.SetBAUD(value: integer);
begin
  FBAUD := value;
end;


//Valores default do codigo
procedure TSetssc.Default();
begin
    ckdevice := false;
    FEXEC := false;
    FHide:= false;
    {$IFDEF LINUX}
    FCOM := '':='/dev/ttyS0';
    {$ENDIF}
    {$IFDEF WINDOWS}
    FCOM :='COM13';
    {$ENDIF}
    FBAUD := 3; (* 2400 *)

end;

procedure TSetssc.CarregaContexto();
var
  posicao: integer;
begin
    if  BuscaChave(arquivo,'DEVICE:',posicao) then
    begin
      device := (RetiraInfo(arquivo.Strings[posicao])='1');
    end;
    if  BuscaChave(arquivo,'POSX:',posicao) then
    begin
      FPOSX := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'POSY:',posicao) then
    begin
      FPOSY := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'HIDE:',posicao) then
    begin
      FHide := StrToBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'EXEC:',posicao) then
    begin
      FEXEC := strtoBool(RetiraInfo(arquivo.Strings[posicao]));
    end;
    if  BuscaChave(arquivo,'COMPORT:',posicao) then
    begin
      FCOM := RetiraInfo(arquivo.Strings[posicao]);
    end;
    if  BuscaChave(arquivo,'BAUDRATE:',posicao) then
    begin
      FBAUD := strtoint(RetiraInfo(arquivo.Strings[posicao]));
    end;

end;

//Metodo construtor
constructor TSetssc.create();
begin
  arquivo := TStringList.create();
  if (FileExists(filename)) then
  begin
    arquivo.LoadFromFile(filename);
    CarregaContexto();
  end
  else
  begin
    default();
  end;
end;


procedure TSetssc.SalvaContexto();
begin
  arquivo.Clear;
  arquivo.Append('DEVICE:'+iif(ckdevice,'1','0'));
  arquivo.Append('POSX:'+inttostr(FPOSX));
  arquivo.Append('POSY:'+inttostr(FPOSY));
  arquivo.Append('HIDE:'+booltostr(FHide));
  arquivo.Append('EXEC:'+booltostr(FEXEC));
  arquivo.Append('COMPORT:'+FCOM);
  arquivo.Append('BAUDRATE:'+ inttostr(FBAUD));

  arquivo.SaveToFile(filename);
end;

destructor TSetssc.destroy();
begin
  SalvaContexto();
  arquivo.free;
end;

end.

