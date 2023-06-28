{
module Parser where

import Syntax
import Tokens
}

--------------------------------------------------------------------------------

%name        geoParse
%tokentype { Token      }
%error     { parseError }

--------------------------------------------------------------------------------

%token
    module { TModule }
    import { TImport }
    id     { TIdent $$ }
    ';'    { TSemi }
    '@'    { TAt }
    '['    { TSquareOpen }
    ']'    { TSquareClose }
    '::'   { TDblColon }
    '->'   { TArrow }
    '=>'   { TDblArrow }
    '|'    { TBar }
    ','    { TComma }
    lStr   { TString $$ }

--------------------------------------------------------------------------------

%% 

Module :: { Module }
Module  : module id ';' Body               { Module (Ident $2) $4 }

Body   :: { Body }
Body    : Decl Body                        { $1 : $2 }
        | Decl                             { [$1] }

Decl   :: { Decl }
Decl    : Import                           { $1 }
        | FunDecl                          { $1 }

Import  : import id ';'                    { DImport (Ident $2) }

FunDecl : '@' '[' id ']' '::' FunType Impl { DFun (Sig (Ident $3) (fst $6) (snd $6)) [$7] }

FunType : Types '->' id                    { ($1, Type $3) }

Impl    : '|' '=>' Expr                    { Impl $3 }

Expr    : id lStr                          { ECall (Ident $1) (LStr $2) }

Types   : id ',' Types                     { (makeTypeList $1) ++ $3 }
        | id                               { makeTypeList $1 }

--------------------------------------------------------------------------------

{
makeTypeList :: String -> [Type]
makeTypeList "Unit" = [ ]
makeTypeList t      = [Type t]

parseError :: [Token] -> a
parseError ts = error $ "Parse error: " ++ show ts
}
