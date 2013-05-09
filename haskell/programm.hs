#!/usr/bin/env runhaskell
module Main where
import Data.Complex

-- Parameter
a = 1/8

-- returns n-th coefficient of v
vKoeff :: Int -> Complex Double
vKoeff n | n == -1   = 1/2
         | n ==  0   = 3/(uKoeff (-2)*4)
         | n >   0   = ((fromIntegral n+1)*(vKoeff (n-1))+summe)/(uKoeff (-2))
         | otherwise = 0
  where summe = sum $ zipWith (*) [vKoeff (n-k-1)|k <- [1..n-1]] 
                                [uKoeff (k-1)|k <- [1..n-1]]

-- returns n-th coefficient of u
uKoeff :: Int -> Complex Double
uKoeff n | n == -2   = 0:+(sqrt(8*a))
         | n == -1   = -3/2
         | otherwise = -(vKoeff n)

main :: IO ()
main = do { putStr "n \t| v_n    u_n\n"
          ; putStr "--------+-----------------------------------------------\n"
          ; mapM_ format bothKoeffs }
  where bothKoeffs :: [(Int, Complex Double, Complex Double)]
        bothKoeffs = [(i, vKoeff i, uKoeff i)|i <- [-2..]]
        format :: (Int, Complex Double, Complex Double) -> IO ()
        format (i, v, u) = putStr formated
          where formated = show i++" \t| "++(show v)++"    "++(show u)++"\n"
