using Amazon.Runtime.Internal.Util;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using MongoDB.Driver;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace Security_Server
{
    public class LoginService
    {

        private readonly IMongoCollection<Kullanıcı> _kullaniciCollection;
        private readonly JWT_Settings _jwtAyarlari;
        private readonly AES_Keys _aesKey;


        public LoginService(
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
        }

        public async Task<List<Kullanıcı>> GetAsync() =>
            await _kullaniciCollection.Find(_ => true).ToListAsync();

        public async Task<Kullanıcı?> GetAsync(string eposta, string password) =>
            await _kullaniciCollection.Find(x => x.E_Posta == eposta && x.Password==password).FirstOrDefaultAsync();

        public async Task<Kullanıcı?> GetMailAsync(string eposta) =>
            await _kullaniciCollection.Find(x => x.E_Posta == eposta).FirstOrDefaultAsync();

        public async Task CreateAsync(Kullanıcı newKullanıcı) =>
            await _kullaniciCollection.InsertOneAsync(newKullanıcı);
            

        public async Task UpdateAsync(string id, Kullanıcı updatedKullanıcı) =>
            await _kullaniciCollection.ReplaceOneAsync(x => x.Id == id, updatedKullanıcı);

        public async Task RemoveAsync(string id) =>
            await _kullaniciCollection.DeleteOneAsync(x => x.Id == id);

        public async Task<string>? Giris(Kullanıcı kullanıcı)
        {
            string newPassword = kullanıcı.Password + kullanıcı.E_Posta;

            kullanıcı.Password = AES_Encryption(newPassword,_aesKey.key,_aesKey.iv);

            var user = await KimlikDenetimiYapAsync(kullanıcı);

            if (user == null)
            {
                return null;
            }
            else
            {
                var token = TokenOlustur(user);
                return token;
            }
        }

        public string TokenOlustur(Kullanıcı user)
        {
            if (_jwtAyarlari.Key == null)
            {
                throw new Exception("JWT KEY NULL OLMAMALI");
            }
            else
            {
                var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtAyarlari.Key));
                var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

                var claimDizisi = new[]
                {
                    new Claim("UserID",$"{user.Id}"),
                    new Claim("UserEMail",$"{user.E_Posta}")
                };

                var token = new JwtSecurityToken(_jwtAyarlari.Issuer,

                    _jwtAyarlari.Audience,
                    claimDizisi,
                    expires: DateTime.Now.AddHours(1),
                    signingCredentials: credentials);

                return new JwtSecurityTokenHandler().WriteToken(token);

            }
        }

        public async Task<Kullanıcı>? KimlikDenetimiYapAsync(Kullanıcı kullanıcı)
        {
            var Donen_Kullanici = await GetAsync(kullanıcı.E_Posta, kullanıcı.Password);

            return Donen_Kullanici;
        }


        public string? AES_Encryption(string plainText, byte[] key, byte[] iv)
        {
            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;

                ICryptoTransform encryptor = aes.CreateEncryptor(aes.Key, aes.IV);

                using (MemoryStream msEncrypt = new MemoryStream())
                {
                    using (CryptoStream csEncrypt = new CryptoStream(msEncrypt, encryptor, CryptoStreamMode.Write))
                    {
                        using (StreamWriter swEncrypt = new StreamWriter(csEncrypt))
                        {
                            swEncrypt.Write(plainText);
                        }
                        return Convert.ToBase64String(msEncrypt.ToArray());
                    }
                }
            }
        }

        public string? AES_Decryption(string cipherText, byte[] key, byte[] iv)
        {
            byte[] cipherBytes = Convert.FromBase64String(cipherText);

            using (Aes aes = Aes.Create())
            {
                aes.Key = key;
                aes.IV = iv;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream msDecrypt = new MemoryStream(cipherBytes))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                        {
                            return srDecrypt.ReadToEnd();
                        }
                    }
                }
            }

        }








    }
}
