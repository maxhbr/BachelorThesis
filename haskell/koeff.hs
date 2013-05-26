module Main where
import ComplRat
import Data.MemoTrie (memo) -- https://github.com/conal/MemoTrie

-- parallel
import qualified Control.Monad.Parallel as P

-- for writing to file
import System.Environment
import System.IO
import Data.Time

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

printData :: Int -> ComplRat -> IO()
printData end uMin2 = mapM_ addLine $ take end $ zip3 [0..] (tail vals) vals
  where vals      = vKoeffs uMin2
        addLine a = putStr $ genLine a

genLine :: (Int, ComplRat, ComplRat) -> String
genLine (i,v1,v2) = concat [ show  i                   , "\t"
                           , show $ betrag (i,v1,v2)   , "\t"
                           , show $ (cauchy (i,v1,v2)) , "\t"
                           , show $ quot (i,v1,v2)     , "\t"
                           , show $ fac (i,v1,v2)      , "\t"
                           , show $ approxSize v1      , "\n" ]
  where toDbl x        = fromRational x :: Double
        betrag (_,v,_) = fromRational $ magnitude v
        cauchy (i,v,_) = (fromRational $ magnitude v)**(1/(fromIntegral i))
        quot (_,v1,v2) = sqrt $ toDbl $ (magnitudeSq v2) / (magnitudeSq v1)
        fac (i,v,_)    = fromRational $ (magnitude v) / 
                                        (fromIntegral $ product [1..i])

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

saveData :: Int -> (String, ComplRat) -> IO()
saveData end (fn, uMin2) =
  do start <- getCurrentTime
     withFile fn WriteMode (\handle -> do
       hPutStr handle (concat $ take end $ map genLine triples))
     stop <- getCurrentTime
     putStrLn $ fn ++ " " ++ (show $ diffUTCTime stop start)
  where vals      = vKoeffs uMin2
        triples   = zip3 [0..] (tail vals) vals
