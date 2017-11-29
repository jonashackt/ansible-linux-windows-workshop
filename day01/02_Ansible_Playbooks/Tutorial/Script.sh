# Clone example application https://github.com/jonashackt/restexamples into Tutorial directory
#
# Build example application with Maven: mvn clean install
#
ansible-playbook SpringBootLinux.yml -i inventory --extra-vars "spring_boot_app_jar=../../../../restexamples/target/restexamples-0.0.1-SNAPSHOT.jar"
