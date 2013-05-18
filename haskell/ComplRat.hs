-- | Dieses Modul stellt den Datentyp 'ComplRat' komplexrationaler
-- Zahlen, also den Elementen von /Q(i)/, bereit.
module ComplRat
    ( ComplRat(..)
    , realPart
    , imagPart
    , magnitude
    , magnitudeSq)
    where
import Data.Ratio

-- | Typ für komplexrationale Zahlen in kartesischer Darstellung.
-- Der Konstruktor ist strikt in seinen beiden Argumenten.
data ComplRat = !Rational :+: !Rational
    deriving (Eq)

-- -----------------------------------------------------------------------------
-- Functions over ComplRat

-- | Extracts the real part of a complex number.
realPart :: ComplRat -> Rational
realPart (x :+: _) =  x

-- | Extracts the imaginary part of a complex number.
imagPart :: ComplRat -> Rational
imagPart (_ :+: y) =  y

-- | The nonnegative magnitude of a complex number.
-- only for pure real or pure complex numbers
magnitude :: ComplRat -> Rational
magnitude (x :+: 0) = abs x
magnitude (0 :+: y) = abs y
{-magnitude (x :+: y) = P.sqrt ( sqr x P.+ (sqr y) )-}
  {-where sqr z = z P.* z-}

-- | The square of magnitude of a complex number.
magnitudeSq :: ComplRat -> Rational
magnitudeSq (x :+: 0) = x*x
magnitudeSq (0 :+: y) = y*y
magnitudeSq (x :+: y) = x*x + (y*y)

-- | 
approxSize :: ComplRat -> Int
approxSize c = sizeNumerator - sizeDenominator + 1
  where sizeNumerator   = length $ show $ numerator $ magnitudeSq c
        sizeDenominator = length $ show $ denominator $ magnitudeSq c

-- TODO: approx. log

-- -----------------------------------------------------------------------------
-- Instances of ComplRat

instance Show ComplRat where
    show (x :+: y) | y == 0    = show x
                   | otherwise = "(" ++ show x ++ "+i" ++ show y ++ ")"

instance Num ComplRat where
    (x :+: y) + (x' :+: y') = (x+x') :+: (y+y')
    (x :+: y) * (x' :+: y') = (x*x' - y*y') :+: (x*y' + y*x')
    negate (x :+: y)        = negate x :+: negate y
    fromInteger i           = fromInteger i :+: 0
    abs z                   =  magnitude z :+: 0
    signum (0:+:0)          =  0
    {-signum z@(x:+:y)        =  x P./ r :+: y P./ r  where r = magnitude z-}

instance  Fractional ComplRat  where
  fromRational r      = fromRational r :+: 0
  (a :+: b)/(c :+: d) = ((a*c + (b*d))/n) :+: ((b*c - (a*d))/n)
    where sqr z = z * z
          n     = sqr c + (sqr d)
