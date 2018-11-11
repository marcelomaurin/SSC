unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Menus, SdpoSerial, DataPortIP, SynMemo,
  SynEdit, hexlib, types, finds, SynHighlighterAny, SynHighlighterPo,
  SynHighlighterPas, SynHighlighterCpp, LCLType;

type

  { TForm1 }

  TForm1 = class(TForm)
    BitBtn1: TBitBtn;
    BitBtn2: TBitBtn;
    BitBtn3: TBitBtn;
    BitBtn4: TBitBtn;
    btEnviar: TButton;
    btEnter: TButton;
    cbDatabit: TComboBox;
    cbBaudrate: TComboBox;
    cbParidade: TComboBox;
    cbStopbit: TComboBox;
    ckRepeaterSerial: TCheckBox;
    ckConnection: TCheckBox;
    DataPortTCP1: TDataPortTCP;
    edEnviar: TEdit;
    edPortSocket: TEdit;
    edURL: TEdit;
    edPort: TEdit;
    edPort1: TEdit;
    FindDialog1: TFindDialog;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label17: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    lstFind: TListBox;
    MainMenu1: TMainMenu;
    Memo1: TSynEdit;
    Memo2: TSynEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    cbTipo: TPageControl;
    popFind: TPopupMenu;
    Process1: TProcess;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    SdpoSerial1: TSdpoSerial;
    SdpoSerial2: TSdpoSerial;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tbSerial: TTabSheet;
    tbSobre: TTabSheet;
    tbConfig: TTabSheet;
    ToggleBox1: TToggleBox;
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
    procedure BitBtn3Click(Sender: TObject);
    procedure BitBtn4Click(Sender: TObject);
    procedure btDevicesClick(Sender: TObject);
    procedure btEnterClick(Sender: TObject);
    procedure btEnviarClick(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btZeraClick(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
    procedure DataPortTCP1Close(Sender: TObject);
    procedure DataPortTCP1DataAppear(Sender: TObject);
    procedure DataPortTCP1Open(Sender: TObject);
    procedure edPortChange(Sender: TObject);
    procedure FindDialog1Find(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Label11Click(Sender: TObject);
    procedure Label12Click(Sender: TObject);
    procedure Label14Click(Sender: TObject);
    procedure lstFindClick(Sender: TObject);
    procedure Memo1Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem6Click(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SdpoSerial1RxData(Sender: TObject);
    procedure SdpoSerial2RxData(Sender: TObject);
    procedure tbConfigContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbSerialContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure timerBalancaTimer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
  private
    { private declarations }
    {$IFDEF WINDOWS}
    FPos : integer;
    procedure Pesquisar(Sender: TObject);
    procedure setSelLength(var textComponent:TSynEdit; newValue:integer);
    procedure ChamaWindows();
    procedure AudioWindows();
    {$ENDIF}
    {$IFDEF LINUX}
    procedure ChamaLinux();
    procedure AudioLinux();

    {$ENDIF}
    function strtohex(info : string) : string;
    function hextostr(info: string): string;
  public
    { public declarations }
    Arquivo : String;
    strFind : string;
  end; 

var
  Form1: TForm1; 

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.BitBtn1Click(Sender: TObject);
begin
  SdpoSerial1.Active:=false;
  SdpoSerial1.Device:= edPort.Text;
  SdpoSerial1.DataBits:=  TDataBits(cbDatabit.ItemIndex);
  SdpoSerial1.BaudRate:= TBaudRate( cbBaudrate.ItemIndex);
  SdpoSerial1.Parity:= TParity(cbParidade.ItemIndex);
  SdpoSerial1.StopBits:= TStopBits(cbStopbit.ItemIndex);

  SdpoSerial1.Active:=true;
end;

procedure TForm1.BitBtn2Click(Sender: TObject);
begin
  SdpoSerial1.Close;
  if DataPortTCP1.Active then
  begin
     DataPortTCP1.Close();
  end;
end;

procedure TForm1.BitBtn3Click(Sender: TObject);
begin
    SdpoSerial2.Close;
end;

procedure TForm1.BitBtn4Click(Sender: TObject);
begin
  SdpoSerial2.Active:=false;
  SdpoSerial2.Device:= edPort1.Text;
  SdpoSerial2.DataBits:=  TDataBits(cbDatabit.ItemIndex);
  SdpoSerial2.BaudRate:= TBaudRate( cbBaudrate.ItemIndex);
  SdpoSerial2.Parity:= TParity(cbParidade.ItemIndex);
  SdpoSerial2.StopBits:= TStopBits(cbStopbit.ItemIndex);

  SdpoSerial2.Active:=true;
end;


{$IFDEF LINUX}
//Chama Comunicacao com Linux para ver devices
procedure TForm1.ChamaLinux();
var
   s : ansistring;
begin
     //if RunCommand('/bin/bash',['-c', 'dmesg |grep -i ttyS'],s) then
     begin
        Memo1.Lines.Text:=s;
     end;

end;
{$ENDIF}

{$IFDEF WINDOWS}
//Chama Comunicacao com Windows
procedure TForm1.ChamaWindows();
begin

end;
{$ENDIF}


procedure TForm1.btDevicesClick(Sender: TObject);
begin
  {$IFDEF LINUX}
          //FDevice:='/dev/ttyS0';
          ChamaLinux();
  {$ENDIF}
  {$IFDEF WINDOWS}
          //FDevice:='COM1';
          ChamaWindows();
  {$ENDIF}
end;

procedure TForm1.btEnterClick(Sender: TObject);
var
   info : string;
begin
    info := edEnviar.Text;
    if SdpoSerial1.Active then
  begin

     if (cbTipo.ActivePage=TabSheet1) then
     begin
          SdpoSerial1.WriteData(info + #13+#10);
          Memo1.Lines.Append('Send'+datetimetostr(now)+':'+Info);
          Memo2.Lines.Append('Send'+datetimetostr(now)+':'+strtohex(Info));
     end
     else
     begin
           SdpoSerial1.WriteData(hextostr(info) + #13+#10);
           Memo1.Lines.Append('Send'+datetimetostr(now)+':'+hextostr(Info));
           Memo2.Lines.Append('Send'+datetimetostr(now)+':'+Info);
     end;

  end;
end;

procedure TForm1.btEnviarClick(Sender: TObject);
var
   info : string;
begin
  info := edEnviar.Text;
  Memo1.Lines.Append('Send'+datetimetostr(now)+':'+Info);
  if (cbTipo.ActivePage=TabSheet1) then
  begin
     SdpoSerial1.WriteData(info);
     Memo1.Lines.Append('Send'+datetimetostr(now)+':'+Info);
     Memo2.Lines.Append('Send'+datetimetostr(now)+':'+strtohex(Info));
  end
  else
  begin
     SdpoSerial1.WriteData(hextostr(info));
     Memo1.Lines.Append('Send'+datetimetostr(now)+':'+hextostr(Info));
     Memo2.Lines.Append('Send'+datetimetostr(now)+':'+Info);
  end;
end;

procedure TForm1.btImprimirClick(Sender: TObject);

begin

end;

procedure TForm1.btZeraClick(Sender: TObject);
begin
  if SdpoSerial1.Active then
  begin
       SdpoSerial1.WriteData('Z');
  end;
end;


{$IFDEF LINUX}
procedure TForm1.AudioLinux();
begin

end;
{$ENDIF}

{$IFDEF WINDOWS}
procedure TForm1.AudioWindows();
begin

end;
{$ENDIF}

procedure TForm1.Button5Click(Sender: TObject);
begin
  {$IFDEF LINUX}
          //FDevice:='/dev/ttyS0';
          AudioLinux();
  {$ENDIF}
  {$IFDEF WINDOWS}
          //FDevice:='COM1';
          AudioWindows();
  {$ENDIF}
end;

procedure TForm1.cbTipoChange(Sender: TObject);
begin
  if (edEnviar.text <>'') then
  begin
       if (cbTipo.ActivePage = TabSheet1 ) then
       begin
          edEnviar.text := hextostr(edEnviar.text);
       end
       else
       begin
          edEnviar.text := strtohex(edEnviar.text);
       end;
  end;
end;

procedure TForm1.DataPortTCP1Close(Sender: TObject);
begin
    Memo1.Lines.Append('Socket:'+datetimetostr(now)+':disconnected');
end;

procedure TForm1.DataPortTCP1DataAppear(Sender: TObject);
var
   info : string;
begin
  info := DataPortTCP1.Peek(DataPortTCP1.PeekSize());
  Memo1.Lines.Append('Socket Rec:'+datetimetostr(now)+':'+info);
  if (ckRepeaterSerial.Checked) then
  begin
       if (SdpoSerial1.Active) then
       begin
          SdpoSerial1.WriteData(info);
       end;
  end;
end;

procedure TForm1.DataPortTCP1Open(Sender: TObject);
begin
  Memo1.Lines.Append('Socket:'+datetimetostr(now)+':connected');
end;

procedure TForm1.edPortChange(Sender: TObject);
begin

end;

procedure TForm1.FindDialog1Find(Sender: TObject);
begin
     strFind:= findDialog1.FindText;
     Pesquisar(Sender);
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
    {$IFDEF LINUX}
          edPort.text:='/dev/ttyS0';
          edPort1.text:='/dev/ttyS0';

  {$ENDIF}
  {$IFDEF WINDOWS}
          edPort.text:='COM1';
          edPort1.text:='COM2';

  {$ENDIF}

end;

procedure TForm1.Label11Click(Sender: TObject);
begin

end;

procedure TForm1.Label12Click(Sender: TObject);
begin

end;

procedure TForm1.Label14Click(Sender: TObject);
begin

end;

procedure TForm1.lstFindClick(Sender: TObject);
var
   syn : TSynEdit;
   res : boolean;

   find : TFind;


begin

    If lstFind.SelCount > 0 then
    begin
        if cbTipo.ActivePage = TabSheet1 then
        begin
         syn := Memo1;
        end
         else
        begin
         syn := Memo2;
        end;

        find := TFIND(lstFind.items.objects[lstFind.ItemIndex]);
        //pgMain.ActivePage := find.tb;

        FPOS := find.IPOS;



        FPos := find.IPos + length(find.strFind);
        //   Hoved.BringToFront;       {Edit control must have focus in }
        find.syn.SetFocus;
        Self.ActiveControl := find.syn;
        find.syn.SelStart:= find.IPos;  // -1;   mike   {Select the string found by POS}
        setSelLength(find.syn, find.FLen);     //Memo1.SelLength := FLen;
        //Found := True;
        FPos:=FPos+find.FLen-1;   //mike - move just past end of found item

    end;

end;

procedure TForm1.setSelLength(var textComponent:TSynEdit; newValue:integer);
begin
textComponent.SelEnd:=textComponent.SelStart+newValue ;
end;

procedure TForm1.Memo1Change(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin
  if (SaveDialog1.Execute) then
  begin
     Memo1.Lines.SaveToFile(SaveDialog1.FileName);
     ShowMessage('File Save!');
  end;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin
  Close();
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  if (FindDialog1.Execute) then
  begin

  end;
end;

procedure TForm1.MenuItem6Click(Sender: TObject);
begin
     lstFind.Visible:=false;
end;

procedure TForm1.Pesquisar(Sender: TObject);
Var
     find : TFind;
     //FindS: String;
     Found : boolean;
     IPos, FLen, SLen: Integer; {Internpos, Lengde søkestreng, lengde memotekst}
     Res : integer;
     syn : TSynEdit;

begin
    IPOS := 0;
    FPOS := 0;
    if cbTipo.ActivePage = TabSheet1 then
    begin
         syn := Memo1;

    end
    else
    begin
       syn := Memo2;
    end;
    //item := TItem(syn.tag);

    {FPos is global}
    Found:= False;
    FLen := Length(strFind);
    SLen := Length(syn.Text);
    //FindS := findDialog1.FindText;
    lstFind.Items.clear;

    repeat

       //following 'if' added by mike
       if frMatchcase in findDialog1.Options then
          IPos := Pos(strFind, Copy(syn.Text,FPos+1,SLen-FPos))
       else
          IPos := Pos(AnsiUpperCase(strFind),AnsiUpperCase( Copy(syn.Text,FPos+1,SLen-FPos)));

       if (IPOS>0) then
       begin
         FPos := FPos + IPos;
         find := TFind.create(syn ,cbTipo.ActivePage , nil, FPOS, strFind);

         lstFind.Items.AddObject('Pos:'+inttostr(FPOS),tobject(find));

       end
       else
       begin
         FPOS := 0;
         break;
       end;
    until (IPOS <=0);

    If lstFind.Count > 0 then begin
      lstFind.Visible:= true;
    end
    Else
    begin
      lstFind.Visible:= false;
      Res := Application.MessageBox('Text was not found!',
             'Find',  mb_OK + mb_ICONWARNING);
      FPos := 0;     //mike  nb user might cancel dialog, so setting here is not enough
    end;             //   - also do it before exec of dialog.

end;

procedure TForm1.PageControl1Change(Sender: TObject);
begin

end;

function TForm1.hextostr(info: string): string;
begin
  result := HexToString(info);

end;

function TForm1.strtohex(info : string) : string;
begin
  result := StringToHex(info);
end;

procedure TForm1.SdpoSerial1RxData(Sender: TObject);
var
  Info : String;
begin
  Info := SdpoSerial1.ReadData;
  Memo1.Lines.Append('Rec1'+datetimetostr(now)+':'+Info);
  Memo2.Lines.Append('Rec1'+datetimetostr(now)+':'+strtohex(Info));
  if ckConnection.Checked then
  begin
     if (SdpoSerial2.Active) then
     begin
        SdpoSerial2.WriteData(Info);
     end;
  end;
  if ckRepeaterSerial.Checked then
  begin
     if (DataPortTCP1.Active) then
     begin
        DataPortTCP1.Push(info);
     end
     else
     begin
        DataPortTCP1.RemoteHost:=edURL.Text;
        DataPortTCP1.RemotePort:=edPortSocket.text;
        DataPortTCP1.Open(info);
     end;
  end;

end;

procedure TForm1.SdpoSerial2RxData(Sender: TObject);
var
  Info : String;
begin
  Info := SdpoSerial2.ReadData;
  Memo1.Lines.Append('Rec2'+datetimetostr(now)+':'+Info);
  Memo2.Lines.Append('Rec2'+datetimetostr(now)+':'+strtohex(Info));
  if ckConnection.Checked then
  begin
     if (SdpoSerial1.Active) then
     begin
        SdpoSerial1.WriteData(Info);
     end;
  end;
end;

procedure TForm1.tbConfigContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.tbSerialContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure TForm1.timerBalancaTimer(Sender: TObject);
begin

end;

procedure TForm1.ToggleBox1Change(Sender: TObject);
begin
   DataPortTCP1.Close();
end;

end.

