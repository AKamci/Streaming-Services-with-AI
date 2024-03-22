using Main_Server.Datalayer.Services.Concrete;
using Main_Server.Infrastructure;
using Main_Server.Models;
using Microsoft.AspNetCore.Cors.Infrastructure;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;

namespace Main_Server.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly UserService _userService;
        private readonly JwtSettings _jwtSettings;

        public UsersController(UserService userService, IOptions<JwtSettings> jwtSettings)
        {
            _userService = userService;
            _jwtSettings = jwtSettings.Value;
        }

        [HttpPost]
        public IActionResult CreateAccount(string token)
        {
            var result = _userService.Create(token);

            return Ok(result.Result);
        }

        [HttpGet]
        public IActionResult GetAll()
        {
            var result = _userService.GetAll();
            var users = result.Result.Value;
            return Ok(users);
        }

        [HttpDelete]
        public IActionResult Delete(string id)
        {
            // Diğer serverda da silinmesi gerekiyor:...
            var result = _userService.Delete(id);
            var users = result.Result.Value;
            return Ok(users);
        }

        [HttpGet("{id}")]
        public IActionResult GetById(string id)
        {
            var result = _userService.GetById(id);
            var users = result.Result.Value;
            return Ok(users);
        }
    }

}
