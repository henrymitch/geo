{-# LANGUAGE TemplateHaskell #-}
module Embedding where

import Language.Haskell.TH

embedFile :: FilePath -> Q Exp
embedFile path =
    runIO (readFile path) >>= strToExpr

strToExpr :: String -> Q Exp
strToExpr s = [| s |]
