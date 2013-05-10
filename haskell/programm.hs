#!/usr/bin/env runhaskell
module Main where
import Data.Complex
import Data.MemoTrie -- https://github.com/conal/MemoTrie
import System.Environment

-- Parameter
a = 1/8

-- returns n-th coefficient of v(t)
vKoeff :: Int -> Complex Double
vKoeff = memo vKoeff'
  where vKoeff' :: Int -> Complex Double
        vKoeff' n | n >   0   = ((fromIntegral n+1)*(vKoeff (n-1))+summe) /
                                (uKoeff (-2))
                  | n ==  0   = 3/(uKoeff (-2)*4)
                  | n == -1   = 1/2
                  | otherwise = 0
          where summe = sum $ zipWith (*) [vKoeff (n-k-1)|k <- [1..n-1]] 
                                          [uKoeff (k-1)  |k <- [1..n-1]]

-- returns n-th coefficient of u(t)
uKoeff :: Int -> Complex Double
uKoeff n | n == -2   = 0:+(sqrt(8*a))
         | n == -1   = -3/2
         | otherwise = -(vKoeff n)

main :: IO ()
main = do args <- getArgs
          putStr ("n \t| v_n    u_n\n--------+"++(replicate 70 '-')++"\n")
          mapM_ (putStr . formated) [-2..(read $ head args :: Int)]
  where formated :: Int -> String
        formated i = concat [ show i, " \t| " , show $ vKoeff i, "    "
                                              , show $ uKoeff i, "\n" ]

forPlot :: Int -> IO()
forPlot n = mapM_ (putStr . formated) [-2..n]
  where formated :: Int -> String
        formated i = show i ++ " " ++ (show $ magnitude $ vKoeff i) ++ "\n"
