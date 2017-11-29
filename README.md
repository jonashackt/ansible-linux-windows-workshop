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
Da die Schulung aber für alle Nutzer eine einheitliche Trainingsumgebung bereitstellen will, wird die Ansible Control Machine zusätzlich bereitgestellt. Dazu die
`Microsoft Edge on Win10 (x64) Stable (16.xxx)` __Vagrant Box__ hier herunterladen https://developer.microsoft.com/en-us/microsoft-edge/tools/vms/#downloads und in Ordner `/day01/00_Infrastructure-as-Code/ControlMachine` entpacken (oder direkt vom USB-Stick des Trainers).

Die Vagrant Box ebenfalls der lokalen Vagrantinstallation hinzufügen:

```
vagrant box add "MSEdge - Win10.box" --name "windows10"
```

Nun folgt der `vagrant up` 

> Leider vergisst Microsoft bei der eigenen Vagrant Box ein paar grundlegende Dinge, damit diese auch ohne Probleme funktioniert. Denn wie man vielleicht schon bemerkt hat, führt ein unvoreingenommenes vagrant up zu einem „Timed out while waiting for the machine to boot […]“. Das liegt an der Konfiguration der Network List Management Policies, die einen Zugriff per Windows Remote Management (WinRM) verhindern. Doch dem kann man schnell Abhilfe verschaffen. Dazu einmalig nach dem ersten Start der Vagrant Box in die Local Security Policys gehen und darin in die Network List Management Policies wechseln. Dort auf Network klicken und im Tab Network Location den Location type auf private und die User permissions auf User can change location setzen.  Nun sollte das vagrant up so funktionieren wie gedacht. Es wäre natürlich schön, wenn uns diese Arbeit schon Microsoft abnehmen würde.

Wen das Englische Tastaturlayout stört: `language` tippen, runter scrollen und unter __Related settings__ `Additional date, time, & regional settings`. Dann auf `Change input methods`unter __Language__ usw. sudo ... (zuletzt einmal neustarten)

##### Control Machine vorbereiten

Siehe auch https://msdn.microsoft.com/en-us/commandline/wsl/install-win10

Zuerst auf einer Administrativen PowerShell den folgenden Befehl ausführen:

```
Enable-WindowsOptionalFeature -Online -FeatureName Microsoft-Windows-Subsystem-Linux
```

Danach in den Windows Store gehen und nach Ubuntu suchen. Dieses per __GET__ installieren. Danach auf __LAUNCH__.

![Installing_Ubuntu_on_Control_Machine.png](https://github.com/jonashackt/ansible-linux-windows-workshop/blob/master/Installing_Ubuntu_on_Control_Machine.png)

Nun einen Nutzernamen und Passwort vergeben.

Danach einmal das Package Management updaten:

```
sudo apt-get update
```

##### Ansible auf der Control Machine installieren

Siehe http://docs.ansible.com/ansible/latest/intro_installation.html#latest-releases-via-apt-ubuntu

```
sudo apt-add-repository ppa:ansible/ansible
sudo apt-get update
sudo apt-get install ansible
sudo apt-get install python-pip
pip install pywinrm
```

![Installing_Ansible_on_Control_Machine.png](https://github.com/jonashackt/ansible-linux-windows-workshop/blob/master/Installing_Ansible_on_Control_Machine.png)


##### Testaufruf des globales Hosentaschen-Rechenzentrums

Auf dem Host jeweils unter `day01/00_Infrastructure-as-Code/Frankfurt` & `day01/00_Infrastructure-as-Code/NewYork` ein `vagrant up` ausführen.

Dann wieder in die Control Machine wechseln: Nun kann das https://github.com/jonashackt/ansible-linux-windows-workshop lokal in die Control Machine gecloned werden (git ist bereits im Windows 10 Subsystem installiert):

```
git clone https://github.com/jonashackt/ansible-linux-windows-workshop.git
```

Im Ordner `ansible-linux-windows-workshop/day01/01_Ansible_Basics/Tutorial` einmal die folgenden Befehle ausführen:

```
export ANSIBLE_HOST_KEY_CHECKING=False
ansible all -m ping -i inventory
unset ANSIBLE_HOST_KEY_CHECKING
```

Das Ergebnis sollte zwei erfolgreiche `pongs` zurückgeben:

![Control_Machine_Successful_Ansible_Call_of_FFMandNYC.png](https://github.com/jonashackt/ansible-linux-windows-workshop/blob/master/Control_Machine_Successful_Ansible_Call_of_FFMandNYC.png)

Außerdem einmal die Windows Connectivity testen:

```
ansible all -m win_ping -i inventoryStuttgart 
```


Sobald die Maschinen bereitstehen und von Ansible angesprochen werden können, soll ein durchgängiges Anwendungsbeispiel aufgebaut werden.



#### Ein durchgängiges Beispiel

Wir wollen eine moderne Webanwendung mit Hilfe von Ansible auf ein System provisionieren. Dafür nutzen wir das aktuell sehr beliebte [Spring Boot](https://projects.spring.io/spring-boot/) im Java Enterprise Umfeld. 

Dafür brauchen wir eine Spring Boot Anwendung: Entweder schnell selbst eine zusammenbauen (z.B. per https://start.spring.io/) oder die folgende Beispielapp clonen: https://github.com/jonashackt/restexamples

```
cd /home/vagrant
git clone https://github.com/jonashackt/restexamples.git
# Maven installieren
sudo apt-get install maven
```

Dann werden wir eine:

* Spring Boot Anwendung auf Linux provisionieren

Danach wollen wir das gleiche mit Ansible auf einem Windows System durchführen.

* Spring Boot Anwendung auf Windows provisionieren



Und dann kommen noch Container ins Spiel. Wir werden die Vorteile von Docker motivieren und das Zusammenspiel mit Ansible zeigen. Ziel ist es Docker zu nutzen, um erneut eine Spring Boot Anwendung zu provisionieren.

* Spring Boot Anwendung - Dockerized - auf Linux provisionieren
* Spring Boot Anwendund - Dockerized - auf Windows provisionieren

Dafür müssen wir zeigen, 

* wie Ansible und Docker zusammenspielen
* wie man den Docker Host mit Ansible installiert und konfiguriert


Da heute Microservice-Architekturen das Mittel der Wahl darstellen, wollen wir ein komplexeres Beispiel mit Spring Cloud und Docker Compose aufbauen.


- Container mit Ansible orchestrieren





Abschließend werden wir besprechen, wie wir die erstellten Skripte in einer CI Umgebung nutzen können.

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
