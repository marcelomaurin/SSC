unit main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, StdCtrls, ExtCtrls,
  ComCtrls, aiserial, ailistserialdevices, setssc;

const
  APP_TITLE = 'SSC 3.0 - Analisador Serial';
  MAX_LOG_CHARS = 2 * 1024 * 1024;

type

  { Tfrmmain }

  Tfrmmain = class(TForm)
  private
    FSettings: TSetSSC;
    FSerial: TAISerialModem;
    FPortList: TAIListSerialDevices;
    FPollTimer: TTimer;
    FSaveDialog: TSaveDialog;

    FRxBytes: QWord;
    FTxBytes: QWord;

    FConnectionPanel: TPanel;
    FPortCombo: TComboBox;
    FRefreshButton: TButton;
    FPortInfoLabel: TLabel;
    FBaudCombo: TComboBox;
    FDataBitsCombo: TComboBox;
    FParityCombo: TComboBox;
    FStopBitsCombo: TComboBox;
    FConnectButton: TButton;
    FDisconnectButton: TButton;
    FConnectionLabel: TLabel;

    FPages: TPageControl;
    FMonitorTab: TTabSheet;
    FSendTab: TTabSheet;

    FMonitorToolbar: TPanel;
    FDisplayModeCombo: TComboBox;
    FTimestampCheck: TCheckBox;
    FAutoScrollCheck: TCheckBox;
    FClearButton: TButton;
    FSaveButton: TButton;
    FLogMemo: TMemo;

    FSendPanel: TPanel;
    FSendEdit: TEdit;
    FSendModeCombo: TComboBox;
    FEolCombo: TComboBox;
    FSendButton: TButton;
    FSendHelpLabel: TLabel;

    FStatusBar: TStatusBar;

    procedure BuildUI;
    procedure LoadSettingsToUI;
    procedure SaveUIToSettings;
    procedure UpdateStatusBar;
    procedure UpdatePortInfo;
    procedure SetConnectedUI(AConnected: Boolean);

    procedure RefreshPorts;
    procedure ConnectSerial;
    procedure DisconnectSerial;

    procedure PollTimerTimer(Sender: TObject);
    procedure SerialConnected(Sender: TObject);
    procedure SerialDisconnected(Sender: TObject);
    procedure SerialRX(Sender: TObject; const AData: string);
    procedure SerialTX(Sender: TObject; const AData: string);

    procedure RefreshButtonClick(Sender: TObject);
    procedure PortComboChange(Sender: TObject);
    procedure ConnectButtonClick(Sender: TObject);
    procedure DisconnectButtonClick(Sender: TObject);
    procedure ClearButtonClick(Sender: TObject);
    procedure SaveButtonClick(Sender: TObject);
    procedure SendButtonClick(Sender: TObject);
    procedure SendEditKeyPress(Sender: TObject; var Key: Char);

    function DataToHex(const AData: string): string;
    function DataToVisibleText(const AData: string): string;
    function FormatData(const AData: string): string;
    function TryParseHex(const AText: string; out AData: string): Boolean;
    function ApplyEOL(const AData: string): string;
    procedure AddTraffic(const APrefix, AData: string);
    procedure AddSystem(const AMessage: string);
    procedure AppendLog(const AText: string);
    procedure TrimLog;
  public
    constructor Create(TheOwner: TComponent); override;
    destructor Destroy; override;
  end;

var
  frmmain: Tfrmmain;

implementation

{$R *.lfm}

procedure CreateLabel(AOwner: TComponent; AParent: TWinControl;
  const ACaption: string; ALeft, ATop: Integer);
var
  L: TLabel;
begin
  L := TLabel.Create(AOwner);
  L.Parent := AParent;
  L.Caption := ACaption;
  L.Left := ALeft;
  L.Top := ATop;
end;

constructor Tfrmmain.Create(TheOwner: TComponent);
begin
  inherited Create(TheOwner);

  Caption := APP_TITLE;
  Constraints.MinWidth := 900;
  Constraints.MinHeight := 560;
  Position := poScreenCenter;

  FSettings := TSetSSC.Create;
  Width := FSettings.WindowWidth;
  Height := FSettings.WindowHeight;
  if (FSettings.PosX >= 0) and (FSettings.PosY >= 0) then
  begin
    Position := poDesigned;
    Left := FSettings.PosX;
    Top := FSettings.PosY;
  end;

  FRxBytes := 0;
  FTxBytes := 0;

  BuildUI;
  LoadSettingsToUI;

  { A comunicação serial é fornecida pela biblioteca CHATGPT/openai_input.
    O SSC apenas configura e consome o componente. }
  FSerial := TAISerialModem.Create(Self);
  FSerial.OnConnect := @SerialConnected;
  FSerial.OnDisconnect := @SerialDisconnected;
  FSerial.OnRXReceive := @SerialRX;
  FSerial.OnTXSend := @SerialTX;

  { A descoberta de portas também fica centralizada na biblioteca CHATGPT. }
  FPortList := TAIListSerialDevices.Create(Self);
  FPortList.AutoRefresh := False;
  FPortList.ProbeOpenable := False;  { evita reset de Arduino/ESP por DTR }
  FPortList.OnlyAvailable := True;
  FPortList.IncludeSystemPorts := True;
  FPortList.IncludeUSBSerial := True;
  FPortList.IncludeBluetooth := True;
  FPortList.IncludeTTYVariants := False;

  FPollTimer := TTimer.Create(Self);
  FPollTimer.Interval := 30;
  FPollTimer.Enabled := False;
  FPollTimer.OnTimer := @PollTimerTimer;

  FSaveDialog := TSaveDialog.Create(Self);
  FSaveDialog.DefaultExt := 'log';
  FSaveDialog.Filter :=
    'Arquivo de log|*.log|Arquivo texto|*.txt|Todos os arquivos|*.*';

  SetConnectedUI(False);
  RefreshPorts;
  AddSystem('SSC inicializado usando TAISerialModem e TAIListSerialDevices.');
end;

destructor Tfrmmain.Destroy;
begin
  if Assigned(FPollTimer) then
    FPollTimer.Enabled := False;

  if Assigned(FSerial) then
    FSerial.ClosePort;

  if Assigned(FSettings) then
  begin
    SaveUIToSettings;
    FSettings.Save;
    FreeAndNil(FSettings);
  end;

  inherited Destroy;
end;

procedure Tfrmmain.BuildUI;
begin
  FConnectionPanel := TPanel.Create(Self);
  FConnectionPanel.Parent := Self;
  FConnectionPanel.Align := alTop;
  FConnectionPanel.Height := 118;
  FConnectionPanel.BevelOuter := bvNone;

  CreateLabel(Self, FConnectionPanel, 'Porta serial', 12, 8);
  FPortCombo := TComboBox.Create(Self);
  FPortCombo.Parent := FConnectionPanel;
  FPortCombo.Left := 12;
  FPortCombo.Top := 27;
  FPortCombo.Width := 150;
  FPortCombo.Style := csDropDownList;
  FPortCombo.OnChange := @PortComboChange;

  FRefreshButton := TButton.Create(Self);
  FRefreshButton.Parent := FConnectionPanel;
  FRefreshButton.Left := 170;
  FRefreshButton.Top := 25;
  FRefreshButton.Width := 108;
  FRefreshButton.Height := 29;
  FRefreshButton.Caption := 'Atualizar portas';
  FRefreshButton.Hint :=
    'Refaz a detecção das portas presentes sem reiniciar o SSC.';
  FRefreshButton.ShowHint := True;
  FRefreshButton.OnClick := @RefreshButtonClick;

  CreateLabel(Self, FConnectionPanel, 'Baud rate', 294, 8);
  FBaudCombo := TComboBox.Create(Self);
  FBaudCombo.Parent := FConnectionPanel;
  FBaudCombo.Left := 294;
  FBaudCombo.Top := 27;
  FBaudCombo.Width := 100;
  FBaudCombo.Style := csDropDownList;
  FBaudCombo.Items.Text :=
    '300' + LineEnding +
    '600' + LineEnding +
    '1200' + LineEnding +
    '2400' + LineEnding +
    '4800' + LineEnding +
    '9600' + LineEnding +
    '19200' + LineEnding +
    '38400' + LineEnding +
    '57600' + LineEnding +
    '115200' + LineEnding +
    '230400' + LineEnding +
    '460800' + LineEnding +
    '921600';

  CreateLabel(Self, FConnectionPanel, 'Bits', 406, 8);
  FDataBitsCombo := TComboBox.Create(Self);
  FDataBitsCombo.Parent := FConnectionPanel;
  FDataBitsCombo.Left := 406;
  FDataBitsCombo.Top := 27;
  FDataBitsCombo.Width := 58;
  FDataBitsCombo.Style := csDropDownList;
  FDataBitsCombo.Items.Text :=
    '8' + LineEnding + '7' + LineEnding + '6' + LineEnding + '5';

  CreateLabel(Self, FConnectionPanel, 'Paridade', 476, 8);
  FParityCombo := TComboBox.Create(Self);
  FParityCombo.Parent := FConnectionPanel;
  FParityCombo.Left := 476;
  FParityCombo.Top := 27;
  FParityCombo.Width := 90;
  FParityCombo.Style := csDropDownList;
  FParityCombo.Items.Text :=
    'Nenhuma' + LineEnding + 'Par' + LineEnding + 'Ímpar';

  CreateLabel(Self, FConnectionPanel, 'Stop', 578, 8);
  FStopBitsCombo := TComboBox.Create(Self);
  FStopBitsCombo.Parent := FConnectionPanel;
  FStopBitsCombo.Left := 578;
  FStopBitsCombo.Top := 27;
  FStopBitsCombo.Width := 60;
  FStopBitsCombo.Style := csDropDownList;
  FStopBitsCombo.Items.Text := '1' + LineEnding + '2';

  FConnectButton := TButton.Create(Self);
  FConnectButton.Parent := FConnectionPanel;
  FConnectButton.Left := 654;
  FConnectButton.Top := 24;
  FConnectButton.Width := 100;
  FConnectButton.Height := 31;
  FConnectButton.Caption := 'Conectar';
  FConnectButton.OnClick := @ConnectButtonClick;

  FDisconnectButton := TButton.Create(Self);
  FDisconnectButton.Parent := FConnectionPanel;
  FDisconnectButton.Left := 762;
  FDisconnectButton.Top := 24;
  FDisconnectButton.Width := 106;
  FDisconnectButton.Height := 31;
  FDisconnectButton.Caption := 'Desconectar';
  FDisconnectButton.OnClick := @DisconnectButtonClick;

  FConnectionLabel := TLabel.Create(Self);
  FConnectionLabel.Parent := FConnectionPanel;
  FConnectionLabel.Left := 12;
  FConnectionLabel.Top := 65;
  FConnectionLabel.Caption := 'Desconectado';
  FConnectionLabel.Font.Style := [fsBold];

  FPortInfoLabel := TLabel.Create(Self);
  FPortInfoLabel.Parent := FConnectionPanel;
  FPortInfoLabel.Left := 12;
  FPortInfoLabel.Top := 88;
  FPortInfoLabel.Caption := 'Nenhuma porta selecionada';

  FPages := TPageControl.Create(Self);
  FPages.Parent := Self;
  FPages.Align := alClient;

  FMonitorTab := TTabSheet.Create(Self);
  FMonitorTab.PageControl := FPages;
  FMonitorTab.Caption := 'Monitor serial';

  FMonitorToolbar := TPanel.Create(Self);
  FMonitorToolbar.Parent := FMonitorTab;
  FMonitorToolbar.Align := alTop;
  FMonitorToolbar.Height := 48;
  FMonitorToolbar.BevelOuter := bvNone;

  CreateLabel(Self, FMonitorToolbar, 'Exibição', 10, 4);
  FDisplayModeCombo := TComboBox.Create(Self);
  FDisplayModeCombo.Parent := FMonitorToolbar;
  FDisplayModeCombo.Left := 10;
  FDisplayModeCombo.Top := 21;
  FDisplayModeCombo.Width := 130;
  FDisplayModeCombo.Style := csDropDownList;
  FDisplayModeCombo.Items.Text :=
    'Texto' + LineEnding + 'HEX' + LineEnding + 'Texto + HEX';
  FDisplayModeCombo.ItemIndex := 0;

  FTimestampCheck := TCheckBox.Create(Self);
  FTimestampCheck.Parent := FMonitorToolbar;
  FTimestampCheck.Left := 154;
  FTimestampCheck.Top := 23;
  FTimestampCheck.Caption := 'Timestamp';
  FTimestampCheck.Checked := True;

  FAutoScrollCheck := TCheckBox.Create(Self);
  FAutoScrollCheck.Parent := FMonitorToolbar;
  FAutoScrollCheck.Left := 260;
  FAutoScrollCheck.Top := 23;
  FAutoScrollCheck.Caption := 'Auto-scroll';
  FAutoScrollCheck.Checked := True;

  FClearButton := TButton.Create(Self);
  FClearButton.Parent := FMonitorToolbar;
  FClearButton.Width := 80;
  FClearButton.Height := 29;
  FClearButton.Top := 10;
  FClearButton.Left := 690;
  FClearButton.Anchors := [akTop, akRight];
  FClearButton.Caption := 'Limpar';
  FClearButton.OnClick := @ClearButtonClick;

  FSaveButton := TButton.Create(Self);
  FSaveButton.Parent := FMonitorToolbar;
  FSaveButton.Width := 94;
  FSaveButton.Height := 29;
  FSaveButton.Top := 10;
  FSaveButton.Left := 780;
  FSaveButton.Anchors := [akTop, akRight];
  FSaveButton.Caption := 'Salvar log';
  FSaveButton.OnClick := @SaveButtonClick;

  FLogMemo := TMemo.Create(Self);
  FLogMemo.Parent := FMonitorTab;
  FLogMemo.Align := alClient;
  FLogMemo.ReadOnly := True;
  FLogMemo.ScrollBars := ssBoth;
  FLogMemo.WordWrap := False;
  {$IFDEF WINDOWS}
  FLogMemo.Font.Name := 'Consolas';
  {$ELSE}
  FLogMemo.Font.Name := 'Monospace';
  {$ENDIF}

  FSendTab := TTabSheet.Create(Self);
  FSendTab.PageControl := FPages;
  FSendTab.Caption := 'Transmitir';

  FSendPanel := TPanel.Create(Self);
  FSendPanel.Parent := FSendTab;
  FSendPanel.Align := alTop;
  FSendPanel.Height := 120;
  FSendPanel.BevelOuter := bvNone;

  CreateLabel(Self, FSendPanel, 'Dados', 12, 10);
  FSendEdit := TEdit.Create(Self);
  FSendEdit.Parent := FSendPanel;
  FSendEdit.Left := 12;
  FSendEdit.Top := 30;
  FSendEdit.Width := 490;
  FSendEdit.Anchors := [akTop, akLeft, akRight];
  FSendEdit.OnKeyPress := @SendEditKeyPress;

  CreateLabel(Self, FSendPanel, 'Formato', 516, 10);
  FSendModeCombo := TComboBox.Create(Self);
  FSendModeCombo.Parent := FSendPanel;
  FSendModeCombo.Left := 516;
  FSendModeCombo.Top := 30;
  FSendModeCombo.Width := 86;
  FSendModeCombo.Style := csDropDownList;
  FSendModeCombo.Items.Text := 'Texto' + LineEnding + 'HEX';
  FSendModeCombo.ItemIndex := 0;
  FSendModeCombo.Anchors := [akTop, akRight];

  CreateLabel(Self, FSendPanel, 'Final de linha', 614, 10);
  FEolCombo := TComboBox.Create(Self);
  FEolCombo.Parent := FSendPanel;
  FEolCombo.Left := 614;
  FEolCombo.Top := 30;
  FEolCombo.Width := 102;
  FEolCombo.Style := csDropDownList;
  FEolCombo.Items.Text :=
    'Nenhum' + LineEnding + 'CR' + LineEnding + 'LF' + LineEnding + 'CR+LF';
  FEolCombo.ItemIndex := 0;
  FEolCombo.Anchors := [akTop, akRight];

  FSendButton := TButton.Create(Self);
  FSendButton.Parent := FSendPanel;
  FSendButton.Left := 730;
  FSendButton.Top := 28;
  FSendButton.Width := 110;
  FSendButton.Height := 31;
  FSendButton.Caption := 'Enviar';
  FSendButton.Anchors := [akTop, akRight];
  FSendButton.OnClick := @SendButtonClick;

  FSendHelpLabel := TLabel.Create(Self);
  FSendHelpLabel.Parent := FSendPanel;
  FSendHelpLabel.Left := 12;
  FSendHelpLabel.Top := 76;
  FSendHelpLabel.Caption :=
    'HEX: use bytes como 01 0A FF ou 010AFF. Enter também envia.';

  FStatusBar := TStatusBar.Create(Self);
  FStatusBar.Parent := Self;
  FStatusBar.Align := alBottom;
  FStatusBar.SimplePanel := False;
  with FStatusBar.Panels.Add do Width := 270;
  with FStatusBar.Panels.Add do Width := 150;
  with FStatusBar.Panels.Add do Width := 150;
  with FStatusBar.Panels.Add do Width := 190;
end;

procedure Tfrmmain.LoadSettingsToUI;
begin
  FBaudCombo.ItemIndex := FSettings.BAUDRATE;
  FDataBitsCombo.ItemIndex := FSettings.DATABIT;
  FParityCombo.ItemIndex := FSettings.PARIDADE;
  FStopBitsCombo.ItemIndex := FSettings.STOPBIT;
end;

procedure Tfrmmain.SaveUIToSettings;
begin
  if not Assigned(FSettings) then Exit;

  FSettings.COMPORT := FPortCombo.Text;
  FSettings.BAUDRATE := FBaudCombo.ItemIndex;
  FSettings.DATABIT := FDataBitsCombo.ItemIndex;
  FSettings.PARIDADE := FParityCombo.ItemIndex;
  FSettings.STOPBIT := FStopBitsCombo.ItemIndex;
  FSettings.PosX := Left;
  FSettings.PosY := Top;
  FSettings.WindowWidth := Width;
  FSettings.WindowHeight := Height;
end;

procedure Tfrmmain.RefreshPorts;
var
  PreviousPort, ConnectedPort: string;
  Index: Integer;
begin
  PreviousPort := FPortCombo.Text;
  ConnectedPort := '';
  if FSerial.Active then
    ConnectedPort := FSerial.DeviceName;

  try
    FPortList.Refresh;
    FPortList.GetDeviceNames(FPortCombo.Items);

    Index := -1;
    if PreviousPort <> '' then
      Index := FPortCombo.Items.IndexOf(PreviousPort);

    if (Index < 0) and (FSettings.COMPORT <> '') then
      Index := FPortCombo.Items.IndexOf(FSettings.COMPORT);

    if (Index < 0) and (FPortCombo.Items.Count > 0) then
      Index := 0;

    FPortCombo.ItemIndex := Index;

    { O botão Atualizar também detecta remoção física da porta em uso. }
    if FSerial.Active and
       (FPortList.FindByDeviceName(ConnectedPort) = nil) then
    begin
      AddSystem('A porta ' + ConnectedPort +
        ' não está mais presente. A conexão será encerrada.');
      FSerial.ClosePort;
    end;

    if FPortCombo.Items.Count = 0 then
      FConnectionLabel.Caption := 'Nenhuma porta serial disponível'
    else if not FSerial.Active then
      FConnectionLabel.Caption :=
        Format('%d porta(s) serial(is) disponível(is)', [FPortCombo.Items.Count]);

    UpdatePortInfo;
    UpdateStatusBar;
  except
    on E: Exception do
    begin
      AddSystem('Erro ao atualizar portas: ' + E.Message);
      FConnectionLabel.Caption := 'Erro na detecção de portas';
    end;
  end;
end;

procedure Tfrmmain.UpdatePortInfo;
var
  D: TAIListSerialDeviceItem;
  S: string;
begin
  if FPortCombo.Text = '' then
  begin
    FPortInfoLabel.Caption := 'Nenhuma porta selecionada';
    Exit;
  end;

  D := FPortList.FindByDeviceName(FPortCombo.Text);
  if D = nil then
  begin
    FPortInfoLabel.Caption := FPortCombo.Text;
    Exit;
  end;

  S := D.DeviceName;
  if D.DisplayName <> '' then
    S := S + ' - ' + D.DisplayName;
  if D.Manufacturer <> '' then
    S := S + ' | ' + D.Manufacturer;
  if (D.VID <> '') or (D.PID <> '') then
    S := S + ' | VID:PID ' + D.VID + ':' + D.PID;

  FPortInfoLabel.Caption := S;
end;

procedure Tfrmmain.ConnectSerial;
begin
  if FSerial.Active then Exit;

  if FPortCombo.Text = '' then
  begin
    RefreshPorts;
    if FPortCombo.Text = '' then
    begin
      MessageDlg('SSC', 'Nenhuma porta serial disponível.',
        mtWarning, [mbOK], 0);
      Exit;
    end;
  end;

  FSerial.DeviceName := FPortCombo.Text;
  FSerial.BaudRate := StrToIntDef(FBaudCombo.Text, 9600);
  FSerial.DataBits := StrToIntDef(FDataBitsCombo.Text, 8);
  FSerial.StopBits := StrToIntDef(FStopBitsCombo.Text, 1);

  case FParityCombo.ItemIndex of
    1: FSerial.Parity := 'E';
    2: FSerial.Parity := 'O';
  else
    FSerial.Parity := 'N';
  end;

  if not FSerial.OpenPort then
  begin
    AddSystem('Falha ao abrir ' + FSerial.DeviceName + ': ' +
      FSerial.LastError);
    MessageDlg('Erro de conexão', FSerial.LastError,
      mtError, [mbOK], 0);
  end;
end;

procedure Tfrmmain.DisconnectSerial;
begin
  FSerial.ClosePort;
end;

procedure Tfrmmain.SetConnectedUI(AConnected: Boolean);
begin
  FPortCombo.Enabled := not AConnected;
  FBaudCombo.Enabled := not AConnected;
  FDataBitsCombo.Enabled := not AConnected;
  FParityCombo.Enabled := not AConnected;
  FStopBitsCombo.Enabled := not AConnected;

  { Atualizar permanece habilitado para detectar inserção/remoção de hardware. }
  FRefreshButton.Enabled := True;

  FConnectButton.Enabled := not AConnected;
  FDisconnectButton.Enabled := AConnected;
  FSendButton.Enabled := AConnected;
  FSendEdit.Enabled := AConnected;
end;

procedure Tfrmmain.SerialConnected(Sender: TObject);
begin
  FSettings.COMPORT := FSerial.DeviceName;
  FPollTimer.Enabled := True;
  SetConnectedUI(True);

  FConnectionLabel.Caption :=
    Format('Conectado: %s  %d %d%c%d',
      [FSerial.DeviceName, FSerial.BaudRate, FSerial.DataBits,
       FSerial.Parity, FSerial.StopBits]);

  AddSystem('Conectado em ' + FSerial.DeviceName + '.');
  UpdateStatusBar;
  FSendEdit.SetFocus;
end;

procedure Tfrmmain.SerialDisconnected(Sender: TObject);
begin
  FPollTimer.Enabled := False;
  SetConnectedUI(False);
  FConnectionLabel.Caption := 'Desconectado';
  AddSystem('Porta serial desconectada.');
  UpdateStatusBar;
end;

procedure Tfrmmain.PollTimerTimer(Sender: TObject);
begin
  if not FSerial.Active then Exit;

  try
    { Poll é o mecanismo de recepção previsto pelo TAISerialModem.
      Não fazemos Flush após leitura, evitando perda de bytes. }
    FSerial.Poll;
  except
    on E: Exception do
    begin
      AddSystem('Erro de recepção serial: ' + E.Message);
      FSerial.ClosePort;
    end;
  end;
end;

procedure Tfrmmain.SerialRX(Sender: TObject; const AData: string);
begin
  Inc(FRxBytes, Length(AData));
  AddTraffic('RX', AData);
  UpdateStatusBar;
end;

procedure Tfrmmain.SerialTX(Sender: TObject; const AData: string);
begin
  Inc(FTxBytes, Length(AData));
  AddTraffic('TX', AData);
  UpdateStatusBar;
end;

procedure Tfrmmain.RefreshButtonClick(Sender: TObject);
begin
  RefreshPorts;
end;

procedure Tfrmmain.PortComboChange(Sender: TObject);
begin
  UpdatePortInfo;
end;

procedure Tfrmmain.ConnectButtonClick(Sender: TObject);
begin
  ConnectSerial;
end;

procedure Tfrmmain.DisconnectButtonClick(Sender: TObject);
begin
  DisconnectSerial;
end;

procedure Tfrmmain.ClearButtonClick(Sender: TObject);
begin
  FLogMemo.Clear;
  FRxBytes := 0;
  FTxBytes := 0;
  UpdateStatusBar;
end;

procedure Tfrmmain.SaveButtonClick(Sender: TObject);
begin
  if FSaveDialog.Execute then
  begin
    try
      FLogMemo.Lines.SaveToFile(FSaveDialog.FileName);
      AddSystem('Log salvo em ' + FSaveDialog.FileName);
    except
      on E: Exception do
        MessageDlg('Erro ao salvar', E.Message, mtError, [mbOK], 0);
    end;
  end;
end;

procedure Tfrmmain.SendButtonClick(Sender: TObject);
var
  Data: string;
begin
  if not FSerial.Active then
  begin
    AddSystem('Não é possível transmitir: porta desconectada.');
    Exit;
  end;

  if FSendModeCombo.ItemIndex = 1 then
  begin
    if not TryParseHex(FSendEdit.Text, Data) then
    begin
      MessageDlg('HEX inválido',
        'Informe pares hexadecimais, por exemplo: 01 0A FF.',
        mtWarning, [mbOK], 0);
      Exit;
    end;
  end
  else
    Data := FSendEdit.Text;

  Data := ApplyEOL(Data);

  if not FSerial.WriteText(Data) then
    AddSystem('Erro de transmissão: ' + FSerial.LastError);
end;

procedure Tfrmmain.SendEditKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
  begin
    Key := #0;
    SendButtonClick(FSendButton);
  end;
end;

function Tfrmmain.DataToHex(const AData: string): string;
var
  I: Integer;
begin
  Result := '';
  for I := 1 to Length(AData) do
  begin
    if Result <> '' then
      Result := Result + ' ';
    Result := Result + IntToHex(Ord(AData[I]), 2);
  end;
end;

function Tfrmmain.DataToVisibleText(const AData: string): string;
var
  I: Integer;
  C: Byte;
begin
  Result := '';
  for I := 1 to Length(AData) do
  begin
    C := Ord(AData[I]);
    case C of
      9: Result := Result + '<TAB>';
      10: Result := Result + '<LF>' + LineEnding;
      13: Result := Result + '<CR>';
      32..255: Result := Result + AData[I];
    else
      Result := Result + '<' + IntToHex(C, 2) + '>';
    end;
  end;
end;

function Tfrmmain.FormatData(const AData: string): string;
begin
  case FDisplayModeCombo.ItemIndex of
    1: Result := DataToHex(AData);
    2: Result := DataToVisibleText(AData) + '    | ' + DataToHex(AData);
  else
    Result := DataToVisibleText(AData);
  end;
end;

function Tfrmmain.TryParseHex(const AText: string; out AData: string): Boolean;
var
  Clean: string;
  I, V: Integer;
  Pair: string;
begin
  Result := False;
  AData := '';

  Clean := StringReplace(AText, '0x', '', [rfReplaceAll, rfIgnoreCase]);
  Clean := StringReplace(Clean, ' ', '', [rfReplaceAll]);
  Clean := StringReplace(Clean, #9, '', [rfReplaceAll]);
  Clean := StringReplace(Clean, '-', '', [rfReplaceAll]);
  Clean := StringReplace(Clean, ':', '', [rfReplaceAll]);

  if Clean = '' then
  begin
    Result := True;
    Exit;
  end;

  if Odd(Length(Clean)) then Exit;

  I := 1;
  while I <= Length(Clean) do
  begin
    Pair := Copy(Clean, I, 2);
    if not TryStrToInt('$' + Pair, V) then Exit;
    AData := AData + Chr(V);
    Inc(I, 2);
  end;

  Result := True;
end;

function Tfrmmain.ApplyEOL(const AData: string): string;
begin
  Result := AData;
  case FEolCombo.ItemIndex of
    1: Result := Result + #13;
    2: Result := Result + #10;
    3: Result := Result + #13#10;
  end;
end;

procedure Tfrmmain.AddTraffic(const APrefix, AData: string);
var
  S: string;
begin
  if FTimestampCheck.Checked then
    S := FormatDateTime('hh:nn:ss.zzz', Now) + ' '
  else
    S := '';

  S := S + APrefix + '  ' + FormatData(AData);
  if not S.EndsWith(LineEnding) then
    S := S + LineEnding;

  AppendLog(S);
end;

procedure Tfrmmain.AddSystem(const AMessage: string);
begin
  AppendLog(FormatDateTime('hh:nn:ss.zzz', Now) +
    ' SYS ' + AMessage + LineEnding);
end;

procedure Tfrmmain.AppendLog(const AText: string);
begin
  FLogMemo.SelStart := Length(FLogMemo.Text);
  FLogMemo.SelLength := 0;
  FLogMemo.SelText := AText;

  TrimLog;

  if FAutoScrollCheck.Checked then
  begin
    FLogMemo.SelStart := Length(FLogMemo.Text);
    FLogMemo.SelLength := 0;
  end;
end;

procedure Tfrmmain.TrimLog;
var
  S: string;
  CutAt: Integer;
begin
  if Length(FLogMemo.Text) <= MAX_LOG_CHARS then Exit;

  S := FLogMemo.Text;
  CutAt := Length(S) div 2;
  while (CutAt < Length(S)) and
        not (S[CutAt] in [#10, #13]) do
    Inc(CutAt);

  Delete(S, 1, CutAt);
  FLogMemo.Text := S;
end;

procedure Tfrmmain.UpdateStatusBar;
var
  StateText: string;
begin
  if FSerial.Active then
    StateText := 'Conectado: ' + FSerial.DeviceName
  else
    StateText := 'Desconectado';

  FStatusBar.Panels[0].Text := StateText;
  FStatusBar.Panels[1].Text := 'RX: ' + IntToStr(FRxBytes) + ' bytes';
  FStatusBar.Panels[2].Text := 'TX: ' + IntToStr(FTxBytes) + ' bytes';
  FStatusBar.Panels[3].Text :=
    'Portas: ' + IntToStr(FPortCombo.Items.Count);
end;

end.
