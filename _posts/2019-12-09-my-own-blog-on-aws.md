--
layout: post
title: Własny blog na AWS. Praktycznie za darmo.
date: 2019-12-09 14:00
category: cloud
author: Łukasz Żułnowski
image: /img/2019-12-09-my-own-blog-on-aws/logo.png
share-img: /img/2019-12-09-my-own-blog-on-aws/logo.png
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
4. Zainstalowany Docker
5. Jakies 20 minut

Proces instalacji będzie opisany dla Ubuntu, ponieważ aktualnie takiego systemu używam.

### Zakładanie konta AWS

Nie chce tutaj opisywać całego procesu zakładania konta w chmurze AWS. Jest to bardzo szybki proces, bez żadnych niespodzianek. Jedynie trzeba podpiąć kartę płatnicza do swojego konta co może być dla niektórych problematyczne. Polecam użycie karty prepaid np: [Revolute](https://revolut.com/referral/ukaszk0y!a13221) . AWS daje każdemu użytkownikowi pakiet [Free Tier](https://aws.amazon.com/free/?all-free-tier.sort-by=item.additionalFields.SortRank&all-free-tier.sort-order=asc&awsf.Free%20Tier%20Types=*all&awsm.page-all-free-tier=1). Niektóre usługi są w pewnym stopniu za darmo przez pierwszy rok, a niektóre są w ograniczonym stopniu za darmo. W następnych artykułach opisze stawianie takiej samej usługi u innego dostawcy chmury, żebyś miał porównanie jak to wygląda u innych.

Teraz musisz wygenerować Access i Secret key dla twojego konta. Do tego celu najlepiej stworzyć nowe użytkownika IAM i dopiero jemu dać odpowiednie dostępy. Poniżej zamieszczam instruckje jak to zrobić z powiomu konsoli AWS:

1. Zaloguj się do konsoli pod adresem [https://console.aws.amazon.com/](https://console.aws.amazon.com/).
   ![AWS konsola](/img/2019-12-09-my-own-blog-on-aws/aws_login.png)
2. W serwisach wybierz [IAM](https://console.aws.amazon.com/iam/home?region=us-east-1#/home)
3. ![AWS IAM](/img/2019-12-09-my-own-blog-on-aws/aws_services.png)
4. Przejdz do [użytowników](https://console.aws.amazon.com/iam/home?region=us-east-1#/users) i nacisnij przycisk "Add user".
   ![AWS konsola](/img/2019-12-09-my-own-blog-on-aws/users.png)
5. Wybierasz dowolną nazwę dla użytkownika. Wymagane jest zaznaczenie "Programmatic access". Ta opcja wygeneruje dla użytkownika Access i Secret key. Klikasz "Next"
   ![AWS nowy użytkownik](/img/2019-12-09-my-own-blog-on-aws/new_user.png)
6. Wybierasz Attach existing policies directly i wyszukujesz polise dministratorAccess.
   ![AWS polisy](/img/2019-12-09-my-own-blog-on-aws/polices.png)
7. Na następnej stronie dodaj tagi o ile takie potrzebujesz.
   ![AWS tagi](/img/2019-12-09-my-own-blog-on-aws/tags.png)
8. Na kolejnej stronie zobaczysz podsumowanie tegp co zostanie stworzone.
9. Ostatnia strona zawiera niezbędne dla Ciebie informacje, Access i Secret key.

Jesteś gotowy żeby skonfigurować AWS CLI.


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

Teraz możesz sprawdzić czy poprawnie skonfigurowałeś CLI poleceniem.
{% highlight bash %}
aws sts get-caller-identity
{
    "UserId": "**********",
    "Account": "**********",
    "Arn": "**********"
}
{% endhighlight %}

Wynik tego polecenia powinien być taki jak powyżej. Zawiera dane na temat twojego użytkownika takie jak, UserId, numer konta AWS oraz ARN obiektu użytkownika.

### Instalacja Terraforma
Instalacja teraforma jest manulna. Nie ma paczki systemowej, ani innego ładnego rozwiązania. Trzeba wejść na strone i pobrać najnowszą albo konkretną wersje. Jednak społeczność rozwiązała ten problem pisząc prosty skrypt, który robi dokładnie to co chcemy.  Zamieszczam jego kod oraz odnośnik do źródła:

{% highlight bash %}
#!/bin/bash

function terraform-install() {
  [[ -f ${HOME}/bin/terraform ]] && echo "`${HOME}/bin/terraform version` already installed at ${HOME}/bin/terraform" && return 0
  LATEST_URL=$(curl -sL https://releases.hashicorp.com/terraform/index.json | jq -r '.versions[].builds[].url' | sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n | egrep -v 'rc|beta' | egrep 'linux.*amd64' |tail -1)
  curl ${LATEST_URL} > /tmp/terraform.zip
  mkdir -p ${HOME}/bin
  (cd ${HOME}/bin && unzip /tmp/terraform.zip)
  if [[ -z $(grep 'export PATH=${HOME}/bin:${PATH}' ~/.bashrc) ]]; then
  	echo 'export PATH=${HOME}/bin:${PATH}' >> ~/.bashrc
  fi
  
  echo "Installed: `${HOME}/bin/terraform version`"
  
  cat - << EOF 
 
Run the following to reload your PATH with terraform:
  source ~/.bashrc
EOF
}

terraform-install
{% endhighlight %}
Umieść zawartość w pliku terraform-install.sh. Gdy już masz plik na swoim komputerze wystarczy dodać uprawnienia do uruchomienia, i odpalić go:

{% highlight bash %}
chmod +x terraform-install.sh
./terraform-install.sh
{% endhighlight %}

Jak skrypt zakończy prace możemy sprawdzić czy terraform został poprawnie zainstalowany sprawdzając czy się uruchomi.

{% highlight bash %}
terrafrom version
Terraform v0.12.6
{% endhighlight %}

### Instalacja Dockera

Procesu instalacji Dockera nie będę opisywał. Wszystkie informacje na ten temat można znaleść w moim poprzednim artykule na temat [Kubernetesa na VPS](/2018-10-15-kubernetes-pierwszy-cluster/) albo w oficjalnej [instrukcji](https://docs.docker.com/install/linux/docker-ce/ubuntu/). 

## Hosting

Żeby ktoś zobaczył twoją stronę, to musimy wystawić ją na jakimś serwerze, który jest podpięty do sieci. Jest jeszcze jedna możliwość, ale tyczy się ona tylko stron opartych na plikach statycznych jak blog, który właśnie czytasz.
Rozwiązaniem jest object storage. W przypadku AWS jest to S3. Usługa ta daje możliwośc wystawienie całego bucketu za webserverem

Usługi które wykorzystamy:

* S3
* CloudFront
* Certificate Manager
* Route 53

### Kod źródłowy dla infrastruktury

Infrastruktura jest stworzona za pomocą terraforma. Moduł jest dostępny na [GitHub](https://github.com/buker/blog-terraform-aws). Jest to moduł, który tworzy wszystkie niezbędne obiekty w chmurze AWS. Do poprawnego działania modułu trzeba go dodać do swojego projektu terraform z odpowiednimi zmiennymi. Przykład działającego rozwiązania znajduje się w katalogu [example](https://github.com/buker/blog-terraform-aws/tree/master/example). Poniżej zamieszczam fragment, który właśnie znajduje się w tym katalogu.

{% highlight bash %}
provider "aws" {
  profile = "default"
  region = "us-east-1"
}
module "blog" {
  source = "github.com/buker/blog-terraform-aws"
  bucket_name = "demo-blog.zulnowski.com"
  domain_name = "demo-blog.zulnowski.com"
}
{% endhighlight %}

W pliku znajduje się definicja prowaidera dla AWS oraz inicjalizacja modułu z tego [repozytorium](https://github.com/buker/blog-terraform-aws). Musis zmienić 2 zmienne bucket_name i domain_name na odpowiednie dla twojego projektu. Pamiętaj że nazwa bucketu s3 musi być unikalna. Nikt inny nie może mieć już bucketa z taką nazwą.

Zanim uruchomisz terraforma jeszcze musisz ustalić jedną rzecz. Czy posiadasz domenę, której będziesz używał. Jeśli nie to musisz kupić ją u jakiegoś dostawcy. możesz to też zrobić bezpośrednio w AWS. Polecam kupić jak najtaniej, zwróć uwagę na koszt przedłużenia. Często domena jest za symboliczną złotówkę ale potem utrzymanie domeny przez następny rok kosztuje ponad 100zł albo jeszczce więcej.

### Uruchomienie Terraforma

Dobrze jesteś gotowy na uruchomienie swojej infrastruktury. Nie uruchamiaj bezposrednio terraforma, w taki sposób żeby stworzył infrastrukture przy użyciu apply. Na początku stworz plan dla terraforma poleceniem terrfarom plan.

{% highlight bash %}
terraform plan -out infra_plan
{% endhighlight %}

Terraform powinien wyświetlić Ci wszystkie zmiany jakie zostaną wykonane w AWS. Najprawdopodobniej będzie to tylko tworzenie obiektów. Na koniec zostanie wyświetlone polecenie, którym wcześniej wygenerowany plan możemy wdrożyć w życie. Moim przypadku polecenie wyglądało następująco:

{% highlight bash %}
terraform apply "infra_plan"
{% endhighlight %}
Gdy zmianny zgadzają się z oczekiwanymi, wpisujesz "yes" akceptując zmiany i czekasz aż wykona się. Może to chwilę potrwać z powodu podpisywania certyfikatu. W trakcie wykonywania gdy obiekt route 53 będzie stworzony powinieneś u swojego dostawcy domeny stworzyć odpowiednie wpisy na temat serweró nazw. To na jekie serwery powinna kierować nasza domena wpisami typu NS można znaleść w konfiguracji strefy w [Route 53](https://console.aws.amazon.com/route53/).
![AWS NS](/img/2019-12-09-my-own-blog-on-aws/ns.png)

{: .box-error}
**Ważne:** Zastanawiasz się czemu rpoprosiłem żebyś to zrobił w ten sposób. W ten sposób możesz odłożyć samo wdrożenie na później i będziesz miał pewność że to co się wykona na infrastruktórze będzie tym co wcześniej widziałeś.

Gdy terraform skończy swoją prace, nasza infrastruktura jest gotowa do użytku. Możemy się zająć zawartością strony, którą umieścimy.

## Twoja strona

Została nam ostatnia rzecz do zrobienia. Wygenerowanie strony. W artykule przedstawie Ci prosty sposów na stworznie strony statycznej za pomocą frameworku Jekyll. Do tego celu przygotowałem repozytorium, które ułatwi nam tworzenie strony i potem dalsze jej utrzymywanie.

Sklonuj [repozytorium](https://github.com/buker/blog-example.git) używając polecenia:

{% highlight bash %}
git clone https://github.com/buker/blog-example.git
{% endhighlight %}

W repozytorium znajduje się Dockerfile oraz wszystkie niezbędne pliki do zbudowania obrazu. Dodatkowo stworzyłem Makefile, który automatyzuje procesy. Będzie to twoje główne narzędzie. Zaimplementowany w nim jest target help, który służy do wyświetlania pomocy. Znajdują się w niej opisy wszystkich targetów w raz z listą parametrów.

{% highlight bash %}
make help
Variables:
 - SITE - name of your website
 - BUCKET_NAME - name of bucket
build                          Build image for development, Parameters: site, Usage: make run SITE=blog.example.com
build-site                     Build statics files in docker image, Parameters: site, Usage: make build-site SITE=blog.example.com
deploy                         Deploy your static file to s3 bucket, Parameters: site, bucket_name, Usage: make deploy SITE=blog.example.com BUCKET_NAME=example-bucket
help                           Display this help. Default target
new                            Create new jekyll page. Parameters: site, Usage: make new SITE=blog.example.com
run                            Run docker with volume mount, Parameters: site, Usage: make run SITE=blog.example.com
{% endhighlight %}

Zacznijmy tworzyć stronę. Na początku musimy zbudować obraz dokerowy, w którym będziemy uruchamiać i budować naszą stronę. 

{% highlight bash %}
make build SITE=nazwa_twojej_strony
...
Successfully built d38fae7aba96
Successfully tagged demo_blog:latest
{% endhighlight %}

Dobrze masz gotowy obraz. Następny krok to już wygenerowanie strony. Jeśli to będzie twoja pierwsza strona powinieneś zacząć od wygenerowania jej za pomocą targetu new.
{% highlight bash %}
$ make new SITE=nazwa_twojej_strony
docker run --rm --name "demo_blog" -v "/home/buker/Workspace/blog-example":/srv/jekyll "demo_blog" new "demo_blog"
new
ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux-musl]
Running bundle install in /srv/jekyll/demo_blog... 
  Bundler: Using concurrent-ruby 1.1.5
  ...
  Bundler: Bundled gems are installed into `/usr/local/bundle`
New jekyll site installed in /srv/jekyll/demo_blog. 
New page generated
$ ls -1
demo_blog
Dockerfile
entrypoint.sh
Gemfile
Gemfile.lock
Makefile
README.md
{% endhighlight %}
Jak widzisz został wygenerowany nowy katalog demo_blog (takiej nazwy strony użyłem). Zawiera on wszystkie pliki których potrzebuje Jekyll do działania.

{% highlight bash %}
$ tree
.
├── 404.html
├── about.md
├── _config.yml
├── Gemfile
├── Gemfile.lock
├── index.md
└── _posts
    └── 2019-11-04-welcome-to-jekyll.markdown
{% endhighlight %}

To jest już w stu procentach działająca strona, którą da się uruchomić. Możemy to zrobić za pomocą polecenia:

{% highlight bash %}
$ make run SITE=nazwa_twojej_strony
ocker run --rm -p 4000:4000 --name "demo_blog" -v "/home/buker/Workspace/blog-example/"demo_blog"":/srv/jekyll "demo_blog" serve
serve
ruby 2.6.5p114 (2019-10-01 revision 67812) [x86_64-linux-musl]
Configuration file: /srv/jekyll/_config.yml
            Source: /srv/jekyll
       Destination: /srv/jekyll/_site
 Incremental build: disabled. Enable with --incremental
      Generating... 
       Jekyll Feed: Generating feed for posts
                    done in 0.542 seconds.
 Auto-regeneration: enabled for '/srv/jekyll'
    Server address: http://0.0.0.0:4000/
  Server running... press ctrl-c to stop.
{% endhighlight %}
W tym momencie twoja strona jest dostępna na twojej lokalnej maszynie pod adressem [http://localhost:400](http://localhost:400) i wygląda podobnie do tej poniżej.
![Jekyll example](/img/2019-12-09-my-own-blog-on-aws/new_site.png)

Jeśli chcesz zacząć swoją strone od gotowego projektu wystarczy go umieścić jako katalog w taki sam sposób jak demo_blog. 

### Wysyłamy stronę w świat

Przyszedł czas na najlepszą część. Wysłanie naszej nowej storny w świat. Jest to wyjątkowo proste. Twoja strona jest będzie umieszczona na s3 do czego możemy użyć aws cli. W Makefile znajduje się target, który dokładnie to robi.

{% highlight bash %}
$ make deploy SITE=blog.example.com BUCKET_NAME=example-bucket
{% endhighlight %}

Twoja strona zostanie synchronizowana do podanego bucketu. Teraz wystarczy werjść pod domenę, którą podałeś przy tworzeniu infrastuktury.

## Podsumowanie

Dziki kilku krótkim krokom zainsniałeś w internecie :). Zaprezentowane rozwiązanie możemy używać na początku życia strony jak i gdy dziennie ma setki albo tysiące użytkowników dziennie. S3 nie ma limitów na ilość requestów na sekunde, dodatkowo strona jest cachowana po stronie CloudFront co zapewnia znaczne oszczędności przy dużym ruchu na stronie. Jak dzięki temu artykułowi zachęciłem Cię do postawienia własnej strony, podziel się tym w komentarzach. Bardzo chętnie zobacze wasze projekty.

Zachęcam do zapisania się w newsleterze. Mam pewien pomysł na projekt, którym chętnie wykorzystam Newsleter jako źródło danych. Oczywiście tylko dla chętnych :).
