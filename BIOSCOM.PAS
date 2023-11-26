{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSCOM;

INTERFACE

Var
 SerialPort:Byte;
 SerialBaud:Word;
 SerialParity:(ParityN,ParityO,ParityE);
 SerialData:Byte;
 SerialStop:Byte;
 ModemInit:String;

Function Rs232Compose(PhoneNumber:String):Boolean;
Function Rs232Init:Boolean;
Function Rs232Ready(Port:Byte):Boolean;
Function Rs232Send(Port:Byte;S:String):Boolean;

IMPLEMENTATION

Uses DOS;

Function Rs232Ready(Port:Byte):Boolean;
Var
 Regs:Registers;
Begin
 Rs232Ready:=False;
 If(Port>1)or(Port>4)Then Exit;
 Regs.AX:=$0300;
 Regs.DX:=Port-1;
 Intr($14,Regs);
 If(Regs.AX and $0300)=0 Then Exit;
 Rs232Ready:=True;
End;

Function Rs232Send(Port:Byte;S:String):Boolean;
Var
 K,L:Byte;
 Regs:Registers;
 RawS:String;
Begin
 Rs232Send:=False;
 Regs.AH:=$01;
 Regs.DX:=Port-1;
 RawS:='';
 K:=1;
 While K<Length(S)do Begin
  If Copy(S,K,2)='^M'Then Begin
   RawS:=RawS+#13;
   Inc(K,2);
  End
   Else
  Begin
   RawS:=RawS+S[K];
   Inc(K);
  End;
 End;
 For K:=1 to Length(RawS)do Begin
  L:=0;
  While(L<250)and(Not Rs232Ready(Port))do L:=L+1;
  If L>=250 Then Exit;
  Regs.AL:=Ord(RawS[K]);
  Intr($14,Regs);
  If(Regs.AH and $8E)<>0 Then Exit;
 End;
 Rs232Send:=True;
End;

Function Rs232Init:Boolean;Begin
 Rs232Init:=Rs232Send(SerialPort,ModemInit);
End;

Function Rs232Compose(PhoneNumber:String):Boolean;Begin
 Rs232Compose:=Rs232Send(SerialPort,'ATDT'+PhoneNumber);
End;

BEGIN
 SerialPort:=1;
 SerialBaud:=9600;
 SerialParity:=ParityN;
 SerialData:=8;
 SerialStop:=1;
 ModemInit:='AT S0=0 Q0 E1 X4^M~~~AT&C1^M~';
END.