{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE ScopedTypeVariables #-}

module Main where

import Web.Scotty
import Control.Concurrent.MVar

import qualified Data.Map as Map
import Data.Map (Map)

import qualified Data.Text.Lazy as TL
import qualified Data.Text as T
import qualified Data.Text.Encoding as TE
import qualified Data.ByteString.Lazy as BL

import qualified Control.Exception as E
import Control.Exception (IOException)

import Data.Aeson (decode, encode)

type Key = String
type Store = Map Key Int

storeFile :: FilePath
storeFile = "store.json" 

main :: IO ()
main = do
    
  storeData <- BL.readFile storeFile `E.catch` \(_ :: IOException) -> return "{}"
  let initialStore = maybe Map.empty id (decode storeData)
  store <- newMVar initialStore

  let saveStore = do
        finalStore <- readMVar store
        BL.writeFile storeFile (encode finalStore)

  scotty 9000 $ do
    post "/input" $ do
      bodyText <- body
      let key = T.unpack (TE.decodeUtf8 (BL.toStrict bodyText))
      liftIO $ modifyMVar_ store $ \m ->
        return $ Map.insertWith (+) key (1 :: Int) m
      liftIO saveStore
      text "OK"

    get "/query" $ do
      key <- queryParam "key"
      count <- liftIO $ do
        m <- readMVar store
        return $ Map.findWithDefault 0 key m
      text (TL.pack (show count))