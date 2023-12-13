procedure ParseDomainUserName(const Value: string; var Domain, UserCUID: string);
var
    DelimPos: Integer;
begin
    DelimPos := Pos('\', Value);
    if DelimPos = 0 then begin
        Domain := '.';
        UserCUID := Value;
    end else begin
        Domain := Copy(Value, 1, DelimPos - 1);
        UserCUID := Copy(Value, DelimPos + 1, MaxInt);
    end;
end;

procedure OpenBrowser(Url: string);
var
    ErrorCode: Integer;
begin
    ShellExec('open', Url, '', '', SW_SHOWNORMAL, ewNoWait, ErrorCode);
end;

procedure LinkClickGitLabUrlDiodToken(Sender: TObject);
begin
    OpenBrowser('https://{#GITLAB_HOSTDiod}/-/profile/personal_access_tokens?name=LSW&scopes=api');
end;

procedure LinkClickGitLabUrlSpiritToken(Sender: TObject);
begin
    OpenBrowser('https://{#GITLAB_HOSTSpirit}/-/profile/personal_access_tokens?name=LSW&scopes=api');
end;

procedure LinkClickVdiPortal(Sender: TObject);
begin
    OpenBrowser('{#VdiPortalURL}');
end;

procedure LinkClickBastionsDoc(Sender: TObject);
begin
    OpenBrowser('{#BastionsDoc}');
end;

procedure Explode(var Dest: TArrayOfString; Text: String; Separator: String);
var
    i, p: Integer;
begin
    i := 0;
    repeat
        SetArrayLength(Dest, i+1);
        p := Pos(Separator, Text);
        if p > 0 then begin
            Dest[i] := Copy(Text, 1, p-1);
            Text := Copy(Text, p + Length(Separator), Length(Text));
            i := i + 1;
        end else begin
            Dest[i] := Text;
            Text := '';
        end;
    until Length(Text)=0;
end;

procedure ExitProcess(uExitCode: Integer);
    external 'ExitProcess@kernel32.dll stdcall';
