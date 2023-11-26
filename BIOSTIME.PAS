{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSTIME;

INTERFACE

Function _BiosTime(Cmd:Integer;NewTime:LongInt):LongInt;

IMPLEMENTATION

Uses DOS;

Function _BiosTime(Cmd:Integer;NewTime:LongInt):LongInt;
Var
 Regs:Registers;
Begin
 Regs.AH:=Cmd;
 Regs.CX:=NewTime shr 16;
 Regs.DX:=NewTime and $FFFF;
 Intr($1A,Regs);
 _BiosTime:=LongInt(LongInt(LongInt(Regs.CX) shl 16)+LongInt(Regs.DX));
End;

END.