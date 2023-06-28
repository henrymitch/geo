module Tokens where

data Token
    -- KEYWORDS
    = TLet
    | TModule
    | TImport

    -- SYMBOLS
    | TNewLn          -- \n
    | TEquals         -- =
    | TPlus           -- +
    | TDblColon       -- ::
    | TAt             -- @
    | TBar            -- |
    | TDblArrow       -- =>
    | TRoundOpen      -- (
    | TRoundClose     -- )
    | TSquareOpen     -- [
    | TSquareClose    -- ]
    | TSemi           -- ;
    | TArrow          -- ->
    | TComma          -- ,

    -- LITERALS
    | TInt Int
    | TString String

    -- OTHER
    | TIdent String

    | TEof
  deriving (Eq,Show)
