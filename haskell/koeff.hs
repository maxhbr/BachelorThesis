import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

import System.IO
import System.Directory
import Control.Monad

-- returns array with the coefficients of v(t) 
vKoeffs :: ComplRat -> [(Int, ComplRat)]
vKoeffs uMin2 = (-1,1/2:+:0) : [(i, vKoeff i)|i <- [0..]]
  where
    -- returns n-th coefficient of v(t)
    vKoeff :: Int -> ComplRat
    vKoeff = memo vKoeff'
    vKoeff' :: Int -> ComplRat
    vKoeff' n | n >   0   = (vKoeff (n-1)*(fromIntegral n+1)+summe)/uMin2
              | n ==  0   = -3/(uMin2*4)
              | n == -1   = 1/2
              | otherwise = 0
              where summe = sum [vKoeff (k-1)*(vKoeff (n-k-1))|k <- [1..n-1]]

    -- returns n-th coefficient of u(t)
    uKoeff :: Int -> ComplRat
    uKoeff n | n == -2   = uMin2
             | n == -1   = -3/2
             | otherwise = -(vKoeff n)

-- returns array with the coefficients of u(t) 
uKoeffs :: ComplRat -> [(Int, ComplRat)]
uKoeffs uMin2 = (-2,uMin2) : (-1,-3/2:+:0) : (tail $ vKoeffs uMin2)

testRun :: ComplRat -> IO()
testRun uMin2 = do mapM_ putStrLn $ map show $ take 10 $ vKoeffs uMin2

{-run :: IO()-}
{-run = do mapM_ (genData 100) [(0:+:1),(1:+:0)]-}

genData :: Int -> ComplRat -> IO()
genData end uMin2 = do mapM_ addLine $ take end $ zip3 [0..] (tail vals) vals
  where vals              = map snd $ vKoeffs uMin2
        toDbl x           = fromRational x :: Double
        betrag (_,v,_)    = fromRational $ magnitude v
        cauchy (i,v,_)    = (fromRational $ magnitude v)**(1/(fromIntegral i))
        quot (_,v1,v2)    = sqrt $ toDbl $ (magnitudeSq v2) / (magnitudeSq v1)
        addLine (i,v1,v2) = putStrLn $ concat [ show  i                 , "\t"
                                              , show $ betrag (i,v1,v2) , "\t"
                                              , show $ cauchy (i,v1,v2) , "\t"
                                              , show $ quot (i,v1,v2)
                                              ]

saveData :: String -> Int -> ComplRat -> IO()
saveData fn end uMin2 = do fileExists <- doesFileExist fn
                           when fileExists (removeFile fn)
                           mapM_ addLine $ take end $ zip3 [0..] (tail vals) vals
  where vals              = map snd $ vKoeffs uMin2
        toDbl x           = fromRational x :: Double
        betrag (_,v,_)    = fromRational $ magnitude v
        cauchy (i,v,_)    = (fromRational $ magnitude v)**(1/(fromIntegral i))
        quot (_,v1,v2)    = sqrt $ toDbl $ (magnitudeSq v2) / (magnitudeSq v1)
        addLine (i,v1,v2) = do putStr $ show i ++ " "
                               appendFile fn $ concat [ show  i                 , "\t"
                                                      , show $ betrag (i,v1,v2) , "\t"
                                                      , show $ cauchy (i,v1,v2) , "\t"
                                                      , show $ quot (i,v1,v2)   , "\n"
                                                      ]

-- ####  old  ################################################################
--
{-import System.Environment (getArgs)-}

{-import System.IO-}
{-import System.Directory-}
{-import Control.Monad-}
-- | Writes the data to stdOut
{-genData :: ComplRat -> Int -> Int -> IO()-}
{-genData uMin2 step num = do mapM_ addLine [i*step|i <- [1..num]]-}
  {-where toDbl x   = fromRational x :: Double-}
        {-betrag i  = magnitude $ vKoeff uMin2 i-}
        {-cauchy i  = (fromRational $ betrag i)**(1/(fromIntegral i))-}
        {-quot i    = toDbl $ (betrag (i-1)) / (betrag i)-}
        {-addLine i = do putStr $ concat [ show i                  , " "-}
                                       {-[>, show $ toDbl $ betrag i , " "<]-}
                                       {-[>, show $ cauchy i         , " "<]-}
                                       {-, show $ quot i           , "\n" ]-}

{--- | Writes the data to file-}
{-genData' :: ComplRat -> Int -> IO()-}
{-genData' uMin2 n = do fileExists <- doesFileExist fn-}
                       {-when fileExists (removeFile fn)-}
                       {-mapM_ addLine [1..n]-}
  {-where fn        = "../img/data/test" -- a="++(show a)-}
        {-toDbl x   = fromRational x :: Double-}
        {-betrag i  = magnitude $ vKoeff uMin2 i-}
        {-cauchy i  = (fromRational $ betrag i)**(1/(fromIntegral i))-}
        {-quot i    = toDbl $ (betrag (i-1)) / (betrag i)-}
        {-addLine i = do putStr $ show i ++ " "-}
                       {-appendFile fn $ concat [ show i                  , " "-}
                                              {-, show $ toDbl $ betrag i , " "-}
                                              {-, show $ cauchy i         , " "-}
                                              {-, show $ quot i           , "\n" ]-}
