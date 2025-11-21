--DATA PROJECT SQL

-- 1) Crea el esquema de la BBDD:

--- Solución: Botón derecho sobre public y clicamos en View Diagram (Hay 15 tablas).

-- 2) Muestra los nombres de todas las películas con una clasificación por edades 'R':

SELECT "title", "rating"
FROM FILM F
WHERE "rating" = 'R';

---Comentarios: Del total de 1.000 películas, hay 195 con rating R (19,5%).
---Dentro de tipos de Rating, hay G (178), PG (194), PG-13 (223), R (195) y NC-17 (210).

SELECT "rating", COUNT (*) AS cantidad_peliculas
FROM FILM F
GROUP BY rating;

-- 3) Encuentra los nombres de los actores que tengan un “actor_id” entre 30 y 40:

SELECT "actor_id", "first_name", "last_name"
FROM ACTOR A 
WHERE "actor_id" BETWEEN 30 AND 40;

---Comentarios: Hay 11 actores y actrices con id del 30 al 40 ambos inclusives. 

-- 4) Obtén las películas cuyo idioma coincide con el idioma original.

SELECT "film_id", "title", "language_id","original_language_id"
FROM FILM F
WHERE "language_id" = "original_language_id";

SELECT *
FROM FILM F;

SELECT *
FROM "language" L;

---Comentarios: Al ejecutar, no me salen resultados (vacío).
---Compruebo lo que puede ocurrir cogiendo la tabla entera de Film (solo hay 1 en language_id) y todo NULLS en original_language_id.
---Y en la tabla entera de Language, hay los diferentes ids por idioma (6).
---Conclusión: en la tabla de Film solo hay películas en inglés.

-- 5) Ordena las películas por duración de forma ascendente:

SELECT "film_id", "title", "length"
FROM FILM F 
ORDER BY "length" ASC;

---Comentarios: Hay 5 pelis con duración mínima de 46 min y 10 con la máxima duración de 185 min.

-- 6) Encuentra el nombre y apellido de los actores que tengan ‘Allen’ en su apellido:

SELECT "actor_id", "first_name", "last_name"
FROM ACTOR A 
WHERE "last_name" = 'ALLEN';

SELECT *
FROM ACTOR A; 

---Comentarios: Ojo con las minúsculas y mayúsculas (Allen no es igual a ALLEN).
---Hay 3 actores y actrices con apellido Allen.

-- 7) Encuentra la cantidad total de películas en cada clasificación de la tabla “film” y muestra la clasificación junto con el recuento:

SELECT "rating", COUNT (*) AS cantidad_peliculas
FROM FILM F
GROUP BY rating
ORDER BY cantidad_peliculas DESC;

---Comentarios: Hay 223 pelis con rating PG-13, 210 con NC-17, 195 con R, 194 con PG y 178 con G.

-- 8) Encuentra el título de todas las películas que son ‘PG-13’ o tienen una duración mayor a 3 horas en la tabla film:

SELECT "title", "rating", "length"
FROM FILM F
WHERE "rating" = 'PG-13'
OR "length" > 180;

---Comentarios: Hay 253 títulos que cumplen al menos una de las condiciones indicadas.

-- 9) Encuentra la variabilidad de lo que costaría reemplazar las películas:

SELECT ROUND (VARIANCE ("replacement_cost"), 2) AS "varianza_coste_reemplazo"
FROM FILM F;

SELECT ROUND (AVG ("replacement_cost"), 2) AS "promedio_coste_reemplazo"
FROM FILM F ;

SELECT ROUND (STDDEV ("replacement_cost"), 2) AS "desviación_coste_reemplazo"
FROM FILM F ;

---C: La varianza es de 36,61.
---Para interpretar los resultados, he calculado promedio (19,98) y Desv.Est. (6,05).
---El coste reemplazo no es fijo pero no hay diferencias extremas (dispersión moderada).

-- 10) Encuentra la mayor y menor duración de una película de nuestra BBDD:

SELECT 
	MIN ("length") AS "menor_duracion",
	MAX ("length") AS "mayor_duracion"
FROM FILM F ;

---C: La menor duración es de 46min y la mayor de 185min.

-- 11) Encuentra lo que costó el antepenúltimo alquiler ordenado por día:

SELECT *
FROM RENTAL R; 

SELECT *
FROM PAYMENT P ;

--Si lo hacemos en base Rental_ID (antepenúltimo alquiler individual):
SELECT R.RENTAL_ID , R.RENTAL_DATE , P.AMOUNT 
FROM RENTAL R 
JOIN PAYMENT P ON R.RENTAL_ID = P.RENTAL_ID
ORDER BY R.RENTAL_DATE DESC
LIMIT 1 OFFSET 2; -- 3r alquiler más reciente

--Si consideramos buscar coste total 3r día más reciente en que hubo alquileres:
WITH total_por_dia AS (
  SELECT
    DATE(r.rental_date) AS dia,
    SUM(p.amount) AS total_coste
  FROM rental r
  JOIN payment p ON r.rental_id = p.rental_id
  GROUP BY DATE(r.rental_date)
)
SELECT dia, total_coste
FROM total_por_dia
ORDER BY dia DESC
OFFSET 2 LIMIT 1; 

---C: En el 1r caso, hacemos un join de tablas para poder buscar el antepenúltimo alquiler individual (por id).
---En este caso, el resultado es rental_id 11.676, fecha 14/02/2006, a las 15:16:03h con un coste de 0.
---Si buscamos el coste total del 3r día más reciente de alquiler, ejecutamos una CTE entre dos Select.
---1r paso es obtener y ordenar todos los alquileres cin su coste y en el 2do paso nos quedamos con el 3r más reciente.
---El resultado es que el día 22/08/2005 es el antepenultimo y el coste total alquileres fue de 2.576,74.

-- 12) Encuentra el título de las películas en la tabla “film” que no sean ni ‘NC-17’ ni ‘G’ en cuanto a su clasificación:

SELECT "film_id", "title", "rating"
FROM FILM F 
WHERE "rating" NOT IN ('NC-17', 'G');

---C: Hay 612 títulos que no están clasificados ni con ‘NC-17’ ni con ‘G’.
---Esto cuadra con los rtdos previos ya que si en total hay 1.000 títulos y le restamos 612 (total sin NC-17 y G)da 388 que es el total de NC-17 (210) y G (178).

-- 13) Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la clasificación junto con el promedio de duración:

SELECT "rating", ROUND (AVG ("length"),1) AS promedio_duracion
FROM FILM F
GROUP BY rating;

---C: Las pelis de clasificación PG-13 son las más largas, con un promedio de 120,4 min. Las más cortas, las de rating R.

-- 14) Encuentra el título de todas las películas que tengan una duración mayor a 180 minutos:

SELECT "film_id", "title", "length"
FROM FILM F 
WHERE "length" >180
ORDER BY "length" DESC;

---C: Hay 39 películas que duran más de 180 minutos.

-- 15) ¿Cuánto dinero ha generado en total la empresa?

SELECT ROUND (SUM ("amount"), 2) AS total_generado
FROM PAYMENT ; 

---C: En total, la empresa ha generado 67.417 USD/€.

-- 16) Muestra los 10 clientes con mayor valor de id:

SELECT "customer_id", "first_name", "last_name"
FROM CUSTOMER C
ORDER BY "customer_id" DESC
LIMIT 10;

---C: Los 10 clientes con mayor ID van del 590 al 599.

-- 17) Encuentra el nombre y apellido de los actores que aparecen en la película con título ‘Egg Igby’:

SELECT A.FIRST_NAME , A.LAST_NAME, F.TITLE   
FROM  ACTOR A 
JOIN FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM F ON F.FILM_ID = FA.FILM_ID
WHERE F.TITLE = 'EGG IGBY';

---C: Hay 5 actores y actrices que aparecen en la película "EGG IGBY".

-- 18) Selecciona todos los nombres de las películas únicos:

SELECT DISTINCT "title" -- aplicamos Distinct para eliminar duplicados 
FROM FILM F ;

---C: Hay 1.000 películas únicas.

-- 19) Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la tabla “film”:

SELECT F.TITLE, F.LENGTH, C."name" 
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Comedy' AND F.LENGTH > 180;

---C: Hay 3 películas de comedia que duran más de 180 minutos.

-- 20) Encuentra las categorías de películas que tienen un promedio de duración superior a 110 minutos y muestra el nombre de la categoría junto con el promedio de duración:

SELECT
	C."name" AS Categoria,
	ROUND (AVG (F.LENGTH) ,1) AS Promedio_duracion
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
GROUP BY C."name"
HAVING AVG (F.LENGTH ) > 110
ORDER BY Promedio_duracion DESC;

---C: Las pelis de la categoría Sports son las más largas en promedio mientras que las más cortas son las de Animation.

-- 21) ¿Cuál es la media de duración del alquiler de las películas?

SELECT AVG (R.RETURN_DATE - R.RENTAL_DATE ) AS media_duracion_alquiler
FROM RENTAL R ;

---C: La media de duración del alquiler de las películas es de 4 días.

-- 22) Crea una columna con el nombre y apellidos de todos los actores y actrices:

SELECT CONCAT ("first_name",' ', "last_name") AS nombre_completo
FROM ACTOR A ;

---C: Hay registrados 200 actores y actrices.

-- 23) Números de alquiler por día, ordenados por cantidad de alquiler de forma descendente:

SELECT 
	DATE (R.RENTAL_DATE) AS fecha,
	COUNT (R.RENTAL_ID) AS numero_alquileres
FROM RENTAL R
GROUP BY DATE (R.RENTAL_DATE )
ORDER BY numero_alquileres DESC;

---C: Del total de fechas, observamos que los meses de verano (julio y agosto) son los que tienen más volumen de alquileres.

-- 24) Encuentra las películas con una duración superior al promedio:

WITH promedio AS (
	SELECT AVG (F.LENGTH) AS media_duracion
	FROM FILM F)	
SELECT "film_id", "title", "length"
FROM FILM F , promedio 
WHERE F.LENGTH > MEDIA_DURACION ;

SELECT ROUND (AVG (F.LENGTH),1)
	FROM FILM F;

---C: Del total de 1.00 películas, 489 tienen una duración superior al promedio (115,3).

-- 25) Averigua el número de alquileres registrados por mes:

SELECT 
	EXTRACT (YEAR FROM "rental_date") AS año,
	EXTRACT (MONTH FROM "rental_date") AS mes,
	COUNT (R.RENTAL_ID) AS numero_alquileres
FROM RENTAL R
GROUP BY año, mes
ORDER BY año, mes;

SELECT COUNT  ("rental_id")
FROM RENTAL R ;

---C: Del total de alquileres (16.044) 1.156 son de Mayo (7%), 2.311 de Junio (14%), 6.709 de Julio (42%), 5.686 de Agosto (35%) del año 2005.
---De 2006, hay 182 alquileres en Febrero (1%).

-- 26) Encuentra el promedio, la desviación estándar y varianza del total pagado:

SELECT
	ROUND (AVG("amount"),2) AS promedio,
	ROUND (STDDEV ("amount"),2) AS desviacion_estandar,
	ROUND (VARIANCE("amount"), 2) AS varianza
FROM PAYMENT P ;

---C: El promedio del total pagado es de 4,2, la desviación estándar del 2,36 (la mayoría pagos se encuentran entre 1,84 y 6,56) y la varianza del 5,58 (variabilidad moderada).

-- 27) ¿Qué películas se alquilan por encima del precio medio?

WITH promedio AS (
	SELECT AVG ("rental_rate") AS media_precio
	FROM FILM F )	
SELECT "film_id", "title", "rental_rate"
FROM FILM F , promedio 
WHERE F.RENTAL_RATE  > media_precio ;

SELECT ROUND (AVG("rental_rate"),2) AS promedio_precio
FROM FILM F ;

---C: Hay 659 películas que se alquilan por encima del precio promedio (2,98).

-- 28) Muestra el id de los actores que hayan participado en más de 40 películas:

SELECT
	"actor_id" AS actores,
	COUNT ("film_id") AS numero_peliculas
FROM FILM_ACTOR FA
GROUP BY FA.ACTOR_ID 
HAVING COUNT ("film_id") > 40
ORDER BY numero_peliculas DESC;

---C: Hay solo 2 actores que tienen más de 40 películas.

-- 29) Obtener todas las películas y, si están disponibles en el inventario, mostrar la cantidad disponible:

SELECT
	F.FILM_ID,
	F.TITLE,
	COUNT ("inventory_id") AS cantidad_disponible
FROM FILM F
LEFT JOIN INVENTORY I 
ON F.FILM_ID = I.FILM_ID
GROUP BY F.FILM_ID , F.TITLE 
ORDER BY CANTIDAD_DISPONIBLE DESC;

---C: Se observa la cantidad disponible en inventario de cada película.

-- 30) Obtener los actores y el número de películas en las que ha actuado:

SELECT
	A.ACTOR_ID,
	A.FIRST_NAME ,
	A.LAST_NAME ,
	COUNT ("film_id") AS cantidad_peliculas
FROM ACTOR A 
LEFT JOIN FILM_ACTOR FA   
ON A.ACTOR_ID = FA.ACTOR_ID 
GROUP BY A.ACTOR_ID, A.FIRST_NAME , A.LAST_NAME 
ORDER BY cantidad_peliculas DESC;

---C: Gina Degeneres es la actriz con más películas (40), la que menos es Emily Dee con 14 películas.

-- 31) Obtener todas las películas y mostrar los actores que han actuado en ellas, incluso si algunas películas no tienen actores asociados:

SELECT
    f.film_id,
    f.title,
    a.actor_id,
    a.first_name,
    a.last_name
FROM film f
LEFT JOIN film_actor fa 
ON f.film_id = fa.film_id
LEFT JOIN actor a
ON fa.actor_id = a.actor_id
ORDER BY f.film_id, a.actor_id;

---C: Hacemos dos joins para poder asociar los actores y actrices a cada película.

-- 32) Obtener todos los actores y mostrar las películas en las que han actuado, incluso si algunos actores no han actuado en ninguna película:

SELECT
    concat (A2.FIRST_NAME, ' ' , A2.LAST_NAME) AS nombre_completo,
    A2.ACTOR_ID,
    F.FILM_ID,
    F.TITLE 
FROM ACTOR A2 
LEFT JOIN FILM_ACTOR FA 
ON A2.ACTOR_ID = FA.ACTOR_ID 
LEFT JOIN FILM F 
ON F.FILM_ID = FA.FILM_ID 
ORDER BY A2.ACTOR_ID;

---C: Hacemos dos joins para mostrar todos los actores y las películas en las que han actuado.

-- 33) Obtener todas las películas que tenemos y todos los registros de alquiler:

SELECT F.FILM_ID , F.TITLE , I.INVENTORY_ID , R.RENTAL_ID , R.RENTAL_DATE , R.RETURN_DATE 
FROM FILM F 
LEFT JOIN INVENTORY I
ON F.FILM_ID = I.FILM_ID
LEFT JOIN RENTAL R 
ON I.INVENTORY_ID = R.INVENTORY_ID
ORDER BY F.FILM_ID , R.RENTAL_DATE ; 

---C: Así aparecen todas las películas aunque no tengan inventario o no se hayan alquilado. 

-- 34) Encuentra los 5 clientes que más dinero se hayan gastado con nosotros:

SELECT
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS clientes,
	ROUND (SUM (P.AMOUNT), 1) AS total_gastado
FROM PAYMENT P
JOIN CUSTOMER C ON P.CUSTOMER_ID = C.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID , C.FIRST_NAME , C.LAST_NAME 
ORDER BY total_gastado DESC 
LIMIT 5;

---C: Los 5 clientes que más gastan son Karl Seal (221,6), Eleanor Hunt (216,5), Clara Shaw (195,6), Rhonda Kennedy (194,6) y Marion Synder (194,6).

-- 35) Selecciona todos los actores cuyo primer nombre es ' Johnny':

SELECT A.ACTOR_ID , A.FIRST_NAME, A.LAST_NAME 
FROM ACTOR A
WHERE A.FIRST_NAME = 'JOHNNY'; 

---C: Solo hay 2 actores que se llaman Johnny (Lollobrigida y Cage). Vigilar las mayúsculas/minúsculas en WHERE. 

-- 36) Renombra la columna “first_name” como Nombre y “last_name” como Apellido:

SELECT
	A.FIRST_NAME AS Nombre,
	A.LAST_NAME AS Apellido
FROM ACTOR A;

---C: Salen las columnas renombradas como Nombre y Apellido.

-- 37) Encuentra el ID del actor más bajo y más alto en la tabla actor:

SELECT
	MAX (A.ACTOR_ID) AS ID_mas_alta,
	MIN (A.ACTOR_ID) AS ID_mas_baja
FROM ACTOR A;

---C: La ID de actor más alta es 200 y la más baja 1.

-- 38) Cuenta cuántos actores hay en la tabla “actor”:

SELECT COUNT (A.ACTOR_ID)
FROM ACTOR A;

---C: En total hay 200 actores. (Como actor_id es Primary Key nunca es NULL y cuenta todos los actores de la tabla).

-- 39) Selecciona todos los actores y ordénalos por apellido en orden Ascendente:

SELECT A.ACTOR_ID, A.FIRST_NAME , A.LAST_NAME 
FROM ACTOR A 
ORDER BY A.LAST_NAME ASC;

---C: El primer apellido en orden ascendente es Akroyd y el último Zellweger.

-- 40) Selecciona las primeras 5 películas de la tabla “film”:

SELECT F.FILM_ID , F.TITLE 
FROM FILM F
LIMIT 5;

---C: Las 5 primeras películas son Academy dinosaur, Ace Goldfinger, Adaptation Holes, Affair Prejudice, African Egg.

-- 41) Agrupa los actores por su nombre y cuenta cuántos actores tienen el mismo nombre. ¿Cuál es el nombre más repetido?

SELECT
	A.FIRST_NAME AS nombre,
	COUNT (A.FIRST_NAME) AS cantidad
FROM ACTOR A
GROUP BY A.FIRST_NAME
ORDER BY cantidad DESC; 

---C: Los nombres más repetidos (4 veces) son Kenneth, Penelope y Julia.

-- 42) Encuentra todos los alquileres y los nombres de los clientes que los realizaron:

SELECT
	R.RENTAL_ID,
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS Nombre_clientes
FROM RENTAL R 
JOIN CUSTOMER C
ON C.CUSTOMER_ID = R.CUSTOMER_ID;

---C: Aparecen todos los alquileres (por ID) y los nombres de los clientes que corresponde a cada alquiler.

-- 43) Muestra todos los clientes y sus alquileres si existen, incluyendo aquellos que no tienen alquileres:

SELECT
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS Nombre_clientes,
	COUNT (R.RENTAL_ID) AS Numero_alquileres
FROM CUSTOMER C 
LEFT JOIN RENTAL R ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID, Nombre_clientes
ORDER BY Numero_alquileres DESC;

---C: Hacemos un LEFT JOIN para mostrar todos los clientes, independientemente de si tienen alquileres o no.
---Eleanor Hunt es la que más tiene con 46 alquileres y el que menos Brian Wyman con 12.

-- 44) Realiza un CROSS JOIN entre las tablas film y category. ¿Aporta valor esta consulta? ¿Por qué? Deja después de la consulta la contestación.

SELECT *
FROM FILM F
CROSS JOIN CATEGORY C;

---C: En mi opinión, no aporta valor porque se generan muchas combinaciones (+2.800 filas) aunque no tengan una relación entre sí. 
---Sería mejor hacer un JOIN con film_category.

-- 45) Encuentra los actores que han participado en películas de la categoría 'Action':

SELECT DISTINCT
	A.ACTOR_ID,
	CONCAT (A.FIRST_NAME, ' ', A.LAST_NAME) AS nombre_actor,
	C."name" AS categoria
FROM ACTOR A 
JOIN FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM F ON FA.FILM_ID = F.FILM_ID
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Action'
ORDER BY nombre_actor;

---C: Hay 166 actores y actrices que han participado en peículas de Acción.

-- 46) Encuentra todos los actores que no han participado en películas:

SELECT
	FA.ACTOR_ID,
	CONCAT (A.FIRST_NAME , ' ', A.LAST_NAME) AS nombre_actores,
	FA.FILM_ID 
FROM FILM_ACTOR FA
LEFT JOIN ACTOR A
ON FA.ACTOR_ID = A.ACTOR_ID
WHERE FA.FILM_ID IS NULL
ORDER BY A.ACTOR_ID;

SELECT *
FROM FILM_ACTOR FA;

---C: Todos los actores y actrices han participado en al menos una película ya que no hay NULLS.

-- 47) Selecciona el nombre de los actores y la cantidad de películas en las que han participado:

SELECT
	A2.ACTOR_ID  ,
	CONCAT (A2.FIRST_NAME  , ' ', A2.LAST_NAME ) AS nombre_actores,
	COUNT(FA.FILM_ID) AS cantidad_peliculas 
FROM ACTOR A2  
LEFT JOIN FILM_ACTOR FA 
ON A2.ACTOR_ID = FA.ACTOR_ID
GROUP BY A2.ACTOR_ID
ORDER BY cantidad_peliculas DESC;

---C: La actriz Gina Degeneres es la que más películas ha participado con un total de 42 y Emily Lee la que menos con 14 películas.

-- 48) Crea una vista llamada “actor_num_peliculas” que muestre los nombres de los actores y el número de películas en las que han participado:

CREATE VIEW actor_num_peliculas AS 
SELECT
	A2.ACTOR_ID  ,
	CONCAT (A2.FIRST_NAME  , ' ', A2.LAST_NAME ) AS nombre_actores,
	COUNT(FA.FILM_ID) AS cantidad_peliculas 
FROM ACTOR A2  
LEFT JOIN FILM_ACTOR FA 
ON A2.ACTOR_ID = FA.ACTOR_ID
GROUP BY A2.ACTOR_ID
ORDER BY cantidad_peliculas DESC;

---Comprobación:
SELECT *
FROM ACTOR_NUM_PELICULAS ANP;

-- 49) Calcula el número total de alquileres realizados por cada cliente:

SELECT
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS nombre_cliente,
	COUNT (R.RENTAL_ID) AS total_alquileres
FROM CUSTOMER C 
LEFT JOIN RENTAL R 
ON C.CUSTOMER_ID = R.CUSTOMER_ID 
GROUP BY C.CUSTOMER_ID
ORDER BY total_alquileres DESC;

---C:Eleanor Hunt es la que más alquileres tiene con un total de 46. El que menos Brian Wyman con 12.

-- 50) Calcula la duración total de las películas en la categoría 'Action':

SELECT
	C."name" AS categoria,
	SUM (F.LENGTH) AS duracion_total
FROM FILM F
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON C.CATEGORY_ID = FC.CATEGORY_ID 
WHERE C."name" = 'Action'
GROUP BY C."name"
ORDER BY duracion_total;

---C:La duración total de las películas de Acción es de 7.143 minutos.

-- 51) Crea una tabla temporal llamada “cliente_rentas_temporal” para almacenar el total de alquileres por cliente:

CREATE TEMPORARY TABLE clientes_rentas_temporal AS
SELECT
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS nombre_cliente,
	COUNT (R.RENTAL_ID) AS total_alquileres
FROM CUSTOMER C 
LEFT JOIN RENTAL R 
ON C.CUSTOMER_ID = R.CUSTOMER_ID 
GROUP BY C.CUSTOMER_ID;

---Comprobación:
SELECT *
FROM clientes_rentas_temporal
ORDER BY total_alquileres DESC;

-- 52) Crea una tabla temporal llamada “peliculas_alquiladas” que almacene las películas que han sido alquiladas al menos 10 veces:

CREATE TEMPORARY TABLE peliculas_alquiladas AS
SELECT
	F.FILM_ID,
	F.TITLE,
	COUNT (R.RENTAL_ID) AS total_alquileres
FROM FILM F
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY F.FILM_ID, F.TITLE 
HAVING COUNT (R.RENTAL_ID) >= 10;

---Comprobación:
SELECT *
FROM peliculas_alquiladas
ORDER BY total_alquileres DESC;

-- 53) Encuentra el título de las películas que han sido alquiladas por el cliente con el nombre ‘Tammy Sanders’ y que aún no se han devuelto. Ordena los resultados alfabéticamente por título de película:

SELECT
	F.TITLE AS peliculas,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS clientes,
	R.RETURN_DATE 
FROM CUSTOMER C 
JOIN RENTAL R ON C.CUSTOMER_ID = R.CUSTOMER_ID 
JOIN INVENTORY I ON I.INVENTORY_ID = R.INVENTORY_ID 
JOIN FILM F ON F.FILM_ID = I.FILM_ID 
WHERE C.FIRST_NAME = 'TAMMY'
	AND C.LAST_NAME = 'SANDERS'
	AND R.RETURN_DATE IS NULL
ORDER BY F.TITLE ASC;

---C:Tammy sander no ha devuelto 3 películas que tiene alquiladas (Lust Lock, Sleepy Japanese y Trouble Date).
---Si return_date es NULL consideramos que las pelis no se han devuelto.

-- 54) Encuentra los nombres de los actores que han actuado en al menos una película que pertenece a la categoría ‘Sci-Fi’. Ordena los resultados alfabéticamente por apellido:

SELECT DISTINCT --distinct para que solo me devuelva el mismo nombre y apellido una sola vez
	A.ACTOR_ID,
	A.FIRST_NAME,
	A.LAST_NAME,
	C."name" 
FROM ACTOR A 
JOIN FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM F ON FA.FILM_ID = F.FILM_ID
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Sci-Fi' --garantiza el al menos 1
ORDER BY A.LAST_NAME ASC, A.FIRST_NAME ASC;

---C:Hay 167 actores y actrices que han actuado en al menos una película de Sci-Fi.

-- 55) Encuentra el nombre y apellido de los actores que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’ se alquilara por primera vez. Ordena los resultados alfabéticamente por apellido:

WITH primera_vez_spartacus AS (
	SELECT MIN (R.RENTAL_DATE) AS primer_alquiler
	FROM FILM F
	JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID 
	JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
	WHERE F.TITLE = 'SPARTACUS CHEAPER'
	)
SELECT DISTINCT
	A.FIRST_NAME,
	A.LAST_NAME 
FROM ACTOR A 
JOIN FILM_ACTOR FA ON A.ACTOR_ID = FA.ACTOR_ID
JOIN FILM F ON FA.FILM_ID = F.FILM_ID
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
CROSS JOIN primera_vez_spartacus
WHERE R.RENTAL_DATE > primer_alquiler
ORDER BY A.LAST_NAME ASC, A.FIRST_NAME ASC;

---C:Hay 199 actores y actrices que han actuado en películas que se alquilaron después de que la película ‘Spartacus Cheaper’.

-- 56) Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría ‘Music’:

SELECT
	A.ACTOR_ID,
	CONCAT (A.FIRST_NAME , ' ', A.LAST_NAME),
FROM ACTOR A 
WHERE NOT EXISTS ( ---excluye solo a quienes sí han hecho peli categoría Music.
	SELECT 1
	FROM FILM_ACTOR FA 
	JOIN FILM F ON FA.FILM_ID = F.FILM_ID
	JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
	JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
	WHERE FA.ACTOR_ID = A.ACTOR_ID 
	AND C."name" = 'Music'
	)
ORDER BY A.LAST_NAME ASC, A.FIRST_NAME ASC;
	
---C:Hay 56 actores y actrices que no han hecho ninguna película de la categoría 'Music'.

-- 57) Encuentra el título de todas las películas que fueron alquiladas por más de 8 días:

SELECT
	F.TITLE,
	R.RENTAL_DATE,
	R.RETURN_DATE,
	(R.RETURN_DATE::DATE - R.RENTAL_DATE::DATE) AS dias_alquilados ---Ponemos ::DATE para poder trabajar con días, sino da error.
FROM FILM F
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID 
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID 
WHERE R.RETURN_DATE IS NOT NULL
AND (R.RETURN_DATE::DATE - R.RENTAL_DATE::DATE ) > 8
ORDER BY dias_alquilados DESC;

---C:Hay 1.795 películas que fueron alquiladas por más de 8 días. 

-- 58) Encuentra el título de todas las películas que son de la misma categoría que ‘Animation’:

SELECT
	F.FILM_ID,
	F.TITLE,
	C."name" 
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE C."name" = 'Animation' 
ORDER BY F.TITLE;

---C:Hay 66 películas que son de la categoría Animation.

-- 59) Encuentra los nombres de las películas que tienen la misma duración que la película con el título ‘Dancing Fever’. Ordena los resultados alfabéticamente por título de película:

SELECT
	F.FILM_ID,
	F.TITLE,
	F.LENGTH 
FROM FILM F 
WHERE F.LENGTH IN (
	SELECT DISTINCT F2.LENGTH 
	FROM FILM F2  
	WHERE F2.TITLE = 'DANCING FEVER'
)
ORDER BY F.TITLE;

---Comprobación:
SELECT
    film_id,
    title,
    length
FROM film
WHERE length = 144
ORDER BY title;

---C:Hay 7 películas más que tienen la misma duración que 'Dancing Fever', que es de 144 minutos.
---Observación: En la consulta se deben usar alias distintos (f fuera de la subconsulta y f2 dentro) porque cada alias solo es válido en su propio nivel.

-- 60) Encuentra los nombres de los clientes que han alquilado al menos 7 películas distintas. Ordena los resultados alfabéticamente por apellido:

SELECT
	C.CUSTOMER_ID,
	CONCAT (C.FIRST_NAME , ' ', C.LAST_NAME) AS nombre_cliente,
	COUNT (DISTINCT F.FILM_ID) AS peliculas_distintas
FROM CUSTOMER C
JOIN RENTAL R ON C.CUSTOMER_ID = R.CUSTOMER_ID
JOIN INVENTORY I ON R.INVENTORY_ID = I.INVENTORY_ID
JOIN FILM F ON I.FILM_ID = F.FILM_ID
GROUP BY C.CUSTOMER_ID, NOMBRE_CLIENTE 
HAVING COUNT (DISTINCT F.FILM_ID) >= 7
ORDER BY C.LAST_NAME ASC, C.FIRST_NAME ASC;

---C:Hay 599 clientes que han alquilado al menos 7 películas distintas.

-- 61) Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el recuento de alquileres:

SELECT
	C."name" AS categoria,
	COUNT (R.RENTAL_ID) AS total_alquileres
FROM CATEGORY C 
JOIN FILM_CATEGORY FC ON C.CATEGORY_ID = FC.CATEGORY_ID 
JOIN FILM F ON FC.FILM_ID = F.FILM_ID
JOIN INVENTORY I ON F.FILM_ID = I.FILM_ID
JOIN RENTAL R ON I.INVENTORY_ID = R.INVENTORY_ID
GROUP BY C."name" 
ORDER BY total_alquileres DESC;

---C:Hay 16 categorías de películas, las más alquiladas son las de Sports y las menos alquiladas las de Music.

-- 62) Encuentra el número de películas por categoría estrenadas en 2006:

SELECT
	C."name" AS categoria,
	COUNT (F.FILM_ID) AS total_peliculas_2006
FROM FILM F 
JOIN FILM_CATEGORY FC ON F.FILM_ID = FC.FILM_ID
JOIN CATEGORY C ON FC.CATEGORY_ID = C.CATEGORY_ID
WHERE F.RELEASE_YEAR = 2006
GROUP BY C."name" 
ORDER BY total_peliculas_2006 DESC;

---C:En 2006, la categoría con mayor producción fue Sports (74), mientras que la menos representada fue Music (51).

-- 63) Obtén todas las combinaciones posibles de trabajadores con las tiendas que tenemos:

SELECT
	S.STAFF_ID,
	S.FIRST_NAME,
	S.LAST_NAME,
	S.STORE_ID,
	S.ADDRESS_ID 
FROM STAFF S 
CROSS JOIN STORE S2   ---Cross Join (producto cartesiano) para tener todas las combinaciones posibles
ORDER BY S.STAFF_ID , S.STORE_ID;

-- 64) Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y apellido junto con la cantidad de películas alquiladas:

SELECT
	C.CUSTOMER_ID AS ID_cliente,
	CONCAT (C.FIRST_NAME  , ' ', C.LAST_NAME) AS nombre_cliente,
	COUNT (R.RENTAL_ID) AS total_peliculas_alquiladas
FROM CUSTOMER C 
LEFT JOIN RENTAL R ON C.CUSTOMER_ID = R.CUSTOMER_ID
GROUP BY C.CUSTOMER_ID , NOMBRE_CLIENTE 
ORDER BY total_peliculas_alquiladas DESC;

---C:Eleanor Hunt (ID 48) es la que más películas ha alquilado (46) y Brian Wyman (ID 318) el que menos (12).



