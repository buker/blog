---
layout: post
title: DevOps w konsoli
date: 2019-11-28 18:00
category: Linux
author: Łukasz Żułnowski
image: /img/2019-11-09-aws-solution-architect-associate/logo.png
share-img: /img/2019-11-28-aws-solution-architect-associate/logo.png
tags: [aws, cloud, trening, certyfikat, nauka, egzamin]
summary: Lista przydatnych narzędzi CLI, które ułatwiają życie
series: [Cloud]
---

Ten artykuł poświęce przedstawienie kilku narzędzi, a dokładnie dziesięciu, które ułatwiają mi na codzień życie po przez brak konieczności używania myszki albo automatyzowanie niektórych procesów. Postaram się każde z narzędzi/komend opisać najważniejsze funkcje i możliwość konfiguracji. Część z was się spodziewa pewnie że będę pisał tutaj o Vim :). Zaskocze was, nie tym razem. Na temat edytorów teksowych będzie oddzielny odcinek ale musi to trochę poczekać bo właśnie próbuje używać Emacsa (tak ten wpis właśnie w nim pisze i narazie nie mogę się przyzwyczaić)

## 1. Tmux

Na pierwszy ogień midzie mój faworyt jeśli chodzi o prace w terminalu. Bez niego nie wyobrażam sobie życia. Czym jest Tmux? Jest to multiplekser terminala, który pozwala nam odpalić w jednym oknie terminala wiele zakładek a w nich wiele niezależnych sesji. Jest to bardzo konfigurowalne narzędzie a przy okazji posiada wiele użytecznych pluginów. 

########SCREEN  Z TMUXA JAKIS Z NETA#########


Plusy:
* Pluginy
* Konfiguracja daje dużo mozliwości personalizacji
* Szybkość działania 
* Praktycznie nie zużywa zasobów
* Nie musisz nic konfigurować żeby go używać

Minusy:
* Jak w przypadku VIM żeby zacząć go używać jak pro musisz poświęcić sporo czasu




## 2. Pet

Jest to moje najnowsze odkrycie. [Pet](https://github.com/knqyf263/pet) to manager komend, który potrafi się synchronizować z gitsami. Bardzo przydatne narzędzie naprzykład przy zarządzaniu wieloma środowiskami gdzie jedyna rzecz w komendzie musisz zmienić to przełącznik, albo zmienną. Jako przykład posłuże sie poleceniem kubectl. Załużmy że chce wyświetlić wszystkie wszystkie pody w namespace prod, dodatkowo używając selectora, który zawęzi nam wynik tylko do podów jednego klienta.
Polecenie w konsoli wyglądało by następująco:

{% highlight bash linenos %}
kubectl get pod --namespace prod --selector=client=some_company
{% endhighlight %}

Trochę pisana jest, a można by to polecenie jeszcze rozbudować o kilka dodatkowych przełączników. Tutaj przychodzi nam z pomocą Pet.

Jak już mamy nasze polecenie wystarczy je dodać do naszej bazy wiedzy za pomoca polecenie 
{% highlight bash linenos %}
pet new
{% endhighlight %}
W pole "Command" wpisujemy nasze polecenie dodając elementy które mogą się zmienić na tagi <jakaś nazwa>
Przykładowe polecenie będzie wyglądać następująco:

{% highlight bash linenos %}
kubectl get pod --namespace <namespace> --selector=client=<client>
{% endhighlight %}

Zostało dodanie opisu, po którym będziemy mogli znaleść nasze polecenie i to wszystko.

Za pomocą polecenia
{% highlight bash linenos %}
pet exec
{% endhighlight %}

Możemy znaleść naszą komendę i ją uruchomić. Otworzy się okno diaglogowe z miejscami na wstawienie zmiennych do polecenia. 

#########SCREEN Z OKNA DIALOGOWEGO#######

