import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie
import System.Environment (getArgs)

import System.IO
import System.Directory
import Control.Monad

-- Parameter
a = 0.1

-- returns n-th coefficient of v(t)
vKoeff :: Int -> ComplRat
vKoeff = memo vKoeff'
  where vKoeff' :: Int -> ComplRat
        vKoeff' n
          | n >   0   = ((fromIntegral n+1)*(vKoeff (n-1))+summe)/(uKoeff (-2))
          | n ==  0   = -3/(uKoeff (-2)*4)
          | n == -1   = 1/2
          | otherwise = 0
          where summe = sum [vKoeff (k-1)*(vKoeff (n-k-1))|k <- [1..n-1]]

-- returns n-th coefficient of u(t)
uKoeff :: Int -> ComplRat
uKoeff n | n == -2   = 0:+:1 -- (sqrt(8*a))
         | n == -1   = -3/2
         | otherwise = -(vKoeff n)
