{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSMEM;

INTERFACE

Function GetConvMemory:Word;
Function BIOSMemory:Word;

IMPLEMENTATION

Uses DOS;

{ La fonction BIOSMemory est inspir‚ du Symantec C++ }

Function BIOSMemory:Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=0;
 Intr($12,Regs);
 BIOSMemory:=Regs.AX;
End;

Function GetConvMemory:Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=0;
 Intr($12,Regs);
 GetConvMemory:=Regs.AX;
End;

END.