% Spawalnictwo - Zarz¹dzanie procesami spawalniczymi
% program ma na celu u³atwienie zarz¹dzania projektami spawalniczymi.
% Pozwala on na przydzielenie odpowiednich materia³ów i wyspecjalizowanych w nich spawaczy
% do projektu o specyficznych wymaganiach. Nastêpnie ewaluowana jest mo¿liwoœæ realizacji
% takiego projektu. Program usprawnia w ten sposób dysponowanie zasobami i pracownikami
% w planowaniu projektu spawalniczego

% Dynamiczna definicja materia³ów spawalniczych (oznacza to ¿e predykat materia³y mo¿e byæ na bie¿¹co usuwany lub dodawany)
:- dynamic(material/2).

% Definicja materia³ów spawalniczych
% material(Nazwa, Ilosc)
material(stal, 50).
material(aluminium, 30).
material(miedz, 20).
material(tytan, 10).
material(zloto, 5).
material(srebro, 8).

% Definicja spawaczy i ich kwalifikacji spawalniczycg
% spawacz(Imie, Kwalifikacje)
spawacz(andrew, [stal, aluminium]).
spawacz(adam, [stal]).
spawacz(roxie, [miedz, tytan]).
spawacz(ola, [aluminium, srebro]).
spawacz(eleonora, [zloto, stal]).

% Definicja projektów spawalniczych
% projekt(NazwaProjektu, WymaganeMaterialy, WymaganeKwalifikacje)
projekt(most, [stal, aluminium], [stal, aluminium]).
projekt(rura, [miedz], [miedz]).
projekt(satelita, [tytan], [tytan]).
projekt(bizuteria, [zloto, srebro], [zloto, srebro]).
projekt(samolot, [aluminium, tytan], [aluminium, tytan]).

% Przydzielenie materia³u do projektu spawalniczego
% predykat 'member' sprawdza czy pierwszy argument jest cz³onkiem drugiego argumentu
% przydziel_material(NazwaProjektu, NazwaMaterialu, Ilosc)
przydziel_material(Projekt, Material, Ilosc) :-
    projekt(Projekt, WymaganeMaterialy, _),
    member(Material, WymaganeMaterialy),
    material(Material, DostepnaIlosc),
    DostepnaIlosc >= Ilosc.

% Przydzielenie spawacza do projektu
% predykat subset sprawdza czy pierwszy argument nale¿y do podzbioru drugiego argumentu
% przydziel_spawacza(NazwaProjektu, ImieSpawacza, Kwalifikacje)
przydziel_spawacza(Projekt, Spawacz, Kwalifikacje) :-
    projekt(Projekt, _, WymaganeKwalifikacje),
    spawacz(Spawacz, KwalifikacjeSpawacza),
    subset(WymaganeKwalifikacje, KwalifikacjeSpawacza),
    member(Kwalifikacja, Kwalifikacje),
    member(Kwalifikacja, KwalifikacjeSpawacza).

% Sprawdzenie czy projekt jest mo¿liwy do zrealizowania
% predykat forall sprawdza czy pierwszy argument jest prawdziwy w drugim argumencie
% w tym przypadku oznacza, ¿e dla ka¿dego materia³u wymaganego w projekcie, dostêpna
% iloœæ tego materia³u musi byæ wiêksza lub równa iloœci wymaganej do realizacji projektu.
% sprawdz_projekt(NazwaProjektu, IloscMaterialu, Spawacze)
sprawdz_projekt(Projekt, IloscMaterialu, Spawacze) :-
    projekt(Projekt, WymaganeMaterialy, WymaganeKwalifikacje),
    forall(member(Material, WymaganeMaterialy),
        (material(Material, DostepnaIlosc),
        DostepnaIlosc >= IloscMaterialu)),
    forall(member(Kwalifikacja, WymaganeKwalifikacje),
        (member(Spawacz, Spawacze),
        spawacz(Spawacz, KwalifikacjeSpawacza),
        member(Kwalifikacja, KwalifikacjeSpawacza))).

% Aktualizacja liczby materia³ów po przydzieleniu do projektu
% predykaty retract i assertz usuwaj¹ i dodaj¹ fakty do bazy wiedzy
% aktualizuj_material(NazwaMaterialu, NowaIlosc)
aktualizuj_material(Material, NowaIlosc) :-
    retract(material(Material, _)),
    assertz(material(Material, NowaIlosc)).

% Realzacja projektu spawalniczego
% realizuj_projekt(NazwaProjektu, IloscMaterialu, Spawacze)
realizuj_projekt(Projekt, IloscMaterialu, Spawacze) :-
    sprawdz_projekt(Projekt, IloscMaterialu, Spawacze),
    projekt(Projekt, WymaganeMaterialy, _),
    forall(member(Material, WymaganeMaterialy),
        (material(Material, DostepnaIlosc),
        NowaIlosc is DostepnaIlosc - IloscMaterialu,
        aktualizuj_material(Material, NowaIlosc))),
    write('Projekt '), write(Projekt), write(' zrealizowany prawid³owo.'), nl.

% Przyk³adowe predykaty do u¿ycia w programie:
% ?- przydziel_material(most, stal, 20).
% ?- przydziel_spawacza(most, andrew, [stal, aluminium]).
% ?- sprawdz_projekt(most, 20, [andrew]).
% ?- sprawdz_projekt(rura, 10, [roxie]).
% ?- sprawdz_projekt(satelita, 5, [roxie]).
% ?- realizuj_projekt(most, 20, [andrew]).
% ?- realizuj_projekt(bizuteria, 2, [eleonora, ola]).
% ?- aktualizuj_materia³(stal, 30).

% program zrealizowany przez: Jakub Mosakowski, Norbert Gutkowski
