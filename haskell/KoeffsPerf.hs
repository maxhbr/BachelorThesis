-- | Dieses Modul stellt Funktionen bereit, welche die zu einem Startwert
-- gehörigen Koeffizienten von v(t) und u(t) generieren
module KoeffsPerf
  ( vKoeffs
  , uKoeffs
  ) where
import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

-- returns array with the coefficients of v(t)
-- first element in array is koefficient from t^{-1}
-- FALSE!!!!!!!!!!
vKoeffs :: ComplRat -> [ComplRat]
vKoeffs uMin2 = zipWith (*) denominators numerators
  where 
    denominators :: [ComplRat]
    denominators = [denominator i| i <- [0..]]
      where denominator i = product [(1:+:0)/(2*uMin2)| j <- [1..i]] / 2
    numerators :: [ComplRat]
    numerators = 1:+:0 : [numerator i|i <- [0..]]
      where
        numerator :: Int -> ComplRat
        numerator = memo numerator'
        numerator' :: Int -> ComplRat
        numerator' n | n >   0   = (numerator (n-1)*(fromIntegral n+1)+summe)
                     | n ==  0   = -3/(uMin2*4)
                     | n == -1   = 1/2
                     | otherwise = 0
          where summe = sum [numerator (k-1)*(numerator (n-k-1))|k <- [1..n-1]]

-- returns array with the coefficients of u(t)
-- first element in array is koefficient from t^{-2}
uKoeffs :: ComplRat -> [ComplRat]
uKoeffs uMin2 = uMin2 : -3/2:+:0 : (map negate (tail $ vKoeffs uMin2))
