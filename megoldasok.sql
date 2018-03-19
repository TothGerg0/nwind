/*Els� feladatsor*/

/*1.	Mely rendel�sek nincsenek kisz�ll�tva?*/
SELECT
  *
FROM rendel�sek
WHERE rendel�sek.`Sz�ll�t�s d�tuma` IS NULL;

/*2.	Hat�rid� ut�n kisz�ll�tott rendel�sek?*/
SELECT
  *
FROM rendel�sek
WHERE rendel�sek.Hat�rid� < rendel�sek.`Sz�ll�t�s d�tuma`;

/*3.	List�zza ki az 1000 Ft-n�l olcs�bb italokat!*/
  SELECT
  *
FROM term�kek
  INNER JOIN kateg�ri�k
    ON term�kek.Kateg�riak�d = kateg�ri�k.Kateg�riak�d
  WHERE kateg�ri�k.Kateg�riak�d = 1 AND Egys�g�r < 1000;

/*4.	Param�terben megadott �v rendel�sei?*/
  SELECT
  YEAR(rendel�sek.`Rendel�s d�tuma`),
  COUNT(rendel�sek.Rendel�sk�d)
FROM rendel�sek
  GROUP BY year(`Rendel�s d�tuma`);

/*5.	A Vev� (C�gn�v) 3. vagy negyedik bet�je �R�-bet�.*/
SELECT
  *
FROM vev�k
  WHERE C�gn�v LIKE '__r%' OR C�gn�v LIKE '___r%';

/*6.	Hat�rozzuk meg a kateg�ri�nk�nti kifutott term�kek sz�m�t �s �tlagos egys�g�r�t!*/
SELECT term�kek.Kateg�riak�d, COUNT(Kifutott), AVG(Egys�g�r)

FROM term�kek
  GROUP BY Kateg�riak�d;

/*7.	Hat�rozza meg orsz�gonk�nt �s v�rosonk�nt a vev�k sz�m�t!*/
SELECT Orsz�g, V�ros, COUNT(Vev�k�d)
FROM rendel�sek
  GROUP BY Orsz�g, V�ros;


/*8.	List�zza ki cs�kken� sorrendben azt a 10 vev�t, akik a legt�bb p�nzt hagyt�k a kassz�ban?*/
SELECT Vev�k�d, SUM(Egys�g�r*Mennyis�g) AS P�nz

FROM `rendel�s r�szletei`
  INNER JOIN rendel�sek
    ON `rendel�s r�szletei`.Rendel�sk�d = rendel�sek.Rendel�sk�d
  GROUP BY Vev�k�d
  ORDER BY P�nz DESC
  LIMIT 10;

/*9.	Hat�rozza meg az �venk�nti rendel�sek sz�m�t!*/
SELECT
  YEAR(rendel�sek.`Rendel�s d�tuma`),
  COUNT(rendel�sek.Rendel�sk�d)
FROM rendel�sek
  GROUP BY year(`Rendel�s d�tuma`);

/*10.	Hat�rozza meg az �venk�nt eladott term�kek sz�m�t!*/
SELECT YEAR(`Sz�ll�t�s d�tuma`), SUM(Mennyis�g)

FROM `rendel�s r�szletei`
  INNER JOIN rendel�sek
    ON `rendel�s r�szletei`.Rendel�sk�d = rendel�sek.Rendel�sk�d
  WHERE `Sz�ll�t�s d�tuma` IS NOT NULL 
  GROUP BY YEAR(`Sz�ll�t�s d�tuma`);

/*11.	�zletk�t�nk�nt hat�rozza meg az �sszes engedm�ny �rt�k�t!*/
SELECT Megsz�l�t�s, Vezet�kn�v, Keresztn�v, Beoszt�s, SUM(Egys�g�r*Mennyis�g*(1-Engedm�ny))

FROM `rendel�s r�szletei`
  INNER JOIN rendel�sek
    ON `rendel�s r�szletei`.Rendel�sk�d = rendel�sek.Rendel�sk�d
  INNER JOIN alkalmazottak
    ON rendel�sek.Alkalmazottk�d = alkalmazottak.Alkalmazottk�d
  WHERE Beoszt�s LIKE '�zletk�t�'
GROUP BY rendel�sek.Alkalmazottk�d;

/*12.	Az �zletk�t�k h�nyszor adtak engedm�nyt?*/
  SELECT Megsz�l�t�s, Vezet�kn�v, Keresztn�v, Beoszt�s, count(Engedm�ny)

FROM `rendel�s r�szletei`
  INNER JOIN rendel�sek
    ON `rendel�s r�szletei`.Rendel�sk�d = rendel�sek.Rendel�sk�d
  INNER JOIN alkalmazottak
    ON rendel�sek.Alkalmazottk�d = alkalmazottak.Alkalmazottk�d
  WHERE Beoszt�s LIKE '�zletk�t�' AND Engedm�ny IS NOT NULL 
GROUP BY rendel�sek.Alkalmazottk�d;

/*13.	 T�zn�l t�bb term�ket tartalmaz� kateg�ri�kban h�ny term�k szerepel.*/
SELECT Kateg�rian�v, COUNT(term�kek.Kateg�riak�d)

FROM term�kek
  INNER JOIN kateg�ri�k
    ON term�kek.Kateg�riak�d = kateg�ri�k.Kateg�riak�d
  GROUP BY Kateg�rian�v
  HAVING COUNT(term�kek.Kateg�riak�d) > 10;

/*14.	A Fizet�s mez�ben azon �zletk�t�k j�vedelme, akik� meghaladja az "Igazgat�" vagy "Aleln�k"
  c�mmel rendelkez� minden alkalmazott�t.*/


/*15.	A Rendel�s�sszeg: [Egys�g�r] * [Mennyis�g] sz�m�tott mez�ben az �tlagos rendel�s�rt�kn�l nagyobb �sszeg� rendel�sek.*/
SELECT rendel�sek.Rendel�sk�d, SUM(Egys�g�r*Mennyis�g)

FROM `rendel�s r�szletei`
  INNER JOIN rendel�sek
    ON `rendel�s r�szletei`.Rendel�sk�d = rendel�sek.Rendel�sk�d
GROUP BY rendel�sek.Rendel�sk�d;

/*16.	Az Egys�g�r mez� azon term�kei, amelyek egys�g�ra megegyezik az �nizsmagsz�rp�vel.*/
SELECT Term�kk�d, Term�kn�v

  FROM term�kek
  WHERE Egys�g�r=(SELECT Egys�g�r

  FROM term�kek 
  WHERE Term�kn�v ='Aniseed Syrup');

/*17.	Kik azok az �zletk�t�k, akik az igazgat�kn�l �s az aleln�k�kn�l is id�sebbek?*/




/*M�sodik feladatsor*/

  /*1.	Add meg a kifutott term�kek nev�t �s sz�ll�t�j�t!*/

  SELECT Term�kn�v, C�gn�v
FROM term�kek
  INNER JOIN sz�ll�t�k
    ON term�kek.Sz�ll�t�k�d = sz�ll�t�k.Sz�ll�t�k�d
  WHERE Kifutott =1;

/*2.	T�r�ld az Alkalmazottak t�bl�b�l a Gyakornok Beoszt�s� rekordokat.*/
DELETE FROM alkalmazottak
  WHERE Beoszt�s = 'gyakornok';

/*3.	Add meg a B �s az M bet�vel kezd�d� v�rosokb�l sz�ll�tott term�kek nev�t �s egys�g�r�t.*/
SELECT Term�kn�v, Egys�g�r
FROM term�kek
  INNER JOIN sz�ll�t�k
    ON term�kek.Sz�ll�t�k�d = sz�ll�t�k.Sz�ll�t�k�d
  WHERE V�ros LIKE 'b%' OR V�ros LIKE 'm%';

/*4.	Add meg a rakt�ron l�v� term�kek �tlagos egys�g�r�t.*/
  SELECT AVG(Egys�g�r)
FROM term�kek
 WHERE Rakt�ron > 0;

/*5.	Add meg a minimumk�szlet al� cs�kkent nem kifutott term�kek nev�t �s darabsz�m�t term�kn�v szerinti sorrendben.*/

  SELECT Term�kn�v, Rakt�ron
FROM term�kek
 WHERE Rakt�ron <= `Minimum k�szlet` AND Kifutott = 0
  ORDER BY Term�kn�v;

/*6.	Add meg a 10 legnagyobb rakt�ri �ssz�rt�kkel rendelkez� term�k nev�t, besz�ll�t�j�t, �rt�kszerinti cs�kken� sorrendben.*/
SELECT Term�kn�v, C�gn�v
FROM term�kek
  INNER JOIN sz�ll�t�k
    ON term�kek.Sz�ll�t�k�d = sz�ll�t�k.Sz�ll�t�k�d
ORDER BY Egys�g�r*Rakt�ron DESC
LIMIT 10;

/*7.	Add meg az 1995 els� f�l�v�ben sz�letett rendel�sek megrendel�ssz�m�t, megrendel�j�t �s az alkalmazott nev�t, 
  aki a megrendel�st bonyol�totta.*/
SELECT Rendel�sk�d, C�gn�v, Vezet�kn�v, Keresztn�v
FROM rendel�sek
  INNER JOIN alkalmazottak
    ON rendel�sek.Alkalmazottk�d = alkalmazottak.Alkalmazottk�d
  INNER JOIN vev�k
    ON rendel�sek.Vev�k�d = vev�k.Vev�k�d
WHERE `Rendel�s d�tuma` <= '1995-06-31' AND `Rendel�s d�tuma`>= '1995-01-01';

/*8.	Add meg annak a 3 alkalmazottnak a nev�t, akik 1995-ben a legkevesebb rendel�seket bonyol�totta.*/
SELECT COUNT(rendel�sek.Alkalmazottk�d), Vezet�kn�v, Keresztn�v
FROM rendel�sek
  INNER JOIN alkalmazottak
    ON rendel�sek.Alkalmazottk�d = alkalmazottak.Alkalmazottk�d
  INNER JOIN vev�k
    ON rendel�sek.Vev�k�d = vev�k.Vev�k�d
WHERE `Rendel�s d�tuma` <= '1995-12-31' AND `Rendel�s d�tuma`>= '1995-01-01'
  GROUP BY alkalmazottak.Alkalmazottk�d
  ORDER BY COUNT(rendel�sek.Alkalmazottk�d) ASC
  LIMIT 3;

/*9.	A k�vetkez� p�lda minden olyan rekord Felettes mez�j�t 5-re �ll�tja, amelynek jelenleg 2 az �rt�ke.*/
UPDATE alkalmazottak
SET Felettes = 5
WHERE Felettes = 2;

/*10.	A k�vetkez� p�lda minden olyan term�k egys�g�r�t megn�veli 10 sz�zal�kkal, amely a 8. sz�m� sz�ll�t�t�l sz�rmazik, 
  �s amelyb�l van rakt�ron.*/
UPDATE term�kek
SET Egys�g�r = Egys�g�r*1.1
WHERE Sz�ll�t�k�d = 8 AND Rakt�ron > 0;

/*11.	A k�vetkez� p�lda minden olyan term�k egys�g�r�t cs�kkenti 10 sz�zal�kkal, amely a Tokyo Traders nev� sz�ll�t�t�l 
  sz�rmazik, �s amelyb�l van rakt�ron.*/ 
UPDATE term�kek
SET Egys�g�r = Egys�g�r*0.9
WHERE Sz�ll�t�k�d = 4 AND Rakt�ron > 0;

/*12.	Add meg a term�kek kateg�ri�nk�nti �tlagos egys�g�r�t!*/
SELECT Kateg�rian�v, AVG(Egys�g�r)
FROM term�kek
  INNER JOIN kateg�ri�k
    ON term�kek.Kateg�riak�d = kateg�ri�k.Kateg�riak�d
  GROUP BY kateg�ri�k.Kateg�riak�d;