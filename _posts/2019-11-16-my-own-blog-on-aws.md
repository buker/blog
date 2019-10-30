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

Nie chce tutaj opisywać całego procesu zakładania konta w chmurze AWS. Jest to bardzo szybki proces bez żadnych niespodzianek. Jedynie trzeba podpiąć kartę płatnicza do swojego konta co może być dla niektórych problematyczne. Polecam użycie karty prepaid np: [Revolute](https://revolut.com/referral/ukaszk0y!a13221) 

## Hosting

## Kod źródłowy