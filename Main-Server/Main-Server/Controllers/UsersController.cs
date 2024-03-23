using Main_Server.Datalayer.Services.Abstract;
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
        public async Task<IActionResult> CreateAccount(string token)
        {
            var result = await _userService.Create(token);

            return Ok(result);
        }

        [HttpGet]
        public async Task<IActionResult> GetAll()
        {
            var result = await _userService.GetAll();
            var users = result;
            return Ok(users);
        }

        [HttpDelete]
        public async Task<IActionResult> Delete(string id)
        {
            // Diğer serverda da silinmesi gerekiyor:...
            var result = await _userService.Delete(id);
            var users = result;
            return Ok(users);
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetById(string id)
        {
            var result = await _userService.GetById(id);
            var users = result;
            return Ok(users);
        }

        [HttpPut]
        public async Task<IActionResult> Update(string id, string email)
        {
            var result = await _userService.Update(id, email);



            var users = result;
            return Ok(users);
        }

    }

}
