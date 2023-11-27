{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSKEY;

INTERFACE

Function _BIOSKEY(Flag:Integer):Integer;
Function  GetModeInsert:Boolean;
Function  KeyFlags:Byte;
Function  IsCtrlLetterCode(Code:Word):Boolean;
Function  NextKey:Word;
Procedure PushKey(Key:Word);
Function  ReadKey:Word;
Function  ReadKeyAT:Word;
Procedure SetKeyRate(Rate,Delay:Word);

IMPLEMENTATION

Uses DOS;

Function _BIOSKEY(Flag:Integer):Integer;
Var
 Regs:Registers;
Begin
 Regs.AX:=Flag;
 Intr($16,Regs);
 _BIOSKEY:=Regs.AX;
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

Function GetModeInsert:Boolean;
Var
 Regs:Registers;
Begin
 Regs.AH:=$02;
 Intr($16,Regs);
 GetModeInsert:=Boolean((Regs.AL shr 7)and 1);
End;

Procedure PushKey(Key:Word);
Var
 Regs:Registers;
Begin
 Regs.AH:=$05;
 Regs.CX:=Key;
 Intr($16,Regs);
End;

Function KeyFlags:Byte;
Var
 Regs:Registers;
Begin
 Regs.AH:=02;
 Intr($16,Regs);
 KeyFlags:=Regs.AL;
End;

Function NextKey:Word;
Var
 Regs:Registers;
Begin
 Regs.AH:=$01;
 Intr($16,Regs);
 NextKey:=Regs.AX;
END;

Function ReadKeyAT:Word;
Var
 Regs:Registers;
Begin
 Regs.AH:=$10;
 Intr($16,Regs);
 ReadKeyAT:=Regs.AX;
End;

Function IsCtrlLetterCode(Code:Word):Boolean;
Const
 ShiftCode:Array['A'..'Z'] of Byte=(
  30,48,46,32,18,33,34,35,23,36,37,38,50,
  49,24,25,16,19,31,20,22,47,17,45,21,44);
Begin
 IsCtrlLetterCode:=(Lo(Code) in [1..26])and
                   (Hi(Code)=ShiftCode[Char(Lo(Code)+64)]);
End;

END.
