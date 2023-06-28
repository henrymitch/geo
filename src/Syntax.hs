module Syntax where

data Module = Module Ident Body
  deriving (Show)

type Body = [Decl]

data Decl
    = DImport Ident
    | DFun Sig [Impl]
  deriving (Show)

data Sig = Sig Ident [Type] Type
  deriving (Show)

data Impl = Impl Expr
  deriving (Show)

data Expr
    = ECall Ident Lit
  deriving (Show)

data Lit
    = LStr String
  deriving (Show)

newtype Type = Type String
  deriving (Show)

newtype Ident = Ident String
  deriving (Show)
