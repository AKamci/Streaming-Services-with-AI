using MongoDB.Bson;

namespace Security_Server
{
    public class Kullanıcı
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string Password { get; set; }

    }
}
