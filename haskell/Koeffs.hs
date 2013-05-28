-- | Dieses Modul stellt Funktionen bereit, welche die zu einem Startwert
-- gehörigen Koeffizienten von v(t) und u(t) generieren
module Koeffs
  ( vKoeffs
  , uKoeffs
  ) where
import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

-- returns array with the coefficients of v(t)
-- first element in array is koefficient from t^{-1}
vKoeffs :: ComplRat -> [ComplRat]
vKoeffs uMin2 = 1/2:+:0 : [koeff i|i <- [0..]]
  where koeff :: Int -> ComplRat
        koeff = memo koeff'
        koeff' :: Int -> ComplRat
        koeff' n | n >   0   = (koeff (n-1)*(fromIntegral n+1)+summe)/uMin2
                 | n ==  0   = -3/(uMin2*4)
                 | n == -1   = 1/2
                 | otherwise = 0
                 where summe = sum [koeff (k-1)*(koeff (n-k-1))|k <- [1..n-1]]

-- returns array with the coefficients of u(t)
-- first element in array is koefficient from t^{-2}
uKoeffs :: ComplRat -> [ComplRat]
uKoeffs uMin2 = uMin2 : -3/2:+:0 : (tail $ vKoeffs uMin2)
