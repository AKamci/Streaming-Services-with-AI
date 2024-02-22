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
using MongoDB.Bson.Serialization.Conventions;
using MongoDB.Driver.Linq;
using Microsoft.AspNetCore.Http.HttpResults;

namespace Security_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly LoginService _loginService;
        private readonly JWT_Settings _jwtAyarlari;

        public LoginController(LoginService loginService, IOptions<JWT_Settings> jwtAyarlari)
        {
            _loginService = loginService;
            _jwtAyarlari = jwtAyarlari.Value;
        }

        [HttpPost]
        public async Task<IActionResult> Login(Kullanıcı kullanici)
        {
            var token = await _loginService.Giris(kullanici);

            if (token is null)
            {
                return NotFound("Kullanıcı Bulunamadı");
            }
            else
            {
                return Ok(token);
            }
            
        }      
    }
}
