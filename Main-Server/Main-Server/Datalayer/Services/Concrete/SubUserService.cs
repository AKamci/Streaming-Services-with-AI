using Main_Server.Datalayer.Context;
using Main_Server.Datalayer.Services.Abstract;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.Extensions.Options;
using MongoDB.Bson;
using MongoDB.Driver;
using System;
using System.Xml.Linq;
using static MongoDB.Bson.Serialization.Serializers.SerializerHelper;

namespace Main_Server.Datalayer.Services.Concrete
{
    public class SubUserService: UserService        
    {
        private readonly IMongoCollection<User> _usersCollection;
        private readonly JwtSettings _jwtsettings;

        public SubUserService(IOptions<Client_DatabaseSettings> client_DatabaseSettings, IOptions<JwtSettings> jwtsettings) : base(client_DatabaseSettings, jwtsettings)
        {
            var mongoClient = new MongoClient(
                 client_DatabaseSettings.Value.ConnectionString);

            var mongoDatabase = mongoClient.GetDatabase(
                client_DatabaseSettings.Value.DatabaseName);

            _usersCollection = mongoDatabase.GetCollection<User>(
                client_DatabaseSettings.Value.CollectionName);

            _jwtsettings = jwtsettings.Value;
        }

        public async Task<Result<User>> Add_SubUser(string id, SubUser subuser)
        {
           SubUser newSubUser = new SubUser();
           newSubUser = subuser;


            var _user =  await GetById(id);
           

            var user = _user.Value;

            int SubuserNumber = await RandomGenerate();

            newSubUser.UserId = user.Id.ToString();

            newSubUser.SubId = user.Id + "/" + SubuserNumber.ToString();


            var filter = Builders<User>.Filter.Eq(x => x.Id, id);
            var update = Builders<User>.Update.Push(x => x.SubUser, newSubUser);

            await _usersCollection.UpdateOneAsync(filter, update);

            var test = newSubUser.UserId;

            return Result<User>.Success(user, $"User number {id} has been updated.");
        }

        public async Task<int> RandomGenerate()
        {
            var random = new Random();
            int randomNumber = random.Next(1000);
            return randomNumber;
        }

        public async Task<Result<User>> Delete_SubUser(string id, string subId)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;

            var _subUser = await GetById_SubUser(id, subId);

            var subUser = _subUser.Value;

            var filter = Builders<User>.Filter.Eq(x => x.Id, id);
            var update = Builders<User>.Update.Pull(x => x.SubUser, subUser);

            await _usersCollection.UpdateOneAsync(filter, update);

            return Result<User>.Success(user, $"User number {id} has been updated.");
        }

        public async Task<Result<List<SubUser>>> Listed_All_SubUser(string id)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;

            var listUser = user.SubUser.ToList();

            return Result<List<SubUser>>.Success(listUser, $"User number {id} has been SubUser listed.");
        }

        public async Task<Result<SubUser>> GetById_SubUser(string id, string subId)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;

            var returnedSubUser = user.SubUser.Find(x => x.SubId == subId);

            return Result<SubUser>.Success(returnedSubUser, $"SubUser number {subId} has been listed.");

        }

        public async Task<Result<SubUser>> Update_SubUser(string id, string subId, SubUser newSubuser) 
        {
            SubUser subUser = new SubUser();

            var _user = GetById(id);

            var user = _user.Result.Value;

            subUser = newSubuser;

            var filter = Builders<User>.Filter.Where(x => x.Id == id && x.SubUser.Any(i => i.SubId == subId));
            var update = Builders<User>.Update.Set("SubUser.$", subUser); // $ operatörü son öğeyi ifade eder

            await _usersCollection.UpdateOneAsync(filter, update);


            return Result<SubUser>.Success(subUser, $"SubUser number {subId} has been uptade.");
        }


        

    }
}
