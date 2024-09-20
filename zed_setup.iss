#define MyAppName "Zed"
#define MyAppVersion "0.0.0"  ; This will be dynamically updated by the workflow
#define MyAppPublisher "Zed Industries"
#define MyAppExeName "zed.exe"

[Setup]
; NOTE: The value of AppId uniquely identifies this application. Do not use the same AppId value in installers for other applications.
; Generate a new GUID for your application using the command [guid]::NewGuid() in PowerShell or an online GUID generator.
AppId={{DEC54CF2-B010-495E-A78B-BD7E1DED610A}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
DefaultDirName={autopf}\{#MyAppName}
DisableProgramGroupPage=yes
OutputBaseFilename=ZedInstaller-{#MyAppVersion}
Compression=lzma
SolidCompression=yes
WizardStyle=modern
UninstallDisplayIcon={app}\{#MyAppExeName}
ChangesAssociations=yes

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked
Name: "quicklaunchicon"; Description: "{cm:CreateQuickLaunchIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked; OnlyBelowVersion: 6.1; Check: not IsAdminInstallMode
Name: "associatefiles"; Description: "Associate Zed with all file types"; GroupDescription: "File associations:"; Flags: unchecked

[Files]
Source: "zed-release\zed.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon
Name: "{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: quicklaunchicon

[Registry]
Root: HKCR; Subkey: "*\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Open with {#MyAppName}"; Flags: uninsdeletekey
Root: HKCR; Subkey: "*\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey
Root: HKCR; Subkey: "Applications\{#MyAppExeName}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""; Flags: uninsdeletekey

[Code]
procedure CurStepChanged(CurStep: TSetupStep);
var
  ResultCode: Integer;
begin
  if CurStep = ssPostInstall then
  begin
    if WizardIsTaskSelected('associatefiles') then
    begin
      // Associate Zed with all file types
      Exec(ExpandConstant('{sys}\ftype.exe'), '.=ZedFile', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
      Exec(ExpandConstant('{sys}\assoc.exe'), '.=ZedFile', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    end;
  end;
end;

procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
  ResultCode: Integer;
begin
  if CurUninstallStep = usPostUninstall then
  begin
    // Remove desktop icon
    DeleteFile(ExpandConstant('{userdesktop}\{#MyAppName}.lnk'));
    
    // Remove Quick Launch icon
    DeleteFile(ExpandConstant('{userappdata}\Microsoft\Internet Explorer\Quick Launch\{#MyAppName}.lnk'));
    
    // Remove file associations
    Exec(ExpandConstant('{sys}\ftype.exe'), 'ZedFile=', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    Exec(ExpandConstant('{sys}\assoc.exe'), '.=', '', SW_HIDE, ewWaitUntilTerminated, ResultCode);
    
    // Clean up registry
    RegDeleteKeyIncludingSubkeys(HKCR, '*\shell\{#MyAppName}');
    RegDeleteKeyIncludingSubkeys(HKCR, 'Applications\{#MyAppExeName}');
  end;
end;
