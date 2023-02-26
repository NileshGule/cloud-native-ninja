# Java Dapr modules

There are 2 Dapr modules based on the Java SDK.

## Build

These maven projects uses [Jib maven](https://github.com/GoogleContainerTools/jib/tree/master/jib-maven-plugin) to build repeatable
images.

To build using Jib, go to the maven project example: `techtalks-consumer/`

Followed by.

``` shell
mvn compile jib:build -D-Djib.to.image=myregistry/myimage:latest
```

