---
layout: post
title: Własny blog na AWS praktycznie za darmo.
date: 2019-10-16 20:08
category: cloud
author: Łukasz Żułnowski
image: /img2019-11-16-my-own-blog-on-aws/logo.png
share-image: /img/2019-11-16-my-own-blog-on-aws/logo.png
tags: [aws, cloud, blog, free, hosting, jekyll]
summary: Jak postawić własnego bloga na platformie AWS.
series: [Cloud]
---

Dzisiaj każdy może stworzyć swojego blog, pisać artykuły i wyrażać w ten sposób swoje zdanie w internecie. Jedyne czego potrzebuje taka osoba to kawałek kodu, który wyświetli treść użytkownikowi i hosting. W tym odcinku postaram się zaproponować bardzo łatwe jak i tanie rozwiązanie (do pewnego stopnia nawet darmowe). Artykuł jest podzielony na 3 sekcje: wymagnia, hosting, kod. Oczywiście cały niezbędny kod będzie dostępny dla was z poziomu githuba. Linki w sekcji wymagnania.



## Wymagania

Do uruchomienia swojego blogu potrzebne będzie tylko kilka rzeczy:

1. Konto [AWS](https://portal.aws.amazon.com/gp/aws/developer/registration/index.html?nc2=h_ct&src=default)
2. Zaintalowany (klient CLI dla AWS)[https://aws.amazon.com/cli/]
3. Zainstalowany [terraform](https://www.terraform.io/downloads.html)
4. Jakies 20 minut

Proces instalacji będzie opisany dla Ubuntu, ponieważ aktualnie takiego używam.

### Zakładanie konta AWS

Nie chce tutaj opisywać całego procesu zakładania konta w chmurze AWS. Jest to bardzo szybki proces, bez żadnych niespodzianek. Jedynie trzeba podpiąć kartę płatnicza do swojego konta co może być dla niektórych problematyczne. Polecam użycie karty prepaid np: [Revolute](https://revolut.com/referral/ukaszk0y!a13221) . AWS daje każdemu użytkownikowi pakiet [Free Tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsm.page-all-free-tier=1). Niektóre usługi są w pewnym stopniu za darmo przez pierwszy rok, a niektóre są w ograniczonym stopniu za darmo. W następnych artykułach opisze stawianie takiej samej usługi u innego dostawcy chmury, żebyś miał porównanie jak to wygląda u innych.

## Hosting

Żeby ktoś zobaczył twoją stronę, to musimy wystawić ją na jakimś serwerze, który jest podpięty do sieci. Jest jeszcze jedna możliwość, ale tyczy się ona tylko stron opartych na plikach statycznych jak blog, który właśnie czytasz.
Rozwiązaniem jest object storage. W przypadku AWS jest to S3. Usługa ta daje możliwośc wystawienie całego bucketu za webserverem

Usługi które wykorzystamy:
* S3
* CloudFront
* Certificate Manager
* Route 53

## Kod źródłowy

Infrastruktura jest stworzona za pomocą terraforma. Moduł jest dostępny na [GitHub](https://github.com/buker/blog-terraform-aws). Jest to moduł który tworzy wszystkie niezbędne obiekty w chmurze AWS. Jedynie trzeba wypełnić zmienne, które przyjmuje moduł na odpowienie dla nas. 

Przykład działającego rozwiązania znajduje się w specjalnie do tego celu przygotowanym [repozytorium](https://github.com/buker/blog-example)