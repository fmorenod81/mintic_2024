# mintic_2024
Ejercicios para Arquitectura de Nube Avanzada
Alumno: Francisco Javier Moreno Diaz
Email: fmorenod@gmail.com

Se realizo la descripcion en el archivo del Drive.

Los comandos para su ejecucion son:

kubectl apply -f postgres.yaml

 >> Respuesta

 ``persistentvolumeclaim/postgres-claim created

 deployment.apps/postgresql created

 service/postgresql created ``

kubectl apply -f drupal.yaml

>> Respuesta

 ``persistentvolumeclaim/drupal-claim created

deployment.apps/drupal created

service/drupal created ``

para revisar la creacion de los servicios se usa

kubectl get svc

>> Ejemplo de Respuesta

 ``NAME         TYPE           CLUSTER-IP       EXTERNAL-IP   PORT(S)        AGE
drupal       LoadBalancer   10.111.49.166    localhost     80:31683/TCP   89s
kubernetes   ClusterIP      10.96.0.1        <none>        443/TCP        8h
postgresql   ClusterIP      10.100.135.109   <none>        5432/TCP       96s ``

Se verifica la IP que genera como Cluster-IP para configurar el Drupal cuando nos pida el host del PostgreSQL, en este caso seria 10.100.135.109.



Cuando se realizen las pruebas de funcionamiento del Drupal como se explicaron en el PDF del GDrive, se procede a borrar los deployment asi:

kubectl delete -f drupal.yaml

>> Respuesta

 ``persistentvolumeclaim "drupal-claim" deleted

deployment.apps "drupal" deleted

service "drupal" deleted ``

Luego, la base de datos

kubectl delete -f postgres.yaml

 >> Respuesta

 ``persistentvolumeclaim "postgres-claim" deleted

deployment.apps "postgresql" deleted

service "postgresql" deleted ``