MODULE DAY1;

(*************************************************************


  Description.. : Solution to day 1 Advent of Code
  Title........ :
  Creation Date : 10 December 2024
  System....... : LOGITECH MODULA-2/86 OS/2 1.x 16-Bit compiler

REV    Date    Auth    Description
---    ----    ----    -----------
1.0
1.1
1.2
1.3
1.4
1.5
*************************************************************)


                      (* MODULA-2 LIBRARY IMPORTS: *)

FROM ASCII IMPORT cr, lf, nul, EOL;

FROM FileSystem       IMPORT File, Lookup, Create, Close, SetOpen,
                      WriteNBytes, ReadNBytes, ReadByte, ReadChar,
                      Response,Length,GetPos,SetPos,Delete;

FROM InOut  IMPORT WriteString, WriteLn;

FROM NumberConversion IMPORT StringToCard, StringToNum, CardToString,
        StringToLongInt, LongIntToString;

FROM Sort         IMPORT HSort, QSort, CompareProc, SwapProc;

FROM SYSTEM IMPORT ADR, SIZE;

                      (* APPLICATION PROGRAM IMPORTS: *)


CONST
	MaxInputEntries = 2000;
TYPE
	NumberList = ARRAY[0..MaxInputEntries] OF LONGINT;


VAR
  file : File;
  leftList : NumberList;
  rightList : NumberList;
  numberListLength: CARDINAL;






PROCEDURE FReadLn(VAR infile : File; VAR line : ARRAY OF CHAR;
                  VAR lastChar : CHAR);
VAR
    i : CARDINAL;
BEGIN
  i := 0;
  REPEAT
    ReadChar(infile,lastChar);
    IF lastChar = EOL THEN
      line[i] := nul;
    ELSE
      line[i] := lastChar;
    END;

    IF lastChar # EOL THEN    (* remove OL character *)
      INC(i);
    END (* if *);
  
  UNTIL (lastChar = nul) OR (lastChar = EOL) OR (i >= HIGH(line))
END FReadLn;




PROCEDURE Less(VAR numberList : NumberList; i, j : CARDINAL) : BOOLEAN;
BEGIN
  RETURN numberList[i] < numberList[j];
END Less;



PROCEDURE Swap(VAR numberList : NumberList; i,j:CARDINAL);
VAR 
  tmp : LONGINT;
BEGIN
  tmp := numberList[i]; numberList[i] := numberList[j]; numberList[j] := tmp;
END Swap;


PROCEDURE SortNumberLists;
BEGIN
  HSort(numberListLength, CompareProc(Less), SwapProc(Swap), ADR(leftList));
  HSort(numberListLength, CompareProc(Less), SwapProc(Swap), ADR(rightList));

END SortNumberLists;



PROCEDURE ParseLine(VAR line : ARRAY OF CHAR);
VAR
  i : CARDINAL;
  numIndex : CARDINAL;
  numberStr : ARRAY[0..30] OF CHAR;
  num1, num2 : LONGINT;
  done : BOOLEAN;
BEGIN
  i := 0;
  WHILE line[i] = ' ' DO
    INC(i);
  END (* while *);

  numIndex := 0;
  WHILE (line[i] # nul) AND (line[i] # ' ') DO
    numberStr[numIndex] := line[i];
    INC(i);
    INC(numIndex);
  END (* while *);
  numberStr[numIndex] := nul;

  IF line[i] = nul THEN
    RETURN;
  END (* if *);


  StringToLongInt(numberStr, num1, done);
  IF NOT done THEN
    WriteString("Invalid Number: "); WriteString(numberStr); WriteLn;
  END (* if *);

  WHILE line[i] = ' ' DO
    INC(i);
  END (* while *);

  numIndex := 0;
  WHILE (line[i] # nul) AND (line[i] # ' ') DO
    numberStr[numIndex] := line[i];
    INC(i);
    INC(numIndex);
  END (* while *);
  numberStr[numIndex] := nul;

  StringToLongInt(numberStr, num2, done);
  IF NOT done THEN
    WriteString("Invalid Number: "); WriteString(numberStr); WriteLn;
  END (* if *);

  leftList[numberListLength] := num1;
  rightList[numberListLength] := num2;
  INC(numberListLength);


END ParseLine;


PROCEDURE DumpNumbers;
VAR
  i : CARDINAL;
  numStr : ARRAY[0..30] OF CHAR;
BEGIN

  FOR i := 0 TO numberListLength-1 DO
    LongIntToString(leftList[i], numStr, 1);
    WriteString(numStr);  WriteString("  ");
    LongIntToString(rightList[i], numStr, 1);
    WriteString(numStr);  WriteLn;
  END (* for *);
END DumpNumbers;



PROCEDURE FillNumberList;
VAR
  line : ARRAY[0..100] OF CHAR;
  ch : CHAR;
BEGIN
  Lookup(file, "DAY1_A.TXT", FALSE);

  IF file.res # done THEN
    WriteString("Unable to open input file"); WriteLn;
    RETURN;
  ELSE
    SetOpen(file);
    REPEAT
      FReadLn(file, line, ch);
      ParseLine(line);
    UNTIL (ch = nul);
    Close(file);
  END;

END FillNumberList;


PROCEDURE Day1_Part1;
VAR
  i : CARDINAL;
  sum : LONGINT;
  numStr : ARRAY[0..30] OF CHAR;
BEGIN
  SortNumberLists;
  (* DEBUG DumpNumbers; *) (* Confirm sort *)

  sum := 0L;

  FOR i := 0 TO numberListLength-1 DO
    sum := sum + ABS(leftList[i] - rightList[i]);
  END (* for *);


  LongIntToString(sum, numStr, 1);
  WriteString("Part 1 Answer: ");  WriteString(numStr); WriteLn;


END Day1_Part1;


PROCEDURE CountOccurrences(testNum : LONGINT) : CARDINAL;
VAR
  i, count : CARDINAL;
 
BEGIN
  count := 0;
  FOR i := 0 TO numberListLength-1 DO
    IF rightList[i] = testNum THEN
      INC(count);
    END (* if *);

  END (* for *);

  RETURN count;

END CountOccurrences;


PROCEDURE Day1_Part2;
VAR
  i : CARDINAL;
  leftNum : LONGINT;
  count : CARDINAL;
  sum : LONGINT;
  numStr : ARRAY[0..30] OF CHAR;
BEGIN
  SortNumberLists;
  (* DEBUG DumpNumbers; *) (* Confirm sort *)

  sum := 0L;

  FOR i := 0 TO numberListLength-1 DO
    leftNum := leftList[i];
    count := CountOccurrences(leftNum);    

    sum := sum + leftNum * VAL(LONGINT, count);
  END (* for *);


  LongIntToString(sum, numStr, 1);
  WriteString("Part 2 Answer: ");  WriteString(numStr); WriteLn;


END Day1_Part2;



BEGIN
  FillNumberList;

  Day1_Part1;


  Day1_Part2;

END DAY1.

