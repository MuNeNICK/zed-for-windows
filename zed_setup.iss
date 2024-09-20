#define MyAppName "Zed"
#define MyAppVersion "0.0.0"  ; This will be dynamically updated by the workflow
#define MyAppPublisher "Zed Industries"
#define MyAppExeName "zed.exe"

[Setup]
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

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "zed-release\zed.exe"; DestDir: "{app}"; Flags: ignoreversion

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Registry]
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}"; ValueType: string; ValueName: ""; ValueData: "Open with {#MyAppName}"
Root: HKCR; Subkey: "Directory\shell\{#MyAppName}\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""

[Code]
var
  InstallationPage: TInputDirWizardPage;
  ShortcutsPage: TInputOptionWizardPage;
  AdditionalSettingsPage: TInputOptionWizardPage;

procedure InitializeWizard;
begin
  // Installation directory page
  InstallationPage := CreateInputDirPage(wpSelectDir,
    'Select Installation Directory', 'Where should Zed be installed?',
    'Select the folder in which to install Zed, then click Next.',
    False, '');
  InstallationPage.Add('');
  InstallationPage.Values[0] := ExpandConstant('{autopf}\{#MyAppName}');

  // Shortcuts page
  ShortcutsPage := CreateInputOptionPage(InstallationPage.ID,
    'Shortcut Options', 'Where would you like shortcuts to be created?',
    'Select the locations for shortcuts, then click Next.',
    False, False);
  ShortcutsPage.Add('Create a desktop shortcut');
  ShortcutsPage.Add('Create a Quick Launch shortcut');

  // Additional settings page
  AdditionalSettingsPage := CreateInputOptionPage(ShortcutsPage.ID,
    'Additional Settings', 'Configure additional options',
    'Select any additional settings you would like to apply, then click Next.',
    False, False);
  AdditionalSettingsPage.Add('Add Zed to system PATH');
  AdditionalSettingsPage.Add('Associate .txt files with Zed');
end;

function NextButtonClick(CurPageID: Integer): Boolean;
begin
  if CurPageID = InstallationPage.ID then
    WizardForm.DirEdit.Text := InstallationPage.Values[0];
  
  Result := True;
end;

procedure CurStepChanged(CurStep: TSetupStep);
var
  Path: string;
begin
  if CurStep = ssPostInstall then
  begin
    if AdditionalSettingsPage.Values[0] then
    begin
      // Add to PATH
      Path := ExpandConstant('{app}');
      if not RegQueryStringValue(HKEY_LOCAL_MACHINE,
        'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
        'Path', Path) then
        Path := '';
      if Pos(';' + UpperCase(ExpandConstant('{app}')) + ';', ';' + UpperCase(Path) + ';') = 0 then
      begin
        Path := Path + ';' + ExpandConstant('{app}');
        RegWriteStringValue(HKEY_LOCAL_MACHINE,
          'SYSTEM\CurrentControlSet\Control\Session Manager\Environment',
          'Path', Path);
      end;
    end;

    if AdditionalSettingsPage.Values[1] then
    begin
      // Associate .txt files
      RegWriteStringValue(HKCR, '.txt\OpenWithProgids', 'ZedFile', '');
      RegWriteStringValue(HKCR, 'ZedFile', '', 'Zed Text File');
      RegWriteStringValue(HKCR, 'ZedFile\DefaultIcon', '', ExpandConstant('{app}\{#MyAppExeName},0'));
      RegWriteStringValue(HKCR, 'ZedFile\shell\open\command', '', '"' + ExpandConstant('{app}\{#MyAppExeName}') + '" "%1"');
    end;
  end;
end;
