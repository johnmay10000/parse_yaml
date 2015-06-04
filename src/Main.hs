{-# LANGUAGE OverloadedStrings   #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where
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
import           Definitions
-- import qualified System.FilePath.FilePather.Find as FP
-- import qualified System.FilePath.FilePather.FilterPredicate as FP
-- import qualified System.FilePath.FilePather.FileType as FP
-- import qualified System.FilePath.FilePather.RecursePredicate as FP
-- import qualified Data.ByteString.Char8 as BS
-- loopRead :: String -> IO([String])
-- loopRead file = lines <$> readFile file
main  = do
        results <- Y.decodeFile "10-Sky/config.yml" :: IO ( Maybe Y.Value )
        defs <- Y.decodeFile "definitions.yml" :: IO ( Maybe Y.Value )
--      files <- getDirNames
        -- filenames <-
        -- dirs <- directories files
--         putStrLn "Definitions"
--         process definitions
        putStrLn "Config"
        process results
        -- return (_)

-- Y.decodeFile :: Y.FromJSON a => FilePath -> IO (Maybe a)
--  Test code
-- process' :: Maybe Y.Value -> IO ()
-- process' (Just v) = mapM_ putStrLn $ processValueToString v
-- process' _ = return ()
--
-- processValue :: Y.Value -> [(T.Text, Y.Value)]
-- processValue (Y.Object a) = HM.toList a
-- processValue _ = []
--
-- processValueToString :: Y.Value -> [String]
-- processValueToString (Y.Object a) = map show $ HM.toList a
-- processValueToString _ = []
--
-- processKeys :: Y.Value -> [T.Text]
-- processKeys (Y.Object a) = HM.keys a
-- processKeys _ = []
--
-- processKeysToString :: Y.Value -> [String]
-- processKeysToString (Y.Object a) = map show $ HM.keys a
-- processKeysToString _ = []

-- getDirectoryContents :: FilePath -> IO [FilePath]
dropList :: [FilePath]
dropList = [".", "..", ".DS_Store"]

-- definitions :: [String]
-- definitions = ["",""]

process :: Maybe Y.Value -> IO ()
process (Just v) = mapM_ print (processTopLevel v)
process Nothing = putStrLn "WAT?"

processKeys ::Maybe Y.Value -> [String]
processKeys (Just v) = map show $ processTopLevel v
processKeys Nothing = []

doProcessLevel :: [T.Text] -> [(T.Text, Y.Value)] -> [T.Text]
doProcessLevel = foldl processGetKeys

processTopLevel :: Y.Value -> [T.Text]
processTopLevel (Y.Object a) = nub (doProcessLevel [] $ HM.toList a)
processTopLevel _ = []

processGetKeys :: [T.Text] -> (T.Text, Y.Value) -> [T.Text]
processGetKeys xs (t, Y.Object b) = t : doProcessLevel xs (HM.toList b)
processGetKeys xs (t, _) = t:xs

getDirNames :: IO [FilePath]
getDirNames = do
          files <- getNames
          dirNames <- filterM isDir files
          let filteredDirNames = filter (`notElem` dropList) dirNames
          return filteredDirNames

getNames :: IO [FilePath]
getNames = getCurrentDirectory >>= getDirectoryContents

fileStatus :: FilePath -> IO FileStatus
fileStatus = getFileStatus

isDir :: FilePath -> IO Bool
isDir p = do
          fs <- fileStatus p
          return (isDirectory fs)

findFilesNames :: IO [FilePath]
findFilesNames = do
               files <- getNames
               dirNames <- getDirNames
               let filteredFiles =  filter (`notElem` dropList) files
               let filesOnly = filter (`notElem` dirNames) filteredFiles
               let filesNoExts = map dropExtension $ filterFileExts (\p -> takeExtension p == ".png" || takeExtension p == ".jpg" || takeExtension p == ".jpeg") filesOnly
               return filesNoExts

filterFileExts :: (FilePath -> Bool) -> [FilePath] -> [FilePath]
filterFileExts = filter

-- directories :: IO [FilePath] -> IO [FilePath]
-- directories = _
-- directories l = do
--                 filePaths <- filter isDir l
--                 return filePaths
-- directories l = do
--                 return (foldl (\acc e -> do
--                                             isDir <- isDirectory <$> (fileStatus e)
--                                             if isDir
--                                               then e:acc
--                                               else acc ) l [])

-- validFileNames :: [FilePath] -> [FilePath]
-- validFileNames =

-- maildirFind :: ([String] -> Bool) -> ([String] -> Bool) -> FilePath -> IO [FilePath]
-- maildirFind fpred rpred mbox = FP.findp
-- 	(FP.filterPredicate (\x t -> FP.isDirectory t && normPred fpred x))
-- 	(FP.recursePredicate (normPred rpred))
-- 	mbox
-- 	where
-- 	normPred pred x =
-- 		let s = FP.splitDirectories $ FP.normalise x in
-- 			last s `notElem` ["new","cur","tmp"] &&
-- 				not ("." `isPrefixOf` last s) && pred s
