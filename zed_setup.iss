#define MyAppName "Zed"
#define MyAppVersion "0.0.0"  ; This will be dynamically updated by the workflow
#define MyAppPublisher "Zed Industries"
#define MyAppURL "https://zed.dev"
#define MyAppExeName "zed.exe"

[Setup]
AppId={{DEC54CF2-B010-495E-A78B-BD7E1DED610A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=ZedInstaller-{#MyAppVersion}
Compression=lzma2/ultra64
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\{#MyAppExeName}
ChangesAssociations=yes
PrivilegesRequired=lowest
PrivilegesRequiredOverridesAllowed=dialog

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "associatefiles"; Description: "Associate Zed with supported file types"; GroupDescription: "File associations:"; Flags: unchecked

[Files]
Source: "zed-release\zed.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKCU; Subkey: "Software\Classes\*\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Open with {#MyAppName}"; Flags: uninsdeletekey; Tasks: associatefiles
Root: HKCU; Subkey: "Software\Classes\*\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey; Tasks: associatefiles

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('associatefiles') then
    begin
      // Associate Zed with specific file types
      // Add your specific file associations here
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Remove desktop icon
    DeleteFile(ExpandConstant('{userdesktop}\{#MyAppName}.lnk'));
    
    // Remove file associations
    RegDeleteKeyIncludingSubkeys(HKCU, 'Software\Classes\*\shell\{#MyAppName}');
  end;
end;
