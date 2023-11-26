{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSKEY;

INTERFACE

Function  BIOSKey(Flag:Integer):Integer;
Function  ReadKey:Word;
Procedure SetKeyRate(Rate,Delay:Word);

IMPLEMENTATION

Uses DOS;

Function BIOSKey(Flag:Integer):Integer;
Var
 Regs:Registers;
Begin
 Regs.AX:=Flag;
 Intr($16,Regs);
 BIOSKey:=Regs.AX;
End;

Function ReadKey:Word;
Var
 Regs:Registers;
Begin
 Regs.AH:=0;
 Intr($16,Regs);
 ReadKey:=Regs.AX;
End;

Procedure SetKeyRate(Rate,Delay:Word);
Var
 Regs:Registers;
Begin
 Regs.AX:=$0305;
 Regs.BH:=$01;
 Regs.BL:=$0C;
 Case Delay of
  0..250:Regs.BH:=$00;
  251..500:Regs.BH:=$01;
  501..1000:Regs.BH:=$02;
 End;
 Case Rate of
  27..30:Regs.BL:=$00;
  25..26:Regs.BL:=$01;
  24:Regs.BL:=$02;
  21..23:Regs.BL:=$03;
  20:Regs.BL:=$04;
  18..19:Regs.BL:=$05;
  17:Regs.BL:=$06;
  16:Regs.BL:=$07;
  15:Regs.BL:=$08;
  13..14:Regs.BL:=$09;
  12:Regs.BL:=$0A;
  11:Regs.BL:=$0B;
  10:Regs.BL:=$0C;
  9:Regs.BL:=$0D;
  8:Regs.BL:=$0F;
  7:Regs.BL:=$10;
  6:Regs.BL:=$12;
  5:Regs.BL:=$14;
  4:Regs.BL:=$17;
  3:Regs.BL:=$1A;
  2:Regs.BL:=$1F;
 End;
 Intr($16,Regs);
End;

END.