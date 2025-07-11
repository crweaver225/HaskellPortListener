{-# LANGUAGE OverloadedStrings #-}

module Main where

import Web.Scotty
import Control.Concurrent.MVar
import qualified Data.Map as Map
import qualified Data.ByteString.Lazy.Char8 as BL
import qualified Data.Text.Lazy as TL

type Store = MVar (Map.Map String Int)

main :: IO ()
main = do
    -- Create a new MVar to store the key counts
    store <- newMVar Map.empty

    scotty 9000 $ do

        -- POST /input
        post "/input" $ do
            bodyData <- body -- Read the raw request body as a lazy ByteString
            let key = BL.unpack bodyData  -- Convert ByteString to String
            liftIO $ modifyMVar_ store $ \m ->
                return $ Map.insertWith (+) key (1 :: Int) m
            text "OK"

        -- GET /query?key=...
        get "/query" $ do
            key <- queryParam "key"
            count <- liftIO $ do
                m <- readMVar store
                return $ Map.findWithDefault 0 key m
            text (TL.pack (show count))