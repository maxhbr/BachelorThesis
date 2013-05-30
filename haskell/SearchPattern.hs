module Main where
import ComplRat
import Koeffs
import Data.Ratio

{-searchPattern :: Int -> IO()-}
{-searchPattern end = searchPattern' end 1-}
{-searchPattern' :: Int -> ComplRat -> IO()-}
{-searchPattern' end uMin2 = mapM_ addLine $ take end $ zip [0..] $ vKoeffs uMin2-}
  {-where addLine (i,a) = putStr $ show i ++ "\t" ++ (show $ item (i,a)) ++ "\n"-}
        {-item (i,a)    = numerator $ magnitude $ a*(fromIntegral $ floor $ 2**(i+1))-}

uMin2=(1:+:0)

items end = items' end uMin2
items' end uMin2 =  map (item) $ take end $ zip [0..] $ vKoeffs uMin2
  where item (i,a) = magnitude $ a*(fromIntegral $ floor $ 2**(i+1))

step2 = map (\(x,y) -> x/y) list
   where list = zip (tail $ items 11) (items 10)
step3 = map (\(x,y) -> x/y) list
   where list = zip (tail $ tail $ items 12) (items 10)

printList list = mapM_ putStrLn $ map show list
