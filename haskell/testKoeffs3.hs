module Main where
import ComplRat
import Koeffs3
import System.Environment

uMin2s=[ (0:+:1)
       , (1:+:1)
       , (0:+:10)
       , (0:+:100)
       , (0:+:1000)
       , (0:+:10000)
       ]

main :: IO()
main = do x <- getArgs
          putStrLn $ "n \t| v_n\n--------+" ++ replicate 70 '-'
          main' $ head $ map (\x -> read x :: Int) x
  where main' :: Int -> IO()
        main' end = mapM_ addLine $ zip [-1..end] $ vKoeffs uMin2s
          where addLine (i,a) = putStrLn $ show i ++ "\t| " ++ show a
