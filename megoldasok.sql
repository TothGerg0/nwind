/*Elsõ feladatsor*/

/*1.	Mely rendelések nincsenek kiszállítva?*/
SELECT
  *
FROM rendelések
WHERE rendelések.`Szállítás dátuma` IS NULL;

/*2.	Határidõ után kiszállított rendelések?*/
SELECT
  *
FROM rendelések
WHERE rendelések.Határidõ < rendelések.`Szállítás dátuma`;

/*3.	Listázza ki az 1000 Ft-nál olcsóbb italokat!*/
  SELECT
  *
FROM termékek
  INNER JOIN kategóriák
    ON termékek.Kategóriakód = kategóriák.Kategóriakód
  WHERE kategóriák.Kategóriakód = 1 AND Egységár < 1000;

/*4.	Paraméterben megadott év rendelései?*/
  SELECT
  YEAR(rendelések.`Rendelés dátuma`),
  COUNT(rendelések.Rendeléskód)
FROM rendelések
  GROUP BY year(`Rendelés dátuma`);

/*5.	A Vevõ (Cégnév) 3. vagy negyedik betûje „R”-betû.*/
SELECT
  *
FROM vevõk
  WHERE Cégnév LIKE '__r%' OR Cégnév LIKE '___r%';

/*6.	Határozzuk meg a kategóriánkénti kifutott termékek számát és átlagos egységárát!*/
SELECT termékek.Kategóriakód, COUNT(Kifutott), AVG(Egységár)

FROM termékek
  GROUP BY Kategóriakód;

/*7.	Határozza meg országonként és városonként a vevõk számát!*/
SELECT Ország, Város, COUNT(Vevõkód)
FROM rendelések
  GROUP BY Ország, Város;


/*8.	Listázza ki csökkenõ sorrendben azt a 10 vevõt, akik a legtöbb pénzt hagyták a kasszában?*/
SELECT Vevõkód, SUM(Egységár*Mennyiség) AS Pénz

FROM `rendelés részletei`
  INNER JOIN rendelések
    ON `rendelés részletei`.Rendeléskód = rendelések.Rendeléskód
  GROUP BY Vevõkód
  ORDER BY Pénz DESC
  LIMIT 10;

/*9.	Határozza meg az évenkénti rendelések számát!*/
SELECT
  YEAR(rendelések.`Rendelés dátuma`),
  COUNT(rendelések.Rendeléskód)
FROM rendelések
  GROUP BY year(`Rendelés dátuma`);

/*10.	Határozza meg az évenként eladott termékek számát!*/
SELECT YEAR(`Szállítás dátuma`), SUM(Mennyiség)

FROM `rendelés részletei`
  INNER JOIN rendelések
    ON `rendelés részletei`.Rendeléskód = rendelések.Rendeléskód
  WHERE `Szállítás dátuma` IS NOT NULL 
  GROUP BY YEAR(`Szállítás dátuma`);

/*11.	Üzletkötõnként határozza meg az összes engedmény értékét!*/
SELECT Megszólítás, Vezetéknév, Keresztnév, Beosztás, SUM(Egységár*Mennyiség*(1-Engedmény))

FROM `rendelés részletei`
  INNER JOIN rendelések
    ON `rendelés részletei`.Rendeléskód = rendelések.Rendeléskód
  INNER JOIN alkalmazottak
    ON rendelések.Alkalmazottkód = alkalmazottak.Alkalmazottkód
  WHERE Beosztás LIKE 'Üzletkötõ'
GROUP BY rendelések.Alkalmazottkód;

/*12.	Az üzletkötõk hányszor adtak engedményt?*/
  SELECT Megszólítás, Vezetéknév, Keresztnév, Beosztás, count(Engedmény)

FROM `rendelés részletei`
  INNER JOIN rendelések
    ON `rendelés részletei`.Rendeléskód = rendelések.Rendeléskód
  INNER JOIN alkalmazottak
    ON rendelések.Alkalmazottkód = alkalmazottak.Alkalmazottkód
  WHERE Beosztás LIKE 'Üzletkötõ' AND Engedmény IS NOT NULL 
GROUP BY rendelések.Alkalmazottkód;

/*13.	 Tíznél több terméket tartalmazó kategóriákban hány termék szerepel.*/
SELECT Kategórianév, COUNT(termékek.Kategóriakód)

FROM termékek
  INNER JOIN kategóriák
    ON termékek.Kategóriakód = kategóriák.Kategóriakód
  GROUP BY Kategórianév
  HAVING COUNT(termékek.Kategóriakód) > 10;

/*14.	A Fizetés mezõben azon üzletkötõk jövedelme, akiké meghaladja az "Igazgató" vagy "Alelnök"
  címmel rendelkezõ minden alkalmazottét.*/


/*15.	A Rendelésösszeg: [Egységár] * [Mennyiség] számított mezõben az átlagos rendelésértéknél nagyobb összegû rendelések.*/
SELECT rendelések.Rendeléskód, SUM(Egységár*Mennyiség)

FROM `rendelés részletei`
  INNER JOIN rendelések
    ON `rendelés részletei`.Rendeléskód = rendelések.Rendeléskód
GROUP BY rendelések.Rendeléskód;

/*16.	Az Egységár mezõ azon termékei, amelyek egységára megegyezik az ánizsmagszörpével.*/
SELECT Termékkód, Terméknév

  FROM termékek
  WHERE Egységár=(SELECT Egységár

  FROM termékek 
  WHERE Terméknév ='Aniseed Syrup');

/*17.	Kik azok az üzletkötõk, akik az igazgatóknál és az alelnököknél is idõsebbek?*/




/*Második feladatsor*/

  /*1.	Add meg a kifutott termékek nevét és szállítóját!*/

  SELECT Terméknév, Cégnév
FROM termékek
  INNER JOIN szállítók
    ON termékek.Szállítókód = szállítók.Szállítókód
  WHERE Kifutott =1;

/*2.	Töröld az Alkalmazottak táblából a Gyakornok Beosztású rekordokat.*/
DELETE FROM alkalmazottak
  WHERE Beosztás = 'gyakornok';

/*3.	Add meg a B és az M betûvel kezdõdõ városokból szállított termékek nevét és egységárát.*/
SELECT Terméknév, Egységár
FROM termékek
  INNER JOIN szállítók
    ON termékek.Szállítókód = szállítók.Szállítókód
  WHERE Város LIKE 'b%' OR Város LIKE 'm%';

/*4.	Add meg a raktáron lévõ termékek átlagos egységárát.*/
  SELECT AVG(Egységár)
FROM termékek
 WHERE Raktáron > 0;

/*5.	Add meg a minimumkészlet alá csökkent nem kifutott termékek nevét és darabszámát terméknév szerinti sorrendben.*/

  SELECT Terméknév, Raktáron
FROM termékek
 WHERE Raktáron <= `Minimum készlet` AND Kifutott = 0
  ORDER BY Terméknév;

/*6.	Add meg a 10 legnagyobb raktári összértékkel rendelkezõ termék nevét, beszállítóját, értékszerinti csökkenõ sorrendben.*/
SELECT Terméknév, Cégnév
FROM termékek
  INNER JOIN szállítók
    ON termékek.Szállítókód = szállítók.Szállítókód
ORDER BY Egységár*Raktáron DESC
LIMIT 10;

/*7.	Add meg az 1995 elsõ félévében született rendelések megrendelésszámát, megrendelõjét és az alkalmazott nevét, 
  aki a megrendelést bonyolította.*/
SELECT Rendeléskód, Cégnév, Vezetéknév, Keresztnév
FROM rendelések
  INNER JOIN alkalmazottak
    ON rendelések.Alkalmazottkód = alkalmazottak.Alkalmazottkód
  INNER JOIN vevõk
    ON rendelések.Vevõkód = vevõk.Vevõkód
WHERE `Rendelés dátuma` <= '1995-06-31' AND `Rendelés dátuma`>= '1995-01-01';

/*8.	Add meg annak a 3 alkalmazottnak a nevét, akik 1995-ben a legkevesebb rendeléseket bonyolította.*/
SELECT COUNT(rendelések.Alkalmazottkód), Vezetéknév, Keresztnév
FROM rendelések
  INNER JOIN alkalmazottak
    ON rendelések.Alkalmazottkód = alkalmazottak.Alkalmazottkód
  INNER JOIN vevõk
    ON rendelések.Vevõkód = vevõk.Vevõkód
WHERE `Rendelés dátuma` <= '1995-12-31' AND `Rendelés dátuma`>= '1995-01-01'
  GROUP BY alkalmazottak.Alkalmazottkód
  ORDER BY COUNT(rendelések.Alkalmazottkód) ASC
  LIMIT 3;

/*9.	A következõ példa minden olyan rekord Felettes mezõjét 5-re állítja, amelynek jelenleg 2 az értéke.*/
UPDATE alkalmazottak
SET Felettes = 5
WHERE Felettes = 2;

/*10.	A következõ példa minden olyan termék egységárát megnöveli 10 százalékkal, amely a 8. számú szállítótól származik, 
  és amelybõl van raktáron.*/
UPDATE termékek
SET Egységár = Egységár*1.1
WHERE Szállítókód = 8 AND Raktáron > 0;

/*11.	A következõ példa minden olyan termék egységárát csökkenti 10 százalékkal, amely a Tokyo Traders nevû szállítótól 
  származik, és amelybõl van raktáron.*/ 
UPDATE termékek
SET Egységár = Egységár*0.9
WHERE Szállítókód = 4 AND Raktáron > 0;

/*12.	Add meg a termékek kategóriánkénti átlagos egységárát!*/
SELECT Kategórianév, AVG(Egységár)
FROM termékek
  INNER JOIN kategóriák
    ON termékek.Kategóriakód = kategóriák.Kategóriakód
  GROUP BY kategóriák.Kategóriakód;