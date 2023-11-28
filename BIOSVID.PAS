{ @author: Sylvain Maltais (support@gladir.com)
  @created: 2023
  @website(https://www.gladir.com/CODER/BIOSLIB-TP)
  @abstract(Target: Turbo Pascal 7)
}

Unit BIOSVID;

INTERFACE

Procedure BackgroundTextHighIntensity;
Procedure BarCharHori(X1,Y,X2:Byte;Chr:Char);
Procedure BarTextHori(X1,Y,X2:Byte;Chr:Char;Color:Byte);
Procedure ClearLineAt(Y,X2:Byte;Chr:Char;Color:Byte);
Procedure ClearWindow(X1,Y1,X2,Y2,Color:Byte);
Procedure CursorOff;
Procedure CursorOn;
Function  EnhancedGraphicsAdapterPresent:Byte;
Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Function  GetAttr(X,Y,Page:Byte):Byte;
Function  GetBlinkControl:Boolean;
Function  GetChar(X,Y,Page:Byte):Char;
Function  GetHeightChar:Byte;
Function  GetNumColor:Word;
Function  GetNumPage:Byte;
Procedure GetPosCursor(Var X,Y:Byte;Page:Byte);
Function  GetScanLine:Word;
Function  GetVideoCard:Word;
Function  GetVideoInfo(Var Buffer):Boolean;
Function  GetVideoMode:Byte;
Function  MonochromePresent:Byte;
Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure PutChar(X,Y,Page:Byte;Character:Char);
Procedure PutCharType(X,Y:Byte;Chr:Char;Color:Byte;Fond:Boolean);
Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Procedure ScrollUp(X1,Y1,X2,Y2,Color:Byte);
Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Procedure SetCursor(Start,Finish:Byte);
Procedure SetMatrix(Palette,Height:Byte;Number,Start:Word;Var Buffer);
Procedure SetPosCursor(X,Y,Page:Byte);
Procedure SetVideoMode(Mode:Byte);
Procedure Set80x50Text;

IMPLEMENTATION

Uses DOS;

Type
 TByte=Array[0..32000]of Byte;

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

Procedure SetCube(X,Y:Byte;Chr:Char;Color:Byte);
Var
 Regs:Registers;
Begin
 Regs.AH:=$02;
 Regs.BH:=0;
 Regs.DL:=X;
 Regs.DH:=Y;
 Intr($10,Regs);
 Regs.AH:=9;
 Regs.AL:=Byte(Chr);
 Regs.BL:=Color;
 Regs.CX:=1;
 Intr($10,Regs);
End;

Procedure SaveBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Var
 I,J,XS,YS:Byte;
 TBuffer:^TByte;
Begin
 XS:=(X2-X1);
 YS:=(Y2-Y1);
 TBuffer:=@Buffer;
 For J:=0 to YS do Begin
  For I:=0 to XS do Begin
   TBuffer^[(((XS+1)*J)+I) shl 1]:=Byte(GetChar(X1+I,Y1+J,0));
   TBuffer^[((((XS+1)*J)+I) shl 1)+1]:=GetAttr(X1+I,Y1+J,0);
  End;
 End;
End;

Procedure PutBox(X1,Y1,X2,Y2:Byte;Var Buffer);
Var
 I,J,XS,YS:Byte;
 TBuffer:^TByte;
Begin
 XS:=(X2-X1);
 YS:=(Y2-Y1);
 TBuffer:=@Buffer;
 For J:=0 to YS do Begin
  For I:=0 to XS do  Begin
   SetCube(X1+I,Y1+J,Char(TBuffer^[(((XS+1)*J)+I) shl 1]),
                          TBuffer^[((((XS+1)*J)+I) shl 1)+1]);
  End;
 End;
End;

Procedure FillBox(X1,Y1,X2,Y2:Byte;Chr:Char;Color:Byte);
Var
 I:Byte;
Begin
 For I:=Y1 to Y2 do BarTextHori(X1,I,X2,Chr,Color);
End;

Function GetVideoInfo(Var Buffer):Boolean;
Var
 Regs:Registers;
Begin
 Regs.ES:=Seg(Buffer);
 Regs.DI:=Ofs(Buffer);
 Regs.AH:=$1B;
 Regs.BX:=0;
 Intr($10,Regs);
 GetVideoInfo:=Regs.AL=$1B;
End;

Function GetBlinkControl:Boolean;
Var
 Table:Array[0..31] of Word;
 Results:Boolean;
Begin
 {$IFDEF FPC}
  GetBlinkControl:=False;
 {$ELSE}
  Results:=GetVideoInfo(Table);
  GetBLinkControl:=Boolean((Mem[Table[1]:Table[0]+$0B]shr 2)and 1);
 {$ENDIF}
End;

Function GetHeightChar:Byte;
Var
 Table:Array[0..63]of Byte;
Begin
 {$IFDEF FPC}
  GetHeightChar:=25;
 {$ELSE}
  If(GetVideoInfo(Table))Then GetHeightChar:=(Table[$24] shl 8)+Table[$23]
 	                 Else GetHeightChar:=0
 {$ENDIF}
End;

Function GetNumColor:Word;
Var
 Table:Array[0..63] of Byte;
Begin
 {$IFDEF FPC}
  GetNumColor:=16;
 {$ELSE}
  If(GetVideoInfo(Table))Then GetNumColor:=(Table[$28] shl 8)+Table[$27]
                         Else GetNumColor:=0
 {$ENDIF}
End;

Function GetNumPage:Byte;
Var
 Table:Array[0..63] of Byte;
Begin
 {$IFDEF FPC}
  GetNumPage:=1;
 {$ELSE}
  If(GetVideoInfo(Table))Then GetNumPage:=Table[$29]
 		         Else GetNumPage:=1;
 {$ENDIF}
End;

Function GetScanLine:Word;
Var
 Table:Array[0..63] of Byte;
 Results:Byte;
Begin
 {$IFDEF FPC}
  GetScanLine:=0;
 {$ELSE}
  If(GetVideoInfo(Table))Then Results:=Table[$2A]
                         Else Results:=0;
  Case Results of
   0:GetScanLine:=200;
   1:GetScanLine:=350;
   2:GetScanLine:=400;
   3:GetScanLine:=480;
   5:GetScanLine:=600;
   6:GetScanLine:=768;
   8:GetScanLine:=352;
   9:GetScanLine:=364;
   Else GetScanLine:=0;
  End;
 {$ENDIF}
End;

Procedure SetMatrix(Palette,Height:Byte;Number,Start:Word;Var Buffer);
Var
 Regs:Registers;
Begin
 Regs.AX:=$1100;
 Regs.BL:=Palette;
 Regs.BH:=Height;
 Regs.DX:=Start;
 Regs.CX:=Number;
 Regs.ES:=Seg(Buffer);
 Regs.BP:=Ofs(Buffer);
 Intr($10,Regs);
End;

Procedure Set80x50Text;
Var
 Regs:Registers;
Begin
 Regs.AX:=$1112;
 Regs.BX:=0;
 Intr($10,Regs);
End;

END.