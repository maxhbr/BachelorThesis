module Main where
import ComplRat
import Koeffs
import System.Environment
import Data.Ratio

uMin2=(0:+:1)

main :: IO()
main = do x <- getArgs
          main' $ head $ map (\x -> read x :: Int) x
  where main' :: Int -> IO()
        main' end = mapM_ addLine $ zip [-1..end] $ vKoeffs uMin2
          where addLine (i,a) = putStrLn $ showLaTeX a ++ "t^{" ++ show i ++ "}+"

-- | Gibt zu einem Element in ComplRat die entsprechende LaTeX Notation zurück
showLaTeX :: ComplRat -> String
showLaTeX (0 :+: 0) = "0"
showLaTeX (x :+: 0) = "\\frac{" ++ (show $ numerator x) ++ "}{"
                                ++ (show $ denominator x) ++ "}"
showLaTeX (0 :+: y) = showLaTeX (y:+:0) ++ "i"
showLaTeX (x :+: y) = showLaTeX (x:+:0) ++ "+" ++ showLaTeX (y:+:0) ++ "i"

asList :: Int -> IO()
asList end = mapM_ addLine $ zip [-1..end] $ vKoeffs uMin2
  where addLine (i,a) = putStrLn $ "\\\\" ++ show i ++ " & $" ++ showLaTeX a ++ "$"
