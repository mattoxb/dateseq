#!/usr/bin/env stack
-- stack --resolver lts-13.29 script
{-# LANGUAGE OverloadedStrings #-}

module Main where
import Turtle
import Data.Time
import Data.Time.Calendar
import Data.Time.Calendar.WeekDate
import Options.Applicative
import Control.Monad.Reader

default (Text)

dowFilter :: Maybe [DOW] -> Day -> Bool
dowFilter Nothing = \_ -> True
dowFilter (Just dows) =
   let intDows = (map fromEnum dows)
    in \ day -> let (_,_,day') = toWeekDate day 
               in day' `mod` 7 `elem` (map fromEnum dows)


data Options = Options { start :: Day,
                         end :: Day,
                         dows :: Maybe [DOW] }
defaultOptions :: Options
defaultOptions = Options undefined undefined Nothing

data DOW = Su | M | T | W | Th | F | Sa
   deriving (Eq,Ord,Show,Enum)

instance Read DOW where
  readsPrec _ ('T':'h':rest) = [(Th,rest)]
  readsPrec _ ('S':'a':rest) = [(Sa,rest)]
  readsPrec _ ('S':rest)  = [(Su,rest)]
  readsPrec _ ('M':rest)  = [(M,rest)]
  readsPrec _ ('T':rest)  = [(T,rest)]
  readsPrec _ ('W':rest)  = [(W,rest)]
  readsPrec _ ('R':rest)  = [(Th,rest)]
  readsPrec _ ('F':rest)  = [(F,rest)]
  readsPrec _ ('A':rest)  = [(Sa,rest)]
  readsPrec _ x = []

dowsReader ('T':'h':rest) = Th : dowsReader rest
dowsReader ('S':'a':rest) = Sa : dowsReader rest
dowsReader ('S':rest)  = Su : dowsReader rest
dowsReader ('M':rest)  = M : dowsReader rest
dowsReader ('T':rest)  = T : dowsReader rest
dowsReader ('W':rest)  = W : dowsReader rest
dowsReader ('R':rest)  = Th : dowsReader rest
dowsReader ('F':rest)  = F : dowsReader rest
dowsReader ('A':rest)  = Sa : dowsReader rest
dowsReader [] = []
 
parseDOWs :: ReadM (Maybe [DOW])
parseDOWs = eitherReader (\s -> return $ Just (dowsReader s))

parser :: Parser Options
parser = Options <$> argRead "START" "The start date"
                 <*> argRead "END" "The end date"
                 <*> Options.Applicative.option parseDOWs (metavar "DOWS" <> long "dows" <> short 'd' <> help "The days of week (e.g. MWF)" <> value Nothing)

main = sh $ do
   opts <- options "dateseq" parser
   let df = dowFilter (dows opts)
   liftIO $ mapM_ print [x | x <- [start opts .. end opts], df x]

