{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSEXT;

INTERFACE

Procedure DisableFrontPanelAmdekSystem88;
Procedure EnableFrontPanelAmdekSystem88;
Procedure HighSpeedAmdekSystem88;
Function  SetAPMMode(Mode:Word):Boolean;
Procedure SetSpeedAMI(Fast:Boolean);
Procedure StandardSpeedAmdekSystem88;

IMPLEMENTATION

Uses DOS;

Procedure DisableFrontPanelAmdekSystem88;
Var
 Regs:Registers;
Begin
   { Amdek System/88}
 Regs.AL:=0;
 Regs.AH:=4;
 Intr($15,Regs);
End;

Procedure EnableFrontPanelAmdekSystem88;
Var
 Regs:Registers;
Begin
  { Amdek System/88}
 Regs.AL:=1;
 Regs.AH:=4;
 Intr($15,Regs);
End;

Procedure HighSpeedAmdekSystem88;
Var
 Regs:Registers;
Begin
  { Amdek System/88}
 Regs.AL:=8;
 Regs.AH:=4;
 Intr($15,Regs);
End;

Procedure StandardSpeedAmdekSystem88;
Var
 Regs:Registers;
Begin
  { Amdek System/88}
 Regs.AL:=6;
 Regs.AH:=4;
 Intr($15,Regs);
End;

Procedure SetSpeedAMI(Fast:Boolean);
Var
 Regs:Registers;
Begin
  { BIOS AMI }
 If(Fast)Then Begin
  Regs.AH:=$F0;
  Regs.AL:=$02;
  Intr($16,Regs);
 End
  Else
 Begin
  Regs.AH:=$F0;
  Regs.AL:=$01;
  Intr($16,Regs);
 End;
End;

Function SetAPMMode(Mode:Word):Boolean;
{$IFDEF FPC}
 Begin
  WriteLn('Non implement‚');
  SetAPMMode:=False;
 End;
{$ELSE}
 Assembler;ASM
   { Connecter l'interface RM }
  MOV AX,5301h
  XOR BX,BX
  INT 15h
   { Active le pilote APM 1.1 }
  MOV AX,530Eh
  XOR BX,BX
  MOV CX,0101h
  INT 15h
   { Active l'APM }
  MOV AX,5308h
  MOV BX,1
  MOV CX,BX
  INT 15h
   { Demande la mode sp‚cifier }
  MOV AX,5307h
  mov BX,1
  MOV CX,Mode
  INT 15h
  MOV AL,0
  JC  @Error
  MOV AL,True
@Error:
@End:
 END;
{$ENDIF}

END.