using MongoDB.Bson.Serialization.Attributes;
using MongoDB.Bson;

namespace Main_Server.Models
{
    public class User
    {
        [BsonId]
        [BsonRepresentation(BsonType.ObjectId)]
        public string Id { get; set; }

        public string Email { get; set; }

        public List<SubUser> SubUser { get; set; }    
        
    }
}
