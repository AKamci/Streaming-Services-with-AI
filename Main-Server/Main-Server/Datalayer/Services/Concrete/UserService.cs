using Amazon.Runtime.Internal.Endpoints.StandardLibrary;
using Main_Server.Datalayer.Context;
using Main_Server.Datalayer.Services.Abstract;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.Extensions.Options;
using MongoDB.Bson;
using MongoDB.Driver;
using Newtonsoft.Json;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Security.Claims;
using System.Text;

namespace Main_Server.Datalayer.Services.Concrete
{
    public class UserService
    {
        private readonly IMongoCollection<User> _usersCollection;
        private readonly JwtSettings _jwtsettings;

        public UserService(IOptions<Client_DatabaseSettings> client_DatabaseSettings, IOptions<JwtSettings> jwtsettings)
        {
            var mongoClient = new MongoClient(
                 client_DatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                client_DatabaseSettings.Value.DatabaseName);

            _usersCollection = mongoDatabase.GetCollection<User>(
                client_DatabaseSettings.Value.CollectionName);

            _jwtsettings = jwtsettings.Value;
        }

        public async Task<Result<User>> Create(string token)
        {
            User user = new User();
            var _information = DecodeToken(token);
            
            string _id = _information._id;
            string _mail = _information._mail;

            //Eklenti
            ObjectId objectId;

            ObjectId.TryParse(_id, out objectId);

            user.Id = _id; // Normalde _id
            user.Email = _mail;

            await _usersCollection.InsertOneAsync(user);
            return Result<User>.Success(user, "New User added.");
        }

        public (string _id, string _mail) DecodeToken(string token)
        {
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(token);
            var payload = jwtSecurityToken.Payload;
            string _id = (string)payload["UserID"];
            string _mail = (string)payload["UserEMail"];

            Console.WriteLine(_id, _mail);
            
            return (_id, _mail);
        }

        public async Task<Result<bool>> Delete(string id)
        {
           await _usersCollection.DeleteOneAsync(x => x.Id.ToString() == id);
           return Result<bool>.Success(true, "User Deleted");
        }

        public async Task<Result<List<User>>> GetAll()
        {
            var returnedUser = await _usersCollection.Find(_ => true).ToListAsync();

            return Result<List<User>>.Success(returnedUser, "User listed.");
        }

        public async Task<Result<User>> GetById(string id)
        {
            var user = await _usersCollection.Find(x => x.Id.ToString() == id).FirstOrDefaultAsync();

            if (user is null)
            {
                return Result<User>.Failure("User not found.");
            }

            return Result<User>.Success(user, "User found.");
        }

        public async Task<Result<User>> Update(string id, string email)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;
            string secretKey = "guyayscdsanjhsadvbkjlshdcbavsgdchbnsbcdgavh";
            string oldEmail = user.Email;
            var filter = Builders<User>.Filter.Eq(u => u.Email, user.Email);
           
            user.Email = email;

            var update = Builders<User>.Update.Set(u => u.Email, user.Email);

            // Kullanıcıyı güncelleyin
            await _usersCollection.UpdateOneAsync(filter, update);

            // POST isteği için URL'yi oluşturun
            string url = "https://localhost:44385/api/Server";

            // Gönderilecek verileri oluşturun
            var data = new
            {
                newEmail = email,
                oldEmail = oldEmail,
                secretKey = "guyayscdsanjhsadvbkjlshdcbavsgdchbnsbcdgavh"
            };

            // JSON formatında veri göndermek için Content-Type header'ı ekleyin
            var client = new HttpClient();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));

            // POST isteği oluşturun ve verileri ekleyin
            var request = new HttpRequestMessage(HttpMethod.Post, url);
            request.Content = new StringContent(JsonConvert.SerializeObject(data), Encoding.UTF8, "application/json");

            // POST isteğini gönderin ve cevabı alın
            var response = await client.SendAsync(request);

            // Cevabın durum kodunu kontrol edin
            if (response.IsSuccessStatusCode)
            {
                // Başarılıysa, cevabı yazdırın
                Console.WriteLine("Başarılı!");
                Console.WriteLine(await response.Content.ReadAsStringAsync());
            }
            else
            {
                // Başarısızsa, hata mesajını yazdırın
                Console.WriteLine("Hata!");
                Console.WriteLine(await response.Content.ReadAsStringAsync());
            }



            return Result<User>.Success(user, "User Updated");

        }

       






    }
}
