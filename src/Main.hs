module Main where

import Lexer (alexScanTokens)
import Parser (geoParse)
import Generator (generateCode)
import Wrapper (generateWrapper)

import System.Environment (getArgs)
import Data.Maybe (listToMaybe)
import System.FilePath ((<.>), splitExtension, replaceFileName)

changeExtension :: FilePath -> FilePath
changeExtension path = 
    name <.> ".java"
    where
        (name,_) = splitExtension path

wrapperPath :: FilePath -> FilePath
wrapperPath path =
    replaceFileName path "Main.java"

main :: IO ()
main = do
    args <- getArgs
    let inFile = listToMaybe args
    case inFile of
        Just inFile -> do
            src <- readFile inFile

            let tokens = alexScanTokens src
            putStrLn $ "Tokens:\n" ++ show tokens

            let ast = geoParse tokens
            putStrLn $ "\nAST:\n" ++ show ast

            let code = generateCode ast
            putStrLn $ "\nGenerated Code:\n" ++ code

            let wrapper = generateWrapper ast
            let wrapperFile = wrapperPath inFile
            writeFile wrapperFile wrapper

            let outFile = changeExtension inFile
            writeFile outFile code

        Nothing -> putStrLn "Error: Invalid arguments."
