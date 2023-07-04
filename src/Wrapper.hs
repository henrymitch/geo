{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Wrapper where

import Embedding
import Syntax

template :: String
template = $(embedFile "wrapper/Main.java")

replace :: String -> String -> String -> String
replace [] _ _ = []
replace str old new = go str
    where
        go [] = []
        go s@(x:xs)
            | take (length old) s == old = new ++ drop (length old) s
            | otherwise                  = x : go xs

generateWrapper :: Module -> String
generateWrapper (Module (Ident name) _) = do
    let x  = replace template "/* -IMPORTS- */" ("import " ++ name ++ ";")
    let x' = replace x        "/* -BODY- */"    (name ++ ".Main();") 
    x'
