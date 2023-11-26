{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSPRN;

INTERFACE

Function BIOSPrint(Cmd,AByte,Port:Integer):Integer;

IMPLEMENTATION

Uses DOS;

Function BIOSPrint(Cmd,AByte,Port:Integer):Integer;
Var
 Regs:Registers;
Begin
 Regs.AH:=Cmd;
 Regs.AL:=AByte;
 Regs.DX:=Port;
 Intr($17,Regs);
 BIOSPrint:=Regs.AH;
End;

END.