using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text.Json;
using System.Text;
using MongoDB.Driver;
using MongoDB.Bson;
using Microsoft.Extensions.Options;

namespace Security_Server.Controllers
{
    public class LoginController : Controller
    {
        private IMongoCollection<BsonDocument> _collection;
        private readonly JWT_Settings _jwtSettings;

        public LoginController(IOptions<JWT_Settings> jwtSettings)
        {
            _jwtSettings = jwtSettings.Value;
            string connectionString = "mongodb://localhost:27017";
            var client = new MongoClient(connectionString);
            var database = client.GetDatabase("Client_Information");
            var _collection = database.GetCollection<BsonDocument>("Login_Information");
        }

        [HttpPost("Login")]
        [AllowAnonymous]
        public IActionResult Login([FromBody] Kullanıcı kullanici)
        {
            var user = IdentityControl(kullanici);

            if (user == null)
            {
                return NotFound("Hatalı Giriş");
            }
            else
            {
                var token = CreateToken(user);
                return Ok(token);
            }

        }

        public string CreateToken(BsonDocument user)
        {
            if (_jwtSettings.Key == null)
            {
                throw new Exception("JWT KEY NULL OLMAMALI");
            }
            else
            {
                var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.Key));
                var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

                var claimDizisi = new[]
                {
            new Claim(ClaimTypes.NameIdentifier, "Deneme"),
            new Claim(ClaimTypes.Name, "Deneme2")
        };

                var token = new JwtSecurityToken(_jwtSettings.Issuer,

                    _jwtSettings.Audience,
                    claimDizisi,
                expires: DateTime.Now.AddHours(10),
                    signingCredentials: credentials);
                return new JwtSecurityTokenHandler().WriteToken(token);

            }
        }

        public BsonDocument IdentityControl(Kullanıcı kullanici)
        {
            var filter = Builders<BsonDocument>.Filter.Eq(kullanici.Email, "deneme@gmail.com");

            var documents = _collection.Find(filter).FirstOrDefault();
            
            return documents;

        }

    }
}
