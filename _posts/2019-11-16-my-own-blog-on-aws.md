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
2. Zaintalowany i skonfigurowany (klient CLI dla AWS)[https://aws.amazon.com/cli/]
3. Zainstalowany [terraform](https://www.terraform.io/downloads.html)
4. Jakies 20 minut

Proces instalacji będzie opisany dla Ubuntu, ponieważ aktualnie takiego systemu używam.

### Zakładanie konta AWS

Nie chce tutaj opisywać całego procesu zakładania konta w chmurze AWS. Jest to bardzo szybki proces, bez żadnych niespodzianek. Jedynie trzeba podpiąć kartę płatnicza do swojego konta co może być dla niektórych problematyczne. Polecam użycie karty prepaid np: [Revolute](https://revolut.com/referral/ukaszk0y!a13221) . AWS daje każdemu użytkownikowi pakiet [Free Tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsm.page-all-free-tier=1). Niektóre usługi są w pewnym stopniu za darmo przez pierwszy rok, a niektóre są w ograniczonym stopniu za darmo. W następnych artykułach opisze stawianie takiej samej usługi u innego dostawcy chmury, żebyś miał porównanie jak to wygląda u innych.

Teraz musisz wygenerować Access i Secret key dla twojego konta. Do tego celu najlepiej stworzyć nowe użytkownika IAM i dopiero jemu dać odpowiednie dostępy. Poniżej zamieszczam instruckje jak to zrobić z powiomu konsoli AWS:

1. Zaloguj się do konsoli pod adresem [https://console.aws.amazon.com/](https://console.aws.amazon.com/).
   ![AWS konsola](/img/2019-11-16-my-own-blog-on-aws/aws_login.png)
2. W serwisach wybierz [IAM](https://console.aws.amazon.com/iam/home?region=us-east-1#/home)
3. ![AWS IAM](/img/2019-11-16-my-own-blog-on-aws/aws_services.png)
4. Przejdz do [użytowników](https://console.aws.amazon.com/iam/home?region=us-east-1#/users) i nacisnij przycisk "Add user".
   ![AWS konsola](/img/2019-11-16-my-own-blog-on-aws/users.png)
5. Wybierasz dowolną nazwę dla użytkownika. Wymagane jest zaznaczenie "Programmatic access". Ta opcja wygeneruje dla użytkownika Access i Secret key. Klikasz "Next"
   ![AWS nowy użytkownik](/img/2019-11-16-my-own-blog-on-aws/new_user.png)
6. Wybierasz Attach existing policies directly i wyszukujesz polise dministratorAccess.
   ![AWS polisy](/img/2019-11-16-my-own-blog-on-aws/polices.png)
7. Na następnej stronie dodaj tagi o ile takie potrzebujesz.
   ![AWS tagi](/img/2019-11-16-my-own-blog-on-aws/tags.png)
8. Na kolejnej stronie zobaczysz podsumowanie tegp co zostanie stworzone.
9. Ostatnia strona zawiera niezbędne dla Ciebie informacje, Access i Secret key.

Jesteś gotowy żeby skonfigurować AWS CLI


### Instalacja i konfiguracja AWS CLI

AWS CLI jest dostarczana jako moduł pyhton. Instalacja jest bardzo prosta, wystarczy w konsoli uruchomić komendę kilka komend która zainstaluje pip3 oraz sam moduł AWS CLI:

{% highlight bash %}
sudo apt install python3-pip -y
sudo pip3 install awscli
{% endhighlight %}

Po zakończonym procesie installacji powinieneś skonfigurować CLI pod swoje konto AWS:
{% highlight bash %}
aws configure
AWS Access Key ID []: <tutaj podaj swój Access Key>
AWS Secret Access Key []: <tutaj podaj swój Secret Key>
Default region name []: <tutaj podaj swój region>
Default output format []: json

{% endhighlight %}

## Hosting

Żeby ktoś zobaczył twoją stronę, to musimy wystawić ją na jakimś serwerze, który jest podpięty do sieci. Jest jeszcze jedna możliwość, ale tyczy się ona tylko stron opartych na plikach statycznych jak blog, który właśnie czytasz.
Rozwiązaniem jest object storage. W przypadku AWS jest to S3. Usługa ta daje możliwośc wystawienie całego bucketu za webserverem

Usługi które wykorzystamy:

* S3
* CloudFront
* Certificate Manager
* Route 53

## Kod źródłowy dla infrastruktury

Infrastruktura jest stworzona za pomocą terraforma. Moduł jest dostępny na [GitHub](https://github.com/buker/blog-terraform-aws). Jest to moduł, który tworzy wszystkie niezbędne obiekty w chmurze AWS. Do poprawnego działania modułu trzeba go dodać do swojego projektu terraform z odpowiednimi zmiennymi. Przykład działającego rozwiązania znajduje się w katalogu [example](https://github.com/buker/blog-terraform-aws/tree/master/example). Poniżej zamieszczam fragment, który właśnie znajduje się w tym katalogu.

{% highlight bash %}
provider "aws" {
  profile = "default"
  region = "us-east-1"
}
module "blog" {
  source = "../"
  bucket_name = "demo-blog.zulnowski.com"
  domain_name = "demo-blog.zulnowski.com"
}
{% endhighlight %}

W pliku znajduje się definicja prowaidera dla AWS oraz inicjalizacja modułu z tego repozytorium.

Do poprawnego działania potrzebne jest skonfigurowane 


