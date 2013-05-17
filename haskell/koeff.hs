module Main where
import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

-- parallel
import qualified Control.Monad.Parallel as P

-- for writing to file
import System.Environment
import System.IO
import System.Directory
import Control.Monad
import Data.Time

-- returns array with the coefficients of v(t)
-- first element in array is koefficient from t^{-1}
vKoeffs :: ComplRat -> [ComplRat]
vKoeffs uMin2 = 1/2:+:0 : [vKoeff i|i <- [0..]]
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
-- first element in array is koefficient from t^{-2}
uKoeffs :: ComplRat -> [ComplRat]
uKoeffs uMin2 = uMin2 : -3/2:+:0 : (tail $ vKoeffs uMin2)

printData :: Int -> ComplRat -> IO()
printData end uMin2 = mapM_ addLine $ take end $ zip3 [0..] (tail vals) vals
  where vals      = vKoeffs uMin2
        addLine a = putStr $ genLine a

genLine :: (Int, ComplRat, ComplRat) -> String
genLine (i,v1,v2) = concat [ show  i                 , "\t"
                           , show $ betrag (i,v1,v2) , "\t"
                           , show $ (cauchy (i,v1,v2)) , "\t"
                           , show $ quot (i,v1,v2)   , "\n" ]
  where toDbl x        = fromRational x :: Double
        betrag (_,v,_) = fromRational $ magnitude v
        cauchy (i,v,_) = (fromRational $ magnitude v)**(1/(fromIntegral i))
        quot (_,v1,v2) = sqrt $ toDbl $ (magnitudeSq v2) / (magnitudeSq v1)

-- ############################################################################

main :: IO()
main = do x <- getArgs
          P.sequence_ (funcs $ head $ map (\x -> read x :: Int) x)
  where funcs x = map (saveData x) [ ("./data/u_-2=i"       , (0:+:1))
                                   {-, ("./data/u_-2=-i"      , (0:+:(-1)))-}
                                   {-, ("./data/u_-2=1"       , (1:+:0))-}
                                   {-, ("./data/u_-2=-1"      , (-1:+:0))-}
                                   {-, ("./data/u_-2=10000i"  , (0:+:10000))-}
                                   {-, ("./data/u_-2=1000i"   , (0:+:1000))-}
                                   {-, ("./data/u_-2=100i"    , (0:+:100))-}
                                   {-, ("./data/u_-2=10i"     , (0:+:10))-}
                                   , ("./data/u_-2=1.0e-1i" , (0:+:1.0e-1))
                                   , ("./data/u_-2=1.0e-2i" , (0:+:1.0e-2))
                                   , ("./data/u_-2=1.0e-3i" , (0:+:1.0e-3))
                                   , ("./data/u_-2=1.0e-4i" , (0:+:1.0e-4))
                                   , ("./data/u_-2=1.0e-5i" , (0:+:1.0e-5))
                                   ]

testSaveData = saveData 100 ("./data/u_-2=i", (0:+:1))

saveData :: Int -> (String, ComplRat) -> IO()
saveData end (fn, uMin2) =
  do start <- getCurrentTime
     fileExists <- doesFileExist fn
     when fileExists (removeFile fn)
     withFile fn WriteMode (\handle -> do
       hPutStr handle (concat $ take end $ map genLine triples))
     {-mapM_ addLine $ take end $ triples-}
     stop <- getCurrentTime
     putStrLn $ fn ++ " " ++ (show $ diffUTCTime stop start)
  where vals      = vKoeffs uMin2
        triples   = zip3 [0..] (tail vals) vals
        {-addLine a = appendFile fn $ genLine a-}
