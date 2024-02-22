using Microsoft.AspNetCore.Mvc;

namespace Security_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class RegisterController : ControllerBase
    {
        private readonly LoginService _loginService;
        private readonly AES_Keys _aesKey;
        public RegisterController(LoginService loginService, AES_Keys aesKey)
        {
            _loginService = loginService;
            _aesKey = aesKey;
        }

        [HttpPost]
        public async Task<IActionResult> Register(Kullanıcı kullanici)
        {
             
            string newPassword = kullanici.Password + kullanici.E_Posta;
            kullanici.Password = _loginService.AES_Encryption(newPassword, _aesKey.key, _aesKey.iv);

            await _loginService.CreateAsync(kullanici);

            return CreatedAtAction(nameof(Get), new { id = kullanici.Id }, kullanici);
        }

        [HttpGet]
        public async Task<ActionResult<Kullanıcı>> Get(string eposta)
        {
            var kullanici = await _loginService.GetMailAsync(eposta);

            if (kullanici is null)
            {
                return NotFound();
            }

            return kullanici;
        }
    }
}
