#!/usr/bin/env runhaskell
{-module Main where-}
import Data.Complex

{-a :: Complex Double-}
a=1/8 -- :+0

uKoeff :: Int -> Complex Double
uKoeff n | n == -2   = 0:+(1/(2*sqrt(2*a)))
         | n == -1   = (-3/2):+0
         | otherwise = - (vKoeff n)

vKoeff :: Int -> Complex Double
vKoeff n | n == -1   = 1/2
         | n ==  0   = uKoeff (-2) * (3/4)
         | n >   0   = uKoeff (-2) * ((n+1) * (vKoeff (n-1)) + summe)
         | otherwise = 0
  where summe = sum [vKoeff (k-1) * (vKoeff (n-k-1)) | k <- [1..n-1]]

--evalU :: Double -> Int -> Complex Double
evalU x e = zipWith (+) [uKoeff i|i <- [-2..e]] [x^i|i <- [-2..e]]
--evalV :: Double -> Int -> Complex Double
evalV x e = zipWith (+) [vKoeff i|i <- [-1..e]] [x^i|i <- [-1..e]]
