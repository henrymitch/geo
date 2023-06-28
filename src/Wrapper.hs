{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
module Wrapper where

import Embedding
import Syntax

import Data.Text

template :: String
template = $(embedFile "wrapper/Main.java")

generateWrapper :: Module -> String
-- TODO: Probably best using a function where we don't have to keep converting
--       between Text and String
generateWrapper (Module (Ident name) _) = do
    let x  = replace "/* -IMPORTS- */" (pack ("import " ++ name ++ ";")) (pack template)
    let x' = replace "/* -BODY- */" (pack (name ++ ".main();")) x
    unpack x'

-- import <Name>;
-- <Name>.main();
