module Generator where

import Syntax
import Translation

import Control.Monad.State
import Data.List

data GenState = GenState
    { code    :: String
    , indents :: Int    }

type CodeGen = State GenState

class Gen a where
    str  :: a -> String
    
    -- With preceeding space
    (+/) :: String -> a -> String
    s +/ x = s ++ " " ++ str x

    -- Without preceeding space
    (+|) :: String -> a -> String
    s +| x = s ++ str x

instance Gen Ident where
    str (Ident x) = translateIdent x

instance Gen Type where
    str (Type x) = translateType x

instance Gen Lit where
    str (LStr x) = x

emit :: String -> CodeGen ()
emit c = do
    state <- get
    --let spaces = replicate (indents state) ' '
    let spaces = ""
    let new = spaces ++ code state ++ c ++ "\n"
    put $ state { code = new }

runGenerator :: Module -> CodeGen ()
runGenerator (Module (Ident id) decls) = do
    emit $ "public class " ++ id
    startBlock
    mapM_ declGen decls
    endBlock

sigGen :: Sig -> CodeGen ()
sigGen (Sig id params ret) = do
    emit $ "public static" +/ ret +/ id
    paramsGen params

paramsGen :: [Type] -> CodeGen()
paramsGen ts = do
    emit $ "(" ++ intercalate ", " (map ("" +/) ts) ++ ")"

declGen :: Decl -> CodeGen ()
declGen (DFun s impls) = do
    sigGen s
    startBlock
    implGen (head impls)
    endBlock

implGen :: Impl -> CodeGen ()
implGen (Impl (ECall id p)) = do
    emit $ "" +| id ++ "(" +| p ++ ");"

startBlock :: CodeGen ()
startBlock = do
    emit "{"
    state <- get
    put $ state { indents = indents state + 4 }

endBlock :: CodeGen ()
endBlock = do
    state <- get
    put $ state { indents = indents state - 4 }
    emit "}"

generateCode :: Module -> String
generateCode m = do
    let initialState = GenState { code = "", indents = 0 }
    let final = execState (runGenerator m) initialState
    code final
