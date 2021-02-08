# java-logback-app

java-logback-app is a Java app that logs using logback.

## Installation

Build to run locally.

```
mvn clean package
mvn exec:java -Dexec.mainClass="com.newrelic.testapps.logback.Main"
```

Build to run in Kubernetes.

```
docker build -t crshanks/logback-app:1.0 .
```

Push to DockerHub:

```
docker push crshanks/logback-app:1.0
```


## Usage

Edit logback-app-deployment.yaml, adding your New Relic license key, then:

```
kubectl apply -f logback-app-deployment.yaml
kubectl delete -f logback-app-deployment.yaml
```

The app runs once, then exits, meaning that you will need to delete it to prevent k8s continuously restarting it.

```
kubectl delete -f logback-app-deployment.yaml
```