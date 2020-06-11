export MONGO_DBNAME=DB
export MONGO_URL=localhost
export MONGO_PORT=27017
export MONGO_USER=sample
export MANGO_PASS=sample
export DATABASE_DRIVER=org.postgresql.Driver
export DATABASE_URL=jdbc:postgresql://localhost:5432/sample
export DATABASE_USER=sample
export DATABASE_PASS=sample
export DATABASE_POOL_MIN=10
export DATABASE_POOL_MAX=50
export DATABASE_DIALECT=org.hibernate.dialect.PostgresPlusDialect

java -classpath sample-akka/target/sample-akka-0.0.1-SNAPSHOT.jar akka.kernel.Main fr.canal.vod.sample.akka.SampleBoot