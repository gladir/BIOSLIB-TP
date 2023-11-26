{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSVID;

INTERFACE

Procedure BackgroundTextHighIntensity;
Procedure CursorOff;
Procedure CursorOn;
Function  EnhancedGraphicsAdapterPresent:Byte;
Function  GetVideoCard:Word;
Function  MonochromePresent:Byte;

IMPLEMENTATION

Uses DOS;

Procedure BackgroundTextHighIntensity;
Var
 Regs:Registers;
Begin
 Regs.AX:=$1003;
 Regs.BL:=$0;
 Intr($10,Regs);
End;

Procedure CursorOff;
Var
 Regs:Registers;
Begin
 Regs.AH:=1;
 Regs.CH:=32;
 Regs.CL:=0;
 Intr($10,Regs);
End;

Procedure CursorOn;
Var
 Regs:Registers;
Begin
 Regs.AX:=$0100;
 Regs.CX:=(7 shl 8)+9;
 Intr($10,Regs);
End;

Function GetVideoCard:Word;
Var
 Regs:Registers;
Begin
 Regs.AX:=$1A00;
 Intr($10,Regs);
 If Regs.AL=$1AThen GetVideoCard:=Regs.BX
               Else GetVideoCard:=0;
End;

Function MonochromePresent:Byte;Begin
 MonochromePresent:=0;
 If((GetVideoCard and $FF)in[$01,$07,$0B])or
   ((GetVideoCard shr 8)in[$01,$07,$0B])Then MonochromePresent:=1
End;

Function EnhancedGraphicsAdapterPresent:Byte;Begin
 EnhancedGraphicsAdapterPresent:=0;
 If((GetVideoCard and $FF)in[$04,$05,$06,$08,$0A,$0C])or
   ((GetVideoCard shr 8)in[$04,$05,$06,$08,$0A,$0C])Then EnhancedGraphicsAdapterPresent:=1
End;

END.