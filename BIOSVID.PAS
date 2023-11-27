{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSVID;

INTERFACE

Procedure BackgroundTextHighIntensity;
Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure ClearLineAt(Y,X2:Byte;Chr:Char;Color:Byte);
Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
Procedure CursorOff;
Procedure CursorOn;
Function  EnhancedGraphicsAdapterPresent:Byte;
Function  GetAttr(X,Y,Page:Byte):Byte;
Function  GetChar(X,Y,Page:Byte):Char;
Procedure GetPosCursor(Var X,Y:Byte;Page:Byte);
Function  GetVideoCard:Word;
Function  GetVideoMode:Byte;
Function  MonochromePresent:Byte;
Procedure PutChar(X,Y,Page:Byte;Character:Char);
Procedure PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
Procedure ScrollUp(X1,Y1,X2,Y2,Color:Byte);
Procedure SetCursor(Start,Finish:Byte);
Procedure SetPosCursor(X,Y,Page:Byte);
Procedure SetVideoMode(Mode:Byte);

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

Procedure PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
Var
 Regs:Registers;
Begin
 Regs.AH:=$02;
 Regs.BH:=0;
 Regs.DL:=X;
 Regs.DH:=Y;
 Intr($10,Regs);
 Regs.AH:=$0E;
 Regs.AL:=(Byte(Fond) shl 7) or Byte(Chr);
 Regs.BL:=Color;
 Intr($10,Regs);
End;

Procedure SetVideoMode(Mode:Byte);
Var
 Regs:Registers;
Begin
 Regs.AL:=Mode;
 Regs.AH:=0;
 Intr($10,Regs);
End;

Procedure SetCursor(Start,Finish:Byte);
Var
 Regs:Registers;
Begin
 Regs.CL:=Finish;
 Regs.CH:=Start;
 Regs.AH:=$01;
 Intr($10,Regs);
End;

Procedure SetPosCursor(X,Y,Page:Byte);
Var
 Regs:Registers;
Begin
 Regs.AH:=$02;
 Regs.DL:=X;
 Regs.DH:=Y;
 Regs.BH:=Page;
 Intr($10,Regs);
End;

Procedure GetPosCursor(Var X,Y:Byte;Page:Byte);
Var
 Regs:Registers;
Begin
 Regs.AH:=$03;
 Regs.BH:=Page;
 Intr($10,Regs);
 X:=Regs.DL;
 Y:=Regs.DH;
End;

Procedure PutChar(X,Y,Page:Byte;Character:Char);
Var
 Regs:Registers;
Begin
 SetPosCursor(X,Y,Page);
 Regs.AH:=$0A;
 Regs.AL:=Byte(Character);
 Regs.BX:=$0F;
 Regs.CX:=$01;
 Intr($10,Regs);
End;

Procedure ScrollUp(X1,Y1,X2,Y2,Color:Byte);
Var
 Regs:Registers;
Begin
 Regs.AX:=$0601;
 Regs.BH:=Color;
 Regs.CL:=X1;
 Regs.CH:=Y1;
 Regs.DL:=X2;
 Regs.DH:=Y2;
 Intr($10,Regs);
End;

Procedure ScrollDown(X1,Y1,X2,Y2,Num,Color:Byte);
Var
 Regs:Registers;
Begin
 Regs.AH:=$07;
 Regs.AL:=Num;
 Regs.BH:=Color;
 Regs.CL:=X1;
 Regs.CH:=Y1;
 Regs.DL:=X2;
 Regs.DH:=Y2;
 Intr($10,Regs);
End;

Function GetAttr(X,Y,Page:Byte):Byte;
Var
 Regs:Registers;
 Data:Word;
Begin
 Regs.AH:=$03;
 Regs.BH:=Page;
 Intr($10,Regs);
 Data:=Regs.DX;
 SetPosCursor(X,Y,Page);
 Regs.AH:=$08;
 Intr($10,Regs);
 GetAttr:=Regs.AH;
 Regs.AH:=$02;
 Regs.DX:=Data;
 Intr($10,Regs);
End;

Function GetChar(X,Y,Page:Byte):Char;
Var
 Regs:Registers;
 Data:Word;
Begin
 Regs.AH:=$03;
 Regs.BH:=Page;
 Intr($10,Regs);
 Data:=Regs.DX;
 SetPosCursor(X,Y,Page);
 Regs.AH:=$08;
 Intr($10,Regs);
 GetChar:=Char(Regs.AL);
 Regs.AH:=$02;
 Regs.DX:=Data;
 Intr($10,Regs);
End;

Function GetColums:Byte;
Var
 Regs:Registers;
Begin
 Regs.AH:=$0F;
 Intr($10,Regs);
 GetColums:=Regs.AH;
End;

Function GetPage:Byte;
Var
 Regs:Registers;
Begin
 Regs.AH:=$0F;
 Intr($10,Regs);
 GetPage:=Regs.BH;
End;

Function GetVideoMode:Byte;
Var
 Regs:Registers;
Begin
 Regs.AH:=$0F;
 Intr($10,Regs);
 GetVideoMode:=Regs.AL;
End;

Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
Var
 Regs:Registers;
Begin
 Regs.AX:=$0600;
 Regs.BH:=Color;
 Regs.CL:=X1;
 Regs.CH:=Y1;
 Regs.DL:=X2;
 Regs.DH:=Y2;
 Intr($10,Regs);
End;

Procedure ClearLineAt(Y,X2:Byte;Chr:Char;Color:Byte);
Var
 Regs:Registers;
Begin
 Regs.AH:=2;
 Regs.BH:=0;
 Regs.DL:=0;
 Regs.DH:=Y;
 Intr($10,Regs);
 Regs.AH:=9;
 Regs.AL:=Byte(Chr);
 Regs.BL:=Color;
 Regs.CL:=X2;
 Regs.CH:=0;
 Intr($10,Regs);
End;

Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Var
 Regs:Registers;
Begin
 Regs.CL:=X2-X1;
 Regs.CH:=0;
 Inc(Regs.CX);
 Regs.AH:=2;
 Regs.BH:=0;
 Regs.DL:=X1;
 Regs.DH:=Y;
 Intr($10,Regs);
 Regs.AH:=$0A;
 Regs.AL:=Byte(Chr);
 Regs.BL:=15;
 Intr($10,Regs);
End;

Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Var
 Regs:Registers;
 X:Byte;
Begin
 If(X1>X2)Then Begin
  X:=X1;
  X1:=X2;
  X2:=X;
 End;
 Regs.CX:=X2-X1+1;
 Regs.AH:=2;
 Regs.BH:=0;
 Regs.DL:=X1;
 Regs.DH:=Y;
 Intr($10,Regs);
 Regs.AH:=9;
 Regs.AL:=Byte(Chr);
 Regs.BL:=Color;
 Intr($10,Regs);
End;


END.