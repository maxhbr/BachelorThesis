#!/usr/bin/env runhaskell
module Main where
import Data.Complex
{-import Data.MemoTrie-}

main :: IO ()
main = do mapM_ print bothKoeff
  where bothKoeff :: [(Int,Complex Double,Complex Double)]
        bothKoeff = [(i, vKoeff i, uKoeff i)|i <- [-2..]]

a = 1/8

vKoeffs :: [Complex Double]
vKoeffs = [vKoeff i|i <- [-1..]]
vKoeff :: Int -> Complex Double
vKoeff n | n == -1   = 1/2
         | n ==  0   = 3/(uKoeff (-2)*4)
         | n >   0   = ((fromIntegral n+1)*(vKoeff (n-1))+summe)/(uKoeff (-2))
         | otherwise = 0
  where summe = sum $ zipWith (*) xs ys
        xs = reverse [vKoeff (k-1)|k <- [1..n-1]]
        ys = [vKoeff (k-1)|k <- [1..n-1]]

uKoeffs :: [Complex Double]
uKoeffs = [uKoeff i|i <- [-2..]]
uKoeff :: Int -> Complex Double
uKoeff n | n == -2   = 0:+(2*sqrt(2*a))
         | n == -1   = -3/2
         | otherwise = - (vKoeff n)

-- ############################################################################

produkt :: [Complex Double] -> [Complex Double] -> [Complex Double]
produkt = produkt' 0
  where
    produkt' :: Int -> [Complex Double] -> [Complex Double] -> [Complex Double]
    produkt' i us vs = (sum (zipWith (*) (reverse (take (i+1) us)) vs)): produkt' (i+1) us vs

check :: Int -> [Complex Double]
check e = produkt [uKoeff i|i <- [-2..e]] [vKoeff i|i <- [-1..e]]

{-
pKoeffs :: [Complex Double]
pKoeffs = [pKoeff i|i <- [-1..]]
pKoeff :: Int -> Complex Double
pKoeff n | n == -3   = 0:+(sqrt(2*a)*3)
         | otherwise = 0
-}

-- ############################################################################

--evalU :: Double -> Int -> Complex Double
evalU x e = zipWith (+) [uKoeff i|i <- [-2..e]] [x^i|i <- [-2..e]]
--evalV :: Double -> Int -> Complex Double
evalV x e = zipWith (+) [vKoeff i|i <- [-1..e]] [x^i|i <- [-1..e]]
