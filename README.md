Ansible Workshop (Linux & Windows)
======================================================================================

Dieses Repopository basiert auf der super Vorarbeit meines Kollegen: https://github.com/jannikhuels/workshop-handson-ansible

Der Fokus dieses Repositories liegt auf der Integration in die Zielbetriebssysteme Linux & Windows. Außerdem kommen als Beispielapplikationen [Spring Boot](https://projects.spring.io/spring-boot/) Anwendungen zum Einsatz. 

Dieser Workshop soll viel Hands-On Erfahrung vermitteln. Wissen prägt sich am effektivsten ein, wenn es angewendet wird. Daher beschränken sich die Folien auf ein absolutes Minimum und werden durch Live-Nutzung der Tools mit Leben gefüllt. Am Ende jedes Abschnitts sollen die Teilnehmer dann das vorgestellte direkt praktisch anwenden.

Im ersten Teil werden wir die Basics zu Ansible kennenlernen und Ad-Hoc erste Tasks anwenden. Das Projekt verwendet [Vagrant](https://www.vagrantup.com/), um die verschiedenen Server bereitzustellen, die mit dem DevOps-Tools Ansible provisioniert werden sollen.

## Vorraussetzungen: Ein globales Rechenzentrum in der Hosentasche:

#### a) Installationen von VirtualBox, Packer, Vagrant

###### auf Windows via [chocolatey](https://chocolatey.org/)
* `choco install packer`
* `choco install virtualbox`
* `choco install vagrant`

###### auf dem Mac via [brew](https://brew.sh/index_de.html)
* `brew install packer`
* `brew cask install virtualbox` 
* `brew cask install vagrant`

###### unter Linux - einfach den jeweiligen Package Manager verwenden


#### Windows Server 2016 Vagrant Box:

Ein aktuelles Windows liegt leider nicht einfach auf vagrantup.com bereit. Wie man sich trotzdem legal eine Testumgebung mit Windows Server 2016 in einer VagrantBox mit Hilfe des DevOps-Tools [Packer](https://www.packer.io/) bereitstellt, beschreibt [dieser Blogartikel](https://blog.codecentric.de/en/2017/04/ansible-docker-windows-containers-spring-boot/).

Für die Schulung sind nur die folgenden Schritte notwendig:

###### 1.) ISO herunterladen

https://www.microsoft.com/de-de/evalcenter/evaluate-windows-server-2016 (oder direkt vom USB-Stick des Trainers)

###### 2.) Vagrant Box mit Packer bauen

Das Schulungs-GitHub Repository clonen: [ansible-linux-windows-workshop](https://github.com/jonashackt/ansible-linux-windows-workshop) und im Ordner `/day01/00_Infrastructure-as-Code/NewYork` folgenden Befehl ausführen:

```
packer build -var iso_url=14393.0.161119-1705.RS1_REFRESH_SERVER_EVAL_X64FRE_EN-US.ISO -var iso_checksum=70721288bbcdfe3239d8f8c0fae55f1f windows_2016_ansible.json
```


Dieser baut eine Vagrant Box mit Windows Server 2016, die bereits für die Verwendung mit Ansible konfiguriert ist. Sobald sie lokal vorliegt, muss sie Vagrant bekannt gemacht werden:

```
vagrant box add --name windows_2016_ansible_virtualbox  windows_2016_ansible_virtualbox.box
```


#### Die Ansible Control Machine

Mac-, Linux- & Windows 10-User könn(t)en ohne eine extra virtuelle Maschine loslegen - einfach Ansible installieren und fertig. ABER: Windows-User wären ausgesperrt!

> Da die Schulung aber für alle Nutzer eine einheitliche Trainingsumgebung bereitstellen will, wird die Ansible Control Machine zusätzlich bereitgestellt

`Microsoft Edge on Windows 10 Stable (15.xxx)` hier herunterladen https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/#downloads (oder direkt vom USB-Stick des Trainers)





Sobald die Maschinen bereitstehen und von Ansible angesprochen werden können, soll ein durchgängiges Anwendungsbeispiel aufgebaut werden.







- Bootstrapping neuer Instanzen
- Apache2 Webserver installieren und konfigurieren

In der heutigen Welt ist alles hochverfügbar. Wir werden das Anwendungsbeispiel dahingehend ausbauen:

- Apache2 hinter Loadbalancer
- Rolling updates

Und dann kommen noch Container ins Spiel. Wir werden die Vorteile von Docker motivieren und das Zusammenspiel mit Ansible zeigen. Ziel ist es Docker zu nutzen, um erneut einen Apache2 aufzusetzen. Zudem wollen wir keycloak als Authentifizierungsdienst einbauen und das Apache modul mod_auth_openidc nutzen. Anhand dieses komplexen Beispiels werden wir docker compose vorstellen.

Um zu zeigen, wie Ansible und Docker zusammenspielen werden wir:

- den Docker Host mit Ansible installieren und konfigurieren
- Container mit Ansible orchestrieren
- Ansible-Container nutzen

Abschließend werden wir besprechen, wie wir die erstellten Skripte in einer CI Umgebung nutzen können und gehen kurz auf Best-Practices im Bezug auf sensible Daten ein.

## Tag 1
* **[G]** Vorstellung [Persönliche Vorstellung, Kenntnisse, Erwartungen]
* **[V]** Roadmap
* **[V]** Ansible Grundlagen
* **[P]** PONG?
* **[V]** Ansible Playbooks
* **[P]** Bootstrap
* **[V]** Ansible Rollenkonzept
* **[P]** Apache2
* **[V]** Ansible Variablen
* **[P]** Apache2 && Keycloak
* **[G]** Retro

## Tag 2
* **[V]** Ansible Orchestrierung
* **[P]** HAProxy && Updates
* **[V]** Ansible Zusammenfassung
* **[V]** Docker Grundlagen
* **[P]** Ansible Docker Host
* **[P]** Erster Container
* **[V]** Docker Compose
* **[P]** Einmal alles, bitte
* **[G]** Retro

## Tag 3
* **[V]** Ansible Docker
* **[P]** Container Orchestrierung
* **[V]** Ansible Container
* **[P]** Container && VMs 
* **[V]** Automatisierung
* **[P]** Jenkins
* **[V]** Sicherheit
* **[P]** Ansible Vault
* **[G]** Retro

ToDo:
* Jump-Host / Proxy?
* https://github.com/ansible/ansible-container
* https://linuxacademy.com/howtoguides/posts/show/topic/13750-managing-docker-containers-with-ansible
* https://www.ansible.com/blog/six-ways-ansible-makes-docker-compose-better
* Return values
* Pipelining?
* https://github.com/geerlingguy/ansible-role-haproxy
* Handlers (in V Playbooks)
* http://docs.ansible.com/ansible-container/ Container - Alternative zu Docker Compose
* Variablen : Group by?
