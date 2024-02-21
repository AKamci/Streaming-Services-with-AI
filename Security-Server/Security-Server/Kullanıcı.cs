using MongoDB.Bson;
using MongoDB.Bson.Serialization.Attributes;

namespace Security_Server
{
    public class Kullanıcı
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string? Id { get; set; }

        [BsonElement("E_Posta")]
        public string E_Posta { get; set; } = null!;
        public string Password { get; set; } = null!;

    }
}
