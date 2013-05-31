-- | Dieses Modul stellt den Datentyp 'ComplRat' komplexrationaler
-- Zahlen, also den Elementen von /Q(i)/, bereit.
module ComplRat
    ( ComplRat(..)
    , realPart
    , imagPart
    , magnitude
    , magnitudeSq
    ) where
import Data.Ratio

-- | Typ für komplexrationale Zahlen in kartesischer Darstellung.
-- Der Konstruktor ist strikt in seinen beiden Argumenten.
data ComplRat = !Rational :+: !Rational
    deriving (Eq)

-- -----------------------------------------------------------------------------
-- Funktionen

-- | Gibt den reelen Teil einer gegebenen complexen Zahl zurück
realPart :: ComplRat -> Rational
realPart (x :+: _) =  x

-- | Gibt den imaginären Teil einer gegebenen complexen Zahl zurück
imagPart :: ComplRat -> Rational
imagPart (_ :+: y) =  y

-- | Der nichtnegative Betrag einer complexen Zahl
-- nur für rein reele oder complexe Zahlen, da es sonst, aufgrund der fehlenden
-- Wurzel, zu problemen kommt
magnitude :: ComplRat -> Rational
magnitude (x :+: 0) = abs x
magnitude (0 :+: y) = abs y
magnitude (_ :+: _) = error "Oops! Use magnitudeSq instead."
{-magnitude (x :+: y) = P.sqrt ( sqr x P.+ (sqr y) )-}
  {-where sqr z = z P.* z-}

-- | Das quadrat des Betrags einer complexen Zahl
-- ist für alle complexen zahlen geeignet
magnitudeSq :: ComplRat -> Rational
magnitudeSq (x :+: y) = x*x + y*y

-- -----------------------------------------------------------------------------
-- Instanzen von ComplRat

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
    where n = c*c + d*d
