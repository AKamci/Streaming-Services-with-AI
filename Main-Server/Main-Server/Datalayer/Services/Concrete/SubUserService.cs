using Main_Server.Datalayer.Context;
using Main_Server.Datalayer.Services.Abstract;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;

namespace Main_Server.Datalayer.Services.Concrete
{
    public class SubUserService(IOptions<Client_DatabaseSettings> client_DatabaseSettings,
        IOptions<JwtSettings> jwtsettings) : UserService(client_DatabaseSettings, jwtsettings)
    {
        private readonly IMongoCollection<User> _usersCollection;

        public async Task<Result<User>> Add_SubUser(string id, SubUser subuser)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;

            subuser.MainId = id;

            user.SubUser.Add(subuser);

            await _usersCollection.ReplaceOneAsync(x => x.Id == id, user);

            return Result<User>.Success(user, $"User number {id} has been updated.");
        }

        public async Task<Result<User>> Delete_SubUser(string id, SubUser subuser)
        {
            var _user = GetById(id);

            var user = _user.Result.Value;

            user.SubUser.Remove(subuser);

            await _usersCollection.ReplaceOneAsync(x => x.Id == id, user);

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
            var _user = GetById(id);

            var _subUser = GetById_SubUser(id, subId);

            var subUser = _subUser.Result.Value;

            var user = _user.Result.Value;

            subUser = newSubuser;

            await _usersCollection.ReplaceOneAsync(x => x.Id == id, user);

            return Result<SubUser>.Success(subUser, $"SubUser number {subId} has been uptade.");
        }


    }
}
