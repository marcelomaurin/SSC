unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, FileUtil, Forms, Controls, Graphics, Dialogs,
  StdCtrls, Buttons, ComCtrls, ExtCtrls, Menus, lNetComponents, SdpoSerial,
  SynMemo, SynEdit, hexlib, types, lNet, synaser, setssc, funcoes;

const
  MAXBLOCOLINHA = 40;
  BLOCOSTART = 'INICIOU GATEWAY';

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
    btBridge: TButton;
    btConnect: TBitBtn;
    btConnectSRV: TBitBtn;
    btDisconnect: TBitBtn;
    btDisconnectSRV: TBitBtn;
    btEnviar: TButton;
    btEnter: TButton;
    btFeedbackserial: TButton;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    cbBaudrate: TComboBox;
    cbDatabit: TComboBox;
    cbParidade: TComboBox;
    cbStopbit: TComboBox;
    cbTipo1: TPageControl;
    ckEscuta: TCheckBox;
    ckExecuta: TCheckBox;
    ckServidor: TCheckBox;
    ckEsperaCon: TCheckBox;
    ckBlocado: TCheckBox;
    ckTimmer: TCheckBox;
    edEnviar: TEdit;
    edHexBloc: TEdit;
    edHost: TEdit;
    edDelay: TEdit;
    edPort: TEdit;
    edSource: TEdit;
    edStart: TEdit;
    edTCPPORT: TEdit;
    edTCPPORT1: TEdit;
    edTimmer: TEdit;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    GroupBox3: TGroupBox;
    gbTCP: TGroupBox;
    GroupBox4: TGroupBox;
    Label1: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    Label20: TLabel;
    Label21: TLabel;
    Label22: TLabel;
    Label23: TLabel;
    Label3: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    LTCPComponent1: TLTCPComponent;
    LTCPComSRV: TLTCPComponent;
    MainMenu1: TMainMenu;
    Memo1: TSynEdit;
    Memo2: TSynEdit;
    Memo3: TSynEdit;
    Memo4: TSynEdit;
    Memo5: TSynEdit;
    Memo6: TSynEdit;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    mnSair: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    cbTipo: TPageControl;
    pmtray: TPopupMenu;
    SaveDialog1: TSaveDialog;
    SaveDialog2: TSaveDialog;
    SdpoSerial1: TSdpoSerial;
    synSource: TSynEdit;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    tbProgrammer: TTabSheet;
    TabSheet4: TTabSheet;
    TabSheet5: TTabSheet;
    TabSheet6: TTabSheet;
    TabSheet7: TTabSheet;
    tbSocket: TTabSheet;
    tmConecta: TTimer;
    ToggleBox1: TToggleBox;
    TrayIcon1: TTrayIcon;
    tsSource: TTabSheet;
    tbSerial: TTabSheet;
    tbSobre: TTabSheet;
    tbConfig: TTabSheet;
    Timer1: TTimer;
    procedure btBridgeClick(Sender: TObject);
    procedure btConnectClick(Sender: TObject);
    procedure btConnectSRVClick(Sender: TObject);
    procedure btDisconnectClick(Sender: TObject);
    procedure btDevicesClick(Sender: TObject);
    procedure btDisconnectSRVClick(Sender: TObject);
    procedure btEnterClick(Sender: TObject);
    procedure btEnterKeyPress(Sender: TObject; var Key: char);
    procedure btEnviarClick(Sender: TObject);
    procedure btFeedbbackSChange(Sender: TObject);
    procedure btImprimirClick(Sender: TObject);
    procedure btZeraClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure btFeedbackserialClick(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure cbTipoChange(Sender: TObject);
    procedure ckEscutaChange(Sender: TObject);
    procedure ckTimmerChange(Sender: TObject);
    procedure edEnviarKeyPress(Sender: TObject; var Key: char);
    procedure edPortChange(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCreate(Sender: TObject);
    procedure GroupBox4Click(Sender: TObject);
    procedure Label8Click(Sender: TObject);
    procedure LTCPComponent1Accept(aSocket: TLSocket);
    procedure LTCPComponent1CanSend(aSocket: TLSocket);
    procedure LTCPComponent1Connect(aSocket: TLSocket);
    procedure LTCPComponent1Disconnect(aSocket: TLSocket);
    procedure LTCPComponent1Error(const msg: string; aSocket: TLSocket);
    procedure LTCPComponent1Receive(aSocket: TLSocket);
    procedure LTCPComSRVAccept(aSocket: TLSocket);
    procedure LTCPComSRVConnect(aSocket: TLSocket);
    procedure LTCPComSRVDisconnect(aSocket: TLSocket);
    procedure LTCPComSRVReceive(aSocket: TLSocket);
    procedure Memo1Change(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
    procedure mnSairClick(Sender: TObject);
    procedure PageControl1Change(Sender: TObject);
    procedure SdpoSerial1BlockSerialStatus(Sender: TObject;
      Reason: THookSerialReason; const Value: string);
    procedure SdpoSerial1RxData(Sender: TObject);
    procedure tbConfigContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbSerialContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
      var Handled: Boolean);
    procedure Timer1Timer(Sender: TObject);
    procedure timerBalancaTimer(Sender: TObject);
    procedure tmConectaStartTimer(Sender: TObject);
    procedure tmConectaTimer(Sender: TObject);
    procedure ToggleBox1Change(Sender: TObject);
    procedure RegistraChar(tipo: string; Info : string);
    procedure RegistraTCP(tipo: string; Info : string);
    procedure EscutaTCP();
  private
    { private declarations }
    {$IFDEF WINDOWS}
    blocolinha : integer;
    blocolinhaTCP : integer;
    bufferSerial : string;
    flgEstabeleceu :boolean;
    aCliente: TLSocket;


    //FNet: TLConnection;
    FIsServer: Boolean;
    procedure ConectaSerial();
    procedure ChamaWindows();
    procedure AudioWindows();
    procedure  AtivaTCP();
    {$ENDIF}
    {$IFDEF LINUX}
    procedure ChamaLinux();
    procedure AudioLinux();

    {$ENDIF}
    function strtohex(info : string) : string;
    function hextostr(info: string): string;
    procedure AnalisaBloco();
    procedure Echooa();
  public
    { public declarations }
    Arquivo : String;
    procedure ProcessSource();
    function Analise(info : string): string;
  end; 

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

{ Tfrmmain }

//Analisa a linha em busca de comandos - futuro
function Tfrmmain.Analise(info : string): string;
begin
  result := info;
end;

//Process line in line to send
procedure Tfrmmain.ProcessSource();
var
  line : integer;
  info : string;
begin
  for line := 0 to synSource.Lines.Count-1 do
  begin
       info := Analise(synSource.Lines[line]);
       SdpoSerial1.WriteData(info);
  end;

end;

procedure  Tfrmmain.AtivaTCP();
begin
    if   LTCPComponent1.Connected then
    begin
        LTCPComponent1.Disconnect(true);
        Application.ProcessMessages;
        sleep(1000); //Aguarda desconectar
    end;

   // SSL.SSLActive:= false;
    //LTCPComponent1.SocketNet := LAF_INET;
    //LTCPComponent1.Port:= strtoint(edTCPPORT.Text);
    if LTCPComponent1.Connect(edHost.text,strtoint(edTCPPORT.Text)) then
    begin
         Application.ProcessMessages;
         //Deu certo
         RegistraChar('CON','Registrou TCP'+#13+#10);

         if (ckEsperaCon.Checked) then
         begin
             flgEstabeleceu := false;
             RegistraChar('CON','Aguardando estabelecer conexao'+#13+#10);
             sleep(1000);
             //Echooa();
             Application.ProcessMessages;
             tmConecta.Enabled:= true; //Ativa thread de aguarda echo
         end
         else
         begin
             RegistraTCP('WAIT' , 'ESTABELECEU CONEXAO!'+#13+#10);
         end;
    end;

end;

procedure Tfrmmain.ConectaSerial();
begin
  SdpoSerial1.close;
  SdpoSerial1.Device:= edPort.Text;
  SdpoSerial1.DataBits:=  TDataBits(cbDatabit.ItemIndex);
  SdpoSerial1.BaudRate:= TBaudRate( cbBaudrate.ItemIndex);
  SdpoSerial1.Parity:= TParity(cbParidade.ItemIndex);
  SdpoSerial1.StopBits:= TStopBits(cbStopbit.ItemIndex);
  //SdpoSerial1.Open;
  SdpoSerial1.Active:= true;
  TrayIcon1.Visible:=true;
end;

procedure Tfrmmain.btConnectClick(Sender: TObject);
begin
   ConectaSerial();
end;

procedure Tfrmmain.EscutaTCP();
begin
    if(ckServidor.Checked) then
  begin
      if LTCPComSRV.Listen(strtoint(edTCPport1.text)) then
      begin

      end;
  end;
end;

procedure Tfrmmain.btConnectSRVClick(Sender: TObject);
begin
  EscutaTCP();
end;

procedure Tfrmmain.btBridgeClick(Sender: TObject);
begin
 Cursor:= crHourGlass;
 tmConecta.Enabled:= false; //Ativa thread de aguarda echo
 ckEscuta.Checked:= false;
 ckBlocado.Checked:= false;
 //Inicia conexao com Rede
 if   LTCPComponent1.Connected then
 begin
         LTCPComponent1.Disconnect(true);
         Application.ProcessMessages;

 end;
 Application.ProcessMessages;
 ConectaSerial();
 Application.ProcessMessages;
 sleep(strtoint(edDelay.text) *1000);
 Application.ProcessMessages;
 if LTCPComponent1.Connect(edHost.text,strtoint(edTCPPORT.Text)) then
  begin
        Application.ProcessMessages;
        //Deu certo
        RegistraChar('CON','Registrou TCP'+#13+#10);

        if(ckEsperaCon.Checked) then
        begin
            flgEstabeleceu := true;
            Echooa();
            Application.ProcessMessages;
            tmConecta.Enabled:= true; //Ativa thread de aguarda echo
        end
        else
        begin

          AtivaTCP();
          sleep(1000); //Aguarda desconectar
          Application.ProcessMessages;
          ECHOOA;

        end;
  end;

  ckEscuta.Checked:= true;
  ckBlocado.Checked:= false;
  Cursor:=crDefault;
end;

procedure Tfrmmain.btDisconnectClick(Sender: TObject);
begin
  SdpoSerial1.Close;
  if LTCPComponent1.Connected then
  begin
    LTCPComponent1.Disconnect(true);
  end;
  //LTCPComponent1.Active:= false;
  TrayIcon1.Visible:=false;
end;


{$IFDEF LINUX}
//Chama Comunicacao com Linux para ver devices
procedure Tfrmmain.ChamaLinux();
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
procedure Tfrmmain.ChamaWindows();
begin

end;
{$ENDIF}


procedure Tfrmmain.btDevicesClick(Sender: TObject);
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

procedure Tfrmmain.btDisconnectSRVClick(Sender: TObject);
begin
  LTCPComSRV.Disconnect(true);
end;

procedure Tfrmmain.btEnterClick(Sender: TObject);
var
   info : string;
begin
    info := edEnviar.Text;
    if SdpoSerial1.Active then
  begin
     info := info + #13+#10;
     if (cbTipo.ActivePage=TabSheet1) then
     begin
          SdpoSerial1.WriteData(info);
          RegistraChar('Send',Info);
     end;
     if (cbTipo.ActivePage=TabSheet2) then
     begin
           SdpoSerial1.WriteData(hextostr(info) );
           RegistraChar('Send',hextostr(Info));
     end;
     if (cbTipo.ActivePage=TabSheet4) then
     begin
          SdpoSerial1.WriteData(info);
          RegistraChar('Send',Info);
     end;


  end;
end;

procedure Tfrmmain.btEnterKeyPress(Sender: TObject; var Key: char);
begin

end;

procedure Tfrmmain.btEnviarClick(Sender: TObject);
var
   info : string;
begin
  info := edEnviar.Text;
  if (cbTipo.ActivePage=TabSheet1) then
  begin
     SdpoSerial1.WriteData(info);
     RegistraChar('Send',Info);
  end;
  if (cbTipo.ActivePage=TabSheet2) then
  begin
     SdpoSerial1.WriteData(hextostr(info));
     RegistraChar('Send',hextostr(Info));
  end;
  if (cbTipo.ActivePage=TabSheet4) then
       begin
            SdpoSerial1.WriteData(info);
            RegistraChar('Send',Info);
       end;
end;

procedure Tfrmmain.btFeedbbackSChange(Sender: TObject);
var
   info : string;
begin
  info := 'TESTE Serial'+#13;
  if (SdpoSerial1.Active) then
  begin
     SdpoSerial1.WriteData(info);
  end
  else
  begin
     ShowMessage('Disconnected!');
  end;
end;

procedure Tfrmmain.btImprimirClick(Sender: TObject);

begin

end;

procedure Tfrmmain.btZeraClick(Sender: TObject);
begin
  if SdpoSerial1.Active then
  begin
       SdpoSerial1.WriteData('Z');
  end;
end;

procedure Tfrmmain.Echooa();
var
   info : string;
   n : integer;
begin
  info := 'ECHOOA'+#13;
  //if ckEscuta.Checked then
  begin
     RegistraChar('SSD' , 'ECHOA');
     if LTCPComponent1.Connected then
     begin
             Application.ProcessMessages;
             RegistraTCP('SCT' ,Info);
             n := LTCPComponent1.SendMessage(Info);
             Application.ProcessMessages;
             if( n<length(Info) ) then
             begin
                //debug("Erro ao tentar enviar sck!");
                RegistraTCP('ERRO' , 'Erro ao tentar enviar sck!');
             end;
     end;
  end;
end;

procedure Tfrmmain.Button1Click(Sender: TObject);
begin
  ECHOOA;
end;

procedure Tfrmmain.btFeedbackserialClick(Sender: TObject);
var
   info : string;
begin
  info := 'TESTE Socket'+#13;
  if SdpoSerial1.Active then
  begin
    SdpoSerial1.WriteData(info);
  end;
end;

procedure Tfrmmain.Button2Click(Sender: TObject);
begin
  AtivaTCP();
end;

procedure Tfrmmain.Button3Click(Sender: TObject);
begin
  LTCPComponent1.Disconnect(true);
  tmConecta.Enabled:=false;
end;


{$IFDEF LINUX}
procedure Tfrmmain.AudioLinux();
begin

end;
{$ENDIF}

{$IFDEF WINDOWS}
procedure Tfrmmain.AudioWindows();
begin

end;
{$ENDIF}

procedure Tfrmmain.Button5Click(Sender: TObject);
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

procedure Tfrmmain.cbTipoChange(Sender: TObject);
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

procedure Tfrmmain.ckEscutaChange(Sender: TObject);
begin
  if ckEscuta.Checked then
  begin
      btBridge.Enabled:= true;
  end
  else
  begin
      btBridge.Enabled:= false;
  end;
end;

procedure Tfrmmain.ckTimmerChange(Sender: TObject);
begin
  Timer1.Enabled:=false;
  Timer1.Interval:=strtoint(edTimmer.text);

  Timer1.Enabled:= ckTimmer.Enabled;
end;

procedure Tfrmmain.edEnviarKeyPress(Sender: TObject; var Key: char);
begin
  if (key = #13) then
  begin
       btEnterClick(self);
  end;
end;

procedure Tfrmmain.edPortChange(Sender: TObject);
begin

end;

procedure Tfrmmain.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  FSetssc.posx := self.Left;
  FSetssc.posy := self.top;
  FSetssc.COMPORT := edPort.text;
  FSetssc.BAUDRATE:= cbBaudrate.ItemIndex;
  FSetssc.EXEC:= iif(ckExecuta.Checked,1,0);
  FSetssc.SalvaContexto();
end;

procedure Tfrmmain.FormCreate(Sender: TObject);
begin
  blocolinha := 0; //Inicia bloco de linha
  blocolinhaTCP := 0; //Inicia bloco de linha
  FIsServer := False;
  TrayIcon1.Visible:=false;
  aCliente := nil;
  FSetssc  := TSetSSC.create();
  Fsetssc.CarregaContexto();
  self.Left:= FSetssc.posx;
  self.top:=FSetssc.posy;
  PageControl1.ActivePageIndex := 0;
  edPort.text := FSetssc.COMPORT;
  cbBaudrate.ItemIndex:= FSetssc.BAUDRATE;
  ckExecuta.Checked:= FSetssc.EXEC;


end;

procedure Tfrmmain.GroupBox4Click(Sender: TObject);
begin

end;

procedure Tfrmmain.Label8Click(Sender: TObject);
begin

end;

procedure Tfrmmain.LTCPComponent1Accept(aSocket: TLSocket);
var
   info : string;
begin
  info := 'Aceitou a conexao, IP:'+ aSocket.LocalAddress+#13+#10;
  RegistraTCP('ACE' , INFO);
end;

procedure Tfrmmain.LTCPComponent1CanSend(aSocket: TLSocket);
begin

end;

procedure Tfrmmain.LTCPComponent1Connect(aSocket: TLSocket);
var
   info : string;
begin
  info := 'O Cliente Conectou IP:'+ aSocket.LocalAddress+#13+#10;
  RegistraTCP('CON' , info);
  info := 'O Servidor Conectou IP:'+ aSocket.PeerAddress+#13+#10;
  RegistraTCP('CON' , info);
end;

procedure Tfrmmain.LTCPComponent1Disconnect(aSocket: TLSocket);
var
   info : string;
begin
  info := 'O Cliente Desconectou IP:'+ aSocket.LocalAddress+#13+#10;
  RegistraTCP('DES' , info);

end;

procedure Tfrmmain.LTCPComponent1Error(const msg: string; aSocket: TLSocket);
var
   info : string;
begin
  info := 'Erro:'+ msg;
  RegistraTCP('ERRO' , 'info');
end;

procedure Tfrmmain.LTCPComponent1Receive(aSocket: TLSocket);
var
   info : string;
begin
   aSocket.GetMessage(Info);
   RegistraTCP('TCR' , info);
   if (SdpoSerial1.Active) then
   begin
      RegistraChar('STX' , info);

      SdpoSerial1.WriteData(info);
      if ckEsperaCon.Checked then
      begin
        if (pos(edStart.text,info)>0) then
        begin
           flgEstabeleceu := true;
        end;
      end;

   end;
end;

procedure Tfrmmain.LTCPComSRVAccept(aSocket: TLSocket);
begin
  if (aCliente = nil)  then
  begin
      RegistraChar('TCP Accept:', aSocket.PeerAddress);
      aCliente := aSocket;
  end;
end;

procedure Tfrmmain.LTCPComSRVConnect(aSocket: TLSocket);
begin
  RegistraChar('TCP Connect:', aSocket.PeerAddress);
end;

procedure Tfrmmain.LTCPComSRVDisconnect(aSocket: TLSocket);
begin
  RegistraChar('TCP Disconect:', aSocket.PeerAddress);
  aCliente := nil;
end;

procedure Tfrmmain.LTCPComSRVReceive(aSocket: TLSocket);
var
   info : string;
   tam : integer;
begin
  tam := aSocket.GetMessage(info);
  if (tam <>0) then
  begin
    //RegistraChar('TCP Rcv:', info);
    RegistraTCP('TCR' , info);
    if(SdpoSerial1.Active) then
    begin
      SdpoSerial1.WriteData(info);
    end;
  end;
end;

procedure Tfrmmain.Memo1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.MenuItem2Click(Sender: TObject);
begin
  if (SaveDialog1.Execute) then
  begin
     Memo1.Lines.SaveToFile(SaveDialog1.FileName);
     ShowMessage('File Save!');
  end;
end;

procedure Tfrmmain.MenuItem3Click(Sender: TObject);
begin
  Close();
end;

procedure Tfrmmain.MenuItem4Click(Sender: TObject);
begin
  show();
end;

procedure Tfrmmain.MenuItem5Click(Sender: TObject);
begin
  ShowMessage('Not yet!');
end;

procedure Tfrmmain.MenuItem8Click(Sender: TObject);
begin
  if (SaveDialog1.Execute) then
  begin
     synSource.Lines.SaveToFile(SaveDialog1.FileName);
  end;
end;

procedure Tfrmmain.MenuItem9Click(Sender: TObject);
begin
  ToggleBox1Change(self); //Carrega o arquivo
end;

procedure Tfrmmain.mnSairClick(Sender: TObject);
begin
  close();
end;

procedure Tfrmmain.PageControl1Change(Sender: TObject);
begin

end;

procedure Tfrmmain.SdpoSerial1BlockSerialStatus(Sender: TObject;
  Reason: THookSerialReason; const Value: string);
begin
  case Reason of
  HR_Connect:
  begin
     //btConnect.Enabled:=false;
     //btDisconnect.Enabled:=true;
     RegistraChar('SEND' , 'Conectou');
  end;
  HR_SerialClose:
  begin
     //btConnect.Enabled:=true;
     //btDisconnect.Enabled:=false;

     RegistraChar('SEND' , 'Desconectou');
  end;

  end;
end;

function Tfrmmain.hextostr(info: string): string;
begin
  result := HexToString(info);

end;

function Tfrmmain.strtohex(info : string) : string;
begin
  result := StringToHex(info);
end;


procedure Tfrmmain.RegistraChar(tipo: string; Info : string);
var
   linha : string;
   a : integer;
   strBloco : string;
begin
  strBloco := hextostr(edHexBloc.text);
  if (pos(strBloco,info)>0) then
  begin
    Memo3.Lines.Append(tipo+timetostr(now)+'->'+Info);
  end
  else
  begin
    if ((memo3.lines.count-1)>0) then
    begin
      linha := memo3.Lines.Strings[memo3.lines.count-1];
      memo3.Lines.Delete(memo3.lines.count-1);
      Memo3.Lines.Append(linha+Info);
    end;
  end;

  for a:= 0 to Length(Info)-1 do
  begin
    if (a = pos(strBloco,info)) then
    begin
      blocolinha := 0;
    end;
    if (blocolinha >= MAXBLOCOLINHA) then
    begin
       blocolinha := 0;
    end;
    if (blocolinha =0 ) then
    begin
       Memo1.Lines.Append(tipo+timetostr(now)+'->'+Info[a]);
       Memo2.Lines.Append(tipo+timetostr(now)+'->'+StringToHexMask(Info[a],' '));
    end
    else
    begin
      Application.ProcessMessages;
      linha := Memo1.Lines.Strings[Memo1.Lines.Count-1];
      Memo1.Lines.Delete(Memo1.Lines.Count-1);
      Memo1.Lines.Append(linha+' '+Info);
      //Memo1.Lines.AddStrings(info);
      Application.ProcessMessages;

      linha := Memo2.Lines.Strings[Memo2.Lines.Count-1];
      Memo2.Lines.Delete(Memo2.Lines.Count-1);
      Memo2.Lines.Append(linha+' '+StringToHexMask(Info,' '));
      //Memo2.Lines.AddStrings(info);
      Application.ProcessMessages;
    end;
    inc(blocolinha );
  end;
  //blocolinha := 0;
end;

procedure Tfrmmain.RegistraTCP(tipo: string; Info : string);
var
   linha : string;
   a : integer;
   strBloco : string;
   info2 : string;
begin
  strBloco := hextostr(edHexBloc.text);
  if (pos(strBloco,info)>0) then
  begin
    Memo6.Lines.Append(tipo+timetostr(now)+'->'+Info);
  end
  else
  begin
    if ((memo6.lines.count-1)>0) then
    begin
      linha := memo6.Lines.Strings[memo6.lines.count-1];
      memo6.Lines.Delete(memo6.lines.count-1);
      Memo6.Lines.Append(linha+Info);
    end;
  end;

  for a:= 0 to Length(Info)-1 do
  begin
    if (a = pos(strBloco,info)) then
    begin
      blocolinhaTCP := 0;
    end;
    if (blocolinhaTCP >= MAXBLOCOLINHA) then
    begin
       blocolinhaTCP := 0;
    end;
    if (blocolinhaTCP =0 ) then
    begin
       Memo4.Lines.Append(tipo+timetostr(now)+'->'+Info);
       info2 := StringToHexMask(Info,' ');
       Memo5.Lines.Append(tipo+timetostr(now)+'->'+info2);
    end
    else
    begin
      linha := Memo4.Lines.Strings[Memo4.Lines.Count-1];
      if (linha <> '') then
      begin
         Memo4.Lines.Delete(Memo4.Lines.Count-1);
      end;
      Memo4.Lines.Append(linha+' '+Info[a]);
      linha := Memo5.Lines.Strings[Memo5.Lines.Count-1];
      if (linha <> '') then
      begin
           Memo5.Lines.Delete(Memo5.Lines.Count-1);
      end;
      info2 := StringToHexMask(Info,' ');
      Memo5.Lines.Append(linha+' '+info2);

    end;
    inc(blocolinhaTCP );
  end;
  //blocolinha := 0;
end;


procedure Tfrmmain.AnalisaBloco();
var
  trabalho : string;
  n : integer;
  strBlocado : string;
begin
  strBlocado := hextostr(edHexBloc.text);
  if (pos(strBlocado,bufferSerial)>0) then
  begin
       repeat
         Trabalho := copy(BufferSerial,1,pos(strBlocado,BufferSerial)+(length(strBlocado)-1));
         if (pos(BLOCOSTART,Trabalho)>0) then
         begin
              if ckEscuta.Checked then
              begin
                 AtivaTCP;
              end;
         end;
         RegistraChar('SRX',Trabalho);
         if ckEscuta.Checked then
         begin
                if LTCPComponent1.Connected then
                begin
                       RegistraTCP('SCT',Trabalho);
                       n := LTCPComponent1.SendMessage(Trabalho,LTCPComponent1.Iterator);
                       if( n<length(Trabalho) ) then
                       begin
                         //debug("Erro ao tentar enviar sck!");
                         RegistraTCP('ERR','Erro ao tentar enviar sck!');
                       end;
                end;
         end;
         bufferSerial :=copy(bufferSerial,(pos(strBlocado,bufferSerial)+length(strBlocado)), Length(bufferSerial));
       until (BufferSerial = '');
  end;

end;

procedure Tfrmmain.SdpoSerial1RxData(Sender: TObject);
var
  Info : String;
  n : integer;

begin
  Info := SdpoSerial1.ReadData;
  SdpoSerial1.SynSer.Flush;

  if ckBlocado.Checked then
  begin
    BufferSerial := BufferSerial + Info;
    AnalisaBloco();
  end
  else
  begin    //Nao blocado
    RegistraChar('SRX',info);
    if( ckServidor.Checked) then
    begin
      if (aCliente<> nil) then
      begin
        if(LTCPComSRV.Active) then
        begin
           aCliente.SendMessage(info);
        end;
      end;
    end;
    if ckEsperaCon.Checked then
    begin
      if ckEscuta.Checked then
      begin
        RegistraChar('RX',info);
        if LTCPComponent1.Connected then
        begin
           RegistraTCP('SCT',Info);
           n := LTCPComponent1.SendMessage(Info,LTCPComponent1.Iterator);
           if( n<length(Info) ) then
           begin
               //debug("Erro ao tentar enviar sck!");
           end;
        end;
      end
      else
      begin
        RegistraChar('RX',info);
      end;

    end
    else
    begin
      if ckEscuta.Checked then
      begin
        RegistraChar('RX',info);
        if LTCPComponent1.Connected then
        begin
           RegistraTCP('SCT',Info);
           n := LTCPComponent1.SendMessage(Info,LTCPComponent1.Iterator);
           if( n<length(Info) ) then
           begin
               //debug("Erro ao tentar enviar sck!");
           end;
        end;
      end
      else
      begin
        RegistraChar('RX',info);
      end;
    end;


  end;

end;

procedure Tfrmmain.tbConfigContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure Tfrmmain.tbSerialContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure Tfrmmain.tbSobreContextPopup(Sender: TObject; MousePos: TPoint;
  var Handled: Boolean);
begin

end;

procedure Tfrmmain.Timer1Timer(Sender: TObject);
begin
  if (edSource.text <> '') then
  begin
     synSource.Lines.LoadFromFile(edSource.Text );
     ProcessSource();
  end;
end;

procedure Tfrmmain.timerBalancaTimer(Sender: TObject);
begin

end;

procedure Tfrmmain.tmConectaStartTimer(Sender: TObject);
begin

end;

procedure Tfrmmain.tmConectaTimer(Sender: TObject);
begin
  tmConecta.Enabled:= false;
  if not flgEstabeleceu then
  begin
       RegistraTCP('WAIT' , 'RECONECTANDO'+#13+#10);
       AtivaTCP();
       tmConecta.Enabled:= true;
  end
  else
  begin
       RegistraTCP('WAIT' , 'ESTABELECEU CONEXAO!'+#13+#10);
  end;
end;

procedure Tfrmmain.ToggleBox1Change(Sender: TObject);
begin
  if (OpenDialog1.Execute) then
  begin
     edSource.Text:=OpenDialog1.FileName;
     synSource.Lines.LoadFromFile(edSource.Text);
  end;

end;

end.

