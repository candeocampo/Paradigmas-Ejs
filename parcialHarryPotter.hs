
data Postre = UnPostre{
    sabores :: [Sabores],
    peso :: Int,
    temperatura :: Int
} deriving(Show,Eq)

type Sabores = String

--Ejemplos
bizcocho :: Postre
bizcocho = UnPostre ["Borracho de Fruta","Crema"] 100 25

tarta :: Postre
tarta = UnPostre ["Melaza"] 50 0

--PUNTO B)

type Hechizo = Postre -> Postre

cambiarPesoPostre :: Int -> Hechizo
cambiarPesoPostre valor postre = postre{ peso = (peso postre * (100 - valor)) `div` 100 }

cambiarTemperaturaPostre :: Int -> Hechizo
cambiarTemperaturaPostre nuevaTemp postre = postre{temperatura=nuevaTemp}

agregarNuevoSabor :: String -> Postre -> Postre
agregarNuevoSabor nuevoSabor postre = postre{sabores=nuevoSabor:sabores postre}

perderSabores :: Hechizo
perderSabores postre = postre{sabores=[]}

incendio :: Hechizo
incendio = cambiarTemperaturaPostre 1 . cambiarPesoPostre 5

inmmobulus:: Hechizo
inmmobulus = cambiarTemperaturaPostre 0

wingardiumLeviosa :: Hechizo
wingardiumLeviosa = agregarNuevoSabor "Concentrado" . cambiarPesoPostre 10

diffindo :: Int -> Hechizo
diffindo porcentaje = cambiarPesoPostre porcentaje

riddikulus :: String -> Hechizo
riddikulus saborNuevo = agregarNuevoSabor (reverse saborNuevo)

avadaKedavra :: Hechizo
avadaKedavra = inmmobulus . perderSabores

--PUNTO C)
estaCongelado :: Postre -> Bool
estaCongelado = (>0).temperatura

unPostreListo :: Postre -> Bool
unPostreListo postre = peso postre > 0 && not(estaCongelado postre) && not(null (sabores postre))

estaraListoPostre :: Hechizo -> [Postre] -> Bool
estaraListoPostre hechizo listaPostre = all (unPostreListo.hechizo) listaPostre

--PUNTO D)
promedioPostre :: [Int] -> Int
promedioPostre pesos = (sum pesos)`div`(length pesos)

promedioPostresListos :: [Postre] -> Int
promedioPostresListos listaPostres= (promedioPostre . map peso .filter unPostreListo) listaPostres
--acá podrias simplificar lo de "listaPostres"

--PARTE 2) MAGOS
data Mago = UnMago{
    hechizosAprendidos :: [Hechizo],
    cantidadHorrorcruxex :: Int
}deriving Show

claseCocina :: Hechizo -> Postre -> Mago ->  Mago
claseCocina hechizo postre mago = sumarHorrocrux hechizo postre.practicaMago hechizo

practicaMago :: Mago -> Hechizo -> Mago
practicaMago mago hechizoPractica= mago{hechizosAprendidos=hechizoPractica:hechizosAprendidos mago}

esElMismoResultado :: Hechizo -> Postre -> Bool
esElMismoResultado hechizo postre = hechizo postre == avadaKedavra postre

sumarHorrocrux :: Mago
sumarHorrocrux mago = mago{cantidadHorrorcruxex=cantidadHorrorcruxex mago + 1}

sumarHorrocruxSegun :: Hechizo -> Postre -> Mago -> Mago
sumarHorrocruxSegun hechizo postre mago
    | esElMismoResultado hechizo postre = sumarHorrocrux mago
    | otherwise = mago

--PUNTO 2B)

mejorHechizo :: Postre -> Mago -> Hechizo
mejorHechizo postre mago = foldl1 (elMejorEntre postre) (hechizosAprendidos mago)

elMejorEntre :: Postre -> Hechizo -> Hechizo -> Hechizo
elMejorEntre postre hechizo1 hechizo2 
    | postreConMasSabores postre hechizo1 hechizo2 = hechizo1
    | otherwise = hechizo2

postreConMasSabores :: Postre -> Hechizo -> Hechizo -> Bool
postreConMasSabores postre hechizo1 hechizo2 = (length.sabores.hechizo1) postre > (length.sabores.hechizo2) postre

--PUNTO 3A)

mesaInfinita :: [Postre]
mesaInfinita = repeat bizcocho

magoInf :: Mago
magoInf = UnMago{hechizosAprendidos=repeat avadaKedavra,cantidadHorrorcruxex=0}

--PUNTO 3B)
-- Suponiendo que hay una mesa con infinitos postres, y pregunto si algún hechizo los deja listos
-- ¿Existe alguna consulta que pueda hacer para que me sepa dar una respuesta? Justificar
-- conceptualmente.

{-
Verdadero, existe la consulta:
Prelude> estanListos avadaKedabra mesaInfinita
La ejecución devuelve falso pues debido a la evaluación diferida, el all cuando encuentra el primer postre que no está listo ya retorna y no requiere construir la lista infinita.
-}




--PUNTO 3C)
-- Suponiendo que un mago tiene infinitos hechizos ¿Existe algún caso en el que se puede
-- encontrar al mejor hechizo? Justificar conceptualmente

{-
No existe ninguna forma de conocer el mejor hechizo del mago porque para hacerlo hay que evaluar todos los elementos lista, aún teniendo lazy evaluation.
-}


