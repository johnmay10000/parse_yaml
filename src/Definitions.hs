module Definitions where
import qualified Data.Yaml           as Y
-- import qualified Data.Vector as V
import           Control.Applicative()
import qualified Data.HashMap.Strict as HM
import qualified Data.Text           as T
import           System.Directory
import           System.Posix.Files
import           Control.Monad
import           System.FilePath
import           Data.List

definitions :: Maybe Y.Value -> [(T.Text, T.Text)]
definitions = process

process :: Maybe Y.Value -> [(T.Text, Y.Value)]
process (Just v) = processTopLevel v
process Nothing = putStrLn "WAT?"

doProcessLevel :: [T.Text] -> [(T.Text, Y.Value)] -> [T.Text]
doProcessLevel = foldl processGetKeys

processTopLevel :: Y.Value -> [T.Text]
processTopLevel (Y.Object a) = nub (doProcessLevel [] $ HM.toList a)
processTopLevel _ = []

processGetKeys :: [T.Text] -> (T.Text, Y.Value) -> [T.Text]
processGetKeys xs (t, Y.Object b) = t : doProcessLevel xs (HM.toList b)
processGetKeys xs (t, _) = t:xs