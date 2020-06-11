package almoneya.http

import almoneya.Account
import com.fasterxml.jackson.core.JsonGenerator
import com.fasterxml.jackson.databind.{JsonSerializer, SerializerProvider}

class AccountSerializer extends JsonSerializer[Account] {
    override def serialize(account: Account, gen: JsonGenerator, serializers: SerializerProvider): Unit = {
        gen.writeStartObject()

        gen.writeObjectField("id", account.id)
        gen.writeObjectField("code", account.code)
        gen.writeObjectField("name", account.name)
        gen.writeObjectField("kind", account.kind)
        gen.writeObjectField("balance", account.balance)
        gen.writeBooleanField("virtual", account.virtual)

        gen.writeEndObject()
    }
}
