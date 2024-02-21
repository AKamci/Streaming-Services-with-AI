using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Security_Server
{
    public class LoginService
    {

        private readonly IMongoCollection<Kullanıcı> _kullaniciCollection;

        public LoginService(
            IOptions<Client_InformationDatabaseSettings> client_informationDatabaseSettings)
        {
            var mongoClient = new MongoClient(
                client_informationDatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                client_informationDatabaseSettings.Value.DatabaseName);

            _kullaniciCollection = mongoDatabase.GetCollection<Kullanıcı>(
                client_informationDatabaseSettings.Value.BooksCollectionName);
        }

        public async Task<List<Kullanıcı>> GetAsync() =>
            await _kullaniciCollection.Find(_ => true).ToListAsync();

        public async Task<Kullanıcı?> GetAsync(string eposta) =>
            await _kullaniciCollection.Find(x => x.E_Posta == eposta).FirstOrDefaultAsync();

        public async Task CreateAsync(Kullanıcı newKullanıcı) =>
            await _kullaniciCollection.InsertOneAsync(newKullanıcı);

        public async Task UpdateAsync(string id, Kullanıcı updatedKullanıcı) =>
            await _kullaniciCollection.ReplaceOneAsync(x => x.Id == id, updatedKullanıcı);

        public async Task RemoveAsync(string id) =>
            await _kullaniciCollection.DeleteOneAsync(x => x.Id == id);
    }
}
