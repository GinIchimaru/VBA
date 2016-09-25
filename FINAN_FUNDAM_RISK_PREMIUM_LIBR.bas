Attribute VB_Name = "FINAN_FUNDAM_RISK_PREMIUM_LIBR"

Option Explicit     'Requires that all variables to be declared explicitly.
Option Base 1       'The "Option Base" statement allows to specify 0 or 1 as the
                    'default first index of arrays.
                    
Private PUB_CURRENT_PRICE_LEVEL As Double
Private PUB_CURRENT_DIVIDEND_YIELD As Double
Private PUB_PROJECTED_EARNINGS_GROWTH As Double
Private PUB_TREASURY_BOND_YIELD As Double
Private PUB_LONG_TERM_GROWTH_RATE As Double
Private PUB_EXCESS_PERIOD_RETURNS As Long

Private Const PUB_EPSILON As Double = 2 ^ 52

'************************************************************************************
'************************************************************************************
'FUNCTION      : IMPLIED_RISK_PREMIUM_TABLE_FUNC
'DESCRIPTION   : IMPLIED RISK PREMIUM CALCULATOR
'LIBRARY       : FUNDAMENTAL
'GROUP         : RISK PREMIUM
'ID            : 001
'LAST UPDATE   : 24/06/2010
'AUTHOR        : RAFAEL NICOLAS FERMIN COTA
'************************************************************************************
'************************************************************************************

Function IMPLIED_RISK_PREMIUM_TABLE_FUNC( _
ByRef CURRENT_PRICE_LEVEL_RNG As Variant, _
ByRef CURRENT_DIVIDEND_YIELD_RNG As Variant, _
ByRef PROJECTED_EARNINGS_GROWTH_RNG As Variant, _
ByRef TREASURY_BOND_YIELD_RNG As Variant, _
ByRef LONG_TERM_GROWTH_RATE_RNG As Variant, _
ByRef TRAILING_PE_RNG As Variant, _
ByRef FORWARD_PE_RNG As Variant, _
ByRef EXCESS_PERIOD_RETURNS_RNG As Variant, _
ByRef ERP_LOWER_BOUND_RNG As Variant, _
ByRef ERP_UPPER_BOUND_RNG As Variant)

Dim i As Long
Dim j As Long
Dim k As Long

Dim NROWS As Long
Dim NCOLUMNS As Long

Dim HEADINGS_STR As String
Dim TEMP_MATRIX As Variant

'25 Year Projected Growth Rate --> 8.00%
'ERP = 0.04

Dim CURRENT_PRICE_LEVEL As Double '1465
Dim CURRENT_DIVIDEND_YIELD As Double '0.019
Dim PROJECTED_EARNINGS_GROWTH As Double '0.11
Dim TREASURY_BOND_YIELD As Double '0.0485
Dim LONG_TERM_GROWTH_RATE As Double '0.06
Dim TRAILING_PE As Double '16.5
Dim FORWARD_PE As Double '15.01
Dim EXCESS_PERIOD_RETURNS As Long '5
Dim ERP_LOWER_BOUND As Double '0.02
Dim ERP_UPPER_BOUND As Double '0.06

Dim CURRENT_PRICE_LEVEL_VECTOR As Variant
Dim CURRENT_DIVIDEND_YIELD_VECTOR As Variant
Dim PROJECTED_EARNINGS_GROWTH_VECTOR As Variant
Dim TREASURY_BOND_YIELD_VECTOR As Variant
Dim LONG_TERM_GROWTH_RATE_VECTOR As Variant
Dim TRAILING_PE_VECTOR As Variant
Dim FORWARD_PE_VECTOR As Variant
Dim EXCESS_PERIOD_RETURNS_VECTOR As Variant
Dim ERP_LOWER_BOUND_VECTOR As Variant
Dim ERP_UPPER_BOUND_VECTOR As Variant

On Error GoTo ERROR_LABEL

If IsArray(CURRENT_PRICE_LEVEL_RNG) = True Then
    CURRENT_PRICE_LEVEL_VECTOR = CURRENT_PRICE_LEVEL_RNG
    If UBound(CURRENT_PRICE_LEVEL_VECTOR, 1) = 1 Then
        CURRENT_PRICE_LEVEL_VECTOR = MATRIX_TRANSPOSE_FUNC(CURRENT_PRICE_LEVEL_VECTOR)
    End If
Else
    ReDim CURRENT_PRICE_LEVEL_VECTOR(1 To 1, 1 To 1)
    CURRENT_PRICE_LEVEL_VECTOR(1, 1) = CURRENT_PRICE_LEVEL_RNG
End If
NROWS = UBound(CURRENT_PRICE_LEVEL_VECTOR, 1)

If IsArray(CURRENT_DIVIDEND_YIELD_RNG) = True Then
    CURRENT_DIVIDEND_YIELD_VECTOR = CURRENT_DIVIDEND_YIELD_RNG
    If UBound(CURRENT_DIVIDEND_YIELD_VECTOR, 1) = 1 Then
        CURRENT_DIVIDEND_YIELD_VECTOR = MATRIX_TRANSPOSE_FUNC(CURRENT_DIVIDEND_YIELD_VECTOR)
    End If
Else
    ReDim CURRENT_DIVIDEND_YIELD_VECTOR(1 To 1, 1 To 1)
    CURRENT_DIVIDEND_YIELD_VECTOR(1, 1) = CURRENT_DIVIDEND_YIELD_RNG
End If
If NROWS <> UBound(CURRENT_DIVIDEND_YIELD_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(PROJECTED_EARNINGS_GROWTH_RNG) = True Then
    PROJECTED_EARNINGS_GROWTH_VECTOR = PROJECTED_EARNINGS_GROWTH_RNG
    If UBound(PROJECTED_EARNINGS_GROWTH_VECTOR, 1) = 1 Then
        PROJECTED_EARNINGS_GROWTH_VECTOR = MATRIX_TRANSPOSE_FUNC(PROJECTED_EARNINGS_GROWTH_VECTOR)
    End If
Else
    ReDim PROJECTED_EARNINGS_GROWTH_VECTOR(1 To 1, 1 To 1)
    PROJECTED_EARNINGS_GROWTH_VECTOR(1, 1) = PROJECTED_EARNINGS_GROWTH_RNG
End If
If NROWS <> UBound(PROJECTED_EARNINGS_GROWTH_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(TREASURY_BOND_YIELD_RNG) = True Then
    TREASURY_BOND_YIELD_VECTOR = TREASURY_BOND_YIELD_RNG
    If UBound(TREASURY_BOND_YIELD_VECTOR, 1) = 1 Then
        TREASURY_BOND_YIELD_VECTOR = MATRIX_TRANSPOSE_FUNC(TREASURY_BOND_YIELD_VECTOR)
    End If
Else
    ReDim TREASURY_BOND_YIELD_VECTOR(1 To 1, 1 To 1)
    TREASURY_BOND_YIELD_VECTOR(1, 1) = TREASURY_BOND_YIELD_RNG
End If
If NROWS <> UBound(TREASURY_BOND_YIELD_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(LONG_TERM_GROWTH_RATE_RNG) = True Then
    LONG_TERM_GROWTH_RATE_VECTOR = LONG_TERM_GROWTH_RATE_RNG
    If UBound(LONG_TERM_GROWTH_RATE_VECTOR, 1) = 1 Then
        LONG_TERM_GROWTH_RATE_VECTOR = MATRIX_TRANSPOSE_FUNC(LONG_TERM_GROWTH_RATE_VECTOR)
    End If
Else
    ReDim LONG_TERM_GROWTH_RATE_VECTOR(1 To 1, 1 To 1)
    LONG_TERM_GROWTH_RATE_VECTOR(1, 1) = LONG_TERM_GROWTH_RATE_RNG
End If
If NROWS <> UBound(LONG_TERM_GROWTH_RATE_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(TRAILING_PE_RNG) = True Then
    TRAILING_PE_VECTOR = TRAILING_PE_RNG
    If UBound(TRAILING_PE_VECTOR, 1) = 1 Then
        TRAILING_PE_VECTOR = MATRIX_TRANSPOSE_FUNC(TRAILING_PE_VECTOR)
    End If
Else
    ReDim TRAILING_PE_VECTOR(1 To 1, 1 To 1)
    TRAILING_PE_VECTOR(1, 1) = TRAILING_PE_RNG
End If
If NROWS <> UBound(TRAILING_PE_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(FORWARD_PE_RNG) = True Then
    FORWARD_PE_VECTOR = FORWARD_PE_RNG
    If UBound(FORWARD_PE_VECTOR, 1) = 1 Then
        FORWARD_PE_VECTOR = MATRIX_TRANSPOSE_FUNC(FORWARD_PE_VECTOR)
    End If
Else
    ReDim FORWARD_PE_VECTOR(1 To 1, 1 To 1)
    FORWARD_PE_VECTOR(1, 1) = FORWARD_PE_RNG
End If
If NROWS <> UBound(FORWARD_PE_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(EXCESS_PERIOD_RETURNS_RNG) = True Then
    EXCESS_PERIOD_RETURNS_VECTOR = EXCESS_PERIOD_RETURNS_RNG
    If UBound(EXCESS_PERIOD_RETURNS_VECTOR, 1) = 1 Then
        EXCESS_PERIOD_RETURNS_VECTOR = MATRIX_TRANSPOSE_FUNC(EXCESS_PERIOD_RETURNS_VECTOR)
    End If
Else
    ReDim EXCESS_PERIOD_RETURNS_VECTOR(1 To NROWS, 1 To 1)
    For i = 1 To NROWS
        EXCESS_PERIOD_RETURNS_VECTOR(i, 1) = EXCESS_PERIOD_RETURNS_RNG
    Next i
End If
If NROWS <> UBound(EXCESS_PERIOD_RETURNS_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(ERP_LOWER_BOUND_RNG) = True Then
    ERP_LOWER_BOUND_VECTOR = ERP_LOWER_BOUND_RNG
    If UBound(ERP_LOWER_BOUND_VECTOR, 1) = 1 Then
        ERP_LOWER_BOUND_VECTOR = MATRIX_TRANSPOSE_FUNC(ERP_LOWER_BOUND_VECTOR)
    End If
Else
    ReDim ERP_LOWER_BOUND_VECTOR(1 To NROWS, 1 To 1)
    For i = 1 To NROWS
        ERP_LOWER_BOUND_VECTOR(i, 1) = ERP_LOWER_BOUND_RNG
    Next i
End If
If NROWS <> UBound(ERP_LOWER_BOUND_VECTOR, 1) Then: GoTo ERROR_LABEL

If IsArray(ERP_UPPER_BOUND_RNG) = True Then
    ERP_UPPER_BOUND_VECTOR = ERP_UPPER_BOUND_RNG
    If UBound(ERP_UPPER_BOUND_VECTOR, 1) = 1 Then
        ERP_UPPER_BOUND_VECTOR = MATRIX_TRANSPOSE_FUNC(ERP_UPPER_BOUND_VECTOR)
    End If
Else
    ReDim ERP_UPPER_BOUND_VECTOR(1 To NROWS, 1 To 1)
    For i = 1 To NROWS
        ERP_UPPER_BOUND_VECTOR(i, 1) = ERP_UPPER_BOUND_RNG
    Next i
End If
If NROWS <> UBound(ERP_UPPER_BOUND_VECTOR, 1) Then: GoTo ERROR_LABEL


NCOLUMNS = 20
HEADINGS_STR = "INDEX - CURRENT PRICE LEVEL,CURRENT DIVIDEND YIELD,PROJECTED 5YR EARNINGS GROWTH,TREASURY BOND YIELD,LONG-TERM GROWTH RATE,P/E-TRAILING 12M,P/E-FORWARD,EPS-TRAILING 12M,EPS-EXPECTED,GROWTH (YR/YR),DIVIDENDS- TRAILING 12M,PAYOUT RATIO,GROWTH RATE + DIVIDEND YIELD (EST),REQUIRED RETURN- EQUITY,- RISK-FREE RATE,EQUITY RISK PREMIUM,INDEX - INTRINSIC VALUE,IMPLIED EQUITY RISK PREMIUM,REQUIRED RATE OF RETURN,CHECK!!!,"
j = Len(HEADINGS_STR)
NCOLUMNS = 0
For i = 1 To j
    If Mid(HEADINGS_STR, i, 1) = "," Then: NCOLUMNS = NCOLUMNS + 1
Next i
ReDim TEMP_MATRIX(0 To NROWS, 1 To NCOLUMNS)
i = 1
For k = 1 To NCOLUMNS
    j = InStr(i, HEADINGS_STR, ",")
    TEMP_MATRIX(0, k) = Mid(HEADINGS_STR, i, j - i)
    i = j + 1
Next k

i = 1
For i = 1 To NROWS
    CURRENT_PRICE_LEVEL = CURRENT_PRICE_LEVEL_VECTOR(i, 1) '1465
    CURRENT_DIVIDEND_YIELD = CURRENT_DIVIDEND_YIELD_VECTOR(i, 1) '0.019
    PROJECTED_EARNINGS_GROWTH = PROJECTED_EARNINGS_GROWTH_VECTOR(i, 1) '0.11
    TREASURY_BOND_YIELD = TREASURY_BOND_YIELD_VECTOR(i, 1) '0.0485
    LONG_TERM_GROWTH_RATE = LONG_TERM_GROWTH_RATE_VECTOR(i, 1) '0.06
    TRAILING_PE = TRAILING_PE_VECTOR(i, 1) '16.5
    FORWARD_PE = FORWARD_PE_VECTOR(i, 1) '15.01
    EXCESS_PERIOD_RETURNS = EXCESS_PERIOD_RETURNS_VECTOR(i, 1) '5
    ERP_LOWER_BOUND = ERP_LOWER_BOUND_VECTOR(i, 1) '0.02
    ERP_UPPER_BOUND = ERP_UPPER_BOUND_VECTOR(i, 1) '0.06
    
    TEMP_MATRIX(i, 1) = CURRENT_PRICE_LEVEL
    TEMP_MATRIX(i, 2) = CURRENT_DIVIDEND_YIELD
    TEMP_MATRIX(i, 3) = PROJECTED_EARNINGS_GROWTH
    TEMP_MATRIX(i, 4) = TREASURY_BOND_YIELD
    
    TEMP_MATRIX(i, 5) = LONG_TERM_GROWTH_RATE
    TEMP_MATRIX(i, 6) = TRAILING_PE
    TEMP_MATRIX(i, 7) = FORWARD_PE

    If TEMP_MATRIX(i, 1) > 0 And TEMP_MATRIX(i, 6) > 0 And TEMP_MATRIX(i, 7) > 0 Then
        TEMP_MATRIX(i, 8) = TEMP_MATRIX(i, 1) / TEMP_MATRIX(i, 6)
        TEMP_MATRIX(i, 9) = TEMP_MATRIX(i, 1) / TEMP_MATRIX(i, 7)
        TEMP_MATRIX(i, 11) = TEMP_MATRIX(i, 1) * TEMP_MATRIX(i, 2)
        
        If TEMP_MATRIX(i, 8) > 0 Then
            TEMP_MATRIX(i, 10) = TEMP_MATRIX(i, 9) / TEMP_MATRIX(i, 8) - 1
            TEMP_MATRIX(i, 12) = TEMP_MATRIX(i, 11) / TEMP_MATRIX(i, 8)
        Else
            TEMP_MATRIX(i, 10) = CVErr(xlErrNA)
            TEMP_MATRIX(i, 12) = CVErr(xlErrNA)
        End If
        TEMP_MATRIX(i, 13) = ((TEMP_MATRIX(i, 2) * TEMP_MATRIX(i, 1)) * (1 + TEMP_MATRIX(i, 3)) / TEMP_MATRIX(i, 1))
        TEMP_MATRIX(i, 14) = TEMP_MATRIX(i, 5) + TEMP_MATRIX(i, 13)
        TEMP_MATRIX(i, 15) = TEMP_MATRIX(i, 4)
        TEMP_MATRIX(i, 16) = TEMP_MATRIX(i, 14) - TEMP_MATRIX(i, 15)
        TEMP_MATRIX(i, 17) = IMPLIED_RISK_PREMIUM_SOLVER_FUNC(TEMP_MATRIX(i, 1), TEMP_MATRIX(i, 2), TEMP_MATRIX(i, 3), TEMP_MATRIX(i, 4), TEMP_MATRIX(i, 5), EXCESS_PERIOD_RETURNS, TEMP_MATRIX(i, 16), ERP_LOWER_BOUND, ERP_UPPER_BOUND)
        TEMP_MATRIX(i, 18) = IMPLIED_RISK_PREMIUM_SOLVER_FUNC(TEMP_MATRIX(i, 1), TEMP_MATRIX(i, 2), TEMP_MATRIX(i, 3), TEMP_MATRIX(i, 4), TEMP_MATRIX(i, 5), EXCESS_PERIOD_RETURNS, 0, ERP_LOWER_BOUND, ERP_UPPER_BOUND)
        TEMP_MATRIX(i, 19) = TEMP_MATRIX(i, 18) + TEMP_MATRIX(i, 4)
        TEMP_MATRIX(i, 20) = IMPLIED_RISK_PREMIUM_SOLVER_FUNC(TEMP_MATRIX(i, 1), TEMP_MATRIX(i, 2), TEMP_MATRIX(i, 3), TEMP_MATRIX(i, 4), TEMP_MATRIX(i, 5), EXCESS_PERIOD_RETURNS, TEMP_MATRIX(i, 18), ERP_LOWER_BOUND, ERP_UPPER_BOUND)
        TEMP_MATRIX(i, 20) = Abs(TEMP_MATRIX(i, 20) - TEMP_MATRIX(i, 1))
    Else
        For j = 8 To NCOLUMNS: TEMP_MATRIX(i, j) = CVErr(xlErrNA): Next j
    End If
Next i

IMPLIED_RISK_PREMIUM_TABLE_FUNC = TEMP_MATRIX

Exit Function
ERROR_LABEL:
IMPLIED_RISK_PREMIUM_TABLE_FUNC = Err.number
End Function

'************************************************************************************
'************************************************************************************
'FUNCTION      : IMPLIED_RISK_PREMIUM_SOLVER_FUNC
'DESCRIPTION   : IMPLIED RISK PREMIUM CALCULATOR
'LIBRARY       : FUNDAMENTAL
'GROUP         : RISK PREMIUM
'ID            : 002
'LAST UPDATE   : 24/06/2010
'AUTHOR        : RAFAEL NICOLAS FERMIN COTA
'************************************************************************************
'************************************************************************************
'25 Year Projected Growth Rate --> 8.00%

Private Function IMPLIED_RISK_PREMIUM_SOLVER_FUNC( _
Optional ByVal CURRENT_PRICE_LEVEL As Double = 1465, _
Optional ByVal CURRENT_DIVIDEND_YIELD As Double = 0.019, _
Optional ByVal PROJECTED_EARNINGS_GROWTH As Double = 0.11, _
Optional ByVal TREASURY_BOND_YIELD As Double = 0.0485, _
Optional ByVal LONG_TERM_GROWTH_RATE As Double = 0.06, _
Optional ByVal EXCESS_PERIOD_RETURNS As Long = 5, _
Optional ByVal EQUITY_RISK_PREMIUM As Double = 0.04, _
Optional ByVal ERP_LOWER_BOUND As Double = 0.02, _
Optional ByVal ERP_UPPER_BOUND As Double = 0.06)

Dim Y_VAL As Double
Dim CONVERG_VAL As Integer
Dim COUNTER As Long
Dim nLOOPS As Long
Dim tolerance As Double

On Error GoTo ERROR_LABEL

nLOOPS = 1000
tolerance = 10 ^ -10

PUB_CURRENT_PRICE_LEVEL = CURRENT_PRICE_LEVEL
PUB_CURRENT_DIVIDEND_YIELD = CURRENT_DIVIDEND_YIELD
PUB_PROJECTED_EARNINGS_GROWTH = PROJECTED_EARNINGS_GROWTH
PUB_TREASURY_BOND_YIELD = TREASURY_BOND_YIELD
PUB_LONG_TERM_GROWTH_RATE = LONG_TERM_GROWTH_RATE
PUB_EXCESS_PERIOD_RETURNS = EXCESS_PERIOD_RETURNS

'---------------------------------------------------------------------------
Select Case EQUITY_RISK_PREMIUM
'---------------------------------------------------------------------------
Case Is <> 0 'Intrinsic Value of Index
'---------------------------------------------------------------------------
    IMPLIED_RISK_PREMIUM_SOLVER_FUNC = CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC(EQUITY_RISK_PREMIUM) ^ 0.5 + CURRENT_PRICE_LEVEL
'---------------------------------------------------------------------------
Case Else 'Implied Risk Premium
'---------------------------------------------------------------------------
    Y_VAL = MULLER_ZERO_FUNC(ERP_LOWER_BOUND, ERP_UPPER_BOUND, "CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC", CONVERG_VAL, COUNTER, nLOOPS, tolerance)
    If CONVERG_VAL = 0 Then
        IMPLIED_RISK_PREMIUM_SOLVER_FUNC = Y_VAL
    Else
        IMPLIED_RISK_PREMIUM_SOLVER_FUNC = CONVERG_VAL
    End If
'---------------------------------------------------------------------------
End Select
'---------------------------------------------------------------------------

Exit Function
ERROR_LABEL:
IMPLIED_RISK_PREMIUM_SOLVER_FUNC = Err.number
End Function

'************************************************************************************
'************************************************************************************
'FUNCTION      : CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC
'DESCRIPTION   : IMPLIED RISK PREMIUM OBJECTIVE FUNCTION
'LIBRARY       : FUNDAMENTAL
'GROUP         : RISK PREMIUM
'ID            : 003
'LAST UPDATE   : 24/06/2010
'AUTHOR        : RAFAEL NICOLAS FERMIN COTA
'************************************************************************************
'************************************************************************************

Private Function CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC(ByVal X_VAL As Double)

Dim i As Long
Dim TEMP_SUM As Double
Dim TEMP_VAL As Double

On Error GoTo ERROR_LABEL

TEMP_SUM = 0
'--------------------------------------------------------------------------------
For i = 1 To PUB_EXCESS_PERIOD_RETURNS - 1
'--------------------------------------------------------------------------------
    TEMP_VAL = PUB_CURRENT_PRICE_LEVEL * PUB_CURRENT_DIVIDEND_YIELD * (1 + PUB_PROJECTED_EARNINGS_GROWTH) ^ i 'Expected Dividends
    TEMP_VAL = TEMP_VAL / (1 + PUB_TREASURY_BOND_YIELD + X_VAL) ^ i
    TEMP_SUM = TEMP_SUM + TEMP_VAL
'--------------------------------------------------------------------------------
Next i
'--------------------------------------------------------------------------------
TEMP_VAL = PUB_CURRENT_PRICE_LEVEL * PUB_CURRENT_DIVIDEND_YIELD * (1 + PUB_PROJECTED_EARNINGS_GROWTH) ^ i 'Expected Dividends
TEMP_VAL = TEMP_VAL + (TEMP_VAL * (1 + PUB_LONG_TERM_GROWTH_RATE) / (PUB_TREASURY_BOND_YIELD + X_VAL - PUB_LONG_TERM_GROWTH_RATE)) 'Expected Terminal Value
TEMP_VAL = TEMP_VAL / (1 + PUB_TREASURY_BOND_YIELD + X_VAL) ^ i
TEMP_SUM = TEMP_SUM + TEMP_VAL

CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC = Abs(TEMP_SUM - PUB_CURRENT_PRICE_LEVEL) ^ 2

Exit Function
ERROR_LABEL:
CALL_IMPLIED_RISK_PREMIUM_OBJ_FUNC = PUB_EPSILON
End Function
