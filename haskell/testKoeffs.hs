module Main where
import ComplRat
import Koeffs
import System.Environment

uMin2=(0:+:1)

main :: IO()
main = do x <- getArgs
          putStrLn $ "n \t| v_n\n--------+"++(replicate 70 '-')
          main' $ head $ map (\x -> read x :: Int) x
  where main' :: Int -> IO()
        main' end = mapM_ addLine $ zip [-1..end] $ vKoeffs uMin2
          where addLine (i,a) = putStrLn $ show i ++ "\t| " ++ show a
