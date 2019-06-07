unit hexlib;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;

function StringToHex(S: String): string;
function StringToHexMask(S: String; delimitador : string): string;
function HexToString(H: String): String;

implementation

function StringToHex(S: String): string;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (S) do
    Result:= Result+IntToHex(ord(S[i]),2);
end;

function StringToHexMask(S: String; delimitador : string): string;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (S) do
    Result:= Result+IntToHex(ord(S[i]),2)+delimitador;
end;

function HexToString(H: String): String;
var I: Integer;
begin
  Result:= '';
  for I := 1 to length (H) div 2 do
    Result:= Result+Char(StrToInt('$'+Copy(H,(I-1)*2+1,2)));
end;

end.

