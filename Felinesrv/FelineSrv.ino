
#include <Ethernet.h>
#include <SPI.h>
#include <SD.h>
#include <EEPROM.h>

boolean erro = true; 

// Enter a MAC address and IP address for your controller below.
// The IP address will be dependent on your local network.
// gateway and subnet are optional:
byte mac[] = {  0x0C, 0xBA, 0xBB, 0xCC, 0xDE, 0x02 };

IPAddress ip(192, 168, 2, 70);
IPAddress myDns(192, 168, 0, 1);
IPAddress gateway(192, 168, 0, 1);
IPAddress subnet(255, 255, 255, 0);

EthernetClient sckclient;

int porta = 8088;
int portaweb = 80;

int pinEcho = 11;
int pinTeste = 12;
int pinConected = 13;
const int pinSD = 4;
int pinEthernet = 10;

String BufferIn = "";
String InSer = "";
String OutSer = "";
String InSck = "";
String OutSck = "";


File dataFile; //Ponteiro de arquivo
Sd2Card card;
SdVolume volume;
SdFile root;

// telnet defaults to port 23
EthernetServer server(porta);

// telnet defaults to port 23
EthernetServer web(portaweb);

boolean debuparando = true;
boolean echo = true;
boolean sd = true;

void Web_Cliente();

void debug(String info){
  if (debuparando) {
    Serial.println( info);
  }
  if(sd) {
    dataFile = SD.open("log.txt", FILE_WRITE);  
    dataFile.println(info);
    dataFile.close();
  }
  else
  {
    BufferIn = BufferIn + info;
  }
}


void Testa_debug(){
 int sensor = digitalRead(pinTeste);
 
 if (sensor ==0 ){
  debuparando = 0;
 }
 debug("Sensor debug:"+String(sensor));
 echo = digitalRead(pinEcho);
 
 debug("Sensor echo:"+String(echo)); 
}


void Conectado(){
 digitalWrite(pinConected, HIGH);
}


void Desconectado(){
 digitalWrite(pinConected, LOW);

}

void Start_Digital(){
  pinMode(pinTeste, INPUT);
  pinMode(pinConected, OUTPUT);
}

void Start_card(){
  //debug("Initializing card card...");
  // disable SD card if one in the slot
  pinMode(pinSD,OUTPUT);
  digitalWrite(pinSD,HIGH);
  digitalWrite(pinEthernet, LOW);  // Ethernet ACTIVE
  
  // see if the card is present and can be initialized:
  if (!SD.begin(pinSD)) {
    debug(" card failed, or not present");
    sd = false;
  } else
  {
     // Now we will try to open the 'volume'/'partition' - it should be FAT16 or FAT32
    if (!volume.init(card)) {
      debug("Could not find FAT16/FAT32 partition.\nMake sure you've formatted the card");
      //while (1);
      }
    else
    {
      cardType();
      cardSize();
      cardroot();
    }
    debug(" card initialized.");
  }
}

void cardType(){
    // print the type of card
  Serial.println();
  Serial.print("card type:         ");
  switch (card.type()) {
    case SD_CARD_TYPE_SD1:
      debug("card1");
      break;
    case SD_CARD_TYPE_SD2:
      debug("card2");
      break;
    case SD_CARD_TYPE_SDHC:
      debug("cardHC");
    default:
      debug("Unknown");
  }
}

void cardSize(){
  Serial.print("Clusters:          ");
  Serial.println(volume.clusterCount());
  Serial.print("Blocks x Cluster:  ");
  Serial.println(volume.blocksPerCluster());

  Serial.print("Total Blocks:      ");
  Serial.println(volume.blocksPerCluster() * volume.clusterCount());
  Serial.println();

  // print the type and size of the first FAT-type volume
  uint32_t volumesize;
  Serial.print("Volume type is:    FAT");
  Serial.println(volume.fatType(), DEC);

  volumesize = volume.blocksPerCluster();    // clusters are collections of blocks
  volumesize *= volume.clusterCount();       // we'll have a lot of clusters
  volumesize /= 2;                           // card card blocks are always 512 bytes (2 blocks are 1KB)
  Serial.print("Volume size (Kb):  ");
  Serial.println(volumesize);
  Serial.print("Volume size (Mb):  ");
  volumesize /= 1024;
  Serial.println(volumesize);
  Serial.print("Volume size (Gb):  ");
  Serial.println((float)volumesize / 1024.0);
}

void cardroot(){
  root.openRoot(volume);
}

void cardls(){
  // list all files in the card with date and size
  root.ls(LS_R | LS_DATE | LS_SIZE);
}

void Start_Serial(){
  // Open serial communications and wait for port to open:
  Serial.begin(2400);
  //Serial.begin(115200);
  /*
  while (!Serial) {
    
    ; // wait for serial port to connect. Needed for native USB port only
  }*/
  
}

void Start_Ethernet(){
  // You can use Ethernet.init(pin) to configure the CS pin
  //Ethernet.init(10);  // Most Arduino shields
  //Ethernet.init(5);   // MKR ETH shield
  //Ethernet.init(0);   // Teensy 2.0
  //Ethernet.init(20);  // Teensy++ 2.0
  //Ethernet.init(15);  // ESP8266 with Adafruit Featherwing Ethernet
  //Ethernet.init(33);  // ESP32 with Adafruit Featherwing Ethernet
  
  // start the Ethernet connection:
  // disable w5100 SPI
  pinMode(pinSD,OUTPUT);
  pinMode(pinEthernet,OUTPUT);
  digitalWrite(pinEthernet,HIGH);
  digitalWrite(pinSD,LOW);
  Ethernet.init(pinEthernet);  // Most Arduino shields
 
  while (erro) {
    debug("Buscando DHCP...");
    if (Ethernet.begin(mac) == 0) {
       debug("Falhou ao achar servidor DHCP");
       // Check for Ethernet hardware presen

       Ethernet.begin(mac, ip, myDns, gateway, subnet);
       debug("IP Imposto!");
       erro = false;        
    } 
    else
    {
      erro = false;   
      
    }
  }
}

void MeuIP(){
  // print your local IP address:
  
  debug("Meu Endereco: "+String(Ethernet.localIP()[0])+"."+String(Ethernet.localIP()[1])+"."+String(Ethernet.localIP()[2])+"."+String(Ethernet.localIP()[3]));
}


void Start_Server(){
  
  // start listening for clients
  
  debug("Iniciando Servico Web");
  web.begin();
  debug("Iniciando Servico na Porta 8088");
  server.begin();
}

void OpenFile(){
  dataFile = SD.open("log.txt",FILE_WRITE);   
}



void CloseFile(){
  dataFile.close();
}

void LogDel(){
  if (sd) {
    if (SD.exists("log.txt")){
      SD.remove("log.txt");
    }
    
  }
}

void setup() {  
// debuparando = 1;
 Start_Serial();
 if (debuparando) Serial.println("Inicio...");

 Start_Ethernet();  
 
 if (debuparando) Serial.println("Setup Digital.."); 
 Start_Digital();
 MeuIP();   
 if (debuparando) Serial.println("SERVER...");   
 Start_Server();
 if (debuparando) Serial.println("card...");
 Start_card();
 if (sd) debug("card failed, or not present");
 if (debuparando) Serial.println("INICIOU"); 
 if (debuparando) Serial.println("LOG..."); 
 LogDel();
 Testa_debug(); 
 if (debuparando) {Serial.println("INICIOU GATEWAY");}

}


void Le_Cliente(EthernetClient client){
  if (client.available()) {
    // read the bytes incoming from the client:
    char thisChar = client.read();
    
    Serial.print(thisChar);
    InSck = InSck + thisChar;
    debug("client:"+String(thisChar));
    if (echo) { //Controle de Echo
      OutSck = OutSck + thisChar;
      client.write(thisChar);
    }

  }
}

void Le_Serial(EthernetClient sckcli){
    // echo the bytes to the server as well:
    char info;
    if (Serial.available() > 0)  {

      info= Serial.read();     
      InSer = InSer +info;
      debug("Serial:"+String(info));
      
      sckcli.write(info);
      if (echo) { //Controle de Echo
        Serial.write(info);
        OutSer = OutSer + info;
      }      
    }
}


void PaginaErro(String In,EthernetClient client){
          client.println("HTTP/1.1 404 ERRO");     
  
}

void LeLOGcard(EthernetClient client){
  if (sd){
    dataFile = SD.open("log.txt");   
    while (dataFile.available()) {
      char linha = dataFile.read();            
      client.print(linha);
    }
    CloseFile();
  }
  else
  {
    client.print(BufferIn);
    BufferIn = "";
  }

}

void PaginaIndex(String InW,EthernetClient client){
          client.println("HTTP/1.1 200 OK");    
          client.println("Content-Type: text/html");
          client.println("Connection: close");  // the connection will be closed after completion of the response
          client.println("Refresh: 5");  // refresh the page automatically every 5 sec                     
          //delay(10);
          client.println();  
          client.println();
          client.println();
          client.println();
          //debug("IN:"+In);
   
          client.println("<!DOCTYPE HTML>");          
          client.println("<html>");  
          client.println("<head>");  
          client.println("<link rel='stylesheet' href='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css' integrity='sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T' crossorigin='anonymous'>");              
          client.println("<script src='https://code.jquery.com/jquery-3.3.1.slim.min.js' integrity='sha384-q8i/X+965DzO0rT7abK41JStQIAqVgRVzpbzo5smXKp4YfRvH+8abtTE1Pi6jizo' crossorigin='anonymous'></script>");            
          client.println("<script src='https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js' integrity='sha384-UO2eT0CpHqdSJQ6hJty5KVphtPhzWj9WO1clHTMGa3JDZwrnQq4sF86dIHNDz0W1' crossorigin='anonymous'></script>");            
          client.println("<script src='https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js' integrity='sha384-JjSmVgyd0p3pXB1rRibZUAYoIIy6OrQ6VrjIEaFf/nJGzIxFDsf4x0xIM+B07jRM' crossorigin='anonymous'></script>");            
          client.println("</head>");
          client.println("<body class='bg-light'>");
          client.println("<div class='py-5'><H1><center>Analizador de Protocolo</center></H1></div>");
          client.println("<div class='row'>");
          client.println("<div class='col-md-2'><strong>Echo:</strong>"+String((echo==1)?"Ativo":"Desativado")+"</div>");
          client.println("<div class='col-md-1'><strong>ClienteSck:</strong></div><div " \
                          +String(sckclient.connected()?" class='col-md-2 text-success'":" class='col-md-2 text-danger'")\ 
                          +">"+String(sckclient.connected()?"Conectado":"Nao Conectado") \ 
                          +"</div>");
          client.println("<div class='col-md-2'><strong>card:</strong>"+String(!sd?"Nao presente":"Presente")+"</div>");
          client.println("<div class='col-md-2'><strong>Debug:</strong>"+String(debuparando?"DEBUG ON":"DEBUG OFF")+"</div>");
          client.println("</div>");
          client.println("<div>Log:<br/><textarea name='bufferout' rows='3' cols='80'>");          
          if (sd){
            LeLOGcard(client);
          }
          else
          {
            client.print(BufferIn);
            BufferIn = "";
          }
          client.println("</textarea></div></br>");
          client.println("<div>Client Web:<br/><textarea name='bufferout' rows='3' cols='80'>");
          client.print(InW);          
          client.println("</textarea></div></br>");             
          
          client.println("<div>Socket In:<br/><textarea name='bufferout' rows='3' cols='80'>");
          client.print(InSck);          
          InSck = "";
          client.println("</textarea></div></br>");             
          client.println("<div>Socket Out:<br/><textarea name='bufferout' rows='3' cols='80'>");
          client.print(OutSck);          
          OutSck = "";
          client.println("</textarea></div></br>");                       
          client.println("<div>Serial In:<br/><textarea name='bufferout' rows='3' cols='80'>");
          client.print(InSer);          
          InSer = "";
          client.println("</textarea></div></br>");                                 
          client.println("<div>Serial Out:<br/><textarea name='bufferout' rows='3' cols='80'>");
          client.print(OutSer);          
          OutSer = "";
          client.println("</textarea></div></br>");                                           
          client.println("</body>");
          client.println("</html>");
          
          client.println();
  
}

//**Futura pesquisa de paginas do card
int RefPagina(String In, EthernetClient client){
   return In.indexOf("GET /");
   
}

void Paginas(String In,EthernetClient client){
          if (RefPagina(In, client)>=0){
            PaginaIndex(In, client);
            }                
          else  {            
            PaginaErro(In, client);
          }
          
}

void Web_Cliente(){
  // listen for incoming clients
  EthernetClient webclient = web.available();
  String BufferSitein = "";
  if (webclient) {
    //debug("new web client");
    // an http request ends with a blank line
    boolean currentLineIsBlank = true;
    while (webclient.connected()) {
      if (webclient.available()) {
        char c = webclient.read();
        BufferSitein = BufferSitein + c;
        //debug(c);
        // if you've gotten to the end of the line (received a newline
        // character) and the line is blank, the http request has ended,
        // so you can send a reply
        if (c == '\n' && currentLineIsBlank) {
          // send a standard http response header
          //debug(BufferSitein);
          Paginas(BufferSitein, webclient);
          BufferSitein = "";

          break;
        }

        if (c == '\n') {
          // you're starting a new line
          currentLineIsBlank = true;
        } else if (c != '\r') {
          // you've gotten a character on the current line
          currentLineIsBlank = false;
        }
      }
    }
    // give the web browser time to receive the data
    delay(30);
    // close the connection:
    if (webclient.connected()){
      webclient.stop();
      //debug("web disconnected");
    }
   // client.close();
  }
}


int Tem_Cliente(){
      int conectou = 0;
      //while (sckclient.available()>0) {         
      while (sckclient.connected()) {         
          conectou = 1;
          Le_Cliente(sckclient);
          Le_Serial(sckclient);        
          Web_Cliente();
         
      }
      if (conectou == 1){
          if (!sckclient.connected()) {
            debug("Cliente desconectou!");
            Desconectado(); 
            return(1);         
          }  
      }                    
      return(0);         
}

void loop() {
    sckclient = server.available();
    //sckclient = server.available();
    //debug("Status Socket:"+String(sckclient.connected()));
    if(sckclient>0){
      //sckclient.flush();
      debug("Nova conexao foi estabelecida!");
      debug("connected to "+ String(sckclient.remoteIP()[0])+"."+
                             String(sckclient.remoteIP()[1])+"."+
                             String(sckclient.remoteIP()[2])+"."+
                             String(sckclient.remoteIP()[3])
                             );
      //sckclient.write("Bem vindo GATEWAY ON!");
      Conectado();   
      Tem_Cliente();
    }
    Web_Cliente();
   

}
