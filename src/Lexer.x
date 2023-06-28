{
module Lexer where

import Tokens
}

%wrapper "basic"

--------------------------------------------------------------------------------

$nl          = [\n]
$white       = [$nl\t\ ]
$white_no_nl = $white # \n

$digit       = 0-9
$alpha       = [a-zA-Z]
$str_char    = [$alpha $digit \ \!\,]
$idchar      = [$alpha \_\'\/]

$symbol      = [\+\-]

--------------------------------------------------------------------------------

@id     = $idchar+

@int    = $digit+
@real   = $digit+ \. $digit+
@string = \" $str_char* \"

--------------------------------------------------------------------------------

tokens :-

$white+ ;
"--".*        ;

-- KEYWORDS
"let"     { \s -> TLet }
"module"  { \s -> TModule }
"import"  { \s -> TImport }

-- SYMBOLS
$nl       { \s -> TNewLn }
"="       { \s -> TEquals }
"+"       { \s -> TPlus }
"::"      { \s -> TDblColon }
"@"       { \s -> TAt }
"|"       { \s -> TBar }
"=>"      { \s -> TDblArrow }
"("       { \s -> TRoundOpen }
")"       { \s -> TRoundClose }
"["       { \s -> TSquareOpen }
"]"       { \s -> TSquareClose }
";"       { \s -> TSemi }
"->"      { \s -> TArrow }
"()"      { \s -> TIdent "Unit" }

-- LITERALS
@id       { \s -> TIdent s }
@int      { \s -> TInt $ read s }
@string   { \s -> TString s }
