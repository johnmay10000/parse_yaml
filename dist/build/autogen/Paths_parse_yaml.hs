module Paths_parse_yaml (
    version,
    getBinDir, getLibDir, getDataDir, getLibexecDir,
    getDataFileName, getSysconfDir
  ) where

import qualified Control.Exception as Exception
import Data.Version (Version(..))
import System.Environment (getEnv)
import Prelude

catchIO :: IO a -> (Exception.IOException -> IO a) -> IO a
catchIO = Exception.catch


version :: Version
version = Version {versionBranch = [0,1,0,0], versionTags = []}
bindir, libdir, datadir, libexecdir, sysconfdir :: FilePath

bindir     = "/Users/johnmay/Library/Haskell/ghc-7.8.3/lib/parse-yaml-0.1.0.0/bin"
libdir     = "/Users/johnmay/Library/Haskell/ghc-7.8.3/lib/parse-yaml-0.1.0.0/lib"
datadir    = "/Users/johnmay/Library/Haskell/ghc-7.8.3/lib/parse-yaml-0.1.0.0/share"
libexecdir = "/Users/johnmay/Library/Haskell/ghc-7.8.3/lib/parse-yaml-0.1.0.0/libexec"
sysconfdir = "/Users/johnmay/Library/Haskell/ghc-7.8.3/lib/parse-yaml-0.1.0.0/etc"

getBinDir, getLibDir, getDataDir, getLibexecDir, getSysconfDir :: IO FilePath
getBinDir = catchIO (getEnv "parse_yaml_bindir") (\_ -> return bindir)
getLibDir = catchIO (getEnv "parse_yaml_libdir") (\_ -> return libdir)
getDataDir = catchIO (getEnv "parse_yaml_datadir") (\_ -> return datadir)
getLibexecDir = catchIO (getEnv "parse_yaml_libexecdir") (\_ -> return libexecdir)
getSysconfDir = catchIO (getEnv "parse_yaml_sysconfdir") (\_ -> return sysconfdir)

getDataFileName :: FilePath -> IO FilePath
getDataFileName name = do
  dir <- getDataDir
  return (dir ++ "/" ++ name)
