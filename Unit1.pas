unit Unit1;

interface

uses
  // Various units used in the form
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.WinXCtrls, Vcl.Menus, Vcl.StdCtrls, Vcl.ComCtrls, System.ImageList,
  Vcl.ImgList, MediumIL, scControls, scGPControls, Vcl.Imaging.jpeg,
  CnWaterImage;

type
  TForm1 = class(TForm)
    // UI components on the form
    StatusBar1: TStatusBar;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    TabSheet3: TTabSheet;
    GroupBox2: TGroupBox;
    RichEdit2: TRichEdit;
    Label2: TLabel;
    Edit2: TEdit;
    Button7: TButton;
    Button8: TButton;
    SplitView1: TSplitView;
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    ImageList1: TImageList;
    OpenDialog: TOpenDialog;
    Button5: TButton;
    PopupMenu1: TPopupMenu;
    C1: TMenuItem;
    CnWaterImage2: TCnWaterImage;
    scGPLabel1: TscGPLabel;
    Label1: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Timer1: TTimer;

    // Event handlers
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure C1Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure Label2MouseEnter(Sender: TObject);
    procedure Edit2MouseEnter(Sender: TObject);
    procedure Button7MouseEnter(Sender: TObject);
    procedure Button8MouseEnter(Sender: TObject);
    procedure GroupBox2MouseEnter(Sender: TObject);
    procedure RichEdit2MouseEnter(Sender: TObject);
    procedure Button5MouseEnter(Sender: TObject);
    procedure StatusBar1MouseEnter(Sender: TObject);
    procedure Label1MouseEnter(Sender: TObject);
    procedure TabSheet2MouseEnter(Sender: TObject);
    procedure Label3MouseEnter(Sender: TObject);
    procedure Label4MouseEnter(Sender: TObject);
    procedure CnWaterImage2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SplitView1Opened(Sender: TObject);
    procedure SplitView1Closed(Sender: TObject);

  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

function IsUserAnAdmin: Boolean;
var
  Token: THandle;
  TokenInfo: TTokenElevation;
  TokenInfoSize: DWORD;
begin
  Result := False;
  if OpenProcessToken(GetCurrentProcess, TOKEN_QUERY, Token) then
    try
      TokenInfoSize := SizeOf(TokenInfo);
      if GetTokenInformation(Token, TokenElevation, @TokenInfo, TokenInfoSize, TokenInfoSize) then
        Result := TokenInfo.TokenIsElevated <> 0; // Convert DWORD to Boolean
    finally
      CloseHandle(Token);
    end;
end;

procedure closemenu;
begin
  if Form1.SplitView1.Opened then
    Form1.SplitView1.Close; // Close SplitView if it's open
end;

procedure CaseOfNotAdmin; // Display message when not running with UAC permissions
begin
  // Display a message warning the user about not having UAC privileges
  Form1.RichEdit2.Clear;
  Form1.RichEdit2.Lines.Add('This application is not running under UAC Admin permissions!');
  Sleep(1500);
  Form1.RichEdit2.Lines.Add('You will be unable to use this application if running as NON-UAC!');
end;

procedure TForm1.Button1Click(Sender: TObject);
begin
  // Set the active tab to the first page
  Self.PageControl1.ActivePageIndex := 0;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  // Set the active tab to the second page
  Self.PageControl1.ActivePageIndex := 1;
end;

procedure TForm1.Button3Click(Sender: TObject);
begin
  // Set the active tab to the third page
  Self.PageControl1.ActivePageIndex := 2;
end;

procedure TForm1.Button4Click(Sender: TObject);
begin
  // Toggle SplitView open/close state
  if Self.SplitView1.Opened then
    Self.SplitView1.Close
  else
    Self.SplitView1.Opened := True;
end;

procedure TForm1.Button5Click(Sender: TObject);
begin
  // Clear RichEdit and enable Timer
  Self.RichEdit2.Clear;
  Self.Timer1.Enabled := True;
end;

procedure TForm1.Button5MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Button7Click(Sender: TObject);
begin
  // Open a file dialog and set the file path to Edit2
  if Self.OpenDialog.Execute then
    if FileExists(Self.OpenDialog.FileName) then
    begin
      Self.Edit2.Text := Self.OpenDialog.FileName;
      Self.Button8.Enabled := True;
      Self.RichEdit2.Lines.Add('File selected! Ready to execute at a lower privilege level!');
    end;
end;

procedure TForm1.Button7MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  StartupInfo: TStartupInfo;
  ProcessInfo: TProcessInformation;
  ResultCode: DWORD;
begin
  // Initialize StartupInfo and ProcessInfo to zero
  ZeroMemory(@StartupInfo, SizeOf(StartupInfo));
  ZeroMemory(@ProcessInfo, SizeOf(ProcessInfo));
  StartupInfo.cb := SizeOf(StartupInfo);

  // Create a new process with medium integrity level (lower than UAC)
  ResultCode := CreateProcessMediumIL(PChar(Edit2.Text), nil, nil, nil, False, 0, nil, nil, StartupInfo, ProcessInfo);

  // Check the result of process creation
  if ResultCode = ERROR_SUCCESS then
  begin
    Self.RichEdit2.Lines.Add('Process created successfully!');
    Self.StatusBar1.Panels[0].Text := 'Status: Executed New Process Successfully!';
  end
  else
  begin
    Self.RichEdit2.Lines.Add('Failed to create process. Error: ' + IntToStr(ResultCode));
    Self.RichEdit2.Lines.Add('The file either has a UAC manifest or hardcoded code within itself which only allows it to execute under UAC privilege level!');
    Self.StatusBar1.Panels[0].Text := 'Status: Issue Running New Process!';
  end;
end;

procedure TForm1.Button8MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.C1Click(Sender: TObject);
begin
  // Clear RichEdit and enable Timer
  Self.RichEdit2.Clear;
  Self.Timer1.Enabled := True;
end;

procedure TForm1.CnWaterImage2MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
begin
  // Close SplitView if the mouse moves over the image
  if Self.SplitView1.Opened = False then
    Exit;
  Self.SplitView1.Close;
end;

procedure TForm1.Edit2MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  // Hide tab sheets and set the initial active page index
  Self.PageControl1.Pages[0].TabVisible := False;
  Self.PageControl1.Pages[1].TabVisible := False;
  Self.PageControl1.Pages[2].TabVisible := False;
  Self.PageControl1.ActivePageIndex := 0;

  // Check if the application is running with admin privileges
  if IsUserAnAdmin then
  begin
    self.RichEdit2.SelAttributes.Color := CLlime;
    Self.RichEdit2.Lines.Add('This Application Instance is Running As UAC Admin!');
  end
  else
  begin
    ShowMessage('This Application Must Be Ran As UAC Admin Elevated Privilage Level.');
    Halt;
  end;
end;

procedure TForm1.GroupBox2MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Label1MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Label2MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Label3MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Label4MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.RichEdit2MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.StatusBar1MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.TabSheet2MouseEnter(Sender: TObject);
begin
  closemenu; // Close the menu on mouse enter
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
  // Timer event for clearing StatusBar text after a period
  Self.StatusBar1.Panels[0].Text := 'Status: Waiting...';
  Timer1.Enabled := False; // Disable the timer after resetting the status
end;

procedure TForm1.SplitView1Closed(Sender: TObject);
begin
  // Update button captions and alignments when the SplitView is opened
  Button4.Caption := '';

  // Check the button's ImageAlignment property; it may not exist in all Delphi versions
  Button4.ImageAlignment := TImageAlignment(4);
  // Alternatively, use Button4.ImagePosition := ipTop if it exists

  Button1.Caption := '';
  Button1.ImageAlignment := TImageAlignment(4);
  Button2.Caption := '';
  Button2.ImageAlignment := TImageAlignment(4);
  Button3.Caption := '';
  Button3.ImageAlignment := TImageAlignment(4);
  // Handle SplitView close event to update the status
  Self.StatusBar1.Panels[0].Text := 'Status: Waiting...';
end;

procedure TForm1.SplitView1Opened(Sender: TObject);
begin
   // Update button captions and alignments when the SplitView is opened
  Button4.Caption := 'Menu';

  // Check the button's ImageAlignment property; it may not exist in all Delphi versions
  Button4.ImageAlignment := TImageAlignment(2);
  // Alternatively, use Button4.ImagePosition := ipTop if it exists

  Button1.Caption := 'Target Process';
  Button1.ImageAlignment := TImageAlignment(2);
  Button2.Caption := 'About The Software';
  Button2.ImageAlignment := TImageAlignment(2);
  Button3.Caption := 'Author';
  Button3.ImageAlignment := TImageAlignment(2);
  // Handle SplitView open event to update the status
  Self.StatusBar1.Panels[0].Text := 'Status: Ready...';
end;


end.

