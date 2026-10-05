#define MyAppName "SSC Serial Analyzer"
#define MyAppVersion "3.0.0"
#define MyAppPublisher "Maurinsoft"
#define MyAppURL "https://github.com/marcelomaurin/SSC"
#define MyAppExeName "ssc.exe"

[Setup]
AppId={{81657C6C-4AC4-4959-8BFA-598E9BBAA4B0}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppVerName={#MyAppName} {#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\SSC3
DefaultGroupName=SSC3
OutputDir=..\..\bin\win_X64
OutputBaseFilename=setup_3.0.0
Compression=lzma2
SolidCompression=yes
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
WizardStyle=modern
UninstallDisplayIcon={app}\{#MyAppExeName}

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "spanish"; MessagesFile: "compiler:Languages\Spanish.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "german"; MessagesFile: "compiler:Languages\German.isl"
Name: "russian"; MessagesFile: "compiler:Languages\Russian.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "..\..\src\ssc.exe"; DestDir: "{app}"; Flags: ignoreversion
Source: "..\..\README.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.en.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.es.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.fr.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.de.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.ru.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.zh-CN.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.ar.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\README.hi.md"; DestDir: "{app}\docs"; Flags: ignoreversion
Source: "..\..\LICENSE"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{group}\SSC Serial Analyzer"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\SSC Serial Analyzer"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,SSC Serial Analyzer}"; Flags: nowait postinstall skipifsilent
