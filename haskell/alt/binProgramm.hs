{-# LANGUAGE GADTs, TypeFamilies, TypeOperators, ScopedTypeVariables, CPP #-}
{-# LANGUAGE StandaloneDeriving, FlexibleInstances #-}
{-# OPTIONS_GHC -Wall -fenable-rewrite-rules #-}
import ComplRat

import Data.MemoTrie -- https://github.com/conal/MemoTrie
import System.Environment (getArgs)

import System.IO
import System.Directory
import Control.Monad

-- {{{ for memorizing ComplRat
import Data.Bits 
import Control.Arrow (first,(&&&))

instance HasTrie ComplRat where
    -- | Representation of trie with domain type @a@
    data (:->:) a :: * -> *
    newtype ComplRat :->: a = ComplRatTrie ((Bool,[Bool]) :->: a)
    -- | Create the trie for the entire domain of a function
    trie   :: (a  ->  b) -> (a :->: b)
    trie f = ComplRatTrie (trie (f . unbitsZ))
    -- | Convert a trie to a function, i.e., access a field of the trie
    untrie :: (a :->: b) -> (a  ->  b)
    untrie (ComplRatTrie t) = untrie t . bitsZ
    -- | List the trie elements.  Order of keys (@:: a@) is always the same.
    enumerate :: (a :->: b) -> [(a,b)]
    enumerate (ComplRatTrie t) = enum' unbitsZ t

unbitsZ :: (Num n, Bits n) => (Bool,[Bool]) -> n
unbitsZ (positive,bs) = sig (unbits bs)
 where
   sig | positive  = id
       | otherwise = negate

bits :: (Num t, Bits t) => t -> [Bool]
bits 0 = []
bits x = testBit x 0 : bits (shiftR x 1)

unbit :: Num t => Bool -> t
unbit False = 0
unbit True  = 1

unbits :: (Num t, Bits t) => [Bool] -> t
unbits [] = 0
unbits (x:xs) = unbit x .|. shiftL (unbits xs) 1

bitsZ :: (Num n, Ord n, Bits n) => n -> (Bool,[Bool])
bitsZ = (>= 0) &&& (bits . abs)  

enum' :: (HasTrie a) => (a -> a') -> (a :->: b) -> [(a', b)]
enum' f = (fmap.first) f . enumerate
-- }}}

-- Parameter
a = 0.125
defaultuMin2 = 0:+:1

-- returns n-th coefficient of v(t)
vKoeff :: Int -> ComplRat -> ComplRat
vKoeff = memo2 vKoeff'
  where vKoeff' :: Int -> ComplRat -> ComplRat
        vKoeff' n uMin2
          | n >   0   = ((fromIntegral n+1)*(vKoeff (n-1) uMin2)+summe)/uMin2
          | n ==  0   = -3/(uMin2*4)
          | n == -1   = 1/2
          | otherwise = 0
          where summe = sum [vKoeff (k-1) uMin2*(vKoeff (n-k-1) uMin2)|
                              k <- [1..n-1]]

-- returns n-th coefficient of u(t)
uKoeff :: Int -> ComplRat -> ComplRat
uKoeff n uMin2 | n == -2   = uMin2 -- (sqrt(8*a))
               | n == -1   = -3/2
               | otherwise = -(vKoeff n uMin2)

{-main :: IO ()-}
{-main = do args <- getArgs-}
          {-putStrLn $ "n \t| v_n    u_n\n--------+"++(replicate 70 '-')-}
          {-mapM_ (putStrLn . formated) [-2..(read $ head args :: Int)]-}
          {-mapM_ (putStrLn . formated) $ map (\x -> read x :: Int) (tail args)-}
  {-where formated :: Int -> String-}
        {-formated i = concat [ show i, " \t| " , show $ vKoeff i, "    "-}
                                              {-, show $ uKoeff i ]-}

-- ####  test convergence  ###################################################
{-convTest = do fileExists <- doesFileExist fn-}
              {-when fileExists (removeFile fn)-}
              {-mapM_ addLine [1..10000]-}
  {-where fn        = "../img/data/a="++(show a)-}
        {-toDbl x   = fromRational x :: Double-}
        {-betrag i  = magnitude $ vKoeff i-}
        {-cauchy i  = (fromRational $ betrag i)**(1/(fromIntegral i))-}
        {-quot i    = toDbl $ (betrag i) / (betrag (i+1))-}
        {-addLine i = do putStr $ show i ++ " "-}
                       {-appendFile fn $ concat [ show i                  , " "-}
                                              {-, show $ toDbl $ betrag i , " "-}
                                              {-, show $ cauchy i         , " "-}
                                              {-, show $ quot i           , "\n" ]-}
