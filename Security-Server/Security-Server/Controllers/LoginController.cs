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

namespace Security_Server.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class LoginController : ControllerBase
    {
        private readonly LoginService _loginService;

        public LoginController(LoginService loginService) =>
            _loginService = loginService;

        [HttpGet]
        public async Task<List<Kullanıcı>> Get() =>
            await _loginService.GetAsync();

        [HttpGet("{eposta:length(36)}")]
        public async Task<ActionResult<Kullanıcı>> Get(string eposta)
        {
            var kullanici = await _loginService.GetAsync(eposta);

            if (kullanici is null)
            {
                return NotFound();
            }

            return kullanici;
        }

        [HttpPost]
        public async Task<IActionResult> Post(Kullanıcı kullanici)
        {
            await _loginService.CreateAsync(kullanici);

            return CreatedAtAction(nameof(Get), new { id = kullanici.Id }, kullanici);
        }

        [HttpPut("{id:length(24)}")]
        public async Task<IActionResult> Update(string id, Kullanıcı updatedkullanici)
        {
            var kullanici = await _loginService.GetAsync(id);

            if (kullanici is null)
            {
                return NotFound();
            }

            updatedkullanici.Id = kullanici.Id;

            await _loginService.UpdateAsync(id, updatedkullanici);

            return NoContent();
        }

        [HttpDelete("{id:length(24)}")]
        public async Task<IActionResult> Delete(string id)
        {
            var kullanici = await _loginService.GetAsync(id);

            if (kullanici is null)
            {
                return NotFound();
            }

            await _loginService.RemoveAsync(id);

            return NoContent();
        }



    }
}
