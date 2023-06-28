module Translation where

translateIdent :: String -> String
translateIdent "Env/printLn" = "System.out.println"
translateIdent x = x

translateType :: String -> String
translateType "Unit" = "void"
translateType x = x
