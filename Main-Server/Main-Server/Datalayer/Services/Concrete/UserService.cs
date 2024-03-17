using Main_Server.Datalayer.Context;
using Main_Server.Datalayer.Services.Abstract;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.Extensions.Options;
using MongoDB.Driver;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;

namespace Main_Server.Datalayer.Services.Concrete
{
    public class UserService : IUserService
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
            
            user.Id = _id;
            user.Email = _mail;

            await _usersCollection.InsertOneAsync(user);
            return Result<User>.Success(user, "New User added.");
        }

        public (string _id, string _mail) DecodeToken(string token)
        {
            var handler = new JwtSecurityTokenHandler();
            var jwtSecurityToken = handler.ReadJwtToken(token);
            var payload = jwtSecurityToken.Payload;
            string _id = (string)payload["nameidentifier"];
            string _mail = (string)payload["name"];
            
            return (_id, _mail);
        }

        public async Task<Result<bool>> Delete(string id)
        {
           await _usersCollection.DeleteOneAsync(x => x.Id == id);
           return Result<bool>.Success(true, "User Deleted");
        }

        public async Task<Result<List<User>>> GetAll()
        {
            var returnedUser = await _usersCollection.Find(_ => true).ToListAsync();

            return Result<List<User>>.Success(returnedUser, "User listed.");
        }

        public async Task<Result<User>> GetById(string id)
        {
            var user = await _usersCollection.Find(x => x.Id == id).FirstOrDefaultAsync();

            if (user is null)
            {
                return Result<User>.Failure("User not found.");
            }

            return Result<User>.Success(user, "User found.");
        }



        //Diğer server ile anlaşmalı update edilmesi lazım.
        public Result<User> Update(User entity)
        {
            throw new NotImplementedException();
        }

       






    }
}
