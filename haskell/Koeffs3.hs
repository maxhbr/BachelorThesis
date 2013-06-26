-- | Dieses Modul stellt Funktionen bereit, welche die zu einem Startwert
-- gehörigen Koeffizienten von v(t) und u(t) generieren
module Koeffs3
  ( vKoeffs
  {-, uKoeffs-}
  ) where
import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

-- returns array with the coefficients of v(t)
-- first element in array is koefficient from t^{-1}
vKoeffs :: [ComplRat] -> [[ComplRat]]
vKoeffs uMin2s = ([1/2:+:0] : [vKoeffs' i|i <- [0..]])
  where vKoeffs' i        = map (vKoeffs'' i) uMin2s
        vKoeffs'' i uMin2 = product [1/uMin2|j <- [1..i]] * (tildeKoeff i)

tildeKoeff :: Int -> ComplRat
tildeKoeff = memo tildeKoeff'
tildeKoeff' :: Int -> ComplRat
tildeKoeff' n | n >   0   = tildeKoeff (n-1)*(fromIntegral n+1)+
                sum [tildeKoeff (k-1)*(tildeKoeff (n-k-1))|k <- [1..n-1]]
              | n ==  0   = -3/(4)
              | n == -1   = 1/2
              | otherwise = 0

-- returns array with the coefficients of u(t)
-- first element in array is koefficient from t^{-2}
{-uKoeffs :: ComplRat -> [ComplRat]-}
{-uKoeffs uMin2 = uMin2 : -3/2:+:0 : (map negate (tail $ vKoeffs uMin2))-}
