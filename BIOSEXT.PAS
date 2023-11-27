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
Var
 Regs:Registers;
Begin
 { Connecter l'interface RM }
 Regs.AX:=$5301;
 Regs.BX:=0;
 Intr($15,Regs);
  { Active le pilote APM 1.1 }
 Regs.AX:=$530E;
 Regs.BX:=0;
 Regs.CX:=$0101;
 Intr($15,Regs);
   { Active l'APM }
 Regs.AX:=$5308;
 Regs.BX:=1;
 Regs.CX:=1;
 Intr($15,Regs);
   { Demande la mode sp‚cifier }
 Regs.AX:=$5307;
 Regs.BX:=1;
 Regs.CX:=Mode;
 Intr($15,Regs);
 SetAPMMode:=Regs.Flags and 1=1;
End;

END.