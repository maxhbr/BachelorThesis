module Main where
import ComplRat
import Koeffs

-- from numbers
import Data.Number.CReal (CReal)

-- from monad-parallel
import qualified Control.Monad.Parallel as P (sequence_)

-- for writing to file
import System.Environment
import System.IO
import Data.Time

main :: IO()
main = do x <- getArgs; P.sequence_ $ main' $ (read $ head x :: Int)
  where
    main' x = map (saveData x) [ ("./data/u_-2=i"       , (0:+:1))
                               , ("./data/u_-2=1.0e-5i" , (0:+:1.0e-5))
                               , ("./data/u_-2=1.0e-4i" , (0:+:1.0e-4))
                               , ("./data/u_-2=1.0e-3i" , (0:+:1.0e-3))
                               , ("./data/u_-2=1.0e-2i" , (0:+:1.0e-2))
                               , ("./data/u_-2=1.0e-1i" , (0:+:1.0e-1))
                               , ("./data/u_-2=10000i"  , (0:+:10000))
                               , ("./data/u_-2=1000i"   , (0:+:1000))
                               , ("./data/u_-2=100i"    , (0:+:100))
                               , ("./data/u_-2=10i"     , (0:+:10))
                               ]

    saveData :: Int -> (String, ComplRat) -> IO()
    saveData end (fn, uMin2) =
      do start <- getCurrentTime
         withFile fn WriteMode (\handle -> do
           hPutStr handle (concat $ take end $ map genLine triples))
         stop <- getCurrentTime
         putStrLn $ fn ++ " " ++ (show $ diffUTCTime stop start)
      where vals    = vKoeffs uMin2
            triples = zip3 [0..] (tail vals) vals

    genLine :: (Int, ComplRat, ComplRat) -> String
    genLine (i,v1,v2) = concat [ show  i                 , "\t"
                               , genItemBetrag (i,v1,v2) , "\t"
                               , genItemCauchy (i,v1,v2) , "\t"
                               , genItemQuot (i,v1,v2)   , "\n" ]
      where realMag = fromRational $ magnitude v1 :: CReal

            genItemBetrag :: (Int, ComplRat, ComplRat) -> String
            genItemBetrag (_,v,_) = show $ realMag

            genItemCauchy :: (Int, ComplRat, ComplRat) -> String
            genItemCauchy (i,v,_)
              | i == 0    = show $ realMag
              | otherwise = show $ realMag**(1 / (fromIntegral i))

            genItemQuot :: (Int, ComplRat, ComplRat) -> String
            genItemQuot (_,v1,v2) = show $ sqrt $ fromRational $ genItemQuot'
              where genItemQuot' = magnitudeSq v2 / magnitudeSq v1
