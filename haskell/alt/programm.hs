import ComplRat

import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie
import System.Environment (getArgs)

import System.IO
import System.Directory
import Control.Monad

-- Parameter
a = 10

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

{-main :: IO ()-}
{-main = do args <- getArgs-}
          {-putStrLn $ "n \t| v_n    u_n\n--------+"++(replicate 70 '-')-}
          {-mapM_ (putStrLn . formated) [-2..(read $ head args :: Int)]-}
          {-mapM_ (putStrLn . formated) $ map (\x -> read x :: Int) (tail args)-}
  {-where formated :: Int -> String-}
        {-formated i = concat [ show i, " \t| " , show $ vKoeff i, "    "-}
                                              {-, show $ uKoeff i ]-}

-- ####  test convergence  ###################################################
-- | Writes the data to file
convTest :: Int -> IO()
convTest i = do fileExists <- doesFileExist fn
                when fileExists (removeFile fn)
                mapM_ addLine [1..i]
  where fn        = "../img/data/a="++(show a)
        toDbl x   = fromRational x :: Double
        betrag i  = magnitude $ vKoeff i
        cauchy i  = (fromRational $ betrag i)**(1/(fromIntegral i))
        quot i    = toDbl $ (betrag i) / (betrag (i+1))
        addLine i = do putStr $ show i ++ " "
                       appendFile fn $ concat [ show i                  , " "
                                              , show $ toDbl $ betrag i , " "
                                              , show $ cauchy i         , " "
                                              , show $ quot i           , "\n" ]
