unit funcs;

interface

uses
  Winapi.Windows;

function AdjustProcessPrivilege(Processhandle: THandle;
  Token_Name: pchar): boolean;

implementation

function AdjustProcessPrivilege(Processhandle: THandle;
  Token_Name: pchar): boolean;
var
{$IF CompilerVersion >= 23}
  Token: THandle;
{$ELSE}
  Token: cardinal;
{$IFEND}
  TokenPri: _TOKEN_PRIVILEGES;
  processDest: int64;
  i: DWORD;
begin
  Result := FALSE;
  if OpenProcessToken(Processhandle, TOKEN_ADJUST_PRIVILEGES, Token) then
  begin
    if LookupPrivilegeValue(nil, Token_Name, processDest) then
    begin
      TokenPri.PrivilegeCount := 1;
      TokenPri.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
      TokenPri.Privileges[0].Luid := processDest;
      i := 0;
      if AdjustTokenPrivileges(Token, FALSE, TokenPri, sizeof(TokenPri), nil, i)
      then
        Result := true;
    end;
  end;
end;

end.
