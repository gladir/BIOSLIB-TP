{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSEQUI;

INTERFACE

Function BIOSEquip:Word;
Function GetEquip:Word;
Function GetNumFloppyDisk:Word;
Function GetNumParallelPort:Word;
Function GetNumSerialPort:Word;

IMPLEMENTATION

Uses DOS;

Function BIOSEquip:Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=0;
 Intr($11,Regs);
 BIOSEquip:=Regs.AX;
End;

Function GetEquip:Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=0;
 Intr($11,Regs);
 GetEquip:=Regs.AX;
End;

Function GetNumFloppyDisk:Word;Begin
 GetNumFloppyDisk:=(GetEquip shr 6)and 3;
End;

Function GetNumParallelPort:Word;Begin
 GetNumParallelPort:=(GetEquip shr 14)and 3;
End;

Function GetNumSerialPort:Word;Begin
 GetNumSerialPort:=(GetEquip shr 9) and 3;
End;

END.