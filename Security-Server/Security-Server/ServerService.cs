using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Security_Server
{
    public class ServerService
    {
        private readonly IMongoCollection<Kullanıcı> _kullaniciCollection;
        private readonly JWT_Settings _jwtAyarlari;
        private readonly AES_Keys _aesKey;
        private readonly string secretKey;


        public ServerService(
            IOptions<Client_InformationDatabaseSettings> client_informationDatabaseSettings, IOptions<JWT_Settings> jwtAyarlari, AES_Keys aesKey)
        {
            var mongoClient = new MongoClient(
                client_informationDatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                client_informationDatabaseSettings.Value.DatabaseName);

            _kullaniciCollection = mongoDatabase.GetCollection<Kullanıcı>(
                client_informationDatabaseSettings.Value.BooksCollectionName);

            _jwtAyarlari = jwtAyarlari.Value;
            _aesKey = aesKey;
            secretKey = "guyayscdsanjhsadvbkjlshdcbavsgdchbnsbcdgavh";
        }


        public async Task<UpdateResult>? Update_Email(string newEmail, string oldEmail, string _secretKey)
        {
            if (secretKey == _secretKey)
            {
                var filter = Builders<Kullanıcı>.Filter.Eq("E_Posta", oldEmail);
                var update = Builders<Kullanıcı>.Update.Set(x => x.E_Posta, newEmail);
                var result = await _kullaniciCollection.UpdateOneAsync(filter, update);
                return result;
            }
            return null;
            
        }
    }
}
